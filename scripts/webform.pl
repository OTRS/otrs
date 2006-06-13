#!/usr/bin/perl -w
# --
# webform.pl - a simple web form script to generate email with
# X-OTRS-Queue header for an OTRS system (x-headers for dispatching!).
# Copyright (C) 2001-2006 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: webform.pl,v 1.5 2006-06-13 11:35:36 cs Exp $
# --
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
# --

use strict;
# to get the errors on screen
use CGI::Carp qw(fatalsToBrowser);
# Simple Common Gateway Interface Class
use CGI;

my $VERSION = '$Revision: 1.5 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;


# --
# web form options
# --
my $Ident = 'ahfiw2Fw32r230dddl2foeo3r';
# sendmail location and options
my $Sendmail = '/usr/sbin/sendmail -t -i -f ';
# email where the emails of the form will send to
my $OTRSEmail = 'otrs-system@example.com';
# topics and dest. queues
my %Topics = (
    # topic => OTRS queue
    'Info' => 'info',
    'Support' => 'support',
    'Bugs' => 'bugs',
    'Sales' => 'sales',
    'Billing' => 'billing',
    'Webmaster' => 'webmaster',
);

# --
# html header
# --
sub Header {
    my %Param = @_;
    (my $Output = <<EOF);
Content-Type: text/html

<html>
<head>
    <title>$Param{"Title"}</title>
</head>
<body>

<h1>$Param{"Title"}</h1>
<hr>
EOF
    return $Output;
}
# --
# html footer
# --
sub Footer {
    (my $Output = <<EOF);
<hr>

</body>
</html>
EOF
    return $Output;
}
# --
# Thanks
# --
sub Thanks {
    my %Param = @_;
    (my $Output = <<EOF);
Thanks <b>$Param{From}</b>! Your request is forwarded to us. <br>
We will answer ASAP.<br>
EOF
    return $Output;
}
# --
# error
# --
sub Error {
    my %Param = @_;
    (my $Output = <<EOF);
<font color="red">$Param{Message}</font><br>
EOF
    return $Output;
}

# --
# start the real actions
# --
my $CGI = new CGI;
my %GetParam = ();
foreach (qw(Action From FromEmail Subject Topic Body)) {
    $GetParam{$_} = $CGI->param($_) || '';
}
# what should I do?
if ($GetParam{Action} eq 'SendMail') {
    SendMail(%GetParam);
}
else {
    WebForm();
}

# --
# web form
# --
sub WebForm {
    print Header(Title => 'Submit Request');
print '
    <form action="webform.pl" method="post">
    <input type="hidden" name="Action" value="SendMail">
    <table>
    <tr>
      <td>Topic:</td>
      <td>
';
    foreach (sort keys %Topics) {
        print $_.'<input type="radio" name="Topic" value="'.$Topics{$_}.'">';
    }
print '
      </td>
    </tr>
    <tr>
      <td>From:</td>
      <td><input type="text" name="From" size="45" value=""></td>
    </tr>
    <tr>
      <td>Email:</td>
      <td><input type="text" name="FromEmail" size="45" value=""></td>
    </tr>
    <tr>
      <td>Subject:</td>
      <td><input type="text" name="Subject" size="45" value=""></td>
    </tr>
    <tr valign="top">
      <td>Message:</td>
      <td><textarea name="Body" rows="15" cols="45"></textarea></td>
    </tr>
    <tr>
      <td></td>
      <td><input type="submit" value="Submit"></td>
    </tr>
    </table>
    </form>
';
    print Footer();
}
# --
# send email
# --
sub SendMail {
    my %Param = @_;
    my $Output = '';
    # --
    # check needed params
    # --
    foreach (qw(From FromEmail Subject Topic Body)) {
        if (!$Param{$_}) {
            $Output .= Error(Message => "Param $_ is needed!");
        }
    }
    if ($Output) {
        $Output = Header(Title => 'Error!') . $Output;
        $Output .= Footer();
        print $Output;
        return;
    }
    # --
    # simple email check
    # ---
    my $NonAscii      = "\x80-\xff"; # Non-ASCII-Chars are not allowed
    my $Nqtext        = "[^\\\\$NonAscii\015\012\"]";
    my $Qchar         = "\\\\[^$NonAscii]";
    my $Protocol      = '(?:mailto:)';
    my $NormUser      = '[a-zA-Z0-9][a-zA-Z0-9_.-]*';
    my $QuotedString  = "\"(?:$Nqtext|$Qchar)+\"";
    my $UserPart     = "(?:$NormUser|$QuotedString)";
    my $DomMainPart  = '[a-zA-Z0-9][a-zA-Z0-9._-]*\\.';
    my $DomSubPart   = '(?:[a-zA-Z0-9][a-zA-Z0-9._-]*\\.)*';
    my $DomTldPart   = '[a-zA-Z]{2,5}';
    my $DomainPart   = "$DomSubPart$DomMainPart$DomTldPart";
    my $Regex         = "$Protocol?$UserPart\@$DomainPart";

    if ($Param{FromEmail} !~ /^$Regex$/) {
        $Output = Header(Title => 'Error!');
        $Output .= Error(Message => "Your email '$Param{FromEmail}' is invalid!");
        $Output .= Footer();
        print $Output;
        return;
    }
    # --
    # build email
    # --
    my @Mail = ("From: $Param{From} <$Param{FromEmail}>\n");
    push @Mail, "To: $Param{Topic} <$OTRSEmail>\n";
    push @Mail, "Subject: $Param{Subject}\n";
    push @Mail, "X-OTRS-Ident: $Ident\n";
    push @Mail, "X-OTRS-Queue: $Param{Topic}\n";
    push @Mail, "X-OTRS-ArticleKey1: Sent via\n";
    push @Mail, "X-OTRS-ArticleValue1: Webform\n";
    push @Mail, "X-OTRS-ArticleKey2: Orig. sort\n";
    push @Mail, "X-OTRS-ArticleValue2: $Param{Topic}\n";
    push @Mail, "X-Mailer: OTRS WebForm ($VERSION)\n";
    push @Mail, "X-Powered-By: OTRS (http://otrs.org/)\n";
    push @Mail, "\n";
    push @Mail, $Param{Body};
    push @Mail, "\n";
    # --
    # send mail
    # --
    $Param{From} =~ s/"|;|'|<|>|\|| //ig;
    if (open(MAIL, "|$Sendmail $Param{From} ")) {
        print MAIL @Mail;
        close(MAIL);
        # --
        # thanks!
        # --
        $Output = Header(Title => 'Thanks!');
        $Output .= Thanks(%Param);
        $Output .= Footer();
        print $Output;
    }
    else {
        # error
        $Output = Header(Title => 'Error!');
        $Output .= Error(Message => "Can't send email: $!");
        $Output .= Footer();
        print $Output;
    }
}
# --

