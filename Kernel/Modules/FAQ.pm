# --
# Kernel/Modules/FAQ.pm - faq module
# Copyright (C) 2001-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: FAQ.pm,v 1.1 2004-01-05 20:06:28 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::FAQ;

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

    foreach (keys %Param) {
        $Self->{$_} = $Param{$_};
    }

    # check needed Opjects
    foreach (qw(ParamObject DBObject LayoutObject LogObject 
      ConfigObject UserObject)) {
        die "Got no $_!" if (!$Self->{$_});
    }

    $Self->{FAQObject} = Kernel::System::FAQ->new(%Param);

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Output;
    my $ID = $Self->{ParamObject}->GetParam(Param => 'ID') || '';

    $Output .= $Self->{LayoutObject}->Header(Area => 'FAQ');
    $Output .= $Self->{LayoutObject}->FAQNavigationBar();

    # search
    if (!$ID && !$Self->{Subaction}) {
        $Output = $Self->{LayoutObject}->Header(Area => 'FAQ', Title => 'Search');
        $Output .= $Self->{LayoutObject}->FAQNavigationBar();
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'FAQSearch', 
            Data => { %Param },
        );
    }
    # search action
    elsif ($Self->{Subaction} eq 'Search') {
        my $What = $Self->{ParamObject}->GetParam(Param => 'What') || '';
        $Output = $Self->{LayoutObject}->Header(Area => 'FAQ', Title => 'Search');
        $Output .= $Self->{LayoutObject}->FAQNavigationBar();
        my @FAQIDs = $Self->{FAQObject}->Search(
            What => $What,
            UserID => $Self->{UserID},
        );
        foreach (@FAQIDs) {
            my %Data = $Self->{FAQObject}->ArticleGet(ID => $_, UserID => $Self->{UserID}); 
            $Param{List} .= "<a href='\$Env{\"Baselink\"}Action=FAQ&ID=$_'>$Data{Subject} - Changed \$TimeLong{\"$Data{Changed}\"}</a><br>\n";
        }
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'FAQSearchResult', 
            Data => { %Param },
        );
#        $Output .= $List;
    }
    # history
    elsif ($Self->{Subaction} eq 'History') {

    }
    # view
    elsif ($ID && $Self->{Subaction} eq 'Print') {
        my %Data = $Self->{FAQObject}->ArticleGet(ID => $ID, UserID => $Self->{UserID});
        $Output = $Self->{LayoutObject}->PrintHeader(Area => 'FAQ', Title => $Data{Subject});

        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'FAQArticlePrint', 
            Data => { %Param, %Data },
        );
        $Output .= $Self->{LayoutObject}->PrintFooter();
        return $Output;
    }
    elsif ($ID) {
        my %Data = $Self->{FAQObject}->ArticleGet(ID => $ID, UserID => $Self->{UserID});
        $Output = $Self->{LayoutObject}->Header(Area => 'FAQ', Title => $Data{Subject});
        $Output .= $Self->{LayoutObject}->FAQNavigationBar();

        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'FAQArticleView', 
            Data => { %Param, %Data },
        );
    }
    $Output .= $Self->{LayoutObject}->Footer();
    return $Output;
}
# --

1;
