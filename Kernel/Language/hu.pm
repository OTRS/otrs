# --
# Kernel/Language/hu.pm - provides de language translation
# Copyright (C) 2004 RLAN Internet <MAGIC at rlan.hu>
# --
# $Id: hu.pm,v 1.4 2004-08-24 08:20:42 martin Exp $
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
$VERSION = '$Revision: 1.4 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub Data {
    my $Self = shift;
    my %Param = @_;
    my %Hash = ();

    # $$START$$
    # Last translation Tue Aug 24 10:17:13 2004 by 

    # possible charsets
    $Self->{Charset} = ['iso-8859-2', 'iso-8859-15', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Jear;)
    $Self->{DateFormat} = '%Y.%M.%D %T';
    $Self->{DateFormatLong} = '%Y %B %D %A %T';
    $Self->{DateInputFormat} = '%Y.%M.%D';
    $Self->{DateInputFormatLong} = '%Y.%M.%D - %T';

    %Hash = (
    # Template: AAABase
      ' 2 minutes' => ' 2 Perc',
      ' 5 minutes' => ' 5 Perc',
      ' 7 minutes' => ' 7 Perc',
      '(Click here to add)' => '(Kattinst ide a hozzáadáshoz)',
      '...Back' => '',
      '10 minutes' => '10 Perc',
      '15 minutes' => '15 Perc',
      'Added User "%s"' => '',
      'AddLink' => 'Link hozzáadása',
      'Admin-Area' => 'Admin terület',
      'agent' => 'Ügynök',
      'Agent-Area' => 'Ügynök-terület',
      'all' => 'összes',
      'All' => 'Összes',
      'Attention' => 'Figyelem',
      'Back' => 'Vissza',
      'before' => 'elõtt',
      'Bug Report' => 'Hibajelentés',
      'Calendar' => '',
      'Cancel' => 'Mégsem',
      'change' => 'változtat',
      'Change' => 'Változtat',
      'change!' => 'Változtat!',
      'click here' => 'kattints ide',
      'Comment' => 'Megjegyzés',
      'Contract' => '',
      'Crypt' => '',
      'Crypted' => '',
      'Customer' => 'Ügyfél',
      'customer' => 'ügyfél',
      'Customer Info' => 'Ügyfél Info',
      'day' => 'nap',
      'day(s)' => 'nap',
      'days' => 'nap',
      'description' => 'leírás',
      'Description' => 'Leírás',
      'Directory' => '',
      'Dispatching by email To: field.' => 'Felosztás email címzett mezõ szerint.',
      'Dispatching by selected Queue.' => 'Felosztás a kiválasztott ügy szerint.',
      'Don\'t show closed Tickets' => 'Ne jelenítse meg a lezárt jegyeket.',
      'Don\'t work with UserID 1 (System account)! Create new users!' => 'Ne dolgozzon az 1-es felhasználóval (Rendszer jogosultság)! Hozzon létre új felhasználót!',
      'Done' => 'Kész',
      'end' => 'vége',
      'Error' => 'Hiba',
      'Example' => 'Példa',
      'Examples' => 'Példa',
      'Facility' => 'Képesség',
      'FAQ-Area' => 'GYIK terület',
      'Feature not active!' => 'Képesség nem aktív!',
      'go' => 'indítsd',
      'go!' => 'Indítsd!',
      'Group' => 'Csoport',
      'History::AddNote' => '',
      'History::Bounce' => '',
      'History::CustomerUpdate' => '',
      'History::EmailAgent' => '',
      'History::EmailCustomer' => '',
      'History::FollowUp' => '',
      'History::Forward' => '',
      'History::Lock' => '',
      'History::LoopProtection' => '',
      'History::Misc' => '',
      'History::Move' => '',
      'History::NewTicket' => '',
      'History::OwnerUpdate' => '',
      'History::PhoneCallAgent' => '',
      'History::PhoneCallCustomer' => '',
      'History::PriorityUpdate' => '',
      'History::Remove' => '',
      'History::SendAgentNotification' => '',
      'History::SendAnswer' => '',
      'History::SendAutoFollowUp' => '',
      'History::SendAutoReject' => '',
      'History::SendAutoReply' => '',
      'History::SendCustomerNotification' => '',
      'History::SetPendingTime' => '',
      'History::StateUpdate' => '',
      'History::TicketFreeTextUpdate' => '',
      'History::TicketLinkAdd' => '',
      'History::TicketLinkDelete' => '',
      'History::TimeAccounting' => '',
      'History::Unlock' => '',
      'History::WebRequestCustomer' => '',
      'Hit' => 'Találat',
      'Hits' => 'Találat',
      'hour' => 'óra',
      'hours' => 'óra',
      'Ignore' => 'Figyelmen kívül hagy',
      'invalid' => 'hibás',
      'Invalid SessionID!' => 'Hibás SessionID!',
      'Language' => 'Nyelv',
      'Languages' => 'Nyelv',
      'last' => 'utolsó',
      'Line' => 'Vonal',
      'Lite' => 'Egyszerû',
      'Login failed! Your username or password was entered incorrectly.' => 'Belépés sikertelen! Hibásan adta meg a felhasználói nevét vagy jelszavát.',
      'Logout successful. Thank you for using OTRS!' => 'Kilépés rendben! Köszönjük, hogy az OTRS-t használja!',
      'Message' => 'Üzenet',
      'minute' => 'Perc',
      'minutes' => 'perc',
      'Module' => 'Modul',
      'Modulefile' => 'Modulfile',
      'month(s)' => 'hónap',
      'Name' => 'Név',
      'New Article' => 'Új cikk',
      'New message' => 'Új üzenet',
      'New message!' => 'Új üzenet!',
      'Next' => '',
      'Next...' => '',
      'No' => 'Nem',
      'no' => 'nem',
      'No entry found!' => 'Nem található tétel!',
      'No Permission!' => '',
      'No such Ticket Number "%s"! Can\'t link it!' => '',
      'No suggestions' => 'Nincsenek javaslatok',
      'none' => 'semmi',
      'none - answered' => 'semmi - megválaszolt',
      'none!' => 'semmi!',
      'Normal' => 'Normál',
      'off' => 'ki',
      'Off' => 'Ki',
      'On' => 'Be',
      'on' => 'be',
      'Online Agent: %s' => '',
      'Online Customer: %s' => '',
      'Password' => 'Jelszó',
      'Passwords dosn\'t match! Please try it again!' => '',
      'Pending till' => 'Várakozás amíg',
      'Please answer this ticket(s) to get back to the normal queue view!' => 'Kérjük válaszoljon erre(ezekre) a jegy(ek)re hogy visszatérhessen a normál ügyek nézethez!',
      'Please contact your admin' => 'Kérjük vegye fel a kapcsolatot a rendszergazdájával',
      'please do not edit!' => 'kérjük ne javítsa!',
      'possible' => 'lehetséges',
      'Preview' => 'Elõnézet',
      'QueueView' => 'ÜgyekNézet',
      'reject' => 'elutasít',
      'replace with' => 'csere ezzel',
      'Reset' => 'Alapállás',
      'Salutation' => 'Megszólítás',
      'Session has timed out. Please log in again.' => 'Az ügymenet idõtúllépésmiatt befejezõdött. Kérjük lépjen be újra.',
      'Show closed Tickets' => 'Mutasd a lezárt jegyeket',
      'Sign' => '',
      'Signature' => 'Aláírás',
      'Signed' => '',
      'Size' => '',
      'Sorry' => 'Sajnálom',
      'Stats' => 'Statisztika',
      'Subfunction' => 'Alfunkció',
      'submit' => 'elküld',
      'submit!' => 'Elküld!',
      'system' => 'rendszer',
      'Take this Customer' => '',
      'Take this User' => 'Foglalt ennek a felhasználónak',
      'Text' => 'Szöveg',
      'The recommended charset for your language is %s!' => 'Az ajánlott karakterkészlet az ön nyelvénél %s!',
      'Theme' => 'Téma',
      'There is no account with that login name.' => 'Azzal a névvel nincs azonosító.',
      'Ticket Number' => '',
      'Timeover' => 'Késés',
      'To: (%s) replaced with database email!' => 'Címzett: (%s) felülírva az adatbázis címmel!',
      'top' => 'Teteje',
      'Type' => 'Típus',
      'update' => 'frissít',
      'Update' => 'Frissít',
      'update!' => 'Frissít!',
      'Upload' => '',
      'User' => 'Felhasználó',
      'Username' => 'Felhasználónév',
      'Valid' => 'Érvényes',
      'Warning' => 'Figyelem',
      'week(s)' => 'hét',
      'Welcome to OTRS' => 'Üdvözli az OTRS',
      'Word' => 'Szó',
      'wrote' => 'írta',
      'year(s)' => 'év',
      'Yes' => 'Igen',
      'yes' => 'igen',
      'You got new message!' => 'Új üzenete érkezett!',
      'You have %s new message(s)!' => '%s új üzenete van!',
      'You have %s reminder ticket(s)!' => '%s emlékeztetõ jegye van!',

    # Template: AAAMonth
      'Apr' => 'Ápr',
      'Aug' => 'Aug',
      'Dec' => 'Dec',
      'Feb' => 'Feb',
      'Jan' => 'Jan',
      'Jul' => 'Júl',
      'Jun' => 'Jún',
      'Mar' => 'Már',
      'May' => 'Máj',
      'Nov' => 'Nov',
      'Oct' => 'Okt',
      'Sep' => 'Sze',

    # Template: AAAPreferences
      'Closed Tickets' => 'Lezárt jegyek',
      'CreateTicket' => 'Jegylétrehozás',
      'Custom Queue' => 'Egyedi ügyek',
      'Follow up notification' => 'Válaszlevél értesítés',
      'Frontend' => 'Munkafelület',
      'Mail Management' => 'Email kezelés',
      'Max. shown Tickets a page in Overview.' => 'Max. megjelenített jegy az áttekintésnél.',
      'Max. shown Tickets a page in QueueView.' => 'Max. megjelenített jegy az ügyek nézetnél.',
      'Move notification' => 'Áthelyezés értesítés',
      'New ticket notification' => 'Új jegy értesítés',
      'Other Options' => 'Egyéb beállítások',
      'PhoneView' => 'TelefonNézet',
      'Preferences updated successfully!' => 'Beállítások sikeresen frissítve!',
      'QueueView refresh time' => 'ÜgyekNézet frissítési idõ',
      'Screen after new ticket' => 'Új jegy utáni képernyõ',
      'Select your default spelling dictionary.' => 'Válassza ki az alapértelmezett helyesírásellenõrzõ szótárat.',
      'Select your frontend Charset.' => 'Válassza ki a munkafelület karakterkészletét.',
      'Select your frontend language.' => 'Válassza ki a munkafelület nyelvét.',
      'Select your frontend QueueView.' => 'Válassza ki a munkafelület Ügyek-nézetét.',
      'Select your frontend Theme.' => 'Válassza ki a munkafelület stílusát.',
      'Select your QueueView refresh time.' => 'Válassza ki az ÜgyekNézet frissítési idejét.',
      'Select your screen after creating a new ticket.' => 'Válassza ki a képernyõt új jegy létrehozása után.',
      'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.' => 'Küldjön értesítést ha az ügyfél válaszol és én vagyok a tulajdonosa a jegynek.',
      'Send me a notification if a ticket is moved into one of "My Queues".' => '',
      'Send me a notification if a ticket is unlocked by the system.' => 'Küldjön értesítést ha a jegy zárolását a renszer feloldotta.',
      'Send me a notification if there is a new ticket in "My Queues".' => '',
      'Show closed tickets.' => 'Mutasd a lezárt jegyeket.',
      'Spelling Dictionary' => 'Helyesírás-ellenõrzõ szótár',
      'Ticket lock timeout notification' => 'Jegyzárolás-lejárat értesítés',
      'TicketZoom' => 'JegyNagyítás',

    # Template: AAATicket
      '1 very low' => '1 nagyon alacsony',
      '2 low' => '2 alacsony',
      '3 normal' => '3 normál',
      '4 high' => '4 magas',
      '5 very high' => '5 nagyon magas',
      'Action' => 'Mûvelet',
      'Age' => 'Kor',
      'Article' => 'Cikk',
      'Attachment' => 'Csatolás',
      'Attachments' => 'Csatolás',
      'Bcc' => 'Vakmásolat',
      'Bounce' => 'Visszaküld',
      'Cc' => 'Másolat',
      'Close' => 'Lezár',
      'closed' => '',
      'closed successful' => 'sikeresen lezárva',
      'closed unsuccessful' => 'sikertelenül lezárva',
      'Compose' => 'Készít',
      'Created' => 'Elkészítve',
      'Createtime' => 'Elkészült ',
      'email' => 'email',
      'eMail' => 'eMail',
      'email-external' => 'külsõ email',
      'email-internal' => 'belsõ email',
      'Forward' => 'Továbbít',
      'From' => 'Feladó',
      'high' => 'magas',
      'History' => 'Történet',
      'If it is not displayed correctly,' => 'Ha nem helyesen jelent meg,',
      'lock' => 'zárolt',
      'Lock' => 'Zárol',
      'low' => 'alacsony',
      'Move' => 'Áthelyez',
      'new' => 'új',
      'normal' => 'normál',
      'note-external' => 'külsõ jegyzet',
      'note-internal' => 'belsõ jegyzet',
      'note-report' => 'jegyzet jelentés',
      'open' => 'nyitva',
      'Owner' => 'Tulajdonos',
      'Pending' => 'Várakozik',
      'pending auto close+' => 'automatikus zárásra várakozik+',
      'pending auto close-' => 'automatikus zárásra várakozik-',
      'pending reminder' => 'emlékeztetõre várakozik',
      'phone' => 'telefon',
      'plain' => 'sima',
      'Priority' => 'Sürgõsség',
      'Queue' => 'Ügyek',
      'removed' => 'törölve',
      'Sender' => 'Küldõ',
      'sms' => 'sms',
      'State' => 'Állapot',
      'Subject' => 'Tárgy',
      'This is a' => 'Ez egy',
      'This is a HTML email. Click here to show it.' => 'Ez egy HTML email. Kattintson ide a megtekintéshez.',
      'This message was written in a character set other than your own.' => 'Ezt az üzenetet más karakterkészlettel írták mint amit ön használ.',
      'Ticket' => 'Jegy',
      'Ticket "%s" created!' => 'A "%s" jegy létrehozva!',
      'To' => 'Címzett',
      'to open it in a new window.' => 'hogy megnyissa új ablakban.',
      'Unlock' => 'Felold',
      'unlock' => 'feloldva',
      'very high' => 'nagyon magas',
      'very low' => 'nagyon alacsony',
      'View' => 'Nézet',
      'webrequest' => 'webkérés',
      'Zoom' => 'Nagyít',

    # Template: AAAWeekDay
      'Fri' => 'Pén',
      'Mon' => 'Hét',
      'Sat' => 'Szo',
      'Sun' => 'Vas',
      'Thu' => 'Csü',
      'Tue' => 'Ked',
      'Wed' => 'Sze',

    # Template: AdminAttachmentForm
      'Add' => 'Hozzáad',
      'Attachment Management' => 'Csatolás kezelése',

    # Template: AdminAutoResponseForm
      'Auto Response From' => 'Automatikus válasz feladónak',
      'Auto Response Management' => 'Automatikus válasz kezelõnek',
      'Note' => 'Jegyzet',
      'Response' => 'Válasz',
      'to get the first 20 character of the subject' => 'hogy megkapja az elsõ 20 karaktert a tárgyból',
      'to get the first 5 lines of the email' => 'hogy megkapja az elsõ 5 sort az email-bõl',
      'to get the from line of the email' => 'hogy megkapja a feladót az email-bõl',
      'to get the realname of the sender (if given)' => 'hogy megkapja a feladó valódi nevét (ha lehetséges)',
      'to get the ticket id of the ticket' => 'hogy megkapja a jegyazonosítót a jegybõl',
      'to get the ticket number of the ticket' => 'hogy megkapja a jegysorszámot a jegybõl',
      'Useable options' => 'Használható opciók',

    # Template: AdminCustomerUserForm
      'Customer User Management' => 'Ügyfél felhasználók kezelése',
      'Customer user will be needed to have an customer histor and to to login via customer panels.' => '',
      'Result' => '',
      'Search' => 'Keresés',
      'Search for' => '',
      'Select Source (for add)' => '',
      'Source' => 'Forrás',
      'The message being composed has been closed.  Exiting.' => 'Az éppen elkészült levél lezárásra került. Kilépés.',
      'This values are read only.' => '',
      'This values are required.' => '',
      'This window must be called from compose window' => 'Ezt az ablakot a szerkesztõ ablakból kell hívni',

    # Template: AdminCustomerUserGroupChangeForm
      'Change %s settings' => '%s beállításainak módosítása',
      'Customer User <-> Group Management' => 'Ügyfél felhasználó <-> Csoportok kezelése',
      'Full read and write access to the tickets in this group/queue.' => 'Teljes írás és olvasási jog a jegyekhez ebben a csoportban/ügyben.',
      'If nothing is selected, then there are no permissions in this group (tickets will not be available for the user).' => 'Ha nincs semmi kiválasztva, akkor nincsenek jogosultságok ebben a csoportban (a jegyek nem lesznek elérhetõk a felhasználónak).',
      'Permission' => 'Jogosultság',
      'Read only access to the ticket in this group/queue.' => 'Csak olvasási jogosultság a jegyekhez ebben a csoportban/ügyben.',
      'ro' => 'Csak olvasás',
      'rw' => 'Írás/Olvasás',
      'Select the user:group permissions.' => 'A felhasználó:csoport jogok kiválasztása.',

    # Template: AdminCustomerUserGroupForm
      'Change user <-> group settings' => 'A felhasználó <-> csoport beállítások megváltoztatása',

    # Template: AdminEmail
      'Admin-Email' => 'Kezelõ-Email',
      'Body' => 'Törzs',
      'OTRS-Admin Info!' => 'OTRS-Kezelõ Info!',
      'Recipents' => 'Címzettek',
      'send' => 'küld',

    # Template: AdminEmailSent
      'Message sent to' => 'Üzenet elküldve',

    # Template: AdminGenericAgent
      '(e. g. 10*5155 or 105658*)' => 'pl. 10*5144 vagy 105658*',
      '(e. g. 234321)' => 'pl. 234321',
      '(e. g. U5150)' => 'pl. U5150',
      '-' => '',
      'Add Note' => 'Megjegyzés hozzáadása',
      'Agent' => 'Ügynök',
      'and' => 'és',
      'CMD' => '',
      'Customer User Login' => 'Ügyfél felhasználó belépés',
      'CustomerID' => 'Ügyfélszám#',
      'CustomerUser' => 'Ügyfél',
      'Days' => '',
      'Delete' => 'Töröl',
      'Delete tickets' => '',
      'Edit' => 'Szerkeszt',
      'Fulltext-Search in Article (e. g. "Mar*in" or "Baue*")' => 'Teljesszöveg keresés a cikkben (pl. "Mar*in" oder "Baue*")',
      'GenericAgent' => '',
      'Hours' => '',
      'Job-List' => '',
      'Jobs' => '',
      'Last run' => '',
      'Minutes' => '',
      'Modules' => '',
      'New Agent' => '',
      'New Customer' => '',
      'New Owner' => 'Új tulajdonos',
      'New Priority' => '',
      'New Queue' => 'Új ügy',
      'New State' => '',
      'New Ticket Lock' => '',
      'No time settings.' => 'Nincs idõbeállítás.',
      'Param 1' => '',
      'Param 2' => '',
      'Param 3' => '',
      'Param 4' => '',
      'Param 5' => '',
      'Param 6' => '',
      'Save' => '',
      'Save Job as?' => '',
      'Schedule' => '',
      'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' => '',
      'Ticket created' => 'Jegy létrehozva',
      'Ticket created between' => 'Jegy létrehozva közöttük:',
      'Ticket Lock' => '',
      'TicketFreeText' => 'Jegy szabadszöveg',
      'Times' => 'Idõk',
      'Warning! This tickets will be removed from the database! This tickets are lost!' => '',

    # Template: AdminGroupForm
      'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).' => 'Hozzon létre új csoportot a különbözõ ügynök csoportok (pl. beszerzõ osztály, támogató osztály, eladó osztály, ...) hozzáférési jogainak kezeléséhez.',
      'Group Management' => 'Csoport kezelés',
      'It\'s useful for ASP solutions.' => 'Ez hasznos ASP megoldásokhoz.',
      'The admin group is to get in the admin area and the stats group to get stats area.' => 'Az admin csoport megkapja az admin területet és a státusz csoport megkapja a státusz területet.',

    # Template: AdminLog
      'System Log' => 'Rendszernapló',
      'Time' => '',

    # Template: AdminNavigationBar
      'AdminEmail' => 'KezelõEmail',
      'Attachment <-> Response' => 'Csatolás <-> Válasz',
      'Auto Response <-> Queue' => 'Automatikus válasz <-> Ügyek',
      'Auto Responses' => 'Automatikus válaszok',
      'Customer User' => 'Ügyfél felhasználó',
      'Customer User <-> Groups' => 'Ügyfél felhasználó <-> Csoportok',
      'Email Addresses' => 'Email címek',
      'Groups' => 'Csoportok',
      'Logout' => 'Kilép',
      'Misc' => 'Egyéb',
      'Notifications' => 'Értesítések',
      'PGP Keys' => '',
      'PostMaster Filter' => 'PostaMester szûrõ',
      'PostMaster POP3 Account' => 'PostaMester POP3 azonosító',
      'Responses' => 'Válaszok',
      'Responses <-> Queue' => 'Válaszok <-> Ügyek',
      'Role' => '',
      'Role <-> Group' => '',
      'Role <-> User' => '',
      'Roles' => '',
      'Select Box' => 'SQL Parancsok',
      'Session Management' => 'Folyamatkezelés',
      'SMIME Certificates' => '',
      'Status' => 'Állapot',
      'System' => 'Rendszer',
      'User <-> Groups' => 'Felhasználó <-> Csoportok',

    # Template: AdminNotificationForm
      'Config options (e. g. &lt;OTRS_CONFIG_HttpType&gt;)' => 'Beállítás opciók (pl. &lt;OTRS_CONFIG_HttpType&gt;)',
      'Notification Management' => 'Értesítéskezelés',
      'Notifications are sent to an agent or a customer.' => 'Az értesítések ügynöknek vagy ügyfélnek kerülnek elküldésre.',
      'Options of the current customer user data (e. g. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)' => 'Opciók az aktuális ügyfél felhasználói adatokhoz (pl. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)',
      'Options of the current user who requested this action (e. g. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)' => 'Opciók a aktuális felhasználónál aki kérte ezt az eljárást. (pl. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)',
      'Ticket owner options (e. g. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)' => 'Jegy tulajdonos opciók (pl. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)',

    # Template: AdminPGPForm
      'Bit' => '',
      'Expires' => '',
      'File' => '',
      'Fingerprint' => '',
      'FIXME: WHAT IS PGP?' => '',
      'Identifier' => '',
      'In this way you can directly edit the keyring configured in Kernel/Config.pm.' => '',
      'Key' => 'Kulcs',
      'PGP Key Management' => '',

    # Template: AdminPOP3Form
      'All incoming emails with one account will be dispatched in the selected queue!' => 'Az összes egy azonosítóval rendelkezõ bejövõ email egy kiválasztott ügynélhöz lesz rendelve!',
      'Dispatching' => 'Hozzárendelés',
      'Host' => 'Gazda',
      'If your account is trusted, the already existing x-otrs header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' => '',
      'POP3 Account Management' => 'POP3 azonosító kezelése',
      'Trusted' => 'Megbízható',

    # Template: AdminPostMasterFilter
      'Do dispatch or filter incoming emails based on email X-Headers! RegExp is also possible.' => '',
      'Filtername' => '',
      'Header' => '',
      'If you use RegExp, you also can use the matched value in () as [***] in \'Set\'.' => '',
      'Match' => 'Egyezés',
      'PostMaster Filter Management' => '',
      'Set' => 'Beállít',
      'Value' => 'Érték',

    # Template: AdminQueueAutoResponseForm
      'Queue <-> Auto Response Management' => 'Ügyek <-> Automatikus válasz kezelés',

    # Template: AdminQueueAutoResponseTable

    # Template: AdminQueueForm
      '0 = no escalation' => '0 = nincs eszkaláció',
      '0 = no unlock' => '0 = nincs feloldás',
      'Customer Move Notify' => 'Ügyfél értesítés mozgatáskor',
      'Customer Owner Notify' => 'Ügyfél értesítés tulajdonsováltáskor',
      'Customer State Notify' => 'Ügyfél értesítés állapotváltozáskor',
      'Escalation time' => 'Eszkaláció idõ',
      'Follow up Option' => 'Válasz opciók',
      'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.' => 'Ha a jegy le van zárva és az ügyfél válaszol a jegyre, akkor az zárolásra kerül a régi tulajdonosnak.',
      'If a ticket will not be answered in thos time, just only this ticket will be shown.' => 'Ha a jegy nem kerül megválaszolásra a megadott idõn belül, csak ez a jegy lesz megjelenítve.',
      'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.' => 'Ha az ügynök zárolja a jegyet és nem küld választ ezen idõn belül, a jegy zárolása megszûnik. Így a jegy látható lesz minden ügynöknek.',
      'OTRS sends an notification email to the customer if the ticket is moved.' => 'Az OTRS értesítõ levelet küld az ügyfélnek ha a jegy áthelyezésre került.',
      'OTRS sends an notification email to the customer if the ticket owner has changed.' => 'Az OTRS értesítõ levelet küld az ügyfélnek ha a jegy tulajdonosa megváltozott.',
      'OTRS sends an notification email to the customer if the ticket state has changed.' => 'Az OTRS értesítõ levelet küld az ügyfélnek ha a jegy állapota megváltozott.',
      'Queue Management' => 'Ügyek kezelése',
      'Sub-Queue of' => 'Al-Ügye a(z)',
      'Systemaddress' => 'Rendszercím',
      'The salutation for email answers.' => 'A megszólítás az email válaszokhoz.',
      'The signature for email answers.' => 'Az aláírás a válasz emailekhez.',
      'Ticket lock after a follow up' => 'Jegy zárolása válasz érkezése után.',
      'Unlock timeout' => 'Feloldás idõtúllépés',
      'Will be the sender address of this queue for email answers.' => 'Ennél az ügynél ez lesz a feladó email válaszokhoz.',

    # Template: AdminQueueResponsesChangeForm
      'Std. Responses <-> Queue Management' => 'Alap válaszok <-> Ügyek kezelése',

    # Template: AdminQueueResponsesForm
      'Answer' => 'Válasz',

    # Template: AdminResponseAttachmentChangeForm
      'Std. Responses <-> Std. Attachment Management' => 'Alap válaszok <-> Alap csatolások kezelése',

    # Template: AdminResponseAttachmentForm

    # Template: AdminResponseForm
      'A response is default text to write faster answer (with default text) to customers.' => 'Egy reakció az alapértelmezett szöveg gyors válaszokhoz (az alapértelmezett szöveggel) az ügyfeleknek.',
      'All Customer variables like defined in config option CustomerUser.' => '',
      'Don\'t forget to add a new response a queue!' => 'Ne felejtsen el új reakciót hozzáadni az ügyhöz!',
      'Next state' => 'Következõ állapot',
      'Response Management' => 'Reakció kezelés',
      'The current ticket state is' => 'A jegy aktuális állapota',
      'Your email address is new' => '',

    # Template: AdminRoleForm
      'Create a role and put groups in it. Then add the role to the users.' => '',
      'It\'s useful for a lot of users and groups.' => '',
      'Role Management' => '',

    # Template: AdminRoleGroupChangeForm
      'create' => 'készít',
      'move_into' => 'mozgat',
      'owner' => 'tulajdonos',
      'Permissions to change the ticket owner in this group/queue.' => 'Jogosultságok a jegy tulajdonosának megváltoztatásához ebben a csoportban/ügyben.',
      'Permissions to change the ticket priority in this group/queue.' => 'Jogosultágok a jegy prioritásnak megváltoztatásához ebben a csoportban/ügyben.',
      'Permissions to create tickets in this group/queue.' => 'Jogosultságok új jegyek létrehozásához ebben a csoportban/ügyben.',
      'Permissions to move tickets into this group/queue.' => 'Jogosultságok jegyek áthelyezéséhez ebbe a csoportba/ügybe.',
      'priority' => 'sürgõsség',
      'Role <-> Group Management' => '',

    # Template: AdminRoleGroupForm
      'Change role <-> group settings' => '',

    # Template: AdminRoleUserChangeForm
      'Active' => '',
      'Role <-> User Management' => '',
      'Select the role:user relations.' => '',

    # Template: AdminRoleUserForm
      'Change user <-> role settings' => '',

    # Template: AdminSMIMEForm
      'Add Certificate' => '',
      'Add Private Key' => '',
      'FIXME: WHAT IS SMIME?' => '',
      'Hash' => '',
      'In this way you can directly edit the certification and private keys in file system.' => '',
      'Secret' => '',
      'SMIME Certificate Management' => '',

    # Template: AdminSalutationForm
      'customer realname' => 'ügyfél valódi név',
      'for agent firstname' => 'ügynök keresztnévhez',
      'for agent lastname' => 'ügynök családinévhez',
      'for agent login' => 'ügynök belépéséhez',
      'for agent user id' => 'ügynük felhasználó azonosítójához',
      'Salutation Management' => 'Megszólítás kezelés',

    # Template: AdminSelectBoxForm
      'Limit' => 'Korlát',
      'SQL' => 'SQL',

    # Template: AdminSelectBoxResult
      'Select Box Result' => 'SQL Parancs eredmény',

    # Template: AdminSession
      'kill all sessions' => 'Minden eljárás kilövése',
      'kill session' => 'folyamat leállítása',
      'Overview' => 'Áttekintõ',
      'Session' => '',
      'Sessions' => 'Eljárások',
      'Uniq' => 'Egyedi',

    # Template: AdminSignatureForm
      'Signature Management' => 'Aláírás kezelés',

    # Template: AdminStateForm
      'See also' => 'Lásd még',
      'State Type' => 'Állapot típus',
      'System State Management' => 'Rendszerállapot kezelés',
      'Take care that you also updated the default states in you Kernel/Config.pm!' => 'Figyeljen oda, hogy az Kernel/Config.pm fájlban is frissítse az alapértelmezett állapotokat!',

    # Template: AdminSystemAddressForm
      'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!' => 'Az összes bejövõ email ezzel az "Email"-el (Címzett:) a kiválasztott ügyhöz lesz rendelve!',
      'Email' => 'Email',
      'Realname' => 'Valódi név',
      'System Email Addresses Management' => 'Rendszer email címek kezelése',

    # Template: AdminUserForm
      'Don\'t forget to add a new user to groups!' => 'Ne felejtsen el új felhasználót hozzáadni a csoportokhoz!',
      'Firstname' => 'Keresztnév',
      'Lastname' => 'Családi név',
      'User Management' => 'Felhasználó kezelés',
      'User will be needed to handle tickets.' => 'Felhasználó kell a jegyek kezeléséhez.',

    # Template: AdminUserGroupChangeForm
      'User <-> Group Management' => 'Felhasználó <-> Csoport kezelés',

    # Template: AdminUserGroupForm

    # Template: AgentBook
      'Address Book' => 'Címjegyzék',
      'Discard all changes and return to the compose screen' => 'Minden változtatás megsemmisítése és visszatérés a szerkesztõképernyõre',
      'Return to the compose screen' => 'Visszatérés a szerkesztõképernyõre',

    # Template: AgentBounce
      'A message should have a To: recipient!' => 'Egy üzenethez kellene legyen címzett!',
      'Bounce ticket' => 'Jegy visszaküldése',
      'Bounce to' => 'Visszaküldés ide:',
      'Inform sender' => 'Küldõ tájékoztatása',
      'Next ticket state' => 'A jegy következõ állapota',
      'Send mail!' => 'Email küldése!',
      'You need a email address (e. g. customer@example.com) in To:!' => 'Kell egy email cím (pl. customer@example.com) címzettnek!',
      'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further informations.' => 'Az ön "<OTRS_TICKET>" számú jegyhez rendelt emailje visszaküldésre került a "<OTRS_BOUNCE_TO>" címre. Vegye fel ezzel a címmel a kapcsolatot további információkért.',

    # Template: AgentBulk
      '$Text{"Note!' => '',
      'A message should have a subject!' => 'Egy üzenetnek kell legyen tárgya!',
      'Note type' => 'Jegyzet típus',
      'Note!' => 'Megjegyzés!',
      'Options' => 'Beállítások',
      'Spell Check' => 'Helyesírásellenõrzés',
      'Ticket Bulk Action' => '',

    # Template: AgentClose
      ' (work units)' => ' (munkaegység)',
      'A message should have a body!' => 'Egy üzenetnek kell legyen törzse!',
      'Close ticket' => 'Jegy lezárása',
      'Close type' => 'Típus lezárása',
      'Close!' => 'Lezár!',
      'Note Text' => 'Jegyzet szöveg',
      'Time units' => 'Idõ egységek',
      'You need to account time!' => 'El kell számolnia az idõvel!',

    # Template: AgentCompose
      'A message must be spell checked!' => 'Az üzenetnek helyesírásellenõrzésen kell átmennie!',
      'Attach' => 'Csatol',
      'Compose answer for ticket' => 'Válaszadás a jegyre',
      'for pending* states' => 'várakozó* státuszhoz',
      'Is the ticket answered' => 'Megválaszolt-e a jegy',
      'Pending Date' => 'Várakozás dátuma',

    # Template: AgentCrypt

    # Template: AgentCustomer
      'Change customer of ticket' => 'A jegy ügyfelének megváltoztatása',
      'Search Customer' => 'Ügyfél keresése',
      'Set customer user and customer id of a ticket' => 'A jegy ügyfél felhasználójának és ügyfél azonosítójának megbeállítása',

    # Template: AgentCustomerHistory
      'All customer tickets.' => 'Összes ügyfél jegy.',
      'Customer history' => 'Ügyfél történet',

    # Template: AgentCustomerMessage
      'Follow up' => 'Válasz',

    # Template: AgentCustomerView
      'Customer Data' => 'Ügyfél adatok',

    # Template: AgentEmailNew
      'All Agents' => 'Minden ügynök',
      'Clear To' => '',
      'Compose Email' => 'Új Email írása',
      'new ticket' => 'új jegy',

    # Template: AgentForward
      'Article type' => 'Cikk típusa',
      'Date' => 'Dátum',
      'End forwarded message' => 'Vége a továbbított üzenetnek',
      'Forward article of ticket' => 'Továbbított cikk a jegyben',
      'Forwarded message from' => 'Továbbított üzenet innen',
      'Reply-To' => 'Válasz-Ide',

    # Template: AgentFreeText
      'Change free text of ticket' => 'Szabad szöveg változtatása a jegyben',

    # Template: AgentHistoryForm
      'History of' => 'Története ennek:',

    # Template: AgentHistoryRow

    # Template: AgentInfo
      'Info' => 'Info',

    # Template: AgentLookup
      'Lookup' => '',

    # Template: AgentMailboxNavBar
      'All messages' => 'Minden üzenet',
      'down' => 'le',
      'Mailbox' => 'Postafiók',
      'New' => 'Új',
      'New messages' => 'Új üzenetek',
      'Open' => 'Nyitva',
      'Open messages' => 'Nyitott üzenetek',
      'Order' => 'Sorrend',
      'Pending messages' => 'Várakozó üzenetek',
      'Reminder' => 'Emlékeztetõ',
      'Reminder messages' => 'Emlékeztetõ üzenetek',
      'Sort by' => 'Rendezés így',
      'Tickets' => 'Jegyek',
      'up' => 'fel',

    # Template: AgentMailboxTicket
      '"}' => '}',
      '"}","14' => '"}","14',
      'Add a note to this ticket!' => '',
      'Change the ticket customer!' => '',
      'Change the ticket owner!' => '',
      'Change the ticket priority!' => '',
      'Close this ticket!' => '',
      'Shows the detail view of this ticket!' => '',
      'Unlock this ticket!' => '',

    # Template: AgentMove
      'Move Ticket' => 'Jegy áthelyezése',
      'Previous Owner' => 'Korábbi tulajdonos',
      'Queue ID' => 'Ügy azonosító',

    # Template: AgentNavigationBar
      'Agent Preferences' => '',
      'Bulk Action' => '',
      'Bulk Actions on Tickets' => '',
      'Create new Email Ticket' => '',
      'Create new Phone Ticket' => '',
      'Email-Ticket' => '',
      'Locked tickets' => 'Zárolt jegyek',
      'new message' => 'új üzenet',
      'Overview of all open Tickets' => '',
      'Phone-Ticket' => '',
      'Preferences' => 'Beállítások',
      'Search Tickets' => '',
      'Ticket selected for bulk action!' => '',
      'You need min. one selected Ticket!' => '',

    # Template: AgentNote
      'Add note to ticket' => 'Megjegyzés hozzáadása a jegyhez',

    # Template: AgentOwner
      'Change owner of ticket' => 'Jegy tulajdonosának módosítása',
      'Message for new Owner' => 'Üzenet az új tulajdonosnak',

    # Template: AgentPending
      'Pending date' => 'Várakozási dátum',
      'Pending type' => 'Várakozás típusa',
      'Set Pending' => 'Várakozás beállítás',

    # Template: AgentPhone
      'Phone call' => 'Telefonhívás',

    # Template: AgentPhoneNew
      'Clear From' => 'Feladó törlése',

    # Template: AgentPlain
      'ArticleID' => 'Cikkazonosító',
      'Download' => '',
      'Plain' => 'Egyszerû',
      'TicketID' => 'Jegyazonosító',

    # Template: AgentPreferencesCustomQueue
      'My Queues' => '',
      'You also get notified about this queues via email if enabled.' => '',
      'Your queue selection of your favorite queues.' => '',

    # Template: AgentPreferencesForm

    # Template: AgentPreferencesGeneric

    # Template: AgentPreferencesPassword
      'Change Password' => 'Jelszó módosítása',
      'New password' => 'Új jelszó',
      'New password again' => 'Új jelszó ismét',

    # Template: AgentPriority
      'Change priority of ticket' => 'Jegy sürgõsségének módosítása',

    # Template: AgentSpelling
      'Apply these changes' => 'Módosítások érvényesítése',
      'Spell Checker' => 'Helyesírásellenõrzõ',
      'spelling error(s)' => 'helyesírási hiba(k)',

    # Template: AgentStatusView
      'D' => 'Z',
      'of' => 'kitõl',
      'Site' => 'Gép',
      'sort downward' => 'rendezés lefelé',
      'sort upward' => 'rendezés felfelé',
      'Ticket Status' => 'Jegy állapota',
      'U' => 'A',

    # Template: AgentTicketLink
      'Delete Link' => '',
      'Link' => 'Hivatkozás',
      'Link to' => 'Hivatkozás ide',

    # Template: AgentTicketLocked
      'Ticket locked!' => 'Jegy lezárva!',
      'Ticket unlock!' => 'Jegy feloldva!',

    # Template: AgentTicketPrint

    # Template: AgentTicketPrintHeader
      'Accounted time' => 'Elszámolt idõ',
      'Escalation in' => 'Eszkaláció ebben',

    # Template: AgentUtilSearch
      'Profile' => 'Profil',
      'Result Form' => 'Eredmény ürlap',
      'Save Search-Profile as Template?' => 'Elmenti a keresõ profilt sablonként?',
      'Search-Template' => 'Keresõ sablon',
      'Select' => 'Kiválaszt',
      'Ticket Search' => 'Jegy keresés',
      'Yes, save it with name' => 'Igen, elmentve ezen a néven',

    # Template: AgentUtilSearchByCustomerID
      'Customer history search' => 'Keresés az ügyfél történetében',
      'Customer history search (e. g. "ID342425").' => 'Keresés az ügyfél történetében (pl. "ID342425").',
      'No * possible!' => 'A "*" nem lehetséges!',

    # Template: AgentUtilSearchResult
      'Change search options' => 'Keresési beállítások módosítása',
      'Results' => 'Eredmények',
      'Search Result' => 'Keresési eredmény',
      'Total hits' => 'Összes találat',

    # Template: AgentUtilSearchResultPrint

    # Template: AgentUtilSearchResultShort

    # Template: AgentUtilTicketStatus
      'All closed tickets' => 'Minden lezárt jegy',
      'All open tickets' => 'Minden nyitott jegy',
      'closed tickets' => 'lezárt jegyek',
      'open tickets' => 'nyitott jegyek',
      'or' => 'vagy',
      'Provides an overview of all' => 'Áttekintést ad az összesrõl',
      'So you see what is going on in your system.' => 'Szóval ön látja mi folyik a rendszerében.',

    # Template: AgentZoomAgentIsCustomer
      'Compose Follow up' => 'Válasz írása',
      'Your own Ticket' => 'Az ön saját jegye',

    # Template: AgentZoomAnswer
      'Compose Answer' => 'Válasz írása',
      'Contact customer' => 'Kapcsolatbalépés az ügyféllel',
      'phone call' => 'Telefonhívás',

    # Template: AgentZoomArticle
      'Split' => 'Felosztás',

    # Template: AgentZoomBody
      'Change queue' => 'Ügy változtatás',

    # Template: AgentZoomHead
      'Change the ticket free fields!' => '',
      'Free Fields' => 'Szabad mezõk',
      'Link this ticket to an other one!' => '',
      'Lock it to work on it!' => '',
      'Print' => 'Nyomtat',
      'Print this ticket!' => '',
      'Set this ticket to pending!' => '',
      'Shows the ticket history!' => '',

    # Template: AgentZoomStatus
      '"}","18' => '"}","18',
      'Locked' => '',
      'SLA Age' => '',

    # Template: Copyright
      'printed by' => 'Nyomtatta',

    # Template: CustomerAccept

    # Template: CustomerCreateAccount
      'Create Account' => 'Azonosító létrehozása',
      'Login' => 'Belépés',

    # Template: CustomerError
      'Traceback' => 'Visszakövetés',

    # Template: CustomerFAQArticleHistory
      'FAQ History' => 'GYIK történet',

    # Template: CustomerFAQArticlePrint
      'Category' => 'Kategória',
      'Keywords' => 'Kulcsszó',
      'Last update' => 'Utolsó frissítés',
      'Problem' => 'Probléma',
      'Solution' => 'Megoldás',
      'Symptom' => 'Jelenség',

    # Template: CustomerFAQArticleSystemHistory
      'FAQ System History' => 'GYIK rendszer történet',

    # Template: CustomerFAQArticleView
      'FAQ Article' => 'GYIK Cikk',
      'Modified' => 'Módosítva',

    # Template: CustomerFAQOverview
      'FAQ Overview' => 'GYIK Áttekintõ',

    # Template: CustomerFAQSearch
      'FAQ Search' => 'GYIK keresés',
      'Fulltext' => 'Teljesszöveg',
      'Keyword' => 'Kulcsszó',

    # Template: CustomerFAQSearchResult
      'FAQ Search Result' => 'GYIK keresés eredmény',

    # Template: CustomerFooter
      'Powered by' => 'Készítette',

    # Template: CustomerLostPassword
      'Lost your password?' => 'Elfelejtette a jelszavát?',
      'Request new password' => 'Új jelszó kérése',

    # Template: CustomerMessage

    # Template: CustomerMessageNew

    # Template: CustomerNavigationBar
      'CompanyTickets' => '',
      'Create new Ticket' => 'Új jegy létrehozása',
      'FAQ' => 'GYIK',
      'MyTickets' => '',
      'New Ticket' => 'Új jegy',
      'Welcome %s' => 'Üdvözöli a %s',

    # Template: CustomerPreferencesForm

    # Template: CustomerPreferencesGeneric

    # Template: CustomerPreferencesPassword

    # Template: CustomerStatusView

    # Template: CustomerTicketSearch

    # Template: CustomerTicketSearchResultPrint

    # Template: CustomerTicketSearchResultShort

    # Template: CustomerTicketZoom

    # Template: CustomerWarning

    # Template: Error
      'Click here to report a bug!' => 'Kattintson ide új hiba bejelentéséhez!',

    # Template: FAQArticleDelete
      'FAQ Delete' => 'GYIK törlése',
      'You really want to delete this article?' => 'Biztos, hogy törölni akarja ezt a cikket?',

    # Template: FAQArticleForm
      'A article should have a title!' => '',
      'Comment (internal)' => 'Megjegyzés (belsõ)',
      'Filename' => 'Fájlnév',
      'Title' => '',

    # Template: FAQArticleHistory

    # Template: FAQArticlePrint

    # Template: FAQArticleSystemHistory

    # Template: FAQArticleView

    # Template: FAQArticleViewSmall

    # Template: FAQCategoryForm
      'FAQ Category' => 'GYIK kategória',
      'Name is required!' => '',

    # Template: FAQLanguageForm
      'FAQ Language' => 'GYIK nyelv',

    # Template: FAQNavigationBar

    # Template: FAQOverview

    # Template: FAQSearch

    # Template: FAQSearchResult

    # Template: Footer
      'Top of Page' => 'Lap teteje',

    # Template: FooterSmall

    # Template: InstallerBody
      'Create Database' => 'Adatbázis létrehozása',
      'Drop Database' => 'Adatbázis törlése',
      'Finished' => 'Befejezve',
      'System Settings' => 'Rendszerbeállítások',
      'Web-Installer' => 'Web-telepítõ',

    # Template: InstallerFinish
      'Admin-User' => 'Admin-felhasználó',
      'After doing so your OTRS is up and running.' => 'Ha ez kész, az OTRS kész és fut.',
      'Have a lot of fun!' => 'Sok sikert!',
      'Restart your webserver' => 'Indítsa újra a web-kiszolgálót',
      'Start page' => 'Start oldal',
      'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' => 'Ahhoz, hogy az OTRS-t használni tudja, a következõ parancsot kell begépelnie parancssorban (terminálban/héjjban) root-ként.',
      'Your OTRS Team' => 'Az ön OTRS csapata',

    # Template: InstallerLicense
      'accept license' => 'Licenc elfogadása',
      'don\'t accept license' => 'Licenc elutasítása',
      'License' => 'Licenc',

    # Template: InstallerStart
      'Create new database' => 'Új adatbázis létrehozása',
      'DB Admin Password' => 'DB Admin jelszó',
      'DB Admin User' => 'DB Admin felhasználó',
      'DB Host' => 'DB Gazda',
      'DB Type' => 'DB típusa',
      'default \'hot\'' => 'alapértelmezett',
      'Delete old database' => 'Régi adatbázis törlése',
      'next step' => 'következõ lépés',
      'OTRS DB connect host' => 'OTRS DB kapcsolódik a gazdához',
      'OTRS DB Name' => 'OTRS DB név',
      'OTRS DB Password' => 'OTRS DB jelszó',
      'OTRS DB User' => 'OTRS DB felhasználó',
      'your MySQL DB should have a root password! Default is empty!' => 'Az ön MySQL adatbázisának kell legyen root jelszava! Az alapértelmezett üres!',

    # Template: InstallerSystem
      '(Checks MX recordes of used email addresses by composing an answer. Don\'t use CheckMXRecord if your OTRS machine is behinde a dial-up line $!)' => '(Ellenõrizd le az MX rekordot a használt email címben a válasz írásakor!)',
      '(Email of the system admin)' => '(E-Mail a rendszergazdának)',
      '(Full qualified domain name of your system)' => '(Teljes ellenõrzött domain név a rendszerben)',
      '(Logfile just needed for File-LogModule!)' => '(Logfile szükséges a File-LogModul számára!)',
      '(The identify of the system. Each ticket number and each http session id starts with this number)' => '(Azonosítás a rendszerben. Minden jegyhez és minden http eljárás ezzel a sorszámmal indul)',
      '(Ticket identifier. Some people want toset this to e. g. \'Ticket#\', \'Call#\' or \'MyTicket#\')' => '(Jegy azonosítûs. pl. \'Jegy#\', \'Hívó#\' vagy \'Jegyem#\')',
      '(Used default language)' => '(A felhasználó alapértelmezett nyelve)',
      '(Used log backend)' => '(Használt háttér log)',
      '(Used ticket number format)' => '(Nyitott jegyek sorszámának formátuma)',
      'CheckMXRecord' => 'MX Rekord ellenõrzés',
      'Default Charset' => 'Alapértelmezett karakterkészlet',
      'Default Language' => 'Alapértelmezett nyelv',
      'Logfile' => 'Log file',
      'LogModule' => 'Log modul',
      'Organization' => 'Szervezet',
      'System FQDN' => '',
      'SystemID' => 'Rendszer azonosító',
      'Ticket Hook' => 'Jegy pöcök',
      'Ticket Number Generator' => 'Jegy sorszám generátor',
      'Use utf-8 it your database supports it!' => 'Használd utf-8-at az adatbázis támogatásoknál!',
      'Webfrontend' => 'Web-munkafelület',

    # Template: LostPassword

    # Template: NoPermission
      'No Permission' => 'Nincs jogosultság',

    # Template: Notify

    # Template: PrintFooter
      'URL' => 'URL',

    # Template: QueueView
      'All tickets' => 'Minden jegy',
      'Page' => 'Oldal',
      'Queues' => 'Ügyek',
      'Tickets available' => 'Elérhetõ jegyek',
      'Tickets shown' => 'Mutatott jegyek',

    # Template: SystemStats

    # Template: Test
      'OTRS Test Page' => 'OTRS tesztoldal',

    # Template: TicketEscalation
      'Ticket escalation!' => 'Jegy eszkaláció!',

    # Template: TicketView

    # Template: TicketViewLite

    # Template: Warning

    # Template: css
      'Home' => 'Otthon',

    # Template: customer-css
      'Contact' => 'Kapcsolat',
      'Online-Support' => 'Online-támogatás',
      'Products' => 'Termékek',
      'Support' => 'Támogatás',

    # Misc
      '"}","15' => '"}","15',
      '"}","30' => '"}","30',
      'Add auto response' => 'Automatikus válasz hozzáadása',
      'Addressbook' => 'Címjegyzék',
      'AgentFrontend' => 'Ügynök-Munkafelület',
      'Article free text' => 'Cikk szabadszöveg',
      'BackendMessage' => 'Háttérüzenet',
      'Bottom of Page' => 'Lap alja',
      'Change Response <-> Attachment settings' => 'Reakció <-> Csatolás beállítások módosítása',
      'Change answer <-> queue settings' => 'Válasz <-> Ügyek beállítások módosítása',
      'Change auto response settings' => 'Automatikus válasz beállítások módosítása',
      'Charset' => 'Karakterkészlet',
      'Charsets' => 'Karakterkészletek',
      'Closed' => 'Lezárva',
      'Create' => 'Létrehoz',
      'Customer called' => 'Ügyfél felhívva',
      'Customer user will be needed to to login via customer panels.' => 'Az ügyfél panel használatához ügyfél felhasználóra lesz szükség.',
      'FAQ State' => 'GYIK állapot',
      'Graphs' => 'Grafikonok',
      'If your account is trusted, the x-otrs header (for priority, ...) will be used!' => 'Ha a te azonosítód megbízható, az x-otrs fejlécet (prioritáshoz,...) használjuk!',
      'Lock Ticket' => 'Jegy lezárása',
      'Max Rows' => 'Max. oszlopok',
      'My Tickets' => 'Az én jegyeim',
      'New ticket via call.' => 'Új jegy híváson keresztül.',
      'New user' => 'Új felhasználó',
      'POP3 Account' => 'POP3 azonosító',
      'Pending!' => 'Várakozás!',
      'Phone call at %s' => 'Telefonhívás ekkor: %s',
      'Please go away!' => 'Kérjük menjen innen!',
      'PostMasterFilter Management' => 'PostaMesterSzûrõ kezelése',
      'Search in' => 'Keresés itt',
      'Select source:' => 'Forrás kiválasztása:',
      'Select your custom queues' => 'Válassza ki az egyedi ügyeit',
      'Send me a notification if a ticket is moved into a custom queue.' => 'Küldjön értesítést ha a jegyet áthelyezik egyedi ügyhöz.',
      'Send me a notification if there is a new ticket in my custom queues.' => 'Küldjön értesítést ha új jegy van az én egyedi ügyeim között.',
      'SessionID' => 'Folyamatazonosító',
      'SessionID invalid! Need user data!' => 'Hibás SessionID! Felhasználói adat szükséges!',
      'Short Description' => 'Rövid leírás',
      'Show all' => 'Mindent mutat',
      'Shown Tickets' => 'Jegyek megmutatása',
      'System Charset Management' => 'Rendszer karakterkészlet kezelése',
      'Ticket-Overview' => 'Jegy-áttekintés',
      'Time till escalation' => 'Idõ az eszkalációig',
      'Utilities' => 'Keresés',
      'With Priority' => 'Sürgõsséggel',
      'With State' => 'Álapottal',
      'by' => 'általa:',
      'invalid-temporarily' => 'ideiglenesen-érvénytelen',
      'search' => 'keres',
      'settings' => 'beállítások',
      'store' => 'tárol',
      'tickets' => 'jegyek',
      'valid' => 'érvényes',
    );

    # $$STOP$$
    $Self->{Translation} = \%Hash;
}
# --
1;
