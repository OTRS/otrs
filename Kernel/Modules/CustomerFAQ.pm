# --
# Kernel/Modules/FAQ.pm - faq module
# Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: CustomerFAQ.pm,v 1.3 2004-04-01 09:20:50 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::CustomerFAQ;

use strict;
use Kernel::System::FAQ;

use vars qw($VERSION);
$VERSION = '$Revision: 1.3 $';
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
    if (!$Param{States}) {
        $Param{States} = ['external (customer)', 'public (all)'];
    }

    $Output .= $Self->{LayoutObject}->CustomerHeader(Area => 'FAQ');
    $Output .= $Self->{LayoutObject}->CustomerNavigationBar() if ($Self->{Action});

    $Param{What} = $Self->{ParamObject}->GetParam(Param => 'What') || '';
    $Param{Keyword} = $Self->{ParamObject}->GetParam(Param => 'Keyword') || '';
    my @LanguageIDs = $Self->{ParamObject}->GetArray(Param => 'LanguageIDs');
    my @CategoryIDs = $Self->{ParamObject}->GetArray(Param => 'CategoryIDs');

    $Param{LanguageOption} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => { $Self->{FAQObject}->LanguageList(UserID => $Self->{UserID}) },
        Size => 6,
        Name => 'LanguageIDs',
        Multiple => 1,
        SelectedIDRefArray => \@LanguageIDs,
        HTMLQuote => 1,
        LanguageTranslation => 0,
    );

    $Param{CategoryOption} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => { $Self->{FAQObject}->CategoryList(UserID => $Self->{UserID}) },
        Size => 6,
        Name => 'CategoryIDs',
        Multiple => 1,
        SelectedIDRefArray => \@CategoryIDs,
        HTMLQuote => 1,
        LanguageTranslation => 0,
    );


    # search
    if (!$ID && !$Self->{Subaction}) {
        $Output = $Self->{LayoutObject}->CustomerHeader(Area => 'FAQ', Title => 'Search');
        $Output .= $Self->{LayoutObject}->CustomerNavigationBar() if ($Self->{Action});
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'CustomerFAQSearch', 
            Data => { %Param },
        );
        # build an overview
        my %Categories = $Self->{FAQObject}->CategoryList(UserID => $Self->{UserID});
        foreach (sort {$Categories{$a} cmp $Categories{$b}} keys %Categories) {
            $Param{Overview} .= "<b>".$Self->{LayoutObject}->Ascii2Html(Text => $Categories{$_})."</b><br>";
            my @FAQIDs = $Self->{FAQObject}->Search(
                %Param,
                States => $Param{States},
#                LanguageIDs => \@LanguageIDs,
                CategoryIDs => [$_],
                UserID => $Self->{UserID},
            );
            my %AllArticle = ();
            foreach (@FAQIDs) {
                my %Data = $Self->{FAQObject}->ArticleGet(ID => $_, UserID => $Self->{UserID});
                foreach (keys %Data) {
                    $Data{$_} = $Self->{LayoutObject}->Ascii2Html(Text => $Data{$_});
                }
                $AllArticle{$Data{ID}} = "<a href='\$Env{\"Baselink\"}Action=\$Env{\"Action\"}&ID=$_'>";
                $AllArticle{$Data{ID}} .= "[$Data{Language}/$Data{Category}] $Data{Subject} (\$Text{\"modified\"} \$TimeLong{\"$Data{Changed}\"})</a><br>";
            }
            foreach (sort {$AllArticle{$a} cmp $AllArticle{$b}} keys %AllArticle) {
                $Param{Overview} .= $AllArticle{$_};
            }
        }
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'CustomerFAQOverview',
            Data => { %Param },
        );
    }
    # search action
    elsif ($Self->{Subaction} eq 'Search') {
        $Output = $Self->{LayoutObject}->CustomerHeader(Area => 'FAQ', Title => 'Search');
        $Output .= $Self->{LayoutObject}->CustomerNavigationBar() if ($Self->{Action});

        my @FAQIDs = $Self->{FAQObject}->Search(
            %Param,
            States => $Param{States}, 
            LanguageIDs => \@LanguageIDs,
            CategoryIDs => \@CategoryIDs,
            UserID => $Self->{UserID},
        );
        my %AllArticle = ();
        foreach (@FAQIDs) {
            my %Data = $Self->{FAQObject}->ArticleGet(ID => $_, UserID => $Self->{UserID}); 
            foreach (keys %Data) {
                $Data{$_} = $Self->{LayoutObject}->Ascii2Html(Text => $Data{$_});
            }
            $AllArticle{$Data{ID}} = "[$Data{Language}/$Data{Category}] $Data{Subject}</td><td> (\$Text{\"modified\"} \$TimeLong{\"$Data{Changed}\"})";
        }
        foreach (sort {$AllArticle{$a} cmp $AllArticle{$b}} keys %AllArticle) {
            my %Data = $Self->{FAQObject}->ArticleGet(ID => $_, UserID => $Self->{UserID}); 
            $Param{List} .= "<tr><td><a href='\$Env{\"Baselink\"}Action=\$Env{\"Action\"}&ID=$_'>$AllArticle{$Data{ID}}</a></td></tr>\n";
        }
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'CustomerFAQSearch', 
            Data => { %Param },
        );
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'CustomerFAQSearchResult', 
            Data => { %Param },
        );
#        $Output .= $List;
    }
    # system history
    elsif ($Self->{Subaction} eq 'SystemHistory') {
        $Output = $Self->{LayoutObject}->CustomerHeader(Area => 'FAQ', Title => 'History');
        $Output .= $Self->{LayoutObject}->CustomerNavigationBar() if ($Self->{Action});
        my @History = $Self->{FAQObject}->HistoryGet(
            UserID => $Self->{UserID},
        );
        foreach my $Row (@History) {
            my %Data = $Self->{FAQObject}->ArticleGet(ID => $Row->{ID}, UserID => $Self->{UserID}); 
            foreach (keys %Data) {
                $Data{$_} = $Self->{LayoutObject}->Ascii2Html(Text => $Data{$_});
            }
            $Param{HistoryList} .= "<tr><td><a href=\"\$Env{\"Baselink\"}Action=\$Env{\"Action\"}&ID=$Row->{ID}\">[$Data{Language}/$Data{Category}] $Data{Subject}</a></td><td> (\$Text{\"$Row->{Name}\"} - \$TimeLong{\"$Data{Changed}\"})</td></tr>";
        }
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'CustomerFAQArticleSystemHistory', 
            Data => { 
                ID => $ID,
                %Param 
            },
        );

    }
    # view
    elsif ($ID && $Self->{Subaction} eq 'Print') {
        my %Data = $Self->{FAQObject}->ArticleGet(ID => $ID, UserID => $Self->{UserID});
        $Output = $Self->{LayoutObject}->PrintHeader(Area => 'FAQ', Title => $Data{Subject});
        if ($Data{State} =~ /(external \(customer\)|public \(all\))/i) {
            $Output .= $Self->{LayoutObject}->Output(
                TemplateFile => 'CustomerFAQArticlePrint', 
                Data => { %Param, %Data },
            );
        }
        $Output .= $Self->{LayoutObject}->PrintFooter();
        return $Output;
    }
    elsif ($ID) {
        my %Data = $Self->{FAQObject}->ArticleGet(ID => $ID, UserID => $Self->{UserID});
        $Output = $Self->{LayoutObject}->CustomerHeader(Area => 'FAQ', Title => $Data{Subject});
        $Output .= $Self->{LayoutObject}->CustomerNavigationBar() if ($Self->{Action});
        if ($Data{State} =~ /(external \(customer\)|public \(all\))/i) {
            $Output .= $Self->{LayoutObject}->Output(
                TemplateFile => 'CustomerFAQArticleView', 
                Data => { %Param, %Data },
            );
        }
    }
    $Output .= $Self->{LayoutObject}->CustomerFooter();
    return $Output;
}
# --

1;
