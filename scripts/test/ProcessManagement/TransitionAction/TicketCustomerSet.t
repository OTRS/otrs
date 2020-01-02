# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

use Kernel::System::VariableCheck qw(:all);

my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
my $ModuleObject = $Kernel::OM->Get('Kernel::System::ProcessManagement::TransitionAction::TicketCustomerSet');

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my ( $TestUserLogin, $TestUserID ) = $Helper->TestUserCreate();
my $UserID     = $TestUserID;
my $ModuleName = 'TicketCustomerSet';

# Create a test ticket.
my $TicketID = $TicketObject->TicketCreate(
    Title         => 'test',
    QueueID       => 1,
    Lock          => 'unlock',
    Priority      => '3 normal',
    StateID       => 1,
    TypeID        => 1,
    OwnerID       => 1,
    ResponsibleID => 1,
    UserID        => $UserID,
);

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
                CustomerID => 'test',
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
        Name   => 'Correct ASCII CustomerID',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {
                CustomerID => 'test',
            },
        },
        Success => 1,
    },
    {
        Name   => 'Correct ASCII CustomerUserID',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {
                CustomerID => 'test',
            },
        },
        Success => 1,
    },
    {
        Name   => 'Correct ASCII No',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {
                No => 'test',
            },
        },
        Success => 1,
    },
    {
        Name   => 'Correct ASCII User',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {
                User => '#',
            },
        },
        Success => 1,
    },
    {
        Name   => 'Correct UTF8 CustomerID',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {
                CustomerID =>
                    'äöüßÄÖÜ€исáéíúóúÁÉÍÓÚñÑ-カスタ-用迎使用-Язык',
            },
        },
        Success => 1,
    },
    {
        Name   => 'Correct UTF8 CustomerUserID',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {
                CustomerUserID =>
                    'äöüßÄÖÜ€исáéíúóúÁÉÍÓÚñÑ-カスタ-用迎使用-Язык',
            },
        },
        Success => 1,
    },
    {
        Name   => 'Correct Ticket->Queue',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {
                CustomerUserID => '<OTRS_TICKET_Queue>',
            },
        },
        Success => 1,
    },
    {
        Name   => 'Wrong Ticket->NotExisting',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {
                CustomerUserID => '<OTRS_TICKET_NotExisting>',
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
                CustomerID => 'test',
                UserID     => $TestUserID,
            },
        },
        Success => 1,
    },
    {
        Name   => 'Correct Using Current tag to set CustomerID',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {
                CustomerID => '<OTRS_CURRENT_UserLogin>',
            },
        },
        ExpectedCustomerID => $TestUserLogin,
        Success            => 1,
    },
    {
        Name   => 'Correct Using Current tag to set CustomerUserID',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {
                CustomerUserID => '<OTRS_CURRENT_UserLogin>',
            },
        },
        ExpectedCustomerUserID => $TestUserLogin,
        Success                => 1,
    },
);

for my $Test (@Tests) {

    # Make a deep copy to avoid changing the definition.
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
            "$ModuleName Run() - Test:'$Test->{Name}' | executed with True"
        );

        my %Ticket = $TicketObject->TicketGet(
            TicketID => $TicketID,
            UserID   => 1,
        );

        if ( $Test->{ExpectedCustomerUserID} ) {
            $Self->Is(
                $TestUserLogin,
                $Ticket{CustomerUserID},
                "CustomerUserID is successfully replaced by OTRS_CURRENT_ tag",
            );
        }

        if ( $Test->{ExpectedCustomerID} ) {
            $Self->Is(
                $TestUserLogin,
                $Ticket{CustomerID},
                "CustomerID is successfully replaced by OTRS_CURRENT_ tag",
            );
        }

        # Set Attributes No as CustomerID and User as CustomerUserID.
        $Ticket{No}   = $Ticket{CustomerID}     || '';
        $Ticket{User} = $Ticket{CustomerUserID} || '';

        ATTRIBUTE:
        for my $Attribute ( sort keys %{ $Test->{Config}->{Config} } ) {

            $Self->True(
                defined $Ticket{$Attribute},
                "$ModuleName - Test:'$Test->{Name}' | Attribute: $Attribute for TicketID:"
                    . " $TicketID exists with True",
            );

            my $ExpectedValue = $Test->{Config}->{Config}->{$Attribute};
            if (
                $OrigTest->{Config}->{Config}->{$Attribute}
                =~ m{\A<OTRS_TICKET_([A-Za-z0-9_]+)>\z}msx
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

# Cleanup is done by RestoreDatabase.

1;
