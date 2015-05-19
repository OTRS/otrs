# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::Ticket::MenuProcess;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Output::HTML::NavBar::AgentTicketProcess',
    'Kernel::System::Log',
    'Kernel::Config',
    'Kernel::System::Ticket',
    'Kernel::System::Group',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get UserID param
    $Self->{UserID} = $Param{UserID} || die "Got no UserID!";

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get log object
    my $LogObject = $Kernel::OM->Get('Kernel::System::Log');

    # check needed stuff
    if ( !$Param{Ticket} ) {
        $LogObject->Log(
            Priority => 'error',
            Message  => 'Need Ticket!'
        );
        return;
    }

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # check if ticket is already enrolled into a process
    my $ProcessEntityID = $Param{Ticket}->{
        'DynamicField_'
            . $ConfigObject->Get('Process::DynamicFieldProcessManagementProcessID')
    } || '';
    return if $ProcessEntityID;

    # check if frontend module registered, if not, do not show action
    if ( $Param{Config}->{Action} ) {
        my $Module = $ConfigObject->Get('Frontend::Module')->{ $Param{Config}->{Action} };
        return if !$Module;
    }

    # check permission
    my $Config = $ConfigObject->Get("Ticket::Frontend::$Param{Config}->{Action}");
    if ($Config) {

        # get ticket object
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        if ( $Config->{Permission} ) {
            my $AccessOk = $TicketObject->TicketPermission(
                Type     => $Config->{Permission},
                TicketID => $Param{Ticket}->{TicketID},
                UserID   => $Self->{UserID},
                LogNo    => 1,
            );
            return if !$AccessOk;
        }
        if ( $Config->{RequiredLock} ) {
            if (
                $TicketObject->TicketLockGet( TicketID => $Param{Ticket}->{TicketID} )
                )
            {
                my $AccessOk = $TicketObject->OwnerCheck(
                    TicketID => $Param{Ticket}->{TicketID},
                    OwnerID  => $Self->{UserID},
                );
                return if !$AccessOk;
            }
        }
    }

    # group check
    if ( $Param{Config}->{Group} ) {

        my @Items = split /;/, $Param{Config}->{Group};

        my $AccessOk;
        ITEM:
        for my $Item (@Items) {

            my ( $Permission, $Name ) = split /:/, $Item;

            if ( !$Permission || !$Name ) {
                $LogObject->Log(
                    Priority => 'error',
                    Message  => "Invalid config for Key Group: '$Item'! "
                        . "Need something like '\$Permission:\$Group;'",
                );
            }

            my %Groups = $Kernel::OM->Get('Kernel::System::Group')->PermissionUserGet(
                UserID => $Self->{UserID},
                Type   => $Permission,
            );

            next ITEM if !%Groups;

            my %GroupsReverse = reverse %Groups;

            next ITEM if !$GroupsReverse{$Name};

            $AccessOk = 1;

            last ITEM;
        }

        return if !$AccessOk;
    }

    # check ACL
    if ( $Param{Config}->{Action} ) {
        my %ACLLookup = reverse( %{ $Param{ACL} || {} } );
        return if ( !$ACLLookup{ $Param{Config}->{Action} } );
    }

    # use the nav bar module to check for process ACLs to prevent code duplication
    $Kernel::OM->ObjectParamAdd(
        'Kernel::Output::HTML::NavBar::AgentTicketProcess' => {
            UserID => $Self->{UserID},
        },
    );
    my $NavBarModule = $Kernel::OM->Get('Kernel::Output::HTML::NavBar::AgentTicketProcess');

    # check process ACLs with the nav bar module (if returns something hide the menu item)
    return if $NavBarModule->Run();

    # return item
    return { %{ $Param{Config} }, %{ $Param{Ticket} }, %Param };
}

1;
