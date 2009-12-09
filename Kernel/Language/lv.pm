# --
# Kernel/Language/lv.pm - provides Latvian language translation
# Copyright (C) 2009 Ivars Strazdins <ivars.strazdins at gmail.com>
# --
# $Id: lv.pm,v 1.6.2.4 2009-12-09 12:01:00 mb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --
package Kernel::Language::lv;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.6.2.4 $) [1];

sub Data {
    my $Self = shift;

    # $$START$$
    # Last translation file sync: Tue Jun 30 17:48:59 2009

    # possible charsets
    $Self->{Charset} = ['UTF-8', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Year;)
    $Self->{DateFormat}          = '%D.%M.%Y %T';
    $Self->{DateFormatLong}      = '%T - %D.%M.%Y';
    $Self->{DateFormatShort}     = '%D.%M.%Y';
    $Self->{DateInputFormat}     = '%D.%M.%Y';
    $Self->{DateInputFormatLong} = '%D.%M.%Y - %T';

    $Self->{Translation} = {
        # Template: AAABase
        'Yes' => 'Jā',
        'No' => 'Nē',
        'yes' => 'jā',
        'no' => 'nē',
        'Off' => 'Izslēgts',
        'off' => 'izslēgts',
        'On' => 'Ieslēgts',
        'on' => 'ieslēgts',
        'top' => 'sākums',
        'end' => 'beigas',
        'Done' => 'Pabeigts',
        'Cancel' => 'Atcelt',
        'Reset' => 'Atiestatīt',
        'last' => 'pēdējais',
        'before' => 'pirms',
        'day' => 'diena',
        'days' => 'dienas',
        'day(s)' => 'diena(s)',
        'hour' => 'stunda',
        'hours' => 'stundas',
        'hour(s)' => 'stunda(s)',
        'minute' => 'minūte',
        'minutes' => 'minūtes',
        'minute(s)' => 'minūte(s)',
        'month' => 'mēnesis',
        'months' => 'mēneši',
        'month(s)' => 'mēnesis(ši)',
        'week' => 'nedēļa',
        'week(s)' => 'nedēļa(s)',
        'year' => 'gads',
        'years' => 'gadi',
        'year(s)' => 'gads(i)',
        'second(s)' => 'sekunde(s)',
        'seconds' => 'sekundes',
        'second' => 'sekunde',
        'wrote' => 'rakstīja',
        'Message' => 'ziņojums',
        'Error' => 'kļūda',
        'Bug Report' => 'kļūdas ziņojums',
        'Attention' => 'uzmanību',
        'Warning' => 'brīdinājums',
        'Module' => 'modulis',
        'Modulefile' => 'moduļa fails',
        'Subfunction' => 'apakšfunkcija',
        'Line' => 'līnija',
        'Setting' => 'iestatījums',
        'Settings' => 'Iestatījumi',
        'Example' => 'piemērs',
        'Examples' => 'piemēri',
        'valid' => 'derīgs',
        'invalid' => 'nederīgs',
        '* invalid' => '* ir nederīga',
        'invalid-temporarily' => 'īslaicīgi nederīgs',
        ' 2 minutes' => ' 2 minūtes',
        ' 5 minutes' => ' 5 minūtes',
        ' 7 minutes' => ' 7 minūtes',
        '10 minutes' => '10 minūtes',
        '15 minutes' => '15 minūtes',
        'Mr.' => 'K-gs',
        'Mrs.' => 'K-dze',
        'Next' => 'Nākamais',
        'Back' => 'Atpakaļ',
        'Next...' => 'Nākamais...',
        '...Back' => '...atpakaļ',
        '-none-' => '-nav-',
        'none' => 'nav',
        'none!' => 'nav pazīmju!',
        'none - answered' => 'neviens nav atbildējis',
        'please do not edit!' => 'lūdzu nelabot!',
        'AddLink' => 'Pievienot saiti',
        'Link' => 'Saite',
        'Unlink' => 'Dzēst saiti',
        'Linked' => 'Sasaistīts',
        'Link (Normal)' => 'Saite (normāla)',
        'Link (Parent)' => 'Saite (uz sākotnējo)',
        'Link (Child)' => 'Saite (uz nākamo)',
        'Normal' => 'Normāls',
        'Parent' => 'Sākotnējais',
        'Child' => 'Nākamais',
        'Hit' => 'Trāpījums',
        'Hits' => 'Trāpījumi',
        'Text' => 'Teksts',
        'Lite' => 'Vieglā',
        'Standard' => 'Standarta',
        'User' => 'Lietotājs',
        'Username' => 'Lietotājvārds',
        'Language' => 'Valoda',
        'Languages' => 'Valodas',
        'Password' => 'Parole',
        'Salutation' => 'Uzruna',
        'Signature' => 'Paraksts',
        'Customer' => 'Klienti',
        'CustomerID' => 'Klienta identifikators',
        'CustomerIDs' => 'Klienta identifikatori',
        'customer' => 'Klients',
        'agent' => 'atbildīgais',
        'system' => 'sistēma',
        'Customer Info' => 'Klienta informācija',
        'Customer Company' => 'Klienta organizācija/uzņēmums',
        'Company' => 'Organizācija/uzņēmums',
        'go!' => 'Sākt!',
        'go' => 'Sākt',
        'All' => 'Visi pieteikumi',
        'all' => 'visi pieteikumi',
        'Sorry' => 'Atvainojiet',
        'update!' => 'atjaunināšana!',
        'update' => 'atjaunināšana',
        'Update' => 'Atjaunināt',
        'Updated!' => 'Atjaunināts!',
        'submit!' => 'iesniegt!',
        'submit' => 'ieniegt',
        'Submit' => 'Iesniegt',
        'change!' => 'Mainīt!',
        'Change' => 'Mainīt',
        'change' => 'Mainīt',
        'click here' => 'klikšķināt te',
        'Comment' => 'Komentārs',
        'Valid' => 'Vai derīgs?',
        'Invalid Option!' => 'Nederīga izvēle!',
        'Invalid time!' => 'Nederīgs laiks!',
        'Invalid date!' => 'Nederīgs datums!',
        'Name' => 'Vārds',
        'Group' => 'Grupa',
        'Description' => 'Apraksts',
        'description' => 'apraksts',
        'Theme' => 'Tēma',
        'Created' => 'Izveidots',
        'Created by' => 'Izveidojis',
        'Changed' => 'Mainīts',
        'Changed by' => 'Mainījis',
        'Search' => 'Meklēt',
        'and' => 'un',
        'between' => 'starp',
        'Fulltext Search' => 'pilna teksta meklēšana',
        'Data' => 'Datu fails',
        'Options' => 'Iestatījumi',
        'Title' => 'Virsraksts',
        'Item' => 'vienība',
        'Delete' => 'Dzēst',
        'Edit' => 'Labot',
        'View' => 'Skatīt',
        'Number' => 'Numurs',
        'System' => 'Sistēma',
        'Contact' => 'Kontaktpersona',
        'Contacts' => 'Kontaktpersonas',
        'Export' => 'Eksports',
        'Up' => 'uz augšu',
        'Down' => 'uz leju',
        'Add' => 'Pievienot',
        'Added!' => 'Pievienots!',
        'Category' => 'Kategorija',
        'Viewer' => 'Aplūkotājs',
        'Expand' => 'Izvērst',
        'New message' => 'Jauni ziņojumi',
        'New message!' => 'Jauns ziņojums!',
        'Please answer this ticket(s) to get back to the normal queue view!' => 'Lai varētu atgriezties uz parasto rindas apskati, lūdzu atbildiet uz šo problēmas pieteikumu!',
        'You got new message!' => 'Jums ir jauns ziņojums!',
        'You have %s new message(s)!' => 'Jums ir %s jauns(i) ziņojums(i)!',
        'You have %s reminder ticket(s)!' => 'Jums ir %s atgādinājums(i)!',
        'The recommended charset for your language is %s!' => 'Ieteicamais simbolu kodējums izvēlētajai valodai ir %s!',
        'Passwords doesn\'t match! Please try it again!' => 'Paroles nesakrīt! Lūdzu, mēģiniet vēlreiz!',
        'Password is already in use! Please use an other password!' => 'Šī parole jau tiek izmantota, lūdzu izmantojiet citu paroli!',
        'Password is already used! Please use an other password!' => 'Šī parole jau ir tikusi izmantota, lūdzu izmantojiet citu paroli!',
        'You need to activate %s first to use it!' => 'Lai to izmantotu, vispirms jāaktivizē %s!',
        'No suggestions' => 'Nav ieteikumu',
        'Word' => 'Vārds',
        'Ignore' => 'Ignorēt',
        'replace with' => 'aizvietot ar',
        'There is no account with that login name.' => 'Nav lietāja konta ar tādu lietotāja vārdu.',
        'Login failed! Your username or password was entered incorrectly.' => 'Neizdevās pieteikties! Lietotājvārds vai parole tika ievadīti nepareizi.',
        'Please contact your admin' => 'Lūdzu sazinieties ar sistēmas administratoru',
        'Logout successful. Thank you for using OTRS!' => 'Atteikšanās veiksmīga! Paldies, ka izmantojāt OTRS problēmu pieteikumu sistēmu!',
        'Invalid SessionID!' => 'Nederīgs sesijas ID!',
        'Feature not active!' => 'Papildiespēja nav aktivizēta!',
        'Notification (Event)' => 'Paziņojums (notikums)',
        'Login is needed!' => 'Vispirms jāpiesakās sistēmā!',
        'Password is needed!' => 'Parole ir obligāta!',
        'License' => 'Licence',
        'Take this Customer' => 'Ņemt šo klientu',
        'Take this User' => 'Ņemt šo lietotāju',
        'possible' => 'iespējams',
        'reject' => 'nepieņemt',
        'reverse' => 'pretēji',
        'Facility' => 'Iespēja',
        'Timeover' => 'Laika periods',
        'Pending till' => 'Neizlemts līdz',
        'Don\'t work with UserID 1 (System account)! Create new users!' => 'Lūdzu, nestrādājiet ar Lietotāja ID 1 (sistēmas kontu)! Izveidojiet jaunu lietotāju!',
        'Dispatching by email To: field.' => 'Pārvietot pēc Kam: lauka pazīmes e-pastā.',
        'Dispatching by selected Queue.' => 'Pārvietot uz norādīto rindu.',
        'No entry found!' => 'Nekas netika atrasts!',
        'Session has timed out. Please log in again.' => 'Sesija ir beigusies. Lūdzu, piesakieties vēlreiz.',
        'No Permission!' => 'Nav atļaujas!',
        'To: (%s) replaced with database email!' => 'Kam: (%s) tikai aizvietots ar datubāzes e-pastu!',
        'Cc: (%s) added database email!' => 'Datubāzes e-pasta adrese pievienota Kopija: (%s) laukā!',
        '(Click here to add)' => '(Klikšķiniet šeit, lai pievienotu)',
        'Preview' => 'Priekšapskate',
        'Package not correctly deployed! You should reinstall the Package again!' => 'Programmatūras pakotne nav korekti pievienota! Nepieciešams pārinstalēt programmatūras pakotni!',
        'Added User "%s"' => 'Lietotājs "%s" pievienots.',
        'Contract' => 'Kontrakts (līgums)',
        'Online Customer: %s' => 'Tiešsaistes klients: %s',
        'Online Agent: %s' => 'Tiešsaistes atbildīgā persona: %s',
        'Calendar' => 'Kalendārs',
        'File' => 'Datu fails',
        'Filename' => 'Faila (datnes) nosaukums',
        'Type' => 'Tips',
        'Size' => 'Izmērs',
        'Upload' => 'Augšupielādēt',
        'Directory' => 'Direktorija (mape)',
        'Signed' => 'Parakstīts',
        'Sign' => 'Parakstīt',
        'Crypted' => 'Šifrēts',
        'Crypt' => 'Šifrēt',
        'Office' => 'Birojs',
        'Phone' => 'Telefons',
        'Fax' => 'Fakss',
        'Mobile' => 'Mobilais telefons',
        'Zip' => 'Pasta indekss',
        'City' => 'Pilsēta',
        'Street' => 'Iela',
        'Country' => 'Valsts',
        'Location' => 'Vieta',
        'installed' => 'instalēts',
        'uninstalled' => 'nav instalēts',
        'Security Note: You should activate %s because application is already running!' => 'Drošības piezīme: jums vajadzētu aktivizēt %s, jo programma jau darbojas!',
        'Unable to parse Online Repository index document!' => 'Nav iespējams caurlūkot tiešsaistes repozitorija indeksu!',
        'No Packages for requested Framework in this Online Repository, but Packages for other Frameworks!' => 'Pieprasītajai struktūrai (framework) nav pakotņu šajā tiešsaistes repozitorijā, bet ir pakotnes citām struktūrām.',
        'No Packages or no new Packages in selected Online Repository!' => 'Izvēlētajā tiešsaistes repozitorijā nav pakotņu vai nav jaunu pakotņu!',
        'printed at' => 'izdrukāts',
        'Dear Mr. %s,' => 'Cien. %s k-gs,',
        'Dear Mrs. %s,' => 'Cien. %s k-dze,',
        'Dear %s,' => 'Cien. %s,',
        'Hello %s,' => 'Labdien %s,',
        'This account exists.' => 'Šāds lietotāja konts eksistē.',
        'New account created. Sent Login-Account to %s.' => 'Izveidots jauns lietotāja konts. Konta dati nosūtīti uz %s.',
        'Please press Back and try again.' => 'Lūdzu, klikšķiniet uz Atpakaļ un mēģiniet vēlreiz.',
        'Sent password token to: %s' => 'Paroles maiņas piekļuves pilnvara nosūtīta uz %s.',
        'Sent new password to: %s' => 'Jaunā parole nosūtīta uz %s.',
        'Upcoming Events' => 'Nākamie notikumi',
        'Event' => 'Notikums',
        'Events' => 'Notikumi',
        'Invalid Token!' => 'Nederīga piekļuves pilnvara!',
        'more' => 'vēl',
        'For more info see:' => 'Papildus informācijai, lūdzu, skatīt:',
        'Package verification failed!' => 'Pākotnes pārbaude neizdevās!',
        'Collapse' => 'Sašaurināt',
        'News' => 'Jaunumi',
        'Product News' => 'Izstrādes jaunumi',
        'OTRS News' => 'OTRS jaunumi',
        '7 Day Stats' => '7 dienu statistika',
        'Bold' => 'Treknraksts',
        'Italic' => 'Kursīvs',
        'Underline' => 'Pasvītrots',
        'Font Color' => 'Fonta krāsa',
        'Background Color' => 'Fona krāsa',
        'Remove Formatting' => 'Novākt formātējumu',
        'Show/Hide Hidden Elements' => 'Rādīt/Slēpt slēptos teksta elementus',
        'Align Left' => 'Kārtot pa kreisi',
        'Align Center' => 'Centrēt',
        'Align Right' => 'Kārtot pa labi',
        'Justify' => 'Izlīdzināt',
        'Header' => 'Galvene',
        'Indent' => 'Atkāpe',
        'Outdent' => 'Pretējā atkāpe',
        'Create an Unordered List' => 'Izveidot nesakārtotu sarakstu',
        'Create an Ordered List' => 'Izveidot sakārtotu sarakstu',
        'HTML Link' => 'HTML hipersaite',
        'Insert Image' => 'Ievietot attēlu',
        'CTRL' => 'CTRL',
        'SHIFT' => 'SHIFT',
        'Undo' => 'atcelt',
        'Redo' => 'atjaunot',

        # Template: AAAMonth
        'Jan' => 'Jan',
        'Feb' => 'Feb',
        'Mar' => 'Mar',
        'Apr' => 'Apr',
        'May' => 'Mai',
        'Jun' => 'Jūn',
        'Jul' => 'Jūl',
        'Aug' => 'Aug',
        'Sep' => 'Sep',
        'Oct' => 'Okt',
        'Nov' => 'Nov',
        'Dec' => 'Dec',
        'January' => 'Janvāris',
        'February' => 'Februāris',
        'March' => 'Marts',
        'April' => 'Aprīlis',
        'May_long' => 'Maijs',
        'June' => 'Jūnijs',
        'July' => 'Jūlijs',
        'August' => 'Augusts',
        'September' => 'Septembris',
        'October' => 'Oktobris',
        'November' => 'Novembris',
        'December' => 'Decembris',

        # Template: AAANavBar
        'Admin-Area' => 'Administrēšanas sadaļa',
        'Agent-Area' => 'Lietotāja sadaļa',
        'Ticket-Area' => 'Pieteikumu sadaļa',
        'Logout' => 'Atteikties',
        'Agent Preferences' => 'Lietotāja iestatījumi',
        'Preferences' => 'Iestatījumi',
        'Agent Mailbox' => 'Lietotāja pastkaste',
        'Stats' => 'Statistika',
        'Stats-Area' => 'Statistikas sadaļa',
        'Admin' => 'Administrēšana',
        'Customer Users' => 'Klienti',
        'Customer Users <-> Groups' => 'Klienti <-> Grupas',
        'Users <-> Groups' => 'Lietotāji <-> Grupas',
        'Roles' => 'Lomas',
        'Roles <-> Users' => 'Lomas <-> Lietotāji',
        'Roles <-> Groups' => 'Lomas <-> Grupas',
        'Salutations' => 'Uzrunas',
        'Signatures' => 'Paraksti',
        'Email Addresses' => 'E-pasta adreses',
        'Notifications' => 'Paziņojumi',
        'Category Tree' => 'Kategorijas',
        'Admin Notification' => 'Administratora paziņojumi',

        # Template: AAAPreferences
        'Preferences updated successfully!' => 'Iestatījumi sekmīgi atjaunoti!',
        'Mail Management' => 'E-pasta pārvaldība',
        'Frontend' => 'Lietotāja interfeiss',
        'Other Options' => 'Citas iespējas',
        'Change Password' => 'Paroles maiņa',
        'New password' => 'Jaunā parole',
        'New password again' => 'Jaunā parole vēlreiz',
        'Select your QueueView refresh time.' => 'Izvēlieties, cik bieži pārlasīt rindas skatu (pieteikumu sarakstus).',
        'Select your frontend language.' => 'Izvēlieties interfeisa valodu.',
        'Select your frontend Charset.' => 'Izvēlieties interfeisa rakstzīmju kodējumu.',
        'Select your frontend Theme.' => 'Izvēlieties interfeisa tēmu.',
        'Select your frontend QueueView.' => 'Izvēlieties interfeisa rindas skata (pieteikumu saraksta) izskatu.',
        'Spelling Dictionary' => 'Pareizrakstības vārdnīca',
        'Select your default spelling dictionary.' => 'Izvēlieties noklusēto pareizrakstības pārbaudes vārdnīcu.',
        'Max. shown Tickets a page in Overview.' => 'Maksimālais problēmu pieteikumu skaits pārskata lapā.',
        'Can\'t update password, your new passwords do not match! Please try again!' => 'Nav iespējams mainīt paroli, jaunās paroles nesakrīt savā starpā! Lūdzu, mēģiniet vēlreiz',
        'Can\'t update password, invalid characters!' => 'Nav iespējams mainīt paroli, tā satur nederīgas rakstzīmes.',
        'Can\'t update password, must be at least %s characters!' => 'Nav iespējams mainīt paroli, nepieciešamas vismaz %s rakstzīmes.',
        'Can\'t update password, must contain 2 lower and 2 upper characters!' => 'Nav iespējams mainīt paroli, parolei jāsatur vismaz 2 lielo un 2 mazo burtu rakstzīmes.',
        'Can\'t update password, needs at least 1 digit!' => 'Nav iespējams mainīt paroli, parolei jāsatur vismaz 1 ciparu rakstzīme!',
        'Can\'t update password, needs at least 2 characters!' => 'Nav iespējams mainīt paroli, parolei jāsatur vismaz 2 rakstzīmes!',

        # Template: AAAStats
        'Stat' => 'Statistika',
        'Please fill out the required fields!' => 'Lūdzu, aizpildiet obligātos laukus!',
        'Please select a file!' => 'Lūdzu, izvēlieties failu (datni)!',
        'Please select an object!' => 'Lūdzu, izvēlieties objektu!',
        'Please select a graph size!' => 'Lūdzu, izvēlieties diagrammas izmēru!',
        'Please select one element for the X-axis!' => 'Lūdzu, izvēlieties vienu elementu X-asij!',
        'Please select only one element or turn off the button \'Fixed\' where the select field is marked!' => 'Lūdzu, izvēlieties tikai vienu elementu vai arī atiestatiet \'Fixed\' pogu pie iezīmētā lauka!',
        'If you use a checkbox you have to select some attributes of the select field!' => 'Ja lietojiet izvēles rūtiņu, tad iezīmētajam laukam jāizvēlas daži atribūti!',
        'Please insert a value in the selected input field or turn off the \'Fixed\' checkbox!' => 'Lūdzu ievadiet vērtību iezīmētajā laukā vai atstatiet \'Fixed\' izvēles rūtiņu!',
        'The selected end time is before the start time!' => 'Izvēlētais beigu laiks ir pirms sākuma laika!',
        'You have to select one or more attributes from the select field!' => 'Jums jāizvēlas viena vai vairākas vērtības no izvēles lauka!',
        'The selected Date isn\'t valid!' => 'Izvēlētais datums nav derīgs!',
        'Please select only one or two elements via the checkbox!' => 'Lūdzu izvēles rūtiņā izvēlieties tikai vienu vai divus elementus!',
        'If you use a time scale element you can only select one element!' => 'Lietojot laika mērogu, iespējams izvēlēties tikai vienu elementu!',
        'You have an error in your time selection!' => 'Izvēlētais laiks ir kļūdains!',
        'Your reporting time interval is too small, please use a larger time scale!' => 'Atskaites laika intervāls ir pārāks mazs, lūdzu, izvēlieties lielāku laika mērogu!',
        'The selected start time is before the allowed start time!' => 'Izvēlētais sākuma laiks ir pirms atļautā sākuma laika!',
        'The selected end time is after the allowed end time!' => 'Izvēlētais beigu laiks ir pēc atļautā beigu laika!',
        'The selected time period is larger than the allowed time period!' => 'Izvēlētais laika periods ir lielāks nekā atļautais periods!',
        'Common Specification' => 'Vispārīgā specifikācija',
        'Xaxis' => 'X-ass',
        'Value Series' => 'Vērtības',
        'Restrictions' => 'Ierobežojumi',
        'graph-lines' => 'līniju diagramma',
        'graph-bars' => 'joslu diagramma',
        'graph-hbars' => 'horizontālo joslu diagramma',
        'graph-points' => 'punktu diagramma',
        'graph-lines-points' => 'punktu un līniju diagramma',
        'graph-area' => 'laukumu diagramma',
        'graph-pie' => 'sektoru diagramma',
        'extended' => 'paplašinātā',
        'Agent/Owner' => 'Aģents/Īpašnieks',
        'Created by Agent/Owner' => 'Izveidojis Aģents/Īpašnieks',
        'Created Priority' => 'Izveidotā prioritāte',
        'Created State' => 'Izveidotais statuss',
        'Create Time' => 'Izveidošanas laiks',
        'CustomerUserLogin' => 'Klienta lietotājvārds',
        'Close Time' => 'Aizvēršanas laiks',
        'TicketAccumulation' => 'Pieteikumu uzkrāšana',
        'Attributes to be printed' => 'Drukājamie atribūti',
        'Sort sequence' => 'kārtošanas secība',
        'Order by' => 'Kārtot pēc',
        'Limit' => 'Limits',
        'Ticketlist' => 'Pieteikumu saraksts',
        'ascending' => 'pieaugoša',
        'descending' => 'dilstoša',
        'First Lock' => 'Pirmo reizi aizslēgts',
        'Evaluation by' => 'Izvērtējis',
        'Total Time' => 'Kopējais laiks',
        'Ticket Average' => 'Vidējais pieteikuma ilgums',
        'Ticket Min Time' => 'Minimālais pieteikuma ilgums',
        'Ticket Max Time' => 'Maksimālais pieteikuma ilgums',
        'Number of Tickets' => 'Pieteikumu skaits',
        'Article Average' => 'Vidējais pieteikuma ilgums',
        'Article Min Time' => 'Minimālais pieteikuma ilgums',
        'Article Max Time' => 'Maksimālais pieteikuma ilgums',
        'Number of Articles' => 'Pieteikumu skaits',
        'Accounted time by Agent' => 'Uzskaitītais laiks aģentam',
        'Ticket/Article Accounted Time' => 'Uzskaitītais laiks pieteikumam/ziņojumam',
        'TicketAccountedTime' => 'Pieteikumu uzskaitītais laiks',
        'Ticket Create Time' => 'Pieteikuma izveidošanas laiks',
        'Ticket Close Time' => 'Pieteikuma aizvēršanas laiks',

        # Template: AAATicket
        'Lock' => 'Aizslēgt',
        'Unlock' => 'Atslēgt',
        'History' => 'Vēsture',
        'Zoom' => 'Atvērt vaļā',
        'Age' => 'Atvērts jau',
        'Bounce' => 'Pārcelt',
        'Forward' => 'Pārsūtīt',
        'From' => 'No',
        'To' => 'Kam',
        'Cc' => 'Kopija',
        'Bcc' => 'Diskrētā kopija',
        'Subject' => 'Tēma',
        'Move' => 'Pārvietot',
        'Queue' => 'Rinda',
        'Priority' => 'Prioritāte',
        'Priority Update' => 'Prioritāte mainīta',
        'State' => 'Statuss',
        'Compose' => 'Izveidot',
        'Pending' => 'Neizlemts',
        'Owner' => 'Īpašnieks',
        'Owner Update' => 'Īpašnieks mainīts',
        'Responsible' => 'Atbildīgais',
        'Responsible Update' => 'Atbildīgais mainīts',
        'Sender' => 'Nosūtītājs',
        'Article' => 'Ziņojums',
        'Ticket' => 'Pieteikumi',
        'Createtime' => 'Izveidošanas laiks',
        'plain' => 'vienkāršs teksts',
        'Email' => 'E-pasts',
        'email' => 'e-pasts',
        'Close' => 'Aizvērt',
        'Action' => 'Darbība',
        'Attachment' => 'Pielikums',
        'Attachments' => 'Pielikumi',
        'This message was written in a character set other than your own.' => 'Šis ziņojums ir rakstīts citā rakstzīmju kodējumā nekā pašlaik izmantotais.',
        'If it is not displayed correctly,' => 'Ja tas netiek parādīts pareizi,',
        'This is a' => 'Tas ir',
        'to open it in a new window.' => 'lai atvērtu jaunā logā',
        'This is a HTML email. Click here to show it.' => 'Šis ir HTML e-pasts. Klikšķiniet šeit, lai atvērtu to jaunā pārlūkprogrammas logā.',
        'Free Fields' => 'Neaizpildītie lauki',
        'Merge' => 'Apvienot',
        'merged' => 'apvienotie',
        'closed successful' => 'aizvērta, atrisināta',
        'closed unsuccessful' => 'aizvērta, neatrisināta',
        'new' => 'jauna',
        'open' => 'atvērta',
        'Open' => 'Atvērta',
        'closed' => 'aizvērta',
        'Closed' => 'Aizvērta',
        'removed' => 'aizvākta',
        'pending reminder' => 'neizlemts - gaida atgādinājumu',
        'pending auto' => 'gaida automātisku darbību',
        'pending auto close+' => 'gaida automātisku aizvēršanu+',
        'pending auto close-' => 'gaida automātisku aizvēršanu-',
        'email-external' => 'ārējs e-pasts',
        'email-internal' => 'iekšējs e-pasts',
        'note-external' => 'ārēja piezīme',
        'note-internal' => 'iekšēja piezīme',
        'note-report' => 'piezīmju pārskats',
        'phone' => 'telefona zvans',
        'sms' => 'sms',
        'webrequest' => 'no pārlūkprogrammas veidots pieteikums',
        'lock' => 'aizslēgt',
        'unlock' => 'atslēgt',
        'very low' => 'ļoti zema',
        'low' => 'zema',
        'normal' => 'normāla',
        'high' => 'augsta',
        'very high' => 'ļoti augsta',
        '1 very low' => '1 ļoti zema',
        '2 low' => '2 zema',
        '3 normal' => '3 normāla',
        '4 high' => '4 augsta',
        '5 very high' => '5 ļoti augsta',
        'Ticket "%s" created!' => 'Problēmas pieteikums "%s" izveidots!',
        'Ticket Number' => 'Pieteikuma numurs',
        'Ticket Object' => 'Pieteikuma objekts (?)',
        'No such Ticket Number "%s"! Can\'t link it!' => 'Nevar atrast šādu problēmas pieteikuma numuru "%s"! Nav iespējams to piesaistīt!',
        'Don\'t show closed Tickets' => 'Nerādīt atvērtos problēmu pieteikumus',
        'Show closed Tickets' => 'Rādīt atvērtos problēmu pieteikumus',
        'New Article' => 'Jauns ziņojums',
        'Email-Ticket' => 'Pieteikums ar e-pastu',
        'Create new Email Ticket' => 'Izveidot jaunu problēmas pieteikumu ar e-pastu',
        'Phone-Ticket' => 'Telefonisks pieteikums',
        'Search Tickets' => 'Meklēt pieteikumos',
        'Edit Customer Users' => 'Labot klientu datus',
        'Edit Customer Company' => 'Labot klientu organizāciju/uzņēmumu datus',
        'Bulk-Action' => 'Labot vairākus',
        'Bulk Actions on Tickets' => 'Veikt darbības ar vairākiem pieteikumiem uzreiz',
        'Send Email and create a new Ticket' => 'Nosūtīt e-pastu un izveidot jaunu problēmas pieteikumu',
        'Create new Email Ticket and send this out (Outbound)' => 'Izveidot jaunu problēmas pieteikumu ar e-pastu un to izsūtīt (izejošs)',
        'Create new Phone Ticket (Inbound)' => 'Izveidot jaunu telefonisku problēmas pieteikumu (ienākošs)',
        'Overview of all open Tickets' => 'Pārskats par visiem atvērtajiem problēmu pieteikumiem',
        'Locked Tickets' => 'Aizslēgtie pieteikumi',
        'Watched Tickets' => 'Vērotie pieteikumi',
        'Watched' => 'Vērots',
        'Subscribe' => 'Parakstīties',
        'Unsubscribe' => 'Beigt parakstīšanos',
        'Lock it to work on it!' => 'Aizslēgt pieteikumu lai ar to strādātu!',
        'Unlock to give it back to the queue!' => 'Atslēgt pieteikumu lai varētu to atgriezt atpakaļ rindā!',
        'Shows the ticket history!' => 'Parādīt problēmas pieteikuma vēsturi!',
        'Print this ticket!' => 'Drukāt šo pieteikumu!',
        'Change the ticket priority!' => 'Mainīt pieteikuma prioritāti!',
        'Change the ticket free fields!' => 'Mainīt pieteikuma neaizpildītos laukus',
        'Link this ticket to an other objects!' => 'Piesaistīt šo pieteikumu citiem objektiem!',
        'Change the ticket owner!' => 'Mainīt pieteikuma īpašnieku (atbildīgo)!',
        'Change the ticket customer!' => 'Mainīt pieteikuma pieteicēju (klientu)!',
        'Add a note to this ticket!' => 'Pievienot pieteikumam piezīmi!',
        'Merge this ticket!' => 'Apvienot šo pieteikumu (ar citu)!',
        'Set this ticket to pending!' => 'Iestatīt šim pieteikumam statusu \'neizlemts\'!',
        'Close this ticket!' => 'Aizvērt pieteikumu!',
        'Look into a ticket!' => 'Apskatīt pieteikumu!',
        'Delete this ticket!' => 'Dzēst šo pieteikumu!',
        'Mark as Spam!' => 'Iezīmēt kā mēstuli (spamu)!',
        'My Queues' => 'Manas rindas',
        'Shown Tickets' => 'Parādītie pieteikumi',
        'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' => 'Jūsu e-pasts ar pieteikuma numuru "<OTRS_TICKET>" ir apvienots ar pieteikumu nr. "<OTRS_MERGE_TO_TICKET>"!',
        'Ticket %s: first response time is over (%s)!' => 'Pieteikums %s: reakcijas laiks ir lielāks par (%s)!',
        'Ticket %s: first response time will be over in %s!' => 'Pieteikums %s: reakcijas laiks beigsies %s!',
        'Ticket %s: update time is over (%s)!' => 'Pieteikums %s: atjaunošanas (labošanas) laiks ir lielāks par (%s)!',
        'Ticket %s: update time will be over in %s!' => 'Pieteikums %s: atjaunošanas (labošanas) laiks beigsies %s!',
        'Ticket %s: solution time is over (%s)!' => 'Pieteikums %s: atrisināšanas laiks ir lielāks par (%s)!',
        'Ticket %s: solution time will be over in %s!' => 'Pieteikums %s: atrisināšanas laiks beigsies %s!',
        'There are more escalated tickets!' => 'Ir vēl citi problēmu pieteikumi ar paaugstinātu svarīgumu (?)!',
        'New ticket notification' => 'Jauna pieteikuma paziņojums',
        'Send me a notification if there is a new ticket in "My Queues".' => 'Sūtīt man paziņojumu ja manās rindās parādās jauns pieteikums.',
        'Follow up notification' => 'Sekošanas paziņojums',
        'Send me a notification if a customer sends a follow up and I\'m the owner of the ticket or the ticket is unlocked and is in one of my subscribed queues.' => 'Sūtīt man paziņojumu, ja klients nosūta papildinformāciju un es esmu šī pieteikuma īpašnieks.',
        'Ticket lock timeout notification' => 'Pieteikuma slēgšanas noilguma paziņojums',
        'Send me a notification if a ticket is unlocked by the system.' => 'Sūtīt man paziņojumu, ja sistēma ir atslēgusi pieteikumu.',
        'Move notification' => 'Pārvietošanas paziņojums',
        'Send me a notification if a ticket is moved into one of "My Queues".' => 'Nosūtīt man paziņojumu, ja pieteikums pārvietots uz kādu no "Manām rindām".',
        'Your queue selection of your favourite queues. You also get notified about those queues via email if enabled.' => 'Izvēlētās prioritārās rindas. Ja ir iestatīts, tad jūs saņemsiet par šīm rindām paziņojumus arī e-pastā.',
        'Custom Queue' => 'Pielāgota rinda',
        'QueueView refresh time' => 'Rindas skata atjaunināšanas laiks',
        'Screen after new ticket' => 'Ekrāns pēc jauna pieteikuma izveidošanas',
        'Select your screen after creating a new ticket.' => 'Izvēlieties ekrāna izskatu pēc jauna pieteikuma izveidošanas.',
        'Closed Tickets' => 'Aizvērtie pieteikumi',
        'Show closed tickets.' => 'Rādīt aizvērtos pieteikumus.',
        'Max. shown Tickets a page in QueueView.' => 'Maksimālais parādīto pieteikumu skaits rindas skatā (pieteikumu sarakstā).',
        'Watch notification' => 'Vērošanas paziņojums',
        'Send me a notification of an watched ticket like an owner of an ticket.' => 'Nosūtīt man vērotā pieteikuma paziņojumu kā pieteikuma īpašniekam.',
        'Out Of Office' => 'Ārpus biroja',
        'Select your out of office time.' => 'Iestatiet laiku, kurā neatrodieties birojā.',
        'CompanyTickets' => 'Organizācijas/uzņēmuma pieteikumi',
        'MyTickets' => 'Mani pieteikumi',
        'New Ticket' => 'Jaunie pieteikumi',
        'Create new Ticket' => 'Izveidot jaunu pieteikumu',
        'Customer called' => 'Klienta zvans',
        'phone call' => 'telefona zvans',
        'Reminder Reached' => 'Sasniegts atgādinājuma laiks',
        'Reminder Tickets' => 'Pieteikumi ar atgādinājumiem',
        'Escalated Tickets' => 'Eskalētie pieteikumi',
        'New Tickets' => 'Jaunie pieteikumi',
        'Open Tickets / Need to be answered' => 'Atvētie pieteikumi/nepieciešama atbilde',
        'Tickets which need to be answered!' => 'Pieteikumi, uz kuriem nepieciešams atbildēt',
        'All new tickets!' => 'Visi jaunie pieteikumi',
        'All tickets which are escalated!' => 'Visi eskalētie pieteikumi',
        'All tickets where the reminder date has reached!' => 'Visi pieteikumi, kuriem pienācis atgādinājuma datums',
        'Responses' => 'Atbildes',
        'Responses <-> Queue' => 'Atbildes <-> Rindas',
        'Auto Responses' => 'Automātiskas atbildes',
        'Auto Responses <-> Queue' => 'Automātiskas atbildes <-> Rindas',
        'Attachments <-> Responses' => 'Pielikumi <-> Atbildes',
        'History::Move' => 'Problēmas pieteikums ievietots rindā "%s" (%s) pārceļot no rindas "%s" (%s).',
        'History::TypeUpdate' => 'Tips mainīts uz %s (ID=%s).',
        'History::ServiceUpdate' => 'Serviss mainīts uz%s (ID=%s).',
        'History::SLAUpdate' => 'SLA mainīts uz %s (ID=%s).',
        'History::NewTicket' => 'Izveidots jauns problēmas pieteikums [%s] (Q=%s;P=%s;S=%s).',
        'History::FollowUp' => 'Sekošana pieteikumam [%s]. %s',
        'History::SendAutoReject' => 'Uz "%s" nosūtīts automātisks problēmas pieteikuma noraidījums.',
        'History::SendAutoReply' => 'Uz "%s" nosūtīta automātiska atbilde.',
        'History::SendAutoFollowUp' => 'Uz "%s" nosūtīta automātiska sekošanas atbilde.',
        'History::Forward' => 'Pārsūtīts uz "%s".',
        'History::Bounce' => 'Ziņojums pārcelts pie "%s".',
        'History::SendAnswer' => 'Uz "%s" nosūtīts e-pasts.',
        'History::SendAgentNotification' => '"%s"-paziņojums nosūtīts uz "%s".',
        'History::SendCustomerNotification' => 'Uz "%s" nosūtīts paziņojums.',
        'History::EmailAgent' => 'Klientam nosūtīts e-pasts.',
        'History::EmailCustomer' => 'E-pasts pievienots. %s',
        'History::PhoneCallAgent' => 'Darbinieka zvans klientam.',
        'History::PhoneCallCustomer' => 'Klienta zvans mums.',
        'History::AddNote' => 'Pievienota piezīme (%s)',
        'History::Lock' => 'Problēmas pieteikums aizslēgts.',
        'History::Unlock' => 'Problēmas pieteikums atslēgts.',
        'History::TimeAccounting' => 'Uzskaitītas %s laika vienība(s). Tagad kopējais laiks ir %s laika vienība(s).',
        'History::Remove' => '%s dzēsts.',
        'History::CustomerUpdate' => 'Labots: %s',
        'History::PriorityUpdate' => 'Prioritāte mainīta no "%s" (%s) uz "%s" (%s).',
        'History::OwnerUpdate' => 'Jaunais atbildīgas par problēmu ir "%s" (ID=%s).',
        'History::LoopProtection' => 'Cilpas aizsardzība! Automātiska atbilde uz "%s" nav nosūtīta.',
        'History::Misc' => '%s',
        'History::SetPendingTime' => 'Neizlemts līdz: %s',
        'History::StateUpdate' => 'Vecais: "%s" Jaunais: "%s"',
        'History::TicketFreeTextUpdate' => 'Labots: %s=%s;%s=%s;',
        'History::WebRequestCustomer' => 'Klienta pieprasījums no pārlūkprogrammas.',
        'History::TicketLinkAdd' => 'Pievienota saite uz problēmas ziņojumu "%s".',
        'History::TicketLinkDelete' => 'Dzēsta saite uz problēmas ziņojumu "%s".',
        'History::Subscribe' => 'Pievienota sekošana lietotājam "%s".',
        'History::Unsubscribe' => 'Noņemta sekošana lietotājam "%s".',
        'History::SystemRequest' => 'Sistēmas pieprasījums (%s).',

        # Template: AAAWeekDay
        'Sun' => 'Sv',
        'Mon' => 'Pi',
        'Tue' => 'Ot',
        'Wed' => 'Tr',
        'Thu' => 'Ce',
        'Fri' => 'Pk',
        'Sat' => 'Se',

        # Template: AdminAttachmentForm
        'Attachment Management' => 'Pielikumu pārvaldība',

        # Template: AdminAutoResponseForm
        'Auto Response Management' => 'Automātisko atbilžu pārvaldība',
        'Response' => 'Atbilde',
        'Auto Response From' => 'Automātiska atbilde no',
        'Note' => 'Piezīme(s)',
        'Useable options' => 'Izmantojamie iestatījumi',
        'To get the first 20 character of the subject.' => 'Lai saņemtu pirmās 20 rakstzīmes no pieteikuma tēmas',
        'To get the first 5 lines of the email.' => 'Lai saņemtu pirmās 5 rindiņas no e-pasta',
        'A web calendar' => 'Kalendārs',
        'To get the realname of the sender (if given).' => 'Lai saņemtu nosūtītāja īsto vārdu (ja norādīts).',
        'To get the article attribute (e. g. (<OTRS_CUSTOMER_From>, <OTRS_CUSTOMER_To>, <OTRS_CUSTOMER_Cc>, <OTRS_CUSTOMER_Subject> and <OTRS_CUSTOMER_Body>).' => 'Lai saņemtu pieteikuma atribūtus (piem. (<OTRS_CUSTOMER_From>, <OTRS_CUSTOMER_To>, <OTRS_CUSTOMER_Cc>, <OTRS_CUSTOMER_Subject> un <OTRS_CUSTOMER_Body>).',
        'Options of the current customer user data (e. g. <OTRS_CUSTOMER_DATA_UserFirstname>).' => 'Tekošā klienta dati (piem. <OTRS_CUSTOMER_DATA_UserFirstname>)',
        'Ticket owner options (e. g. <OTRS_OWNER_UserFirstname>).' => 'Pieteikuma īpašnieka dati (piem. <OTRS_OWNER_UserFirstname>).',
        'Ticket responsible options (e. g. <OTRS_RESPONSIBLE_UserFirstname>).' => 'Pieteikuma atbildes dati (piem. <OTRS_RESPONSIBLE_UserFirstname>).',
        'Options of the current user who requested this action (e. g. <OTRS_CURRENT_UserFirstname>).' => 'Darbības pieprasītāja lietotāja dati (piem. <OTRS_CURRENT_UserFirstname).',
        'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>).' => 'Pieteikuma īpašību dati (piem. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>).',
        'Config options (e. g. <OTRS_CONFIG_HttpType>).' => 'Konfigurācijas dati (piem. <OTRS_CONFIG_HttpType).',

        # Template: AdminCustomerCompanyForm
        'Customer Company Management' => 'Klienta organizāciju/uzņēmumu datu pārvaldība',
        'Search for' => 'Meklēt pēc',
        'Add Customer Company' => 'Pievienot klienta organizāciju/uzņēmumu',
        'Add a new Customer Company.' => 'Pievienot jaunu klienta organizāciju/uzņēmumu.',
        'List' => 'Saraksts',
        'This values are required.' => 'Šīs vērtības ir obligātas (jāaizpilda obligāti).',
        'This values are read only.' => 'Šīs vērtības ir pieejamas tikai lasīšanai.',

        # Template: AdminCustomerUserForm
        'The message being composed has been closed.  Exiting.' => 'Aktīvais ziņojums ir ticis aizvērts. Izejam.',
        'This window must be called from compose window' => 'Šis logs jāizsauc no ziņojuma sastādīšanas loga',
        'Customer User Management' => 'Klientu datu pārvaldība',
        'Add Customer User' => 'Pievienot klienta datus',
        'Source' => 'Dati no',
        'Create' => 'Izveidot',
        'Customer user will be needed to have a customer history and to login via customer panel.' => 'Klienta lietotājvārds ir nepieciešams lai saglabātu klienta vēstures datus un lai pieteiktos sistēmā.',

        # Template: AdminCustomerUserGroupChangeForm
        'Customer Users <-> Groups Management' => 'Klientu grupu <-> Grupu pārvaldība',
        'Change %s settings' => 'Mainīt %s iestatījumus',
        'Select the user:group permissions.' => 'Izvēlēties lietotāju:grupu tiesības.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the user).' => 'Ja nekas nav iestatīts, tad šajā grupā lietotājam nav tiesību (lietotājam pieteikumi nebūs pieejami).',
        'Permission' => 'Tiesības',
        'ro' => 'lasīt',
        'Read only access to the ticket in this group/queue.' => 'Tikai pieteikumu lasīšanas tiesības šajā grupā/rindā.',
        'rw' => 'rakstīt',
        'Full read and write access to the tickets in this group/queue.' => 'Visas lasīšanas un rakstīšanas tiesības šajā grupā/rindā.',

        # Template: AdminCustomerUserGroupForm

        # Template: AdminCustomerUserService
        'Customer Users <-> Services Management' => 'Klientu <-> Servisu pārvaldība',
        'CustomerUser' => 'Klienti',
        'Service' => 'Servisi',
        'Edit default services.' => 'Labot noklusētos servisus.',
        'Search Result' => 'Meklēšanas rezultāti',
        'Allocate services to CustomerUser' => 'Pievienot klientam servisus',
        'Active' => 'Aktīvs',
        'Allocate CustomerUser to service' => 'Pievienot klientus servisam',

        # Template: AdminEmail
        'Message sent to' => 'Ziņojums nosūtīts',
        'A message should have a subject!' => 'Ziņojumam jābūt tēmai!',
        'Recipients' => 'Saņēmēji',
        'Body' => 'Saturs',
        'Send' => 'Nosūtīt',

        # Template: AdminGenericAgent
        'GenericAgent' => 'Vispārīgais uzdevums',
        'Job-List' => 'Uzdevumu saraksts',
        'Last run' => 'Pēdējo reizi izpildīts',
        'Run Now!' => 'Izpildīt tagad!',
        'x' => 'x',
        'Save Job as?' => 'Saglabāt uzdevumu kā...',
        'Is Job Valid?' => 'Vai uzdevums ir derīgs?',
        'Is Job Valid' => 'Vai uzdevums ir derīgs',
        'Schedule' => 'Grafiks',
        'Currently this generic agent job will not run automatically.' => 'Pašlaik šis vispārīgais aģenta uzdevums neizpildīsies automātiski.',
        'To enable automatic execution select at least one value from minutes, hours and days!' => 'Lai iestatītu automātisku izpildi, izvēlieties vismaz vienu vērtību no minūtēm, stundām un dienām!',
        'Fulltext-Search in Article (e. g. "Mar*in" or "Baue*")' => 'Meklēšana visā ziņojuma tekstā (piem. "Mar*in" vai "Neva*")',
        '(e. g. 10*5155 or 105658*)' => 'piem. 10*5144 vai 105658*',
        '(e. g. 234321)' => 'piem. 234321',
        'Customer User Login' => 'Klienta pieteikšanās sistēmā',
        '(e. g. U5150)' => 'piem. U5150',
        'SLA' => 'Servisa līmeņa līgums',
        'Agent' => 'Aģents (pieteikumu apstrādātājs)',
        'Ticket Lock' => 'Pieteikuma slēgšanas pazīme',
        'TicketFreeFields' => 'Pieteikuma neaizpildītie lauki',
        'Create Times' => 'Izveidošanas laiki',
        'No create time settings.' => 'Nav izveidošanas laika iestatījumu',
        'Ticket created' => 'Pieteikums izveidots',
        'Ticket created between' => 'Pieteikums izveidots starp',
        'Close Times' => 'Aizvēršanas laiki',
        'No close time settings.' => 'Nav aizvēršanas laika iestatījumu',
        'Ticket closed' => 'Pieteikums aizvērts',
        'Ticket closed between' => 'Pieteikums aizvērts starp ',
        'Pending Times' => 'Izlemšanas laiki',
        'No pending time settings.' => 'Nav izlemšanas laika iestatījumu',
        'Ticket pending time reached' => 'Pienācis pieteikuma izlemšanas laiks',
        'Ticket pending time reached between' => 'Pieteikuma izlemšanas laiks sasniegts starp',
        'Escalation Times' => 'Eskalācijas laiki',
        'No escalation time settings.' => 'Eskalācijas laiki nav iestatīti',
        'Ticket escalation time reached' => 'Pienācis pieteikuma eskalācijas laiks',
        'Ticket escalation time reached between' => 'Pieteikuma eskalācijas laiks pienācis starp',
        'Escalation - First Response Time' => 'Eskalācija - pirmās atbildes laiks',
        'No escalation time settings.' => 'Eskalācijas laiki nav iestatīti.',
        'Ticket first response time reached' => 'Pienācis pieteikuma pirmās atbildes laiks',
        'Ticket first response time reached between' => 'Pieteikuma pirmās atbildes laiks pienācis starp',
        'Escalation - Update Time' => 'Eskalācija - atjaunošanas laiks',
        'Ticket update time reached' => 'Pienācis pieteikuma atjaunošanas laiks',
        'Ticket update time reached between' => 'Pieteikuma atjaunošanas laiks pienācis starp',
        'Escalation - Solution Time' => 'Eskalācija - atrisināšanas laiks',
        'Ticket solution time reached' => 'Pienācis pieteikuma atrisināšanas laiks',
        'Ticket solution time reached between' => 'Pieteikuma atrisināšanas laiks pienācis starp',
        'New Service' => 'Jauns serviss',
        'New SLA' => 'Jauns servisa līmeņa līgums',
        'New Priority' => 'Jauna prioritāte',
        'New Queue' => 'Jauna rinda',
        'New State' => 'Jauns statuss',
        'New Agent' => 'Jauns aģents',
        'New Owner' => 'Jauns īpašnieks',
        'New Customer' => 'Jauns klients',
        'New Ticket Lock' => 'Jauna pieteikuma slēgšanas zīme',
        'New Type' => 'Jauns tips',
        'New Title' => 'Jauns virsraksts',
        'New TicketFreeFields' => 'Jauni pieteikuma neaizpildītie lauki',
        'Add Note' => 'Pievienot piezīmi',
        'Time units' => 'Laika vienības',
        'CMD' => 'Komanda',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' => 'Šī komanda tiks izpildīta. ARG[0] būs pieteikuma numurs un ARG[1] būs pieteikuma identifikators (ID).',
        'Delete tickets' => 'Dzēst pieteikumus',
        'Warning! This tickets will be removed from the database! This tickets are lost!' => 'Brīdinājums! Šie pieteikumi tiks dzēsti no datubāzes! Pieteikumi tiks zaudēti!',
        'Send Notification' => 'Sūtīt paziņojumu',
        'Param 1' => 'Parametrs 1',
        'Param 2' => 'Parametrs 2',
        'Param 3' => 'Parametrs 3',
        'Param 4' => 'Parametrs 4',
        'Param 5' => 'Parametrs 5',
        'Param 6' => 'Parametrs 6',
        'Send agent/customer notifications on changes' => 'Izmaiņu gadījumā nosūtīt paziņojumus aģentam/klientam',
        'Save' => 'Saglabāt',
        '%s Tickets affected! Do you really want to use this job?' => 'Tiks mainīti %s pieteikumi! Vai tiešām vēlaties izpildīt šo uzdevumu?',

        # Template: AdminGroupForm
        'WARNING: When you change the name of the group \'admin\', before making the appropriate changes in the SysConfig, you will be locked out of the administrations panel! If this happens, please rename the group back to admin per SQL statement.' => 'BRĪDINĀJUMS! Ja pirms grupas \'admin\' pārdēvēšanas citā vārdā netiks izdarītas izmaiņas sistēmas konfigurācijā, nebūs iespējams pieteikties administrēšanas sadaļā! Ja tā ir gadījies, pārdēvējiet grupu atpakaļ par admin ar SQL teikuma palidzību.',
        'Group Management' => 'Grupu pārvaldība',
        'Add Group' => 'Pievienot grupu',
        'Add a new Group.' => 'Pievienot jaunu grupu.',
        'The admin group is to get in the admin area and the stats group to get stats area.' => '\'admin\' grupa domāta lai darbotos administrēšanas sadaļā un \'stats\' grupa lai darbotos statistikas sadaļā.',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).' => 'Veidojiet jaunas grupas, lai pārvaldītu pieejas tiesības dažādām aģentu grupām (piemēram iepirkumu daļai, atbalsta daļai, pārdošanas daļai, utt.).',
        'It\'s useful for ASP solutions.' => 'Izmantojams ASP-risinājumiem.',

        # Template: AdminLog
        'System Log' => 'Sistēmas žurnāls',
        'Time' => 'Laiks',

        # Template: AdminMailAccount
        'Mail Account Management' => 'Pasta kontu pārvaldība',
        'Host' => 'Resursdators',
        'Trusted' => 'Uzticams',
        'Dispatching' => 'Nosūtīšana',
        'All incoming emails with one account will be dispatched in the selected queue!' => 'Visi ienākošie e-pasta ziņojumi ar vienu un to pašu lietotāja kontu tiks pārsūtīti uz norādīto rindu!',
        'If your account is trusted, the already existing X-OTRS header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' => 'Ja jūsu konts ir uzticams, tad prioritātēm un citur tiks izmantoti jau ziņojuma pienākšanas laikā eksistējošie X-OTRS hederi (galvenes). Neatkarīgi no tā tiks izmantots arī Postmaster filtrs.',

        # Template: AdminNavigationBar
        'Users' => 'Lietotāji',
        'Groups' => 'Grupas',
        'Misc' => 'Dažādi',

        # Template: AdminNotificationEventForm
        'Notification Management' => 'Paziņojumu pārvaldība',
        'Add Notification' => 'Pievienot paziņojumu',
        'Add a new Notification.' => 'Pievienojiet jaunu paziņojumu.',
        'Name is required!' => 'Vārds ir obligāts!',
        'Event is required!' => 'Notikums ir obligāts!',
        'A message should have a body!' => 'Ziņojumam jābūt saturam!',
        'Recipient' => 'Saņēmējs',
        'Group based' => 'Grupām',
        'Recipient' => 'Saņēmējs',
        'Agent based' => 'Aģentiem',
        'Email based' => 'E-pasta ziņojumiem',
        'Article Type' => 'Ziņojuma tips',
        'Only for ArticleCreate Event.' => 'Tikai ziņojuma izveidošanas notikumam.',
        'Subject match' => 'Sakrīt tēma',
        'Only for ArticleCreate Event.' => 'Tikai ziņojuma izveidošanas notikumam.',
        'Body match' => 'Sakrīt saturs',
        'Notifications are sent to an agent or a customer.' => 'Paziņojumi tiek nosūtīti aģentam vai klientam.',
        'To get the first 20 character of the subject (of the latest agent article).' => 'Lai saņemtu pirmās 20 rakstzīmes no tēmas (no pēdējā aģenta ziņojuma)',
        'To get the first 5 lines of the body (of the latest agent article).' => 'Lai saņemtu pirmās 5 satura rindas (no pēdējā aģenta ziņojuma)',
        'To get the article attribute (e. g. (<OTRS_AGENT_From>, <OTRS_AGENT_To>, <OTRS_AGENT_Cc>, <OTRS_AGENT_Subject> and <OTRS_AGENT_Body>).' => 'Lai saņemtu ziņojuma atribūtus (piem. <OTRS_AGENT_From>, <OTRS_AGENT_To>, <OTRS_AGENT_Cc>, <OTRS_AGENT_Subject> un <OTRS_AGENT_Body>).',
        'To get the first 20 character of the subject (of the latest customer article).' => 'Lai saņemtu pirmās 20 rakstzīmes no tēmas (no pēdējā klienta ziņojuma).',
        'To get the first 5 lines of the body (of the latest customer article).' => 'Lai saņemtu pirmās 5 satura rindas (no pēdējā klienta ziņojuma)',

        # Template: AdminNotificationForm
        'Notification' => 'Paziņojumi',

        # Template: AdminPackageManager
        'Package Manager' => 'Pakotņu pārvaldība',
        'Uninstall' => 'Noņemt',
        'Version' => 'Versija',
        'Do you really want to uninstall this package?' => 'Vai tiešām vēlaties noņemt šo pakotni?',
        'Reinstall' => 'Pārinstalēt',
        'Do you really want to reinstall this package (all manual changes get lost)?' => 'Vai tiešām vēlaties pārinstalēt šo pakotni (visas izdarītās izmaiņas tiks zaudētas)?',
        'Continue' => 'Turpināt',
        'Install' => 'Instalēt',
        'Package' => 'Pakotne',
        'Online Repository' => 'Tiešsaistes repozitorijs',
        'Vendor' => 'Piegādātājs',
        'Module documentation' => 'Moduļa dokumentācija',
        'Upgrade' => 'Jaunināt',
        'Local Repository' => 'Lokālais repozitorijs',
        'Status' => 'Statuss',
        'Overview' => 'Pārskats',
        'Download' => 'Lejupielādēt',
        'Rebuild' => 'Pārbūvēt',
        'ChangeLog' => 'Izmaiņu saraksts',
        'Date' => 'Datums',
        'Filelist' => 'Failu (datņu) saraksts',
        'Download file from package!' => 'Lejupielādēt failu (datni) no pakotnes!',
        'Required' => 'Pieprasīts',
        'PrimaryKey' => 'Primārā atslēga',
        'AutoIncrement' => 'Autopieaugums',
        'SQL' => 'SQL',
        'Diff' => 'Atšķirības',

        # Template: AdminPerformanceLog
        'Performance Log' => 'Veiktspējas žurnāls',
        'This feature is enabled!' => 'Šī iespēja ir aktivizēta!',
        'Just use this feature if you want to log each request.' => 'Lietojiet šo iespēju lai žurnalētu katru pieprasījumu.',
        'Activating this feature might affect your system performance!' => 'Šīs iespējas aktivizēšana var negatīvi ietekmēt sistēmas veiktspēju.',
        'Disable it here!' => 'Atiestatīt šeit!',
        'This feature is disabled!' => 'Šī iespēja ir atiestatīta!',
        'Enable it here!' => 'Aktivizēt šeit!',
        'Logfile too large!' => 'Žurnāla fails ir pārāk liels!',
        'Logfile too large, you need to reset it!' => 'Žurnāla fails ir pārāk liels, jums jāsamazina tā izmērs!',
        'Range' => 'Intervāls',
        'Interface' => 'Interfeiss',
        'Requests' => 'Pieprasījumi',
        'Min Response' => 'Min. atbildes laiks',
        'Max Response' => 'Maks. atbildes laiks',
        'Average Response' => 'Vidējais atbildes laiks',
        'Period' => 'Periods',
        'Min' => 'Min.',
        'Max' => 'Maks.',
        'Average' => 'Vidēji',

        # Template: AdminPGPForm
        'PGP Management' => 'PGP pārvaldība',
        'Result' => 'Rezultāts',
        'Identifier' => 'Identifikātors',
        'Bit' => 'Bits',
        'Key' => 'Atslēga',
        'Fingerprint' => 'Identificētājsumma',
        'Expires' => 'Darbības termiņš',
        'In this way you can directly edit the keyring configured in SysConfig.' => 'Šādi var tieši labot ar sistēmas konfigurāciju (SysConfig) izveidoto atslēgu saišķi.',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => 'PostMaster\'a filtru pārvaldība',
        'Filtername' => 'Filtra nosaukums',
        'Stop after match' => 'Pārtraukt pēc sakritības',
        'Match' => 'Sakritība',
        'Value' => 'Vērtība',
        'Set' => 'Uzstādīt',
        'Do dispatch or filter incoming emails based on email X-Headers! RegExp is also possible.' => 'Pārvietot vai filtrēt ienākošos e-pastus pēc to X-hederiem (galvenēm). Pieļaujamas arī regulārās izteiksmes (regexp).',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' => 'Ja vēlaties, lai sakristu tikai e-pasta adrese, izmantojiet EMAILADDRESS:info@example.com No, Kam vai Kopija laukos.',
        'If you use RegExp, you also can use the matched value in () as [***] in \'Set\'.' => 'Lietojot regulārās izteiksmes (regexp), var izmantot arī sakrītošo vērtību kā [***] zem \'Uzstādīt\'.',

        # Template: AdminPriority
        'Priority Management' => 'Prioritāšu pārvaldība',
        'Add Priority' => 'Pievienot prioritāti',
        'Add a new Priority.' => 'Pievienot jaunu prioritāti.',

        # Template: AdminQueueAutoResponseForm
        'Queue <-> Auto Responses Management' => 'Rindu <-> Automātisko atbilžu pārvaldība',
        'settings' => 'Iestatījumi',

        # Template: AdminQueueForm
        'Queue Management' => 'Rindu pārvaldība',
        'Sub-Queue of' => 'apakšrinda',
        'Unlock timeout' => 'Atslēgšanas noilgums',
        '0 = no unlock' => '0 = neatslēgt',
        'Only business hours are counted.' => 'Tiek uzskaitītas tikai darbalaika stundas.',
        '0 = no escalation' => '0 = netiek eskalēts',
        'Notify by' => 'Paziņot ar',
        'Follow up Option' => 'Sekošanas iespēja',
        'Ticket lock after a follow up' => 'Pieteikuma slēgšana pēc sekošanas',
        'Systemaddress' => 'Sistēmas adrese',
        'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.' => 'Ja aģents slēdz pieteikumu un neatbild līdz šī laika beigām, pieteikums tiks automātiski atslēgts. Tātad pieteikums būs atkal redzams visiem aģentiem.',
        'Escalation time' => 'Eskalācijas laiks',
        'If a ticket will not be answered in this time, just only this ticket will be shown.' => 'Ja uz pieteikumu netiks atbildēts līdz ši laika beigām, tiks parādīts tikai šis pieteikums.',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.' => 'Ja pieteikums ir aizvērts un klients ir nosūtījis papildinājumu, pieteikums tiks aizslēgts, saglabājot iepriekšējo īpašnieku.',
        'Will be the sender address of this queue for email answers.' => 'E-pasta atbildēm izmantos šīs rindas nosūtītāja adresi.',
        'The salutation for email answers.' => 'Uzruna e-pasta atbildēm.',
        'The signature for email answers.' => 'Paraksts e-pasta atbildēm.',
        'Customer Move Notify' => 'Paziņojums klientam par pieteikuma pārvietošanu',
        'OTRS sends an notification email to the customer if the ticket is moved.' => 'Ja pieteikums tiks pārvietots, OTRS problēmu pieteikumu sistēma nosūtīs klientam e-pasta paziņojumu.',
        'Customer State Notify' => 'Paziņojums klientam par statusa maiņu',
        'OTRS sends an notification email to the customer if the ticket state has changed.' => 'Ja tiks mainīts pieteikuma statuss, OTRS problēmu pieteikumu sistēma nosūtīs klientam e-pasta paziņojumu.',
        'Customer Owner Notify' => 'Paziņojums klientam par pieteikuma īpašnieka maiņu',
        'OTRS sends an notification email to the customer if the ticket owner has changed.' => 'Ja  tiks mainīts pieteikuma īpašnieks, OTRS problēmu pieteikumu sistēma nosūtīs klientam e-pasta paziņojumu.',

        # Template: AdminQueueResponsesChangeForm
        'Responses <-> Queue Management' => 'Atbilžu <-> Rindu pārvaldība',

        # Template: AdminQueueResponsesForm
        'Answer' => 'Atbilde',

        # Template: AdminResponseAttachmentChangeForm
        'Responses <-> Attachments Management' => 'Atbilžu <-> Pielikumu pārvaldība',

        # Template: AdminResponseAttachmentForm

        # Template: AdminResponseForm
        'Response Management' => 'Atbilžu pārvaldība',
        'A response is default text to write faster answer (with default text) to customers.' => 'Atbilde ir noklusētais teksts lai varētu ātri sastādīt atbildi klientam ar jau gatavu tekstu.',
        'Don\'t forget to add a new response a queue!' => 'Neaizmirstiet rindai pievienot jaunu atbildi!',
        'The current ticket state is' => 'Aktuālais pieteikuma statuss ir',
        'Your email address is new' => 'Jūsu e-pasta adrese ir jauna',

        # Template: AdminRoleForm
        'Role Management' => 'Lomu pārvaldība',
        'Add Role' => 'Pievienot lomas',
        'Add a new Role.' => 'Pievienot jaunu lomu.',
        'Create a role and put groups in it. Then add the role to the users.' => 'Izveidot jaunu lomu un iekļaut tajā grupas. Pēc tam pievienot lomu lietotājiem',
        'It\'s useful for a lot of users and groups.' => 'Noderīga daudzu lietotāju un grupu gadījumā.',

        # Template: AdminRoleGroupChangeForm
        'Roles <-> Groups Management' => 'Lomu <-> Grupu pārvaldība',
        'move_into' => 'ievietot',
        'Permissions to move tickets into this group/queue.' => 'Tiesības ievietot pieteikumus šajā grupā/rindā.',
        'create' => 'izveidot',
        'Permissions to create tickets in this group/queue.' => 'Tiesības izveidot pieteikumus šajā grupā/rindā.',
        'owner' => 'īpašnieks',
        'Permissions to change the ticket owner in this group/queue.' => 'Tiesības mainīt pieteikuma īpašnieku šajā grupā/rindā.',
        'priority' => 'prioritāte',
        'Permissions to change the ticket priority in this group/queue.' => 'Tiesības mainīt pieteikuma prioritāti šajā grupā/rindā.',

        # Template: AdminRoleGroupForm
        'Role' => 'Loma',

        # Template: AdminRoleUserChangeForm
        'Roles <-> Users Management' => 'Lomu <-> Lietotāju pārvaldība',
        'Select the role:user relations.' => 'Atzīmējiet lomas:lietotāja sakarības.',

        # Template: AdminRoleUserForm

        # Template: AdminSalutationForm
        'Salutation Management' => 'Uzrunu pārvaldība',
        'Add Salutation' => 'Pievienot uzrunu',
        'Add a new Salutation.' => 'Pievienot jaunu uzrunu.',

        # Template: AdminSecureMode
        'Secure Mode need to be enabled!' => 'Drošajam režīmam (Secure Mode) ir jābūt ieslēgtam!',
        'Secure mode will (normally) be set after the initial installation is completed.' => 'Parasti drošo režīmu (Secure Mode) uzstāda pēc instalācijas beigām.',
        'Secure mode must be disabled in order to reinstall using the web-installer.' => 'Lai pārinstalētu datus, lietojot pārlūkprogrammas instalātoru, drošajam režīmam (Secure Mode) ir jābūt izslēgtam.',
        'If Secure Mode is not activated, activate it via SysConfig because your application is already running.' => 'Ja drošais režīms vēl nav aktivizēts, aktivizējiet to no sistēmas konfigurācijas (SysConfig), jo programma jau tiek pašlaik darbināta.',

        # Template: AdminSelectBoxForm
        'SQL Box' => 'SQL pieprasījumi',
        'Go' => 'Izpildīt',
        'Select Box Result' => 'Pieprasījuma rezultātu logs',

        # Template: AdminService
        'Service Management' => 'Servisu pārvaldība',
        'Add Service' => 'Pievienot servisu',
        'Add a new Service.' => 'Pievienot jaunu servisu.',
        'Sub-Service of' => 'Kā apakšservisu',

        # Template: AdminSession
        'Session Management' => 'Sesiju pārvaldība',
        'Sessions' => 'sesijas',
        'Uniq' => 'Unikāli',
        'Kill all sessions' => 'Apturēt visas sesijas',
        'Session' => 'Sesija',
        'Content' => 'Saturs',
        'kill session' => 'Apturēt sesiju',

        # Template: AdminSignatureForm
        'Signature Management' => 'Parakstu pārvaldība',
        'Add Signature' => 'Pievienot parakstu',
        'Add a new Signature.' => 'Pievienot jaunu parakstu.',

        # Template: AdminSLA
        'SLA Management' => 'Servisa līmeņa līgumu pārvaldība',
        'Add SLA' => 'Pievienot servisa līmeņa līgumu',
        'Add a new SLA.' => 'Pievienot jaunu servisa līmeņa līgumu.',

        # Template: AdminSMIMEForm
        'S/MIME Management' => 'S/MIME pārvaldība',
        'Add Certificate' => 'Pievieot sertifikātu',
        'Add Private Key' => 'Pievienot privāto atslēgu',
        'Secret' => 'Slepenais kods',
        'Hash' => 'Jaucējsumma',
        'In this way you can directly edit the certification and private keys in file system.' => 'Šādi var tieši failu sistēmā labot sertifikātus un privātās atslēgas.',

        # Template: AdminStateForm
        'State Management' => 'Statusu pārvaldība',
        'Add State' => 'Pievienot statusu',
        'Add a new State.' => 'Pievienot jaunu statusu.',
        'State Type' => 'Statusa tips',
        'Take care that you also updated the default states in you Kernel/Config.pm!' => 'Neaizmirstiet izlabot noklusētos statusus Kernel/Config.pm failā!',
        'See also' => 'Skatīt arī',

        # Template: AdminSysConfig
        'SysConfig' => 'Sistēmas konfigurācija (SysConfig)',
        'Group selection' => 'Grupu izvēle',
        'Show' => 'Rādīt',
        'Download Settings' => 'Lejupielādēt iestatījumus',
        'Download all system config changes.' => 'Lejupielādēt visas sistēmas konfigurācijas izmaiņas.',
        'Load Settings' => 'Ielādēt iestatījumus',
        'Subgroup' => 'Apakšgrupa',
        'Elements' => 'Elementi',

        # Template: AdminSysConfigEdit
        'Config Options' => 'Konfigurācijas iestatījumi',
        'Default' => 'Noklusētā vērtība',
        'New' => 'Jauna',
        'New Group' => 'Jauna grupa',
        'Group Ro' => 'Ro grupa (iespējams tikai lasīt)',
        'New Group Ro' => 'Jauna Ro grupa (tikai lasīšanai)',
        'NavBarName' => 'Vadības paneļa nosaukums',
        'NavBar' => 'Vadības panelis',
        'Image' => 'Attēls',
        'Prio' => 'Prioritāte',
        'Block' => 'Bloks',
        'AccessKey' => 'Pieejas atslēga',

        # Template: AdminSystemAddressForm
        'System Email Addresses Management' => 'Sistēmas e-pasta adrešu pārvaldība',
        'Add System Address' => 'Pievienot sistēmas e-pasta adresi',
        'Add a new System Address.' => 'Pievienot jaunu sistēmas e-pasta adresi.',
        'Realname' => 'Īstais vārds',
        'All email addresses get excluded on replaying on composing an email.' => 'Rakstot atbildes e-pasta ziņojumu, visas e-pasta adreses tiks izlaistas.',
        'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!' => 'Visi ienākošie e-pasta ziņojumi ar šo adresi (Kam:) tiks pārsūtīti uz izvēlēto rindu!',

        # Template: AdminTypeForm
        'Type Management' => 'Tipu pārvaldība',
        'Add Type' => 'Pievienot tipu',
        'Add a new Type.' => 'Pievienot jaunu tipu.',

        # Template: AdminUserForm
        'User Management' => 'Lietotāju pārvaldība',
        'Add User' => 'Pievienot lietotāju',
        'Add a new Agent.' => 'Pievienot jaunu aģentu (pieteikumu apstrādes operatoru).',
        'Login as' => 'Pieteikties sistēmā kā',
        'Firstname' => 'Vārds',
        'Lastname' => 'Uzvārds',
        'Start' => 'Sākt',
        'End' => 'Beigt',
        'User will be needed to handle tickets.' => 'Lai apstrādātu pieteikumus, nepieciešams lietotājs.',
        'Don\'t forget to add a new user to groups and/or roles!' => 'Neaizmirstiet pievienot jauno lietotāju grupām un/vai lomām!',

        # Template: AdminUserGroupChangeForm
        'Users <-> Groups Management' => 'Lietotāju <-> Grupu pārvaldība',

        # Template: AdminUserGroupForm

        # Template: AgentBook
        'Address Book' => 'Adresu grāmata',
        'Return to the compose screen' => 'Atgriezties ziņojuma sastādīšanas logā',
        'Discard all changes and return to the compose screen' => 'Izmest visas izmaiņas un atgriezties ziņojuma sastādīšanas logā',

        # Template: AgentCalendarSmall

        # Template: AgentCalendarSmallIcon

        # Template: AgentCustomerSearch

        # Template: AgentCustomerTableView

        # Template: AgentDashboard
        'Dashboard' => 'Darbvirsmas panelis',
        'more' => 'vēl',
        'Settings' => 'Iestatījumi',
        'Collapse' => 'Sašaurināt',

        # Template: AgentDashboardCalendarOverview
        'in' => 'iekšā',

        # Template: AgentDashboardImage

        # Template: AgentDashboardProductNotify
        '%s %s is available!' => '%s %s ir pieejams',
        'Please update now.' => 'Lūdzu, atjauniniet tūlīt',
        'Release Note' => 'Laidiena piezīme',
        'Level' => 'Līmenis',

        # Template: AgentDashboardRSSOverview
        'Posted %s ago.' => 'Ievietots %s atpakaļ.',

        # Template: AgentDashboardTicketOverview

        # Template: AgentDashboardTicketStats

        # Template: AgentInfo
        'Info' => 'Informācija',

        # Template: AgentLinkObject
        'Link Object: %s' => 'Saistītais objekts: %s',
        'Object' => 'Objekts',
        'Link Object' => 'Saistīt ar objektu',
        'with' => 'ar',
        'Select' => 'Paņemt',
        'Unlink Object: %s' => 'Atsaistīt objektu: %s',

        # Template: AgentLookup
        'Lookup' => 'Caurskatīt',

        # Template: AgentNavigationBar

        # Template: AgentPreferencesForm

        # Template: AgentSpelling
        'Spell Checker' => 'Pareizrakstības pārbaude',
        'spelling error(s)' => 'pareizrakstības kļūda(s)',
        'or' => 'vai',
        'Apply these changes' => 'Apstiprināt izmaiņas',

        # Template: AgentStatsDelete
        'Do you really want to delete this Object?' => 'Vai tiešām vēlaties dzēst šo objektu?',

        # Template: AgentStatsEditRestrictions
        'Select the restrictions to characterise the stat' => 'Izvēlieties ierobežojumus lai raksturotu šo statistikas pārskatu',
        'Fixed' => 'Fiksēts',
        'Please select only one element or turn off the button \'Fixed\'.' => 'Lūdzu, izvēlieties tikai vienu elementu vai atstatiet pogu \'Fiksēts\'.',
        'Absolut Period' => 'Absolūtais periods',
        'Between' => 'Starp',
        'Relative Period' => 'Relatīvais periods',
        'The last' => 'Pēdējais',
        'Finish' => 'Beigas',
        'Here you can make restrictions to your stat.' => 'Šeit statistikas pārskatam var izveidot ierobežojumus.',
        'If you remove the hook in the "Fixed" checkbox, the agent generating the stat can change the attributes of the corresponding element.' => 'Ja "Fixed" izvēles rūtiņu nav iezīmēta, tad aģents, kurš veido pārskatu, var mainīt attiecīgā elementa atribūtus.',

        # Template: AgentStatsEditSpecification
        'Insert of the common specifications' => 'Ievadiet kopējas pazīmes',
        'Permissions' => 'Tiesības',
        'Format' => 'Formāts',
        'Graphsize' => 'Diagrammas izmērs',
        'Sum rows' => 'Summēt rindas',
        'Sum columns' => 'Summēt kolonnas',
        'Cache' => 'Kešatmiņa',
        'Required Field' => 'Obligātais lauks',
        'Selection needed' => 'Jāizvēlas',
        'Explanation' => 'Paskaidrojums',
        'In this form you can select the basic specifications.' => 'Šajā formā var izvēlēties pamata kritērijus.',
        'Attribute' => 'Attribūts',
        'Title of the stat.' => 'Statistikas atskaites nosaukums.',
        'Here you can insert a description of the stat.' => 'Šeit var ierakstīt statistikas atskaites aprakstu.',
        'Dynamic-Object' => 'Dinamisks objekts',
        'Here you can select the dynamic object you want to use.' => 'Šeit var izvēlēties kādus dinamiskos objektus lietot.',
        '(Note: It depends on your installation how many dynamic objects you can use)' => '(Piezīme: no instalācijas ir atkarīgs cik dinamiskos objektus objektus var lietot)',
        'Static-File' => 'Statiskais fails (datne)',
        'For very complex stats it is possible to include a hardcoded file.' => 'Ļoti sarežģītām atskaitēm var izmantot iepriekš definētu failu (datni) atskaites kritērijiem.',
        'If a new hardcoded file is available this attribute will be shown and you can select one.' => 'Ja būs pieejams jauns kritēriju fails tad šis atribūts tiks parādīts un to varēs izvēlēties.',
        'Permission settings. You can select one or more groups to make the configurated stat visible for different agents.' => 'Tiesības: Ir iespējams izvēlēties vienu vai vairākas grupas lai izveidotā atskaite būtu pieejama dažādiem aģentiem.',
        'Multiple selection of the output format.' => 'Atskaišu izvades formāta izvēles.',
        'If you use a graph as output format you have to select at least one graph size.' => 'Ja kā izvades formāts norādīta diagramma, jāizvēlas vismaz viens diagrammas izmērs.',
        'If you need the sum of every row select yes' => 'Ja nepieciešams summēt visas rindiņas, izvēlieties \'Jā\'.',
        'If you need the sum of every column select yes.' => 'Ja nepieciešams summēt visas kolonnas, izvēlieties \'Jā\'.',
        'Most of the stats can be cached. This will speed up the presentation of this stat.' => 'Lielāko daļu atskaišu iespējams kešot. Tas paātrinās atskaites izveidošanu.',
        '(Note: Useful for big databases and low performance server)' => '(Piezīmes: noderīgi lielām datu bāzēm un zemas veiktspējas serveriem)',
        'With an invalid stat it isn\'t feasible to generate a stat.' => 'Ar nederīgu atskaiti nav iespējams izveidot jaunu atskaiti.',
        'This is useful if you want that no one can get the result of the stat or the stat isn\'t ready configurated.' => 'Noderīgi, ja vēlaties, lai neviens nevarētu izmantot atskaites rezultātus vai atskaites konfigurēšana vēl nav pabeigta.',

        # Template: AgentStatsEditValueSeries
        'Select the elements for the value series' => 'Izvēlieties elementus vērtību (Y) asij',
        'Scale' => 'Mērogs',
        'minimal' => 'minimālā vērtība',
        'Please remember, that the scale for value series has to be larger than the scale for the X-axis (e.g. X-Axis => Month, ValueSeries => Year).' => 'Lūdzu, atcerieties, ka vērtību (Y) ass mērogam jābūt lielākām nekā X-ass mērogam (piem. X-ass => mēnesis, Y-ass => gads).',
        'Here you can define the value series. You have the possibility to select one or two elements. Then you can select the attributes of elements. Each attribute will be shown as single value series. If you don\'t select any attribute all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' => 'Šeit var noteikt vērtību ass elementus. Iespējams izvēlēties vienu vai divus elementus. Pēc tam var izvēlēties elementu atribūtus. Katrs atribūts tiks parādīts kā atsevišķa vērtību sērija. Ja netiks izvēlēts neviens atsevišķs atribūts, veidojot atskaiti tiks izmantoti visi izvēlētā elementa atribūti, kā arī jaunie atribūti, kuri pievienoti kopš pēdējās konfigurēšanas.',

        # Template: AgentStatsEditXaxis
        'Select the element, which will be used at the X-axis' => 'Izvēlieties X-asij izmantojamo elementu.',
        'maximal period' => 'maksmālais periods',
        'minimal scale' => 'minimālais mērogs',
        'Here you can define the x-axis. You can select one element via the radio button. If you make no selection all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' => 'Šeit var izvēlēties X-asi. Ar radio pogu iespējams izvēlēties vienu elementu. Ja netiks izvēlēts nekas, veidojot atskaiti tiks izmantoti visi izvēlētā elementa atribūti, kā arī jaunie atribūti, kuri pievienoti kopš pēdējās konfigurēšanas.',

        # Template: AgentStatsImport
        'Import' => 'Importēt',
        'File is not a Stats config' => 'Norādītais fails nesatur statistikas konfigurācijas datus',
        'No File selected' => 'Nav izvēlēts neviens fails',

        # Template: AgentStatsOverview
        'Results' => 'Rezultāti',
        'Total hits' => 'Kopējais daudzums',
        'Page' => 'Lapa',

        # Template: AgentStatsPrint
        'Print' => 'Drukāt',
        'No Element selected.' => 'Nav izvēlēts neviens elements.',

        # Template: AgentStatsView
        'Export Config' => 'Eksportēt konfigurāciju',
        'Information about the Stat' => 'Informācija par atskaiti',
        'Exchange Axis' => 'Samainīt asis',
        'Configurable params of static stat' => 'Statisko atskaišu konfigurējamie parametri',
        'No element selected.' => 'Nav izvēlēts neviens elements.',
        'maximal period from' => 'maksimālais periods no',
        'to' => 'līdz',
        'With the input and select fields you can configurate the stat at your needs. Which elements of a stat you can edit depends on your stats administrator who configurated the stat.' => 'Ar ievades un izvēlētajiem laukiem var konfigurēt atskaiti pēc nepieciešamības. No administratora, kurš konfigurējis atskaiti, būs atkarīgs, kādus elementus varēs labot.',

        # Template: AgentTicketBounce
        'A message should have a To: recipient!' => 'Ziņojumam jābūt saņēmējam (Kam:)!',
        'You need a email address (e. g. customer@example.com) in To:!' => 'Kam: laukā nepieciešama e-pasta adrese (piem. klients@piemeram.lv)!',
        'Bounce ticket' => 'Pieteikumu varēs pārcelt',
        'Ticket locked!' => 'Pieteikums aizslēgts!',
        'Ticket unlock!' => 'Pieteikums atslēgts!',
        'Bounce to' => 'Atleks uz',
        'Next ticket state' => 'Nākamais pieteikuma stāvoklis',
        'Inform sender' => 'Informēt nosūtītāju',
        'Send mail!' => 'Nosūtīt ziņojumu!',

        # Template: AgentTicketBulk
        'You need to account time!' => 'Nepieciešams uzskaitīt laiku!',
        'Ticket Bulk Action' => 'Labot vairākus pieteikumus',
        'Spell Check' => 'Pareizrakstības pārbaude',
        'Note type' => 'Piezīmes tips',
        'Next state' => 'Nākamais statuss',
        'Pending date' => 'Gaida līdz (datumam)',
        'Merge to' => 'Apvienot ar',
        'Merge to oldest' => 'Apvienot ar vecāko',
        'Link together' => 'Sasaistīt kopā',
        'Link to Parent' => 'Sasaistīt ar senci',
        'Unlock Tickets' => 'Atslēgt pieteikumus',

        # Template: AgentTicketClose
        'Ticket Type is required!' => 'Pieteikuma tips ir obligāts!',
        'A required field is:' => 'Obligātais lauks ir:',
        'Close ticket' => 'Aizvērt pieteikumu',
        'Previous Owner' => 'Iepriekšējais īpašnieks',
        'Inform Agent' => 'Informēt aģentu',
        'Optional' => 'Izvēles',
        'Inform involved Agents' => 'Informēt iesaistītos aģentus',
        'Attach' => 'Pievienot',

        # Template: AgentTicketCompose
        'A message must be spell checked!' => 'Ziņojumam jāpārbauda pareizrakstība!',
        'Compose answer for ticket' => 'Rakstīt atbildi pieteikumam',
        'Pending Date' => 'Izlemt līdz (datumam)',
        'for pending* states' => 'izlemšanas* stāvokļiem',

        # Template: AgentTicketCustomer
        'Change customer of ticket' => 'Mainīt pieteikuma klientu',
        'Set customer user and customer id of a ticket' => 'Izvēlēties pieteikuma klientu un klienta identifikatoru',
        'Customer User' => 'Knients',
        'Search Customer' => 'Meklēt klientu',
        'Customer Data' => 'Klienta dati',
        'Customer history' => 'Klienta vēstures dati',
        'All customer tickets.' => 'Visi klienta pieteikumi.',

        # Template: AgentTicketEmail
        'Compose Email' => 'Izveidot e-pasta ziņojumu',
        'new ticket' => 'jauns pieteikums',
        'Refresh' => 'Atjaunot',
        'Clear To' => 'Nodzēst Kam:',
        'All Agents' => 'Visi aģenti',

        # Template: AgentTicketEscalation

        # Template: AgentTicketForward
        'Article type' => 'Ziņojuma tips',

        # Template: AgentTicketFreeText
        'Change free text of ticket' => 'Mainīt pieteikuma brīvo tekstu',

        # Template: AgentTicketHistory
        'History of' => 'Vēsture',

        # Template: AgentTicketLocked

        # Template: AgentTicketMerge
        'You need to use a ticket number!' => 'Jālieto pieteikuma numurs!',
        'Ticket Merge' => 'Apvienot pieteikumus',

        # Template: AgentTicketMove
        'If you want to account time, please provide Subject and Text!' => '',
        'Move Ticket' => 'Pārvietot pieteikumu',

        # Template: AgentTicketNote
        'Add note to ticket' => 'Pievienot pieteikumam piezīmi',

        # Template: AgentTicketOverviewMedium
        'First Response Time' => 'Pirmais reakcijas laiks',
        'Service Time' => 'Servisa laiks',
        'Update Time' => 'Atjaunināšanas laiks',
        'Solution Time' => 'Atrisinājuma laiks',

        # Template: AgentTicketOverviewMediumMeta
        'You need min. one selected Ticket!' => 'Jāizvēlas vismaz viens pieteikums!',
        'Bulk Action' => '',

        # Template: AgentTicketOverviewNavBar
        'Filter' => 'Filtrs',
        'Change search options' => 'Mainīt meklēšanas iestatījumus',
        'Tickets' => 'Pieteikumu',
        'of' => 'no',

        # Template: AgentTicketOverviewNavBarSmall

        # Template: AgentTicketOverviewPreview
        'Compose Answer' => 'Rakstīt atbildi',
        'Contact customer' => 'Kontaktēties (zvanīt) klientam',
        'Change queue' => 'Mainīt rindu',

        # Template: AgentTicketOverviewPreviewMeta

        # Template: AgentTicketOverviewSmall
        'sort upward' => 'kārtot pieaugošā secībā',
        'up' => 'augoša',
        'sort downward' => 'kārtot dilstošā secībā',
        'down' => 'dilstoša',
        'Escalation in' => 'Eskalēt',
        'Locked' => 'Aizslēgts',

        # Template: AgentTicketOwner
        'Change owner of ticket' => 'Mainīt pieteikuma īpašnieku',

        # Template: AgentTicketPending
        'Set Pending' => 'Iestatīt kā neizlemtu',

        # Template: AgentTicketPhone
        'Phone call' => 'Telefona zvans',
        'Clear From' => 'Dzēst No:',

        # Template: AgentTicketPhoneOutbound

        # Template: AgentTicketPlain
        'Plain' => 'vienkāršs teksts',

        # Template: AgentTicketPrint
        'Ticket-Info' => 'Informācija par pieteikumu',
        'Accounted time' => 'Uzskaitītais laiks',
        'Linked-Object' => 'Saistītie objekti',
        'by' => 'no',

        # Template: AgentTicketPriority
        'Change priority of ticket' => 'Mainīt pieteikuma prioritāti',

        # Template: AgentTicketQueue
        'Tickets shown' => 'Parādītie pieteikumi',
        'Tickets available' => 'Pieejamie pieteikumi',
        'All tickets' => 'Visi pieteikumi',
        'Queues' => 'Rindas',
        'Ticket escalation!' => 'Pieteikumu eskalācija!',

        # Template: AgentTicketResponsible
        'Change responsible of ticket' => 'Mainīt atbildīgo par pieteikumu',

        # Template: AgentTicketSearch
        'Ticket Search' => 'Meklēt pieteikumus',
        'Profile' => 'Profils',
        'Search-Template' => 'Meklēšanas sagatave',
        'TicketFreeText' => 'Pieteikuma brīvais teksts',
        'Created in Queue' => 'Izveidots rindā',
        'Article Create Times' => 'Ziņojuma izveidošanas laiki',
        'Article created' => 'Ziņojums izveidots',
        'Article created between' => 'Ziņojums izveidots laikā starp',
        'Change Times' => 'Mainīt laikus',
        'No change time settings.' => 'Nemainīt laika iestatījumus',
        'Ticket changed' => 'Pieteikums izmainīts',
        'Ticket changed between' => 'Pieteikums izmainīts starp',
        'Result Form' => 'Rezultātu forma',
        'Save Search-Profile as Template?' => 'Vai saglabāt meklēšanas profilu kā sagatavi?',
        'Yes, save it with name' => 'Jā, saglabāt ar nosaukumu',

        # Template: AgentTicketSearchOpenSearchDescriptionFulltext
        'Fulltext' => 'Pilnais teksts',

        # Template: AgentTicketSearchOpenSearchDescriptionTicketNumber

        # Template: AgentTicketSearchResultPrint

        # Template: AgentTicketZoom
        'Expand View' => 'Paplašināt skatu',
        'Collapse View' => 'Sašaurināt skatu',
        'Split' => 'Sadalīt',

        # Template: AgentTicketZoomArticleFilterDialog
        'Article filter settings' => 'Ziņojuma filtra iestatījumi',
        'Save filter settings as default' => 'Saglabāt filtra iestatījumus kā noklusētos',

        # Template: AgentWindowTab

        # Template: AJAX

        # Template: Copyright

        # Template: CustomerAccept

        # Template: CustomerCalendarSmallIcon

        # Template: CustomerError
        'Traceback' => 'Izsekot vēsturei',

        # Template: CustomerFooter
        'Powered by' => 'Darbina ar',

        # Template: CustomerFooterSmall

        # Template: CustomerHeader

        # Template: CustomerHeaderSmall

        # Template: CustomerLogin
        'Login' => 'Pieteikties',
        'Lost your password?' => 'Aizmirsta parole?',
        'Request new password' => 'Pieprasīt jaunu paroli',
        'Create Account' => 'Izveidot lietotāja kontu',

        # Template: CustomerNavigationBar
        'Welcome %s' => 'Laipni lūdzam %s',

        # Template: CustomerPreferencesForm

        # Template: CustomerStatusView

        # Template: CustomerTicketMessage

        # Template: CustomerTicketPrint

        # Template: CustomerTicketSearch
        'Times' => 'Laiki',
        'No time settings.' => 'Nav laika iestatījumu.',

        # Template: CustomerTicketSearchOpenSearchDescription

        # Template: CustomerTicketSearchResultCSV

        # Template: CustomerTicketSearchResultPrint

        # Template: CustomerTicketSearchResultShort

        # Template: CustomerTicketZoom

        # Template: CustomerWarning

        # Template: Error
        'Click here to report a bug!' => 'Klikšķiniet te, lai paziņotu par kļūdu!',

        # Template: Footer
        'Top of Page' => 'Lapas augša',

        # Template: FooterSmall

        # Template: Header
        'Home' => 'Sākums',

        # Template: HeaderSmall

        # Template: Installer
        'Web-Installer' => 'Instalācija no interneta pārlūka',
        'Welcome to %s' => '%s',
        'Accept license' => 'Piekrist licencei',
        'Don\'t accept license' => 'Nepiekrist licencei',
        'Admin-User' => 'Lietotājs - administrators',
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty. For security reasons we do recommend setting a root password. For more information please refer to your database documentation.' => 'Ja datubāzei ir iestatīta \'root\' parole, ievadiet to šeit. Ja nav, atstājiet lauku tukšu. Drošības apsvērumu dēļ mēs iesakām datubāzei iestatīt \'root\'paroli. Papildinformāciju meklējiet savas datubāzes dokumentācijā.',
        'Admin-Password' => 'Administratora parole',
        'Database-User' => 'Datubāzes lietotāja parole',
        'default \'hot\'' => 'noklusētais \'hot\'',
        'DB connect host' => 'Datubāzes resursdators',
        'Database' => 'Datubāze',
        'Default Charset' => 'Noklusētais kodējums',
        'utf8' => 'utf8',
        'false' => 'aplams',
        'SystemID' => 'Sistēmas ID',
        '(The identify of the system. Each ticket number and each http session id starts with this number)' => 'Sistēmas identifikators. Katrs pieteikums un katra http sesija sākas ar šo numuru',
        'System FQDN' => 'Sistēmas FQDN',
        '(Full qualified domain name of your system)' => '(Sistēmas pilnais domēna vārds)',
        'AdminEmail' => 'Administratora e-pasts',
        '(Email of the system admin)' => '(Sistēmas administratora e-pasts)',
        'Organization' => 'Organizācija/uzņēmums',
        'Log' => 'Žurnāls',
        'LogModule' => 'Žurnāla modulis',
        '(Used log backend)' => '(Izmantotā žurnāla aizmugure)',
        'Logfile' => 'Žurnāla fails) datne',
        '(Logfile just needed for File-LogModule!)' => '(Žurnāla fails. Tiek izmantots tikai failu žurnālam!)',
        'Webfrontend' => 'Pārlūka priekšpuse',
        'Use utf-8 it your database supports it!' => 'Izmantojiet utf-8 kodējumu, ja to uztur datubāze!',
        'Default Language' => 'Noklusētā valoda',
        '(Used default language)' => '(Izmantotā noklusētā valoda)',
        'CheckMXRecord' => 'Pārbaudīt MX ierakstu',
        '(Checks MX recordes of used email addresses by composing an answer. Don\'t use CheckMXRecord if your OTRS machine is behinde a dial-up line $!)' => '(Nosūtot atbildes ziņojumu, OTRS pārbauda izmantoto e-pasta adrešu MX ierakstus. Nelietojiet, ja OTRS sistēma izmanto iezvanpieeju!)',
        'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' => 'Lai varētu izmantot OTRS, sekojošā komanda jāizpilda terminālī/čaulā.',
        'Restart your webserver' => 'Pārstartējiet tīmekļa serveri (webserver).',
        'After doing so your OTRS is up and running.' => 'Pēc tam OTRS būs darba kārtībā un palaists.',
        'Start page' => 'Sākumlapa',
        'Your OTRS Team' => 'Jūsu OTRS komanda',

        # Template: LinkObject

        # Template: Login

        # Template: Motd

        # Template: NoPermission
        'No Permission' => 'Nav tiesību',

        # Template: Notify
        'Important' => 'Svarīgi',

        # Template: PrintFooter
        'URL' => 'URL (adrese)',

        # Template: PrintHeader
        'printed by' => 'drukājis',

        # Template: PublicDefault

        # Template: Redirect

        # Template: Test
        'OTRS Test Page' => 'OTRS problēmu pieteikumu sistēmas testa lapa',
        'Counter' => 'Skaitītājs',

        # Template: Warning

        # Template: YUI

        # Misc
        'Create Database' => 'Izveidot datubāzi',
        'verified' => 'pārbaudījis',
        'File-Name' => 'Faila (datnes) nosaukums',
        'Ticket Number Generator' => 'Pieteikumu identifikatoru ģenerators',
        '(Ticket identifier. Some people want toset this to e. g. \'Ticket#\', \'Call#\' or \'MyTicket#\')' => 'Pieteikuma identifikators. Iespējams iestatīt identifikātora nosaukumu, piem. \'Pieteikums#\', \'Zvans#\' vai \'MansPieteikums#\')',
        'Create new Phone Ticket' => 'Izveidot jaunu telefonisku pieteikumu',
        'In this way you can directly edit the keyring configured in Kernel/Config.pm.' => 'Šādi iespējams tieši labot atslēgu saišķi failā Kernel/Config.pm',
        'U' => 'U',
        'Site' => 'Vieta',
        'Customer history search (e. g. "ID342425").' => 'Meklēšana klienta vēstures datos (piem. "ID342425").',
        'Can not delete link with %s!' => 'Nevar nodzēst saiti ar %s !',
        'for agent firstname' => 'aģenta vārdam',
        'Close!' => 'Aizvērt!',
        'Reporter' => 'Ziņotājs',
        'Process-Path' => 'Procesa ceļš',
        'A web calendar' => 'Kalendārs',
        'to get the realname of the sender (if given)' => 'lai izmantotu nosūtītāja īsto vārdu (ja ir norādīts)',
        'FAQ Search Result' => 'BUJ (FAQ) meklēšanas rezultāti',
        'To enable automatic execusion select at least one value form minutes, hours and days!' => 'Lai iestatītu automātisku izpildi, izvēlieties vismaz vienu vērtību no minūtēm, stundām un dienām!',
        'Notification (Customer)' => 'Paziņojums (klienta)',
        'CSV' => 'CSV',
        'Select Source (for add)' => 'Izvēlēties avotu (pievienošanai)',
        'Node-Name' => 'Mezgla nosaukums',
        'Options of the ticket data (e. g. &lt;OTRS_TICKET_Number&gt;, &lt;OTRS_TICKET_ID&gt;, &lt;OTRS_TICKET_Queue&gt;, &lt;OTRS_TICKET_State&gt;)' => 'Pieteikuma iestatījumi (piem. &lt;OTRS_TICKET_Number&gt;, &lt;OTRS_TICKET_ID&gt;, &lt;OTRS_TICKET_Queue&gt;, &lt;OTRS_TICKET_State&gt;)',
        'Child-Object' => '\'Bērna\' objekts',
        'Workflow Groups' => 'Darbplūsmas grupas',
        'Current Impact Rating' => 'Tekošais ietekmes novērtējums',
        'Config options (e. g. <OTRS_CONFIG_HttpType>)' => 'Konfigurācijas iestatījumi (piem. <OTRS_CONFIG_HttpType>)',
        'FAQ System History' => 'BUJ (FAQ) sistēmas vēstures dati',
        'customer realname' => 'klienta vārds',
        'Pending messages' => 'Neizlemtie pieteikumi',
        'Modules' => 'Moduļi',
        'for agent login' => 'aģenta pieteikumam sistēmā',
        'Keyword' => 'Atslēgvārds',
        'Reference' => 'Atsauce (en)',
        'Close type' => 'Aizvēršanas tips',
        'Can\'t update password, need min. 2 characters!' => 'Nav iespējams mainīt paroli, parolei jāsatur vismaz 2 rakstzīmes!',
        'DB Admin User' => 'Datubāzes administratora lietotājvārds',
        'for agent user id' => 'aģenta lietotāja identifikatoram',
        'Classification' => 'Klasifikācija',
        'Change user <-> group settings' => 'Mainīt lietotāju <-> grupu iestatījumus',
        'Escalation' => 'Eskalācija',
        'Order' => 'Kārtība',
        'next step' => 'nākamais solis',
        'Follow up' => 'Sekošana',
        'Customer history search' => 'Meklēšana klienta vēstures datos',
        'not verified' => 'nav pārbaudīts',
        'Stat#' => 'Atskaite Nr.',
        'Create new database' => 'Izveidot jaunu datubāzi',
        'Year' => 'Gads',
        'X-axis' => 'X-ass',
        'Can\'t update password, need min. 1 digit!' => 'Nav iespējams mainīt paroli, parolei jāsatur vismaz 1 ciparu rakstzīme!',
        'Keywords' => 'Atslēgvārdi',
        'Ticket Escalation View' => 'Pieteikumu eskalācijas skats',
        'Today' => 'Šodien',
        'No * possible!' => '"*" nav iespējama!',
        'Load' => 'Ielādēt',
        'Change Time' => 'Mainīt laiku',
        'Options of the current user who requested this action (e. g. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)' => 'Darbības pieprasītāja lietotāja iestatījumi (piem. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)',
        'Message for new Owner' => 'Ziņojums jaunajam īpašniekam',
        'to get the first 5 lines of the email' => 'lai parādītu pirmās piecas e-pasta ziņojuma rindiņas',
        'Sent new password to: ' => 'Nosutīt jauno paroli uz: ',
        'Sort by' => 'Kārtot pēc',
        'OTRS DB Password' => 'OTRS datubāzes parole',
        'Last update' => 'Pēdējā atjaunināšana',
        'Tomorrow' => 'Rīt',
        'not rated' => 'nav vērtējuma',
        'to get the first 20 character of the subject' => 'lai parādītu ziņojuma tēmas pirmos 20 simbolus',
        'Select the customeruser:service relations.' => 'Iestatīt klienta lietotājvārda:servisa attiecības.',
        'DB Admin Password' => 'Datubāzes administratora parole',
        'Bulk-Action' => 'Labot vairākus',
        'Drop Database' => 'Dzēst datubāzi',
        'Options of the current customer user data (e. g. <OTRS_CUSTOMER_DATA_UserFirstname>)' => 'Tekošā klienta datu iestatījumi (piem. <OTRS_CUSTOMER_DATA_UserFirstname>)',
        'Pending type' => 'Neizlemts: tips',
        'Comment (internal)' => 'Komentārs (iekšējais)',
        'Ticket owner options (e. g. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)' => 'Pieteikuma īpašnieka iestatījumi (piem. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)',
        'User-Number' => 'Lietotāja identifikators',
        'Options of the ticket data (e. g. <OTRS_TICKET_Number>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' => 'Pieteikuma iestatījumi(piem. <OTRS_TICKET_Number>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)',
        '(Used ticket number format)' => '(Izmantotais pieteikuma identifikatora formāts)',
        'Reminder' => 'Atgādinājumi',
        'Month' => 'Mēnesis',
        'Can\'t update password, passwords doesn\'t match! Please try it again!' => 'Nav iespējams mainīt paroli, jaunās paroles nesakrīt savā starpā!',
        'Recipients' => 'Saņēmēji',
        'Node-Address' => 'Mezgla adrese',
        'All Agent variables.' => 'Visi aģenta mainīgie dati',
        ' (work units)' => ' (darba laika vienības)',
        'Next Week' => 'nākamā nedēļa',
        'You use the DELETE option! Take care, all deleted Tickets are lost!!!' => 'Šis iestatījums DZĒŠ datus! Esiet uzmanīgi, visi nodzēstie pieteikumi tiks neatgriezeniski zaudēti!',
        'All Customer variables like defined in config option CustomerUser.' => 'Visi klienta mainīgie dati kā noteikts \'CustomerUser\' konfigurācijas iestatījumā.',
        'for agent lastname' => 'aģenta uzvārdam',
        'Options of the current user who requested this action (e. g. <OTRS_CURRENT_UserFirstname>)' => 'Darbības pieprasītāja lietotāja iestatījumi (piem. <OTRS_CURRENT_UserFirstname>)',
        'Reminder messages' => 'Atgādinājuma paziņojumi',
        'Parent-Object' => '\'Vecāku\' objekts',
        'Of couse this feature will take some system performance it self!' => 'Protams, šis iestatījums prasīs sistēmas resursus.',
        'Detail' => 'Detaļas',
        'Your own Ticket' => 'Jūsu pieteikums',
        'TicketZoom' => 'Atvērt pieteikumu',
        'Open Tickets' => 'Atvērtie pieteikumi',
        'Don\'t forget to add a new user to groups!' => 'Neaizmirstiet pievienot jauno lietotāju grupām!',
        'CreateTicket' => 'Izveidot vēl vienu',
        'unknown' => 'nezināms',
        'System Settings' => 'Sistēmas iestatījumi',
        'Finished' => 'Pabeigts(i)',
        'Imported' => 'Importēts',
        'unread' => 'nelasīts(i)',
        'D' => 'D',
        'All messages' => 'Visi ziņojumi',
        'System Status' => 'Systēmas statuss',
        'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' => 'Pieteikuma datu iestatījumi (piem. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)',
        'Object already linked as %s.' => 'Objekts jau piesaistīts kā %s.',
        'A article should have a title!' => 'Ziņojumam jābūt arī virsrakstam!',
        'Customer Users <-> Services' => 'Klienti <-> Servisi',
        'Config options (e. g. &lt;OTRS_CONFIG_HttpType&gt;)' => 'Konfigurācijas iestatījumi (piem.&lt;OTRS_CONFIG_HttpType&gt;)',
        'Compose Follow up' => 'Rakstīt sekošanas ziņojumu',
        'Imported by' => 'Importējis',
        'Can\'t update password, need min. 8 characters!' => 'Nav iespējams mainīt paroli, nepieciešamas vismaz 8 rakstzīmes.',
        'Ticket owner options (e. g. <OTRS_OWNER_UserFirstname>)' => 'Pieteikuma īpašnieka datu iestatījumi (piem. <OTRS_OWNER_UserFirstname>)',
        'read' => 'lasīts(i)',
        'Product' => 'Produkts(i)',
        'kill all sessions' => 'apturēt visas sesijas',
        'to get the from line of the email' => 'lai parādītu e-pasta No: rindiņu',
        'Solution' => 'Risinājums',
        'QueueView' => 'Rindas skats',
        'My Queue' => 'Mana rinda',
        'Select Box' => 'Atlases lauks',
        'Instance' => 'Instance',
        'Day' => 'Diena',
        'New messages' => 'Jauni ziņojumi',
        'Service-Name' => 'Servisa nosaukums',
        'Can not create link with %s!' => 'Nevar izveidot saiti ar %s!',
        'Linked as' => 'Sasaistīts kā',
        'Welcome to OTRS' => 'Lūdzam OTRS problēmu pieteikumu sistēmā',
        'tmp_lock' => 'pagaidu slēgšana',
        'modified' => 'mainīts',
        'Delete old database' => 'Dzēst veco datubāzi',
        'Watcher' => 'Novērotājs',
        'Have a lot of fun!' => 'Veiksmi darbā!',
        'send' => 'nosutīt',
        'Note Text' => 'Piezīmes teksts',
        'POP3 Account Management' => 'POP3 kontu pārvaldība',
        'Options of the current customer user data (e. g. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)' => 'Tekošā klienta datu iestatījumi (piem. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;).',
        'System State Management' => 'Sistēmas statusa pārvaldība',
        'Mailbox' => 'Pastkaste',
        'PhoneView' => 'Telefonu saraksts',
        'User-Name' => 'Lietotājvārds',
        'File-Path' => 'Faila (datnes) ceļa vārds',
        'Standard' => 'Standarta',
        'Can\'t update password, need 2 lower and 2 upper characters!' => 'Nav iespējams mainīt paroli, parolei jāsatur vismaz 2 lielo un 2 mazo burtu rakstzīmes.',
        'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further information.' => 'Jūsu e-pasts ar pieteikuma numuru "<OTRS_TICKET>" ir pārcelts pie "<OTRS_BOUNCE_TO>". Papildinformāciju, lūdzu, jautājiet norādītajā adresē.',
        'Ticket Status View' => 'Pieteikuma statusa skats',
        'Modified' => 'Mainīts',
        'Ticket selected for bulk action!' => 'Pieteikums izvēlēts kopīgai apstrādei!',
        'History::SystemRequest' => 'Sistēmas pieprasījums (%s).',
        '%s is not writable!' => '',
        'Cannot create %s!' => '',
    };
    # $$STOP$$
    return;
}

1;
