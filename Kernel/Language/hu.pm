# --
# Kernel/Language/hu.pm - provides de language translation
# Copyright (C) 2004 RLAN Internet <MAGIC at rlan.hu>
# --
# $Id: hu.pm,v 1.35 2007-05-29 12:52:58 martin Exp $
# Translation: Gabor Gancs /gg@magicnet.hu/ & Krisztian Gancs /krisz@gancs.hu/
# Verify: Flora Szabo /szaboflora@magicnet.hu/
# Hungary Sopron Europe
#
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Language::hu;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.35 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

sub Data {
    my $Self = shift;
    my %Param = @_;

    # $$START$$
    # Last translation file sync: Tue May 29 14:48:53 2007

    # possible charsets
    $Self->{Charset} = ['iso-8859-2', 'iso-8859-15', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Jear;)
    $Self->{DateFormat} = '%Y.%M.%D %T';
    $Self->{DateFormatLong} = '%Y %B %D %A %T';
    $Self->{DateFormatShort} = '%Y.%M.%D';
    $Self->{DateInputFormat} = '%Y.%M.%D';
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
        'last' => 'utolsó',
        'before' => 'elõtt',
        'day' => 'nap',
        'days' => 'nap',
        'day(s)' => 'nap',
        'hour' => 'óra',
        'hours' => 'óra',
        'hour(s)' => '',
        'minute' => 'Perc',
        'minutes' => 'perc',
        'minute(s)' => '',
        'month' => '',
        'months' => '',
        'month(s)' => 'hónap',
        'week' => '',
        'week(s)' => 'hét',
        'year' => '',
        'years' => '',
        'year(s)' => 'év',
        'second(s)' => '',
        'seconds' => '',
        'second' => '',
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
        '* invalid' => '',
        'invalid-temporarily' => '',
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
        '-none-' => '',
        'none' => 'semmi',
        'none!' => 'semmi!',
        'none - answered' => 'semmi - megválaszolt',
        'please do not edit!' => 'kérjük ne javítsa!',
        'AddLink' => 'Link hozzáadása',
        'Link' => 'Hivatkozás',
        'Linked' => '',
        'Link (Normal)' => '',
        'Link (Parent)' => '',
        'Link (Child)' => '',
        'Normal' => 'Normál',
        'Parent' => '',
        'Child' => '',
        'Hit' => 'Találat',
        'Hits' => 'Találat',
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
        'CustomerID' => 'Ügyfél#',
        'CustomerIDs' => '',
        'customer' => 'ügyfél',
        'agent' => 'Ügynök',
        'system' => 'rendszer',
        'Customer Info' => 'Ügyfél Info',
        'Customer Company' => '',
        'Company' => '',
        'go!' => 'Indítsd!',
        'go' => 'indítsd',
        'All' => 'Összes',
        'all' => 'összes',
        'Sorry' => 'Sajnálom',
        'update!' => 'Frissít!',
        'update' => 'frissít',
        'Update' => 'Frissít',
        'submit!' => 'Elküld!',
        'submit' => 'elküld',
        'Submit' => '',
        'change!' => 'Változtat!',
        'Change' => 'Változtat',
        'change' => 'változtat',
        'click here' => 'kattints ide',
        'Comment' => 'Megjegyzés',
        'Valid' => 'Érvényes',
        'Invalid Option!' => '',
        'Invalid time!' => '',
        'Invalid date!' => '',
        'Name' => 'Név',
        'Group' => 'Csoport',
        'Description' => 'Leírás',
        'description' => 'leírás',
        'Theme' => 'Téma',
        'Created' => 'Elkészítve',
        'Created by' => '',
        'Changed' => '',
        'Changed by' => '',
        'Search' => 'Keresés',
        'and' => 'és',
        'between' => '',
        'Fulltext Search' => '',
        'Data' => '',
        'Options' => 'Beállítások',
        'Title' => 'Cím',
        'Item' => '',
        'Delete' => 'Töröl',
        'Edit' => 'Szerkeszt',
        'View' => 'Nézet',
        'Number' => '',
        'System' => 'Rendszer',
        'Contact' => 'Kapcsolat',
        'Contacts' => '',
        'Export' => '',
        'Up' => '',
        'Down' => '',
        'Add' => 'Hozzáad',
        'Category' => 'Kategória',
        'Viewer' => '',
        'New message' => 'Új üzenet',
        'New message!' => 'Új üzenet!',
        'Please answer this ticket(s) to get back to the normal queue view!' => 'Kérjük válaszoljon erre(ezekre) a jegy(ek)re hogy visszatérhessen a normál ügyek nézethez!',
        'You got new message!' => 'Új üzenete érkezett!',
        'You have %s new message(s)!' => '%s új üzenete van!',
        'You have %s reminder ticket(s)!' => '%s emlékeztetõ jegye van!',
        'The recommended charset for your language is %s!' => 'Az ajánlott karakterkészlet az ön nyelvénél %s!',
        'Passwords doesn\'t match! Please try it again!' => 'A jelszavak nem egyeznek! Próbálja meg újra!',
        'Password is already in use! Please use an other password!' => '',
        'Password is already used! Please use an other password!' => '',
        'You need to activate %s first to use it!' => '',
        'No suggestions' => 'Nincsenek javaslatok',
        'Word' => 'Szó',
        'Ignore' => 'Figyelmen kívül hagy',
        'replace with' => 'csere ezzel',
        'There is no account with that login name.' => 'Azzal a névvel nincs azonosító.',
        'Login failed! Your username or password was entered incorrectly.' => 'Belépés sikertelen! Hibásan adta meg a felhasználói nevét vagy jelszavát.',
        'Please contact your admin' => 'Kérjük vegye fel a kapcsolatot a rendszergazdájával',
        'Logout successful. Thank you for using OTRS!' => 'Kilépés rendben! Köszönjük, hogy az OTRS-t használja!',
        'Invalid SessionID!' => 'Hibás SessionID!',
        'Feature not active!' => 'Képesség nem aktív!',
        'Login is needed!' => '',
        'Password is needed!' => '',
        'License' => 'Licenc',
        'Take this Customer' => 'Átveszi ez az ügyfél',
        'Take this User' => 'Átveszi ez a felhasználó',
        'possible' => 'lehetséges',
        'reject' => 'elutasít',
        'reverse' => '',
        'Facility' => 'Képesség',
        'Timeover' => 'Késés',
        'Pending till' => 'Várakozás eddig',
        'Don\'t work with UserID 1 (System account)! Create new users!' => 'Ne dolgozzon az 1-es felhasználóval (Rendszer jogosultság)! Hozzon létre új felhasználót!',
        'Dispatching by email To: field.' => 'Felosztás email címzett mezõ szerint.',
        'Dispatching by selected Queue.' => 'Felosztás a kiválasztott ügy szerint.',
        'No entry found!' => 'Nem található tétel!',
        'Session has timed out. Please log in again.' => 'Az ügymenet idõtúllépésmiatt befejezõdött. Kérjük lépjen be újra.',
        'No Permission!' => 'Nincs jogosultság!',
        'To: (%s) replaced with database email!' => 'Címzett: (%s) felülírva az adatbázis címmel!',
        'Cc: (%s) added database email!' => '',
        '(Click here to add)' => '(Kattinst ide a hozzáadáshoz)',
        'Preview' => 'Elõnézet',
        'Package not correctly deployed! You should reinstall the Package again!' => '',
        'Added User "%s"' => 'A "%s" felhasználó hozzáadva',
        'Contract' => 'Kapcsolat',
        'Online Customer: %s' => 'Bejelentkezett ügyfél: %s',
        'Online Agent: %s' => 'Bejelentkezett ügynök: %s',
        'Calendar' => 'Naptár',
        'File' => 'Fájl',
        'Filename' => 'Fájlnév',
        'Type' => 'Típus',
        'Size' => 'Méret',
        'Upload' => 'Feltölt',
        'Directory' => 'Könyvtár',
        'Signed' => 'Aláírt',
        'Sign' => 'Aláír',
        'Crypted' => 'Kódolt',
        'Crypt' => 'Kódol',
        'Office' => '',
        'Phone' => '',
        'Fax' => '',
        'Mobile' => '',
        'Zip' => '',
        'City' => '',
        'Country' => '',
        'installed' => '',
        'uninstalled' => '',
        'Security Note: You should activate %s because application is already running!' => '',
        'Unable to parse Online Repository index document!' => '',
        'No Packages for requested Framework in this Online Repository, but Packages for other Frameworks!' => '',
        'No Packages or no new Packages in selected Online Repository!' => '',
        'printed at' => '',

        # Template: AAAMonth
        'Jan' => '',
        'Feb' => '',
        'Mar' => 'Már',
        'Apr' => 'Ápr',
        'May' => 'Máj',
        'Jun' => 'Jún',
        'Jul' => 'Júl',
        'Aug' => '',
        'Sep' => 'Sze',
        'Oct' => 'Okt',
        'Nov' => '',
        'Dec' => '',
        'January' => '',
        'February' => '',
        'March' => '',
        'April' => '',
        'June' => '',
        'July' => '',
        'August' => '',
        'September' => '',
        'October' => '',
        'November' => '',
        'December' => '',

        # Template: AAANavBar
        'Admin-Area' => 'Admin terület',
        'Agent-Area' => 'Ügynök-terület',
        'Ticket-Area' => '',
        'Logout' => 'Kilép',
        'Agent Preferences' => 'Ügynök beállítások',
        'Preferences' => 'Beállítások',
        'Agent Mailbox' => '',
        'Stats' => 'Statisztika',
        'Stats-Area' => '',
        'Admin' => '',
        'Customer Users' => '',
        'Customer Users <-> Groups' => '',
        'Users <-> Groups' => '',
        'Roles' => 'Szabályok',
        'Roles <-> Users' => '',
        'Roles <-> Groups' => '',
        'Salutations' => '',
        'Signatures' => '',
        'Email Addresses' => '',
        'Notifications' => '',
        'Category Tree' => '',
        'Admin Notification' => '',

        # Template: AAAPreferences
        'Preferences updated successfully!' => 'Beállítások sikeresen frissítve!',
        'Mail Management' => 'Email kezelés',
        'Frontend' => 'Munkafelület',
        'Other Options' => 'Egyéb beállítások',
        'Change Password' => '',
        'New password' => '',
        'New password again' => '',
        'Select your QueueView refresh time.' => 'Válassza ki az ÜgyekNézet frissítési idejét.',
        'Select your frontend language.' => 'Válassza ki a munkafelület nyelvét.',
        'Select your frontend Charset.' => 'Válassza ki a munkafelület karakterkészletét.',
        'Select your frontend Theme.' => 'Válassza ki a munkafelület stílusát.',
        'Select your frontend QueueView.' => 'Válassza ki a munkafelület Ügyek-nézetét.',
        'Spelling Dictionary' => 'Helyesírás-ellenõrzõ szótár',
        'Select your default spelling dictionary.' => 'Válassza ki az alapértelmezett helyesírásellenõrzõ szótárat.',
        'Max. shown Tickets a page in Overview.' => 'Max. megjelenített jegy az áttekintésnél.',
        'Can\'t update password, passwords doesn\'t match! Please try it again!' => '',
        'Can\'t update password, invalid characters!' => '',
        'Can\'t update password, need min. 8 characters!' => '',
        'Can\'t update password, need 2 lower and 2 upper characters!' => '',
        'Can\'t update password, need min. 1 digit!' => '',
        'Can\'t update password, need min. 2 characters!' => '',

        # Template: AAAStats
        'Stat' => '',
        'Please fill out the required fields!' => '',
        'Please select a file!' => '',
        'Please select an object!' => '',
        'Please select a graph size!' => '',
        'Please select one element for the X-axis!' => '',
        'You have to select two or more attributes from the select field!' => '',
        'Please select only one element or turn of the button \'Fixed\' where the select field is marked!' => '',
        'If you use a checkbox you have to select some attributes of the select field!' => '',
        'Please insert a value in the selected input field or turn off the \'Fixed\' checkbox!' => '',
        'The selected end time is before the start time!' => '',
        'You have to select one or more attributes from the select field!' => '',
        'The selected Date isn\'t valid!' => '',
        'Please select only one or two elements via the checkbox!' => '',
        'If you use a time scale element you can only select one element!' => '',
        'You have an error in your time selection!' => '',
        'Your reporting time interval is to small, please use a larger time scale!' => '',
        'The selected start time is before the allowed start time!' => '',
        'The selected end time is after the allowed end time!' => '',
        'The selected time period is larger than the allowed time period!' => '',
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
        'Agent/Owner' => '',
        'Created by Agent/Owner' => '',
        'Created Priority' => '',
        'Created State' => '',
        'Create Time' => '',
        'CustomerUserLogin' => '',
        'Close Time' => '',

        # Template: AAATicket
        'Lock' => 'Zárol',
        'Unlock' => 'Felold',
        'History' => 'Történet',
        'Zoom' => 'Nagyít',
        'Age' => 'Kor',
        'Bounce' => 'Visszaküld',
        'Forward' => 'Továbbít',
        'From' => 'Feladó',
        'To' => 'Címzett',
        'Cc' => 'Másolat',
        'Bcc' => 'Vakmásolat',
        'Subject' => 'Tárgy',
        'Move' => 'Áthelyez',
        'Queue' => 'Ügyek',
        'Priority' => 'Sürgõsség',
        'State' => 'Állapot',
        'Compose' => 'Készít',
        'Pending' => 'Várakozik',
        'Owner' => 'Tulajdonos',
        'Owner Update' => '',
        'Responsible' => '',
        'Responsible Update' => '',
        'Sender' => 'Küldõ',
        'Article' => 'Cikk',
        'Ticket' => 'Jegy',
        'Createtime' => 'Elkészült ',
        'plain' => 'sima',
        'Email' => '',
        'email' => '',
        'Close' => 'Lezár',
        'Action' => 'Mûvelet',
        'Attachment' => 'Csatolás',
        'Attachments' => 'Csatolás',
        'This message was written in a character set other than your own.' => 'Ezt az üzenetet más karakterkészlettel írták mint amit ön használ.',
        'If it is not displayed correctly,' => 'Ha nem helyesen jelent meg,',
        'This is a' => 'Ez egy',
        'to open it in a new window.' => 'hogy megnyissa új ablakban.',
        'This is a HTML email. Click here to show it.' => 'Ez egy HTML email. Kattintson ide a megtekintéshez.',
        'Free Fields' => '',
        'Merge' => '',
        'merged' => '',
        'closed successful' => 'sikeresen lezárva',
        'closed unsuccessful' => 'sikertelenül lezárva',
        'new' => 'új',
        'open' => 'nyitva',
        'closed' => 'lezárt',
        'removed' => 'törölve',
        'pending reminder' => 'emlékeztetõre várakozik',
        'pending auto' => '',
        'pending auto close+' => 'automatikus zárásra várakozik+',
        'pending auto close-' => 'automatikus zárásra várakozik-',
        'email-external' => 'külsõ email',
        'email-internal' => 'belsõ email',
        'note-external' => 'külsõ jegyzet',
        'note-internal' => 'belsõ jegyzet',
        'note-report' => 'jegyzet jelentés',
        'phone' => 'telefon',
        'sms' => '',
        'webrequest' => 'webkérés',
        'lock' => 'zárolt',
        'unlock' => 'feloldva',
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
        'Ticket Number' => 'Jegy szám',
        'Ticket Object' => '',
        'No such Ticket Number "%s"! Can\'t link it!' => 'Nincs "%s" számú jegy! Nem tudom csatolni!',
        'Don\'t show closed Tickets' => 'Ne jelenítse meg a lezárt jegyeket.',
        'Show closed Tickets' => 'Mutasd a lezárt jegyeket',
        'New Article' => 'Új cikk',
        'Email-Ticket' => '',
        'Create new Email Ticket' => '',
        'Phone-Ticket' => '',
        'Search Tickets' => '',
        'Edit Customer Users' => '',
        'Bulk-Action' => '',
        'Bulk Actions on Tickets' => '',
        'Send Email and create a new Ticket' => '',
        'Create new Email Ticket and send this out (Outbound)' => '',
        'Create new Phone Ticket (Inbound)' => '',
        'Overview of all open Tickets' => 'Összes nyitott jegy áttekintése',
        'Locked Tickets' => '',
        'Watched Tickets' => '',
        'Watched' => '',
        'Subscribe' => '',
        'Unsubscribe' => '',
        'Lock it to work on it!' => '',
        'Unlock to give it back to the queue!' => '',
        'Shows the ticket history!' => '',
        'Print this ticket!' => '',
        'Change the ticket priority!' => '',
        'Change the ticket free fields!' => '',
        'Link this ticket to an other objects!' => '',
        'Change the ticket owner!' => '',
        'Change the ticket customer!' => '',
        'Add a note to this ticket!' => '',
        'Merge this ticket!' => '',
        'Set this ticket to pending!' => '',
        'Close this ticket!' => '',
        'Look into a ticket!' => '',
        'Delete this ticket!' => '',
        'Mark as Spam!' => '',
        'My Queues' => '',
        'Shown Tickets' => '',
        'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' => '',
        'Ticket %s: first response time is over (%s)!' => '',
        'Ticket %s: first response time will be over in %s!' => '',
        'Ticket %s: update time is over (%s)!' => '',
        'Ticket %s: update time will be over in %s!' => '',
        'Ticket %s: solution time is over (%s)!' => '',
        'Ticket %s: solution time will be over in %s!' => '',
        'There are more escalated tickets!' => '',
        'New ticket notification' => 'Új jegy értesítés',
        'Send me a notification if there is a new ticket in "My Queues".' => 'Küldjön nekem értesítést, ha új jegy van a "Saját Ügyeim"-ben.',
        'Follow up notification' => 'Válaszlevél értesítés',
        'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.' => 'Küldjön értesítést ha az ügyfél válaszol és én vagyok a tulajdonosa a jegynek.',
        'Ticket lock timeout notification' => 'Jegyzárolás-lejárat értesítés',
        'Send me a notification if a ticket is unlocked by the system.' => 'Küldjön értesítést ha a jegy zárolását a renszer feloldotta.',
        'Move notification' => 'Áthelyezés értesítés',
        'Send me a notification if a ticket is moved into one of "My Queues".' => 'Küldjön nekem értesítést, ha egy jegyet a "Saját Ügyeim" egyikébe mozgatták.',
        'Your queue selection of your favourite queues. You also get notified about those queues via email if enabled.' => '',
        'Custom Queue' => 'Egyedi ügyek',
        'QueueView refresh time' => 'ÜgyekNézet frissítési idõ',
        'Screen after new ticket' => 'Új jegy utáni képernyõ',
        'Select your screen after creating a new ticket.' => 'Válassza ki a képernyõt új jegy létrehozása után.',
        'Closed Tickets' => 'Lezárt jegyek',
        'Show closed tickets.' => 'Mutasd a lezárt jegyeket.',
        'Max. shown Tickets a page in QueueView.' => 'Max. megjelenített jegy az ügyek nézetnél.',
        'CompanyTickets' => '',
        'MyTickets' => '',
        'New Ticket' => '',
        'Create new Ticket' => '',
        'Customer called' => '',
        'phone call' => '',
        'Responses' => 'Válaszok',
        'Responses <-> Queue' => '',
        'Auto Responses' => '',
        'Auto Responses <-> Queue' => '',
        'Attachments <-> Responses' => '',
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
        'History::SendAgentNotification' => 'Történet::ÜgynökÉrtesítésKüldés',
        'History::SendCustomerNotification' => 'Történet::ÜgyfélÉrtesítésKüldés',
        'History::EmailAgent' => 'Történet::EmailÜgynök',
        'History::EmailCustomer' => 'Történet::EmailÜgyfél',
        'History::PhoneCallAgent' => 'Történet::ÜgynökTelefonHívás',
        'History::PhoneCallCustomer' => 'Történet::ÜgyfélTelefonHívás',
        'History::AddNote' => 'Történet::MegjegyzésHozzáadás',
        'History::Lock' => 'Történet::Zárol',
        'History::Unlock' => 'Történet::Feloldás',
        'History::TimeAccounting' => 'Történet::IdõElszámolás',
        'History::Remove' => 'Történet::Eltávolítás',
        'History::CustomerUpdate' => 'Történet::ÜgyfélMódosítás',
        'History::PriorityUpdate' => 'Történet::SürgõsségMódosítás',
        'History::OwnerUpdate' => 'Történet::TulajdonosVáltás',
        'History::LoopProtection' => 'Történet::VisszacsatolásVédelem',
        'History::Misc' => 'Történet::Vegyes',
        'History::SetPendingTime' => 'Történet::VárakozásiIdõBeállítás',
        'History::StateUpdate' => 'Történet::ÁllapotMódosítás',
        'History::TicketFreeTextUpdate' => 'Történet::JegySzabadSzövegMódosítás',
        'History::WebRequestCustomer' => 'Történet::ÜgyfélWebKérés',
        'History::TicketLinkAdd' => 'Történet::JegyCsatolásHozzáadás',
        'History::TicketLinkDelete' => 'Történet::JegyCsatolásTörlés',

        # Template: AAAWeekDay
        'Sun' => 'Vas',
        'Mon' => 'Hét',
        'Tue' => 'Ked',
        'Wed' => 'Sze',
        'Thu' => 'Csü',
        'Fri' => 'Pén',
        'Sat' => 'Szo',

        # Template: AdminAttachmentForm
        'Attachment Management' => 'Csatolás kezelése',

        # Template: AdminAutoResponseForm
        'Auto Response Management' => 'Automatikus válasz kezelõnek',
        'Response' => 'Válasz',
        'Auto Response From' => 'Automatikus válasz feladónak',
        'Note' => 'Jegyzet',
        'Useable options' => 'Használható opciók',
        'To get the first 20 character of the subject.' => '',
        'To get the first 5 lines of the email.' => '',
        'To get the realname of the sender (if given).' => '',
        'To get the article attribut (e. g. (<OTRS_CUSTOMER_From>, <OTRS_CUSTOMER_To>, <OTRS_CUSTOMER_Cc>, <OTRS_CUSTOMER_Subject> and <OTRS_CUSTOMER_Body>).' => '',
        'Options of the current customer user data (e. g. <OTRS_CUSTOMER_DATA_UserFirstname>).' => '',
        'Ticket owner options (e. g. <OTRS_OWNER_UserFirstname>).' => '',
        'Ticket responsible options (e. g. <OTRS_RESPONSIBLE_UserFirstname>).' => '',
        'Options of the current user who requested this action (e. g. <OTRS_CURRENT_UserFirstname>).' => '',
        'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>).' => '',
        'Config options (e. g. <OTRS_CONFIG_HttpType>).' => '',

        # Template: AdminCustomerCompanyForm
        'Customer Company Management' => '',
        'Add Customer Company' => '',
        'Add a new Customer Company.' => '',
        'List' => '',
        'This values are required.' => 'Ezek az értékek szükségesek.',
        'This values are read only.' => 'Ezek az értékek csak olvashatók.',

        # Template: AdminCustomerUserForm
        'Customer User Management' => 'Ügyfél felhasználók kezelése',
        'Search for' => 'Keresd a',
        'Add Customer User' => '',
        'Source' => 'Forrás',
        'Create' => '',
        'Customer user will be needed to have a customer history and to login via customer panel.' => 'Ügyfél felhasználóra lesz szükség, hogy legyen ügyfél történet és be lehessen lépni az ügyfél panelen.',

        # Template: AdminCustomerUserGroupChangeForm
        'Customer Users <-> Groups Management' => '',
        'Change %s settings' => '%s beállításainak módosítása',
        'Select the user:group permissions.' => 'A felhasználó:csoport jogok kiválasztása.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the user).' => 'Ha nincs semmi kiválasztva, akkor nincsenek jogosultságok ebben a csoportban (a jegyek nem lesznek elérhetõk a felhasználónak).',
        'Permission' => 'Jogosultság',
        'ro' => 'Csak olvasás',
        'Read only access to the ticket in this group/queue.' => 'Csak olvasási jogosultság a jegyekhez ebben a csoportban/ügyben.',
        'rw' => 'Írás/Olvasás',
        'Full read and write access to the tickets in this group/queue.' => 'Teljes írás és olvasási jog a jegyekhez ebben a csoportban/ügyben.',

        # Template: AdminCustomerUserGroupForm

        # Template: AdminEmail
        'Message sent to' => 'Üzenet elküldve',
        'Recipents' => 'Címzettek',
        'Body' => 'Törzs',
        'Send' => '',

        # Template: AdminGenericAgent
        'GenericAgent' => 'ÁltalánosÜgynök',
        'Job-List' => 'Feladat-Lista',
        'Last run' => 'Utolsó végrehajtás',
        'Run Now!' => '',
        'x' => '',
        'Save Job as?' => 'Feladat mentése másképp?',
        'Is Job Valid?' => '',
        'Is Job Valid' => '',
        'Schedule' => 'Idõzít',
        'Fulltext-Search in Article (e. g. "Mar*in" or "Baue*")' => 'Teljesszöveg keresés a cikkben (pl. "Mar*in" oder "Baue*")',
        '(e. g. 10*5155 or 105658*)' => 'pl. 10*5144 vagy 105658*',
        '(e. g. 234321)' => 'pl. 234321',
        'Customer User Login' => 'Ügyfél felhasználó belépés',
        '(e. g. U5150)' => 'pl. U5150',
        'Agent' => 'Ügynök',
        'Ticket Lock' => 'Jegy zárolás',
        'TicketFreeFields' => '',
        'Create Times' => '',
        'No create time settings.' => '',
        'Ticket created' => 'Jegy létrehozva',
        'Ticket created between' => 'Jegy létrehozva közöttük:',
        'Pending Times' => '',
        'No pending time settings.' => '',
        'Ticket pending time reached' => '',
        'Ticket pending time reached between' => '',
        'New Priority' => 'Új sürgõsség',
        'New Queue' => 'Új ügy',
        'New State' => 'Új állapot',
        'New Agent' => 'Új ügynök',
        'New Owner' => 'Új tulajdonos',
        'New Customer' => 'Új ügyfél',
        'New Ticket Lock' => 'Új jegy zárolás',
        'CustomerUser' => 'ÜgyfélFelhasználó',
        'New TicketFreeFields' => '',
        'Add Note' => 'Megjegyzés hozzáadása',
        'CMD' => 'PARANCS',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' => 'Ez a parancs lesz végrehajtva. Az ARG[0] lesz a jegy száma. Az ARG[1] lesz a jegy azonosítója.',
        'Delete tickets' => 'Jegyek törlése',
        'Warning! This tickets will be removed from the database! This tickets are lost!' => 'Figyelem! Ezek a jegyek el lesznek távolítva az adatbázisból! Ezek a jegyek elvesztek!',
        'Send Notification' => '',
        'Param 1' => '1. paraméter',
        'Param 2' => '2. paraméter',
        'Param 3' => '3. paraméter',
        'Param 4' => '4. paraméter',
        'Param 5' => '5. paraméter',
        'Param 6' => '6. paraméter',
        'Send no notifications' => '',
        'Yes means, send no agent and customer notifications on changes.' => '',
        'No means, send agent and customer notifications on changes.' => '',
        'Save' => 'Ment',
        '%s Tickets affected! Do you really want to use this job?' => '',
        '"}' => '',

        # Template: AdminGroupForm
        'Group Management' => 'Csoport kezelés',
        'Add Group' => '',
        'Add a new Group.' => '',
        'The admin group is to get in the admin area and the stats group to get stats area.' => 'Az admin csoport megkapja az admin területet és a státusz csoport megkapja a státusz területet.',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).' => 'Hozzon létre új csoportot a különbözõ ügynök csoportok (pl. beszerzõ osztály, támogató osztály, eladó osztály, ...) hozzáférési jogainak kezeléséhez.',
        'It\'s useful for ASP solutions.' => 'Ez hasznos ASP megoldásokhoz.',

        # Template: AdminLog
        'System Log' => 'Rendszernapló',
        'Time' => 'Idõ',

        # Template: AdminMailAccount
        'Mail Account Management' => '',
        'Host' => 'Gazda',
        'Account Type' => '',
        'POP3' => '',
        'POP3S' => '',
        'IMAP' => '',
        'IMAPS' => '',
        'Mailbox' => 'Postafiók',
        'Port' => '',
        'Trusted' => 'Megbízható',
        'Dispatching' => 'Hozzárendelés',
        'All incoming emails with one account will be dispatched in the selected queue!' => 'Az összes egy azonosítóval rendelkezõ bejövõ email egy kiválasztott ügynélhöz lesz rendelve!',
        'If your account is trusted, the already existing X-OTRS header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' => 'Ha az ön azonosítójamegbízható, a már létezõ X-OTRS fejlécet használjuk az érkezéskor (sörgõsséghez, ...)! Egyéb esetben a PostMaster szûrõ lesz alkalmazva.',

        # Template: AdminNavigationBar
        'Users' => '',
        'Groups' => 'Csoportok',
        'Misc' => 'Egyéb',

        # Template: AdminNotificationForm
        'Notification Management' => 'Értesítéskezelés',
        'Notification' => '',
        'Notifications are sent to an agent or a customer.' => 'Az értesítések ügynöknek vagy ügyfélnek kerülnek elküldésre.',

        # Template: AdminPackageManager
        'Package Manager' => '',
        'Uninstall' => '',
        'Version' => '',
        'Do you really want to uninstall this package?' => '',
        'Reinstall' => '',
        'Do you really want to reinstall this package (all manual changes get lost)?' => '',
        'Cancle' => '',
        'Continue' => '',
        'Install' => '',
        'Package' => '',
        'Online Repository' => '',
        'Vendor' => '',
        'Upgrade' => '',
        'Local Repository' => '',
        'Status' => 'Állapot',
        'Overview' => 'Áttekintõ',
        'Download' => 'Letölt',
        'Rebuild' => '',
        'ChangeLog' => '',
        'Date' => '',
        'Filelist' => '',
        'Download file from package!' => '',
        'Required' => '',
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

        # Template: AdminPGPForm
        'PGP Management' => '',
        'Result' => 'Eredmények',
        'Identifier' => 'Azonosító',
        'Bit' => '',
        'Key' => 'Kulcs',
        'Fingerprint' => 'Ujjlenyomat',
        'Expires' => 'Lejár',
        'In this way you can directly edit the keyring configured in SysConfig.' => '',

        # Template: AdminPOP3
        'POP3 Account Management' => 'POP3 azonosító kezelése',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => 'PostMaster Szûrõ Kezelés',
        'Filtername' => 'Szûrõnév',
        'Match' => 'Egyezés',
        'Header' => 'Fejléc',
        'Value' => 'Érték',
        'Set' => 'Beállít',
        'Do dispatch or filter incoming emails based on email X-Headers! RegExp is also possible.' => 'A beérkezõ emailek az X-Fejlécek alapján legyen hozzárendelve! Szabályos kifelyezések alkalmazhatók.',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' => '',
        'If you use RegExp, you also can use the matched value in () as [***] in \'Set\'.' => 'Ha szabályos kifelyezéseket használ, használhatja az egyezõ értékeket a ()-ben mint [***] a \'Halmaz\'-ban.',

        # Template: AdminQueueAutoResponseForm
        'Queue <-> Auto Responses Management' => '',

        # Template: AdminQueueForm
        'Queue Management' => 'Ügyek kezelése',
        'Sub-Queue of' => 'Al-Ügye a(z)',
        'Unlock timeout' => 'Feloldás idõtúllépés',
        '0 = no unlock' => '0 = nincs feloldás',
        'Escalation - First Response Time' => '',
        '0 = no escalation' => '0 = nincs eszkaláció',
        'Escalation - Update Time' => '',
        'Escalation - Solution Time' => '',
        'Follow up Option' => 'Válasz opciók',
        'Ticket lock after a follow up' => 'Jegy zárolása válasz érkezése után.',
        'Systemaddress' => 'Rendszercím',
        'Customer Move Notify' => 'Ügyfél értesítés mozgatáskor',
        'Customer State Notify' => 'Ügyfél értesítés állapotváltozáskor',
        'Customer Owner Notify' => 'Ügyfél értesítés tulajdonsováltáskor',
        'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.' => 'Ha az ügynök zárolja a jegyet és nem küld választ ezen idõn belül, a jegy zárolása megszûnik. Így a jegy látható lesz minden ügynöknek.',
        'Escalation time' => 'Eszkaláció idõ',
        'If a ticket will not be answered in this time, just only this ticket will be shown.' => 'Ha a jegy nem kerül megválaszolásra a megadott idõn belül, csak ez a jegy lesz megjelenítve.',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.' => 'Ha a jegy le van zárva és az ügyfél válaszol a jegyre, akkor az zárolásra kerül a régi tulajdonosnak.',
        'Will be the sender address of this queue for email answers.' => 'Ennél az ügynél ez lesz a feladó email válaszokhoz.',
        'The salutation for email answers.' => 'A megszólítás az email válaszokhoz.',
        'The signature for email answers.' => 'Az aláírás a válasz emailekhez.',
        'OTRS sends an notification email to the customer if the ticket is moved.' => 'Az OTRS értesítõ levelet küld az ügyfélnek ha a jegy áthelyezésre került.',
        'OTRS sends an notification email to the customer if the ticket state has changed.' => 'Az OTRS értesítõ levelet küld az ügyfélnek ha a jegy állapota megváltozott.',
        'OTRS sends an notification email to the customer if the ticket owner has changed.' => 'Az OTRS értesítõ levelet küld az ügyfélnek ha a jegy tulajdonosa megváltozott.',

        # Template: AdminQueueResponsesChangeForm
        'Responses <-> Queue Management' => '',

        # Template: AdminQueueResponsesForm
        'Answer' => 'Válasz',

        # Template: AdminResponseAttachmentChangeForm
        'Responses <-> Attachments Management' => '',

        # Template: AdminResponseAttachmentForm

        # Template: AdminResponseForm
        'Response Management' => 'Reakció kezelés',
        'A response is default text to write faster answer (with default text) to customers.' => 'Egy reakció az alapértelmezett szöveg gyors válaszokhoz (az alapértelmezett szöveggel) az ügyfeleknek.',
        'Don\'t forget to add a new response a queue!' => 'Ne felejtsen el új reakciót hozzáadni az ügyhöz!',
        'The current ticket state is' => 'A jegy aktuális állapota',
        'Your email address is new' => 'Az ön e-mail címe új',

        # Template: AdminRoleForm
        'Role Management' => 'Szabály Kezelés',
        'Add Role' => '',
        'Add a new Role.' => '',
        'Create a role and put groups in it. Then add the role to the users.' => 'Hozzon létre egy szabályt és tegyen bele csoportokat. Azután adja a szabályt a felhasználókhoz.',
        'It\'s useful for a lot of users and groups.' => 'Ez hasznos egy csomó felhasználónak és csoportnak',

        # Template: AdminRoleGroupChangeForm
        'Roles <-> Groups Management' => '',
        'move_into' => 'mozgat',
        'Permissions to move tickets into this group/queue.' => 'Jogosultságok jegyek áthelyezéséhez ebbe a csoportba/ügybe.',
        'create' => 'készít',
        'Permissions to create tickets in this group/queue.' => 'Jogosultságok új jegyek létrehozásához ebben a csoportban/ügyben.',
        'owner' => 'tulajdonos',
        'Permissions to change the ticket owner in this group/queue.' => 'Jogosultságok a jegy tulajdonosának megváltoztatásához ebben a csoportban/ügyben.',
        'priority' => 'sürgõsség',
        'Permissions to change the ticket priority in this group/queue.' => 'Jogosultágok a jegy prioritásnak megváltoztatásához ebben a csoportban/ügyben.',

        # Template: AdminRoleGroupForm
        'Role' => 'Szabály',

        # Template: AdminRoleUserChangeForm
        'Roles <-> Users Management' => '',
        'Active' => 'Aktív',
        'Select the role:user relations.' => 'Válassza ki a szabály:felhasználó kapcsolatokat.',

        # Template: AdminRoleUserForm

        # Template: AdminSalutationForm
        'Salutation Management' => 'Megszólítás kezelés',
        'Add Salutation' => '',
        'Add a new Salutation.' => '',

        # Template: AdminSelectBoxForm
        'Select Box' => 'SQL Parancsok',
        'Limit' => 'Korlát',
        'Go' => '',
        'Select Box Result' => 'SQL Parancs eredmény',

        # Template: AdminService
        'Service Management' => '',
        'Add Service' => '',
        'Add a new Service.' => '',
        'Service' => '',
        'Sub-Service of' => '',

        # Template: AdminSession
        'Session Management' => 'Folyamatkezelés',
        'Sessions' => 'Eljárások',
        'Uniq' => 'Egyedi',
        'Kill all sessions' => '',
        'Session' => 'Eljárás',
        'Content' => '',
        'kill session' => 'folyamat leállítása',

        # Template: AdminSignatureForm
        'Signature Management' => 'Aláírás kezelés',
        'Add Signature' => '',
        'Add a new Signature.' => '',

        # Template: AdminSLA
        'SLA Management' => '',
        'Add SLA' => '',
        'Add a new SLA.' => '',
        'SLA' => '',
        'First Response Time' => '',
        'Update Time' => '',
        'Solution Time' => '',

        # Template: AdminSMIMEForm
        'S/MIME Management' => '',
        'Add Certificate' => 'Tanusítvány Hozzáadása',
        'Add Private Key' => 'Titkos Kulcs Hozáadása',
        'Secret' => 'Titok',
        'Hash' => 'Kivonat',
        'In this way you can directly edit the certification and private keys in file system.' => 'Íly módon közvetlenül szerkesztheti a fájlrendszeren tárolt tanusítványokat és titkos kulcsokat.',

        # Template: AdminStateForm
        'State Management' => '',
        'Add State' => '',
        'Add a new State.' => '',
        'State Type' => 'Állapot típus',
        'Take care that you also updated the default states in you Kernel/Config.pm!' => 'Figyeljen oda, hogy az Kernel/Config.pm fájlban is frissítse az alapértelmezett állapotokat!',
        'See also' => 'Lásd még',

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
        'New' => 'Új',
        'New Group' => '',
        'Group Ro' => '',
        'New Group Ro' => '',
        'NavBarName' => '',
        'NavBar' => '',
        'Image' => '',
        'Prio' => '',
        'Block' => '',
        'AccessKey' => '',

        # Template: AdminSystemAddressForm
        'System Email Addresses Management' => 'Rendszer email címek kezelése',
        'Add System Address' => '',
        'Add a new System Address.' => '',
        'Realname' => 'Valódi név',
        'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!' => 'Az összes bejövõ email ezzel az "Email"-el (Címzett:) a kiválasztott ügyhöz lesz rendelve!',

        # Template: AdminSystemStatus
        'System Status' => '',

        # Template: AdminTicketCustomerNotification
        'Notification (Customer)' => '',
        'Event' => '',
        'Config options (e. g. &lt;OTRS_CONFIG_HttpType&gt;)' => '',
        'Ticket owner options (e. g. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)' => '',
        'Options of the current user who requested this action (e. g. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)' => '',
        'Options of the current customer user data (e. g. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)' => '',
        'Options of the ticket data (e. g. &lt;OTRS_TICKET_Number&gt;, &lt;OTRS_TICKET_ID&gt;, &lt;OTRS_TICKET_Queue&gt;, &lt;OTRS_TICKET_State&gt;)' => '',

        # Template: AdminTypeForm
        'Type Management' => '',
        'Add Type' => '',
        'Add a new Type.' => '',

        # Template: AdminUserForm
        'User Management' => 'Felhasználó kezelés',
        'Add User' => '',
        'Add a new Agent.' => '',
        'Login as' => '',
        'Firstname' => 'Keresztnév',
        'Lastname' => 'Családi név',
        'User will be needed to handle tickets.' => 'Felhasználó kell a jegyek kezeléséhez.',
        'Don\'t forget to add a new user to groups and/or roles!' => '',

        # Template: AdminUserGroupChangeForm
        'Users <-> Groups Management' => '',

        # Template: AdminUserGroupForm

        # Template: AgentBook
        'Address Book' => 'Címjegyzék',
        'Return to the compose screen' => 'Visszatérés a szerkesztõképernyõre',
        'Discard all changes and return to the compose screen' => 'Minden változtatás megsemmisítése és visszatérés a szerkesztõképernyõre',

        # Template: AgentCalendarSmall

        # Template: AgentCalendarSmallIcon

        # Template: AgentCustomerTableView

        # Template: AgentInfo
        'Info' => '',

        # Template: AgentLinkObject
        'Link Object' => '',
        'Select' => 'Kiválaszt',
        'Results' => 'Eredmények',
        'Total hits' => 'Összes találat',
        'Page' => 'Oldal',
        'Detail' => '',

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
        'Stat#' => '',
        'Do you really want to delete this Object?' => '',

        # Template: AgentStatsEditRestrictions
        'Select the restrictions to characterise the stat' => '',
        'Fixed' => '',
        'Please select only one Element or turn of the button \'Fixed\'.' => '',
        'Absolut Period' => '',
        'Between' => '',
        'Relative Period' => '',
        'The last' => '',
        'Finish' => '',
        'Here you can make restrictions to your stat.' => '',
        'If you remove the hook in the "Fixed" checkbox, the agent generating the stat can change the attributs of the corresponding element.' => '',

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
        'Here you can the value series. You have the possibility to select one or two elements. Then you can select the attributes of elements. Each attribute will be shown as single value series. If you don\'t select any attribute all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' => '',

        # Template: AgentStatsEditXaxis
        'Select the element, which will be used at the X-axis' => '',
        'maximal period' => '',
        'minimal scale' => '',
        'Here you can define the x-axis. You can select one element via the radio button. Than you you have to select two or more attributes of the element. If you make no selection all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' => '',

        # Template: AgentStatsImport
        'Import' => '',
        'File is not a Stats config' => '',
        'No File selected' => '',

        # Template: AgentStatsOverview
        'Object' => '',

        # Template: AgentStatsPrint
        'Print' => 'Nyomtat',
        'No Element selected.' => '',

        # Template: AgentStatsView
        'Export Config' => '',
        'Informations about the Stat' => '',
        'Exchange Axis' => '',
        'Configurable params of static stat' => '',
        'No element selected.' => '',
        'maximal period from' => '',
        'to' => '',
        'Start' => '',
        'With the input and select fields you can configurate the stat at your needs. Which elements of a stat you can edit depends on your stats administrator who configurated the stat.' => '',

        # Template: AgentTicketArticleUpdate
        'A message should have a subject!' => 'Egy üzenetnek kell legyen tárgya!',
        'A message should have a body!' => 'Egy üzenetnek kell legyen törzse!',
        'You need to account time!' => 'El kell számolnia az idõvel!',
        'Edit Article' => '',

        # Template: AgentTicketBounce
        'Bounce ticket' => 'Jegy visszaküldése',
        'Ticket locked!' => 'Jegy lezárva!',
        'Ticket unlock!' => 'Jegy feloldva!',
        'Bounce to' => 'Visszaküldés ide:',
        'Next ticket state' => 'A jegy következõ állapota',
        'Inform sender' => 'Küldõ tájékoztatása',
        'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further informations.' => 'Az ön "<OTRS_TICKET>" számú jegyhez rendelt emailje visszaküldésre került a "<OTRS_BOUNCE_TO>" címre. Vegye fel ezzel a címmel a kapcsolatot további információkért.',
        'Send mail!' => 'Email küldése!',

        # Template: AgentTicketBulk
        'Ticket Bulk Action' => 'Csoportos Jegy Mûvelet',
        'Spell Check' => 'Helyesírásellenõrzés',
        'Note type' => 'Jegyzet típus',
        'Unlock Tickets' => '',

        # Template: AgentTicketClose
        'Close ticket' => 'Jegy lezárása',
        'Previous Owner' => 'Korábbi tulajdonos',
        'Inform Agent' => '',
        'Optional' => '',
        'Inform involved Agents' => '',
        'Attach' => 'Csatol',
        'Next state' => 'Következõ állapot',
        'Pending date' => 'Várakozási dátum',
        'Time units' => 'Idõ egységek',
        ' (work units)' => ' (munkaegység)',

        # Template: AgentTicketCompose
        'Compose answer for ticket' => 'Válaszadás a jegyre',
        'Pending Date' => 'Várakozás dátuma',
        'for pending* states' => 'várakozó* státuszhoz',

        # Template: AgentTicketCustomer
        'Change customer of ticket' => 'A jegy ügyfelének megváltoztatása',
        'Set customer user and customer id of a ticket' => 'A jegy ügyfél felhasználójának és ügyfél azonosítójának megbeállítása',
        'Customer User' => 'Ügyfél felhasználó',
        'Search Customer' => 'Ügyfél keresése',
        'Customer Data' => 'Ügyfél adatok',
        'Customer history' => 'Ügyfél történet',
        'All customer tickets.' => 'Összes ügyfél jegy.',

        # Template: AgentTicketCustomerMessage
        'Follow up' => 'Válasz',

        # Template: AgentTicketEmail
        'Compose Email' => 'Új Email írása',
        'new ticket' => 'új jegy',
        'Refresh' => '',
        'Clear To' => 'Tisztítás Neki',

        # Template: AgentTicketForward
        'Article type' => 'Cikk típusa',

        # Template: AgentTicketFreeText
        'Change free text of ticket' => 'Szabad szöveg változtatása a jegyben',

        # Template: AgentTicketHistory
        'History of' => 'Története ennek:',

        # Template: AgentTicketLocked

        # Template: AgentTicketMailbox
        'Tickets' => 'Jegyek',
        'of' => 'kitõl',
        'Filter' => '',
        'New messages' => 'Új üzenetek',
        'Reminder' => 'Emlékeztetõ',
        'Sort by' => 'Rendezés így',
        'Order' => 'Sorrend',
        'up' => 'fel',
        'down' => 'le',

        # Template: AgentTicketMerge
        'Ticket Merge' => '',
        'Merge to' => '',

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
        'Clear From' => 'Feladó törlése',

        # Template: AgentTicketPhoneOutbound

        # Template: AgentTicketPlain
        'Plain' => 'Egyszerû',

        # Template: AgentTicketPrint
        'Ticket-Info' => '',
        'Accounted time' => 'Elszámolt idõ',
        'Escalation in' => 'Eszkaláció ebben',
        'Linked-Object' => '',
        'Parent-Object' => '',
        'Child-Object' => '',
        'by' => 'általa:',

        # Template: AgentTicketPriority
        'Change priority of ticket' => 'Jegy sürgõsségének módosítása',

        # Template: AgentTicketQueue
        'Tickets shown' => 'Mutatott jegy',
        'Tickets available' => 'Elérhetõ jegy',
        'All tickets' => 'Összes jegy',
        'Queues' => 'Ügyek',
        'Ticket escalation!' => 'Jegy eszkaláció!',

        # Template: AgentTicketQueueTicketView
        'Service Time' => '',
        'Your own Ticket' => 'Az ön saját jegye',
        'Compose Follow up' => 'Válasz írása',
        'Compose Answer' => 'Válasz írása',
        'Contact customer' => 'Kapcsolatbalépés az ügyféllel',
        'Change queue' => 'Ügy változtatás',

        # Template: AgentTicketQueueTicketViewLite

        # Template: AgentTicketResponsible
        'Change responsible of ticket' => '',

        # Template: AgentTicketSearch
        'Ticket Search' => 'Jegy keresés',
        'Profile' => 'Profil',
        'Search-Template' => 'Keresõ sablon',
        'TicketFreeText' => 'Jegy szabadszöveg',
        'Created in Queue' => '',
        'Result Form' => 'Eredmény ürlap',
        'Save Search-Profile as Template?' => 'Elmenti a keresõ profilt sablonként?',
        'Yes, save it with name' => 'Igen, elmentve ezen a néven',

        # Template: AgentTicketSearchResult
        'Search Result' => 'Keresési eredmény',
        'Change search options' => 'Keresési beállítások módosítása',

        # Template: AgentTicketSearchResultPrint

        # Template: AgentTicketSearchResultShort
        'U' => 'A',
        'D' => 'Z',

        # Template: AgentTicketStatusView
        'Ticket Status View' => '',
        'Open Tickets' => '',
        'Locked' => 'Zárolt',

        # Template: AgentTicketZoom

        # Template: AgentWindowTab

        # Template: Calculator
        'Calculator' => '',
        'Operation' => '',

        # Template: Copyright

        # Template: css

        # Template: customer-css

        # Template: CustomerAccept

        # Template: CustomerCalendarSmallIcon

        # Template: CustomerError
        'Traceback' => 'Visszakövetés',

        # Template: CustomerFAQ

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
        'Accept license' => '',
        'Don\'t accept license' => '',
        'Admin-User' => 'Admin-felhasználó',
        'Admin-Password' => '',
        'your MySQL DB should have a root password! Default is empty!' => 'Az ön MySQL adatbázisának kell legyen root jelszava! Az alapértelmezett üres!',
        'Database-User' => '',
        'default \'hot\'' => 'alapértelmezett',
        'DB connect host' => '',
        'Database' => '',
        'false' => '',
        'SystemID' => 'Rendszer azonosító',
        '(The identify of the system. Each ticket number and each http session id starts with this number)' => '(Azonosítás a rendszerben. Minden jegyhez és minden http eljárás ezzel a sorszámmal indul)',
        'System FQDN' => 'Rendszer FQDN',
        '(Full qualified domain name of your system)' => '(Teljes ellenõrzött domain név a rendszerben)',
        'AdminEmail' => 'KezelõEmail',
        '(Email of the system admin)' => '(E-Mail a rendszergazdának)',
        'Organization' => 'Szervezet',
        'Log' => '',
        'LogModule' => 'Log modul',
        '(Used log backend)' => '(Használt háttér log)',
        'Logfile' => 'Log file',
        '(Logfile just needed for File-LogModule!)' => '(Logfile szükséges a File-LogModul számára!)',
        'Webfrontend' => 'Web-munkafelület',
        'Default Charset' => 'Alapértelmezett karakterkészlet',
        'Use utf-8 it your database supports it!' => 'Használd utf-8-at az adatbázis támogatásoknál!',
        'Default Language' => 'Alapértelmezett nyelv',
        '(Used default language)' => '(A felhasználó alapértelmezett nyelve)',
        'CheckMXRecord' => 'MX Rekord ellenõrzés',
        '(Checks MX recordes of used email addresses by composing an answer. Don\'t use CheckMXRecord if your OTRS machine is behinde a dial-up line $!)' => '(Ellenõrizd le az MX rekordot a használt email címben a válasz írásakor!)',
        'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' => 'Ahhoz, hogy az OTRS-t használni tudja, a következõ parancsot kell begépelnie parancssorban (terminálban/héjjban) root-ként.',
        'Restart your webserver' => 'Indítsa újra a web-kiszolgálót',
        'After doing so your OTRS is up and running.' => 'Ha ez kész, az OTRS kész és fut.',
        'Start page' => 'Start oldal',
        'Have a lot of fun!' => 'Sok sikert!',
        'Your OTRS Team' => 'Az ön OTRS csapata',

        # Template: Login
        'Welcome to %s' => 'Üdvözli az %s',

        # Template: Motd

        # Template: NoPermission
        'No Permission' => 'Nincs jogosultság',

        # Template: Notify
        'Important' => '',

        # Template: PrintFooter
        'URL' => '',

        # Template: PrintHeader
        'printed by' => 'Nyomtatta',

        # Template: PublicFAQ

        # Template: PublicView
        'Management Summary' => '',

        # Template: Redirect

        # Template: Test
        'OTRS Test Page' => 'OTRS tesztoldal',
        'Counter' => '',

        # Template: Warning
        # Misc
        'Create Database' => 'Adatbázis létrehozása',
        'DB Host' => 'DB Gazda',
        'Ticket Number Generator' => 'Jegy sorszám generátor',
        '(Ticket identifier. Some people want toset this to e. g. \'Ticket#\', \'Call#\' or \'MyTicket#\')' => '(Jegy azonosítûs. pl. \'Jegy#\', \'Hívó#\' vagy \'Jegyem#\')',
        'Create new Phone Ticket' => 'Új telefon jegy létrehozása',
        'In this way you can directly edit the keyring configured in Kernel/Config.pm.' => 'Íly módon közvetlenül szerkesztheti a Kernel/Config.pm-ben beállított kulcskarikát.',
        'Symptom' => 'Jelenség',
        'A message should have a To: recipient!' => 'Egy üzenethez kellene legyen címzett!',
        'Site' => 'Gép',
        'Customer history search (e. g. "ID342425").' => 'Keresés az ügyfél történetében (pl. "ID342425").',
        'for agent firstname' => 'ügynök keresztnévhez',
        'Close!' => 'Lezár!',
        'The message being composed has been closed.  Exiting.' => 'Az éppen elkészült levél lezárásra került. Kilépés.',
        'A web calendar' => '',
        'to get the realname of the sender (if given)' => 'hogy megkapja a feladó valódi nevét (ha lehetséges)',
        'OTRS DB Name' => 'OTRS DB név',
        'Select Source (for add)' => 'Válassza ki a forrsát (hozzáadáshoz)',
        'Days' => 'Nap',
        'Queue ID' => 'Ügy azonosító',
        'Home' => 'Otthon',
        'Config options (e. g. <OTRS_CONFIG_HttpType>)' => 'Beállítás opciók (pl. <OTRS_CONFIG_HttpType>)',
        'System History' => '',
        'customer realname' => 'ügyfél valódi név',
        'First Response' => '',
        'Pending messages' => 'Várakozó üzenetek',
        'Modules' => 'Modul',
        'for agent login' => 'ügynök belépéséhez',
        'Keyword' => 'Kulcsszó',
        'Close type' => 'Típus lezárása',
        'DB Admin User' => 'DB Admin felhasználó',
        'for agent user id' => 'ügynük felhasználó azonosítójához',
        'sort upward' => 'rendezés felfelé',
        'Change user <-> group settings' => 'A felhasználó <-> csoport beállítások megváltoztatása',
        'Problem' => 'Probléma',
        'next step' => 'következõ lépés',
        'Customer history search' => 'Keresés az ügyfél történetében',
        'Admin-Email' => 'Kezelõ-Email',
        'Create new database' => 'Új adatbázis létrehozása',
        'A message must be spell checked!' => 'Az üzenetnek helyesírásellenõrzésen kell átmennie!',
        'ArticleID' => 'Cikkazonosító',
        'All Agents' => 'Minden ügynök',
        'Keywords' => 'Kulcsszó',
        'No * possible!' => 'A "*" nem lehetséges!',
        'Options ' => '',
        'Message for new Owner' => 'Üzenet az új tulajdonosnak',
        'to get the first 5 lines of the email' => 'hogy megkapja az elsõ 5 sort az email-bõl',
        'OTRS DB Password' => 'OTRS DB jelszó',
        'Last update' => 'Utolsó frissítés',
        'to get the first 20 character of the subject' => 'hogy megkapja az elsõ 20 karaktert a tárgyból',
        'DB Admin Password' => 'DB Admin jelszó',
        'Advisory' => '',
        'Drop Database' => 'Adatbázis törlése',
        'FileManager' => '',
        'Options of the current customer user data (e. g. <OTRS_CUSTOMER_DATA_UserFirstname>)' => 'Opciók az aktuális ügyfél felhasználói adatokhoz (pl. <OTRS_CUSTOMER_DATA_UserFirstname>)',
        'Pending type' => 'Várakozás típusa',
        'Comment (internal)' => 'Megjegyzés (belsõ)',
        'This window must be called from compose window' => 'Ezt az ablakot a szerkesztõ ablakból kell hívni',
        'Minutes' => 'Perc',
        'You need min. one selected Ticket!' => 'Legalább egy jegyet ki kell választani!',
        'Options of the ticket data (e. g. <OTRS_TICKET_Number>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' => '',
        '(Used ticket number format)' => '(Nyitott jegyek sorszámának formátuma)',
        'Fulltext' => 'Teljesszöveg',
        'Incident' => '',
        'OTRS DB connect host' => 'OTRS DB kapcsolódik a gazdához',
        'All Agent variables.' => '',
        'All Customer variables like defined in config option CustomerUser.' => 'Az összes ügyfél változó ahogyan az ÜgyfélFelhasználó opcióknál lett beállítva.',
        'accept license' => 'Licenc elfogadása',
        'for agent lastname' => 'ügynök családinévhez',
        'Options of the current user who requested this action (e. g. <OTRS_CURRENT_UserFirstname>)' => 'Opciók a aktuális felhasználónál aki kérte ezt az eljárást. (pl. <OTRS_CURRENT_UserFirstname>)',
        'Reminder messages' => 'Emlékeztetõ üzenetek',
        'Ticket Hook' => 'Jegy pöcök',
        'TicketZoom' => 'JegyNagyítás',
        'Don\'t forget to add a new user to groups!' => 'Ne felejtsen el új felhasználót hozzáadni a csoportokhoz!',
        'You need a email address (e. g. customer@example.com) in To:!' => 'Kell egy email cím (pl. customer@example.com) címzettnek!',
        'CreateTicket' => 'Jegylétrehozás',
        'System Settings' => 'Rendszerbeállítások',
        'WebWatcher' => '',
        'Hours' => 'Óra',
        'Finished' => 'Befejezve',
        'Split' => 'Felosztás',
        'All messages' => 'Minden üzenet',
        'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' => '',
        'Artefact' => '',
        'A article should have a title!' => 'Egy cikknek kellene legyen címe!',
        'don\'t accept license' => 'Licenc elutasítása',
        'A web mail client' => '',
        'WebMail' => '',
        'Ticket owner options (e. g. <OTRS_OWNER_UserFirstname>)' => 'Jegy tulajdonos opciók (pl. <OTRS_OWNER_UserFirstname>)',
        'Name is required!' => 'A nevet meg kell adni!',
        'DB Type' => 'DB típusa',
        'Termin1' => '',
        'kill all sessions' => 'Minden eljárás kilövése',
        'to get the from line of the email' => 'hogy megkapja a feladót az email-bõl',
        'Solution' => 'Megoldás',
        'QueueView' => 'ÜgyekNézet',
        'Welcome to OTRS' => '',
        'modified' => '',
        'Delete old database' => 'Régi adatbázis törlése',
        'sort downward' => 'rendezés lefelé',
        'You need to use a ticket number!' => '',
        'A web file manager' => '',
        'send' => 'küld',
        'Note Text' => 'Jegyzet szöveg',
        'System State Management' => 'Rendszerállapot kezelés',
        'OTRS DB User' => 'OTRS DB felhasználó',
        'PhoneView' => 'TelefonNézet',
        'maximal period form' => '',
        'Verion' => '',
        'TicketID' => 'Jegyazonosító',
        'Modified' => 'Módosítva',
        'Ticket selected for bulk action!' => 'Jegy kiválasztva csoportos mûvelethez!',
    };
    # $$STOP$$
}

1;
