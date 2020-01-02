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
my $ModuleObject = $Kernel::OM->Get('Kernel::System::ProcessManagement::TransitionAction::TicketTitleSet');

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# Define variables.
my $UserID     = 1;
my $ModuleName = 'TicketTitleSet';
my $RandomID   = $Helper->GetRandomID();

# Set user details.
my ( $TestUserLogin, $TestUserID ) = $Helper->TestUserCreate();

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
$Self->Is(
    $Ticket{Title},
    'test',
    "TicketGet() - Title after creation",
);

my @Tests = (
    {
        Name    => 'No Params',
        Config  => undef,
        Success => 0,
    },
    {
        Name   => 'No Title',
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
                Title => 'test2',
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
                Title => 'test2',
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
        Name   => 'New title',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {
                Title => 'Some new title for the ticket goes here',
            },
        },
        Success => 1,
    },
    {
        Name   => 'New empty title',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {
                Title => '',
            },
        },
        Success => 1,
    },
    {
        Name   => 'New title extended',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {
                Title =>
                    'Jetzt kommen die ultrascharfen Groß-Fernseher mit vierfache HD-Auflösung',
            },
        },
        Success => 1,
    },
    {
        Name   => 'New title UTF8',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {
                Title =>
                    'Многие пользователи сети отмечают, что тема очередной массовой акции непарламентской оппозиции выбрана крайне спорная и непатриотичная',
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
                Title => '<OTRS_TICKET_Queue>',
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
                Title => '<OTRS_TICKET_NotExisting>',
            },
        },
        Success => 1,
    },
    {
        Name   => 'Correct Using Different UserID',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {
                Title => '',
            },
        },
        Success => 1,
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

        %Ticket = $TicketObject->TicketGet(
            TicketID => $TicketID,
            UserID   => 1,
        );

        ATTRIBUTE:
        for my $Attribute ( sort keys %{ $Test->{Config}->{Config} } ) {

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

            # Workaround for oracle.
            # Oracle databases can't determine the difference between NULL and ''.
            # Compare ticket attribute or empty string then.
            $Self->Is(
                $Ticket{$Attribute} || '',
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
            "$ModuleName Run() - Test:'$Test->{Name}' | excecuted with False"
        );
    }
}

# Check tags <OTRS_TICKET_DynamicField_Name1> and <OTRS_TICKET_DynamicField_Name1_Value>
# for date type DF (see bug#13795).
# Create test ticket.
$TicketID = $TicketObject->TicketCreate(
    Title         => 'Test' . $RandomID,
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
    "TicketID $TicketID is created",
);

my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');

# Create test dynamic field.
my $DynamicFieldName = 'TestDate' . $RandomID;
my $DynamicFieldID   = $DynamicFieldObject->DynamicFieldAdd(
    Name       => $DynamicFieldName,
    Label      => $DynamicFieldName,
    FieldOrder => 9990,
    FieldType  => 'Date',
    ObjectType => 'Ticket',
    Config     => {
        DefaultValue  => 0,
        YearsInFuture => 0,
        YearsInPast   => 0,
        YearsPeriod   => 0,
    },
    Reorder => 1,
    ValidID => 1,
    UserID  => 1,
);
$Self->True(
    $DynamicFieldID,
    "DynamicFieldID $DynamicFieldID is created",
);

# Set the value from the dynamic field.
my $DateValue          = '2018-06-11';
my $DynamicFieldConfig = $DynamicFieldObject->DynamicFieldGet(
    Name => $DynamicFieldName,
);

my $Result = $Kernel::OM->Get('Kernel::System::DynamicField::Backend')->ValueSet(
    DynamicFieldConfig => $DynamicFieldConfig,
    ObjectID           => $TicketID,
    Value              => "$DateValue 00:00:00",
    UserID             => 1,
);
$Self->True(
    $Result,
    "DynamicFieldID $DynamicFieldID is set successfully",
);

my @Titles = (
    '<OTRS_TICKET_DynamicField_' . $DynamicFieldName . '>',
    '<OTRS_Ticket_DynamicField_' . $DynamicFieldName . '>',
    '<OTRS_TICKET_DynamicField_' . $DynamicFieldName . '_Value>',
    '<OTRS_Ticket_DynamicField_' . $DynamicFieldName . '_Value>',
);

for my $Title (@Titles) {
    my %TicketData = $TicketObject->TicketGet(
        TicketID      => $TicketID,
        DynamicFields => 1,
        UserID        => $UserID,
    );

    $ModuleObject->Run(
        UserID => $UserID,
        Ticket => \%TicketData,
        Config => {
            Title => $Title,
        },
        ProcessEntityID          => 'P1',
        ActivityEntityID         => 'A1',
        TransitionEntityID       => 'T1',
        TransitionActionEntityID => 'TA1',
    );

    %TicketData = $TicketObject->TicketGet( TicketID => $TicketID );

    $Self->Is(
        $TicketData{Title},
        $DateValue,
        "Title is set successfully"
    );
}

# cleanup is done by RestoreDatabase.

1;
