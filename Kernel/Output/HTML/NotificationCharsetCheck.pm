# --
# Kernel/Output/HTML/NotificationCharsetCheck.pm
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: NotificationCharsetCheck.pm,v 1.5 2007-09-29 10:50:15 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Output::HTML::NotificationCharsetCheck;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.5 $) [1];

sub new {
    my $Type  = shift;
    my %Param = @_;

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
    my $Self   = shift;
    my %Param  = @_;
    my $Output = '';

    # check DisplayCharset
    if ( $Self->{LayoutObject}->{UserCharset} =~ /^utf-8$/i ) {
        $Param{CorrectDisplayCharset} = 1;
    }
    else {
        for ( $Self->{LayoutObject}->{LanguageObject}->GetPossibleCharsets() ) {
            if ( $Self->{LayoutObject}->{UserCharset} =~ /^$_$/i ) {
                $Param{CorrectDisplayCharset} = 1;
            }
        }
    }
    if ( !$Param{CorrectDisplayCharset}
        && $Self->{LayoutObject}->{LanguageObject}->GetRecommendedCharset() )
    {
        $Output .= $Self->{LayoutObject}->Notify(
            Priority => 'Notice',
            Data     => '$Text{"The recommended charset for your language is %s!", "'
                . $Self->{LayoutObject}->{LanguageObject}->GetRecommendedCharset() . '"}',
        );
    }
    return $Output;
}

1;
