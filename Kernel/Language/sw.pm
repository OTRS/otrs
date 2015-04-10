# --
# Kernel/Language/sw.pm - provides Swahili language translation
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::sw;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # http://en.wikipedia.org/wiki/Date_and_time_notation_by_country#United_States
    # month-day-year (e.g., "12/31/99")

    # $$START$$
    # possible charsets
    $Self->{Charset} = ['utf-8', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Year;)
    $Self->{DateFormat}          = '%M/%D/%Y %T';
    $Self->{DateFormatLong}      = '%T - %M/%D/%Y';
    $Self->{DateFormatShort}     = '%M/%D/%Y';
    $Self->{DateInputFormat}     = '%M/%D/%Y';
    $Self->{DateInputFormatLong} = '%M/%D/%Y - %T';

    # csv separator
    $Self->{Separator} = ',';

    $Self->{Translation} = {

        # Template: AAABase
        'Yes' => 'Ndio',
        'No' => 'Hapana',
        'yes' => 'ndio',
        'no' => 'hapana',
        'Off' => 'Zima',
        'off' => 'zima',
        'On' => 'Washa',
        'on' => 'washa',
        'top' => 'juu',
        'end' => 'mwisho',
        'Done' => 'Maliza',
        'Cancel' => 'Futa',
        'Reset' => 'Kuweka',
        'more than ... ago' => 'Zaidi ya...Iliyopita',
        'in more than ...' => 'Ndani zaidi ya...',
        'within the last ...' => 'Ndani ya mwisho...',
        'within the next ...' => 'Ndani ya inayofuata...',
        'Created within the last' => 'Ilitengenezwa ndani ya ya mwisho',
        'Created more than ... ago' => 'Ilitengenezwa zaidi ya...iliyopita',
        'Today' => 'Leo',
        'Tomorrow' => 'Kesho',
        'Next week' => 'Wiki ijayo',
        'day' => 'Siku',
        'days' => 'Siku',
        'day(s)' => 'Siku',
        'd' => 'd',
        'hour' => 'Saa',
        'hours' => 'Masaa',
        'hour(s)' => '(Ma)Saa',
        'Hours' => 'Masaa',
        'h' => 'S',
        'minute' => 'Dakika',
        'minutes' => 'Dakika',
        'minute(s)' => 'Dakika',
        'Minutes' => 'Dakika',
        'm' => 'd',
        'month' => 'Mwezi',
        'months' => 'Miezi',
        'month(s)' => '(Mi)Mwezi',
        'week' => 'Wiki',
        'week(s)' => 'Wiki',
        'year' => 'Mwaka',
        'years' => 'Miaka',
        'year(s)' => '(Mi)Mwaka',
        'second(s)' => 'sekunde',
        'seconds' => 'Sekunde',
        'second' => 'Sekunde',
        's' => 's',
        'Time unit' => 'Kizio cha Muda',
        'wrote' => 'Iliandika',
        'Message' => 'Ujumbe',
        'Error' => 'Kosa',
        'Bug Report' => 'Ripoti yenye makosa',
        'Attention' => 'Angalizo',
        'Warning' => 'Onyo',
        'Module' => 'Moduli',
        'Modulefile' => 'Faili la moduli',
        'Subfunction' => 'Kijikazi',
        'Line' => 'Mstari',
        'Setting' => 'Mpangilio',
        'Settings' => 'Mpangilio',
        'Example' => 'Mfano',
        'Examples' => 'Mifano',
        'valid' => 'Halali',
        'Valid' => 'Halali',
        'invalid' => 'isiyo halali',
        'Invalid' => 'Isiyo halali',
        '* invalid' => '*isiyo halali',
        'invalid-temporarily' => 'isiyo halali kwa muda mfupi',
        ' 2 minutes' => 'Dakika 2',
        ' 5 minutes' => 'Dakika 5',
        ' 7 minutes' => 'Dakika 7',
        '10 minutes' => 'Dakika 10',
        '15 minutes' => 'Dakika 15',
        'Mr.' => 'Bwana',
        'Mrs.' => 'Bibi',
        'Next' => 'Baadae',
        'Back' => 'Nyuma',
        'Next...' => 'Baadae...',
        '...Back' => '..Nyuma',
        '-none-' => '-hakuna-',
        'none' => 'hakuna',
        'none!' => 'hakuna!',
        'none - answered' => 'hakuna iliyojibiwa',
        'please do not edit!' => 'Tafadhali usihariri!',
        'Need Action' => 'Inahitaji hatua',
        'AddLink' => 'Ongezakiungo',
        'Link' => 'Kiungo',
        'Unlink' => 'Isiyokiungo',
        'Linked' => 'Imeunganishwa',
        'Link (Normal)' => 'Kiungo(kawaida)',
        'Link (Parent)' => 'Kiungo (Zazi)',
        'Link (Child)' => 'Kiungo (Ndogo)',
        'Normal' => 'Kawaida',
        'Parent' => 'Mzazi',
        'Child' => 'Mtoto(Ndogo)',
        'Hit' => 'Gonga',
        'Hits' => 'Gonga',
        'Text' => 'Matini',
        'Standard' => 'Kiwango',
        'Lite' => 'Nyepesi',
        'User' => 'Mtumiaji',
        'Username' => 'Jina la mtumiaji',
        'Language' => 'Lugha',
        'Languages' => 'Lugha',
        'Password' => 'Neno la siri',
        'Preferences' => 'Pendekezo',
        'Salutation' => 'Salamu',
        'Salutations' => 'Salamu',
        'Signature' => 'Saini',
        'Signatures' => 'Saini',
        'Customer' => 'Mteja',
        'CustomerID' => 'Kitambilisho cha mteja',
        'CustomerIDs' => 'Vitambulisho vya mteja',
        'customer' => 'mteja',
        'agent' => 'wakala',
        'system' => 'mfumo',
        'Customer Info' => 'Taarifa za mteja',
        'Customer Information' => 'Taarifa za mteja',
        'Customer Companies' => 'Kampuni ya mteja',
        'Company' => 'Kampuni',
        'go!' => 'nenda!',
        'go' => 'nenda',
        'All' => 'Yote',
        'all' => 'yote',
        'Sorry' => 'Samahani',
        'update!' => 'sasisha!',
        'update' => 'sasisha',
        'Update' => 'Sasisha',
        'Updated!' => 'Iliyosasishwa!',
        'submit!' => 'kusanya!',
        'submit' => 'kusanya',
        'Submit' => 'Kusanya',
        'change!' => 'badilisha!',
        'Change' => 'Badilisha',
        'change' => 'badilisha',
        'click here' => 'boya hapa',
        'Comment' => 'Maoni',
        'Invalid Option!' => 'Chaguo batili',
        'Invalid time!' => 'Muda batili!',
        'Invalid date!' => 'Tarehe batili!',
        'Name' => 'Jina',
        'Group' => 'Kikundi',
        'Description' => 'Maelezo',
        'description' => 'maelezo',
        'Theme' => 'Mandhari',
        'Created' => 'Ilitengenezwa',
        'Created by' => 'Ilitengenezwa na',
        'Changed' => 'Ilibadilishwa',
        'Changed by' => 'Ilibadilishwa',
        'Search' => 'Tafuta',
        'and' => 'na',
        'between' => 'katikati',
        'before/after' => 'kabla/baada',
        'Fulltext Search' => 'Tafuta nakala kamili',
        'Data' => 'Data',
        'Options' => 'Chaguo',
        'Title' => 'Kichwa cha habari',
        'Item' => 'Kipengele',
        'Delete' => 'Futa',
        'Edit' => 'Hariri',
        'View' => 'Angalia',
        'Number' => 'Namba',
        'System' => 'Mfumo',
        'Contact' => 'Mwasiliani',
        'Contacts' => 'Waasiliani',
        'Export' => 'Hamisha',
        'Up' => 'Juu',
        'Down' => 'Chini',
        'Add' => 'Ongeza',
        'Added!' => 'Ongezwa',
        'Category' => 'Kategoria',
        'Viewer' => 'Mtazamaji',
        'Expand' => 'Panua',
        'Small' => 'Ndogo',
        'Medium' => 'Wastani',
        'Large' => 'Kubwa',
        'Date picker' => 'Kitwaa tarehe',
        'Show Tree Selection' => 'Onyesha chaguo la mti',
        'The field content is too long!' => 'Yaliyomo katika uga ni mengi sana!',
        'Maximum size is %s characters.' => 'Upeo wa juu wa ukubwa ni % miundo.',
        'This field is required or' => 'Uga huu unahitajika au',
        'New message' => 'Ujumbe mpya',
        'New message!' => 'Ujumbe mpya!',
        'Please answer this ticket(s) to get back to the normal queue view!' =>
            'Tafadhali jibu tiketi hi(z)i kurudi nyuma kwenye mandhari ya kawaida ya foleni',
        'You have %s new message(s)!' => 'Una ujumbe %s m(i)pya',
        'You have %s reminder ticket(s)!' => 'Una tiketi %s kumbusho!',
        'The recommended charset for your language is %s!' => 'Seti ya herufi iliyopendekezwa kwa lugha yako ni %s!',
        'Change your password.' => 'Badili neno la siri',
        'Please activate %s first!' => 'Tafadhani amilisha %s kwanza!',
        'No suggestions' => 'Hakuna mapendekezo',
        'Word' => 'Neno',
        'Ignore' => 'Puuzia',
        'replace with' => 'Badilisha na',
        'There is no account with that login name.' => 'Hakuna akaunti yenye kifungua jina hilo.',
        'Login failed! Your user name or password was entered incorrectly.' =>
            'Kuingia kumeshindikana. Jina lako la mtumiaji au neno la siri lililoingizwa halikuwa sahihi.',
        'There is no acount with that user name.' => 'Hakuna akaunti yenye jina la mtumiaji hilo',
        'Please contact your administrator' => 'Tafadhali wasiliana na kiongozi wako',
        'Authentication succeeded, but no customer record is found in the customer backend. Please contact your administrator.' =>
            'Uhalalishaji umefanikiwa, lakini hakuna rekodi za mteja zilizokutwa katika mazingira yake nyuma. Tafadhali wasiliana na kiongozi wako.',
        'This e-mail address already exists. Please log in or reset your password.' =>
            'Anwani ya barua pepe hii tayari ipo. Tafadhali ingia au weka upya neno lako la siri.',
        'Logout' => 'Funga',
        'Logout successful. Thank you for using %s!' => 'Umefanikiwa kutoka. Asante kwa kutumia %s!',
        'Feature not active!' => 'Kipengele hakipo amilifu.',
        'Agent updated!' => 'Wakala amesasishwa',
        'Database Selection' => 'Chaguo la hifadhi data',
        'Create Database' => 'Tengeneza hifadhidata',
        'System Settings' => 'Mipangilio ya mfumo',
        'Mail Configuration' => 'Usanidi wa barua pepe',
        'Finished' => 'Maliza',
        'Install OTRS' => 'Sakinisha OTRS',
        'Intro' => 'Utangulizi',
        'License' => 'Leseni',
        'Database' => 'Hifadhi data',
        'Configure Mail' => 'Sanidi barua pepe',
        'Database deleted.' => 'Hifadhi data imefutwa',
        'Enter the password for the administrative database user.' => 'Ingiza neo la siri kwa mtumiaji wa utawala wa hifadhi data',
        'Enter the password for the database user.' => 'Ingiza neno la siri kwa mtumiaji wa hifadhi data',
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty.' =>
            'Kama umeweka neno la  siri shina kwa ajili ya hifadhi data, lazima liingizwe hapa. Kama sio, acha uga huu wazi.',
        'Database already contains data - it should be empty!' => 'Hifadhi data ina data tayari-inatakiwa kuwa wazi!',
        'Login is needed!' => 'kuingia kunatakiwa!',
        'It is currently not possible to login due to a scheduled system maintenance.' =>
            'Kwa sasa huwezi kuingia kwa sababu ya matengenezo ya mfumo.',
        'Password is needed!' => 'Neno la siri linahitajika!',
        'Take this Customer' => 'Mchukue mteja huyu.',
        'Take this User' => 'Mchukue mtumiaji huyu.',
        'possible' => 'Inawezekana',
        'reject' => 'Kataa',
        'reverse' => 'Badili',
        'Facility' => 'Kituo',
        'Time Zone' => 'Majira ya saa',
        'Pending till' => 'Inasubiri hadi',
        'Don\'t use the Superuser account to work with OTRS! Create new Agents and work with these accounts instead.' =>
            'Usitumie akaunti ya mtumiaji barabara kufanya kazi na OTRS! Tengeneza mawakala wapya na ufanye kazi na hizo akaunti badala yake.',
        'Dispatching by email To: field.' => 'Tuma kwa barua pepe kwenda: uga.',
        'Dispatching by selected Queue.' => 'Tuma kwa foleni iliyochaguliwa.',
        'No entry found!' => 'Hakuna ingizo lililopatikana!',
        'Session invalid. Please log in again.' => 'Kipindi batili. Tafadhani ingia tena.',
        'Session has timed out. Please log in again.' => 'Muda wa kipindi umeisha.Tafadhali jaribu tena baadae',
        'Session limit reached! Please try again later.' => 'Upeo wa kipindi umefikiwa.Tafadhali jaribu tena baadae.',
        'No Permission!' => 'Hakuna ruhusa',
        '(Click here to add)' => '(Bofya hapa kuongeza)',
        'Preview' => 'Kihakiki',
        'Package not correctly deployed! Please reinstall the package.' =>
            'KIfurushi hakijatumiwa kwa usahihi. Tafadhali Sakini kifurushi tena.',
        '%s is not writable!' => '%s haiandikiki!',
        'Cannot create %s!' => 'Haiwezi Kutengenezwa %s!',
        'Check to activate this date' => 'Angalia kuamilisha tarehe hii',
        'You have Out of Office enabled, would you like to disable it?' =>
            'Nje ya ofisi imewezeshwa, ungependa kuikatisha?',
        'News about OTRS releases!' => 'Taarifa kuhusu matoleo ya OTRS! ',
        'Customer %s added' => 'Mteja %s ameongezwa',
        'Role added!' => 'Jukumu limeongezwa!',
        'Role updated!' => 'Jukumu limesasishwa!',
        'Attachment added!' => 'Kiambatisho kimeongezwa!',
        'Attachment updated!' => 'Kiambatisho kimesasishwa!',
        'Response added!' => 'Majibu yameongezwa!',
        'Response updated!' => 'Majibu yamesasishwa!',
        'Group updated!' => 'Kikundi kimesasishwa',
        'Queue added!' => 'Foleni kimeongezwa!',
        'Queue updated!' => 'Foleni imesasishwa!',
        'State added!' => 'Hali imeongezwa!',
        'State updated!' => 'Hali imesasishwa!',
        'Type added!' => 'Aina imeongezwa!',
        'Type updated!' => 'Aina imesasishwa!',
        'Customer updated!' => 'Mteja amesasishwa!',
        'Customer company added!' => 'Kampuni ya mteja imeongezwa!',
        'Customer company updated!' => 'Kampuni ya mteja imesasishwa!',
        'Note: Company is invalid!' => 'Kidokezo: Kampuni ni batili!',
        'Mail account added!' => 'Akaunti ya barua pepe imeongezwa!',
        'Mail account updated!' => 'Akaunti ya barua pepe imesasishwa!',
        'System e-mail address added!' => 'Barua pepe ya mfumo imeongezwa!',
        'System e-mail address updated!' => 'Barua pepe ya mfumo imesasishwa!',
        'Contract' => 'Mkataba',
        'Online Customer: %s' => 'Mteja wa mtandaoni: %s',
        'Online Agent: %s' => 'Wakala wa matandaoni: %s',
        'Calendar' => 'Kalenda',
        'File' => 'Faili',
        'Filename' => 'Jina la faili',
        'Type' => 'Aina',
        'Size' => 'Ukubwa',
        'Upload' => 'Pakia',
        'Directory' => 'Mpangilio orodha',
        'Signed' => 'Imesainiwa',
        'Sign' => 'Saini',
        'Crypted' => 'Iliyosimbwa fiche',
        'Crypt' => 'Kusimba fiche',
        'PGP' => 'PGP ',
        'PGP Key' => 'Ufunguo wa PGP',
        'PGP Keys' => 'Funguo za PGP',
        'S/MIME' => 'S/MIME',
        'S/MIME Certificate' => 'Cheti cha S/MIME ',
        'S/MIME Certificates' => 'Vyeti vya S/MIME',
        'Office' => 'Ofisi',
        'Phone' => 'Simu',
        'Fax' => 'Faksi',
        'Mobile' => 'Simu ya mkononi',
        'Zip' => 'Posta',
        'City' => 'Mji',
        'Street' => 'Mtaa',
        'Country' => 'Nchi',
        'Location' => 'Mahali',
        'installed' => 'Iliyosakinishwa',
        'uninstalled' => 'Isiyosakinishwa',
        'Security Note: You should activate %s because application is already running!' =>
            'Kidokezo za usalama: Unatakiwa kuamilisha %s kwasababu programu-tumizi tayari inafanya kazi.',
        'Unable to parse repository index document.' => 'Imeshindwa kuchanganua hati ya kielezo cha hifadhi.',
        'No packages for your framework version found in this repository, it only contains packages for other framework versions.' =>
            'Hakuna vifurushi kwa ajili ya toleo la mfumo wako uliokutwa katika hifadhi hii, ina vifurushi kwa ajili ya matoleo mengine ya mfumo.',
        'No packages, or no new packages, found in selected repository.' =>
            'Hakuna vifurushi, au hakuna vifurushi vipya, vilivyokutwa katika hifadhi iliyochaguliwa.',
        'Edit the system configuration settings.' => 'Hakiki mipangilio ya usanidishaji wa mfumo. ',
        'ACL information from database is not in sync with the system configuration, please deploy all ACLs.' =>
            'Taarifa za ACL kutoka kwenye kihifadhi data hazilandani na mfumo uliosanidishwa, tafadhali eneza kwneye ACL zote.',
        'printed at' => 'Chapishwa',
        'Loading...' => 'Inapakia...',
        'Dear Mr. %s,' => 'Mpendwa bwana %s,',
        'Dear Mrs. %s,' => 'Mpendwa bibi %s,',
        'Dear %s,' => 'Mpendwa %s,',
        'Hello %s,' => 'Habari %s,',
        'This email address is not allowed to register. Please contact support staff.' =>
            'Anuani ya barua hii pepe hairuhusiwi kusajili. Tafadhali wasiliana na wafanyakazi wa msaada.',
        'New account created. Sent login information to %s. Please check your email.' =>
            'Akaunti mpya imetengenezwa. Taarifa za kuingia zimetumwa kwa %s. Tafadhali angalia barua pepe yako.',
        'Please press Back and try again.' => 'Tafadhali bofya nyuma na jaribu tena.',
        'Sent password reset instructions. Please check your email.' => 'Maelezo ya kuweka upya neno la siri yametumwa. Tafadhali angalia barua pepe yako.',
        'Sent new password to %s. Please check your email.' => 'Neno jipya la siri limetumwa kwa %s. Tafadhali angalia barua pepe yako.',
        'Upcoming Events' => 'Tukio lijalo',
        'Event' => 'Tukio',
        'Events' => 'Matukio',
        'Invalid Token!' => 'Tuzo batili!',
        'more' => 'aidi',
        'Collapse' => 'Kunja',
        'Shown' => 'Onyeshwa',
        'Shown customer users' => 'Onyesha watumiaji wa mteja',
        'News' => 'Habari',
        'Product News' => 'Habari za bidhaa',
        'OTRS News' => 'Habari za OTRS',
        '7 Day Stats' => 'Takwimu za siku 7',
        'Process Management information from database is not in sync with the system configuration, please synchronize all processes.' =>
            'Habari za usimamizi wa mchakato kutoka kwenye hifadhi data hazilandani na  mfumo uliosanidishwa, tafadhali landanisha michakato yote.',
        'Package not verified by the OTRS Group! It is recommended not to use this package.' =>
            'Kifurushi hakijathibitishwa na kikundi cha OTRS! Inapendekezwa kutokutumia kifurushi hiki.',
        '<br>If you continue to install this package, the following issues may occur!<br><br>&nbsp;-Security problems<br>&nbsp;-Stability problems<br>&nbsp;-Performance problems<br><br>Please note that issues that are caused by working with this package are not covered by OTRS service contracts!<br><br>' =>
            '<br> Kama unaendelea kusaniki kifurishi hiki, mambo yafuatayo yanaweza kutokea! <br><br>&nbsp;-usalama
Matatizo<br>&nbsp;-utendaji wa matatizo<br><br> tafadhali kumbuka kwamba mambo yanayosababishwa na kufanya kazi na kifurushi hayajausishwa kwneye makataba wa huduma wa OTRS.',
        'Mark' => 'Alama',
        'Unmark' => 'Toa alama',
        'Bold' => 'Kwa herufi nzito',
        'Italic' => 'Italiki',
        'Underline' => 'Piga mstari',
        'Font Color' => 'Rangi ya mbele',
        'Background Color' => 'Rangi msingi',
        'Remove Formatting' => 'Ondoa uumbizaji',
        'Show/Hide Hidden Elements' => 'Onyesha/Ficha elementi zilifichwa',
        'Align Left' => 'Pangilia kushoto',
        'Align Center' => 'Pangilia katitati',
        'Align Right' => 'Pangilia kulia ',
        'Justify' => 'Sawazisha',
        'Header' => 'Kichwa',
        'Indent' => 'Jongezo',
        'Outdent' => 'Jongezo nje',
        'Create an Unordered List' => 'Tengeneza orodha isiyopangiliwa.',
        'Create an Ordered List' => 'Tengeneza orodha iliyopangiliwa.',
        'HTML Link' => 'Kiungo cha HTML',
        'Insert Image' => 'Ingiza picha',
        'CTRL' => 'CTRL',
        'SHIFT' => 'SHIFT',
        'Undo' => 'Tendua',
        'Redo' => 'Rudia',
        'Scheduler process is registered but might not be running.' => 'Mchakato wa kipanga ratiba umesajiliwa lakini unaweza usifanye kazi. ',
        'Scheduler is not running.' => 'Kipanga ratiba hakifanyi kazi.',
        'All sessions have been killed, except for your own.' => '',
        'Can\'t contact registration server. Please try again later.' => 'Huwezi kuwasiliana na seva ya usajili. Tafadhali jaribu tena baadae.',
        'No content received from registration server. Please try again later.' =>
            'Hakuna maudhui yaliyopokelewa kutoka kwenye seva ya usajili. Tafadhali jaribu tena baadae.',
        'Problems processing server result. Please try again later.' => 'Matatizo katika kushughulikia majibu ya seva.Tafadhali jaribu tena baadae.',
        'Username and password do not match. Please try again.' => 'Jina la mtumiaji na neno la siri haviendani. Tafadhali jaribu tena.',
        'The selected process is invalid!' => 'Mchakato uliochaguliwa ipo batili.',
        'Upgrade to %s now!' => 'Kuboresha na %s sasa!',
        '%s Go to the upgrade center %s' => '%s Nenda kituo cha kuboresha %s',
        'The license for your %s is about to expire. Please make contact with %s to renew your contract!' =>
            'Leseni ya %s inakaribia kuisha. Tafadhali fanya mkataba na %s kufanya upya mkataba.',
        'An update for your %s is available, but there is a conflict with your framework version! Please update your framework first!' =>
            'Usasihswaji wa %s yako upo, lakini kuna mgogoro kati ya toleo la mfumokazi! Tafadhali sasisha mfumokazi wako kwanza!',
        'Your system was successfully upgraded to %s.' => 'Mfumo wako mara kwa mafanikio kuboreshwa kwa %s.',
        'There was a problem during the upgrade to %s.' => 'Kulikuwa na tatizo wakati wa kuboresha na %s.',
        '%s was correctly reinstalled.' => '%s mara usahihi reinstalled.',
        'There was a problem reinstalling %s.' => 'Kulikuwa na tatizo reinstalling %s.',
        'Your %s was successfully updated.' => '%s yako mara kwa mafanikio updated.',
        'There was a problem during the upgrade of %s.' => 'Kulikuwa na tatizo wakati wa kuboresha %s.',
        '%s was correctly uninstalled.' => '%s mara usahihi uninstalled.',
        'There was a problem uninstalling %s.' => 'Kulikuwa na tatizo la kusakinusha %s.',

        # Template: AAACalendar
        'New Year\'s Day' => 'Siku ya mwaka mpya.',
        'International Workers\' Day' => 'Siku ya kimataifa ya wafanyakazi. ',
        'Christmas Eve' => 'Usiku wa kuamkia Krismasi.',
        'First Christmas Day' => 'Siku ya kwanza ya krisimasi.',
        'Second Christmas Day' => 'Siku ya pili ya krisimasi',
        'New Year\'s Eve' => 'Usiku wa kuamkia mwaka mpya.',

        # Template: AAAGenericInterface
        'OTRS as requester' => 'OTRS kama  muombaji',
        'OTRS as provider' => 'OTRS kama mtoaji',
        'Webservice "%s" created!' => 'Huduma ya tovuti \'\'%s\'\' imetengenezwa!',
        'Webservice "%s" updated!' => 'Huduma ya tovuti \'\'%s\'\' imesasishwa!',

        # Template: AAAMonth
        'Jan' => 'Jan',
        'Feb' => 'Feb',
        'Mar' => 'Machi',
        'Apr' => 'Aprili',
        'May' => 'Mei',
        'Jun' => 'Jun',
        'Jul' => 'Julai',
        'Aug' => 'Agosti',
        'Sep' => 'Sep',
        'Oct' => 'Okt',
        'Nov' => 'Nov',
        'Dec' => 'Des',
        'January' => 'Januari',
        'February' => 'Februari',
        'March' => 'Machi',
        'April' => 'Aprili',
        'May_long' => 'Mei',
        'June' => 'Juni',
        'July' => 'Julai',
        'August' => 'Agosti',
        'September' => 'Septemba',
        'October' => 'Oktoba',
        'November' => 'Novemba',
        'December' => 'Desemba',

        # Template: AAAPreferences
        'Preferences updated successfully!' => 'Mapendeleo yamefanikiwa kusasishwa!',
        'User Profile' => 'Maelezo mafupi ya mtumiaji',
        'Email Settings' => 'Mipangilio ya barua pepe',
        'Other Settings' => 'Mipangilio mingine',
        'Change Password' => 'Badili neno la siri',
        'Current password' => 'Neno la siri la sasa',
        'New password' => 'Neno jipya la siri',
        'Verify password' => 'Hakiki neno la siri',
        'Spelling Dictionary' => 'Kamusi ya maneno',
        'Default spelling dictionary' => 'Kamusi chaguo-msingi ya maneno',
        'Max. shown Tickets a page in Overview.' => 'Upeo wa juu wa tiketi zilizoonyeshwa katika ukurasa katika mapitio.',
        'The current password is not correct. Please try again!' => 'Neno la siri la sasa haliko sahihi. Tafadhali jaribu tena!',
        'Can\'t update password, your new passwords do not match. Please try again!' =>
            'Neno la siri haliwezi kusasishwa, neno jipya la siri halilandani. Tafadhali jaribu tena!',
        'Can\'t update password, it contains invalid characters!' => 'Neno la siri haliwezi kusasishwa, lina herufi batili!',
        'Can\'t update password, it must be at least %s characters long!' =>
            'Neno la siri haliwezi kusasishwa, Lazima liwe na japo herufi %s!',
        'Can\'t update password, it must contain at least 2 lowercase and 2 uppercase characters!' =>
            'Neno la siri haliwezi kusasishwa, lazima liwe na japo herufi ndogo 2 na herufi kubwa 2!',
        'Can\'t update password, it must contain at least 1 digit!' => 'Neno la siri haliwezi kusasishwa, lazima liwe na japo tarakimu 1!',
        'Can\'t update password, it must contain at least 2 characters!' =>
            'Neno la siri haliwezi kusasiswha, lazima liwe na japo herufi 2!',
        'Can\'t update password, this password has already been used. Please choose a new one!' =>
            'Neno la siri haliwezi kusasishwa, neno hili la siri limekwisha tumika. Tafadhali chagua jipya!',
        'Select the separator character used in CSV files (stats and searches). If you don\'t select a separator here, the default separator for your language will be used.' =>
            'Chagua kitenganishi cha herufi kilichotumika katika mafaili ya CVS( anza na tafuta). Kama hujakiona kitenganishi hapa, kitenganishi chaguo-msingi cha lugha yako kitatumika.',
        'CSV Separator' => 'Kitenganishi cha CSV ',

        # Template: AAAStats
        'Stat' => 'Takwimu',
        'Sum' => 'Jumla',
        'No (not supported)' => 'Hapana (Haina usaidizi)',
        'Days' => 'Siku',
        'Please fill out the required fields!' => 'Tafadhali jaza sehemu zinazotakiwa!',
        'Please select a file!' => 'Tafadhali chagua faili!',
        'Please select an object!' => 'Tafadhali chagua kipengee',
        'Please select a graph size!' => 'Tafadhali chagua ukubwa wa grafu!',
        'Please select one element for the X-axis!' => 'Tafadhali chagua elementi moja kwa ajili ya jira X!',
        'Please select only one element or turn off the button \'Fixed\' where the select field is marked!' =>
            'Tafadhali chagua elementi moja tu au zima kitufe \'Pachikwa\' ambapo sehemu iliyochaguliwa imewekwa alama!',
        'If you use a checkbox you have to select some attributes of the select field!' =>
            'Kama unatumia kiangalia boksi inabidi uchague sifa ya sehemu iliyochaguliwa!',
        'Please insert a value in the selected input field or turn off the \'Fixed\' checkbox!' =>
            'Tafadhali weka thamani katika sehemu iliyochaguliwa ya kuweka au zima \'Pachikwa\' kionaboksi!',
        'The selected end time is before the start time!' => 'Muda wa kuisha uliochaguliwa ni kabla ya muda wa kuanza!',
        'You have to select one or more attributes from the select field!' =>
            'Unapaswa kuchagua sifa moja au zaidi kutoka kwenye uga uliochaguliwa!',
        'The selected Date isn\'t valid!' => 'Tarehe iliyochaguliwa ni batili!',
        'Please select only one or two elements via the checkbox!' => 'Tafadhali chagua elementi moja au zaidi kupitia kiona boksi!',
        'If you use a time scale element you can only select one element!' =>
            'Kama unatumia elementi ya skeli ya muda unaweza kuchagua elementi moja tu!',
        'You have an error in your time selection!' => 'Una makosa katika uchaguzi wako wa muda! ',
        'Your reporting time interval is too small, please use a larger time scale!' =>
            'Nafasi ya muda wa kuripoti ni mdogo sana, tafadhali tumia skale kubwa zaidi ya muda!',
        'The selected start time is before the allowed start time!' => 'Muda uliochaguliwa wa kuanza ni kabla ya muda wa kuanza ulioruhusiwa!',
        'The selected end time is after the allowed end time!' => 'Muda uliochaguliwa wa kuisha ni baada ya muda wa kuisha ulioruhusiwa!',
        'The selected time period is larger than the allowed time period!' =>
            'Kipindi cha muda kilichochaguliwa ni kikubwa kuliko kipindi cha muda kilichoruhusiwa.',
        'Common Specification' => 'Ubainishaji wa kawaida',
        'X-axis' => 'Jira X',
        'Value Series' => 'Msururu wa thamani',
        'Restrictions' => 'Vizuizi',
        'graph-lines' => 'Grafu-mistari',
        'graph-bars' => 'Grafu-Miambaa',
        'graph-hbars' => 'Grafu-Miambaa h',
        'graph-points' => 'Grafu-points',
        'graph-lines-points' => 'Grafu-Mistari-Pointi',
        'graph-area' => 'Grafu-eneo',
        'graph-pie' => 'Grafu-duara',
        'extended' => 'Imerefushwa',
        'Agent/Owner' => 'Wakala/Mmiliki',
        'Created by Agent/Owner' => 'Wakala/ Mmiliki aliyetengenezwa',
        'Created Priority' => 'Kipaumbele kilichotengenezwa',
        'Created State' => 'Hali iliyotengenezwa',
        'Create Time' => 'Muda wa kutengeneza',
        'CustomerUserLogin' => 'MtejaMtumiajiIngia',
        'Close Time' => 'Muda wa kufunga',
        'TicketAccumulation' => 'Mkusanyiko wa tiketi',
        'Attributes to be printed' => 'Viumbi vitachapishwa',
        'Sort sequence' => 'Panga mfuatano ',
        'Order by' => 'Panga kwa',
        'Limit' => 'Upeo',
        'Ticketlist' => 'Orodha ya tiketi',
        'ascending' => 'Kupanda',
        'descending' => 'Kushuka',
        'First Lock' => 'Funga kwanza',
        'Evaluation by' => 'Tathiminishwa na',
        'Total Time' => 'Jumla ya muda',
        'Ticket Average' => 'Wastani wa tiketi',
        'Ticket Min Time' => 'Kiwango cha chini cha muda ',
        'Ticket Max Time' => 'Kiwango cha juu cha muda',
        'Number of Tickets' => 'Namba ya tiketi',
        'Article Average' => 'Wastani wa makala',
        'Article Min Time' => 'Kiwango cha chini cha muda cha makala',
        'Article Max Time' => 'Kiwango cha juu cha muda cha makala',
        'Number of Articles' => 'Namba ya makala',
        'Accounted time by Agent' => 'Muda una',
        'Ticket/Article Accounted Time' => 'Muda uliohusika wa tiketi/makala',
        'TicketAccountedTime' => 'Muda uliohesabika wa tiketi',
        'Ticket Create Time' => 'Muda wa kutengeneza tiketi',
        'Ticket Close Time' => 'Muda wa kufunga tiketi',

        # Template: AAASupportDataCollector
        'Unknown' => 'Haijulikani',
        'Information' => 'Taarifa',
        'OK' => 'Sawa',
        'Problem' => 'Tatizo',
        'Webserver' => 'Seva ya tovuti',
        'Operating System' => 'Mfumo endeshi',
        'OTRS' => 'OTRS',
        'Table Presence' => 'Uwepo wa meza',
        'Internal Error: Could not open file.' => 'Kosa la ndani: Haikuweza kufungua faili',
        'Table Check' => 'Angalia meza',
        'Internal Error: Could not read file.' => 'Kosa la ndani: Haikuweza kusoma faili.',
        'Tables found which are not present in the database.' => 'Meza zilizopatikana hazipo kwenye hifadhi data',
        'Database Size' => 'Ukubwa wa hifadhi data',
        'Could not determine database size.' => 'haikuweza kutambua ukubwa wa hifadhi data',
        'Database Version' => 'Toleo la hifadhi data',
        'Could not determine database version.' => 'Haikuweza kutambua toleo la hifadhi data',
        'Client Connection Charset' => 'Seti ya herufi ya mahusiano ya mteja',
        'Setting character_set_client needs to be utf8.' => 'Mpangilio character_set_client nahitaji kuwa utf8.',
        'Server Database Charset' => 'Seti ya herufi ya hifadhi data ya seva',
        'Setting character_set_database needs to be UNICODE or UTF8.' => 'Mpangilio character_set_database unahitaji kuwa UNICODE au UTF8.',
        'Table Charset' => 'Seti ya herufi ya jedwali',
        'There were tables found which do not have utf8 as charset.' => 'Kuna majedwali yalipatikana hayana utf8 kana seti ya herufi',
        'InnoDB Log File Size' => '',
        'The setting innodb_log_file_size must be at least 256 MB.' => '',
        'Maximum Query Size' => 'Kiwango cha juu ukubwa wa ulizo',
        'The setting \'max_allowed_packet\' must be higher than 20 MB.' =>
            'Mpangilio \'kiwango cha juu_kinachoruhusiwa_cha paketi\' lazima kiwe kikubwa zaidi ya MB 20',
        'Query Cache Size' => 'Ukubwa wa hifadhi muda wa ulizo',
        'The setting \'query_cache_size\' should be used (higher than 10 MB but not more than 512 MB).' =>
            'Mpangilio \'Ukubwa_wa hifadhi data_wa ulizo\' utumike ( kubwa zaidi ya MB 10 lakini sio zaidi ya MB 512).',
        'Default Storage Engine' => 'Injini Chaguo msingi ya kuhifadhi ',
        'Tables with a different storage engine than the default engine were found.' =>
            'Meza zenye injini ya kuifadhi za tofauti na injini chaguo-msingi zimepatikana.',
        'MySQL 5.x or higher is required.' => 'MySQL 5.x au zaidi inahitajika.',
        'NLS_LANG Setting' => 'Mipangilio ya NLS_LANG ',
        'NLS_LANG must be set to AL32UTF8 (e.g. GERMAN_GERMANY.AL32UTF8).' =>
            'NLS_LANG lazima iwekwe kuwa AL2UTF8 (Mfano GERMAN_GERMANY.AL32UTF8).',
        'NLS_DATE_FORMAT Setting' => 'Mpangilio wa NLS_DATE_FORMAT',
        'NLS_DATE_FORMAT must be set to \'YYYY-MM-DD HH24:MI:SS\'.' => 'NLS_DATE_FORMAT lazima iwekwe kuwa \'YYYY-MM-DD HH24:MI:SS\'.',
        'NLS_DATE_FORMAT Setting SQL Check' => 'Mpangilio wa NLS_DATE_FORMAT angalio la SQL',
        'Setting client_encoding needs to be UNICODE or UTF8.' => 'Mpangilio client_encoding unahitaji kuwa UNICODE au UTF8',
        'Setting server_encoding needs to be UNICODE or UTF8.' => 'Mpangilio server_encoding unahitaji kuwa UNICODE au UTF8.',
        'Date Format' => 'Mpangilio wa tarehe',
        'Setting DateStyle needs to be ISO.' => 'Mpangilio DateStyle unahitaji kuwa ISO.',
        'PostgreSQL 8.x or higher is required.' => 'PostgreSQL 8.x au zaidi inahitajika.',
        'OTRS Disk Partition' => 'Kitenga diski cha OTRS',
        'Disk Usage' => 'Matimizi ya diski',
        'The partition where OTRS is located is almost full.' => 'Kitenga ambacho OTRS imewekwa kinakaribia kujaa',
        'The partition where OTRS is located has no disk space problems.' =>
            'Kitenga ambacho OTRS imewekwa kina matatizo ya nafasi katika disk.',
        'Disk Partitions Usage' => 'Matumizi ya vitenga diski',
        'Distribution' => 'Usambazaji',
        'Could not determine distribution.' => 'Haikuweza kutambua usambazaji.',
        'Kernel Version' => 'Toleo la kiini',
        'Could not determine kernel version.' => 'Haikuweza kutambua aina ya kiini.',
        'System Load' => 'Pakia mfumo',
        'The system load should be at maximum the number of CPUs the system has (e.g. a load of 8 or less on a system with 8 CPUs is OK).' =>
            'Kupakia mfumo unatakiwa kuwa na upeo wa juu wa namba za CPU ambazo mfumo unazo ( mfano. Mzigo wa 8 au chini ya mfumo kwa CPU nane ni sawa).',
        'Perl Modules' => 'Moduli za Perl',
        'Not all required Perl modules are correctly installed.' => 'Sio kila moduli za perl zinesanidiwa kwa usahihi.',
        'Perl Version' => 'Toleo la perl',
        'Free Swap Space (%)' => 'Nafasi ya kubadilishana ya bure (%)',
        'No Swap Enabled.' => 'Kubadilishana hakujawezeshwa.',
        'Used Swap Space (MB)' => 'Nafasi ya kubadilishana iliyotumika(MB)',
        'There should be more than 60% free swap space.' => 'Lazima kuna nafasi ya kubadilisha ya bure zaidi ya 60%.',
        'There should be no more than 200 MB swap space used.' => 'Hakuna zaidi ya MB 200 ya nafasi ilitumika ya kubadilishana.',
        'Config Settings' => 'Mipangilio ya kusanidi',
        'Could not determine value.' => 'Haikuweza kutambua thamani',
        'Database Records' => 'Rekodi ya hifadhi data',
        'Tickets' => 'Tiketi',
        'Ticket History Entries' => 'Historia ya ingizo ya tiketi',
        'Articles' => 'Makala',
        'Attachments (DB, Without HTML)' => 'Viambatanisho (DB, bila ya HTML)',
        'Customers With At Least One Ticket' => 'Wateja wenye tiketi angalau zaidi ya moja',
        'Queues' => 'Foleni',
        'Agents' => 'Mawakala',
        'Roles' => 'Majukumu',
        'Groups' => 'Makundi',
        'Dynamic Fields' => 'Uga wenye nguvu',
        'Dynamic Field Values' => 'Thamani za uga zenye  nguvu',
        'Invalid Dynamic Fields' => 'Uga zenye nguvu batili',
        'Invalid Dynamic Field Values' => 'Thamani za uga wenye nguvu batili',
        'GenericInterface Webservices' => 'Huduma za wavuti za kiolesura cha jumla.',
        'Processes' => 'Michakato',
        'Months Between First And Last Ticket' => 'Miezi kati ya tiketi ya kwanza na ya mwisho',
        'Tickets Per Month (avg)' => 'Tiketi za kila mwezi (wastani)',
        'Default SOAP Username and Password' => 'Jina la mtumiaji na neno la siri la SOAP chaguo-msingi ',
        'Security risk: you use the default setting for SOAP::User and SOAP::Password. Please change it.' =>
            'Hatari ya usalama: Tumia mipangilio chaguo-msingi kwa SOAP:: Mtumiaji na SOAP::Neno la siri. Tafadhali badilisha.',
        'Default Admin Password' => 'Neno la siri chaguo-msingi la kiongozi',
        'Security risk: the agent account root@localhost still has the default password. Please change it or invalidate the account.' =>
            'Hatari y a usalama: Akaunti ya wakala root@locolhost bado lina neno la siri chaguo-msingi.Tafadhali libadilishe au batilisha akaunti.',
        'Error Log' => 'Kosa la kuingia',
        'There are error reports in your system log.' => 'Kuna repoti za makosa katika mfumo wako wa kuingia',
        'File System Writable' => 'Mfumo wa file unaandikika',
        'The file system on your OTRS partition is not writable.' => 'Mfumo wa file katika kitenga chako cha OTRS  hakiandikiki.',
        'Domain Name' => 'Jina la kikoa',
        'Your FQDN setting is invalid.' => 'Mipangilio yako ya FQDN ni batili.',
        'Package installation status' => 'Hali ya usanikishwaji wa kifurushi',
        'Some packages are not correctly installed.' => 'kuna vifurishi havijasanikishwa kwa usahihi.',
        'Package List' => 'Orodha ya vifurushi',
        'SystemID' => 'Kitambulisho cha Mfumo',
        'Your SystemID setting is invalid, it should only contain digits.' =>
            'Mipangilio ya kitambulisho chako cha mfumo ni batili, lazima iwe na namba tu.',
        'OTRS Version' => 'Toleo la OTRS',
        'Ticket Index Module' => 'Moduli ya kielezo cha tiketi',
        'You have more than 60,000 tickets and should use the StaticDB backend. See admin manual (Performance Tuning) for more information.' =>
            'Una zaidi ya tiketi 60,000 na mandharinyuma DBtuli. Angalia manyo ya kiongozi (kuboresha utendaji) kwa taarifa zaidi.',
        'Open Tickets' => 'Tiketi zilizo wazi',
        'You should not have more than 8,000 open tickets in your system.' =>
            'Usiwe na tiketi zilizowazi zaidi ya 8000 katika mfumo wako.',
        'Ticket Search Index module' => 'Moduli ya kutafuta kielezo cha tiketi',
        'You have more than 50,000 articles and should use the StaticDB backend. See admin manual (Performance Tuning) for more information.' =>
            'Una zaidi ya makala 50,000 na unapaswa kutumia mandharinyuma DB tuli.Angalia Manyo ya kiongozi (kuboresha utendaji) kwa taarifa zaidi.',
        'Orphaned Records In ticket_lock_index Table' => 'Rekodi zilizoachwa katika jedwali la Kielezo_Cha kufunga_Tiketi',
        'Table ticket_lock_index contains orphaned records. Please run otrs/bin/otrs.CleanTicketIndex.pl to clean the StaticDB index.' =>
            'Jedwali la Kielezo cha_kufunga_Tiketi lina rekodi zilizoachwa. Tafadhali fanya otrs/bin/otrs.CleanTicketIndex.pl kusafisha kielezo cha DBTuli.',
        'Orphaned Records In ticket_index Table' => 'Rekodi zilizoachwa katika jedwali la Kielezo_cha Tiketi.',
        'Table ticket_index contains orphaned records. Please run otrs/bin/otrs.CleanTicketIndex.pl to clean the StaticDB index.' =>
            'Jedwali la Kielezo cha_Tiketi lina rekodi zilizoachwa. Tafadhali fanya otrs/bin/otrs.CleanTicketIndex.pl kusafisha kielezo cha DBTuli.',
        'Environment Variables' => 'Vishika nafsi vya mazingira',
        'Webserver Version' => 'Toleo la tovuti',
        'Could not determine webserver version.' => 'Haikuweza kutambua toleo la seva ya tovuti.',
        'Loaded Apache Modules' => 'Moduli za Apache zilizopakiwa',
        'CGI Accelerator Usage' => 'Matumizi ya kichocheo cha CGI',
        'You should use FastCGI or mod_perl to increase your performance.' =>
            'Tumia FastCGI au mod_perl kuongeza uwezo wako.',
        'mod_deflate Usage' => 'Matumizi ya mod_deflate',
        'Please install mod_deflate to improve GUI speed.' => 'Tafadhali sanidi mod_deflate kuboresha kasi ya GUI.',
        'mod_filter Usage' => '',
        'Please install mod_filter if mod_deflate is used.' => '',
        'mod_headers Usage' => 'Matumizi ya mod_headers',
        'Please install mod_headers to improve GUI speed.' => 'Tafadhali sanidi mod_deflate kuboresha kasi ya GUI.',
        'Apache::Reload Usage' => 'Apache::Pakia matumizi',
        'Apache::Reload or Apache2::Reload should be used as PerlModule and PerlInitHandler to prevent web server restarts when installing and upgrading modules.' =>
            'Apache:: Onesha upya au Apache 2:: Onesha upya itumike kama Moduli ya Perl na Per ya kuanzisha ya Kishiko kuzuia seva ya tovuti kuanza upya wakati wa usanidi na uboreshaji wa moduli.',
        'Apache::DBI Usage' => 'Apache::Matumizi ya DBI',
        'Apache::DBI should be used to get a better performance  with pre-established database connections.' =>
            'Apache:: DBI itumike kupata utendaji mzuri na miunganisho ya hifadhi data iliyoanzishwa.',
        'You should use PerlEx to increase your performance.' => 'Tumia PerlEx kuongeza utendaji wako.',

        # Template: AAATicket
        'Status View' => 'Angalia hali',
        'Service View' => '',
        'Bulk' => 'Kwa wingi',
        'Lock' => 'funga',
        'Unlock' => 'fungua',
        'History' => 'historia',
        'Zoom' => 'Kuza',
        'Age' => 'Umri',
        'Bounce' => 'Dunda',
        'Forward' => 'Mbele',
        'From' => 'Kutoka',
        'To' => 'Kwenda',
        'Cc' => 'Kupitia kwa',
        'Bcc' => 'Bcc',
        'Subject' => 'Somo',
        'Move' => 'Sogea',
        'Queue' => 'Foleni',
        'Priority' => 'Kipaumbele',
        'Priorities' => 'Vipaumbele',
        'Priority Update' => 'Usasishwaji wa kipaumbele',
        'Priority added!' => 'Kipaumbele kimeongezwa!',
        'Priority updated!' => 'Kipaumbele kimesasishwa!',
        'Signature added!' => 'Saini imeongezwa',
        'Signature updated!' => 'Saini imeisasishwa!',
        'SLA' => 'MKH',
        'Service Level Agreement' => 'Kubaliano ya kivango cha huduma',
        'Service Level Agreements' => 'Makubaliano ya kiwango cha huduma',
        'Service' => 'Huduma',
        'Services' => 'Huduma',
        'State' => 'Hali',
        'States' => 'Hali',
        'Status' => 'Hali/hadhi',
        'Statuses' => 'Hali/hadhi',
        'Ticket Type' => 'Aina ya tiketi',
        'Ticket Types' => 'Aina za tiketi',
        'Compose' => 'Tunga',
        'Pending' => 'Inasubiri',
        'Owner' => 'Mmiliki',
        'Owner Update' => 'Usasishwaji wa mmiliki',
        'Responsible' => 'Husika',
        'Responsible Update' => 'Usasishwaji unaohusika',
        'Sender' => 'Mtumaji',
        'Article' => 'Makala',
        'Ticket' => 'Tiketi',
        'Createtime' => 'Muda wa kutengeneza',
        'plain' => 'Ghafi',
        'Email' => 'Barua pepe',
        'email' => 'barua pepe',
        'Close' => 'Funga',
        'Action' => 'Kitendo',
        'Attachment' => 'Kiambatanishi',
        'Attachments' => 'Viambatanishi',
        'This message was written in a character set other than your own.' =>
            'Ujumbe huu wa maneno uliandikwa kwa mpangilio wa herufi ambao sio wako.',
        'If it is not displayed correctly,' => 'Kama haijaonyeshwa kw ausahihi,',
        'This is a' => 'Hii ni',
        'to open it in a new window.' => 'Kuifungua kwenye window nyingine',
        'This is a HTML email. Click here to show it.' => 'Hii ni barua pepe ya HTML.Bofya hapa kuionyesha.',
        'Free Fields' => 'Uga huru',
        'Merge' => 'Ibuka',
        'merged' => 'liibuka',
        'closed successful' => 'Ilifungwa kwa mafanikio',
        'closed unsuccessful' => 'Ilifungwa bila mafanikio',
        'Locked Tickets Total' => 'Jumla ya tiketi zilizofungwa',
        'Locked Tickets Reminder Reached' => 'Ukumbusho wa tiketi zilizofungwa umefika',
        'Locked Tickets New' => 'Funga tiketi mpya',
        'Responsible Tickets Total' => 'Jumla ya tiketi zinazowajibika',
        'Responsible Tickets New' => 'Tiketi mpya zinazowajibika',
        'Responsible Tickets Reminder Reached' => 'Ukumbusho wa tiketi zinazowajibika umefika',
        'Watched Tickets Total' => 'Jumla ya tiketi zinazoangaliwa',
        'Watched Tickets New' => 'Mpya ya tiketi zinazoangaliwa',
        'Watched Tickets Reminder Reached' => 'Ukumbusho wa tiketi zinazoangaliwa umefika',
        'All tickets' => 'Tiketi zote',
        'Available tickets' => 'Tiketi zinazopatikana',
        'Escalation' => 'Kupanda',
        'last-search' => 'Utafutaji wa mwisho',
        'QueueView' => 'Angalia foleni',
        'Ticket Escalation View' => 'Mandhari ya kupanda ya tiketi',
        'Message from' => 'Ujumbe wa maneno kutoka',
        'End message' => 'Mwisho wa Ujumbe wa maneno',
        'Forwarded message from' => 'Peleka ujumbe wa maneno kutoka ',
        'End forwarded message' => 'Malizia ujumbe wa maneno uliotumwa',
        'Bounce Article to a different mail address' => 'Peleka makala kwenye anuani ya ujumbe nyingine',
        'Reply to note' => '',
        'new' => 'mpya',
        'open' => 'fungua',
        'Open' => 'Fungua',
        'Open tickets' => 'Fungua tketi',
        'closed' => 'fungwa',
        'Closed' => 'Fungwa',
        'Closed tickets' => 'Tiketi zilizofungwa',
        'removed' => 'ondolewa',
        'pending reminder' => 'Ukumbusho unaosuburia',
        'pending auto' => 'Inasubiri kiautomatikali',
        'pending auto close+' => 'Inasubiri kiautomatikali Kufunga',
        'pending auto close-' => 'Funga otomatiki inasubiri-',
        'email-external' => 'barua pepe-nje',
        'email-internal' => 'barua pepe-ndani',
        'note-external' => 'kidokezo-nje',
        'note-internal' => 'kidokezo-ndani',
        'note-report' => 'kidokezo-ripoti',
        'phone' => 'simu',
        'sms' => 'ujumbe mfupi',
        'webrequest' => 'ombi la tovuti',
        'lock' => 'funga',
        'unlock' => 'fungua',
        'very low' => 'Kiwango cha chini sana',
        'low' => 'kiwango cha chini',
        'normal' => 'Kiwango cha kawaida',
        'high' => 'kiwango cha juu',
        'very high' => 'kiwango cha juu sana',
        '1 very low' => '1 chini sana',
        '2 low' => '2 chini',
        '3 normal' => '3 kawaida',
        '4 high' => '4 juu',
        '5 very high' => '5 juu sana',
        'auto follow up' => 'Kufuatilia otomatiki',
        'auto reject' => 'Kukataa otomatiki',
        'auto remove' => 'Ondoa otomatiki',
        'auto reply' => 'Jibu otomatiki',
        'auto reply/new ticket' => 'Jibu otomatiki/ tiketi mpya',
        'Create' => 'Tengeneza',
        'Answer' => 'jibu',
        'Phone call' => 'Simu',
        'Ticket "%s" created!' => 'Tiketi "%s" zimetengenezwa!',
        'Ticket Number' => 'Namba ya tiketi',
        'Ticket Object' => 'Kipengele cha tiketi',
        'No such Ticket Number "%s"! Can\'t link it!' => 'Hakuna namba ya tiketi kama hii "%s"! Haiwezi kuunganisha nacho.',
        'You don\'t have write access to this ticket.' => 'Hauna uwezo wa kuandika katika tiketi hii',
        'Sorry, you need to be the ticket owner to perform this action.' =>
            'Samahani, unahitaji kuwa mmiliki wa tiketi kufanya kitendo hiki.',
        'Please change the owner first.' => 'Tafadhali badilisha mmiliki kwanza.',
        'Ticket selected.' => 'Tiketi imechaguliwa',
        'Ticket is locked by another agent.' => 'Tiketi imefungwa na wakala mwingine.',
        'Ticket locked.' => 'Tiketi imefungwa',
        'Don\'t show closed Tickets' => 'Usionyeshe tiketi zilizofungwa',
        'Show closed Tickets' => 'Onyesha tiketi zilizofungwa',
        'New Article' => 'Makala mpya',
        'Unread article(s) available' => 'Makala ambayo hayajasomwa yanapatikana',
        'Remove from list of watched tickets' => 'Ondoa kwenye orodha ya tiketi zilizoangaliwa',
        'Add to list of watched tickets' => 'Ongeza kwenye orodha ya tiketi zilizoangaliwa',
        'Email-Ticket' => 'Barua pepe-Tiketi',
        'Create new Email Ticket' => 'Tengeneza tiketi ya barua pepe mpya',
        'Phone-Ticket' => 'Simu-Tiketi',
        'Search Tickets' => 'Tafuta tiketi',
        'Customer Realname' => '',
        'Customer History' => '',
        'Edit Customer Users' => 'Badili watuamiaji wa mteja',
        'Edit Customer' => 'Badili mteja',
        'Bulk Action' => 'Tendo la wingi',
        'Bulk Actions on Tickets' => 'Matendo ya wingi katika tiketi',
        'Send Email and create a new Ticket' => 'Tuma barua pepe na tengeneza tiketi mpya',
        'Create new Email Ticket and send this out (Outbound)' => 'Tengeneza tiketi mpya za barua pepe na uzitume (Nje)',
        'Create new Phone Ticket (Inbound)' => 'Tengeneza tiketi mpya za simu (Ndani)',
        'Address %s replaced with registered customer address.' => 'Anuani %s imebadilishwa na anuani ya mteja iliyosajiliwa',
        'Customer user automatically added in Cc.' => 'Mtumiaji wa mteja anaongezwa automatiki kwenye Cc.',
        'Overview of all open Tickets' => 'Mapitio ya tiketi zote zilizowazi',
        'Locked Tickets' => 'Tiketi zilizofungwa',
        'My Locked Tickets' => 'Tiketi zangu zilizofungwa',
        'My Watched Tickets' => 'Tiketi zangu zilizoangaliwa',
        'My Responsible Tickets' => 'Tiketi zangu zinazowajibika',
        'Watched Tickets' => 'Tiketi zilizoangaliwa',
        'Watched' => 'Angaliwa',
        'Watch' => 'Angalia',
        'Unwatch' => 'Usiangalie',
        'Lock it to work on it' => 'Ifunge ufanyenayo kazi',
        'Unlock to give it back to the queue' => 'Fungua kuirudisha kwenye foleni',
        'Show the ticket history' => 'Onyesha historia ya tiketi',
        'Print this ticket' => 'Chapa tiketi hii',
        'Print this article' => 'Chapa makala hii',
        'Split' => 'Gawanya',
        'Split this article' => 'Gawanya makala hii',
        'Forward article via mail' => 'Peleka makala hii kwa barua pepe',
        'Change the ticket priority' => 'Badili kipaumbele cha tiketi',
        'Change the ticket free fields!' => 'Badilii uga huru wa tiketi',
        'Link this ticket to other objects' => 'Unganisha tiketi na vipengele vingine',
        'Change the owner for this ticket' => 'Badili mmiliki wa tiketi hii',
        'Change the  customer for this ticket' => 'Badili wakala wa kwa tiketi hii',
        'Add a note to this ticket' => 'Ongeza kidokezo katika tiketi hii',
        'Merge into a different ticket' => 'Unganisha katika tiketi nyingine',
        'Set this ticket to pending' => 'Weka tiketi hii isubiri',
        'Close this ticket' => 'Funga tiketi hii',
        'Look into a ticket!' => 'Fungia kwenye tiketi',
        'Delete this ticket' => 'Futa tiketi hii.',
        'Mark as Spam!' => 'Weka alama kama barua taka',
        'My Queues' => 'Foleni zangu',
        'Shown Tickets' => 'Onyesha tiketi',
        'Shown Columns' => 'Safuwima zilizoonyeshwa',
        'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' =>
            'Barua pepe yako yenye tiketi namba "<OTRS_TIKETI>" imeunganishwa na "<OTRS_UNGA_KWENYE_TIKETI>".',
        'Ticket %s: first response time is over (%s)!' => 'Tiketi %s:muda wa majibu ya kwanza umeisha (%s)!',
        'Ticket %s: first response time will be over in %s!' => 'Tiketi %s:muda wa majibu ya kwanza utaisha ndani ya %s!',
        'Ticket %s: update time is over (%s)!' => 'Tiketi %s:muda wa usasishwaji umeisha (%s)!',
        'Ticket %s: update time will be over in %s!' => 'Tiketi %s:muda wa usasishwaji utaisha ndani ya %s!',
        'Ticket %s: solution time is over (%s)!' => 'Tiketi %s:muda wa ufumbuzu umeisha (%s)!',
        'Ticket %s: solution time will be over in %s!' => 'Tiketi %s:muda wa ufumbuzi utaisha ndani ya %s!',
        'There are more escalated tickets!' => 'Kuna tiketi zaidi zinazopanda! ',
        'Plain Format' => 'Umbizo la wazi',
        'Reply All' => 'Jibu wote',
        'Direction' => 'Muelekeo',
        'Agent (All with write permissions)' => 'Wakala (Wote wenye kibali cha kuandika)',
        'Agent (Owner)' => 'Wakala(Mmiliki)',
        'Agent (Responsible)' => 'Wakala (Mhusika)',
        'New ticket notification' => 'Taarifa kuhusu tiketi mpya',
        'Send me a notification if there is a new ticket in "My Queues".' =>
            'Nitumie taarifa kama kuna tiketi mpya katika "foleni yangu".',
        'Send new ticket notifications' => 'Nitumie taarifa za tiketi mpya',
        'Ticket follow up notification' => 'Taarifa ya kufatilia tiketi',
        'Send me a notification if a customer sends a follow up and I\'m the owner of the ticket or the ticket is unlocked and is in one of my subscribed queues.' =>
            'Nitumie taarifa kama mteja akituma kufuatilia na mimi ni mmiliki wa tiketi au tiketi zimefunguliwa na ni moja ya foleni zangu za kujiunga',
        'Send ticket follow up notifications' => 'Tuma taarifa za ufuatiliaji za tiketi',
        'Ticket lock timeout notification' => 'Taarifa ya muda wa kuisha wa kufunga tiketi',
        'Send me a notification if a ticket is unlocked by the system.' =>
            'Nitumie taarifa kama tiketi imetolewa kutoka kwenye moja ya "Foleni zangu".',
        'Send ticket lock timeout notifications' => 'Tuma taarifa za kuisha kwa muda wa kufunga tiketi',
        'Ticket move notification' => 'Taarifa ya kuhamisha tiketi',
        'Send me a notification if a ticket is moved into one of "My Queues".' =>
            'Nitumie taarifa kama tiketi imehamishwa kwenye moja ya ""Foleni zangu".',
        'Send ticket move notifications' => 'Tuma taarifa za kuhamisha tiketi',
        'Your queue selection of your favourite queues. You also get notified about those queues via email if enabled.' =>
            'Chaguo lako la foleni kwa foleni unazozopenda. Pia utapata kutaarifiwa kuhusu hizo foleni kwa barua pepe kama imewezeshwa.',
        'Custom Queue' => 'Foleni maalum',
        'QueueView refresh time' => 'Muda wa kufanya upya wa muonekano wa foleni',
        'If enabled, the QueueView will automatically refresh after the specified time.' =>
            'Kama imewezeshwa, muonekano wa foleni utafanywa mpya automaiki baada ya muda maalum.',
        'Refresh QueueView after' => 'Fanya mandhari ya foleni kuonekana mpya baada ya',
        'Screen after new ticket' => 'Skrini baada ya tiketi mpya',
        'Show this screen after I created a new ticket' => 'Onyesha hii skrini baada ya kutengeneza tiketi mpya',
        'Closed Tickets' => 'Tiketi zilizofungwa',
        'Show closed tickets.' => 'Onyesha tiketi zilizofungwa',
        'Max. shown Tickets a page in QueueView.' => 'Upeo wa juu wa tiketi zilizoonyeshwa katika ukurasa katika mandhari ya foleni.',
        'Ticket Overview "Small" Limit' => 'Kikomo cha mapitio ya tiketi \'\'Ndogo\'\' ',
        'Ticket limit per page for Ticket Overview "Small"' => 'Kikomo cha tiketi kwa ukurasa kwa mapitio ya tiketi \'\'Ndogo"',
        'Ticket Overview "Medium" Limit' => 'Kikomo cha mapitio ya tiketi \'\'Wastani\'\' ',
        'Ticket limit per page for Ticket Overview "Medium"' => 'Kikomo cha tiketi kwa ukurasa kwa mapitio ya tiketi \'\'Wastani"',
        'Ticket Overview "Preview" Limit' => 'Kikomo cha mapitio ya tiketi \'\'Kihakiki\' ',
        'Ticket limit per page for Ticket Overview "Preview"' => 'Kikomo cha tiketi kwa ukurasa kwa mapitio ya tiketi \'\'kihakiki"',
        'Ticket watch notification' => 'Taarifa za kutazama za tiketi',
        'Send me the same notifications for my watched tickets that the ticket owners will get.' =>
            'Nitumie taarifa zilezile za tiketi zangu zinazoangaliwa ambazo wamiliki wa tiketi watapata. ',
        'Send ticket watch notifications' => 'Tuma taarifa za tiketi zinazoangaliwa ',
        'Out Of Office Time' => 'Muda wa muda kuisha',
        'New Ticket' => 'Tiketi mpya',
        'Create new Ticket' => 'Tengeneza tiketi mpya',
        'Customer called' => 'Mteja kapiga simu',
        'phone call' => 'Simu',
        'Phone Call Outbound' => 'Simu iliyofungwa nje',
        'Phone Call Inbound' => 'Simu inayofungwa ndani',
        'Reminder Reached' => 'Kikumbusho kimefika',
        'Reminder Tickets' => 'Tiketi za kikumbuhso',
        'Escalated Tickets' => 'Tiketi zilizopanda',
        'New Tickets' => 'Tiketi mpya',
        'Open Tickets / Need to be answered' => 'Tiketi zilizowazi/ Zinazohitaji kujibiwa',
        'All open tickets, these tickets have already been worked on, but need a response' =>
            'Tiketi zote zilizowazi, hizi tiketi zimeshafanyiwa kazi, lakini zinahitaji majibu.',
        'All new tickets, these tickets have not been worked on yet' => 'Tiketi zote mpya, hizi tiketi hazijafanyiwa kazi bado',
        'All escalated tickets' => 'Tiketi zote zilizopanda',
        'All tickets with a reminder set where the reminder date has been reached' =>
            'Tiketi zote zilizowekewa kikumbusho ambazo siku ya kikumbusho hakijafika',
        'Archived tickets' => 'Tiketi zilizohifadhiwa',
        'Unarchived tickets' => 'Tiketi ambazo hazijahifadhiwa',
        'Ticket Information' => 'Taarifa za tiketi',

        # Template: AAAWeekDay
        'Sun' => 'Jumapili',
        'Mon' => 'Jumatatu',
        'Tue' => 'Jumanne',
        'Wed' => 'Jumatano',
        'Thu' => 'Alhamisi',
        'Fri' => 'Ijumaa',
        'Sat' => 'Jumamosi',

        # Template: AdminACL
        'ACL Management' => 'Usimamizi wa ACL ',
        'Filter for ACLs' => 'Chuja kwa ajili ya ACL',
        'Filter' => 'Chuja',
        'ACL Name' => 'Jina la ACL',
        'Actions' => 'Matendo',
        'Create New ACL' => 'Tengeneza ACL mpya',
        'Deploy ACLs' => 'Tumia ACL',
        'Export ACLs' => 'Hamisha ACL',
        'Configuration import' => 'Ingiza usanidi',
        'Here you can upload a configuration file to import ACLs to your system. The file needs to be in .yml format as exported by the ACL editor module.' =>
            'Hapa unaweza kupakia faili la usanidi ili kuingiza ACL katika mfumo wako. Faili linahitaji kuwa katika umbizo la .yml kama itakavyohamishwa na moduli ya kuhariri ya ACL.',
        'This field is required.' => 'Hili faili linahitajika',
        'Overwrite existing ACLs?' => 'Anduka juu ya ACLS zilizokuwepo?',
        'Upload ACL configuration' => 'Pakia usanidi wa ACL',
        'Import ACL configuration(s)' => 'Leta usanidi wa ACL',
        'To create a new ACL you can either import ACLs which were exported from another system or create a complete new one.' =>
            'Kutengeneza ACL mpya unaweza kuleta ACL ambazo zimehamishwa kutoka kwenye mfumo mwingine au tengeneza mpya iliyokamilika.',
        'Changes to the ACLs here only affect the behavior of the system, if you deploy the ACL data afterwards. By deploying the ACL data, the newly made changes will be written to the configuration.' =>
            'Mabadiliko katika ACL hapa yanaathiri tabia ya mfumo, kama Unatumia data za ACL baadae. Kwa kutumia data za ACL, mabadiliko mapya yaliyofanywa yataandikwa kwneye usanidi.',
        'ACLs' => 'ACL',
        'Please note: This table represents the execution order of the ACLs. If you need to change the order in which ACLs are executed, please change the names of the affected ACLs.' =>
            'Tafadhali zingatia: jedwali hili linawakilisha mpangilio wa utekelezaji wa ACL. Kama unahitaji kubadilisha mpangilio ambao ACL unatekelezwa, tafadhali badilisha majina ya ACL yaliyoathiwa.',
        'ACL name' => 'Jina la ACL',
        'Validity' => 'Uhahali',
        'Copy' => 'Nakili',
        'No data found.' => 'Hakuna data zilizopatikana',

        # Template: AdminACLEdit
        'Edit ACL %s' => 'Hariri ACL %s',
        'Go to overview' => 'Nenda kwenye mapitio',
        'Delete ACL' => 'Futa ACL',
        'Delete Invalid ACL' => 'Futa ACL ambazo ni halali',
        'Match settings' => 'Mipangilio ya kufanana',
        'Set up matching criteria for this ACL. Use \'Properties\' to match the current screen or \'PropertiesDatabase\' to match attributes of the current ticket that are in the database.' =>
            'Weka vigezo kwa hii ACL.Tumia \'Sifa\' kufananisha na skrini ya sasa au \'Hifadhidaya ya Sifa\' kufananisha viumbi vya sasa vya tiketi ambavyo vipo kwenye hiadhidata.',
        'Change settings' => 'Badili Mipangilio',
        'Set up what you want to change if the criteria match. Keep in mind that \'Possible\' is a white list, \'PossibleNot\' a black list.' =>
            'Weka unachotaka kubadillisha kama vigezo vinafanana. Weka akilini kwamba \'Wezekana\' ni orodha nyeupe, \'Haiwezekani\' ni orodha nyeusi.',
        'Check the official' => 'Angalia rasmi',
        'documentation' => 'Weka nyaraka',
        'Show or hide the content' => 'Onyesha maudhui',
        'Edit ACL information' => 'Hariri taarifa za ACL',
        'Stop after match' => 'Simama baada ya kufanana',
        'Edit ACL structure' => 'Hariri muundo wa ACL',
        'Save' => 'Hifadhi',
        'or' => 'Au',
        'Save and finish' => 'Hifadhi na maliza',
        'Do you really want to delete this ACL?' => 'Je unahitaji kufuta ACL hii?',
        'This item still contains sub items. Are you sure you want to remove this item including its sub items?' =>
            'Hiki kipengee bado kina vipengee vidogo. Je unataka kuondoa kipengee hiki na vipengee vidogo',
        'An item with this name is already present.' => 'Kipengee kwa jina hili tayari kimeshaonyeshwa',
        'Add all' => 'Ongeza zote',
        'There was an error reading the ACL data.' => 'Kulikuwa na hitilafu inasoma data za ACL',

        # Template: AdminACLNew
        'Create a new ACL by submitting the form data. After creating the ACL, you will be able to add configuration items in edit mode.' =>
            'Tengeneza ACL mpya kwa kukusanya data. Baada ya kutengeneza ACL, utakuwa na uwezo wa kuongeza kipengee cha usanidi katika  ',

        # Template: AdminAttachment
        'Attachment Management' => 'Usimamizi wa kiambatisho',
        'Add attachment' => 'Ongeza kiambatisho',
        'List' => 'Orodha',
        'Download file' => 'Pakua faili',
        'Delete this attachment' => 'Futa kiambatanisho',
        'Add Attachment' => 'Ongeza kiambatanisho',
        'Edit Attachment' => 'Hariri kiambatisho',

        # Template: AdminAutoResponse
        'Auto Response Management' => 'Usimamizi wa majibu wa kiautomatiki',
        'Add auto response' => 'Ongeza majibu ya kiautomatiki',
        'Add Auto Response' => 'Ongeza Majibu ya Kiautomatiki',
        'Edit Auto Response' => 'Hariri Majibu ya Kiautomatiki',
        'Response' => 'Majibu',
        'Auto response from' => 'Majibu automatiki kutoka',
        'Reference' => 'Marejeo',
        'You can use the following tags' => 'Unaweza kutumia lebo zifuatazo',
        'To get the first 20 character of the subject.' => 'Kupata herufi 20 za kwanza za somo',
        'To get the first 5 lines of the email.' => 'Kupata mistari 5 ya kwanza ya barua pepe.',
        'To get the realname of the sender (if given).' => 'Kupata jina halisi la mtumaji ( kama limetolewa)',
        'To get the article attribute' => 'Kupata sifa za makala',
        ' e. g.' => 'Mfano',
        'Options of the current customer user data' => 'Chaguo la data za mtumiaji za mteja wa sasa',
        'Ticket owner options' => 'Chaguo la mmiliki wa tiketi',
        'Ticket responsible options' => 'Michaguo ya tiketi husika',
        'Options of the current user who requested this action' => 'Michaguo ya mtumiaji wa sasa ambae ameomba tendo hili.',
        'Options of the ticket data' => 'Chaguo la data ya tiketi',
        'Options of ticket dynamic fields internal key values' => 'Chaguo la thamani za muhimu za ndani za uga wenye nguvu wa tiketi.',
        'Options of ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            'Chaguo la thamani za za uga wenye nguvu wa kuonyesa wa tiketi, inatumika katika uga wa Kuangushachini na Chaguowingi.',
        'Config options' => 'Mchaguo wa usanidi',
        'Example response' => 'Majibu ya mfano',

        # Template: AdminCustomerCompany
        'Customer Management' => 'Usimamizi wa mteja.',
        'Wildcards like \'*\' are allowed.' => 'Wildkadi kama \'*\' zinaruhusiwa.',
        'Add customer' => 'Ongeza mteja',
        'Select' => 'chagua',
        'Please enter a search term to look for customers.' => 'Tafadhali ingiza neno la utafutaji kuwatafuta wateja.',
        'Add Customer' => 'Ongeza wateja',

        # Template: AdminCustomerUser
        'Customer User Management' => 'Usimamizi wa mtumiaji wa mteja',
        'Back to search results' => 'Rudi kwenye majibu ya utafutaji',
        'Add customer user' => 'Ongeza mtumiaji wa mteja',
        'Hint' => 'Dokezo',
        'Customer user are needed to have a customer history and to login via customer panel.' =>
            'Mtumiaji wa mteja anahitaji kuwa na historia ya mteja na kuingia kupitia paneli ya mteja.',
        'Last Login' => 'Muingio wa mwisho',
        'Login as' => 'Ingia kama',
        'Switch to customer' => 'Badili kwenda kwa mteja',
        'Add Customer User' => 'Ongeza mtumiaji wa mteja',
        'Edit Customer User' => 'Hariri mtumiaji wa mteja',
        'This field is required and needs to be a valid email address.' =>
            'Uga huu unahitajika na iwe anuani ya barua pepe halali',
        'This email address is not allowed due to the system configuration.' =>
            'Barua pepe hii hairuhusiwi kwasababu ya usanidi wa mfumo.',
        'This email address failed MX check.' => 'Barua pepe hii imeshindwa angalio la MX.',
        'DNS problem, please check your configuration and the error log.' =>
            'Matatizo katika DNS,  tafadhali anagalia usanidi wako na ingio katika makosa.',
        'The syntax of this email address is incorrect.' => 'Sintaksi katika barua pepe hii sio sawa.',

        # Template: AdminCustomerUserGroup
        'Manage Customer-Group Relations' => 'Simamia mahusiano ya Mteja-Kikundi',
        'Notice' => 'Taarifa',
        'This feature is disabled!' => 'Kipengele hiki hakijaruhusiwa.',
        'Just use this feature if you want to define group permissions for customers.' =>
            'Tumia kipengele hiki kama unataka kufafanua ruhusa za kikundi kwa wateja.',
        'Enable it here!' => 'Iruhusu hapa.',
        'Edit Customer Default Groups' => 'Hariri kikundi cha chaguo-msingi cha mteja',
        'These groups are automatically assigned to all customers.' => 'Makundi hata yamegaiwa kwa automatiki kwa wateja wote.',
        'You can manage these groups via the configuration setting "CustomerGroupAlwaysGroups".' =>
            'Unaweza kusimamia makundi haya kwa mpangilio wa usanidi \'\'Kikundicha mteja mara zote Makundi"',
        'Filter for Groups' => 'Chuja kwa ajili ya makundi',
        'Just start typing to filter...' => 'Anza kuandika ili kuchuja',
        'Select the customer:group permissions.' => 'Chagua ruhusa za kikundi za mteja',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer).' =>
            'Kama hakuna kilichochaguliwa, basi hakuna ruhusa katika kikundi hiki (tiketi zitakuwa hazipatikani kwa wateja).',
        'Search Results' => 'Majibu ya kutafuta',
        'Customers' => 'Wateja',
        'No matches found.' => 'Hakuna zinazofanana zilizopatikana',
        'Change Group Relations for Customer' => 'Badili uhusiano wa kikundi kwa mteja',
        'Change Customer Relations for Group' => 'Badili uhusiano wa mteja kwa kikundi',
        'Toggle %s Permission for all' => 'Geuza ruhusa %s kwa wote',
        'Toggle %s permission for %s' => 'Geuza ruhusa %s kwa %s',
        'Customer Default Groups:' => 'Kikundi chaguo-msingi cha mteja',
        'No changes can be made to these groups.' => 'Hakuna mabadiliko yanayoweza kufanywa katika makundi haya.',
        'ro' => 'ro',
        'Read only access to the ticket in this group/queue.' => 'Ufikivu wa kusoma tu kwenda kwenye tiketi katika kikundi hiki/foleni.',
        'rw' => 'rw',
        'Full read and write access to the tickets in this group/queue.' =>
            'Ufikivu wote wa kusoma na kuandika kwenda kwenye tiketi katika kikundi hiki/foleni.',

        # Template: AdminCustomerUserService
        'Manage Customer-Services Relations' => 'Simamia mahusiano ya huduma kwa mteja',
        'Edit default services' => 'Hariri huduma chaguo-msingi.',
        'Filter for Services' => 'Chuja kwa jili ya huduma',
        'Allocate Services to Customer' => 'Tengea huduma kwa mteja',
        'Allocate Customers to Service' => 'Tengea mteja kwa huduma',
        'Toggle active state for all' => 'Geuza hali amilifu kwa wote',
        'Active' => 'Amilifu',
        'Toggle active state for %s' => 'Geuza hali amilifu kwa %s',

        # Template: AdminDynamicField
        'Dynamic Fields Management' => 'Usimamizi wa uga wenye nguvu',
        'Add new field for object' => 'Ongeza uga mpya kwa kipengele',
        'To add a new field, select the field type from one of the object\'s list, the object defines the boundary of the field and it can\'t be changed after the field creation.' =>
            'Kuongeza uga mpya, chagua aina ya uga kutoka kwenye orodha ya kipengele, kipengele kinafafanua mpaka wa uga na haiwezi kubadilishwa baada ya kutengeneza uga. ',
        'Dynamic Fields List' => 'Orodha ya uga wenye nguvu',
        'Dynamic fields per page' => 'Uga zenye nguvu kwa ukurasa',
        'Label' => 'Lebo',
        'Order' => 'Mpangilio',
        'Object' => 'Kipengele',
        'Delete this field' => 'Futa uga huu',
        'Do you really want to delete this dynamic field? ALL associated data will be LOST!' =>
            'Je unataka kufuta uga huu wenye nguvu? Data zote zinazohisika zitapotea!',
        'Delete field' => 'Futa uga',

        # Template: AdminDynamicFieldCheckbox
        'Field' => 'Uga',
        'Go back to overview' => 'Rudi nyuma kwenye mapitio',
        'General' => 'Ujumla',
        'This field is required, and the value should be alphabetic and numeric characters only.' =>
            'Uga huu unahitajika, na thamani iwe herufu na namba tu.',
        'Must be unique and only accept alphabetic and numeric characters.' =>
            'Lazima iwe ya kipekee na ikubali herufi na namba tu.',
        'Changing this value will require manual changes in the system.' =>
            'Kubadilisha thamani hii itahitaji mabadiliko ya mkono katika mfumo.',
        'This is the name to be shown on the screens where the field is active.' =>
            'Hili ni jina litakaloonyeshwa kwenye skrini uga ukiwa amilifu.',
        'Field order' => 'Kitafuta uga',
        'This field is required and must be numeric.' => 'Uga huu unatakiwa na lazima iwe namba.',
        'This is the order in which this field will be shown on the screens where is active.' =>
            'Huu ndio mpangilio ambao uga huu utaonyeshwa katika skrini ikiwa amilifu',
        'Field type' => 'Aina ya uga',
        'Object type' => 'Aina ya kipengele',
        'Internal field' => 'Uga wa ndani',
        'This field is protected and can\'t be deleted.' => 'Uga huu unalindwa na hauwezi kufutwa.',
        'Field Settings' => 'Mipangilio ya uga',
        'Default value' => 'Thamani chaguo-msingi',
        'This is the default value for this field.' => 'Hii ndio thamani chaguo-msingi kwa uga huu.',

        # Template: AdminDynamicFieldDateTime
        'Default date difference' => 'Tofauti ya tarehe chaguo-msingi',
        'This field must be numeric.' => 'Uga huu lazima uwe wa namba.',
        'The difference from NOW (in seconds) to calculate the field default value (e.g. 3600 or -60).' =>
            'Tofauti ya sasa(katika sekunde) kukadiria thamani ya chaguo-msingi ya uga (mfano 3600 au -60).',
        'Define years period' => 'Fafanua kipindi cha miaka',
        'Activate this feature to define a fixed range of years (in the future and in the past) to be displayed on the year part of the field.' =>
            'Amilisha kipengele hiki ili kufafanua masafa ya miaka funge (kwa mbeleni na zamani) ili kuonyeshwa katika sehemu ya miaka ya uga.',
        'Years in the past' => 'Miaka ya nyuma',
        'Years in the past to display (default: 5 years).' => 'Miaka ya nyuma ya kuonyeshwa (chaguo-msingi: miaka 5).',
        'Years in the future' => 'Miaka ya wakati ujao.',
        'Years in the future to display (default: 5 years).' => 'Miaka ya wakti ujao itaonyesha (chaguo-msingi: miaka 5)',
        'Show link' => 'Onyesha kiungo',
        'Here you can specify an optional HTTP link for the field value in Overviews and Zoom screens.' =>
            'Hapa unaweza kubainisha kiungo cha HTTP cha hiari kwenye uga katika mapitio na skrini zilizokuzwa.',
        'Restrict entering of dates' => 'Zuia uingizaji wa tarehe',
        'Here you can restrict the entering of dates of tickets.' => 'Hapa unaweza kuzuia uingizaji wa tarehe wa tiketi.',

        # Template: AdminDynamicFieldDropdown
        'Possible values' => 'Thamani ziwezekanazo',
        'Key' => 'funguo',
        'Value' => 'Thamani',
        'Remove value' => 'Ondoa thamani',
        'Add value' => 'Ongeza thamani',
        'Add Value' => 'Ongeza thamani',
        'Add empty value' => 'Ongeza thamani tupu',
        'Activate this option to create an empty selectable value.' => 'Amilisha chaguo hili kutengeneza thamani tupu inayowezakuchagulika.',
        'Tree View' => 'Mandhari ya mti',
        'Activate this option to display values as a tree.' => 'Amilisha chaguo hili kuonyesha thamani kama mti.',
        'Translatable values' => 'Thamani zinazoweza kutafsirika.',
        'If you activate this option the values will be translated to the user defined language.' =>
            'Kama utaamilisha chaguo hili thamani zitatafsiriwa kwa lugha ya mtumiaji.',
        'Note' => 'Kidokezo',
        'You need to add the translations manually into the language translation files.' =>
            'Unahitaji kuongeza utafsiri kwa mkono katika faili la tafsiri la lugha. ',

        # Template: AdminDynamicFieldText
        'Number of rows' => 'Namba ya safu mlalo',
        'Specify the height (in lines) for this field in the edit mode.' =>
            'Bainisha urefu (katika mistari) kwa uga huu katika hali timizi ya uhariri ',
        'Number of cols' => 'Namba ya safu wima',
        'Specify the width (in characters) for this field in the edit mode.' =>
            'Bainisha upana (kwa herufi) kwa uga huu katika hali timzi ya uhariri',
        'Check RegEx' => 'Angalia RegEx',
        'Here you can specify a regular expression to check the value. The regex will be executed with the modifiers xms.' =>
            'Hapa unaweza kubainisha maelezo ya kawaida kuangalia thamani. Regex itafanywa na kirekebishi xms.',
        'RegEx' => 'RegEx',
        'Invalid RegEx' => 'RegEx batili',
        'Error Message' => 'Ujumbe wa hitilafu/kosa',
        'Add RegEx' => 'Ongeza RegEx',

        # Template: AdminEmail
        'Admin Notification' => 'Taarifa ya msimamizi',
        'With this module, administrators can send messages to agents, group or role members.' =>
            'Na moduli hii, wasimamizi wanaweza kutuma ujumbe kwa mawakala, kikundi au wahusika wenye majukumu.',
        'Create Administrative Message' => 'Tengeneza ujumbe wa utawala.',
        'Your message was sent to' => 'Ujumbe wako ulitumwa',
        'Send message to users' => 'tuma meseji kwa watumiaji',
        'Send message to group members' => 'tuma meseji kwa memba wa grupu',
        'Group members need to have permission' => 'Wanakikundi wanahitaji kuwa na ruhusa.',
        'Send message to role members' => 'Tuma ujumbe kwa washiriki wenye majukumu. ',
        'Also send to customers in groups' => 'Pia tuma kwa wateja kwenye vikundi.',
        'Body' => 'Kiini',
        'Send' => 'tuma',

        # Template: AdminGenericAgent
        'Generic Agent' => 'Wakala wa jumla',
        'Add job' => 'Ongeza kazi',
        'Last run' => 'Mwisho kufanya ',
        'Run Now!' => 'Fanya sasa',
        'Delete this task' => 'Futa kazi hii',
        'Run this task' => 'Fanya kazi hii',
        'Job Settings' => 'Mipangilio ya kazi',
        'Job name' => 'Jina la kazi',
        'The name you entered already exists.' => 'Jina uliloingiza tayari lipo',
        'Toggle this widget' => 'Geuza kifaa hiki',
        'Automatic execution (multiple tickets)' => 'Tekelezo automatiki (Tiketi nyingi)',
        'Execution Schedule' => 'Ratiba ya utekelezaji',
        'Schedule minutes' => 'Dakika za ratiba',
        'Schedule hours' => 'Masaa ya ratiba',
        'Schedule days' => 'Siku za ratiba',
        'Currently this generic agent job will not run automatically.' =>
            'Kwa sasa kazi hii ya ujumla ya wakala haitofanya kazi kwa otomatiki.',
        'To enable automatic execution select at least one value from minutes, hours and days!' =>
            'Kuwezesha utendaji otomatiki chagua angalau thamani moja kutoka kwenye dakika, saa na siku!',
        'Event based execution (single ticket)' => 'Tukio kwa msingi wa utekelezaji (Tiketi moja)',
        'Event Triggers' => 'Uchochezi wa tukio',
        'List of all configured events' => 'Orodha ya matukio yote yaliyosanidiwa',
        'Delete this event' => 'Futa tukio hili',
        'Additionally or alternatively to a periodic execution, you can define ticket events that will trigger this job.' =>
            'Kwa kuongeza au kwa mbadala katika utekelezaji wa muda, unaweza ukafafanua matukio ya tiketi ambayo yatachochea kazi hii.',
        'If a ticket event is fired, the ticket filter will be applied to check if the ticket matches. Only then the job is run on that ticket.' =>
            'Kama tukio la tiketi limefutwa, kichuja cha tiketi kitatumika kuangalia kama tiketi zinafanana. Kazi itafanywa kwenye tiketi tu.',
        'Do you really want to delete this event trigger?' => 'Je unataka kufuta kichocheo hiki cha tukio?',
        'Add Event Trigger' => 'Ongeza kichochezi tukio',
        'Add Event' => 'Ongeza tukio',
        'To add a new event select the event object and event name and click on the "+" button' =>
            'Kuongeza tukio jipya jagua kipengele cha tukio na jina la tukio na bofya kwenye kitufye "+"',
        'Duplicate event.' => 'Nakili tukio',
        'This event is already attached to the job, Please use a different one.' =>
            'Tukio hili tayari limeweambatanishwa na kazi, tafadhali tumia lingine.',
        'Delete this Event Trigger' => 'Futa kichochezi cha tukio hili',
        'Remove selection' => '',
        'Select Tickets' => 'Chagua tiketi',
        '(e. g. 10*5155 or 105658*)' => '(Mfano 10*5155 au 105658)',
        '(e. g. 234321)' => '(Mfano 234321)',
        'Customer login' => 'Uingiaji kwa mteja',
        '(e. g. U5150)' => '(Mfano U5150)',
        'Fulltext-search in article (e. g. "Mar*in" or "Baue*").' => 'Tafuta nakala kamili katika makala (Mfano "Mar*in" au "Baue" ).',
        'Agent' => 'Wakala',
        'Ticket lock' => 'Kifungo cha tiketi',
        'Create times' => 'Tengeneza muda',
        'No create time settings.' => 'Hakuna mipangilio ya kutengeneza muda',
        'Ticket created' => 'Tiketi imetengenezwa',
        'Ticket created between' => 'Tiketi imetengenezwa kati ya',
        'Last changed times' => 'Muda wa mwisho kubadilishwa',
        'No last changed time settings.' => 'Hakuna muda wa mwisho kubadilishwa',
        'Ticket last changed' => 'Tiketi imebadilishwa mwisho',
        'Ticket last changed between' => 'Tiketi imebadilishwa mwisho kati ya',
        'Change times' => 'Badili muda',
        'No change time settings.' => 'Hakuna mipangilio ya kubadili muda',
        'Ticket changed' => 'Tiketi imebadilishwa',
        'Ticket changed between' => 'Tiketi imebadilishwa katikati ya',
        'Close times' => 'Mida ya kufunga ',
        'No close time settings.' => 'Hakuna mipangilio ya muda wa kufunga.',
        'Ticket closed' => 'Tiketi imefungwa',
        'Ticket closed between' => 'Tiketi inafungwa kati ya',
        'Pending times' => 'Muda wa kusubiri',
        'No pending time settings.' => 'Muda wa kusubiri wa tiketi umefika',
        'Ticket pending time reached' => 'Muda wa kusubiri wa tiketi umefika',
        'Ticket pending time reached between' => 'Muda wa kusubiri wa tiketi umefika kati ya',
        'Escalation times' => 'Eneza Muda',
        'No escalation time settings.' => 'Hakuna mipangilio ya kueneza muda',
        'Ticket escalation time reached' => 'Muda wa kueneza muda wa tiketi umefika',
        'Ticket escalation time reached between' => 'Muda wa kueneza tiketi umefika kati ya ',
        'Escalation - first response time' => 'Kupanda- muda wa majibu ya kwanza',
        'Ticket first response time reached' => 'Muda wa mwitiko wa kwanza wa tiketi umefika ',
        'Ticket first response time reached between' => 'Muda wa mwitiko wa kwanza wa tiketi ulifika kati ya',
        'Escalation - update time' => 'Kupanda-muda wa kusasisha',
        'Ticket update time reached' => 'Muda wa kusasisha tiketi umefika',
        'Ticket update time reached between' => 'Muda wa kusasisha tiketi ulifika kati ya',
        'Escalation - solution time' => 'Kupanda-Muda wa suluhu',
        'Ticket solution time reached' => 'Muda wa utatuzi wa tiketi umefika',
        'Ticket solution time reached between' => 'Muda wa utatuzi wa tiketi ulifika kati ya',
        'Archive search option' => 'Uchaguzi wa kutafuta nyaraka',
        'Update/Add Ticket Attributes' => 'Sasisha/ongeza sifa za tiketi',
        'Set new service' => 'Weka huduma mpya',
        'Set new Service Level Agreement' => 'Weka Kubaliano Jipya la kiwango la huduma',
        'Set new priority' => 'Weka kipaumbele kipya',
        'Set new queue' => 'Weka foleni mpya',
        'Set new state' => 'Weka hali mpya',
        'Pending date' => 'Tarehe inasubiri',
        'Set new agent' => 'Weka wakala mpya',
        'new owner' => 'Mmiliki mpya',
        'new responsible' => 'Kuwajibika kupya',
        'Set new ticket lock' => 'Weka kufunga kupya kwa tiketi',
        'New customer' => 'Mteja mpya',
        'New customer ID' => 'Kitambulisho kipya cha mteja',
        'New title' => 'Kichwa cha habari kipya',
        'New type' => 'Aina mpya',
        'New Dynamic Field Values' => 'Thamani mpya za uga wenye nguvu',
        'Archive selected tickets' => 'Tiketi zilizochaguliwa kutoka kwenye nyaraka',
        'Add Note' => 'Ongeza Kidokezo',
        'Time units' => 'Kizio cha muda',
        'Execute Ticket Commands' => 'Tekeleza amri ya tiketi',
        'Send agent/customer notifications on changes' => 'Mtumie wakala/mteja taarifa kuhusu mabadiliko',
        'CMD' => 'CMD',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' =>
            'Amri hii itatekelezwa. Namba ya tiketi itakuwa ARG[0].ARG[1] ni kitambulisho cha tiketi',
        'Delete tickets' => 'Tiketi zilizofutwa ',
        'Warning: All affected tickets will be removed from the database and cannot be restored!' =>
            'Onyo: Tiketi zote zilizoathiriwa zitaondolewa kwenye hifadhi data and hazitorejeshwa.',
        'Execute Custom Module' => 'Tekeleza moduli maalum',
        'Param %s key' => 'Ufunguo wa kigezo %s',
        'Param %s value' => 'Thamani ya kigezo %s',
        'Save Changes' => 'Hifadhi mabadiliko',
        'Results' => 'matokeo',
        '%s Tickets affected! What do you want to do?' => 'Tiketi %s zimeathirika. Unataka kufanya nini?',
        'Warning: You used the DELETE option. All deleted tickets will be lost!' =>
            'Onyo: Umetumia chaguo la kufuta. Tiketi zote zilizofutwa zitapotea!',
        'Edit job' => 'Hariri kazi',
        'Run job' => 'Fanya kazi',
        'Affected Tickets' => 'Tiketi zilizoathirika',

        # Template: AdminGenericInterfaceDebugger
        'GenericInterface Debugger for Web Service %s' => 'Kiolesura cha ujumla cha mweuaji kwa ajili ya huduma za wavuti %s',
        'Web Services' => 'Huduma za tovuti',
        'Debugger' => 'Mweauju',
        'Go back to web service' => 'Rudi nyuma kwenye huduma za tovuti',
        'Clear' => 'safisha',
        'Do you really want to clear the debug log of this web service?' =>
            'Je unataka kufuta batli eua ya huduma ya tovuti.',
        'Request List' => 'Orodha ya maombi',
        'Time' => 'Muda',
        'Remote IP' => 'IP ya mbali',
        'Loading' => 'Pakia',
        'Select a single request to see its details.' => 'Chagua ombi moja kuona maelezo yake.',
        'Filter by type' => 'Chuja kwa aina',
        'Filter from' => 'Chuja kutoka',
        'Filter to' => 'Chuja kwenda',
        'Filter by remote IP' => 'Chuja kwa IP ya mbali',
        'Refresh' => 'Onyesha upya',
        'Request Details' => 'Maelezo ya maombi',
        'An error occurred during communication.' => 'Kosa limetokea wakati wa mawasiliano.',
        'Show or hide the content.' => 'Onyesha au ficha maudhui.',
        'Clear debug log' => 'Futa batli ya eua.',

        # Template: AdminGenericInterfaceInvokerDefault
        'Add new Invoker to Web Service %s' => 'Ongeza kisababishi kipya katika huduma ya tovuti %s',
        'Change Invoker %s of Web Service %s' => 'Badilisha kisababishi %s cha huduma za wavuti %s',
        'Add new invoker' => 'Ongeza kisababishi kipya.',
        'Change invoker %s' => 'Badili kisababishi',
        'Do you really want to delete this invoker?' => 'Je unataka kufuta isababishi hiki?',
        'All configuration data will be lost.' => 'usanidishaji wote wa data utapotea.',
        'Invoker Details' => 'Undani wa Kisababishi',
        'The name is typically used to call up an operation of a remote web service.' =>
            'Jina limeshatumika kuweka operesheni ya huduma ya tovuti wa mbali.',
        'Please provide a unique name for this web service invoker.' => 'Tafadhali weka jina la kipekee kwa ajili ya kisababishi cha huduma ya tovuti.',
        'Invoker backend' => 'Mazingira ya nyuma ya kisababishi',
        'This OTRS invoker backend module will be called to prepare the data to be sent to the remote system, and to process its response data.' =>
            'Moduli ya mazingira ya nyuma ya kichochezi cha OTRS itaitwa kuandaa data kutumwa katika mfumo wa mbali, na kushughulikia data zake za majibu.',
        'Mapping for outgoing request data' => 'Kuunganishwa kwa data za maombi zinazotoka nje.',
        'Configure' => 'Sanidi',
        'The data from the invoker of OTRS will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            'Data kutoka kwa kichochezi cha OTRS zitashughulikiwa na kuunganishwa huku, kubadilisha kuwa data ambayo mfumo wa mbali inaitarajia.',
        'Mapping for incoming response data' => 'Kuunganisha data za majibu zinazoingia ndani.',
        'The response data will be processed by this mapping, to transform it to the kind of data the invoker of OTRS expects.' =>
            'Data za majibu zitashughulikiwa na kuunganishwa kwa ramani, kuibadilisha kuwa data ambayo kichochezi cha OTRS kinaitarajia. ',
        'Asynchronous' => 'Solandanifu',
        'This invoker will be triggered by the configured events.' => 'Kichochezi kitashtuliwa na matukio yaliyosanidiwa.',
        'Asynchronous event triggers are handled by the OTRS Scheduler in background (recommended).' =>
            'Vichochezi vya tukio solandanifu vinashughulikiwa na kipanga ratiba cha OTRS kwa nyuma(Inapendekezwa).',
        'Synchronous event triggers would be processed directly during the web request.' =>
            'Vichochezi vya tukio solandanifu vitashughulikiwa moja kwa moja wakati wa maombi ya tovuti.',
        'Save and continue' => 'Hifadhi na endelea',
        'Delete this Invoker' => 'Tufa kisababishi hiki',

        # Template: AdminGenericInterfaceMappingSimple
        'GenericInterface Mapping Simple for Web Service %s' => 'Sampuli ya kuunganisha ya kiolesura cha ujumla kwa ajili ya huduma ya wavuti %s',
        'Go back to' => 'Rusi nyuma kwenda',
        'Mapping Simple' => 'Kuunganisha kwa urahisi',
        'Default rule for unmapped keys' => 'Sharti chaguo msingi kwa funguo za kuunganishwa.',
        'This rule will apply for all keys with no mapping rule.' => 'Sharti hili litatumika kwa funguo zote amabazo hazina sharti la kuunganisha.',
        'Default rule for unmapped values' => 'Sharti chaguo msingi kwa thamani ya kuunganishwa.',
        'This rule will apply for all values with no mapping rule.' => 'Sharti hili litatumika kwa thamani zote ambazo hazina sharti la kuunganisha.',
        'New key map' => 'Funguo mpya wa ramani',
        'Add key mapping' => 'Ongeza funguo ya ',
        'Mapping for Key ' => 'Unganisha kwa funguo',
        'Remove key mapping' => 'Ondoa kuunganisha kwa funguo',
        'Key mapping' => 'Kuunganisha kwa funguo',
        'Map key' => 'Kibonye cha ramani',
        'matching the' => 'Linganisha',
        'to new key' => 'Kwenda kwenye kibonye kipya',
        'Value mapping' => 'Thamani ya kuunganisha',
        'Map value' => 'Thamani ya kuunganisha',
        'to new value' => 'Kwa thamani mpya',
        'Remove value mapping' => 'Ondoa thamani ya kuunganisha',
        'New value map' => 'Thamani mpya ya kuunganisha',
        'Add value mapping' => 'Ongeza thamani ya kuunganisha',
        'Do you really want to delete this key mapping?' => 'Je unataka kufuta ufunguo huu wa kutengeneza ramani?',
        'Delete this Key Mapping' => 'Futa ufungu huu wa kuunganisha/kutengeneza ramani.',

        # Template: AdminGenericInterfaceOperationDefault
        'Add new Operation to Web Service %s' => 'Ongeza opereshi mpya katika huduma ya tovuti %s',
        'Change Operation %s of Web Service %s' => 'Badili operesheni %s wa huduma ya tovuti %s',
        'Add new operation' => 'Ongeza operesheni mpya',
        'Change operation %s' => 'Badili operesheni %s',
        'Do you really want to delete this operation?' => 'Je unataka kufuta operesheni hii?',
        'Operation Details' => 'Undani wa operesheni',
        'The name is typically used to call up this web service operation from a remote system.' =>
            'Jina limeshatumika kuweka operesheni ya huduma ya tovuti wa mbali.',
        'Please provide a unique name for this web service.' => 'Tafadhali weka jina la kipekee kwa ajili ya huduma ya tovuti hii.',
        'Mapping for incoming request data' => 'Tengeneza ramani kwa ajili ya data za maombi zinazoingia.',
        'The request data will be processed by this mapping, to transform it to the kind of data OTRS expects.' =>
            'Data za majibu zitashughulikiwa na muunganisho huu, kuibadilisha kuifanya kuwa data inayotarajiwa na OTRS.',
        'Operation backend' => 'azingira ya nyuma ya mfumo',
        'This OTRS operation backend module will be called internally to process the request, generating data for the response.' =>
            'Moduli ya mazingira ya nyuma ya uendeshaji ya OTRS yataitwa ndani kushughulikia maombi, kutengeneza data kwa ajili ya majibu.',
        'Mapping for outgoing response data' => 'Kuunganisha data za majibu zinazotoka nje.',
        'The response data will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            'Data za majimu zitashughulikiwa na kuunganishwa huku, kubadili kuwa data ambayo mfumo wa mbali unaitarajia.',
        'Delete this Operation' => 'Kufuta Operesheni hii',

        # Template: AdminGenericInterfaceTransportHTTPREST
        'GenericInterface Transport HTTP::REST for Web Service %s' => 'Kiolesura cha ujumla cha kusafirisha HTTP::REST kwa ajili ya huduma za wavuti %s.',
        'Network transport' => 'Usafirishaji wa mtandao',
        'Properties' => 'tabia',
        'Route mapping for Operation' => 'Kuunganisha njia kwa ajili ya uendeshaji',
        'Define the route that should get mapped to this operation. Variables marked by a \':\' will get mapped to the entered name and passed along with the others to the mapping. (e.g. /Ticket/:TicketID).' =>
            'Inafafanua njia ambayo inaunganishwa na uendeshaji huu.Thamani zinazobadilika zilizowekwa alama ya \':\' zinaunganishwa katika jina lililoingizwa na lililopitishwa na mengine katika uunganishaji. (mfano /Tiketi/:kitambulisho cha tiketi).',
        'Valid request methods for Operation' => 'Njia za maombi halali kwa ajili ya uendeshaji',
        'Limit this Operation to specific request methods. If no method is selected all requests will be accepted.' =>
            'Weka kikomo kwa ajili ya uendeshaji huu kuwa njia za maombi maalum. Kama hakuna njia iliyochaguliwa maombi yote yatakubaliwa.',
        'Maximum message length' => 'Upeo urefu wa ujumbe',
        'This field should be an integer number.' => 'Uga huu uwe namba kamili.',
        'Here you can specify the maximum size (in bytes) of REST messages that OTRS will process.' =>
            'Hapa unaweza kubainisha ukubwa wa upeo wa juu (katika baiti) wa jumbe zilizopumzika ambazo OTRS itazishughulikia.',
        'Send Keep-Alive' => 'Tuna Weka-hai',
        'This configuration defines if incoming connections should get closed or kept alive.' =>
            'Usanidi huu unafafanua kama miunganisho ya kuingia ifungwe au iache hai.',
        'Host' => 'Mwenyeji',
        'Remote host URL for the REST requests.' => 'Mwenye wa mbali wa URL kwa ajili ya maombi ya REST.',
        'e.g https://www.otrs.com:10745/api/v1.0 (without trailing backslash)' =>
            'mfano  https://www.otrs.com:10745/api/v1.0 (bila ya mkwajunyuma unaofuatilia)',
        'Controller mapping for Invoker' => 'Kiendeshaji kiunganishaji kwa ajili ya kichochezi',
        'The controller that the invoker should send requests to. Variables marked by a \':\' will get replaced by the data value and passed along with the request. (e.g. /Ticket/:TicketID?UserLogin=:UserLogin&Password=:Password).' =>
            'Kiendashaji ambacho kichochezi kinatakiwa kitume maombi kwenda. Vishika nafasi vimewekwa alama na \':\' kitabadilishwa na thamani ya data na itapitishwa na ombi. (mfano/Tiketi/:Kitambulisho cha tiketi=: Kuingia kwa mtumiaji & neno la siri=:neno la siri). ',
        'Valid request command for Invoker' => 'Amri halali ya maombi kwa ajili ya kichochezi',
        'A specific HTTP command to use for the requests with this Invoker (optional).' =>
            'Amri maalum ya HTTP ya kutumia kwa ajili ya maombi kwa ajili ya kichochezi hiki (Hiari). ',
        'Default command' => 'Sharti chaguo-msingi',
        'The default HTTP command to use for the requests.' => 'Sharti chaguo-msingi la HTTP kutumia kwa ajili ya maombi.',
        'Authentication' => 'uthibitisho',
        'The authentication mechanism to access the remote system.' => 'Utaritibu wa uhalishaji kufikia mfumo wa mbali.',
        'A "-" value means no authentication.' => 'Thamani "-" ina maana hakuna uhalishwaji.',
        'The user name to be used to access the remote system.' => 'Jina la mtumiaji litumike kufikia mfumo wa mbali.',
        'The password for the privileged user.' => 'Neno la siri kwa mtumiaji aliyependelewa.',
        'Use SSL Options' => 'Tumia chaguo la SSL',
        'Show or hide SSL options to connect to the remote system.' => 'Onyesha au ficha michaguo ya SSL kuunganisha ma mfumo wa mbali.',
        'Certificate File' => 'Faili la cheti',
        'The full path and name of the SSL certificate file.' => 'Njia kamili na jina la faili la cheti cha SSL.',
        'e.g. /opt/otrs/var/certificates/REST/ssl.crt' => 'mfano ',
        'Certificate Password File' => 'Faili la neno la siri la cheti',
        'The full path and name of the SSL key file.' => 'Njia kamili na jina la faili la funguo ya SSL.',
        'e.g. /opt/otrs/var/certificates/REST/ssl.key' => 'mfano /opt/otrs/var/certificates/REST/ssl.key',
        'Certification Authority (CA) File' => 'Faili la Cheti cha Mamlaka (CA)',
        'The full path and name of the certification authority certificate file that validates the SSL certificate.' =>
            'Njia kamili na jina la faili la cheti cha mamlaka ambazo zinahakikisha cheti SSL.',
        'e.g. /opt/otrs/var/certificates/REST/CA/ca.file' => 'mfano  /opt/otrs/var/certificates/REST/CA/ca.file',

        # Template: AdminGenericInterfaceTransportHTTPSOAP
        'GenericInterface Transport HTTP::SOAP for Web Service %s' => 'Kiolesura cha ujumla cha kusafirisha HTTP::SOAP kwa ajili ya huduma za wavuti %s.',
        'Endpoint' => 'Mwisho',
        'URI to indicate a specific location for accessing a service.' =>
            'URI insonyesha eneo maalum kupata huduma',
        'e.g. http://local.otrs.com:8000/Webservice/Example' => 'mfano http://local.otrs.com:8000/Webservice/Example',
        'Namespace' => 'Nafasi ya jina',
        'URI to give SOAP methods a context, reducing ambiguities.' => 'URI kuzipa njia za SOAP muktadha kupunguza utata.',
        'e.g urn:otrs-com:soap:functions or http://www.otrs.com/GenericInterface/actions' =>
            'mfano urn:otrs-com:soap:functions au http://www.otrs.com/GenericInterface/actions',
        'Here you can specify the maximum size (in bytes) of SOAP messages that OTRS will process.' =>
            'Hapa unaweza kubainisha ukubwa wa upeo wa juu (katika baiti) wa jumbe za SOAP ambazo OTRS itazishughulikia.',
        'Encoding' => 'Usimbaji',
        'The character encoding for the SOAP message contents.' => 'Herufi za usimbaji kwa ajili ya maudhui ya ujumbe wa SOAP',
        'e.g utf-8, latin1, iso-8859-1, cp1250, Etc.' => 'mfano utf-8, latin1, iso-8859-1, cp1250, n.k.',
        'SOAPAction' => 'Kitendo cha SOAP',
        'Set to "Yes" to send a filled SOAPAction header.' => 'Weka kuwa "Ndio" kutuma kichwa cha kitendo cha SOAP kilichowekwa kwenye faili.',
        'Set to "No" to send an empty SOAPAction header.' => 'Weka kuwa "Hapana" kutuma kichwa cha kitendo cha SOAP kilichowekwa kwenye faili.',
        'SOAPAction separator' => 'Kitenganishi cha kitendo cha SOAP',
        'Character to use as separator between name space and SOAP method.' =>
            'Herufi kutumika kama litenganishi kati ya nafasi ya jina na njia ya SOAP.',
        'Usually .Net web services uses a "/" as separator.' => 'Mara kwa mara  huduma za tovuti .Net zinatumia kitenganishi "/".',
        'The full path and name of the SSL certificate file (must be in .p12 format).' =>
            'Njia kamili na jina la faili la cheti cha SSL (lazima iwe katika umbizo la .p12).',
        'e.g. /opt/otrs/var/certificates/SOAP/certificate.p12' => 'mfano /opt/otrs/var/certificates/SOAP/certificate.p12',
        'The password to open the SSL certificate.' => 'Neno la siri la kufungua cheti cha SSL.',
        'The full path and name of the certification authority certificate file that validates SSL certificate.' =>
            'Njia kamili na jina la faili la cheti cha mamlaka cha uhalalishaji ambacho kinahalisha cheti cha SSL.',
        'e.g. /opt/otrs/var/certificates/SOAP/CA/ca.pem' => 'mfano /opt/otrs/var/certificates/SOAP/CA/ca.pem',
        'Certification Authority (CA) Directory' => 'Mpangilio orodha wa Cheti cha Mamlaka (CA)',
        'The full path of the certification authority directory where the CA certificates are stored in the file system.' =>
            'Njia kamili na jina la mipangilio orodha ya cheti cha mamlaka ambazo zinahakikisha cheti SSL.',
        'e.g. /opt/otrs/var/certificates/SOAP/CA' => 'Mfano /opt/otrs/var/certificates/SOAP/CA',
        'Proxy Server' => 'Seva mbadala',
        'URI of a proxy server to be used (if needed).' => 'URI au seva mbadala itumike (Kama inahitajika).',
        'e.g. http://proxy_hostname:8080' => 'Mfano http://proxy_hostname:8080',
        'Proxy User' => 'Mtumiaji mbadala',
        'The user name to be used to access the proxy server.' => 'Jina la mtumiaji litakalotumika kufikia seva mbadala.',
        'Proxy Password' => 'Neno la siri mbadala',
        'The password for the proxy user.' => 'Neno la siri kwa ajili ya mtumiaji mbadala.',

        # Template: AdminGenericInterfaceWebservice
        'GenericInterface Web Service Management' => 'Usimamizi wa huduma ya wavuti ya kiolesura cha jumla.',
        'Add web service' => 'Ongeza huduma ya tovuti',
        'Clone web service' => 'Nakala idhinishe ya huduma ya tovuti',
        'The name must be unique.' => 'Jina lazima liwe la kipekee.',
        'Clone' => 'Nakala idhinishe',
        'Export web service' => 'Hamisha huduma ya tovuti',
        'Import web service' => 'Leta huduma ya tovuti',
        'Configuration File' => 'Faili la usanidi',
        'The file must be a valid web service configuration YAML file.' =>
            'Faili lazima liwe faili halali la huduma ya tovuti la usanidi wa YAML.',
        'Import' => 'kuingiza',
        'Configuration history' => 'Historia ya usanidi',
        'Delete web service' => 'Futa huduma ya tovuti',
        'Do you really want to delete this web service?' => 'Je unataka kufuta huduma hii ya tovuti?',
        'After you save the configuration you will be redirected again to the edit screen.' =>
            'Baada ya kuhifadhi usanidi utaelekezwa tena kwenye skrini ya kuhariri.',
        'If you want to return to overview please click the "Go to overview" button.' =>
            'Kama unataka kurudi katika maelezo tafadhali bofya kibonye cha "Rudi kwenye maelezo"',
        'Web Service List' => 'Orodha ya huduma ya tovuti',
        'Remote system' => 'Mfumo wa mbali',
        'Provider transport' => 'Kutoa usafiri',
        'Requester transport' => 'Usafiri wa muombaji',
        'Debug threshold' => 'Kizingiti cha ueuaji',
        'In provider mode, OTRS offers web services which are used by remote systems.' =>
            'Katika hali tumizi ya mtoaji, OTRS inatoa huduma za tovuti ambazo mifumo ya mbali.',
        'In requester mode, OTRS uses web services of remote systems.' =>
            'Katika hali timizi ya muombaji, OTRS inatumia huduma za tovuti kwa ajili ya mifumo ya mbali.',
        'Operations are individual system functions which remote systems can request.' =>
            'Uendeshaji ni kazi za mfumo binafsi ambao mifumo ya mbali inaweza kuomba.',
        'Invokers prepare data for a request to a remote web service, and process its response data.' =>
            'Vichochezi vinaanda data kwa ajili ya kuomba huduma ya tovuti ya mbali, na ina shughulikia data zake za majibu.',
        'Controller' => 'mtawala',
        'Inbound mapping' => 'Kuunganishwa kulikofungwa ndani',
        'Outbound mapping' => 'Kuunganishwa kulikofungwa nje',
        'Delete this action' => 'kufuta hatua hii',
        'At least one %s has a controller that is either not active or not present, please check the controller registration or delete the %s' =>
            'Japo kila %s moja ina kiendeshaji ambacho hakipo amilifu au hakipo, tafadhali angalia usajili wa kiendeshaji au futa %s',
        'Delete webservice' => 'Futa huduma ya tovuti',
        'Delete operation' => 'kufuta operesheni',
        'Delete invoker' => 'Tufa kisababishi ',
        'Clone webservice' => 'Nakili huduma ya tovuti.',
        'Import webservice' => 'Agiza huduma ya tovuti',

        # Template: AdminGenericInterfaceWebserviceHistory
        'GenericInterface Configuration History for Web Service %s' => 'Historia ya usanidi wa kiolesura cha jumla kwa ajili ya huduma %s ya wavuti',
        'Go back to Web Service' => 'Rudi nyuma kwenye huduma za tovuti',
        'Here you can view older versions of the current web service\'s configuration, export or even restore them.' =>
            'Hapa unaweza kuangalia matoleo yaliyopita ya usanidi wa huduma za tovuti za sasa, hamisha au zirudishe.',
        'Configuration History List' => 'Orodha ya historia ya usanidi',
        'Version' => 'toleo',
        'Create time' => 'Muda wa kutengeneza',
        'Select a single configuration version to see its details.' => 'Chagua toleo la usanidi mmoja kuona maelezo yake.',
        'Export web service configuration' => 'Hamisha usanidi wa huduma ya tovuti',
        'Restore web service configuration' => 'Rejesha usanidi wa huduma za wavuti.',
        'Do you really want to restore this version of the web service configuration?' =>
            'Je unataka kurejesha toleo hili la usanidi wa huduma za wavuti?',
        'Your current web service configuration will be overwritten.' => 'Usanidi wako wa sasa wa huduma za wavuti utaandikiwa kwa juu.',
        'Restore' => 'kurejesha',

        # Template: AdminGroup
        'WARNING: When you change the name of the group \'admin\', before making the appropriate changes in the SysConfig, you will be locked out of the administrations panel! If this happens, please rename the group back to admin per SQL statement.' =>
            'ONYO: Wakati unabadilisha jina la kikundi \'Kiongozi\', kabla ya kutengeneza mabadiliko sahihi katika usanidi wa mfumo, utafungiwa nje ya paneli ya uongozi! Kama hili likitokea, tafadhali kipe jina la zamani kikundi la kiongozi kwa kila kauli za SQL. ',
        'Group Management' => 'Usimamizi wa kundi',
        'Add group' => 'kuongeza kundi',
        'The admin group is to get in the admin area and the stats group to get stats area.' =>
            'Kikundi cha kiongozi kiingie katika eneo la kiongozi na kikundi cha takwimu ili kupata eneo la takwimu.',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...). ' =>
            'Tengeneza makundi mapya kushughulikia ruhusa za kupata kwa ajili makundi mbalimbali ya wakala (mfano idara ya manunuzi, idara ya usaidizi, idara mauzo)',
        'It\'s useful for ASP solutions. ' => 'Inatumika kwa ufumbuzi wa ASP.',
        'Add Group' => 'Kuongeza kundi',
        'Edit Group' => 'hariri kundi',

        # Template: AdminLog
        'System Log' => 'Batli ya mfumo',
        'Here you will find log information about your system.' => 'Hapa utakuta taarifa batli kuhusu mfumo wako.',
        'Hide this message' => 'kuficha ujumbe huu',
        'Recent Log Entries' => 'Miingio ya batli ya sasa.',

        # Template: AdminMailAccount
        'Mail Account Management' => 'Usimamizi wa akaunti za barua',
        'Add mail account' => 'kuongeza akaunti ya barua pepe',
        'All incoming emails with one account will be dispatched in the selected queue!' =>
            'Barua pepe zote zinazoingia zenye akaunti moja  zitatumwa kwenye foleni iliyochaguliwa. ',
        'If your account is trusted, the already existing X-OTRS header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' =>
            'Kama akounti ya inaaminika, tayari ipo katika kichwa cha X-OTRS kwa muda wa kuwasili (kwa kipaumbele,...) itatumika! Kichuja cha mkuu wa posta kitatumika.',
        'Delete account' => 'kufuta akaunti',
        'Fetch mail' => 'Pakua barua pepe',
        'Add Mail Account' => 'Kuongeza akaunti ya barua pepe',
        'Example: mail.example.com' => 'Mfano: barua pepe.mfano.com',
        'IMAP Folder' => 'Kabrasha la IMAP',
        'Only modify this if you need to fetch mail from a different folder than INBOX.' =>
            'Rekebisha hii tu kama unahitaji kupakua barua pepe kutoka kwenye kabrasha tofauti na kikasha cha ndani.',
        'Trusted' => 'kuaminiwa',
        'Dispatching' => 'Tuma',
        'Edit Mail Account' => 'Hariri akaunti ya barua pepe',

        # Template: AdminNavigationBar
        'Admin' => 'Kiongozi',
        'Agent Management' => 'Usimamizi wa wakala',
        'Queue Settings' => 'Mipangilio ya foleni',
        'Ticket Settings' => 'Mipangilio ya tiketi',
        'System Administration' => 'Msimamizi wa mfumo',
        'Online Admin Manual' => 'Mwongozo wa kiongozi wa mtandaoni',

        # Template: AdminNotification
        'Notification Management' => 'Usimamizi wa taarifa',
        'Select a different language' => 'chagua lugha nyingine',
        'Filter for Notification' => 'Chuja kwa ajili ya taarifa',
        'Notifications are sent to an agent or a customer.' => 'Taarifa zimetumwa kwa wakala au mteja',
        'Notification' => 'Taarifa',
        'Edit Notification' => 'Hariri taarifa',
        'e. g.' => 'Mfano',
        'Options of the current customer data' => 'Michaguo kwa data za mteja za sasa',

        # Template: AdminNotificationEvent
        'Add notification' => 'Ongeza taarifa',
        'Delete this notification' => 'Futa taarifa hii',
        'Add Notification' => 'Ongeza taarifa',
        'Ticket Filter' => 'Kichuja tiketi',
        'Article Filter' => 'Kichuja makala',
        'Only for ArticleCreate and ArticleSend event' => 'Kwaajili ya tukio la TengenezaMakala na TumaMakala tu',
        'Article type' => 'aina ya makala',
        'If ArticleCreate or ArticleSend is used as a trigger event, you need to specify an article filter as well. Please select at least one of the article filter fields.' =>
            'Kama TengenezaMakala au TumaMAkala inatumika kama kichocheo, unahitaji kubainisha kichuja makala pia. Tafadhali chagua japo uga wa kuchja makala mmoja',
        'Article sender type' => 'Aina ya mtumaji wa makala',
        'Subject match' => 'Kufafana kwa somo',
        'Body match' => 'kufanana kwa kiini',
        'Include attachments to notification' => 'Weka viambatanisho katika taarifa',
        'Recipient' => 'Mopokeaji',
        'Recipient groups' => 'Vikundi vya mpokeaji',
        'Recipient agents' => 'Mawakala wa mpokeaji',
        'Recipient roles' => 'Kazi za mpokeaji',
        'Recipient email addresses' => 'Anuani ya barua pepe ya mpokeaji',
        'Notification article type' => 'Aina ya taarifa ya makala',
        'Only for notifications to specified email addresses' => 'Kwa taarifa tu kwa barua pepe zilizobainishwa.',
        'To get the first 20 character of the subject (of the latest agent article).' =>
            'Kupata herufi 20 za kwanza za somo (kutoka kwa wakala wa karibuni)',
        'To get the first 5 lines of the body (of the latest agent article).' =>
            'Kupata mistari 5 ya kwanza ya kiini (kutoka kwa wakala wa makala wa karibuni)',
        'To get the first 20 character of the subject (of the latest customer article).' =>
            'Kupata herufi 20 za kwanza za somo (kutoka kwa makala ya mteja wa karibuni)',
        'To get the first 5 lines of the body (of the latest customer article).' =>
            'Kupata mistari 5 ya kwanza ya kiini (kutoka kwa makala ya mteja wa karibuni)',

        # Template: AdminOTRSBusinessInstalled
        'Manage %s' => 'Sisamia %s',
        'Downgrade to OTRS Free' => 'Kushusha kwenda OTRS huru',
        '%s makes contact regularly with cloud.otrs.com to check on available updates and the validity of the underlying contract.' =>
            '%s inakutana mara kwa mara na cloud.otrs.com kuangalia usasishwaji uliopo na uhalali mkataba wa msingi.',
        'Unauthorized Usage Detected' => 'Matumizi yasiidhinishwa yamegundulika',
        'This system uses the %s without a proper license! Please make contact with %s to renew or activate your contract!' =>
            'Mfumo huu unatumia %s bila leseni sahihi! Tafadhali fanya mawasiliano na %s kufanya upya au kuamilisha mkataba wako.',
        '%s not Correctly Installed' => '%s haija sanidiwa kiusahihi',
        'Your %s is not correctly installed. Please reinstall it with the button below.' =>
            '%s haijasanidiwa kiusahihi. Tafadhalii sanidi upya kwa kutumia kibonye hapo chini.',
        'Reinstall %s' => 'Sakinisha %s',
        'Your %s is not correctly installed, and there is also an update available.' =>
            '%s haijasanidiwa kiusahihi, na pia kuna usasishaji unapatikana.',
        'You can either reinstall your current version or perform an update with the buttons below (update recommended).' =>
            'Unaweza kusandi upya toleo lako la sasa au unaweza kufanya usasishwaji na kibonye hapo chini (Usasishwaji unapendekezwa).',
        'Update %s' => 'Sasisha %s',
        '%s Not Yet Available' => '%s Haipatikani bado',
        '%s will be available soon.' => '%s itapatikana baadae.',
        '%s Update Available' => '%s usasishwaji unapatikana',
        'An update for your %s is available! Please update at your earliest!' =>
            'Usasishwaji kwa ajili yako %s unapatikana! Tafadhali sasisha mapema.',
        '%s Correctly Deployed' => '%s imetumika kwa sahihi',
        'Congratulations, your %s is correctly installed and up to date!' =>
            'Hongera, %s imesanidiwa kwa usahihi na wa kisasa!',

        # Template: AdminOTRSBusinessNotInstalled
        'Upgrade to %s' => 'Boresha kwenda %s',
        '%s will be available soon. Please check again in a few days.' =>
            '%s itapatikana baadae. Tafadhali angalia tena baaada ya siku chache.',
        'Please have a look at %s for more information.' => 'Tafadhali angalia %s kwa taarifa zaidi.',
        'Your OTRS Free is the base for all future actions. Please register first before you continue with the upgrade process of %s!' =>
            'OTRS huru yako ni msingi wa vitendo vyote vijavyo. Tafadhali sajili kwanza kabla haujaendelea na mchakato wa kuboresha wa %s!',
        'Register this System' => 'Sajili mfumo huu',
        'System Registration is disabled for your system. Please check your configuration.' =>
            '',
        'Before you can benefit from %s, please contact %s to get your %s contract.' =>
            'Kabla haujafaidika kutoka %s, tafadhali wasiliana na %s kupata mkataba wako  %s ',
        'Connection to cloud.otrs.com via HTTPS couldn\'t be established. Please make sure that your OTRS can connect to cloud.otrs.com via port 443.' =>
            'Muunganisho kwenda cloud.otrs.com kupitia HTTPS haukuweza kuanzishwa. Tafadhali hakikisha OTRS yako inaweza kuunganishwa cloud.otrs.com kupitia kituo tarishi 443.',
        'With your existing contract you can only use a small part of the %s.' =>
            'Kwa mkataba wako uliokuwepo unaweza kutumia sehemu ndogo ya %s',
        'If you would like to take full advantage of the %s get your contract upgraded now! Contact %s.' =>
            'Kama ungependa kupata faida ya %s pandisha daraja mkataba wako sasa! Mkataba %s.',

        # Template: AdminOTRSBusinessUninstall
        'Cancel downgrade and go back' => 'Tufa ushushaji kurudi nyuma',
        'Go to OTRS Package Manager' => 'Rudi kwa msimamizi wa vifurushi vya OTRS ',
        'Sorry, but currently you can\'t downgrade due to the following packages which depend on %s:' =>
            'Samahani, lakini sasa huwezi kushusha kutokana na vifurushi vifuatavyo vinavyotegemea %s.',
        'Vendor' => 'Muuzaji',
        'Please uninstall the packages first using the package manager and try again.' =>
            'Tafadhali sakinusha vifurushi kwanza kwa kutumia kisimamizi cha vifurushi na jaribu tena.',
        'You are about to downgrade to OTRS Free and will lose the following features and all data related to these:' =>
            'Unakaribia kushusha kwenda kwenye OTRS huru na utapoteza vipengele vifuatavyo na data zote zinazohusiana na hiyo.',
        'Chat' => 'Ongea',
        'Timeline view in ticket zoom' => 'Mandhari ya mfululizo katika kikuzaji tiketi',
        'DynamicField ContactWithData' => 'Uga wenye nguvu wasiliana na data',
        'DynamicField Database' => '',
        'SLA Selection Dialog' => '',
        'Ticket Attachment View' => '',
        'The %s skin' => 'Gamba %s',

        # Template: AdminPGP
        'PGP Management' => 'Usimamizi PGP',
        'Use this feature if you want to work with PGP keys.' => 'Tumia kigezo hiki kama unataka kufanya kazi na funguo za PGP.',
        'Add PGP key' => 'Ongeza funguo za PGP',
        'In this way you can directly edit the keyring configured in SysConfig.' =>
            'Kwa njia hii unaweza ukahariri moja kwa moja keyring iliyosanidiwa katika mfumo sanidi.',
        'Introduction to PGP' => 'Utangulizi wa PGP',
        'Result' => 'Matokeo',
        'Identifier' => 'Kitambulisho',
        'Bit' => 'Biti',
        'Fingerprint' => 'Alama za vidole',
        'Expires' => 'Malizika',
        'Delete this key' => 'Futa funguo hii',
        'Add PGP Key' => 'Ongeza funguo ya PGP',
        'PGP key' => 'Funguo ya PGP ',

        # Template: AdminPackageManager
        'Package Manager' => 'Msimamiz wa kifurushi',
        'Uninstall package' => 'Futa kifurushi',
        'Do you really want to uninstall this package?' => 'Je unataka kufuta kifurushi hiki?',
        'Reinstall package' => 'Sakinisha kifurushi',
        'Do you really want to reinstall this package? Any manual changes will be lost.' =>
            'Je unahitaji kusakinisha kifurushi hiki? Mabaidliko yoyote ya mkono yatapotea.',
        'Continue' => 'Endelea',
        'Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            'Tafadhali hakikisha hifadhidata yako inakubali vifurushi vya ukubwa zaidi ya MB %s (kwa sasa inakubali vifurush hadi MB %s). Tafadhali kubaliana na mipangilio ya Upeo mkubwa_ulioruhusiwa_wa kifurushi ya hifadhidata yako ili kuzuia makosa.',
        'Install' => 'Sakinisha',
        'Install Package' => 'Sanikisha kifueushi',
        'Update repository information' => 'Sasisha taarifa zilizohifadhiwa',
        'Online Repository' => 'Hifadhi ya mtandaoni',
        'Module documentation' => 'Moduli za nyaraka',
        'Upgrade' => 'Kuboresha',
        'Local Repository' => 'Hifadhi ya ndani',
        'This package is verified by OTRSverify (tm)' => 'Kifurushi hiki kimethibitishwa na OTRSthibitisha (tm)',
        'Uninstall' => 'Sakinusha',
        'Reinstall' => 'Sakinisha',
        'Features for %s customers only' => 'Vipengele kwa wateja %s tu',
        'With %s, you can benefit from the following optional features. Please make contact with %s if you need more information.' =>
            'Na %s unaweza kufaidika na vipengele vifuatavyo vya hiari. Tafadhali weka mkataba na %s kama unataka taarifa zaidi.',
        'Download package' => 'Pakua kifurushi',
        'Rebuild package' => 'Jenga kifurushi',
        'Metadata' => 'Metadata',
        'Change Log' => 'Badili Kuingia',
        'Date' => 'Tarehe',
        'List of Files' => 'Orodha ya mafaili',
        'Permission' => 'Ruhusa',
        'Download' => 'Pakua',
        'Download file from package!' => 'Pakua faili kutoka kwenye kifurushi',
        'Required' => 'Hitajika',
        'PrimaryKey' => 'Funguo wa msingi',
        'AutoIncrement' => 'Ongeza kwa otomatiki',
        'SQL' => 'SQL',
        'File differences for file %s' => 'Tofauti ya faili kwa faili %s',

        # Template: AdminPerformanceLog
        'Performance Log' => 'Utendaji batli',
        'This feature is enabled!' => 'Kipengele hiki kimeruhusiwa!',
        'Just use this feature if you want to log each request.' => 'Tumia kipengele hiki kama unataka kuingia kila ombi.',
        'Activating this feature might affect your system performance!' =>
            'kuamilisha kipengele hiki kunaweza kuathisi utendaji wa mfumo wako! ',
        'Disable it here!' => 'Usiiruhusu hapa',
        'Logfile too large!' => 'Faili la batli ni kubwa sana!',
        'The logfile is too large, you need to reset it' => 'Faili la batli ni kubwa, unahitaji kuliweka tena',
        'Overview' => 'Mapitio',
        'Range' => 'Masafa',
        'last' => 'Mwisho',
        'Interface' => 'Kiolesura',
        'Requests' => 'Maombi',
        'Min Response' => 'Majibu ya kima cha chini',
        'Max Response' => 'Majibu ya kima cha juu',
        'Average Response' => 'Majibu wa wastani',
        'Period' => 'Kipindi',
        'Min' => 'Kima cha chini',
        'Max' => 'Kima cha juu',
        'Average' => 'Wastani',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => 'Usimamizi wa kichuja cha Mkuu wa kuchapisha',
        'Add filter' => 'Ongeza Kichuja',
        'To dispatch or filter incoming emails based on email headers. Matching using Regular Expressions is also possible.' =>
            'Kutuma au kuchuja barua pepe zinazoingia kulingana na kichwa cha habari za barua pepe. Fananisha kwa kutumia semi za mara kwa mara pia inawezekana.',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' =>
            'Kama unataka kufananisha barua pepe tu, tumia ANUANI YA BARUA PEPE: info@example.com kwa kutoka, kwenda au Cc.',
        'If you use Regular Expressions, you also can use the matched value in () as [***] in the \'Set\' action.' =>
            'Kama unatumia semi za mara kwa mara, pia unaweza kutumia thamani zinazofafana kwenye () kama [***] katika  kitendo cha \'Weka\'',
        'Delete this filter' => 'Futa kichuja hiki',
        'Add PostMaster Filter' => 'Ongeza kichuja Mkuu wa kuchapisha ',
        'Edit PostMaster Filter' => 'Hariri Kichuja Mkuu wa kuchapisha',
        'The name is required.' => 'Jina linahitajika',
        'Filter Condition' => 'Masharti ya kuchuja',
        'AND Condition' => 'Masharti ya AND',
        'Check email header' => 'Angalia kichwa cha habari cha barua pepe',
        'Negate' => 'Kanusha',
        'Look for value' => 'Angalia thamani',
        'The field needs to be a valid regular expression or a literal word.' =>
            'Uga unahitaji kuwa msemo wa mara kwa mara wa halali au neno halisi',
        'Set Email Headers' => 'Tuma kichwa cha habari cha barua pepe',
        'Set email header' => 'Weka kichwa cha habari cha barua pepe',
        'Set value' => 'Weka thamani',
        'The field needs to be a literal word.' => 'Uga unahitaji kuwa neno halisi',

        # Template: AdminPriority
        'Priority Management' => 'Usimamizi wa kipaumbele',
        'Add priority' => 'Ongeza kipaumbele',
        'Add Priority' => 'Ongeza Kipaumbele',
        'Edit Priority' => 'Hariri Kipaumbele',

        # Template: AdminProcessManagement
        'Process Management' => 'Usimamizi wa mchakato',
        'Filter for Processes' => 'Chuja kwa aijili ya mchakato',
        'Create New Process' => 'Tengeneza Mchakato mpya',
        'Deploy All Processes' => 'Tumia michakato yote',
        'Here you can upload a configuration file to import a process to your system. The file needs to be in .yml format as exported by process management module.' =>
            'Hapa unaweza kupakia faili la kusanidi kuleta mchakato katika mfumo wako. Faili linahitaji kuwa katika muundo wa .yml kama lilivyopelekwa na moduli ya usimamizi wa mchakato.',
        'Overwrite existing entities' => 'Andika juu ya vipengele halisi vilivyopo',
        'Upload process configuration' => 'Pakia usanidi wa mchakato',
        'Import process configuration' => 'Leta usanidi wa mchakato',
        'To create a new Process you can either import a Process that was exported from another system or create a complete new one.' =>
            'Kutengeenza mchakato mpya unaweza kuleta mchakato ambao uliumehamishwa kutoka kwenye mfumo mwingine au kutengeneza mpya uliokamilika.',
        'Changes to the Processes here only affect the behavior of the system, if you synchronize the Process data. By synchronizing the Processes, the newly made changes will be written to the Configuration.' =>
            'Mabadiliko katika michakato hapa inaadhiri tabia ya mfumo, kama unalandanisha data za mchakato. Kwa kulandanisha michakato, mabadiliko mapya yaliyofanywa yataandikwa kwneye usanidi.',
        'Process name' => 'Jina la mchakato',
        'Print' => 'Chapisha',
        'Export Process Configuration' => 'Hamisha usanidi wa mchakato',
        'Copy Process' => 'Nakili mchakato',

        # Template: AdminProcessManagementActivity
        'Cancel & close window' => 'Futa na funga window',
        'Go Back' => 'Rudi nyuma',
        'Please note, that changing this activity will affect the following processes' =>
            'Tafadhali zingatia kwamba kubadilisha hiki kitendo itaadhiri michakato ifuatayo',
        'Activity' => 'Shughuli',
        'Activity Name' => 'Jina la shughuli',
        'Activity Dialogs' => 'Mazungumzo ya shughuli',
        'You can assign Activity Dialogs to this Activity by dragging the elements with the mouse from the left list to the right list.' =>
            'Unaweza kugaia Kisanduku kidadisi cha shughuli kwa shughuli hii kwa kukokota elementi kwa panya kutoka kwenye orodha ya kushoto kwenda kwenye orodha ya kulia.',
        'Ordering the elements within the list is also possible by drag \'n\' drop.' =>
            'Kupanga elementi ndani ya orodha pia inawezekana kwa kukokota na kudondosha.',
        'Filter available Activity Dialogs' => 'Chuja mazungumzo yaliyopo ya shughuli',
        'Available Activity Dialogs' => 'Mazungumzo ya shughuli yaliyopo',
        'Create New Activity Dialog' => 'Tengeneza mazungumzo ya shughuli mapya',
        'Assigned Activity Dialogs' => 'Kupewa mazungumzo ya shughuli',
        'As soon as you use this button or link, you will leave this screen and its current state will be saved automatically. Do you want to continue?' =>
            'Punde uonapo kibonye hiki au kiunganishi hiki, utaiacha skrini na hali yake ya sasa itahifadhiwa otomatiki. Je unataka kuendelea?',

        # Template: AdminProcessManagementActivityDialog
        'Please note that changing this activity dialog will affect the following activities' =>
            'Tafadhali zingatia kwamba mazunguzo haya ya shughuli itaathiri shughuli zifuatazo',
        'Please note that customer users will not be able to see or use the following fields: Owner, Responsible, Lock, PendingTime and CustomerID.' =>
            'Tafadhali tambua kuwa watumiaji wa mteja hawataweza kuona au kutumia uga zifuatazo: Mmiliki, Kuwajibika, Funga, Muda wa kusubiri na kitambulisho cha mteja.',
        'The Queue field can only be used by customers when creating a new ticket.' =>
            'Uga wa foleni unaweza kutumika na wateja tu wakati wa kutengeneza tiketi mpya.',
        'Activity Dialog' => 'Kikadisi cha shughuli',
        'Activity dialog Name' => 'Jina la kidadisi cha shughuli',
        'Available in' => 'Inapatikana kwa ',
        'Description (short)' => 'Maelezo (fupi)',
        'Description (long)' => 'Maelezo (Ndefu)',
        'The selected permission does not exist.' => 'Ruhusa ilichaguliwa haipo.',
        'Required Lock' => 'Kufuli inayohitajika',
        'The selected required lock does not exist.' => 'Kufuli inayohitajika iliyochaguliwa haipo.',
        'Submit Advice Text' => 'Kusanya matini ya ushauri',
        'Submit Button Text' => 'Kusanya kitufe cha matini',
        'Fields' => 'Uga',
        'You can assign Fields to this Activity Dialog by dragging the elements with the mouse from the left list to the right list.' =>
            'Unaweza kugaia uga kwa Kisanduku kidadisi hiki cha shughuli kwa kukokota elementi kwa panya kutoka kwenye orodha ya kushoto kwenda kwenye orodha ya kulia.',
        'Filter available fields' => 'Chuja Uga zinazopatika',
        'Available Fields' => 'Uga uliopo',
        'Assigned Fields' => 'Uga zilizogaiwa',
        'Edit Details for Field' => 'Hariri maelezo ya uga',
        'ArticleType' => 'Aina ya makala',
        'Display' => 'Onyesha',
        'Edit Field Details' => 'Hariri maelezo ya uga',
        'Customer interface does not support internal article types.' => 'Kiole cha mteja hakisaidii aina za makala za ndani.',

        # Template: AdminProcessManagementPath
        'Path' => 'Njia',
        'Edit this transition' => 'Hariri mpito huu',
        'Transition Actions' => 'Matendo ya mpito',
        'You can assign Transition Actions to this Transition by dragging the elements with the mouse from the left list to the right list.' =>
            'Unaweza kugaia matendo mpito kwa huu mpito kwa kukokota elementi kwa panya kutoka kwenye orodha ya kushoto kwenda kwenye orodha ya kulia.',
        'Filter available Transition Actions' => 'Chuja matendo ya mpito yanayopatikana',
        'Available Transition Actions' => 'Matendo ya mpito yanayopatikana',
        'Create New Transition Action' => 'Tengeneza tendo jipya la mpito.',
        'Assigned Transition Actions' => 'Matendo ya mpito yaliyogaiwa',

        # Template: AdminProcessManagementProcessAccordion
        'Activities' => 'Shughuli',
        'Filter Activities...' => 'Chuja shughuli',
        'Create New Activity' => 'Tengeneza shughuli nyingine',
        'Filter Activity Dialogs...' => 'Chuja Kidadisi cha shughuli ',
        'Transitions' => 'Mapito',
        'Filter Transitions...' => 'Chuja mapito',
        'Create New Transition' => 'Tengeneza mpito mpya',
        'Filter Transition Actions...' => 'Chuja matendo ya mpito...',

        # Template: AdminProcessManagementProcessEdit
        'Edit Process' => 'Hariri mchakato',
        'Print process information' => 'Chapa taarifa za mchakato',
        'Delete Process' => 'Futa mchakato',
        'Delete Inactive Process' => 'Futa michakato isiyoamilifu.',
        'Available Process Elements' => 'Elementi za mchakato zinazopatikana',
        'The Elements listed above in this sidebar can be moved to the canvas area on the right by using drag\'n\'drop.' =>
            'Elementi zilizoorozeshwa juu ya huu mwambaa upande unawezwa kuhamishwa eneo la kanvasi kulia kwa kutumia kokota na dondosha.',
        'You can place Activities on the canvas area to assign this Activity to the Process.' =>
            'Unaweza kuweka shuguli kwenye eneo la kanvasi ili kugawa hili tukio kwa mchakato.',
        'To assign an Activity Dialog to an Activity drop the Activity Dialog element from this sidebar over the Activity placed in the canvas area.' =>
            'Kuipa mazungumzo ya shuguli shughuli dondosha kipengele cha mazungumzo ya shughuli kutoka kwenye mwambaa upande huu juu ya shughuli iliyowekwa katika kanvasi.  ',
        'You can start a connection between to Activities by dropping the Transition element over the Start Activity of the connection. After that you can move the loose end of the arrow to the End Activity.' =>
            'Unaweza ukanza muunganiko kati ya shughuli kwa kudondosha kipengele cha mpito juu ya Anza Shughuli ya muunganisho. Baada ya hapo unaweza kuhamisha upande ulio huru wa mshale kwa Maliza shughuli.',
        'Actions can be assigned to a Transition by dropping the Action Element onto the label of a Transition.' =>
            'Vitendo vinaweza kugaiwa kwa Mpito kwa kudondosha Kipengele cha kitendo katika lebo ta Mpito.',
        'Edit Process Information' => 'Hariri taarifa za mchakato',
        'Process Name' => 'Jina la mchakato',
        'The selected state does not exist.' => 'Hali iliyochaguliwa haipo.',
        'Add and Edit Activities, Activity Dialogs and Transitions' => 'Ongeza na hariri shuguli, mazungumzo ya shuguli na mipito',
        'Show EntityIDs' => 'Onyesha kitambulisho cha ingizo',
        'Extend the width of the Canvas' => 'Ongeza upana wa kanvasi.',
        'Extend the height of the Canvas' => 'Ongeza urefu wa kanvasi.',
        'Remove the Activity from this Process' => 'Ondoa shughuli kutoka kwenye mchakato huu.',
        'Edit this Activity' => 'Hariri shughuli hii',
        'Save settings' => 'Hifadhi mipangilio',
        'Save Activities, Activity Dialogs and Transitions' => 'Hifadhi shuguli, mazungumzo ya shuguli na mipito',
        'Do you really want to delete this Process?' => 'Je unataka kufuta mchakato huu?',
        'Do you really want to delete this Activity?' => 'Je unataka kufuta shughuli hii?',
        'Do you really want to delete this Activity Dialog?' => 'Je unataka kufuta Kidadisi kitendo?',
        'Do you really want to delete this Transition?' => 'Je unataka kufuta mpito huu?',
        'Do you really want to delete this Transition Action?' => 'Je unataka kufuta kitendo hiki cha mpito?',
        'Do you really want to remove this activity from the canvas? This can only be undone by leaving this screen without saving.' =>
            'Je unataka kutoa kitendo hiki kwenye kanvasi? Hii inaweza kutokufanywa kwa kutoka kwenye skrini hii bila kuhifadhi. ',
        'Do you really want to remove this transition from the canvas? This can only be undone by leaving this screen without saving.' =>
            'Je unataka kutoa mpito huu kwenye kanvasi? Hii inaweza kutokufanywa kwa kutoka kwenye skrini hii bila kuhifadhi. ',
        'Hide EntityIDs' => 'Ficha kitambulisho cha ingizo',
        'Delete Entity' => 'Futa kipengee halisi',
        'Remove Entity from canvas' => 'Ondoa kipengee halisi kutoka kwenye kanvasi.',
        'This Activity is already used in the Process. You cannot add it twice!' =>
            'Shuguli tayari imetumika katika mchakato. Huwezi kuongeza kwa mara ya pili.',
        'This Activity cannot be deleted because it is the Start Activity.' =>
            'Shughuli haiwezi kufutwa kwasababu ni shughuli ya kuanza.',
        'This Transition is already used for this Activity. You cannot use it twice!' =>
            'Mpito huu umeshatumika katika shughuli hii. Huwezi kutumia mara mbili!',
        'This TransitionAction is already used in this Path. You cannot use it twice!' =>
            'Kitendo cha mpito huu kimeshatumika katika njia hii. Huwezi kutumia mara mbili!',
        'Remove the Transition from this Process' => 'Ondoa mpito kutoka kwenye mchakato huu.',
        'No TransitionActions assigned.' => 'Hakuna vitendo vya mpito vilivyogawiwa.',
        'The Start Event cannot loose the Start Transition!' => 'Kitendo cha kuanza hakiwezi kupoteza mpito wa kuanza!',
        'No dialogs assigned yet. Just pick an activity dialog from the list on the left and drag it here.' =>
            'Hakuna Kidadisi kilochogaiwa. Chukua kikadisi shughuli kutoka kwenye orodha kushoto na ikokote hapa.',
        'An unconnected transition is already placed on the canvas. Please connect this transition first before placing another transition.' =>
            'Mpito usiounganishwa tayari umefanyika katika kanvasi. Tafadhali unganisha mpito huu kwanza kabla haujaweka mpito mwingine.',

        # Template: AdminProcessManagementProcessNew
        'In this screen, you can create a new process. In order to make the new process available to users, please make sure to set its state to \'Active\' and synchronize after completing your work.' =>
            'Katika skrini hii, unaweza kutengeneza mchakato mpya. Ili kufanya mchakato mpya utakaopatikana kwa watumiaji, tafadhali hakikisha unaweka hali yake kuwa \'Amilifu\' na landanisha baada ya kumaliza kazi yako.',

        # Template: AdminProcessManagementProcessPrint
        'Start Activity' => 'Anza shughuli',
        'Contains %s dialog(s)' => 'Yenye %s mazungumzo',
        'Assigned dialogs' => 'Mazungumzo yaliyogaiwa',
        'Activities are not being used in this process.' => 'Shughuli hazitumiki katika mchakato huu.',
        'Assigned fields' => 'Uga zilizogaiwa',
        'Activity dialogs are not being used in this process.' => 'Mazungumzo ya shughuli hayatumiki katika mchakato huu.',
        'Condition linking' => 'Kuunganisha masharti',
        'Conditions' => 'Masharti',
        'Condition' => 'Sharti',
        'Transitions are not being used in this process.' => 'Mipito haitumiki katika mchakato huu.',
        'Module name' => 'Jina la moduli',
        'Configuration' => 'Usanidi',
        'Transition actions are not being used in this process.' => 'Vitendo vya mipito havitumiki katika mchakato huu.',

        # Template: AdminProcessManagementTransition
        'Please note that changing this transition will affect the following processes' =>
            'Tafadhali zingatia kwamba kubadili mpito huu utaathiri michakato ifuatayo',
        'Transition' => 'Mpito',
        'Transition Name' => 'Jina la mpito',
        'Type of Linking between Conditions' => 'Aina ya kunganisha kati ya masharti',
        'Remove this Condition' => 'Ondoa sharti hili',
        'Type of Linking' => 'Aina ya kiunganishi',
        'Remove this Field' => 'Ondoa uga huu',
        'And can\'t be repeated on the same condition.' => '',
        'Add a new Field' => 'Ongeza uga mpya',
        'Add New Condition' => 'Ongeza sharti jipya',

        # Template: AdminProcessManagementTransitionAction
        'Please note that changing this transition action will affect the following processes' =>
            'Tafadhani zingatia kwamba ubadilishaji wa mpito huu utaathiri michakato ifuatayo',
        'Transition Action' => 'Kitendo cha mpito',
        'Transition Action Name' => 'Jina la kitendo cha mpito',
        'Transition Action Module' => 'Moduli ya kitendo cha mpito',
        'Config Parameters' => 'Vigezo vya usanidi',
        'Remove this Parameter' => 'Ondoa hiki kigezo',
        'Add a new Parameter' => 'Ongeza kigezo kipya',

        # Template: AdminQueue
        'Manage Queues' => 'Simamia foleni',
        'Add queue' => 'Ongeza foleni',
        'Add Queue' => 'Ongeza Foleni',
        'Edit Queue' => 'Hariri Foleni',
        'A queue with this name already exists!' => '',
        'Sub-queue of' => 'Foleni ya ',
        'Unlock timeout' => 'Fungua muda kuisha',
        '0 = no unlock' => '0= hakuna kutokufunga',
        'Only business hours are counted.' => 'Masaa ya kazi tu ndo yanahesabika.',
        'If an agent locks a ticket and does not close it before the unlock timeout has passed, the ticket will unlock and will become available for other agents.' =>
            'Kama wakala amefunga tiketi na hajaifungua kabla ya muda wa wa kuisha kupita, tiketi itafunguliwa na na itakuwa inapatikana kwa mawakala wengine.',
        'Notify by' => 'Taarifu kwa',
        '0 = no escalation' => '0= hakuna kupanda',
        'If there is not added a customer contact, either email-external or phone, to a new ticket before the time defined here expires, the ticket is escalated.' =>
            'Kama hakuna anwani ya mteja iliyoongezwa, barua pepe au simu, kwenye tiketi mpya kabla ya muda uliofafanuliwa hapa haujaisha, tiketi itapandishwa.',
        'If there is an article added, such as a follow-up via email or the customer portal, the escalation update time is reset. If there is no customer contact, either email-external or phone, added to a ticket before the time defined here expires, the ticket is escalated.' =>
            'Kama kuna makala imeongezwa, kama ufuatiliaji kwa barua pepe au kituo cha mteja, muda wa kuenea wa kusasishwa umewekwa upya. Kama hakuna anuani ya mteja, au barua pepe ya nje au simu, iliyoongezwa kwenye tiketi kabla ya muda uliofafanuliwa hapa haujaisha, tiketi itaenezwa',
        'If the ticket is not set to closed before the time defined here expires, the ticket is escalated.' =>
            'Kama tiketi imewekwa kufungwa kabla ya muda ulioowekwa hapa haujaisha, tiketi itaenezwa.',
        'Follow up Option' => 'Chaguo la kufuatilia',
        'Specifies if follow up to closed tickets would re-open the ticket, be rejected or lead to a new ticket.' =>
            'Bainisha kama ufuatiliaji kwa tiketi zilizofungwa utafungua tiketi, kataliwa au itasababisha tiketi mpya.',
        'Ticket lock after a follow up' => 'Tiketi imefungwa baada ya ufuatiliaji.',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked to the old owner.' =>
            'Kama tiketi imefungwa na mteja ametuma ufuatiliaji tiketi itafunguliwa kwa mmiliki wa zamani.',
        'System address' => 'Anuani ya mfumo',
        'Will be the sender address of this queue for email answers.' => 'Itakuwa anuani ya mtumaji wa foleni kwa majibu ya barua pepe.',
        'Default sign key' => 'Funguo ya alama chaguo msingi',
        'The salutation for email answers.' => 'Salamu kwa majibu ya barua pepe',
        'The signature for email answers.' => 'Saini kwa majibu ya barua pepe',

        # Template: AdminQueueAutoResponse
        'Manage Queue-Auto Response Relations' => 'Simamia mahusiano ya majibu ya otomatiki ya foleni',
        'Filter for Queues' => 'Chuja kwa ajili ya foleni',
        'Filter for Auto Responses' => 'Chuja kwa ajili ya majibu ya otomatiki.',
        'Auto Responses' => 'Majibu ya otomatiki',
        'Change Auto Response Relations for Queue' => 'Badili mahusiano ya majibu ya otomatiki kwa ajili ya foleni',

        # Template: AdminQueueTemplates
        'Manage Template-Queue Relations' => 'Simamia mahusiano ya kielezo cha foleni.',
        'Filter for Templates' => 'Kichujio cha kielezo',
        'Templates' => 'Kielezo',
        'Change Queue Relations for Template' => 'Badili mahusiano ya foleni kwa ajili ya kielezo',
        'Change Template Relations for Queue' => 'Badili mahusiano ya foleni kwa ajili ya foleni',

        # Template: AdminRegistration
        'System Registration Management' => 'Usimamizi usajili wa mfumo',
        'Edit details' => 'Hariri maelezo',
        'Show transmitted data' => 'Onyesha data zilizotumwa',
        'Deregister system' => 'Futa usajili wa mfumo',
        'Overview of registered systems' => 'Marejeo ya mifumo iliyosajiliwa',
        'System Registration' => 'Usajili wa mfumo',
        'This system is registered with OTRS Group.' => 'Huu mfumo umesajiliwa na kikundi cha OTRS',
        'System type' => 'Aina ya mfumo',
        'Unique ID' => 'Kitambulisho cha kipekee',
        'Last communication with registration server' => 'Mawasiliano ya mwisho na seva ya usajili.',
        'Send support data' => 'Tuma data za kusaidia',
        'System registration not possible' => '',
        'Please note that you can\'t register your system if your scheduler is not running correctly!' =>
            '',
        'Instructions' => '',
        'System deregistration not possible' => 'Kutoa usajili wa mfumo haiwezekani',
        'Please note that you can\'t deregister your system if you\'re using the %s or having a valid service contract.' =>
            'Tafadhali zingatia kwamba hauwezi kutoa usajili katika mfumo wako kama unatumia %s au una mkataba wa huduma ulio halali.',
        'OTRS-ID Login' => 'OTRS- ingia na kitambulidho',
        'System registration is a service of OTRS Group, which provides a lot of advantages!' =>
            'Usajili wa mfumo ni huduma ya kikundi cha OTRS, ambacho kina faida nyingi.',
        'Read more' => 'Soma zaidi',
        'You need to log in with your OTRS-ID to register your system.' =>
            'Unahitaji kuingia na kitambulisho chako cha OTRS kusajili mfumo wako.',
        'Your OTRS-ID is the email address you used to sign up on the OTRS.com webpage.' =>
            'Kitambulisho chako cha OTRS ni barua pepe uliyotumia kujiunga katika ukurasa wa tovuti wa OTRS.com',
        'Data Protection' => 'Ulinzi wa data',
        'What are the advantages of system registration?' => 'Nini faida za usajili wa mfumo?',
        'You will receive updates about relevant security releases.' => 'Utapokea habari kuhusu matoleo yanayohusiana na usalama.',
        'With your system registration we can improve our services for you, because we have all relevant information available.' =>
            'Kwa usajili wako wa mfumo tutaboresha huduma zetu kwa ajili yako, kwasababu tuna tarifa zote zinazohusika.',
        'This is only the beginning!' => 'Huu ni mwanzo tu!',
        'We will inform you about our new services and offerings soon.' =>
            'Tutakupa taarifa kuhusu huduma zetu mpya na ofa karibuni.',
        'Can I use OTRS without being registered?' => 'Je ninawezakutumia OTRS bila kujisajili?',
        'System registration is optional.' => 'Usajili wa mfumo ni mzuri.',
        'You can download and use OTRS without being registered.' => 'Unaweza kupakua na kutumia OTRS bila kusajiliwa.',
        'Is it possible to deregister?' => 'Inawezeka kujifuta?',
        'You can deregister at any time.' => 'Unaweza kujitoa muda wowote',
        'Which data is transfered when registering?' => 'Data gani zinatumwa wakati wa usajili?',
        'A registered system sends the following data to OTRS Group:' => 'Mfumo uliosajiliwa unatuma data zifuatazo kwenda kwenye kikundi cha OTRS:',
        'Fully Qualified Domain Name (FQDN), OTRS version, Database, Operating System and Perl version.' =>
            'Jina ka Kikoa lilifuzu Kamili (FQDN), Toleo la OTRS, Hifadhi data, Mfumo endeshi na Toleo la Perl.',
        'Why do I have to provide a description for my system?' => 'Kwanini nitoe maelezo kwa ajili ya mfumo wangu.',
        'The description of the system is optional.' => 'Maelezo ya mfumo ni wa hiari.',
        'The description and system type you specify help you to identify and manage the details of your registered systems.' =>
            'Maelezo na aina ya mfumo unaobainisha unakusaidia kugundua na kusimamia maelezo ya mfumo wako uliosajiliwa.',
        'How often does my OTRS system send updates?' => 'Ni kila baada ya muda gani mfumo wangu wa OTRS unatuma ushasishwaji?',
        'Your system will send updates to the registration server at regular intervals.' =>
            'Mfumo utatuma visasihi kwenye seva ya usajili kila baada ya muda flani.',
        'Typically this would be around once every three days.' => 'Hii itakuwa kila mara moja kila  siku tatu',
        'In case you would have further questions we would be glad to answer them.' =>
            'Kama una maswali zaidi tungependa kuyajibu.',
        'Please visit our' => 'Tafadhali tembelea',
        'portal' => 'Kituo',
        'and file a request.' => 'Na ombi la faili.',
        'Here at OTRS Group we take the protection of your personal details very seriously and strictly adhere to data protection laws.' =>
            'Hapa katika kikundi cha OTRS tunahukulia ulinzi wa taarifa zako binafsi kwa makini na tunakubalina na sheria za ulinzi wa data.',
        'All passwords are automatically made unrecognizable before the information is sent.' =>
            'Maneno yote ya siri yanatengenezwa otomatiki bila kutambulika kabla ya taarifa kutumwa.',
        'Under no circumstances will any data we obtain be sold or passed on to unauthorized third parties.' =>
            'Si kwa namna yoyote data yoyote tunayoipata itauzwa au kupwa upande usiokuwa na mmalaka ',
        'The following explanation provides you with an overview of how we guarantee this protection and which type of data is collected for which purpose.' =>
            'Maelezo yafuatayo yanakupa muonekano wa jinsi tunavyodhamini ulinzi huu na data za aina gani zinachukuliwa na kwa malengo gani.',
        'Data Handling with \'System Registration\'' => 'Utunzaji wa data na \'Usajili wa Mfumo\'.',
        'Information received through the \'Service Center\' is saved by OTRS Group.' =>
            'Taarifa zilizopokelewa kupitia \'Kituo cha huduma\' zimehifadhiwa na kikundi cha OTRS.',
        'This only applies to data that OTRS Group requires to analyze the performance and function of the OTRS server or to establish contact.' =>
            'Hii inatumika tu kwenye data ambazo kikundi cha  OTRS inahitaji kuchunguza utendaji na kazi za seva ya OTRS au kuanzisha mawasiliano.  ',
        'Safety of Personal Details' => 'Usalama wa maelezo binafsi.',
        'OTRS Group protects your personal data from unauthorized access, use or publication.' =>
            'Kikundi cha OTRS kinalinda data zako binafsi kuzuia mamlaka zisizoruhusiwa kufikia, kutumia au kuweka kwenye umma.',
        'OTRS Group ensures that the personal information you store on the server is protected from unauthorized access and publication.' =>
            'Kikundi ch aOTRS kinahakikisha kwamba taarifa zako binafsi unazohifadhi kwenye seva zinalindwa dhidi ya ufikivu usiohalalishwa na umma.',
        'Disclosure of Details' => 'Kutoa taarifa za maelezo',
        'OTRS Group will not pass on your details to third parties unless required for business transactions.' =>
            'Kikundi cha OTRS kitatoa taarifa zako kwenda kwa watu wa nje isipokuwa zitahitajika kwa ajili ya miamala wa biashara.',
        'OTRS Group will only pass on your details to entitled public institutions and authorities if required by law or court order.' =>
            'Kikundi cha OTRS kitatoa taarifa zako kwenda kwenye taasisi ya umma inayostahili na mamlaka kama itahitajika na sheria au amri kutoka mahakamani.',
        'Amendment of Data Protection Policy' => 'Marekebisho ya Sera ya ulinzi wa data',
        'OTRS Group reserves the right to amend this security and data protection policy if required by technical developments.' =>
            'Kikundi cha OTRS kinahifadhi haki za kubadilisha ulinzi huu na sera ya ulinzi ya data kama unahitajika na maendeleo ya kiufundi.',
        'In this case we will also adapt our information regarding data protection accordingly.' =>
            'Kwa jambo hili tutakabiliana na taarifa kuhusiana na ulinzi wa data.',
        'Please regularly refer to the latest version of our Data Protection Policy.' =>
            'Tafadhali rejea mara nyingi kwenye toleo la sasa la Sera za ulinzi wa data.',
        'Right to Information' => 'Haki kwa taarifa',
        'You have the right to demand information concerning the data saved about you, its origin and recipients, as well as the purpose of the data processing at any time.' =>
            'Una haki ya kuomba taarifa kuhusina na data zilizohifadhiwa kuhusu wewe, chanzo chake na mpokeaji, na pia kusudi la kukokotoa data muda wowote.',
        'You can request information about the saved data by sending an e-mail to info@otrs.com.' =>
            'Unaweza kuomba taarifa kuhusu data zilizohifadhiwa kwa kutuma barua pepe kwenda info@otrs.com.',
        'Further Information' => 'Taarifa zaidi',
        'Your trust is very important to us. We are willing to inform you about the processing of your personal details at any time.' =>
            'Uaminifu wako ni muhimu kwetu. Tuko tayari kukutaarifu kuhusu mchakato wa maelezo yako binafsi muda wowote.',
        'If you have any questions that have not been answered by this Data Protection Policy or if you require more detailed information about a specific topic, please contact info@otrs.com.' =>
            'Kama una maswali ambayo hayajajibiwa na sera ya ulinzi wa data au kama unahitaji maelezo ya taarifa zaidi kuhusu kuhusu mada maalum, tafadhali wasiliana na  info@otrs.com.',
        'If you deregister your system, you will lose these benefits:' =>
            'Kama utatoa usajili katika mfumo wako, utapoteza manufaa haya.',
        'You need to log in with your OTRS-ID to deregister your system.' =>
            'Unahitaji kuingia na kitambulisho chako cha OTRS kutoa usajili katika mfumo wako.',
        'OTRS-ID' => 'Kitambulisho cha OTRS',
        'You don\'t have an OTRS-ID yet?' => 'Hauna kitambulisho cha OTRS bado?',
        'Sign up now' => 'Jiandikishe sasa',
        'Forgot your password?' => 'Umesahau neno lako la siri?',
        'Retrieve a new one' => 'Pata jipya',
        'This data will be frequently transferred to OTRS Group when you register this system.' =>
            'Data hii itahamishwa mara kwa mara kwenye kikundi cha OTRS ukisajili katika mfumo huu.',
        'Attribute' => 'Sifa',
        'FQDN' => 'FQDN',
        'Optional description of this system.' => 'Maelezo mafupi ya hiari ya mfumo huu.',
        'This will allow the system to send additional support data information to OTRS Group.' =>
            'Hii itaruhusu mfumo kutuma taarifa za data nyongeza kwenye kikundi cha OTRS.',
        'Service Center' => 'Kituo cha huduma',
        'Support Data Management' => 'Usimamizi wa data za usaidizi.',
        'Register' => 'Usajili',
        'Deregister System' => 'Kufuta usajili wa mfumo',
        'Continuing with this step will deregister the system from OTRS Group.' =>
            'Endelea na hatua hii itafuta usajili wa mfumo kutoka kikundi cha OTRS.',
        'Deregister' => 'Ondoa usajili',
        'You can modify registration settings here.' => 'Unaweza kurekebisha mipangilio ya usajili hapa',
        'Overview of transmitted data' => 'Mapitio ya data zilizotumwa',
        'There is no data regularly sent from your system to %s.' => 'Hakuna data za mara kwa mara zinazotumwa katika mfumo wako kwenda %s.',
        'The following data is sent at minimum every 3 days from your system to %s.' =>
            'Data ifuatayo inatumwa kila siku 3 katika katika mfumo wako %s.',
        'The data will be transferred in JSON format via a secure https connection.' =>
            'Data itatumwa katika umbizo la JSON kupitia muunganisho wa salama wa https.',
        'System Registration Data' => 'Data ya usajili wa mfumo',
        'Support Data' => 'Data za masaada',

        # Template: AdminRole
        'Role Management' => 'Usimamizi wa jukumu',
        'Add role' => 'Ongeza jukumu',
        'Create a role and put groups in it. Then add the role to the users.' =>
            'Tengeneza jukumu na weka makundi ndani yake. Halafu ongeza jukumu kwa watumiaji.',
        'There are no roles defined. Please use the \'Add\' button to create a new role.' =>
            'Hakuna majukumu yalifafanuliwa.Tafadhali tumia kitufe \'Ongeza\' kutengeneza jukumu jipya.',
        'Add Role' => 'Ongeza jukumu',
        'Edit Role' => 'Hariri jukumu',

        # Template: AdminRoleGroup
        'Manage Role-Group Relations' => 'Simamia mahusiano ya Jukumu-Kikundi',
        'Filter for Roles' => 'Chuja kwa ajili ya majukumu',
        'Select the role:group permissions.' => 'Chagua jukumu: Ruhusa za kikundi',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the role).' =>
            'Kama hakuna kilichochaguliwa, kutakuwa hakuna ruhusa katika kikundi hiki (tiketi hazitapatikana kwa ajili ya jukumu).  ',
        'Change Role Relations for Group' => 'Badilisha mahusiano ya jukumu kwa kikundi',
        'Change Group Relations for Role' => 'Badili mahusiano ya kikundi kwa jukumu',
        'Toggle %s permission for all' => 'Geuza ruhusa %s kwa wote',
        'move_into' => 'Hamisha_Utambulisho',
        'Permissions to move tickets into this group/queue.' => 'Ruhusa za kuhamisha tiketi katika kikundi/foleni.',
        'create' => 'Tengeneza',
        'Permissions to create tickets in this group/queue.' => 'Ruhusa ya kutengeneza tiketi katika kikundi/foleni.',
        'note' => 'Kidokezo',
        'Permissions to add notes to tickets in this group/queue.' => 'Ruhusa za kuongeza vidokezo kwenye tiketi katika kikundi/foleni.',
        'owner' => 'Mmiliki',
        'Permissions to change the owner of tickets in this group/queue.' =>
            'Ruhusa za kubadili mmiliki wa tiketi katika kikundi hiki/foleni.',
        'priority' => 'Kipaumbele',
        'Permissions to change the ticket priority in this group/queue.' =>
            'Ruhusa za kubadilisha kipaumbele cha tiketi katika kikundi/foleni.',

        # Template: AdminRoleUser
        'Manage Agent-Role Relations' => 'Simamia mahusiano ya Wakala-Jukumu',
        'Filter for Agents' => 'Chuja kwa ajili ya wakala',
        'Manage Role-Agent Relations' => 'Simamia mahusiano ya Jukumu-Wakala',
        'Change Role Relations for Agent' => 'Badili mahusiano ya jukumu kwa wakala',
        'Change Agent Relations for Role' => 'Badili mahusiano ya wakala kwa jukumu',

        # Template: AdminSLA
        'SLA Management' => 'Usimamizi wa SLA',
        'Add SLA' => 'Ongeza SLA',
        'Edit SLA' => 'Hariri SLA',
        'Please write only numbers!' => 'Tafadhali andika namba tu!',

        # Template: AdminSMIME
        'S/MIME Management' => 'Usimamizi wa S/MIME ',
        'Add certificate' => 'Ongeza cheti',
        'Add private key' => 'Ongeza kibonye binafsi',
        'Filter for certificates' => 'Chuja kwa ajili ya vyeti',
        'Filter for S/MIME certs' => 'Chuja kwa ajili ya vyeti vya S/MIME ',
        'To show certificate details click on a certificate icon.' => 'Kuonyesha undani wa vyeti bofya kwenye ikoni ya cheti',
        'To manage private certificate relations click on a private key icon.' =>
            'Kusimamia mahusiano ya cheti binafsi bofya kwenye ikoni ya kibonye binafsi.',
        'Here you can add relations to your private certificate, these will be embedded to the S/MIME signature every time you use this certificate to sign an email.' =>
            'Hapa unaweza kuongeza mahusiano katika cheti chako binafsi, hizi zitajificha kwenye saini ya S/MIME muda wote unaotumia hiki cheti kusaini barua pepe. ',
        'See also' => 'Pia ona',
        'In this way you can directly edit the certification and private keys in file system.' =>
            'Kwa njia hii unaweza moja kwa moja kuhariri cheti na kibonye binafsi katika mfumo wa faili.',
        'Hash' => 'Kali',
        'Handle related certificates' => 'Mudu vyeti vinanyohusiana',
        'Read certificate' => 'Soma vyeti',
        'Delete this certificate' => 'Futa cheti hiki',
        'Add Certificate' => 'Ongeza cheti',
        'Add Private Key' => 'Ongeza kibonye binafsi',
        'Secret' => 'Siri',
        'Related Certificates for' => 'Vyeti vinavyohusiana ',
        'Delete this relation' => 'Futa huu uhusiano ',
        'Available Certificates' => 'Vyeti vinavyopatikana',
        'Relate this certificate' => 'Husisha hiki cheti',

        # Template: AdminSMIMECertRead
        'Close window' => 'Funga window',
        'Certificate details' => 'Maelezo ya ndani ya cheti',

        # Template: AdminSalutation
        'Salutation Management' => 'Usimamizi wa salamu',
        'Add salutation' => 'Ongeza salamu',
        'Add Salutation' => 'Ongeza Salamu',
        'Edit Salutation' => 'Hariri salamu',
        'Example salutation' => 'Mfano wa salamu',

        # Template: AdminSecureMode
        'Secure mode needs to be enabled!' => 'Hali timizi salama inahitaji kuwezeshwa!',
        'Secure mode will (normally) be set after the initial installation is completed.' =>
            'Hali timizi salama (kawaida) itawekwa baada ya usanidi wa kwanza kumalizika.',
        'If secure mode is not activated, activate it via SysConfig because your application is already running.' =>
            'Kama hali timizi salama haijaamilishwa, amilisha kwa kupitia Usanidi wa Mfumo kwasababu programu tumizi tayari inafanya kazi.',

        # Template: AdminSelectBox
        'SQL Box' => 'Kisanduku cha SQL',
        'Here you can enter SQL to send it directly to the application database. It is not possible to change the content of the tables, only select queries are allowed.' =>
            'Hapa unaweza kuingia SQL kutuma moja kwa moja kwenye hifadhi data ya programu. Haiwezekani kubadilisha yaliyomo kwenye jedwali, chagua tu foleni zinazoruhusiwa.',
        'Here you can enter SQL to send it directly to the application database.' =>
            'Hapa unaweza kuingia SQL kutuma moja kwa moja kwenye hifadhi data ya programu.',
        'Only select queries are allowed.' => 'Foleni zilizochaguliwa tu zinaruhusiwa.',
        'The syntax of your SQL query has a mistake. Please check it.' =>
            'Sintaksi ya ulizo lako la SQL lina makosa. Tafadhali liangalie.',
        'There is at least one parameter missing for the binding. Please check it.' =>
            'Kuna japo parameta moja imepotea kwa ajili ya uunganishaji. Tafadhali iangalie.',
        'Result format' => 'Umbizo la matokeo',
        'Run Query' => 'Endesha ulizo.',
        'Query is executed.' => 'Ulizo linatekelezwa.',

        # Template: AdminService
        'Service Management' => 'Usimamizi wa huduma',
        'Add service' => 'Ongeza huhuma',
        'Add Service' => 'Ongeza Huduma',
        'Edit Service' => 'Hariri huduma',
        'Sub-service of' => 'Huduma ya ',

        # Template: AdminServiceCenterSupportDataCollector
        'This data is sent to OTRS Group on a regular basis. To stop sending this data please update your system registration.' =>
            'Hii data imetumwa kwenda kwenye kikundi cha OTRS kwa msingi wa mara kwa mara. Kuzuia kutuma data hii tafadhali sasisha usajili wa mfumo wako.',
        'You can manually trigger the Support Data sending by pressing this button:' =>
            'Unaweza kuchochea kwa mkono data ya kusaidia kwa kutuma kwa kubofya kitufe:',
        'Send Update' => 'Tuma usasishaji',
        'Sending Update...' => 'Tuma Usasishaji...',
        'Support Data information was successfully sent.' => 'Wezesha taarifa za data imetumwa kwa mafanikio.',
        'Was not possible to send Support Data information.' => 'Haikuwezekana kutumwa kwa wezesha taarifa za data.',
        'Update Result' => 'Sasisha matokeo',
        'Currently this data is only shown in this system.' => 'Kwasasa hii data inaonyeshwa katika mfumo huu',
        'It is highly recommended to send this data to OTRS Group in order to get better support.' =>
            'Inapendekezwa kutuma data hii kwenye kikundi cha OTRS ili kupata msaada mzuri. ',
        'To enable data sending, please register your system with OTRS Group or update your system registration information (make sure to activate the \'send support data\' option.)' =>
            'Kuruhusu utumaji wa data, tafadhali sajili mfumo wako na kikundi cha OTRS au sasisha taarifa za usajili wa mfumo wako (hakikisha unaamilisha chaguo la \'Tuma data za msaada\')',
        'A support bundle (including: system registration information, support data, a list of installed packages and all locally modified source code files) can be generated by pressing this button:' =>
            'Kifurushi cha msaada (Inahusisha: taarifa za usajili za mfumo, data za msaada, orodha ya vifurushi vilivyosanidiwa na mafaili ya chanzo msimbo yote yaliyorekebishwa) yanaweza kuundwa kwa kubofya kibonye hiki.',
        'Generate Support Bundle' => 'Tengeneza kifurushi cha msaada.',
        'Generating...' => 'Tengeneza...',
        'It was not possible to generate the Support Bundle.' => 'Haikuwezekana kutengeneza kifurushi cha msaada.',
        'Generate Result' => 'Matokeo ya ujumla',
        'Support Bundle' => 'Kifurushi cha msaada',
        'The mail could not be sent' => 'Barua pepe haikuweza kutumwa',
        'The support bundle has been generated.' => 'Kifurushi cha msaada kimetengenezwa.',
        'Please choose one of the following options.' => 'Tafadhali chagua moja kati ya michaguo ifuatayo.',
        'Send by Email' => 'Tuma kwa barua pepe',
        'The support bundle is too large to send it by email, this option has been disabled.' =>
            'Kifurushi cha msaada ni kikubwa sana kukituma kwa barua pepe, chaguo hili halijawezeshwa.',
        'The email address for this user is invalid, this option has been disabled.' =>
            'Anwani ya barua pepe kwa mtumiaji huyu ni batili, chaguo hili halijawezeshwa.',
        'Sending' => 'Tuma',
        'The support bundle will be sent to OTRS Group via email automatically.' =>
            'Kifurushi cha msaada kitatumwa kwenye kikundi cha oTRS kwa kutumia barua pepe kwa otomatiki.',
        'Download File' => 'Pakua faili',
        'A file containing the support bundle will be downloaded to the local system. Please save the file and send it to the OTRS Group, using an alternate method.' =>
            'Faili lililo na kifurushi cha msaada litapakuliwa kwenye mfumo kiambo. Tafadhali hifadhi faili na litume kwenye kikundi cha OTRS, kwa kutumia njia mbadala.',
        'Error: Support data could not be collected (%s).' => 'Kosa: Data auni hazikuweza kukusanywa (%s).',
        'Details' => 'Undani',

        # Template: AdminSession
        'Session Management' => 'Usimamizi wa kipindi',
        'All sessions' => 'Vipindi vyote',
        'Agent sessions' => 'Vipindi vya wakala',
        'Customer sessions' => 'Vipindi vya mteja',
        'Unique agents' => 'Makala wa kipee',
        'Unique customers' => 'Wateja wa kipee',
        'Kill all sessions' => 'Ua vipindi vyote',
        'Kill this session' => 'Ua kipindi hiki',
        'Session' => 'Vipindi',
        'Kill' => 'Ua',
        'Detail View for SessionID' => 'Muonekano wa undani kwa kitambulisho cha kipindi',

        # Template: AdminSignature
        'Signature Management' => 'Usimamizi wa Saini',
        'Add signature' => 'Ongeza saini',
        'Add Signature' => 'Ongeza Saini',
        'Edit Signature' => 'Hariri Saini',
        'Example signature' => 'Saini ya mfano',

        # Template: AdminState
        'State Management' => 'Usimamizi wa hali',
        'Add state' => 'Ongeza hali',
        'Please also update the states in SysConfig where needed.' => 'Tafadhali sasisha pia hali katika usanidi wa mfumo utapohitajika.',
        'Add State' => 'Ongeza Hali',
        'Edit State' => 'Hariri hali',
        'State type' => 'Aina ya hali',

        # Template: AdminSysConfig
        'SysConfig' => 'Usanidi wa mfumo',
        'Navigate by searching in %s settings' => 'Abiri kwa kutafuta katika mipangilio %s',
        'Navigate by selecting config groups' => 'Abiri kwa kuchagua Vikundi vya kusanidi.',
        'Download all system config changes' => ' Pakua mabadiliko yote ya kusanidi mfumo',
        'Export settings' => 'Hamisha mipangilio',
        'Load SysConfig settings from file' => 'Pakia mipangilio ya usanidi wa mfumo kwa faili',
        'Import settings' => 'Lete mipangilio',
        'Import Settings' => 'Lete Mipangilio',
        'Please enter a search term to look for settings.' => 'Tafadhali ingiza neno la kutafuta kutafuta mipangilio',
        'Subgroup' => 'Kikundi',
        'Elements' => 'Elementi',

        # Template: AdminSysConfigEdit
        'Edit Config Settings' => 'Hariri mipangilio ya usanidi',
        'This config item is only available in a higher config level!' =>
            'Kipengee hiki cha usanidi kinapatikana katika ngazi za juu za usanidi tu!',
        'Reset this setting' => 'Weka upya mipangilio',
        'Error: this file could not be found.' => 'Kosa: Faili hili halikuweza kupatikana',
        'Error: this directory could not be found.' => 'Kosa: Mpangilio orodha huu haukuweza kupatikana',
        'Error: an invalid value was entered.' => 'Kosa: thamani batili iliingizwa',
        'Content' => 'Maudhui',
        'Remove this entry' => 'Ondoa ingizo hili',
        'Add entry' => 'Ongeza ingizo',
        'Remove entry' => 'Toa ingizo',
        'Add new entry' => 'Ongeza ingizo jipya',
        'Delete this entry' => 'Futa ingizo hili',
        'Create new entry' => 'Tengeneza ingizo jipya',
        'New group' => 'Kikundi kipya',
        'Group ro' => 'Kikundi somwa tu',
        'Readonly group' => 'KIkundi cha kusomwa tu',
        'New group ro' => 'Kikundi kipya cha kusomw tu',
        'Loader' => 'Kipakizi',
        'File to load for this frontend module' => 'Faili la kupakia kwa moduli hii ya Mbelenyuma',
        'New Loader File' => 'Faili jipya la kupakia',
        'NavBarName' => 'Jina la upao wa abiri',
        'NavBar' => 'Upao wa Abiri',
        'LinkOption' => 'Chaguo la kiunganishi',
        'Block' => 'Zuia',
        'AccessKey' => 'Vibonye ufikivu',
        'Add NavBar entry' => 'Ongeza ingizo la upao wa abiri',
        'Year' => 'Mwakk',
        'Month' => 'Mwezi ',
        'Day' => 'Siku',
        'Invalid year' => 'Mwaka batili',
        'Invalid month' => 'Mwezi batili',
        'Invalid day' => 'Siku batili',
        'Show more' => 'Onyesha zaidi',

        # Template: AdminSystemAddress
        'System Email Addresses Management' => 'Mfumo wa Usimamizi wa anuani za barua pepe',
        'Add system address' => 'Ongeza anuani ya mfumo',
        'All incoming email with this address in To or Cc will be dispatched to the selected queue.' =>
            'Barua pepe zote zinazoingia zenye hii anuani kwenye kutoka au Cc zitatumwa kwenye foleni iliyochaguliwa. ',
        'Email address' => 'Anuani ya barua pepe',
        'Display name' => 'Jina la kuonyesha',
        'Add System Email Address' => 'Ongeza Anuani ya barua pepe ya mfumo',
        'Edit System Email Address' => 'Hariri Anuani ya Barua pepe ya Mfumo',
        'The display name and email address will be shown on mail you send.' =>
            'Jina la kuonyesha na Anuani ya barua pepe zitaonyeshwa kwenye barua pepe unayotuma',

        # Template: AdminSystemMaintenance
        'System Maintenance Management' => 'Usimamizi wa marekebisho ya mfumo',
        'Schedule New System Maintenance' => 'Panga ratiba ya matengenezo ya mfumo mapya',
        'Schedule a system maintenance period for announcing the Agents and Customers the system is down for a time period.' =>
            'Panga ratiba ya muda wa  matengenezo ya mfumo kwa kuwatangazia mawakala na wateja kuwa mfumo utakuwa chini kwa kipindi cha muda.',
        'Some time before this system maintenance starts the users will receive a notification on each screen announcing about this fact.' =>
            'Muda flani kabla matengenezo ya mfumo hayajaanza watumiaji watapata taarifa kwenye kila skrini kuhusiana na jambo hili.',
        'Start date' => 'Tarehe ya kuanza',
        'Stop date' => 'Tarehe ya kusitisha',
        'Delete System Maintenance' => 'Futa matengenezo ya mfumo',
        'Do you really want to delete this scheduled system maintenance?' =>
            'Je unataka kufuta matengenezo haya ya mfumo yaliyokuwa kwenye ratika?',

        # Template: AdminSystemMaintenanceEdit
        'Edit System Maintenance %s' => 'Hariri matengenezo ya mfumo %s',
        'Edit System Maintenance information' => 'Hariri taarifa za matengenezo za mfumo',
        'Date invalid!' => 'Tarehe batili',
        'Login message' => 'Ujumbe wa kuingia',
        'Show login message' => 'Onyesha ujumbe wa kuingia',
        'Notify message' => 'Ujumbe wa kutaarifu',
        'Manage Sessions' => 'Simamia vipindi',
        'All Sessions' => 'Vipindi vyote',
        'Agent Sessions' => 'Vipindi vya wakala',
        'Customer Sessions' => 'Vipindi vya mteja',
        'Kill all Sessions, except for your own' => '',

        # Template: AdminTemplate
        'Manage Templates' => 'Simamia vielezo',
        'Add template' => 'Ongeza kielezo',
        'A template is a default text which helps your agents to write faster tickets, answers or forwards.' =>
            'Kielezo ni matini chaguo msingi mabayo yanawasaidia mawakala wako kuandika haraka tuketi, kujibu na kupeleka mbele.',
        'Don\'t forget to add new templates to queues.' => 'Usisahau kuongeza vielezo vipya katika foleni.',
        'Add Template' => 'Ongeza kielezo',
        'Edit Template' => 'Hariri kielezo',
        'A standard template with this name already exists!' => 'Kielezo cha kawaida kwa jina hili tayari kipo!',
        'Template' => 'Kielezo',
        'Create type templates only supports this smart tags' => 'Tengeneza aina ya violezo kwa kusaidia tu lebo maizi.',
        'Example template' => 'Kielezo cha mfano',
        'The current ticket state is' => 'Hali ya tiketi ya sasa ni',
        'Your email address is' => 'Anuani yako ya barua pepe ni',

        # Template: AdminTemplateAttachment
        'Manage Templates <-> Attachments Relations' => 'Simamia Vielezo <-> mahusiano ya viambatanishi',
        'Filter for Attachments' => 'Chuja kwa ajili ya viambatanisho',
        'Change Template Relations for Attachment' => 'Badili mahusiano ya kielezo kwa kielezo',
        'Change Attachment Relations for Template' => 'Badili mahusiano ya kiambatanisho kwa kielezo',
        'Toggle active for all' => 'Geuza kuwa amilifi kwa wote',
        'Link %s to selected %s' => 'Unganisha %s kwa %s iliyochaguliwa',

        # Template: AdminType
        'Type Management' => 'Usimamizi wa aina',
        'Add ticket type' => 'Ongeza aina ya tiketi',
        'Add Type' => 'Ongeza aina',
        'Edit Type' => 'Hariri aina',
        'A type with this name already exists!' => 'Aina yenye jina hili tayari ipo!',

        # Template: AdminUser
        'Add agent' => 'Oneza wakala',
        'Agents will be needed to handle tickets.' => 'Mawakala watahitajika kumud tiketi.',
        'Don\'t forget to add a new agent to groups and/or roles!' => 'Usisahau kuongeza wakaal mpya kwenye vikundi na/au majukumu.',
        'Please enter a search term to look for agents.' => 'Tafadhali ingiza neno la kutafuta kuwatafuta mawakala.',
        'Last login' => 'Mwingio wa mwisho',
        'Switch to agent' => 'Badili kwa wakala',
        'Add Agent' => 'Oneza wakala',
        'Edit Agent' => 'Hariri wakala',
        'Firstname' => 'Jina la kwanza',
        'Lastname' => 'Jina la mwisho',
        'A user with this username already exists!' => 'Mtumiaji kwa jina hili la utumiaji tayari yupo!',
        'Will be auto-generated if left empty.' => 'Itazalisha otomatikali kama ikiachwa wazi.',
        'Start' => 'Anza',
        'End' => 'Mwisho',

        # Template: AdminUserGroup
        'Manage Agent-Group Relations' => 'Simamia mahusiano ya Wakala-Kikundi',
        'Change Group Relations for Agent' => 'Badili mahusiano ya kikundi kwa wakala',
        'Change Agent Relations for Group' => 'Badili mahusiano ya wakala kwa kikundi',

        # Template: AgentBook
        'Address Book' => 'Kitabu cha anuani',
        'Search for a customer' => 'Tafuta mteja',
        'Add email address %s to the To field' => 'Ongeza Anwani ya barua pepe %s katika uga wa kwenda',
        'Add email address %s to the Cc field' => 'Ongeza anwani ya barua pepe %s katika uga wa Cc',
        'Add email address %s to the Bcc field' => 'Ongeza anwani ya barua pepe %s katika uga wa Bcc',
        'Apply' => 'Tekeleza',

        # Template: AgentCustomerInformationCenter
        'Customer Information Center' => 'Kituo cha habari cha mteja',

        # Template: AgentCustomerInformationCenterSearch
        'Customer User' => 'Mtumiaji wa mteja',

        # Template: AgentCustomerSearch
        'Duplicated entry' => 'Ingizo nakala pacha',
        'This address already exists on the address list.' => 'Anwani hii tayari ipo katika orodha ya anwani',
        'It is going to be deleted from the field, please try again.' => 'Itafutwa kutoka kwenye uga, tafadhali jaribu tena.',

        # Template: AgentCustomerTableView
        'Note: Customer is invalid!' => 'Kidokezo: Mteja ni batili!',

        # Template: AgentDashboard
        'Dashboard' => 'Dashibodi',

        # Template: AgentDashboardCalendarOverview
        'in' => 'Ndani',

        # Template: AgentDashboardCommon
        'Available Columns' => 'Safu wima zilizopo',
        'Visible Columns (order by drag & drop)' => 'Safuwima zinazoonekana (kwa oda ya kokota na dondosha)',

        # Template: AgentDashboardCustomerIDStatus
        'Escalated tickets' => 'Tiketi za kupanda',

        # Template: AgentDashboardCustomerUserList
        'Customer information' => 'Taarifa za mteja',
        'Phone ticket' => 'Tiketi ya simu',
        'Email ticket' => 'Tiketi ya barua pepe',
        'Start Chat' => 'Anza maongezi',
        '%s open ticket(s) of %s' => 'Tiketi %s zilizowazi kati ya %s',
        '%s closed ticket(s) of %s' => 'Tiketi %s i(z)liyofungwa kati ya %s ',
        'New phone ticket from %s' => 'Tiketi mpya za simu kutoka %s',
        'New email ticket to %s' => 'Tiketi mpya ya barua pepe kwenda %s',
        'Start chat' => 'Anza maongezi',

        # Template: AgentDashboardProductNotify
        '%s %s is available!' => '%s inapatikana',
        'Please update now.' => 'Tafadhali sasisha sasa.',
        'Release Note' => 'Matini ya toleo',
        'Level' => 'Kiwango',

        # Template: AgentDashboardRSSOverview
        'Posted %s ago.' => 'Imechapishwa %s zilizopita.',

        # Template: AgentDashboardStats
        'The content of this statistic is being prepared for you, please be patient.' =>
            'Yaliyomo ya takwimu hizi imeandaliwa kwa ajili yako, tafadhali kuwa na subira.',
        'Grouped' => 'Imewekwa kwenye makundi',
        'Stacked' => 'Ya omekezo',
        'Expanded' => 'Imepanuliwa',
        'Stream' => 'Mfululizo',
        'CSV' => 'CSV',
        'PDF' => 'PDF',

        # Template: AgentDashboardTicketGeneric
        'My locked tickets' => 'Tiketi zangu zilizofungwa',
        'My watched tickets' => 'Tiketi zangu zilizoangaliwa',
        'My responsibilities' => 'Majukumu yangu',
        'Tickets in My Queues' => 'Tiketi katika foleni yangu',
        'Tickets in My Services' => 'Tiketi zilizopo kwenye huduma',
        'Service Time' => 'Muda wa huduma',
        'Remove active filters for this widget.' => 'Ondoa vichuja amilifu kwa hiki kifaa.',

        # Template: AgentDashboardTicketQueueOverview
        'Totals' => 'Jumla',

        # Template: AgentDashboardUserOnline
        'out of office' => 'Nje ya office',

        # Template: AgentDashboardUserOutOfOffice
        'until' => 'Mpaka',

        # Template: AgentHTMLReferencePageLayout
        'The ticket has been locked' => 'Tiketi imefungwa',
        'Undo & close window' => 'Tendua & funga window',

        # Template: AgentInfo
        'Info' => 'Taarifa',
        'To accept some news, a license or some changes.' => 'Kukubali baadhi ya taarifa, lleseni au baadhi ya mabadiliko.',

        # Template: AgentLinkObject
        'Link Object: %s' => 'Kipengele kiunganishi: %s',
        'go to link delete screen' => 'nenda kwenye skrini ya kiunganishi cha kufuta',
        'Select Target Object' => 'Chagua kipengele lengwa.',
        'Link Object' => 'Kipengele kiunganishi',
        'with' => 'Na',
        'Unlink Object: %s' => 'Kipengele kisichokiunganishi',
        'go to link add screen' => 'Nenda kwenye skrini ya kiunganishi cha kuongeza.',

        # Template: AgentPreferences
        'Edit your preferences' => 'Harir mapendeleo yako',

        # Template: AgentSchedulerInfo
        'General Information' => 'Taarifa kwa ujumla',
        'Scheduler is an OTRS separated process that perform asynchronous tasks' =>
            'Kiratibu ni mchakato wa OTRS ulitengwa ambao unafanya kazi solandanifu.',
        '(e.g. Generic Interface asynchronous invoker tasks)' => '(mfano Kazi za kichochezi solandanifu cha kiolesura cha ujumla)',
        'It is necessary to have the Scheduler running to make the system work correctly!' =>
            'Ni muhimu kuwa na kipanga ratiba kufanya kazi kufanya mfumo kufanya kazi vizuri.',
        'Starting Scheduler' => 'Anzisha kipanga ratiba.',
        'Make sure that %s exists (without .dist extension)' => 'Hakikisha kwamba %s ipo (bila kiendelezi .dist)',
        'Check that cron deamon is running in the system' => 'Angalia hiyo dimoni inayofanyakazi katika mfumo.',
        'Confirm that OTRS cron jobs are running, execute %s start' => 'Thibitisha kwamba kazi za cron za OTRS, fanya % anza',

        # Template: AgentSpelling
        'Spell Checker' => 'Kiangalia herufi',
        'spelling error(s)' => '(Ma)kosa ya herufi',
        'Apply these changes' => 'Tumia mabadiliko haya',

        # Template: AgentStatsDelete
        'Delete stat' => 'Futa takwimu',
        'Do you really want to delete this stat?' => 'Je unataka kufuta takwimu hii?',

        # Template: AgentStatsEditRestrictions
        'Step %s' => 'Hatua %s',
        'General Specifications' => 'Ubainishi wa jumla',
        'Select the element that will be used at the X-axis' => 'Chagua elementi ambayo itakayotumika katika jira la X.',
        'Select the elements for the value series' => 'Chagua elementi kwa mfatano wa thamani ',
        'Select the restrictions to characterize the stat' => 'Chagua vizuizi kuwakilisha takwimu.',
        'Here you can make restrictions to your stat.' => 'Hapa unaweza kutengeneza vizuizi kwa takwimu yako.',
        'If you remove the hook in the "Fixed" checkbox, the agent generating the stat can change the attributes of the corresponding element.' =>
            'Kama ukitoa ndoano katika kisanduku tiki "Pachikwa", wakala anaetengeneza takwimu anaweza kubadilisha sifa ya elementi inayohisiana.',
        'Fixed' => 'Pachikwa',
        'Please select only one element or turn off the button \'Fixed\'.' =>
            'Tafadhali chagua elementi moja tu au zina kibonye cha \'Pachikwa\'.',
        'Absolute Period' => 'Kipindi sahihi',
        'Between' => 'Katikati',
        'Relative Period' => 'Kipindi kinachohusiana',
        'The last' => 'Mwisho',
        'Finish' => 'Maliza',

        # Template: AgentStatsEditSpecification
        'Permissions' => 'Ruhusa ',
        'You can select one or more groups to define access for different agents.' =>
            'Unaweza kuchagua kikundi kimoja na zaidi kuwapa ufikivu kwa mawakala mbalimbali.',
        'Some result formats are disabled because at least one needed package is not installed.' =>
            'Baadhi ya umbizo matokeo hayajawezeshwa kwasababu japo kifurushi kimoja kinachohitajika hakijasanidiwa.',
        'Please contact your administrator.' => 'Tafadhali wasiliana na mtawala.',
        'Graph size' => 'Ukubwa wa grafu.',
        'If you use a graph as output format you have to select at least one graph size.' =>
            'Kama unatumia grafu kama umbizo tokeo chagua japo ukubwa wa grafu mmoja.',
        'Sum rows' => 'Safu mlalo za jumla',
        'Sum columns' => 'Safu wima za jumla',
        'Use cache' => 'Tumia hifadhi muda',
        'Most of the stats can be cached. This will speed up the presentation of this stat.' =>
            'Takwimu nyingi  zinaweza kuwekwa kwenye hifadhi muda. Hii itafanya uwasilishaji wa takwimu hii uende haraka.',
        'Show as dashboard widget' => 'Onyesha kifaa cha dashibodi',
        'Provide the statistic as a widget that agents can activate in their dashboard.' =>
            'Onyesha takwimu kama kifaa ambacho mawakala wanaweza kuamilisha dashibodi zao.',
        'Please note' => 'Tafadhali jua',
        'Enabling the dashboard widget will activate caching for this statistic in the dashboard.' =>
            'Kuruhusu kifaa cha dashibodi itaamilisha uwezo wa uhifadhi muda kwa takwimu hizi katika dashibodi.',
        'Agents will not be able to change absolute time settings for statistics dashboard widgets.' =>
            'Mawakala hawatoweza kubadili mipangilio ya muda wa kuisha kwa  dashibodi ya takwimu. ',
        'IE8 doesn\'t support statistics dashboard widgets.' => 'IE8 haihaiwezeshi vifaa vya dashibodii cha takwimu. ',
        'If set to invalid end users can not generate the stat.' => 'Kama imewekwa batili mtumiaji wa mwisho hawezi kutengeneza takwimu.',

        # Template: AgentStatsEditValueSeries
        'Here you can define the value series.' => 'Hapa unaweza kufafanua thamani mfuatano.',
        'You have the possibility to select one or two elements.' => 'Kuna uwezekano wa kuchagua elementi moja au mbili. ',
        'Then you can select the attributes of elements.' => 'Halafu unaweza kuchagua sifa za elementi.',
        'Each attribute will be shown as single value series.' => 'Kila sifa itaonyeshwa kama mfuatano wa thamani moja. ',
        'If you don\'t select any attribute all attributes of the element will be used if you generate a stat, as well as new attributes which were added since the last configuration.' =>
            'Kama hautochagua sifa yoyote sifa zote za elementi zitatumika kama ukitengeneza takwimu, na pia sifa mpya zilizoongezwa tangu usanidi wa mwisho.',
        'Scale' => 'Mzani',
        'minimal' => 'Ndogo',
        'Please remember, that the scale for value series has to be larger than the scale for the X-axis (e.g. X-Axis => Month, ValueSeries => Year).' =>
            'Tafadhali kumbuka, kwamba mzani kwa mfuatano wa thamani unabidi uwe mkubwa kuliko mzani kwa jira la X (mfano  Jira X=> mwezi,thamani mfuatano => Mwaka).',

        # Template: AgentStatsEditXaxis
        'Here you can define the x-axis. You can select one element via the radio button.' =>
            'Hapa unaweza kufafanua jira X. Unaweza kuchagua elementi moja kupitia kibonye cha redio.',
        'maximal period' => 'Upeo mkubwa wa muda',
        'minimal scale' => 'mzani mdogo',

        # Template: AgentStatsImport
        'Import Stat' => 'Agiza takwimu',
        'File is not a Stats config' => 'Faili sio la usanidi wa takwimu',
        'No File selected' => 'Hakuna faili lililochaguliwa',

        # Template: AgentStatsOverview
        'Stats' => 'Takwimu',

        # Template: AgentStatsPrint
        'No Element selected.' => 'Hakuna elementi iliyochaguliwa',

        # Template: AgentStatsView
        'Export config' => 'Hamisha usanidi',
        'With the input and select fields you can influence the format and contents of the statistic.' =>
            'Kwa ingizo na chagua uga unaweza kushawishi umbizo na maudhui ya takwimu. ',
        'Exactly what fields and formats you can influence is defined by the statistic administrator.' =>
            'Uga gani hasa na umbizo unazoweza kushawishi zinamefafanuliwa na kiongozi wa takwimu.',
        'Stat Details' => 'Takwimu za tafiti',
        'Format' => 'Mpangilio',
        'Graphsize' => 'Ukubwa wa grafu',
        'Cache' => 'Hifadhi muda',
        'Exchange Axis' => 'Jira ya kubadilishana',

        # Template: AgentStatsViewSettings
        'Configurable params of static stat' => 'Vigezo vilivyosanidiwa vya takwimu tuli',
        'No element selected.' => 'Hakuna elementi iliyochaguliwa',
        'maximal period from' => 'Upeo mkubwa wa muda kutoka',
        'to' => 'Kwenda',
        'not changable for dashboard statistics' => 'Haiwezi kubadilika kwa takwimu za dashibodi',
        'Select Chart Type' => 'Chagua aina ya chati',
        'Chart Type' => 'Aina ya chati',
        'Multi Bar Chart' => 'Chati pau mbalimbali',
        'Multi Line Chart' => 'Chati mstari mbalimbali',
        'Stacked Area Chart' => 'Eneo mpororo',

        # Template: AgentTicketActionCommon
        'Change Free Text of Ticket' => 'Badili matini huru kwa ajili ya tiketi',
        'Change Owner of Ticket' => 'Badili mmiliki wa tiketi',
        'Close Ticket' => 'Funga tiketi',
        'Add Note to Ticket' => 'Ongeza kidokezo katika tiketi ',
        'Set Pending' => 'Weka kusubiri',
        'Change Priority of Ticket' => 'Badili kipaumbele cha tiketi.',
        'Change Responsible of Ticket' => 'Badili uhusika wa tiketi.',
        'All fields marked with an asterisk (*) are mandatory.' => 'Uga zote zilizowekwa alama ya kinyota (*) ni za lazima.',
        'Service invalid.' => 'HUduma batili.',
        'New Owner' => 'Mmiliki mpya.',
        'Please set a new owner!' => 'Tafadhali weka mmiliki mpya!',
        'Previous Owner' => 'Mmiliki wa aliyepita!',
        'Next state' => 'Hali ijayo',
        'For all pending* states.' => '',
        'Add Article' => 'Ongeza makala',
        'Create an Article' => 'Tengeneza makala',
        'Spell check' => 'Angalia herufi',
        'Text Template' => 'Kielezo cha matini',
        'Setting a template will overwrite any text or attachment.' => 'Kuweka kiolezo kutaandika juu ya matini yoyote au kiambatisho.',
        'Note type' => 'Aina ya kidokezo',
        'Inform Agent' => 'Mtaarifu wakala',
        'Optional' => 'Ya hiari',
        'Inform involved Agents' => 'Taarifu mawakala wanaohusika',
        'Here you can select additional agents which should receive a notification regarding the new article.' =>
            'Hapa unaweza kuchagua mawakala wa kuongezea ambao watapokea taarifa kuhusiana na makala mpya.',
        'Note will be (also) received by:' => '',

        # Template: AgentTicketBounce
        'Bounce Ticket' => 'Tiketi dunda',
        'Bounce to' => 'Dunda kwenda ',
        'You need a email address.' => 'Unahitaji anwani ya barua pepe',
        'Need a valid email address or don\'t use a local email address.' =>
            'Unahitaji anwani halali ya barua pepe au usitumie anwani ya kawaida ya barua pepe.',
        'Next ticket state' => 'Hali ijayo ya tiketi.',
        'Inform sender' => 'Taarifu mtumaji.',
        'Send mail' => 'Tuma barua pepe',

        # Template: AgentTicketBulk
        'Ticket Bulk Action' => 'Kitendo cha wingi cha tiketi.',
        'Send Email' => 'Tuma barua pepe',
        'Merge to' => 'Unganishwa kwa',
        'Invalid ticket identifier!' => 'Kitambulishi cha tiketi batili!',
        'Merge to oldest' => 'Unganishwa na kubwa kabisa',
        'Link together' => 'Unganisha pamoja',
        'Link to parent' => 'Unganisha na mzazi',
        'Unlock tickets' => 'Fungua tiketi',

        # Template: AgentTicketCompose
        'Compose answer for ticket' => 'Tunga jibu kwa ajili ya tiketi',
        'Please include at least one recipient' => 'Tafadhali ambatanisha mpokeaji japo mmoja',
        'Remove Ticket Customer' => 'Mtoe mteja wa tiketi',
        'Please remove this entry and enter a new one with the correct value.' =>
            'Tafadhali toa ingizo hili na uweke jipya lenye thamani sahihi.',
        'Remove Cc' => 'Toa Cc.',
        'Remove Bcc' => 'Toa Bcc',
        'Address book' => 'Kitabu cha anwani',
        'Date Invalid!' => 'Tarehe batili',

        # Template: AgentTicketCustomer
        'Change customer of ticket' => 'Badili tiketi ya mteja',
        'Customer user' => 'Mtumiaji wa mteja',

        # Template: AgentTicketEmail
        'Create New Email Ticket' => 'Tengeneza tiketi ya barua pepe mpya',
        'Example Template' => 'Kiolezo cha mfano',
        'From queue' => 'Kutoka kwenye foleni',
        'To customer user' => 'Kwenda kwa mtumiaji wa mteja',
        'Please include at least one customer user for the ticket.' => 'Tafadhali weka japo mtumiaji wa mteja mmoja kwa tiketi hii.',
        'Select this customer as the main customer.' => 'Chagua mteja huyu kama mteja mkuu.',
        'Remove Ticket Customer User' => 'Ondoa mtumiaji wa mteja wa tiketi',
        'Get all' => 'Pata zote',

        # Template: AgentTicketEmailOutbound
        'E-Mail Outbound' => 'Barua pepe zilizofungwa nje.',

        # Template: AgentTicketForward
        'Forward ticket: %s - %s' => 'Tuma mbele: %s - %s',

        # Template: AgentTicketHistory
        'History of' => 'Historia ya',
        'History Content' => 'Maudhui ya historia',
        'Zoom view' => 'Mandhari iliyokuzwa',

        # Template: AgentTicketMerge
        'Ticket Merge' => 'Uchanganishi tiketi',
        'You need to use a ticket number!' => 'Unahitaji kutumia namba ya tiketi',
        'A valid ticket number is required.' => 'Namba ya tiketi halali inatakiwa.',
        'Need a valid email address.' => 'Anwani ya barua pepe halali inahitajika.',

        # Template: AgentTicketMove
        'Move Ticket' => 'Hamisha tiketi',
        'New Queue' => 'Foleni mpya',

        # Template: AgentTicketOverviewMedium
        'Select all' => 'Chagua zote',
        'No ticket data found.' => 'Data za tiketi hazijapatikana',
        'Select this ticket' => 'Chagua tiketi hii',
        'First Response Time' => 'Muda wa kwanza wa majibu',
        'Update Time' => 'Muda wa kusasisha',
        'Solution Time' => 'Muda wa ufumbuzi',
        'Move ticket to a different queue' => 'Hamisha tiketi kwenye foleni nyingine',
        'Change queue' => 'Badili foleni',

        # Template: AgentTicketOverviewNavBar
        'Change search options' => 'Badili michaguo ya utafutaji',
        'Remove active filters for this screen.' => 'Ondoa kichuja amilifu kwa skrini hii.',
        'Tickets per page' => 'Tiketi kwa ukurasa',

        # Template: AgentTicketOverviewSmall
        'Reset overview' => 'Weka tena mapitio',
        'Column Filters Form' => 'Safu wima zinachujwa kutoka',

        # Template: AgentTicketPhone
        'Split Into New Phone Ticket' => 'Gawanya kwenye tiketi za simu mpya',
        'Save Chat Into New Phone Ticket' => 'Hifadhi mazungumzo katika tiketi mpya ya simu',
        'Create New Phone Ticket' => 'Tengeneza tiketi mpya ya simu',
        'Please include at least one customer for the ticket.' => 'Tafadhali ambatanisha japo mteja mmoja kwa tiketi hii.',
        'To queue' => 'Kwenda kwenye foleni',
        'Chat protocol' => 'Itifaki ya mazungumzo',
        'The chat will be appended as a separate article.' => 'Mazungumzo yataambatishwa kama makala ya tofauti.',

        # Template: AgentTicketPlain
        'Email Text Plain View' => 'Mandhari ya wazi ya matini ya barua pepe',
        'Plain' => 'Wazi',
        'Download this email' => 'Pakua barua pepe hii',

        # Template: AgentTicketPrint
        'Ticket-Info' => 'Taarifa za tiketi',
        'Accounted time' => 'Muda wa kuhesabu',
        'Linked-Object' => 'Kipengele kilichounganishwa',
        'by' => 'Kwa',

        # Template: AgentTicketProcess
        'Create New Process Ticket' => 'Tengeneza tiketi mpya za mchakato',
        'Process' => 'Mchakato',

        # Template: AgentTicketProcessSmall
        'Enroll Ticket into a Process' => 'Andikisha tiketi hii kuwa mchakato',

        # Template: AgentTicketSearch
        'Search template' => 'Tafuta kielezo',
        'Create Template' => 'Tengeneza kielezo',
        'Create New' => 'Tenngeneza mpya',
        'Profile link' => 'Kiolesura cha maelezo mafupi',
        'Save changes in template' => 'Hifadhi mabadiliko kwenye kielezo',
        'Filters in use' => 'Chuja katika kutumia',
        'Additional filters' => 'Vichuja vilivyoongezwa',
        'Add another attribute' => 'Ongeza sifa nyingine',
        'Output' => 'Matokeo',
        'Fulltext' => 'Nakala yote',
        'Remove' => 'Ondoa',
        'Searches in the attributes From, To, Cc, Subject and the article body, overriding other attributes with the same name.' =>
            'Tafuta katika sifa Kutoka, Kwenda, Cc, Somo na kiini cha makala, geuza sifa nyingine zenye jina sawa.',
        'Customer User Login' => 'Kuingia kwa mtimiaji wa mteja',
        'Attachment Name' => 'Jina la kiambatanishi',
        '(e. g. m*file or myfi*)' => '(Mfano m*file au myfil*) ',
        'Created in Queue' => 'Tengenezwa katika foleni',
        'Lock state' => 'Hali ya kufungwa',
        'Watcher' => 'Muangaliaji',
        'Article Create Time (before/after)' => 'Muda wa kutengeneza makala (Kabla/baada)',
        'Article Create Time (between)' => 'Muda wa kutengeneza makala (Kati ya)',
        'Ticket Create Time (before/after)' => 'Muda wa kutengeneza tiketi (Kabla/baada)',
        'Ticket Create Time (between)' => 'Muda wa kutengeneza tiketi (kati ya)',
        'Ticket Change Time (before/after)' => 'Muda wa kubadili tiketi (Kabla/baada)',
        'Ticket Change Time (between)' => 'Muda wa kubadili tiketi (kati ya)',
        'Ticket Last Change Time (before/after)' => 'Muda wa mwisho wa kubadili tiketi (kabla/baada)',
        'Ticket Last Change Time (between)' => 'Muda wa mwisho wa kubadili tiketi (kati ya)',
        'Ticket Close Time (before/after)' => 'Muda wa kufunga tiketi (kabla/baada)',
        'Ticket Close Time (between)' => 'Muda wa kufunga tiketi (kati ya)',
        'Ticket Escalation Time (before/after)' => 'Muda wa tiketi kupanda (baada/kabla)',
        'Ticket Escalation Time (between)' => 'Muda wa tiketi kupanda (kati ya)',
        'Archive Search' => 'Tafuta nyaraka',
        'Run search' => 'Tafuta',

        # Template: AgentTicketZoom
        'Article filter' => 'Kichuja cha makala',
        'Article Type' => 'Aina ya makala',
        'Sender Type' => 'Aina y amtumaji',
        'Save filter settings as default' => 'Hifadhi mipangilio ya kichuja kuwa chaguo-msingi',
        'Event Type Filter' => 'Kichuja cha aina ya tukio',
        'Event Type' => 'Aina ya tukio',
        'Save as default' => 'Hifadhi kama chaguo-msingi',
        'Archive' => 'Nyaraka',
        'This ticket is archived.' => 'Tiketi hii imewekwa kwenye nyaraka',
        'Locked' => 'Fungwa',
        'Linked Objects' => 'Vipengele vilivyounganishwa',
        'Change Queue' => 'Badili foleni',
        'There are no dialogs available at this point in the process.' =>
            'Hakuna mazungumzo yaliyopo katika hatua hii ya mchakato.',
        'This item has no articles yet.' => 'Kipengee hakina makala bado.',
        'Ticket Timeline View' => 'Mandhari ya kalenda ya matukio ya tiketi',
        'Article Overview' => 'Marejeo ya makala',
        'Article(s)' => 'Makala',
        'Page' => 'Ukurasa',
        'Add Filter' => 'Ongeza kichuja',
        'Set' => 'Weka',
        'Reset Filter' => 'Weka tena kichuja',
        'Show one article' => 'Onyesha makala moja',
        'Show all articles' => 'Onyesha makala zote',
        'Show Ticket Timeline View' => 'Onyesha mandhari ya kalenda ya matukio ya tiketi',
        'Unread articles' => 'Makala ambazo hazijasomwa',
        'No.' => 'Hapana.',
        'Important' => 'Muhimu',
        'Unread Article!' => 'Makala ambayo haijasomwa!',
        'Incoming message' => 'Ujumbe unaoingia',
        'Outgoing message' => 'Ujumbe unaotoka',
        'Internal message' => 'Ujumbe wa ndani',
        'Resize' => 'Badilisha ukubwa',
        'Mark this article as read' => 'Weka alama kwa makala hii kama imeshasomwa.',
        'Show Full Text' => 'Onyesha nakala yote',
        'Full Article Text' => 'Nakala ya makala yote',
        'No more events found. Please try changing the filter settings.' =>
            'Hakuna matukio yaliyopatikana.Tafadhali jaribu kubadilisha mipangilio ya kuchuja.',
        'To open links in the following article, you might need to press Ctrl or Cmd or Shift key while clicking the link (depending on your browser and OS).' =>
            '',
        'Close this message' => 'Funga ujumbe huu',
        'Article could not be opened! Perhaps it is on another article page?' =>
            'Makala haiwezi kufunguliwa! Huenda ipo kwenye ukurasa mwingine wa makala.',

        # Template: AttachmentBlocker
        'To protect your privacy, remote content was blocked.' => 'Kulinda faragha yako,  yaliyomo ya mbali yamezuiliwa.',
        'Load blocked content.' => 'Pakia yaliyomo yaliyozuiliwa.',

        # Template: ChatStartForm
        'First message' => 'Ujumbe wa kwanza',

        # Template: CustomerError
        'Traceback' => 'Tafuta Nyuma',

        # Template: CustomerFooter
        'Powered by' => 'Imewezeshwa na',

        # Template: CustomerFooterJS
        'One or more errors occurred!' => 'Kosa moja au zaidi yametokea',
        'Close this dialog' => 'Funga mazungumzo haya',
        'Could not open popup window. Please disable any popup blockers for this application.' =>
            'Haikuweza kufungua dirisha ibukizi.Tafadhali kataza vizuizi vya kiibukizi kwa programu-tumizi hii.',
        'There are currently no elements available to select from.' => 'Kwasasa hakuna elementi inayopatika kuchagua fomu.',
        'Please turn off Compatibility Mode in Internet Explorer!' => 'Tafadhali zima hali timizi tangamanifu ya kitafuta wavuti! ',
        'The browser you are using is too old.' => 'Kivinjari unachotumia ni cha zamani sana.',
        'OTRS runs with a huge lists of browsers, please upgrade to one of these.' =>
            'OTRS inafanya kazi na orodha kubwa ya vijivinjari, tafadhali boresha kwenda kwenye moja wapo.',
        'Please see the documentation or ask your admin for further information.' =>
            'Tafadhali angalia nyaraka au muulize kiongozi wako kwa taarifa zaidi.',

        # Template: CustomerLogin
        'JavaScript Not Available' => 'JavaScript haipatikani',
        'In order to experience OTRS, you\'ll need to enable JavaScript in your browser.' =>
            'Ili kupata OTRS inabidi uruhusu JavaScript kwenye kivinjari',
        'Browser Warning' => 'Onyo la kivinjari',
        'One moment please, you are being redirected...' => 'Tafadhali subiri kidogo, unaelekezwa....',
        'Login' => 'Ingia',
        'User name' => 'Jina la mtumiaji',
        'Your user name' => 'Jina lako lamtumiaji',
        'Your password' => 'Neno lako la siri',
        'Forgot password?' => 'Umesahau neno la siri?',
        'Log In' => 'Ingia',
        'Not yet registered?' => 'Bado haujasajiliwa?',
        'Request new password' => 'Ombi la neno la siri jipya',
        'Your User Name' => 'Jina lako la mtumiaji',
        'A new password will be sent to your email address.' => 'Neno jipya la siri litatumwa kwenye anwani yako ya barua pepe',
        'Create Account' => 'Tengeneza akaunti',
        'Please fill out this form to receive login credentials.' => 'Tafadhali jaza fomu hii kupokea hati za utambulisho za kuingia.',
        'How we should address you' => 'Jinsi tutakavyokutambulisha',
        'Your First Name' => 'Jina lako la kwanza',
        'Your Last Name' => 'Jina lako la mwisho',
        'Your email address (this will become your username)' => 'Anwani yako ya barua pepe (Hii itakuwa jina lako la utumiaji )',

        # Template: CustomerNavigationBar
        'Incoming Chat Requests' => 'Maombi ya mazungumzo yanayoingia',
        'You have unanswered chat requests' => 'Unamaombi ya mazungumzo ambayo hayajajibiwa',
        'Edit personal preferences' => 'Hariri mapendeleo binafsi',

        # Template: CustomerRichTextEditor
        'Split Quote' => 'Gawanya nukuu',

        # Template: CustomerTicketMessage
        'Service level agreement' => 'Kubaliano la kiwango cha huduma',

        # Template: CustomerTicketOverview
        'Welcome!' => 'Karibu ',
        'Please click the button below to create your first ticket.' => 'Tafadhali bofya kwneye kitufe cha chini kutengeneza tiketi yako ya kwanza.',
        'Create your first ticket' => 'Tengeneza tiketi yako ya kwanza',

        # Template: CustomerTicketPrint
        'Ticket Print' => 'Chapisho la tiketi',
        'Ticket Dynamic Fields' => 'Uga wenye nguvu wa tiketi',

        # Template: CustomerTicketSearch
        'Profile' => 'Maelezo mafupi',
        'e. g. 10*5155 or 105658*' => 'Mfano 10*5155 au 105658',
        'Customer ID' => 'Kitambulisho cha mteja',
        'Fulltext search in tickets (e. g. "John*n" or "Will*")' => 'Tafuta nakala kamili katika tiketi (mfano "John" au "Will")',
        'Carbon Copy' => 'carbon nakala ',
        'e. g. m*file or myfi*' => 'Mfano m*file au myfil*',
        'Types' => 'Aina',
        'Time restrictions' => 'Vizuizi vya muda',
        'No time settings' => 'Hakuna mipangilio ya muda',
        'Only tickets created' => 'Tiketi zilizotengenezwa tu',
        'Only tickets created between' => 'Tiketi zilizotengenezwa kati ya',
        'Ticket archive system' => 'Mfumo wa nyaraka za tiketi',
        'Save search as template?' => 'Hifadhi tafuti kama kielezo?',
        'Save as Template?' => 'Hifadhi kama kielezo?',
        'Save as Template' => 'Hifadhi kama kielezo',
        'Template Name' => 'Jina la kielezo',
        'Pick a profile name' => 'Chagua jina la umbo',
        'Output to' => 'Matokeo ya ',

        # Template: CustomerTicketSearchResultShort
        'of' => 'Ya',
        'Search Results for' => 'Majibu ya kutafuka kwa',
        'Remove this Search Term.' => 'Ondoa hii neno la kutafuta',

        # Template: CustomerTicketZoom
        'Expand article' => 'Panua makal',
        'Next Steps' => 'Hatua inayofuata',
        'Reply' => 'Jibu',

        # Template: DashboardEventsTicketCalendar
        'All-day' => 'Siku nzima',
        'Sunday' => 'Jumapili',
        'Monday' => 'Jumatatu',
        'Tuesday' => 'Jumanne',
        'Wednesday' => 'Jumatano',
        'Thursday' => 'Alhamisi',
        'Friday' => 'Ijumaa',
        'Saturday' => 'Jumamosi',
        'Su' => 'J2',
        'Mo' => 'J3',
        'Tu' => 'J4',
        'We' => 'J5',
        'Th' => 'Alh',
        'Fr' => 'Iju',
        'Sa' => 'Jmosi',
        'Event Information' => 'Taarifa kuhusu tukio',
        'Ticket fields' => 'Uga wa tiketi',
        'Dynamic fields' => 'Uga wenye nguvu',

        # Template: Datepicker
        'Invalid date (need a future date)!' => 'Tarehe batili (Tarehe ijayo inatakiwa)',
        'Invalid date (need a past date)!' => 'Tarehe batili (Tarehe ya zamani inahitajika)',
        'Previous' => 'Iliyopita',
        'Open date selection' => 'Fungua chaguo la tarehe',

        # Template: Error
        'Oops! An Error occurred.' => 'Samahani! Kosa limetokea.',
        'You can' => 'Unaweza',
        'Send a bugreport' => 'Tuma repoti yenye makosa',
        'go back to the previous page' => 'Rudi nyuma kwenye ukurasa uliopita',
        'Error Details' => 'Makosa kwa undani',

        # Template: FooterJS
        'If you now leave this page, all open popup windows will be closed, too!' =>
            'Kama unaondoka huu ukurasa, madirisha ibukizi  yote yaliyofunguliwa yatafungwa pia.',
        'A popup of this screen is already open. Do you want to close it and load this one instead?' =>
            'Kiibukizi katika skrini hii tayari imefunguliwa. Je unataka kufunga na kupakia hii hapa badala yake?',
        'Please enter at least one search value or * to find anything.' =>
            'Tafadhali ingiza japo moja ya thamani ilitafutwa au * kutafuta yoyote.',
        'Please check the fields marked as red for valid inputs.' => 'Tafadhali angalia uga zote ziliizowekwa alama nyekundu kwa ajili ya maingizo batili.',
        'Please perform a spell check on the the text first.' => 'Tafadhali fanya uangalizi maneno katika makala kwanza.',
        'Slide the navigation bar' => 'Telezesha mwambaa wa uabiri',

        # Template: Header
        'You are logged in as' => 'Umeingia kama',
        'There are new chat requests available. Please visit the chat manager.' =>
            '',

        # Template: Installer
        'JavaScript not available' => 'JavaScript haipatikani',
        'Database Settings' => 'Mipangilio ya hifadhi data',
        'General Specifications and Mail Settings' => 'Ubainishi wa jumla na mipangilio ya barua pepe',
        'Web site' => 'Tovuti',
        'Mail check successful.' => 'Barua pepe imeangaliwa kwa mafanikio',
        'Error in the mail settings. Please correct and try again.' => 'Kosa katika mipangilio ya barua pepe. Tafadhali rekebisha na jaribu tena.',

        # Template: InstallerConfigureMail
        'Configure Outbound Mail' => 'Sanidi barua pepe ya iliyofungwa nje',
        'Outbound mail type' => 'Aina ya barua pepe iliyofungwa nje',
        'Select outbound mail type.' => 'Chagua aina ya barua pepe iliyofungwa nje',
        'Outbound mail port' => 'Kituo tarishi cha barua pepe zilizofungwa nje',
        'Select outbound mail port.' => 'Chagua kituo tarishi cha barua pepe zilifungwa nje.',
        'SMTP host' => 'Mwenyeji wa SMTP',
        'SMTP host.' => 'Mwenyeji WA SMTP',
        'SMTP authentication' => 'Uthibitisho wa SMTP',
        'Does your SMTP host need authentication?' => 'Mwenyeji wako wa SMTP anahitaji uthibitisho?',
        'SMTP auth user' => 'Mtumiaji wa uthibitisho wa SMTP',
        'Username for SMTP auth.' => 'Jina la mtumiaji kwa ajjili ya uthibitisho wa SMTP ',
        'SMTP auth password' => 'Neno la siri la uthibitisho wa SMTP',
        'Password for SMTP auth.' => 'Neno la siri kwa ajili la uthibitisho wa SMTP',
        'Configure Inbound Mail' => 'Sanidi barua pepe za ndani',
        'Inbound mail type' => 'Aina za barua pepe za ndani',
        'Select inbound mail type.' => 'Chagua aina ya barua pepe za ndani',
        'Inbound mail host' => 'Mwenyeji wa barua pepe za ndani',
        'Inbound mail host.' => 'Mwenyeji wa barua  pepe za ndani.',
        'Inbound mail user' => 'Mtumiaji wa barua pepe za ndani',
        'User for inbound mail.' => 'Mtumiaji kwa ajili ya barua pepe za ndani.',
        'Inbound mail password' => 'Neno la siri barua pepe zilifungwa ndani',
        'Password for inbound mail.' => 'Neno la siri kwa ajili barua pepe zilifungwa ndani.',
        'Result of mail configuration check' => 'Matokeo ya maangalizi usanidi wa barua pepe',
        'Check mail configuration' => 'Angalia usanidi wa barua pepe',
        'Skip this step' => 'Ruka hatua hii',

        # Template: InstallerDBResult
        'Database setup successful!' => 'Usanidi wa hifadhi data umefanikiwa!',

        # Template: InstallerDBStart
        'Install Type' => 'Sakinisha aina',
        'Create a new database for OTRS' => 'Tengeneza hifadhi data mpya kwa ajili ya OTRS',
        'Use an existing database for OTRS' => 'Tumia hifadhi data iliyopo kwa ajili ya OTRS',

        # Template: InstallerDBmssql
        'Database name' => 'Jina la hifadhi data',
        'Check database settings' => 'Angalia mipangilio ya hifadhi data',
        'Result of database check' => 'Matokeo ya maangilio ya hifadhi data',
        'Database check successful.' => 'Uangalizi wa hifadhi data umeefanikiwa.',
        'Database User' => 'Mtumiaji wa hifadhi data',
        'New' => 'Mpya',
        'A new database user with limited permissions will be created for this OTRS system.' =>
            'Mtumiaji mpya wa hifadhi data wenye ruhusa kidogo watangenezwa katika mfumo huu wa OTRS.',
        'Repeat Password' => 'Rudia neno la siri',
        'Generated password' => 'Neno la siri lilitongenezwa',

        # Template: InstallerDBmysql
        'Passwords do not match' => 'Maneno ya siri hayafanani',

        # Template: InstallerDBoracle
        'SID' => 'SID',
        'Port' => 'Kituo tarishi',

        # Template: InstallerFinish
        'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' =>
            'Kuweza kutumia OTRS ingiza mistari ifuatayo katika tungo amri yako kama mzizi.(Terminal/Shell) ',
        'Restart your webserver' => 'Washa upya seva ya tovuti',
        'After doing so your OTRS is up and running.' => 'Baada ya kufanya hivyo OTRS  itafanya kazi.',
        'Start page' => 'Ukurusa wa kuanza',
        'Your OTRS Team' => 'Timu yako ya OTRS',

        # Template: InstallerLicense
        'Don\'t accept license' => 'Usikubali leseni',
        'Accept license and continue' => 'Kubali leseni na endelea',

        # Template: InstallerSystem
        'The identifier of the system. Each ticket number and each HTTP session ID contain this number.' =>
            'Kitambulishi cha mfumo. Kila namba ya tiketi na kila kitambulisho cha kipindi cha HTTP kina namba hii.',
        'System FQDN' => 'Mfumo FQDN',
        'Fully qualified domain name of your system.' => 'Jina la kikoa lilifudhu kamili la mfumo wako.',
        'AdminEmail' => 'Barua pepe ya kiongozi',
        'Email address of the system administrator.' => 'Barua pepe ya kiongozi wa mfumo.',
        'Organization' => 'Shirika',
        'Log' => 'Batli',
        'LogModule' => 'Moduli ya batli',
        'Log backend to use.' => 'Batli mazingira ya nyuma kutumia.',
        'LogFile' => 'Batli faili',
        'Webfrontend' => 'Mazingira ya mbele ya tovuti.',
        'Default language' => 'Lugha ya chaguo-msingi',
        'Default language.' => 'Lugha ya chaguo-msingi.',
        'CheckMXRecord' => 'Angalia rekodi ya MX',
        'Email addresses that are manually entered are checked against the MX records found in DNS. Don\'t use this option if your DNS is slow or does not resolve public addresses.' =>
            'Anwani za barua pepe ambazo zinaingizwa kwa mkono zinaangaliwa dhidi ya rekodi za MX zilizopatikana kwenye DNS. Usitumie chaguo hili kama DNS yako ipo taratibu au haitatui anwani za umma.',

        # Template: LinkObject
        'Object#' => 'Kipengee#',
        'Add links' => 'Ongeza viungo',
        'Delete links' => 'Futa viungo',

        # Template: Login
        'Lost your password?' => 'Umepoteza neno lako la siri?',
        'Request New Password' => 'Ombi la neno jipya la siri',
        'Back to login' => 'Rudi kwenye kuingia',

        # Template: Motd
        'Message of the Day' => 'Ujumbe wa siku',

        # Template: NoPermission
        'Insufficient Rights' => 'Haki zisizotosha',
        'Back to the previous page' => 'Nyuma kwenye ukurasa uliopita',

        # Template: Pagination
        'Show first page' => 'Onyesha ukurasa wa kwanza',
        'Show previous pages' => 'Onyesha kurasa zilizopita',
        'Show page %s' => 'Onyesha ukurasa %s',
        'Show next pages' => 'Onyesha kurasa zifuatazo',
        'Show last page' => 'Onyesha ukurasa wa mwisho',

        # Template: PictureUpload
        'Need FormID!' => 'Kitambulisho cha fomu kinahitajika!',
        'No file found!' => 'Hakuna faili lilipatikana',
        'The file is not an image that can be shown inline!' => 'Faili sio taswira ambayo inaweza kuonyeshwa ndani ya mstari.',

        # Template: PrintHeader
        'printed by' => 'Imechapishwa na ',

        # Template: Test
        'OTRS Test Page' => 'Ukurasa wa majaribio wa OTRS',
        'Counter' => 'Kiesabuji',

        # Template: Warning
        'Go back to the previous page' => 'Rudi nyuma kwenye ukurasa uliopita',

        # SysConfig
        ' (work units)' => '',
        '"%s"-notification sent to "%s".' => ' %s -taarifa imetumwa kwenda "%s".',
        '%s' => '%s',
        '%s time unit(s) accounted. Now total %s time unit(s).' => '%s k(v)izio cha muda vinahusika. Sasa %s jumla ya k(v)izio cha muda.',
        '(UserLogin) Firstname Lastname' => '(Kuingia kwa mtumiaji) Jina kwanza Jina la mwisho',
        '(UserLogin) Lastname, Firstname' => '(Kuingia kwa mtumiaji) Jina la mwsiho, jina la kwanza',
        'A Website' => '',
        'A list of dynamic fields that are merged into the main ticket during a merge operation. Only dynamic fields that are empty in the main ticket will be set.' =>
            'Orodha ya uga zenye nguvu ambazo zimeunganishwa katika tiketi kuu wakati wa mchakato wa kuunganisha. Uga zenye nguvu tu amabzo zipo wazi katika tiketi kuu zitawekwa.',
        'A picture' => '',
        'ACL module that allows closing parent tickets only if all its children are already closed ("State" shows which states are not available for the parent ticket until all child tickets are closed).' =>
            'Moduli za ACL ambazo zinakubali kufunga tiketi zazi tu kama ndogo zake zimefungwa tayari ("Hali" inaonyesha hali ambazo hazipataki kwa tiketi zazi hadi tiketi ndogo zote ziwe zimefungwa).',
        'Access Control Lists (ACL)' => 'Orodha Dhibiti Ufikivu (ACL)',
        'AccountedTime' => 'Muda uliohesabiwa',
        'Activates a blinking mechanism of the queue that contains the oldest ticket.' =>
            'Amilisha utaratibu unaokonyeza wa foleni ambao una tiketi ya zamani.',
        'Activates lost password feature for agents, in the agent interface.' =>
            'Amilisha kipengele cha neno la siri lilopotea kwa wakala, katika kiolesura cha wakala.',
        'Activates lost password feature for customers.' => 'Amilisha kipengele cha neno la siri lililopotea kwa wateja.',
        'Activates support for customer groups.' => 'Amilisha msaada kwa vikundi vya wateja.',
        'Activates the article filter in the zoom view to specify which articles should be shown.' =>
            'Amilisha kichuja cha makala katika mandhari ya kukuza kubainisha makala ipi ionyeshwe.',
        'Activates the available themes on the system. Value 1 means active, 0 means inactive.' =>
            'Amilisha dhima zinazopatikana katika mfumo. Thamani 1 inamaanisha amilifu, 0 inamaanisha isiyoamilifu.',
        'Activates the ticket archive system search in the customer interface.' =>
            'Amilisha mfumo wa uhifadhi wa tiketi katika kiolesura cha mteja.',
        'Activates the ticket archive system to have a faster system by moving some tickets out of the daily scope. To search for these tickets, the archive flag has to be enabled in the ticket search.' =>
            'Inaamilisha mfumo wa uhifadhi wa tiketi kuwa na mfumo wa haraka kwa kuhamisha baadhi ya tiketi nje ya upeo wa kila siku. Kutafuta tiketi hizi, bendera ya hifadhi za nyaraka inabidi iwezeshwa katika utafutaji wa tiketi.',
        'Activates time accounting.' => 'Amilisha muda wa kusebiwa.',
        'ActivityID' => 'Kitambulisho cha shughuli',
        'Added email. %s' => 'Ongeza barua pepe. %s',
        'Added link to ticket "%s".' => 'Ongeza kiunganishi kwa tiketi "%s".',
        'Added note (%s)' => 'Kidokezo kilichoongezwa (%s)',
        'Added subscription for user "%s".' => 'Kujiunga kulikoongezwa kwa mtumiaji %s',
        'Adds a suffix with the actual year and month to the OTRS log file. A logfile for every month will be created.' =>
            'Inaongeza kiendelezi na mwaka na mwezi wa ukweli katika faili la batli. Faili la batli litatengenezwa kila mwezi.',
        'Adds customers email addresses to recipients in the ticket compose screen of the agent interface. The customers email address won\'t be added if the article type is email-internal.' =>
            'Ongeza anwani za barua pepe za wateja kwa mpokeaji katika skrini ya kutunga tiketi ya kiolesura cha wakala. Anwani za barua pepe za wateja hazitoongezwa kama aina ya makala ni barua pepe za ndani.',
        'Adds the one time vacation days for the indicated calendar. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Inaongeza mara moja siku za mapumziko katika kalenda iliyoonyeshwa. Tafadhali tumia tarakimu za aina moja kwa ajili ya namba 1 hadi 9 (badala ya 01-09).',
        'Adds the one time vacation days. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Inaongeza siku za mapumziko za mara moja. Tafadhali tumia tarakimu za aina moja kwa ajili ya namba 1 hadi 9 (badala ya 01-09).',
        'Adds the permanent vacation days for the indicated calendar. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Inaongeza siku za mapumziko za kudumu zilizoonyeshwa kwenye kalenda. Tafadhali tumia tarakimu za aina moja kwa ajili ya namba 1 hadi 9 (badala ya 01-09).',
        'Adds the permanent vacation days. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Inaongeza siku za mapumziko za kudumu. Tafadhali tumia tarakimu za aina moja kwa ajili ya namba 1 hadi 9 (badala ya 01-09).',
        'Agent Notifications' => 'Taarifa za wakala',
        'Agent called customer.' => 'Wakala amempigia simu mteja',
        'Agent interface article notification module to check PGP.' => 'Moduli ya taarifa ya makala ya kiolesura cha wakala kuangalia PGP.',
        'Agent interface article notification module to check S/MIME.' =>
            'Moduli ya taarifa ya makala ya kiolesura cha wakala kuangalia S/MIME.',
        'Agent interface module to access CIC search via nav bar.' => 'Moduli ya kiolesura cha wakala ya kufikia utafutaji wa CIC kupitia mwambaa wa uabiri.',
        'Agent interface module to access fulltext search via nav bar.' =>
            'Moduli ya kiolesura cha wakala ya kufikia utafutaji wa matini kamili kupitia mwambaa wa uabiri.',
        'Agent interface module to access search profiles via nav bar.' =>
            'Moduli ya kiolesura cha wakala ya kufikia utafutaji wa maelezo mafupi kupitia mwambaa wa uabiri.',
        'Agent interface module to check incoming emails in the Ticket-Zoom-View if the S/MIME-key is available and true.' =>
            'Moduli ya kiolesura cha wakala ya kuangalia barua pepe zinazoingia katika mandhari iliyokuzwa ya tiketi kama kibonye cha S/MIME kipo na kweli.',
        'Agent interface notification module to see the number of locked tickets.' =>
            '',
        'Agent interface notification module to see the number of tickets an agent is responsible for.' =>
            'Moduli ya taarifa ya makala ya kiolesura cha wakala kuona namba ya tiketi ambazo wakala anahusika nazo.',
        'Agent interface notification module to see the number of tickets in My Services.' =>
            'Moduli ya taarifa ya makala ya kiolesura cha wakala kuona namba ya tiketi katika Huduma Yangu.',
        'Agent interface notification module to see the number of watched tickets.' =>
            'Moduli ya taarifa ya makala ya kiolesura cha wakala kuona namba ya tiketi ambazo zinaangaliwa.',
        'Agents <-> Groups' => 'Mawakala <-> Makundi',
        'Agents <-> Roles' => 'Mawakala <-> Majukumu',
        'All customer users of a CustomerID' => 'Watumiaji wote wa mteja wa kitambulisho cha mteja',
        'Allows adding notes in the close ticket screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Ruhusu kuongeza vidokezo katika skrini ilifungwa ya tiketi ya kiolesura cha wakala. Inaweza kuandikwa kupitiliza kwa Tiketi::Mazingira ya mbele::Inahitaji muda uliohesabika',
        'Allows adding notes in the ticket free text screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Ruhusu kuongeza vidokezo katika tiketi huru ya skini ya matini ya kiolesura cha wakala. Inaweza kuandikwa kupitiliza kwa Tiketi::Mazingira ya mbele::Inahitaji muda uliohesabika',
        'Allows adding notes in the ticket note screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Ruhusu kuongeza vidokezo katika tiketi ya kidokezo ya skini ya kiolesura cha wakala. Inaweza kuandikwa kupitiliza kwa Tiketi::Mazingira ya mbele::Inahitaji muda uliohesabika',
        'Allows adding notes in the ticket owner screen of a zoomed ticket in the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Ruhusu kuongeza vidokezo katika skrini ya tiketi miliki ya tiketi iliyokuzwa katika kiolesura cha wakala. Inaweza kuandikwa kupitiliza kwa Tiketi::Mazingira ya mbele::Inahitaji muda uliohesabika',
        'Allows adding notes in the ticket pending screen of a zoomed ticket in the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Ruhusu kuongezwa kwa vidokezo katika skrini inayosubiri tiketi ya tiketi iliyokuzwa katika kiolesura cha wakala. Inaweza kuandikwa kwa kupitilizwa kwa Tiketi::Mazingira ya mbele::Inahitaji muda uliohesabika',
        'Allows adding notes in the ticket priority screen of a zoomed ticket in the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Ruhusu kuongeza vidokezo katika skrini ya tiketi ya kipaumbele ya tiketi iliyokuzwa katika kiolesura cha wakala. Inaweza kuandikwa kupitiliza kwa Tiketi::Mazingira ya mbele::Inahitaji muda uliohesabika',
        'Allows adding notes in the ticket responsible screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Ruhusu kuongeza vidokezo katika skrini ya tiketi wajibika ya kiolesura cha wakala. Inaweza kuandikwa kupitiliza kwa Tiketi::Mazingira ya mbele::Inahitaji muda uliohesabika',
        'Allows agents to exchange the axis of a stat if they generate one.' =>
            'Inawaruhusu mawakala kubadilisha jira la takwimu kama wakitengeneza.',
        'Allows agents to generate individual-related stats.' => 'Inawaruhusu mawakala kutengeneza takwimu zinazohusiana na mtu.',
        'Allows choosing between showing the attachments of a ticket in the browser (inline) or just make them downloadable (attachment).' =>
            'Inaruhusu kuchagua kati ya kuonyesha viambatisho vya tiketi katika kivinjari (ndani ya mstari) au kuzifanya ziweze kupakuliwa (kiambatisho)',
        'Allows choosing the next compose state for customer tickets in the customer interface.' =>
            'Inawaruhusu wateja kutunga hali ijayo kwa tiketi za mteja katika kiolesura cha mteja.',
        'Allows customers to change the ticket priority in the customer interface.' =>
            'Inawaruhusu wateja kubadili kipaumbele cha tiketi katika kiolesura cha mteja.',
        'Allows customers to set the ticket SLA in the customer interface.' =>
            'Inawaruhusu wateja kuweka SLA ya tiketi katika kiolesura cha mteja.',
        'Allows customers to set the ticket priority in the customer interface.' =>
            'Inawaruhusu wateja kuweka kipaumbele cha tiketi katika kiolesura cha mteja.',
        'Allows customers to set the ticket queue in the customer interface. If this is set to \'No\', QueueDefault should be configured.' =>
            'Inawaruhusu wateja kuweka foleni ya tiketi katika kiolesura cha mteja. Kama imewekwa "Hapana", foleni chaguo-msingi itasasishwa.',
        'Allows customers to set the ticket service in the customer interface.' =>
            'Inawaruhusu wateja kuweka huduma ya tiketi katika kiolesura cha mteja.',
        'Allows customers to set the ticket type in the customer interface. If this is set to \'No\', TicketTypeDefault should be configured.' =>
            'Inawaruhusu wateja kuweka aina ya tiketi katika kiolesura cha mteja. ',
        'Allows default services to be selected also for non existing customers.' =>
            'Inaruhusu huduma chaguo-msingi kuchaguliwa pia kwa wateja wasiokuwepo.',
        'Allows defining new types for ticket (if ticket type feature is enabled).' =>
            'Inaruhusu kufafanua aina mpya kwa ajili ya tiketi (Kama kipengele cha aina ya tiketi kimewezeshwa ).',
        'Allows defining services and SLAs for tickets (e. g. email, desktop, network, ...), and escalation attributes for SLAs (if ticket service/SLA feature is enabled).' =>
            'Inaruhusu kufafanua huduma na SLA kwa ajili ya tiketi (mfano barua pepe, eneo kazi, mtandao,....) na sifa ya kupanda kwa ajili ya SLA(kama huduma/SLA ya tiketi imeruhusiwa).',
        'Allows extended search conditions in ticket search of the agent interface. With this feature you can search e. g. with this kind of conditions like "(key1&&key2)" or "(key1||key2)".' =>
            'Inaruhusu masharti ya kutafuta kuongezwa katika utafutaji wa tiketi wa kiolesura cha wakala. Kwa kipengele hiki unaweza kutafuta mfano kwa masharti ya aina hii "(key1&&key2)" or "(key1||key2)".',
        'Allows extended search conditions in ticket search of the customer interface. With this feature you can search w. g. with this kind of conditions like "(key1&&key2)" or "(key1||key2)".' =>
            'Inaruhusu masharti ya kutafuta kuongezwa katika utafutaji wa tiketi wa kiolesura cha mteja. Kwa kipengele hiki unaweza kutafuta mfano kwa masharti ya aina hii "(key1&&key2)" or "(key1||key2)".',
        'Allows having a medium format ticket overview (CustomerInfo => 1 - shows also the customer information).' =>
            'Inaruhusu kuwa na mapitio ya tiketi ya umbizo ya kati (Taarifa za mteja =>1 - inaonyesha pia taarifa za mteja).',
        'Allows having a small format ticket overview (CustomerInfo => 1 - shows also the customer information).' =>
            'Inaruhusu kuwa na marejeo ya tiketi ya umbizo dogo (Taarifa za mteja =>1 - inaonyesha pia taarifa za mteja).',
        'Allows invalid agents to generate individual-related stats.' => 'Inaruhusu mawakala batili kutengeneza takwimu zinazohusiana na mtu.',
        'Allows the administrators to login as other customers, via the customer user administration panel.' =>
            'Inawaruhusu viongozi kuingia kama wateja wengine, kupitia paneli ya uongozi wa mtumiaji wa mteja.',
        'Allows the administrators to login as other users, via the users administration panel.' =>
            'Inawaruhusu viongozi kuingia kama wateja wengine, kupitia paneli ya uongozi ya watumiaji.',
        'Allows to set a new ticket state in the move ticket screen of the agent interface.' =>
            'Inaruhusu kuweka hali mpya ya tiketi katika skrini ya kutoa ya tiketi ya kiolesura cha wakala.',
        'Archive state changed: "%s"' => 'Hali ya nyaraka imebadilishwa: "%s"',
        'ArticleTree' => 'Mti wa makala',
        'Attachments <-> Templates' => 'Viambatisho <-> Vielezo',
        'Auto Responses <-> Queues' => 'Majibu otomatiki<-> Foleni',
        'AutoFollowUp sent to "%s".' => 'Ufuatiliaji otomatiki umetumwa kwenda: "%s".',
        'AutoReject sent to "%s".' => 'Kukataa otomatiki kumetumwa kwenda "%s".',
        'AutoReply sent to "%s".' => 'Majibu otomatiki yametumwa kwenda "%s".',
        'Automated line break in text messages after x number of chars.' =>
            'Kigawa mstari otomatiki katika ujumbe wa maneno baada ya namba x ya herufi.',
        'Automatically lock and set owner to current Agent after opening the move ticket screen of the agent interface.' =>
            'Imefungwa otomatiki na inamuweka mmiliki katika wakala wa sasa baada ya kufungua skrini ya kuhamisha tiketi ya kiolesura cha wakala.',
        'Automatically lock and set owner to current Agent after selecting for an Bulk Action.' =>
            'Imefungwa otomatiki na inamuweka mmiliki katika wakala wa sasa baada ya kuchagua kitendo cha wingi.',
        'Automatically sets the owner of a ticket as the responsible for it (if ticket responsible feature is enabled).' =>
            'Inamuweka otomatiki mmiliki wa tiketi kama mhuiska wake (Kama kipengele cha uhusika wa tiketi kimewezeshwa).',
        'Automatically sets the responsible of a ticket (if it is not set yet) after the first owner update.' =>
            'Inamuweka otomatiki mmhusika wa tiketi (Kama hajawekwa bado) baada ya usasishwaji wa mmiliki wa kwanza.',
        'Balanced white skin by Felix Niklas (slim version).' => 'Balanced white skin na Felix Niklas (toleo jembamba).',
        'Balanced white skin by Felix Niklas.' => 'Balanced white skin na Felix Niklas.',
        'Basic fulltext index settings. Execute "bin/otrs.RebuildFulltextIndex.pl" in order to generate a new index.' =>
            'Mipangilio ya kielezo cha matini iliyojaa ya msingi. Fanya "bin/otrs.RebuildFulltextIndex.pl" katika mpango kutengeneza kielezo kipya.',
        'Blocks all the incoming emails that do not have a valid ticket number in subject with From: @example.com address.' =>
            'Zuia barua pepe zote zinazooingia ambazo hazina namba ya tiketi halali katika somo kutoka: @example.com address.',
        'Bounced to "%s".' => 'Ilidunda kwenda "%s".',
        'Builds an article index right after the article\'s creation.' =>
            'Jenga kielezo cha makala mara baada ya utengenezaji wa makala.',
        'CMD example setup. Ignores emails where external CMD returns some output on STDOUT (email will be piped into STDIN of some.bin).' =>
            'Mpangilio wa mfano wa CMD. Inapuuzia barua pepe ambapo CMD ya nje inarudisha baadhi ya matokeo katika STDOUT (Barua pepe zitapitishwa katika TDIN ya some.bin ).',
        'Cache time in seconds for agent authentication in the GenericInterface.' =>
            'Muda wa hifadhi muda katika sekunde kwa ajili ya uhalalishaji wa wakala katika kiolesura cha jumla.',
        'Cache time in seconds for customer authentication in the GenericInterface.' =>
            'Muda wa hifadhi muda katika sekunde kwa ajili ya uhalalishaji wa mteja katika kiolesura cha jumla.',
        'Cache time in seconds for the DB ACL backend.' => 'Muda wa hifadhi muda katika sekunde kwa ajili ya mazingira ya nyuma ya DB ACL.',
        'Cache time in seconds for the DB process backend.' => 'Muda wa hifadhi muda katika sekunde kwa ajili ya mazingira ya nyuma ya mchakato wa DB.',
        'Cache time in seconds for the SSL certificate attributes.' => 'Muda wa hifadhi muda katika sekunde kwa ajili yasifa za cheti cha SSL.',
        'Cache time in seconds for the ticket process navigation bar output module.' =>
            'Muda wa hifadhi muda katika sekunde kwa ajili ya Moduli ya matokeo ya mwambaa wa uaburi wa mchakato wa tiketi.',
        'Cache time in seconds for the web service config backend.' => 'Muda wa hifadhi muda katika sekunde kwa ajili ya mazingira ya nyuma ya usanidi wa huduma za wavuti.',
        'Change password' => 'Badili neno la siri',
        'Change queue!' => 'Badili foleni!',
        'Change the customer for this ticket' => 'Badili mteja kwa ajili ya hii tiketi',
        'Change the free fields for this ticket' => 'Badili uga uliowazi kwa ajili ya tiketi hii',
        'Change the priority for this ticket' => 'Badili kiapumbele cha tiketi hii',
        'Change the responsible person for this ticket' => 'Badili mtu anayehusika na tiketi hii',
        'Changed priority from "%s" (%s) to "%s" (%s).' => 'Kipaumbele kimebadilishwa kutoka "%s" (%s) kwenda "%s" ("%s").',
        'Changes the owner of tickets to everyone (useful for ASP). Normally only agent with rw permissions in the queue of the ticket will be shown.' =>
            'Badilii mmiliki wa tiketi kuwa kila mtu(Inafaa kwa ASP). Mara nyingi wakala tu mwenye ruhusa za rw katika foleni ya tiketi itaonyeshwa.',
        'Checkbox' => 'Kisandukutiki',
        'Checks the SystemID in ticket number detection for follow-ups (use "No" if SystemID has been changed after using the system).' =>
            'Angalia kitamulisho cha mfumo katika kutambua namba ya tiketi kwa ajili ya ufuatiliaji (Tumia "Hapana" kama kitambulisho cha mfumo kimebadilishwa baada ya kubadili mfumo).',
        'Closed tickets (customer user)' => 'Tiketi zilizofungwa (Mteja mtumiaji)',
        'Closed tickets (customer)' => 'Tiketi zilizofungwa (Mteja )',
        'Column ticket filters for Ticket Overviews type "Small".' => 'Vichuja vya tiketi vya safu wima kwa ajili ya aina "Ndogo" ya mapitio ya tiketi.',
        'Columns that can be filtered in the escalation view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed.' =>
            'Safuwima ambazo zinaweza kuchujwa katika mandhari ya kupandishwa ya kiolesura cha wakala. Mipangilio inayowezekana: 0 = Haijawezeshwa, 1 = Inapatikana, 2 = imewezeshwa kwa chaguo msingi. Kumbuka: Sifa za tiketi na uga zenye nguvu tu zinaruhusiwa (Uga wenye Nguvu_JinaX).',
        'Columns that can be filtered in the locked view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed.' =>
            'Safuwima ambazo zinaweza kuchujwa katika mandhari iliyofungwa ya kiolesura cha wakala. Mipangilio inayowezekana: 0 = Haijawezeshwa, 1 = Inapatikana, 2 = imewezeshwa kwa chaguo msingi. Kumbuka: Sifa za tiketi na uga zenye nguvu tu zinaruhusiwa (Uga wenye Nguvu_JinaX).',
        'Columns that can be filtered in the queue view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed.' =>
            'Safuwima ambazo zinaweza kuchujwa katika mandhari ya foleni ya kiolesura cha wakala. Mipangilio inayowezekana: 0 = Haijawezeshwa, 1 = Inapatikana, 2 = imewezeshwa kwa chaguo msingi. Kumbuka: Sifa za tiketi na uga zenye nguvu tu zinaruhusiwa (Uga wenye Nguvu_JinaX).',
        'Columns that can be filtered in the responsible view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed.' =>
            'Safuwima ambazo zinaweza kuchujwa katika mandhari inayohusika ya kiolesura cha wakala. Mipangilio inayowezekana: 0 = Haijawezeshwa, 1 = Inapatikana, 2 = imewezeshwa kwa chaguo msingi. Kumbuka: Sifa za tiketi na uga zenye nguvu tu zinaruhusiwa (Uga wenye Nguvu_JinaX).',
        'Columns that can be filtered in the service view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed.' =>
            'Safuwima ambazo zinaweza kuchujwa katika mandhari ya huduma ya kiolesura cha wakala. Mipangilio inayowezekana: 0 = Haijawezeshwa, 1 = Inapatikana, 2 = imewezeshwa kwa chaguo msingi. Kumbuka: Sifa za tiketi na uga zenye nguvu tu zinaruhusiwa (Uga wenye Nguvu_JinaX).',
        'Columns that can be filtered in the status view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed.' =>
            'Safuwima ambazo zinaweza kuchujwa katika mandhari ya hali ya kiolesura cha wakala. Mipangilio inayowezekana: 0 = Haijawezeshwa, 1 = Inapatikana, 2 = imewezeshwa kwa chaguo msingi. Kumbuka: Sifa za tiketi na uga zenye nguvu tu zinaruhusiwa (Uga wenye Nguvu_JinaX).',
        'Columns that can be filtered in the ticket search result view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed.' =>
            'Safuwima ambazo zinaweza kuchujwa katika mandhari ya matokeo ya utafutaji wa tiketi ya kiolesura cha wakala. Mipangilio inayowezekana: 0 = Haijawezeshwa, 1 = Inapatikana, 2 = imewezeshwa kwa chaguo msingi. Kumbuka: Sifa za tiketi na uga zenye nguvu tu zinaruhusiwa (Uga wenye Nguvu_JinaX).',
        'Columns that can be filtered in the watch view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed.' =>
            'Safuwima ambazo zinaweza kuchujwa katika mandhari ya kuangalia ya kiolesura cha wakala. Mipangilio inayowezekana: 0 = Haijawezeshwa, 1 = Inapatikana, 2 = imewezeshwa kwa chaguo msingi. Kumbuka: Sifa za tiketi na uga zenye nguvu tu zinaruhusiwa (Uga wenye Nguvu_JinaX).',
        'Comment for new history entries in the customer interface.' => 'Toa maoni kwa ajili ya maingizo ya historia mapya katika kiolesura cha mteja.',
        'Comment2' => '',
        'Company Status' => 'Hali ya kampuni',
        'Company Tickets' => 'Tiketi za kampuni',
        'Company name which will be included in outgoing emails as an X-Header.' =>
            'Jina la kampuni litakalohusishwa katika barua pepe zinazotoka nje kama kichwa-X.',
        'Configure Processes.' => 'Michakato wa usanidi.',
        'Configure and manage ACLs.' => 'Sanidi na simamia ACL.',
        'Configure your own log text for PGP.' => 'Sanidi matini batli yako kwa ajili ya PGP.',
        'Configures a default TicketDynamicField setting. "Name" defines the dynamic field which should be used, "Value" is the data that will be set, and "Event" defines the trigger event. Please check the developer manual (http://doc.otrs.org/), chapter "Ticket Event Module".' =>
            'Inasanidi mpangilio chaguo-msingi Uga wenye nguvu wa tiketi. "Jina" inafafanua uga wenye nguvu unaotakiwa kutumika, "Thamani" ni data ambayo itawekwa, na "Tukio" inafafanua kichochezi cha tukio. Tafadhali angalia mwongozo wa msanifu (http://doc.otrs.org/), sura "Moduli ya tukio la tiketi".',
        'Controls how to display the ticket history entries as readable values.' =>
            'Inadhibiti jinsi ya kuonyesha maingizo ya historia ya tiketi kama thamani zinazosomeka. ',
        'Controls if customers have the ability to sort their tickets.' =>
            'Inadhibiti kama wateja wanauwezo wa kupanga tiketi zao.',
        'Controls if more than one from entry can be set in the new phone ticket in the agent interface.' =>
            'Inadhibiti kama kuna ingizo zaidi moja linawezwa kuwekwa katika tiketi ya simu mpya katika kiolesura cha wakala. ',
        'Controls if the admin is allowed to import a saved system configuration in SysConfig.' =>
            'Inadhibiti kama kiongozi anaruhusiwa kuleta usanidi wa mfumo uliohifadhiwa katika UsanidiMfumo',
        'Controls if the admin is allowed to make changes to the database via AdminSelectBox.' =>
            'Inadhibiti kama kiongozi anaruhusiwa kufanya mabadiliko kwenye hifadhi data kupitia Kisanduku cha kiongozi cha kuchagua.',
        'Controls if the ticket and article seen flags are removed when a ticket is archived.' =>
            'Inadhibiti kama alama zilizoonekana za tiketi na makala zimeondolewa wakati tiketi zimwekwa kwenye nyaraka.',
        'Converts HTML mails into text messages.' => 'Badilisha barua pepe za HTML katika ujumbe mfupi wa maneno.',
        'Create New process ticket' => 'Tengeneza tiketi za mchakato mpya.',
        'Create and manage Service Level Agreements (SLAs).' => 'Tengeneza na simamia Makubaliano ya Viwango ya Huduma (MVH).',
        'Create and manage agents.' => 'Tenengeza na simamia mawakala.',
        'Create and manage attachments.' => 'Tengeneza na simamia viambanishi.',
        'Create and manage customer users.' => 'Tengeneza na simamia watumiaji wa mteja.',
        'Create and manage customers.' => 'Tengeneza na simamia wateja.',
        'Create and manage dynamic fields.' => 'Tengeneza na simamia uga wenye uwezo.',
        'Create and manage event based notifications.' => 'Tengeneza na simamia taarifa za matukio.',
        'Create and manage groups.' => 'Tengeneza na simamia makundi.',
        'Create and manage queues.' => 'Tengeneza na simamia foleni.',
        'Create and manage responses that are automatically sent.' => 'Tengeneza na simamia majibu ambayo yanatumwa automatiki.',
        'Create and manage roles.' => 'Tengeneza na simamia majukumu.',
        'Create and manage salutations.' => 'Tengeneza na simamia salamu.',
        'Create and manage services.' => 'Tengeneza na simamia huduma.',
        'Create and manage signatures.' => 'Tengeneza na simamia saini.',
        'Create and manage templates.' => 'Tengeneza na simamia violezo.',
        'Create and manage ticket priorities.' => 'Tengeneza na simamia vipaumbele vya tiketi.',
        'Create and manage ticket states.' => 'Tengeneza na simamia hali za tiketi.',
        'Create and manage ticket types.' => 'Tengeneza na simamia aina za tiketi.',
        'Create and manage web services.' => 'Tengeneza na simamia huduma za tovuti.',
        'Create new email ticket and send this out (outbound)' => 'Tengeneza tiketi mpya za barua pepe na uzitume (zilizofungwa nje)',
        'Create new phone ticket (inbound)' => 'Tengeneza tiketi mpya za simu (zilizofungwa ndani)',
        'Create new process ticket' => 'Tengeneza tiketi za mchakato mpya.',
        'Custom RSS Feed' => '',
        'Custom text for the page shown to customers that have no tickets yet (if you need those text translated add them to a custom translation module).' =>
            'Nakala ya kawaida kwa kurasa zilizoonyeshwa kwa wateja ambao hawana tiketi bado (Kama unahitaji nakala hizo kutafsiriwa ziongeze katika moduli ya kawaida ya kutafsiri ).',
        'Customer Administration' => 'Usimamizi wa mteja',
        'Customer User <-> Groups' => 'Mteja mtumiaji <-> Vikundi',
        'Customer User <-> Services' => 'Mteja mtumiaji <-> Huduma',
        'Customer User Administration' => 'Usimamizi wa mteja mtumiaji',
        'Customer Users' => 'Wateja watumiaji',
        'Customer called us.' => 'Mteja ametupigia',
        'Customer item (icon) which shows the closed tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            'Kipengee cha mteja (Ikoni) ambacho kinaonyesha tiketi zilizofungwa za mteja huyu kama taarifa za kuzuiliwa. Kuweka Kuingia kwa mteja mtumiaji kuwa 1 kutafuta tiketi kulingana na jina la kuingia kuliko kitambulisho cha mteja.',
        'Customer item (icon) which shows the open tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            'Kipengee cha mteja (Ikoni) ambacho kinaonyesha tiketi zilizofunguliwa za mteja huyu kama taarifa za kuzuiliwa. Kuweka Kuingia kwa mteja mtumiaji kuwa 1 kutafuta tiketi kulingana na jina la kuingia kuliko kitambulisho cha mteja.',
        'Customer request via web.' => 'Ombi la mteja kupitia wavuti.',
        'Customer user search' => '',
        'CustomerID search' => '',
        'CustomerName' => 'Jina la mteja',
        'Customers <-> Groups' => 'Makundi ya <->  Wateja',
        'Data used to export the search result in CSV format.' => 'Data zinazotumika kuhamisha matokeo ya kutafuta katika umbizo la CSV.',
        'Date / Time' => 'Tarehe / Muda',
        'Debugs the translation set. If this is set to "Yes" all strings (text) without translations are written to STDERR. This can be helpful when you are creating a new translation file. Otherwise, this option should remain set to "No".' =>
            'Eua seti ya tafsiri.Kama hii imewekwa kuwa "Ndio" tungo(matini) zote bila tafsiri zitaandikwa kwa STDERR. Hii inaweza kusaidia wakati unatengeneza faili jipya la tafsiri. Vinginevyo, chaguo hili libakie kuwa "No".',
        'Default ACL values for ticket actions.' => 'Thamani za ACL chaguo msingi  kwa ajili ya vitendo vya tiketi.',
        'Default ProcessManagement entity prefixes for entity IDs that are automatically generated.' =>
            'Viambishi awali vya vipengeee halisi vya Usimamizi wa mchakato chaguo msingi kwa ajili ya kitambulisho cha kipengee halisi ambavyo vinatengenezwa otomatiki.',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimePointFormat=year;TicketCreateTimePointStart=Last;TicketCreateTimePoint=2;".' =>
            'Data chaguo misngi kutumika katika sifa kwa ajili ya skrini ya kutafuta ya tiketi.
Mfano:
"Umbizo la Muda la Kutengeneza Tiketi= mwaka; Mwanzo wa Muda wa kutengeneza tiketi= Mwisho; Pointi ya muda wa kutengeneza tiketi=2;".',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimeStartYear=2010;TicketCreateTimeStartMonth=10;TicketCreateTimeStartDay=4;TicketCreateTimeStopYear=2010;TicketCreateTimeStopMonth=11;TicketCreateTimeStopDay=3;".' =>
            'Data chaguo-msingi kutumia katika sifa kwa ajili ya skrini ya kutafuta ya tiketi:
"Mwaka wa kuanza wa muda wa kutengeneza tiketi=2010; Mwezi wa kuanza wa muda wa kutengeneza tiketi=10; Siku ya kuanza ya muda wa kutengeneza tiketi=4; Mwaka wa kuacha wa muda wa kutengeneza tiketi =2010; Mwezi wa kuacha wa muda wa kutengeneza tiketi = 11; Siku ya kuacha ya muda wa kutengeneza tiketi=3; ".',
        'Default loop protection module.' => 'Moduli ya kulinda kitanzi chaguo-msingi.',
        'Default queue ID used by the system in the agent interface.' => 'Kitambulisho cha foleni chaguo-msingi kinachotumika na mfumo katika kiolesura cha wakala.',
        'Default skin for OTRS 3.0 interface.' => 'Gamba chaguo-msingi la kiolesura cha OTRS cha 3.0.',
        'Default skin for the agent interface (slim version).' => 'Gamba chaguo-msingi kwa jili ya kiolesura cha wakala (toleo jembamba).',
        'Default skin for the agent interface.' => 'Gamba chaguo-msingi kwa ajili ya kiolesura cha wakala.',
        'Default ticket ID used by the system in the agent interface.' =>
            'Kitambulisho cha tiketi chaguo-msingi kinachotumika na mfumo katika kiolesura cha wakala.',
        'Default ticket ID used by the system in the customer interface.' =>
            'Kitambulisho cha tiketi chaguo-msingi kinachotumika na mfumo katika kiolesura cha mteja.',
        'Default value for NameX' => 'Thamani chaguo msingi kwa jina X',
        'Define a filter for html output to add links behind a defined string. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Inafafanua kichujio cha matokeo ya html ili kuongeza viunganishi nyuma ya tungo zilizo fafanuliwa. Sura ya elemnti hii inaruhusu maingizo ya aina mbili. Kwanza jinala sura (mf. faq.png). Kwa kesi hii sura ya njia ya OTRS itatumika. Njia ya pili ni kuingiza kiungo cha hiyo sura.',
        'Define a mapping between variables of the customer user data (keys) and dynamic fields of a ticket (values). The purpose is to store customer user data in ticket dynamic fields. The dynamic fields must be present in the system and should be enabled for AgentTicketFreeText, so that they can be set/updated manually by the agent. They mustn\'t be enabled for AgentTicketPhone, AgentTicketEmail and AgentTicketCustomer. If they were, they would have precedence over the automatically set values. To use this mapping, you have to also activate the next setting below.' =>
            'Inafafanua uunganishwaji kati ya thamani zinazobadilika za data (Funguo) za  mteja mtumiaji na uga zenye nguvu za tiketi (thamani). Lengo ni kufadhi data za mteja mtumiaji katika uga wenye nguvu wa tiketi. Uga zenye nguvu lazima ziwepo katika mfumo na uwezeshwe kwa ajili ya matini huru ya tiketi ya wakala, ili ziwekwe/zisasishwe kwa mkono na wakala. Zisiwezeshwe kwa simu ya tiketi za wakala, barua pepe ya tiketi ya wakala na mteja wa tiketi ya wakala. Kama zingekuwepo zingekuwa na kitangulizi juu ya thamani zilizowekwa kwa otomatiki. Kutumia uunganishaji huu, inabidi uamilishe pia mpangilio ujao chini.',
        'Define dynamic field name for end time. This field has to be manually added to the system as Ticket: "Date / Time" and must be activated in ticket creation screens and/or in any other ticket action screens.' =>
            'Fafanua jina la uga wenye nguvu kwa ajili ya muda wa kuisha. Uga huu unabidi uongezwe kwa mkono katika mfumo kama tiketi: "Tarehe / Muda" na lazima iamilishwe katika skrini ya utengenezaji wa tiketi na/au katika skrini nyingine za kitendo cha tiketi.',
        'Define dynamic field name for start time. This field has to be manually added to the system as Ticket: "Date / Time" and must be activated in ticket creation screens and/or in any other ticket action screens.' =>
            'Fafanua jina la uga wenye nguvu kwa ajili ya muda wa kuanza. Uga huu unabidi uongezwe kwa mkono katika mfumo kama tiketi: "Tarehe / Muda" na lazima iamilishwe katika skrini ya utengenezaji wa tiketi na/au katika skrini nyingine za kitendo cha tiketi.',
        'Define the max depth of queues.' => 'inafafanua upeo wa juu wa kina wa foleni.',
        'Define the queue comment 2.' => '',
        'Define the service comment 2.' => '',
        'Define the sla comment 2.' => '',
        'Define the start day of the week for the date picker for the indicated calendar.' =>
            'Inafafanua siku ya kwanza ya wiki kwa kichagua tarehe kama ilivyoonyeshwa kwenye kalenda.',
        'Define the start day of the week for the date picker.' => 'Inafafanua siku ya kwanza ya wiki kwa kichagua tarehe.',
        'Defines a customer item, which generates a LinkedIn icon at the end of a customer info block.' =>
            'Inafafanua kipengee cha mteja, ambacho kinatengeneza ikoni ya LinkedIn katika mwisho wa kifungu cha taarifa cha mteja.',
        'Defines a customer item, which generates a XING icon at the end of a customer info block.' =>
            'Inafafanua kipengee cha mteja, ambacho kinatengeneza ikoni ya XING katika mwisho wa kifungu cha taarifa cha mteja.',
        'Defines a customer item, which generates a google icon at the end of a customer info block.' =>
            'Inafafanua kipengee cha mteja, ambacho kinatengeneza ikoni ya google katika mwisho wa kifungu cha taarifa cha mteja.',
        'Defines a customer item, which generates a google maps icon at the end of a customer info block.' =>
            'Inafafanua kipengee cha mteja, ambacho kinatengeneza ikoni ya ramani za google katika mwisho wa kifungu cha taarifa cha mteja.',
        'Defines a default list of words, that are ignored by the spell checker.' =>
            'Inafafanua orodha chaguo msingi ya maneno, ambayo yanapuuziwa na kiangalia herufi.',
        'Defines a filter for html output to add links behind CVE numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Inafafanua kichujio cha matokeo ya html ili kuongeza viungo nyuma ya namba za CVE. Sura ya elemnti hii inaruhusu maingizo ya aina mbili. Kwanza jinala sura (mf. faq.png). Kwa kesi hii sura ya njia ya OTRS itatumika. Njia ya pili ni kuingiza kiungo cha hiyo sura.',
        'Defines a filter for html output to add links behind MSBulletin numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Inafafanua kichujio cha matokeo ya html ili kuongeza viunganishi nyuma ya namba za MSBulletin. Sura ya elemnti hii inaruhusu maingizo ya aina mbili. Kwanza jinala sura (mf. faq.png). Kwa kesi hii sura ya njia ya OTRS itatumika. Njia ya pili ni kuingiza kiungo cha hiyo sura.',
        'Defines a filter for html output to add links behind a defined string. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Inafafanua kichujio cha matokeo ya html ili kuongeza viunganishi nyuma ya tungo zilizo fafanuliwa. Sura ya elemnti hii inaruhusu maingizo ya aina mbili. Kwanza jinala sura (mf. faq.png). Kwa kesi hii sura ya njia ya OTRS itatumika. Njia ya pili ni kuingiza kiungo cha hiyo sura.',
        'Defines a filter for html output to add links behind bugtraq numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Inafafanua kichujio cha matokeo ya html ili kuongeza viunganishi nyuma ya namba za bugtraq. Sura ya elemnti hii inaruhusu maingizo ya aina mbili. Kwanza jinala sura (mf. faq.png). Kwa kesi hii sura ya njia ya OTRS itatumika. Njia ya pili ni kuingiza kiungo cha hiyo sura.',
        'Defines a filter to process the text in the articles, in order to highlight predefined keywords.' =>
            'Inafafanua kichujio kushughulikia matini katika makala, ili kuonyesha maneno muhimu yaliyofafanuliwa.',
        'Defines a regular expression that excludes some addresses from the syntax check (if "CheckEmailAddresses" is set to "Yes"). Please enter a regex in this field for email addresses, that aren\'t syntactically valid, but are necessary for the system (i.e. "root@localhost").' =>
            'Inafafanua semi za kawaida ambazo zinazuia baadhi ya  anwani kwenye uangalizi wa sintaksi("Uangalizi wa Anwani za Barua pepe" umewekwa kuwa "Yes"). Tafadhali ingia regex katika uga huu kwa ajili ya anwani za barua pepe, ambazo kisintentiki zipo batili, lakini ni za lazima kwa ajili ya mfumo  (mfano "root@localhost").',
        'Defines a regular expression that filters all email addresses that should not be used in the application.' =>
            'Inafafanua semi za kawaida ambazo zinachuja anwani za barua pepe ambazo hazitakiwi kutumika katika program tumizi.',
        'Defines a useful module to load specific user options or to display news.' =>
            'Inafafanua moduli inayotumika kupakia michaguo maalum ya mtmiaji au kuonyesha taarifa.',
        'Defines all the X-headers that should be scanned.' => 'Inafafanua vichwa vyote vya X ambavyo vinatakiwa kutambazwa.',
        'Defines all the languages that are available to the application. The Key/Content pair links the front-end display name to the appropriate language PM file. The "Key" value should be the base-name of the PM file (i.e. de.pm is the file, then de is the "Key" value). The "Content" value should be the display name for the front-end. Specify any own-defined language here (see the developer documentation http://doc.otrs.org/ for more infomation). Please remember to use the HTML equivalents for non-ASCII characters (i.e. for the German oe = o umlaut, it is necessary to use the &ouml; symbol).' =>
            'Inafafanua lugha zote ambazo zinapatikana katika programu tumizi. jozi ya funguo/maudhui inaunganisha muonekano wa jina la mazingira ya mbele katika faili la PM la lugha sahihi . Thamani "Funguo" lazima iwe jina mzizi la faili la PM (mfano de.pm ni faili, na de ni thamani ya "Funguo").  Thamani "Maudhui" iwe jina la kuonyeshwa kwa ajili ya mazingira ya nyuma. Bainisha lugha yoyote iliyofafanuliwa hapa(angalia hati ya msanifu http://doc.otrs.org/ kwa taarifa zaidi). Tafadhali kumbuka kutumia nakala pacha za HTML kwa herufi ambazo sio za ASCII (mfano kwa kijerumani oe = eumlaut, ni lazima kutumia alma ya &ouml; ).',
        'Defines all the parameters for the RefreshTime object in the customer preferences of the customer interface.' =>
            'Inaelezea vigezo vyote kwa kipengele cha Muda wa kuonyesha upya katika mapendeleo ya mteja ya kiolesura cha mteja. ',
        'Defines all the parameters for the ShownTickets object in the customer preferences of the customer interface.' =>
            'Inaelezea vigezo vyote kwa kipengee cha Tiketi zilizonyeshwa katika mapendeleo ya mteja ya kiolesura cha mteja.',
        'Defines all the parameters for this item in the customer preferences.' =>
            'Inafafanua vigezo vyote vya kipengele hiki katika mapendeleo ya mteja.',
        'Defines all the possible stats output formats.' => 'Inafafanua umbizo tokeo la takwimu zote zinazowezekana.',
        'Defines an alternate URL, where the login link refers to.' => 'Inafafanua URL mbadala, ambapo kiungo cha kuingia kinarejea.',
        'Defines an alternate URL, where the logout link refers to.' => 'Inafafanua URL mbadala, ambapo kiungo cha kutoka kinarejea.',
        'Defines an alternate login URL for the customer panel..' => 'Inafafanua URL ya kuingia mbadala kwa paneli ya mteja.',
        'Defines an alternate logout URL for the customer panel.' => 'Inafafanua URL ya kutoka  mbadala kwa paneli ya mteja.',
        'Defines an external link to the database of the customer (e.g. \'http://yourhost/customer.php?CID=[% Data.CustomerID %]\' or \'\').' =>
            'Inafafanua kiungo cha nje kwenye hifadhi data ya mteja (mfano \'http://yourhost/customer.php?CID=[% Data.CustomerID %]\' or \'\').',
        'Defines from which ticket attributes the agent can select the result order.' =>
            'Inafafanua kutoka kwenye sifa gani za tiketi wakala anaweza kuchagua mpangilio wa matokeo.',
        'Defines how the From field from the emails (sent from answers and email tickets) should look like.' =>
            'Inafafanua jinsi uga wa Kutoka kutoka kwenye barua pepe (umetumwa kutoka kwenye majibu na tiketi za barua pepe) unatakiwa ufanane. ',
        'Defines if a pre-sorting by priority should be done in the queue view.' =>
            'Inafafanua kama upangaji wa awali kwa kipaumbele ufanywe kwenye mandhari ya kuona ya foleni.',
        'Defines if a pre-sorting by priority should be done in the service view.' =>
            'Inafafanua kama upangaji wa awali kwa kipaumbele ufanywe kwenye mandhari ya kuona ya huduma.',
        'Defines if a ticket lock is required in the close ticket screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Inafafanua kama kufuli la tiketi inahitajika katika mandhari ya kufunga tiketi  ya kiolesura cha wakala (kama tiketi haijafungwa bado, tiketi itafungwa na wakala wa sasa ataweka otomatiki kuwa mmiliki wake).',
        'Defines if a ticket lock is required in the email outbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Inafafanua kama kufuli la tiketi inahitajika katika mandhari yabarua pepe iliyofungwa nje ya kiolesura cha wakala (kama tiketi haijafungwa bado, tiketi itafungwa na wakala wa sasa ataweka otomatiki kuwa mmiliki wake).',
        'Defines if a ticket lock is required in the ticket bounce screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Inafafanua kama kufuli la tiketi inahitajika katika mandhari ya tiketi inayodunda  ya kiolesura cha wakala (kama tiketi haijafungwa bado, tiketi itafungwa na wakala wa sasa ataweka otomatiki kuwa mmiliki wake).',
        'Defines if a ticket lock is required in the ticket compose screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Inafafanua kama kufuli la tiketi inahitajika katika mandhari ya kutunga ya tiketi ya kiolesura cha wakala (kama tiketi haijafungwa bado, tiketi itafungwa na wakala wa sasa ataweka otomatiki kuwa mmiliki wake).',
        'Defines if a ticket lock is required in the ticket forward screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Inafafanua kama kufuli la tiketi inahitajika katika mandhari ya tiketi ya kupeleka mbele ya kiolesura cha wakala (kama tiketi haijafungwa bado, tiketi itafungwa na wakala wa sasa ataweka otomatiki kuwa mmiliki wake).',
        'Defines if a ticket lock is required in the ticket free text screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Inafafanua kama kufuli la tiketi inahitajika katika mandhari ya matini huru ya tiketi ya kiolesura cha wakala (kama tiketi haijafungwa bado, tiketi itafungwa na wakala wa sasa ataweka otomatiki kuwa mmiliki wake).',
        'Defines if a ticket lock is required in the ticket merge screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Inafafanua kama kufuli la tiketi inahitajika katika mandhari ya kuunganisha tiketi ya kiolesura cha wakala (kama tiketi haijafungwa bado, tiketi itafungwa na wakala wa sasa ataweka otomatiki kuwa mmiliki wake).',
        'Defines if a ticket lock is required in the ticket note screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Inafafanua kama kufuli la tiketi inahitajika katika mandhari ya kidokezo cha tiketi ya kiolesura cha wakala (kama tiketi haijafungwa bado, tiketi itafungwa na wakala wa sasa ataweka otomatiki kuwa mmiliki wake).',
        'Defines if a ticket lock is required in the ticket owner screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Inafafanua kama kufuli la tiketi inahitajika katika mandhari ya mmiliki wa  tiketi ya tiketi iliyokuzwa katika kiolesura cha wakala (kama tiketi haijafungwa bado, tiketi itafungwa na wakala wa sasa ataweka otomatiki kuwa mmiliki wake).',
        'Defines if a ticket lock is required in the ticket pending screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Inafafanua kama kufuli la tiketi inahitajika katika mandhari ya tiketi inayosubiri ya tiketi iliyokuzwa katika kiolesura cha wakala (kama tiketi haijafungwa bado, tiketi itafungwa na wakala wa sasa ataweka otomatiki kuwa mmiliki wake).',
        'Defines if a ticket lock is required in the ticket phone inbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Inafafanua kama kufuli la tiketi inahitajika katika mandhari ya simu ya tiketi iliyofungwa ndani ya kiolesura cha wakala (kama tiketi haijafungwa bado, tiketi itafungwa na wakala wa sasa ataweka otomatiki kuwa mmiliki wake).',
        'Defines if a ticket lock is required in the ticket phone outbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Inafafanua kama kufuli la tiketi inahitajika katika mandhari ya simu ya tiketi iliyofungwa nje ya kiolesura cha wakala (kama tiketi haijafungwa bado, tiketi itafungwa na wakala wa sasa ataweka otomatiki kuwa mmiliki wake).',
        'Defines if a ticket lock is required in the ticket priority screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Inafafanua kama kufuli la tiketi inahitajika katika mandhari ya kipaumbele ya tiketi ya tiketi iliyokuzwa  kiolesura cha wakala (kama tiketi haijafungwa bado, tiketi itafungwa na wakala wa sasa ataweka otomatiki kuwa mmiliki wake).',
        'Defines if a ticket lock is required in the ticket responsible screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Inafafanua kama kufuli la tiketi inahitajika katika mandhari ya uhusika wa tiketi ya kiolesura cha wakala (kama tiketi haijafungwa bado, tiketi itafungwa na wakala wa sasa ataweka otomatiki kuwa mmiliki wake).',
        'Defines if a ticket lock is required to change the customer of a ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Inafafanua kama kufuli la tiketi litahitajika mteja wa tiketi katika kiolesura cha wakala (kama tiketi haijafungwa bado, tiketi itafungwa na wakala wa sasa ataweka otomatiki kuwa mmiliki wake).',
        'Defines if composed messages have to be spell checked in the agent interface.' =>
            'Inafafanua kama tiketi iliyotungwa inahitaji kuangaliwa herufi katika kiolesura cha wakala.',
        'Defines if the enhanced mode should be used (enables use of table, replace, subscript, superscript, paste from word, etc.).' =>
            'Inafafanua kama hali timizi ya uimarishaji itumike(Wezesha matumizi ya jedwali, kubadilisha,hati chini, hati juu, Bandika kutoka kwenye Word, n.k.).',
        'Defines if the list for filters should be retrieve just from current tickets in system. Just for clarification, Customers list will always came from system\'s tickets.' =>
            'Inafafanua kama orodha ya vijucha inaweza kurejeshwa kutoka kwenye tiketi za sasa katika mfumo. Orodha ya wateja inatoka kwenye tiketi za mfumo. ',
        'Defines if time accounting is mandatory in the agent interface. If activated, a note must be entered for all ticket actions (no matter if the note itself is configured as active or is originally mandatory for the individual ticket action screen).' =>
            'Fafanua kama uhasibu wa muda ni lazima katika kiolesura cha wakala. Kama imeamilishwa, kidokezo lazima kiingizwe kwa matendo yenye tiketi( haijalishi kama kidokezo chenyewe kimesanidiwa kama amilifu au ni awali lazima kwa skrini kitendo ya kitendo kila moja ) .',
        'Defines if time accounting must be set to all tickets in bulk action.' =>
            'Inafafanua kama uhusishwaji wa muda lazima uwekwe katika tiketi zote katika tendo ya wingi.',
        'Defines queues that\'s tickets are used for displaying as calendar events.' =>
            'Inafafanua foleni ambazo tiketi zake zinatumika kuonyesha kama matukio ya kalenda.',
        'Defines scheduler PID update time in seconds.' => 'Inafafanua muda wa kusasihwa PID kipanga ratiba katika sekunde.',
        'Defines scheduler sleep time in seconds after processing all available tasks (floating point number).' =>
            'Inafafanua Muda wa kulala wa kipanga ratiba katika sekunde baada ya kushughulikia kazi zote zilizokuwepo (namba yenye pointi zinazoelea).',
        'Defines the IP regular expression for accessing the local repository. You need to enable this to have access to your local repository and the package::RepositoryList is required on the remote host.' =>
            'Inafafanua maelezo ya kawaida ya IP ya kufikia hifadhi ya ndani. Unahitaji kuwezesha hii ili kuweza kufikia hifadhi yako ya ndani na kifurushi:: Orodha ya hifadhi inahitajika kwa mwenyeji wa mbali.',
        'Defines the URL CSS path.' => 'Inafafanua njia ya URL CSS.',
        'Defines the URL base path of icons, CSS and Java Script.' => 'Inafafanua njia ya msingi ya URL kwa ajili ya ikoni, CSS na maandiko ya Java.',
        'Defines the URL image path of icons for navigation.' => 'Inafafanua njia ya taswira ya URL ya ikoni kwa ajili ya uabiri.',
        'Defines the URL java script path.' => 'Inafafanua njia ya maandiko ya Java ya URL.',
        'Defines the URL rich text editor path.' => 'Inafafanua njia ya mhariri wa nakala tajiri ya URL.',
        'Defines the address of a dedicated DNS server, if necessary, for the "CheckMXRecord" look-ups.' =>
            'Inafafanua anwani ya seva ya DNS iliyojitotelea, kama muhimu kwa ajili ya ukaguaji wa "Angalia rekodi ya MX".',
        'Defines the body text for notification mails sent to agents, about new password (after using this link the new password will be sent).' =>
            'Inafafanua kiini cha matini cha barua pepe za taarifa zilizotumwa kwenda kwa mawakala, kuhusu neno jipya la siri (Baada ya kutumia kiunganishi hiki neno jipya la siri lilatumwa).',
        'Defines the body text for notification mails sent to agents, with token about new requested password (after using this link the new password will be sent).' =>
            'Inafafanua kiini cha matini cha barua pepe za taarifa zilizotumwa kwenda kwa mawakala, na alama kuhusu neno jipya la siri lililoombwa (Baada ya kutumia kiunganishi hiki neno jipya la siri lilatumwa).',
        'Defines the body text for notification mails sent to customers, about new account.' =>
            'Inafafanua kiini cha matini cha barua pepe za taarifa zilizotumwa kwenda kwa wateja, kuhusu akaunti mpya.',
        'Defines the body text for notification mails sent to customers, about new password (after using this link the new password will be sent).' =>
            'Inafafanua kiini cha matini cha barua pepe za taarifa zilizotumwa kwenda kwa wateja, kuhusu neno jipya la siri (Baada ya kutumia kiunganishi hiki neno jipya la siri lilatumwa).',
        'Defines the body text for notification mails sent to customers, with token about new requested password (after using this link the new password will be sent).' =>
            'Inafafanua kiini cha matini cha barua pepe za taarifa zilizotumwa kwenda kwa wateja, na alama kuhusu neno jipya la siri lililoombwa (Baada ya kutumia kiunganishi hiki neno jipya la siri lilatumwa).',
        'Defines the body text for rejected emails.' => 'Inafafanua kiini cha matini ya barua pepe zilizokataliwa',
        'Defines the boldness of the line drawed by the graph.' => 'Inafafanua mkolezo wa mstari uliochorwa na grafu',
        'Defines the calendar width in percent. Default is 95%.' => 'Inafafanua upana wa kalenda katika silimia. Chaguo msingi ni 95%.',
        'Defines the colors for the graphs.' => 'Inafafanua rangi za grafu.',
        'Defines the column to store the keys for the preferences table.' =>
            'Inafafanua safu wima za kuhifadhi vibonye kwa ajili ya jedwali la mapendeleo.',
        'Defines the config options for the autocompletion feature.' => 'Inafafanua michaguo ya usanidi kwa ajili ya kipengele cha ukamilifu otomatiki.',
        'Defines the config parameters of this item, to be shown in the preferences view.' =>
            'Inafafanua vigezo vya usanidi vya kipengele hiki, vitaonyeshwa katika mandhari ya mapendeleo.',
        'Defines the config parameters of this item, to be shown in the preferences view. Take care to maintain the dictionaries installed in the system in the data section.' =>
            'Inafafanua vigezo vya usanidi vya kipengele hiki, vitaonyeshwa katika mandhari ya mapendeleo. Kuwa makini na kamusi zilizosanisiwa katika mfumo katika sehemu cha data',
        'Defines the connections for http/ftp, via a proxy.' => 'Inafafanua miunganiko kwa ajili ya http/ftp, kupitia seva mbadala.',
        'Defines the date input format used in forms (option or input fields).' =>
            'Inafafanua umbizo umbizo ingizo la tarehe linalotumika katika fomu (hiari au uga ingizo).',
        'Defines the default CSS used in rich text editors.' => 'Inafafanua CSS chaguo-msingi inayotumika katika wahariri wa matini tondoti.',
        'Defines the default auto response type of the article for this operation.' =>
            'Inafafanua aina ya majibu ya otomatiki chaguo msingi ya makala kwa operesheni hii.',
        'Defines the default body of a note in the ticket free text screen of the agent interface.' =>
            'Inafafanua kiini cha kidokezo chaguo msingi katika skrini ya matini huru ya kiolesura cha wakala.',
        'Defines the default front-end (HTML) theme to be used by the agents and customers. If you like, you can add your own theme. Please refer the administrator manual located at http://doc.otrs.org/.' =>
            'Inafafanua dhima ya mazingira ya mbele chaguo msingi (HTML)itakayotumika na mawakala na wateja. Kama unapenda, unaweza kuongeza dhima yako. Tafadhali rejea mwongozo wa kiongozi uliopo http://doc.otrs.org/. ',
        'Defines the default front-end language. All the possible values are determined by the available language files on the system (see the next setting).' =>
            'Inafafanua lugha ya mazingira ya mbele chaguo msingi. Thamani zote ziwezekanazo zinaamuliwa na mafaili ya lugha yaliyopo katika mfumo (Angalia mpangilio ujao).',
        'Defines the default history type in the customer interface.' => 'Inafafanua aina ya historia chaguo msingi katika kiolesura cha mteja.',
        'Defines the default maximum number of X-axis attributes for the time scale.' =>
            'Inafafanua upeo wa juu wa namba chaguo msingi ya sifa za  jira X kwa ajili ya mzani wa muda.',
        'Defines the default maximum number of search results shown on the overview page.' =>
            'Inafafanua upeo wa juu wa namba chaguo msingi ya matokeo ya utafutaji yaliyoonyeshwa katika ukurasa wa mapitio.',
        'Defines the default next state for a ticket after customer follow up in the customer interface.' =>
            'Inafafanua hali ijayo chaguo msingi ya tiketi baada ya ufuatiliaji wa mteja katika kiolesura cha mteja.',
        'Defines the default next state of a ticket after adding a note, in the close ticket screen of the agent interface.' =>
            'Inafafanua hali ijayo chaguo msingi ya tiketi baada ya kuongea kidokezo, katika skrini ya kufunga tiketi ya kiolesura cha wakala.',
        'Defines the default next state of a ticket after adding a note, in the ticket bulk screen of the agent interface.' =>
            'Inafafanua hali ijayo chaguo msingi ya tiketi baada ya kuongea kidokezo, katika skrini ya wingi wa tiketi ya kiolesura cha wakala.',
        'Defines the default next state of a ticket after adding a note, in the ticket free text screen of the agent interface.' =>
            'Inafafanua hali ijayo chaguo msingi ya tiketi baada ya kuongea kidokezo, katika skrini ya matini huru ya tiketi ya kiolesura cha wakala.',
        'Defines the default next state of a ticket after adding a note, in the ticket note screen of the agent interface.' =>
            'Inafafanua hali ijayo chaguo msingi ya tiketi baada ya kuongea kidokezo, katika skrini ya kidokezo cha tiketi ya kiolesura cha wakala.',
        'Defines the default next state of a ticket after adding a note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Inafafanua hali ijayo chaguo msingi ya tiketi baada ya kuongea kidokezo, katika skrini ya mmiliki wa tiketi ya tiiketi iliyokuzwa katika kiolesura cha wakala.',
        'Defines the default next state of a ticket after adding a note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Inafafanua hali ijayo chaguo msingi ya tiketi baada ya kuongea kidokezo, katika skrini ya tiketi inayosubiri ya tiiketi iliyokuzwa katika kiolesura cha wakala.',
        'Defines the default next state of a ticket after adding a note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Inafafanua hali ijayo chaguo msingi ya tiketi baada ya kuongea kidokezo, katika skrini ya kipaumbele cha tiketi ya tiiketi iliyokuzwa katika kiolesura cha wakala.',
        'Defines the default next state of a ticket after adding a note, in the ticket responsible screen of the agent interface.' =>
            'Inafafanua hali ijayo chaguo msingi ya tiketi baada ya kuongea kidokezo, katika skrini husika ya tiketi ya kiolesura cha wakala.',
        'Defines the default next state of a ticket after being bounced, in the ticket bounce screen of the agent interface.' =>
            'Inafafanua hali ijayo chaguo msingi ya tiketi baada ya kuongea kidokezo, katika skrini ya tiketi inayodunda ya kiolesura cha wakala.',
        'Defines the default next state of a ticket after being forwarded, in the ticket forward screen of the agent interface.' =>
            'Inafafanua hali ijayo chaguo msingi ya tiketi baada ya tiketi kutumwa mbele, katika skrini ya tiketi ya kupeleka mbele ya kiolesura cha wakala.',
        'Defines the default next state of a ticket after the message has been sent, in the email outbound screen of the agent interface.' =>
            'Inafafanua hali ijayo chaguo msingi ya tiketi baada ya ujumbe kutumwa, katika skrini ya tiketi iliyofungwa nje ya kiolesura cha wakala.',
        'Defines the default next state of a ticket if it is composed / answered in the ticket compose screen of the agent interface.' =>
            'Inafafanua hali ijayo ya tiketi chaguo msingi kama imetungwa / imejibiwa katika skrini ya kutunga ya tiketi ya kiolesura cha wakala.',
        'Defines the default note body text for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            'Inafafanua matini kiini ya kidokezo chaguo msingi kwa skrini iliyofungwa ndani ya tiketi ya simu ya kiolesura cha wakala.',
        'Defines the default note body text for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            'Inafafanua matini kiini ya kidokezo chaguo msingi kwa skrini iliyofungwa nje ya tiketi ya simu ya kiolesura cha wakala.',
        'Defines the default priority of follow up customer tickets in the ticket zoom screen in the customer interface.' =>
            'Inafafanua kipaumbele chaguo msingi cha tiketi za mteja anayefuatilia katika skrini ya tiketi iliyokuzwa katika kiolesura cha mteja.',
        'Defines the default priority of new customer tickets in the customer interface.' =>
            'Inafafanua kipaumbele chaguo msingi cha tiketi za mteja mpya katika kiolesura cha mteja.',
        'Defines the default priority of new tickets.' => 'Inafafanua kipaumbele chaguo msingi cha tiketi mpya.',
        'Defines the default queue for new customer tickets in the customer interface.' =>
            'Inafafanua foleni mchaguo msingi kwa tiketi za mteja mpya katika kiolesura cha mteja.',
        'Defines the default selection at the drop down menu for dynamic objects (Form: Common Specification).' =>
            'Inafafanu chaguo chaguo msingi katika menyu kunjuzi kwa vipengele vyenye nguvu (Kutoka: ubainishi wa kawaida).',
        'Defines the default selection at the drop down menu for permissions (Form: Common Specification).' =>
            'Inafafanu chaguo chaguo msingi katika menyu kunjuzi kwa ajili ya ruhusa  (Kutoka: ubainishi wa kawaida).',
        'Defines the default selection at the drop down menu for stats format (Form: Common Specification). Please insert the format key (see Stats::Format).' =>
            'Inafafanu chaguo chaguo msingi katika menyu kunjuzi kwa ajili ya umbizo la takwimu (Kutoka: ubainishi wa kawaida). Tafadhali ingiza kibonye umbizo (Angalia takwimu::Umbizo).',
        'Defines the default sender type for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            'Inafafanu aina ya mtumaji chaguo msingi kwa ajili ya tiketi za simu katika skrini ilifungwa ndani ya tiketi ya simu ya kiolesura cha wakala.',
        'Defines the default sender type for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            'Inafafanu aina ya mtumaji chaguo msingi kwa ajili ya tiketi za simu katika skrini ilifungwa nje ya tiketi ya simu ya kiolesura cha wakala.',
        'Defines the default sender type for tickets in the ticket zoom screen of the customer interface.' =>
            'Inafafanu aina ya mtumaji chaguo msingi kwa ajili ya tiketi katika skrini iliyokuzwa ya tiketi  ya kiolesura cha wakala.',
        'Defines the default shown ticket search attribute for ticket search screen.' =>
            'Inafafanua sifa ya tiketi iliyotafutwa iliyoonyeshwa chaguo msingi kwa skrini ya kutafuta tiketi.',
        'Defines the default shown ticket search attribute for ticket search screen. Example: "Key" must have the name of the Dynamic Field in this case \'X\', "Content" must have the value of the Dynamic Field depending on the Dynamic Field type,  Text: \'a text\', Dropdown: \'1\', Date/Time: \'Search_DynamicField_XTimeSlotStartYear=1974; Search_DynamicField_XTimeSlotStartMonth=01; Search_DynamicField_XTimeSlotStartDay=26; Search_DynamicField_XTimeSlotStartHour=00; Search_DynamicField_XTimeSlotStartMinute=00; Search_DynamicField_XTimeSlotStartSecond=00; Search_DynamicField_XTimeSlotStopYear=2013; Search_DynamicField_XTimeSlotStopMonth=01; Search_DynamicField_XTimeSlotStopDay=26; Search_DynamicField_XTimeSlotStopHour=23; Search_DynamicField_XTimeSlotStopMinute=59; Search_DynamicField_XTimeSlotStopSecond=59;\' and or \'Search_DynamicField_XTimePointFormat=week; Search_DynamicField_XTimePointStart=Before; Search_DynamicField_XTimePointValue=7\';.' =>
            'Inafafanua sifa ya tiketi iliyotafutwa iliyoonyeshwa chaguo msingi kwa skrini ya kutafuta tiketi. Mfano: "Kibonye" lazima iwe na jina la uga wenye nguvu kwa hapa ni \'X\', "Maudhui" lazima iwe na thamani ua uga wenye nguvu kutegemeana na aina ya uga wenye nguvu, Matini:\'Matini\', Kunjuzi: \'1\', Tarehe/Muda:  Mwaka wa kuanza wa majira ya muda uliopangwa X ya uga wenye nguvu uliotafutafutwa=1974; Mwezi wa kuanza wa majira ya muda uliopangwa X ya uga wenye nguvu uliotafutafutwa=01; Siku ya kuanza ya majira ya muda uliopangwa X ya uga wenye nguvu uliotafutafutwa=26; Saa ya kuanza ya majira ya muda uliopangwa X ya uga wenye nguvu uliotafutafutwa =00; Dakika ya kuanza ya majira ya muda uliopangwa X ya uga wenye nguvu uliotafutafutwa = 00; Sekunde ya kuanza ya majira ya muda uliopangwa X ya uga wenye nguvu uliotafutafutwa = 00; Mwaka wa kuisha wa majira ya muda uliopangwa X ya uga wenye nguvu uliotafutafutwa =2013; Mwezi wa kuisha wa majira ya muda uliopangwa X ya uga wenye nguvu uliotafutafutwa =01; Siku ya kuisha ya majira ya muda uliopangwa X ya uga wenye nguvu uliotafutafutwa =26; Saa ya kuisha ya majira ya muda uliopangwa X ya uga wenye nguvu uliotafutafutwa =23; Dakika ya kuisha ya majira ya muda uliopangwa X ya uga wenye nguvu uliotafutafutwa =59; Sekunde ya kuisha ya majira ya muda uliopangwa X ya uga wenye nguvu uliotafutafutwa =59; na au Umbizo la pointi ya muda X ya uga wenye nguvu uliotafutafutwa = Week; Mwanzo wa pointi ya muda X ya uga wenye nguvu uliotafutafutwa = Kabla; Thamani ya pointi ya muda X ya uga wenye nguvu uliotafutafutwa = 7;',
        'Defines the default sort criteria for all queues displayed in the queue view.' =>
            'Inafafanua upangaji wa vigezo chaguo msingi kwa foleni zote zinazoonyeshwa katika muonekano wa foleni.',
        'Defines the default sort criteria for all services displayed in the service view.' =>
            'Inafafanua upangaji wa vigezo chaguo msingi kwa huduma zote zinazoonyeshwa katika muonekano wa huduma.',
        'Defines the default sort order for all queues in the queue view, after priority sort.' =>
            'Inafafanua utaratibu wa kupanga chaguo-msingi kwafoleni zote katika mazingira ya foleni, baada ya kupanga vipaumbele.',
        'Defines the default sort order for all services in the service view, after priority sort.' =>
            'Inafafanua utaratibu wa kupanga chaguo-msingi kwa huduma zote katika mazingira ya huduma, baada ya kupanga vipaumbele.',
        'Defines the default spell checker dictionary.' => 'Inafafanua kamusi ya kuangalia herifu ya chaguo-msingi.',
        'Defines the default state of new customer tickets in the customer interface.' =>
            'Fafanua hali ya chaguo-msingi ya tiketi za mteja mpya katika kiolesura cha mteja.',
        'Defines the default state of new tickets.' => 'Inafafanua hali chaguo-msingi ya tiketi mpya.',
        'Defines the default subject for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            'Inafafanua somo chaguo-msingi kwa tiketi za simu katika skrini ya tiketi ya simu zilizofungwa ndani ya kiolesura cha wakala.',
        'Defines the default subject for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            'Inafafanua somo chaguo-msingi kwa tiketi za simu katika skrini ya tiketi ya simu zilizofungwa nje ya kiolesura cha wakala.',
        'Defines the default subject of a note in the ticket free text screen of the agent interface.' =>
            'Inafafanua somo chaguo-msingi  ya kidokezo katika skrini ya matini huru ya tiketi ya kiolesura cha wakala.',
        'Defines the default ticket attribute for ticket sorting in a ticket search of the customer interface.' =>
            'Inafafanua sifa ya tiketi chaguo-msingi kwa ajili ya kupanga tiketi katika utafutaji wa tiketi wa kiolesura cha mteja.',
        'Defines the default ticket attribute for ticket sorting in the escalation view of the agent interface.' =>
            'Inafafanua sifa ya tiketi chaguo-msingi kwa ajili ya kupanga tiketi katika mandhari ya kupanda ya kiolesura cha mteja.',
        'Defines the default ticket attribute for ticket sorting in the locked ticket view of the agent interface.' =>
            'Inafafanua sifa ya tiketi chaguo-msingi kwa ajili ya kupanga tiketi katika mandhari ya tiketi zilizofungwa ya kiolesura cha mteja.',
        'Defines the default ticket attribute for ticket sorting in the responsible view of the agent interface.' =>
            'Inafafanua sifa ya tiketi chaguo-msingi kwa ajili ya kupanga tiketi katika mandhari yanayohusika ya kiolesura cha mteja.',
        'Defines the default ticket attribute for ticket sorting in the status view of the agent interface.' =>
            'Inafafanua sifa ya tiketi chaguo-msingi kwa ajili ya kupanga tiketi katika mandhari ya hali ya kiolesura cha mteja.',
        'Defines the default ticket attribute for ticket sorting in the watch view of the agent interface.' =>
            'Inafafanua sifa ya tiketi chaguo-msingi kwa ajili ya kupanga tiketi katika mandhari ya kuangalia ya kiolesura cha mteja.',
        'Defines the default ticket attribute for ticket sorting of the ticket search result of the agent interface.' =>
            'Inafafanua sifa ya tiketi chaguo-msingi kwa ajili ya kupanga matokeo ya utafutaji wa tiketi ya kiolesura cha mteja.',
        'Defines the default ticket attribute for ticket sorting of the ticket search result of this operation.' =>
            'Inafafanua sifa ya tiketi chaguo-msingi kwa ajili ya kupanga matokeo ya utafutaji wa tiketi ya uendeshaji huu.',
        'Defines the default ticket bounced notification for customer/sender in the ticket bounce screen of the agent interface.' =>
            'Inafafanua taarifa za tiketi chaguo-msingi zilizodunda kwa mteja/mtumaji katika skrini ya tiketi zilizodunda za kiolesura cha wakala. ',
        'Defines the default ticket next state after adding a phone note in the ticket phone inbound screen of the agent interface.' =>
            'Inafafanua hali ijayo ya tiketi chaguo-msingi baada ya kuongeza kidokezo cha simu katika skrini ya simu zilizofungwa ndani za tiketi ya kiolesura cha wakala.',
        'Defines the default ticket next state after adding a phone note in the ticket phone outbound screen of the agent interface.' =>
            'Inafafanua hali ijayo ya tiketi chaguo-msingi baada ya kuongeza kidokezo cha simu katika skrini ya simu zilizofungwa nje za tiketi ya kiolesura cha wakala.',
        'Defines the default ticket order (after priority sort) in the escalation view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Inafafanua mpangilio wa tiketi chaguo-msingi (Baada ya kupanga vipaumbele) katika mandhari ya kuona kupanda ya kiolesura cha wakala. Juu: Kongwe juu. Chini: Za sasa juu.',
        'Defines the default ticket order (after priority sort) in the status view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Inafafanua mpangilio wa tiketi chaguo-msingi (Baada ya kupanga vipaumbele) katika mandhari ya kuona hali ya kiolesura cha wakala. Juu: Kongwe juu. Chini: Za sasa juu.',
        'Defines the default ticket order in the responsible view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Inafafanua mpangilio wa tiketi chaguo-msingi katika mandhari ya kuona inayohusika ya kiolesura cha wakala. Juu: Kongwe juu. Chini: Za sasa juu.',
        'Defines the default ticket order in the ticket locked view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Inafafanua mpangilio wa tiketi chaguo-msingi katika mandhari ya kuona ya tiketi iliyofungwa ya kiolesura cha wakala. Juu: Kongwe juu. Chini: Za sasa juu.',
        'Defines the default ticket order in the ticket search result of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Inafafanua mpangilio wa tiketi chaguo-msingi katika matokeo ya utafutaji ya tiketi ya kiolesura cha wakala. Juu: Kongwe juu. Chini: Za sasa juu.',
        'Defines the default ticket order in the ticket search result of the this operation. Up: oldest on top. Down: latest on top.' =>
            'Inafafanua mpangilio wa tiketi chaguo-msingi katika matokeo ya utafutaji ya tiketi ya mchakato huu. Juu: Kongwe juu. Chini: Za sasa juu.',
        'Defines the default ticket order in the watch view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Inafafanua mpangilio wa tiketi chaguo-msingi katika mandhari ya kuangalia  ya kiolesura cha wakala. Juu: Kongwe juu. Chini: Za sasa juu.',
        'Defines the default ticket order of a search result in the customer interface. Up: oldest on top. Down: latest on top.' =>
            'Inafafanua mpangilio wa tiketi chaguo-msingi katika matokeo ya utafutaji ya tiketi ya kiolesura cha mteja. Juu: Kongwe juu. Chini: Za sasa juu.',
        'Defines the default ticket priority in the close ticket screen of the agent interface.' =>
            'Fafanua kipaumbele chaguo-msingi cha tiketi katika skrini iliyofungwa ya tiketi ya kiolesura cha wakala.',
        'Defines the default ticket priority in the ticket bulk screen of the agent interface.' =>
            'Fafanua kipaumbele chaguo-msingi cha tiketi katika skrini iliyojaa ya tiketi ya kiolesura cha wakala.',
        'Defines the default ticket priority in the ticket free text screen of the agent interface.' =>
            'Fafanua kipaumbele chaguo-msingi cha tiketi katika skrini huru ya matini ya tiketi ya kiolesura cha wakala.',
        'Defines the default ticket priority in the ticket note screen of the agent interface.' =>
            'Fafanua kipaumbele chaguo-msingi cha tiketi katika skrini dokezi ya tiketi ya kiolesura cha wakala.',
        'Defines the default ticket priority in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Fafanua kipaumbele chaguo-msingi cha tiketi katika skrini ya mmiliki wa tiketi katika tiketi iliyokuzwa ya kiolesura cha wakala.',
        'Defines the default ticket priority in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Fafanua kipaumbele chaguo-msingi cha tiketi katika skrini ya kusubiri ya tiketi katika tiketi iliyokuzwa ya kiolesura cha wakala.',
        'Defines the default ticket priority in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Fafanua kipaumbele chaguo-msingi cha tiketi katika skrini ya kipaumbele ya tiketi katika tiketi iliyokuzwa ya kiolesura cha wakala.',
        'Defines the default ticket priority in the ticket responsible screen of the agent interface.' =>
            'Fafanua kipaumbele chaguo-msingi cha tiketi katika skrini husika ya tiketi ya kiolesura cha wakala.',
        'Defines the default ticket type for new customer tickets in the customer interface.' =>
            'Fafanua aina ya chaguo-msingi ya tiketi kwa tiketi za mteja mpya katika kiolesura cha mteja.',
        'Defines the default type for article in the customer interface.' =>
            'Fafanua aina ya chaguo-msingi kwa makala katika kiolesura cha mteja.',
        'Defines the default type of forwarded message in the ticket forward screen of the agent interface.' =>
            'fafanua aina ya chaguo-msingi ya ujumbe uliotumwa katika skrin ya ujumbe uluotumwa ya kiolesura cha wakala',
        'Defines the default type of the article for this operation.' => 'Fafanua aina ya chaguo-msingi ya makala kwa uendeshaji huu.',
        'Defines the default type of the message in the email outbound screen of the agent interface.' =>
            'Fafanua aina ya chaguo-msingi ya ujumbe huu katika skrini ya barua pepe ya nje ya kiole sura cha wakla',
        'Defines the default type of the note in the close ticket screen of the agent interface.' =>
            'Fafanua aina ya chaguo msingi ya kidokezo katika skrini ya tikei iliyofungwa ya kiolesura cha wakala',
        'Defines the default type of the note in the ticket bulk screen of the agent interface.' =>
            'Fafanua aina ya chaguo msingi ya kidokezo katika skrini ya tiketi za wingi ya kiole sura cha wakala.',
        'Defines the default type of the note in the ticket free text screen of the agent interface.' =>
            'Fafanua aina ya chaguo msingi ya kidokezo katika skrini ya nakala huru ya kiolesura cha wakala.',
        'Defines the default type of the note in the ticket note screen of the agent interface.' =>
            'Fafanua aina ya chaguo-msingi ya kidokezo katika skrini ya kidokezo cha tiketi ya kiolesura cha wakala.',
        'Defines the default type of the note in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Fafanua aina ya chaguo-msingi ya kidokezo katika skrini ya mmiliki wa tiketi ya tiketi iliyokuzwa katika kiolesura cha wakala.',
        'Defines the default type of the note in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Fafanua aina ya chaguo-msingi ya kidokezo katika skrini ya tiketi inayosubiri ya tiketi iliyokuzwa katika kiolesura cha wakala.',
        'Defines the default type of the note in the ticket phone inbound screen of the agent interface.' =>
            'Fafanua aina ya chaguo-msingi ya kidokezo katika skrini ya tiketi ya simu za ndani ya kiolesura cha wakala.',
        'Defines the default type of the note in the ticket phone outbound screen of the agent interface.' =>
            'Fafanua aina ya chaguo-msingi ya kidokezo katika skrini ya tiketi ya simu za nje ya kiolesura cha wakala.',
        'Defines the default type of the note in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Fafanua aina ya chaguo-msingi ya kidokezo katika skrini ya tiketi yenye kipaumbele ya tiketi iliyokuzwa katika kiolesura cha wakala.',
        'Defines the default type of the note in the ticket responsible screen of the agent interface.' =>
            'Fafanua aina ya chaguo-msingi ya kidokezo katika skrini ya tiketi inayohusika ya kiolesura cha wakala.',
        'Defines the default type of the note in the ticket zoom screen of the customer interface.' =>
            'Fafanua aina ya chaguo-msingi ya kidokezo katika skrini ya tiketi iliyokuzwa  ya kiolesura cha mteja.',
        'Defines the default used Frontend-Module if no Action parameter given in the url on the agent interface.' =>
            'Fafanua chaguo-msingi inayotumika katika Moduli-Mbelenyuma kama hakuna kigezo cha kitendo iliyotolewa na url kwa kiole sura cha wakala. ',
        'Defines the default used Frontend-Module if no Action parameter given in the url on the customer interface.' =>
            'Fafanua chaguo-msingi inayotumika katika Moduli-Mbelenyuma kama hakuna kigezo cha kitendo iliyotolewa na url kwa kiole sura cha mteja. ',
        'Defines the default value for the action parameter for the public frontend. The action parameter is used in the scripts of the system.' =>
            'Fafanua aina ya chaguo-msingi kwa kigezo cha kitendo kwa ajili ya Mbelenyuma y aumma. Kigezo cha kitendo kinatumika katika hati ya mfumo.',
        'Defines the default viewable sender types of a ticket (default: customer).' =>
            'Fafanua aina ya chaguo-msingi inayoonekana ya mtumaji ta tiketi (chaguo-msingi: mteja).',
        'Defines the dynamic fields that are used for displaying on calendar events.' =>
            'Fafanua uga zenye nguvu ambazo zinatumika kuonyesha matukio katika kalenda.',
        'Defines the filter that processes the text in the articles, in order to highlight URLs.' =>
            'Fafanua chujio linalochanganua nakala katika makala, ili kutoa mwonozo kwa URL.',
        'Defines the format of responses in the ticket compose screen of the agent interface ([% Data.OrigFrom | html %] is From 1:1, [% Data.OrigFromName | html %] is only realname of From).' =>
            'Inafafanua umbizo la majibu katika skrini ya kutunga ya tiketi ya kiolesura ya wakala  ([% Data.OrigFrom | html %] is From 1:1, [% Data.OrigFromName | html %] is only realname of From).',
        'Defines the fully qualified domain name of the system. This setting is used as a variable, OTRS_CONFIG_FQDN which is found in all forms of messaging used by the application, to build links to the tickets within your system.' =>
            'Inafafanua jina la kikoa lilifuzu la mfumo. Mpangilio huu unatumika kama unaobadilika, OTRS_CONFIG_FQDN inayopatikana katika kila umbizo la ujumbe kwa programu tumizi, kujenga viunganishi kwenye tiketi katika mfumo wako.',
        'Defines the groups every customer user will be in (if CustomerGroupSupport is enabled and you don\'t want to manage every user for these groups).' =>
            'Inafafanua makundi ambayo kila mtumiaji mteja atakuwepo (Kama Msaada wa kikundi kwa mteja haujawezeshwa na hautaki kumsimamia kila mtuiaji wa makundi haya).',
        'Defines the height for the rich text editor component for this screen. Enter number (pixels) or percent value (relative).' =>
            'Inafafanua urefu kwa kijenzi cha mhariri wa matini tajini kwa skrini hii. Ingiza namba (Pikseli) au thamani ya asilimia (Inayohusika).',
        'Defines the height for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            'Inafafanua urefu kwa kijenzi cha mhariri wa matini tajini kwa skrini hii. Ingiza namba (Pikseli) au thamani ya asilimia (Inayohusika).refu wa ',
        'Defines the height of the legend.' => 'Inafafanua urefu wa maelezo mafupi.',
        'Defines the history comment for the close ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Inafafanua maoni ya historia kwa kitendo cha skrini ya tiketi iliyofungwa, ambayo inatumika kwa ajili ya historia ya tiketi katika kiolesura cha wakala.',
        'Defines the history comment for the email ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Inafafanua maoni ya historia kwa kitendo cha skrini ya tiketi ya barua pepe, ambayo inatumika kwa ajili ya historia ya tiketi katika kiolesura cha wakala.',
        'Defines the history comment for the phone ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Inafafanua maoni ya historia kwa kitendo cha skrini ya tiketi ya simu, ambayo inatumika kwa ajili ya historia ya tiketi katika kiolesura cha wakala.',
        'Defines the history comment for the ticket free text screen action, which gets used for ticket history.' =>
            'Inafafanua maoni ya historia kwa kitendo cha skrini ya matini huru ya tiketi, ambayo inatumika kwa ajili ya historia ya tiketi katika kiolesura cha wakala.',
        'Defines the history comment for the ticket note screen action, which gets used for ticket history in the agent interface.' =>
            'Inafafanua maoni ya historia kwa kitendo cha skrini ya kidokezo cha tiketi, ambayo inatumika kwa ajili ya historia ya tiketi katika kiolesura cha wakala.',
        'Defines the history comment for the ticket owner screen action, which gets used for ticket history in the agent interface.' =>
            'Inafafanua maoni ya historia kwa kitendo cha skrini ya mmiliki wa tiketi, ambayo inatumika kwa ajili ya historia ya tiketi katika kiolesura cha wakala.',
        'Defines the history comment for the ticket pending screen action, which gets used for ticket history in the agent interface.' =>
            'Inafafanua maoni ya historia kwa kitendo cha skrini ya tiketi inayosubiri, ambayo inatumika kwa ajili ya historia ya tiketi katika kiolesura cha wakala.',
        'Defines the history comment for the ticket phone inbound screen action, which gets used for ticket history in the agent interface.' =>
            'Inafafanua maoni ya historia kwa kitendo cha skrini iliyofungwa ndani ya simu ya tiketi, ambayo inatumika kwa ajili ya historia ya tiketi katika kiolesura cha wakala.',
        'Defines the history comment for the ticket phone outbound screen action, which gets used for ticket history in the agent interface.' =>
            'Inafafanua maoni ya historia kwa kitendo cha skrini ya tiketi iliyofungwa, ambayo inatumika kwa ajili ya historia ya tiketi katika kiolesura cha wakala.',
        'Defines the history comment for the ticket priority screen action, which gets used for ticket history in the agent interface.' =>
            'Inafafanua maoni ya historia kwa kitendo cha skrini iliyofungwa nje ya simu ya tiketi, ambayo inatumika kwa ajili ya historia ya tiketi katika kiolesura cha wakala.',
        'Defines the history comment for the ticket responsible screen action, which gets used for ticket history in the agent interface.' =>
            'Inafafanua maoni ya historia kwa kitendo cha skrini inayohusika ya tiketi, ambayo inatumika kwa ajili ya historia ya tiketi katika kiolesura cha wakala.',
        'Defines the history comment for the ticket zoom action, which gets used for ticket history in the customer interface.' =>
            'Inafafanua maoni ya historia kwa kitendo cha ukuzaji wa tiketi, ambayo inatumika kwa ajili ya historia ya tiketi katika kiolesura cha wakala.',
        'Defines the history comment for this operation, which gets used for ticket history in the agent interface.' =>
            'Inafafanua maoni ya historia kwa uendeshaji  huu, ambayo inatumika kwa ajili ya historia ya tiketi katika kiolesura cha wakala.',
        'Defines the history type for the close ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Inafafanua aina ya historia kwa kitendo cha skrini ya tiketi iliyofungwa, ambayo inatumika kwa ajili ya historia ya tiketi katika kiolesura cha wakala.',
        'Defines the history type for the email ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Inafafanua aina ya historia kwa kitendo cha skrini ya tiketi ya barua pepe, ambayo inatumika kwa ajili ya historia ya tiketi katika kiolesura cha wakala.',
        'Defines the history type for the phone ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Inafafanua aina ya historia kwa kitendo cha skrini ya tiketi ya simu, ambayo inatumika kwa ajili ya historia ya tiketi katika kiolesura cha wakala.',
        'Defines the history type for the ticket free text screen action, which gets used for ticket history.' =>
            'Inafafanua aina ya historia kwa kitendo cha skrini ya matini huru ya tiketi, ambayo inatumika kwa ajili ya historia ya tiketi.',
        'Defines the history type for the ticket note screen action, which gets used for ticket history in the agent interface.' =>
            'Inafafanua aina ya historia kwa kitendo cha skrini ya kidokezo cha tiketi, ambayo inatumika kwa ajili ya historia ya tiketi katika kiolesura cha wakala.',
        'Defines the history type for the ticket owner screen action, which gets used for ticket history in the agent interface.' =>
            'Inafafanua aina ya historia kwa kitendo cha skrini ya mmiliki wa  tiketi, ambayo inatumika kwa ajili ya historia ya tiketi katika kiolesura cha wakala.',
        'Defines the history type for the ticket pending screen action, which gets used for ticket history in the agent interface.' =>
            'Inafafanua aina ya historia kwa kitendo cha skrini ya tiketi inayosubiri, ambayo inatumika kwa ajili ya historia ya tiketi katika kiolesura cha wakala.',
        'Defines the history type for the ticket phone inbound screen action, which gets used for ticket history in the agent interface.' =>
            'Inafafanua aina ya historia kwa kitendo cha skrini iliyofungwa ndani ya  simu ya tiketi, ambayo inatumika kwa ajili ya historia ya tiketi katika kiolesura cha wakala.',
        'Defines the history type for the ticket phone outbound screen action, which gets used for ticket history in the agent interface.' =>
            'Inafafanua aina ya historia kwa kitendo cha skrini iliyofungwa nje ya  simu ya tiketi, ambayo inatumika kwa ajili ya historia ya tiketi katika kiolesura cha wakala.',
        'Defines the history type for the ticket priority screen action, which gets used for ticket history in the agent interface.' =>
            'Inafafanua aina ya historia kwa kitendo cha skrini ya kipaumbele cha tiketi, ambayo inatumika kwa ajili ya historia ya tiketi katika kiolesura cha wakala.',
        'Defines the history type for the ticket responsible screen action, which gets used for ticket history in the agent interface.' =>
            'Inafafanua aina ya historia kwa kitendo cha skrini ya tiketi inayohusika, ambayo inatumika kwa ajili ya historia ya tiketi katika kiolesura cha wakala.',
        'Defines the history type for the ticket zoom action, which gets used for ticket history in the customer interface.' =>
            'Inafafanua aina ya historia kwa kitendo cha kukuza tiketi, ambayo inatumika kwa ajili ya historia ya tiketi katika kiolesura cha wakala.',
        'Defines the history type for this operation, which gets used for ticket history in the agent interface.' =>
            'Inafafanua aina ya historia kwa uendeshaji huu, ambayo inatumika kwa ajili ya historia ya tiketi katika kiolesura cha wakala.',
        'Defines the hours and week days of the indicated calendar, to count the working time.' =>
            'Inafafanua masaa na siku za wiki za kalenda iliyoonyeshwa, kuhesabu muda wa kufanya kazi.',
        'Defines the hours and week days to count the working time.' => 'Inafafanua masaa na siku za wiki za kuhesabu muda wa kufanya kazi.',
        'Defines the key to be checked with Kernel::Modules::AgentInfo module. If this user preferences key is true, the message is accepted by the system.' =>
            'Inafafanua kibonye cha kuangaliwa na moduli ya Kiini::Moduli::Taarifa Za Wakala. Kama huyu mtumiaji anapendelea kibonye cha ndio, ujumbe utakubaliwa na mfumo.',
        'Defines the key to check with CustomerAccept. If this user preferences key is true, then the message is accepted by the system.' =>
            'Inafafanua kibonye cha kuangalia na Ukubali wa mteja. Kama huyu mtumiaji anapendelea kibonye cha ndio, ujumbe utakubaliwa na mfumo.',
        'Defines the legend font in graphs (place custom fonts in var/fonts).' =>
            'Inafafanua fonti ya maelezo mafupi katika grafu (Inaweka fonti za desturi katika fonti mbalimbali).',
        'Defines the link type \'Normal\'. If the source name and the target name contain the same value, the resulting link is a non-directional one; otherwise, the result is a directional link.' =>
            'Inafafanua aina ya kiunganishi \'Kawaida\'.Kama jina la chanzo na jina lengwa yana thamani sawa, kiunganishi kilichotokea hakina uelekeo;vinginevyo ni kiungo chenye uelekeo.',
        'Defines the link type \'ParentChild\'. If the source name and the target name contain the same value, the resulting link is a non-directional one; otherwise, the result is a directional link.' =>
            'Inafafanua aina ya kiunganishi \'ZaziMtoto\'.Kama jina la chanzo na jina lengwa yana thamani sawa, kiunganishi kilichotokea hakina uelekeo;vinginevyo ni kiungo chenye uelekeo.',
        'Defines the link type groups. The link types of the same group cancel one another. Example: If ticket A is linked per a \'Normal\' link with ticket B, then these tickets could not be additionally linked with link of a \'ParentChild\' relationship.' =>
            'Inafafanua aina ya kiunganishi vikundi. Aina za viunganishi zilizokatika kikundi kimoja zinajifuta zenyewe.Mfano: Kama tiketi A imeunganishwa na kiunganishi \'Kawaida\' na tiketi B, tiketi hizi haziwezi kuunganishwa tena na kiunganishi kutoka \'Zazi mtoto\'. ',
        'Defines the list of online repositories. Another installations can be used as repository, for example: Key="http://example.com/otrs/public.pl?Action=PublicRepository;File=" and Content="Some Name".' =>
            'Inafafanua orodha ya hifadhi za mtandaoni. Usanidi mwingine unaweza kutumika kama hifadhi, kwa mfano: kibonye="http://example.com/otrs/public.pl?Action=PublicRepository;File=" na maudhui="Baadhi ya majina".',
        'Defines the list of possible next actions on an error screen.' =>
            'Inafafanua orodha ya matendo yanayowezekana yajayo katika skrini ya makosa.',
        'Defines the list of types for templates.' => 'Infafanua aina ya orodha kwa vielezo.',
        'Defines the location to get online repository list for additional packages. The first available result will be used.' =>
            'Inafafanua sehemu ya kupata orodha hifadhi mtandaoni kwa vifurushi vilivyoongezwa. Jibu la kwanza lililopo litatumika. ',
        'Defines the log module for the system. "File" writes all messages in a given logfile, "SysLog" uses the syslog daemon of the system, e.g. syslogd.' =>
            'Inafafanua moduli batli kwa mfumo. "Faili" inaandika jumbe zote katika faili batli lilipo, "BatliMfumo" unatumia batli mfumo jini wa mfumo mfano syslogd',
        'Defines the maximal size (in bytes) for file uploads via the browser. Warning: Setting this option to a value which is too low could cause many masks in your OTRS instance to stop working (probably any mask which takes input from the user).' =>
            'Inafafanua upeo wa juu wa ukubwa (katika baiti) kwa ajili ya kupakia faili kwa kivinjari. Onyo: kuwekea chaguo hili thamani ambayo ni ndogo sana inaweza kusababisha barakoa nyingi katika OTRS yako kuacha kufanya kazi (Pengine barakoa inayochukua miingizo kutoka kwa mtumiaji)',
        'Defines the maximal valid time (in seconds) for a session id.' =>
            'Inafafanua upeo wa juu wa muda halali (katika sekunde) kwa kitambulisho cha kipindi.',
        'Defines the maximum length (in characters) for a scheduler task data. WARNING: Do not modify this setting unless you are sure of the current Database length for \'task_data\' filed from \'scheduler_data_list\' table.' =>
            'Inafafanua urefu wa upeo wa juu (katika herufi) kwa ajili data za kazi za kipanga ratiba. ONYO: Usirekebishe mpangilio huu isipokuwa una hakika na urefu wa hifadhi data ya sasa kwa \'Kazi_data\' imehifadhiwa kwenye jedwali \'Orodha_ya data_ya kipanga ratiba\'.',
        'Defines the maximum number of pages per PDF file.' => 'Inafafanua namba ya upeo wa juu ya kurasa lwa kila faili la PDF.',
        'Defines the maximum number of quoted lines to be added to responses.' =>
            'Inafafanua namba ya upeo wa juu ya mistari iliyonukuliwa kuongezwa katika majibu.',
        'Defines the maximum size (in MB) of the log file.' => 'Inafafanua ukubwa wa upeo wa juu (katika MB) wa faili la batli. ',
        'Defines the module that shows a generic notification in the agent interface. Either "Text" - if configured - or the contents of "File" will be displayed.' =>
            'Inafafanua moduli inayoonyesha taarifa ya ujumla katika kiolesura cha wakala. Kama "Nakala" imesanidiwa au maudhui ya "File" yataonyeshwa.',
        'Defines the module that shows all the currently loged in customers in the agent interface.' =>
            'Inafafanua moduli inayoonyesha wateja wote walioingia sasa katika kiolesura cha wakala.',
        'Defines the module that shows all the currently logged in agents in the agent interface.' =>
            'Inafafanua moduli inayoonyesha mawakala wote walioingia sasa katika kiolesura cha wakala.',
        'Defines the module that shows the currently loged in agents in the customer interface.' =>
            'Inafafanua moduli inayoonyesha mawakala wote walioingia sasa katika kiolesura cha mteja.',
        'Defines the module that shows the currently loged in customers in the customer interface.' =>
            'Inafafanua moduli inayoonyesha wateja wote walioingia sasa katika kiolesura cha mteja.',
        'Defines the module to authenticate customers.' => 'Inafafanua moduli ya kuwahalalisha wateja.',
        'Defines the module to display a notification in different interfaces on different occasions for OTRS Business Solution™.' =>
            'Inafafanua moduli ya kuonyesha taarifa katika violesura mbalimbali katika matukio mbalimbali kwa ajili ya OTRS Business Solution™.',
        'Defines the module to display a notification in the agent interface if the scheduler is not running.' =>
            'Inafafanua moduli ya kuonyesha taarifa katika kiolesura cha wakala kama kipanga ratiba hakifanyi kazi.',
        'Defines the module to display a notification in the agent interface, if the agent is logged in while having out-of-office active.' =>
            'Inafafanua moduli ya kuonyesha taarifa katika kiolesura cha wakala, kama wakala aliingiia  nje-ya-ofisi ikiwa amilifu.',
        'Defines the module to display a notification in the agent interface, if the agent is logged in while having system maintenance active.' =>
            'Inafafanua moduli ya kuonyesha taarifa katika kiolesura cha wakala, kama wakala aliingia wakati matengenezo ya mfumo ikiwa amilifu.',
        'Defines the module to display a notification in the agent interface, if the system is used by the admin user (normally you shouldn\'t work as admin).' =>
            'Inafafanua moduli ya kuonyesha taarifa katika kiolesura cha wakala, kama mfumo unatumika na mtumiaji wa muongozaji(mara zote usipende kufanya kazi kama kiongozi)',
        'Defines the module to generate html refresh headers of html sites, in the customer interface.' =>
            'Inafafanua Moduli ya kutengeneza vichwa vya kuonesha upya vya hatml ya tovuti ya html, katika kiolesura cha mteja.',
        'Defines the module to generate html refresh headers of html sites.' =>
            'Inafafanua Moduli ya kutengeneza vichwa vya kuonesha upya vya hatml ya tovuti ya html.',
        'Defines the module to send emails. "Sendmail" directly uses the sendmail binary of your operating system. Any of the "SMTP" mechanisms use a specified (external) mailserver. "DoNotSendEmail" doesn\'t send emails and it is useful for test systems.' =>
            'Inafafanua moduli ya kutuma barua pepe. "TumaBarua pepe" moja kwa moja  inatumia bainari ya tumabaruapepe ya mfumo endeshi. Taratibu yoyote ya "SMTP" inatumia seva maalum (nje) ya baruapepe. "UsitumeBaruapepe" haitumi barua pepe na inafaa kwa majaribio ya mfumo.',
        'Defines the module used to store the session data. With "DB" the frontend server can be splitted from the db server. "FS" is faster.' =>
            'Inafafanua moduli inayotumika kuhifadhi data ya kipindi. Na "DB" seva ya mazingira ya mbele inaweza kugawanywa kutoka kwenye seva ya db. "FS" ni haraka.',
        'Defines the name of the application, shown in the web interface, tabs and title bar of the web browser.' =>
            'Inafafanua jina la programu tumizi, inayoonyeshwa katikakiolesura cha wavuti, vichupo na ufio wa kichwa wa kivinjari cha wavuti.',
        'Defines the name of the column to store the data in the preferences table.' =>
            'Inafafanua jina la safu wima ya kuhifadhi data katika jedwali la mapendeleo.',
        'Defines the name of the column to store the user identifier in the preferences table.' =>
            'Inafafanua jina la safu wima ya kuhifadhi kitambulishi cha mtumiaji katika jedwali la mapendeleo',
        'Defines the name of the indicated calendar.' => 'Fafanua jina la kalenda iliyoonyeshwa.',
        'Defines the name of the key for customer sessions.' => 'Fafanua jina la funguo kwa vipindi vya mteja.',
        'Defines the name of the session key. E.g. Session, SessionID or OTRS.' =>
            'Fafanua jina la funguo wa kipindi.Mfano Kipindi, Kitambulisho cha kipindi au OTRS.',
        'Defines the name of the table, where the customer preferences are stored.' =>
            'Fafanua jina la jedwali, ambalo mapendekezo ya mteja yamehifadhiwa.',
        'Defines the next possible states after composing / answering a ticket in the ticket compose screen of the agent interface.' =>
            'Fafanua hali zinafouta zinazowezekana baada ya kutunga/kujibu tiketi katika skrini ta kutunga tiketi ya kiolesura  cha wakala.',
        'Defines the next possible states after forwarding a ticket in the ticket forward screen of the agent interface.' =>
            'Fafanua hali zinazifuata baada ya kupeleka tiketi katika skrini ya kutuma mbele ya tiketi ya kiolesura cha tiketi.',
        'Defines the next possible states after sending a message in the email outbound screen of the agent interface.' =>
            'Fafanua hali zinazofuata zinazowezekana baada ya kutuma ujumbe katika skrini ya barua pepe ya nje ya kiolesura cha wakala.',
        'Defines the next possible states for customer tickets in the customer interface.' =>
            'Fafanua hali zinazofuata zinazowezekana kwa tiketi za mteja katika kiolesura cha mteja.',
        'Defines the next state of a ticket after adding a note, in the close ticket screen of the agent interface.' =>
            'Fafanua hali zinafouata za tiketi baada ya kuongeza kidokezo, katika  skrini ya tiketi iliyofungwa ya kiolesura cha wakala.',
        'Defines the next state of a ticket after adding a note, in the ticket bulk screen of the agent interface.' =>
            'Inafafanua hali ijayo ya tiketi baada ya kuongeza kidokezo, katika skrini ya wingi ya tiketi ya kiolesura cha wakala.',
        'Defines the next state of a ticket after adding a note, in the ticket free text screen of the agent interface.' =>
            'Inafafanua hali ijayo ya tiketi baada ya kuongeza kidokezo, katika skrini ya matini huru ya tiketi ya kiolesura cha wakala.',
        'Defines the next state of a ticket after adding a note, in the ticket note screen of the agent interface.' =>
            'Inafafanua hali ijayo ya tiketi baada ya kuongeza kidokezo, katika skrini ya kidokezo cha tiketi ya kiolesura cha wakala.',
        'Defines the next state of a ticket after adding a note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Inafafanua hali ijayo ya tiketi baada ya kuongeza kidokezo, katika skrini ya mmiliki wa tiketi ya tiketi iliyokuzwa katika kiolesura cha wakala.',
        'Defines the next state of a ticket after adding a note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Inafafanua hali ijayo ya tiketi baada ya kuongeza kidokezo, katika skrini ya  tiketi ilinayosubiri ya tiketi iliyokuzwa katika kiolesura cha wakala.',
        'Defines the next state of a ticket after adding a note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Inafafanua hali ijayo ya tiketi baada ya kuongeza kidokezo, katika skrini ya kipaumbele cha tiketi ya tiketi iliyokuzwa katika kiolesura cha wakala.',
        'Defines the next state of a ticket after adding a note, in the ticket responsible screen of the agent interface.' =>
            'Inafafanua hali ijayo ya tiketi baada ya kuongeza kidokezo, katika skrini ya  tiketi inayohusika ya kiolesura cha wakala.',
        'Defines the next state of a ticket after being bounced, in the ticket bounce screen of the agent interface.' =>
            'Inafafanua hali ijayo ya tiketi baada ya kuongeza kidokezo, katika skrini ya  tiketi inayodunda ya kiolesura cha wakala.',
        'Defines the next state of a ticket after being moved to another queue, in the move ticket screen of the agent interface.' =>
            'Inafafanua hali ijayo ya tiketi baada ya kuhamishiwa kwenye foleni nyingine, katika skrini ya kuhamisha tiketi ya kiolesura cha wakala.',
        'Defines the number of header fields in frontend modules for add and update postmaster filters. It can be up to 99 fields.' =>
            'Fafanua namba za uga wa kichwa katika moduli za kiolesura kwa kuongeza na kusasisha kichuja cha mchapishajimkuu. Inawezakuwa hadi uga 99.',
        'Defines the parameters for the customer preferences table.' => 'Fafanua vigezo kwa jedwali la upendeleo la mteja.',
        'Defines the parameters for the dashboard backend. "Cmd" is used to specify command with parameters. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin.' =>
            'Fafanua vigezo kwa ajili ya dashibodi ya mandharinyuma. "Cmd" inatumika kubainisha amri zenye vigezo "Kikundi" inatumika kuzuia uwezo kwenye programu jalizi (mfano. kikundi: kiongozi; kikundi cha 1; kikundi cha 2;) \'\'chaguo-msingi\'\' inaonyesha kama programu jalizi imewezeshwa  kwa chaguo msingiau kama mtumiaji anahitaji kuiwezesha kwa mkono. "Hifadhi muda TTL" inaonyesha muda wa kuisha wa hifadhimuda katika dakika kwa programu jalizi.',
        'Defines the parameters for the dashboard backend. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin.' =>
            'Fafanua vigezo kwa ajili ya dashibodi ya mandharinyuma. "Kikundi" inatumika kuzuia uwezo kwenye programu jalizi (mfano. kikundi: kiongozi; kikundi cha 1; kikundi cha 2;) \'\'chaguo-msingi\'\' inaonyesha kama programu jalizi imewezeshwa  kwa chaguo msingiau kama mtumiaji anahitaji kuiwezesha kwa mkono. "Hifadhi muda TTL" inaonyesha muda wa kuisha wa hifadhimuda katika dakika kwa programu jalizi.',
        'Defines the parameters for the dashboard backend. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" defines the cache expiration period in minutes for the plugin.' =>
            'Fafanua vigezo kwa ajili ya dashibodi ya mandharinyuma. "Kikomo" inafafanua namba ya maingizo yanayoonyeshwa kwa chaguo-msingi. "Kikundi" inatumika kuzuia uwezo kwenye programu jalizi (mfano. kikundi: kiongozi; kikundi cha 1; kikundi cha 2;) \'\'chaguo-msingi\'\' inaonyesha kama programu jalizi imewezeshwa  kwa chaguo msingiau kama mtumiaji anahitaji kuiwezesha kwa mkono. "Hifadhi muda TTL" inaonyesha muda wa kuisha wa hifadhimuda katika dakika kwa programu jalizi.',
        'Defines the parameters for the dashboard backend. "Limit" defines the number of entries displayed by default. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin.' =>
            'Fafanua vigezo kwa ajili ya dashibodi ya mandharinyuma. "Kikomo" inafafanua namba ya maingizo yanayoonyeshwa kwa chaguo-msingi. "Kikundi" inatumika kuzuia uwezo kwenye programu jalizi (mfano. kikundi: kiongozi; kikundi cha 1; kikundi cha 2;) \'\'chaguo-msingi\'\' inaonyesha kama programu jalizi imewezeshwa  kwa chaguo msingiau kama mtumiaji anahitaji kuiwezesha kwa mkono. "Hifadhi muda TTL" inaonyesha muda wa kuisha wa hifadhimuda katika dakika kwa programu jalizi.',
        'Defines the parameters for the dashboard backend. "Limit" defines the number of entries displayed by default. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" defines the cache expiration period in minutes for the plugin.' =>
            'Fafanua vigezo kwa ajili ya dashibodi ya mandharinyuma. "Kikomo" inafafanua namba ya maingizo yanayoonyeshwa kwa chaguo-msingi. "Kikundi" inatumika kuzuia uwezo kwenye programu jalizi (mfano. kikundi: kiongozi; kikundi cha 1; kikundi cha 2;) \'\'chaguo-msingi\'\' inaonyesha kama programu jalizi imewezeshwa  kwa chaguo msingiau kama mtumiaji anahitaji kuiwezesha kwa mkono. "Hifadhi muda TTLLocal" inaonyesha muda wa kuisha wa hifadhimuda katika dakika kwa programu jalizi.',
        'Defines the password to access the SOAP handle (bin/cgi-bin/rpc.pl).' =>
            'Fafanua neno la siri la kufikia kishiko cha SOAP (bin/cgi-bin/rpc.pl).',
        'Defines the path and TTF-File to handle bold italic monospaced font in PDF documents.' =>
            'Fafanua njia na faili la TTF  kumudu fonti za italiki za herufi nzito za nafasimoja katika waraka wa PDF.',
        'Defines the path and TTF-File to handle bold italic proportional font in PDF documents.' =>
            'Fafanua njia na faili la TTF  kumudu fonti za italiki za herufi nzito zilizosawa katika waraka wa PDF.',
        'Defines the path and TTF-File to handle bold monospaced font in PDF documents.' =>
            'Fafanua njia na faili la TTF  kumudu fonti za herufi nzito za nafasimoja katika waraka wa PDF.',
        'Defines the path and TTF-File to handle bold proportional font in PDF documents.' =>
            'Fafanua njia na faili la TTF  kumudu fonti za herufi nzito zilizosawa katika waraka wa PDF.',
        'Defines the path and TTF-File to handle italic monospaced font in PDF documents.' =>
            'Fafanua njia na faili la TTF  kumudu fonti za italiki za nafasimoja katika waraka wa PDF.',
        'Defines the path and TTF-File to handle italic proportional font in PDF documents.' =>
            'Fafanua njia na faili la TTF  kumudu fonti za italiki zilizosawa katika waraka wa PDF.',
        'Defines the path and TTF-File to handle monospaced font in PDF documents.' =>
            'Fafanua njia na faili la TTF  kumudu fonti za nafasimoja katika waraka wa PDF.',
        'Defines the path and TTF-File to handle proportional font in PDF documents.' =>
            'Fafanua njia na faili la TTF  kumudu fonti zilizosawa katika waraka wa PDF.',
        'Defines the path for scheduler to store its console output (SchedulerOUT.log and SchedulerERR.log).' =>
            'Inafafanua njia kwa ajili ya kipanga ratiba kuhifadhi matokeo yake ya kiweko (SchedulerOUT.log na SchedulerERR.log).',
        'Defines the path of the shown info file, that is located under Kernel/Output/HTML/Standard/CustomerAccept.dtl.' =>
            'Inafafanua njia faili la taarifa iliyoonyeshwa, ambayo imewekwa chini ya Kernel/Output/HTML/Standard/CustomerAccept.dtl.',
        'Defines the path to PGP binary.' => 'Inafafanua njia ya kufika kwenye jozi ya PGP.',
        'Defines the path to open ssl binary. It may need a HOME env ($ENV{HOME} = \'/var/lib/wwwrun\';).' =>
            'Inafafanua njia ya kufungua jozi ya ssl. Inaweza kuhitaji HOME env($ENV{HOME} = \'/var/lib/wwwrun\';).',
        'Defines the placement of the legend. This should be a two letter key of the form: \'B[LCR]|R[TCB]\'. The first letter indicates the placement (Bottom or Right), and the second letter the alignment (Left, Right, Center, Top, or Bottom).' =>
            'Inafafanua kubadilishwa kwa maelezo mafupi. Hii iwe ya funguo ya herufi mbili yenye aina ya: \'B[LCR]|R[TCB]\'. Herufi ya kwanza inaonyesha kubadilishwa (chini au kulia), na herufi ya pili inaonyesha mpangilio (Kushoto, Kulia, Katikati, juu au Chini).',
        'Defines the postmaster default queue.' => 'Inafafanua foleni chaguo msingi ya mkuu wa posta.',
        'Defines the priority in which the information is logged and presented.' =>
            'Inafafanua kipaumbele ambacho taarifa zinawekwa batli na kuwasilishwa.',
        'Defines the receipent target of the phone ticket and the sender of the email ticket ("Queue" shows all queues, "System address" displays all system addresses) in the agent interface.' =>
            '',
        'Defines the receipent target of the tickets ("Queue" shows all queues, "SystemAddress" displays all system addresses) in the customer interface.' =>
            'Inafafanua lengo la mpokeaji wa tiketi ("Foleni" inaonyesha foleni zote, "Anwani ya Mfumo" inaonyesha anwani zote za mfumo) katika kiolesura cha mteja. ',
        'Defines the required permission to show a ticket in the escalation view of the agent interface.' =>
            'Inafafanua ruhusa zinazohitajika kuonyesha tiketi katika mandhari ya kupandishwa ya kiolesura cha wakala.',
        'Defines the search limit for the stats.' => 'Inafafanua kikomo cha utafutaji kwa ajili ya takwimu.',
        'Defines the sender for rejected emails.' => 'Inamfafanua mtumaji wa barua pepe zilizolizokataliwa.',
        'Defines the separator between the agents real name and the given queue email address.' =>
            'Inafafanua kitenganishi kati ya majina halisi la mawakala na anwani za barua pepe za foleni zilizogaiwa.',
        'Defines the spacing of the legends.' => 'Inafafanua nafasi kati ya maelezo mafupi.',
        'Defines the standard permissions available for customers within the application. If more permissions are needed, you can enter them here. Permissions must be hard coded to be effective. Please ensure, when adding any of the afore mentioned permissions, that the "rw" permission remains the last entry.' =>
            'Inafafanua ruhusa zinazopatikana za kiwango kwa wateja ndani ya programu tumizi. Kama ruhusa zaidi zinahitajika, unaweza kuziingiza hapa. Ruhusa lazima zifafanuliwe kuwa za ufanisi. Tafadhali hakikisha kwamba wakati wa kuongeza ruhusa zozote zilizotajwa kabla, kwamba ruhusa ya "rw" ibakie kuwa ingizo la mwisho.',
        'Defines the standard size of PDF pages.' => 'Inafafanua kiwango cha ukubwa wa kurasa za PDF. ',
        'Defines the state of a ticket if it gets a follow-up and the ticket was already closed.' =>
            'Inafafanua hali ya tiketi kama ikipata kufuatiliwa  na tiketi ilikuwa tayari imefungwa. ',
        'Defines the state of a ticket if it gets a follow-up.' => 'Inafafanua hali ya tiketi kama ikipata kufatiliwa.',
        'Defines the state type of the reminder for pending tickets.' => 'Inafafanua aina ya hali ya kikumbusho cha tiketi zinazogoja.',
        'Defines the subject for notification mails sent to agents, about new password.' =>
            'Inafafanua somo kwa barua pepe za taarifa zilizotumwa kwa mawakala, kuhusu neno jipya la siri. ',
        'Defines the subject for notification mails sent to agents, with token about new requested password.' =>
            'Inafafanua somo kwa ajili ya barua pepe za taarifa zilizotumwa kwa mawakala, na alama ya neno jipya la siri lililoombwa.',
        'Defines the subject for notification mails sent to customers, about new account.' =>
            'Inafafanua somo kwa ajili ya barua pepe za taarifa zilizotumwa kwa wateja, kuhusu akaunti mpya.',
        'Defines the subject for notification mails sent to customers, about new password.' =>
            'Inafafanua somo kwa ajili ya barua pepe za taarifa zilizotumwa kwa wateja, kuhusu neno jipya la siri.',
        'Defines the subject for notification mails sent to customers, with token about new requested password.' =>
            'Inafafanua somo kwa ajili ya barua pepe za taarifa zilizotumwa kwa wateja, na alama ya neno jipya la siri lililoombwa.',
        'Defines the subject for rejected emails.' => 'Inafafanua somo kwa barua pepe zilizokataliwa.',
        'Defines the system administrator\'s email address. It will be displayed in the error screens of the application.' =>
            'Inafafanua anwani ya barua pepe ya msimamizi wa mfumo. Itaonyeshwa katika skrini za makosa ya programu tumizi.',
        'Defines the system identifier. Every ticket number and http session string contains this ID. This ensures that only tickets which belong to your system will be processed as follow-ups (useful when communicating between two instances of OTRS).' =>
            'Inafafanua kitambulishi cha mfumo. Kila namba ya tiketi na tungo ya kipindi cha http inacho kitambulisho hiki. Hii inahakikisha kwamba kila tiketi ambayo ipo katika mfumo wako itashughulikiwa kama iliyokuwa inafuatiliwa (Inatumika wakati wa kuwasiliana kati ya mifani 2 ya OTRS).',
        'Defines the target attribute in the link to external customer database. E.g. \'AsPopup PopupType_TicketAction\'.' =>
            'Inafafanua sifa ya lengo katika kiunganishi cha hifadhi data ya mteja ya nje. Mfano \'AsPopup PopupType_TicketAction\'.',
        'Defines the target attribute in the link to external customer database. E.g. \'target="cdb"\'.' =>
            'Inafafanua sifa ya lengo katika kiunganishi cha hifadhi data ya mteja ya nje. Mfano \'target="cdb"\'.',
        'Defines the ticket fields that are going to be displayed calendar events. The "Key" defines the field or ticket attribute and the "Content" defines the display name.' =>
            'Inafafanua uga za tiketi ambazo yataonyesha matukio ya kalenda. "Ufunguo" unafafanua uga au sifa ya tiketi na "Maudhui" inafafanua jina linaloonyeshwa.',
        'Defines the time in days to keep log backup files.' => 'Inafafanua muda katika siku kuweka mafaili chelezo batli.',
        'Defines the time in seconds after which the Scheduler performs an automatic self-restart.' =>
            'Inafafanua muda katika sekunde ambayo kipanga ratiba kitafanya kuanza upya kwa otomatiki.',
        'Defines the time zone of the indicated calendar, which can be assigned later to a specific queue.' =>
            'Inafafanua majira ya masaa yaliyoonyeshwa katika kalenda, ambayo yatapewa baadae kwa foleni maalum.',
        'Defines the title font in graphs (place custom fonts in var/fonts).' =>
            'Inafafanua fonti ya kichwa katika grafu (weka fonti ya kawaifda katika var/fonti).',
        'Defines the type of protocol, used by the web server, to serve the application. If https protocol will be used instead of plain http, it must be specified here. Since this has no affect on the web server\'s settings or behavior, it will not change the method of access to the application and, if it is wrong, it will not prevent you from logging into the application. This setting is only used as a variable, OTRS_CONFIG_HttpType which is found in all forms of messaging used by the application, to build links to the tickets within your system.' =>
            'Inafafanua aina ya itifaki, inayotumika na seva ya tovuti, kuihudumia programu tumizi. Itifaki ya https itatumika badala ya http iliyowazi, laizma ibainishwe hapa. Kutokana na kutokuwa na madhara katika mipangilio ya wavuti au tabia, haitabadilisha namna ya kufikia programu tumizi na, kama haipo sahihi haitokuzuia wewe kuingia kwenye programu tumizi. Mpangilio huu unatumika kama thamani inayobadilika tu, aina ya OTRS_CONFIG_Http ambayo ipo katika namna zote za ujumbe zinazotumika na programu tumizi, kujenga viunganishi kwenda kwenye tiketi ndani ya mfumo wako.',
        'Defines the used character for plaintext email quotes in the ticket compose screen of the agent interface. If this is empty or inactive, original emails will not be quoted but appended to the response.' =>
            'Inafafanua tabia iliyotumika kwa ajili ya nukuu za barua pepe za makala iliyowazi katika skrini ya kutunga tiketi ya kiolesura cha wakala. Kama ipo tupu au haija amilishwa, barua pepe halisi hatizonukuliwa lakini zita ambatanishwa kwenye majibu.',
        'Defines the user identifier for the customer panel.' => 'Inafafanua kitambulishi cha mtumiaji kwa paneli ya mteja.',
        'Defines the username to access the SOAP handle (bin/cgi-bin/rpc.pl).' =>
            'Inafafanua jina la mtuaji kufikia kishiko cha SOAP (bin/cgi-bin/rpc.pl).',
        'Defines the valid state types for a ticket.' => 'Inafafanua aina ya hali halali ya tiketi.',
        'Defines the valid states for unlocked tickets. To unlock tickets the script "bin/otrs.UnlockTickets.pl" can be used.' =>
            'Inafafanua aina ya hali halali ya tiketi zilizofunguliwa. Kufungua tiketi hati "bin/otrs.UnlockTickets.pl"  inaweza kutumika.',
        'Defines the viewable locks of a ticket. Default: unlock, tmp_lock.' =>
            'Inafafanua kufuli zinazooneka za tiketi. Chaguo: fungua, tmp_lock.',
        'Defines the width for the rich text editor component for this screen. Enter number (pixels) or percent value (relative).' =>
            'Inafafanua upana kwa ajili ya kijenzi wa kihariri cha matini tajiri kwa skrini hii. Ingiza namba (pikseli) au thamani ya asilimia (inayohusiana).',
        'Defines the width for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            'Inafafanua upana kwa ajili ya kijenzi wa kihariri cha matini tajiri. Ingiza namba (pikseli) au thamani ya asilimia (inayohusiana).',
        'Defines the width of the legend.' => 'Inafafanua upana wa maelezo mafupi.',
        'Defines which article sender types should be shown in the preview of a ticket.' =>
            'Inafafanu aina zipi za makala ya mtumaji zionyeshwe katika kihakiki cha tiketi.',
        'Defines which items are available for \'Action\' in third level of the ACL structure.' =>
            'Inafafa vipengelee ambavyo vinapatikana kwa ajili ya \'Kitendo\' katika ngazi ya tatu ya muundo wa ACL.',
        'Defines which items are available in first level of the ACL structure.' =>
            'Inafafanua vipengele ambavyo vinapatikana katika ngazi ya kwanza ya muundo wa ACL.',
        'Defines which items are available in second level of the ACL structure.' =>
            'Inafafanua vipengele ambavyo vinapatikana katika ngazi ya pili ya muundo wa ACL.',
        'Defines which states should be set automatically (Content), after the pending time of state (Key) has been reached.' =>
            'Inafafanua hali ipi iwekwe otomatiki (maudhui), baada ya muda wa kusubiri wa hali (funguo) kufikia.',
        'Defines wich article type should be expanded when entering the overview. If nothing defined, latest article will be expanded.' =>
            'Inafafanua aina ipi ya makala iongezwe wakati wa kuingiza mapitio. Kama hakuna hakuna iliyofafanuliwa, makala ya sasa itaongezwa.',
        'Defines, which tickets of which ticket state types should not be listed in linked ticket lists.' =>
            'Inafafanua tiketi ambazo aina ya hali ya tiketi isiorodheshwe katika orodha ya tiketi zilizounganishwa.',
        'Deleted link to ticket "%s".' => 'Kiunganisho kwa tiketi "%s" kilichofutwa.',
        'Deletes a session if the session id is used with an invalid remote IP address.' =>
            'Inafuta kipindi kama kitambulisho cha kipindi kinatumika na anwani batili ya IP ya mbali.',
        'Deletes requested sessions if they have timed out.' => 'Inafuta vipindi vilivyoombwa kama vina muda ulioisha.',
        'Deploy and manage OTRS Business Solution™.' => 'Tumia na simamia OTRS Business Solution™.',
        'Determines if the list of possible queues to move to ticket into should be displayed in a dropdown list or in a new window in the agent interface. If "New Window" is set you can add a move note to the ticket.' =>
            'Itaamua kama orodha za foleni zinaaowezekana kuhamisha tiketi zionyeshwe katika orodha kunjuzi au katika window mpya ya kiolesura cha wakala. Kama "Window Mpya" imewekwa unaweza kuongeza kidokezo cha kuhamisha katika tiketi.',
        'Determines if the statistics module may generate ticket lists.' =>
            'Inaamua kaam moduli ya takwimu inaweza kutengeneza orodha za tiketi.',
        'Determines the next possible ticket states, after the creation of a new email ticket in the agent interface.' =>
            'Itaamua hali ya tiketi inayowezekana  ifuatayo, baada ya kutengeneza tiketi ya barua pepe mpya katika kiolesura cha wakala.',
        'Determines the next possible ticket states, after the creation of a new phone ticket in the agent interface.' =>
            'Itaamua hali ya tiketi inayowezekana ifuatayo, baada ya kutengeneza tiketi ya simu mpya katika kiolesura cha wakala.',
        'Determines the next possible ticket states, for process tickets in the agent interface.' =>
            'Itaamua hali ya tiketi inayowezekana ifuatayo, kwa mchakato wa tiketi katika kiolesura cha wakala.',
        'Determines the next screen after new customer ticket in the customer interface.' =>
            'Itaamua skrini inayofuata baada ya tiketi ya mteja mpya katika kiolesura cha wakala.',
        'Determines the next screen after the follow up screen of a zoomed ticket in the customer interface.' =>
            'Itaamua skrini inayofuata baada ya ufuatiliaji wa skrini ya tiketi iliyokuzwa katika kiolesura cha wakala.',
        'Determines the next screen after the ticket is moved. LastScreenOverview will return the last overview screen (e.g. search results, queueview, dashboard). TicketZoom will return to the TicketZoom.' =>
            'Itaamua skrini inayofuata baada ya tiketi kuhamishwa. Mapitio ya skrini ya mwisho yatarudisha skrini ya mapitio ya mwisho (Mfano matokeo ya utafutaji, mandhari ya foleni, dashibodi). Tiketi kuzwa itarudi kwenye tiketi kuzwa.',
        'Determines the possible states for pending tickets that changed state after reaching time limit.' =>
            'Inaamua hali zinazowezekana kwa ajili ya tiketi zinazongoja ambazo zimebadilisha hali baada ya kikomo cha muda kufika.',
        'Determines the strings that will be shown as receipent (To:) of the phone ticket and as sender (From:) of the email ticket in the agent interface. For Queue as NewQueueSelectionType "<Queue>" shows the names of the queues and for SystemAddress "<Realname> <<Email>>" shows the name and email of the receipent.' =>
            'Inaamua tungo zitakazo onyeshwa kama mpokeaji (Kwenda:) wa tiketi ya simu na kama mtumaji (Kutoka:) wa tiketi ya barua pepe katikakiolesura cha wakala. Kwa foleni kaam aina ya Chaguo la Foleni Mpya "<Foleni>" inaonyesha najina ya foleni na Anwani zaMfumo "<JinaHalisi>"<<Barua pepe>>" inaonyesha jina na barua pepe ya mpokeaji.',
        'Determines the strings that will be shown as receipent (To:) of the ticket in the customer interface. For Queue as CustomerPanelSelectionType, "<Queue>" shows the names of the queues, and for SystemAddress, "<Realname> <<Email>>" shows the name and email of the receipent.' =>
            'Inaamua tungo zitakazo onyeshwa kama mpokeaji (Kwenda:) wa tiketi katika kiolesura cha mteja. Kwa foleni kaam aina ya Chaguo la Foleni Mpya "<Foleni>" inaonyesha najina ya foleni na Anwani zaMfumo "<JinaHalisi>"<<Barua pepe>>" inaonyesha jina na barua pepe ya mpokeaji.',
        'Determines the way the linked objects are displayed in each zoom mask.' =>
            'Inaamua jinsi ambayo vipengele vilivyounganishwa vitaonyeshwa katika kila barakoa ya kukuza.',
        'Determines which options will be valid of the recepient (phone ticket) and the sender (email ticket) in the agent interface.' =>
            'Inaamua michaguo ipi itakuwa halali kwa mpokeaji (tiketi za simu) na mtumaji (tiketi za barua pepe) katika kiolesura cha wakala.',
        'Determines which queues will be valid for ticket\'s recepients in the customer interface.' =>
            'Inaamua foleni zipi zitakuwa halali kwa wapokeaji wa tiketi katika kiolesura cha mteja.',
        'Disable restricted security for IFrames in IE. May be required for SSO to work in IE8.' =>
            'Lemaza ulinzi uliozuiliwa kw aajili ya IFrames katika IE. Inaweza ikahitajika kwa ajili ya SSO kufanya kazi na IE8.',
        'Disables sending reminder notifications to the responsible agent of a ticket (Ticket::Responsible needs to be activated).' =>
            'Inalemaza utumaji wa taarifa za kikumbushaji kwa wakala anayehusika wa tiketi (Tiketi:: Uhusika unahitaji kuamilishwa).',
        'Disables the web installer (http://yourhost.example.com/otrs/installer.pl), to prevent the system from being hijacked. If set to "No", the system can be reinstalled and the current basic configuration will be used to pre-populate the questions within the installer script. If not active, it also disables the GenericAgent, PackageManager and SQL Box.' =>
            'Inalemaza kisanishi cha wavuti (http://yourhost.example.com/otrs/installer.pl), kuzuia mfumo kuvamiwa. Kama imewekwa kuwa "hapana", mfumo unaweza kusanidiwa upya na usanidi wa sasa wa msingi utatumika kujaza maswali katika hati ya usakinishi. Kama haijaamilishwa, pia inalemaza Wakala wa Jumla, Kisimamizi cha Kifurushi na kikasha cha SQL.',
        'Display settings to override defaults for Process Tickets.' => 'Inaonyesha mipangilio ya inayobadilisha michaguo msingi kw aajili ya mchakato wa tiketi.',
        'Displays the accounted time for an article in the ticket zoom view.' =>
            'Inaonyesha muda ulihesabiwa kwa ajili ya makala ya mandhari ya ukuzaji wa tiketi.',
        'Dropdown' => 'Kunjuzi',
        'Dynamic Fields Checkbox Backend GUI' => 'GUI ya mazingira ya nyuma ya kisanduku tiki cha uga zenye nguvu',
        'Dynamic Fields Date Time Backend GUI' => 'GUI ya mazingira ya nyuma ya muda wa tarehe ya uga zenye nguvu',
        'Dynamic Fields Drop-down Backend GUI' => 'GUI ya mazingira ya nyuma kunjuzi ya uga zenye nguvu',
        'Dynamic Fields GUI' => 'GUI ya uga zenye nguvu',
        'Dynamic Fields Multiselect Backend GUI' => 'GUI ya mazingira ya nyuma ya uchaguzi mbalimbali wa uga zenye nguvu',
        'Dynamic Fields Overview Limit' => 'Kikomo cha mapitio ya uga zenye nguvu',
        'Dynamic Fields Text Backend GUI' => 'GUI ya mzingira ya nyuma ya matini ya uga zenye nguvu',
        'Dynamic Fields used to export the search result in CSV format.' =>
            'Uga zenye nguvu zimetumika kuhamisha majibu ya utafutaji katika umbizo la CSV',
        'Dynamic fields groups for process widget. The key is the name of the group, the value contains the fields to be shown. Example: \'Key => My Group\', \'Content: Name_X, NameY\'.' =>
            'Vikundi vya uga zenye nguvu kwa ajili ya mchakato wa kifaa. Ufunguo ndio jina la kikundi, thamani ina uga unatakaoonyeshwa. Mfano \'Funguo => Kikundi Changu\', \'Maudhui: Jina_X, Jina Y\'.',
        'Dynamic fields limit per page for Dynamic Fields Overview' => 'Uga zenye nguvu kwa ukurasa kwa ajili ya mapitio ya uga zenye nguvu.',
        'Dynamic fields options shown in the ticket message screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required. NOTE. If you want to display these fields also in the ticket zoom of the customer interface, you have to enable them in CustomerTicketZoom###DynamicField.' =>
            'Uga wenye nguvu unaonyeshwa katika skrini ya ujumbe wa tiketi katika  kiolesura cha wakala. Mipangilio inayowezeka: 0=Kutokuwezesha, 1=wezesha, 2=Wezesha na inahitajika. KUMBUKA. Kama unataka kuonyesha uga hizi pia katika ukuzaji wa tiketi wa kiolesura cha mteja, unatakiwa kuziwezesha katika Ukuzaji wa tiketi wa mteja##Uga wenye Nguvu.',
        'Dynamic fields options shown in the ticket reply section in the ticket zoom screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Uga wenye nguvu unaonyeshwa katika sehemu ya majibu ya tiketi katika skrini ya kukuza ya tiketi ya kiolesura cha wakala. Mipangilio inayowezeka: 0=Kutokuwezesha, 1=wezesha, 2=Wezesha na inahitajika.',
        'Dynamic fields shown in the email outbound screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Uga wenye nguvu unaonyeshwa katika skrini iliyofungwa nje ya barua pepe ya kiolesura cha wakala. Mipangilio inayowezeka: 0=Kutokuwezesha, 1=wezesha, 2=Wezesha na inahitajika.',
        'Dynamic fields shown in the process widget in ticket zoom screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            'Uga wenye nguvu unaonyeshwa katika kifaa cha uendeshaji katika skrini ya kukuza ya tiketi ya kiolesura cha wakala. Mipangilio inayowezeka: 0=Kutokuwezesha, 1=wezesha.',
        'Dynamic fields shown in the sidebar of the ticket zoom screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            'Uga wenye nguvu unaonyeshwa katika mwambaa upande wa  skrini ya kukuza ya tiketi ya kiolesura cha wakala. Mipangilio inayowezeka: 0=Kutokuwezesha, 1=wezesha.',
        'Dynamic fields shown in the ticket close screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Uga wenye nguvu unaonyeshwa katika skrini ya kufunga ya tiketi ya kiolesura cha wakala. Mipangilio inayowezeka: 0=Kutokuwezesha, 1=wezesha, 2= wezesha na takiwa.',
        'Dynamic fields shown in the ticket compose screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Uga wenye nguvu unaonyeshwa katika skrini ya kutunga ya tiketi ya kiolesura cha wakala. Mipangilio inayowezeka: 0=Kutokuwezesha, 1=wezesha, 2= wezesha na takiwa.',
        'Dynamic fields shown in the ticket email screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Uga wenye nguvu unaonyeshwa katika skrini ya barua pepe ya tiketi ya kiolesura cha wakala. Mipangilio inayowezeka: 0=Kutokuwezesha, 1=wezesha, 2= wezesha na takiwa.',
        'Dynamic fields shown in the ticket forward screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Uga wenye nguvu unaonyeshwa katika skrini ya kutuma mbele ya tiketi ya kiolesura cha wakala. Mipangilio inayowezeka: 0=Kutokuwezesha, 1=wezesha, 2= wezesha na takiwa.',
        'Dynamic fields shown in the ticket free text screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Uga wenye nguvu unaonyeshwa katika skrini ya matini huru ya tiketi ya kiolesura cha wakala. Mipangilio inayowezeka: 0=Kutokuwezesha, 1=wezesha, 2= wezesha na takiwa.',
        'Dynamic fields shown in the ticket medium format overview screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            'Uga wenye nguvu unaonyeshwa katika skrini ya mapitio ya umbizo la wastani la tiketi ya kiolesura cha wakala. Mipangilio inayowezeka: 0=Kutokuwezesha, 1=wezesha.',
        'Dynamic fields shown in the ticket move screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Uga wenye nguvu unaonyeshwa katika skrini yakuhamisha ya tiketi ya kiolesura cha wakala. Mipangilio inayowezeka: 0=Kutokuwezesha, 1=wezesha, 2= wezesha na takiwa.',
        'Dynamic fields shown in the ticket note screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Uga wenye nguvu unaonyeshwa katika skrini ya kidokezo cha tiketi ya kiolesura cha wakala. Mipangilio inayowezeka: 0=Kutokuwezesha, 1=wezesha, 2= wezesha na takiwa.',
        'Dynamic fields shown in the ticket overview screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Uga wenye nguvu unaonyeshwa katika skrini ya mapitio ya tiketi ya kiolesura cha wakala. Mipangilio inayowezeka: 0=Kutokuwezesha, 1=wezesha, 2= wezesha na takiwa.',
        'Dynamic fields shown in the ticket owner screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Uga wenye nguvu unaonyeshwa katika skrini yammiliki wa tiketi ya kiolesura cha wakala. Mipangilio inayowezeka: 0=Kutokuwezesha, 1=wezesha, 2= wezesha na takiwa.',
        'Dynamic fields shown in the ticket pending screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Uga wenye nguvu unaonyeshwa katika skrini inayosubiri ya tiketi ya kiolesura cha wakala. Mipangilio inayowezeka: 0=Kutokuwezesha, 1=wezesha, 2= wezesha na takiwa.',
        'Dynamic fields shown in the ticket phone inbound screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Uga wenye nguvu unaonyeshwa katika skrini ya simu zilizofungwa ndani  za tiketi ya kiolesura cha wakala. Mipangilio inayowezeka: 0=Kutokuwezesha, 1=wezesha, 2= wezesha na takiwa.',
        'Dynamic fields shown in the ticket phone outbound screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Uga wenye nguvu unaonyeshwa katika skrini ya simu zilizofungwa nje  za tiketi ya kiolesura cha wakala. Mipangilio inayowezeka: 0=Kutokuwezesha, 1=wezesha, 2= wezesha na takiwa.',
        'Dynamic fields shown in the ticket phone screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Uga wenye nguvu unaonyeshwa katika skrini ya simu ya tiketi ya kiolesura cha wakala. Mipangilio inayowezeka: 0=Kutokuwezesha, 1=wezesha, 2= wezesha na takiwa.',
        'Dynamic fields shown in the ticket preview format overview screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            'Uga wenye nguvu unaonyeshwa katika skrini ya mapitio ya kihakiki cha umbizo cha tiketi ya kiolesura cha mteja. Mipangilio inayowezeka: 0=Kutokuwezesha, 1=wezesha.',
        'Dynamic fields shown in the ticket print screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            'Uga wenye nguvu unaonyeshwa katika skrini ya kuchapisha ya tiketi ya kiolesura cha wakala. Mipangilio inayowezeka: 0=Kutokuwezesha, 1=wezesha.',
        'Dynamic fields shown in the ticket print screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            'Uga wenye nguvu unaonyeshwa katika skrini ya kuchapisha ya tiketi ya kiolesura cha mteja. Mipangilio inayowezeka: 0=Kutokuwezesha, 1=wezesha.',
        'Dynamic fields shown in the ticket priority screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Uga wenye nguvu unaonyeshwa katika skrini kipaumbele ya tiketi ya kiolesura cha wakala. Mipangilio inayowezeka: 0=Kutokuwezesha, 1=wezesha, 2= Wezesha na takiwa.',
        'Dynamic fields shown in the ticket responsible screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Uga wenye nguvu unaonyeshwa katika skrini husika ya tiketi ya kiolesura cha wakala. Mipangilio inayowezeka: 0=Kutokuwezesha, 1=wezesha, 2= Wezesha na takiwa.',
        'Dynamic fields shown in the ticket search overview results screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            'Uga wenye nguvu unaonyeshwa katika skrini ya matokeo ya mapitio ya utafutaji ya tiketi ya kiolesura cha wakala. Mipangilio inayowezeka: 0=Kutokuwezesha, 1=wezesha.',
        'Dynamic fields shown in the ticket search screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and shown by default.' =>
            'Uga wenye nguvu unaonyeshwa katika skrini ya kutafuta tiketi ya kiolesura cha wakala. Mipangilio inayowezeka: 0=Kutokuwezesha, 1=wezesha, 2=Wezeshwa kwa chaguo msingi.',
        'Dynamic fields shown in the ticket search screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            'Uga wenye nguvu unaonyeshwa katika skrini ya kutafuta tiketi ya kiolesura cha mteja. Mipangilio inayowezeka: 0=Kutokuwezesha, 1=wezesha.',
        'Dynamic fields shown in the ticket small format overview screen of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.' =>
            'Uga wenye uwezo imeonyeshwa katika skrini ya maumbizo madogo ya mapitio ya tiketi ya kiolesura cha wakala. Mipangilio inayowezeka: 0= Lemazwa, 1 = wezesha, 2=Wezeshwa kwa chaguo msingi.',
        'Dynamic fields shown in the ticket zoom screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            'Uga wenye nguvu unaonyeshwa katika skrini iliyokuzwa ya tiketi ya kiolesura cha mteja. Mipangilio inayowezeka: 0=Kutokuwezesha, 1=wezesha.',
        'DynamicField backend registration.' => 'Usajili wa mazingira ya nyuma ya uga wenye nguvu.',
        'DynamicField object registration.' => 'Usajili wa kipengele cha uga wenye nguvu.',
        'Edit customer company' => 'Hariri kampuni ya mteja ',
        'Email Addresses' => 'Anwani za barua pepe',
        'Email sent to "%s".' => 'Barua pepe imetumwa kwa "%s".',
        'Email sent to customer.' => 'Barua pepe imetumwa kwa mteja.',
        'Enable keep-alive connection header for SOAP responses.' => 'Wezesha kichwa cha muunganisho weka-hai kwa ajili ya majibu ya SOAP.',
        'Enabled filters.' => 'Wezesha vichuja.',
        'Enables PDF output. The CPAN module PDF::API2 is required, if not installed, PDF output will be disabled.' =>
            'Wezesha matokeo ya PDF. Moduli ya CPAN PDF::API2 inahitajika, kama haijasanidiwa, matokeo ya PDF yatalemazwa.',
        'Enables PGP support. When PGP support is enabled for signing and encrypting mail, it is HIGHLY recommended that the web server runs as the OTRS user. Otherwise, there will be problems with the privileges when accessing .gnupg folder.' =>
            'Inawezesha msaada wa PGP. Wakati msaada wa PGP umewezeshwa kwa ajili ya kuipa na usimbaji fiche barua bebe, inashauriwa kwamba seva ya wavuti kufanya kazi kama mtumiaji wa OTRS. Vinginevyo kutakuwa na matatizo na mapendeleo wakati wa kufikia mpangilio orodha wa .gnupg.',
        'Enables S/MIME support.' => 'Wezesha msaada wa S/MIME.',
        'Enables customers to create their own accounts.' => 'Inawawezesha wateja kutengeneza akaunti zao wenyeye.',
        'Enables file upload in the package manager frontend.' => 'Inawezeshesha upakiaji wa faili katika mazinga ya mbele ya msimamizi ya kifurushi.',
        'Enables or disables the caching for templates. WARNING: Do NOT disable template caching for production environments for it will cause a massive performance drop! This setting should only be disabled for debugging reasons!' =>
            'Wezesha au lemaza uhifadhi muda wa violezo. ONYO: usilemaze uhifadhi muda wa kiolezo kwa ajili ya mazingira ya uzalishaji itasababisha kushuka kwa utendaji! mpangilio huu ulemazwe kwa sababu za ueuaji!',
        'Enables or disables the debug mode over frontend interface.' => 'Wezesha au lemaza hali tumizi ya ueuzi badala ya kiolesura cha mazingira ya mbele.',
        'Enables or disables the ticket watcher feature, to keep track of tickets without being the owner nor the responsible.' =>
            'Wezesha au lemeza kipengele cha mwangaliaji tiketi, kufuatilia tiketi bila kuwa mmiliki au muhusika.',
        'Enables performance log (to log the page response time). It will affect the system performance. Frontend::Module###AdminPerformanceLog must be enabled.' =>
            'Wezesha batli ya utendaji (Kuingiza muda wa kujibu wa ukurasa). Itaathiri utendaji wa mfumo. Frontend::Module###AdminPerformanceLog lazima iwezeshwa.',
        'Enables spell checker support.' => 'Wezesha msaada wa kiangalia herufi.',
        'Enables the minimal ticket counter size (if "Date" was selected as TicketNumberGenerator).' =>
            'Wezesha ukubwa kihesabuji cha tiketi cha upeo wa chini (kama "Tarehe" ilichaguliwa kama kitengenezaji tiketi).',
        'Enables ticket bulk action feature for the agent frontend to work on more than one ticket at a time.' =>
            'Wezesha kipengele cha kitendo cha wingi cha tiketi kwa wakala ufanya kazi na tiketi zaidi ya moja kwa muda.',
        'Enables ticket bulk action feature only for the listed groups.' =>
            'Wezesha kipengele cha kitendo cha wingi cha tiketi kwa makundi yaliyoorodheshwa tu.',
        'Enables ticket responsible feature, to keep track of a specific ticket.' =>
            'Wezesha kipengele cha uwajibikaji cha tiketi kuweka ufatiliaji wa tiketi maalum.',
        'Enables ticket watcher feature only for the listed groups.' => 'Wezesha kipengele cha kiangalizi cha tiketi katika makundi yaliyoorodheshwa tu.',
        'Enroll this ticket into a process' => 'Andikisha tiketi hii kuwa mchakato',
        'Escalation response time finished' => 'Muda wa majibu ya kupanda umekwisha',
        'Escalation response time forewarned' => 'Muda wa majibu ya kupanda umetaarifiwa',
        'Escalation response time in effect' => 'Muda wa majibu ya kupanda katika ufanisi',
        'Escalation solution time finished' => 'Muda wa utatuzi wa kupanda umeisha',
        'Escalation solution time forewarned' => 'Muda wa utatuzi wa kupanda umetaarifiwa',
        'Escalation solution time in effect' => 'Muda wa ufumbuzi wa kupanda katika madhara',
        'Escalation update time finished' => 'Muda wa usasishaji wa kupanda umeisha',
        'Escalation update time forewarned' => 'Muda wa usasishaji wa kupanda umetaarifiwa',
        'Escalation update time in effect' => 'Muda wa usasishaji wa kupanda unafanya kazi',
        'Escalation view' => 'Mandhari ya kupanda',
        'EscalationTime' => '',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate).' =>
            'Usajili wa moduli ya tukio. Kwa utendaji wa zaidi unaweza kuweka tukio chochezi (mfano Tukio => Tengeneza tiketi).',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate). This is only possible if all Ticket dynamic fields need the same event.' =>
            'Usajili wa moduli ya tukio. Kwa utendaji wa zaidi unaweza kuweka tukio chochezi (mfano Tukio => Tengeneza tiketi). Hii inawezekana tu kama uga wenye nguvu wa tiketi inahitaji tukio hilohilo.',
        'Event module that performs an update statement on TicketIndex to rename the queue name there if needed and if StaticDB is actually used.' =>
            'Moduli ya tukio ambayo inafanya tamko la usasishwaji katika Kielezoo cha Tiketi kuipa jina foleni kama inahitajika na DBTuli inatumika.',
        'Event module that updates customer user service membership if login changes.' =>
            'Moduli ya tukio inayosasisha uanachama wa huduma za mteja mtumiaji kama ameingiza mabadiliko.',
        'Event module that updates customer users after an update of the Customer.' =>
            'Moduli ya tukio inayosasisha mteja mtumiaji baada ya usasishaji wa mteja.',
        'Event module that updates tickets after an update of the Customer User.' =>
            'Moduli ya tukio inayosasisha tiketi baada ya usasishaji wa mteja mtumiaji.',
        'Event module that updates tickets after an update of the Customer.' =>
            'Moduli ya tukio inayosasisha tiketi baada ya usasishaji wa mteja.',
        'Events Ticket Calendar' => 'Kalenda ya tiketi ya matukio',
        'Execute SQL statements.' => 'Tekeleza kauli za SQL.',
        'Executes follow up checks on In-Reply-To or References headers for mails that don\'t have a ticket number in the subject.' =>
            'Tekeleza uangalizi wa ufuatiliaji katika Kujibu-kwa au kichwa cha kumbukummbu kwa ajili ya barua pepe ambazo hazina tiketi namba katika somo. ',
        'Executes follow up mail attachments checks in  mails that don\'t have a ticket number in the subject.' =>
            'Inatekelezanuangalizi wa  ufuatiliaji wa viambatanishi vya barua pepe katika barua pepe ambazo hazina namba ya tiketi katika somo.',
        'Executes follow up mail body checks in mails that don\'t have a ticket number in the subject.' =>
            'Inatekeleza ufuatiliaji uangalizi wa kiini cha barua pepe ambazo hazina namba ya tiketi katika somo.',
        'Executes follow up plain/raw mail checks in mails that don\'t have a ticket number in the subject.' =>
            'Inafuatilia uangalizi wa barua pepe ya wazi/mbichi ambazo hazina namba ya tiketi katika somo.',
        'Exports the whole article tree in search result (it can affect the system performance).' =>
            'Inahamisha mti wa makala yote katika majibu ya utafutajii (inaweza athiri utendaji wa mfumo). ',
        'Fetches packages via proxy. Overwrites "WebUserAgent::Proxy".' =>
            'Inachukua vifurushi kupitia seva mbadala. Inaandika juu kwa "Wakala mtumiaji wa tovuti::Seva mbadala".',
        'File that is displayed in the Kernel::Modules::AgentInfo module, if located under Kernel/Output/HTML/Standard/AgentInfo.dtl.' =>
            'Faili ambalo linaloonyeshwa katika moduli ya kiini::Module::Taarifa za Wakala, kama imewekwa chini ya Kernel/Output/HTML/Standard/AgentInfo.dtl.',
        'Filter for debugging ACLs. Note: More ticket attributes can be added in the format <OTRS_TICKET_Attribute> e.g. <OTRS_TICKET_Priority>.' =>
            'Chuja kwa ajili ya ueuaji wa ACL.Angalizo: Sifa za tiketi zaidi vinaweza kuongezwa katika umbizo <OTRS_TICKET_Attribute> mfano <OTRS_TICKET_Priority>.',
        'Filter for debugging Transitions. Note: More filters can be added in the format <OTRS_TICKET_Attribute> e.g. <OTRS_TICKET_Priority>.' =>
            'Chuja kwa ajili ya mipito ya ueuaji.Angalizo: Vichuja zaidi vinaweza kuongezwa katika umbizo <OTRS_TICKET_Attribute> mfano <OTRS_TICKET_Priority>.',
        'Filter incoming emails.' => 'Chuja barua pepe zinazoingia.',
        'First Queue' => '',
        'FirstLock' => 'Kufunga kwa kwanza',
        'FirstResponse' => 'Jibu la kwanza',
        'FirstResponseDiffInMin' => 'Tofauti ya katika dakika kwa jibu la kwanza',
        'FirstResponseInMin' => 'Jibu la kwanza katika dakika',
        'Firstname Lastname' => 'Jina kwanza Jina la mwisho',
        'Firstname Lastname (UserLogin)' => 'Jina kwanza Jina la mwisho(Kuingia kwa mtumiaji) ',
        'FollowUp for [%s]. %s' => 'Ufuatiliaji kwa [%s]. %s',
        'Forces encoding of outgoing emails (7bit|8bit|quoted-printable|base64).' =>
            'Inalazimisha usimbaji wa barua pepe zinatoka nje (7bit|8bit|quoted-printable|base64).',
        'Forces to choose a different ticket state (from current) after lock action. Define the current state as key, and the next state after lock action as content.' =>
            'Inalazimisha kuchagua hali tofauti za tiketi (Kutoka sasa) baada ya kitendo cha kufunga. Fafanua hali ya sasa kama funguo, na hali ijayo baada ya kitendo cha kufunga kama maudhui.',
        'Forces to unlock tickets after being moved to another queue.' =>
            'Inalazimisha kufungua tiketi baada ya kuhamishwa kwenye foleni nyingine.',
        'Forwarded to "%s".' => 'Tumwa mbele kwenda "%s".',
        'Frontend language' => 'Lugha ya mazingira ya mbele',
        'Frontend module registration (disable AgentTicketService link if Ticket Serivice feature is not used).' =>
            'Usajili wa moduli ya mazingira ya mbele (Lemaza kiunganishi cha huduma za tiketi cha wakala kama kipengele cha huduma ya tiketi haijatumika).',
        'Frontend module registration (disable company link if no company feature is used).' =>
            'Usajili wa moduli ya mazingira ya mbele (lemaza kiunganishi cha kampuni kama hakuna kipengele cha kampuni kinachotumika).',
        'Frontend module registration (disable ticket processes screen if no process available) for Customer.' =>
            'Usajili wa moduli ya mazingira ya mbele (lemaza skrini ya michakato ya tiketi kama hakuna mchakato unaopatikana) kwa ajili ya mteja.',
        'Frontend module registration (disable ticket processes screen if no process available).' =>
            'Usajili wa moduli ya mazingira ya mbele (lemaza skrini ya michakato ya tiketi kama hakuna mchakato unaopatikana).',
        'Frontend module registration for the agent interface.' => 'Usajili wa moduli ya mazingira ya mbele kwa ajili ya kiolesura cha wakala.',
        'Frontend module registration for the customer interface.' => 'Usajili wa moduli ya mazingira ya mbele kwa ajili ya kiolesura cha mteja.',
        'Frontend theme' => 'Dhima ya mazingira ya mbele',
        'Fulltext index regex filters to remove parts of the text.' => 'Regex ya kielezo cha nakala kamili inachuja kuondoa sehemu za makala.',
        'Fulltext search' => '',
        'General ticket data shown in the ticket overviews (fall-back). Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note that TicketNumber can not be disabled, because it is necessary.' =>
            'Data za tiketi za ujumla zinaonyeshwa katika mapitio ya tiketi (KAnguka nyuma). Mipangilio inayowezekana: 0 = Lemaza, 1 = Patikana, 2= Wezesha kwa chaguo msingi.  Kumbuka kwamba namba ya tiketi haiwezi kulemazwa, kwasababu ni ya lazima.',
        'GenericAgent' => 'Wakala wa jumla',
        'GenericInterface Debugger GUI' => 'GUI ya mweuaji wa Kiolesura cha ujumla ',
        'GenericInterface Invoker GUI' => 'GUI ya muito wa kiolesura cha ujumla',
        'GenericInterface Operation GUI' => 'GUI ya uendeshaji ya kiolesura cha ujumla',
        'GenericInterface TransportHTTPREST GUI' => 'GUI ya usafirishaji ya HTTPREST ya kiolesura cha ujumla',
        'GenericInterface TransportHTTPSOAP GUI' => 'GUI ya usafirishaji ya HTTPSOAP ya kiolesura cha ujumla',
        'GenericInterface Web Service GUI' => 'GUI ya huduma ya tovuti ya kiolesura cha ujumla.',
        'GenericInterface Webservice History GUI' => 'GUI ya historia ya huduma ya tovuti ya kiolesura cha ujumla.',
        'GenericInterface Webservice Mapping GUI' => 'GUI ya kufanya ramani ya huduma ya wavuti wa kiolesura cha ujumla',
        'GenericInterface module registration for the invoker layer.' => 'Usajili wa moduli ya kiolesura cha jumla kwaajili la tabaka la kihamshaji.',
        'GenericInterface module registration for the mapping layer.' => 'Usajili wa moduli ya kiolesura cha jumla kwaajili la tabaka la kutengeneza ramani.',
        'GenericInterface module registration for the operation layer.' =>
            'Usajili wa moduli ya kiolesura cha jumla kwaajili la tabaka la utendaji.',
        'GenericInterface module registration for the transport layer.' =>
            'Usajili wa moduli ya kiolesura cha jumla kwaajili la tabaka la usafirishaji.',
        'Gives end users the possibility to override the separator character for CSV files, defined in the translation files.' =>
            'Inampa mtumiaji wa mwisho uwezekano wa kubatilisha herufi ya kutenganisha kwa ajili ya mafaili ya CSV, yaliyofafanuliwa katika mafaili ya tasfiri.',
        'Grants access, if the customer ID of the ticket matches the customer user\'s ID and the customer user has group permissions on the queue the ticket is in.' =>
            'Inatoa ruhusa, kama kitambulisho cha mteja wa tiketi kinalandana na kitambulisho cha mteja mtumiaji na mteja mtumiaji ana ruhusa za kikundi katika foleni, tiketi ipo ndani.',
        'Helps to extend your articles full-text search (From, To, Cc, Subject and Body search). Runtime will do full-text searches on live data (it works fine for up to 50.000 tickets). StaticDB will strip all articles and will build an index after article creation, increasing fulltext searches about 50%. To create an initial index use "bin/otrs.RebuildFulltextIndex.pl".' =>
            'Inasaidia kuongeza utafutaji wa matini kamili wa makala yako (Kutoka, Kwenda, Cc, Somo na utafutaji wa Kiini). Muda wa kufanya kazi utatafutaji wa matini kamili katika data hai (inafanya kazi vizuri kwa tiketi hadi 50.000). Hifadhi data Tuli itatoa makala zote na itajenga kielezo baada ya kutengeneza makala, inaongeza utafutaji wa matini kamili kwa 50%. Kutengeneza kielezo cha kwanza tumia "bin/otrs.RebuildFulltextIndex.pl".',
        'If "DB" was selected for Customer::AuthModule, a database driver (normally autodetection is used) can be specified.' =>
            'Kama "DB" inachaguliwa kwa ajili ya Mteja::Moduli ya uhalalishaji,viendeshaji  hifadhi data(mara nyingi ugunduzi wa otomatiki unatumika) vinaweza kubainishwa.',
        'If "DB" was selected for Customer::AuthModule, a password to connect to the customer table can be specified.' =>
            'Kama "DB" inachaguliwa kwa ajili ya Mteja::Moduli ya uhalalishaji,neno la siri la kuunganisha kwenye jedwali la mteja linaweza kubainishwa.',
        'If "DB" was selected for Customer::AuthModule, a username to connect to the customer table can be specified.' =>
            'Kama "DB" inachaguliwa kwa ajili ya Mteja::Moduli ya uhalalishaji,jina la mtumiaji la kuunganisha kwenye jedwali la mteja linaweza kubainishwa.',
        'If "DB" was selected for Customer::AuthModule, the DSN for the connection to the customer table must be specified.' =>
            'Kama "DB" inachaguliwa kwa ajili ya Mteja::Moduli ya uhalalishaji,DNS kwa jilia ya kuunganisha kwenye jedwali la mteja linaweza kubainishwa.',
        'If "DB" was selected for Customer::AuthModule, the column name for the CustomerPassword in the customer table must be specified.' =>
            'Kama "DB" inachaguliwa kwa ajili ya Mteja::Moduli ya uhalalishaji,jina la safu wima kwa ajili ya neno la siri la mteja katika jedwali la mteja lazima libainishwe.',
        'If "DB" was selected for Customer::AuthModule, the crypt type of passwords must be specified.' =>
            'Kama "DB" inachaguliwa kwa ajili ya Mteja::Moduli ya uhalalishaji,aina ya uchimbaji fiche wa maneno ya siri lazima ubainishwe.',
        'If "DB" was selected for Customer::AuthModule, the name of the column for the CustomerKey in the customer table must be specified.' =>
            'Kama "DB" inachaguliwa kwa ajili ya Mteja::Moduli ya uhalalishaji,jina la safu wima kwa ajili ya funguo wa mteja katika jedwali la mteja lazima libainishwe.',
        'If "DB" was selected for Customer::AuthModule, the name of the table where your customer data should be stored must be specified.' =>
            'Kama "DB" inachaguliwa kwa ajili ya Mteja::Moduli ya uhalalishaji,jina la jedwali ambapo data za mteja wako zitahifadhiwa lazima libainishwe.',
        'If "DB" was selected for SessionModule, a table in database where session data will be stored must be specified.' =>
            'Kama "DB" inachaguliwa kwa ajili ya Moduli ya kipindi, jedwali katika hifadhi data ambapo data za kipindi zitahifadhiwa lazima zibainishwe.',
        'If "FS" was selected for SessionModule, a directory where the session data will be stored must be specified.' =>
            'Kama "DB" inachaguliwa kwa ajili ya Moduli ya kipindi, mpangilio orodha ambapo data za kipindi zitahifadhiwa lazima zibainishwe.',
        'If "HTTPBasicAuth" was selected for Customer::AuthModule, you can specify (by using a RegExp) to strip parts of REMOTE_USER (e. g. for to remove trailing domains). RegExp-Note, $1 will be the new Login.' =>
            'Kama "Uhifadhi wa msingi wa HTTP" inachaguliwa kwa ajili ya Mteja::Moduli ya uhalalishaji, unaweza kubainisha (kwa kutumia RegExp) kuachanisha sehemu za MTUMIAJI_WA_MBALI (mfano kuongoa vikoa mkia). RegExp-Note, $1 itakuwa muingio mpya.',
        'If "HTTPBasicAuth" was selected for Customer::AuthModule, you can specify to strip leading parts of user names (e. g. for domains like example_domain\user to user).' =>
            'Kama "Uhifadhi wa msingi wa HTTP" inachaguliwa kwa ajili ya Mteja::Moduli ya uhalalishaji, unaweza kubainisha kwenye sehemu zilizo wazi za majina ya watumiaji (mfano kwa vikoa kwa example_domain\user kwa mtumiaji).',
        'If "LDAP" was selected for Customer::AuthModule and if you want to add a suffix to every customer login name, specifiy it here, e. g. you just want to write the username user but in your LDAP directory exists user@domain.' =>
            'Kama "LDAP" imechaguliwa kwa ajili ya Mteja::Moduli ya uhalalishaji na kama unahitaji kuongeza kiambishi kwa kila jina la mteja la kuingia, bainisha hapa, mfano unataka kuandika jina la mtumiaji lakini katika mpangilio orodha wako wa LDAP ipo user@domain.',
        'If "LDAP" was selected for Customer::AuthModule and special paramaters are needed for the Net::LDAP perl module, you can specify them here. See "perldoc Net::LDAP" for more information about the parameters.' =>
            'Kama "LDAP" imechaguliwa kwa ajili ya Mteja::Moduli ya uhalalishaji na parameta maalum zinahitajika kwa jaili ya moduli ya Net::LDAP, unaweza kubainisha hapa. Angalia "perldoc Net::LDAP" kwa taarifa zaidi kuhusu parameta.',
        'If "LDAP" was selected for Customer::AuthModule and your users have only anonymous access to the LDAP tree, but you want to search through the data, you can do this with a user who has access to the LDAP directory. Specify the password for this special user here.' =>
            'Kama "LDAP" imechaguliwa kwa ajili ya Mteja::Moduli ya uhalalishaji na na watumiaji wako wana uwezo usiojulikana wa kufikia mti wa LDAP, lakini unataka kutafuta kupitia data, unaweza kufanya hivi na mtumiaji ambaye anafikia mpangilio orodha wa LDAP. Bainisha neno la siri kwa huyu mtumiaji wa maalum hapa.',
        'If "LDAP" was selected for Customer::AuthModule and your users have only anonymous access to the LDAP tree, but you want to search through the data, you can do this with a user who has access to the LDAP directory. Specify the username for this special user here.' =>
            'Kama "LDAP" imechaguliwa kwa ajili ya Mteja::Moduli ya uhalalishaji na na watumiaji wako wana uwezo usiojulikana wa kufikia mti wa LDAP, lakini unataka kutafuta kupitia data, unaweza kufanya hivi na mtumiaji ambaye anafikia mpangilio orodha wa LDAP. Bainisha jina la mtumiaji kwa huyu mtumiaji wa maalum hapa.',
        'If "LDAP" was selected for Customer::AuthModule, the BaseDN must be specified.' =>
            'Kama "LDAP" imechaguliwa kwa ajili ya Mteja::Moduli ya uhalalishaji DN ya msingi lazima ibainishwa.',
        'If "LDAP" was selected for Customer::AuthModule, the LDAP host can be specified.' =>
            'Kama "LDAP" imechaguliwa kwa ajili ya Mteja::Moduli ya uhalalishaji, mwenyeji wa LDAP anaweza kubainishwa.',
        'If "LDAP" was selected for Customer::AuthModule, the user identifier must be specified.' =>
            'Kama "LDAP" imechaguliwa kwa ajili ya Mteja::Moduli ya uhalalishaji, kitambulishi cha mtumiaji  lazima kibainishwe.',
        'If "LDAP" was selected for Customer::AuthModule, user attributes can be specified. For LDAP posixGroups use UID, for non LDAP posixGroups use full user DN.' =>
            'Kama "LDAP" imechaguliwa kwa ajili ya Mteja::Moduli ya uhalalishaji, sifa za mtumiaji zinaweza kubainishwa. Kwa LDAP posixGroups wanatumia UID, kwa wasio LDAP posixGroups wanatumia DN kamili ya mtumiaji.',
        'If "LDAP" was selected for Customer::AuthModule, you can specify access attributes here.' =>
            'Kama "LDAP" imechaguliwa kwa ajili ya Mteja::Moduli ya uhalalishaji, unaweza kubainisha sifa za kufikia hapa.',
        'If "LDAP" was selected for Customer::AuthModule, you can specify if the applications will stop if e. g. a connection to a server can\'t be established due to network problems.' =>
            'Kama "LDAP" imechaguliwa kwa ajili ya Mteja::Moduli ya uhalalishaji, unaweza kubainisha kama programu tumizi zitaacha kufanya kazi kama mfano muunganisho wa kwenye seva hauwezi kuanzishwa kwasababu ya matatizo ya mtandao.',
        'If "LDAP" was selected for Customer::Authmodule, you can check if the user is allowed to authenticate because he is in a posixGroup, e.g. user needs to be in a group xyz to use OTRS. Specify the group, who may access the system.' =>
            'Kama "LDAP" imechaguliwa kwa ajili ya Mteja::Moduli ya uhalalishaji, unaweza kuangalia hapa kama mtumiaji anaruhusiwa kuhalalisha kwasababu yuo kwenye posixGroup, mfano mtumiaji anahitaji kuwa kwenye kikundi xyz kutumia OTRS. Bainisha kikundi, nani anaweza kufikia mfumo.',
        'If "LDAP" was selected, you can add a filter to each LDAP query, e.g. (mail=*), (objectclass=user) or (!objectclass=computer).' =>
            'Kama "LDAP" imechaguliwa unaweza kuongeza kichuja katika kila ulizo la LDAP, mfano (barua pepe=*), (tabaka la kipengele = mtumiaji) au (!tabaka la kipengele = tarakilishi).',
        'If "Radius" was selected for Customer::AuthModule, the password to authenticate to the radius host must be specified.' =>
            'Kama "Nusu kipenyo" kimechaguliwa kwa ajili ya Moduli ya kuhalalisha::Mteja, neno la siri kuhalalisha kwa mwenyeji wa nusu kipenyo lazima ibainishwe.',
        'If "Radius" was selected for Customer::AuthModule, the radius host must be specified.' =>
            'Kama "Nusu kipenyo" kimechaguliwa kwa ajili ya Moduli ya kuhalalisha::Mteja, mwenyeji wa nusu kipenyo lazima ibainishwe.',
        'If "Radius" was selected for Customer::AuthModule, you can specify if the applications will stop if e. g. a connection to a server can\'t be established due to network problems.' =>
            'Kama "Nusu kipenyo" imechaguliwa kwa ajili ya Mteja::Moduli ya uhalalishaji, unaweza kubainisha kama programu tumizi zitaacha kufanya kazi kama mfano muunganisho wa kwenye seva hauwezi kuanzishwa kwasababu ya matatizo ya mtandao.',
        'If "Sendmail" was selected as SendmailModule, the location of the sendmail binary and the needed options must be specified.' =>
            'Kama "Tuma Barua pepe" ilichaguliwa kama Moduli ya kutuma barua pepe, eneo la pacha tuma barua pepe na michaguo inayohusika lazima ibainishwe.',
        'If "SysLog" was selected for LogModule, a special log facility can be specified.' =>
            'Kama  "BatliMfumo" imechaguliwa kwa ajili ya ModuliBatli, kituo batli maalum kitabainishwa.',
        'If "SysLog" was selected for LogModule, a special log sock can be specified (on solaris you may need to use \'stream\').' =>
            'Kama "BatliMfumo" ilichaguliwa kwa ajili ya Moduli batli, chapa batli maalum inaweza kubainishwa (kwenye solaris unahitaji kutumia \'stream\').',
        'If "SysLog" was selected for LogModule, the charset that should be used for logging can be specified.' =>
            'Kama "BatliMfumo" ilichagulia moduli ya batli, seti ya herufi ambayo itumike kuingia ibainishwe.',
        'If "file" was selected for LogModule, a logfile must be specified. If the file doesn\'t exist, it will be created by the system.' =>
            'Kama "Faili" limechagulia kwa Moduli batli, failibatli lazima libainishwe. Kama faili halipo, litatengenezwa na mfumo.',
        'If a note is added by an agent, sets the state of a ticket in the close ticket screen of the agent interface.' =>
            'Kama kidokezo kimeongezwa na wakala, inaweka hali ya tiketi katika skrini ya kufunga ya tiketi ya kiolesura cha wakala.',
        'If a note is added by an agent, sets the state of a ticket in the ticket bulk screen of the agent interface.' =>
            'Kama kidokezo kimeongezwa na wakala, inaweka hali ya tiketi katika skrini ya kufunga ya tiketi ya kiolesura cha wakala.',
        'If a note is added by an agent, sets the state of a ticket in the ticket free text screen of the agent interface.' =>
            'Kama kidokezo kimeongezwa na wakala, inaweka hali ya tiketi katika skrini ya matini huru ya tiketi ya kiolesura cha wakala.',
        'If a note is added by an agent, sets the state of a ticket in the ticket note screen of the agent interface.' =>
            'Kama kidokezo kimeongezwa na wakala, inaweka hali ya tiketi katika skrini ya kidokezo cha tiketi ya kiolesura cha wakala.',
        'If a note is added by an agent, sets the state of a ticket in the ticket responsible screen of the agent interface.' =>
            'Kama kidokezo kimeongezwa na wakala, inaweka hali ya tiketi katika skrini ya tiketi inayohusika ya kiolesura cha wakala.',
        'If a note is added by an agent, sets the state of the ticket in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Kama kidokezo kimeongezwa na wakala, inaweka hali ya tiketi katika skrini ya mmiliki wa tiketi ya kiolesura cha wakala.',
        'If a note is added by an agent, sets the state of the ticket in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Kama kidokezo kimeongezwa na wakala, inaweka hali ya tiketi katika skrini ya tiketi inayosubiri ya tiketi iliyokuzwa katika kiolesura cha wakala.',
        'If a note is added by an agent, sets the state of the ticket in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Kama kidokezo kimeongezwa na wakala, inaweka hali ya tiketi katika skrini yenye kipaumbele cha tiketi ya tiketi iliyokuzwa katika kiolesura cha wakala.',
        'If active, none of the regular expressions may match the user\'s email address to allow registration.' =>
            'Kama amilifu, hakuna usemi wa mara kwa mara utaoweza kufananisha na anwani ya barua pepe ya mtumiaji kuruhusu usajili.',
        'If active, one of the regular expressions has to match the user\'s email address to allow registration.' =>
            'Kama amilifu,moja ya  usemi wa mara kwa mara upaswa kufanana na anwani ya barua pepe ya mtumiaji kuruhusu usajili.',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, and authentication to the mail server is needed, a password must be specified.' =>
            'Kama moja ya taratibu za "SMTP" itachaguliwa kama Moduli ya Barua pepe ya kutuma, na uhalalishaji kwenye seva ya barua pepe unahitajika, neno la siri lazima libainishwe.',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, and authentication to the mail server is needed, an username must be specified.' =>
            'Kama moja ya taratibu za "SMTP" itachaguliwa kama Moduli ya Barua pepe ya kutuma, na uhalalishaji kwenye seva ya barua pepe unahitajika, jina la mtumiaji lazima libainishwe.',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, the mailhost that sends out the mails must be specified.' =>
            'Kama moja ya taratibu za "SMTP" itachaguliwa kama Moduli ya Barua pepe ya kutuma, mwenyeji wa barua pepe ambaye anatuma lazima abainishwe.',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, the port where your mailserver is listening for incoming connections must be specified.' =>
            'Kama moja ya taratibu za "SMTP" itachaguliwa kama Moduli ya Barua pepe ya kutuma, kituo tarishi ambacho seva yako ya barua pepe inasikiliza kwa ajili ya miunganisho inayoingia lazima ibainishwe.',
        'If enabled debugging information for ACLs is logged.' => 'Kama imewezeshwa kueua taarifa  kwa ajili ya ACL imewekwa batli.',
        'If enabled debugging information for transitions is logged.' => 'Kama imewezeshwa kueua taarifa  kwa ajili ya mipito imewekwa batli.',
        'If enabled, OTRS will deliver all CSS files in minified form. WARNING: If you turn this off, there will likely be problems in IE 7, because it cannot load more than 32 CSS files.' =>
            'Kama imewezeshwa, OTRS itawasilisha mafaili yote ya CSS katika umbo dogo. ONYO: ukizima hii, kunaweza kukawa na matatizo katika IE7, kwasababu haiwezi kupakia mafaili ya CSS zaidi ya 32.',
        'If enabled, OTRS will deliver all JavaScript files in minified form.' =>
            'Kama imezeshwa, OTRS itawasilisha mafaili yote ya JavaScript katika umbo dogo.',
        'If enabled, TicketPhone and TicketEmail will be open in new windows.' =>
            'Kama imewezeshwa, Simu ya tiketi na barua pepe ya tiketi zitafunguliwa katika windows mpya.',
        'If enabled, the OTRS version tag will be removed from the Webinterface, the HTTP headers and the X-Headers of outgoing mails.' =>
            'Kama imewezeshwa. lebo ya toleo la OTRS itaondolewa kutoka katika kiolesura cha wavuti, vichwa vya HTTP na kichwa cha X cha barua pepe zinazokwenda nje.',
        'If enabled, the customer can search for tickets in all services (regardless what services are assigned to the customer).' =>
            '',
        'If enabled, the different overviews (Dashboard, LockedView, QueueView) will automatically refresh after the specified time.' =>
            'Kama imewezeshwa, mapitio mbalimbali (dashibodi, Mandhari iliyofungwa, Mandhari ya foleni) itaonyeshwa upya otomatiki baada ya muda uliobainishwa.',
        'If enabled, the first level of the main menu opens on mouse hover (instead of click only).' =>
            'Kama imewezeshwa,ngazi ya kwanza ya menyu kuu itafunguka katika uambaaji wa juu wa kipanya (badala ya kubofya tu)',
        'If set, this address is used as envelope sender header in outgoing notifications. If no address is specified, the envelope sender header is empty.' =>
            'Kama imewekwa, anwani hii inatumika kama kichwa cha mtumaji cha bahasha katika taarifa zinakwenda nje. Kama hakuna anwani iliyobainishwa, kichwa cha mtumaji cha bahasha kipo wazi.',
        'If set, this address is used as envelope sender in outgoing messages (not notifications - see below). If no address is specified, the envelope sender is equal to queue e-mail address.' =>
            'Kama imewekwa, anwani hii inatumika kama mtumaji wa bahasha katika ujumbe unaokwenda nje (hakuna taarifa- angalia chini). Kama hakuna anwani iliyobainishwa mtumaji wa bahasha ni sawa anwani ya barua pepe ya foleni',
        'If this option is enabled, then the decrypted data will be stored in the database if they are displayed in AgentTicketZoom.' =>
            'Kama chaguo hili limewezeshwa, data iliyosimbuliwa fiche itahifadhiwa katika hifadhi data kama zinaonyeshwa katika kikuzaji cha tiketi cha wakala.',
        'If this option is set to \'Yes\', tickets created via the web interface, via Customers or Agents, will receive an autoresponse if configured. If this option is set to \'No\', no autoresponses will be sent.' =>
            'Kama chaguo hili limewekwa "Ndio". tiketi zinazotengenezwa kupitia kiolesura cha wavuti kupitia wateja au mawakala, itapokea majibu ya otomatiki kama imesanidiwa. Kama chaguo hili limewekwa kuwa \'Hapana\', hakuna majibu ya otomatiki yatakayotumwa.',
        'If this regex matches, no message will be send by the autoresponder.' =>
            'Kama regex inafanana, hakuna ujumbe utakaotumwa na kiitiko cha ototmatiki.',
        'If you want to use a mirror database for agent ticket fulltext search or to generate stats, specify the DSN to this database.' =>
            'Kama unahitaj kutumia hifadhi data kioo kwa utafutaji wa matini kamili ya tiketi ya wakala au kutengeneza takwimu, bainisha DNS kwa hifadhi data hii.',
        'If you want to use a mirror database for agent ticket fulltext search or to generate stats, the password to authenticate to this database can be specified.' =>
            'Kama unataka kutumia hifadhi data kioo kwa utafutaji wa matini kamili ya tiketi ya wakala au kutengeneza takwimu, neno la siri na la kuhakikishwa katika hifadhi data hii inaweza kubainishwa.',
        'If you want to use a mirror database for agent ticket fulltext search or to generate stats, the user to authenticate to this database can be specified.' =>
            'Kama unataka kutumia hifadhi data kioo kwa utafutaji wa matini kamili ya tiketi ya wakala au kutengeneza takwimu, mtumiaji wa kuhakikishwa katika hifadhi data hii anaweza kubainishwa.',
        'Ignore article with system sender type for new article feature (e. g. auto responses or email notifications).' =>
            'Inapuuzia makala yenye aina ya mtumaji wa mfumo kwa ajili ya kipengele cha makala mpya (mfano majibu ya otomatiki au taarifa za barua pepe ).',
        'Includes article create times in the ticket search of the agent interface.' =>
            'Inahusisha muda wa kutengeneza makala katika utafutaji wa tiketi wa kiolesura cha wakala.',
        'IndexAccelerator: to choose your backend TicketViewAccelerator module. "RuntimeDB" generates each queue view on the fly from ticket table (no performance problems up to approx. 60.000 tickets in total and 6.000 open tickets in the system). "StaticDB" is the most powerful module, it uses an extra ticket-index table that works like a view (recommended if more than 80.000 and 6.000 open tickets are stored in the system). Use the script "bin/otrs.RebuildTicketIndex.pl" for initial index update.' =>
            'Kielezi kichochezi: kuchagua mazingira ya nyuma ya moduli ya kichochezi cha mandhari ya tiketi. "Muda wa kufanya kazi wa DB" unatengeneza kila mandhari ya foleni  kutoka kwenye jedwali la tiketi (hakuna matatizo ya utendaji hadi takrabani jumla ya tiketi 60.000 na tiketi 6 katika mfumo). "DBTuli" ni moduli yenye nguvu, inatumia jedwali la kielezo cha tiketi la ziada ambalo linalofanya kazi kama mandahari (inashauriwa kama zaidi ya 80.000 na tiketi zilizowazi 6.000 zinahifadhiwa katika mfumo). Tumia hati "bin/otrs.RebuildTicketIndex.pl" kwa usashishwaji wa kiolezo wa mwanzo.',
        'Install ispell or aspell on the system, if you want to use a spell checker. Please specify the path to the aspell or ispell binary on your operating system.' =>
            'Sanidi ispell au aspell katika mfumo, kama unataka kutumia kiangalia herufi. Tafadhali bainisha njia ya kwenda bainari za aspell au ispell katika mfumo endeshi.',
        'Interface language' => 'Lugha ya kiolesura',
        'It is possible to configure different skins, for example to distinguish between diferent agents, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            'Inawezekana kusanidi magamba tofauti, kwa mfano kutofautisha kati mawakala tofauti, wataokaotumika katika kila huduma kwenye kikoa katika programu tumizi. Kwa kutumia imizo la kawaida (regex), unaweza kusanidi jozi ya yaliyomo/kibonye kulandanisha kikoa. Thamani katika "Kibonye" ilandane na kikoa, na thamani kwenye "Yaliyomo" iwe gamba batili katika mfumo wako. Tafadhali ona maingizo ya mfano kwa  ajili fomu sahihi ya  imizo la kawaida.',
        'It is possible to configure different skins, for example to distinguish between diferent customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            'Inawezekana kusanidi magamba tofauti, kwa mfano kutofautisha kati wateja tofauti, wataokaotumika katika kila huduma kwenye kikoa katika programu tumizi. Kwa kutumia imizo la kawaida (regex), unaweza kusanidi jozi ya yaliyomo/kibonye kulandanisha kikoa. Thamani katika "Kibonye" ilandane na kikoa, na thamani kwenye "Yaliyomo" iwe gamba batili katika mfumo wako. Tafadhali ona maingizo ya mfano kwa  ajili fomu sahihi ya  imizo la kawaida.',
        'It is possible to configure different themes, for example to distinguish between agents and customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid theme on your system. Please see the example entries for the proper form of the regex.' =>
            'Inawezekana kusanidi dhima tofauti, kwa mfano kutofautisha kati wakala na wateja, wataokaotumika katika kila huduma kwenye kikoa katika programu tumizi. Kwa kutumia imizo la kawaida (regex), unaweza kusanidi jozi ya yaliyomo/kibonye kulandanisha kikoa. Thamani katika "Kibonye" ilandane na kikoa, na thamani kwenye "Yaliyomo" iwe dhima batili katika mfumo wako. Tafadhali ona maingizo ya mfano kwa  ajili fomu sahihi ya  imizo la kawaida.',
        'Lastname, Firstname' => 'Jina la mwisho, Jina la kwanza',
        'Lastname, Firstname (UserLogin)' => 'Jina la mwisho, Jina la kwanza (Kuingia kwa mtumiaji)',
        'Left' => '',
        'Link agents to groups.' => 'Muuanganishe wakala kwenye makundi.',
        'Link agents to roles.' => 'Muuanganishe wakala kwenye majukumu.',
        'Link attachments to templates.' => 'Unganisha Viambatanisho kwa Violezo',
        'Link customer user to groups.' => 'Mnuunganishe mteja mtumiaji kwenye makundi.',
        'Link customer user to services.' => 'Muunganishe mteja mtumiaji kwenye huduma.',
        'Link queues to auto responses.' => 'Unganisha foleni kwenye majibu ya otomatiki.',
        'Link roles to groups.' => 'Unganisha majukumu kwenye makundi.',
        'Link templates to queues.' => 'Unganisha vielezo kwenye foleni.',
        'Links 2 tickets with a "Normal" type link.' => 'Inaunganisha tiketi 2 na kiunganishi aina ya "Kawaida".',
        'Links 2 tickets with a "ParentChild" type link.' => 'Inaunganisha tiketi 2 na kiunganishi aina ya "ZaziMtoto".',
        'List of CSS files to always be loaded for the agent interface.' =>
            'Orodha ya mafaili ya CSS yapelekwe mara zote katika kiolesura cha wakala.',
        'List of CSS files to always be loaded for the customer interface.' =>
            'Orodha ya mafaili ya CSS yapelekwe mara zote katika kiolesura cha mteja.',
        'List of IE8-specific CSS files to always be loaded for the agent interface.' =>
            'Orodha ya mafaili maalum ya IE8 ya CSS yapelekwe mara zote katika kiolesura cha wakala.',
        'List of IE8-specific CSS files to always be loaded for the customer interface.' =>
            'Orodha ya mafaili maalum ya IE8 ya CSS yapelekwe mara zote katika kiolesura cha mteja.',
        'List of JS files to always be loaded for the agent interface.' =>
            'Orodha ya mafaili ya JS yapelekwe mara zote katika kiolesura cha wakala.',
        'List of JS files to always be loaded for the customer interface.' =>
            'Orodha ya mafaili ya JS yapelekwe mara zote katika kiolesura cha mteja.',
        'List of all CustomerCompany events to be displayed in the GUI.' =>
            'Orodha ya matukio yote ya Kampuni ya mteja yataonyeshwa katika GUI.',
        'List of all CustomerUser events to be displayed in the GUI.' => 'Orodha ya matukio yote ya MtejaMtumiaji yataonyeshwa katika GUI.',
        'List of all DynamicField events to be displayed in the GUI.' => 'Orodha ya matukio ya Uga wenye Nguvu zote yataonyeshwa katika GUI.',
        'List of all Package events to be displayed in the GUI.' => 'Orodha ya matukio ya vifurushi vyote yataonyeshwa katika GUI.',
        'List of all article events to be displayed in the GUI.' => 'Orodha ya matukio ya makala zote yataonyeshwa katika GUI.',
        'List of all queue events to be displayed in the GUI.' => 'Orodha ya matukio yote ya foleni yataonyeshwa katika GUI.',
        'List of all ticket events to be displayed in the GUI.' => 'Orodha ya matukio yote ya foleni yataonyeshwa katika GUI.',
        'List of default Standard Templates which are assigned automatically to new Queues upon creation.' =>
            'Orodha ya vielezo vya viwango chaguo msingi ambavyo vimepewa otomatiki kwa foleni mpya wakati wa kutengenezwa.',
        'List view' => '',
        'Locked ticket.' => 'Tiketi iliyofungwa',
        'Log file for the ticket counter.' => 'Faili batli kwa ajili ya kihesabu tiketi.',
        'Loop-Protection! No auto-response sent to "%s".' => 'Ulinzi wa kitanzi! hakuna majibu ya otomatiki yatakayotumwa kwenda "%s".',
        'Mail Accounts' => 'Akaunti za barua pepe',
        'Main menu registration.' => 'Usajili wa menyu kuu.',
        'Makes the application check the MX record of email addresses before sending an email or submitting a telephone or email ticket.' =>
            'Inafanya programu tumizi kuangalia kumbukumbu ya MX ya anwani za barua pepe kabla ya kutuma barua pepe au kukusanya kielezo au tiketi ya barua pepe.',
        'Makes the application check the syntax of email addresses.' => 'Inafanya programu tumizi kuangalia sintaksi ya anwani ya barua pepe.',
        'Makes the picture transparent.' => 'Inafanya picha kuwa wazi.',
        'Makes the session management use html cookies. If html cookies are disabled or if the client browser disabled html cookies, then the system will work as usual and append the session id to the links.' =>
            'Inafanya usimamizi wa kipindi utumie vidakuzi vya html. Kama vidakuzi vya html havijawezeshwa au kivinjari cha mteja haijawezesha vidakuzi vya  html, mfumo utafanya kazi kama kawaida na itaambatisha kitambulisho cha kipindi kwenye viunganishi.',
        'Manage OTRS Group services.' => 'Simamia huduma za makundi ya OTRS.',
        'Manage PGP keys for email encryption.' => 'Simamia vibonye vya PGP kwa ajili ya usimbaji fiche wa barua pepe. ',
        'Manage POP3 or IMAP accounts to fetch email from.' => 'Simamia akaunti za POP3 au IMAP kupata barua pepe kutika huko. ',
        'Manage S/MIME certificates for email encryption.' => 'Simamia vyeti vya S/MIME kwa ajili ya usimbaji fiche.',
        'Manage existing sessions.' => 'Simamia vipindi vilivyopo.',
        'Manage notifications that are sent to agents.' => 'Simamia taarifa ambazo zimetumwa kwa mawakala.',
        'Manage system registration.' => 'Simamia usajili wa mfumo.',
        'Manage tasks triggered by event or time based execution.' => 'Simamia kazi zilizoamshwa na tukio au zinazotekelezwa kutegemeana na muda.',
        'Max size (in characters) of the customer information table (phone and email) in the compose screen.' =>
            'Ukumbwa wa upeo wa juu (katika herufi) wa jedwali la taarifa za mteja (Simu na barua pepe)katika skrini ya kutunga.',
        'Max size (in rows) of the informed agents box in the agent interface.' =>
            'Ukubwa wa upeo wa juu (katika safu mlalo) wa kikasha cha mawakala walio taarifiwa katika kiolesura cha wakala.',
        'Max size (in rows) of the involved agents box in the agent interface.' =>
            'Ukubwa wa upeo juu (katika safu mlalo) wa kikasha wa mawakala wanaohusika katika kioleusura cha wakala. ',
        'Max size of the subjects in an email reply.' => 'Ukubwa wa upeo wa juu wa masomo katika majibu ya barua pepe.',
        'Maximal auto email responses to own email-address a day (Loop-Protection).' =>
            'Majibu ya barua pepe ya otomatiki ya upeo wa juu kwenda anwani yake yenyewe ya barua pepe kwa siku (Ulinzi wa kitanzi).',
        'Maximal size in KBytes for mails that can be fetched via POP3/POP3S/IMAP/IMAPS (KBytes).' =>
            'Ukubwa wa upeo wa juu katika baiti K kwa ajili ya barua pepe ambazo zinawezwa kuchukuliwa kwa kutumia POP3/POP3S/IMAP/IMAPS (Baiti K).',
        'Maximum length (in characters) of the dynamic field in the article of the ticket zoom view.' =>
            'Urefu wa upeo wa juu (katika herufi) ya uga wenye nguvu katika makala ya mandhari iliyokuzwa ya tiketi.',
        'Maximum length (in characters) of the dynamic field in the sidebar of the ticket zoom view.' =>
            'Urefu wa upeo wa juu (katika herufi) ya uga wenye nguvu katika upao wa pembeni wa mandhari iliyokuzwa ya tiketi.',
        'Maximum number of tickets to be displayed in the result of a search in the agent interface.' =>
            'Namba ya upeo wa juu wa tiketi zitakazo onyeshwa katika matokeo katika kiolesura cha wakala.',
        'Maximum number of tickets to be displayed in the result of a search in the customer interface.' =>
            'Namba ya upeo wa juu wa tiketi zitakazo onyeshwa katika matokeo katika kiolesura cha mteja.',
        'Maximum number of tickets to be displayed in the result of this operation.' =>
            'Namba ya upeo wa juu wa tiketi zitakazo onyeshwa katika matokeo ya mchakato huu.',
        'Maximum size (in characters) of the customer information table in the ticket zoom view.' =>
            'Ukubwa wa upeo wa juu (katika herufi) wa jedwali la taarifa za mteja katika mandhari iliyokuzwa ya tiketi.',
        'Module for To-selection in new ticket screen in the customer interface.' =>
            'Moduli kwa ajili ya uchaguzi katika skrini ya tiketi katika kioleusura cha mteja.',
        'Module to check customer permissions.' => 'Moduli ya kuangalia ruhusa za mteja.',
        'Module to check if a user is in a special group. Access is granted, if the user is in the specified group and has ro and rw permissions.' =>
            'Moduli ya kuangalia kama mtumiaji yupo katika kundi maalum. Ruhusa itagaiwa, kama mtumiaji yupo katika kundi maalum na ana ruhusa za ro na rw.',
        'Module to check if arrived emails should be marked as email-internal (because of original forwarded internal email). ArticleType and SenderType define the values for the arrived email/article.' =>
            'Moduli za kuangalia barua pepe zilizofika  ziwekwe alama kama barua pepe za ndani (kwasababu ya barua pepe za ndani zilizotumwa mbele awali). Aina ya Makala na aina ya mtumaji wanafafanua thamani ya barua pepe/makala zilizofika.',
        'Module to check the agent responsible of a ticket.' => 'Moduli ya kuangalia wakala anayehusika na tiketi.',
        'Module to check the group permissions for the access to customer tickets.' =>
            'Moduli ya kuangalia ruhusa za kundi kuweza kufikia tiketi za mteja.',
        'Module to check the owner of a ticket.' => 'Moduli ya kukagua mmiliki wa tiketi',
        'Module to check the watcher agents of a ticket.' => 'Moduli ya kukagua waangaliaji wa mawakala wa tiketi.',
        'Module to compose signed messages (PGP or S/MIME).' => 'Moduli ya kutunga ujumbe uliosainiwa (PGP au S/MIME).',
        'Module to crypt composed messages (PGP or S/MIME).' => 'Moduli ya ujumbe uliotungwa wa ufichami (PGP au S/MIME).',
        'Module to filter and manipulate incoming messages. Block/ignore all spam email with From: noreply@ address.' =>
            'Moduli ya kuchuja na kuendesha ujumbe unaoingia. Funga/zuia barua pepe taka kutoka: noreply@ address.',
        'Module to filter and manipulate incoming messages. Get a 4 digit number to ticket free text, use regex in Match e. g. From => \'(.+?)@.+?\', and use () as [***] in Set =>.' =>
            'Moduli ya kuchuja na kuendesha ujumbe zinazoingia. Pata namba yenye tarakimu 4 kwenye matini huru ya tiketi, tumia regex kufananisha mfano =>\'(.+?)@.+?\', na tumia () kama [***] katika seti ya =>.',
        'Module to generate accounted time ticket statistics.' => 'Moduli ya kutengeneza takwimu za tiketi za muda unaohusika',
        'Module to generate html OpenSearch profile for short ticket search in the agent interface.' =>
            'Moduli ya kutengeneza umbo la Utafutaji wazi wa html kwa utafutaji wa tiketi mfupi katika kiolesura cha wakala.',
        'Module to generate html OpenSearch profile for short ticket search in the customer interface.' =>
            'Moduli ya kutengeneza umbo la Utafutaji wazi wa html kwa utafutaji wa tiketi mfupi katika kiolesura cha mteja.',
        'Module to generate ticket solution and response time statistics.' =>
            'Moduli kutengeneza ufumbuzi wa tiketi na takwimu za muda za majibu.',
        'Module to generate ticket statistics.' => 'Moduli ya kutengeneza takwimu za tiketi.',
        'Module to show notifications and escalations (ShownMax: max. shown escalations, EscalationInMinutes: Show ticket which will escalation in, CacheTime: Cache of calculated escalations in seconds).' =>
            'Moduli ya kuonyesha taarifa na upandaji (Upeo wa juu ulioonyeshwa: upeo wa juu wa upandaji ulioonyeshwa, Upandaji katika dakika: Onyesha tiketi itakayopanda ndani, hifadhi muda ya muda: Hifadhi muda ya upandaji uliohesabiwa katika sekunde).',
        'Module to use database filter storage.' => 'Moduli ya kutumia hifadhi ya kichujua cha hifadhi data.',
        'Multiselect' => 'Uchaguzi wa wingi',
        'My Queues and My Services' => 'Foleni zangu au Huduma zangu',
        'My Queues or My Services' => 'Foleni zangu au Huduma zangu',
        'My Services' => 'Huduma zangu',
        'My Tickets' => 'Tiketi zangu',
        'Name of custom queue. The custom queue is a queue selection of your preferred queues and can be selected in the preferences settings.' =>
            'Jina la foleni maalum. Foleni maalum ni uchaguzi wa foleni wa foleni zako unazozipendelea na zinazeweza kuchaguliwa katika mipangilio ya mapendeleo.',
        'Name of custom service. The custom service is a service selection of your preferred services and can be selected in the preferences settings.' =>
            'Jina la huduma maalum. Huduma maalum ni uchaguzi wa huduma wa huduma zako unazozipendelea na zinazeweza kuchaguliwa katika mipangilio ya mapendeleo.',
        'NameX' => 'Jina X',
        'New Ticket [%s] created (Q=%s;P=%s;S=%s).' => 'Tiketi mpya [%s] imetengenezwa (Q=%s;P=%s:S=%s).',
        'New Window' => '',
        'New email ticket' => 'Tiketi mpya ya barua pepe ',
        'New owner is "%s" (ID=%s).' => 'Mmiliki mpya ni %s (Kitambulisho=%s).',
        'New phone ticket' => 'Tiketi mpy ya simu',
        'New process ticket' => 'Tiketi Mpya ya mchakato',
        'New responsible is "%s" (ID=%s).' => 'Mpya inayohusika ni "%s" (Kitambulisho=%s).',
        'Next possible ticket states after adding a phone note in the ticket phone inbound screen of the agent interface.' =>
            'Hali za tiketi zijazo ziwezekanazo baada ya kuongeza kidokezo cha simu katika skrini iliyofungwa ndani ya simu ya tiketi ya kiolesura cha wakala.',
        'Next possible ticket states after adding a phone note in the ticket phone outbound screen of the agent interface.' =>
            'Hali za tiketi zijazo ziwezekanazo baada ya kuongeza kidokezo cha simu katika skrini iliyofungwa nje ya simu ya tiketi ya kiolesura cha wakala.',
        'No Notification' => 'Hakuna Taarifa',
        'None' => '',
        'Notification sent to "%s".' => 'Taarifa imetumwa kwenda "%s".',
        'Notifications (Event)' => 'Taarifa (Tukio)',
        'Number of displayed tickets' => 'Namba ya tiketi zilizoonyeshwa',
        'Number of lines (per ticket) that are shown by the search utility in the agent interface.' =>
            'Namba ya mistari (kwa kila tiketi) ambazo zinaonyeshwa na kifaa ha utafutaji katika kiolesura cha wakala.',
        'Number of tickets to be displayed in each page of a search result in the agent interface.' =>
            'Namba ta tiketi zitakazoonyeshwa katika kila ukurasa wa matokeo ya utafutaji katika kiolesura cha wakala.',
        'Number of tickets to be displayed in each page of a search result in the customer interface.' =>
            'Namba ta tiketi zitakazoonyeshwa katika kila ukurasa wa matokeo ya utafutaji katika kiolesura cha mteja.',
        'Old: "%s" New: "%s"' => 'Ya zamani: "%s" Mpya: "%s"',
        'Online' => '',
        'Open tickets (customer user)' => 'Fungua tiketi (Mtumiaji wa mteja)',
        'Open tickets (customer)' => 'Fungua tiketi (Mteja)',
        'Out Of Office' => 'Nje ya ofisi',
        'Overloads (redefines) existing functions in Kernel::System::Ticket. Used to easily add customizations.' =>
            'Pakia (Inafafanua tena) fomula saidizi katika kiini::Mfumo::Tiketi. Inatumika kuongeza kirahisi hali hukidhi haja binafsi.',
        'Overview Escalated Tickets' => 'Marejeo ya tiketi zilizopandishwa',
        'Overview Refresh Time' => 'Muda kuonyesha upya marejeo',
        'Overview of all open Tickets.' => 'Marejeo ya Tiketi zilizo wazi ',
        'PGP Key Management' => 'Usimamizi wa kibonye cha PGP',
        'PGP Key Upload' => 'Pakia kibonye cha PGP',
        'Package event module file a scheduler task for update registration.' =>
            'Faili la moduli ya tukio la kifurushi kipanga ratiba cha kazi kwa ajili la usajili wa usasishwaji.',
        'Parameters for .' => 'Vigezo kwa ajili ya ',
        'Parameters for the CreateNextMask object in the preference view of the agent interface.' =>
            'Vigezo kwa ajili ya kipengele cha Kutengeneza Barakoa mpya katika mandhari ya mapendeleo ya kiolesura cha wakala.',
        'Parameters for the CustomQueue object in the preference view of the agent interface.' =>
            'Vigezo kwa ajili ya kipengele cha maalum ya Kawaida katika mandhari ya mapendeleo ya kiolesura cha wakala.',
        'Parameters for the CustomService object in the preference view of the agent interface.' =>
            'Vigezo kwa ajili ya kipengele cha Huduma Maalum katika mandhari ya mapendeleo ya kiolesura cha wakala.',
        'Parameters for the FollowUpNotify object in the preference view of the agent interface.' =>
            'Vigezo kwa ajili ya kipengele cha Taarifa za ufuatiliaji katika mandhari ya mapendeleo ya kiolesura cha wakala.',
        'Parameters for the LockTimeoutNotify object in the preference view of the agent interface.' =>
            'Vigezo kwa ajili ya kipengele cha Taarifa za Muda wa kufunga kuisha katika mandhari ya mapendeleo ya kiolesura cha wakala.',
        'Parameters for the MoveNotify object in the preference view of the agent interface.' =>
            'Vigezo kwa ajili ya kipengele cha Taarifa za kuhamisha katika mandhari ya mapendeleo ya kiolesura cha wakala.',
        'Parameters for the NewTicketNotify object in the preferences view of the agent interface.' =>
            'Vigezo kwa ajili ya kipengele cha Taarifa za Tiketi Mpya katika mandhari ya mapendeleo ya kiolesura cha wakala.',
        'Parameters for the RefreshTime object in the preference view of the agent interface.' =>
            'Vigezo kwa ajili ya kipengele cha Muda wa kuonyesha upya katika mandhari ya mapendeleo ya kiolesura cha wakala.',
        'Parameters for the ServiceUpdateNotify object in the preference view of the agent interface.' =>
            'Vigezo kwa ajili ya kipengele cha Taariza za usasishwaji wa huduma katika mandhari ya mapendeleo ya kiolesura cha wakala.',
        'Parameters for the WatcherNotify object in the preference view of the agent interface.' =>
            'Vigezo kwa ajili ya kipengele cha Taarifa za wmangaliaji katika mandhari ya mapendeleo ya kiolesura cha wakala.',
        'Parameters for the dashboard backend of the customer company information of the agent interface . "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'Parameta kwa mazingira ya nyuma ya dashibodi ya taarifa ya kampuni ya mteja ya kiolesura cha wakala. \'\'Kikundi\'\' kinatumika kuzuia kufikia kuchomeka (mfano Kikundi:Utawala;kikundi cha 1;kikundi cha 2;). \'\'Chaguo-msingi\'\' inahakiki kama mchomeko umewezeshwa kwa mchaguo-msingi au kama mtumizi anahitaji kuwezesha kwa mkono. \'\'HifadhimudaTTLKiambo\'\' ni muda wa hifadhi muda katika dakika kwa mchomeko.',
        'Parameters for the dashboard backend of the customer id status widget of the agent interface . "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'Parameta kwa mazingira ya nyuma ya dashibodi kifaa cha hali ya kitambulisho cha mteja cha kiolesura cha wakala. \'\'Kikundi\'\' kinatumika kuzuia kufikia kuchomeka (mfano Kikundi:Utawala;kikundi cha 1;kikundi cha 2;). \'\'Chaguo-msingi\'\' inahakiki kama mchomeko umewezeshwa kwa mchaguo-msingi au kama mtumizi anahitaji kuwezesha kwa mkono. \'\'HifadhimudaTTLKiambo\'\' ni muda wa hifadhi muda katika dakika kwa mchomeko.',
        'Parameters for the dashboard backend of the customer user list overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'Parameta kwa mazingira ya nyuma ya dashibodi mapitio ya orodha ya mteja mtumiaji ya kiolesura cha wakala. \'\'Kikundi\'\' kinatumika kuzuia kufikia kuchomeka (mfano Kikundi:Utawala;kikundi cha 1;kikundi cha 2;). \'\'Chaguo-msingi\'\' inahakiki kama mchomeko umewezeshwa kwa mchaguo-msingi au kama mtumizi anahitaji kuwezesha kwa mkono. \'\'HifadhimudaTTLKiambo\'\' ni muda wa hifadhi muda katika dakika kwa mchomeko.',
        'Parameters for the dashboard backend of the new tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.' =>
            'Parameta kwa mazingira ya nyuma ya dashibodi ya mapitio ya tiketi mpya ya kiolesura cha wakala. \'\'Kikomo\'\' ni namba ya vipengee halisi vinavyoonyeshwa kwa mchaguo-halisi. \'\'Kikundi\'\' kinatumika kuzuia kufikia kuchomeka (mfano Kikundi:Utawala;kikundi cha 1;kikundi cha 2;). \'\'Chaguo-msingi\'\' inahakiki kama mchomeko umewezeshwa kwa mchaguo-msingi au kama mtumizi anahitaji kuwezesha kwa mkono. \'\'HifadhimudaTTLKiambo\'\' ni muda wa hifadhi muda katika dakika kwa mchomeko. Angalizo: Sifa za tiketi tu na uga zenye nguvu (Uga wenye Nguvu_Jina X) yanaruhusiwa kwa safu wima chaguo msingi. Mipangilio inayowezekana: 0 = Kutowezeshwa, 1 = Inapatika, 2 = Wezeshwa kw achaguo msingi.',
        'Parameters for the dashboard backend of the queue overview widget of the agent interface. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "QueuePermissionGroup" is not mandatory, queues are only listed if they belong to this permission group if you enable it. "States" is a list of states, the key is the sort order of the state in the widget. "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'Parameta kwa mazingira ya nyuma ya dashibodi kifaa cha hali ya kitambulisho cha mteja cha kiolesura cha wakala. \'\'Kikundi\'\' kinatumika kuzuia kufikia kuchomeka (mfano Kikundi:Utawala;kikundi cha 1;kikundi cha 2;). "Kikundi cha ruhusa cha foleni" sio lazima, foleni zimeorozeshwa tu kama zipo kwenye kikundi hiki cha ruhusa kama umeruhusu."Hali" ni orodha ya hali, kibonye ni utaratibu wa kupangawa hali katika kifaa.\'\'Chaguo-msingi\'\' inahakiki kama mchomeko umewezeshwa kwa mchaguo-msingi au kama mtumizi anahitaji kuwezesha kwa mkono. \'\'HifadhimudaTTLKiambo\'\' ni muda wa hifadhi muda katika dakika kwa mchomeko.',
        'Parameters for the dashboard backend of the running process tickets overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'Parameta kwa mazingira ya nyuma ya dashibodi ya mapitio ya tiketi ya mchakato unaofanya kazi wa kiolesura cha wakala. \'\'Kikomo\'\' ni namba ya vipengee halisi vinavyoonyeshwa kwa mchaguo-halisi. \'\'Kikundi\'\' kinatumika kuzuia kufikia kuchomeka (mfano Kikundi:Utawala;kikundi cha 1;kikundi cha 2;). \'\'Chaguo-msingi\'\' inahakiki kama mchomeko umewezeshwa kwa mchaguo-msingi au kama mtumizi anahitaji kuwezesha kwa mkono. \'\'HifadhimudaTTLKiambo\'\' ni muda wa hifadhi muda katika dakika kwa mchomeko.',
        'Parameters for the dashboard backend of the ticket calendar of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'Parameta kwa mazingira ya nyuma ya dashibodi ya Kalenda ya tiketi ya kiolesura cha wakala. \'\'Kikomo\'\' ni namba ya vipengee halisi vinavyoonyeshwa kwa mchaguo-halisi. \'\'Kikundi\'\' kinatumika kuzuia kufikia kuchomeka (mfano Kikundi:Utawala;kikundi cha 1;kikundi cha 2;). \'\'Chaguo-msingi\'\' inahakiki kama mchomeko umewezeshwa kwa mchaguo-msingi au kama mtumizi anahitaji kuwezesha kwa mkono. \'\'HifadhimudaTTLKiambo\'\' ni muda wa hifadhi muda katika dakika kwa mchomeko.',
        'Parameters for the dashboard backend of the ticket escalation overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.' =>
            'Parameta kwa mazingira ya nyuma ya dashibodi ya mapitio ya kupandishwa kwa  tiketi  ya kiolesura cha wakala. \'\'Kikomo\'\' ni namba ya vipengee halisi vinavyoonyeshwa kwa mchaguo-halisi. \'\'Kikundi\'\' kinatumika kuzuia kufikia kuchomeka (mfano Kikundi:Utawala;kikundi cha 1;kikundi cha 2;). \'\'Chaguo-msingi\'\' inahakiki kama mchomeko umewezeshwa kwa mchaguo-msingi au kama mtumizi anahitaji kuwezesha kwa mkono. \'\'HifadhimudaTTLKiambo\'\' ni muda wa hifadhi muda katika dakika kwa mchomeko. Angalizo: Sifa za tiketi tu na uga zenye nguvu (Uga wenye Nguvu_Jina X) yanaruhusiwa kwa safu wima chaguo msingi. Mipangilio inayowezekana: 0 = Kutowezeshwa, 1 = Inapatika, 2 = Wezeshwa kwa chaguo msingi.',
        'Parameters for the dashboard backend of the ticket pending reminder overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.' =>
            'Parameta kwa mazingira ya nyuma ya dashibodi ya mapitio ya kikumbusho cha tiketi inayosubiri ya kiolesura cha wakala. \'\'Kikomo\'\' ni namba ya vipengee halisi vinavyoonyeshwa kwa mchaguo-halisi. \'\'Kikundi\'\' kinatumika kuzuia kufikia kuchomeka (mfano Kikundi:Utawala;kikundi cha 1;kikundi cha 2;). \'\'Chaguo-msingi\'\' inahakiki kama mchomeko umewezeshwa kwa mchaguo-msingi au kama mtumizi anahitaji kuwezesha kwa mkono. \'\'HifadhimudaTTLKiambo\'\' ni muda wa hifadhi muda katika dakika kwa mchomeko. Angalizo: Sifa za tiketi tu na uga zenye nguvu (Uga wenye Nguvu_Jina X) yanaruhusiwa kwa safu wima chaguo msingi. Mipangilio inayowezekana: 0 = Kutowezeshwa, 1 = Inapatika, 2 = Wezeshwa kwa chaguo msingi.',
        'Parameters for the dashboard backend of the ticket pending reminder overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.' =>
            'Parameta kwamazingira ya nyuma ya dashibodi ya mapitio ya kikumbusho cha tiketi inayosubiri ya kiolesura cha wakala. \'\'Kikomo\'\' ni namba ya vipengee halisi vinavyoonyeshwa kwa mchaguo-halisi. \'\'Kikundi\'\' kinatumika kuzuia kufikia kuchomeka (mfano Kikundi:Utawala;kikundi cha 1;kikundi cha 2;). \'\'Chaguo-msingi\'\' inahakiki kama mchomeko umewezeshwa kwa mchaguo-msingi au kama mtumizi anahitaji kuwezesha kwa mkono. \'\'HifadhimudaTTLKiambo\'\' ni muda wa hifadhi muda katika dakika kwa mchomeko. Angalizo: Sifa za tiketi tu na uga zenye nguvu (Uga wenye Nguvu_Jina X) yanaruhusiwa kwa safu wima chaguo msingi. Mipangilio inayowezekana: 0 = Kutowezeshwa, 1 = Inapatika, 2 = Wezeshwa kwa chaguo msingi.',
        'Parameters for the dashboard backend of the ticket stats of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'Parameta kwa mazingira ya nyuma ya dashibodi ya takwimu za tiketi ya kiolesura cha wakala. \'\'Kikomo\'\' ni namba ya vipengee halisi vinavyoonyeshwa kwa mchaguo-halisi. \'\'Kikundi\'\' kinatumika kuzuia kufikia kuchomeka (mfano Kikundi:Utawala;kikundi cha 1;kikundi cha 2;). \'\'Chaguo-msingi\'\' inahakiki kama mchomeko umewezeshwa kwa mchaguo-msingi au kama mtumizi anahitaji kuwezesha kwa mkono. \'\'HifadhimudaTTLKiambo\'\' ni muda wa hifadhi muda katika dakika kwa mchomeko. ',
        'Parameters for the pages (in which the dynamic fields are shown) of the dynamic fields overview.' =>
            'Vigezo kwa ajili vya kurasa(ambapo tiketi zinaonyeshwa) za mapitio ya ya uga wenye nguvu.',
        'Parameters for the pages (in which the tickets are shown) of the medium ticket overview.' =>
            'Vigezo kwa ajili vya kurasa(ambapo tiketi zinaonyeshwa) za mapitio ya tiketi za wastani.',
        'Parameters for the pages (in which the tickets are shown) of the small ticket overview.' =>
            'Vigezo kwa ajili vya kurasa(ambapo tiketi zinaonyeshwa) za mapitio ya tiket madogo.',
        'Parameters for the pages (in which the tickets are shown) of the ticket preview overview.' =>
            'Vigezo kwa ajili vya kurasa(ambapo tiketi zinaonyeshwa) za mapitio ya kihakiki.',
        'Parameters of the example SLA attribute Comment2.' => 'Vigezo vya maoni ya 2 ya mfano wa sifa za SLA.',
        'Parameters of the example queue attribute Comment2.' => 'Vigezo vya maoni ya 2 ya mfano wa foleni.',
        'Parameters of the example service attribute Comment2.' => 'Vigezo vya maoni ya 2 ya sifa za mfano wa huduma.',
        'Path for the log file (it only applies if "FS" was selected for LoopProtectionModule and it is mandatory).' =>
            'Njia ya faili ya batli (Inatumika tu kama "FS" ilichaguliwa kwa ajili ya Moduli ya Kulinda Kitanzi na ni lazima).',
        'Path of the file that stores all the settings for the QueueObject object for the agent interface.' =>
            'Njia ya faili linahifadhi mipangilio yote ya kipengele Kipengele cha Foleni kwa ajili ya kiolesura cha wakala. ',
        'Path of the file that stores all the settings for the QueueObject object for the customer interface.' =>
            'Njia ya faili linahifadhi mipangilio yote ya kipengele Kipengele cha Foleni kwa ajili ya kiolesura cha mteja. ',
        'Path of the file that stores all the settings for the TicketObject for the agent interface.' =>
            'Njia ya faili linahifadhi mipangilio yote ya kipengele Kipengele cha Foleni kwa ajili ya kiolesura cha wakala. ',
        'Path of the file that stores all the settings for the TicketObject for the customer interface.' =>
            'Njia ya faili linahifadhi mipangilio yote ya Kipengele cha Tiketi kwa ajili ya kiolesura cha mteja. ',
        'Performs the configured action for each event (as an Invoker) for each configured Webservice.' =>
            'Fanya kitecndo cha usanidishwaji kwa kila tukio (kama Kichochezi) kwa kila huduma ya wavuti iliyosanidiwa.',
        'Permitted width for compose email windows.' => 'Imeruhusu upana katika windows kwa ajili ya kutunga barua pepe.',
        'Permitted width for compose note windows.' => 'Imeruhusu upana katika windows kwa ajili ya kutunga kidokezo.',
        'Picture-Upload' => 'Pakia picha',
        'PostMaster Filters' => 'Vichuja vya mkuu wa Posta',
        'PostMaster Mail Accounts' => 'Akaunti za barua pepe za mkuu wa posta',
        'Process Information' => 'Taarifa za mchakato',
        'Process Management Activity Dialog GUI' => 'GUI ya mazungumzo ya shughuli ya usimamizi ya mchakato',
        'Process Management Activity GUI' => 'GUI ya shughuli ya usimamizi ya mchakato',
        'Process Management Path GUI' => 'GUI njia ya usimamizi ya mchakato',
        'Process Management Transition Action GUI' => 'GUI ya kitendo cha mpito cha usimamizi ya mchakato',
        'Process Management Transition GUI' => 'GUI ya  mpito cha usimamizi ya mchakato',
        'ProcessID' => 'Kitambulisho cha mchakato',
        'Protection against CSRF (Cross Site Request Forgery) exploits (for more info see http://en.wikipedia.org/wiki/Cross-site_request_forgery).' =>
            'Ulinzi dhidi ya CSRF (Cross Site Request Forgery) kutumia (Kwa taarifa zaidi anaglia http://en.wikipedia.org/wiki/Cross-site_request_forgery).',
        'Provides a matrix overview of the tickets per state per queue.' =>
            'Unatoa mapitio ya matriki ya tiketi kwa kila kila hali per kila foleni.',
        'Queue view' => 'Mandhari ya foleni',
        'Recognize if a ticket is a follow up to an existing ticket using an external ticket number.' =>
            'Tambua kama tiketi ilikuwa inafuatiliwa hadi kuwa tiketi iliyopo kwa kutumia namba ya nje ya tiketi.',
        'Refresh Overviews after' => 'Onyesha mapitio baada',
        'Refresh interval' => 'muda wa kuonyesha',
        'Removed subscription for user "%s".' => 'Toa kujiunga kwa mtumiaji "%s".',
        'Removes the ticket watcher information when a ticket is archived.' =>
            'Inatoa taarifa za mwangaliaji wa tiketi wakati imehifadhiwa.',
        'Replaces the original sender with current customer\'s email address on compose answer in the ticket compose screen of the agent interface.' =>
            'Inabadilisha anwani ya barua pepe ya  mtumaji wa mwanzo naya  mteja wa katika kutunga jibu katika skrini ya kutunga tiketi ya kiolesura cha wakala.',
        'Required permissions to change the customer of a ticket in the agent interface.' =>
            'Inahitaji ruhusa kubadilisha mteja wa tiketi katika kiolesura cha wakala.',
        'Required permissions to use the close ticket screen in the agent interface.' =>
            'Inahitaji ruhusa kutumia skrini ya tiketi iliyofungwa katika kiolesura cha wakala.',
        'Required permissions to use the email outbound screen in the agent interface.' =>
            'Inahitaji ruhusa kutumia skrini ya iliyofungwa nje ya barua pepe katika kiolesura cha wakala.',
        'Required permissions to use the ticket bounce screen in the agent interface.' =>
            'Inahitaji ruhusa kutumia skrini inayodunda ya tiketi katika kiolesura cha wakala.',
        'Required permissions to use the ticket compose screen in the agent interface.' =>
            'Inahitaji ruhusa kutumia skrini ya kutunga ya tiketi katika kiolesura cha wakala.',
        'Required permissions to use the ticket forward screen in the agent interface.' =>
            'Inahitaji ruhusa kutumia skrini ya kutuma mbele ya tiketi katika kiolesura cha wakala.',
        'Required permissions to use the ticket free text screen in the agent interface.' =>
            'Inahitaji ruhusa kutumia skrini ya matini huru ya tiketi katika kiolesura cha wakala.',
        'Required permissions to use the ticket merge screen of a zoomed ticket in the agent interface.' =>
            'Inahitaji ruhusa kutumia skrini ya kuunganisha ya tiketi ya tiketi iliyokuzwa katika kiolesura cha wakala.',
        'Required permissions to use the ticket note screen in the agent interface.' =>
            'Inahitaji ruhusa kutumia skrini ya kidokezo ya tiketi katika kiolesura cha wakala.',
        'Required permissions to use the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Inahitaji ruhusa kutumia skrini ya mmiliki ya tiketi ya tiketi iliyokuzwa katika kiolesura cha wakala.',
        'Required permissions to use the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Inahitaji ruhusa kutumia skrini ya tiketi inayongoja  ya tiketi iliyokuzwa katika kiolesura cha wakala.',
        'Required permissions to use the ticket phone inbound screen in the agent interface.' =>
            'Inahitaji ruhusa kutumia skrini ya iliyofungwa ndani ya simu ya tiketi katika kiolesura cha wakala.',
        'Required permissions to use the ticket phone outbound screen in the agent interface.' =>
            'Inahitaji ruhusa kutumia skrini ya iliyofungwa nje ya simu ya tiketi katika kiolesura cha wakala.',
        'Required permissions to use the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Inahitaji ruhusa kutumia skrini ya kipaumbele ya tiketi ya tiketi iliyokuzwa katika kiolesura cha wakala.',
        'Required permissions to use the ticket responsible screen in the agent interface.' =>
            'Inahitaji ruhusa kutumia skrini ya inayohusika ya tiketi katika kiolesura cha wakala.',
        'Resets and unlocks the owner of a ticket if it was moved to another queue.' =>
            'Inaweka upya na inamfungua mmiliki wa tiketi kama ilikuwa imeamishwa kwenye foleni.',
        'Restores a ticket from the archive (only if the event is a state change, from closed to any open available state).' =>
            'Inarudisha tiketi kwenye hifadhi (kama tukio tu ni hali ya kubadilika, kutoka kufungwa kwenda hali yoyote iliyopo iliyo wazi).',
        'Retains all services in listings even if they are children of invalid elements.' =>
            'Inaacha huduma zote katika orodha hata kama ni vipengele vidogo vya vipengele batili. ',
        'Right' => '',
        'Roles <-> Groups' => 'Majukumu <-> Makundi',
        'Running Process Tickets' => 'Endeshaji wa tiketi za mchakato.',
        'Runs an initial wildcard search of the existing customer company when accessing the AdminCustomerCompany module.' =>
            '',
        'Runs an initial wildcard search of the existing customer users when accessing the AdminCustomerUser module.' =>
            'Inatafuta utafutaji wa kwanza wa kibambo egemezi wa mtumiaji wa mteja ayiekuwepo wakati wa kufikia moduli ya mteja mtumiaji kiongozi.',
        'Runs the system in "Demo" mode. If set to "Yes", agents can change preferences, such as selection of language and theme via the agent web interface. These changes are only valid for the current session. It will not be possible for agents to change their passwords.' =>
            'Mfumo unafanya kazi katika hali-tumizi "Mfano". Kama imewekwa kuwa "Ndio", mawakala wanaweza kubadilisha mapendeleo, kama uchaguzi wa lugha na dhima kwa kupitia kiolesura cha wavuti wa wakala. Mabadiliko haya ni halali kwa kipindi cha sasa. Haitowezekana kwa mawakala kubadilisha neno la siri.
 ',
        'S/MIME Certificate Upload' => 'Upakizi wa cheti cha S/MIME',
        'Sample command output' => '',
        'Saves the attachments of articles. "DB" stores all data in the database (not recommended for storing big attachments). "FS" stores the data on the filesystem; this is faster but the webserver should run under the OTRS user. You can switch between the modules even on a system that is already in production without any loss of data. Note: Searching for attachment names is not supported when "FS" is used.' =>
            '',
        'Schedule a maintenance period.' => 'Panga ratiba ya muda wa matengenezo.',
        'Search Customer' => 'Tafuta mteja',
        'Search User' => 'Tafuta mtumiaji',
        'Search backend default router.' => 'Tafuta kipanga njia chaguo-msingi cha mazingira ya nyuma',
        'Search backend router.' => 'Tafuta kipanga njia cha mazingira ya nyuma',
        'Second Queue' => '',
        'Select your frontend Theme.' => 'Chagua dhima ya mazingira yako ya mbele.',
        'Selects the cache backend to use.' => 'Chagua hifadhi muda ya mazingira ya nyuma ya kutumia.',
        'Selects the module to handle uploads via the web interface. "DB" stores all uploads in the database, "FS" uses the file system.' =>
            'Inachagua moduli kushughulikia upakiaji kwa kupitia kiolesura cha wavuti. "DB" inahifadhi upakuaji  wote katika hifadhi data, "FS" inatumia mfumo wa faili.',
        'Selects the ticket number generator module. "AutoIncrement" increments the ticket number, the SystemID and the counter are used with SystemID.counter format (e.g. 1010138, 1010139). With "Date" the ticket numbers will be generated by the current date, the SystemID and the counter. The format looks like Year.Month.Day.SystemID.counter (e.g. 200206231010138, 200206231010139). With "DateChecksum"  the counter will be appended as checksum to the string of date and SystemID. The checksum will be rotated on a daily basis. The format looks like Year.Month.Day.SystemID.Counter.CheckSum (e.g. 2002070110101520, 2002070110101535). "Random" generates randomized ticket numbers in the format "SystemID.Random" (e.g. 100057866352, 103745394596).' =>
            'Chagua module ya kutengeneza namba ya tiketi. "Kuongezeka kwa otomatiki" inaongeza namba ya tiketi, kitambulisho cha mfumo na kihesabuji zinatumika na kitambulisho cha mufmo.umbizo la kihesabuji (mfano 1010138, 1010139). Na "Tarehe" namba za tiketi zitatengenezwa na tarehe ya sasa, kitambulisho cha mfumo na kihesabuji. Umbizo linafanana kama hivi Mwaka.Mwezi.Siku.Kitambulisho cha mfumo.Kihesabuji (mfano 200206231010138,200206231010139). Na "Kuangalia jumla kwa tarehe"  kihesabuji kitaambatanishwa kama kiangaliaji jumla kwenye tungo ya tarehe na kitambulisho. Kiangalia jumla kitazungushwa kwa mishingi ya kila siku. Umbizo litafanana kama hivi Mwaka.Mwezi.Siku.Kitambulisho cha mfumo.Kihesabuji (mfano 2002070110101520, 2002070110101535). "Nasibu" inatengeneza namba za tiketi zilizokuwanasibu katika umbizo la "Kitambulisho cha mfumo.Nasibu" (mfano 100057866352, 103745394596).',
        'Send me a notification if a customer sends a follow up and I\'m the owner of the ticket or the ticket is unlocked and is in one of my queues/services.' =>
            'Nitumie taarifa kama mteja akituma kufuatilia na mimi ni mmiliki wa tiketi au tiketi zimefunguliwa na ni moja ya foleni/huduma zangu.',
        'Send me a notification if the service of a ticket is changed to a service in "My Services" and the ticket is in a queue where I have read permissions.' =>
            'Nitumie taarifa kama huduma ya tiketi imebadilishwa kuwa huduma katika "Huduma zangu" na tiketi ipo katika foleni ambapo ninaruhusa za kusoma. ',
        'Send me a notification if there is a new ticket in my queues/services.' =>
            'Nitumie taarifa kama kuna tiketi mpya katika foleni/huduma zangu',
        'Send new ticket notifications if subscribed to' => 'Nitumie taarifa za tiketi mpya kama imeunganishwa',
        'Send notifications to users.' => 'tuma taarifa kwa watumiaji',
        'Send service update notifications' => 'Tuma taarifa za kusasisha kwa huduma',
        'Send ticket follow up notifications if subscribed to' => 'Tuma taarifa za ufuatiliaji za tiketi kama imeunganishwa ',
        'Sender type for new tickets from the customer inteface.' => 'Aina ya mtumaji kwa tiketi mpya kutoka kwa kiolesura cha mtej.',
        'Sends agent follow-up notification only to the owner, if a ticket is unlocked (the default is to send the notification to all agents).' =>
            'Tuma taarifa za ufuatiliaji za wakala kwa mmiliki tu, kama tiketi imefunguliwa (Chaguo-msingi ni kutuma taarifa kwa mawakala wote).',
        'Sends all outgoing email via bcc to the specified address. Please use this only for backup reasons.' =>
            'Tuma bariu pepe za kwenda nje zote kupitia bcc kwa anwani iliyobainishwa.Tafadhali tumia hii kwa sababu za chelezo.',
        'Sends customer notifications just to the mapped customer. Normally, if no customer is mapped, the latest customer sender gets the notification.' =>
            'Tuma taarifa za mteja kwa mteja wa kuunganisha. Kawaida, kama hakuna mteja aliyeunganishwa, mtumaji wa mteja wa sasa atapata taarifa.',
        'Sends reminder notifications of unlocked ticket after reaching the reminder date (only sent to ticket owner).' =>
            'Tuma taarifa za kukumbusha za tiketi iliyofunguliwa baada ya kufikia tarehe kukumbushwa. (Inatumwa kwa mmiliki wa tiketi tu).',
        'Sends the notifications which are configured in the admin interface under "Notfication (Event)".' =>
            'Inatuma taarifa ambazo zimesanidiwa katika kiolesura cha kiongozi chini ya "Taarifa (Tukio)".',
        'Service update notification' => 'Taarifa za kusasisha kwa huduma',
        'Service view' => 'Mtazamo wa huduma',
        'Set sender email addresses for this system.' => 'Weka anwani za barua pepe ya mtumaji kwa mfumo huu. ',
        'Set the default height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            'Weka urefu wa chaguo-msingi (katika pikseli) ya ndani ya makala ya HTML katika kikuzaji cha tiketi cha wakala.',
        'Set the maximum height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            'Weka upeo wa juu wa urefu (katika pikseli) ya ndani ya mstari wa makala za HTML katika kikuzaji cha tiketi cha wakala',
        'Set this to yes if you trust in all your public and private pgp keys, even if they are not certified with a trusted signature.' =>
            'Weka Ndio kama unaviamini vibonye  vya pgpvyako vyote binafsi na vya umma,hata kama havijawekewa saini ya kuaminika.',
        'Sets if SLA must be selected by the agent.' => 'Inaweka kama SLA ni lazima kuchaguliwa na wakala.',
        'Sets if SLA must be selected by the customer.' => 'Inaweka kama SLA ni lazima kuchaguliwa na mteja.',
        'Sets if note must be filled in by the agent. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Inaweka kama kidokezo lazima kijazwe na wakala. Inawezwa kuandikiwa juu na Tiketi::Mazingira ya mbele::Inahitaji Muda wa kuendelea.',
        'Sets if service must be selected by the agent.' => 'Inaweka kama huduma lazima ichaguliwe na wakala.',
        'Sets if service must be selected by the customer.' => 'Inaweka kama huduma lazima ichaguliwe na mteja.',
        'Sets if ticket owner must be selected by the agent.' => 'Inaweka kama mmiliki wa tiketi lazima achaguliwe na wakala.',
        'Sets the PendingTime of a ticket to 0 if the state is changed to a non-pending state.' =>
            'Inaweka muda wa kusubiri wa tiketi kuwa 0 kama hali imebadilishwa kuwa hali ya kutokusubiria.',
        'Sets the age in minutes (first level) for highlighting queues that contain untouched tickets.' =>
            'Inaweka umri katika dakika (hatua ya kwanza) kwa kuonyesha foleni ambazo zina tiketi ambazo hazija guswa.',
        'Sets the age in minutes (second level) for highlighting queues that contain untouched tickets.' =>
            'Inaweka umri katika (hatua ya pili) kwa kuonyesha foleni ambazo zina tiketi ambazo hazija guswa.',
        'Sets the configuration level of the administrator. Depending on the config level, some sysconfig options will be not shown. The config levels are in in ascending order: Expert, Advanced, Beginner. The higher the config level is (e.g. Beginner is the highest), the less likely is it that the user can accidentally configure the system in a way that it is not usable any more.' =>
            'Inaweka hatua ya usanidi ya kiongozi. Inategemeana na hatua ya usanidi, baadhi ya michaguo ya usanidi wa mfumo haitoonyeshwa. Hatua za usanidi zipo katika mpangilio wa kupanda: Mtaalam, kiwango cha juu, Aliyemwanzo. Hatua ya Usanidi ya usanidi ikiwa ya juu zaidi(mfano anayeanza ndo kubwa)inapunguza ajali za mtumiaji kusanidi mfumo kwa jinsi ambayo hautoweza kutumika tena. ',
        'Sets the count of articles visible in preview mode of ticket overviews.' =>
            'Weka hesabu ya makala ionekane katika hali timizi ya kihakiki ya marejep ya tiketi.',
        'Sets the default article type for new email tickets in the agent interface.' =>
            'Weka aina ya makala chaguo-msingi kwa barua pepe mpya katika kiolesura cha wakala.',
        'Sets the default article type for new phone tickets in the agent interface.' =>
            'Weka aina ya makala chaguo-msingi tiketi za simu mpya katika kiolesura cha wakala.',
        'Sets the default body text for notes added in the close ticket screen of the agent interface.' =>
            'Weka kiini cha matini makala chaguo-msingi kwa vidokezo vilivyoongezwa katika skrini ya tiketi iliyofungwa ya kiolesura cha wakala.',
        'Sets the default body text for notes added in the ticket move screen of the agent interface.' =>
            'Weka kiini cha matini makala chaguo-msingi kwa vidokezo vilivyoongezwa katika skrini ya tiketi iliyohamishwa ya kiolesura cha wakala.',
        'Sets the default body text for notes added in the ticket note screen of the agent interface.' =>
            'Weka kiini cha matini makala chaguo-msingi kwa vidokezo vilivyoongezwa katika skrini ya vidokezo ya tiketi ya kiolesura cha wakala.',
        'Sets the default body text for notes added in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Weka kiini cha matini makala chaguo-msingi kwa vidokezo vilivyoongezwa katika skrini ya mmiliki wa tiketi ya tiketi iliyokuzwa katika kiolesura cha wakala.',
        'Sets the default body text for notes added in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Weka kiini cha matini makala chaguo-msingi kwa vidokezo vilivyoongezwa katika skrini ya tiketi inayosubiri  ya tiketi iliyokuzwa katika kiolesura cha wakala.',
        'Sets the default body text for notes added in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Weka kiini cha matini makala chaguo-msingi kwa vidokezo vilivyoongezwa katika skrini ya  tiketi inayowajibika ya tiketi iliyokuzwa katika kiolesura cha wakala.',
        'Sets the default body text for notes added in the ticket responsible screen of the agent interface.' =>
            'Weka kiini cha matini makala chaguo-msingi kwa vidokezo vilivyoongezwa katika skrini ya  tiketi inayowajibika ya kiolesura cha wakala.',
        'Sets the default error message for the login screen on Agent and Customer interface, it\'s shown when a running system maintenance period is active.' =>
            'Weka ujumbe wa yaliyokosewa chaguo-msingi kwa skrini ya kuingia kwenye kiolesura cha wakala na mteja, inaonyeshwa wakati wa kipindi amilifu cha matengenezo ya mfumo  yanaendelea.',
        'Sets the default link type of splitted tickets in the agent interface.' =>
            'Weka aina ya kiunganishi chaguo msingi ya tiketi zilizogawanywa katika kiolesura cha wakala.',
        'Sets the default message for the login screen on Agent and Customer interface, it\'s shown when a running system maintenance period is active.' =>
            'Weka ujumbe chaguo-msingi kwa skrini ya kuingia kwenye kiolesura cha wakala na mteja, inaonyeshwa wakati wa kipindi amilifu cha matengenezo ya mfumo yanaendelea.',
        'Sets the default message for the notification is shown on a running system maintenance period.' =>
            'Weka ujumbe chaguo msingi kwa taarifa itaonyeshwa wakati wa matengenezo ya mfumo unaendelea.',
        'Sets the default next state for new phone tickets in the agent interface.' =>
            'Inaweka hali chaguo-msingi ijayo kwa ajili ya tiketi za simu mpya katika kiolesura cha wakala.',
        'Sets the default next ticket state, after the creation of an email ticket in the agent interface.' =>
            'Inaweka hali chaguo-msingi ijayo, baada ya kutengeneza tiketi za barua pepe katika kiolesura cha wakala.',
        'Sets the default note text for new telephone tickets. E.g \'New ticket via call\' in the agent interface.' =>
            'Inaweka matini chaguo-msingi kwa tiketi mpya za simu. Mfano \'Tiketi mpya kupitia simu\' katika kiolesura cha wakala.',
        'Sets the default priority for new email tickets in the agent interface.' =>
            'Inaweka kipaumbele chaguo-msingi kwa tiketi mpya za barua pepe katika kiolesura cha wakala.',
        'Sets the default priority for new phone tickets in the agent interface.' =>
            'Inaweka kipaumbele chaguo-msingi kwa tiketi mpya za simu katika kiolesura cha wakala.',
        'Sets the default sender type for new email tickets in the agent interface.' =>
            'Inaweka aina ya mtumaji chaguo-msingi kwa tiketi mpya za barua pepe katika kiolesura cha wakala.',
        'Sets the default sender type for new phone ticket in the agent interface.' =>
            'Inaweka aina ya mtumaji chaguo-msingi kwa tiketi mpya za simu katika kiolesura cha wakala.',
        'Sets the default subject for new email tickets (e.g. \'email Outbound\') in the agent interface.' =>
            'Inaweka kipaumbele chaguo-msingi kwa tiketi mpya za barua pepe(mfano \'barua pepe zilizofungwa nje\') katika kiolesura cha wakala.',
        'Sets the default subject for new phone tickets (e.g. \'Phone call\') in the agent interface.' =>
            'Weka somo chaguo-msingi kwa tiketi za simu mpya(mfano \'Simu\') katika kiolesura cha wakala.',
        'Sets the default subject for notes added in the close ticket screen of the agent interface.' =>
            'Weka somo chaguo-msingi kwa vidokezo vilivyoongezwa katika skrini ya tiketi zilizofungwa katika kiolesura cha wakala.',
        'Sets the default subject for notes added in the ticket move screen of the agent interface.' =>
            'Weka somo chaguo-msingi kwa vidokezo vilivyoongezwa katika skrini ya tiketi zilihamishwa katika kiolesura cha wakala.',
        'Sets the default subject for notes added in the ticket note screen of the agent interface.' =>
            'Weka somo chaguo-msingi kwa vidokezo vilivyoongezwa katika skrini ya tiket yenye kidokezo ya kiolesura cha wakala.',
        'Sets the default subject for notes added in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Weka somo chaguo-msingi kwa vidokezo vilivyoongezwa katika skrini ya mmiliki wa tiketi  ya tiketi iliyokuzwa ya kiolesura cha wakala.',
        'Sets the default subject for notes added in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Weka somo chaguo-msingi kwa vidokezo vilivyoongezwa katika skrini ya tiketi inayosubiri ya tiketi iliyokuzwa ya kiolesura cha wakala.',
        'Sets the default subject for notes added in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Weka somo chaguo-msingi kwa vidokezo vilivyoongezwa katika skrini ya kipaumbele cha tiketi  ya tiketi iliyokuzwa katika kiolesura cha wakala.',
        'Sets the default subject for notes added in the ticket responsible screen of the agent interface.' =>
            'Weka somo chaguo-msingi kwa vidokezo vilivyoongezwa katika skrini ya inahusika ya tiketi  ya kiolesura cha wakala.',
        'Sets the default text for new email tickets in the agent interface.' =>
            'Inaweka matini ya chaguo-msingi kwa tiketi za barua pepe mpya katika kiolesura cha wakala. ',
        'Sets the display order of the different items in the preferences view.' =>
            'Inaweka mpangilio wa kuonyesha ya vipengele mbalimbali katika mandhari ya kuona ya mapendeleo.',
        'Sets the inactivity time (in seconds) to pass before a session is killed and a user is loged out.' =>
            'Inaweka muda ambao hauna tukio (katika sekunde) kupita kabla ya kipindi kukatwa na mtumiaji kutolewa.',
        'Sets the maximum number of active agents within the timespan defined in SessionActiveTime.' =>
            'Inaweka upeo wa juu ya namba wa makala amilifu katika kipindi cha muda kilichofafanuliwa katika Muda amilifu wa Kipindi. ',
        'Sets the maximum number of active customers within the timespan defined in SessionActiveTime.' =>
            'Inaweka upeo wa juu wa namba ya wateja amilifu katika kipindi cha muda kilichofafanuliwa katika Muda amilifu wa Kipindi. ',
        'Sets the maximum number of active sessions per agent within the timespan defined in SessionActiveTime.' =>
            'Inaweka upeo wa juu wa namba ya vipindi amilifu  kwa kila wakala katika kipindi cha muda kilichofafanuliwa katika Muda amilifu wa Kipindi. ',
        'Sets the maximum number of active sessions per customers within the timespan defined in SessionActiveTime.' =>
            'Inaweka upeo wa juu wa namba ya vipindi amilifu  kwa kila mteja katika kipindi cha muda kilichofafanuliwa katika Muda amilifu wa Kipindi.',
        'Sets the minimal ticket counter size (if "AutoIncrement" was selected as TicketNumberGenerator). Default is 5, this means the counter starts from 10000.' =>
            'Inaweka upeo wa chini wa ukubwa wa kihesabuji tiketi (Kama "Inaongezeka otomatiki" imechaguliwa kama Kitengeneza namaba za tiketi). Chaguo-msingi ni 5, hii inamaanisha kihesabuji kinaanzia 10000',
        'Sets the minutes a notification is shown for notice about upcoming system maintenance period.' =>
            'Inawekea dakika taarifa inaonyeshwa kwa ilani kuhusu kipindi cha marekebisho ya mfumo ujao. ',
        'Sets the number of lines that are displayed in text messages (e.g. ticket lines in the QueueZoom).' =>
            'Inaweka namba ya mistari ambayo inaonyeshwa katika ujumbe wa maneno (mfano mistari ya tiketi katika foleni iliyokuzwa).',
        'Sets the options for PGP binary.' => 'Inaweka chaguo kwa binari za PGP.',
        'Sets the order of the different items in the customer preferences view.' =>
            'Inaweka mpangilio wa vipengele mbalimbali katika mandhari ya kuona anayopendelea mteja.',
        'Sets the password for private PGP key.' => 'Inaweka neno la siri kwa kibonye cha PGP ya binafsi',
        'Sets the prefered time units (e.g. work units, hours, minutes).' =>
            'Inaweka vigawe vya muda vinavyopendelewa (mfano vigawe vya kazi, masaa, dakika).',
        'Sets the prefix to the scripts folder on the server, as configured on the web server. This setting is used as a variable, OTRS_CONFIG_ScriptAlias which is found in all forms of messaging used by the application, to build links to the tickets within the system.' =>
            'Inaweka kiambishi awali kwenye kabrasha la hati katika seva, kama ilivyosanidi katika seva ya tovuti. Mpangilio huu unatumika kama thamani inayobadilika,  OTRS_CONFIG_ScriptAlias ambayo ipo katika miundo yote ya kutuma ujumbe inayotumika programu-tumizi, kujenga viungo kufikia kwenye tiketi katika mfumo.',
        'Sets the queue in the ticket close screen of a zoomed ticket in the agent interface.' =>
            'Weka foleni kwenye skrini ya kufunga kwa tiketi ya tiketi iliyokuzwa katika kiolesura cha wakala',
        'Sets the queue in the ticket free text screen of a zoomed ticket in the agent interface.' =>
            'Weka foleni kwenye skrini ya matini huru ya tiketi ya tiketi iliyokuzwa katika kiolesura cha wakala',
        'Sets the queue in the ticket note screen of a zoomed ticket in the agent interface.' =>
            'Weka foleni kwenye skrini ya kidokezo cha tiketi ya tiketi iliyokuzwa katika kiolesura cha wakala',
        'Sets the queue in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Weka foleni kwenye skrini ya mmiliki wa tiketi ya tiketi iliyokuzwa katika kiolesura cha wakala',
        'Sets the queue in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Weka foleni kwenye skrini ya tiketi inayosubiri ya tiketi iliyokuzwa katika kiolesura cha wakala',
        'Sets the queue in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Weka foleni kwenye skrini ya tiketi yenye kipaumbele ya tiketi iliyokuzwa katika kiolesura cha wakala',
        'Sets the queue in the ticket responsible screen of a zoomed ticket in the agent interface.' =>
            'Weka foleni kwenye skrini ya tiketi husika ya tiketi iliyokuzwa katika kiolesura cha wakala.',
        'Sets the responsible agent of the ticket in the close ticket screen of the agent interface.' =>
            'Inamuweka wakala mhusika wa tiketi katika skrini ya tiketi iliyofungwa ya kiolesura cha wakala.',
        'Sets the responsible agent of the ticket in the ticket bulk screen of the agent interface.' =>
            'Inamuweka wakala mhusika wa tiketi katika skrini ya wingi ya tiketi ya kiolesura cha wakala.',
        'Sets the responsible agent of the ticket in the ticket free text screen of the agent interface.' =>
            'Inamuweka wakala mhusika wa tiketi katika skrini ya matini huru ya tiketi ya kiolesura cha wakala.',
        'Sets the responsible agent of the ticket in the ticket note screen of the agent interface.' =>
            'Inamuweka wakala mhusika wa tiketi katika skrini ya kidokezo cha tiketi ya kiolesura cha wakala.',
        'Sets the responsible agent of the ticket in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Inamuweka wakala mhusika wa tiketi katika skrini ya mmiliki wa tiketi ya kiolesura cha wakala.',
        'Sets the responsible agent of the ticket in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Inamuweka wakala mhusika wa tiketi katika skrini ya tiketi inayosubiri ya tketi iliyokuzwa katika  kiolesura cha wakala.',
        'Sets the responsible agent of the ticket in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Inamuweka wakala mhusika wa tiketi katika skrini ya kipaumbele cha tiketi ya tketi iliyokuzwa katika  kiolesura cha wakala.',
        'Sets the responsible agent of the ticket in the ticket responsible screen of the agent interface.' =>
            'Inamuweka wakala mhusika wa tiketi katika skrini ya tiketi inayohusika  ya kiolesura cha wakala.',
        'Sets the service in the close ticket screen of the agent interface (Ticket::Service needs to be activated).' =>
            'Inaweka huduma katika skrini ya tiketi iliyofungwa ya  kiolesura cha wakala. (Tiketi:: Aina inahitaji kuamilishwa).',
        'Sets the service in the ticket free text screen of the agent interface (Ticket::Service needs to be activated).' =>
            'Inaweka huduma katika skrini ya matini huru ya tiketi ya  kiolesura cha wakala. (Tiketi:: Aina inahitaji kuamilishwa).',
        'Sets the service in the ticket note screen of the agent interface (Ticket::Service needs to be activated).' =>
            'Inaweka huduma katika skrini ya kidokezo ya tiketi ya  kiolesura cha wakala. (Tiketi:: Aina inahitaji kuamilishwa).',
        'Sets the service in the ticket owner screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).' =>
            'Inaweka huduma katika skrini ya mmiliki wa tiketi ya tiketi iliyokuzwa katika kiolesura cha wakala. (Tiketi:: Aina inahitaji kuamilishwa).',
        'Sets the service in the ticket pending screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).' =>
            'Inaweka huduma katika skrini inayosubiri ya tiketi ya tiketi iliyokuzwa katika kiolesura cha wakala. (Tiketi:: Aina inahitaji kuamilishwa).',
        'Sets the service in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).' =>
            'Inaweka huduma katika skrini ya kipaumbele cha tiketi ya tiketi iliyokuzwa katika kiolesura cha wakala. (Tiketi:: Aina inahitaji kuamilishwa).',
        'Sets the service in the ticket responsible screen of the agent interface (Ticket::Service needs to be activated).' =>
            'Inaweka huduma katika skrini inayohusika ya tiketi ya tiketi iliyokuzwa katika kiolesura cha wakala. (Tiketi:: Aina inahitaji kuamilishwa).',
        'Sets the size of the statistic graph.' => 'Inaweka ukubwa wa grafu ya takwimu.',
        'Sets the stats hook.' => 'Inaweka ndoano ya takwimu.',
        'Sets the system time zone (required a system with UTC as system time). Otherwise this is a diff time to the local time.' =>
            'Inaweka mfumo wa majira ya muda (inahitaji mfumo wenye UTC kama mfumo wa muda). Vinginevyo huu ni muda wa tofauti na muda wa ndani.',
        'Sets the ticket owner in the close ticket screen of the agent interface.' =>
            'Inamuweka mmiliki wa tiketi katika skrini ya kufunga ya tiketi ya  kiolesura cha wakala.',
        'Sets the ticket owner in the ticket bulk screen of the agent interface.' =>
            'Inamuweka mmiliki wa tiketi katika skrini ya wingi ya tiketi ya  kiolesura cha wakala.',
        'Sets the ticket owner in the ticket free text screen of the agent interface.' =>
            'Inamuweka mmiliki wa tiketi katika skrini matini huru ya tiketi ya  kiolesura cha wakala.',
        'Sets the ticket owner in the ticket note screen of the agent interface.' =>
            'Inamuweka mmiliki wa tiketi katika skrini ya kidokezo cha tiketi ya  kiolesura cha wakala.',
        'Sets the ticket owner in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Inamuweka mmiliki wa tiketi katika skrini ya mmiliki wa tiketi ya tiketi iliyokuzwa katika kiolesura cha wakala.',
        'Sets the ticket owner in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Inamuweka mmiliki wa tiketi katika skrini inayosubiri ya tiketi ya tiketi iliyokuzwa katika kiolesura cha wakala.',
        'Sets the ticket owner in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Inamuweka mmiliki wa tiketi katika skrini kipaumbele cha tiketi ya tiketi iliyokuzwa katika kiolesura cha wakala.',
        'Sets the ticket owner in the ticket responsible screen of the agent interface.' =>
            'Inamuweka mmiliki wa tiketi katika skrini inayohusika ya tiketi ya kiolesura cha wakala.',
        'Sets the ticket type in the close ticket screen of the agent interface (Ticket::Type needs to be activated).' =>
            'Inaweka aina ya tiketi katika skrini ya kufunga ya tiketi ya kiolesura cha wakala (Tiketi:: Aina inahitaji kuamilishwa).',
        'Sets the ticket type in the ticket bulk screen of the agent interface.' =>
            'Inaweka aina ya tiketi katika skrini ya wingi ya tiketi ya kiolesura cha wakala.',
        'Sets the ticket type in the ticket free text screen of the agent interface (Ticket::Type needs to be activated).' =>
            'Inaweka aina ya tiketi katika skrini ya mtini huru ya tiketi ya kiolesura cha wakala (Tiketi:: Aina inahitaji kuamilishwa).',
        'Sets the ticket type in the ticket note screen of the agent interface (Ticket::Type needs to be activated).' =>
            'Inaweka aina ya tiketi katika skrini ya kidokezo cha tiketi ya kiolesura cha wakala (Tiketi:: Aina inahitaji kuamilishwa).',
        'Sets the ticket type in the ticket owner screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).' =>
            'Inaweka aina ya tiketi katika skrini ya mmiliki wa tiketi ya tiketi iliyokuzwa ya kiolesura cha wakala (Tiketi::Aina inahitaji kuamilishwa).',
        'Sets the ticket type in the ticket pending screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).' =>
            'Inaweka aina ya tiketi katika skrini inayosubiri ya tiketi ya tiketi iliyokuzwa katika kiolesura cha wakala (Tiketi:: Aina inahitaji kuamilishwa).',
        'Sets the ticket type in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).' =>
            'Inaweka aina ya tiketi katika skrini ya kipaumbele cha tiketi ya tiketi iliyokuzwa katika kiolesura cha wakala (Tiketi:: aina inahitaji kuamilishwa).',
        'Sets the ticket type in the ticket responsible screen of the agent interface (Ticket::Type needs to be activated).' =>
            'Inaweka aina ya tiketi katika skrini husika ya tiketi ya kiolesura cha wakala (Tiketi::Aina inahitaji kuamilishwa).',
        'Sets the time (in seconds) a user is marked as active.' => 'Inaweka muda (katika sekunde) mtumiaji anawekwa alama kama amilifu.',
        'Sets the time type which should be shown.' => 'Inaweka aina ya muda unaotakiwa kuonyeshwa.',
        'Sets the timeout (in seconds) for http/ftp downloads.' => 'Inaweka muda wa kuisha (katika sekunde) kwa http/ftp za kupakua.',
        'Sets the timeout (in seconds) for package downloads. Overwrites "WebUserAgent::Timeout".' =>
            'InawekInaweka muda wa kuisha (katika sekunde) kwa vifurushi vya kupakua. Inaandika kwa juu ya "wakala wa mtumiaji wa tovuti::Muda umekwisha".',
        'Sets the user time zone per user (required a system with UTC as system time and UTC under TimeZone). Otherwise this is a diff time to the local time.' =>
            'Inaweka majira ya muda wa mtumiaji kwa mtumiaji (inahitaji mfumo wenyeUTC kama mfumo wa muda na UTC chini ya majira ya muda). Vinginevyo huu ni muda wa tofauti na muda wa kawaida',
        'Sets the user time zone per user based on java script / browser time zone offset feature at login time.' =>
            'Inaweka majira ya muda ya mtumiaji kwa mtumiaji kulingana na hati ya java /kipengele cha makubaliano ya majira ya muda ya kivinjari katika muda wa kuingia.',
        'Should the cache data be help in memory?' => 'Je data ya hifadhi muda inaweza kusaidia kwenye kumbukumbu?',
        'Should the cache data be stored in the selected cache backend?' =>
            'Je data ya hifadhi muda inaweza kuhifadhiwa katika mazingira ya nyuma ya hifadhi data iliyochaguliwa?',
        'Show a responsible selection in phone and email tickets in the agent interface.' =>
            'Inaonyesha uchaguzi husika katika simu na tiketi za barua pepe katika kiolesura cha wakala.',
        'Show article as rich text even if rich text writing is disabled.' =>
            'Inaonyesha makala kama matini tajiri hata kama uandishi wa matini tajiri haujaruhusiwa.',
        'Show the current owner in the customer interface.' => 'Inaonyesha mmiliki wa sasa katika kiolesura cha mteja.',
        'Show the current queue in the customer interface.' => 'Inaonyesha foleni ya sasa katika kiolesura cha mteja.',
        'Shows a count of icons in the ticket zoom, if the article has attachments.' =>
            'Inaonyesha hesabu ya ikoni zilizopo katika tiketi iliyokuzwa, kama makala ina viambatishi.',
        'Shows a link in the menu for subscribing / unsubscribing from a ticket in the ticket zoom view of the agent interface.' =>
            'Inaonyesha kiungo katika menyu ajili ya kujiunga/kutokujiunga kutoka kwenye tiketi katika mandhari iliyokuzwa ya tiketi ya kiolesura cha wakala.',
        'Shows a link in the menu that allows linking a ticket with another object in the ticket zoom view of the agent interface.' =>
            'Inaonyesha kiungo katika menyu ambacho kinaruhusu kuunganisha tiketi na kipengele kingine katika mandhari iliyokuzwa ya tiketi ya kiolesura cha wakala.',
        'Shows a link in the menu that allows merging tickets in the ticket zoom view of the agent interface.' =>
            'Inaonyesha kiungo katika menyu ambacho kinaruhusu tiketi zilizounganishwa katika mandhari iliyokuzwa ya tiketi ya kiolesura cha wakala.',
        'Shows a link in the menu to access the history of a ticket in the ticket zoom view of the agent interface.' =>
            'Inaonyesha kiungo kwenye menyu ili kufikia historia ya tiketi katika mandhari iliyokuzwa ya tiketi ya kiolesura cha wakala. ',
        'Shows a link in the menu to add a free text field in the ticket zoom view of the agent interface.' =>
            'Inaonyesha kiungo kwenye menyu cha kuongeza uga wa matini huru katika mandhari iliyokuzwa ya tiketi ya kiolesura cha wakala.',
        'Shows a link in the menu to add a note in the ticket zoom view of the agent interface.' =>
            'Inaonyesha kiungo kwenye menyu kuongeza kidokezo katika mandhari iliyokuzwa ya tiketi ya kiolesura cha wakala.',
        'Shows a link in the menu to add a note to a ticket in every ticket overview of the agent interface.' =>
            'Inaonyesha kiungo kwenye menyu kuongeza kidokezo katika tiketi kwa kila marejeo ya tiketi ya kiolesura cha wakala.',
        'Shows a link in the menu to close a ticket in every ticket overview of the agent interface.' =>
            'Inaonyesha kiungo kwenye menyu kufunga tiketi katika kila marejeo ya tiketi ya kiolesura cha wakala. ',
        'Shows a link in the menu to close a ticket in the ticket zoom view of the agent interface.' =>
            'Inaonyesha kiungo kwenye menyu kufunga tiketi katika mandhari iliyokuzwa ya tiketi ya kiolesura cha wakala. ',
        'Shows a link in the menu to delete a ticket in every ticket overview of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Inaonyesha kiungo katika menyu cha kufuta tiketi katika mapitio ya kila tiketi ya kiolesura cha wakala. Udhibiti ufikivu umeongezwa kuongesha au kutokuonyesha kiungo hiki kinaweza kufanywa kwa kutumia kibonye  "Kikundi" na yaliyomo kama "rw: Kikundi cha 1; Hamia_kwenye: kikundi cha 2".',
        'Shows a link in the menu to delete a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Inaonyesha kiungo katika menyu cha kufuta tiketi katika mandhari iliyokuzwa ya tiketi ya kiolesura cha wakala. Udhibiti ufikivu umeongezwa kuongesha au kutokuonyesha kiungo hiki kinaweza kufanywa kwa kutumia kibonye  "Kikundi" na yaliyomo kama "rw: Kikundi cha 1; Hamia_kwenye: kikundi cha 2".',
        'Shows a link in the menu to enroll a ticket into a process in the ticket zoom view of the agent interface.' =>
            'Inaonyesha kiungo kwenye menyu kuandikisha tiketi katika mchakato katika mandhari iliyokuzwa ya tiketi ya kiolesura cha wakala.',
        'Shows a link in the menu to go back in the ticket zoom view of the agent interface.' =>
            'Inaonyesha kiungo kwenye menyu kurudi nyuma katika mandhari iliyokuzwa ya tiketi ya kiolesura cha wakala.',
        'Shows a link in the menu to lock / unlock a ticket in the ticket overviews of the agent interface.' =>
            'Inaonyesha kiungo katika menyu kufunga/kufungua tiketi katia marejeo ya tiketi ya kiolesura cha wakala.',
        'Shows a link in the menu to lock/unlock tickets in the ticket zoom view of the agent interface.' =>
            'Inaonyesha kiungo katika menyu kufunga/kufungua tiketi katia marejeo ya tiketi ya kiolesura cha wakala.',
        'Shows a link in the menu to move a ticket in every ticket overview of the agent interface.' =>
            'Inaonyesha kiungo katika menyu kuhamisha tiketi katika kila marejeo ya kila tiketi ya kiolesura cha wakala.',
        'Shows a link in the menu to print a ticket or an article in the ticket zoom view of the agent interface.' =>
            'Inaonyesha kiungo katika menyu kuchapisha tiketi au makala katika mandhari iliyokuzwa ya tiketi ya kiolesura cha wakala.',
        'Shows a link in the menu to see the customer who requested the ticket in the ticket zoom view of the agent interface.' =>
            'Inaonyesha kiungo katika menyu kuona wateja walioomba tiketi katika mandhari iliyokuzwa ya tiketi ya kiolesura cha wakala.',
        'Shows a link in the menu to see the history of a ticket in every ticket overview of the agent interface.' =>
            'Inaonyesha kiungo katika menyu kuona historia ya tiketi katika marejeo ya kila tiketi ya kiolesura cha wakala.',
        'Shows a link in the menu to see the owner of a ticket in the ticket zoom view of the agent interface.' =>
            'Inaonyesha kiungo katika menyu kuona mmiliki wa tiketi katika mandhari iliyokuzwa ya tiketi ya kiolesura cha wakala.',
        'Shows a link in the menu to see the priority of a ticket in the ticket zoom view of the agent interface.' =>
            'Inaonyesha kiungo katika menyu kuona kipaumbele cha tiketi katika mandhari iliyokuzwa ya tiketi ya kiolesura cha wakala.',
        'Shows a link in the menu to see the responsible agent of a ticket in the ticket zoom view of the agent interface.' =>
            'Inaonyesha kiungo katika menyu kuona wakala husika wa tiketi katika mandhari iliyokuzwa ya tiketi ya kiolesura cha wakala.',
        'Shows a link in the menu to send an outbound email in the ticket zoom view of the agent interface.' =>
            'Inaonyesha kiungo katika menyu kutuma barua pepe iliyofungwa nje katika mandhari iliyokuzwa ya tiketi ya kiolesura cha wakala.',
        'Shows a link in the menu to set a ticket as pending in the ticket zoom view of the agent interface.' =>
            'Inaonyesha kiungo katika menyu kuweka tiketi kama inasubiri katika mandhari iliyokuzwa ya tiketi ya kiolesura cha wakala.',
        'Shows a link in the menu to set a ticket as spam in every ticket overview of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Inaonyesha kiungo katika menyu kuweka tiketi kama barua taka katika mapitio ya kila tiketi ya kiolesura cha wakala. Udhibiti ufikivu umeongezwa kuongesha au kutokuonyesha kiungo hiki kinaweza kufanywa kwa kutumia kibonye  "Kikundi" na yaliyomo kama "rw: Kikundi cha 1; Hamia_kwenye: kikundi cha 2".',
        'Shows a link in the menu to set the priority of a ticket in every ticket overview of the agent interface.' =>
            'Inaonyesha kiungo katika menyu kuona kipaumbele cha tiketi katika marejeo ya kila tiketi ya kiolesura cha wakala',
        'Shows a link in the menu to zoom a ticket in the ticket overviews of the agent interface.' =>
            'Inaonyesha kiungo katika menyu kukuza tiketi katika mapitio ya tiketi ya kiolesura cha wakala.',
        'Shows a link to access article attachments via a html online viewer in the zoom view of the article in the agent interface.' =>
            'Inaonyesha kiungo kufikia viambatanishi vya makala kupitia mandhari ya mtandaoni ya html  katika mandhari iliyokuzwa ya makala katika kiolesura cha wakala.',
        'Shows a link to download article attachments in the zoom view of the article in the agent interface.' =>
            'Inaonyesha kiungo cha kupakua viambatanishi vya makala katika mandhari iliyokuzwa ya makala ya kiolesura cha wakala.',
        'Shows a link to see a zoomed email ticket in plain text.' => 'Inaonyesha link kuona tiketi ya barua pepe iliyokuzwa katika matini wazi.',
        'Shows a link to set a ticket as spam in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Inaonyesha kiungo cha kuweka tiketi kama barua taka katika mandhari iliyokuzwa ya tiketi ya kiolesura cha wakala. Udhibiti wa kufikia ulioongezwa kuonyesha au kutokuonyesha kiungo hiki unawezwa ukafanywa na kibonye cha "Kikundi" na yaliyomo kama "rw:kikundi cha 1;hamisha_kwenye:kikundi cha 2".',
        'Shows a list of all the involved agents on this ticket, in the close ticket screen of the agent interface.' =>
            'Inaonyesha orodha ya mawakala wote waliohusika katika tiketi hii, katika skrini ya tiketi ya kufunga ya kiolesura cha wakala.',
        'Shows a list of all the involved agents on this ticket, in the ticket free text screen of the agent interface.' =>
            'Inaonyesha orodha ya mawakala wote waliohusika katika tiketi hii, katika skrini ya ya matini huru ya tiketi ya kiolesura cha wakala.',
        'Shows a list of all the involved agents on this ticket, in the ticket note screen of the agent interface.' =>
            'Inaonyesha orodha ya mawakala wote waliohusika katika tiketi hii, katika skrini ya kidokezo cha tiketi ya kiolesura cha wakala.',
        'Shows a list of all the involved agents on this ticket, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Inaonyesha orodha ya mawakala wote waliohusika katika tiketi hii, katika skrini ya mmiliki wa tiketi ya kiolesura cha wakala.',
        'Shows a list of all the involved agents on this ticket, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Inaonyesha orodha ya mawakala wote waliohusika katika tiketi hii, katika skrini ya kusubiri ya tiketi ya tikei iliyokuzwa katika  kiolesura cha wakala.',
        'Shows a list of all the involved agents on this ticket, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Inaonyesha orodha ya mawakala wote waliohusika katika tiketi hii, katika skrini ya kipaumbele ya tiketi ya tikei iliyokuzwa katika  kiolesura cha wakala',
        'Shows a list of all the involved agents on this ticket, in the ticket responsible screen of the agent interface.' =>
            'Inaonyesha orodha ya mawakala wote waliohusika katika tiketi hii, katika skrini ya kuhusika ya tiketi ya kiolesura cha wakala.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the close ticket screen of the agent interface.' =>
            'Inaonyesha orodha ya mawakala wote( Mawakala wote wenye kidokezo cha ruhusa katika foleni/tiketi) wanaoweza kugundua nani ataarifiwe kuhusu kidokezo hiki, katika skrini ya kufunga ya tiketi ya kiolesura cha wakala.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket free text screen of the agent interface.' =>
            'Inaonyesha orodha ya mawakala wote( Mawakala wote wenye kidokezo cha ruhusa katika foleni/tiketi) wanaoweza kugundua nani ataarifiwe kuhusu kidokezo hiki, katika skrini ya matini huru ya tiketi ya kiolesura cha wakala.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket note screen of the agent interface.' =>
            'Inaonyesha orodha ya mawakala wote( Mawakala wote wenye kidokezo cha ruhusa katika foleni/tiketi) wanaoweza kugundua nani ataarifiwe kuhusu kidokezo hiki, katika skrini ya kidokezo cha tiketi ya kiolesura cha wakala.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Inaonyesha orodha ya mawakala wote( Mawakala wote wenye kidokezo cha ruhusa katika foleni/tiketi) wanaoweza kugundua nani ataarifiwe kuhusu kidokezo hiki, katika skrini ya mmiliki wa tiketi ya kiolesura cha wakala.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Inaonyesha orodha ya mawakala wote( Mawakala wote wenye kidokezo cha ruhusa katika foleni/tiketi) wanaoweza kugundua nani ataarifiwe kuhusu kidokezo hiki, katika skrini ya kusubiri ya tiketi ya kiolesura cha wakala.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Inaonyesha orodha ya mawakala wote( Mawakala wote wenye kidokezo cha ruhusa katika foleni/tiketi) wanaoweza kugundua nani ataarifiwe kuhusu kidokezo hiki, katika skrini ya kipaumbele cha tiketi ya tiketi iliyokuzwa katika kiolesura cha wakala.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket responsible screen of the agent interface.' =>
            'Inaonyesha orodha ya mawakala wote( Mawakala wote wenye kidokezo cha ruhusa katika foleni/tiketi) wanaoweza kugundua nani ataarifiwe kuhusu kidokezo hiki, katika skrini ya kuhusika ya tiketi ya kiolesura cha wakala.',
        'Shows a preview of the ticket overview (CustomerInfo => 1 - shows also Customer-Info, CustomerInfoMaxSize max. size in characters of Customer-Info).' =>
            'Inaonyesha mahakikisho ya mapitio ya tiketi (Taarifa za mteja =>1 - pia inaonyesha taarifa za mteja, ukubwa wa kima cha juu cha taarifa za mteja kima cha juu.ukubwa katika sifa za mteja-taarifa).',
        'Shows a select of ticket attributes to order the queue view ticket list. The possible selections can be configured via \'TicketOverviewMenuSort###SortAttributes\'.' =>
            'Inaonyesha chaguo ya sifa za tiketi kuagiza orodha ya tiketi ya mandhari ya foleni. Michaguo inayowezekana inaweza kusadiwa kupitia \'Panga menyu ya mapitio ya tiketi###Panga sifa\'',
        'Shows all both ro and rw queues in the queue view.' => 'Inaonyesha foleni zote za ro na rw katika mandhari ya foleni.',
        'Shows all both ro and rw tickets in the service view.' => 'Inaonyesha tiketi zote za ro na rw katika mandhari ya kuona huduma.',
        'Shows all open tickets (even if they are locked) in the escalation view of the agent interface.' =>
            'Inaonyesha tiketi zote zilizowazi (hata kama zimefungwa) katika mandhari ya kupandishwa juu ya kiolesura cha wakala.',
        'Shows all open tickets (even if they are locked) in the status view of the agent interface.' =>
            'Inaonyesha tiketi zote zilizowazi (hata kama zimefungwa) katika mandhari ya kuona ya hali ya kiolesura cha wakala.',
        'Shows all the articles of the ticket (expanded) in the zoom view.' =>
            'Inaonyesha makala zote za tiketi (zilizoongezwa) katika mandhari ya kuona iliyokuzwa.',
        'Shows all the customer identifiers in a multi-select field (not useful if you have a lot of customer identifiers).' =>
            'Inaonyesha vitambulisho vya mteja katika uga wa uchaguzi wa wingi (haitumiki kama una vitambulisho vya mteja vingi).',
        'Shows an owner selection in phone and email tickets in the agent interface.' =>
            'Inaonyesha chaguo la mmiliki katika simu na tiketi za barua pepe katika kiolesura cha wakala.',
        'Shows colors for different article types in the article table.' =>
            'Inaonyesha rangi kwa ajili ya aina makala mbalimbali katika jedwali la makala.',
        'Shows customer history tickets in AgentTicketPhone, AgentTicketEmail and AgentTicketCustomer.' =>
            'Inaonyesha tiketi za historia za mteja katika simu ya tiketi ya wakala, Barua pepe za tiketi za wakala na mteja wa tiketi za wakala.',
        'Shows either the last customer article\'s subject or the ticket title in the small format overview.' =>
            'Inaonyesha somo la mwisho la makala ya mteja la mwisho au kichwa cha tiketi katika mapitio madogo ya umbizo.',
        'Shows existing parent/child queue lists in the system in the form of a tree or a list.' =>
            'Inaonyesha orodha ya foleni Kuu/ndogo iliyopo katika mfumo katika fomu ya mti au orodha.',
        'Shows information on how to start OTRS Scheduler' => 'Inaonyesha taarifa jinsi ya kuanza kipanga ratiba cha OTRS',
        'Shows the activated ticket attributes in the customer interface (0 = Disabled and 1 = Enabled).' =>
            'Inaonyesha sifa za tiketi zilizoamishwa katika kiolesura cha mteja (0 = kutowezesha na 1 = Wezesha).',
        'Shows the articles sorted normally or in reverse, under ticket zoom in the agent interface.' =>
            'Inaonyesha makala zilizopangwa kawaida au kinyume, katika ukuzwaji wa tiketi katika kiolesura cha wakala.',
        'Shows the customer user information (phone and email) in the compose screen.' =>
            'Inaonyesha taarifa za mtumiaji wa mteja (simu na barua pepe) katika skrini ya kutunga.',
        'Shows the customer user\'s info in the ticket zoom view.' => 'Inaonyesha taarifa za mtumiaji za mteja katika mandhari ya kuona yaliyokuzwa ya tiketi.',
        'Shows the message of the day (MOTD) in the agent dashboard. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually.' =>
            'Inaonyesha ujumbe wa siku wa siku (MOTD) katika dashibodi ya wakala. "Kikundi" inatumika kuzuia kufikia programu-jalizi (mfano kikundi: kiongozi:Kikundi cha 1; kikundi cha 2;). "Chaguo-msingi" inaonyesha programu-jalizi imewezeshwa kwa chaguo-msingi au kama mtumiaji anahitaji kuwezesha kwa mkono.',
        'Shows the message of the day on login screen of the agent interface.' =>
            'Inaonyesha ujumbe wa siku katika skrini ya kuingilia ya kiolesura cha wakala.',
        'Shows the ticket history (reverse ordered) in the agent interface.' =>
            'Inaonyesha historia ya tiketi (mpangilio uliogeuzwa) katika kiolesura cha wakala.',
        'Shows the ticket priority options in the close ticket screen of the agent interface.' =>
            'Inaonyesha michaguo ya kipaumbele cha tiketi katika skrini ya tiketi ya kufunga ya kiolesura cha wakala.',
        'Shows the ticket priority options in the move ticket screen of the agent interface.' =>
            'Inaonyesha michaguo ya kipaumbele cha tiketi katika skrini ya tiketi ya kuhamisha ya kiolesura cha wakala.',
        'Shows the ticket priority options in the ticket bulk screen of the agent interface.' =>
            'Inaonyesha michaguo ya kipaumbele cha tiketi katika skrini ya wingi ya  tiketi ya kiolesura cha wakala.',
        'Shows the ticket priority options in the ticket free text screen of the agent interface.' =>
            'Inaonyesha michaguo ya kipaumbele cha tiketi katika skrini ya tiketi ya kiolesura cha wakala.',
        'Shows the ticket priority options in the ticket note screen of the agent interface.' =>
            'Inaonyesha michaguo ya kipaumbele ya tiketi katika skrini ya kidokezo ya tiketi ya kiolesura cha wakala.',
        'Shows the ticket priority options in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Inaonyesha michaguo ya kipaumbele ya tiketi katika skrini ya mmiliki ya tiketi ya tiketi iliyokuzwa katika kiolesura cha wakala.',
        'Shows the ticket priority options in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Inaonyesha michaguo ya kipaumbele ya tiketi katika skrini ya tiketi inayosubiri ya tiketi iliyokuzwa katika kiolesura cha wakala.',
        'Shows the ticket priority options in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Inaonyesha michaguo ya kipaumbele ya tiketi katika skrini ya kipaumbele ya tiketi ya tiketi iliyokuzwa katika kiolesura cha wakala.',
        'Shows the ticket priority options in the ticket responsible screen of the agent interface.' =>
            'Inaonyesha michaguo ya kipaumbele cha tiketi katika skrini inayohusika ya tiketi ya kiolesura cha wakala.',
        'Shows the title fields in the close ticket screen of the agent interface.' =>
            'Inaonyesha uga wa kichwa cha habari katika skrini ya tiketi iliyofungwa ya  kiolesura cha wakala.',
        'Shows the title fields in the ticket free text screen of the agent interface.' =>
            'Inaonyesha uga wa kichwa cha habari katika skrini ya matini huru ya tiketi ya  kiolesura cha wakala.',
        'Shows the title fields in the ticket note screen of the agent interface.' =>
            'Inaonyesha uga wa kichwa cha habari katika skrini ya kidokezo ya tiketi ya  kiolesura cha wakala.',
        'Shows the title fields in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Inaonyesha uga wa kichwa cha habari katika skrini ya mmiliki wa tiketi ya tiketi iliyokuzwa katika kiolesura cha wakala.',
        'Shows the title fields in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Inaonyesha uga wa kichwa cha habari katika skrini inayosubiri ya tiketi ya tiketi iliyokuzwa katika kiolesura cha wakala.',
        'Shows the title fields in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Inaonyesha uga wa kichwa cha habari katika skrini ya kipaumbele ya tiketi ya tiketi iliyokuzwa katika kiolesura cha wakala.',
        'Shows the title fields in the ticket responsible screen of the agent interface.' =>
            'Inaonyesha uga wa kichwa cha habari katika skrini inayohusika ya tiketi ya tiketi iliyokuzwa katika kiolesura cha wakala.',
        'Shows time in long format (days, hours, minutes), if set to "Yes"; or in short format (days, hours), if set to "No".' =>
            'Inaonyesha muda kwa umbizo la marefu (siku, masaa, dakika), kama imewekwa "Ndio"; au katika umbizo la ufupi (siku, masaa), kama imewekwa "Hapana".',
        'Shows time use complete description (days, hours, minutes), if set to "Yes"; or just first letter (d, h, m), if set to "No".' =>
            'Inaonyesha maelezo yaliyokamilika ya matumizi ya muda (siku, masaa, dakika), kama imewekwa "Ndio"; au herufi ya kwanza (s, m, d), kama imewekwa "Hapana".',
        'Skin' => 'Gamba',
        'SolutionDiffInMin' => 'Tofauti katika dakika katika ufumbuzi',
        'SolutionInMin' => 'Ufumbuzi katika dakika',
        'Some description!' => '',
        'Some picture description!' => '',
        'Sorts the tickets (ascendingly or descendingly) when a single queue is selected in the queue view and after the tickets are sorted by priority. Values: 0 = ascending (oldest on top, default), 1 = descending (youngest on top). Use the QueueID for the key and 0 or 1 for value.' =>
            'Inapanga tiketi (kwa kupanda au kushuka) wakati foleni moja imechaguliwakatika mandhari ya foleni na baada ya tiketi kupangwa kwa kipaumbele. Thamani: 0 = kupanga (Ya zaman juu, chaguo msingi), 1 = Kushuka (Ya sasa juu). Tumia kitambulisho cha foleni kwa ajili ya ufunguo na 0 au 1 kwa ajili ya thamani.',
        'Sorts the tickets (ascendingly or descendingly) when a single queue is selected in the service view and after the tickets are sorted by priority. Values: 0 = ascending (oldest on top, default), 1 = descending (youngest on top). Use the ServiceID for the key and 0 or 1 for value.' =>
            'Inapanga tiketi (kwa kupanda au kushuka) wakati foleni moja imechaguliwakatika mandhari ya huduma na baada ya tiketi kupangwa kwa kipaumbele. Thamani: 0 = kupanga (Ya zaman juu, chaguo msingi), 1 = Kushuka (Ya sasa juu). Tumia kitambulisho cha huduma kwa ajili ya ufunguo na 0 au 1 kwa ajili ya thamani.',
        'Spam Assassin example setup. Ignores emails that are marked with SpamAssassin.' =>
            'Mfano wa mpangilio wa barua taka muuaji. Puuzia barua pepe ambazo zimewekwa alama kama barua taka muuaji.',
        'Spam Assassin example setup. Moves marked mails to spam queue.' =>
            'Mfano wa mpangilio wa barua taka muuaji.Hamisha barua pepe zilizowekwa alama kwenye foleni ya barua taka.',
        'Specifies if an agent should receive email notification of his own actions.' =>
            'Inabainisha kama wakala apokee taarifa ya barua pepe kwa ajili ya matendo yake.',
        'Specifies the available note types for this ticket mask. If the option is deselected, ArticleTypeDefault is used and the option is removed from the mask.' =>
            'Inabainisha aina za vidokezo zilizopo kwa ajili ya barakoa ya tiketi hii. Kama chaguo halijachaguliwa, aina chaguo msingi ya makala inatumika na chaguo linatolewa kwenye barakoa',
        'Specifies the background color of the chart.' => 'Inabainisha rangi ya nyuma ya chati.',
        'Specifies the background color of the picture.' => 'Inabainisha rangi ya nyuma ya picha',
        'Specifies the border color of the chart.' => 'Inabainisha rangi ya ukingo ya chati.',
        'Specifies the border color of the legend.' => 'Inabainisha rangi ya ukingo wa maelezo mafupi.',
        'Specifies the bottom margin of the chart.' => 'Inabainisha pambizo la chini ya chini',
        'Specifies the default article type for the ticket compose screen in the agent interface if the article type cannot be automatically detected.' =>
            'Inabainiinisha aina ya makala ya chaguo-msingi ya skrini ya kutunga ya tiketi katika kiolesura cha wakala kama aina ya makala haiwezi kupatikana kwa otomatiki.',
        'Specifies the different article types that will be used in the system.' =>
            'Inabainisha aina za makala tofauti ambazo zitatumika katika mfumo.',
        'Specifies the different note types that will be used in the system.' =>
            'Inabainisha aina za vidokezo mbalimbali ambavyo vitatumika katika mfumo.',
        'Specifies the directory to store the data in, if "FS" was selected for TicketStorageModule.' =>
            'Inabainisha mpangilio orodha ya kuhufadhi data ndani, kama "FS" ilichaguliwa kwa moduli ya uhifadhi wa tiketi.',
        'Specifies the directory where SSL certificates are stored.' => 'Inabainisha mpangilio orodha ambapo vyeti cha SSL vimehifadhiwa.',
        'Specifies the directory where private SSL certificates are stored.' =>
            'Inabainisha mpango ordha ambapo Vyeti vya SSL binafsi vimehifadhiwa.',
        'Specifies the email address that should be used by the application when sending notifications. The email address is used to build the complete display name for the notification master (i.e. "OTRS Notification Master" otrs@your.example.com). You can use the OTRS_CONFIG_FQDN variable as set in your configuation, or choose another email address. Notifications are messages such as en::Customer::QueueUpdate or en::Agent::Move.' =>
            'Bainisha anwani ya barua pepe ambayo itatumika na programu tumizi wakati wa utumaji wa taarifa. Anwani ya barua pepe inatumika kujenga jina kamili la kuonyeshwa kwa ajili ya mkuu wa taarifa (mfano "Mkuu wa taarifa za OTRS"otrs@your.example.com ). Unaweza kutumia thamani inayobadilika ya OTRS_CONFIG_FQDN kama ilivyowekwa katika usanidi wako, au chagua anwani nyingine ya baru apepe. Taarifa ni ujumbe kama wezesha::Mteja::Foleni ya usasishaji au wezesha::wakala::Hamisha.',
        'Specifies the group where the user needs rw permissions so that he can access the "SwitchToCustomer" feature.' =>
            'Bainisha kikundi ambacho mtumiaji anahitaji ruhusa za rw ili aweze kufikia kipengele cha "Badili kwenda kwa Mteja".',
        'Specifies the left margin of the chart.' => 'Inabainisha pambizo la kushoto la chati.',
        'Specifies the name that should be used by the application when sending notifications. The sender name is used to build the complete display name for the notification master (i.e. "OTRS Notification Master" otrs@your.example.com). Notifications are messages such as en::Customer::QueueUpdate or en::Agent::Move.' =>
            'Bainisha jina ambalo litatumika na programu tumizi wakati wa utumaji wa taarifa. Jina la mtumaji linatumika kujenga jina kamili la kuonyeshwa kwa ajili ya mkuu wa taarifa (mfano "Mkuu wa taarifa za OTRS"otrs@your.example.com ). Taarifa ni ujumbe kama wezesha::Mteja::Foleni ya usasishaji au wezesha::wakala::Hamisha.',
        'Specifies the order in which the firstname and the lastname of agents will be displayed.' =>
            'Inabainisha mpangilio ambao jina la kwanza na jina la mwisho ya mawakala yataonyeshwa.',
        'Specifies the path of the file for the logo in the page header (gif|jpg|png, 700 x 100 pixel).' =>
            'Inabainisha njia kwenda kwenye faili kwa ajili ya nembo katika kichwa cha ukurasa (gif|jpg|png, 700 x 100 pikseli).',
        'Specifies the path of the file for the performance log.' => 'Bainisha njia ya faili kwa ajili ya batli ya utendaji.',
        'Specifies the path to the converter that allows the view of Microsoft Excel files, in the web interface.' =>
            'Bainisha njia ya kibadili inayoruhusu mandhari ya faili la Microsoft Excel, katika kiolesura cha tovuti. ',
        'Specifies the path to the converter that allows the view of Microsoft Word files, in the web interface.' =>
            'Inabainisha njia ya kibadilishaji ambayo inaruhusu mandhari ya mafaili ya Microsoft Word, katika kiolesura cha tovuti.',
        'Specifies the path to the converter that allows the view of PDF documents, in the web interface.' =>
            'Inabainisha njia ya kibadilishaji ambayo inaruhusu mandhari ya nyaraka za PDF, katika kiolesura cha tovuti.',
        'Specifies the path to the converter that allows the view of XML files, in the web interface.' =>
            'Inabainisha njia ya kibadilishaji ambayo inaruhusu mandhari ya mafaili ya XML, katika kiolesura cha tovuti.',
        'Specifies the right margin of the chart.' => 'Inabainisha pambizo la kulia la chati.',
        'Specifies the text color of the chart (e. g. caption).' => 'Inabainisha rangi ya matini ya chati (mfano maelezo mafupi)',
        'Specifies the text color of the legend.' => 'Bainisha rangi ya uga ya maelezo mafupi.',
        'Specifies the text that should appear in the log file to denote a CGI script entry.' =>
            'Bainisha matini ambayo inatokea katika faili la batli kuchangia hati ya CGI.',
        'Specifies the top margin of the chart.' => 'Bainisha pambizo la juu la chati.',
        'Specifies user id of the postmaster data base.' => 'Bainisha kitambulisho cha mtumiaji cha hifadhi data cha mkuu wa posti.',
        'Specifies whether all storage backends should be checked when looking for attachements. This is only required for installations where some attachements are in the file system, and others in the database.' =>
            'Inabainisha kama mazingira yoteya nyuma ya hifadhi yameangaliwa wakati wa uangaliaji wa viambatanishi. Hii inahitajika tu kwa ajili ya usanidi ambapo baadhi ya viambatanishi vipo kwenye faili la mfumo na vingine katika hifadhi data. ',
        'Specify how many sub directory levels to use when creating cache files. This should prevent too many cache files being in one directory.' =>
            'Bainisha ngazi ngapi za vipengele vya mpangilio orodha vya kutumia wakati wa kutengeneza faili la hifadhi muda. Hii izuie mafaili mengi kuwa kwenye mpangilio orodha moja.',
        'Specify the channel to be used to fetch OTRS Business Solution™ updates. Warning: Development releases might not be complete, your system might experience unrecoverable errors and on extreme cases could become unresponsive!' =>
            'Bainisha mkondo utakao tumika kuchukua usasishwaji wa OTRS Business Solution™. Onyo: Matoleo ya maendeleo yanaweza yasiwe kamili, mfumo wako unaweza kupata matatizo yasiyoweza kupona na kwa hali za zilizokithiri unaweza kuwa hauwezi kuji.',
        'Standard available permissions for agents within the application. If more permissions are needed, they can be entered here. Permissions must be defined to be effective. Some other good permissions have also been provided built-in: note, close, pending, customer, freetext, move, compose, responsible, forward, and bounce. Make sure that "rw" is always the last registered permission.' =>
            'Ruhusa zinazopatikana za kiwango kwa mawakala ndani ya programu tumizi. Kama ruhusa zaidi zinahitajika, zinaweza kuingizwa hapa. Ruhusa lazima zifafanuliwe kuwa za ufanis. Baadhi ya ruhusa nzuri zimejengwa ndani: Kidokezo,Kungoja, Mteja, matini huru, kusogeza, Kutunga, uhusika, kutuma mbele na udundaji. Hakikisha kwamba "rw" sikuzote ni ruhusa ya mwisho kusajiliwa.',
        'Start number for statistics counting. Every new stat increments this number.' =>
            'Anza namba kwa ajili ya hesabu ya takwimu. Kila takwimu mpya ongeza namba hii.',
        'Starts a wildcard search of the active object after the link object mask is started.' =>
            'Anza utafutaji wa kibambo egemezi wa kipengele amilifu baada ya barakoa ya kipengele kiunganishi kuanza.',
        'Stat#' => 'Takwimu#',
        'Statistics' => 'Takwimu',
        'Status view' => 'Angalia hali',
        'Stop words for fulltext index. These words will be removed.' => 'Sitisha maneno kwa ajili ya kipengele cha nakala kamili. Maneno haya yatatolewa.',
        'Stores cookies after the browser has been closed.' => 'Inahifadhi vidakuzi baada ya kivinjari kufungwa. ',
        'Strips empty lines on the ticket preview in the queue view.' => 'Toa mistari iliyowazi katika mapitio ya tiketi katika mandhari ya foleni.',
        'Strips empty lines on the ticket preview in the service view.' =>
            'Toa mistari iliyowazi katika mapitio ya tiketi katika mandhari ya huduma.',
        'System Maintenance' => 'Matengenezo ya mfumo',
        'System Request (%s).' => 'Maombi ya mfumo (%s).',
        'Templates <-> Queues' => 'Vielezo <-> Foleni',
        'Textarea' => 'Sehemu ya nakala',
        'The "bin/PostMasterMailAccount.pl" will reconnect to POP3/POP3S/IMAP/IMAPS host after the specified count of messages.' =>
            '"bin/PostMasterMailAccount.pl" itakuunganisha na POP3/POP3S/IMAP/IMAPS baada ya hesabu bainishi ya ujumbe.',
        'The agent skin\'s InternalName which should be used in the agent interface. Please check the available skins in Frontend::Agent::Skins.' =>
            'Gamba la wakala la Jina la ndani ambalo linatumika katika kiolesura cha wakala. Tafadhali angali magamba yanayopatikana katika Mazingira ya mbele::wakala::Magamba.',
        'The customer skin\'s InternalName which should be used in the customer interface. Please check the available skins in Frontend::Customer::Skins.' =>
            'Gamba la wakala la Jina la ndani ambalo linatumika katika kiolesura cha mteja. Tafadhali angali magamba yanayopatikana katika Mazingira ya mbele::wakala::Magamba.',
        'The divider between TicketHook and ticket number. E.g \': \'.' =>
            'Kitenganishi kati ya ndoano ya tiketi na namba ya tiketi. Mfano \':\'.',
        'The duration in minutes after emitting an event, in which the new escalation notify and start events are suppressed.' =>
            'Muda katika dakika baada ya kutoa tukio, ambacho uarifu wa kupandishwa kupya na kuanza kwa matukio kumefutwa.',
        'The format of the subject. \'Left\' means \'[TicketHook#:12345] Some Subject\', \'Right\' means \'Some Subject [TicketHook#:12345]\', \'None\' means \'Some Subject\' and no ticket number. In the last case you should enable PostmasterFollowupSearchInRaw or PostmasterFollowUpSearchInReferences to recognize followups based on email headers and/or body.' =>
            'Umbizo la somo. \'Kushoto\' inamaana \'[Ndoano ya tiketi#:12345]\', \'Hakuna\' inamaana \'Baadhi ya masomo\' na hakuna namba ya tiketi. Katika jambo la mwisho unatakiwa kuwezesha PostmasterFollowupSearchInRaw au PostmasterFollowUpSearchInReferences kutambua ufuatiliaji kulingana na vichwa vya barua pepe na/au kiini.',
        'The headline shown in the customer interface.' => 'Kichwa cha habari kinaonyeshwa katika kiolesura cha mteja.',
        'The identifier for a ticket, e.g. Ticket#, Call#, MyTicket#. The default is Ticket#.' =>
            'Kitambulishi cha tiketi, mfano. Tiketi #, Simu#, Tiketizangu#. Chaguo-msingi ni Tiketi#.',
        'The logo shown in the header of the agent interface for the skin "default". See "AgentLogo" for further description.' =>
            'Nembo inayoonyeshwa katika kichwa cha kiolesura cha wakala kwa ajili gamba "chaguo-msingi". Angalia "Nembo ya wakala" kwa ufafanuzi zaidi.',
        'The logo shown in the header of the agent interface for the skin "ivory". See "AgentLogo" for further description.' =>
            'Nembo inayoonyeshwa katika kichwa cha kiolesura cha wakala kwa ajili gamba "ivory". Angalia "Nembo ya wakala" kwa ufafanuzi zaidi.',
        'The logo shown in the header of the agent interface for the skin "ivory-slim". See "AgentLogo" for further description.' =>
            'Nembo inayoonyeshwa katika kichwa cha kiolesura cha wakala kwa ajili gamba "ivory-slim". Angalia "Nembo ya wakala" kwa ufafanuzi zaidi.',
        'The logo shown in the header of the agent interface for the skin "slim". See "AgentLogo" for further description.' =>
            'Nembo inayoonyeshwa katika kichwa cha kiolesura cha wakala kwa ajili gamba "slim". Angalia "Nembo ya wakala" kwa ufafanuzi zaidi.',
        'The logo shown in the header of the agent interface. The URL to the image can be a relative URL to the skin image directory, or a full URL to a remote web server.' =>
            'Nembo iliyoonyeshwa kwenye kichwa cha kiolesura cha wakala. URL kwenye taswira inaweza URL inayofanana na gamba la taswira la mpangilio orodha, au URL nzima kwenye seva ya wavuti. ',
        'The logo shown in the header of the customer interface. The URL to the image can be a relative URL to the skin image directory, or a full URL to a remote web server.' =>
            'Nembo iliyoonyeshwa kwenye kichwa cha kiolesura cha mteja. URL kwenye taswira inaweza URL inayofanana na gamba la taswira la mpangilio orodha, au URL nzima kwenye seva ya wavuti. ',
        'The logo shown on top of the login box of the agent interface. The URL to the image must be relative URL to the skin image directory.' =>
            'Nembo iliyoonyeshwa juu ya kisanduku cha kuingia kiolesura cha wakala. URL kwenye taswira lazima iwe URL inayofanana na gamba la taswira la mpangilio orodha.',
        'The maximal number of articles expanded on a single page in AgentTicketZoom.' =>
            'Kima cha juu cha namba ya makala imaongezwa katika ukurasa mmoja katika Kikuza cha wakala wa tiketi. ',
        'The maximal number of articles shown on a single page in AgentTicketZoom.' =>
            'Kima cha chini ya namba ya makala zinazoonyeshwa katika ukurasa mmoja katika kikuza cha wakala wa tiketi.',
        'The text at the beginning of the subject in an email reply, e.g. RE, AW, or AS.' =>
            'Matini mwanzoni mwa somo katika majibu ya barua pepe, mfano RE,AW au AS.',
        'The text at the beginning of the subject when an email is forwarded, e.g. FW, Fwd, or WG.' =>
            'Matini mwanzoni mwa somo wakati barua pepe inatumwa mbele, mfano FW, Fwd, au WG.',
        'This event module stores attributes from CustomerUser as DynamicFields tickets. Please see the setting above for how to configure the mapping.' =>
            'Moduli hii ya tukio inahifadhi sifa kutoka kwa mtumiaji wa mteja kama uga wenye nguvu wa tiketi. Tafadhali angalia mipangilio juu jinsi ya kusanidi kwa ajili ya kuweka ramani.',
        'This module and its PreRun() function will be executed, if defined, for every request. This module is useful to check some user options or to display news about new applications.' =>
            'Moduli hii na fomula saidizi yake PreRun() zitatendewa kazi, kama zikikataliwa, kwa kila ombi. Moduli hii iatumika kuangalia michaguo ya mtumiaji au kuonyesha taarifa kuhusu programu-tumizi mpya.',
        'This option defines the dynamic field in which a Process Management activity entity id is stored.' =>
            'Chaguo hili linafafanua uga wenye nguvu ambao kitambulisho cha kipengele halisi cha shughuli wa usimamizi wa mchakato kinahifadhiwa.',
        'This option defines the dynamic field in which a Process Management process entity id is stored.' =>
            'Chaguo hili linafafanua uga wenye nguvu ambao kitambulisho kipengele halisi cha mchakato wa usimamizi wa mchakato kinahifadhiwa.',
        'This option defines the process tickets default lock.' => 'Chaguo hili linafafanua ufungwaji  chaguo msingi wa tiketi ya mchakato.',
        'This option defines the process tickets default priority.' => 'Chaguo hili linafafanua kipaumbele chaguo msingi ya tiketi ya mchakato.',
        'This option defines the process tickets default queue.' => 'Chaguo hili linafafanua foleni chaguo msingi ya tiketi ya mchakato.',
        'This option defines the process tickets default state.' => 'Chaguo hili linafafanua hali chaguo msingi ya tiketi ya mchakato.',
        'This option will deny the access to customer company tickets, which are not created by the customer user.' =>
            'Chaguo hili litakuzuia kufikia tiketi za kampuni za mteja, ambazo hazikujatengenezwa na mtumiaji wa mteja.',
        'This setting allows you to override the built-in country list with your own list of countries. This is particularly handy if you just want to use a small select group of countries.' =>
            'Mpangalio huu unakuruhusu kutendua orodha ya nchi ilijengewa ndani  kwa orodha yako ya nchi. Inatumika hasa kama unataka kutumia nchi chache usichaguazo.',
        'Ticket Queue Overview' => 'Mapitio ya foleni ya tiketi',
        'Ticket event module that triggers the escalation stop events.' =>
            'Moduli ya tukio la tiketi ambalo linaamsha tukio la kusimamishwa kuwa upandishwaji.',
        'Ticket moved into Queue "%s" (%s) from Queue "%s" (%s).' => 'Tiketi imehamishwa kwenye foleni "%s" (%s) kutoka foleni"%s" (%s).',
        'Ticket overview' => 'Marejeo ya tiketi',
        'TicketNumber' => 'Namba ya tiketi',
        'Time in seconds that gets added to the actual time if setting a pending-state (default: 86400 = 1 day).' =>
            'Muda katika sekunde ambao unaongezwa kwneye muda halisi kama hali ya kusubiri ikiwekwa (chaguo-msingi: 86400 = siku 1).',
        'Title updated: Old: "%s", New: "%s"' => 'Kichwa cha habari kimesasishwa: ya zamani :"%s", Mpya: "%s"',
        'Toggles display of OTRS FeatureAddons list in PackageManager.' =>
            'Inageuza onyesho la orodha ya vifaa vya nyongeza ya vipengele vya OTRS  katika msimamizi wa kifurushi.',
        'Toolbar Item for a shortcut.' => 'Kipengele cha mwambaa zana kwa ajili ya mkato.',
        'Tree view' => '',
        'Turns off SSL certificate validation, for example if you use a transparent HTTPS proxy. Use at your own risk!' =>
            'Zima uhalalishaji wa cheti wa SSL, kwa mfano kama ukitumia seva mbadala ya HTTPS iliyowazi. Tumia kwa tahadhari yako mwenyewe!',
        'Turns on drag and drop for the main navigation.' => 'Washa kokota na dondosha kwa ajili wa uabiri mkuu.',
        'Turns on the animations used in the GUI. If you have problems with these animations (e.g. performance issues), you can turn them off here.' =>
            'Washa uhuishaji uliotumika katika GUI. Kama una matatizo na uhuishaji huu (mfano maswala ya uendeshaji) unaweza kuzima hapa.',
        'Turns on the remote ip address check. It should be set to "No" if the application is used, for example, via a proxy farm or a dialup connection, because the remote ip address is mostly different for the requests.' =>
            'Inawasha uangalizi wa anwani ya IP ya mbali. Iwekwe kuwa "Hapana" kama programu-tumizi inatumika, mfano, kupitia proxy farm au muunganisho wa modem, kwasababu anwani za ip za mbali ni tofauti sana kwa ajili ya maombi.',
        'Unlock tickets whenever a note is added and the owner is out of office.' =>
            'Fungua tiketi kidokezo kinapoongezwa na mmiliki hayupo ofisini.',
        'Unlocked ticket.' => 'Tiketi zilizofunguliwa.',
        'Update Ticket "Seen" flag if every article got seen or a new Article got created.' =>
            'Sasisha alama ya tiketi "Imeonekana" kama kila makala imeonekana au makala mpya imetengenezwa. ',
        'Update and extend your system with software packages.' => 'Sasisha na panua mfumo wako kwa vifurushi vya programu.',
        'Updated SLA to %s (ID=%s).' => ' SLA  iliyosasishwa kwenda %s (Kitambulisho=%s).',
        'Updated Service to %s (ID=%s).' => 'Huduma iliyosasishwa kwenda %s (Kitambulisho =%s).',
        'Updated Type to %s (ID=%s).' => ' Aina iliyosasishwa kwenda %s (Kitambulisho =%s).',
        'Updated: %s' => 'Sasishwa: %s',
        'Updated: %s=%s;%s=%s;%s=%s;' => 'Sasishwa: %s=%s;%s=%s;%s=%s;',
        'Updates the ticket escalation index after a ticket attribute got updated.' =>
            'Sasisha kielezo cha kupanda cha tiketi baada ya sifa ya tiketi kusasishwa.',
        'Updates the ticket index accelerator.' => 'Sasisha kiharakishi cha kielezo cha tiketi.',
        'UserFirstname' => 'Jina la kwanza la mtumiaji',
        'UserLastname' => 'Jina la mwisho la mtumiaji',
        'Uses Cc recipients in reply Cc list on compose an email answer in the ticket compose screen of the agent interface.' =>
            'Inatumia wapokeaji wa Cc katika kujibu orodha ya Cc kwenye kutunga majibu ya barua pepe katika skrini ya kutunga tiketi ya kiolesura cha wakala. ',
        'Uses richtext for viewing and editing notification events.' => 'Inatumia matini tajiri kwa kuangalia na kuhariri taarifa za matukio.',
        'Uses richtext for viewing and editing: articles, salutations, signatures, standard templates, auto responses and notifications.' =>
            'Inatumia makala tajiri kwa kuangalia na kuhariri: makala, salamu, saini, vielezo vyenye viwango, majibu otomatiki na taarifa.',
        'View performance benchmark results.' => 'Angalia matokeo ya utendaji wa kuigwa.',
        'View system log messages.' => 'Angalia ujumbe wa batli ya mfumo.',
        'Wear this frontend skin' => 'Vaa ngozi hii mazingira ya mbele',
        'Webservice path separator.' => 'Kitenganishi cha njia za huduma za tovuti.',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. Here you can define the body of this note (this text cannot be changed by the agent).' =>
            'Wakati tiketi zinaungwanishwa, kidokezo kitaongezwa otomatiki kwenye tiketi ambayo sio amililifu. Hapa unaweza kufafanua kiini cha kidokezo hiki (Matini haya hayawezi kubadilishwa na wakala).',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. Here you can define the subject of this note (this subject cannot be changed by the agent).' =>
            'Wakati tiketi zinaungwanishwa, kidokezo kitaongezwa otomatiki kwenye tiketi ambayo sio amililifu. Hapa unaweza kufafanua somo la kidokezo hiki (Somo hili haliwezi kubadilishwa na wakala).',
        'When tickets are merged, the customer can be informed per email by setting the check box "Inform Sender". In this text area, you can define a pre-formatted text which can later be modified by the agents.' =>
            'Wakati tiketi zinaunganishwa, wakala anaweza kutaarifiwa kwa barua pepe kwa kuweka kwenye kisanduku cha kuangalia "Mjulishe mtumaji". Katika eneo la matini haya, unaweza kuelezea matini yaliyoundwa kabla ambayo baadae yanaweza kubadilishwa na mawakala.',
        'Write a new, outgoing mail' => 'Andika barua pepe mpya  ya kwenda nje',
        'Yes, but hide archived tickets' => '',
        'Your queue selection of your favorite queues. You also get notified about those queues via email if enabled.' =>
            'Chaguo lako la foleni kwa foleni uzipendazo. Pia utapata kujulishwa kuhusu foleni hizi kwa kupitia barua pepe kama imewezeshwa.',
        'Your service selection of your favorite services. You also get notified about those services via email if enabled.' =>
            'Chaguo lako la huduma la huduma uzipendazo. Pia utapata kujulishwa kuhusu hizo huduma kwa kupitia barua pepe kama imewezeshwa.',

    };
    # $$STOP$$
    return;
}

1;
