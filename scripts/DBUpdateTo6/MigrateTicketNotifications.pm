# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package scripts::DBUpdateTo6::MigrateTicketNotifications;    ## no critic

use strict;
use warnings;

use parent qw(scripts::DBUpdateTo6::Base);

our @ObjectDependencies = (
    'Kernel::System::DB',
    'Kernel::System::NotificationEvent',
);

=head1 NAME

scripts::DBUpdateTo6::MigrateTicketNotifications - Migrate ticket notification contents.

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
    my $Verbose  = $Param{CommandlineOptions}->{Verbose} || 0;

    # check if article_type table exists
    my $TableExists = $Self->TableExists(
        Table => 'article_type',
    );

    # Skip execution if article_type table is missing.
    if ( !$TableExists ) {
        print "\n        - Article types table missing, skipping...\n\n" if $Verbose;
        return 1;
    }

    # Collect data for further calculation of article type mapping.
    return if !$DBObject->Prepare(
        SQL => 'SELECT id, name FROM article_type',
    );

    my %ArticleTypes;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $ArticleTypes{ $Row[0] } = $Row[1];
    }

    return if !$DBObject->Prepare(
        SQL => 'SELECT id, name FROM communication_channel',
    );

    my %CommunicationChannels;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $CommunicationChannels{ $Row[1] } = $Row[0];
    }

    my $NotificationEventObject = $Kernel::OM->Get('Kernel::System::NotificationEvent');

    my %NotificationEventList = $NotificationEventObject->NotificationList(
        Type    => 'Ticket',
        Details => 1,
    );

    for my $NotificationEventID ( sort keys %NotificationEventList ) {

        my $UpdateNeeded = 0;

        # Check for ArticleTypeIDs and map those entries to new options:
        #   - IsVisibleForCustomer
        #   - CommunicationChannelID
        if ( $NotificationEventList{$NotificationEventID}->{Data}->{ArticleTypeID} ) {
            my $IsVisibleForCustomer;
            my @CommunicationChannelIDs;
            for my $ArticleTypeID ( @{ $NotificationEventList{$NotificationEventID}->{Data}->{ArticleTypeID} } ) {

                # Deduce customer visibility option. Set only if it's the same for all selected article type IDs.
                #   Otherwise, leave it undefined, so both types are considered.
                if (
                    $ArticleTypes{$ArticleTypeID}
                    && $ArticleTypes{$ArticleTypeID} =~ /(-ext|phone|fax|sms|webrequest)/i
                    )
                {
                    if ( !defined $IsVisibleForCustomer ) {
                        $IsVisibleForCustomer = 1;
                    }
                    else {
                        if ( !$IsVisibleForCustomer ) {
                            $IsVisibleForCustomer = undef;
                        }
                    }
                }
                elsif ( $ArticleTypes{$ArticleTypeID} ) {
                    if ( !defined $IsVisibleForCustomer ) {
                        $IsVisibleForCustomer = 0;
                    }
                    else {
                        if ($IsVisibleForCustomer) {
                            $IsVisibleForCustomer = undef;
                        }
                    }
                }

                # Deduce communication channel ID and save it.
                my $CommunicationChannelID;
                if ( $ArticleTypes{$ArticleTypeID} && $ArticleTypes{$ArticleTypeID} =~ /email-/i ) {
                    $CommunicationChannelID = $CommunicationChannels{Email};
                }
                elsif ( $ArticleTypes{$ArticleTypeID} && $ArticleTypes{$ArticleTypeID} =~ /phone/i ) {
                    $CommunicationChannelID = $CommunicationChannels{Phone};
                }
                elsif ( $ArticleTypes{$ArticleTypeID} && $ArticleTypes{$ArticleTypeID} =~ /chat-/i ) {
                    $CommunicationChannelID = $CommunicationChannels{Chat};
                }
                else {
                    $CommunicationChannelID = $CommunicationChannels{Internal};
                }
                if ( !grep { $_ eq $CommunicationChannelID } @CommunicationChannelIDs ) {
                    push @CommunicationChannelIDs, $CommunicationChannelID;
                }
            }

            delete $NotificationEventList{$NotificationEventID}->{Data}->{ArticleTypeID};
            $NotificationEventList{$NotificationEventID}->{Data}->{ArticleIsVisibleForCustomer}
                = [$IsVisibleForCustomer];
            $NotificationEventList{$NotificationEventID}->{Data}->{ArticleCommunicationChannelID}
                = \@CommunicationChannelIDs;

            $UpdateNeeded = 1;
        }

        # Check for transport-based NotificationArticleTypeIDs and convert them to IsVisibleForCustomer entries.
        if ( $NotificationEventList{$NotificationEventID}->{Data}->{NotificationArticleTypeID} ) {

            if ( $NotificationEventList{$NotificationEventID}->{Data}->{NotificationArticleTypeID}->[0] == 3 ) {
                $NotificationEventList{$NotificationEventID}->{Data}->{IsVisibleForCustomer} = ['on'];
            }
            delete $NotificationEventList{$NotificationEventID}->{Data}->{NotificationArticleTypeID};

            $UpdateNeeded = 1;
        }

        # Update notification entries if needed.
        if ($UpdateNeeded) {
            $NotificationEventObject->NotificationUpdate(
                %{ $NotificationEventList{$NotificationEventID} },
                UserID               => 1,
                PossibleEmptyMessage => 1,
            );
        }
    }

    return 1;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
