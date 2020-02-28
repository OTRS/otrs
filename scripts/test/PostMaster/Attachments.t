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

# get needed objects
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $MainObject   = $Kernel::OM->Get('Kernel::System::Main');

# ensure that the appropriate X-Headers are available in the config
my %NeededXHeaders = (
    'X-OTRS-AttachmentExists' => 1,
    'X-OTRS-AttachmentCount'  => 1,
);

my $XHeaders          = $ConfigObject->Get('PostmasterX-Header');
my @PostmasterXHeader = @{$XHeaders};

HEADER:
for my $Header ( sort keys %NeededXHeaders ) {

    my $IsInConfig = 0;

    # Verify header is already part of the config
    $IsInConfig = 1 if ( grep { $_ eq $Header } @PostmasterXHeader );

    $Self->True(
        $IsInConfig,
        "Headermight be in config already: $Header.",
    );
}

my @DynamicfieldIDs;
my @DynamicFieldUpdate;

my %NeededDynamicfields = (
    TicketFreeText1 => 1,
    TicketFreeText2 => 1,
);

# list available dynamic fields
my $DynamicFields = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldList(
    Valid      => 0,
    ResultType => 'HASH',
);
$DynamicFields = ( ref $DynamicFields eq 'HASH' ? $DynamicFields : {} );
$DynamicFields = { reverse %{$DynamicFields} };

for my $FieldName ( sort keys %NeededDynamicfields ) {
    if ( !$DynamicFields->{$FieldName} ) {

        # create a dynamic field
        my $FieldID = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldAdd(
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

        push @DynamicfieldIDs, $FieldID;
    }
    else {
        my $DynamicField
            = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldGet( ID => $DynamicFields->{$FieldName} );

        if ( $DynamicField->{ValidID} > 1 ) {
            push @DynamicFieldUpdate, $DynamicField;
            $DynamicField->{ValidID} = 1;
            my $SuccessUpdate = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldUpdate(
                %{$DynamicField},
                Reorder => 0,
                UserID  => 1,
                ValidID => 1,
            );

            # verify dynamic field creation
            $Self->True(
                $SuccessUpdate,
                "DynamicFieldUpdate() successful update for Field $DynamicField->{Name}",
            );
        }
    }
}

# disable not needed event module
$ConfigObject->Set(
    Key => 'Ticket::EventModulePost###9600-TicketDynamicFieldDefault',
);

# Read email content (from a file).
my $EmailAttachment = $MainObject->FileRead(
    Location => $ConfigObject->Get('Home') . '/scripts/test/sample/EmailParser/MultipartMixedPlain.eml',

    # Type            => 'Attachment',
    Result => 'ARRAY',
);

# Read email content that contains inline image.
my $EmailInlineImage = $MainObject->FileRead(
    Location => $ConfigObject->Get('Home') . '/scripts/test/sample/PostMaster/InlineImage.box',
    Result   => 'ARRAY',
);

# Workaround due used email have not a From value
unshift @{$EmailAttachment}, 'From: Sender <sender@example.com>';

# filter test
my @Tests = (
    {
        Name  => '#1 - No attachments',
        Match => [
            {
                Key   => 'X-OTRS-AttachmentExists',
                Value => 'no',
            },
            {
                Key   => 'X-OTRS-AttachmentCount',
                Value => 0,
            }
        ],
        Set => [
            {
                Key   => 'X-OTRS-DynamicField-TicketFreeText1',
                Value => 'No Attachments in mail',
            },
            {
                Key   => 'X-OTRS-DynamicField-TicketFreeText2',
                Value => 'CeroAttachments',
            },
        ],
        Check => {
            DynamicField_TicketFreeText1 => 'No Attachments in mail',
            DynamicField_TicketFreeText2 => 'CeroAttachments',
        },
        Email => 'From: Sender <sender@example.com>
    To: Some Name <recipient@example.com>
    Subject: Server: example.tld

    This is a multiline
    email for server: example.tld

    The IP address: 192.168.0.1
    '
    },
    {
        Name  => '#2 - With Attachment',
        Match => [
            {
                Key   => 'X-OTRS-AttachmentExists',
                Value => 'yes',
            },
            {
                Key   => 'X-OTRS-AttachmentCount',
                Value => 1,
            }
        ],
        Set => [
            {
                Key   => 'X-OTRS-DynamicField-TicketFreeText1',
                Value => 'A normal SMIME email',
            },
            {
                Key   => 'X-OTRS-DynamicField-TicketFreeText2',
                Value => 'AtLeastOneAttachment',
            },
        ],
        Check => {
            DynamicField_TicketFreeText1 => 'A normal SMIME email',
            DynamicField_TicketFreeText2 => 'AtLeastOneAttachment',
        },
        Email => $EmailAttachment,
    },
    {
        Name  => '#3 - With Inline Images',
        Match => [
            {
                Key   => 'X-OTRS-AttachmentExists',
                Value => 'yes',
            },
            {
                Key   => 'X-OTRS-AttachmentCount',
                Value => 1,
            }
        ],
        Set => [
            {
                Key   => 'X-OTRS-DynamicField-TicketFreeText1',
                Value => 'This should not be set',
            },
            {
                Key   => 'X-OTRS-DynamicField-TicketFreeText2',
                Value => 'This should not be set',
            },
        ],
        Check => {
            DynamicField_TicketFreeText1 => undef,
            DynamicField_TicketFreeText2 => undef,
        },
        Email => $EmailInlineImage,
    },
);

$Kernel::OM->ObjectsDiscard( Objects => ['Kernel::System::PostMaster::Filter'] );
my $PostMasterFilter = $Kernel::OM->Get('Kernel::System::PostMaster::Filter');

for my $Test (@Tests) {
    $PostMasterFilter->FilterAdd(
        Name           => $Test->{Name},
        StopAfterMatch => 0,
        %{$Test},
    );

    my $Email = $Test->{Email};

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
            Email                  => $Email,
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
        1,
        "#Filter Run() - NewTicket",
    );
    $Self->True(
        $Return[1] || 0,
        "#Filter Run() - NewTicket/TicketID",
    );

    # new/clear ticket object
    $Kernel::OM->ObjectsDiscard( Objects => ['Kernel::System::Ticket'] );
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    my %Ticket = $TicketObject->TicketGet(
        TicketID      => $Return[1],
        DynamicFields => 1,
    );

    for my $Key ( sort keys %{ $Test->{Check} } ) {
        $Self->Is(
            $Ticket{$Key},
            $Test->{Check}->{$Key},
            "#Filter Run('$Test->{Name}') - $Key",
        );
    }

    # delete ticket
    my $Delete = $TicketObject->TicketDelete(
        TicketID => $Return[1],
        UserID   => 1,
    );
    $Self->True(
        $Delete || 0,
        "#Filter TicketDelete()",
    );

    # remove filter
    $PostMasterFilter->FilterDelete( Name => $Test->{Name} );
}

# cleanup is done by RestoreDatabase

1;
