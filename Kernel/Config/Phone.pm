# --
# Kernel/Config/Phone.pm - Phone config file for OTRS 
# Copyright (C) 2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Phone.pm,v 1.1 2002-10-15 09:18:55 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
package Kernel::Config::Phone;

use strict;
use vars qw($VERSION);
$VERSION = '$Revision: 1.1 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

# --
sub LoadPhone {
    my $Self = shift;
    # ----------------------------------------------------#
    #                                                     #
    #             Start of config options!!!              #
    #                    Phone stuff                      #
    #                                                     #
    # ----------------------------------------------------#

    # ----------------------------------------------------#
    # defaults for phone stuff                            #
    # ----------------------------------------------------#
    # default note type
    $Self->{PhoneDefaultArticleType} = 'phone';
    $Self->{PhoneDefaultSenderType} = 'agent'; 
    # default note subject
    $Self->{PhoneDefaultSubject} = '$Text{"Phone call at"} \''. localtime() ."'";
    # default note text
    $Self->{PhoneDefaultNoteText} = 'Customer called ';
    # next possible states after phone
    $Self->{PhoneDefaultNextStatePossible} = [
        'open', 
        'closed succsessful',
        'closed unsuccsessful',
    ];
    # default next state
    $Self->{PhoneDefaultNextState} = 'closed succsessful';
    # default history type
    $Self->{PhoneDefaultHistoryType} = 'PhoneCallAgent';
    $Self->{PhoneDefaultHistoryComment} = 'Called customer.';


    # default article type
    $Self->{PhoneDefaultNewArticleType} = 'phone';
    $Self->{PhoneDefaultNewSenderType} = 'customer';
    # default note subject
    $Self->{PhoneDefaultNewSubject} = '$Text{"Phone call at"} \''. localtime() ."'";
    # default note text
    $Self->{PhoneDefaultNewNoteText} = 'New ticket via call. ';
    # default next state
    $Self->{PhoneDefaultNewNextState} = 'open';
    # default history type
    $Self->{PhoneDefaultNewHistoryType} = 'PhoneCallCustomer';
    $Self->{PhoneDefaultNewHistoryComment} = 'Customer called us.';

    # PhoneViewASP -> useful for ASP
    # (Possible to create in all queue? Not only queue which
    # the own groups) [0|1]
    $Self->{PhoneViewASP} = 1;

    # PhoneViewSelectionType 
    # (To: seection type. Queue => show all queues, SystemAddress => show all system 
    # addresses;) [Queue|SystemAddress]
#    $Self->{PhoneViewSelectionType} = 'Queue';
    $Self->{PhoneViewSelectionType} = 'SystemAddress';

    # PhoneViewSelectionString
    # (String for To: selection.) 
    # use this for PhoneViewSelectionType = Queue
#   $Self->{PhoneViewSelectionString} = 'Queue: <Queue> - <QueueComment>';
    # use this for PhoneViewSelectionType = SystemAddress
    $Self->{PhoneViewSelectionString} = '<Realname> <<Email>> - Queue: <Queue> - <QueueComment>';

    # PhoneViewOwnSelection
    # (If this is in use, "just this selection is valid" for the PhoneView.)
#    $Self->{PhoneViewOwnSelection} = {
#        # QueueID => String
#        '1' => 'First Queue!',
#        '2' => 'Second Queue!',
#    };


}
# --


1;

