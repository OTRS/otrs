# --
# Kernel/Config/Postmaster.pm - Postmaster config file for OTRS 
# Copyright (C) 2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Postmaster.pm,v 1.3 2002-10-25 11:45:06 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
package Kernel::Config::Postmaster;

use strict;
use vars qw($VERSION);
$VERSION = '$Revision: 1.3 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

# --
sub LoadPostmaster {
    my $Self = shift;
    # ----------------------------------------------------#
    #                                                     #
    #             Start of config options!!!              #
    #                 PostMaster stuff                    #
    #                                                     #
    # ----------------------------------------------------#
  
    # PostmasterMaxEmails
    # (Max post master daemon email to own email-address a day.
    # Loop-Protection!) [default: 40]
    $Self->{PostmasterMaxEmails} = 40;

    # PostmasterUserID
    # (The post master db-uid.) [default: 1]
    $Self->{PostmasterUserID} = 1;

    # PostmasterDefaultQueue
    # (The default queue of all.) [default: Raw]
    $Self->{PostmasterDefaultQueue} = 'Raw';

    # PostmasterDefaultPriority
    # (The default priority of new tickets.) [default: normal]
    $Self->{PostmasterDefaultPriority} = 'normal';

    # PostmasterDefaultState
    # (The default state of new tickets.) [default: new]
    $Self->{PostmasterDefaultState} = 'new';

    # X-Header
    # (All scanned x-headers.)
    $Self->{'PostmasterX-Header'} = [
      'From',
      'To',
      'Cc',
      'Reply-To',
      'ReplyTo',
      'Subject',
      'Message-ID',
      'Message-Id',
      'Precedence',
      'Mailing-List',
      'X-Loop',
      'X-No-Loop',
      'X-OTRS-Loop',
      'X-OTRS-Info',
      'X-OTRS-Priority',
      'X-OTRS-Queue',
      'X-OTRS-Ignore',
      'X-OTRS-State',
      'X-OTRS-CustomerNo',
      'X-OTRS-ArticleKey1',
      'X-OTRS-ArticleKey2',
      'X-OTRS-ArticleKey3',
      'X-OTRS-ArticleValue1',
      'X-OTRS-ArticleValue2',
      'X-OTRS-ArticleValue3',
      'X-OTRS-TicketKey1',
      'X-OTRS-TicketKey2',
      'X-OTRS-TicketValue1',
      'X-OTRS-TicketValue2',
    ];

}
# --


1;

