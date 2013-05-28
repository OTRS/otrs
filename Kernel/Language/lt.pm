# --
# Kernel/Language/lt.pm - provides Lithuanian language translation
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# Copyright (C) 2011 Edgaras Lukoševičius <edgaras[eta]kauko.lt or admin[eta]sysadmin.lt>
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --
package Kernel::Language::lt;

use strict;
use warnings;

sub Data {
    my $Self = shift;

    # $$START$$
    # Last translation file sync: 2013-05-28 11:37:16

    # possible charsets
    $Self->{Charset} = ['utf-8', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Year;)
    $Self->{DateFormat}          = '%Y-%M-%D %T';
    $Self->{DateFormatLong}      = '%Y-%M-%D - %T';
    $Self->{DateFormatShort}     = '%Y-%M-%D';
    $Self->{DateInputFormat}     = '%Y-%M-%D';
    $Self->{DateInputFormatLong} = '%Y-%M-%D - %T';

    # csv separator
    $Self->{Separator} = ';';

    $Self->{Translation} = {

        # Template: AAABase
        'Yes' => 'Taip',
        'No' => 'Ne',
        'yes' => 'taip',
        'no' => 'ne',
        'Off' => 'Išjungta',
        'off' => 'išjungta',
        'On' => 'Įjungta',
        'on' => 'įjungta',
        'top' => 'viršus',
        'end' => 'pabaiga',
        'Done' => 'Atlikta',
        'Cancel' => 'Atšaukti',
        'Reset' => 'Atstatyti',
        'last' => 'paskutinis',
        'before' => 'prieš',
        'Today' => 'Šiandien',
        'Tomorrow' => 'Rytoj',
        'Next week' => '',
        'day' => 'diena',
        'days' => 'dienos',
        'day(s)' => 'Diena(-os)',
        'd' => 'd',
        'hour' => 'valanda',
        'hours' => 'valandos',
        'hour(s)' => 'valanda(-os)',
        'Hours' => 'Valandos',
        'h' => 'h',
        'minute' => 'minutė',
        'minutes' => 'minutės',
        'minute(s)' => 'minutė(-ės)',
        'Minutes' => 'minutės',
        'm' => 'm',
        'month' => 'mėnesis',
        'months' => 'mėnesiai',
        'month(s)' => 'mėnesis(-iai)',
        'week' => 'savaitė',
        'week(s)' => 'savaitė(-ės)',
        'year' => 'metai',
        'years' => 'metų',
        'year(s)' => 'metai(-ų)',
        'second(s)' => 'sekundė(-ės)',
        'seconds' => 'sekundės',
        'second' => 'sekundė',
        's' => 's',
        'wrote' => 'rašė',
        'Message' => 'Žinutė',
        'Error' => 'Klaida',
        'Bug Report' => 'Triktis apie defektą',
        'Attention' => 'Dėmesio',
        'Warning' => 'Perspėjimas',
        'Module' => 'Modulis',
        'Modulefile' => 'Modulio failas',
        'Subfunction' => 'Sub-funkcija',
        'Line' => 'Eilutė',
        'Setting' => 'Nustatymas',
        'Settings' => 'Nustatymai',
        'Example' => 'Pavyzdys',
        'Examples' => 'Pavyzdžiai',
        'valid' => 'galiojantis',
        'Valid' => 'Galiojantis',
        'invalid' => 'negaliojantis',
        'Invalid' => '',
        '* invalid' => '* negaliojantis',
        'invalid-temporarily' => 'laikinai negaliojantis',
        ' 2 minutes' => ' 2 minutės',
        ' 5 minutes' => ' 5 minutės',
        ' 7 minutes' => ' 7 minutės',
        '10 minutes' => '10 minučių',
        '15 minutes' => '15 minučių',
        'Mr.' => 'Ponas',
        'Mrs.' => 'Ponia',
        'Next' => 'Sekantis',
        'Back' => 'Atgal',
        'Next...' => 'Toliau...',
        '...Back' => '...Atgal',
        '-none-' => '-nėra-',
        'none' => 'nėra',
        'none!' => 'nėra!',
        'none - answered' => 'neatsakyta',
        'please do not edit!' => 'Prašome neredaguoti!',
        'Need Action' => 'Reikalingas veiksmas',
        'AddLink' => 'Pridėti nuorodą',
        'Link' => 'Susieti',
        'Unlink' => 'Atsieti',
        'Linked' => 'Susijęs',
        'Link (Normal)' => 'Nuoroda (Normali)',
        'Link (Parent)' => 'Nuoroda (Tėvinė?)',
        'Link (Child)' => 'Nuoroda (Vaikinė?)',
        'Normal' => 'Normaus',
        'Parent' => 'Tėvinis?',
        'Child' => 'Vaikinis?',
        'Hit' => '',
        'Hits' => '',
        'Text' => 'Tekstas',
        'Standard' => 'Standartinis',
        'Lite' => 'Paprastas',
        'User' => 'Naudotojas',
        'Username' => 'Naudotojo vardas',
        'Language' => 'Kalba',
        'Languages' => 'Kalbos',
        'Password' => 'Slaptažodis',
        'Preferences' => 'Asmeniniai nustatymai',
        'Salutation' => 'Kreipimosi forma(pasveikinimas)',
        'Salutations' => 'Kreipimosi formos(pasveikinimai)',
        'Signature' => 'Parašas',
        'Signatures' => 'Parašai',
        'Customer' => 'Klientas',
        'CustomerID' => 'Kliento ID',
        'CustomerIDs' => 'Kliento ID',
        'customer' => 'klientas',
        'agent' => 'agentas',
        'system' => 'sistema',
        'Customer Info' => 'Kliento info',
        'Customer Information' => 'Kliento informacija',
        'Customer Company' => 'Kliento organizacija',
        'Customer Companies' => 'Kliento organizacijos',
        'Company' => 'Organizacija',
        'go!' => 'eiti!',
        'go' => 'eiti',
        'All' => 'Visos',
        'all' => 'visi',
        'Sorry' => 'Atsiprašome',
        'update!' => 'atnaujinti!',
        'update' => 'atnaujinti',
        'Update' => 'Atnaujinti',
        'Updated!' => 'Atnaujinta!',
        'submit!' => 'Pateikti!',
        'submit' => 'Pateikti',
        'Submit' => 'Pateikti',
        'change!' => 'pakeisti!',
        'Change' => 'Pakeisti',
        'change' => 'pakeisti',
        'click here' => 'spauskite čia',
        'Comment' => 'Komentaras',
        'Invalid Option!' => 'Neleistina pasirinktis!',
        'Invalid time!' => 'Klaidingas laikas!',
        'Invalid date!' => 'Klaidinga data!',
        'Name' => 'Vardas',
        'Group' => 'Grupė',
        'Description' => 'Aprašymas',
        'description' => 'aprašymas',
        'Theme' => 'Tema',
        'Created' => 'Sukurtas',
        'Created by' => 'Sukūrė',
        'Changed' => 'Pakeistas',
        'Changed by' => 'Pakeitė',
        'Search' => 'Ieškoti',
        'and' => 'ir',
        'between' => 'tarp',
        'Fulltext Search' => 'Pilno teksto paieška',
        'Data' => 'Data',
        'Options' => 'Parinktys',
        'Title' => 'Antraštė',
        'Item' => 'Elementas',
        'Delete' => 'Ištrinti',
        'Edit' => 'Redaguoti',
        'View' => 'Žiūrėti',
        'Number' => 'Numeris',
        'System' => 'Sistema',
        'Contact' => 'Kontaktas',
        'Contacts' => 'Kontaktai',
        'Export' => 'Eksportuoti',
        'Up' => 'Į viršų',
        'Down' => 'Į apačią',
        'Add' => 'Pridėti',
        'Added!' => 'Pridėta!',
        'Category' => 'Kategorija',
        'Viewer' => 'Žiūryklė',
        'Expand' => 'Išplėsti',
        'Small' => 'Mažas',
        'Medium' => 'Vidutinis',
        'Large' => 'Didelis',
        'Date picker' => 'Datos parinkiklis',
        'New message' => 'Nauja žinutė',
        'New message!' => 'Nauja žinutė!',
        'Please answer this ticket(s) to get back to the normal queue view!' =>
            'Prašome atsakyti į šį triktį(-us), kad grįžtumėte prie įprastos eilės peržiūros!',
        'You have %s new message(s)!' => 'Jūs turite %s naują(-ų) žinutę(-čių)!',
        'You have %s reminder ticket(s)!' => 'Jūs turite %s priminimą(-ų) apie triktį(-us)!',
        'The recommended charset for your language is %s!' => 'Jūsų kalbai rekomenduojamas simbolių rinkinys yra %s!',
        'Change your password.' => 'Pasikeiskite slaptažodį.',
        'Please activate %s first!' => 'Prašome iš pradžių aktyvuoti %s!',
        'No suggestions' => 'Pasiūlymų nėra',
        'Word' => 'Žodis',
        'Ignore' => 'Ignoruoti',
        'replace with' => 'sukeisti su',
        'There is no account with that login name.' => 'Nėra paskyros su tokiu prisijungimo vardu.',
        'Login failed! Your user name or password was entered incorrectly.' =>
            'Prisijungimas nepavyko! Neteisingai įvestas prisijungimo vardas arba slaptažodis.',
        'There is no acount with that user name.' => 'Nėra paskyros su tokiu naudotojo vardu.',
        'Please contact your administrator' => 'Prašome susisiekti su savo administratoriumi',
        'Logout' => 'Atsijungti',
        'Logout successful. Thank you for using %s!' => 'Sėkmingai atsijungta! Ačiū, kad naudojatės %s!',
        'Feature not active!' => 'Funkcija/ypatybė neaktyvuota!',
        'Agent updated!' => 'Agentas atnaujintas!',
        'Create Database' => 'Sukurti duomenų bazę',
        'System Settings' => 'Sistemos nustatymai',
        'Mail Configuration' => 'Pašto konfigūracija',
        'Finished' => 'Baigta',
        'Install OTRS' => '',
        'Intro' => '',
        'License' => 'Licenzija',
        'Database' => 'Duomenų bazė',
        'Configure Mail' => '',
        'Database deleted.' => '',
        'Database setup successful!' => '',
        'Generated password' => '',
        'Login is needed!' => 'Reikia prisijungimo vardo!',
        'Password is needed!' => 'Reikia slaptažodžio!',
        'Take this Customer' => 'Imti šį klientą',
        'Take this User' => 'Imti šį naudotoją',
        'possible' => 'galima',
        'reject' => 'atmesti',
        'reverse' => 'atšaukti/panaikinti',
        'Facility' => 'Priemonė/įranga (Facility)',
        'Time Zone' => 'Laiko zona',
        'Pending till' => 'Laukia sprendimo iki',
        'Don\'t use the Superuser account to work with OTRS! Create new Agents and work with these accounts instead.' =>
            'Nenaudokite supernaudotojo darbui su OTRS! Vietoje to sukurkite naujus agentus ir dirbkite naudodami juos.',
        'Dispatching by email To: field.' => 'Išsiuntinėti pagal el. pašto Kam: laukelį.',
        'Dispatching by selected Queue.' => 'Išsiuntinėti pagal pasirinktą eilę.',
        'No entry found!' => 'Įrašas nerastas!',
        'Session invalid. Please log in again.' => '',
        'Session has timed out. Please log in again.' => 'Baigėsi sesijai skirtas laikas. Prisijunkite iš naujo',
        'Session limit reached! Please try again later.' => '',
        'No Permission!' => 'Nėra leidimo!',
        '(Click here to add)' => '(Spauskite čia, kad pridėti)',
        'Preview' => 'Peržiūra',
        'Package not correctly deployed! Please reinstall the package.' =>
            '',
        '%s is not writable!' => 'Negalima įrašyti į %s!',
        'Cannot create %s!' => 'Nepavyksta sukurti %s!',
        'Check to activate this date' => '',
        'You have Out of Office enabled, would you like to disable it?' =>
            '',
        'Customer %s added' => 'Klientas %s pridėtas',
        'Role added!' => 'Rolė pridėta!',
        'Role updated!' => 'Rolė atnaujinta!',
        'Attachment added!' => 'Priedas pridėtas!',
        'Attachment updated!' => 'Priedas atnaujintas!',
        'Response added!' => 'Atsakymas pridėtas!',
        'Response updated!' => 'Atsakymas atnaujintas!',
        'Group updated!' => 'Grupė atnaujinta',
        'Queue added!' => 'Eilė pridėta!',
        'Queue updated!' => 'Eilė atnaujinta!',
        'State added!' => 'Būsena pridėta!',
        'State updated!' => 'Būsena atnaujinta!',
        'Type added!' => 'Tipas pridėtas!',
        'Type updated!' => 'Tipas atnaujintas!',
        'Customer updated!' => 'Klientas atnaujintas!',
        'Customer company added!' => '',
        'Customer company updated!' => '',
        'Mail account added!' => '',
        'Mail account updated!' => '',
        'System e-mail address added!' => '',
        'System e-mail address updated!' => '',
        'Contract' => 'Kontraktas',
        'Online Customer: %s' => 'Prisijungę klientai: %s',
        'Online Agent: %s' => 'Prisijungę agentai: %s',
        'Calendar' => 'Kalendorius',
        'File' => 'Failas',
        'Filename' => 'Failo pavadinimas',
        'Type' => 'Tipas',
        'Size' => 'Dydis',
        'Upload' => 'Įkelti',
        'Directory' => 'Direktorija',
        'Signed' => 'Pasirašytas',
        'Sign' => 'Pasirašyti',
        'Crypted' => 'Šifruotas',
        'Crypt' => 'Šifras',
        'PGP' => 'PGP',
        'PGP Key' => 'PGP raktas',
        'PGP Keys' => 'PGP raktai',
        'S/MIME' => 'S/MIME',
        'S/MIME Certificate' => 'S/MIME sertifikatas',
        'S/MIME Certificates' => 'S/MIME sertifikatai',
        'Office' => 'Biuras',
        'Phone' => 'Telefonas',
        'Fax' => 'Faksas',
        'Mobile' => 'Mobilus telefonas',
        'Zip' => 'Pašto kodas',
        'City' => 'Miestas',
        'Street' => 'Gatvė',
        'Country' => 'Šalis',
        'Location' => 'Vietovė',
        'installed' => 'įdiegtas',
        'uninstalled' => 'neįdiegtas',
        'Security Note: You should activate %s because application is already running!' =>
            'Saugumo pastaba: turėtumėte aktyvuoti %s, nes aplikacija jau vykdoma!',
        'Unable to parse repository index document.' => 'Nepavyko išnagrinėti saugyklos indeksų dokumento.',
        'No packages for your framework version found in this repository, it only contains packages for other framework versions.' =>
            'Šioje saugykloje nėra paketų Jūsų naudojamai pagrindo (framework) versijai, yra tik kitoms versijoms.',
        'No packages, or no new packages, found in selected repository.' =>
            'Pasirinktoje saugykloje arba nėra naujų paketų, arba išvis nėra jokių paketų.',
        'Edit the system configuration settings.' => 'Keisti sistemos konfigūracijos nustatymus',
        'printed at' => 'spausdinta',
        'Loading...' => 'Kraunasi...',
        'Dear Mr. %s,' => 'Gerbiamas pone %s,',
        'Dear Mrs. %s,' => 'Gerbiama ponia %s,',
        'Dear %s,' => 'Gerbiamas %s,',
        'Hello %s,' => 'Sveiki %s,',
        'This email address already exists. Please log in or reset your password.' =>
            'Šis el. pašto adresas jau yra. Prašome prisijungti arba atsistatyti slaptažodį.',
        'New account created. Sent login information to %s. Please check your email.' =>
            'Sukruta nauja paskyra. Prisijungimo informacija išiųsta į %s. Prašome pasitikrinti savo el. paštą.',
        'Please press Back and try again.' => 'Prašome spausti Atgal ir bandyti dar kartą.',
        'Sent password reset instructions. Please check your email.' => 'Slaptažodžio atstatymo instrukcijos išsiųstos. Prašome pasitikrinti savo el. paštą.',
        'Sent new password to %s. Please check your email.' => 'Naujas slaptažodis išsiųstas į %s. Prašome pasitikrinti savo el. paštą.',
        'Upcoming Events' => 'Artėjantys įvykiai',
        'Event' => 'Įvykis',
        'Events' => 'Įvykiai',
        'Invalid Token!' => 'Negalimas triktis!',
        'more' => 'daugiau',
        'Collapse' => 'Sutraukti',
        'Shown' => 'Rodomi',
        'Shown customer users' => '',
        'News' => 'Naujienos',
        'Product News' => 'Produkto naujienos',
        'OTRS News' => 'OTRS Naujienos',
        '7 Day Stats' => '7 dienų statistika',
        'Process Management information from database is not in sync with the system configuration, please synchronize all processes.' =>
            '',
        'Package not verified by the OTRS Group! It is recommended not to use this package.' =>
            '',
        '<br>If you continue to install this package, the following issues may occur!<br><br>&nbsp;-Security problems<br>&nbsp;-Stability problems<br>&nbsp;-Performance problems<br><br>Please note that issues that are caused by working with this package are not covered by OTRS service contracts!<br><br>' =>
            '',
        'Bold' => 'Paryškintas',
        'Italic' => 'Pasviręs',
        'Underline' => 'Pabrauktas',
        'Font Color' => 'Šrifto spalva',
        'Background Color' => 'Fono spalva',
        'Remove Formatting' => 'Panaikinti formatavimą',
        'Show/Hide Hidden Elements' => 'Rodyti/Slėpti paslėptus elementus',
        'Align Left' => 'Lygiuoti kairėje',
        'Align Center' => 'Lygiuoti centre',
        'Align Right' => 'Lygiuoti dešinėje',
        'Justify' => 'Lygiuoti pagal abi kraštines',
        'Header' => 'Antraštė',
        'Indent' => 'Įtrauka',
        'Outdent' => 'Atitrauka',
        'Create an Unordered List' => 'Sukurti nerikiuotą sąrašą',
        'Create an Ordered List' => 'Sukurti rikiuotą sąrašą',
        'HTML Link' => 'HTML nuoroda',
        'Insert Image' => 'Įterpti paveikslėlį',
        'CTRL' => 'CTRL',
        'SHIFT' => 'SHIFT',
        'Undo' => 'Atšaukti',
        'Redo' => 'Atstatyti',
        'Scheduler process is registered but might not be running.' => '',
        'Scheduler is not running.' => '',

        # Template: AAACalendar
        'New Year\'s Day' => 'Naujieji metai',
        'International Workers\' Day' => 'Tarptautinė darbuotojų diena',
        'Christmas Eve' => 'Kūčios',
        'First Christmas Day' => 'Pirmoji Kalėdų diena',
        'Second Christmas Day' => 'Antroji Kalėdų diena',
        'New Year\'s Eve' => 'Naujųjų Metų išvakarės',

        # Template: AAAGenericInterface
        'OTRS as requester' => '',
        'OTRS as provider' => '',
        'Webservice "%s" created!' => '',
        'Webservice "%s" updated!' => '',

        # Template: AAAMonth
        'Jan' => 'Sau',
        'Feb' => 'Vas',
        'Mar' => 'Kov',
        'Apr' => 'Bal',
        'May' => 'Geg',
        'Jun' => 'Bir',
        'Jul' => 'Lie',
        'Aug' => 'Rug',
        'Sep' => 'Rugs',
        'Oct' => 'Spa',
        'Nov' => 'Lap',
        'Dec' => 'Gruo',
        'January' => 'Sausis',
        'February' => 'Vasaris',
        'March' => 'Kovas',
        'April' => 'Balandis',
        'May_long' => 'Gegužė',
        'June' => 'Birželis',
        'July' => 'Liepa',
        'August' => 'Rugpjūtis',
        'September' => 'Rugsėjis',
        'October' => 'Spalis',
        'November' => 'Lapkritis',
        'December' => 'Gruodis',

        # Template: AAAPreferences
        'Preferences updated successfully!' => 'Nustatymai sėkmingai atnaujinti!',
        'User Profile' => 'Naudotojo profilis',
        'Email Settings' => 'Elektroninio pašto nustatymai',
        'Other Settings' => 'Kiti nustatymai',
        'Change Password' => 'Pakeisti slaptažodį',
        'Current password' => '',
        'New password' => 'Naujas slaptažodis',
        'Verify password' => 'Patikrinti slaptažodį',
        'Spelling Dictionary' => 'Rašybos žodynas',
        'Default spelling dictionary' => 'Numatytasis rašybos žodynas',
        'Max. shown Tickets a page in Overview.' => 'Daugiausia, apžvalgoje rodomų, trikčių viename puslapyje.',
        'The current password is not correct. Please try again!' => 'Dabartinis slaptažodis įvestas neteisingai. Bandykite iš naujo!',
        'Can\'t update password, your new passwords do not match. Please try again!' =>
            'Neįmanoma atnaujinti slaptažodžio, nes nesutampa Jūsų įvesti nauji slaptažodžiai!',
        'Can\'t update password, it contains invalid characters!' => 'Neįmanoma atnaujinti slaptažodžio, nes jame yra neleistinų simbolių.',
        'Can\'t update password, it must be at least %s characters long!' =>
            'Neįmanoma atnaujinti slaptažodžio. Jis turi būti mažiausiai %s simbolių ilgio.',
        'Can\'t update password, it must contain at least 2 lowercase  and 2 uppercase characters!' =>
            'Neįmanoma atnaujinti slaptažodžio. Slaptažodį turi sudaryti mažiausiai 2 didžiosios ir 2 mažosios raidės.',
        'Can\'t update password, it must contain at least 1 digit!' => 'Neįmanoma atnaujinti slaptažodžio. Slaptažodyje turi būti bent 1 skaitmuo.',
        'Can\'t update password, it must contain at least 2 characters!' =>
            'Neįmanoma atnaujinti slaptažodžio. Slaptažodis turi būti mažiausiai 2 simbolių ilgio.',
        'Can\'t update password, this password has already been used. Please choose a new one!' =>
            'Neįmanoma atnaujinti slaptažodžio. Šis slaptažodis jau buvo naudotas. Prašome pasirinkti naują!',
        'Select the separator character used in CSV files (stats and searches). If you don\'t select a separator here, the default separator for your language will be used.' =>
            'Pasirinkite skyriklį, kurį norite naudoti CSV failuose (statistikoje ir paieškoje) arba bus naudojamas standartinis Jūsų kalbos skyriklis.',
        'CSV Separator' => 'CSV skyriklis',

        # Template: AAAStats
        'Stat' => 'Statistika',
        'Sum' => 'Suma',
        'Please fill out the required fields!' => 'Prašome užpildyti būtinus laukus!',
        'Please select a file!' => 'Prašome pasirinkti failą!',
        'Please select an object!' => 'Prašome pasirinkti objektą!',
        'Please select a graph size!' => 'Prašome pasirinkti diagramos dydį!',
        'Please select one element for the X-axis!' => 'Prašome pasirinkti elementą X ašiai!',
        'Please select only one element or turn off the button \'Fixed\' where the select field is marked!' =>
            'Prašome pasirinkti tik vieną elementą arba nuimti mygtuko "Fiksuota" varnelę!',
        'If you use a checkbox you have to select some attributes of the select field!' =>
            'Jeigu naudojate žymeles turite pasirinkti kurias nors reikšmes ir pasirinkimo laukelio!',
        'Please insert a value in the selected input field or turn off the \'Fixed\' checkbox!' =>
            'Prašome įveasti reikšmę į pasirinktą įvedimo laukelį arba atžymėti \'Fiksuotas\'!',
        'The selected end time is before the start time!' => 'Pasirinktas pabaigos laikas yra ankstesnis negu pradžios laikas!',
        'You have to select one or more attributes from the select field!' =>
            'Privalote pasirinkti bent vieną reikšmę iš pasirinkto lauko!',
        'The selected Date isn\'t valid!' => 'Pasirinkta data yra klaidinga!',
        'Please select only one or two elements via the checkbox!' => 'Prašome pasirinkti tik vieną ar du elemntus iš checkbox!',
        'If you use a time scale element you can only select one element!' =>
            'Jeigu naudojate laiko skalės elementą, tai galite pasirinkti tik vieną elementą!',
        'You have an error in your time selection!' => 'Jūsų datos pasirinkime yra klaida!',
        'Your reporting time interval is too small, please use a larger time scale!' =>
            'Jūsų pasirinktas ataskaitos intervalas yra per trumpas. Prašome pasirinkti didesnę laiko skalę!',
        'The selected start time is before the allowed start time!' => 'Pasirinktas pradžios laikas yra prieš ankstesnis negu leidžiamas pradžios laikas!',
        'The selected end time is after the allowed end time!' => 'Pasirinktas pabaigos laikas yra vėlesnis negu leistinas pabaigos laikas!',
        'The selected time period is larger than the allowed time period!' =>
            'Pasirinktas laikotarpis yra ilgesnis negu leistina!',
        'Common Specification' => 'Bendroji specifikacija',
        'X-axis' => 'X ašis',
        'Value Series' => 'Reikšmių serija',
        'Restrictions' => 'Apribojimai',
        'graph-lines' => 'Linijinė diagrama',
        'graph-bars' => 'Stulpelinė diagrama',
        'graph-hbars' => 'Juostinė (horizontalūs stulpeliai) diagrama',
        'graph-points' => 'Taškinė diagrama',
        'graph-lines-points' => 'Linijinė-taškinė diagrama',
        'graph-area' => 'Plokštuminė diagrama',
        'graph-pie' => 'Skritulinė diagrama',
        'extended' => 'išplėsta',
        'Agent/Owner' => 'Agentas/Savininkas',
        'Created by Agent/Owner' => 'Sukurta agento/savininko',
        'Created Priority' => 'Sukūrimo prioritetas',
        'Created State' => 'Sukūrimo būsena',
        'Create Time' => 'Sukūrimo laikas',
        'CustomerUserLogin' => 'Kliento Naudotojo Prisijungimas',
        'Close Time' => 'Uždarymo laikas',
        'TicketAccumulation' => 'Trikčių sankaupa (accumulation)',
        'Attributes to be printed' => 'Atributai spausdinimui',
        'Sort sequence' => 'Rūšiavimo seka',
        'Order by' => 'Rikiuoti pagal',
        'Limit' => 'Limitas',
        'Ticketlist' => 'Trikčių sąrašas',
        'ascending' => 'didėjančia tvarka',
        'descending' => 'mažėjančia tvarka',
        'First Lock' => 'Pirmasis užrakinimas',
        'Evaluation by' => 'Įvertinimas pagal',
        'Total Time' => 'Iš viso laiko',
        'Ticket Average' => 'Trikčių vidurkis',
        'Ticket Min Time' => 'Trikčių minimalus laikas',
        'Ticket Max Time' => 'Trikčių maksimalus laikas',
        'Number of Tickets' => 'Trikčių kiekis',
        'Article Average' => 'Straipsnių vidurkis',
        'Article Min Time' => 'Straipsnių minimalus laikas',
        'Article Max Time' => 'Straipsnių maksimalus laikas',
        'Number of Articles' => 'Straipsnių kiekis',
        'Accounted time by Agent' => 'Apskaičiuotas laikas pagal agentą',
        'Ticket/Article Accounted Time' => 'Trikčių/agentų apskaičiuotas laikas',
        'TicketAccountedTime' => 'Trikties apskaičiuotas laikas',
        'Ticket Create Time' => 'Trikties sukūrimo laikas',
        'Ticket Close Time' => 'Trikties uždarymo laikas',

        # Template: AAATicket
        'Status View' => 'Būsenos peržiūra',
        'Bulk' => 'Masiškai',
        'Lock' => 'Užrakinti',
        'Unlock' => 'Atrakinti',
        'History' => 'Istorija',
        'Zoom' => 'Priartinti',
        'Age' => 'Amžius',
        'Bounce' => 'Nukreipti (Bounce)',
        'Forward' => 'Persiųsti',
        'From' => 'Nuo',
        'To' => 'Kam',
        'Cc' => 'Kopija',
        'Bcc' => 'Bcc',
        'Subject' => 'Tema',
        'Move' => 'Perkelti',
        'Queue' => 'Eilė',
        'Queues' => 'Eilės',
        'Priority' => 'Prioritetas',
        'Priorities' => 'Prioritetai',
        'Priority Update' => 'Prioritetu atnaujinimas',
        'Priority added!' => '',
        'Priority updated!' => '',
        'Signature added!' => '',
        'Signature updated!' => '',
        'SLA' => '',
        'Service Level Agreement' => 'Aptarnavimo lygio sutartis',
        'Service Level Agreements' => 'Aptarnavimo lygio sutartys',
        'Service' => 'Paslauga',
        'Services' => 'Paslaugos',
        'State' => 'Būsena',
        'States' => 'Būsenos',
        'Status' => 'Statusas',
        'Statuses' => 'Statusai',
        'Ticket Type' => 'Trikties tipas',
        'Ticket Types' => 'Trikties tipai',
        'Compose' => 'Sukurti',
        'Pending' => 'Laukiantis sprendimo',
        'Owner' => 'Savininkas',
        'Owner Update' => 'Savininko pakeitimas',
        'Responsible' => 'Atsakingas',
        'Responsible Update' => 'Atsakingo atnaujinimas',
        'Sender' => 'Siuntėjas',
        'Article' => 'Straipsnis',
        'Ticket' => 'Triktis',
        'Createtime' => 'Sukūrimo laikas',
        'plain' => 'paprastas',
        'Email' => 'El. paštas',
        'email' => 'el. paštas',
        'Close' => 'Užverti',
        'Action' => 'Veiksmas',
        'Attachment' => 'Priedas',
        'Attachments' => 'Priedai',
        'This message was written in a character set other than your own.' =>
            'Ši žinutė parašyta kitokiu simbolių rinkiniu negu Jūsų esama.',
        'If it is not displayed correctly,' => 'Jeigu neatvaizduojama teisingai,',
        'This is a' => 'Tai yra',
        'to open it in a new window.' => 'atverti naujame lange',
        'This is a HTML email. Click here to show it.' => 'Šis el. laiškas yra HTML formatu. Spauskite čia jeigu norite jį pamatyti.',
        'Free Fields' => 'Laisvi laukeliai',
        'Merge' => 'Sujungti',
        'merged' => 'sujungti',
        'closed successful' => 'uždarytas sėkmingai',
        'closed unsuccessful' => 'uždarytas nesėkmingai',
        'Locked Tickets Total' => 'Iš viso užrakintų trikčių',
        'Locked Tickets Reminder Reached' => '',
        'Locked Tickets New' => 'Nauji užrakintos triktys',
        'Responsible Tickets Total' => 'Iš viso atsakingų trikčių',
        'Responsible Tickets New' => 'Naujos atsakingos triktys',
        'Responsible Tickets Reminder Reached' => '',
        'Watched Tickets Total' => 'Iš viso stebimų trikčių',
        'Watched Tickets New' => 'Naujos stebimos triktys',
        'Watched Tickets Reminder Reached' => '',
        'All tickets' => 'Visos triktys',
        'Available tickets' => '',
        'Escalation' => 'Eskalavimas',
        'last-search' => 'Paskutinė paieška',
        'QueueView' => 'Eilių peržiūra',
        'Ticket Escalation View' => 'Trikčių eskalavimo peržiūra',
        'Message from' => '',
        'End message' => '',
        'Forwarded message from' => '',
        'End forwarded message' => '',
        'new' => 'naujas',
        'open' => 'atidarytas',
        'Open' => 'Atidarytas',
        'Open tickets' => '',
        'closed' => 'uždarytas',
        'Closed' => 'Uždarytas',
        'Closed tickets' => '',
        'removed' => 'pašalintas',
        'pending reminder' => 'laukiantis priminimas',
        'pending auto' => 'laukia auto',
        'pending auto close+' => 'laukia automatiško uždarymo kaip sėkmingas',
        'pending auto close-' => 'laukia automatiško uždarymo kaip nesėkmingas',
        'email-external' => 'Išorinis el. paštas',
        'email-internal' => 'Vidinis el. paštas',
        'note-external' => 'Išorinė pastaba',
        'note-internal' => 'Vidinė pastaba',
        'note-report' => 'Pastaba ataskaitai',
        'phone' => 'Telefonas',
        'sms' => 'SMS',
        'webrequest' => 'Web užklausa',
        'lock' => 'užrakintas',
        'unlock' => 'atrakintas',
        'very low' => 'labai žemas',
        'low' => 'žemas',
        'normal' => 'normalus',
        'high' => 'aukštas',
        'very high' => 'labai aukštas',
        '1 very low' => '1 labai žemas',
        '2 low' => '2 žemas',
        '3 normal' => '3 normalus',
        '4 high' => '4 aukštas',
        '5 very high' => '5 labai aukštas',
        'auto follow up' => '',
        'auto reject' => '',
        'auto remove' => '',
        'auto reply' => '',
        'auto reply/new ticket' => '',
        'Ticket "%s" created!' => 'Triktis "%s" sukurta!',
        'Ticket Number' => 'Trikties numeris',
        'Ticket Object' => 'Trikties objektas',
        'No such Ticket Number "%s"! Can\'t link it!' => 'Nėra trikties numeriu "%s"! Negalima jo susieti!',
        'You don\'t have write access to this ticket.' => '',
        'Sorry, you need to be the ticket owner to perform this action.' =>
            '',
        'Please change the owner first.' => '',
        'Ticket selected.' => '',
        'Ticket is locked by another agent.' => 'Triktį užrakino kitas agentas!',
        'Ticket locked.' => '',
        'Don\'t show closed Tickets' => 'Nerodyti uždarytų trikčių',
        'Show closed Tickets' => 'Rodyti uždarytus triktimis',
        'New Article' => 'Naujas straipsnis',
        'Unread article(s) available' => 'Prieinami neperskaityti straipsniai',
        'Remove from list of watched tickets' => 'Pašalinti iš stebimų trikčių sąrašo',
        'Add to list of watched tickets' => 'Pridėti prie stebimų trikčių sąrašo',
        'Email-Ticket' => 'Triktis el. paštu',
        'Create new Email Ticket' => 'Sukurti naują el. pašto triktį',
        'Phone-Ticket' => 'Triktis telefonu',
        'Search Tickets' => 'Ieškoti trikčių',
        'Edit Customer Users' => 'Redaguoti kliento naudotojus',
        'Edit Customer Company' => 'Redaguoti kliento organizaciją',
        'Bulk Action' => 'Masinis veiksmas',
        'Bulk Actions on Tickets' => 'Masinis veiksmas triktims',
        'Send Email and create a new Ticket' => 'Išsiųsti el. laišką ir sukurti naują triktį',
        'Create new Email Ticket and send this out (Outbound)' => 'Sukurti naują el. pašto triktį ir išsiųsti jį (Išorinis)',
        'Create new Phone Ticket (Inbound)' => 'Sukurti naują telefoninį triktį (vidinis)',
        'Address %s replaced with registered customer address.' => '',
        'Customer automatically added in Cc.' => '',
        'Overview of all open Tickets' => 'Visų atvirų trikčių apžvalga',
        'Locked Tickets' => 'Užrakintos triktys',
        'My Locked Tickets' => 'Mano užrakintos triktys',
        'My Watched Tickets' => 'Mano stebimos triktys',
        'My Responsible Tickets' => 'Triktys už kuriuos aš atsakingas',
        'Watched Tickets' => 'Stebimos triktys',
        'Watched' => 'Stebimi',
        'Watch' => 'Stebėti',
        'Unwatch' => 'Nestebėti',
        'Lock it to work on it' => '',
        'Unlock to give it back to the queue' => '',
        'Show the ticket history' => '',
        'Print this ticket' => '',
        'Print this article' => '',
        'Split' => '',
        'Split this article' => '',
        'Forward article via mail' => '',
        'Change the ticket priority' => '',
        'Change the ticket free fields!' => 'Keisti trikties laisvus laukelius',
        'Link this ticket to other objects' => '',
        'Change the owner for this ticket' => '',
        'Change the  customer for this ticket' => '',
        'Add a note to this ticket' => '',
        'Merge into a different ticket' => '',
        'Set this ticket to pending' => '',
        'Close this ticket' => '',
        'Look into a ticket!' => 'Pažiūrėti triktį!',
        'Delete this ticket' => '',
        'Mark as Spam!' => 'Pažymėti kaip Spam!',
        'My Queues' => 'Mano eilės',
        'Shown Tickets' => 'Rodomos triktys',
        'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' =>
            'Jūsų el. laiškas trikties numeriu "<OTRS_TICKET>" yra sujungtas su "<OTRS_MERGE_TO_TICKET>"!',
        'Ticket %s: first response time is over (%s)!' => 'Triktis %s: baigėsi pirmojo atsakymo laikas (%s)!',
        'Ticket %s: first response time will be over in %s!' => 'Triktis %s: pirmojo atsakymo laikas pasibaigs po %s!',
        'Ticket %s: update time is over (%s)!' => 'Triktis %s: baigėsi atnaujinimo laikas (%s)!',
        'Ticket %s: update time will be over in %s!' => 'Triktis %s: atnaujinimo laikas pasibaigs po %s!',
        'Ticket %s: solution time is over (%s)!' => 'Triktis %s: baigėsi išsprendimo laikas (%s)!',
        'Ticket %s: solution time will be over in %s!' => 'Triktis %s: išsprendimo laikas baigsis po %s!',
        'There are more escalated tickets!' => 'Yra ir daugiau eskaluotų trikčių!',
        'Plain Format' => 'Paprastas formatas',
        'Reply All' => 'Atsakyti visiems',
        'Direction' => 'Kryptis',
        'Agent (All with write permissions)' => 'Agentas (Visi su rašymo leidimais)',
        'Agent (Owner)' => 'Agentas (Savininkas)',
        'Agent (Responsible)' => 'Agentas (Atsakingas)',
        'New ticket notification' => 'Perspėjimas apie naują triktį',
        'Send me a notification if there is a new ticket in "My Queues".' =>
            'Siųsti perspėjimą jeigu yra naujų trikčių "mano eilėse".',
        'Send new ticket notifications' => 'Siųsti perspėjimus apie naujus triktimis',
        'Ticket follow up notification' => 'Trikties eigos informacija',
        'Ticket lock timeout notification' => 'Perspėjimas apie trikties užrakinimo laikotarpio pabaigą',
        'Send me a notification if a ticket is unlocked by the system.' =>
            'Siųsti man perspėjimą jeigu sistema atrakina triktį',
        'Send ticket lock timeout notifications' => 'Siųsti perspėjimus apie trikties užrakinimo laikotarpio pabaigą',
        'Ticket move notification' => 'Įspėjimas apie trikties perkėlimą',
        'Send me a notification if a ticket is moved into one of "My Queues".' =>
            'Siųsti man įspėjimą jeigu triktis yra perkeliamas į vieną iš "mano eilių".',
        'Send ticket move notifications' => 'Siųsti įspėjimus apie trikties perkėlimą',
        'Your queue selection of your favourite queues. You also get notified about those queues via email if enabled.' =>
            'Jūsų mėgstamiausių eilių rinkinys. Taip pat būsite informuoti apie šias eiles jei įjungsite (įgalinsite) tokią funkciją.',
        'Custom Queue' => 'Pasirinktinė (nestandartinė) eilė',
        'QueueView refresh time' => 'Eilių peržiūros lango atnaujinimo intervalas',
        'If enabled, the QueueView will automatically refresh after the specified time.' =>
            'Eilių peržiūra automatiškai atsinaujins po nurodyto laiko, jeigu tai įjungsite',
        'Refresh QueueView after' => 'Atnaujinti eilių peržiūrą po',
        'Screen after new ticket' => 'Langas po naujo trikties sukūrimo',
        'Show this screen after I created a new ticket' => 'Rodyti šį langą po to kai sukursiu naują triktį',
        'Closed Tickets' => 'Uždarytos triktys',
        'Show closed tickets.' => 'Rodyti uždarytus triktimis.',
        'Max. shown Tickets a page in QueueView.' => 'Eilių peržiūroje rodomų trikčių kiekis.',
        'Ticket Overview "Small" Limit' => 'Trikčių apžvalgos "mažasis(apatinis)" limitas',
        'Ticket limit per page for Ticket Overview "Small"' => 'Trikčių limitas puslapyje "mažąjam/apatiniam" apžvalgos(overview) limitui',
        'Ticket Overview "Medium" Limit' => 'Trikčių apžvalgos "vidutinis" limitas',
        'Ticket limit per page for Ticket Overview "Medium"' => 'Trikčių limitas puslapyje "vidutinaim" apžvalgos(overview) limitui',
        'Ticket Overview "Preview" Limit' => 'Trikčių apžvalgos "peržiūros" limitas',
        'Ticket limit per page for Ticket Overview "Preview"' => 'Trikčių limitas puslapyje "peržiūros(preview)" apžvalgos(overview) limitui',
        'Ticket watch notification' => 'Pranešimas apie trikties stebėjimą',
        'Send me the same notifications for my watched tickets that the ticket owners will get.' =>
            'Mano stebimoms triktims siųsti man tuos pačius pranešimus, kuriuos gaus ir patys pranešimų savininkai.',
        'Send ticket watch notifications' => 'Siųsti pranešimus apie trikčių stebėjimą',
        'Out Of Office Time' => 'Ne darbo laikas',
        'New Ticket' => 'Nauja triktis',
        'Create new Ticket' => 'Sukurti naują triktį',
        'Customer called' => '',
        'phone call' => 'Skambutis telefonu',
        'Phone Call Outbound' => 'Išeinantis skambutis telefonu',
        'Phone Call Inbound' => 'Įeinantis skambutis telefonu',
        'Reminder Reached' => 'Pasiektas priminimas',
        'Reminder Tickets' => 'Pranešimai su priminimu',
        'Escalated Tickets' => 'Eskaluotos triktys',
        'New Tickets' => 'Naujos triktys',
        'Open Tickets / Need to be answered' => 'Atviros / Laukiančios atsakymo triktys',
        'All open tickets, these tickets have already been worked on, but need a response' =>
            'Visos atviros triktys su kuriomis jau buvo dirbta, bet joms dar reikia atsako',
        'All new tickets, these tickets have not been worked on yet' => 'Visos naujos triktys su kuriomis dar nebuvo dirbta',
        'All escalated tickets' => 'Visos eskaluotos triktys',
        'All tickets with a reminder set where the reminder date has been reached' =>
            'Visos triktys turinčios nustatytus priminimus, kurių priminimo laikai jau atėjo',
        'Archived tickets' => '',
        'Unarchived tickets' => '',
        'History::Move' => 'Triktis perkelta iš eilės "%s" (%s) į eilę "%s" (%s).',
        'History::TypeUpdate' => 'Tipas pakeistas į "%s" (ID=%s).',
        'History::ServiceUpdate' => 'Servisas pakeistas į "%s" (ID=%s).',
        'History::SLAUpdate' => 'SLA pakeistas į "%s" (ID=%s).',
        'History::NewTicket' => 'Nauja triktis [%s] sukurta (Q=%s;P=%s;S=%s).',
        'History::FollowUp' => 'FollowUp [%s]. %s',
        'History::SendAutoReject' => 'Išsiųstas "%s" automatinis atmetimas.',
        'History::SendAutoReply' => 'Išsiųstas "%s" automatinis atsakymas.',
        'History::SendAutoFollowUp' => 'Išsiųstas "%s" automatinis FollowUp.',
        'History::Forward' => 'Persiųstas į "%s".',
        'History::Bounce' => 'Nukreiptas į "%s".',
        'History::SendAnswer' => 'El. laikas nusiųstas į "%s".',
        'History::SendAgentNotification' => '"%s"-pranešimas nusiųstas į "%s".',
        'History::SendCustomerNotification' => 'Pranešimas nusiųstas į "%s".',
        'History::EmailAgent' => 'Klientui nusiųstas el. laiškas.',
        'History::EmailCustomer' => 'Pridėtas el. paštas. %s',
        'History::PhoneCallAgent' => 'Agentas skalbino klientui.',
        'History::PhoneCallCustomer' => 'Klientas skambino mums.',
        'History::AddNote' => 'Pridėta pastaa (%s)',
        'History::Lock' => 'Triktis užrakinta.',
        'History::Unlock' => 'Triktis atrakinta.',
        'History::TimeAccounting' => 'Apskaičiuota %s laiko vientetų. Dabar iš viso %s laiko vienetų.',
        'History::Remove' => '%s',
        'History::CustomerUpdate' => 'Atnaujintas: %s',
        'History::PriorityUpdate' => 'Prioritetas pakeistas iš "%s" (%s) į "%s" (%s).',
        'History::OwnerUpdate' => 'Naujas savininkas yra "%s" (ID=%s).',
        'History::LoopProtection' => 'Loop-Protection! Keine Auto-Antwort versandt an "%s".',
        'History::Misc' => '%s',
        'History::SetPendingTime' => 'Aktualisiert: %s',
        'History::StateUpdate' => 'Alt: "%s" Neu: "%s"',
        'History::TicketDynamicFieldUpdate' => '',
        'History::WebRequestCustomer' => 'Kliento užklausa internetu.',
        'History::TicketLinkAdd' => 'Pridėti trikties sąsaja "%s".',
        'History::TicketLinkDelete' => 'Pašalinta trikties sąsaja "%s".',
        'History::Subscribe' => '',
        'History::Unsubscribe' => '',
        'History::SystemRequest' => '',
        'History::ResponsibleUpdate' => 'Naujas atsakingas asmuo yra "%s" (ID=%s).',
        'History::ArchiveFlagUpdate' => '',

        # Template: AAAWeekDay
        'Sun' => 'S',
        'Mon' => 'Pr',
        'Tue' => 'A',
        'Wed' => 'T',
        'Thu' => 'K',
        'Fri' => 'P',
        'Sat' => 'Š',

        # Template: AdminAttachment
        'Attachment Management' => 'Priedų valdymas',
        'Actions' => 'Veiksmai',
        'Go to overview' => 'Eiti į peržiūrą',
        'Add attachment' => 'Pridėti priedą',
        'List' => 'Sąrašas',
        'Validity' => '',
        'No data found.' => 'Nerasta duomenų.',
        'Download file' => 'Parsisiųsti failą',
        'Delete this attachment' => 'Ištrinti šį priedą',
        'Add Attachment' => 'Pridėti Priedą',
        'Edit Attachment' => 'Keisti priedą',
        'This field is required.' => 'Šis laukelis yra būtinas.',
        'or' => 'arba',

        # Template: AdminAutoResponse
        'Auto Response Management' => 'Automatinių atsakymų valdymas',
        'Add auto response' => 'Pridėti automatinį atsakymą',
        'Add Auto Response' => 'Pridėti Automatinį atsakymą',
        'Edit Auto Response' => 'Redaguoti automatinį atsakymą',
        'Response' => 'Atsakymas',
        'Auto response from' => 'Automatinis atsakymas nuo',
        'Reference' => 'Nuoroda (Reference)',
        'You can use the following tags' => 'Galite naudoti šias žymeles',
        'To get the first 20 character of the subject.' => '',
        'To get the first 5 lines of the email.' => '',
        'To get the realname of the sender (if given).' => '',
        'To get the article attribute' => '',
        ' e. g.' => 'pvz.',
        'Options of the current customer user data' => 'Šio kliento naudotojo duomenų parinktys',
        'Ticket owner options' => 'Trikties savininko parinktys',
        'Ticket responsible options' => '',
        'Options of the current user who requested this action' => 'Naudotojo prašiusio šio veiksmo parinktys',
        'Options of the ticket data' => 'Trikties duomenų parinktys',
        'Options of ticket dynamic fields internal key values' => '',
        'Options of ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            '',
        'Config options' => 'Konfigūracijos parinktys',
        'Example response' => 'Atsakymo pavyzdys',

        # Template: AdminCustomerCompany
        'Customer Company Management' => 'Kliento  valdymas',
        'Wildcards like \'*\' are allowed.' => '',
        'Add customer company' => 'Pridėti organizaciją',
        'Please enter a search term to look for customer companies.' => 'Prašome įvesti paieškos terminą klientų firmų paieškai.',
        'Add Customer Company' => 'Pridėti kliento organizaciją',

        # Template: AdminCustomerUser
        'Customer Management' => 'Klientų valdymas',
        'Back to search result' => '',
        'Add customer' => 'Pridėti klientą',
        'Select' => 'Pasirinkti',
        'Hint' => 'Užuomina',
        'Customer will be needed to have a customer history and to login via customer panel.' =>
            'Klientas bus reikalingas turėti klientų istorijai ir prisijungimui per klientų skydelį.',
        'Please enter a search term to look for customers.' => 'Prašome įvesti paieškos terminą klientų paieškai.',
        'Last Login' => 'Paskutinis prisijungimas',
        'Login as' => 'Prisijungti kaip',
        'Switch to customer' => '',
        'Add Customer' => 'Pridėti klientą',
        'Edit Customer' => 'Redaguoti klientą',
        'This field is required and needs to be a valid email address.' =>
            'Šis laukelis yra būtinas ir turi būti galiojontis pašto adresas.',
        'This email address is not allowed due to the system configuration.' =>
            'Dėl sistemos konfigūracijos šis el. pašto adresas yra neleidžiamas.',
        'This email address failed MX check.' => 'Nepavyko šio el. pašto adreso MX patikrinimas.',
        'DNS problem, please check your configuration and the error log.' =>
            '',
        'The syntax of this email address is incorrect.' => 'Šio el. pašto adreso sintaksė yra neteisinga.',

        # Template: AdminCustomerUserGroup
        'Manage Customer-Group Relations' => 'Valdyti klientas-grupė sąsajas',
        'Notice' => 'Perspėjimas',
        'This feature is disabled!' => 'Ši ypatybė yra išjungta!',
        'Just use this feature if you want to define group permissions for customers.' =>
            'Šią ypatybę naudokite tik tada jeigu norite klientams apibrėžti grupių leidimus.',
        'Enable it here!' => 'Įjungti čia!',
        'Search for customers.' => '',
        'Edit Customer Default Groups' => 'Redaguoti numatytąsias klientų grupes',
        'These groups are automatically assigned to all customers.' => 'Šios grupės yra automatiškai priskiriamos visiems klientams.',
        'You can manage these groups via the configuration setting "CustomerGroupAlwaysGroups".' =>
            'Šias grupes galite valdyti per konfigūracijos nustatymą "CustomerGroupAlwaysGroups".',
        'Filter for Groups' => 'Filtruoti grupes',
        'Select the customer:group permissions.' => 'Pasirinkite klientas:grupė leidimus',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer).' =>
            'Jeigu nėra nieko pasirinkta, tai šioje grupėje nėra nustatytų leidimų (klientui triktys bus nepasiekiamos).',
        'Search Result:' => 'Paieškos rezultatas:',
        'Customers' => 'Klientai',
        'Groups' => 'Grupės',
        'No matches found.' => 'Nerasta atitikmenų.',
        'Change Group Relations for Customer' => 'Pakeisti klientui grupės sąsajas(ryšius)',
        'Change Customer Relations for Group' => 'Pakeisti grupei kliento sąsajas(ryšius)',
        'Toggle %s Permission for all' => 'Įjungti %s leidimą visiems',
        'Toggle %s permission for %s' => 'Įjungti %s leidimą %s',
        'Customer Default Groups:' => 'Standartinės klientų grupės:',
        'No changes can be made to these groups.' => 'Šioms grupėms negalima atlikti jokių pakeitimų.',
        'ro' => 'ro',
        'Read only access to the ticket in this group/queue.' => 'Tik skaitymo teisės trikčiai šioje grupėje/eilėje.',
        'rw' => 'rw',
        'Full read and write access to the tickets in this group/queue.' =>
            'Pilnos skaitymo ir rašymo teisės trikčiai šioje grupėje/eilėje.',

        # Template: AdminCustomerUserService
        'Manage Customer-Services Relations' => 'Valdyti klientas-servisas sąsajas',
        'Edit default services' => 'Redaguoti standartinius servisus',
        'Filter for Services' => 'Filtruoti paslaugas',
        'Allocate Services to Customer' => 'Priskirti servisus klientams',
        'Allocate Customers to Service' => 'Priskirti klientus servisams',
        'Toggle active state for all' => 'Perjungti visiems aktyvią būseną',
        'Active' => 'Aktyvus',
        'Toggle active state for %s' => 'Perjungti %s aktyvią būseną',

        # Template: AdminDynamicField
        'Dynamic Fields Management' => '',
        'Add new field for object' => '',
        'To add a new field, select the field type form one of the object\'s list, the object defines the boundary of the field and it can\'t be changed after the field creation.' =>
            '',
        'Dynamic Fields List' => '',
        'Dynamic fields per page' => '',
        'Label' => '',
        'Order' => '',
        'Object' => 'Objektas',
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
        'Default value' => 'Standartinė reikšmė',
        'This is the default value for this field.' => '',
        'Save' => 'Išsaugoti',

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
        'Key' => 'Raktas',
        'Value' => 'Reikšmė',
        'Remove value' => '',
        'Add value' => '',
        'Add Value' => '',
        'Add empty value' => '',
        'Activate this option to create an empty selectable value.' => '',
        'Translatable values' => '',
        'If you activate this option the values will be translated to the user defined language.' =>
            '',
        'Note' => 'Pastaba',
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
        'Admin Notification' => 'Admin. pranešimas',
        'With this module, administrators can send messages to agents, group or role members.' =>
            'Šio modulio pagalba administratoriai gali siųsti žinutes agentams, grupėms ar rolių nariams.',
        'Create Administrative Message' => 'Sukurti administracinę žinutę',
        'Your message was sent to' => 'Jūsų žinutė buvo išsiųsta',
        'Send message to users' => 'Siųsti žinutę naudotojams',
        'Send message to group members' => 'Siųsti žinutę grupės nariams',
        'Group members need to have permission' => 'Grupės nariai turi turėti leidimą',
        'Send message to role members' => 'Siųsti žinutę rolės nariams',
        'Also send to customers in groups' => 'Taip pat siųsti ir klientams grupėse',
        'Body' => 'Tekstas',
        'Send' => 'Siųsti',

        # Template: AdminGenericAgent
        'Generic Agent' => 'Bendrinis agentas (Generic Agent)',
        'Add job' => 'Pridėti agentą',
        'Last run' => 'Paskutinis paleidimas',
        'Run Now!' => 'Paleisti dabar!',
        'Delete this task' => 'Ištrinti šią užduotį',
        'Run this task' => 'Vykdyti šią užduoti',
        'Job Settings' => 'Užduoties nustatymai',
        'Job name' => 'Užduoties pavadinimas',
        'Currently this generic agent job will not run automatically.' =>
            'Šiuo metu ši bendrinio agento (generic agent) užduotis nebus vykdoma.',
        'To enable automatic execution select at least one value from minutes, hours and days!' =>
            'Norėdami įjungti automatinį užduočių paleidimą turite pasirinkti bent vieną reikšmę iš minučių, valandų ir dienų!',
        'Schedule minutes' => '',
        'Schedule hours' => '',
        'Schedule days' => '',
        'Toggle this widget' => 'Įjungti/išjungti šį valdiklį',
        'Ticket Filter' => 'Trikčių filtras',
        '(e. g. 10*5155 or 105658*)' => 'pvz. 10*5144 arba 105658*',
        '(e. g. 234321)' => 'pvz. 234321',
        'Customer login' => 'Kliento prisijungimas',
        '(e. g. U5150)' => 'pvz. U5150',
        'Fulltext-search in article (e. g. "Mar*in" or "Baue*").' => 'Pilno teksto paieška straipsnyje (pvz. "Mar*in" oder "Baue*").',
        'Agent' => 'Agentas',
        'Ticket lock' => 'Trikčių užraktas',
        'Create times' => 'Sukūrimo datos',
        'No create time settings.' => '',
        'Ticket created' => 'Triktis sukurta',
        'Ticket created between' => 'Triktis sukurta tarp',
        'Change times' => '',
        'No change time settings.' => '',
        'Ticket changed' => '',
        'Ticket changed between' => '',
        'Close times' => 'Uždarymo datos',
        'No close time settings.' => '',
        'Ticket closed' => 'Triktis uždaryta',
        'Ticket closed between' => 'Triktis uždaryta tarp',
        'Pending times' => '',
        'No pending time settings.' => '',
        'Ticket pending time reached' => '',
        'Ticket pending time reached between' => '',
        'Escalation times' => 'Eskalavimo datos',
        'No escalation time settings.' => '',
        'Ticket escalation time reached' => '',
        'Ticket escalation time reached between' => '',
        'Escalation - first response time' => 'Eskalavimas - pirmo atsakymo laikas',
        'Ticket first response time reached' => '',
        'Ticket first response time reached between' => '',
        'Escalation - update time' => 'Eskalavimas - atnaujinimo laikas',
        'Ticket update time reached' => '',
        'Ticket update time reached between' => '',
        'Escalation - solution time' => 'Eskalavimas - išsprendimo laikas',
        'Ticket solution time reached' => '',
        'Ticket solution time reached between' => '',
        'Archive search option' => 'Paieška archyve',
        'Ticket Action' => 'Trikties veiksmas',
        'Set new service' => 'Nustatyti naują paslaugą',
        'Set new Service Level Agreement' => 'Nustatyti naują paslaugos lygio sutartį (SLA)',
        'Set new priority' => 'Nustatyti naują prioritetą',
        'Set new queue' => 'Nustatyti naują eilę',
        'Set new state' => 'Nustatyti naują būseną',
        'Set new agent' => 'Priskirti naują agentą',
        'new owner' => 'naujas savininkas',
        'new responsible' => '',
        'Set new ticket lock' => '',
        'New customer' => 'Naujas klientas',
        'New customer ID' => 'Naujo kliento ID',
        'New title' => 'Naujas pavadinimas',
        'New type' => 'Naujas tipas',
        'New Dynamic Field Values' => '',
        'Archive selected tickets' => 'Archyvuoti pasirinktas triktis',
        'Add Note' => 'Pridėti pastabą',
        'Time units' => 'Laiko vienetai',
        '(work units)' => '',
        'Ticket Commands' => 'Trikčių komandos',
        'Send agent/customer notifications on changes' => 'Įvykus pasikeitimams siųsti perspėjimus agentams/klientams',
        'CMD' => 'CMD',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' =>
            'Ši komanda bus įvykdyta. ARG[0] bus trikties numeris, ARG[1] - trikties ID',
        'Delete tickets' => 'Ištrinti triktis',
        'Warning: All affected tickets will be removed from the database and cannot be restored!' =>
            'ĮSPĖJIMAS: visos paveiktos triktys bus pašalintos iš duomenų bazės ir bus nebe atstatomos.',
        'Execute Custom Module' => 'Vykdyti pasirinktinį/nestandartinį (custom) modulį',
        'Param %s key' => 'Parametro %s raktas',
        'Param %s value' => 'Parametro %s reikšmė',
        'Save Changes' => 'Išsaugoti pakeitimus',
        'Results' => 'Rezultatai',
        '%s Tickets affected! What do you want to do?' => '%s paveiktos triktys! Ką norite daryti?',
        'Warning: You used the DELETE option. All deleted tickets will be lost!' =>
            'ĮSPĖJIMAS: Pasirinkote IŠTRINTI. Ištrintos triktys bus prarastos visam laikui!',
        'Edit job' => 'Redaguoti darbą',
        'Run job' => 'Vykdyti darbą',
        'Affected Tickets' => 'Paveiktos triktys',

        # Template: AdminGenericInterfaceDebugger
        'GenericInterface Debugger for Web Service %s' => '',
        'Web Services' => '',
        'Debugger' => '',
        'Go back to web service' => '',
        'Clear' => '',
        'Do you really want to clear the debug log of this web service?' =>
            '',
        'Request List' => '',
        'Time' => 'Laikas',
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
        'Show or hide the content' => 'Slėpti arba rodyti turinį',
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
        'Import' => 'Importuoti',
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
        'Version' => 'Versija',
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
            'ĮSPĖJIMAS: Pervadinant grupę \'admin\' prieš atlikant atitinkamus veiksmus \'SysConfig\' būsite užrakintas nuo administravimo skydelio! Jei tai atsitiktų, panaudodami SQL užklausą, atkeiskite grupės pavadinimą atgal į \'admin\'',
        'Group Management' => 'Grupės valdymas',
        'Add group' => 'Pridėti grupę',
        'The admin group is to get in the admin area and the stats group to get stats area.' =>
            '\'admin\' grupė yra skirta patekti į administratorių zoną, o \'stats\' grupė - į statistikos zoną',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...). ' =>
            'Sukurkite naujas grupes skirtingų agentų grupių leidimams suvaldyti (pvz. pirkimų skyrius, palaikymo skyrius, pardavimų skyrius, ...).',
        'It\'s useful for ASP solutions. ' => 'Tai yra naudinga ASP sprendimams.',
        'Add Group' => 'Pridėti grupę',
        'Edit Group' => 'Redaguoti grupę',

        # Template: AdminLog
        'System Log' => 'Sistemos žurnalas',
        'Here you will find log information about your system.' => 'Čia rasite žurnalų informaciją apie Jūsų sistemą.',
        'Hide this message' => 'Slėpti šią žinutę',
        'Recent Log Entries' => 'Naujausi žurnalo įrašai',

        # Template: AdminMailAccount
        'Mail Account Management' => 'Pašto paskyros valdymas',
        'Add mail account' => 'Pridėti pašto paskyrą',
        'All incoming emails with one account will be dispatched in the selected queue!' =>
            '',
        'If your account is trusted, the already existing X-OTRS header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' =>
            '',
        'Host' => 'Serveris',
        'Delete account' => 'Ištrinti paskyrą',
        'Fetch mail' => 'Gauti (parsiųsti) laiškus',
        'Add Mail Account' => 'Pridėti el. pašto paskyrą',
        'Example: mail.example.com' => 'Pavyzdžiui : mail.example.com',
        'IMAP Folder' => '',
        'Only modify this if you need to fetch mail from a different folder than INBOX.' =>
            '',
        'Trusted' => 'Patikimas',
        'Dispatching' => 'Išskirstymas',
        'Edit Mail Account' => 'Redaguoti pašto paskyrą',

        # Template: AdminNavigationBar
        'Admin' => 'Admin',
        'Agent Management' => 'Agentų valdymas',
        'Queue Settings' => 'Eilių nustatymai',
        'Ticket Settings' => 'Trikčių nustatymai',
        'System Administration' => 'Sistemos administravimas',

        # Template: AdminNotification
        'Notification Management' => 'Pranešimų valdymas',
        'Select a different language' => 'Pasirinkite kitą kalbą',
        'Filter for Notification' => 'Filtruoti pranešimus',
        'Notifications are sent to an agent or a customer.' => 'Pranešimai yra siunčiami agentui arba klientui.',
        'Notification' => 'Pranešimas',
        'Edit Notification' => 'Redaguoti pranešimus',
        'e. g.' => 'pvz.',
        'Options of the current customer data' => 'Esamų klientų duomenų parinktys',

        # Template: AdminNotificationEvent
        'Add notification' => 'Pridėti pranešimą',
        'Delete this notification' => 'Ištrinti šį pranešimą',
        'Add Notification' => 'Pridėti pranešimą',
        'Recipient groups' => 'Gaunančios grupės',
        'Recipient agents' => 'Gaunantys agentai',
        'Recipient roles' => 'Gaunančios rolės',
        'Recipient email addresses' => 'Gavėjo el. pašto adresas',
        'Article type' => 'Straipsnio tipas',
        'Only for ArticleCreate event' => 'Tik straipsnio sukūrimo įvykiui',
        'Article sender type' => '',
        'Subject match' => 'Tema atitinka',
        'Body match' => 'Turinys atitinka',
        'Include attachments to notification' => 'Įtraukti priedus į pranešimus',
        'Notification article type' => 'Pranešimo straipsnio tipas',
        'Only for notifications to specified email addresses' => 'Tik pranešimams į nurodytus el. pašto adresus',
        'To get the first 20 character of the subject (of the latest agent article).' =>
            'Gauti pirmus 20 temos simbolių (paskutinio agento straipsnio)',
        'To get the first 5 lines of the body (of the latest agent article).' =>
            'Gauti pirmas 5 turinio eilutes (paskutinio agento straipsnio)',
        'To get the first 20 character of the subject (of the latest customer article).' =>
            'Gauti pirmus 20 temos simbolių (paskutinio kliento straipsnio)',
        'To get the first 5 lines of the body (of the latest customer article).' =>
            'Gauti pirmas 5 turinio eilutes (paskutinio kliento straipsnio)',

        # Template: AdminPGP
        'PGP Management' => 'PGP valdymas',
        'Use this feature if you want to work with PGP keys.' => 'Naudokite šią ypatybę jei norite dirbti su PGP raktais.',
        'Add PGP key' => 'Pridėti PGP raktą',
        'In this way you can directly edit the keyring configured in SysConfig.' =>
            'Šiuo būdu galite tiesiogiai valdyti SysConfig sukonfigūruotą "raktų ryšulį".',
        'Introduction to PGP' => 'Įvadas į PGP',
        'Result' => 'Rezultatas',
        'Identifier' => 'Identifikatorius',
        'Bit' => 'Bitai',
        'Fingerprint' => 'Piršto atspaudas',
        'Expires' => 'Galiojimo laikas baigiasi',
        'Delete this key' => 'Trinti šį raktą',
        'Add PGP Key' => 'Pridėti PGP Raktą',
        'PGP key' => 'PGP raktas',

        # Template: AdminPackageManager
        'Package Manager' => 'Paketų valdymas',
        'Uninstall package' => 'Pašalinti paketą',
        'Do you really want to uninstall this package?' => 'Ar tikrai norite pašalinti š paketą?',
        'Reinstall package' => 'Iš naujo įdiegti paketą',
        'Do you really want to reinstall this package? Any manual changes will be lost.' =>
            'Ar tikrai norite iš naujo įdiegti šį paketą? Bet kokie atlikti rankiniai pakeitimai bus prarasti.',
        'Continue' => 'Tęsti',
        'Install' => 'Įdiegti',
        'Install Package' => 'Įdiegti paketą',
        'Update repository information' => 'Atnaujinti saugyklos informaciją',
        'Did not find a required feature? OTRS Group provides their service contract customers with exclusive Add-Ons:' =>
            '',
        'Online Repository' => 'Prieinamos (įjungtos) saugyklos',
        'Vendor' => 'Tiekėjas/pardavėjas',
        'Module documentation' => 'Modulio dokumentacija',
        'Upgrade' => 'Atnaujinti versiją',
        'Local Repository' => 'Vietinė saugykla',
        'Uninstall' => 'Pašalinti',
        'Reinstall' => 'Įdiegti iš naujo',
        'Feature Add-Ons' => '',
        'Download package' => 'Parsisiųsti paketą',
        'Rebuild package' => 'Iš naujo surinkti paketą (rebuild)',
        'Metadata' => 'Meta-duomenys',
        'Change Log' => 'Pakeitimų žurnalas',
        'Date' => 'Data',
        'List of Files' => 'Failų sąrašas',
        'Permission' => 'Leidimas',
        'Download' => 'Parsiųsti',
        'Download file from package!' => 'Parsiųsti failą iš paketo!',
        'Required' => 'Reikalaujama',
        'PrimaryKey' => '',
        'AutoIncrement' => '',
        'SQL' => 'SQL',
        'File differences for file %s' => 'Skirtumai tarp failų %s',

        # Template: AdminPerformanceLog
        'Performance Log' => 'Sistemos našumo žurnalas',
        'This feature is enabled!' => 'Ši ypatybę aktyvuota!',
        'Just use this feature if you want to log each request.' => 'Įjunkite šią ypatybę tik tuo atveju jeigu norite registruoti visas užklausas.',
        'Activating this feature might affect your system performance!' =>
            'Šios ypatybės aktyvavimas gali paveikti Jūsų sistemos našumą.',
        'Disable it here!' => 'Išjungti čia!',
        'Logfile too large!' => 'Registravimo žurnalas per didelis!',
        'The logfile is too large, you need to reset it' => 'Registravimo žurnalas per didelis. Turėtumėte jį anuliuoti.',
        'Overview' => 'Apžvalga',
        'Range' => 'Diapazonas',
        'Interface' => 'Sąsaja',
        'Requests' => 'Užklausos',
        'Min Response' => 'Mažiausias atsako laikas',
        'Max Response' => 'Didžiausias atsako laikas',
        'Average Response' => 'Vidutinis atsako laikas',
        'Period' => 'Laiko tarpas',
        'Min' => 'Min',
        'Max' => 'Maks',
        'Average' => 'Vidurkis',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => 'PostMaster filtrų valdymas',
        'Add filter' => 'Pridėti filtrą',
        'To dispatch or filter incoming emails based on email headers. Matching using Regular Expressions is also possible.' =>
            'Išskirstyti ar filtruoti el. laiškus pagal el. laiškų antraštes. Taip pat galima naudoti ir reguliarias išraiškas',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' =>
            'Jeigu norite nustatyti atitikmenį tik vienam el. pašto adresui, tai Nuo, Kam ir Cc laukeliuose naudokite EMAILADDRESS:info@example.com.',
        'If you use Regular Expressions, you also can use the matched value in () as [***] in the \'Set\' action.' =>
            '',
        'Delete this filter' => 'Ištrinti šį filtrą',
        'Add PostMaster Filter' => 'Pridėti PostMaster filtrą',
        'Edit PostMaster Filter' => 'Redaguoti PostMaster filtrą',
        'Filter name' => 'Filtro pavadinimas',
        'The name is required.' => '',
        'Stop after match' => 'Radus atitikmenį sustoti',
        'Filter Condition' => 'Filtro sąlyga',
        'The field needs to be a valid regular expression or a literal word.' =>
            '',
        'Set Email Headers' => 'Nustatyti el. pašto antraštes',
        'The field needs to be a literal word.' => '',

        # Template: AdminPriority
        'Priority Management' => 'Prioritetų valdymas',
        'Add priority' => 'Pridėti prioritetą',
        'Add Priority' => 'Pridėti prioritetą',
        'Edit Priority' => 'Redaguoti prioritetą',

        # Template: AdminProcessManagement
        'Process Management' => '',
        'Filter for Processes' => '',
        'Filter' => 'Filtras',
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
        'Print' => 'Spausdinti',
        'Export Process Configuration' => '',
        'Copy Process' => '',

        # Template: AdminProcessManagementActivity
        'Cancel & close window' => 'Atšaukti ir užverti langą',
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
        'Manage Queues' => 'Valdyti eiles',
        'Add queue' => 'Pridėti eilę',
        'Add Queue' => 'Pridėto eilę',
        'Edit Queue' => 'Redaguoti eilę',
        'Sub-queue of' => 'Poeilis',
        'Unlock timeout' => '',
        '0 = no unlock' => 'neatrakinti',
        'Only business hours are counted.' => 'Skaičiuojamos tik darbo valandos.',
        'If an agent locks a ticket and does not close it before the unlock timeout has passed, the ticket will unlock and will become available for other agents.' =>
            'Jeigu agentas užrakins triktį ir neuždarys jos iki pasibaigs atrakinimo laikas (unlock timeout), tai ji atsirakins ir taps prieinama kitiems agentams.',
        'Notify by' => 'Pranešti per',
        '0 = no escalation' => '0 = neeskaluoti',
        'If there is not added a customer contact, either email-external or phone, to a new ticket before the time defined here expires, the ticket is escalated.' =>
            'Jeigu naujai trikčiai nebus pridėti kliento kontaktai (išorinis el. paštas ar telefono numeris), iki pasibaigiant čia nurodytam laikui, tai triktis bus eskaluota.',
        'If there is an article added, such as a follow-up via email or the customer portal, the escalation update time is reset. If there is no customer contact, either email-external or phone, added to a ticket before the time defined here expires, the ticket is escalated.' =>
            'Jeigu trikčiai bus pridėtas naujas straipsnis, pvz., atsakymas per išorinį el. paštą arba klientų portalą, tai eskalavimo atnaujinimo laikas yra atstatomas atgal. Jeigu trikčiai nebus pridėti kliento kontaktai (išorinis el. paštas ar telefono numeris), iki pasibaigiant čia nurodytam laikui, tai triktis bus eskaluota.',
        'If the ticket is not set to closed before the time defined here expires, the ticket is escalated.' =>
            'Jeigu triktis nebus ir neuždaryta iki pasibaigs čia nurodytas laikas, tai ji bus eskaluota.',
        'Follow up Option' => '',
        'Specifies if follow up to closed tickets would re-open the ticket, be rejected or lead to a new ticket.' =>
            'Nurodo ar tolimesni veiksmai su jau uždaryta triktimi: ją iš naujo atidarytų, atmestų bet kokius tolimesnius veiksmus, sukurtų naują triktį.',
        'Ticket lock after a follow up' => 'Užrakinti triktį po bet kokio atsakymo ar kontakto',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked to the old owner.' =>
            'Jeigu triktis yra uždaryta ir klientas vėl ką nors atsiunčia - triktis bus prirakinta prie senojo savininko.',
        'System address' => 'Sistemos adresas',
        'Will be the sender address of this queue for email answers.' => 'Bus šios eilės siunčiamų atsakymų siuntėjo adresas.',
        'Default sign key' => 'Standartinis pasirašymo raktas',
        'The salutation for email answers.' => 'Kreipimosi forma el. pašto atsakymuose.',
        'The signature for email answers.' => 'El. pašto atsakymų parašas.',

        # Template: AdminQueueAutoResponse
        'Manage Queue-Auto Response Relations' => 'Valdyti eilių - automatinių atsakymų ryšius',
        'Filter for Queues' => 'Filtruoti eiles',
        'Filter for Auto Responses' => 'Filtruoti auto. atsakymus',
        'Auto Responses' => 'Automatiniai atsakymai',
        'Change Auto Response Relations for Queue' => 'Keisti eilei automatinių atsakymų sąsajas',
        'settings' => 'nustatymai',

        # Template: AdminQueueResponses
        'Manage Response-Queue Relations' => 'Valdyti atsakymų-eilių ryšius',
        'Filter for Responses' => 'Filtruoti atsakymus',
        'Responses' => 'Atsakymai',
        'Change Queue Relations for Response' => 'Keisti eilių ryšius atsakymui',
        'Change Response Relations for Queue' => 'Keisti atsakymų ryšius eilei',

        # Template: AdminResponse
        'Manage Responses' => 'Valdyti atsakymus',
        'Add response' => 'Pridėti atsakymą',
        'A response is a default text which helps your agents to write faster answers to customers.' =>
            '',
        'Don\'t forget to add new responses to queues.' => '',
        'Delete this entry' => 'Ištrinti šį įrašą',
        'Add Response' => 'Pridėti atsakymą',
        'Edit Response' => 'Redaguoti atsakymą',
        'The current ticket state is' => 'Dabartinė trikties būsena yra',
        'Your email address is' => 'Jūsų el. pašto adresas yra',

        # Template: AdminResponseAttachment
        'Manage Responses <-> Attachments Relations' => 'Valdyti Atsakymai <-> Priedai ryšius',
        'Filter for Attachments' => 'Filtruoti priedus',
        'Change Response Relations for Attachment' => 'Keisti atsakymų ryšius priedui',
        'Change Attachment Relations for Response' => 'Keisti priedų ryšius atsakymui',
        'Toggle active for all' => 'Perjungti visų aktyvavimą',
        'Link %s to selected %s' => 'Prijungti %s prie pasirinkto %s',

        # Template: AdminRole
        'Role Management' => 'Rolių valdymas',
        'Add role' => 'Pridėti rolę',
        'Create a role and put groups in it. Then add the role to the users.' =>
            'Sukurkite rolę, o tada įdėkite į ją grupes. Tada priskirkite roles naudotojams.',
        'There are no roles defined. Please use the \'Add\' button to create a new role.' =>
            'Nėra apibrėžtų rolių. Prašome paspausti mygtuką "Pridėti" naujoms rolės sukurti.',
        'Add Role' => 'Pridėti Rolę',
        'Edit Role' => 'Redaguoti rolę',

        # Template: AdminRoleGroup
        'Manage Role-Group Relations' => 'Valdyti Rolė-Grupė ryšius',
        'Filter for Roles' => 'Filtruoti roles',
        'Roles' => 'Rolės',
        'Select the role:group permissions.' => 'Pasirinkite rolė:grupė leidimus.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the role).' =>
            'Jeigu nėra nieko pasirinkta, tai šioje grupėje nėra nustatytų leidimų (rolei triktys bus neprieinamos).',
        'Change Role Relations for Group' => 'Keisti rolių ryšius grupei',
        'Change Group Relations for Role' => 'Keisti grupių ryšius rolei',
        'Toggle %s permission for all' => 'Perjungti visiems %s leidimą',
        'move_into' => 'Perkelti į',
        'Permissions to move tickets into this group/queue.' => 'Leidimai perkelti triktis į šią grupę/eilę.',
        'create' => 'sukurti',
        'Permissions to create tickets in this group/queue.' => 'Leidimai kurti triktis šioje grupėje/eilėje.',
        'priority' => 'prioritetas',
        'Permissions to change the ticket priority in this group/queue.' =>
            'Leidimai keisti trikčių prioritetus šioje grupėje/eilėje.',

        # Template: AdminRoleUser
        'Manage Agent-Role Relations' => 'Valdyti Agentas-Rolė ryšius',
        'Filter for Agents' => 'Filtruoti agentus',
        'Agents' => 'Agentai',
        'Manage Role-Agent Relations' => 'Valdyti Rolė-Agentas ryšius',
        'Change Role Relations for Agent' => 'Keisti rolių ryšius agentui',
        'Change Agent Relations for Role' => 'Keisti agentų ryšius rolei',

        # Template: AdminSLA
        'SLA Management' => 'SLA valdymas',
        'Add SLA' => 'Pridėti SLA',
        'Edit SLA' => 'Redaguoti SLA',
        'Please write only numbers!' => 'Prašome rašyti tik numerius!',

        # Template: AdminSMIME
        'S/MIME Management' => 'S/MIME valdymas',
        'Add certificate' => 'Pridėti sertifikatą',
        'Add private key' => 'Pridėti privatų raktą',
        'Filter for certificates' => '',
        'Filter for SMIME certs' => '',
        'Here you can add relations to your private certificate, these will be embedded to the SMIME signature every time you use this certificate to sign an email.' =>
            '',
        'See also' => 'Taip pat žiūrėkite',
        'In this way you can directly edit the certification and private keys in file system.' =>
            'Šiuo būdu galite tiesiogiai redaguoti sertifikatus ir privačius raktus sistemoje.',
        'Hash' => '',
        'Create' => 'Sukurti',
        'Handle related certificates' => '',
        'Read certificate' => '',
        'Delete this certificate' => 'Ištrinti šį sertifikatą',
        'Add Certificate' => 'Pridėti sertifikatą',
        'Add Private Key' => 'Pridėti privatų raktą',
        'Secret' => '',
        'Related Certificates for' => '',
        'Delete this relation' => '',
        'Available Certificates' => '',
        'Relate this certificate' => '',

        # Template: AdminSMIMECertRead
        'SMIME Certificate' => '',
        'Close window' => 'Užverti langą',

        # Template: AdminSalutation
        'Salutation Management' => 'Kreipinių valdymas',
        'Add salutation' => 'Pridėti kreipimąsi',
        'Add Salutation' => 'Pridėti kreipimąsi',
        'Edit Salutation' => 'Redaguoti kreipimąsi',
        'Example salutation' => 'Kreipimosi pavyzdys',

        # Template: AdminScheduler
        'This option will force Scheduler to start even if the process is still registered in the database' =>
            '',
        'Start scheduler' => '',
        'Scheduler could not be started. Check if scheduler is not running and try it again with Force Start option' =>
            '',

        # Template: AdminSecureMode
        'Secure mode needs to be enabled!' => 'Turi būti įjungtas saugus režimas!',
        'Secure mode will (normally) be set after the initial installation is completed.' =>
            'Saugus režimas, paprastai, yra nustatomas po pradinio įdiegimo.',
        'If secure mode is not activated, activate it via SysConfig because your application is already running.' =>
            '',

        # Template: AdminSelectBox
        'SQL Box' => 'SQL Box',
        'Here you can enter SQL to send it directly to the application database.' =>
            'Čia galite įvesti ir tiesiogiai programos duomenų bazei nusiųsti SQL užklausas.',
        'The syntax of your SQL query has a mistake. Please check it.' =>
            'Jūsų SQL užklausoje yra klaida. Prašome ją ištaisyti.',
        'There is at least one parameter missing for the binding. Please check it.' =>
            '',
        'Result format' => 'Rezultato formatas',
        'Run Query' => 'Vykdyti užduotį',

        # Template: AdminService
        'Service Management' => 'Paslaugų valdymas',
        'Add service' => 'Pridėti paslaugą',
        'Add Service' => 'Pridėti paslaugą',
        'Edit Service' => 'Redaguoti paslaugą',
        'Sub-service of' => 'Sub-paslauga',

        # Template: AdminSession
        'Session Management' => 'Sesijų valdymas',
        'All sessions' => 'Visos sesijos',
        'Agent sessions' => 'Agentų sesijos',
        'Customer sessions' => 'Klientų sesijos',
        'Unique agents' => 'Unikalūs agentai',
        'Unique customers' => 'Unikalūs klientai',
        'Kill all sessions' => 'Nutraukti visas sesijas',
        'Kill this session' => 'Nutraukti šią sesiją',
        'Session' => 'Sesija',
        'Kill' => 'Nutraukti',
        'Detail View for SessionID' => 'Detali Sesijos ID peržiūra',

        # Template: AdminSignature
        'Signature Management' => 'Parašų valdymas',
        'Add signature' => 'Pridėti parašą',
        'Add Signature' => 'Pridėti parašą',
        'Edit Signature' => 'Redaguoti parašą',
        'Example signature' => 'Parašo pavyzdys',

        # Template: AdminState
        'State Management' => 'Būsenų valdymas',
        'Add state' => 'Pridėti būseną',
        'Please also update the states in SysConfig where needed.' => '',
        'Add State' => 'Pridėti būseną',
        'Edit State' => 'Redaguoti būseną',
        'State type' => 'Būsenos tipas',

        # Template: AdminSysConfig
        'SysConfig' => 'SysConfig',
        'Navigate by searching in %s settings' => 'Naršyti ieškant %s nustatymuose',
        'Navigate by selecting config groups' => 'Naršyti pasirenkant konfigūracijos grupes',
        'Download all system config changes' => 'Parsisiųsti visus sistemos konfigūracijos pakeitimus',
        'Export settings' => 'Eksportuoti nustatymus',
        'Load SysConfig settings from file' => 'Užkrauti konfigūraciją iš failo',
        'Import settings' => 'Importuoti nustatymus',
        'Import Settings' => 'Importuoti nustatymus',
        'Please enter a search term to look for settings.' => 'Prašome įvesti paieškos terminą nustatymų paieškai.',
        'Subgroup' => 'Pogrupis',
        'Elements' => 'Elementai',

        # Template: AdminSysConfigEdit
        'Edit Config Settings' => 'Redaguoti konfigūracijos nustatymus',
        'This config item is only available in a higher config level!' =>
            'Šis konfigūracijos punktas yra prieinamas tik aukštesniame konfigūracijos lygyje!',
        'Reset this setting' => 'Atstatyti šį nustatymą',
        'Error: this file could not be found.' => 'Klaida: šis failas nerastas.',
        'Error: this directory could not be found.' => 'Klaida: ši direktorija nerasta.',
        'Error: an invalid value was entered.' => 'Klaida: buvo įvesta netinkama reikšmė.',
        'Content' => 'Turinys',
        'Remove this entry' => 'Pašalinti šį įrašą',
        'Add entry' => 'Pridėti įrašą',
        'Remove entry' => 'Pašalinti įrašą',
        'Add new entry' => 'Pridėti naują įrašą',
        'Create new entry' => 'Sukurti naują įrašą',
        'New group' => 'Nauja grupė',
        'Group ro' => 'Ro grupė',
        'Readonly group' => 'Tik skaitymo grupė',
        'New group ro' => 'Nauja ro grupė',
        'Loader' => 'Įkrovėjas(loader)',
        'File to load for this frontend module' => 'Šio sąsajos modulio užkrovimo failas',
        'New Loader File' => 'Naujas užkrovos failas',
        'NavBarName' => '',
        'NavBar' => '',
        'LinkOption' => '',
        'Block' => 'Blokuoti',
        'AccessKey' => '',
        'Add NavBar entry' => 'Pridėti NavBar įrašą',
        'Year' => 'Metai',
        'Month' => 'Mėnesis',
        'Day' => 'Diena',
        'Invalid year' => 'Negalimi metai',
        'Invalid month' => 'Negalimas mėnesis',
        'Invalid day' => 'Negalima diena',

        # Template: AdminSystemAddress
        'System Email Addresses Management' => 'Sistemos el. pašto adresų valdymas',
        'Add system address' => 'Pridėti sistemos adresą',
        'All incoming email with this address in To or Cc will be dispatched to the selected queue.' =>
            'Visas įeinantis el. paštas, su tokiu (nurodytu) el. pašto adresu Kam ir Kopija laukeliuose, bus nukreiptas į pasirinktą eilę.',
        'Email address' => 'El. pašto adresas',
        'Display name' => 'Rodomas vardas',
        'Add System Email Address' => 'Pridėti sistemos el. pašto adresą',
        'Edit System Email Address' => 'Redaguoti sistemos el. pašto adresą',
        'The display name and email address will be shown on mail you send.' =>
            'Rodomas vardas ir el. pašto adresas bus rodomas Jūsų siunčiamuose laiškuose.',

        # Template: AdminType
        'Type Management' => 'Tipų valdymas',
        'Add ticket type' => 'Pridėti trikties tipą',
        'Add Type' => 'Pridėti tipą',
        'Edit Type' => 'Redaguoti tipą',

        # Template: AdminUser
        'Add agent' => 'Pridėti agentą',
        'Agents will be needed to handle tickets.' => 'Agentai bus reikalingi darbui su triktimis ir jų valdymu.',
        'Don\'t forget to add a new agent to groups and/or roles!' => 'Nepamirškite naujų agentų priskirti prie grupių ir/ar rolių!',
        'Please enter a search term to look for agents.' => 'Prašome įvesti agentų paieškos terminą.',
        'Last login' => 'Paskutinis prisijungimas',
        'Switch to agent' => 'Persijungti į agentą',
        'Add Agent' => 'Pridėti agentą',
        'Edit Agent' => 'Redaguoti agentą',
        'Firstname' => 'Vardas',
        'Lastname' => 'Pavardė',
        'Password is required.' => '',
        'Start' => 'Pradžia',
        'End' => 'Pabaiga',

        # Template: AdminUserGroup
        'Manage Agent-Group Relations' => 'Valdyti Agentas-Grupė ryšius',
        'Change Group Relations for Agent' => 'Keisti grupių ryšius agentui',
        'Change Agent Relations for Group' => 'Keisti agentų ryšius grupei',
        'note' => 'pastaba',
        'Permissions to add notes to tickets in this group/queue.' => 'Leidimai pridėti pastabas triktims šioje grupėje/eilėje.',
        'owner' => 'savininkas',
        'Permissions to change the owner of tickets in this group/queue.' =>
            'Leidimai keisti trikčių savininkus šioje grupėje/eilėje.',

        # Template: AgentBook
        'Address Book' => 'Adresų knyga',
        'Search for a customer' => 'Ieškoti kliento',
        'Add email address %s to the To field' => 'Pridėti %s el. pašto adresą prie laukelio Kam (To)',
        'Add email address %s to the Cc field' => 'Pridėti %s el. pašto adresą prie laukelio Kopija (Cc)',
        'Add email address %s to the Bcc field' => 'Pridėti %s el. pašto adresą prie laukelio Slapta kopija (Bcc)',
        'Apply' => 'Pritaikyti',

        # Template: AgentCustomerInformationCenter
        'Customer Information Center' => '',

        # Template: AgentCustomerInformationCenterBlank

        # Template: AgentCustomerInformationCenterSearch
        'Customer ID' => 'Kliento ID',
        'Customer User' => '',

        # Template: AgentCustomerSearch
        'Search Customer' => 'Ieškoti kliento',
        'Duplicated entry' => '',
        'This address already exists on the address list.' => '',
        'It is going to be deleted from the field, please try again.' => '',

        # Template: AgentCustomerTableView

        # Template: AgentDashboard
        'Dashboard' => 'Skydelis',

        # Template: AgentDashboardCalendarOverview
        'in' => 'in',

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
        '%s %s is available!' => '%s %s jau prieinamas!',
        'Please update now.' => 'Prašome atnaujinti jau dabar.',
        'Release Note' => 'išleidimo pastaba',
        'Level' => 'Lygis',

        # Template: AgentDashboardRSSOverview
        'Posted %s ago.' => 'Paskelbtas prieš %s.',

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
        'The ticket has been locked' => 'Triktis buvo užrakinta',
        'Undo & close window' => 'Atstatyti ir užverti langą',

        # Template: AgentInfo
        'Info' => 'Info.',
        'To accept some news, a license or some changes.' => 'Kai kurių naujienų priėmimui, licenzijai ar kai kuriems pakeitimams.',

        # Template: AgentLinkObject
        'Link Object: %s' => 'Susietas objektas: %s',
        'go to link delete screen' => 'eiti į sąsajos trynimo ekraną',
        'Select Target Object' => 'Pasirinkite paskirties objektą',
        'Link Object' => 'Susieti objektą',
        'with' => 'su',
        'Unlink Object: %s' => 'Atsieti objektą: %s',
        'go to link add screen' => 'eiti į sąsajos sukūrimo ekraną',

        # Template: AgentNavigationBar

        # Template: AgentPreferences
        'Edit your preferences' => 'Redaguoti savo nustatymus',

        # Template: AgentSpelling
        'Spell Checker' => 'Rašybos tikrintuvas',
        'spelling error(s)' => 'Rašybos klaida(-os)',
        'Apply these changes' => 'Pritaikyti šiuos pakeitimus',

        # Template: AgentStatsDelete
        'Delete stat' => 'Ištrinti statistiką',
        'Stat#' => '',
        'Do you really want to delete this stat?' => 'Ar tikrai norite ištrinti šią statistiką?',

        # Template: AgentStatsEditRestrictions
        'Step %s' => 'Žingsnis %s',
        'General Specifications' => 'Bendrosios nuostatos',
        'Select the element that will be used at the X-axis' => 'Pasirinkite X ašiai naudojamą elementą',
        'Select the elements for the value series' => 'Pasirinkite reikšmėms naudojamus elementus',
        'Select the restrictions to characterize the stat' => 'Pasirinkite apribojimus statistikos charakterizavimui (apibūdinimui)',
        'Here you can make restrictions to your stat.' => 'Čia galite apriboti savo statistiką.',
        'If you remove the hook in the "Fixed" checkbox, the agent generating the stat can change the attributes of the corresponding element.' =>
            'Jeigu nuimsite varnelę nuo laukelio "Fiksuotas", tai agentas galės pakeisti kiekvieno atitinkamo elemento atributus.',
        'Fixed' => 'Fiksuotas',
        'Please select only one element or turn off the button \'Fixed\'.' =>
            'Prašome pasirinkti tik vieną elementą arba išjungti "Fiksuotas"!',
        'Absolute Period' => 'Absoliutus laikotarpis',
        'Between' => 'Tarp',
        'Relative Period' => 'Reliatyvus laikotarpis',
        'The last' => 'Paskutinis',
        'Finish' => 'Baigti',

        # Template: AgentStatsEditSpecification
        'Permissions' => 'Leidimai',
        'You can select one or more groups to define access for different agents.' =>
            'Skirtingiems agentams apibrėžti galite pasirinkti vieną ar daugiau grupių.',
        'Some result formats are disabled because at least one needed package is not installed.' =>
            'Dalis rezultatų formatų yra išjungti, nes neįdiegtas mažiausiai vienas reikalingas paketas.',
        'Please contact your administrator.' => 'Prašome susisiekti su savo administratoriumi.',
        'Graph size' => 'Diagramos dydis',
        'If you use a graph as output format you have to select at least one graph size.' =>
            'Jei išvedimo tipui naudosite diagramą - turite pasirinkti bent vieną diagramos dydį.',
        'Sum rows' => 'Sumuoti eilutes',
        'Sum columns' => 'Sumuoti stulpelius',
        'Use cache' => 'Naudoti kešą (cache)',
        'Most of the stats can be cached. This will speed up the presentation of this stat.' =>
            'Dauguma statistikų gali būti kešuojama. Tai padidins šios statistikos pateikimą.',
        'If set to invalid end users can not generate the stat.' => 'Jei nustatyta negaliojančiu galutiniai naudotojai negalės generuoti šios statistikos.',

        # Template: AgentStatsEditValueSeries
        'Here you can define the value series.' => 'Čia galite apibrėžti reikšmių serijas.',
        'You have the possibility to select one or two elements.' => 'Turite galimybę pasirinkti vieną ar daugiau elementų.',
        'Then you can select the attributes of elements.' => 'Tada galite pasirinkti elementų atributus.',
        'Each attribute will be shown as single value series.' => 'Kiekvienas atributas bus rodomas kaip atskira reikšmių serija.',
        'If you don\'t select any attribute all attributes of the element will be used if you generate a stat, as well as new attributes which were added since the last configuration.' =>
            '',
        'Scale' => 'Skalė',
        'minimal' => 'minimalus',
        'Please remember, that the scale for value series has to be larger than the scale for the X-axis (e.g. X-Axis => Month, ValueSeries => Year).' =>
            'Prisiminkite, kad reikšmių serijos skalė turi būti didesnė už X ašies skalę (pvz., X-ašis => Mėnesis, Reikšmių Serija => Metai).',

        # Template: AgentStatsEditXaxis
        'Here you can define the x-axis. You can select one element via the radio button.' =>
            'Čia galite apibrėžti X ašį. Galite pasirinkti vieną elementą pažymėdami "radijo mygtuką" (radio button)',
        'maximal period' => 'maksimalus laikotarpis',
        'minimal scale' => 'minimali skalė',

        # Template: AgentStatsImport
        'Import Stat' => 'Importuoti statistiką',
        'File is not a Stats config' => 'Failas nėra statistikos konfigūracija',
        'No File selected' => 'Nepasirinktas failas',

        # Template: AgentStatsOverview
        'Stats' => 'Statistika',

        # Template: AgentStatsPrint
        'No Element selected.' => 'Nepasirinktas joks elementas.',

        # Template: AgentStatsView
        'Export config' => 'Eksportuoti konfigūraciją',
        'With the input and select fields you can influence the format and contents of the statistic.' =>
            'Pasirinktais laukeliais ir įvestimi galite įtakoti turinio ir statistikos formatą.',
        'Exactly what fields and formats you can influence is defined by the statistic administrator.' =>
            'Kokius konkrečius laukelius ir formatus galite įtakoti yra numatęs statistikos administratorius.',
        'Stat Details' => 'Statistikos smulkmenos',
        'Format' => 'Formatas',
        'Graphsize' => 'Diagramos dydis',
        'Cache' => 'Kešas',
        'Exchange Axis' => 'Apsikeitimo (exchange) ašis',
        'Configurable params of static stat' => 'Statiškos statistikos konfigūruojami parametrai',
        'No element selected.' => 'Nepasirinktas elementas.',
        'maximal period from' => 'maksimalus periodas nuo',
        'to' => 'iki',

        # Template: AgentTicketActionCommon
        'Change Free Text of Ticket' => 'Keisti trikties atvirąjį tekstą',
        'Change Owner of Ticket' => 'Keisti trikties savininką',
        'Close Ticket' => 'Uždaryti triktį',
        'Add Note to Ticket' => 'Pridėti pastabą trikčiai',
        'Set Pending' => 'Nustatyti kaip laukiančią',
        'Change Priority of Ticket' => 'Keisti trikties prioritetą',
        'Change Responsible of Ticket' => 'Keisti atsakingą už triktį',
        'Service invalid.' => 'Paslauga negalima',
        'New Owner' => 'Naujas savininkas',
        'Please set a new owner!' => 'Prašome nustatyti naują savininką',
        'Previous Owner' => 'Buvęs savininkas',
        'Inform Agent' => 'Informuoti agentą',
        'Optional' => 'Nebūtinas',
        'Inform involved Agents' => 'Informuoti susijusius agentus',
        'Spell check' => 'Rašybos tikrinimas',
        'Note type' => 'Pastabos tipas',
        'Next state' => 'Sekanti būsena',
        'Pending date' => '',
        'Date invalid!' => 'Negalima data',

        # Template: AgentTicketActionPopupClose

        # Template: AgentTicketBounce
        'Bounce Ticket' => '',
        'Bounce to' => 'Nukreipti į',
        'You need a email address.' => 'Jums reikia el. pašto adreso',
        'Need a valid email address or don\'t use a local email address.' =>
            'Reikalingas galiojantis el. pašto adresas (arba nenaudokite lokalaus pašto adreso).',
        'Next ticket state' => 'Sekanti trikčių būsena',
        'Inform sender' => 'Informuoti siuntėją',
        'Send mail!' => 'Siųsti paštą!',

        # Template: AgentTicketBulk
        'Ticket Bulk Action' => 'Masinis veiksmas su triktimis',
        'Send Email' => '',
        'Merge to' => 'Sujungti su',
        'Invalid ticket identifier!' => 'Negaliojantis trikties identifikatorius!',
        'Merge to oldest' => 'Prijungti prie seniausio',
        'Link together' => 'Susieti vieną su kitu',
        'Link to parent' => 'Susieti su tėvu (parent)',
        'Unlock tickets' => 'Atrakinti triktis',

        # Template: AgentTicketClose

        # Template: AgentTicketCompose
        'Compose answer for ticket' => 'Sukurti atsakymą trikčiai',
        'Remove Ticket Customer' => '',
        'Please remove this entry and enter a new one with the correct value.' =>
            '',
        'Please include at least one recipient' => '',
        'Remove Cc' => '',
        'Remove Bcc' => '',
        'Address book' => 'Adresų knyga',
        'Pending Date' => '',
        'for pending* states' => '',
        'Date Invalid!' => 'Negalima data!',

        # Template: AgentTicketCustomer
        'Change customer of ticket' => 'Keisti trikties klientą',
        'Customer user' => 'Kliento naudotojas',

        # Template: AgentTicketEmail
        'Create New Email Ticket' => 'Sukurti naują el. pašto triktį',
        'From queue' => 'iš eilės',
        'To customer' => '',
        'Please include at least one customer for the ticket.' => '',
        'Get all' => 'Gauti visus',

        # Template: AgentTicketEscalation

        # Template: AgentTicketForward
        'Forward ticket: %s - %s' => '',

        # Template: AgentTicketFreeText

        # Template: AgentTicketHistory
        'History of' => 'Istorija',
        'History Content' => 'Istorijos turinys',
        'Zoom view' => 'Pritraukti apžvalgą',

        # Template: AgentTicketMerge
        'Ticket Merge' => 'Trikčių suliejimas',
        'You need to use a ticket number!' => 'Turite naudoti trikties numerį!',
        'A valid ticket number is required.' => 'Būtinas galiojantis trikties numeris.',
        'Need a valid email address.' => 'Reikia galiojančio el. pašto adreso.',

        # Template: AgentTicketMove
        'Move Ticket' => 'Perkelti triktį',
        'New Queue' => 'Nauja eilė',

        # Template: AgentTicketNote

        # Template: AgentTicketOverviewMedium
        'Select all' => 'Pažymėti visus',
        'No ticket data found.' => 'Nerasta duomenų apie triktį',
        'First Response Time' => 'Pirmas atsakymo laikas',
        'Service Time' => 'Aptarnavimo laikas',
        'Update Time' => 'Atnaujinimo laikas',
        'Solution Time' => 'Sprendimo laikas',
        'Move ticket to a different queue' => 'Perkelti triktį į kitą eilę',
        'Change queue' => 'Pakeisti eilę',

        # Template: AgentTicketOverviewNavBar
        'Change search options' => 'Keisti paieškos nustatymus',
        'Tickets per page' => 'Trikčių puslapyje',

        # Template: AgentTicketOverviewPreview

        # Template: AgentTicketOverviewSmall
        'Escalation in' => 'Eskalavimas po',
        'Locked' => 'Užrakintas',

        # Template: AgentTicketOwner

        # Template: AgentTicketPending

        # Template: AgentTicketPhone
        'Create New Phone Ticket' => 'Sukurti naują telefoninę triktį',
        'From customer' => 'Nuo kliento',
        'To queue' => 'Į eilę',

        # Template: AgentTicketPhoneCommon
        'Phone call' => 'Telefono skambutis',

        # Template: AgentTicketPlain
        'Email Text Plain View' => 'El. laiško peržiūra paprasto teksto režimu',
        'Plain' => 'Paprastas',
        'Download this email' => 'Atsisiųsti šį el. laišką',

        # Template: AgentTicketPrint
        'Ticket-Info' => 'Trikties info.',
        'Accounted time' => 'Apskaičiuotas laikas (Accounted time)',
        'Linked-Object' => 'Susietas objektas',
        'by' => 'pagal',

        # Template: AgentTicketPriority

        # Template: AgentTicketProcess
        'Create New Process Ticket' => '',
        'Process' => '',

        # Template: AgentTicketProcessNavigationBar

        # Template: AgentTicketQueue

        # Template: AgentTicketResponsible

        # Template: AgentTicketSearch
        'Search template' => 'Paieškos šablonas',
        'Create Template' => 'Sukurti šabloną',
        'Create New' => 'Sukurti naują',
        'Profile link' => '',
        'Save changes in template' => 'Išsaugoti pakeitimus šablone',
        'Add another attribute' => 'Pridėti dar vieną atributą',
        'Output' => 'Išvestis',
        'Fulltext' => 'Visas tekstas',
        'Remove' => 'Pašalinti',
        'Searches in the attributes From, To, Cc, Subject and the article body, overriding other attributes with the same name.' =>
            '',
        'Customer User Login' => 'Kliento naudotojo prisijungimas',
        'Created in Queue' => 'Sukurti eilėje',
        'Lock state' => 'Užrakinimo būsena',
        'Watcher' => 'Stebėtojas',
        'Article Create Time (before/after)' => 'Straipsnio sukūrimo data (prieš/po)',
        'Article Create Time (between)' => 'Straipsnio sukūrimo data (tarp)',
        'Ticket Create Time (before/after)' => 'Trikties sukūrimo data (prieš/po)',
        'Ticket Create Time (between)' => 'Trikties sukūrimo data (tarp)',
        'Ticket Change Time (before/after)' => 'Trikties keitimo data (prieš/po)',
        'Ticket Change Time (between)' => 'Trikties keitimo data (tarp)',
        'Ticket Close Time (before/after)' => 'Trikties uždarymo data (prieš/po)',
        'Ticket Close Time (between)' => 'Trikties uždarymo data (tarp)',
        'Ticket Escalation Time (before/after)' => '',
        'Ticket Escalation Time (between)' => '',
        'Archive Search' => 'Paieška archyve',
        'Run search' => '',

        # Template: AgentTicketSearchOpenSearchDescriptionFulltext

        # Template: AgentTicketSearchOpenSearchDescriptionTicketNumber

        # Template: AgentTicketSearchResultPrint

        # Template: AgentTicketZoom
        'Article filter' => 'Straipsnių filtras',
        'Article Type' => 'Straipsnio tipas',
        'Sender Type' => 'Siuntėjo tipas',
        'Save filter settings as default' => 'Išsaugoti filtro nustatymus kaip numatytuosius',
        'Archive' => '',
        'This ticket is archived.' => '',
        'Linked Objects' => 'Susieti objektai',
        'Article(s)' => 'Straipsnis(-iai)',
        'Change Queue' => 'Pakeisti eilę',
        'There are no dialogs available at this point in the process.' =>
            '',
        'This item has no articles yet.' => '',
        'Article Filter' => 'Straipsnių Filtras',
        'Add Filter' => 'Pridėti filtrą',
        'Set' => 'Nustatyti',
        'Reset Filter' => 'Anuliuoti filtrą',
        'Show one article' => 'Rodyti vieną straipsnį',
        'Show all articles' => 'Rodyti visus straipsnius',
        'Unread articles' => 'Neperskaityti straipsniai',
        'No.' => 'Nr.',
        'Unread Article!' => 'Neskaitytas straipsnis!',
        'Incoming message' => 'Įeinanti žinutė',
        'Outgoing message' => 'Išeinanti žinutė',
        'Internal message' => 'Vidinė žinutė',
        'Resize' => 'Keisti dydį',

        # Template: AttachmentBlocker
        'To protect your privacy, remote content was blocked.' => '',
        'Load blocked content.' => '',

        # Template: Copyright

        # Template: CustomerAccept

        # Template: CustomerError
        'Traceback' => '',

        # Template: CustomerFooter
        'Powered by' => 'Powered by',
        'One or more errors occurred!' => 'Iškilo viena ar daugiau problemų!',
        'Close this dialog' => 'Užverti šį dialogo langą',
        'Could not open popup window. Please disable any popup blockers for this application.' =>
            'Nepavyko atverti iššokančio lango. Prašome išjungti visus iššokančius langus blokuojančias programas.',

        # Template: CustomerFooterSmall

        # Template: CustomerHeader

        # Template: CustomerHeaderSmall

        # Template: CustomerLogin
        'JavaScript Not Available' => 'JavaScript neįjungtas.',
        'In order to experience OTRS, you\'ll need to enable JavaScript in your browser.' =>
            'Norint geriausios, darbo su OTRS, patirties Jums reikia savo naršyklėje įjungti JavaScript.',
        'Browser Warning' => 'Naršyklės perspėjimas',
        'The browser you are using is too old.' => 'Jūsų naudojama interneto naršyklė yra per sena.',
        'OTRS runs with a huge lists of browsers, please upgrade to one of these.' =>
            'OTRS gali veikti su daugybe naršyklių, prašome atsinaujinti į vieną iš jų.',
        'Please see the documentation or ask your admin for further information.' =>
            'Daugiau informacijos ieškokit dokumentacijoje arba kreipkitės į administratorių.',
        'Login' => 'Prisijungti',
        'User name' => 'Naudotojo vardas',
        'Your user name' => 'Jūsų naudotojo vardas',
        'Your password' => 'Jūsų slaptažodis',
        'Forgot password?' => 'Pamiršote slaptažodį?',
        'Log In' => 'Prisijungti',
        'Not yet registered?' => 'Neregistruotas?',
        'Sign up now' => 'Prisijunkite',
        'Request new password' => 'Prašyti naujo slaptažodžio',
        'Your User Name' => 'Jūsų Naudotojo Vardas',
        'A new password will be sent to your email address.' => 'Naujas slaptažodis bus nusiųstas į Jūsų pašto dėžutę.',
        'Create Account' => 'Sukurti paskyrą',
        'Please fill out this form to receive login credentials.' => '',
        'How we should address you' => 'Kaip turėtume į Jus kreiptis?',
        'Your First Name' => 'Jūsų vardas',
        'Please supply a first name' => 'Prašome pateikti vardą',
        'Your Last Name' => 'Jūsų pavardė',
        'Please supply a last name' => 'Prašome pateikti pavardę',
        'Your email address (this will become your username)' => '',
        'Please supply a' => 'Prašome pateikti:',

        # Template: CustomerNavigationBar
        'Edit personal preferences' => 'Redaguoti asmeninius nustatymus',
        'Logout %s' => '',

        # Template: CustomerPreferences

        # Template: CustomerRichTextEditor

        # Template: CustomerTicketMessage
        'Service level agreement' => 'Aptarnavimo lygio sutartis (SLA)',

        # Template: CustomerTicketOverview
        'Welcome!' => 'Sveiki atvykę!',
        'Please click the button below to create your first ticket.' => 'Prašome paspausti žemiau esantį mytuką, kad sukurtumėte savo pirmąjį trikties pranešimą.',
        'Create your first ticket' => 'Sukurti pirmąjį trikties pranešimą',

        # Template: CustomerTicketPrint
        'Ticket Print' => 'Spausdinti triktį',

        # Template: CustomerTicketSearch
        'Profile' => 'Profilis',
        'e. g. 10*5155 or 105658*' => 'pvz. 10*5155 arba 105658*',
        'Fulltext search in tickets (e. g. "John*n" or "Will*")' => 'Pilno teksto paieška triktyse (pvz., "Petr*" arba "Jon*is")',
        'Recipient' => 'Gavėjas',
        'Carbon Copy' => 'Kopija',
        'Time restrictions' => 'Laiko apribojimai',
        'No time settings' => '',
        'Only tickets created' => 'Tik triktys sukurti',
        'Only tickets created between' => 'Tik triktys sukurti tarp',
        'Ticket archive system' => '',
        'Save search as template?' => '',
        'Save as Template?' => 'Išsaugoti kaip šabloną?',
        'Save as Template' => '',
        'Template Name' => 'Šablono pavadinimas',
        'Pick a profile name' => '',
        'Output to' => 'Rezultato išvedimas: ',

        # Template: CustomerTicketSearchOpenSearchDescription

        # Template: CustomerTicketSearchResultPrint

        # Template: CustomerTicketSearchResultShort
        'of' => 'iš',
        'Page' => 'Puslapis',
        'Search Results for' => 'Paieškos rezultatai: ',

        # Template: CustomerTicketZoom
        'Show  article' => '',
        'Expand article' => 'Išplėsti straipsnį',
        'Information' => '',
        'Next Steps' => '',
        'Reply' => 'Atsakyti',

        # Template: CustomerWarning

        # Template: Datepicker
        'Invalid date (need a future date)!' => 'Negalima data (turi būti ateities data)!',
        'Previous' => 'Buvęs',
        'Sunday' => 'Sekmadienis',
        'Monday' => 'Pirmadienis',
        'Tuesday' => 'Antradienis',
        'Wednesday' => 'Trečiadienis',
        'Thursday' => 'Ketvirtadienis',
        'Friday' => 'Penktadienis',
        'Saturday' => 'Šeštadienis',
        'Su' => 'S',
        'Mo' => 'Pr',
        'Tu' => 'A',
        'We' => 'T',
        'Th' => 'K',
        'Fr' => 'Pn',
        'Sa' => 'Š',
        'Open date selection' => 'Atverti datos parinkiklį',

        # Template: Error
        'Oops! An Error occurred.' => 'Oi! Įvyko klaida.',
        'Error Message' => 'Klaidos pranešimas',
        'You can' => 'Jūs galite',
        'Send a bugreport' => 'Siųsti pranešimą apie defektą',
        'go back to the previous page' => 'Grįžti prie buvusio puslapio',
        'Error Details' => 'Klaidos smulkmenos',

        # Template: Footer
        'Top of page' => 'Puslapio viršus',

        # Template: FooterJS
        'If you now leave this page, all open popup windows will be closed, too!' =>
            'Jeigu dabar užversite/paliksite šį puslapį, tai visi iššokantys langai taip pat bus užverti!',
        'A popup of this screen is already open. Do you want to close it and load this one instead?' =>
            'Šio ekrano iššokantis langas jau yra atvertas. Ar norite jį uždaryti ir vietoj jo užkrauti šį?',
        'Please enter at least one search value or * to find anything.' =>
            '',

        # Template: FooterSmall

        # Template: HTMLHead

        # Template: HTMLHeadBlockEvents

        # Template: Header
        'Fulltext search' => '',
        'CustomerID Search' => '',
        'CustomerUser Search' => '',
        'You are logged in as' => 'Prisijungėte kaip',

        # Template: HeaderSmall

        # Template: Installer
        'JavaScript not available' => 'JavaScript neįjungtas.',
        'Database Settings' => 'Duomenų bazės nustatymai',
        'General Specifications and Mail Settings' => 'Bendrieji reikalavimai ir Pašto nustatymai',
        'Registration' => '',
        'Welcome to %s' => 'Sveiki atvykę į %s',
        'Web site' => 'Interneto puslapis',
        'Database check successful.' => 'Duomenų bazės patikrinimas sėkmingas.',
        'Mail check successful.' => 'El. pašto patikrinimas sėkmingas.',
        'Error in the mail settings. Please correct and try again.' => 'Klaida pašto nustatymuose. Prašome ištaisyti klaidas ir bandyti iš naujo.',

        # Template: InstallerConfigureMail
        'Configure Outbound Mail' => 'Išeinančio el. pašto konfigūracija',
        'Outbound mail type' => 'Išeinančio el. pašto tipas',
        'Select outbound mail type.' => 'Pasirinkite išeinančio el. pašto tipą',
        'Outbound mail port' => 'Išeinančio el. pašto prievadas',
        'Select outbound mail port.' => 'Pasirinkite išeinančio el. pašto prievadą',
        'SMTP host' => 'SMTP serveris',
        'SMTP host.' => 'SMTP serveris',
        'SMTP authentication' => 'SMTP autentikacija',
        'Does your SMTP host need authentication?' => 'Ar SMTP serveris reikalauja autentikacijos?',
        'SMTP auth user' => 'SMTP naudotojo autentikacija',
        'Username for SMTP auth.' => 'SMTP naudotojo vardas.',
        'SMTP auth password' => 'SMTP slaptažodis',
        'Password for SMTP auth.' => 'Slaptažodis SMTP autentikacijai.',
        'Configure Inbound Mail' => 'Įeinančio el. pašto konfigūracija',
        'Inbound mail type' => 'Įeinančio el. pašto tipas',
        'Select inbound mail type.' => 'Pasirinkite įeinančio el. pašto tipą',
        'Inbound mail host' => 'Gaunamo el. pašto serveris',
        'Inbound mail host.' => 'Gaunamo el. pašto serveris.',
        'Inbound mail user' => 'Gaunamo el. pašto naudotojas',
        'User for inbound mail.' => 'Naudotojas įeinančiam el. paštui',
        'Inbound mail password' => 'Įeinančio el. pašto naudotojo slaptažodis',
        'Password for inbound mail.' => 'Slaptažodis įeinančiam el. paštui.',
        'Result of mail configuration check' => 'El. pašto konfigūracijos patikrinimo rezultatas',
        'Check mail configuration' => 'Patikrinti el. pašto konfigūraciją',
        'Skip this step' => 'Praleisti šį žingsnį',
        'Skipping this step will automatically skip the registration of your OTRS. Are you sure you want to continue?' =>
            '',

        # Template: InstallerDBResult
        'False' => 'Neigiama',

        # Template: InstallerDBStart
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty. For security reasons we do recommend setting a root password. For more information please refer to your database documentation.' =>
            'Čia turi būti įvestas Jūsų duomenų bazės root naudotojo slaptažodis, jeigu toks yra nustatytas, jeigu ne, tai palikite šį laukelį tuščią. Dėl saugumo, mes, nerekomenduojame naudoti root slaptažodžio. Daugiau informacijos rasite savo duomenų bazės dokumentacijoje.',
        'Currently only MySQL is supported in the web installer.' => 'Šiuo metu web-įdiegimo sąsajoje palaikomas tik MySQL.',
        'If you want to install OTRS on another database type, please refer to the file README.database.' =>
            'Jeigu OTRS diegimui norite naudoti kitokį duombazės tipą skaitykite failą README.database',
        'Database-User' => 'Duomenų bazės naudotojas',
        'New' => 'Naujas',
        'A new database user with limited rights will be created for this OTRS system.' =>
            'Šiai OTRS sistemai bus sukurtas naujas, apribotas teises turintis, duomenų bazės naudotojas.',
        'default \'hot\'' => 'standartiškai \'hot\'',
        'DB host' => 'Duomenų bazės serveris',
        'Check database settings' => 'Patikrinti duomenų bazės nustatymus',
        'Result of database check' => 'Duomenų bazės nustatymų patikrinimo rezultatas',

        # Template: InstallerFinish
        'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' =>
            'Norėdami naudoti OTRS turite root naudotojo teisėmis, komandinėje eilutėje (terminale), įvesti šią komandą.',
        'Restart your webserver' => 'Perkraukite savo web serverį.',
        'After doing so your OTRS is up and running.' => 'Atlikus šiuos veiksmus bus paleista OTRS sistema.',
        'Start page' => 'Pradinis puslapis',
        'Your OTRS Team' => 'Jūsų OTRS komanda',

        # Template: InstallerLicense
        'Accept license' => 'Sutikti su licenzija',
        'Don\'t accept license' => 'Nesutikti su licenzija',

        # Template: InstallerLicenseText

        # Template: InstallerRegistration
        'Organization' => 'Organizacija',
        'Position' => '',
        'Complete registration and continue' => '',
        'Please fill in all fields marked as mandatory.' => '',

        # Template: InstallerSystem
        'SystemID' => 'SystemID',
        'The identifier of the system. Each ticket number and each HTTP session ID contain this number.' =>
            'Sistemos identifikacijos numeris. Šis numeris bus kiekviename trikties numeryje ir kiekviename HTTP sesijos ID',
        'System FQDN' => 'Sistemos FQDN',
        'Fully qualified domain name of your system.' => 'Pilnas sistemos domeno pavadinimas (Fully qualified domain name).',
        'AdminEmail' => 'Administratoriaus el. pašto adresas',
        'Email address of the system administrator.' => 'Sistemos administratoriaus el. pašto adresas.',
        'Log' => 'Žurnalas (log)',
        'LogModule' => 'Žurnalo modulis (log module)',
        'Log backend to use.' => 'Žurnalo posistemė.',
        'LogFile' => 'Žurnalo failas',
        'Log file location is only needed for File-LogModule!' => 'Žurnalizavimo failo vieta (log file location) yra reikalinga tik File-LogModule!',
        'Webfrontend' => 'Web sąsaja',
        'Default language' => 'Standartinė kalba',
        'Default language.' => 'Standartinė kalba.',
        'CheckMXRecord' => 'Tikrinti MX įrašą',
        'Email addresses that are manually entered are checked against the MX records found in DNS. Don\'t use this option if your DNS is slow or does not resolve public addresses.' =>
            'Rankiniu būdu įvesti el. pašto adresai yra patikrinami DNS MX sąrašuose. Nenaudokite šios parinkties jeigu Jūsų DNS yra lėtas arba neaptarnauja viešų adresų.',

        # Template: LinkObject
        'Object#' => 'Objekto numeris',
        'Add links' => 'Pridėti nuorodas',
        'Delete links' => 'Ištrinti nuorodas',

        # Template: Login
        'Lost your password?' => 'Pamiršote slaptažodį?',
        'Request New Password' => 'Prašyti naujo slaptažodžio',
        'Back to login' => 'Grįžti prie prisijungimo',

        # Template: Motd
        'Message of the Day' => 'Dienos žinutė',

        # Template: NoPermission
        'Insufficient Rights' => 'Nepakankamos teisės',
        'Back to the previous page' => 'Atgal prie buvusio puslapio',

        # Template: Notify

        # Template: Pagination
        'Show first page' => 'Rodyti pirmą puslapį',
        'Show previous pages' => 'Rodyti ankstesnius puslapius',
        'Show page %s' => 'Rodyti %s puslapį',
        'Show next pages' => 'Rodyti sekančius puslapius',
        'Show last page' => 'Rodyti paskutinį puslapį',

        # Template: PictureUpload
        'Need FormID!' => 'Reikia Formos ID!',
        'No file found!' => 'Failas nerastas!',
        'The file is not an image that can be shown inline!' => 'Failas nėra paveikslėlis, kurį būtų galima rodyti tiesiogiai (? inline)',

        # Template: PrintFooter
        'URL' => 'URL',

        # Template: PrintHeader
        'printed by' => 'atspausdino',

        # Template: PublicDefault

        # Template: Redirect

        # Template: RichTextEditor

        # Template: SpellingInline

        # Template: Test
        'OTRS Test Page' => 'OTRS Bandomasis puslapis',
        'Welcome %s' => 'Sveiki %s',
        'Counter' => 'Skaitliukas',

        # Template: Warning
        'Go back to the previous page' => 'Grįžti prie buvusio puslapio',

        # SysConfig
        '"Slim" Skin which tries to save screen space for power users.' =>
            '',
        'ACL module that allows closing parent tickets only if all its children are already closed ("State" shows which states are not available for the parent ticket until all child tickets are closed).' =>
            '',
        'AccountedTime' => '',
        'Activates a blinking mechanism of the queue that contains the oldest ticket.' =>
            '',
        'Activates lost password feature for agents, in the agent interface.' =>
            '',
        'Activates lost password feature for customers.' => '',
        'Activates support for customer groups.' => '',
        'Activates the article filter in the zoom view to specify which articles should be shown.' =>
            '',
        'Activates the available themes on the system. Value 1 means active, 0 means inactive.' =>
            '',
        'Activates the ticket archive system search in the customer interface.' =>
            '',
        'Activates the ticket archive system to have a faster system by moving some tickets out of the daily scope. To search for these tickets, the archive flag has to be enabled in the ticket search.' =>
            '',
        'Activates time accounting.' => '',
        'Adds a suffix with the actual year and month to the OTRS log file. A logfile for every month will be created.' =>
            '',
        'Adds customers email addresses to recipients in the ticket compose screen of the agent interface. The customers email address won\'t be added if the article type is email-internal.' =>
            '',
        'Adds the one time vacation days for the indicated calendar. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            '',
        'Adds the one time vacation days. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            '',
        'Adds the permanent vacation days for the indicated calendar. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            '',
        'Adds the permanent vacation days. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            '',
        'Agent Notifications' => 'Pranešimai agentams',
        'Agent interface article notification module to check PGP.' => '',
        'Agent interface article notification module to check S/MIME.' =>
            '',
        'Agent interface module to access CIC search via nav bar.' => '',
        'Agent interface module to access fulltext search via nav bar.' =>
            '',
        'Agent interface module to access search profiles via nav bar.' =>
            '',
        'Agent interface module to check incoming emails in the Ticket-Zoom-View if the S/MIME-key is available and true.' =>
            '',
        'Agent interface notification module to check the used charset.' =>
            '',
        'Agent interface notification module to see the number of tickets an agent is responsible for.' =>
            '',
        'Agent interface notification module to see the number of watched tickets.' =>
            '',
        'Agents <-> Groups' => 'Agentai <-> Grupės',
        'Agents <-> Roles' => 'Agentai <-> Rolės',
        'All customer users of a CustomerID' => '',
        'Allows adding notes in the close ticket screen of the agent interface.' =>
            '',
        'Allows adding notes in the ticket free text screen of the agent interface.' =>
            '',
        'Allows adding notes in the ticket note screen of the agent interface.' =>
            '',
        'Allows adding notes in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Allows adding notes in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Allows adding notes in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Allows adding notes in the ticket responsible screen of the agent interface.' =>
            '',
        'Allows agents to exchange the axis of a stat if they generate one.' =>
            '',
        'Allows agents to generate individual-related stats.' => '',
        'Allows choosing between showing the attachments of a ticket in the browser (inline) or just make them downloadable (attachment).' =>
            '',
        'Allows choosing the next compose state for customer tickets in the customer interface.' =>
            '',
        'Allows customers to change the ticket priority in the customer interface.' =>
            '',
        'Allows customers to set the ticket SLA in the customer interface.' =>
            '',
        'Allows customers to set the ticket priority in the customer interface.' =>
            '',
        'Allows customers to set the ticket queue in the customer interface. If this is set to \'No\', QueueDefault should be configured.' =>
            '',
        'Allows customers to set the ticket service in the customer interface.' =>
            '',
        'Allows customers to set the ticket type in the customer interface. If this is set to \'No\', TicketTypeDefault should be configured.' =>
            '',
        'Allows default services to be selected also for non existing customers.' =>
            '',
        'Allows defining new types for ticket (if ticket type feature is enabled).' =>
            '',
        'Allows defining services and SLAs for tickets (e. g. email, desktop, network, ...), and escalation attributes for SLAs (if ticket service/SLA feature is enabled).' =>
            '',
        'Allows extended search conditions in ticket search of the agent interface. With this feature you can search e. g. with this kind of conditions like "(key1&&key2)" or "(key1||key2)".' =>
            '',
        'Allows extended search conditions in ticket search of the customer interface. With this feature you can search w. g. with this kind of conditions like "(key1&&key2)" or "(key1||key2)".' =>
            '',
        'Allows having a medium format ticket overview (CustomerInfo => 1 - shows also the customer information).' =>
            '',
        'Allows having a small format ticket overview (CustomerInfo => 1 - shows also the customer information).' =>
            '',
        'Allows the administrators to login as other customers, via the customer user administration panel.' =>
            '',
        'Allows the administrators to login as other users, via the users administration panel.' =>
            '',
        'Allows to set a new ticket state in the move ticket screen of the agent interface.' =>
            '',
        'ArticleTree' => '',
        'Attachments <-> Responses' => 'Priedai <-> Atsakymai',
        'Auto Responses <-> Queues' => 'Automatiniai atsakymai <-> Eilės',
        'Automated line break in text messages after x number of chars.' =>
            '',
        'Automatically lock and set owner to current Agent after selecting for an Bulk Action.' =>
            '',
        'Automatically sets the owner of a ticket as the responsible for it (if ticket responsible feature is enabled).' =>
            '',
        'Automatically sets the responsible of a ticket (if it is not set yet) after the first owner update.' =>
            '',
        'Balanced white skin by Felix Niklas.' => '',
        'Basic fulltext index settings. Execute "bin/otrs.RebuildFulltextIndex.pl" in order to generate a new index.' =>
            '',
        'Blocks all the incoming emails that do not have a valid ticket number in subject with From: @example.com address.' =>
            '',
        'Builds an article index right after the article\'s creation.' =>
            '',
        'CMD example setup. Ignores emails where external CMD returns some output on STDOUT (email will be piped into STDIN of some.bin).' =>
            '',
        'Cache time in seconds for agent authentication in the GenericInterface.' =>
            '',
        'Cache time in seconds for customer authentication in the GenericInterface.' =>
            '',
        'Cache time in seconds for the DB process backend.' => '',
        'Cache time in seconds for the ticket process navigation bar output module.' =>
            '',
        'Cache time in seconds for the web service config backend.' => '',
        'Change password' => '',
        'Change queue!' => '',
        'Change the customer for this ticket' => '',
        'Change the free fields for this ticket' => '',
        'Change the priority for this ticket' => '',
        'Change the responsible person for this ticket' => '',
        'Changes the owner of tickets to everyone (useful for ASP). Normally only agent with rw permissions in the queue of the ticket will be shown.' =>
            '',
        'Checkbox' => '',
        'Checks the SystemID in ticket number detection for follow-ups (use "No" if SystemID has been changed after using the system).' =>
            '',
        'Closed tickets of customer' => '',
        'Comment for new history entries in the customer interface.' => '',
        'Company Status' => '',
        'Company Tickets' => 'Organizacijos triktys',
        'Company name for the customer web interface. Will also be included in emails as an X-Header.' =>
            '',
        'Configure Processes.' => '',
        'Configure your own log text for PGP.' => '',
        'Configures a default TicketDynmicField setting. "Name" defines the dynamic field which should be used, "Value" is the data that will be set, and "Event" defines the trigger event. Please check the developer manual (http://doc.otrs.org/), chapter "Ticket Event Module".' =>
            '',
        'Controls if customers have the ability to sort their tickets.' =>
            '',
        'Controls if more than one from entry can be set in the new phone ticket in the agent interface.' =>
            '',
        'Controls if the ticket and article seen flags are removed when a ticket is archived.' =>
            '',
        'Converts HTML mails into text messages.' => '',
        'Create New process ticket' => '',
        'Create and manage Service Level Agreements (SLAs).' => 'Kurti ir valdyti Aptarnavimo Lygio Sutartis (SLA).',
        'Create and manage agents.' => 'Kurti ir valdyti agentus.',
        'Create and manage attachments.' => 'Kurti ir valdyti priedus(attachment).',
        'Create and manage companies.' => 'Kurti ir valdyti organizacijas.',
        'Create and manage customers.' => 'Kurti ir valdyti klientus.',
        'Create and manage dynamic fields.' => '',
        'Create and manage event based notifications.' => 'Kurti ir valdyti nuo įvykių priklausančius pranešimus.',
        'Create and manage groups.' => 'Kurti ir valdyti grupes.',
        'Create and manage queues.' => 'Kurti ir valdyti eiles.',
        'Create and manage response templates.' => 'Kurti ir valdyti atsakymų šablonus.',
        'Create and manage responses that are automatically sent.' => 'Kurti ir valdyti automatiškai siunčiamus atsakymus.',
        'Create and manage roles.' => 'Kurti ir valdyti roles.',
        'Create and manage salutations.' => 'Kurti ir valdyti kreipinius į asmenis (salutations).',
        'Create and manage services.' => 'Kurti ir valdyti paslaugas(services).',
        'Create and manage signatures.' => 'Kurti ir valdyti parašus.',
        'Create and manage ticket priorities.' => 'Kurti ir valdyti prioritetus.',
        'Create and manage ticket states.' => 'Kurti ir valdyti trikčių būsenas.',
        'Create and manage ticket types.' => 'Kurti ir valdyti trikčių tipus.',
        'Create and manage web services.' => '',
        'Create new email ticket and send this out (outbound)' => 'Sukurti naują el. pašto triktį ir išsiųsti (išorinis)',
        'Create new phone ticket (inbound)' => 'Sukurti naują telefonu praneštą triktį (vidinis)',
        'Custom text for the page shown to customers that have no tickets yet.' =>
            '',
        'Customer Company Administration' => '',
        'Customer Company Information' => '',
        'Customer User Administration' => '',
        'Customer Users' => '',
        'Customer item (icon) which shows the closed tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            '',
        'Customer item (icon) which shows the open tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            '',
        'CustomerName' => '',
        'Customers <-> Groups' => 'Klientai <-> Grupės',
        'Customers <-> Services' => 'Klientai <-> Paslaugos',
        'Data used to export the search result in CSV format.' => '',
        'Date / Time' => '',
        'Debugs the translation set. If this is set to "Yes" all strings (text) without translations are written to STDERR. This can be helpful when you are creating a new translation file. Otherwise, this option should remain set to "No".' =>
            '',
        'Default ACL values for ticket actions.' => '',
        'Default ProcessManagement entity prefixes for entity IDs that are automatically generated.' =>
            '',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimePointFormat=year;TicketCreateTimePointStart=Last;TicketCreateTimePoint=2;".' =>
            '',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimeStartYear=2010;TicketCreateTimeStartMonth=10;TicketCreateTimeStartDay=4;TicketCreateTimeStopYear=2010;TicketCreateTimeStopMonth=11;TicketCreateTimeStopDay=3;".' =>
            '',
        'Default loop protection module.' => '',
        'Default queue ID used by the system in the agent interface.' => '',
        'Default skin for OTRS 3.0 interface.' => '',
        'Default skin for interface.' => '',
        'Default ticket ID used by the system in the agent interface.' =>
            '',
        'Default ticket ID used by the system in the customer interface.' =>
            '',
        'Default value for NameX' => '',
        'Define a filter for html output to add links behind a defined string. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            '',
        'Define the max depth of queues.' => '',
        'Define the start day of the week for the date picker.' => '',
        'Defines a customer item, which generates a LinkedIn icon at the end of a customer info block.' =>
            '',
        'Defines a customer item, which generates a XING icon at the end of a customer info block.' =>
            '',
        'Defines a customer item, which generates a google icon at the end of a customer info block.' =>
            '',
        'Defines a customer item, which generates a google maps icon at the end of a customer info block.' =>
            '',
        'Defines a default list of words, that are ignored by the spell checker.' =>
            '',
        'Defines a filter for html output to add links behind CVE numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            '',
        'Defines a filter for html output to add links behind MSBulletin numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            '',
        'Defines a filter for html output to add links behind a defined string. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            '',
        'Defines a filter for html output to add links behind bugtraq numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            '',
        'Defines a filter to process the text in the articles, in order to highlight predefined keywords.' =>
            '',
        'Defines a regular expression that excludes some addresses from the syntax check (if "CheckEmailAddresses" is set to "Yes"). Please enter a regex in this field for email addresses, that aren\'t syntactically valid, but are necessary for the system (i.e. "root@localhost").' =>
            '',
        'Defines a regular expression that filters all email addresses that should not be used in the application.' =>
            '',
        'Defines a useful module to load specific user options or to display news.' =>
            '',
        'Defines all the X-headers that should be scanned.' => '',
        'Defines all the languages that are available to the application. The Key/Content pair links the front-end display name to the appropriate language PM file. The "Key" value should be the base-name of the PM file (i.e. de.pm is the file, then de is the "Key" value). The "Content" value should be the display name for the front-end. Specify any own-defined language here (see the developer documentation http://doc.otrs.org/ for more infomation). Please remember to use the HTML equivalents for non-ASCII characters (i.e. for the German oe = o umlaut, it is necessary to use the &ouml; symbol).' =>
            '',
        'Defines all the parameters for the RefreshTime object in the customer preferences of the customer interface.' =>
            '',
        'Defines all the parameters for the ShownTickets object in the customer preferences of the customer interface.' =>
            '',
        'Defines all the parameters for this item in the customer preferences.' =>
            '',
        'Defines all the possible stats output formats.' => '',
        'Defines an alternate URL, where the login link refers to.' => '',
        'Defines an alternate URL, where the logout link refers to.' => '',
        'Defines an alternate login URL for the customer panel..' => '',
        'Defines an alternate logout URL for the customer panel.' => '',
        'Defines an external link to the database of the customer (e.g. \'http://yourhost/customer.php?CID=$Data{"CustomerID"}\' or \'\').' =>
            '',
        'Defines how the From field from the emails (sent from answers and email tickets) should look like.' =>
            '',
        'Defines if a pre-sorting by priority should be done in the queue view.' =>
            '',
        'Defines if a ticket lock is required in the close ticket screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket bounce screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket compose screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket forward screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket free text screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket merge screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket note screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket owner screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket pending screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket phone inbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket phone outbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket priority screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket responsible screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required to change the customer of a ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if composed messages have to be spell checked in the agent interface.' =>
            '',
        'Defines if the enhanced mode should be used (enables use of table, replace, subscript, superscript, paste from word, etc.).' =>
            '',
        'Defines if time accounting is mandatory in the agent interface.' =>
            '',
        'Defines if time accounting must be set to all tickets in bulk action.' =>
            '',
        'Defines scheduler PID update time in seconds (floating point number).' =>
            '',
        'Defines scheduler sleep time in seconds after processing all available tasks (floating point number).' =>
            '',
        'Defines the IP regular expression for accessing the local repository. You need to enable this to have access to your local repository and the package::RepositoryList is required on the remote host.' =>
            '',
        'Defines the URL CSS path.' => '',
        'Defines the URL base path of icons, CSS and Java Script.' => '',
        'Defines the URL image path of icons for navigation.' => '',
        'Defines the URL java script path.' => '',
        'Defines the URL rich text editor path.' => '',
        'Defines the address of a dedicated DNS server, if necessary, for the "CheckMXRecord" look-ups.' =>
            '',
        'Defines the body text for notification mails sent to agents, about new password (after using this link the new password will be sent).' =>
            '',
        'Defines the body text for notification mails sent to agents, with token about new requested password (after using this link the new password will be sent).' =>
            '',
        'Defines the body text for notification mails sent to customers, about new account.' =>
            '',
        'Defines the body text for notification mails sent to customers, about new password (after using this link the new password will be sent).' =>
            '',
        'Defines the body text for notification mails sent to customers, with token about new requested password (after using this link the new password will be sent).' =>
            '',
        'Defines the body text for rejected emails.' => '',
        'Defines the boldness of the line drawed by the graph.' => '',
        'Defines the colors for the graphs.' => '',
        'Defines the column to store the keys for the preferences table.' =>
            '',
        'Defines the config parameters of this item, to be shown in the preferences view.' =>
            '',
        'Defines the config parameters of this item, to be shown in the preferences view. Take care to maintain the dictionaries installed in the system in the data section.' =>
            '',
        'Defines the connections for http/ftp, via a proxy.' => '',
        'Defines the date input format used in forms (option or input fields).' =>
            '',
        'Defines the default CSS used in rich text editors.' => '',
        'Defines the default auto response type of the article for this operation.' =>
            '',
        'Defines the default body of a note in the ticket free text screen of the agent interface.' =>
            '',
        'Defines the default front-end (HTML) theme to be used by the agents and customers. The default themes are Standard and Lite. If you like, you can add your own theme. Please refer the administrator manual located at http://doc.otrs.org/.' =>
            '',
        'Defines the default front-end language. All the possible values are determined by the available language files on the system (see the next setting).' =>
            '',
        'Defines the default history type in the customer interface.' => '',
        'Defines the default maximum number of X-axis attributes for the time scale.' =>
            '',
        'Defines the default maximum number of search results shown on the overview page.' =>
            '',
        'Defines the default next state for a ticket after customer follow up in the customer interface.' =>
            '',
        'Defines the default next state of a ticket after adding a note, in the close ticket screen of the agent interface.' =>
            '',
        'Defines the default next state of a ticket after adding a note, in the ticket bulk screen of the agent interface.' =>
            '',
        'Defines the default next state of a ticket after adding a note, in the ticket free text screen of the agent interface.' =>
            '',
        'Defines the default next state of a ticket after adding a note, in the ticket note screen of the agent interface.' =>
            '',
        'Defines the default next state of a ticket after adding a note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the default next state of a ticket after adding a note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the default next state of a ticket after adding a note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the default next state of a ticket after adding a note, in the ticket responsible screen of the agent interface.' =>
            '',
        'Defines the default next state of a ticket after being bounced, in the ticket bounce screen of the agent interface.' =>
            '',
        'Defines the default next state of a ticket after being forwarded, in the ticket forward screen of the agent interface.' =>
            '',
        'Defines the default next state of a ticket if it is composed / answered in the ticket compose screen of the agent interface.' =>
            '',
        'Defines the default note body text for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Defines the default note body text for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            '',
        'Defines the default priority of follow up customer tickets in the ticket zoom screen in the customer interface.' =>
            '',
        'Defines the default priority of new customer tickets in the customer interface.' =>
            '',
        'Defines the default priority of new tickets.' => '',
        'Defines the default queue for new customer tickets in the customer interface.' =>
            '',
        'Defines the default selection at the drop down menu for dynamic objects (Form: Common Specification).' =>
            '',
        'Defines the default selection at the drop down menu for permissions (Form: Common Specification).' =>
            '',
        'Defines the default selection at the drop down menu for stats format (Form: Common Specification). Please insert the format key (see Stats::Format).' =>
            '',
        'Defines the default sender type for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Defines the default sender type for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            '',
        'Defines the default sender type for tickets in the ticket zoom screen of the customer interface.' =>
            '',
        'Defines the default shown ticket search attribute for ticket search screen.' =>
            '',
        'Defines the default shown ticket search attribute for ticket search screen. Example: a text, 1, Search_DynamicField_Field1StartYear=2002; Search_DynamicField_Field1StartMonth=12; Search_DynamicField_Field1StartDay=12; Search_DynamicField_Field1StartHour=00; Search_DynamicField_Field1StartMinute=00; Search_DynamicField_Field1StartSecond=00; Search_DynamicField_Field1StopYear=2009; Search_DynamicField_Field1StopMonth=02; Search_DynamicField_Field1StopDay=10; Search_DynamicField_Field1StopHour=23; Search_DynamicField_Field1StopMinute=59; Search_DynamicField_Field1StopSecond=59;.' =>
            '',
        'Defines the default sort criteria for all queues displayed in the queue view.' =>
            '',
        'Defines the default sort order for all queues in the queue view, after priority sort.' =>
            '',
        'Defines the default spell checker dictionary.' => '',
        'Defines the default state of new customer tickets in the customer interface.' =>
            '',
        'Defines the default state of new tickets.' => '',
        'Defines the default subject for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Defines the default subject for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            '',
        'Defines the default subject of a note in the ticket free text screen of the agent interface.' =>
            '',
        'Defines the default ticket attribute for ticket sorting in a ticket search of the customer interface.' =>
            '',
        'Defines the default ticket attribute for ticket sorting in the escalation view of the agent interface.' =>
            '',
        'Defines the default ticket attribute for ticket sorting in the locked ticket view of the agent interface.' =>
            '',
        'Defines the default ticket attribute for ticket sorting in the responsible view of the agent interface.' =>
            '',
        'Defines the default ticket attribute for ticket sorting in the status view of the agent interface.' =>
            '',
        'Defines the default ticket attribute for ticket sorting in the watch view of the agent interface.' =>
            '',
        'Defines the default ticket attribute for ticket sorting of the ticket search result of the agent interface.' =>
            '',
        'Defines the default ticket bounced notification for customer/sender in the ticket bounce screen of the agent interface.' =>
            '',
        'Defines the default ticket next state after adding a phone note in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Defines the default ticket next state after adding a phone note in the ticket phone outbound screen of the agent interface.' =>
            '',
        'Defines the default ticket order (after priority sort) in the escalation view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            '',
        'Defines the default ticket order (after priority sort) in the status view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            '',
        'Defines the default ticket order in the responsible view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            '',
        'Defines the default ticket order in the ticket locked view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            '',
        'Defines the default ticket order in the ticket search result of the agent interface. Up: oldest on top. Down: latest on top.' =>
            '',
        'Defines the default ticket order in the watch view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            '',
        'Defines the default ticket order of a search result in the customer interface. Up: oldest on top. Down: latest on top.' =>
            '',
        'Defines the default ticket priority in the close ticket screen of the agent interface.' =>
            '',
        'Defines the default ticket priority in the ticket bulk screen of the agent interface.' =>
            '',
        'Defines the default ticket priority in the ticket free text screen of the agent interface.' =>
            '',
        'Defines the default ticket priority in the ticket note screen of the agent interface.' =>
            '',
        'Defines the default ticket priority in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the default ticket priority in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the default ticket priority in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the default ticket priority in the ticket responsible screen of the agent interface.' =>
            '',
        'Defines the default ticket type for new customer tickets in the customer interface.' =>
            '',
        'Defines the default type for article in the customer interface.' =>
            '',
        'Defines the default type of forwarded message in the ticket forward screen of the agent interface.' =>
            '',
        'Defines the default type of the article for this operation.' => '',
        'Defines the default type of the note in the close ticket screen of the agent interface.' =>
            '',
        'Defines the default type of the note in the ticket bulk screen of the agent interface.' =>
            '',
        'Defines the default type of the note in the ticket free text screen of the agent interface.' =>
            '',
        'Defines the default type of the note in the ticket note screen of the agent interface.' =>
            '',
        'Defines the default type of the note in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the default type of the note in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the default type of the note in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Defines the default type of the note in the ticket phone outbound screen of the agent interface.' =>
            '',
        'Defines the default type of the note in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the default type of the note in the ticket responsible screen of the agent interface.' =>
            '',
        'Defines the default type of the note in the ticket zoom screen of the customer interface.' =>
            '',
        'Defines the default used Frontend-Module if no Action parameter given in the url on the agent interface.' =>
            '',
        'Defines the default used Frontend-Module if no Action parameter given in the url on the customer interface.' =>
            '',
        'Defines the default value for the action parameter for the public frontend. The action parameter is used in the scripts of the system.' =>
            '',
        'Defines the default viewable sender types of a ticket (default: customer).' =>
            '',
        'Defines the filter that processes the text in the articles, in order to highlight URLs.' =>
            '',
        'Defines the format of responses in the ticket compose screen of the agent interface ($QData{"OrigFrom"} is From 1:1, $QData{"OrigFromName"} is only realname of From).' =>
            '',
        'Defines the fully qualified domain name of the system. This setting is used as a variable, OTRS_CONFIG_FQDN which is found in all forms of messaging used by the application, to build links to the tickets within your system.' =>
            '',
        'Defines the groups every customer user will be in (if CustomerGroupSupport is enabled and you don\'t want to manage every user for these groups).' =>
            '',
        'Defines the height for the rich text editor component for this screen. Enter number (pixels) or percent value (relative).' =>
            '',
        'Defines the height for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            '',
        'Defines the height of the legend.' => '',
        'Defines the history comment for the close ticket screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the email ticket screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the phone ticket screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the ticket free text screen action, which gets used for ticket history.' =>
            '',
        'Defines the history comment for the ticket note screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the ticket owner screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the ticket pending screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the ticket phone inbound screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the ticket phone outbound screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the ticket priority screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the ticket responsible screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the ticket zoom action, which gets used for ticket history in the customer interface.' =>
            '',
        'Defines the history comment for this operation, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the close ticket screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the email ticket screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the phone ticket screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the ticket free text screen action, which gets used for ticket history.' =>
            '',
        'Defines the history type for the ticket note screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the ticket owner screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the ticket pending screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the ticket phone inbound screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the ticket phone outbound screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the ticket priority screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the ticket responsible screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the ticket zoom action, which gets used for ticket history in the customer interface.' =>
            '',
        'Defines the history type for this operation, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the hours and week days of the indicated calendar, to count the working time.' =>
            '',
        'Defines the hours and week days to count the working time.' => '',
        'Defines the key to be checked with Kernel::Modules::AgentInfo module. If this user preferences key is true, the message is accepted by the system.' =>
            '',
        'Defines the key to check with CustomerAccept. If this user preferences key is true, then the message is accepted by the system.' =>
            '',
        'Defines the link type \'Normal\'. If the source name and the target name contain the same value, the resulting link is a non-directional one; otherwise, the result is a directional link.' =>
            '',
        'Defines the link type \'ParentChild\'. If the source name and the target name contain the same value, the resulting link is a non-directional one; otherwise, the result is a directional link.' =>
            '',
        'Defines the link type groups. The link types of the same group cancel one another. Example: If ticket A is linked per a \'Normal\' link with ticket B, then these tickets could not be additionally linked with link of a \'ParentChild\' relationship.' =>
            '',
        'Defines the list of online repositories. Another installations can be used as repository, for example: Key="http://example.com/otrs/public.pl?Action=PublicRepository;File=" and Content="Some Name".' =>
            '',
        'Defines the location to get online repository list for additional packages. The first available result will be used.' =>
            '',
        'Defines the log module for the system. "File" writes all messages in a given logfile, "SysLog" uses the syslog daemon of the system, e.g. syslogd.' =>
            '',
        'Defines the maximal size (in bytes) for file uploads via the browser.' =>
            '',
        'Defines the maximal valid time (in seconds) for a session id.' =>
            '',
        'Defines the maximum length (in characters) for a scheduler task data. WARNING: Do not modify this setting unless you are sure of the current Database length for \'task_data\' filed from \'scheduler_data_list\' table.' =>
            '',
        'Defines the maximum number of pages per PDF file.' => '',
        'Defines the maximum size (in MB) of the log file.' => '',
        'Defines the module that shows a generic notification in the agent interface. Either "Text" - if configured - or the contents of "File" will be displayed.' =>
            '',
        'Defines the module that shows all the currently loged in customers in the agent interface.' =>
            '',
        'Defines the module that shows all the currently logged in agents in the agent interface.' =>
            '',
        'Defines the module that shows the currently loged in agents in the customer interface.' =>
            '',
        'Defines the module that shows the currently loged in customers in the customer interface.' =>
            '',
        'Defines the module to authenticate customers.' => '',
        'Defines the module to display a notification in the agent interface, (only for agents on the admin group) if the scheduler is not running.' =>
            '',
        'Defines the module to display a notification in the agent interface, if the agent is logged in while having out-of-office active.' =>
            '',
        'Defines the module to display a notification in the agent interface, if the system is used by the admin user (normally you shouldn\'t work as admin).' =>
            '',
        'Defines the module to generate html refresh headers of html sites, in the customer interface.' =>
            '',
        'Defines the module to generate html refresh headers of html sites.' =>
            '',
        'Defines the module to send emails. "Sendmail" directly uses the sendmail binary of your operating system. Any of the "SMTP" mechanisms use a specified (external) mailserver. "DoNotSendEmail" doesn\'t send emails and it is useful for test systems.' =>
            '',
        'Defines the module used to store the session data. With "DB" the frontend server can be splitted from the db server. "FS" is faster.' =>
            '',
        'Defines the name of the application, shown in the web interface, tabs and title bar of the web browser.' =>
            '',
        'Defines the name of the column to store the data in the preferences table.' =>
            '',
        'Defines the name of the column to store the user identifier in the preferences table.' =>
            '',
        'Defines the name of the indicated calendar.' => '',
        'Defines the name of the key for customer sessions.' => '',
        'Defines the name of the session key. E.g. Session, SessionID or OTRS.' =>
            '',
        'Defines the name of the table, where the customer preferences are stored.' =>
            '',
        'Defines the next possible states after composing / answering a ticket in the ticket compose screen of the agent interface.' =>
            '',
        'Defines the next possible states after forwarding a ticket in the ticket forward screen of the agent interface.' =>
            '',
        'Defines the next possible states for customer tickets in the customer interface.' =>
            '',
        'Defines the next state of a ticket after adding a note, in the close ticket screen of the agent interface.' =>
            '',
        'Defines the next state of a ticket after adding a note, in the ticket bulk screen of the agent interface.' =>
            '',
        'Defines the next state of a ticket after adding a note, in the ticket free text screen of the agent interface.' =>
            '',
        'Defines the next state of a ticket after adding a note, in the ticket note screen of the agent interface.' =>
            '',
        'Defines the next state of a ticket after adding a note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the next state of a ticket after adding a note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the next state of a ticket after adding a note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the next state of a ticket after adding a note, in the ticket responsible screen of the agent interface.' =>
            '',
        'Defines the next state of a ticket after being bounced, in the ticket bounce screen of the agent interface.' =>
            '',
        'Defines the next state of a ticket after being moved to another queue, in the move ticket screen of the agent interface.' =>
            '',
        'Defines the parameters for the customer preferences table.' => '',
        'Defines the parameters for the dashboard backend. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin.' =>
            '',
        'Defines the parameters for the dashboard backend. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" defines the cache expiration period in minutes for the plugin.' =>
            '',
        'Defines the parameters for the dashboard backend. "Limit" defines the number of entries displayed by default. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin.' =>
            '',
        'Defines the parameters for the dashboard backend. "Limit" defines the number of entries displayed by default. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" defines the cache expiration period in minutes for the plugin.' =>
            '',
        'Defines the password to access the SOAP handle (bin/cgi-bin/rpc.pl).' =>
            '',
        'Defines the path and TTF-File to handle bold italic monospaced font in PDF documents.' =>
            '',
        'Defines the path and TTF-File to handle bold italic proportional font in PDF documents.' =>
            '',
        'Defines the path and TTF-File to handle bold monospaced font in PDF documents.' =>
            '',
        'Defines the path and TTF-File to handle bold proportional font in PDF documents.' =>
            '',
        'Defines the path and TTF-File to handle italic monospaced font in PDF documents.' =>
            '',
        'Defines the path and TTF-File to handle italic proportional font in PDF documents.' =>
            '',
        'Defines the path and TTF-File to handle monospaced font in PDF documents.' =>
            '',
        'Defines the path and TTF-File to handle proportional font in PDF documents.' =>
            '',
        'Defines the path for scheduler to store its console output (SchedulerOUT.log and SchedulerERR.log).' =>
            '',
        'Defines the path of the shown info file, that is located under Kernel/Output/HTML/Standard/CustomerAccept.dtl.' =>
            '',
        'Defines the path to PGP binary.' => '',
        'Defines the path to open ssl binary. It may need a HOME env ($ENV{HOME} = \'/var/lib/wwwrun\';).' =>
            '',
        'Defines the placement of the legend. This should be a two letter key of the form: \'B[LCR]|R[TCB]\'. The first letter indicates the placement (Bottom or Right), and the second letter the alignment (Left, Right, Center, Top, or Bottom).' =>
            '',
        'Defines the postmaster default queue.' => '',
        'Defines the receipent target of the phone ticket and the sender of the email ticket ("Queue" shows all queues, "SystemAddress" displays all system addresses) in the agent interface.' =>
            '',
        'Defines the receipent target of the tickets ("Queue" shows all queues, "SystemAddress" displays all system addresses) in the customer interface.' =>
            '',
        'Defines the required permission to show a ticket in the escalation view of the agent interface.' =>
            '',
        'Defines the search limit for the stats.' => '',
        'Defines the sender for rejected emails.' => '',
        'Defines the separator between the agents real name and the given queue email address.' =>
            '',
        'Defines the spacing of the legends.' => '',
        'Defines the standard permissions available for customers within the application. If more permissions are needed, you can enter them here. Permissions must be hard coded to be effective. Please ensure, when adding any of the afore mentioned permissions, that the "rw" permission remains the last entry.' =>
            '',
        'Defines the standard size of PDF pages.' => '',
        'Defines the state of a ticket if it gets a follow-up and the ticket was already closed.' =>
            '',
        'Defines the state of a ticket if it gets a follow-up.' => '',
        'Defines the state type of the reminder for pending tickets.' => '',
        'Defines the subject for notification mails sent to agents, about new password.' =>
            '',
        'Defines the subject for notification mails sent to agents, with token about new requested password.' =>
            '',
        'Defines the subject for notification mails sent to customers, about new account.' =>
            '',
        'Defines the subject for notification mails sent to customers, about new password.' =>
            '',
        'Defines the subject for notification mails sent to customers, with token about new requested password.' =>
            '',
        'Defines the subject for rejected emails.' => '',
        'Defines the system administrator\'s email address. It will be displayed in the error screens of the application.' =>
            '',
        'Defines the system identifier. Every ticket number and http session string contain this ID. This ensures that only tickets which belong to your system will be processed as follow-ups (useful when communicating between two instances of OTRS).' =>
            '',
        'Defines the target attribute in the link to external customer database. E.g. \'AsPopup PopupType_TicketAction\'.' =>
            '',
        'Defines the target attribute in the link to external customer database. E.g. \'target="cdb"\'.' =>
            '',
        'Defines the time in days to keep log backup files.' => '',
        'Defines the time in seconds after which the Scheduler performs an automatic self-restart.' =>
            '',
        'Defines the time zone of the indicated calendar, which can be assigned later to a specific queue.' =>
            '',
        'Defines the type of protocol, used by ther web server, to serve the application. If https protocol will be used instead of plain http, it must be specified it here. Since this has no affect on the web server\'s settings or behavior, it will not change the method of access to the application and, if it is wrong, it will not prevent you from logging into the application. This setting is used as a variable, OTRS_CONFIG_HttpType which is found in all forms of messaging used by the application, to build links to the tickets within your system.' =>
            '',
        'Defines the used character for email quotes in the ticket compose screen of the agent interface.' =>
            '',
        'Defines the user identifier for the customer panel.' => '',
        'Defines the username to access the SOAP handle (bin/cgi-bin/rpc.pl).' =>
            '',
        'Defines the valid state types for a ticket.' => '',
        'Defines the valid states for unlocked tickets. To unlock tickets the script "bin/otrs.UnlockTickets.pl" can be used.' =>
            '',
        'Defines the viewable locks of a ticket. Default: unlock, tmp_lock.' =>
            '',
        'Defines the width for the rich text editor component for this screen. Enter number (pixels) or percent value (relative).' =>
            '',
        'Defines the width for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            '',
        'Defines the width of the legend.' => '',
        'Defines which article sender types should be shown in the preview of a ticket.' =>
            '',
        'Defines which states should be set automatically (Content), after the pending time of state (Key) has been reached.' =>
            '',
        'Defines wich article type should be expanded when entering the overview. If nothing defined, latest article will be expanded.' =>
            '',
        'Delay time between autocomplete queries in milliseconds.' => '',
        'Deletes a session if the session id is used with an invalid remote IP address.' =>
            '',
        'Deletes requested sessions if they have timed out.' => '',
        'Determines if the list of possible queues to move to ticket into should be displayed in a dropdown list or in a new window in the agent interface. If "New Window" is set you can add a move note to the ticket.' =>
            '',
        'Determines if the search results container for the autocomplete feature should adjust its width dynamically.' =>
            '',
        'Determines if the statistics module may generate ticket lists.' =>
            '',
        'Determines the next possible ticket states, after the creation of a new email ticket in the agent interface.' =>
            '',
        'Determines the next possible ticket states, after the creation of a new phone ticket in the agent interface.' =>
            '',
        'Determines the next possible ticket states, for process tickets in the agent interface.' =>
            '',
        'Determines the next screen after new customer ticket in the customer interface.' =>
            '',
        'Determines the next screen after the follow up screen of a zoomed ticket in the customer interface.' =>
            '',
        'Determines the next screen after the ticket is moved. LastScreenOverview will return to search results, queueview, dashboard or the like, LastScreenView will return to TicketZoom.' =>
            '',
        'Determines the possible states for pending tickets that changed state after reaching time limit.' =>
            '',
        'Determines the strings that will be shown as receipent (To:) of the phone ticket and as sender (From:) of the email ticket in the agent interface. For Queue as NewQueueSelectionType "<Queue>" shows the names of the queues and for SystemAddress "<Realname> <<Email>>" shows the name and email of the receipent.' =>
            '',
        'Determines the strings that will be shown as receipent (To:) of the ticket in the customer interface. For Queue as CustomerPanelSelectionType, "<Queue>" shows the names of the queues, and for SystemAddress, "<Realname> <<Email>>" shows the name and email of the receipent.' =>
            '',
        'Determines the way the linked objects are displayed in each zoom mask.' =>
            '',
        'Determines which options will be valid of the recepient (phone ticket) and the sender (email ticket) in the agent interface.' =>
            '',
        'Determines which queues will be valid for ticket\'s recepients in the customer interface.' =>
            '',
        'Disables sending reminder notifications to the responsible agent of a ticket (Ticket::Responsible needs to be activated).' =>
            '',
        'Disables the web installer (http://yourhost.example.com/otrs/installer.pl), to prevent the system from being hijacked. If set to "No", the system can be reinstalled and the current basic configuration will be used to pre-populate the questions within the installer script. If not active, it also disables the GenericAgent, PackageManager and SQL Box.' =>
            '',
        'Display settings to override defaults for Process Tickets.' => '',
        'Displays the accounted time for an article in the ticket zoom view.' =>
            '',
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
        'Email Addresses' => 'El. pašto adresai',
        'Enables PDF output. The CPAN module PDF::API2 is required, if not installed, PDF output will be disabled.' =>
            '',
        'Enables PGP support. When PGP support is enabled for signing and securing mail, it is HIGHLY recommended that the web server be run as the OTRS user. Otherwise, there will be problems with the privileges when accessing .gnupg folder.' =>
            '',
        'Enables S/MIME support.' => 'Aktyvuoja S/MIME palaikymą.',
        'Enables customers to create their own accounts.' => '',
        'Enables file upload in the package manager frontend.' => '',
        'Enables or disable the debug mode over frontend interface.' => '',
        'Enables or disables the autocomplete feature for the customer search in the agent interface.' =>
            '',
        'Enables or disables the ticket watcher feature, to keep track of tickets without being the owner nor the responsible.' =>
            '',
        'Enables performance log (to log the page response time). It will affect the system performance. Frontend::Module###AdminPerformanceLog must be enabled.' =>
            '',
        'Enables spell checker support.' => '',
        'Enables ticket bulk action feature for the agent frontend to work on more than one ticket at a time.' =>
            '',
        'Enables ticket bulk action feature only for the listed groups.' =>
            '',
        'Enables ticket responsible feature, to keep track of a specific ticket.' =>
            '',
        'Enables ticket watcher feature only for the listed groups.' => '',
        'Escalation view' => 'Eskalacijų peržiūra',
        'Event list to be displayed on GUI to trigger generic interface invokers.' =>
            '',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate).' =>
            '',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate). This is only possible if all Ticket dynamic fields need the same event.' =>
            '',
        'Execute SQL statements.' => 'Vykdyti SQL sakinius',
        'Executes follow up checks on In-Reply-To or References headers for mails that don\'t have a ticket number in the subject.' =>
            '',
        'Executes follow up mail attachments checks in  mails that don\'t have a ticket number in the subject.' =>
            '',
        'Executes follow up mail body checks in mails that don\'t have a ticket number in the subject.' =>
            '',
        'Executes follow up plain/raw mail checks in mails that don\'t have a ticket number in the subject.' =>
            '',
        'Exports the whole article tree in search result (it can affect the system performance).' =>
            '',
        'Fetches packages via proxy. Overwrites "WebUserAgent::Proxy".' =>
            '',
        'File that is displayed in the Kernel::Modules::AgentInfo module, if located under Kernel/Output/HTML/Standard/AgentInfo.dtl.' =>
            '',
        'Filter incoming emails.' => 'Filtruoti įeinančius laiškus.',
        'FirstLock' => '',
        'FirstResponse' => '',
        'FirstResponseDiffInMin' => '',
        'FirstResponseInMin' => '',
        'Forces encoding of outgoing emails (7bit|8bit|quoted-printable|base64).' =>
            '',
        'Forces to choose a different ticket state (from current) after lock action. Define the current state as key, and the next state after lock action as content.' =>
            '',
        'Forces to unlock tickets after being moved to another queue.' =>
            '',
        'Frontend language' => 'Sąsajos kalba',
        'Frontend module registration (disable company link if no company feature is used).' =>
            '',
        'Frontend module registration (disable ticket processes screen if no process available).' =>
            '',
        'Frontend module registration for the agent interface.' => '',
        'Frontend module registration for the customer interface.' => '',
        'Frontend theme' => 'Sąsajos tema (Išvaizda)',
        'Fulltext index regex filters to remove parts of the text.' => '',
        'GenericAgent' => 'Bendrinis agentas (generic agent)',
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
            '',
        'Grants access, if the customer ID of the ticket matches the customer user\'s ID and the customer user has group permissions on the queue the ticket is in.' =>
            '',
        'Helps to extend your articles full-text search (From, To, Cc, Subject and Body search). Runtime will do full-text searches on live data (it works fine for up to 50.000 tickets). StaticDB will strip all articles and will build an index after article creation, increasing fulltext searches about 50%. To create an initial index use "bin/otrs.RebuildFulltextIndex.pl".' =>
            '',
        'If "DB" was selected for Customer::AuthModule, a database driver (normally autodetection is used) can be specified.' =>
            '',
        'If "DB" was selected for Customer::AuthModule, a password to connect to the customer table can be specified.' =>
            '',
        'If "DB" was selected for Customer::AuthModule, a username to connect to the customer table can be specified.' =>
            '',
        'If "DB" was selected for Customer::AuthModule, the DSN for the connection to the customer table must be specified.' =>
            '',
        'If "DB" was selected for Customer::AuthModule, the column name for the CustomerPassword in the customer table must be specified.' =>
            '',
        'If "DB" was selected for Customer::AuthModule, the crypt type of passwords must be specified.' =>
            '',
        'If "DB" was selected for Customer::AuthModule, the name of the column for the CustomerKey in the customer table must be specified.' =>
            '',
        'If "DB" was selected for Customer::AuthModule, the name of the table where your customer data should be stored must be specified.' =>
            '',
        'If "DB" was selected for SessionModule, a table in database where session data will be stored must be specified.' =>
            '',
        'If "FS" was selected for SessionModule, a directory where the session data will be stored must be specified.' =>
            '',
        'If "HTTPBasicAuth" was selected for Customer::AuthModule, you can specify (by using a RegExp) to strip parts of REMOTE_USER (e. g. for to remove trailing domains). RegExp-Note, $1 will be the new Login.' =>
            '',
        'If "HTTPBasicAuth" was selected for Customer::AuthModule, you can specify to strip leading parts of user names (e. g. for domains like example_domain\user to user).' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule and if you want to add a suffix to every customer login name, specifiy it here, e. g. you just want to write the username user but in your LDAP directory exists user@domain.' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule and special paramaters are needed for the Net::LDAP perl module, you can specify them here. See "perldoc Net::LDAP" for more information about the parameters.' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule and your users have only anonymous access to the LDAP tree, but you want to search through the data, you can do this with a user who has access to the LDAP directory. Specify the password for this special user here.' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule and your users have only anonymous access to the LDAP tree, but you want to search through the data, you can do this with a user who has access to the LDAP directory. Specify the username for this special user here.' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule, the BaseDN must be specified.' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule, the LDAP host can be specified.' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule, the user identifier must be specified.' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule, user attributes can be specified. For LDAP posixGroups use UID, for non LDAP posixGroups use full user DN.' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule, you can specify access attributes here.' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule, you can specify if the applications will stop if e. g. a connection to a server can\'t be established due to network problems.' =>
            '',
        'If "LDAP" was selected for Customer::Authmodule, you can check if the user is allowed to authenticate because he is in a posixGroup, e.g. user needs to be in a group xyz to use OTRS. Specify the group, who may access the system.' =>
            '',
        'If "LDAP" was selected, you can add a filter to each LDAP query, e.g. (mail=*), (objectclass=user) or (!objectclass=computer).' =>
            '',
        'If "Radius" was selected for Customer::AuthModule, the password to authenticate to the radius host must be specified.' =>
            '',
        'If "Radius" was selected for Customer::AuthModule, the radius host must be specified.' =>
            '',
        'If "Radius" was selected for Customer::AuthModule, you can specify if the applications will stop if e. g. a connection to a server can\'t be established due to network problems.' =>
            '',
        'If "Sendmail" was selected as SendmailModule, the location of the sendmail binary and the needed options must be specified.' =>
            '',
        'If "SysLog" was selected for LogModule, a special log facility can be specified.' =>
            '',
        'If "SysLog" was selected for LogModule, a special log sock can be specified (on solaris you may need to use \'stream\').' =>
            '',
        'If "SysLog" was selected for LogModule, the charset that should be used for logging can be specified.' =>
            '',
        'If "file" was selected for LogModule, a logfile must be specified. If the file doesn\'t exist, it will be created by the system.' =>
            '',
        'If a note is added by an agent, sets the state of a ticket in the close ticket screen of the agent interface.' =>
            '',
        'If a note is added by an agent, sets the state of a ticket in the ticket bulk screen of the agent interface.' =>
            '',
        'If a note is added by an agent, sets the state of a ticket in the ticket free text screen of the agent interface.' =>
            '',
        'If a note is added by an agent, sets the state of a ticket in the ticket note screen of the agent interface.' =>
            '',
        'If a note is added by an agent, sets the state of a ticket in the ticket responsible screen of the agent interface.' =>
            '',
        'If a note is added by an agent, sets the state of the ticket in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'If a note is added by an agent, sets the state of the ticket in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'If a note is added by an agent, sets the state of the ticket in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, and authentication to the mail server is needed, a password must be specified.' =>
            '',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, and authentication to the mail server is needed, an username must be specified.' =>
            '',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, the mailhost that sends out the mails must be specified.' =>
            '',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, the port where your mailserver is listening for incoming connections must be specified.' =>
            '',
        'If enabled, OTRS will deliver all CSS files in minified form. WARNING: If you turn this off, there will likely be problems in IE 7, because it cannot load more than 32 CSS files.' =>
            '',
        'If enabled, OTRS will deliver all JavaScript files in minified form.' =>
            '',
        'If enabled, TicketPhone and TicketEmail will be open in new windows.' =>
            '',
        'If enabled, the OTRS version tag will be removed from the HTTP headers.' =>
            '',
        'If enabled, the different overviews (Dashboard, LockedView, QueueView) will automatically refresh after the specified time.' =>
            '',
        'If enabled, the first level of the main menu opens on mouse hover (instead of click only).' =>
            '',
        'If set, this address is used as envelope sender header in outgoing notifications. If no address is specified, the envelope sender header is empty.' =>
            '',
        'If this regex matches, no message will be send by the autoresponder.' =>
            '',
        'If you want to use a mirror database for agent ticket fulltext search or to generate stats, specify the DSN to this database.' =>
            '',
        'If you want to use a mirror database for agent ticket fulltext search or to generate stats, the password to authenticate to this database can be specified.' =>
            '',
        'If you want to use a mirror database for agent ticket fulltext search or to generate stats, the user to authenticate to this database can be specified.' =>
            '',
        'Ignore article with system sender type for new article feature (e. g. auto responses or email notifications).' =>
            '',
        'Includes article create times in the ticket search of the agent interface.' =>
            '',
        'IndexAccelerator: to choose your backend TicketViewAccelerator module. "RuntimeDB" generates each queue view on the fly from ticket table (no performance problems up to approx. 60.000 tickets in total and 6.000 open tickets in the system). "StaticDB" is the most powerful module, it uses an extra ticket-index table that works like a view (recommended if more than 80.000 and 6.000 open tickets are stored in the system). Use the script "bin/otrs.RebuildTicketIndex.pl" for initial index update.' =>
            '',
        'Install ispell or aspell on the system, if you want to use a spell checker. Please specify the path to the aspell or ispell binary on your operating system.' =>
            '',
        'Interface language' => 'Sąsajos kalba',
        'It is possible to configure different skins, for example to distinguish between diferent agents, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            '',
        'It is possible to configure different skins, for example to distinguish between diferent customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            '',
        'It is possible to configure different themes, for example to distinguish between agents and customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid theme on your system. Please see the example entries for the proper form of the regex.' =>
            '',
        'Link agents to groups.' => 'Susieti agentus su grupėmis.',
        'Link agents to roles.' => 'Susieti agentus su rolėmis.',
        'Link attachments to responses templates.' => 'Susieti laiškų priedus su atsakymų šablonais.',
        'Link customers to groups.' => 'Susieti klientus su grupėmis.',
        'Link customers to services.' => 'Susieti klientus su paslaugomis(services).',
        'Link queues to auto responses.' => 'Susieti eiles su automatiniais atsakymais.',
        'Link responses to queues.' => 'Susieti atsakymus su eilėmis.',
        'Link roles to groups.' => 'Susieti roles su grupėmis.',
        'Links 2 tickets with a "Normal" type link.' => '',
        'Links 2 tickets with a "ParentChild" type link.' => '',
        'List of CSS files to always be loaded for the agent interface.' =>
            '',
        'List of CSS files to always be loaded for the customer interface.' =>
            '',
        'List of IE7-specific CSS files to always be loaded for the customer interface.' =>
            '',
        'List of IE8-specific CSS files to always be loaded for the agent interface.' =>
            '',
        'List of IE8-specific CSS files to always be loaded for the customer interface.' =>
            '',
        'List of JS files to always be loaded for the agent interface.' =>
            '',
        'List of JS files to always be loaded for the customer interface.' =>
            '',
        'List of default StandardResponses which are assigned automatically to new Queues upon creation.' =>
            '',
        'Log file for the ticket counter.' => '',
        'Mail Accounts' => '',
        'Main menu registration.' => '',
        'Makes the application check the MX record of email addresses before sending an email or submitting a telephone or email ticket.' =>
            '',
        'Makes the application check the syntax of email addresses.' => '',
        'Makes the picture transparent.' => '',
        'Makes the session management use html cookies. If html cookies are disabled or if the client browser disabled html cookies, then the system will work as usual and append the session id to the links.' =>
            '',
        'Manage PGP keys for email encryption.' => 'Valdyti PGP raktus el. laiškų šifravimui.',
        'Manage POP3 or IMAP accounts to fetch email from.' => 'Valdyti POP3 arba IMAP paskyras laiškams gauti.',
        'Manage S/MIME certificates for email encryption.' => 'Valdyti S/MIME sertifikatus el. laiškų šifravimui.',
        'Manage existing sessions.' => 'Valdyti esamas sesijas.',
        'Manage notifications that are sent to agents.' => '',
        'Manage periodic tasks.' => 'Valdyti periodines užduotis.',
        'Max size (in characters) of the customer information table (phone and email) in the compose screen.' =>
            '',
        'Max size (in rows) of the informed agents box in the agent interface.' =>
            '',
        'Max size (in rows) of the involved agents box in the agent interface.' =>
            '',
        'Max size of the subjects in an email reply.' => '',
        'Maximal auto email responses to own email-address a day (Loop-Protection).' =>
            '',
        'Maximal size in KBytes for mails that can be fetched via POP3/POP3S/IMAP/IMAPS (KBytes).' =>
            '',
        'Maximum number of tickets to be displayed in the result of a search in the agent interface.' =>
            '',
        'Maximum number of tickets to be displayed in the result of a search in the customer interface.' =>
            '',
        'Maximum size (in characters) of the customer information table in the ticket zoom view.' =>
            '',
        'Module for To-selection in new ticket screen in the customer interface.' =>
            '',
        'Module to check customer permissions.' => '',
        'Module to check if a user is in a special group. Access is granted, if the user is in the specified group and has ro and rw permissions.' =>
            '',
        'Module to check if arrived emails should be marked as email-internal (because of original forwared internal email it college). ArticleType and SenderType define the values for the arrived email/article.' =>
            '',
        'Module to check the agent responsible of a ticket.' => '',
        'Module to check the group permissions for the access to customer tickets.' =>
            '',
        'Module to check the owner of a ticket.' => '',
        'Module to check the watcher agents of a ticket.' => '',
        'Module to compose signed messages (PGP or S/MIME).' => '',
        'Module to crypt composed messages (PGP or S/MIME).' => '',
        'Module to filter and manipulate incoming messages. Block/ignore all spam email with From: noreply@ address.' =>
            '',
        'Module to filter and manipulate incoming messages. Get a 4 digit number to ticket free text, use regex in Match e. g. From => \'(.+?)@.+?\', and use () as [***] in Set =>.' =>
            '',
        'Module to generate accounted time ticket statistics.' => '',
        'Module to generate html OpenSearch profile for short ticket search in the agent interface.' =>
            '',
        'Module to generate html OpenSearch profile for short ticket search in the customer interface.' =>
            '',
        'Module to generate ticket solution and response time statistics.' =>
            '',
        'Module to generate ticket statistics.' => '',
        'Module to show notifications and escalations (ShownMax: max. shown escalations, EscalationInMinutes: Show ticket which will escalation in, CacheTime: Cache of calculated escalations in seconds).' =>
            '',
        'Module to use database filter storage.' => '',
        'Multiselect' => '',
        'My Tickets' => 'Mano triktys',
        'Name of custom queue. The custom queue is a queue selection of your preferred queues and can be selected in the preferences settings.' =>
            '',
        'NameX' => '',
        'New email ticket' => 'Naujas panešimas el. paštu',
        'New phone ticket' => 'Naujas panešimas telefonu',
        'New process ticket' => '',
        'Next possible ticket states after adding a phone note in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Next possible ticket states after adding a phone note in the ticket phone outbound screen of the agent interface.' =>
            '',
        'Notifications (Event)' => 'Pranešimai (įvykių)',
        'Number of displayed tickets' => 'Rodomų trikčių skaičius',
        'Number of lines (per ticket) that are shown by the search utility in the agent interface.' =>
            '',
        'Number of tickets to be displayed in each page of a search result in the agent interface.' =>
            '',
        'Number of tickets to be displayed in each page of a search result in the customer interface.' =>
            '',
        'Open tickets of customer' => '',
        'Overloads (redefines) existing functions in Kernel::System::Ticket. Used to easily add customizations.' =>
            '',
        'Overview Escalated Tickets' => 'Peržiūrėti eskaluotas triktis',
        'Overview Refresh Time' => '',
        'Overview of all open Tickets.' => 'Peržiūrėti visas atviras triktis.',
        'PGP Key Management' => '',
        'PGP Key Upload' => 'Įkelti PGP raktą',
        'Parameters for the CreateNextMask object in the preference view of the agent interface.' =>
            '',
        'Parameters for the CustomQueue object in the preference view of the agent interface.' =>
            '',
        'Parameters for the FollowUpNotify object in the preference view of the agent interface.' =>
            '',
        'Parameters for the LockTimeoutNotify object in the preference view of the agent interface.' =>
            '',
        'Parameters for the MoveNotify object in the preference view of the agent interface.' =>
            '',
        'Parameters for the NewTicketNotify object in the preferences view of the agent interface.' =>
            '',
        'Parameters for the RefreshTime object in the preference view of the agent interface.' =>
            '',
        'Parameters for the WatcherNotify object in the preference view of the agent interface.' =>
            '',
        'Parameters for the dashboard backend of the customer company information of the agent interface . "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the customer id status widget of the agent interface . "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the customer user list overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the new tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the ticket calendar of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the ticket escalation overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the ticket pending reminder overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the ticket pending reminder overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the ticket stats of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the pages (in which the dynamic fields are shown) of the dynamic fields overview.' =>
            '',
        'Parameters for the pages (in which the tickets are shown) of the medium ticket overview.' =>
            '',
        'Parameters for the pages (in which the tickets are shown) of the small ticket overview.' =>
            '',
        'Parameters for the pages (in which the tickets are shown) of the ticket preview overview.' =>
            '',
        'Parameters of the example SLA attribute Comment2.' => '',
        'Parameters of the example queue attribute Comment2.' => '',
        'Parameters of the example service attribute Comment2.' => '',
        'Path for the log file (it only applies if "FS" was selected for LoopProtectionModule and it is mandatory).' =>
            '',
        'Path of the file that stores all the settings for the QueueObject object for the agent interface.' =>
            '',
        'Path of the file that stores all the settings for the QueueObject object for the customer interface.' =>
            '',
        'Path of the file that stores all the settings for the TicketObject for the agent interface.' =>
            '',
        'Path of the file that stores all the settings for the TicketObject for the customer interface.' =>
            '',
        'Performs the configured action for each event (as an Invoker) for each configured Webservice.' =>
            '',
        'Permitted width for compose email windows.' => '',
        'Permitted width for compose note windows.' => '',
        'Picture-Upload' => '',
        'PostMaster Filters' => 'PostMaster filtrai',
        'PostMaster Mail Accounts' => 'PostMaster el. pašto paskyros',
        'Process Information' => '',
        'Process Management Activity Dialog GUI' => '',
        'Process Management Activity GUI' => '',
        'Process Management Path GUI' => '',
        'Process Management Transition Action GUI' => '',
        'Process Management Transition GUI' => '',
        'Protection against CSRF (Cross Site Request Forgery) exploits (for more info see http://en.wikipedia.org/wiki/Cross-site_request_forgery).' =>
            '',
        'Queue view' => 'Eilių peržiūra',
        'Refresh Overviews after' => '',
        'Refresh interval' => 'Atnaujinimo intervalas',
        'Removes the ticket watcher information when a ticket is archived.' =>
            '',
        'Replaces the original sender with current customer\'s email address on compose answer in the ticket compose screen of the agent interface.' =>
            '',
        'Required permissions to change the customer of a ticket in the agent interface.' =>
            '',
        'Required permissions to use the close ticket screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket bounce screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket compose screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket forward screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket free text screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket merge screen of a zoomed ticket in the agent interface.' =>
            '',
        'Required permissions to use the ticket note screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Required permissions to use the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Required permissions to use the ticket phone inbound screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket phone outbound screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Required permissions to use the ticket responsible screen in the agent interface.' =>
            '',
        'Resets and unlocks the owner of a ticket if it was moved to another queue.' =>
            '',
        'Responses <-> Queues' => 'Atsakymai <-> Eilės',
        'Restores a ticket from the archive (only if the event is a state change, from closed to any open available state).' =>
            '',
        'Roles <-> Groups' => 'Rolės <-> Grupės',
        'Runs an initial wildcard search of the existing customer users when accessing the AdminCustomerUser module.' =>
            '',
        'Runs the system in "Demo" mode. If set to "Yes", agents can change preferences, such as selection of language and theme via the agent web interface. These changes are only valid for the current session. It will not be possible for agents to change their passwords.' =>
            '',
        'S/MIME Certificate Upload' => 'Įkelti S/MIME sertifikatą',
        'Saves the attachments of articles. "DB" stores all data in the database (not recommended for storing big attachments). "FS" stores the data on the filesystem; this is faster but the webserver should run under the OTRS user. You can switch between the modules even on a system that is already in production without any loss of data.' =>
            '',
        'Search backend default router.' => '',
        'Search backend router.' => '',
        'Select your frontend Theme.' => 'Pasirinkite sąsajos temą (išvaizdą).',
        'Selects the cache backend to use.' => '',
        'Selects the module to handle uploads via the web interface. "DB" stores all uploads in the database, "FS" uses the file system.' =>
            '',
        'Selects the ticket number generator module. "AutoIncrement" increments the ticket number, the SystemID and the counter are used with SystemID.counter format (e.g. 1010138, 1010139). With "Date" the ticket numbers will be generated by the current date, the SystemID and the counter. The format looks like Year.Month.Day.SystemID.counter (e.g. 200206231010138, 200206231010139). With "DateChecksum"  the counter will be appended as checksum to the string of date and SystemID. The checksum will be rotated on a daily basis. The format looks like Year.Month.Day.SystemID.Counter.CheckSum (e.g. 2002070110101520, 2002070110101535). "Random" generates randomized ticket numbers in the format "SystemID.Random" (e.g. 100057866352, 103745394596).' =>
            '',
        'Send me a notification if a customer sends a follow up and I\'m the owner of the ticket or the ticket is unlocked and is in one of my subscribed queues.' =>
            'Siųsti man pranešimą jeigu klientas atsiunčia atsaką o aš esu trikties savininkas arba triktis yra atrakinta ir yra vienoje iš mano eilių.',
        'Send notifications to users.' => 'Siųsti pranešimus naudotojams.',
        'Send ticket follow up notifications' => 'Siųsti trikčių atsakymų (follow-up) pranešimus',
        'Sender type for new tickets from the customer inteface.' => '',
        'Sends agent follow-up notification only to the owner, if a ticket is unlocked (the default is to send the notification to all agents).' =>
            '',
        'Sends all outgoing email via bcc to the specified address. Please use this only for backup reasons.' =>
            '',
        'Sends customer notifications just to the mapped customer. Normally, if no customer is mapped, the latest customer sender gets the notification.' =>
            '',
        'Sends reminder notifications of unlocked ticket after reaching the reminder date (only sent to ticket owner).' =>
            '',
        'Sends the notifications which are configured in the admin interface under "Notfication (Event)".' =>
            '',
        'Set sender email addresses for this system.' => 'Nustatyti šiai sistemai el. pašto siuntėjo adresą.',
        'Set the default height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            '',
        'Set the maximum height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            '',
        'Set this to yes if you trust in all your public and private pgp keys, even if they are not certified with a trusted signature.' =>
            '',
        'Sets if ticket owner must be selected by the agent.' => '',
        'Sets the PendingTime of a ticket to 0 if the state is changed to a non-pending state.' =>
            '',
        'Sets the age in minutes (first level) for highlighting queues that contain untouched tickets.' =>
            '',
        'Sets the age in minutes (second level) for highlighting queues that contain untouched tickets.' =>
            '',
        'Sets the configuration level of the administrator. Depending on the config level, some sysconfig options will be not shown. The config levels are in in ascending order: Expert, Advanced, Beginner. The higher the config level is (e.g. Beginner is the highest), the less likely is it that the user can accidentally configure the system in a way that it is not usable any more.' =>
            '',
        'Sets the default article type for new email tickets in the agent interface.' =>
            '',
        'Sets the default article type for new phone tickets in the agent interface.' =>
            '',
        'Sets the default body text for notes added in the close ticket screen of the agent interface.' =>
            '',
        'Sets the default body text for notes added in the ticket move screen of the agent interface.' =>
            '',
        'Sets the default body text for notes added in the ticket note screen of the agent interface.' =>
            '',
        'Sets the default body text for notes added in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the default body text for notes added in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the default body text for notes added in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the default body text for notes added in the ticket responsible screen of the agent interface.' =>
            '',
        'Sets the default link type of splitted tickets in the agent interface.' =>
            '',
        'Sets the default next state for new phone tickets in the agent interface.' =>
            '',
        'Sets the default next ticket state, after the creation of an email ticket in the agent interface.' =>
            '',
        'Sets the default note text for new telephone tickets. E.g \'New ticket via call\' in the agent interface.' =>
            '',
        'Sets the default priority for new email tickets in the agent interface.' =>
            '',
        'Sets the default priority for new phone tickets in the agent interface.' =>
            '',
        'Sets the default sender type for new email tickets in the agent interface.' =>
            '',
        'Sets the default sender type for new phone ticket in the agent interface.' =>
            '',
        'Sets the default subject for new email tickets (e.g. \'email Outbound\') in the agent interface.' =>
            '',
        'Sets the default subject for new phone tickets (e.g. \'Phone call\') in the agent interface.' =>
            '',
        'Sets the default subject for notes added in the close ticket screen of the agent interface.' =>
            '',
        'Sets the default subject for notes added in the ticket move screen of the agent interface.' =>
            '',
        'Sets the default subject for notes added in the ticket note screen of the agent interface.' =>
            '',
        'Sets the default subject for notes added in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the default subject for notes added in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the default subject for notes added in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the default subject for notes added in the ticket responsible screen of the agent interface.' =>
            '',
        'Sets the default text for new email tickets in the agent interface.' =>
            '',
        'Sets the display order of the different items in the preferences view.' =>
            '',
        'Sets the inactivity time (in seconds) to pass before a session is killed and a user is loged out.' =>
            '',
        'Sets the maximum number of active agents within the timespan defined in SessionActiveTime.' =>
            '',
        'Sets the maximum number of active customers within the timespan defined in SessionActiveTime.' =>
            '',
        'Sets the minimal ticket counter size (if "AutoIncrement" was selected as TicketNumberGenerator). Default is 5, this means the counter starts from 10000.' =>
            '',
        'Sets the minimum number of characters before autocomplete query is sent.' =>
            '',
        'Sets the number of lines that are displayed in text messages (e.g. ticket lines in the QueueZoom).' =>
            '',
        'Sets the number of search results to be displayed for the autocomplete feature.' =>
            '',
        'Sets the options for PGP binary.' => '',
        'Sets the order of the different items in the customer preferences view.' =>
            '',
        'Sets the password for private PGP key.' => '',
        'Sets the prefered time units (e.g. work units, hours, minutes).' =>
            '',
        'Sets the prefix to the scripts folder on the server, as configured on the web server. This setting is used as a variable, OTRS_CONFIG_ScriptAlias which is found in all forms of messaging used by the application, to build links to the tickets within the system.' =>
            '',
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
            '',
        'Sets the responsible agent of the ticket in the ticket bulk screen of the agent interface.' =>
            '',
        'Sets the responsible agent of the ticket in the ticket free text screen of the agent interface.' =>
            '',
        'Sets the responsible agent of the ticket in the ticket note screen of the agent interface.' =>
            '',
        'Sets the responsible agent of the ticket in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the responsible agent of the ticket in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the responsible agent of the ticket in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the responsible agent of the ticket in the ticket responsible screen of the agent interface.' =>
            '',
        'Sets the service in the close ticket screen of the agent interface (Ticket::Service needs to be activated).' =>
            '',
        'Sets the service in the ticket free text screen of the agent interface (Ticket::Service needs to be activated).' =>
            '',
        'Sets the service in the ticket note screen of the agent interface (Ticket::Service needs to be activated).' =>
            '',
        'Sets the service in the ticket owner screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).' =>
            '',
        'Sets the service in the ticket pending screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).' =>
            '',
        'Sets the service in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).' =>
            '',
        'Sets the service in the ticket responsible screen of the agent interface (Ticket::Service needs to be activated).' =>
            '',
        'Sets the size of the statistic graph.' => '',
        'Sets the stats hook.' => '',
        'Sets the system time zone (required a system with UTC as system time). Otherwise this is a diff time to the local time.' =>
            '',
        'Sets the ticket owner in the close ticket screen of the agent interface.' =>
            '',
        'Sets the ticket owner in the ticket bulk screen of the agent interface.' =>
            '',
        'Sets the ticket owner in the ticket free text screen of the agent interface.' =>
            '',
        'Sets the ticket owner in the ticket note screen of the agent interface.' =>
            '',
        'Sets the ticket owner in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the ticket owner in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the ticket owner in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the ticket owner in the ticket responsible screen of the agent interface.' =>
            '',
        'Sets the ticket type in the close ticket screen of the agent interface (Ticket::Type needs to be activated).' =>
            '',
        'Sets the ticket type in the ticket bulk screen of the agent interface.' =>
            '',
        'Sets the ticket type in the ticket free text screen of the agent interface (Ticket::Type needs to be activated).' =>
            '',
        'Sets the ticket type in the ticket note screen of the agent interface (Ticket::Type needs to be activated).' =>
            '',
        'Sets the ticket type in the ticket owner screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).' =>
            '',
        'Sets the ticket type in the ticket pending screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).' =>
            '',
        'Sets the ticket type in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).' =>
            '',
        'Sets the ticket type in the ticket responsible screen of the agent interface (Ticket::Type needs to be activated).' =>
            '',
        'Sets the time (in seconds) a user is marked as active.' => '',
        'Sets the time type which should be shown.' => '',
        'Sets the timeout (in seconds) for http/ftp downloads.' => '',
        'Sets the timeout (in seconds) for package downloads. Overwrites "WebUserAgent::Timeout".' =>
            '',
        'Sets the user time zone per user (required a system with UTC as system time and UTC under TimeZone). Otherwise this is a diff time to the local time.' =>
            '',
        'Sets the user time zone per user based on java script / browser time zone offset feature at login time.' =>
            '',
        'Show a responsible selection in phone and email tickets in the agent interface.' =>
            '',
        'Show article as rich text even if rich text writing is disabled.' =>
            '',
        'Show the current owner in the customer interface.' => '',
        'Show the current queue in the customer interface.' => '',
        'Shows a count of icons in the ticket zoom, if the article has attachments.' =>
            '',
        'Shows a link in the menu for subscribing / unsubscribing from a ticket in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu that allows linking a ticket with another object in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu that allows merging tickets in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to access the history of a ticket in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to add a free text field in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to add a note in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to add a note to a ticket in every ticket overview of the agent interface.' =>
            '',
        'Shows a link in the menu to close a ticket in every ticket overview of the agent interface.' =>
            '',
        'Shows a link in the menu to close a ticket in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to delete a ticket in every ticket overview of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Shows a link in the menu to delete a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Shows a link in the menu to go back in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to lock / unlock a ticket in the ticket overviews of the agent interface.' =>
            '',
        'Shows a link in the menu to lock/unlock tickets in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to move a ticket in every ticket overview of the agent interface.' =>
            '',
        'Shows a link in the menu to print a ticket or an article in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to see the customer who requested the ticket in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to see the history of a ticket in every ticket overview of the agent interface.' =>
            '',
        'Shows a link in the menu to see the owner of a ticket in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to see the priority of a ticket in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to see the responsible agent of a ticket in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to set a ticket as pending in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to set a ticket as spam in every ticket overview of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Shows a link in the menu to set the priority of a ticket in every ticket overview of the agent interface.' =>
            '',
        'Shows a link in the menu to zoom a ticket in the ticket overviews of the agent interface.' =>
            '',
        'Shows a link to access article attachments via a html online viewer in the zoom view of the article in the agent interface.' =>
            '',
        'Shows a link to download article attachments in the zoom view of the article in the agent interface.' =>
            '',
        'Shows a link to see a zoomed email ticket in plain text.' => '',
        'Shows a link to set a ticket as spam in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Shows a list of all the involved agents on this ticket, in the close ticket screen of the agent interface.' =>
            '',
        'Shows a list of all the involved agents on this ticket, in the ticket free text screen of the agent interface.' =>
            '',
        'Shows a list of all the involved agents on this ticket, in the ticket note screen of the agent interface.' =>
            '',
        'Shows a list of all the involved agents on this ticket, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows a list of all the involved agents on this ticket, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows a list of all the involved agents on this ticket, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows a list of all the involved agents on this ticket, in the ticket responsible screen of the agent interface.' =>
            '',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the close ticket screen of the agent interface.' =>
            '',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket free text screen of the agent interface.' =>
            '',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket note screen of the agent interface.' =>
            '',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket responsible screen of the agent interface.' =>
            '',
        'Shows a preview of the ticket overview (CustomerInfo => 1 - shows also Customer-Info, CustomerInfoMaxSize max. size in characters of Customer-Info).' =>
            '',
        'Shows all both ro and rw queues in the queue view.' => '',
        'Shows all open tickets (even if they are locked) in the escalation view of the agent interface.' =>
            '',
        'Shows all open tickets (even if they are locked) in the status view of the agent interface.' =>
            '',
        'Shows all the articles of the ticket (expanded) in the zoom view.' =>
            '',
        'Shows all the customer identifiers in a multi-select field (not useful if you have a lot of customer identifiers).' =>
            '',
        'Shows an owner selection in phone and email tickets in the agent interface.' =>
            '',
        'Shows colors for different article types in the article table.' =>
            '',
        'Shows customer history tickets in AgentTicketPhone, AgentTicketEmail and AgentTicketCustomer.' =>
            '',
        'Shows either the last customer article\'s subject or the ticket title in the small format overview.' =>
            '',
        'Shows existing parent/child queue lists in the system in the form of a tree or a list.' =>
            '',
        'Shows the activated ticket attributes in the customer interface (0 = Disabled and 1 = Enabled).' =>
            '',
        'Shows the articles sorted normally or in reverse, under ticket zoom in the agent interface.' =>
            '',
        'Shows the customer user information (phone and email) in the compose screen.' =>
            '',
        'Shows the customer user\'s info in the ticket zoom view.' => '',
        'Shows the message of the day (MOTD) in the agent dashboard. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually.' =>
            '',
        'Shows the message of the day on login screen of the agent interface.' =>
            '',
        'Shows the ticket history (reverse ordered) in the agent interface.' =>
            '',
        'Shows the ticket priority options in the close ticket screen of the agent interface.' =>
            '',
        'Shows the ticket priority options in the move ticket screen of the agent interface.' =>
            '',
        'Shows the ticket priority options in the ticket bulk screen of the agent interface.' =>
            '',
        'Shows the ticket priority options in the ticket free text screen of the agent interface.' =>
            '',
        'Shows the ticket priority options in the ticket note screen of the agent interface.' =>
            '',
        'Shows the ticket priority options in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows the ticket priority options in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows the ticket priority options in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows the ticket priority options in the ticket responsible screen of the agent interface.' =>
            '',
        'Shows the title fields in the close ticket screen of the agent interface.' =>
            '',
        'Shows the title fields in the ticket free text screen of the agent interface.' =>
            '',
        'Shows the title fields in the ticket note screen of the agent interface.' =>
            '',
        'Shows the title fields in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows the title fields in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows the title fields in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows the title fields in the ticket responsible screen of the agent interface.' =>
            '',
        'Shows time in long format (days, hours, minutes), if set to "Yes"; or in short format (days, hours), if set to "No".' =>
            '',
        'Shows time use complete description (days, hours, minutes), if set to "Yes"; or just first letter (d, h, m), if set to "No".' =>
            '',
        'Skin' => 'Apvalkalas',
        'SolutionDiffInMin' => '',
        'SolutionInMin' => '',
        'Sorts the tickets (ascendingly or descendingly) when a single queue is selected in the queue view and after the tickets are sorted by priority. Values: 0 = ascending (oldest on top, default), 1 = descending (youngest on top). Use the QueueID for the key and 0 or 1 for value.' =>
            '',
        'Spam Assassin example setup. Ignores emails that are marked with SpamAssassin.' =>
            '',
        'Spam Assassin example setup. Moves marked mails to spam queue.' =>
            '',
        'Specifies if an agent should receive email notification of his own actions.' =>
            '',
        'Specifies the available note types for this ticket mask. If the option is deselected, ArticleTypeDefault is used and the option is removed from the mask.' =>
            '',
        'Specifies the background color of the chart.' => '',
        'Specifies the background color of the picture.' => '',
        'Specifies the border color of the chart.' => '',
        'Specifies the border color of the legend.' => '',
        'Specifies the bottom margin of the chart.' => '',
        'Specifies the different article types that will be used in the system.' =>
            '',
        'Specifies the different note types that will be used in the system.' =>
            '',
        'Specifies the directory to store the data in, if "FS" was selected for TicketStorageModule.' =>
            '',
        'Specifies the directory where SSL certificates are stored.' => '',
        'Specifies the directory where private SSL certificates are stored.' =>
            '',
        'Specifies the email address that should be used by the application when sending notifications. The email address is used to build the complete display name for the notification master (i.e. "OTRS Notification Master" otrs@your.example.com). You can use the OTRS_CONFIG_FQDN variable as set in your configuation, or choose another email address. Notifications are messages such as en::Customer::QueueUpdate or en::Agent::Move.' =>
            '',
        'Specifies the group where the user needs rw permissions so that he can access the "SwitchToCustomer" feature.' =>
            '',
        'Specifies the left margin of the chart.' => '',
        'Specifies the name that should be used by the application when sending notifications. The sender name is used to build the complete display name for the notification master (i.e. "OTRS Notification Master" otrs@your.example.com). Notifications are messages such as en::Customer::QueueUpdate or en::Agent::Move.' =>
            '',
        'Specifies the path of the file for the logo in the page header (gif|jpg|png, 700 x 100 pixel).' =>
            '',
        'Specifies the path of the file for the performance log.' => '',
        'Specifies the path to the converter that allows the view of Microsoft Excel files, in the web interface.' =>
            '',
        'Specifies the path to the converter that allows the view of Microsoft Word files, in the web interface.' =>
            '',
        'Specifies the path to the converter that allows the view of PDF documents, in the web interface.' =>
            '',
        'Specifies the path to the converter that allows the view of XML files, in the web interface.' =>
            '',
        'Specifies the right margin of the chart.' => '',
        'Specifies the text color of the chart (e. g. caption).' => '',
        'Specifies the text color of the legend.' => '',
        'Specifies the text that should appear in the log file to denote a CGI script entry.' =>
            '',
        'Specifies the top margin of the chart.' => '',
        'Specifies user id of the postmaster data base.' => '',
        'Specify how many sub directory levels to use when creating cache files. This should prevent too many cache files being in one directory.' =>
            '',
        'Standard available permissions for agents within the application. If more permissions are needed, they can be entered here. Permissions must be defined to be effective. Some other good permissions have also been provided built-in: note, close, pending, customer, freetext, move, compose, responsible, forward, and bounce. Make sure that "rw" is always the last registered permission.' =>
            '',
        'Start number for statistics counting. Every new stat increments this number.' =>
            '',
        'Starts a wildcard search of the active object after the link object mask is started.' =>
            '',
        'Statistics' => 'Statistika',
        'Status view' => 'Statusų peržiūra',
        'Stop words for fulltext index. These words will be removed.' => '',
        'Stores cookies after the browser has been closed.' => '',
        'Strips empty lines on the ticket preview in the queue view.' => '',
        'Textarea' => '',
        'The "bin/PostMasterMailAccount.pl" will reconnect to POP3/POP3S/IMAP/IMAPS host after the specified count of messages.' =>
            '',
        'The agent skin\'s InternalName which should be used in the agent interface. Please check the available skins in Frontend::Agent::Skins.' =>
            '',
        'The customer skin\'s InternalName which should be used in the customer interface. Please check the available skins in Frontend::Customer::Skins.' =>
            '',
        'The divider between TicketHook and ticket number. E.g \': \'.' =>
            '',
        'The duration in minutes after emitting an event, in which the new escalation notify and start events are suppressed.' =>
            '',
        'The format of the subject. \'Left\' means \'[TicketHook#:12345] Some Subject\', \'Right\' means \'Some Subject [TicketHook#:12345]\', \'None\' means \'Some Subject\' and no ticket number. In the last case you should enable PostmasterFollowupSearchInRaw or PostmasterFollowUpSearchInReferences to recognize followups based on email headers and/or body.' =>
            '',
        'The headline shown in the customer interface.' => '',
        'The identifier for a ticket, e.g. Ticket#, Call#, MyTicket#. The default is Ticket#.' =>
            '',
        'The logo shown in the header of the agent interface. The URL to the image can be a relative URL to the skin image directory, or a full URL to a remote web server.' =>
            '',
        'The logo shown in the header of the customer interface. The URL to the image can be a relative URL to the skin image directory, or a full URL to a remote web server.' =>
            '',
        'The logo shown on top of the login box of the agent interface. The URL to the image must be relative URL to the skin image directory.' =>
            '',
        'The text at the beginning of the subject in an email reply, e.g. RE, AW, or AS.' =>
            '',
        'The text at the beginning of the subject when an email is forwarded, e.g. FW, Fwd, or WG.' =>
            '',
        'This module and its PreRun() function will be executed, if defined, for every request. This module is useful to check some user options or to display news about new applications.' =>
            '',
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
        'Ticket overview' => 'Trikčių peržiūra',
        'TicketNumber' => '',
        'Tickets' => 'Triktys',
        'Time in seconds that gets added to the actual time if setting a pending-state (default: 86400 = 1 day).' =>
            '',
        'Toggles display of OTRS FeatureAddons list in PackageManager.' =>
            '',
        'Toolbar Item for a shortcut.' => '',
        'Turns on the animations used in the GUI. If you have problems with these animations (e.g. performance issues), you can turn them off here.' =>
            '',
        'Turns on the remote ip address check. It should be set to "No" if the application is used, for example, via a proxy farm or a dialup connection, because the remote ip address is mostly different for the requests.' =>
            '',
        'Types' => 'Tipai',
        'Update Ticket "Seen" flag if every article got seen or a new Article got created.' =>
            '',
        'Update and extend your system with software packages.' => 'Atnaujinkite ir išplėskite savo sistemą programinės įrangos paketais.',
        'Updates the ticket escalation index after a ticket attribute got updated.' =>
            '',
        'Updates the ticket index accelerator.' => '',
        'UserFirstname' => '',
        'UserLastname' => '',
        'Uses Cc recipients in reply Cc list on compose an email answer in the ticket compose screen of the agent interface.' =>
            '',
        'Uses richtext for viewing and editing: articles, salutations, signatures, standard responses, auto responses and notifications.' =>
            '',
        'View performance benchmark results.' => 'Peržiūrėti našumo rodiklių rezultatus.',
        'View system log messages.' => 'Peržiūrėti sistemos registravimo žurnalo žinutes.',
        'Wear this frontend skin' => '',
        'Webservice path separator.' => '',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. In this text area you can define this text (This text cannot be changed by the agent).' =>
            '',
        'When tickets are merged, the customer can be informed per email by setting the check box "Inform Sender". In this text area, you can define a pre-formatted text which can later be modified by the agents.' =>
            '',
        'Your queue selection of your favorite queues. You also get notified about those queues via email if enabled.' =>
            '',

        #
        # OBSOLETE ENTRIES FOR REFERENCE, DO NOT TRANSLATE!
        #
        'Customer Data' => 'Kliento duomenys',
        'For more info see:' => 'Daugiau informacijos žiūrėkite:',
        'Logout successful. Thank you for using OTRS!' => 'Sėkmingai atsijungta! Ačiū, kad naudojatės OTRS!',
        'Package verification failed!' => 'Paketo patikrinimas nepavyko',
        'Secure mode must be disabled in order to reinstall using the web-installer.' =>
            'Norint įdiegti iš naujo, naudojant web-diegyklę, saugus režimas turi būti išjungtas.',

    };
    # $$STOP$$
    return;
}

1;
