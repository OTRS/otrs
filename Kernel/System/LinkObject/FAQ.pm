# --
# Kernel/System/LinkObject/FAQ.pm - to link faq objects
# Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: FAQ.pm,v 1.1 2004-09-11 07:59:08 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::LinkObject::FAQ;

use strict;
use Kernel::System::FAQ;

use vars qw($VERSION);
$VERSION = '$Revision: 1.1 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

sub Init {
    my $Self = shift;
    my %Param = @_;

    $Self->{FAQObject} = Kernel::System::FAQ->new(%{$Self});

    return 1;
}

sub FillDataMap {
    my $Self = shift;
    my %Param = @_;
    foreach (qw(ID UserID)) {
        if (!$Param{$_}) {
             $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    my %Article = $Self->{FAQObject}->ArticleGet(
        ID => $Param{ID},
        UserID => $Param{UserID},
    );
    return (
        Text => 'F:'.$Article{ID},
        Number => $Article{ID},
        ID => $Param{ID},
        Object => 'FAQ',
        FrontendDest => "Action=FAQ&ID=",
    );
}

sub BackendLinkObject {
    my $Self = shift;
    my %Param = @_;
    return 1;
}

sub BackendUnlinkObject {
    my $Self = shift;
    my %Param = @_;
    return 1;
}

sub LinkSearchParams {
    my $Self = shift;
    my %Param = @_;
    return (
        { Name => 'FAQNumber', Text => 'FAQ#'},
        { Name => 'FAQFulltext', Text => 'Fulltext'},
    );
}

sub LinkSearch {
    my $Self = shift;
    my %Param = @_;
    my @ResultWithData = ();
    my @Result = $Self->{FAQObject}->Search(
        What => $Param{FAQFulltext},
        UserID => $Param{UserID},
    );
    foreach (@Result) {
        my %Article = $Self->{FAQObject}->ArticleGet(
            ID => $_,
            UserID => $Param{UserID},
        );
        push (@ResultWithData, {
            %Article,
            ID => $_,
            Identifier => $Article{Subject},
          },
        );
    }
    return @ResultWithData;
}

sub LinkItemData {
    my $Self = shift;
    my %Param = @_;
    my %Article = $Self->{FAQObject}->ArticleGet(
        ID => $Param{ID},
        UserID => $Param{UserID},
    );

    my $Body = '';
    foreach (1..10) {
        if ($Article{"Field$_"}) {
            $Body .= $Article{"Field$_"};
        }
    }

    return (
        %Article,
        Number => $Article{ID},
        Body => $Body,
    );
}

1;

