# --
# Kernel/Config/CustomerPanel.pm - CustomerPanel config file for OTRS 
# Copyright (C) 2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: CustomerPanel.pm,v 1.5 2002-10-31 22:58:56 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
package Kernel::Config::CustomerPanel;

use strict;
use vars qw($VERSION);
$VERSION = '$Revision: 1.5 $';
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
   
    # SessionName
    # (Name of the session key. E. g. Session, SessionID, OTRS)
    $Self->{CustomerPanelSessionName} = 'CSID';

    # CustomerPanelUserID 
    # (The customer panel db-uid.) [default: 1]
    $Self->{CustomerPanelUserID} = 1;

    # ----------------------------------------------------#
    # login and logout settings                           #
    # ----------------------------------------------------#
    # CustomerPanelLoginURL
    # (If this is anything other than '', then it is assumed to be the
    # URL of an alternate login screen which will be used in place of 
    # the default one.)
    $Self->{CustomerPanelLoginURL} = '';
#    $Self->{CustomerPanelLoginURL} = 'http://host.example.com/cgi-bin/login.pl';

    # CustomerPanelLogoutURL
    # (If this is anything other than '', it is assumed to be the URL
    # of an alternate logout page which users will be sent to when they
    # logout.)
    $Self->{CustomerPanelLogoutURL} = '';
#    $Self->{CustomerPanelLogoutURL} = 'http://host.example.com/cgi-bin/login.pl';

    # CustomerPanelLostPassword
    # (use lost passowrd feature)
    $Self->{CustomerPanelLostPassword} = 1;
 
    # CustomerPanelCreateAccount
    # (use create cutomer account self feature)
    $Self->{CustomerPanelCreateAccount} = 1;

    # CustomerPanelMXCheck
    # (check mx of customer email addresses)
    $Self->{CustomerPanelMXCheck} = 1;
 
    # ----------------------------------------------------#
    # customer message settings                           #
    # ----------------------------------------------------#
    # default note type
    $Self->{CustomerPanelArticleType} = 'webrequest';
    $Self->{CustomerPanelSenderType} = 'customer'; 
    # default history type
    $Self->{CustomerPanelHistoryType} = 'FollowUp';
    $Self->{CustomerPanelHistoryComment} = 'Customer sent follow up via web.';

    # default article type
    $Self->{CustomerPanelNewArticleType} = 'webrequest';
    $Self->{CustomerPanelNewSenderType} = 'customer';
    # default history type
    $Self->{CustomerPanelNewHistoryType} = 'NewTicket';
    $Self->{CustomerPanelNewHistoryComment} = 'Customer sent new ticket via web.';

    # CustomerPanelSelectionType 
    # (To: seection type. Queue => show all queues, SystemAddress => show all system 
    # addresses;) [Queue|SystemAddress]
#    $Self->{CustomerPanelSelectionType} = 'Queue';
    $Self->{CustomerPanelSelectionType} = 'SystemAddress';

    # CustomerPanelSelectionString
    # (String for To: selection.) 
    # use this for CustomerPanelSelectionType = Queue
#    $Self->{CustomerPanelSelectionString} = 'Queue: <Queue> - <QueueComment>';
    # use this for CustomerPanelSelectionType = SystemAddress
    $Self->{CustomerPanelSelectionString} = '<Realname> <<Email>> - Queue: <Queue> - <QueueComment>';

    # CustomerPanelOwnSelection
    # (If this is in use, "just this selection is valid" for the CustomMessage.)
#    $Self->{CustomerPanelOwnSelection} = { 
#        # QueueID => String
#        '1' => 'First Queue!',
#        '2' => 'Second Queue!',
#    };
    
    # ----------------------------------------------------#
    # notification email for new password                 #
    # ----------------------------------------------------#
    $Self->{CustomerPanelSubjectLostPassword} = 'New OTRS Password!';
    $Self->{CustomerPanelBodyLostPassword} = "
Hi <OTRS_USERFIRSTNAME>,

you or someone impersonating you has requested to change your OTRS
password.  

New Password: <OTRS_NEWPW>

http://$Self->{FQDN}/$Self->{ScriptAlias}/customer.pl

Your OTRS Notification Master
";


}
# --


1;

