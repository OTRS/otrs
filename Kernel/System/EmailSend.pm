# --
# Kernel/System/EmailSend.pm - the global email send module
# Copyright (C) 2001-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: EmailSend.pm,v 1.21 2003-02-08 15:09:38 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::EmailSend;

use strict;
use MIME::Words qw(:all);
use Mail::Internet;

use vars qw($VERSION);
$VERSION = '$Revision: 1.21 $';
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
    foreach (qw(ConfigObject LogObject DBObject)) {
        die "Got no $_" if (!$Self->{$_});
    }

    # get config data
    $Self->{Sendmail} = $Self->{ConfigObject}->Get('Sendmail');
    $Self->{SendmailBcc} = $Self->{ConfigObject}->Get('SendmailBcc');
    $Self->{FQDN} = $Self->{ConfigObject}->Get('FQDN');
    $Self->{Organization} = $Self->{ConfigObject}->Get('Organization');

    return $Self;
}
# --
sub SendNormal {
    my $Self = shift;
    my %Param = @_;
    # --
    # check needed stuff
    # --
    foreach (qw(Subject Body)) {
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
    # --
    # send mail
    # --
    if (open( MAIL, "|".$Self->{ConfigObject}->Get('Sendmail')." '$Param{From}' " )) {
            print MAIL "From: $Param{From}\n";
            foreach (qw(To Cc Bcc)) {
                print MAIL "$_: $Param{$_}\n" if ($Param{$_});
            }
            print MAIL "Subject: $Param{Subject}\n";
            print MAIL "X-Mailer: OTRS Mail Service ($VERSION)\n";
            print MAIL "X-Powered-By: OTRS - Open Ticket Request System (http://otrs.org/)\n";
            print MAIL "\n";
            print MAIL "$Param{Body}\n";
            close(MAIL);
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
