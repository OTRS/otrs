# --
# EmailParser.t - email parser tests
# Copyright (C) 2001-2005 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: EmailParser.t,v 1.1 2005-12-20 22:53:43 martin Exp $
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



$Self->True(
    $Self->{EmailParserObject}->GetParam(WHAT => 'To') eq 'darthvader@otrs.org',
    "GetParam(WHAT => 'To')",
);

$Self->True(
    $Self->{EmailParserObject}->GetParam(WHAT => 'From') eq 'Skywalker Attachment <skywalker@otrs.org>',
    "GetParam(WHAT => 'From')",
);

$Self->True(
    $Self->{EmailParserObject}->GetEmailAddress(Email => 'Juergen Weber <juergen.qeber@air.com>') eq 'juergen.qeber@air.com',
    "GetEmailAddress()",
);

$Self->True(
    $Self->{EmailParserObject}->GetEmailAddress(Email => 'Juergen Weber <juergen+qeber@air.com>') eq 'juergen+qeber@air.com',
    "GetEmailAddress()",
);

$Self->True(
    $Self->{EmailParserObject}->GetEmailAddress(Email => 'Juergen Weber <juergen+qeber@air.com> (Comment)') eq 'juergen+qeber@air.com',
    "GetEmailAddress()",
);

$Self->True(
    $Self->{EmailParserObject}->GetEmailAddress(Email => 'juergen+qeber@air.com (Comment)') eq 'juergen+qeber@air.com',
    "GetEmailAddress()",
);


my @Addresses = $Self->{EmailParserObject}->SplitAddressLine(
    Line => 'Juergen Weber <juergen.qeber@air.com>, me@example.com, hans@example.com (Hans Huber)',
);

$Self->True(
    $Addresses[2] eq 'hans@example.com (Hans Huber)',
    "SplitAddressLine()",
);

$Self->True(
    $Self->{EmailParserObject}->GetCharset() eq 'us-ascii',
    "GetCharset()",
);

my @Attachments = $Self->{EmailParserObject}->GetAttachments();
$Self->True(
    $Attachments[1]->{Filename} eq 'otrs.jpg',
    "GetAttachments()",
);

1;
