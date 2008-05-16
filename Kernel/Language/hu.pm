# --
# Kernel/Language/hu.pm - provides de language translation
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: hu.pm,v 1.47 2008-05-16 12:16:13 martin Exp $
# Translation: Gabor Gancs /gg@magicnet.hu/ & Krisztian Gancs /krisz@gancs.hu/
# Verify: Flora Szabo /szaboflora@magicnet.hu/
# Hungary Sopron Europe
#
# Reviewed and adapted to OTRS v2.2 by Aron Ujvari <ujvari@hungary.com>
#
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Language::hu;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.47 $) [1];

sub Data {
    my ( $Self, %Param ) = @_;

    # $$START$$
    # Last translation file sync: Fri May 16 14:08:31 2008

    # possible charsets
    $Self->{Charset} = ['iso-8859-2', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Jear;)
    $Self->{DateFormat}          = '%Y.%M.%D %T';
    $Self->{DateFormatLong}      = '%Y %B %D %A %T';
    $Self->{DateFormatShort}     = '%Y.%M.%D';
    $Self->{DateInputFormat}     = '%Y.%M.%D';
    $Self->{DateInputFormatLong} = '%Y.%M.%D - %T';

    $Self->{Translation} = {
        # Template: AAABase
        'Yes' => 'Igen',
        'No' => 'Nem',
        'yes' => 'igen',
        'no' => 'nem',
        'Off' => 'Ki',
        'off' => 'ki',
        'On' => 'Be',
        'on' => 'be',
        'top' => 'Teteje',
        'end' => 'vége',
        'Done' => 'Kész',
        'Cancel' => 'Mégsem',
        'Reset' => 'Alapállás',
        'last' => 'legfeljebb ennyi ideje',
        'before' => 'legalább ennyi ideje',
        'day' => 'nap',
        'days' => 'nap',
        'day(s)' => 'nap',
        'hour' => 'óra',
        'hours' => 'óra',
        'hour(s)' => 'óra',
        'minute' => 'Perc',
        'minutes' => 'perc',
        'minute(s)' => 'perc',
        'month' => 'hónap',
        'months' => 'hónap',
        'month(s)' => 'hónap',
        'week' => 'hét',
        'week(s)' => 'hét',
        'year' => 'év',
        'years' => 'év',
        'year(s)' => 'év',
        'second(s)' => 'mp',
        'seconds' => 'mp',
        'second' => 'mp',
        'wrote' => 'írta',
        'Message' => 'Üzenet',
        'Error' => 'Hiba',
        'Bug Report' => 'Hibajelentés',
        'Attention' => 'Figyelem',
        'Warning' => 'Figyelem',
        'Module' => 'Modul',
        'Modulefile' => 'Modulfile',
        'Subfunction' => 'Alfunkció',
        'Line' => 'Vonal',
        'Example' => 'Példa',
        'Examples' => 'Példa',
        'valid' => 'érvényes',
        'invalid' => 'érvénytelen',
        '* invalid' => '* érvénytelen',
        'invalid-temporarily' => 'ideiglenesen érvénytelen',
        ' 2 minutes' => ' 2 Perc',
        ' 5 minutes' => ' 5 Perc',
        ' 7 minutes' => ' 7 Perc',
        '10 minutes' => '10 Perc',
        '15 minutes' => '15 Perc',
        'Mr.' => '',
        'Mrs.' => '',
        'Next' => 'Következõ',
        'Back' => 'Vissza',
        'Next...' => 'Következõ...',
        '...Back' => '...Vissza',
        '-none-' => '-nincs-',
        'none' => 'semmi',
        'none!' => 'semmi!',
        'none - answered' => 'semmi - megválaszolt',
        'please do not edit!' => 'kérjük ne javítsa!',
        'AddLink' => 'Kapcsolat hozzáadása',
        'Link' => 'Kapcsolat',
        'Unlink' => 'Kapcsolat feloldása',
        'Linked' => 'Kapcsolat',
        'Link (Normal)' => '',
        'Link (Parent)' => '',
        'Link (Child)' => '',
        'Normal' => 'Normál',
        'Parent' => 'Szülõ',
        'Child' => 'Gyerek',
        'Hit' => 'Találat',
        'Hits' => 'Találatok',
        'Text' => 'Szöveg',
        'Lite' => 'Egyszerû',
        'User' => 'Felhasználó',
        'Username' => 'Felhasználónév',
        'Language' => 'Nyelv',
        'Languages' => 'Nyelv',
        'Password' => 'Jelszó',
        'Salutation' => 'Megszólítás',
        'Signature' => 'Aláírás',
        'Customer' => 'Ügyfél',
        'CustomerID' => 'Ügyfélazonosító',
        'CustomerIDs' => 'Ügyfélazonosítók',
        'customer' => 'ügyfél',
        'agent' => 'Ügyintézõ',
        'system' => 'rendszer',
        'Customer Info' => 'Ügyfél Info',
        'Customer Company' => 'Ügyfél cég',
        'Company' => 'Cég',
        'go!' => 'Indítás!',
        'go' => 'indítás',
        'All' => 'Összes',
        'all' => 'összes',
        'Sorry' => 'Sajnálom',
        'update!' => 'Módosítás!',
        'update' => 'módosítás',
        'Update' => 'Módosítás',
        'submit!' => 'Elküldés!',
        'submit' => 'elküldés',
        'Submit' => 'Elküldés',
        'change!' => 'Változtatás!',
        'Change' => 'Változtatás',
        'change' => 'változtatás',
        'click here' => 'kattints ide',
        'Comment' => 'Megjegyzés',
        'Valid' => 'Érvényesség',
        'Invalid Option!' => '',
        'Invalid time!' => 'Hibás idõpont!',
        'Invalid date!' => 'Hibás dátum!',
        'Name' => 'Név',
        'Group' => 'Csoport',
        'Description' => 'Leírás',
        'description' => 'leírás',
        'Theme' => 'Téma',
        'Created' => 'Létrehozás ideje',
        'Created by' => 'Létrehozta',
        'Changed' => 'Módosítás ideje',
        'Changed by' => 'Módosította',
        'Search' => 'Keresés',
        'and' => 'és',
        'between' => '',
        'Fulltext Search' => '',
        'Data' => '',
        'Options' => 'Beállítások',
        'Title' => 'Cím',
        'Item' => '',
        'Delete' => 'Törlés',
        'Edit' => 'Szerkesztés',
        'View' => 'Nézet',
        'Number' => '',
        'System' => 'Rendszer',
        'Contact' => 'Kapcsolat',
        'Contacts' => '',
        'Export' => '',
        'Up' => '',
        'Down' => '',
        'Add' => 'Hozzáadás',
        'Category' => 'Kategória',
        'Viewer' => '',
        'New message' => 'Új üzenet',
        'New message!' => 'Új üzenet!',
        'Please answer this ticket(s) to get back to the normal queue view!' => 'Kérjük válaszoljon erre(ezekre) a jegy(ek)re hogy visszatérhessen a normál várólista nézethez!',
        'You got new message!' => 'Új üzenete érkezett!',
        'You have %s new message(s)!' => '%s új üzenete van!',
        'You have %s reminder ticket(s)!' => '%s emlékeztetõ jegye van!',
        'The recommended charset for your language is %s!' => 'Az ajánlott karakterkészlet az ön nyelvénél %s!',
        'Passwords doesn\'t match! Please try it again!' => 'A jelszavak nem egyeznek! Próbálja meg újra!',
        'Password is already in use! Please use an other password!' => '',
        'Password is already used! Please use an other password!' => '',
        'You need to activate %s first to use it!' => '%s aktiválására van szükség mielõtt használná!',
        'No suggestions' => 'Nincsenek javaslatok',
        'Word' => 'Szó',
        'Ignore' => 'Figyelmen kívül hagy',
        'replace with' => 'csere ezzel',
        'There is no account with that login name.' => 'Azzal a névvel nincs azonosító.',
        'Login failed! Your username or password was entered incorrectly.' => 'Belépés sikertelen! Hibásan adta meg a felhasználói nevét vagy jelszavát.',
        'Please contact your admin' => 'Kérjük vegye fel a kapcsolatot a rendszergazdájával',
        'Logout successful. Thank you for using OTRS!' => 'Kilépés megtörtént! Köszönjük, hogy az OTRS-t használja!',
        'Invalid SessionID!' => 'Hibás folyamat azonosító!',
        'Feature not active!' => 'Képesség nem aktív!',
        'Login is needed!' => '',
        'Password is needed!' => '',
        'License' => 'Licensz',
        'Take this Customer' => 'Átveszi ez az ügyfél',
        'Take this User' => 'Átveszi ez a felhasználó',
        'possible' => 'lehetséges',
        'reject' => 'elutasítás',
        'reverse' => '',
        'Facility' => 'Képesség',
        'Timeover' => 'Késés',
        'Pending till' => 'Várakozás eddig',
        'Don\'t work with UserID 1 (System account)! Create new users!' => 'Ne dolgozzon az 1-es felhasználóval (Rendszer jogosultság)! Hozzon létre új felhasználót!',
        'Dispatching by email To: field.' => 'Szétválogatás az e-mail címzett mezõje szerint.',
        'Dispatching by selected Queue.' => 'Szétválogatás a kiválasztott várólista szerint.',
        'No entry found!' => 'Nem található tétel!',
        'Session has timed out. Please log in again.' => 'Az folyamat idõtúllépés miatt befejezõdött. Kérjük lépjen be újra.',
        'No Permission!' => 'Nincs jogosultság!',
        'To: (%s) replaced with database email!' => 'Címzett: (%s) felülírva az adatbázis címmel!',
        'Cc: (%s) added database email!' => 'Másolat: (%s) e-mail címe hozzáadva az adatbázishoz!',
        '(Click here to add)' => '(Kattinston ide a hozzáadáshoz)',
        'Preview' => 'Elõnézet',
        'Package not correctly deployed! You should reinstall the Package again!' => 'A csomag nincsen megfelelõen telepítve! Telepítse újra a csomagot!',
        'Added User "%s"' => 'A "%s" felhasználó hozzáadva',
        'Contract' => 'Kapcsolat',
        'Online Customer: %s' => 'Bejelentkezett ügyfél: %s',
        'Online Agent: %s' => 'Bejelentkezett ügyintézõ: %s',
        'Calendar' => 'Naptár',
        'File' => 'Fájl',
        'Filename' => 'Fájlnév',
        'Type' => 'Típus',
        'Size' => 'Méret',
        'Upload' => 'Feltöltés',
        'Directory' => 'Könyvtár',
        'Signed' => 'Aláírt',
        'Sign' => 'Aláírás',
        'Crypted' => 'Kódolt',
        'Crypt' => 'Kódolás',
        'Office' => 'Iroda',
        'Phone' => 'Telefonszám',
        'Fax' => 'Fax szám',
        'Mobile' => 'Mobil szám',
        'Zip' => 'Irányítószám',
        'City' => 'Város',
        'Street' => 'Utca',
        'Country' => 'Ország',
        'installed' => 'telepített',
        'uninstalled' => 'nem telepített',
        'Security Note: You should activate %s because application is already running!' => 'Biztonsági megjegyzés: Aktiválnia kellene a %s modult, mert az alakalmazás már fut!',
        'Unable to parse Online Repository index document!' => 'Nem sikerült értelmezni az on-line csomagtároló index dokumentumát!',
        'No Packages for requested Framework in this Online Repository, but Packages for other Frameworks!' => 'Nincsenek csomagok a kért Keretrendszerhez ebben az on-line csomagtárolóban, viszont vannak más Keretrendszerekhez!',
        'No Packages or no new Packages in selected Online Repository!' => 'Nincsenek csomagok vagy nincsenek új csomagok a kiválasztott on-line csomagtárolóban!',
        'printed at' => '',
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
        'Jan' => 'Jan',
        'Feb' => 'Feb',
        'Mar' => 'Már',
        'Apr' => 'Ápr',
        'May' => 'Május',
        'Jun' => 'Jún',
        'Jul' => 'Júl',
        'Aug' => 'Aug',
        'Sep' => 'Sze',
        'Oct' => 'Okt',
        'Nov' => 'Nov',
        'Dec' => 'Dec',
        'January' => 'Január',
        'February' => 'Február',
        'March' => 'Március',
        'April' => 'Április',
        'June' => 'Június',
        'July' => 'Július',
        'August' => 'Augusztus',
        'September' => 'Szeptember',
        'October' => 'Október',
        'November' => 'November',
        'December' => 'December',

        # Template: AAANavBar
        'Admin-Area' => 'Adminisztrációs-terület',
        'Agent-Area' => 'Ügyintézõ-terület',
        'Ticket-Area' => 'Jegy-terület',
        'Logout' => 'Kilépés',
        'Agent Preferences' => 'Ügyintézõ beállításai',
        'Preferences' => 'Beállítások',
        'Agent Mailbox' => 'Ügyintézõ postafiókja',
        'Stats' => 'Statisztika',
        'Stats-Area' => 'Statisztika-terület',
        'Admin' => 'Adminisztráció',
        'Customer Users' => 'Ügyfél felhasználók',
        'Customer Users <-> Groups' => 'Ügyfél felhasználók <-> Csoportok',
        'Users <-> Groups' => 'Felhasználók <-> Csoportok',
        'Roles' => 'Szerepek',
        'Roles <-> Users' => 'Szerepek <-> Felhasználók',
        'Roles <-> Groups' => 'Szerepek <-> Csoportok',
        'Salutations' => 'Megszólítások',
        'Signatures' => 'Aláírások',
        'Email Addresses' => 'E-mail címek',
        'Notifications' => 'Értesítések',
        'Category Tree' => '',
        'Admin Notification' => 'Adminsztrátori értesítések',

        # Template: AAAPreferences
        'Preferences updated successfully!' => 'Beállítások sikeresen frissítve!',
        'Mail Management' => 'E-mail kezelés',
        'Frontend' => 'Felhasználói felület',
        'Other Options' => 'Egyéb beállítások',
        'Change Password' => 'Jelszó megváltoztatása',
        'New password' => 'Új jelszó',
        'New password again' => 'Új jelszó megismétlése',
        'Select your QueueView refresh time.' => 'Válassza ki a Várólista nézet frissítési idejét.',
        'Select your frontend language.' => 'Válassza ki a felhasználói felület nyelvét.',
        'Select your frontend Charset.' => 'Válassza ki a felhasználói felület karakterkészletét.',
        'Select your frontend Theme.' => 'Válassza ki a felhasználói felület stílusát.',
        'Select your frontend QueueView.' => 'Válassza ki a felhasználói felület Várólista nézetét.',
        'Spelling Dictionary' => 'Helyesírás-ellenõrzõ szótár',
        'Select your default spelling dictionary.' => 'Válassza ki az alapértelmezett helyesírásellenõrzõ szótárat.',
        'Max. shown Tickets a page in Overview.' => 'Max. megjelenített jegy az áttekintésnél.',
        'Can\'t update password, passwords doesn\'t match! Please try it again!' => 'Nem sikerült modosítani a jelszót, a jelszavak nem egyeznek! Kérem próbálja újra!',
        'Can\'t update password, invalid characters!' => 'Nem sikerült modosítani a jelszót, érvénytelen karakterek!',
        'Can\'t update password, need min. 8 characters!' => 'Nem sikerült modosítani a jelszót, legalább 8 karakter megadása szükséges!',
        'Can\'t update password, need 2 lower and 2 upper characters!' => 'Nem sikerült modosítani a jelszót, legalább 2 kisbetûnek és 2 nagybetûnek kell benne szerepelnie!',
        'Can\'t update password, need min. 1 digit!' => 'Nem sikerült modosítani a jelszót, legalább egy számjegynek kell benne szerepelnie!',
        'Can\'t update password, need min. 2 characters!' => 'Nem sikerült modosítani a jelszót, legalább 2 karakter megadása szükséges!',

        # Template: AAAStats
        'Stat' => 'Statisztika',
        'Please fill out the required fields!' => 'Kérem töltse ki a kötelezõ mezõket!',
        'Please select a file!' => 'Kérem válasszon egy fájlt!',
        'Please select an object!' => 'Kérem válasszok egy objektumot!',
        'Please select a graph size!' => 'Kérem válasszon egy grafikon méretet!',
        'Please select one element for the X-axis!' => 'Kérem válasszon egy tulajdonságot az X tengelynek',
        'You have to select two or more attributes from the select field!' => 'Legalább két értéket válasszon ki a mezõben!',
        'Please select only one element or turn off the button \'Fixed\' where the select field is marked!' => 'Kérem válasszon egy értéket vagy kapcsolja ki a \'Rögzített\' kapcsolót a megjelölt mezõnél.',
        'If you use a checkbox you have to select some attributes of the select field!' => 'Ha egy jelölõnégyzetet használ, akkor néhány értéket is ki kell választania a tulajdonsághoz!',
        'Please insert a value in the selected input field or turn off the \'Fixed\' checkbox!' => 'Adjon meg egy értéket a bemeneti mezõben vagy kapcsolja ki a \'Rögzített\' kapcsolót!',
        'The selected end time is before the start time!' => 'A befejezési idõnek a kezdeti idõ után kell lennie!',
        'You have to select one or more attributes from the select field!' => 'Válasszon ki egy vagy több értéket a mezõbõl!',
        'The selected Date isn\'t valid!' => 'A kiválasztott dátum érvénytelen!',
        'Please select only one or two elements via the checkbox!' => 'Kérem válasszon egy vagy két elemet a jelölõnégyetekbõl!',
        'If you use a time scale element you can only select one element!' => 'Amennyiben egy idõskála elemet is választott, akkro csak egy elemet választhat közölük!',
        'You have an error in your time selection!' => 'Hibás a kiválasztott idõ!',
        'Your reporting time interval is too small, please use a larger time scale!' => 'A kiválasztott idõ intervallum túl kicsi, kérem válasszon nagyobb skálát.',
        'The selected start time is before the allowed start time!' => 'A kiválasztott kezdési idõ a megengedett kezdési idõ elõtt van!',
        'The selected end time is after the allowed end time!' => 'A kiválasztott befejezési idõ a megengedett befejezési idõ után van!',
        'The selected time period is larger than the allowed time period!' => 'A kiválasztott ismétlõdés a megengedett ismétlõdésnél nagyobb!',
        'Common Specification' => 'Általános beállítások',
        'Xaxis' => 'X tengely',
        'Value Series' => 'Megjelenített értékek',
        'Restrictions' => 'Megkötések',
        'graph-lines' => 'Grafikon - vonalak',
        'graph-bars' => 'Grafikon - oszlopok',
        'graph-hbars' => 'Grafikon - vízszintes oszlopok',
        'graph-points' => 'Grafikon - pontok',
        'graph-lines-points' => 'Grafikon - vonalak-pontok',
        'graph-area' => 'Grafikon - terület',
        'graph-pie' => 'Grafikon - torta',
        'extended' => 'Kiterjesztett',
        'Agent/Owner' => 'Ügyintézõ/Tulajdonos',
        'Created by Agent/Owner' => 'Letrehozó ügyintézõ/tulajdonos',
        'Created Priority' => 'Létrehozáskori prioritás',
        'Created State' => 'Létrehozáskori állapot',
        'Create Time' => 'Létrehozás ideje',
        'CustomerUserLogin' => 'Ügyfél felhasználóneve',
        'Close Time' => 'Lezárás ideje',

        # Template: AAATicket
        'Lock' => 'Zárolás',
        'Unlock' => 'Feloldás',
        'History' => 'Elõzmények',
        'Zoom' => 'Részletek',
        'Age' => 'Kor',
        'Bounce' => 'Visszaküldés',
        'Forward' => 'Továbbítás',
        'From' => 'Feladó',
        'To' => 'Címzett',
        'Cc' => 'Másolat',
        'Bcc' => 'Rejtett másolat',
        'Subject' => 'Tárgy',
        'Move' => 'Áthelyezés',
        'Queue' => 'Várólista',
        'Priority' => 'Prioritás',
        'Priority Update' => 'Prioritás módosítása',
        'State' => 'Állapot',
        'Compose' => 'Készít',
        'Pending' => 'Várakozik',
        'Owner' => 'Tulajdonos',
        'Owner Update' => 'Tulajdonos módosítása',
        'Responsible' => 'Felelõs',
        'Responsible Update' => 'Felelõs módosítása',
        'Sender' => 'Küldõ',
        'Article' => 'Bejegyzés',
        'Ticket' => 'Jegy',
        'Createtime' => 'Létrehozás ideje',
        'plain' => 'sima',
        'Email' => 'E-mail',
        'email' => 'e-mail',
        'Close' => 'Lezárás',
        'Action' => 'Mûvelet',
        'Attachment' => 'Levélmelléklet',
        'Attachments' => 'Levélmellékletek',
        'This message was written in a character set other than your own.' => 'Ezt az üzenetet más karakterkészlettel írták mint amit ön használ.',
        'If it is not displayed correctly,' => 'Ha nem helyesen jelent meg,',
        'This is a' => 'Ez egy',
        'to open it in a new window.' => 'hogy megnyissa új ablakban.',
        'This is a HTML email. Click here to show it.' => 'Ez egy HTML e-mail. Kattintson ide a megtekintéshez.',
        'Free Fields' => 'Szabad mezõk',
        'Merge' => 'Egyesítés',
        'merged' => 'egyesített',
        'closed successful' => 'sikeresen lezárva',
        'closed unsuccessful' => 'sikertelenül lezárva',
        'new' => 'új',
        'open' => 'nyitott',
        'closed' => 'lezárt',
        'removed' => 'törölt',
        'pending reminder' => 'emlékeztetõre várakozik',
        'pending auto' => '',
        'pending auto close+' => 'automatikus zárásra várakozik+',
        'pending auto close-' => 'automatikus zárásra várakozik-',
        'email-external' => 'külsõ e-mail',
        'email-internal' => 'belsõ e-mail',
        'note-external' => 'külsõ jegyzet',
        'note-internal' => 'belsõ jegyzet',
        'note-report' => 'jegyzet jelentés',
        'phone' => 'telefon',
        'sms' => 'sms',
        'webrequest' => 'webkérés',
        'lock' => 'zárolt',
        'unlock' => 'feloldott',
        'very low' => 'nagyon alacsony',
        'low' => 'alacsony',
        'normal' => 'normál',
        'high' => 'magas',
        'very high' => 'nagyon magas',
        '1 very low' => '1 nagyon alacsony',
        '2 low' => '2 alacsony',
        '3 normal' => '3 normál',
        '4 high' => '4 magas',
        '5 very high' => '5 nagyon magas',
        'Ticket "%s" created!' => 'A "%s" jegy létrehozva!',
        'Ticket Number' => 'Jegy száma',
        'Ticket Object' => 'Jegy objektum',
        'No such Ticket Number "%s"! Can\'t link it!' => 'Nincs "%s" számú jegy! Nem tudom csatolni!',
        'Don\'t show closed Tickets' => 'Ne jelenítse meg a lezárt jegyeket.',
        'Show closed Tickets' => 'Mutasd a lezárt jegyeket',
        'New Article' => 'Új bejegyzés',
        'Email-Ticket' => 'E-mail jegy',
        'Create new Email Ticket' => '',
        'Phone-Ticket' => 'Telefon-jegy',
        'Search Tickets' => 'Jegyek keresése',
        'Edit Customer Users' => 'Ügyfél felhasználó szerkesztése',
        'Edit Customer Company' => 'Ügyfél cég szerkesztése',
        'Bulk-Action' => 'Csoportos mûvelet',
        'Bulk Actions on Tickets' => 'Csoportos mûvelet jegyeken',
        'Send Email and create a new Ticket' => '',
        'Create new Email Ticket and send this out (Outbound)' => 'Új E-mail jegy létrehozása és kiküldése (Kimenõ)',
        'Create new Phone Ticket (Inbound)' => 'Új Telefon-jegy létrehozása (Bejövõ)',
        'Overview of all open Tickets' => 'Összes nyitott jegy áttekintése',
        'Locked Tickets' => 'Zárolt jegyek',
        'Watched Tickets' => 'Követett jegyek',
        'Watched' => 'Követett',
        'Subscribe' => 'Feliratkozás',
        'Unsubscribe' => 'Leiratkozás',
        'Lock it to work on it!' => 'Jegy zárolása, hogy dolgozzon rajta!',
        'Unlock to give it back to the queue!' => 'Oldja föl, hogy visszakerüljön a várólistába!',
        'Shows the ticket history!' => 'Jegy elõzményeinek megjelenítése!',
        'Print this ticket!' => 'Jegy nyomtatása!',
        'Change the ticket priority!' => 'Jegy prioritásának módosítása!',
        'Change the ticket free fields!' => 'Jegy szabad mezõinek módosítása!',
        'Link this ticket to an other objects!' => 'Összekapcsolja a jegyet egy másik objektummal!',
        'Change the ticket owner!' => 'Jegy tulajdonosának módosítása!',
        'Change the ticket customer!' => 'Jegyhez tartozó ügyfél módosítása!',
        'Add a note to this ticket!' => 'Megjegyzés írása a jegyhez!',
        'Merge this ticket!' => 'Egyesíti a jegyet egy másikkal!',
        'Set this ticket to pending!' => 'Jegy várakozó állapotba helyezése!',
        'Close this ticket!' => 'Jegy lezárása!',
        'Look into a ticket!' => 'Jegy részletesebb megtekintése!',
        'Delete this ticket!' => 'Jegy törlése!',
        'Mark as Spam!' => 'Jegy spamnek jelölése!',
        'My Queues' => 'Saját várólistáim',
        'Shown Tickets' => 'Megjelenített jegyek',
        'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' => 'Az Ön "<OTRS_TICKET>" jegy számmal rendelkezõ e-mailje egyesítésre került a "<OTRS_MERGE_TO_TICKET>" jeggyel.',
        'Ticket %s: first response time is over (%s)!' => 'Jegy %s: elsõ válasz ideje letelt (%s)!',
        'Ticket %s: first response time will be over in %s!' => 'Jegy %s: elsõ válasz ideje le fog telni %s idõn belül!',
        'Ticket %s: update time is over (%s)!' => 'Jegy %s: frissítés ideje letelt (%s)!',
        'Ticket %s: update time will be over in %s!' => 'Jegy %s: frissítés ideje le fog telni %s idõn belül!',
        'Ticket %s: solution time is over (%s)!' => 'Jegy %s: megoldás ideje letelt (%s)!',
        'Ticket %s: solution time will be over in %s!' => 'Jegy %s: megoldás ideje le fog telni %s idõn belül!',
        'There are more escalated tickets!' => 'Több kiemelt jegy van!',
        'New ticket notification' => 'Új jegy értesítés',
        'Send me a notification if there is a new ticket in "My Queues".' => 'Küldjön nekem értesítést, ha új jegy van a "Saját várólistáim"-ban.',
        'Follow up notification' => 'Válaszlevél értesítés',
        'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.' => 'Küldjön értesítést ha az ügyfél válaszol és én vagyok a tulajdonosa a jegynek.',
        'Ticket lock timeout notification' => 'Jegyzárolás-lejárat értesítés',
        'Send me a notification if a ticket is unlocked by the system.' => 'Küldjön értesítést ha egy jegy zárolását a renszer feloldotta.',
        'Move notification' => 'Áthelyezés értesítés',
        'Send me a notification if a ticket is moved into one of "My Queues".' => 'Küldjön nekem értesítést, ha egy jegyet a "Saját várólistáim" egyikébe mozgatták.',
        'Your queue selection of your favourite queues. You also get notified about those queues via email if enabled.' => 'Saját várólistáknak tekintett várólisták kiválasztása. E-mail értesítítések fog kapni ezekrõl a várólistákról, amennyiben ez engedélyezett.',
        'Custom Queue' => 'Egyedi várólisták',
        'QueueView refresh time' => 'Várólista nézet frissítési ideje',
        'Screen after new ticket' => 'Új jegy utáni képernyõ',
        'Select your screen after creating a new ticket.' => 'Válassza ki a képernyõt új jegy létrehozása után.',
        'Closed Tickets' => 'Lezárt jegyek',
        'Show closed tickets.' => 'Mutasd a lezárt jegyeket.',
        'Max. shown Tickets a page in QueueView.' => 'A megjelenített jegyek számának maximuma a Várólista nézetnél.',
        'CompanyTickets' => 'Cég jegyek',
        'MyTickets' => 'Saját jegyek',
        'New Ticket' => 'Új jegy',
        'Create new Ticket' => 'Új jegy létrehozása',
        'Customer called' => 'Ügyfél telefonált',
        'phone call' => 'telefonhívás',
        'Responses' => 'Válaszok',
        'Responses <-> Queue' => 'Válaszok <-> Várólista',
        'Auto Responses' => 'Automatikus válaszok',
        'Auto Responses <-> Queue' => 'Automatikus válaszok <-> Várólista',
        'Attachments <-> Responses' => 'Levélmellékletek <-> Válaszok',
        'History::Move' => 'Történet::Mozgat',
        'History::TypeUpdate' => 'Updated Type to %s (ID=%s).',
        'History::ServiceUpdate' => 'Updated Service to %s (ID=%s).',
        'History::SLAUpdate' => 'Updated SLA to %s (ID=%s).',
        'History::NewTicket' => 'Történet::ÚjJegy',
        'History::FollowUp' => 'Történet::Válasz',
        'History::SendAutoReject' => 'Történet::AutomatikusElutasításKüldés',
        'History::SendAutoReply' => 'Történet::AutomatikusVálaszKüldés',
        'History::SendAutoFollowUp' => 'Történet::AutomatikusReakcióKüldés',
        'History::Forward' => 'Történet::Továbbít',
        'History::Bounce' => 'Történet::Visszaküld',
        'History::SendAnswer' => 'Történet::VálaszKüldés',
        'History::SendAgentNotification' => 'Történet::ÜgyintézõÉrtesítésKüldés',
        'History::SendCustomerNotification' => 'Történet::ÜgyfélÉrtesítésKüldés',
        'History::EmailAgent' => 'Történet::EmailÜgyintézõ',
        'History::EmailCustomer' => 'Történet::EmailÜgyfél',
        'History::PhoneCallAgent' => 'Történet::ÜgyintézõTelefonHívás',
        'History::PhoneCallCustomer' => 'Történet::ÜgyfélTelefonHívás',
        'History::AddNote' => 'Történet::MegjegyzésHozzáadás',
        'History::Lock' => 'Történet::Zárol',
        'History::Unlock' => 'Történet::Feloldás',
        'History::TimeAccounting' => 'Történet::IdõElszámolás',
        'History::Remove' => 'Történet::Eltávolítás',
        'History::CustomerUpdate' => 'Történet::ÜgyfélMódosítás',
        'History::PriorityUpdate' => 'Történet::PrioritásMódosítás',
        'History::OwnerUpdate' => 'Történet::TulajdonosVáltás',
        'History::LoopProtection' => 'Történet::VisszacsatolásVédelem',
        'History::Misc' => 'Történet::Vegyes',
        'History::SetPendingTime' => 'Történet::VárakozásiIdõBeállítás',
        'History::StateUpdate' => 'Történet::ÁllapotMódosítás',
        'History::TicketFreeTextUpdate' => 'Történet::JegySzabadSzövegMódosítás',
        'History::WebRequestCustomer' => 'Történet::ÜgyfélWebKérés',
        'History::TicketLinkAdd' => 'Történet::JegyCsatolásHozzáadás',
        'History::TicketLinkDelete' => 'Történet::JegyCsatolásTörlés',
        'History::Subscribe' => 'Added subscription for user "%s".',
        'History::Unsubscribe' => 'Removed subscription for user "%s".',

        # Template: AAAWeekDay
        'Sun' => 'Vas',
        'Mon' => 'Hét',
        'Tue' => 'Ked',
        'Wed' => 'Sze',
        'Thu' => 'Csü',
        'Fri' => 'Pén',
        'Sat' => 'Szo',

        # Template: AdminAttachmentForm
        'Attachment Management' => 'Levélmellékletek kezelése',

        # Template: AdminAutoResponseForm
        'Auto Response Management' => 'Automatikus válasz kezelõnek',
        'Response' => 'Válasz',
        'Auto Response From' => 'Automatikus válasz feladónak',
        'Note' => 'Megjegyzés',
        'Useable options' => 'Használható opciók',
        'To get the first 20 character of the subject.' => 'Az elsõ 20 karakter használata a tárgyból',
        'To get the first 5 lines of the email.' => 'Az elsõ 5 sor használata az e-mailbõl.',
        'To get the realname of the sender (if given).' => 'A küldõ valódi nevének használata (ha van ilyen)',
        'To get the article attribute (e. g. (<OTRS_CUSTOMER_From>, <OTRS_CUSTOMER_To>, <OTRS_CUSTOMER_Cc>, <OTRS_CUSTOMER_Subject> and <OTRS_CUSTOMER_Body>).' => 'A bejegyzés attributmának használata (pl. <OTRS_CUSTOMER_From>, <OTRS_CUSTOMER_To>, <OTRS_CUSTOMER_Cc>, <OTRS_CUSTOMER_Subject> és <OTRS_CUSTOMER_Body>).',
        'Options of the current customer user data (e. g. <OTRS_CUSTOMER_DATA_UserFirstname>).' => 'Az aktuális ügyfél adatai (pl.  <OTRS_CUSTOMER_DATA_UserFirstname>).',
        'Ticket owner options (e. g. <OTRS_OWNER_UserFirstname>).' => 'A jegy tulajdonosának adatai (pl.  <OTRS_OWNER_UserFirstname>).',
        'Ticket responsible options (e. g. <OTRS_RESPONSIBLE_UserFirstname>).' => 'A jegy felelõsének adatai (pl. <OTRS_RESPONSIBLE_UserFirstname>).',
        'Options of the current user who requested this action (e. g. <OTRS_CURRENT_UserFirstname>).' => 'A mûveletet végzõ felhasználónak adatai (pl. <OTRS_CURRENT_UserFirstname>).',
        'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>).' => 'A jegy adatai (pl. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>).',
        'Config options (e. g. <OTRS_CONFIG_HttpType>).' => 'Konfigurációs értékek (pl.  <OTRS_CONFIG_HttpType>).',

        # Template: AdminCustomerCompanyForm
        'Customer Company Management' => 'Ügyfél cégek kezelése',
        'Search for' => 'Keresendõ',
        'Add Customer Company' => 'Ügyfél cég hozzáadása',
        'Add a new Customer Company.' => 'Új ügyfél cég hozzadása',
        'List' => 'Lista',
        'This values are required.' => 'Ezen értékek megadása kötelezõ.',
        'This values are read only.' => 'Ezek az értékek csak olvashatók.',

        # Template: AdminCustomerUserForm
        'Customer User Management' => 'Ügyfél felhasználók kezelése',
        'Add Customer User' => 'Ügyfél felhasználó hozzáadása',
        'Source' => 'Forrás',
        'Create' => 'Létrehozás',
        'Customer user will be needed to have a customer history and to login via customer panel.' => 'Ügyfél felhasználó létrehozása szükséges, hogy legyenek ügyfélhez tartozó elõzmények és be lehessen lépni az ügyfél oldalon.',

        # Template: AdminCustomerUserGroupChangeForm
        'Customer Users <-> Groups Management' => 'Ügyfél felhasználók <-> Csoportok kezelése',
        'Change %s settings' => '%s beállításainak módosítása',
        'Select the user:group permissions.' => 'A felhasználó:csoport jogok kiválasztása.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the user).' => 'Ha nincs semmi kiválasztva, akkor nincsenek jogosultságok ebben a csoportban (a jegyek nem lesznek elérhetõk a felhasználónak).',
        'Permission' => 'Jogosultság',
        'ro' => 'Csak olvasás',
        'Read only access to the ticket in this group/queue.' => 'Csak olvasási jogosultság a jegyekhez ebben a csoportban/várólistában.',
        'rw' => 'Írás/Olvasás',
        'Full read and write access to the tickets in this group/queue.' => 'Teljes írás és olvasási jog a jegyekhez ebben a csoportban/várólistában.',

        # Template: AdminCustomerUserGroupForm

        # Template: AdminCustomerUserService
        'Customer Users <-> Services Management' => 'Ügyfél felhasználók <-> Szolgáltatások kezelése',
        'CustomerUser' => 'Ügyfél felhasználó',
        'Service' => 'Szolgáltatás',
        'Edit default services.' => '',
        'Search Result' => 'Keresési eredmény',
        'Allocate services to CustomerUser' => '',
        'Active' => 'Aktív',
        'Allocate CustomerUser to service' => '',

        # Template: AdminEmail
        'Message sent to' => 'Üzenet elküldve',
        'Recipents' => 'Címzettek',
        'Body' => 'Törzs',
        'Send' => 'Küldés',

        # Template: AdminGenericAgent
        'GenericAgent' => 'Automata ügyintézõ',
        'Job-List' => 'Teendõk listája',
        'Last run' => 'Utolsó végrehajtás',
        'Run Now!' => 'Végrehajtás most!',
        'x' => 'x',
        'Save Job as?' => 'Teendõk mentése másképp?',
        'Is Job Valid?' => 'Teendõ érvényes?',
        'Is Job Valid' => 'Teendõ érvényes',
        'Schedule' => 'Idõzítés',
        'Fulltext-Search in Article (e. g. "Mar*in" or "Baue*")' => 'Szöveg keresése a bejegyzésekben (pl. "Mar*in" or "Baue*")',
        '(e. g. 10*5155 or 105658*)' => 'pl. 10*5144 vagy 105658*',
        '(e. g. 234321)' => 'pl. 234321',
        'Customer User Login' => 'Ügyfél felhasználó belépés',
        '(e. g. U5150)' => 'pl. U5150',
        'SLA' => 'SLA',
        'Agent' => 'Ügyintézõ',
        'Ticket Lock' => 'Jegy zárolás',
        'TicketFreeFields' => 'Jegy szabad mezõi',
        'Create Times' => 'Létrehozási idõk',
        'No create time settings.' => 'Nincsenek létrehozási idõ beállítások.',
        'Ticket created' => 'Jegy létrehozva',
        'Ticket created between' => 'Jegy létrehozva idõpontok között:',
        'Close Times' => '',
        'No close time settings.' => '',
        'Ticket closed' => '',
        'Ticket closed between' => '',
        'Pending Times' => 'Várakozási idõk',
        'No pending time settings.' => 'Nincsenek várakozási idõ beállítások.',
        'Ticket pending time reached' => 'Várakozási idõ letelt',
        'Ticket pending time reached between' => 'Várakozási idõ letelt idõpontok között:',
        'New Service' => '',
        'New SLA' => '',
        'New Priority' => 'Új prioritás',
        'New Queue' => 'Új várólista',
        'New State' => 'Új állapot',
        'New Agent' => 'Új ügyintézõ',
        'New Owner' => 'Új tulajdonos',
        'New Customer' => 'Új ügyfél',
        'New Ticket Lock' => 'Jegy új zárolási állapota',
        'New Type' => '',
        'New Title' => '',
        'New Type' => '',
        'New TicketFreeFields' => 'Új jegy szabad mezõk',
        'Add Note' => 'Megjegyzés hozzáadása',
        'CMD' => 'PARANCS',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' => 'Ez a parancs lesz végrehajtva. Az ARG[0] lesz a jegy száma. Az ARG[1] lesz a jegy azonosítója.',
        'Delete tickets' => 'Jegyek törlése',
        'Warning! This tickets will be removed from the database! This tickets are lost!' => 'Figyelmeztetés! Ezek a jegyek el lesznek távolítva az adatbázisból! Ezek a jegyek elvesznek!',
        'Send Notification' => 'Értesítés küldése',
        'Param 1' => '1. paraméter',
        'Param 2' => '2. paraméter',
        'Param 3' => '3. paraméter',
        'Param 4' => '4. paraméter',
        'Param 5' => '5. paraméter',
        'Param 6' => '6. paraméter',
        'Send no notifications' => 'Ne küldjön értesítéseket',
        'Yes means, send no agent and customer notifications on changes.' => 'Igen esetén nem küld értesítésekes sem az ügyintézõnek, sem az ügyfélnek a változásokról.',
        'No means, send agent and customer notifications on changes.' => 'Nem esetén mind az ügyintézõnek, mind az ügyfélnek küld értesítéseket a változásokról.',
        'Save' => 'Mentés',
        '%s Tickets affected! Do you really want to use this job?' => '%s jegy érintett! Valóban el akarja végezni ezt a teendõt a jegyeken?',
        '"}' => '',

        # Template: AdminGroupForm
        'Group Management' => 'Csoportok kezelése',
        'Add Group' => 'Csoport hozzáadása',
        'Add a new Group.' => 'Új csoport hozzáadása',
        'The admin group is to get in the admin area and the stats group to get stats area.' => 'Az admin csoport megkapja az admin területet és a státusz csoport megkapja a státusz területet.',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).' => 'Hozzon létre új csoportot a különbözõ ügyintézõ csoportok (pl. beszerzõ osztály, támogató osztály, eladó osztály, ...) hozzáférési jogainak kezeléséhez.',
        'It\'s useful for ASP solutions.' => 'Ez hasznos ASP megoldásokhoz.',

        # Template: AdminLog
        'System Log' => 'Rendszernapló',
        'Time' => 'Idõ',

        # Template: AdminMailAccount
        'Mail Account Management' => '',
        'Host' => 'Kiszolgáló',
        'Trusted' => 'Megbízható',
        'Dispatching' => 'Szétválogatás',
        'All incoming emails with one account will be dispatched in the selected queue!' => 'Az összes fiókkal rendelkezõ bejövõ e-mail egy kiválasztott várólistához lesz rendelve!',
        'If your account is trusted, the already existing X-OTRS header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' => 'Ha az Ön fiókja megbízható, a már létezõ X-OTRS fejlécet használjuk beérkezéskor (prioritáshoz, ...)! Egyéb esetben a levelezési szûrõk lesznek alkalmazva.',

        # Template: AdminNavigationBar
        'Users' => 'Felhasználók',
        'Groups' => 'Csoportok',
        'Misc' => 'Egyéb',

        # Template: AdminNotificationForm
        'Notification Management' => 'Értesítéskezelés',
        'Notification' => 'Értesítés',
        'Notifications are sent to an agent or a customer.' => 'Az értesítések ügyintézõnek vagy ügyfélnek kerülnek elküldésre.',

        # Template: AdminPackageManager
        'Package Manager' => 'Csomagkezelõ',
        'Uninstall' => 'Eltávolítás',
        'Version' => 'Verzió',
        'Do you really want to uninstall this package?' => 'Valóban el akarja távolítani ezt a csomagot?',
        'Reinstall' => 'Újratelepítés',
        'Do you really want to reinstall this package (all manual changes get lost)?' => 'Valóban újra kívánja telepíteni ezt a csomagot (minden megváltoztatott beállítás elvész)?',
        'Continue' => 'Folytatás',
        'Install' => 'Telepítés',
        'Package' => 'Csomag',
        'Online Repository' => 'On-line csomagtároló',
        'Vendor' => 'Terjesztõ',
        'Upgrade' => 'Frissítés',
        'Local Repository' => 'Helyi csomagtároló',
        'Status' => 'Állapot',
        'Overview' => 'Áttekintés',
        'Download' => 'Letöltés',
        'Rebuild' => 'Újraépítés',
        'ChangeLog' => 'Változtatások',
        'Date' => 'Dátum',
        'Filelist' => 'Fájl lista',
        'Download file from package!' => 'Fájl letöltése a csomagból!',
        'Required' => 'Követlemények',
        'PrimaryKey' => '',
        'AutoIncrement' => '',
        'SQL' => 'SQL',
        'Diff' => '',

        # Template: AdminPerformanceLog
        'Performance Log' => 'Teljesítmény napló',
        'This feature is enabled!' => 'Ez a képesség aktív!',
        'Just use this feature if you want to log each request.' => 'Használja ezt a képességet amennyiben naplózni szeretne minden egyes kérést.',
        'Of couse this feature will take some system performance it self!' => 'Természetesen ez a képesség maga is befolyásolja a rendszer teljesítményét!',
        'Disable it here!' => 'Inaktiválja itt!',
        'This feature is disabled!' => 'Ez a képesség inaktív!',
        'Enable it here!' => 'Aktiválja itt!',
        'Logfile too large!' => 'A naplófájl túl nagy!',
        'Logfile too large, you need to reset it!' => 'A naplófájl túl nagy, kitörlése szükséges!',
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
        'PGP Management' => 'PGP kulcs kezelése',
        'Result' => 'Eredmények',
        'Identifier' => 'Azonosító',
        'Bit' => 'Bitek száma',
        'Key' => 'Kulcs',
        'Fingerprint' => 'Ujjlenyomat',
        'Expires' => 'Lejárati idõ',
        'In this way you can directly edit the keyring configured in SysConfig.' => 'Így közvetlenül szerkesztheti a kulcstartót amit a rendszer beállításainál beállított.',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => 'Levelezési szûrõk kezelése',
        'Filtername' => 'Szûrõ neve',
        'Match' => 'Egyezés',
        'Header' => 'Fejléc',
        'Value' => 'Érték',
        'Set' => 'Beállítás',
        'Do dispatch or filter incoming emails based on email X-Headers! RegExp is also possible.' => 'A beérkezõ e-mailek az X-Fejlécek alapján legyen hozzárendelve! Szabályos kifejezések alkalmazhatók.',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' => 'Amennyiben Ön csak az e-mail cím egyezését kívánja vizsgálni, akkor használja a EMAILADDRESS:info@example.com formulát a Feladó (From), Címzett (To) vagy Másolat (Cc) mezõkben.',
        'If you use RegExp, you also can use the matched value in () as [***] in \'Set\'.' => 'Ha szabályos kifejzéseket használ, használhatja a ()-ben levõ egyezõ értéket mint [***] a \'Beállítás\'-nál.',

        # Template: AdminQueueAutoResponseForm
        'Queue <-> Auto Responses Management' => 'Várólista <-> Automatikus válaszok kezelése',

        # Template: AdminQueueForm
        'Queue Management' => 'Várólisták kezelése',
        'Sub-Queue of' => 'Várólista alá tartozik',
        'Unlock timeout' => 'Feloldási idõtúllépés',
        '0 = no unlock' => '0 = nincs feloldás',
        'Only business hours are counted.' => '',
        'Escalation - First Response Time' => 'Kiemelés - Elsõ válasz ideje',
        '0 = no escalation' => '0 = nincs kiemelés',
        'Only business hours are counted.' => '',
        'Notify by' => '',
        'Escalation - Update Time' => 'Kiemelés - Frissítés ideje',
        'Notify by' => '',
        'Escalation - Solution Time' => 'Kiemelés - Megoldás ideje',
        'Follow up Option' => 'Válasz kezelése',
        'Ticket lock after a follow up' => 'Jegy zárolása válasz érkezése után.',
        'Systemaddress' => 'Rendszercím',
        'Customer Move Notify' => 'Ügyfél értesítése mozgatáskor',
        'Customer State Notify' => 'Ügyfél értesítése állapotváltozáskor',
        'Customer Owner Notify' => 'Ügyfél értesítése tulajdonosváltáskor',
        'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.' => 'Ha az ügyintézõ zárolja a jegyet és nem küld választ ezen idõn belül, a jegy zárolása megszûnik. Így a jegy látható lesz minden ügyintézõnek.',
        'Escalation time' => 'Kiemelési idõ',
        'If a ticket will not be answered in this time, just only this ticket will be shown.' => 'Ha a jegy nem kerül megválaszolásra a megadott idõn belül, csak ez a jegy lesz megjelenítve.',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.' => 'Ha a jegy le van zárva és az ügyfél válaszol a jegyre, akkor az zárolásra kerül a régi tulajdonos részére.',
        'Will be the sender address of this queue for email answers.' => 'Ennél a várólistánál ez lesz a feladó e-mail válaszokhoz.',
        'The salutation for email answers.' => 'A megszólítás az e-mail válaszokhoz.',
        'The signature for email answers.' => 'Az aláírás a válasz e-mailekhez.',
        'OTRS sends an notification email to the customer if the ticket is moved.' => 'Az OTRS értesítõ levelet küld az ügyfélnek ha a jegy áthelyezésre került.',
        'OTRS sends an notification email to the customer if the ticket state has changed.' => 'Az OTRS értesítõ levelet küld az ügyfélnek ha a jegy állapota megváltozott.',
        'OTRS sends an notification email to the customer if the ticket owner has changed.' => 'Az OTRS értesítõ levelet küld az ügyfélnek ha a jegy tulajdonosa megváltozott.',

        # Template: AdminQueueResponsesChangeForm
        'Responses <-> Queue Management' => 'Válaszok <-> Várlisták kezelése',

        # Template: AdminQueueResponsesForm
        'Answer' => 'Válasz',

        # Template: AdminResponseAttachmentChangeForm
        'Responses <-> Attachments Management' => 'Válaszok <-> Levélmellékletek kezelése',

        # Template: AdminResponseAttachmentForm

        # Template: AdminResponseForm
        'Response Management' => 'Reakció kezelés',
        'A response is default text to write faster answer (with default text) to customers.' => 'Egy reakció az alapértelmezett szöveg gyors válaszokhoz (az alapértelmezett szöveggel) az ügyfeleknek.',
        'Don\'t forget to add a new response a queue!' => 'Ne felejtsen el új reakciót hozzáadni a várólistához!',
        'The current ticket state is' => 'A jegy aktuális állapota',
        'Your email address is new' => 'Az ön e-mail címe új',

        # Template: AdminRoleForm
        'Role Management' => 'Szerepek kezelése',
        'Add Role' => 'Szerep hozzáadása',
        'Add a new Role.' => 'Új szerep hozzáadása',
        'Create a role and put groups in it. Then add the role to the users.' => 'Hozzon létre egy szerepet és tegyen bele csoportokat. Azután adja a szerepet a felhasználókhoz.',
        'It\'s useful for a lot of users and groups.' => 'Ez hasznos egy csomó felhasználónak és csoportnak',

        # Template: AdminRoleGroupChangeForm
        'Roles <-> Groups Management' => 'Szerepek <-> Csoportok kezelése',
        'move_into' => 'mozgat',
        'Permissions to move tickets into this group/queue.' => 'Jogosultságok jegyek áthelyezéséhez ebbe a csoportba/várólistába.',
        'create' => 'készít',
        'Permissions to create tickets in this group/queue.' => 'Jogosultságok új jegyek létrehozásához ebben a csoportban/várólistában.',
        'owner' => 'tulajdonos',
        'Permissions to change the ticket owner in this group/queue.' => 'Jogosultságok a jegy tulajdonosának megváltoztatásához ebben a csoportban/várólistában.',
        'priority' => 'prioritás',
        'Permissions to change the ticket priority in this group/queue.' => 'Jogosultágok a jegy prioritásnak megváltoztatásához ebben a csoportban/várólistában.',

        # Template: AdminRoleGroupForm
        'Role' => 'Szerep',

        # Template: AdminRoleUserChangeForm
        'Roles <-> Users Management' => 'Szerepek <-> Felhasználók kezelése',
        'Select the role:user relations.' => 'Válassza ki a szerep:felhasználó kapcsolatokat.',

        # Template: AdminRoleUserForm

        # Template: AdminSalutationForm
        'Salutation Management' => 'Megszólítások kezelése',
        'Add Salutation' => 'Megszólítás hozzáadása',
        'Add a new Salutation.' => 'Új megszólítás hozzáadása',

        # Template: AdminSelectBoxForm
        'SQL Box' => 'SQL parancsok',
        'Limit' => 'Sorok száma legfeljebb',
        'Go' => 'Indítás',
        'Select Box Result' => 'SQL parancs eredménye',

        # Template: AdminService
        'Service Management' => 'Szolgáltatások kezelése',
        'Add Service' => 'Szolgáltatás hozzáadása',
        'Add a new Service.' => 'Új szolgáltatás hozzáadása',
        'Sub-Service of' => 'Szolgátatása alá tartozik',

        # Template: AdminSession
        'Session Management' => 'Folyamatkezelés',
        'Sessions' => 'Folyamat',
        'Uniq' => 'Egyedi',
        'Kill all sessions' => 'Összes folyamat törlése',
        'Session' => 'Folyamat',
        'Content' => 'Tartalom',
        'kill session' => 'folyamat törlése',

        # Template: AdminSignatureForm
        'Signature Management' => 'Aláírások kezelése',
        'Add Signature' => 'Aláírás hozzáadása',
        'Add a new Signature.' => 'Új aláírás hozzáadása',

        # Template: AdminSLA
        'SLA Management' => 'SLA kezelése',
        'Add SLA' => 'SLA hozzáadása',
        'Add a new SLA.' => 'Új SLA hozzáadása',

        # Template: AdminSMIMEForm
        'S/MIME Management' => 'S/MIME kezelés',
        'Add Certificate' => 'Tanusítvány Hozzáadása',
        'Add Private Key' => 'Titkos Kulcs Hozáadása',
        'Secret' => 'Titok',
        'Hash' => 'Kivonat',
        'In this way you can directly edit the certification and private keys in file system.' => 'Íly módon közvetlenül szerkesztheti a fájlrendszeren tárolt tanusítványokat és titkos kulcsokat.',

        # Template: AdminStateForm
        'State Management' => 'Állapotok kezelése',
        'Add State' => 'Állapot hozzáadása',
        'Add a new State.' => 'Új állapot hozzáadása',
        'State Type' => 'Állapot típusa',
        'Take care that you also updated the default states in you Kernel/Config.pm!' => 'Figyeljen oda, hogy az Kernel/Config.pm fájlban is frissítse az alapértelmezett állapotokat!',
        'See also' => 'Lásd még',

        # Template: AdminSysConfig
        'SysConfig' => 'Rendszerbeállítások',
        'Group selection' => 'Csoport kiválasztása',
        'Show' => 'Megjelenítés',
        'Download Settings' => 'Beállítások letöltése',
        'Download all system config changes.' => 'Minden rendszerbeállítás modosítás letöltése.',
        'Load Settings' => 'Beállítások betöltése',
        'Subgroup' => 'Alcsoport',
        'Elements' => 'Elemek száma',

        # Template: AdminSysConfigEdit
        'Config Options' => 'Beállítási lehetõségek',
        'Default' => 'Alapértelmezett',
        'New' => 'Új',
        'New Group' => 'Új csoport',
        'Group Ro' => '',
        'New Group Ro' => '',
        'NavBarName' => '',
        'NavBar' => '',
        'Image' => '',
        'Prio' => '',
        'Block' => '',
        'AccessKey' => '',

        # Template: AdminSystemAddressForm
        'System Email Addresses Management' => 'Rendszer e-mail címek kezelése',
        'Add System Address' => 'Rendszer cím hozzáadása',
        'Add a new System Address.' => 'Új rendszer cím hozzáadása',
        'Realname' => 'Valódi név',
        'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!' => 'Az összes bejövõ e-mail ezzel az címzettel a kiválasztott várólistához lesz rendelve!',

        # Template: AdminTypeForm
        'Type Management' => 'Típusok kezelése',
        'Add Type' => 'Típus hozzáadása',
        'Add a new Type.' => 'Új típus hozzáadása',

        # Template: AdminUserForm
        'User Management' => 'Felhasználók kezelése',
        'Add User' => 'Felhasználó hozzáadása',
        'Add a new Agent.' => 'Új felhasználó hozzáadása',
        'Login as' => '',
        'Firstname' => 'Keresztnév',
        'Lastname' => 'Vezetéknév',
        'User will be needed to handle tickets.' => 'Felhasználó szükséges a jegyek kezeléséhez.',
        'Don\'t forget to add a new user to groups and/or roles!' => 'Ne felejtse el az új felhasználót hozzáadni csoportokhoz és/vagy szerepekhez!',

        # Template: AdminUserGroupChangeForm
        'Users <-> Groups Management' => 'Felhasználók <-> Csoportok kezelése',

        # Template: AdminUserGroupForm

        # Template: AgentBook
        'Address Book' => 'Címjegyzék',
        'Return to the compose screen' => 'Visszatérés a szerkesztõképernyõre',
        'Discard all changes and return to the compose screen' => 'Minden változtatás megsemmisítése és visszatérés a szerkesztõképernyõre',

        # Template: AgentCalendarSmall

        # Template: AgentCalendarSmallIcon

        # Template: AgentCustomerTableView

        # Template: AgentInfo
        'Info' => 'Info',

        # Template: AgentLinkObject
        'Link Object' => 'Objektumok összekapcsolása',
        'Select' => 'Kiválasztás',
        'Results' => 'Eredmények',
        'Total hits' => 'Összes találat',
        'Page' => 'Oldal',
        'Detail' => 'Részletek',

        # Template: AgentLookup
        'Lookup' => 'Keres',

        # Template: AgentNavigationBar

        # Template: AgentPreferencesForm

        # Template: AgentSpelling
        'Spell Checker' => 'Helyesírásellenõrzõ',
        'spelling error(s)' => 'helyesírási hiba(k)',
        'or' => 'vagy',
        'Apply these changes' => 'Módosítások érvényesítése',

        # Template: AgentStatsDelete
        'Do you really want to delete this Object?' => 'Valóban törölni szertné ezt az objektumot?',

        # Template: AgentStatsEditRestrictions
        'Select the restrictions to characterise the stat' => 'Válassza ki a megkötéseket a statsztika testre szabásához',
        'Fixed' => 'Rögzített',
        'Please select only one element or turn off the button \'Fixed\'.' => 'Kérem válasszon egy értéket vagy kapcsolja ki a \'Rögzített\' kapcsolót.',
        'Absolut Period' => 'Abszolút idõszak',
        'Between' => 'Idõszak:',
        'Relative Period' => 'Relatív idõszak',
        'The last' => 'A legutóbbi',
        'Finish' => 'Befejezés',
        'Here you can make restrictions to your stat.' => 'Itt megkötéseket adhat a statsztikához.',
        'If you remove the hook in the "Fixed" checkbox, the agent generating the stat can change the attributes of the corresponding element.' => 'Ha eltávolítja a "Rögzített" jelölõnégyzetet, akkor a statisztikát elõállítõ ügyintézõ megváltoztathatja az értékeit a megfelelõ tulajdonságnak.',

        # Template: AgentStatsEditSpecification
        'Insert of the common specifications' => 'Az általános beállítások megadása',
        'Permissions' => 'Jogosultságok',
        'Format' => 'Formátum',
        'Graphsize' => 'Grafikon mérete',
        'Sum rows' => 'Sorok összegzése',
        'Sum columns' => 'Oszlopok összegzése',
        'Cache' => 'Gyorsítótár',
        'Required Field' => 'Kötelezõ mezõk',
        'Selection needed' => 'Választák szükséges',
        'Explanation' => 'Magyarázat',
        'In this form you can select the basic specifications.' => 'Ezen a felületen elvégezheti az alapvetõ beállításokat.',
        'Attribute' => 'Tulajdonság',
        'Title of the stat.' => 'A statisztika címe.',
        'Here you can insert a description of the stat.' => 'Itt tudja megadni a statisztika leírását.',
        'Dynamic-Object' => 'Dinamikus objektum',
        'Here you can select the dynamic object you want to use.' => 'Itt tudja kiválasztani azt a dinamikus objektumot, amelyet hasznáni kíván.',
        '(Note: It depends on your installation how many dynamic objects you can use)' => '(Megjegyzés: A telepítéstõl függ mennyi dinamikus objektumot használhat.)',
        'Static-File' => 'Statikus fájl',
        'For very complex stats it is possible to include a hardcoded file.' => 'Nagyon összetett statisztikáknál lehetség elõre elkészített fájlok használata.',
        'If a new hardcoded file is available this attribute will be shown and you can select one.' => 'Ha rendelkezésre áll egy újabb elõre elkészített fájl akkor az itt megjelenik és választható közülük egyet.',
        'Permission settings. You can select one or more groups to make the configurated stat visible for different agents.' => 'Jogosultság beállítások. Kiválaszthat egy vagy több csoportot, hogy a beállított statisztikát megtekinthetõvé tegye a különbözõ ügyintézõk számára.',
        'Multiple selection of the output format.' => 'Több kimeneti formátum kiválasztása.',
        'If you use a graph as output format you have to select at least one graph size.' => 'Amennyiben grafikont is kiválasztott, mint kimeneti formátum, úgy ki kell választania legalább egy grafikon méretet.',
        'If you need the sum of every row select yes' => 'Amennyiben a sorok összegzésére van szüksége, akkor válassza az igent.',
        'If you need the sum of every column select yes.' => 'Amennyiben az oszlopok összegzésére van szüksége, akkor válassza az igent.',
        'Most of the stats can be cached. This will speed up the presentation of this stat.' => 'A statisztikák többsége használhat gyorsítótárat. Ez gyorsítja az elkészítését a statisztikának.',
        '(Note: Useful for big databases and low performance server)' => '(Megyjegyzés: Ez hasznos nagy méretû adatbázisoknál és ki teljesítményû kiszolgáló használata esetén.)',
        'With an invalid stat it isn\'t feasible to generate a stat.' => 'Érvénytelen statisztika esetén nem lehetséges a statiszika elõállítása.',
        'This is useful if you want that no one can get the result of the stat or the stat isn\'t ready configurated.' => 'Ez akkor hasznos, ha nem akarja, hogy valaki elérje a statisztika eredményét vagy a statsztika nincsen még teljesen beállítva.',

        # Template: AgentStatsEditValueSeries
        'Select the elements for the value series' => 'Válassza ki a tulajdonságokat a grafikonon megjelenõ értékekhez',
        'Scale' => 'Skála',
        'minimal' => '',
        'Please remember, that the scale for value series has to be larger than the scale for the X-axis (e.g. X-Axis => Month, ValueSeries => Year).' => '',
        'Here you can the value series. You have the possibility to select one or two elements. Then you can select the attributes of elements. Each attribute will be shown as single value series. If you don\'t select any attribute all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' => 'Itt kiválaszthatja a grafikonon megjelenõ értékeket. Egy vagy két tulajdonságot jelölhet ki. Után kiválaszthatja a tulajdonság értékeit. Minden érték külön kerül ábrázolásra a grafikonon. Ha nem választ ki egyetlen értéket sem a tulajdonsághoz, akkor az összes érték használva lesz a statisztika létrehozásakor. Szintén hozzáadásra kerülnek a legutóbbi beállítás óta létrejött új értékek is.',

        # Template: AgentStatsEditXaxis
        'Select the element, which will be used at the X-axis' => 'Válassza ki a tulajdonságot, amely az X tengelyen fog megjelenni.',
        'maximal period' => '',
        'minimal scale' => '',
        'Here you can define the x-axis. You can select one element via the radio button. Then you you have to select two or more attributes of the element. If you make no selection all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' => 'Itt állíthatja be az X tengelyt. Válasszon egyet a rádió gombok közül. Utána válassza ki két vagy több értékét a tulajdonságnak. Ha nem választ ki egyetlen értéket sem a tulajdonsághoz, akkor az összes érték használva lesz a statisztika létrehozásakor. Szintén hozzáadásra kerülnek a legutóbbi beállítás óta létrejött új értékek is.',

        # Template: AgentStatsImport
        'Import' => 'Importálás',
        'File is not a Stats config' => 'A fájl nem egy statisztika beállítás fájl',
        'No File selected' => 'Nincsen fájl kiválasztva',

        # Template: AgentStatsOverview
        'Object' => 'Objektum',

        # Template: AgentStatsPrint
        'Print' => 'Nyomtatás',
        'No Element selected.' => 'Nincsen érték kiválasztva.',

        # Template: AgentStatsView
        'Export Config' => 'Beállítások exportálása',
        'Informations about the Stat' => 'Információ a statisztikáról',
        'Exchange Axis' => 'Tengelyek fölcserélése',
        'Configurable params of static stat' => '',
        'No element selected.' => 'Nincsenek ertékek kiválasztva.',
        'maximal period from' => '',
        'to' => '',
        'Start' => 'Start',
        'With the input and select fields you can configurate the stat at your needs. Which elements of a stat you can edit depends on your stats administrator who configurated the stat.' => 'A bemeneti és kiválasztható mezõkkel kiválaszthatja a kívánt statisztikát. Az Ön által szerkeszthetõ statisztika értékek a statisztikát beállító adminisztrátortól függnek.',

        # Template: AgentTicketBounce
        'Bounce ticket' => 'Jegy visszaküldése',
        'Ticket locked!' => 'Jegy zárolva!',
        'Ticket unlock!' => 'Jegy feloldása!',
        'Bounce to' => 'Visszaküldés ide:',
        'Next ticket state' => 'A jegy következõ állapota',
        'Inform sender' => 'Küldõ tájékoztatása',
        'Send mail!' => 'E-mail küldése!',

        # Template: AgentTicketBulk
        'Ticket Bulk Action' => 'Csoportos jegy-mûvelet',
        'Spell Check' => 'Helyesírásellenõrzés',
        'Note type' => 'Jegyzet típusa',
        'Unlock Tickets' => 'Jegyek feloldása',

        # Template: AgentTicketClose
        'Close ticket' => 'Jegy lezárása',
        'Previous Owner' => 'Korábbi tulajdonos',
        'Inform Agent' => 'Ügyintézõ értsítése',
        'Optional' => 'Nem kötelezõ',
        'Inform involved Agents' => 'Érintett ügyintézõk értesítése',
        'Attach' => 'Csatolás',
        'Next state' => 'Következõ állapot',
        'Pending date' => 'Várakozási dátum',
        'Time units' => 'Idõ egységek',

        # Template: AgentTicketCompose
        'Compose answer for ticket' => 'Válaszadás a jegyre',
        'Pending Date' => 'Várakozás dátuma',
        'for pending* states' => 'várakozó* státuszhoz',

        # Template: AgentTicketCustomer
        'Change customer of ticket' => 'A jegyhez tartozó ügyfél megváltoztatása',
        'Set customer user and customer id of a ticket' => 'A jegyhez tartozó ügyfél felhasználónak és ügyfél azonosítónak beállítása',
        'Customer User' => 'Ügyfél felhasználó',
        'Search Customer' => 'Ügyfél keresése',
        'Customer Data' => 'Ügyfél adatok',
        'Customer history' => 'Ügyfél történet',
        'All customer tickets.' => 'Összes ügyfél jegy.',

        # Template: AgentTicketCustomerMessage
        'Follow up' => 'Válasz',

        # Template: AgentTicketEmail
        'Compose Email' => 'Új e-mail írása',
        'new ticket' => 'új jegy',
        'Refresh' => 'Frissítés',
        'Clear To' => 'Mezõ törlése',

        # Template: AgentTicketEscalationView
        'Ticket Escalation View' => '',
        'Escalation' => '',
        'Today' => '',
        'Tomorrow' => '',
        'Next Week' => '',
        'up' => 'fel',
        'down' => 'le',
        'Escalation' => '',
        'Locked' => 'Zárolás',

        # Template: AgentTicketForward
        'Article type' => 'Bejegyzés típusa',

        # Template: AgentTicketFreeText
        'Change free text of ticket' => 'Szabad szöveg változtatása a jegyben',

        # Template: AgentTicketHistory
        'History of' => 'Elõzmények:',

        # Template: AgentTicketLocked

        # Template: AgentTicketMailbox
        'Mailbox' => 'Postafiók',
        'Tickets' => 'Jegyek',
        'of' => 'kitõl',
        'Filter' => 'Szûrõ',
        'New messages' => 'Új üzenetek',
        'Reminder' => 'Emlékeztetõ',
        'Sort by' => 'Rendezés így',
        'Order' => 'Sorrend',

        # Template: AgentTicketMerge
        'Ticket Merge' => 'Jegy egyesítése',
        'Merge to' => 'Befogadó',

        # Template: AgentTicketMove
        'Move Ticket' => 'Jegy áthelyezése',

        # Template: AgentTicketNote
        'Add note to ticket' => 'Megjegyzés hozzáadása a jegyhez',

        # Template: AgentTicketOwner
        'Change owner of ticket' => 'Jegy tulajdonosának módosítása',

        # Template: AgentTicketPending
        'Set Pending' => 'Várakozás beállítás',

        # Template: AgentTicketPhone
        'Phone call' => 'Telefonhívás',
        'Clear From' => 'Mezõ törlése',

        # Template: AgentTicketPhoneOutbound

        # Template: AgentTicketPlain
        'Plain' => 'Egyszerû',

        # Template: AgentTicketPrint
        'Ticket-Info' => 'Jegy információ',
        'Accounted time' => 'Elszámolt idõ',
        'First Response Time' => 'Elsõ válaszidõ',
        'Update Time' => 'Frissítés ideje',
        'Solution Time' => 'Megoldás ideje',
        'Linked-Object' => 'Kapcsolódó objektum',
        'Parent-Object' => 'Szülõ objektum',
        'Child-Object' => 'Gyerek objektum',
        'by' => 'általa:',

        # Template: AgentTicketPriority
        'Change priority of ticket' => 'Jegy prioritásának módosítása',

        # Template: AgentTicketQueue
        'Tickets shown' => 'Mutatott jegyek',
        'Tickets available' => 'Elérhetõ jegyek',
        'All tickets' => 'Összes jegy',
        'Queues' => 'Várólisták',
        'Ticket escalation!' => 'Jegy kiemelése!',

        # Template: AgentTicketQueueTicketView
        'Service Time' => 'Szolgáltatás ideje',
        'Your own Ticket' => 'Az ön saját jegye',
        'Compose Follow up' => 'Válasz írása',
        'Compose Answer' => 'Válasz írása',
        'Contact customer' => 'Kapcsolatbalépés az ügyféllel',
        'Change queue' => 'Várólista megváltoztatása',

        # Template: AgentTicketQueueTicketViewLite

        # Template: AgentTicketResponsible
        'Change responsible of ticket' => 'Jegy felelõsének megváltoztatása',

        # Template: AgentTicketSearch
        'Ticket Search' => 'Jegy keresés',
        'Profile' => 'Profil',
        'Search-Template' => 'Keresõ sablon',
        'TicketFreeText' => 'Jegy szabadszöveg',
        'Created in Queue' => 'Létrehozáskori várólista',
        'Close Times' => '',
        'No close time settings.' => '',
        'Ticket closed' => '',
        'Ticket closed between' => '',
        'Result Form' => 'Eredmény ürlap',
        'Save Search-Profile as Template?' => 'Elmenti a keresõ profilt sablonként?',
        'Yes, save it with name' => 'Igen, elmentve ezen a néven',

        # Template: AgentTicketSearchOpenSearchDescription

        # Template: AgentTicketSearchResult
        'Change search options' => 'Keresési beállítások módosítása',

        # Template: AgentTicketSearchResultPrint
        '"}' => '',

        # Template: AgentTicketSearchResultShort

        # Template: AgentTicketStatusView
        'Ticket Status View' => 'Jegy állapotának megtekintése',
        'Open Tickets' => 'Jegyek megnyitása',

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
        'Traceback' => 'Visszakövetés',

        # Template: CustomerFooter
        'Powered by' => 'Készítette',

        # Template: CustomerFooterSmall

        # Template: CustomerHeader

        # Template: CustomerHeaderSmall

        # Template: CustomerLogin
        'Login' => 'Belépés',
        'Lost your password?' => 'Elfelejtette a jelszavát?',
        'Request new password' => 'Új jelszó kérése',
        'Create Account' => 'Azonosító létrehozása',

        # Template: CustomerNavigationBar
        'Welcome %s' => 'Üdvözöljük %s',

        # Template: CustomerPreferencesForm

        # Template: CustomerStatusView

        # Template: CustomerTicketMessage

        # Template: CustomerTicketPrint

        # Template: CustomerTicketSearch
        'Times' => 'Idõk',
        'No time settings.' => 'Nincs idõbeállítás.',

        # Template: CustomerTicketSearchResultCSV

        # Template: CustomerTicketSearchResultPrint

        # Template: CustomerTicketSearchResultShort

        # Template: CustomerTicketZoom

        # Template: CustomerWarning

        # Template: Error
        'Click here to report a bug!' => 'Kattintson ide új hiba bejelentéséhez!',

        # Template: Footer
        'Top of Page' => 'Lap teteje',

        # Template: FooterSmall

        # Template: Header

        # Template: HeaderSmall

        # Template: Installer
        'Web-Installer' => 'Web-telepítõ',
        'Welcome to %s' => 'Üdvözli az %s',
        'Accept license' => 'Lincensz elfogadása',
        'Don\'t accept license' => 'Licensz elutasítása',
        'Admin-User' => 'Adminisztrátor felhasználó',
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty. For security reasons we do recommend setting a root password. For more information please refer to your database documentation.' => '',
        'Admin-Password' => 'Adminisztrátor jelszó',
        'Database-User' => 'Adatbázis felhasználó',
        'default \'hot\'' => 'alapértelmezett',
        'DB connect host' => 'Adatbázis kiszolgáló',
        'Database' => 'Adatbázis',
        'Default Charset' => 'Alapértelmezett karakterkészlet',
        'utf8' => '',
        'false' => 'hamis',
        'SystemID' => 'Rendszer azonosító',
        '(The identify of the system. Each ticket number and each http session id starts with this number)' => '(Azonosítás a rendszerben. Minden jegyhez és minden http eljárás ezzel a sorszámmal indul)',
        'System FQDN' => 'Rendszer FQDN',
        '(Full qualified domain name of your system)' => '(Teljes ellenõrzött domain név a rendszerben)',
        'AdminEmail' => 'AdminEmail',
        '(Email of the system admin)' => '(A rendszergazda e-mailje)',
        'Organization' => 'Szervezet',
        'Log' => '',
        'LogModule' => 'Log modul',
        '(Used log backend)' => '(Használt háttér log)',
        'Logfile' => 'Log file',
        '(Logfile just needed for File-LogModule!)' => '(Logfile szükséges a File-LogModul számára!)',
        'Webfrontend' => 'Webes felhasználói felület',
        'Use utf-8 it your database supports it!' => 'Használd utf-8-at az adatbázis támogatásoknál!',
        'Default Language' => 'Alapértelmezett nyelv',
        '(Used default language)' => '(A felhasználó alapértelmezett nyelve)',
        'CheckMXRecord' => 'MX Rekord ellenõrzés',
        '(Checks MX recordes of used email addresses by composing an answer. Don\'t use CheckMXRecord if your OTRS machine is behinde a dial-up line $!)' => '(Ellenõrizd le az MX rekordot a használt email címben a válasz írásakor!)',
        'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' => 'Ahhoz, hogy az OTRS-t használni tudja, a következõ parancsot kell begépelnie parancssorban (terminálban/héjjban) root-ként.',
        'Restart your webserver' => 'Indítsa újra a web-kiszolgálót',
        'After doing so your OTRS is up and running.' => 'Ha ez kész, az OTRS kész és fut.',
        'Start page' => 'Start oldal',
        'Your OTRS Team' => 'Az ön OTRS csapata',

        # Template: Login

        # Template: Motd

        # Template: NoPermission
        'No Permission' => 'Nincs jogosultság',

        # Template: Notify
        'Important' => 'Fontos',

        # Template: PrintFooter
        'URL' => 'URL',

        # Template: PrintHeader
        'printed by' => 'Nyomtatta',

        # Template: Redirect

        # Template: Test
        'OTRS Test Page' => 'OTRS tesztoldal',
        'Counter' => 'Számláló',

        # Template: Warning
        # Misc
        'auto follow up' => 'automatikus válasz',
        'Create Database' => 'Adatbázis létrehozása',
        'verified' => 'ellenõrzött',
        'File-Name' => '',
        'Ticket Number Generator' => 'Jegy sorszám generátor',
        '(Ticket identifier. Some people want toset this to e. g. \'Ticket#\', \'Call#\' or \'MyTicket#\')' => '(Jegy azonosítás. pl. \'Jegy#\', \'Hívó#\' vagy \'Jegyem#\')',
        'In this way you can directly edit the keyring configured in Kernel/Config.pm.' => 'Íly módon közvetlenül szerkesztheti a Kernel/Config.pm-ben beállított kulcskarikát.',
        'Create new Phone Ticket' => 'Új telefon jegy létrehozása',
        'U' => 'A',
        'A message should have a To: recipient!' => 'Egy üzenethez kellene legyen címzett!',
        'Site' => 'Gép',
        'Reset of unlock time.' => 'Feloldási idõ nullázása.',
        'Customer history search (e. g. "ID342425").' => 'Keresés az ügyfél történetében (pl. "ID342425").',
        'Close!' => 'Lezár!',
        'for agent firstname' => 'ügyintézõ keresztnévhez',
        'Reporter' => '',
        'The message being composed has been closed.  Exiting.' => 'Az éppen elkészült levél lezárásra került. Kilépés.',
        'Process-Path' => '',
        'to get the realname of the sender (if given)' => 'hogy megkapja a feladó valódi nevét (ha lehetséges)',
        'FAQ Search Result' => '',
        'Notification (Customer)' => 'Értesítés (Ügyfél)',
        'Select Source (for add)' => 'Válassza ki a forrsát (hozzáadáshoz)',
        'Node-Name' => '',
        'Options of the ticket data (e. g. &lt;OTRS_TICKET_Number&gt;, &lt;OTRS_TICKET_ID&gt;, &lt;OTRS_TICKET_Queue&gt;, &lt;OTRS_TICKET_State&gt;)' => '',
        'Agent updated!' => 'Ügyintézõ módosítva!',
        'Home' => 'Otthon',
        'Workflow Groups' => '',
        'Current Impact Rating' => '',
        'Config options (e. g. <OTRS_CONFIG_HttpType>)' => 'Beállítás opciók (pl. <OTRS_CONFIG_HttpType>)',
        'FAQ System History' => '',
        'customer realname' => 'ügyfél valódi név',
        'Pending messages' => 'Várakozó üzenetek',
        'auto reply/new ticket' => 'automatikus válasz/új jegy',
        'Modules' => 'Modul',
        'for agent login' => 'ügyintézõ belépéséhez',
        'Keyword' => 'Kulcsszó',
        'Reference' => '',
        'with' => '',
        'Close type' => 'Típus lezárása',
        'DB Admin User' => 'DB Admin felhasználó',
        'for agent user id' => 'ügynük felhasználó azonosítójához',
        'sort upward' => 'rendezés felfelé',
        'Classification' => 'Besorolás',
        'Change user <-> group settings' => 'A felhasználó <-> csoport beállítások megváltoztatása',
        'next step' => 'következõ lépés',
        'Customer history search' => 'Keresés az ügyfél történetében',
        'not verified' => 'nem ellenõrzött',
        'Stat#' => 'Stat#',
        'Create new database' => 'Új adatbázis létrehozása',
        'auto reject' => 'automatikus visszautasítás',
        'Year' => 'Év',
        'A message must be spell checked!' => 'Az üzenetnek helyesírásellenõrzésen kell átmennie!',
        'X-axis' => 'X tengely',
        'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further informations.' => 'Az ön "<OTRS_TICKET>" számú jegyhez rendelt e-mailje visszaküldésre került a "<OTRS_BOUNCE_TO>" címre. Vegye fel ezzel a címmel a kapcsolatot további információkért.',
        'A message should have a body!' => 'Egy üzenetnek kell legyen törzse!',
        'All Agents' => 'Minden ügyintézõ',
        'Keywords' => 'Kulcsszó',
        'No * possible!' => 'A "*" nem lehetséges!',
        'Load' => 'Betöltés',
        'Change Time' => 'Idõ megváltoztatása',
        'PostMaster Filter' => 'Levelezési szûrõk',
        'Options of the current user who requested this action (e. g. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)' => '',
        'PostMaster POP3 Account' => 'Levelezési fiókok (POP3)',
        'Message for new Owner' => 'Üzenet az új tulajdonosnak',
        'to get the first 5 lines of the email' => 'hogy megkapja az elsõ 5 sort az e-mailbõl',
        'Default Sign Key' => 'Alapértelmezett aláíró kulcs',
        'OTRS DB Password' => 'OTRS DB jelszó',
        'Last update' => 'Utolsó frissítés',
        'not rated' => '',
        'to get the first 20 character of the subject' => 'hogy megkapja az elsõ 20 karaktert a tárgyból',
        'Select the customeruser:service relations.' => 'Válassza ki az ügyfél felhasználó:szolgáltatás relációt.',
        'DB Admin Password' => 'DB Admin jelszó',
        'Drop Database' => 'Adatbázis törlése',
        'Options of the current customer user data (e. g. <OTRS_CUSTOMER_DATA_UserFirstname>)' => 'Opciók az aktuális ügyfél felhasználói adatokhoz (pl. <OTRS_CUSTOMER_DATA_UserFirstname>)',
        'Pending type' => 'Várakozás típusa',
        'Comment (internal)' => 'Megjegyzés (belsõ)',
        'Ticket owner options (e. g. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)' => 'Jegy tulajdonosának adatai (pl. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)',
        'This window must be called from compose window' => 'Ezt az ablakot a szerkesztõ ablakból kell hívni',
        'User-Number' => '',
        'You need min. one selected Ticket!' => 'Legalább egy jegyet ki kell választani!',
        'Reset of escalation time.' => 'Kiemelési idõ nullázása.',
        'System Address updated!' => 'Rendszer cím módosítva!',
        'Options of the ticket data (e. g. <OTRS_TICKET_Number>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' => '',
        '(Used ticket number format)' => '(Nyitott jegyek sorszámának formátuma)',
        'Fulltext' => 'Teljes szöveg',
        'Month' => 'Hónap',
        'SessionID invalid! Need user data!' => 'Hibás folyamat azonosító! Felhasználói adatok megadása szükséges!',
        'Node-Address' => '',
        'All Agent variables.' => '',
        ' (work units)' => ' (munkaegység)',
        'You use the DELETE option! Take care, all deleted Tickets are lost!!!' => 'A TÖRLÉS opciót használja! Legyen óvatos, az összes törölt jegy elveszik!!!',
        'All Customer variables like defined in config option CustomerUser.' => 'Az összes ügyfél változó ahogyan az Ügyfél felhasználó opcióknál lett beállítva.',
        'for agent lastname' => 'ügyintézõ családinévhez',
        'Options of the current user who requested this action (e. g. <OTRS_CURRENT_UserFirstname>)' => 'Opciók a aktuális felhasználónál aki kérte ezt az eljárást. (pl. <OTRS_CURRENT_UserFirstname>)',
        'Reminder messages' => 'Emlékeztetõ üzenetek',
        'A message should have a subject!' => 'Egy üzenetnek kell legyen tárgya!',
        'TicketZoom' => 'JegyRészletek',
        'Don\'t forget to add a new user to groups!' => 'Ne felejtsen el új felhasználót hozzáadni a csoportokhoz!',
        'You need a email address (e. g. customer@example.com) in To:!' => 'Kell egy e-mail cím (pl. customer@example.com) címzettnek!',
        'CreateTicket' => 'JegyLétrehozás',
        'unknown' => 'ismeretlen',
        'You need to account time!' => 'El kell számolnia az idõvel!',
        'System Settings' => 'Rendszerbeállítások',
        'Finished' => 'Befejezve',
        'Imported' => '',
        'unread' => 'olvasatlan',
        'Split' => 'Felosztás',
        'D' => 'Z',
        'System Status' => 'Rendszer állapota',
        'All messages' => 'Minden üzenet',
        'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' => 'A jegy adatai (pl.  <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)',
        'A article should have a title!' => 'Egy bejegyzésnek kell legyen címe!',
        'Customer Users <-> Services' => 'Ügyfél felhasználók <-> Szolgáltatások',
        'Config options (e. g. &lt;OTRS_CONFIG_HttpType&gt;)' => 'Konfigurációs értékek (pl. &lt;OTRS_CONFIG_HttpType&gt;)',
        'Event' => 'Esemény',
        'Imported by' => '',
        'S/MIME' => 'S/MIME',
        'Ticket owner options (e. g. <OTRS_OWNER_UserFirstname>)' => 'Jegy tulajdonos opciók (pl. <OTRS_OWNER_UserFirstname>)',
        'read' => 'olvasott',
        'Product' => 'Termék',
        'Name is required!' => 'A nevet meg kell adni!',
        'kill all sessions' => 'Minden eljárás kilövése',
        'to get the from line of the email' => 'hogy megkapja a feladót az e-mailbõl',
        'Solution' => 'Megoldás',
        'auto reply' => 'automatikus válasz',
        'QueueView' => 'Várólista nézet',
        'My Queue' => 'Saját várólistám',
        'Select Box' => 'SQL lekérdezés',
        'Instance' => '',
        'Day' => 'Nap',
        'auto remove' => 'automatikus törlés',
        'Service-Name' => 'Szolgáltatás neve',
        'Welcome to OTRS' => 'Üdvözli az OTRS',
        'tmp_lock' => 'ideiglenesen zárolt',
        'modified' => 'módosított',
        'Escalation in' => 'Kiemelés ebben',
        'Delete old database' => 'Régi adatbázis törlése',
        'sort downward' => 'rendezés lefelé',
        'You need to use a ticket number!' => 'Adja meg egy jegy számát!',
        'Watcher' => '',
        'Have a lot of fun!' => 'Sok sikert!',
        'send' => 'küldés',
        'Note Text' => 'Jegyzet szöveg',
        'POP3 Account Management' => 'Levelezési POP3 fiókok kezelése',
        'Options of the current customer user data (e. g. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)' => 'Az aktuális ügyfél felhasználó adatai (pl. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)',
        'System State Management' => 'Rendszerállapot kezelés',
        'PhoneView' => 'TelefonNézet',
        'User-Name' => 'Felhasználónév',
        'File-Path' => '',
        'Modified' => 'Módosítva',
        'Ticket selected for bulk action!' => 'Jegy kiválasztva csoportos mûvelethez!',
    };
    # $$STOP$$
    return;
}

1;
