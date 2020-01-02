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

# get needed objects
my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
my $TypeObject   = $Kernel::OM->Get('Kernel::System::Type');
my $ModuleObject = $Kernel::OM->Get('Kernel::System::ProcessManagement::TransitionAction::TicketTypeSet');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# enable ticket type for this run
$Kernel::OM->Get('Kernel::Config')->Set(
    Key   => 'Ticket::Type',
    Value => 1,
);

# define variables
my $UserID     = 1;
my $ModuleName = 'TicketTypeSet';
my $RandomID   = $Helper->GetRandomID();

# set user details
my ( $TestUserLogin, $TestUserID ) = $Helper->TestUserCreate();

my @TypeID;
my @TypeName;
for my $Item ( 0 .. 2 ) {
    $TypeName[$Item] = 'Type' . $Item . $RandomID;

    $TypeID[$Item] = $TypeObject->TypeAdd(
        Name    => $TypeName[$Item],
        ValidID => 1,
        UserID  => 1,
    );

    $Self->True(
        $TypeID[$Item],
        "TypeAdd() - $TypeName[$Item]",
    );
}

#
# Create a test ticket
#
my $TicketID = $TicketObject->TicketCreate(
    Title         => $TypeName[1],
    QueueID       => 1,
    Lock          => 'unlock',
    Priority      => '3 normal',
    StateID       => 1,
    TypeID        => $TypeID[0],
    OwnerID       => 1,
    ResponsibleID => 1,
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
                Type => $TypeID[1],
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
        Name   => 'Wrong Type',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {
                Type => 'NotExisting' . $RandomID,
            },
        },
        Success => 0,
    },
    {
        Name   => 'Wrong TypeID',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {
                TypeID => 9999999,
            },
        },
        Success => 0,
    },
    {
        Name   => "Correct Type $TypeName[1]",
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {
                Type => $TypeName[1],
            },
        },
        Success => 1,
    },
    {
        Name   => "Correct Type $TypeName[2]",
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {
                Type => $TypeName[2],
            },
        },
        Success => 1,
    },
    {
        Name   => "Correct TypeID $TypeName[1]",
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {
                TypeID => $TypeID[1],
            },
        },
        Success => 1,
    },
    {
        Name   => "Correct TypeID $TypeName[2]",
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {
                TypeID => $TypeID[2],
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
                Type => '<OTRS_TICKET_Title>',
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
                Type => '<OTRS_TICKET_NotExisting>',
            },
        },
        Success => 0,
    },
    {
        Name   => "Correct Using Different UserID",
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {
                Type   => $TypeName[1],
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
            "$ModuleName Run() - Test:'$Test->{Name}' | executed with True"
        );

        # get ticket
        %Ticket = $TicketObject->TicketGet(
            TicketID => $TicketID,
            UserID   => 1,
        );

        ATTRIBUTE:
        for my $Attribute ( sort keys %{ $Test->{Config}->{Config} } ) {

            $Self->True(
                $Ticket{$Attribute},
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

# cleanup is done by RestoreDatabase.

1;
