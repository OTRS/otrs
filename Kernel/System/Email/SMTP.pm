# --
# Kernel/System/Email/SMTP.pm - the global email send module
# Copyright (C) 2001-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: SMTP.pm,v 1.4 2003-06-01 19:20:56 martin Exp $
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
$VERSION = '$Revision: 1.4 $';
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
    $Self->{SMTPDebug} = 0; # shown on STDERR
    $Self->{SMTPTimeout} = 30; # sec
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
        $Param{Header} .= "Message-ID: <".time().".".rand(999999)."\@$Self->{FQDN}>\n";
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
    # send mail
    if ($Self->{SMTPObject} = Net::SMTP->new($Self->{MailHost}, Timeout => $Self->{SMTPTimeout}, Debug => $Self->{SMTPDebug})) {
        if ($Self->{User} && $Self->{Password}) {
            if (!$Self->{SMTPObject}->auth($Self->{User}, $Self->{Password})) {
                $Self->{LogObject}->Log(
                    Priority => 'error', 
                    Message => "SMTP authentication failed! Enable debug for more info!",
                );
                $Self->{SMTPObject}->quit;
                return;
            }
        }
        # - SOLO_adress patch by Robert Kehl (2003-03-11) -
        my @SOLO_address = Mail::Address->parse($Param{From});
        my $RealFrom = $SOLO_address[0]->address();
        if (!$Self->{SMTPObject}->mail($RealFrom)) {
            # log error
            $Self->{LogObject}->Log(
                Priority => 'error', 
                Message => "Can't use from: $RealFrom! Enable debug for more info!",
            );
            $Self->{SMTPObject}->quit;
            return;
        }
        foreach (@To) {
            if (!$Self->{SMTPObject}->to($_)) {
                # log error
                $Self->{LogObject}->Log(
                    Priority => 'error', 
                    Message => "Can't send to: $_! Enable debug for more info!",
                );
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
        # debug 
        if ($Self->{Debug}) {
            $Self->{LogObject}->Log(
                Message => "Sent email to '$ToString' from '$Param{From}'.",
            );
        }
        return 1;
    }
    else {
        # log error
        $Self->{LogObject}->Log(
            Priority => 'error', 
            Message => "Can't connect to $Self->{MailHost}: $!!",
        );
        return;
    }
}
# --

1;
