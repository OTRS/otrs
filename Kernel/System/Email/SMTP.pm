# --
# Kernel/System/Email/SMTP.pm - the global email send module
# Copyright (C) 2001-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: SMTP.pm,v 1.1 2003-03-06 10:40:01 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Email::SMTP;

use strict;
use MIME::Words qw(:all);
use Mail::Address;
use Net::SMTP;

use vars qw($VERSION);
$VERSION = '$Revision: 1.1 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;
    # allocate new hash for object
    my $Self = {}; 
    bless ($Self, $Type);
    # get common opjects
    foreach (keys %Param) {
        $Self->{$_} = $Param{$_};
    }
    # check all needed objects
    foreach (qw(ConfigObject LogObject)) {
        die "Got no $_" if (!$Self->{$_});
    }
    # get config data
    $Self->{Sendmail} = $Self->{ConfigObject}->Get('Sendmail');
    $Self->{SendmailBcc} = $Self->{ConfigObject}->Get('SendmailBcc');
    $Self->{FQDN} = $Self->{ConfigObject}->Get('FQDN');
    $Self->{Organization} = $Self->{ConfigObject}->Get('Organization');
    $Self->{MailHost} = $Self->{ConfigObject}->Get('SendmailModule::Host') || 
      die "No SendmailModule::Host found in Kernel/Config.pm";
    $Self->{User} = $Self->{ConfigObject}->Get('SendmailModule::AuthUser');
    $Self->{Password} = $Self->{ConfigObject}->Get('SendmailModule::AuthPassword');
    return $Self;
}
# --
sub Send {
    my $Self = shift;
    my %Param = @_;
    # --
    # check needed stuff
    # --
    foreach (qw(Body)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    if (!$Param{To} && !$Param{Cc} && !$Param{Bcc}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need To, Cc or Bcc!");
        return;
    }
    if (!$Param{From}) {
        $Param{From} = $Self->{ConfigObject}->Get('AdminEmail') || 'otrs@localhost';
    }
    if (!$Param{Header}) {
        $Param{Header} = "From: $Param{From}\n";
        foreach (qw(To Cc)) {
            $Param{Header} .= "$_: $Param{$_}\n" if ($Param{$_});
        }
        $Param{Header} .= "Subject: $Param{Subject}\n";
        $Param{Header} .= "X-Mailer: OTRS Mail Service ($VERSION)\n";
        $Param{Header} .= "Organization: $Self->{Organization}\n" if ($Self->{Organization});
        $Param{Header} .= "X-Powered-By: OTRS - Open Ticket Request System (http://otrs.org/)\n";
        $Param{Header} .= "MessageID: <".time().".".rand(999999)."\@$Self->{FQDN}>\n";
    }
    my @To = ();
    my $ToString = ();
    foreach (qw(To Cc Bcc)) {
        if ($Param{$_}) {
            foreach my $Email (Mail::Address->parse($Param{$_})) {
                push (@To, $Email->address());
                if ($ToString) {
                    $ToString .= ', ';
                }
                $ToString .= $Email->address();
            }
        }
    }
    # --
    # send mail
    # --
    if ($Self->{SMTPObject} = Net::SMTP->new($Self->{MailHost}, Timeout => 30, Debug => 0,)) {
        if ($Self->{User} && $Self->{Password}) {
            if (!$Self->{SMTPObject}->auth($Self->{User}, $Self->{Password})) {
                $Self->{LogObject}->Log(Priority => 'error', Message => "SMTP authentication failed!");
                $Self->{SMTPObject}->quit;
                return;
            }
        }
        $Self->{SMTPObject}->mail($Param{From});
        foreach (@To) {
            if (!$Self->{SMTPObject}->to($_)) {
                $Self->{LogObject}->Log(Priority => 'error', Message => "Can't send to: $_!");
                $Self->{SMTPObject}->quit;
                return;
            }
        }
        $Self->{SMTPObject}->data();
        $Self->{SMTPObject}->datasend($Param{Header});
        $Self->{SMTPObject}->datasend("\n");
        $Self->{SMTPObject}->datasend($Param{Body});
        $Self->{SMTPObject}->dataend();
        $Self->{SMTPObject}->quit;
        # -- 
        # log
        # -- 
        $Self->{LogObject}->Log(
            Message => "Sent email to '$ToString' from '$Param{From}'.",
        );
        return 1;
    }
    else {
        $Self->{LogObject}->Log(
            Priority => 'error', 
            Message => "Can't connect to $Self->{MailHost}: $!!",
        );
        return;
    }
}
# --

1;
