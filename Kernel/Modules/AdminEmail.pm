# --
# Kernel/Modules/AdminEmail.pm - to send a email to all agents
# Copyright (C) 2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AdminEmail.pm,v 1.1 2002-10-03 21:10:13 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AdminEmail;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.1 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {}; 
    bless ($Self, $Type);

    foreach (keys %Param) {
        $Self->{$_} = $Param{$_};
    }
    # --
    # check needed Opjects
    # --
    foreach (qw(ParamObject DBObject LayoutObject LogObject ConfigObject PermissionObject)) {
        die "Got no $_!" if (!$Self->{$_});
    }

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Output = '';
    my $Subaction = $Self->{Subaction}; 
    # --
    # permission check
    # --
    if (!$Self->{PermissionObject}->Section(UserID => $Self->{UserID}, Section => 'Admin')) {
        return $Self->{LayoutObject}->NoPermission();
    }
    # --
    # send email(s)
    # --
    if ($Subaction eq 'Send') {
        $Output .= $Self->{LayoutObject}->Header(Title => 'Admin-Email');
        $Output .= $Self->{LayoutObject}->AdminNavigationBar();
        # --
        # get recipients address
        # --
        foreach ($Self->{ParamObject}->GetArray(Param => 'UserIDs')) {
            my %UserData = $Self->{UserObject}->GetUserData(UserID => $_);
            if ($UserData{UserEmail}) {
                $Param{Bcc} .= "$UserData{UserEmail}, ";
            }
        }
        # --
        # check needed stuff
        # --
        foreach (qw(From Subject Body Bcc)) {
            $Param{$_} = $Self->{ParamObject}->GetParam(Param => $_) || '';
            if (!$Param{$_}) {
                $Output = $Self->{LayoutObject}->Header(Title => 'Warning');
                $Output .= $Self->{LayoutObject}->Warning(
                    Message => "Need $_!",
                    Comment => 'Click back and check the needed value.',
                );
                $Output .= $Self->{LayoutObject}->Footer();
                return $Output;
            }
        }
        # --
        # send mail
        # --
        if (open( MAIL, "|".$Self->{ConfigObject}->Get('Sendmail')." '$Param{From}' " )) {
            print MAIL "From: $Param{From}\n"; 
            print MAIL "Bcc: $Param{Bcc}\n"; 
            print MAIL "Subject: $Param{Subject}\n"; 
            print MAIL "X-Mailer: OTRS Admin-Email ($VERSION) (http://otrs.org/)\n"; 
            print MAIL "\n"; 
            print MAIL "$Param{Body}\n"; 
            close(MAIL);
            $Output .= $Self->{LayoutObject}->AdminEmailSent(%Param);
        }
        else {
            $Output .= $Self->{LayoutObject}->Error(
                Message => "Can't use ".$Self->{ConfigObject}->Get('Sendmail').": $!!",
                Comment => 'Please contact your admin',
            );
        }
        $Output .= $Self->{LayoutObject}->Footer();
    }
    else {
        $Output .= $Self->{LayoutObject}->Header(Title => 'Admin-Email');
        $Output .= $Self->{LayoutObject}->AdminNavigationBar();
        my %Users = $Self->{UserObject}->UserList();
        $Output .= $Self->{LayoutObject}->AdminEmail(UserList => \%Users);
        $Output .= $Self->{LayoutObject}->Footer();
    }
    return $Output;
}
# --

1;

