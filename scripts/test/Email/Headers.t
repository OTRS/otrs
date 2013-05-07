# --
# Headers.t - email headers tests
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --
use strict;
use warnings;
use vars (qw($Self));
use utf8;
use Kernel::Config;
use Kernel::System::Email;

# create local object
my $ConfigObject = Kernel::Config->new();

# do not really send emails
$ConfigObject->Set(
    Key   => 'SendmailModule',
    Value => 'Kernel::System::Email::DoNotSendEmail',
);


# generate email
my $EmailObject = Kernel::System::Email->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);

# Check that long references and in-reply-to headers are correctly split across lines.
# See bug#9345 and RFC5322.
my $MsgID = '<54DEDF2AD94D34F9A6C123E21D7CA6102A2E7@EFNPNCY115.xyz-intra.net>';

# call Send and get results
my ( $Header, $Body ) = $EmailObject->Send(
    From       => 'john.smith@example.com',
    To         => 'john.smith2@example.com',
    Subject    => 'some subject',
    Body       => 'Some Body',
    Type       => 'text/html',
    Charset    => 'utf8',
    References => $MsgID x 10,
    InReplyTo  => $MsgID x 10,
);

my ($ReferencesHeader) = $$Header =~ m{^(References:.*?)(^\S|\z)}xms;
my ($InReplyToHeader)  = $$Header =~ m{^(In-Reply-To:.*?)(^\S|\z)}xms;

$Self->Is(
    $ReferencesHeader,
    'References: <54DEDF2AD94D34F9A6C123E21D7CA6102A2E7@EFNPNCY115.xyz-intra.net>
 <54DEDF2AD94D34F9A6C123E21D7CA6102A2E7@EFNPNCY115.xyz-intra.net>
 <54DEDF2AD94D34F9A6C123E21D7CA6102A2E7@EFNPNCY115.xyz-intra.net>
 <54DEDF2AD94D34F9A6C123E21D7CA6102A2E7@EFNPNCY115.xyz-intra.net>
 <54DEDF2AD94D34F9A6C123E21D7CA6102A2E7@EFNPNCY115.xyz-intra.net>
 <54DEDF2AD94D34F9A6C123E21D7CA6102A2E7@EFNPNCY115.xyz-intra.net>
 <54DEDF2AD94D34F9A6C123E21D7CA6102A2E7@EFNPNCY115.xyz-intra.net>
 <54DEDF2AD94D34F9A6C123E21D7CA6102A2E7@EFNPNCY115.xyz-intra.net>
 <54DEDF2AD94D34F9A6C123E21D7CA6102A2E7@EFNPNCY115.xyz-intra.net>
 <54DEDF2AD94D34F9A6C123E21D7CA6102A2E7@EFNPNCY115.xyz-intra.net>
',
    'Check that references header is split across lines',
);

$Self->Is(
    $InReplyToHeader,
    'In-Reply-To: <54DEDF2AD94D34F9A6C123E21D7CA6102A2E7@EFNPNCY115.xyz-intra.net>
 <54DEDF2AD94D34F9A6C123E21D7CA6102A2E7@EFNPNCY115.xyz-intra.net>
 <54DEDF2AD94D34F9A6C123E21D7CA6102A2E7@EFNPNCY115.xyz-intra.net>
 <54DEDF2AD94D34F9A6C123E21D7CA6102A2E7@EFNPNCY115.xyz-intra.net>
 <54DEDF2AD94D34F9A6C123E21D7CA6102A2E7@EFNPNCY115.xyz-intra.net>
 <54DEDF2AD94D34F9A6C123E21D7CA6102A2E7@EFNPNCY115.xyz-intra.net>
 <54DEDF2AD94D34F9A6C123E21D7CA6102A2E7@EFNPNCY115.xyz-intra.net>
 <54DEDF2AD94D34F9A6C123E21D7CA6102A2E7@EFNPNCY115.xyz-intra.net>
 <54DEDF2AD94D34F9A6C123E21D7CA6102A2E7@EFNPNCY115.xyz-intra.net>
 <54DEDF2AD94D34F9A6C123E21D7CA6102A2E7@EFNPNCY115.xyz-intra.net>
',
    'Check that in-reply-to header is split across lines',
);



1;
