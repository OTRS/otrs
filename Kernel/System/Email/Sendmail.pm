# --
# Kernel/System/Email/Sendmail.pm - the global email send module
# Copyright (C) 2001-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Sendmail.pm,v 1.1 2003-03-06 10:40:01 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Email::Sendmail;

use strict;
use MIME::Words qw(:all);

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
    $Self->{Sendmail} = $Self->{ConfigObject}->Get('SendmailModule::CMD');
    $Self->{SendmailBcc} = $Self->{ConfigObject}->Get('SendmailBcc');
    $Self->{FQDN} = $Self->{ConfigObject}->Get('FQDN');
    $Self->{Organization} = $Self->{ConfigObject}->Get('Organization');

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
        foreach (qw(To Cc Bcc)) {
            $Param{Header} .= "$_: $Param{$_}\n" if ($Param{$_});
        }
        $Param{Header} .= "Subject: $Param{Subject}\n";
        $Param{Header} .= "X-Mailer: OTRS Mail Service ($VERSION)\n";
        $Param{Header} .= "X-Powered-By: OTRS - Open Ticket Request System (http://otrs.org/)\n";
    }
    my $To = '';
    foreach (qw(To Cc Bcc)) {
        if (!$To) {
            $To .= "$Param{$_}" if ($Param{$_});
        }
        else {
            $To .= ", $Param{$_}" if ($Param{$_});
        }
    }
    # --
    # send mail
    # --
    if (open( MAIL, "|".$Self->{ConfigObject}->Get('Sendmail')." '$Param{From}' " )) {
        print MAIL $Param{Header};
        print MAIL "\n";
        print MAIL $Param{Body};
        close(MAIL);
        # -- 
        # log
        # -- 
        $Self->{LogObject}->Log(
            Message => "Sent email to '$To' from '$Param{From}'. Subject => $Param{Subject};",
        );
        return 1;
    }
    else {
        $Self->{LogObject}->Log(
            Priority => 'error', 
            Message => "Can't use ".$Self->{ConfigObject}->Get('Sendmail').": $!!",
        );
        return;
    }
}
# --

1;
