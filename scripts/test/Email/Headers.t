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

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# Disable email addresses checking.
$Helper->ConfigSettingChange(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

# do not really send emails
$Kernel::OM->Get('Kernel::Config')->Set(
    Key   => 'SendmailModule',
    Value => 'Kernel::System::Email::DoNotSendEmail',
);

my $SendEmail = sub {
    my %Param = @_;

    my $EmailObject     = $Kernel::OM->Get('Kernel::System::Email');
    my $MailQueueObject = $Kernel::OM->Get('Kernel::System::MailQueue');

    # Delete mail queue
    $MailQueueObject->Delete();

    # Generate the mail and queue it
    $EmailObject->Send( %Param, );

    # Get last item in the queue.
    my $Items = $MailQueueObject->List();
    $Items = [ sort { $b->{ID} <=> $a->{ID} } @{$Items} ];
    my $LastItem = $Items->[0];

    my $Result = $MailQueueObject->Send( %{$LastItem} );

    return {
        Data => $LastItem->{Message},
    };
};

# Check that long references and in-reply-to headers are correctly split across lines.
# See bug#9345 and RFC5322.
my $MsgIDShort = '<54DEDF2@xyz-intra.net>';
my $MsgIDLong  = '<54DEDF2AD94D34F9A6C123E21D7CA6102A2E7HHIDHDGSUFKF@EFNPNCY115.xyz-intra.net>';

my @Tests = (
    {
        Name         => "Short MSGID 2x",
        Header       => $MsgIDShort x 2,
        FoldedHeader => '<54DEDF2@xyz-intra.net><54DEDF2@xyz-intra.net>',
    },

    {
        Name         => "Short MSGID 2x",
        Header       => $MsgIDShort x 10,
        FoldedHeader => '<54DEDF2@xyz-intra.net><54DEDF2@xyz-intra.net><54DEDF2@xyz-intra.net>
 <54DEDF2@xyz-intra.net><54DEDF2@xyz-intra.net><54DEDF2@xyz-intra.net>
 <54DEDF2@xyz-intra.net><54DEDF2@xyz-intra.net><54DEDF2@xyz-intra.net>
 <54DEDF2@xyz-intra.net>',
    },
    {
        Name         => "Long MSGID 10x",
        Header       => $MsgIDLong x 10,
        FoldedHeader => '<54DEDF2AD94D34F9A6C123E21D7CA6102A2E7HHIDHDGSUFKF@EFNPNCY115.xyz-intra.net>
 <54DEDF2AD94D34F9A6C123E21D7CA6102A2E7HHIDHDGSUFKF@EFNPNCY115.xyz-intra.net>
 <54DEDF2AD94D34F9A6C123E21D7CA6102A2E7HHIDHDGSUFKF@EFNPNCY115.xyz-intra.net>
 <54DEDF2AD94D34F9A6C123E21D7CA6102A2E7HHIDHDGSUFKF@EFNPNCY115.xyz-intra.net>
 <54DEDF2AD94D34F9A6C123E21D7CA6102A2E7HHIDHDGSUFKF@EFNPNCY115.xyz-intra.net>
 <54DEDF2AD94D34F9A6C123E21D7CA6102A2E7HHIDHDGSUFKF@EFNPNCY115.xyz-intra.net>
 <54DEDF2AD94D34F9A6C123E21D7CA6102A2E7HHIDHDGSUFKF@EFNPNCY115.xyz-intra.net>
 <54DEDF2AD94D34F9A6C123E21D7CA6102A2E7HHIDHDGSUFKF@EFNPNCY115.xyz-intra.net>
 <54DEDF2AD94D34F9A6C123E21D7CA6102A2E7HHIDHDGSUFKF@EFNPNCY115.xyz-intra.net>
 <54DEDF2AD94D34F9A6C123E21D7CA6102A2E7HHIDHDGSUFKF@EFNPNCY115.xyz-intra.net>',
    },
);

for my $Test (@Tests) {
    my $Result = $SendEmail->(
        From       => 'john.smith@example.com',
        To         => 'john.smith2@example.com',
        Subject    => 'some subject',
        Body       => 'Some Body',
        MimeType   => 'text/html',
        Charset    => 'utf8',
        References => $Test->{Header},
        InReplyTo  => $Test->{Header},
    );

    my ($ReferencesHeader) = $Result->{Data}->{Header} =~ m{^(References:.*?)(^\S|\z)}xms;
    my ($InReplyToHeader)  = $Result->{Data}->{Header} =~ m{^(In-Reply-To:.*?)(^\S|\z)}xms;

    $Self->Is(
        $ReferencesHeader,
        "References: $Test->{FoldedHeader}\n",
        'Check that references header is split across lines',
    );

    $Self->Is(
        $InReplyToHeader,
        "In-Reply-To: $Test->{FoldedHeader}\n",
        'Check that in-reply-to header is split across lines',
    );
}

# call Send a

#
# Check header security
#
$Kernel::OM->Get('Kernel::Config')->Set(
    Key   => 'Secure::DisableBanner',
    Value => 0,
);

my $Result = $SendEmail->(
    From    => 'john.smith@example.com',
    To      => 'john.smith2@example.com',
    Subject => 'some subject',
    Body    => 'Some Body',
    Type    => 'text/html',
    Charset => 'utf8',
);

my ($XMailerHeader)    = $Result->{Data}->{Header} =~ m{^X-Mailer:\s+(.*?)$}ixms;
my ($XPoweredByHeader) = $Result->{Data}->{Header} =~ m{^X-Powered-By:\s+(.*?)$}ixms;

my $Product = $Kernel::OM->Get('Kernel::Config')->Get('Product');
my $Version = $Kernel::OM->Get('Kernel::Config')->Get('Version');

$Self->Is(
    $XMailerHeader,
    "$Product Mail Service ($Version)",
    "Default X-Mailer header",
);

$Self->Is(
    $XPoweredByHeader,
    "OTRS (https://otrs.com/)",
    "Default X-Powered-By header",
);

$Kernel::OM->Get('Kernel::Config')->Set(
    Key   => 'Secure::DisableBanner',
    Value => 1,
);

$Result = $SendEmail->(
    From     => 'john.smith@example.com',
    To       => 'john.smith2@example.com',
    Subject  => 'some subject',
    Body     => 'Some Body',
    MimeType => 'text/html',
    Charset  => 'utf8',
);

($XMailerHeader)    = $Result->{Data}->{Header} =~ m{^X-Mailer:\s+(.*?)$}ixms;
($XPoweredByHeader) = $Result->{Data}->{Header} =~ m{^X-Powered-By:\s+(.*?)$}ixms;

$Self->Is(
    $XMailerHeader,
    undef,
    "Disabled X-Mailer header",
);

$Self->Is(
    $XPoweredByHeader,
    undef,
    "Disabled X-Powered-By header",
);

1;
