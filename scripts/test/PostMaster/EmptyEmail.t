# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

## no critic (Modules::RequireExplicitPackage)
use strict;
use warnings;
use utf8;

use vars (qw($Self));

use Kernel::System::PostMaster;

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $ConfigObject  = $Kernel::OM->Get('Kernel::Config');
my $MainObject    = $Kernel::OM->Get('Kernel::System::Main');
my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');

for my $Backend (qw(DB FS)) {

    # Change the article storage backend.
    $Helper->ConfigSettingChange(
        Key   => 'Ticket::Article::Backend::MIMEBase::ArticleStorage',
        Value => 'Kernel::System::Ticket::Article::Backend::MIMEBase::ArticleStorage' . $Backend,
    );

    # Re-create article backend object for every run, in order to reflect the article storage backend change.
    my $ArticleBackendObject = $ArticleObject->BackendForChannel( ChannelName => 'Email' );

    my $Location = $ConfigObject->Get('Home')
        . '/scripts/test/sample/EmailParser/EmptyEmail.eml';

    my $ContentRef = $MainObject->FileRead(
        Location => $Location,
        Mode     => 'binmode',
        Result   => 'ARRAY',
    );

    my $TicketID;
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
            Email                  => $ContentRef,
        );

        my @Return = $PostMasterObject->Run();

        $TicketID = $Return[1];

        $CommunicationLogObject->ObjectLogStop(
            ObjectLogType => 'Message',
            Status        => 'Successful',
        );
        $CommunicationLogObject->CommunicationStop(
            Status => 'Successful',
        );
    }

    $Self->True(
        $TicketID,
        "$Backend - Ticket created"
    );

    my @ArticleIDs = map { $_->{ArticleID} } $ArticleObject->ArticleList( TicketID => $TicketID );
    $Self->True(
        $ArticleIDs[0],
        "$Backend - Article created"
    );

    my %Article = $ArticleBackendObject->ArticleGet(
        ArticleID => $ArticleIDs[0],
        TicketID  => $TicketID,
    );

    $Self->Is(
        $Article{Body} // '',    # Oracle stores '' as undef.
        '',
        'Empty article body found'
    );

    my %Attachments = $ArticleBackendObject->ArticleAttachmentIndex(
        ArticleID => $ArticleIDs[0],
    );

    $Self->IsDeeply(
        $Attachments{2},
        {
            'ContentAlternative' => '',
            'ContentID'          => '',
            'ContentType'        => 'application/x-download; name="=?UTF-8?Q?=C5=81atwa_sprawa.txt?="',
            'Disposition'        => 'attachment',
            'Filename'           => 'Łatwa_sprawa.txt',
            'FilesizeRaw'        => 0
        },
        "$Backend - Attachment filename"
    );
}

# cleanup is done by RestoreDatabase.

1;
