# --
# Kernel/Modules/AdminPOP3.pm - to add/update/delete POP3 acounts 
# Copyright (C) 2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AdminPOP3.pm,v 1.1 2002-12-15 23:18:32 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AdminPOP3;

use strict;
use Kernel::System::POP3Account;

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

    # get common opjects
    foreach (keys %Param) {
        $Self->{$_} = $Param{$_};
    }

    # check all needed objects
    foreach (qw(ParamObject DBObject PermissionObject LayoutObject ConfigObject LogObject)) {
        die "Got no $_" if (!$Self->{$_});
    }

    $Self->{POP3Account} = Kernel::System::POP3Account->new(%Param);

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Output = '';
    my $NextScreen = 'AdminPOP3';
    my @Params = (qw(ID Login Password Host Comment ValidID QueueID Trusted));
    # --
    # permission check
    # --
    if (!$Self->{PermissionObject}->Section(UserID => $Self->{UserID}, Section => 'Admin')) {
        $Output .= $Self->{LayoutObject}->NoPermission();
        return $Output;
    }
    # --
    # get data 2 form
    # --
    if ($Self->{Subaction} eq 'Change') {
        my $ID = $Self->{ParamObject}->GetParam(Param => 'ID') || '';
        my %Data = $Self->{POP3Account}->POP3AccountGet(ID => $ID);
        my %List = $Self->{POP3Account}->POP3AccountList(Valid => 0);
        $Output .= $Self->{LayoutObject}->Header(Title => 'Change POP3 Account');
        $Output .= $Self->{LayoutObject}->AdminNavigationBar();
        $Output .= $Self->{LayoutObject}->AdminPOP3Form(%Data, POP3AccountList => \%List);
        $Output .= $Self->{LayoutObject}->Footer();
    }
    # --
    # update action
    # --
    elsif ($Self->{Subaction} eq 'ChangeAction') {
        my %GetParam;
        foreach (@Params) {
            $GetParam{$_} = $Self->{ParamObject}->GetParam(Param => $_);
        }
        if ($Self->{POP3Account}->POP3AccountUpdate(%GetParam, UserID => $Self->{UserID})) { 
            $Output .= $Self->{LayoutObject}->Redirect(OP => "Action=$NextScreen");
        }
        else {
            $Output .= $Self->{LayoutObject}->Header(Title => 'Error');
            $Output .= $Self->{LayoutObject}->Error(
                Message => 'DB Error!!',
                Comment => 'Please contact your admin');
            $Output .= $Self->{LayoutObject}->Footer();
        }
    }
    # --
    # add new queue
    # --
    elsif ($Self->{Subaction} eq 'AddAction') {
        my %GetParam;
        foreach (@Params) {
            $GetParam{$_} = $Self->{ParamObject}->GetParam(Param => $_);
        }
        if ($Self->{POP3Account}->POP3AccountAdd(%GetParam, UserID => $Self->{UserID}) ) {
             $Output .= $Self->{LayoutObject}->Redirect(OP => "Action=$NextScreen");
        }
        else {
            $Output .= $Self->{LayoutObject}->Header(Title => 'Error');
            $Output .= $Self->{LayoutObject}->AdminNavigationBar();
            $Output .= $Self->{LayoutObject}->Error(
                Message => 'DB Error!!',
                Comment => 'Please contact your admin');
            $Output .= $Self->{LayoutObject}->Footer();
        }
    }
    # --
    # else ! print form 
    # --
    else {
        my %List = $Self->{POP3Account}->POP3AccountList(Valid => 0);
        $Output .= $Self->{LayoutObject}->Header(Title => 'Add POP3 Account');
        $Output .= $Self->{LayoutObject}->AdminNavigationBar();
        $Output .= $Self->{LayoutObject}->AdminPOP3Form(POP3AccountList => \%List);
        $Output .= $Self->{LayoutObject}->Footer();
    }
    return $Output;
}
# --

1;
