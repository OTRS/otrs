# --
# Kernel/Modules/FAQArticle.pm - to add/update/delete faq articles
# Copyright (C) 2001-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: FAQArticle.pm,v 1.1 2004-01-05 20:06:28 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::FAQArticle;

use strict;
use Kernel::System::FAQ;

use vars qw($VERSION);
$VERSION = '$Revision: 1.1 $';
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
    my @Params = qw(ID Name CategoryID StateID Language Subject UserID Field1 Field2 Field3 FreeKey1 FreeKey2 FreeKey3);
    # get data 2 form
    if ($Self->{Subaction} eq 'Change') {
        my $ID = $Self->{ParamObject}->GetParam(Param => 'ID') || '';
        my %Data = $Self->{FAQObject}->ArticleGet(ID => $ID, UserID => $Self->{UserID});
        $Output .= $Self->{LayoutObject}->Header(Area => 'FAQ', Title => 'Article');
        $Output .= $Self->{LayoutObject}->FAQNavigationBar();
        $Output .= $Self->_Mask(%Data);
        $Output .= $Self->{LayoutObject}->Footer();
    }
    # update action
    elsif ($Self->{Subaction} eq 'ChangeAction') {
        my %GetParam;
        foreach (@Params) {
            $GetParam{$_} = $Self->{ParamObject}->GetParam(Param => $_) || '';
        }
        if ($Self->{FAQObject}->ArticleUpdate(%GetParam, UserID => $Self->{UserID})) { 
            $Output .= $Self->{LayoutObject}->Redirect(OP => "Action=FAQ&ID=$GetParam{ID}");
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
        foreach (@Params) {
            $GetParam{$_} = $Self->{ParamObject}->GetParam(Param => $_) || '';
        }
        if ($Self->{FAQObject}->ArticleAdd(%GetParam, UserID => $Self->{UserID}) ) {
            $Output .= $Self->{LayoutObject}->Redirect(OP => "Action=FAQ&ID=$GetParam{ID}");
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
        $Output .= $Self->{LayoutObject}->Header(Area => 'FAQ', Title => 'Article');
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

    $Param{CategoryOption} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => { $Self->{FAQObject}->CategoryList(UserID => $Self->{UserID}) },
        Name => 'CategoryID',
        SelectedID => $Param{CategoryID},
    );
    $Param{StateOption} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => { $Self->{FAQObject}->StateList(UserID => $Self->{UserID}) },
        Name => 'StateID',
        SelectedID => $Param{StateID},
    );
    $Param{GroupOption} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => { $Self->{GroupObject}->GroupList(Valid => 1) },
        Name => 'GroupID',
        SelectedID => $Param{GroupID},
    );

    return $Self->{LayoutObject}->Output(TemplateFile => 'FAQArticleForm', Data => \%Param);
}
# --
1;

