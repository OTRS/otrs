# --
# Kernel/Modules/FAQCategory.pm - to add/update/delete faq categories
# Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: FAQCategory.pm,v 1.5 2004-09-16 22:04:00 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::FAQCategory;

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
    # get data 2 form
    if ($Self->{Subaction} eq 'Change') {
        my $ID = $Self->{ParamObject}->GetParam(Param => 'ID') || '';
        my %Data = $Self->{FAQObject}->CategoryGet(ID => $ID, UserID => $Self->{UserID});
        $Output .= $Self->{LayoutObject}->Header(Area => 'FAQ', Title => 'Category');
        $Output .= $Self->{LayoutObject}->NavigationBar(Type => 'FAQ');
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
        if ($Self->{FAQObject}->CategoryUpdate(%GetParam, UserID => $Self->{UserID})) {
            $Output .= $Self->{LayoutObject}->Redirect(OP => "Action=FAQCategory");
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
        if ($Self->{FAQObject}->CategoryAdd(%GetParam, UserID => $Self->{UserID}) ) {
             $Output .= $Self->{LayoutObject}->Redirect(OP => "Action=FAQCategory");
        }
        else {
            $Output .= $Self->{LayoutObject}->Header(Title => 'Error');
            $Output .= $Self->{LayoutObject}->NavigationBar(Type => 'FAQ');
            $Output .= $Self->{LayoutObject}->Error(
                Message => 'DB Error!!',
                Comment => 'Please contact your admin',
            );
            $Output .= $Self->{LayoutObject}->Footer();
        }
    }
    # else ! print form
    else {
        $Output .= $Self->{LayoutObject}->Header(Area => 'FAQ', Title => 'Category');
        $Output .= $Self->{LayoutObject}->NavigationBar(Type => 'FAQ');
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
        Size => 10,
        Name => 'ID',
        SelectedID => $Param{CategoryID},
        HTMLQuote => 1,
        LanguageTranslation => 0,
    );

    return $Self->{LayoutObject}->Output(TemplateFile => 'FAQCategoryForm', Data => \%Param);
}
# --
1;

