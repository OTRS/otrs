# --
# Kernel/Config/CustomerPanel.pm - CustomerPanel config file for OTRS 
# Copyright (C) 2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: CustomerPanel.pm,v 1.1 2002-10-15 09:18:55 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
package Kernel::Config::CustomerPanel;

use strict;
use vars qw($VERSION);
$VERSION = '$Revision: 1.1 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

# --
sub LoadCustomerPanel {
    my $Self = shift;
    # ----------------------------------------------------#
    #                                                     #
    #             Start of config options!!!              #
    #                CustomerPanel stuff                  #
    #                                                     #
    # ----------------------------------------------------#
    
    # ----------------------------------------------------#
    # default values                                      #
    # (default values for GUIs)                           #
    # ----------------------------------------------------#
    # default charset
    # (default frontend charset) [default: iso-8859-1]
    $Self->{CustomerPanelDefaultCharset} = 'iso-8859-1';
    # default langauge
    # (the default frontend langauge) [default: English]
    $Self->{CustomerPanelDefaultLanguage} = 'English';
    # default theme
    # (the default html theme) [default: Standard]
    $Self->{CustomerPanelDefaultTheme} = 'Standard';

}
# --


1;

