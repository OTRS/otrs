# --
# HTML/System.pm - provides generic system HTML output
# Copyright (C) 2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: System.pm,v 1.2 2002-05-12 22:04:21 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Output::HTML::System;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.2 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

# --
sub SystemStats {
    my $Self = shift;
    my %Param = @_;
    my $FilesTmp = $Param{Files};
    my @Files = @$FilesTmp;
    my $SystemTicktsTmp = $Param{SystemTickts};
    my %SytemTickets = %$SystemTicktsTmp;

    $Param{TicketCounter} = 0;
    foreach (keys %SytemTickets) {
      $Param{CounterOutput} .= "<TR ALIGN=CENTER><TD>\$Text{\"$_\"}</TD><TD>$SytemTickets{$_}</TD></TR>\n";
      $Param{TicketCounter} = $Param{TicketCounter} + $SytemTickets{$_};
    }

    foreach (reverse @Files) {
        $Param{Output} .= '<P>
        <A HREF="pic.pl?SessionID=$Env{"SessionID"}&Action=SystemStats&Pic='.$_.'"><IMG SRC="pic.pl?SessionID=$Env{"SessionID"}&Action=SystemStats&Pic='.$_.'" border="1"></A>
        </P>';
    }

    # create & return output
    return $Self->Output(TemplateFile => 'SystemStats', Data => \%Param);
}
# --

1;
 
