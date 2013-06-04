# --
# Kernel/System/PostMaster/Filter/ExternalTicketNumberRecognition.pm - Recognize incoming emails as followups
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::PostMaster::Filter::ExternalTicketNumberRecognition;

use strict;
use warnings;

use Kernel::System::State;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.10 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    $Self->{Debug} = $Param{Debug} || 0;

    # get needed objects
    for my $Object (
        qw(DBObject ConfigObject LogObject MainObject EncodeObject TicketObject TimeObject)
        )
    {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }

    # create additional objects
    $Self->{StateObject} = Kernel::System::State->new(%Param);

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # checking mandatory configuration options
    for my $Option (qw(NumberRegExp DynamicFieldName SenderType ArticleType)) {
        if ( !defined $Param{JobConfig}->{$Option} && !$Param{JobConfig}->{$Option} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Missing configuration for $Option for postmaster filter.",
            );
            return 1;
        }
    }

    if ( $Self->{Debug} >= 1 ) {
        $Self->{LogObject}->Log(
            Priority => 'debug',
            Message  => "starting Filter $Param{JobConfig}->{Name}",
        );
    }

    # check if sender is of interest
    return 1 if !$Param{GetParam}->{From};
    if ( defined $Param{JobConfig}->{FromAddressRegExp} && $Param{JobConfig}->{FromAddressRegExp} )
    {
        if ( $Param{GetParam}->{From} !~ /$Param{JobConfig}->{FromAddressRegExp}/i ) {
            return 1;
        }
    }

    # search in the subject
    if ( $Param{JobConfig}->{SearchInSubject} ) {

        # try to get external ticket number from email subject
        my @SubjectLines = split /\n/, $Param{GetParam}->{Subject};
        LINE:
        for my $Line (@SubjectLines) {
            if ( $Line =~ m{ $Param{JobConfig}->{NumberRegExp} }msx ) {
                $Self->{Number} = $1;
                last LINE;
            }
        }

        if ( $Self->{Number} ) {
            if ( $Self->{Debug} >= 1 ) {
                $Self->{LogObject}->Log(
                    Priority => 'debug',
                    Message  => "Found number: $Self->{Number} in subject",
                );
            }
        }
        else {
            if ( $Self->{Debug} >= 1 ) {
                $Self->{LogObject}->Log(
                    Priority => 'debug',
                    Message  => 'No number found in subject.',
                );
            }
        }
    }

    # search in the body
    if ( $Param{JobConfig}->{SearchInBody} ) {

        # split the body into separate lines
        my @BodyLines = split /\n/, $Param{GetParam}->{Body};

        # traverse lines and return first match
        LINE:
        for my $Line (@BodyLines) {
            if ( $Line =~ m{ $Param{JobConfig}->{NumberRegExp} }msx ) {

                # get the found element value
                $Self->{Number} = $1;
                last LINE;
            }
        }
    }

    # we need to have found an external number to proceed.
    if ( !$Self->{Number} ) {
        if ( $Self->{Debug} >= 1 ) {
            $Self->{LogObject}->Log(
                Priority => 'debug',
                Message  => 'Could not find external ticket number => Ignoring',
            );
        }
        return 1;
    }
    else {
        if ( $Self->{Debug} >= 1 ) {
            $Self->{LogObject}->Log(
                Priority => 'debug',
                Message  => "Found number $Self->{Number}",
            );
        }
    }

    # Is there a ticket for this ticket number?
    my %Query = (
        Result => 'ARRAY',
        Limit  => 1,
        UserID => 1,
    );

    # check if we should only find the ticket number in tickets with a given state type
    if ( defined $Param{JobConfig}->{TicketStateTypes} && $Param{JobConfig}->{TicketStateTypes} ) {

        $Query{StateTypeIDs} = [];
        my @StateTypeIDs;

        # if StateTypes contains semicolons, use that for split,
        # otherwise split on spaces (for compat)
        if ( $Param{JobConfig}->{TicketStateTypes} =~ m{;} ) {
            @StateTypeIDs = split ';', $Param{JobConfig}->{TicketStateTypes};
        }
        else {
            @StateTypeIDs = split ' ', $Param{JobConfig}->{TicketStateTypes};
        }
        STATETYPE:
        for my $StateType (@StateTypeIDs) {

            next STATETYPE if !$StateType;

            my $StateTypeID = $Self->{StateObject}->StateTypeLookup(
                StateType => $StateType,
            );

            if ($StateTypeID) {
                push @{ $Query{StateTypeIDs} }, $StateTypeID;
            }
        }
    }

    # dynamic field search condition
    $Query{ 'DynamicField_' . $Param{JobConfig}->{'DynamicFieldName'} } = {
        Equals => $Self->{Number},
    };

    # search tickets
    my @TicketIDs = $Self->{TicketObject}->TicketSearch(%Query);

    # get the first and only ticket id
    my $TicketID = shift @TicketIDs;

    # OK, found ticket to deal with
    if ($TicketID) {

        # get ticket number
        my $TicketNumber = $Self->{TicketObject}->TicketNumberLookup(
            TicketID => $TicketID,
            UserID   => 1,
        );

        if ( $Self->{Debug} >= 1 ) {
            $Self->{LogObject}->Log(
                Priority => 'debug',
                Message =>
                    "Found ticket $TicketNumber open for external number $Self->{Number}. Updating.",
            );
        }

        # build subject
        $Param{GetParam}->{Subject} = $Self->{TicketObject}->TicketSubjectBuild(
            TicketNumber => $TicketNumber,
            Subject      => $Param{GetParam}->{Subject},
        );

        # set sender type and article type
        $Param{GetParam}->{'X-OTRS-FollowUp-SenderType'}  = $Param{JobConfig}->{SenderType};
        $Param{GetParam}->{'X-OTRS-FollowUp-ArticleType'} = $Param{JobConfig}->{ArticleType};

    }
    else {
        if ( $Self->{Debug} >= 1 ) {
            $Self->{LogObject}->Log(
                Priority => 'debug',
                Message  => "Creating new ticket for external ticket $Self->{Number}",
            );
        }

        # get the dynamic field name and description from JobConfig, set as headers
        my $TicketDynamicFieldName = $Param{JobConfig}->{'DynamicFieldName'};
        $Param{GetParam}->{ 'X-OTRS-DynamicField-' . $TicketDynamicFieldName } = $Self->{Number};

        # set sender type and article type
        $Param{GetParam}->{'X-OTRS-SenderType'}  = $Param{JobConfig}->{SenderType};
        $Param{GetParam}->{'X-OTRS-ArticleType'} = $Param{JobConfig}->{ArticleType};
    }

    return 1;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut

=head1 VERSION

$Revision: 1.10 $ $Date: 2012/09/12 12:15:11 $

=cut
