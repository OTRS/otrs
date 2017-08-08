# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

## no critic (Modules::RequireExplicitPackage)
use strict;
use warnings;
use utf8;

use vars (qw($Self));

use Kernel::System::PostMaster;

# get needed objects
my $ConfigObject         = $Kernel::OM->Get('Kernel::Config');
my $ArticleObject        = $Kernel::OM->Get('Kernel::System::Ticket::Article');
my $ArticleBackendObject = $ArticleObject->BackendForChannel( ChannelName => 'Email' );
my $MainObject           = $Kernel::OM->Get('Kernel::System::Main');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

for my $Backend (qw(DB FS)) {

    $ConfigObject->Set(
        Key   => 'Ticket::Article::Backend::MIMEBase::ArticleStorage',
        Value => 'Kernel::System::Ticket::ArticleStorage' . $Backend,
    );

    my $Location = $ConfigObject->Get('Home')
        . "/scripts/test/sample/EmailParser/EmptyEmail.eml";

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
                Start     => 1,
                }
        );
        my $MessageID = $CommunicationLogObject->ObjectLogStart( ObjectType => 'Message' );

        my $PostMasterObject = Kernel::System::PostMaster->new(
            CommunicationLogObject    => $CommunicationLogObject,
            CommunicationLogMessageID => $MessageID,
            Email                     => $ContentRef,
        );

        my @Return = $PostMasterObject->Run();

        $TicketID = $Return[1];

        $CommunicationLogObject->ObjectLogStop(
            ObjectType => 'Message',
            ObjectID   => $MessageID,
            Status     => 'Successful',
        );
        $CommunicationLogObject->CommunicationStop(
            Status => 'Successful',
        );
    }

    $Self->True(
        $TicketID,
        "$Backend - Ticket created",
    );

    my @ArticleIDs = map { $_->{ArticleID} } $ArticleObject->ArticleList( TicketID => $TicketID );
    $Self->True(
        $ArticleIDs[0],
        "$Backend - Article created",
    );

    my %Article = $ArticleBackendObject->ArticleGet(
        ArticleID => $ArticleIDs[0],
        TicketID  => $TicketID,
    );

    $Self->Is(
        $Article{Body} // '',    # Oracle stores '' as undef.
        '',
        "Empty article body found"
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
            'Filename'           => 'Łatwa sprawa.txt',
            'FilesizeRaw'        => 0
        },
        "$Backend - Attachment filename",
    );
}

# cleanup is done by RestoreDatabase.

1;
