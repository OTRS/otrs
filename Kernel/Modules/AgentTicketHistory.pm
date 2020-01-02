# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Modules::AgentTicketHistory;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);
use Kernel::Language qw(Translatable);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # check needed stuff
    if ( !$Self->{TicketID} ) {

        # error page
        return $LayoutObject->ErrorScreen(
            Message => Translatable('Can\'t show history, no TicketID is given!'),
            Comment => Translatable('Please contact the administrator.'),
        );
    }

    # get ticket object
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    # check permissions
    if (
        !$TicketObject->TicketPermission(
            Type     => 'ro',
            TicketID => $Self->{TicketID},
            UserID   => $Self->{UserID},
        )
        )
    {

        # error screen, don't show ticket
        return $LayoutObject->NoPermission( WithHeader => 'yes' );
    }

    # get ACL restrictions
    my %PossibleActions = ( 1 => $Self->{Action} );

    my $ACL = $TicketObject->TicketAcl(
        Data          => \%PossibleActions,
        Action        => $Self->{Action},
        TicketID      => $Self->{TicketID},
        ReturnType    => 'Action',
        ReturnSubType => '-',
        UserID        => $Self->{UserID},
    );
    my %AclAction = $TicketObject->TicketAclActionData();

    # check if ACL restrictions exist
    if ( $ACL || IsHashRefWithData( \%AclAction ) ) {

        my %AclActionLookup = reverse %AclAction;

        # show error screen if ACL prohibits this action
        if ( !$AclActionLookup{ $Self->{Action} } ) {
            return $LayoutObject->NoPermission( WithHeader => 'yes' );
        }
    }

    my %Ticket = $TicketObject->TicketGet( TicketID => $Self->{TicketID} );

    my @Lines = $TicketObject->HistoryGet(
        TicketID => $Self->{TicketID},
        UserID   => $Self->{UserID},
    );
    my $Tn = $TicketObject->TicketNumberLookup( TicketID => $Self->{TicketID} );

    # get shown user info
    if ( $Kernel::OM->Get('Kernel::Config')->Get('Ticket::Frontend::HistoryOrder') eq 'reverse' ) {
        @Lines = reverse(@Lines);
    }

    # Get mapping of history types to readable strings
    my %HistoryTypes;
    my %HistoryTypeConfig = %{ $Kernel::OM->Get('Kernel::Config')->Get('Ticket::Frontend::HistoryTypes') // {} };
    for my $Entry ( sort keys %HistoryTypeConfig ) {
        %HistoryTypes = (
            %HistoryTypes,
            %{ $HistoryTypeConfig{$Entry} },
        );
    }

    my $UserObject = $Kernel::OM->Get('Kernel::System::User');

    my $Time;

    for my $Data (@Lines) {
        $Data->{Class} = '';

        my $HistoryArticleTime = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                String => $Data->{CreateTime},
            }
        )->ToEpoch();

        my $IsNewWidget;

        # Create a new widget if article create time difference is more then 5 sec.
        if ( !$Time || abs( $Time - $HistoryArticleTime ) > 5 ) {

            $LayoutObject->Block(
                Name => 'HistoryWidget',
                Data => {
                    CreateTime => $Data->{CreateTime},
                },
            );

            $Time        = $HistoryArticleTime;
            $IsNewWidget = 1;

        }

        # replace text
        if ( $Data->{Name} && $Data->{Name} =~ m/^%%/x ) {
            $Data->{Name} =~ s/^%%//xg;
            my @Values = split( /%%/x, $Data->{Name} );

            # Rebuild some of the values for history entries so they have more speaking form. This is necessary because
            #   values stored previously in older format might not be compatible with new human readable form.
            #   Please see bug#11520 for more information.
            #
            # HistoryType: TicketDynamicFieldUpdate
            #   - Old: %%FieldName%%$FieldName%%Value%%$HistoryValue%%OldValue%%$HistoryOldValue
            #   - New: %%$FieldName%%$HistoryOldValue%%$HistoryValue
            if ( $Data->{HistoryType} eq 'TicketDynamicFieldUpdate' ) {
                @Values = ( $Values[1], $Values[5] // '', $Values[3] // '' );
            }

            # Make sure that the order of the values is correct, because we're now
            #   also showing the old ticket type on 'TypeUpdate'.
            elsif ( $Data->{HistoryType} eq 'TypeUpdate' ) {
                @Values = ( $Values[2] // '', $Values[3] // '', $Values[0], $Values[1] );
            }

            $Data->{Name} = $LayoutObject->{LanguageObject}->Translate(
                $HistoryTypes{ $Data->{HistoryType} },
                @Values,
            );

            # remove not needed place holder
            $Data->{Name} =~ s/\%s//xg;
        }
        else {
            $Data->{Name} = $LayoutObject->{LanguageObject}->Translate(
                $Data->{Name}
            );
        }

        $LayoutObject->Block(
            Name => 'Row',
            Data => $Data,
        );
    }

    # build page
    my $Output = $LayoutObject->Header(
        Value => $Tn,
        Type  => 'Small',
    );
    $Output .= $LayoutObject->Output(
        TemplateFile => 'AgentTicketHistory',
        Data         => {
            TicketNumber => $Tn,
            TicketID     => $Self->{TicketID},
            Title        => $Ticket{Title},
        },
    );
    $Output .= $LayoutObject->Footer(
        Type => 'Small',
    );

    return $Output;
}

1;
