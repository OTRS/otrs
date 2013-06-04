# --
# ExternalTicketNumberRecognition.t - ExternalTicketNumberRecognition tests
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# $Id: ExternalTicketNumberRecognition.t,v 1.3 2012/05/21 08:26:03 mb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use vars (qw($Self));

use Kernel::Config;
use Kernel::System::DynamicField;
use Kernel::System::DynamicFieldValue;
use Kernel::System::PostMaster;
use Kernel::System::Ticket;

# create local config object
my $ConfigObject = Kernel::Config->new();

my %Jobs = %{ $ConfigObject->Get('PostMaster::PreFilterModule') };
my @TicketIDs;

# new/clear ticket object
my $TicketObject = Kernel::System::Ticket->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);

my $DynamicFieldObject = Kernel::System::DynamicField->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);

my $DynamicFieldValueObject = Kernel::System::DynamicFieldValue->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);

# create a dynamic field
my $FieldName = 'ExternalTNRecognition' . int rand(1000);
my $FieldID   = $DynamicFieldObject->DynamicFieldAdd(
    Name       => $FieldName,
    Label      => $FieldName . "_test",
    FieldOrder => 9991,
    FieldType  => 'Text',
    ObjectType => 'Ticket',
    Config     => {
        DefaultValue => 'a value',
    },
    ValidID => 1,
    UserID  => 1,
);

# verify dynamic field creation
$Self->True(
    $FieldID,
    "DynamicFieldAdd() successful for Field $FieldName",
);

my $ExternalTicketID = '13579' . rand(10000);

# filter test
my @Tests = (
    {
        Name  => '#1 - From Test - Fail',
        Email => 'From: Sender <sender@example.com>
To: Some Name <recipient@example.com>
Subject: An incident subject Incident-' . $ExternalTicketID . '

Some Content in Body',
        Check     => {},
        JobConfig => {
            ArticleType       => 'note-report',
            DynamicFieldName  => $FieldName,
            FromAddressRegExp => 'externalsystem@example.com',
            Module       => 'Kernel::System::PostMaster::Filter::ExternalTicketNumberRecognition',
            Name         => 'Some Description',
            NumberRegExp => '\\s*Incident-(\\d.*)\\s*',
            SearchInBody => '1',
            SearchInSubject  => '1',
            SenderType       => 'system',
            TicketStateTypes => 'new;open',
        },
        NewTicket => 1,
    },
    {
        Name  => '#2 - From Test Success',
        Email => 'From: Sender <sender@example.com>
To: Some Name <recipient@example.com>
Subject: An incident subject Incident-' . $ExternalTicketID . '

Some Content in Body',
        Check => {
            "DynamicField_$FieldName" => $ExternalTicketID,
        },
        JobConfig => {
            ArticleType       => 'note-report',
            DynamicFieldName  => $FieldName,
            FromAddressRegExp => '\\s*@example.com',
            Module       => 'Kernel::System::PostMaster::Filter::ExternalTicketNumberRecognition',
            Name         => 'Some Description',
            NumberRegExp => '\\s*Incident-(\\d.*)\\s*',
            SearchInBody => '1',
            SearchInSubject  => '1',
            SenderType       => 'system',
            TicketStateTypes => 'new;open',
        },
        NewTicket => 1,
    },
    {
        Name  => '#3 - Subject Test - Fail',
        Email => 'From: Sender <sender@example.com>
To: Some Name <recipient@example.com>
Subject: An incident subject Incident-' . $ExternalTicketID . '7

Some Content in Body',
        Check     => {},
        JobConfig => {
            ArticleType       => 'note-report',
            DynamicFieldName  => $FieldName,
            FromAddressRegExp => '\\s*@example.com',
            Module       => 'Kernel::System::PostMaster::Filter::ExternalTicketNumberRecognition',
            Name         => 'Some Description',
            NumberRegExp => '\\s*Incident-(\\d.*)\\s*',
            SearchInBody => '1',
            SearchInSubject  => '1',
            SenderType       => 'system',
            TicketStateTypes => 'new;open',
        },
        NewTicket => 1,
    },
    {
        Name  => '#4 - Subject Test - Fail',
        Email => 'From: Sender <sender@example.com>
To: Some Name <recipient@example.com>
Subject: An incident subject Incident-' . $ExternalTicketID . '

Some Content in Body',
        Check     => {},
        JobConfig => {
            ArticleType       => 'note-report',
            DynamicFieldName  => $FieldName,
            FromAddressRegExp => '\\s*@example.com',
            Module       => 'Kernel::System::PostMaster::Filter::ExternalTicketNumberRecognition',
            Name         => 'Some Description',
            NumberRegExp => '\\s*Incident-(\\d.*)\\s*',
            SearchInBody => '1',
            SearchInSubject  => '0',
            SenderType       => 'system',
            TicketStateTypes => 'new;open',
        },
        NewTicket => 1,
    },
    {
        Name  => '#5 - Subject Test - Fail',
        Email => 'From: Sender <sender@example.com>
To: Some Name <recipient@example.com>
Subject: An incident subject Incident-' . $ExternalTicketID . '

Some Content in Body',
        Check     => {},
        JobConfig => {
            ArticleType       => 'note-report',
            DynamicFieldName  => $FieldName,
            FromAddressRegExp => '\\s*@example.com',
            Module       => 'Kernel::System::PostMaster::Filter::ExternalTicketNumberRecognition',
            Name         => 'Some Description',
            NumberRegExp => '\\s*Report-(\\d.*)\\s*',
            SearchInBody => '1',
            SearchInSubject  => '1',
            SenderType       => 'system',
            TicketStateTypes => 'new;open',
        },
        NewTicket => 1,
    },
    {
        Name  => '#6 - Subject Test Success',
        Email => 'From: Sender <sender@example.com>
To: Some Name <recipient@example.com>
Subject: An incident subject Incident-' . $ExternalTicketID . '

Some Content in Body',
        Check => {
            "DynamicField_$FieldName" => $ExternalTicketID,
        },
        JobConfig => {
            ArticleType       => 'note-report',
            DynamicFieldName  => $FieldName,
            FromAddressRegExp => '\\s*@example.com',
            Module       => 'Kernel::System::PostMaster::Filter::ExternalTicketNumberRecognition',
            Name         => 'Some Description',
            NumberRegExp => '\\s*Incident-(\\d.*)\\s*',
            SearchInBody => '1',
            SearchInSubject  => '1',
            SenderType       => 'system',
            TicketStateTypes => 'new;open',
        },
        NewTicket => 2,
    },
    {
        Name  => '#3 - Body Test - Fail',
        Email => 'From: Sender <sender@example.com>
To: Some Name <recipient@example.com>
Subject: An incident subject

Some Content in Body Incident-' . $ExternalTicketID . '7',
        Check     => {},
        JobConfig => {
            ArticleType       => 'note-report',
            DynamicFieldName  => $FieldName,
            FromAddressRegExp => '\\s*@example.com',
            Module       => 'Kernel::System::PostMaster::Filter::ExternalTicketNumberRecognition',
            Name         => 'Some Description',
            NumberRegExp => '\\s*Incident-(\\d.*)\\s*',
            SearchInBody => '1',
            SearchInSubject  => '1',
            SenderType       => 'system',
            TicketStateTypes => 'new;open',
        },
        NewTicket => 2,
    },
    {
        Name  => '#4 - Body Test - Fail',
        Email => 'From: Sender <sender@example.com>
To: Some Name <recipient@example.com>
Subject: An incident subject

Some Content in Body Incident-' . $ExternalTicketID,
        Check     => {},
        JobConfig => {
            ArticleType       => 'note-report',
            DynamicFieldName  => $FieldName,
            FromAddressRegExp => '\\s*@example.com',
            Module       => 'Kernel::System::PostMaster::Filter::ExternalTicketNumberRecognition',
            Name         => 'Some Description',
            NumberRegExp => '\\s*Incident-(\\d.*)\\s*',
            SearchInBody => '0',
            SearchInSubject  => '1',
            SenderType       => 'system',
            TicketStateTypes => 'new;open',
        },
        NewTicket => 1,
    },
    {
        Name  => '#5 - Body Test - Fail',
        Email => 'From: Sender <sender@example.com>
To: Some Name <recipient@example.com>
Subject: An incident subject

Some Content in Body Incident-' . $ExternalTicketID,
        Check     => {},
        JobConfig => {
            ArticleType       => 'note-report',
            DynamicFieldName  => $FieldName,
            FromAddressRegExp => '\\s*@example.com',
            Module       => 'Kernel::System::PostMaster::Filter::ExternalTicketNumberRecognition',
            Name         => 'Some Description',
            NumberRegExp => '\\s*Report-(\\d.*)\\s*',
            SearchInBody => '1',
            SearchInSubject  => '1',
            SenderType       => 'system',
            TicketStateTypes => 'new;open',
        },
        NewTicket => 1,
    },
    {
        Name  => '#6 - Body Test Success',
        Email => 'From: Sender <sender@example.com>
To: Some Name <recipient@example.com>
Subject: An incident subject

Some Content in Body Incident-' . $ExternalTicketID,
        Check => {
            "DynamicField_$FieldName" => $ExternalTicketID,
        },
        JobConfig => {
            ArticleType       => 'note-report',
            DynamicFieldName  => $FieldName,
            FromAddressRegExp => '\\s*@example.com',
            Module       => 'Kernel::System::PostMaster::Filter::ExternalTicketNumberRecognition',
            Name         => 'Some Description',
            NumberRegExp => '\\s*Incident-(\\d.*)\\s*',
            SearchInBody => '1',
            SearchInSubject  => '1',
            SenderType       => 'system',
            TicketStateTypes => 'new;open',
        },
        NewTicket => 2,
    },
);

for my $Test (@Tests) {

    $ConfigObject->Set(
        Key   => 'PostMaster::PreFilterModule',
        Value => {},
    );

    $ConfigObject->Set(
        Key   => 'PostMaster::PreFilterModule',
        Value => {
            '00-ExternalTicketNumberRecognition1' => {
                %{ $Test->{JobConfig} }
            },
        },
    );

    my @Return;
    {
        my $PostMasterObject = Kernel::System::PostMaster->new(
            %{$Self},
            ConfigObject => $ConfigObject,
            Email        => \$Test->{Email},
            Debug        => 2,
        );

        @Return = $PostMasterObject->Run();
    }
    $Self->Is(
        $Return[0] || 0,
        $Test->{NewTicket},
        "#Filter Run() - NewTicket",
    );
    $Self->True(
        $Return[1] || 0,
        "#Filter  Run() - NewTicket/TicketID",
    );
    my %Ticket = $TicketObject->TicketGet(
        TicketID      => $Return[1],
        DynamicFields => 1,
    );

    for my $Key ( sort keys %{ $Test->{Check} } ) {
        $Self->Is(
            $Ticket{$Key},
            $Test->{Check}->{$Key},
            "#Filter Run() - $Key",
        );
    }

    # remember TicketID
    push @TicketIDs, $Return[1];
}

# cleanup the system
# delete all dynamic field field values
my $ValuesDeleteSuccess = $DynamicFieldValueObject->AllValuesDelete(
    FieldID => $FieldID,
    UserID  => 1,
);
$Self->True(
    $ValuesDeleteSuccess,
    "Deleted values for dynamic field with id $FieldID.",
);

# delete dynamic field
my $FieldDelete = $DynamicFieldObject->DynamicFieldDelete(
    ID     => $FieldID,
    UserID => 1,
);
$Self->True(
    $FieldDelete,
    "Deleted dynamic field with id $FieldID.",
);

# delete tickets
for my $TicketID (@TicketIDs) {
    my $Delete = $TicketObject->TicketDelete(
        TicketID => $TicketID,
        UserID   => 1,
    );
    $Self->True(
        $Delete || 0,
        "#Filter TicketDelete()",
    );
}

# set back values for prefilter config
$ConfigObject->Set(
    Key   => 'PostMaster::PreFilterModule',
    Value => \%Jobs,
);

1;
