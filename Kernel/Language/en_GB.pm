# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::en_GB;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # http://en.wikipedia.org/wiki/Date_and_time_notation_by_country#United_Kingdom
    # day-month-year (e.g., "31/12/99")

    # $$START$$
    # possible charsets
    $Self->{Charset} = ['utf-8', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Year;)
    $Self->{DateFormat}          = '%D/%M/%Y %T';
    $Self->{DateFormatLong}      = '%T - %D/%M/%Y';
    $Self->{DateFormatShort}     = '%D/%M/%Y';
    $Self->{DateInputFormat}     = '%D/%M/%Y';
    $Self->{DateInputFormatLong} = '%D/%M/%Y - %T';
    $Self->{Completeness}        = 0.959158916295997;

    # csv separator
    $Self->{Separator} = ',';

    $Self->{Translation} = {

        # Template: AAABase
        'Yes' => 'Yes',
        'No' => 'No',
        'yes' => 'yes',
        'no' => 'no',
        'Off' => 'Off',
        'off' => 'off',
        'On' => 'On',
        'on' => 'on',
        'top' => 'top',
        'end' => 'end',
        'Done' => 'Done',
        'Cancel' => 'Cancel',
        'Reset' => 'Reset',
        'more than ... ago' => 'more than ... ago',
        'in more than ...' => 'in more than ...',
        'within the last ...' => 'within the last ...',
        'within the next ...' => 'within the next ...',
        'Created within the last' => 'Created within the last',
        'Created more than ... ago' => 'Created more than ... ago',
        'Today' => 'Today',
        'Tomorrow' => 'Tomorrow',
        'Next week' => 'Next week',
        'day' => 'day',
        'days' => 'days',
        'day(s)' => 'day(s)',
        'd' => 'd',
        'hour' => 'hour',
        'hours' => 'hours',
        'hour(s)' => 'hour(s)',
        'Hours' => 'Hours',
        'h' => 'h',
        'minute' => 'minute',
        'minutes' => 'minutes',
        'minute(s)' => 'minute(s)',
        'Minutes' => 'Minutes',
        'm' => 'm',
        'month' => 'month',
        'months' => 'months',
        'month(s)' => 'month(s)',
        'week' => 'week',
        'week(s)' => 'week(s)',
        'quarter' => 'quarter',
        'quarter(s)' => 'quarter(s)',
        'half-year' => 'half-year',
        'half-year(s)' => 'half-year(s)',
        'year' => 'year',
        'years' => 'years',
        'year(s)' => 'year(s)',
        'second(s)' => 'second(s)',
        'seconds' => 'seconds',
        'second' => 'second',
        's' => 's',
        'Time unit' => 'Time unit',
        'wrote' => 'wrote',
        'Message' => 'Message',
        'Error' => 'Error',
        'Bug Report' => 'Bug Report',
        'Attention' => 'Attention',
        'Warning' => 'Warning',
        'Module' => 'Module',
        'Modulefile' => 'Modulefile',
        'Subfunction' => 'Subfunction',
        'Line' => 'Line',
        'Setting' => 'Setting',
        'Settings' => 'Settings',
        'Example' => 'Example',
        'Examples' => 'Examples',
        'valid' => 'valid',
        'Valid' => 'Valid',
        'invalid' => 'invalid',
        'Invalid' => 'Invalid',
        '* invalid' => '* invalid',
        'invalid-temporarily' => 'invalid-temporarily',
        ' 2 minutes' => '2 minutes',
        ' 5 minutes' => '5 minutes',
        ' 7 minutes' => '7 minutes',
        '10 minutes' => '10 minutes',
        '15 minutes' => '15 minutes',
        'Mr.' => 'Mr.',
        'Mrs.' => 'Mrs.',
        'Next' => 'Next',
        'Back' => 'Back',
        'Next...' => 'Next...',
        '...Back' => '...Back',
        '-none-' => '-none-',
        'none' => 'none',
        'none!' => 'none!',
        'none - answered' => 'none - answered',
        'please do not edit!' => 'please do not edit!',
        'Need Action' => 'Need Action',
        'AddLink' => 'AddLink',
        'Link' => 'Link',
        'Unlink' => 'Unlink',
        'Linked' => 'Linked',
        'Link (Normal)' => 'Link (Normal)',
        'Link (Parent)' => 'Link (Parent)',
        'Link (Child)' => 'Link (Child)',
        'Normal' => 'Normal',
        'Parent' => 'Parent',
        'Child' => 'Child',
        'Hit' => 'Hit',
        'Hits' => 'Hits',
        'Text' => 'Text',
        'Standard' => 'Standard',
        'Lite' => 'Lite',
        'User' => 'User',
        'Username' => 'Username',
        'Language' => 'Language',
        'Languages' => 'Languages',
        'Password' => 'Password',
        'Preferences' => 'Preferences',
        'Salutation' => 'Salutation',
        'Salutations' => 'Salutations',
        'Signature' => 'Signature',
        'Signatures' => 'Signatures',
        'Customer' => 'Customer',
        'CustomerID' => 'CustomerID',
        'CustomerIDs' => 'CustomerIDs',
        'customer' => 'customer',
        'agent' => 'agent',
        'system' => 'system',
        'Customer Info' => 'Customer Info',
        'Customer Information' => 'Customer Information',
        'Customer Companies' => 'Customer Companies',
        'Company' => 'Company',
        'go!' => 'go!',
        'go' => 'go',
        'All' => 'All',
        'all' => 'all',
        'Sorry' => 'Sorry',
        'update!' => 'update!',
        'update' => 'update',
        'Update' => 'Update',
        'Updated!' => 'Updated!',
        'submit!' => 'submit!',
        'submit' => 'submit',
        'Submit' => 'Submit',
        'change!' => 'change!',
        'Change' => 'Change',
        'change' => 'change',
        'click here' => 'click here',
        'Comment' => 'Comment',
        'Invalid Option!' => 'Invalid Option!',
        'Invalid time!' => 'Invalid time!',
        'Invalid date!' => 'Invalid date!',
        'Name' => 'Name',
        'Group' => 'Group',
        'Description' => 'Description',
        'description' => 'description',
        'Theme' => 'Theme',
        'Created' => 'Created',
        'Created by' => 'Created by',
        'Changed' => 'Changed',
        'Changed by' => 'Changed by',
        'Search' => 'Search',
        'and' => 'and',
        'between' => 'between',
        'before/after' => 'before/after',
        'Fulltext Search' => 'Fulltext Search',
        'Data' => 'Data',
        'Options' => 'Options',
        'Title' => 'Title',
        'Item' => 'Item',
        'Delete' => 'Delete',
        'Edit' => 'Edit',
        'View' => 'View',
        'Number' => 'Number',
        'System' => 'System',
        'Contact' => 'Contact',
        'Contacts' => 'Contacts',
        'Export' => 'Export',
        'Up' => 'Up',
        'Down' => 'Down',
        'Add' => 'Add',
        'Added!' => 'Added!',
        'Category' => 'Category',
        'Viewer' => 'Viewer',
        'Expand' => 'Expand',
        'Small' => 'Small',
        'Medium' => 'Medium',
        'Large' => 'Large',
        'Date picker' => 'Date picker',
        'Show Tree Selection' => 'Show Tree Selection',
        'The field content is too long!' => 'The field content is too long!',
        'Maximum size is %s characters.' => 'Maximum size is %s characters.',
        'This field is required or' => 'This field is required or',
        'New message' => 'New message',
        'New message!' => 'New message!',
        'Please answer this ticket(s) to get back to the normal queue view!' =>
            'Please answer this ticket(s) to get back to the normal queue view!',
        'You have %s new message(s)!' => 'You have %s new messages(s)!',
        'You have %s reminder ticket(s)!' => 'You have %s reminder ticket(s)!',
        'The recommended charset for your language is %s!' => 'The recommended charset for your language is %s!',
        'Change your password.' => 'Change your password.',
        'Please activate %s first!' => 'Please activate %s first!',
        'No suggestions' => 'No suggestions',
        'Word' => 'Word',
        'Ignore' => 'Ignore',
        'replace with' => 'replace with',
        'There is no account with that login name.' => 'There is no account with that login name.',
        'Login failed! Your user name or password was entered incorrectly.' =>
            'Login failed! Your user name or password was entered incorrectly.',
        'There is no acount with that user name.' => 'There is no acount with that username.',
        'Please contact your administrator' => 'Please contact your administrator',
        'Authentication succeeded, but no customer record is found in the customer backend. Please contact your administrator.' =>
            'Authentication succeeded, but no customer record is found in the customer backend. Please contact your administrator.',
        'This e-mail address already exists. Please log in or reset your password.' =>
            'The email address already exists. Please log in or reset your password.',
        'Logout' => 'Logout',
        'Logout successful. Thank you for using %s!' => 'Logout successful. Thank you for using %s.',
        'Feature not active!' => 'Feature not active!',
        'Agent updated!' => 'Agent updated!',
        'Database Selection' => 'Database Selection',
        'Create Database' => 'Create Database',
        'System Settings' => 'System Settings',
        'Mail Configuration' => 'Mail Configuration',
        'Finished' => 'Finished',
        'Install OTRS' => 'Install OTRS',
        'Intro' => 'Intro',
        'License' => 'Licence',
        'Database' => 'Database',
        'Configure Mail' => 'Configure Mail',
        'Database deleted.' => 'Database deleted.',
        'Enter the password for the administrative database user.' => 'Enter the password for the administrative database user.',
        'Enter the password for the database user.' => 'Enter the password for the database user.',
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty.' =>
            'If you have set a root password for your database, it must be entered here. If not, leave this field empty.',
        'Database already contains data - it should be empty!' => 'Database already contains data - it should be empty!',
        'Login is needed!' => 'Login is needed!',
        'It is currently not possible to login due to a scheduled system maintenance.' =>
            'It is currently not possible to login due to a scheduled system maintenance.',
        'Password is needed!' => 'Password is needed!',
        'Take this Customer' => 'Take this Customer',
        'Take this User' => 'Take this User',
        'possible' => 'possible',
        'reject' => 'reject',
        'reverse' => 'reverse',
        'Facility' => 'Facility',
        'Time Zone' => 'Time Zone',
        'Pending till' => 'Pending till',
        'Don\'t use the Superuser account to work with OTRS! Create new Agents and work with these accounts instead.' =>
            'Don\'t use the Superuser account to work with OTRS! Create new agents and work with these accounts instead.',
        'Dispatching by email To: field.' => 'Dispatching by email To: field.',
        'Dispatching by selected Queue.' => 'Dispatching by selected Queue.',
        'No entry found!' => 'No entry found!',
        'Session invalid. Please log in again.' => 'Session invalid. Please log in again.',
        'Session has timed out. Please log in again.' => 'Session has timed out. Please log in again.',
        'Session limit reached! Please try again later.' => 'Session limit reached! Please try again later.',
        'No Permission!' => 'No Permission!',
        '(Click here to add)' => '(Click here to add)',
        'Preview' => 'Preview',
        'Package not correctly deployed! Please reinstall the package.' =>
            'Package not correctly deployed. Please reinstall the package.',
        '%s is not writable!' => '%s is not writable!',
        'Cannot create %s!' => 'Cannot create %s!',
        'Check to activate this date' => 'Check to activate this date',
        'You have Out of Office enabled, would you like to disable it?' =>
            'You have Out of Office enabled, would you like to disable it?',
        'News about OTRS releases!' => 'News about OTRS releases!',
        'Go to dashboard!' => 'Go to dashboard!',
        'Customer %s added' => 'Customer %s added',
        'Role added!' => 'Role added!',
        'Role updated!' => 'Role updated!',
        'Attachment added!' => 'Attachment added!',
        'Attachment updated!' => 'Attachment updated!',
        'Response added!' => 'Response added!',
        'Response updated!' => 'Response updated!',
        'Group updated!' => 'Group updated!',
        'Queue added!' => 'Queue added!',
        'Queue updated!' => 'Queue updated!',
        'State added!' => 'State added!',
        'State updated!' => 'State updated!',
        'Type added!' => 'Type added!',
        'Type updated!' => 'Type updated!',
        'Customer updated!' => 'Customer updated!',
        'Customer company added!' => 'Customer company added!',
        'Customer company updated!' => 'Customer company updated!',
        'Note: Company is invalid!' => 'Note: Company is invalid!',
        'Mail account added!' => 'Mail account added!',
        'Mail account updated!' => 'Mail account updated!',
        'System e-mail address added!' => 'System e-mail address added!',
        'System e-mail address updated!' => 'System e-mail address updated!',
        'Contract' => 'Contract!',
        'Online Customer: %s' => 'Online Customer %s',
        'Online Agent: %s' => 'Online Agent: %s',
        'Calendar' => 'Calendar',
        'File' => 'File',
        'Filename' => 'Filename',
        'Type' => 'Type',
        'Size' => 'Size',
        'Upload' => 'Upload',
        'Directory' => 'Directory',
        'Signed' => 'Signed',
        'Sign' => 'Sign',
        'Crypted' => 'Crypted',
        'Crypt' => 'Crypt',
        'PGP' => 'PGP',
        'PGP Key' => 'PGP Key',
        'PGP Keys' => 'PGP Keys',
        'S/MIME' => 'S/MIME',
        'S/MIME Certificate' => 'S/MIME Certificate',
        'S/MIME Certificates' => 'S/MIME Certificates',
        'Office' => 'Office',
        'Phone' => 'Phone',
        'Fax' => 'Fax',
        'Mobile' => 'Mobile',
        'Zip' => 'Postcode',
        'City' => 'City',
        'Street' => 'Street',
        'Country' => 'Country',
        'Location' => 'Location',
        'installed' => 'installed',
        'uninstalled' => 'uninstalled',
        'Security Note: You should activate %s because application is already running!' =>
            'Security Note: You should activate %s because application is already running!',
        'Unable to parse repository index document.' => 'Unable to parse repository index document.',
        'No packages for your framework version found in this repository, it only contains packages for other framework versions.' =>
            'No packages for your framework version found in this repository, it only contains packages for other framework versions.',
        'No packages, or no new packages, found in selected repository.' =>
            'No packages, or no new packages, found in selected repository.',
        'Edit the system configuration settings.' => 'Edit the system configuration settings.',
        'ACL information from database is not in sync with the system configuration, please deploy all ACLs.' =>
            'ACL information from database is not in sync with the system configuration, please deploy all ACLs.',
        'printed at' => 'printed at',
        'Loading...' => 'Loading...',
        'Dear Mr. %s,' => 'Dear Mr. %s,',
        'Dear Mrs. %s,' => 'Dear Mrs %s,',
        'Dear %s,' => 'Dear %s,',
        'Hello %s,' => 'Hello %s,',
        'This email address is not allowed to register. Please contact support staff.' =>
            'This email address is not allowed to register. Please contact support staff.',
        'New account created. Sent login information to %s. Please check your email.' =>
            'New account created. Sent login information to %s. Please check your email.',
        'Please press Back and try again.' => 'Please press Back and try again.',
        'Sent password reset instructions. Please check your email.' => 'Sent password reset instructions. Please check your email.',
        'Sent new password to %s. Please check your email.' => 'Sent new password to %s. Please check your email.',
        'Upcoming Events' => 'Upcoming Events',
        'Event' => 'Event',
        'Events' => 'Events',
        'Invalid Token!' => 'Invalid Token!',
        'more' => 'more',
        'Collapse' => 'Collapse',
        'Shown' => 'Shown',
        'Shown customer users' => 'Shown customer users',
        'News' => 'News',
        'Product News' => 'Product News',
        'OTRS News' => 'OTRS News',
        '7 Day Stats' => '7 Day Stats',
        'Process Management information from database is not in sync with the system configuration, please synchronize all processes.' =>
            'Process Management information from database is not in sync with the system configuration, please synchronise all processes.',
        'Package not verified by the OTRS Group! It is recommended not to use this package.' =>
            'Package not verified by the OTRS Group! It is recommended not to use this package.',
        '<br>If you continue to install this package, the following issues may occur!<br><br>&nbsp;-Security problems<br>&nbsp;-Stability problems<br>&nbsp;-Performance problems<br><br>Please note that issues that are caused by working with this package are not covered by OTRS service contracts!<br><br>' =>
            '<br>If you continue to install this package, the following issues may occur!<br><br>&nbsp;-Security problems<br>&nbsp;-Stability problems<br>&nbsp;-Performance problems<br><br>Please note that issues that are caused by working with this package are not covered by OTRS service contracts!<br><br>',
        'Mark' => 'Mark',
        'Unmark' => 'Unmark',
        'Bold' => 'Bold',
        'Italic' => 'Italic',
        'Underline' => 'Underline',
        'Font Color' => 'Font Colour',
        'Background Color' => 'Background Colour',
        'Remove Formatting' => 'Remove Formatting',
        'Show/Hide Hidden Elements' => 'Show/Hide Hidden Elements',
        'Align Left' => 'Align Left',
        'Align Center' => 'Align Center',
        'Align Right' => 'Align Right',
        'Justify' => 'Justify',
        'Header' => 'Header',
        'Indent' => 'Indent',
        'Outdent' => 'Outdent',
        'Create an Unordered List' => 'Create an Unordered List',
        'Create an Ordered List' => 'Create an Ordered List',
        'HTML Link' => 'HTML Link',
        'Insert Image' => 'Insert Image',
        'CTRL' => 'CTRL',
        'SHIFT' => 'SHIFT',
        'Undo' => 'Undo',
        'Redo' => 'Redo',
        'OTRS Daemon is not running.' => 'OTRS Daemon is not running.',
        'Can\'t contact registration server. Please try again later.' => 'Can\'t contact registration server. Please try again later.',
        'No content received from registration server. Please try again later.' =>
            'No content received from registration server. Please try again later.',
        'Problems processing server result. Please try again later.' => 'Problems processing server result. Please try again later.',
        'Username and password do not match. Please try again.' => 'Username and password do not match. Please try again.',
        'The selected process is invalid!' => 'The selected process is invalid!',
        'Upgrade to %s now!' => 'Upgrade to %s now!',
        '%s Go to the upgrade center %s' => '%s Go to the upgrade center %s',
        'The license for your %s is about to expire. Please make contact with %s to renew your contract!' =>
            'The licence for your %s is about to expire. Please make contact with %s to renew your contract!',
        'An update for your %s is available, but there is a conflict with your framework version! Please update your framework first!' =>
            'An update for your %s is available, but there is a conflict with your framework version! Please update your framework first!',
        'Your system was successfully upgraded to %s.' => 'Your system was successfully upgraded to %s.',
        'There was a problem during the upgrade to %s.' => 'There was a problem during the upgrade to %s.',
        '%s was correctly reinstalled.' => '%s was correctly reinstalled.',
        'There was a problem reinstalling %s.' => 'There was a problem reinstalling %s.',
        'Your %s was successfully updated.' => 'Your %s was successfully updated.',
        'There was a problem during the upgrade of %s.' => 'There was a problem during the upgrade of %s.',
        '%s was correctly uninstalled.' => '%s was correctly uninstalled.',
        'There was a problem uninstalling %s.' => 'There was a problem uninstalling %s.',
        'Enable cloud services to unleash all OTRS features!' => 'Enable cloud services to unleash all OTRS features!',

        # Template: AAACalendar
        'New Year\'s Day' => 'New Year\'s Day',
        'International Workers\' Day' => 'International Workers\' Day',
        'Christmas Eve' => 'Christmas Eve',
        'First Christmas Day' => 'First Christmas Day',
        'Second Christmas Day' => 'Second Christmas Day',
        'New Year\'s Eve' => 'New Year\'s Eve',

        # Template: AAAGenericInterface
        'OTRS as requester' => 'OTRS as requester',
        'OTRS as provider' => 'OTRS as provider',
        'Webservice "%s" created!' => 'Webservice "%s" created!',
        'Webservice "%s" updated!' => 'Webservice "%s" updated!',

        # Template: AAAMonth
        'Jan' => 'Jan',
        'Feb' => 'Feb',
        'Mar' => 'Mar',
        'Apr' => 'Apr',
        'May' => 'May',
        'Jun' => 'Jun',
        'Jul' => 'Jul',
        'Aug' => 'Aug',
        'Sep' => 'Sep',
        'Oct' => 'Oct',
        'Nov' => 'Nov',
        'Dec' => 'Dec',
        'January' => 'January',
        'February' => 'February',
        'March' => 'March',
        'April' => 'April',
        'May_long' => 'May',
        'June' => 'June',
        'July' => 'July',
        'August' => 'August',
        'September' => 'September',
        'October' => 'October',
        'November' => 'November',
        'December' => 'December',

        # Template: AAAPreferences
        'Preferences updated successfully!' => 'Preferences updated successfully!',
        'User Profile' => 'User Profile',
        'Email Settings' => 'Email Settings',
        'Other Settings' => 'Other Settings',
        'Notification Settings' => 'Notification Settings',
        'Change Password' => 'Change Password',
        'Current password' => 'Current password',
        'New password' => 'New password',
        'Verify password' => 'Verify password',
        'Spelling Dictionary' => 'Spelling Dictionary',
        'Default spelling dictionary' => 'Default spelling dictionary',
        'Max. shown Tickets a page in Overview.' => 'Max. shown Tickets a page in Overview.',
        'The current password is not correct. Please try again!' => 'The current password is not correct. Please try again!',
        'Can\'t update password, your new passwords do not match. Please try again!' =>
            'Can\'t update password, your new passwords do not match. Please try again!',
        'Can\'t update password, it contains invalid characters!' => 'Can\'t update password. It contains invalid characters.',
        'Can\'t update password, it must be at least %s characters long!' =>
            'Can\'t update password, it must be at least %s characters long!',
        'Can\'t update password, it must contain at least 2 lowercase and 2 uppercase characters!' =>
            'Can\'t update password, it must contain at least 2 lowercase and 2 uppercase characters!',
        'Can\'t update password, it must contain at least 1 digit!' => 'Can\'t update password, it must contain at least 1 digit!',
        'Can\'t update password, it must contain at least 2 characters!' =>
            'Can\'t update password, it must contain at least 2 characters!',
        'Can\'t update password, this password has already been used. Please choose a new one!' =>
            'Can\'t update password, this password has already been used. Please choose a new one!',
        'Select the separator character used in CSV files (stats and searches). If you don\'t select a separator here, the default separator for your language will be used.' =>
            'Select the separator character used in CSV files (stats and searches). If you don\'t select a separator here, the default separator for your language will be used.',
        'CSV Separator' => 'CSV Separator',

        # Template: AAATicket
        'Status View' => 'Status View',
        'Service View' => 'Service View',
        'Bulk' => 'Bulk',
        'Lock' => 'Lock',
        'Unlock' => 'Unlock',
        'History' => 'History',
        'Zoom' => 'Zoom',
        'Age' => 'Age',
        'Bounce' => 'Bounce',
        'Forward' => 'Forward',
        'From' => 'From',
        'To' => 'To',
        'Cc' => 'Cc',
        'Bcc' => 'Bcc',
        'Subject' => 'Subject',
        'Move' => 'Move',
        'Queue' => 'Queue',
        'Queues' => 'Queues',
        'Priority' => 'Priority',
        'Priorities' => 'Priorities',
        'Priority Update' => 'Priority Update',
        'Priority added!' => 'Priority added!',
        'Priority updated!' => 'Priority updated!',
        'Signature added!' => 'Signature added!',
        'Signature updated!' => 'Signature updated!',
        'SLA' => 'SLA',
        'Service Level Agreement' => 'Service Level Agreement',
        'Service Level Agreements' => 'Service Level Agreements',
        'Service' => 'Service',
        'Services' => 'Services',
        'State' => 'State',
        'States' => 'States',
        'Status' => 'Status',
        'Statuses' => 'Status',
        'Ticket Type' => 'Ticket Type',
        'Ticket Types' => 'Ticket Types',
        'Compose' => 'Compose',
        'Pending' => 'Pending',
        'Owner' => 'Owner',
        'Owner Update' => 'Owner Update',
        'Responsible' => 'Responsible',
        'Responsible Update' => 'Responsible Update',
        'Sender' => 'Sender',
        'Article' => 'Article',
        'Ticket' => 'Ticket',
        'Createtime' => 'Createtime',
        'plain' => 'plain',
        'Email' => 'Email',
        'email' => 'email',
        'Close' => 'Close',
        'Action' => 'Action',
        'Attachment' => 'Attachment',
        'Attachments' => 'Attachments',
        'This message was written in a character set other than your own.' =>
            'This message was written in a character set other than your own.',
        'If it is not displayed correctly,' => 'If it is not displayed correctly,',
        'This is a' => 'This is a',
        'to open it in a new window.' => 'to open it in a new window.',
        'This is a HTML email. Click here to show it.' => 'This is a HTML email. Click here to show it.',
        'Free Fields' => 'Free Fields',
        'Merge' => 'Merge',
        'merged' => 'merged',
        'closed successful' => 'closed successful',
        'closed unsuccessful' => 'closed unsuccessful',
        'Locked Tickets Total' => 'Locked Tickets Total',
        'Locked Tickets Reminder Reached' => 'Locked Tickets Reminder Reached',
        'Locked Tickets New' => 'Locked Tickets New',
        'Responsible Tickets Total' => 'Responsible Tickets Total',
        'Responsible Tickets New' => 'Responsible Tickets New',
        'Responsible Tickets Reminder Reached' => 'Responsible Tickets Reminder Reached',
        'Watched Tickets Total' => 'Watched Tickets Total',
        'Watched Tickets New' => 'Watched Tickets New',
        'Watched Tickets Reminder Reached' => 'Watched Tickets Reminder Reached',
        'All tickets' => 'All tickets',
        'Available tickets' => 'Available tickets',
        'Escalation' => 'Escalation',
        'last-search' => 'last-search',
        'QueueView' => 'QueueView',
        'Ticket Escalation View' => 'Ticket Escalation View',
        'Message from' => 'Message from',
        'End message' => 'End message',
        'Forwarded message from' => 'Forwarded message from',
        'End forwarded message' => 'End forwarded message',
        'Bounce Article to a different mail address' => 'Bounce Article to a different mail address',
        'Reply to note' => 'Reply to note',
        'new' => 'new',
        'open' => 'open',
        'Open' => 'Open',
        'Open tickets' => 'Open tickets',
        'closed' => 'closed',
        'Closed' => 'Closed',
        'Closed tickets' => 'Closed tickets',
        'removed' => 'removed',
        'pending reminder' => 'pending reminder',
        'pending auto' => 'pending auto',
        'pending auto close+' => 'pending auto close+',
        'pending auto close-' => 'pending auto close-',
        'email-external' => 'email-external',
        'email-internal' => 'email-internal',
        'note-external' => 'note-external',
        'note-internal' => 'note-internal',
        'note-report' => 'note-report',
        'phone' => 'phone',
        'sms' => 'sms',
        'webrequest' => 'webrequest',
        'lock' => 'lock',
        'unlock' => 'unlock',
        'very low' => 'very low',
        'low' => 'low',
        'normal' => 'normal',
        'high' => 'high',
        'very high' => 'very high',
        '1 very low' => '1 very low',
        '2 low' => '2 low',
        '3 normal' => '3 normal',
        '4 high' => '4 high',
        '5 very high' => '5 very high',
        'auto follow up' => 'auto follow up',
        'auto reject' => 'auto reject',
        'auto remove' => 'auto remove',
        'auto reply' => 'auto reply',
        'auto reply/new ticket' => 'auto reply/new ticket',
        'Create' => 'Create',
        'Answer' => 'Answer',
        'Phone call' => 'Phone call',
        'Ticket "%s" created!' => 'Ticket "%s" created!',
        'Ticket Number' => 'Ticket Number',
        'Ticket Object' => 'Ticket Object',
        'No such Ticket Number "%s"! Can\'t link it!' => 'No such Ticket Number "%s"! Can\'t link it!',
        'You don\'t have write access to this ticket.' => 'You don\'t have write access to this ticket.',
        'Sorry, you need to be the ticket owner to perform this action.' =>
            'Sorry, you need to be the ticket owner to perform this action.',
        'Please change the owner first.' => 'Please change the owner first.',
        'Ticket selected.' => 'Ticket selected.',
        'Ticket is locked by another agent.' => 'Ticket is locked by another agent.',
        'Ticket locked.' => 'Ticket locked.',
        'Don\'t show closed Tickets' => 'Don\'t show closed Tickets',
        'Show closed Tickets' => 'Show closed Tickets',
        'New Article' => 'New Article',
        'Unread article(s) available' => 'Unread article(s) available',
        'Remove from list of watched tickets' => 'Remove from list of watched tickets',
        'Add to list of watched tickets' => 'Add to list of watched tickets',
        'Email-Ticket' => 'Email-Ticket',
        'Create new Email Ticket' => 'Create new Email Ticket',
        'Phone-Ticket' => 'Phone-Ticket',
        'Search Tickets' => 'Search Tickets',
        'Customer Realname' => 'Customer Realname',
        'Customer History' => 'Customer History',
        'Edit Customer Users' => 'Edit Customer Users',
        'Edit Customer' => 'Edit Customer',
        'Bulk Action' => 'Bulk Action',
        'Bulk Actions on Tickets' => 'Bulk Actions on Tickets',
        'Send Email and create a new Ticket' => 'Send Email and create a new Ticket',
        'Create new Email Ticket and send this out (Outbound)' => 'Create new Email Ticket and send this out (Outbound)',
        'Create new Phone Ticket (Inbound)' => 'Create new Phone Ticket (Inbound)',
        'Address %s replaced with registered customer address.' => 'Address %s replaced with registered customer address.',
        'Customer user automatically added in Cc.' => 'Customer user automatically added in Cc.',
        'Overview of all open Tickets' => 'Overview of all open Tickets',
        'Locked Tickets' => 'Locked Tickets',
        'My Locked Tickets' => 'My Locked Tickets',
        'My Watched Tickets' => 'My Watched Tickets',
        'My Responsible Tickets' => 'My Responsible Tickets',
        'Watched Tickets' => 'Watched Tickets',
        'Watched' => 'Watched',
        'Watch' => 'Watch',
        'Unwatch' => 'Unwatch',
        'Lock it to work on it' => 'Lock it to work on it',
        'Unlock to give it back to the queue' => 'Unlock to give it back to the queue',
        'Show the ticket history' => 'Show the ticket history',
        'Print this ticket' => 'Print this ticket',
        'Print this article' => 'Print this article',
        'Split' => 'Split',
        'Split this article' => 'Split this article',
        'Forward article via mail' => 'Forward article via mail',
        'Change the ticket priority' => 'Change the ticket priority',
        'Change the ticket free fields!' => 'Change the ticket free fields!',
        'Link this ticket to other objects' => 'Link this ticket to other objects',
        'Change the owner for this ticket' => 'Change the owner for this ticket',
        'Change the  customer for this ticket' => 'Change the  customer for this ticket',
        'Add a note to this ticket' => 'Add a note to this ticket',
        'Merge into a different ticket' => 'Merge into a different ticket',
        'Set this ticket to pending' => 'Set this ticket to pending',
        'Close this ticket' => 'Close this ticket',
        'Look into a ticket!' => 'Look into a ticket!',
        'Delete this ticket' => 'Delete this ticket',
        'Mark as Spam!' => 'Mark as Spam!',
        'My Queues' => 'My Queues',
        'Shown Tickets' => 'Shown Tickets',
        'Shown Columns' => 'Shown Columns',
        'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' =>
            'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".',
        'Ticket %s: first response time is over (%s)!' => 'Ticket %s: first response time is over (%s)!',
        'Ticket %s: first response time will be over in %s!' => 'Ticket %s: first response time will be over in %s!',
        'Ticket %s: update time is over (%s)!' => 'Ticket %s: update time is over (%s)!',
        'Ticket %s: update time will be over in %s!' => 'Ticket %s: update time will be over in %s!',
        'Ticket %s: solution time is over (%s)!' => 'Ticket %s: solution time is over (%s)!',
        'Ticket %s: solution time will be over in %s!' => 'Ticket %s: solution time will be over in %s!',
        'There are more escalated tickets!' => 'There are more escalated tickets!',
        'Plain Format' => 'Plain Format',
        'Reply All' => 'Reply All',
        'Direction' => 'Direction',
        'New ticket notification' => 'New ticket notification',
        'Send me a notification if there is a new ticket in "My Queues".' =>
            'Send me a notification if there is a new ticket in "My Queues".',
        'Send new ticket notifications' => 'Send new ticket notifications',
        'Ticket follow up notification' => 'Ticket follow up notification',
        'Send me a notification if a customer sends a follow up and I\'m the owner of the ticket or the ticket is unlocked and is in one of my subscribed queues.' =>
            'Send me a notification if a customer sends a follow up and I\'m the owner of the ticket or the ticket is unlocked and is in one of my subscribed queues.',
        'Send ticket follow up notifications' => 'Send ticket follow up notifications',
        'Ticket lock timeout notification' => 'Ticket lock timeout notification',
        'Send me a notification if a ticket is unlocked by the system.' =>
            'Send me a notification if a ticket is unlocked by the system.',
        'Send ticket lock timeout notifications' => 'Send ticket lock timeout notifications',
        'Ticket move notification' => 'Ticket move notification',
        'Send me a notification if a ticket is moved into one of "My Queues".' =>
            'Send me a notification if a ticket is moved into one of "My Queues".',
        'Send ticket move notifications' => 'Send ticket move notifications',
        'Your queue selection of your favourite queues. You also get notified about those queues via email if enabled.' =>
            'Your queue selection of your favourite queues. You also get notified about those queues via email if enabled.',
        'Custom Queue' => 'Custom Queue',
        'QueueView refresh time' => 'QueueView refresh time',
        'If enabled, the QueueView will automatically refresh after the specified time.' =>
            'If enabled, the QueueView will automatically refresh after the specified time.',
        'Refresh QueueView after' => 'Refresh QueueView after',
        'Screen after new ticket' => 'Screen after new ticket',
        'Show this screen after I created a new ticket' => 'Show this screen after I created a new ticket',
        'Closed Tickets' => 'Closed Tickets',
        'Show closed tickets.' => 'Show closed tickets.',
        'Max. shown Tickets a page in QueueView.' => 'Max. shown Tickets a page in QueueView.',
        'Ticket Overview "Small" Limit' => 'Ticket Overview "Small" Limit',
        'Ticket limit per page for Ticket Overview "Small"' => 'Ticket limit per page for Ticket Overview "Small"',
        'Ticket Overview "Medium" Limit' => 'Ticket Overview "Medium" Limit',
        'Ticket limit per page for Ticket Overview "Medium"' => 'Ticket limit per page for Ticket Overview "Medium"',
        'Ticket Overview "Preview" Limit' => 'Ticket Overview "Preview" Limit',
        'Ticket limit per page for Ticket Overview "Preview"' => 'Ticket limit per page for Ticket Overview "Preview"',
        'Ticket watch notification' => 'Ticket watch notification',
        'Send me the same notifications for my watched tickets that the ticket owners will get.' =>
            'Send me the same notifications for my watched tickets that the ticket owners will get.',
        'Send ticket watch notifications' => 'Send ticket watch notifications',
        'Out Of Office Time' => 'Out Of Office Time',
        'New Ticket' => 'New Ticket',
        'Create new Ticket' => 'Create new Ticket',
        'Customer called' => 'Customer called',
        'phone call' => 'phone call',
        'Phone Call Outbound' => 'Phone Call Outbound',
        'Phone Call Inbound' => 'Phone Call Inbound',
        'Reminder Reached' => 'Reminder Reached',
        'Reminder Tickets' => 'Reminder Tickets',
        'Escalated Tickets' => 'Escalated Tickets',
        'New Tickets' => 'New Tickets',
        'Open Tickets / Need to be answered' => 'Open Tickets / Need to be answered',
        'All open tickets, these tickets have already been worked on, but need a response' =>
            'All open tickets, these tickets have already been worked on, but need a response',
        'All new tickets, these tickets have not been worked on yet' => 'All new tickets, these tickets have not been worked on yet',
        'All escalated tickets' => 'All escalated tickets',
        'All tickets with a reminder set where the reminder date has been reached' =>
            'All tickets with a reminder set where the reminder date has been reached',
        'Archived tickets' => 'Archived tickets',
        'Unarchived tickets' => 'Unarchived tickets',
        'Ticket Information' => 'Ticket Information',
        'including subqueues' => 'including subqueues',
        'excluding subqueues' => 'excluding subqueues',

        # Template: AAAWeekDay
        'Sun' => 'Sun',
        'Mon' => 'Mon',
        'Tue' => 'Tue',
        'Wed' => 'Wed',
        'Thu' => 'Thu',
        'Fri' => 'Fri',
        'Sat' => 'Sat',

        # Template: AdminACL
        'ACL Management' => 'ACL Management',
        'Filter for ACLs' => 'Filter for ACLs',
        'Filter' => 'Filter',
        'ACL Name' => 'ACL Name',
        'Actions' => 'Actions',
        'Create New ACL' => 'Create New ACL',
        'Deploy ACLs' => 'Deploy ACLs',
        'Export ACLs' => 'Export ACLs',
        'Configuration import' => 'Configuration import',
        'Here you can upload a configuration file to import ACLs to your system. The file needs to be in .yml format as exported by the ACL editor module.' =>
            'Here you can upload a configuration file to import ACLs to your system. The file needs to be in .yml format as exported by the ACL editor module.',
        'This field is required.' => 'This field is required.',
        'Overwrite existing ACLs?' => 'Overwrite existing ACLs?',
        'Upload ACL configuration' => 'Upload ACL configuration',
        'Import ACL configuration(s)' => 'Import ACL configuration(s)',
        'To create a new ACL you can either import ACLs which were exported from another system or create a complete new one.' =>
            'To create a new ACL you can either import ACLs which were exported from another system or create a complete new one.',
        'Changes to the ACLs here only affect the behavior of the system, if you deploy the ACL data afterwards. By deploying the ACL data, the newly made changes will be written to the configuration.' =>
            'Changes to the ACLs here only affect the behaviour of the system, if you deploy the ACL data afterwards. By deploying the ACL data, the newly made changes will be written to the configuration.',
        'ACLs' => 'ACLs',
        'Please note: This table represents the execution order of the ACLs. If you need to change the order in which ACLs are executed, please change the names of the affected ACLs.' =>
            'Please note: This table represents the execution order of the ACLs. If you need to change the order in which ACLs are executed, please change the names of the affected ACLs.',
        'ACL name' => 'ACL name',
        'Validity' => 'Validity',
        'Copy' => 'Copy',
        'No data found.' => 'No data found.',

        # Template: AdminACLEdit
        'Edit ACL %s' => 'Edit ACL %s',
        'Go to overview' => 'Go to overview',
        'Delete ACL' => 'Delete ACL',
        'Delete Invalid ACL' => 'Delete Invalid ACL',
        'Match settings' => 'Match settings',
        'Set up matching criteria for this ACL. Use \'Properties\' to match the current screen or \'PropertiesDatabase\' to match attributes of the current ticket that are in the database.' =>
            'Set up matching criteria for this ACL. Use \'Properties\' to match the current screen or \'PropertiesDatabase\' to match attributes of the current ticket that are in the database.',
        'Change settings' => 'Change settings',
        'Set up what you want to change if the criteria match. Keep in mind that \'Possible\' is a white list, \'PossibleNot\' a black list.' =>
            'Set up what you want to change if the criteria match. Keep in mind that \'Possible\' is a white list, \'PossibleNot\' a black list.',
        'Check the official' => 'Check the official',
        'documentation' => 'documentation',
        'Show or hide the content' => 'Show or hide the content',
        'Edit ACL information' => 'Edit ACL information',
        'Stop after match' => 'Stop after match',
        'Edit ACL structure' => 'Edit ACL structure',
        'Save settings' => 'Save settings',
        'Save ACL' => '',
        'Save' => 'Save',
        'or' => 'or',
        'Save and finish' => 'Save and finish',
        'Do you really want to delete this ACL?' => 'Do you really want to delete this ACL?',
        'This item still contains sub items. Are you sure you want to remove this item including its sub items?' =>
            'This item still contains sub items. Are you sure you want to remove this item including its sub items?',
        'An item with this name is already present.' => 'An item with this name is already present.',
        'Add all' => 'Add all',
        'There was an error reading the ACL data.' => 'There was an error reading the ACL data.',

        # Template: AdminACLNew
        'Create a new ACL by submitting the form data. After creating the ACL, you will be able to add configuration items in edit mode.' =>
            'Create a new ACL by submitting the form data. After creating the ACL, you will be able to add configuration items in edit mode.',

        # Template: AdminAttachment
        'Attachment Management' => 'Attachment Management',
        'Add attachment' => 'Add attachment',
        'List' => 'List',
        'Download file' => 'Download file',
        'Delete this attachment' => 'Delete this attachment',
        'Do you really want to delete this attachment?' => '',
        'Add Attachment' => 'Add Attachment',
        'Edit Attachment' => 'Edit Attachment',

        # Template: AdminAutoResponse
        'Auto Response Management' => 'Auto Response Management',
        'Add auto response' => 'Add auto response',
        'Add Auto Response' => 'Add Auto Response',
        'Edit Auto Response' => 'Edit Auto Response',
        'Response' => 'Response',
        'Auto response from' => 'Auto response from',
        'Reference' => 'Reference',
        'You can use the following tags' => 'You can use the following tags',
        'To get the first 20 character of the subject.' => 'To get the first 20 character of the subject.',
        'To get the first 5 lines of the email.' => 'To get the first 5 lines of the email.',
        'To get the name of the ticket\'s customer user (if given).' => '',
        'To get the article attribute' => 'To get the article attribute',
        ' e. g.' => ' e. g.',
        'Options of the current customer user data' => 'Options of the current customer user data',
        'Ticket owner options' => 'Ticket owner options',
        'Ticket responsible options' => 'Ticket responsible options',
        'Options of the current user who requested this action' => 'Options of the current user who requested this action',
        'Options of the ticket data' => 'Options of the ticket data',
        'Options of ticket dynamic fields internal key values' => 'Options of ticket dynamic fields internal key values',
        'Options of ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            'Options of ticket dynamic fields display values, useful for Dropdown and Multiselect fields',
        'Config options' => 'Config options',
        'Example response' => 'Example response',

        # Template: AdminCloudServiceSupportDataCollector
        'Cloud Service Management' => 'Cloud Service Management',
        'Support Data Collector' => 'Support Data Collector',
        'Support data collector' => 'Support data collector',
        'Hint' => 'Hint',
        'Currently support data is only shown in this system.' => 'Currently support data is only shown in this system.',
        'It is highly recommended to send this data to OTRS Group in order to get better support.' =>
            'It is highly recommended to send this data to OTRS Group in order to get better support.',
        'Configuration' => 'Configuration',
        'Send support data' => 'Send support data',
        'This will allow the system to send additional support data information to OTRS Group.' =>
            'This will allow the system to send additional support data information to OTRS Group.',
        'System Registration' => 'System Registration',
        'To enable data sending, please register your system with OTRS Group or update your system registration information (make sure to activate the \'send support data\' option.)' =>
            'To enable data sending, please register your system with OTRS Group or update your system registration information (make sure to activate the \'send support data\' option.)',
        'Register this System' => 'Register this System',
        'System Registration is disabled for your system. Please check your configuration.' =>
            'System Registration is disabled for your system. Please check your configuration.',

        # Template: AdminCloudServices
        'System registration is a service of OTRS Group, which provides a lot of advantages!' =>
            'System registration is a service of OTRS Group, which provides a lot of advantages!',
        'Please note that the use of OTRS cloud services requires the system to be registered.' =>
            'Please note that the use of OTRS cloud services requires the system to be registered.',
        'Register this system' => 'Register this system',
        'Here you can configure available cloud services that communicate securely with %s.' =>
            'Here you can configure available cloud services that communicate securely with %s.',
        'Available Cloud Services' => 'Available Cloud Services',
        'Upgrade to %s' => 'Upgrade to %s',

        # Template: AdminCustomerCompany
        'Customer Management' => 'Customer Management',
        'Wildcards like \'*\' are allowed.' => 'Wildcards like \'*\' are allowed.',
        'Add customer' => 'Add customer',
        'Select' => 'Select',
        'List (only %s shown - more available)' => 'List (only %s shown - more available)',
        'List (%s total)' => 'List (%s total)',
        'Please enter a search term to look for customers.' => 'Please enter a search term to look for customers.',
        'Add Customer' => 'Add Customer',

        # Template: AdminCustomerUser
        'Customer User Management' => 'Customer User Management',
        'Back to search results' => 'Back to search results',
        'Add customer user' => 'Add customer user',
        'Customer user are needed to have a customer history and to login via customer panel.' =>
            'Customer user are needed to have a customer history and to login via customer panel.',
        'Last Login' => 'Last Login',
        'Login as' => 'Login as',
        'Switch to customer' => 'Switch to customer',
        'Add Customer User' => 'Add Customer User',
        'Edit Customer User' => 'Edit Customer User',
        'This field is required and needs to be a valid email address.' =>
            'This field is required and needs to be a valid email address.',
        'This email address is not allowed due to the system configuration.' =>
            'This email address is not allowed due to the system configuration.',
        'This email address failed MX check.' => 'This email address failed MX check.',
        'DNS problem, please check your configuration and the error log.' =>
            'DNS problem, please check your configuration and the error log.',
        'The syntax of this email address is incorrect.' => 'The syntax of this email address is incorrect.',

        # Template: AdminCustomerUserGroup
        'Manage Customer-Group Relations' => 'Manage Customer-Group Relations',
        'Notice' => 'Notice',
        'This feature is disabled!' => 'This feature is disabled!',
        'Just use this feature if you want to define group permissions for customers.' =>
            'Just use this feature if you want to define group permissions for customers.',
        'Enable it here!' => 'Enable it here!',
        'Edit Customer Default Groups' => 'Edit Customer Default Groups',
        'These groups are automatically assigned to all customers.' => 'These groups are automatically assigned to all customers.',
        'You can manage these groups via the configuration setting "CustomerGroupAlwaysGroups".' =>
            'You can manage these groups via the configuration setting "CustomerGroupAlwaysGroups".',
        'Filter for Groups' => 'Filter for Groups',
        'Just start typing to filter...' => 'Just start typing to filter...',
        'Select the customer:group permissions.' => 'Select the customer:group permissions.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer).' =>
            'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer).',
        'Search Results' => 'Search Results',
        'Customers' => 'Customers',
        'No matches found.' => 'No matches found.',
        'Groups' => 'Groups',
        'Change Group Relations for Customer' => 'Change Group Relations for Customer',
        'Change Customer Relations for Group' => 'Change Customer Relations for Group',
        'Toggle %s Permission for all' => 'Toggle %s Permission for all',
        'Toggle %s permission for %s' => 'Toggle %s permission for %s',
        'Customer Default Groups:' => 'Customer Default Groups:',
        'No changes can be made to these groups.' => 'No changes can be made to these groups.',
        'ro' => 'ro',
        'Read only access to the ticket in this group/queue.' => 'Read only access to the ticket in this group/queue.',
        'rw' => 'rw',
        'Full read and write access to the tickets in this group/queue.' =>
            'Full read and write access to the tickets in this group/queue.',

        # Template: AdminCustomerUserService
        'Manage Customer-Services Relations' => 'Manage Customer-Services Relations',
        'Edit default services' => 'Edit default services',
        'Filter for Services' => 'Filter for Services',
        'Allocate Services to Customer' => 'Allocate Services to Customer',
        'Allocate Customers to Service' => 'Allocate Customers to Service',
        'Toggle active state for all' => 'Toggle active state for all',
        'Active' => 'Active',
        'Toggle active state for %s' => 'Toggle active state for %s',

        # Template: AdminDynamicField
        'Dynamic Fields Management' => 'Dynamic Fields Management',
        'Add new field for object' => 'Add new field for object',
        'To add a new field, select the field type from one of the object\'s list, the object defines the boundary of the field and it can\'t be changed after the field creation.' =>
            'To add a new field, select the field type from one of the object\'s list, the object defines the boundary of the field and it can\'t be changed after the field creation.',
        'Dynamic Fields List' => 'Dynamic Fields List',
        'Dynamic fields per page' => 'Dynamic fields per page',
        'Label' => 'Label',
        'Order' => 'Order',
        'Object' => 'Object',
        'Delete this field' => 'Delete this field',
        'Do you really want to delete this dynamic field? ALL associated data will be LOST!' =>
            'Do you really want to delete this dynamic field? ALL associated data will be LOST!',
        'Delete field' => 'Delete field',
        'Deleting the field and its data. This may take a while...' => 'Deleting the field and its data. This may take a while...',

        # Template: AdminDynamicFieldCheckbox
        'Dynamic Fields' => 'Dynamic Fields',
        'Field' => 'Field',
        'Go back to overview' => 'Go back to overview',
        'General' => 'General',
        'This field is required, and the value should be alphabetic and numeric characters only.' =>
            'This field is required, and the value should be alphabetic and numeric characters only.',
        'Must be unique and only accept alphabetic and numeric characters.' =>
            'Must be unique and only accept alphabetic and numeric characters.',
        'Changing this value will require manual changes in the system.' =>
            'Changing this value will require manual changes in the system.',
        'This is the name to be shown on the screens where the field is active.' =>
            'This is the name to be shown on the screens where the field is active.',
        'Field order' => 'Field order',
        'This field is required and must be numeric.' => 'This field is required and must be numeric.',
        'This is the order in which this field will be shown on the screens where is active.' =>
            'This is the order in which this field will be shown on the screens where is active.',
        'Field type' => 'Field type',
        'Object type' => 'Object type',
        'Internal field' => 'Internal field',
        'This field is protected and can\'t be deleted.' => 'This field is protected and can\'t be deleted.',
        'Field Settings' => 'Field Settings',
        'Default value' => 'Default value',
        'This is the default value for this field.' => 'This is the default value for this field.',

        # Template: AdminDynamicFieldDateTime
        'Default date difference' => 'Default date difference',
        'This field must be numeric.' => 'This field must be numeric.',
        'The difference from NOW (in seconds) to calculate the field default value (e.g. 3600 or -60).' =>
            'The difference from NOW (in seconds) to calculate the field default value (e.g. 3600 or -60).',
        'Define years period' => 'Define years period',
        'Activate this feature to define a fixed range of years (in the future and in the past) to be displayed on the year part of the field.' =>
            'Activate this feature to define a fixed range of years (in the future and in the past) to be displayed on the year part of the field.',
        'Years in the past' => 'Years in the past',
        'Years in the past to display (default: 5 years).' => 'Years in the past to display (default: 5 years).',
        'Years in the future' => 'Years in the future',
        'Years in the future to display (default: 5 years).' => 'Years in the future to display (default: 5 years).',
        'Show link' => 'Show link',
        'Here you can specify an optional HTTP link for the field value in Overviews and Zoom screens.' =>
            'Here you can specify an optional HTTP link for the field value in Overviews and Zoom screens.',
        'Link for preview' => 'Link for preview',
        'If filled in, this URL will be used for a preview which is shown when this link is hovered in ticket zoom. Please note that for this to work, the regular URL field above needs to be filled in, too.' =>
            'If filled in, this URL will be used for a preview which is shown when this link is hovered in ticket zoom. Please note that for this to work, the regular URL field above needs to be filled in, too.',
        'Restrict entering of dates' => 'Restrict entering of dates',
        'Here you can restrict the entering of dates of tickets.' => 'Here you can restrict the entering of dates of tickets.',

        # Template: AdminDynamicFieldDropdown
        'Possible values' => 'Possible values',
        'Key' => 'Key',
        'Value' => 'Value',
        'Remove value' => 'Remove value',
        'Add value' => 'Add value',
        'Add Value' => 'Add Value',
        'Add empty value' => 'Add empty value',
        'Activate this option to create an empty selectable value.' => 'Activate this option to create an empty selectable value.',
        'Tree View' => 'Tree View',
        'Activate this option to display values as a tree.' => 'Activate this option to display values as a tree.',
        'Translatable values' => 'Translatable values',
        'If you activate this option the values will be translated to the user defined language.' =>
            'If you activate this option the values will be translated to the user defined language.',
        'Note' => 'Note',
        'You need to add the translations manually into the language translation files.' =>
            'You need to add the translations manually into the language translation files.',

        # Template: AdminDynamicFieldText
        'Number of rows' => 'Number of rows',
        'Specify the height (in lines) for this field in the edit mode.' =>
            'Specify the height (in lines) for this field in the edit mode.',
        'Number of cols' => 'Number of cols',
        'Specify the width (in characters) for this field in the edit mode.' =>
            'Specify the width (in characters) for this field in the edit mode.',
        'Check RegEx' => 'Check RegEx',
        'Here you can specify a regular expression to check the value. The regex will be executed with the modifiers xms.' =>
            'Here you can specify a regular expression to check the value. The regex will be executed with the modifiers xms.',
        'RegEx' => 'RegEx',
        'Invalid RegEx' => 'Invalid RegEx',
        'Error Message' => 'Error Message',
        'Add RegEx' => 'Add RegEx',

        # Template: AdminEmail
        'Admin Notification' => 'Admin Notification',
        'With this module, administrators can send messages to agents, group or role members.' =>
            'With this module, administrators can send messages to agents, group or role members.',
        'Create Administrative Message' => 'Create Administrative Message',
        'Your message was sent to' => 'Your message was sent to',
        'Send message to users' => 'Send message to users',
        'Send message to group members' => 'Send message to group members',
        'Group members need to have permission' => 'Group members need to have permission',
        'Send message to role members' => 'Send message to role members',
        'Also send to customers in groups' => 'Also send to customers in groups',
        'Body' => 'Body',
        'Send' => 'Send',

        # Template: AdminGenericAgent
        'Generic Agent' => 'Generic Agent',
        'Add job' => 'Add job',
        'Last run' => 'Last run',
        'Run Now!' => 'Run Now!',
        'Delete this task' => 'Delete this task',
        'Run this task' => 'Run this task',
        'Do you really want to delete this task?' => '',
        'Job Settings' => 'Job Settings',
        'Job name' => 'Job name',
        'The name you entered already exists.' => 'The name you entered already exists.',
        'Toggle this widget' => 'Toggle this widget',
        'Automatic execution (multiple tickets)' => 'Automatic execution (multiple tickets)',
        'Execution Schedule' => 'Execution Schedule',
        'Schedule minutes' => 'Schedule minutes',
        'Schedule hours' => 'Schedule hours',
        'Schedule days' => 'Schedule days',
        'Currently this generic agent job will not run automatically.' =>
            'Currently this generic agent job will not run automatically.',
        'To enable automatic execution select at least one value from minutes, hours and days!' =>
            'To enable automatic execution select at least one value from minutes, hours and days!',
        'Event based execution (single ticket)' => 'Event based execution (single ticket)',
        'Event Triggers' => 'Event Triggers',
        'List of all configured events' => 'List of all configured events',
        'Delete this event' => 'Delete this event',
        'Additionally or alternatively to a periodic execution, you can define ticket events that will trigger this job.' =>
            'Additionally or alternatively to a periodic execution, you can define ticket events that will trigger this job.',
        'If a ticket event is fired, the ticket filter will be applied to check if the ticket matches. Only then the job is run on that ticket.' =>
            'If a ticket event is fired, the ticket filter will be applied to check if the ticket matches. Only then the job is run on that ticket.',
        'Do you really want to delete this event trigger?' => 'Do you really want to delete this event trigger?',
        'Add Event Trigger' => 'Add Event Trigger',
        'Add Event' => 'Add Event',
        'To add a new event select the event object and event name and click on the "+" button' =>
            'To add a new event select the event object and event name and click on the "+" button',
        'Duplicate event.' => 'Duplicate event.',
        'This event is already attached to the job, Please use a different one.' =>
            'This event is already attached to the job, Please use a different one.',
        'Delete this Event Trigger' => 'Delete this Event Trigger',
        'Remove selection' => 'Remove selection',
        'Select Tickets' => 'Select Tickets',
        '(e. g. 10*5155 or 105658*)' => '(e. g. 10*5155 or 105658*)',
        '(e. g. 234321)' => '(e. g. 234321)',
        'Customer user' => 'Customer user',
        '(e. g. U5150)' => '(e. g. U5150)',
        'Fulltext-search in article (e. g. "Mar*in" or "Baue*").' => 'Fulltext-search in article (e. g. "Mar*in" or "Baue*").',
        'Agent' => 'Agent',
        'Ticket lock' => 'Ticket lock',
        'Create times' => 'Create times',
        'No create time settings.' => 'No create time settings.',
        'Ticket created' => 'Ticket created',
        'Ticket created between' => 'Ticket created between',
        'Last changed times' => 'Last changed times',
        'No last changed time settings.' => 'No last changed time settings.',
        'Ticket last changed' => 'Ticket last changed',
        'Ticket last changed between' => 'Ticket last changed between',
        'Change times' => 'Change times',
        'No change time settings.' => 'No change time settings.',
        'Ticket changed' => 'Ticket changed',
        'Ticket changed between' => 'Ticket changed between',
        'Close times' => 'Close times',
        'No close time settings.' => 'No close time settings.',
        'Ticket closed' => 'Ticket closed',
        'Ticket closed between' => 'Ticket closed between',
        'Pending times' => 'Pending times',
        'No pending time settings.' => 'No pending time settings.',
        'Ticket pending time reached' => 'Ticket pending time reached',
        'Ticket pending time reached between' => 'Ticket pending time reached between',
        'Escalation times' => 'Escalation times',
        'No escalation time settings.' => 'No escalation time settings.',
        'Ticket escalation time reached' => 'Ticket escalation time reached',
        'Ticket escalation time reached between' => 'Ticket escalation time reached between',
        'Escalation - first response time' => 'Escalation - first response time',
        'Ticket first response time reached' => 'Ticket first response time reached',
        'Ticket first response time reached between' => 'Ticket first response time reached between',
        'Escalation - update time' => 'Escalation - update time',
        'Ticket update time reached' => 'Ticket update time reached',
        'Ticket update time reached between' => 'Ticket update time reached between',
        'Escalation - solution time' => 'Escalation - solution time',
        'Ticket solution time reached' => 'Ticket solution time reached',
        'Ticket solution time reached between' => 'Ticket solution time reached between',
        'Archive search option' => 'Archive search option',
        'Update/Add Ticket Attributes' => 'Update/Add Ticket Attributes',
        'Set new service' => 'Set new service',
        'Set new Service Level Agreement' => 'Set new Service Level Agreement',
        'Set new priority' => 'Set new priority',
        'Set new queue' => 'Set new queue',
        'Set new state' => 'Set new state',
        'Pending date' => 'Pending date',
        'Set new agent' => 'Set new agent',
        'new owner' => 'new owner',
        'new responsible' => 'new responsible',
        'Set new ticket lock' => 'Set new ticket lock',
        'New customer user' => 'New customer user',
        'New customer ID' => 'New customer ID',
        'New title' => 'New title',
        'New type' => 'New type',
        'New Dynamic Field Values' => 'New Dynamic Field Values',
        'Archive selected tickets' => 'Archive selected tickets',
        'Add Note' => 'Add Note',
        'Time units' => 'Time units',
        'Execute Ticket Commands' => 'Execute Ticket Commands',
        'Send agent/customer notifications on changes' => 'Send agent/customer notifications on changes',
        'CMD' => 'CMD',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' =>
            'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.',
        'Delete tickets' => 'Delete tickets',
        'Warning: All affected tickets will be removed from the database and cannot be restored!' =>
            'Warning: All affected tickets will be removed from the database and cannot be restored!',
        'Execute Custom Module' => 'Execute Custom Module',
        'Param %s key' => 'Param %s key',
        'Param %s value' => 'Param %s value',
        'Save Changes' => 'Save Changes',
        'Results' => 'Results',
        '%s Tickets affected! What do you want to do?' => '%s Tickets affected! What do you want to do?',
        'Warning: You used the DELETE option. All deleted tickets will be lost!' =>
            'Warning: You used the DELETE option. All deleted tickets will be lost!',
        'Warning: There are %s tickets affected but only %s may be modified during one job execution!' =>
            'Warning: There are %s tickets affected but only %s may be modified during one job execution!',
        'Edit job' => 'Edit job',
        'Run job' => 'Run job',
        'Affected Tickets' => 'Affected Tickets',

        # Template: AdminGenericInterfaceDebugger
        'GenericInterface Debugger for Web Service %s' => 'GenericInterface Debugger for Web Service %s',
        'You are here' => 'You are here',
        'Web Services' => 'Web Services',
        'Debugger' => 'Debugger',
        'Go back to web service' => 'Go back to web service',
        'Clear' => 'Clear',
        'Do you really want to clear the debug log of this web service?' =>
            'Do you really want to clear the debug log of this web service?',
        'Request List' => 'Request List',
        'Time' => 'Time',
        'Remote IP' => 'Remote IP',
        'Loading' => 'Loading',
        'Select a single request to see its details.' => 'Select a single request to see its details.',
        'Filter by type' => 'Filter by type',
        'Filter from' => 'Filter from',
        'Filter to' => 'Filter to',
        'Filter by remote IP' => 'Filter by remote IP',
        'Limit' => 'Limit',
        'Refresh' => 'Refresh',
        'Request Details' => 'Request Details',
        'An error occurred during communication.' => 'An error occurred during communication.',
        'Show or hide the content.' => 'Show or hide the content.',
        'Clear debug log' => 'Clear debug log',

        # Template: AdminGenericInterfaceInvokerDefault
        'Add new Invoker to Web Service %s' => 'Add new Invoker to Web Service %s',
        'Change Invoker %s of Web Service %s' => 'Change Invoker %s of Web Service %s',
        'Add new invoker' => 'Add new invoker',
        'Change invoker %s' => 'Change invoker %s',
        'Do you really want to delete this invoker?' => 'Do you really want to delete this invoker?',
        'All configuration data will be lost.' => 'All configuration data will be lost.',
        'Invoker Details' => 'Invoker Details',
        'The name is typically used to call up an operation of a remote web service.' =>
            'The name is typically used to call up an operation of a remote web service.',
        'Please provide a unique name for this web service invoker.' => 'Please provide a unique name for this web service invoker.',
        'Invoker backend' => 'Invoker backend',
        'This OTRS invoker backend module will be called to prepare the data to be sent to the remote system, and to process its response data.' =>
            'This OTRS invoker backend module will be called to prepare the data to be sent to the remote system, and to process its response data.',
        'Mapping for outgoing request data' => 'Mapping for outgoing request data',
        'Configure' => 'Configure',
        'The data from the invoker of OTRS will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            'The data from the invoker of OTRS will be processed by this mapping, to transform it to the kind of data the remote system expects.',
        'Mapping for incoming response data' => 'Mapping for incoming response data',
        'The response data will be processed by this mapping, to transform it to the kind of data the invoker of OTRS expects.' =>
            'The response data will be processed by this mapping, to transform it to the kind of data the invoker of OTRS expects.',
        'Asynchronous' => 'Asynchronous',
        'This invoker will be triggered by the configured events.' => 'This invoker will be triggered by the configured events.',
        'Asynchronous event triggers are handled by the OTRS Scheduler Daemon in background (recommended).' =>
            'Asynchronous event triggers are handled by the OTRS Scheduler Daemon in background (recommended).',
        'Synchronous event triggers would be processed directly during the web request.' =>
            'Synchronous event triggers would be processed directly during the web request.',
        'Save and continue' => 'Save and continue',
        'Delete this Invoker' => 'Delete this Invoker',

        # Template: AdminGenericInterfaceMappingSimple
        'GenericInterface Mapping Simple for Web Service %s' => 'GenericInterface Mapping Simple for Web Service %s',
        'Go back to' => 'Go back to',
        'Mapping Simple' => 'Mapping Simple',
        'Default rule for unmapped keys' => 'Default rule for unmapped keys',
        'This rule will apply for all keys with no mapping rule.' => 'This rule will apply for all keys with no mapping rule.',
        'Default rule for unmapped values' => 'Default rule for unmapped values',
        'This rule will apply for all values with no mapping rule.' => 'This rule will apply for all values with no mapping rule.',
        'New key map' => 'New key map',
        'Add key mapping' => 'Add key mapping',
        'Mapping for Key ' => 'Mapping for Key ',
        'Remove key mapping' => 'Remove key mapping',
        'Key mapping' => 'Key mapping',
        'Map key' => 'Map key',
        'matching the' => 'matching the',
        'to new key' => 'to new key',
        'Value mapping' => 'Value mapping',
        'Map value' => 'Map value',
        'to new value' => 'to new value',
        'Remove value mapping' => 'Remove value mapping',
        'New value map' => 'New value map',
        'Add value mapping' => 'Add value mapping',
        'Do you really want to delete this key mapping?' => 'Do you really want to delete this key mapping?',
        'Delete this Key Mapping' => 'Delete this Key Mapping',

        # Template: AdminGenericInterfaceMappingXSLT
        'GenericInterface Mapping XSLT for Web Service %s' => 'GenericInterface Mapping XSLT for Web Service %s',
        'Mapping XML' => 'Mapping XML',
        'Template' => 'Template',
        'The entered data is not a valid XSLT stylesheet.' => 'The entered data is not a valid XSLT stylesheet.',
        'Insert XSLT stylesheet.' => 'Insert XSLT stylesheet.',

        # Template: AdminGenericInterfaceOperationDefault
        'Add new Operation to Web Service %s' => 'Add new Operation to Web Service %s',
        'Change Operation %s of Web Service %s' => 'Change Operation %s of Web Service %s',
        'Add new operation' => 'Add new operation',
        'Change operation %s' => 'Change operation %s',
        'Do you really want to delete this operation?' => 'Do you really want to delete this operation?',
        'Operation Details' => 'Operation Details',
        'The name is typically used to call up this web service operation from a remote system.' =>
            'The name is typically used to call up this web service operation from a remote system.',
        'Please provide a unique name for this web service.' => 'Please provide a unique name for this web service.',
        'Mapping for incoming request data' => 'Mapping for incoming request data',
        'The request data will be processed by this mapping, to transform it to the kind of data OTRS expects.' =>
            'The request data will be processed by this mapping, to transform it to the kind of data OTRS expects.',
        'Operation backend' => 'Operation backend',
        'This OTRS operation backend module will be called internally to process the request, generating data for the response.' =>
            'This OTRS operation backend module will be called internally to process the request, generating data for the response.',
        'Mapping for outgoing response data' => 'Mapping for outgoing response data',
        'The response data will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            'The response data will be processed by this mapping, to transform it to the kind of data the remote system expects.',
        'Delete this Operation' => 'Delete this Operation',

        # Template: AdminGenericInterfaceTransportHTTPREST
        'GenericInterface Transport HTTP::REST for Web Service %s' => 'GenericInterface Transport HTTP::REST for Web Service %s',
        'Network transport' => 'Network transport',
        'Properties' => 'Properties',
        'Route mapping for Operation' => 'Route mapping for Operation',
        'Define the route that should get mapped to this operation. Variables marked by a \':\' will get mapped to the entered name and passed along with the others to the mapping. (e.g. /Ticket/:TicketID).' =>
            'Define the route that should get mapped to this operation. Variables marked by a \':\' will get mapped to the entered name and passed along with the others to the mapping. (e.g. /Ticket/:TicketID).',
        'Valid request methods for Operation' => 'Valid request methods for Operation',
        'Limit this Operation to specific request methods. If no method is selected all requests will be accepted.' =>
            'Limit this Operation to specific request methods. If no method is selected all requests will be accepted.',
        'Maximum message length' => 'Maximum message length',
        'This field should be an integer number.' => 'This field should be an integer number.',
        'Here you can specify the maximum size (in bytes) of REST messages that OTRS will process.' =>
            'Here you can specify the maximum size (in bytes) of REST messages that OTRS will process.',
        'Send Keep-Alive' => 'Send Keep-Alive',
        'This configuration defines if incoming connections should get closed or kept alive.' =>
            'This configuration defines if incoming connections should get closed or kept alive.',
        'Host' => 'Host',
        'Remote host URL for the REST requests.' => 'Remote host URL for the REST requests.',
        'e.g https://www.otrs.com:10745/api/v1.0 (without trailing backslash)' =>
            'e.g https://www.otrs.com:10745/api/v1.0 (without trailing backslash)',
        'Controller mapping for Invoker' => 'Controller mapping for Invoker',
        'The controller that the invoker should send requests to. Variables marked by a \':\' will get replaced by the data value and passed along with the request. (e.g. /Ticket/:TicketID?UserLogin=:UserLogin&Password=:Password).' =>
            'The controller that the invoker should send requests to. Variables marked by a \':\' will get replaced by the data value and passed along with the request. (e.g. /Ticket/:TicketID?UserLogin=:UserLogin&Password=:Password).',
        'Valid request command for Invoker' => 'Valid request command for Invoker',
        'A specific HTTP command to use for the requests with this Invoker (optional).' =>
            'A specific HTTP command to use for the requests with this Invoker (optional).',
        'Default command' => 'Default command',
        'The default HTTP command to use for the requests.' => 'The default HTTP command to use for the requests.',
        'Authentication' => 'Authentication',
        'The authentication mechanism to access the remote system.' => 'The authentication mechanism to access the remote system.',
        'A "-" value means no authentication.' => 'A "-" value means no authentication.',
        'The user name to be used to access the remote system.' => 'The user name to be used to access the remote system.',
        'The password for the privileged user.' => 'The password for the privileged user.',
        'Use SSL Options' => 'Use SSL Options',
        'Show or hide SSL options to connect to the remote system.' => 'Show or hide SSL options to connect to the remote system.',
        'Certificate File' => 'Certificate File',
        'The full path and name of the SSL certificate file.' => 'The full path and name of the SSL certificate file.',
        'e.g. /opt/otrs/var/certificates/REST/ssl.crt' => 'e.g. /opt/otrs/var/certificates/REST/ssl.crt',
        'Certificate Password File' => 'Certificate Password File',
        'The full path and name of the SSL key file.' => 'The full path and name of the SSL key file.',
        'e.g. /opt/otrs/var/certificates/REST/ssl.key' => 'e.g. /opt/otrs/var/certificates/REST/ssl.key',
        'Certification Authority (CA) File' => 'Certification Authority (CA) File',
        'The full path and name of the certification authority certificate file that validates the SSL certificate.' =>
            'The full path and name of the certification authority certificate file that validates the SSL certificate.',
        'e.g. /opt/otrs/var/certificates/REST/CA/ca.file' => 'e.g. /opt/otrs/var/certificates/REST/CA/ca.file',

        # Template: AdminGenericInterfaceTransportHTTPSOAP
        'GenericInterface Transport HTTP::SOAP for Web Service %s' => 'GenericInterface Transport HTTP::SOAP for Web Service %s',
        'Endpoint' => 'Endpoint',
        'URI to indicate a specific location for accessing a service.' =>
            'URI to indicate a specific location for accessing a service.',
        'e.g. http://local.otrs.com:8000/Webservice/Example' => 'e.g. http://local.otrs.com:8000/Webservice/Example',
        'Namespace' => 'Namespace',
        'URI to give SOAP methods a context, reducing ambiguities.' => 'URI to give SOAP methods a context, reducing ambiguities.',
        'e.g urn:otrs-com:soap:functions or http://www.otrs.com/GenericInterface/actions' =>
            'e.g urn:otrs-com:soap:functions or http://www.otrs.com/GenericInterface/actions',
        'Request name scheme' => 'Request name scheme',
        'Select how SOAP request function wrapper should be constructed.' =>
            'Select how SOAP request function wrapper should be constructed.',
        '\'FunctionName\' is used as example for actual invoker/operation name.' =>
            '\'FunctionName\' is used as example for actual invoker/operation name.',
        '\'FreeText\' is used as example for actual configured value.' =>
            '\'FreeText\' is used as example for actual configured value.',
        'Request name free text' => '',
        'Text to be used to as function wrapper name suffix or replacement.' =>
            'Text to be used to as function wrapper name suffix or replacement.',
        'Please consider XML element naming restrictions (e.g. don\'t use \'<\' and \'&\').' =>
            'Please consider XML element naming restrictions (e.g. don\'t use \'<\' and \'&\').',
        'Response name scheme' => 'Response name scheme',
        'Select how SOAP response function wrapper should be constructed.' =>
            'Select how SOAP response function wrapper should be constructed.',
        'Response name free text' => 'Response name free text',
        'Here you can specify the maximum size (in bytes) of SOAP messages that OTRS will process.' =>
            'Here you can specify the maximum size (in bytes) of SOAP messages that OTRS will process.',
        'Encoding' => 'Encoding',
        'The character encoding for the SOAP message contents.' => 'The character encoding for the SOAP message contents.',
        'e.g utf-8, latin1, iso-8859-1, cp1250, Etc.' => 'e.g utf-8, latin1, iso-8859-1, cp1250, Etc.',
        'SOAPAction' => 'SOAPAction',
        'Set to "Yes" to send a filled SOAPAction header.' => 'Set to "Yes" to send a filled SOAPAction header.',
        'Set to "No" to send an empty SOAPAction header.' => 'Set to "No" to send an empty SOAPAction header.',
        'SOAPAction separator' => 'SOAPAction separator',
        'Character to use as separator between name space and SOAP method.' =>
            'Character to use as separator between name space and SOAP method.',
        'Usually .Net web services uses a "/" as separator.' => 'Usually .Net web services uses a "/" as separator.',
        'Proxy Server' => 'Proxy Server',
        'URI of a proxy server to be used (if needed).' => 'URI of a proxy server to be used (if needed).',
        'e.g. http://proxy_hostname:8080' => 'e.g. http://proxy_hostname:8080',
        'Proxy User' => 'Proxy User',
        'The user name to be used to access the proxy server.' => 'The user name to be used to access the proxy server.',
        'Proxy Password' => 'Proxy Password',
        'The password for the proxy user.' => 'The password for the proxy user.',
        'The full path and name of the SSL certificate file (must be in .p12 format).' =>
            'The full path and name of the SSL certificate file (must be in .p12 format).',
        'e.g. /opt/otrs/var/certificates/SOAP/certificate.p12' => 'e.g. /opt/otrs/var/certificates/SOAP/certificate.p12',
        'The password to open the SSL certificate.' => 'The password to open the SSL certificate.',
        'The full path and name of the certification authority certificate file that validates SSL certificate.' =>
            'The full path and name of the certification authority certificate file that validates SSL certificate.',
        'e.g. /opt/otrs/var/certificates/SOAP/CA/ca.pem' => 'e.g. /opt/otrs/var/certificates/SOAP/CA/ca.pem',
        'Certification Authority (CA) Directory' => 'Certification Authority (CA) Directory',
        'The full path of the certification authority directory where the CA certificates are stored in the file system.' =>
            'The full path of the certification authority directory where the CA certificates are stored in the file system.',
        'e.g. /opt/otrs/var/certificates/SOAP/CA' => 'e.g. /opt/otrs/var/certificates/SOAP/CA',
        'Sort options' => 'Sort options',
        'Add new first level element' => 'Add new first level element',
        'Element' => 'Element',
        'Outbound sort order for xml fields (structure starting below function name wrapper) - see documentation for SOAP transport.' =>
            'Outbound sort order for xml fields (structure starting below function name wrapper) - see documentation for SOAP transport.',

        # Template: AdminGenericInterfaceWebservice
        'GenericInterface Web Service Management' => 'GenericInterface Web Service Management',
        'Add web service' => 'Add web service',
        'Clone web service' => 'Clone web service',
        'The name must be unique.' => 'The name must be unique.',
        'Clone' => 'Clone',
        'Export web service' => 'Export web service',
        'Import web service' => 'Import web service',
        'Configuration File' => 'Configuration File',
        'The file must be a valid web service configuration YAML file.' =>
            'The file must be a valid web service configuration YAML file.',
        'Import' => 'Import',
        'Configuration history' => 'Configuration history',
        'Delete web service' => 'Delete web service',
        'Do you really want to delete this web service?' => 'Do you really want to delete this web service?',
        'Ready-to-run Web Services' => '',
        'Here you can activate ready-to-run web services showcasing our best practices that are a part of %s.' =>
            '',
        'Please note that these web services may depend on other modules only available with certain %s contract levels (there will be a notification with further details when importing).' =>
            '',
        'Import ready-to-run web service' => '',
        'Would you like to benefit from web services created by experts? Upgrade to %s to import some sophisticated ready-to-run web services.' =>
            '',
        'After you save the configuration you will be redirected again to the edit screen.' =>
            'After you save the configuration you will be redirected again to the edit screen.',
        'If you want to return to overview please click the "Go to overview" button.' =>
            'If you want to return to overview please click the "Go to overview" button.',
        'Web Service List' => 'Web Service List',
        'Remote system' => 'Remote system',
        'Provider transport' => 'Provider transport',
        'Requester transport' => 'Requester transport',
        'Debug threshold' => 'Debug threshold',
        'In provider mode, OTRS offers web services which are used by remote systems.' =>
            'In provider mode, OTRS offers web services which are used by remote systems.',
        'In requester mode, OTRS uses web services of remote systems.' =>
            'In requester mode, OTRS uses web services of remote systems.',
        'Operations are individual system functions which remote systems can request.' =>
            'Operations are individual system functions which remote systems can request.',
        'Invokers prepare data for a request to a remote web service, and process its response data.' =>
            'Invokers prepare data for a request to a remote web service, and process its response data.',
        'Controller' => 'Controller',
        'Inbound mapping' => 'Inbound mapping',
        'Outbound mapping' => 'Outbound mapping',
        'Delete this action' => 'Delete this action',
        'At least one %s has a controller that is either not active or not present, please check the controller registration or delete the %s' =>
            'At least one %s has a controller that is either not active or not present, please check the controller registration or delete the %s',
        'Delete webservice' => 'Delete webservice',
        'Delete operation' => 'Delete operation',
        'Delete invoker' => 'Delete invoker',
        'Clone webservice' => 'Clone webservice',
        'Import webservice' => 'Import webservice',

        # Template: AdminGenericInterfaceWebserviceHistory
        'GenericInterface Configuration History for Web Service %s' => 'GenericInterface Configuration History for Web Service %s',
        'Go back to Web Service' => 'Go back to Web Service',
        'Here you can view older versions of the current web service\'s configuration, export or even restore them.' =>
            'Here you can view older versions of the current web service\'s configuration, export or even restore them.',
        'Configuration History List' => 'Configuration History List',
        'Version' => 'Version',
        'Create time' => 'Create time',
        'Select a single configuration version to see its details.' => 'Select a single configuration version to see its details.',
        'Export web service configuration' => 'Export web service configuration',
        'Restore web service configuration' => 'Restore web service configuration',
        'Do you really want to restore this version of the web service configuration?' =>
            'Do you really want to restore this version of the web service configuration?',
        'Your current web service configuration will be overwritten.' => 'Your current web service configuration will be overwritten.',
        'Restore' => 'Restore',

        # Template: AdminGroup
        'WARNING: When you change the name of the group \'admin\', before making the appropriate changes in the SysConfig, you will be locked out of the administrations panel! If this happens, please rename the group back to admin per SQL statement.' =>
            'WARNING: When you change the name of the group \'admin\', before making the appropriate changes in the SysConfig, you will be locked out of the administrations panel! If this happens, please rename the group back to admin per SQL statement.',
        'Group Management' => 'Group Management',
        'Add group' => 'Add group',
        'The admin group is to get in the admin area and the stats group to get stats area.' =>
            'The admin group is to get in the admin area and the stats group to get stats area.',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...). ' =>
            'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...). ',
        'It\'s useful for ASP solutions. ' => 'It\'s useful for ASP solutions. ',
        'total' => 'total',
        'Add Group' => 'Add Group',
        'Edit Group' => 'Edit Group',

        # Template: AdminLog
        'System Log' => 'System Log',
        'Here you will find log information about your system.' => 'Here you will find log information about your system.',
        'Hide this message' => 'Hide this message',
        'Recent Log Entries' => 'Recent Log Entries',

        # Template: AdminMailAccount
        'Mail Account Management' => 'Mail Account Management',
        'Add mail account' => 'Add mail account',
        'All incoming emails with one account will be dispatched in the selected queue!' =>
            'All incoming emails with one account will be dispatched in the selected queue!',
        'If your account is trusted, the already existing X-OTRS header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' =>
            'If your account is trusted, the already existing X-OTRS header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.',
        'Delete account' => 'Delete account',
        'Fetch mail' => 'Fetch mail',
        'Add Mail Account' => 'Add Mail Account',
        'Example: mail.example.com' => 'Example: mail.example.com',
        'IMAP Folder' => 'IMAP Folder',
        'Only modify this if you need to fetch mail from a different folder than INBOX.' =>
            'Only modify this if you need to fetch mail from a different folder than INBOX.',
        'Trusted' => 'Trusted',
        'Dispatching' => 'Dispatching',
        'Edit Mail Account' => 'Edit Mail Account',

        # Template: AdminNavigationBar
        'Admin' => 'Admin',
        'Agent Management' => 'Agent Management',
        'Queue Settings' => 'Queue Settings',
        'Ticket Settings' => 'Ticket Settings',
        'System Administration' => 'System Administration',
        'Online Admin Manual' => 'Online Admin Manual',

        # Template: AdminNotificationEvent
        'Ticket Notification Management' => 'Ticket Notification Management',
        'Add notification' => 'Add notification',
        'Export Notifications' => 'Export Notifications',
        'Configuration Import' => 'Configuration Import',
        'Here you can upload a configuration file to import Ticket Notifications to your system. The file needs to be in .yml format as exported by the Ticket Notification module.' =>
            'Here you can upload a configuration file to import Ticket Notifications to your system. The file needs to be in .yml format as exported by the Ticket Notification module.',
        'Overwrite existing notifications?' => 'Overwrite existing notifications?',
        'Upload Notification configuration' => 'Upload Notification configuration',
        'Import Notification configuration' => 'Import Notification configuration',
        'Delete this notification' => 'Delete this notification',
        'Do you really want to delete this notification?' => 'Do you really want to delete this notification?',
        'Add Notification' => 'Add Notification',
        'Edit Notification' => 'Edit Notification',
        'Show in agent preferences' => 'Show in agent preferences',
        'Agent preferences tooltip' => 'Agent preferences tooltip',
        'This message will be shown on the agent preferences screen as a tooltip for this notification.' =>
            'This message will be shown on the agent preferences screen as a tooltip for this notification.',
        'Here you can choose which events will trigger this notification. An additional ticket filter can be applied below to only send for ticket with certain criteria.' =>
            'Here you can choose which events will trigger this notification. An additional ticket filter can be applied below to only send for ticket with certain criteria.',
        'Ticket Filter' => 'Ticket Filter',
        'Article Filter' => 'Article Filter',
        'Only for ArticleCreate and ArticleSend event' => 'Only for ArticleCreate and ArticleSend event',
        'Article type' => 'Article type',
        'If ArticleCreate or ArticleSend is used as a trigger event, you need to specify an article filter as well. Please select at least one of the article filter fields.' =>
            'If ArticleCreate or ArticleSend is used as a trigger event, you need to specify an article filter as well. Please select at least one of the article filter fields.',
        'Article sender type' => 'Article sender type',
        'Subject match' => 'Subject match',
        'Body match' => 'Body match',
        'Include attachments to notification' => 'Include attachments to notification',
        'Recipients' => 'Recipients',
        'Send to' => 'Send to',
        'Send to these agents' => 'Send to these agents',
        'Send to all group members' => 'Send to all group members',
        'Send to all role members' => 'Send to all role members',
        'Send on out of office' => 'Send on out of office',
        'Also send if the user is currently out of office.' => 'Also send if the user is currently out of office.',
        'Once per day' => 'Once per day',
        'Notify user just once per day about a single ticket using a selected transport.' =>
            'Notify user just once per day about a single ticket using a selected transport.',
        'Notification Methods' => 'Notification Methods',
        'These are the possible methods that can be used to send this notification to each of the recipients. Please select at least one method below.' =>
            'These are the possible methods that can be used to send this notification to each of the recipients. Please select at least one method below.',
        'Enable this notification method' => 'Enable this notification method',
        'Transport' => 'Transport',
        'At least one method is needed per notification.' => 'At least one method is needed per notification.',
        'Active by default in agent preferences' => 'Active by default in agent preferences',
        'This is the default value for assigned recipient agents who didn\'t make a choice for this notification in their preferences yet. If the box is enabled, the notification will be sent to such agents.' =>
            'This is the default value for assigned recipient agents who didn\'t make a choice for this notification in their preferences yet. If the box is enabled, the notification will be sent to such agents.',
        'This feature is currently not available.' => 'This feature is currently not available.',
        'No data found' => 'No data found',
        'No notification method found.' => 'No notification method found.',
        'Notification Text' => 'Notification Text',
        'This language is not present or enabled on the system. This notification text could be deleted if it is not needed anymore.' =>
            'This language is not present or enabled on the system. This notification text could be deleted if it is not needed anymore.',
        'Remove Notification Language' => 'Remove Notification Language',
        'Message body' => 'Message body',
        'Add new notification language' => 'Add new notification language',
        'Do you really want to delete this notification language?' => 'Do you really want to delete this notification language?',
        'Tag Reference' => 'Tag Reference',
        'Notifications are sent to an agent or a customer.' => 'Notifications are sent to an agent or a customer.',
        'To get the first 20 character of the subject (of the latest agent article).' =>
            'To get the first 20 character of the subject (of the latest agent article).',
        'To get the first 5 lines of the body (of the latest agent article).' =>
            'To get the first 5 lines of the body (of the latest agent article).',
        'To get the first 20 character of the subject (of the latest customer article).' =>
            'To get the first 20 character of the subject (of the latest customer article).',
        'To get the first 5 lines of the body (of the latest customer article).' =>
            'To get the first 5 lines of the body (of the latest customer article).',
        'Attributes of the current customer user data' => 'Attributes of the current customer user data',
        'Attributes of the current ticket owner user data' => 'Attributes of the current ticket owner user data',
        'Attributes of the current ticket responsible user data' => 'Attributes of the current ticket responsible user data',
        'Attributes of the current agent user who requested this action' =>
            'Attributes of the current agent user who requested this action',
        'Attributes of the recipient user for the notification' => 'Attributes of the recipient user for the notification',
        'Attributes of the ticket data' => 'Attributes of the ticket data',
        'Ticket dynamic fields internal key values' => 'Ticket dynamic fields internal key values',
        'Ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            'Ticket dynamic fields display values, useful for Dropdown and Multiselect fields',
        'Example notification' => 'Example notification',

        # Template: AdminNotificationEventTransportEmailSettings
        'Additional recipient email addresses' => 'Additional recipient email addresses',
        'You can use OTRS-tags like <OTRS_TICKET_DynamicField_...> to insert values from the current ticket.' =>
            '',
        'Notification article type' => 'Notification article type',
        'An article will be created if the notification is sent to the customer or an additional email address.' =>
            'An article will be created if the notification is sent to the customer or an additional email address.',
        'Email template' => 'Email template',
        'Use this template to generate the complete email (only for HTML emails).' =>
            'Use this template to generate the complete email (only for HTML emails).',
        'Enable email security' => '',
        'Email security level' => '',
        'If signing key/certificate is missing' => '',
        'If encryption key/certificate is missing' => '',

        # Template: AdminOTRSBusinessInstalled
        'Manage %s' => 'Manage %s',
        'Go to the OTRS customer portal' => '',
        'Downgrade to OTRS Free' => 'Downgrade to OTRS Free',
        'Read documentation' => 'Read documentation',
        '%s makes contact regularly with cloud.otrs.com to check on available updates and the validity of the underlying contract.' =>
            '%s makes contact regularly with cloud.otrs.com to check on available updates and the validity of the underlying contract.',
        'Unauthorized Usage Detected' => 'Unauthorised Usage Detected',
        'This system uses the %s without a proper license! Please make contact with %s to renew or activate your contract!' =>
            'This system uses the %s without a proper license! Please make contact with %s to renew or activate your contract!',
        '%s not Correctly Installed' => '%s not Correctly Installed',
        'Your %s is not correctly installed. Please reinstall it with the button below.' =>
            'Your %s is not correctly installed. Please reinstall it with the button below.',
        'Reinstall %s' => 'Reinstall %s',
        'Your %s is not correctly installed, and there is also an update available.' =>
            'Your %s is not correctly installed, and there is also an update available.',
        'You can either reinstall your current version or perform an update with the buttons below (update recommended).' =>
            'You can either reinstall your current version or perform an update with the buttons below (update recommended).',
        'Update %s' => 'Update %s',
        '%s Not Yet Available' => '%s Not Yet Available',
        '%s will be available soon.' => '%s will be available soon.',
        '%s Update Available' => '%s Update Available',
        'Package installation requires patch level update of OTRS.' => '',
        'Please visit our customer portal and file a request.' => '',
        'Everything else will be done as part of your contract.' => '',
        'Your installed OTRS version is %s.' => '',
        'To install the current version of OTRS Business Solution™, you need to update to OTRS %s or higher.' =>
            '',
        'To install the current version of OTRS Business Solution™, the Maximum OTRS Version is %s.' =>
            '',
        'To install this package, the required Framework version is %s.' =>
            '',
        'Why should I keep OTRS up to date?' => '',
        'You will receive updates about relevant security issues.' => '',
        'You will receive updates for all other relevant OTRS issues' => '',
        'An update for your %s is available! Please update at your earliest!' =>
            'An update for your %s is available! Please update at your earliest!',
        '%s Correctly Deployed' => '%s Correctly Deployed',
        'Congratulations, your %s is correctly installed and up to date!' =>
            'Congratulations, your %s is correctly installed and up to date!',

        # Template: AdminOTRSBusinessNotInstalled
        '%s will be available soon. Please check again in a few days.' =>
            '%s will be available soon. Please check again in a few days.',
        'Please have a look at %s for more information.' => 'Please have a look at %s for more information.',
        'Your OTRS Free is the base for all future actions. Please register first before you continue with the upgrade process of %s!' =>
            'Your OTRS Free is the base for all future actions. Please register first before you continue with the upgrade process of %s.',
        'Before you can benefit from %s, please contact %s to get your %s contract.' =>
            'Before you can benefit from %s, please contact %s to get your %s contract.',
        'Connection to cloud.otrs.com via HTTPS couldn\'t be established. Please make sure that your OTRS can connect to cloud.otrs.com via port 443.' =>
            'Connection to cloud.otrs.com via HTTPS couldn\'t be established. Please make sure that your OTRS can connect to cloud.otrs.com via port 443.',
        'To install this package, you need to update to OTRS %s or higher.' =>
            '',
        'To install this package, the Maximum OTRS Version is %s.' => '',
        'With your existing contract you can only use a small part of the %s.' =>
            'With your existing contract you can only use a small part of the %s.',
        'If you would like to take full advantage of the %s get your contract upgraded now! Contact %s.' =>
            'If you would like to take full advantage of the %s get your contract upgraded now! Contact %s.',

        # Template: AdminOTRSBusinessUninstall
        'Cancel downgrade and go back' => 'Cancel downgrade and go back',
        'Go to OTRS Package Manager' => 'Go to OTRS Package Manager',
        'Sorry, but currently you can\'t downgrade due to the following packages which depend on %s:' =>
            'Sorry, but currently you can\'t downgrade due to the following packages which depend on %s:',
        'Vendor' => 'Vendor',
        'Please uninstall the packages first using the package manager and try again.' =>
            'Please uninstall the packages first using the package manager and try again.',
        'You are about to downgrade to OTRS Free and will lose the following features and all data related to these:' =>
            'You are about to downgrade to OTRS Free and will lose the following features and all data related to these:',
        'Chat' => 'Chat',
        'Report Generator' => 'Report Generator',
        'Timeline view in ticket zoom' => 'Timeline view in ticket zoom',
        'DynamicField ContactWithData' => 'DynamicField ContactWithData',
        'DynamicField Database' => 'DynamicField Database',
        'SLA Selection Dialog' => 'SLA Selection Dialog',
        'Ticket Attachment View' => 'Ticket Attachment View',
        'The %s skin' => 'The %s skin',

        # Template: AdminPGP
        'PGP Management' => 'PGP Management',
        'PGP support is disabled' => 'PGP support is disabled',
        'To be able to use PGP in OTRS, you have to enable it first.' => 'To be able to use PGP in OTRS, you have to enable it first.',
        'Enable PGP support' => 'Enable PGP support.',
        'Faulty PGP configuration' => 'Faulty PGP configuration',
        'PGP support is enabled, but the relevant configuration contains errors. Please check the configuration using the button below.' =>
            'PGP support is enabled, but the relevant configuration contains errors. Please check the configuration using the button below.',
        'Configure it here!' => 'Configure it here!',
        'Check PGP configuration' => 'Check PGP configuration',
        'Add PGP key' => 'Add PGP key',
        'In this way you can directly edit the keyring configured in SysConfig.' =>
            'In this way you can directly edit the keyring configured in SysConfig.',
        'Introduction to PGP' => 'Introduction to PGP',
        'Result' => 'Result',
        'Identifier' => 'Identifier',
        'Bit' => 'Bit',
        'Fingerprint' => 'Fingerprint',
        'Expires' => 'Expires',
        'Delete this key' => 'Delete this key',
        'Add PGP Key' => 'Add PGP Key',
        'PGP key' => 'PGP key',

        # Template: AdminPackageManager
        'Package Manager' => 'Package Manager',
        'Uninstall package' => 'Uninstall package',
        'Do you really want to uninstall this package?' => 'Do you really want to uninstall this package?',
        'Reinstall package' => 'Reinstall package',
        'Do you really want to reinstall this package? Any manual changes will be lost.' =>
            'Do you really want to reinstall this package? Any manual changes will be lost.',
        'Go to upgrading instructions' => '',
        'package information' => '',
        'Package upgrade requires patch level update of OTRS.' => '',
        'If you are a OTRS Business Solution™ customer, please visit our customer portal and file a request.' =>
            '',
        'Please note that your installed OTRS version is %s.' => '',
        'How can I do a patch level update if I don’t have a contract?' =>
            '',
        'Please find all relevant information within' => '',
        'the upgrading instructions' => '',
        'In case you would have further questions we would be glad to answer them.' =>
            'In case you would have further questions we would be glad to answer them.',
        'Please visit our customer' => '',
        'portal' => 'portal',
        'and file a request.' => 'and file a request.',
        'Continue' => 'Continue',
        'Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            'Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.',
        'Install' => 'Install',
        'Install Package' => 'Install Package',
        'Update repository information' => 'Update repository information',
        'Cloud services are currently disabled.' => 'Cloud services are currently disabled.',
        'OTRS Verify™ can not continue!' => 'OTRS Verify™ can not continue!',
        'Enable cloud services' => 'Enable cloud services',
        'Online Repository' => 'Online Repository',
        'Module documentation' => 'Module documentation',
        'Upgrade' => 'Upgrade',
        'Local Repository' => 'Local Repository',
        'This package is verified by OTRSverify (tm)' => 'This package is verified by OTRSverify (tm)',
        'Uninstall' => 'Uninstall',
        'Reinstall' => 'Reinstall',
        'Features for %s customers only' => 'Features for %s customers only',
        'With %s, you can benefit from the following optional features. Please make contact with %s if you need more information.' =>
            'With %s, you can benefit from the following optional features. Please make contact with %s if you need more information.',
        'Download package' => 'Download package',
        'Rebuild package' => 'Rebuild package',
        'Metadata' => 'Metadata',
        'Change Log' => 'Change Log',
        'Date' => 'Date',
        'List of Files' => 'List of FIles',
        'Permission' => 'Permission',
        'Download' => 'Download',
        'Download file from package!' => 'Download file from package!',
        'Required' => 'Required',
        'Primary Key' => '',
        'Auto Increment' => '',
        'SQL' => 'SQL',
        'File differences for file %s' => 'File differences for file %s',

        # Template: AdminPerformanceLog
        'Performance Log' => 'Performance Log',
        'This feature is enabled!' => 'This feature is enabled!',
        'Just use this feature if you want to log each request.' => 'Just use this feature if you want to log each request.',
        'Activating this feature might affect your system performance!' =>
            'Activating this feature might affect your system performance!',
        'Disable it here!' => 'Disable it here!',
        'Logfile too large!' => 'Logfile too large!',
        'The logfile is too large, you need to reset it' => 'The logfile is too large, you need to reset it',
        'Overview' => 'Overview',
        'Range' => 'Range',
        'last' => 'last',
        'Interface' => 'Interface',
        'Requests' => 'Requests',
        'Min Response' => 'Min Response',
        'Max Response' => 'Max Response',
        'Average Response' => 'Average Response',
        'Period' => 'Period',
        'Min' => 'Min',
        'Max' => 'Max',
        'Average' => 'Average',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => 'PostMaster Filter Management',
        'Add filter' => 'Add filter',
        'To dispatch or filter incoming emails based on email headers. Matching using Regular Expressions is also possible.' =>
            'To dispatch or filter incoming emails based on email headers. Matching using Regular Expressions is also possible.',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' =>
            'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.',
        'If you use Regular Expressions, you also can use the matched value in () as [***] in the \'Set\' action.' =>
            'If you use Regular Expressions, you also can use the matched value in () as [***] in the \'Set\' action.',
        'Delete this filter' => 'Delete this filter',
        'Do you really want to delete this filter?' => '',
        'Add PostMaster Filter' => 'Add PostMaster Filter',
        'Edit PostMaster Filter' => 'Edit PostMaster Filter',
        'A postmaster filter with this name already exists!' => '',
        'Filter Condition' => 'Filter Condition',
        'AND Condition' => 'AND Condition',
        'Check email header' => 'Check email header',
        'Negate' => 'Negate',
        'Look for value' => 'Look for value',
        'The field needs to be a valid regular expression or a literal word.' =>
            'The field needs to be a valid regular expression or a literal word.',
        'Set Email Headers' => 'Set Email Headers',
        'Set email header' => 'Set email header',
        'Set value' => 'Set value',
        'The field needs to be a literal word.' => 'The field needs to be a literal word.',

        # Template: AdminPriority
        'Priority Management' => 'Priority Management',
        'Add priority' => 'Add priority',
        'Add Priority' => 'Add Priority',
        'Edit Priority' => 'Edit Priority',

        # Template: AdminProcessManagement
        'Process Management' => 'Process Management',
        'Filter for Processes' => 'Filter for Processes',
        'Create New Process' => 'Create New Process',
        'Deploy All Processes' => 'Deploy All Processes',
        'Here you can upload a configuration file to import a process to your system. The file needs to be in .yml format as exported by process management module.' =>
            'Here you can upload a configuration file to import a process to your system. The file needs to be in .yml format as exported by process management module.',
        'Overwrite existing entities' => 'Overwrite existing entities',
        'Upload process configuration' => 'Upload process configuration',
        'Import process configuration' => 'Import process configuration',
        'Ready-to-run Processes' => '',
        'Here you can activate ready-to-run processes showcasing our best practices. Please note that some additional configuration may be required.' =>
            '',
        'Would you like to benefit from processes created by experts? Upgrade to %s to import some sophisticated ready-to-run processes.' =>
            '',
        'Import ready-to-run process' => '',
        'To create a new Process you can either import a Process that was exported from another system or create a complete new one.' =>
            'To create a new Process you can either import a Process that was exported from another system or create a complete new one.',
        'Changes to the Processes here only affect the behavior of the system, if you synchronize the Process data. By synchronizing the Processes, the newly made changes will be written to the Configuration.' =>
            'Changes to the Processes here only affect the behaviour of the system, if you synchronise the Process data. By synchronising the Processes, the newly made changes will be written to the Configuration.',
        'Processes' => 'Processes',
        'Process name' => 'Process name',
        'Print' => 'Print',
        'Export Process Configuration' => 'Export Process Configuration',
        'Copy Process' => 'Copy Process',

        # Template: AdminProcessManagementActivity
        'Cancel & close' => 'Cancel & close',
        'Go Back' => 'Go Back',
        'Please note, that changing this activity will affect the following processes' =>
            'Please note, that changing this activity will affect the following processes',
        'Activity' => 'Activity',
        'Activity Name' => 'Activity Name',
        'Activity Dialogs' => 'Activity Dialogs',
        'You can assign Activity Dialogs to this Activity by dragging the elements with the mouse from the left list to the right list.' =>
            'You can assign Activity Dialogs to this Activity by dragging the elements with the mouse from the left list to the right list.',
        'Ordering the elements within the list is also possible by drag \'n\' drop.' =>
            'Ordering the elements within the list is also possible by drag \'n\' drop.',
        'Filter available Activity Dialogs' => 'Filter available Activity Dialogs',
        'Available Activity Dialogs' => 'Available Activity Dialogs',
        'Name: %s, EntityID: %s' => 'Name: %s, EntityID: %s',
        'Create New Activity Dialog' => 'Create New Activity Dialog',
        'Assigned Activity Dialogs' => 'Assigned Activity Dialogs',
        'As soon as you use this button or link, you will leave this screen and its current state will be saved automatically. Do you want to continue?' =>
            'As soon as you use this button or link, you will leave this screen and its current state will be saved automatically. Do you want to continue?',

        # Template: AdminProcessManagementActivityDialog
        'Please note that changing this activity dialog will affect the following activities' =>
            'Please note that changing this activity dialog will affect the following activities',
        'Please note that customer users will not be able to see or use the following fields: Owner, Responsible, Lock, PendingTime and CustomerID.' =>
            'Please note that customer users will not be able to see or use the following fields: Owner, Responsible, Lock, PendingTime and CustomerID.',
        'The Queue field can only be used by customers when creating a new ticket.' =>
            'The Queue field can only be used by customers when creating a new ticket.',
        'Activity Dialog' => 'Activity Dialog',
        'Activity dialog Name' => 'Activity dialog Name',
        'Available in' => 'Available in',
        'Description (short)' => 'Description (short)',
        'Description (long)' => 'Description (long)',
        'The selected permission does not exist.' => 'The selected permission does not exist.',
        'Required Lock' => 'Required Lock',
        'The selected required lock does not exist.' => 'The selected required lock does not exist.',
        'Submit Advice Text' => 'Submit Advice Text',
        'Submit Button Text' => 'Submit Button Text',
        'Fields' => 'Fields',
        'You can assign Fields to this Activity Dialog by dragging the elements with the mouse from the left list to the right list.' =>
            'You can assign Fields to this Activity Dialog by dragging the elements with the mouse from the left list to the right list.',
        'Filter available fields' => 'Filter available fields',
        'Available Fields' => 'Available Fields',
        'Name: %s' => 'Name: %s',
        'Assigned Fields' => 'Assigned Fields',
        'ArticleType' => 'ArticleType',
        'Display' => 'Display',
        'Edit Field Details' => 'Edit Field Details',
        'Customer interface does not support internal article types.' => 'Customer interface does not support internal article types.',

        # Template: AdminProcessManagementPath
        'Path' => 'Path',
        'Edit this transition' => 'Edit this transition',
        'Transition Actions' => 'Transition Actions',
        'You can assign Transition Actions to this Transition by dragging the elements with the mouse from the left list to the right list.' =>
            'You can assign Transition Actions to this Transition by dragging the elements with the mouse from the left list to the right list.',
        'Filter available Transition Actions' => 'Filter available Transition Actions',
        'Available Transition Actions' => 'Available Transition Actions',
        'Create New Transition Action' => 'Create New Transition Action',
        'Assigned Transition Actions' => 'Assigned Transition Actions',

        # Template: AdminProcessManagementProcessAccordion
        'Activities' => 'Activities',
        'Filter Activities...' => 'Filter Activities...',
        'Create New Activity' => 'Create New Activity',
        'Filter Activity Dialogs...' => 'Filter Activity Dialogs...',
        'Transitions' => 'Transitions',
        'Filter Transitions...' => 'Filter Transitions...',
        'Create New Transition' => 'Create New Transition',
        'Filter Transition Actions...' => 'Filter Transition Actions...',

        # Template: AdminProcessManagementProcessEdit
        'Edit Process' => 'Edit Process',
        'Print process information' => 'Print process information',
        'Delete Process' => 'Delete Process',
        'Delete Inactive Process' => 'Delete Inactive Process',
        'Available Process Elements' => 'Available Process Elements',
        'The Elements listed above in this sidebar can be moved to the canvas area on the right by using drag\'n\'drop.' =>
            'The Elements listed above in this sidebar can be moved to the canvas area on the right by using drag\'n\'drop.',
        'You can place Activities on the canvas area to assign this Activity to the Process.' =>
            'You can place Activities on the canvas area to assign this Activity to the Process.',
        'To assign an Activity Dialog to an Activity drop the Activity Dialog element from this sidebar over the Activity placed in the canvas area.' =>
            'To assign an Activity Dialog to an Activity drop the Activity Dialog element from this sidebar over the Activity placed in the canvas area.',
        'You can start a connection between two Activities by dropping the Transition element over the Start Activity of the connection. After that you can move the loose end of the arrow to the End Activity.' =>
            '',
        'Actions can be assigned to a Transition by dropping the Action Element onto the label of a Transition.' =>
            'Actions can be assigned to a Transition by dropping the Action Element onto the label of a Transition.',
        'Edit Process Information' => 'Edit Process Information',
        'Process Name' => 'Process Name',
        'The selected state does not exist.' => 'The selected state does not exist.',
        'Add and Edit Activities, Activity Dialogs and Transitions' => 'Add and Edit Activities, Activity Dialogs and Transitions',
        'Show EntityIDs' => 'Show EntityIDs',
        'Extend the width of the Canvas' => 'Extend the width of the Canvas',
        'Extend the height of the Canvas' => 'Extend the height of the Canvas',
        'Remove the Activity from this Process' => 'Remove the Activity from this Process',
        'Edit this Activity' => 'Edit this Activity',
        'Save Activities, Activity Dialogs and Transitions' => 'Save Activities, Activity Dialogs and Transitions',
        'Do you really want to delete this Process?' => 'Do you really want to delete this Process?',
        'Do you really want to delete this Activity?' => 'Do you really want to delete this Activity?',
        'Do you really want to delete this Activity Dialog?' => 'Do you really want to delete this Activity Dialog?',
        'Do you really want to delete this Transition?' => 'Do you really want to delete this Transition?',
        'Do you really want to delete this Transition Action?' => 'Do you really want to delete this Transition Action?',
        'Do you really want to remove this activity from the canvas? This can only be undone by leaving this screen without saving.' =>
            'Do you really want to remove this activity from the canvas? This can only be undone by leaving this screen without saving.',
        'Do you really want to remove this transition from the canvas? This can only be undone by leaving this screen without saving.' =>
            'Do you really want to remove this transition from the canvas? This can only be undone by leaving this screen without saving.',
        'Hide EntityIDs' => 'Hide EntityIDs',
        'Delete Entity' => 'Delete Entity',
        'Remove Entity from canvas' => 'Remove Entity from canvas',
        'This Activity is already used in the Process. You cannot add it twice!' =>
            'This Activity is already used in the Process. You cannot add it twice!',
        'This Activity cannot be deleted because it is the Start Activity.' =>
            'This Activity cannot be deleted because it is the Start Activity.',
        'This Transition is already used for this Activity. You cannot use it twice!' =>
            'This Transition is already used for this Activity. You cannot use it twice!',
        'This TransitionAction is already used in this Path. You cannot use it twice!' =>
            'This TransitionAction is already used in this Path. You cannot use it twice!',
        'Remove the Transition from this Process' => 'Remove the Transition from this Process',
        'No TransitionActions assigned.' => 'No TransitionActions assigned.',
        'The Start Event cannot loose the Start Transition!' => 'The Start Event cannot loose the Start Transition!',
        'No dialogs assigned yet. Just pick an activity dialog from the list on the left and drag it here.' =>
            'No dialogs assigned yet. Just pick an activity dialog from the list on the left and drag it here.',
        'An unconnected transition is already placed on the canvas. Please connect this transition first before placing another transition.' =>
            'An unconnected transition is already placed on the canvas. Please connect this transition first before placing another transition.',

        # Template: AdminProcessManagementProcessNew
        'In this screen, you can create a new process. In order to make the new process available to users, please make sure to set its state to \'Active\' and synchronize after completing your work.' =>
            'In this screen, you can create a new process. In order to make the new process available to users, please make sure to set its state to \'Active\' and synchronise after completing your work.',

        # Template: AdminProcessManagementProcessPrint
        'cancel & close' => '',
        'Start Activity' => 'Start Activity',
        'Contains %s dialog(s)' => 'Contains %s dialog(s)',
        'Assigned dialogs' => 'Assigned dialogs',
        'Activities are not being used in this process.' => 'Activities are not being used in this process.',
        'Assigned fields' => 'Assigned fields',
        'Activity dialogs are not being used in this process.' => 'Activity dialogs are not being used in this process.',
        'Condition linking' => 'Condition linking',
        'Conditions' => 'Conditions',
        'Condition' => 'Condition',
        'Transitions are not being used in this process.' => 'Transitions are not being used in this process.',
        'Module name' => 'Module name',
        'Transition actions are not being used in this process.' => 'Transition actions are not being used in this process.',

        # Template: AdminProcessManagementTransition
        'Please note that changing this transition will affect the following processes' =>
            'Please note that changing this transition will affect the following processes',
        'Transition' => 'Transition',
        'Transition Name' => 'Transition Name',
        'Conditions can only operate on non-empty fields.' => 'Conditions can only operate on non-empty fields.',
        'Type of Linking between Conditions' => 'Type of Linking between Conditions',
        'Remove this Condition' => 'Remove this Condition',
        'Type of Linking' => 'Type of Linking',
        'Add a new Field' => 'Add a new Field',
        'Remove this Field' => 'Remove this Field',
        'And can\'t be repeated on the same condition.' => 'And can\'t be repeated on the same condition.',
        'Add New Condition' => 'Add New Condition',

        # Template: AdminProcessManagementTransitionAction
        'Please note that changing this transition action will affect the following processes' =>
            'Please note that changing this transition action will affect the following processes',
        'Transition Action' => 'Transition Action',
        'Transition Action Name' => 'Transition Action Name',
        'Transition Action Module' => 'Transition Action Module',
        'Config Parameters' => 'Config Parameters',
        'Add a new Parameter' => 'Add a new Parameter',
        'Remove this Parameter' => 'Remove this Parameter',

        # Template: AdminQueue
        'Manage Queues' => 'Manage Queues',
        'Add queue' => 'Add queue',
        'Add Queue' => 'Add Queue',
        'Edit Queue' => 'Edit Queue',
        'A queue with this name already exists!' => 'A queue with this name already exists!',
        'Sub-queue of' => 'Sub-queue of',
        'Unlock timeout' => 'Unlock timeout',
        '0 = no unlock' => '0 = no unlock',
        'Only business hours are counted.' => 'Only business hours are counted.',
        'If an agent locks a ticket and does not close it before the unlock timeout has passed, the ticket will unlock and will become available for other agents.' =>
            'If an agent locks a ticket and does not close it before the unlock timeout has passed, the ticket will unlock and will become available for other agents.',
        'Notify by' => 'Notify by',
        '0 = no escalation' => '0 = no escalation',
        'If there is not added a customer contact, either email-external or phone, to a new ticket before the time defined here expires, the ticket is escalated.' =>
            'If there is not added a customer contact, either email-external or phone, to a new ticket before the time defined here expires, the ticket is escalated.',
        'If there is an article added, such as a follow-up via email or the customer portal, the escalation update time is reset. If there is no customer contact, either email-external or phone, added to a ticket before the time defined here expires, the ticket is escalated.' =>
            'If there is an article added, such as a follow-up via email or the customer portal, the escalation update time is reset. If there is no customer contact, either email-external or phone, added to a ticket before the time defined here expires, the ticket is escalated.',
        'If the ticket is not set to closed before the time defined here expires, the ticket is escalated.' =>
            'If the ticket is not set to closed before the time defined here expires, the ticket is escalated.',
        'Follow up Option' => 'Follow up Option',
        'Specifies if follow up to closed tickets would re-open the ticket, be rejected or lead to a new ticket.' =>
            'Specifies if follow up to closed tickets would re-open the ticket, be rejected or lead to a new ticket.',
        'Ticket lock after a follow up' => 'Ticket lock after a follow up',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked to the old owner.' =>
            'If a ticket is closed and the customer sends a follow up the ticket will be locked to the old owner.',
        'System address' => 'System address',
        'Will be the sender address of this queue for email answers.' => 'Will be the sender address of this queue for email answers.',
        'Default sign key' => 'Default sign key',
        'The salutation for email answers.' => 'The salutation for email answers.',
        'The signature for email answers.' => 'The signature for email answers.',

        # Template: AdminQueueAutoResponse
        'Manage Queue-Auto Response Relations' => 'Manage Queue-Auto Response Relations',
        'This filter allow you to show queues without auto responses' => 'This filter allow you to show queues without auto responses',
        'Queues without auto responses' => 'Queues without auto responses',
        'This filter allow you to show all queues' => 'This filter allow you to show all queues',
        'Show all queues' => 'Show all queues',
        'Filter for Queues' => 'Filter for Queues',
        'Filter for Auto Responses' => 'Filter for Auto Responses',
        'Auto Responses' => 'Auto Responses',
        'Change Auto Response Relations for Queue' => 'Change Auto Response Relations for Queue',

        # Template: AdminQueueTemplates
        'Manage Template-Queue Relations' => 'Manage Template-Queue Relations',
        'Filter for Templates' => 'Filter for Templates',
        'Templates' => 'Templates',
        'Change Queue Relations for Template' => 'Change Queue Relations for Template',
        'Change Template Relations for Queue' => 'Change Template Relations for Queue',

        # Template: AdminRegistration
        'System Registration Management' => 'System Registration Management',
        'Edit details' => 'Edit details',
        'Show transmitted data' => 'Show transmitted data',
        'Deregister system' => 'Deregister system',
        'Overview of registered systems' => 'Overview of registered systems',
        'This system is registered with OTRS Group.' => 'This system is registered with OTRS Group.',
        'System type' => 'System type',
        'Unique ID' => 'Unique ID',
        'Last communication with registration server' => 'Last communication with registration server',
        'System registration not possible' => 'System registration not possible',
        'Please note that you can\'t register your system if OTRS Daemon is not running correctly!' =>
            'Please note that you can\'t register your system if OTRS Daemon is not running correctly!',
        'Instructions' => 'Instructions',
        'System deregistration not possible' => 'System deregistration not possible',
        'Please note that you can\'t deregister your system if you\'re using the %s or having a valid service contract.' =>
            'Please note that you can\'t deregister your system if you\'re using the %s or having a valid service contract.',
        'OTRS-ID Login' => 'OTRS-ID Login',
        'Read more' => 'Read more',
        'You need to log in with your OTRS-ID to register your system.' =>
            'You need to log in with your OTRS-ID to register your system.',
        'Your OTRS-ID is the email address you used to sign up on the OTRS.com webpage.' =>
            'Your OTRS-ID is the email address you used to sign up on the OTRS.com webpage.',
        'Data Protection' => 'Data Protection',
        'What are the advantages of system registration?' => 'What are the advantages of system registration?',
        'You will receive updates about relevant security releases.' => 'You will receive updates about relevant security releases.',
        'With your system registration we can improve our services for you, because we have all relevant information available.' =>
            'With your system registration we can improve our services for you, because we have all relevant information available.',
        'This is only the beginning!' => 'This is only the beginning!',
        'We will inform you about our new services and offerings soon.' =>
            'We will inform you about our new services and offerings soon.',
        'Can I use OTRS without being registered?' => 'Can I use OTRS without being registered?',
        'System registration is optional.' => 'System registration is optional.',
        'You can download and use OTRS without being registered.' => 'You can download and use OTRS without being registered.',
        'Is it possible to deregister?' => 'Is it possible to deregister?',
        'You can deregister at any time.' => 'You can deregister at any time.',
        'Which data is transfered when registering?' => 'Which data is transfered when registering?',
        'A registered system sends the following data to OTRS Group:' => 'A registered system sends the following data to OTRS Group:',
        'Fully Qualified Domain Name (FQDN), OTRS version, Database, Operating System and Perl version.' =>
            'Fully Qualified Domain Name (FQDN), OTRS version, Database, Operating System and Perl version.',
        'Why do I have to provide a description for my system?' => 'Why do I have to provide a description for my system?',
        'The description of the system is optional.' => 'The description of the system is optional.',
        'The description and system type you specify help you to identify and manage the details of your registered systems.' =>
            'The description and system type you specify help you to identify and manage the details of your registered systems.',
        'How often does my OTRS system send updates?' => 'How often does my OTRS system send updates?',
        'Your system will send updates to the registration server at regular intervals.' =>
            'Your system will send updates to the registration server at regular intervals.',
        'Typically this would be around once every three days.' => 'Typically this would be around once every three days.',
        'Please visit our' => 'Please visit our',
        'If you deregister your system, you will lose these benefits:' =>
            'If you deregister your system, you will lose these benefits:',
        'You need to log in with your OTRS-ID to deregister your system.' =>
            'You need to log in with your OTRS-ID to deregister your system.',
        'OTRS-ID' => 'OTRS-ID',
        'You don\'t have an OTRS-ID yet?' => 'You don\'t have an OTRS-ID yet?',
        'Sign up now' => 'Sign up now',
        'Forgot your password?' => 'Forgot your password?',
        'Retrieve a new one' => 'Retrieve a new one',
        'This data will be frequently transferred to OTRS Group when you register this system.' =>
            'This data will be frequently transferred to OTRS Group when you register this system.',
        'Attribute' => 'Attribute',
        'FQDN' => 'FQDN',
        'OTRS Version' => 'OTRS Version',
        'Operating System' => 'Operating System',
        'Perl Version' => 'Perl Version',
        'Optional description of this system.' => 'Optional description of this system.',
        'Register' => 'Register',
        'Deregister System' => 'Deregister System',
        'Continuing with this step will deregister the system from OTRS Group.' =>
            'Continuing with this step will deregister the system from OTRS Group.',
        'Deregister' => 'Deregister',
        'You can modify registration settings here.' => 'You can modify registration settings here.',
        'Overview of transmitted data' => 'Overview of transmitted data',
        'There is no data regularly sent from your system to %s.' => 'There is no data regularly sent from your system to %s.',
        'The following data is sent at minimum every 3 days from your system to %s.' =>
            'The following data is sent at minimum every 3 days from your system to %s.',
        'The data will be transferred in JSON format via a secure https connection.' =>
            'The data will be transferred in JSON format via a secure https connection.',
        'System Registration Data' => 'System Registration Data',
        'Support Data' => 'Support Data',

        # Template: AdminRole
        'Role Management' => 'Role Management',
        'Add role' => 'Add role',
        'Create a role and put groups in it. Then add the role to the users.' =>
            'Create a role and put groups in it. Then add the role to the users.',
        'There are no roles defined. Please use the \'Add\' button to create a new role.' =>
            'There are no roles defined. Please use the \'Add\' button to create a new role.',
        'Add Role' => 'Add Role',
        'Edit Role' => 'Edit Role',

        # Template: AdminRoleGroup
        'Manage Role-Group Relations' => 'Manage Role-Group Relations',
        'Filter for Roles' => 'Filter for Roles',
        'Roles' => 'Roles',
        'Select the role:group permissions.' => 'Select the role:group permissions.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the role).' =>
            'If nothing is selected, then there are no permissions in this group (tickets will not be available for the role).',
        'Change Role Relations for Group' => 'Change Role Relations for Group',
        'Change Group Relations for Role' => 'Change Group Relations for Role',
        'Toggle %s permission for all' => 'Toggle %s permission for all',
        'move_into' => 'move_into',
        'Permissions to move tickets into this group/queue.' => 'Permissions to move tickets into this group/queue.',
        'create' => 'create',
        'Permissions to create tickets in this group/queue.' => 'Permissions to create tickets in this group/queue.',
        'note' => 'note',
        'Permissions to add notes to tickets in this group/queue.' => 'Permissions to add notes to tickets in this group/queue.',
        'owner' => 'owner',
        'Permissions to change the owner of tickets in this group/queue.' =>
            'Permissions to change the owner of tickets in this group/queue.',
        'priority' => 'priority',
        'Permissions to change the ticket priority in this group/queue.' =>
            'Permissions to change the ticket priority in this group/queue.',

        # Template: AdminRoleUser
        'Manage Agent-Role Relations' => 'Manage Agent-Role Relations',
        'Add agent' => 'Add agent',
        'Filter for Agents' => 'Filter for Agents',
        'Agents' => 'Agents',
        'Manage Role-Agent Relations' => 'Manage Role-Agent Relations',
        'Change Role Relations for Agent' => 'Change Role Relations for Agent',
        'Change Agent Relations for Role' => 'Change Agent Relations for Role',

        # Template: AdminSLA
        'SLA Management' => 'SLA Management',
        'Add SLA' => 'Add SLA',
        'Edit SLA' => 'Edit SLA',
        'Please write only numbers!' => 'Please write only numbers!',

        # Template: AdminSMIME
        'S/MIME Management' => 'S/MIME Management',
        'SMIME support is disabled' => 'SMIME support is disabled',
        'To be able to use SMIME in OTRS, you have to enable it first.' =>
            'To be able to use SMIME in OTRS, you have to enable it first.',
        'Enable SMIME support' => 'Enable SMIME support',
        'Faulty SMIME configuration' => 'Faulty SMIME configuration',
        'SMIME support is enabled, but the relevant configuration contains errors. Please check the configuration using the button below.' =>
            'SMIME support is enabled, but the relevant configuration contains errors. Please check the configuration using the button below.',
        'Check SMIME configuration' => 'Check SMIME configuration',
        'Add certificate' => 'Add certificate',
        'Add private key' => 'Add private key',
        'Filter for certificates' => 'Filter for certificates',
        'Filter for S/MIME certs' => 'Filter for S/MIME certs',
        'To show certificate details click on a certificate icon.' => 'To show certificate details click on a certificate icon.',
        'To manage private certificate relations click on a private key icon.' =>
            'To manage private certificate relations click on a private key icon.',
        'Here you can add relations to your private certificate, these will be embedded to the S/MIME signature every time you use this certificate to sign an email.' =>
            'Here you can add relations to your private certificate, these will be embedded to the S/MIME signature every time you use this certificate to sign an email.',
        'See also' => 'See also',
        'In this way you can directly edit the certification and private keys in file system.' =>
            'In this way you can directly edit the certification and private keys in file system.',
        'Hash' => 'Hash',
        'Handle related certificates' => 'Handle related certificates',
        'Read certificate' => 'Read certificate',
        'Delete this certificate' => 'Delete this certificate',
        'Add Certificate' => 'Add Certificate',
        'Add Private Key' => 'Add Private Key',
        'Secret' => 'Secret',
        'Related Certificates for' => 'Related Certificates for',
        'Delete this relation' => 'Delete this relation',
        'Available Certificates' => 'Available Certificates',
        'Relate this certificate' => 'Relate this certificate',

        # Template: AdminSMIMECertRead
        'Close dialog' => 'Close dialog',
        'Certificate details' => 'Certificate details',

        # Template: AdminSalutation
        'Salutation Management' => 'Salutation Management',
        'Add salutation' => 'Add salutation',
        'Add Salutation' => 'Add Salutation',
        'Edit Salutation' => 'Edit Salutation',
        'e. g.' => 'e. g.',
        'Example salutation' => 'Example salutation',

        # Template: AdminSecureMode
        'Secure mode needs to be enabled!' => 'Secure mode needs to be enabled!',
        'Secure mode will (normally) be set after the initial installation is completed.' =>
            'Secure mode will (normally) be set after the initial installation is completed.',
        'If secure mode is not activated, activate it via SysConfig because your application is already running.' =>
            'If secure mode is not activated, activate it via SysConfig because your application is already running.',

        # Template: AdminSelectBox
        'SQL Box' => 'SQL Box',
        'Here you can enter SQL to send it directly to the application database. It is not possible to change the content of the tables, only select queries are allowed.' =>
            'Here you can enter SQL to send it directly to the application database. It is not possible to change the content of the tables, only select queries are allowed.',
        'Here you can enter SQL to send it directly to the application database.' =>
            'Here you can enter SQL to send it directly to the application database.',
        'Only select queries are allowed.' => 'Only select queries are allowed.',
        'The syntax of your SQL query has a mistake. Please check it.' =>
            'The syntax of your SQL query has a mistake. Please check it.',
        'There is at least one parameter missing for the binding. Please check it.' =>
            'There is at least one parameter missing for the binding. Please check it.',
        'Result format' => 'Result format',
        'Run Query' => 'Run Query',
        'Query is executed.' => 'Query is executed.',

        # Template: AdminService
        'Service Management' => 'Service Management',
        'Add service' => 'Add service',
        'Add Service' => 'Add Service',
        'Edit Service' => 'Edit Service',
        'Sub-service of' => 'Sub-service of',

        # Template: AdminSession
        'Session Management' => 'Session Management',
        'All sessions' => 'All sessions',
        'Agent sessions' => 'Agent sessions',
        'Customer sessions' => 'Customer sessions',
        'Unique agents' => 'Unique agents',
        'Unique customers' => 'Unique customers',
        'Kill all sessions' => 'Kill all sessions',
        'Kill this session' => 'Kill this session',
        'Session' => 'Session',
        'Kill' => 'Kill',
        'Detail View for SessionID' => 'Detail View for SessionID',

        # Template: AdminSignature
        'Signature Management' => 'Signature Management',
        'Add signature' => 'Add signature',
        'Add Signature' => 'Add Signature',
        'Edit Signature' => 'Edit Signature',
        'Example signature' => 'Example signature',

        # Template: AdminState
        'State Management' => 'State Management',
        'Add state' => 'Add state',
        'Please also update the states in SysConfig where needed.' => 'Please also update the states in SysConfig where needed.',
        'Add State' => 'Add State',
        'Edit State' => 'Edit State',
        'State type' => 'State type',

        # Template: AdminSupportDataCollector
        'Sending support data to OTRS Group is not possible!' => 'Sending support data to OTRS Group is not possible!',
        'Enable Cloud Services' => 'Enable Cloud Services',
        'This data is sent to OTRS Group on a regular basis. To stop sending this data please update your system registration.' =>
            'This data is sent to OTRS Group on a regular basis. To stop sending this data please update your system registration.',
        'You can manually trigger the Support Data sending by pressing this button:' =>
            'You can manually trigger the Support Data sending by pressing this button:',
        'Send Update' => 'Send Update',
        'Sending Update...' => 'Sending Update...',
        'Support Data information was successfully sent.' => 'Support Data information was successfully sent.',
        'Was not possible to send Support Data information.' => 'Was not possible to send Support Data information.',
        'Update Result' => 'Update Result',
        'Currently this data is only shown in this system.' => 'Currently this data is only shown in this system.',
        'A support bundle (including: system registration information, support data, a list of installed packages and all locally modified source code files) can be generated by pressing this button:' =>
            'A support bundle (including: system registration information, support data, a list of installed packages and all locally modified source code files) can be generated by pressing this button:',
        'Generate Support Bundle' => 'Generate Support Bundle',
        'Generating...' => 'Generating...',
        'It was not possible to generate the Support Bundle.' => 'It was not possible to generate the Support Bundle.',
        'Generate Result' => 'Generate Result',
        'Support Bundle' => 'Support Bundle',
        'The mail could not be sent' => 'The mail could not be sent',
        'The support bundle has been generated.' => 'The support bundle has been generated.',
        'Please choose one of the following options.' => 'Please choose one of the following options.',
        'Send by Email' => 'Send by Email',
        'The support bundle is too large to send it by email, this option has been disabled.' =>
            'The support bundle is too large to send it by email, this option has been disabled.',
        'The email address for this user is invalid, this option has been disabled.' =>
            'The email address for this user is invalid, this option has been disabled.',
        'Sending' => 'Sending',
        'The support bundle will be sent to OTRS Group via email automatically.' =>
            'The support bundle will be sent to OTRS Group via email automatically.',
        'Download File' => 'Download File',
        'A file containing the support bundle will be downloaded to the local system. Please save the file and send it to the OTRS Group, using an alternate method.' =>
            'A file containing the support bundle will be downloaded to the local system. Please save the file and send it to the OTRS Group, using an alternate method.',
        'Error: Support data could not be collected (%s).' => 'Error: Support data could not be collected (%s).',
        'Details' => 'Details',

        # Template: AdminSysConfig
        'SysConfig' => 'SysConfig',
        'Navigate by searching in %s settings' => 'Navigate by searching in %s settings',
        'Navigate by selecting config groups' => 'Navigate by selecting config groups',
        'Download all system config changes' => 'Download all system config changes',
        'Export settings' => 'Export settings',
        'Load SysConfig settings from file' => 'Load SysConfig settings from file',
        'Import settings' => 'Import settings',
        'Import Settings' => 'Import Settings',
        'Please enter a search term to look for settings.' => 'Please enter a search term to look for settings.',
        'Subgroup' => 'Subgroup',
        'Elements' => 'Elements',

        # Template: AdminSysConfigEdit
        'Edit Config Settings in %s → %s' => 'Edit Config Settings in %s → %s',
        'This setting is read only.' => 'This setting is read only.',
        'This config item is only available in a higher config level!' =>
            'This config item is only available in a higher config level!',
        'Reset this setting' => 'Reset this setting',
        'Error: this file could not be found.' => 'Error: this file could not be found.',
        'Error: this directory could not be found.' => 'Error: this directory could not be found.',
        'Error: an invalid value was entered.' => 'Error: an invalid value was entered.',
        'Content' => 'Content',
        'Remove this entry' => 'Remove this entry',
        'Add entry' => 'Add entry',
        'Remove entry' => 'Remove entry',
        'Add new entry' => 'Add new entry',
        'Delete this entry' => 'Delete this entry',
        'Create new entry' => 'Create new entry',
        'New group' => 'New group',
        'Group ro' => 'Group ro',
        'Readonly group' => 'Readonly group',
        'New group ro' => 'New group ro',
        'Loader' => 'Loader',
        'File to load for this frontend module' => 'File to load for this frontend module',
        'New Loader File' => 'New Loader File',
        'NavBarName' => 'NavBarName',
        'NavBar' => 'NavBar',
        'LinkOption' => 'LinkOption',
        'Block' => 'Block',
        'AccessKey' => 'AccessKey',
        'Add NavBar entry' => 'Add NavBar entry',
        'NavBar module' => 'NavBar module',
        'Year' => 'Year',
        'Month' => 'Month',
        'Day' => 'Day',
        'Invalid year' => 'Invalid year',
        'Invalid month' => 'Invalid month',
        'Invalid day' => 'Invalid day',
        'Show more' => 'Show more',

        # Template: AdminSystemAddress
        'System Email Addresses Management' => 'System Email Addresses Management',
        'Add system address' => 'Add system address',
        'All incoming email with this address in To or Cc will be dispatched to the selected queue.' =>
            'All incoming email with this address in To or Cc will be dispatched to the selected queue.',
        'Email address' => 'Email address',
        'Display name' => 'Display name',
        'Add System Email Address' => 'Add System Email Address',
        'Edit System Email Address' => 'Edit System Email Address',
        'The display name and email address will be shown on mail you send.' =>
            'The display name and email address will be shown on mail you send.',

        # Template: AdminSystemMaintenance
        'System Maintenance Management' => 'System Maintenance Management',
        'Schedule New System Maintenance' => 'Schedule New System Maintenance',
        'Schedule a system maintenance period for announcing the Agents and Customers the system is down for a time period.' =>
            'Schedule a system maintenance period for announcing the Agents and Customers the system is down for a time period.',
        'Some time before this system maintenance starts the users will receive a notification on each screen announcing about this fact.' =>
            'Some time before this system maintenance starts the users will receive a notification on each screen announcing about this fact.',
        'Start date' => 'Start date',
        'Stop date' => 'Stop date',
        'Delete System Maintenance' => 'Delete System Maintenance',
        'Do you really want to delete this scheduled system maintenance?' =>
            'Do you really want to delete this scheduled system maintenance?',

        # Template: AdminSystemMaintenanceEdit
        'Edit System Maintenance %s' => 'Edit System Maintenance %s',
        'Edit System Maintenance Information' => '',
        'Date invalid!' => 'Date invalid!',
        'Login message' => 'Login message',
        'Show login message' => 'Show login message',
        'Notify message' => 'Notify message',
        'Manage Sessions' => 'Manage Sessions',
        'All Sessions' => 'All Sessions',
        'Agent Sessions' => 'Agent Sessions',
        'Customer Sessions' => 'Customer Sessions',
        'Kill all Sessions, except for your own' => 'Kill all Sessions, except for your own',

        # Template: AdminTemplate
        'Manage Templates' => 'Manage Templates',
        'Add template' => 'Add template',
        'A template is a default text which helps your agents to write faster tickets, answers or forwards.' =>
            'A template is a default text which helps your agents to write faster tickets, answers or forwards.',
        'Don\'t forget to add new templates to queues.' => 'Don\'t forget to add new templates to queues.',
        'Do you really want to delete this template?' => 'Do you really want to delete this template?',
        'Add Template' => 'Add Template',
        'Edit Template' => 'Edit Template',
        'A standard template with this name already exists!' => 'A standard template with this name already exists!',
        'Create type templates only supports this smart tags' => 'Create type templates only supports this smart tags',
        'Example template' => 'Example template',
        'The current ticket state is' => 'The current ticket state is',
        'Your email address is' => 'Your email address is',

        # Template: AdminTemplateAttachment
        'Manage Templates <-> Attachments Relations' => 'Manage Templates <-> Attachments Relations',
        'Filter for Attachments' => 'Filter for Attachments',
        'Change Template Relations for Attachment' => 'Change Template Relations for Attachment',
        'Change Attachment Relations for Template' => 'Change Attachment Relations for Template',
        'Toggle active for all' => 'Toggle active for all',
        'Link %s to selected %s' => 'Link %s to selected %s',

        # Template: AdminType
        'Type Management' => 'Type Management',
        'Add ticket type' => 'Add ticket type',
        'Add Type' => 'Add Type',
        'Edit Type' => 'Edit Type',
        'A type with this name already exists!' => 'A type with this name already exists!',

        # Template: AdminUser
        'Agents will be needed to handle tickets.' => 'Agents will be needed to handle tickets.',
        'Don\'t forget to add a new agent to groups and/or roles!' => 'Don\'t forget to add a new agent to groups and/or roles!',
        'Please enter a search term to look for agents.' => 'Please enter a search term to look for agents.',
        'Last login' => 'Last login',
        'Switch to agent' => 'Switch to agent',
        'Add Agent' => 'Add Agent',
        'Edit Agent' => 'Edit Agent',
        'Title or salutation' => 'Title or salutation',
        'Firstname' => 'Firstname',
        'Lastname' => 'Lastname',
        'A user with this username already exists!' => 'A user with this username already exists!',
        'Will be auto-generated if left empty.' => 'Will be auto-generated if left empty.',
        'Start' => 'Start',
        'End' => 'End',

        # Template: AdminUserGroup
        'Manage Agent-Group Relations' => 'Manage Agent-Group Relations',
        'Change Group Relations for Agent' => 'Change Group Relations for Agent',
        'Change Agent Relations for Group' => 'Change Agent Relations for Group',

        # Template: AgentBook
        'Address Book' => 'Address Book',
        'Search for a customer' => 'Search for a customer',
        'Add email address %s to the To field' => 'Add email address %s to the To field',
        'Add email address %s to the Cc field' => 'Add email address %s to the Cc field',
        'Add email address %s to the Bcc field' => 'Add email address %s to the Bcc field',
        'Apply' => 'Apply',

        # Template: AgentCustomerInformationCenter
        'Customer Information Center' => 'Customer Information Center',

        # Template: AgentCustomerInformationCenterSearch
        'Customer User' => 'Customer User',

        # Template: AgentCustomerSearch
        'Duplicated entry' => 'Duplicated entry',
        'This address already exists on the address list.' => 'This address already exists on the address list.',
        'It is going to be deleted from the field, please try again.' => 'It is going to be deleted from the field, please try again.',

        # Template: AgentCustomerTableView
        'Note: Customer is invalid!' => 'Note: Customer is invalid!',
        'Start chat' => 'Start chat',
        'Video call' => '',
        'Audio call' => '',

        # Template: AgentDaemonInfo
        'The OTRS Daemon is a daemon process that performs asynchronous tasks, e.g. ticket escalation triggering, email sending, etc.' =>
            'The OTRS Daemon is a daemon process that performs asynchronous tasks, e.g. ticket escalation triggering, email sending, etc.',
        'A running OTRS Daemon is mandatory for correct system operation.' =>
            'A running OTRS Daemon is mandatory for correct system operation.',
        'Starting the OTRS Daemon' => 'Starting the OTRS Daemon',
        'Make sure that the file \'%s\' exists (without .dist extension). This cron job will check every 5 minutes if the OTRS Daemon is running and start it if needed.' =>
            'Make sure that the file \'%s\' exists (without .dist extension). This cron job will check every 5 minutes if the OTRS Daemon is running and start it if needed.',
        'Execute \'%s start\' to make sure the cron jobs of the \'otrs\' user are active.' =>
            'Execute \'%s start\' to make sure the cron jobs of the \'otrs\' user are active.',
        'After 5 minutes, check that the OTRS Daemon is running in the system (\'bin/otrs.Daemon.pl status\').' =>
            'After 5 minutes, check that the OTRS Daemon is running in the system (\'bin/otrs.Daemon.pl status\').',

        # Template: AgentDashboard
        'Dashboard' => 'Dashboard',

        # Template: AgentDashboardCalendarOverview
        'in' => 'in',

        # Template: AgentDashboardCommon
        'Close this widget' => 'Close this widget',
        'Available Columns' => 'Available Columns',
        'Visible Columns (order by drag & drop)' => 'Visible Columns (order by drag & drop)',

        # Template: AgentDashboardCustomerIDStatus
        'Escalated tickets' => 'Escalated tickets',

        # Template: AgentDashboardCustomerUserList
        'Customer login' => 'Customer login',
        'Customer information' => 'Customer information',
        'Phone ticket' => 'Phone ticket',
        'Email ticket' => 'Email ticket',
        '%s open ticket(s) of %s' => '%s open ticket(s) of %s',
        '%s closed ticket(s) of %s' => '%s closed ticket(s) of %s',
        'New phone ticket from %s' => 'New phone ticket from %s',
        'New email ticket to %s' => 'New email ticket to %s',

        # Template: AgentDashboardProductNotify
        '%s %s is available!' => '%s %s is available!',
        'Please update now.' => 'Please update now.',
        'Release Note' => 'Release Note',
        'Level' => 'Level',

        # Template: AgentDashboardRSSOverview
        'Posted %s ago.' => 'Posted %s ago.',

        # Template: AgentDashboardStats
        'The configuration for this statistic widget contains errors, please review your settings.' =>
            'The configuration for this statistic widget contains errors, please review your settings.',
        'Download as SVG file' => 'Download as SVG file',
        'Download as PNG file' => 'Download as PNG file',
        'Download as CSV file' => 'Download as CSV file',
        'Download as Excel file' => 'Download as Excel file',
        'Download as PDF file' => 'Download as PDF file',
        'Grouped' => 'Grouped',
        'Stacked' => 'Stacked',
        'Expanded' => 'Expanded',
        'Stream' => 'Stream',
        'No Data Available.' => '',
        'Please select a valid graph output format in the configuration of this widget.' =>
            'Please select a valid graph output format in the configuration of this widget.',
        'The content of this statistic is being prepared for you, please be patient.' =>
            'The content of this statistic is being prepared for you, please be patient.',
        'This statistic can currently not be used because its configuration needs to be corrected by the statistics administrator.' =>
            'This statistic can currently not be used because its configuration needs to be corrected by the statistics administrator.',

        # Template: AgentDashboardTicketGeneric
        'My locked tickets' => 'My locked tickets',
        'My watched tickets' => 'My watched tickets',
        'My responsibilities' => 'My responsibilities',
        'Tickets in My Queues' => 'Tickets in My Queues',
        'Tickets in My Services' => 'Tickets in My Services',
        'Service Time' => 'Service Time',
        'Remove active filters for this widget.' => 'Remove active filters for this widget.',

        # Template: AgentDashboardTicketQueueOverview
        'Totals' => 'Totals',

        # Template: AgentDashboardUserOnline
        'out of office' => 'out of office',

        # Template: AgentDashboardUserOutOfOffice
        'until' => 'until',

        # Template: AgentHTMLReferencePageLayout
        'The ticket has been locked' => 'The ticket has been locked',
        'Undo & close' => 'Undo & close',

        # Template: AgentInfo
        'Info' => 'Info',
        'To accept some news, a license or some changes.' => 'To accept some news, a license or some changes.',

        # Template: AgentLinkObject
        'Link Object: %s' => 'Link Object: %s',
        'go to link delete screen' => 'go to link delete screen',
        'Select Target Object' => 'Select Target Object',
        'Link object %s with' => 'Link object %s with',
        'Unlink Object: %s' => 'Unlink Object: %s',
        'go to link add screen' => 'go to link add screen',

        # Template: AgentOTRSBusinessBlockScreen
        'Unauthorized usage of %s detected' => '',
        'If you decide to downgrade to OTRS Free, you will lose all database tables and data related to %s.' =>
            '',

        # Template: AgentPreferences
        'Edit your preferences' => 'Edit your preferences',
        'Did you know? You can help translating OTRS at %s.' => 'Did you know? You can help translating OTRS at %s.',

        # Template: AgentSpelling
        'Spell Checker' => 'Spell Checker',
        'spelling error(s)' => 'spelling error(s)',
        'Apply these changes' => 'Apply these changes',

        # Template: AgentStatisticsAdd
        'Statistics » Add' => 'Statistics » Add',
        'Add New Statistic' => 'Add New Statistic',
        'Dynamic Matrix' => 'Dynamic Matrix',
        'Tabular reporting data where each cell contains a singular data point (e. g. the number of tickets).' =>
            'Tabular reporting data where each cell contains a singular data point (e. g. the number of tickets).',
        'Dynamic List' => 'Dynamic List',
        'Tabular reporting data where each row contains data of one entity (e. g. a ticket).' =>
            'Tabular reporting data where each row contains data of one entity (e. g. a ticket).',
        'Static' => 'Static',
        'Complex statistics that cannot be configured and may return non-tabular data.' =>
            'Complex statistics that cannot be configured and may return non-tabular data.',
        'General Specification' => 'General Specification',
        'Create Statistic' => 'Create Statistic',

        # Template: AgentStatisticsEdit
        'Statistics » Edit %s%s — %s' => 'Statistics » Edit %s%s — %s',
        'Run now' => 'Run now',
        'Statistics Preview' => 'Statistics Preview',
        'Save statistic' => 'Save statistic',

        # Template: AgentStatisticsImport
        'Statistics » Import' => 'Statistics » Import',
        'Import Statistic Configuration' => 'Import Statistic Configuration',

        # Template: AgentStatisticsOverview
        'Statistics » Overview' => 'Statistics » Overview',
        'Statistics' => 'Statistics',
        'Run' => 'Run',
        'Edit statistic "%s".' => 'Edit statistic "%s".',
        'Export statistic "%s"' => 'Export statistic "%s"',
        'Export statistic %s' => 'Export statistic %s',
        'Delete statistic "%s"' => 'Delete statistic "%s"',
        'Delete statistic %s' => 'Delete statistic %s',
        'Do you really want to delete this statistic?' => 'Do you really want to delete this statistic?',

        # Template: AgentStatisticsView
        'Statistics » View %s%s — %s' => 'Statistics » View %s%s — %s',
        'Statistic Information' => 'Statistic Information',
        'Sum rows' => 'Sum rows',
        'Sum columns' => 'Sum columns',
        'Show as dashboard widget' => 'Show as dashboard widget',
        'Cache' => 'Cache',
        'This statistic contains configuration errors and can currently not be used.' =>
            'This statistic contains configuration errors and can currently not be used.',

        # Template: AgentTicketActionCommon
        'Change Free Text of %s%s%s' => 'Change Free Text of %s%s%s',
        'Change Owner of %s%s%s' => 'Change Owner of %s%s%s',
        'Close %s%s%s' => 'Close %s%s%s',
        'Add Note to %s%s%s' => 'Add Note to %s%s%s',
        'Set Pending Time for %s%s%s' => 'Set Pending Time for %s%s%s',
        'Change Priority of %s%s%s' => 'Change Priority of %s%s%s',
        'Change Responsible of %s%s%s' => 'Change Responsible of %s%s%s',
        'All fields marked with an asterisk (*) are mandatory.' => 'All fields marked with an asterisk (*) are mandatory.',
        'Service invalid.' => 'Service invalid.',
        'New Owner' => 'New Owner',
        'Please set a new owner!' => 'Please set a new owner!',
        'New Responsible' => 'New Responsible',
        'Next state' => 'Next state',
        'For all pending* states.' => 'For all pending* states.',
        'Add Article' => 'Add Article',
        'Create an Article' => 'Create an Article',
        'Inform agents' => 'Inform agents',
        'Inform involved agents' => 'Inform involved agents',
        'Here you can select additional agents which should receive a notification regarding the new article.' =>
            'Here you can select additional agents which should receive a notification regarding the new article.',
        'Text will also be received by' => 'Text will also be received by',
        'Spell check' => 'Spell check',
        'Text Template' => 'Text Template',
        'Setting a template will overwrite any text or attachment.' => 'Setting a template will overwrite any text or attachment.',
        'Note type' => 'Note type',

        # Template: AgentTicketBounce
        'Bounce %s%s%s' => 'Bounce %s%s%s',
        'Bounce to' => 'Bounce to',
        'You need a email address.' => 'You need a email address.',
        'Need a valid email address or don\'t use a local email address.' =>
            'Need a valid email address or don\'t use a local email address.',
        'Next ticket state' => 'Next ticket state',
        'Inform sender' => 'Inform sender',
        'Send mail' => 'Send mail',

        # Template: AgentTicketBulk
        'Ticket Bulk Action' => 'Ticket Bulk Action',
        'Send Email' => 'Send Email',
        'Merge to' => 'Merge to',
        'Invalid ticket identifier!' => 'Invalid ticket identifier!',
        'Merge to oldest' => 'Merge to oldest',
        'Link together' => 'Link together',
        'Link to parent' => 'Link to parent',
        'Unlock tickets' => 'Unlock tickets',
        'Execute Bulk Action' => 'Execute Bulk Action',

        # Template: AgentTicketCompose
        'Compose Answer for %s%s%s' => 'Compose Answer for %s%s%s',
        'This address is registered as system address and cannot be used: %s' =>
            'This address is registered as system address and cannot be used: %s',
        'Please include at least one recipient' => 'Please include at least one recipient',
        'Remove Ticket Customer' => 'Remove Ticket Customer',
        'Please remove this entry and enter a new one with the correct value.' =>
            'Please remove this entry and enter a new one with the correct value.',
        'Remove Cc' => 'Remove Cc',
        'Remove Bcc' => 'Remove Bcc',
        'Address book' => 'Address book',
        'Date Invalid!' => 'Date Invalid!',

        # Template: AgentTicketCustomer
        'Change Customer of %s%s%s' => 'Change Customer of %s%s%s',

        # Template: AgentTicketEmail
        'Create New Email Ticket' => 'Create New Email Ticket',
        'Example Template' => 'Example Template',
        'From queue' => 'From queue',
        'To customer user' => 'To customer user',
        'Please include at least one customer user for the ticket.' => 'Please include at least one customer user for the ticket.',
        'Select this customer as the main customer.' => 'Select this customer as the main customer.',
        'Remove Ticket Customer User' => 'Remove Ticket Customer User',
        'Get all' => 'Get all',

        # Template: AgentTicketEmailOutbound
        'Outbound Email for %s%s%s' => 'Outbound Email for %s%s%s',

        # Template: AgentTicketEscalation
        'Ticket %s: first response time is over (%s/%s)!' => 'Ticket %s: first response time is over (%s/%s)!',
        'Ticket %s: first response time will be over in %s/%s!' => 'Ticket %s: first response time will be over in %s/%s!',
        'Ticket %s: update time is over (%s/%s)!' => 'Ticket %s: update time is over (%s/%s)!',
        'Ticket %s: update time will be over in %s/%s!' => 'Ticket %s: update time will be over in %s/%s!',
        'Ticket %s: solution time is over (%s/%s)!' => 'Ticket %s: solution time is over (%s/%s)!',
        'Ticket %s: solution time will be over in %s/%s!' => 'Ticket %s: solution time will be over in %s/%s!',

        # Template: AgentTicketForward
        'Forward %s%s%s' => 'Forward %s%s%s',

        # Template: AgentTicketHistory
        'History of %s%s%s' => 'History of %s%s%s',
        'History Content' => 'History Content',
        'Zoom view' => 'Zoom view',

        # Template: AgentTicketMerge
        'Merge %s%s%s' => 'Merge %s%s%s',
        'Merge Settings' => 'Merge Settings',
        'You need to use a ticket number!' => 'You need to use a ticket number!',
        'A valid ticket number is required.' => 'A valid ticket number is required.',
        'Need a valid email address.' => 'Need a valid email address.',

        # Template: AgentTicketMove
        'Move %s%s%s' => 'Move %s%s%s',
        'New Queue' => 'New Queue',

        # Template: AgentTicketOverviewMedium
        'Select all' => 'Select all',
        'No ticket data found.' => 'No ticket data found.',
        'Open / Close ticket action menu' => 'Open / Close ticket action menu',
        'Select this ticket' => 'Select this ticket',
        'First Response Time' => 'First Response Time',
        'Update Time' => 'Update Time',
        'Solution Time' => 'Solution Time',
        'Move ticket to a different queue' => 'Move ticket to a different queue',
        'Change queue' => 'Change queue',

        # Template: AgentTicketOverviewNavBar
        'Change search options' => 'Change search options',
        'Remove active filters for this screen.' => 'Remove active filters for this screen.',
        'Tickets per page' => 'Tickets per page',

        # Template: AgentTicketOverviewSmall
        'Reset overview' => 'Reset overview',
        'Column Filters Form' => 'Column Filters Form',

        # Template: AgentTicketPhone
        'Split Into New Phone Ticket' => 'Split Into New Phone Ticket',
        'Save Chat Into New Phone Ticket' => 'Save Chat Into New Phone Ticket',
        'Create New Phone Ticket' => 'Create New Phone Ticket',
        'Please include at least one customer for the ticket.' => 'Please include at least one customer for the ticket.',
        'To queue' => 'To queue',
        'Chat protocol' => 'Chat protocol',
        'The chat will be appended as a separate article.' => 'The chat will be appended as a separate article.',

        # Template: AgentTicketPhoneCommon
        'Phone Call for %s%s%s' => 'Phone Call for %s%s%s',

        # Template: AgentTicketPlain
        'View Email Plain Text for %s%s%s' => 'View Email Plain Text for %s%s%s',
        'Plain' => 'Plain',
        'Download this email' => 'Download this email',

        # Template: AgentTicketProcess
        'Create New Process Ticket' => 'Create New Process Ticket',
        'Process' => 'Process',

        # Template: AgentTicketProcessSmall
        'Enroll Ticket into a Process' => 'Enroll Ticket into a Process',

        # Template: AgentTicketSearch
        'Search template' => 'Search template',
        'Create Template' => 'Create Template',
        'Create New' => 'Create New',
        'Profile link' => 'Profile link',
        'Save changes in template' => 'Save changes in template',
        'Filters in use' => 'Filters in use',
        'Additional filters' => 'Additional filters',
        'Add another attribute' => 'Add another attribute',
        'Output' => 'Output',
        'Fulltext' => 'Fulltext',
        'Remove' => 'Remove',
        'Searches in the attributes From, To, Cc, Subject and the article body, overriding other attributes with the same name.' =>
            'Searches in the attributes From, To, Cc, Subject and the article body, overriding other attributes with the same name.',
        'CustomerID (complex search)' => 'CustomerID (complex search)',
        '(e. g. 234*)' => '',
        'CustomerID (exact match)' => 'CustomerID (exact match)',
        'Customer User Login (complex search)' => 'Customer User Login (complex search)',
        '(e. g. U51*)' => '',
        'Customer User Login (exact match)' => 'Customer User Login (exact match)',
        'Attachment Name' => 'Attachment Name',
        '(e. g. m*file or myfi*)' => '(e. g. m*file or myfi*)',
        'Created in Queue' => 'Created in Queue',
        'Lock state' => 'Lock state',
        'Watcher' => 'Watcher',
        'Article Create Time (before/after)' => 'Article Create Time (before/after)',
        'Article Create Time (between)' => 'Article Create Time (between)',
        'Ticket Create Time (before/after)' => 'Ticket Create Time (before/after)',
        'Ticket Create Time (between)' => 'Ticket Create Time (between)',
        'Ticket Change Time (before/after)' => 'Ticket Change Time (before/after)',
        'Ticket Change Time (between)' => 'Ticket Change Time (between)',
        'Ticket Last Change Time (before/after)' => 'Ticket Last Change Time (before/after)',
        'Ticket Last Change Time (between)' => 'Ticket Last Change Time (between)',
        'Ticket Close Time (before/after)' => 'Ticket Close Time (before/after)',
        'Ticket Close Time (between)' => 'Ticket Close Time (between)',
        'Ticket Escalation Time (before/after)' => 'Ticket Escalation Time (before/after)',
        'Ticket Escalation Time (between)' => 'Ticket Escalation Time (between)',
        'Archive Search' => 'Archive Search',
        'Run search' => 'Run search',

        # Template: AgentTicketZoom
        'Article filter' => 'Article filter',
        'Article Type' => 'Article Type',
        'Sender Type' => 'Sender Type',
        'Save filter settings as default' => 'Save filter settings as default',
        'Event Type Filter' => 'Event Type Filter',
        'Event Type' => 'Event Type',
        'Save as default' => 'Save as default',
        'Archive' => 'Archive',
        'This ticket is archived.' => 'This ticket is archived.',
        'Note: Type is invalid!' => 'Note: Type is invalid!',
        'Locked' => 'Locked',
        'Accounted time' => 'Accounted time',
        'Linked Objects' => 'Linked Objects',
        'Change Queue' => 'Change Queue',
        'There are no dialogs available at this point in the process.' =>
            'There are no dialogs available at this point in the process.',
        'This item has no articles yet.' => 'This item has no articles yet.',
        'Ticket Timeline View' => 'Ticket Timeline View',
        'Article Overview' => 'Article Overview',
        'Article(s)' => 'Article(s)',
        'Page' => 'Page',
        'Add Filter' => 'Add Filter',
        'Set' => 'Set',
        'Reset Filter' => 'Reset Filter',
        'Show one article' => 'Show one article',
        'Show all articles' => 'Show all articles',
        'Show Ticket Timeline View' => 'Show Ticket Timeline View',
        'Unread articles' => 'Unread articles',
        'No.' => 'No.',
        'Important' => 'Important',
        'Unread Article!' => 'Unread Article!',
        'Incoming message' => 'Incoming message',
        'Outgoing message' => 'Outgoing message',
        'Internal message' => 'Internal message',
        'Resize' => 'Resize',
        'Mark this article as read' => 'Mark this article as read',
        'Show Full Text' => 'Show Full Text',
        'Full Article Text' => 'Full Article Text',
        'No more events found. Please try changing the filter settings.' =>
            'No more events found. Please try changing the filter settings.',
        'by' => 'by',
        'To open links in the following article, you might need to press Ctrl or Cmd or Shift key while clicking the link (depending on your browser and OS).' =>
            'To open links in the following article, you might need to press Ctrl or Cmd or Shift key while clicking the link (depending on your browser and OS).',
        'Close this message' => 'Close this message',
        'Article could not be opened! Perhaps it is on another article page?' =>
            'Article could not be opened! Perhaps it is on another article page?',
        'Scale preview content' => 'Scale preview content',
        'Open URL in new tab' => 'Open URL in new tab',
        'Close preview' => 'Close preview',
        'A preview of this website can\'t be provided because it didn\'t allow to be embedded.' =>
            'A preview of this website can\'t be provided because it didn\'t allow to be embedded.',

        # Template: AttachmentBlocker
        'To protect your privacy, remote content was blocked.' => 'To protect your privacy, remote content was blocked.',
        'Load blocked content.' => 'Load blocked content.',

        # Template: ChatStartForm
        'First message' => 'First message',

        # Template: CloudServicesDisabled
        'This feature requires cloud services.' => 'This feature requires cloud services.',
        'You can' => 'You can',
        'go back to the previous page' => 'go back to the previous page',

        # Template: CustomerError
        'An Error Occurred' => 'An Error Occurred',
        'Error Details' => 'Error Details',
        'Traceback' => 'Traceback',

        # Template: CustomerFooter
        'Powered by' => 'Powered by',

        # Template: CustomerFooterJS
        'One or more errors occurred!' => 'One or more errors occurred!',
        'Close this dialog' => 'Close this dialog',
        'Could not open popup window. Please disable any popup blockers for this application.' =>
            'Could not open popup window. Please disable any popup blockers for this application.',
        'If you now leave this page, all open popup windows will be closed, too!' =>
            'If you now leave this page, all open popup windows will be closed, too!',
        'A popup of this screen is already open. Do you want to close it and load this one instead?' =>
            'A popup of this screen is already open. Do you want to close it and load this one instead?',
        'There are currently no elements available to select from.' => 'There are currently no elements available to select from.',
        'Please turn off Compatibility Mode in Internet Explorer!' => 'Please turn off Compatibility Mode in Internet Explorer!',
        'The browser you are using is too old.' => 'The browser you are using is too old.',
        'OTRS runs with a huge lists of browsers, please upgrade to one of these.' =>
            'OTRS runs with a huge lists of browsers, please upgrade to one of these.',
        'Please see the documentation or ask your admin for further information.' =>
            'Please see the documentation or ask your admin for further information.',
        'Switch to mobile mode' => 'Switch to mobile mode',
        'Switch to desktop mode' => 'Switch to desktop mode',
        'Not available' => 'Not available',
        'Clear all' => 'Clear all',
        'Clear search' => 'Clear search',
        '%s selection(s)...' => '%s selection(s)...',
        'and %s more...' => 'and %s more...',
        'Filters' => 'Filters',
        'Confirm' => 'Confirm',
        'You have unanswered chat requests' => 'You have unanswered chat requests',
        'Accept' => 'Accept',
        'Decline' => 'Decline',
        'An internal error occurred.' => 'An internal error occurred.',
        'Connection error' => '',
        'Reload page' => '',
        'Your browser was not able to communicate with OTRS properly, there seems to be something wrong with your network connection. You could either try reloading this page manually or wait until your browser has re-established the connection on its own.' =>
            '',
        'The connection has been re-established after a temporary connection loss. Due to this, elements on this page could have stopped to work correctly. In order to be able to use all elements correctly again, it is strongly recommended to reload this page.' =>
            '',

        # Template: CustomerLogin
        'JavaScript Not Available' => 'JavaScript Not Available',
        'In order to experience OTRS, you\'ll need to enable JavaScript in your browser.' =>
            'In order to experience OTRS, you\'ll need to enable JavaScript in your browser.',
        'Browser Warning' => 'Browser Warning',
        'One moment please, you are being redirected...' => 'One moment please, you are being redirected...',
        'Login' => 'Login',
        'User name' => 'User name',
        'Your user name' => 'Your user name',
        'Your password' => 'Your password',
        'Forgot password?' => 'Forgot password?',
        '2 Factor Token' => '2 Factor Token',
        'Your 2 Factor Token' => 'Your 2 Factor Token',
        'Log In' => 'Log In',
        'Not yet registered?' => 'Not yet registered?',
        'Request new password' => 'Request new password',
        'Your User Name' => 'Your User Name',
        'A new password will be sent to your email address.' => 'A new password will be sent to your email address.',
        'Create Account' => 'Create Account',
        'Please fill out this form to receive login credentials.' => 'Please fill out this form to receive login credentials.',
        'How we should address you' => 'How we should address you',
        'Your First Name' => 'Your First Name',
        'Your Last Name' => 'Your Last Name',
        'Your email address (this will become your username)' => 'Your email address (this will become your username)',

        # Template: CustomerNavigationBar
        'Incoming Chat Requests' => 'Incoming Chat Requests',
        'Edit personal preferences' => 'Edit personal preferences',
        'Logout %s %s' => 'Logout %s %s',

        # Template: CustomerRichTextEditor
        'Split Quote' => 'Split Quote',
        'Open link' => 'Open link',

        # Template: CustomerTicketMessage
        'Service level agreement' => 'Service level agreement',

        # Template: CustomerTicketOverview
        'Welcome!' => 'Welcome!',
        'Please click the button below to create your first ticket.' => 'Please click the button below to create your first ticket.',
        'Create your first ticket' => 'Create your first ticket',

        # Template: CustomerTicketSearch
        'Profile' => 'Profile',
        'e. g. 10*5155 or 105658*' => 'e. g. 10*5155 or 105658*',
        'Customer ID' => 'Customer ID',
        'Fulltext search in tickets (e. g. "John*n" or "Will*")' => 'Fulltext search in tickets (e. g. "John*n" or "Will*")',
        'Recipient' => 'Recipient',
        'Carbon Copy' => 'Carbon Copy',
        'e. g. m*file or myfi*' => 'e. g. m*file or myfi*',
        'Types' => 'Types',
        'Time restrictions' => 'Time restrictions',
        'No time settings' => 'No time settings',
        'Specific date' => 'Specific date',
        'Only tickets created' => 'Only tickets created',
        'Date range' => 'Date range',
        'Only tickets created between' => 'Only tickets created between',
        'Ticket archive system' => 'Ticket archive system',
        'Save search as template?' => 'Save search as template?',
        'Save as Template?' => 'Save as Template?',
        'Save as Template' => 'Save as Template',
        'Template Name' => 'Template Name',
        'Pick a profile name' => 'Pick a profile name',
        'Output to' => 'Output to',

        # Template: CustomerTicketSearchResultShort
        'of' => 'of',
        'Search Results for' => 'Search Results for',
        'Remove this Search Term.' => 'Remove this Search Term.',

        # Template: CustomerTicketZoom
        'Start a chat from this ticket' => 'Start a chat from this ticket',
        'Expand article' => 'Expand article',
        'Information' => 'Information',
        'Next Steps' => 'Next Steps',
        'Reply' => 'Reply',
        'Chat Protocol' => 'Chat Protocol',

        # Template: DashboardEventsTicketCalendar
        'All-day' => 'All-day',
        'Sunday' => 'Sunday',
        'Monday' => 'Monday',
        'Tuesday' => 'Tuesday',
        'Wednesday' => 'Wednesday',
        'Thursday' => 'Thursday',
        'Friday' => 'Friday',
        'Saturday' => 'Saturday',
        'Su' => 'Su',
        'Mo' => 'Mo',
        'Tu' => 'Tu',
        'We' => 'We',
        'Th' => 'Th',
        'Fr' => 'Fr',
        'Sa' => 'Sa',
        'Event Information' => 'Event Information',
        'Ticket fields' => 'Ticket fields',
        'Dynamic fields' => 'Dynamic fields',

        # Template: Datepicker
        'Invalid date (need a future date)!' => 'Invalid date (need a future date)!',
        'Invalid date (need a past date)!' => 'Invalid date (need a past date)!',
        'Previous' => 'Previous',
        'Open date selection' => 'Open date selection',

        # Template: Error
        'An error occurred.' => 'An error occurred.',
        'Really a bug? 5 out of 10 bug reports result from a wrong or incomplete installation of OTRS.' =>
            'Really a bug? 5 out of 10 bug reports result from a wrong or incomplete installation of OTRS.',
        'With %s, our experts take care of correct installation and cover your back with support and periodic security updates.' =>
            'With %s, our experts take care of correct installation and cover your back with support and periodic security updates.',
        'Contact our service team now.' => 'Contact our service team now.',
        'Send a bugreport' => 'Send a bugreport',

        # Template: FooterJS
        'Please enter at least one search value or * to find anything.' =>
            'Please enter at least one search value or * to find anything.',
        'Please remove the following words from your search as they cannot be searched for:' =>
            'Please remove the following words from your search as they cannot be searched for:',
        'Please check the fields marked as red for valid inputs.' => 'Please check the fields marked as red for valid inputs.',
        'Please perform a spell check on the the text first.' => 'Please perform a spell check on the the text first.',
        'Slide the navigation bar' => 'Slide the navigation bar',
        'Unavailable for chat' => 'Unavailable for chat',
        'Available for internal chats only' => 'Available for internal chats only',
        'Available for chats' => 'Available for chats',
        'Please visit the chat manager' => 'Please visit the chat manager',
        'New personal chat request' => 'New personal chat request',
        'New customer chat request' => 'New customer chat request',
        'New public chat request' => 'New public chat request',
        'Selected user is not available for chat.' => '',
        'New activity' => 'New activity',
        'New activity on one of your monitored chats.' => 'New activity on one of your monitored chats.',
        'Your browser does not support video and audio calling.' => '',
        'Selected user is not available for video and audio call.' => '',
        'Target user\'s browser does not support video and audio calling.' =>
            '',
        'Do you really want to continue?' => 'Do you really want to continue?',
        'Information about the OTRS Daemon' => 'Information about the OTRS Daemon',
        'This feature is part of the %s.  Please contact us at %s for an upgrade.' =>
            'This feature is part of the %s.  Please contact us at %s for an upgrade.',
        'Find out more about the %s' => 'Find out more about the %s',

        # Template: Header
        'You are logged in as' => 'You are logged in as',

        # Template: Installer
        'JavaScript not available' => 'JavaScript not available',
        'Step %s' => 'Step %s',
        'Database Settings' => 'Database Settings',
        'General Specifications and Mail Settings' => 'General Specifications and Mail Settings',
        'Finish' => 'Finish',
        'Welcome to %s' => 'Welcome to %s',
        'Web site' => 'Web site',
        'Mail check successful.' => 'Mail check successful.',
        'Error in the mail settings. Please correct and try again.' => 'Error in the mail settings. Please correct and try again.',

        # Template: InstallerConfigureMail
        'Configure Outbound Mail' => 'Configure Outbound Mail',
        'Outbound mail type' => 'Outbound mail type',
        'Select outbound mail type.' => 'Select outbound mail type.',
        'Outbound mail port' => 'Outbound mail port',
        'Select outbound mail port.' => 'Select outbound mail port.',
        'SMTP host' => 'SMTP host',
        'SMTP host.' => 'SMTP host.',
        'SMTP authentication' => 'SMTP authentication',
        'Does your SMTP host need authentication?' => 'Does your SMTP host need authentication?',
        'SMTP auth user' => 'SMTP auth user',
        'Username for SMTP auth.' => 'Username for SMTP auth.',
        'SMTP auth password' => 'SMTP auth password',
        'Password for SMTP auth.' => 'Password for SMTP auth.',
        'Configure Inbound Mail' => 'Configure Inbound Mail',
        'Inbound mail type' => 'Inbound mail type',
        'Select inbound mail type.' => 'Select inbound mail type.',
        'Inbound mail host' => 'Inbound mail host',
        'Inbound mail host.' => 'Inbound mail host.',
        'Inbound mail user' => 'Inbound mail user',
        'User for inbound mail.' => 'User for inbound mail.',
        'Inbound mail password' => 'Inbound mail password',
        'Password for inbound mail.' => 'Password for inbound mail.',
        'Result of mail configuration check' => 'Result of mail configuration check',
        'Check mail configuration' => 'Check mail configuration',
        'Skip this step' => 'Skip this step',

        # Template: InstallerDBResult
        'Database setup successful!' => 'Database setup successful!',

        # Template: InstallerDBStart
        'Install Type' => 'Install Type',
        'Create a new database for OTRS' => 'Create a new database for OTRS',
        'Use an existing database for OTRS' => 'Use an existing database for OTRS',

        # Template: InstallerDBmssql
        'Database name' => 'Database name',
        'Check database settings' => 'Check database settings',
        'Result of database check' => 'Result of database check',
        'Database check successful.' => 'Database check successful.',
        'Database User' => 'Database User',
        'New' => 'New',
        'A new database user with limited permissions will be created for this OTRS system.' =>
            'A new database user with limited permissions will be created for this OTRS system.',
        'Repeat Password' => 'Repeat Password',
        'Generated password' => 'Generated password',

        # Template: InstallerDBmysql
        'Passwords do not match' => 'Passwords do not match',

        # Template: InstallerDBoracle
        'SID' => 'SID',
        'Port' => 'Port',

        # Template: InstallerFinish
        'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' =>
            'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.',
        'Restart your webserver' => 'Restart your webserver',
        'After doing so your OTRS is up and running.' => 'After doing so your OTRS is up and running.',
        'Start page' => 'Start page',
        'Your OTRS Team' => 'Your OTRS Team',

        # Template: InstallerLicense
        'Don\'t accept license' => 'Don\'t accept licence',
        'Accept license and continue' => 'Accept license and continue',

        # Template: InstallerSystem
        'SystemID' => 'SystemID',
        'The identifier of the system. Each ticket number and each HTTP session ID contain this number.' =>
            'The identifier of the system. Each ticket number and each HTTP session ID contain this number.',
        'System FQDN' => 'System FQDN',
        'Fully qualified domain name of your system.' => 'Fully qualified domain name of your system.',
        'AdminEmail' => 'AdminEmail',
        'Email address of the system administrator.' => 'Email address of the system administrator.',
        'Organization' => 'Organisation',
        'Log' => 'Log',
        'LogModule' => 'LogModule',
        'Log backend to use.' => 'Log backend to use.',
        'LogFile' => 'LogFile',
        'Webfrontend' => 'Webfrontend',
        'Default language' => 'Default language',
        'Default language.' => 'Default language.',
        'CheckMXRecord' => 'CheckMXRecord',
        'Email addresses that are manually entered are checked against the MX records found in DNS. Don\'t use this option if your DNS is slow or does not resolve public addresses.' =>
            'Email addresses that are manually entered are checked against the MX records found in DNS. Don\'t use this option if your DNS is slow or does not resolve public addresses.',

        # Template: LinkObject
        'Object#' => 'Object#',
        'Add links' => 'Add links',
        'Delete links' => 'Delete links',

        # Template: Login
        'Lost your password?' => 'Lost your password?',
        'Request New Password' => 'Request New Password',
        'Back to login' => 'Back to login',

        # Template: MobileNotAvailableWidget
        'Feature not available' => 'Feature not available',
        'Sorry, but this feature of OTRS is currently not available for mobile devices. If you\'d like to use it, you can either switch to desktop mode or use your regular desktop device.' =>
            'Sorry, but this feature of OTRS is currently not available for mobile devices. If you\'d like to use it, you can either switch to desktop mode or use your regular desktop device.',

        # Template: Motd
        'Message of the Day' => 'Message of the Day',
        'This is the message of the day. You can edit this in %s.' => 'This is the message of the day. You can edit this in %s.',

        # Template: NoPermission
        'Insufficient Rights' => 'Insufficient Rights',
        'Back to the previous page' => 'Back to the previous page',

        # Template: Pagination
        'Show first page' => 'Show first page',
        'Show previous pages' => 'Show previous pages',
        'Show page %s' => 'Show page %s',
        'Show next pages' => 'Show next pages',
        'Show last page' => 'Show last page',

        # Template: PictureUpload
        'Need FormID!' => 'Need FormID!',
        'No file found!' => 'No file found!',
        'The file is not an image that can be shown inline!' => 'The file is not an image that can be shown inline!',

        # Template: PreferencesNotificationEvent
        'Notification' => 'Notification',
        'No user configurable notifications found.' => 'No user configurable notifications found.',
        'Receive messages for notification \'%s\' by transport method \'%s\'.' =>
            'Receive messages for notification \'%s\' by transport method \'%s\'.',
        'Please note that you can\'t completely disable notifications marked as mandatory.' =>
            'Please note that you can\'t completely disable notifications marked as mandatory.',
        'Sorry, but you can\'t disable all methods for notifications marked as mandatory.' =>
            'Sorry, but you can\'t disable all methods for notifications marked as mandatory.',
        'Sorry, but you can\'t disable all methods for this notification.' =>
            'Sorry, but you can\'t disable all methods for this notification.',

        # Template: ActivityDialogHeader
        'Process Information' => 'Process Information',
        'Dialog' => 'Dialog',

        # Template: Article
        'Inform Agent' => 'Inform Agent',

        # Template: PublicDefault
        'Welcome' => 'Welcome',
        'This is the default public interface of OTRS! There was no action parameter given.' =>
            'This is the default public interface of OTRS! There was no action parameter given.',
        'You could install a custom public module (via the package manager), for example the FAQ module, which has a public interface.' =>
            'You could install a custom public module (via the package manager), for example the FAQ module, which has a public interface.',

        # Template: RichTextEditor
        'Remove Quote' => 'Remove Quote',

        # Template: GeneralSpecificationsWidget
        'Permissions' => 'Permissions',
        'You can select one or more groups to define access for different agents.' =>
            'You can select one or more groups to define access for different agents.',
        'Result formats' => 'Result formats',
        'The selected time periods in the statistic are time zone neutral.' =>
            'The selected time periods in the statistic are time zone neutral.',
        'Create summation row' => 'Create summation row',
        'Generate an additional row containing sums for all data rows.' =>
            'Generate an additional row containing sums for all data rows.',
        'Create summation column' => 'Create summation column',
        'Generate an additional column containing sums for all data columns.' =>
            'Generate an additional column containing sums for all data columns.',
        'Cache results' => 'Cache results',
        'Stores statistics result data in a cache to be used in subsequent views with the same configuration (requires at least one selected time field).' =>
            '',
        'Provide the statistic as a widget that agents can activate in their dashboard.' =>
            'Provide the statistic as a widget that agents can activate in their dashboard.',
        'Please note that enabling the dashboard widget will activate caching for this statistic in the dashboard.' =>
            'Please note that enabling the dashboard widget will activate caching for this statistic in the dashboard.',
        'If set to invalid end users can not generate the stat.' => 'If set to invalid end users can not generate the stat.',

        # Template: PreviewWidget
        'There are problems in the configuration of this statistic:' => 'There are problems in the configuration of this statistic:',
        'You may now configure the X-axis of your statistic.' => 'You may now configure the X-axis of your statistic.',
        'This statistic does not provide preview data.' => 'This statistic does not provide preview data.',
        'Preview format:' => 'Preview format:',
        'Please note that the preview uses random data and does not consider data filters.' =>
            'Please note that the preview uses random data and does not consider data filters.',
        'Configure X-Axis' => 'Configure X-Axis',
        'X-axis' => 'X-axis',
        'Configure Y-Axis' => 'Configure Y-Axis',
        'Y-axis' => 'Y-axis',
        'Configure Filter' => 'Configure Filter',

        # Template: RestrictionsWidget
        'Please select only one element or turn off the button \'Fixed\'.' =>
            'Please select only one element or turn off the button \'Fixed\'.',
        'Absolute period' => 'Absolute period',
        'Between' => 'Between',
        'Relative period' => 'Relative period',
        'The past complete %s and the current+upcoming complete %s %s' =>
            'The past complete %s and the current+upcoming complete %s %s',
        'Do not allow changes to this element when the statistic is generated.' =>
            'Do not allow changes to this element when the statistic is generated.',

        # Template: StatsParamsWidget
        'Format' => 'Format',
        'Exchange Axis' => 'Exchange Axis',
        'Configurable params of static stat' => 'Configurable params of static stat',
        'No element selected.' => 'No element selected.',
        'Scale' => 'Scale',
        'show more' => 'show more',
        'show less' => 'show less',

        # Template: D3
        'Download SVG' => 'Download SVG',
        'Download PNG' => 'Download PNG',

        # Template: XAxisWidget
        'The selected time period defines the default time frame for this statistic to collect data from.' =>
            'The selected time period defines the default time frame for this statistic to collect data from.',
        'Defines the time unit that will be used to split the selected time period into reporting data points.' =>
            'Defines the time unit that will be used to split the selected time period into reporting data points.',

        # Template: YAxisWidget
        'Please remember that the scale for the Y-axis has to be larger than the scale for the X-axis (e.g. X-axis => Month, Y-Axis => Year).' =>
            'Please remember that the scale for the Y-axis has to be larger than the scale for the X-axis (e.g. X-axis => Month, Y-Axis => Year).',

        # Template: Test
        'OTRS Test Page' => 'OTRS Test Page',
        'Welcome %s %s' => 'Welcome %s %s',
        'Counter' => 'Counter',

        # Template: Warning
        'Go back to the previous page' => 'Go back to the previous page',

        # Perl Module: Kernel/Config/Defaults.pm
        'View system log messages.' => 'View system log messages.',
        'Update and extend your system with software packages.' => 'Update and extend your system with software packages.',

        # Perl Module: Kernel/Modules/AdminACL.pm
        'ACLs could not be Imported due to a unknown error, please check OTRS logs for more information' =>
            'ACLs could not be Imported due to a unknown error, please check OTRS logs for more information',
        'The following ACLs have been added successfully: %s' => 'The following ACLs have been added successfully: %s',
        'The following ACLs have been updated successfully: %s' => 'The following ACLs have been updated successfully: %s',
        'There where errors adding/updating the following ACLs: %s. Please check the log file for more information.' =>
            'There where errors adding/updating the following ACLs: %s. Please check the log file for more information.',
        'This field is required' => 'This field is required',
        'There was an error creating the ACL' => 'There was an error creating the ACL',
        'Need ACLID!' => 'Need ACLID!',
        'Could not get data for ACLID %s' => 'Could not get data for ACLID %s',
        'There was an error updating the ACL' => 'There was an error updating the ACL',
        'There was an error setting the entity sync status.' => 'There was an error setting the entity sync status.',
        'There was an error synchronizing the ACLs.' => 'There was an error synchronizing the ACLs.',
        'ACL %s could not be deleted' => 'ACL %s could not be deleted',
        'There was an error getting data for ACL with ID %s' => 'There was an error getting data for ACL with ID %s',
        'Exact match' => 'Exact match',
        'Negated exact match' => 'Negated exact match',
        'Regular expression' => 'Regular expression',
        'Regular expression (ignore case)' => 'Regular expression (ignore case)',
        'Negated regular expression' => 'Negated regular expression',
        'Negated regular expression (ignore case)' => 'Negated regular expression (ignore case)',

        # Perl Module: Kernel/Modules/AdminCustomerCompany.pm
        'Customer Company %s already exists!' => 'Customer Company %s already exists!',

        # Perl Module: Kernel/Modules/AdminCustomerUser.pm
        'New phone ticket' => 'New phone ticket',
        'New email ticket' => 'New email ticket',

        # Perl Module: Kernel/Modules/AdminDynamicField.pm
        'Fields configuration is not valid' => 'Fields configuration is not valid',
        'Objects configuration is not valid' => 'Objects configuration is not valid',
        'Could not reset Dynamic Field order properly, please check the error log for more details.' =>
            'Could not reset Dynamic Field order properly, please check the error log for more details.',

        # Perl Module: Kernel/Modules/AdminDynamicFieldCheckbox.pm
        'Undefined subaction.' => 'Undefined subaction.',
        'Need %s' => 'Need %s',
        'The field does not contain only ASCII letters and numbers.' => 'The field does not contain only ASCII letters and numbers.',
        'There is another field with the same name.' => 'There is another field with the same name.',
        'The field must be numeric.' => 'The field must be numeric.',
        'Need ValidID' => 'Need ValidID',
        'Could not create the new field' => 'Could not create the new field',
        'Need ID' => 'Need ID',
        'Could not get data for dynamic field %s' => 'Could not get data for dynamic field %s',
        'The name for this field should not change.' => 'The name for this field should not change.',
        'Could not update the field %s' => 'Could not update the field %s',
        'Currently' => 'Currently',
        'Unchecked' => 'Unchecked',
        'Checked' => 'Checked',

        # Perl Module: Kernel/Modules/AdminDynamicFieldDateTime.pm
        'Prevent entry of dates in the future' => 'Prevent entry of dates in the future',
        'Prevent entry of dates in the past' => 'Prevent entry of dates in the past',

        # Perl Module: Kernel/Modules/AdminDynamicFieldDropdown.pm
        'This field value is duplicated.' => 'This field value is duplicated.',

        # Perl Module: Kernel/Modules/AdminEmail.pm
        'Select at least one recipient.' => 'Select at least one recipient.',

        # Perl Module: Kernel/Modules/AdminGenericAgent.pm
        'archive tickets' => 'archive tickets',
        'restore tickets from archive' => 'restore tickets from archive',
        'Need Profile!' => 'Need Profile!',
        'Got no values to check.' => 'Got no values to check.',
        'Please remove the following words because they cannot be used for the ticket selection:' =>
            'Please remove the following words because they cannot be used for the ticket selection:',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceDebugger.pm
        'Need WebserviceID!' => 'Need WebserviceID!',
        'Could not get data for WebserviceID %s' => 'Could not get data for WebserviceID %s',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceInvokerDefault.pm
        'Need InvokerType' => 'Need InvokerType',
        'Invoker %s is not registered' => 'Invoker %s is not registered',
        'InvokerType %s is not registered' => 'InvokerType %s is not registered',
        'Need Invoker' => 'Need Invoker',
        'Could not determine config for invoker %s' => 'Could not determine config for invoker %s',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceMappingSimple.pm
        'Could not get registered configuration for action type %s' => 'Could not get registered configuration for action type %s',
        'Could not get backend for %s %s' => 'Could not get backend for %s %s',
        'Could not update configuration data for WebserviceID %s' => 'Could not update configuration data for WebserviceID %s',
        'Keep (leave unchanged)' => 'Keep (leave unchanged)',
        'Ignore (drop key/value pair)' => 'Ignore (drop key/value pair)',
        'Map to (use provided value as default)' => 'Map to (use provided value as default)',
        'Exact value(s)' => 'Exact value(s)',
        'Ignore (drop Value/value pair)' => 'Ignore (drop Value/value pair)',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceMappingXSLT.pm
        'Could not find required library %s' => 'Could not find required library %s',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceOperationDefault.pm
        'Need OperationType' => 'Need OperationType',
        'Operation %s is not registered' => 'Operation %s is not registered',
        'OperationType %s is not registered' => 'OperationType %s is not registered',
        'Need Operation' => 'Need Operation',
        'Could not determine config for operation %s' => 'Could not determine config for operation %s',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceTransportHTTPREST.pm
        'Need Subaction!' => 'Need Subaction!',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceWebservice.pm
        'There is another web service with the same name.' => 'There is another web service with the same name.',
        'There was an error updating the web service.' => 'There was an error updating the web service.',
        'Web service "%s" updated!' => 'Web service "%s" updated!',
        'There was an error creating the web service.' => 'There was an error creating the web service.',
        'Web service "%s" created!' => 'Web service "%s" created!',
        'Need Name!' => 'Need Name!',
        'Need ExampleWebService!' => 'Need ExampleWebService!',
        'Could not read %s!' => 'Could not read %s!',
        'Need a file to import!' => 'Need a file to import!',
        'The imported file has not valid YAML content! Please check OTRS log for details' =>
            'The imported file has not valid YAML content! Please check OTRS log for details',
        'Web service "%s" deleted!' => 'Web service "%s" deleted!',
        'New Web service' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceWebserviceHistory.pm
        'Got no WebserviceHistoryID!' => 'Got no WebserviceHistoryID!',
        'Could not get history data for WebserviceHistoryID %s' => 'Could not get history data for WebserviceHistoryID %s',

        # Perl Module: Kernel/Modules/AdminNotificationEvent.pm
        'Notification updated!' => 'Notification updated!',
        'Notification added!' => 'Notification added!',
        'There was an error getting data for Notification with ID:%s!' =>
            'There was an error getting data for Notification with ID:%s!',
        'Unknown Notification %s!' => 'Unknown Notification %s!',
        'There was an error creating the Notification' => 'There was an error creating the Notification',
        'Notifications could not be Imported due to a unknown error, please check OTRS logs for more information' =>
            'Notifications could not be Imported due to a unknown error, please check OTRS logs for more information',
        'The following Notifications have been added successfully: %s' =>
            'The following Notifications have been added successfully: %s',
        'The following Notifications have been updated successfully: %s' =>
            'The following Notifications have been updated successfully: %s',
        'There where errors adding/updating the following Notifications: %s. Please check the log file for more information.' =>
            'There where errors adding/updating the following Notifications: %s. Please check the log file for more information.',
        'Agent who owns the ticket' => 'Agent who owns the ticket',
        'Agent who is responsible for the ticket' => 'Agent who is responsible for the ticket',
        'All agents watching the ticket' => 'All agents watching the ticket',
        'All agents with write permission for the ticket' => 'All agents with write permission for the ticket',
        'All agents subscribed to the ticket\'s queue' => 'All agents subscribed to the ticket\'s queue',
        'All agents subscribed to the ticket\'s service' => 'All agents subscribed to the ticket\'s service',
        'All agents subscribed to both the ticket\'s queue and service' =>
            'All agents subscribed to both the ticket\'s queue and service',
        'Customer of the ticket' => 'Customer of the ticket',
        'Yes, but require at least one active notification method' => 'Yes, but require at least one active notification method',

        # Perl Module: Kernel/Modules/AdminPGP.pm
        'PGP environment is not working. Please check log for more info!' =>
            'PGP environment is not working. Please check log for more info!',
        'Need param Key to delete!' => 'Need param Key to delete!',
        'Key %s deleted!' => 'Key %s deleted!',
        'Need param Key to download!' => 'Need param Key to download!',

        # Perl Module: Kernel/Modules/AdminPackageManager.pm
        'Sorry, Apache::Reload is needed as PerlModule and PerlInitHandler in Apache config file. See also scripts/apache2-httpd.include.conf. Alternatively, you can use the command line tool bin/otrs.Console.pl to install packages!' =>
            'Sorry, Apache::Reload is needed as PerlModule and PerlInitHandler in Apache config file. See also scripts/apache2-httpd.include.conf. Alternatively, you can use the command line tool bin/otrs.Console.pl to install packages!',
        'No such package!' => 'No such package!',
        'No such file %s in package!' => 'No such file %s in package!',
        'No such file %s in local file system!' => 'No such file %s in local file system!',
        'Can\'t read %s!' => 'Can\'t read %s!',
        'File is OK' => '',
        'Package has locally modified files.' => 'Package has locally modified files.',
        'No packages or no new packages found in selected repository.' =>
            'No packages or no new packages found in selected repository.',
        'Package not verified due a communication issue with verification server!' =>
            'Package not verified due a communication issue with verification server!',
        'Can\'t connect to OTRS Feature Add-on list server!' => 'Can\'t connect to OTRS Feature Add-on list server!',
        'Can\'t get OTRS Feature Add-on list from server!' => 'Can\'t get OTRS Feature Add-on list from server!',
        'Can\'t get OTRS Feature Add-on from server!' => 'Can\'t get OTRS Feature Add-on from server!',

        # Perl Module: Kernel/Modules/AdminPostMasterFilter.pm
        'No such filter: %s' => 'No such filter: %s',

        # Perl Module: Kernel/Modules/AdminProcessManagement.pm
        'Need ExampleProcesses!' => 'Need ExampleProcesses!',
        'Need ProcessID!' => 'Need ProcessID!',
        'Yes (mandatory)' => 'Yes (mandatory)',
        'Unknown Process %s!' => 'Unknown Process %s!',
        'There was an error generating a new EntityID for this Process' =>
            'There was an error generating a new EntityID for this Process',
        'The StateEntityID for state Inactive does not exists' => 'The StateEntityID for state Inactive does not exists',
        'There was an error creating the Process' => 'There was an error creating the Process',
        'There was an error setting the entity sync status for Process entity: %s' =>
            'There was an error setting the entity sync status for Process entity: %s',
        'Could not get data for ProcessID %s' => 'Could not get data for ProcessID %s',
        'There was an error updating the Process' => 'There was an error updating the Process',
        'Process: %s could not be deleted' => 'Process: %s could not be deleted',
        'There was an error synchronizing the processes.' => 'There was an error synchronising the processes.',
        'The %s:%s is still in use' => 'The %s:%s is still in use',
        'The %s:%s has a different EntityID' => 'The %s:%s has a different EntityID',
        'Could not delete %s:%s' => 'Could not delete %s:%s',
        'There was an error setting the entity sync status for %s entity: %s' =>
            'There was an error setting the entity sync status for %s entity: %s',
        'Could not get %s' => 'Could not get %s',
        'Need %s!' => 'Need %s!',
        'Process: %s is not Inactive' => 'Process: %s is not Inactive',

        # Perl Module: Kernel/Modules/AdminProcessManagementActivity.pm
        'There was an error generating a new EntityID for this Activity' =>
            'There was an error generating a new EntityID for this Activity',
        'There was an error creating the Activity' => 'There was an error creating the Activity',
        'There was an error setting the entity sync status for Activity entity: %s' =>
            'There was an error setting the entity sync status for Activity entity: %s',
        'Need ActivityID!' => 'Need ActivityID!',
        'Could not get data for ActivityID %s' => 'Could not get data for ActivityID %s',
        'There was an error updating the Activity' => 'There was an error updating the Activity',
        'Missing Parameter: Need Activity and ActivityDialog!' => 'Missing Parameter: Need Activity and ActivityDialog!',
        'Activity not found!' => 'Activity not found!',
        'ActivityDialog not found!' => 'ActivityDialog not found!',
        'ActivityDialog already assigned to Activity. You cannot add an ActivityDialog twice!' =>
            'ActivityDialog already assigned to Activity. You cannot add an ActivityDialog twice!',
        'Error while saving the Activity to the database!' => 'Error while saving the Activity to the database!',
        'This subaction is not valid' => 'This subaction is not valid',
        'Edit Activity "%s"' => 'Edit Activity "%s"',

        # Perl Module: Kernel/Modules/AdminProcessManagementActivityDialog.pm
        'There was an error generating a new EntityID for this ActivityDialog' =>
            'There was an error generating a new EntityID for this ActivityDialog',
        'There was an error creating the ActivityDialog' => 'There was an error creating the ActivityDialog',
        'There was an error setting the entity sync status for ActivityDialog entity: %s' =>
            'There was an error setting the entity sync status for ActivityDialog entity: %s',
        'Need ActivityDialogID!' => 'Need ActivityDialogID!',
        'Could not get data for ActivityDialogID %s' => 'Could not get data for ActivityDialogID %s',
        'There was an error updating the ActivityDialog' => 'There was an error updating the ActivityDialog',
        'Edit Activity Dialog "%s"' => 'Edit Activity Dialog "%s"',
        'Agent Interface' => 'Agent Interface',
        'Customer Interface' => 'Customer Interface',
        'Agent and Customer Interface' => 'Agent and Customer Interface',
        'Do not show Field' => 'Do not show Field',
        'Show Field' => 'Show Field',
        'Show Field As Mandatory' => 'Show Field As Mandatory',
        'fax' => 'fax',

        # Perl Module: Kernel/Modules/AdminProcessManagementPath.pm
        'Edit Path' => 'Edit Path',

        # Perl Module: Kernel/Modules/AdminProcessManagementTransition.pm
        'There was an error generating a new EntityID for this Transition' =>
            'There was an error generating a new EntityID for this Transition',
        'There was an error creating the Transition' => 'There was an error creating the Transition',
        'There was an error setting the entity sync status for Transition entity: %s' =>
            'There was an error setting the entity sync status for Transition entity: %s',
        'Need TransitionID!' => 'Need TransitionID!',
        'Could not get data for TransitionID %s' => 'Could not get data for TransitionID %s',
        'There was an error updating the Transition' => 'There was an error updating the Transition',
        'Edit Transition "%s"' => 'Edit Transition "%s"',
        'xor' => 'xor',
        'String' => 'String',
        'Transition validation module' => 'Transition validation module',

        # Perl Module: Kernel/Modules/AdminProcessManagementTransitionAction.pm
        'At least one valid config parameter is required.' => 'At least one valid config parameter is required.',
        'There was an error generating a new EntityID for this TransitionAction' =>
            'There was an error generating a new EntityID for this TransitionAction',
        'There was an error creating the TransitionAction' => 'There was an error creating the TransitionAction',
        'There was an error setting the entity sync status for TransitionAction entity: %s' =>
            'There was an error setting the entity sync status for TransitionAction entity: %s',
        'Need TransitionActionID!' => 'Need TransitionActionID!',
        'Could not get data for TransitionActionID %s' => 'Could not get data for TransitionActionID %s',
        'There was an error updating the TransitionAction' => 'There was an error updating the TransitionAction',
        'Edit Transition Action "%s"' => 'Edit Transition Action "%s"',
        'Error: Not all keys seem to have values or vice versa.' => 'Error: Not all keys seem to have values or vice versa.',

        # Perl Module: Kernel/Modules/AdminQueue.pm
        'Don\'t use :: in queue name!' => 'Don\'t use :: in queue name!',
        'Click back and change it!' => 'Click back and change it!',

        # Perl Module: Kernel/Modules/AdminQueueAutoResponse.pm
        'Queues ( without auto responses )' => 'Queues ( without auto responses )',

        # Perl Module: Kernel/Modules/AdminSMIME.pm
        'S/MIME environment is not working. Please check log for more info!' =>
            'S/MIME environment is not working. Please check log for more info!',
        'Need param Filename to delete!' => 'Need param Filename to delete!',
        'Need param Filename to download!' => 'Need param Filename to download!',
        'Needed CertFingerprint and CAFingerprint!' => 'Needed CertFingerprint and CAFingerprint!',
        'CAFingerprint must be different than CertFingerprint' => 'CAFingerprint must be different than CertFingerprint',
        'Relation exists!' => 'Relation exists!',
        'Relation added!' => 'Relation added!',
        'Impossible to add relation!' => 'Impossible to add relation!',
        'Relation doesn\'t exists' => 'Relation doesn\'t exists',
        'Relation deleted!' => 'Relation deleted!',
        'Impossible to delete relation!' => 'Impossible to delete relation!',
        'Certificate %s could not be read!' => 'Certificate %s could not be read!',
        'Needed Fingerprint' => 'Needed Fingerprint',

        # Perl Module: Kernel/Modules/AdminSalutation.pm
        'Salutation updated!' => 'Salutation updated!',
        'Salutation added!' => 'Salutation added!',

        # Perl Module: Kernel/Modules/AdminSupportDataCollector.pm
        'File %s could not be read!' => 'File %s could not be read!',

        # Perl Module: Kernel/Modules/AdminSysConfig.pm
        'Import not allowed!' => 'Import not allowed!',
        'Need File!' => 'Need File!',
        'Can\'t write ConfigItem!' => 'Can\'t write ConfigItem!',

        # Perl Module: Kernel/Modules/AdminSystemMaintenance.pm
        'Start date shouldn\'t be defined after Stop date!' => 'Start date shouldn\'t be defined after Stop date!',
        'There was an error creating the System Maintenance' => 'There was an error creating the System Maintenance',
        'Need SystemMaintenanceID!' => 'Need SystemMaintenanceID!',
        'Could not get data for SystemMaintenanceID %s' => 'Could not get data for SystemMaintenanceID %s',
        'System Maintenance was saved successfully!' => 'System Maintenance was saved successfully!',
        'Session has been killed!' => 'Session has been killed!',
        'All sessions have been killed, except for your own.' => 'All sessions have been killed, except for your own.',
        'There was an error updating the System Maintenance' => 'There was an error updating the System Maintenance',
        'Was not possible to delete the SystemMaintenance entry: %s!' => 'Was not possible to delete the SystemMaintenance entry: %s!',

        # Perl Module: Kernel/Modules/AdminTemplate.pm
        'Template updated!' => 'Template updated!',
        'Template added!' => 'Template added!',

        # Perl Module: Kernel/Modules/AdminType.pm
        'Need Type!' => 'Need Type!',

        # Perl Module: Kernel/Modules/AgentDashboardCommon.pm
        'No such config for %s' => 'No such config for %s',
        'Statistic' => 'Statistic',
        'No preferences for %s!' => 'No preferences for %s!',
        'Can\'t get element data of %s!' => 'Can\'t get element data of %s!',
        'Can\'t get filter content data of %s!' => 'Can\'t get filter content data of %s!',
        'Customer Company Name' => '',
        'Customer User ID' => '',

        # Perl Module: Kernel/Modules/AgentLinkObject.pm
        'Need SourceObject and SourceKey!' => 'Need SourceObject and SourceKey!',
        'Please contact the administrator.' => 'Please contact the administrator.',
        'You need ro permission!' => 'You need ro permission!',
        'Can not delete link with %s!' => 'Can not delete link with %s!',
        'Can not create link with %s! Object already linked as %s.' => 'Can not create link with %s! Object already linked as %s.',
        'Can not create link with %s!' => 'Can not create link with %s!',
        'The object %s cannot link with other object!' => 'The object %s cannot link with other object!',

        # Perl Module: Kernel/Modules/AgentPreferences.pm
        'Param Group is required!' => 'Param Group is required!',

        # Perl Module: Kernel/Modules/AgentStatistics.pm
        'Parameter %s is missing.' => 'Parameter %s is missing.',
        'Invalid Subaction.' => 'Invalid Subaction.',
        'Statistic could not be imported.' => 'Statistic could not be imported.',
        'Please upload a valid statistic file.' => 'Please upload a valid statistic file.',
        'Export: Need StatID!' => 'Export: Need StatID!',
        'Delete: Get no StatID!' => 'Delete: Get no StatID!',
        'Need StatID!' => 'Need StatID!',
        'Could not load stat.' => 'Could not load stat.',
        'Could not create statistic.' => 'Could not create statistic.',
        'Run: Get no %s!' => 'Run: Get no %s!',

        # Perl Module: Kernel/Modules/AgentTicketActionCommon.pm
        'No TicketID is given!' => 'No TicketID is given!',
        'You need %s permissions!' => 'You need %s permissions!',
        'Could not perform validation on field %s!' => 'Could not perform validation on field %s!',
        'No subject' => 'No subject',
        'Previous Owner' => 'Previous Owner',

        # Perl Module: Kernel/Modules/AgentTicketBounce.pm
        '%s is needed!' => '%s is needed!',
        'Plain article not found for article %s!' => 'Plain article not found for article %s!',
        'Article does not belong to ticket %s!' => 'Article does not belong to ticket %s!',
        'Can\'t bounce email!' => 'Can\'t bounce email!',
        'Can\'t send email!' => 'Can\'t send email!',
        'Wrong Subaction!' => 'Wrong Subaction!',

        # Perl Module: Kernel/Modules/AgentTicketBulk.pm
        'Can\'t lock Tickets, no TicketIDs are given!' => 'Can\'t lock Tickets, no TicketIDs are given!',
        'Ticket (%s) is not unlocked!' => 'Ticket (%s) is not unlocked!',
        'Bulk feature is not enabled!' => 'Bulk feature is not enabled!',
        'No selectable TicketID is given!' => 'No selectable TicketID is given!',
        'You either selected no ticket or only tickets which are locked by other agents.' =>
            '',
        'You need to select at least one ticket.' => '',
        'The following tickets were ignored because they are locked by another agent or you don\'t have write access to these tickets: %s.' =>
            '',
        'The following tickets were locked: %s.' => '',

        # Perl Module: Kernel/Modules/AgentTicketCompose.pm
        'Can not determine the ArticleType!' => 'Can not determine the ArticleType!',

        # Perl Module: Kernel/Modules/AgentTicketEmail.pm
        'No Subaction!' => 'No Subaction!',

        # Perl Module: Kernel/Modules/AgentTicketEmailOutbound.pm
        'Got no TicketID!' => 'Got no TicketID!',
        'System Error!' => 'System Error!',

        # Perl Module: Kernel/Modules/AgentTicketEscalationView.pm
        'Invalid Filter: %s!' => 'Invalid Filter: %s!',

        # Perl Module: Kernel/Modules/AgentTicketHistory.pm
        'Can\'t show history, no TicketID is given!' => 'Can\'t show history, no TicketID is given!',

        # Perl Module: Kernel/Modules/AgentTicketLock.pm
        'Can\'t lock Ticket, no TicketID is given!' => 'Can\'t lock Ticket, no TicketID is given!',
        'Sorry, the current owner is %s!' => 'Sorry, the current owner is %s!',
        'Please become the owner first.' => 'Please become the owner first.',
        'Ticket (ID=%s) is locked by %s!' => 'Ticket (ID=%s) is locked by %s!',
        'Change the owner!' => 'Change the owner!',

        # Perl Module: Kernel/Modules/AgentTicketMerge.pm
        'Can\'t merge ticket with itself!' => 'Can\'t merge ticket with itself!',

        # Perl Module: Kernel/Modules/AgentTicketMove.pm
        'You need move permissions!' => 'You need move permissions!',

        # Perl Module: Kernel/Modules/AgentTicketPhone.pm
        'Chat is not active.' => 'Chat is not active.',
        'No permission.' => 'No permission.',
        '%s has left the chat.' => '%s has left the chat.',
        'This chat has been closed and will be removed in %s hours.' => 'This chat has been closed and will be removed in %s hours.',

        # Perl Module: Kernel/Modules/AgentTicketPlain.pm
        'No ArticleID!' => 'No ArticleID!',
        'Can\'t read plain article! Maybe there is no plain email in backend! Read backend message.' =>
            'Can\'t read plain article! Maybe there is no plain email in backend! Read backend message.',

        # Perl Module: Kernel/Modules/AgentTicketPrint.pm
        'Need TicketID!' => 'Need TicketID!',
        'printed by' => 'printed by',
        'Ticket Dynamic Fields' => 'Ticket Dynamic Fields',

        # Perl Module: Kernel/Modules/AgentTicketProcess.pm
        'Couldn\'t get ActivityDialogEntityID "%s"!' => 'Couldn\'t get ActivityDialogEntityID "%s"!',
        'No Process configured!' => 'No Process configured!',
        'Process %s is invalid!' => 'Process %s is invalid!',
        'Subaction is invalid!' => 'Subaction is invalid!',
        'Parameter %s is missing in %s.' => 'Parameter %s is missing in %s.',
        'No ActivityDialog configured for %s in _RenderAjax!' => 'No ActivityDialog configured for %s in _RenderAjax!',
        'Got no Start ActivityEntityID or Start ActivityDialogEntityID for Process: %s in _GetParam!' =>
            'Got no Start ActivityEntityID or Start ActivityDialogEntityID for Process: %s in _GetParam!',
        'Couldn\'t get Ticket for TicketID: %s in _GetParam!' => 'Couldn\'t get Ticket for TicketID: %s in _GetParam!',
        'Couldn\'t determine ActivityEntityID. DynamicField or Config isn\'t set properly!' =>
            'Couldn\'t determine ActivityEntityID. DynamicField or Config isn\'t set properly!',
        'Process::Default%s Config Value missing!' => 'Process::Default%s Config Value missing!',
        'Got no ProcessEntityID or TicketID and ActivityDialogEntityID!' =>
            'Got no ProcessEntityID or TicketID and ActivityDialogEntityID!',
        'Can\'t get StartActivityDialog and StartActivityDialog for the ProcessEntityID "%s"!' =>
            'Can\'t get StartActivityDialog and StartActivityDialog for the ProcessEntityID "%s"!',
        'Can\'t get Ticket "%s"!' => 'Can\'t get Ticket "%s"!',
        'Can\'t get ProcessEntityID or ActivityEntityID for Ticket "%s"!' =>
            'Can\'t get ProcessEntityID or ActivityEntityID for Ticket "%s"!',
        'Can\'t get Activity configuration for ActivityEntityID "%s"!' =>
            'Can\'t get Activity configuration for ActivityEntityID "%s"!',
        'Can\'t get ActivityDialog configuration for ActivityDialogEntityID "%s"!' =>
            'Can\'t get ActivityDialog configuration for ActivityDialogEntityID "%s"!',
        'Can\'t get data for Field "%s" of ActivityDialog "%s"!' => 'Can\'t get data for Field "%s" of ActivityDialog "%s"!',
        'PendingTime can just be used if State or StateID is configured for the same ActivityDialog. ActivityDialog: %s!' =>
            'PendingTime can just be used if State or StateID is configured for the same ActivityDialog. ActivityDialog: %s!',
        'Pending Date' => 'Pending Date',
        'for pending* states' => 'for pending* states',
        'ActivityDialogEntityID missing!' => 'ActivityDialogEntityID missing!',
        'Couldn\'t get Config for ActivityDialogEntityID "%s"!' => 'Couldn\'t get Config for ActivityDialogEntityID "%s"!',
        'Couldn\'t use CustomerID as an invisible field.' => '',
        'Missing ProcessEntityID, check your ActivityDialogHeader.tt!' =>
            'Missing ProcessEntityID, check your ActivityDialogHeader.tt!',
        'No StartActivityDialog or StartActivityDialog for Process "%s" configured!' =>
            'No StartActivityDialog or StartActivityDialog for Process "%s" configured!',
        'Couldn\'t create ticket for Process with ProcessEntityID "%s"!' =>
            'Couldn\'t create ticket for Process with ProcessEntityID "%s"!',
        'Couldn\'t set ProcessEntityID "%s" on TicketID "%s"!' => 'Couldn\'t set ProcessEntityID "%s" on TicketID "%s"!',
        'Couldn\'t set ActivityEntityID "%s" on TicketID "%s"!' => 'Couldn\'t set ActivityEntityID "%s" on TicketID "%s"!',
        'Could not store ActivityDialog, invalid TicketID: %s!' => 'Could not store ActivityDialog, invalid TicketID: %s!',
        'Invalid TicketID: %s!' => 'Invalid TicketID: %s!',
        'Missing ActivityEntityID in Ticket %s!' => 'Missing ActivityEntityID in Ticket %s!',
        'This step does not belong anymore the current activity in process for ticket \'%s%s%s\'! Another user changed this ticket in the meantime.' =>
            '',
        'Missing ProcessEntityID in Ticket %s!' => 'Missing ProcessEntityID in Ticket %s!',
        'Could not set DynamicField value for %s of Ticket with ID "%s" in ActivityDialog "%s"!' =>
            'Could not set DynamicField value for %s of Ticket with ID "%s" in ActivityDialog "%s"!',
        'Could not set PendingTime for Ticket with ID "%s" in ActivityDialog "%s"!' =>
            'Could not set PendingTime for Ticket with ID "%s" in ActivityDialog "%s"!',
        'Wrong ActivityDialog Field config: %s can\'t be Display => 1 / Show field (Please change its configuration to be Display => 0 / Do not show field or Display => 2 / Show field as mandatory)!' =>
            'Wrong ActivityDialog Field config: %s can\'t be Display => 1 / Show field (Please change its configuration to be Display => 0 / Do not show field or Display => 2 / Show field as mandatory)!',
        'Could not set %s for Ticket with ID "%s" in ActivityDialog "%s"!' =>
            'Could not set %s for Ticket with ID "%s" in ActivityDialog "%s"!',
        'Default Config for Process::Default%s missing!' => 'Default Config for Process::Default%s missing!',
        'Default Config for Process::Default%s invalid!' => 'Default Config for Process::Default%s invalid!',

        # Perl Module: Kernel/Modules/AgentTicketSearch.pm
        'Untitled' => 'Untitled',
        'Customer Name' => '',
        'Invalid Users' => 'Invalid Users',
        'CSV' => 'CSV',
        'Excel' => 'Excel',

        # Perl Module: Kernel/Modules/AgentTicketService.pm
        'Feature not enabled!' => 'Feature not enabled!',

        # Perl Module: Kernel/Modules/AgentTicketWatcher.pm
        'Feature is not active' => 'Feature is not active',

        # Perl Module: Kernel/Modules/AgentTicketZoom.pm
        'Link Deleted' => 'Link Deleted',
        'Ticket Locked' => 'Ticket Locked',
        'Pending Time Set' => 'Pending Time Set',
        'Dynamic Field Updated' => 'Dynamic Field Updated',
        'Outgoing Email (internal)' => 'Outgoing Email (internal)',
        'Ticket Created' => 'Ticket Created',
        'Type Updated' => 'Type Updated',
        'Escalation Update Time In Effect' => '',
        'Escalation Update Time Stopped' => 'Escalation Update Time Stopped',
        'Escalation First Response Time Stopped' => 'Escalation First Response Time Stopped',
        'Customer Updated' => 'Customer Updated',
        'Internal Chat' => 'Internal Chat',
        'Automatic Follow-Up Sent' => 'Automatic Follow-Up Sent',
        'Note Added' => 'Note Added',
        'Note Added (Customer)' => 'Note Added (Customer)',
        'State Updated' => 'State Updated',
        'Outgoing Answer' => 'Outgoing Answer',
        'Service Updated' => 'Service Updated',
        'Link Added' => 'Link Added',
        'Incoming Customer Email' => 'Incoming Customer Email',
        'Incoming Web Request' => 'Incoming Web Request',
        'Priority Updated' => 'Priority Updated',
        'Ticket Unlocked' => 'Ticket Unlocked',
        'Outgoing Email' => 'Outgoing Email',
        'Title Updated' => 'Title Updated',
        'Ticket Merged' => 'Ticket Merged',
        'Outgoing Phone Call' => 'Outgoing Phone Call',
        'Forwarded Message' => '',
        'Removed User Subscription' => '',
        'Time Accounted' => 'Time Accounted',
        'Incoming Phone Call' => 'Incoming Phone Call',
        'System Request.' => '',
        'Incoming Follow-Up' => 'Incoming Follow-Up',
        'Automatic Reply Sent' => 'Automatic Reply Sent',
        'Automatic Reject Sent' => '',
        'Escalation Solution Time In Effect' => '',
        'Escalation Solution Time Stopped' => 'Escalation Solution Time Stopped',
        'Escalation Response Time In Effect' => '',
        'Escalation Response Time Stopped' => 'Escalation Response Time Stopped',
        'SLA Updated' => 'SLA Updated',
        'Queue Updated' => 'Queue Updated',
        'External Chat' => 'External Chat',
        'Queue Changed' => '',
        'Notification Was Sent' => '',
        'We are sorry, you do not have permissions anymore to access this ticket in its current state.' =>
            '',
        'Can\'t get for ArticleID %s!' => 'Can\'t get for ArticleID %s!',
        'Article filter settings were saved.' => 'Article filter settings were saved.',
        'Event type filter settings were saved.' => 'Event type filter settings were saved.',
        'Need ArticleID!' => 'Need ArticleID!',
        'Invalid ArticleID!' => 'Invalid ArticleID!',
        'Offline' => '',
        'User is currently offline.' => '',
        'User is currently active.' => '',
        'Away' => '',
        'User was inactive for a while.' => '',
        'Unavailable' => '',
        'User set their status to unavailable.' => '',
        'Fields with no group' => 'Fields with no group',
        'View the source for this Article' => 'View the source for this Article',

        # Perl Module: Kernel/Modules/CustomerTicketAttachment.pm
        'FileID and ArticleID are needed!' => 'FileID and ArticleID are needed!',
        'No TicketID for ArticleID (%s)!' => 'No TicketID for ArticleID (%s)!',
        'No such attachment (%s)!' => 'No such attachment (%s)!',

        # Perl Module: Kernel/Modules/CustomerTicketMessage.pm
        'Check SysConfig setting for %s::QueueDefault.' => 'Check SysConfig setting for %s::QueueDefault.',
        'Check SysConfig setting for %s::TicketTypeDefault.' => 'Check SysConfig setting for %s::TicketTypeDefault.',

        # Perl Module: Kernel/Modules/CustomerTicketOverview.pm
        'Need CustomerID!' => 'Need CustomerID!',
        'My Tickets' => 'My Tickets',
        'Company Tickets' => 'Company Tickets',
        'Untitled!' => 'Untitled!',

        # Perl Module: Kernel/Modules/CustomerTicketSearch.pm
        'Please remove the following words because they cannot be used for the search:' =>
            'Please remove the following words because they cannot be used for the search:',

        # Perl Module: Kernel/Modules/CustomerTicketZoom.pm
        'Can\'t reopen ticket, not possible in this queue!' => 'Can\'t reopen ticket, not possible in this queue!',
        'Create a new ticket!' => 'Create a new ticket!',

        # Perl Module: Kernel/Modules/Installer.pm
        'Directory "%s" doesn\'t exist!' => 'Directory "%s" doesn\'t exist!',
        'Configure "Home" in Kernel/Config.pm first!' => 'Configure "Home" in Kernel/Config.pm first!',
        'File "%s/Kernel/Config.pm" not found!' => 'File "%s/Kernel/Config.pm" not found!',
        'Directory "%s" not found!' => 'Directory "%s" not found!',
        'Kernel/Config.pm isn\'t writable!' => 'Kernel/Config.pm isn\'t writable!',
        'If you want to use the installer, set the Kernel/Config.pm writable for the webserver user!' =>
            'If you want to use the installer, set the Kernel/Config.pm writable for the webserver user!',
        'Unknown Check!' => 'Unknown Check!',
        'The check "%s" doesn\'t exist!' => 'The check "%s" doesn\'t exist!',
        'Database %s' => 'Database %s',
        'Configure MySQL' => '',
        'Configure PostgreSQL' => '',
        'Configure Oracle' => '',
        'Unknown database type "%s".' => 'Unknown database type "%s".',
        'Please go back.' => '',
        'Install OTRS - Error' => 'Install OTRS - Error',
        'File "%s/%s.xml" not found!' => 'File "%s/%s.xml" not found!',
        'Contact your Admin!' => 'Contact your Admin!',
        'Syslog' => '',
        'Can\'t write Config file!' => 'Can\'t write Config file!',
        'Unknown Subaction %s!' => 'Unknown Subaction %s!',
        'Can\'t connect to database, Perl module DBD::%s not installed!' =>
            'Can\'t connect to database, Perl module DBD::%s not installed!',
        'Can\'t connect to database, read comment!' => 'Can\'t connect to database, read comment!',
        'Error: Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            'Error: Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.',
        'Error: Please set the value for innodb_log_file_size on your database to at least %s MB (current: %s MB, recommended: %s MB). For more information, please have a look at %s.' =>
            'Error: Please set the value for innodb_log_file_size on your database to at least %s MB (current: %s MB, recommended: %s MB). For more information, please have a look at %s.',

        # Perl Module: Kernel/Modules/PublicRepository.pm
        'Need config Package::RepositoryAccessRegExp' => 'Need config Package::RepositoryAccessRegExp',
        'Authentication failed from %s!' => 'Authentication failed from %s!',

        # Perl Module: Kernel/Output/HTML/ArticleCheck/PGP.pm
        'Sent message crypted to recipient!' => 'Sent message crypted to recipient!',
        '"PGP SIGNED MESSAGE" header found, but invalid!' => '"PGP SIGNED MESSAGE" header found, but invalid!',

        # Perl Module: Kernel/Output/HTML/ArticleCheck/SMIME.pm
        '"S/MIME SIGNED MESSAGE" header found, but invalid!' => '"S/MIME SIGNED MESSAGE" header found, but invalid!',
        'Ticket decrypted before' => 'Ticket decrypted before',
        'Impossible to decrypt: private key for email was not found!' => 'Impossible to decrypt: private key for email was not found!',
        'Successful decryption' => 'Successful decryption',

        # Perl Module: Kernel/Output/HTML/Dashboard/EventsTicketCalendar.pm
        'The start time of a ticket has been set after the end time!' => 'The start time of a ticket has been set after the end time!',

        # Perl Module: Kernel/Output/HTML/Dashboard/News.pm
        'Can\'t connect to OTRS News server!' => '',
        'Can\'t get OTRS News from server!' => '',

        # Perl Module: Kernel/Output/HTML/Dashboard/ProductNotify.pm
        'Can\'t connect to Product News server!' => '',
        'Can\'t get Product News from server!' => '',

        # Perl Module: Kernel/Output/HTML/Dashboard/RSS.pm
        'Can\'t connect to %s!' => '',

        # Perl Module: Kernel/Output/HTML/Dashboard/TicketGeneric.pm
        'sorted ascending' => 'sorted ascending',
        'sorted descending' => 'sorted descending',
        'filter not active' => 'filter not active',
        'filter active' => 'filter active',
        'This ticket has no title or subject' => 'This ticket has no title or subject',

        # Perl Module: Kernel/Output/HTML/Layout.pm
        'We are sorry, you do not have permissions anymore to access this ticket in its current state. You can take one of the following actions:' =>
            'We are sorry, you do not have permissions anymore to access this ticket in its current state. You can take one of the following actions:',
        'No Permission' => 'No Permission',

        # Perl Module: Kernel/Output/HTML/Layout/LinkObject.pm
        'Linked as' => 'Linked as',
        'Search Result' => 'Search Result',

        # Perl Module: Kernel/Output/HTML/LinkObject/Ticket.pm
        'Archive search' => '',

        # Perl Module: Kernel/Output/HTML/Notification/AgentOTRSBusiness.pm
        '%s Upgrade to %s now! %s' => '%s Upgrade to %s now! %s',

        # Perl Module: Kernel/Output/HTML/Notification/CustomerSystemMaintenanceCheck.pm
        'A system maintenance period will start at: ' => 'A system maintenance period will start at: ',

        # Perl Module: Kernel/Output/HTML/Preferences/Language.pm
        '(in process)' => '(in process)',

        # Perl Module: Kernel/Output/HTML/Preferences/NotificationEvent.pm
        'Please make sure you\'ve chosen at least one transport method for mandatory notifications.' =>
            'Please make sure you\'ve chosen at least one transport method for mandatory notifications.',

        # Perl Module: Kernel/Output/HTML/Preferences/OutOfOffice.pm
        'Please specify an end date that is after the start date.' => 'Please specify an end date that is after the start date.',

        # Perl Module: Kernel/Output/HTML/Preferences/Password.pm
        'Please supply your new password!' => 'Please supply your new password!',

        # Perl Module: Kernel/Output/HTML/Statistics/View.pm
        'No (not supported)' => 'No (not supported)',
        'No past complete or the current+upcoming complete relative time value selected.' =>
            'No past complete or the current+upcoming complete relative time value selected.',
        'The selected time period is larger than the allowed time period.' =>
            'The selected time period is larger than the allowed time period.',
        'No time scale value available for the current selected time scale value on the X axis.' =>
            'No time scale value available for the current selected time scale value on the X axis.',
        'The selected date is not valid.' => 'The selected date is not valid.',
        'The selected end time is before the start time.' => 'The selected end time is before the start time.',
        'There is something wrong with your time selection.' => 'There is something wrong with your time selection.',
        'Please select only one element or allow modification at stat generation time.' =>
            'Please select only one element or allow modification at stat generation time.',
        'Please select at least one value of this field or allow modification at stat generation time.' =>
            'Please select at least one value of this field or allow modification at stat generation time.',
        'Please select one element for the X-axis.' => 'Please select one element for the X-axis.',
        'You can only use one time element for the Y axis.' => 'You can only use one time element for the Y axis.',
        'You can only use one or two elements for the Y axis.' => 'You can only use one or two elements for the Y axis.',
        'Please select at least one value of this field.' => 'Please select at least one value of this field.',
        'Please provide a value or allow modification at stat generation time.' =>
            'Please provide a value or allow modification at stat generation time.',
        'Please select a time scale.' => 'Please select a time scale.',
        'Your reporting time interval is too small, please use a larger time scale.' =>
            'Your reporting time interval is too small, please use a larger time scale.',
        'Please remove the following words because they cannot be used for the ticket restrictions: %s.' =>
            'Please remove the following words because they cannot be used for the ticket restrictions: %s.',

        # Perl Module: Kernel/Output/HTML/TicketOverviewMenu/Sort.pm
        'Order by' => 'Order by',

        # Perl Module: Kernel/System/ACL/DB/ACL.pm
        'Couldn\'t read ACL configuration file. Please make sure the file is valid.' =>
            '',

        # Perl Module: Kernel/System/AuthSession.pm
        'You have exceeded the number of concurrent agents - contact sales@otrs.com.' =>
            '',
        'Please note that the session limit is almost reached.' => '',
        'Login rejected! You have exceeded the maximum number of concurrent Agents! Contact sales@otrs.com immediately!' =>
            '',
        'Session per user limit reached!' => 'Session per user limit reached!',

        # Perl Module: Kernel/System/Console/Command/Dev/Tools/Config2Docbook.pm
        'Configuration Options Reference' => 'Configuration Options Reference',
        'This setting can not be changed.' => 'This setting can not be changed.',
        'This setting is not active by default.' => 'This setting is not active by default.',
        'This setting can not be deactivated.' => 'This setting can not be deactivated.',

        # Perl Module: Kernel/System/CustomerUser.pm
        'Customer user "%s" already exists.' => '',

        # Perl Module: Kernel/System/CustomerUser/DB.pm
        'This email address is already in use for another customer user.' =>
            '',

        # Perl Module: Kernel/System/DynamicField/Driver/BaseText.pm
        'e.g. Text or Te*t' => '',

        # Perl Module: Kernel/System/DynamicField/Driver/Checkbox.pm
        'Ignore this field.' => '',

        # Perl Module: Kernel/System/NotificationEvent.pm
        'Couldn\'t read Notification configuration file. Please make sure the file is valid.' =>
            '',

        # Perl Module: Kernel/System/Package.pm
        'not installed' => 'not installed',
        'File is not installed!' => '',
        'File is different!' => '',
        'Can\'t read file!' => '',

        # Perl Module: Kernel/System/ProcessManagement/DB/Process.pm
        'The process "%s" and all of its data has been imported successfully.' =>
            '',

        # Perl Module: Kernel/System/ProcessManagement/DB/Process/State.pm
        'Inactive' => '',
        'FadeAway' => '',

        # Perl Module: Kernel/System/Registration.pm
        'Can\'t get Token from sever' => 'Can\'t get Token from sever',

        # Perl Module: Kernel/System/Stats.pm
        'Sum' => '',

        # Perl Module: Kernel/System/Stats/Dynamic/Ticket.pm
        'State Type' => 'State Type',
        'Created Priority' => 'Created Priority',
        'Created State' => 'Created State',
        'Create Time' => 'Create Time',
        'Close Time' => 'Close Time',
        'Escalation - First Response Time' => 'Escalation - First Response Time',
        'Escalation - Update Time' => 'Escalation - Update Time',
        'Escalation - Solution Time' => 'Escalation - Solution Time',
        'Agent/Owner' => 'Agent/Owner',
        'Created by Agent/Owner' => 'Created by Agent/Owner',
        'CustomerUserLogin' => '',
        'CustomerUserLogin (complex search)' => 'CustomerUserLogin (complex search)',
        'CustomerUserLogin (exact match)' => 'CustomerUserLogin (exact match)',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketAccountedTime.pm
        'Evaluation by' => 'Evaluation by',
        'Ticket/Article Accounted Time' => 'Ticket/Article Accounted Time',
        'Ticket Create Time' => 'Ticket Create Time',
        'Ticket Close Time' => 'Ticket Close Time',
        'Accounted time by Agent' => 'Accounted time by Agent',
        'Total Time' => 'Total Time',
        'Ticket Average' => 'Ticket Average',
        'Ticket Min Time' => 'Ticket Min Time',
        'Ticket Max Time' => 'Ticket Max Time',
        'Number of Tickets' => 'Number of Tickets',
        'Article Average' => 'Article Average',
        'Article Min Time' => 'Article Min Time',
        'Article Max Time' => 'Article Max Time',
        'Number of Articles' => 'Number of Articles',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketList.pm
        'unlimited' => 'unlimited',
        'ascending' => 'ascending',
        'descending' => 'descending',
        'Attributes to be printed' => 'Attributes to be printed',
        'Sort sequence' => 'Sort sequence',
        'State Historic' => 'State Historic',
        'State Type Historic' => 'State Type Historic',
        'Historic Time Range' => 'Historic Time Range',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketSolutionResponseTime.pm
        'Solution Average' => 'Solution Average',
        'Solution Min Time' => 'Solution Min Time',
        'Solution Max Time' => 'Solution Max Time',
        'Solution Average (affected by escalation configuration)' => 'Solution Average (affected by escalation configuration)',
        'Solution Min Time (affected by escalation configuration)' => 'Solution Min Time (affected by escalation configuration)',
        'Solution Max Time (affected by escalation configuration)' => 'Solution Max Time (affected by escalation configuration)',
        'Solution Working Time Average (affected by escalation configuration)' =>
            'Solution Working Time Average (affected by escalation configuration)',
        'Solution Min Working Time (affected by escalation configuration)' =>
            'Solution Min Working Time (affected by escalation configuration)',
        'Solution Max Working Time (affected by escalation configuration)' =>
            'Solution Max Working Time (affected by escalation configuration)',
        'First Response Average (affected by escalation configuration)' =>
            '',
        'First Response Min Time (affected by escalation configuration)' =>
            '',
        'First Response Max Time (affected by escalation configuration)' =>
            '',
        'First Response Working Time Average (affected by escalation configuration)' =>
            '',
        'First Response Min Working Time (affected by escalation configuration)' =>
            '',
        'First Response Max Working Time (affected by escalation configuration)' =>
            '',
        'Number of Tickets (affected by escalation configuration)' => 'Number of Tickets (affected by escalation configuration)',

        # Perl Module: Kernel/System/Stats/Static/StateAction.pm
        'Days' => 'Days',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/TablePresence.pm
        'Table Presence' => 'Table Presence',
        'Internal Error: Could not open file.' => 'Internal Error: Could not open file.',
        'Table Check' => 'Table Check',
        'Internal Error: Could not read file.' => 'Internal Error: Could not read file.',
        'Tables found which are not present in the database.' => 'Tables found which are not present in the database.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mssql/Size.pm
        'Database Size' => 'Database Size',
        'Could not determine database size.' => 'Could not determine database size.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mssql/Version.pm
        'Database Version' => 'Database Version',
        'Could not determine database version.' => 'Could not determine database version.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Charset.pm
        'Client Connection Charset' => 'Client Connection Charset',
        'Setting character_set_client needs to be utf8.' => 'Setting character_set_client needs to be utf8.',
        'Server Database Charset' => 'Server Database Charset',
        'Setting character_set_database needs to be UNICODE or UTF8.' => 'Setting character_set_database needs to be UNICODE or UTF8.',
        'Table Charset' => 'Table Charset',
        'There were tables found which do not have utf8 as charset.' => 'There were tables found which do not have utf8 as charset.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/InnoDBLogFileSize.pm
        'InnoDB Log File Size' => 'InnoDB Log File Size',
        'The setting innodb_log_file_size must be at least 256 MB.' => 'The setting innodb_log_file_size must be at least 256 MB.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/MaxAllowedPacket.pm
        'Maximum Query Size' => 'Maximum Query Size',
        'The setting \'max_allowed_packet\' must be higher than 20 MB.' =>
            'The setting \'max_allowed_packet\' must be higher than 20 MB.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Performance.pm
        'Query Cache Size' => 'Query Cache Size',
        'The setting \'query_cache_size\' should be used (higher than 10 MB but not more than 512 MB).' =>
            'The setting \'query_cache_size\' should be used (higher than 10 MB but not more than 512 MB).',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/StorageEngine.pm
        'Default Storage Engine' => 'Default Storage Engine',
        'Table Storage Engine' => 'Table Storage Engine',
        'Tables with a different storage engine than the default engine were found.' =>
            'Tables with a different storage engine than the default engine were found.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Version.pm
        'MySQL 5.x or higher is required.' => 'MySQL 5.x or higher is required.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/oracle/NLS.pm
        'NLS_LANG Setting' => 'NLS_LANG Setting',
        'NLS_LANG must be set to al32utf8 (e.g. GERMAN_GERMANY.AL32UTF8).' =>
            'NLS_LANG must be set to al32utf8 (e.g. GERMAN_GERMANY.AL32UTF8).',
        'NLS_DATE_FORMAT Setting' => 'NLS_DATE_FORMAT Setting',
        'NLS_DATE_FORMAT must be set to \'YYYY-MM-DD HH24:MI:SS\'.' => 'NLS_DATE_FORMAT must be set to \'YYYY-MM-DD HH24:MI:SS\'.',
        'NLS_DATE_FORMAT Setting SQL Check' => 'NLS_DATE_FORMAT Setting SQL Check',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/Charset.pm
        'Setting client_encoding needs to be UNICODE or UTF8.' => 'Setting client_encoding needs to be UNICODE or UTF8.',
        'Setting server_encoding needs to be UNICODE or UTF8.' => 'Setting server_encoding needs to be UNICODE or UTF8.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/DateStyle.pm
        'Date Format' => 'Date Format',
        'Setting DateStyle needs to be ISO.' => 'Setting DateStyle needs to be ISO.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/Version.pm
        'PostgreSQL 8.x or higher is required.' => 'PostgreSQL 8.x or higher is required.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskPartitionOTRS.pm
        'OTRS Disk Partition' => 'OTRS Disk Partition',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskSpace.pm
        'Disk Usage' => 'Disk Usage',
        'The partition where OTRS is located is almost full.' => 'The partition where OTRS is located is almost full.',
        'The partition where OTRS is located has no disk space problems.' =>
            'The partition where OTRS is located has no disk space problems.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskSpacePartitions.pm
        'Disk Partitions Usage' => 'Disk Partitions Usage',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Distribution.pm
        'Distribution' => 'Distribution',
        'Could not determine distribution.' => 'Could not determine distribution.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/KernelVersion.pm
        'Kernel Version' => 'Kernel Version',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Load.pm
        'System Load' => 'System Load',
        'The system load should be at maximum the number of CPUs the system has (e.g. a load of 8 or less on a system with 8 CPUs is OK).' =>
            'The system load should be at maximum the number of CPUs the system has (e.g. a load of 8 or less on a system with 8 CPUs is OK).',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/PerlModules.pm
        'Perl Modules' => 'Perl Modules',
        'Not all required Perl modules are correctly installed.' => 'Not all required Perl modules are correctly installed.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Swap.pm
        'Free Swap Space (%)' => 'Free Swap Space (%)',
        'No swap enabled.' => 'No swap enabled.',
        'Used Swap Space (MB)' => 'Used Swap Space (MB)',
        'There should be more than 60% free swap space.' => 'There should be more than 60% free swap space.',
        'There should be no more than 200 MB swap space used.' => 'There should be no more than 200 MB swap space used.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/ConfigSettings.pm
        'OTRS' => 'OTRS',
        'Config Settings' => 'Config Settings',
        'Could not determine value.' => 'Could not determine value.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/DaemonRunning.pm
        'Daemon' => 'Daemon',
        'Daemon is running.' => '',
        'Daemon is not running.' => 'Daemon is not running.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/DatabaseRecords.pm
        'Database Records' => 'Database Records',
        'Tickets' => 'Tickets',
        'Ticket History Entries' => 'Ticket History Entries',
        'Articles' => 'Articles',
        'Attachments (DB, Without HTML)' => 'Attachments (DB, Without HTML)',
        'Customers With At Least One Ticket' => 'Customers With At Least One Ticket',
        'Dynamic Field Values' => 'Dynamic Field Values',
        'Invalid Dynamic Fields' => 'Invalid Dynamic Fields',
        'Invalid Dynamic Field Values' => 'Invalid Dynamic Field Values',
        'GenericInterface Webservices' => 'GenericInterface Webservices',
        'Process Tickets' => '',
        'Months Between First And Last Ticket' => 'Months Between First And Last Ticket',
        'Tickets Per Month (avg)' => 'Tickets Per Month (avg)',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/DefaultSOAPUser.pm
        'Default SOAP Username And Password' => 'Default SOAP Username And Password',
        'Security risk: you use the default setting for SOAP::User and SOAP::Password. Please change it.' =>
            'Security risk: you use the default setting for SOAP::User and SOAP::Password. Please change it.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/DefaultUser.pm
        'Default Admin Password' => 'Default Admin Password',
        'Security risk: the agent account root@localhost still has the default password. Please change it or invalidate the account.' =>
            'Security risk: the agent account root@localhost still has the default password. Please change it or invalidate the account.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/ErrorLog.pm
        'Error Log' => 'Error Log',
        'There are error reports in your system log.' => 'There are error reports in your system log.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/FQDN.pm
        'FQDN (domain name)' => 'FQDN (domain name)',
        'Please configure your FQDN setting.' => 'Please configure your FQDN setting.',
        'Domain Name' => 'Domain Name',
        'Your FQDN setting is invalid.' => 'Your FQDN setting is invalid.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/FileSystemWritable.pm
        'File System Writable' => 'File System Writable',
        'The file system on your OTRS partition is not writable.' => 'The file system on your OTRS partition is not writable.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/PackageDeployment.pm
        'Package Installation Status' => 'Package Installation Status',
        'Some packages have locally modified files.' => 'Some packages have locally modified files.',
        'Some packages are not correctly installed.' => 'Some packages are not correctly installed.',
        'Package Verification Status' => '',
        'Some packages are not verified by the OTRS Group! It is recommended not to use this packages.' =>
            '',
        'Package Framework Version Status' => '',
        'Some packages are not allowed for the current framework version.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/PackageList.pm
        'Package List' => 'Package List',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/SessionConfigSettings.pm
        'Session Config Settings' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/SpoolMails.pm
        'Spooled Emails' => '',
        'There are emails in var/spool that OTRS could not process.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/SystemID.pm
        'Your SystemID setting is invalid, it should only contain digits.' =>
            'Your SystemID setting is invalid, it should only contain digits.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/DefaultType.pm
        'Default Ticket Type' => 'Default Ticket Type',
        'The configured default ticket type is invalid or missing. Please change the setting Ticket::Type::Default and select a valid ticket type.' =>
            'The configured default ticket type is invalid or missing. Please change the setting Ticket::Type::Default and select a valid ticket type.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/IndexModule.pm
        'Ticket Index Module' => 'Ticket Index Module',
        'You have more than 60,000 tickets and should use the StaticDB backend. See admin manual (Performance Tuning) for more information.' =>
            'You have more than 60,000 tickets and should use the StaticDB backend. See admin manual (Performance Tuning) for more information.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/InvalidUsersWithLockedTickets.pm
        'Invalid Users with Locked Tickets' => 'Invalid Users with Locked Tickets',
        'There are invalid users with locked tickets.' => 'There are invalid users with locked tickets.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/OpenTickets.pm
        'Open Tickets' => 'Open Tickets',
        'You should not have more than 8,000 open tickets in your system.' =>
            'You should not have more than 8,000 open tickets in your system.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/SearchIndexModule.pm
        'Ticket Search Index Module' => 'Ticket Search Index Module',
        'You have more than 50,000 articles and should use the StaticDB backend. See admin manual (Performance Tuning) for more information.' =>
            'You have more than 50,000 articles and should use the StaticDB backend. See admin manual (Performance Tuning) for more information.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/StaticDBOrphanedRecords.pm
        'Orphaned Records In ticket_lock_index Table' => 'Orphaned Records In ticket_lock_index Table',
        'Table ticket_lock_index contains orphaned records. Please run bin/otrs.Console.pl "Maint::Ticket::QueueIndexCleanup" to clean the StaticDB index.' =>
            'Table ticket_lock_index contains orphaned records. Please run bin/otrs.Console.pl "Maint::Ticket::QueueIndexCleanup" to clean the StaticDB index.',
        'Orphaned Records In ticket_index Table' => 'Orphaned Records In ticket_index Table',
        'Table ticket_index contains orphaned records. Please run bin/otrs.Console.pl "Maint::Ticket::QueueIndexCleanup" to clean the StaticDB index.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/TimeSettings.pm
        'Time Settings' => 'Time Settings',
        'Server time zone' => 'Server time zone',
        'Computed server time offset' => 'Computed server time offset',
        'OTRS TimeZone setting (global time offset)' => 'OTRS TimeZone setting (global time offset)',
        'TimeZone may only be activated for systems running in UTC.' => 'TimeZone may only be activated for systems running in UTC.',
        'OTRS TimeZoneUser setting (per-user time zone support)' => 'OTRS TimeZoneUser setting (per-user time zone support)',
        'TimeZoneUser may only be activated for systems running in UTC that don\'t have an OTRS TimeZone set.' =>
            'TimeZoneUser may only be activated for systems running in UTC that don\'t have an OTRS TimeZone set.',
        'OTRS TimeZone setting for calendar ' => 'OTRS TimeZone setting for calendar ',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/LoadedModules.pm
        'Webserver' => 'Webserver',
        'Loaded Apache Modules' => 'Loaded Apache Modules',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/MPMModel.pm
        'MPM model' => 'MPM model',
        'OTRS requires apache to be run with the \'prefork\' MPM model.' =>
            'OTRS requires apache to be run with the \'prefork\' MPM model.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/Performance.pm
        'CGI Accelerator Usage' => 'CGI Accelerator Usage',
        'You should use FastCGI or mod_perl to increase your performance.' =>
            'You should use FastCGI or mod_perl to increase your performance.',
        'mod_deflate Usage' => 'mod_deflate Usage',
        'Please install mod_deflate to improve GUI speed.' => 'Please install mod_deflate to improve GUI speed.',
        'mod_filter Usage' => 'mod_filter Usage',
        'Please install mod_filter if mod_deflate is used.' => 'Please install mod_filter if mod_deflate is used.',
        'mod_headers Usage' => 'mod_headers Usage',
        'Please install mod_headers to improve GUI speed.' => 'Please install mod_headers to improve GUI speed.',
        'Apache::Reload Usage' => 'Apache::Reload Usage',
        'Apache::Reload or Apache2::Reload should be used as PerlModule and PerlInitHandler to prevent web server restarts when installing and upgrading modules.' =>
            'Apache::Reload or Apache2::Reload should be used as PerlModule and PerlInitHandler to prevent web server restarts when installing and upgrading modules.',
        'Apache2::DBI Usage' => 'Apache2::DBI Usage',
        'Apache2::DBI should be used to get a better performance  with pre-established database connections.' =>
            'Apache2::DBI should be used to get a better performance  with pre-established database connections.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/EnvironmentVariables.pm
        'Environment Variables' => 'Environment Variables',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/InternalWebRequest.pm
        'Support Data Collection' => '',
        'Support data could not be collected from the web server.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Version.pm
        'Webserver Version' => 'Webserver Version',
        'Could not determine webserver version.' => 'Could not determine webserver version.',

        # Perl Module: Kernel/System/SupportDataCollector/PluginAsynchronous/OTRS/ConcurrentUsers.pm
        'Concurrent Users Details' => 'Concurrent Users Details',
        'Concurrent Users' => 'Concurrent Users',

        # Perl Module: Kernel/System/SupportDataCollector/PluginBase.pm
        'Unknown' => 'Unknown',
        'OK' => 'OK',
        'Problem' => 'Problem',

        # Perl Module: Kernel/System/Ticket.pm
        'Reset of unlock time.' => 'Reset of unlock time.',

        # Perl Module: Kernel/System/Ticket/Event/NotificationEvent/Transport/Email.pm
        'PGP sign only' => '',
        'PGP encrypt only' => '',
        'PGP sign and encrypt' => '',
        'SMIME sign only' => '',
        'SMIME encrypt only' => '',
        'SMIME sign and encrypt' => '',
        'PGP and SMIME not enabled.' => '',
        'Skip notification delivery' => '',
        'Send unsigned notification' => '',
        'Send unencrypted notification' => '',

        # Perl Module: Kernel/System/Web/InterfaceAgent.pm
        'Panic, user authenticated but no user data can be found in OTRS DB!! Perhaps the user is invalid.' =>
            'Panic, user authenticated but no user data can be found in OTRS DB!! Perhaps the user is invalid.',
        'Can`t remove SessionID.' => '',
        'Logout successful.' => 'Logout successful.',
        'Panic! Invalid Session!!!' => 'Panic! Invalid Session!!!',
        'No Permission to use this frontend module!' => 'No Permission to use this frontend module!',

        # Perl Module: Kernel/System/Web/InterfaceCustomer.pm
        'Authentication succeeded, but no customer record is found in the customer backend. Please contact the administrator.' =>
            '',
        'Reset password unsuccessful. Please contact the administrator.' =>
            '',
        'Added via Customer Panel (%s)' => 'Added via Customer Panel (%s)',
        'Customer user can\'t be added!' => 'Customer user can\'t be added!',
        'Can\'t send account info!' => 'Can\'t send account info!',

        # Perl Module: Kernel/System/Web/InterfaceInstaller.pm
        'SecureMode active!' => 'SecureMode active!',
        'If you want to re-run the Installer, disable the SecureMode in the SysConfig.' =>
            '',
        'Action "%s" not found!' => 'Action "%s" not found!',

        # Database XML Definition: scripts/database/otrs-initial_insert.xml
        'Group for default access.' => 'Group for default access.',
        'Group of all administrators.' => 'Group of all administrators.',
        'Group for statistics access.' => 'Group for statistics access.',
        'All new state types (default: viewable).' => 'All new state types (default: viewable).',
        'All open state types (default: viewable).' => 'All open state types (default: viewable).',
        'All closed state types (default: not viewable).' => 'All closed state types (default: not viewable).',
        'All \'pending reminder\' state types (default: viewable).' => 'All \'pending reminder\' state types (default: viewable).',
        'All \'pending auto *\' state types (default: viewable).' => 'All \'pending auto *\' state types (default: viewable).',
        'All \'removed\' state types (default: not viewable).' => 'All \'removed\' state types (default: not viewable).',
        'State type for merged tickets (default: not viewable).' => 'State type for merged tickets (default: not viewable).',
        'New ticket created by customer.' => 'New ticket created by customer.',
        'Ticket is closed successful.' => 'Ticket is closed successful.',
        'Ticket is closed unsuccessful.' => 'Ticket is closed unsuccessful.',
        'Open tickets.' => 'Open tickets.',
        'Customer removed ticket.' => 'Customer removed ticket.',
        'Ticket is pending for agent reminder.' => 'Ticket is pending for agent reminder.',
        'Ticket is pending for automatic close.' => 'Ticket is pending for automatic close.',
        'State for merged tickets.' => 'State for merged tickets.',
        'system standard salutation (en)' => 'system standard salutation (en)',
        'Standard Salutation.' => 'Standard Salutation.',
        'system standard signature (en)' => 'system standard signature (en)',
        'Standard Signature.' => 'Standard Signature.',
        'Standard Address.' => 'Standard Address.',
        'Follow-ups for closed tickets are possible. Ticket will be reopened.' =>
            'Follow-ups for closed tickets are possible. Ticket will be reopened.',
        'Follow-ups for closed tickets are not possible. No new ticket will be created.' =>
            'Follow-ups for closed tickets are not possible. No new ticket will be created.',
        'new ticket' => 'new ticket',
        'Follow-ups for closed tickets are not possible. A new ticket will be created..' =>
            'Follow-ups for closed tickets are not possible. A new ticket will be created..',
        'Postmaster queue.' => 'Postmaster queue.',
        'All default incoming tickets.' => 'All default incoming tickets.',
        'All junk tickets.' => 'All junk tickets.',
        'All misc tickets.' => 'All misc tickets.',
        'Automatic reply which will be sent out after a new ticket has been created.' =>
            'Automatic reply which will be sent out after a new ticket has been created.',
        'Automatic reject which will be sent out after a follow-up has been rejected (in case queue follow-up option is "reject").' =>
            'Automatic reject which will be sent out after a follow-up has been rejected (in case queue follow-up option is "reject").',
        'Automatic confirmation which is sent out after a follow-up has been received for a ticket (in case queue follow-up option is "possible").' =>
            'Automatic confirmation which is sent out after a follow-up has been received for a ticket (in case queue follow-up option is "possible").',
        'Automatic response which will be sent out after a follow-up has been rejected and a new ticket has been created (in case queue follow-up option is "new ticket").' =>
            'Automatic response which will be sent out after a follow-up has been rejected and a new ticket has been created (in case queue follow-up option is "new ticket").',
        'Auto remove will be sent out after a customer removed the request.' =>
            'Auto remove will be sent out after a customer removed the request.',
        'default reply (after new ticket has been created)' => 'default reply (after new ticket has been created)',
        'default reject (after follow-up and rejected of a closed ticket)' =>
            'default reject (after follow-up and rejected of a closed ticket)',
        'default follow-up (after a ticket follow-up has been added)' => 'default follow-up (after a ticket follow-up has been added)',
        'default reject/new ticket created (after closed follow-up with new ticket creation)' =>
            'default reject/new ticket created (after closed follow-up with new ticket creation)',
        'Unclassified' => 'Unclassified',
        'tmp_lock' => 'tmp_lock',
        'email-notification-ext' => 'email-notification-ext',
        'email-notification-int' => 'email-notification-int',
        'Ticket create notification' => 'Ticket create notification',
        'You will receive a notification each time a new ticket is created in one of your "My Queues" or "My Services".' =>
            'You will receive a notification each time a new ticket is created in one of your "My Queues" or "My Services".',
        'Ticket follow-up notification (unlocked)' => 'Ticket follow-up notification (unlocked)',
        'You will receive a notification if a customer sends a follow-up to an unlocked ticket which is in your "My Queues" or "My Services".' =>
            'You will receive a notification if a customer sends a follow-up to an unlocked ticket which is in your "My Queues" or "My Services".',
        'Ticket follow-up notification (locked)' => 'Ticket follow-up notification (locked)',
        'You will receive a notification if a customer sends a follow-up to a locked ticket of which you are the ticket owner or responsible.' =>
            'You will receive a notification if a customer sends a follow-up to a locked ticket of which you are the ticket owner or responsible.',
        'You will receive a notification as soon as a ticket owned by you is automatically unlocked.' =>
            'You will receive a notification as soon as a ticket owned by you is automatically unlocked.',
        'Ticket owner update notification' => 'Ticket owner update notification',
        'Ticket responsible update notification' => 'Ticket responsible update notification',
        'Ticket new note notification' => 'Ticket new note notification',
        'Ticket queue update notification' => 'Ticket queue update notification',
        'You will receive a notification if a ticket is moved into one of your "My Queues".' =>
            'You will receive a notification if a ticket is moved into one of your "My Queues".',
        'Ticket pending reminder notification (locked)' => 'Ticket pending reminder notification (locked)',
        'Ticket pending reminder notification (unlocked)' => 'Ticket pending reminder notification (unlocked)',
        'Ticket escalation notification' => 'Ticket escalation notification',
        'Ticket escalation warning notification' => 'Ticket escalation warning notification',
        'Ticket service update notification' => 'Ticket service update notification',
        'You will receive a notification if a ticket\'s service is changed to one of your "My Services".' =>
            'You will receive a notification if a ticket\'s service is changed to one of your "My Services".',

        # SysConfig
        '
Dear Customer,

Unfortunately we could not detect a valid ticket number
in your subject, so this email can\'t be processed.

Please create a new ticket via the customer panel.

Thanks for your help!

 Your Helpdesk Team
' => '
Dear Customer,

Unfortunately we could not detect a valid ticket number
in your subject, so this email can\'t be processed.

Please create a new ticket via the customer panel.

Thanks for your help!

 Your Helpdesk Team
',
        ' (work units)' => ' (work units)',
        '"%s" notification was sent to "%s" by "%s".' => '"%s" notification was sent to "%s" by "%s".',
        '"Slim" skin which tries to save screen space for power users.' =>
            '"Slim" skin which tries to save screen space for power users.',
        '%s' => '%s',
        '%s time unit(s) accounted. Now total %s time unit(s).' => '%s time unit(s) accounted. Now total %s time unit(s).',
        '(UserLogin) Firstname Lastname' => '(UserLogin) Firstname Lastname',
        '(UserLogin) Lastname Firstname' => '(UserLogin) Lastname Firstname',
        '(UserLogin) Lastname, Firstname' => '(UserLogin) Lastname, Firstname',
        '*** out of office until %s (%s d left) ***' => '*** out of office until %s (%s d left) ***',
        '100 (Expert)' => '100 (Expert)',
        '200 (Advanced)' => '200 (Advanced)',
        '300 (Beginner)' => '300 (Beginner)',
        'A TicketWatcher Module.' => 'A TicketWatcher Module.',
        'A Website' => 'A Website',
        'A list of dynamic fields that are merged into the main ticket during a merge operation. Only dynamic fields that are empty in the main ticket will be set.' =>
            'A list of dynamic fields that are merged into the main ticket during a merge operation. Only dynamic fields that are empty in the main ticket will be set.',
        'A picture' => 'A picture',
        'ACL module that allows closing parent tickets only if all its children are already closed ("State" shows which states are not available for the parent ticket until all child tickets are closed).' =>
            'ACL module that allows closing parent tickets only if all its children are already closed ("State" shows which states are not available for the parent ticket until all child tickets are closed).',
        'Access Control Lists (ACL)' => 'Access Control Lists (ACL)',
        'AccountedTime' => 'AccountedTime',
        'Activates a blinking mechanism of the queue that contains the oldest ticket.' =>
            'Activates a blinking mechanism of the queue that contains the oldest ticket.',
        'Activates lost password feature for agents, in the agent interface.' =>
            'Activates lost password feature for agents, in the agent interface.',
        'Activates lost password feature for customers.' => 'Activates lost password feature for customers.',
        'Activates support for customer groups.' => 'Activates support for customer groups.',
        'Activates the article filter in the zoom view to specify which articles should be shown.' =>
            'Activates the article filter in the zoom view to specify which articles should be shown.',
        'Activates the available themes on the system. Value 1 means active, 0 means inactive.' =>
            'Activates the available themes on the system. Value 1 means active, 0 means inactive.',
        'Activates the ticket archive system search in the customer interface.' =>
            'Activates the ticket archive system search in the customer interface.',
        'Activates the ticket archive system to have a faster system by moving some tickets out of the daily scope. To search for these tickets, the archive flag has to be enabled in the ticket search.' =>
            'Activates the ticket archive system to have a faster system by moving some tickets out of the daily scope. To search for these tickets, the archive flag has to be enabled in the ticket search.',
        'Activates time accounting.' => 'Activates time accounting.',
        'ActivityID' => 'ActivityID',
        'Add an inbound phone call to this ticket' => 'Add an inbound phone call to this ticket',
        'Add an outbound phone call to this ticket' => 'Add an outbound phone call to this ticket',
        'Added email. %s' => 'Added email. %s',
        'Added link to ticket "%s".' => 'Added link to ticket "%s".',
        'Added note (%s)' => 'Added note (%s)',
        'Added subscription for user "%s".' => 'Added subscription for user "%s".',
        'Address book of CustomerUser sources.' => 'Address book of CustomerUser sources.',
        'Adds a suffix with the actual year and month to the OTRS log file. A logfile for every month will be created.' =>
            'Adds a suffix with the actual year and month to the OTRS log file. A logfile for every month will be created.',
        'Adds customers email addresses to recipients in the ticket compose screen of the agent interface. The customers email address won\'t be added if the article type is email-internal.' =>
            'Adds customers email addresses to recipients in the ticket compose screen of the agent interface. The customers email address won\'t be added if the article type is email-internal.',
        'Adds the one time vacation days for the indicated calendar. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Adds the one time vacation days for the indicated calendar. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).',
        'Adds the one time vacation days. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Adds the one time vacation days. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).',
        'Adds the permanent vacation days for the indicated calendar. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Adds the permanent vacation days for the indicated calendar. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).',
        'Adds the permanent vacation days. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Adds the permanent vacation days. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).',
        'Admin Area.' => 'Admin Area.',
        'After' => 'After',
        'Agent Name' => 'Agent Name',
        'Agent Name + FromSeparator + System Address Display Name' => 'Agent Name + FromSeparator + System Address Display Name',
        'Agent Preferences.' => 'Agent Preferences.',
        'Agent called customer.' => 'Agent called customer.',
        'Agent interface article notification module to check PGP.' => 'Agent interface article notification module to check PGP.',
        'Agent interface article notification module to check S/MIME.' =>
            'Agent interface article notification module to check S/MIME.',
        'Agent interface module to access CIC search via nav bar. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Agent interface module to access CIC search via nav bar. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".',
        'Agent interface module to access fulltext search via nav bar. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Agent interface module to access fulltext search via nav bar. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".',
        'Agent interface module to access search profiles via nav bar. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Agent interface module to access search profiles via nav bar. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".',
        'Agent interface module to check incoming emails in the Ticket-Zoom-View if the S/MIME-key is available and true.' =>
            'Agent interface module to check incoming emails in the Ticket-Zoom-View if the S/MIME-key is available and true.',
        'Agent interface notification module to see the number of locked tickets. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Agent interface notification module to see the number of locked tickets. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".',
        'Agent interface notification module to see the number of tickets an agent is responsible for. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Agent interface notification module to see the number of tickets an agent is responsible for. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".',
        'Agent interface notification module to see the number of tickets in My Services. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Agent interface notification module to see the number of tickets in My Services. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".',
        'Agent interface notification module to see the number of watched tickets. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Agent interface notification module to see the number of watched tickets. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".',
        'AgentCustomerSearch' => 'AgentCustomerSearch',
        'AgentCustomerSearch.' => 'AgentCustomerSearch.',
        'AgentUserSearch' => 'AgentUserSearch',
        'AgentUserSearch.' => 'AgentUserSearch.',
        'Agents <-> Groups' => 'Agents <-> Groups',
        'Agents <-> Roles' => 'Agents <-> Roles',
        'All customer users of a CustomerID' => 'All customer users of a CustomerID',
        'Allows adding notes in the close ticket screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Allows adding notes in the close ticket screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.',
        'Allows adding notes in the ticket free text screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Allows adding notes in the ticket free text screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.',
        'Allows adding notes in the ticket note screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Allows adding notes in the ticket note screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.',
        'Allows adding notes in the ticket owner screen of a zoomed ticket in the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Allows adding notes in the ticket owner screen of a zoomed ticket in the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.',
        'Allows adding notes in the ticket pending screen of a zoomed ticket in the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Allows adding notes in the ticket pending screen of a zoomed ticket in the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.',
        'Allows adding notes in the ticket priority screen of a zoomed ticket in the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Allows adding notes in the ticket priority screen of a zoomed ticket in the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.',
        'Allows adding notes in the ticket responsible screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Allows adding notes in the ticket responsible screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.',
        'Allows agents to exchange the axis of a stat if they generate one.' =>
            'Allows agents to exchange the axis of a stat if they generate one.',
        'Allows agents to generate individual-related stats.' => 'Allows agents to generate individual-related stats.',
        'Allows choosing between showing the attachments of a ticket in the browser (inline) or just make them downloadable (attachment).' =>
            'Allows choosing between showing the attachments of a ticket in the browser (inline) or just make them downloadable (attachment).',
        'Allows choosing the next compose state for customer tickets in the customer interface.' =>
            'Allows choosing the next compose state for customer tickets in the customer interface.',
        'Allows customers to change the ticket priority in the customer interface.' =>
            'Allows customers to change the ticket priority in the customer interface.',
        'Allows customers to set the ticket SLA in the customer interface.' =>
            'Allows customers to set the ticket SLA in the customer interface.',
        'Allows customers to set the ticket priority in the customer interface.' =>
            'Allows customers to set the ticket priority in the customer interface.',
        'Allows customers to set the ticket queue in the customer interface. If this is set to \'No\', QueueDefault should be configured.' =>
            'Allows customers to set the ticket queue in the customer interface. If this is set to \'No\', QueueDefault should be configured.',
        'Allows customers to set the ticket service in the customer interface.' =>
            'Allows customers to set the ticket service in the customer interface.',
        'Allows customers to set the ticket type in the customer interface. If this is set to \'No\', TicketTypeDefault should be configured.' =>
            'Allows customers to set the ticket type in the customer interface. If this is set to \'No\', TicketTypeDefault should be configured.',
        'Allows default services to be selected also for non existing customers.' =>
            'Allows default services to be selected also for non existing customers.',
        'Allows defining new types for ticket (if ticket type feature is enabled).' =>
            'Allows defining new types for ticket (if ticket type feature is enabled).',
        'Allows defining services and SLAs for tickets (e. g. email, desktop, network, ...), and escalation attributes for SLAs (if ticket service/SLA feature is enabled).' =>
            'Allows defining services and SLAs for tickets (e. g. email, desktop, network, ...), and escalation attributes for SLAs (if ticket service/SLA feature is enabled).',
        'Allows extended search conditions in ticket search of the agent interface. With this feature you can search e. g. ticket title with this kind of conditions like "(*key1*&&*key2*)" or "(*key1*||*key2*)".' =>
            '',
        'Allows extended search conditions in ticket search of the customer interface. With this feature you can search e. g. ticket title with this kind of conditions like "(*key1*&&*key2*)" or "(*key1*||*key2*)".' =>
            '',
        'Allows extended search conditions in ticket search of the generic agent interface. With this feature you can search e. g. ticket title with this kind of conditions like "(*key1*&&*key2*)" or "(*key1*||*key2*)".' =>
            'Allows extended search conditions in ticket search of the generic agent interface. With this feature you can search e. g. ticket title with this kind of conditions like "(*key1*&&*key2*)" or "(*key1*||*key2*)".',
        'Allows having a medium format ticket overview (CustomerInfo => 1 - shows also the customer information).' =>
            'Allows having a medium format ticket overview (CustomerInfo => 1 - shows also the customer information).',
        'Allows having a small format ticket overview (CustomerInfo => 1 - shows also the customer information).' =>
            'Allows having a small format ticket overview (CustomerInfo => 1 - shows also the customer information).',
        'Allows invalid agents to generate individual-related stats.' => 'Allows invalid agents to generate individual-related stats.',
        'Allows the administrators to login as other customers, via the customer user administration panel.' =>
            'Allows the administrators to login as other customers, via the customer user administration panel.',
        'Allows the administrators to login as other users, via the users administration panel.' =>
            'Allows the administrators to login as other users, via the users administration panel.',
        'Allows to set a new ticket state in the move ticket screen of the agent interface.' =>
            'Allows to set a new ticket state in the move ticket screen of the agent interface.',
        'Always show RichText if available' => 'Always show RichText if available',
        'Arabic (Saudi Arabia)' => 'Arabic (Saudi Arabia)',
        'Archive state changed: "%s"' => 'Archive state changed: "%s"',
        'ArticleTree' => 'ArticleTree',
        'Attachments <-> Templates' => 'Attachments <-> Templates',
        'Auto Responses <-> Queues' => 'Auto Responses <-> Queues',
        'AutoFollowUp sent to "%s".' => 'AutoFollowUp sent to "%s".',
        'AutoReject sent to "%s".' => 'AutoReject sent to "%s".',
        'AutoReply sent to "%s".' => 'AutoReply sent to "%s".',
        'Automated line break in text messages after x number of chars.' =>
            'Automated line break in text messages after x number of chars.',
        'Automatically lock and set owner to current Agent after opening the move ticket screen of the agent interface.' =>
            'Automatically lock and set owner to current Agent after opening the move ticket screen of the agent interface.',
        'Automatically lock and set owner to current Agent after selecting for an Bulk Action.' =>
            'Automatically lock and set owner to current Agent after selecting for an Bulk Action.',
        'Automatically sets the owner of a ticket as the responsible for it (if ticket responsible feature is enabled). This will only work by manually actions of the logged in user. It does not work for automated actions e.g. GenericAgent, Postmaster and GenericInterface.' =>
            'Automatically sets the owner of a ticket as the responsible for it (if ticket responsible feature is enabled). This will only work by manually actions of the logged in user. It does not work for automated actions e.g. GenericAgent, Postmaster and GenericInterface.',
        'Automatically sets the responsible of a ticket (if it is not set yet) after the first owner update.' =>
            'Automatically sets the responsible of a ticket (if it is not set yet) after the first owner update.',
        'Balanced white skin by Felix Niklas (slim version).' => 'Balanced white skin by Felix Niklas (slim version).',
        'Balanced white skin by Felix Niklas.' => 'Balanced white skin by Felix Niklas.',
        'Based on global RichText setting' => 'Based on global RichText setting',
        'Basic fulltext index settings. Execute "bin/otrs.Console.pl Maint::Ticket::FulltextIndexRebuild" in order to generate a new index.' =>
            'Basic fulltext index settings. Execute "bin/otrs.Console.pl Maint::Ticket::FulltextIndexRebuild" in order to generate a new index.',
        'Blocks all the incoming emails that do not have a valid ticket number in subject with From: @example.com address.' =>
            'Blocks all the incoming emails that do not have a valid ticket number in subject with From: @example.com address.',
        'Bounced to "%s".' => 'Bounced to "%s".',
        'Builds an article index right after the article\'s creation.' =>
            'Builds an article index right after the article\'s creation.',
        'Bulgarian' => 'Bulgarian',
        'CMD example setup. Ignores emails where external CMD returns some output on STDOUT (email will be piped into STDIN of some.bin).' =>
            'CMD example setup. Ignores emails where external CMD returns some output on STDOUT (email will be piped into STDIN of some.bin).',
        'Cache time in seconds for agent authentication in the GenericInterface.' =>
            'Cache time in seconds for agent authentication in the GenericInterface.',
        'Cache time in seconds for customer authentication in the GenericInterface.' =>
            'Cache time in seconds for customer authentication in the GenericInterface.',
        'Cache time in seconds for the DB ACL backend.' => 'Cache time in seconds for the DB ACL backend.',
        'Cache time in seconds for the DB process backend.' => 'Cache time in seconds for the DB process backend.',
        'Cache time in seconds for the SSL certificate attributes.' => 'Cache time in seconds for the SSL certificate attributes.',
        'Cache time in seconds for the ticket process navigation bar output module.' =>
            'Cache time in seconds for the ticket process navigation bar output module.',
        'Cache time in seconds for the web service config backend.' => 'Cache time in seconds for the web service config backend.',
        'Catalan' => 'Catalan',
        'Change password' => 'Change password',
        'Change queue!' => 'Change queue!',
        'Change the customer for this ticket' => 'Change the customer for this ticket',
        'Change the free fields for this ticket' => 'Change the free fields for this ticket',
        'Change the priority for this ticket' => 'Change the priority for this ticket',
        'Change the responsible for this ticket' => 'Change the responsible for this ticket',
        'Changed priority from "%s" (%s) to "%s" (%s).' => 'Changed priority from "%s" (%s) to "%s" (%s).',
        'Changes the owner of tickets to everyone (useful for ASP). Normally only agent with rw permissions in the queue of the ticket will be shown.' =>
            'Changes the owner of tickets to everyone (useful for ASP). Normally only agent with rw permissions in the queue of the ticket will be shown.',
        'Checkbox' => 'Checkbox',
        'Checks if an E-Mail is a followup to an existing ticket by searching the subject for a valid ticket number.' =>
            'Checks if an E-Mail is a followup to an existing ticket by searching the subject for a valid ticket number.',
        'Checks the SystemID in ticket number detection for follow-ups (use "No" if SystemID has been changed after using the system).' =>
            'Checks the SystemID in ticket number detection for follow-ups (use "No" if SystemID has been changed after using the system).',
        'Checks the availability of OTRS Business Solution™ for this system.' =>
            'Checks the availability of OTRS Business Solution™ for this system.',
        'Checks the entitlement status of OTRS Business Solution™.' => 'Checks the entitlement status of OTRS Business Solution™.',
        'Chinese (Simplified)' => 'Chinese (Simplified)',
        'Chinese (Traditional)' => 'Chinese (Traditional)',
        'Choose for which kind of ticket changes you want to receive notifications.' =>
            'Choose for which kind of ticket changes you want to receive notifications.',
        'Closed tickets (customer user)' => 'Closed tickets (customer user)',
        'Closed tickets (customer)' => 'Closed tickets (customer)',
        'Cloud Services' => 'Cloud Services',
        'Cloud service admin module registration for the transport layer.' =>
            'Cloud service admin module registration for the transport layer.',
        'Collect support data for asynchronous plug-in modules.' => 'Collect support data for asynchronous plug-in modules.',
        'Column ticket filters for Ticket Overviews type "Small".' => 'Column ticket filters for Ticket Overviews type "Small".',
        'Columns that can be filtered in the escalation view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            'Columns that can be filtered in the escalation view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.',
        'Columns that can be filtered in the locked view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            'Columns that can be filtered in the locked view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.',
        'Columns that can be filtered in the queue view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            'Columns that can be filtered in the queue view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.',
        'Columns that can be filtered in the responsible view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            'Columns that can be filtered in the responsible view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.',
        'Columns that can be filtered in the service view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            'Columns that can be filtered in the service view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.',
        'Columns that can be filtered in the status view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            'Columns that can be filtered in the status view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.',
        'Columns that can be filtered in the ticket search result view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            'Columns that can be filtered in the ticket search result view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.',
        'Columns that can be filtered in the watch view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            'Columns that can be filtered in the watch view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.',
        'Comment for new history entries in the customer interface.' => 'Comment for new history entries in the customer interface.',
        'Comment2' => 'Comment2',
        'Communication' => 'Communication',
        'Company Status' => 'Company Status',
        'Company Tickets.' => 'Company Tickets.',
        'Company name which will be included in outgoing emails as an X-Header.' =>
            'Company name which will be included in outgoing emails as an X-Header.',
        'Compat module for AgentZoom to AgentTicketZoom.' => 'Compat module for AgentZoom to AgentTicketZoom.',
        'Complex' => 'Complex',
        'Configure Processes.' => 'Configure Processes.',
        'Configure and manage ACLs.' => 'Configure and manage ACLs.',
        'Configure any additional readonly mirror databases that you want to use.' =>
            'Configure any additional readonly mirror databases that you want to use.',
        'Configure sending of support data to OTRS Group for improved support.' =>
            'Configure sending of support data to OTRS Group for improved support.',
        'Configure which screen should be shown after a new ticket has been created.' =>
            'Configure which screen should be shown after a new ticket has been created.',
        'Configure your own log text for PGP.' => 'Configure your own log text for PGP.',
        'Configures a default TicketDynamicField setting. "Name" defines the dynamic field which should be used, "Value" is the data that will be set, and "Event" defines the trigger event. Please check the developer manual (http://otrs.github.io/doc/), chapter "Ticket Event Module".' =>
            'Configures a default TicketDynamicField setting. "Name" defines the dynamic field which should be used, "Value" is the data that will be set, and "Event" defines the trigger event. Please check the developer manual (http://otrs.github.io/doc/), chapter "Ticket Event Module".',
        'Controls how to display the ticket history entries as readable values.' =>
            'Controls how to display the ticket history entries as readable values.',
        'Controls if CustomerID is automatically copied from the sender address for unknown customers.' =>
            '',
        'Controls if CustomerID is read-only in the agent interface.' => '',
        'Controls if customers have the ability to sort their tickets.' =>
            'Controls if customers have the ability to sort their tickets.',
        'Controls if more than one from entry can be set in the new phone ticket in the agent interface.' =>
            'Controls if more than one from entry can be set in the new phone ticket in the agent interface.',
        'Controls if the admin is allowed to import a saved system configuration in SysConfig.' =>
            'Controls if the admin is allowed to import a saved system configuration in SysConfig.',
        'Controls if the admin is allowed to make changes to the database via AdminSelectBox.' =>
            'Controls if the admin is allowed to make changes to the database via AdminSelectBox.',
        'Controls if the ticket and article seen flags are removed when a ticket is archived.' =>
            'Controls if the ticket and article seen flags are removed when a ticket is archived.',
        'Converts HTML mails into text messages.' => 'Converts HTML mails into text messages.',
        'Create New process ticket.' => 'Create New process ticket.',
        'Create and manage Service Level Agreements (SLAs).' => 'Create and manage Service Level Agreements (SLAs).',
        'Create and manage agents.' => 'Create and manage agents.',
        'Create and manage attachments.' => 'Create and manage attachments.',
        'Create and manage customer users.' => 'Create and manage customer users.',
        'Create and manage customers.' => 'Create and manage customers.',
        'Create and manage dynamic fields.' => 'Create and manage dynamic fields.',
        'Create and manage groups.' => 'Create and manage groups.',
        'Create and manage queues.' => 'Create and manage queues.',
        'Create and manage responses that are automatically sent.' => 'Create and manage responses that are automatically sent.',
        'Create and manage roles.' => 'Create and manage roles.',
        'Create and manage salutations.' => 'Create and manage salutations.',
        'Create and manage services.' => 'Create and manage services.',
        'Create and manage signatures.' => 'Create and manage signatures.',
        'Create and manage templates.' => 'Create and manage templates.',
        'Create and manage ticket notifications.' => 'Create and manage ticket notifications.',
        'Create and manage ticket priorities.' => 'Create and manage ticket priorities.',
        'Create and manage ticket states.' => 'Create and manage ticket states.',
        'Create and manage ticket types.' => 'Create and manage ticket types.',
        'Create and manage web services.' => 'Create and manage web services.',
        'Create new Ticket.' => 'Create new Ticket.',
        'Create new email ticket and send this out (outbound).' => 'Create new email ticket and send this out (outbound).',
        'Create new email ticket.' => 'Create new email ticket.',
        'Create new phone ticket (inbound).' => 'Create new phone ticket (inbound).',
        'Create new phone ticket.' => 'Create new phone ticket.',
        'Create new process ticket.' => 'Create new process ticket.',
        'Create tickets.' => 'Create tickets.',
        'Croatian' => 'Croatian',
        'Custom RSS Feed' => 'Custom RSS Feed',
        'Custom text for the page shown to customers that have no tickets yet (if you need those text translated add them to a custom translation module).' =>
            'Custom text for the page shown to customers that have no tickets yet (if you need those text translated add them to a custom translation module).',
        'Customer Administration' => 'Customer Administration',
        'Customer Information Center Search.' => 'Customer Information Center Search.',
        'Customer Information Center.' => 'Customer Information Center.',
        'Customer Ticket Print Module.' => 'Customer Ticket Print Module.',
        'Customer User <-> Groups' => 'Customer User <-> Groups',
        'Customer User <-> Services' => 'Customer User <-> Services',
        'Customer User Administration' => 'Customer User Administration',
        'Customer Users' => 'Customer Users',
        'Customer called us.' => 'Customer called us.',
        'Customer item (icon) which shows the closed tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            'Customer item (icon) which shows the closed tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.',
        'Customer item (icon) which shows the open tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            'Customer item (icon) which shows the open tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.',
        'Customer preferences.' => 'Customer preferences.',
        'Customer request via web.' => 'Customer request via web.',
        'Customer ticket overview' => 'Customer ticket overview',
        'Customer ticket search.' => 'Customer ticket search.',
        'Customer ticket zoom' => 'Customer ticket zoom',
        'Customer user search' => 'Customer user search',
        'CustomerID search' => 'CustomerID search',
        'CustomerName' => 'CustomerName',
        'CustomerUser' => 'CustomerUser',
        'Customers <-> Groups' => 'Customers <-> Groups',
        'Customizable stop words for fulltext index. These words will be removed from the search index.' =>
            'Customizable stop words for fulltext index. These words will be removed from the search index.',
        'Czech' => 'Czech',
        'Danish' => 'Danish',
        'Data used to export the search result in CSV format.' => 'Data used to export the search result in CSV format.',
        'Date / Time' => 'Date / Time',
        'Debug' => 'Debug',
        'Debugs the translation set. If this is set to "Yes" all strings (text) without translations are written to STDERR. This can be helpful when you are creating a new translation file. Otherwise, this option should remain set to "No".' =>
            'Debugs the translation set. If this is set to "Yes" all strings (text) without translations are written to STDERR. This can be helpful when you are creating a new translation file. Otherwise, this option should remain set to "No".',
        'Default' => 'Default',
        'Default (Slim)' => 'Default (Slim)',
        'Default ACL values for ticket actions.' => 'Default ACL values for ticket actions.',
        'Default ProcessManagement entity prefixes for entity IDs that are automatically generated.' =>
            'Default ProcessManagement entity prefixes for entity IDs that are automatically generated.',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimePointFormat=year;TicketCreateTimePointStart=Last;TicketCreateTimePoint=2;".' =>
            'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimePointFormat=year;TicketCreateTimePointStart=Last;TicketCreateTimePoint=2;".',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimeStartYear=2010;TicketCreateTimeStartMonth=10;TicketCreateTimeStartDay=4;TicketCreateTimeStopYear=2010;TicketCreateTimeStopMonth=11;TicketCreateTimeStopDay=3;".' =>
            'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimeStartYear=2010;TicketCreateTimeStartMonth=10;TicketCreateTimeStartDay=4;TicketCreateTimeStopYear=2010;TicketCreateTimeStopMonth=11;TicketCreateTimeStopDay=3;".',
        'Default display type for recipient (To,Cc) names in AgentTicketZoom and CustomerTicketZoom.' =>
            'Default display type for recipient (To,Cc) names in AgentTicketZoom and CustomerTicketZoom.',
        'Default display type for sender (From) names in AgentTicketZoom and CustomerTicketZoom.' =>
            'Default display type for sender (From) names in AgentTicketZoom and CustomerTicketZoom.',
        'Default loop protection module.' => 'Default loop protection module.',
        'Default queue ID used by the system in the agent interface.' => 'Default queue ID used by the system in the agent interface.',
        'Default skin for the agent interface (slim version).' => 'Default skin for the agent interface (slim version).',
        'Default skin for the agent interface.' => 'Default skin for the agent interface.',
        'Default skin for the customer interface.' => 'Default skin for the customer interface.',
        'Default ticket ID used by the system in the agent interface.' =>
            'Default ticket ID used by the system in the agent interface.',
        'Default ticket ID used by the system in the customer interface.' =>
            'Default ticket ID used by the system in the customer interface.',
        'Default value for NameX' => 'Default value for NameX',
        'Define Actions where a settings button is available in the linked objects widget (LinkObject::ViewMode = "complex"). Please note that these Actions must have registered the following JS and CSS files: Core.AllocationList.css, Core.UI.AllocationList.js, Core.UI.Table.Sort.js, Core.Agent.TableFilters.js.' =>
            'Define Actions where a settings button is available in the linked objects widget (LinkObject::ViewMode = "complex"). Please note that these Actions must have registered the following JS and CSS files: Core.AllocationList.css, Core.UI.AllocationList.js, Core.UI.Table.Sort.js, Core.Agent.TableFilters.js.',
        'Define a filter for html output to add links behind a defined string. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Define a filter for html output to add links behind a defined string. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.',
        'Define a mapping between variables of the customer user data (keys) and dynamic fields of a ticket (values). The purpose is to store customer user data in ticket dynamic fields. The dynamic fields must be present in the system and should be enabled for AgentTicketFreeText, so that they can be set/updated manually by the agent. They mustn\'t be enabled for AgentTicketPhone, AgentTicketEmail and AgentTicketCustomer. If they were, they would have precedence over the automatically set values. To use this mapping, you have to also activate the next setting below.' =>
            'Define a mapping between variables of the customer user data (keys) and dynamic fields of a ticket (values). The purpose is to store customer user data in ticket dynamic fields. The dynamic fields must be present in the system and should be enabled for AgentTicketFreeText, so that they can be set/updated manually by the agent. They mustn\'t be enabled for AgentTicketPhone, AgentTicketEmail and AgentTicketCustomer. If they were, they would have precedence over the automatically set values. To use this mapping, you have to also activate the next setting below.',
        'Define dynamic field name for end time. This field has to be manually added to the system as Ticket: "Date / Time" and must be activated in ticket creation screens and/or in any other ticket action screens.' =>
            'Define dynamic field name for end time. This field has to be manually added to the system as Ticket: "Date / Time" and must be activated in ticket creation screens and/or in any other ticket action screens.',
        'Define dynamic field name for start time. This field has to be manually added to the system as Ticket: "Date / Time" and must be activated in ticket creation screens and/or in any other ticket action screens.' =>
            'Define dynamic field name for start time. This field has to be manually added to the system as Ticket: "Date / Time" and must be activated in ticket creation screens and/or in any other ticket action screens.',
        'Define the max depth of queues.' => 'Define the max depth of queues.',
        'Define the queue comment 2.' => 'Define the queue comment 2.',
        'Define the service comment 2.' => 'Define the service comment 2.',
        'Define the sla comment 2.' => 'Define the sla comment 2.',
        'Define the start day of the week for the date picker for the indicated calendar.' =>
            'Define the start day of the week for the date picker for the indicated calendar.',
        'Define the start day of the week for the date picker.' => 'Define the start day of the week for the date picker.',
        'Define which columns are shown in the linked tickets widget (LinkObject::ViewMode = "complex"). Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.' =>
            'Define which columns are shown in the linked tickets widget (LinkObject::ViewMode = "complex"). Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.',
        'Defines a customer item, which generates a LinkedIn icon at the end of a customer info block.' =>
            'Defines a customer item, which generates a LinkedIn icon at the end of a customer info block.',
        'Defines a customer item, which generates a XING icon at the end of a customer info block.' =>
            'Defines a customer item, which generates a XING icon at the end of a customer info block.',
        'Defines a customer item, which generates a google icon at the end of a customer info block.' =>
            'Defines a customer item, which generates a google icon at the end of a customer info block.',
        'Defines a customer item, which generates a google maps icon at the end of a customer info block.' =>
            'Defines a customer item, which generates a google maps icon at the end of a customer info block.',
        'Defines a default list of words, that are ignored by the spell checker.' =>
            'Defines a default list of words, that are ignored by the spell checker.',
        'Defines a filter for html output to add links behind CVE numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Defines a filter for html output to add links behind CVE numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.',
        'Defines a filter for html output to add links behind MSBulletin numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Defines a filter for html output to add links behind MSBulletin numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.',
        'Defines a filter for html output to add links behind a defined string. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Defines a filter for html output to add links behind a defined string. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.',
        'Defines a filter for html output to add links behind bugtraq numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Defines a filter for html output to add links behind bugtraq numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.',
        'Defines a filter to collect CVE numbers from article texts in AgentTicketZoom. The results will be displayed in a meta box next to the article. Fill in URLPreview if you would like to see a preview when moving your mouse cursor above the link element. This could be the same URL as in URL, but also an alternate one. Please note that some websites deny being displayed within an iframe (e.g. Google) and thus won\'t work with the preview mode.' =>
            'Defines a filter to collect CVE numbers from article texts in AgentTicketZoom. The results will be displayed in a meta box next to the article. Fill in URLPreview if you would like to see a preview when moving your mouse cursor above the link element. This could be the same URL as in URL, but also an alternate one. Please note that some websites deny being displayed within an iframe (e.g. Google) and thus won\'t work with the preview mode.',
        'Defines a filter to process the text in the articles, in order to highlight predefined keywords.' =>
            'Defines a filter to process the text in the articles, in order to highlight predefined keywords.',
        'Defines a regular expression that excludes some addresses from the syntax check (if "CheckEmailAddresses" is set to "Yes"). Please enter a regex in this field for email addresses, that aren\'t syntactically valid, but are necessary for the system (i.e. "root@localhost").' =>
            'Defines a regular expression that excludes some addresses from the syntax check (if "CheckEmailAddresses" is set to "Yes"). Please enter a regex in this field for email addresses, that aren\'t syntactically valid, but are necessary for the system (i.e. "root@localhost").',
        'Defines a regular expression that filters all email addresses that should not be used in the application.' =>
            'Defines a regular expression that filters all email addresses that should not be used in the application.',
        'Defines a sleep time in microseconds between tickets while they are been processed by a job.' =>
            'Defines a sleep time in microseconds between tickets while they are been processed by a job.',
        'Defines a useful module to load specific user options or to display news.' =>
            'Defines a useful module to load specific user options or to display news.',
        'Defines all the X-headers that should be scanned.' => 'Defines all the X-headers that should be scanned.',
        'Defines all the languages that are available to the application. Specify only English names of languages here.' =>
            'Defines all the languages that are available to the application. Specify only English names of languages here.',
        'Defines all the languages that are available to the application. Specify only native names of languages here.' =>
            'Defines all the languages that are available to the application. Specify only native names of languages here.',
        'Defines all the parameters for the RefreshTime object in the customer preferences of the customer interface.' =>
            'Defines all the parameters for the RefreshTime object in the customer preferences of the customer interface.',
        'Defines all the parameters for the ShownTickets object in the customer preferences of the customer interface.' =>
            'Defines all the parameters for the ShownTickets object in the customer preferences of the customer interface.',
        'Defines all the parameters for this item in the customer preferences.' =>
            'Defines all the parameters for this item in the customer preferences.',
        'Defines all the parameters for this item in the customer preferences. \'PasswordRegExp\' allows to match passwords against a regular expression. Define the minimum number of characters using \'PasswordMinSize\'. Define if at least 2 lowercase and 2 uppercase letter characters are needed by setting the appropriate option to \'1\'. \'PasswordMin2Characters\' defines if the password needs to contain at least 2 letter characters (set to 0 or 1). \'PasswordNeedDigit\' controls the need of at least 1 digit (set to 0 or 1 to control).' =>
            'Defines all the parameters for this item in the customer preferences. \'PasswordRegExp\' allows to match passwords against a regular expression. Define the minimum number of characters using \'PasswordMinSize\'. Define if at least 2 lowercase and 2 uppercase letter characters are needed by setting the appropriate option to \'1\'. \'PasswordMin2Characters\' defines if the password needs to contain at least 2 letter characters (set to 0 or 1). \'PasswordNeedDigit\' controls the need of at least 1 digit (set to 0 or 1 to control).',
        'Defines all the parameters for this notification transport.' => 'Defines all the parameters for this notification transport.',
        'Defines all the possible stats output formats.' => 'Defines all the possible stats output formats.',
        'Defines an alternate URL, where the login link refers to.' => 'Defines an alternate URL, where the login link refers to.',
        'Defines an alternate URL, where the logout link refers to.' => 'Defines an alternate URL, where the logout link refers to.',
        'Defines an alternate login URL for the customer panel..' => 'Defines an alternate login URL for the customer panel..',
        'Defines an alternate logout URL for the customer panel.' => 'Defines an alternate logout URL for the customer panel.',
        'Defines an external link to the database of the customer (e.g. \'http://yourhost/customer.php?CID=[% Data.CustomerID %]\' or \'\').' =>
            'Defines an external link to the database of the customer (e.g. \'http://yourhost/customer.php?CID=[% Data.CustomerID %]\' or \'\').',
        'Defines from which ticket attributes the agent can select the result order.' =>
            'Defines from which ticket attributes the agent can select the result order.',
        'Defines how the From field from the emails (sent from answers and email tickets) should look like.' =>
            'Defines how the From field from the emails (sent from answers and email tickets) should look like.',
        'Defines if a pre-sorting by priority should be done in the queue view.' =>
            'Defines if a pre-sorting by priority should be done in the queue view.',
        'Defines if a pre-sorting by priority should be done in the service view.' =>
            'Defines if a pre-sorting by priority should be done in the service view.',
        'Defines if a ticket lock is required in the close ticket screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Defines if a ticket lock is required in the close ticket screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).',
        'Defines if a ticket lock is required in the email outbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Defines if a ticket lock is required in the email outbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).',
        'Defines if a ticket lock is required in the ticket bounce screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Defines if a ticket lock is required in the ticket bounce screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).',
        'Defines if a ticket lock is required in the ticket compose screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Defines if a ticket lock is required in the ticket compose screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).',
        'Defines if a ticket lock is required in the ticket forward screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Defines if a ticket lock is required in the ticket forward screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).',
        'Defines if a ticket lock is required in the ticket free text screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Defines if a ticket lock is required in the ticket free text screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).',
        'Defines if a ticket lock is required in the ticket merge screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Defines if a ticket lock is required in the ticket merge screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).',
        'Defines if a ticket lock is required in the ticket note screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Defines if a ticket lock is required in the ticket note screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).',
        'Defines if a ticket lock is required in the ticket owner screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Defines if a ticket lock is required in the ticket owner screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).',
        'Defines if a ticket lock is required in the ticket pending screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Defines if a ticket lock is required in the ticket pending screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).',
        'Defines if a ticket lock is required in the ticket phone inbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Defines if a ticket lock is required in the ticket phone inbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).',
        'Defines if a ticket lock is required in the ticket phone outbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Defines if a ticket lock is required in the ticket phone outbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).',
        'Defines if a ticket lock is required in the ticket priority screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Defines if a ticket lock is required in the ticket priority screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).',
        'Defines if a ticket lock is required in the ticket responsible screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Defines if a ticket lock is required in the ticket responsible screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).',
        'Defines if a ticket lock is required to change the customer of a ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Defines if a ticket lock is required to change the customer of a ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).',
        'Defines if agents should be allowed to login if they have no shared secret stored in their preferences and therefore are not using two-factor authentication.' =>
            'Defines if agents should be allowed to login if they have no shared secret stored in their preferences and therefore are not using two-factor authentication.',
        'Defines if composed messages have to be spell checked in the agent interface.' =>
            'Defines if composed messages have to be spell checked in the agent interface.',
        'Defines if customers should be allowed to login if they have no shared secret stored in their preferences and therefore are not using two-factor authentication.' =>
            'Defines if customers should be allowed to login if they have no shared secret stored in their preferences and therefore are not using two-factor authentication.',
        'Defines if the enhanced mode should be used (enables use of table, replace, subscript, superscript, paste from word, etc.) in customer interface.' =>
            'Defines if the enhanced mode should be used (enables use of table, replace, subscript, superscript, paste from word, etc.) in customer interface.',
        'Defines if the enhanced mode should be used (enables use of table, replace, subscript, superscript, paste from word, etc.).' =>
            'Defines if the enhanced mode should be used (enables use of table, replace, subscript, superscript, paste from word, etc.).',
        'Defines if the previously valid token should be accepted for authentication. This is slightly less secure but gives users 30 seconds more time to enter their one-time password.' =>
            'Defines if the previously valid token should be accepted for authentication. This is slightly less secure but gives users 30 seconds more time to enter their one-time password.',
        'Defines if the values for filters should be retrieved from all available tickets. If set to "Yes", only values which are actually used in any ticket will be available for filtering. Please note: The list of customers will always be retrieved like this.' =>
            'Defines if the values for filters should be retrieved from all available tickets. If set to "Yes", only values which are actually used in any ticket will be available for filtering. Please note: The list of customers will always be retrieved like this.',
        'Defines if time accounting is mandatory in the agent interface. If activated, a note must be entered for all ticket actions (no matter if the note itself is configured as active or is originally mandatory for the individual ticket action screen).' =>
            'Defines if time accounting is mandatory in the agent interface. If activated, a note must be entered for all ticket actions (no matter if the note itself is configured as active or is originally mandatory for the individual ticket action screen).',
        'Defines if time accounting must be set to all tickets in bulk action.' =>
            'Defines if time accounting must be set to all tickets in bulk action.',
        'Defines out of office message template. Two string parameters (%s) available: end date and number of days left.' =>
            'Defines out of office message template. Two string parameters (%s) available: end date and number of days left.',
        'Defines queues that\'s tickets are used for displaying as calendar events.' =>
            'Defines queues that\'s tickets are used for displaying as calendar events.',
        'Defines the HTTP hostname for the support data collection with the public module \'PublicSupportDataCollector\' (e.g. used from the OTRS Daemon).' =>
            '',
        'Defines the IP regular expression for accessing the local repository. You need to enable this to have access to your local repository and the package::RepositoryList is required on the remote host.' =>
            'Defines the IP regular expression for accessing the local repository. You need to enable this to have access to your local repository and the package::RepositoryList is required on the remote host.',
        'Defines the URL CSS path.' => 'Defines the URL CSS path.',
        'Defines the URL base path of icons, CSS and Java Script.' => 'Defines the URL base path of icons, CSS and Java Script.',
        'Defines the URL image path of icons for navigation.' => 'Defines the URL image path of icons for navigation.',
        'Defines the URL java script path.' => 'Defines the URL java script path.',
        'Defines the URL rich text editor path.' => 'Defines the URL rich text editor path.',
        'Defines the address of a dedicated DNS server, if necessary, for the "CheckMXRecord" look-ups.' =>
            'Defines the address of a dedicated DNS server, if necessary, for the "CheckMXRecord" look-ups.',
        'Defines the agent preferences key where the shared secret key is stored.' =>
            'Defines the agent preferences key where the shared secret key is stored.',
        'Defines the body text for notification mails sent to agents, about new password (after using this link the new password will be sent).' =>
            'Defines the body text for notification mails sent to agents, about new password (after using this link the new password will be sent).',
        'Defines the body text for notification mails sent to agents, with token about new requested password (after using this link the new password will be sent).' =>
            'Defines the body text for notification mails sent to agents, with token about new requested password (after using this link the new password will be sent).',
        'Defines the body text for notification mails sent to customers, about new account.' =>
            'Defines the body text for notification mails sent to customers, about new account.',
        'Defines the body text for notification mails sent to customers, about new password (after using this link the new password will be sent).' =>
            'Defines the body text for notification mails sent to customers, about new password (after using this link the new password will be sent).',
        'Defines the body text for notification mails sent to customers, with token about new requested password (after using this link the new password will be sent).' =>
            'Defines the body text for notification mails sent to customers, with token about new requested password (after using this link the new password will be sent).',
        'Defines the body text for rejected emails.' => 'Defines the body text for rejected emails.',
        'Defines the calendar width in percent. Default is 95%.' => 'Defines the calendar width in percent. Default is 95%.',
        'Defines the cluster node identifier. This is only used in cluster configurations where there is more than one OTRS frontend system. Note: only values from 1 to 99 are allowed.' =>
            'Defines the cluster node identifier. This is only used in cluster configurations where there is more than one OTRS frontend system. Note: only values from 1 to 99 are allowed.',
        'Defines the column to store the keys for the preferences table.' =>
            'Defines the column to store the keys for the preferences table.',
        'Defines the config options for the autocompletion feature.' => 'Defines the config options for the autocompletion feature.',
        'Defines the config parameters of this item, to be shown in the preferences view.' =>
            'Defines the config parameters of this item, to be shown in the preferences view.',
        'Defines the config parameters of this item, to be shown in the preferences view. \'PasswordRegExp\' allows to match passwords against a regular expression. Define the minimum number of characters using \'PasswordMinSize\'. Define if at least 2 lowercase and 2 uppercase letter characters are needed by setting the appropriate option to \'1\'. \'PasswordMin2Characters\' defines if the password needs to contain at least 2 letter characters (set to 0 or 1). \'PasswordNeedDigit\' controls the need of at least 1 digit (set to 0 or 1 to control). \'PasswordMaxLoginFailed\' allows to set an agent to invalid-temporarily if max failed logins reached.' =>
            'Defines the config parameters of this item, to be shown in the preferences view. \'PasswordRegExp\' allows to match passwords against a regular expression. Define the minimum number of characters using \'PasswordMinSize\'. Define if at least 2 lowercase and 2 uppercase letter characters are needed by setting the appropriate option to \'1\'. \'PasswordMin2Characters\' defines if the password needs to contain at least 2 letter characters (set to 0 or 1). \'PasswordNeedDigit\' controls the need of at least 1 digit (set to 0 or 1 to control). \'PasswordMaxLoginFailed\' allows to set an agent to invalid-temporarily if max failed logins reached.',
        'Defines the config parameters of this item, to be shown in the preferences view. Take care to maintain the dictionaries installed in the system in the data section.' =>
            'Defines the config parameters of this item, to be shown in the preferences view. Take care to maintain the dictionaries installed in the system in the data section.',
        'Defines the connections for http/ftp, via a proxy.' => 'Defines the connections for http/ftp, via a proxy.',
        'Defines the customer preferences key where the shared secret key is stored.' =>
            'Defines the customer preferences key where the shared secret key is stored.',
        'Defines the date input format used in forms (option or input fields).' =>
            'Defines the date input format used in forms (option or input fields).',
        'Defines the default CSS used in rich text editors.' => 'Defines the default CSS used in rich text editors.',
        'Defines the default auto response type of the article for this operation.' =>
            'Defines the default auto response type of the article for this operation.',
        'Defines the default body of a note in the ticket free text screen of the agent interface.' =>
            'Defines the default body of a note in the ticket free text screen of the agent interface.',
        'Defines the default front-end (HTML) theme to be used by the agents and customers. If you like, you can add your own theme. Please refer the administrator manual located at http://otrs.github.io/doc/.' =>
            'Defines the default front-end (HTML) theme to be used by the agents and customers. If you like, you can add your own theme. Please refer the administrator manual located at http://otrs.github.io/doc/.',
        'Defines the default front-end language. All the possible values are determined by the available language files on the system (see the next setting).' =>
            'Defines the default front-end language. All the possible values are determined by the available language files on the system (see the next setting).',
        'Defines the default history type in the customer interface.' => 'Defines the default history type in the customer interface.',
        'Defines the default maximum number of X-axis attributes for the time scale.' =>
            'Defines the default maximum number of X-axis attributes for the time scale.',
        'Defines the default maximum number of statistics per page on the overview screen.' =>
            'Defines the default maximum number of statistics per page on the overview screen.',
        'Defines the default next state for a ticket after customer follow-up in the customer interface.' =>
            'Defines the default next state for a ticket after customer follow-up in the customer interface.',
        'Defines the default next state of a ticket after adding a note, in the close ticket screen of the agent interface.' =>
            'Defines the default next state of a ticket after adding a note, in the close ticket screen of the agent interface.',
        'Defines the default next state of a ticket after adding a note, in the ticket bulk screen of the agent interface.' =>
            'Defines the default next state of a ticket after adding a note, in the ticket bulk screen of the agent interface.',
        'Defines the default next state of a ticket after adding a note, in the ticket free text screen of the agent interface.' =>
            'Defines the default next state of a ticket after adding a note, in the ticket free text screen of the agent interface.',
        'Defines the default next state of a ticket after adding a note, in the ticket note screen of the agent interface.' =>
            'Defines the default next state of a ticket after adding a note, in the ticket note screen of the agent interface.',
        'Defines the default next state of a ticket after adding a note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Defines the default next state of a ticket after adding a note, in the ticket owner screen of a zoomed ticket in the agent interface.',
        'Defines the default next state of a ticket after adding a note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Defines the default next state of a ticket after adding a note, in the ticket pending screen of a zoomed ticket in the agent interface.',
        'Defines the default next state of a ticket after adding a note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Defines the default next state of a ticket after adding a note, in the ticket priority screen of a zoomed ticket in the agent interface.',
        'Defines the default next state of a ticket after adding a note, in the ticket responsible screen of the agent interface.' =>
            'Defines the default next state of a ticket after adding a note, in the ticket responsible screen of the agent interface.',
        'Defines the default next state of a ticket after being bounced, in the ticket bounce screen of the agent interface.' =>
            'Defines the default next state of a ticket after being bounced, in the ticket bounce screen of the agent interface.',
        'Defines the default next state of a ticket after being forwarded, in the ticket forward screen of the agent interface.' =>
            'Defines the default next state of a ticket after being forwarded, in the ticket forward screen of the agent interface.',
        'Defines the default next state of a ticket after the message has been sent, in the email outbound screen of the agent interface.' =>
            'Defines the default next state of a ticket after the message has been sent, in the email outbound screen of the agent interface.',
        'Defines the default next state of a ticket if it is composed / answered in the ticket compose screen of the agent interface.' =>
            'Defines the default next state of a ticket if it is composed / answered in the ticket compose screen of the agent interface.',
        'Defines the default note body text for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            'Defines the default note body text for phone tickets in the ticket phone inbound screen of the agent interface.',
        'Defines the default note body text for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            'Defines the default note body text for phone tickets in the ticket phone outbound screen of the agent interface.',
        'Defines the default priority of follow-up customer tickets in the ticket zoom screen in the customer interface.' =>
            'Defines the default priority of follow-up customer tickets in the ticket zoom screen in the customer interface.',
        'Defines the default priority of new customer tickets in the customer interface.' =>
            'Defines the default priority of new customer tickets in the customer interface.',
        'Defines the default priority of new tickets.' => 'Defines the default priority of new tickets.',
        'Defines the default queue for new customer tickets in the customer interface.' =>
            'Defines the default queue for new customer tickets in the customer interface.',
        'Defines the default selection at the drop down menu for dynamic objects (Form: Common Specification).' =>
            'Defines the default selection at the drop down menu for dynamic objects (Form: Common Specification).',
        'Defines the default selection at the drop down menu for permissions (Form: Common Specification).' =>
            'Defines the default selection at the drop down menu for permissions (Form: Common Specification).',
        'Defines the default selection at the drop down menu for stats format (Form: Common Specification). Please insert the format key (see Stats::Format).' =>
            'Defines the default selection at the drop down menu for stats format (Form: Common Specification). Please insert the format key (see Stats::Format).',
        'Defines the default sender type for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            'Defines the default sender type for phone tickets in the ticket phone inbound screen of the agent interface.',
        'Defines the default sender type for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            'Defines the default sender type for phone tickets in the ticket phone outbound screen of the agent interface.',
        'Defines the default sender type for tickets in the ticket zoom screen of the customer interface.' =>
            'Defines the default sender type for tickets in the ticket zoom screen of the customer interface.',
        'Defines the default shown ticket search attribute for ticket search screen (AllTickets/ArchivedTickets/NotArchivedTickets).' =>
            'Defines the default shown ticket search attribute for ticket search screen (AllTickets/ArchivedTickets/NotArchivedTickets).',
        'Defines the default shown ticket search attribute for ticket search screen.' =>
            'Defines the default shown ticket search attribute for ticket search screen.',
        'Defines the default shown ticket search attribute for ticket search screen. Example: "Key" must have the name of the Dynamic Field in this case \'X\', "Content" must have the value of the Dynamic Field depending on the Dynamic Field type,  Text: \'a text\', Dropdown: \'1\', Date/Time: \'Search_DynamicField_XTimeSlotStartYear=1974; Search_DynamicField_XTimeSlotStartMonth=01; Search_DynamicField_XTimeSlotStartDay=26; Search_DynamicField_XTimeSlotStartHour=00; Search_DynamicField_XTimeSlotStartMinute=00; Search_DynamicField_XTimeSlotStartSecond=00; Search_DynamicField_XTimeSlotStopYear=2013; Search_DynamicField_XTimeSlotStopMonth=01; Search_DynamicField_XTimeSlotStopDay=26; Search_DynamicField_XTimeSlotStopHour=23; Search_DynamicField_XTimeSlotStopMinute=59; Search_DynamicField_XTimeSlotStopSecond=59;\' and or \'Search_DynamicField_XTimePointFormat=week; Search_DynamicField_XTimePointStart=Before; Search_DynamicField_XTimePointValue=7\';.' =>
            'Defines the default shown ticket search attribute for ticket search screen. Example: "Key" must have the name of the Dynamic Field in this case \'X\', "Content" must have the value of the Dynamic Field depending on the Dynamic Field type,  Text: \'a text\', Dropdown: \'1\', Date/Time: \'Search_DynamicField_XTimeSlotStartYear=1974; Search_DynamicField_XTimeSlotStartMonth=01; Search_DynamicField_XTimeSlotStartDay=26; Search_DynamicField_XTimeSlotStartHour=00; Search_DynamicField_XTimeSlotStartMinute=00; Search_DynamicField_XTimeSlotStartSecond=00; Search_DynamicField_XTimeSlotStopYear=2013; Search_DynamicField_XTimeSlotStopMonth=01; Search_DynamicField_XTimeSlotStopDay=26; Search_DynamicField_XTimeSlotStopHour=23; Search_DynamicField_XTimeSlotStopMinute=59; Search_DynamicField_XTimeSlotStopSecond=59;\' and or \'Search_DynamicField_XTimePointFormat=week; Search_DynamicField_XTimePointStart=Before; Search_DynamicField_XTimePointValue=7\';.',
        'Defines the default sort criteria for all queues displayed in the queue view.' =>
            'Defines the default sort criteria for all queues displayed in the queue view.',
        'Defines the default sort criteria for all services displayed in the service view.' =>
            'Defines the default sort criteria for all services displayed in the service view.',
        'Defines the default sort order for all queues in the queue view, after priority sort.' =>
            'Defines the default sort order for all queues in the queue view, after priority sort.',
        'Defines the default sort order for all services in the service view, after priority sort.' =>
            'Defines the default sort order for all services in the service view, after priority sort.',
        'Defines the default spell checker dictionary.' => 'Defines the default spell checker dictionary.',
        'Defines the default state of new customer tickets in the customer interface.' =>
            'Defines the default state of new customer tickets in the customer interface.',
        'Defines the default state of new tickets.' => 'Defines the default state of new tickets.',
        'Defines the default subject for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            'Defines the default subject for phone tickets in the ticket phone inbound screen of the agent interface.',
        'Defines the default subject for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            'Defines the default subject for phone tickets in the ticket phone outbound screen of the agent interface.',
        'Defines the default subject of a note in the ticket free text screen of the agent interface.' =>
            'Defines the default subject of a note in the ticket free text screen of the agent interface.',
        'Defines the default the number of seconds (from current time) to re-schedule a generic interface failed task.' =>
            'Defines the default the number of seconds (from current time) to re-schedule a generic interface failed task.',
        'Defines the default ticket attribute for ticket sorting in a ticket search of the customer interface.' =>
            'Defines the default ticket attribute for ticket sorting in a ticket search of the customer interface.',
        'Defines the default ticket attribute for ticket sorting in the escalation view of the agent interface.' =>
            'Defines the default ticket attribute for ticket sorting in the escalation view of the agent interface.',
        'Defines the default ticket attribute for ticket sorting in the locked ticket view of the agent interface.' =>
            'Defines the default ticket attribute for ticket sorting in the locked ticket view of the agent interface.',
        'Defines the default ticket attribute for ticket sorting in the responsible view of the agent interface.' =>
            'Defines the default ticket attribute for ticket sorting in the responsible view of the agent interface.',
        'Defines the default ticket attribute for ticket sorting in the status view of the agent interface.' =>
            'Defines the default ticket attribute for ticket sorting in the status view of the agent interface.',
        'Defines the default ticket attribute for ticket sorting in the watch view of the agent interface.' =>
            'Defines the default ticket attribute for ticket sorting in the watch view of the agent interface.',
        'Defines the default ticket attribute for ticket sorting of the ticket search result of the agent interface.' =>
            'Defines the default ticket attribute for ticket sorting of the ticket search result of the agent interface.',
        'Defines the default ticket attribute for ticket sorting of the ticket search result of this operation.' =>
            'Defines the default ticket attribute for ticket sorting of the ticket search result of this operation.',
        'Defines the default ticket bounced notification for customer/sender in the ticket bounce screen of the agent interface.' =>
            'Defines the default ticket bounced notification for customer/sender in the ticket bounce screen of the agent interface.',
        'Defines the default ticket next state after adding a phone note in the ticket phone inbound screen of the agent interface.' =>
            'Defines the default ticket next state after adding a phone note in the ticket phone inbound screen of the agent interface.',
        'Defines the default ticket next state after adding a phone note in the ticket phone outbound screen of the agent interface.' =>
            'Defines the default ticket next state after adding a phone note in the ticket phone outbound screen of the agent interface.',
        'Defines the default ticket order (after priority sort) in the escalation view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Defines the default ticket order (after priority sort) in the escalation view of the agent interface. Up: oldest on top. Down: latest on top.',
        'Defines the default ticket order (after priority sort) in the status view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Defines the default ticket order (after priority sort) in the status view of the agent interface. Up: oldest on top. Down: latest on top.',
        'Defines the default ticket order in the responsible view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Defines the default ticket order in the responsible view of the agent interface. Up: oldest on top. Down: latest on top.',
        'Defines the default ticket order in the ticket locked view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Defines the default ticket order in the ticket locked view of the agent interface. Up: oldest on top. Down: latest on top.',
        'Defines the default ticket order in the ticket search result of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Defines the default ticket order in the ticket search result of the agent interface. Up: oldest on top. Down: latest on top.',
        'Defines the default ticket order in the ticket search result of the this operation. Up: oldest on top. Down: latest on top.' =>
            'Defines the default ticket order in the ticket search result of the this operation. Up: oldest on top. Down: latest on top.',
        'Defines the default ticket order in the watch view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Defines the default ticket order in the watch view of the agent interface. Up: oldest on top. Down: latest on top.',
        'Defines the default ticket order of a search result in the customer interface. Up: oldest on top. Down: latest on top.' =>
            'Defines the default ticket order of a search result in the customer interface. Up: oldest on top. Down: latest on top.',
        'Defines the default ticket priority in the close ticket screen of the agent interface.' =>
            'Defines the default ticket priority in the close ticket screen of the agent interface.',
        'Defines the default ticket priority in the ticket bulk screen of the agent interface.' =>
            'Defines the default ticket priority in the ticket bulk screen of the agent interface.',
        'Defines the default ticket priority in the ticket free text screen of the agent interface.' =>
            'Defines the default ticket priority in the ticket free text screen of the agent interface.',
        'Defines the default ticket priority in the ticket note screen of the agent interface.' =>
            'Defines the default ticket priority in the ticket note screen of the agent interface.',
        'Defines the default ticket priority in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Defines the default ticket priority in the ticket owner screen of a zoomed ticket in the agent interface.',
        'Defines the default ticket priority in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Defines the default ticket priority in the ticket pending screen of a zoomed ticket in the agent interface.',
        'Defines the default ticket priority in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Defines the default ticket priority in the ticket priority screen of a zoomed ticket in the agent interface.',
        'Defines the default ticket priority in the ticket responsible screen of the agent interface.' =>
            'Defines the default ticket priority in the ticket responsible screen of the agent interface.',
        'Defines the default ticket type for new customer tickets in the customer interface.' =>
            'Defines the default ticket type for new customer tickets in the customer interface.',
        'Defines the default ticket type.' => 'Defines the default ticket type.',
        'Defines the default type for article in the customer interface.' =>
            'Defines the default type for article in the customer interface.',
        'Defines the default type of forwarded message in the ticket forward screen of the agent interface.' =>
            'Defines the default type of forwarded message in the ticket forward screen of the agent interface.',
        'Defines the default type of the article for this operation.' => 'Defines the default type of the article for this operation.',
        'Defines the default type of the message in the email outbound screen of the agent interface.' =>
            'Defines the default type of the message in the email outbound screen of the agent interface.',
        'Defines the default type of the note in the close ticket screen of the agent interface.' =>
            'Defines the default type of the note in the close ticket screen of the agent interface.',
        'Defines the default type of the note in the ticket bulk screen of the agent interface.' =>
            'Defines the default type of the note in the ticket bulk screen of the agent interface.',
        'Defines the default type of the note in the ticket free text screen of the agent interface.' =>
            'Defines the default type of the note in the ticket free text screen of the agent interface.',
        'Defines the default type of the note in the ticket note screen of the agent interface.' =>
            'Defines the default type of the note in the ticket note screen of the agent interface.',
        'Defines the default type of the note in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Defines the default type of the note in the ticket owner screen of a zoomed ticket in the agent interface.',
        'Defines the default type of the note in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Defines the default type of the note in the ticket pending screen of a zoomed ticket in the agent interface.',
        'Defines the default type of the note in the ticket phone inbound screen of the agent interface.' =>
            'Defines the default type of the note in the ticket phone inbound screen of the agent interface.',
        'Defines the default type of the note in the ticket phone outbound screen of the agent interface.' =>
            'Defines the default type of the note in the ticket phone outbound screen of the agent interface.',
        'Defines the default type of the note in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Defines the default type of the note in the ticket priority screen of a zoomed ticket in the agent interface.',
        'Defines the default type of the note in the ticket responsible screen of the agent interface.' =>
            'Defines the default type of the note in the ticket responsible screen of the agent interface.',
        'Defines the default type of the note in the ticket zoom screen of the customer interface.' =>
            'Defines the default type of the note in the ticket zoom screen of the customer interface.',
        'Defines the default used Frontend-Module if no Action parameter given in the url on the agent interface.' =>
            'Defines the default used Frontend-Module if no Action parameter given in the url on the agent interface.',
        'Defines the default used Frontend-Module if no Action parameter given in the url on the customer interface.' =>
            'Defines the default used Frontend-Module if no Action parameter given in the url on the customer interface.',
        'Defines the default value for the action parameter for the public frontend. The action parameter is used in the scripts of the system.' =>
            'Defines the default value for the action parameter for the public frontend. The action parameter is used in the scripts of the system.',
        'Defines the default viewable sender types of a ticket (default: customer).' =>
            'Defines the default viewable sender types of a ticket (default: customer).',
        'Defines the dynamic fields that are used for displaying on calendar events.' =>
            'Defines the dynamic fields that are used for displaying on calendar events.',
        'Defines the fall-back path to open fetchmail binary. Note: The name of the binary needs to be \'fetchmail\', if it is different please use a symbolic link.' =>
            'Defines the fall-back path to open fetchmail binary. Note: The name of the binary needs to be \'fetchmail\', if it is different please use a symbolic link.',
        'Defines the filter that processes the text in the articles, in order to highlight URLs.' =>
            'Defines the filter that processes the text in the articles, in order to highlight URLs.',
        'Defines the format of responses in the ticket compose screen of the agent interface ([% Data.OrigFrom | html %] is From 1:1, [% Data.OrigFromName | html %] is only realname of From).' =>
            'Defines the format of responses in the ticket compose screen of the agent interface ([% Data.OrigFrom | html %] is From 1:1, [% Data.OrigFromName | html %] is only realname of From).',
        'Defines the fully qualified domain name of the system. This setting is used as a variable, OTRS_CONFIG_FQDN which is found in all forms of messaging used by the application, to build links to the tickets within your system.' =>
            'Defines the fully qualified domain name of the system. This setting is used as a variable, OTRS_CONFIG_FQDN which is found in all forms of messaging used by the application, to build links to the tickets within your system.',
        'Defines the groups every customer user will be in (if CustomerGroupSupport is enabled and you don\'t want to manage every user for these groups).' =>
            'Defines the groups every customer user will be in (if CustomerGroupSupport is enabled and you don\'t want to manage every user for these groups).',
        'Defines the height for the rich text editor component for this screen. Enter number (pixels) or percent value (relative).' =>
            'Defines the height for the rich text editor component for this screen. Enter number (pixels) or percent value (relative).',
        'Defines the height for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            'Defines the height for the rich text editor component. Enter number (pixels) or percent value (relative).',
        'Defines the history comment for the close ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Defines the history comment for the close ticket screen action, which gets used for ticket history in the agent interface.',
        'Defines the history comment for the email ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Defines the history comment for the email ticket screen action, which gets used for ticket history in the agent interface.',
        'Defines the history comment for the phone ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Defines the history comment for the phone ticket screen action, which gets used for ticket history in the agent interface.',
        'Defines the history comment for the ticket free text screen action, which gets used for ticket history.' =>
            'Defines the history comment for the ticket free text screen action, which gets used for ticket history.',
        'Defines the history comment for the ticket note screen action, which gets used for ticket history in the agent interface.' =>
            'Defines the history comment for the ticket note screen action, which gets used for ticket history in the agent interface.',
        'Defines the history comment for the ticket owner screen action, which gets used for ticket history in the agent interface.' =>
            'Defines the history comment for the ticket owner screen action, which gets used for ticket history in the agent interface.',
        'Defines the history comment for the ticket pending screen action, which gets used for ticket history in the agent interface.' =>
            'Defines the history comment for the ticket pending screen action, which gets used for ticket history in the agent interface.',
        'Defines the history comment for the ticket phone inbound screen action, which gets used for ticket history in the agent interface.' =>
            'Defines the history comment for the ticket phone inbound screen action, which gets used for ticket history in the agent interface.',
        'Defines the history comment for the ticket phone outbound screen action, which gets used for ticket history in the agent interface.' =>
            'Defines the history comment for the ticket phone outbound screen action, which gets used for ticket history in the agent interface.',
        'Defines the history comment for the ticket priority screen action, which gets used for ticket history in the agent interface.' =>
            'Defines the history comment for the ticket priority screen action, which gets used for ticket history in the agent interface.',
        'Defines the history comment for the ticket responsible screen action, which gets used for ticket history in the agent interface.' =>
            'Defines the history comment for the ticket responsible screen action, which gets used for ticket history in the agent interface.',
        'Defines the history comment for the ticket zoom action, which gets used for ticket history in the customer interface.' =>
            'Defines the history comment for the ticket zoom action, which gets used for ticket history in the customer interface.',
        'Defines the history comment for this operation, which gets used for ticket history in the agent interface.' =>
            'Defines the history comment for this operation, which gets used for ticket history in the agent interface.',
        'Defines the history type for the close ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Defines the history type for the close ticket screen action, which gets used for ticket history in the agent interface.',
        'Defines the history type for the email ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Defines the history type for the email ticket screen action, which gets used for ticket history in the agent interface.',
        'Defines the history type for the phone ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Defines the history type for the phone ticket screen action, which gets used for ticket history in the agent interface.',
        'Defines the history type for the ticket free text screen action, which gets used for ticket history.' =>
            'Defines the history type for the ticket free text screen action, which gets used for ticket history.',
        'Defines the history type for the ticket note screen action, which gets used for ticket history in the agent interface.' =>
            'Defines the history type for the ticket note screen action, which gets used for ticket history in the agent interface.',
        'Defines the history type for the ticket owner screen action, which gets used for ticket history in the agent interface.' =>
            'Defines the history type for the ticket owner screen action, which gets used for ticket history in the agent interface.',
        'Defines the history type for the ticket pending screen action, which gets used for ticket history in the agent interface.' =>
            'Defines the history type for the ticket pending screen action, which gets used for ticket history in the agent interface.',
        'Defines the history type for the ticket phone inbound screen action, which gets used for ticket history in the agent interface.' =>
            'Defines the history type for the ticket phone inbound screen action, which gets used for ticket history in the agent interface.',
        'Defines the history type for the ticket phone outbound screen action, which gets used for ticket history in the agent interface.' =>
            'Defines the history type for the ticket phone outbound screen action, which gets used for ticket history in the agent interface.',
        'Defines the history type for the ticket priority screen action, which gets used for ticket history in the agent interface.' =>
            'Defines the history type for the ticket priority screen action, which gets used for ticket history in the agent interface.',
        'Defines the history type for the ticket responsible screen action, which gets used for ticket history in the agent interface.' =>
            'Defines the history type for the ticket responsible screen action, which gets used for ticket history in the agent interface.',
        'Defines the history type for the ticket zoom action, which gets used for ticket history in the customer interface.' =>
            'Defines the history type for the ticket zoom action, which gets used for ticket history in the customer interface.',
        'Defines the history type for this operation, which gets used for ticket history in the agent interface.' =>
            'Defines the history type for this operation, which gets used for ticket history in the agent interface.',
        'Defines the hours and week days of the indicated calendar, to count the working time.' =>
            'Defines the hours and week days of the indicated calendar, to count the working time.',
        'Defines the hours and week days to count the working time.' => 'Defines the hours and week days to count the working time.',
        'Defines the key to be checked with Kernel::Modules::AgentInfo module. If this user preferences key is true, the message is accepted by the system.' =>
            'Defines the key to be checked with Kernel::Modules::AgentInfo module. If this user preferences key is true, the message is accepted by the system.',
        'Defines the key to check with CustomerAccept. If this user preferences key is true, then the message is accepted by the system.' =>
            'Defines the key to check with CustomerAccept. If this user preferences key is true, then the message is accepted by the system.',
        'Defines the link type \'Normal\'. If the source name and the target name contain the same value, the resulting link is a non-directional one; otherwise, the result is a directional link.' =>
            'Defines the link type \'Normal\'. If the source name and the target name contain the same value, the resulting link is a non-directional one; otherwise, the result is a directional link.',
        'Defines the link type \'ParentChild\'. If the source name and the target name contain the same value, the resulting link is a non-directional one; otherwise, the result is a directional link.' =>
            'Defines the link type \'ParentChild\'. If the source name and the target name contain the same value, the resulting link is a non-directional one; otherwise, the result is a directional link.',
        'Defines the link type groups. The link types of the same group cancel one another. Example: If ticket A is linked per a \'Normal\' link with ticket B, then these tickets could not be additionally linked with link of a \'ParentChild\' relationship.' =>
            'Defines the link type groups. The link types of the same group cancel one another. Example: If ticket A is linked per a \'Normal\' link with ticket B, then these tickets could not be additionally linked with link of a \'ParentChild\' relationship.',
        'Defines the list of online repositories. Another installations can be used as repository, for example: Key="http://example.com/otrs/public.pl?Action=PublicRepository;File=" and Content="Some Name".' =>
            'Defines the list of online repositories. Another installations can be used as repository, for example: Key="http://example.com/otrs/public.pl?Action=PublicRepository;File=" and Content="Some Name".',
        'Defines the list of possible next actions on an error screen, a full path is required, then is possible to add external links if needed.' =>
            'Defines the list of possible next actions on an error screen, a full path is required, then is possible to add external links if needed.',
        'Defines the list of types for templates.' => 'Defines the list of types for templates.',
        'Defines the location to get online repository list for additional packages. The first available result will be used.' =>
            'Defines the location to get online repository list for additional packages. The first available result will be used.',
        'Defines the log module for the system. "File" writes all messages in a given logfile, "SysLog" uses the syslog daemon of the system, e.g. syslogd.' =>
            'Defines the log module for the system. "File" writes all messages in a given logfile, "SysLog" uses the syslog daemon of the system, e.g. syslogd.',
        'Defines the maximal size (in bytes) for file uploads via the browser. Warning: Setting this option to a value which is too low could cause many masks in your OTRS instance to stop working (probably any mask which takes input from the user).' =>
            'Defines the maximal size (in bytes) for file uploads via the browser. Warning: Setting this option to a value which is too low could cause many masks in your OTRS instance to stop working (probably any mask which takes input from the user).',
        'Defines the maximal valid time (in seconds) for a session id.' =>
            'Defines the maximal valid time (in seconds) for a session id.',
        'Defines the maximum number of affected tickets per job.' => 'Defines the maximum number of affected tickets per job.',
        'Defines the maximum number of pages per PDF file.' => 'Defines the maximum number of pages per PDF file.',
        'Defines the maximum number of quoted lines to be added to responses.' =>
            'Defines the maximum number of quoted lines to be added to responses.',
        'Defines the maximum number of tasks to be executed as the same time.' =>
            'Defines the maximum number of tasks to be executed as the same time.',
        'Defines the maximum size (in MB) of the log file.' => 'Defines the maximum size (in MB) of the log file.',
        'Defines the maximum size in KiloByte of GenericInterface responses that get logged to the gi_debugger_entry_content table.' =>
            'Defines the maximum size in KiloByte of GenericInterface responses that get logged to the gi_debugger_entry_content table.',
        'Defines the module that shows a generic notification in the agent interface. Either "Text" - if configured - or the contents of "File" will be displayed.' =>
            'Defines the module that shows a generic notification in the agent interface. Either "Text" - if configured - or the contents of "File" will be displayed.',
        'Defines the module that shows all the currently logged in agents in the agent interface.' =>
            'Defines the module that shows all the currently logged in agents in the agent interface.',
        'Defines the module that shows all the currently logged in customers in the agent interface.' =>
            '',
        'Defines the module that shows the currently logged in agents in the customer interface.' =>
            '',
        'Defines the module that shows the currently logged in customers in the customer interface.' =>
            '',
        'Defines the module to authenticate customers.' => 'Defines the module to authenticate customers.',
        'Defines the module to display a notification if cloud services are disabled.' =>
            'Defines the module to display a notification if cloud services are disabled.',
        'Defines the module to display a notification in different interfaces on different occasions for OTRS Business Solution™.' =>
            'Defines the module to display a notification in different interfaces on different occasions for OTRS Business Solution™.',
        'Defines the module to display a notification in the agent interface if the OTRS Daemon is not running.' =>
            'Defines the module to display a notification in the agent interface if the OTRS Daemon is not running.',
        'Defines the module to display a notification in the agent interface, if the agent is logged in while having out-of-office active.' =>
            'Defines the module to display a notification in the agent interface, if the agent is logged in while having out-of-office active.',
        'Defines the module to display a notification in the agent interface, if the agent is logged in while having system maintenance active.' =>
            'Defines the module to display a notification in the agent interface, if the agent is logged in while having system maintenance active.',
        'Defines the module to display a notification in the agent interface, if the agent session limit prior warning is reached.' =>
            '',
        'Defines the module to display a notification in the agent interface, if the system is used by the admin user (normally you shouldn\'t work as admin).' =>
            'Defines the module to display a notification in the agent interface, if the system is used by the admin user (normally you shouldn\'t work as admin).',
        'Defines the module to generate code for periodic page reloads.' =>
            'Defines the module to generate code for periodic page reloads.',
        'Defines the module to send emails. "Sendmail" directly uses the sendmail binary of your operating system. Any of the "SMTP" mechanisms use a specified (external) mailserver. "DoNotSendEmail" doesn\'t send emails and it is useful for test systems.' =>
            'Defines the module to send emails. "Sendmail" directly uses the sendmail binary of your operating system. Any of the "SMTP" mechanisms use a specified (external) mailserver. "DoNotSendEmail" doesn\'t send emails and it is useful for test systems.',
        'Defines the module used to store the session data. With "DB" the frontend server can be splitted from the db server. "FS" is faster.' =>
            'Defines the module used to store the session data. With "DB" the frontend server can be splitted from the db server. "FS" is faster.',
        'Defines the name of the application, shown in the web interface, tabs and title bar of the web browser.' =>
            'Defines the name of the application, shown in the web interface, tabs and title bar of the web browser.',
        'Defines the name of the column to store the data in the preferences table.' =>
            'Defines the name of the column to store the data in the preferences table.',
        'Defines the name of the column to store the user identifier in the preferences table.' =>
            'Defines the name of the column to store the user identifier in the preferences table.',
        'Defines the name of the indicated calendar.' => 'Defines the name of the indicated calendar.',
        'Defines the name of the key for customer sessions.' => 'Defines the name of the key for customer sessions.',
        'Defines the name of the session key. E.g. Session, SessionID or OTRS.' =>
            'Defines the name of the session key. E.g. Session, SessionID or OTRS.',
        'Defines the name of the table where the user preferences are stored.' =>
            'Defines the name of the table where the user preferences are stored.',
        'Defines the next possible states after composing / answering a ticket in the ticket compose screen of the agent interface.' =>
            'Defines the next possible states after composing / answering a ticket in the ticket compose screen of the agent interface.',
        'Defines the next possible states after forwarding a ticket in the ticket forward screen of the agent interface.' =>
            'Defines the next possible states after forwarding a ticket in the ticket forward screen of the agent interface.',
        'Defines the next possible states after sending a message in the email outbound screen of the agent interface.' =>
            'Defines the next possible states after sending a message in the email outbound screen of the agent interface.',
        'Defines the next possible states for customer tickets in the customer interface.' =>
            'Defines the next possible states for customer tickets in the customer interface.',
        'Defines the next state of a ticket after adding a note, in the close ticket screen of the agent interface.' =>
            'Defines the next state of a ticket after adding a note, in the close ticket screen of the agent interface.',
        'Defines the next state of a ticket after adding a note, in the ticket bulk screen of the agent interface.' =>
            'Defines the next state of a ticket after adding a note, in the ticket bulk screen of the agent interface.',
        'Defines the next state of a ticket after adding a note, in the ticket free text screen of the agent interface.' =>
            'Defines the next state of a ticket after adding a note, in the ticket free text screen of the agent interface.',
        'Defines the next state of a ticket after adding a note, in the ticket note screen of the agent interface.' =>
            'Defines the next state of a ticket after adding a note, in the ticket note screen of the agent interface.',
        'Defines the next state of a ticket after adding a note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Defines the next state of a ticket after adding a note, in the ticket owner screen of a zoomed ticket in the agent interface.',
        'Defines the next state of a ticket after adding a note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Defines the next state of a ticket after adding a note, in the ticket pending screen of a zoomed ticket in the agent interface.',
        'Defines the next state of a ticket after adding a note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Defines the next state of a ticket after adding a note, in the ticket priority screen of a zoomed ticket in the agent interface.',
        'Defines the next state of a ticket after adding a note, in the ticket responsible screen of the agent interface.' =>
            'Defines the next state of a ticket after adding a note, in the ticket responsible screen of the agent interface.',
        'Defines the next state of a ticket after being bounced, in the ticket bounce screen of the agent interface.' =>
            'Defines the next state of a ticket after being bounced, in the ticket bounce screen of the agent interface.',
        'Defines the next state of a ticket after being moved to another queue, in the move ticket screen of the agent interface.' =>
            'Defines the next state of a ticket after being moved to another queue, in the move ticket screen of the agent interface.',
        'Defines the number of character per line used in case an HTML article preview replacement on TemplateGenerator for EventNotifications.' =>
            'Defines the number of character per line used in case an HTML article preview replacement on TemplateGenerator for EventNotifications.',
        'Defines the number of days to keep the daemon log files.' => 'Defines the number of days to keep the daemon log files.',
        'Defines the number of header fields in frontend modules for add and update postmaster filters. It can be up to 99 fields.' =>
            'Defines the number of header fields in frontend modules for add and update postmaster filters. It can be up to 99 fields.',
        'Defines the parameters for the customer preferences table.' => 'Defines the parameters for the customer preferences table.',
        'Defines the parameters for the dashboard backend. "Cmd" is used to specify command with parameters. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin.' =>
            'Defines the parameters for the dashboard backend. "Cmd" is used to specify command with parameters. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin.',
        'Defines the parameters for the dashboard backend. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin.' =>
            'Defines the parameters for the dashboard backend. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin.',
        'Defines the parameters for the dashboard backend. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" defines the cache expiration period in minutes for the plugin.' =>
            'Defines the parameters for the dashboard backend. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" defines the cache expiration period in minutes for the plugin.',
        'Defines the parameters for the dashboard backend. "Limit" defines the number of entries displayed by default. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin.' =>
            'Defines the parameters for the dashboard backend. "Limit" defines the number of entries displayed by default. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin.',
        'Defines the parameters for the dashboard backend. "Limit" defines the number of entries displayed by default. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" defines the cache expiration period in minutes for the plugin.' =>
            'Defines the parameters for the dashboard backend. "Limit" defines the number of entries displayed by default. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" defines the cache expiration period in minutes for the plugin.',
        'Defines the password to access the SOAP handle (bin/cgi-bin/rpc.pl).' =>
            'Defines the password to access the SOAP handle (bin/cgi-bin/rpc.pl).',
        'Defines the path and TTF-File to handle bold italic monospaced font in PDF documents.' =>
            'Defines the path and TTF-File to handle bold italic monospaced font in PDF documents.',
        'Defines the path and TTF-File to handle bold italic proportional font in PDF documents.' =>
            'Defines the path and TTF-File to handle bold italic proportional font in PDF documents.',
        'Defines the path and TTF-File to handle bold monospaced font in PDF documents.' =>
            'Defines the path and TTF-File to handle bold monospaced font in PDF documents.',
        'Defines the path and TTF-File to handle bold proportional font in PDF documents.' =>
            'Defines the path and TTF-File to handle bold proportional font in PDF documents.',
        'Defines the path and TTF-File to handle italic monospaced font in PDF documents.' =>
            'Defines the path and TTF-File to handle italic monospaced font in PDF documents.',
        'Defines the path and TTF-File to handle italic proportional font in PDF documents.' =>
            'Defines the path and TTF-File to handle italic proportional font in PDF documents.',
        'Defines the path and TTF-File to handle monospaced font in PDF documents.' =>
            'Defines the path and TTF-File to handle monospaced font in PDF documents.',
        'Defines the path and TTF-File to handle proportional font in PDF documents.' =>
            'Defines the path and TTF-File to handle proportional font in PDF documents.',
        'Defines the path of the shown info file, that is located under Kernel/Output/HTML/Templates/Standard/CustomerAccept.tt.' =>
            'Defines the path of the shown info file, that is located under Kernel/Output/HTML/Templates/Standard/CustomerAccept.tt.',
        'Defines the path to PGP binary.' => 'Defines the path to PGP binary.',
        'Defines the path to open ssl binary. It may need a HOME env ($ENV{HOME} = \'/var/lib/wwwrun\';).' =>
            'Defines the path to open ssl binary. It may need a HOME env ($ENV{HOME} = \'/var/lib/wwwrun\';).',
        'Defines the postmaster default queue.' => 'Defines the postmaster default queue.',
        'Defines the priority in which the information is logged and presented.' =>
            'Defines the priority in which the information is logged and presented.',
        'Defines the recipient target of the phone ticket and the sender of the email ticket ("Queue" shows all queues, "System address" displays all system addresses) in the agent interface.' =>
            'Defines the recipient target of the phone ticket and the sender of the email ticket ("Queue" shows all queues, "System address" displays all system addresses) in the agent interface.',
        'Defines the recipient target of the tickets ("Queue" shows all queues, "SystemAddress" shows only the queues which are assigned to system addresses) in the customer interface.' =>
            'Defines the recipient target of the tickets ("Queue" shows all queues, "SystemAddress" shows only the queues which are assigned to system addresses) in the customer interface.',
        'Defines the required permission to show a ticket in the escalation view of the agent interface.' =>
            'Defines the required permission to show a ticket in the escalation view of the agent interface.',
        'Defines the search limit for the stats.' => 'Defines the search limit for the stats.',
        'Defines the sender for rejected emails.' => 'Defines the sender for rejected emails.',
        'Defines the separator between the agents real name and the given queue email address.' =>
            'Defines the separator between the agents real name and the given queue email address.',
        'Defines the standard permissions available for customers within the application. If more permissions are needed, you can enter them here. Permissions must be hard coded to be effective. Please ensure, when adding any of the afore mentioned permissions, that the "rw" permission remains the last entry.' =>
            'Defines the standard permissions available for customers within the application. If more permissions are needed, you can enter them here. Permissions must be hard coded to be effective. Please ensure, when adding any of the afore mentioned permissions, that the "rw" permission remains the last entry.',
        'Defines the standard size of PDF pages.' => 'Defines the standard size of PDF pages.',
        'Defines the state of a ticket if it gets a follow-up and the ticket was already closed.' =>
            'Defines the state of a ticket if it gets a follow-up and the ticket was already closed.',
        'Defines the state of a ticket if it gets a follow-up.' => 'Defines the state of a ticket if it gets a follow-up.',
        'Defines the state type of the reminder for pending tickets.' => 'Defines the state type of the reminder for pending tickets.',
        'Defines the subject for notification mails sent to agents, about new password.' =>
            'Defines the subject for notification mails sent to agents, about new password.',
        'Defines the subject for notification mails sent to agents, with token about new requested password.' =>
            'Defines the subject for notification mails sent to agents, with token about new requested password.',
        'Defines the subject for notification mails sent to customers, about new account.' =>
            'Defines the subject for notification mails sent to customers, about new account.',
        'Defines the subject for notification mails sent to customers, about new password.' =>
            'Defines the subject for notification mails sent to customers, about new password.',
        'Defines the subject for notification mails sent to customers, with token about new requested password.' =>
            'Defines the subject for notification mails sent to customers, with token about new requested password.',
        'Defines the subject for rejected emails.' => 'Defines the subject for rejected emails.',
        'Defines the system administrator\'s email address. It will be displayed in the error screens of the application.' =>
            'Defines the system administrator\'s email address. It will be displayed in the error screens of the application.',
        'Defines the system identifier. Every ticket number and http session string contains this ID. This ensures that only tickets which belong to your system will be processed as follow-ups (useful when communicating between two instances of OTRS).' =>
            'Defines the system identifier. Every ticket number and http session string contains this ID. This ensures that only tickets which belong to your system will be processed as follow-ups (useful when communicating between two instances of OTRS).',
        'Defines the target attribute in the link to external customer database. E.g. \'AsPopup PopupType_TicketAction\'.' =>
            'Defines the target attribute in the link to external customer database. E.g. \'AsPopup PopupType_TicketAction\'.',
        'Defines the target attribute in the link to external customer database. E.g. \'target="cdb"\'.' =>
            'Defines the target attribute in the link to external customer database. E.g. \'target="cdb"\'.',
        'Defines the ticket fields that are going to be displayed calendar events. The "Key" defines the field or ticket attribute and the "Content" defines the display name.' =>
            'Defines the ticket fields that are going to be displayed calendar events. The "Key" defines the field or ticket attribute and the "Content" defines the display name.',
        'Defines the time zone of the indicated calendar, which can be assigned later to a specific queue.' =>
            'Defines the time zone of the indicated calendar, which can be assigned later to a specific queue.',
        'Defines the timeout (in seconds, minimum is 20 seconds) for the support data collection with the public module \'PublicSupportDataCollector\' (e.g. used from the OTRS Daemon).' =>
            '',
        'Defines the two-factor module to authenticate agents.' => 'Defines the two-factor module to authenticate agents.',
        'Defines the two-factor module to authenticate customers.' => 'Defines the two-factor module to authenticate customers.',
        'Defines the type of protocol, used by the web server, to serve the application. If https protocol will be used instead of plain http, it must be specified here. Since this has no affect on the web server\'s settings or behavior, it will not change the method of access to the application and, if it is wrong, it will not prevent you from logging into the application. This setting is only used as a variable, OTRS_CONFIG_HttpType which is found in all forms of messaging used by the application, to build links to the tickets within your system.' =>
            'Defines the type of protocol, used by the web server, to serve the application. If https protocol will be used instead of plain http, it must be specified here. Since this has no affect on the web server\'s settings or behavior, it will not change the method of access to the application and, if it is wrong, it will not prevent you from logging into the application. This setting is only used as a variable, OTRS_CONFIG_HttpType which is found in all forms of messaging used by the application, to build links to the tickets within your system.',
        'Defines the used character for plaintext email quotes in the ticket compose screen of the agent interface. If this is empty or inactive, original emails will not be quoted but appended to the response.' =>
            'Defines the used character for plaintext email quotes in the ticket compose screen of the agent interface. If this is empty or inactive, original emails will not be quoted but appended to the response.',
        'Defines the user identifier for the customer panel.' => 'Defines the user identifier for the customer panel.',
        'Defines the username to access the SOAP handle (bin/cgi-bin/rpc.pl).' =>
            'Defines the username to access the SOAP handle (bin/cgi-bin/rpc.pl).',
        'Defines the valid state types for a ticket.' => 'Defines the valid state types for a ticket.',
        'Defines the valid states for unlocked tickets. To unlock tickets the script "bin/otrs.Console.pl Maint::Ticket::UnlockTimeout" can be used.' =>
            'Defines the valid states for unlocked tickets. To unlock tickets the script "bin/otrs.Console.pl Maint::Ticket::UnlockTimeout" can be used.',
        'Defines the viewable locks of a ticket. NOTE: When you change this setting, make sure to delete the cache in order to use the new value. Default: unlock, tmp_lock.' =>
            '',
        'Defines the width for the rich text editor component for this screen. Enter number (pixels) or percent value (relative).' =>
            'Defines the width for the rich text editor component for this screen. Enter number (pixels) or percent value (relative).',
        'Defines the width for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            'Defines the width for the rich text editor component. Enter number (pixels) or percent value (relative).',
        'Defines which article sender types should be shown in the preview of a ticket.' =>
            'Defines which article sender types should be shown in the preview of a ticket.',
        'Defines which items are available for \'Action\' in third level of the ACL structure.' =>
            'Defines which items are available for \'Action\' in third level of the ACL structure.',
        'Defines which items are available in first level of the ACL structure.' =>
            'Defines which items are available in first level of the ACL structure.',
        'Defines which items are available in second level of the ACL structure.' =>
            'Defines which items are available in second level of the ACL structure.',
        'Defines which states should be set automatically (Content), after the pending time of state (Key) has been reached.' =>
            'Defines which states should be set automatically (Content), after the pending time of state (Key) has been reached.',
        'Defines wich article type should be expanded when entering the overview. If nothing defined, latest article will be expanded.' =>
            'Defines wich article type should be expanded when entering the overview. If nothing defined, latest article will be expanded.',
        'Defines, which tickets of which ticket state types should not be listed in linked ticket lists.' =>
            'Defines, which tickets of which ticket state types should not be listed in linked ticket lists.',
        'Delete expired cache from core modules.' => 'Delete expired cache from core modules.',
        'Delete expired loader cache weekly (Sunday mornings).' => 'Delete expired loader cache weekly (Sunday mornings).',
        'Delete expired sessions.' => 'Delete expired sessions.',
        'Deleted link to ticket "%s".' => 'Deleted link to ticket "%s".',
        'Deletes a session if the session id is used with an invalid remote IP address.' =>
            'Deletes a session if the session id is used with an invalid remote IP address.',
        'Deletes requested sessions if they have timed out.' => 'Deletes requested sessions if they have timed out.',
        'Delivers extended debugging information in the frontend in case any AJAX errors occur, if enabled.' =>
            'Delivers extended debugging information in the frontend in case any AJAX errors occur, if enabled.',
        'Deploy and manage OTRS Business Solution™.' => 'Deploy and manage OTRS Business Solution™.',
        'Determines if the list of possible queues to move to ticket into should be displayed in a dropdown list or in a new window in the agent interface. If "New Window" is set you can add a move note to the ticket.' =>
            'Determines if the list of possible queues to move to ticket into should be displayed in a dropdown list or in a new window in the agent interface. If "New Window" is set you can add a move note to the ticket.',
        'Determines if the statistics module may generate ticket lists.' =>
            'Determines if the statistics module may generate ticket lists.',
        'Determines the next possible ticket states, after the creation of a new email ticket in the agent interface.' =>
            'Determines the next possible ticket states, after the creation of a new email ticket in the agent interface.',
        'Determines the next possible ticket states, after the creation of a new phone ticket in the agent interface.' =>
            'Determines the next possible ticket states, after the creation of a new phone ticket in the agent interface.',
        'Determines the next possible ticket states, for process tickets in the agent interface.' =>
            'Determines the next possible ticket states, for process tickets in the agent interface.',
        'Determines the next possible ticket states, for process tickets in the customer interface.' =>
            '',
        'Determines the next screen after new customer ticket in the customer interface.' =>
            'Determines the next screen after new customer ticket in the customer interface.',
        'Determines the next screen after the follow-up screen of a zoomed ticket in the customer interface.' =>
            'Determines the next screen after the follow-up screen of a zoomed ticket in the customer interface.',
        'Determines the next screen after the ticket is moved. LastScreenOverview will return the last overview screen (e.g. search results, queueview, dashboard). TicketZoom will return to the TicketZoom.' =>
            'Determines the next screen after the ticket is moved. LastScreenOverview will return the last overview screen (e.g. search results, queueview, dashboard). TicketZoom will return to the TicketZoom.',
        'Determines the possible states for pending tickets that changed state after reaching time limit.' =>
            'Determines the possible states for pending tickets that changed state after reaching time limit.',
        'Determines the strings that will be shown as recipient (To:) of the phone ticket and as sender (From:) of the email ticket in the agent interface. For Queue as NewQueueSelectionType "<Queue>" shows the names of the queues and for SystemAddress "<Realname> <<Email>>" shows the name and email of the recipient.' =>
            'Determines the strings that will be shown as recipient (To:) of the phone ticket and as sender (From:) of the email ticket in the agent interface. For Queue as NewQueueSelectionType "<Queue>" shows the names of the queues and for SystemAddress "<Realname> <<Email>>" shows the name and email of the recipient.',
        'Determines the strings that will be shown as recipient (To:) of the ticket in the customer interface. For Queue as CustomerPanelSelectionType, "<Queue>" shows the names of the queues, and for SystemAddress, "<Realname> <<Email>>" shows the name and email of the recipient.' =>
            'Determines the strings that will be shown as recipient (To:) of the ticket in the customer interface. For Queue as CustomerPanelSelectionType, "<Queue>" shows the names of the queues, and for SystemAddress, "<Realname> <<Email>>" shows the name and email of the recipient.',
        'Determines the way the linked objects are displayed in each zoom mask.' =>
            'Determines the way the linked objects are displayed in each zoom mask.',
        'Determines which options will be valid of the recipient (phone ticket) and the sender (email ticket) in the agent interface.' =>
            'Determines which options will be valid of the recipient (phone ticket) and the sender (email ticket) in the agent interface.',
        'Determines which queues will be valid for ticket\'s recepients in the customer interface.' =>
            'Determines which queues will be valid for ticket\'s recepients in the customer interface.',
        'Development' => '',
        'Disable HTTP header "Content-Security-Policy" to allow loading of external script contents. Disabling this HTTP header can be a security issue! Only disable it, if you know what you are doing!' =>
            '',
        'Disable HTTP header "X-Frame-Options: SAMEORIGIN" to allow OTRS to be included as an IFrame in other websites. Disabling this HTTP header can be a security issue! Only disable it, if you know what you are doing!' =>
            'Disable HTTP header "X-Frame-Options: SAMEORIGIN" to allow OTRS to be included as an IFrame in other websites. Disabling this HTTP header can be a security issue! Only disable it, if you know what you are doing!',
        'Disable restricted security for IFrames in IE. May be required for SSO to work in IE.' =>
            'Disable restricted security for IFrames in IE. May be required for SSO to work in IE.',
        'Disables sending reminder notifications to the responsible agent of a ticket (Ticket::Responsible needs to be activated).' =>
            'Disables sending reminder notifications to the responsible agent of a ticket (Ticket::Responsible needs to be activated).',
        'Disables the communication between this system and OTRS Group servers that provides cloud services. If active, some functionality will be lost such as system registration, support data sending, upgrading to and use of OTRS Business Solution™, OTRS Verify™, OTRS News and product News dashboard widgets, among others.' =>
            'Disables the communication between this system and OTRS Group servers that provides cloud services. If active, some functionality will be lost such as system registration, support data sending, upgrading to and use of OTRS Business Solution™, OTRS Verify™, OTRS News and product News dashboard widgets, among others.',
        'Disables the web installer (http://yourhost.example.com/otrs/installer.pl), to prevent the system from being hijacked. If set to "No", the system can be reinstalled and the current basic configuration will be used to pre-populate the questions within the installer script. If not active, it also disables the GenericAgent, PackageManager and SQL Box.' =>
            'Disables the web installer (http://yourhost.example.com/otrs/installer.pl), to prevent the system from being hijacked. If set to "No", the system can be reinstalled and the current basic configuration will be used to pre-populate the questions within the installer script. If not active, it also disables the GenericAgent, PackageManager and SQL Box.',
        'Display a warning and prevent search when using stop words within fulltext search.' =>
            'Display a warning and prevent search when using stop words within fulltext search.',
        'Display settings to override defaults for Process Tickets.' => 'Display settings to override defaults for Process Tickets.',
        'Displays the accounted time for an article in the ticket zoom view.' =>
            'Displays the accounted time for an article in the ticket zoom view.',
        'Dropdown' => 'Dropdown',
        'Dutch stop words for fulltext index. These words will be removed from the search index.' =>
            'Dutch stop words for fulltext index. These words will be removed from the search index.',
        'Dynamic Fields Checkbox Backend GUI' => 'Dynamic Fields Checkbox Backend GUI',
        'Dynamic Fields Date Time Backend GUI' => 'Dynamic Fields Date Time Backend GUI',
        'Dynamic Fields Drop-down Backend GUI' => 'Dynamic Fields Drop-down Backend GUI',
        'Dynamic Fields GUI' => 'Dynamic Fields GUI',
        'Dynamic Fields Multiselect Backend GUI' => 'Dynamic Fields Multiselect Backend GUI',
        'Dynamic Fields Overview Limit' => 'Dynamic Fields Overview Limit',
        'Dynamic Fields Text Backend GUI' => 'Dynamic Fields Text Backend GUI',
        'Dynamic Fields used to export the search result in CSV format.' =>
            'Dynamic Fields used to export the search result in CSV format.',
        'Dynamic fields groups for process widget. The key is the name of the group, the value contains the fields to be shown. Example: \'Key => My Group\', \'Content: Name_X, NameY\'.' =>
            'Dynamic fields groups for process widget. The key is the name of the group, the value contains the fields to be shown. Example: \'Key => My Group\', \'Content: Name_X, NameY\'.',
        'Dynamic fields limit per page for Dynamic Fields Overview' => 'Dynamic fields limit per page for Dynamic Fields Overview',
        'Dynamic fields options shown in the ticket message screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required. NOTE. If you want to display these fields also in the ticket zoom of the customer interface, you have to enable them in CustomerTicketZoom###DynamicField.' =>
            'Dynamic fields options shown in the ticket message screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required. NOTE. If you want to display these fields also in the ticket zoom of the customer interface, you have to enable them in CustomerTicketZoom###DynamicField.',
        'Dynamic fields options shown in the ticket reply section in the ticket zoom screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Dynamic fields options shown in the ticket reply section in the ticket zoom screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.',
        'Dynamic fields shown in the email outbound screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Dynamic fields shown in the email outbound screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.',
        'Dynamic fields shown in the process widget in ticket zoom screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            'Dynamic fields shown in the process widget in ticket zoom screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.',
        'Dynamic fields shown in the sidebar of the ticket zoom screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            'Dynamic fields shown in the sidebar of the ticket zoom screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.',
        'Dynamic fields shown in the ticket close screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Dynamic fields shown in the ticket close screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.',
        'Dynamic fields shown in the ticket compose screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Dynamic fields shown in the ticket compose screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.',
        'Dynamic fields shown in the ticket email screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Dynamic fields shown in the ticket email screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.',
        'Dynamic fields shown in the ticket forward screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Dynamic fields shown in the ticket forward screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.',
        'Dynamic fields shown in the ticket free text screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Dynamic fields shown in the ticket free text screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.',
        'Dynamic fields shown in the ticket medium format overview screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            'Dynamic fields shown in the ticket medium format overview screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.',
        'Dynamic fields shown in the ticket move screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Dynamic fields shown in the ticket move screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.',
        'Dynamic fields shown in the ticket note screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Dynamic fields shown in the ticket note screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.',
        'Dynamic fields shown in the ticket overview screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Dynamic fields shown in the ticket overview screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.',
        'Dynamic fields shown in the ticket owner screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Dynamic fields shown in the ticket owner screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.',
        'Dynamic fields shown in the ticket pending screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Dynamic fields shown in the ticket pending screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.',
        'Dynamic fields shown in the ticket phone inbound screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Dynamic fields shown in the ticket phone inbound screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.',
        'Dynamic fields shown in the ticket phone outbound screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Dynamic fields shown in the ticket phone outbound screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.',
        'Dynamic fields shown in the ticket phone screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Dynamic fields shown in the ticket phone screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.',
        'Dynamic fields shown in the ticket preview format overview screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            'Dynamic fields shown in the ticket preview format overview screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.',
        'Dynamic fields shown in the ticket print screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            'Dynamic fields shown in the ticket print screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.',
        'Dynamic fields shown in the ticket print screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            'Dynamic fields shown in the ticket print screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.',
        'Dynamic fields shown in the ticket priority screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Dynamic fields shown in the ticket priority screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.',
        'Dynamic fields shown in the ticket responsible screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Dynamic fields shown in the ticket responsible screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.',
        'Dynamic fields shown in the ticket search overview results screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            'Dynamic fields shown in the ticket search overview results screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.',
        'Dynamic fields shown in the ticket search screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and shown by default.' =>
            'Dynamic fields shown in the ticket search screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and shown by default.',
        'Dynamic fields shown in the ticket search screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            'Dynamic fields shown in the ticket search screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.',
        'Dynamic fields shown in the ticket small format overview screen of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.' =>
            'Dynamic fields shown in the ticket small format overview screen of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.',
        'Dynamic fields shown in the ticket zoom screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            'Dynamic fields shown in the ticket zoom screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.',
        'DynamicField' => 'DynamicField',
        'DynamicField backend registration.' => 'DynamicField backend registration.',
        'DynamicField object registration.' => 'DynamicField object registration.',
        'E-Mail Outbound' => 'E-Mail Outbound',
        'Edit Customer Companies.' => 'Edit Customer Companies.',
        'Edit Customer Users.' => 'Edit Customer Users.',
        'Edit customer company' => 'Edit customer company',
        'Email Addresses' => 'Email Addresses',
        'Email Outbound' => 'Email Outbound',
        'Email sent to "%s".' => 'Email sent to "%s".',
        'Email sent to customer.' => 'Email sent to customer.',
        'Enable keep-alive connection header for SOAP responses.' => 'Enable keep-alive connection header for SOAP responses.',
        'Enabled filters.' => 'Enabled filters.',
        'Enables PGP support. When PGP support is enabled for signing and encrypting mail, it is HIGHLY recommended that the web server runs as the OTRS user. Otherwise, there will be problems with the privileges when accessing .gnupg folder.' =>
            'Enables PGP support. When PGP support is enabled for signing and encrypting mail, it is HIGHLY recommended that the web server runs as the OTRS user. Otherwise, there will be problems with the privileges when accessing .gnupg folder.',
        'Enables S/MIME support.' => 'Enables S/MIME support.',
        'Enables customers to create their own accounts.' => 'Enables customers to create their own accounts.',
        'Enables fetch S/MIME from CustomerUser backend support.' => '',
        'Enables file upload in the package manager frontend.' => 'Enables file upload in the package manager frontend.',
        'Enables or disables the caching for templates. WARNING: Do NOT disable template caching for production environments for it will cause a massive performance drop! This setting should only be disabled for debugging reasons!' =>
            'Enables or disables the caching for templates. WARNING: Do NOT disable template caching for production environments for it will cause a massive performance drop! This setting should only be disabled for debugging reasons!',
        'Enables or disables the debug mode over frontend interface.' => 'Enables or disables the debug mode over frontend interface.',
        'Enables or disables the ticket watcher feature, to keep track of tickets without being the owner nor the responsible.' =>
            'Enables or disables the ticket watcher feature, to keep track of tickets without being the owner nor the responsible.',
        'Enables performance log (to log the page response time). It will affect the system performance. Frontend::Module###AdminPerformanceLog must be enabled.' =>
            'Enables performance log (to log the page response time). It will affect the system performance. Frontend::Module###AdminPerformanceLog must be enabled.',
        'Enables spell checker support.' => 'Enables spell checker support.',
        'Enables the minimal ticket counter size (if "Date" was selected as TicketNumberGenerator).' =>
            'Enables the minimal ticket counter size (if "Date" was selected as TicketNumberGenerator).',
        'Enables ticket bulk action feature for the agent frontend to work on more than one ticket at a time.' =>
            'Enables ticket bulk action feature for the agent frontend to work on more than one ticket at a time.',
        'Enables ticket bulk action feature only for the listed groups.' =>
            'Enables ticket bulk action feature only for the listed groups.',
        'Enables ticket responsible feature, to keep track of a specific ticket.' =>
            'Enables ticket responsible feature, to keep track of a specific ticket.',
        'Enables ticket watcher feature only for the listed groups.' => 'Enables ticket watcher feature only for the listed groups.',
        'English (Canada)' => 'English (Canada)',
        'English (United Kingdom)' => 'English (United Kingdom)',
        'English (United States)' => 'English (United States)',
        'English stop words for fulltext index. These words will be removed from the search index.' =>
            'English stop words for fulltext index. These words will be removed from the search index.',
        'Enroll process for this ticket' => 'Enroll process for this ticket',
        'Enter your shared secret to enable two factor authentication.' =>
            'Enter your shared secret to enable two factor authentication.',
        'Escalation response time finished' => 'Escalation response time finished',
        'Escalation response time forewarned' => 'Escalation response time forewarned',
        'Escalation response time in effect' => 'Escalation response time in effect',
        'Escalation solution time finished' => 'Escalation solution time finished',
        'Escalation solution time forewarned' => 'Escalation solution time forewarned',
        'Escalation solution time in effect' => 'Escalation solution time in effect',
        'Escalation update time finished' => 'Escalation update time finished',
        'Escalation update time forewarned' => 'Escalation update time forewarned',
        'Escalation update time in effect' => 'Escalation update time in effect',
        'Escalation view' => 'Escalation view',
        'EscalationTime' => 'EscalationTime',
        'Estonian' => 'Estonian',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate).' =>
            'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate).',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate). This is only possible if all Ticket dynamic fields need the same event.' =>
            'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate). This is only possible if all Ticket dynamic fields need the same event.',
        'Event module that performs an update statement on TicketIndex to rename the queue name there if needed and if StaticDB is actually used.' =>
            'Event module that performs an update statement on TicketIndex to rename the queue name there if needed and if StaticDB is actually used.',
        'Event module that updates customer user search profiles if login changes.' =>
            'Event module that updates customer user search profiles if login changes.',
        'Event module that updates customer user service membership if login changes.' =>
            'Event module that updates customer user service membership if login changes.',
        'Event module that updates customer users after an update of the Customer.' =>
            'Event module that updates customer users after an update of the Customer.',
        'Event module that updates tickets after an update of the Customer User.' =>
            'Event module that updates tickets after an update of the Customer User.',
        'Event module that updates tickets after an update of the Customer.' =>
            'Event module that updates tickets after an update of the Customer.',
        'Events Ticket Calendar' => 'Events Ticket Calendar',
        'Execute SQL statements.' => 'Execute SQL statements.',
        'Executes a custom command or module. Note: if module is used, function is required.' =>
            'Executes a custom command or module. Note: if module is used, function is required.',
        'Executes follow-up checks on In-Reply-To or References headers for mails that don\'t have a ticket number in the subject.' =>
            'Executes follow-up checks on In-Reply-To or References headers for mails that don\'t have a ticket number in the subject.',
        'Executes follow-up checks on attachment contents for mails that don\'t have a ticket number in the subject.' =>
            'Executes follow-up checks on attachment contents for mails that don\'t have a ticket number in the subject.',
        'Executes follow-up checks on email body for mails that don\'t have a ticket number in the subject.' =>
            'Executes follow-up checks on email body for mails that don\'t have a ticket number in the subject.',
        'Executes follow-up checks on the raw source email for mails that don\'t have a ticket number in the subject.' =>
            'Executes follow-up checks on the raw source email for mails that don\'t have a ticket number in the subject.',
        'Exports the whole article tree in search result (it can affect the system performance).' =>
            'Exports the whole article tree in search result (it can affect the system performance).',
        'Fetch emails via fetchmail (using SSL).' => 'Fetch emails via fetchmail (using SSL).',
        'Fetch emails via fetchmail.' => 'Fetch emails via fetchmail.',
        'Fetch incoming emails from configured mail accounts.' => 'Fetch incoming emails from configured mail accounts.',
        'Fetches packages via proxy. Overwrites "WebUserAgent::Proxy".' =>
            'Fetches packages via proxy. Overwrites "WebUserAgent::Proxy".',
        'File that is displayed in the Kernel::Modules::AgentInfo module, if located under Kernel/Output/HTML/Templates/Standard/AgentInfo.tt.' =>
            'File that is displayed in the Kernel::Modules::AgentInfo module, if located under Kernel/Output/HTML/Templates/Standard/AgentInfo.tt.',
        'Filter for debugging ACLs. Note: More ticket attributes can be added in the format <OTRS_TICKET_Attribute> e.g. <OTRS_TICKET_Priority>.' =>
            'Filter for debugging ACLs. Note: More ticket attributes can be added in the format <OTRS_TICKET_Attribute> e.g. <OTRS_TICKET_Priority>.',
        'Filter for debugging Transitions. Note: More filters can be added in the format <OTRS_TICKET_Attribute> e.g. <OTRS_TICKET_Priority>.' =>
            'Filter for debugging Transitions. Note: More filters can be added in the format <OTRS_TICKET_Attribute> e.g. <OTRS_TICKET_Priority>.',
        'Filter incoming emails.' => 'Filter incoming emails.',
        'Finnish' => 'Finnish',
        'First Queue' => 'First Queue',
        'FirstLock' => 'FirstLock',
        'FirstResponse' => 'FirstResponse',
        'FirstResponseDiffInMin' => 'FirstResponseDiffInMin',
        'FirstResponseInMin' => 'FirstResponseInMin',
        'Firstname Lastname' => 'Firstname Lastname',
        'Firstname Lastname (UserLogin)' => 'Firstname Lastname (UserLogin)',
        'FollowUp for [%s]. %s' => 'FollowUp for [%s]. %s',
        'Forces encoding of outgoing emails (7bit|8bit|quoted-printable|base64).' =>
            'Forces encoding of outgoing emails (7bit|8bit|quoted-printable|base64).',
        'Forces to choose a different ticket state (from current) after lock action. Define the current state as key, and the next state after lock action as content.' =>
            'Forces to choose a different ticket state (from current) after lock action. Define the current state as key, and the next state after lock action as content.',
        'Forces to unlock tickets after being moved to another queue.' =>
            'Forces to unlock tickets after being moved to another queue.',
        'Forwarded to "%s".' => 'Forwarded to "%s".',
        'French' => 'French',
        'French (Canada)' => 'French (Canada)',
        'French stop words for fulltext index. These words will be removed from the search index.' =>
            'French stop words for fulltext index. These words will be removed from the search index.',
        'Frontend' => 'Frontend',
        'Frontend module registration (disable AgentTicketService link if Ticket Serivice feature is not used).' =>
            'Frontend module registration (disable AgentTicketService link if Ticket Serivice feature is not used).',
        'Frontend module registration (disable company link if no company feature is used).' =>
            'Frontend module registration (disable company link if no company feature is used).',
        'Frontend module registration (disable ticket processes screen if no process available) for Customer.' =>
            'Frontend module registration (disable ticket processes screen if no process available) for Customer.',
        'Frontend module registration (disable ticket processes screen if no process available).' =>
            'Frontend module registration (disable ticket processes screen if no process available).',
        'Frontend module registration for the agent interface.' => 'Frontend module registration for the agent interface.',
        'Frontend module registration for the customer interface.' => 'Frontend module registration for the customer interface.',
        'Frontend theme' => 'Frontend theme',
        'Full value' => 'Full value',
        'Fulltext index regex filters to remove parts of the text.' => 'Fulltext index regex filters to remove parts of the text.',
        'Fulltext search' => 'Fulltext search',
        'Galician' => 'Galician',
        'General ticket data shown in the ticket overviews (fall-back). Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note that TicketNumber can not be disabled, because it is necessary.' =>
            'General ticket data shown in the ticket overviews (fall-back). Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note that TicketNumber can not be disabled, because it is necessary.',
        'Generate dashboard statistics.' => 'Generate dashboard statistics.',
        'Generic Info module.' => 'Generic Info module.',
        'GenericAgent' => 'GenericAgent',
        'GenericInterface Debugger GUI' => 'GenericInterface Debugger GUI',
        'GenericInterface Invoker GUI' => 'GenericInterface Invoker GUI',
        'GenericInterface Operation GUI' => 'GenericInterface Operation GUI',
        'GenericInterface TransportHTTPREST GUI' => 'GenericInterface TransportHTTPREST GUI',
        'GenericInterface TransportHTTPSOAP GUI' => 'GenericInterface TransportHTTPSOAP GUI',
        'GenericInterface Web Service GUI' => 'GenericInterface Web Service GUI',
        'GenericInterface Webservice History GUI' => 'GenericInterface Webservice History GUI',
        'GenericInterface Webservice Mapping GUI' => 'GenericInterface Webservice Mapping GUI',
        'GenericInterface module registration for the invoker layer.' => 'GenericInterface module registration for the invoker layer.',
        'GenericInterface module registration for the mapping layer.' => 'GenericInterface module registration for the mapping layer.',
        'GenericInterface module registration for the operation layer.' =>
            'GenericInterface module registration for the operation layer.',
        'GenericInterface module registration for the transport layer.' =>
            'GenericInterface module registration for the transport layer.',
        'German' => 'German',
        'German stop words for fulltext index. These words will be removed from the search index.' =>
            'German stop words for fulltext index. These words will be removed from the search index.',
        'Gives end users the possibility to override the separator character for CSV files, defined in the translation files.' =>
            'Gives end users the possibility to override the separator character for CSV files, defined in the translation files.',
        'Global Search Module.' => 'Global Search Module.',
        'Go back' => 'Go back',
        'Google Authenticator' => 'Google Authenticator',
        'Graph: Bar Chart' => 'Graph: Bar Chart',
        'Graph: Line Chart' => 'Graph: Line Chart',
        'Graph: Stacked Area Chart' => 'Graph: Stacked Area Chart',
        'Greek' => 'Greek',
        'HTML Reference' => 'HTML Reference',
        'HTML Reference.' => 'HTML Reference.',
        'Hebrew' => 'Hebrew',
        'Helps to extend your articles full-text search (From, To, Cc, Subject and Body search). Runtime will do full-text searches on live data (it works fine for up to 50.000 tickets). StaticDB will strip all articles and will build an index after article creation, increasing fulltext searches about 50%. To create an initial index use "bin/otrs.Console.pl Maint::Ticket::FulltextIndexRebuild".' =>
            'Helps to extend your articles full-text search (From, To, Cc, Subject and Body search). Runtime will do full-text searches on live data (it works fine for up to 50.000 tickets). StaticDB will strip all articles and will build an index after article creation, increasing fulltext searches about 50%. To create an initial index use "bin/otrs.Console.pl Maint::Ticket::FulltextIndexRebuild".',
        'Hindi' => 'Hindi',
        'Hungarian' => 'Hungarian',
        'If "DB" was selected for Customer::AuthModule, a database driver (normally autodetection is used) can be specified.' =>
            'If "DB" was selected for Customer::AuthModule, a database driver (normally autodetection is used) can be specified.',
        'If "DB" was selected for Customer::AuthModule, a password to connect to the customer table can be specified.' =>
            'If "DB" was selected for Customer::AuthModule, a password to connect to the customer table can be specified.',
        'If "DB" was selected for Customer::AuthModule, a username to connect to the customer table can be specified.' =>
            'If "DB" was selected for Customer::AuthModule, a username to connect to the customer table can be specified.',
        'If "DB" was selected for Customer::AuthModule, the DSN for the connection to the customer table must be specified.' =>
            'If "DB" was selected for Customer::AuthModule, the DSN for the connection to the customer table must be specified.',
        'If "DB" was selected for Customer::AuthModule, the column name for the CustomerPassword in the customer table must be specified.' =>
            'If "DB" was selected for Customer::AuthModule, the column name for the CustomerPassword in the customer table must be specified.',
        'If "DB" was selected for Customer::AuthModule, the crypt type of passwords must be specified.' =>
            'If "DB" was selected for Customer::AuthModule, the crypt type of passwords must be specified.',
        'If "DB" was selected for Customer::AuthModule, the name of the column for the CustomerKey in the customer table must be specified.' =>
            'If "DB" was selected for Customer::AuthModule, the name of the column for the CustomerKey in the customer table must be specified.',
        'If "DB" was selected for Customer::AuthModule, the name of the table where your customer data should be stored must be specified.' =>
            'If "DB" was selected for Customer::AuthModule, the name of the table where your customer data should be stored must be specified.',
        'If "DB" was selected for SessionModule, a table in database where session data will be stored must be specified.' =>
            'If "DB" was selected for SessionModule, a table in database where session data will be stored must be specified.',
        'If "FS" was selected for SessionModule, a directory where the session data will be stored must be specified.' =>
            'If "FS" was selected for SessionModule, a directory where the session data will be stored must be specified.',
        'If "HTTPBasicAuth" was selected for Customer::AuthModule, you can specify (by using a RegExp) to strip parts of REMOTE_USER (e. g. for to remove trailing domains). RegExp-Note, $1 will be the new Login.' =>
            'If "HTTPBasicAuth" was selected for Customer::AuthModule, you can specify (by using a RegExp) to strip parts of REMOTE_USER (e. g. for to remove trailing domains). RegExp-Note, $1 will be the new Login.',
        'If "HTTPBasicAuth" was selected for Customer::AuthModule, you can specify to strip leading parts of user names (e. g. for domains like example_domain\user to user).' =>
            'If "HTTPBasicAuth" was selected for Customer::AuthModule, you can specify to strip leading parts of user names (e. g. for domains like example_domain\user to user).',
        'If "LDAP" was selected for Customer::AuthModule and if you want to add a suffix to every customer login name, specifiy it here, e. g. you just want to write the username user but in your LDAP directory exists user@domain.' =>
            'If "LDAP" was selected for Customer::AuthModule and if you want to add a suffix to every customer login name, specifiy it here, e. g. you just want to write the username user but in your LDAP directory exists user@domain.',
        'If "LDAP" was selected for Customer::AuthModule and special paramaters are needed for the Net::LDAP perl module, you can specify them here. See "perldoc Net::LDAP" for more information about the parameters.' =>
            'If "LDAP" was selected for Customer::AuthModule and special paramaters are needed for the Net::LDAP perl module, you can specify them here. See "perldoc Net::LDAP" for more information about the parameters.',
        'If "LDAP" was selected for Customer::AuthModule and your users have only anonymous access to the LDAP tree, but you want to search through the data, you can do this with a user who has access to the LDAP directory. Specify the password for this special user here.' =>
            'If "LDAP" was selected for Customer::AuthModule and your users have only anonymous access to the LDAP tree, but you want to search through the data, you can do this with a user who has access to the LDAP directory. Specify the password for this special user here.',
        'If "LDAP" was selected for Customer::AuthModule and your users have only anonymous access to the LDAP tree, but you want to search through the data, you can do this with a user who has access to the LDAP directory. Specify the username for this special user here.' =>
            'If "LDAP" was selected for Customer::AuthModule and your users have only anonymous access to the LDAP tree, but you want to search through the data, you can do this with a user who has access to the LDAP directory. Specify the username for this special user here.',
        'If "LDAP" was selected for Customer::AuthModule, the BaseDN must be specified.' =>
            'If "LDAP" was selected for Customer::AuthModule, the BaseDN must be specified.',
        'If "LDAP" was selected for Customer::AuthModule, the LDAP host can be specified.' =>
            'If "LDAP" was selected for Customer::AuthModule, the LDAP host can be specified.',
        'If "LDAP" was selected for Customer::AuthModule, the user identifier must be specified.' =>
            'If "LDAP" was selected for Customer::AuthModule, the user identifier must be specified.',
        'If "LDAP" was selected for Customer::AuthModule, user attributes can be specified. For LDAP posixGroups use UID, for non LDAP posixGroups use full user DN.' =>
            'If "LDAP" was selected for Customer::AuthModule, user attributes can be specified. For LDAP posixGroups use UID, for non LDAP posixGroups use full user DN.',
        'If "LDAP" was selected for Customer::AuthModule, you can specify access attributes here.' =>
            'If "LDAP" was selected for Customer::AuthModule, you can specify access attributes here.',
        'If "LDAP" was selected for Customer::AuthModule, you can specify if the applications will stop if e. g. a connection to a server can\'t be established due to network problems.' =>
            'If "LDAP" was selected for Customer::AuthModule, you can specify if the applications will stop if e. g. a connection to a server can\'t be established due to network problems.',
        'If "LDAP" was selected for Customer::Authmodule, you can check if the user is allowed to authenticate because he is in a posixGroup, e.g. user needs to be in a group xyz to use OTRS. Specify the group, who may access the system.' =>
            'If "LDAP" was selected for Customer::Authmodule, you can check if the user is allowed to authenticate because he is in a posixGroup, e.g. user needs to be in a group xyz to use OTRS. Specify the group, who may access the system.',
        'If "LDAP" was selected, you can add a filter to each LDAP query, e.g. (mail=*), (objectclass=user) or (!objectclass=computer).' =>
            'If "LDAP" was selected, you can add a filter to each LDAP query, e.g. (mail=*), (objectclass=user) or (!objectclass=computer).',
        'If "Radius" was selected for Customer::AuthModule, the password to authenticate to the radius host must be specified.' =>
            'If "Radius" was selected for Customer::AuthModule, the password to authenticate to the radius host must be specified.',
        'If "Radius" was selected for Customer::AuthModule, the radius host must be specified.' =>
            'If "Radius" was selected for Customer::AuthModule, the radius host must be specified.',
        'If "Radius" was selected for Customer::AuthModule, you can specify if the applications will stop if e. g. a connection to a server can\'t be established due to network problems.' =>
            'If "Radius" was selected for Customer::AuthModule, you can specify if the applications will stop if e. g. a connection to a server can\'t be established due to network problems.',
        'If "Sendmail" was selected as SendmailModule, the location of the sendmail binary and the needed options must be specified.' =>
            'If "Sendmail" was selected as SendmailModule, the location of the sendmail binary and the needed options must be specified.',
        'If "SysLog" was selected for LogModule, a special log facility can be specified.' =>
            'If "SysLog" was selected for LogModule, a special log facility can be specified.',
        'If "SysLog" was selected for LogModule, a special log sock can be specified (on solaris you may need to use \'stream\').' =>
            'If "SysLog" was selected for LogModule, a special log sock can be specified (on solaris you may need to use \'stream\').',
        'If "SysLog" was selected for LogModule, the charset that should be used for logging can be specified.' =>
            'If "SysLog" was selected for LogModule, the charset that should be used for logging can be specified.',
        'If "file" was selected for LogModule, a logfile must be specified. If the file doesn\'t exist, it will be created by the system.' =>
            'If "file" was selected for LogModule, a logfile must be specified. If the file doesn\'t exist, it will be created by the system.',
        'If active, none of the regular expressions may match the user\'s email address to allow registration.' =>
            'If active, none of the regular expressions may match the user\'s email address to allow registration.',
        'If active, one of the regular expressions has to match the user\'s email address to allow registration.' =>
            'If active, one of the regular expressions has to match the user\'s email address to allow registration.',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, and authentication to the mail server is needed, a password must be specified.' =>
            'If any of the "SMTP" mechanisms was selected as SendmailModule, and authentication to the mail server is needed, a password must be specified.',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, and authentication to the mail server is needed, an username must be specified.' =>
            'If any of the "SMTP" mechanisms was selected as SendmailModule, and authentication to the mail server is needed, an username must be specified.',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, the mailhost that sends out the mails must be specified.' =>
            'If any of the "SMTP" mechanisms was selected as SendmailModule, the mailhost that sends out the mails must be specified.',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, the port where your mailserver is listening for incoming connections must be specified.' =>
            'If any of the "SMTP" mechanisms was selected as SendmailModule, the port where your mailserver is listening for incoming connections must be specified.',
        'If enabled debugging information for ACLs is logged.' => 'If enabled debugging information for ACLs is logged.',
        'If enabled debugging information for transitions is logged.' => 'If enabled debugging information for transitions is logged.',
        'If enabled the daemon will redirect the standard error stream to a log file.' =>
            'If enabled the daemon will redirect the standard error stream to a log file.',
        'If enabled the daemon will redirect the standard output stream to a log file.' =>
            'If enabled the daemon will redirect the standard output stream to a log file.',
        'If enabled, OTRS will deliver all CSS files in minified form. WARNING: If you turn this off, there will likely be problems in IE 7, because it cannot load more than 32 CSS files.' =>
            'If enabled, OTRS will deliver all CSS files in minified form. WARNING: If you turn this off, there will likely be problems in IE 7, because it cannot load more than 32 CSS files.',
        'If enabled, OTRS will deliver all JavaScript files in minified form.' =>
            'If enabled, OTRS will deliver all JavaScript files in minified form.',
        'If enabled, TicketPhone and TicketEmail will be open in new windows.' =>
            'If enabled, TicketPhone and TicketEmail will be open in new windows.',
        'If enabled, the OTRS version tag will be removed from the Webinterface, the HTTP headers and the X-Headers of outgoing mails. NOTE: If you change this option, please make sure to delete the cache.' =>
            '',
        'If enabled, the customer can search for tickets in all services (regardless what services are assigned to the customer).' =>
            'If enabled, the customer can search for tickets in all services (regardless what services are assigned to the customer).',
        'If enabled, the different overviews (Dashboard, LockedView, QueueView) will automatically refresh after the specified time.' =>
            'If enabled, the different overviews (Dashboard, LockedView, QueueView) will automatically refresh after the specified time.',
        'If enabled, the first level of the main menu opens on mouse hover (instead of click only).' =>
            'If enabled, the first level of the main menu opens on mouse hover (instead of click only).',
        'If no SendmailNotificationEnvelopeFrom is specified, this setting makes it possible to use the email\'s from address instead of an empty envelope sender (required in certain mail server configurations).' =>
            '',
        'If set, this address is used as envelope sender header in outgoing notifications. If no address is specified, the envelope sender header is empty (unless SendmailNotificationEnvelopeFrom::FallbackToEmailFrom is set).' =>
            '',
        'If set, this address is used as envelope sender in outgoing messages (not notifications - see below). If no address is specified, the envelope sender is equal to queue e-mail address.' =>
            'If set, this address is used as envelope sender in outgoing messages (not notifications - see below). If no address is specified, the envelope sender is equal to queue e-mail address.',
        'If this option is enabled, then the decrypted data will be stored in the database if they are displayed in AgentTicketZoom.' =>
            'If this option is enabled, then the decrypted data will be stored in the database if they are displayed in AgentTicketZoom.',
        'If this option is set to \'Yes\', tickets created via the web interface, via Customers or Agents, will receive an autoresponse if configured. If this option is set to \'No\', no autoresponses will be sent.' =>
            'If this option is set to \'Yes\', tickets created via the web interface, via Customers or Agents, will receive an autoresponse if configured. If this option is set to \'No\', no autoresponses will be sent.',
        'If this regex matches, no message will be send by the autoresponder.' =>
            'If this regex matches, no message will be send by the autoresponder.',
        'If this setting is active, local modifications will not be highlighted as errors in the package manager and support data collector.' =>
            'If this setting is active, local modifications will not be highlighted as errors in the package manager and support data collector.',
        'If you\'re going to be out of office, you may wish to let other users know by setting the exact dates of your absence.' =>
            '',
        'Ignore system sender article types (e. g. auto responses or email notifications) to be flagged as \'Unread Article\' in AgentTicketZoom or expanded automatically in Large view screens.' =>
            '',
        'Include tickets of subqueues per default when selecting a queue.' =>
            'Include tickets of subqueues per default when selecting a queue.',
        'Include unknown customers in ticket filter.' => 'Include unknown customers in ticket filter.',
        'Includes article create times in the ticket search of the agent interface.' =>
            'Includes article create times in the ticket search of the agent interface.',
        'Incoming Phone Call.' => 'Incoming Phone Call.',
        'IndexAccelerator: to choose your backend TicketViewAccelerator module. "RuntimeDB" generates each queue view on the fly from ticket table (no performance problems up to approx. 60.000 tickets in total and 6.000 open tickets in the system). "StaticDB" is the most powerful module, it uses an extra ticket-index table that works like a view (recommended if more than 80.000 and 6.000 open tickets are stored in the system). Use the command "bin/otrs.Console.pl Maint::Ticket::QueueIndexRebuild" for initial index creation.' =>
            'IndexAccelerator: to choose your backend TicketViewAccelerator module. "RuntimeDB" generates each queue view on the fly from ticket table (no performance problems up to approx. 60.000 tickets in total and 6.000 open tickets in the system). "StaticDB" is the most powerful module, it uses an extra ticket-index table that works like a view (recommended if more than 80.000 and 6.000 open tickets are stored in the system). Use the command "bin/otrs.Console.pl Maint::Ticket::QueueIndexRebuild" for initial index creation.',
        'Indonesian' => 'Indonesian',
        'Input' => 'Input',
        'Install ispell or aspell on the system, if you want to use a spell checker. Please specify the path to the aspell or ispell binary on your operating system.' =>
            'Install ispell or aspell on the system, if you want to use a spell checker. Please specify the path to the aspell or ispell binary on your operating system.',
        'Interface language' => 'Interface language',
        'It is possible to configure different skins, for example to distinguish between diferent agents, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            'It is possible to configure different skins, for example to distinguish between diferent agents, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.',
        'It is possible to configure different skins, for example to distinguish between diferent customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            'It is possible to configure different skins, for example to distinguish between diferent customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.',
        'It is possible to configure different themes, for example to distinguish between agents and customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid theme on your system. Please see the example entries for the proper form of the regex.' =>
            'It is possible to configure different themes, for example to distinguish between agents and customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid theme on your system. Please see the example entries for the proper form of the regex.',
        'Italian' => 'Italian',
        'Italian stop words for fulltext index. These words will be removed from the search index.' =>
            'Italian stop words for fulltext index. These words will be removed from the search index.',
        'Ivory' => 'Ivory',
        'Ivory (Slim)' => 'Ivory (Slim)',
        'Japanese' => 'Japanese',
        'JavaScript function for the search frontend.' => 'JavaScript function for the search frontend.',
        'Last customer subject' => 'Last customer subject',
        'Lastname Firstname' => 'Lastname Firstname',
        'Lastname Firstname (UserLogin)' => 'Lastname Firstname (UserLogin)',
        'Lastname, Firstname' => 'Lastname, Firstname',
        'Lastname, Firstname (UserLogin)' => 'Lastname, Firstname (UserLogin)',
        'Latvian' => 'Latvian',
        'Left' => 'Left',
        'Link Object' => 'Link Object',
        'Link Object.' => 'Link Object.',
        'Link agents to groups.' => 'Link agents to groups.',
        'Link agents to roles.' => 'Link agents to roles.',
        'Link attachments to templates.' => 'Link attachments to templates.',
        'Link customer user to groups.' => 'Link customer user to groups.',
        'Link customer user to services.' => 'Link customer user to services.',
        'Link queues to auto responses.' => 'Link queues to auto responses.',
        'Link roles to groups.' => 'Link roles to groups.',
        'Link templates to queues.' => 'Link templates to queues.',
        'Links 2 tickets with a "Normal" type link.' => 'Links 2 tickets with a "Normal" type link.',
        'Links 2 tickets with a "ParentChild" type link.' => 'Links 2 tickets with a "ParentChild" type link.',
        'List of CSS files to always be loaded for the agent interface.' =>
            'List of CSS files to always be loaded for the agent interface.',
        'List of CSS files to always be loaded for the customer interface.' =>
            'List of CSS files to always be loaded for the customer interface.',
        'List of JS files to always be loaded for the agent interface.' =>
            'List of JS files to always be loaded for the agent interface.',
        'List of JS files to always be loaded for the customer interface.' =>
            'List of JS files to always be loaded for the customer interface.',
        'List of all CustomerCompany events to be displayed in the GUI.' =>
            'List of all CustomerCompany events to be displayed in the GUI.',
        'List of all CustomerUser events to be displayed in the GUI.' => 'List of all CustomerUser events to be displayed in the GUI.',
        'List of all DynamicField events to be displayed in the GUI.' => 'List of all DynamicField events to be displayed in the GUI.',
        'List of all Package events to be displayed in the GUI.' => 'List of all Package events to be displayed in the GUI.',
        'List of all article events to be displayed in the GUI.' => 'List of all article events to be displayed in the GUI.',
        'List of all queue events to be displayed in the GUI.' => 'List of all queue events to be displayed in the GUI.',
        'List of all ticket events to be displayed in the GUI.' => 'List of all ticket events to be displayed in the GUI.',
        'List of default Standard Templates which are assigned automatically to new Queues upon creation.' =>
            'List of default Standard Templates which are assigned automatically to new Queues upon creation.',
        'List of responsive CSS files to always be loaded for the agent interface.' =>
            'List of responsive CSS files to always be loaded for the agent interface.',
        'List of responsive CSS files to always be loaded for the customer interface.' =>
            'List of responsive CSS files to always be loaded for the customer interface.',
        'List view' => 'List view',
        'Lithuanian' => 'Lithuanian',
        'Lock / unlock this ticket' => 'Lock / unlock this ticket',
        'Locked Tickets.' => 'Locked Tickets.',
        'Locked ticket.' => 'Locked ticket.',
        'Log file for the ticket counter.' => 'Log file for the ticket counter.',
        'Logout of customer panel.' => 'Logout of customer panel.',
        'Loop-Protection! No auto-response sent to "%s".' => 'Loop-Protection! No auto-response sent to "%s".',
        'Mail Accounts' => 'Mail Accounts',
        'Main menu registration.' => 'Main menu registration.',
        'Makes the application check the MX record of email addresses before sending an email or submitting a telephone or email ticket.' =>
            'Makes the application check the MX record of email addresses before sending an email or submitting a telephone or email ticket.',
        'Makes the application check the syntax of email addresses.' => 'Makes the application check the syntax of email addresses.',
        'Makes the session management use html cookies. If html cookies are disabled or if the client browser disabled html cookies, then the system will work as usual and append the session id to the links.' =>
            'Makes the session management use html cookies. If html cookies are disabled or if the client browser disabled html cookies, then the system will work as usual and append the session id to the links.',
        'Malay' => 'Malay',
        'Manage OTRS Group cloud services.' => 'Manage OTRS Group cloud services.',
        'Manage PGP keys for email encryption.' => 'Manage PGP keys for email encryption.',
        'Manage POP3 or IMAP accounts to fetch email from.' => 'Manage POP3 or IMAP accounts to fetch email from.',
        'Manage S/MIME certificates for email encryption.' => 'Manage S/MIME certificates for email encryption.',
        'Manage existing sessions.' => 'Manage existing sessions.',
        'Manage support data.' => 'Manage support data.',
        'Manage system registration.' => 'Manage system registration.',
        'Manage tasks triggered by event or time based execution.' => 'Manage tasks triggered by event or time based execution.',
        'Mark this ticket as junk!' => 'Mark this ticket as junk!',
        'Max size (in characters) of the customer information table (phone and email) in the compose screen.' =>
            'Max size (in characters) of the customer information table (phone and email) in the compose screen.',
        'Max size (in rows) of the informed agents box in the agent interface.' =>
            'Max size (in rows) of the informed agents box in the agent interface.',
        'Max size (in rows) of the involved agents box in the agent interface.' =>
            'Max size (in rows) of the involved agents box in the agent interface.',
        'Max size of the subjects in an email reply and in some overview screens.' =>
            'Max size of the subjects in an email reply and in some overview screens.',
        'Maximal auto email responses to own email-address a day (Loop-Protection).' =>
            'Maximal auto email responses to own email-address a day (Loop-Protection).',
        'Maximal size in KBytes for mails that can be fetched via POP3/POP3S/IMAP/IMAPS (KBytes).' =>
            'Maximal size in KBytes for mails that can be fetched via POP3/POP3S/IMAP/IMAPS (KBytes).',
        'Maximum Number of a calendar shown in a dropdown.' => 'Maximum Number of a calendar shown in a dropdown.',
        'Maximum length (in characters) of the dynamic field in the article of the ticket zoom view.' =>
            'Maximum length (in characters) of the dynamic field in the article of the ticket zoom view.',
        'Maximum length (in characters) of the dynamic field in the sidebar of the ticket zoom view.' =>
            'Maximum length (in characters) of the dynamic field in the sidebar of the ticket zoom view.',
        'Maximum number of tickets to be displayed in the result of a search in the agent interface.' =>
            'Maximum number of tickets to be displayed in the result of a search in the agent interface.',
        'Maximum number of tickets to be displayed in the result of a search in the customer interface.' =>
            'Maximum number of tickets to be displayed in the result of a search in the customer interface.',
        'Maximum number of tickets to be displayed in the result of this operation.' =>
            'Maximum number of tickets to be displayed in the result of this operation.',
        'Maximum size (in characters) of the customer information table in the ticket zoom view.' =>
            'Maximum size (in characters) of the customer information table in the ticket zoom view.',
        'Merge this ticket and all articles into a another ticket' => 'Merge this ticket and all articles into a another ticket',
        'Merged Ticket <OTRS_TICKET> to <OTRS_MERGE_TO_TICKET>.' => 'Merged Ticket <OTRS_TICKET> to <OTRS_MERGE_TO_TICKET>.',
        'Miscellaneous' => 'Miscellaneous',
        'Module for To-selection in new ticket screen in the customer interface.' =>
            'Module for To-selection in new ticket screen in the customer interface.',
        'Module to check if arrived emails should be marked as email-internal (because of original forwarded internal email). ArticleType and SenderType define the values for the arrived email/article.' =>
            'Module to check if arrived emails should be marked as email-internal (because of original forwarded internal email). ArticleType and SenderType define the values for the arrived email/article.',
        'Module to check the group permissions for customer access to tickets.' =>
            'Module to check the group permissions for customer access to tickets.',
        'Module to check the group permissions for the access to tickets.' =>
            'Module to check the group permissions for the access to tickets.',
        'Module to compose signed messages (PGP or S/MIME).' => 'Module to compose signed messages (PGP or S/MIME).',
        'Module to crypt composed messages (PGP or S/MIME).' => 'Module to crypt composed messages (PGP or S/MIME).',
        'Module to fetch customer users SMIME certificates of incoming messages.' =>
            '',
        'Module to filter and manipulate incoming messages. Block/ignore all spam email with From: noreply@ address.' =>
            'Module to filter and manipulate incoming messages. Block/ignore all spam email with From: noreply@ address.',
        'Module to filter and manipulate incoming messages. Get a 4 digit number to ticket free text, use regex in Match e. g. From => \'(.+?)@.+?\', and use () as [***] in Set =>.' =>
            'Module to filter and manipulate incoming messages. Get a 4 digit number to ticket free text, use regex in Match e. g. From => \'(.+?)@.+?\', and use () as [***] in Set =>.',
        'Module to filter encrypted bodies of incoming messages.' => '',
        'Module to generate accounted time ticket statistics.' => 'Module to generate accounted time ticket statistics.',
        'Module to generate html OpenSearch profile for short ticket search in the agent interface.' =>
            'Module to generate html OpenSearch profile for short ticket search in the agent interface.',
        'Module to generate html OpenSearch profile for short ticket search in the customer interface.' =>
            'Module to generate html OpenSearch profile for short ticket search in the customer interface.',
        'Module to generate ticket solution and response time statistics.' =>
            'Module to generate ticket solution and response time statistics.',
        'Module to generate ticket statistics.' => 'Module to generate ticket statistics.',
        'Module to grant access if the CustomerID of the ticket matches the CustomerID of the customer.' =>
            'Module to grant access if the CustomerID of the ticket matches the CustomerID of the customer.',
        'Module to grant access if the CustomerUserID of the ticket matches the CustomerUserID of the customer.' =>
            'Module to grant access if the CustomerUserID of the ticket matches the CustomerUserID of the customer.',
        'Module to grant access to any agent that has been involved in a ticket in the past (based on ticket history entries).' =>
            'Module to grant access to any agent that has been involved in a ticket in the past (based on ticket history entries).',
        'Module to grant access to the agent responsible of a ticket.' =>
            'Module to grant access to the agent responsible of a ticket.',
        'Module to grant access to the creator of a ticket.' => 'Module to grant access to the creator of a ticket.',
        'Module to grant access to the owner of a ticket.' => 'Module to grant access to the owner of a ticket.',
        'Module to grant access to the watcher agents of a ticket.' => 'Module to grant access to the watcher agents of a ticket.',
        'Module to show notifications and escalations (ShownMax: max. shown escalations, EscalationInMinutes: Show ticket which will escalation in, CacheTime: Cache of calculated escalations in seconds).' =>
            'Module to show notifications and escalations (ShownMax: max. shown escalations, EscalationInMinutes: Show ticket which will escalation in, CacheTime: Cache of calculated escalations in seconds).',
        'Module to use database filter storage.' => 'Module to use database filter storage.',
        'Multiselect' => 'Multiselect',
        'My Services' => 'My Services',
        'My Tickets.' => 'My Tickets.',
        'Name of custom queue. The custom queue is a queue selection of your preferred queues and can be selected in the preferences settings.' =>
            'Name of custom queue. The custom queue is a queue selection of your preferred queues and can be selected in the preferences settings.',
        'Name of custom service. The custom service is a service selection of your preferred services and can be selected in the preferences settings.' =>
            'Name of custom service. The custom service is a service selection of your preferred services and can be selected in the preferences settings.',
        'NameX' => 'NameX',
        'Nederlands' => 'Nederlands',
        'New Ticket [%s] created (Q=%s;P=%s;S=%s).' => 'New Ticket [%s] created (Q=%s;P=%s;S=%s).',
        'New Window' => 'New Window',
        'New owner is "%s" (ID=%s).' => 'New owner is "%s" (ID=%s).',
        'New process ticket' => 'New process ticket',
        'New responsible is "%s" (ID=%s).' => 'New responsible is "%s" (ID=%s).',
        'Next possible ticket states after adding a phone note in the ticket phone inbound screen of the agent interface.' =>
            'Next possible ticket states after adding a phone note in the ticket phone inbound screen of the agent interface.',
        'Next possible ticket states after adding a phone note in the ticket phone outbound screen of the agent interface.' =>
            'Next possible ticket states after adding a phone note in the ticket phone outbound screen of the agent interface.',
        'None' => 'None',
        'Norwegian' => 'Norwegian',
        'Notification sent to "%s".' => 'Notification sent to "%s".',
        'Number of displayed tickets' => 'Number of displayed tickets',
        'Number of lines (per ticket) that are shown by the search utility in the agent interface.' =>
            'Number of lines (per ticket) that are shown by the search utility in the agent interface.',
        'Number of tickets to be displayed in each page of a search result in the agent interface.' =>
            'Number of tickets to be displayed in each page of a search result in the agent interface.',
        'Number of tickets to be displayed in each page of a search result in the customer interface.' =>
            'Number of tickets to be displayed in each page of a search result in the customer interface.',
        'OTRS can use one or more readonly mirror databases for expensive operations like fulltext search or statistics generation. Here you can specify the DSN for the first mirror database.' =>
            'OTRS can use one or more readonly mirror databases for expensive operations like fulltext search or statistics generation. Here you can specify the DSN for the first mirror database.',
        'Old: "%s" New: "%s"' => 'Old: "%s" New: "%s"',
        'Online' => 'Online',
        'Open tickets (customer user)' => 'Open tickets (customer user)',
        'Open tickets (customer)' => 'Open tickets (customer)',
        'Option' => 'Option',
        'Optional queue limitation for the CreatorCheck permission module. If set, permission is only granted for tickets in the specified queues.' =>
            'Optional queue limitation for the CreatorCheck permission module. If set, permission is only granted for tickets in the specified queues.',
        'Optional queue limitation for the InvolvedCheck permission module. If set, permission is only granted for tickets in the specified queues.' =>
            'Optional queue limitation for the InvolvedCheck permission module. If set, permission is only granted for tickets in the specified queues.',
        'Optional queue limitation for the OwnerCheck permission module. If set, permission is only granted for tickets in the specified queues.' =>
            'Optional queue limitation for the OwnerCheck permission module. If set, permission is only granted for tickets in the specified queues.',
        'Optional queue limitation for the ResponsibleCheck permission module. If set, permission is only granted for tickets in the specified queues.' =>
            'Optional queue limitation for the ResponsibleCheck permission module. If set, permission is only granted for tickets in the specified queues.',
        'Out Of Office' => 'Out Of Office',
        'Overloads (redefines) existing functions in Kernel::System::Ticket. Used to easily add customizations.' =>
            'Overloads (redefines) existing functions in Kernel::System::Ticket. Used to easily add customizations.',
        'Overview Escalated Tickets.' => 'Overview Escalated Tickets.',
        'Overview Refresh Time' => 'Overview Refresh Time',
        'Overview of all escalated tickets.' => 'Overview of all escalated tickets.',
        'Overview of all open Tickets.' => 'Overview of all open Tickets.',
        'Overview of all open tickets.' => 'Overview of all open tickets.',
        'Overview of customer tickets.' => 'Overview of customer tickets.',
        'PGP Key Management' => 'PGP Key Management',
        'PGP Key Upload' => 'PGP Key Upload',
        'Package event module file a scheduler task for update registration.' =>
            'Package event module file a scheduler task for update registration.',
        'Parameters for the CreateNextMask object in the preference view of the agent interface.' =>
            'Parameters for the CreateNextMask object in the preference view of the agent interface.',
        'Parameters for the CustomQueue object in the preference view of the agent interface.' =>
            'Parameters for the CustomQueue object in the preference view of the agent interface.',
        'Parameters for the CustomService object in the preference view of the agent interface.' =>
            'Parameters for the CustomService object in the preference view of the agent interface.',
        'Parameters for the RefreshTime object in the preference view of the agent interface.' =>
            'Parameters for the RefreshTime object in the preference view of the agent interface.',
        'Parameters for the column filters of the small ticket overview.' =>
            'Parameters for the column filters of the small ticket overview.',
        'Parameters for the dashboard backend of the customer company information of the agent interface . "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'Parameters for the dashboard backend of the customer company information of the agent interface . "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.',
        'Parameters for the dashboard backend of the customer id status widget of the agent interface . "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'Parameters for the dashboard backend of the customer id status widget of the agent interface . "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.',
        'Parameters for the dashboard backend of the customer user list overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'Parameters for the dashboard backend of the customer user list overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.',
        'Parameters for the dashboard backend of the new tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.' =>
            'Parameters for the dashboard backend of the new tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.',
        'Parameters for the dashboard backend of the open tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.' =>
            'Parameters for the dashboard backend of the open tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.',
        'Parameters for the dashboard backend of the queue overview widget of the agent interface. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "QueuePermissionGroup" is not mandatory, queues are only listed if they belong to this permission group if you enable it. "States" is a list of states, the key is the sort order of the state in the widget. "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'Parameters for the dashboard backend of the queue overview widget of the agent interface. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "QueuePermissionGroup" is not mandatory, queues are only listed if they belong to this permission group if you enable it. "States" is a list of states, the key is the sort order of the state in the widget. "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.',
        'Parameters for the dashboard backend of the running process tickets overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'Parameters for the dashboard backend of the running process tickets overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.',
        'Parameters for the dashboard backend of the ticket escalation overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.' =>
            'Parameters for the dashboard backend of the ticket escalation overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.',
        'Parameters for the dashboard backend of the ticket events calendar of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'Parameters for the dashboard backend of the ticket events calendar of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.',
        'Parameters for the dashboard backend of the ticket pending reminder overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.' =>
            'Parameters for the dashboard backend of the ticket pending reminder overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.',
        'Parameters for the dashboard backend of the ticket stats of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'Parameters for the dashboard backend of the ticket stats of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.',
        'Parameters for the dashboard backend of the upcoming events widget of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'Parameters for the dashboard backend of the upcoming events widget of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.',
        'Parameters for the pages (in which the dynamic fields are shown) of the dynamic fields overview.' =>
            'Parameters for the pages (in which the dynamic fields are shown) of the dynamic fields overview.',
        'Parameters for the pages (in which the tickets are shown) of the medium ticket overview.' =>
            'Parameters for the pages (in which the tickets are shown) of the medium ticket overview.',
        'Parameters for the pages (in which the tickets are shown) of the small ticket overview.' =>
            'Parameters for the pages (in which the tickets are shown) of the small ticket overview.',
        'Parameters for the pages (in which the tickets are shown) of the ticket preview overview.' =>
            'Parameters for the pages (in which the tickets are shown) of the ticket preview overview.',
        'Parameters of the example SLA attribute Comment2.' => 'Parameters of the example SLA attribute Comment2.',
        'Parameters of the example queue attribute Comment2.' => 'Parameters of the example queue attribute Comment2.',
        'Parameters of the example service attribute Comment2.' => 'Parameters of the example service attribute Comment2.',
        'ParentChild' => 'ParentChild',
        'Path for the log file (it only applies if "FS" was selected for LoopProtectionModule and it is mandatory).' =>
            'Path for the log file (it only applies if "FS" was selected for LoopProtectionModule and it is mandatory).',
        'People' => 'People',
        'Performs the configured action for each event (as an Invoker) for each configured Webservice.' =>
            'Performs the configured action for each event (as an Invoker) for each configured Webservice.',
        'Permitted width for compose email windows.' => 'Permitted width for compose email windows.',
        'Permitted width for compose note windows.' => 'Permitted width for compose note windows.',
        'Persian' => 'Persian',
        'Phone Call.' => 'Phone Call.',
        'Picture Upload' => 'Picture Upload',
        'Picture upload module.' => 'Picture upload module.',
        'Picture-Upload' => 'Picture-Upload',
        'Polish' => 'Polish',
        'Portuguese' => 'Portuguese',
        'Portuguese (Brasil)' => 'Portuguese (Brasil)',
        'PostMaster Filters' => 'PostMaster Filters',
        'PostMaster Mail Accounts' => 'PostMaster Mail Accounts',
        'Process Management Activity Dialog GUI' => 'Process Management Activity Dialog GUI',
        'Process Management Activity GUI' => 'Process Management Activity GUI',
        'Process Management Path GUI' => 'Process Management Path GUI',
        'Process Management Transition Action GUI' => 'Process Management Transition Action GUI',
        'Process Management Transition GUI' => 'Process Management Transition GUI',
        'Process Ticket.' => 'Process Ticket.',
        'Process pending tickets.' => 'Process pending tickets.',
        'Process ticket' => 'Process ticket',
        'ProcessID' => 'ProcessID',
        'Protection against CSRF (Cross Site Request Forgery) exploits (for more info see http://en.wikipedia.org/wiki/Cross-site_request_forgery).' =>
            'Protection against CSRF (Cross Site Request Forgery) exploits (for more info see http://en.wikipedia.org/wiki/Cross-site_request_forgery).',
        'Provides a matrix overview of the tickets per state per queue.' =>
            'Provides a matrix overview of the tickets per state per queue.',
        'Queue view' => 'Queue view',
        'Rebuild the ticket index for AgentTicketQueue.' => 'Rebuild the ticket index for AgentTicketQueue.',
        'Recognize if a ticket is a follow-up to an existing ticket using an external ticket number.' =>
            'Recognise if a ticket is a follow-up to an existing ticket using an external ticket number.',
        'Refresh interval' => 'Refresh interval',
        'Removed subscription for user "%s".' => 'Removed subscription for user "%s".',
        'Removes the ticket watcher information when a ticket is archived.' =>
            'Removes the ticket watcher information when a ticket is archived.',
        'Renew existing SMIME certificates from customer backend. Note: SMIME and SMIME::FetchFromCustomer needs to be active in SysConfig and customer backend needs to be configured to fetch UserSMIMECertificate attribute.' =>
            '',
        'Replaces the original sender with current customer\'s email address on compose answer in the ticket compose screen of the agent interface.' =>
            'Replaces the original sender with current customer\'s email address on compose answer in the ticket compose screen of the agent interface.',
        'Reports' => 'Reports',
        'Reports (OTRS Business Solution™)' => 'Reports (OTRS Business Solution™)',
        'Reprocess mails from spool directory that could not be imported in the first place.' =>
            'Reprocess mails from spool directory that could not be imported in the first place.',
        'Required permissions to change the customer of a ticket in the agent interface.' =>
            'Required permissions to change the customer of a ticket in the agent interface.',
        'Required permissions to use the close ticket screen in the agent interface.' =>
            'Required permissions to use the close ticket screen in the agent interface.',
        'Required permissions to use the email outbound screen in the agent interface.' =>
            'Required permissions to use the email outbound screen in the agent interface.',
        'Required permissions to use the ticket bounce screen in the agent interface.' =>
            'Required permissions to use the ticket bounce screen in the agent interface.',
        'Required permissions to use the ticket compose screen in the agent interface.' =>
            'Required permissions to use the ticket compose screen in the agent interface.',
        'Required permissions to use the ticket forward screen in the agent interface.' =>
            'Required permissions to use the ticket forward screen in the agent interface.',
        'Required permissions to use the ticket free text screen in the agent interface.' =>
            'Required permissions to use the ticket free text screen in the agent interface.',
        'Required permissions to use the ticket merge screen of a zoomed ticket in the agent interface.' =>
            'Required permissions to use the ticket merge screen of a zoomed ticket in the agent interface.',
        'Required permissions to use the ticket note screen in the agent interface.' =>
            'Required permissions to use the ticket note screen in the agent interface.',
        'Required permissions to use the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Required permissions to use the ticket owner screen of a zoomed ticket in the agent interface.',
        'Required permissions to use the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Required permissions to use the ticket pending screen of a zoomed ticket in the agent interface.',
        'Required permissions to use the ticket phone inbound screen in the agent interface.' =>
            'Required permissions to use the ticket phone inbound screen in the agent interface.',
        'Required permissions to use the ticket phone outbound screen in the agent interface.' =>
            'Required permissions to use the ticket phone outbound screen in the agent interface.',
        'Required permissions to use the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Required permissions to use the ticket priority screen of a zoomed ticket in the agent interface.',
        'Required permissions to use the ticket responsible screen in the agent interface.' =>
            'Required permissions to use the ticket responsible screen in the agent interface.',
        'Resets and unlocks the owner of a ticket if it was moved to another queue.' =>
            'Resets and unlocks the owner of a ticket if it was moved to another queue.',
        'Responsible Tickets' => 'Responsible Tickets',
        'Responsible Tickets.' => 'Responsible Tickets.',
        'Restores a ticket from the archive (only if the event is a state change to any open available state).' =>
            '',
        'Retains all services in listings even if they are children of invalid elements.' =>
            'Retains all services in listings even if they are children of invalid elements.',
        'Right' => 'Right',
        'Roles <-> Groups' => 'Roles <-> Groups',
        'Run file based generic agent jobs (Note: module name need needs to be specified in -configuration-module param e.g. "Kernel::System::GenericAgent").' =>
            'Run file based generic agent jobs (Note: module name need needs to be specified in -configuration-module param e.g. "Kernel::System::GenericAgent").',
        'Running Process Tickets' => 'Running Process Tickets',
        'Runs an initial wildcard search of the existing customer company when accessing the AdminCustomerCompany module.' =>
            'Runs an initial wildcard search of the existing customer company when accessing the AdminCustomerCompany module.',
        'Runs an initial wildcard search of the existing customer users when accessing the AdminCustomerUser module.' =>
            'Runs an initial wildcard search of the existing customer users when accessing the AdminCustomerUser module.',
        'Runs the system in "Demo" mode. If set to "Yes", agents can change preferences, such as selection of language and theme via the agent web interface. These changes are only valid for the current session. It will not be possible for agents to change their passwords.' =>
            'Runs the system in "Demo" mode. If set to "Yes", agents can change preferences, such as selection of language and theme via the agent web interface. These changes are only valid for the current session. It will not be possible for agents to change their passwords.',
        'Russian' => 'Russian',
        'S/MIME Certificate Upload' => 'S/MIME Certificate Upload',
        'SMS' => 'SMS',
        'SMS (Short Message Service)' => 'SMS (Short Message Service)',
        'Sample command output' => 'Sample command output',
        'Saves the attachments of articles. "DB" stores all data in the database (not recommended for storing big attachments). "FS" stores the data on the filesystem; this is faster but the webserver should run under the OTRS user. You can switch between the modules even on a system that is already in production without any loss of data. Note: Searching for attachment names is not supported when "FS" is used.' =>
            'Saves the attachments of articles. "DB" stores all data in the database (not recommended for storing big attachments). "FS" stores the data on the filesystem; this is faster but the webserver should run under the OTRS user. You can switch between the modules even on a system that is already in production without any loss of data. Note: Searching for attachment names is not supported when "FS" is used.',
        'Schedule a maintenance period.' => 'Schedule a maintenance period.',
        'Screen' => 'Screen',
        'Search Customer' => 'Search Customer',
        'Search Ticket.' => 'Search Ticket.',
        'Search Tickets.' => 'Search Tickets.',
        'Search User' => 'Search User',
        'Search backend default router.' => 'Search backend default router.',
        'Search backend router.' => 'Search backend router.',
        'Search.' => 'Search.',
        'Second Queue' => 'Second Queue',
        'Select after which period ticket overviews should refresh automatically.' =>
            '',
        'Select how many tickets should be shown in overviews by default.' =>
            '',
        'Select the main interface language.' => '',
        'Select your frontend Theme.' => 'Select your frontend Theme.',
        'Select your preferred layout for OTRS.' => '',
        'Selects the cache backend to use.' => 'Selects the cache backend to use.',
        'Selects the module to handle uploads via the web interface. "DB" stores all uploads in the database, "FS" uses the file system.' =>
            'Selects the module to handle uploads via the web interface. "DB" stores all uploads in the database, "FS" uses the file system.',
        'Selects the ticket number generator module. "AutoIncrement" increments the ticket number, the SystemID and the counter are used with SystemID.counter format (e.g. 1010138, 1010139). With "Date" the ticket numbers will be generated by the current date, the SystemID and the counter. The format looks like Year.Month.Day.SystemID.counter (e.g. 200206231010138, 200206231010139). With "DateChecksum"  the counter will be appended as checksum to the string of date and SystemID. The checksum will be rotated on a daily basis. The format looks like Year.Month.Day.SystemID.Counter.CheckSum (e.g. 2002070110101520, 2002070110101535). "Random" generates randomized ticket numbers in the format "SystemID.Random" (e.g. 100057866352, 103745394596).' =>
            'Selects the ticket number generator module. "AutoIncrement" increments the ticket number, the SystemID and the counter are used with SystemID.counter format (e.g. 1010138, 1010139). With "Date" the ticket numbers will be generated by the current date, the SystemID and the counter. The format looks like Year.Month.Day.SystemID.counter (e.g. 200206231010138, 200206231010139). With "DateChecksum"  the counter will be appended as checksum to the string of date and SystemID. The checksum will be rotated on a daily basis. The format looks like Year.Month.Day.SystemID.Counter.CheckSum (e.g. 2002070110101520, 2002070110101535). "Random" generates randomised ticket numbers in the format "SystemID.Random" (e.g. 100057866352, 103745394596).',
        'Send new outgoing mail from this ticket' => 'Send new outgoing mail from this ticket',
        'Send notifications to users.' => 'Send notifications to users.',
        'Sender type for new tickets from the customer inteface.' => 'Sender type for new tickets from the customer inteface.',
        'Sends agent follow-up notification only to the owner, if a ticket is unlocked (the default is to send the notification to all agents).' =>
            'Sends agent follow-up notification only to the owner, if a ticket is unlocked (the default is to send the notification to all agents).',
        'Sends all outgoing email via bcc to the specified address. Please use this only for backup reasons.' =>
            'Sends all outgoing email via bcc to the specified address. Please use this only for backup reasons.',
        'Sends customer notifications just to the mapped customer.' => 'Sends customer notifications just to the mapped customer.',
        'Sends registration information to OTRS group.' => 'Sends registration information to OTRS group.',
        'Sends reminder notifications of unlocked ticket after reaching the reminder date (only sent to ticket owner).' =>
            'Sends reminder notifications of unlocked ticket after reaching the reminder date (only sent to ticket owner).',
        'Sends the notifications which are configured in the admin interface under "Notfication (Event)".' =>
            'Sends the notifications which are configured in the admin interface under "Notfication (Event)".',
        'Serbian Cyrillic' => 'Serbian Cyrillic',
        'Serbian Latin' => 'Serbian Latin',
        'Service view' => 'Service view',
        'ServiceView' => 'ServiceView',
        'Set a new password by filling in your current password and a new one.' =>
            '',
        'Set sender email addresses for this system.' => 'Set sender email addresses for this system.',
        'Set the default height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            'Set the default height (in pixels) of inline HTML articles in AgentTicketZoom.',
        'Set the limit of tickets that will be executed on a single genericagent job execution.' =>
            'Set the limit of tickets that will be executed on a single genericagent job execution.',
        'Set the maximum height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            'Set the maximum height (in pixels) of inline HTML articles in AgentTicketZoom.',
        'Set the minimum log level. If you select \'error\', just errors are logged. With \'debug\' you get all logging messages. The order of log levels is: \'debug\', \'info\', \'notice\' and \'error\'.' =>
            '',
        'Set this to yes if you trust in all your public and private pgp keys, even if they are not certified with a trusted signature.' =>
            'Set this to yes if you trust in all your public and private pgp keys, even if they are not certified with a trusted signature.',
        'Sets if SLA must be selected by the agent.' => 'Sets if SLA must be selected by the agent.',
        'Sets if SLA must be selected by the customer.' => 'Sets if SLA must be selected by the customer.',
        'Sets if note must be filled in by the agent. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Sets if note must be filled in by the agent. Can be overwritten by Ticket::Frontend::NeedAccountedTime.',
        'Sets if service must be selected by the agent.' => 'Sets if service must be selected by the agent.',
        'Sets if service must be selected by the customer.' => 'Sets if service must be selected by the customer.',
        'Sets if ticket owner must be selected by the agent.' => 'Sets if ticket owner must be selected by the agent.',
        'Sets the PendingTime of a ticket to 0 if the state is changed to a non-pending state.' =>
            'Sets the PendingTime of a ticket to 0 if the state is changed to a non-pending state.',
        'Sets the age in minutes (first level) for highlighting queues that contain untouched tickets.' =>
            'Sets the age in minutes (first level) for highlighting queues that contain untouched tickets.',
        'Sets the age in minutes (second level) for highlighting queues that contain untouched tickets.' =>
            'Sets the age in minutes (second level) for highlighting queues that contain untouched tickets.',
        'Sets the configuration level of the administrator. Depending on the config level, some sysconfig options will be not shown. The config levels are in in ascending order: Expert, Advanced, Beginner. The higher the config level is (e.g. Beginner is the highest), the less likely is it that the user can accidentally configure the system in a way that it is not usable any more.' =>
            'Sets the configuration level of the administrator. Depending on the config level, some sysconfig options will be not shown. The config levels are in in ascending order: Expert, Advanced, Beginner. The higher the config level is (e.g. Beginner is the highest), the less likely is it that the user can accidentally configure the system in a way that it is not usable any more.',
        'Sets the count of articles visible in preview mode of ticket overviews.' =>
            'Sets the count of articles visible in preview mode of ticket overviews.',
        'Sets the default article type for new email tickets in the agent interface.' =>
            'Sets the default article type for new email tickets in the agent interface.',
        'Sets the default article type for new phone tickets in the agent interface.' =>
            'Sets the default article type for new phone tickets in the agent interface.',
        'Sets the default body text for notes added in the close ticket screen of the agent interface.' =>
            'Sets the default body text for notes added in the close ticket screen of the agent interface.',
        'Sets the default body text for notes added in the ticket move screen of the agent interface.' =>
            'Sets the default body text for notes added in the ticket move screen of the agent interface.',
        'Sets the default body text for notes added in the ticket note screen of the agent interface.' =>
            'Sets the default body text for notes added in the ticket note screen of the agent interface.',
        'Sets the default body text for notes added in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Sets the default body text for notes added in the ticket owner screen of a zoomed ticket in the agent interface.',
        'Sets the default body text for notes added in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Sets the default body text for notes added in the ticket pending screen of a zoomed ticket in the agent interface.',
        'Sets the default body text for notes added in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Sets the default body text for notes added in the ticket priority screen of a zoomed ticket in the agent interface.',
        'Sets the default body text for notes added in the ticket responsible screen of the agent interface.' =>
            'Sets the default body text for notes added in the ticket responsible screen of the agent interface.',
        'Sets the default error message for the login screen on Agent and Customer interface, it\'s shown when a running system maintenance period is active.' =>
            'Sets the default error message for the login screen on Agent and Customer interface, it\'s shown when a running system maintenance period is active.',
        'Sets the default link type of splitted tickets in the agent interface.' =>
            'Sets the default link type of splitted tickets in the agent interface.',
        'Sets the default message for the login screen on Agent and Customer interface, it\'s shown when a running system maintenance period is active.' =>
            'Sets the default message for the login screen on Agent and Customer interface, it\'s shown when a running system maintenance period is active.',
        'Sets the default message for the notification is shown on a running system maintenance period.' =>
            'Sets the default message for the notification is shown on a running system maintenance period.',
        'Sets the default next state for new phone tickets in the agent interface.' =>
            'Sets the default next state for new phone tickets in the agent interface.',
        'Sets the default next ticket state, after the creation of an email ticket in the agent interface.' =>
            'Sets the default next ticket state, after the creation of an email ticket in the agent interface.',
        'Sets the default note text for new telephone tickets. E.g \'New ticket via call\' in the agent interface.' =>
            'Sets the default note text for new telephone tickets. E.g \'New ticket via call\' in the agent interface.',
        'Sets the default priority for new email tickets in the agent interface.' =>
            'Sets the default priority for new email tickets in the agent interface.',
        'Sets the default priority for new phone tickets in the agent interface.' =>
            'Sets the default priority for new phone tickets in the agent interface.',
        'Sets the default sender type for new email tickets in the agent interface.' =>
            'Sets the default sender type for new email tickets in the agent interface.',
        'Sets the default sender type for new phone ticket in the agent interface.' =>
            'Sets the default sender type for new phone ticket in the agent interface.',
        'Sets the default subject for new email tickets (e.g. \'email Outbound\') in the agent interface.' =>
            'Sets the default subject for new email tickets (e.g. \'email Outbound\') in the agent interface.',
        'Sets the default subject for new phone tickets (e.g. \'Phone call\') in the agent interface.' =>
            'Sets the default subject for new phone tickets (e.g. \'Phone call\') in the agent interface.',
        'Sets the default subject for notes added in the close ticket screen of the agent interface.' =>
            'Sets the default subject for notes added in the close ticket screen of the agent interface.',
        'Sets the default subject for notes added in the ticket move screen of the agent interface.' =>
            'Sets the default subject for notes added in the ticket move screen of the agent interface.',
        'Sets the default subject for notes added in the ticket note screen of the agent interface.' =>
            'Sets the default subject for notes added in the ticket note screen of the agent interface.',
        'Sets the default subject for notes added in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Sets the default subject for notes added in the ticket owner screen of a zoomed ticket in the agent interface.',
        'Sets the default subject for notes added in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Sets the default subject for notes added in the ticket pending screen of a zoomed ticket in the agent interface.',
        'Sets the default subject for notes added in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Sets the default subject for notes added in the ticket priority screen of a zoomed ticket in the agent interface.',
        'Sets the default subject for notes added in the ticket responsible screen of the agent interface.' =>
            'Sets the default subject for notes added in the ticket responsible screen of the agent interface.',
        'Sets the default text for new email tickets in the agent interface.' =>
            'Sets the default text for new email tickets in the agent interface.',
        'Sets the display order of the different items in the preferences view.' =>
            'Sets the display order of the different items in the preferences view.',
        'Sets the inactivity time (in seconds) to pass before a session is killed and a user is logged out.' =>
            '',
        'Sets the maximum number of active agents within the timespan defined in SessionActiveTime before a prior warning will be visible for the logged in agents.' =>
            '',
        'Sets the maximum number of active agents within the timespan defined in SessionActiveTime.' =>
            'Sets the maximum number of active agents within the timespan defined in SessionActiveTime.',
        'Sets the maximum number of active customers within the timespan defined in SessionActiveTime.' =>
            'Sets the maximum number of active customers within the timespan defined in SessionActiveTime.',
        'Sets the maximum number of active sessions per agent within the timespan defined in SessionActiveTime.' =>
            'Sets the maximum number of active sessions per agent within the timespan defined in SessionActiveTime.',
        'Sets the maximum number of active sessions per customers within the timespan defined in SessionActiveTime.' =>
            'Sets the maximum number of active sessions per customers within the timespan defined in SessionActiveTime.',
        'Sets the minimal ticket counter size if "AutoIncrement" was selected as TicketNumberGenerator. Default is 5, this means the counter starts from 10000.' =>
            'Sets the minimal ticket counter size if "AutoIncrement" was selected as TicketNumberGenerator. Default is 5, this means the counter starts from 10000.',
        'Sets the minutes a notification is shown for notice about upcoming system maintenance period.' =>
            'Sets the minutes a notification is shown for notice about upcoming system maintenance period.',
        'Sets the number of lines that are displayed in text messages (e.g. ticket lines in the QueueZoom).' =>
            'Sets the number of lines that are displayed in text messages (e.g. ticket lines in the QueueZoom).',
        'Sets the options for PGP binary.' => 'Sets the options for PGP binary.',
        'Sets the order of the different items in the customer preferences view.' =>
            'Sets the order of the different items in the customer preferences view.',
        'Sets the password for private PGP key.' => 'Sets the password for private PGP key.',
        'Sets the prefered time units (e.g. work units, hours, minutes).' =>
            'Sets the prefered time units (e.g. work units, hours, minutes).',
        'Sets the prefix to the scripts folder on the server, as configured on the web server. This setting is used as a variable, OTRS_CONFIG_ScriptAlias which is found in all forms of messaging used by the application, to build links to the tickets within the system.' =>
            'Sets the prefix to the scripts folder on the server, as configured on the web server. This setting is used as a variable, OTRS_CONFIG_ScriptAlias which is found in all forms of messaging used by the application, to build links to the tickets within the system.',
        'Sets the queue in the ticket close screen of a zoomed ticket in the agent interface.' =>
            'Sets the queue in the ticket close screen of a zoomed ticket in the agent interface.',
        'Sets the queue in the ticket free text screen of a zoomed ticket in the agent interface.' =>
            'Sets the queue in the ticket free text screen of a zoomed ticket in the agent interface.',
        'Sets the queue in the ticket note screen of a zoomed ticket in the agent interface.' =>
            'Sets the queue in the ticket note screen of a zoomed ticket in the agent interface.',
        'Sets the queue in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Sets the queue in the ticket owner screen of a zoomed ticket in the agent interface.',
        'Sets the queue in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Sets the queue in the ticket pending screen of a zoomed ticket in the agent interface.',
        'Sets the queue in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Sets the queue in the ticket priority screen of a zoomed ticket in the agent interface.',
        'Sets the queue in the ticket responsible screen of a zoomed ticket in the agent interface.' =>
            'Sets the queue in the ticket responsible screen of a zoomed ticket in the agent interface.',
        'Sets the responsible agent of the ticket in the close ticket screen of the agent interface.' =>
            'Sets the responsible agent of the ticket in the close ticket screen of the agent interface.',
        'Sets the responsible agent of the ticket in the ticket bulk screen of the agent interface.' =>
            'Sets the responsible agent of the ticket in the ticket bulk screen of the agent interface.',
        'Sets the responsible agent of the ticket in the ticket free text screen of the agent interface.' =>
            'Sets the responsible agent of the ticket in the ticket free text screen of the agent interface.',
        'Sets the responsible agent of the ticket in the ticket note screen of the agent interface.' =>
            'Sets the responsible agent of the ticket in the ticket note screen of the agent interface.',
        'Sets the responsible agent of the ticket in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Sets the responsible agent of the ticket in the ticket owner screen of a zoomed ticket in the agent interface.',
        'Sets the responsible agent of the ticket in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Sets the responsible agent of the ticket in the ticket pending screen of a zoomed ticket in the agent interface.',
        'Sets the responsible agent of the ticket in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Sets the responsible agent of the ticket in the ticket priority screen of a zoomed ticket in the agent interface.',
        'Sets the responsible agent of the ticket in the ticket responsible screen of the agent interface.' =>
            'Sets the responsible agent of the ticket in the ticket responsible screen of the agent interface.',
        'Sets the service in the close ticket screen of the agent interface (Ticket::Service needs to be activated).' =>
            'Sets the service in the close ticket screen of the agent interface (Ticket::Service needs to be activated).',
        'Sets the service in the ticket free text screen of the agent interface (Ticket::Service needs to be activated).' =>
            'Sets the service in the ticket free text screen of the agent interface (Ticket::Service needs to be activated).',
        'Sets the service in the ticket note screen of the agent interface (Ticket::Service needs to be activated).' =>
            'Sets the service in the ticket note screen of the agent interface (Ticket::Service needs to be activated).',
        'Sets the service in the ticket owner screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).' =>
            'Sets the service in the ticket owner screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).',
        'Sets the service in the ticket pending screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).' =>
            'Sets the service in the ticket pending screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).',
        'Sets the service in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).' =>
            'Sets the service in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).',
        'Sets the service in the ticket responsible screen of the agent interface (Ticket::Service needs to be activated).' =>
            'Sets the service in the ticket responsible screen of the agent interface (Ticket::Service needs to be activated).',
        'Sets the state of a ticket in the close ticket screen of the agent interface.' =>
            '',
        'Sets the state of a ticket in the ticket bulk screen of the agent interface.' =>
            '',
        'Sets the state of a ticket in the ticket free text screen of the agent interface.' =>
            '',
        'Sets the state of a ticket in the ticket note screen of the agent interface.' =>
            '',
        'Sets the state of a ticket in the ticket responsible screen of the agent interface.' =>
            '',
        'Sets the state of the ticket in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the state of the ticket in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the state of the ticket in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the stats hook.' => 'Sets the stats hook.',
        'Sets the system time zone (required a system with UTC as system time). Otherwise this is a diff time to the local time.' =>
            'Sets the system time zone (required a system with UTC as system time). Otherwise this is a diff time to the local time.',
        'Sets the ticket owner in the close ticket screen of the agent interface.' =>
            'Sets the ticket owner in the close ticket screen of the agent interface.',
        'Sets the ticket owner in the ticket bulk screen of the agent interface.' =>
            'Sets the ticket owner in the ticket bulk screen of the agent interface.',
        'Sets the ticket owner in the ticket free text screen of the agent interface.' =>
            'Sets the ticket owner in the ticket free text screen of the agent interface.',
        'Sets the ticket owner in the ticket note screen of the agent interface.' =>
            'Sets the ticket owner in the ticket note screen of the agent interface.',
        'Sets the ticket owner in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Sets the ticket owner in the ticket owner screen of a zoomed ticket in the agent interface.',
        'Sets the ticket owner in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Sets the ticket owner in the ticket pending screen of a zoomed ticket in the agent interface.',
        'Sets the ticket owner in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Sets the ticket owner in the ticket priority screen of a zoomed ticket in the agent interface.',
        'Sets the ticket owner in the ticket responsible screen of the agent interface.' =>
            'Sets the ticket owner in the ticket responsible screen of the agent interface.',
        'Sets the ticket type in the close ticket screen of the agent interface (Ticket::Type needs to be activated).' =>
            'Sets the ticket type in the close ticket screen of the agent interface (Ticket::Type needs to be activated).',
        'Sets the ticket type in the ticket bulk screen of the agent interface.' =>
            'Sets the ticket type in the ticket bulk screen of the agent interface.',
        'Sets the ticket type in the ticket free text screen of the agent interface (Ticket::Type needs to be activated).' =>
            'Sets the ticket type in the ticket free text screen of the agent interface (Ticket::Type needs to be activated).',
        'Sets the ticket type in the ticket note screen of the agent interface (Ticket::Type needs to be activated).' =>
            'Sets the ticket type in the ticket note screen of the agent interface (Ticket::Type needs to be activated).',
        'Sets the ticket type in the ticket owner screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).' =>
            'Sets the ticket type in the ticket owner screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).',
        'Sets the ticket type in the ticket pending screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).' =>
            'Sets the ticket type in the ticket pending screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).',
        'Sets the ticket type in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).' =>
            'Sets the ticket type in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).',
        'Sets the ticket type in the ticket responsible screen of the agent interface (Ticket::Type needs to be activated).' =>
            'Sets the ticket type in the ticket responsible screen of the agent interface (Ticket::Type needs to be activated).',
        'Sets the time (in seconds) a user is marked as active (minimum active time is 300 seconds).' =>
            '',
        'Sets the timeout (in seconds) for http/ftp downloads.' => 'Sets the timeout (in seconds) for http/ftp downloads.',
        'Sets the timeout (in seconds) for package downloads. Overwrites "WebUserAgent::Timeout".' =>
            'Sets the timeout (in seconds) for package downloads. Overwrites "WebUserAgent::Timeout".',
        'Sets the user time zone per user (required a system with UTC as system time and UTC under TimeZone). Otherwise this is a diff time to the local time.' =>
            'Sets the user time zone per user (required a system with UTC as system time and UTC under TimeZone). Otherwise this is a diff time to the local time.',
        'Sets the user time zone per user based on java script / browser time zone offset feature at login time.' =>
            'Sets the user time zone per user based on java script / browser time zone offset feature at login time.',
        'Shared Secret' => 'Shared Secret',
        'Should the cache data be held in memory?' => 'Should the cache data be held in memory?',
        'Should the cache data be stored in the selected cache backend?' =>
            'Should the cache data be stored in the selected cache backend?',
        'Show a responsible selection in phone and email tickets in the agent interface.' =>
            'Show a responsible selection in phone and email tickets in the agent interface.',
        'Show article as rich text even if rich text writing is disabled.' =>
            'Show article as rich text even if rich text writing is disabled.',
        'Show queues even when only locked tickets are in.' => 'Show queues even when only locked tickets are in.',
        'Show the current owner in the customer interface.' => 'Show the current owner in the customer interface.',
        'Show the current queue in the customer interface.' => 'Show the current queue in the customer interface.',
        'Show the history for this ticket' => 'Show the history for this ticket',
        'Shows a count of icons in the ticket zoom, if the article has attachments.' =>
            'Shows a count of icons in the ticket zoom, if the article has attachments.',
        'Shows a link in the menu for subscribing / unsubscribing from a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Shows a link in the menu for subscribing / unsubscribing from a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.',
        'Shows a link in the menu that allows linking a ticket with another object in the ticket zoom view of the agent interface.  Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Shows a link in the menu that allows linking a ticket with another object in the ticket zoom view of the agent interface.  Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.',
        'Shows a link in the menu that allows merging tickets in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Shows a link in the menu that allows merging tickets in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.',
        'Shows a link in the menu to access the history of a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Shows a link in the menu to access the history of a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.',
        'Shows a link in the menu to add a free text field in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Shows a link in the menu to add a free text field in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.',
        'Shows a link in the menu to add a note in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Shows a link in the menu to add a note in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.',
        'Shows a link in the menu to add a note to a ticket in every ticket overview of the agent interface.' =>
            'Shows a link in the menu to add a note to a ticket in every ticket overview of the agent interface.',
        'Shows a link in the menu to close a ticket in every ticket overview of the agent interface.' =>
            'Shows a link in the menu to close a ticket in every ticket overview of the agent interface.',
        'Shows a link in the menu to close a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Shows a link in the menu to close a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.',
        'Shows a link in the menu to delete a ticket in every ticket overview of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Shows a link in the menu to delete a ticket in every ticket overview of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".',
        'Shows a link in the menu to delete a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Shows a link in the menu to delete a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.',
        'Shows a link in the menu to enroll a ticket into a process in the ticket zoom view of the agent interface.' =>
            'Shows a link in the menu to enroll a ticket into a process in the ticket zoom view of the agent interface.',
        'Shows a link in the menu to go back in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Shows a link in the menu to go back in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.',
        'Shows a link in the menu to lock / unlock a ticket in the ticket overviews of the agent interface.' =>
            'Shows a link in the menu to lock / unlock a ticket in the ticket overviews of the agent interface.',
        'Shows a link in the menu to lock/unlock tickets in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Shows a link in the menu to lock/unlock tickets in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.',
        'Shows a link in the menu to move a ticket in every ticket overview of the agent interface.' =>
            'Shows a link in the menu to move a ticket in every ticket overview of the agent interface.',
        'Shows a link in the menu to print a ticket or an article in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Shows a link in the menu to print a ticket or an article in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.',
        'Shows a link in the menu to see the customer who requested the ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Shows a link in the menu to see the customer who requested the ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.',
        'Shows a link in the menu to see the history of a ticket in every ticket overview of the agent interface.' =>
            'Shows a link in the menu to see the history of a ticket in every ticket overview of the agent interface.',
        'Shows a link in the menu to see the owner of a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Shows a link in the menu to see the owner of a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.',
        'Shows a link in the menu to see the priority of a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Shows a link in the menu to see the priority of a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.',
        'Shows a link in the menu to see the responsible agent of a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Shows a link in the menu to see the responsible agent of a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.',
        'Shows a link in the menu to send an outbound email in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Shows a link in the menu to send an outbound email in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.',
        'Shows a link in the menu to set a ticket as junk in every ticket overview of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Shows a link in the menu to set a ticket as junk in every ticket overview of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".',
        'Shows a link in the menu to set a ticket as pending in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Shows a link in the menu to set a ticket as pending in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.',
        'Shows a link in the menu to set the priority of a ticket in every ticket overview of the agent interface.' =>
            'Shows a link in the menu to set the priority of a ticket in every ticket overview of the agent interface.',
        'Shows a link in the menu to zoom a ticket in the ticket overviews of the agent interface.' =>
            'Shows a link in the menu to zoom a ticket in the ticket overviews of the agent interface.',
        'Shows a link to access article attachments via a html online viewer in the zoom view of the article in the agent interface.' =>
            'Shows a link to access article attachments via a html online viewer in the zoom view of the article in the agent interface.',
        'Shows a link to download article attachments in the zoom view of the article in the agent interface.' =>
            'Shows a link to download article attachments in the zoom view of the article in the agent interface.',
        'Shows a link to see a zoomed email ticket in plain text.' => 'Shows a link to see a zoomed email ticket in plain text.',
        'Shows a link to set a ticket as junk in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Shows a link to set a ticket as junk in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.',
        'Shows a list of all the involved agents on this ticket, in the close ticket screen of the agent interface.' =>
            'Shows a list of all the involved agents on this ticket, in the close ticket screen of the agent interface.',
        'Shows a list of all the involved agents on this ticket, in the ticket free text screen of the agent interface.' =>
            'Shows a list of all the involved agents on this ticket, in the ticket free text screen of the agent interface.',
        'Shows a list of all the involved agents on this ticket, in the ticket note screen of the agent interface.' =>
            'Shows a list of all the involved agents on this ticket, in the ticket note screen of the agent interface.',
        'Shows a list of all the involved agents on this ticket, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Shows a list of all the involved agents on this ticket, in the ticket owner screen of a zoomed ticket in the agent interface.',
        'Shows a list of all the involved agents on this ticket, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Shows a list of all the involved agents on this ticket, in the ticket pending screen of a zoomed ticket in the agent interface.',
        'Shows a list of all the involved agents on this ticket, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Shows a list of all the involved agents on this ticket, in the ticket priority screen of a zoomed ticket in the agent interface.',
        'Shows a list of all the involved agents on this ticket, in the ticket responsible screen of the agent interface.' =>
            'Shows a list of all the involved agents on this ticket, in the ticket responsible screen of the agent interface.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the close ticket screen of the agent interface.' =>
            'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the close ticket screen of the agent interface.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket free text screen of the agent interface.' =>
            'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket free text screen of the agent interface.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket note screen of the agent interface.' =>
            'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket note screen of the agent interface.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket owner screen of a zoomed ticket in the agent interface.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket pending screen of a zoomed ticket in the agent interface.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket priority screen of a zoomed ticket in the agent interface.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket responsible screen of the agent interface.' =>
            'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket responsible screen of the agent interface.',
        'Shows a preview of the ticket overview (CustomerInfo => 1 - shows also Customer-Info, CustomerInfoMaxSize max. size in characters of Customer-Info).' =>
            'Shows a preview of the ticket overview (CustomerInfo => 1 - shows also Customer-Info, CustomerInfoMaxSize max. size in characters of Customer-Info).',
        'Shows a select of ticket attributes to order the queue view ticket list. The possible selections can be configured via \'TicketOverviewMenuSort###SortAttributes\'.' =>
            'Shows a select of ticket attributes to order the queue view ticket list. The possible selections can be configured via \'TicketOverviewMenuSort###SortAttributes\'.',
        'Shows all both ro and rw queues in the queue view.' => 'Shows all both ro and rw queues in the queue view.',
        'Shows all both ro and rw tickets in the service view.' => 'Shows all both ro and rw tickets in the service view.',
        'Shows all open tickets (even if they are locked) in the escalation view of the agent interface.' =>
            'Shows all open tickets (even if they are locked) in the escalation view of the agent interface.',
        'Shows all open tickets (even if they are locked) in the status view of the agent interface.' =>
            'Shows all open tickets (even if they are locked) in the status view of the agent interface.',
        'Shows all the articles of the ticket (expanded) in the zoom view.' =>
            'Shows all the articles of the ticket (expanded) in the zoom view.',
        'Shows all the customer identifiers in a multi-select field (not useful if you have a lot of customer identifiers).' =>
            'Shows all the customer identifiers in a multi-select field (not useful if you have a lot of customer identifiers).',
        'Shows all the customer user identifiers in a multi-select field (not useful if you have a lot of customer user identifiers).' =>
            '',
        'Shows an owner selection in phone and email tickets in the agent interface.' =>
            'Shows an owner selection in phone and email tickets in the agent interface.',
        'Shows colors for different article types in the article table.' =>
            'Shows colours for different article types in the article table.',
        'Shows customer history tickets in AgentTicketPhone, AgentTicketEmail and AgentTicketCustomer.' =>
            'Shows customer history tickets in AgentTicketPhone, AgentTicketEmail and AgentTicketCustomer.',
        'Shows either the last customer article\'s subject or the ticket title in the small format overview.' =>
            'Shows either the last customer article\'s subject or the ticket title in the small format overview.',
        'Shows existing parent/child queue lists in the system in the form of a tree or a list.' =>
            'Shows existing parent/child queue lists in the system in the form of a tree or a list.',
        'Shows information on how to start OTRS Daemon' => 'Shows information on how to start OTRS Daemon',
        'Shows the activated ticket attributes in the customer interface (0 = Disabled and 1 = Enabled).' =>
            'Shows the activated ticket attributes in the customer interface (0 = Disabled and 1 = Enabled).',
        'Shows the articles sorted normally or in reverse, under ticket zoom in the agent interface.' =>
            'Shows the articles sorted normally or in reverse, under ticket zoom in the agent interface.',
        'Shows the customer user information (phone and email) in the compose screen.' =>
            'Shows the customer user information (phone and email) in the compose screen.',
        'Shows the customer user\'s info in the ticket zoom view.' => 'Shows the customer user\'s info in the ticket zoom view.',
        'Shows the message of the day (MOTD) in the agent dashboard. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually.' =>
            'Shows the message of the day (MOTD) in the agent dashboard. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually.',
        'Shows the message of the day on login screen of the agent interface.' =>
            'Shows the message of the day on login screen of the agent interface.',
        'Shows the ticket history (reverse ordered) in the agent interface.' =>
            'Shows the ticket history (reverse ordered) in the agent interface.',
        'Shows the ticket priority options in the close ticket screen of the agent interface.' =>
            'Shows the ticket priority options in the close ticket screen of the agent interface.',
        'Shows the ticket priority options in the move ticket screen of the agent interface.' =>
            'Shows the ticket priority options in the move ticket screen of the agent interface.',
        'Shows the ticket priority options in the ticket bulk screen of the agent interface.' =>
            'Shows the ticket priority options in the ticket bulk screen of the agent interface.',
        'Shows the ticket priority options in the ticket free text screen of the agent interface.' =>
            'Shows the ticket priority options in the ticket free text screen of the agent interface.',
        'Shows the ticket priority options in the ticket note screen of the agent interface.' =>
            'Shows the ticket priority options in the ticket note screen of the agent interface.',
        'Shows the ticket priority options in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Shows the ticket priority options in the ticket owner screen of a zoomed ticket in the agent interface.',
        'Shows the ticket priority options in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Shows the ticket priority options in the ticket pending screen of a zoomed ticket in the agent interface.',
        'Shows the ticket priority options in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Shows the ticket priority options in the ticket priority screen of a zoomed ticket in the agent interface.',
        'Shows the ticket priority options in the ticket responsible screen of the agent interface.' =>
            'Shows the ticket priority options in the ticket responsible screen of the agent interface.',
        'Shows the title field in the ticket free text screen of the agent interface.' =>
            '',
        'Shows the title fields in the close ticket screen of the agent interface.' =>
            'Shows the title fields in the close ticket screen of the agent interface.',
        'Shows the title fields in the ticket note screen of the agent interface.' =>
            'Shows the title fields in the ticket note screen of the agent interface.',
        'Shows the title fields in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Shows the title fields in the ticket owner screen of a zoomed ticket in the agent interface.',
        'Shows the title fields in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Shows the title fields in the ticket pending screen of a zoomed ticket in the agent interface.',
        'Shows the title fields in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Shows the title fields in the ticket priority screen of a zoomed ticket in the agent interface.',
        'Shows the title fields in the ticket responsible screen of the agent interface.' =>
            'Shows the title fields in the ticket responsible screen of the agent interface.',
        'Shows time in long format (days, hours, minutes), if set to "Yes"; or in short format (days, hours), if set to "No".' =>
            'Shows time in long format (days, hours, minutes), if set to "Yes"; or in short format (days, hours), if set to "No".',
        'Shows time use complete description (days, hours, minutes), if set to "Yes"; or just first letter (d, h, m), if set to "No".' =>
            'Shows time use complete description (days, hours, minutes), if set to "Yes"; or just first letter (d, h, m), if set to "No".',
        'Simple' => 'Simple',
        'Skin' => 'Skin',
        'Slovak' => 'Slovak',
        'Slovenian' => 'Slovenian',
        'Software Package Manager.' => 'Software Package Manager.',
        'SolutionDiffInMin' => 'SolutionDiffInMin',
        'SolutionInMin' => 'SolutionInMin',
        'Some description!' => 'Some description!',
        'Some picture description!' => 'Some picture description!',
        'Sorts the tickets (ascendingly or descendingly) when a single queue is selected in the queue view and after the tickets are sorted by priority. Values: 0 = ascending (oldest on top, default), 1 = descending (youngest on top). Use the QueueID for the key and 0 or 1 for value.' =>
            'Sorts the tickets (ascendingly or descendingly) when a single queue is selected in the queue view and after the tickets are sorted by priority. Values: 0 = ascending (oldest on top, default), 1 = descending (youngest on top). Use the QueueID for the key and 0 or 1 for value.',
        'Sorts the tickets (ascendingly or descendingly) when a single queue is selected in the service view and after the tickets are sorted by priority. Values: 0 = ascending (oldest on top, default), 1 = descending (youngest on top). Use the ServiceID for the key and 0 or 1 for value.' =>
            'Sorts the tickets (ascendingly or descendingly) when a single queue is selected in the service view and after the tickets are sorted by priority. Values: 0 = ascending (oldest on top, default), 1 = descending (youngest on top). Use the ServiceID for the key and 0 or 1 for value.',
        'Spam' => 'Spam',
        'Spam Assassin example setup. Ignores emails that are marked with SpamAssassin.' =>
            'Spam Assassin example setup. Ignores emails that are marked with SpamAssassin.',
        'Spam Assassin example setup. Moves marked mails to spam queue.' =>
            'Spam Assassin example setup. Moves marked mails to spam queue.',
        'Spanish' => 'Spanish',
        'Spanish (Colombia)' => 'Spanish (Colombia)',
        'Spanish (Mexico)' => 'Spanish (Mexico)',
        'Spanish stop words for fulltext index. These words will be removed from the search index.' =>
            'Spanish stop words for fulltext index. These words will be removed from the search index.',
        'Specifies if an agent should receive email notification of his own actions.' =>
            'Specifies if an agent should receive email notification of his own actions.',
        'Specifies the available note types for this ticket mask. If the option is deselected, ArticleTypeDefault is used and the option is removed from the mask.' =>
            'Specifies the available note types for this ticket mask. If the option is deselected, ArticleTypeDefault is used and the option is removed from the mask.',
        'Specifies the default article type for the ticket compose screen in the agent interface if the article type cannot be automatically detected.' =>
            'Specifies the default article type for the ticket compose screen in the agent interface if the article type cannot be automatically detected.',
        'Specifies the different article types that will be used in the system.' =>
            'Specifies the different article types that will be used in the system.',
        'Specifies the different note types that will be used in the system.' =>
            'Specifies the different note types that will be used in the system.',
        'Specifies the directory to store the data in, if "FS" was selected for TicketStorageModule.' =>
            'Specifies the directory to store the data in, if "FS" was selected for TicketStorageModule.',
        'Specifies the directory where SSL certificates are stored.' => 'Specifies the directory where SSL certificates are stored.',
        'Specifies the directory where private SSL certificates are stored.' =>
            'Specifies the directory where private SSL certificates are stored.',
        'Specifies the email address that should be used by the application when sending notifications. The email address is used to build the complete display name for the notification master (i.e. "OTRS Notifications" otrs@your.example.com). You can use the OTRS_CONFIG_FQDN variable as set in your configuation, or choose another email address.' =>
            'Specifies the email address that should be used by the application when sending notifications. The email address is used to build the complete display name for the notification master (i.e. "OTRS Notifications" otrs@your.example.com). You can use the OTRS_CONFIG_FQDN variable as set in your configuation, or choose another email address.',
        'Specifies the email addresses to get notification messages from scheduler tasks.' =>
            'Specifies the email addresses to get notification messages from scheduler tasks.',
        'Specifies the group where the user needs rw permissions so that he can access the "SwitchToCustomer" feature.' =>
            'Specifies the group where the user needs rw permissions so that he can access the "SwitchToCustomer" feature.',
        'Specifies the name that should be used by the application when sending notifications. The sender name is used to build the complete display name for the notification master (i.e. "OTRS Notifications" otrs@your.example.com).' =>
            'Specifies the name that should be used by the application when sending notifications. The sender name is used to build the complete display name for the notification master (i.e. "OTRS Notifications" otrs@your.example.com).',
        'Specifies the order in which the firstname and the lastname of agents will be displayed.' =>
            'Specifies the order in which the firstname and the lastname of agents will be displayed.',
        'Specifies the path of the file for the logo in the page header (gif|jpg|png, 700 x 100 pixel).' =>
            'Specifies the path of the file for the logo in the page header (gif|jpg|png, 700 x 100 pixel).',
        'Specifies the path of the file for the performance log.' => 'Specifies the path of the file for the performance log.',
        'Specifies the path to the converter that allows the view of Microsoft Excel files, in the web interface.' =>
            'Specifies the path to the converter that allows the view of Microsoft Excel files, in the web interface.',
        'Specifies the path to the converter that allows the view of Microsoft Word files, in the web interface.' =>
            'Specifies the path to the converter that allows the view of Microsoft Word files, in the web interface.',
        'Specifies the path to the converter that allows the view of PDF documents, in the web interface.' =>
            'Specifies the path to the converter that allows the view of PDF documents, in the web interface.',
        'Specifies the path to the converter that allows the view of XML files, in the web interface.' =>
            'Specifies the path to the converter that allows the view of XML files, in the web interface.',
        'Specifies the text that should appear in the log file to denote a CGI script entry.' =>
            'Specifies the text that should appear in the log file to denote a CGI script entry.',
        'Specifies user id of the postmaster data base.' => 'Specifies user id of the postmaster data base.',
        'Specifies whether all storage backends should be checked when looking for attachments. This is only required for installations where some attachments are in the file system, and others in the database.' =>
            'Specifies whether all storage backends should be checked when looking for attachments. This is only required for installations where some attachments are in the file system, and others in the database.',
        'Specify how many sub directory levels to use when creating cache files. This should prevent too many cache files being in one directory.' =>
            'Specify how many sub directory levels to use when creating cache files. This should prevent too many cache files being in one directory.',
        'Specify the channel to be used to fetch OTRS Business Solution™ updates. Warning: Development releases might not be complete, your system might experience unrecoverable errors and on extreme cases could become unresponsive!' =>
            'Specify the channel to be used to fetch OTRS Business Solution™ updates. Warning: Development releases might not be complete, your system might experience unrecoverable errors and on extreme cases could become unresponsive!',
        'Specify the password to authenticate for the first mirror database.' =>
            'Specify the password to authenticate for the first mirror database.',
        'Specify the username to authenticate for the first mirror database.' =>
            'Specify the username to authenticate for the first mirror database.',
        'Spell checker.' => 'Spell checker.',
        'Stable' => '',
        'Standard available permissions for agents within the application. If more permissions are needed, they can be entered here. Permissions must be defined to be effective. Some other good permissions have also been provided built-in: note, close, pending, customer, freetext, move, compose, responsible, forward, and bounce. Make sure that "rw" is always the last registered permission.' =>
            'Standard available permissions for agents within the application. If more permissions are needed, they can be entered here. Permissions must be defined to be effective. Some other good permissions have also been provided built-in: note, close, pending, customer, freetext, move, compose, responsible, forward, and bounce. Make sure that "rw" is always the last registered permission.',
        'Start number for statistics counting. Every new stat increments this number.' =>
            'Start number for statistics counting. Every new stat increments this number.',
        'Starts a wildcard search of the active object after the link object mask is started.' =>
            'Starts a wildcard search of the active object after the link object mask is started.',
        'Stat#' => 'Stat#',
        'Status view' => 'Status view',
        'Stores cookies after the browser has been closed.' => 'Stores cookies after the browser has been closed.',
        'Strips empty lines on the ticket preview in the queue view.' => 'Strips empty lines on the ticket preview in the queue view.',
        'Strips empty lines on the ticket preview in the service view.' =>
            'Strips empty lines on the ticket preview in the service view.',
        'Swahili' => 'Swahili',
        'Swedish' => 'Swedish',
        'System Address Display Name' => 'System Address Display Name',
        'System Maintenance' => 'System Maintenance',
        'System Request (%s).' => 'System Request (%s).',
        'Target' => 'Target',
        'Templates <-> Queues' => 'Templates <-> Queues',
        'Textarea' => 'Textarea',
        'Thai' => 'Thai',
        'The agent skin\'s InternalName which should be used in the agent interface. Please check the available skins in Frontend::Agent::Skins.' =>
            'The agent skin\'s InternalName which should be used in the agent interface. Please check the available skins in Frontend::Agent::Skins.',
        'The customer skin\'s InternalName which should be used in the customer interface. Please check the available skins in Frontend::Customer::Skins.' =>
            'The customer skin\'s InternalName which should be used in the customer interface. Please check the available skins in Frontend::Customer::Skins.',
        'The daemon registration for the scheduler cron task manager.' =>
            'The daemon registration for the scheduler cron task manager.',
        'The daemon registration for the scheduler future task manager.' =>
            'The daemon registration for the scheduler future task manager.',
        'The daemon registration for the scheduler generic agent task manager.' =>
            'The daemon registration for the scheduler generic agent task manager.',
        'The daemon registration for the scheduler task worker.' => 'The daemon registration for the scheduler task worker.',
        'The divider between TicketHook and ticket number. E.g \': \'.' =>
            'The divider between TicketHook and ticket number. E.g \': \'.',
        'The duration in minutes after emitting an event, in which the new escalation notify and start events are suppressed.' =>
            'The duration in minutes after emitting an event, in which the new escalation notify and start events are suppressed.',
        'The format of the subject. \'Left\' means \'[TicketHook#:12345] Some Subject\', \'Right\' means \'Some Subject [TicketHook#:12345]\', \'None\' means \'Some Subject\' and no ticket number. In the latter case you should verify that the setting PostMaster::CheckFollowUpModule###0200-References is activated to recognize followups based on email headers.' =>
            'The format of the subject. \'Left\' means \'[TicketHook#:12345] Some Subject\', \'Right\' means \'Some Subject [TicketHook#:12345]\', \'None\' means \'Some Subject\' and no ticket number. In the latter case you should verify that the setting PostMaster::CheckFollowUpModule###0200-References is activated to recognise followups based on email headers.',
        'The headline shown in the customer interface.' => 'The headline shown in the customer interface.',
        'The identifier for a ticket, e.g. Ticket#, Call#, MyTicket#. The default is Ticket#.' =>
            'The identifier for a ticket, e.g. Ticket#, Call#, MyTicket#. The default is Ticket#.',
        'The logo shown in the header of the agent interface for the skin "default". See "AgentLogo" for further description.' =>
            'The logo shown in the header of the agent interface for the skin "default". See "AgentLogo" for further description.',
        'The logo shown in the header of the agent interface for the skin "ivory". See "AgentLogo" for further description.' =>
            'The logo shown in the header of the agent interface for the skin "ivory". See "AgentLogo" for further description.',
        'The logo shown in the header of the agent interface for the skin "ivory-slim". See "AgentLogo" for further description.' =>
            'The logo shown in the header of the agent interface for the skin "ivory-slim". See "AgentLogo" for further description.',
        'The logo shown in the header of the agent interface for the skin "slim". See "AgentLogo" for further description.' =>
            'The logo shown in the header of the agent interface for the skin "slim". See "AgentLogo" for further description.',
        'The logo shown in the header of the agent interface. The URL to the image can be a relative URL to the skin image directory, or a full URL to a remote web server.' =>
            'The logo shown in the header of the agent interface. The URL to the image can be a relative URL to the skin image directory, or a full URL to a remote web server.',
        'The logo shown in the header of the customer interface. The URL to the image can be a relative URL to the skin image directory, or a full URL to a remote web server.' =>
            'The logo shown in the header of the customer interface. The URL to the image can be a relative URL to the skin image directory, or a full URL to a remote web server.',
        'The logo shown on top of the login box of the agent interface. The URL to the image must be relative URL to the skin image directory.' =>
            'The logo shown on top of the login box of the agent interface. The URL to the image must be relative URL to the skin image directory.',
        'The maximal number of articles expanded on a single page in AgentTicketZoom.' =>
            'The maximal number of articles expanded on a single page in AgentTicketZoom.',
        'The maximal number of articles shown on a single page in AgentTicketZoom.' =>
            'The maximal number of articles shown on a single page in AgentTicketZoom.',
        'The maximum number of mails fetched at once before reconnecting to the server.' =>
            'The maximum number of mails fetched at once before reconnecting to the server.',
        'The text at the beginning of the subject in an email reply, e.g. RE, AW, or AS.' =>
            'The text at the beginning of the subject in an email reply, e.g. RE, AW, or AS.',
        'The text at the beginning of the subject when an email is forwarded, e.g. FW, Fwd, or WG.' =>
            'The text at the beginning of the subject when an email is forwarded, e.g. FW, Fwd, or WG.',
        'This event module stores attributes from CustomerUser as DynamicFields tickets. Please see the setting above for how to configure the mapping.' =>
            'This event module stores attributes from CustomerUser as DynamicFields tickets. Please see the setting above for how to configure the mapping.',
        'This is the default orange - black skin for the customer interface.' =>
            'This is the default orange - black skin for the customer interface.',
        'This is the default orange - black skin.' => 'This is the default orange - black skin.',
        'This module and its PreRun() function will be executed, if defined, for every request. This module is useful to check some user options or to display news about new applications.' =>
            'This module and its PreRun() function will be executed, if defined, for every request. This module is useful to check some user options or to display news about new applications.',
        'This module is part of the admin area of OTRS.' => 'This module is part of the admin area of OTRS.',
        'This option defines the dynamic field in which a Process Management activity entity id is stored.' =>
            'This option defines the dynamic field in which a Process Management activity entity id is stored.',
        'This option defines the dynamic field in which a Process Management process entity id is stored.' =>
            'This option defines the dynamic field in which a Process Management process entity id is stored.',
        'This option defines the process tickets default lock.' => 'This option defines the process tickets default lock.',
        'This option defines the process tickets default priority.' => 'This option defines the process tickets default priority.',
        'This option defines the process tickets default queue.' => 'This option defines the process tickets default queue.',
        'This option defines the process tickets default state.' => 'This option defines the process tickets default state.',
        'This option will deny the access to customer company tickets, which are not created by the customer user.' =>
            'This option will deny the access to customer company tickets, which are not created by the customer user.',
        'This setting allows you to override the built-in country list with your own list of countries. This is particularly handy if you just want to use a small select group of countries.' =>
            'This setting allows you to override the built-in country list with your own list of countries. This is particularly handy if you just want to use a small select group of countries.',
        'This will allow the system to send text messages via SMS.' => 'This will allow the system to send text messages via SMS.',
        'Ticket Close.' => 'Ticket Close.',
        'Ticket Compose Bounce Email.' => 'Ticket Compose Bounce Email.',
        'Ticket Compose email Answer.' => 'Ticket Compose email Answer.',
        'Ticket Customer.' => 'Ticket Customer.',
        'Ticket Forward Email.' => 'Ticket Forward Email.',
        'Ticket FreeText.' => 'Ticket FreeText.',
        'Ticket History.' => 'Ticket History.',
        'Ticket Lock.' => 'Ticket Lock.',
        'Ticket Merge.' => 'Ticket Merge.',
        'Ticket Move.' => 'Ticket Move.',
        'Ticket Note.' => 'Ticket Note.',
        'Ticket Notifications' => 'Ticket Notifications',
        'Ticket Outbound Email.' => 'Ticket Outbound Email.',
        'Ticket Owner.' => 'Ticket Owner.',
        'Ticket Pending.' => 'Ticket Pending.',
        'Ticket Print.' => 'Ticket Print.',
        'Ticket Priority.' => 'Ticket Priority.',
        'Ticket Queue Overview' => 'Ticket Queue Overview',
        'Ticket Responsible.' => 'Ticket Responsible.',
        'Ticket Watcher' => 'Ticket Watcher',
        'Ticket Zoom.' => 'Ticket Zoom.',
        'Ticket bulk module.' => 'Ticket bulk module.',
        'Ticket event module that triggers the escalation stop events.' =>
            'Ticket event module that triggers the escalation stop events.',
        'Ticket moved into Queue "%s" (%s) from Queue "%s" (%s).' => 'Ticket moved into Queue "%s" (%s) from Queue "%s" (%s).',
        'Ticket notifications' => 'Ticket notifications',
        'Ticket overview' => 'Ticket overview',
        'Ticket plain view of an email.' => 'Ticket plain view of an email.',
        'Ticket title' => 'Ticket title',
        'Ticket zoom view.' => 'Ticket zoom view.',
        'TicketNumber' => 'TicketNumber',
        'Tickets.' => 'Tickets.',
        'Time in seconds that gets added to the actual time if setting a pending-state (default: 86400 = 1 day).' =>
            'Time in seconds that gets added to the actual time if setting a pending-state (default: 86400 = 1 day).',
        'Title updated: Old: "%s", New: "%s"' => 'Title updated: Old: "%s", New: "%s"',
        'To accept login information, such as an EULA or license.' => 'To accept login information, such as an EULA or license.',
        'To download attachments.' => 'To download attachments.',
        'Toggles display of OTRS FeatureAddons list in PackageManager.' =>
            'Toggles display of OTRS FeatureAddons list in PackageManager.',
        'Toolbar Item for a shortcut. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Toolbar Item for a shortcut. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".',
        'Transport selection for ticket notifications.' => 'Transport selection for ticket notifications.',
        'Tree view' => 'Tree view',
        'Triggers ticket escalation events and notification events for escalation.' =>
            'Triggers ticket escalation events and notification events for escalation.',
        'Turkish' => 'Turkish',
        'Turns off SSL certificate validation, for example if you use a transparent HTTPS proxy. Use at your own risk!' =>
            'Turns off SSL certificate validation, for example if you use a transparent HTTPS proxy. Use at your own risk!',
        'Turns on drag and drop for the main navigation.' => 'Turns on drag and drop for the main navigation.',
        'Turns on the animations used in the GUI. If you have problems with these animations (e.g. performance issues), you can turn them off here.' =>
            'Turns on the animations used in the GUI. If you have problems with these animations (e.g. performance issues), you can turn them off here.',
        'Turns on the remote ip address check. It should be set to "No" if the application is used, for example, via a proxy farm or a dialup connection, because the remote ip address is mostly different for the requests.' =>
            'Turns on the remote ip address check. It should be set to "No" if the application is used, for example, via a proxy farm or a dialup connection, because the remote ip address is mostly different for the requests.',
        'Ukrainian' => 'Ukrainian',
        'Unlock tickets that are past their unlock timeout.' => 'Unlock tickets that are past their unlock timeout.',
        'Unlock tickets whenever a note is added and the owner is out of office.' =>
            'Unlock tickets whenever a note is added and the owner is out of office.',
        'Unlocked ticket.' => 'Unlocked ticket.',
        'Update Ticket "Seen" flag if every article got seen or a new Article got created.' =>
            'Update Ticket "Seen" flag if every article got seen or a new Article got created.',
        'Updated SLA to %s (ID=%s).' => 'Updated SLA to %s (ID=%s).',
        'Updated Service to %s (ID=%s).' => 'Updated Service to %s (ID=%s).',
        'Updated Type to %s (ID=%s).' => 'Updated Type to %s (ID=%s).',
        'Updated: %s' => 'Updated: %s',
        'Updated: %s=%s;%s=%s;%s=%s;' => 'Updated: %s=%s;%s=%s;%s=%s;',
        'Updates the ticket escalation index after a ticket attribute got updated.' =>
            'Updates the ticket escalation index after a ticket attribute got updated.',
        'Updates the ticket index accelerator.' => 'Updates the ticket index accelerator.',
        'Use new type of select and autocomplete fields in agent interface, where applicable (InputFields).' =>
            'Use new type of select and autocomplete fields in agent interface, where applicable (InputFields).',
        'Use new type of select and autocomplete fields in customer interface, where applicable (InputFields).' =>
            'Use new type of select and autocomplete fields in customer interface, where applicable (InputFields).',
        'UserFirstname' => 'UserFirstname',
        'UserLastname' => 'UserLastname',
        'Uses Cc recipients in reply Cc list on compose an email answer in the ticket compose screen of the agent interface.' =>
            'Uses Cc recipients in reply Cc list on compose an email answer in the ticket compose screen of the agent interface.',
        'Uses richtext for viewing and editing ticket notification.' => 'Uses richtext for viewing and editing ticket notification.',
        'Uses richtext for viewing and editing: articles, salutations, signatures, standard templates, auto responses and notifications.' =>
            'Uses richtext for viewing and editing: articles, salutations, signatures, standard templates, auto responses and notifications.',
        'Vietnam' => 'Vietnam',
        'View performance benchmark results.' => 'View performance benchmark results.',
        'Watch this ticket' => 'Watch this ticket',
        'Watched Tickets.' => 'Watched Tickets.',
        'We are performing scheduled maintenance.' => 'We are performing scheduled maintenance.',
        'We are performing scheduled maintenance. Login is temporarily not available.' =>
            'We are performing scheduled maintenance. Login is temporarily not available.',
        'We are performing scheduled maintenance. We should be back online shortly.' =>
            'We are performing scheduled maintenance. We should be back online shortly.',
        'Web View' => 'Web View',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. Here you can define the body of this note (this text cannot be changed by the agent).' =>
            'When tickets are merged, a note will be added automatically to the ticket which is no longer active. Here you can define the body of this note (this text cannot be changed by the agent).',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. Here you can define the subject of this note (this subject cannot be changed by the agent).' =>
            'When tickets are merged, a note will be added automatically to the ticket which is no longer active. Here you can define the subject of this note (this subject cannot be changed by the agent).',
        'When tickets are merged, the customer can be informed per email by setting the check box "Inform Sender". In this text area, you can define a pre-formatted text which can later be modified by the agents.' =>
            'When tickets are merged, the customer can be informed per email by setting the check box "Inform Sender". In this text area, you can define a pre-formatted text which can later be modified by the agents.',
        'Whether or not to collect meta information from articles using filters configured in Ticket::Frontend::ZoomCollectMetaFilters.' =>
            'Whether or not to collect meta information from articles using filters configured in Ticket::Frontend::ZoomCollectMetaFilters.',
        'Yes, but hide archived tickets' => 'Yes, but hide archived tickets',
        'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further information.' =>
            'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further information.',
        'Your queue selection of your preferred queues. You also get notified about those queues via email if enabled.' =>
            'Your queue selection of your preferred queues. You also get notified about those queues via email if enabled.',
        'Your service selection of your preferred services. You also get notified about those services via email if enabled.' =>
            'Your service selection of your preferred services. You also get notified about those services via email if enabled.',
        'attachment' => 'attachment',
        'bounce' => '',
        'compose' => '',
        'debug' => 'debug',
        'error' => 'error',
        'forward' => '',
        'info' => 'info',
        'inline' => 'inline',
        'notice' => 'notice',
        'pending' => '',
        'responsible' => '',
        'stats' => '',

    };
    # $$STOP$$
    return;
}

1;
