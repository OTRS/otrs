# --
# Kernel/Modules/AdminEmail.pm - to send a email to all agents
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: AdminEmail.pm,v 1.25.4.1 2008-07-24 10:09:13 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Modules::AdminEmail;

use strict;
use Kernel::System::Email;

use vars qw($VERSION);
$VERSION = '$Revision: 1.25.4.1 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    foreach (keys %Param) {
        $Self->{$_} = $Param{$_};
    }
    # check needed Objects
    foreach (qw(ParamObject DBObject LayoutObject LogObject ConfigObject)) {
        if (!$Self->{$_}) {
            $Self->{LayoutObject}->FatalError(Message => "Got no $_!");
        }
    }

    $Self->{SendmailObject} = Kernel::System::Email->new(%Param);

    return $Self;
}

sub Run {
    my $Self = shift;
    my %Param = @_;
    foreach (qw(From Subject Body Bcc GroupPermission)) {
        $Param{$_} = $Self->{ParamObject}->GetParam(Param => $_) || $Param{$_} || '';
    }
    # ------------------------------------------------------------ #
    # send email(s)
    # ------------------------------------------------------------ #
    if ($Self->{Subaction} eq 'Send') {
        # check needed stuff
        foreach (qw(From Subject Body GroupPermission)) {
            if (!$Param{$_}) {
                my $Output = $Self->{LayoutObject}->Header(Title => 'Warning');
                $Output .= $Self->{LayoutObject}->Warning(
                    Message => "Need $_!",
                    Comment => 'Click back and check the needed value.',
                );
                $Output .= $Self->{LayoutObject}->Footer();
                return $Output;
            }
        }
        my %Bcc = ();
        # get user recipients address
        foreach ($Self->{ParamObject}->GetArray(Param => 'UserIDs')) {
            my %UserData = $Self->{UserObject}->GetUserData(UserID => $_, Valid => 1);
            if ($UserData{UserEmail}) {
                $Bcc{$UserData{UserLogin}} = $UserData{UserEmail};
            }
        }
        # get group recipients address
        foreach ($Self->{ParamObject}->GetArray(Param => 'GroupIDs')) {
            my @GroupMemberList = $Self->{GroupObject}->GroupMemberList(
                Result => 'ID',
                Type => $Param{GroupPermission},
                GroupID => $_,
            );
            foreach (@GroupMemberList) {
                my %UserData = $Self->{UserObject}->GetUserData(UserID => $_, Valid => 1);
                if ($UserData{UserEmail}) {
                    $Bcc{$UserData{UserLogin}} = $UserData{UserEmail};
                }
            }
        }
        foreach (sort keys %Bcc) {
            $Param{Bcc} .= "$Bcc{$_}, ";
        }
        # check needed stuff
        foreach (qw(Bcc)) {
            if (!$Param{$_}) {
                my $Output = $Self->{LayoutObject}->Header(Title => 'Warning');
                $Output .= $Self->{LayoutObject}->Warning(
                    Message => "Need $_!",
                    Comment => 'Click back and check the needed value.',
                );
                $Output .= $Self->{LayoutObject}->Footer();
                return $Output;
            }
        }
        # clean up
        $Param{Body} =~ s/(\r\n|\n\r)/\n/g;
        $Param{Body} =~ s/\r/\n/g;
        # send mail
        if ($Self->{SendmailObject}->Send(
            From => $Param{From},
            Bcc => $Param{Bcc},
            Subject => $Param{Subject},
            Type => 'text/plain',
            Charset => $Self->{LayoutObject}->{UserCharset},
            Body => $Param{Body},
        )) {
            $Self->{LayoutObject}->Block(
                Name => 'Sent',
                Data => { %Param },
            );
            my $Output = $Self->{LayoutObject}->Header();
            $Output .= $Self->{LayoutObject}->NavigationBar();
            $Output .= $Self->{LayoutObject}->Output(TemplateFile => 'AdminEmail', Data => \%Param);
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
        else {
            return $Self->{LayoutObject}->ErrorScreen();
        }
    }
    # ------------------------------------------------------------ #
    # show mask
    # ------------------------------------------------------------ #
    else {
        $Param{'UserOption'} = $Self->{LayoutObject}->OptionStrgHashRef(
            Data => {$Self->{UserObject}->UserList(Valid => 1)},
            Name => 'UserIDs',
            Size => 8,
            Multiple => 1,
        );
        $Param{'GroupOption'} = $Self->{LayoutObject}->OptionStrgHashRef(
            Data => {$Self->{GroupObject}->GroupList(Valid => 1)},
            Size => 6,
            Name => 'GroupIDs',
            Multiple => 1,
        );
        $Self->{LayoutObject}->Block(
            Name => 'Form',
            Data => { %Param },
        );
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->{LayoutObject}->Output(TemplateFile => 'AdminEmail', Data => \%Param);
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
}

1;
