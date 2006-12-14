# --
# Kernel/System/Email/Sendmail.pm - the global email send module
# Copyright (C) 2001-2006 OTRS GmbH, http://otrs.org/
# --
# $Id: Sendmail.pm,v 1.18 2006-12-14 12:13:55 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Email::Sendmail;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.18 $';
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
    # debug
    $Self->{Debug} = $Param{Debug} || 0;
    # check all needed objects
    foreach (qw(ConfigObject LogObject)) {
        die "Got no $_" if (!$Self->{$_});
    }
    # get config data
    $Self->{Sendmail} = $Self->{ConfigObject}->Get('SendmailModule::CMD');

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
    # from
    my $Arg = quotemeta($Param{From});
    if (!$Param{From}) {
        $Arg = "''";
    }
    # recipient
    foreach (@{$Param{ToArray}}) {
        $ToString .= "$_,";
        $Arg.= ' '.quotemeta($_);
    }
    # send mail
    if (open( MAIL, "| $Self->{Sendmail} $Arg")) {
        # set handle to binmode if utf-8 is used
        if ($Self->{ConfigObject}->Get('DefaultCharset') =~ /^utf(-8|8)$/i) {
            binmode MAIL, ":utf8";
        }
        print MAIL ${$Param{Header}};
        print MAIL "\n";
        print MAIL ${$Param{Body}};
        close(MAIL);
        # debug
        if ($Self->{Debug} > 2) {
            $Self->{LogObject}->Log(
                Priority => 'notice',
                Message => "Sent email to '$ToString' from '$Param{From}'.",
            );
        }
        return 1;
    }
    else {
        # log error
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message => "Can't use $Self->{Sendmail}: $!!",
        );
        return;
    }
}

1;
