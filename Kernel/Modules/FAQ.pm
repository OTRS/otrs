# --
# Kernel/Modules/FAQ.pm - faq module
# Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: FAQ.pm,v 1.7 2004-03-24 15:40:59 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::FAQ;

use strict;
use Kernel::System::FAQ;

use vars qw($VERSION);
$VERSION = '$Revision: 1.7 $';
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
    my $Output = $Self->{LayoutObject}->Header(Title => 'FAQ');
    my $ID = $Self->{ParamObject}->GetParam(Param => 'ID') || '';
    my $Nav = $Self->{ParamObject}->GetParam(Param => 'Nav') || '';
    my $NavBar = '';
    my $HeaderType = $Self->{LastFAQNav} || '';

    if ($Nav && $Nav eq 'None') {
        $HeaderType = 'Small';
        # store nav param
        $Self->{SessionObject}->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key => 'LastFAQNav',
            Value => $HeaderType,
        );
    }
    if ($Nav && $Nav ne 'None') {
        $HeaderType = '';
        # store nav param
        $Self->{SessionObject}->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key => 'LastFAQNav',
            Value => $HeaderType,
        );
    }
    if ($HeaderType ne 'Small') {
        $NavBar = $Self->{LayoutObject}->FAQNavigationBar();
    }
   
    $Param{What} = $Self->{ParamObject}->GetParam(Param => 'What');
    if (!defined($Param{What})) {
        $Param{What} = $Self->{LastFAQWhat} || '';
    }
    $Param{Keyword} = $Self->{ParamObject}->GetParam(Param => 'Keyword');
    if (!defined($Param{Keyword})) {
        $Param{Keyword} = $Self->{LastFAQKeyword} || '';
    }
    my @LanguageIDs = $Self->{ParamObject}->GetArray(Param => 'LanguageIDs');
    my @CategoryIDs = $Self->{ParamObject}->GetArray(Param => 'CategoryIDs');

    # store search params
    $Self->{SessionObject}->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key => 'LastFAQWhat',
        Value => $Param{What},
    );
    $Self->{SessionObject}->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key => 'LastFAQKeyword',
        Value => $Param{Keyword},
    );


    $Param{LanguageOption} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => { $Self->{FAQObject}->LanguageList(UserID => $Self->{UserID}) },
        Size => 5,
        Name => 'LanguageIDs',
        Multiple => 1,
        SelectedIDRefArray => \@LanguageIDs,
        HTMLQuote => 0,
    );

    $Param{CategoryOption} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => { $Self->{FAQObject}->CategoryList(UserID => $Self->{UserID}) },
        Size => 5,
        Name => 'CategoryIDs',
        Multiple => 1,
        SelectedIDRefArray => \@CategoryIDs,
        HTMLQuote => 0,
    );


    # search
    if (!$ID && !$Self->{Subaction}) {
        $Output = $Self->{LayoutObject}->Header(Area => 'FAQ', Title => 'Search', Type => $HeaderType);
        $Output .= $NavBar;
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'FAQSearch', 
            Data => { %Param },
        );
        # build an overview
        my %Categories = $Self->{FAQObject}->CategoryList(UserID => $Self->{UserID});
        foreach (sort {$Categories{$a} cmp $Categories{$b}} keys %Categories) {
            $Param{Overview} .= "<b>$Categories{$_}</b><br>";
            my @FAQIDs = $Self->{FAQObject}->Search(
                %Param,
#            States => ['internal (agent)', 'external (customer)', 'public (all)'],
#                LanguageIDs => \@LanguageIDs,
                CategoryIDs => [$_],
                UserID => $Self->{UserID},
            );
            my %AllArticle = ();
            foreach (@FAQIDs) {
                my %Data = $Self->{FAQObject}->ArticleGet(ID => $_, UserID => $Self->{UserID}); 
                $AllArticle{$Data{ID}} = "<a href='\$Env{\"Baselink\"}Action=\$Env{\"Action\"}&ID=$_'>";
                $AllArticle{$Data{ID}} .= "[$Data{Language}/$Data{Category}] $Data{Subject} (\$Text{\"modified\"} \$TimeLong{\"$Data{Changed}\"})</a><br>";
                $AllArticle{$Data{ID}} = "[$Data{Language}/$Data{Category}] $Data{Subject}";
            }
            $Param{Overview} .= '<table border="0" width="100%">';
            foreach (sort {$AllArticle{$a} cmp $AllArticle{$b}} keys %AllArticle) {
                my %Data = $Self->{FAQObject}->ArticleGet(ID => $_, UserID => $Self->{UserID});
#                $Param{Overview} .= $AllArticle{$_};
                $Param{Overview} .= "<tr><td>[$Data{Language}]</td><td><a href='\$Env{\"Baselink\"}Action=\$Env{\"Action\"}&ID=$_'>$Data{Subject}</a></td><td align='right'>(\$Text{\"modified\"} \$TimeLong{\"$Data{Changed}\"})</td></tr>\n";
            }
            $Param{Overview} .= '</table>';
        }
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'FAQOverview', 
            Data => { %Param },
        );
    }
    # search action
    elsif ($Self->{Subaction} eq 'Search') {
        $Output = $Self->{LayoutObject}->Header(Area => 'FAQ', Title => 'Search', Type => $HeaderType);
        $Output .= $NavBar;
        my @FAQIDs = $Self->{FAQObject}->Search(
            %Param,
            States => ['external (customer)', 'public (all)', 'internal (agent)'],
            LanguageIDs => \@LanguageIDs,
            CategoryIDs => \@CategoryIDs,
            UserID => $Self->{UserID},
        );
        my %AllArticle = ();
        foreach (@FAQIDs) {
            my %Data = $Self->{FAQObject}->ArticleGet(ID => $_, UserID => $Self->{UserID});
            $AllArticle{$Data{ID}} = "[$Data{Language}/$Data{Category}] $Data{Subject}</td><td align='right'> (\$Text{\"modified\"} \$TimeLong{\"$Data{Changed}\"})";
        }
        foreach (sort {$AllArticle{$a} cmp $AllArticle{$b}} keys %AllArticle) {
            my %Data = $Self->{FAQObject}->ArticleGet(ID => $_, UserID => $Self->{UserID}); 
            $Param{List} .= "<tr><td><a href='\$Env{\"Baselink\"}Action=\$Env{\"Action\"}&ID=$_'>$AllArticle{$Data{ID}}</a></td></tr>\n";
        }
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'FAQSearch', 
            Data => { %Param },
        );
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'FAQSearchResult', 
            Data => { %Param },
        );
#        $Output .= $List;
    }
    # history
    elsif ($Self->{Subaction} eq 'History') {
        $Output = $Self->{LayoutObject}->Header(Area => 'FAQ', Title => 'History', Type => $HeaderType);
        $Output .= $NavBar;
        my @History = $Self->{FAQObject}->ArticleHistoryGet(
            ID => $ID,
            UserID => $Self->{UserID},
        );
        foreach my $Row (@History) {
            $Param{HistoryList} .= "<tr><td>\$Text{\"$Row->{Name}\"}</td><td>(\$TimeLong{\"$Row->{Created}\"})</td></tr>";
        }
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'FAQArticleHistory', 
            Data => { 
                ID => $ID,
                %Param 
            },
        );

    }
    # system history
    elsif ($Self->{Subaction} eq 'SystemHistory') {
        $Output = $Self->{LayoutObject}->Header(Area => 'FAQ', Title => 'History', Type => $HeaderType);
        $Output .= $NavBar;
        my @History = $Self->{FAQObject}->HistoryGet(
            UserID => $Self->{UserID},
        );
        foreach my $Row (@History) {
            my %Data = $Self->{FAQObject}->ArticleGet(ID => $Row->{ID}, UserID => $Self->{UserID}); 
            my %User = $Self->{UserObject}->GetUserData(
                UserID => $Row->{CreatedBy},
                Cached => 1,
            );
            $Param{HistoryList} .= "<tr><td><a href=\"\$Env{\"Baselink\"}Action=\$Env{\"Action\"}&ID=$Row->{ID}\">[$Data{Language}/$Data{Category}] $Data{Subject}</a></td><td> (\$Text{\"$Row->{Name}\"} - \$TimeLong{\"$Data{Changed}\"} - $User{UserLogin} ($User{UserFirstname} $User{UserLastname}))</td></tr>";
        }
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'FAQArticleSystemHistory', 
            Data => { 
                ID => $ID,
                %Param 
            },
        );

    }
    # view
    elsif ($ID && $Self->{Subaction} eq 'Print') {
        my %Data = $Self->{FAQObject}->ArticleGet(ID => $ID, UserID => $Self->{UserID});
        $Output = $Self->{LayoutObject}->PrintHeader(Area => 'FAQ', Title => $Data{Subject}, Type => $HeaderType);

        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'FAQArticlePrint', 
            Data => { %Param, %Data },
        );
        $Output .= $Self->{LayoutObject}->PrintFooter();
        return $Output;
    }
    elsif ($ID) {
        my %Data = $Self->{FAQObject}->ArticleGet(ID => $ID, UserID => $Self->{UserID});
        $Output = $Self->{LayoutObject}->Header(Area => 'FAQ', Title => $Data{Subject}, Type => $HeaderType);
        $Output .= $NavBar;
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'FAQSearch', 
            Data => { %Param },
        );
        if ($HeaderType eq 'Small') {
            $Output .= $Self->{LayoutObject}->Output(
                TemplateFile => 'FAQArticleViewSmall', 
                Data => { %Param, %Data },
            );
        }
        else {
            $Output .= $Self->{LayoutObject}->Output(
                TemplateFile => 'FAQArticleView', 
                Data => { %Param, %Data },
            );
        }
    }
    $Output .= $Self->{LayoutObject}->Footer(Type => $HeaderType);
    return $Output;
}
# --

1;
