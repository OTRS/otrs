# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

use Kernel::System::PostMaster;

# get needed objects
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# define needed variable
my $RandomID = $Helper->GetRandomID();
my %Jobs     = %{ $ConfigObject->Get('PostMaster::PreFilterModule') };

# create a dynamic field
my $FieldName = 'ExternalTNRecognition' . $RandomID;
my $FieldID   = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldAdd(
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

my $ExternalTicketID = '13579' . $RandomID;

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
            DynamicFieldName     => $FieldName,
            FromAddressRegExp    => 'externalsystem@example.com',
            Module               => 'Kernel::System::PostMaster::Filter::ExternalTicketNumberRecognition',
            Name                 => 'Some Description',
            NumberRegExp         => '\\s*Incident-(\\d.*)\\s*',
            SearchInBody         => '1',
            SearchInSubject      => '1',
            SenderType           => 'system',
            IsVisibleForCustomer => 1,
            TicketStateTypes     => 'new;open',
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
            DynamicFieldName     => $FieldName,
            FromAddressRegExp    => '\\s*@example.com',
            Module               => 'Kernel::System::PostMaster::Filter::ExternalTicketNumberRecognition',
            Name                 => 'Some Description',
            NumberRegExp         => '\\s*Incident-(\\d.*)\\s*',
            SearchInBody         => '1',
            SearchInSubject      => '1',
            SenderType           => 'system',
            IsVisibleForCustomer => 1,
            TicketStateTypes     => 'new;open',
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
            DynamicFieldName     => $FieldName,
            FromAddressRegExp    => '\\s*@example.com',
            Module               => 'Kernel::System::PostMaster::Filter::ExternalTicketNumberRecognition',
            Name                 => 'Some Description',
            NumberRegExp         => '\\s*Incident-(\\d.*)\\s*',
            SearchInBody         => '1',
            SearchInSubject      => '1',
            SenderType           => 'system',
            IsVisibleForCustomer => 1,
            TicketStateTypes     => 'new;open',
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
            DynamicFieldName     => $FieldName,
            FromAddressRegExp    => '\\s*@example.com',
            Module               => 'Kernel::System::PostMaster::Filter::ExternalTicketNumberRecognition',
            Name                 => 'Some Description',
            NumberRegExp         => '\\s*Incident-(\\d.*)\\s*',
            SearchInBody         => '1',
            SearchInSubject      => '0',
            SenderType           => 'system',
            IsVisibleForCustomer => 1,
            TicketStateTypes     => 'new;open',
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
            DynamicFieldName     => $FieldName,
            FromAddressRegExp    => '\\s*@example.com',
            Module               => 'Kernel::System::PostMaster::Filter::ExternalTicketNumberRecognition',
            Name                 => 'Some Description',
            NumberRegExp         => '\\s*Report-(\\d.*)\\s*',
            SearchInBody         => '1',
            SearchInSubject      => '1',
            SenderType           => 'system',
            IsVisibleForCustomer => 1,
            TicketStateTypes     => 'new;open',
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
            DynamicFieldName     => $FieldName,
            FromAddressRegExp    => '\\s*@example.com',
            Module               => 'Kernel::System::PostMaster::Filter::ExternalTicketNumberRecognition',
            Name                 => 'Some Description',
            NumberRegExp         => '\\s*Incident-(\\d.*)\\s*',
            SearchInBody         => '1',
            SearchInSubject      => '1',
            SenderType           => 'system',
            IsVisibleForCustomer => 1,
            TicketStateTypes     => 'new;open',
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
            DynamicFieldName     => $FieldName,
            FromAddressRegExp    => '\\s*@example.com',
            Module               => 'Kernel::System::PostMaster::Filter::ExternalTicketNumberRecognition',
            Name                 => 'Some Description',
            NumberRegExp         => '\\s*Incident-(\\d.*)\\s*',
            SearchInBody         => '1',
            SearchInSubject      => '1',
            SenderType           => 'system',
            IsVisibleForCustomer => 1,
            TicketStateTypes     => 'new;open',
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
            DynamicFieldName     => $FieldName,
            FromAddressRegExp    => '\\s*@example.com',
            Module               => 'Kernel::System::PostMaster::Filter::ExternalTicketNumberRecognition',
            Name                 => 'Some Description',
            NumberRegExp         => '\\s*Incident-(\\d.*)\\s*',
            SearchInBody         => '0',
            SearchInSubject      => '1',
            SenderType           => 'system',
            IsVisibleForCustomer => 1,
            TicketStateTypes     => 'new;open',
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
            DynamicFieldName     => $FieldName,
            FromAddressRegExp    => '\\s*@example.com',
            Module               => 'Kernel::System::PostMaster::Filter::ExternalTicketNumberRecognition',
            Name                 => 'Some Description',
            NumberRegExp         => '\\s*Report-(\\d.*)\\s*',
            SearchInBody         => '1',
            SearchInSubject      => '1',
            SenderType           => 'system',
            IsVisibleForCustomer => 1,
            TicketStateTypes     => 'new;open',
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
            DynamicFieldName     => $FieldName,
            FromAddressRegExp    => '\\s*@example.com',
            Module               => 'Kernel::System::PostMaster::Filter::ExternalTicketNumberRecognition',
            Name                 => 'Some Description',
            NumberRegExp         => '\\s*Incident-(\\d.*)\\s*',
            SearchInBody         => '1',
            SearchInSubject      => '1',
            SenderType           => 'system',
            IsVisibleForCustomer => 1,
            TicketStateTypes     => 'new;open',
        },
        NewTicket => 2,
    },
    {
        Name =>
            '#7 - Body Test Success with Complex TicketNumber / Regex; special characters must be escaped in the regex',
        Email => 'From: Sender <sender@example.com>
To: Some Name <recipient@example.com>
Subject: An incident subject

Some Content in Body Incident#/' . $ExternalTicketID,
        Check => {
            "DynamicField_$FieldName" => $ExternalTicketID,
        },
        JobConfig => {
            DynamicFieldName     => $FieldName,
            FromAddressRegExp    => '\\s*@example.com',
            Module               => 'Kernel::System::PostMaster::Filter::ExternalTicketNumberRecognition',
            Name                 => 'Some Description',
            NumberRegExp         => '\\s*Incident\#\/(\\d.*)\\s*',
            SearchInBody         => '1',
            SearchInSubject      => '1',
            SenderType           => 'system',
            IsVisibleForCustomer => 1,
            TicketStateTypes     => 'new;open',
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
        my $CommunicationLogObject = $Kernel::OM->Create(
            'Kernel::System::CommunicationLog',
            ObjectParams => {
                Transport => 'Email',
                Direction => 'Incoming',
            },
        );
        $CommunicationLogObject->ObjectLogStart( ObjectLogType => 'Message' );

        my $PostMasterObject = Kernel::System::PostMaster->new(
            CommunicationLogObject => $CommunicationLogObject,
            Email                  => \$Test->{Email},
            Debug                  => 2,
        );

        @Return = $PostMasterObject->Run();

        $CommunicationLogObject->ObjectLogStop(
            ObjectLogType => 'Message',
            Status        => 'Successful',
        );
        $CommunicationLogObject->CommunicationStop(
            Status => 'Successful',
        );
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
}

# set back values for prefilter config
$ConfigObject->Set(
    Key   => 'PostMaster::PreFilterModule',
    Value => \%Jobs,
);

# cleanup is done by RestoreDatabase.

1;
