# --
# Kernel/System/CheckItem.pm - the global spellinf module
# Copyright (C) 2001-2006 OTRS GmbH, http://otrs.org/
# --
# $Id: CheckItem.pm,v 1.16 2006-09-05 23:17:44 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::CheckItem;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.16 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    $Self->{Debug} = 0;

    # get needed objects
    foreach (qw(ConfigObject LogObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    return $Self;
}

sub CheckError {
    my $Self = shift;
    return $Self->{Error};
}

sub CheckEmail {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(Address)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # check if it's to do
    if (! $Self->{ConfigObject}->Get('CheckEmailAddresses')) {
        return 1;
    }
    # check valid email addresses
    my $RegExp = $Self->{ConfigObject}->Get('CheckEmailValidAddress');
    if ($RegExp && $Param{Address} =~ /$RegExp/i) {
        return 1;
    }
    my $Error = '';
    # email address syntax check
    if ($Param{Address} !~ /^(()|([a-zA-Z0-9]+([a-zA-Z0-9_+\.&%-]*[a-zA-Z0-9_\.-]+)?@([a-zA-Z0-9]+([a-zA-Z0-9\.-]*[a-zA-Z0-9]+)?\.+[a-zA-Z]{2,8}|\[\d+\.\d+\.\d+\.\d+])))$/) {
        $Error = "Invalid syntax";
    }
    # mx check
    elsif ($Self->{ConfigObject}->Get('CheckMXRecord') && eval { require Net::DNS }) {
        # get host
        my $Host = $Param{Address};
        $Host =~ s/^.*@(.*)$/$1/;
        $Host =~ s/\s+//g;
        $Host =~ s/(^\[)|(\]$)//g;
        # do dns query
        my $Resolver = Net::DNS::Resolver->new();
        if ($Resolver) {
            # A recorde lookup
            my $packet = $Resolver->send($Host, 'A');
            if (!$packet) {
                $Error = "DNS problem: ".$Resolver->errorstring();
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message => "DNS problem: ".$Resolver->errorstring(),
                );
            }
            elsif ($packet->header->ancount()) {
                # OK
#                print STDERR "OK A $Host ".$packet->header->ancount()."\n";
            }
            # mx recorde lookup
            else {
                my $packet = $Resolver->send($Host, 'MX');
                if (!$packet) {
                    $Error = "DNS problem: ".$Resolver->errorstring();
                    $Self->{LogObject}->Log(
                        Priority => 'error',
                        Message => "DNS problem: ".$Resolver->errorstring(),
                    );
                }
                elsif ($packet->header->ancount()) {
                    # OK
#                    print STDERR "OK MX $Host ".$packet->header->ancount()."\n";
                }
                else {
                    $Error = "no mail exchanger (mx) found!";
                }
            }
        }
    }
    elsif ($Self->{ConfigObject}->Get('CheckMXRecord')) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message => "Can't load Net::DNS, no mx lookups possible",
        );
    }
    # check address
    if (!$Error) {
        # check special stuff
        my $RegExp = $Self->{ConfigObject}->Get('CheckEmailInvalidAddress');
        if ($RegExp && $Param{Address} =~ /$RegExp/i) {
            $Self->{Error} = "invalid $Param{Address} (config)!";
            return;
        }
        return 1;
    }
    else {
        # remember error
        $Self->{Error} = "invalid $Param{Address} ($Error)! ";
        return;
    }
}

1;
