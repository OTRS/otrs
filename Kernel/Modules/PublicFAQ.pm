# --
# Kernel/Modules/PublicFAQ.pm - faq module
# Copyright (C) 2001-2005 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: PublicFAQ.pm,v 1.3 2005-09-11 13:38:21 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::PublicFAQ;

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
    foreach (qw(ParamObject DBObject LayoutObject LogObject ConfigObject UserObject)) {
        if (!$Self->{$_}) {
            $Self->{LayoutObject}->FatalError(Message => "Got no $_!");
        }
    }

    $Self->{FAQObject} = Kernel::System::FAQ->new(%Param);

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Output;
    my $ID = $Self->{ParamObject}->GetParam(Param => 'ID') || $Self->{ParamObject}->GetParam(Param => 'FAQID') || '';
    if (!$Param{States}) {
        $Param{States} = ['public (all)'];
    }

    $Output .= $Self->{LayoutObject}->CustomerHeader();

    $Param{What} = $Self->{ParamObject}->GetParam(Param => 'What') || '';
    $Param{Keyword} = $Self->{ParamObject}->GetParam(Param => 'Keyword') || '';
    my @LanguageIDs = $Self->{ParamObject}->GetArray(Param => 'LanguageIDs');
    my @CategoryIDs = $Self->{ParamObject}->GetArray(Param => 'CategoryIDs');

    $Param{LanguageOption} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => { $Self->{FAQObject}->LanguageList() },
        Size => 6,
        Name => 'LanguageIDs',
        Multiple => 1,
        SelectedIDRefArray => \@LanguageIDs,
        HTMLQuote => 1,
        LanguageTranslation => 0,
    );

    $Param{CategoryOption} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => { $Self->{FAQObject}->CategoryList() },
        Size => 6,
        Name => 'CategoryIDs',
        Multiple => 1,
        SelectedIDRefArray => \@CategoryIDs,
        HTMLQuote => 1,
        LanguageTranslation => 0,
    );


    # search
    if (!$ID && !$Self->{Subaction}) {
        my $Output = $Self->{LayoutObject}->CustomerHeader(Title => 'Search');
        $Self->{LayoutObject}->Block(
            Name => 'Search',
            Data => { %Param },
        );
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'CustomerFAQ',
            Data => { %Param },
        );
        $Output .= $Self->{LayoutObject}->CustomerFooter();
        return $Output;
    }
    elsif ($Self->{Subaction} eq 'Download') {
        my $FAQID = $Self->{ParamObject}->GetParam(Param => 'FAQID');
        my %FAQ = $Self->{FAQObject}->FAQGet(FAQID => $FAQID);
        if (%FAQ && $FAQ{State} =~ /(public \(all\))/i) {
            return $Self->{LayoutObject}->Attachment(%FAQ);
        }
        else {
            return $Self->{LayoutObject}->ErrorScreen();
        }
    }
    # search action
    elsif ($Self->{Subaction} eq 'Search') {
        my $Output = $Self->{LayoutObject}->CustomerHeader(Title => 'Search');
        $Self->{LayoutObject}->Block(
            Name => 'Search',
            Data => { %Param },
        );
        $Self->{LayoutObject}->Block(
            Name => 'SearchResult',
            Data => { %Param },
        );

        my @FAQIDs = $Self->{FAQObject}->FAQSearch(
            %Param,
            States => $Param{States},
            LanguageIDs => \@LanguageIDs,
            CategoryIDs => \@CategoryIDs,
            UserID => $Self->{UserID},
        );
        my %AllArticle = ();
        foreach (@FAQIDs) {
            my %Data = $Self->{FAQObject}->FAQGet(FAQID => $_);
            $Self->{LayoutObject}->Block(
                Name => 'SearchResultRow',
                Data => { %Param, %Data },
            );
        }
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'CustomerFAQ',
            Data => { %Param },
        );
        $Output .= $Self->{LayoutObject}->CustomerFooter();
        return $Output;
    }
    # system history
    elsif ($Self->{Subaction} eq 'SystemHistory') {
        $Output = $Self->{LayoutObject}->CustomerHeader(Title => 'History');
        $Self->{LayoutObject}->Block(
            Name => 'SystemHistory',
            Data => { %Param },
        );
        my @History = $Self->{FAQObject}->HistoryGet(
            UserID => $Self->{UserID},
        );
        foreach my $Row (@History) {
            my %Data = $Self->{FAQObject}->FAQGet(FAQID => $Row->{FAQID});
            if ($Data{State} =~ /(public \(all\))/i) {
                $Self->{LayoutObject}->Block(
                    Name => 'SystemHistoryRow',
                    Data => { %Data },
                );
            }
        }
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'CustomerFAQ',
            Data => { %Param },
        );
        $Output .= $Self->{LayoutObject}->CustomerFooter();
        return $Output;

    }
    # view
    elsif ($ID && $Self->{Subaction} eq 'Print') {
        my %Data = $Self->{FAQObject}->FAQGet(FAQID => $ID);
        my $Output = $Self->{LayoutObject}->PrintHeader(Title => 'View', Value => $Data{Number});
        # check permission
        if ($Data{State} =~ /(public \(all\))/i) {
            $Self->{LayoutObject}->Block(
                Name => 'ViewPrint',
                Data => { %Data },
            );
        }
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'CustomerFAQ',
            Data => { %Param },
        );
        $Output .= $Self->{LayoutObject}->PrintFooter();
        return $Output;
    }
    elsif ($ID) {
        # get article
        my %Data = $Self->{FAQObject}->FAQGet(FAQID => $ID);
        my $Output = $Self->{LayoutObject}->CustomerHeader(Title => 'View', Value => $Data{Number});
        # check permission
        if ($Data{State} =~ /(public \(all\))/i) {
            $Self->{LayoutObject}->Block(
                Name => 'View',
                Data => { %Data },
            );
        }
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'CustomerFAQ',
            Data => { %Param },
        );
        $Output .= $Self->{LayoutObject}->CustomerFooter();
        return $Output;
    }
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'CustomerFAQ',
        Data => { %Param },
    );
    $Output .= $Self->{LayoutObject}->CustomerFooter();
    return $Output;
}
# --

1;
