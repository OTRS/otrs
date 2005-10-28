# --
# Kernel/Modules/FAQ.pm - faq module
# Copyright (C) 2001-2005 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: FAQ.pm,v 1.17 2005-10-28 07:27:18 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::FAQ;

use strict;
use Kernel::System::FAQ;
use Kernel::System::LinkObject;

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

    foreach (keys %Param) {
        $Self->{$_} = $Param{$_};
    }

    # check needed Opjects
    foreach (qw(ParamObject DBObject LayoutObject LogObject ConfigObject UserObject)) {
        $Self->{LayoutObject}->FatalError(Message => "Got no $_!") if (!$Self->{$_});
    }

    # faq object
    $Self->{FAQObject} = Kernel::System::FAQ->new(%Param);
    # link object
    $Self->{LinkObject} = Kernel::System::LinkObject->new(%Param);

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my $ID = $Self->{ParamObject}->GetParam(Param => 'ID') || $Self->{ParamObject}->GetParam(Param => 'FAQID') || '';
    my $Nav = $Self->{ParamObject}->GetParam(Param => 'Nav') || '';
    my $NavBar = '';
    my $HeaderType = $Self->{LastFAQNav} || '';
    my @Params = qw(ID Number Name CategoryID StateID LanguageID Title UserID Field1 Field2 Field3 Field4 Field5 Field6 FreeKey1 FreeKey2 FreeKey3 Keywords);

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
    my $Output = $Self->{LayoutObject}->Header();
    if ($HeaderType ne 'Small') {
        $NavBar = $Self->{LayoutObject}->NavigationBar();
    }


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

    # ---------------------------------------------------------- #
    # add a new object (Note: dtl text "New")
    # ---------------------------------------------------------- #
    if ($Self->{Subaction} eq 'Add') {
        my $Output   = '';
        my %Frontend = ();
        # permission check
        if (!$Self->{AccessRw}) {
            return $Self->{LayoutObject}->NoPermission(WithHeader => 'yes');
        }
        $Frontend{LanguageOption} = $Self->{LayoutObject}->OptionStrgHashRef(
            Data => { $Self->{FAQObject}->LanguageList() },
            Name => 'LanguageID',
            LanguageTranslation => 0,
            Selected => $Self->{UserLanguage},
        );
        $Frontend{CategoryOption} = $Self->{LayoutObject}->OptionStrgHashRef(
            Data => { $Self->{FAQObject}->CategoryList() },
            Name => 'CategoryID',
            LanguageTranslation => 0,
        );
        $Frontend{StateOption} = $Self->{LayoutObject}->OptionStrgHashRef(
            Data => { $Self->{FAQObject}->StateList() },
            Name => 'StateID',
            Selected => 'internal (agent)',
        );

        # add add block
        $Self->{LayoutObject}->Block(
            Name => 'Add',
            Data => {%Param, %Frontend},
        );
        # build output
        $Output .= $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->{LayoutObject}->Output(
            Data => {%Param, %Frontend},
            TemplateFile => 'FAQ',
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
    # ---------------------------------------------------------- #
    # add a object to database
    # ---------------------------------------------------------- #
    elsif ($Self->{Subaction} eq 'AddAction') {
        my $FAQID       = '';
        my %Param       = ();
        foreach (@Params) {
            $Param{$_} = $Self->{ParamObject}->GetParam(Param => $_);
        }
        # get submit attachment
        my %UploadStuff = $Self->{ParamObject}->GetUploadAll(
            Param => 'file_upload',
            Source => 'String',
        );

        # permission check
        if (!$Self->{AccessRw}) {
            return $Self->{LayoutObject}->NoPermission(WithHeader => 'yes');
        }

        $FAQID = $Self->{FAQObject}->FAQAdd(
            %Param,
            %UploadStuff,
        );

        if ($FAQID) {
            return $Self->{LayoutObject}->Redirect(OP => "Action=$Self->{Action}&Subaction=View&FAQID=$FAQID");
        }
        else {
            return $Self->{LayoutObject}->ErrorScreen();
        }
    }
    # ---------------------------------------------------------- #
    # update object (Note: dtl text "Edit")
    # ---------------------------------------------------------- #
    elsif ($Self->{Subaction} eq 'Update') {
        my $Output      = '';
        my %Frontend    = ();
        my %FAQ         = ();
        my $FAQID       = $Self->{ParamObject}->GetParam(Param => 'FAQID');
        # permission check
        if (!$Self->{AccessRw}) {
            return $Self->{LayoutObject}->NoPermission(WithHeader => 'yes');
        }
        # get artefact
        %FAQ = $Self->{FAQObject}->FAQGet(FAQID => $FAQID);
        if (!%FAQ) {
            return $Self->{LayoutObject}->ErrorScreen();
        }
        $Frontend{LanguageOption} = $Self->{LayoutObject}->OptionStrgHashRef(
            Data => { $Self->{FAQObject}->LanguageList() },
            Name => 'LanguageID',
            LanguageTranslation => 0,
            SelectedID => $FAQ{LanguageID},
        );
        $Frontend{CategoryOption} = $Self->{LayoutObject}->OptionStrgHashRef(
            Data => { $Self->{FAQObject}->CategoryList() },
            Name => 'CategoryID',
            LanguageTranslation => 0,
            SelectedID => $FAQ{CategoryID},
        );
        $Frontend{StateOption} = $Self->{LayoutObject}->OptionStrgHashRef(
            Data => { $Self->{FAQObject}->StateList() },
            Name => 'StateID',
            SelectedID => $FAQ{StateID},
        );
        $Self->{LayoutObject}->Block(
            Name => 'Update',
            Data => { %FAQ, %Frontend },
        );

        # build output
        $Output .= $Self->{LayoutObject}->Header(Title => "Edit");
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->{LayoutObject}->Output(
            Data => {%Param, %Frontend},
            TemplateFile => 'FAQ',
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
    # ---------------------------------------------------------- #
    # update a object in database
    # ---------------------------------------------------------- #
    elsif ($Self->{Subaction} eq 'UpdateAction') {
        my %GetParam    = ();
        foreach ('FAQID', @Params) {
            $GetParam{$_} = $Self->{ParamObject}->GetParam(Param => $_);
        }
        # get submit attachment
        my %UploadStuff = $Self->{ParamObject}->GetUploadAll(
            Param => 'file_upload',
            Source => 'String',
        );
        # permission check
        if (!$Self->{AccessRw}) {
            return $Self->{LayoutObject}->NoPermission(WithHeader => 'yes');
        }
        if ($Self->{FAQObject}->FAQUpdate(%GetParam, %UploadStuff)) {
            return $Self->{LayoutObject}->Redirect(OP => "Action=$Self->{Action}&Subaction=View&FAQID=$GetParam{FAQID}");
        }
        else {
            return $Self->{LayoutObject}->ErrorScreen();
        }
    }
    # ---------------------------------------------------------- #
    # delete screen
    # ---------------------------------------------------------- #
    elsif ($Self->{Subaction} eq 'Delete') {
        my $Output      = '';
        my %FAQ         = ();
        my $FAQID       = $Self->{ParamObject}->GetParam(Param => 'FAQID');
        # permission check
        if (!$Self->{AccessRw}) {
            return $Self->{LayoutObject}->NoPermission(WithHeader => 'yes');
        }
        # get article
        %FAQ = $Self->{FAQObject}->FAQGet(FAQID => $FAQID);
        if (!%FAQ) {
            return $Self->{LayoutObject}->ErrorScreen();
        }
        $Self->{LayoutObject}->Block(
            Name => 'Delete',
            Data => {%FAQ},
        );
        # build output
        $Output .= $Self->{LayoutObject}->Header(Title => "Delete");
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->{LayoutObject}->Output(
            Data => {%Param},
            TemplateFile => 'FAQ',
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
    # ---------------------------------------------------------- #
    # delete object from database
    # ---------------------------------------------------------- #
    elsif ($Self->{Subaction} eq 'DeleteAction') {
        my $FAQID = $Self->{ParamObject}->GetParam(Param => 'FAQID');
        # permission check
        if (!$Self->{AccessRw}) {
            return $Self->{LayoutObject}->NoPermission(WithHeader => 'yes');
        }
        if ($Self->{FAQObject}->FAQDelete(FAQID => $FAQID)) {
            return $Self->{LayoutObject}->Redirect(OP => $Self->{LastScreenOverview});
        }
        else {
            return $Self->{LayoutObject}->ErrorScreen();
        }
    }
    # ---------------------------------------------------------- #
    # download object
    # ---------------------------------------------------------- #
    elsif ($Self->{Subaction} eq 'Download') {
        my $FAQID = $Self->{ParamObject}->GetParam(Param => 'FAQID');
        my %FAQ = $Self->{FAQObject}->FAQGet(FAQID => $FAQID);
        if (%FAQ) {
            return $Self->{LayoutObject}->Attachment(%FAQ);
        }
        else {
            return $Self->{LayoutObject}->ErrorScreen();
        }
    }
    # ---------------------------------------------------------- #
    # search a object
    # ---------------------------------------------------------- #
    elsif ($Self->{Subaction} eq 'Search') {
        my %GetParam    = ();
        my %Frontend    = ();
        # store last queue screen
        $Self->{SessionObject}->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key => 'LastScreenOverview',
            Value => $Self->{RequestedURL},
        );
        # store last screen
        $Self->{SessionObject}->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key => 'LastScreenView',
            Value => $Self->{RequestedURL},
        );
        # get params
        foreach (qw(LanguageIDs CategoryIDs)) {
            my @Array = $Self->{ParamObject}->GetArray(Param => $_);
            if (@Array) {
                $GetParam{$_} = \@Array;
            }
        }
        foreach (qw(Number Title What Keyword)) {
            $GetParam{$_} = $Self->{ParamObject}->GetParam(Param => $_);
        }

        $Frontend{LanguageOption} = $Self->{LayoutObject}->OptionStrgHashRef(
            Data => { $Self->{FAQObject}->LanguageList() },
            Size => 5,
            Name => 'LanguageIDs',
            Multiple => 1,
            SelectedIDRefArray => $GetParam{LanguageIDs} || [],
            HTMLQuote => 1,
            LanguageTranslation => 0,
        );
        $Frontend{CategoryOption} = $Self->{LayoutObject}->OptionStrgHashRef(
            Data => { $Self->{FAQObject}->CategoryList() },
            Size => 5,
            Name => 'CategoryIDs',
            Multiple => 1,
            SelectedIDRefArray => $GetParam{CategoryIDs} || [],
            HTMLQuote => 1,
            LanguageTranslation => 0,
        );
        $Self->{LayoutObject}->Block(
            Name => 'Search',
            Data => { %Param, %GetParam, %Frontend },
        );
        # build result
        my @FAQIDs = $Self->{FAQObject}->FAQSearch(
            %Param,
            %GetParam,
            States => ['external (customer)', 'public (all)', 'internal (agent)'],
        );
        $Self->{LayoutObject}->Block(
            Name => 'SearchResult',
            Data => { %Param, %Frontend },
        );
        foreach (@FAQIDs) {
            my %Data = $Self->{FAQObject}->FAQGet(FAQID => $_);
            $Self->{LayoutObject}->Block(
                Name => 'SearchResultRow',
                Data => { %Data },
            );
        }

        my $Output = $Self->{LayoutObject}->Header(Title => 'Search', Type => $HeaderType);
        $Output .= $NavBar;
        $Output .= $Self->{LayoutObject}->Output(
            Data => {%Param},
            TemplateFile => 'FAQ',
        );
        $Output .= $Self->{LayoutObject}->Footer(Type => $HeaderType);
        return $Output;
    }
    # ---------------------------------------------------------- #
    # history
    # ---------------------------------------------------------- #
    elsif ($Self->{Subaction} eq 'History') {
        my %Data = $Self->{FAQObject}->FAQGet(FAQID => $ID);
        $Self->{LayoutObject}->Block(
            Name => 'History',
            Data => { %Param, %Data },
        );
        my @History = $Self->{FAQObject}->FAQHistoryGet(FAQID => $ID);
        foreach my $Row (@History) {
            $Self->{LayoutObject}->Block(
                Name => 'HistoryRow',
                Data => { Name => $Row->{Name}, Created => $Row->{Created}, },
            );
        }
        my $Output = $Self->{LayoutObject}->Header(Title => "History");
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'FAQ',
            Data => { %Param },
        );
        $Output .= $Self->{LayoutObject}->Footer(Type => $HeaderType);
        return $Output;
    }
    # ---------------------------------------------------------- #
    # system history
    # ---------------------------------------------------------- #
    elsif ($Self->{Subaction} eq 'SystemHistory') {
        # store last queue screen
        $Self->{SessionObject}->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key => 'LastScreenOverview',
            Value => $Self->{RequestedURL},
        );
        # store last screen
        $Self->{SessionObject}->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key => 'LastScreenView',
            Value => $Self->{RequestedURL},
        );
        $Self->{LayoutObject}->Block(
            Name => 'SystemHistory',
            Data => { %Param },
        );
        my @History = $Self->{FAQObject}->HistoryGet();
        foreach my $Row (@History) {
            my %Data = $Self->{FAQObject}->FAQGet(FAQID => $Row->{FAQID});
            my %User = $Self->{UserObject}->GetUserData(
                UserID => $Row->{CreatedBy},
                Cached => 1,
            );
            $Self->{LayoutObject}->Block(
                Name => 'SystemHistoryRow',
                Data => { %Data, %User, Name => $Row->{Name} },
            );
        }
        my $Output = $Self->{LayoutObject}->Header(Title => 'History', Type => $HeaderType);
        $Output .= $NavBar;
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'FAQ',
            Data => { %Param, },
        );
        $Output .= $Self->{LayoutObject}->Footer(Type => $HeaderType);
        return $Output;

    }
    # ---------------------------------------------------------- #
    # print view
    # ---------------------------------------------------------- #
    elsif ($Self->{Subaction} eq 'Print') {
        my %Data = $Self->{FAQObject}->FAQGet(FAQID => $ID);
        # add article
        $Self->{LayoutObject}->Block(
             Name => 'Print',
             Data => { %Data },
        );
        # get linked objects
        my %Links = $Self->{LinkObject}->AllLinkedObjects(
            Object => 'FAQ',
            ObjectID => $ID,
            UserID => $Self->{UserID},
        );
        foreach my $LinkType (sort keys %Links) {
            my %ObjectType = %{$Links{$LinkType}};
            foreach my $Object (sort keys %ObjectType) {
                my %Data = %{$ObjectType{$Object}};
                foreach my $Item (sort keys %Data) {
                    $Self->{LayoutObject}->Block(
                        Name => "Link$LinkType",
                        Data => $Data{$Item},
                    );
                }
            }
        }
        my $Output = $Self->{LayoutObject}->PrintHeader(Title => $Data{Subject}, Type => $HeaderType);
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'FAQ',
            Data => { %Param },
        );
        $Output .= $Self->{LayoutObject}->PrintFooter();
        return $Output;
    }
    # ---------------------------------------------------------- #
    # view
    # ---------------------------------------------------------- #
    elsif ($ID) {
        # remember to last screen
        $Self->{SessionObject}->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key => 'LastScreenView',
            Value => $Self->{RequestedURL},
        );
        my %Data = $Self->{FAQObject}->FAQGet(FAQID => $ID);
        my $Output = $Self->{LayoutObject}->Header(Title => $Data{Number}, Type => $HeaderType);
        $Output .= $NavBar;

        # show article
        if ($HeaderType eq 'Small') {
            $Self->{LayoutObject}->Block(
                Name => 'ViewSmall',
                Data => { %Param, %Data },
            );
        }
        else {
            $Self->{LayoutObject}->Block(
                Name => 'View',
                Data => { %Param, %Data },
            );
        }

        # get linked objects
        my %Links = $Self->{LinkObject}->AllLinkedObjects(
            Object => 'FAQ',
            ObjectID => $ID,
            UserID => $Self->{UserID},
        );
        foreach my $LinkType (sort keys %Links) {
            my %ObjectType = %{$Links{$LinkType}};
            foreach my $Object (sort keys %ObjectType) {
                my %Data = %{$ObjectType{$Object}};
                foreach my $Item (sort keys %Data) {
                    $Self->{LayoutObject}->Block(
                        Name => "Link$LinkType",
                        Data => $Data{$Item},
                    );
                }
            }
        }

        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'FAQ',
            Data => { %Param },
        );
        $Output .= $Self->{LayoutObject}->Footer(Type => $HeaderType);
        return $Output;
    }
    # ---------------------------------------------------------- #
    # redirect to search
    # ---------------------------------------------------------- #
    else {
        return $Self->{LayoutObject}->Redirect(OP => "Action=$Self->{Action}&Subaction=Search");
    }

}
# --

1;
