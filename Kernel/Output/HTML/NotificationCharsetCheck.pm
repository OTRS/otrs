# --
# Kernel/Output/HTML/NotificationCharsetCheck.pm
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: NotificationCharsetCheck.pm,v 1.8 2009-02-16 11:16:22 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::NotificationCharsetCheck;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.8 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for (qw(ConfigObject LogObject DBObject LayoutObject UserID)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }
    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check DisplayCharset
    if ( $Self->{LayoutObject}->{UserCharset} =~ /^utf-8$/i ) {
        return '';
    }

    for ( $Self->{LayoutObject}->{LanguageObject}->GetPossibleCharsets() ) {
        if ( $Self->{LayoutObject}->{UserCharset} =~ /^$_$/i ) {
            return ''
        }
    }

    if ( $Self->{LayoutObject}->{LanguageObject}->GetRecommendedCharset() ) {
        return $Self->{LayoutObject}->Notify(
            Priority => 'Notice',
            Data     => '$Text{"The recommended charset for your language is %s!", "'
                . $Self->{LayoutObject}->{LanguageObject}->GetRecommendedCharset() . '"}',
        );
    }
    return '';
}

1;
