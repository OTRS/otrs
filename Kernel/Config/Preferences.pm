# --
# Kernel/Config/Preferences.pm - Preferences config file for OTRS 
# Copyright (C) 2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Preferences.pm,v 1.3 2002-10-22 13:54:05 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
package Kernel::Config::Preferences;

use strict;
use vars qw($VERSION);
$VERSION = '$Revision: 1.3 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

# --
sub LoadPreferences {
    my $Self = shift;
    # ----------------------------------------------------#
    #                                                     #
    #             Start of config options!!!              #
    #                 Preferences stuff                   #
    #                                                     #
    # ----------------------------------------------------#
    
    # PreferencesTable*
    # (Stored preferences table data.)
    $Self->{PreferencesTable} = 'user_preferences';
    $Self->{PreferencesTableKey} = 'preferences_key';
    $Self->{PreferencesTableValue} = 'preferences_value';
    $Self->{PreferencesTableUserID} = 'user_id';

    # PreferencesView
    # (Order of shown items)
    $Self->{PreferencesView} = {
        'Mail Management' => [
            'NewTicketNotify', 'FollowUpNotify', 'LockTimeoutNotify', 'MoveNotify',
        ],
        Frontend => [
            'RefreshTime', 'Language', 'Charset', 'Theme', 'QueueView', 
        ],
        'Other Options' => [
            'Password', 'CustomQueue',
        ],
    };
  
    # PreferencesGroups
    # (All possible items)
    $Self->{PreferencesGroups}->{NewTicketNotify} = {
        Colum => 'Mail Management', 
        Label => 'New ticket notification',
        Desc => 'Send me a notification if there is a new ticket in my custom queues.', 
        Type => 'Generic',
        Data => $Self->Get('YesNoOptions'),
        PrefKey => 'UserSendNewTicketNotification',
        Activ => 1,
    };
    $Self->{PreferencesGroups}->{FollowUpNotify} = {
        Colum => 'Mail Management', 
        Label => 'Follow up notification',
        Desc => "Send me a notification if a customer sends a follow up and I'm the owner of this ticket.",
        Type => 'Generic',
        Data => $Self->Get('YesNoOptions'),
        PrefKey => 'UserSendFollowUpNotification',
        Activ => 1,
    };
    $Self->{PreferencesGroups}->{LockTimeoutNotify} = {
        Colum => 'Mail Management', 
        Label => 'Ticket lock timeout notification',
        Desc => 'Send me a notification if a ticket is unlocked by the system.', 
        Type => 'Generic',
        Data => $Self->Get('YesNoOptions'),
        PrefKey => 'UserSendLockTimeoutNotification',
        Activ => 1,
    };
    $Self->{PreferencesGroups}->{MoveNotify} = {
        Colum => 'Mail Management', 
        Label => 'Move notification',
        Desc => 'Send me a notification if a ticket is moved into a custom queue.', 
        Type => 'Generic',
        Data => $Self->Get('YesNoOptions'),
        PrefKey => 'UserSendMoveNotification',
        Activ => 1,
    };


    $Self->{PreferencesGroups}->{Password} = {
        Colum => 'Other Options', 
        Label => 'Change Password',
        Type => 'Password',
        Activ => 1,
    };
    $Self->{PreferencesGroups}->{CustomQueue} = {
        Colum => 'Other Options', 
        Label => 'Custom Queue',
        Type => 'CustomQueue',
        Desc => 'Select your custom queues.', 
        Activ => 1,
    };


    $Self->{PreferencesGroups}->{RefreshTime} = {
        Colum => 'Frontend', 
        Label => 'QueueView refresh time',
        Desc => 'Select your QueueView refresh time.', 
        Type => 'Generic',
        Data => {
            '' => 'off',
            2 => ' 2 minutes',
            5 => ' 5 minutes',
            7 => ' 7 minutes',
            10 => '10 minutes',
            15 => '15 minutes',
        },
        PrefKey => 'UserRefreshTime',
        Activ => 1,
    };
    $Self->{PreferencesGroups}->{Language} = {
        Colum => 'Frontend', 
        Label => 'Frontend Language',
        Desc => 'Select your frontend language.', 
        Type => 'Generic',
        PrefKey => 'UserLanguage',
        Activ => 1,
    };
    $Self->{PreferencesGroups}->{Charset} = {
        Colum => 'Frontend', 
        Label => 'Frontend Charset',
        Desc => 'Select your frontend Charset.', 
        Type => 'Generic',
        PrefKey => 'UserCharset',
        Activ => 1,
    };
    $Self->{PreferencesGroups}->{Theme} = {
        Colum => 'Frontend', 
        Label => 'Frontend Theme',
        Desc => 'Select your frontend Theme.', 
        Type => 'Generic',
        PrefKey => 'UserTheme',
        Activ => 1,
    };
    $Self->{PreferencesGroups}->{QueueView} = {
        Colum => 'Frontend', 
        Label => 'Frontend QueueView',
        Desc => 'Select your frontend QueueView.', 
        Type => 'Generic',
        Data => {
            TicketView => 'Standard',
            TicketViewLite => 'Lite', 
        },
        PrefKey => 'UserQueueView',
        Activ => 1,
    };

}
# --


1;

