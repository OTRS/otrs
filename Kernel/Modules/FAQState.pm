# --
# Kernel/Modules/FAQState.pm - to add/update/delete faq categories
# Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: FAQState.pm,v 1.2 2004-03-05 11:35:09 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::FAQState;

use strict;
use Kernel::System::FAQ;

use vars qw($VERSION);
$VERSION = '$Revision: 1.2 $';
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
        die "Got no $_" if (!$Self->{$_});
    }

    $Self->{FAQObject} = Kernel::System::FAQ->new(%Param);

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Output = '';
    # get data 2 form
    if ($Self->{Subaction} eq 'Change') {
        my $ID = $Self->{ParamObject}->GetParam(Param => 'ID') || '';
        my %Data = $Self->{FAQObject}->StateGet(ID => $ID, UserID => $Self->{UserID});
        $Output .= $Self->{LayoutObject}->Header(Area => 'FAQ', Title => 'State');
        $Output .= $Self->{LayoutObject}->FAQNavigationBar();
        $Output .= $Self->_Mask(%Data);
        $Output .= $Self->{LayoutObject}->Footer();
    }
    # update action
    elsif ($Self->{Subaction} eq 'ChangeAction') {
        my %GetParam;
        my @Params = ('ID', 'Name', 'Comment', 'GroupID');
        foreach (@Params) {
            $GetParam{$_} = $Self->{ParamObject}->GetParam(Param => $_) || '';
        }
        if ($Self->{FAQObject}->StateUpdate(%GetParam, UserID => $Self->{UserID})) { 
            $Output .= $Self->{LayoutObject}->Redirect(OP => "Action=FAQState");
        }
        else {
            $Output .= $Self->{LayoutObject}->Header(Title => 'Error');
            $Output .= $Self->{LayoutObject}->Error(
                Message => 'DB Error!!',
                Comment => 'Please contact your admin',
            );
            $Output .= $Self->{LayoutObject}->Footer();
        }
    }
    # add new queue
    elsif ($Self->{Subaction} eq 'AddAction') {
        my %GetParam;
        my @Params = ('Name', 'Comment', 'GroupID');
        foreach (@Params) {
            $GetParam{$_} = $Self->{ParamObject}->GetParam(Param => $_) || '';
        }
        if ($Self->{FAQObject}->StateAdd(%GetParam, UserID => $Self->{UserID}) ) {
             $Output .= $Self->{LayoutObject}->Redirect(OP => "Action=FAQState");
        }
        else {
            $Output .= $Self->{LayoutObject}->Header(Title => 'Error');
            $Output .= $Self->{LayoutObject}->FAQNavigationBar();
            $Output .= $Self->{LayoutObject}->Error(
                Message => 'DB Error!!',
                Comment => 'Please contact your admin',
            );
            $Output .= $Self->{LayoutObject}->Footer();
        }
    }
    # else ! print form 
    else {
        $Output .= $Self->{LayoutObject}->Header(Area => 'FAQ', Title => 'State');
        $Output .= $Self->{LayoutObject}->FAQNavigationBar();
        $Output .= $Self->_Mask();
        $Output .= $Self->{LayoutObject}->Footer();
    }
    return $Output;
}
# --
sub _Mask {
    my $Self = shift;
    my %Param = @_;

    $Param{StateOption} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => { $Self->{FAQObject}->StateList(UserID => $Self->{UserID}) },
        Size => 10,
        Name => 'ID',
        SelectedID => $Param{StateID},
    );

    return $Self->{LayoutObject}->Output(TemplateFile => 'FAQStateForm', Data => \%Param);
}
# --
1;
