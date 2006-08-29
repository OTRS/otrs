# --
# Kernel/Modules/AdminAutoResponse.pm - provides AdminAutoResponse HTML
# Copyright (C) 2001-2006 OTRS GmbH, http://otrs.org/
# --
# $Id: AdminAutoResponse.pm,v 1.17 2006-08-29 17:17:23 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AdminAutoResponse;

use strict;
use Kernel::System::AutoResponse;

use vars qw($VERSION);
$VERSION = '$Revision: 1.17 $';
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
    foreach (qw(ParamObject DBObject LayoutObject ConfigObject LogObject)) {
        if (!$Self->{$_}) {
            $Self->{LayoutObject}->FatalError(Message => "Got no $_!");
        }
    }

    # lib object
    $Self->{AutoResponseObject} = Kernel::System::AutoResponse->new(%Param);

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Output = '';
    $Param{Subaction} = $Self->{Subaction};
    $Param{NextScreen} = 'AdminAutoResponse';

    my @Params = (
        'ID',
        'Name',
        'Comment',
        'ValidID',
        'Response',
        'Subject',
        'TypeID',
        'AddressID',
        'Charset',
    );
    my %GetParam;
    foreach (@Params) {
        $GetParam{$_} = $Self->{ParamObject}->GetParam(Param => $_) || '';
    }
    # get composed charset
    $GetParam{Charset} = $Self->{LayoutObject}->{UserCharset};
    # get data
    if ($Param{Subaction} eq 'Change') {
        my $ID = $Self->{ParamObject}->GetParam(Param => 'ID') || '';
        my %Data = $Self->{AutoResponseObject}->AutoResponseGet(ID => $ID);
        $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->_Mask(%Data);
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
    # update action
    elsif ($Param{Subaction} eq 'ChangeAction') {
        if ($Self->{AutoResponseObject}->AutoResponseUpdate(
            %GetParam,
            UserID => $Self->{UserID},
        )) {
            return $Self->{LayoutObject}->Redirect(OP => "Action=$Param{NextScreen}");
        }
        else {
            return $Self->{LayoutObject}->ErrorScreen();
        }
    }
    # add new auto response
    elsif ($Param{Subaction} eq 'AddAction') {
        if ($Self->{AutoResponseObject}->AutoResponseAdd(
            %GetParam,
            UserID => $Self->{UserID},
        )) {
            return $Self->{LayoutObject}->Redirect(OP => "Action=$Param{NextScreen}");
        }
        else {
            return $Self->{LayoutObject}->ErrorScreen();
        }
    }
    # else ! print form
    else {
        $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->_Mask();
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
}
# --
sub _Mask {
    my $Self = shift;
    my %Param = @_;

    # build ValidID string
    $Param{'ValidOption'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => {
          $Self->{DBObject}->GetTableData(
            What => 'id, name',
            Table => 'valid',
            Valid => 0,
          )
        },
        Name => 'ValidID',
        SelectedID => $Param{ValidID},
    );

    $Param{'AutoResponseOption'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => {
          $Self->{DBObject}->GetTableData(
            What => 'id, name, id',
            Valid => 0,
            Clamp => 1,
            Table => 'auto_response',
          )
        },
        Name => 'ID',
        Size => 15,
        SelectedID => $Param{ID},
    );

    $Param{'TypeOption'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => {
          $Self->{DBObject}->GetTableData(
            What => 'id, name',
            Valid => 1,
            Clamp => 1,
            Table => 'auto_response_type',
          )
        },
        Name => 'TypeID',
        SelectedID => $Param{TypeID},
    );

    $Param{'SystemAddressOption'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => {
          $Self->{DBObject}->GetTableData(
            What => 'id, value0, value1',
            Valid => 1,
            Clamp => 1,
            Table => 'system_address',
          )
        },
        Name => 'AddressID',
        SelectedID => $Param{AddressID},
    );
    $Param{'Subaction'} = "Add" if (!$Param{'Subaction'});
    if ($Param{Charset} && $Param{Charset} !~ /$Self->{LayoutObject}->{UserCharset}/i) {
        $Param{Note} = '(<i>$Text{"This message was written in a character set other than your own."}</i>)';
    }
    return $Self->{LayoutObject}->Output(TemplateFile => 'AdminAutoResponseForm', Data => \%Param);
}
# --
1;
