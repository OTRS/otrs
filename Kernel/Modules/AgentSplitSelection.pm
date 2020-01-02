# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Modules::AgentSplitSelection;

use strict;
use warnings;

use Mail::Address;

our $ObjectManagerDisabled = 1;

use Kernel::Language qw(Translatable);
use Kernel::System::VariableCheck qw(:all);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get needed objects
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    # get the split related parameters
    $Param{TicketID}       = $ParamObject->GetParam( Param => 'TicketID' );
    $Param{ArticleID}      = $ParamObject->GetParam( Param => 'ArticleID' );
    $Param{LinkTicketID}   = $ParamObject->GetParam( Param => 'LinkTicketID' );
    $Param{SplitSelection} = $ParamObject->GetParam( Param => 'SplitSelection' ) || 0;

    # validation
    for my $Needed (qw(TicketID ArticleID LinkTicketID)) {
        if ( !$Param{$Needed} ) {
            $LayoutObject->FatalError( Message => "Got no $Needed!" );
        }
    }

    # ---------------------------------------------------------- #
    # ProcessSelection
    # ---------------------------------------------------------- #
    if ( $Self->{Subaction} eq 'ProcessSelection' ) {

        # determine the redirection target
        my $RedirectAction;
        my $URLExtension = '';

        #
        # Split Email-Ticket
        #
        if ( $Param{SplitSelection} eq 'EmailTicket' ) {

            $RedirectAction = 'AgentTicketEmail';
            $URLExtension   = ";TicketID=$Param{TicketID}";
        }

        #
        # Split Phone-Ticket
        #
        elsif ( $Param{SplitSelection} eq 'PhoneTicket' ) {

            $RedirectAction = 'AgentTicketPhone';
            $URLExtension   = ";TicketID=$Param{TicketID}";
        }

        #
        # Split Process-Ticket
        #
        elsif ( $Param{SplitSelection} eq 'ProcessTicket' ) {

            $RedirectAction = 'AgentTicketProcess';

            # check if we got a useful process id
            my $ProcessEntityID = $ParamObject->GetParam( Param => 'ProcessEntityID' );

            # only append the parameter if a process was selected before
            if ($ProcessEntityID) {
                $URLExtension = ";FirstActivityDialog=1;ProcessEntityID=$ProcessEntityID";
            }
        }

        #
        # No Split
        #
        else {
            # got a not supported split action or nothing was selected
            # return to the ticket zoom screen
            return $LayoutObject->Redirect(
                OP => "Action=AgentTicketZoom;TicketID=$Param{TicketID}",
            );
        }

        # redirect to the next split screen
        return $LayoutObject->Redirect(
            OP =>
                "Action=$RedirectAction;ArticleID=$Param{ArticleID};LinkTicketID=$Param{LinkTicketID}"
                . $URLExtension,
        );
    }

    # ---------------------------------------------------------- #
    # Split Selection Dialog
    # ---------------------------------------------------------- #

    # Get ACL restrictions.
    my %PossibleActions;
    my $Counter = 0;

    # Get all registered actions.
    if ( ref $ConfigObject->Get('Frontend::Module') eq 'HASH' ) {

        my %Actions = %{ $ConfigObject->Get('Frontend::Module') };

        # Only use those actions that start with 'Agent'.
        %PossibleActions = map { ++$Counter => $_ }
            grep { substr( $_, 0, length 'Agent' ) eq 'Agent' }
            sort keys %Actions;
    }

    my $ACL = $TicketObject->TicketAcl(
        Data          => \%PossibleActions,
        Action        => 'AgentTicketZoom',
        TicketID      => $Param{TicketID},
        ReturnType    => 'Action',
        ReturnSubType => '-',
        UserID        => $Self->{UserID},
    );

    my %AclAction = %PossibleActions;
    if ($ACL) {
        %AclAction = $TicketObject->TicketAclActionData();
    }

    my %AclActionLookup = reverse %AclAction;

    # Build split selection based on availability of corresponding registered modules and ACL restrictions.
    # See bug#13690 (https://bugs.otrs.org/show_bug.cgi?id=13690) and
    #   bug#13947 (https://bugs.otrs.org/show_bug.cgi?id=13947) respectively.
    my %SplitSelectionContent;
    if ( $ConfigObject->Get('Frontend::Module')->{AgentTicketPhone} && $AclActionLookup{AgentTicketPhone} ) {
        $SplitSelectionContent{PhoneTicket} = Translatable('Phone ticket');
    }
    if ( $ConfigObject->Get('Frontend::Module')->{AgentTicketEmail} && $AclActionLookup{AgentTicketEmail} ) {
        $SplitSelectionContent{EmailTicket} = Translatable('Email ticket');
    }

    # only display process tickets if active processes are available
    my $Processes = $ConfigObject->Get('Process');
    if ( IsHashRefWithData($Processes) ) {

        my $ProcessList = $Kernel::OM->Get('Kernel::System::ProcessManagement::Process')->ProcessList(
            ProcessState => ['Active'],
            Interface    => ['AgentInterface'],
        );

        if ( IsHashRefWithData($ProcessList) ) {

            # display the process ticket option
            $SplitSelectionContent{ProcessTicket} = Translatable('Process ticket');

            # reduce the processes based on the stored ACLs
            # prepare process list for ACLs, use only entities instead of names, convert from
            #   P1 => Name to P1 => P1. As ACLs should work only against entities
            my %ProcessListACL = map { $_ => $_ } sort keys %{$ProcessList};

            # validate the ProcessList with stored ACLs
            my $ACL = $TicketObject->TicketAcl(
                ReturnType    => 'Process',
                ReturnSubType => '-',
                Data          => \%ProcessListACL,
                UserID        => $Self->{UserID},
            );

            if ( IsHashRefWithData($ProcessList) && $ACL ) {

                # get ACL results
                my %ACLData = $TicketObject->TicketAclData();

                # recover process names
                my %ReducedProcessList = map { $_ => $ProcessList->{$_} } sort keys %ACLData;

                # replace original process list with the reduced one
                $ProcessList = \%ReducedProcessList;
            }

            # generate selection for the single available processes
            $Param{ProcessListStrg} = $LayoutObject->BuildSelection(
                Data        => $ProcessList,
                Name        => 'ProcessEntityID',
                ID          => 'ProcessEntityID',
                Class       => 'Modernize',
                Sort        => 'AlphanumericValue',
                Translation => 0,
            );
        }
    }

    $Param{SplitSelectionStrg} = $LayoutObject->BuildSelection(
        Data        => \%SplitSelectionContent,
        SelectedID  => 'PhoneTicket',
        Translation => 1,
        Name        => 'SplitSelection',
        ID          => 'SplitSelection',
        Class       => 'Modernize',
    );

    my $Output = $LayoutObject->Output(
        TemplateFile => 'AgentSplitSelection',
        Data         => \%Param,
    );
    return $LayoutObject->Attachment(
        ContentType => 'text/html; charset=' . $LayoutObject->{Charset},
        Content     => $Output || '',
        Type        => 'inline',
        NoCache     => 1,
    );
}

1;
