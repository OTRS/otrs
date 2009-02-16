# --
# Kernel/Language/ar_SA.pm - provides ar_SA language translation
# Copyright (C) 2007 Mohammad Saleh <maoaf at yahoo.com>
# --
# $Id: ar_SA.pm,v 1.27 2009-02-16 10:38:04 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --
package Kernel::Language::ar_SA;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.27 $) [1];

sub Data {
    my $Self = shift;

    # $$START$$
    # Last translation file sync: Fri May 16 14:07:36 2008

    # possible charsets
    $Self->{Charset} = ['cp1256', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Jear;)
    $Self->{DateFormat}          = '%D.%M.%Y %T';
    $Self->{DateFormatLong}      = '%A %D %B %T %Y';
    $Self->{DateFormatShort}     = '%D.%M.%Y';
    $Self->{DateInputFormat}     = '%D.%M.%Y';
    $Self->{DateInputFormatLong} = '%D.%M.%Y - %T';

    # TextDirection rtl or ltr
    $Self->{TextDirection} = 'rtl';

    $Self->{Translation} = {
        # Template: AAABase
        'Yes' => 'äÚã',
        'No' => 'áÇ',
        'yes' => 'äÚã',
        'no' => 'áÇ',
        'Off' => 'ÊÚØíá',
        'off' => 'ÊÚØíá',
        'On' => 'ÊİÚíá',
        'on' => 'ÊİÚíá',
        'top' => 'ÃÚáì',
        'end' => 'äåÇíÉ',
        'Done' => 'Êã ÈäÌÇÍ',
        'Cancel' => 'ÅáÛÇÁ',
        'Reset' => 'ÅÚÇÏÉ',
        'last' => 'ÇáÃÎíÑ',
        'before' => 'ŞÈá',
        'day' => 'íæã',
        'days' => 'ÃíÇã',
        'day(s)' => 'íæã/ÃíÇã',
        'hour' => 'ÓÇÚÉ',
        'hours' => 'ÓÇÚÇÊ',
        'hour(s)' => 'ÓÇÚÉ/ÓÇÚÇÊ',
        'minute' => 'ÏŞíŞÉ',
        'minutes' => 'ÏŞÇÆŞ',
        'minute(s)' => 'ÏŞÓŞÉ/ÏŞÇÆŞ',
        'month' => 'ÔåÑ',
        'months' => 'ÃÔåÑ',
        'month(s)' => 'ÔåÑ/ÃÔåÑ',
        'week' => 'ÃÓÈæÚ',
        'week(s)' => 'ÃÓÈæÚ/ÃÓÇÈíÚ',
        'year' => 'ÓäÉ',
        'years' => 'ÓäæÇÊ',
        'year(s)' => 'ÓäÉ/Óäíä',
        'second(s)' => 'ËÇäíÉ/ËæÇäí',
        'seconds' => 'ËæÇäí',
        'second' => 'ËÇäíÉ',
        'wrote' => 'ßÊÈ',
        'Message' => 'ÑÓÇáÉ',
        'Error' => 'ÎØÃ',
        'Bug Report' => 'ÊŞÑíÑ Úä ÎØÃ',
        'Attention' => 'ÊäÈíå',
        'Warning' => 'ÊÍĞíÑ',
        'Module' => 'ãæÏíæá',
        'Modulefile' => 'ãáİ ãæÏíæá',
        'Subfunction' => 'ÚãáíÉ İÑÚíÉ',
        'Line' => 'ÎØ',
        'Example' => 'ãËÇá',
        'Examples' => 'ÃãËáÉ',
        'valid' => 'İÚÇá',
        'invalid' => 'ÛíÑ İÚÇá',
        '* invalid' => '',
        'invalid-temporarily' => 'ÛíÑ İÚÇá ãÄŞÊÇğ',
        ' 2 minutes' => ' ÏŞíŞÊÇä',
        ' 5 minutes' => ' 5 ÏŞÇÆŞ',
        ' 7 minutes' => ' 7 ÏŞÇÆŞ',
        '10 minutes' => ' 10 ÏŞÇÆŞ',
        '15 minutes' => ' 15 ÏŞíŞÉ',
        'Mr.' => 'ÓíÏ ',
        'Mrs.' => 'ÓíÏÉ ',
        'Next' => 'ÇáÊÇáí',
        'Back' => 'ÇáÓÇÈŞ',
        'Next...' => 'ÇáÊÇáí....',
        '...Back' => '....ÇáÓÇÈŞ',
        '-none-' => '-ÈÏæä-',
        'none' => 'ÈÏæä',
        'none!' => 'ÈÏæä!',
        'none - answered' => '',
        'please do not edit!' => 'ÇáÑÌÇÁ ÚÏã ÇáÊÚÏíá!',
        'AddLink' => 'ÃÖİ ÑÇÈØ',
        'Link' => 'ÑÇÈØ',
        'Unlink' => '',
        'Linked' => 'Êã ÑÈØå',
        'Link (Normal)' => 'ÑÇÈØ(ÚÇÏí)',
        'Link (Parent)' => 'ÑÇÈØ (ãÚ ÃÓÇÓ)',
        'Link (Child)' => 'ÑÇÈØ (ãÚ İÑÚ)',
        'Normal' => 'ÚÇÏí',
        'Parent' => 'ÃÓÇÓ',
        'Child' => 'İÑÚ',
        'Hit' => 'ÖÛØÉ',
        'Hits' => 'ÖÛØÇÊ',
        'Text' => 'äÕ',
        'Lite' => 'Îİíİ',
        'User' => 'ãÓÊÎÏã',
        'Username' => 'ÅÓã ÇáãÓÊÎÏã',
        'Language' => 'ÇááÛÉ',
        'Languages' => 'ÇááÛÇÊ',
        'Password' => 'ßáãÉ ÇáãÑæÑ',
        'Salutation' => 'ÇáÊÍíÉ',
        'Signature' => 'ÇáÊæŞíÚ',
        'Customer' => 'Úãíá',
        'CustomerID' => 'ÑŞã ÇáÚãíá',
        'CustomerIDs' => 'ÃÑŞÇã ÇáÚãíá',
        'customer' => 'Úãíá',
        'agent' => 'æßíá',
        'system' => 'ÇáäÙÇã',
        'Customer Info' => 'ãÚáæãÇÊ ÇáÚãíá',
        'Customer Company' => '',
        'Company' => '',
        'go!' => 'ÇÈÏÃ!',
        'go' => 'ÛÈÏÃ',
        'All' => 'Çáßá',
        'all' => 'Çáßá',
        'Sorry' => 'ãÚĞÑÉ',
        'update!' => 'ÊÍÏíË!',
        'update' => 'ÊÍÏíË',
        'Update' => 'ÊÍÏíË',
        'submit!' => 'ÊÓáíã!',
        'submit' => 'ÊÓáíã',
        'Submit' => 'ÊÓáíã',
        'change!' => 'ÊÛííÑ!',
        'Change' => 'ÊÛííÑ',
        'change' => 'ÊÛííÑ',
        'click here' => 'ÇÖÛØ åäÇ',
        'Comment' => 'ÊÚáíŞ',
        'Valid' => 'İÚÇá',
        'Invalid Option!' => 'ÎÇÕíÉ ÛíÑ ÕÍíÍÉ!',
        'Invalid time!' => 'ÇáæŞÊ ÛíÑ ÕÍíÍ!',
        'Invalid date!' => 'ÇáÊÇÑíÎ ÛíÑ ÕÍíÍ!',
        'Name' => 'ÇáÅÓã',
        'Group' => 'ÇáãÌãæÚÉ',
        'Description' => 'ÇáÔÑÍ',
        'description' => 'ÇáÔÑÍ',
        'Theme' => 'ÇáËíã',
        'Created' => 'ÃäÔíÁ',
        'Created by' => 'ÃäÔíÁ ãä ÎáÇá',
        'Changed' => 'Êã ÊÛííÑå',
        'Changed by' => 'Êã ÊÛííÑå ãä ÎáÇá',
        'Search' => 'ÈÍË',
        'and' => ' æ ',
        'between' => 'Èíä',
        'Fulltext Search' => 'ÈÍË Úä ßÇãá ÇáäÕ',
        'Data' => 'ÈíÇäÇÊ',
        'Options' => 'ÎíÇÑÇÊ',
        'Title' => 'ÇáÚäæÇä',
        'Item' => 'ÇáÚäÕÑ',
        'Delete' => 'ÍĞİ',
        'Edit' => 'ÊÚÏíá',
        'View' => 'ÚÑÖ',
        'Number' => 'ÇáÑŞã',
        'System' => 'ÇáäÙÇã',
        'Contact' => 'ÇÊÕÇá',
        'Contacts' => 'ÇÊÕÇáÇÊ',
        'Export' => 'ÊÕÏíÑ',
        'Up' => 'ÃÚáì',
        'Down' => 'ÃÓİá',
        'Add' => 'ÃÖİ',
        'Category' => 'ÊÕäíİ',
        'Viewer' => 'ãÓÊÚÑÖ',
        'New message' => 'ÑÓÇáÉ ÌÏíÏÉ',
        'New message!' => 'ÑÓÇáÉ ÌÏíÏÉ!',
        'Please answer this ticket(s) to get back to the normal queue view!' => 'ÇáÑÌÇÁ ÇáÅÌÇÈÉ Úáì åĞå ÇáÈØÇŞÇÊ ááÚæÏÉ Åáì ÔÇÔÉ ÇáÈØÇŞÇÊ ÇáÑÆíÓíÉ!',
        'You got new message!' => 'áÏíß ÑÓÇáÉ ÌÏíÏÉ!',
        'You have %s new message(s)!' => 'áÏíß %s ÑÓÇáÉ/ÑÓÇÆá ÌÏíÏÉ!',
        'You have %s reminder ticket(s)!' => 'áÏíß %s ÊäÈíåÇÊ áÈØÇŞÇÊ!',
        'The recommended charset for your language is %s!' => 'ÇáÊÑãíÒ ÇáãİÖá ááÛÊß åæ %s !',
        'Passwords doesn\'t match! Please try it again!' => 'ßáãÊí ÇáãÑæÑ ÛíÑ ãÊØÇÈŞÊÇä! ÇáÑÌÇÁ ÇáÊÌÑÈÉ ãÑÉ ÃÎÑì!',
        'Password is already in use! Please use an other password!' => 'ßáãÉ ÇáãÑæÑ ãÓÊÎÏãÉ ãÓÈŞÇğ! ÇáÑÌÇÁ ÅÓÊÎÏÇã ßáãÉ ãÑæÑ ÃÎÑìì!',
        'Password is already used! Please use an other password!' => 'ßáãÉ ÇáãÑæÑ ãÓÊÎÏãÉ ãÓÈŞÇğ! ÇáÑÌÇÁ ÅÓÊÎÏÇã ßáãÉ ãÑæÑ ÃÎÑì !',
        'You need to activate %s first to use it!' => 'íÌÈ Úáíß ÊİÚíá %s ŞÈá ÇÓÊÎÏÇãå!',
        'No suggestions' => 'áÇ ÊæÌÏ ÇŞÊÑÇÍÇÊ',
        'Word' => 'ßáãÉ',
        'Ignore' => 'ÊÌÇåá',
        'replace with' => 'ÇÓÊÈÏÇá ÈÜ ',
        'There is no account with that login name.' => 'áÇ íæÌÏ ÍÓÇÈ ãÑÈæØ ãÚ ÇÓã ÇáÏÎæá.',
        'Login failed! Your username or password was entered incorrectly.' => 'İÔá ÊÓÌíá ÇáÏÎæá! ÇáÑÌÇÁ ÇáÊÃßÏ ãä ÇÓã ÇáãÓÊÎÏã Ãæ ßáãÉ ÇáãÑæÑ.',
        'Please contact your admin' => 'ÇáÑÌÇÁ ÇáÅÊÕÇá ÈãÏíÑ ÇáäÙÇã',
        'Logout successful. Thank you for using OTRS!' => 'Êã ÇáÎÑæÌ ãä ÇáäÙÇã ÈäÌÇÍ. ÔßÑÇğ áÅÓÊÎÏÇãß OTRS!',
        'Invalid SessionID!' => '',
        'Feature not active!' => 'ÇáÎÇÕíÉ ÛíÑ ãİÚáÉ!',
        'Login is needed!' => '',
        'Password is needed!' => 'ßáãÉ ÇáãÑæÑ ãØáæÈÉ!',
        'License' => 'ÇáÑÎÕÉ',
        'Take this Customer' => '',
        'Take this User' => '',
        'possible' => 'ããßä',
        'reject' => 'ÑİÖ',
        'reverse' => 'ÚßÓ',
        'Facility' => '',
        'Timeover' => 'ÇáæŞÊ ÅäÊåì',
        'Pending till' => '',
        'Don\'t work with UserID 1 (System account)! Create new users!' => 'áÇ ÊÓÊÎÏã ãÏíÑ ÇáäÙÇã ÇáÃÓÇÓí! ÃäÔíÁ ãÓÊÎÏã ÂÎÑ!',
        'Dispatching by email To: field.' => '',
        'Dispatching by selected Queue.' => '',
        'No entry found!' => 'áÇ ÊæÌÏ äÊÇÆÌ!',
        'Session has timed out. Please log in again.' => '',
        'No Permission!' => 'áÇ ÊæÌÏ ÕáÇÍíÇÊ!',
        'To: (%s) replaced with database email!' => '',
        'Cc: (%s) added database email!' => '',
        '(Click here to add)' => '(ÃÎÊÑ åäÇ ááÅÖÇİÉ)',
        'Preview' => 'ÇÓÊÚÑÇÖ',
        'Package not correctly deployed! You should reinstall the Package again!' => 'ÇáÈÑäÇãÌ ÇáÅÖÇİí áã íÎÒä ÈÔßá ÕÍíÍ! íÌÈ Úáíß ÅÚÇÏÉ ÊÎÒíäå ãÑÉ ÇÎÑì',
        'Added User "%s"' => 'ÃÖíİ ÇáãÓÊÎÏã"%s"',
        'Contract' => 'ÇáÚŞÏ',
        'Online Customer: %s' => 'ÇáÚãáÇÁ ÇáãÊæÇÌÏíä ÍÇáíÇğ : %s',
        'Online Agent: %s' => 'ÇáãÔÛáíä ÇáãæÌæÏíä ÍÇáíÇğ : %s',
        'Calendar' => 'ÇáÊŞæíã',
        'File' => 'ãáİ',
        'Filename' => 'ÇÓã Çáãáİ',
        'Type' => 'ÇáäæÚ',
        'Size' => 'ÇáÍÌã',
        'Upload' => 'ÊÍãíá',
        'Directory' => 'ãÌáÏ',
        'Signed' => 'ãæŞÚ',
        'Sign' => 'æŞÚ',
        'Crypted' => '',
        'Crypt' => '',
        'Office' => 'ÇáãßÊÈ',
        'Phone' => 'ÑŞã ÇáåÇÊİ',
        'Fax' => 'ÑŞã ÇáİÇßÓ',
        'Mobile' => 'ÑŞã ÇáÌæÇá',
        'Zip' => '',
        'City' => 'ÇáãÏíäÉ',
        'Street' => '',
        'Location' => '',
        'Country' => 'ÇáÏæáÉ',
        'installed' => 'Êã ÊÎÒíä ÇáÈÑäÇãÌ',
        'uninstalled' => 'Êã ÍĞİ ÇáÈÑäÇãÌ',
        'Security Note: You should activate %s because application is already running!' => '',
        'Unable to parse Online Repository index document!' => '',
        'No Packages for requested Framework in this Online Repository, but Packages for other Frameworks!' => '',
        'No Packages or no new Packages in selected Online Repository!' => '',
        'printed at' => 'ØÈÚ İí',
        'Dear Mr. %s,' => '',
        'Dear Mrs. %s,' => '',
        'Dear %s,' => '',
        'Hello %s,' => '',
        'This account exists.' => '',
        'New account created. Sent Login-Account to %s.' => '',
        'Please press Back and try again.' => '',
        'Sent password token to: %s' => '',
        'Sent new password to: %s' => '',
        'Invalid Token!' => '',

        # Template: AAAMonth
        'Jan' => 'íäÇíÑ',
        'Feb' => 'İÈÑÇíÑ',
        'Mar' => 'ãÇÑÓ',
        'Apr' => 'ÃÈÑíá',
        'May' => 'ãÇíæ',
        'Jun' => 'Ìæä',
        'Jul' => 'íæáíæ',
        'Aug' => 'ÃÛÓØÓ',
        'Sep' => 'ÓÈÊãÈÑ',
        'Oct' => 'ÃßÊæÈÑ',
        'Nov' => 'äæİãÈÑ',
        'Dec' => 'ÏíÓãÈÑ',
        'January' => 'íäÇíÑ',
        'February' => 'İÈÑÇíÑ',
        'March' => 'ãÇÑÓ',
        'April' => 'ÃÈÑíá',
        'June' => 'Ìæä',
        'July' => 'íæáíæ',
        'August' => 'ÇÛÓØÓ',
        'September' => 'ÓÈÊãÈÑ',
        'October' => 'ÇßÊæÈÑ',
        'November' => 'äæİãÈÑ',
        'December' => 'ÏíÓãÈÑ',

        # Template: AAANavBar
        'Admin-Area' => 'ãäØŞÉ-ãÏíÑ ÇáäÙÇã',
        'Agent-Area' => 'ãäØŞÉ-ÇáãÔÛá',
        'Ticket-Area' => 'ãäØŞÉ-ÇáÈØÇŞÉ',
        'Logout' => 'ÊÓÌíá ÇáÎÑæÌ',
        'Agent Preferences' => 'ÅÚÏÇÏÇÊ ÇáãÔÛá',
        'Preferences' => 'ÅÚÏÇÏÇÊ',
        'Agent Mailbox' => 'ÕäÏæŞ ÈÑíÏ ÇáãÔÛá',
        'Stats' => 'ÅÍÕÇÆíÇÊ',
        'Stats-Area' => 'ãäØŞÉ-ÇáÅÍÕÇÆÇÊ',
        'Admin' => 'ÅÏÇÑÉ ÇáäÙÇã',
        'Customer Users' => 'ÇáÚãáÇÁ',
        'Customer Users <-> Groups' => 'ÇáÚãáÇÁ <=> ÇáãÌãæÚÇÊ',
        'Users <-> Groups' => 'ÇáãÓÊÎÏãíä <=> ÇáãÌãæÚÇÊ',
        'Roles' => '',
        'Roles <-> Users' => '',
        'Roles <-> Groups' => '',
        'Salutations' => '',
        'Signatures' => 'ÇáÊæŞíÚÇÊ',
        'Email Addresses' => 'ÚäÇæíä ÇáÈÑíÏ ÇáÅáßÊÑæäí',
        'Notifications' => 'ÊäÈíåÇÊ',
        'Category Tree' => '',
        'Admin Notification' => 'ÊäÈíåÇÊ ãÏíÑ ÇáäÙÇã',

        # Template: AAAPreferences
        'Preferences updated successfully!' => 'Êã ÊÍÏíË ÇáÅÚÏÇÏÇÊ ÈäÌÇÍ!',
        'Mail Management' => 'ÅÏÇÑÉ ÇáÈÑíÏ',
        'Frontend' => 'ÇáæÇÌåÉ ÇáÃãÇãíÉ',
        'Other Options' => 'ÎíÇÑÇÊ ÃÎÑì',
        'Change Password' => 'ÊÛííÑ ßáãÉ ÇáãÑæÑ',
        'New password' => 'ßáãÉ ÇáãÑæÑ ÇáÌÏíÏÉ',
        'New password again' => 'ßáãÉ ÇáãÑæÑ ÇáÌÏíÏÉ ãÑÉ ÃÎÑì',
        'Select your QueueView refresh time.' => 'ÍÏÏ æŞÊ ÊÍÏíË ŞÇÆãÉ ÇáÈØÇŞÇÊ',
        'Select your frontend language.' => 'ÃÎÊÑ áÛÉ ÇáæÇÌåÉ ÇáÃãÇãíÉ',
        'Select your frontend Charset.' => 'ÃÎÊÑ ÇáÊÑãíÒ ÇáÎÇÕ ÈÇáæÇÌåÉ ÇáÃãÇãíÉ',
        'Select your frontend Theme.' => 'ÃÎÊÑ ÇáËíã ÇáÎÇÕ ÈÇáæÇÌåÉ ÇáÃãÇãíÉ',
        'Select your frontend QueueView.' => 'ÃÎÊÑ ŞÇÆãÉ ÇáÈØÇŞÇÊ ÇáÎÇÕÉ Èß ÈÇáæÇÌåÉ ÇáÑÆíÓíÉ.',
        'Spelling Dictionary' => 'ÇáãÏŞŞ ÇááÛæí',
        'Select your default spelling dictionary.' => 'ÃÎÊÑ ÇáãÏŞŞ ÇááÛæí ÇáÎÇÕ Èß',
        'Max. shown Tickets a page in Overview.' => 'ÃßÈÑ ÚÏÏ ãä ÇáÈØÇŞÇÊ ÇáãÚÑæÖÉ İí ßá ÕİÍÉ',
        'Can\'t update password, passwords doesn\'t match! Please try it again!' => 'áÇ íãßä ÊÍÏíË ßáãÉ ÇáãÑæÑ, ßáãÊí ÇáãÑæÑ ÛíÑ ãÊØÇÈŞÊÇä! ÇáÑÌÇÁ ÇáÊÌÑÈÉ ãÑÉ ÃÎÑì',
        'Can\'t update password, invalid characters!' => 'áÇ íãßä ÊÍÏíË ßáãÉ ÇáãÑæÑ, ÇáÍÑæİ ÛíÑ ÕÍíÍÉ!',
        'Can\'t update password, need min. 8 characters!' => 'áÇ íãßä ÊÛííÑ ßáãÉ ÇáãÑæÑ, Úáì ÇáÃŞá íÌÈ ßÊÇÈÉ 8 ÎÇäÇÊ!',
        'Can\'t update password, need 2 lower and 2 upper characters!' => '',
        'Can\'t update password, need min. 1 digit!' => 'áÇ íãßä ÊÍÏíË ßáãÉ ÇáãÑæÑ, íÌÈ ßÊÇÈÉ ÎÇäÉ æÇÍÏÉ Úáì ÇáÃŞá',
        'Can\'t update password, need min. 2 characters!' => 'áÇ íãßä ÊÍÏíË ßáãÉ ÇáãÑæÑ, íÌÈ ßÊÇÈÉ ÎÇäÊíä Úáì ÇáÃÃŞá',

        # Template: AAAStats
        'Stat' => 'ÅÍÕÇÁÇÊ',
        'Please fill out the required fields!' => 'ÑÌÇÁÇğ Şã íÊÚÈÆÉ ÇáÎÇäÇÊ ÇáãØáæÈÉ',
        'Please select a file!' => 'ÑÌÇÁÇğ ÃÎÊÑ ãáİ',
        'Please select an object!' => 'ÑÌÇÁÇğ Şã ÈÊÍÏíÏÇáßÇÆä!',
        'Please select a graph size!' => 'ÑÌÇÁÇğ ÃÎÊÑ ÍÌã ÇáÕæÑÉ',
        'Please select one element for the X-axis!' => 'ÑÌÇÁÇğ Şã ÈÊÍÏíÏ ÚäÕÑ æÇÍÏ áãÍæÑ ÇáÓíäÇÊ!',
        'You have to select two or more attributes from the select field!' => 'íÌÈ Úáíß ÊÍÏíÏ ÚäÕÑíä Ãæ ÃßËÑ ãä ÇáŞÇÆãÉ ÇáãÍÏÏÉ!',
        'Please select only one element or turn off the button \'Fixed\' where the select field is marked!' => '',
        'If you use a checkbox you have to select some attributes of the select field!' => '',
        'Please insert a value in the selected input field or turn off the \'Fixed\' checkbox!' => '',
        'The selected end time is before the start time!' => 'æŞÊ ÇáäåÇíÉ ÇáãÍÏÏ ŞÈá æŞÊ ÇáÈÏÇíÉ ÇáãÍÏÏ!!',
        'You have to select one or more attributes from the select field!' => '',
        'The selected Date isn\'t valid!' => '',
        'Please select only one or two elements via the checkbox!' => '',
        'If you use a time scale element you can only select one element!' => '',
        'You have an error in your time selection!' => 'áÏíß ÎØÃ İí ÇÎÊíÇÑß ááæŞÊ!',
        'Your reporting time interval is too small, please use a larger time scale!' => '',
        'The selected start time is before the allowed start time!' => '',
        'The selected end time is after the allowed end time!' => 'æŞÊ ÇáäåÇíÉ ÇáãÍÏÏ ÈÚÏ æŞÊ ÇáäåÇíÉ ÇáãÓãæÍ Èå!',
        'The selected time period is larger than the allowed time period!' => 'ãÏÉ ÇáæŞÊ ÇáãÍÏÏÉ ÃßÈÑ ãä ÇáãÏÉ ÇáãÓãæÍ ÈåÇ!',
        'Common Specification' => '',
        'Xaxis' => '',
        'Value Series' => '',
        'Restrictions' => '',
        'graph-lines' => '',
        'graph-bars' => '',
        'graph-hbars' => '',
        'graph-points' => '',
        'graph-lines-points' => '',
        'graph-area' => '',
        'graph-pie' => '',
        'extended' => '',
        'Agent/Owner' => 'ÇáãÔÛá/ ÇáãÇáß',
        'Created by Agent/Owner' => 'ÃäÔÆÊ ÈæÇÓØÉÇáãÔÛá/ÇáãÇáß',
        'Created Priority' => 'ÅäÔÇÁ ÃæáæíÉ',
        'Created State' => 'ÅäÔÇÁ ÅÍÕÇÆíÉ',
        'Create Time' => 'æŞÊ ÇáÅäÔÇÁ',
        'CustomerUserLogin' => 'ÏÎæá ÇáÚãáÇÁ',
        'Close Time' => 'æŞÊ ÅŞİÇá ÇáÈØÇŞÉ',

        # Template: AAATicket
        'Lock' => 'ÅŞİÇá',
        'Unlock' => 'İß',
        'History' => 'ÊÇÑíÎ',
        'Zoom' => 'ÊßÈíÑ',
        'Age' => 'ÚãÑ ÇáÈØÇŞÉ',
        'Bounce' => '',
        'Forward' => 'ÊŞÏíã',
        'From' => 'ãä',
        'To' => 'Åáì',
        'Cc' => '',
        'Bcc' => '',
        'Subject' => 'ÇáÚäæÇä',
        'Move' => 'äŞá',
        'Queue' => 'ŞÇÆãÉ ÇáÈØÇŞÇÊ',
        'Priority' => 'ÃæáæíÉ',
        'Priority Update' => '',
        'State' => 'ÇáÍÇáÉ',
        'Compose' => 'ÅÑÓÇá',
        'Pending' => 'ÊÍÊ ÇáÅäÊÙÇÑ',
        'Owner' => 'ÇáãÇáß',
        'Owner Update' => 'ÊÍÏíË ÇáãÇáß',
        'Responsible' => 'ãÓÄæáíÇÊ',
        'Responsible Update' => 'ÊÍÏíË ÇáãÓÄæáíÇÊ',
        'Sender' => 'ÇáãÑÓá',
        'Article' => 'ãæÖæÚ',
        'Ticket' => 'ÇáÈØÇŞÉ',
        'Createtime' => 'æŞÊ ÇáÅäÔÇÁ',
        'plain' => 'äÕí',
        'Email' => 'ÇáÈÑíÏ ÇáÅáßÊÑæäí',
        'email' => 'ÇáÈÑíÏ ÇáÅáßÊÑæäí',
        'Close' => 'ÅÛáÇŞ',
        'Action' => 'ÚãáíÉ',
        'Attachment' => 'ãáİ ãÑİŞ',
        'Attachments' => 'ãáİÇÊ ãÑİŞå',
        'This message was written in a character set other than your own.' => 'åĞå ÇáÑÓÇáÉ ßÊÈÊ ÈÊÑãíÒ ãÎÊáİ Úä ÇáÊÑãíÒ ÇáÍÇáí.',
        'If it is not displayed correctly,' => '',
        'This is a' => '',
        'to open it in a new window.' => 'áİÊÍåÇ İí äÇİĞÉ ÌÏíÏÉ.',
        'This is a HTML email. Click here to show it.' => 'åĞÇ ÈÑíÏ ÅáßÑÊæäí ßÕİÍÉ ÃÊÔ Êí Ãã Çá. ÃÎÊÑ åäÇ áÚÑÖåÇ.',
        'Free Fields' => '',
        'Merge' => 'ÏãÌ',
        'merged' => '',
        'closed successful' => 'ÃÛáŞÊ ÈäÌÇÍ',
        'closed unsuccessful' => 'ÃÛáŞÊ ÈİÔá',
        'new' => 'ÌÏíÏ',
        'open' => 'İÊÍ',
        'closed' => 'Êã ÅŞİÇáå',
        'removed' => 'Êã ÍĞÛå',
        'pending reminder' => '',
        'pending auto' => '',
        'pending auto close+' => '',
        'pending auto close-' => '',
        'email-external' => 'ÈÑíÏ ÅáßÊÑæäí-ÎÇÑÌí',
        'email-internal' => 'ÈÑíÏ ÅáßÊÑæäí- ÏÇÎáí',
        'note-external' => 'ãáÇÍÙÉ-ÎÇÑÌíÉ',
        'note-internal' => 'ãáÇÍÙÉ-ÏÇÎáíÉ',
        'note-report' => 'ÊŞÑíÑ-ãáÇÍÙÉ',
        'phone' => 'ÑŞã ÇáåÇÊİ',
        'sms' => '',
        'webrequest' => 'ØáÈ ãä ÎáÇá ÇáÅäÊÑäÊ',
        'lock' => 'ÅŞİÇá',
        'unlock' => 'ÅÚÇÏÉ İÊÍ',
        'very low' => 'ãäÎİÖ ÌÏÇğ',
        'low' => 'ãäÎİÖ',
        'normal' => 'ÚÇÏí',
        'high' => 'ãÑÊİÚ',
        'very high' => 'ãÑÊİÚ ÌÏÇğ',
        '1 very low' => '1 ãäÎİÖ ÌÏÇğ',
        '2 low' => '2 ãäÎİÖ',
        '3 normal' => '3 ÚÇÏí',
        '4 high' => '4 ãÑÊİÚ',
        '5 very high' => '5 ãÑÊİÚ ÌÏÇğ',
        'Ticket "%s" created!' => 'ÇáÈØÇŞÉ "%s" ÃäÔÆÊ!',
        'Ticket Number' => 'ÑŞã ÇáÈØÇŞÉ',
        'Ticket Object' => 'ßÇÆä ÇáÈØÇŞÉ',
        'No such Ticket Number "%s"! Can\'t link it!' => 'áã íÊã ÇáÚËæÑ Úáì ÑŞã ÇáÈØÇŞÉ "%s" !! áÇ íãßä ÑÈØåÇ!',
        'Don\'t show closed Tickets' => 'áÇ ÊÙåÑ ÇáÈØÇŞÇÊ ÇáãŞİáÉ',
        'Show closed Tickets' => 'ÃÙåÑ ÇáÈØÇŞÇÊ ÇáãŞİáÉ',
        'New Article' => '',
        'Email-Ticket' => 'ÈØÇŞÉ-ÈÑíÏ',
        'Create new Email Ticket' => 'ÃäÔíÁ ÈØÇŞÉ ÈÑíÏ ÌÏíÏÉ',
        'Phone-Ticket' => 'ÈØÇŞÉ-åÇÊİ',
        'Search Tickets' => 'ÃÈÍË İí ÇáÈØÇŞÇÊ',
        'Edit Customer Users' => 'ÊÚÏíá ãÚáæãÇÊ ÇáÚãáÇÁ',
        'Edit Customer Company' => '',
        'Bulk Action' => 'ÊäİíĞ ÌãÇÚí',
        'Bulk Actions on Tickets' => 'ÇáÚãáíÇÊ ÇáÌãÇÚíÉ Úáì ÇáÈØÇŞÇÊ',
        'Send Email and create a new Ticket' => 'ÃÑÓá ÇáÈÑíÏ æ ÃäÔíÁ ÈØÇŞÉ ÌÏíÏÉ',
        'Create new Email Ticket and send this out (Outbound)' => '',
        'Create new Phone Ticket (Inbound)' => '',
        'Overview of all open Tickets' => 'ÇÓÊÚÑÖ ÌãíÚ ÇáÈØÇŞÇÊ ÇáãİÊæÍÉ',
        'Locked Tickets' => 'ÇáÈØÇŞÇÊ ÇáãŞİáÉ áí',
        'Watched Tickets' => 'ÇáÈØÇŞÇÊ ÇáãÑÇŞÈÉ',
        'Watched' => 'ãÑÇŞÈ',
        'Subscribe' => 'ãÑÇŞÈÉ',
        'Unsubscribe' => 'ÅáÛÇÁ ÇáãÑÇŞÈÉ',
        'Lock it to work on it!' => 'ÃŞİáåÇ Úä ÇáÈŞíÉ ááÚãá ÚáíåÇ',
        'Unlock to give it back to the queue!' => 'ÃİÊÍ ÇáÈØÇŞÉ áÅÑÌÇÚåÇ áŞÇÆãÉ ÇáÈØÇŞÇÊ ÇáÎÇÕÉ ÈåÇ!',
        'Shows the ticket history!' => 'ÃÙåÑ ÊÇÑíÎ ÇáÈØÇŞÉ!',
        'Print this ticket!' => 'ØÈÇÚÉ ÇáÈØÇŞÉ!',
        'Change the ticket priority!' => 'ÊÛííÑ ÃæáæíÉ ÇáÈØÇŞÉ!',
        'Change the ticket free fields!' => '',
        'Link this ticket to an other objects!' => 'ÃÑÈØ åĞå ÇáÈØÇŞÉ ãÚ ÇáßÇÆä  ÂÎÑ',
        'Change the ticket owner!' => 'ÊÛííÑ ãÇáß ÇáÈØÇŞÉ',
        'Change the ticket customer!' => 'ÊÛííÑ Úãíá ÇáÈØÇŞÉ!',
        'Add a note to this ticket!' => 'ÃÖİ ãáÇÍÙÉ áåĞå ÇáÈØÇŞÉ!',
        'Merge this ticket!' => 'ÃÏãÌ åĞå ÇáÈØÇŞÉ!',
        'Set this ticket to pending!' => 'ÃÖİ åĞå ÇáÈØÇŞÉ áŞÇÆãÉ ÇáÅäÊÙÇÑ!',
        'Close this ticket!' => 'ÃŞİá åĞå ÇáÈØÇŞÉ!',
        'Look into a ticket!' => 'ÃÍÊßÑ åĞå ÇáÈØÇŞÉ!',
        'Delete this ticket!' => 'ÃÍĞİ åĞå ÇáÈØÇŞÉ!',
        'Mark as Spam!' => 'ÍÏÏåÇ ßÑÓÇáå ãÒÚÌÉ',
        'My Queues' => 'ÈØÇŞÇÊí',
        'Shown Tickets' => 'ÇáÈØÇŞÇÊ ÇáãÚÑæÖÉ',
        'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' => 'ÈÑíÏß ãÚ ÑŞã ÇáÈØÇŞÉ  "<OTRS_TICKET>" ÏãÌÊ ãÚ "<OTRS_MERGE_TO_TICKET>".',
        'Ticket %s: first response time is over (%s)!' => '',
        'Ticket %s: first response time will be over in %s!' => '',
        'Ticket %s: update time is over (%s)!' => '',
        'Ticket %s: update time will be over in %s!' => '',
        'Ticket %s: solution time is over (%s)!' => '',
        'Ticket %s: solution time will be over in %s!' => '',
        'There are more escalated tickets!' => '',
        'New ticket notification' => 'ÊäÈíå ÈØÇŞÉ ÌÏíÏÉ',
        'Send me a notification if there is a new ticket in "My Queues".' => 'ÃÑÓáí ÊäÈíå ÅĞÇ æÌÏÊ ÈØÇŞÉ ÌÏíÏÉ İí ŞÇÆãÉ "ÈØÇŞÇÊí".',
        'Follow up notification' => 'ÊäÈíå ÇáãÊÇÈÚÉ',
        'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.' => 'ÃÑÓá Åáí ÊäÈíå ÅĞÇÃÑÓá ÇáÚãíá ãáÍŞ ãÊÇÈÚÉ ááÈØÇŞÉ ÅĞÇ ßÇäÊ ãáß áí.',
        'Ticket lock timeout notification' => 'ÊäÈíå ÅäÊåÇÁ æŞÊ ÅŞİÇá ÇáÈØÇŞÉ',
        'Send me a notification if a ticket is unlocked by the system.' => 'ÃÑÓá Åáí ÊäÈíå ÚäÏ İÊÍ ÈØÇŞÉ ÈæÇÓØÉ ÇáäÙÇã ÈÚÏ ÅäÊåÇÁ ÇáæŞÊ ÇáãÎÕÕ áÅŞİÇáåÇ.',
        'Move notification' => 'ÊäÈíå ÚäÏ äŞá ÈØÇŞÉ',
        'Send me a notification if a ticket is moved into one of "My Queues".' => 'ÃÑÓáí ÊäÈíå ÅĞÇ äŞáÊ ÃÍÏ ÇáÈØÇŞÇÊ Åáì ÃÍÏ ŞæÇÆã "ÈØÇŞÇÊí".',
        'Your queue selection of your favourite queues. You also get notified about those queues via email if enabled.' => 'ÇáŞæÇÆã ÇáãİÖáÉ áÏíß ãä ŞæÇÆã ÇáÈØÇŞÇÊ. ÃíÖÇğ ÓíÊã ÊäÈíåß Úä åĞå ÇáŞæÇÆã ãä ÎáÇá ÇáíÈÑíÏ ÇáÅáßÊÑæäí ÅĞÇ İÚáÊ',
        'Custom Queue' => '',
        'QueueView refresh time' => 'æŞÊ ÊÍÏíË ŞÇÆãÉ ÇáÈØÇŞÇÊ',
        'Screen after new ticket' => 'ÇáÔÇÔÉ ÈÚÏ ÅäÔÇÁ ÈØÇŞÉ ÌÏíÏÉ',
        'Select your screen after creating a new ticket.' => 'ÃÎÊÑ ÇáÔÇÔÉ ááĞåÇÈ ÅáíåÇ ÈÚÏ ÅäÔÇÁ ÈØÇŞÉ ÌÏíÏÉ.',
        'Closed Tickets' => 'ÇáÈØÇŞÇÊ ÇáãŞİáÉ',
        'Show closed tickets.' => 'ÃÚÑÖ ÇáÈØÇŞÇÊ ÇáãŞİáÉ',
        'Max. shown Tickets a page in QueueView.' => 'ÃßÈÑ ÚÏÏ ãä ÇáÈØÇŞÇÊ ÇáãÚÑæÖÉ İí ÇáÕİÍÉ ÇáæÇÍÏÉ İí ŞÇÆãÉ ÇáÈØÇŞÇÊ.',
        'CompanyTickets' => 'ÈØÇŞÇÊ ÇáÅÏÇÑÉ',
        'MyTickets' => 'ÈØÇŞÇÊí',
        'New Ticket' => 'ÈØÇŞÉ ÌÏíÏÉ',
        'Create new Ticket' => 'ÃäÔíÁ ÈØÇŞÉ ÌÏíÏÉ!',
        'Customer called' => 'ÇáÚãíá ÃÊÕá',
        'phone call' => 'ãßÇáãÉ åÇÊİíÉ',
        'Responses' => 'ÇáÑÏæÏ',
        'Responses <-> Queue' => 'ÇáÑÏæÏ <=> ŞÇÆãÉ ÇáÈØÇŞÇÊ',
        'Auto Responses' => 'ÇáÑÏæÏ ÇáÂáíÉáí',
        'Auto Responses <-> Queue' => 'ÇáÑÏæÏ ÇáÂáíÉ <=> ŞÇÆãÉ ÇáÈØÇŞÇÊ',
        'Attachments <-> Responses' => 'ÇáãÑİŞÇÊ<=> ÇáÑÏæÏ',
        'History::Move' => 'ÇáÊÇÑíÎ::äŞá',
        'History::TypeUpdate' => '',
        'History::ServiceUpdate' => '',
        'History::SLAUpdate' => '',
        'History::NewTicket' => 'ÇáÊÇÑíÎ::ÈØÇŞÉ ÌÏíÏÉ',
        'History::FollowUp' => 'ÇáÊÇÑíÎ::ãÊÇÈÚÉ',
        'History::SendAutoReject' => 'ÇáÊÇÑíÎ::ÃÑÓá ÑÏ Âáí',
        'History::SendAutoReply' => 'ÇáÊÇÑíÎ::ÃÑÓá ÑÏ Âáí',
        'History::SendAutoFollowUp' => 'ÇáÊÇÑíÎ::ÃÑÓá ãÊÇÈÚÉ ÂáíÉ',
        'History::Forward' => 'ÇáÊÇÑíÎ::ÊŞÏíã',
        'History::Bounce' => '',
        'History::SendAnswer' => 'ÇáÊÇÑíÎ::ÃÑÓá ÅÌÇÈÉ',
        'History::SendAgentNotification' => 'ÇáÊÇÑíÎ::ÃÑÓá ÊäÈíå ááãÔÛá',
        'History::SendCustomerNotification' => 'ÇáÊÇÑíÎ::ÃÑÓá ÊäÈíå ãÚÏá',
        'History::EmailAgent' => 'ÇáÊÇÑíÎ::ÇáÈÑíÏ ÇáÅáßÊÑæäí ááãÔÛá',
        'History::EmailCustomer' => 'ÇáÊÇÑíÎ::ÇáÈÑíÏ ÇáÅáßÊÑæäí ááÚãíá',
        'History::PhoneCallAgent' => 'ÇáÊÇÑíÎ::ãßÇáãÉ åÇÊİíÉ ááãÔÛá',
        'History::PhoneCallCustomer' => 'ÇáÊÇÑíÎ::Úãíá ãßÇáãÉ åÇÊİíÉ',
        'History::AddNote' => 'ÇáÊÇÑíÎ::ÅÖÇİÉ ãáÇÍÙÉ',
        'History::Lock' => 'ÇáÊÇÑíÎ::ÅÛáÇŞ',
        'History::Unlock' => 'ÇáÊÇÑíÎ::ÅÚÇÏÉ İÊÍ',
        'History::TimeAccounting' => '',
        'History::Remove' => '%s',
        'History::CustomerUpdate' => 'ÇáÊÇÑíÎ::ÊÍÏíË ÇáÚãíá',
        'History::PriorityUpdate' => 'ÇáÊÇÑíÎ::ÊÍÏíË ÇáÃæáæíÉ',
        'History::OwnerUpdate' => 'ÇáÊÇÑíÎ::ÊÍÏíË ÇáãÇáß',
        'History::LoopProtection' => '',
        'History::Misc' => '%s',
        'History::SetPendingTime' => '',
        'History::StateUpdate' => 'ÇáÊÇÑíÎ::ÊÍÏíË ÇáÍÇáÉ',
        'History::TicketFreeTextUpdate' => '',
        'History::WebRequestCustomer' => 'ÇáÊÇÑíÎ::ØáÈ Úãíá ãä ÎáÇá ÇáÅäÊÑäÊ',
        'History::TicketLinkAdd' => 'ÇáÊÇÑíÎ::ÊãÊ ÅÖÇİÉ ÑÇÈØ ááÈØÇŞÉ',
        'History::TicketLinkDelete' => 'ÇáÊÇÑíÎ::ÊãÍĞİ ÑÇÈØ ááÈØÇŞÉ',
        'History::Subscribe' => 'Added subscription for user "%s".',
        'History::Unsubscribe' => 'Removed subscription for user "%s".',

        # Template: AAAWeekDay
        'Sun' => 'ÇáÃÍÏ',
        'Mon' => 'ÇáÅËäíä',
        'Tue' => 'ÇáËáËÇÁ',
        'Wed' => 'ÇáÃÑÈÚÇÁ',
        'Thu' => 'ÇáÎãíÓ',
        'Fri' => 'ÇáÌãÚÉ',
        'Sat' => 'ÇáÓÈÊ',

        # Template: AdminAttachmentForm
        'Attachment Management' => 'ÅÏÇÑÉ ÇáãáİÇÊ ÇáãÑİŞÉ',

        # Template: AdminAutoResponseForm
        'Auto Response Management' => 'ÅÏÇÑÉ ÇáÑÏ ÇáÂáí',
        'Response' => 'ÇáÑÏ',
        'Auto Response From' => 'ÇáÑÏ ÇáÂáí ãä',
        'Note' => 'ãáÇÍÙÉ',
        'Useable options' => '',
        'To get the first 20 character of the subject.' => '',
        'To get the first 5 lines of the email.' => '',
        'To get the realname of the sender (if given).' => '',
        'To get the article attribute (e. g. (<OTRS_CUSTOMER_From>, <OTRS_CUSTOMER_To>, <OTRS_CUSTOMER_Cc>, <OTRS_CUSTOMER_Subject> and <OTRS_CUSTOMER_Body>).' => '',
        'Options of the current customer user data (e. g. <OTRS_CUSTOMER_DATA_UserFirstname>).' => '',
        'Ticket owner options (e. g. <OTRS_OWNER_UserFirstname>).' => '',
        'Ticket responsible options (e. g. <OTRS_RESPONSIBLE_UserFirstname>).' => '',
        'Options of the current user who requested this action (e. g. <OTRS_CURRENT_UserFirstname>).' => '',
        'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>).' => '',
        'Config options (e. g. <OTRS_CONFIG_HttpType>).' => '',

        # Template: AdminCustomerCompanyForm
        'Customer Company Management' => '',
        'Search for' => 'ÇÈÍË Úä',
        'Add Customer Company' => '',
        'Add a new Customer Company.' => '',
        'List' => '',
        'This values are required.' => 'åĞå ÇáŞíãÉ ãØáæÈÉ',
        'This values are read only.' => 'åĞå ÇáŞíãÉ ááŞÑÇÁÉ İŞØ',

        # Template: AdminCustomerUserForm
        'Customer User Management' => 'ÃÏÇÑÉ ÇáÚãáÇÁ',
        'Add Customer User' => '',
        'Source' => 'ÇáãÕÏÑ',
        'Create' => 'ÅäÔÇÁ',
        'Customer user will be needed to have a customer history and to login via customer panel.' => 'ÇáÚãáÇÁ ãØáæÈæä áÅãßÇäíÉ ÇáÑÌæÚ Åáì ÊÇÑíÎ ÇáÚãáÇÁ ßã íãßäåã ÇáÏÎæá ãä ÔÇÔÉ ÇáÚãáÇÁ.',

        # Template: AdminCustomerUserGroupChangeForm
        'Customer Users <-> Groups Management' => '',
        'Change %s settings' => '',
        'Select the user:group permissions.' => '',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the user).' => '',
        'Permission' => '',
        'ro' => '',
        'Read only access to the ticket in this group/queue.' => '',
        'rw' => '',
        'Full read and write access to the tickets in this group/queue.' => '',

        # Template: AdminCustomerUserGroupForm

        # Template: AdminCustomerUserService
        'Customer Users <-> Services Management' => '',
        'CustomerUser' => 'ÇáÚãíá',
        'Service' => '',
        'Edit default services.' => '',
        'Search Result' => 'äÊíÌÉ ÇáÈÍË',
        'Allocate services to CustomerUser' => '',
        'Active' => '',
        'Allocate CustomerUser to service' => '',

        # Template: AdminEmail
        'Message sent to' => 'ÇáÑÓÇáÉ ÃÑÓáÊ Åáì',
        'Recipents' => 'ÇáãÓÊŞÈáíä',
        'Body' => 'äÕ ÇáÑÓÇáÉ',
        'Send' => '',

        # Template: AdminGenericAgent
        'GenericAgent' => '',
        'Job-List' => '',
        'Last run' => 'ÂÎÑ ÊÔÛíá',
        'Run Now!' => 'ÊÔÛíá ÇáÂä',
        'x' => '',
        'Save Job as?' => '',
        'Is Job Valid?' => '',
        'Is Job Valid' => '',
        'Schedule' => 'ÇáÌÏæá',
        'Fulltext-Search in Article (e. g. "Mar*in" or "Baue*")' => '',
        '(e. g. 10*5155 or 105658*)' => '',
        '(e. g. 234321)' => '',
        'Customer User Login' => 'ÅÓã ÇáÏÎæá ÇáÎÇÕ ÈÇáÚãíá',
        '(e. g. U5150)' => '',
        'SLA' => '',
        'Agent' => 'ÇáãÔÛá',
        'Ticket Lock' => 'ÅÍÊßÇÑ ÇáÈØÇŞÉ',
        'TicketFreeFields' => 'ÇáÎÇäÇÊ ÇáÅÖÇİíÉ ááÈØÇŞÉ',
        'Create Times' => '',
        'No create time settings.' => '',
        'Ticket created' => 'ÇáÈØÇŞÉ ÃäÔÆÊ',
        'Ticket created between' => 'ÇáÈØÇŞÉ ÃäÔÆÊ Èíä',
        'Close Times' => '',
        'No close time settings.' => '',
        'Ticket closed' => '',
        'Ticket closed between' => '',
        'Pending Times' => '',
        'No pending time settings.' => '',
        'Ticket pending time reached' => '',
        'Ticket pending time reached between' => '',
        'New Service' => '',
        'New SLA' => '',
        'New Priority' => 'ÃæáæíÉ ÌÏíÏÉ',
        'New Queue' => 'ŞÇÆãÉ ÈØÇŞÇÊ ÌÏíÏÉ',
        'New State' => 'ÍÇáÉ ÌÏíÏÉ',
        'New Agent' => 'ãÔÛá ÌÏíÏ',
        'New Owner' => 'ãÇáß ÌÏíÏ',
        'New Customer' => 'Úãíá ÌÏíÏ',
        'New Ticket Lock' => 'ÅŞİÇá ÇáÈØÇŞÉ ÇáÌÏíÏÉ',
        'New Type' => '',
        'New Title' => '',
        'New Type' => '',
        'New TicketFreeFields' => 'ÎÇäÇÊ ÅÖÇİíÉ ÌÏíÏÉ ááÈØÇŞÉ',
        'Add Note' => 'ÅÖÇİÉ ãáÇÍÙÉ',
        'CMD' => '',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' => '',
        'Delete tickets' => 'ÍĞİ ÈØÇŞÇÊ',
        'Warning! This tickets will be removed from the database! This tickets are lost!' => '',
        'Send Notification' => 'ÅÑÓÇá ÊäÈíå',
        'Param 1' => '',
        'Param 2' => '',
        'Param 3' => '',
        'Param 4' => '',
        'Param 5' => '',
        'Param 6' => '',
        'Send no notifications' => 'áÇ ÊÑÓá Ãí ÊäÈíåÇÊ',
        'Yes means, send no agent and customer notifications on changes.' => '',
        'No means, send agent and customer notifications on changes.' => '',
        'Save' => 'ÍİÙ',
        '%s Tickets affected! Do you really want to use this job?' => '',
        '"}' => '',

        # Template: AdminGroupForm
        'Group Management' => 'ÅÏÇÑÉ ÇáãÌãæÚÇÊ',
        'Add Group' => '',
        'Add a new Group.' => '',
        'The admin group is to get in the admin area and the stats group to get stats area.' => '',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).' => '',
        'It\'s useful for ASP solutions.' => '',

        # Template: AdminLog
        'System Log' => '',
        'Time' => 'ÇáæŞÊ',

        # Template: AdminMailAccount
        'Mail Account Management' => '',
        'Host' => '',
        'Trusted' => '',
        'Dispatching' => '',
        'All incoming emails with one account will be dispatched in the selected queue!' => '',
        'If your account is trusted, the already existing X-OTRS header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' => '',

        # Template: AdminNavigationBar
        'Users' => 'ÇáãÓÊÎÏãíä',
        'Groups' => 'ÇáãÌãæÚÇÊ',
        'Misc' => 'ãäæÚ',

        # Template: AdminNotificationForm
        'Notification Management' => 'ÅÏÇÑÉ ÇáÊäÈíåÇÊ',
        'Notification' => 'ÇáÊäÈíåÇÊ',
        'Notifications are sent to an agent or a customer.' => 'ÇáÊäÈíå ÃÑÓá Åáì ãÔÛá Ãæ Úãíá.',

        # Template: AdminPackageManager
        'Package Manager' => '',
        'Uninstall' => 'ÍĞİ',
        'Version' => 'ÇáäÓÎÉ',
        'Do you really want to uninstall this package?' => '',
        'Reinstall' => 'ÅÚÇÏÉ ÇáÊÎÒíä',
        'Do you really want to reinstall this package (all manual changes get lost)?' => '',
        'Continue' => '',
        'Install' => 'ÊÎÒíä',
        'Package' => '',
        'Online Repository' => '',
        'Vendor' => '',
        'Upgrade' => 'ÊØæíÑ',
        'Local Repository' => '',
        'Status' => 'ÇáÍÇáÉ',
        'Overview' => 'ÇáãáÎÕ',
        'Download' => 'ÊäÒíá',
        'Rebuild' => 'ÅÚÇÏÉ ÈäÇÁ',
        'ChangeLog' => '',
        'Date' => '',
        'Filelist' => '',
        'Download file from package!' => '',
        'Required' => 'ãØáæÈ',
        'PrimaryKey' => '',
        'AutoIncrement' => '',
        'SQL' => '',
        'Diff' => '',

        # Template: AdminPerformanceLog
        'Performance Log' => '',
        'This feature is enabled!' => '',
        'Just use this feature if you want to log each request.' => '',
        'Of couse this feature will take some system performance it self!' => '',
        'Disable it here!' => '',
        'This feature is disabled!' => '',
        'Enable it here!' => '',
        'Logfile too large!' => '',
        'Logfile too large, you need to reset it!' => '',
        'Range' => '',
        'Interface' => '',
        'Requests' => '',
        'Min Response' => '',
        'Max Response' => '',
        'Average Response' => '',
        'Period' => '',
        'Min' => '',
        'Max' => '',
        'Average' => '',

        # Template: AdminPGPForm
        'PGP Management' => '',
        'Result' => 'ÇáäÊíÌÉ',
        'Identifier' => '',
        'Bit' => '',
        'Key' => '',
        'Fingerprint' => '',
        'Expires' => '',
        'In this way you can directly edit the keyring configured in SysConfig.' => '',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => '',
        'Filtername' => '',
        'Match' => '',
        'Header' => '',
        'Value' => '',
        'Set' => '',
        'Do dispatch or filter incoming emails based on email X-Headers! RegExp is also possible.' => '',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' => '',
        'If you use RegExp, you also can use the matched value in () as [***] in \'Set\'.' => '',

        # Template: AdminQueueAutoResponseForm
        'Queue <-> Auto Responses Management' => 'ŞÇÆãÉ ÇáÈØÇŞÇÊ <=> ÅÏÇÑÉ ÇáÑÏæÏ ÇáÂáíÉ',

        # Template: AdminQueueForm
        'Queue Management' => 'ÅÏÇÑÉ ŞæÇÆã ÇáÈØÇŞÇÊ',
        'Sub-Queue of' => 'ŞÇÆãÉ İÑÚíÉ ãä',
        'Unlock timeout' => '',
        '0 = no unlock' => '',
        'Only business hours are counted.' => '',
        'Escalation - First Response Time' => '',
        '0 = no escalation' => '0 = áÇ íæÌÏ ÊÕÚíÏ',
        'Only business hours are counted.' => '',
        'Notify by' => '',
        'Escalation - Update Time' => '',
        'Notify by' => '',
        'Escalation - Solution Time' => '',
        'Follow up Option' => 'ÎíÇÑ ÇáãÊÇÈÚÉ',
        'Ticket lock after a follow up' => 'ÅŞİÇá ÇáÈØÇŞÉ ÈÚÏ ÅÖÇİÉ ãÊÇÈÚÉ',
        'Systemaddress' => 'ÚäæÇä ÇáäÙÇã',
        'Customer Move Notify' => 'ÊäÈíå ÇáÚãíá ÚäÏ äŞá ÇáÈØÇŞÉ',
        'Customer State Notify' => '',
        'Customer Owner Notify' => '',
        'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.' => '',
        'Escalation time' => 'ŞÊ ÇáÊÕÚíÏ',
        'If a ticket will not be answered in this time, just only this ticket will be shown.' => '',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.' => '',
        'Will be the sender address of this queue for email answers.' => '',
        'The salutation for email answers.' => '',
        'The signature for email answers.' => '',
        'OTRS sends an notification email to the customer if the ticket is moved.' => '',
        'OTRS sends an notification email to the customer if the ticket state has changed.' => '',
        'OTRS sends an notification email to the customer if the ticket owner has changed.' => '',

        # Template: AdminQueueResponsesChangeForm
        'Responses <-> Queue Management' => 'ÇáÑÏæÏ <=> ÅÏÇÑÉ ÇáŞæÇÆã',

        # Template: AdminQueueResponsesForm
        'Answer' => 'ÇáÅÌÇÈÉ',

        # Template: AdminResponseAttachmentChangeForm
        'Responses <-> Attachments Management' => '',

        # Template: AdminResponseAttachmentForm

        # Template: AdminResponseForm
        'Response Management' => 'ÅÏÇÑÉ ÇáÑÏæÏ',
        'A response is default text to write faster answer (with default text) to customers.' => '',
        'Don\'t forget to add a new response a queue!' => 'áÇ ÊäÓì ÅÖÇİÉ ÇáÑÏ ÇáÌÏíÏ Åáì ŞÇÆãÉ',
        'The current ticket state is' => 'ÍÇáÉ ÇáÈØÇŞÉ ÇáÂä åí',
        'Your email address is new' => 'ÚäæÇä ÈÑíÏß ÇáÅáßÊÑæäí ÇáÂä åí',

        # Template: AdminRoleForm
        'Role Management' => '',
        'Add Role' => '',
        'Add a new Role.' => '',
        'Create a role and put groups in it. Then add the role to the users.' => '',
        'It\'s useful for a lot of users and groups.' => '',

        # Template: AdminRoleGroupChangeForm
        'Roles <-> Groups Management' => '',
        'move_into' => '',
        'Permissions to move tickets into this group/queue.' => '',
        'create' => '',
        'Permissions to create tickets in this group/queue.' => '',
        'owner' => '',
        'Permissions to change the ticket owner in this group/queue.' => '',
        'priority' => '',
        'Permissions to change the ticket priority in this group/queue.' => '',

        # Template: AdminRoleGroupForm
        'Role' => '',

        # Template: AdminRoleUserChangeForm
        'Roles <-> Users Management' => '',
        'Select the role:user relations.' => '',

        # Template: AdminRoleUserForm

        # Template: AdminSalutationForm
        'Salutation Management' => '',
        'Add Salutation' => '',
        'Add a new Salutation.' => '',

        # Template: AdminSelectBoxForm
        'SQL Box' => '',
        'Limit' => '',
        'Go' => '',
        'Select Box Result' => '',

        # Template: AdminService
        'Service Management' => '',
        'Add Service' => '',
        'Add a new Service.' => '',
        'Sub-Service of' => '',

        # Template: AdminSession
        'Session Management' => '',
        'Sessions' => '',
        'Uniq' => '',
        'Kill all sessions' => '',
        'Session' => '',
        'Content' => '',
        'kill session' => '',

        # Template: AdminSignatureForm
        'Signature Management' => '',
        'Add Signature' => '',
        'Add a new Signature.' => '',

        # Template: AdminSLA
        'SLA Management' => '',
        'Add SLA' => '',
        'Add a new SLA.' => '',

        # Template: AdminSMIMEForm
        'S/MIME Management' => '',
        'Add Certificate' => '',
        'Add Private Key' => '',
        'Secret' => '',
        'Hash' => '',
        'In this way you can directly edit the certification and private keys in file system.' => '',

        # Template: AdminStateForm
        'State Management' => '',
        'Add State' => '',
        'Add a new State.' => '',
        'State Type' => '',
        'Take care that you also updated the default states in you Kernel/Config.pm!' => '',
        'See also' => '',

        # Template: AdminSysConfig
        'SysConfig' => '',
        'Group selection' => '',
        'Show' => '',
        'Download Settings' => '',
        'Download all system config changes.' => '',
        'Load Settings' => '',
        'Subgroup' => '',
        'Elements' => '',

        # Template: AdminSysConfigEdit
        'Config Options' => '',
        'Default' => '',
        'New' => 'ÌÏíÏ',
        'New Group' => 'ãÌãæÚÉ ÌÏíÏÉ',
        'Group Ro' => '',
        'New Group Ro' => '',
        'NavBarName' => '',
        'NavBar' => '',
        'Image' => 'ÕæÑÉ',
        'Prio' => '',
        'Block' => '',
        'AccessKey' => '',

        # Template: AdminSystemAddressForm
        'System Email Addresses Management' => '',
        'Add System Address' => '',
        'Add a new System Address.' => '',
        'Realname' => 'ÇáÅÓã ÇáÍŞíŞí',
        'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!' => '',

        # Template: AdminTypeForm
        'Type Management' => '',
        'Add Type' => '',
        'Add a new Type.' => '',

        # Template: AdminUserForm
        'User Management' => 'ÅÏÇÑÉ ÇáãÓÊÎÏãíä',
        'Add User' => '',
        'Add a new Agent.' => '',
        'Login as' => 'ÊÓÌíá ÏÎæá ßÜ',
        'Firstname' => 'ÇáÅÓã ÇáÃæá',
        'Lastname' => 'ÇáÅÓã ÇáÃÎíÑ',
        'User will be needed to handle tickets.' => 'ÇáãÓÊÎÏã ãØáæÈ áãÊÇÈÚÉ ÇáÈØÇŞÇÊ.',
        'Don\'t forget to add a new user to groups and/or roles!' => 'áÇÊäÓì ÅÖÇİÉ ÇáãÓÊÎÏã ÇáÌÏíÏ Åáì ãÌãæÚÉ Ãæ ãÌãæÚÉ ÎÕÇÆÕ',

        # Template: AdminUserGroupChangeForm
        'Users <-> Groups Management' => '',

        # Template: AdminUserGroupForm

        # Template: AgentBook
        'Address Book' => 'ÏİÊÑ ÇáÚäÇæíä',
        'Return to the compose screen' => 'ÇáÚæÏÉ Åáì ÔÇÔÉ ÇáÅÑÓÇá',
        'Discard all changes and return to the compose screen' => 'ÅáÛÇÁ ÌãíÚ ÇáÊÛííÑÇÊ æ ÇáÚæÏÉ Åáì ÔÇÔÉ ÇáÅÑÓÇá',

        # Template: AgentCalendarSmall

        # Template: AgentCalendarSmallIcon

        # Template: AgentCustomerTableView

        # Template: AgentInfo
        'Info' => 'ãÚáæãÇÊ',

        # Template: AgentLinkObject
        'Link Object' => 'ÑÈØ ÇáßÇÆä',
        'Select' => 'ÃÎÊÑ',
        'Results' => 'ÇáäÊíÌÉ',
        'Total hits' => 'ÚÏÏ ÇáÊŞÇÑíÑ',
        'Page' => 'ÇáÕİÍÉ',
        'Detail' => 'ÇáÊİÇÕíá',

        # Template: AgentLookup
        'Lookup' => 'ÈÍË Úä',

        # Template: AgentNavigationBar

        # Template: AgentPreferencesForm

        # Template: AgentSpelling
        'Spell Checker' => 'ÇáãÏŞŞ ÇáÅãáÇÆí',
        'spelling error(s)' => 'ÃÎØÇÁ ÅãáÇÆíÉ',
        'or' => ' Ãæ ',
        'Apply these changes' => 'ÊØÈíŞ ÇáÊÛííÑÇÊ',

        # Template: AgentStatsDelete
        'Do you really want to delete this Object?' => 'åÇ ÊÑíÏ İÚáÇğ ÍĞİ åĞÇ ÇáßÇÆä¿',

        # Template: AgentStatsEditRestrictions
        'Select the restrictions to characterise the stat' => '',
        'Fixed' => '',
        'Please select only one element or turn off the button \'Fixed\'.' => '',
        'Absolut Period' => '',
        'Between' => 'Èíä',
        'Relative Period' => '',
        'The last' => '',
        'Finish' => '',
        'Here you can make restrictions to your stat.' => '',
        'If you remove the hook in the "Fixed" checkbox, the agent generating the stat can change the attributes of the corresponding element.' => '',

        # Template: AgentStatsEditSpecification
        'Insert of the common specifications' => '',
        'Permissions' => '',
        'Format' => '',
        'Graphsize' => '',
        'Sum rows' => '',
        'Sum columns' => '',
        'Cache' => '',
        'Required Field' => '',
        'Selection needed' => '',
        'Explanation' => '',
        'In this form you can select the basic specifications.' => '',
        'Attribute' => '',
        'Title of the stat.' => '',
        'Here you can insert a description of the stat.' => '',
        'Dynamic-Object' => '',
        'Here you can select the dynamic object you want to use.' => '',
        '(Note: It depends on your installation how many dynamic objects you can use)' => '',
        'Static-File' => '',
        'For very complex stats it is possible to include a hardcoded file.' => '',
        'If a new hardcoded file is available this attribute will be shown and you can select one.' => '',
        'Permission settings. You can select one or more groups to make the configurated stat visible for different agents.' => '',
        'Multiple selection of the output format.' => '',
        'If you use a graph as output format you have to select at least one graph size.' => '',
        'If you need the sum of every row select yes' => '',
        'If you need the sum of every column select yes.' => '',
        'Most of the stats can be cached. This will speed up the presentation of this stat.' => '',
        '(Note: Useful for big databases and low performance server)' => '',
        'With an invalid stat it isn\'t feasible to generate a stat.' => '',
        'This is useful if you want that no one can get the result of the stat or the stat isn\'t ready configurated.' => '',

        # Template: AgentStatsEditValueSeries
        'Select the elements for the value series' => '',
        'Scale' => '',
        'minimal' => '',
        'Please remember, that the scale for value series has to be larger than the scale for the X-axis (e.g. X-Axis => Month, ValueSeries => Year).' => '',
        'Here you can define the value series. You have the possibility to select one or two elements. Then you can select the attributes of elements. Each attribute will be shown as single value series. If you don\'t select any attribute all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' => '',

        # Template: AgentStatsEditXaxis
        'Select the element, which will be used at the X-axis' => '',
        'maximal period' => 'ÃØæá ãÏÉ',
        'minimal scale' => '',
        'Here you can define the x-axis. You can select one element via the radio button. Then you you have to select two or more attributes of the element. If you make no selection all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' => '',

        # Template: AgentStatsImport
        'Import' => 'ÇÓÊíÑÇÏ',
        'File is not a Stats config' => 'Çáãáİ áíÓ ãáİ ÎÕÇÆÕ ÇáÃÍÕÇÆÇÊ',
        'No File selected' => 'áã íÊã ÇÎÊíÇÑ Ãí ãáİ',

        # Template: AgentStatsOverview
        'Object' => 'ßÇÆä',

        # Template: AgentStatsPrint
        'Print' => 'ØÈÇÚÉ',
        'No Element selected.' => 'áã íÊã ÃÎÊíÇÑ Ãí ÚäÕÑ',

        # Template: AgentStatsView
        'Export Config' => 'ÊÕÏíÑ ÇáÎÕÇÆÕ',
        'Information about the Stat' => 'ãÚáæãÇÊ Úä ÇáÅÍÕÇÆÇÊ',
        'Exchange Axis' => '',
        'Configurable params of static stat' => '',
        'No element selected.' => 'áã íÊã ÊÍÏíÏ Ãí ÚäÕÑ',
        'maximal period from' => '',
        'to' => 'Åáì',
        'Start' => 'ÅÈÏÃ',
        'With the input and select fields you can configurate the stat at your needs. Which elements of a stat you can edit depends on your stats administrator who configurated the stat.' => '',

        # Template: AgentTicketBounce
        'Bounce ticket' => '',
        'Ticket locked!' => 'ÅŞİÇá ÇáÈØÇŞÉ',
        'Ticket unlock!' => 'İÊÍ ÇáÈØÇŞÉ',
        'Bounce to' => '',
        'Next ticket state' => 'ÍÇáÉ ÇáÈØÇŞÉ ÈÚÏ ÅäÔÇÆåÇ',
        'Inform sender' => 'ÃÎÈÑ ÇáãÑÓá',
        'Send mail!' => 'ÅÑÓÇá ÇáÈÑíÏ',

        # Template: AgentTicketBulk
        'Ticket Bulk Action' => 'ÇáÊäİíĞ ÇáÌãÇÚí ááÈØÇŞÉ',
        'Spell Check' => 'ÇáÊÏŞíŞ ÇáÅãáÇÆí',
        'Note type' => 'äæÚ ÇáãáÇÍÙÉ',
        'Unlock Tickets' => 'İß ÅÑÊÈÇØ ÇáÈØÇŞÇÊ',

        # Template: AgentTicketClose
        'Close ticket' => 'ÅŞİÇá ÇáÈØÇŞÉ',
        'Previous Owner' => 'ÇáãÇáß ÇáÓÇÈŞ',
        'Inform Agent' => 'ÃÈáÛ ÇáãÔÛá',
        'Optional' => 'ÅÎÊíÇÑí',
        'Inform involved Agents' => 'ÃÈáÛ ÇáãÔÛáíä ÇáãÔÇÑßíä',
        'Attach' => 'ÅÑİÇŞ',
        'Next state' => 'ÇáÍÇáÉ ÇáÊÇáíÉ',
        'Pending date' => 'ÊÇÑíÎ ÇáÅäÊÙÇÑ',
        'Time units' => 'æÍÏÇÊ ÇáæŞÊ',

        # Template: AgentTicketCompose
        'Compose answer for ticket' => 'ÃÑÓá ÅÌÇÈÉ Åáì ÇáÈØÇŞÉ',
        'Pending Date' => 'ÊÇÑíÎ ÇáÅäÊÙÇÑ',
        'for pending* states' => 'ÍÇáÉ ÇáÅäÊÙÇÑ*',

        # Template: AgentTicketCustomer
        'Change customer of ticket' => 'ÊÛííÑ ÇáÚãíá ÈÇáäÓÈÉ ááÈØÇŞÉ',
        'Set customer user and customer id of a ticket' => 'ßÊÇÈÉ ÅÓã ÇáÚãíá æÑŞã ÇáÚãíá ááÈØÇŞÉ',
        'Customer User' => 'ÇáÚãíá',
        'Search Customer' => 'ÇáÈÍË Úä Úãíá',
        'Customer Data' => 'ãÚáæãÇÊ ÇáÚãíá',
        'Customer history' => 'ÊÇÑíÎ ÇáÚãíá',
        'All customer tickets.' => 'ÌãíÚ ÈØÇŞÇÊ ÇáÚãíá',

        # Template: AgentTicketCustomerMessage
        'Follow up' => 'ÇáãÊÇÈÚÉ',

        # Template: AgentTicketEmail
        'Compose Email' => 'ÅÑÓÇá ÈÑíÏ',
        'new ticket' => 'ÈØÇŞÉ ÌÏíÏÉ',
        'Refresh' => 'ÊÍÏíË',
        'Clear To' => 'ãÓÍ Åáì',

        # Template: AgentTicketEscalationView
        'Ticket Escalation View' => '',
        'Escalation' => '',
        'Today' => '',
        'Tomorrow' => '',
        'Next Week' => '',
        'up' => 'ÃÚáì',
        'down' => 'ÃÓİá',
        'Escalation' => '',
        'Locked' => 'ãŞİá',

        # Template: AgentTicketForward
        'Article type' => 'äæÚ ÇáãŞÇáÉ',

        # Template: AgentTicketFreeText
        'Change free text of ticket' => '',

        # Template: AgentTicketHistory
        'History of' => 'ÊÇÑíÎ Çá',

        # Template: AgentTicketLocked

        # Template: AgentTicketMailbox
        'Mailbox' => 'ÕäÏæŞ ÇáÑÓÇÆá',
        'Tickets' => 'ÇáÈØÇŞÇÊ',
        'of' => 'ãä',
        'Filter' => 'ÇáÊÑÔíÍ',
        'New messages' => 'ÇáÑÓÇÆá ÇáÌÏíÏÉ',
        'Reminder' => 'ÇáÊĞßíÑ',
        'Sort by' => 'ÊÑÊíÈ ÈÜ',
        'Order' => 'ÑÊÈ',

        # Template: AgentTicketMerge
        'Ticket Merge' => 'ÏãÌ ÇáÈØÇŞÉ',
        'Merge to' => 'ÏãÌ Åáì',

        # Template: AgentTicketMove
        'Move Ticket' => 'äŞá ÇáÈØÇŞÉ',

        # Template: AgentTicketNote
        'Add note to ticket' => 'ÅÖÇİÉ ãáÇÍÙÉ Åáì ÇáÈØÇŞÉ',

        # Template: AgentTicketOwner
        'Change owner of ticket' => 'ÊÛííÑ ãÇáß ÇáÈØÇŞÉ',

        # Template: AgentTicketPending
        'Set Pending' => 'ÅÖÇİÉ Åáì ÇáÅäÊÙÇÑ',

        # Template: AgentTicketPhone
        'Phone call' => 'ãßÇáãÉ åÇÊİíÉ',
        'Clear From' => 'ãÓÍ ÇáäãæĞÌ',

        # Template: AgentTicketPhoneOutbound

        # Template: AgentTicketPlain
        'Plain' => '',

        # Template: AgentTicketPrint
        'Ticket-Info' => 'ãÚáæãÇÊ-ÇáÈØÇŞÉ',
        'Accounted time' => 'ÇáæŞÊ ÇáãÍÓæÈ',
        'First Response Time' => '',
        'Update Time' => '',
        'Solution Time' => '',
        'Linked-Object' => 'ÇáßÇÆä-ÇáãÑÈæØ',
        'Parent-Object' => 'ÇáßÇÆä-ÇáÃÓÇÓí',
        'Child-Object' => 'ÇáßÇÆä-ÇáİÑÚí',
        'by' => 'ÈæÇÓØÉ',

        # Template: AgentTicketPriority
        'Change priority of ticket' => 'ÊÛííÑ ÃæáæíÉ ÇáÈØÇŞÉ',

        # Template: AgentTicketQueue
        'Tickets shown' => 'ÚÑÖ ÇáÈØÇŞÇÊ',
        'Tickets available' => 'ÇáÈØÇŞÇÊ ÇáãÊæİÑÉ',
        'All tickets' => 'ÌãíÚ ÇáÈØÇŞÇÊ',
        'Queues' => 'ŞæÇÆã ÇáÈØÇŞÇÊ',
        'Ticket escalation!' => 'ÑİÚ ÇáÈØÇŞÉ',

        # Template: AgentTicketQueueTicketView
        'Service Time' => '',
        'Your own Ticket' => 'ÈØÇŞÊß ÇáÎÇÕÉ Èß',
        'Compose Follow up' => 'ÅÑÓÇá ÅÖÇİÉ ÇáãÊÇÈÚÉ',
        'Compose Answer' => 'ÅÑÓÇá ÇáÅÌÇÈÉ',
        'Contact customer' => 'ÇÊÕá ÈÇáÚãíá',
        'Change queue' => 'ÊÛííÑ ÇáŞÇÆãÉ',

        # Template: AgentTicketQueueTicketViewLite

        # Template: AgentTicketResponsible
        'Change responsible of ticket' => 'ÊÛííÑ ÇáãÓÄæá Úä ÇáÈØÇŞÉ',

        # Template: AgentTicketSearch
        'Ticket Search' => 'ÇáÈÍË Úä ÈØÇŞÉ',
        'Profile' => 'Çáãáİ',
        'Search-Template' => '',
        'TicketFreeText' => '',
        'Created in Queue' => 'ÃäÔÆÊ İí ÇáŞÇÆãÉ',
        'Close Times' => '',
        'No close time settings.' => '',
        'Ticket closed' => '',
        'Ticket closed between' => '',
        'Result Form' => 'äãæĞÌ ÇáäÊíÌÉ',
        'Save Search-Profile as Template?' => 'ÇÍİÙ ÅÚÏÇÏÇÊ ÇáÈÍË¿',
        'Yes, save it with name' => 'äÚã, ÃÍİÙåÇ ãÚ ÇáÅÓã',

        # Template: AgentTicketSearchOpenSearchDescription

        # Template: AgentTicketSearchResult
        'Change search options' => 'ÊÛííÑ ÎÕÇÆÕ ÇáÈÍË',

        # Template: AgentTicketSearchResultPrint

        # Template: AgentTicketSearchResultShort

        # Template: AgentTicketStatusView
        'Ticket Status View' => 'ÚÑÖ ÍÇáÉ ÇáÈØÇŞÇÊ',
        'Open Tickets' => 'ÇáÈØÇŞÇÊ ÇáãİÊæÍÉ',

        # Template: AgentTicketZoom
        'Expand View' => '',
        'Collapse View' => '',

        # Template: AgentWindowTab

        # Template: AJAX

        # Template: Copyright

        # Template: css

        # Template: customer-css

        # Template: CustomerAccept

        # Template: CustomerCalendarSmallIcon

        # Template: CustomerError
        'Traceback' => '',

        # Template: CustomerFooter
        'Powered by' => 'ÃäÊÌ ÈæÇÓØÉ',

        # Template: CustomerFooterSmall

        # Template: CustomerHeader

        # Template: CustomerHeaderSmall

        # Template: CustomerLogin
        'Login' => 'ÊÓÌíá ÇáÏÎæá',
        'Lost your password?' => 'İŞÏÊ ßáãÉ ÇáãÑæÑ¿',
        'Request new password' => 'ØáÈ ßáãÉ ãÑæÑ ÌÏíÏÉ',
        'Create Account' => 'ÅäÔÇÁ ÍÓÇÈ ÌÏíÏ',

        # Template: CustomerNavigationBar
        'Welcome %s' => 'ãÑÍÈÇğ %s',

        # Template: CustomerPreferencesForm

        # Template: CustomerStatusView

        # Template: CustomerTicketMessage

        # Template: CustomerTicketPrint

        # Template: CustomerTicketSearch
        'Times' => 'ÇáÃæŞÇÊ',
        'No time settings.' => 'ÈÏæä ÎíÇÑÇÊ ááæŞÊ',

        # Template: CustomerTicketSearchResultCSV

        # Template: CustomerTicketSearchResultPrint

        # Template: CustomerTicketSearchResultShort

        # Template: CustomerTicketZoom

        # Template: CustomerWarning

        # Template: Error
        'Click here to report a bug!' => 'ÃÖÛØ åäÇ ááÊÈáíÛ Úä ãÔßáÉ',

        # Template: Footer
        'Top of Page' => 'ÃÚáì ÇáÕİÍÉ',

        # Template: FooterSmall

        # Template: Header

        # Template: HeaderSmall

        # Template: Installer
        'Web-Installer' => '',
        'Welcome to %s' => 'ãÑÍÈÇğ Èß İí %s',
        'Accept license' => '',
        'Don\'t accept license' => '',
        'Admin-User' => '',
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty. For security reasons we do recommend setting a root password. For more information please refer to your database documentation.' => '',
        'Admin-Password' => '',
        'Database-User' => '',
        'default \'hot\'' => '',
        'DB connect host' => '',
        'Database' => '',
        'Default Charset' => '',
        'utf8' => '',
        'false' => '',
        'SystemID' => '',
        '(The identify of the system. Each ticket number and each http session id starts with this number)' => '',
        'System FQDN' => '',
        '(Full qualified domain name of your system)' => '',
        'AdminEmail' => '',
        '(Email of the system admin)' => '',
        'Organization' => '',
        'Log' => '',
        'LogModule' => '',
        '(Used log backend)' => '',
        'Logfile' => '',
        '(Logfile just needed for File-LogModule!)' => '',
        'Webfrontend' => '',
        'Use utf-8 it your database supports it!' => '',
        'Default Language' => '',
        '(Used default language)' => '',
        'CheckMXRecord' => '',
        '(Checks MX recordes of used email addresses by composing an answer. Don\'t use CheckMXRecord if your OTRS machine is behinde a dial-up line $!)' => '',
        'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' => '',
        'Restart your webserver' => '',
        'After doing so your OTRS is up and running.' => '',
        'Start page' => '',
        'Your OTRS Team' => '',

        # Template: Login

        # Template: Motd

        # Template: NoPermission
        'No Permission' => 'áÇ ÊæÌÏ ÕáÇÍíÇÊ',

        # Template: Notify
        'Important' => 'ãåã ÌÏÇğ',

        # Template: PrintFooter
        'URL' => '',

        # Template: PrintHeader
        'printed by' => 'ØÈÚ ÈæÇÓØÉ',

        # Template: Redirect

        # Template: Test
        'OTRS Test Page' => 'ÕİÍÉ ÇáÊÌÑÈÉ á OTRS',
        'Counter' => 'ÇáÚÏÇÏ',

        # Template: Warning
        # Misc
        'Edit Article' => '',
        'Create Database' => '',
        'DB Host' => '',
        'verified' => '',
        'File-Name' => '',
        'Ticket Number Generator' => '',
        '(Ticket identifier. Some people want toset this to e. g. \'Ticket#\', \'Call#\' or \'MyTicket#\')' => '',
        'Create new Phone Ticket' => 'ÃäÔíÁ ÈØÇŞÉ åÇÊİ ÌÏíÏÉ',
        'In this way you can directly edit the keyring configured in Kernel/Config.pm.' => '',
        'Symptom' => '',
        'U' => 'ÃÚáì',
        'A message should have a To: recipient!' => 'ÇáÑÓÇáÉ íÌÈ Ãä íßæä áåÇ: ãÊáŞí!',
        'Site' => '',
        'Customer history search (e. g. "ID342425").' => '',
        'for agent firstname' => '',
        'Close!' => 'ÅŞİÇá!',
        'Reporter' => '',
        'The message being composed has been closed.  Exiting.' => '',
        'Process-Path' => '',
        'to get the realname of the sender (if given)' => '',
        'FAQ Search Result' => 'äÊíÌÉ ÇáÈÍË İí ÇáÃÓÆáÉ ÇáãÊßÑÑÉ',
        'OTRS DB Name' => '',
        'Notification (Customer)' => '',
        'Select Source (for add)' => 'ÃÎÊÑ ÇáãÕÏÑ (ááÅÖÇİÉ)',
        'Node-Name' => '',
        'Options of the ticket data (e. g. &lt;OTRS_TICKET_Number&gt;, &lt;OTRS_TICKET_ID&gt;, &lt;OTRS_TICKET_Queue&gt;, &lt;OTRS_TICKET_State&gt;)' => '',
        'Days' => 'ÃíÇã',
        'Queue ID' => 'ÑŞã ÇáŞÇÆãÉ',
        'Home' => 'ÇáÑÆíÓíÉ',
        'Workflow Groups' => '',
        'Current Impact Rating' => '',
        'Config options (e. g. <OTRS_CONFIG_HttpType>)' => '',
        'System History' => 'ÊÇÑíÎ ÇáäÙÇã',
        'FAQ System History' => 'ÊÇÑíÎ äÙÇã ÇáÃÓÆáÉ ÇáãÊßÑÑÉ',
        'customer realname' => '',
        'Pending messages' => 'ÑÓÇÆá ÇáÅäÊÙÇÑ',
        'Port' => '',
        'Modules' => '',
        'for agent login' => '',
        'Keyword' => '',
        'Reference' => '',
        'with' => 'ãÚ',
        'Close type' => '',
        'DB Admin User' => '',
        'for agent user id' => '',
        'Victim' => '',
        'sort upward' => 'ÊÑÊíÈ ãä ÇáÃÚáì ááÃŞá',
        'Classification' => '',
        'Change user <-> group settings' => '',
        'Incident detected' => '',
        'Incident reported' => '',
        'Problem' => '',
        'Officer' => '',
        'next step' => 'ÇáÎØæÉ ÇáÊÇáíÉ',
        'Customer history search' => '',
        'not verified' => '',
        'Stat#' => '',
        'Create new database' => '',
        'Year' => 'ÇáÓäÉ',
        'A message must be spell checked!' => 'ÇáÑÓÇáÉ íÌÈ ÊÏŞíŞåÇ áÛæíÇğ!',
        'Service-Port' => '',
        'X-axis' => '',
        'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further information.' => '',
        'ArticleID' => '',
        'A message should have a body!' => 'ÇáÑÓÇáÉ íÌÈ Ãä íßæä áåÇ äÕ',
        'All Agents' => 'ÌãíÚ ÇáãÔÛáíä',
        'Keywords' => '',
        'No * possible!' => '',
        'Load' => '',
        'Change Time' => 'ÊÛííÑ ÇáæŞÊ',
        'Options of the current user who requested this action (e. g. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)' => '',
        'Message for new Owner' => 'ÑÓÇáÉ Åáì ÇáãÇáß ÇáÌÏíÏ',
        'to get the first 5 lines of the email' => '',
        'OTRS DB Password' => '',
        'Last update' => '',
        'not rated' => '',
        'to get the first 20 character of the subject' => '',
        'Select the customeruser:service relations.' => '',
        'DB Admin Password' => '',
        'Drop Database' => '',
        'Options of the current customer user data (e. g. <OTRS_CUSTOMER_DATA_UserFirstname>)' => 'ÇáÎíÇÑÇÊ áÈíÇäÇÊ ÇáÚãíá ÇáÍÇáí(ãËÇáå <OTRS_CUSTOMER_DATA_UserFirstname>)',
        'Pending type' => '',
        'Comment (internal)' => '',
        'Ticket owner options (e. g. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)' => '',
        'This window must be called from compose window' => '',
        'User-Number' => '',
        'You need min. one selected Ticket!' => 'íÌÈ ÊÍÏíÏ ÈØÇŞÉ æÇÍÏÉ Úáì ÇáÃŞá!',
        'Options of the ticket data (e. g. <OTRS_TICKET_Number>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' => '',
        '(Used ticket number format)' => '',
        'Fulltext' => 'ßÇãá ÇáäÕ',
        'Month' => 'ÇáÔåÑ',
        'OTRS DB connect host' => '',
        'Node-Address' => '',
        'All Agent variables.' => '',
        ' (work units)' => ' (æÍÏÇÊ ÇáÚãá) ',
        'You use the DELETE option! Take care, all deleted Tickets are lost!!!' => 'ŞãÊ ÈÅÓÊÎÏÇã "ÍĞİ" ! ÌãíÚ ÇáÈØÇŞÇÊ ÇáãÍĞæİÉ ãÓÍÊ ÈÔßá äåÇÆí!!!!',
        'All Customer variables like defined in config option CustomerUser.' => '',
        'Operation' => '',
        'accept license' => '',
        'for agent lastname' => '',
        'Options of the current user who requested this action (e. g. <OTRS_CURRENT_UserFirstname>)' => 'ÇáÎÕÇÆÕ ááãÓÊÎÏã ÇáÍÇáí ÇáĞí ØáÈ åĞå ÇáÚãáíÉ (ãËÇáå <OTRS_CURRENT_UserFirstname>)',
        'Reminder messages' => 'ÑÓÇÆá ÇáÊĞßíÑ',
        'A message should have a subject!' => 'ÇáÑÓÇáÉ íÌÈ Ãä íßæä áåÇ ãæÖæÚ!',
        'IMAPS' => '',
        'TicketZoom' => 'ÊßÈíÑ ÇáÈØÇŞÉ',
        'Don\'t forget to add a new user to groups!' => '',
        'You need a email address (e. g. customer@example.com) in To:!' => '',
        'CreateTicket' => 'ÃäÔíÁ ÈØÇŞÉ',
        'unknown' => 'ÛíÑ ãÚÑæİ',
        'You need to account time!' => 'íÌÈ Úáíß ÍÓÇÈ ÇáæŞÊ!',
        'System Settings' => 'ÅÚÏÇÏÇÊ ÇáäÙÇã',
        'Finished' => 'ÇäÊåì',
        'Imported' => 'Êã ÇáÅÓÊíÑÇÏ',
        'Account Type' => '',
        'unread' => 'ÛíÑ ãŞÑæÁ',
        'Split' => 'İÕá',
        'D' => 'ÃŞá',
        'All messages' => 'ÌãíÚ ÇáÑÓÇÆá',
        'System Status' => '',
        'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' => 'ÎíÇÑÇÊ ÈíÇäÇÊ ÇáÈØÇŞÉ (ãËÇáå <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)',
        'A article should have a title!' => 'ÇáÈØÇŞÉ íÌÈ Ãä íßæä áåÇ ÚäæÇä!',
        'Event' => '',
        'Config options (e. g. &lt;OTRS_CONFIG_HttpType&gt;)' => '',
        'don\'t accept license' => '',
        'IMAP' => '',
        'Imported by' => 'Êã ÅÓÊíÑÇÏå ãä ÎáÇá',
        'Ticket owner options (e. g. <OTRS_OWNER_UserFirstname>)' => 'ÎíÇÑÇÊ ãÇáß ÇáÈØÇŞÉ (ãËÇáå <OTRS_OWNER_UserFirstname>)',
        'read' => 'ÅŞÑÃ',
        'Product' => '',
        'Name is required!' => 'ÇáÅÓã ãŞÑæÁ',
        'DB Type' => '',
        'kill all sessions' => '',
        'to get the from line of the email' => '',
        'Solution' => 'ÇáÍá',
        'QueueView' => 'ÚÑÖ ÇáŞÇÆãÉ',
        'My Queue' => 'ŞÇÆãÊí',
        'Select Box' => '',
        'Instance' => 'äÓÎÉ',
        'Day' => 'íæã',
        'Service-Name' => 'ÇÓã ÇáÎÏãÉ',
        'Welcome to OTRS' => 'ãÑÍÈÇğ Èß İí OTRS',
        'tmp_lock' => '',
        'modified' => 'Êã ÊÚÏíáå',
        'Calculator' => '',
        'Escalation in' => 'ÊÕÚíÏ ÎáÇá',
        'Delete old database' => 'ÍĞİ ŞÇÚÏÉ ÇáÈíÇäÇÊ ÇáŞÏíãÉ',
        'sort downward' => 'ÊÑÊíÈ ãä ÇáÃŞá ááÃÚáì',
        'You need to use a ticket number!' => 'íÌÈ ÅÓÊÎÏÇã ÑŞã ÇáÈØÇŞÉ!',
        'Have a lot of fun!' => '',
        'send' => 'ÅÑÓÇá',
        'Note Text' => 'äÕ ÇáãáÇÍÙÉ',
        'POP3 Account Management' => '',
        'Options of the current customer user data (e. g. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)' => '',
        'System State Management' => '',
        'OTRS DB User' => '',
        'PhoneView' => '',
        'User-Name' => 'ÅÓã-ÇáãÓÊÎÏã',
        'TicketID' => '',
        'Management Summary' => '',
        'File-Path' => '',
        'POP3' => '',
        'POP3S' => '',
        'Modified' => 'Êã ÊÚÏíáå',
        'Ticket selected for bulk action!' => 'Êã ÊÍÏíÏ ÇáÈØÇŞÉ ááÊäİíĞ ÇáÌãÇÚí',

        'Link Object: %s' => '',
        'Unlink Object: %s' => '',
        'Linked as' => '',
        'Can not create link with %s!' => '',
        'Can not delete link with %s!' => '',
        'Object already linked as %s.' => '',
        'Priority Management' => '',
        'Add a new Priority.' => '',
        'Add Priority' => '',
        'Ticket Type is required!' => '',
        'Module documentation' => '',
        'Added!' => '',
        'Updated!' => '',
    };
    # $$STOP$$
    return;
}

1;
