# --
# EmailParser.t - email parser tests
# Copyright (C) 2001-2006 OTRS GmbH, http://otrs.org/
# --
# $Id: EmailParser.t,v 1.3 2006-08-26 17:36:26 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

use Kernel::System::EmailParser;

my $Home = $Self->{ConfigObject}->Get('Home');
my @Array = ();
open(IN, "< $Home/doc/test-email-3.box");
while (<IN>) {
    push(@Array, $_);
}
close (IN);

$Self->{EmailParserObject} = Kernel::System::EmailParser->new(
    %{$Self},
    Email => \@Array,
);



$Self->Is(
    $Self->{EmailParserObject}->GetParam(WHAT => 'To'),
    'darthvader@otrs.org',
    "GetParam(WHAT => 'To')",
);

$Self->Is(
    $Self->{EmailParserObject}->GetParam(WHAT => 'From'),
    'Skywalker Attachment <skywalker@otrs.org>',
    "GetParam(WHAT => 'From')",
);

$Self->Is(
    $Self->{EmailParserObject}->GetEmailAddress(Email => 'Juergen Weber <juergen.qeber@air.com>'),
    'juergen.qeber@air.com',
    "GetEmailAddress()",
);

$Self->Is(
    $Self->{EmailParserObject}->GetEmailAddress(Email => 'Juergen Weber <juergen+qeber@air.com>'),
    'juergen+qeber@air.com',
    "GetEmailAddress()",
);

$Self->Is(
    $Self->{EmailParserObject}->GetEmailAddress(Email => 'Juergen Weber <juergen+qeber@air.com> (Comment)'),
    'juergen+qeber@air.com',
    "GetEmailAddress()",
);

$Self->Is(
    $Self->{EmailParserObject}->GetEmailAddress(Email => 'juergen+qeber@air.com (Comment)'),
    'juergen+qeber@air.com',
    "GetEmailAddress()",
);


my @Addresses = $Self->{EmailParserObject}->SplitAddressLine(
    Line => 'Juergen Weber <juergen.qeber@air.com>, me@example.com, hans@example.com (Hans Huber)',
);

$Self->Is(
    $Addresses[2],
    'hans@example.com (Hans Huber)',
    "SplitAddressLine()",
);

$Self->Is(
    $Self->{EmailParserObject}->GetCharset(),
    'us-ascii',
    "GetCharset()",
);

my @Attachments = $Self->{EmailParserObject}->GetAttachments();
$Self->Is(
    $Attachments[1]->{Filename},
    'otrs.jpg',
    "GetAttachments()",
);

1;
