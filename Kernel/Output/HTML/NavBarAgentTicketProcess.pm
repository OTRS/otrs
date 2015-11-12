# --
# Kernel/Output/HTML/NavBarAgentTicketProcess.pm - to show or hide AgentTicketProcess menu item
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::NavBarAgentTicketProcess;

use strict;
use warnings;

use Kernel::System::ProcessManagement::Activity;
use Kernel::System::ProcessManagement::ActivityDialog;
use Kernel::System::ProcessManagement::Process;
use Kernel::System::ProcessManagement::Transition;
use Kernel::System::ProcessManagement::TransitionAction;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Cache',
    'Kernel::System::DB',
    'Kernel::System::Encode',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::Ticket',
    'Kernel::System::Time',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for (qw( LayoutObject UserID )) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    # get needed objects
    $Self->{ConfigObject} //= $Kernel::OM->Get('Kernel::Config');
    $Self->{CacheObject}  //= $Kernel::OM->Get('Kernel::System::Cache');
    $Self->{DBObject}     //= $Kernel::OM->Get('Kernel::System::DB');
    $Self->{LogObject}    //= $Kernel::OM->Get('Kernel::System::Log');
    $Self->{TimeObject}   //= $Kernel::OM->Get('Kernel::System::Time');
    $Self->{MainObject}   //= $Kernel::OM->Get('Kernel::System::Main');
    $Self->{EncodeObject} //= $Kernel::OM->Get('Kernel::System::Encode');
    $Self->{TicketObject} //= $Kernel::OM->Get('Kernel::System::Ticket');

    # get the cache TTL (in seconds)
    $Self->{CacheTTL} = int( $Self->{ConfigObject}->Get('Process::NavBar::CacheTTL') || 900 );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get process management configuration
    my $FrontendModuleConfig = $Self->{ConfigObject}->Get('Frontend::Module')->{AgentTicketProcess};

    # check if the registration config is valid
    return if !IsHashRefWithData($FrontendModuleConfig);
    return if !IsHashRefWithData( $FrontendModuleConfig->{NavBar}->[0] );

    my $NameForID = $FrontendModuleConfig->{NavBar}->[0]->{Name};
    $NameForID =~ s/[ &;]//ig;

    # check if the module name is valid
    return if !$NameForID;

    my $DisplayMenuItem;

    # check the cache
    my $CacheKey = 'ProcessManagement::UserID' . $Self->{UserID} . '::DisplayMenuItem';

    my $Cache = $Self->{CacheObject}->Get(
        Type => 'ProcessManagement_Process',
        Key  => $CacheKey,
    );

    # set the cache value to show or hide the menu item (if value exists)
    if ( $Cache && ref $Cache eq 'SCALAR' ) {
        $DisplayMenuItem = ${$Cache};
    }

    # otherwise determine the value by quering the process object
    else {

        # create objects (only create objects if no cache, to increse performance)
        $Self->{ActivityObject}         = Kernel::System::ProcessManagement::Activity->new( %{$Self} );
        $Self->{ActivityDialogObject}   = Kernel::System::ProcessManagement::ActivityDialog->new( %{$Self} );
        $Self->{TransitionActionObject} = Kernel::System::ProcessManagement::TransitionAction->new( %{$Self} );
        $Self->{TransitionObject}       = Kernel::System::ProcessManagement::Transition->new( %{$Self} );
        $Self->{ProcessObject}          = Kernel::System::ProcessManagement::Process->new(
            %{$Self},
            ActivityObject         => $Self->{ActivityObject},
            ActivityDialogObject   => $Self->{ActivityDialogObject},
            TransitionObject       => $Self->{TransitionObject},
            TransitionActionObject => $Self->{TransitionActionObject},
        );

        $DisplayMenuItem = 0;
        my $Processes = $Self->{ConfigObject}->Get('Process');

        # avoid error messages when there is no processes and call ProcessList
        if ( IsHashRefWithData($Processes) ) {

            # get process list
            my $ProcessList = $Self->{ProcessObject}->ProcessList(
                ProcessState => ['Active'],
                Interface    => ['AgentInterface'],
            );

            # prepare process list for ACLs, use only entities instead of names, convert from
            #   P1 => Name to P1 => P1. As ACLs should work only against entities
            my %ProcessListACL = map { $_ => $_ } sort keys %{$ProcessList};

            # validate the ProcessList with stored ACLs
            my $ACL = $Self->{TicketObject}->TicketAcl(
                ReturnType    => 'Process',
                ReturnSubType => '-',
                Data          => \%ProcessListACL,
                UserID        => $Self->{UserID},
            );

            if ( IsHashRefWithData($ProcessList) && $ACL ) {

                # get ACL results
                my %ACLData = $Self->{TicketObject}->TicketAclData();

                # recover process names
                my %ReducedProcessList = map { $_ => $ProcessList->{$_} } sort keys %ACLData;

                # replace original process list with the reduced one
                $ProcessList = \%ReducedProcessList;
            }

            # set the value to show or hide the menu item (based in process list)
            if ( IsHashRefWithData($ProcessList) ) {
                $DisplayMenuItem = 1;
            }
        }

        # set cache
        $Self->{CacheObject}->Set(
            Type  => 'ProcessManagement_Process',
            Key   => $CacheKey,
            Value => \$DisplayMenuItem,
            TTL   => $Self->{CacheTTL},
        );
    }

    # return nothing to display the menu item
    return if $DisplayMenuItem;

    # frontend module is enabled but there is no selectable process, then remove the menu entry
    my $NavBarName = $FrontendModuleConfig->{NavBarName};
    my $Priority = sprintf( "%07d", $FrontendModuleConfig->{NavBar}->[0]->{Prio} );

    my %Return = %{ $Param{NavBar}->{Sub} || {} };

    # remove AgentTicketProcess from the TicketMenu
    delete $Return{$NavBarName}->{$Priority};

    return ( Sub => \%Return );
}

1;
