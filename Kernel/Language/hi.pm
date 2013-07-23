# --
# Kernel/Language/hi.pm - provides Hindi language translation
# Copyright (C) 2011 O.P.S <sales at OptForOPS.com>
# Copyright (C) 2011 Chetan Nagaonkar <Chetan_Nagaonkar at OptForOPS.com>
# Copyright (C) 2011 Chetan Nagaonkar <ChetanNagaonkar at yahoo.com>
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::hi;

use strict;
use warnings;

sub Data {
    my $Self = shift;

    # $$START$$
    # Last translation file sync: 2013-06-14 08:49:32

    # possible charsets
    $Self->{Charset} = ['utf-8', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Year;)
    $Self->{DateFormat}          = '%D/%M/%Y - %T';
    $Self->{DateFormatLong}      = '%A, %D %B %Y - %T';
    $Self->{DateFormatShort}     = '%D/%M/%Y';
    $Self->{DateInputFormat}     = '%D/%M/%Y';
    $Self->{DateInputFormatLong} = '%D/%M/%Y - %T';

    # csv separator
    $Self->{Separator} = ';';

    $Self->{Translation} = {

        # Template: AAABase
        'Yes' => 'हाँ',
        'No' => 'नहीं',
        'yes' => 'हाँ',
        'no' => 'नहीं',
        'Off' => 'बंद',
        'off' => 'बंद',
        'On' => 'चालू करें',
        'on' => 'चालू करें',
        'top' => 'ऊपर',
        'end' => 'समाप्त',
        'Done' => 'किया',
        'Cancel' => 'रद्द',
        'Reset' => 'पुनर्स्थापित',
        'last' => 'पिछला',
        'before' => 'से पहले',
        'Today' => 'आज',
        'Tomorrow' => 'कल',
        'Next week' => '',
        'day' => 'दिन',
        'days' => 'दिनों',
        'day(s)' => 'दिनों',
        'd' => 'डी',
        'hour' => 'घंटा',
        'hours' => 'घंटे',
        'hour(s)' => 'घंटे',
        'Hours' => 'घंटे',
        'h' => 'एच',
        'minute' => 'मिनट',
        'minutes' => 'मिनटों',
        'minute(s)' => 'मिनटों',
        'Minutes' => 'मिनटों',
        'm' => 'म',
        'month' => 'महीना',
        'months' => 'महीने',
        'month(s)' => 'महीने',
        'week' => 'हफ़्ता',
        'week(s)' => 'हफ्ते',
        'year' => 'वर्ष',
        'years' => 'वर्षों',
        'year(s)' => 'वर्षों',
        'second(s)' => 'सेकंड',
        'seconds' => 'सेकंड',
        'second' => 'सेकंड',
        's' => 'एस',
        'wrote' => 'लिखा',
        'Message' => 'संदेश',
        'Error' => 'त्रुटि',
        'Bug Report' => 'बग रिपोर्ट',
        'Attention' => 'ध्यान दें',
        'Warning' => 'चेतावनी',
        'Module' => 'मॉड्यूल',
        'Modulefile' => 'मॉड्यूल संचिका',
        'Subfunction' => 'सब फ़ंक्शन',
        'Line' => 'रेखा',
        'Setting' => 'सेटिंग',
        'Settings' => 'सेटिंग्स',
        'Example' => 'उदाहरण',
        'Examples' => 'उदाहरणों',
        'valid' => 'वैध',
        'Valid' => 'वैध',
        'invalid' => 'अवैध',
        'Invalid' => '',
        '* invalid' => '* अवैध',
        'invalid-temporarily' => 'अवैध-अस्थायी रूप',
        ' 2 minutes' => ' 2 मिनट',
        ' 5 minutes' => ' 5 मिनट',
        ' 7 minutes' => ' 7 मिनट',
        '10 minutes' => '10 मिनट',
        '15 minutes' => '15 मिनट',
        'Mr.' => 'श्रीमान',
        'Mrs.' => 'श्रीमती',
        'Next' => 'अगला',
        'Back' => 'वापस',
        'Next...' => 'अगला...',
        '...Back' => '...वापस',
        '-none-' => '-कोई नहीं-',
        'none' => 'कोई नहीं',
        'none!' => 'कोई नहीं',
        'none - answered' => 'कोई  - जवाब नहीं',
        'please do not edit!' => 'कृपया संपादित मत कीजिए',
        'Need Action' => 'कार्रवाई की आवश्यकता',
        'AddLink' => 'कड़ी जोड़ें',
        'Link' => 'कड़ी',
        'Unlink' => 'अनलिंक करें',
        'Linked' => 'लिंक किए गए',
        'Link (Normal)' => 'कड़ी (सामान्य)',
        'Link (Parent)' => 'कड़ी (अभिभावक)',
        'Link (Child)' => 'कड़ी (संतान)',
        'Normal' => 'सामान्य',
        'Parent' => 'अभिभावक',
        'Child' => 'संतान',
        'Hit' => 'हिट',
        'Hits' => 'हिट्स',
        'Text' => 'पूर्ण पाठ',
        'Standard' => 'मानक',
        'Lite' => 'लाइट',
        'User' => 'उपयोगकर्ता',
        'Username' => 'उपयोगकर्ता का नाम',
        'Language' => 'भाषा',
        'Languages' => 'भाषाएँ',
        'Password' => 'कूटशब्द',
        'Preferences' => 'वरीयताएं',
        'Salutation' => 'अभिवादन',
        'Salutations' => 'अभिवादन',
        'Signature' => 'हस्ताक्षर',
        'Signatures' => 'हस्ताक्षर',
        'Customer' => 'ग्राहक',
        'CustomerID' => 'ग्राहक ID',
        'CustomerIDs' => 'ग्राहक IDs',
        'customer' => 'ग्राहक',
        'agent' => 'प्रतिनिधि',
        'system' => 'प्रणाली',
        'Customer Info' => 'ग्राहक की जानकारी',
        'Customer Information' => 'ग्राहक की जानकारी',
        'Customer Company' => 'ग्राहक की कंपनी',
        'Customer Companies' => 'ग्राहक की कंपनियां',
        'Company' => 'कंपनी',
        'go!' => 'आगे जाना',
        'go' => 'आगे जाना',
        'All' => 'सभी',
        'all' => 'सभी',
        'Sorry' => 'क्षमा करें',
        'update!' => 'अद्यतनीकरण',
        'update' => 'अद्यतनीकरण',
        'Update' => 'अद्यतनीकरण',
        'Updated!' => 'अद्यतनीकरण',
        'submit!' => 'यहॉ जमा करे',
        'submit' => 'यहॉ जमा करे',
        'Submit' => 'यहॉ जमा करे',
        'change!' => 'बदलना',
        'Change' => 'बदलना',
        'change' => 'बदलना',
        'click here' => 'यहाँ दबाऐ',
        'Comment' => 'टिप्पणी',
        'Invalid Option!' => 'अवैध विकल्प',
        'Invalid time!' => 'अवैध समय',
        'Invalid date!' => 'अवैध दिनांक',
        'Name' => 'नाम',
        'Group' => 'समूह',
        'Description' => 'विवरण',
        'description' => 'विवरण',
        'Theme' => 'थीम',
        'Created' => 'बनाया',
        'Created by' => 'द्वारा बनाया गया',
        'Changed' => 'बदल गया',
        'Changed by' => 'से बदला',
        'Search' => 'खोजें',
        'and' => 'और',
        'between' => 'बीच में',
        'Fulltext Search' => 'पूर्ण पाठ खोजें',
        'Data' => 'आंकड़ा',
        'Options' => 'विकल्प',
        'Title' => 'शीर्षक',
        'Item' => 'वस्तु',
        'Delete' => 'हटाएँ',
        'Edit' => 'संपादित करें',
        'View' => 'देखें',
        'Number' => 'संख्या',
        'System' => 'प्रणाली',
        'Contact' => 'संपर्क',
        'Contacts' => 'संपर्क',
        'Export' => 'निर्यात',
        'Up' => 'ऊपर',
        'Down' => 'नीचे',
        'Add' => 'जोड़ें',
        'Added!' => 'जोड़ा गया',
        'Category' => 'वर्ग',
        'Viewer' => 'दर्शक',
        'Expand' => 'विस्तार',
        'Small' => 'लघु',
        'Medium' => 'मध्यम',
        'Large' => 'बड़ा',
        'Date picker' => 'दिनांक चयनकर्ता',
        'New message' => 'नया संदेश',
        'New message!' => 'नया संदेश',
        'Please answer this ticket(s) to get back to the normal queue view!' =>
            'इस टिकट को सामान्य श्रेणी में देखने के लिए जवाब दे ।',
        'You have %s new message(s)!' => 'आपके पास %s नए संदेश है ।',
        'You have %s reminder ticket(s)!' => 'आपके पास %s अनुस्मारक टिकट है ।',
        'The recommended charset for your language is %s!' => 'आपकी भाषा के लिए अनुशंसित चारसेट %s है ।',
        'Change your password.' => 'अपना कूटशब्द बदलें ।',
        'Please activate %s first!' => 'कृपया पहले %s को सक्रिय करें ।',
        'No suggestions' => 'कोई सुझाव नहीं है',
        'Word' => 'शब्द',
        'Ignore' => 'ध्यान न दें',
        'replace with' => 'के साथ बदलें',
        'There is no account with that login name.' => 'इस लॉग इन नाम से कोई खाता नहीं है।',
        'Login failed! Your user name or password was entered incorrectly.' =>
            'प्रवेश असफल। आपका उपयोगकर्ता नाम या कूटशब्द गलत प्रविष्ट किया गया था।',
        'There is no acount with that user name.' => 'ऐसे उपयोगकर्ता नाम के साथ कोई खाता नहीं है।',
        'Please contact your administrator' => 'कृपया अपने प्रशासक से संपर्क करें।',
        'Logout' => 'बाहर प्रवेश करें',
        'Logout successful. Thank you for using %s!' => '',
        'Feature not active!' => 'सुविधा सक्रिय नहीं है।',
        'Agent updated!' => 'प्रतिनिधि अद्यतन।',
        'Create Database' => 'आंकड़ाकोष बनाएँ',
        'System Settings' => 'प्रणाली व्यवस्थाऐं',
        'Mail Configuration' => 'डाक विन्यास',
        'Finished' => 'समाप्त',
        'Install OTRS' => '',
        'Intro' => '',
        'License' => 'स्वच्छंदता',
        'Database' => 'आंकड़ाकोष',
        'Configure Mail' => '',
        'Database deleted.' => '',
        'Database setup successful!' => '',
        'Generated password' => '',
        'Login is needed!' => 'प्रवेश आवश्यक है।',
        'Password is needed!' => 'कूटशब्द आवश्यक है।',
        'Take this Customer' => 'यह ग्राहक लें।',
        'Take this User' => 'यह उपयोगकर्ता लें।',
        'possible' => 'संभव है',
        'reject' => 'अस्वीकार',
        'reverse' => 'उलटा',
        'Facility' => 'सहूलियत',
        'Time Zone' => 'समय क्षेत्र',
        'Pending till' => 'स्थगित जब तक',
        'Don\'t use the Superuser account to work with OTRS! Create new Agents and work with these accounts instead.' =>
            '',
        'Dispatching by email To: field.' => 'ईमेल से भेजने के लिए :क्षेत्र',
        'Dispatching by selected Queue.' => 'चयनित श्रेणी से भेजने के लिए।',
        'No entry found!' => 'कोई प्रविष्टि नहीं है।',
        'Session invalid. Please log in again.' => '',
        'Session has timed out. Please log in again.' => 'सत्र का समय समाप्त हो गया है। कृपया फिर से प्रवेश करें।',
        'Session limit reached! Please try again later.' => '',
        'No Permission!' => 'अनुमति नहीं है।',
        '(Click here to add)' => '(जोड़ने के लिए यहाँ दबाऐ।)',
        'Preview' => 'पूर्वावलोकन',
        'Package not correctly deployed! Please reinstall the package.' =>
            '',
        '%s is not writable!' => '%s लिखने योग्य नहीं है।',
        'Cannot create %s!' => '%s नहीं बन सकता।',
        'Check to activate this date' => '',
        'You have Out of Office enabled, would you like to disable it?' =>
            '',
        'Customer %s added' => 'ग्राहक %s जोड़ा गया। ',
        'Role added!' => 'भूमिका जोडी गयी।',
        'Role updated!' => 'भूमिका अद्यतन।',
        'Attachment added!' => 'संलग्नक जोड़ा गया।',
        'Attachment updated!' => 'संलग्नक अद्यतन।',
        'Response added!' => 'प्रतिक्रिया जोडी गयी।',
        'Response updated!' => 'प्रतिक्रिया अद्यतन।',
        'Group updated!' => 'समूह अद्यतन।',
        'Queue added!' => 'श्रेणी जोडी गयी।',
        'Queue updated!' => 'श्रेणी अद्यतन।',
        'State added!' => 'अवस्था जोडी गयी।',
        'State updated!' => 'अवस्था अद्यतन।',
        'Type added!' => 'प्रकार जोड़ा गया।',
        'Type updated!' => 'प्रकार अद्यतन।',
        'Customer updated!' => 'ग्राहक अद्यतन। ',
        'Customer company added!' => '',
        'Customer company updated!' => '',
        'Mail account added!' => '',
        'Mail account updated!' => '',
        'System e-mail address added!' => '',
        'System e-mail address updated!' => '',
        'Contract' => 'अनुबंध',
        'Online Customer: %s' => 'ऑनलाइन ग्राहक: %s',
        'Online Agent: %s' => 'ऑनलाइन प्रतिनिधि: %s',
        'Calendar' => 'पंचांग',
        'File' => 'संचिका',
        'Filename' => 'संचिका का नाम',
        'Type' => 'प्रकार',
        'Size' => 'आकार',
        'Upload' => 'अपलोड',
        'Directory' => 'निर्देशिका',
        'Signed' => 'हस्ताक्षरित',
        'Sign' => 'संकेत',
        'Crypted' => 'क्रिप्टटेड',
        'Crypt' => 'क्रिप्ट',
        'PGP' => 'PGP',
        'PGP Key' => 'PGP कुंजी',
        'PGP Keys' => 'PGP कुंजियाँ',
        'S/MIME' => 'S/MIME',
        'S/MIME Certificate' => 'S/MIME प्रमाणपत्र',
        'S/MIME Certificates' => 'S/MIME प्रमाणपत्रों',
        'Office' => 'कार्यालय',
        'Phone' => 'फोन',
        'Fax' => 'फैक्स',
        'Mobile' => 'मोबाइल',
        'Zip' => 'ज़िप',
        'City' => 'शहर',
        'Street' => 'मार्ग',
        'Country' => 'देश',
        'Location' => 'स्थान',
        'installed' => 'स्थापित',
        'uninstalled' => 'स्थापना रद्द',
        'Security Note: You should activate %s because application is already running!' =>
            'सुरक्षा टिप्पणी: आपको  %s सक्रिय कराना होगा क्योंकि अनुप्रयोग पहले से चल रहा हैं।',
        'Unable to parse repository index document.' => 'संग्रह सूचकांक दस्तावेज़ की व्याख्या करने में असमर्थ।',
        'No packages for your framework version found in this repository, it only contains packages for other framework versions.' =>
            'आपकी रूपरेखा संस्करण के लिए कोई संकुल इस संग्रह में नहीं मिला,इसके केवल दूसरे रूपरेखा संस्करणों के लिए संकुल शामिल हैं।',
        'No packages, or no new packages, found in selected repository.' =>
            'कोई संकुल,या कोई नया संकुल,चयनित संग्रह में नहीं मिला हैं।',
        'Edit the system configuration settings.' => 'प्रणाली विन्यास व्यवस्थाऐं संपादित करें।',
        'printed at' => 'पर मुद्रित',
        'Loading...' => 'लोड हो रहा है।',
        'Dear Mr. %s,' => 'प्रिय श्रीमान %s,',
        'Dear Mrs. %s,' => 'प्रिय श्रीमती %s,',
        'Dear %s,' => 'प्रिय %s,',
        'Hello %s,' => 'नमस्कार %s,',
        'This email address already exists. Please log in or reset your password.' =>
            'यह ईमेल पता पहले से मौजूद है। प्रवेश करें या अपने कूटशब्द को पुनर्स्थापित करें।',
        'New account created. Sent login information to %s. Please check your email.' =>
            'नया खाता बन गया। प्रवेश करने की जानकारी %s को भेजी। कृपया अपना ईमेल देखें।',
        'Please press Back and try again.' => 'कृपया वापस जाएँ और फिर प्रयास करें।',
        'Sent password reset instructions. Please check your email.' => 'कूटशब्द पुनर्स्थापित निर्देशों को भेज दियॆ। कृपया अपना ईमेल देखें।',
        'Sent new password to %s. Please check your email.' => 'नये कूटशब्द की जानकारी %s को भेजी। कृपया अपना ईमेल देखें।',
        'Upcoming Events' => 'आगामी कार्यक्रम',
        'Event' => 'कार्यक्रम',
        'Events' => 'कार्यक्रम',
        'Invalid Token!' => 'अवैध टोकन',
        'more' => 'अधिक',
        'Collapse' => 'संक्षिप्त करें',
        'Shown' => 'दिखाए',
        'Shown customer users' => '',
        'News' => 'समाचार',
        'Product News' => 'उत्पाद समाचार',
        'OTRS News' => 'OTRS समाचार',
        '7 Day Stats' => '7 दिन के आँकड़े',
        'Process Management information from database is not in sync with the system configuration, please synchronize all processes.' =>
            '',
        'Package not verified by the OTRS Group! It is recommended not to use this package.' =>
            '',
        '<br>If you continue to install this package, the following issues may occur!<br><br>&nbsp;-Security problems<br>&nbsp;-Stability problems<br>&nbsp;-Performance problems<br><br>Please note that issues that are caused by working with this package are not covered by OTRS service contracts!<br><br>' =>
            '',
        'Bold' => 'गहरा ',
        'Italic' => 'इटैलिक ',
        'Underline' => 'रेखांकित करना',
        'Font Color' => 'लिपि रंग',
        'Background Color' => 'पृष्ठभूमि रंग',
        'Remove Formatting' => 'स्वरूपण हटाएँ',
        'Show/Hide Hidden Elements' => 'दिखाएँ /छिपाएँ छिपे हुए तत्वों को',
        'Align Left' => 'बाएँ संरेखित करें',
        'Align Center' => 'मध्य में समंजित करें',
        'Align Right' => 'दाएँ संरेखित करें',
        'Justify' => 'औचित्य',
        'Header' => 'शीर्षक',
        'Indent' => 'मांगपत्र',
        'Outdent' => 'आउटडेंट',
        'Create an Unordered List' => 'एक बिना क्रम वाली सूची बनाएँ।',
        'Create an Ordered List' => 'क्रमांकित सूची बनाएँ।',
        'HTML Link' => 'HTML कड़ी',
        'Insert Image' => 'छवि डालें',
        'CTRL' => 'CTRL',
        'SHIFT' => 'SHIFT',
        'Undo' => 'पूर्ववत्',
        'Redo' => 'फिर से करना',
        'Scheduler process is registered but might not be running.' => '',
        'Scheduler is not running.' => '',

        # Template: AAACalendar
        'New Year\'s Day' => '',
        'International Workers\' Day' => '',
        'Christmas Eve' => '',
        'First Christmas Day' => '',
        'Second Christmas Day' => '',
        'New Year\'s Eve' => '',

        # Template: AAAGenericInterface
        'OTRS as requester' => '',
        'OTRS as provider' => '',
        'Webservice "%s" created!' => '',
        'Webservice "%s" updated!' => '',

        # Template: AAAMonth
        'Jan' => 'जनवरी',
        'Feb' => 'फ़रवरी',
        'Mar' => 'मार्च',
        'Apr' => 'अप्रैल',
        'May' => 'मई',
        'Jun' => 'जून',
        'Jul' => 'जुलाई',
        'Aug' => 'अगस्त',
        'Sep' => 'सितम्बर',
        'Oct' => 'अक्टूबर',
        'Nov' => 'नवम्बर',
        'Dec' => 'दिसम्बर',
        'January' => 'जनवरी',
        'February' => 'फ़रवरी',
        'March' => 'मार्च',
        'April' => 'अप्रैल',
        'May_long' => 'मई',
        'June' => 'जून',
        'July' => 'जुलाई',
        'August' => 'अगस्त',
        'September' => 'सितम्बर',
        'October' => 'अक्टूबर',
        'November' => 'नवम्बर',
        'December' => 'दिसम्बर',

        # Template: AAAPreferences
        'Preferences updated successfully!' => 'वरीयताएं सफलतापूर्वक अद्यतन।',
        'User Profile' => 'उपयोगकर्ता रूपरेखा',
        'Email Settings' => 'ईमेल व्यवस्थाऐं',
        'Other Settings' => 'अन्य व्यवस्थाऐं',
        'Change Password' => 'कूटशब्द बदलें',
        'Current password' => 'वर्तमान कूटशब्द',
        'New password' => 'नया कूटशब्द',
        'Verify password' => 'कूटशब्द सत्यापित करें',
        'Spelling Dictionary' => 'वर्तनी शब्दकोश',
        'Default spelling dictionary' => 'तयशुदा वर्तनी शब्दकोश',
        'Max. shown Tickets a page in Overview.' => 'अवलोकन में पृष्ठ पर दिखाऐ गयॆ अधिकतम टिकट।',
        'The current password is not correct. Please try again!' => 'वर्तमान कूटशब्द सही नहीं है। कृपया पुनः प्रयास करें।',
        'Can\'t update password, your new passwords do not match. Please try again!' =>
            'कूटशब्द अद्यतन नहीं किया जा सकता,आपका नया कूटशब्द मेल नहीं खाता है,कृपया पुनः प्रयास करें।',
        'Can\'t update password, it contains invalid characters!' => 'कूटशब्द अद्यतन नहीं किया जा सकता,इसमें अमान्य वर्ण हैं।',
        'Can\'t update password, it must be at least %s characters long!' =>
            'कूटशब्द अद्यतन नहीं किया जा सकता,यह कम से कम %s वर्ण लंबा होना चाहिए।',
        'Can\'t update password, it must contain at least 2 lowercase and 2 uppercase characters!' =>
            'कूटशब्द अद्यतन नहीं किया जा सकता,इसमें कम से कम 2 लोअरकेस और 2 अपरकेस वर्ण होने चाहिए।',
        'Can\'t update password, it must contain at least 1 digit!' => 'कूटशब्द अद्यतन नहीं किया जा सकता,इसमें कम से कम 1 अंक होना चाहिए।',
        'Can\'t update password, it must contain at least 2 characters!' =>
            'कूटशब्द अद्यतन नहीं किया जा सकता,इसमें कम से कम 2 वर्ण शामिल होने चाहिए।',
        'Can\'t update password, this password has already been used. Please choose a new one!' =>
            'कूटशब्द अद्यतन नहीं किया जा सकता,यह कूटशब्द पहले से ही उपयोग में हैं।',
        'Select the separator character used in CSV files (stats and searches). If you don\'t select a separator here, the default separator for your language will be used.' =>
            'CSV संचिका (आँकड़े और खोजों) में उपयोग कियॆ जानॆवालॆ विभाजक वर्ण को चुनें। यदि आप यहाँ एक विभाजक चयन नहीं करते हैं, तो आपकी भाषा के लिए तयशुदा विभाजक का उपयोग किया जाएगा।',
        'CSV Separator' => 'CSV विभाजक',

        # Template: AAAStats
        'Stat' => 'आँकड़े',
        'Sum' => 'योग',
        'Please fill out the required fields!' => 'कृपया आवश्यक क्षेत्र भरें।',
        'Please select a file!' => 'कृपया कोई संचिका चुनें।',
        'Please select an object!' => 'कृपया किसी वस्तु को चुनें।',
        'Please select a graph size!' => 'कृपया एक रेखा-चित्र का आकार चुनें।',
        'Please select one element for the X-axis!' => 'कृपया X-अक्ष के लिए एक तत्व चुनें।',
        'Please select only one element or turn off the button \'Fixed\' where the select field is marked!' =>
            'कृपया केवल एक ही तत्व का चयन करें या बटन बंद करें  \'निश्चित\' जहां चयन क्षेत्र चिह्नित हैं।',
        'If you use a checkbox you have to select some attributes of the select field!' =>
            'यदि आप निशानबक्से का उपयोग करें तो आपको चयन क्षेत्र की कुछ विशेषताओं चयन करना होगा।',
        'Please insert a value in the selected input field or turn off the \'Fixed\' checkbox!' =>
            'कृपया आगत क्षेत्र में कोई मान डालें अथवा \'निश्चित\' निशानबक्से बटन बंद करें ।',
        'The selected end time is before the start time!' => 'चयनित अंत समय आरंभ समय से पहले हैं।',
        'You have to select one or more attributes from the select field!' =>
            'आपको चयन क्षेत्र से एक या अधिक विशेषताओं का चयन करना होगा।',
        'The selected Date isn\'t valid!' => 'चयनित दिनांक वैध नहीं है।',
        'Please select only one or two elements via the checkbox!' => 'कृपया निशानबक्से के माध्यम से केवल एक या दो तत्वों का ही चयन करें।',
        'If you use a time scale element you can only select one element!' =>
            'यदि आप समय पैमाने तत्व का उपयोग करेंगे तो आप केवल एक ही तत्व चुन सकते हैं।',
        'You have an error in your time selection!' => 'आपके समय के चुनाव में त्रुटि है।',
        'Your reporting time interval is too small, please use a larger time scale!' =>
            'आपका रिपोर्टिंग समयांतराल बहुत कम है,कृपया बड़ा समयांतराल चुने।',
        'The selected start time is before the allowed start time!' => 'चयनित प्रारंभ समय अनुमति प्रारंभ समय से पहले होता है।',
        'The selected end time is after the allowed end time!' => 'चयनित अंत समय अनुमति अंत समय के बाद होता है।',
        'The selected time period is larger than the allowed time period!' =>
            'चयनित समय अवधि अनुमति समय अवधि से बड़ा होता है।',
        'Common Specification' => 'सामान्य विशिष्टता',
        'X-axis' => 'X-अक्ष',
        'Value Series' => 'मान श्रृंखला',
        'Restrictions' => 'प्रतिबंध',
        'graph-lines' => 'रेखाचित्र-रेखाएं',
        'graph-bars' => 'रेखाचित्र-बार',
        'graph-hbars' => 'रेखाचित्र-hbars',
        'graph-points' => 'रेखाचित्र-बिन्दु',
        'graph-lines-points' => 'रेखाचित्र-रेखाएं-बिन्दु',
        'graph-area' => 'रेखाचित्र-क्षेत्र',
        'graph-pie' => 'रेखाचित्र-पाई',
        'extended' => 'विस्तृत',
        'Agent/Owner' => 'प्रतिनिधि/स्वामी',
        'Created by Agent/Owner' => 'प्रतिनिधि/स्वामी के द्वारा बनाया गया',
        'Created Priority' => 'प्राथमिकता बनाई गई',
        'Created State' => 'अवस्था बनाया गया',
        'Create Time' => 'समय बनाएँ',
        'CustomerUserLogin' => 'ग्राहक प्रयोक्ता प्रवेश',
        'Close Time' => 'बंद होने का समय',
        'TicketAccumulation' => 'टिकटसंचय',
        'Attributes to be printed' => 'विशेषताएँ मुद्रित करने के लिए',
        'Sort sequence' => 'क्रमबद्ध श्रृंखला',
        'Order by' => 'के आदेश से',
        'Limit' => 'सीमा',
        'Ticketlist' => 'टिकट सूची',
        'ascending' => 'बढ़ते हुए',
        'descending' => 'घटते हुए',
        'First Lock' => 'पहला लॉक',
        'Evaluation by' => 'मूल्यांकन से',
        'Total Time' => 'कुल समय',
        'Ticket Average' => 'टिकट औसत',
        'Ticket Min Time' => 'टिकट-न्यूनतम समय',
        'Ticket Max Time' => 'टिकट-अधिकतम समय',
        'Number of Tickets' => 'टिकटों की संख्या',
        'Article Average' => 'अनुच्छेद-औसत',
        'Article Min Time' => 'अनुच्छेद-न्यूनतम समय',
        'Article Max Time' => 'अनुच्छेद-अधिकतम समय',
        'Number of Articles' => 'अनुच्छेद की संख्या',
        'Accounted time by Agent' => 'प्रतिनिधि द्वारा लेखा  समय',
        'Ticket/Article Accounted Time' => 'टिकट/अनुच्छेद लेखा समय',
        'TicketAccountedTime' => 'टिकट लेखा समय',
        'Ticket Create Time' => 'टिकट बनाने का समय',
        'Ticket Close Time' => 'टिकट बंद होने का समय',

        # Template: AAATicket
        'Status View' => 'स्तर दृश्य',
        'Bulk' => 'थोक',
        'Lock' => 'लॉक',
        'Unlock' => 'अनलॉक',
        'History' => 'इतिहास',
        'Zoom' => 'ज़ूम',
        'Age' => 'आयु',
        'Bounce' => 'फलांग',
        'Forward' => 'आगे',
        'From' => 'से',
        'To' => 'को',
        'Cc' => 'प्रति ',
        'Bcc' => 'गुप्त प्रति',
        'Subject' => 'विषय',
        'Move' => 'स्थान-परिवर्तन',
        'Queue' => 'श्रेणी',
        'Queues' => 'श्रेणीया',
        'Priority' => 'प्राथमिकता',
        'Priorities' => 'प्राथमिकताएं',
        'Priority Update' => 'प्राथमिकता अद्यतन',
        'Priority added!' => '',
        'Priority updated!' => '',
        'Signature added!' => '',
        'Signature updated!' => '',
        'SLA' => 'SLA',
        'Service Level Agreement' => 'सेवा लेवल समझौता',
        'Service Level Agreements' => 'सेवा लेवल समझौतॆ',
        'Service' => 'सेवा',
        'Services' => 'सेवाएँ',
        'State' => 'अवस्था',
        'States' => 'अवस्थाएँ',
        'Status' => 'स्तर',
        'Statuses' => 'स्तर',
        'Ticket Type' => 'टिकट के प्रकार',
        'Ticket Types' => 'टिकट के प्रकार',
        'Compose' => 'लिखें',
        'Pending' => 'विचाराधीन',
        'Owner' => 'स्वामी',
        'Owner Update' => 'स्वामी अद्यतन',
        'Responsible' => 'उत्तरदायी',
        'Responsible Update' => 'उत्तरदायी अद्यतन',
        'Sender' => 'प्रेषक',
        'Article' => 'अनुच्छेद',
        'Ticket' => 'टिकट',
        'Createtime' => 'समय बनाएँ',
        'plain' => 'सरल',
        'Email' => 'ईमेल',
        'email' => 'ईमेल',
        'Close' => 'अंत',
        'Action' => 'कार्रवाई',
        'Attachment' => 'संलग्नक',
        'Attachments' => 'संलग्नक',
        'This message was written in a character set other than your own.' =>
            'यह संदेश दूसरे वर्ण में लिखा है आपके वर्ण में नहीं।',
        'If it is not displayed correctly,' => 'यदि यह सही ढंग से प्रदर्शित नहीं है तो',
        'This is a' => 'यह एक',
        'to open it in a new window.' => 'नई विंडो में खोलने के लिए',
        'This is a HTML email. Click here to show it.' => 'यह एक HTML ईमेल हैं। दिखाने के लिए यहाँ दबाऐ।',
        'Free Fields' => 'स्वतंत्र क्षेत्र',
        'Merge' => 'मिलाएं',
        'merged' => 'मिलाएं गए',
        'closed successful' => 'सफलतापूर्वक समाप्त',
        'closed unsuccessful' => 'असफलतापूर्वक समाप्त',
        'Locked Tickets Total' => 'कुल लॉकड टिकट',
        'Locked Tickets Reminder Reached' => 'लॉकड टिकट अनुस्मारक आ गया',
        'Locked Tickets New' => 'नए लॉकड टिकट',
        'Responsible Tickets Total' => 'कुल उत्तरदायी टिकट',
        'Responsible Tickets New' => 'नए उत्तरदायी टिकट',
        'Responsible Tickets Reminder Reached' => 'उत्तरदायी टिकट अनुस्मारक आ गया',
        'Watched Tickets Total' => 'कुल ध्यानाधीन टिकट',
        'Watched Tickets New' => 'नए ध्यानाधीन टिकट',
        'Watched Tickets Reminder Reached' => 'ध्यानाधीन टिकट अनुस्मारक आ गया',
        'All tickets' => 'सभी टिकट',
        'Available tickets' => '',
        'Escalation' => 'संवर्धित',
        'last-search' => 'पिछली खोज',
        'QueueView' => 'श्रेणी दृश्य',
        'Ticket Escalation View' => 'टिकट संवर्धित दृश्य',
        'Message from' => '',
        'End message' => '',
        'Forwarded message from' => '',
        'End forwarded message' => '',
        'new' => 'नया',
        'open' => 'खुला',
        'Open' => 'खुला',
        'Open tickets' => '',
        'closed' => 'बंद',
        'Closed' => 'बंद',
        'Closed tickets' => '',
        'removed' => 'हटा दिया',
        'pending reminder' => 'विचाराधीन चेतावनी',
        'pending auto' => 'विचाराधीन स्वत',
        'pending auto close+' => 'विचाराधीन स्वत बंद+',
        'pending auto close-' => 'विचाराधीन स्वत बंद-',
        'email-external' => 'बाहरी-ईमेल',
        'email-internal' => 'आंतरिक-ईमेल',
        'note-external' => 'बाहरी-टिप्पणी',
        'note-internal' => 'आंतरिक-टिप्पणी',
        'note-report' => 'टिप्पणी-रिपोर्ट',
        'phone' => 'फोन',
        'sms' => 'एसएमएस',
        'webrequest' => 'वेब अनुरोध',
        'lock' => 'लॉक',
        'unlock' => 'अनलॉक',
        'very low' => 'बहुत निम्न',
        'low' => 'निम्न',
        'normal' => 'सामान्य',
        'high' => 'उच्च',
        'very high' => 'बहुत उच्च',
        '1 very low' => '1 बहुत निम्न',
        '2 low' => '2 निम्न',
        '3 normal' => '3 सामान्य',
        '4 high' => '4 उच्च',
        '5 very high' => '5 बहुत उच्च',
        'auto follow up' => '',
        'auto reject' => '',
        'auto remove' => '',
        'auto reply' => '',
        'auto reply/new ticket' => '',
        'Ticket "%s" created!' => 'टिकट "%s" बना।',
        'Ticket Number' => 'टिकट संख्या',
        'Ticket Object' => 'टिकट वस्तु',
        'No such Ticket Number "%s"! Can\'t link it!' => 'ऐसी कोई "%s टिकट संख्या नहीं है।" इसे लिंक नहीं कर सकते।',
        'You don\'t have write access to this ticket.' => '',
        'Sorry, you need to be the ticket owner to perform this action.' =>
            '',
        'Please change the owner first.' => '',
        'Ticket selected.' => '',
        'Ticket is locked by another agent.' => '',
        'Ticket locked.' => '',
        'Don\'t show closed Tickets' => 'बंद टिकटें न दिखाएँ।',
        'Show closed Tickets' => 'बंद टिकटें दिखाएँ',
        'New Article' => 'नया अनुच्छेद',
        'Unread article(s) available' => 'उपलब्ध अपठित अनुच्छेद',
        'Remove from list of watched tickets' => 'ध्यानाधीन टिकटों की सूची से हटाएं।',
        'Add to list of watched tickets' => 'ध्यानाधीन टिकटों की सूची में जोड़ें।',
        'Email-Ticket' => 'ईमेल टिकट',
        'Create new Email Ticket' => 'नया ईमेल टिकट बनाएँ।',
        'Phone-Ticket' => 'फोन टिकट',
        'Search Tickets' => 'टिकटें खोजें',
        'Edit Customer Users' => 'ग्राहक प्रयोक्ता संपादित करें',
        'Edit Customer Company' => 'ग्राहक कंपनी संपादित करें',
        'Bulk Action' => 'थोक क्रिया',
        'Bulk Actions on Tickets' => 'टिकटों पर थोक क्रिया',
        'Send Email and create a new Ticket' => 'ईमेल भेजें और नया टिकट बनाएँ',
        'Create new Email Ticket and send this out (Outbound)' => 'नया ईमेल टिकट बनाएँ और बाहर भेजें (आउटबाउंड)',
        'Create new Phone Ticket (Inbound)' => 'नया फोन टिकट बनाएँ (इनबाउंड)',
        'Address %s replaced with registered customer address.' => '',
        'Customer automatically added in Cc.' => '',
        'Overview of all open Tickets' => 'सभी खुले टिकटों का अवलोकन',
        'Locked Tickets' => 'लॉकड टिकटें',
        'My Locked Tickets' => 'मेरे लॉकड टिकट',
        'My Watched Tickets' => 'मेरे ध्यानाधीन टिकट',
        'My Responsible Tickets' => 'मेरे उत्तरदायी टिकट',
        'Watched Tickets' => 'ध्यानाधीन टिकटें',
        'Watched' => 'ध्यानाधीन',
        'Watch' => 'देखो',
        'Unwatch' => 'अनदॆखॆ',
        'Lock it to work on it' => '',
        'Unlock to give it back to the queue' => '',
        'Show the ticket history' => '',
        'Print this ticket' => '',
        'Print this article' => '',
        'Split' => '',
        'Split this article' => '',
        'Forward article via mail' => '',
        'Change the ticket priority' => '',
        'Change the ticket free fields!' => 'टिकट के स्वतंत्र क्षेत्र बदलें।',
        'Link this ticket to other objects' => '',
        'Change the owner for this ticket' => '',
        'Change the  customer for this ticket' => '',
        'Add a note to this ticket' => '',
        'Merge into a different ticket' => '',
        'Set this ticket to pending' => '',
        'Close this ticket' => '',
        'Look into a ticket!' => 'टिकट में देखें',
        'Delete this ticket' => '',
        'Mark as Spam!' => 'अवांछनीय मार्क करें',
        'My Queues' => 'मेरी श्रेणी',
        'Shown Tickets' => 'दिखाए गए टिकट',
        'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' =>
            'आपका ईमेल टिकट संख्या "<OTRS_TICKET>" "<OTRS_MERGE_TO_TICKET>" में मिलाया जाता है।',
        'Ticket %s: first response time is over (%s)!' => 'टिकट %s: पहली प्रतिक्रिया का समय खत्म हो गया है (%s)।',
        'Ticket %s: first response time will be over in %s!' => 'टिकट %s: पहली प्रतिक्रिया का समय %s में खत्म होगा।',
        'Ticket %s: update time is over (%s)!' => 'टिकट %s: अद्यतन समय खत्म हो गया है (%s)।',
        'Ticket %s: update time will be over in %s!' => 'टिकट %s: अद्यतन समय %s में खत्म होगा।',
        'Ticket %s: solution time is over (%s)!' => 'टिकट %s: समाधान का समय खत्म हो गया है(%s)।',
        'Ticket %s: solution time will be over in %s!' => 'टिकट %s: समाधान का समय %s में खत्म होगा।',
        'There are more escalated tickets!' => 'यहाँ और भी संवर्धित टिकटें हैं।',
        'Plain Format' => 'सादा स्वरूप',
        'Reply All' => 'सबको उत्तर दें',
        'Direction' => 'दिशा',
        'Agent (All with write permissions)' => 'प्रतिनिधि (सभी के साथ लिखने की अनुमति)',
        'Agent (Owner)' => 'प्रतिनिधि (स्वामी)',
        'Agent (Responsible)' => 'प्रतिनिधि (उत्तरदायी)',
        'New ticket notification' => 'नए टिकट की सूचना',
        'Send me a notification if there is a new ticket in "My Queues".' =>
            'मुझे अधिसूचना भेजें यदि "मेरी श्रेणी" में नया टिकट आए।',
        'Send new ticket notifications' => 'नये टिकट की अधिसूचना भेजें।',
        'Ticket follow up notification' => 'टिकट अधिसूचना का पालन करें।',
        'Ticket lock timeout notification' => 'टिकट लॉक समय समाप्ति अधिसूचना',
        'Send me a notification if a ticket is unlocked by the system.' =>
            'मुझे अधिसूचना भेजें यदि टिकट प्रणाली द्वारा अनलॉक किया जाता है।',
        'Send ticket lock timeout notifications' => 'टिकट की लॉक समय समाप्ति की अधिसूचना भेजें।',
        'Ticket move notification' => 'टिकट स्थानांतरित अधिसूचना',
        'Send me a notification if a ticket is moved into one of "My Queues".' =>
            'यदि टिकट मेरी किसी भी "मेरी श्रेणी" में नया टिकट प्रस्तावित किया जाता है तो मुझे सूचना भेजें।',
        'Send ticket move notifications' => 'टिकट स्थानांतरित अधिसूचना भेजें।',
        'Your queue selection of your favourite queues. You also get notified about those queues via email if enabled.' =>
            '',
        'Custom Queue' => 'कस्टम श्रेणी ',
        'QueueView refresh time' => 'श्रेणीदृश्य का नवीनीकृत समय',
        'If enabled, the QueueView will automatically refresh after the specified time.' =>
            'यदि सक्रिय है,श्रेणीदृश्य स्वचालित रूप से निर्धारित समय के बाद ताज़ा होगी।',
        'Refresh QueueView after' => 'श्रेणीदृश्य को ताज़ा करें के बाद',
        'Screen after new ticket' => 'नये टिकट के बाद की स्क्रीन',
        'Show this screen after I created a new ticket' => 'मॆरॆ नये टिकट बनानॆ के बाद यह स्क्रीन दिखाएँ।',
        'Closed Tickets' => 'बंद टिकटें',
        'Show closed tickets.' => 'बंद टिकटें दिखाएँ।',
        'Max. shown Tickets a page in QueueView.' => 'श्रेणीदृश्य के एक पृष्ठ में दिखाएँ गये टिकटें।',
        'Ticket Overview "Small" Limit' => 'टिकट अवलोकन "लघु" सीमा ',
        'Ticket limit per page for Ticket Overview "Small"' => 'टिकट अवलोकन के लिए प्रति पृष्ठ टिकट "लघु" सीमा। ',
        'Ticket Overview "Medium" Limit' => 'टिकट अवलोकन "मध्यम" सीमा ',
        'Ticket limit per page for Ticket Overview "Medium"' => 'टिकट अवलोकन के लिए प्रति पृष्ठ टिकट "मध्यम" सीमा।',
        'Ticket Overview "Preview" Limit' => 'टिकट अवलोकन "पूर्वावलोकन " सीमा',
        'Ticket limit per page for Ticket Overview "Preview"' => 'टिकट अवलोकन के लिए प्रति पृष्ठ टिकट "पूर्वावलोकन " सीमा।',
        'Ticket watch notification' => 'टिकट ध्यानाधीन अधिसूचना',
        'Send me the same notifications for my watched tickets that the ticket owners will get.' =>
            'मुझे मेरे ध्यानाधीन टिकट के लिए वही अधिसूचना भेजें जो टिकट स्वामियों को मिलेगी।',
        'Send ticket watch notifications' => 'टिकट ध्यानाधीन की अधिसूचना भेजें।',
        'Out Of Office Time' => 'कार्यालय के समय से बाहर',
        'New Ticket' => 'नये टिकट ',
        'Create new Ticket' => 'नया टिकट बनाएँ',
        'Customer called' => 'ग्राहक को बुलाया ',
        'phone call' => 'फोन कॉल',
        'Phone Call Outbound' => 'फोन कॉल आउटबाउंड',
        'Phone Call Inbound' => '',
        'Reminder Reached' => 'अनुस्मारक आ गया',
        'Reminder Tickets' => 'अनुस्मारक टिकटें',
        'Escalated Tickets' => 'संवर्धित टिकटें',
        'New Tickets' => 'नई टिकटें ',
        'Open Tickets / Need to be answered' => 'खुले टिकटें / उत्तर दिया जाना चाहिए',
        'All open tickets, these tickets have already been worked on, but need a response' =>
            'सभी खुले टिकट,इन टिकटों पर पहले ही काम किया जा चुका है,लेकिन प्रतिक्रिया की जरूरत है।',
        'All new tickets, these tickets have not been worked on yet' => 'सभी नये टिकट,इन टिकटों पर अभी तक काम नहीं किया गया है।',
        'All escalated tickets' => 'सभी संवर्धित टिकट',
        'All tickets with a reminder set where the reminder date has been reached' =>
            'सभी टिकट एक अनुस्मारक सेट के साथ जहाँ दिनांक अनुस्मारक पहुँच गया है।',
        'Archived tickets' => '',
        'Unarchived tickets' => '',
        'History::Move' => ' "%s" (%s) प्रस्तावित  "%s" (%s)।',
        'History::TypeUpdate' => 'प्रकार अद्यतन %s (ID=%s)।',
        'History::ServiceUpdate' => 'सेवा अद्यतन %s (ID=%s)।',
        'History::SLAUpdate' => 'SLA अद्यतन %s (ID=%s)।',
        'History::NewTicket' => 'नया टिकट [%s] बनाया (Q=%s;P=%s;S=%s)।',
        'History::FollowUp' => 'अनुवर्ती कार्रवाई [%s]. %s',
        'History::SendAutoReject' => 'स्वत भेजना अस्वीकारें "%s"।',
        'History::SendAutoReply' => 'स्वत जवाब भेजना "%s"।',
        'History::SendAutoFollowUp' => 'स्वत अनुवर्ती कार्रवाई भेजना  "%s"।',
        'History::Forward' => 'आगे"%s"।',
        'History::Bounce' => 'फलांग "%s"।',
        'History::SendAnswer' => 'जवाब भेजें "%s"।',
        'History::SendAgentNotification' => '"%s"-प्रतिनिधि अधिसूचना भेजें"%s"।',
        'History::SendCustomerNotification' => 'ग्राहक अधिसूचना भेजें"%s"।',
        'History::EmailAgent' => 'प्रतिनिधि ईमेल।',
        'History::EmailCustomer' => 'ग्राहक ईमेल %s।',
        'History::PhoneCallAgent' => 'फोन कॉल प्रतिनिधि।',
        'History::PhoneCallCustomer' => 'फोन कॉल ग्राहक।',
        'History::AddNote' => 'टिप्पणी जोड़ें (%s)।',
        'History::Lock' => 'लॉक।',
        'History::Unlock' => 'अनलॉक।',
        'History::TimeAccounting' => '%S समय लेखाकरण दर्ज की गई। नई कुल %S इकाई समय।',
        'History::Remove' => 'हटायें "%s"।',
        'History::CustomerUpdate' => 'ग्राहक अद्यतन: %s।',
        'History::PriorityUpdate' => 'अद्यतन प्राथमिकता "%s" (%s)  "%s" (%s)।',
        'History::OwnerUpdate' => 'स्वामी अद्यतन"%s" (ID=%s)।',
        'History::LoopProtection' => 'सुरक्षालूप "%s"।',
        'History::Misc' => 'विविध %s।',
        'History::SetPendingTime' => 'विचाराधीन निर्धारित समय: %s।',
        'History::StateUpdate' => 'पुराना: "%s". नया: "%s"।',
        'History::TicketDynamicFieldUpdate' => 'टिकट पाठ्य अद्यतन: %s=%s;%s=%s;',
        'History::WebRequestCustomer' => 'ग्राहक वेब अनुरोध।',
        'History::TicketLinkAdd' => 'टिकट के लिए लिंक जोड़ा गया "%s"।',
        'History::TicketLinkDelete' => 'टिकट के लिए लिंक हटाया "%s"।',
        'History::Subscribe' => 'सदस्यता लें "%s"।',
        'History::Unsubscribe' => 'सदस्यता रद्द करें "%s"।',
        'History::SystemRequest' => 'प्रणाली आग्रह।',
        'History::ResponsibleUpdate' => 'उत्तरदायी अद्यतन।',
        'History::ArchiveFlagUpdate' => '',

        # Template: AAAWeekDay
        'Sun' => 'रविवार',
        'Mon' => 'सोमवार',
        'Tue' => 'मंगलवार',
        'Wed' => 'बुधवार',
        'Thu' => 'गुस्र्वार',
        'Fri' => 'शुक्रवार',
        'Sat' => 'शनिवार',

        # Template: AdminAttachment
        'Attachment Management' => 'अनुलग्नक प्रबंधन',
        'Actions' => 'क्रियाएँ',
        'Go to overview' => 'अवलोकन के लिए जाएँ',
        'Add attachment' => 'संलग्नक जोड़ें',
        'List' => 'सूची',
        'Validity' => '',
        'No data found.' => 'कोई आंकड़ा नहीं मिला।',
        'Download file' => 'फ़ाइल डाउनलोड करें',
        'Delete this attachment' => 'इस संलग्नक को हटाएँ ',
        'Add Attachment' => 'संलग्नक जोड़ें',
        'Edit Attachment' => 'संलग्नक संपादित करें',
        'This field is required.' => 'इस क्षेत्र की आवश्यकता है।',
        'or' => 'या',

        # Template: AdminAutoResponse
        'Auto Response Management' => 'स्वत प्रतिक्रिया प्रबंधन ',
        'Add auto response' => 'स्वत प्रतिक्रिया जोड़ें',
        'Add Auto Response' => 'स्वत प्रतिक्रिया जोड़ें',
        'Edit Auto Response' => 'स्वत प्रतिक्रिया संपादित करें',
        'Response' => 'प्रतिक्रिया',
        'Auto response from' => 'स्वत प्रतिक्रिया से',
        'Reference' => 'संदर्भ में',
        'You can use the following tags' => 'आप निम्नलिखित टैग का उपयोग कर सकते हैं।',
        'To get the first 20 character of the subject.' => 'विषय के पहले 20 वर्ण प्राप्त करने के लिए।',
        'To get the first 5 lines of the email.' => 'ईमेल की पहली 5 लाइनें प्राप्त करने के लिए।',
        'To get the realname of the sender (if given).' => 'प्रेषक का वास्तविक नाम प्राप्त करने के लिए (यदि दिया है)।',
        'To get the article attribute' => 'अनुच्छेद विशेषता प्राप्त करने के लिए।',
        ' e. g.' => 'उदा.',
        'Options of the current customer user data' => 'मौजूदा ग्राहक उपयोगकर्ता के आंकड़ॊ के विकल्प',
        'Ticket owner options' => 'टिकट स्वामी विकल्प',
        'Ticket responsible options' => 'टिकट उत्तरदायी विकल्प',
        'Options of the current user who requested this action' => 'वर्तमान उपयोगकर्ता के विकल्प जिसनॆ इस कार्रवाई के लिए अनुरोध किया।',
        'Options of the ticket data' => 'टिकट आंकड़ॊ के विकल्प',
        'Options of ticket dynamic fields internal key values' => '',
        'Options of ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            '',
        'Config options' => 'संरचना के विकल्पों',
        'Example response' => 'उदाहरण प्रतिक्रिया',

        # Template: AdminCustomerCompany
        'Customer Company Management' => 'ग्राहक कंपनी प्रबंधन',
        'Wildcards like \'*\' are allowed.' => '',
        'Add customer company' => 'ग्राहक कंपनी जोड़ें',
        'Please enter a search term to look for customer companies.' => 'कृपया ग्राहक कंपनियों को देखने के लिए एक खोज शब्द दर्ज करें।',
        'Add Customer Company' => 'ग्राहक कंपनी जोड़ें',

        # Template: AdminCustomerUser
        'Customer Management' => 'ग्राहक प्रबंधन',
        'Back to search results' => '',
        'Add customer' => 'ग्राहक जोड़ें',
        'Select' => 'चुनें',
        'Hint' => 'संकेत',
        'Customer will be needed to have a customer history and to login via customer panel.' =>
            'ग्राहक को एक ग्राहक इतिहास की आवश्यकता होगी और ग्राहक पटल के माध्यम से प्रवेश की।',
        'Please enter a search term to look for customers.' => 'कृपया ग्राहकों को देखने के लिए एक खोज शब्द दर्ज करें।',
        'Last Login' => 'पिछला प्रवेश ',
        'Login as' => 'के रूप में प्रवेश',
        'Switch to customer' => '',
        'Add Customer' => 'ग्राहक जोड़ें',
        'Edit Customer' => 'ग्राहक संपादित करें',
        'This field is required and needs to be a valid email address.' =>
            'यह क्षेत्र जरूरी है और एक मान्य ईमेल पतॆ की आवश्यकता है।',
        'This email address is not allowed due to the system configuration.' =>
            'यह ईमेल पता प्रणाली विन्यास की वजह से स्वीकार्य नहीं है।',
        'This email address failed MX check.' => 'यह ईमेल पता MX जांच में विफल रहा।',
        'DNS problem, please check your configuration and the error log.' =>
            '',
        'The syntax of this email address is incorrect.' => 'इस ईमेल पते के वाक्य रचना ग़लत है।',

        # Template: AdminCustomerUserGroup
        'Manage Customer-Group Relations' => 'ग्राहक-समूह संबंधों का प्रबंधन करें',
        'Notice' => 'समन',
        'This feature is disabled!' => 'यह सुविधा निष्क्रिय है।',
        'Just use this feature if you want to define group permissions for customers.' =>
            'यदि आप ग्राहकों के लिए समूह अनुमतियाँ परिभाषित करना चाहते हैं तो इस सुविधा का उपयोग करें।',
        'Enable it here!' => 'यहाँ सक्रिय करें।',
        'Search for customers.' => '',
        'Edit Customer Default Groups' => 'ग्राहक तयशुदा समूह संपादित करें',
        'These groups are automatically assigned to all customers.' => 'यह समूह स्वतः सभी ग्राहकों के लिए आवंटित हो जाते हैं।',
        'You can manage these groups via the configuration setting "CustomerGroupAlwaysGroups".' =>
            'आप विन्यास व्यवस्था "ग्राहक समूह सदैव समूहों" के माध्यम से इन समूहों का प्रबंधन कर सकते हैं।',
        'Filter for Groups' => 'समूहों के लिए निस्पादक',
        'Select the customer:group permissions.' => 'ग्राहक:समूह अनुमतियाँ चुनें।',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer).' =>
            'अगर कुछ भी नहीं चुना जाता है,तो फिर इस समूह में कोई अनुमतियाँ नहीं हैं(टिकट ग्राहकों के लिए उपलब्ध नहीं होगा)। ',
        'Search Results' => 'खोज परिणाम:',
        'Customers' => 'ग्राहकों',
        'Groups' => 'समूहों',
        'No matches found.' => 'कोई मिलान नहीं मिले।',
        'Change Group Relations for Customer' => 'ग्राहक के लिए समूह संबंधों को बदलें',
        'Change Customer Relations for Group' => 'समूह के लिए ग्राहक संबंधों को बदलें',
        'Toggle %s Permission for all' => 'स्विच %s सभी के लिए अनुमति है',
        'Toggle %s permission for %s' => 'स्विच %s %s के लिए अनुमति है',
        'Customer Default Groups:' => 'ग्राहक तयशुदा समूहॆ:',
        'No changes can be made to these groups.' => 'इन समूहों में कोई बदलाव नहीं किया जा सकता।',
        'ro' => 'केवल पढ़ने के लिए',
        'Read only access to the ticket in this group/queue.' => 'इस समूह/श्रेणी के टिकट को केवल पढ़ने के लिए प्रवेश।',
        'rw' => 'पढ़ने और लिखने के लिए',
        'Full read and write access to the tickets in this group/queue.' =>
            'इस समूह/श्रेणी के टिकट को पढ़ने और लिखने के लिए प्रवेश।',

        # Template: AdminCustomerUserService
        'Manage Customer-Services Relations' => 'ग्राहक-सेवाएँ संबंधों का प्रबंधन करें',
        'Edit default services' => 'तयशुदा सेवाएं संपादित करें',
        'Filter for Services' => 'सेवाओं के लिए निस्पादक',
        'Allocate Services to Customer' => 'ग्राहक को सेवाएँ आवंटित करें',
        'Allocate Customers to Service' => 'सेवाओं को ग्राहक आवंटित करें',
        'Toggle active state for all' => 'सभी के लिए सक्रिय स्थिति स्विच करें',
        'Active' => 'क्रियाशील',
        'Toggle active state for %s' => 'सक्रिय स्थिति स्विच करें %s के लिए',

        # Template: AdminDynamicField
        'Dynamic Fields Management' => '',
        'Add new field for object' => '',
        'To add a new field, select the field type form one of the object\'s list, the object defines the boundary of the field and it can\'t be changed after the field creation.' =>
            '',
        'Dynamic Fields List' => '',
        'Dynamic fields per page' => '',
        'Label' => '',
        'Order' => '',
        'Object' => 'वस्तु',
        'Delete this field' => '',
        'Do you really want to delete this dynamic field? ALL associated data will be LOST!' =>
            '',
        'Delete field' => '',

        # Template: AdminDynamicFieldCheckbox
        'Dynamic Fields' => '',
        'Field' => '',
        'Go back to overview' => '',
        'General' => '',
        'This field is required, and the value should be alphabetic and numeric characters only.' =>
            '',
        'Must be unique and only accept alphabetic and numeric characters.' =>
            '',
        'Changing this value will require manual changes in the system.' =>
            '',
        'This is the name to be shown on the screens where the field is active.' =>
            '',
        'Field order' => '',
        'This field is required and must be numeric.' => '',
        'This is the order in which this field will be shown on the screens where is active.' =>
            '',
        'Field type' => '',
        'Object type' => '',
        'Internal field' => '',
        'This field is protected and can\'t be deleted.' => '',
        'Field Settings' => '',
        'Default value' => 'तयशुदा मान',
        'This is the default value for this field.' => '',
        'Save' => 'सुरक्षित करे',

        # Template: AdminDynamicFieldDateTime
        'Default date difference' => '',
        'This field must be numeric.' => '',
        'The difference from NOW (in seconds) to calculate the field default value (e.g. 3600 or -60).' =>
            '',
        'Define years period' => '',
        'Activate this feature to define a fixed range of years (in the future and in the past) to be displayed on the year part of the field.' =>
            '',
        'Years in the past' => '',
        'Years in the past to display (default: 5 years).' => '',
        'Years in the future' => '',
        'Years in the future to display (default: 5 years).' => '',
        'Show link' => '',
        'Here you can specify an optional HTTP link for the field value in Overviews and Zoom screens.' =>
            '',

        # Template: AdminDynamicFieldDropdown
        'Possible values' => '',
        'Key' => 'कुंजी',
        'Value' => 'मान',
        'Remove value' => '',
        'Add value' => '',
        'Add Value' => '',
        'Add empty value' => '',
        'Activate this option to create an empty selectable value.' => '',
        'Translatable values' => '',
        'If you activate this option the values will be translated to the user defined language.' =>
            '',
        'Note' => '',
        'You need to add the translations manually into the language translation files.' =>
            '',

        # Template: AdminDynamicFieldMultiselect

        # Template: AdminDynamicFieldText
        'Number of rows' => '',
        'Specify the height (in lines) for this field in the edit mode.' =>
            '',
        'Number of cols' => '',
        'Specify the width (in characters) for this field in the edit mode.' =>
            '',

        # Template: AdminEmail
        'Admin Notification' => 'व्यवस्थापक अधिसूचना',
        'With this module, administrators can send messages to agents, group or role members.' =>
            'इस मॉड्यूल के साथ,प्रशासक प्रतिनिधि,समूह,या भूमिका के सदस्यों को संदेश भेज सकते हैं। ',
        'Create Administrative Message' => 'प्रशासनिक संदेश बनाएँ',
        'Your message was sent to' => 'आपका संदेश को भेजा गया',
        'Send message to users' => 'उपयोगकर्ताओं को संदेश भेजें',
        'Send message to group members' => 'समूह के सदस्यों को संदेश भेजें',
        'Group members need to have permission' => 'समूह सदस्यों को अनुमति की आवश्यकता है',
        'Send message to role members' => 'भूमिका के सदस्यों को संदेश भेजें',
        'Also send to customers in groups' => 'समूह में ग्राहकों को भी भेजें',
        'Body' => 'मुख्य-भाग',
        'Send' => 'भेजें',

        # Template: AdminGenericAgent
        'Generic Agent' => 'सामान्य प्रतिनिधि',
        'Add job' => 'काम जोड़ें',
        'Last run' => 'पिछले भागो',
        'Run Now!' => 'अब चलाएँ',
        'Delete this task' => 'इस कार्य को हटाएँ',
        'Run this task' => 'इस कार्य को चलाएँ',
        'Job Settings' => 'कार्य व्यवस्थाऐं',
        'Job name' => 'कार्य का नाम',
        'Currently this generic agent job will not run automatically.' =>
            'फ़िलहाल इस सामान्य प्रतिनिधि के काम स्वचालित रूप से नहीं चलेंगे।',
        'To enable automatic execution select at least one value from minutes, hours and days!' =>
            'स्वचालित निष्पादन सक्रिय करने के लिए मिनट,घंटे और दिनों से कम से कम एक मान का चयन करें।',
        'Schedule minutes' => 'अनुसूची मिनट ',
        'Schedule hours' => 'अनुसूची घंटे',
        'Schedule days' => 'अनुसूची दिनों',
        'Toggle this widget' => 'इस मशीन को स्विच करें',
        'Ticket Filter' => 'टिकट निस्पादक',
        '(e. g. 10*5155 or 105658*)' => '(उदा: 10*5155 o 105658*)',
        '(e. g. 234321)' => '(उदा: 234321)',
        'Customer login' => 'ग्राहक प्रवेश',
        '(e. g. U5150)' => '(उदा: U5150)',
        'Fulltext-search in article (e. g. "Mar*in" or "Baue*").' => 'अनुच्छेद में पूर्ण पाठ खोजें(उदा: "Mar*in" or "Baue*") ',
        'Agent' => 'प्रतिनिधि',
        'Ticket lock' => 'टिकट लॉक',
        'Create times' => 'समय बनाएँ',
        'No create time settings.' => 'कोई समय बनाने की व्यवस्थाऐं नहीं।',
        'Ticket created' => 'टिकट बनाया',
        'Ticket created between' => 'टिकट के बीच में बनाया गया',
        'Change times' => '',
        'No change time settings.' => '',
        'Ticket changed' => '',
        'Ticket changed between' => '',
        'Close times' => 'बंद समय',
        'No close time settings.' => 'कोई बंद समय व्यवस्थाऐं नहीं।',
        'Ticket closed' => 'टिकट बंद हुआ',
        'Ticket closed between' => 'टिकट के बीच में बंद हुआ',
        'Pending times' => 'विचाराधीन समय',
        'No pending time settings.' => 'कोई विचाराधीन समय व्यवस्थाऐं नहीं।',
        'Ticket pending time reached' => 'टिकट विचाराधीन समय आ गया',
        'Ticket pending time reached between' => 'टिकट विचाराधीन समय आ गया के बीच में',
        'Escalation times' => 'संवर्धित समय',
        'No escalation time settings.' => 'कोई संवर्धित समय व्यवस्थाऐं नहीं।',
        'Ticket escalation time reached' => 'टिकट संवर्धित समय आ गया',
        'Ticket escalation time reached between' => 'टिकट संवर्धित समय आ गया के बीच में',
        'Escalation - first response time' => 'संवर्धित पहली प्रतिक्रिया समय',
        'Ticket first response time reached' => 'टिकट पहली प्रतिक्रिया समय आ गया',
        'Ticket first response time reached between' => 'टिकट पहली प्रतिक्रिया समय आ गया के बीच में',
        'Escalation - update time' => 'संवर्धित अद्यतन समय ',
        'Ticket update time reached' => 'टिकट अद्यतन समय आ गया',
        'Ticket update time reached between' => 'टिकट अद्यतन समय आ गया के बीच में',
        'Escalation - solution time' => 'संवर्धित समाधान समय',
        'Ticket solution time reached' => 'टिकट समाधान समय आ गया',
        'Ticket solution time reached between' => 'टिकट समाधान समय आ गया के बीच में',
        'Archive search option' => 'संग्रह खोज विकल्प',
        'Ticket Action' => 'टिकट कार्रवाई',
        'Set new service' => 'नई सेवा निर्धारित करें',
        'Set new Service Level Agreement' => 'नये सेवा लेवल समझौतॆ निर्धारित करें',
        'Set new priority' => 'नई प्राथमिकता निर्धारित करें',
        'Set new queue' => 'नई श्रेणी निर्धारित करें',
        'Set new state' => 'नई स्थिति निर्धारित करें',
        'Set new agent' => 'नया प्रतिनिधि निर्धारित करें',
        'new owner' => 'नया स्वामी',
        'new responsible' => '',
        'Set new ticket lock' => 'नया टिकट लॉक निर्धारित करें',
        'New customer' => 'नया ग्राहक ',
        'New customer ID' => 'नया ग्राहक ID',
        'New title' => 'नया शीर्षक',
        'New type' => 'नए प्रकार',
        'New Dynamic Field Values' => '',
        'Archive selected tickets' => 'संग्रह टिकट चयनित',
        'Add Note' => 'टिप्पणी जोड़ें',
        'Time units' => 'समय इकाइयों',
        '(work units)' => '',
        'Ticket Commands' => 'टिकट आदेश',
        'Send agent/customer notifications on changes' => 'बदलाव पर प्रतिनिधि/ग्राहक कि अधिसूचना भेजें',
        'CMD' => 'CMD',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' =>
            'यह  आदेश चलाएँ। ARG[0] टिकट संख्या होगी, ARG[0] टिकट id।',
        'Delete tickets' => 'टिकट हटाएँ',
        'Warning: All affected tickets will be removed from the database and cannot be restored!' =>
            'चेतावनी:सभी प्रभावित टिकट आंकड़ाकोष से हटा दिए जाएँगे और तब ये पुनर्स्थापित नहीं हो सकते।',
        'Execute Custom Module' => 'कस्टम मॉड्यूल चलाएँ',
        'Param %s key' => 'पैरा %s कुंजी',
        'Param %s value' => 'पैरा %s मूल्य',
        'Save Changes' => 'परिवर्तन  सुरक्षित करें',
        'Results' => 'परिणाम',
        '%s Tickets affected! What do you want to do?' => '%s प्रभावित टिकट। आप क्या करना चाहते हैं?',
        'Warning: You used the DELETE option. All deleted tickets will be lost!' =>
            'चेतावनी: आपनॆ हटाएँ विकल्प का उपयोग किया है। सभी नष्ट टिकट लुप्त जाऍगॆ।',
        'Edit job' => 'काम संपादित करें',
        'Run job' => 'काम चलाएँ',
        'Affected Tickets' => 'प्रभावित टिकट',

        # Template: AdminGenericInterfaceDebugger
        'GenericInterface Debugger for Web Service %s' => '',
        'Web Services' => '',
        'Debugger' => '',
        'Go back to web service' => '',
        'Clear' => '',
        'Do you really want to clear the debug log of this web service?' =>
            '',
        'Request List' => '',
        'Time' => 'समय',
        'Remote IP' => '',
        'Loading' => '',
        'Select a single request to see its details.' => '',
        'Filter by type' => '',
        'Filter from' => '',
        'Filter to' => '',
        'Filter by remote IP' => '',
        'Refresh' => '',
        'Request Details' => '',
        'An error occurred during communication.' => '',
        'Show or hide the content' => 'अंतर्वस्तु दिखाएँ या छुपाएँ',
        'Clear debug log' => '',

        # Template: AdminGenericInterfaceInvokerDefault
        'Add new Invoker to Web Service %s' => '',
        'Change Invoker %s of Web Service %s' => '',
        'Add new invoker' => '',
        'Change invoker %s' => '',
        'Do you really want to delete this invoker?' => '',
        'All configuration data will be lost.' => '',
        'Invoker Details' => '',
        'The name is typically used to call up an operation of a remote web service.' =>
            '',
        'Please provide a unique name for this web service invoker.' => '',
        'The name you entered already exists.' => '',
        'Invoker backend' => '',
        'This OTRS invoker backend module will be called to prepare the data to be sent to the remote system, and to process its response data.' =>
            '',
        'Mapping for outgoing request data' => '',
        'Configure' => '',
        'The data from the invoker of OTRS will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            '',
        'Mapping for incoming response data' => '',
        'The response data will be processed by this mapping, to transform it to the kind of data the invoker of OTRS expects.' =>
            '',
        'Event Triggers' => '',
        'Asynchronous' => '',
        'Delete this event' => '',
        'This invoker will be triggered by the configured events.' => '',
        'Do you really want to delete this event trigger?' => '',
        'Add Event Trigger' => '',
        'To add a new event select the event object and event name and click on the "+" button' =>
            '',
        'Asynchronous event triggers are handled by the OTRS Scheduler in background (recommended).' =>
            '',
        'Synchronous event triggers would be processed directly during the web request.' =>
            '',
        'Save and continue' => '',
        'Save and finish' => '',
        'Delete this Invoker' => '',
        'Delete this Event Trigger' => '',

        # Template: AdminGenericInterfaceMappingSimple
        'GenericInterface Mapping Simple for Web Service %s' => '',
        'Go back to' => '',
        'Mapping Simple' => '',
        'Default rule for unmapped keys' => '',
        'This rule will apply for all keys with no mapping rule.' => '',
        'Default rule for unmapped values' => '',
        'This rule will apply for all values with no mapping rule.' => '',
        'New key map' => '',
        'Add key mapping' => '',
        'Mapping for Key ' => '',
        'Remove key mapping' => '',
        'Key mapping' => '',
        'Map key' => '',
        'matching the' => '',
        'to new key' => '',
        'Value mapping' => '',
        'Map value' => '',
        'to new value' => '',
        'Remove value mapping' => '',
        'New value map' => '',
        'Add value mapping' => '',
        'Do you really want to delete this key mapping?' => '',
        'Delete this Key Mapping' => '',

        # Template: AdminGenericInterfaceOperationDefault
        'Add new Operation to Web Service %s' => '',
        'Change Operation %s of Web Service %s' => '',
        'Add new operation' => '',
        'Change operation %s' => '',
        'Do you really want to delete this operation?' => '',
        'Operation Details' => '',
        'The name is typically used to call up this web service operation from a remote system.' =>
            '',
        'Please provide a unique name for this web service.' => '',
        'Mapping for incoming request data' => '',
        'The request data will be processed by this mapping, to transform it to the kind of data OTRS expects.' =>
            '',
        'Operation backend' => '',
        'This OTRS operation backend module will be called internally to process the request, generating data for the response.' =>
            '',
        'Mapping for outgoing response data' => '',
        'The response data will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            '',
        'Delete this Operation' => '',

        # Template: AdminGenericInterfaceTransportHTTPSOAP
        'GenericInterface Transport HTTP::SOAP for Web Service %s' => '',
        'Network transport' => '',
        'Properties' => '',
        'Endpoint' => '',
        'URI to indicate a specific location for accessing a service.' =>
            '',
        'e.g. http://local.otrs.com:8000/Webservice/Example' => '',
        'Namespace' => '',
        'URI to give SOAP methods a context, reducing ambiguities.' => '',
        'e.g urn:otrs-com:soap:functions or http://www.otrs.com/GenericInterface/actions' =>
            '',
        'Maximum message length' => '',
        'This field should be an integer number.' => '',
        'Here you can specify the maximum size (in bytes) of SOAP messages that OTRS will process.' =>
            '',
        'Encoding' => '',
        'The character encoding for the SOAP message contents.' => '',
        'e.g utf-8, latin1, iso-8859-1, cp1250, Etc.' => '',
        'SOAPAction' => '',
        'Set to "Yes" to send a filled SOAPAction header.' => '',
        'Set to "No" to send an empty SOAPAction header.' => '',
        'SOAPAction separator' => '',
        'Character to use as separator between name space and SOAP method.' =>
            '',
        'Usually .Net web services uses a "/" as separator.' => '',
        'Authentication' => '',
        'The authentication mechanism to access the remote system.' => '',
        'A "-" value means no authentication.' => '',
        'The user name to be used to access the remote system.' => '',
        'The password for the privileged user.' => '',
        'Use SSL Options' => '',
        'Show or hide SSL options to connect to the remote system.' => '',
        'Certificate File' => '',
        'The full path and name of the SSL certificate file (must be in .p12 format).' =>
            '',
        'e.g. /opt/otrs/var/certificates/SOAP/certificate.p12' => '',
        'Certificate Password File' => '',
        'The password to open the SSL certificate.' => '',
        'Certification Authority (CA) File' => '',
        'The full path and name of the certification authority certificate file that validates SSL certificate.' =>
            '',
        'e.g. /opt/otrs/var/certificates/SOAP/CA/ca.pem' => '',
        'Certification Authority (CA) Directory' => '',
        'The full path of the certification authority directory where the CA certificates are stored in the file system.' =>
            '',
        'e.g. /opt/otrs/var/certificates/SOAP/CA' => '',
        'Proxy Server' => '',
        'URI of a proxy server to be used (if needed).' => '',
        'e.g. http://proxy_hostname:8080' => '',
        'Proxy User' => '',
        'The user name to be used to access the proxy server.' => '',
        'Proxy Password' => '',
        'The password for the proxy user.' => '',

        # Template: AdminGenericInterfaceWebservice
        'GenericInterface Web Service Management' => '',
        'Add web service' => '',
        'Clone web service' => '',
        'The name must be unique.' => '',
        'Clone' => '',
        'Export web service' => '',
        'Import web service' => '',
        'Configuration File' => '',
        'The file must be a valid web service configuration YAML file.' =>
            '',
        'Import' => 'आयात',
        'Configuration history' => '',
        'Delete web service' => '',
        'Do you really want to delete this web service?' => '',
        'After you save the configuration you will be redirected again to the edit screen.' =>
            '',
        'If you want to return to overview please click the "Go to overview" button.' =>
            '',
        'Web Service List' => '',
        'Remote system' => '',
        'Provider transport' => '',
        'Requester transport' => '',
        'Details' => '',
        'Debug threshold' => '',
        'In provider mode, OTRS offers web services which are used by remote systems.' =>
            '',
        'In requester mode, OTRS uses web services of remote systems.' =>
            '',
        'Operations are individual system functions which remote systems can request.' =>
            '',
        'Invokers prepare data for a request to a remote web service, and process its response data.' =>
            '',
        'Controller' => '',
        'Inbound mapping' => '',
        'Outbound mapping' => '',
        'Delete this action' => '',
        'At least one %s has a controller that is either not active or not present, please check the controller registration or delete the %s' =>
            '',
        'Delete webservice' => '',
        'Delete operation' => '',
        'Delete invoker' => '',
        'Clone webservice' => '',
        'Import webservice' => '',

        # Template: AdminGenericInterfaceWebserviceHistory
        'GenericInterface Configuration History for Web Service %s' => '',
        'Go back to Web Service' => '',
        'Here you can view older versions of the current web service\'s configuration, export or even restore them.' =>
            '',
        'Configuration History List' => '',
        'Version' => 'संस्करण',
        'Create time' => '',
        'Select a single configuration version to see its details.' => '',
        'Export web service configuration' => '',
        'Restore web service configuration' => '',
        'Do you really want to restore this version of the web service configuration?' =>
            '',
        'Your current web service configuration will be overwritten.' => '',
        'Show or hide the content.' => '',
        'Restore' => '',

        # Template: AdminGroup
        'WARNING: When you change the name of the group \'admin\', before making the appropriate changes in the SysConfig, you will be locked out of the administrations panel! If this happens, please rename the group back to admin per SQL statement.' =>
            'चेतावनी: जब आप \'व्यवस्थापक\'समूह का नाम बदले, प्रणाली विन्यास में उपयुक्त बदलाव करने से पहले, आपको प्रशासन के बाहर अवरोधित कर दिया जाएगा। यदि ऐसा होता है, तो कृपया प्रत्येक SQL वचन के लिए व्यवस्थापक के समूह का नाम बदले।',
        'Group Management' => 'समूह प्रबंधन',
        'Add group' => 'समूह जोड़ें',
        'The admin group is to get in the admin area and the stats group to get stats area.' =>
            'व्यवस्थापक समूह के लिए समूह प्रबंधन के क्षेत्र का प्रयोग है और आँकड़े समूह आँकड़े क्षेत्र को प्राप्त करने के लिए।',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...). ' =>
            ' विभिन्न समूहों के एजेंट की विभिन्न उपयोग अनुमतियो को संभालने के लिए नयॆ समूह बनाएँ।(उदा. क्रय विभाग,समर्थन विभाग,बिक्री विभाग,...)',
        'It\'s useful for ASP solutions. ' => 'यह ASP समाधान के लिए उपयोगी है।',
        'Add Group' => 'समूह जोड़ें',
        'Edit Group' => 'समूह संपादित करें',

        # Template: AdminLog
        'System Log' => 'प्रणाली अभिलेख ',
        'Here you will find log information about your system.' => 'यहाँ पर आपको अपनी प्रणाली के बारे में अभिलेख की जानकारी मिल जाएगी।',
        'Hide this message' => 'इस संदेश को छिपाएँ',
        'Recent Log Entries' => 'ताज़ा अभिलेख प्रविष्टियां',

        # Template: AdminMailAccount
        'Mail Account Management' => 'मेल खाता प्रबंधन',
        'Add mail account' => 'मेल खाता जोड़ें',
        'All incoming emails with one account will be dispatched in the selected queue!' =>
            'सभी आने वाली ईमेल जो एक ही खाते में है उनको चयनित श्रेणी में भेज दिया जाएगा।',
        'If your account is trusted, the already existing X-OTRS header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' =>
            'यदि आपका खाता विश्वसनीय है, आगमन समय(प्राथमिकता के लिए,...) पर पहले से मौजूद X-OTRS शीर्षक का उपयोग किया जाएगा। किसी न किसी प्रकार से डाकपाल निस्पादक प्रयोग किया जाएगा।',
        'Host' => 'मेजबान',
        'Delete account' => 'खाता हटाएँ',
        'Fetch mail' => 'आनयन मेल',
        'Add Mail Account' => 'मेल खाता जोड़ें',
        'Example: mail.example.com' => 'उदाहरण:मेल.उदाहरण.कॉम',
        'IMAP Folder' => '',
        'Only modify this if you need to fetch mail from a different folder than INBOX.' =>
            '',
        'Trusted' => 'विश्वसनीय',
        'Dispatching' => 'प्रेषण',
        'Edit Mail Account' => 'मेल खाता संपादित करें',

        # Template: AdminNavigationBar
        'Admin' => 'व्यवस्थापक',
        'Agent Management' => 'प्रतिनिधि प्रबंधन',
        'Queue Settings' => 'श्रेणी व्यवस्थाऐं',
        'Ticket Settings' => 'टिकट व्यवस्थाऐं',
        'System Administration' => 'प्रशासन प्रणाली',

        # Template: AdminNotification
        'Notification Management' => 'अधिसूचना प्रबंधन',
        'Select a different language' => '',
        'Filter for Notification' => 'अधिसूचना के लिए निस्पादक',
        'Notifications are sent to an agent or a customer.' => 'अधिसूचनाएँ एक प्रतिनिधि या एक ग्राहक को भेजी जाती है।',
        'Notification' => 'अधिसूचनाएँ',
        'Edit Notification' => 'अधिसूचनाएँ संपादित करें',
        'e. g.' => 'उदा.',
        'Options of the current customer data' => 'मौजूदा ग्राहक के आंकड़ॊ के विकल्प',

        # Template: AdminNotificationEvent
        'Add notification' => 'अधिसूचना जोड़ें',
        'Delete this notification' => 'इस अधिसूचना को हटाएँ',
        'Add Notification' => 'अधिसूचना जोड़ें',
        'Recipient groups' => 'प्राप्तकर्ता समूहों',
        'Recipient agents' => 'प्राप्तकर्ता प्रतिनिधियॊ ',
        'Recipient roles' => 'प्राप्तकर्ता भूमिकाओं',
        'Recipient email addresses' => 'प्राप्तकर्ता के ईमेल पते',
        'Article type' => 'आलेख प्रकार',
        'Only for ArticleCreate event' => 'कार्यक्रम केवल अनुच्छेद बनाने के लिए',
        'Article sender type' => '',
        'Subject match' => 'विषय मिलान',
        'Body match' => 'मुख्य-भाग मिलान',
        'Include attachments to notification' => 'अधिसूचना में संलग्नक शामिल करें',
        'Notification article type' => 'अधिसूचना अनुच्छेद के प्रकार',
        'Only for notifications to specified email addresses' => 'केवल निर्दिष्ट ईमेल पतों के लिए अधिसूचना',
        'To get the first 20 character of the subject (of the latest agent article).' =>
            'विषय के पहले 20 वर्ण (नवीनतम प्रतिनिधि अनुच्छेद में से) प्राप्त करने के लिए।',
        'To get the first 5 lines of the body (of the latest agent article).' =>
            'मुख्य-भाग (नवीनतम प्रतिनिधि अनुच्छेद में से एक) के पहले 5 लाइनें प्राप्त करने के लिए।',
        'To get the first 20 character of the subject (of the latest customer article).' =>
            'विषय के पहले 20 वर्ण (नवीनतम ग्राहक अनुच्छेद में से) प्राप्त करने के लिए।',
        'To get the first 5 lines of the body (of the latest customer article).' =>
            'मुख्य-भाग (नवीनतम ग्राहक अनुच्छेद  के) के पहले 5 लाइनें प्राप्त करने के लिए।',

        # Template: AdminPGP
        'PGP Management' => 'PGP प्रबंधन',
        'Use this feature if you want to work with PGP keys.' => 'इस सुविधा का उपयोग करें यदि आप PGP कुंजी के साथ काम करना चाहते हैं।',
        'Add PGP key' => 'PGP कुंजी जोड़ें',
        'In this way you can directly edit the keyring configured in SysConfig.' =>
            'इस तरह आपको सीधे प्रणाली विन्यास में विन्यस्त कुंजीरिंग संपादित कर सकते हैं।',
        'Introduction to PGP' => 'PGP के लिए परिचय',
        'Result' => 'परिणाम',
        'Identifier' => 'पहचानकर्ता',
        'Bit' => 'थोड़ा',
        'Fingerprint' => 'अंगुली-चिह्न',
        'Expires' => 'समय सीमा समाप्त',
        'Delete this key' => 'इस कुंजी को हटाएँ',
        'Add PGP Key' => 'PGP कुंजी जोड़ें',
        'PGP key' => 'PGP कुंजी',

        # Template: AdminPackageManager
        'Package Manager' => 'संकुल प्रबंधक',
        'Uninstall package' => 'संकुल जिनकी स्थापना रद्द हॊ गयी है',
        'Do you really want to uninstall this package?' => 'क्या आप वास्तव में इस संकुल की स्थापना रद्द करना चाहते हैं?',
        'Reinstall package' => 'संकुल की पुनर्स्थापना',
        'Do you really want to reinstall this package? Any manual changes will be lost.' =>
            'क्या आप वास्तव में इस संकुल की पुनर्स्थापना करना चाहते हैं?सभी हस्तचालित परिवर्तन लुप्त हो जाएंगे।',
        'Continue' => 'जारी रखें',
        'Install' => 'स्थापित',
        'Install Package' => 'संकुल स्थापित करें',
        'Update repository information' => 'कोष जानकारी अद्यतन करें',
        'Did not find a required feature? OTRS Group provides their service contract customers with exclusive Add-Ons:' =>
            '',
        'Online Repository' => 'ऑनलाइन कोष',
        'Vendor' => 'विक्रेता',
        'Module documentation' => 'मॉड्यूल दस्तावेज',
        'Upgrade' => 'उन्नयन',
        'Local Repository' => 'स्थानीय कोष',
        'Uninstall' => 'स्थापना रद्द',
        'Reinstall' => 'पुनर्स्थापना',
        'Feature Add-Ons' => '',
        'Download package' => 'संकुल डाउनलोड करें ',
        'Rebuild package' => 'संकुल फिर से बनाएँ',
        'Metadata' => 'मेटाडेटा',
        'Change Log' => 'अभिलेख बदलना',
        'Date' => 'दिनांक',
        'List of Files' => 'फाइलों की सूची',
        'Permission' => 'अनुमति',
        'Download' => 'डाउनलोड करें',
        'Download file from package!' => 'संकुल से फ़ाइल डाउनलोड करें ',
        'Required' => 'आवश्यकता',
        'PrimaryKey' => 'प्राथमिक कुंजी',
        'AutoIncrement' => 'स्वत वृद्धि',
        'SQL' => 'SQL',
        'File differences for file %s' => 'फ़ाइल %s के लिए फ़ाइल अंतर',

        # Template: AdminPerformanceLog
        'Performance Log' => 'प्रदर्शन अभिलेख',
        'This feature is enabled!' => 'यह सुविधा सक्षम है',
        'Just use this feature if you want to log each request.' => 'इस सुविधा का प्रयोग करें यदि आप प्रत्येक अनुरोध का अभिलेख चाहते हैं।',
        'Activating this feature might affect your system performance!' =>
            'यह सुविधा सक्रिय होनॆ पर आपके प्रणाली के प्रदर्शन को प्रभावित कर सकता।',
        'Disable it here!' => 'यहाँ निष्क्रिय करें',
        'Logfile too large!' => 'अभिलेख फ़ाइल बहुत बड़ा है',
        'The logfile is too large, you need to reset it' => 'अभिलेख फ़ाइल बहुत बड़ा है,इसे पुनर्स्थापित करनॆ की आवश्यकता हैं।',
        'Overview' => 'अवलोकन',
        'Range' => 'सीमा',
        'Interface' => 'अंतरफलक',
        'Requests' => 'अनुरोध',
        'Min Response' => 'न्यूनतम प्रतिक्रिया',
        'Max Response' => 'अधिकतम प्रतिक्रिया',
        'Average Response' => 'औसत प्रतिक्रिया',
        'Period' => 'अवधि',
        'Min' => 'न्यूनतम',
        'Max' => 'अधिकत',
        'Average' => 'औसत',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => 'डाकपाल निस्पादक प्रबंधन',
        'Add filter' => 'निस्पादक जोड़ें',
        'To dispatch or filter incoming emails based on email headers. Matching using Regular Expressions is also possible.' =>
            ' ईमेल शीर्षक के आधार पर आने वाली ईमेल को प्रेषण या निस्पादक करने के लिए। नियमित भाव सॆ भी मिलान संभव है।',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' =>
            'यदि आप केवल ईमेल पते का मिलान करना चाहते हैं,तो से,प्रति या प्रतिलिपिसे में EMAILADDRESinfo@example.com का उपयोग करें।',
        'If you use Regular Expressions, you also can use the matched value in () as [***] in the \'Set\' action.' =>
            'यदि आप नियमित भाव का उपयोग करें,तो आप \निर्धारित करें\ कार्रवाई में जो मिलान मान () में है उसॆ [***] के रूप में उपयोग कर सकते हैं।',
        'Delete this filter' => 'इस निस्पादक को हटाएँ',
        'Add PostMaster Filter' => 'डाकपाल निस्पादक जोड़ें',
        'Edit PostMaster Filter' => 'डाकपाल निस्पादक को संपादित करें',
        'Filter name' => 'निस्पादक का नाम',
        'The name is required.' => '',
        'Stop after match' => 'मिलान के बाद स्र्कें',
        'Filter Condition' => 'निस्पादक की शर्त',
        'The field needs to be a valid regular expression or a literal word.' =>
            '',
        'Set Email Headers' => 'ईमेल शीर्षक निर्धारित करें',
        'The field needs to be a literal word.' => '',

        # Template: AdminPriority
        'Priority Management' => 'प्राथमिकता प्रबंधन',
        'Add priority' => 'प्राथमिकता जोड़ें',
        'Add Priority' => 'प्राथमिकता जोड़ें',
        'Edit Priority' => 'प्राथमिकता संपादित करें ',

        # Template: AdminProcessManagement
        'Process Management' => '',
        'Filter for Processes' => '',
        'Filter' => 'निस्पादक',
        'Process Name' => '',
        'Create New Process' => '',
        'Synchronize All Processes' => '',
        'Configuration import' => '',
        'Here you can upload a configuration file to import a process to your system. The file needs to be in .yml format as exported by process management module.' =>
            '',
        'Upload process configuration' => '',
        'Import process configuration' => '',
        'To create a new Process you can either import a Process that was exported from another system or create a complete new one.' =>
            '',
        'Changes to the Processes here only affect the behavior of the system, if you synchronize the Process data. By synchronizing the Processes, the newly made changes will be written to the Configuration.' =>
            '',
        'Processes' => '',
        'Process name' => '',
        'Copy' => '',
        'Print' => 'मुद्रित करें',
        'Export Process Configuration' => '',
        'Copy Process' => '',

        # Template: AdminProcessManagementActivity
        'Cancel & close window' => 'रद्द करें और विंडो बंद करें',
        'Go Back' => '',
        'Please note, that changing this activity will affect the following processes' =>
            '',
        'Activity' => '',
        'Activity Name' => '',
        'Activity Dialogs' => '',
        'You can assign Activity Dialogs to this Activity by dragging the elements with the mouse from the left list to the right list.' =>
            '',
        'Ordering the elements within the list is also possible by drag \'n\' drop.' =>
            '',
        'Filter available Activity Dialogs' => '',
        'Available Activity Dialogs' => '',
        'Create New Activity Dialog' => '',
        'Assigned Activity Dialogs' => '',
        'As soon as you use this button or link, you will leave this screen and its current state will be saved automatically. Do you want to continue?' =>
            '',

        # Template: AdminProcessManagementActivityDialog
        'Please note that changing this activity dialog will affect the following activities' =>
            '',
        'Activity Dialog' => '',
        'Activity dialog Name' => '',
        'Available in' => '',
        'Description (short)' => '',
        'Description (long)' => '',
        'The selected permission does not exist.' => '',
        'Required Lock' => '',
        'The selected required lock does not exist.' => '',
        'Submit Advice Text' => '',
        'Submit Button Text' => '',
        'Fields' => '',
        'You can assign Fields to this Activity Dialog by dragging the elements with the mouse from the left list to the right list.' =>
            '',
        'Filter available fields' => '',
        'Available Fields' => '',
        'Assigned Fields' => '',
        'Edit Details for Field' => '',
        'ArticleType' => '',
        'Display' => '',
        'Edit Field Details' => '',
        'Customer interface does not support internal article types.' => '',

        # Template: AdminProcessManagementPath
        'Path' => '',
        'Edit this transition' => '',
        'Transition Actions' => '',
        'You can assign Transition Actions to this Transition by dragging the elements with the mouse from the left list to the right list.' =>
            '',
        'Filter available Transition Actions' => '',
        'Available Transition Actions' => '',
        'Create New Transition Action' => '',
        'Assigned Transition Actions' => '',

        # Template: AdminProcessManagementPopupResponse

        # Template: AdminProcessManagementProcessAccordion
        'Activities' => '',
        'Filter Activities...' => '',
        'Create New Activity' => '',
        'Filter Activity Dialogs...' => '',
        'Transitions' => '',
        'Filter Transitions...' => '',
        'Create New Transition' => '',
        'Filter Transition Actions...' => '',

        # Template: AdminProcessManagementProcessEdit
        'Edit Process' => '',
        'Print process information' => '',
        'Delete Process' => '',
        'Delete Inactive Process' => '',
        'Available Process Elements' => '',
        'The Elements listed above in this sidebar can be moved to the canvas area on the right by using drag\'n\'drop.' =>
            '',
        'You can place Activities on the canvas area to assign this Activity to the Process.' =>
            '',
        'To assign an Activity Dialog to an Activity drop the Activity Dialog element from this sidebar over the Activity placed in the canvas area.' =>
            '',
        'You can start a connection between to Activities by dropping the Transition element over the Start Activity of the connection. After that you can move the loose end of the arrow to the End Activity.' =>
            '',
        'Actions can be assigned to a Transition by dropping the Action Element onto the label of a Transition.' =>
            '',
        'Edit Process Information' => '',
        'The selected state does not exist.' => '',
        'Add and Edit Activities, Activity Dialogs and Transitions' => '',
        'Show EntityIDs' => '',
        'Extend the width of the Canvas' => '',
        'Extend the height of the Canvas' => '',
        'Remove the Activity from this Process' => '',
        'Edit this Activity' => '',
        'Do you really want to delete this Process?' => '',
        'Do you really want to delete this Activity?' => '',
        'Do you really want to delete this Activity Dialog?' => '',
        'Do you really want to delete this Transition?' => '',
        'Do you really want to delete this Transition Action?' => '',
        'Do you really want to remove this activity from the canvas? This can only be undone by leaving this screen without saving.' =>
            '',
        'Do you really want to remove this transition from the canvas? This can only be undone by leaving this screen without saving.' =>
            '',
        'Hide EntityIDs' => '',
        'Delete Entity' => '',
        'Remove Entity from canvas' => '',
        'This Activity is already used in the Process. You cannot add it twice!' =>
            '',
        'This Activity cannot be deleted because it is the Start Activity.' =>
            '',
        'This Transition is already used for this Activity. You cannot use it twice!' =>
            '',
        'This TransitionAction is already used in this Path. You cannot use it twice!' =>
            '',
        'Remove the Transition from this Process' => '',
        'No TransitionActions assigned.' => '',
        'The Start Event cannot loose the Start Transition!' => '',
        'No dialogs assigned yet. Just pick an activity dialog from the list on the left and drag it here.' =>
            '',
        'An unconnected transition is already placed on the canvas. Please connect this transition first before placing another transition.' =>
            '',

        # Template: AdminProcessManagementProcessNew
        'In this screen, you can create a new process. In order to make the new process available to users, please make sure to set its state to \'Active\' and synchronize after completing your work.' =>
            '',

        # Template: AdminProcessManagementProcessPrint
        'Start Activity' => '',
        'Contains %s dialog(s)' => '',
        'Assigned dialogs' => '',
        'Activities are not being used in this process.' => '',
        'Assigned fields' => '',
        'Activity dialogs are not being used in this process.' => '',
        'Condition linking' => '',
        'Conditions' => '',
        'Condition' => '',
        'Transitions are not being used in this process.' => '',
        'Module name' => '',
        'Configuration' => '',
        'Transition actions are not being used in this process.' => '',

        # Template: AdminProcessManagementTransition
        'Please note that changing this transition will affect the following processes' =>
            '',
        'Transition' => '',
        'Transition Name' => '',
        'Type of Linking between Conditions' => '',
        'Remove this Condition' => '',
        'Type of Linking' => '',
        'Remove this Field' => '',
        'Add a new Field' => '',
        'Add New Condition' => '',

        # Template: AdminProcessManagementTransitionAction
        'Please note that changing this transition action will affect the following processes' =>
            '',
        'Transition Action' => '',
        'Transition Action Name' => '',
        'Transition Action Module' => '',
        'Config Parameters' => '',
        'Remove this Parameter' => '',
        'Add a new Parameter' => '',

        # Template: AdminQueue
        'Manage Queues' => 'श्रेणी का प्रबंधन करें',
        'Add queue' => 'श्रेणी जोड़ें',
        'Add Queue' => 'श्रेणी जोड़ें',
        'Edit Queue' => 'श्रेणी को संपादित करें',
        'Sub-queue of' => 'की उप-श्रेणी',
        'Unlock timeout' => 'अनलॉक समय समाप्त',
        '0 = no unlock' => '0 = कोई अनलॉक  नहीं',
        'Only business hours are counted.' => 'केवल व्यापार घंटे गिने जाते हैं।',
        'If an agent locks a ticket and does not close it before the unlock timeout has passed, the ticket will unlock and will become available for other agents.' =>
            'यदि एक प्रतिनिधि टिकट को लॉक करता है और अनलॉक समय समाप्ति बीत जानॆ से पहले उसे बंद नहीं करता है, टिकट अनलॉक हो जाएगा और अन्य प्रतिनिधियॊ के लिए उपलब्ध हो जाएगा।',
        'Notify by' => 'के द्वारा सूचित करें',
        '0 = no escalation' => '0 = कोई संवर्धित नहीं',
        'If there is not added a customer contact, either email-external or phone, to a new ticket before the time defined here expires, the ticket is escalated.' =>
            'यदि यहां परिभाषित समय समाप्त होनॆ से पहले टिकट को यदि एक ग्राहक संपर्क नहीं जोड़ा जाता है,या तो बाहरी-ईमेल या फोन भी नहीं जोड़ा जाता है,तो टिकट संवर्धित हो जाएगा।',
        'If there is an article added, such as a follow-up via email or the customer portal, the escalation update time is reset. If there is no customer contact, either email-external or phone, added to a ticket before the time defined here expires, the ticket is escalated.' =>
            'यदि एक अनुच्छेद जोड़ा जाए,जैसे कोई अनुवर्ती ईमेल या ग्राहक पोर्टल के माध्यम से,वृद्धि अद्यतन समय पुनर्स्थापित हो जाता है। यदि यहां परिभाषित समय समाप्त होनॆ से पहले टिकट को यदि एक ग्राहक संपर्क नहीं जोड़ा जाता है,या तो बाहरी-ईमेल या फोन भी नहीं जोड़ा जाता है,तो टिकट संवर्धित हो जाएगा। ',
        'If the ticket is not set to closed before the time defined here expires, the ticket is escalated.' =>
            'यदि टिकट बंद को स्थापित नहीं है यहां परिभाषित समय समाप्त होनॆ से पहले,तो टिकट संवर्धित हो जाएगा।',
        'Follow up Option' => 'निगरानी विकल्प',
        'Specifies if follow up to closed tickets would re-open the ticket, be rejected or lead to a new ticket.' =>
            'यह निर्दिष्ट करता है की यदि बंद टिकट को निगरानी विकल्प दिया जाए तो वह टिकट को पुनः खोल सकता है,अस्वीकार कर सकता है या एक नए टिकट को बना सकता है।',
        'Ticket lock after a follow up' => 'टिकट लॉक निगरानी के बाद ',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked to the old owner.' =>
            'यदि एक टिकट बंद है और ग्राहक एक अनुवर्ती भेजता है तो टिकट पुराने स्वामी को लॉक कर दिया जायेगा।',
        'System address' => 'प्रणाली का पता',
        'Will be the sender address of this queue for email answers.' => 'ईमेल के जवाब के लिए इस श्रेणी में प्रेषक का पता होगा।',
        'Default sign key' => 'तयशुदा हस्ताक्षर कुंजी',
        'The salutation for email answers.' => 'ईमेल उत्तर के लिए अभिवादन।',
        'The signature for email answers.' => 'ईमेल उत्तर के लिए हस्ताक्षर।',

        # Template: AdminQueueAutoResponse
        'Manage Queue-Auto Response Relations' => 'श्रेणी-स्वतप्रतिक्रिया संबंधों का प्रबंधन करें',
        'Filter for Queues' => 'श्रेणी के लिए निस्पादक',
        'Filter for Auto Responses' => 'स्वतप्रतिक्रियाओं के लिए निस्पादक',
        'Auto Responses' => 'स्वत प्रतिक्रियाएँ',
        'Change Auto Response Relations for Queue' => 'श्रेणी के लिए स्वतप्रतिक्रिया संबंधों को बदलॆ',
        'settings' => 'व्यवस्थाऐं',

        # Template: AdminQueueResponses
        'Manage Response-Queue Relations' => 'श्रेणी-प्रतिक्रिया संबंधों का प्रबंधन करें',
        'Filter for Responses' => 'प्रतिक्रियाओं के लिए निस्पादक',
        'Responses' => 'प्रतिक्रियाएँ',
        'Change Queue Relations for Response' => 'श्रेणी संबंधों को प्रतिक्रिया के लिए बदलॆ',
        'Change Response Relations for Queue' => 'श्रेणी के लिए प्रतिक्रिया संबंधों को बदलॆ',

        # Template: AdminResponse
        'Manage Responses' => 'प्रतिक्रियाओं का प्रबंधन करें',
        'Add response' => 'प्रतिक्रिया जोड़ें',
        'A response is a default text which helps your agents to write faster answers to customers.' =>
            '',
        'Don\'t forget to add new responses to queues.' => '',
        'Delete this entry' => 'इस प्रविष्टि को हटाएँ',
        'Add Response' => 'प्रतिक्रिया जोड़ें',
        'Edit Response' => 'प्रतिक्रिया संपादित करें',
        'The current ticket state is' => 'वर्तमान टिकट की स्थिति है ',
        'Your email address is' => 'आपका ईमेल पता है',

        # Template: AdminResponseAttachment
        'Manage Responses <-> Attachments Relations' => 'प्रतिक्रिया<->संलग्नक संबंधों का प्रबंधन करें',
        'Filter for Attachments' => 'संलग्नक के लिए निस्पादक',
        'Change Response Relations for Attachment' => 'संलग्नक के लिए प्रतिक्रिया संबंधों को बदलॆ',
        'Change Attachment Relations for Response' => 'संलग्नक संबंधों को प्रतिक्रिया के लिए बदलॆ',
        'Toggle active for all' => 'सभी के लिए स्विच सक्रिय करें',
        'Link %s to selected %s' => 'लिंक %s को चयनित %s',

        # Template: AdminRole
        'Role Management' => 'भूमिका प्रबंधन',
        'Add role' => 'भूमिका जोड़ें',
        'Create a role and put groups in it. Then add the role to the users.' =>
            'एक भूमिका बनाएँ और समूहों को उसमें डालॆ। फिर भूमिका को उपयोगकर्ताओं से जोड़ें।',
        'There are no roles defined. Please use the \'Add\' button to create a new role.' =>
            'वहाँ कोई परिभाषित भूमिकाएं नहीं है। कृपया \'जोड़ें \' बटन का उपयोग करें नई भूमिका बनाने के लिए।',
        'Add Role' => 'भूमिका जोड़ें',
        'Edit Role' => 'भूमिका संपादित करें',

        # Template: AdminRoleGroup
        'Manage Role-Group Relations' => 'भूमिका-समूह संबंधों का प्रबंधन करें',
        'Filter for Roles' => 'भूमिकाओं के लिए निस्पादक',
        'Roles' => 'भूमिकाएं',
        'Select the role:group permissions.' => 'भूमिका:समूह अनुमतियों का चयन करें',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the role).' =>
            'अगर कुछ भी चयनित नहीं है,तो फिर इस समूह में कोई अनुमतियाँ नहीं हैं(टिकट भूमिका के लिए उपलब्ध नहीं होंगे)।',
        'Change Role Relations for Group' => 'समूह के लिए भूमिका संबंधों को बदलॆ',
        'Change Group Relations for Role' => 'समूह संबंधों को भूमिका  के लिए बदलॆ',
        'Toggle %s permission for all' => 'स्विच %s सभी के लिए अनुमति है',
        'move_into' => 'में स्थानांतरित',
        'Permissions to move tickets into this group/queue.' => 'इस समूह/श्रेणी में टिकट स्थानांतरित करने के लिए अनुमतियाँ।',
        'create' => 'बनाने के लिए',
        'Permissions to create tickets in this group/queue.' => 'इस समूह/श्रेणी में टिकट बनाने के लिए करने के लिए अनुमतियाँ।',
        'priority' => 'प्राथमिकता',
        'Permissions to change the ticket priority in this group/queue.' =>
            'इस समूह/श्रेणी में टिकट की प्राथमिकता बदलने के लिए अनुमतियाँ।',

        # Template: AdminRoleUser
        'Manage Agent-Role Relations' => 'प्रतिनिधि-भूमिका संबंधों का प्रबंधन करें',
        'Filter for Agents' => 'प्रतिनिधियॊ के लिए निस्पादक',
        'Agents' => 'प्रतिनिधियॊ',
        'Manage Role-Agent Relations' => 'भूमिका-प्रतिनिधि संबंधों का प्रबंधन करें',
        'Change Role Relations for Agent' => 'प्रतिनिधि के लिए भूमिका संबंधों को बदलॆ',
        'Change Agent Relations for Role' => 'प्रतिनिधि संबंधों को भूमिका  के लिए बदलॆ',

        # Template: AdminSLA
        'SLA Management' => 'SLA प्रबंधन',
        'Add SLA' => 'SLA जोड़ें',
        'Edit SLA' => 'SLA संपादित करें',
        'Please write only numbers!' => 'केवल संख्याएँ लिखें',

        # Template: AdminSMIME
        'S/MIME Management' => 'S/MIME प्रबंधन',
        'Add certificate' => 'प्रमाणपत्र जोड़ें',
        'Add private key' => 'निजी कुंजी जोड़ें',
        'Filter for certificates' => '',
        'Filter for SMIME certs' => '',
        'Here you can add relations to your private certificate, these will be embedded to the SMIME signature every time you use this certificate to sign an email.' =>
            '',
        'See also' => 'यह भी देखें',
        'In this way you can directly edit the certification and private keys in file system.' =>
            'इस तरह आप सीधे प्रमाणीकरण और फाइल प्रणाली में निजी कुंजी संपादित कर सकते हैं।',
        'Hash' => '',
        'Create' => 'बनाएँ',
        'Handle related certificates' => '',
        'Read certificate' => '',
        'Delete this certificate' => 'इस प्रमाणपत्र को हटाएँ',
        'Add Certificate' => 'प्रमाणपत्र जोड़ें',
        'Add Private Key' => 'निजी कुंजी जोड़ें',
        'Secret' => 'गोपनीय',
        'Related Certificates for' => '',
        'Delete this relation' => '',
        'Available Certificates' => '',
        'Relate this certificate' => '',

        # Template: AdminSMIMECertRead
        'SMIME Certificate' => '',
        'Close window' => 'विंडो बंद करें',

        # Template: AdminSalutation
        'Salutation Management' => 'अभिवादन प्रबंधन',
        'Add salutation' => 'अभिवादन जोड़ें ',
        'Add Salutation' => 'अभिवादन जोड़ें ',
        'Edit Salutation' => 'अभिवादन संपादित करें',
        'Example salutation' => 'अभिवादन के उदाहरण',

        # Template: AdminScheduler
        'This option will force Scheduler to start even if the process is still registered in the database' =>
            '',
        'Start scheduler' => '',
        'Scheduler could not be started. Check if scheduler is not running and try it again with Force Start option' =>
            '',

        # Template: AdminSecureMode
        'Secure mode needs to be enabled!' => 'सुरक्षित मोड को सक्रिय करने की जरूरत हैं।',
        'Secure mode will (normally) be set after the initial installation is completed.' =>
            'सुरक्षित मोड (सामान्य रूप से)प्रारंभिक स्थापना पूरी होनॆ के बाद निर्धारित किया जाएगा।',
        'If secure mode is not activated, activate it via SysConfig because your application is already running.' =>
            'यदि सुरक्षित मोड सक्रिय नहीं है,तो उसे प्रणाली विन्यास के माध्यम से सक्रिय करें क्योंकि आपका अनुप्रयोग पहले से चल रहा है।',

        # Template: AdminSelectBox
        'SQL Box' => 'SQL संदूक',
        'Here you can enter SQL to send it directly to the application database.' =>
            'SQL को सीधे अनुप्रयोग डेटाबेस को भेजने के लिए यहाँ दर्ज कर सकते हैं।',
        'The syntax of your SQL query has a mistake. Please check it.' =>
            'आपकी SQL क्वेरी के वाक्यविन्यास मॆ गलती हैं। उसकी जाँच करें।',
        'There is at least one parameter missing for the binding. Please check it.' =>
            'इसमें बंधन के लिए कम से कम गायब एक मापदण्ड है। उसकी जाँच करें।',
        'Result format' => 'परिणाम का स्वरूप',
        'Run Query' => 'क्वेरी चलाएँ',

        # Template: AdminService
        'Service Management' => 'सेवा प्रबंधन',
        'Add service' => 'सेवा जोड़ें',
        'Add Service' => 'सेवा जोड़ें ',
        'Edit Service' => 'सेवा संपादित करें',
        'Sub-service of' => 'की उप-सेवा',

        # Template: AdminSession
        'Session Management' => 'सत्र प्रबंधन',
        'All sessions' => 'सभी सत्रों',
        'Agent sessions' => 'प्रतिनिधि सत्र',
        'Customer sessions' => 'ग्राहक सत्र',
        'Unique agents' => 'अद्वितीय प्रतिनिधि',
        'Unique customers' => 'अद्वितीय ग्राहक',
        'Kill all sessions' => 'सभी सत्रों को नष्ट कर दे',
        'Kill this session' => 'इस सत्र को नष्ट कर दे',
        'Session' => 'सत्र',
        'Kill' => 'नष्ट',
        'Detail View for SessionID' => 'सत्र ID का विस्तार दृश्य',

        # Template: AdminSignature
        'Signature Management' => 'हस्ताक्षर प्रबंधन',
        'Add signature' => 'हस्ताक्षर जोड़ें',
        'Add Signature' => 'हस्ताक्षर जोड़ें',
        'Edit Signature' => 'हस्ताक्षर संपादित करें',
        'Example signature' => 'हस्ताक्षर के उदाहरण',

        # Template: AdminState
        'State Management' => 'स्थिति प्रबंधन',
        'Add state' => 'स्थिति जोड़ें',
        'Please also update the states in SysConfig where needed.' => '',
        'Add State' => 'स्थिति जोड़ें',
        'Edit State' => 'स्थिति संपादित करें',
        'State type' => 'स्थिति के प्रकार',

        # Template: AdminSysConfig
        'SysConfig' => 'प्रणाली विन्यास',
        'Navigate by searching in %s settings' => 'व्यवस्थाऐं %s में खोज कर मार्गनिर्देशन करें',
        'Navigate by selecting config groups' => 'विन्यास समूहों का चयन करके मार्गनिर्देशन करें',
        'Download all system config changes' => 'सभी प्रणाली विन्यास बदलाव डाउनलोड करें',
        'Export settings' => 'व्यवस्थाऐं निर्यात करें',
        'Load SysConfig settings from file' => 'फ़ाइल से प्रणाली विन्यास कि व्यवस्थाऐं लोड करें',
        'Import settings' => 'व्यवस्थाऐं आयात करें',
        'Import Settings' => 'व्यवस्थाऐं आयात करें',
        'Please enter a search term to look for settings.' => 'कृपया एक खोज शब्द दर्ज करें व्यवस्थाऐं देखने के लिए।',
        'Subgroup' => 'उपसमूह',
        'Elements' => 'तत्व',

        # Template: AdminSysConfigEdit
        'Edit Config Settings' => 'विन्यास व्यवस्थाऐं संपादित करें',
        'This config item is only available in a higher config level!' =>
            'यह विन्यास वस्तु केवल उच्च स्तर विन्यास में उपलब्ध है।',
        'Reset this setting' => 'इस व्यवस्था को पुनर्स्थापित करें',
        'Error: this file could not be found.' => 'त्रुटि:यह फ़ाइल को नहीं मिल सकी।',
        'Error: this directory could not be found.' => 'त्रुटि:यह निर्देशिका नहीं मिल सकी।',
        'Error: an invalid value was entered.' => 'त्रुटि:एक अवैध मान दर्ज किया गया था।',
        'Content' => 'अंतर्वस्तु',
        'Remove this entry' => 'इस प्रविष्टि को हटाएँ',
        'Add entry' => 'प्रविष्टि जोड़ें',
        'Remove entry' => 'प्रविष्टि को हटाएँ',
        'Add new entry' => 'नई प्रविष्टि जोड़ें',
        'Create new entry' => 'नई प्रविष्टि बनाएँ',
        'New group' => 'नया समूह',
        'Group ro' => 'केवल पढ़ने के समूह',
        'Readonly group' => 'केवल पढ़ने के समूह',
        'New group ro' => 'केवल पढ़ने के नये समूह',
        'Loader' => 'भारक',
        'File to load for this frontend module' => 'इस दृश्यपटल मॉड्यूल के लिए यह फ़ाइल लोड करें',
        'New Loader File' => 'नई भारक फ़ाइल',
        'NavBarName' => 'संचरण पट्टी का नाम',
        'NavBar' => 'संचरण पट्टी',
        'LinkOption' => 'लिंक विकल्प',
        'Block' => 'खंड',
        'AccessKey' => 'प्रवेश कुंजी',
        'Add NavBar entry' => 'संचरण प्रविष्टि जोड़ें',
        'Year' => 'वर्ष',
        'Month' => 'महीना',
        'Day' => 'दिन',
        'Invalid year' => 'अवैध वर्ष',
        'Invalid month' => 'अवैध महीना',
        'Invalid day' => 'अवैध दिन',

        # Template: AdminSystemAddress
        'System Email Addresses Management' => 'तंत्र ईमेल पते प्रबंधन',
        'Add system address' => 'प्रणाली का पता शामिल करें',
        'All incoming email with this address in To or Cc will be dispatched to the selected queue.' =>
            'प्रति या प्रतिलिपि के इस पते के साथ सभी आने वाली ईमेल को चयनित श्रेणी को भेज दिया जाएगा।',
        'Email address' => 'ईमेल पता',
        'Display name' => 'प्रदर्शित होने वाला नाम',
        'Add System Email Address' => 'प्रणाली का ईमेल पता शामिल करें',
        'Edit System Email Address' => 'प्रणाली का ईमेल पता संपादित करें',
        'The display name and email address will be shown on mail you send.' =>
            'आपके द्वारा भेजे गए मेल पर प्रदर्शित होने वाला नाम और ईमेल पता दिखाया जाएगा।',

        # Template: AdminType
        'Type Management' => 'प्रकार प्रबंधन',
        'Add ticket type' => 'टिकट के प्रकार जोड़ें',
        'Add Type' => 'प्रकार जोड़ें',
        'Edit Type' => 'प्रकार संपादित करें',

        # Template: AdminUser
        'Add agent' => 'प्रतिनिधि जोड़ें',
        'Agents will be needed to handle tickets.' => 'प्रतिनिधियॊ के लिए टिकट संभालना जरूरी हो जाएगा।',
        'Don\'t forget to add a new agent to groups and/or roles!' => 'प्रतिनिधियॊ को समूहों और/या भूमिकाएं सॆ जोड़ना ना भुलॆ।',
        'Please enter a search term to look for agents.' => 'कृपया एक खोज शब्द दर्ज करें प्रतिनिधियॊ को देखने के लिए।',
        'Last login' => 'पिछला प्रवेश',
        'Switch to agent' => 'प्रतिनिधि से बदलें',
        'Add Agent' => 'प्रतिनिधि जोड़ें',
        'Edit Agent' => 'प्रतिनिधि संपादित करें',
        'Firstname' => 'पहला नाम',
        'Lastname' => 'आखिरी नाम',
        'Password is required.' => '',
        'Start' => 'आरंभ',
        'End' => 'समाप्त',

        # Template: AdminUserGroup
        'Manage Agent-Group Relations' => 'प्रतिनिधि-समूह संबंधों का प्रबंधन करें',
        'Change Group Relations for Agent' => 'प्रतिनिधि के लिए समूह संबंधों को बदलॆ',
        'Change Agent Relations for Group' => 'समूह के लिए प्रतिनिधि संबंधों को बदलॆ',
        'note' => 'टिप्पणी',
        'Permissions to add notes to tickets in this group/queue.' => 'इस समूह/श्रेणी मॆ टिकटों को टिप्पणी जोड़ने के लिए अनुमतियाँ।',
        'owner' => 'स्वामी',
        'Permissions to change the owner of tickets in this group/queue.' =>
            'इस समूह/श्रेणी मॆ टिकटों के स्वामी बदलने के लिए अनुमतियाँ।',

        # Template: AgentBook
        'Address Book' => 'पता पुस्तिका',
        'Search for a customer' => 'ग्राहक के लिए खोजें',
        'Add email address %s to the To field' => 'ईमेल पता %s शामिल करें प्रति क्षेत्र मॆ',
        'Add email address %s to the Cc field' => 'ईमेल पता %s शामिल करें प्रतिलिपि क्षेत्र मॆ',
        'Add email address %s to the Bcc field' => 'ईमेल पता %s शामिल करें गुप्त प्रतिलिपि क्षेत्र मॆ',
        'Apply' => 'लागू करें',

        # Template: AgentCustomerInformationCenter
        'Customer Information Center' => '',

        # Template: AgentCustomerInformationCenterBlank

        # Template: AgentCustomerInformationCenterSearch
        'Customer ID' => 'ग्राहक ID',
        'Customer User' => '',

        # Template: AgentCustomerSearch
        'Search Customer' => 'ग्राहक खोजें',
        'Duplicated entry' => '',
        'This address already exists on the address list.' => '',
        'It is going to be deleted from the field, please try again.' => '',

        # Template: AgentCustomerTableView

        # Template: AgentDashboard
        'Dashboard' => 'नियंत्रण-पट्ट',

        # Template: AgentDashboardCalendarOverview
        'in' => 'में',

        # Template: AgentDashboardCustomerCompanyInformation

        # Template: AgentDashboardCustomerIDStatus
        'Escalated tickets' => '',

        # Template: AgentDashboardCustomerUserList
        'Customer information' => '',
        'Phone ticket' => '',
        'Email ticket' => '',
        '%s open ticket(s) of %s' => '',
        '%s closed ticket(s) of %s' => '',
        'New phone ticket from %s' => '',
        'New email ticket to %s' => '',

        # Template: AgentDashboardIFrame

        # Template: AgentDashboardImage

        # Template: AgentDashboardProductNotify
        '%s %s is available!' => '%s %s उपलब्ध है',
        'Please update now.' => 'कृपया अभी अद्यतन करें',
        'Release Note' => 'प्रकाशन टिप्पणी',
        'Level' => 'स्तर',

        # Template: AgentDashboardRSSOverview
        'Posted %s ago.' => '%s पहले प्रस्तुत।',

        # Template: AgentDashboardTicketGeneric
        'My locked tickets' => '',
        'My watched tickets' => '',
        'My responsibilities' => '',
        'Tickets in My Queues' => '',

        # Template: AgentDashboardTicketStats

        # Template: AgentDashboardUserOnline
        'out of office' => '',

        # Template: AgentDashboardUserOutOfOffice
        'until' => '',

        # Template: AgentHTMLReferenceForms

        # Template: AgentHTMLReferenceOverview

        # Template: AgentHTMLReferencePageLayout
        'The ticket has been locked' => 'टिकट के लॉक कर दिया गया है',
        'Undo & close window' => 'पूर्ववत करें और विंडो बंद करें',

        # Template: AgentInfo
        'Info' => 'जानकारी',
        'To accept some news, a license or some changes.' => 'किसी समाचार,लाइसेंस या कुछ बदलाव स्वीकार करने के लिए।',

        # Template: AgentLinkObject
        'Link Object: %s' => 'लिंक वस्तु: %s',
        'go to link delete screen' => 'लिंक नष्ट स्क्रीन पर जाने के लिए',
        'Select Target Object' => 'लक्ष्य वस्तु चयन करें',
        'Link Object' => 'लिंक वस्तु',
        'with' => 'के साथ',
        'Unlink Object: %s' => 'अनलिंक वस्तु: %s',
        'go to link add screen' => 'लिंक स्क्रीन जोड़ें पर जाने के लिए',

        # Template: AgentNavigationBar

        # Template: AgentPreferences
        'Edit your preferences' => 'अपनी वरीयताएँ संपादित करें',

        # Template: AgentSpelling
        'Spell Checker' => 'वर्तनी परीक्षक',
        'spelling error(s)' => 'वर्तनी त्रुटि (ओं)',
        'Apply these changes' => 'इन परिवर्तनों को लागू करें',

        # Template: AgentStatsDelete
        'Delete stat' => 'आँकड़े हटाएँ',
        'Stat#' => '',
        'Do you really want to delete this stat?' => 'क्या आप वास्तव में यह आँकड़े हटाना चाहते हैं?',

        # Template: AgentStatsEditRestrictions
        'Step %s' => 'चरण %s',
        'General Specifications' => 'सामान्य निर्दिष्टीकरण',
        'Select the element that will be used at the X-axis' => 'X-अक्ष पर इस्तेमाल किया जानॆवाला तत्व चुनें',
        'Select the elements for the value series' => 'मान श्रृंखला के लिए तत्वों का चयन करें',
        'Select the restrictions to characterize the stat' => 'आँकड़ॊ की विशेषताऔ पर लगनॆ वालॆ प्रतिबंधों को चुनें',
        'Here you can make restrictions to your stat.' => 'यहां आप अपने आँकड़ॊ पर प्रतिबंध बना सकते हैं।',
        'If you remove the hook in the "Fixed" checkbox, the agent generating the stat can change the attributes of the corresponding element.' =>
            'यदि आप "निश्चित"निशानबक्से के हुक हटा दॆ,आँकड़े बनानॆ वाला प्रतिनिधि संबंधित तत्व के गुणों को बदल सकता हैं।',
        'Fixed' => 'निश्चित',
        'Please select only one element or turn off the button \'Fixed\'.' =>
            'कृपया केवल एक ही तत्व का चयन करें या "निश्चित" बटन बंद करें।',
        'Absolute Period' => 'निरपेक्ष अवधि',
        'Between' => 'के बीच',
        'Relative Period' => 'सापेक्ष अवधि',
        'The last' => 'अंतिम',
        'Finish' => 'खत्म',

        # Template: AgentStatsEditSpecification
        'Permissions' => 'अनुमतियाँ',
        'You can select one or more groups to define access for different agents.' =>
            'आप एक या अधिक समूहों का चयन करके विभिन्न प्रतिनिधियॊ के लिए उपयोग निर्धारित कर सकते हैं।',
        'Some result formats are disabled because at least one needed package is not installed.' =>
            'कुछ परिणाम प्रारूप निष्क्रिय है क्योंकि कोई एक आवश्यक संकुल स्थापित नहीं है।',
        'Please contact your administrator.' => 'कृपया अपने व्यवस्थापक से संपर्क करें।',
        'Graph size' => 'रेखा-चित्र का आकार',
        'If you use a graph as output format you have to select at least one graph size.' =>
            'यदि आपने आउटपुट स्वरूप के रूप में रेखा-चित्र का उपयोग किया है तो कम से कम एक रेखा-चित्र आकार का चयन किजिए।',
        'Sum rows' => 'पंक्ति योग',
        'Sum columns' => 'स्तंभ योग',
        'Use cache' => 'द्रुतिका उपयोग करें',
        'Most of the stats can be cached. This will speed up the presentation of this stat.' =>
            'आँकड़े अधिकांश संचित कियॆ जा सकतॆ है।यह इस आँकड़े की प्रस्तुति कॊ गति देगा।',
        'If set to invalid end users can not generate the stat.' => 'यदि अवैध अंत उपयोगकर्ताओं के लिए निर्धारित तॊ आँकड़े उत्पन्न नहीं कर सकते।',

        # Template: AgentStatsEditValueSeries
        'Here you can define the value series.' => 'यहाँ आप मान श्रृंखला परिभाषित कर सकते हैं।',
        'You have the possibility to select one or two elements.' => 'एक या दो तत्वों का चयन करने की संभावना है।',
        'Then you can select the attributes of elements.' => 'तो आप तत्वों की विशेषताओं का चयन कर सकते।',
        'Each attribute will be shown as single value series.' => 'प्रत्येक विशेषता एकल मान श्रृंखला के रूप में दिखाया जाएगा।',
        'If you don\'t select any attribute all attributes of the element will be used if you generate a stat, as well as new attributes which were added since the last configuration.' =>
            'यदि आप किसी गुण का चयन नहीं करते हैं तॊ आँकड़े उत्पन्न करनॆ मॆ तत्व के सभी गुणों को इस्तेमाल किया जाएगा,साथ ही नये गुणों है जो पिछले विन्यास के बाद से जोड़ा गया था।',
        'Scale' => 'मापक',
        'minimal' => 'अल्पतम',
        'Please remember, that the scale for value series has to be larger than the scale for the X-axis (e.g. X-Axis => Month, ValueSeries => Year).' =>
            'कृपया याद रखें,कि मान श्रृंखला का मापक X-अक्ष के लिए मापक से भी बड़ा होना चाहीए(उदा:X-अक्ष =>महीना,मानश्रृंखला =>वर्ष)।',

        # Template: AgentStatsEditXaxis
        'Here you can define the x-axis. You can select one element via the radio button.' =>
            'यहाँ आप x-अक्ष परिभाषित कर सकते हैं।आप रेडियो बटन के माध्यम से एक तत्व का चयन कर सकते हैं।',
        'maximal period' => 'अधिकतम अवधि',
        'minimal scale' => 'न्यूनतम स्तर',

        # Template: AgentStatsImport
        'Import Stat' => 'आँकड़े आयात करें',
        'File is not a Stats config' => 'फ़ाइल एक विन्यास आँकड़ा नहीं है',
        'No File selected' => 'कोई भी फ़ाइल चयनित नहीं',

        # Template: AgentStatsOverview
        'Stats' => 'आँकड़ा',

        # Template: AgentStatsPrint
        'No Element selected.' => 'कोई भी तत्व चयनित नहीं',

        # Template: AgentStatsView
        'Export config' => 'विन्यास निर्यात करें',
        'With the input and select fields you can influence the format and contents of the statistic.' =>
            'इनपुट का चयन करें और क्षेत्रों के साथ आप प्रारूप और आँकड़ों की सामग्री को प्रभावित कर सकते हैं।',
        'Exactly what fields and formats you can influence is defined by the statistic administrator.' =>
            'वास्तव में आप जिन क्षेत्र और स्वरूपों को प्रभावित कर सकते हैं वो आँकड़ा व्यवस्थापक द्वारा परिभाषित किया गया है।',
        'Stat Details' => 'आँकड़ॊ का विवरण',
        'Format' => 'प्रारूप',
        'Graphsize' => 'रेखा-चित्र का आकार',
        'Cache' => 'द्रुतिका',
        'Exchange Axis' => 'विनिमय अक्ष',
        'Configurable params of static stat' => 'स्थिर आँकड़ॊ के विन्यास मापदंड',
        'No element selected.' => 'कोई भी तत्व चयनित नहीं',
        'maximal period from' => 'अधिकतम अवधि से',
        'to' => 'के लिए',

        # Template: AgentTicketActionCommon
        'Change Free Text of Ticket' => 'टिकट का मुक्त पाठ बदलें',
        'Change Owner of Ticket' => 'टिकट के स्वामी बदलें',
        'Close Ticket' => 'टिकट बंद करें',
        'Add Note to Ticket' => 'टिकट के लिए टिप्पणी जोड़ें',
        'Set Pending' => 'विचाराधीन निर्धारित करें',
        'Change Priority of Ticket' => 'टिकट की प्राथमिकता बदलें',
        'Change Responsible of Ticket' => 'टिकट के उत्तरदायी बदलें',
        'Service invalid.' => 'अवैध सेवा।',
        'New Owner' => 'नया स्वामी',
        'Please set a new owner!' => 'कृपया नया स्वामी सेट करें',
        'Previous Owner' => 'पिछला स्वामी',
        'Inform Agent' => 'प्रतिनिधि को सूचित करें ',
        'Optional' => 'ऐच्छिक',
        'Inform involved Agents' => 'शामिल प्रतिनिधियॊ को सूचित करें',
        'Spell check' => 'वर्तनी की जाँच',
        'Note type' => 'टिप्पणी प्रकार',
        'Next state' => 'अगली स्थिति',
        'Pending date' => 'विचाराधीन दिनांक',
        'Date invalid!' => 'अवैध दिनांक',

        # Template: AgentTicketActionPopupClose

        # Template: AgentTicketBounce
        'Bounce Ticket' => '',
        'Bounce to' => 'फलांग तक',
        'You need a email address.' => 'आपको ईमेल पते की आवश्यकता।',
        'Need a valid email address or don\'t use a local email address.' =>
            'एक मान्य ईमेल पता की आवश्यकता है या एक स्थानीय ईमेल पते का उपयोग मत किजिए।',
        'Next ticket state' => 'टिकट की अगली स्थिति',
        'Inform sender' => 'प्रेषक को सूचित करें',
        'Send mail!' => 'मेल भेजें',

        # Template: AgentTicketBulk
        'Ticket Bulk Action' => 'टिकट थोक कार्रवाई',
        'Send Email' => '',
        'Merge to' => 'मे मिलाएं',
        'Invalid ticket identifier!' => 'अवैध टिकट पहचानकर्ता',
        'Merge to oldest' => 'पुराने मे मिलाएं',
        'Link together' => 'एक साथ लिंक करें',
        'Link to parent' => 'अभिभावकों के साथ लिंक करें',
        'Unlock tickets' => 'अनलॉक टिकट',

        # Template: AgentTicketClose

        # Template: AgentTicketCompose
        'Compose answer for ticket' => 'टिकट के लिए जवाब लिखें',
        'Remove Ticket Customer' => '',
        'Please remove this entry and enter a new one with the correct value.' =>
            '',
        'Please include at least one recipient' => '',
        'Remove Cc' => '',
        'Remove Bcc' => '',
        'Address book' => 'पता पुस्तिका',
        'Pending Date' => 'विचाराधीन दिनांक',
        'for pending* states' => 'विचाराधीन* स्थिति के लिए',
        'Date Invalid!' => 'अवैध दिनांक',

        # Template: AgentTicketCustomer
        'Change customer of ticket' => 'टिकट के ग्राहक बदलें',
        'Customer user' => 'ग्राहक उपयोगकर्ता',

        # Template: AgentTicketEmail
        'Create New Email Ticket' => 'नई ईमेल टिकट बनाएँ',
        'From queue' => 'श्रेणी से',
        'To customer' => '',
        'Please include at least one customer for the ticket.' => '',
        'Get all' => 'सभी प्राप्त करें',

        # Template: AgentTicketEscalation

        # Template: AgentTicketForward
        'Forward ticket: %s - %s' => '',

        # Template: AgentTicketFreeText

        # Template: AgentTicketHistory
        'History of' => 'का  इतिहास',
        'History Content' => 'इतिहास विषयवस्तु',
        'Zoom view' => 'ज़ूम दृश्य',

        # Template: AgentTicketMerge
        'Ticket Merge' => 'टिकट मिलाएं',
        'You need to use a ticket number!' => 'आपको एक टिकट नंबर का उपयोग आवश्यक है',
        'A valid ticket number is required.' => 'एक वैध टिकट संख्या की आवश्यकता है।',
        'Need a valid email address.' => 'वैध ईमेल पता चाहिए।',

        # Template: AgentTicketMove
        'Move Ticket' => 'टिकट स्थानांतरित करें',
        'New Queue' => 'नई श्रेणी',

        # Template: AgentTicketNote

        # Template: AgentTicketOverviewMedium
        'Select all' => 'सभी का चयन करें',
        'No ticket data found.' => 'कोई टिकट आंकड़ा नहीं मिला',
        'First Response Time' => 'पहला प्रतिक्रिया समय',
        'Service Time' => 'सेवा समय',
        'Update Time' => 'अद्यतन समय',
        'Solution Time' => 'समाधान समय',
        'Move ticket to a different queue' => 'एक अलग श्रेणी में टिकट को ले जाएँ',
        'Change queue' => 'श्रेणी बदलें',

        # Template: AgentTicketOverviewNavBar
        'Change search options' => 'खोज विकल्प बदलें',
        'Tickets per page' => 'टिकट प्रति पृष्ठ',

        # Template: AgentTicketOverviewPreview

        # Template: AgentTicketOverviewSmall
        'Escalation in' => 'में संवर्धित',
        'Locked' => 'लॉकड',

        # Template: AgentTicketOwner

        # Template: AgentTicketPending

        # Template: AgentTicketPhone
        'Create New Phone Ticket' => 'नया फोन टिकट बनाएँ',
        'From customer' => 'ग्राहक से',
        'To queue' => 'श्रेणी में',

        # Template: AgentTicketPhoneCommon
        'Phone call' => 'फोन कॉल',

        # Template: AgentTicketPlain
        'Email Text Plain View' => 'सरल पाठ ईमेल दृश्य',
        'Plain' => 'सरल',
        'Download this email' => 'इस ईमेल को डाउनलोड करें',

        # Template: AgentTicketPrint
        'Ticket-Info' => 'टिकट जानकारी',
        'Accounted time' => 'अकाउंटटेड समय',
        'Linked-Object' => 'लिंक्ड वस्तु',
        'by' => 'द्वारा',

        # Template: AgentTicketPriority

        # Template: AgentTicketProcess
        'Create New Process Ticket' => '',
        'Process' => '',

        # Template: AgentTicketProcessNavigationBar

        # Template: AgentTicketQueue

        # Template: AgentTicketResponsible

        # Template: AgentTicketSearch
        'Search template' => 'टेम्पलेट खोजें',
        'Create Template' => 'टेम्पलेट बनाएँ',
        'Create New' => 'नया बनाएँ',
        'Profile link' => '',
        'Save changes in template' => 'टेम्पलेट में बदलाव सुरक्षित करें',
        'Add another attribute' => 'एक और विशेषता जोड़ें',
        'Output' => 'आउटपुट',
        'Fulltext' => 'पूर्ण पाठ',
        'Remove' => 'हटायें',
        'Searches in the attributes From, To, Cc, Subject and the article body, overriding other attributes with the same name.' =>
            '',
        'Customer User Login' => 'ग्राहक प्रयोक्ता प्रवेश',
        'Created in Queue' => 'श्रेणी में बनाया गया',
        'Lock state' => 'लॉक स्थिति',
        'Watcher' => 'पहरेदार',
        'Article Create Time (before/after)' => 'अनुच्छेद बनाने का समय (के बाद/से पहले)',
        'Article Create Time (between)' => 'अनुच्छेद बनाने का समय (बीच में)',
        'Ticket Create Time (before/after)' => 'टिकट बनाने का समय (के बाद/से पहले)',
        'Ticket Create Time (between)' => 'टिकट बनाने का समय (बीच में)',
        'Ticket Change Time (before/after)' => 'टिकट बदलनॆ का समय (के बाद/से पहले)',
        'Ticket Change Time (between)' => 'टिकट बदलनॆ का समय (बीच में)',
        'Ticket Close Time (before/after)' => 'टिकट बंद होने का समय (के बाद/से पहले)',
        'Ticket Close Time (between)' => 'टिकट बंद होने का समय (बीच में)',
        'Ticket Escalation Time (before/after)' => '',
        'Ticket Escalation Time (between)' => '',
        'Archive Search' => 'संग्रह खोजें',
        'Run search' => '',

        # Template: AgentTicketSearchOpenSearchDescriptionFulltext

        # Template: AgentTicketSearchOpenSearchDescriptionTicketNumber

        # Template: AgentTicketSearchResultPrint

        # Template: AgentTicketZoom
        'Article filter' => 'अनुच्छेद निस्पादक',
        'Article Type' => 'अनुच्छेद प्रकार',
        'Sender Type' => 'प्रेषक का प्रकार',
        'Save filter settings as default' => 'तयशुदा रूप में निस्पादक की व्यवस्थाऐं सुरक्षित करें',
        'Archive' => '',
        'This ticket is archived.' => '',
        'Linked Objects' => 'लिंक्ड वस्तु',
        'Article(s)' => 'अनुच्छेद',
        'Change Queue' => 'श्रेणी बदलें',
        'There are no dialogs available at this point in the process.' =>
            '',
        'This item has no articles yet.' => '',
        'Article Filter' => 'अनुच्छेद निस्पादक',
        'Add Filter' => 'निस्पादक जोड़ें',
        'Set' => 'निर्धारित करें',
        'Reset Filter' => 'निस्पादक को फिर से निर्धारित करें',
        'Show one article' => 'एक अनुच्छेद दिखाएँ',
        'Show all articles' => 'सभी अनुच्छेद दिखाएँ',
        'Unread articles' => 'अपठित अनुच्छेद',
        'No.' => 'संख्या',
        'Unread Article!' => 'अपठित अनुच्छेद',
        'Incoming message' => 'आने वाले संदेश',
        'Outgoing message' => 'जाने वाले संदेश ',
        'Internal message' => 'अंदरूनी संदेश',
        'Resize' => 'आकारबदलें',

        # Template: AttachmentBlocker
        'To protect your privacy, remote content was blocked.' => '',
        'Load blocked content.' => 'लोड विषयवस्तु अवरुद्ध',

        # Template: Copyright

        # Template: CustomerAccept

        # Template: CustomerError
        'Traceback' => 'ट्रेसबैक',

        # Template: CustomerFooter
        'Powered by' => 'द्वारा संचालित',
        'One or more errors occurred!' => 'एक या अधिक त्रुटि आई है',
        'Close this dialog' => 'इस संवाद को बंद करें',
        'Could not open popup window. Please disable any popup blockers for this application.' =>
            'पॉपअप विंडो नहीं खोला जा सकता। कृपया इस अनुप्रयोग के लिए पॉपअप ब्लॉकर्स निष्क्रिय करें।',

        # Template: CustomerFooterSmall

        # Template: CustomerHeader

        # Template: CustomerHeaderSmall

        # Template: CustomerLogin
        'JavaScript Not Available' => 'जावास्क्रिप्ट उपलब्ध नहीं है।',
        'In order to experience OTRS, you\'ll need to enable JavaScript in your browser.' =>
            'OTRS अनुभव करने के लिए,आपको अपने ब्राउज़र में जावास्क्रिप्ट सक्षम करना होगा।',
        'Browser Warning' => 'ब्राउज़र चेतावनी',
        'The browser you are using is too old.' => 'आप जो ब्राउज़र उपयोग कर रहे बहुत पुराना है।',
        'OTRS runs with a huge lists of browsers, please upgrade to one of these.' =>
            'OTRS ब्राउज़रों की एक बड़ी सूची के साथ चलाता है,तो कृपया इनमें से एक को का उन्नयन करे।',
        'Please see the documentation or ask your admin for further information.' =>
            'कृपया अधिक जानकारी के लिए दस्तावेज़ देखे या अपने व्यवस्थापक से पूछे।',
        'Login' => 'प्रवेश',
        'User name' => 'उपयोगकर्ता का नाम',
        'Your user name' => 'आपका उपयोगकर्ता नाम',
        'Your password' => 'आपका कूटशब्द',
        'Forgot password?' => 'कूटशब्द भूल गए?',
        'Log In' => 'प्रवेश',
        'Not yet registered?' => 'अभी तक पंजीकृत नही?',
        'Sign up now' => 'अभी पंजीकरण करें',
        'Request new password' => 'नए कूटशब्द के लिए अनुरोध',
        'Your User Name' => 'आपका उपयोगकर्ता नाम',
        'A new password will be sent to your email address.' => 'एक नया कूटशब्द आपके ईमेल पते पर भेजा जाएगा।',
        'Create Account' => 'खाता बनाएँ',
        'Please fill out this form to receive login credentials.' => '',
        'How we should address you' => 'हम आपको कैसे संबोधित करें',
        'Your First Name' => 'आपका पहला नाम',
        'Your Last Name' => 'आपका आखिरी नाम',
        'Your email address (this will become your username)' => '',

        # Template: CustomerNavigationBar
        'Edit personal preferences' => 'व्यक्तिगत वरीयताएँ संपादित करें',
        'Logout %s' => '',

        # Template: CustomerPreferences

        # Template: CustomerRichTextEditor

        # Template: CustomerTicketMessage
        'Service level agreement' => 'सेवा स्तर अनुबंध',

        # Template: CustomerTicketOverview
        'Welcome!' => 'आपका स्वागत है',
        'Please click the button below to create your first ticket.' => 'अपना पहला टिकट बनाने के लिए कृपया नीचे दिए गए बटन को दबाऐ।',
        'Create your first ticket' => 'अपना पहला टिकट बनाएँ',

        # Template: CustomerTicketPrint
        'Ticket Print' => 'टिकट मुद्रण',

        # Template: CustomerTicketSearch
        'Profile' => 'वर्णन',
        'e. g. 10*5155 or 105658*' => 'उदा.: 10*5155 or 105658*',
        'Fulltext search in tickets (e. g. "John*n" or "Will*")' => 'टिकटों में पूर्ण पाठ खोज(उदा."John*n" or "Will*")',
        'Recipient' => 'प्राप्तकर्ता',
        'Carbon Copy' => 'प्रतिलिपि',
        'Time restrictions' => 'समय प्रतिबंध',
        'No time settings' => '',
        'Only tickets created' => 'केवल टिकट बनाए',
        'Only tickets created between' => 'कॆवल वही टिकट जो इस बीच बनाए गए',
        'Ticket archive system' => '',
        'Save search as template?' => '',
        'Save as Template?' => 'टेम्पलेट के रूप में सुरक्षित करें ?',
        'Save as Template' => '',
        'Template Name' => 'टेम्पलेट का नाम',
        'Pick a profile name' => '',
        'Output to' => 'को आउटपुट',

        # Template: CustomerTicketSearchOpenSearchDescription

        # Template: CustomerTicketSearchResultPrint

        # Template: CustomerTicketSearchResultShort
        'of' => 'की',
        'Page' => 'पृष्ठ',
        'Search Results for' => 'के लिए परिणाम खोजें',

        # Template: CustomerTicketZoom
        'Show  article' => '',
        'Expand article' => 'अनुच्छेद का विस्तार करें',
        'Information' => '',
        'Next Steps' => '',
        'Reply' => 'जवाब देना',

        # Template: CustomerWarning

        # Template: Datepicker
        'Invalid date (need a future date)!' => 'अवैध दिनांक(आगामी दिनांक की जरूरत है)',
        'Previous' => 'पिछला',
        'Sunday' => 'रविवार',
        'Monday' => 'सोमवार',
        'Tuesday' => 'मंगलवार',
        'Wednesday' => 'बुधवार',
        'Thursday' => 'गुरूवार',
        'Friday' => 'शुक्रवार',
        'Saturday' => 'शनिवार',
        'Su' => 'रविवार',
        'Mo' => 'सोमवार',
        'Tu' => 'मंगलवार',
        'We' => 'बुधवार',
        'Th' => 'गुरूवार',
        'Fr' => 'शुक्रवार',
        'Sa' => 'शनिवार',
        'Open date selection' => 'दिनांक चयन को खोलें',

        # Template: Error
        'Oops! An Error occurred.' => 'ओह! एक त्रुटि आई।',
        'Error Message' => 'त्रुटि संदेश',
        'You can' => 'आप कर सकते हैं',
        'Send a bugreport' => 'दोष रिपोर्ट भेजें',
        'go back to the previous page' => 'पिछले पृष्ठ पर वापस जाने के लिए',
        'Error Details' => 'त्रुटि का विवरण',

        # Template: Footer
        'Top of page' => 'पृष्ठ का शीर्ष',

        # Template: FooterJS
        'If you now leave this page, all open popup windows will be closed, too!' =>
            'यदि अब आप इस पृष्ठ को छॊडॆंगॆ,सभी खुले पॉपअप विंडोज़ भी बंद हो जायेंगे।',
        'A popup of this screen is already open. Do you want to close it and load this one instead?' =>
            'इस स्क्रीन का एक पॉपअप पहले से ही खुला है। क्या आप उसे बंद करके उसकी बजाय इसे लोड करना चाहते हैं?',
        'Please enter at least one search value or * to find anything.' =>
            '',

        # Template: FooterSmall

        # Template: HTMLHead

        # Template: HTMLHeadBlockEvents

        # Template: Header
        'Fulltext search' => '',
        'CustomerID Search' => '',
        'CustomerUser Search' => '',
        'You are logged in as' => 'आप इस रूप में प्रवॆशित हैं।',

        # Template: HeaderSmall

        # Template: Installer
        'JavaScript not available' => 'जावास्क्रिप्ट उपलब्ध नहीं है।',
        'Database Settings' => 'आंकड़ाकोष व्यवस्थाऐं',
        'General Specifications and Mail Settings' => 'सामान्य निर्दिष्टीकरण और मेल व्यवस्थाऐं',
        'Registration' => '',
        'Welcome to %s' => '%s में आपका स्वागत है',
        'Web site' => 'वेबसाइट',
        'Database check successful.' => 'आंकड़ाकोष की जाँच सफल रही।',
        'Mail check successful.' => 'मेल की जाँच सफल रही।',
        'Error in the mail settings. Please correct and try again.' => 'मेल व्यवस्थाऐं करने में त्रुटि हैं। सही करें तथा पुनः प्रयास करें।',

        # Template: InstallerConfigureMail
        'Configure Outbound Mail' => 'आउटबाउंड मेल विन्यस्त करें',
        'Outbound mail type' => 'आउटबाउंड मेल का प्रकार',
        'Select outbound mail type.' => 'आउटबाउंड मेल प्रकार का चयन करें।',
        'Outbound mail port' => 'आउटबाउंड मेल का द्वारक',
        'Select outbound mail port.' => 'आउटबाउंड मेल द्वारक का चयन करें।',
        'SMTP host' => 'SMTP मेजबान',
        'SMTP host.' => 'SMTP मेजबान।',
        'SMTP authentication' => 'SMTP प्रमाणीकरण',
        'Does your SMTP host need authentication?' => 'क्या आपके SMTP मेजबान को प्रमाणीकरण की आवश्यकता है?',
        'SMTP auth user' => 'SMTP प्रमाणीकरण उपयोगकर्ता',
        'Username for SMTP auth.' => 'SMTP प्रमाणीकरण के लिए उपयोगकर्ता नाम',
        'SMTP auth password' => 'SMTP प्रमाणीकरण का कूटशब्द',
        'Password for SMTP auth.' => 'SMTP प्रमाणीकरण के लिए कूटशब्द',
        'Configure Inbound Mail' => 'इनबाउंड मेल विन्यस्त करें',
        'Inbound mail type' => 'इनबाउंड मेल का प्रकार',
        'Select inbound mail type.' => 'इनबाउंड मेल प्रकार का चयन करें।',
        'Inbound mail host' => 'इनबाउंड मेल का मेजबान',
        'Inbound mail host.' => 'इनबाउंड मेल का मेजबान।',
        'Inbound mail user' => 'इनबाउंड मेल उपयोगकर्ता ',
        'User for inbound mail.' => 'इनबाउंड मेल के लिए उपयोगकर्ता।',
        'Inbound mail password' => 'इनबाउंड मेल कूटशब्द',
        'Password for inbound mail.' => 'इनबाउंड मेल के लिए कूटशब्द।',
        'Result of mail configuration check' => 'मेल विन्यास की जाँच के नतीजे',
        'Check mail configuration' => 'मेल विन्यास की जाँच करें',
        'Skip this step' => 'यह चरण छोड़ें',
        'Skipping this step will automatically skip the registration of your OTRS. Are you sure you want to continue?' =>
            '',

        # Template: InstallerDBResult
        'False' => 'ग़लत',

        # Template: InstallerDBStart
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty. For security reasons we do recommend setting a root password. For more information please refer to your database documentation.' =>
            'यदि आप अपने आंकड़ाकोष के लिए एक रूट कूटशब्द निर्धारित किया है,यहाँ प्रविष्ट किया जाना चाहिए। यदि नहीं,इस क्षेत्र को खाली छोडें। सुरक्षा कारणों से हम एक रूट कूटशब्द निर्धारित करने की अनुशंसा करते हैं। अधिक जानकारी के लिए कृपया अपने आंकड़ाकोष दस्तावेजों को देखें।',
        'Currently only MySQL is supported in the web installer.' => 'वर्तमान में केवल MySQL वेब संस्थापक में समर्थित है।',
        'If you want to install OTRS on another database type, please refer to the file README.database.' =>
            'यदि आप किसी अन्य डेटाबेस के प्रकार पर OTRS स्थापित करना चाहते हैं,तो कृपया README.database फ़ाइल का संदर्भ लें।',
        'Database-User' => 'आंकड़ाकोष उपयोगकर्ता',
        'New' => 'नया',
        'A new database user with limited permissions will be created for this OTRS system.' =>
            'सीमित अधिकार के साथ एक नया आंकड़ाकोष उपयोगकर्ता इस OTRS प्रणाली के लिए बनाया जाएगा।',
        'default \'hot\'' => 'तयशुदा \'hot\'',
        'DB host' => 'आंकड़ाकोष मेजबान',
        'Check database settings' => 'आंकड़ाकोष व्यवस्थाऒं की जाँच करें',
        'Result of database check' => 'आंकड़ाकोष की जाँच के नतीजे',

        # Template: InstallerFinish
        'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' =>
            'OTRS का प्रयोग करनॆ कॆ लिए आपको निम्नलिखित पंक्ति रूट के रूप में कमांड लाइन (टर्मिनल/शैल) में दॆनी होगी।',
        'Restart your webserver' => 'वेबसर्वर पुनरारंभ करें',
        'After doing so your OTRS is up and running.' => 'ऐसा करने के बाद आपका OTRS तैयार है।',
        'Start page' => 'प्रारंभिक पेज',
        'Your OTRS Team' => 'आपका OTRS समूह',

        # Template: InstallerLicense
        'Accept license' => 'लाइसेंस स्वीकारें',
        'Don\'t accept license' => 'लाइसेंस स्वीकार नहीं',

        # Template: InstallerLicenseText

        # Template: InstallerRegistration
        'Organization' => 'संगठन',
        'Position' => '',
        'Complete registration and continue' => '',
        'Please fill in all fields marked as mandatory.' => '',

        # Template: InstallerSystem
        'SystemID' => 'सिस्टम ID',
        'The identifier of the system. Each ticket number and each HTTP session ID contain this number.' =>
            'प्रणाली का पहचानकर्ता। प्रत्येक टिकट संख्या और प्रत्येक HTTP सत्र ID कॆ पास यह संख्या होती हैं।',
        'System FQDN' => 'प्रणाली FQDN',
        'Fully qualified domain name of your system.' => 'पूरी तरह से योग्य आपके सिस्टम का प्रक्षेत्र नाम।',
        'AdminEmail' => 'व्यवस्थापक ईमेल',
        'Email address of the system administrator.' => 'प्रणाली प्रशासक का ईमेल पता।',
        'Log' => 'अभिलेख',
        'LogModule' => 'मॉड्यूल अभिलेख',
        'Log backend to use.' => 'अभिलेख का बैकेंड प्रयोग के लिये',
        'LogFile' => 'अभिलेख फ़ाइल',
        'Log file location is only needed for File-LogModule!' => 'अभिलेख फ़ाइल स्थान केवल अभिलेख-मॉड्यूल फ़ाइल के लिए जरूरी है।',
        'Webfrontend' => 'वेब दृश्यपटल',
        'Default language' => 'तयशुदा भाषा',
        'Default language.' => 'तयशुदा भाषा।',
        'CheckMXRecord' => 'MX रिकार्ड की जाँच करें',
        'Email addresses that are manually entered are checked against the MX records found in DNS. Don\'t use this option if your DNS is slow or does not resolve public addresses.' =>
            'ईमेल पते जो कि दस्ती रूप से दाखिल कर रहे हैं,वो DNS मॆं MX रिकॉर्ड्स से जाँचे जा रहे है। इस विकल्प का उपयोग न करें यदि आपके DNS धीमा है या सार्वजनिक पते को हल नहीं कर सकता।',

        # Template: LinkObject
        'Object#' => 'वस्तु#',
        'Add links' => 'लिंक जोड़ें',
        'Delete links' => 'लिंक हटाएँ',

        # Template: Login
        'Lost your password?' => ' आपने कूटशब्द खो दिया?',
        'Request New Password' => 'नए कूटशब्द के लिए अनुरोध करे',
        'Back to login' => 'प्रवेश करने के लिए वापस जाएँ',

        # Template: Motd
        'Message of the Day' => 'आज के दिन का संदेश',

        # Template: NoPermission
        'Insufficient Rights' => 'अपर्याप्त अधिकार',
        'Back to the previous page' => 'पिछले पृष्ठ पर वापस जाएँ',

        # Template: Notify

        # Template: Pagination
        'Show first page' => 'पहला पृष्ठ दिखाएँ ',
        'Show previous pages' => 'पिछले पृष्ठ दिखाएँ',
        'Show page %s' => '%s पृष्ठ दिखाएँ',
        'Show next pages' => 'अगले पृष्ठ दिखाएँ',
        'Show last page' => 'अंतिम पृष्ठ दिखाएँ ',

        # Template: PictureUpload
        'Need FormID!' => 'प्रपत्र ID की आवश्यकता है',
        'No file found!' => 'कोई फाइल नहीं मिली',
        'The file is not an image that can be shown inline!' => 'फ़ाइल एक छवि नहीं है जो इनलाइन दिखाया जा सकता है।',

        # Template: PrintFooter
        'URL' => 'URL',

        # Template: PrintHeader
        'printed by' => 'के द्वारा मुद्रित',

        # Template: PublicDefault

        # Template: Redirect

        # Template: RichTextEditor

        # Template: SpellingInline

        # Template: Test
        'OTRS Test Page' => 'OTRS परीक्षण पृष्ठ',
        'Welcome %s' => '%s आपका स्वागत है',
        'Counter' => 'पटल',

        # Template: Warning
        'Go back to the previous page' => 'पिछले पृष्ठ पर वापस जाएँ',

        # SysConfig
        '"Slim" Skin which tries to save screen space for power users.' =>
            '',
        'ACL module that allows closing parent tickets only if all its children are already closed ("State" shows which states are not available for the parent ticket until all child tickets are closed).' =>
            'ACL मॉड्यूल जनक टिकटों तभी बंद करने की अनुमति देता है जब उसके सभी चिल्ड्रन पहले से ही बंद हो।(" स्थिति" से पता चलता है की कोंनसी स्थिति जनक टिकटों के लिए उपलब्ध नहीं हैं जब तक कि सभी चिल्ड्रन टिकटें बंद न हो)।',
        'AccountedTime' => '',
        'Activates a blinking mechanism of the queue that contains the oldest ticket.' =>
            'श्रेणी के एक निमिष व्यवस्था सक्रिय करता है जिसमें सबसे पुराना टिकट शामिल होता है।',
        'Activates lost password feature for agents, in the agent interface.' =>
            'प्रतिनिधि अंतरफलक में कूटशब्द खो दिया सुविधा को सक्रिय करता है।',
        'Activates lost password feature for customers.' => 'कूटशब्द खो दिया सुविधा को ग्राहकों के लिए सक्रिय करता है।',
        'Activates support for customer groups.' => 'ग्राहक समूहों के लिए सहायता सक्रिय करता है।',
        'Activates the article filter in the zoom view to specify which articles should be shown.' =>
            'ज़ूम दृश्य में जो अनुच्छेद दिखाया जाना चाहिये अनुच्छेद निस्पादक को सक्रिय करता है।',
        'Activates the available themes on the system. Value 1 means active, 0 means inactive.' =>
            'प्रणाली पर उपलब्ध थीम को सक्रिय करता है।मान 1 का मतलब सक्रिय है,0 का मतलब है निष्क्रिय।',
        'Activates the ticket archive system search in the customer interface.' =>
            '',
        'Activates the ticket archive system to have a faster system by moving some tickets out of the daily scope. To search for these tickets, the archive flag has to be enabled in the ticket search.' =>
            'प्रणाली तेज बनाने के लिए टिकटों को दैनिक दायरे से बाहर ले जाने वाले टिकट संग्रह प्रणाली को सक्रिय करता है। इन टिकटों को खोजने के लिए,संग्रह चिह्नक को टिकट खोज में सक्रिय किया जाना चाहिए।',
        'Activates time accounting.' => 'समय लेखाकरण सक्रिय करता है।',
        'Adds a suffix with the actual year and month to the OTRS log file. A logfile for every month will be created.' =>
            'वास्तविक वर्ष और महीने के साथ OTRS अभिलेख फ़ाइल को एक प्रत्यय जोड़ता है।हर महीने के लिए एक अभिलेख फ़ाइल बनाया जाएगा।',
        'Adds customers email addresses to recipients in the ticket compose screen of the agent interface. The customers email address won\'t be added if the article type is email-internal.' =>
            '',
        'Adds the one time vacation days for the indicated calendar. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            '',
        'Adds the one time vacation days. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'एक बार अवकाश के दिन जोड़ता हैं। 1 से 9 की संख्या के लिए एकल अंक स्वरूप का उपयोग करें(01 - 09 के बजाय )।',
        'Adds the permanent vacation days for the indicated calendar. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            '',
        'Adds the permanent vacation days. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'स्थायी अवकाश के दिन जोड़ता हैं। 1 से 9 तक की संख्या के लिए एकल अंक पद्धति का उपयोग करें(01 - 09 के बजाय )।',
        'Agent Notifications' => 'प्रतिनिधि अधिसूचनाएं',
        'Agent interface article notification module to check PGP.' => 'PGP की जाँच करने के लिए प्रतिनिधि अंतरफलक अनुच्छेद अधिसूचना मॉड्यूल।',
        'Agent interface article notification module to check S/MIME.' =>
            'S/MIME की जाँच करने के लिए प्रतिनिधि अंतरफलक अनुच्छेद अधिसूचना मॉड्यूल।',
        'Agent interface module to access CIC search via nav bar.' => '',
        'Agent interface module to access fulltext search via nav bar.' =>
            'संचरण में प्रतिनिधि अंतरफलक मॉड्यूल से पूर्ण पाठ खोज का उपयोग।',
        'Agent interface module to access search profiles via nav bar.' =>
            'संचरण में प्रतिनिधि अंतरफलक मॉड्यूल से वर्णन खोज का उपयोग।',
        'Agent interface module to check incoming emails in the Ticket-Zoom-View if the S/MIME-key is available and true.' =>
            'प्रतिनिधि अंतरफलक मॉड्यूल टिकट-ज़ूम-दृश्य में आने वाली ईमेल की जाँच करने के लिए अगर एस / MIME-कुंजी उपलब्ध है और सही है।',
        'Agent interface notification module to check the used charset.' =>
            'प्रयुक्त चारसेट की जाँच के लिए प्रतिनिधि अंतरफलक अधिसूचना मॉड्यूल।',
        'Agent interface notification module to see the number of tickets an agent is responsible for.' =>
            'एक प्रतिनिधि के उत्तरदायी टिकट की संख्या देखने के लिए प्रतिनिधि अंतरफलक अधिसूचना मॉड्यूल। ',
        'Agent interface notification module to see the number of watched tickets.' =>
            'ध्यानाधीन टिकट की संख्या को देखने के लिए प्रतिनिधि अंतरफलक अधिसूचना मॉड्यूल।',
        'Agents <-> Groups' => 'प्रतिनिधि<->समूहों',
        'Agents <-> Roles' => 'प्रतिनिधि<->भूमिकाएँ',
        'All customer users of a CustomerID' => '',
        'Allows adding notes in the close ticket screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के बंद टिकट स्क्रीन में टिप्पणीयां जोड़ने की अनुमति देता है।',
        'Allows adding notes in the ticket free text screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट मुक्त पाठ स्क्रीन में टिप्पणीयां जोड़ने की अनुमति देता है।',
        'Allows adding notes in the ticket note screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट टिप्पणी स्क्रीन में टिप्पणीयां जोड़ने की अनुमति देता है।',
        'Allows adding notes in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'प्रतिनिधि अंतरफलक के जूम टिकट के स्वामी स्क्रीन में टिप्पणीयां जोड़ने की अनुमति देता है।',
        'Allows adding notes in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'प्रतिनिधि अंतरफलक के जूम टिकट के विचाराधीन स्क्रीन में टिप्पणीयां जोड़ने की अनुमति देता है।',
        'Allows adding notes in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'प्रतिनिधि अंतरफलक के जूम टिकट के प्राथमिकता स्क्रीन में टिप्पणीयां जोड़ने की अनुमति देता है।',
        'Allows adding notes in the ticket responsible screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के जूम टिकट के उत्तरदायी स्क्रीन में टिप्पणीयां जोड़ने की अनुमति देता है।',
        'Allows agents to exchange the axis of a stat if they generate one.' =>
            'आँकड़ॊ की धुरी विनिमय करने के लिए प्रतिनिधि को अनुमति देता है यदि वे एक उत्पन्न करते है।',
        'Allows agents to generate individual-related stats.' => 'अलग अलग संबंधित आँकड़े उत्पन्न करने के लिए प्रतिनिधि को अनुमति देता है।',
        'Allows choosing between showing the attachments of a ticket in the browser (inline) or just make them downloadable (attachment).' =>
            'ब्राउज़र (इनलाइन) में एक टिकट के संलग्नक दिखाने या सिर्फ उन्हें डाउनलोड करने योग्य (संलग्नक) के बीच में चुनने की अनुमति देता है।',
        'Allows choosing the next compose state for customer tickets in the customer interface.' =>
            'ग्राहक अंतरफलक में ग्राहक टिकटों के लिए अगली रचना स्थिति को चुनने की अनुमति देता है।',
        'Allows customers to change the ticket priority in the customer interface.' =>
            'ग्राहकों को ग्राहक अंतरफलक में टिकट प्राथमिकता बदलने के लिए अनुमति देता है।',
        'Allows customers to set the ticket SLA in the customer interface.' =>
            'ग्राहकों को ग्राहक अंतरफलक में टिकट SLA स्थापित करने के लिए अनुमति देता है।',
        'Allows customers to set the ticket priority in the customer interface.' =>
            'ग्राहकों को ग्राहक अंतरफलक में टिकट प्राथमिकता बदलने के लिए अनुमति देता है।',
        'Allows customers to set the ticket queue in the customer interface. If this is set to \'No\', QueueDefault should be configured.' =>
            'ग्राहकों को ग्राहक अंतरफलक में टिकट श्रेणी स्थापित करने के लिए अनुमति देता है। यदि यह  \'नहीं\'के लिए स्थापित है,तयशुदा श्रेणी विन्यस्त होना चाहिये।',
        'Allows customers to set the ticket service in the customer interface.' =>
            'ग्राहकों को ग्राहक अंतरफलक में टिकट सेवा स्थापित करने के लिए अनुमति देता है।',
        'Allows customers to set the ticket type in the customer interface. If this is set to \'No\', TicketTypeDefault should be configured.' =>
            '',
        'Allows default services to be selected also for non existing customers.' =>
            '',
        'Allows defining new types for ticket (if ticket type feature is enabled).' =>
            'टिकट के लिए नए प्रकार को परिभाषित करने की अनुमति देता है (अगर टिकट प्रकार सुविधा सक्षम है)।',
        'Allows defining services and SLAs for tickets (e. g. email, desktop, network, ...), and escalation attributes for SLAs (if ticket service/SLA feature is enabled).' =>
            'टिकटों के लिए सेवाओं और SLAs(उदा. ईमेल,डेस्कटॉप,नेटवर्क,...) और SLAs के लिए संवर्धित विशेषताओं(यदि टिकट सेवा/SLA सुविधा सक्षम है) को परिभाषित करने के लिए की अनुमति देता है।',
        'Allows extended search conditions in ticket search of the agent interface. With this feature you can search e. g. with this kind of conditions like "(key1&&key2)" or "(key1||key2)".' =>
            '',
        'Allows extended search conditions in ticket search of the customer interface. With this feature you can search w. g. with this kind of conditions like "(key1&&key2)" or "(key1||key2)".' =>
            'ग्राहक अंतरफलक के टिकट खोज में खोज स्थितियों के विस्तार की अनुमति देता है।इस सुविधा के साथ आप खोज कर सकते हैं उदा. इस प्रकार की स्थितियों के साथ "(key1 && key2)"या"(key1 || key2)"।',
        'Allows having a medium format ticket overview (CustomerInfo => 1 - shows also the customer information).' =>
            'एक मध्यम प्रारूप टिकट अवलोकन होने की अनुमति देता है(ग्राहक जानकारी =>1 - यह भी ग्राहकों की जानकारी दिखाता है)।',
        'Allows having a small format ticket overview (CustomerInfo => 1 - shows also the customer information).' =>
            'एक छोटे प्रारूप टिकट अवलोकन होने की अनुमति देता है(ग्राहक जानकारी =>1 - यह भी ग्राहकों की जानकारी दिखाता है)।',
        'Allows the administrators to login as other customers, via the customer user administration panel.' =>
            '',
        'Allows the administrators to login as other users, via the users administration panel.' =>
            'प्रशासक को प्रशासन पैनल के माध्यम से अन्य उपयोगकर्ताओं को प्रशासक के रूप में प्रवेश की अनुमति देता है।',
        'Allows to set a new ticket state in the move ticket screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के स्थानांतरित टिकट स्क्रीन में एक नया टिकट स्थिति स्थापित करने के लिए अनुमति देता है।',
        'ArticleTree' => '',
        'Attachments <-> Responses' => 'संलग्नक <-> प्रतिक्रिया',
        'Auto Responses <-> Queues' => 'प्रतिक्रिया<->श्रेणी',
        'Automated line break in text messages after x number of chars.' =>
            'पाठ संदेशों में स्वचालित पंक्ति विराम अक्षरों की x संख्या के बाद।',
        'Automatically lock and set owner to current Agent after selecting for an Bulk Action.' =>
            'थोक कार्रवाई चुनने के बाद स्वचालित रूप से वर्तमान प्रतिनिधि के लिए लॉक और स्वामी निर्धारित करें।',
        'Automatically sets the owner of a ticket as the responsible for it (if ticket responsible feature is enabled).' =>
            'स्वामी को स्वचालित रूप से टिकट के लिए उत्तरदायी बनायें(यदि टिकट की उत्तरदायी सुविधा सक्षम है)।',
        'Automatically sets the responsible of a ticket (if it is not set yet) after the first owner update.' =>
            'पहला स्वामी अद्यतन करने के बाद स्वचालित रूप से एक टिकट का उत्तरदायी(अगर यह अभी तक निर्धारित नहीं है)निर्धारित करें।',
        'Balanced white skin by Felix Niklas.' => 'संतुलित सफेद सतही फेलिक्स निकलस के द्वारा',
        'Basic fulltext index settings. Execute "bin/otrs.RebuildFulltextIndex.pl" in order to generate a new index.' =>
            '',
        'Blocks all the incoming emails that do not have a valid ticket number in subject with From: @example.com address.' =>
            'सभी आने वाली ईमेल से:@ example.com पते के जिनके विषय में एक वैध टिकट नंबर नहीं है उनको रोकें।',
        'Builds an article index right after the article\'s creation.' =>
            'अनुच्छेद बनने के ठीक बाद एक अनुच्छेद सूचकांक बनता है।',
        'CMD example setup. Ignores emails where external CMD returns some output on STDOUT (email will be piped into STDIN of some.bin).' =>
            'CMD उदाहरण स्थापना,ईमेल पर ध्यान न दें जब बाहरी CMD STDOUT को कुछ उत्पादन देता है(ईमेल some.bin का stdin में पहुंचाया जाएगा)।',
        'Cache time in seconds for agent authentication in the GenericInterface.' =>
            '',
        'Cache time in seconds for customer authentication in the GenericInterface.' =>
            '',
        'Cache time in seconds for the DB process backend.' => '',
        'Cache time in seconds for the ticket process navigation bar output module.' =>
            '',
        'Cache time in seconds for the web service config backend.' => '',
        'Change password' => 'कूटशब्द बदलें',
        'Change queue!' => 'श्रेणी बदलें',
        'Change the customer for this ticket' => '',
        'Change the free fields for this ticket' => '',
        'Change the priority for this ticket' => '',
        'Change the responsible person for this ticket' => '',
        'Changes the owner of tickets to everyone (useful for ASP). Normally only agent with rw permissions in the queue of the ticket will be shown.' =>
            'टिकट का स्वामी सभी को करने के लिए बदलें(ASP के लिए उपयोगी)। आम तौर पर टिकट की श्रेणी में ही पढ़ने और लिखने की अनुमति के साथ प्रतिनिधि दिखाया जाएगा।',
        'Checkbox' => '',
        'Checks the SystemID in ticket number detection for follow-ups (use "No" if SystemID has been changed after using the system).' =>
            'टिकट की अनुवर्ती संख्या का पता लगाने के लिए यह प्रणाली ID की जाँच करता है(प्रयोग "नहीं" अगर प्रणाली ID प्रणाली का उपयोग करने के बाद बदल दिया गया है)।',
        'Closed tickets of customer' => '',
        'Comment for new history entries in the customer interface.' => 'ग्राहक अंतरफलक में इतिहास नई प्रविष्टियों के लिए टिप्पणी।',
        'Company Status' => '',
        'Company Tickets' => 'कंपनी के टिकट',
        'Company name for the customer web interface. Will also be included in emails as an X-Header.' =>
            '',
        'Configure Processes.' => '',
        'Configure your own log text for PGP.' => 'आपके PGP के लिए अपनी अभिलेख पाठ विन्यस्त करें।',
        'Configures a default TicketDynmicField setting. "Name" defines the dynamic field which should be used, "Value" is the data that will be set, and "Event" defines the trigger event. Please check the developer manual (http://doc.otrs.org/), chapter "Ticket Event Module".' =>
            '',
        'Controls if customers have the ability to sort their tickets.' =>
            'नियंत्रित करता है यदि ग्राहकों को उनके टिकट सॉर्ट करने की क्षमता है।',
        'Controls if more than one from entry can be set in the new phone ticket in the agent interface.' =>
            '',
        'Controls if the ticket and article seen flags are removed when a ticket is archived.' =>
            '',
        'Converts HTML mails into text messages.' => 'HTML मेल को पाठ संदेशों में बदलता है। ',
        'Create New process ticket' => '',
        'Create and manage Service Level Agreements (SLAs).' => 'सेवा स्तर के समझौतों को बनाएँ और प्रबंधन करें।',
        'Create and manage agents.' => 'प्रतिनिधियॊ को बनाएँ और प्रबंधन करें।',
        'Create and manage attachments.' => 'संलग्नक को बनाएँ और प्रबंधन करें।',
        'Create and manage companies.' => 'कंपनियों को बनाएँ और प्रबंधन करें।',
        'Create and manage customers.' => 'ग्राहकों को बनाएँ और प्रबंधन करें।',
        'Create and manage dynamic fields.' => '',
        'Create and manage event based notifications.' => 'घटना आधारित अधिसूचना को बनाएँ और प्रबंधन करें।',
        'Create and manage groups.' => 'समूहों को बनाएँ और प्रबंधन करें।',
        'Create and manage queues.' => 'श्रेणीयों को बनाएँ और प्रबंधन करें।',
        'Create and manage response templates.' => 'प्रतिक्रिया टेम्पलेट्स को बनाएँ और प्रबंधन करें।',
        'Create and manage responses that are automatically sent.' => 'प्रतिक्रियाएं जो स्वचालित रूप से भेजी जाती है को बनाएँ और प्रबंधन करें।',
        'Create and manage roles.' => 'भूमिकाएं को बनाएँ और प्रबंधन करें।',
        'Create and manage salutations.' => 'अभिवादनों को बनाएँ और प्रबंधन करें।',
        'Create and manage services.' => 'सेवाओं को बनाएँ और प्रबंधन करें।',
        'Create and manage signatures.' => 'हस्ताक्षरों को बनाएँ और प्रबंधन करें।',
        'Create and manage ticket priorities.' => 'टिकट प्राथमिकताओं को बनाएँ और प्रबंधन करें।',
        'Create and manage ticket states.' => 'टिकट स्थितियों को बनाएँ और प्रबंधन करें।',
        'Create and manage ticket types.' => 'टिकट के प्रकारों को बनाएँ और प्रबंधन करें।',
        'Create and manage web services.' => '',
        'Create new email ticket and send this out (outbound)' => 'नया ईमेल टिकट बनाएँ और इस बाहर (आउटबाउंड) भेजें',
        'Create new phone ticket (inbound)' => 'नया फोन टिकट (इनबाउंड)बनाएँ',
        'Custom text for the page shown to customers that have no tickets yet.' =>
            'कस्टम पाठ जो उन ग्राहकों को दिखाया जाएगा जिनके पास अभी तक कोई टिकट नहीं है।',
        'Customer Company Administration' => '',
        'Customer Company Information' => '',
        'Customer User Administration' => '',
        'Customer Users' => '',
        'Customer item (icon) which shows the closed tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            '',
        'Customer item (icon) which shows the open tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            '',
        'CustomerName' => '',
        'Customers <-> Groups' => 'ग्राहकों<->समूहों',
        'Customers <-> Services' => 'ग्राहकों<->सेवाएँ',
        'Data used to export the search result in CSV format.' => 'CSV प्रारूप में खोज परिणाम भेजने के लिए उपयोग होनेवाला आंकड़ा।',
        'Date / Time' => '',
        'Debugs the translation set. If this is set to "Yes" all strings (text) without translations are written to STDERR. This can be helpful when you are creating a new translation file. Otherwise, this option should remain set to "No".' =>
            'निर्धारित अनुवाद को दोषमार्जन करना। यदि यह "हाँ" पर निर्धारित है तो अनुवाद किए बिना सभी स्ट्रिंग्स(पाठ)stderr में लिखा जाता है।',
        'Default ACL values for ticket actions.' => 'तयशुदा ACL मान टिकट कार्रवाई के लिए।',
        'Default ProcessManagement entity prefixes for entity IDs that are automatically generated.' =>
            '',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimePointFormat=year;TicketCreateTimePointStart=Last;TicketCreateTimePoint=2;".' =>
            '',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimeStartYear=2010;TicketCreateTimeStartMonth=10;TicketCreateTimeStartDay=4;TicketCreateTimeStopYear=2010;TicketCreateTimeStopMonth=11;TicketCreateTimeStopDay=3;".' =>
            '',
        'Default loop protection module.' => 'तयशुदा पाश सुरक्षा मॉड्यूल',
        'Default queue ID used by the system in the agent interface.' => 'प्रतिनिधि अंतरफलक में सिस्टम के द्वारा प्रयुक्त तयशुदा श्रेणीID।',
        'Default skin for OTRS 3.0 interface.' => '3.0 OTRS अंतरफलक के लिए तयशुदा सतही।',
        'Default skin for interface.' => 'तयशुदा सतही अंतरफलक के लिए।',
        'Default ticket ID used by the system in the agent interface.' =>
            'प्रतिनिधि अंतरफलक में सिस्टम के द्वारा प्रयुक्त तयशुदा टिकटID।',
        'Default ticket ID used by the system in the customer interface.' =>
            'ग्राहक अंतरफलक में सिस्टम के द्वारा प्रयुक्त तयशुदा टिकटID।',
        'Default value for NameX' => '',
        'Define a filter for html output to add links behind a defined string. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'HTML उत्पादन को  परिभाषित स्ट्रिंग के पीछे की लिंक जोड़ने के लिए एक निस्पादक परिभाषित करे। तत्व छवि दो इनपुट प्रकार की अनुमति देता है। एक बार एक छवि के नाम से(उदा.faq.png)। ऐसी स्थिति में OTRS छवि के पथ का उपयोग किया जाएगा। दूसरी संभावना छवि को कड़ी सम्मिलित करने की है।',
        'Define the max depth of queues.' => '',
        'Define the start day of the week for the date picker.' => 'दिनांक पिकर के लिए सप्ताह की शुरुआत के दिन निर्धारित करें।',
        'Defines a customer item, which generates a LinkedIn icon at the end of a customer info block.' =>
            'एक ग्राहक वस्तु को परिभाषित करें, जो एक ग्राहक को जानकारी ब्लॉक के अंत में एक LinkedIn चिह्न उत्पन्न करता है।',
        'Defines a customer item, which generates a XING icon at the end of a customer info block.' =>
            'एक ग्राहक वस्तु को परिभाषित करें,जो एक ग्राहक को जानकारी ब्लॉक के अंत में एक XING चिह्न उत्पन्न करता है।',
        'Defines a customer item, which generates a google icon at the end of a customer info block.' =>
            'एक ग्राहक वस्तु को परिभाषित करें,जो एक ग्राहक को जानकारी ब्लॉक के अंत में एक गूगल चिह्न उत्पन्न करता है।',
        'Defines a customer item, which generates a google maps icon at the end of a customer info block.' =>
            'एक ग्राहक वस्तु को परिभाषित करें,जो एक ग्राहक को जानकारी ब्लॉक के अंत में एक गूगल मानचित्र का चिह्न उत्पन्न करता है।',
        'Defines a default list of words, that are ignored by the spell checker.' =>
            'शब्दों की एक तयशुदा सूची परिभाषित करें,जो वर्तनी परीक्षक के द्वारा नजरअंदाज कर दिया जाएगा।',
        'Defines a filter for html output to add links behind CVE numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Html उत्पादन को CVE संख्या के पीछे लिंक जोड़ने के लिए एक निस्पादक परिभाषित करें। तत्व छवि दो इनपुट प्रकार की अनुमति देता है। एक बार एक छवि के नाम से(उदा.faq.png)। ऐसी स्थिति में OTRS छवि के पथ का उपयोग किया जाएगा। दूसरी संभावना छवि को कड़ी सम्मिलित करने की है।',
        'Defines a filter for html output to add links behind MSBulletin numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Html उत्पादन को MSBulletin संख्या के पीछे लिंक जोड़ने के लिए एक निस्पादक परिभाषित करें। तत्व छवि दो इनपुट प्रकार की अनुमति देता है। एक बार एक छवि के नाम से(उदा.faq.png)। ऐसी स्थिति में OTRS छवि के पथ का उपयोग किया जाएगा। दूसरी संभावना छवि को कड़ी सम्मिलित करने की है।',
        'Defines a filter for html output to add links behind a defined string. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Html उत्पादन को परिभाषित स्ट्रिंग संख्या के पीछे लिंक जोड़ने के लिए एक निस्पादक परिभाषित करें। तत्व छवि दो इनपुट प्रकार की अनुमति देता है। एक बार एक छवि के नाम से(उदा.faq.png)। ऐसी स्थिति में OTRS छवि के पथ का उपयोग किया जाएगा। दूसरी संभावना छवि को कड़ी सम्मिलित करने की है।',
        'Defines a filter for html output to add links behind bugtraq numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Html उत्पादन को परिभाषित बगटै्क संख्या के पीछे लिंक जोड़ने के लिए एक निस्पादक परिभाषित करें। तत्व छवि दो इनपुट प्रकार की अनुमति देता है। एक बार एक छवि के नाम से(उदा.faq.png)। ऐसी स्थिति में OTRS छवि के पथ का उपयोग किया जाएगा। दूसरी संभावना छवि को कड़ी सम्मिलित करने की है।',
        'Defines a filter to process the text in the articles, in order to highlight predefined keywords.' =>
            'अनुच्छेद में एक पाठ प्रक्रिया निस्पादक परिभाषित करें,पूर्वनिर्धारित खोजशब्दों को उजागर करने के लिए। ',
        'Defines a regular expression that excludes some addresses from the syntax check (if "CheckEmailAddresses" is set to "Yes"). Please enter a regex in this field for email addresses, that aren\'t syntactically valid, but are necessary for the system (i.e. "root@localhost").' =>
            'एक नियमित अभिव्यक्ति को परिभाषित करें जिसमें वाक्यविन्यास से कुछ पते शामिल नहीं है(यदि "ईमेल पतों की जाँच करें" "हाँ" पर स्थापित है)। ईमेल पते के लिए इस क्षेत्र में एक नियमित अभिव्यक्ति दर्ज करें,जो वाक्य रचना से वैध नहीं है,लेकिन सिस्टम के लिए आवश्यक हैं (अर्थात् "root@localhost")।',
        'Defines a regular expression that filters all email addresses that should not be used in the application.' =>
            'एक नियमित अभिव्यक्ति को परिभाषित करें जो सभी ईमेल पते जो आवेदन पत्र में प्रयुक्त नहीं होना चाहिए को निस्पादित करता है।',
        'Defines a useful module to load specific user options or to display news.' =>
            'एक उपयोगी मॉड्यूल को परिभाषित करें विशिष्ट उपयोगकर्ता विकल्प लोड करने के लिए या समाचार प्रदर्शन करने के लिए।',
        'Defines all the X-headers that should be scanned.' => 'सभी एक्स हेडर जो स्कैन किया जाना चाहिए को परिभाषित करता है।',
        'Defines all the languages that are available to the application. The Key/Content pair links the front-end display name to the appropriate language PM file. The "Key" value should be the base-name of the PM file (i.e. de.pm is the file, then de is the "Key" value). The "Content" value should be the display name for the front-end. Specify any own-defined language here (see the developer documentation http://doc.otrs.org/ for more infomation). Please remember to use the HTML equivalents for non-ASCII characters (i.e. for the German oe = o umlaut, it is necessary to use the &ouml; symbol).' =>
            'सभी भाषाओं परिभाषित करें जो अनुप्रयोग के लिए उपलब्ध हैं। कुंजी/विषयवस्तु जोड़ी अग्रांत प्रदर्शन नाम को उपयुक्त भाषा PM फ़ाइल से जोडता है। "कुंजी" मान PM फ़ाइल का बेस नाम होना चाहिए (यानी de.pm फ़ाइल है, तो de "कुंजी" मान है)।"सामग्री" मान दृश्यपटल के लिए प्रदर्शन नाम होना चाहिए। कोई भी खुद से परिभाषित भाषा यहाँ निर्दिष्ट करें(अधिक जानकारी के लिए डेवलपर दस्तावेज़ीकरण http://doc.otrs.org/ देखें)। कृपया गैर-ASCII                वर्ण के लिए HTML समतुल्य का उपयोग करता है।(यानी जर्मन oe=o ऊमलायूट के लिए,यह जरूरी है कि &ouml; प्रतीक का उपयोग करें)।',
        'Defines all the parameters for the RefreshTime object in the customer preferences of the customer interface.' =>
            'ग्राहक अंतरफलक के ग्राहक वरीयताओं में ताज़ा टाइम वस्तु के लिए सभी पैरामीटर्स निर्धारित करता है।',
        'Defines all the parameters for the ShownTickets object in the customer preferences of the customer interface.' =>
            'ग्राहक अंतरफलक के ग्राहक वरीयताओं में टिकट दिखाए वस्तु के लिए सभी पैरामीटर्स निर्धारित करता है।',
        'Defines all the parameters for this item in the customer preferences.' =>
            'ग्राहक वरीयताओं में इस वस्तु के लिए सभी पैरामीटर्स निर्धारित करता है।',
        'Defines all the possible stats output formats.' => 'सभी संभव आँकड़े आउटपुट स्वरूप को परिभाषित करता है।',
        'Defines an alternate URL, where the login link refers to.' => 'एक वैकल्पिक URL को परिभाषित करें,जहां प्रवेश कड़ी संदर्भित करता है।',
        'Defines an alternate URL, where the logout link refers to.' => 'एक वैकल्पिक URL को परिभाषित करें।,जहां लॉगआउट कड़ी संदर्भित करता है।',
        'Defines an alternate login URL for the customer panel..' => 'ग्राहक पैनल के लिए एक वैकल्पिक प्रवेश URL को परिभाषित करता है।',
        'Defines an alternate logout URL for the customer panel.' => 'ग्राहक पैनल के लिए एक वैकल्पिक लॉगआउट URL को परिभाषित करता है।',
        'Defines an external link to the database of the customer (e.g. \'http://yourhost/customer.php?CID=$Data{"CustomerID"}\' or \'\').' =>
            'ग्राहक के आंकड़ाकोष के लिए एक बाहरी लिंक को परिभाषित करता है।(उदा. \'http://yourhost/customer.php?CID=$Data{"CustomerID"}\' or \'\')।',
        'Defines how the From field from the emails (sent from answers and email tickets) should look like.' =>
            'ईमेल(उत्तर और ईमेल टिकट से भेजा गया) के से क्षेत्र कैसे दिखना चाहिए,को परिभाषित करता है। ',
        'Defines if a pre-sorting by priority should be done in the queue view.' =>
            '',
        'Defines if a ticket lock is required in the close ticket screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'यदि प्रतिनिधि अंतरफलक के पास टिकट बंद स्क्रीन में  एक टिकट लॉक की आवश्यकता है तो परिभाषित करता है(यदि अभी तक टिकट बंद नहीं है,टिकट बंद हो जाए है और वर्तमान प्रतिनिधि उसके मालिक के रूप में अपने आप स्थापित हो जाएगा)।',
        'Defines if a ticket lock is required in the ticket bounce screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'यदि प्रतिनिधि अंतरफलक के पास टिकट फलांग स्क्रीन में  एक टिकट लॉक की आवश्यकता है तो परिभाषित करता है(यदि अभी तक टिकट बंद नहीं है,टिकट बंद हो जाए है और वर्तमान प्रतिनिधि उसके मालिक के रूप में अपने आप स्थापित हो जाएगा)।',
        'Defines if a ticket lock is required in the ticket compose screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'यदि प्रतिनिधि अंतरफलक के पास टिकट रचना स्क्रीन में  एक टिकट लॉक की आवश्यकता है तो परिभाषित करता है(यदि अभी तक टिकट बंद नहीं है,टिकट बंद हो जाए है और वर्तमान प्रतिनिधि उसके मालिक के रूप में अपने आप स्थापित हो जाएगा)।',
        'Defines if a ticket lock is required in the ticket forward screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'यदि प्रतिनिधि अंतरफलक के पास टिकट अग्रिम स्क्रीन में  एक टिकट लॉक की आवश्यकता है तो परिभाषित करता है(यदि अभी तक टिकट बंद नहीं है,टिकट बंद हो जाए है और वर्तमान प्रतिनिधि उसके मालिक के रूप में अपने आप स्थापित हो जाएगा)।',
        'Defines if a ticket lock is required in the ticket free text screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'यदि प्रतिनिधि अंतरफलक के पास टिकट मुक्त पाठ स्क्रीन में  एक टिकट लॉक की आवश्यकता है तो परिभाषित करता है(यदि अभी तक टिकट बंद नहीं है,टिकट बंद हो जाए है और वर्तमान प्रतिनिधि उसके मालिक के रूप में अपने आप स्थापित हो जाएगा)।',
        'Defines if a ticket lock is required in the ticket merge screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'यदि प्रतिनिधि अंतरफलक के पास जूम टिकट की विलय स्क्रीन में  एक टिकट लॉक की आवश्यकता है तो परिभाषित करता है(यदि अभी तक टिकट बंद नहीं है,टिकट बंद हो जाए है और वर्तमान प्रतिनिधि उसके मालिक के रूप में अपने आप स्थापित हो जाएगा)।',
        'Defines if a ticket lock is required in the ticket note screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'यदि प्रतिनिधि अंतरफलक के पास टिकट टिप्पणी स्क्रीन में  एक टिकट लॉक की आवश्यकता है तो परिभाषित करता है(यदि अभी तक टिकट बंद नहीं है,टिकट बंद हो जाए है और वर्तमान प्रतिनिधि उसके मालिक के रूप में अपने आप स्थापित हो जाएगा)।',
        'Defines if a ticket lock is required in the ticket owner screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'यदि प्रतिनिधि अंतरफलक के पास जूम टिकट की स्वामी स्क्रीन में  एक टिकट लॉक की आवश्यकता है तो परिभाषित करता है(यदि अभी तक टिकट बंद नहीं है,टिकट बंद हो जाए है और वर्तमान प्रतिनिधि उसके मालिक के रूप में अपने आप स्थापित हो जाएगा)।',
        'Defines if a ticket lock is required in the ticket pending screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'यदि प्रतिनिधि अंतरफलक के पास जूम टिकट की विचाराधीन स्क्रीन में  एक टिकट लॉक की आवश्यकता है तो परिभाषित करता है(यदि अभी तक टिकट बंद नहीं है,टिकट बंद हो जाए है और वर्तमान प्रतिनिधि उसके मालिक के रूप में अपने आप स्थापित हो जाएगा)।',
        'Defines if a ticket lock is required in the ticket phone inbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket phone outbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'यदि प्रतिनिधि अंतरफलक के पास टिकट फोन आउटबाउंड स्क्रीन में  एक टिकट लॉक की आवश्यकता है तो परिभाषित करता है(यदि अभी तक टिकट बंद नहीं है,टिकट बंद हो जाए है और वर्तमान प्रतिनिधि उसके मालिक के रूप में अपने आप स्थापित हो जाएगा)।',
        'Defines if a ticket lock is required in the ticket priority screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'यदि प्रतिनिधि अंतरफलक के पास जूम टिकट की प्राथमिकता स्क्रीन में  एक टिकट लॉक की आवश्यकता है तो परिभाषित करता है(यदि अभी तक टिकट बंद नहीं है,टिकट बंद हो जाए है और वर्तमान प्रतिनिधि उसके मालिक के रूप में अपने आप स्थापित हो जाएगा)।',
        'Defines if a ticket lock is required in the ticket responsible screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'यदि प्रतिनिधि अंतरफलक के पास टिकट उत्तरदायी स्क्रीन में  एक टिकट लॉक की आवश्यकता है तो परिभाषित करता है(यदि अभी तक टिकट बंद नहीं है,टिकट बंद हो जाए है और वर्तमान प्रतिनिधि उसके मालिक के रूप में अपने आप स्थापित हो जाएगा)।',
        'Defines if a ticket lock is required to change the customer of a ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'यदि प्रतिनिधि अंतरफलक के पास टिकट का ग्राहक बदलने के लिए एक टिकट लॉक की आवश्यकता है तो परिभाषित करता है(यदि अभी तक टिकट बंद नहीं है,टिकट बंद हो जाए है और वर्तमान प्रतिनिधि उसके मालिक के रूप में अपने आप स्थापित हो जाएगा)।',
        'Defines if composed messages have to be spell checked in the agent interface.' =>
            'यदि प्रतिनिधि अंतरफलक में रचना संदेश की वर्तनी की जाँच की जानी है तो परिभाषित करता है।',
        'Defines if the enhanced mode should be used (enables use of table, replace, subscript, superscript, paste from word, etc.).' =>
            '',
        'Defines if time accounting is mandatory in the agent interface.' =>
            'यदि समय लेखांकन प्रतिनिधि अंतरफलक में अनिवार्य है तो परिभाषित करता है।',
        'Defines if time accounting must be set to all tickets in bulk action.' =>
            '',
        'Defines scheduler PID update time in seconds (floating point number).' =>
            '',
        'Defines scheduler sleep time in seconds after processing all available tasks (floating point number).' =>
            '',
        'Defines the IP regular expression for accessing the local repository. You need to enable this to have access to your local repository and the package::RepositoryList is required on the remote host.' =>
            'स्थानीय भंडार तक पहुँचने के लिए आईपी नियमित अभिव्यक्ति परिभाषित करें। आपको अपनी स्थानीय भंडार का उपयोग करने के लिए यह सक्षम करने आवश्यकता है और पैकेज:: स्रोत सूची दूरस्थ मेजबान पर आवश्यक है।',
        'Defines the URL CSS path.' => 'URL CSS पथ को परिभाषित करता है।',
        'Defines the URL base path of icons, CSS and Java Script.' => 'चिह्न,CSS और जावा स्क्रिप्ट का URL आधार पथ को परिभाषित करता है।',
        'Defines the URL image path of icons for navigation.' => 'नेविगेशन के लिए URL चिह्न की छवि पथ को परिभाषित करता है।',
        'Defines the URL java script path.' => 'URL जावा स्क्रिप्ट पथ को परिभाषित करता है।',
        'Defines the URL rich text editor path.' => 'URL समृद्ध पाठ संपादक पथ को परिभाषित करता है।',
        'Defines the address of a dedicated DNS server, if necessary, for the "CheckMXRecord" look-ups.' =>
            '"CheckMXRecord" देखने के लिए,यदि आवश्यक हो तो,एक समर्पित DNS सर्वर का पता को परिभाषित करता है।',
        'Defines the body text for notification mails sent to agents, about new password (after using this link the new password will be sent).' =>
            'नए कूटशब्द के बारे में, प्रतिनिधि को भेजा जाने वाला अधिसूचना मेल के लिए मुख्य-भाग पाठ को परिभाषित करता है(नया कूटशब्द इस लिंक का उपयोग करने के बाद भेजा जाएगा)। ',
        'Defines the body text for notification mails sent to agents, with token about new requested password (after using this link the new password will be sent).' =>
            'नए शब्दकूट अनुरोध के बारे में प्रतीक के साथ,प्रतिनिधि को भेजा जाने वाला अधिसूचना मेल के लिए मुख्य-भाग पाठ को परिभाषित करता है(नया कूटशब्द इस लिंक का उपयोग करने के बाद भेजा जाएगा)।',
        'Defines the body text for notification mails sent to customers, about new account.' =>
            'नए खाते के बारे में,ग्राहकों को भेजा जाने वाला अधिसूचना मेल के लिए मुख्य-भाग पाठ परिभाषित करें।',
        'Defines the body text for notification mails sent to customers, about new password (after using this link the new password will be sent).' =>
            'नए कूटशब्द के बारे में, ग्राहकों को भेजा जाने वाला अधिसूचना मेल के लिए मुख्य-भाग पाठ को परिभाषित करता है(नया कूटशब्द इस लिंक का उपयोग करने के बाद भेजा जाएगा)।',
        'Defines the body text for notification mails sent to customers, with token about new requested password (after using this link the new password will be sent).' =>
            'नए शब्दकूट अनुरोध के बारे में प्रतीक के साथ,ग्राहकों को भेजा जाने वाला अधिसूचना मेल के लिए मुख्य-भाग पाठ को परिभाषित करता है(नया कूटशब्द इस लिंक का उपयोग करने के बाद भेजा जाएगा)।',
        'Defines the body text for rejected emails.' => 'अस्वीकृत ईमेल मुख्य-भाग लिए के पाठ को परिभाषित करता है।',
        'Defines the boldness of the line drawed by the graph.' => 'रेखा-चित्र द्वारा बनाई रेखा की धृष्टता को परिभाषित करता है।',
        'Defines the colors for the graphs.' => 'रेखा-चित्र के लिए रंग को परिभाषित करता है।',
        'Defines the column to store the keys for the preferences table.' =>
            'वरीयताएँ तालिका के लिए चाबी संग्रहीत स्तंभ को परिभाषित करता है।',
        'Defines the config parameters of this item, to be shown in the preferences view.' =>
            'वरीयता दृश्य में देखने के लिए,इस वस्तु का विन्यास पैरामीटर को परिभाषित करता है।',
        'Defines the config parameters of this item, to be shown in the preferences view. Take care to maintain the dictionaries installed in the system in the data section.' =>
            'वरीयता दृश्य में देखने के लिए,इस वस्तु का विन्यास पैरामीटर परिभाषित करें। आंकड़ों खंड में प्रणाली में स्थापित शब्दकोश बनाए रखने के लिए ध्यान रखना।',
        'Defines the connections for http/ftp, via a proxy.' => 'एक प्रॉक्सी के माध्यम से,Http/ftp के लिए कनेक्शन को परिभाषित करता है।',
        'Defines the date input format used in forms (option or input fields).' =>
            'तारीख निवेश रूपों में उपयोग प्रारूप को परिभाषित करता है(विकल्प या निवेश क्षेत्र)।',
        'Defines the default CSS used in rich text editors.' => 'समृद्ध पाठ संपादकों में प्रयुक्त तयशुदा CSS को परिभाषित करता है।',
        'Defines the default auto response type of the article for this operation.' =>
            '',
        'Defines the default body of a note in the ticket free text screen of the agent interface.' =>
            'प्रतिनिधि अग्रांत से टिकट मुक्त पाठ स्क्रीन में एक टिप्पणी के तयशुदा मुख्य-भाग को परिभाषित करता है।',
        'Defines the default front-end (HTML) theme to be used by the agents and customers. The default themes are Standard and Lite. If you like, you can add your own theme. Please refer the administrator manual located at http://doc.otrs.org/.' =>
            'प्रतिनिधि और ग्राहकों द्वारा उपयोग किया जाने वाला तयशुदा दृश्यपटल (HTML) की थीम को परिभाषित करता है। तयशुदा थीम मानक और लाइट हैं। यदि आप चाहें, तो आप अपने खुद के थीम जोड़ सकते हैं। कृपया  http://doc.otrs.org/ पर स्थित प्रशासक पुस्तिका देखें।',
        'Defines the default front-end language. All the possible values are determined by the available language files on the system (see the next setting).' =>
            'तयशुदा अग्रांत भाषा परिभाषित करें। सभी संभावित मान प्रणाली पर उपलब्ध भाषा फ़ाइलों से निर्धारित होते हैं(अगली व्यवस्थाओ को देखें)।',
        'Defines the default history type in the customer interface.' => 'ग्राहक अंतरफलक में तयशुदा इतिहास के प्रकार को परिभाषित करता है।',
        'Defines the default maximum number of X-axis attributes for the time scale.' =>
            'समय के पैमाने के लिए X-अक्ष विशेषताओं की तयशुदा अधिकतम संख्या को परिभाषित करता है।',
        'Defines the default maximum number of search results shown on the overview page.' =>
            'अवलोकन पृष्ठ पर दिखने वाले खोज परिणामों की तयशुदा अधिकतम संख्या को परिभाषित करता है।',
        'Defines the default next state for a ticket after customer follow up in the customer interface.' =>
            'ग्राहक अंतरफलक में ग्राहक की अनुवर्ती कार्रवाई करने के बाद टिकट की तयशुदा अगली स्थिति को परिभाषित करता है।',
        'Defines the default next state of a ticket after adding a note, in the close ticket screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के बंद टिकट की स्क्रीन पर,एक टिप्पणी जोड़ने के बाद टिकट की अगली तयशुदा स्थिति को परिभाषित करता है।',
        'Defines the default next state of a ticket after adding a note, in the ticket bulk screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट की थोक स्क्रीन में,एक टिप्पणी जोड़ने के बाद टिकट की अगली तयशुदा स्थिति को परिभाषित करता है।',
        'Defines the default next state of a ticket after adding a note, in the ticket free text screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट की मुक्त पाठ स्क्रीन में,एक टिप्पणी जोड़ने के बाद टिकट की अगली तयशुदा स्थिति को परिभाषित करता है।',
        'Defines the default next state of a ticket after adding a note, in the ticket note screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट की टिप्पणी स्क्रीन में,एक टिप्पणी जोड़ने के बाद टिकट की अगली तयशुदा स्थिति को परिभाषित करता है।',
        'Defines the default next state of a ticket after adding a note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'प्रतिनिधि अंतरफलक के  जूम टिकट की स्वामी स्क्रीन में,एक टिप्पणी जोड़ने के बाद टिकट की अगली तयशुदा स्थिति को परिभाषित करता है।',
        'Defines the default next state of a ticket after adding a note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'प्रतिनिधि अंतरफलक के  जूम टिकट की विचाराधीन स्क्रीन में,एक टिप्पणी जोड़ने के बाद टिकट की अगली तयशुदा स्थिति को परिभाषित करता है।',
        'Defines the default next state of a ticket after adding a note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'प्रतिनिधि अंतरफलक के  जूम टिकट की प्राथमिकता स्क्रीन में,एक टिप्पणी जोड़ने के बाद टिकट की अगली तयशुदा स्थिति को परिभाषित करता है।',
        'Defines the default next state of a ticket after adding a note, in the ticket responsible screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट की उत्तरदायी स्क्रीन में,एक टिप्पणी जोड़ने के बाद टिकट की अगली तयशुदा स्थिति को परिभाषित करता है।',
        'Defines the default next state of a ticket after being bounced, in the ticket bounce screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट की फलांग स्क्रीन में,वापस होने के बाद टिकट की अगली तयशुदा स्थिति को परिभाषित करता है।',
        'Defines the default next state of a ticket after being forwarded, in the ticket forward screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट की अग्रिम स्क्रीन में,अग्रेषित होने के बाद टिकट की अगली तयशुदा स्थिति को परिभाषित करता है।',
        'Defines the default next state of a ticket if it is composed / answered in the ticket compose screen of the agent interface.' =>
            'एक टिकट की तयशुदा अगली स्थिति को परिभाषित करता है। यदि यह रचित है/जवाब टिकट की प्रतिनिधि अंतरफलक रचना की स्क्रीन में।',
        'Defines the default note body text for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Defines the default note body text for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के फोन आउटबाउंड स्क्रीन में फोन टिकटों के लिए तयशुदा टिप्पणी मुख्य-भाग पाठ को परिभाषित करता है।',
        'Defines the default priority of follow up customer tickets in the ticket zoom screen in the customer interface.' =>
            'ग्राहक अंतरफलक में टिकट की ज़ूम स्क्रीन पर ग्राहक टिकट के अनुसरण की तयशुदा प्राथमिकता को परिभाषित करता है।',
        'Defines the default priority of new customer tickets in the customer interface.' =>
            'ग्राहक अंतरफलक में नए ग्राहक टिकटों की तयशुदा प्राथमिकता को परिभाषित करता है।',
        'Defines the default priority of new tickets.' => 'नई टिकटों की तयशुदा प्राथमिकता को परिभाषित करता है।',
        'Defines the default queue for new customer tickets in the customer interface.' =>
            'ग्राहक अंतरफलक में नए ग्राहक टिकटों के लिए तयशुदा श्रेणी को परिभाषित करता है।',
        'Defines the default selection at the drop down menu for dynamic objects (Form: Common Specification).' =>
            'सक्रिय वस्तुओं के लिए ड्रॉप डाउन मेनू में तयशुदा चुनाव को परिभाषित करता है(प्रपत्र:सामान्य विशिष्टता)।',
        'Defines the default selection at the drop down menu for permissions (Form: Common Specification).' =>
            'अनुमतियों के लिए ड्रॉप डाउन मेनू में तयशुदा चुनाव को परिभाषित करता है(प्रपत्र:सामान्य विशिष्टता)।',
        'Defines the default selection at the drop down menu for stats format (Form: Common Specification). Please insert the format key (see Stats::Format).' =>
            'आँकड़े प्रारूप के लिए ड्रॉप डाउन मेनू में तयशुदा चुनाव को परिभाषित करता है(प्रपत्र:सामान्य विशिष्टता)। कृपया स्वरूप कुंजी सम्मिलित करें(आँकड़े:प्रारूप देखें)।',
        'Defines the default sender type for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Defines the default sender type for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट की फोन आउटबाउंड स्क्रीन में फोन टिकटों के लिए तयशुदा प्रेषक प्रकार को परिभाषित करता है।',
        'Defines the default sender type for tickets in the ticket zoom screen of the customer interface.' =>
            'ग्राहक अंतरफलक के टिकट की ज़ूम स्क्रीन में फोन टिकटों के लिए तयशुदा प्रेषक प्रकार को परिभाषित करता है।',
        'Defines the default shown ticket search attribute for ticket search screen.' =>
            'टिकट की खोज स्क्रीन के लिए दिखाई टिकट की तयशुदा खोज विशेषता को परिभाषित करता है।',
        'Defines the default shown ticket search attribute for ticket search screen. Example: a text, 1, Search_DynamicField_Field1StartYear=2002; Search_DynamicField_Field1StartMonth=12; Search_DynamicField_Field1StartDay=12; Search_DynamicField_Field1StartHour=00; Search_DynamicField_Field1StartMinute=00; Search_DynamicField_Field1StartSecond=00; Search_DynamicField_Field1StopYear=2009; Search_DynamicField_Field1StopMonth=02; Search_DynamicField_Field1StopDay=10; Search_DynamicField_Field1StopHour=23; Search_DynamicField_Field1StopMinute=59; Search_DynamicField_Field1StopSecond=59;.' =>
            '',
        'Defines the default sort criteria for all queues displayed in the queue view.' =>
            '',
        'Defines the default sort order for all queues in the queue view, after priority sort.' =>
            'प्राथमिकता के आधार पर क्रमबद्ध करने के बाद,श्रेणी दृश्य में प्रदर्शित सभी श्रेणीऔ के लिए तयशुदा क्रमबद्ध करने के क्रम को परिभाषित करता है।',
        'Defines the default spell checker dictionary.' => 'तयशुदा वर्तनी परीक्षक शब्दकोश को परिभाषित करता है।',
        'Defines the default state of new customer tickets in the customer interface.' =>
            'ग्राहक अंतरफलक में नए ग्राहक टिकटों की तयशुदा स्थिति को परिभाषित करता है।',
        'Defines the default state of new tickets.' => 'नये टिकटों की तयशुदा स्थिति को परिभाषित करता है।',
        'Defines the default subject for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Defines the default subject for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट की फोन आउटबाउंड फोन स्क्रीन में टिकटों के लिए तयशुदा विषय को परिभाषित करता है।',
        'Defines the default subject of a note in the ticket free text screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट की मुक्त पाठ स्क्रीन में टिप्पणी के तयशुदा विषय को परिभाषित करता है।',
        'Defines the default ticket attribute for ticket sorting in a ticket search of the customer interface.' =>
            'ग्राहक अंतरफलक के टिकट की खोज में तयशुदा टिकट की छँटाई के लिए टिकट की विशेषता को परिभाषित करता है।',
        'Defines the default ticket attribute for ticket sorting in the escalation view of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के संवर्धित दृश्य में तयशुदा टिकट की छँटाई के लिए टिकट की विशेषता को परिभाषित करता है।',
        'Defines the default ticket attribute for ticket sorting in the locked ticket view of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट के लॉक दृश्य में तयशुदा टिकट की छँटाई के लिए टिकट की विशेषता को परिभाषित करता है।',
        'Defines the default ticket attribute for ticket sorting in the responsible view of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट के उत्तरदायी दृश्य में तयशुदा टिकट की छँटाई के लिए टिकट की विशेषता को परिभाषित करता है।',
        'Defines the default ticket attribute for ticket sorting in the status view of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट के स्तर दृश्य में तयशुदा टिकट की छँटाई के लिए टिकट की विशेषता को परिभाषित करता है।',
        'Defines the default ticket attribute for ticket sorting in the watch view of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट के ध्यानाधीन दृश्य में तयशुदा टिकट की छँटाई के लिए टिकट की विशेषता को परिभाषित करता है।',
        'Defines the default ticket attribute for ticket sorting of the ticket search result of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट के खोज परिणाम में तयशुदा टिकट की छँटाई के लिए टिकट की विशेषता को परिभाषित करता है।',
        'Defines the default ticket bounced notification for customer/sender in the ticket bounce screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट के बाउंस स्क्रीन में ग्राहक/प्रेषक के लिए तयशुदा टिकट के अधिसूचना बाउंस को परिभाषित करता है।',
        'Defines the default ticket next state after adding a phone note in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Defines the default ticket next state after adding a phone note in the ticket phone outbound screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट के फोन आउटबाउंड स्क्रीन में एक फोन टिप्पणी जोड़ने के बाद तयशुदा टिकट की अगली स्थिति को परिभाषित करता है।',
        'Defines the default ticket order (after priority sort) in the escalation view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'प्रतिनिधि अंतरफलक की संवर्धित दृश्य में तयशुदा टिकट के क्रम(प्राथमिकता आधार पर क्रमबद्ध करें करने के बाद) को परिभाषित करता है। ऊपर:शीर्ष पर सबसे पुरानी। नीचे:शीर्ष पर नवीनतम।',
        'Defines the default ticket order (after priority sort) in the status view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'प्रतिनिधि अंतरफलक की स्तर दृश्य में तयशुदा टिकट के क्रम(प्राथमिकता आधार पर क्रमबद्ध करें करने के बाद) को परिभाषित करता है। ऊपर:शीर्ष पर सबसे पुरानी। नीचे:शीर्ष पर नवीनतम।',
        'Defines the default ticket order in the responsible view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'प्रतिनिधि अंतरफलक की उत्तरदायी दृश्य में तयशुदा टिकट के क्रम को परिभाषित करता है। ऊपर:शीर्ष पर सबसे पुरानी। नीचे:शीर्ष पर नवीनतम।',
        'Defines the default ticket order in the ticket locked view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'प्रतिनिधि अंतरफलक की लॉक दृश्य में तयशुदा टिकट के क्रम को परिभाषित करता है। ऊपर:शीर्ष पर सबसे पुरानी। नीचे:शीर्ष पर नवीनतम।',
        'Defines the default ticket order in the ticket search result of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'प्रतिनिधि अंतरफलक की खोज परिणाम में तयशुदा टिकट के क्रम को परिभाषित करता है। ऊपर:शीर्ष पर सबसे पुरानी। नीचे:शीर्ष पर नवीनतम।',
        'Defines the default ticket order in the watch view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'प्रतिनिधि अंतरफलक की ध्यानाधीन दृश्य में तयशुदा टिकट के क्रम को परिभाषित करता है। ऊपर:शीर्ष पर सबसे पुरानी। नीचे:शीर्ष पर नवीनतम।',
        'Defines the default ticket order of a search result in the customer interface. Up: oldest on top. Down: latest on top.' =>
            'ग्राहक अंतरफलक में एक खोज परिणाम के टिकट के तयशुदा क्रम को परिभाषित करता है। ऊपर:शीर्ष पर सबसे पुरानी। नीचे:शीर्ष पर नवीनतम।',
        'Defines the default ticket priority in the close ticket screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट बंद के स्क्रीन में तयशुदा टिकट के प्राथमिकता को परिभाषित करता है।',
        'Defines the default ticket priority in the ticket bulk screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट थोक के स्क्रीन में तयशुदा टिकट के प्राथमिकता को परिभाषित करता है।',
        'Defines the default ticket priority in the ticket free text screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट मुक्त पाठ के स्क्रीन में तयशुदा टिकट के प्राथमिकता को परिभाषित करता है।',
        'Defines the default ticket priority in the ticket note screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट टिप्पणी के स्क्रीन में तयशुदा टिकट के प्राथमिकता को परिभाषित करता है।',
        'Defines the default ticket priority in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'प्रतिनिधि अंतरफलक में जूम टिकट के टिकट स्वामी स्क्रीन में तयशुदा टिकट की प्राथमिकता को परिभाषित करता है।',
        'Defines the default ticket priority in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'प्रतिनिधि अंतरफलक में जूम टिकट के टिकट विचाराधीन स्क्रीन में तयशुदा टिकट की प्राथमिकता को परिभाषित करता है।',
        'Defines the default ticket priority in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'प्रतिनिधि अंतरफलक में जूम टिकट के टिकट प्राथमिकता स्क्रीन में तयशुदा टिकट की प्राथमिकता को परिभाषित करता है।',
        'Defines the default ticket priority in the ticket responsible screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक में जूम टिकट के टिकट उत्तरदायी स्क्रीन में तयशुदा टिकट की प्राथमिकता को परिभाषित करता है।',
        'Defines the default ticket type for new customer tickets in the customer interface.' =>
            '',
        'Defines the default type for article in the customer interface.' =>
            'ग्राहक अंतरफलक में तयशुदा अनुच्छेद प्रकार के लिए को परिभाषित करता है।',
        'Defines the default type of forwarded message in the ticket forward screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट अग्रेषित स्क्रीन में तयशुदा अग्रेषित संदेश के प्रकार को परिभाषित करता है।',
        'Defines the default type of the article for this operation.' => '',
        'Defines the default type of the note in the close ticket screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट बंद स्क्रीन में तयशुदा टिप्पणी के प्रकार को परिभाषित करता है।',
        'Defines the default type of the note in the ticket bulk screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट थोक स्क्रीन में तयशुदा टिप्पणी के प्रकार को परिभाषित करता है।',
        'Defines the default type of the note in the ticket free text screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट मुक्त पाठ स्क्रीन में तयशुदा टिप्पणी के प्रकार को परिभाषित करता है।',
        'Defines the default type of the note in the ticket note screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट टिप्पणी स्क्रीन में तयशुदा टिप्पणी के प्रकार को परिभाषित करता है।',
        'Defines the default type of the note in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'प्रतिनिधि अंतरफलक में जूम टिकट के टिकट स्वामी स्क्रीन में तयशुदा टिप्पणी के प्रकार को परिभाषित करता है।',
        'Defines the default type of the note in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'प्रतिनिधि अंतरफलक में जूम टिकट के टिकट विचाराधीन स्क्रीन में तयशुदा टिप्पणी के प्रकार को परिभाषित करता है।',
        'Defines the default type of the note in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Defines the default type of the note in the ticket phone outbound screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट फोन आउटबाउंड स्क्रीन में तयशुदा टिप्पणी के प्रकार को परिभाषित करता है।',
        'Defines the default type of the note in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'प्रतिनिधि अंतरफलक में जूम टिकट के टिकट प्राथमिकता स्क्रीन में तयशुदा टिप्पणी के प्रकार को परिभाषित करता है।',
        'Defines the default type of the note in the ticket responsible screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट उत्तरदायी स्क्रीन में तयशुदा टिप्पणी के प्रकार को परिभाषित करता है।',
        'Defines the default type of the note in the ticket zoom screen of the customer interface.' =>
            'ग्राहक अंतरफलक के ज़ूम स्क्रीन पर तयशुदा टिप्पणी के प्रकार को परिभाषित करता है।',
        'Defines the default used Frontend-Module if no Action parameter given in the url on the agent interface.' =>
            'यदि प्रतिनिधि अंतरफलक के url में कोई कार्रवाई प्रतिमान नहीं दिया जाता है तो मुखपटल-मॉड्यूल के प्रयोग को परिभाषित करता है।',
        'Defines the default used Frontend-Module if no Action parameter given in the url on the customer interface.' =>
            'यदि ग्राहक अंतरफलक के url में कोई कार्रवाई प्रतिमान नहीं दिया जाता है तो मुखपटल-मॉड्यूल के प्रयोग को परिभाषित करता है।',
        'Defines the default value for the action parameter for the public frontend. The action parameter is used in the scripts of the system.' =>
            'सार्वजनिक मुखपटल के लिए कार्रवाई प्रतिमान के तयशुदा मान को परिभाषित करता है। क्रिया प्रतिमान प्रणाली की लिपियों में प्रयोग किया जाता है।',
        'Defines the default viewable sender types of a ticket (default: customer).' =>
            'एक टिकट के तयशुदा देखने योग्य प्रेषक के प्रकार को परिभाषित करता है(तयशुदा:ग्राहक)।',
        'Defines the filter that processes the text in the articles, in order to highlight URLs.' =>
            'URLs को उजागर करने के लिए,अनुच्छेद के पाठ की प्रक्रियाओं के लिए निस्पादक को परिभाषित करता है।',
        'Defines the format of responses in the ticket compose screen of the agent interface ($QData{"OrigFrom"} is From 1:1, $QData{"OrigFromName"} is only realname of From).' =>
            'प्रतिनिधि अंतरफलक के टिकट रचना स्क्रीन में प्रतिक्रियाओं के प्रारूप को परिभाषित करता है($ QData {"OrigFrom"} 1:1 से है, $ QData {"OrigFromName"} केवल से का असली नाम है)। ',
        'Defines the fully qualified domain name of the system. This setting is used as a variable, OTRS_CONFIG_FQDN which is found in all forms of messaging used by the application, to build links to the tickets within your system.' =>
            'पूरी तरह से योग्य प्रणाली के डोमेन नाम को परिभाषित करता है। यह व्यवस्था किसी परिवर्तनीय के रूप में प्रयोग की जाती है, OTRS_CONFIG_FQDN जो अनुप्रयोग द्वारा उपयोग संदेश प्रेषण के सभी रूपों में पाया जाता है,आपकी प्रणाली में टिकटों के लिए लिंक बनाने के लिए।',
        'Defines the groups every customer user will be in (if CustomerGroupSupport is enabled and you don\'t want to manage every user for these groups).' =>
            'प्रत्येक ग्राहक उपयोगकर्ता जिन समूहों में होगा को परिभाषित करता है(यदि CustomerGroupSupport सक्षम है और आप इन समूहों के लिए प्रत्येक उपयोगकर्ता का प्रबंधन नहीं करना चाहते हैं)। ',
        'Defines the height for the rich text editor component for this screen. Enter number (pixels) or percent value (relative).' =>
            '',
        'Defines the height for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            '',
        'Defines the height of the legend.' => 'किंवदंती की ऊँचाई को परिभाषित करता है।',
        'Defines the history comment for the close ticket screen action, which gets used for ticket history in the agent interface.' =>
            'बंद टिकट स्क्रीन कार्रवाई के लिए इतिहास समीक्षा को परिभाषित करता है,जो टिकट इतिहास के लिए प्रतिनिधि अंतरफलक में इस्तेमाल किया जाता है।',
        'Defines the history comment for the email ticket screen action, which gets used for ticket history in the agent interface.' =>
            'ईमेल टिकट स्क्रीन कार्रवाई के लिए इतिहास समीक्षा को परिभाषित करता है,जो टिकट इतिहास के लिए प्रतिनिधि अंतरफलक में इस्तेमाल किया जाता है।',
        'Defines the history comment for the phone ticket screen action, which gets used for ticket history in the agent interface.' =>
            'फ़ोन टिकट स्क्रीन कार्रवाई के लिए इतिहास समीक्षा को परिभाषित करता है,जो टिकट इतिहास के लिए प्रतिनिधि अंतरफलक में इस्तेमाल किया जाता है।',
        'Defines the history comment for the ticket free text screen action, which gets used for ticket history.' =>
            'टिकट मुक्त पाठ स्क्रीन कार्रवाई के लिए इतिहास समीक्षा को परिभाषित करता है,जो टिकट इतिहास के लिए इस्तेमाल किया जाता है।',
        'Defines the history comment for the ticket note screen action, which gets used for ticket history in the agent interface.' =>
            'टिकट टिप्पणी स्क्रीन कार्रवाई के लिए इतिहास समीक्षा को परिभाषित करता है,जो टिकट इतिहास के लिए प्रतिनिधि अंतरफलक में इस्तेमाल किया जाता है।',
        'Defines the history comment for the ticket owner screen action, which gets used for ticket history in the agent interface.' =>
            'टिकट स्वामी स्क्रीन कार्रवाई के लिए इतिहास समीक्षा को परिभाषित करता है,जो टिकट इतिहास के लिए प्रतिनिधि अंतरफलक में इस्तेमाल किया जाता है।',
        'Defines the history comment for the ticket pending screen action, which gets used for ticket history in the agent interface.' =>
            'टिकट विचाराधीन स्क्रीन कार्रवाई के लिए इतिहास समीक्षा को परिभाषित करता है,जो टिकट इतिहास के लिए प्रतिनिधि अंतरफलक में इस्तेमाल किया जाता है।',
        'Defines the history comment for the ticket phone inbound screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the ticket phone outbound screen action, which gets used for ticket history in the agent interface.' =>
            'टिकट फोन आउटबाउंड स्क्रीन कार्रवाई के लिए इतिहास समीक्षा को परिभाषित करता है,जो टिकट इतिहास के लिए प्रतिनिधि अंतरफलक में इस्तेमाल किया जाता है।',
        'Defines the history comment for the ticket priority screen action, which gets used for ticket history in the agent interface.' =>
            'टिकट प्राथमिकता स्क्रीन कार्रवाई के लिए इतिहास समीक्षा को परिभाषित करता है,जो टिकट इतिहास के लिए प्रतिनिधि अंतरफलक में इस्तेमाल किया जाता है।',
        'Defines the history comment for the ticket responsible screen action, which gets used for ticket history in the agent interface.' =>
            'टिकट उत्तरदायी स्क्रीन कार्रवाई के लिए इतिहास समीक्षा को परिभाषित करता है,जो टिकट इतिहास के लिए प्रतिनिधि अंतरफलक में इस्तेमाल किया जाता है।',
        'Defines the history comment for the ticket zoom action, which gets used for ticket history in the customer interface.' =>
            'टिकट ज़ूम कार्रवाई के लिए इतिहास समीक्षा को परिभाषित करता है,जो टिकट इतिहास के लिए ग्राहक अंतरफलक में प्रयोग किया जाता है।',
        'Defines the history comment for this operation, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the close ticket screen action, which gets used for ticket history in the agent interface.' =>
            'बंद टिकट स्क्रीन कार्रवाई के लिए इतिहास के प्रकार को परिभाषित करता है,जो टिकट इतिहास के लिए प्रतिनिधि अंतरफलक में इस्तेमाल किया जाता है।',
        'Defines the history type for the email ticket screen action, which gets used for ticket history in the agent interface.' =>
            'ईमेल टिकट स्क्रीन कार्रवाई के लिए इतिहास के प्रकार को परिभाषित करता है,जो टिकट इतिहास के लिए प्रतिनिधि अंतरफलक में इस्तेमाल किया जाता है।',
        'Defines the history type for the phone ticket screen action, which gets used for ticket history in the agent interface.' =>
            'फोन टिकट स्क्रीन कार्रवाई के लिए इतिहास के प्रकार को परिभाषित करता है,जो टिकट इतिहास के लिए प्रतिनिधि अंतरफलक में इस्तेमाल किया जाता है।',
        'Defines the history type for the ticket free text screen action, which gets used for ticket history.' =>
            'टिकट मुक्त पाठ स्क्रीन कार्रवाई के लिए इतिहास के प्रकार को परिभाषित करता है,जो टिकट इतिहास के लिए इस्तेमाल किया जाता है।',
        'Defines the history type for the ticket note screen action, which gets used for ticket history in the agent interface.' =>
            'टिकट टिप्पणी स्क्रीन कार्रवाई के लिए इतिहास के प्रकार को परिभाषित करता है,जो टिकट इतिहास के लिए प्रतिनिधि अंतरफलक में इस्तेमाल किया जाता है।',
        'Defines the history type for the ticket owner screen action, which gets used for ticket history in the agent interface.' =>
            'टिकट स्वामी स्क्रीन कार्रवाई के लिए इतिहास के प्रकार को परिभाषित करता है,जो टिकट इतिहास के लिए प्रतिनिधि अंतरफलक में इस्तेमाल किया जाता है।',
        'Defines the history type for the ticket pending screen action, which gets used for ticket history in the agent interface.' =>
            'टिकट विचाराधीन स्क्रीन कार्रवाई के लिए इतिहास के प्रकार को परिभाषित करता है,जो टिकट इतिहास के लिए प्रतिनिधि अंतरफलक में इस्तेमाल किया जाता है।',
        'Defines the history type for the ticket phone inbound screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the ticket phone outbound screen action, which gets used for ticket history in the agent interface.' =>
            'टिकट फोन आउटबाउंड स्क्रीन कार्रवाई के लिए इतिहास के प्रकार को परिभाषित करता है,जो टिकट इतिहास के लिए प्रतिनिधि अंतरफलक में इस्तेमाल किया जाता है।',
        'Defines the history type for the ticket priority screen action, which gets used for ticket history in the agent interface.' =>
            'टिकट प्राथमिकता स्क्रीन कार्रवाई के लिए इतिहास के प्रकार को परिभाषित करता है,जो टिकट इतिहास के लिए प्रतिनिधि अंतरफलक में इस्तेमाल किया जाता है।',
        'Defines the history type for the ticket responsible screen action, which gets used for ticket history in the agent interface.' =>
            'टिकट उत्तरदायी स्क्रीन कार्रवाई के लिए इतिहास के प्रकार को परिभाषित करता है,जो टिकट इतिहास के लिए प्रतिनिधि अंतरफलक में इस्तेमाल किया जाता है।',
        'Defines the history type for the ticket zoom action, which gets used for ticket history in the customer interface.' =>
            'टिकट ज़ूम कार्रवाई के लिए इतिहास के प्रकार को परिभाषित करता है,जो टिकट इतिहास के लिए ग्राहक अंतरफलक में प्रयोग किया जाता है।',
        'Defines the history type for this operation, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the hours and week days of the indicated calendar, to count the working time.' =>
            '',
        'Defines the hours and week days to count the working time.' => 'कार्य समय की गणना करने के लिए घंटे और सप्ताह के दिनों को परिभाषित करता है।',
        'Defines the key to be checked with Kernel::Modules::AgentInfo module. If this user preferences key is true, the message is accepted by the system.' =>
            'Kernel::Modules::AgentInfo मॉड्यूल के साथ जाँच करने के लिए कुंजी को परिभाषित करता है। यदि यह उपयोगकर्ता वरीयता कुंजी सही है,तो संदेश प्रणाली द्वारा स्वीकार कर लिए जाते हैं।',
        'Defines the key to check with CustomerAccept. If this user preferences key is true, then the message is accepted by the system.' =>
            'ग्राहकस्वीकार के साथ जाँच करने के लिए कुंजी को परिभाषित करता है। यदि यह उपयोगकर्ता वरीयता कुंजी सही है,तो संदेश प्रणाली द्वारा स्वीकार कर लिए जाते हैं।',
        'Defines the link type \'Normal\'. If the source name and the target name contain the same value, the resulting link is a non-directional one; otherwise, the result is a directional link.' =>
            '\'सामान्य\' लिंक के प्रकार को परिभाषित करता है। यदि स्रोत नाम और लक्ष्य नाम का एक ही मान है,तो परिणामी लिंक गैर दिशात्मक है;अन्यथा,परिणाम एक दिशात्मक लिंक है।',
        'Defines the link type \'ParentChild\'. If the source name and the target name contain the same value, the resulting link is a non-directional one; otherwise, the result is a directional link.' =>
            '\'जनक\बालक\' लिंक के प्रकार को परिभाषित करता है। यदि स्रोत नाम और लक्ष्य नाम का एक ही मान है,तो परिणामी लिंक गैर दिशात्मक है;अन्यथा,परिणाम एक दिशात्मक लिंक है।',
        'Defines the link type groups. The link types of the same group cancel one another. Example: If ticket A is linked per a \'Normal\' link with ticket B, then these tickets could not be additionally linked with link of a \'ParentChild\' relationship.' =>
            'लिंक के प्रकार समूहों को परिभाषित करता है। एक ही समूह के लिंक प्रकार एक दूसरे को रद्द कर देंगे।उदाहरण: यदि टिकट A टिकट B के साथ एक \'सामान्य\' लिंक के अनुसार जुड़ा हुआ है,तब इन टिकटों को \'जनक\बालक\' संबंध की लिंक के साथ नहीं जोड़ा जा सकता है।',
        'Defines the list of online repositories. Another installations can be used as repository, for example: Key="http://example.com/otrs/public.pl?Action=PublicRepository;File=" and Content="Some Name".' =>
            '',
        'Defines the location to get online repository list for additional packages. The first available result will be used.' =>
            'अतिरिक्त संकुल के लिए ऑनलाइन भंडार सूची प्राप्त करने के लिए स्थान को परिभाषित करता है। पहले उपलब्ध परिणाम का उपयोग किया जाएगा।',
        'Defines the log module for the system. "File" writes all messages in a given logfile, "SysLog" uses the syslog daemon of the system, e.g. syslogd.' =>
            'प्रणाली के लिए अभिलेख मॉड्यूल को परिभाषित करता है। "फाइल" सभी संदेशों को किसी दिए गए अभिलेखफ़ाइल में लिखता है,"syslog" प्रणाली के syslog डेमॉन का उपयोग करता है, जैसे syslogd।',
        'Defines the maximal size (in bytes) for file uploads via the browser.' =>
            'ब्राउज़र के माध्यम से फ़ाइल अपलोड करने के लिए अधिकतम(बाइट में) आकार को परिभाषित करता है।',
        'Defines the maximal valid time (in seconds) for a session id.' =>
            'सत्र के लिए अधिकतम मान्य समय (सेकेंड में) पहचान को परिभाषित करता है।',
        'Defines the maximum length (in characters) for a scheduler task data. WARNING: Do not modify this setting unless you are sure of the current Database length for \'task_data\' filed from \'scheduler_data_list\' table.' =>
            '',
        'Defines the maximum number of pages per PDF file.' => 'PDF फ़ाइल के अनुसार पृष्ठों की अधिकतम संख्या को परिभाषित करता है।',
        'Defines the maximum size (in MB) of the log file.' => 'अभिलेख फ़ाइल के अधिकतम आकार(MB में) को परिभाषित करता है।',
        'Defines the module that shows a generic notification in the agent interface. Either "Text" - if configured - or the contents of "File" will be displayed.' =>
            '',
        'Defines the module that shows all the currently loged in customers in the agent interface.' =>
            'प्रतिनिधि अंतरफलक में वर्तमान में सभी प्रवॆशित ग्राहकों को दिखाने वाले मॉड्यूल को परिभाषित करता है।',
        'Defines the module that shows all the currently logged in agents in the agent interface.' =>
            'प्रतिनिधि अंतरफलक में वर्तमान में सभी प्रवॆशित प्रतिनिधियॊ को दिखाने वाले मॉड्यूल को परिभाषित करता है।',
        'Defines the module that shows the currently loged in agents in the customer interface.' =>
            'ग्राहक अंतरफलक में वर्तमान में सभी प्रवॆशित प्रतिनिधियॊ को दिखाने वाले मॉड्यूल को परिभाषित करता है।',
        'Defines the module that shows the currently loged in customers in the customer interface.' =>
            'ग्राहक अंतरफलक में वर्तमान में सभी प्रवॆशित ग्राहकों को दिखाने वाले मॉड्यूल को परिभाषित करता है।',
        'Defines the module to authenticate customers.' => 'ग्राहकों को प्रमाणित करने वाले मॉड्यूल को परिभाषित करता है।',
        'Defines the module to display a notification in the agent interface, (only for agents on the admin group) if the scheduler is not running.' =>
            '',
        'Defines the module to display a notification in the agent interface, if the agent is logged in while having out-of-office active.' =>
            '',
        'Defines the module to display a notification in the agent interface, if the system is used by the admin user (normally you shouldn\'t work as admin).' =>
            'प्रतिनिधि अंतरफलक में एक अधिसूचना प्रदर्शित करने के लिए मॉड्यूल को परिभाषित करता है,अगर प्रणाली व्यवस्थापक उपयोगकर्ता के द्वारा प्रयोग किया जाता है (सामान्यतः आपको व्यवस्थापक के रूप में काम नहीं करना चाहिए)।',
        'Defines the module to generate html refresh headers of html sites, in the customer interface.' =>
            'ग्राहक अंतरफलक में html साइटों के html ताज़ाकरण हेडर उत्पन्न करने के लिए मॉड्यूल को परिभाषित करता है।',
        'Defines the module to generate html refresh headers of html sites.' =>
            'html साइटों के html ताज़ाकरण हेडर उत्पन्न करने के लिए मॉड्यूल को परिभाषित करता है।',
        'Defines the module to send emails. "Sendmail" directly uses the sendmail binary of your operating system. Any of the "SMTP" mechanisms use a specified (external) mailserver. "DoNotSendEmail" doesn\'t send emails and it is useful for test systems.' =>
            'मॉड्यूल ईमेल भेजने करने को परिभाषित करता है। "सेंडमेल" सीधे आपके ऑपरेटिंग सिस्टम  केद्विआधारी sendmail का उपयोग करता है। "SMTP" तंत्र का कोई भी एक निर्दिष्ट MailServer (बाह्य) का उपयोग करें। "DoNotSendEmail" ईमेल नहीं भेज सकता और यह परीक्षण प्रणालियों के लिए उपयोगी है।',
        'Defines the module used to store the session data. With "DB" the frontend server can be splitted from the db server. "FS" is faster.' =>
            'सत्र आंकड़ों को संग्रह करने के लिए मॉड्यूल को परिभाषित करता है। "DB" के साथ दृश्यपटल सर्वर को db सर्वर से विभाजित किया जा सकता है।  "FS" तेज है।',
        'Defines the name of the application, shown in the web interface, tabs and title bar of the web browser.' =>
            'अनुप्रयोग का नाम,वेब अंतरफलक में दिखाए गए, वेब ब्राउज़र के टैब और शीर्षक पट्टी को परिभाषित करता।',
        'Defines the name of the column to store the data in the preferences table.' =>
            'वरीयताओं तालिका में आंकड़ों को संग्रह करने के लिए कॉलम के नाम को परिभाषित करता है। ',
        'Defines the name of the column to store the user identifier in the preferences table.' =>
            'वरीयताओं तालिका में उपयोगकर्ता पहचानक के लिए कॉलम के नाम को परिभाषित करता है।',
        'Defines the name of the indicated calendar.' => '',
        'Defines the name of the key for customer sessions.' => 'ग्राहक सत्र के लिए कुंजी का नाम को परिभाषित करता है।',
        'Defines the name of the session key. E.g. Session, SessionID or OTRS.' =>
            'सत्र कुंजी के नाम को परिभाषित करता है। उदा. सत्र SessionID,या OTRS।',
        'Defines the name of the table, where the customer preferences are stored.' =>
            'तालिका के नाम को परिभाषित करता है,जहाँ  ग्राहक वरीयताओं संग्रहीत हैं।',
        'Defines the next possible states after composing / answering a ticket in the ticket compose screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट रचना स्क्रीन में रचना/जवाब टिकट  के बाद अगली संभव स्थिति को परिभाषित करता है।',
        'Defines the next possible states after forwarding a ticket in the ticket forward screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट अग्रेषित स्क्रीन में अग्रेषण टिकट के बाद  के बाद अगली संभव स्थिति को परिभाषित करता है।',
        'Defines the next possible states for customer tickets in the customer interface.' =>
            'ग्राहक अंतरफलक में ग्राहक टिकटों के लिए अगली संभव स्थिति को परिभाषित करता है।',
        'Defines the next state of a ticket after adding a note, in the close ticket screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के बंद टिकट स्क्रीन में टिप्पणी जोड़ने के बाद एक टिकट के अगली स्थिति को परिभाषित करता है।',
        'Defines the next state of a ticket after adding a note, in the ticket bulk screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट थोक स्क्रीन में टिप्पणी जोड़ने के बाद एक टिकट के अगली स्थिति को परिभाषित करता है।',
        'Defines the next state of a ticket after adding a note, in the ticket free text screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट मुक्त पाठ स्क्रीन में टिप्पणी जोड़ने के बाद एक टिकट के अगली स्थिति को परिभाषित करता है।',
        'Defines the next state of a ticket after adding a note, in the ticket note screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट टिप्पणी स्क्रीन में टिप्पणी जोड़ने के बाद एक टिकट के अगली स्थिति को परिभाषित करता है।',
        'Defines the next state of a ticket after adding a note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'प्रतिनिधि अंतरफलक के जूम टिकट की स्वामी स्क्रीन में टिप्पणी जोड़ने के बाद एक टिकट के अगली स्थिति को परिभाषित करता है।',
        'Defines the next state of a ticket after adding a note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'प्रतिनिधि अंतरफलक के जूम टिकट की विचाराधीन स्क्रीन में टिप्पणी जोड़ने के बाद एक टिकट के अगली स्थिति को परिभाषित करता है।',
        'Defines the next state of a ticket after adding a note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'प्रतिनिधि अंतरफलक के जूम टिकट की प्राथमिकता स्क्रीन में टिप्पणी जोड़ने के बाद एक टिकट के अगली स्थिति को परिभाषित करता है।',
        'Defines the next state of a ticket after adding a note, in the ticket responsible screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट उत्तरदायी स्क्रीन में टिप्पणी जोड़ने के बाद एक टिकट के अगली स्थिति को परिभाषित करता है।',
        'Defines the next state of a ticket after being bounced, in the ticket bounce screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट फलांग स्क्रीन में टिप्पणी जोड़ने के बाद एक टिकट के अगली स्थिति को परिभाषित करता है।',
        'Defines the next state of a ticket after being moved to another queue, in the move ticket screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के स्थानांतरित टिकट स्क्रीन में अन्य श्रेणी में स्थानांतरित हो जाने के बाद टिकट के अगली स्थिति को परिभाषित करता है।',
        'Defines the parameters for the customer preferences table.' => 'ग्राहक वरीयता तालिका के लिए मापदंडों को परिभाषित करता है।',
        'Defines the parameters for the dashboard backend. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin.' =>
            'पटल के लिए मापदंडों के बैकेंड को परिभाषित करता है। प्लगइन के उपयोग को सीमित करने के लिए "समूह" का प्रयोग किया जाता है(उदाहरण के लिए समूह: व्यवस्थापक, group1; समूह 2;)। "तयशुदा" इंगित करता है कि यदि प्लगइन तयशुदा रूप से सक्रिय है या उपयोगकर्ता के लिए उसे मैन्युअल रूप से सक्षम की जरूरत है। "CacheTTL" प्लगइन के लिए द्रुतिका समाप्ति अवधि(मिनट में) के संकेत करता है।',
        'Defines the parameters for the dashboard backend. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" defines the cache expiration period in minutes for the plugin.' =>
            'पटल के लिए मापदंडों के बैकेंड को परिभाषित करता है। प्लगइन के उपयोग को सीमित करने के लिए "समूह" का प्रयोग किया जाता है(उदाहरण के लिए समूह: व्यवस्थापक, group1; समूह 2;)। "तयशुदा" इंगित करता है कि यदि प्लगइन तयशुदा रूप से सक्रिय है या उपयोगकर्ता के लिए उसे मैन्युअल रूप से सक्षम की जरूरत है। "CacheTTLocal" प्लगइन के लिए द्रुतिका समाप्ति अवधि(मिनट में) के संकेत करता है।',
        'Defines the parameters for the dashboard backend. "Limit" defines the number of entries displayed by default. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin.' =>
            'पटल के लिए मापदंडों के बैकेंड को परिभाषित करता है। "सीमा" तयशुदा रूप से प्रदर्शित प्रविष्टियों की संख्या को परिभाषित करता है। प्लगइन के उपयोग को सीमित करने के लिए "समूह" का प्रयोग किया जाता है(उदाहरण के लिए समूह: व्यवस्थापक, group1; समूह 2;)। "तयशुदा" इंगित करता है कि यदि प्लगइन तयशुदा रूप से सक्रिय है या उपयोगकर्ता के लिए उसे मैन्युअल रूप से सक्षम की जरूरत है। "CacheTTL" प्लगइन के लिए द्रुतिका समाप्ति अवधि(मिनट में) के संकेत करता है।',
        'Defines the parameters for the dashboard backend. "Limit" defines the number of entries displayed by default. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" defines the cache expiration period in minutes for the plugin.' =>
            'पटल के लिए मापदंडों के बैकेंड को परिभाषित करता है। "सीमा" तयशुदा रूप से प्रदर्शित प्रविष्टियों की संख्या को परिभाषित करता है। प्लगइन के उपयोग को सीमित करने के लिए "समूह" का प्रयोग किया जाता है(उदाहरण के लिए समूह: व्यवस्थापक, group1; समूह 2;)। "तयशुदा" इंगित करता है कि यदि प्लगइन तयशुदा रूप से सक्रिय है या उपयोगकर्ता के लिए उसे मैन्युअल रूप से सक्षम की जरूरत है। "CacheTTLocal" प्लगइन के लिए द्रुतिका समाप्ति अवधि(मिनट में) के संकेत करता है।',
        'Defines the password to access the SOAP handle (bin/cgi-bin/rpc.pl).' =>
            'SOAP हैंडल(bin/cgi-bin/rpc.pl) का उपयोग करने के लिए कूटशब्द को परिभाषित करता है।',
        'Defines the path and TTF-File to handle bold italic monospaced font in PDF documents.' =>
            'PDF दस्तावेज़ों में इटैलिक,मोटा मोनो दूरी फ़ॉन्ट को संभालने के लिए पथ और TTF-फ़ाइल को परिभाषित करता है।',
        'Defines the path and TTF-File to handle bold italic proportional font in PDF documents.' =>
            'PDF दस्तावेज़ों में इटैलिक,मोटा आनुपातिक फ़ॉन्ट को संभालने के लिए पथ और TTF-फ़ाइल को परिभाषित करता है।',
        'Defines the path and TTF-File to handle bold monospaced font in PDF documents.' =>
            'PDF दस्तावेज़ों में मोटा मोनो दूरी फ़ॉन्ट को संभालने के लिए पथ और TTF-फ़ाइल को परिभाषित करता है।',
        'Defines the path and TTF-File to handle bold proportional font in PDF documents.' =>
            'PDF दस्तावेज़ों में मोटा आनुपातिक फ़ॉन्ट को संभालने के लिए पथ और TTF-फ़ाइल को परिभाषित करता है।',
        'Defines the path and TTF-File to handle italic monospaced font in PDF documents.' =>
            'PDF दस्तावेज़ों में इटैलिक मोनो दूरी फ़ॉन्ट को संभालने के लिए पथ और TTF-फ़ाइल को परिभाषित करता है।',
        'Defines the path and TTF-File to handle italic proportional font in PDF documents.' =>
            'PDF दस्तावेज़ों में इटैलिक आनुपातिक फ़ॉन्ट को संभालने के लिए पथ और TTF-फ़ाइल को परिभाषित करता है।',
        'Defines the path and TTF-File to handle monospaced font in PDF documents.' =>
            'PDF दस्तावेज़ों में मोनो दूरी फ़ॉन्ट को संभालने के लिए पथ और TTF-फ़ाइल को परिभाषित करता है।',
        'Defines the path and TTF-File to handle proportional font in PDF documents.' =>
            'PDF दस्तावेज़ों में आनुपातिक फ़ॉन्ट को संभालने के लिए पथ और TTF-फ़ाइल को परिभाषित करता है।',
        'Defines the path for scheduler to store its console output (SchedulerOUT.log and SchedulerERR.log).' =>
            '',
        'Defines the path of the shown info file, that is located under Kernel/Output/HTML/Standard/CustomerAccept.dtl.' =>
            'Kernel/Output/HTML/Standard/CustomerAccept.dtl में स्थित जानकारी फ़ाइल के पथ को परिभाषित करता है।',
        'Defines the path to PGP binary.' => 'द्विआधारी PGP के पथ को परिभाषित करता है।',
        'Defines the path to open ssl binary. It may need a HOME env ($ENV{HOME} = \'/var/lib/wwwrun\';).' =>
            'द्विआधारी openssl के पथ को परिभाषित करता है। इसे एक घरेलू वातावरण की आवश्यकता हो सकती ($ENV{HOME} = \'/var/lib/wwwrun\';)।',
        'Defines the placement of the legend. This should be a two letter key of the form: \'B[LCR]|R[TCB]\'. The first letter indicates the placement (Bottom or Right), and the second letter the alignment (Left, Right, Center, Top, or Bottom).' =>
            'किंवदंती की नियुक्ति को परिभाषित करता है। यह दो अक्षर के रूप की कुंजी होना चाहिए:\'B[LCR]|R[TCB]\। पहला अक्षर नियुक्ति संकेत करता है कि (नीचे या दाएँ),और दूसरा अक्षर संरेखण (बाएँ,दाएँ,मध्य,ऊपर,या नीचे)।',
        'Defines the postmaster default queue.' => 'डाकपाल तयशुदा श्रेणी को परिभाषित करता है।',
        'Defines the receipent target of the phone ticket and the sender of the email ticket ("Queue" shows all queues, "SystemAddress" displays all system addresses) in the agent interface.' =>
            'प्रतिनिधि अंतरफलक के फोन टिकट के प्राप्तकर्ता लक्ष्य और ईमेल के प्रेषक टिकट को परिभाषित करता है (सभी श्रेणी को "श्रेणी"दिखाता है,"SystemAddress" सभी प्रणाली पते को प्रदर्शित करता है)।',
        'Defines the receipent target of the tickets ("Queue" shows all queues, "SystemAddress" displays all system addresses) in the customer interface.' =>
            'प्रतिनिधि अंतरफलक के फोन टिकट के प्राप्तकर्ता लक्ष्य को परिभाषित करता है (सभी श्रेणी को "श्रेणी"दिखाता है,"SystemAddress" सभी प्रणाली पते को प्रदर्शित करता है)।',
        'Defines the required permission to show a ticket in the escalation view of the agent interface.' =>
            '',
        'Defines the search limit for the stats.' => 'आँकड़े के लिए खोज सीमा को परिभाषित करता है।',
        'Defines the sender for rejected emails.' => '',
        'Defines the separator between the agents real name and the given queue email address.' =>
            'प्रतिनिधियॊ के असली नाम और कतार के दिए गए ईमेल पते के बीच विभाजक को परिभाषित करता है।',
        'Defines the spacing of the legends.' => 'किंवदंतियों के अंतरालन को परिभाषित करता है।',
        'Defines the standard permissions available for customers within the application. If more permissions are needed, you can enter them here. Permissions must be hard coded to be effective. Please ensure, when adding any of the afore mentioned permissions, that the "rw" permission remains the last entry.' =>
            'अनुप्रयोग के भीतर ग्राहकों के लिए उपलब्ध मानक अनुमतियों को परिभाषित करता है। यदि अधिक अनुमतियों की आवश्यकता हैं,तो आप उन्हें यहाँ दर्ज कर सकते हैं। अनुमतियाँ प्रभावी होने के लिए कठिन कोडित होना चाहिए। कृपया यह सुनिश्चित करें कि जब सामने दी गई वर्णित अनुमतियाँ को जोडें तो"rw" अनुमति अंतिम प्रविष्टि रहती हैं।',
        'Defines the standard size of PDF pages.' => 'PDF पृष्ठों के मानक आकार को परिभाषित करता है।',
        'Defines the state of a ticket if it gets a follow-up and the ticket was already closed.' =>
            'टिकट की स्थिति को परिभाषित करता है यदि अनुसरण हो जाता है और टिकट पहले ही बंद हो गया था।',
        'Defines the state of a ticket if it gets a follow-up.' => 'टिकट की स्थिति को परिभाषित करता है यदि अनुसरण हो जाता है।',
        'Defines the state type of the reminder for pending tickets.' => 'अनुस्मारक की टिकटों के लिए विचाराधीन स्थिति के प्रकार को परिभाषित करता है।',
        'Defines the subject for notification mails sent to agents, about new password.' =>
            'नए कूटशब्द के बारे में प्रतिनिधियॊ को भेजे जाने वाले अधिसूचना मेल के लिए विषय को परिभाषित करता है।',
        'Defines the subject for notification mails sent to agents, with token about new requested password.' =>
            'नए शब्दकूट अनुरोध के बारे में प्रतीक के साथ प्रतिनिधियॊ को भेजे जाने वाले अधिसूचना मेल के लिए विषय को परिभाषित करता है।',
        'Defines the subject for notification mails sent to customers, about new account.' =>
            'नए खाते के बारे में ग्राहकों को भेजे जाने वाले अधिसूचना मेल के लिए विषय को परिभाषित करता है।',
        'Defines the subject for notification mails sent to customers, about new password.' =>
            'नए खाते के बारे में ग्राहकों को भेजे जाने वाले अधिसूचना मेल के लिए विषय को परिभाषित करता है।',
        'Defines the subject for notification mails sent to customers, with token about new requested password.' =>
            'नए शब्दकूट अनुरोध के बारे में प्रतीक के साथ ग्राहकों को भेजे जाने वाले अधिसूचना मेल के लिए विषय को परिभाषित करता है।',
        'Defines the subject for rejected emails.' => 'खारिज कर दिए ईमेल के लिए विषय को परिभाषित करता है।',
        'Defines the system administrator\'s email address. It will be displayed in the error screens of the application.' =>
            'प्रणाली प्रशासक के ईमेल पते को परिभाषित करता है। यह अनुप्रयोग की त्रुटि स्क्रीन में प्रदर्शित किया जाएगा।',
        'Defines the system identifier. Every ticket number and http session string contain this ID. This ensures that only tickets which belong to your system will be processed as follow-ups (useful when communicating between two instances of OTRS).' =>
            'प्रणाली पहचानक को परिभाषित करता है। हर टिकट संख्या और http सत्र स्ट्रिंग के पास यह ID होते हैं। यह सुनिश्चित करता है कि केवल टिकटों है जो आपके प्रणाली से संबंधित है उनकी अनुसरण कार्रवाई की जाएगी(उपयोगी है जब OTRS की दो मामलों के बीच संवाद होते हैं)।',
        'Defines the target attribute in the link to external customer database. E.g. \'AsPopup PopupType_TicketAction\'.' =>
            '',
        'Defines the target attribute in the link to external customer database. E.g. \'target="cdb"\'.' =>
            'बाहरी ग्राहक आंकड़ाकोष की कड़ी में लक्ष्य विशेषता को परिभाषित करता है।',
        'Defines the time in days to keep log backup files.' => '',
        'Defines the time in seconds after which the Scheduler performs an automatic self-restart.' =>
            '',
        'Defines the time zone of the indicated calendar, which can be assigned later to a specific queue.' =>
            '',
        'Defines the type of protocol, used by ther web server, to serve the application. If https protocol will be used instead of plain http, it must be specified it here. Since this has no affect on the web server\'s settings or behavior, it will not change the method of access to the application and, if it is wrong, it will not prevent you from logging into the application. This setting is used as a variable, OTRS_CONFIG_HttpType which is found in all forms of messaging used by the application, to build links to the tickets within your system.' =>
            'अनुप्रयोग की सेवा के लिए,वेब सर्वर द्वारा उपयोग किया है,प्रोटोकॉल के प्रकार को परिभाषित करता है। यदि https प्रोटोकॉल सादा http के बजाय प्रयोग किया जाएगा,इसे यहाँ निर्दिष्ट किया जाना चाहिए। चूंकि इससे वेब सर्वर व्यवस्थाओ या व्यवहार पर असर नहीं पड़ता है,इसे अनुप्रयोग का उपयोग करने के लिए विधि नहीं बदल जाएगा और,यदि यह गलत है,यह आपको अनुप्रयोग में प्रवेश करने से रोकगा नहीं। यह व्यवस्था किसी परिवर्तनीय के रूप में प्रयोग की जाती है,OTRS_CONFIG_HttpType जो अनुप्रयोग                 द्वारा रूपों में पाया जाता है,आपकी प्रणाली में टिकटों के लिए लिंक बनाने के लिए।',
        'Defines the used character for email quotes in the ticket compose screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट रचना स्क्रीन में  ईमेल उद्धरण चिह्नों के लिए इस्तेमाल किया वर्ण को परिभाषित करता है।',
        'Defines the user identifier for the customer panel.' => 'ग्राहक पटल के लिए उपयोगकर्ता पहचानक को परिभाषित करता है।',
        'Defines the username to access the SOAP handle (bin/cgi-bin/rpc.pl).' =>
            'SOAP(bin/cgi-bin/rpc.pl)हैंडल का उपयोग करने के लिए उपयोगकर्ता नाम को परिभाषित करता है।',
        'Defines the valid state types for a ticket.' => 'एक टिकट के लिए वैध स्थिति प्रकार को परिभाषित करता है।',
        'Defines the valid states for unlocked tickets. To unlock tickets the script "bin/otrs.UnlockTickets.pl" can be used.' =>
            'अनलॉक टिकटों के लिए वैध स्थिति को परिभाषित करता है। टिकट अनलॉक करने के लिए लिपि "bin/otrs.UnlockTickets.pl" का उपयोग किया जा सकता है।',
        'Defines the viewable locks of a ticket. Default: unlock, tmp_lock.' =>
            'एक टिकट के देखने योग्य लॉक को परिभाषित करता है। तयशुदा: अनलॉक, tmp_lock।',
        'Defines the width for the rich text editor component for this screen. Enter number (pixels) or percent value (relative).' =>
            '',
        'Defines the width for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            'समृद्ध पाठ संपादक घटक के लिए चौड़ाई को परिभाषित करता है।(पिक्सेल) संख्या या प्रतिशत मान (सापेक्ष) को लिखें।',
        'Defines the width of the legend.' => 'किंवदंती की चौड़ाई को परिभाषित करता है।',
        'Defines which article sender types should be shown in the preview of a ticket.' =>
            '',
        'Defines which states should be set automatically (Content), after the pending time of state (Key) has been reached.' =>
            'स्थिति का विचाराधीन समय(कुंजी) पुरा हो जाने के बाद,स्थिति जो स्वचालित रूप से निर्धारित हो जानी चाहिए (सामग्री) को परिभाषित करता है।',
        'Defines wich article type should be expanded when entering the overview. If nothing defined, latest article will be expanded.' =>
            '',
        'Delay time between autocomplete queries in milliseconds.' => '',
        'Deletes a session if the session id is used with an invalid remote IP address.' =>
            'एक सत्र यदि सत्र पहचान अवैध दूरदराज के IP पते के साथ इस्तेमाल किया जाता है को नष्ट कर देता है।',
        'Deletes requested sessions if they have timed out.' => 'अनुरोध सत्र को नष्ट कर देता है यदि उनका समय समाप्त हो गया है।',
        'Determines if the list of possible queues to move to ticket into should be displayed in a dropdown list or in a new window in the agent interface. If "New Window" is set you can add a move note to the ticket.' =>
            'प्रतिनिधि अंतरफलक में संभव श्रेणीयों की सूची जिनमें टिकटों को स्थानांतरित कर सकते है उनको एक ड्रॉपडाउन सूची में या एक नई विंडो में प्रदर्शित किया जाना चाहिए। यदि "नई विंडो" निर्धारित है तो आप टिकटों के लिए एक स्थानांतरित टिप्पणी जोड़ सकते हैं।',
        'Determines if the search results container for the autocomplete feature should adjust its width dynamically.' =>
            'यदि खोज परिणामों के संग्राहक स्वत: पूर्ण सुविधा के लिए अपनी चौड़ाई गतिशील रूप से समायोजित करते है तो निर्धारित करता है।',
        'Determines if the statistics module may generate ticket lists.' =>
            '',
        'Determines the next possible ticket states, after the creation of a new email ticket in the agent interface.' =>
            'प्रतिनिधि अंतरफलक में एक नया ईमेल टिकटों के बनने के बाद,अगली संभव टिकट स्थिति निर्धारित करता है।',
        'Determines the next possible ticket states, after the creation of a new phone ticket in the agent interface.' =>
            'प्रतिनिधि अंतरफलक में एक नये फोन टिकट के बनने के बाद,अगली संभव टिकट स्थिति निर्धारित करता है।',
        'Determines the next possible ticket states, for process tickets in the agent interface.' =>
            '',
        'Determines the next screen after new customer ticket in the customer interface.' =>
            'ग्राहक अंतरफलक में नए ग्राहक टिकट के बाद अगली स्क्रीन निर्धारित करता है।',
        'Determines the next screen after the follow up screen of a zoomed ticket in the customer interface.' =>
            'ग्राहक अंतरफलक में एक जूम टिकट के अनुसरण स्क्रीन के बाद अगली स्क्रीन को निर्धारित करता है।',
        'Determines the next screen after the ticket is moved. LastScreenOverview will return to search results, queueview, dashboard or the like, LastScreenView will return to TicketZoom.' =>
            '',
        'Determines the possible states for pending tickets that changed state after reaching time limit.' =>
            'विचाराधीन टिकट जो समय सीमा तक पहुँचने के बाद स्थिति बदल लेते हैं उनकी संभावित स्थिति को निर्धारित करता है।',
        'Determines the strings that will be shown as receipent (To:) of the phone ticket and as sender (From:) of the email ticket in the agent interface. For Queue as NewQueueSelectionType "<Queue>" shows the names of the queues and for SystemAddress "<Realname> <<Email>>" shows the name and email of the receipent.' =>
            'प्रतिनिधि अंतरफलक में स्ट्रिंग जो फोन टिकट के प्राप्तकर्ता(के लिए:) के रूप में और ईमेल टिकट के प्रेषक(से:) के रूप में दिखाई जाएगी को निर्धारित करता है। श्रेणी के लिए नई पंक्ति चयन प्रकार  "< श्रेणी>" श्रेणीयों के नाम दर्शाता है और प्रणाली के पते के लिए "<Realname> <<Email>>" प्राप्तकर्ता का नाम और ईमेल दर्शाता है।',
        'Determines the strings that will be shown as receipent (To:) of the ticket in the customer interface. For Queue as CustomerPanelSelectionType, "<Queue>" shows the names of the queues, and for SystemAddress, "<Realname> <<Email>>" shows the name and email of the receipent.' =>
            'ग्राहक अंतरफलक में स्ट्रिंग जो टिकट के प्राप्तकर्ता(के लिए:) दिखाई जाएगी को निर्धारित करता है। श्रेणी के लिए ग्राहक फलक चयन प्रकार "< श्रेणी>" श्रेणीयों के नाम दर्शाता है और प्रणाली के पते के लिए "<Realname> <<Email>>" प्राप्तकर्ता का नाम और ईमेल दर्शाता है।',
        'Determines the way the linked objects are displayed in each zoom mask.' =>
            'लिंक वस्तुऐं हर ज़ूम नकाब में जिस तरह से प्रदर्शित  की जाती हैं उसे निर्धारित करता है।',
        'Determines which options will be valid of the recepient (phone ticket) and the sender (email ticket) in the agent interface.' =>
            'प्रतिनिधि अंतरफलक में प्राप्तकर्ता(फोन टिकट) और प्रेषक(ईमेल टिकट) के लिए जो विकल्प वैध होगें उनको निर्धारित करता है।',
        'Determines which queues will be valid for ticket\'s recepients in the customer interface.' =>
            'ग्राहक अंतरफलक में  टिकट प्राप्तकर्ताओं के लिए जो श्रेणी वैध होगी उनको निर्धारित करता है।',
        'Disables sending reminder notifications to the responsible agent of a ticket (Ticket::Responsible needs to be activated).' =>
            'एक टिकट के जिम्मेदार प्रतिनिधि को अनुस्मारक सूचनाएं भेजना निष्क्रिय करता है (टिकट:जिम्मेदार सक्रिय करने की जरूरत है)।',
        'Disables the web installer (http://yourhost.example.com/otrs/installer.pl), to prevent the system from being hijacked. If set to "No", the system can be reinstalled and the current basic configuration will be used to pre-populate the questions within the installer script. If not active, it also disables the GenericAgent, PackageManager and SQL Box.' =>
            '',
        'Display settings to override defaults for Process Tickets.' => '',
        'Displays the accounted time for an article in the ticket zoom view.' =>
            'टिकट ज़ूम दृश्य में एक अनुच्छेद के समय का हिसाब प्रदर्शित करता है।',
        'Dropdown' => '',
        'Dynamic Fields Checkbox Backend GUI' => '',
        'Dynamic Fields Date Time Backend GUI' => '',
        'Dynamic Fields Drop-down Backend GUI' => '',
        'Dynamic Fields GUI' => '',
        'Dynamic Fields Multiselect Backend GUI' => '',
        'Dynamic Fields Overview Limit' => '',
        'Dynamic Fields Text Backend GUI' => '',
        'Dynamic Fields used to export the search result in CSV format.' =>
            '',
        'Dynamic fields groups for process widget. The key is the name of the group, the value contains the fields to be shown. Example: \'Key => My Group\', \'Content: Name_X, NameY\'.' =>
            '',
        'Dynamic fields limit per page for Dynamic Fields Overview' => '',
        'Dynamic fields options shown in the ticket message screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required. NOTE. If you want to display these fields also in the ticket zoom of the customer interface, you have to enable them in CustomerTicketZoom###DynamicField.' =>
            '',
        'Dynamic fields options shown in the ticket reply section in the ticket zoom screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the process widget in ticket zoom screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'Dynamic fields shown in the sidebar of the ticket zoom screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'Dynamic fields shown in the ticket close screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket compose screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket email screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket forward screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket free text screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket medium format overview screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'Dynamic fields shown in the ticket move screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket note screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket overview screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket owner screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket pending screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket phone inbound screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket phone outbound screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket phone screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket preview format overview screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'Dynamic fields shown in the ticket print screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'Dynamic fields shown in the ticket print screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'Dynamic fields shown in the ticket priority screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket responsible screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket search overview results screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'Dynamic fields shown in the ticket search screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and shown by default.' =>
            '',
        'Dynamic fields shown in the ticket search screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'Dynamic fields shown in the ticket small format overview screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'Dynamic fields shown in the ticket zoom screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'DynamicField backend registration.' => '',
        'DynamicField object registration.' => '',
        'Edit customer company' => '',
        'Email Addresses' => 'ईमेल पते',
        'Enable keep-alive connection header for SOAP responses.' => '',
        'Enables PDF output. The CPAN module PDF::API2 is required, if not installed, PDF output will be disabled.' =>
            'PDF उत्पादन सक्षम बनाता है। CPAN मॉड्यूल PDF: API2 की आवश्यकता है,यदि स्थापित नहीं है,PDF उत्पादन निष्क्रिय कर दिया जाएगा।',
        'Enables PGP support. When PGP support is enabled for signing and securing mail, it is HIGHLY recommended that the web server be run as the OTRS user. Otherwise, there will be problems with the privileges when accessing .gnupg folder.' =>
            'PGP समर्थन सक्षम बनाता है। जब PGP समर्थन पंजीकरण और मेल सुरक्षित करने के लिए सक्षम है,यह अत्यधिक अनुशंसित है कि वेब सर्वर OTRS उपयोगकर्ता के रूप में चलाया जाए। अन्यथा,.gnupg फ़ोल्डर तक पहुँचने के लिए वहाँ विशेषाधिकारों के साथ समस्या हो सकती है।',
        'Enables S/MIME support.' => 'S/MIME समर्थन सक्षम बनाता है।',
        'Enables customers to create their own accounts.' => 'ग्राहकों को अपने खाते बनाने के लिए सक्षम बनाता है।',
        'Enables file upload in the package manager frontend.' => 'पैकेज प्रबंधक दृश्यपटल में फ़ाइल अपलोड सक्षम बनाता है।',
        'Enables or disable the debug mode over frontend interface.' => 'दृश्यपटल अंतरफलक पर डिबग विधा को सक्षम या अक्षम बनाता है।',
        'Enables or disables the autocomplete feature for the customer search in the agent interface.' =>
            'प्रतिनिधि अंतरफलक में ग्राहक खोज की स्वत:पूर्ण सुविधा को सक्षम या अक्षम बनाता है।',
        'Enables or disables the ticket watcher feature, to keep track of tickets without being the owner nor the responsible.' =>
            'बिना  स्वामी और न ही जिम्मेदार का ट्रैक रखने के लिए,टिकट पहरेदार सुविधा को सक्षम या अक्षम बनाता है।',
        'Enables performance log (to log the page response time). It will affect the system performance. Frontend::Module###AdminPerformanceLog must be enabled.' =>
            'अभिलेख प्रदर्शन को को सक्षम बनाता है(पृष्ठ की प्रतिक्रिया समय के लिए अभिलेख)। यह प्रणाली के प्रदर्शन को प्रभावित करेगा। दृश्यपटल::मॉड्यूल### व्यवस्थापक प्रदर्शन अभिलेख सक्षम होना चाहिए।',
        'Enables spell checker support.' => 'वर्तनी परीक्षक समर्थन को सक्षम बनाता है।',
        'Enables ticket bulk action feature for the agent frontend to work on more than one ticket at a time.' =>
            'एक समय में एक से अधिक टिकटों पर काम करने के लिए प्रतिनिधि दृश्यपटल की टिकट थोक कार्रवाई सुविधा को सक्षम बनाता है।',
        'Enables ticket bulk action feature only for the listed groups.' =>
            'केवल सूचीबद्ध समूहों के लिए टिकट थोक कार्रवाई सुविधा को सक्षम बनाता है।',
        'Enables ticket responsible feature, to keep track of a specific ticket.' =>
            'निर्दिष्ट टिकटों का ट्रैक रखने के लिए टिकट जिम्मेदार सुविधा को सक्षम बनाता है।',
        'Enables ticket watcher feature only for the listed groups.' => 'केवल सूचीबद्ध समूहों के लिए टिकट पहरेदार सुविधा को सक्षम बनाता है।',
        'Escalation view' => 'संवर्धित दृश्य',
        'Event list to be displayed on GUI to trigger generic interface invokers.' =>
            '',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate).' =>
            '',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate). This is only possible if all Ticket dynamic fields need the same event.' =>
            '',
        'Execute SQL statements.' => 'SQL बयान चलाएँ।',
        'Executes follow up checks on In-Reply-To or References headers for mails that don\'t have a ticket number in the subject.' =>
            'प्रत्युत्तर के लिए या मेल की संदर्भ शीर्षलेख कि विषय में कोई टिकट नंबर नहीं है के लिए अनुसरण जांच कार्यान्वित करता है।',
        'Executes follow up mail attachments checks in  mails that don\'t have a ticket number in the subject.' =>
            'मेल की संदर्भ शीर्षलेख कि विषय में कोई टिकट नंबर नहीं है के लिए अनुसरण मेल संलग्नक जांच कार्यान्वित करता है।',
        'Executes follow up mail body checks in mails that don\'t have a ticket number in the subject.' =>
            'मेल की संदर्भ शीर्षलेख कि विषय में कोई टिकट नंबर नहीं है के लिए अनुसरण मेल मुख्य-भाग जांच कार्यान्वित करता है।',
        'Executes follow up plain/raw mail checks in mails that don\'t have a ticket number in the subject.' =>
            'मेल की संदर्भ शीर्षलेख कि विषय में कोई टिकट नंबर नहीं है के लिए अनुसरण साधारण/अपक्व मेल जांच कार्यान्वित करता है।',
        'Exports the whole article tree in search result (it can affect the system performance).' =>
            'खोज परिणाम में पूरे अनुच्छेद वृक्ष को निर्यात करता है।',
        'Fetches packages via proxy. Overwrites "WebUserAgent::Proxy".' =>
            'प्रॉक्सी के माध्यम से संकुल को आनयन करता है। "वेब प्रयोक्ता प्रतिनिधि:प्रॉक्सी उपरिलेखन करता है।',
        'File that is displayed in the Kernel::Modules::AgentInfo module, if located under Kernel/Output/HTML/Standard/AgentInfo.dtl.' =>
            'फ़ाइल जो कर्नेल:मॉड्यूल::एजेंट जानकारी मॉड्यूल में प्रदर्शित की जाती है,यदि Kernel/Output/HTML/Standard/AgentInfo.dtl के अंतर्गत स्थित है।',
        'Filter incoming emails.' => 'आने वाले ईमेल निस्पादक।',
        'FirstLock' => '',
        'FirstResponse' => '',
        'FirstResponseDiffInMin' => '',
        'FirstResponseInMin' => '',
        'Forces encoding of outgoing emails (7bit|8bit|quoted-printable|base64).' =>
            'बाहर जाने की ईमेल के कूटबन्धन करने के लिए मजबूर करता है(7bit|8bit|quoted-printable|base64)।',
        'Forces to choose a different ticket state (from current) after lock action. Define the current state as key, and the next state after lock action as content.' =>
            'लॉक कार्रवाई के बाद एक अलग स्थिति(वर्तमान से) चुनने के लिए टिकट को मजबूर करता है। कुंजी के रूप में वर्तमान स्थिति को परिभाषित करें,और सामग्री के रूप में लॉक कार्रवाई के बाद अगली स्थिति को।',
        'Forces to unlock tickets after being moved to another queue.' =>
            'अन्य कतार में स्थानांतरित होने के बाद टिकटों को अनलॉक करने के लिए मजबूर करता है।',
        'Frontend language' => 'दृश्यपटल भाषा',
        'Frontend module registration (disable company link if no company feature is used).' =>
            'दृश्यपटल मॉड्यूल पंजीकरण(कंपनी लिंक निष्क्रिय करे यदि कंपनी सुविधा का उपयोग नहीं किया है)।',
        'Frontend module registration (disable ticket processes screen if no process available).' =>
            '',
        'Frontend module registration for the agent interface.' => 'प्रतिनिधि अंतरफलक के लिए दृश्यपटल मॉड्यूल पंजीकरण।',
        'Frontend module registration for the customer interface.' => 'ग्राहक अंतरफलक के लिए दृश्यपटल मॉड्यूल पंजीकरण।',
        'Frontend theme' => 'दृश्यपटल थीम',
        'Fulltext index regex filters to remove parts of the text.' => '',
        'GenericAgent' => 'सामान्य प्रतिनिधि',
        'GenericInterface Debugger GUI' => '',
        'GenericInterface Invoker GUI' => '',
        'GenericInterface Operation GUI' => '',
        'GenericInterface TransportHTTPSOAP GUI' => '',
        'GenericInterface Web Service GUI' => '',
        'GenericInterface Webservice History GUI' => '',
        'GenericInterface Webservice Mapping GUI' => '',
        'GenericInterface module registration for the invoker layer.' => '',
        'GenericInterface module registration for the mapping layer.' => '',
        'GenericInterface module registration for the operation layer.' =>
            '',
        'GenericInterface module registration for the transport layer.' =>
            '',
        'Gives end users the possibility to override the separator character for CSV files, defined in the translation files.' =>
            'CSV फाइल के लिए अंत उपयोगकर्ताओं को विभाजक वर्ण अध्यारोहित करने संभावना देता है,अनुवाद फ़ाइलों में परिभाषित किया गया है।',
        'Grants access, if the customer ID of the ticket matches the customer user\'s ID and the customer user has group permissions on the queue the ticket is in.' =>
            'प्रवेश अनुमति देता है,यदि टिकट का ग्राहक आईडी ग्राहक प्रयोक्ता आईडी से मेल खाता है और ग्राहक उपयोगकर्ता को टिकट की श्रेणीं की समूह अनुमति होती है।',
        'Helps to extend your articles full-text search (From, To, Cc, Subject and Body search). Runtime will do full-text searches on live data (it works fine for up to 50.000 tickets). StaticDB will strip all articles and will build an index after article creation, increasing fulltext searches about 50%. To create an initial index use "bin/otrs.RebuildFulltextIndex.pl".' =>
            'आपके अनुच्छेद पूर्ण पाठ खोज का विस्तार करने में मदद करता है(से,प्रति,प्रतिलिपि,विषय और मुख्य-भाग खोज)। कार्यसमय जीवित आंकड़ों पर पूर्ण पाठ खोज करेंगे(यह 50.000 टिकटों तक के लिए अच्छा काम करता)। स्थायी डीबी सभी अनुच्छेद पट्टी और अनुच्छेद निर्माण के बाद एक सूचकांक का निर्माण करेगा,पूर्ण पाठ खोजें लगभग 50% बढ़ती है। एक प्रारंभिक सूचकांक बनाने के लिए "bin/otrs.RebuildFulltextIndex.pl" का उपयोग करे।',
        'If "DB" was selected for Customer::AuthModule, a database driver (normally autodetection is used) can be specified.' =>
            'यदि "डीबी" ग्राहक::AuthModule के लिए चयन किया गया,तो आंकड़ाकोष संचालक(सामान्य रूप से स्वत:पहचान प्रयोग किया जाता है) निर्दिष्ट किया जा सकता है।',
        'If "DB" was selected for Customer::AuthModule, a password to connect to the customer table can be specified.' =>
            'यदि "डीबी" ग्राहक::AuthModule के लिए चयन किया गया,तो एक पासवर्ड ग्राहक तालिका से जुड़ने लिए निर्दिष्ट किया जा सकता है।',
        'If "DB" was selected for Customer::AuthModule, a username to connect to the customer table can be specified.' =>
            'यदि "डीबी" ग्राहक::AuthModule के लिए चयन किया गया,तो एक उपयोगकर्ता नाम ग्राहक तालिका से जुड़ने लिए निर्दिष्ट किया जा सकता है।',
        'If "DB" was selected for Customer::AuthModule, the DSN for the connection to the customer table must be specified.' =>
            'यदि "डीबी" ग्राहक::AuthModule के लिए चयन किया गया,तो ग्राहक तालिका में संपर्क के लिए DSN निर्दिष्ट किया जाना चाहिए।',
        'If "DB" was selected for Customer::AuthModule, the column name for the CustomerPassword in the customer table must be specified.' =>
            'यदि "डीबी" ग्राहक::AuthModule के लिए चयन किया गया,तो ग्राहक कूटशब्द के लिए ग्राहक तालिका में स्तंभ नाम निर्दिष्ट किया जाना चाहिए।',
        'If "DB" was selected for Customer::AuthModule, the crypt type of passwords must be specified.' =>
            'यदि "डीबी" ग्राहक:AuthModule के लिए चयन किया गया,तो क्रिप्ट प्रकार के कूटशब्द को निर्दिष्ट किया जाना चाहिए।',
        'If "DB" was selected for Customer::AuthModule, the name of the column for the CustomerKey in the customer table must be specified.' =>
            'यदि "डीबी" ग्राहक::AuthModule के लिए चयन किया गया,तो ग्राहक तालिका में ग्राहक कुंजी के लिए स्तंभ का नाम निर्दिष्ट किया जाना चाहिए।',
        'If "DB" was selected for Customer::AuthModule, the name of the table where your customer data should be stored must be specified.' =>
            'यदि "डीबी" ग्राहक::AuthModule के लिए चयन किया गया,तो तालिका जहाँ आपका ग्राहक आंकड़ा संग्रहीत किया जाना चाहिए का नाम निर्दिष्ट किया जाना चाहिए।',
        'If "DB" was selected for SessionModule, a table in database where session data will be stored must be specified.' =>
            'यदि "डीबी" SessionModule के लिए चयन किया गया,तो आंकड़ाकोष में एक तालिका जहां सत्र आंकड़ों को संग्रहीत किया जाएगा निर्दिष्ट किया जाना चाहिए।',
        'If "FS" was selected for SessionModule, a directory where the session data will be stored must be specified.' =>
            'यदि "एफएस" SessionModule के लिए चयन किया गया,तो एक निर्देशिका जहाँ सत्र आंकड़ों को संग्रहीत किया जाएगा निर्दिष्ट किया जाना चाहिए।',
        'If "HTTPBasicAuth" was selected for Customer::AuthModule, you can specify (by using a RegExp) to strip parts of REMOTE_USER (e. g. for to remove trailing domains). RegExp-Note, $1 will be the new Login.' =>
            'यदि "HTTPBasicAuth" ग्राहक::AuthModule के लिए चयन किया गया,तो आप(RegExp का उपयोग करके) REMOTE_USER(उदा.अनुगामी डोमेन हटाने के लिए) के पट्टी भागों को निर्दिष्ट कर सकते हैं। RegExp-नोट, $ 1 नया प्रवेश होगा।',
        'If "HTTPBasicAuth" was selected for Customer::AuthModule, you can specify to strip leading parts of user names (e. g. for domains like example_domain\user to user).' =>
            'यदि "HTTPBasicAuth" ग्राहक::AuthModule के लिए चयन किया गया,तो आप उपयोगकर्ता नाम के प्रमुख पट्टी भागों को निर्दिष्ट कर सकते हैं।',
        'If "LDAP" was selected for Customer::AuthModule and if you want to add a suffix to every customer login name, specifiy it here, e. g. you just want to write the username user but in your LDAP directory exists user@domain.' =>
            'यदि "LDAP" ग्राहक::AuthModule के लिए चयन किया गया और यदि आप हर ग्राहक के लिए एक प्रवेश नाम प्रत्यय जोड़ना चाहते हैं,यहाँ निर्दिष्ट करते हैं,उदा.आप उपयोगकर्ता नाम उपयोगकर्ता लिखना चाहते हैं लेकिन आपकी LDAP निर्देशिका में user@domain मौजूद हैं।',
        'If "LDAP" was selected for Customer::AuthModule and special paramaters are needed for the Net::LDAP perl module, you can specify them here. See "perldoc Net::LDAP" for more information about the parameters.' =>
            'यदि "LDAP" ग्राहक::AuthModule के लिए चयन किया गया और Net::LDAP perl मॉड्यूल के लिए विशेष मापदंड आवश्यक हैं,आप उन्हें यहाँ निर्दिष्ट कर सकते हैं। मापदंडों के बारे में अधिक जानकारी के लिए "perldoc Net::LDAP" देखें।',
        'If "LDAP" was selected for Customer::AuthModule and your users have only anonymous access to the LDAP tree, but you want to search through the data, you can do this with a user who has access to the LDAP directory. Specify the password for this special user here.' =>
            'यदि "LDAP" ग्राहक::AuthModule के लिए चयन किया गया और आपके उपयोगकर्ताओं को LDAP वृक्ष के लिए केवल गुमनाम उपयोग हैं,लेकिन आप आंकड़ों के माध्यम से खोज करना चाहते हैं,आप एक उपयोगकर्ता जिसको LDAP निर्देशिका का उपयोग है के साथ यह कर सकते हैं। विशेष उपयोगकर्ता के लिए कूटशब्द यहाँ निर्दिष्ट करें।',
        'If "LDAP" was selected for Customer::AuthModule and your users have only anonymous access to the LDAP tree, but you want to search through the data, you can do this with a user who has access to the LDAP directory. Specify the username for this special user here.' =>
            'यदि "LDAP" ग्राहक::AuthModule के लिए चयन किया गया और आपके उपयोगकर्ताओं को LDAP वृक्ष के लिए केवल गुमनाम उपयोग हैं,लेकिन आप आंकड़ों के माध्यम से खोज करना चाहते हैं,आप एक उपयोगकर्ता जिसको LDAP निर्देशिका का उपयोग है के साथ यह कर सकते हैं। विशेष उपयोगकर्ता के लिए उपयोगकर्ता नाम यहाँ निर्दिष्ट करें।',
        'If "LDAP" was selected for Customer::AuthModule, the BaseDN must be specified.' =>
            'यदि "LDAP" ग्राहक::AuthModule के लिए चयन किया गया, तो BaseDN निर्दिष्ट किया जाना चाहिए।',
        'If "LDAP" was selected for Customer::AuthModule, the LDAP host can be specified.' =>
            'यदि "LDAP" ग्राहक::AuthModule के लिए चयन किया गया, तो LDAP मेजबान निर्दिष्ट किया जा सकता है।',
        'If "LDAP" was selected for Customer::AuthModule, the user identifier must be specified.' =>
            'यदि "LDAP" ग्राहक::AuthModule के लिए चयन किया गया, तो उपयोगकर्ता पहचानकर्ता निर्दिष्ट किया जाना चाहिए।',
        'If "LDAP" was selected for Customer::AuthModule, user attributes can be specified. For LDAP posixGroups use UID, for non LDAP posixGroups use full user DN.' =>
            'यदि "LDAP" ग्राहक::AuthModule के लिए चयन किया गया, तो उपयोगकर्ता विशेषताएँ निर्दिष्ट की जा सकती है। LDAP posixGroups के लिए UID उपयोग करते हैं,गैर LDAP posixGroups के लिए पूर्ण उपयोगकर्ता DN का उपयोग करें।',
        'If "LDAP" was selected for Customer::AuthModule, you can specify access attributes here.' =>
            'यदि "LDAP" ग्राहक::AuthModule के लिए चयन किया गया, तो आप एक्सेस विशेषताएँ यहां निर्दिष्ट कर सकते हैं।',
        'If "LDAP" was selected for Customer::AuthModule, you can specify if the applications will stop if e. g. a connection to a server can\'t be established due to network problems.' =>
            'यदि "LDAP" ग्राहक::AuthModule के लिए चयन किया गया, तो आप निर्दिष्ट कर सकते हैं यदि अनुप्रयोग बंद हो जाएगा। उदा. यदि किसी सर्वर से कोई संबंध नेटवर्क समस्याओं के कारण स्थापित नहीं किया जा सकता है।',
        'If "LDAP" was selected for Customer::Authmodule, you can check if the user is allowed to authenticate because he is in a posixGroup, e.g. user needs to be in a group xyz to use OTRS. Specify the group, who may access the system.' =>
            'यदि "LDAP" ग्राहक::AuthModule के लिए चयन किया गया, तो आप जाँच कर सकते हैं यदि उपयोगकर्ता को प्रमाणित करने की अनुमति दी है क्योंकि वह एक posixGroup में है,उदा. उपयोगकर्ता के लिए एक समूह xyz में होना चाहिए OTRS का उपयोग करने के लिए।',
        'If "LDAP" was selected, you can add a filter to each LDAP query, e.g. (mail=*), (objectclass=user) or (!objectclass=computer).' =>
            'यदि "LDAP" चुना गया,आप एक निस्पादक हर LDAP क्वेरी के लिए जोड़ सकते हैं,उदा. (mail=*), (objectclass=user) or (!objectclass=computer)।',
        'If "Radius" was selected for Customer::AuthModule, the password to authenticate to the radius host must be specified.' =>
            'यदि ग्राहक::AuthModule के लिए "त्रिज्या" चयन किया गया,कूटशब्द त्रिज्या मेजबान प्रमाणित करने करने के लिए निर्दिष्ट किया जाना चाहिए।',
        'If "Radius" was selected for Customer::AuthModule, the radius host must be specified.' =>
            'यदि ग्राहक::AuthModule के लिए "त्रिज्या" चयन किया गया,त्रिज्या मेजबान निर्दिष्ट किया जाना चाहिए।',
        'If "Radius" was selected for Customer::AuthModule, you can specify if the applications will stop if e. g. a connection to a server can\'t be established due to network problems.' =>
            'यदि ग्राहक::AuthModule के लिए "त्रिज्या" चयन किया गया,तो आप निर्दिष्ट कर सकते हैं यदि अनुप्रयोग बंद हो जाएगा। उदा. यदि किसी सर्वर से कोई संबंध नेटवर्क समस्याओं के कारण स्थापित नहीं किया जा सकता है।',
        'If "Sendmail" was selected as SendmailModule, the location of the sendmail binary and the needed options must be specified.' =>
            'यदि SendmailModule के रूप में "Sendmail" चुना गया,sendmail द्विआधारी के स्थान और आवश्यक विकल्प निर्दिष्ट किया जाना चाहिए।',
        'If "SysLog" was selected for LogModule, a special log facility can be specified.' =>
            'यदि LogModule लिए "syslog" चुना गया,एक विशेष अभिलेख सुविधा निर्दिष्ट की जा सकती है।',
        'If "SysLog" was selected for LogModule, a special log sock can be specified (on solaris you may need to use \'stream\').' =>
            'यदि LogModule लिए "syslog" चुना गया,एक विशेष लॉग वात शंकु निर्दिष्ट की जा सकती है।(Solaris पर आप  \'stream\' उपयोग कर सकते हैं)।',
        'If "SysLog" was selected for LogModule, the charset that should be used for logging can be specified.' =>
            'यदि LogModule लिए "syslog" चुना गया,वर्णसमूह जो प्रवेश करने के लिए इस्तेमाल किया जाना चाहिए निर्दिष्ट किया जा सकता है।',
        'If "file" was selected for LogModule, a logfile must be specified. If the file doesn\'t exist, it will be created by the system.' =>
            'यदि "फाइल " LogModule के लिए चुना गया,एक अभिलेख फ़ाइल जरूर निर्दिष्ट करना चाहिए। यदि फ़ाइल मौजूद नहीं है,यह प्रणाली द्वारा बनाई जाएगी।',
        'If a note is added by an agent, sets the state of a ticket in the close ticket screen of the agent interface.' =>
            'यदि एक टिप्पणी प्रतिनिधि के द्वारा जोड़ा जाता है,प्रतिनिधि अंतरफलक के बंद टिकट स्क्रीन में एक टिकट की स्थिति निर्धारित करे।',
        'If a note is added by an agent, sets the state of a ticket in the ticket bulk screen of the agent interface.' =>
            'यदि एक टिप्पणी प्रतिनिधि के द्वारा जोड़ा जाता है,प्रतिनिधि अंतरफलक के टिकट थोक स्क्रीन में एक टिकट की स्थिति निर्धारित करे।',
        'If a note is added by an agent, sets the state of a ticket in the ticket free text screen of the agent interface.' =>
            'यदि एक टिप्पणी प्रतिनिधि के द्वारा जोड़ा जाता है,प्रतिनिधि अंतरफलक के टिकट मुक्त पाठ स्क्रीन में एक टिकट की स्थिति निर्धारित करे।',
        'If a note is added by an agent, sets the state of a ticket in the ticket note screen of the agent interface.' =>
            'यदि एक टिप्पणी प्रतिनिधि के द्वारा जोड़ा जाता है,प्रतिनिधि अंतरफलक के टिकट टिप्पणी स्क्रीन में एक टिकट की स्थिति निर्धारित करे।',
        'If a note is added by an agent, sets the state of a ticket in the ticket responsible screen of the agent interface.' =>
            'यदि एक टिप्पणी प्रतिनिधि के द्वारा जोड़ा जाता है,प्रतिनिधि अंतरफलक के टिकट उत्तरदायी स्क्रीन में एक टिकट की स्थिति निर्धारित करे।',
        'If a note is added by an agent, sets the state of the ticket in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'यदि एक टिप्पणी प्रतिनिधि के द्वारा जोड़ा जाता है,प्रतिनिधि अंतरफलक के एक जूम टिकट का टिकट स्वामी स्क्रीन में एक टिकट की स्थिति निर्धारित करे।',
        'If a note is added by an agent, sets the state of the ticket in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'यदि एक टिप्पणी प्रतिनिधि के द्वारा जोड़ा जाता है,प्रतिनिधि अंतरफलक के एक जूम टिकट का टिकट विचाराधीन स्क्रीन में एक टिकट की स्थिति निर्धारित करे।',
        'If a note is added by an agent, sets the state of the ticket in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'यदि एक टिप्पणी प्रतिनिधि के द्वारा जोड़ा जाता है,प्रतिनिधि अंतरफलक के एक जूम टिकट का टिकट प्राथमिकता स्क्रीन में एक टिकट की स्थिति निर्धारित करे।',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, and authentication to the mail server is needed, a password must be specified.' =>
            'यदि "एसएमटीपी" तंत्र को किसी भी SendmailModule के रूप में चुना गया,और मेल सर्वर के लिए प्रमाणीकरण की जरूरत है,एक कूटशब्द जरूर निर्दिष्ट करे।',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, and authentication to the mail server is needed, an username must be specified.' =>
            'यदि "एसएमटीपी" तंत्र को किसी भी SendmailModule के रूप में चुना गया,और मेल सर्वर के लिए प्रमाणीकरण की जरूरत है,एक उपयोगकर्ता नाम जरूर निर्दिष्ट करे।',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, the mailhost that sends out the mails must be specified.' =>
            'यदि "एसएमटीपी" तंत्र को किसी भी SendmailModule के रूप में चुना गया,मेल मेजबान जो बाहर मेल भेजता है निर्दिष्ट किया जाना चाहिए।',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, the port where your mailserver is listening for incoming connections must be specified.' =>
            'यदि "एसएमटीपी" तंत्र को किसी भी SendmailModule के रूप में चुना गया,पोर्ट जहाँ आपका मेल सर्वर आवक कनेक्शन के लिए सुन रहा है जरूर निर्दिष्ट करना चाहिए।',
        'If enabled, OTRS will deliver all CSS files in minified form. WARNING: If you turn this off, there will likely be problems in IE 7, because it cannot load more than 32 CSS files.' =>
            'यदि सक्रिय है,OTRS छोटे किए गए प्रपत्र में सभी CSS फ़ाइलें वितरित करेगा। चेतावनी:यदि आप इस बंद कर देते हैं,कोई संभावित IE 7 में समस्या हो जाएगी,क्योंकि यह 32 से अधिक सीएसएस फ़ाइलों को लोड नहीं कर सकते हैं।',
        'If enabled, OTRS will deliver all JavaScript files in minified form.' =>
            'यदि सक्रिय है,OTRS छोटे किए गए प्रपत्र में सभी जावास्क्रिप्ट फ़ाइलें वितरित करेगा।',
        'If enabled, TicketPhone and TicketEmail will be open in new windows.' =>
            'यदि सक्रिय है,टिकट फोन और ईमेल टिकट नये विंडो में खुल जाएगा।',
        'If enabled, the OTRS version tag will be removed from the HTTP headers.' =>
            'यदि सक्रिय है,OTRS संस्करण टैग HTTP प्रवेशिका से निकाल दिया जाएगा।',
        'If enabled, the different overviews (Dashboard, LockedView, QueueView) will automatically refresh after the specified time.' =>
            '',
        'If enabled, the first level of the main menu opens on mouse hover (instead of click only).' =>
            'यदि सक्रिय है,मुख्य मेनू के पहले के स्तर को माउस मंडराना खोलता है(के बजाय केवल क्लिक से)।',
        'If set, this address is used as envelope sender header in outgoing notifications. If no address is specified, the envelope sender header is empty.' =>
            '',
        'If this regex matches, no message will be send by the autoresponder.' =>
            'यदि यह नियमित अभिव्यक्ति से मेल खाता है,स्वतःप्रत्युत्तर से कोई संदेश नहीं भेजें।',
        'If you want to use a mirror database for agent ticket fulltext search or to generate stats, specify the DSN to this database.' =>
            'यदि आप प्रतिनिधि टिकट की प्रतिलिपि प्राप्त खोज के लिए एक दर्पण आंकड़ाकोष का उपयोग करने के लिए या आँकड़े उत्पन्न करना चाहते हैं,इस डेटाबेस के लिए DSN निर्दिष्ट करें।',
        'If you want to use a mirror database for agent ticket fulltext search or to generate stats, the password to authenticate to this database can be specified.' =>
            'यदि आप प्रतिनिधि टिकट की प्रतिलिपि प्राप्त खोज के लिए एक दर्पण आंकड़ाकोष का उपयोग करने के लिए या आँकड़े उत्पन्न करना चाहते हैं,इस आंकड़ाकोष को प्रमाणीकृत करने के लिए कूटशब्द निर्दिष्ट किया जा सकता।',
        'If you want to use a mirror database for agent ticket fulltext search or to generate stats, the user to authenticate to this database can be specified.' =>
            'यदि आप प्रतिनिधि टिकट की प्रतिलिपि प्राप्त खोज के लिए एक दर्पण आंकड़ाकोष का उपयोग करने के लिए या आँकड़े उत्पन्न करना चाहते हैं,इस आंकड़ाकोष को प्रमाणीकृत करने के लिए उपयोगकर्ता निर्दिष्ट किया जा सकता।',
        'Ignore article with system sender type for new article feature (e. g. auto responses or email notifications).' =>
            'नए अनुच्छेद सुविधा के लिए प्रणाली प्रेषक प्रकार के साथ अनुच्छेद अनदेखा करें(उदाहरण के लिए स्वत: प्रतिक्रिया या ईमेल सूचनाएं)।',
        'Includes article create times in the ticket search of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट खोज में अनुच्छेद बनाने समय शामिल हैं।',
        'IndexAccelerator: to choose your backend TicketViewAccelerator module. "RuntimeDB" generates each queue view on the fly from ticket table (no performance problems up to approx. 60.000 tickets in total and 6.000 open tickets in the system). "StaticDB" is the most powerful module, it uses an extra ticket-index table that works like a view (recommended if more than 80.000 and 6.000 open tickets are stored in the system). Use the script "bin/otrs.RebuildTicketIndex.pl" for initial index update.' =>
            'सूचकांक गतिवर्धक:आपके बैकेंड टिकट दृश्य गतिवर्धक मॉड्यूल चुनने के लिए। "RuntimeDB" टिकट तालिका से हर श्रेणीं दृश्य उत्पन्न करता है(लगभग.60.000 टिकटों तक प्रदर्शन में कोई समस्या नहीं और प्रणाली में 6.000 खुले टिकट)। "StaticDB" सबसे शक्तिशाली मॉड्यूल है,यह एक अतिरिक्त टिकट सूचकांक तालिका जो किसी दृश्य की तरह काम करता का उपयोग करता है(अनुशंसित यदि 6.000 से 80.000 अधिक और खुले टिकट प्रणाली में संग्रहीत किया जाता है)। प्रारंभिक सूचकांक अद्यतन करने के लिए स्क्रिप्ट "bin/otrs.RebuildTicketIndex.pl" का उपयोग करें।',
        'Install ispell or aspell on the system, if you want to use a spell checker. Please specify the path to the aspell or ispell binary on your operating system.' =>
            'यदि आप एक वर्तनी परीक्षक उपयोग करना चाहते हैं, Ispell या aspell सिस्टम पर स्थापित करें। aspell या ispell द्विआधारी के लिए आपकी ऑपरेटिंग सिस्टम पर पथ निर्दिष्ट करें।',
        'Interface language' => 'अंतरफलक भाषा',
        'It is possible to configure different skins, for example to distinguish between diferent agents, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            'विभिन्न सतही विन्यस्त करना संभव है,उदाहरण के लिए विभिन्न प्रतिनिधि के बीच भेद करने के लिए,अनुप्रयोग में प्रति एक डोमेन के आधार पर इस्तेमाल किया जा सकता हैं। एक नियमित अभिव्यक्ति(Regex) का उपयोग करना,आप एक कुंजी/सामग्री जोड़ी विन्यस्त करने एक डोमेन मिलान कर सकते हैं। डोमेन में "कुंजी" मान से मेल खाना चाहिए और "सामग्री" में मूल्य अपने प्रणाली पर एक वैध सतही होना चाहिए। regex के उचित रूप के लिए उदाहरण प्रविष्टियों को देखें।',
        'It is possible to configure different skins, for example to distinguish between diferent customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            'विभिन्न सतही विन्यस्त करना संभव है,उदाहरण के लिए विभिन्न ग्राहकों के बीच भेद करने के लिए,अनुप्रयोग में प्रति एक डोमेन के आधार पर इस्तेमाल किया जा सकता हैं। एक नियमित अभिव्यक्ति(Regex) का उपयोग करना,आप एक कुंजी/सामग्री जोड़ी विन्यस्त करने एक डोमेन मिलान कर सकते हैं। डोमेन में "कुंजी" मान से मेल खाना चाहिए और "सामग्री" में मूल्य अपने प्रणाली पर एक वैध सतही होना चाहिए। regex के उचित रूप के लिए उदाहरण प्रविष्टियों को देखें।',
        'It is possible to configure different themes, for example to distinguish between agents and customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid theme on your system. Please see the example entries for the proper form of the regex.' =>
            'विभिन्न थीम विन्यस्त करना संभव है,उदाहरण के लिए विभिन्न प्रतिनिधि और ग्राहकों के बीच भेद करने के लिए,अनुप्रयोग में प्रति एक डोमेन के आधार पर इस्तेमाल किया जा सकता हैं। एक नियमित अभिव्यक्ति(Regex) का उपयोग करना,आप एक कुंजी/सामग्री जोड़ी विन्यस्त करने एक डोमेन मिलान कर सकते हैं। डोमेन में "कुंजी" मान से मेल खाना चाहिए और "सामग्री" में मूल्य अपने प्रणाली पर एक वैध थीम होना चाहिए। regex के उचित रूप के लिए उदाहरण प्रविष्टियों को देखें।',
        'Link agents to groups.' => 'प्रतिनिधिओं को समूहों से जोडें।',
        'Link agents to roles.' => 'प्रतिनिधिओं को भूमिकाओं से जोडें।',
        'Link attachments to responses templates.' => 'संलग्नक को प्रतिक्रियाएं टेम्पलेट्स से जोडें।',
        'Link customers to groups.' => 'ग्राहकों को समूहों से जोडें।',
        'Link customers to services.' => 'ग्राहकों को सेवाओं से जोडें।',
        'Link queues to auto responses.' => 'श्रेणीयों को स्वत प्रतिक्रियाओं से जोडें।',
        'Link responses to queues.' => 'प्रतिक्रियाओं को श्रेणीयों से जोडें।',
        'Link roles to groups.' => 'भूमिकाओं को समूहों से जोडें।',
        'Links 2 tickets with a "Normal" type link.' => '2 टिकटों को "सामान्य"प्रकार के लिंक के साथ जोडें।',
        'Links 2 tickets with a "ParentChild" type link.' => '2 टिकटों को "ParentChild"प्रकार के लिंक के साथ जोडें।',
        'List of CSS files to always be loaded for the agent interface.' =>
            'प्रतिनिधि इंटरफ़ेस के लिए हमेशा लोड होने वाली सीएसएस फ़ाइलों के सूची।',
        'List of CSS files to always be loaded for the customer interface.' =>
            'ग्राहक इंटरफ़ेस के लिए हमेशा लोड होने वाली सीएसएस फ़ाइलों के सूची।',
        'List of IE7-specific CSS files to always be loaded for the customer interface.' =>
            'ग्राहक इंटरफ़ेस के लिए हमेशा लोड होने वाली IE7 विशिष्ट सीएसएस फ़ाइलों के सूची।',
        'List of IE8-specific CSS files to always be loaded for the agent interface.' =>
            'प्रतिनिधि इंटरफ़ेस के लिए हमेशा लोड होने वाली IE8 विशिष्ट सीएसएस फ़ाइलों के सूची।',
        'List of IE8-specific CSS files to always be loaded for the customer interface.' =>
            'ग्राहक इंटरफ़ेस के लिए हमेशा लोड होने वाली IE8 विशिष्ट सीएसएस फ़ाइलों के सूची।',
        'List of JS files to always be loaded for the agent interface.' =>
            'प्रतिनिधि इंटरफ़ेस के लिए हमेशा लोड होने वाली JS फ़ाइलों के सूची।',
        'List of JS files to always be loaded for the customer interface.' =>
            'ग्राहक इंटरफ़ेस के लिए हमेशा लोड होने वाली JS फ़ाइलों के सूची।',
        'List of default StandardResponses which are assigned automatically to new Queues upon creation.' =>
            '',
        'Log file for the ticket counter.' => 'टिकट काउंटर के लिए अभिलेख फ़ाइल।',
        'Mail Accounts' => '',
        'Main menu registration.' => '',
        'Makes the application check the MX record of email addresses before sending an email or submitting a telephone or email ticket.' =>
            'एक ईमेल भेजने या एक टेलीफोन जमा या ईमेल के टिकट से पहले अनुप्रयोग ईमेल पतों की MX रिकॉर्ड की जाँच करें।',
        'Makes the application check the syntax of email addresses.' => 'अनुप्रयोग ईमेल पतों के वाक्यविन्यास की जाँच करें।',
        'Makes the picture transparent.' => 'तस्वीर पारदर्शी बनाता है।',
        'Makes the session management use html cookies. If html cookies are disabled or if the client browser disabled html cookies, then the system will work as usual and append the session id to the links.' =>
            'सत्र प्रबंधन html कुकीज़ का उपयोग करता है। यदि html कुकीज़ अक्षम हो जाते हैं या यदि ग्राहक ब्राउज़र html कुकीज़ को अक्षम कर देता हैं,तो प्रणाली सामान्य रूप से काम करेगी और लिंक करने के लिए आईडी सत्र संलग्न करें।',
        'Manage PGP keys for email encryption.' => 'ईमेल कूटलेखन के लिए PGP कुंजी प्रबंधित का प्रबंधन करें।',
        'Manage POP3 or IMAP accounts to fetch email from.' => 'ईमेल आनयन करने के लिए POP3 या IMAP खातों का प्रबंधन करें।',
        'Manage S/MIME certificates for email encryption.' => 'ईमेल कूटलेखन के लिए S/MIME प्रमाणपत्र कुंजी प्रबंधित का प्रबंधन करें।',
        'Manage existing sessions.' => 'मौजूदा सत्र का प्रबंधन करें।',
        'Manage notifications that are sent to agents.' => '',
        'Manage periodic tasks.' => 'आवधिक कार्यों का प्रबंधन करें।',
        'Max size (in characters) of the customer information table (phone and email) in the compose screen.' =>
            'ग्राहक जानकारी तालिका(फोन और ईमेल) के स्क्रीन रचना में अधिकतम आकार(अक्षरों में)।',
        'Max size (in rows) of the informed agents box in the agent interface.' =>
            '',
        'Max size (in rows) of the involved agents box in the agent interface.' =>
            '',
        'Max size of the subjects in an email reply.' => 'ईमेल जवाब में विषय का अधिकतम आकार।',
        'Maximal auto email responses to own email-address a day (Loop-Protection).' =>
            'अधिकतम स्वत ईमेल प्रतिक्रियाओं जो ईमेल पता एक दिन स्वयं के लिए(लूप-संरक्षण)।',
        'Maximal size in KBytes for mails that can be fetched via POP3/POP3S/IMAP/IMAPS (KBytes).' =>
            'मेल जोPOP3/POP3S/IMAP/IMAPS के माध्यम से आनयन हूए के अधिकतम आकार Kbytes में।',
        'Maximum number of tickets to be displayed in the result of a search in the agent interface.' =>
            'टिकटों की अधिकतम संख्या प्रतिनिधि अंतरफलक में एक खोज के परिणाम में प्रदर्शित करने के लिए।',
        'Maximum number of tickets to be displayed in the result of a search in the customer interface.' =>
            'टिकटों की अधिकतम संख्या ग्राहक अंतरफलक में एक खोज के परिणाम में प्रदर्शित करने के लिए।',
        'Maximum size (in characters) of the customer information table in the ticket zoom view.' =>
            'टिकट ज़ूम दृश्य में ग्राहक जानकारी तालिका का अधिकतम आकार(अक्षरों में)।',
        'Module for To-selection in new ticket screen in the customer interface.' =>
            'ग्राहक अंतरफलक में नई टिकट स्क्रीन में चयन के लिए माड्यूल।',
        'Module to check customer permissions.' => 'ग्राहक अनुमतियाँ जाँच करने के लिए मॉड्यूल।',
        'Module to check if a user is in a special group. Access is granted, if the user is in the specified group and has ro and rw permissions.' =>
            'जाँच करने के लिए मॉड्यूल यदि कोई उपयोगकर्ता एक विशेष समूह में है। एक्सेस दी जाती है,यदि उपयोगकर्ता विशिष्ट समूह में है और ro और rw अनुमति है।',
        'Module to check if arrived emails should be marked as email-internal (because of original forwared internal email it college). ArticleType and SenderType define the values for the arrived email/article.' =>
            'जांच करने के लिए मॉड्यूल यदि आए ईमेल,ईमेल आंतरिक के रूप में चिह्नित किया जाना चाहिए(क्योंकि यह मौलिक अग्रेषित कॉलेज आंतरिक ईमेल में से)। ArticleType और SenderType अनुच्छेद/आए ईमेल के मूल्यों को परिभाषित करते हैं।',
        'Module to check the agent responsible of a ticket.' => 'एक टिकट के लिए जिम्मेदार प्रतिनिधि की जांच करने के लिए मॉड्यूल।',
        'Module to check the group permissions for the access to customer tickets.' =>
            'ग्राहक टिकट  उपयोग करने के लिए समूह अनुमतियाँ जाँच करने के लिए मॉड्यूल।',
        'Module to check the owner of a ticket.' => 'टिकट के स्वामी की जांच करने के लिए मॉड्यूल।',
        'Module to check the watcher agents of a ticket.' => 'टिकट के पहरेदार प्रतिनिधि की जांच करने के लिए मॉड्यूल।',
        'Module to compose signed messages (PGP or S/MIME).' => 'हस्ताक्षरित संदेश(PGP या S/MIME) लिखने के लिए मॉड्यूल।',
        'Module to crypt composed messages (PGP or S/MIME).' => 'रचित संदेशों(PGP या S/MIME) को क्रिप्ट करने के लिए मॉड्यूल। ',
        'Module to filter and manipulate incoming messages. Block/ignore all spam email with From: noreply@ address.' =>
            'आवक संदेशों में हेरफेर और निस्पादक करने के लिए मॉड्यूल। ब्लॉक/अनदेखा सभी अवांछनीय ईमेल से:noreply@ address के साथ।',
        'Module to filter and manipulate incoming messages. Get a 4 digit number to ticket free text, use regex in Match e. g. From => \'(.+?)@.+?\', and use () as [***] in Set =>.' =>
            'आवक संदेशों में हेरफेर और निस्पादक करने के लिए मॉड्यूल। टिकट मुक्त पाठ के लिए एक 4 अंकों की संख्या प्राप्त करें,मैच में regex का उपयोग करें,उदा.से :=> \'(.+?)@.+?\',और उपयोग करें () रूप में [***] में Set =>',
        'Module to generate accounted time ticket statistics.' => '',
        'Module to generate html OpenSearch profile for short ticket search in the agent interface.' =>
            'प्रतिनिधि अंतरफलक में html मुक्त खोज छोटे टिकट के लिए खोजें रूपरेखा उत्पन्न करने के लिए मॉड्यूल।',
        'Module to generate html OpenSearch profile for short ticket search in the customer interface.' =>
            'ग्राहक अंतरफलक में html मुक्त खोज छोटे टिकट के लिए खोजें रूपरेखा उत्पन्न करने के लिए मॉड्यूल।',
        'Module to generate ticket solution and response time statistics.' =>
            '',
        'Module to generate ticket statistics.' => '',
        'Module to show notifications and escalations (ShownMax: max. shown escalations, EscalationInMinutes: Show ticket which will escalation in, CacheTime: Cache of calculated escalations in seconds).' =>
            'सूचनाएँ और संवर्धित को दिखाने के लिए मॉड्यूल(ShownMax: अधिकतम संवर्धित दिखाए,EscalationInMinutes:टिकट दिखाना जो संवर्धित होगें,CacheTime: सेकंड में गणना की बढ़ोतरी के संचित)।',
        'Module to use database filter storage.' => 'आंकड़ाकोष संग्रहण निस्पादक उपयोग करने के लिए मॉड्यूल।',
        'Multiselect' => '',
        'My Tickets' => 'मेरे टिकट',
        'Name of custom queue. The custom queue is a queue selection of your preferred queues and can be selected in the preferences settings.' =>
            'अनुकूलित श्रेणी के नाम। अनुकूलित कतार एक कतार चयन है,आपकी वरीयता श्रेणीयों का और चयनित किया जा सकता है वरीयता व्यवस्थाओ में।',
        'NameX' => '',
        'New email ticket' => 'नया ईमेल टिकट',
        'New phone ticket' => 'नया फोन टिकट',
        'New process ticket' => '',
        'Next possible ticket states after adding a phone note in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Next possible ticket states after adding a phone note in the ticket phone outbound screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट फोन आउटबाउंड स्क्रीन में एक फोन टिप्पणी जोड़ने के बाद टिकट की अगली संभव स्थिति।',
        'Notifications (Event)' => 'अधिसूचनाएँ (घटना)',
        'Number of displayed tickets' => 'प्रदर्शित टिकट की संख्या',
        'Number of lines (per ticket) that are shown by the search utility in the agent interface.' =>
            'पंक्तियों(प्रति टिकट) की संख्या जो प्रतिनिधि अंतरफलक में खोज उपयोगिता द्वारा दिखाए जाते हैं।',
        'Number of tickets to be displayed in each page of a search result in the agent interface.' =>
            'प्रतिनिधि अंतरफलक में एक खोज परिणाम के प्रत्येक पृष्ठ में प्रदर्शित होने के लिए टिकटों की संख्या।',
        'Number of tickets to be displayed in each page of a search result in the customer interface.' =>
            'ग्राहक अंतरफलक में एक खोज परिणाम के प्रत्येक पृष्ठ में प्रदर्शित होने के लिए टिकटों की संख्या।',
        'Open tickets of customer' => '',
        'Overloads (redefines) existing functions in Kernel::System::Ticket. Used to easily add customizations.' =>
            'अधिभार(पुनर्व्याख्या) मौजूदा कार्य Kernel::System::Ticket में। आसानी से अनुकूलन जोड़ने के लिए। ',
        'Overview Escalated Tickets' => 'अवलोकन संवर्धित टिकट',
        'Overview Refresh Time' => '',
        'Overview of all open Tickets.' => 'सभी खुले टिकटों का ओवरव्यू',
        'PGP Key Management' => '',
        'PGP Key Upload' => 'PGP कुंजी अपलोड',
        'Parameters for the CreateNextMask object in the preference view of the agent interface.' =>
            'प्रतिनिधि अंतरफलक वरीयता दृश्य में CreateNextMask ऑब्जेक्ट के लिए मापदंड।',
        'Parameters for the CustomQueue object in the preference view of the agent interface.' =>
            'प्रतिनिधि अंतरफलक वरीयता दृश्य में CustomQueue ऑब्जेक्ट के लिए मापदंड।',
        'Parameters for the FollowUpNotify object in the preference view of the agent interface.' =>
            'प्रतिनिधि अंतरफलक वरीयता दृश्य में FollowUpNotify ऑब्जेक्ट के लिए मापदंड।',
        'Parameters for the LockTimeoutNotify object in the preference view of the agent interface.' =>
            'प्रतिनिधि अंतरफलक वरीयता दृश्य में LockTimeoutNotify ऑब्जेक्ट के लिए मापदंड।',
        'Parameters for the MoveNotify object in the preference view of the agent interface.' =>
            'प्रतिनिधि अंतरफलक वरीयता दृश्य में MoveNotify ऑब्जेक्ट के लिए मापदंड।',
        'Parameters for the NewTicketNotify object in the preferences view of the agent interface.' =>
            'प्रतिनिधि अंतरफलक वरीयता दृश्य में MoveNotify ऑब्जेक्ट के लिए मापदंड।',
        'Parameters for the RefreshTime object in the preference view of the agent interface.' =>
            'प्रतिनिधि अंतरफलक वरीयता दृश्य में RefreshTime ऑब्जेक्ट के लिए मापदंड।',
        'Parameters for the WatcherNotify object in the preference view of the agent interface.' =>
            'प्रतिनिधि अंतरफलक वरीयता दृश्य में WatcherNotify ऑब्जेक्ट के लिए मापदंड।',
        'Parameters for the dashboard backend of the customer company information of the agent interface . "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the customer id status widget of the agent interface . "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the customer user list overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the new tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'प्रतिनिधि अंतरफलक के नया टिकटों अवलोकन के बैकेंड पटल के लिए मापदंड। प्रविष्टियों की संख्या "सीमा" है जो तयशुदा रूप से दिखाई जाती हैं। "समूह" प्लगइन का उपयोग प्रतिबंधित करने के लिए प्रयोग किया जाता है(उदाहरण के लिए समूह: व्यवस्थापक, समूह 1; समूह 2;)।"तयशुदा" निर्धारित करता है, यदि प्लगइन तयशुदा रूप से सक्षम है या उपयोगकर्ता के लिए यह नियमावली रूप से सक्षम करने की जरूरत है।  "CacheTTLLocal" प्लगइन के लिए मिनटों में कैश समय है।',
        'Parameters for the dashboard backend of the ticket calendar of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'प्रतिनिधि अंतरफलक के टिकट पंचांग के बैकेंड पटल के लिए मापदंड। प्रविष्टियों की संख्या "सीमा" है जो तयशुदा रूप से दिखाई जाती हैं। "समूह" प्लगइन का उपयोग प्रतिबंधित करने के लिए प्रयोग किया जाता है(उदाहरण के लिए समूह: व्यवस्थापक, समूह 1; समूह 2;)।"तयशुदा" निर्धारित करता है, यदि प्लगइन तयशुदा रूप से सक्षम है या उपयोगकर्ता के लिए यह नियमावली रूप से सक्षम करने की जरूरत है।  "CacheTTLLocal" प्लगइन के लिए मिनटों में कैश समय है।',
        'Parameters for the dashboard backend of the ticket escalation overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'प्रतिनिधि अंतरफलक के टिकट संवर्धित अवलोकन के बैकेंड पटल के लिए मापदंड। प्रविष्टियों की संख्या "सीमा" है जो तयशुदा रूप से दिखाई जाती हैं। "समूह" प्लगइन का उपयोग प्रतिबंधित करने के लिए प्रयोग किया जाता है(उदाहरण के लिए समूह: व्यवस्थापक, समूह 1; समूह 2;)।"तयशुदा" निर्धारित करता है, यदि प्लगइन तयशुदा रूप से सक्षम है या उपयोगकर्ता के लिए यह नियमावली रूप से सक्षम करने की जरूरत है।  "CacheTTLLocal" प्लगइन के लिए मिनटों में कैश समय है।',
        'Parameters for the dashboard backend of the ticket pending reminder overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'प्रतिनिधि अंतरफलक के टिकट विचाराधीन अनुस्मारक अवलोकन के बैकेंड पटल के लिए मापदंड। प्रविष्टियों की संख्या "सीमा" है जो तयशुदा रूप से दिखाई जाती हैं। "समूह" प्लगइन का उपयोग प्रतिबंधित करने के लिए प्रयोग किया जाता है(उदाहरण के लिए समूह: व्यवस्थापक, समूह 1; समूह 2;)।"तयशुदा" निर्धारित करता है, यदि प्लगइन तयशुदा रूप से सक्षम है या उपयोगकर्ता के लिए यह नियमावली रूप से सक्षम करने की जरूरत है।  "CacheTTLLocal" प्लगइन के लिए मिनटों में कैश समय है।',
        'Parameters for the dashboard backend of the ticket pending reminder overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'प्रतिनिधि अंतरफलक के टिकट विचाराधीन अनुस्मारक अवलोकन के बैकेंड पटल के लिए मापदंड। प्रविष्टियों की संख्या "सीमा" है जो तयशुदा रूप से दिखाई जाती हैं। "समूह" प्लगइन का उपयोग प्रतिबंधित करने के लिए प्रयोग किया जाता है(उदाहरण के लिए समूह: व्यवस्थापक, समूह 1; समूह 2;)।"तयशुदा" निर्धारित करता है, यदि प्लगइन तयशुदा रूप से सक्षम है या उपयोगकर्ता के लिए यह नियमावली रूप से सक्षम करने की जरूरत है।  "CacheTTLLocal" प्लगइन के लिए मिनटों में कैश समय है।',
        'Parameters for the dashboard backend of the ticket stats of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'प्रतिनिधि अंतरफलक के टिकट आँकड़ों के बैकेंड पटल के लिए मापदंड। प्रविष्टियों की संख्या "सीमा" है जो तयशुदा रूप से दिखाई जाती हैं। "समूह" प्लगइन का उपयोग प्रतिबंधित करने के लिए प्रयोग किया जाता है(उदाहरण के लिए समूह: व्यवस्थापक, समूह 1; समूह 2;)।"तयशुदा" निर्धारित करता है, यदि प्लगइन तयशुदा रूप से सक्षम है या उपयोगकर्ता के लिए यह नियमावली रूप से सक्षम करने की जरूरत है।  "CacheTTLLocal" प्लगइन के लिए मिनटों में कैश समय है।',
        'Parameters for the pages (in which the dynamic fields are shown) of the dynamic fields overview.' =>
            '',
        'Parameters for the pages (in which the tickets are shown) of the medium ticket overview.' =>
            'पृष्ठों(जिसमें टिकट दिखाया गया है) के लिए मध्यम टिकट अवलोकन के मापदंड।',
        'Parameters for the pages (in which the tickets are shown) of the small ticket overview.' =>
            'पृष्ठों(जिसमें टिकट दिखाया गया है) के लिए लघु टिकट अवलोकन के मापदंड।',
        'Parameters for the pages (in which the tickets are shown) of the ticket preview overview.' =>
            'पृष्ठों(जिसमें टिकट दिखाया गया है) के लिए लघु टिकट पूर्वावलोकन के मापदंड।',
        'Parameters of the example SLA attribute Comment2.' => ' SLA विशेषता समीक्षा2 के उदाहरण के मापदंड।',
        'Parameters of the example queue attribute Comment2.' => 'श्रेणी विशेषता समीक्षा2 के उदाहरण के मापदंड।',
        'Parameters of the example service attribute Comment2.' => 'सेवा विशेषता समीक्षा2 के उदाहरण के मापदंड।',
        'Path for the log file (it only applies if "FS" was selected for LoopProtectionModule and it is mandatory).' =>
            'अभिलेख फ़ाइल के लिए पथ(यह तभी लागू होगा जब "FS" LoopProtectionModule के लिए चुना गया और यह अनिवार्य है)।',
        'Path of the file that stores all the settings for the QueueObject object for the agent interface.' =>
            'प्रतिनिधि अंतरफलक के लिए QueueObject वस्तु के लिए फ़ाइल के पथ जो सभी व्यवस्थाओ को संग्रहीत करता है।',
        'Path of the file that stores all the settings for the QueueObject object for the customer interface.' =>
            'ग्राहक अंतरफलक के लिए QueueObject वस्तु के लिए फ़ाइल के पथ जो सभी व्यवस्थाओ को संग्रहीत करता है।',
        'Path of the file that stores all the settings for the TicketObject for the agent interface.' =>
            'प्रतिनिधि अंतरफलक के लिए TicketObject वस्तु के लिए फ़ाइल के पथ जो सभी व्यवस्थाओ को संग्रहीत करता है।',
        'Path of the file that stores all the settings for the TicketObject for the customer interface.' =>
            'ग्राहक अंतरफलक के लिए TicketObject वस्तु के लिए फ़ाइल के पथ जो सभी व्यवस्थाओ को संग्रहीत करता है।',
        'Performs the configured action for each event (as an Invoker) for each configured Webservice.' =>
            '',
        'Permitted width for compose email windows.' => 'रचना ईमेल विंडोज़ के लिए अनुमति प्राप्त चौड़ाई।',
        'Permitted width for compose note windows.' => 'रचना टिप्पणी विंडोज़ के लिए अनुमति प्राप्त चौड़ाई।',
        'Picture-Upload' => '',
        'PostMaster Filters' => 'डाकपाल निस्पादक',
        'PostMaster Mail Accounts' => 'डाकपाल मेल खाते',
        'Process Information' => '',
        'Process Management Activity Dialog GUI' => '',
        'Process Management Activity GUI' => '',
        'Process Management Path GUI' => '',
        'Process Management Transition Action GUI' => '',
        'Process Management Transition GUI' => '',
        'Protection against CSRF (Cross Site Request Forgery) exploits (for more info see http://en.wikipedia.org/wiki/Cross-site_request_forgery).' =>
            'CSRF(क्रॉस साइट अनुरोध जालसाजी) के खिलाफ संरक्षण,कारनामे(अधिक जानकारी के लिए http://en.wikipedia.org/wiki/Cross-site_request_forgery देखें)।',
        'Queue view' => 'श्रेणी दृश्य',
        'Refresh Overviews after' => '',
        'Refresh interval' => 'ताज़ाकरण अंतराल',
        'Removes the ticket watcher information when a ticket is archived.' =>
            '',
        'Replaces the original sender with current customer\'s email address on compose answer in the ticket compose screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक रचना स्क्रीन में जवाब रचना पर मौलिक प्रेषक को वर्तमान ग्राहक के ईमेल पते के साथ बदलता है।',
        'Required permissions to change the customer of a ticket in the agent interface.' =>
            'प्रतिनिधि अंतरफलक में एक टिकट के ग्राहकों को बदलने के लिए आवश्यक अनुमतियां।',
        'Required permissions to use the close ticket screen in the agent interface.' =>
            'प्रतिनिधि अंतरफलक में बंद टिकट स्क्रीन का उपयोग करने के लिए आवश्यक अनुमतियां।',
        'Required permissions to use the ticket bounce screen in the agent interface.' =>
            'प्रतिनिधि अंतरफलक में टिकट फलांग स्क्रीन का उपयोग करने के लिए आवश्यक अनुमतियां।',
        'Required permissions to use the ticket compose screen in the agent interface.' =>
            'प्रतिनिधि अंतरफलक में टिकट रचना स्क्रीन का उपयोग करने के लिए आवश्यक अनुमतियां।',
        'Required permissions to use the ticket forward screen in the agent interface.' =>
            'प्रतिनिधि अंतरफलक में टिकट अग्रिम स्क्रीन का उपयोग करने के लिए आवश्यक अनुमतियां।',
        'Required permissions to use the ticket free text screen in the agent interface.' =>
            'प्रतिनिधि अंतरफलक में टिकट मुक्त पाठ स्क्रीन का उपयोग करने के लिए आवश्यक अनुमतियां।',
        'Required permissions to use the ticket merge screen of a zoomed ticket in the agent interface.' =>
            'प्रतिनिधि अंतरफलक में जूम टिकट के टिकट विलय स्क्रीन का उपयोग करने के लिए आवश्यक अनुमतियां।',
        'Required permissions to use the ticket note screen in the agent interface.' =>
            'प्रतिनिधि अंतरफलक में जूम टिकट के टिकट टिप्पणी स्क्रीन का उपयोग करने के लिए आवश्यक अनुमतियां।',
        'Required permissions to use the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'प्रतिनिधि अंतरफलक में जूम टिकट के टिकट स्वामी स्क्रीन का उपयोग करने के लिए आवश्यक अनुमतियां।',
        'Required permissions to use the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'प्रतिनिधि अंतरफलक में जूम टिकट के टिकट स्वामी स्क्रीन का उपयोग करने के लिए आवश्यक अनुमतियां।',
        'Required permissions to use the ticket phone inbound screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket phone outbound screen in the agent interface.' =>
            'प्रतिनिधि अंतरफलक में टिकट फोन आउटबाउंड स्क्रीन का उपयोग करने के लिए आवश्यक अनुमतियां।',
        'Required permissions to use the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'प्रतिनिधि अंतरफलक में जूम टिकट के टिकट प्राथमिकता स्क्रीन का उपयोग करने के लिए आवश्यक अनुमतियां।',
        'Required permissions to use the ticket responsible screen in the agent interface.' =>
            'प्रतिनिधि अंतरफलक में टिकट उत्तरदायी स्क्रीन का उपयोग करने के लिए आवश्यक अनुमतियां।',
        'Resets and unlocks the owner of a ticket if it was moved to another queue.' =>
            'यदि अन्य कतार में स्थानांतरित होने के बाद टिकट के स्वामी को फिर से निर्धारित करता है और अनलॉक करता है।',
        'Responses <-> Queues' => 'प्रतिक्रियाएँ <-> श्रेणीयां',
        'Restores a ticket from the archive (only if the event is a state change, from closed to any open available state).' =>
            'संग्रह से टिकट पुनर्स्थापित करता है(केवल यदि घटना एक स्थिति परिवर्तन है,किसी भी खुले उपलब्ध स्थिति से बंद के लिए)।',
        'Roles <-> Groups' => 'भूमिकाएं <-> समूहों',
        'Runs an initial wildcard search of the existing customer users when accessing the AdminCustomerUser module.' =>
            '',
        'Runs the system in "Demo" mode. If set to "Yes", agents can change preferences, such as selection of language and theme via the agent web interface. These changes are only valid for the current session. It will not be possible for agents to change their passwords.' =>
            '"प्रदर्शन" मोड में प्रणाली चलाता है। यदि "हाँ" पर निर्धारित है,प्रतिनिधि वरीयताओं को बदल सकते हैं,इस तरह की भाषा के चयन के रूप में और थीम प्रतिनिधि वेब अंतरफलक के द्वारा। ये परिवर्तन केवल वर्तमान सत्र के लिए मान्य हैं। प्रतिनिधियो को अपना कूटशब्द बदलना संभव नहीं होगा।',
        'S/MIME Certificate Upload' => 'S/MIME प्रमाण पत्र अपलोड करें।',
        'Saves the attachments of articles. "DB" stores all data in the database (not recommended for storing big attachments). "FS" stores the data on the filesystem; this is faster but the webserver should run under the OTRS user. You can switch between the modules even on a system that is already in production without any loss of data.' =>
            'अनुच्छेदो के संलग्नक सुरक्षित करता है। "DB" आंकड़ाकोष में सभी आंकड़ों को संग्रहीत करता है(बड़े संलग्नक संग्रहीत करने के लिए अनुशंसित नहीं)। "FS" फाइल प्रणाली पर संग्रहीत करता है;यह तेज है, लेकिन वेबसर्वर OTRS उपयोगकर्ता के अधीन चलाना चाहिए। आप मॉड्यूल बदल सकते यहां तक कि कोई प्रणाली पहले से ही उत्पादन में है बिना आंकड़ो को हानि पहुँचायें।',
        'Search backend default router.' => 'बैकेंड तयशुदा अनुर्मागक खोजें।',
        'Search backend router.' => 'बैकेंड अनुर्मागक खोजें।',
        'Select your frontend Theme.' => 'आपकी दृश्यपटल थीम चुनें।',
        'Selects the cache backend to use.' => '',
        'Selects the module to handle uploads via the web interface. "DB" stores all uploads in the database, "FS" uses the file system.' =>
            'वेब अंतरफलक के द्वारा अपलोड संभालने के लिए मॉड्यूल चुनता है। "DB" आंकड़ाकोष में सभी अपलोड को संग्रहीत करता है,"FS" फ़ाइल प्रणाली का उपयोग करता है।',
        'Selects the ticket number generator module. "AutoIncrement" increments the ticket number, the SystemID and the counter are used with SystemID.counter format (e.g. 1010138, 1010139). With "Date" the ticket numbers will be generated by the current date, the SystemID and the counter. The format looks like Year.Month.Day.SystemID.counter (e.g. 200206231010138, 200206231010139). With "DateChecksum"  the counter will be appended as checksum to the string of date and SystemID. The checksum will be rotated on a daily basis. The format looks like Year.Month.Day.SystemID.Counter.CheckSum (e.g. 2002070110101520, 2002070110101535). "Random" generates randomized ticket numbers in the format "SystemID.Random" (e.g. 100057866352, 103745394596).' =>
            'टिकट संख्या उत्पादक मॉड्यूल चुनता है। "AutoIncrement" टिकट संख्या बढ़ता है,प्रणाली ID और काउंटर SystemID.काउंटर प्रारूप (जैसे. 1010138,1010139) के साथ उपयोग किया जाता है।"दिनांक " के साथ टिकट संख्या वर्तमान दिनांक के आधार पर उत्पन्न किया जाएगा,SystemID और काउंटर।प्रारूप        Year.Month.Day.SystemID.counter की तरह दिखता है(जैसे. 200206231010138, 200206231010139)।"DateChecksum" के साथ काउंटर तारीख और systemid के जाँचयोग स्ट्रिंग के रूप में जुड़ जाएगा।जाँचयोग एक दैनिक आधार पर चलाया जाएगा।प्रारूप Year.Month.Day.SystemID.Counter.CheckSum की तरह दिखता है (जैसे. 2002070110101520,2002070110101535)।"Random" यादृच्छिक टिकट संख्या उत्पन्न करता है "SystemID.Random" प्रारूप में(जैसे. 100057866352, 103745394596)।',
        'Send me a notification if a customer sends a follow up and I\'m the owner of the ticket or the ticket is unlocked and is in one of my subscribed queues.' =>
            'मुझे एक अधिसूचना भेजें यदि एक ग्राहक एक अनुवर्ती भेजता है और मैं टिकट का स्वामी हूँ या टिकट अनलॉक है और मेरी एक सदस्यता श्रेंणीयों में है।',
        'Send notifications to users.' => 'उपयोगकर्ताओं को अधिसूचनाएँ भेजें।',
        'Send ticket follow up notifications' => 'टिकट के लिए अधिसूचना अनुसरण भेजें।',
        'Sender type for new tickets from the customer inteface.' => 'ग्राहक अंतरफलक से नये टिकटों के लिए प्रेषक प्रकार।',
        'Sends agent follow-up notification only to the owner, if a ticket is unlocked (the default is to send the notification to all agents).' =>
            'प्रतिनिधि अनुवर्ती अधिसूचना स्वामी को ही भेजता है,यदि एक टिकट अनलॉक है(सभी एजेंटों को अधिसूचना भेजना तयशुदा है)',
        'Sends all outgoing email via bcc to the specified address. Please use this only for backup reasons.' =>
            'गुप्त प्रतिलिपि के माध्यम से सभी बाहर जाने वाले ईमेल निर्दिष्ट पते पर भेजता है। यह बैकअप कारणों के लिए ही प्रयोग करें।',
        'Sends customer notifications just to the mapped customer. Normally, if no customer is mapped, the latest customer sender gets the notification.' =>
            'ग्राहक अधिसूचना  केवल प्रतिचित्रित ग्राहक के लिए भेजता है। सामान्य तौर पर,यदि कोई ग्राहक प्रतिचित्रित नहीं है,अधिसूचना नवीनतम ग्राहक प्रेषक को जाती है।',
        'Sends reminder notifications of unlocked ticket after reaching the reminder date (only sent to ticket owner).' =>
            'अनलॉक टिकट के लिए अनुस्मारक अधिसूचना भेजता है,अनुस्मारक दिनांक पहुँचने के बाद(केवल टिकट स्वामी को भेजा जाता है)।',
        'Sends the notifications which are configured in the admin interface under "Notfication (Event)".' =>
            'व्यवस्थापक अंतरफलक में "Notfication (घटना)" के तहत जो विन्यस्त किया गया है को अधिसूचना भेजता है।',
        'Set sender email addresses for this system.' => 'इस प्रणाली के लिए प्रेषक ईमेल पते निर्धारित करें।',
        'Set the default height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            'AgentTicketZoom में इनलाइन HTML अनुच्छेद की तयशुदा ऊंचाई(पिक्सेल में) निर्धारित करें।',
        'Set the maximum height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            'AgentTicketZoom में इनलाइन HTML अनुच्छेद की अधिकतम ऊंचाई(पिक्सेल में) निर्धारित करें।',
        'Set this to yes if you trust in all your public and private pgp keys, even if they are not certified with a trusted signature.' =>
            'यदि आपको आपकी सभी सार्वजनिक और निजी PGP कुंजी में विश्वास है तो हाँ स्थापित करें,भले ही वे एक विश्वसनीय हस्ताक्षर के साथ प्रमाणित नहीं किया हैं।',
        'Sets if ticket owner must be selected by the agent.' => 'स्थापित करता है,यदि टिकट स्वामी प्रतिनिधि के द्वारा चुना जाना चाहिए।',
        'Sets the PendingTime of a ticket to 0 if the state is changed to a non-pending state.' =>
            'एक टिकट का विचाराधीन समय 0 स्थापित करता है,यदि स्थिति एक गैर-विचाराधीन स्थिति में बदल जाए।',
        'Sets the age in minutes (first level) for highlighting queues that contain untouched tickets.' =>
            'श्रेणीयो में शामिल अछूते टिकटों पर प्रकाश डालाने के लिए मिनटों(प्रथम स्तर) में आयु स्थापित करता है।',
        'Sets the age in minutes (second level) for highlighting queues that contain untouched tickets.' =>
            'श्रेणीयो में शामिल अछूते टिकटों पर प्रकाश डालाने के लिए मिनटों(द्वितीय स्तर) में आयु स्थापित करता है।',
        'Sets the configuration level of the administrator. Depending on the config level, some sysconfig options will be not shown. The config levels are in in ascending order: Expert, Advanced, Beginner. The higher the config level is (e.g. Beginner is the highest), the less likely is it that the user can accidentally configure the system in a way that it is not usable any more.' =>
            'प्रशासक के विन्यास स्तर को स्थापित करता है। विन्यास स्तर के आधार पर,कुछ sysconfig विकल्प नहीं दिखाए जाएंगे। विन्यास स्तर बढ़ते क्रम में हैं:विशेषज्ञ,विकसित,शुरुआत। अधिक विन्यास स्तर पर(उदाहरण के लिए शुरुआत सर्वाधिक है),यह संभावना कम है कि उपयोगकर्ता गलती से प्रणाली को इस तरह विन्यस्त कर सकते हैं कि प्रणाली उपयोग करने योग्य नहीं रहें।',
        'Sets the default article type for new email tickets in the agent interface.' =>
            'प्रतिनिधि अंतरफलक में तयशुदा नये ईमेल टिकटों के लिए अनुच्छेद प्रकार स्थापित करता है।',
        'Sets the default article type for new phone tickets in the agent interface.' =>
            'प्रतिनिधि अंतरफलक में तयशुदा नये फोन टिकटों के लिए अनुच्छेद प्रकार स्थापित करता है।',
        'Sets the default body text for notes added in the close ticket screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के बंद टिकट स्क्रीन में जोडी गयी टिप्पणी के लिए तयशुदा मुख्य-भाग पाठ स्थापित करता है।',
        'Sets the default body text for notes added in the ticket move screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट स्थानांतरित स्क्रीन में जोडी गयी टिप्पणी के लिए तयशुदा मुख्य-भाग पाठ स्थापित करता है।',
        'Sets the default body text for notes added in the ticket note screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट टिप्पणी स्क्रीन में जोडी गयी टिप्पणी के लिए तयशुदा मुख्य-भाग पाठ स्थापित करता है।',
        'Sets the default body text for notes added in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'प्रतिनिधि अंतरफलक के जूम टिकट के स्वामी स्क्रीन में जोडी गयी टिप्पणी के लिए तयशुदा मुख्य-भाग पाठ स्थापित करता है।',
        'Sets the default body text for notes added in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'प्रतिनिधि अंतरफलक के जूम टिकट के विचाराधीन स्क्रीन में जोडी गयी टिप्पणी के लिए तयशुदा मुख्य-भाग पाठ स्थापित करता है।',
        'Sets the default body text for notes added in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'प्रतिनिधि अंतरफलक के जूम टिकट के प्राथमिकता स्क्रीन में जोडी गयी टिप्पणी के लिए तयशुदा मुख्य-भाग पाठ स्थापित करता है।',
        'Sets the default body text for notes added in the ticket responsible screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट उत्तरदायी स्क्रीन में जोडी गयी टिप्पणी के लिए तयशुदा मुख्य-भाग पाठ स्थापित करता है।',
        'Sets the default link type of splitted tickets in the agent interface.' =>
            'प्रतिनिधि अंतरफलक में विभाजित टिकटों की तयशुदा लिंक प्रकार स्थापित करता है।',
        'Sets the default next state for new phone tickets in the agent interface.' =>
            'प्रतिनिधि अंतरफलक में नये फोन टिकटों के लिए तयशुदा अगली स्थिति स्थापित करता है।',
        'Sets the default next ticket state, after the creation of an email ticket in the agent interface.' =>
            'प्रतिनिधि अंतरफलक में एक ईमेल टिकट के बनने के बाद तयशुदा अगली टिकट स्थिति स्थापित करता है।',
        'Sets the default note text for new telephone tickets. E.g \'New ticket via call\' in the agent interface.' =>
            'नए टेलीफोन टिकटों के लिए तयशुदा टिप्पणी पाठ स्थापित करता है। प्रतिनिधि अंतरफलक में  उदा.\'कॉल के माध्यम से न्यू टिकट \'',
        'Sets the default priority for new email tickets in the agent interface.' =>
            'प्रतिनिधि अंतरफलक में नये ईमेल टिकटों के लिए तयशुदा प्राथमिकता स्थापित करता है।',
        'Sets the default priority for new phone tickets in the agent interface.' =>
            'प्रतिनिधि अंतरफलक में नये फोन टिकटों के लिए तयशुदा प्राथमिकता स्थापित करता है।',
        'Sets the default sender type for new email tickets in the agent interface.' =>
            'प्रतिनिधि अंतरफलक में नये ईमेल टिकटों के लिए तयशुदा प्रेषक प्रकार स्थापित करता है।',
        'Sets the default sender type for new phone ticket in the agent interface.' =>
            'प्रतिनिधि अंतरफलक में नये फोन टिकटों के लिए तयशुदा प्रेषक प्रकार स्थापित करता है।',
        'Sets the default subject for new email tickets (e.g. \'email Outbound\') in the agent interface.' =>
            'प्रतिनिधि अंतरफलक में नये ईमेल टिकटों(उदा \'ईमेल आउटबाउंड\') के लिए तयशुदा विषय स्थापित करता है।',
        'Sets the default subject for new phone tickets (e.g. \'Phone call\') in the agent interface.' =>
            'प्रतिनिधि अंतरफलक में नये फोन टिकटों(उदा \'फोन कॉल\') के लिए तयशुदा विषय स्थापित करता है।',
        'Sets the default subject for notes added in the close ticket screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के बंद टिकट स्क्रीन में जोडी गयी टिप्पणी के लिए तयशुदा विषय स्थापित करता है।',
        'Sets the default subject for notes added in the ticket move screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट स्थानांतरित स्क्रीन में जोडी गयी टिप्पणी के लिए तयशुदा विषय स्थापित करता है।',
        'Sets the default subject for notes added in the ticket note screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट टिप्पणी स्क्रीन में जोडी गयी टिप्पणी के लिए तयशुदा विषय स्थापित करता है।',
        'Sets the default subject for notes added in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'प्रतिनिधि अंतरफलक के जूम टिकट के स्वामी स्क्रीन में जोडी गयी टिप्पणी के लिए तयशुदा विषय स्थापित करता है।',
        'Sets the default subject for notes added in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'प्रतिनिधि अंतरफलक के जूम टिकट के विचाराधीन स्क्रीन में जोडी गयी टिप्पणी के लिए तयशुदा विषय स्थापित करता है।',
        'Sets the default subject for notes added in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'प्रतिनिधि अंतरफलक के जूम टिकट के प्राथमिकता स्क्रीन में जोडी गयी टिप्पणी के लिए तयशुदा विषय स्थापित करता है।',
        'Sets the default subject for notes added in the ticket responsible screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट उत्तरदायी स्क्रीन में जोडी गयी टिप्पणी के लिए तयशुदा विषय स्थापित करता है।',
        'Sets the default text for new email tickets in the agent interface.' =>
            'एजेंट अंतरफलक में नये ईमेल टिकटों के लिए तयशुदा पाठ स्थापित करता है।',
        'Sets the display order of the different items in the preferences view.' =>
            'विभिन्न वस्तुओं के प्रदर्शन क्रम में प्राथमिकता दृश्य स्थापित करता है।',
        'Sets the inactivity time (in seconds) to pass before a session is killed and a user is loged out.' =>
            'निष्क्रियता समय(सेकंड में)उपयोगकर्ता के लॉग होने और सत्र के खतम होने से पहले पारित करने के लिए स्थापित करता है।',
        'Sets the maximum number of active agents within the timespan defined in SessionActiveTime.' =>
            '',
        'Sets the maximum number of active customers within the timespan defined in SessionActiveTime.' =>
            '',
        'Sets the minimal ticket counter size (if "AutoIncrement" was selected as TicketNumberGenerator). Default is 5, this means the counter starts from 10000.' =>
            'न्यूनतम टिकट काउंटर आकार स्थापित करता है(यदि "AutoIncrement" टिकट संख्या उत्पन्नकर्ता के रूप में चुना गया)। तयशुदा 5 है,इसका मतलब काउंटर 10000 से शुरू होता है।',
        'Sets the minimum number of characters before autocomplete query is sent.' =>
            'स्वत:पूर्ण क्वेरी से पहले वर्णों की न्यूनतम संख्या भेजी है यह स्थापित करता है।',
        'Sets the number of lines that are displayed in text messages (e.g. ticket lines in the QueueZoom).' =>
            'पंक्तियों की संख्या जो पाठ संदेश में प्रदर्शित किए जाते हैं को स्थापित करता है(उदा. QueueZoom में टिकट लाइनें)।',
        'Sets the number of search results to be displayed for the autocomplete feature.' =>
            'खोज परिणामों की संख्या स्वत: पूर्ण सुविधा के लिए प्रदर्शित करने के लिए स्थापित करता है।',
        'Sets the options for PGP binary.' => 'PGP द्विआधारी के लिए विकल्प स्थापित करता है।',
        'Sets the order of the different items in the customer preferences view.' =>
            'ग्राहक प्राथमिकता दृश्य में विभिन्न वस्तुओं के क्रम स्थापित करता है।',
        'Sets the password for private PGP key.' => 'निजी PGP कुंजी के लिए कूटशब्द स्थापित करता है।',
        'Sets the prefered time units (e.g. work units, hours, minutes).' =>
            'अनुशंसित समय इकाइयों को स्थापित करता है(उदा. कार्य,इकाइयों,घंटे,मिनट)।',
        'Sets the prefix to the scripts folder on the server, as configured on the web server. This setting is used as a variable, OTRS_CONFIG_ScriptAlias which is found in all forms of messaging used by the application, to build links to the tickets within the system.' =>
            'सर्वर पर लिपि फ़ोल्डर में उपसर्ग स्थापित करता है,जिस रूप में वेब सर्वर पर विन्यस्त है। यह व्यवस्था किसी परिवर्तनीय के रूप में प्रयोग कि जाती है,OTRS_CONFIG_ScriptAlias जो के सभी रूपों में पाया जाता है अनुप्रयोग द्वारा उपयोग संदेश प्रेषण में,इस प्रणाली के भीतर टिकटों के लिए लिंक बनाने के लिए।',
        'Sets the queue in the ticket close screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the queue in the ticket free text screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the queue in the ticket note screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the queue in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the queue in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the queue in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the queue in the ticket responsible screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the responsible agent of the ticket in the close ticket screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के बंद टिकट स्क्रीन में टिकट के उत्तरदायी प्रतिनिधि को स्थापित करता है।',
        'Sets the responsible agent of the ticket in the ticket bulk screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट थोक स्क्रीन में टिकट के उत्तरदायी प्रतिनिधि को स्थापित करता है।',
        'Sets the responsible agent of the ticket in the ticket free text screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट मुक्त पाठ स्क्रीन में टिकट के उत्तरदायी प्रतिनिधि को स्थापित करता है।',
        'Sets the responsible agent of the ticket in the ticket note screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट टिप्पणी स्क्रीन में टिकट के उत्तरदायी प्रतिनिधि को स्थापित करता है।',
        'Sets the responsible agent of the ticket in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'प्रतिनिधि अंतरफलक के जूम टिकट के स्वामी स्क्रीन में टिकट के उत्तरदायी प्रतिनिधि को स्थापित करता है।',
        'Sets the responsible agent of the ticket in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'प्रतिनिधि अंतरफलक के जूम टिकट के विचाराधीन स्क्रीन में टिकट के उत्तरदायी प्रतिनिधि को स्थापित करता है।',
        'Sets the responsible agent of the ticket in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'प्रतिनिधि अंतरफलक के जूम टिकट के प्राथमिकता स्क्रीन में टिकट के उत्तरदायी प्रतिनिधि को स्थापित करता है।',
        'Sets the responsible agent of the ticket in the ticket responsible screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट उत्तरदायी स्क्रीन में टिकट के उत्तरदायी प्रतिनिधि को स्थापित करता है।',
        'Sets the service in the close ticket screen of the agent interface (Ticket::Service needs to be activated).' =>
            'प्रतिनिधि अंतरफलक के बंद टिकट स्क्रीन में सेवा को स्थापित करता है(टिकट::सेवा को सक्रिय करने की आवश्यकता है)।',
        'Sets the service in the ticket free text screen of the agent interface (Ticket::Service needs to be activated).' =>
            'प्रतिनिधि अंतरफलक के टिकट मुक्त पाठ स्क्रीन में सेवा को स्थापित करता है(टिकट::सेवा को सक्रिय करने की आवश्यकता है)।',
        'Sets the service in the ticket note screen of the agent interface (Ticket::Service needs to be activated).' =>
            'प्रतिनिधि अंतरफलक के टिकट टिप्पणी स्क्रीन में सेवा को स्थापित करता है(टिकट::सेवा को सक्रिय करने की आवश्यकता है)।',
        'Sets the service in the ticket owner screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).' =>
            'प्रतिनिधि अंतरफलक के जूम टिकट के स्वामी स्क्रीन में सेवा को स्थापित करता है(टिकट::सेवा को सक्रिय करने की आवश्यकता है)।',
        'Sets the service in the ticket pending screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).' =>
            'प्रतिनिधि अंतरफलक के जूम टिकट के विचाराधीन स्क्रीन में सेवा को स्थापित करता है(टिकट::सेवा को सक्रिय करने की आवश्यकता है)।',
        'Sets the service in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).' =>
            'प्रतिनिधि अंतरफलक के जूम टिकट के प्राथमिकता स्क्रीन में सेवा को स्थापित करता है(टिकट::सेवा को सक्रिय करने की आवश्यकता है)।',
        'Sets the service in the ticket responsible screen of the agent interface (Ticket::Service needs to be activated).' =>
            'प्रतिनिधि अंतरफलक के टिकट उत्तरदायी स्क्रीन में सेवा को स्थापित करता है(टिकट::सेवा को सक्रिय करने की आवश्यकता है)।',
        'Sets the size of the statistic graph.' => 'सांख्यिकीय रेखा-चित्र के आकार को स्थापित करता है।',
        'Sets the stats hook.' => 'आँकड़ों के हुक को स्थापित करता है।',
        'Sets the system time zone (required a system with UTC as system time). Otherwise this is a diff time to the local time.' =>
            'प्रणाली समय जोन को स्थापित करता है(प्रणाली समय के रूप में UTC के साथ एक प्रणाली की आवश्यकता)। अन्यथा यह स्थानीय समय के लिए एक अलग समय है।',
        'Sets the ticket owner in the close ticket screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के बंद टिकट स्क्रीन में टिकट के स्वामी को स्थापित करता है।',
        'Sets the ticket owner in the ticket bulk screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट थोक स्क्रीन में टिकट के स्वामी को स्थापित करता है।',
        'Sets the ticket owner in the ticket free text screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट मुक्त पाठ स्क्रीन में टिकट के स्वामी को स्थापित करता है।',
        'Sets the ticket owner in the ticket note screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट टिप्पणी स्क्रीन में टिकट के स्वामी को स्थापित करता है।',
        'Sets the ticket owner in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'प्रतिनिधि अंतरफलक के जूम टिकट के स्वामी स्क्रीन में स्वामी को स्थापित करता है।',
        'Sets the ticket owner in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'प्रतिनिधि अंतरफलक के जूम टिकट के विचाराधीन स्क्रीन में स्वामी को स्थापित करता है।',
        'Sets the ticket owner in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'प्रतिनिधि अंतरफलक के जूम टिकट के प्राथमिकता स्क्रीन में स्वामी को स्थापित करता है।',
        'Sets the ticket owner in the ticket responsible screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट उत्तरदायी स्क्रीन में टिकट के स्वामी को स्थापित करता है।',
        'Sets the ticket type in the close ticket screen of the agent interface (Ticket::Type needs to be activated).' =>
            'प्रतिनिधि अंतरफलक के बंद टिकट स्क्रीन में टिकट प्रकार को स्थापित करता है(टिकट::प्रकार को सक्रिय करने की आवश्यकता है)।',
        'Sets the ticket type in the ticket bulk screen of the agent interface.' =>
            '',
        'Sets the ticket type in the ticket free text screen of the agent interface (Ticket::Type needs to be activated).' =>
            'प्रतिनिधि अंतरफलक के टिकट मुक्त पाठ स्क्रीन में टिकट प्रकार को स्थापित करता है(टिकट::प्रकार को सक्रिय करने की आवश्यकता है)।',
        'Sets the ticket type in the ticket note screen of the agent interface (Ticket::Type needs to be activated).' =>
            'प्रतिनिधि अंतरफलक के टिकट टिप्पणी स्क्रीन में टिकट प्रकार को स्थापित करता है(टिकट::प्रकार को सक्रिय करने की आवश्यकता है)।',
        'Sets the ticket type in the ticket owner screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).' =>
            'प्रतिनिधि अंतरफलक के जूम टिकट के स्वामी स्क्रीन में टिकट प्रकार को स्थापित करता है(टिकट::प्रकार को सक्रिय करने की आवश्यकता है)।',
        'Sets the ticket type in the ticket pending screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).' =>
            'प्रतिनिधि अंतरफलक के जूम टिकट के विचाराधीन स्क्रीन में टिकट प्रकार को स्थापित करता है(टिकट::प्रकार को सक्रिय करने की आवश्यकता है)।',
        'Sets the ticket type in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).' =>
            'प्रतिनिधि अंतरफलक के जूम टिकट के प्राथमिकता स्क्रीन में टिकट प्रकार को स्थापित करता है(टिकट::प्रकार को सक्रिय करने की आवश्यकता है)।',
        'Sets the ticket type in the ticket responsible screen of the agent interface (Ticket::Type needs to be activated).' =>
            'प्रतिनिधि अंतरफलक के टिकट उत्तरदायी स्क्रीन में टिकट प्रकार को स्थापित करता है(टिकट::प्रकार को सक्रिय करने की आवश्यकता है)।',
        'Sets the time (in seconds) a user is marked as active.' => '',
        'Sets the time type which should be shown.' => 'समय प्रकार जो दिखाया जाना चाहिए को स्थापित करता है।',
        'Sets the timeout (in seconds) for http/ftp downloads.' => 'http / FTP डाउनलोड करने के लिए समय समाप्ति(सेकेंड में) को स्थापित करता है।',
        'Sets the timeout (in seconds) for package downloads. Overwrites "WebUserAgent::Timeout".' =>
            'संकुल डाउनलोड करने के लिए समय समाप्ति (सेकेंड में) को स्थापित करता है। "WebUserAgent::Timeout" को अधिलेखित करता है।',
        'Sets the user time zone per user (required a system with UTC as system time and UTC under TimeZone). Otherwise this is a diff time to the local time.' =>
            'उपयोगकर्ता समय क्षेत्र प्रति उपयोगकर्ता के लिए स्थापित करता है(प्रणाली समय के रूप में UTC के साथ और समय क्षेत्र के अंतर्गत UTC एक प्रणाली की आवश्यकता)। अन्यथा यह स्थानीय समय के लिए एक अलग समय है।',
        'Sets the user time zone per user based on java script / browser time zone offset feature at login time.' =>
            'जावा स्क्रिप्ट/ब्राउज़र समय क्षेत्र ऑफसेट सुविधा के आधार पर उपयोगकर्ता समय क्षेत्र में प्रति उपयोगकर्ता के लिए स्थापित करता है।',
        'Show a responsible selection in phone and email tickets in the agent interface.' =>
            'प्रतिनिधि अंतरफलक में फोन और ईमेल के टिकटों में एक जिम्मेदार चयन दिखाएँ।',
        'Show article as rich text even if rich text writing is disabled.' =>
            '',
        'Show the current owner in the customer interface.' => '',
        'Show the current queue in the customer interface.' => '',
        'Shows a count of icons in the ticket zoom, if the article has attachments.' =>
            'टिकट ज़ूम में चिह्न की गिनती दिखाता है,यदि अनुच्छेद संलग्नक है।',
        'Shows a link in the menu for subscribing / unsubscribing from a ticket in the ticket zoom view of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट ज़ूम दृश्य में टिकट की सदस्यता/सदस्यता समाप्ति के लिए विकल्प सूची में एक कड़ी दिखाता है।',
        'Shows a link in the menu that allows linking a ticket with another object in the ticket zoom view of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट ज़ूम दृश्य में एक वस्तु के साथ एक टिकट जोड़ने की अनुमति देने के लिए विकल्प सूची में एक कड़ी दिखाता है।',
        'Shows a link in the menu that allows merging tickets in the ticket zoom view of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट ज़ूम दृश्य में टिकट विलय की अनुमति देने के लिए विकल्प सूची में एक कड़ी दिखाता है।',
        'Shows a link in the menu to access the history of a ticket in the ticket zoom view of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट ज़ूम दृश्य में टिकट के इतिहास का उपयोग करने के लिए विकल्प सूची में एक कड़ी दिखाता है।',
        'Shows a link in the menu to add a free text field in the ticket zoom view of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट ज़ूम दृश्य में मुक्त पाठ क्षेत्र को जोड़ने के लिए विकल्प सूची में एक कड़ी दिखाता है।',
        'Shows a link in the menu to add a note in the ticket zoom view of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट ज़ूम दृश्य में टिप्पणी को जोड़ने के लिए विकल्प सूची में एक कड़ी दिखाता है।',
        'Shows a link in the menu to add a note to a ticket in every ticket overview of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट ज़ूम दृश्य में हर टिकट के अवलोकन में टिप्पणी को जोड़ने के लिए विकल्प सूची में एक कड़ी दिखाता है।',
        'Shows a link in the menu to close a ticket in every ticket overview of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट ज़ूम दृश्य में हर टिकट के अवलोकन में टिकट बंद करने के लिए विकल्प सूची में एक कड़ी दिखाता है।',
        'Shows a link in the menu to close a ticket in the ticket zoom view of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट ज़ूम दृश्य में टिकट बंद करने के लिए विकल्प सूची में एक कड़ी दिखाता है।',
        'Shows a link in the menu to delete a ticket in every ticket overview of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'प्रतिनिधि अंतरफलक में हर टिकट के अवलोकन में टिकट को नष्ट करने के लिए विकल्प सूची में एक कड़ी दिखाता है। अतिरिक्त अभिगम नियंत्रण दिखाने या नहीं दिखाने के लिए ये कड़ी किया जा सकता है कुंजी "समूह" का उपयोग करके और "rw:group1;move_into:group2" विषयवस्तु की तरह।',
        'Shows a link in the menu to delete a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'प्रतिनिधि अंतरफलक के टिकट ज़ूम दृश्य में हर टिकट के अवलोकन में टिकट को नष्ट करने के लिए विकल्प सूची में एक कड़ी दिखाता है। अतिरिक्त अभिगम नियंत्रण दिखाने या नहीं दिखाने के लिए ये कड़ी किया जा सकता है कुंजी "समूह" का उपयोग करके और "rw:group1;move_into:group2" विषयवस्तु की तरह।',
        'Shows a link in the menu to go back in the ticket zoom view of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट ज़ूम दृश्य में वापस जाने के लिए विकल्प सूची में एक कड़ी दिखाता है।',
        'Shows a link in the menu to lock / unlock a ticket in the ticket overviews of the agent interface.' =>
            'प्रतिनिधि अंतरफलक में टिकट अवलोकन में टिकट लॉक/अनलॉक करने के लिए विकल्प सूची में एक कड़ी दिखाता है।',
        'Shows a link in the menu to lock/unlock tickets in the ticket zoom view of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट ज़ूम दृश्य में टिकट अवलोकन में टिकट लॉक/अनलॉक करने के लिए विकल्प सूची में एक कड़ी दिखाता है।',
        'Shows a link in the menu to move a ticket in every ticket overview of the agent interface.' =>
            'प्रतिनिधि अंतरफलक में हर टिकट के अवलोकन में टिकट स्थानांतरित करने के लिए विकल्प सूची में एक कड़ी दिखाता है।',
        'Shows a link in the menu to print a ticket or an article in the ticket zoom view of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट ज़ूम दृश्य में टिकट या अनुच्छेद मुद्रण करने के लिए विकल्प सूची में एक कड़ी दिखाता है।',
        'Shows a link in the menu to see the customer who requested the ticket in the ticket zoom view of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट ज़ूम दृश्य में ग्राहक को देखने के लिए जिसने टिकट के लिए अनुरोध किया के लिए विकल्प सूची में एक कड़ी दिखाता है।',
        'Shows a link in the menu to see the history of a ticket in every ticket overview of the agent interface.' =>
            'प्रतिनिधि अंतरफलक में हर टिकट के अवलोकन में टिकट इतिहास देखने के लिए विकल्प सूची में एक कड़ी दिखाता है।',
        'Shows a link in the menu to see the owner of a ticket in the ticket zoom view of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट ज़ूम दृश्य में टिकट के स्वामी को देखने के लिए विकल्प सूची में एक कड़ी दिखाता है।',
        'Shows a link in the menu to see the priority of a ticket in the ticket zoom view of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट ज़ूम दृश्य में टिकट की प्राथमिकता को देखने के लिए विकल्प सूची में एक कड़ी दिखाता है।',
        'Shows a link in the menu to see the responsible agent of a ticket in the ticket zoom view of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट ज़ूम दृश्य में टिकट के उत्तरदायी प्रतिनिधि को देखने के लिए विकल्प सूची में एक कड़ी दिखाता है।',
        'Shows a link in the menu to set a ticket as pending in the ticket zoom view of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट ज़ूम दृश्य में टिकट को विचाराधीन निर्धारित करने के लिए विकल्प सूची में एक कड़ी दिखाता है। ',
        'Shows a link in the menu to set a ticket as spam in every ticket overview of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'प्रतिनिधि अंतरफलक में हर टिकट के अवलोकन में टिकट को अवांछनीय के रूप में टिकट निर्धारित करने के लिए विकल्प सूची में एक कड़ी दिखाता है। अतिरिक्त अभिगम नियंत्रण दिखाने या नहीं दिखाने के लिए ये कड़ी किया जा सकता है कुंजी "समूह" का उपयोग करके और "rw:group1;move_into:group2" विषयवस्तु की तरह।',
        'Shows a link in the menu to set the priority of a ticket in every ticket overview of the agent interface.' =>
            'प्रतिनिधि अंतरफलक में हर टिकट के अवलोकन में टिकट की प्राथमिकता को निर्धारित करने के लिए विकल्प सूची में एक कड़ी दिखाता है।',
        'Shows a link in the menu to zoom a ticket in the ticket overviews of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट अवलोकन में एक टिकट ज़ूम करने के लिए विकल्प सूची में एक कड़ी दिखाता है।',
        'Shows a link to access article attachments via a html online viewer in the zoom view of the article in the agent interface.' =>
            'प्रतिनिधि अंतरफलक में अनुच्छेद के ज़ूम दृश्य में HTML ऑनलाइन दर्शक के माध्यम से अनुच्छेद संलग्नक उपयोग के लिए विकल्प सूची में एक कड़ी दिखाता है।',
        'Shows a link to download article attachments in the zoom view of the article in the agent interface.' =>
            'प्रतिनिधि अंतरफलक में अनुच्छेद के ज़ूम दृश्य में अनुच्छेद संलग्नक डाउनलोड करने के लिए विकल्प सूची में एक कड़ी दिखाता है।',
        'Shows a link to see a zoomed email ticket in plain text.' => 'सादे पाठ में एक जूम टिकट देखने के लिए एक कड़ी दिखाता है।',
        'Shows a link to set a ticket as spam in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'प्रतिनिधि अंतरफलक के टिकट ज़ूम दृश्य में टिकट को अवांछनीय के रूप में टिकट निर्धारित करने के लिए एक कड़ी दिखाता है। अतिरिक्त अभिगम नियंत्रण दिखाने या नहीं दिखाने के लिए ये कड़ी किया जा सकता है कुंजी "समूह" का उपयोग करके और "rw:group1;move_into:group2" विषयवस्तु की तरह।',
        'Shows a list of all the involved agents on this ticket, in the close ticket screen of the agent interface.' =>
            'इस टिकट में सभी शामिल प्रतिनिधियों की एक सूची दिखाता है,प्रतिनिधि अंतरफलक के बंद टिकट स्क्रीन में।',
        'Shows a list of all the involved agents on this ticket, in the ticket free text screen of the agent interface.' =>
            'इस टिकट में सभी शामिल प्रतिनिधियों की एक सूची दिखाता है,प्रतिनिधि अंतरफलक के टिकट मुक्त पाठ स्क्रीन में।',
        'Shows a list of all the involved agents on this ticket, in the ticket note screen of the agent interface.' =>
            'इस टिकट में सभी शामिल प्रतिनिधियों की एक सूची दिखाता है,प्रतिनिधि अंतरफलक के टिकट टिप्पणी स्क्रीन में।',
        'Shows a list of all the involved agents on this ticket, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'इस टिकट में सभी शामिल प्रतिनिधियों की एक सूची दिखाता है,प्रतिनिधि अंतरफलक में ज़ूम टिकट के टिकट स्वामी स्क्रीन में।',
        'Shows a list of all the involved agents on this ticket, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'इस टिकट में सभी शामिल प्रतिनिधियों की एक सूची दिखाता है,प्रतिनिधि अंतरफलक में ज़ूम टिकट के टिकट विचाराधीन स्क्रीन में।',
        'Shows a list of all the involved agents on this ticket, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'इस टिकट में सभी शामिल प्रतिनिधियों की एक सूची दिखाता है,प्रतिनिधि अंतरफलक में ज़ूम टिकट के टिकट प्राथमिकता स्क्रीन में।',
        'Shows a list of all the involved agents on this ticket, in the ticket responsible screen of the agent interface.' =>
            'इस टिकट में सभी शामिल प्रतिनिधियों की एक सूची दिखाता है,प्रतिनिधि अंतरफलक के टिकट उत्तरदायी स्क्रीन में।',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the close ticket screen of the agent interface.' =>
            'सभी संभावित प्रतिनिधियों की एक सूची दिखाता है(सभी प्रतिनिधि श्रेणी/टिकट में टिप्पणी अनुमतियों के साथ) निर्धारित करने के लिए जिसको इस नोट के बारे में सूचित किया जाना चाहिए,प्रतिनिधि अंतरफलक के बंद टिकट स्क्रीन में।',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket free text screen of the agent interface.' =>
            'सभी संभावित प्रतिनिधियों की एक सूची दिखाता है(सभी प्रतिनिधि श्रेणी/टिकट में टिप्पणी अनुमतियों के साथ) निर्धारित करने के लिए जिसको इस नोट के बारे में सूचित किया जाना चाहिए,प्रतिनिधि अंतरफलक के टिकट मुक्त पाठ स्क्रीन में।',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket note screen of the agent interface.' =>
            'सभी संभावित प्रतिनिधियों की एक सूची दिखाता है(सभी प्रतिनिधि श्रेणी/टिकट में टिप्पणी अनुमतियों के साथ) निर्धारित करने के लिए जिसको इस नोट के बारे में सूचित किया जाना चाहिए,प्रतिनिधि अंतरफलक के टिकट टिप्पणी स्क्रीन में।',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'सभी संभावित प्रतिनिधियों की एक सूची दिखाता है(सभी प्रतिनिधि श्रेणी/टिकट में टिप्पणी अनुमतियों के साथ) निर्धारित करने के लिए जिसको इस नोट के बारे में सूचित किया जाना चाहिए,प्रतिनिधि अंतरफलक में ज़ूम टिकट के टिकट स्वामी स्क्रीन में।',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'सभी संभावित प्रतिनिधियों की एक सूची दिखाता है(सभी प्रतिनिधि श्रेणी/टिकट में टिप्पणी अनुमतियों के साथ) निर्धारित करने के लिए जिसको इस नोट के बारे में सूचित किया जाना चाहिए,प्रतिनिधि अंतरफलक में ज़ूम टिकट के टिकट विचाराधीन स्क्रीन में।',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'सभी संभावित प्रतिनिधियों की एक सूची दिखाता है(सभी प्रतिनिधि श्रेणी/टिकट में टिप्पणी अनुमतियों के साथ) निर्धारित करने के लिए जिसको इस नोट के बारे में सूचित किया जाना चाहिए,प्रतिनिधि अंतरफलक में ज़ूम टिकट के टिकट प्राथमिकता स्क्रीन में।',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket responsible screen of the agent interface.' =>
            'सभी संभावित प्रतिनिधियों की एक सूची दिखाता है(सभी प्रतिनिधि श्रेणी/टिकट में टिप्पणी अनुमतियों के साथ) निर्धारित करने के लिए जिसको इस नोट के बारे में सूचित किया जाना चाहिए,प्रतिनिधि अंतरफलक के टिकट उत्तरदायी स्क्रीन में।',
        'Shows a preview of the ticket overview (CustomerInfo => 1 - shows also Customer-Info, CustomerInfoMaxSize max. size in characters of Customer-Info).' =>
            'टिकट अवलोकन का पूर्वावलोकन दिखाता है(ग्राहक जानकारी => 1- ग्राहक जानकारी भी दिखाता है,CustomerInfoMaxSize ग्राहक जानकारी के अक्षरों में अधिकतम आकार)।',
        'Shows all both ro and rw queues in the queue view.' => 'श्रेणी दृश्य में दोनों सभी ro और rw श्रेणीयो को दिखाता है।',
        'Shows all open tickets (even if they are locked) in the escalation view of the agent interface.' =>
            'प्रतिनिधि अंतरफलक की संवर्धित दृश्य में सभी खुले टिकट(भले ही वे लॉकङ हो) दिखाता है।',
        'Shows all open tickets (even if they are locked) in the status view of the agent interface.' =>
            'प्रतिनिधि अंतरफलक की स्तर दृश्य में सभी खुले टिकट(भले ही वे लॉकङ हो) दिखाता है।',
        'Shows all the articles of the ticket (expanded) in the zoom view.' =>
            'ज़ूम दृश्य में टिकट(विस्तारित) के सभी अनुच्छेद दिखाता है। ',
        'Shows all the customer identifiers in a multi-select field (not useful if you have a lot of customer identifiers).' =>
            'बहु चयन क्षेत्र में सभी ग्राहक पहचानकर्ताओं को दिखाता है(उपयोगी नहीं यदि आपके पास ग्राहक पहचानकर्ता बहुत है)।',
        'Shows an owner selection in phone and email tickets in the agent interface.' =>
            'प्रतिनिधि अंतरफलक में फोन और ईमेल टिकट में एक स्वामी चयन को दिखाता है।',
        'Shows colors for different article types in the article table.' =>
            '',
        'Shows customer history tickets in AgentTicketPhone, AgentTicketEmail and AgentTicketCustomer.' =>
            'प्रतिनिधि टिकट फोन,प्रतिनिधि टिकट ईमेल,और प्रतिनिधि टिकट ग्राहक में ग्राहक इतिहास टिकट दिखाता है।',
        'Shows either the last customer article\'s subject or the ticket title in the small format overview.' =>
            'छोटे प्रारूप अवलोकन में या तो अंतिम ग्राहक अनुच्छेद विषय या टिकट शीर्षक दिखाता है।',
        'Shows existing parent/child queue lists in the system in the form of a tree or a list.' =>
            'एक वृक्ष या एक सूची के रूप में वर्तमान प्रणाली में जनक/बालक श्रेणी सूची दिखाता है।',
        'Shows the activated ticket attributes in the customer interface (0 = Disabled and 1 = Enabled).' =>
            'ग्राहक अंतरफलक में टिकट सक्रिय विशेषताएँ दिखाता है(0= निष्क्रिय और सक्रिय =1)।',
        'Shows the articles sorted normally or in reverse, under ticket zoom in the agent interface.' =>
            'अनुच्छेद दिखाता है सामान्य रूप से हल या विपरीत दिशा में,प्रतिनिधि अंतरफलक में ज़ूम टिकट के अंतर्गत।',
        'Shows the customer user information (phone and email) in the compose screen.' =>
            'रचना स्क्रीन में ग्राहक उपयोगकर्ता जानकारी(फोन और ईमेल) दिखाता है।',
        'Shows the customer user\'s info in the ticket zoom view.' => 'टिकट ज़ूम दृश्य में ग्राहक उपयोगकर्ता जानकारी दिखाता है।',
        'Shows the message of the day (MOTD) in the agent dashboard. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually.' =>
            'प्रतिनिधि पटल में दिन का संदेश दिखाता है। "समूह" प्लगइन का उपयोग प्रतिबंधित करने के लिए प्रयोग किया जाता है(उदाहरण के लिए समूह: व्यवस्थापक, समूह 1; समूह 2;)।"तयशुदा" निर्धारित करता है,यदि प्लगइन तयशुदा रूप से सक्षम है या उपयोगकर्ता के लिए यह नियमावली रूप से सक्षम करने की जरूरत है।',
        'Shows the message of the day on login screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के प्रवेश स्क्रीन में दिन के संदेश दिखाता है।',
        'Shows the ticket history (reverse ordered) in the agent interface.' =>
            'प्रतिनिधि अंतरफलक में टिकट इतिहास(विपरीत आदेश) दिखाता है।',
        'Shows the ticket priority options in the close ticket screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के बंद टिकट स्क्रीन में टिकट प्राथमिकता विकल्प दिखाता है।',
        'Shows the ticket priority options in the move ticket screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के स्थानांतरित टिकट स्क्रीन में टिकट प्राथमिकता विकल्प दिखाता है।',
        'Shows the ticket priority options in the ticket bulk screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट थोक स्क्रीन में टिकट प्राथमिकता विकल्प दिखाता है।',
        'Shows the ticket priority options in the ticket free text screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट मुक्त पाठ स्क्रीन में टिकट प्राथमिकता विकल्प दिखाता है।',
        'Shows the ticket priority options in the ticket note screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट टिप्पणी स्क्रीन में टिकट प्राथमिकता विकल्प दिखाता है।',
        'Shows the ticket priority options in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'प्रतिनिधि अंतरफलक में ज़ूम टिकट के टिकट स्वामी स्क्रीन में टिकट प्राथमिकता विकल्प दिखाता है।',
        'Shows the ticket priority options in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'प्रतिनिधि अंतरफलक में ज़ूम टिकट के टिकट विचाराधीन स्क्रीन में टिकट प्राथमिकता विकल्प दिखाता है।',
        'Shows the ticket priority options in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'प्रतिनिधि अंतरफलक में ज़ूम टिकट के टिकट प्राथमिकता स्क्रीन में टिकट प्राथमिकता विकल्प दिखाता है।',
        'Shows the ticket priority options in the ticket responsible screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट उत्तरदायी स्क्रीन में टिकट प्राथमिकता विकल्प दिखाता है।',
        'Shows the title fields in the close ticket screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के बंद टिकट स्क्रीन में शीर्षक क्षेत्रों दिखाता है।',
        'Shows the title fields in the ticket free text screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट मुक्त पाठ स्क्रीन में शीर्षक क्षेत्रों दिखाता है।',
        'Shows the title fields in the ticket note screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट टिप्पणी स्क्रीन में शीर्षक क्षेत्रों दिखाता है।',
        'Shows the title fields in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'प्रतिनिधि अंतरफलक में ज़ूम टिकट के टिकट स्वामी स्क्रीन में शीर्षक क्षेत्रों दिखाता है।',
        'Shows the title fields in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'प्रतिनिधि अंतरफलक में ज़ूम टिकट के टिकट विचाराधीन स्क्रीन में शीर्षक क्षेत्रों दिखाता है।',
        'Shows the title fields in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'प्रतिनिधि अंतरफलक में ज़ूम टिकट के टिकट प्राथमिकता स्क्रीन में शीर्षक क्षेत्रों दिखाता है।',
        'Shows the title fields in the ticket responsible screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट उत्तरदायी स्क्रीन में शीर्षक क्षेत्रों दिखाता है।',
        'Shows time in long format (days, hours, minutes), if set to "Yes"; or in short format (days, hours), if set to "No".' =>
            'समय लंबे प्रारूप में दिखाता है(दिन,घंटे,मिनट),यदि "हाँ" पर निर्धारित है;या छोटे प्रारूप में(दिन,घंटे),यदि "नहीं" पर निर्धारित है।',
        'Shows time use complete description (days, hours, minutes), if set to "Yes"; or just first letter (d, h, m), if set to "No".' =>
            'समय उपयोग का पूर्ण विवरण दिखाता है(दिन,घंटे,मिनट),यदि "हाँ" पर निर्धारित है;या सिर्फ पहला अक्षर (डी,एच,म),यदि "नहीं" पर निर्धारित है। ',
        'Skin' => 'सतही',
        'SolutionDiffInMin' => '',
        'SolutionInMin' => '',
        'Sorts the tickets (ascendingly or descendingly) when a single queue is selected in the queue view and after the tickets are sorted by priority. Values: 0 = ascending (oldest on top, default), 1 = descending (youngest on top). Use the QueueID for the key and 0 or 1 for value.' =>
            'टिकटों(आरोही या अवरोही) को क्रमबद्ध करता है जब श्रेणी दृश्य में एक ही श्रेणी का चयन किया जाता है और टिकट प्राथमिकता के आधार पर बाद में क्रमबद्ध किए जाते हैं। मान:0=आरोही(शीर्ष में सबसे पुराना,तयशुदा),1=अवरोही(शीर्ष में नवीनतम)। कुंजी के लिए QueueID और मूल्य के लिए 0 या 1 का प्रयोग करें।',
        'Spam Assassin example setup. Ignores emails that are marked with SpamAssassin.' =>
            'अवांछनीय अवरोधी उदाहरण स्थापना। ईमेल जो अवांछनीय अवरोधी से चिह्नित हैं पर ध्यान न दें।',
        'Spam Assassin example setup. Moves marked mails to spam queue.' =>
            'अवांछनीय अवरोधी उदाहरण स्थापना। चिह्नित मेल अवांछनीय श्रेणी में स्थानांतरित करें।',
        'Specifies if an agent should receive email notification of his own actions.' =>
            'निर्दिष्ट करता है यदि एक प्रतिनिधि अपने खुद के कार्यों की ईमेल अधिसूचना प्राप्त करना चाहे।',
        'Specifies the available note types for this ticket mask. If the option is deselected, ArticleTypeDefault is used and the option is removed from the mask.' =>
            '',
        'Specifies the background color of the chart.' => 'संचित्र की पृष्ठभूमि का रंग निर्दिष्ट करता है।',
        'Specifies the background color of the picture.' => 'चित्र की पृष्ठभूमि का रंग निर्दिष्ट करता है।',
        'Specifies the border color of the chart.' => 'संचित्र की सरहद का रंग निर्दिष्ट करता है।',
        'Specifies the border color of the legend.' => 'किंवदंती की सरहद का रंग निर्दिष्ट करता है।',
        'Specifies the bottom margin of the chart.' => 'संचित्र के नीचे की हाशिये को निर्दिष्ट करता है।',
        'Specifies the different article types that will be used in the system.' =>
            'विभिन्न अनुच्छेद प्रकार जो प्रणाली में इस्तेमाल किया जाएगा निर्दिष्ट करता है।',
        'Specifies the different note types that will be used in the system.' =>
            'विभिन्न टिप्पणी प्रकार जो प्रणाली में इस्तेमाल किया जाएगा निर्दिष्ट करता है।',
        'Specifies the directory to store the data in, if "FS" was selected for TicketStorageModule.' =>
            'निर्देशिका में आँकड़े संग्रहीत करने के लिए निर्दिष्ट करता है,यदि टिकट संग्रहण मॉड्यूल के लिए "FS" चुना गया हो।',
        'Specifies the directory where SSL certificates are stored.' => 'निर्देशिका निर्दिष्ट करता है जहाँ SSL प्रमाणपत्र संग्रहीत हैं।',
        'Specifies the directory where private SSL certificates are stored.' =>
            'निर्देशिका निर्दिष्ट करता है जहाँ निजी SSL प्रमाणपत्र संग्रहीत हैं।',
        'Specifies the email address that should be used by the application when sending notifications. The email address is used to build the complete display name for the notification master (i.e. "OTRS Notification Master" otrs@your.example.com). You can use the OTRS_CONFIG_FQDN variable as set in your configuation, or choose another email address. Notifications are messages such as en::Customer::QueueUpdate or en::Agent::Move.' =>
            'ईमेल पते निर्दिष्ट करता है जब अनुप्रयोग के द्वारा उपयोग किया जाना चाहिए अधिसूचनाएँ भेजने के लिए। ईमेल पते अधिसूचना मास्टर के लिए पूर्ण प्रदर्शन नाम बनाने के काम आता है(अर्थात् "OTRS अधिसूचना मास्टर " otrs@your.example.com)। आप OTRS_CONFIG_FQDN परिवर्तनीय का उपयोग कर सकते हैं,जैसा आपके विन्यास में निर्धारित हैं,या किसी अन्य ईमेल पते का चयन करें। अधिसूचनाएं संदेशों के रूप में हैं जैसे en::Customer::QueueUpdate या en::Agent::Move।',
        'Specifies the group where the user needs rw permissions so that he can access the "SwitchToCustomer" feature.' =>
            '',
        'Specifies the left margin of the chart.' => 'संचित्र की दाईं हाशिए को निर्दिष्ट करता है।',
        'Specifies the name that should be used by the application when sending notifications. The sender name is used to build the complete display name for the notification master (i.e. "OTRS Notification Master" otrs@your.example.com). Notifications are messages such as en::Customer::QueueUpdate or en::Agent::Move.' =>
            'नाम निर्दिष्ट करता है जब अनुप्रयोग के द्वारा उपयोग किया जाना चाहिए अधिसूचनाएँ भेजने के लिए। प्रेषक का नाम अधिसूचना मास्टर के लिए पूर्ण प्रदर्शन नाम बनाने के काम आता है(अर्थात् "OTRS अधिसूचना मास्टर " otrs@your.example.com)। आप OTRS_CONFIG_FQDN परिवर्तनीय का उपयोग कर सकते हैं,जैसा आपके विन्यास में निर्धारित हैं,या किसी अन्य ईमेल पते का चयन करें। अधिसूचनाएं संदेशों के रूप में हैं जैसे en::Customer::QueueUpdate या en::Agent::Move।',
        'Specifies the path of the file for the logo in the page header (gif|jpg|png, 700 x 100 pixel).' =>
            'पृष्ठ शीर्षक में प्रतीक चिह्न के लिए फ़ाइल का पथ निर्दिष्ट करता है(gif|jpg|png, 700 x 100 पिक्सेल)।',
        'Specifies the path of the file for the performance log.' => 'प्रदर्शन के लिए अभिलेख के लिए फ़ाइल का पथ निर्दिष्ट करता है।',
        'Specifies the path to the converter that allows the view of Microsoft Excel files, in the web interface.' =>
            'वेब अंतरफलक में,परिवर्तक के लिए पथ निर्दिष्ट करता है जो Microsoft Excel फ़ाइलों को देखने की अनुमति देता हैं।',
        'Specifies the path to the converter that allows the view of Microsoft Word files, in the web interface.' =>
            'वेब अंतरफलक में,परिवर्तक के लिए पथ निर्दिष्ट करता है जो Microsoft Word फ़ाइलों को देखने की अनुमति देता हैं।',
        'Specifies the path to the converter that allows the view of PDF documents, in the web interface.' =>
            'वेब अंतरफलक में,परिवर्तक के लिए पथ निर्दिष्ट करता है जो PDF दस्तावेजों को देखने की अनुमति देता हैं।',
        'Specifies the path to the converter that allows the view of XML files, in the web interface.' =>
            'वेब अंतरफलक में,परिवर्तक के लिए पथ निर्दिष्ट करता है जो XML फ़ाइलों को देखने की अनुमति देता हैं।',
        'Specifies the right margin of the chart.' => 'संचित्र की बाएँ हाशिए को निर्दिष्ट करता है।',
        'Specifies the text color of the chart (e. g. caption).' => 'संचित्र के पाठ का रंग निर्दिष्ट करता है(जैसे अनुशीर्षक)।',
        'Specifies the text color of the legend.' => 'किंवदंती के पाठ का रंग निर्दिष्ट करता है।',
        'Specifies the text that should appear in the log file to denote a CGI script entry.' =>
            'पाठ को निर्दिष्ट करता है जो लॉग फ़ाइल में दिखाई देना चाहिए CGI स्क्रिप्ट प्रविष्टि निरूपित करने के लिए।',
        'Specifies the top margin of the chart.' => 'संचित्र के शीर्ष हाशिए को निर्दिष्ट करता है।',
        'Specifies user id of the postmaster data base.' => 'डाकपाल आंकड़ा कोष के उपयोगकर्ता आईडी को निर्दिष्ट करता है।',
        'Specify how many sub directory levels to use when creating cache files. This should prevent too many cache files being in one directory.' =>
            '',
        'Standard available permissions for agents within the application. If more permissions are needed, they can be entered here. Permissions must be defined to be effective. Some other good permissions have also been provided built-in: note, close, pending, customer, freetext, move, compose, responsible, forward, and bounce. Make sure that "rw" is always the last registered permission.' =>
            'मानक अनुप्रयोग के भीतर प्रतिनिधियों के लिए उपलब्ध अनुमतियाँ। यदि अधिक अनुमतियों की आवश्यकता है,उन्हें यहाँ दर्ज किया जा सकता। अनुमतियों के लिए प्रभावी होगा परिभाषित किया जाना चाहिए। कुछ अन्य अच्छी अन्तर्निहित अनुमतियाँ भी प्रदान की है: टिप्पणी,विचाराधीन,बंद,ग्राहक,मुक्त पाठ,स्थानांतरित,रचना,उत्तरदायी,अग्रेषण और फलांग। सुनिश्चित करें कि "rw" हमेशा अंतिम पंजीकृत अनुमति हैं।',
        'Start number for statistics counting. Every new stat increments this number.' =>
            'सांख्यिकी की गणना के लिए आरंभ संख्या। हर नया आँकड़ा इस संख्या बढ़ता है।',
        'Starts a wildcard search of the active object after the link object mask is started.' =>
            '',
        'Statistics' => 'सांख्यिकी',
        'Status view' => 'स्तर दृश्य',
        'Stop words for fulltext index. These words will be removed.' => '',
        'Stores cookies after the browser has been closed.' => 'ब्राउज़र के बंद होने के बाद कुकीज़ को संग्रहीत करता है।',
        'Strips empty lines on the ticket preview in the queue view.' => 'कतार दृश्य में टिकट पूर्वावलोकन पर रिक्त पंक्तियाँ खाली कर देता है।',
        'Textarea' => '',
        'The "bin/PostMasterMailAccount.pl" will reconnect to POP3/POP3S/IMAP/IMAPS host after the specified count of messages.' =>
            'संदेशों की निर्दिष्ट संख्या के बाद "bin/PostMasterMailAccount.pl" POP3/POP3S/IMAP/IMAPS मेजबान से फिर जुडेगा।',
        'The agent skin\'s InternalName which should be used in the agent interface. Please check the available skins in Frontend::Agent::Skins.' =>
            'प्रतिनिधि की आंतरिक सतही का नाम जो प्रतिनिधि अंतरफलक में उपयोग किया जाना चाहिए। दृश्यपटल::एजेंट::सतही में उपलब्ध सतही की जाँच करें।',
        'The customer skin\'s InternalName which should be used in the customer interface. Please check the available skins in Frontend::Customer::Skins.' =>
            'ग्राहक की आंतरिक सतही का नाम जो ग्राहक अंतरफलक में उपयोग किया जाना चाहिए। दृश्यपटल::ग्राहक::सतही में उपलब्ध सतही की जाँच करें।',
        'The divider between TicketHook and ticket number. E.g \': \'.' =>
            'टिकट हूक और टिकट संख्या के बीच विभाजक। उदा. \': \'।',
        'The duration in minutes after emitting an event, in which the new escalation notify and start events are suppressed.' =>
            '',
        'The format of the subject. \'Left\' means \'[TicketHook#:12345] Some Subject\', \'Right\' means \'Some Subject [TicketHook#:12345]\', \'None\' means \'Some Subject\' and no ticket number. In the last case you should enable PostmasterFollowupSearchInRaw or PostmasterFollowUpSearchInReferences to recognize followups based on email headers and/or body.' =>
            'विषय का प्रारूप। \'बाएँ \' का अर्थ है \'[TicketHook#:12345] कुछ विषय\',\'दाहिना\' का अर्थ\'कुछ विषय [TicketHook#:12345]\',\'कोई नहीं\' का अर्थ है \'कुछ विषय\' और कोई टिकट संख्या। अंतिम मामले में आप PostmasterFollowupSearchInRaw या PostmasterFollowUpSearchInReferences सक्षम करे ईमेल के हेडर और/या मुख्य-भाग पर आधारित अनुवर्ती कार्रवाई की पहचान के लिए।',
        'The headline shown in the customer interface.' => 'ग्राहक अंतरफलक में दिखाया गया शीर्षक।',
        'The identifier for a ticket, e.g. Ticket#, Call#, MyTicket#. The default is Ticket#.' =>
            'एक टिकट के लिए पहचानकर्ता,उदा टिकट#,कॉल#,मेरा टिकट#। तयशुदा टिकट# हैं।',
        'The logo shown in the header of the agent interface. The URL to the image can be a relative URL to the skin image directory, or a full URL to a remote web server.' =>
            '',
        'The logo shown in the header of the customer interface. The URL to the image can be a relative URL to the skin image directory, or a full URL to a remote web server.' =>
            '',
        'The logo shown on top of the login box of the agent interface. The URL to the image must be relative URL to the skin image directory.' =>
            'प्रतिनिधि अंतरफलक के प्रवेश बॉक्स के शीर्ष पर दिखाया गया प्रतीक चिह्न। छवि के लिए URL सतही की छवि निर्देशिका के कोई सापेक्ष URL होना चाहिए।',
        'The text at the beginning of the subject in an email reply, e.g. RE, AW, or AS.' =>
            'एक ईमेल जवाब में विषय के प्रारंभ में पाठ,उदा. RE, AW, या AS।',
        'The text at the beginning of the subject when an email is forwarded, e.g. FW, Fwd, or WG.' =>
            'एक ईमेल जवाब में विषय के प्रारंभ में पाठ जब एक ईमेल अग्रेषित किया हैं,उदा. FW, Fwd, या WG। ',
        'This module and its PreRun() function will be executed, if defined, for every request. This module is useful to check some user options or to display news about new applications.' =>
            'इस मॉड्यूल और उसके(PreRun) प्रकार्य में क्रियान्वित किया जाएगा,यदि परिभाषित हैं,प्रत्येक अनुरोध के लिए। यह मॉड्यूल उपयोगी है कुछ उपयोगकर्ता की जाँच विकल्प या नये अनुप्रयोगों के बारे में समाचार प्रदर्शित करने के लिए।',
        'This option defines the dynamic field in which a Process Management activity entity id is stored.' =>
            '',
        'This option defines the dynamic field in which a Process Management process entity id is stored.' =>
            '',
        'This option defines the process tickets default lock.' => '',
        'This option defines the process tickets default priority.' => '',
        'This option defines the process tickets default queue.' => '',
        'This option defines the process tickets default state.' => '',
        'This setting allows you to override the built-in country list with your own list of countries. This is particularly handy if you just want to use a small select group of countries.' =>
            '',
        'Ticket event module that triggers the escalation stop events.' =>
            '',
        'Ticket overview' => 'टिकट अवलोकन ',
        'TicketNumber' => '',
        'Tickets' => 'टिकटें',
        'Time in seconds that gets added to the actual time if setting a pending-state (default: 86400 = 1 day).' =>
            'यदि विचाराधीन स्तिथि निर्धारित कर रहे हैं जो समय सेकंड में हैं वास्तविक समय में जुड जाएगा(तयशुदा:86400=1 दिन)।',
        'Toggles display of OTRS FeatureAddons list in PackageManager.' =>
            '',
        'Toolbar Item for a shortcut.' => 'टूलबार वस्तु किसी शॉर्टकट के लिए।',
        'Turns on the animations used in the GUI. If you have problems with these animations (e.g. performance issues), you can turn them off here.' =>
            'GUI में इस्तेमाल एनिमेशन प्रारंभ करते हैं। यदि आपको इन एनिमेशन के साथ समस्या है(उदाहरण के लिए प्रदर्शन के मुद्दों),यहां आप उन्हें बंद कर सकते हैं।',
        'Turns on the remote ip address check. It should be set to "No" if the application is used, for example, via a proxy farm or a dialup connection, because the remote ip address is mostly different for the requests.' =>
            'सुदूर IP पते की जाँच प्रारंभ करते हैं। यह "नहीं" स्थापित किया जाना चाहिए,यदि अनुप्रयोग इस्तेमाल किया जाता है,एक प्रॉक्सी या एक डायलअप कनेक्शन के माध्यम से,क्योंकि सुदूर IP पते ज्यादातर अनुरोधों के लिए अलग अलग है। ',
        'Types' => 'प्रकार',
        'Update Ticket "Seen" flag if every article got seen or a new Article got created.' =>
            'टिकट "देखा है" चिह्नक अद्यतन करें,यदि हर अनुच्छेद देखा लिया है या एक नया अनुच्छेद बनाया है।',
        'Update and extend your system with software packages.' => 'सॉफ्टवेयर संकुल के साथ आपकी प्रणाली अद्यतन और विस्तार करें।',
        'Updates the ticket escalation index after a ticket attribute got updated.' =>
            'टिकट विशेषता अद्यतन के बाद टिकट के संवर्धित सूचकांक को अद्यतन करें।',
        'Updates the ticket index accelerator.' => 'टिकट सूचकांक गतिवर्धक को अद्यतन करें।',
        'UserFirstname' => '',
        'UserLastname' => '',
        'Uses Cc recipients in reply Cc list on compose an email answer in the ticket compose screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के रचना स्क्रीन में एक ईमेल का जवाब की रचना पर जवाब प्रतिलिपि में प्रतिलिपि प्राप्तकर्ताओं का उपयोग करता है।',
        'Uses richtext for viewing and editing: articles, salutations, signatures, standard responses, auto responses and notifications.' =>
            'देखने और संपादित करने के लिए समृद्ध पाठ का उपयोग करता है: अनुच्छेद,अभिवादन,हस्ताक्षर,मानक प्रतिक्रियाएं,स्वत प्रतिक्रियाओं और अधिसूचनाएं।',
        'View performance benchmark results.' => 'प्रदर्शन बेंचमार्क परिणाम देखें।',
        'View system log messages.' => 'प्रणाली अभिलेख संदेशों को देखें।',
        'Wear this frontend skin' => 'इस दृश्यपटल सतही को पहनें।',
        'Webservice path separator.' => '',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. In this text area you can define this text (This text cannot be changed by the agent).' =>
            'जब टिकटों को विलय कर रहे हैं,एक टिप्पणी स्वचालित रूप से जोड़ दी जाएगी उस टिकट को जो अब सक्रिय नहीं है। इस पाठ क्षेत्र में आप इस पाठ को परिभाषित कर सकते हैं(यह पाठ प्रतिनिधि के द्वारा बदला नहीं जा सकता है)।',
        'When tickets are merged, the customer can be informed per email by setting the check box "Inform Sender". In this text area, you can define a pre-formatted text which can later be modified by the agents.' =>
            'जब टिकटों को विलय कर रहे हैं, चेक बॉक्स "सूचित प्रेषक" निर्धारित करने के बाद ग्राहक को ईमेल द्वारा सूचित किया जा सकता है। इस पाठ क्षेत्र में,आप एक पूर्व स्वरूपित पाठ परिभाषित कर सकते हैं जो बाद में प्रतिनिधियों द्वारा संशोधित किया जा सकता है। ',
        'Your queue selection of your favorite queues. You also get notified about those queues via email if enabled.' =>
            'अपनी श्रेणी का चयन करें पसंदीदा श्रेणीयो से। आपको उन श्रेणीयो के बारे में ईमेल द्वारा अधिसूचित किया जाएगा। सक्रिय होने पर।',

        #
        # OBSOLETE ENTRIES FOR REFERENCE, DO NOT TRANSLATE!
        #
        'Adds customers email addresses to recipients in the ticket compose screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट रचना स्क्रीन के में प्राप्तकर्ताओं को ग्राहकों के ईमेल पते जोड़ता है।',
        'Allows extended search conditions in ticket search of the agent interface. With this feature you can search w. g. with this kind of conditions like "(key1&&key2)" or "(key1||key2)".' =>
            'प्रतिनिधि अंतरफलक के टिकट खोज में खोज स्थितियों के विस्तार की अनुमति देता है।इस सुविधा के साथ आप खोज कर सकते हैं उदा. इस प्रकार की स्थितियों के साथ "(key1 && key2)"या"(key1 || key2)"।',
        'Configures the full-text index. Execute "bin/otrs.RebuildFulltextIndex.pl" in order to generate a new index.' =>
            'पूर्ण पाठ सूचकांक विन्यस्त करें। नया सूचकांक उत्पन्न करने के लिए "bin/otrs.RebuildFulltextIndex.pl"चलाएँ।',
        'Customer Data' => 'ग्राहक आंकड़ा',
        'Disables the web installer (http://yourhost.example.com/otrs/installer.pl), to prevent the system from being hijacked. If set to "No", the system can be reinstalled and the current basic configuration will be used to pre-populate the questions within the installer script. If not active, it also disables the GenericAgent, PackageManager and SQL Box (to avoid the use of destructive queries, such as DROP DATABASE, and also to steal user passwords).' =>
            'प्रणाली को अपहरण से रोकने के लिए वेब संस्थापक(http://yourhost.example.com/otrs/installer.pl) को निष्क्रिय करता है। यदि "नहीं" पर सेट है,प्रणाली को फिर से स्थापित किया जा सकता और मौजूदा बुनियादी संरचना का उपयोग किया जाएगा संस्थापक स्क्रिप्ट के भीतर सवालों के पूर्व आबाद करने के लिए। यदि सक्रिय नहीं है,यह सामान्य प्रतिनिधि,संकुल प्रबंधक और SQL बॉक्स को भी निष्क्रिय कर देगा(विध्वंसक क्वेरी के उपयोग से बचने के लिए,जैसे कि DROP DATABASE,और को भी उपयोक्ता शब्दकूट चोरी करने के लिए)।',
        'Experimental "Slim" skin which tries to save screen space for power users.' =>
            'प्रयोगात्मक सतही "स्लिम" जो सत्ता उपयोगकर्ताओं के लिए स्क्रीन स्थान बचाने की कोशिश करता है।',
        'For more info see:' => 'अधिक जानकारी के लिए देखें :',
        'Logout successful. Thank you for using OTRS!' => 'बाहर प्रवेश सफल। OTRS उपयोग करने के लिए धन्यवाद।',
        'Maximum size (in characters) of the customer info table in the queue view.' =>
            'श्रेणीं दृश्य में ग्राहक जानकारी तालिका का अधिकतम आकार(अक्षरों में)।',
        'Package verification failed!' => 'संकुल पुष्टिकरण असफल रहा।',
        'Please supply a' => 'कृपया प्रदान करें',
        'Please supply a first name' => 'कृपया पहला नाम प्रदान करें',
        'Please supply a last name' => 'कृपया आखिरी नाम प्रदान करें',
        'Secure mode must be disabled in order to reinstall using the web-installer.' =>
            'सुरक्षित मोड का उपयोग करके अक्षम किया जाना चाहिए वेब इंस्टॉलर से उसके पुन:स्थापित के लिए।',

    };
    # $$STOP$$
    return;
}

1;
