# --
# TicketStateSet.t - TicketStateSet testscript
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

## no critic (Modules::RequireExplicitPackage)
use strict;
use warnings;
use utf8;
use vars qw($Self);

use Kernel::Config;
use Kernel::System::Ticket;
use Kernel::System::User;
use Kernel::System::UnitTest::Helper;
use Kernel::System::ProcessManagement::TransitionAction::TicketStateSet;

use Kernel::System::VariableCheck qw(:all);

# create local objects
my $HelperObject = Kernel::System::UnitTest::Helper->new(
    %{$Self},
    UnitTestObject             => $Self,
    RestoreSystemConfiguration => 0,
);

$HelperObject->FixedTimeSet();

my $ConfigObject = $Kernel::OM->Get('ConfigObject');
my $UserObject   = Kernel::System::User->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);
my $TicketObject = Kernel::System::Ticket->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);

my $ModuleObject = Kernel::System::ProcessManagement::TransitionAction::TicketStateSet->new(
    %{$Self},
    ConfigObject => $ConfigObject,
    TicketObject => $TicketObject,
);

# define variables
my $UserID     = 1;
my $ModuleName = 'TicketStateSet';
my $RandomID   = $HelperObject->GetRandomID();

# set user details
my $TestUserLogin = $HelperObject->TestUserCreate();
my $TestUserID    = $UserObject->UserLookup(
    UserLogin => $TestUserLogin,
);

# ----------------------------------------
# Create a test ticket
# ----------------------------------------
my $TicketID = $TicketObject->TicketCreate(
    TN            => undef,
    Title         => 'open',
    QueueID       => 1,
    Lock          => 'unlock',
    Priority      => '3 normal',
    StateID       => 1,
    TypeID        => 1,
    Service       => undef,
    SLA           => undef,
    CustomerID    => undef,
    CustomerUser  => undef,
    OwnerID       => 1,
    ResponsibleID => 1,
    ArchiveFlag   => undef,
    UserID        => $UserID,
);

# sanity checks
$Self->True(
    $TicketID,
    "TicketCreate() - $TicketID",
);

my %Ticket = $TicketObject->TicketGet(
    TicketID => $TicketID,
    UserID   => $UserID,
);
$Self->True(
    IsHashRefWithData( \%Ticket ),
    "TicketGet() - Get Ticket with ID $TicketID.",
);

# ----------------------------------------

# Run() tests
my @Tests = (
    {
        Name    => 'No Params',
        Config  => undef,
        Success => 0,
    },
    {
        Name   => 'No UserID',
        Config => {
            UserID => undef,
            Ticket => \%Ticket,
            Config => {
                CustomerID => 'test',
            },
        },
        Success => 0,
    },
    {
        Name   => 'No Ticket',
        Config => {
            UserID => $UserID,
            Ticket => undef,
            Config => {
                CustomerID => 'test',
            },
        },
        Success => 0,
    },
    {
        Name   => 'No Config',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {},
        },
        Success => 0,
    },
    {
        Name   => 'Wrong Config',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {
                NoAgentNotify => 0,
            },
        },
        Success => 0,
    },
    {
        Name   => 'Wrong Ticket Format',
        Config => {
            UserID => $UserID,
            Ticket => 1,
            Config => {
                State => 'open',
            },
        },
        Success => 0,
    },
    {
        Name   => 'Wrong Config Format',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => 1,
        },
        Success => 0,
    },
    {
        Name   => 'Wrong State',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {
                State => 'NotExisting' . $RandomID,
            },
        },
        Success => 0,
    },
    {
        Name   => 'Wrong StateID',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {
                StateID => 'NotExisting' . $RandomID,
            },
        },
        Success => 0,
    },
    {
        Name   => 'Correct State open',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {
                State => 'open',
            },
        },
        Success => 1,
    },
    {
        Name   => 'Correct State closed successful',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {
                State => 'closed successful',
            },
        },
        Success => 1,
    },
    {
        Name   => 'Correct StateID open',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {
                StateID => 4,
            },
        },
        Success => 1,
    },
    {
        Name   => 'Correct StateID closed successful',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {
                StateID => 2,
            },
        },
        Success => 1,
    },
    {
        Name   => 'Correct StateID pending',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {
                State           => 'pending reminder',
                PendingTimeDiff => 3600,
            },
        },
        Success => 1,
    },
    {
        Name   => 'Correct Ticket->Title',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {
                State => '<OTRS_Ticket_Title>',
            },
        },
        Success => 1,
    },
    {
        Name   => 'Correct Ticket->NotExisting',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {
                State => '<OTRS_Ticket_NotExisting>',
            },
        },
        Success => 0,
    },
    {
        Name   => 'Correct Using Different UserID',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {
                State  => 'open',
                UserID => $TestUserID,
            },
        },
        Success => 1,
    },
);

for my $Test (@Tests) {

    # make a deep copy to avoid changing the definition
    my $OrigTest = Storable::dclone($Test);

    my $Success = $ModuleObject->Run(
        %{ $Test->{Config} },
        ProcessEntityID          => 'P1',
        ActivityEntityID         => 'A1',
        TransitionEntityID       => 'T1',
        TransitionActionEntityID => 'TA1',
    );

    if ( $Test->{Success} ) {

        $Self->True(
            $Success,
            "$ModuleName Run() - Test:'$Test->{Name}' | excecuted with True"
        );

        # get ticket
        %Ticket = $TicketObject->TicketGet(
            TicketID => $TicketID,
            UserID   => 1,
        );

        ATTRIBUTE:
        for my $Attribute ( sort keys %{ $Test->{Config}->{Config} } ) {

            next ATTRIBUTE if $Attribute eq 'PendingTimeDiff';

            $Self->True(
                $Ticket{$Attribute},
                "$ModuleName - Test:'$Test->{Name}' | Attribute: $Attribute for TicketID:"
                    . " $TicketID exists with True",
            );

            my $ExpectedValue = $Test->{Config}->{Config}->{$Attribute};
            if (
                $OrigTest->{Config}->{Config}->{$Attribute}
                =~ m{\A<OTRS_Ticket_([A-Za-z0-9_]+)>\z}msx
                )
            {
                $ExpectedValue = $Ticket{$1} // '';
                $Self->IsNot(
                    $Test->{Config}->{Config}->{$Attribute},
                    $OrigTest->{Config}->{Config}->{$Attribute},
                    "$ModuleName - Test:'$Test->{Name}' | Attribute: $Attribute value: $OrigTest->{Config}->{Config}->{$Attribute} should been replaced",
                );
            }

            $Self->Is(
                $Ticket{$Attribute},
                $ExpectedValue,
                "$ModuleName - Test:'$Test->{Name}' | Attribute: $Attribute for TicketID:"
                    . " $TicketID match expected value",
            );
            if ( $Test->{Config}->{Config}->{PendingTimeDiff} ) {
                $Self->Is(
                    $Ticket{UntilTime},
                    $Test->{Config}->{Config}->{PendingTimeDiff},
                    "$ModuleName - Test:'$Test->{Name}' | Attribute: UntilTime for TicketID:"
                        . " $TicketID match expected value",

                );
            }
        }
        if ( $OrigTest->{Config}->{Config}->{UserID} ) {
            $Self->Is(
                $Test->{Config}->{Config}->{UserID},
                undef,
                "$ModuleName - Test:'$Test->{Name}' | Attribute: UserID for TicketID:"
                    . " $TicketID should be removed (as it was used)",
            );
        }
    }
    else {
        $Self->False(
            $Success,
            "$ModuleName Run() - Test:'$Test->{Name}' | executed with False"
        );
    }
}

#-----------------------------------------
# Destructors to remove our Testitems
# ----------------------------------------

# Ticket
my $Delete = $TicketObject->TicketDelete(
    TicketID => $TicketID,
    UserID   => 1,
);
$Self->True(
    $Delete,
    "TicketDelete() - $TicketID",
);

# ----------------------------------------

1;
