# --
# Kernel/Modules/AdminAutoResponse.pm - provides AdminAutoResponse HTML
# Copyright (C) 2001-2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AdminAutoResponse.pm,v 1.6 2002-10-25 11:46:00 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AdminAutoResponse;

use strict;
use Kernel::System::AutoResponse;

use vars qw($VERSION);
$VERSION = '$Revision: 1.6 $';
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

    # lib object
    $Self->{AutoResponseObject} = Kernel::System::AutoResponse->new(
        %Param,
    );

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Output = '';
    $Param{Subaction} = $Self->{Subaction};
    $Param{NextScreen} = 'AdminAutoResponse';

    # --  
    # permission check
    # -- 
    if (!$Self->{PermissionObject}->Section(
            UserID => $Self->{UserID},
            Section => 'Admin',
        )) {
        $Output .= $Self->{LayoutObject}->NoPermission();
        return $Output;
    }
   
    my @Params = (
        'ID',
        'Name',
        'Comment',
        'ValidID',
        'Response',
        'Subject',
        'TypeID',
        'AddressID',
        'CharsetID',
    );

    # -- 
    # get data 
    # --
    if ($Param{Subaction} eq 'Change') {
        my $ID = $Self->{ParamObject}->GetParam(Param => 'ID') || '';
        my %Data = $Self->{AutoResponseObject}->AutoResponseGet(ID => $ID);
        $Output = $Self->{LayoutObject}->Header(Title => 'Auto response change');
        $Output .= $Self->{LayoutObject}->AdminNavigationBar();
        $Output .= $Self->{LayoutObject}->AdminAutoResponseForm(%Data);
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
    # --
    # update action
    # --
    elsif ($Param{Subaction} eq 'ChangeAction') {
        my %GetParam;
        foreach (@Params) {
            $GetParam{$_} = $Self->{ParamObject}->GetParam(Param => $_) || '';
        }
        if ($Self->{AutoResponseObject}->AutoResponseUpdate(
            %GetParam,
            UserID => $Self->{UserID},
        )) {
            return $Self->{LayoutObject}->Redirect(OP => "Action=$Param{NextScreen}");
        }
        else {
            $Output = $Self->{LayoutObject}->Header(Title => 'Error');
            $Output .= $Self->{LayoutObject}->AdminNavigationBar();
            $Output .= $Self->{LayoutObject}->Error();
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
    }
    # --
    # add new auto response 
    # --
    elsif ($Param{Subaction} eq 'AddAction') {
        my %GetParam;
        foreach (@Params) {
            $GetParam{$_} = $Self->{ParamObject}->GetParam(Param => $_) || '';
        }
        if ($Self->{AutoResponseObject}->AutoResponseAdd(
            %GetParam,
            UserID => $Self->{UserID},
        )) {
            return $Self->{LayoutObject}->Redirect(OP => "Action=$Param{NextScreen}");
        }
        else {
            $Output = $Self->{LayoutObject}->Header(Title => 'Error');
            $Output .= $Self->{LayoutObject}->AdminNavigationBar();
            $Output .= $Self->{LayoutObject}->Error();
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
    }
    # --
    # else ! print form
    # --
    else {
        $Output = $Self->{LayoutObject}->Header(Title => 'Auto response add');
        $Output .= $Self->{LayoutObject}->AdminNavigationBar();
        $Output .= $Self->{LayoutObject}->AdminAutoResponseForm();
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
}
# --

1;
