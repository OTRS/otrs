# --
# Kernel/Config/CustomerPreferences.pm - CustomerPreferences config file for OTRS 
# Copyright (C) 2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: CustomerPreferences.pm,v 1.1 2002-10-20 15:43:47 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
package Kernel::Config::CustomerPreferences;

use strict;
use vars qw($VERSION);
$VERSION = '$Revision: 1.1 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

# --
sub LoadCustomerPreferences {
    my $Self = shift;
    # ----------------------------------------------------#
    #                                                     #
    #             Start of config options!!!              #
    #              CustomerPreferences stuff              #
    #                                                     #
    # ----------------------------------------------------#
    
    # CustomerPreferencesTable*
    # (Stored CustomerPreferences table data.)
    $Self->{CustomerPreferencesTable} = 'customer_preferences';
    $Self->{CustomerPreferencesTableKey} = 'preferences_key';
    $Self->{CustomerPreferencesTableValue} = 'preferences_value';
    $Self->{CustomerPreferencesTableUserID} = 'user_id';

    # CustomerPreferencesView
    # (Order of shown items)
    $Self->{CustomerPreferencesView} = {
        Frontend => [
            'RefreshTime', 'Language', 'Charset', 'Theme', 
        ],
        'Other Options' => [
            'Password', 'CustomQueue',
        ],
    };
  
    # CustomerPreferencesGroups
    # (All possible items)
    $Self->{CustomerPreferencesGroups}->{Password} = {
        Colum => 'Other Options', 
        Label => 'Change Password',
        Type => 'Password',
        Activ => 1,
    };

    $Self->{CustomerPreferencesGroups}->{RefreshTime} = {
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
    $Self->{CustomerPreferencesGroups}->{Language} = {
        Colum => 'Frontend', 
        Label => 'Frontend Language',
        Desc => 'Select your frontend language.', 
        Type => 'Generic',
        PrefKey => 'UserLanguage',
        Activ => 1,
    };
    $Self->{CustomerPreferencesGroups}->{Charset} = {
        Colum => 'Frontend', 
        Label => 'Frontend Charset',
        Desc => 'Select your frontend Charset.', 
        Type => 'Generic',
        PrefKey => 'UserCharset',
        Activ => 1,
    };
    $Self->{CustomerPreferencesGroups}->{Theme} = {
        Colum => 'Frontend', 
        Label => 'Frontend Theme',
        Desc => 'Select your frontend Theme.', 
        Type => 'Generic',
        PrefKey => 'UserTheme',
        Activ => 0,
    };

}
# --


1;

