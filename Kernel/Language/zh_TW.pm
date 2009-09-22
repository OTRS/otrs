# --
# Kernel/Language/zh_TW.pm - provides Chinese Traditional language translation
# Copyright (C) 2009 Bin Du <bindu2008 at gmail.com>
# Copyright (C) 2009 Yiye Huang <yiyehuang at gmail.com>
# Copyright (C) 2009 Qingjiu Jia <jiaqj at yahoo.com>
# --
# $Id: zh_TW.pm,v 1.4 2009-09-22 13:04:23 mg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::zh_TW;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.4 $) [1];

sub Data {
    my $Self = shift;

    # $$START$$
    # Last translation file sync: Thurs July16 13:56:58 2009

    # possible charsets
    $Self->{Charset} = ['big5', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Jear;)
    $Self->{DateFormat}          = '%Y.%M.%D %T';
    $Self->{DateFormatLong}      = ' %A %Y/%M/%D %T';
    $Self->{DateFormatShort}     = '%Y.%M.%D';
    $Self->{DateInputFormat}     = '%Y.%M.%D';
    $Self->{DateInputFormatLong} = '%Y.%M.%D - %T';

    $Self->{Translation} = {
        # Template: AAABase
        'Yes' => '¬O',
        'No' => '§_',
        'yes' => '¬O',
        'no' => '¥¼³]¸m',
        'Off' => 'Ãö',
        'off' => 'Ãö',
        'On' => '¶}',
        'on' => '¶}',
        'top' => '³»ºÝ',
        'end' => '©³³¡',
        'Done' => '½T»{',
        'Cancel' => '¨ú®ø',
        'Reset' => '­«¸m',
        'last' => '³Ì¦Z',
        'before' => '¦­©ó',
        'day' => '¤Ñ',
        'days' => '¤Ñ',
        'day(s)' => '¤Ñ',
        'hour' => '¤p®É',
        'hours' => '¤p®É',
        'hour(s)' => '¤p®É',
        'minute' => '¤ÀÄÁ',
        'minutes' => '¤ÀÄÁ',
        'minute(s)' => '¤ÀÄÁ',
        'month' => '¤ë',
        'months' => '¤ë',
        'month(s)' => '¤ë',
        'week' => '¬P´Á',
        'week(s)' => '¬P´Á',
        'year' => '¦~',
        'years' => '¦~',
        'year(s)' => '¦~',
        'second(s)' => '¬í',
        'seconds' => '¬í',
        'second' => '¬í',
        'wrote' => '¼g¹D',
        'Message' => '®ø®§',
        'Error' => '¿ù»~',
        'Bug Report' => 'Bug ³ø§i',
        'Attention' => 'ª`·N',
        'Warning' => 'Äµ§i',
        'Module' => '¼Ò¶ô',
        'Modulefile' => '¼Ò¶ô¤å¥ó',
        'Subfunction' => '¤l¥\¯à',
        'Line' => '¦æ',
        'Setting' => '³]¸m',
        'Settings' => '³]¸m',
        'Example' => '¥Ü¨Ò',
        'Examples' => '¥Ü¨Ò',
        'valid' => '¦³®Ä',
        'invalid' => 'µL®Ä',
        '* invalid' => '* µL®Ä',
        'invalid-temporarily' => '¼È®ÉµL®Ä',
        ' 2 minutes' => ' 2 ¤ÀÄÁ',
        ' 5 minutes' => ' 5 ¤ÀÄÁ',
        ' 7 minutes' => ' 7 ¤ÀÄÁ',
        '10 minutes' => '10 ¤ÀÄÁ',
        '15 minutes' => '15 ¤ÀÄÁ',
        'Mr.' => '¥ý¥Í',
        'Mrs.' => '¤Ò¤H',
        'Next' => '¤U¤@­Ó',
        'Back' => '¦Z°h',
        'Next...' => '¤U¤@­Ó...',
        '...Back' => '...¦Z°h',
        '-none-' => '-µL-',
        'none' => 'µL',
        'none!' => 'µL!',
        'none - answered' => 'µL - ¤wµª´_ªº',
        'please do not edit!' => '¤£­n½s¿è!',
        'AddLink' => '¼W¥[Ãì±µ',
        'Link' => 'Ãì±µ',
        'Unlink' => '¥¼Ãì±µ',
        'Linked' => '¤wÃì±µ',
        'Link (Normal)' => 'Ãì±µ (¥¿±`)',
        'Link (Parent)' => 'Ãì±µ (¤÷)',
        'Link (Child)' => 'Ãì±µ (¤l)',
        'Normal' => '¥¿±`',
        'Parent' => '¤÷',
        'Child' => '¤l',
        'Hit' => 'ÂIÀ»',
        'Hits' => 'ÂIÀ»¼Æ',
        'Text' => '¥¿¤å',
        'Lite' => 'Â²¼ä',
        'User' => '¥Î¤á',
        'Username' => '¥Î¤á¦WºÙ',
        'Language' => '»y¨¥',
        'Languages' => '»y¨¥',
        'Password' => '±K½X',
        'Salutation' => 'ºÙ¿×',
        'Signature' => 'Ã±¦W',
        'Customer' => '«È¤á',
        'CustomerID' => '«È¤á½s¸¹',
        'CustomerIDs' => '«È¤á½s¸¹',
        'customer' => '«È¤á',
        'agent' => '§Þ³N¤ä«ù¤H­û',
        'system' => '¨t²Î',
        'Customer Info' => '«È¤á«H®§',
        'Customer Company' => '«È¤á³æ¦ì',
        'Company' => '³æ¦ì',
        'go!' => '¶}©l!',
        'go' => '¶}©l',
        'All' => '¥þ³¡',
        'all' => '¥þ³¡',
        'Sorry' => '¹ï¤£°_',
        'update!' => '§ó·s!',
        'update' => '§ó·s',
        'Update' => '§ó·s',
        'Updated!' => '',
        'submit!' => '´£¥æ!',
        'submit' => '´£¥æ',
        'Submit' => '´£¥æ',
        'change!' => '­×§ï!',
        'Change' => '­×§ï',
        'change' => '­×§ï',
        'click here' => 'ÂIÀ»³o¸Ì',
        'Comment' => 'ª`ÄÀ',
        'Valid' => '¦³®Ä',
        'Invalid Option!' => 'µL®Ä¿ï¶µ!',
        'Invalid time!' => 'µL®Ä®É¶¡!',
        'Invalid date!' => 'µL®Ä¤é´Á!',
        'Name' => '¦WºÙ',
        'Group' => '²Õ¦W',
        'Description' => '´y­z',
        'description' => '´y­z',
        'Theme' => '¥DÃD',
        'Created' => '³Ð«Ø',
        'Created by' => '³Ð«Ø¥Ñ',
        'Changed' => '¤w­×§ï',
        'Changed by' => '­×§ï¥Ñ',
        'Search' => '·j¯Á',
        'and' => '©M',
        'between' => '¦b',
        'Fulltext Search' => '¥þ¤å·j¯Á',
        'Data' => '¤é´Á',
        'Options' => '¿ï¶µ',
        'Title' => '¼ÐÃD',
        'Item' => '±ø¥Ø',
        'Delete' => '§R°£',
        'Edit' => '½s¿è',
        'View' => '¬d¬Ý',
        'Number' => '½s¸¹',
        'System' => '¨t²Î',
        'Contact' => 'Áp¨t¤H',
        'Contacts' => 'Áp¨t¤H',
        'Export' => '¾É¥X',
        'Up' => '¤W',
        'Down' => '¤U',
        'Add' => '¼W¥[',
        'Added!' => '',
        'Category' => '¥Ø¿ý',
        'Viewer' => '¬d¬Ý¾¹',
        'Expand' => 'ÂX®i',
        'New message' => '·s®ø®§',
        'New message!' => '·s®ø®§!',
        'Please answer this ticket(s) to get back to the normal queue view!' => '½Ð¥ý¦^´_¸Ó Ticket¡AµM¦Z¦^¨ì¥¿±`¶¤¦Cµø¹Ï!',
        'You got new message!' => '±z¦³·s®ø®§!',
        'You have %s new message(s)!' => '±z¦³ %s ±ø·s®ø®§!',
        'You have %s reminder ticket(s)!' => '±z¦³ %s ­Ó´£¿ô!',
        'The recommended charset for your language is %s!' => '«ØÄ³±z©Ò¥Î»y¨¥ªº¦r²Å¶° %s!',
        'Passwords doesn\'t match! Please try it again!' => '±K½X¤£²Å¡A½Ð­«¸Õ!',
        'Password is already in use! Please use an other password!' => '¸Ó±K½X³Q¨Ï¥Î¡A½Ð¨Ï¥Î¨ä¥L±K½X!',
        'Password is already used! Please use an other password!' => '¸Ó±K½X³Q¨Ï¥Î¡A½Ð¨Ï¥Î¨ä¥L±K½X!',
        'You need to activate %s first to use it!' => '%s ¦b¨Ï¥Î¤§«e½Ð¥ý¿E¬¡!',
        'No suggestions' => 'µL«ØÄ³',
        'Word' => '¦r',
        'Ignore' => '©¿²¤',
        'replace with' => '´À´«',
        'There is no account with that login name.' => '¸Ó¥Î¤á¦W¨S¦³±b¤á«H®§.',
        'Login failed! Your username or password was entered incorrectly.' => 'µn¿ý¥¢±Ñ¡A±zªº¥Î¤á¦W©Î±K½X¤£¥¿½T.',
        'Please contact your admin' => '½ÐÁp¨t¨t²ÎºÞ²z­û',
        'Logout successful. Thank you for using OTRS!' => '¦¨¥\ª`¾P¡AÁÂÁÂ¨Ï¥Î!',
        'Invalid SessionID!' => 'µL®Äªº·|¸Ü¼ÐÃÑ²Å!',
        'Feature not active!' => '¸Ó¯S©Ê©|¥¼¿E¬¡!',
        'Notification (Event)' => '³qª¾¡]¨Æ¥ó¡^',
        'Login is needed!' => '»Ý­n¥ýµn¿ý!',
        'Password is needed!' => '»Ý­n±K½X!',
        'License' => '³\¥iµý',
        'Take this Customer' => '¨ú±o³o­Ó«È¤á',
        'Take this User' => '¨ú±o³o­Ó¥Î¤á',
        'possible' => '¥i¯à',
        'reject' => '©Úµ´',
        'reverse' => '¦Z°h',
        'Facility' => 'Ãþ§O',
        'Timeover' => 'µ²§ô',
        'Pending till' => 'µ¥«Ý¦Ü',
        'Don\'t work with UserID 1 (System account)! Create new users!' => '¤£­n¨Ï¥Î UserID 1 (¨t²Î½ã¸¹)! ½Ð³Ð«Ø¤@­Ó·sªº¥Î¤á!',
        'Dispatching by email To: field.' => '¤À¬£¶l¥ó¨ì: °ì.',
        'Dispatching by selected Queue.' => '¤À¬£¶l¥ó¨ì©Ò¿ï¶¤¦C.',
        'No entry found!' => 'µL¤º®e!',
        'Session has timed out. Please log in again.' => '·|¸Ü¶W®É¡A½Ð­«·sµn¿ý.',
        'No Permission!' => 'µLÅv­­!',
        'To: (%s) replaced with database email!' => 'To: (%s) ³Q¼Æ¾Ú®w¶l¥ó¦a§}©Ò´À¥N',
        'Cc: (%s) added database email!' => 'Cc: (%s) ¼W¥[¼Æ¾Ú®w¶l¥ó¦a§}!',
        '(Click here to add)' => '(ÂIÀ»¦¹³B¼W¥[)',
        'Preview' => '¹wÄý',
        'Package not correctly deployed! You should reinstall the Package again!' => '³n¥ó¥]®i¶}¤£¥¿±`! ±z»Ý­n¦A¤@¦¸­«·s¦w¸Ë³o­Ó³n¥ó¥]',
        'Added User "%s"' => '¼W¥[¥Î¤á "%s".',
        'Contract' => '¦X¦P',
        'Online Customer: %s' => '¦b½u«È¤á: %s',
        'Online Agent: %s' => '¦b½u§Þ³N¤ä«ù¤H­û¡G%s',
        'Calendar' => '¤é¾ú',
        'File' => '¤å¥ó',
        'Filename' => '¤å¥ó¦W',
        'Type' => 'Ãþ«¬',
        'Size' => '¤j¤p',
        'Upload' => '¤W¸ü',
        'Directory' => '¥Ø¿ý',
        'Signed' => '¤wÃ±¦W',
        'Sign' => 'Ã±¸p',
        'Crypted' => '¤w¥[±K',
        'Crypt' => '¥[±K',
        'Office' => '¿ì¤½«Ç',
        'Phone' => '¹q¸Ü',
        'Fax' => '¶Ç¯u',
        'Mobile' => '¤â¾÷',
        'Zip' => '¶l½s',
        'City' => '«°¥«',
        'Street' => 'µó¹D',
        'Country' => '°ê®a',
        'Location' => '°Ï',
        'installed' => '¤w¦w¸Ë',
        'uninstalled' => '¥¼¦w¸Ë',
        'Security Note: You should activate %s because application is already running!' => '¦w¥þ´£¥Ü: ±z¤£¯à¿E¬¡ªº %s, ¦]¬°¦¹À³¥Î¤w¸g¦b¹B¦æ!',
        'Unable to parse Online Repository index document!' => '¤£¯à¤À¦C¦b½u¸ê·½¯Á¤Þ¤åÀÉ',
        'No Packages for requested Framework in this Online Repository, but Packages for other Frameworks!' => '¦b½u¸ê·½¤¤¨S¦³³n¥ó¥]¹ïÀ³»Ý­nªº®Ø¬[¡A¦ý¦³¨ä¥Lªº®Ø¬[©Ò»Ý³n¥ó¥]',
        'No Packages or no new Packages in selected Online Repository!' => '¦b©Ò¿ïªº¦b½u¸ê·½¤¤¡A¨S¦³²{¦s©Î·sªº³n¥ó¥]',
        'printed at' => '¥´¦L¤é´Á',
        'Dear Mr. %s,' => '´L·qªº %s ¥ý¥Í:',
        'Dear Mrs. %s,' => '´L·qªº %s ¤k¤h:',
        'Dear %s,' => '´L·qªº %s:',
        'Hello %s,' => '±z¦n, %s:',
        'This account exists.' => '³o­Ó±b¤á¤w¦s¦b',
        'New account created. Sent Login-Account to %s.' => '·sªº±b¸¹¤w³Ð«Ø, ¨Ã±H°e³qª¾µ¹ %s.',
        'Please press Back and try again.' => '½Ðªð¦^¦A¸Õ¤@¦¸.',
        'Sent password token to: %s' => 'µo°e±K½X¨ì: %s',
        'Sent new password to: %s' => 'µo°e·sªº±K½X¨ì: %s',
        'Upcoming Events' => '§Y±N¨ì¨Óªº¨Æ¥ó',
        'Event' => '¨Æ¥ó',
        'Events' => '¨Æ¥ó',
        'Invalid Token!' => '«Dªkªº¼Ð°O',
        'more' => '§ó¦h',
        'For more info see:' => '§ó¦h«H®§½Ð¬Ý',
        'Package verification failed!' => '³n¥ó¥]Åçµý¥¢±Ñ',
        'Collapse' => '¦¬',
        'News' => '·s»D',
        'Product News' => '²£«~·s»D',
        'Bold' => '¶ÂÅé',
        'Italic' => '±×Åé',
        'Underline' => '©³½u',
        'Font Color' => '¦r«¬ÃC¦â',
        'Background Color' => '­I´º¦â',
        'Remove Formatting' => '§R°£®æ¦¡',
        'Show/Hide Hidden Elements' => 'Åã¥Ü/ÁôÂÃ ÁôÂÃ­n¯À',
        'Align Left' => '¥ª¹ï»ô',
        'Align Center' => '©~¤¤¹ï»ô',
        'Align Right' => '¥k¹ï»ô',
        'Justify' => '¹ï»ô',
        'Header' => '«H®§ÀY',
        'Indent' => 'ÁY',
        'Outdent' => '¥~¬ð',
        'Create an Unordered List' => '³Ð«Ø¤@­ÓµL§Ç¦Cªí',
        'Create an Ordered List' => '³Ð«Ø¤@­Ó¦³§Ç¦Cªí',
        'HTML Link' => 'HTMLÃì±µ',
        'Insert Image' => '´¡¤J¹Ï¹³',
        'CTRL' => '«öCTRL',
        'SHIFT' => '«öSHIFT',
        'Undo' => '´_­ì',
        'Redo' => '­«°µ',

        # Template: AAAMonth
        'Jan' => '¤@¤ë',
        'Feb' => '¤G¤ë',
        'Mar' => '¤T¤ë',
        'Apr' => '¥|¤ë',
        'May' => '¤­¤ë',
        'Jun' => '¤»¤ë',
        'Jul' => '¤C¤ë',
        'Aug' => '¤K¤ë',
        'Sep' => '¤E¤ë',
        'Oct' => '¤Q¤ë',
        'Nov' => '¤Q¤@¤ë',
        'Dec' => '¤Q¤G¤ë',
        'January' => '¤@¤ë',
        'February' => '¤G¤ë',
        'March' => '¤T¤ë',
        'April' => '¥|¤ë',
        'June' => '¤»¤ë',
        'July' => '¤C¤ë',
        'August' => '¤K¤ë',
        'September' => '¤E¤ë',
        'October' => '¤Q¤ë',
        'November' => '¤Q¤@¤ë',
        'December' => '¤Q¤G¤ë',

        # Template: AAANavBar
        'Admin-Area' => 'ºÞ²z°Ï°ì',
        'Agent-Area' => '§Þ³N¤ä«ù¤H­û°Ï',
        'Ticket-Area' => 'Ticket°Ï',
        'Logout' => 'ª`¾P',
        'Agent Preferences' => '­Ó¤H³]¸m',
        'Preferences' => '³]¸m',
        'Agent Mailbox' => '§Þ³N¤ä«ù¤H­û¶l½c',
        'Stats' => '²Î­p',
        'Stats-Area' => '²Î­p°Ï',
        'Admin' => 'ºÞ²z',
        'Customer Users' => '«È¤á¥Î¤á',
        'Customer Users <-> Groups' => '«È¤á¥Î¤á <-> ²Õ',
        'Users <-> Groups' => '¥Î¤á <-> ²Õ',
        'Roles' => '¨¤¦â',
        'Roles <-> Users' => '¨¤¦â <-> ¥Î¤á',
        'Roles <-> Groups' => '¨¤¦â <-> ²Õ',
        'Salutations' => 'ºÙ¿×',
        'Signatures' => 'Ã±¦W',
        'Email Addresses' => 'Email ¦a§}',
        'Notifications' => '¨t²Î³qª¾',
        'Category Tree' => '¥Ø¿ý¾ð',
        'Admin Notification' => 'ºÞ²z­û³qª¾',

        # Template: AAAPreferences
        'Preferences updated successfully!' => '³]¸m§ó·s¦¨¥\!',
        'Mail Management' => '¶l¥ó¬ÛÃö³]¸m',
        'Frontend' => '«eºÝ¬É­±',
        'Other Options' => '¨ä¥L¿ï¶µ',
        'Change Password' => '­×§ï±K½X',
        'New password' => '·s±K½X',
        'New password again' => '­«´_·s±K½X',
        'Select your QueueView refresh time.' => '¶¤¦Cµø¹Ï¨ê·s®É¶¡.',
        'Select your frontend language.' => '¬É­±»y¨¥',
        'Select your frontend Charset.' => '¬É­±¦r²Å¶°.',
        'Select your frontend Theme.' => '¬É­±¥DÃD.',
        'Select your frontend QueueView.' => '¶¤¦Cµø¹Ï.',
        'Spelling Dictionary' => '«÷¼gÀË¬d¦r¨å',
        'Select your default spelling dictionary.' => '¯Ê¬Ù«÷¼gÀË¬d¦r¨å.',
        'Max. shown Tickets a page in Overview.' => '¨C¤@­¶Åã¥Üªº³Ì¤j Tickets ¼Æ¥Ø.',
        'Can\'t update password, your new passwords do not match! Please try again!' => '±K½X¨â¦¸¤£²Å¡AµLªk§ó·s¡A½Ð­«·s¿é¤J',
        'Can\'t update password, invalid characters!' => 'µLªk§ó·s±K½X¡A¥]§tµL®Ä¦r²Å.',
        'Can\'t update password, must be at least %s characters!' => 'µLªk§ó·s±K½X¡A±K½Xªø«×¦Ü¤Ö%s¦ì.',
        'Can\'t update password, must contain 2 lower and 2 upper characters!' => 'µLªk§ó·s±K½X¡A¦Ü¤Ö¥]§t2­Ó¤j¼g¦r²Å©M2­Ó¤p¼g¦r²Å.',
        'Can\'t update password, needs at least 1 digit!' => 'µLªk§ó·s±K½X¡A¦Ü¤Ö¥]§t1¦ì¼Æ¦r',
        'Can\'t update password, needs at least 2 characters!' => 'µLªk§ó·s±K½X¡A¦Ü¤Ö¥]§t2­Ó¦r¥À!',

        # Template: AAAStats
        'Stat' => '²Î­p',
        'Please fill out the required fields!' => '½Ð¶ñ¼g¥²¶ñ¦r¬q',
        'Please select a file!' => '½Ð¿ï¾Ü¤@­Ó¤å¥ó!',
        'Please select an object!' => '½Ð¿ï¾Ü¤@­Ó¹ï¶H!',
        'Please select a graph size!' => '½Ð¿ï¾Ü¹Ï¤ù¤Ø¤o!',
        'Please select one element for the X-axis!' => '½Ð¿ï¾Ü¤@­Ó¤¸¯ÀªºX-¶b',
        'Please select only one element or turn off the button \'Fixed\' where the select field is marked!' => '½Ð°¦¿ï¾Ü¤@­Ó¤¸¯À©ÎÃö³¬³Q¿ï°ìªº\'Fixed\'«ö¶s',
        'If you use a checkbox you have to select some attributes of the select field!' => '¦pªG§A¨Ï¥Î´_¿ï®Ø§A¥²¶·¿ï¾Ü³Q¿ï°ìªº¤@¨ÇÄÝ©Ê!',
        'Please insert a value in the selected input field or turn off the \'Fixed\' checkbox!' => '¦b¿ï©wªº¿é¤JÄæ½Ð´¡¤J¤@­Ó­È¡A©ÎÃö³¬\'Fixed\'´_¿ï®Ø¡I',
        'The selected end time is before the start time!' => '¿ï©wªºµ²§ô®É¶¡¦­©ó¶}©l®É¶¡¡I',
        'You have to select one or more attributes from the select field!' => '±q³Q¿ï°ì¤¤§A¥²¶·¿ï¾Ü¤@­Ó©Î¦h­ÓÄÝ©Ê¡I',
        'The selected Date isn\'t valid!' => '©Ò¿ï¤é´Á¤£¦³®Ä',
        'Please select only one or two elements via the checkbox!' => '³q¹L´_¿ï®Ø¡A½Ð°¦¿ï¾Ü¤@­Ó©Î¨â­Ó­n¯À¡I',
        'If you use a time scale element you can only select one element!' => '¦pªG±z¨Ï¥Îªº¬O®É¶¡¤Ø«×­n¯À§A°¦¯à¿ï¾Ü¨ä¤¤¤@­Ó²Õ¦¨³¡¤À',
        'You have an error in your time selection!' => '§A¦³¤@­Ó¿ù»~ªº®É¶¡¿ï¾Ü¡I',
        'Your reporting time interval is too small, please use a larger time scale!' => '±zªº³ø§i®É¶¡¶¡¹j¤Ó¤p¡A½Ð¨Ï¥Î§ó¤jªº¶¡¹j',
        'The selected start time is before the allowed start time!' => '¿ï©wªº¶}©l®É¶¡¦­©ó¤¹³\ªº¶}©l®É¶¡',
        'The selected end time is after the allowed end time!' => '¿ï©wªºµ²§ô®É¶¡±ß©ó¤¹³\ªºµ²§ô®É¶¡',
        'The selected time period is larger than the allowed time period!' => '¦b¿ï©w®É¶¡¬q¤j©ó¤¹³\ªº®É¶¡¬q',
        'Common Specification' => '¦@¦P³W­S',
        'Xaxis' => 'X¶b',
        'Value Series' => '»ù­È¨t¦C',
        'Restrictions' => '­­¨î',
        'graph-lines' => '½u¹Ï',
        'graph-bars' => '¬Wª¬¹Ï',
        'graph-hbars' => 'H¬Wª¬¹Ï',
        'graph-points' => '¹ÏÂI',
        'graph-lines-points' => '¹Ï½uÂI',
        'graph-area' => '¹Ï°Ï',
        'graph-pie' => '»æ¹Ï',
        'extended' => 'ÂX®i',
        'Agent/Owner' => '©Ò¦³ªÌ',
        'Created by Agent/Owner' => '§Þ³N¤ä«ù¤H­û³Ð«Øªº',
        'Created Priority' => '³Ð«ØªºÀu¥ý¯Å',
        'Created State' => '³Ð«Øªºª¬ºA',
        'Create Time' => '³Ð«Ø®É¶¡',
        'CustomerUserLogin' => '«È¤áµn³°',
        'Close Time' => 'Ãö³¬®É¶¡',
        'TicketAccumulation' => 'Ticket¿n²Ö',
        'Attributes to be printed' => '­n¥´¦LªºÄÝ©Ê',
        'Sort sequence' => '±Æ§Ç§Ç¦C',
        'Order by' => '«ö¶¶§Ç±Æ',
        'Limit' => '·¥­­',
        'Ticketlist' => 'Ticket²M³æ',
        'ascending' => '¤É§Ç',
        'descending' => '­°§Ç',
        'First Lock' => '­º¥ýÂê©w',
        'Evaluation by' => 'µû»ùªº¤H',
        'Total Time' => 'Á`®É¶¡',
        'Ticket Average' => 'Ticket³B²z¥­§¡®É¶¡',
        'Ticket Min Time' => 'Ticket³B²z³Ì¤p®É¶¡',
        'Ticket Max Time' => 'Ticket³B²z³Ì¤j®É¶¡',
        'Number of Tickets' => 'Ticket¼Æ¥Ø',
        'Article Average' => 'Article³B²z¥­§¡®É¶¡',
        'Article Min Time' => 'Article³B²z³Ì¤p®É¶¡',
        'Article Max Time' => 'Article³B²z³Ì¤j®É¶¡',
        'Number of Articles' => 'Article¼Æ¶q',
        'Accounted time by Agent' => '§Þ³N¤ä«ù¤H­û³B²zTicket©Ò¥Îªº®É¶¡',
        'Ticket/Article Accounted Time' => 'Ticket/Article©Ò¦û¥Îªº®É¶¡',
        'TicketAccountedTime' => 'Ticket©Ò¦û¥Îªº®É¶¡',
        'Ticket Create Time' => 'Ticket³Ð«Ø®É¶¡',
        'Ticket Close Time' => 'TicketÃö³¬®É¶¡',

        # Template: AAATicket
        'Lock' => 'Âê©w',
        'Unlock' => '¸ÑÂê',
        'History' => '¾ú¥v',
        'Zoom' => '¶l¥ó®i¶}',
        'Age' => 'Á`®É¶¡',
        'Bounce' => '¦^°h',
        'Forward' => 'Âàµo',
        'From' => 'µo¥ó¤H',
        'To' => '¦¬¥ó¤H',
        'Cc' => '§Û°e',
        'Bcc' => '·t°e',
        'Subject' => '¼ÐÃD',
        'Move' => '²¾°Ê',
        'Queue' => '¶¤¦C',
        'Priority' => 'Àu¥ý¯Å',
        'Priority Update' => '§ó·sÀu¥ý¯Å',
        'State' => 'ª¬ºA',
        'Compose' => '¼¶¼g',
        'Pending' => 'µ¥«Ý',
        'Owner' => '©Ò¦³ªÌ',
        'Owner Update' => '§ó·s©Ò¦³ªÌ',
        'Responsible' => '­t³d¤H',
        'Responsible Update' => '§ó·s­t³d¤H',
        'Sender' => 'µo¥ó¤H',
        'Article' => '«H¥ó',
        'Ticket' => 'Ticket',
        'Createtime' => '³Ð«Ø®É¶¡',
        'plain' => '¯Â¤å¥»',
        'Email' => '¶l¥ó¦a§}',
        'email' => 'E-Mail',
        'Close' => 'Ãö³¬',
        'Action' => '°Ê§@',
        'Attachment' => 'ªþ¥ó',
        'Attachments' => 'ªþ¥ó',
        'This message was written in a character set other than your own.' => '³o«Ê¶l¥ó©Ò¥Î¦r²Å¶°»P¥»¨t²Î¦r²Å¶°¤£²Å',
        'If it is not displayed correctly,' => '¦pªGÅã¥Ü¤£¥¿½T,',
        'This is a' => '³o¬O¤@­Ó',
        'to open it in a new window.' => '¦b·sµ¡¤f¤¤¥´¶}',
        'This is a HTML email. Click here to show it.' => '³o¬O¤@«ÊHTML®æ¦¡¶l¥ó¡AÂIÀ»³o¸ÌÅã¥Ü.',
        'Free Fields' => 'ÃB¥~«H®§',
        'Merge' => '¦X¨Ã',
        'merged' => '¤w¦X¨Ã',
        'closed successful' => '¦¨¥\Ãö³¬',
        'closed unsuccessful' => 'Ãö³¬¥¢±Ñ',
        'new' => '·s«Ø',
        'open' => '¥´¶}',
        'Open' => '¥´¶}',
        'closed' => 'Ãö³¬',
        'Closed' => 'Ãö³¬',
        'removed' => '§R°£',
        'pending reminder' => 'µ¥«Ý´£¿ô',
        'pending auto' => '¦Û°Êµ¥«Ý',
        'pending auto close+' => 'µ¥«Ý¦Û°ÊÃö³¬+',
        'pending auto close-' => 'µ¥«Ý¦Û°ÊÃö³¬-',
        'email-external' => '¥~³¡ E-Mail ',
        'email-internal' => '¤º³¡ E-Mail ',
        'note-external' => '¥~³¡ª`¸Ñ',
        'note-internal' => '¤º³¡ª`¸Ñ',
        'note-report' => 'ª`¸Ñ³ø§i',
        'phone' => '¹q¸Ü',
        'sms' => 'µu«H',
        'webrequest' => 'Web½Ð¨D',
        'lock' => 'Âê©w',
        'unlock' => '¥¼Âê©w',
        'very low' => '«D±`§C',
        'low' => '§C',
        'normal' => '¥¿±`',
        'high' => '°ª',
        'very high' => '«D±`°ª',
        '1 very low' => '1 «D±`§C',
        '2 low' => '2 §C',
        '3 normal' => '3 ¥¿±`',
        '4 high' => '4 °ª',
        '5 very high' => '5 «D±`°ª',
        'Ticket "%s" created!' => 'Ticket "%s" ¤w³Ð«Ø!',
        'Ticket Number' => 'Ticket ½s¸¹',
        'Ticket Object' => 'Ticket ¹ï¶H',
        'No such Ticket Number "%s"! Can\'t link it!' => 'Ticket "%s" ¤£¦s¦b¡A¤£¯à³Ð«Ø¨ì¨äªºÃì±µ!',
        'Don\'t show closed Tickets' => '¤£Åã¥Ü¤wÃö³¬ªº Tickets',
        'Show closed Tickets' => 'Åã¥Ü¤wÃö³¬ªº Tickets',
        'New Article' => '·s¤å³¹',
        'Email-Ticket' => '¶l¥ó Ticket',
        'Create new Email Ticket' => '³Ð«Ø·sªº¶l¥ó Ticket',
        'Phone-Ticket' => '¹q¸Ü Ticket',
        'Search Tickets' => '·j¯Á Tickets',
        'Edit Customer Users' => '½s¿è«È¤á±b¤á',
        'Edit Customer Company' => '½s¿è«È¤á³æ¦ì',
        'Bulk Action' => '§å¶q³B²z',
        'Bulk Actions on Tickets' => '§å¶q³B²z Tickets',
        'Send Email and create a new Ticket' => 'µo°e Email ¨Ã³Ð«Ø¤@­Ó·sªº Ticket',
        'Create new Email Ticket and send this out (Outbound)' => '³Ð«Ø·sªº Ticket¨Ãµo°e¥X¥h',
        'Create new Phone Ticket (Inbound)' => '³Ð«Ø·sªº¹q¸ÜTicket¡]¶i¨ÓªºTicket¡^',
        'Overview of all open Tickets' => '©Ò¦³¶}©ñ Tickets ·§ªp',
        'Locked Tickets' => '¤wÂê©w Ticket',
        'Watched Tickets' => '­q¾\ Tickets',
        'Watched' => '­q¾',
        'Subscribe' => '­q¾',
        'Unsubscribe' => '°h­q',
        'Lock it to work on it!' => 'Âê©w¨Ã¶}©l¤u§@ !',
        'Unlock to give it back to the queue!' => '¸ÑÂê¨Ã°e¦^¶¤¦C!',
        'Shows the ticket history!' => 'Åã¥Ü Ticket ¾ú¥vª¬ªp!',
        'Print this ticket!' => '¥´¦L Ticket !',
        'Change the ticket priority!' => '­×§ï Ticket Àu¥ý¯Å',
        'Change the ticket free fields!' => '­×§ï Ticket ÃB¥~«H®§',
        'Link this ticket to an other objects!' => 'Ãì±µ¸Ó Ticket ¨ì¨ä¥L¹ï¶H!',
        'Change the ticket owner!' => '­×§ï Ticket ©Ò¦³ªÌ!',
        'Change the ticket customer!' => '­×§ï Ticket ©ÒÄÝ«È¤á!',
        'Add a note to this ticket!' => 'µ¹ Ticket ¼W¥[ª`¸Ñ!',
        'Merge this ticket!' => '¦X¨Ã¸Ó Ticket!',
        'Set this ticket to pending!' => '±N¸Ó Ticket Âà¤Jµ¥«Ýª¬ºA',
        'Close this ticket!' => 'Ãö³¬¸Ó Ticket!',
        'Look into a ticket!' => '¬d¬Ý Ticket ¤º®e',
        'Delete this ticket!' => '§R°£¸Ó Ticket!',
        'Mark as Spam!' => '¼Ð°O¬°©U§£!',
        'My Queues' => '§Úªº¶¤¦C',
        'Shown Tickets' => 'Åã¥Ü Tickets',
        'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' => '±zªº¶l¥ó "<OTRS_TICKET>" ³Q¦X¨Ã¨ì "<OTRS_MERGE_TO_TICKET>" !',
        'Ticket %s: first response time is over (%s)!' => 'Ticket %s: ²Ä¤@ÅTÀ³®É¶¡¤w¯Ó®É(%s)!',
        'Ticket %s: first response time will be over in %s!' => 'Ticket %s: ²Ä¤@ÅTÀ³®É¶¡±N¯Ó®É(%s)!',
        'Ticket %s: update time is over (%s)!' => 'Ticket %s: §ó·s®É¶¡¤w¯Ó®É(%s)!',
        'Ticket %s: update time will be over in %s!' => 'Ticket %s: §ó·s®É¶¡±N¯Ó®É(%s)!',
        'Ticket %s: solution time is over (%s)!' => 'Ticket %s: ³B²z¸Ñ¨M¤w¯Ó®É(%s)!',
        'Ticket %s: solution time will be over in %s!' => '³B²z¸Ñ¨M±N¯Ó®É(%s)!',
        'There are more escalated tickets!' => '¦³§ó¦h¤É¯Åªºtickets',
        'New ticket notification' => '·s Ticket ³qª¾',
        'Send me a notification if there is a new ticket in "My Queues".' => '¦pªG§Úªº¶¤¦C¤¤¦³·sªº Ticket¡A½Ð³qª¾§Ú.',
        'Follow up notification' => '¸òÂÜ³qª¾',
        'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.' => '¦pªG«È¤áµo°e¤F Ticket ¦^´_¡A¨Ã¥B§Ú¬O¸Ó Ticket ªº©Ò¦³ªÌ.',
        'Ticket lock timeout notification' => 'Ticket Âê©w¶W®É³qª¾ ',
        'Send me a notification if a ticket is unlocked by the system.' => '¦pªG Ticket ³Q¨t²Î¸ÑÂê¡A½Ð³qª¾§Ú.',
        'Move notification' => '²¾°Ê³qª¾',
        'Send me a notification if a ticket is moved into one of "My Queues".' => '¦pªG¦³ Ticket ³QÂà¤J§Úªº¶¤¦C¡A½Ð³qª¾§Ú.',
        'Your queue selection of your favourite queues. You also get notified about those queues via email if enabled.' => '±zªº³Ì±`¥Î¶¤¦C¡A¦pªG±zªº¶l¥ó³]¸m¿E¬¡¡A±z±N·|±o¨ì¸Ó¶¤¦Cªºª¬ºA³qª¾.',
        'Custom Queue' => '«È¤á¶¤¦C',
        'QueueView refresh time' => '¶¤¦Cµø¹Ï¨ê·s®É¶¡',
        'Screen after new ticket' => '³Ð«Ø·s Ticket ¦Zªºµø¹Ï',
        'Select your screen after creating a new ticket.' => '¿ï¾Ü±z³Ð«Ø·s Ticket ¦Z¡A©ÒÅã¥Üªºµø¹Ï.',
        'Closed Tickets' => 'Ãö³¬ Tickets',
        'Show closed tickets.' => 'Åã¥Ü¤wÃö³¬ Tickets.',
        'Max. shown Tickets a page in QueueView.' => '¶¤¦Cµø¹Ï¨C­¶Åã¥Ü Ticket ¼Æ.',
        'Watch notification' => 'Ãöª`³qª¾',
        'Send me a notification of an watched ticket like an owner of an ticket.' => '¹ï§Ú©ÒÃöª`ªºticket¡A¹³¸Óticketªº¾Ö¦³¤H¤@¼Ë¡Aµ¹§Ú¤]µo¤@¥÷³qª¾',
        'Out Of Office' => '¤£¦b¿ì¤½«Ç',
        'Select your out of office time.' => '¿ï¾Ü§A¤£¦b¿ì¤½«Çªº®É¶¡',
        'CompanyTickets' => '¤½¥qTickets',
        'MyTickets' => '§Úªº Tickets',
        'New Ticket' => '·sªº Ticket',
        'Create new Ticket' => '³Ð«Ø·sªº Ticket',
        'Customer called' => '«È¤á­P¹q',
        'phone call' => '¹q¸Ü©I¥s',
        'Reminder Reached' => '´£¿ô¤w¹F',
        'Reminder Tickets' => '´£¿ôªº Ticket',
        'Escalated Tickets' => '¤É¯ÅªºTicket',
        'New Tickets' => '·sªºTicket',
        'Open Tickets / Need to be answered' => '¥´¶}ªºTickets/»Ý­n¦^µª',
        'Tickets which need to be answered!' => '»Ý­n¦^µªªº Ticket',
        'All new tickets!' => '©Ò¦³·sªºtickets',
        'All tickets which are escalated!' => '©Ò¦³¤É¯Åªºtickets',
        'All tickets where the reminder date has reached!' => '©Ò¦³¤w¨ì´£¿ô¤é´ÁªºTicket',
        'Responses' => '¦^´_',
        'Responses <-> Queue' => '¦^´_ <-> ¶¤¦C',
        'Auto Responses' => '¦Û°Ê¦^´_¥\¯à',
        'Auto Responses <-> Queue' => '¦Û°Ê¦^´_ <-> ¶¤¦C',
        'Attachments <-> Responses' => 'ªþ¥ó <-> ¦^´_',
        'History::Move' => 'Ticket ²¾¨ì¶¤¦C "%s" (%s) ±q¶¤¦C "%s" (%s).',
        'History::TypeUpdate' => 'Updated Type to %s (ID=%s).',
        'History::ServiceUpdate' => 'Updated Service to %s (ID=%s).',
        'History::SLAUpdate' => '§ó·sªA°È¯Å§O¨óÄ³ to %s (ID=%s).',
        'History::NewTicket' => 'New ticket [%s] created (Q=%s;P=%s;S=%s).',
        'History::FollowUp' => 'FollowUp for [%s]. %s',
        'History::SendAutoReject' => '¦Û°Ê©Úµ´µo°eµ¹ "%s".',
        'History::SendAutoReply' => '¦Û°Ê¦^´_µo°eµ¹ "%s".',
        'History::SendAutoFollowUp' => '¦Û°Ê¸òÂÜµo°eµ¹ "%s".',
        'History::Forward' => 'Âàµoµ¹ "%s".',
        'History::Bounce' => '¦^°h¨ì "%s".',
        'History::SendAnswer' => '«H¥óµo°eµ¹ "%s".',
        'History::SendAgentNotification' => '"%s"-Benachrichtigung versand an "%s".',
        'History::SendCustomerNotification' => '³qª¾µo°eµ¹ "%s".',
        'History::EmailAgent' => 'µo¶l¥óµ¹«È¤á.',
        'History::EmailCustomer' => 'Add mail. %s',
        'History::PhoneCallAgent' => 'Called customer',
        'History::PhoneCallCustomer' => '«È¤á¤w¥´¹L¹q¸Ü',
        'History::AddNote' => '¥[ª`ÄÀ (%s)',
        'History::Lock' => 'Ticket Âê©w.',
        'History::Unlock' => 'Ticket ¸ÑÂê.',
        'History::TimeAccounting' => '%s time unit(d) counted. Totaly %s time unit(s) counted.',
        'History::Remove' => '%s',
        'History::CustomerUpdate' => 'Refreshed: %s',
        'History::PriorityUpdate' => 'Àu¥ý¯Å³Q§ó·s¡A±q  "%s" (%s) ¨ì "%s" (%s).',
        'History::OwnerUpdate' => 'New owner is "%s" (ID=%s).',
        'History::LoopProtection' => 'Loop protection! sent no auto answer to "%s".',
        'History::Misc' => '%s',
        'History::SetPendingTime' => 'Refreshed: %s',
        'History::StateUpdate' => 'Before "%s" ·s: "%s"',
        'History::TicketFreeTextUpdate' => 'Refreshed: %s=%s;%s=%s;',
        'History::WebRequestCustomer' => '«È¤á¶i¦æºô¤W½Ð¨D.',
        'History::TicketLinkAdd' => 'Link to "%s" established.',
        'History::TicketLinkDelete' => 'Link to "%s" removed.',
        'History::Subscribe' => 'Added subscription for user "%s".',
        'History::Unsubscribe' => 'Removed subscription for user "%s".',

        # Template: AAAWeekDay
        'Sun' => '¬P´Á¤é',
        'Mon' => '¬P´Á¤@',
        'Tue' => '¬P´Á¤G',
        'Wed' => '¬P´Á¤T',
        'Thu' => '¬P´Á¥|',
        'Fri' => '¬P´Á¤­',
        'Sat' => '¬P´Á¤»',

        # Template: AdminAttachmentForm
        'Attachment Management' => 'ªþ¥óºÞ²z',

        # Template: AdminAutoResponseForm
        'Auto Response Management' => '¦Û°Ê¦^´_ºÞ²z',
        'Response' => '¦^´_',
        'Auto Response From' => '¦Û°Ê¦^´_¨Ó¦Û',
        'Note' => 'ª`¸Ñ',
        'Useable options' => '¥i¥Î§»ÅÜ¶q',
        'To get the first 20 character of the subject.' => 'Åã¥Ü¼ÐÃDªº«e20­Ó¦r¸`',
        'To get the first 5 lines of the email.' => 'Åã¥Ü¹q¶lªº«e¤­¦æ',
        'To get the realname of the sender (if given).' => 'Åã¥Üµo¥ó¤Hªº¯u¹ê¦W¦r',
        'To get the article attribute (e. g. (<OTRS_CUSTOMER_From>, <OTRS_CUSTOMER_To>, <OTRS_CUSTOMER_Cc>, <OTRS_CUSTOMER_Subject> and <OTRS_CUSTOMER_Body>).' => '',
        'Options of the current customer user data (e. g. <OTRS_CUSTOMER_DATA_UserFirstname>).' => '·í«e«È¤á«H®§ªº¥i¿ï¶µ (e. g. <OTRS_CUSTOMER_DATA_UserFirstname>)',
        'Ticket owner options (e. g. <OTRS_OWNER_UserFirstname>).' => 'Ticket¾Ö¦³ªÌªº¥i¿ï¶µ e. g. <OTRS_OWNER_UserFirstname>).',
        'Ticket responsible options (e. g. <OTRS_RESPONSIBLE_UserFirstname>).' => 'Ticket³d¥ô¿ï¶µ (e. g. <OTRS_RESPONSIBLE_UserFirstname>).',
        'Options of the current user who requested this action (e. g. <OTRS_CURRENT_UserFirstname>).' => '',
        'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>).' => '',
        'Config options (e. g. <OTRS_CONFIG_HttpType>).' => '',

        # Template: AdminCustomerCompanyForm
        'Customer Company Management' => 'ºÞ²z«È¤H³æ¦ì',
        'Search for' => '·j¯Á',
        'Add Customer Company' => '¼W¥[«È¤H³æ¦ì',
        'Add a new Customer Company.' => '¼W¥[«È¤H¨ì³æ¦ì¸Ì',
        'List' => '¦Cªí',
        'This values are required.' => '¸Ó±ø¥Ø¥²¶·¶ñ¼g.',
        'This values are read only.' => '¸Ó¼Æ¾Ú°¦Åª.',

        # Template: AdminCustomerUserForm
        'The message being composed has been closed.  Exiting.' => '¶i¦æ®ø®§¼¶¼gªºµ¡¤f¤w¸g³QÃö³¬,°h¥X.',
        'This window must be called from compose window' => '¸Óµ¡¤f¥²¶·¥Ñ¼¶¼gµ¡¤f½Õ¥Î',
        'Customer User Management' => '«È¤á¥Î¤áºÞ²z',
        'Add Customer User' => '¼W¥[«È¤H',
        'Source' => '¼Æ¾Ú·½',
        'Create' => '³Ð«Ø',
        'Customer user will be needed to have a customer history and to login via customer panel.' => '«È¤á¥Î¤á¥²¶·¦³¤@­Ó½ã¸¹±q«È¤áµn¿ý­¶­±µn¿ý¨t²Î.',

        # Template: AdminCustomerUserGroupChangeForm
        'Customer Users <-> Groups Management' => '«È¤á¥Î¤á <-> ²Õ ºÞ²z',
        'Change %s settings' => '­×§ï %s ³]¸m',
        'Select the user:group permissions.' => '¿ï¾Ü ¥Î¤á:²Õ Åv­­.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the user).' => '¦pªG¤£¿ï¾Ü¡A«h¸Ó²Õ¨S¦³Åv­­ (¸Ó²ÕµLªk³B²z Ticket)',
        'Permission' => 'Åv­­',
        'ro' => '°¦Åª',
        'Read only access to the ticket in this group/queue.' => '¶¤¦C¤¤ªº Ticket °¦Åª.',
        'rw' => 'Åª¼g',
        'Full read and write access to the tickets in this group/queue.' => '¶¤¦C¤¤ªº Ticket Åª/¼g.',

        # Template: AdminCustomerUserGroupForm

        # Template: AdminCustomerUserService
        'Customer Users <-> Services Management' => '«È¤á±b¸¹ <-> ªA°ÈºÞ²z',
        'CustomerUser' => '«È¤á¥Î¤á',
        'Service' => 'ªA°È',
        'Edit default services.' => '½s¿èÀq»{ªA°È',
        'Search Result' => '·j¯Áµ²ªG',
        'Allocate services to CustomerUser' => '¤À°tªA°Èµ¹«È¤á',
        'Active' => '¿E¬¡',
        'Allocate CustomerUser to service' => '«ü¬£«È¤á¨ìªA°È',

        # Template: AdminEmail
        'Message sent to' => '®ø®§µo°eµ¹',
        'A message should have a subject!' => '¶l¥ó¥²¶·¦³¼ÐÃD!',
        'Recipients' => '¦¬¥ó¤H',
        'Body' => '¤º®e',
        'Send' => 'µo°e',

        # Template: AdminGenericAgent
        'GenericAgent' => '­p¹º¥ô°È',
        'Job-List' => '¤u§@¦Cªí',
        'Last run' => '³Ì¦Z¹B¦æ',
        'Run Now!' => '²{¦b¹B¦æ!',
        'x' => '',
        'Save Job as?' => '«O¦s¤u§@¬°?',
        'Is Job Valid?' => '¤u§@¬O§_¦³®Ä?',
        'Is Job Valid' => '¤u§@¦³®Ä',
        'Schedule' => '¦w±Æ',
        'Currently this generic agent job will not run automatically.' => '¥Ø«e³o¤@³q¥ÎAgent§@·~±N¤£·|¦Û°Ê¹B¦æ',
        'To enable automatic execution select at least one value from minutes, hours and days!' => '±Ò¥Î¦Û°Ê°õ¦æ¦Ü¤Ö¿ï¾Ü¤@­Ó­È¤ÀÄÁ¡A®É¶¡©M¤é´Á',
        'Fulltext-Search in Article (e. g. "Mar*in" or "Baue*")' => '¤å³¹¥þ¤å·j¯Á (¨Ò¦p: "Mar*in" ©ÎªÌ "Baue*")',
        '(e. g. 10*5155 or 105658*)' => '  ¨Ò¦p: 10*5144 ©ÎªÌ 105658*',
        '(e. g. 234321)' => '¨Ò¦p: 234321',
        'Customer User Login' => '«È¤á¥Î¤áµn¿ý«H®§',
        '(e. g. U5150)' => '¨Ò¦p: U5150',
        'SLA' => 'ªA°È¯Å§O¨óÄ³(SLA)',
        'Agent' => '§Þ³N¤ä«ù¤H­û',
        'Ticket Lock' => 'Ticket Âêª¬ºA',
        'TicketFreeFields' => 'Ticket ¦Û¥Ñ°Ï°ì',
        'Create Times' => '³Ð«Ø®É¶¡',
        'No create time settings.' => '¨S¦³³Ð«Ø®É¶¡³]¸m',
        'Ticket created' => '³Ð«Ø®É¶¡',
        'Ticket created between' => ' ³Ð«Ø®É¶¡¦b',
        'Close Times' => 'Ãö³¬®É¶¡',
        'No close time settings.' => '',
        'Ticket closed' => 'Ãö³¬ªº Ticket',
        'Ticket closed between' => '',
        'Pending Times' => '«Ý©w®É¶¡',
        'No pending time settings.' => '¨S¦³³]¸m«Ý©w®É¶¡',
        'Ticket pending time reached' => '«Ý©w®É¶¡¤w¨ìªºTicket',
        'Ticket pending time reached between' => '¦b«Ý©w®É¶¡¤ºªºTicket ',
        'Escalation Times' => '¤É¯Å®É¶¡',
        'No escalation time settings.' => '¨S¦³¤É¯Å®É¶¡³]¸m',
        'Ticket escalation time reached' => '¤w¨ì¤É¯Å®É¶¡Ticket',
        'Ticket escalation time reached between' => '¦b¤É¯Å®É¶¡¤ºªºTicket',
        'Escalation - First Response Time' => '¥ô°È½Õ¤É - ­º¦¸¦^´_ªº®É¶¡',
        'Ticket first response time reached' => '­º¦¸¦^´_®É¶¡¤w¨ìªºTicket',
        'Ticket first response time reached between' => '¦b­º¦¸¦^´_®É¶¡¤ºªºTicket',
        'Escalation - Update Time' => '¥ô°È½Õ¤É - §ó·sªº®É¶¡',
        'Ticket update time reached' => '§ó·s®É¶¡¤w¨ìªºTicket',
        'Ticket update time reached between' => '¦b§ó·s®É¶¡¤ºªºTicket',
        'Escalation - Solution Time' => '¥ô°È½Õ¤É - ¸Ñ¨Mªº®É¶¡',
        'Ticket solution time reached' => '¤è®×¸Ñ¨M®É¶¡¤w¨ìªºTicket',
        'Ticket solution time reached between' => '¦b¤è®×¸Ñ¨M®É¶¡¤º¤w¨ìªºTicket',
        'New Service' => '·sªºªA°È¯Å§O',
        'New SLA' => '·sªºªA°È¯Å§O¨óÄ³(SLA)',
        'New Priority' => '·sÀu¥ý¯Å',
        'New Queue' => '·s¶¤¦C',
        'New State' => '·sª¬ºA',
        'New Agent' => '·s§Þ³N¤ä«ù¤H­û',
        'New Owner' => '·s©Ò¦³ªÌ',
        'New Customer' => '·s«È¤á',
        'New Ticket Lock' => '·s Ticket Âê',
        'New Type' => '·sªºÃþ«¬',
        'New Title' => '·sªº¼ÐÃD',
        'New TicketFreeFields' => '·sªº Ticket ¦Û¥Ñ°Ï°ì',
        'Add Note' => '¼W¥[ª`¸Ñ',
        'Time units' => '®É¶¡³æ¤¸',
        'CMD' => '©R¥O',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' => '±N°õ¦æ³o­Ó©R¥O, ²Ä¤@­Ó°Ñ¼Æ¬O Ticket ½s¸¹¡A²Ä¤G­Ó°Ñ¼Æ¬O Ticket ªº¼ÐÃÑ²Å.',
        'Delete tickets' => '§R°£ Tickets',
        'Warning! This tickets will be removed from the database! This tickets are lost!' => 'Äµ§i! ¸Ó Ticket ±N·|±q¼Æ¾Ú®w§R°£¡AµLªk«ì´_!',
        'Send Notification' => 'µo°e³qª¾',
        'Param 1' => '°Ñ¼Æ 1',
        'Param 2' => '°Ñ¼Æ 2',
        'Param 3' => '°Ñ¼Æ 3',
        'Param 4' => '°Ñ¼Æ 4',
        'Param 5' => '°Ñ¼Æ 5',
        'Param 6' => '°Ñ¼Æ 6',
        'Send agent/customer notifications on changes' => 'µo°e¥N²z/«È¤á³qª¾ÅÜ§ó',
        'Save' => '«O¦s',
        '%s Tickets affected! Do you really want to use this job?' => '%s Tickets ¨ü¨ì¼vÅT! ±z½T©w­n¨Ï¥Î³o­Ó­p¹º¥ô°È?',

        # Template: AdminGroupForm
        'WARNING: When you change the name of the group \'admin\', before making the appropriate changes in the SysConfig, you will be locked out of the administrations panel! If this happens, please rename the group back to admin per SQL statement.' => 'Äµ§i¡G·í±z§ó§ï\'ºÞ²z\'²Õªº¦WºÙ®É¡A¦bSysConfig§@¥X¬ÛÀ³ªºÅÜ¤Æ¤§«e¡A§A±N³QºÞ²z­±ªOÂê¦í¡I¦pªGµo¥Í³oºØ±¡ªp¡A½Ð¥ÎSQL»y¥y§â²Õ¦W§ï¦^¨ì\'admin\'',
        'Group Management' => '²ÕºÞ²z',
        'Add Group' => '¼W¥[·sªº²Õ',
        'Add a new Group.' => '¼W¥[¤@­Ó·s²Õ',
        'The admin group is to get in the admin area and the stats group to get stats area.' => 'Admin ²Õ¥i¥H¶i¤J¨t²ÎºÞ²z°Ï°ì, Stats ²Õ¥i¥H¶i¤J²Î­pºÞ²z°Ï',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).' => '³Ð«Ø·sªº²Õ¨Ó±±¨î¤£¦Pªº¦s¨úÅv­­',
        'It\'s useful for ASP solutions.' => '³o¬O¤@­Ó¦³®ÄªºÀ³¥ÎªA°È´£¨Ñ°Ó(ASP)¸Ñ¨M¤è®×.',

        # Template: AdminLog
        'System Log' => '¨t²Î¤é§Ó',
        'Time' => '®É¶¡',

        # Template: AdminMailAccount
        'Mail Account Management' => '¶l¥ó±b¸¹ºÞ²z',
        'Host' => '¥D¾÷',
        'Trusted' => '¬O§_«H¥ô',
        'Dispatching' => '¤À¬£',
        'All incoming emails with one account will be dispatched in the selected queue!' => '©Ò¦³¨Ó¦Û¤@­Ó¶l¥ó½ã¸¹ªº¶l¥ó±N·|³Q¤Àµo¨ì©Ò¿ï¶¤¦C!',
        'If your account is trusted, the already existing X-OTRS header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' => '¦pªG±zªº±b¤á¬O­È±o«H¿àªº¡A²{¦³ªºX-OTRS¼ÐÃD¨ì¹F®É¶¡¡]Àu¥ý¡A ... ¡^±N³Q¨Ï¥Î¡I¶l¬F¹LÂo¾¹±N³Q¨Ï¥Î',

        # Template: AdminNavigationBar
        'Users' => '¥Î¤á',
        'Groups' => '²Õ',
        'Misc' => 'ºî¦X',

        # Template: AdminNotificationEventForm
        'Notification Management' => '³qª¾ºÞ²z',
        'Add Notification' => '¼W¥[³qª¾',
        'Add a new Notification.' => '',
        'Name is required!' => '»Ý­n¦WºÙ!',
        'Event is required!' => '»Ý­n¨Æ¥ó',
        'A message should have a body!' => '¶l¥ó¥²¶·¥]§t¤º®e!',
        'Recipient' => '¦¬¥ó¤H',
        'Group based' => '°ò©ó²Õªº',
        'Agent based' => '°ò©ó§Þ³N¤ä«ù¥Nªíªº',
        'Email based' => '°ò©ó¹q¶lªº',
        'Article Type' => 'ArticleÃþ§O ',
        'Only for ArticleCreate Event.' => '',
        'Subject match' => '¼ÐÃD¤Ç°t',
        'Body match' => '¤º®e¤Ç°t',
        'Notifications are sent to an agent or a customer.' => '³qª¾³Qµo°e¨ì§Þ³N¤ä«ù¤H­û©ÎªÌ«È¤á.',
        'To get the first 20 character of the subject (of the latest agent article).' => '',
        'To get the first 5 lines of the body (of the latest agent article).' => '',
        'To get the article attribute (e. g. (<OTRS_AGENT_From>, <OTRS_AGENT_To>, <OTRS_AGENT_Cc>, <OTRS_AGENT_Subject> and <OTRS_AGENT_Body>).' => '',
        'To get the first 20 character of the subject (of the latest customer article).' => '',
        'To get the first 5 lines of the body (of the latest customer article).' => '',

        # Template: AdminNotificationForm
        'Notification' => '¨t²Î³qª¾',

        # Template: AdminPackageManager
        'Package Manager' => '³n¥ó¥]ºÞ²z',
        'Uninstall' => '¨ø¸ü',
        'Version' => 'ª©¥»',
        'Do you really want to uninstall this package?' => '¬O§_½T»{¨ø¸ü¸Ó³n¥ó¥]?',
        'Reinstall' => '­«·s¦w¸Ë',
        'Do you really want to reinstall this package (all manual changes get lost)?' => '±z¬O§_­ã³Æ¦n­«·s¦w¸Ë³o¨Ç³n¥ó¥] (©Ò¦³¤â¤u³]¸m±N·|¤£¨£)?',
        'Continue' => 'Ä~Äò',
        'Install' => '¦w¸Ë',
        'Package' => '³n¥ó¥]',
        'Online Repository' => '¦b½uª¾ÃÑ®w',
        'Vendor' => '´£¨ÑªÌ',
        'Module documentation' => '¼Ò¶ô¤åÀÉ',
        'Upgrade' => '¤É¯Å',
        'Local Repository' => '¥»¦aª¾ÃÑ®w',
        'Status' => 'ª¬ºA',
        'Overview' => '·§ªp',
        'Download' => '¤U¸ü',
        'Rebuild' => '­«·sºc«Ø',
        'ChangeLog' => '§ïÅÜ°O¿ý',
        'Date' => '¤é´Á',
        'Filelist' => '¤å¥ó²M³æ',
        'Download file from package!' => '±q³n¥ó¥]¤¤¤U¸ü³o­Ó¤å¥ó',
        'Required' => '¥²»Ýªº',
        'PrimaryKey' => 'ÃöÁäªºKey',
        'AutoIncrement' => '¦Û°Ê»¼¼W',
        'SQL' => 'SQL',
        'Diff' => '¤ñ¸û',

        # Template: AdminPerformanceLog
        'Performance Log' => '¨t²ÎºÊµø¾¹',
        'This feature is enabled!' => '¸Ó¥\¯à¤w±Ò¥Î',
        'Just use this feature if you want to log each request.' => '¦pªG±z·Q¸Ô²Ó°O¿ý¨C­Ó½Ð¨D, ±z¥i¥H¨Ï¥Î¸Ó¥\¯à.',
        'Activating this feature might affect your system performance!' => '±Ò°Ê¸Ó¥\¯à¥i¯à¼vÅT±zªº¨t²Î©Ê¯à',
        'Disable it here!' => 'Ãö³¬¸Ó¥\¯à',
        'This feature is disabled!' => '¸Ó¥\¯à¤wÃö³¬',
        'Enable it here!' => '¥´¶}¸Ó¥\¯à',
        'Logfile too large!' => '¤é§Ó¤å¥ó¹L¤j',
        'Logfile too large, you need to reset it!' => '¤é§Ó¤å¥ó¹L¤j, §A»Ý­n­«¸m¥¦',
        'Range' => '­S³ò',
        'Interface' => '¬É­±',
        'Requests' => '½Ð¨D',
        'Min Response' => '³Ì¤p¦^À³',
        'Max Response' => '³Ì¤j¦^À³',
        'Average Response' => '¥­§¡¦^À³',
        'Period' => '©P´Á',
        'Min' => '³Ì¤p',
        'Max' => '³Ì¤j',
        'Average' => '¥­§¡',

        # Template: AdminPGPForm
        'PGP Management' => 'PGP ºÞ²z',
        'Result' => 'µ²ªG',
        'Identifier' => '¼ÐÃÑ²Å',
        'Bit' => '¦ì',
        'Key' => '±K°Í',
        'Fingerprint' => '«ü¦L',
        'Expires' => '¹L´Á',
        'In this way you can directly edit the keyring configured in SysConfig.' => '³oºØ¤è¦¡¡A±z¥i¥Hª½±µ½s¿è¦bSysConfig³]¸mªºÁä',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => '¶l¥ó¹LÂoºÞ²z',
        'Filtername' => '¹LÂo¾¹¦WºÙ',
        'Stop after match' => '',
        'Match' => '¤Ç°t',
        'Value' => '­È',
        'Set' => '³]¸m',
        'Do dispatch or filter incoming emails based on email X-Headers! RegExp is also possible.' => '¦pªG±z·Q®Ú¾Ú X-Headers ¤º®e¨Ó¹LÂo¡A¥i¥H¨Ï¥Î¥¿³W«hªí¹F¦¡.',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' => '¦pªG±z·Q¶È¤Ç°temail ¦a§}¡A ½Ð¨Ï¥ÎEMAILADDRESS:info@example.com in From, To or Cc.',
        'If you use RegExp, you also can use the matched value in () as [***] in \'Set\'.' => '¦pªG±z¥ÎRegExp¡A±z¤]¯à¨Ï¥Î¤Ç°t­Èin () as [***] in \'Set\'',

        # Template: AdminPriority
        'Priority Management' => 'Àu¥ýÅvºÞ²z',
        'Add Priority' => '²K¥[Àu¥ýÅv',
        'Add a new Priority.' => '¼W¥[¤@­Ó·sªºÀu¥ýÅv',

        # Template: AdminQueueAutoResponseForm
        'Queue <-> Auto Responses Management' => '¶¤¦C <-> ¦Û°Ê¦^´_ºÞ²z',
        'settings' => '³]¸m',

        # Template: AdminQueueForm
        'Queue Management' => '¶¤¦CºÞ²z',
        'Sub-Queue of' => '¤l¶¤¦C',
        'Unlock timeout' => '¦Û°Ê¸ÑÂê¶W®É´Á­­',
        '0 = no unlock' => '0 = ¤£¦Û°Ê¸ÑÂê  ',
        'Only business hours are counted.' => '¶È¥H¤W¯Z®É¶¡­pºâ',
        '0 = no escalation' => '0 = µL­­®É  ',
        'Notify by' => '¶i«×³qª¾',
        'Follow up Option' => '¸ò¶i¿ï¶µ',
        'Ticket lock after a follow up' => '¸ò¶i½T»{¥H¦Z¡ATicket ±N³Q¦Û°Ê¤WÂê',
        'Systemaddress' => '¨t²Î¶l¥ó¦a§}',
        'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.' => '¦pªG§Þ³N¤ä«ù¤H­ûÂê©w¤F Ticket,¦ý¬O¦b¤@©wªº®É¶¡¤º¨S¦³¦^´_¡A¸Ó Ticket ±N·|³Q¦Û°Ê¸ÑÂê¡A¦Ó¹ï©Ò¦³ªº§Þ³N¤ä«ù¤H­û¥iµø.',
        'Escalation time' => '­­®Éµª´_®É¶¡',
        'If a ticket will not be answered in this time, just only this ticket will be shown.' => '¸Ó¶¤¦C°¦Åã¥Ü³W©w®É¶¡¤º¨S¦³³Q³B²zªº Ticket',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.' => '¦pªG Ticket ¤w¸g³B©óÃö³¬ª¬ºA¡A¦Ó«È¤á´Nµo°e¤F¤@­Ó¸ò¶i Ticket¡A¨º»ò³o­Ó Ticket ±N·|³Qª½±µ¥[Âê¡A¦Ó©Ò¦³ªÌ³Q©w¸q¬°­ì¨Ó©Ò¦³ªÌ',
        'Will be the sender address of this queue for email answers.' => '¦^´_¶l¥ó©Ò¥Îªºµo°eªÌ¦a§}',
        'The salutation for email answers.' => '¦^´_¶l¥ó©Ò¥ÎºÙ¿×.',
        'The signature for email answers.' => '¦^´_¶l¥ó©Ò¥ÎÃ±¦W.',
        'Customer Move Notify' => 'Ticket ²¾°Ê«È¤á³qª¾',
        'OTRS sends an notification email to the customer if the ticket is moved.' => '¦pªG Ticket ³Q²¾°Ê¡A¨t²Î±N·|µo°e¤@­Ó³qª¾¶l¥óµ¹«È¤á',
        'Customer State Notify' => 'Ticket ª¬ºA«È¤á³qª¾',
        'OTRS sends an notification email to the customer if the ticket state has changed.' => '¦pªG Ticket ª¬ºA§ïÅÜ¡A¨t²Î±N·|µo°e³qª¾¶l¥óµ¹«È¤á',
        'Customer Owner Notify' => '«È¤á©Ò¦³ªÌ³q§i',
        'OTRS sends an notification email to the customer if the ticket owner has changed.' => '¦pªG Ticket ©Ò¦³ªÌ§ïÅÜ¡A¨t²Î±N·|µo°e³qª¾¶l¥óµ¹«È¤á.',

        # Template: AdminQueueResponsesChangeForm
        'Responses <-> Queue Management' => '¦^´_ <-> ¶¤¦CºÞ²z',

        # Template: AdminQueueResponsesForm
        'Answer' => '¦^´_',

        # Template: AdminResponseAttachmentChangeForm
        'Responses <-> Attachments Management' => '¦^´_ <-> ªþ¥óºÞ²z',

        # Template: AdminResponseAttachmentForm

        # Template: AdminResponseForm
        'Response Management' => '¦^´_¤º®eºÞ²z',
        'A response is default text to write faster answer (with default text) to customers.' => '¬°¤F§Ö³t¦^´_¡A¦^´_¤º®e©w¸q¤F¨C­Ó¦^´_¤¤­«´_ªº¤º®e.',
        'Don\'t forget to add a new response a queue!' => '¤£­n§Ñ°O¼W¥[¤@­Ó·sªº¦^´_¤º®e¨ì¶¤¦C!',
        'The current ticket state is' => '·í«e Ticket ª¬ºA¬O',
        'Your email address is new' => '±zªº¶l¥ó¦a§}¬O·sªº',

        # Template: AdminRoleForm
        'Role Management' => '¨¤¦âºÞ²z',
        'Add Role' => '¼W¥[¨¤¦â',
        'Add a new Role.' => '·s¼W¤@­Ó¨¤¦â',
        'Create a role and put groups in it. Then add the role to the users.' => '³Ð«Ø¤@­Ó¨¤¦â¨Ã±N²Õ¥[¤J¨¤¦â,µM¦Z±N¨¤¦â½áµ¹¥Î¤á.',
        'It\'s useful for a lot of users and groups.' => '·í¦³¤j¶qªº¥Î¤á©M²Õªº®É­Ô¡A¨¤¦â«D±`¾A¦X.',

        # Template: AdminRoleGroupChangeForm
        'Roles <-> Groups Management' => '¨¤¦â <-> ²ÕºÞ²z',
        'move_into' => '²¾°Ê¨ì',
        'Permissions to move tickets into this group/queue.' => '¤¹³\²¾°Ê Tickets ¨ì¸Ó²Õ/¶¤¦C.',
        'create' => '³Ð«Ø',
        'Permissions to create tickets in this group/queue.' => '¦b¸Ó²Õ/¶¤¦C¤¤³Ð«Ø Tickets ªºÅv­­.',
        'owner' => '©Ò¦³ªÌ',
        'Permissions to change the ticket owner in this group/queue.' => '¦b¸Ó²Õ/¶¤¦C¤¤­×§ï Tickets ©Ò¦³ªÌªºÅv­­.',
        'priority' => 'Àu¥ý¯Å',
        'Permissions to change the ticket priority in this group/queue.' => '¦b¸Ó²Õ/¶¤¦C¤¤­×§ï Tickets Àu¥ý¯ÅªºÅv­­.',

        # Template: AdminRoleGroupForm
        'Role' => '¨¤¦â',

        # Template: AdminRoleUserChangeForm
        'Roles <-> Users Management' => '¨¤¦â <-> ¥Î¤áºÞ²z',
        'Select the role:user relations.' => '¿ï¾Ü ¨¤¦â:¥Î¤á ÃöÁp.',

        # Template: AdminRoleUserForm

        # Template: AdminSalutationForm
        'Salutation Management' => 'ºÙ©I»yºÞ²z',
        'Add Salutation' => '¼W¥[ºÙ©I»y',
        'Add a new Salutation.' => '¼W¥[¤@­Ó·sªººÙ©I»y',

        # Template: AdminSecureMode
        'Secure Mode need to be enabled!' => '¦w¥þ¼Ò¦¡»Ý­n±Ò°Ê',
        'Secure mode will (normally) be set after the initial installation is completed.' => '¦bªì©l¦w¸Ëµ²§ô¦Z¡A¦w¥þ¼Ò¦¡³q±`±N³Q³]¸m',
        'Secure mode must be disabled in order to reinstall using the web-installer.' => '¬°¤F­«·s¥ÎWeb ¬É­±¦w¸Ë¡A¦w¥þ¼Ò¦¡¥²¶·disabled',
        'If Secure Mode is not activated, activate it via SysConfig because your application is already running.' => '¦pªG±Ò°Ê¼Ò¦¡¨S¦³³Q±Ò°Ê¡A½Ð³q¹L¨t²Î³]¸m±Ò°Ê¥¦¦]¬°±zªºOTRSµ{§Ç¤w¸g¹B¦æ',

        # Template: AdminSelectBoxForm
        'SQL Box' => 'SQL¬d¸ßµ¡¤f',
        'Go' => '°õ¦æ',
        'Select Box Result' => '¬d¸ßµ²ªG',

        # Template: AdminService
        'Service Management' => 'ªA°ÈºÞ²z',
        'Add Service' => '¼W¥[ªA°È',
        'Add a new Service.' => '·s¼W¤@­ÓªA°È',
        'Sub-Service of' => '¤lªA°ÈÁõÄÝ©ó',

        # Template: AdminSession
        'Session Management' => '·|¸ÜºÞ²z',
        'Sessions' => '·|¸Ü',
        'Uniq' => '³æ¤@',
        'Kill all sessions' => '²×¤î©Ò¦³·|¸Ü',
        'Session' => '·|¸Ü',
        'Content' => '¤º®e',
        'kill session' => '²×¤î·|¸Ü',

        # Template: AdminSignatureForm
        'Signature Management' => 'Ã±¦WºÞ²z',
        'Add Signature' => '¼W¥[Ã±¦W',
        'Add a new Signature.' => '·s¼W¤@­ÓÃ±¦W',

        # Template: AdminSLA
        'SLA Management' => 'ªA°È¯Å§O¨óÄ³(SLA)ºÞ²z',
        'Add SLA' => '¼W¥[ªA°È¯Å§O¨óÄ³(SLA)',
        'Add a new SLA.' => '·s¼W¤@­ÓªA°È¯Å§O¨óÄ³(SLA).',

        # Template: AdminSMIMEForm
        'S/MIME Management' => 'S/MIME ºÞ²z',
        'Add Certificate' => '²K¥[µý®Ñ',
        'Add Private Key' => '²K¥[¨p°Í',
        'Secret' => '±K½X',
        'Hash' => 'Hash',
        'In this way you can directly edit the certification and private keys in file system.' => '¥Î³oºØ¤è¦¡±z¥i¥Hª½±µ½s¿èµý®Ñ©M¨p°Í',

        # Template: AdminStateForm
        'State Management' => 'ª¬ºAºÞ²z',
        'Add State' => '¼W¥[ª¬ºA',
        'Add a new State.' => '¼W¥[¤@­Ó·sªºª¬ºA',
        'State Type' => 'ª¬ºAÃþ«¬',
        'Take care that you also updated the default states in you Kernel/Config.pm!' => '±z¦P®É§ó·s¤F Kernel/Config.pm ¤¤ªº¯Ê¬Ùª¬ºA!',
        'See also' => '°Ñ¨£',

        # Template: AdminSysConfig
        'SysConfig' => '¨t²Î°t¸m',
        'Group selection' => '¿ï¾Ü²Õ',
        'Show' => 'Åã¥Ü',
        'Download Settings' => '¤U¸ü³]¸m',
        'Download all system config changes.' => '¤U¸ü©Ò¦³ªº¨t²Î°t¸mÅÜ¤Æ.',
        'Load Settings' => '¥[¸ü³]¸m',
        'Subgroup' => '¤l²Õ',
        'Elements' => '¤¸¯À',

        # Template: AdminSysConfigEdit
        'Config Options' => '°t¸m¿ï¶µ',
        'Default' => '¯Ê¬Ù',
        'New' => '·s',
        'New Group' => '·s²Õ',
        'Group Ro' => '°¦ÅªÅv­­ªº²Õ',
        'New Group Ro' => '·sªº°¦ÅªÅv­­ªº²Õ',
        'NavBarName' => '¾É¯èÄæ¦WºÙ',
        'NavBar' => '¾É¯èÄæ',
        'Image' => '¹Ï¤ù',
        'Prio' => 'Àu¥ý¯Å',
        'Block' => '¶ô',
        'AccessKey' => '¶iÆ_',

        # Template: AdminSystemAddressForm
        'System Email Addresses Management' => '¨t²Î¶l¥ó¦a§}ºÞ²z',
        'Add System Address' => '¼W¥[¨t²Î¶l¥ó¦a§}',
        'Add a new System Address.' => '¼W¥[¤@­Ó·sªº¨t²Î¶l¥ó¦a§}.',
        'Realname' => '¯u¹ê©m¦W',
        'All email addresses get excluded on replaying on composing an email.' => '',
        'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!' => '©Ò¦³µo°e¨ì¸Ó¦¬¥ó¤Hªº®ø®§±N³QÂà¨ì©Ò¿ï¾Üªº¶¤¦C',

        # Template: AdminTypeForm
        'Type Management' => 'Ãþ«¬ºÞ²z',
        'Add Type' => '¼W¥[Ãþ«¬',
        'Add a new Type.' => '¼W¥[¤@­Ó·sªºÃþ«¬',

        # Template: AdminUserForm
        'User Management' => '¤H­ûºÞ²z',
        'Add User' => '¼W¥[¤H­û',
        'Add a new Agent.' => '¼W¥[¤@­Ó·sªº¤H­û',
        'Login as' => 'µn¿ý¦W',
        'Firstname' => '¦W',
        'Lastname' => '©m',
        'Start' => '¶}©l',
        'End' => 'µ²§ô',
        'User will be needed to handle tickets.' => '»Ý­n¥Î¤á¨Ó³B²z Tickets.',
        'Don\'t forget to add a new user to groups and/or roles!' => '¤£­n§Ñ°O¼W¥[¤@­Ó¥Î¤á¨ì²Õ©M¨¤¦â!',

        # Template: AdminUserGroupChangeForm
        'Users <-> Groups Management' => '¥Î¤á <-> ²ÕºÞ²z',

        # Template: AdminUserGroupForm

        # Template: AgentBook
        'Address Book' => '¦a§}Ã¯',
        'Return to the compose screen' => '¦^¨ì¼¶¼g­¶­±',
        'Discard all changes and return to the compose screen' => '©ñ±ó©Ò¦³­×§ï,¦^¨ì¼¶¼g­¶­±',

        # Template: AgentCalendarSmall

        # Template: AgentCalendarSmallIcon

        # Template: AgentCustomerSearch

        # Template: AgentCustomerTableView

        # Template: AgentDashboard
        'Dashboard' => '',

        # Template: AgentDashboardCalendarOverview
        'in' => '',

        # Template: AgentDashboardImage

        # Template: AgentDashboardProductNotify
        '%s %s is available!' => '',
        'Please update now.' => '½Ð§ó·s',
        'Release Note' => 'ª©¥»µo¥¬ª`ÄÀ',
        'Level' => '¯Å§O',

        # Template: AgentDashboardRSSOverview
        'Posted %s ago.' => '',

        # Template: AgentDashboardTicketOverview

        # Template: AgentDashboardTicketStats

        # Template: AgentInfo
        'Info' => '¸Ô±¡',

        # Template: AgentLinkObject
        'Link Object: %s' => '³s±µ¹ï¶H: %s',
        'Object' => '¹ï¶H',
        'Link Object' => 'Ãì±µ¹ï¶H',
        'with' => '©M',
        'Select' => '¿ï¾Ü',
        'Unlink Object: %s' => '¥¼³s±µ¹ï¶H %s',

        # Template: AgentLookup
        'Lookup' => '',

        # Template: AgentNavigationBar

        # Template: AgentPreferencesForm

        # Template: AgentSpelling
        'Spell Checker' => '«÷¼gÀË¬d',
        'spelling error(s)' => '«÷¼g¿ù»~',
        'or' => '©ÎªÌ',
        'Apply these changes' => 'À³¥Î³o¨Ç§ïÅÜ',

        # Template: AgentStatsDelete
        'Do you really want to delete this Object?' => '±z¬O§_½T»{§R°£¸Ó¹ï¶H?',

        # Template: AgentStatsEditRestrictions
        'Select the restrictions to characterise the stat' => '¿ï¾Ü­­¨î°Ñ¼Æ¡A¨Ï²Î­p¯S©º¤Æ',
        'Fixed' => '',
        'Please select only one element or turn off the button \'Fixed\'.' => '½Ð°¦¿ï¾Ü¤@­Ó¤¸¯À©ÎÃö³¬³Q¿ï°ìªº\'Fixed\'«ö¶s',
        'Absolut Period' => 'µ´¹ï©P´Á',
        'Between' => '',
        'Relative Period' => '¬Û¹ï©P´Á',
        'The last' => '',
        'Finish' => '',
        'Here you can make restrictions to your stat.' => '±z¥i¥H¬°±zªº²Î­p¨î©w­­¨î°Ñ¼Æ',
        'If you remove the hook in the "Fixed" checkbox, the agent generating the stat can change the attributes of the corresponding element.' => '¦pªG±z§R°£¹_¦b¡§©T©w¡¨´_¿ï®Ø¡A¥Í¦¨¸Ó²Î­pªº§Þ³N¤ä«ù¥Nªí¥i¥H§ïÅÜ¬ÛÀ³­n¯ÀªºÄÝ©Ê',

        # Template: AgentStatsEditSpecification
        'Insert of the common specifications' => '´¡¤J¦@¦P³W­S',
        'Permissions' => '¥i³',
        'Format' => '®æ¦¡',
        'Graphsize' => '¹Ï§Î¤Æ',
        'Sum rows' => 'Á`©M¦æ',
        'Sum columns' => 'Á`©M¦C',
        'Cache' => '½w¦s',
        'Required Field' => '¥²¶ñ¦r¬q',
        'Selection needed' => '¿ï¾Ü»Ý­n',
        'Explanation' => '¸ÑÄÀ',
        'In this form you can select the basic specifications.' => '¥H³oºØ§Î¦¡¡A±z¥i¥H¿ï¾Ü°ò¥»³W­S',
        'Attribute' => 'ÄÝ©Ê',
        'Title of the stat.' => '²Î­pªº¼ÐÃD',
        'Here you can insert a description of the stat.' => '±z¥i¥H´¡¤J²Î­pªº´y­z',
        'Dynamic-Object' => '°ÊºA¹ï¶H',
        'Here you can select the dynamic object you want to use.' => '±z¥i¥H¿ï¾Ü±z»Ý­n¨Ï¥Îªº°ÊºA¹ï¶H',
        '(Note: It depends on your installation how many dynamic objects you can use)' => 'ª`¡G³o¨ú¨M©ó±zªº¦w¸Ë¦h¤Ö°ÊºA¹ï¶H¥i¥H¨Ï¥Î',
        'Static-File' => 'ÀRºA¤å¥ó',
        'For very complex stats it is possible to include a hardcoded file.' => '¹ï©ó«D±`´_Âøªº²Î­p¦³¥i¯à¥]¬A¤@­Óµw½s½X¤å¥ó',
        'If a new hardcoded file is available this attribute will be shown and you can select one.' => '¦pªG¤@­Ó·sªºµw½s½X¤å¥ó¦s¦b¡A¥i¦¹ÄÝ©Ê±NÅã¥Ü¡A±z¥i¥H¿ï¾Ü¨ä¤¤¤@­Ó',
        'Permission settings. You can select one or more groups to make the configurated stat visible for different agents.' => 'Åv­­³]¸m¡C±z¥i¥H¿ï¾Ü¤@­Ó©Î¦h­Ó¹ÎÅé¡A¤£¦Pªº§Þ³N¤ä«ù¥Nªí³£¥i¬Ý¨£¸Ó°t¸mªº²Î­p',
        'Multiple selection of the output format.' => '¿é¥X®æ¦¡ªº¦hºØ¿ï¾Ü',
        'If you use a graph as output format you have to select at least one graph size.' => '¦pªG±z¨Ï¥Îªº¬O¹Ï§Îªº¿é¥X®æ¦¡§A¥²¶·¦Ü¤Ö¿ï¾Ü¤@­Ó¹Ï§Îªº¤j¤p',
        'If you need the sum of every row select yes' => '¦p»Ý­n¨C¦æªºÁ`©M¿ï¾Ü yes¡¦',
        'If you need the sum of every column select yes.' => '¦p»Ý­n¨C¦CªºÁ`©M¿ï¾Ü¡¦yes¡¦',
        'Most of the stats can be cached. This will speed up the presentation of this stat.' => '¤j¦h¼Æªº²Î­p¸ê®Æ¥i¥H½w¦s,³o±N¥[§Ö³o¤@²Î­pªº®i¥Ü.',
        '(Note: Useful for big databases and low performance server)' => 'ª`¡G¾A¥Î©ó¤j«¬¼Æ¾Ú®w©M§C©Ê¯àªºªA°È¾¹',
        'With an invalid stat it isn\'t feasible to generate a stat.' => '¥ÎµL®Äªº²Î­p¤£¥i¥Í¦¨²Î­p',
        'This is useful if you want that no one can get the result of the stat or the stat isn\'t ready configurated.' => '³o¬O«D±`¦³¥Îªº¡A¦pªG§A¤£·QÅý¤H±o¨ì²Î­pªºµ²ªG©Î²Î­pµ²ªG¨Ã¤£§¹¾ã',

        # Template: AgentStatsEditValueSeries
        'Select the elements for the value series' => '¿ï¾Ü»ù­È¨t¦Cªº­n¯À',
        'Scale' => '¤Ø«×',
        'minimal' => '³Ì¤p¤Æ',
        'Please remember, that the scale for value series has to be larger than the scale for the X-axis (e.g. X-Axis => Month, ValueSeries => Year).' => '½Ð°O¦í¡A³o¤ñÃBªíªº»ù­È¨t¦C­n¤j©óX¶bªº¤Ø«×¡]¦pX -¶b=>¥»¤ë¡A ValueSeries =>¦~¡^ ',
        'Here you can define the value series. You have the possibility to select one or two elements. Then you can select the attributes of elements. Each attribute will be shown as single value series. If you don\'t select any attribute all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' => '¦b³o¸Ì¡A±z¥i¥H©w¸q¤@¨t¦Cªº­È¡C§A¦³¥i¯à¿ï¾Ü¤@­Ó©Î¨â­Ó¦]¯À¡CµM¦Z±z¥i¥H¿ï¾Ü¤¸¯ÀªºÄÝ©Ê¡C¨C­ÓÄÝ©Ê±NÅã¥Ü¬°³æ¤@ªº­È¡C¦pªG±z¤£¿ï¾Ü¥ô¦óÄÝ©Ê, ¨º»ò·í±z¥Í¦¨¤@­Ó²Î­pªº®É­Ô©Ò¦³¤¸¯ÀªºÄÝ©Ê±N³Q¨Ï¥Î¡C¨Ã¥B¤@­Ó·sªºÄÝ©Ê³Q§ó·s¨ì¤W¦¸°t¸m¤¤',

        # Template: AgentStatsEditXaxis
        'Select the element, which will be used at the X-axis' => '¿ï¾Ü±N¥Î¦bx¶bªº¤¸¯À',
        'maximal period' => '³Ì¤j©P´Á',
        'minimal scale' => '³Ì¤p¤Ø«×',
        'Here you can define the x-axis. You can select one element via the radio button. If you make no selection all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' => '¦b³o¸Ì¡A±z¥i¥H©w¸qx¶b¡C±z¥i¥H¿ï¾Üªº¤@­Ó¦]¯À³q¹L³æ¿ï«ö¶s¡C¦pªG§A¨S¦³¿ï¾Ü¡A©Ò¦³¤¸¯ÀªºÄÝ©Ê±N³Q¨Ï¥Î·í±z¥Í¦¨¤@­Ó²Î­pªº®É­Ô¡C¨Ã¥B¤@­Ó·sªºÄÝ©Ê³Q§ó·s¨ì¤W¦¸°t¸m¤¤',

        # Template: AgentStatsImport
        'Import' => '¾É¤J',
        'File is not a Stats config' => '¤å¥ó¤£¬O¤@­Ó²Î­p°t¸m',
        'No File selected' => '¨S¦³¤å¥ó³Q¿ï¤¤',

        # Template: AgentStatsOverview
        'Results' => 'µ²ªG',
        'Total hits' => 'ÂIÀ»¼Æ',
        'Page' => '­¶',

        # Template: AgentStatsPrint
        'Print' => '¥´¦L',
        'No Element selected.' => '¨S¦³¤¸¯À³Q¿ï¤¤',

        # Template: AgentStatsView
        'Export Config' => '¾É¥X°t¸m',
        'Information about the Stat' => 'Ãö©ó²Î­pªº«H®§',
        'Exchange Axis' => 'Âà´«¶b',
        'Configurable params of static stat' => 'ÀRºA²Î­pªº°t¸m°Ñ¼Æ',
        'No element selected.' => '¨S¦³³Q¿ï°Ñ¼Æ',
        'maximal period from' => '³Ì¤j©P´Áªí',
        'to' => '¦Ü',
        'With the input and select fields you can configurate the stat at your needs. Which elements of a stat you can edit depends on your stats administrator who configurated the stat.' => '³q¹L¿é¤J©M¿ï¾Ü¦r¬q¡A±z¥i¥H«ö±zªº»Ý¨D¨Ó°t¸m²Î­p¡C±z¥i¥H­×§ï½s¿è¨º¨Ç²Î­p­n¯À¥Ñ±zªº²Î­p¸ê®ÆºÞ²z­û¨Ó³]¸m¡C',

        # Template: AgentTicketBounce
        'A message should have a To: recipient!' => '¶l¥ó¥²¶·¦³¦¬¥ó¤H!',
        'You need a email address (e. g. customer@example.com) in To:!' => '¦¬¥ó¤H«H®§¥²¶·¬O¶l¥ó¦a§}(¨Ò¦p¡Gcustomer@example.com)',
        'Bounce ticket' => '¦^°h Ticket ',
        'Ticket locked!' => 'Ticket ³QÂê©w!',
        'Ticket unlock!' => '¸ÑÂê Ticket!',
        'Bounce to' => '¦^°h¨ì ',
        'Next ticket state' => 'Tickets ª¬ºA',
        'Inform sender' => '³qª¾µo°eªÌ',
        'Send mail!' => 'µo°e!',

        # Template: AgentTicketBulk
        'You need to account time!' => '±z»Ý­n°O¿ý®É¶¡',
        'Ticket Bulk Action' => 'Ticket §å¶q³B²z',
        'Spell Check' => '«÷¼gÀË¬d',
        'Note type' => 'ª`ÄÀÃþ«¬',
        'Next state' => 'Ticket ª¬ºA',
        'Pending date' => '«Ý³B²z¤é´Á',
        'Merge to' => '¦X¨Ã¨ì',
        'Merge to oldest' => '¦X¨Ã¨ì³Ì¦Ñªº',
        'Link together' => '¦X¨Ã¦b¤@°_',
        'Link to Parent' => '¦X¨Ã¨ì¤W¤@¯Å',
        'Unlock Tickets' => '¸ÑÂê Tickets',

        # Template: AgentTicketClose
        'Ticket Type is required!' => 'Ticket ªºÃþ«¬¬O¥²¶·ªº!',
        'A required field is:' => '¥²¶·ªº¦r¬q¬O',
        'Close ticket' => 'Ãö³¬ Ticket',
        'Previous Owner' => '«e¤@­Ó©Ò¦³ªÌ',
        'Inform Agent' => '³qª¾§Þ³N¤ä«ù¤H­û',
        'Optional' => '¿ï¶µ',
        'Inform involved Agents' => '³qª¾¬ÛÃö§Þ³N¤ä«ù¤H­û',
        'Attach' => 'ªþ¥ó',

        # Template: AgentTicketCompose
        'A message must be spell checked!' => '®ø®§¥²¶·¸g¹L«÷¼gÀË¬d!',
        'Compose answer for ticket' => '¼¶¼gµª´_,Ticket ½s¸¹',
        'Pending Date' => '¶i¤Jµ¥«Ýª¬ºA¤é´Á',
        'for pending* states' => '°w¹ïµ¥«Ýª¬ºA',

        # Template: AgentTicketCustomer
        'Change customer of ticket' => '­×§ï Tickets ©ÒÄÝ«È¤á',
        'Set customer user and customer id of a ticket' => '³]¸m Ticket ©ÒÄÝ«È¤á¥Î¤á',
        'Customer User' => '«È¤á¥Î¤á',
        'Search Customer' => '·j¯Á«È¤á',
        'Customer Data' => '«È¤á¼Æ¾Ú',
        'Customer history' => '«È¤á¾ú¥v±¡ªp',
        'All customer tickets.' => '¸Ó«È¤á©Ò¦³ Tickets °O¿ý.',

        # Template: AgentTicketEmail
        'Compose Email' => '¼¶¼g Email',
        'new ticket' => '·s«Ø Ticket',
        'Refresh' => '¨ê·s',
        'Clear To' => '²MªÅ',
        'All Agents' => '©Ò¦³§Þ³N¤ä«ù¤H­û',

        # Template: AgentTicketEscalation

        # Template: AgentTicketForward
        'Article type' => '¤å³¹Ãþ«¬',

        # Template: AgentTicketFreeText
        'Change free text of ticket' => '­×§ï Ticket ÃB¥~«H®§',

        # Template: AgentTicketHistory
        'History of' => '¾ú¥v',

        # Template: AgentTicketLocked

        # Template: AgentTicketMerge
        'You need to use a ticket number!' => '±z»Ý­n¨Ï¥Î¤@­Ó Ticket ½s¸¹!',
        'Ticket Merge' => 'Ticket ¦X¨Ã',

        # Template: AgentTicketMove
        'Move Ticket' => '²¾°Ê Ticket',

        # Template: AgentTicketNote
        'Add note to ticket' => '¼W¥[ª`¸Ñ¨ì Ticket',

        # Template: AgentTicketOverviewMedium
        'First Response Time' => '­º¦¸³ø§i®É¶¡',
        'Service Time' => 'ªA°È®É¶¡',
        'Update Time' => '§ó·s®É¶¡',
        'Solution Time' => '¸Ñ¨M®É¶¡',

        # Template: AgentTicketOverviewMediumMeta
        'You need min. one selected Ticket!' => '±z¦Ü¤Ö»Ý­n¿ï¾Ü¤@­Ó Ticket!',

        # Template: AgentTicketOverviewNavBar
        'Filter' => '¹LÂo¾¹',
        'Change search options' => '­×§ï·j¯Á¿ï¶µ',
        'Tickets' => '',
        'of' => '',

        # Template: AgentTicketOverviewNavBarSmall

        # Template: AgentTicketOverviewPreview
        'Compose Answer' => '¼¶¼gµª´_',
        'Contact customer' => 'Áp¨t«È¤á',
        'Change queue' => '§ïÅÜ¶¤¦C',

        # Template: AgentTicketOverviewPreviewMeta

        # Template: AgentTicketOverviewSmall
        'sort upward' => '¥¿§Ç±Æ§Ç',
        'up' => '¤W',
        'sort downward' => '°f§Ç±Æ§Ç',
        'down' => '¤U',
        'Escalation in' => '­­®É',
        'Locked' => 'Âê©wª¬ºA',

        # Template: AgentTicketOwner
        'Change owner of ticket' => '­×§ï Ticket ©Ò¦³ªÌ',

        # Template: AgentTicketPending
        'Set Pending' => '³]¸m«Ý³B²zª¬ºA',

        # Template: AgentTicketPhone
        'Phone call' => '¹q¸Ü',
        'Clear From' => '­«¸m',

        # Template: AgentTicketPhoneOutbound

        # Template: AgentTicketPlain
        'Plain' => '¯Â¤å¥»',

        # Template: AgentTicketPrint
        'Ticket-Info' => 'Ticket«H®§',
        'Accounted time' => '©Ò¥Î®É¶¡',
        'Linked-Object' => '¤wÃì±µ¹ï¶H',
        'by' => '¥Ñ',

        # Template: AgentTicketPriority
        'Change priority of ticket' => '½Õ¾ã Ticket Àu¥ý¯Å',

        # Template: AgentTicketQueue
        'Tickets shown' => 'Åã¥Ü Ticket',
        'Tickets available' => '¥i¥Î Ticket',
        'All tickets' => '©Ò¦³Ticket',
        'Queues' => '¶¤¦C',
        'Ticket escalation!' => 'Ticket ­­®É³B²z!',

        # Template: AgentTicketResponsible
        'Change responsible of ticket' => '§ó§ï Ticket ªº­t³d¤H',

        # Template: AgentTicketSearch
        'Ticket Search' => 'Ticket ·j¯Á',
        'Profile' => '·j¯Á¬ù§ô±ø¥ó',
        'Search-Template' => '·j¯Á¼ÒªO',
        'TicketFreeText' => 'Ticket ÃB¥~«H®§',
        'Created in Queue' => '¦b¶¤¦C¸Ì«Ø¥ß',
        'Article Create Times' => '',
        'Article created' => '',
        'Article created between' => '',
        'Change Times' => '§ïÅÜ®É¶¡',
        'No change time settings.' => '¤£§ïÅÜ®É¶¡³]¸m',
        'Ticket changed' => '',
        'Ticket changed between' => '',
        'Result Form' => '·j¯Áµ²ªGÅã¥Ü¬°',
        'Save Search-Profile as Template?' => '±N·j¯Á±ø¥ó«O¦s¬°¼ÒªO',
        'Yes, save it with name' => '¬O, «O¦s¬°¦WºÙ',

        # Template: AgentTicketSearchOpenSearchDescriptionFulltext
        'Fulltext' => '¥þ¤å',

        # Template: AgentTicketSearchOpenSearchDescriptionTicketNumber

        # Template: AgentTicketSearchResultPrint

        # Template: AgentTicketZoom
        'Expand View' => '®i¶}',
        'Collapse View' => '§éÅ|',
        'Split' => '¤À¸Ñ',

        # Template: AgentTicketZoomArticleFilterDialog
        'Article filter settings' => 'Article ¹LÂo³]¸m',
        'Save filter settings as default' => '«O¦s¹LÂo³]¸m¬°¯Ê¬Ù­È',

        # Template: AgentWindowTab

        # Template: AJAX

        # Template: Copyright

        # Template: CustomerAccept

        # Template: CustomerCalendarSmallIcon

        # Template: CustomerError
        'Traceback' => '°l·¹',

        # Template: CustomerFooter
        'Powered by' => 'ÅX°Ê¤è',

        # Template: CustomerFooterSmall

        # Template: CustomerHeader

        # Template: CustomerHeaderSmall

        # Template: CustomerLogin
        'Login' => 'µn¿ý',
        'Lost your password?' => '§Ñ°O±K½X?',
        'Request new password' => '³]¸m·s±K½X',
        'Create Account' => '³Ð«Ø±b¤á',

        # Template: CustomerNavigationBar
        'Welcome %s' => 'Åwªï %s',

        # Template: CustomerPreferencesForm

        # Template: CustomerStatusView

        # Template: CustomerTicketMessage

        # Template: CustomerTicketPrint

        # Template: CustomerTicketSearch
        'Times' => '®É¶¡',
        'No time settings.' => 'µL®É¶¡¬ù§ô.',

        # Template: CustomerTicketSearchOpenSearchDescription

        # Template: CustomerTicketSearchResultCSV

        # Template: CustomerTicketSearchResultPrint

        # Template: CustomerTicketSearchResultShort

        # Template: CustomerTicketZoom

        # Template: CustomerWarning

        # Template: Error
        'Click here to report a bug!' => 'ÂIÀ»³o¸Ì³ø§i¤@­Ó Bug!',

        # Template: Footer
        'Top of Page' => '­¶­±³»ºÝ',

        # Template: FooterSmall

        # Template: Header
        'Home' => '',

        # Template: HeaderSmall

        # Template: Installer
        'Web-Installer' => 'WEB ¦w¸Ë¦V¾É',
        'Welcome to %s' => 'Åwªï¨Ï¥Î %s',
        'Accept license' => '¦P·N³\¥i',
        'Don\'t accept license' => '¤£¦P·N',
        'Admin-User' => 'ºÞ²z­û',
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty. For security reasons we do recommend setting a root password. For more information please refer to your database documentation.' => '¦pªG±zªº¼Æ¾Ú®w¦³³]¸m root ±K½X, ½Ð¦b³o¸Ì¿é¤J, §_«h, ½Ð«O¯dªÅ¥Õ. ¥X©ó¦w¥þ¦Ò¼{, §Ú­Ì«ØÄ³±z¬° root ³]¸m¤@­Ó±K½X, §ó¦h«H®§½Ð°Ñ¦Ò¼Æ¾Ú®wÀ°§U¤åÀÉ.',
        'Admin-Password' => 'ºÞ²z­û±K½X',
        'Database-User' => '¼Æ¾Ú®w¥Î¤á¦WºÙ',
        'default \'hot\'' => 'Àq»{±K½X \'hot\'',
        'DB connect host' => '¼Æ¾Ú³s±µ¥D¾÷',
        'Database' => '¼Æ¾Ú®w',
        'Default Charset' => '¯Ê¬Ù¦r²Å¶°',
        'utf8' => 'UTF-8',
        'false' => '°²',
        'SystemID' => '¨t²ÎID',
        '(The identify of the system. Each ticket number and each http session id starts with this number)' => '(¨t²Î¼ÐÃÑ²Å. Ticket ½s¸¹©M http ·|¸Ü³£¥H³o­Ó¼ÐÃÑ²Å¶}ÀY)',
        'System FQDN' => '¨t²Î°ì¦W',
        '(Full qualified domain name of your system)' => '(¨t²Î°ì¦W)',
        'AdminEmail' => 'ºÞ²z­û¦a§}',
        '(Email of the system admin)' => '(¨t²ÎºÞ²z­û¶l¥ó¦a§})',
        'Organization' => '²ÕÂ´',
        'Log' => '¤é§Ó',
        'LogModule' => '¤é§Ó¼Ò¶ô',
        '(Used log backend)' => '¨Ï¥Î¤é§Ó¦ZºÝ',
        'Logfile' => '¤é§Ó¤å¥ó',
        '(Logfile just needed for File-LogModule!)' => '(°¦¦³¿E¬¡ File-LogModule ®É¤~»Ý­n Logfile!)',
        'Webfrontend' => 'Web «eºÝ',
        'Use utf-8 it your database supports it!' => '¦pªG±zªº¼Æ¾Ú®w¤ä«ù¡A¨Ï¥ÎUTF-8¦r²Å½s½X!',
        'Default Language' => '¯Ê¬Ù»y¨¥',
        '(Used default language)' => '(¨Ï¥Î¯Ê¬Ù»y¨¥)',
        'CheckMXRecord' => 'ÀË¬d MX °O¿ý',
        '(Checks MX recordes of used email addresses by composing an answer. Don\'t use CheckMXRecord if your OTRS machine is behinde a dial-up line $!)' => '³q¹L¼¶¼gµª®×¨ÓÀË¬d¥Î¹Lªº¹q¤l¶l¥ó¦a§}ªºMX°O¿ý¡C±zOTRS¾÷¾¹¦b¼·¸¹±µ¤Jªº§C³tºôµ¸¸Ì¡A½Ð¤£­n¨Ï¥ÎCheckMXRecord!',
        'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' => '¬°¤F¯à°÷¨Ï¥ÎOTRS, ±z¥²¶·¥Hroot¨­¥÷¿é¤J¥H¤U¦æ¦b©R¥O¦æ¤¤(Terminal/Shell).',
        'Restart your webserver' => '½Ð­«·s±Ò°Ê±zªº webserver.',
        'After doing so your OTRS is up and running.' => '§¹¦¨¦Z¡A±z¥i¥H±Ò°Ê OTRS ¨t²Î¤F.',
        'Start page' => '¶}©l­¶­±',
        'Your OTRS Team' => '±zªº OTRS ¤p²Õ.',

        # Template: LinkObject

        # Template: Login

        # Template: Motd

        # Template: NoPermission
        'No Permission' => 'µLÅv­­',

        # Template: Notify
        'Important' => '­«­n',

        # Template: PrintFooter
        'URL' => 'ºô§}',

        # Template: PrintHeader
        'printed by' => '¥´¦L©ó',

        # Template: PublicDefault

        # Template: Redirect

        # Template: Test
        'OTRS Test Page' => 'OTRS ´ú¸Õ­¶',
        'Counter' => '­p¼Æ¾¹',

        # Template: Warning

        # Template: YUI

        # Misc
        'Edit Article' => '½s¿è«H¥ó',
        'Create Database' => '³Ð«Ø¼Æ¾Ú®w',
        'DB Host' => '¼Æ¾Ú®w¥D¾÷',
        'Ticket Number Generator' => 'Ticket ½s¸¹¥Í¦¨¾¹',
        'Create new Phone Ticket' => '³Ð«Ø·sªº¹q¸Ü Ticket',
        'Symptom' => '¯gª¬',
        'U' => '¤É§Ç',
        'Site' => '¯¸ÂI',
        'Customer history search (e. g. "ID342425").' => '·j¯Á«È¤á¾ú¥v (¨Ò¦p¡G "ID342425").',
        'Can not delete link with %s!' => '¤£¯à§R°£ %s ªº³s±µ',
        'Close!' => 'Ãö³¬!',
        'for agent firstname' => '§Þ³N¤ä«ù¤H­û ¦W',
        'No means, send agent and customer notifications on changes.' => '·í¦³§ïÅÜ®É¤£µo°e³qª¾µ¹§Þ³N¤H­û©Î«È¤á.',
        'A web calendar' => 'Web ¤é¾ú',
        'to get the realname of the sender (if given)' => '¶l¥óµo°e¤Hªº¯u¹ê©m¦W (¦pªG¦s¦b)',
        'OTRS DB Name' => '¼Æ¾Ú®w¦WºÙ',
        'Notification (Customer)' => '',
        'Select Source (for add)' => '¿ï¾Ü¼Æ¾Ú·½(¼W¥[¥\¯à¨Ï¥Î)',
        'Options of the ticket data (e. g. <OTRS_TICKET_Number>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' => '',
        'Child-Object' => '¤l¹ï¶H',
        'Days' => '¤Ñ',
        'Queue ID' => '¶¤¦C½s¸¹',
        'Config options (e. g. <OTRS_CONFIG_HttpType>)' => '°t¸m¿ï¶µ (¨Ò¦p:<OTRS_CONFIG_HttpType>)',
        'System History' => '¨t²Î¾ú¥v',
        'customer realname' => '«È¤á¯u¹ê©m¦W',
        'Pending messages' => '®ø®§Âà¤Jµ¥«Ýª¬ºA',
        'for agent login' => '§Þ³N¤ä«ù¤H­û µn¿ý¦W',
        'Keyword' => 'ÃöÁä¦r',
        'Close type' => 'Ãö³¬Ãþ«¬',
        'DB Admin User' => '¼Æ¾Ú®wºÞ²z­û¥Î¤á¦W',
        'for agent user id' => '§Þ³N¤ä«ù¤H­û ¥Î¤á¦W',
        'Change user <-> group settings' => '­×§ï ¥Î¤á <-> ²Õ ³]¸m',
        'Problem' => '°ÝÃD',
        'Escalation' => '½Õ¾ã',
        '"}' => '',
        'Order' => '¦¸§Ç',
        'next step' => '¤U¤@¨B',
        'Follow up' => '¸ò¶i',
        'Customer history search' => '«È¤á¾ú¥v·j¯Á',
        'PostMaster Mail Account' => '¶l¥ó±b¸¹ºÞ²z',
        'Stat#' => '',
        'Create new database' => '³Ð«Ø·sªº¼Æ¾Ú®w',
        'Keywords' => 'ÃöÁä¦r',
        'Ticket Escalation View' => '½Õ¾ã¬d¬Ý Ticket',
        'Today' => '¤µ¤Ñ',
        'No * possible!' => '¤£¥i¨Ï¥Î³q°t²Å "*" !',
        'Load' => '¥[¸ü',
        'PostMaster Filter' => '¶l¥ó¤º®e¹LÂo',
        'Options of the current user who requested this action (e. g. <OTRS_CURRENT_USERFIRSTNAME>)' => '',
        'Message for new Owner' => 'µ¹©Ò¦³ªÌªº®ø®§',
        'to get the first 5 lines of the email' => '¶l¥ó¥¿¤å«e5¦æ',
        'Sort by' => '±Æ§Ç',
        'OTRS DB Password' => 'OTRS ¥Î¤á±K½X',
        'Last update' => '³Ì¦Z§ó·s©ó',
        'Tomorrow' => '©ú¤Ñ',
        'not rated' => '¤£¤©µû¯Å',
        'to get the first 20 character of the subject' => '¶l¥ó¼ÐÃD«e20­Ó¦r²Å',
        'Select the customeruser:service relations.' => '',
        'DB Admin Password' => '¼Æ¾Ú¨t²ÎºÞ²z­û±K½X',
        'Drop Database' => '§R°£¼Æ¾Ú®w',
        'Here you can define the x-axis. You can select one element via the radio button. Then you you have to select two or more attributes of the element. If you make no selection all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' => '¦b³o¸Ì¡A±z¥i¥H©w¸qx¶b¡C±z¥i¥H¿ï¾Üªº¤@­Ó¦]¯À³q¹L³æ¿ï«ö¶s¡CµM¦Z¡A§A¥²¶·¿ï¾Ü¸Ó¤¸¯À¨â­Ó©Î¨â­Ó¥H¤WªºÄÝ©Ê¡C¦pªG±z¤£¿ï¾Ü¥ô¦óÄÝ©Ê, ¨º»ò·í±z¥Í¦¨¤@­Ó²Î­pªº®É­Ô©Ò¦³¤¸¯ÀªºÄÝ©Ê±N³Q¨Ï¥Î¡C¨Ã¥B¤@­Ó·sªºÄÝ©Ê³Q§ó·s¨ì¤W¦¸°t¸m¤¤',
        'FileManager' => '¤å¥óºÞ²z¾¹',
        'Options of the current customer user data (e. g. <OTRS_CUSTOMER_DATA_UserFirstname>)' => '·í«e«È¤á¥Î¤á«H®§ (¨Ò¦p: <OTRS_CUSTOMER_DATA_UserFirstname>)',
        'Pending type' => '«Ý³B²zÃþ«¬',
        'Comment (internal)' => 'ª`ÄÀ (¤º³¡)',
        'Ticket owner options (e. g. <OTRS_OWNER_USERFIRSTNAME>)' => '¥i¥Îªº Ticket ÂkÄÝ¤H«H®§ (¨Ò¦p: <OTRS_OWNER_USERFIRSTNAME>)',
        'Options of the ticket data (e. g. <OTRS_TICKET_Number>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' => '¥i¥Îªº¦³Ãö Ticket «H®§ (¨Ò¦p: <OTRS_TICKET_Number>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)',
        '(Used ticket number format)' => '(¨Ï¥Î Ticket ½s¸¹®æ¦¡)',
        'Reminder' => '´£¿ô',
        'OTRS DB connect host' => 'OTRS ¼Æ¾Ú®w¥D¾÷',
        'All Agent variables.' => '©Ò¦³ªº§Þ³N¤H­ûÅÜ¶q',
        ' (work units)' => '¤u§@³æ¤¸',
        'Next Week' => '¤U©P',
        'All Customer variables like defined in config option CustomerUser.' => '©Ò¦³«È¤áÅÜ¶q¥i¥H¦b°t¸m¿ï¶µCustomerUser¤¤©w¸q',
        'for agent lastname' => '§Þ³N¤ä«ù¤H­û ¦W',
        'Options of the current user who requested this action (e. g. <OTRS_CURRENT_UserFirstname>)' => '°Ê§@½Ð¨DªÌ«H®§ (¨Ò¦p: <OTRS_CURRENT_UserFirstname>)',
        'Reminder messages' => '®ø®§´£¿ô',
        'Parent-Object' => '¤÷¹ï¶H',
        'Of couse this feature will take some system performance it self!' => '·íµM, ¸Ó¥\¯à·|¦û¥Î¤@©wªº¨t²Î¸ê·½, ¥[­«¨t²Îªº­t¾á!',
        'Detail' => '²Ó¸`',
        'Your own Ticket' => '±z¦Û¤vªº Ticket',
        'TicketZoom' => 'Ticket ®i¶}',
        'Don\'t forget to add a new user to groups!' => '¤£­n§Ñ°O¼W¥[·sªº¥Î¤á¨ì²Õ!',
        'Open Tickets' => '¶}©ñ Tickets',
        'General Catalog' => 'Á`¥Ø¿ý',
        'CreateTicket' => '³Ð«Ø Ticket',
        'You have to select two or more attributes from the select field!' => '§A¥²¶·±q©Ò¿ï¦r¬q¤¤¿ï¾Ü¨â­Ó©Î¨â­Ó¥H¤WªºÄÝ©Ê',
        'System Settings' => '¼Æ¾Ú®w³]¸m ',
        'Finished' => '§¹¦¨',
        'D' => '­°§Ç',
        'All messages' => '©Ò¦³®ø®§',
        'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' => '',
        'Object already linked as %s.' => '¹ï¶H¤w³s±µ¨ì %s.',
        'A article should have a title!' => '¤å³¹¥²¶·¦³¼ÐÃD!',
        'Customer Users <-> Services' => '«È¤á±b¸¹ <-> ªA°ÈºÞ²z',
        'Config options (e. g. <OTRS_CONFIG_HttpType>)' => '°t¸m¿ï¶µ (¨Ò¦p: <OTRS_CONFIG_HttpType>)',
        'All email addresses get excluded on replaying on composing and email.' => '©Ò¦³³Q¨ú®ø¼¶¼g¶l¥ó¥\¯àªº¶l¥ó¦a§}',
        'A web mail client' => 'WebMail «È¤áºÝ',
        'Compose Follow up' => '¼¶¼g¸òÂÜµª´_',
        'WebMail' => 'WebMail',
        'Ticket owner options (e. g. <OTRS_OWNER_UserFirstname>)' => 'Ticket ©Ò¦³ªÌ¿ï¶µ (¨Ò¦p: <OTRS_OWNER_UserFirstname>)',
        'DB Type' => '¼Æ¾Ú®wÃþ«¬',
        'kill all sessions' => '¤¤¤î©Ò¦³·|¸Ü',
        'to get the from line of the email' => '¶l¥ó¨Ó¦Û',
        'Solution' => '¸Ñ¨M¤è®×',
        'QueueView' => '¶¤¦Cµø¹Ï',
        'My Queue' => '§Úªº¶¤¦C',
        'Select Box' => '¿ï¾Ü¤è®Ø',
        'New messages' => '·s®ø®§',
        'Can not create link with %s!' => '¤£¯à¬° %s ³Ð«Ø³s±µ',
        'Linked as' => '¤w³s±µ¬°',
        'modified' => '­×§ï©ó',
        'Delete old database' => '§R°£ÂÂ¼Æ¾Ú®w',
        'A web file manager' => 'Web ¤å¥óºÞ²z¾¹',
        'Have a lot of fun!' => 'Have a lot of fun!',
        'send' => 'µo°e',
        'QuickSearch' => '§Ö³t·j¯Á',
        'Send no notifications' => '¤£µo°e³qª¾',
        'Note Text' => 'ª`¸Ñ',
        'POP3 Account Management' => 'POP3 ±b¤áºÞ²z',
        'Options of the current customer user data (e. g. <OTRS_CUSTOMER_DATA_USERFIRSTNAME>)' => '',
        'System State Management' => '¨t²Îª¬ºAºÞ²z',
        'OTRS DB User' => 'OTRS ¼Æ¾Ú®w¥Î¤á¦W',
        'Mailbox' => '¶l½c',
        'PhoneView' => '¹q¸Üµø¹Ï',
        'maximal period form' => '³Ì¤j©P´Áªí',
        'Escaladed Tickets' => '',
        'Yes means, send no agent and customer notifications on changes.' => '·í¦³§ïÅÜ®É¤£µo°e³qª¾µ¹§Þ³N¤H­û©Î«È¤á.',
        'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further information.' => '±zªº¶l¥ó ½s¸¹: "<OTRS_TICKET>" ¦^°h¨ì "<OTRS_BOUNCE_TO>" . ½ÐÁp¨t¥H¤U¦a§}Àò¨ú¸Ô²Ó«H®§.',
        'Ticket Status View' => 'Ticket ª¬ºAµø¹Ï',
        'Modified' => '­×§ï©ó',
        'Ticket selected for bulk action!' => '³Q¿ï¤¤¶i¦æ§å¶q¾Þ§@ªº Tickets',
        '%s is not writable!' => '',
        'Cannot create %s!' => '',
    };
    # $$STOP$$
    return;
}

1;
