# --
# Kernel/Modules/FAQArticle.pm - to add/update/delete faq articles
# Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: FAQArticle.pm,v 1.5 2004-02-17 23:43:32 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::FAQArticle;

use strict;
use Kernel::System::FAQ;

use vars qw($VERSION);
$VERSION = '$Revision: 1.5 $';
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
    my @Params = qw(ID Name CategoryID StateID LanguageID Subject UserID Field1 Field2 Field3 Field4 Field5 Field6 FreeKey1 FreeKey2 FreeKey3 Keywords);
    my %GetParam;
    foreach (@Params) {
        $GetParam{$_} = $Self->{ParamObject}->GetParam(Param => $_) || '';
    }
    # get data 2 form
    if ($Self->{Subaction} eq 'Change') {
        my %Data = $Self->{FAQObject}->ArticleGet(%GetParam, UserID => $Self->{UserID});
        $Output .= $Self->{LayoutObject}->Header(Area => 'FAQ', Title => 'Article');
        $Output .= $Self->{LayoutObject}->FAQNavigationBar();
        $Output .= $Self->_Mask(%Data);
        $Output .= $Self->{LayoutObject}->Footer();
    }
    # update action
    elsif ($Self->{Subaction} eq 'ChangeAction') {
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
    # delete
    elsif ($Self->{Subaction} eq 'Delete') {
        my %Data = $Self->{FAQObject}->ArticleGet(%GetParam, UserID => $Self->{UserID});
        $Output .= $Self->{LayoutObject}->Header(Area => 'FAQ', Title => 'Delete');
        $Output .= $Self->{LayoutObject}->FAQNavigationBar();
        $Output .= $Self->{LayoutObject}->Output(TemplateFile => 'FAQArticleDelete', Data => { %Param, %GetParam } );
        $Output .= $Self->{LayoutObject}->Footer();
    }
    # delete action
    elsif ($Self->{Subaction} eq 'DeleteAction') {
        if ($Self->{FAQObject}->ArticleDelete(%GetParam, UserID => $Self->{UserID}) ) {
            $Output .= $Self->{LayoutObject}->Redirect(OP => "Action=FAQ");
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
    # add new queue
    elsif ($Self->{Subaction} eq 'AddAction') {
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
        HTMLQuote => 0,
    );
    $Param{StateOption} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => { $Self->{FAQObject}->StateList(UserID => $Self->{UserID}) },
        Name => 'StateID',
        SelectedID => $Param{StateID},
        HTMLQuote => 0,
    );
    $Param{LanguageOption} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => { $Self->{FAQObject}->LanguageList(UserID => $Self->{UserID}) },
        Name => 'LanguageID',
        SelectedID => $Param{LanguageID} || $Self->{UserLanguage},
    );

    return $Self->{LayoutObject}->Output(TemplateFile => 'FAQArticleForm', Data => \%Param);
}
# --
1;
