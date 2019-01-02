# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

# get needed objects
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

# do not really send emails
$ConfigObject->Set(
    Key   => 'SendmailModule',
    Value => 'Kernel::System::Email::DoNotSendEmail',
);

# get email object
my $EmailObject = $Kernel::OM->Get('Kernel::System::Email');

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
    my ( $Header, $Body ) = $Kernel::OM->Get('Kernel::System::Email')->Send(
        From       => 'john.smith@example.com',
        To         => 'john.smith2@example.com',
        Subject    => 'some subject',
        Body       => 'Some Body',
        Type       => 'text/html',
        Charset    => 'utf8',
        References => $Test->{Header},
        InReplyTo  => $Test->{Header},
    );

    my ($ReferencesHeader) = $$Header =~ m{^(References:.*?)(^\S|\z)}xms;
    my ($InReplyToHeader)  = $$Header =~ m{^(In-Reply-To:.*?)(^\S|\z)}xms;

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

1;
