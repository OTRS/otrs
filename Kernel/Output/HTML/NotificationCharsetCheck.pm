# --
# Kernel/Output/HTML/NotificationCharsetCheck.pm  
# Copyright (C) 2001-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: NotificationCharsetCheck.pm,v 1.1 2003-12-01 00:30:51 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Output::HTML::NotificationCharsetCheck;

use strict;

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

    # get needed objects
    foreach (qw(ConfigObject LogObject DBObject LayoutObject UserID)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }
    $Self->{TicketObject} = Kernel::System::Ticket->new(%Param);
    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Output = '';
    # check DisplayCharset
    if ($Self->{LayoutObject}->{UserCharset} =~ /^utf-8$/i) {
        $Param{CorrectDisplayCharset} = 1;
    }
    else {
        foreach ($Self->{LayoutObject}->{LanguageObject}->GetPossibleCharsets()) {
            if ($Self->{LayoutObject}->{UserCharset} =~ /^$_$/i) {
                $Param{CorrectDisplayCharset} = 1;
            }
        }
    }
    if (!$Param{CorrectDisplayCharset} && $Self->{LayoutObject}->{LanguageObject}->GetRecommendedCharset()) {
        $Output .= $Self->{LayoutObject}->Notify(
          Info => $Self->{LayoutObject}->{LanguageObject}->Get('The recommended charset for your language is %s!", "'.$Self->{LayoutObject}->{LanguageObject}->GetRecommendedCharset()),
        );
    }
    return $Output;
}
# --

1;
