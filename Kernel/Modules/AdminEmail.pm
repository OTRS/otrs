# --
# Kernel/Modules/AdminEmail.pm - to send a email to all agents
# Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AdminEmail.pm,v 1.14 2004-04-07 07:15:02 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AdminEmail;

use strict;
use MIME::Words qw(:all);
use MIME::Entity;
use Mail::Internet; 

use vars qw($VERSION);
$VERSION = '$Revision: 1.14 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

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
    # check needed Opjects
    foreach (qw(ParamObject DBObject LayoutObject LogObject ConfigObject)) {
        die "Got no $_!" if (!$Self->{$_});
    }

    $Self->{SendmailObject} = Kernel::System::Email->new(%Param);
    $Self->{FQDN} = $Self->{ConfigObject}->Get('FQDN');
    $Self->{Organization} = $Self->{ConfigObject}->Get('Organization');

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Output = '';
    foreach (qw(From Subject Body Bcc GroupPermission)) {
        $Param{$_} = $Self->{ParamObject}->GetParam(Param => $_) || $Param{$_} || '';
    }
    # send email(s)
    if ($Self->{Subaction} eq 'Send') {
        # check needed stuff
        foreach (qw(From Subject Body GroupPermission)) {
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
        my %Bcc = ();
        # get user recipients address
        foreach ($Self->{ParamObject}->GetArray(Param => 'UserIDs')) {
            my %UserData = $Self->{UserObject}->GetUserData(UserID => $_);
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
                my %UserData = $Self->{UserObject}->GetUserData(UserID => $_);
                if ($UserData{UserEmail}) {
                    $Bcc{$UserData{UserLogin}} = $UserData{UserEmail};
                }
            }
        }
        foreach (sort keys %Bcc) {
            $Param{Bcc} .= "$Bcc{$_},";
        }
        # check needed stuff
        foreach (qw(Bcc)) {
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
        # clean up
        $Param{Body} =~ s/(\r\n|\n\r)/\n/g;
        $Param{Body} =~ s/\r/\n/g;
        # build mail ...
        # do some encode
        foreach (qw(From To Bcc Subject)) {
            if ($Param{$_}) {
                $Param{$_} = encode_mimewords($Param{$_}, Charset => $Self->{LayoutObject}->{UserCharset}) || '';
            }
        }   
        my $Header = {
            From => $Param{From},
            To => $Param{To},
            Bcc => $Param{Bcc},   
            Subject => $Param{Subject},
            'X-Mailer' => "OTRS Mail Service ($VERSION)",
            'X-Powered-By' => 'OTRS - Open Ticket Request System (http://otrs.org/)',
            'Message-ID' => "<".time().".".rand(999999)."\@$Self->{FQDN}>",
            Organization => $Self->{Organization},
            Type => 'text/plain; charset='.$Self->{LayoutObject}->{UserCharset},
            Encoding => '8bit',   
        };
        my $Entity = MIME::Entity->build(%{$Header}, Data => $Param{Body});
        # get header
        my $head = $Entity->head;
        # send mail
        $Output .= $Self->{LayoutObject}->Header(Area => 'Admin', Title => 'Admin-Email');
        $Output .= $Self->{LayoutObject}->AdminNavigationBar();
        if ($Self->{SendmailObject}->Send(
            From => $Param{From},
            To => $Param{To},
            Bcc => $Param{Bcc},   
            Subject => $Param{Subject},
            Header => $head->as_string(),
            Body => $Entity->body_as_string(),
        )) {
            $Output .= $Self->_MaskSent(%Param);
        }
        else {
            $Output .= $Self->{LayoutObject}->Error();
        }
        $Output .= $Self->{LayoutObject}->Footer();
    }
    else {
        $Output .= $Self->{LayoutObject}->Header(Area => 'Admin', Title => 'Admin-Email');
        $Output .= $Self->{LayoutObject}->AdminNavigationBar();
        my %Users = $Self->{UserObject}->UserList(Valid => 1);
        my %Groups = $Self->{GroupObject}->GroupList(Valid => 1);
        $Output .= $Self->_Mask(
            UserList => \%Users, 
            GroupList => \%Groups,
            %Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();
    }
    return $Output;
}
# --
sub _Mask {
    my $Self = shift;
    my %Param = @_;

    $Param{'UserOption'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => $Param{UserList},
        Name => 'UserIDs',
        Size => 8,
        Multiple => 1,
    );

    $Param{'GroupOption'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => $Param{GroupList},
        Size => 6,
        Name => 'GroupIDs',
        Multiple => 1,
    );

    # create & return output
    return $Self->{LayoutObject}->Output(TemplateFile => 'AdminEmail', Data => \%Param);
}
# --
sub _MaskSent {
    my $Self = shift;
    my %Param = @_;

    # create & return output
    return $Self->{LayoutObject}->Output(TemplateFile => 'AdminEmailSent', Data => \%Param);
}
# --
1;
