# --
# Kernel/System/Email/SMTP.pm - the global email send module
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: SMTP.pm,v 1.14 2007-08-22 09:35:23 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Email::SMTP;

use strict;
use warnings;
use Net::SMTP;

use vars qw($VERSION);
$VERSION = '$Revision: 1.14 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

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
    foreach (qw(ConfigObject LogObject EncodeObject)) {
        die "Got no $_" if (!$Self->{$_});
    }
    # debug
    $Self->{Debug} = $Param{Debug} || 0;
    if ($Self->{Debug} > 2) {
        # shown on STDERR
        $Self->{SMTPDebug} = 1;
    }
    # smtp timeout in sec
    $Self->{SMTPTimeout} = 30;
    # get config data
    $Self->{FQDN} = $Self->{ConfigObject}->Get('FQDN');
    $Self->{MailHost} = $Self->{ConfigObject}->Get('SendmailModule::Host') ||
        die "No SendmailModule::Host found in Kernel/Config.pm";
    $Self->{SMTPPort} = $Self->{ConfigObject}->Get('SendmailModule::Port') || 'smtp(25)';
    $Self->{User} = $Self->{ConfigObject}->Get('SendmailModule::AuthUser');
    $Self->{Password} = $Self->{ConfigObject}->Get('SendmailModule::AuthPassword');
    return $Self;
}

sub Send {
    my $Self = shift;
    my %Param = @_;
    my $ToString = '';
    # check needed stuff
    foreach (qw(Header Body ToArray)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    if (!$Param{From}) {
        $Param{From} = "";
    }
    # send mail
    if ($Self->{SMTPObject} = Net::SMTP->new(
        $Self->{MailHost},
        Hello => $Self->{FQDN},
        Port => $Self->{SMTPPort},
        Timeout => $Self->{SMTPTimeout},
        Debug => $Self->{SMTPDebug})) {
        if ($Self->{User} && $Self->{Password}) {
            if (!$Self->{SMTPObject}->auth($Self->{User}, $Self->{Password})) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message => "SMTP authentication failed! Enable debug for more info!",
                );
                $Self->{SMTPObject}->quit();
                return;
            }
        }
        if (!$Self->{SMTPObject}->mail($Param{From})) {
            # log error
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message => "Can't use from: $Param{From}! Enable debug for more info!",
            );
            $Self->{SMTPObject}->quit;
            return;
        }
        foreach (@{$Param{ToArray}}) {
            $ToString .= "$_,";
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
        # encode utf8 header strings (of course, there should only be 7 bit in there!)
        $Self->{EncodeObject}->EncodeOutput($Param{Header});
        # encode utf8 body strings
        $Self->{EncodeObject}->EncodeOutput($Param{Body});
        # send data
        $Self->{SMTPObject}->data();
        $Self->{SMTPObject}->datasend(${$Param{Header}});
        $Self->{SMTPObject}->datasend("\n");
        $Self->{SMTPObject}->datasend(${$Param{Body}});
        $Self->{SMTPObject}->dataend();
        $Self->{SMTPObject}->quit;
        # debug
        if ($Self->{Debug} > 2) {
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

1;
