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

use Kernel::System::PostMaster;

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# Create test dynamic field.
my $FieldName      = 'ETNR' . $Helper->GetRandomID();
my $DynamicFieldID = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldAdd(
    Name       => $FieldName,
    Label      => $FieldName,
    FieldOrder => 9991,
    FieldType  => 'Text',
    ObjectType => 'Ticket',
    Config     => {
        DefaultValue => '',
    },
    ValidID => 1,
    UserID  => 1,
);
$Self->True(
    $DynamicFieldID,
    "DynamicFieldID $DynamicFieldID is created",
);

my @ExternalTicketIDs;
for my $Count ( 0 .. 2 ) {
    push @ExternalTicketIDs, $Helper->GetRandomNumber();
}

my @Tests = (
    {
        Name  => 'ETNR - subject search, ETN - in subject, DF value - set to ETN',
        Email => 'From: Sender <sender@example.com>
To: Some Name <recipient@example.com>
Subject: An incident subject Incident-' . $ExternalTicketIDs[0] . '

Some Content in Body',
        PreFilterModule => {
            '00-ExternalTicketNumberRecognition1' => {
                DynamicFieldName     => $FieldName,
                FromAddressRegExp    => '\\s*@example.com',
                Module               => 'Kernel::System::PostMaster::Filter::ExternalTicketNumberRecognition',
                Name                 => 'Some Description',
                NumberRegExp         => '\s*Incident-(\d.*)\s*',
                SearchInBody         => '0',
                SearchInSubject      => '1',
                SenderType           => 'system',
                IsVisibleForCustomer => 1,
                TicketStateTypes     => 'new;open',
            },
        },
        CheckFollowUpModule => {
            '0100-Subject' => {
                Module => 'Kernel::System::PostMaster::FollowUpCheck::Subject',
            },
            '0600-ExternalTicketNumberRecognition' => {
                Module => 'Kernel::System::PostMaster::FollowUpCheck::ExternalTicketNumberRecognition',
            },
        },
        NumberGeneratorModules => [
            {
                Name   => 'DateChecksum',
                Return => {
                    Number => 1,
                    Action => 'New ticket',
                },
                Check => {
                    "DynamicField_$FieldName" => $ExternalTicketIDs[0],
                },
            },
            {
                Name   => 'AutoIncrement',
                Return => {
                    Number => 2,
                    Action => 'Follow-up',
                },
                Check => {
                    "DynamicField_$FieldName" => $ExternalTicketIDs[0],
                },
            },
        ],
    },
    {
        Name  => 'ETNR - body search, ETN - in body, DF value - set to ETN',
        Email => 'From: Sender <sender@example.com>
To: Some Name <recipient@example.com>
Subject: An incident subject

Some Content in Body-' . $ExternalTicketIDs[1],
        PreFilterModule => {
            '00-ExternalTicketNumberRecognition1' => {
                DynamicFieldName     => $FieldName,
                FromAddressRegExp    => '\\s*@example.com',
                Module               => 'Kernel::System::PostMaster::Filter::ExternalTicketNumberRecognition',
                Name                 => 'Some Description',
                NumberRegExp         => '\s*Body-(\d.*)\s*',
                SearchInBody         => '1',
                SearchInSubject      => '0',
                SenderType           => 'system',
                IsVisibleForCustomer => 1,
                TicketStateTypes     => 'new;open',
            },
        },
        CheckFollowUpModule => {
            '0300-Body' => {
                Module => 'Kernel::System::PostMaster::FollowUpCheck::Body',
            },
            '0600-ExternalTicketNumberRecognition' => {
                Module => 'Kernel::System::PostMaster::FollowUpCheck::ExternalTicketNumberRecognition',
            },
        },
        NumberGeneratorModules => [
            {
                Name   => 'DateChecksum',
                Return => {
                    Number => 1,
                    Action => 'New ticket',
                },
                Check => {
                    "DynamicField_$FieldName" => $ExternalTicketIDs[1],
                },
            },
            {
                Name   => 'AutoIncrement',
                Return => {
                    Number => 2,
                    Action => 'Follow-up',
                },
                Check => {
                    "DynamicField_$FieldName" => $ExternalTicketIDs[1],
                },
            },
        ],
    },
    {
        Name  => 'ETNR - subject search, ETN - in body, DF value - undef',
        Email => 'From: Sender <sender@example.com>
To: Some Name <recipient@example.com>
Subject: An incident subject

Some Content in Body-' . $ExternalTicketIDs[2],
        PreFilterModule => {
            '00-ExternalTicketNumberRecognition1' => {
                DynamicFieldName     => $FieldName,
                FromAddressRegExp    => '\\s*@example.com',
                Module               => 'Kernel::System::PostMaster::Filter::ExternalTicketNumberRecognition',
                Name                 => 'Some Description',
                NumberRegExp         => '\s*Body-(\d.*)\s*',
                SearchInBody         => '0',
                SearchInSubject      => '1',
                SenderType           => 'system',
                IsVisibleForCustomer => 1,
                TicketStateTypes     => 'new;open',
            },
        },
        CheckFollowUpModule => {
            '0100-Subject' => {
                Module => 'Kernel::System::PostMaster::FollowUpCheck::Subject',
            },
            '0600-ExternalTicketNumberRecognition' => {
                Module => 'Kernel::System::PostMaster::FollowUpCheck::ExternalTicketNumberRecognition',
            },
        },
        NumberGeneratorModules => [
            {
                Name   => 'DateChecksum',
                Return => {
                    Number => 1,
                    Action => 'New ticket',
                },
                Check => {
                    "DynamicField_$FieldName" => undef,
                },
            },
            {
                Name   => 'AutoIncrement',
                Return => {
                    Number => 1,
                    Action => 'New ticket',
                },
                Check => {
                    "DynamicField_$FieldName" => undef,
                },
            },
        ],
    },
    {
        Name  => 'ETNR - body search, ETN - in body, DF value - set to ETN',
        Email => 'From: Sender <sender@example.com>
To: Some Name <recipient@example.com>
Subject: An incident subject

Some Content in Body-' . $ExternalTicketIDs[2],
        PreFilterModule => {
            '00-ExternalTicketNumberRecognition1' => {
                DynamicFieldName     => $FieldName,
                FromAddressRegExp    => '\\s*@example.com',
                Module               => 'Kernel::System::PostMaster::Filter::ExternalTicketNumberRecognition',
                Name                 => 'Some Description',
                NumberRegExp         => '\s*Body-(\d.*)\s*',
                SearchInBody         => '1',
                SearchInSubject      => '0',
                SenderType           => 'system',
                IsVisibleForCustomer => 1,
                TicketStateTypes     => 'new;open',
            },
        },
        CheckFollowUpModule => {
            '0100-Subject' => {
                Module => 'Kernel::System::PostMaster::FollowUpCheck::Subject',
            },
            '0600-ExternalTicketNumberRecognition' => {
                Module => 'Kernel::System::PostMaster::FollowUpCheck::ExternalTicketNumberRecognition',
            },
        },
        NumberGeneratorModules => [
            {
                Name   => 'DateChecksum',
                Return => {
                    Number => 1,
                    Action => 'New ticket',
                },
                Check => {
                    "DynamicField_$FieldName" => $ExternalTicketIDs[2],
                },
            },
            {
                Name   => 'AutoIncrement',
                Return => {
                    Number => 2,
                    Action => 'Follow-up',
                },
                Check => {
                    "DynamicField_$FieldName" => $ExternalTicketIDs[2],
                },
            },
        ],
    },
);

my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

for my $Test (@Tests) {

    # Set PreFilterModule.
    $Helper->ConfigSettingChange(
        Valid => 1,
        Key   => 'PostMaster::PreFilterModule',
        Value => $Test->{PreFilterModule},
    );

    # Set CheckFollowUpModule.
    $Helper->ConfigSettingChange(
        Valid => 1,
        Key   => 'PostMaster::CheckFollowUpModule',
        Value => $Test->{CheckFollowUpModule},
    );

    for my $Module ( @{ $Test->{NumberGeneratorModules} } ) {

        # Set number generator.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::NumberGenerator',
            Value => "Kernel::System::Ticket::Number::$Module->{Name}",
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
                Email                  => $Test->{Email},
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

        # Check results.
        $Self->Is(
            $Return[0],
            $Module->{Return}->{Number},
            "$Test->{Name}: Return number - $Module->{Return}->{Number}, Action - $Module->{Return}->{Action}",
        );

        $Self->True(
            $Return[1],
            "$Test->{Name}: TicketID - $Return[1]",
        );

        my %Ticket = $TicketObject->TicketGet(
            TicketID      => $Return[1],
            DynamicFields => 1,
        );

        for my $Key ( sort keys %{ $Module->{Check} } ) {
            $Self->Is(
                $Ticket{$Key},
                $Module->{Check}->{$Key},
                "$Test->{Name}: Correct value for key - $Key",
            );
        }
    }
}

# cleanup is done by RestoreDatabase.

1;
