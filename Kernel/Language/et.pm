# --
# Kernel/Language/et.pm - provides et language translation
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: et.pm,v 1.8 2008-06-26 13:24:02 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --
package Kernel::Language::et;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.8 $) [1];

sub Data {
    my $Self = shift;

    # $$START$$
    # Last translation file sync: Fri May 16 14:08:22 2008

    # possible charsets
    $Self->{Charset} = ['iso-8859-1', 'iso-8859-15', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Jear;)
    $Self->{DateFormat}          = '%D.%M.%Y %T';
    $Self->{DateFormatLong}      = '%T - %D.%M.%Y';
    $Self->{DateFormatShort}     = '%D.%M.%Y';
    $Self->{DateInputFormat}     = '%D.%M.%Y';
    $Self->{DateInputFormatLong} = '%D.%M.%Y - %T';

    $Self->{Translation} = {
        # Template: AAABase
        'Yes' => 'Jah',
        'No' => 'Ei',
        'yes' => 'jah',
        'no' => 'ei',
        'Off' => 'Välja',
        'off' => 'välja',
        'On' => 'Sisse',
        'on' => 'Sisse',
        'top' => 'üles',
        'end' => 'alla',
        'Done' => 'Tehtud',
        'Cancel' => 'Katkesta',
        'Reset' => 'Reset',
        'last' => 'Viimane',
        'before' => 'enne',
        'day' => 'päev',
        'days' => 'päeva',
        'day(s)' => 'päev(a)',
        'hour' => 'tund',
        'hours' => 'tundi',
        'hour(s)' => 'tund(i)',
        'minute' => 'minut',
        'minutes' => 'minutit',
        'minute(s)' => 'minut(it)',
        'month' => 'kuu',
        'months' => 'kuud',
        'month(s)' => 'kuu(d)',
        'week' => 'nädal',
        'week(s)' => 'nädal(at)',
        'year' => 'aasta',
        'years' => 'aastat',
        'year(s)' => 'aasta(t)',
        'second(s)' => 'sekund(it)',
        'seconds' => 'sekundit',
        'second' => 'sekund',
        'wrote' => 'kirjutas',
        'Message' => 'Teade',
        'Error' => 'Viga',
        'Bug Report' => 'Veateade',
        'Attention' => 'Tähelepanu',
        'Warning' => 'Hoiatus',
        'Module' => 'Moodul',
        'Modulefile' => 'Moodulifail',
        'Subfunction' => 'Alamfunktsioon',
        'Line' => 'Rida',
        'Example' => 'Näide',
        'Examples' => 'Näited',
        'valid' => 'kehtiv',
        'invalid' => 'kehtetud',
        '* invalid' => '* kehtetud',
        'invalid-temporarily' => 'ajutiselt kehtetu',
        ' 2 minutes' => ' 2 minutit',
        ' 5 minutes' => ' 5 minutit',
        ' 7 minutes' => ' 7 minutit',
        '10 minutes' => '10 minutit',
        '15 minutes' => '15 minutit',
        'Mr.' => 'Hr.',
        'Mrs.' => 'Pr.',
        'Next' => 'Edasi',
        'Back' => 'Tagasi',
        'Next...' => 'Edasi...',
        '...Back' => '...Tagasi',
        '-none-' => '-puudub-',
        'none' => 'puudub',
        'none!' => 'puudub!',
        'none - answered' => 'puudub - vastatud',
        'please do not edit!' => 'Palun ära muuda!',
        'AddLink' => 'Lisa viide',
        'Link' => 'Viide',
        'Unlink' => '',
        'Linked' => 'Viidatud',
        'Link (Normal)' => 'Viide (tavaline)',
        'Link (Parent)' => 'Viide (ülem)',
        'Link (Child)' => 'Viide (alam)',
        'Normal' => 'Tavaline',
        'Parent' => 'Ülem',
        'Child' => 'Alam',
        'Hit' => 'Hit',
        'Hits' => 'Hits',
        'Text' => 'Tekst',
        'Lite' => 'Kerge',
        'User' => 'Kasutaja',
        'Username' => 'Kasutajanimi',
        'Language' => 'Keel',
        'Languages' => 'Keeled',
        'Password' => 'Parool',
        'Salutation' => 'Salutation',
        'Signature' => 'Signatuur',
        'Customer' => 'Klient',
        'CustomerID' => 'Kliendi nr.',
        'CustomerIDs' => 'Kliendi nr-d',
        'customer' => 'klient',
        'agent' => 'töötaja',
        'system' => 'süsteem',
        'Customer Info' => 'Kliendiinfo',
        'Customer Company' => 'Kliendi ettevõte',
        'Company' => 'Ettevõte',
        'go!' => 'Start!',
        'go' => 'Start',
        'All' => 'Kõik',
        'all' => 'kõik',
        'Sorry' => 'Vabandust',
        'update!' => 'uuenda!',
        'update' => 'uuenda',
        'Update' => 'Uuenda',
        'submit!' => 'salvesta!',
        'submit' => 'salvesta',
        'Submit' => 'Salvesta',
        'change!' => 'muuda!',
        'Change' => 'Muuda',
        'change' => 'muuda',
        'click here' => 'kliki siia',
        'Comment' => 'Kommentaar',
        'Valid' => 'Kehtiv',
        'Invalid Option!' => 'Vale valik!',
        'Invalid time!' => 'Vigane aeg!',
        'Invalid date!' => 'Vigane kuupäev!',
        'Name' => 'Nimi',
        'Group' => 'Grupp',
        'Description' => 'Kirjeldus',
        'description' => 'kirjeldus',
        'Theme' => 'Teema',
        'Created' => 'Tehtud',
        'Created by' => 'Teinud:',
        'Changed' => 'Muudetud',
        'Changed by' => 'Muutnud:',
        'Search' => 'Otsi',
        'and' => 'ja',
        'between' => 'vahel',
        'Fulltext Search' => 'Täistekstiotsing',
        'Data' => 'Andmed',
        'Options' => 'Valikud',
        'Title' => 'Pealkiri',
        'Item' => 'Punkt',
        'Delete' => 'Kustuta',
        'Edit' => 'Muuda',
        'View' => 'Vaata',
        'Number' => 'Number',
        'System' => 'Süsteem',
        'Contact' => 'Kontakt',
        'Contacts' => 'Kontaktid',
        'Export' => 'Eksport',
        'Up' => 'Üles',
        'Down' => 'Alla',
        'Add' => 'Lisa',
        'Category' => 'Kategooria',
        'Viewer' => 'Vaataja',
        'New message' => 'Uus kiri',
        'New message!' => 'Uus kiri!',
        'Please answer this ticket(s) to get back to the normal queue view!' => 'Tagasi järjekorravaatesse saamiseks vasta nendele küsimustele!',
        'You got new message!' => 'Sulle on uus kiri!',
        'You have %s new message(s)!' => 'Sulle on %s uut kirja!',
        'You have %s reminder ticket(s)!' => 'Sulle on  %s meeldetuletust!',
        'The recommended charset for your language is %s!' => 'Teie keele jaoks soovitame kooditabelit %s!',
        'Passwords doesn\'t match! Please try it again!' => 'Paroolid ei ole samad! Palun proovi uuesti!',
        'Password is already in use! Please use an other password!' => 'Parool on juba kasutuses, palun kasuta teist parooli!',
        'Password is already used! Please use an other password!' => 'Parool oli juba kasutuses, palun kasuta teist parooli!',
        'You need to activate %s first to use it!' => 'Enne kui saad kasutada %s, pead selle aktiveerima !',
        'No suggestions' => 'Soovitust ei ole',
        'Word' => 'Sõna',
        'Ignore' => 'Eira',
        'replace with' => 'asenda',
        'There is no account with that login name.' => 'Sellise nimega kontot ei ole.',
        'Login failed! Your username or password was entered incorrectly.' => 'Parool või kasutajanimi on vale.',
        'Please contact your admin' => 'Palun kontatkteeru administraatoriga',
        'Logout successful. Thank you for using OTRS!' => 'Lahkusid OTRSist, täname kasutamise eest!',
        'Invalid SessionID!' => 'Vale SessionID!',
        'Feature not active!' => 'Omadus ei ole aktiveeritud!',
        'Login is needed!' => 'Esmalt logi sisse!',
        'Password is needed!' => 'Sisesta parool!',
        'License' => 'Litsens',
        'Take this Customer' => 'Kasuta seda klienti',
        'Take this User' => 'Kasuta seda kasutajat',
        'possible' => 'võimalik',
        'reject' => 'lükka tagasi',
        'reverse' => 'pööra ümber',
        'Facility' => 'Facility',
        'Timeover' => 'Aeg läbi',
        'Pending till' => 'Ootel kuni',
        'Don\'t work with UserID 1 (System account)! Create new users!' => 'Ära tööta kasutades UserID 1 (System Account)! Tee uus kasutaja!',
        'Dispatching by email To: field.' => 'Jaotamine To: päiserea järgi.',
        'Dispatching by selected Queue.' => 'Jaotamine valitud järjekorra järgi.',
        'No entry found!' => 'Ei leidnud kirjet!',
        'Session has timed out. Please log in again.' => 'Sesesioon aegus. Palun logi uuesti sisse.',
        'No Permission!' => 'Õigust ei ole!',
        'To: (%s) replaced with database email!' => 'Saaja: (%s) asendatud aadressiga andmebaasist!',
        'Cc: (%s) added database email!' => 'Cc: (%s) lisasime aadresssi andmebaasist!',
        '(Click here to add)' => '(Lisamiseks kliki siia)',
        'Preview' => 'Eelvaade',
        'Package not correctly deployed! You should reinstall the Package again!' => 'Moodul ei toimi korrektselt! Peaksite mooduli uuesti paigaldama',
        'Added User "%s"' => 'Kasutaja "%s" lisatud.',
        'Contract' => 'Leping',
        'Online Customer: %s' => 'Online klient: %s',
        'Online Agent: %s' => 'Online töötaja: %s',
        'Calendar' => 'Kalender',
        'File' => 'Fail',
        'Filename' => 'Failinimi',
        'Type' => 'Tüüp',
        'Size' => 'Suurus',
        'Upload' => 'Üles laadimine',
        'Directory' => 'Kataloog',
        'Signed' => 'Alla kirjutanud',
        'Sign' => 'Kirjuta alla',
        'Crypted' => 'Krüpteeritud',
        'Crypt' => 'Krüpteeri',
        'Office' => 'Kontor',
        'Phone' => 'Telefon',
        'Fax' => 'Fax',
        'Mobile' => 'Mobiile',
        'Zip' => 'Postiindeks',
        'City' => 'Linn',
        'Street' => '',
        'Country' => 'Riik',
        'installed' => 'paigaldatud',
        'uninstalled' => 'eemaldatud',
        'Security Note: You should activate %s because application is already running!' => 'Turvateadaanne: Peaksite aktiveerima %s kuna rakendus juba töötab!',
        'Unable to parse Online Repository index document!' => 'Ei saa töödelda võrgurepositooriumi indeksit!',
        'No Packages for requested Framework in this Online Repository, but Packages for other Frameworks!' => 'No Packages for requested Framework in this Online Repository, but Packages for other Frameworks!',
        'No Packages or no new Packages in selected Online Repository!' => 'No Packages or no new Packages in selected Online Repository!',
        'printed at' => 'trükitud',
        'Dear Mr. %s,' => '',
        'Dear Mrs. %s,' => '',
        'Dear %s,' => '',
        'Hello %s,' => '',
        'This account exists.' => 'See konto on juba olemas.',
        'New account created. Sent Login-Account to %s.' => 'Uus konto loodud. Saatsin andmed aadressile %s.',
        'Please press Back and try again.' => 'Palun vajuta tagasi-nuppu ja proovi uuesti.',
        'Sent password token to: %s' => 'Saada parool saajale: %s .',
        'Sent new password to: %s' => 'Saada parool kasutajale:.',
        'Invalid Token!' => 'Vigane!',

        # Template: AAAMonth
        'Jan' => 'Jaan',
        'Feb' => 'Veeb',
        'Mar' => 'Mär',
        'Apr' => 'Apr',
        'May' => 'Mai',
        'Jun' => 'Jun',
        'Jul' => 'Jul',
        'Aug' => 'Aug',
        'Sep' => 'Sept',
        'Oct' => 'Okt',
        'Nov' => 'Nov',
        'Dec' => 'Dets',
        'January' => 'Jaanuar',
        'February' => 'Veebruar',
        'March' => 'Märts',
        'April' => 'Aprill',
        'June' => 'Juuni',
        'July' => 'Juuli',
        'August' => 'August',
        'September' => 'September',
        'October' => 'Oktoober',
        'November' => 'November',
        'December' => 'Detsember',

        # Template: AAANavBar
        'Admin-Area' => 'Haldusala',
        'Agent-Area' => 'Töötaja-ala',
        'Ticket-Area' => 'Intsidendiala',
        'Logout' => 'Lahku',
        'Agent Preferences' => 'Töötaja eelistused',
        'Preferences' => 'Eelistused',
        'Agent Mailbox' => 'Töötaja kirjakast',
        'Stats' => 'Statistika',
        'Stats-Area' => 'Statistika',
        'Admin' => 'Haldus',
        'Customer Users' => 'Kliendikasutajad',
        'Customer Users <-> Groups' => 'Kliendikasutajad <-> grupid',
        'Users <-> Groups' => 'Kasutajad <-> grupid',
        'Roles' => 'Rollid',
        'Roles <-> Users' => 'Rollid <-> kasutajad',
        'Roles <-> Groups' => 'Rollid <-> grupid',
        'Salutations' => 'Salutations',
        'Signatures' => 'Allkirjad',
        'Email Addresses' => 'E-posti aadresid',
        'Notifications' => 'Teavitused',
        'Category Tree' => 'Kategooriapuu',
        'Admin Notification' => 'Haldaja teavitused',

        # Template: AAAPreferences
        'Preferences updated successfully!' => 'Eelistuste uuendamine õnnestus!',
        'Mail Management' => 'E-posti haldus',
        'Frontend' => 'Väljanägemine',
        'Other Options' => 'Muud võimalused',
        'Change Password' => 'Muuda parooli',
        'New password' => 'Uus parool',
        'New password again' => 'Uus parool (veelkord)',
        'Select your QueueView refresh time.' => 'Vali oma järjekorravaate värskendamiste vahe.',
        'Select your frontend language.' => 'Vali keel.',
        'Select your frontend Charset.' => 'Vali koodileht.',
        'Select your frontend Theme.' => 'Vali teema.',
        'Select your frontend QueueView.' => 'Vali järjekorravaade.',
        'Spelling Dictionary' => 'Sõnastik',
        'Select your default spelling dictionary.' => 'Vali vaikimisi sõnastik.',
        'Max. shown Tickets a page in Overview.' => 'Ülevaates korraga nähtavate intsidentide ülempiir.',
        'Can\'t update password, passwords doesn\'t match! Please try it again!' => 'Ei saa uuendada parooli, paroolid ei ole samad. Palun proovi uuesti!',
        'Can\'t update password, invalid characters!' => 'Ei saa uuendada parooli, paroolis on keelatud märke.',
        'Can\'t update password, need min. 8 characters!' => 'Ei saa uuendada parooli, paroolis peab olema vähemalt 8 märki.',
        'Can\'t update password, need 2 lower and 2 upper characters!' => 'Ei saa uuendada parooli, paroolis peab olema vähemalt 2 väiketähte ja 2 suurtähte.',
        'Can\'t update password, need min. 1 digit!' => 'Ei saa uuendada parooli, paroolis peab olema vähemalt 1 number!',
        'Can\'t update password, need min. 2 characters!' => 'Ei saa uuendada parooli, paroolis peab olema vähemalt 2 tähte!',

        # Template: AAAStats
        'Stat' => 'Statistika',
        'Please fill out the required fields!' => 'Palun täida nõutud väljad!',
        'Please select a file!' => 'Vali fail!',
        'Please select an object!' => 'Vali objekt!',
        'Please select a graph size!' => 'Vali graafiku suurus!',
        'Please select one element for the X-axis!' => 'Palun vali üks element X-teljele!',
        'You have to select two or more attributes from the select field!' => 'Pead valima vähemalt 2 atribuuti!',
        'Please select only one element or turn off the button \'Fixed\' where the select field is marked!' => 'Palun vali vähemalt 1 element või lülita välja nupp \'Fixed\'!',
        'If you use a checkbox you have to select some attributes of the select field!' => 'Kui kasutad checkboxi pead valima mõne atribuudi ka valikuväljalt!',
        'Please insert a value in the selected input field or turn off the \'Fixed\' checkbox!' => 'Palun sisesta väärtus valitud väljale või lülita välja nupp \'Fixed\'!',
        'The selected end time is before the start time!' => 'Lõppaeg on enne algusaega!',
        'You have to select one or more attributes from the select field!' => 'Pead valima vähemalt ühe atribuudi!',
        'The selected Date isn\'t valid!' => 'Valitud kuupäev ei ole korrektne!',
        'Please select only one or two elements via the checkbox!' => 'Palun vali 1 kuni 2 elementi checkboxiga!',
        'If you use a time scale element you can only select one element!' => 'If you use a time scale element you can only select one element!!',
        'You have an error in your time selection!' => 'Valitud aeg on vigane!',
        'Your reporting time interval is too small, please use a larger time scale!' => 'Raporti ajavahemik on liiga väike, palun kasuta suuremat!',
        'The selected start time is before the allowed start time!' => 'Valitud algusaeg on enne lubatud algusaega!',
        'The selected end time is after the allowed end time!' => ' Valitud lõppaeg on peale lubatud lõppaega!',
        'The selected time period is larger than the allowed time period!' => 'Valitud ajavahemik on pikem kui lubatud!',
        'Common Specification' => 'Common Specification',
        'Xaxis' => 'X-telg',
        'Value Series' => 'Väärtused',
        'Restrictions' => 'Piirangud',
        'graph-lines' => 'Joondiagramm',
        'graph-bars' => 'Tulpdiagramm',
        'graph-hbars' => 'Tulpdiagramm (horisontaalne)',
        'graph-points' => 'Punktdiagramm',
        'graph-lines-points' => 'Joondiagramm punktidega',
        'graph-area' => 'Aladiagramm',
        'graph-pie' => 'Sektordiagramm',
        'extended' => 'laiendatud',
        'Agent/Owner' => 'Töötaja/Omanik',
        'Created by Agent/Owner' => 'Tegi Töötaja/Omanik',
        'Created Priority' => 'Loomise prioriteet',
        'Created State' => 'Loomise olek',
        'Create Time' => 'Loomisaeg',
        'CustomerUserLogin' => 'Kliendilogin',
        'Close Time' => 'Sulgemisaeg',

        # Template: AAATicket
        'Lock' => 'Lukusta',
        'Unlock' => 'Eemalda lukk',
        'History' => 'Ajalugu',
        'Zoom' => 'Lähemalt',
        'Age' => 'Vanus',
        'Bounce' => 'Põrgata',
        'Forward' => 'Edasta',
        'From' => 'Kellelt',
        'To' => 'Kellele',
        'Cc' => 'Koopia',
        'Bcc' => 'Pimekoopia',
        'Subject' => 'Teema',
        'Move' => 'Liiguta',
        'Queue' => 'Järjekord',
        'Priority' => 'Prioriteet',
        'Priority Update' => '',
        'State' => 'Olek',
        'Compose' => 'Koosta kiri',
        'Pending' => 'Ootel',
        'Owner' => 'Omanik',
        'Owner Update' => 'Muuda omanikku',
        'Responsible' => 'Vastutaja',
        'Responsible Update' => 'Muuda vastutajat',
        'Sender' => 'Saatja',
        'Article' => 'Intsident',
        'Ticket' => 'Intsidendid',
        'Createtime' => 'Loomisaeg',
        'plain' => 'lähtetekst',
        'Email' => 'Epost',
        'email' => 'epost',
        'Close' => 'Sulge',
        'Action' => 'Tegevus',
        'Attachment' => 'Manus',
        'Attachments' => 'Manused',
        'This message was written in a character set other than your own.' => 'Kiri on teises kooditabelis kui see, mis praegu kastusel on.',
        'If it is not displayed correctly,' => 'Kui kirja ei kuvata korrektselt,',
        'This is a' => 'See on',
        'to open it in a new window.' => 'uues aknas avamiseks.',
        'This is a HTML email. Click here to show it.' => 'See kiri on HTML-formaadis. Kliki siia selle kirja nägemiseks.',
        'Free Fields' => 'Määramata väljad',
        'Merge' => 'Ühenda',
        'merged' => 'ühendatud',
        'closed successful' => 'edukalt tehtud',
        'closed unsuccessful' => 'tehtud ebaedukalt',
        'new' => 'uus',
        'open' => 'avatud',
        'closed' => 'suletud',
        'removed' => 'kustutatud',
        'pending reminder' => 'ootab meeldetuletust',
        'pending auto' => 'sulgub ise',
        'pending auto close+' => 'sulgub ise edukalt',
        'pending auto close-' => 'sulgub ise ebaedukalt',
        'email-external' => 'sisemine ekiri',
        'email-internal' => 'avalik ekiri',
        'note-external' => 'sisemine märkus',
        'note-internal' => 'avalik märkus',
        'note-report' => 'märkus raportisse',
        'phone' => 'telefon',
        'sms' => 'sms',
        'webrequest' => 'veebipäring',
        'lock' => 'lukus',
        'unlock' => 'lahti',
        'very low' => 'väga madal',
        'low' => 'madal',
        'normal' => 'tavaline',
        'high' => 'kõrge',
        'very high' => 'väga kõrge',
        '1 very low' => '1 väga madal',
        '2 low' => '2 madal',
        '3 normal' => '3 tavaline',
        '4 high' => '4 kõrge',
        '5 very high' => '5 väga kõrge',
        'Ticket "%s" created!' => 'Tehtud intsident "%s"!',
        'Ticket Number' => 'Intsidendi number',
        'Ticket Object' => 'Intsidendi objekt',
        'No such Ticket Number "%s"! Can\'t link it!' => 'Sellise numbriga (%s) ei ole! Ei saa sellele viidata!',
        'Don\'t show closed Tickets' => 'Mitte näidata suletud intsidente',
        'Show closed Tickets' => 'Näidata suletud intsidente',
        'New Article' => 'Uus intsident',
        'Email-Ticket' => 'Epostist',
        'Create new Email Ticket' => 'Uus e-posti intsident',
        'Phone-Ticket' => 'Telefonist',
        'Search Tickets' => 'Otsi intsidente',
        'Edit Customer Users' => 'Klientkasutajate muutmine',
        'Edit Customer Company' => '',
        'Bulk-Action' => 'Hulgitegevus',
        'Bulk Actions on Tickets' => 'Hulgitegevus intsidentidel',
        'Send Email and create a new Ticket' => 'Saada e-kiri ja loo uus intsident',
        'Create new Email Ticket and send this out (Outbound)' => 'Tee uus intsident ja saada kiri (väljaminev) ',
        'Create new Phone Ticket (Inbound)' => 'Tee uus intsident (telefonist, sissetulev)',
        'Overview of all open Tickets' => 'Ülevaade kõikidest avatud intsidentidest',
        'Locked Tickets' => 'Lukustatud intsidendid',
        'Watched Tickets' => 'Vaatlejaga intsidendid',
        'Watched' => 'Vaadeldav',
        'Subscribe' => 'Telli',
        'Unsubscribe' => 'Katkesta tellimus',
        'Lock it to work on it!' => 'Lukusta intsident tööks!',
        'Unlock to give it back to the queue!' => 'Intsidendi naamiseks järjekorda eemalda lukk!',
        'Shows the ticket history!' => 'Näitab intsidendi ajalugu!',
        'Print this ticket!' => 'Trüki intsident!',
        'Change the ticket priority!' => 'Muuda intsidendi prioriteeti',
        'Change the ticket free fields!' => 'Muuda intsidendi muid välju',
        'Link this ticket to an other objects!' => 'Seo see intsident teiste objektidega!',
        'Change the ticket owner!' => 'Muuda intsidendi omanikku!',
        'Change the ticket customer!' => 'Muuda intsidendi klienti!',
        'Add a note to this ticket!' => 'Lisa intsidendile märkus!',
        'Merge this ticket!' => 'Ühenda see intsident!',
        'Set this ticket to pending!' => 'Märgi see intsident ootel olevaks!',
        'Close this ticket!' => 'Sulge see intsident!',
        'Look into a ticket!' => 'Vaata intsidenti!',
        'Delete this ticket!' => 'Kustuta intsident!',
        'Mark as Spam!' => 'Märgi spämmiks!',
        'My Queues' => 'Minu järjekorrad',
        'Shown Tickets' => 'Nähtavad intsidendid',
        'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' => 'Teie kiri intsidendinumbriga "<OTRS_TICKET>" ühendati intsidendiga "<OTRS_MERGE_TO_TICKET>".',
        'Ticket %s: first response time is over (%s)!' => 'Intsident %s: reaktsiooniaeg on läbi (%s)!',
        'Ticket %s: first response time will be over in %s!' => 'Intsident %s: reaktsiooniaeg saab läbi %s!',
        'Ticket %s: update time is over (%s)!' => 'Intsident %s: muutmiseks määratud aeg on läbi (%s)!',
        'Ticket %s: update time will be over in %s!' => 'Intsident %s: muutmiseks määratud aeg saab läbi %s!',
        'Ticket %s: solution time is over (%s)!' => 'Intsident %s: Lahendusaeg on läbi (%s)!',
        'Ticket %s: solution time will be over in %s!' => 'Intsident %s: Lahendusaeg saab läbi %s!',
        'There are more escalated tickets!' => 'On veel eskaleeritud intsidente!',
        'New ticket notification' => 'Teavitus uuest intsidendist',
        'Send me a notification if there is a new ticket in "My Queues".' => 'Saada mulle teavitus, kui "Minu järjekordades" on uusi intsidente.',
        'Follow up notification' => 'Teavitus vastusest',
        'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.' => 'Saada mulle teavitus, kui klient vastab ja mina olen intsidendi omanik.',
        'Ticket lock timeout notification' => 'Intsidendi luku aegumise teavitus',
        'Send me a notification if a ticket is unlocked by the system.' => 'Saada mulle teavitus, kui intsidendilt eemaldatakse automaatselt lukk.',
        'Move notification' => 'Järjekorravahetuse teavitus',
        'Send me a notification if a ticket is moved into one of "My Queues".' => 'Saada mulle teavitus, kui intsident on tõstetud mõnda järjekorda "Minu järjekordades".',
        'Your queue selection of your favourite queues. You also get notified about those queues via email if enabled.' => 'Sinu valik oma vajalikumatest järjekordadest. Saad ka teavituse e-posti teel, kui see on lubatud.',
        'Custom Queue' => 'Kohandatud järjekord',
        'QueueView refresh time' => 'Järjekorravaate värskendusaeg',
        'Screen after new ticket' => 'Järgmine lehekülg peale intsidendi sisestamist',
        'Select your screen after creating a new ticket.' => 'Vali lehekülg mis on näha peale uue intsidendi loomist.',
        'Closed Tickets' => 'Sultetud intsidendid',
        'Show closed tickets.' => 'Näita suletud intsidente.',
        'Max. shown Tickets a page in QueueView.' => 'Mitut intsidendti näidatakse järjekorras ühel lehel.',
        'CompanyTickets' => 'Ettevõte intsidendid',
        'MyTickets' => 'Minu intsidendid',
        'New Ticket' => 'Uus intsident',
        'Create new Ticket' => 'Tekita uus intsident',
        'Customer called' => 'Klient helistas',
        'phone call' => 'telefonikõne',
        'Responses' => 'Vastused',
        'Responses <-> Queue' => 'Vastused <-> järjekorrad',
        'Auto Responses' => 'Automaatvastused',
        'Auto Responses <-> Queue' => 'Automaatvastused <-> järjekorrad',
        'Attachments <-> Responses' => 'Manused <-> vastused',
        'History::Move' => 'Intsident viidi järjekorrast "%s" (%s) järjekorda "%s" (%s).',
        'History::TypeUpdate' => 'Tüüpi muudeti "%s" (ID=%s).',
        'History::ServiceUpdate' => 'Teenust muudeti "%s" (ID=%s).',
        'History::SLAUpdate' => 'SLA-d muudeti "%s" (ID=%s).',
        'History::NewTicket' => 'Uus intsident [%s] (Q=%s;P=%s;S=%s).',
        'History::FollowUp' => 'Vastus intsidendile [%s]. %s',
        'History::SendAutoReject' => 'Automaatne tagasilükkamine "%s".',
        'History::SendAutoReply' => 'Automaatvastus "%s".',
        'History::SendAutoFollowUp' => 'Automaatedastus "%s".',
        'History::Forward' => 'Edastatud "%s".',
        'History::Bounce' => 'Põrgatatud "%s".',
        'History::SendAnswer' => 'Vastatud epostiga "%s".',
        'History::SendAgentNotification' => '"%s"-teavitus saadeti "%s".',
        'History::SendCustomerNotification' => 'Teavitus saadeti "%s".',
        'History::EmailAgent' => 'Kliendile saadeti ekiri.',
        'History::EmailCustomer' => 'Epostist lisatud. %s',
        'History::PhoneCallAgent' => 'Kliendile helistati.',
        'History::PhoneCallCustomer' => 'Klient helistas.',
        'History::AddNote' => 'Lisatud märkus (%s)',
        'History::Lock' => 'Intsident lukustati.',
        'History::Unlock' => 'Intsidendi lukk eemaldati.',
        'History::TimeAccounting' => 'Arvestati %s ajaühikut. Kokku %s ajaühikut.',
        'History::Remove' => '%s',
        'History::CustomerUpdate' => 'Uuendatud: %s',
        'History::PriorityUpdate' => 'Muudetud prioriteeti: algselt "%s" (%s), pärast "%s" (%s).',
        'History::OwnerUpdate' => 'Uus omanik on "%s" (ID=%s).',
        'History::LoopProtection' => 'Vältimaks korduste tekkimist ei saadetu teavitust "%s".',
        'History::Misc' => '%s',
        'History::SetPendingTime' => 'Uuendati: %s',
        'History::StateUpdate' => 'Vana: "%s" Uus: "%s"',
        'History::TicketFreeTextUpdate' => 'Uuendatud: %s=%s;%s=%s;',
        'History::WebRequestCustomer' => 'Klient ühendus veebiliidesest.',
        'History::TicketLinkAdd' => 'Lisatud viide intsidendile "%s".',
        'History::TicketLinkDelete' => 'Eemaldatud viide intsidendile "%s".',
        'History::Subscribe' => 'Added subscription for user "%s".',
        'History::Unsubscribe' => 'Removed subscription for user "%s".',

        # Template: AAAWeekDay
        'Sun' => 'P',
        'Mon' => 'E',
        'Tue' => 'T',
        'Wed' => 'K',
        'Thu' => 'N',
        'Fri' => 'R',
        'Sat' => 'L',

        # Template: AdminAttachmentForm
        'Attachment Management' => 'Manuste haldus',

        # Template: AdminAutoResponseForm
        'Auto Response Management' => 'Automaatvastuste haldus',
        'Response' => 'Vastus',
        'Auto Response From' => 'Automaatvastuse saatja',
        'Note' => 'Märkus',
        'Useable options' => 'Kasutatavad väljad',
        'To get the first 20 character of the subject.' => 'Esimesed 20 märki teemareast.',
        'To get the first 5 lines of the email.' => 'Kirja esimesed 5 rida. ',
        'To get the realname of the sender (if given).' => 'Saatja nimi (kui on)',
        'To get the article attribute (e. g. (<OTRS_CUSTOMER_From>, <OTRS_CUSTOMER_To>, <OTRS_CUSTOMER_Cc>, <OTRS_CUSTOMER_Subject> and <OTRS_CUSTOMER_Body>).' => 'Kirja atribuudid ((<OTRS_CUSTOMER_From>, <OTRS_CUSTOMER_To>, <OTRS_CUSTOMER_Cc>, <OTRS_CUSTOMER_Subject> ja  <OTRS_CUSTOMER_Body>).',
        'Options of the current customer user data (e. g. <OTRS_CUSTOMER_DATA_UserFirstname>).' => 'Kliendi andmed (näiteks <OTRS_CUSTOMER_DATA_UserFirstname>)',
        'Ticket owner options (e. g. <OTRS_OWNER_UserFirstname>).' => 'Intsidendi omaniku andmed (näiteks <OTRS_OWNER_UserFirstname>).',
        'Ticket responsible options (e. g. <OTRS_RESPONSIBLE_UserFirstname>).' => 'Vastutava isiku andmed (näiteks <OTRS_RESPONSIBLE_UserFirstname>).',
        'Options of the current user who requested this action (e. g. <OTRS_CURRENT_UserFirstname>).' => 'Kasutaja andmed, kelle tegevusele vastavalt teavitatakse (näiteks. <OTRS_CURRENT_UserFirstname).',
        'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>).' => 'Intsidendi andmed (näiteks <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>).',
        'Config options (e. g. <OTRS_CONFIG_HttpType>).' => 'Andmed seadistuse kohta (näiteks <OTRS_CONFIG_HttpType).',

        # Template: AdminCustomerCompanyForm
        'Customer Company Management' => 'Kliendiettevõtte haldus',
        'Search for' => 'Otsi',
        'Add Customer Company' => 'Lisa kliendiettevõte',
        'Add a new Customer Company.' => 'Lisa uus kliendiettevõte.',
        'List' => 'Nimekiri',
        'This values are required.' => 'Need väärtused on nõutud.',
        'This values are read only.' => 'Neid väärtusi ei saa muuta.',

        # Template: AdminCustomerUserForm
        'Customer User Management' => 'Kliendikasutajate haldus',
        'Add Customer User' => 'Lisa kliendikasutaja',
        'Source' => 'Allikas',
        'Create' => 'Tekita',
        'Customer user will be needed to have a customer history and to login via customer panel.' => 'Kliendikasutajad peavad olema kasutanud süsteemi ja sisse logima kliendiliidese kaudu.',

        # Template: AdminCustomerUserGroupChangeForm
        'Customer Users <-> Groups Management' => 'Kliendikasutajate <-> Gruppide haldus',
        'Change %s settings' => 'Muuda %s seadeid',
        'Select the user:group permissions.' => 'Vali kasutaja/grupi õigused.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the user).' => 'Kui midagi ei ole valitud, ei ole selle grupi kasutajalel nendele intsidentile mingeid õigusi.',
        'Permission' => 'Õigus',
        'ro' => 'ro',
        'Read only access to the ticket in this group/queue.' => 'Selle grupi/järjekorra intsidentidele ainult lugemise õigused.',
        'rw' => 'rw',
        'Full read and write access to the tickets in this group/queue.' => 'Kõik lugemise ja kirjutamise õigused selles grupis/järjekorras.',

        # Template: AdminCustomerUserGroupForm

        # Template: AdminCustomerUserService
        'Customer Users <-> Services Management' => 'Kliendikasutajad <-> teenused haldus',
        'CustomerUser' => 'Kliendikasutaja',
        'Service' => 'Teenus',
        'Edit default services.' => 'Muuda vaiketeenusedi.',
        'Search Result' => 'Otsingu tulemus',
        'Allocate services to CustomerUser' => 'Anna teenused kliendikasutajale',
        'Active' => 'Aktiivne',
        'Allocate CustomerUser to service' => 'Anna kliendikasutaja teenusele',

        # Template: AdminEmail
        'Message sent to' => 'Kiri saadetud',
        'Recipents' => 'Saajad',
        'Body' => 'Text',
        'Send' => 'Saada',

        # Template: AdminGenericAgent
        'GenericAgent' => 'GenericAgent',
        'Job-List' => 'Tööde nimekiri',
        'Last run' => 'Viimati käivitud',
        'Run Now!' => 'Käivita nüüd!',
        'x' => 'x',
        'Save Job as?' => 'Salvesta töö kui?',
        'Is Job Valid?' => 'Kas töö on kehtiv?',
        'Is Job Valid' => 'Kas töö on kehtiv',
        'Schedule' => 'Graafik',
        'Fulltext-Search in Article (e. g. "Mar*in" or "Baue*")' => 'Täistekstiotsing kirjadest (näiteks "Mar*in" või "Andr*")',
        '(e. g. 10*5155 or 105658*)' => 'näiteks 10*5144 või 105658*',
        '(e. g. 234321)' => 'näiteks 234321',
        'Customer User Login' => 'Kliendi kasutajanimi',
        '(e. g. U5150)' => 'näiteks U5150',
        'SLA' => 'SLA',
        'Agent' => 'Töötaja',
        'Ticket Lock' => 'Intsidendi lukk',
        'TicketFreeFields' => 'Intsidendi muud väljad',
        'Create Times' => 'Tekitamisaeg',
        'No create time settings.' => 'Tekitasaja seadeid ei ole',
        'Ticket created' => 'Intsident loodud',
        'Ticket created between' => 'Intsident loodud vahemikus',
        'Close Times' => '',
        'No close time settings.' => '',
        'Ticket closed' => '',
        'Ticket closed between' => '',
        'Pending Times' => 'Ooteajad',
        'No pending time settings.' => 'Ooteaegade seadeid ei ole',
        'Ticket pending time reached' => 'Intsidendi ooteaeg on kätte jõudnud',
        'Ticket pending time reached between' => 'Intsidendi ooteaeg jõudis kätte vahemikus',
        'New Service' => '',
        'New SLA' => '',
        'New Priority' => 'Uus prioriteet',
        'New Queue' => 'Uus järjekord',
        'New State' => 'Uus oleks',
        'New Agent' => 'Uus töötaja',
        'New Owner' => 'Uus omanik',
        'New Customer' => 'Uus klient',
        'New Ticket Lock' => 'Uus intsidendi lukk',
        'New Type' => '',
        'New Title' => '',
        'New Type' => '',
        'New TicketFreeFields' => 'Uued intsidendi väljad',
        'Add Note' => 'Lisa märkus',
        'CMD' => 'CMD',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' => 'See käsk käivitatakse. ARG[0] on intsidendi number, ARG[1] on intsidendi ID..',
        'Delete tickets' => 'Kustuta intsidendid',
        'Warning! This tickets will be removed from the database! This tickets are lost!' => 'Tähelepanu! Need intsidendid kustutatkse andmebaasist! Kõik andmed kaovad!',
        'Send Notification' => 'Saatmise teavitus',
        'Param 1' => 'Param 1',
        'Param 2' => 'Param 2',
        'Param 3' => 'Param 3',
        'Param 4' => 'Param 4',
        'Param 5' => 'Param 5',
        'Param 6' => 'Param 6',
        'Send no notifications' => 'Ära saada teavitusi',
        'Yes means, send no agent and customer notifications on changes.' => 'Jah tähendab, et töötajatele ja kasutajatele ei saadeta teavitusi.',
        'No means, send agent and customer notifications on changes.' => 'Ei tähendab, et klientidele ja töötajatele saadetakse infot muudatustest.',
        'Save' => 'Salvesta',
        '%s Tickets affected! Do you really want to use this job?' => 'Muudab %s intisdenti! Oled kindel et soovid seda tööd kasutada?',
        '"}' => '',

        # Template: AdminGroupForm
        'Group Management' => 'Gruppide haldus',
        'Add Group' => 'Lisa grupp',
        'Add a new Group.' => 'Lisa uus grupp.',
        'The admin group is to get in the admin area and the stats group to get stats area.' => 'Grupp "admin" on vajalik otrs halduseks ja grupp "stats" statistika tegemiseks.',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).' => 'Tee uued grupid haldamaks õigusi erinevatel töötajate gruppide (näiteks haldusosakond, müügiosakond ..)',
        'It\'s useful for ASP solutions.' => 'Kasulik ASP-lahendustes.',

        # Template: AdminLog
        'System Log' => 'Süsteem logi',
        'Time' => 'Aeg',

        # Template: AdminMailAccount
        'Mail Account Management' => '',
        'Host' => 'Server',
        'Trusted' => 'Usaldatud',
        'Dispatching' => 'Jaotamine',
        'All incoming emails with one account will be dispatched in the selected queue!' => 'Kõik sissetulevad kirjad ühelt kontolt jaotatakse valitud järjekorda!',
        'If your account is trusted, the already existing X-OTRS header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' => 'Kui konto on usaldatud, siis usutakse kirjade olemasolevaid X-OTRS päiseid(prioriteedid, ...). Postmasteri filtreid rakendatakse niikuinii.',

        # Template: AdminNavigationBar
        'Users' => 'Kasutajad',
        'Groups' => 'Grupid',
        'Misc' => 'Muud',

        # Template: AdminNotificationForm
        'Notification Management' => 'Teavituste haldus',
        'Notification' => 'Teavitus',
        'Notifications are sent to an agent or a customer.' => 'Teavitused saadetakse kliendile või töötajale.',

        # Template: AdminPackageManager
        'Package Manager' => 'Paketihaldus',
        'Uninstall' => 'Eemalda',
        'Version' => 'Versioon',
        'Do you really want to uninstall this package?' => 'Kas tõesti eemaldada see pakett?',
        'Reinstall' => 'Paigalda uuesti',
        'Do you really want to reinstall this package (all manual changes get lost)?' => 'Oled kindel, et soovid paketti uuesti paigaldada (kõik käsitsi tehtud muudatused kaovad)?',
        'Continue' => 'Jätka',
        'Install' => 'Paigalda',
        'Package' => 'Paketr',
        'Online Repository' => 'Võrguallikas',
        'Vendor' => 'Tootja',
        'Upgrade' => 'Uuenda',
        'Local Repository' => 'Kohalik allikas',
        'Status' => 'Olek',
        'Overview' => 'Ülevaade',
        'Download' => 'Lae alla',
        'Rebuild' => 'Ehita uuesti',
        'ChangeLog' => 'Muudatused',
        'Date' => 'Kuupäev',
        'Filelist' => 'Failid',
        'Download file from package!' => 'Lae alla fail paketist!',
        'Required' => 'Vajalik',
        'PrimaryKey' => 'PrimaryKey',
        'AutoIncrement' => 'AutoIncrement',
        'SQL' => 'SQL',
        'Diff' => 'Diff',

        # Template: AdminPerformanceLog
        'Performance Log' => 'Jõudluse logi',
        'This feature is enabled!' => 'Jõudluse logimine on sisse lülitatud!',
        'Just use this feature if you want to log each request.' => 'Kasuta jõudluseandmete logimist siis, kui soovid logida iga päringut.',
        'Of couse this feature will take some system performance it self!' => 'See kahandab süsteemi üldist jõudlust.',
        'Disable it here!' => 'Keela!',
        'This feature is disabled!' => 'Jõudluse logimine on välja lülitatud!',
        'Enable it here!' => 'Luba!',
        'Logfile too large!' => 'Logifail on liiga suur!',
        'Logfile too large, you need to reset it!' => 'Logifail on liiga suur, see tuleb tühjendada!',
        'Range' => 'Vahemik',
        'Interface' => 'Liides',
        'Requests' => 'Päringuid',
        'Min Response' => 'Vähim aeg vastuseni',
        'Max Response' => 'Suurim aeg vastuseni',
        'Average Response' => 'Keskmine aeg vastuseni',
        'Period' => '',
        'Min' => '',
        'Max' => '',
        'Average' => '',

        # Template: AdminPGPForm
        'PGP Management' => 'PGP haldus',
        'Result' => 'Vastus',
        'Identifier' => 'Identifikaator',
        'Bit' => 'Bit',
        'Key' => 'Võti',
        'Fingerprint' => 'Sõrmejälg',
        'Expires' => 'Aegub',
        'In this way you can directly edit the keyring configured in SysConfig.' => 'Nii saad otse muuta SysConfig-is seadistatud võtmeid.',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => 'PostMasteri filtrite haldus',
        'Filtername' => 'Filtri nimi',
        'Match' => 'Vastavus',
        'Header' => 'Päis',
        'Value' => 'Väärtus',
        'Set' => 'Sea',
        'Do dispatch or filter incoming emails based on email X-Headers! RegExp is also possible.' => 'Filtreeri või jaota sissetulevaid kirju vastavalt kirja X-päistele. Regulaaravaldisi saab ka kasutada.',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' => 'Kui soovid kontrollida ainult e-postiaadressi, kasuta EMAILADDRESS:info@example.com From, To või CC päistel.',
        'If you use RegExp, you also can use the matched value in () as [***] in \'Set\'.' => 'Kui kasutad regulaaravaldist saab kasutada ka leitud () väärtusi kui [***] "Sea" väljal .',

        # Template: AdminQueueAutoResponseForm
        'Queue <-> Auto Responses Management' => 'Järjekord <-> automaatvastus haldus',

        # Template: AdminQueueForm
        'Queue Management' => 'Järjekordade haldus',
        'Sub-Queue of' => 'Alam järjekorrale',
        'Unlock timeout' => 'Luku aegumine',
        '0 = no unlock' => '0 = Lukk ei aegu',
        'Only business hours are counted.' => '',
        'Escalation - First Response Time' => 'Eskaleerimine - esimese vastuse aeg',
        '0 = no escalation' => '0 = ei eskaleerita',
        'Only business hours are counted.' => '',
        'Notify by' => '',
        'Escalation - Update Time' => 'Eskaleerimine - muutmise aeg',
        'Notify by' => '',
        'Escalation - Solution Time' => 'Eskaleerimine - lahendusaeg',
        'Follow up Option' => 'Klient saadab täiendusi',
        'Ticket lock after a follow up' => 'Lukk peale klienditäiendusi',
        'Systemaddress' => 'Systemaddress',
        'Customer Move Notify' => 'Kliendi teavitamine liigutamisest',
        'Customer State Notify' => 'Kliendi teavitamine olekutest',
        'Customer Owner Notify' => 'Klienti teavitamine töötajast',
        'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.' => 'Kui töötaja lukustab intsidendi ja ei vasta märgitud aja jooksul, siis indtsidendi lukk eemaldatakse automaatselt. Nii on intsident taas saadaval teistele töötajatele.',
        'Escalation time' => 'Eskaleerimisaeg',
        'If a ticket will not be answered in this time, just only this ticket will be shown.' => 'Kui intsidendile ei ole selle aja jooksul vastatud, näidatakse ainult seda intsidenti.',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.' => 'Kui intsident on suletud ja klient saadab täiendusi, siis intsident on jätkuvalt lukustatud omanikule.',
        'Will be the sender address of this queue for email answers.' => 'Aadress, millelt selle järjekorra kirjad tulevad.',
        'The salutation for email answers.' => 'Tervitus e-posti vastustes.',
        'The signature for email answers.' => 'Signatuur e-posti vastustes.',
        'OTRS sends an notification email to the customer if the ticket is moved.' => 'OTRS saadab kliendile teavituskirja kui intsident on teise järjekorda tõstetud.',
        'OTRS sends an notification email to the customer if the ticket state has changed.' => 'OTRS saadab kliendile teavituskirja kui intsidendi olek on muutunud.',
        'OTRS sends an notification email to the customer if the ticket owner has changed.' => 'OTRS saadab kliendile kirja kui intsidendi omanik on muutunud.',

        # Template: AdminQueueResponsesChangeForm
        'Responses <-> Queue Management' => 'Vastused <-> järjekorrad haldus',

        # Template: AdminQueueResponsesForm
        'Answer' => 'Vastus',

        # Template: AdminResponseAttachmentChangeForm
        'Responses <-> Attachments Management' => 'Vastused <-> manused haldus',

        # Template: AdminResponseAttachmentForm

        # Template: AdminResponseForm
        'Response Management' => 'Vastuste haldus',
        'A response is default text to write faster answer (with default text) to customers.' => 'Vastus on valmiskirjutatud tekst, mis saata kliendile mingi probleemi puhul.',
        'Don\'t forget to add a new response a queue!' => 'Ära unusta lisada järjekorda!',
        'The current ticket state is' => 'Intsidendi olek on',
        'Your email address is new' => 'Teie e-postiaadress on uus',

        # Template: AdminRoleForm
        'Role Management' => 'Rollide haldus',
        'Add Role' => 'Lisa roll',
        'Add a new Role.' => 'Lisa uus roll.',
        'Create a role and put groups in it. Then add the role to the users.' => 'Tee roll ja lisa sinna grupid. Seejärel seo rollid kasutajatega.',
        'It\'s useful for a lot of users and groups.' => 'See on kasulik paljude kasutajate ja gruppide korral',

        # Template: AdminRoleGroupChangeForm
        'Roles <-> Groups Management' => 'Rollid <-> grupid haldus',
        'move_into' => 'liiguta_siia',
        'Permissions to move tickets into this group/queue.' => 'Õigus liigutada intsidente siia gruppi/järjekorda.',
        'create' => 'tekita',
        'Permissions to create tickets in this group/queue.' => 'Õigus tekitada sellesse gruppi/järjekorda intsidente.',
        'owner' => 'omanik',
        'Permissions to change the ticket owner in this group/queue.' => 'Õigus muuta selle grupi/järjekorra intsidentide omanikke.',
        'priority' => 'prioriteet',
        'Permissions to change the ticket priority in this group/queue.' => 'Õigus muuta selle grupi/järjekorra intsidentide prioriteete.',

        # Template: AdminRoleGroupForm
        'Role' => 'Roll',

        # Template: AdminRoleUserChangeForm
        'Roles <-> Users Management' => 'Rollid <-> kasutajad haldus',
        'Select the role:user relations.' => 'Vali roll:kasutaja seosed.',

        # Template: AdminRoleUserForm

        # Template: AdminSalutationForm
        'Salutation Management' => 'Tervituste haldus',
        'Add Salutation' => 'Lisa tervitus',
        'Add a new Salutation.' => 'Lisa uus tervitus.',

        # Template: AdminSelectBoxForm
        'SQL Box' => '',
        'Limit' => 'Piirang',
        'Go' => 'Edasi',
        'Select Box Result' => 'Select Box Result',

        # Template: AdminService
        'Service Management' => 'Teenuste haldus',
        'Add Service' => 'Lisa teenus',
        'Add a new Service.' => 'Lisa uus teenus.',
        'Sub-Service of' => 'Teenus on alam teenusele',

        # Template: AdminSession
        'Session Management' => 'Sessioonihaldus',
        'Sessions' => 'Sessioonid',
        'Uniq' => 'Uniq',
        'Kill all sessions' => 'Hävita kõik sessioonid',
        'Session' => 'Sessioon',
        'Content' => 'Sisu',
        'kill session' => 'hävita sessioon',

        # Template: AdminSignatureForm
        'Signature Management' => 'Signatuuride haldus',
        'Add Signature' => 'Lisa signatuur',
        'Add a new Signature.' => 'Lisa uus signatuur.',

        # Template: AdminSLA
        'SLA Management' => 'SLA haldus',
        'Add SLA' => 'SLA lisamine',
        'Add a new SLA.' => 'Lisa uus SLA.',

        # Template: AdminSMIMEForm
        'S/MIME Management' => 'S/MIME haldus',
        'Add Certificate' => 'Sertifikaadi lisamine',
        'Add Private Key' => 'Privaatvõtme lisamine',
        'Secret' => 'Saladus',
        'Hash' => 'Räsi',
        'In this way you can directly edit the certification and private keys in file system.' => 'Nii saad otse hallata sertifikaate ja võtmeid failisüsteemis.',

        # Template: AdminStateForm
        'State Management' => 'Olekute haldus',
        'Add State' => 'Oleku lisamine',
        'Add a new State.' => 'Lisa uus olek.',
        'State Type' => 'Oleku tüüp',
        'Take care that you also updated the default states in you Kernel/Config.pm!' => 'NB! Vaikimisi määratavaid olekuid tuleb muuta failist Kernel/Config.pm!',
        'See also' => 'Vaata lisaks',

        # Template: AdminSysConfig
        'SysConfig' => 'SysConfig',
        'Group selection' => 'Gruppide valik',
        'Show' => 'Näita',
        'Download Settings' => 'Lae seaded alla',
        'Download all system config changes.' => 'Lae alla kõik süsteemi seadistuste muutused.',
        'Load Settings' => 'Lae seaded',
        'Subgroup' => 'alamgrupp',
        'Elements' => 'elemendid',

        # Template: AdminSysConfigEdit
        'Config Options' => 'Config Options',
        'Default' => 'Vaikimisi',
        'New' => 'Uus',
        'New Group' => 'Uus grupp',
        'Group Ro' => 'Grupp Ro',
        'New Group Ro' => 'Uus Grupp Ro',
        'NavBarName' => 'NavBarName',
        'NavBar' => 'NavBar',
        'Image' => 'Pilt',
        'Prio' => 'Prio',
        'Block' => 'Block',
        'AccessKey' => 'AccessKey',

        # Template: AdminSystemAddressForm
        'System Email Addresses Management' => 'Süsteemi epostiaadresside haldus',
        'Add System Address' => 'Süsteemi aadressi lisamine',
        'Add a new System Address.' => 'Lisa uus süsteemi aadress.',
        'Realname' => 'Pärisnimi',
        'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!' => 'Kõik sissetulevad kirjad selle saajaadressiga pannakse valitud järjekorda.',

        # Template: AdminTypeForm
        'Type Management' => 'Tüüpide haldus',
        'Add Type' => 'Tüübi lisamine',
        'Add a new Type.' => 'Lisa uus tüüp.',

        # Template: AdminUserForm
        'User Management' => 'Kasutajate haldus',
        'Add User' => 'Kasutaja lisamine',
        'Add a new Agent.' => 'Lisa uus töötaja.',
        'Login as' => 'kasutajanimi',
        'Firstname' => 'Eesnimi',
        'Lastname' => 'Perekonnanimi',
        'User will be needed to handle tickets.' => 'Kasutajat on vaja intsidentide haldamiseks.',
        'Don\'t forget to add a new user to groups and/or roles!' => 'Ära unusta kasutajat gruppidesse/rollidesse lisamast!',

        # Template: AdminUserGroupChangeForm
        'Users <-> Groups Management' => ' Kasutajad <-> grupid haldus',

        # Template: AdminUserGroupForm

        # Template: AgentBook
        'Address Book' => 'Aadressiraamat',
        'Return to the compose screen' => 'Tagasi kirja loomise ekraanile',
        'Discard all changes and return to the compose screen' => 'Unusta kõik muudatused ja mine tagasi kirja kirjutamise ekraanile',

        # Template: AgentCalendarSmall

        # Template: AgentCalendarSmallIcon

        # Template: AgentCustomerTableView

        # Template: AgentInfo
        'Info' => 'Info',

        # Template: AgentLinkObject
        'Link Object' => 'Seo objekt',
        'Select' => 'Vali',
        'Results' => 'Tulemused',
        'Total hits' => 'Kokku vaatamisi',
        'Page' => 'Lehekülg',
        'Detail' => 'Täpsemalt',

        # Template: AgentLookup
        'Lookup' => 'Lookup',

        # Template: AgentNavigationBar

        # Template: AgentPreferencesForm

        # Template: AgentSpelling
        'Spell Checker' => 'Õigekirjakontroll',
        'spelling error(s)' => 'kirjavigu',
        'or' => 'või',
        'Apply these changes' => 'Muuda',

        # Template: AgentStatsDelete
        'Do you really want to delete this Object?' => 'Oled kindel, et soovid selle objekti kustutada?',

        # Template: AgentStatsEditRestrictions
        'Select the restrictions to characterise the stat' => 'Select the restrictions to characterise the stat',
        'Fixed' => 'Fikseeritud',
        'Please select only one element or turn off the button \'Fixed\'.' => 'Please select only one element or turn off the button \'Fixed\'.',
        'Absolut Period' => 'Absolut Period',
        'Between' => 'Between',
        'Relative Period' => 'Relative Period',
        'The last' => 'The last',
        'Finish' => 'Finish',
        'Here you can make restrictions to your stat.' => 'Here you can make restrictions to your stat.',
        'If you remove the hook in the "Fixed" checkbox, the agent generating the stat can change the attributes of the corresponding element.' => 'If you remove the hook in the "Fixed" checkbox, the agent generating the stat can change the attributes of the corresponding element.',

        # Template: AgentStatsEditSpecification
        'Insert of the common specifications' => 'Insert of the common specifications',
        'Permissions' => 'Õigused',
        'Format' => 'Formaat',
        'Graphsize' => 'Graafiku suurus',
        'Sum rows' => 'Summaread',
        'Sum columns' => 'Summaveerud',
        'Cache' => 'Cache',
        'Required Field' => 'Nõutud väli',
        'Selection needed' => 'Valik on vajalik',
        'Explanation' => 'Selgitus',
        'In this form you can select the basic specifications.' => 'In this form you can select the basic specifications.',
        'Attribute' => 'Attribuut',
        'Title of the stat.' => 'Graafiku nimi.',
        'Here you can insert a description of the stat.' => 'Here you can insert a description of the stat..',
        'Dynamic-Object' => 'Dynamic-Object',
        'Here you can select the dynamic object you want to use.' => 'Here you can select the dynamic object you want to use.',
        '(Note: It depends on your installation how many dynamic objects you can use)' => '(Note: It depends on your installation how many dynamic objects you can use)',
        'Static-File' => 'Static-File',
        'For very complex stats it is possible to include a hardcoded file.' => 'For very complex stats it is possible to include a hardcoded file.',
        'If a new hardcoded file is available this attribute will be shown and you can select one.' => 'If a new hardcoded file is available this attribute will be shown and you can select one.',
        'Permission settings. You can select one or more groups to make the configurated stat visible for different agents.' => 'Permission settings. You can select one or more groups to make the configurated stat visible for different agents.',
        'Multiple selection of the output format.' => 'Multiple selection of the output format.',
        'If you use a graph as output format you have to select at least one graph size.' => 'If you use a graph as output format you have to select at least one graph size.',
        'If you need the sum of every row select yes' => 'If you need the sum of every row select yes',
        'If you need the sum of every column select yes.' => 'If you need the sum of every column select yes.',
        'Most of the stats can be cached. This will speed up the presentation of this stat.' => 'Most of the stats can be cached. This will speed up the presentation of this stat.',
        '(Note: Useful for big databases and low performance server)' => '(Note: Useful for big databases and low performance server)',
        'With an invalid stat it isn\'t feasible to generate a stat.' => 'With an invalid stat it isn\'t feasible to generate a stat.',
        'This is useful if you want that no one can get the result of the stat or the stat isn\'t ready configurated.' => 'This is useful if you want that no one can get the result of the stat or the stat isn\'t ready configurated.',

        # Template: AgentStatsEditValueSeries
        'Select the elements for the value series' => 'Select the elements for the value series',
        'Scale' => 'Scale',
        'minimal' => 'minimal',
        'Please remember, that the scale for value series has to be larger than the scale for the X-axis (e.g. X-Axis => Month, ValueSeries => Year).' => 'Please remember, that the scale for value series has to be larger than the scale for the X-axis (e.g. X-Axis => Month, ValueSeries => Year).',
        'Here you can the value series. You have the possibility to select one or two elements. Then you can select the attributes of elements. Each attribute will be shown as single value series. If you don\'t select any attribute all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' => 'Here you can the value series. You have the possibility to select one or two elements. Then you can select the attributes of elements. Each attribute will be shown as single value series. If you don\'t select any attribute all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.',

        # Template: AgentStatsEditXaxis
        'Select the element, which will be used at the X-axis' => 'Select the element, which will be used at the X-axis.',
        'maximal period' => 'maximal period',
        'minimal scale' => 'minimal scale',
        'Here you can define the x-axis. You can select one element via the radio button. Then you you have to select two or more attributes of the element. If you make no selection all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' => 'Here you can define the x-axis. You can select one element via the radio button. Then you you have to select two or more attributes of the element. If you make no selection all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.',

        # Template: AgentStatsImport
        'Import' => 'Import',
        'File is not a Stats config' => 'File is not a Stats config',
        'No File selected' => 'No File selected',

        # Template: AgentStatsOverview
        'Object' => 'Object',

        # Template: AgentStatsPrint
        'Print' => 'Trüki',
        'No Element selected.' => 'No Element selected.',

        # Template: AgentStatsView
        'Export Config' => 'Export Config',
        'Information about the Stat' => 'Information about the Stat',
        'Exchange Axis' => 'Exchange Axis',
        'Configurable params of static stat' => 'Configurable params of static stat',
        'No element selected.' => 'No element selected.',
        'maximal period from' => 'maximal period from',
        'to' => 'to',
        'Start' => 'Start',
        'With the input and select fields you can configurate the stat at your needs. Which elements of a stat you can edit depends on your stats administrator who configurated the stat.' => 'With the input and select fields you can configurate the stat at your needs. Which elements of a stat you can edit depends on your stats administrator who configurated the stat.',

        # Template: AgentTicketBounce
        'Bounce ticket' => 'Põrgata intsident',
        'Ticket locked!' => 'Intsident lukus!',
        'Ticket unlock!' => 'Eemalda lukk!',
        'Bounce to' => 'Põrgata töötajale',
        'Next ticket state' => 'Intsidendi järgmine olek',
        'Inform sender' => 'Teavita saatjat',
        'Send mail!' => 'Saada kiri!',

        # Template: AgentTicketBulk
        'Ticket Bulk Action' => 'Hulgitegevused intsidentidega',
        'Spell Check' => 'Õigekirjakontroll',
        'Note type' => 'Märkuse tüüp',
        'Unlock Tickets' => 'Eemalda intsidentidelt lukud',

        # Template: AgentTicketClose
        'Close ticket' => 'Sulge intsident',
        'Previous Owner' => 'Eelmine omanik',
        'Inform Agent' => 'Teavita töötajat',
        'Optional' => 'Valikuline',
        'Inform involved Agents' => 'Teavita seotud töötajaid',
        'Attach' => 'Manusta',
        'Next state' => 'Järmine olek',
        'Pending date' => 'Ootel kuni',
        'Time units' => 'tööühikuid',

        # Template: AgentTicketCompose
        'Compose answer for ticket' => 'Koosta vastus',
        'Pending Date' => 'Ootel kuni',
        'for pending* states' => 'ooteolekutele',

        # Template: AgentTicketCustomer
        'Change customer of ticket' => 'Muuda intsidendiga seotud klienti',
        'Set customer user and customer id of a ticket' => 'muuda intsidendi kliendikasutajat ja kliendikasutaja id-d',
        'Customer User' => 'Klient',
        'Search Customer' => 'Otsi klienti',
        'Customer Data' => 'Kliendi andmed',
        'Customer history' => 'Kliendi ajalugu',
        'All customer tickets.' => 'Kõik selle kliendi intsidendid.',

        # Template: AgentTicketCustomerMessage
        'Follow up' => 'Täiendav info',

        # Template: AgentTicketEmail
        'Compose Email' => 'Kirjuta ekiri',
        'new ticket' => 'uus intsident',
        'Refresh' => 'värskenda',
        'Clear To' => 'puhasta saaja',

        # Template: AgentTicketEscalationView
        'Ticket Escalation View' => '',
        'Escalation' => '',
        'Today' => '',
        'Tomorrow' => '',
        'Next Week' => '',
        'up' => 'üles',
        'down' => 'alla',
        'Escalation' => '',
        'Locked' => 'Lukustatud',

        # Template: AgentTicketForward
        'Article type' => 'Intsidendi tüüp',

        # Template: AgentTicketFreeText
        'Change free text of ticket' => 'Muuda intsidendi teksti',

        # Template: AgentTicketHistory
        'History of' => 'Ajalugu',

        # Template: AgentTicketLocked

        # Template: AgentTicketMailbox
        'Mailbox' => 'Mailbox',
        'Tickets' => 'Intsidendid',
        'of' => '',
        'Filter' => 'Filter',
        'New messages' => 'Uued teated',
        'Reminder' => 'Meeldetuletus',
        'Sort by' => 'Sorteeri',
        'Order' => 'Järjekord',

        # Template: AgentTicketMerge
        'Ticket Merge' => 'Ühenda intsidendid',
        'Merge to' => 'Ühenda intsidendiga',

        # Template: AgentTicketMove
        'Move Ticket' => 'Liiguta intsidenti',

        # Template: AgentTicketNote
        'Add note to ticket' => 'Lisa intsidendile märkus',

        # Template: AgentTicketOwner
        'Change owner of ticket' => 'Muuda intsidendi omanikku',

        # Template: AgentTicketPending
        'Set Pending' => 'Pane ootele',

        # Template: AgentTicketPhone
        'Phone call' => 'Helista',
        'Clear From' => 'Puhasta saatja',

        # Template: AgentTicketPhoneOutbound

        # Template: AgentTicketPlain
        'Plain' => 'Plain',

        # Template: AgentTicketPrint
        'Ticket-Info' => 'Intsidendi info',
        'Accounted time' => 'Tööaeg',
        'First Response Time' => 'Reaktsiooniaeg',
        'Update Time' => 'Muutmisaeg',
        'Solution Time' => 'Lahendusaeg',
        'Linked-Object' => 'Seotud objekt',
        'Parent-Object' => 'Ülemobjekt',
        'Child-Object' => 'Alamobjekt',
        'by' => 'teinud',

        # Template: AgentTicketPriority
        'Change priority of ticket' => 'Muuda intsidendi prioriteeti',

        # Template: AgentTicketQueue
        'Tickets shown' => 'Nähtaval intsidendid',
        'Tickets available' => 'Saadaval intsidente',
        'All tickets' => 'Kõik intsidendid',
        'Queues' => 'Järjekorrad',
        'Ticket escalation!' => 'Intsidendi eskaleerimine!',

        # Template: AgentTicketQueueTicketView
        'Service Time' => 'Teeinindusaeg',
        'Your own Ticket' => 'Sinu intsident',
        'Compose Follow up' => 'Kirjuta täiendus',
        'Compose Answer' => 'Kirjuta vastus',
        'Contact customer' => 'Kotakteeru kliendiga',
        'Change queue' => 'Muuda järjekorda',

        # Template: AgentTicketQueueTicketViewLite

        # Template: AgentTicketResponsible
        'Change responsible of ticket' => 'Muuda intsidendi eest vastutajat',

        # Template: AgentTicketSearch
        'Ticket Search' => 'Otsi intsidente',
        'Profile' => 'Profiil',
        'Search-Template' => 'Otsingumall',
        'TicketFreeText' => 'TicketFreeText',
        'Created in Queue' => 'Tehtud järjekorras',
        'Close Times' => '',
        'No close time settings.' => '',
        'Ticket closed' => '',
        'Ticket closed between' => '',
        'Result Form' => 'Tulemuste formaat',
        'Save Search-Profile as Template?' => 'Kas salvestada otsing mallina?',
        'Yes, save it with name' => 'Jah, salvesta nimega',

        # Template: AgentTicketSearchOpenSearchDescription

        # Template: AgentTicketSearchResult
        'Change search options' => 'Muuda otsingut',

        # Template: AgentTicketSearchResultPrint
        '"}' => '',

        # Template: AgentTicketSearchResultShort

        # Template: AgentTicketStatusView
        'Ticket Status View' => 'Näita intsidendi olekut',
        'Open Tickets' => 'Avatud intsidendid',

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
        'Traceback' => 'Traceback',

        # Template: CustomerFooter
        'Powered by' => 'Powered by',

        # Template: CustomerFooterSmall

        # Template: CustomerHeader

        # Template: CustomerHeaderSmall

        # Template: CustomerLogin
        'Login' => 'Login',
        'Lost your password?' => 'Kaotasid parooli?',
        'Request new password' => 'Telli uus parool',
        'Create Account' => 'Tee konto',

        # Template: CustomerNavigationBar
        'Welcome %s' => 'Tere tulemast %s',

        # Template: CustomerPreferencesForm

        # Template: CustomerStatusView

        # Template: CustomerTicketMessage

        # Template: CustomerTicketPrint

        # Template: CustomerTicketSearch
        'Times' => 'Aeg',
        'No time settings.' => 'Ajaseadeid ei ole.',

        # Template: CustomerTicketSearchResultCSV

        # Template: CustomerTicketSearchResultPrint

        # Template: CustomerTicketSearchResultShort

        # Template: CustomerTicketZoom

        # Template: CustomerWarning

        # Template: Error
        'Click here to report a bug!' => 'Veast teavitamiseks kliki siia!',

        # Template: Footer
        'Top of Page' => 'Lehekülje algusesse',

        # Template: FooterSmall

        # Template: Header

        # Template: HeaderSmall

        # Template: Installer
        'Web-Installer' => 'Web-Installer',
        'Welcome to %s' => 'Tere tulemast %s',
        'Accept license' => 'Nõusti litsensiga',
        'Don\'t accept license' => 'Ära nõustu litsensiga',
        'Admin-User' => 'Admin-kasutaja',
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty. For security reasons we do recommend setting a root password. For more information please refer to your database documentation.' => 'If you have set a root password for your database, it must be entered here. If not, leave this field empty. For security reasons we do recommend setting a root password. For more information please refer to your database documentation.',
        'Admin-Password' => 'Admin-parool',
        'Database-User' => 'Andmebaasi kasutaja',
        'default \'hot\'' => 'vaikimisi \'hot\'',
        'DB connect host' => 'Andembaasiserver',
        'Database' => 'Andmebaas',
        'Default Charset' => 'Vaikimisi kooditabel',
        'utf8' => '',
        'false' => 'vale',
        'SystemID' => 'SystemID',
        '(The identify of the system. Each ticket number and each http session id starts with this number)' => '(Süsteemi identifitseerimiseks. Iga intsidendi number ja http sessiooni id algab selle numbriga)',
        'System FQDN' => 'System FQDN',
        '(Full qualified domain name of your system)' => '(Sinu arvuti täielik DNS nimi)',
        'AdminEmail' => 'Admin epostiaadress',
        '(Email of the system admin)' => '(Süsteemihalduri epostiaadress)',
        'Organization' => 'Organisatsioon',
        'Log' => 'Log',
        'LogModule' => 'LogModule',
        '(Used log backend)' => '(Kasutatav logimise moodul)',
        'Logfile' => 'Logifail',
        '(Logfile just needed for File-LogModule!)' => '(Logifaili vajab ainult File-LogModule!)',
        'Webfrontend' => 'Veebiliides',
        'Use utf-8 it your database supports it!' => 'Kasuta utf-8 kui su andmebaas seda toetab!',
        'Default Language' => 'Vaikimisi keel',
        '(Used default language)' => '(kasuta vaikimisi keeleks)',
        'CheckMXRecord' => 'CheckMXRecord',
        '(Checks MX recordes of used email addresses by composing an answer. Don\'t use CheckMXRecord if your OTRS machine is behinde a dial-up line $!)' => '(Kontrollib e-posti aadresside MX kirjeid. Ära kasuta CheckMXRecord seadet, kui kasutate sissehelistamist või internetiühendus serveril puudub)',
        'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' => 'OTRS kasutamiseks peate järgneva käsu sisestama süsteemi root-kasutajana.',
        'Restart your webserver' => 'Taaskäivita veebiserver.',
        'After doing so your OTRS is up and running.' => 'Peale seda OTRS töötab.',
        'Start page' => 'Algusleht',
        'Your OTRS Team' => 'OTRS meeskond',

        # Template: Login

        # Template: Motd

        # Template: NoPermission
        'No Permission' => 'Ei ole õigust',

        # Template: Notify
        'Important' => 'Tähtis',

        # Template: PrintFooter
        'URL' => 'URL',

        # Template: PrintHeader
        'printed by' => 'trükkija',

        # Template: Redirect

        # Template: Test
        'OTRS Test Page' => 'OTRS testileht',
        'Counter' => 'Loendur',

        # Template: Warning
        # Misc
        'Create Database' => 'Tekita andmebaas',
        'verified' => 'kontrollitud',
        'File-Name' => 'Failinimi',
        'Ticket Number Generator' => 'Intsidendinumbri generaator',
        '(Ticket identifier. Some people want toset this to e. g. \'Ticket#\', \'Call#\' or \'MyTicket#\')' => '(Intsidendi identifikaator. Mõned inimesed tahavad seda muuta näiteks. \'Ticket#\', \'Call#\' või \'MyTicket#\')',
        'In this way you can directly edit the keyring configured in Kernel/Config.pm.' => 'Nii saad otse muuta võtmeid mis on seadistatud Kernel/Config.pm failis.',
        'Create new Phone Ticket' => 'Tee uus telefonitsi laekunud intsident',
        'U' => 'U',
        'A message should have a To: recipient!' => 'Kirjal peaks oleam saatja aadress!',
        'Site' => 'Sait',
        'Customer history search (e. g. "ID342425").' => 'Kliendiajaloo otsing (näiteks "ID342425").',
        'Close!' => 'Sulge!',
        'for agent firstname' => 'Kasutaja eesnimeks',
        'Reporter' => 'Raporteerija',
        'The message being composed has been closed.  Exiting.' => 'Pooleliolev kriri sulegi. Lõpetan.',
        'Process-Path' => 'Protsessi tee',
        'to get the realname of the sender (if given)' => 'hankimaks saatja täisnime (kui on teada)',
        'FAQ Search Result' => 'FAQ otsingu tulemus',
        'Notification (Customer)' => 'Teavitus (klient)',
        'CSV' => 'CSV',
        'Select Source (for add)' => 'Vali allikas (lisamiseks)',
        'Node-Name' => 'Node-Name',
        'Options of the ticket data (e. g. &lt;OTRS_TICKET_Number&gt;, &lt;OTRS_TICKET_ID&gt;, &lt;OTRS_TICKET_Queue&gt;, &lt;OTRS_TICKET_State&gt;)' => 'Võimalikud intsidendi väljad (näiteks &lt;OTRS_TICKET_Number&gt;, &lt;OTRS_TICKET_ID&gt;, &lt;OTRS_TICKET_Queue&gt;, &lt;OTRS_TICKET_State&gt;)',
        'Home' => 'Algusesse',
        'Workflow Groups' => 'Töövoo grupid',
        'Current Impact Rating' => 'Praegune mõjuhinnang',
        'Config options (e. g. <OTRS_CONFIG_HttpType>)' => 'Seadistused (<OTRS_CONFIG_HttpType>)',
        'FAQ System History' => 'FAQ süsteemi ajalugu',
        'customer realname' => 'klienti nimi',
        'Pending messages' => 'Ootel teated',
        'Modules' => 'Moodulid',
        'for agent login' => 'töötaja sisselogimiseks',
        'Keyword' => 'võtmesõna',
        'Reference' => 'Viited',
        'with' => 'koos',
        'Close type' => 'Sulte tüüp',
        'DB Admin User' => 'DB Admin kasutaja',
        'for agent user id' => 'töötaja kasutajanimeks',
        'sort upward' => 'sordi ülespoole',
        'Classification' => 'Klassifikatsioon',
        'Change user <-> group settings' => 'Muuda kasutaja <-> grupp seadeid',
        'next step' => 'järgmine samm',
        'Customer history search' => 'Kliendiajaloo otsing',
        'not verified' => 'kontrollimata',
        'Stat#' => 'Statistika nr.',
        'Create new database' => 'Tekita uus andmebaas',
        'Year' => 'Aasta',
        'A message must be spell checked!' => 'Kiri peab olema õigekirja osas kontrollitud!',
        'X-axis' => 'X-telg',
        'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further information.' => 'Sinu kiri intsidendiga nr "<OTRS_TICKET>" põrgatati "<OTRS_BOUNCE_TO>". Täpsema info saamiseks kirjuta sellel aadressil.',
        'A message should have a body!' => 'Kirjal peab olema sisu!',
        'All Agents' => 'Kõik töötajad',
        'Keywords' => 'Võtmesõnad',
        'No * possible!' => '"*" ei ole lubatud!',
        'Load' => 'Lae',
        'Change Time' => 'Muudatuse aeg',
        'Options of the current user who requested this action (e. g. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)' => 'Selle kasutaja andmed, kes soovis antud tegevust (näiteks &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)',
        'Message for new Owner' => 'Sõnum uuele omanikule',
        'to get the first 5 lines of the email' => 'kirja esimese 5 rea hankimiseks',
        'Sent new password to: ' => 'Saada uus parool aadressile: ',
        'OTRS DB Password' => 'OTRS andmebaasi parool',
        'Last update' => 'Viimane uuendus',
        'not rated' => 'hindamata',
        'to get the first 20 character of the subject' => 'hankimaks esimesed 20 märki teemareast',
        'Select the customeruser:service relations.' => 'Vali kliendikasutaj:teenus suhe.',
        'DB Admin Password' => 'Andmebaasi administraatori parool',
        'Drop Database' => 'Kustuta andmebaas',
        'Options of the current customer user data (e. g. <OTRS_CUSTOMER_DATA_UserFirstname>)' => 'Käesoleva kasutaja andmed (näiteks <OTRS_CUSTOMER_DATA_UserFirstname>)',
        'Pending type' => 'Ooteoleku tüüp',
        'Comment (internal)' => 'Kommentaar (töötajatele)',
        'Ticket owner options (e. g. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)' => 'Intsidendi omaniku andmed (näiteks &lt;OTRS_OWNER_USERFIRSTNAME&gt;)',
        'This window must be called from compose window' => 'Seda akent saab avada kirja kirjutamise aknast',
        'User-Number' => 'Kasutajanumber',
        'You need min. one selected Ticket!' => 'Vajad vähemalt ühte valitud intsidenti!',
        'Options of the ticket data (e. g. <OTRS_TICKET_Number>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' => 'Intsidendi andmed (näiteks <OTRS_TICKET_Number>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)',
        '(Used ticket number format)' => '(intsidendinumbri formaat)',
        'Fulltext' => 'Täistekst',
        'Month' => 'Kuu',
        'Node-Address' => 'Node-Address',
        'All Agent variables.' => 'Kõik töötaja andmed',
        ' (work units)' => ' (tööühikud)',
        'You use the DELETE option! Take care, all deleted Tickets are lost!!!' => 'Kasutad kustutamise valikut! Tähelepanu, kõik kustutatud intsidendid kaovad!',
        'All Customer variables like defined in config option CustomerUser.' => 'Kõik kliendi muutujad nii nagu on defineeritud CustomerUser-is.',
        'for agent lastname' => 'töötaja perenimeks',
        'Options of the current user who requested this action (e. g. <OTRS_CURRENT_UserFirstname>)' => 'Selle kasutaja andmed, kes soovis antud tegevust (näiteks <OTRS_CURRENT_UserFirstname>)',
        'Reminder messages' => 'Meeldetuletusteated',
        'A message should have a subject!' => 'Sõnumil peaks olema teema!',
        'TicketZoom' => 'Vaata täpsemalt',
        'Don\'t forget to add a new user to groups!' => 'Ära unusta kasutajat gruppidesse lisamast!',
        'You need a email address (e. g. customer@example.com) in To:!' => 'Sul peab olema epostiaadress (näiteks klient@example.com) Saaja väljal!',
        'CreateTicket' => 'Tekita intsident',
        'unknown' => 'teadmata',
        'You need to account time!' => 'Pead kirja panema tööaja!',
        'System Settings' => 'Süsteemi seaded',
        'Finished' => 'Valmis',
        'Imported' => 'Imporditud',
        'unread' => 'lugemata',
        'Split' => 'Poolita',
        'D' => 'D',
        'System Status' => 'Süsteemi olek',
        'All messages' => 'Kõik teated',
        'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' => 'Intsidentide andmed  (näiteks <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)',
        'A article should have a title!' => 'Artiklil peaks olema pealkiri!',
        'Customer Users <-> Services' => 'Kliendikasutajad <-> teenused',
        'Config options (e. g. &lt;OTRS_CONFIG_HttpType&gt;)' => 'Seadistused (näiteks .&lt;OTRS_CONFIG_HttpType&gt;)',
        'Event' => 'Sündmus',
        'Imported by' => 'Importija',
        'Ticket owner options (e. g. <OTRS_OWNER_UserFirstname>)' => 'Intsidendi omaniku andmed (näiteks <OTRS_OWNER_UserFirstname>)',
        'read' => 'loetud',
        'Product' => 'Toode',
        'Name is required!' => 'Nimi on vajalik!',
        'kill all sessions' => 'hävita kõik sessioonid',
        'to get the from line of the email' => 'saamaks kirja saatjat',
        'Solution' => 'Lahendus',
        'QueueView' => 'Järjekorrad',
        'My Queue' => 'Minu järjekorrad',
        'Select Box' => 'Select Box',
        'Instance' => 'Ühik',
        'Day' => 'päev',
        'Service-Name' => 'Teenuse nimi',
        'Welcome to OTRS' => 'Tere tulemast OTRSi',
        'tmp_lock' => 'ajutine lukk',
        'modified' => 'muudetud',
        'Escalation in' => 'Eskaleerub',
        'Delete old database' => 'Kustuta vana andmebaas',
        'sort downward' => 'sordi allapoole',
        'You need to use a ticket number!' => 'Pead kasutama intsidendi numbrit!',
        'Watcher' => 'Huvilised',
        'Have a lot of fun!' => 'Tööta mõnuga!',
        'send' => 'saada',
        'Note Text' => 'Märkuse tekst',
        'POP3 Account Management' => 'POP3 konto haldus',
        'Options of the current customer user data (e. g. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)' => 'Käiesoleva kliendi andmed (näiteks &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;).',
        'System State Management' => 'Süsteemi oleku haldus',
        'PhoneView' => 'Telefonivaade',
        'User-Name' => 'Kasutajanimi',
        'File-Path' => 'Failitee',
        'closed with workaround' => 'suletud ajutise lahendusega',
        'Modified' => 'Muudetud',
        'Ticket selected for bulk action!' => 'Intsident märgiti hulgitegevuseks',

        'Link Object: %s' => '',
        'Unlink Object: %s' => '',
        'Linked as' => '',
        'Can not create link with %s!' => '',
        'Can not delete link with %s!' => '',
        'Object already linked as %s.' => '',
    };
    # $$STOP$$
    return;
}

1;
