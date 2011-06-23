# --
# Common.t - ReplicateIncident Operation tests
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: Common.t,v 1.21 2011-06-23 22:28:32 cr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use vars (qw($Self));

use MIME::Base64 ();

use Kernel::System::Ticket;
use Kernel::System::GenericInterface::Webservice;
use Kernel::GenericInterface::Debugger;
use Kernel::GenericInterface::Mapping;
use Kernel::GenericInterface::Operation;
use Kernel::Config;

my $ConfigObject = Kernel::Config->new();
my $TicketObject = Kernel::System::Ticket->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);
my $WebserviceObject = Kernel::System::GenericInterface::Webservice->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);

my $RandomID1 = int rand 1_000_000_000;
my $RandomID2 = $RandomID1 + 1;

my $WebserviceConfig = {
    Debugger => {
        DebugThreshold => 'debug',
    },
    Provider => {
        Transport => {
            Type   => 'HTTP::Test',
            Config => {
                Fail => 0,
            },
        },
        Operation => {
            ReplicateIncident => {
                Type             => 'SolMan::ReplicateIncident',
                RemoteSystemGuid => 'DE86768CD3D015F181D0001438BF50C6',
            },
            ProcessIncident => {
                Type             => 'SolMan::ProcessIncident',
                RemoteSystemGuid => 'DE86768CD3D015F181D0001438BF50C6',
            },
            AddInfo => {
                Type             => 'SolMan::AddInfo',
                RemoteSystemGuid => 'DE86768CD3D015F181D0001438BF50C6',
                MappingInbound   => {
                    Config => {
                        ArticleTypeMap => {
                            SUST => 'phone',
                        },
                        ArticleTypeMapDefault => 'email-internal',
                        PriorityMap           => {
                            1 => '5 very high',
                        },
                        StateMap => {
                            E0003SLFC0001 => 'pending reminder',
                        },
                        TicketFreeTextMap => {
                            SAPComponent    => 10,
                            SAPSystemID     => 11,
                            SAPSystemClient => 12,
                        },
                    },
                    Type => 'SolMan',
                },
            },
            AcceptIncidentProcessing => {
                Type             => 'SolMan::AcceptIncidentProcessing',
                RemoteSystemGuid => 'DE86768CD3D015F181D0001438BF50C6',
            },
            VerifyIncidentSolution => {
                Type             => 'SolMan::VerifyIncidentSolution',
                RemoteSystemGuid => 'DE86768CD3D015F181D0001438BF50C6',
            },
            RejectIncidentSolution => {
                Type             => 'SolMan::RejectIncidentSolution',
                RemoteSystemGuid => 'DE86768CD3D015F181D0001438BF50C6',
            },
            CloseIncident => {
                Type             => 'SolMan::CloseIncident',
                CloseState       => 'closed successful',
                RemoteSystemGuid => 'DE86768CD3D015F181D0001438BF50C6',
            },
        },
    },
};

# add config
my $WebserviceID = $WebserviceObject->WebserviceAdd(
    Config  => $WebserviceConfig,
    Name    => "Test $RandomID1",
    ValidID => 1,
    UserID  => 1,
);

$Self->True(
    $WebserviceID,
    "WebserviceAdd()",
);

my $DebuggerObject = Kernel::GenericInterface::Debugger->new(
    %{$Self},
    ConfigObject   => $ConfigObject,
    DebuggerConfig => {
        DebugThreshold => 'debug',
        TestMode       => 1,
    },
    WebserviceID      => $WebserviceID,
    CommunicationType => 'Provider',
);

my $LocalSystemGuid;

{

    # Get local SystemGuid
    my $OperationObject = Kernel::GenericInterface::Operation->new(
        %{$Self},
        ConfigObject   => $ConfigObject,
        DebuggerObject => $DebuggerObject,
        WebserviceID   => $WebserviceID,
        OperationType  => "SolMan::RequestSystemGuid",
    );

    $Self->Is(
        ref $OperationObject,
        'Kernel::GenericInterface::Operation',
        'Operation::new() success',
    );

    my $Result = $OperationObject->Run();

    $Self->Is(
        $Result->{Success},
        1,
        "RequestSystemGuid success status",
    );

    $LocalSystemGuid = $Result->{Data}->{SystemGuid};
}

my @Tests = (
    [
        {
            Name         => 'ReplicateIncident without data',
            Operation    => 'ReplicateIncident',
            Success      => 1,
            HandledError => 1,
        },
    ],
    [
        {
            Name         => 'ReplicateIncident with wrong data (arrayref)',
            Operation    => 'ReplicateIncident',
            Success      => 1,
            HandledError => 1,
            Data         => [],
        },
    ],
    [
        {
            Name         => 'ReplicateIncident with correct structure, no data',
            Operation    => 'ReplicateIncident',
            Success      => 1,
            HandledError => 1,
            Data         => {
                IctAdditionalInfos => {},
                IctAttachments     => {},
                IctHead            => {},
                IctId              => '',
                IctPersons         => {},
                IctSapNotes        => {},
                IctSolutions       => {},
                IctStatements      => {},
                IctTimestamp       => '',
                IctUrls            => {},
            },
        },
    ],
    [
        {
            Name      => 'ReplicateIncident',
            Operation => 'ReplicateIncident',
            Success   => 1,
            Data      => {
                IctAdditionalInfos => {},
                IctAttachments     => {
                    item => [
                        {
                            AttachmentGuid => "Solman-$RandomID1-1-1",
                            Filename       => 'test1.txt',
                            MimeType       => 'text/plain',
                            Data           => 'ZWluIHRlc3Qgw6TDtsO8w5/DhMOWw5zigqw=',
                            Timestamp      => '20110324000000',
                            PersonId       => 1,
                            Url            => 'http://localhost',
                            Language       => 'de',
                            Delete         => '',
                        },
                    ],
                },
                IctHead => {
                    IncidentGuid     => "Solman-$RandomID1",
                    RequesterGuid    => 'DE86768CD3D015F181D0001438BF50C6',
                    ProviderGuid     => $LocalSystemGuid,
                    AgentId          => 1,
                    ReporterId       => 'stefan.bedorf@otrs.com',
                    ShortDescription => 'title',
                    Priority         => '3 normal',
                    Language         => 'de',
                    RequestedBegin   => '20000101000000',
                    RequestedEnd     => '20111231235959',
                },
                IctId      => "Solman-$RandomID1",
                IctPersons => {
                    item => {
                        PersonId    => 'stefan.bedorf@otrs.com',
                        PersonIdExt => 292,
                        Sex         => 'm',
                        FirstName   => 'Stefan',
                        LastName    => 'Bedorf',
                        Telephone   => {
                            PhoneNo          => '+49 9421 56818',
                            PhoneNoExtension => '0',
                        },
                        MobilePhone => '-',
                        Fax         => {
                            FaxNo          => '+49 9421 56818',
                            FaxNoExtension => '18',
                        },
                        Email => 'stefan.bedorf@otrs.com',
                    },
                },
                IctSapNotes   => {},
                IctSolutions  => {},
                IctStatements => {
                    item => [
                        {
                            TextType => 'note-internal',

                            # text lines
                            Texts => {
                                item => [
                                    'a line of text',
                                    'another line',
                                    'multiline
text
works too',
                                ],
                            },
                            Timestamp => '20110323000000',
                            PersonId  => 1,
                            Language  => 'de',
                        },
                    ],
                },

                IctTimestamp => '20010101000000',
                IctUrls      => {},
            },
        },
        {
            Name      => 'AddInfo',
            Operation => 'AddInfo',
            Success   => 1,
            Expected  => {
                ArticleType => [
                    'phone',
                    'email-internal',
                ],
                Priority       => '5 very high',
                State          => 'pending reminder',
                TicketFreeText => {
                    10 => 'DE-TST',
                    11 => 'localhost',
                    12 => '',
                },
            },
            Data => {
                IctAdditionalInfos => {
                    item => [
                        {
                            AddInfoAttribute => 'SAPComponent',
                            AddInfoValue     => 'DE-TST',
                        },
                        {
                            AddInfoAttribute => 'SAPSystemID',
                            AddInfoValue     => 'localhost',
                        },
                        {
                            AddInfoAttribute => 'SAPUserStatus',
                            AddInfoValue     => 'E0003SLFC0001',
                        },
                    ],
                },
                IctAttachments => {
                    item => [
                        {
                            AttachmentGuid => "Solman-$RandomID1-2-1",
                            Filename       => 'test2.bin',
                            MimeType       => 'application/octet-stream',
                            Data           => 'ZWluIHRlc3Qgw6TDtsO8w5/DhMOWw5zigqw=',
                            Timestamp      => '20110324000000',
                            PersonId       => 1,
                            Url            => 'http://localhost',
                            Language       => 'de',
                            Delete         => ' ',
                        },
                        {
                            AttachmentGuid => "Solman-$RandomID1-3-1",
                            Filename       => 'test3.bin',
                            MimeType       => 'application/octet-stream',
                            Data           => 'ZWluIHRlc3Qgw6TDtsO8w5/DhMOWw5zigqw=',
                            Timestamp      => '20110324000000',
                            PersonId       => 1,
                            Url            => 'http://localhost',
                            Language       => 'de',
                            Delete         => '1',
                        },
                    ],
                },
                IctHead => {
                    IncidentGuid     => "Solman-$RandomID1",
                    RequesterGuid    => 'DE86768CD3D015F181D0001438BF50C6',
                    ProviderGuid     => $LocalSystemGuid,
                    AgentId          => 1,
                    ReporterId       => 'stefan.bedorf@otrs.com',
                    ShortDescription => 'AddInfo Test',
                    Priority         => 1,
                    Language         => 'de',
                    RequestedBegin   => '20000101000000',
                    RequestedEnd     => '20111231235959',
                },
                IctPersons => {
                    item => {
                        PersonId    => 'stefan.bedorf@otrs.com',
                        PersonIdExt => 292,
                        Sex         => 'm',
                        FirstName   => 'Stefan',
                        LastName    => 'Bedorf',
                        Telephone   => {
                            PhoneNo          => '+49 9421 56818',
                            PhoneNoExtension => '0',
                        },
                        MobilePhone => '-',
                        Fax         => {
                            FaxNo          => '+49 9421 56818',
                            FaxNoExtension => '18',
                        },
                        Email => 'stefan.bedorf@otrs.com',
                    },
                },
                IctSapNotes   => {},
                IctSolutions  => {},
                IctStatements => {
                    item => [
                        {
                            TextType => 'SUST',
                            Texts    => {
                                item => [
                                    'another',
                                    'note from SolMan',
                                ],
                            },
                            Timestamp => '20110323000000',
                            PersonId  => 1,
                            Language  => 'de',
                        },
                        {
                            TextType => 'UNKNOWN',
                            Texts    => {
                                item => [
                                    'a new second article',
                                ],
                            },
                            Timestamp => '20110323000000',
                            PersonId  => 1,
                            Language  => 'de',
                        },
                    ],
                },

                IctTimestamp => '20010101000000',
                IctUrls      => {},
            },
        },
        {
            Name                 => 'AddInfo for incompletely synchronized ticket',
            Operation            => 'AddInfo',
            TicketSyncIncomplete => 1,
            Success              => 1,
            HandledError         => 1,
            Data                 => {
                IctAdditionalInfos => {},
                IctAttachments     => {},
                IctHead            => {
                    IncidentGuid     => "Solman-$RandomID1",
                    RequesterGuid    => 'DE86768CD3D015F181D0001438BF50C6',
                    ProviderGuid     => $LocalSystemGuid,
                    AgentId          => 1,
                    ReporterId       => 'stefan.bedorf@otrs.com',
                    ShortDescription => 'AddInfo Test',
                    Priority         => '4 high',
                    Language         => 'de',
                    RequestedBegin   => '20000101000000',
                    RequestedEnd     => '20111231235959',
                },
                IctPersons => {
                    item => {
                        PersonId    => 'stefan.bedorf@otrs.com',
                        PersonIdExt => 292,
                        Sex         => 'm',
                        FirstName   => 'Stefan',
                        LastName    => 'Bedorf',
                        Telephone   => {
                            PhoneNo          => '+49 9421 56818',
                            PhoneNoExtension => '0',
                        },
                        MobilePhone => '-',
                        Fax         => {
                            FaxNo          => '+49 9421 56818',
                            FaxNoExtension => '18',
                        },
                        Email => 'stefan.bedorf@otrs.com',
                    },
                },
                IctSapNotes   => {},
                IctSolutions  => {},
                IctStatements => {},

                IctTimestamp => '20010101000000',
                IctUrls      => {},
            },
        },
        {
            Name                  => 'AddInfo for incompletely synchronized articles',
            Operation             => 'AddInfo',
            ArticleSyncIncomplete => 1,
            Success               => 1,
            HandledError          => 1,
            Data                  => {
                IctAdditionalInfos => {},
                IctAttachments     => {},
                IctHead            => {
                    IncidentGuid     => "Solman-$RandomID1",
                    RequesterGuid    => 'DE86768CD3D015F181D0001438BF50C6',
                    ProviderGuid     => $LocalSystemGuid,
                    AgentId          => 1,
                    ReporterId       => 'stefan.bedorf@otrs.com',
                    ShortDescription => 'AddInfo Test',
                    Priority         => '4 high',
                    Language         => 'de',
                    RequestedBegin   => '20000101000000',
                    RequestedEnd     => '20111231235959',
                },
                IctPersons => {
                    item => {
                        PersonId    => 'stefan.bedorf@otrs.com',
                        PersonIdExt => 292,
                        Sex         => 'm',
                        FirstName   => 'Stefan',
                        LastName    => 'Bedorf',
                        Telephone   => {
                            PhoneNo          => '+49 9421 56818',
                            PhoneNoExtension => '0',
                        },
                        MobilePhone => '-',
                        Fax         => {
                            FaxNo          => '+49 9421 56818',
                            FaxNoExtension => '18',
                        },
                        Email => 'stefan.bedorf@otrs.com',
                    },
                },
                IctSapNotes   => {},
                IctSolutions  => {},
                IctStatements => {},

                IctTimestamp => '20010101000000',
                IctUrls      => {},
            },
        },
        {
            Name      => 'AcceptIncidentProcessing without statements, but with attachments',
            Operation => 'AcceptIncidentProcessing',
            Success   => 1,
            Data      => {
                IctAdditionalInfos => {},
                IctAttachments     => {
                    item => [
                        {
                            AttachmentGuid => "Solman-$RandomID1-4-1",
                            Filename       => 'test4.bin',
                            MimeType       => 'application/octet-stream',
                            Data           => 'ZWluIHRlc3Qgw6TDtsO8w5/DhMOWw5zigqw=',
                            Timestamp      => '20110324000000',
                            PersonId       => 1,
                            Url            => 'http://localhost',
                            Language       => 'de',
                            Delete         => ' ',
                        },
                        {
                            AttachmentGuid => "Solman-$RandomID1-5-1",
                            Filename       => 'test5.bin',
                            MimeType       => 'application/octet-stream',
                            Data           => 'ZWluIHRlc3Qgw6TDtsO8w5/DhMOWw5zigqw=',
                            Timestamp      => '20110324000000',
                            PersonId       => 1,
                            Url            => 'http://localhost',
                            Language       => 'de',
                            Delete         => '1',
                        },
                    ],
                },
                IctHead => {
                    IncidentGuid     => "Solman-$RandomID1",
                    RequesterGuid    => 'DE86768CD3D015F181D0001438BF50C6',
                    ProviderGuid     => $LocalSystemGuid,
                    AgentId          => 1,
                    ReporterId       => 'stefan.bedorf@otrs.com',
                    ShortDescription => 'AddInfo Test',
                    Priority         => '4 high',
                    Language         => 'de',
                    RequestedBegin   => '20000101000000',
                    RequestedEnd     => '20111231235959',
                },
                IctPersons => {
                    item => {
                        PersonId    => 'stefan.bedorf@otrs.com',
                        PersonIdExt => 292,
                        Sex         => 'm',
                        FirstName   => 'Stefan',
                        LastName    => 'Bedorf',
                        Telephone   => {
                            PhoneNo          => '+49 9421 56818',
                            PhoneNoExtension => '0',
                        },
                        MobilePhone => '-',
                        Fax         => {
                            FaxNo          => '+49 9421 56818',
                            FaxNoExtension => '18',
                        },
                        Email => 'stefan.bedorf@otrs.com',
                    },
                },
                IctSapNotes   => {},
                IctSolutions  => {},
                IctStatements => {
                    item => [],
                },

                IctTimestamp => '20010101000000',
                IctUrls      => {},
            },
        },
        {
            Name      => 'VerifyIncidentSolution',
            Operation => 'VerifyIncidentSolution',
            Success   => 1,
            Data      => {
                IctAdditionalInfos => {},
                IctAttachments     => {
                    item => [
                        {
                            AttachmentGuid => "Solman-$RandomID1-6-1",
                            Filename       => 'test6.bin',
                            MimeType       => 'application/octet-stream',
                            Data           => 'ZWluIHRlc3Qgw6TDtsO8w5/DhMOWw5zigqw=',
                            Timestamp      => '20110324000000',
                            PersonId       => 1,
                            Url            => 'http://localhost',
                            Language       => 'de',
                            Delete         => ' ',
                        },
                        {
                            AttachmentGuid => "Solman-$RandomID1-7-1",
                            Filename       => 'test7.bin',
                            MimeType       => 'application/octet-stream',
                            Data           => 'ZWluIHRlc3Qgw6TDtsO8w5/DhMOWw5zigqw=',
                            Timestamp      => '20110324000000',
                            PersonId       => 1,
                            Url            => 'http://localhost',
                            Language       => 'de',
                            Delete         => '1',
                        },
                    ],
                },
                IctHead => {
                    IncidentGuid     => "Solman-$RandomID1",
                    RequesterGuid    => 'DE86768CD3D015F181D0001438BF50C6',
                    ProviderGuid     => $LocalSystemGuid,
                    AgentId          => 1,
                    ReporterId       => 'stefan.bedorf@otrs.com',
                    ShortDescription => 'AddInfo Test',
                    Priority         => '4 high',
                    Language         => 'de',
                    RequestedBegin   => '20000101000000',
                    RequestedEnd     => '20111231235959',
                },
                IctPersons => {
                    item => {
                        PersonId    => 'stefan.bedorf@otrs.com',
                        PersonIdExt => 292,
                        Sex         => 'm',
                        FirstName   => 'Stefan',
                        LastName    => 'Bedorf',
                        Telephone   => {
                            PhoneNo          => '+49 9421 56818',
                            PhoneNoExtension => '0',
                        },
                        MobilePhone => '-',
                        Fax         => {
                            FaxNo          => '+49 9421 56818',
                            FaxNoExtension => '18',
                        },
                        Email => 'stefan.bedorf@otrs.com',
                    },
                },
                IctSapNotes   => {},
                IctSolutions  => {},
                IctStatements => {
                    item => [
                        {
                            TextType => 'note-internal',
                            Texts    => {
                                item => [
                                    'verify incident solution',
                                ],
                            },
                            Timestamp => '20110323000000',
                            PersonId  => 1,
                            Language  => 'de',
                        },
                    ],
                },

                IctTimestamp => '20010101000000',
                IctUrls      => {},
            },
        },
        {
            Name      => 'RejectIncidentSolution',
            Operation => 'RejectIncidentSolution',
            Success   => 1,
            Data      => {
                IctAdditionalInfos => {},
                IctAttachments     => {
                    item => [
                        {
                            AttachmentGuid => "Solman-$RandomID1-8-1",
                            Filename       => 'test8.bin',
                            MimeType       => 'application/octet-stream',
                            Data           => 'ZWluIHRlc3Qgw6TDtsO8w5/DhMOWw5zigqw=',
                            Timestamp      => '20110324000000',
                            PersonId       => 1,
                            Url            => 'http://localhost',
                            Language       => 'de',
                            Delete         => ' ',
                        },
                        {
                            AttachmentGuid => "Solman-$RandomID1-9-1",
                            Filename       => 'test9.bin',
                            MimeType       => 'application/octet-stream',
                            Data           => 'ZWluIHRlc3Qgw6TDtsO8w5/DhMOWw5zigqw=',
                            Timestamp      => '20110324000000',
                            PersonId       => 1,
                            Url            => 'http://localhost',
                            Language       => 'de',
                            Delete         => '1',
                        },
                    ],
                },
                IctHead => {
                    IncidentGuid     => "Solman-$RandomID1",
                    RequesterGuid    => 'DE86768CD3D015F181D0001438BF50C6',
                    ProviderGuid     => $LocalSystemGuid,
                    AgentId          => 1,
                    ReporterId       => 'stefan.bedorf@otrs.com',
                    ShortDescription => 'AddInfo Test',
                    Priority         => '4 high',
                    Language         => 'de',
                    RequestedBegin   => '20000101000000',
                    RequestedEnd     => '20111231235959',
                },
                IctPersons => {
                    item => {
                        PersonId    => 'stefan.bedorf@otrs.com',
                        PersonIdExt => 292,
                        Sex         => 'm',
                        FirstName   => 'Stefan',
                        LastName    => 'Bedorf',
                        Telephone   => {
                            PhoneNo          => '+49 9421 56818',
                            PhoneNoExtension => '0',
                        },
                        MobilePhone => '-',
                        Fax         => {
                            FaxNo          => '+49 9421 56818',
                            FaxNoExtension => '18',
                        },
                        Email => 'stefan.bedorf@otrs.com',
                    },
                },
                IctSapNotes   => {},
                IctSolutions  => {},
                IctStatements => {
                    item => [
                        {
                            TextType => 'note-internal',
                            Texts    => {
                                item => [
                                    'reject incident solution',
                                ],
                            },
                            Timestamp => '20110323000000',
                            PersonId  => 1,
                            Language  => 'de',
                        },
                    ],
                },

                IctTimestamp => '20010101000000',
                IctUrls      => {},
            },
        },
    ],
    [
        {
            Name      => 'ProcessIncident with {} instead of []',
            Operation => 'ProcessIncident',
            Success   => 1,
            Data      => {
                IctAdditionalInfos => {},
                IctAttachments     => {
                    item => {
                        AttachmentGuid => "Solman-$RandomID2-1-1",
                        Filename       => 'test.txt',
                        MimeType       => 'text/plain',
                        Data           => 'ZWluIHRlc3Qgw6TDtsO8w5/DhMOWw5zigqw=',
                        Timestamp      => '20110324000000',
                        PersonId       => 1,
                        Url            => 'http://localhost',
                        Language       => 'de',
                        Delete         => '',
                    },
                },
                IctHead => {
                    IncidentGuid     => "Solman-$RandomID2",
                    RequesterGuid    => 'DE86768CD3D015F181D0001438BF50C6',
                    ProviderGuid     => $LocalSystemGuid,
                    AgentId          => 1,
                    ReporterId       => 'stefan.bedorf@otrs.com',
                    ShortDescription => 'title',
                    Priority         => '2 low',
                    Language         => 'de',
                    RequestedBegin   => '20000101000000',
                    RequestedEnd     => '20111231235959',
                },
                IctId      => "Solman-$RandomID2",
                IctPersons => {
                    item => {
                        PersonId    => 'stefan.bedorf@otrs.com',
                        PersonIdExt => 292,
                        Sex         => 'm',
                        FirstName   => 'Stefan',
                        LastName    => 'Bedorf',
                        Telephone   => {
                            PhoneNo          => '+49 9421 56818',
                            PhoneNoExtension => '0',
                        },
                        MobilePhone => '-',
                        Fax         => {
                            FaxNo          => '+49 9421 56818',
                            FaxNoExtension => '18',
                        },
                        Email => 'stefan.bedorf@otrs.com',
                    },
                },
                IctSapNotes   => {},
                IctSolutions  => {},
                IctStatements => {
                    item => {
                        TextType => 'note-internal',

                        # text lines
                        Texts => {
                            item => [
                                'a line of text',
                                'another line',
                                'multiline
text
works too',
                            ],
                        },
                        Timestamp => '20110323000000',
                        PersonId  => 1,
                        Language  => 'de',
                    },
                },

                IctTimestamp => '20010101000000',
                IctUrls      => {},
            },
        },
        {
            Name      => 'CloseIncident',
            Operation => 'CloseIncident',
            Success   => 1,
            Data      => {
                IctAdditionalInfos => {},
                IctAttachments     => {},
                IctHead            => {
                    IncidentGuid     => "Solman-$RandomID2",
                    RequesterGuid    => 'DE86768CD3D015F181D0001438BF50C6',
                    ProviderGuid     => $LocalSystemGuid,
                    AgentId          => 1,
                    ReporterId       => 'stefan.bedorf@otrs.com',
                    ShortDescription => 'title',
                    Priority         => '2 low',
                    Language         => 'de',
                    RequestedBegin   => '20000101000000',
                    RequestedEnd     => '20111231235959',
                },
                IctId      => "Solman-$RandomID2",
                IctPersons => {
                    item => {
                        PersonId    => 'stefan.bedorf@otrs.com',
                        PersonIdExt => 292,
                        Sex         => 'm',
                        FirstName   => 'Stefan',
                        LastName    => 'Bedorf',
                        Telephone   => {
                            PhoneNo          => '+49 9421 56818',
                            PhoneNoExtension => '0',
                        },
                        MobilePhone => '-',
                        Fax         => {
                            FaxNo          => '+49 9421 56818',
                            FaxNoExtension => '18',
                        },
                        Email => 'stefan.bedorf@otrs.com',
                    },
                },
                IctSapNotes   => {},
                IctSolutions  => {},
                IctStatements => {},

                IctTimestamp => '20010101000000',
                IctUrls      => {},
            },
        },
    ],
    [
        {
            Name         => 'ProcessIncident with wrong RequesterGuid',
            Operation    => 'ProcessIncident',
            Success      => 1,
            HandledError => 1,
            Data         => {
                IctAdditionalInfos => {},
                IctAttachments     => {},
                IctHead            => {
                    IncidentGuid     => "Solman-$RandomID2",
                    RequesterGuid    => 'wrong_value',
                    ProviderGuid     => $LocalSystemGuid,
                    AgentId          => 1,
                    ReporterId       => 'stefan.bedorf@otrs.com',
                    ShortDescription => 'title',
                    Priority         => '2 low',
                    Language         => 'de',
                    RequestedBegin   => '20000101000000',
                    RequestedEnd     => '20111231235959',
                },
                IctId      => "Solman-$RandomID2",
                IctPersons => {
                    item => {
                        PersonId    => 'stefan.bedorf@otrs.com',
                        PersonIdExt => 292,
                        Sex         => 'm',
                        FirstName   => 'Stefan',
                        LastName    => 'Bedorf',
                        Telephone   => {
                            PhoneNo          => '+49 9421 56818',
                            PhoneNoExtension => '0',
                        },
                        MobilePhone => '-',
                        Fax         => {
                            FaxNo          => '+49 9421 56818',
                            FaxNoExtension => '18',
                        },
                        Email => 'stefan.bedorf@otrs.com',
                    },
                },
                IctSapNotes   => {},
                IctSolutions  => {},
                IctStatements => {},
                IctTimestamp  => '20010101000000',
                IctUrls       => {},
            },
        },
    ],
    [
        {
            Name         => 'ProcessIncident with wrong RequesterGuid',
            Operation    => 'ProcessIncident',
            Success      => 1,
            HandledError => 1,
            Data         => {
                IctAdditionalInfos => {},
                IctAttachments     => {},
                IctHead            => {
                    IncidentGuid     => "Solman-$RandomID2",
                    RequesterGuid    => 'DE86768CD3D015F181D0001438BF50C6',
                    ProviderGuid     => 'wrong_value',
                    AgentId          => 1,
                    ReporterId       => 'stefan.bedorf@otrs.com',
                    ShortDescription => 'title',
                    Priority         => '2 low',
                    Language         => 'de',
                    RequestedBegin   => '20000101000000',
                    RequestedEnd     => '20111231235959',
                },
                IctId      => "Solman-$RandomID2",
                IctPersons => {
                    item => {
                        PersonId    => 'stefan.bedorf@otrs.com',
                        PersonIdExt => 292,
                        Sex         => 'm',
                        FirstName   => 'Stefan',
                        LastName    => 'Bedorf',
                        Telephone   => {
                            PhoneNo          => '+49 9421 56818',
                            PhoneNoExtension => '0',
                        },
                        MobilePhone => '-',
                        Fax         => {
                            FaxNo          => '+49 9421 56818',
                            FaxNoExtension => '18',
                        },
                        Email => 'stefan.bedorf@otrs.com',
                    },
                },
                IctSapNotes   => {},
                IctSolutions  => {},
                IctStatements => {},
                IctTimestamp  => '20010101000000',
                IctUrls       => {},
            },
        },
    ],
);

TESTCHAIN:
for my $TestChain (@Tests) {

    my @TestTicketIDs;

    $Self->True(
        1,
        '------------ STARTING NEW TEST CHAIN ------------',
    );

    my $LastTicketID;

    TEST:
    for my $Test ( @{$TestChain} ) {

        # create object
        my $OperationObject = Kernel::GenericInterface::Operation->new(
            %{$Self},
            ConfigObject   => $ConfigObject,
            DebuggerObject => $DebuggerObject,
            WebserviceID   => $WebserviceID,
            OperationType  => "SolMan::$Test->{Operation}",
        );

        $Self->Is(
            ref $OperationObject,
            'Kernel::GenericInterface::Operation',
            'Operation::new() success',
        );

        next TEST if ref $OperationObject ne 'Kernel::GenericInterface::Operation';

        # Bring the ticket out of sync by updating it.
        if ( $LastTicketID && $Test->{TicketSyncIncomplete} ) {

            # Wait a little bit to make sure that the new ticket change time really is later.
            sleep 2;

            # enable archive system feature for all systems to match tests
            $ConfigObject->Set(
                Key   => 'Ticket::ArchiveSystem',
                Value => 1,
            );

            my $SetSuccess = $TicketObject->TicketArchiveFlagSet(
                ArchiveFlag => 'y',
                TicketID    => $LastTicketID,
                UserID      => 1,
            );

            $Self->True(
                $SetSuccess,
                "$Test->{Name} ticket archive flag updated in test case to make ticket synchronization incomplete",
            );

            my $UnSetSuccess = $TicketObject->TicketArchiveFlagSet(
                ArchiveFlag => 'n',
                TicketID    => $LastTicketID,
                UserID      => 1,
            );

            $Self->True(
                $UnSetSuccess,
                "$Test->{Name} ticket archive flag updated in test case to make ticket synchronization incomplete",
            );
        }

        # Bring the ticket out of sync by updating it.
        if ( $LastTicketID && $Test->{ArticleSyncIncomplete} ) {

            my %TicketFlags = $TicketObject->TicketFlagGet(
                TicketID => $LastTicketID,
                UserID   => 1,
            );

            # get last sync timestamp
            my $LastSync = $TicketFlags{"GI_${WebserviceID}_SolMan_SyncTimestamp"} || 0;

            # Wait a little bit to make sure that the new ticket change time really is later.
            sleep 2;

            my $ArticleID = $TicketObject->ArticleCreate(
                TicketID    => $LastTicketID,
                ArticleType => 'note-internal',    # this will be converted in the mapping layer
                SenderType  => 'system',
                From           => 'Some Agent <email@example.com>',
                Subject        => "Dummy test article",
                Body           => '',
                Charset        => 'utf-8',
                MimeType       => 'text/plain',
                HistoryType    => 'AddNote',
                HistoryComment => 'Dummy test article',
                UserID         => 1,
            );

            $Self->True(
                $ArticleID,
                "$Test->{Name} article $ArticleID added to ticket in test case to make ticket synchronization incomplete",
            );

            my %Article = $TicketObject->ArticleGet(
                ArticleID => $ArticleID,
                User      => 1,
            );
        }

        # use mapping if mapping config is defined
        my $MappingConfig =
            $WebserviceConfig->{Provider}->{Operation}->{ $Test->{Operation} }->{MappingInbound};
        if ($MappingConfig) {
            my $MappingObject = Kernel::GenericInterface::Mapping->new(
                %{$Self},
                DebuggerObject => $DebuggerObject,
                MappingConfig  => $MappingConfig,
            );

            $Self->Is(
                ref $MappingObject,
                'Kernel::GenericInterface::Mapping',
                'Mapping::new() success',
            );

            my $MappingResult = $MappingObject->Map(
                Data => $Test->{Data},
            );

            $Self->Is(
                $MappingResult->{Success},
                1,
                "Mapping success status",
            );
            $Test->{Data} = $MappingResult->{Data};
        }

        my $Result = $OperationObject->Run(
            Data => $Test->{Data},
        );

        $Self->Is(
            $Result->{Success} ? 1 : 0,
            $Test->{Success}   ? 1 : 0,
            "$Test->{Name} Run() success status",
        );

        if (
            $LastTicketID
            && ( $Test->{TicketSyncIncomplete} || $Test->{ArticleSyncIncomplete} )
            )
        {

            # Set synchronization timestamp to let subsequent tests work ok on this ticket.
            my $SuccessTicketFlagSet = $TicketObject->TicketFlagSet(
                TicketID => $LastTicketID,
                Key      => "GI_${WebserviceID}_SolMan_SyncTimestamp",
                Value    => $Self->{TimeObject}->SystemTime(),
                UserID   => 1,
            );
        }

        if ( !$Test->{Success} || $Test->{HandledError} ) {

            $Self->True(
                $Result->{ErrorMessage},
                "$Test->{Name} error message",
            );

            $Self->Is(
                ref $Result->{Data}->{Errors},
                'HASH',
                "$Test->{Name} SolMan error structure returned",
            );

            next TEST if ref $Result->{Data}->{Errors} ne 'HASH';

            $Self->True(
                $Result->{Data}->{Errors}->{item}->[0]->{ErrorCode},
                "$Test->{Name} SolMan error code",
            );

            $Self->True(
                $Result->{Data}->{Errors}->{item}->[0]->{Val1},
                "$Test->{Name} SolMan error message 1",
            );

            $Self->True(
                exists $Result->{Data}->{Errors}->{item}->[0]->{Val2},
                "$Test->{Name} SolMan error message 2",
            );

            $Self->True(
                exists $Result->{Data}->{Errors}->{item}->[0]->{Val3},
                "$Test->{Name} SolMan error message 3",
            );

            $Self->True(
                exists $Result->{Data}->{Errors}->{item}->[0]->{Val4},
                "$Test->{Name} SolMan error message 4",
            );

            next TEST;
        }

        $Self->False(
            $Result->{Errors},
            "$Test->{Name} did not yield errors",
        );

        my %TicketCreatingOperations = (
            'ReplicateIncident' => 1,
            'ProcessIncident'   => 1,
        );

        # a new ticket was created, remember the data of this
        if ( $TicketCreatingOperations{ $Test->{Operation} } ) {
            $Self->True(
                $Result->{Data}->{PrdIctId},
                "$Test->{Name} returned a ProviderIncidentID",
            );

            $LastTicketID = $TicketObject->TicketIDLookup(
                TicketNumber => $Result->{Data}->{PrdIctId},
                UserID       => 1,
            );
        }

        $Self->True(
            $LastTicketID,
            "$Test->{Name} Ticket found",
        );

        if ($LastTicketID) {
            push @TestTicketIDs, $LastTicketID;
        }

        $TicketObject->{CacheInternalObject}->CleanUp();

        # recreate TicketObject to avoid problems with the in-memory cache
        $TicketObject = Kernel::System::Ticket->new(
            %{$Self},
            ConfigObject => $ConfigObject,
        );

        my %TicketData = $TicketObject->TicketGet(
            TicketID => $LastTicketID,
            UserID   => 1,
            Extended => 1,
        );

        if ( $TicketCreatingOperations{ $Test->{Operation} } ) {
            $Self->Is(
                $TicketData{TicketNumber},
                $Result->{Data}->{PrdIctId},
                "$Test->{Name} Ticket data contains correct TicketNumber",
            );
        }

        if ( $Test->{Data}->{IctHead}->{ShortDescription} ) {
            $Self->Is(
                $TicketData{Title},
                $Test->{Data}->{IctHead}->{ShortDescription},
                "$Test->{Name} Ticket data contains correct Title",
            );
        }

        if ( $Test->{Data}->{IctHead}->{Priority} ) {
            $Self->Is(
                $TicketData{Priority},
                $Test->{Data}->{IctHead}->{Priority},
                "$Test->{Name} Ticket data contains correct Priority",
            );
        }

        if ( $Test->{Data}->{IctHead}->{ReporterId} ) {
            $Self->Is(
                $TicketData{CustomerUserID},
                $Test->{Data}->{IctHead}->{ReporterId},
                "$Test->{Name} Ticket data contains correct customer",
            );
        }

        if ( $MappingConfig && $Test->{Expected} ) {
            if ( $Test->{Expected}->{Priority} ) {
                $Self->Is(
                    $TicketData{Priority},
                    $Test->{Expected}->{Priority},
                    "$Test->{Name} Ticket data contains correct Priority after mapping",
                );
            }
            if ( $Test->{Expected}->{State} ) {
                $Self->Is(
                    $TicketData{State},
                    $Test->{Expected}->{State},
                    "$Test->{Name} Ticket data contains correct State after mapping",
                );
            }
            my $MapTicketFreeText = $Test->{Expected}->{TicketFreeText};
            if ( ref $MapTicketFreeText eq 'HASH' ) {
                for my $Number ( sort keys %{$MapTicketFreeText} ) {
                    $Self->Is(
                        $TicketData{ 'TicketFreeText' . $Number },
                        $MapTicketFreeText->{$Number},
                        "$Test->{Name} Ticket data contains correct TicketFreeText$Number"
                            . " after mapping",
                    );
                }
            }
        }

        my @ArticleIDs = $TicketObject->ArticleIndex(
            TicketID => $LastTicketID,
        );

        if (
            $Test->{Data}->{IctStatements}->{item}
            && ref $Test->{Data}->{IctStatements}->{item} ne 'ARRAY'
            )
        {
            $Test->{Data}->{IctStatements}->{item} = [ $Test->{Data}->{IctStatements}->{item} ];
        }

        my @CompareArticleIDs = @ArticleIDs;
        my $ExpectedArticleTypes;
        if ( $Test->{Expected} ) {
            $ExpectedArticleTypes = $Test->{Expected}->{ArticleType} || [];
        }
        TEST_STATEMENT_ITEM:
        for my $TestStatementItem ( reverse @{ $Test->{Data}->{IctStatements}->{item} || [] } ) {

            my $SubjectExpected;
            my ( $Year, $Month, $Day, $Hour, $Minute, $Second ) = $TestStatementItem->{Timestamp} =~
                m{ \A ( \d{4} ) ( \d{2} ) ( \d{2} ) ( \d{2} ) ( \d{2} ) ( \d{2} ) \z }xms;
            if ( $Year && $Month && $Day && $Hour && $Minute && $Second ) {
                $SubjectExpected .= " $Day.$Month.$Year $Hour:$Minute:$Second (+0)";
            }

            my $BodyExpected .= join( "\n", @{ $TestStatementItem->{Texts}->{item} || [] } );

            # get last article from ticket
            my $ArticleID = pop @CompareArticleIDs;

            my %Article = $TicketObject->ArticleGet(
                ArticleID => $ArticleID,
                UserID    => 1,
            );

            $Self->True(
                $Article{ArticleID},
                "$Test->{Name} plaintext article found for IctStatemtent",
            );
            next TEST_STATEMENT_ITEM if !%Article;

            $Self->Is(
                $Article{Subject},
                $SubjectExpected,
                "$Test->{Name} plaintext article subject match for IctStatemtent",
            );

            $Self->Is(
                $Article{Body},
                $BodyExpected,
                "$Test->{Name} plaintext article body match for IctStatemtent",
            );

            if ( defined $ExpectedArticleTypes ) {
                my $ExpectedArticleType = pop @{$ExpectedArticleTypes};
                $Self->Is(
                    $Article{ArticleType},
                    $ExpectedArticleType,
                    "$Test->{Name} plaintext article type match for IctStatemtent",
                );
            }
        }

        if (
            $Test->{Data}->{IctAttachments}->{item}
            && ref $Test->{Data}->{IctAttachments}->{item} ne 'ARRAY'
            )
        {
            $Test->{Data}->{IctAttachments}->{item} = [ $Test->{Data}->{IctAttachments}->{item} ];
        }

        TEST_ATTACHMENT_ITEM:
        for my $TestAttachmentItem ( @{ $Test->{Data}->{IctAttachments}->{item} } ) {

            # should the attachment be created or deleted?
            my $DeleteFlag
                = ( $TestAttachmentItem->{Delete} ne '' && $TestAttachmentItem->{Delete} ne ' ' )
                ? 1
                : 0;

            # try to find current attachment item in Ticket attachments
            ARTICLE_ID:
            for my $ArticleID (@ArticleIDs) {

                my %ArticleAttachmentIndex = $TicketObject->ArticleAttachmentIndex(
                    ArticleID => $ArticleID,
                    UserID    => 1,
                );

                # check if the current article has this attachment
                ATTACHMENT_INDEX_ENTRY:
                for my $AttachmentID ( sort keys %ArticleAttachmentIndex ) {
                    if (
                        $ArticleAttachmentIndex{$AttachmentID}->{Filename}
                        eq $TestAttachmentItem->{Filename}
                        )
                    {
                        if ($DeleteFlag) {

                            # Attachment with delete flag was found, show error
                            $Self->False(
                                1,
                                "$Test->{Name} Ticket data attachment $TestAttachmentItem->{Filename} with delete flag was found",
                            );

                        }
                        else {

                            # Success, attachment found
                            $Self->Is(
                                $ArticleAttachmentIndex{$AttachmentID}->{Filename},
                                $TestAttachmentItem->{Filename},
                                "$Test->{Name} found attachment",
                            );

                            my %Attachment = $TicketObject->ArticleAttachment(
                                ArticleID => $ArticleID,
                                FileID    => $AttachmentID,
                                UserID    => 1,
                            );

                            $Self->Is(
                                $Attachment{Content},
                                MIME::Base64::decode_base64( $TestAttachmentItem->{Data} ),
                                "$Test->{Name} attachment content for $TestAttachmentItem->{Filename}",
                            );

                            $Self->Is(
                                $Attachment{ContentType},
                                $TestAttachmentItem->{MimeType},
                                "$Test->{Name} attachment content type for $TestAttachmentItem->{Filename}",
                            );
                        }

                        next TEST_ATTACHMENT_ITEM;
                    }
                }
            }

            if ($DeleteFlag) {

                # Attachment with delete flag was not found
                $Self->True(
                    1,
                    "$Test->{Name} Ticket data attachment $TestAttachmentItem->{Filename} with delete flag was not found",
                );
            }
            else {

                # Attachment that should be created was not found, show error
                $Self->Is(
                    '',
                    $TestAttachmentItem->{Filename},
                    "$Test->{Name} Ticket data found attachment",
                );
            }

        }

        if ( $Test->{Operation} eq 'CloseIncident' ) {
            $Self->Is(
                $TicketData{State},
                'closed successful',
                "$Test->{Name} Ticket was closed",
            );
        }
        else {
            $Self->IsNot(
                $TicketData{State},
                'closed successful',
                "$Test->{Name} Ticket is not closed",
            );
        }

    }    # END TEST

    # delete tickets
    for my $TicketID (@TestTicketIDs) {
        $Self->True(
            $TicketObject->TicketDelete(
                TicketID => $TicketID,
                UserID   => 1,
            ),
            "TicketDelete()",
        );
    }

    $Self->True(
        1,
        '------------ END OF TEST CHAIN ------------',
    );

}    # END TESTCHAIN

# delete config
my $Success = $WebserviceObject->WebserviceDelete(
    ID     => $WebserviceID,
    UserID => 1,
);

$Self->True(
    $Success,
    "WebserviceDelete()",
);

1;
