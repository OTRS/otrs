# --
# Kernel/Language/hu.pm - provides de language translation
# Copyright (C) 2004 RLAN Internet <MAGIC at rlan.hu>
# --
# $Id: hu.pm,v 1.2 2004-06-11 06:41:16 martin Exp $
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
$VERSION = '$Revision: 1.2 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub Data {
    my $Self = shift;
    my %Param = @_;
    my %Hash = ();

    # $$START$$
    # Last translation Tue Feb 10 01:02:02 2004 by 

    # possible charsets
    $Self->{Charset} = ['iso-8859-1', 'iso-8859-15', ];
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
      '10 minutes' => '10 Perc',
      '15 minutes' => '15 Perc',
      'AddLink' => 'Link hozzáadása',
      'Admin-Area' => 'Admin terület',
      'agent' => 'Ügynök',
      'Agent-Area' => 'Felhasználói-terület',
      'all' => 'összes',
      'All' => 'Összes',
      'Attention' => 'Figyelem',
      'before' => 'elõzõ',
      'Bug Report' => 'Hibalista',
      'Cancel' => 'Mégsem',
      'change' => 'váltás',
      'Change' => 'Váltás',
      'change!' => 'Váltás!',
      'click here' => 'kattints ide',
      'Comment' => 'Megjegyzés',
      'Customer' => 'Ügyfél',
      'customer' => 'ügyfél',
      'Customer Info' => 'Ügyfél Info',
      'day' => 'nap',
      'day(s)' => 'nap(ok)',
      'days' => 'napok',
      'description' => 'leírás',
      'Description' => 'Leírás',
      'Dispatching by email To: field.' => 'Felosztás email szerint: mezõ.',
      'Dispatching by selected Queue.' => 'Felosztás a kiválasztott ügyek szerint.',
      'Don\'t show closed Tickets' => 'Ne jelenítse meg a lezárt jegyeket.',
      'Don\'t work with UserID 1 (System account)! Create new users!' => 'Nem dolgozhat a UserID 1-el (Rendszer jogosultság)! Hozzál létre új felhasználót!',
      'Done' => 'Kész',
      'end' => 'vége',
      'Error' => 'Hiba',
      'Example' => 'Példa',
      'Examples' => 'Példák',
      'Facility' => 'Képesség',
      'FAQ-Area' => 'GYIK terület',
      'Feature not active!' => 'Funkció nem aktív!',
      'go' => 'Start',
      'go!' => 'Start!',
      'Group' => 'Csoport',
      'Hit' => 'Találat',
      'Hits' => 'Találat',
      'hour' => 'Óra',
      'hours' => 'Órák',
      'Ignore' => 'Visszavon',
      'invalid' => 'hibás',
      'Invalid SessionID!' => 'Hibás SessionID!',
      'Language' => 'Nyelv',
      'Languages' => 'Nyelvek',
      'last' => 'utolsó',
      'Line' => 'Vonal',
      'Lite' => 'Egyszerû',
      'SessionID invalid! Need user data!' => 'Hibás azonosító! Hiányzó felhasználói adatok! Lépjen be újra a rendszerbe!',
      'Login failed! Your username or password was entered incorrectly.' => 'Belépési hiba! A felhasználói név vagy jelszó hibás.',
      'Logout successful. Thank you for using OTRS!' => 'Kilépés rendben! Gyere máskor is!',
      'Message' => 'Üzenet',
      'minute' => 'Perc',
      'minutes' => 'Perc',
      'Module' => 'Modul',
      'Modulefile' => 'Modulfile',
      'month(s)' => 'Hónap(ok)',
      'Name' => 'Név',
      'New Article' => 'Új tétel',
      'New message' => 'Új üzenet',
      'New message!' => 'Új üzenet!',
      'No' => 'Nem',
      'no' => 'nem',
      'No entry found!' => 'Nem talált tétel!',
      'No suggestions' => 'Nincsenek javaslatok',
      'none' => 'nincs',
      'none - answered' => 'nincs - válasz',
      'none!' => 'nincs!',
      'Normal' => 'Normál',
      'Off' => 'Ki',
      'off' => 'ki',
      'On' => 'Be',
      'on' => 'be',
      'Password' => 'Jelszó',
      'Pending till' => 'Várjon rá',
      'Please answer this ticket(s) to get back to the normal queue view!' => 'Kérjük válaszolj erre a jegyre hogy visszatérj az ügyek nézethez!',
      'Please contact your admin' => 'Vegye fel a kapcsolatot a rendszeradminisztrátorral',
      'please do not edit!' => 'Kérem ezt ne szerkessze át!',
      'Please go away!' => 'Kérjük ezt hagyja így!',
      'possible' => 'lehetséges',
      'Preview' => 'Megtekintés',
      'QueueView' => 'Ügyek-Nézet',
      'reject' => 'elutasítás',
      'replace with' => 'felülírás ezzel',
      'Reset' => 'Törlés',
      'Salutation' => 'Megszólítás',
      'Session has timed out. Please log in again.' => 'A program nem válaszol. Lépjen be újra.',
      'Show closed Tickets' => 'Lezárt jegyek megmutatása',
      'Signature' => 'Aláírás',
      'Sorry' => 'Sajnálom',
      'Stats' => 'Statisztika',
      'Subfunction' => 'Belsõ fukció',
      'submit' => 'elküldés',
      'submit!' => 'Elküldés!',
      'system' => 'Rendszer',
      'Take this User' => 'Foglalt ennek a felhasználónak',
      'Text' => 'Szöveg',
      'The recommended charset for your language is %s!' => 'Az ajánlott karakterkészlet a választott nyelvnél %s!',
      'Theme' => 'Téma',
      'There is no account with that login name.' => 'Ehhez a névhez nem tartozik jogosultság.',
      'Timeover' => 'Idõtúllépes',
      'To: (%s) replaced with database email!'  => 'Cél: (%s) felülírva adatbázis eMail-al',
      'top' => 'Elsõ',
      'update' => 'aktualizálás',
      'Update' => 'Aktualizálás',
      'update!' => 'Aktualizálás!',
      'User' => 'Felhasználó',
      'Username' => 'Felhasználó neve',
      'Valid' => 'Érvényes',
      'Warning' => 'Figyelem',
      'week(s)' => 'Hét(ek)',
      'Welcome to OTRS' => 'Üdvözöl az Ügykezelõ Rendszer',
      'Word' => 'Szó',
      'wrote' => 'Írás',
      'year(s)' => 'Év(ek)',
      'yes' => 'igen',
      'Yes' => 'Igen',
      'You got new message!' => 'Te egy új üzenetet kaptál!',
      'You have %s new message(s)!' => 'Neked %s új üzeneted érkezett!',
      'You have %s reminder ticket(s)!' => 'Neked %s emlékeztetõ jegye(i)d vannak!',

    # Template: AAAMonth
      'Apr' => '',
      'Aug' => '',
      'Dec' => '',
      'Feb' => '',
      'Jan' => '',
      'Jul' => '',
      'Jun' => '',
      'Mar' => '',
      'May' => 'Maj',
      'Nov' => '',
      'Oct' => 'Okt',
      'Sep' => '',

    # Template: AAAPreferences
      'Closed Tickets' => 'Lezárt Hibajegyek',
      'Custom Queue' => 'Szokásos ügyek',
      'Follow up notification' => 'Értesítés nyomonkövetése',
      'Frontend' => 'Munkafelület',
      'Mail Management' => 'Email kezelés',
      'Max. shown Tickets a page in Overview.' => 'Maximum megjeleníthetõ jegyek száma az áttekintésnél.',
      'Max. shown Tickets a page in QueueView.' => 'Maximum megjeleníthetõ jegyek száma az Ügyek nézetnél.',
      'Move notification' => 'Értesítés áthelyezése',
      'New ticket notification' => 'Új jegy értesítése',
      'Other Options' => 'További beállítások',
      'PhoneView' => 'Telefonhívás alapján-Új jegy',
      'Preferences updated successfully!' => 'Változtatások elmentése rendben!',
      'QueueView refresh time' => 'Ügyek nézet - frissítési idõ',
      'Screen after new ticket' => 'Képernyõ után új jegy',
      'Select your default spelling dictionary.' => 'Válaszd ki az alapértelmezett helyesírásellenõrzõ szótárat.',
      'Select your frontend Charset.' => 'Válaszd ki a munkaterület karakterkészletét.',
      'Select your frontend language.' => 'Válaszd ki a munkaterület nyelvét.',
      'Select your frontend QueueView.' => 'Válaszd ki a munkaterület Ügyek-nézetét.',
      'Select your frontend Theme.' => 'Válaszd ki a munkaterület stílusát.',
      'Select your QueueView refresh time.' => 'Válaszd ki az ügyek nézet frissítési idejét.',
      'Select your screen after creating a new ticket.' => 'Válaszd ki a képernyõt az új jegy létrehozása után.',
      'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.' => 'Küldjön értesítést ha a partner használja és Én vagyok a felügyelõje a jegynek.',
      'Send me a notification if a ticket is moved into a custom queue.' => 'Küldjön értesítést ha a jegyet áthelyezik egy másik Ügyhöz.',
      'Send me a notification if a ticket is unlocked by the system.' => 'Küldjön értesítést ha a jegyet zárolás alól felszabadításra kerül.',
      'Send me a notification if there is a new ticket in my custom queues.' => 'Küldjön értesítést ha ott az új jegy az Én szokásos Ügyeimben.',
      'Show closed tickets.' => 'Lezárt jegyek megjelenítése.',
      'Spelling Dictionary' => 'Helyesírás ellenõrzõ szótár',
      'Ticket lock timeout notification' => 'Jegyzárolás idõtúllépésének értesítése',
      'TicketZoom' => 'Jegy nagyítás',

    # Template: AAATicket
      '1 very low' => '1 nagyon kicsi',
      '2 low' => '2 kicsi',
      '3 normal' => '3 normál',
      '4 high' => '4 magas',
      '5 very high' => '5 nagyon magas',
      'Action' => 'Akció',
      'Age' => 'Kor',
      'Article' => 'Tétel',
      'Attachment' => 'Csatolás',
      'Attachments' => 'Csatolások',
      'Bcc' => '',
      'Bounce' => 'Visszapattanás',
      'Cc' => '',
      'Close' => 'Lezárás',
      'closed successful' => 'bezárás rendben',
      'closed unsuccessful' => 'bezárás sikertelen',
      'Compose' => 'Szerkesztés',
      'Created' => 'Elkészítve',
      'Createtime' => 'Elkészült ',
      'email' => 'E-Mail',
      'eMail' => 'E-Mail',
      'email-external' => 'E-Mail külsõ',
      'email-internal' => 'E-Mail belsõ',
      'Forward' => 'Továbbítás',
      'From' => 'Kitõl',
      'high' => 'magas',
      'History' => 'Történet',
      'If it is not displayed correctly,' => 'Ha ez nem a megfelelõ javítás,',
      'lock' => 'zárolt',
      'Lock' => 'Zárolt',
      'low' => 'alacsony',
      'Move' => 'Áthelyezés',
      'new' => 'Új',
      'normal' => 'normál',
      'note-external' => 'külsõ megjegyzés',
      'note-internal' => 'belsõ megjegyzés',
      'note-report' => 'Megjegyzések lekérése',
      'open' => 'nyitás',
      'Owner' => 'Felügyelõ',
      'Pending' => 'Várakozás',
      'pending auto close+' => 'automatikus zárásra várakozás+',
      'pending auto close-' => 'automatikus zárásra várakozás-',
      'pending reminder' => 'figyelmeztetésre várakozás',
      'phone' => 'Telefon',
      'plain' => 'érthetõ',
      'Priority' => 'Prioritás',
      'Queue' => 'Ügyek',
      'removed' => 'törölve',
      'Sender' => 'Küldõ',
      'sms' => '',
      'State' => 'Státusz',
      'Subject' => 'Tárgy',
      'This is a' => 'Ez egy',
      'This is a HTML email. Click here to show it.' => 'Ez egy html email. Kattints ide a megjelenítéshez.',
      'This message was written in a character set other than your own.' => 'Ezt az üzenetet más karakterkészlettel írták mint amit Te használsz.',
      'Ticket' => 'Jegy',
      'Ticket "%s" created!' => '"%s" jegy létrehozva!',
      'To' => 'Címzett',
      'to open it in a new window.' => 'megnyitása egy új ablakban',
      'unlock' => 'kinyitás',
      'Unlock' => 'Kinyitva',
      'very high' => 'nagyon magas',
      'very low' => 'nagyon alacsony',
      'View' => 'Nézet',
      'webrequest' => 'Webkérdés',
      'Zoom' => 'Nagyítás',

    # Template: AAAWeekDay
      'Fri' => 'Pen',
      'Mon' => 'Het',
      'Sat' => 'Szo',
      'Sun' => 'Vas',
      'Thu' => 'Csu',
      'Tue' => 'Ked',
      'Wed' => 'Sze',

    # Template: AdminAttachmentForm
      'Add' => 'Hozzáadás',
      'Attachment Management' => 'Csatolások kezelése',

    # Template: AdminAutoResponseForm
      'Add auto response' => 'Automatikus válasz hozzáadása',
      'Auto Response From' => 'Automatikus válasz',
      'Auto Response Management' => 'Automatikus válaszok kezelése',
      'Change auto response settings' => 'Automatikus válasz beállítások módosítása',
      'Note' => 'Jegyzet',
      'Response' => 'Válasz',
      'to get the first 20 character of the subject' => 'kapja meg az elsõ 20 karaktert a tárgyból',
      'to get the first 5 lines of the email' => 'kapja meg az elsõ 5 sort az email-ból',
      'to get the from line of the email' => 'kapja meg a feladó sort az email-ból',
      'to get the realname of the sender (if given)' => 'kapja meg a feladó valódi nevét (ha lehetséges)',
      'to get the ticket id of the ticket' => 'kapja meg a jegy azonosítóját a jegybõl',
      'to get the ticket number of the ticket' => 'kapja meg a jegy sorszámát a jegybõl',
      'Type' => 'Beírás',
      'Useable options' => 'Használható opciók',

    # Template: AdminCustomerUserForm
      'Customer User Management' => 'Partner felhasználók kezelése',
      'Customer user will be needed to to login via customer panels.' => 'A felhasználói panel használatához a partner felhasználóra lesz szükség.',
      'Select source:' => 'Forrás kiválasztása:',
      'Source' => 'Forrás',

    # Template: AdminCustomerUserGeneric

    # Template: AdminCustomerUserGroupChangeForm
      'Change %s settings' => 'Változtatva %s beállítás',
      'Customer User <-> Group Management' => 'Partner felhasználó <-> Csoportok kezelése',
      'Full read and write access to the tickets in this group/queue.' => 'Teljes írás és olvasási jog ehhez a csoport/ügyeknek a jegyeknél.',
      'If nothing is selected, then there are no permissions in this group (tickets will not be available for the user).' => 'Ha nincs kiválasztva, akkor nincs jogosultságod ehhez a csoporthoz. (a jegyet nem tudja használni a felhasználó).',
      'Permission' => 'Jogosultság',
      'Read only access to the ticket in this group/queue.' => 'Csak olvasási jogosultság a csoport/ügyeknek a jegyeknél.',
      'ro' => 'Csak olvasás',
      'rw' => 'Írás/Olvasás',
      'Select the user:group permissions.' => 'Felhasználó kiválasztása:Csoport jogosultság.',

    # Template: AdminCustomerUserGroupForm
      'Change user <-> group settings' => 'Felhasználó váltása <-> Csoportbeállítások',

    # Template: AdminCustomerUserPreferencesGeneric

    # Template: AdminEmail
      'Admin-Email' => '',
      'Body' => 'Tartalom',
      'OTRS-Admin Info!' => '',
      'Recipents' => 'Címzettek',
      'send' => 'Küldés',

    # Template: AdminEmailSent
      'Message sent to' => 'Üzenet elküldve',

    # Template: AdminGroupForm
      'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).' => 'Létrehoz egy új csoport, kapcsolódva más csoportok jogosultságához az adott ügynöknél.',
      'Group Management' => 'Csoportok kezelése',
      'It\'s useful for ASP solutions.' => 'Ez egy lehetséges ASP megoldás.',
      'The admin group is to get in the admin area and the stats group to get stats area.' => 'Az admin csoport megkapja az admin területet és a státusz csoport megkapja a státusz területet.',

    # Template: AdminLog
      'System Log' => 'Rendszertörténet',

    # Template: AdminNavigationBar
      'AdminEmail' => '',
      'Attachment <-> Response' => 'Csatolás <-> Válasz',
      'Auto Response <-> Queue' => 'Automatikus válasz <-> Ügyek',
      'Auto Responses' => 'Automatikus válaszok',
      'Customer User' => 'Partner Felhasználó',
      'Customer User <-> Groups' => 'Partner <-> Csoport',
      'Email Addresses' => 'E-Mail cím',
      'Groups' => 'Csoportok',
      'Logout' => 'Kilépés',
      'Misc' => 'Egyéb',
      'Notifications' => 'Hírek',
      'PostMaster Filter' => 'Postamester szûrõ',
      'PostMaster POP3 Account' => 'Postamester Email jogosultság',
      'Responses' => 'Válaszok',
      'Responses <-> Queue' => 'Válaszok <-> Ügyek',
      'Select Box' => 'SQL Parancsok',
      'Session Management' => 'Eljárások kezelése',
      'Status' => 'Állapot',
      'System' => 'Rendszer',
      'User <-> Groups' => 'Felhasználó <-> Csoport',

    # Template: AdminNotificationForm
      'Config options (e. g. &lt;OTRS_CONFIG_HttpType&gt;)' => 'Configuráiós beállítások (pl. &lt;OTRS_CONFIG_HttpType&gt;)',
      'Notification Management' => 'Értesítések kezelése',
      'Notifications are sent to an agent or a customer.' => 'Értesítés van küldve az ügynöknek vagy a partnernek.',
      'Options of the current customer user data (e. g. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)' => 'Opciók az aktuális partner felhasználói adatokhoz(pl. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)',
      'Options of the current user who requested this action (e. g. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)' => 'Opciók a aktuális felhasználónál ha kéri ezt az eljárát. (pl. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)',
      'Ticket owner options (e. g. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)' => 'Jegy felügyelõ opciók (pl. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)',

    # Template: AdminPOP3Form
      'All incoming emails with one account will be dispatched in the selected queue!' => 'Az összes bejövõ Email egy hozzáféréshez kerül kiosztásra a kiválasztott ügynél!',
      'Dispatching' => 'Felosztás',
      'Host' => '',
      'If your account is trusted, the x-otrs header (for priority, ...) will be used!' => 'Ha a te jogosultságod bizalmas, az OTRS fejlében nem lesz nyitva!',
      'Login' => '',
      'POP3 Account Management' => 'Email jogosultságok kezelése',
      'Trusted' => 'Bizalmas',
      'POP3 Account' => 'Email fiókok',
      
    # Template: AdminPostMasterFilterForm
      'Match' => 'Találat',
      'PostMasterFilter Management' => 'Postásszûrõk kezelése',
      'Set' => 'Beállítás',

    # Template: AdminQueueAutoResponseForm
      'Queue <-> Auto Response Management' => 'Ügyek <-> Automatikus válaszok kezelése',
      'settings' => 'beállításoknál',

    # Template: AdminQueueAutoResponseTable

    # Template: AdminQueueForm
      '0 = no escalation' => '0 = nem kiterjeszthetõ',
      '0 = no unlock' => '0 = nem nyitható',
      'Customer Move Notify' => 'Partner értesítés mozgatása',
      'Customer Owner Notify' => 'Partner értesítés felügyelõ',
      'Customer State Notify' => 'Partner értesítés állapota',
      'Escalation time' => 'Kiterjesztési idõ',
      'Follow up Option' => 'Ellenõrzési opciók',
      'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.' => 'Ha a jegy le van zárva és a partner felhasználó üzen a jegynek, akkor az zárolásra kerül a régi felügyelõnek.',
      'If a ticket will not be answered in thos time, just only this ticket will be shown.' => 'Ha a jegy nem tud válaszolni a megadott idõben, csak ez a jegy lesz megjelenítve.',
      'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.' => 'Ha az ügynök zárolja a jegyet, és Õ/Te nem küldesz választ a megadott idõpontig, a jegy zárolása megszûnik és látható lesz minden ügynöknek.',
      'Key' => 'Kulcs',
      'OTRS sends an notification email to the customer if the ticket is moved.' => 'OTRS értesítõ leveleket küld a partnereknek ha a jegyet áthelyezed.',
      'OTRS sends an notification email to the customer if the ticket owner has changed.' => 'OTRS értesítõ leveleket küld a partnereknek ha a jegy felügyelõje megváltozik.',
      'OTRS sends an notification email to the customer if the ticket state has changed.' => 'OTRS értesítõ leveleket küld a partnereknek ha a jegy státusza változik.',
      'Queue Management' => 'Ügyek kezelése',
      'Sub-Queue of' => 'Belsõ Ügytõl',
      'Systemaddress' => 'Rendszercím',
      'The salutation for email answers.' => 'A megszólítása az email válaszoknak.',
      'The signature for email answers.' => 'Aláírás a válasz emailoknak.',
      'Ticket lock after a follow up' => 'Jegy zárolása a nyomonkövetés után.',
      'Unlock timeout' => 'Kinyitás idõtúllépés',
      'Will be the sender address of this queue for email answers.' => 'A küldõ címe lesz ehhez az ügyhöz a email válaszok címe.',

    # Template: AdminQueueResponsesChangeForm
      'Std. Responses <-> Queue Management' => 'Alapválaszok <-> Ügyek kezelése',

    # Template: AdminQueueResponsesForm
      'Answer' => 'Válasz',
      'Change answer <-> queue settings' => 'Válasz módosítás <-> Ügyek beállítások',

    # Template: AdminResponseAttachmentChangeForm
      'Std. Responses <-> Std. Attachment Management' => 'Alapválaszok <-> Alapcsatolások kezelése',

    # Template: AdminResponseAttachmentForm
      'Change Response <-> Attachment settings' => 'Válaszok módosítása <-> Csatolás beállítások',

    # Template: AdminResponseForm
      'A response is default text to write faster answer (with default text) to customers.' => 'A válasz az alapértelmezett szöveg a gyors válaszokhoz a partnereknek.',
      'Don\'t forget to add a new response a queue!' => 'Nem lehet hozzáadni új választ az ügyhöz!',
      'Next state' => 'Következõ állapot',
      'Response Management' => 'Válaszok kezelése',
      'The current ticket state is' => 'Az aktuális jegy állapota',

    # Template: AdminSalutationForm
      'customer realname' => 'Partner teljesnév',
      'for agent firstname' => 'kezelõnek családi neve',
      'for agent lastname' => 'kezelõnek utóneve',
      'for agent login' => 'belépési név a kezelõnek',
      'for agent user id' => 'felhasználói azonosító a kezelõnek',
      'Salutation Management' => 'Megszólítások kezelése',

    # Template: AdminSelectBoxForm
      'Max Rows' => 'Max. oszlopok',

    # Template: AdminSelectBoxResult
      'Limit' => 'Korlát',
      'Select Box Result' => 'SQL Parancs kiválasztás',
      'SQL' => '',
      'Select Box' => 'SQL Parancsok',

    # Template: AdminSession
      'Agent' => 'Ügynök',
      'kill all sessions' => 'Minden eljárás kilövése',
      'Overview' => 'Áttekintõ',
      'Sessions' => 'Eljárások',
      'Uniq' => 'Egyedi',

    # Template: AdminSessionTable
      'kill session' => 'ügy kilövése',
      'SessionID' => 'Eljárás azonosító',

    # Template: AdminSignatureForm
      'Signature Management' => 'Aláírások kezelése',

    # Template: AdminStateForm
      'See also' => 'Lásd még',
      'State Type' => 'Állapot típus',
      'System State Management' => 'Rendszerállapotok kezelése',
      'Take care that you also updated the default states in you Kernel/Config.pm!' => 'Ellenõrzid le, hogy frissítve van az alapértelmezett státusz a Kernel/Config.pm file-ban!',

    # Template: AdminSystemAddressForm
      'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!' => 'Minden bejövõ emailhoz az email-t (To:) akarod felosztani a kiválasztott ügyben.',
      'Email' => 'E-Mail',
      'Realname' => 'Valódi név',
      'System Email Addresses Management' => 'Rendszer email cím kezelése',

    # Template: AdminUserForm
      'Don\'t forget to add a new user to groups!' => 'Ne felejtsd el hozzáadni a felhasználót a csoporthoz!',
      'Firstname' => 'Keresztnév',
      'Lastname' => 'Családi név',
      'User Management' => 'Felhasználók kezelése',
      'User will be needed to handle tickets.' => 'a felhasználónak szükséges a jegyek kezeléséhez.',

    # Template: AdminUserGroupChangeForm
      'create' => 'készítés',
      'move_into' => 'mozgatás át',
      'owner' => 'felügyelõ',
      'Permissions to change the ticket owner in this group/queue.' => 'Jogosultság a jegy felügyelõnél megváltoztatásához ebben a csoportban/ügyben.',
      'Permissions to change the ticket priority in this group/queue.' => 'Jogosultág a jegy prioritásnak megváltoztatásához ebben a csoportban/ügyben.',
      'Permissions to create tickets in this group/queue.' => 'Jogosultság, hogy új jegyeket készítsen ebben a csoportban/ügyben.',
      'Permissions to move tickets into this group/queue.' => 'Jogosultság változtatáshoz a jegyek áthelyezéséhez ebben a csoportba/ügybe.',
      'priority' => 'Prioritás',
      'User <-> Group Management' => 'Felhasználó <-> Csoportok kezelése',

    # Template: AdminUserGroupForm

    # Template: AdminUserPreferencesGeneric

    # Template: AgentBook
      'Address Book' => 'Címjegyzék',
      'Discard all changes and return to the compose screen' => 'Elvet minden változtatást és visszatér az szerkesztõképernyõre',
      'Return to the compose screen' => 'Visszatérés a szerkesztõképernyõre',
      'Search' => 'Keresés',
      'The message being composed has been closed.  Exiting.' => 'Létezõ lejárt üzenet szerkesztésnek lezárás.',
      'This window must be called from compose window' => 'Ez az ablak meghívja a szerkesztõ ablakot',

    # Template: AgentBounce
      'A message should have a To: recipient!' => 'Az üzenethez kell címzett!',
      'Bounce ticket' => 'Visszapattanó jegy',
      'Bounce to' => 'Visszapattantás ide',
      'Inform sender' => 'Információ a küldõrõl',
      'Next ticket state' => 'Következõ jegy állapota',
      'Send mail!' => 'Email küldése!',
      'You need a email address (e. g. customer@example.com) in To:!' => 'Kell egy email cím (pl. kunde@beispiel.de!',
      'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further informations.' => 'A Te email-od jegy száma "<OTRS_TICKET>" visszapattant "<OTRS_BOUNCE_TO>". Vedd fel a kapcsolatot a rendszergazdával.',

    # Template: AgentClose
      ' (work units)' => ' (munkaterületek)',
      'A message should have a body!' => 'Az üzenethez szöveg is kell!',
      'A message should have a subject!' => 'Az üzenethez tárgy is kell!',
      'Close ticket' => 'Jegy lezárása',
      'Close type' => 'Típus lezárása',
      'Close!' => 'Lezárás!',
      'Note Text' => 'Jegyzet szöveg',
      'Note type' => 'Jegyzet típus',
      'Options' => 'Beállítások',
      'Spell Check' => 'Helyesírásellenõrzés',
      'Time units' => 'Idõ egységek',
      'You need to account time!' => 'Neked kell jogosultsági idõ!',

    # Template: AgentCompose
      'A message must be spell checked!' => 'Az üzenetnek helyesírásellenõrzésen kell átmennie!',
      'Attach' => 'Csatolás',
      'Compose answer for ticket' => 'Válasz szerkesztése', 
      'for pending* states' => 'várakozó* státusz',
      'Is the ticket answered' => 'Ez egy megválaszolt jegy',
      'Pending Date' => 'Várakozás dátuma',

    # Template: AgentCustomer
      'Back' => 'Vissza',
      'Change customer of ticket' => 'Partner változtatása a jegynél',
      'CustomerID' => 'Ügyfélszám#',
      'Search Customer' => 'Partner keresése',
      'Set customer user and customer id of a ticket' => 'Partner felhasználó és partner azonosító beállítása a jegyben',

    # Template: AgentCustomerHistory
      'All customer tickets.' => 'Összes partner jegy.',
      'Customer history' => 'Partner történet',

    # Template: AgentCustomerMessage
      'Follow up' => 'Nyomonkövetés',

    # Template: AgentCustomerView
      'Customer Data' => 'Partner adatok',

    # Template: AgentEmailNew
      'All Agents' => 'Minden ügynök',
      'Clear From' => 'Innen: törlés',
      'Compose Email' => 'Email alapján-Új jegy',
      'Lock Ticket' => 'Jegy lezárása',
      'new ticket' => 'Új jegy',

    # Template: AgentForward
      'Article type' => 'Tétel típusa',
      'Date' => 'Dátum',
      'End forwarded message' => 'Vége a továbbított üzenetnek',
      'Forward article of ticket' => 'Továbbított tétel a jegyben',
      'Forwarded message from' => 'Továbbított üzenet innen',
      'Reply-To' => 'Kapja még',

    # Template: AgentFreeText
      'Change free text of ticket' => 'Szabad szöveg változtatása a jegyben',
      'Value' => 'Érték',

    # Template: AgentHistoryForm
      'History of' => 'Története a',

    # Template: AgentMailboxNavBar
      'All messages' => 'Minden üzenet',
      'down' => 'le',
      'Mailbox' => 'Postafiók',
      'New' => 'Új',
      'New messages' => 'Új üzenetek',
      'Open' => 'Nyitás',
      'Open messages' => 'Üzenetek nyitása',
      'Order' => 'Rendezés',
      'Pending messages' => 'Várakozó üzenetek',
      'Reminder' => 'Figyelmeztetés',
      'Reminder messages' => 'Figyelmeztetõ üzenet',
      'Sort by' => 'Rendezés így',
      'Tickets' => 'Jegyek',
      'up' => 'fel',

    # Template: AgentMailboxTicket
      '"}' => '',
      '"}","14' => '',

    # Template: AgentMove
      'Move Ticket' => 'Jegy áthelyezése',
      'New Owner' => 'Új felügyelõ',
      'New Queue' => 'Új ügy',
      'Previous Owner' => 'Korábbi felügyelõ',
      'Queue ID' => 'Ügy azonosító',

    # Template: AgentNavigationBar
      'Locked tickets' => 'Zárolt hibajegyek',
      'new message' => 'Új üzenet',
      'Preferences' => 'Beállítások',
      'Utilities' => 'Keresés',

    # Template: AgentNote
      'Add note to ticket' => 'Jegyzet hozzáadása a jegyhez',
      'Note!' => 'Jegyzet!',

    # Template: AgentOwner
      'Change owner of ticket' => 'Jegy felügyelõjének módosítása',
      'Message for new Owner' => 'Üzenet az új felügyelõnek',

    # Template: AgentPending
      'Pending date' => 'Várakozási dátum',
      'Pending type' => 'Várakozás típusa',
      'Pending!' => 'Várakozás!',
      'Set Pending' => 'Várakozás beállítás',

    # Template: AgentPhone
      'Customer called' => 'Partner hívás',
      'Phone call' => 'Telefonhívás',
      'Phone call at %s' => 'Telefonhívás innen %s',

    # Template: AgentPhoneNew

    # Template: AgentPlain
      'ArticleID' => 'Tétel azonosító',
      'Plain' => 'Egyszerû',
      'TicketID' => 'Jegy azonosító',

    # Template: AgentPreferencesCustomQueue
      'Select your custom queues' => 'Válaszd ki a szokásos ügyeidet',

    # Template: AgentPreferencesForm

    # Template: AgentPreferencesGeneric

    # Template: AgentPreferencesPassword
      'Change Password' => 'Jelszó módosítása',
      'New password' => 'Új jelszó',
      'New password again' => 'Új jelszó újra',

    # Template: AgentPriority
      'Change priority of ticket' => 'Jegy prioritásának módosítása',

    # Template: AgentSpelling
      'Apply these changes' => 'Módosítások érvényesítése',
      'Spell Checker' => 'Helyesírásellenõrzés',
      'spelling error(s)' => 'helyesírási hiba(k)',

    # Template: AgentStatusView
      'D' => 'Z',
      'of' => 'kitõl',
      'Site' => 'Oldal',
      'sort downward' => 'Rendezés lefelé',
      'sort upward' => 'Rendezés felfelé',
      'Ticket Status' => 'Jegy állapota',
      'U' => 'A',

    # Template: AgentStatusViewTable

    # Template: AgentStatusViewTableNotAnswerd

    # Template: AgentTicketLink
      'Link' => '',
      'Link to' => 'Link ide',

    # Template: AgentTicketLocked
      'Ticket locked!' => 'A jegy lezárva!',
      'Ticket unlock!' => 'A jegy kinyitva!',

    # Template: AgentTicketPrint
      'by' => 'kitõl',

    # Template: AgentTicketPrintHeader
      'Accounted time' => 'Jogosultsági idõ',
      'Escalation in' => 'Kiterjesztés ebben',

    # Template: AgentUtilSearch
      '(e. g. 10*5155 or 105658*)' => 'pl. 10*5144 vagy 105658*',
      '(e. g. 234321)' => 'pl. 234321',
      '(e. g. U5150)' => 'pl. U5150',
      'and' => 'és',
      'Customer User Login' => 'Partner felhasználó belépés',
      'Delete' => 'Törlés',
      'Fulltext-Search in Article (e. g. "Mar*in" or "Baue*")' => 'Teljesszöveg keresés a tételben (pl. "Mar*in" oder "Baue*")',
      'No time settings.' => 'Nincs idõ beállítás.',
      'Profile' => 'Profil',
      'Result Form' => 'Eredmény ürlap',
      'Save Search-Profile as Template?' => 'Elmented a keresõ profilt sablonba?',
      'Search-Template' => 'Keresõ sablon',
      'Select' => 'Választás',
      'Ticket created' => 'Jegy létrehozva',
      'Ticket created between' => 'Létrehozva a jegyek között',
      'Ticket Search' => 'Jegy keresése',
      'TicketFreeText' => 'Jegy szabadszöveg',
      'Times' => 'Idõk',
      'Yes, save it with name' => 'Igen, elmentve ezen a néven',

    # Template: AgentUtilSearchByCustomerID
      'Customer history search' => 'Partner történetben keresés',
      'Customer history search (e. g. "ID342425").' => 'Partner történetben keresés (pl. "ID342425").',
      'No * possible!' => 'Nem "*" lehetséges!',

    # Template: AgentUtilSearchNavBar
      'Change search options' => 'Keresési beállítások módosítása',
      'Results' => 'Eredmények',
      'Search Result' => 'Keresési eredmények',
      'Total hits' => 'Összes találat',

    # Template: AgentUtilSearchResult
      '"}","15' => '',

    # Template: AgentUtilSearchResultPrint

    # Template: AgentUtilSearchResultPrintTable
      '"}","30' => '',

    # Template: AgentUtilSearchResultShort

    # Template: AgentUtilSearchResultShortTable

    # Template: AgentUtilSearchResultShortTableNotAnswered

    # Template: AgentUtilTicketStatus
      'All closed tickets' => 'Minden lezárt jegyet',
      'All open tickets' => 'Minden nyitott jegyet',
      'closed tickets' => 'lezárt jegyek',
      'open tickets' => 'nyitott jegyek',
      'or' => 'vagy',
      'Provides an overview of all' => 'Áttekintést ad az összesrõl',
      'So you see what is going on in your system.' => 'Így nézd, mi folyik a rendszerben.',

    # Template: AgentZoomAgentIsCustomer
      'Compose Follow up' => 'Nyomonkövetés készítése',
      'Your own Ticket' => 'Általad felügyelt jegyek',

    # Template: AgentZoomAnswer
      'Compose Answer' => 'Válasz írása',
      'Contact customer' => 'Partner kapcsolat',
      'phone call' => 'Telefonhívás',

    # Template: AgentZoomArticle
      'Split' => 'Megosztás',

    # Template: AgentZoomBody
      'Change queue' => 'Ügy változtatás',

    # Template: AgentZoomHead
      'Free Fields' => 'Szabad mezõk',
      'Print' => 'Nyomtatás',

    # Template: AgentZoomStatus
      '"}","18' => '',

    # Template: CustomerCreateAccount
      'Create Account' => 'Jogosultság létrehozása',

    # Template: CustomerError
      'Traceback' => 'Visszakövetés',

    # Template: CustomerFAQArticleHistory
      'Edit' => 'Szerkesztés',
      'FAQ History' => 'FAQ történet',

    # Template: CustomerFAQArticlePrint
      'Category' => 'Kategória',
      'Keywords' => 'Kulcsszó',
      'Last update' => 'Utolsó frissítés',
      'Problem' => 'Probléma',
      'Solution' => 'Megoldás',
      'Symptom' => 'Jelenség',

    # Template: CustomerFAQArticleSystemHistory
      'FAQ System History' => 'FAQ rendszer történet',

    # Template: CustomerFAQArticleView
      'FAQ Article' => 'FAQ Tétel',
      'Modified' => 'Módosítva',

    # Template: CustomerFAQOverview
      'FAQ Overview' => 'FAQ Áttekintõ',

    # Template: CustomerFAQSearch
      'FAQ Search' => 'FAQ keresés',
      'Fulltext' => 'Teljesszöveg',
      'Keyword' => 'Kulcsszó',

    # Template: CustomerFAQSearchResult
      'FAQ Search Result' => 'FAQ keresés-eredmények',

    # Template: CustomerFooter
      'Powered by' => 'Készítette',

    # Template: CustomerHeader
      'Contact' => 'Kapcsolat',
      'Home' => '',
      'Online-Support' => '',
      'Products' => 'Termék',
      'Support' => 'Támogatás',

    # Template: CustomerLogin

    # Template: CustomerLostPassword
      'Lost your password?' => 'Elfelejtetted a jelszavadat?',
      'Request new password' => 'Új jelszó kérése',

    # Template: CustomerMessage

    # Template: CustomerMessageNew

    # Template: CustomerNavigationBar
      'Create new Ticket' => 'Új jegy létrehozása',
      'FAQ' => '',
      'New Ticket' => 'Új jegyek',
      'Ticket-Overview' => 'Jegyek-áttekintõ',
      'Welcome %s' => 'Üdvözöllek %s',

    # Template: CustomerPreferencesForm

    # Template: CustomerPreferencesGeneric

    # Template: CustomerPreferencesPassword

    # Template: CustomerStatusView
      'My Tickets' => 'Az Én jegyeim',

    # Template: CustomerStatusViewTable

    # Template: CustomerTicketZoom

    # Template: CustomerWarning

    # Template: Error
      'Click here to report a bug!' => 'Kattinst ide a hibalista megtekintéséhez!',

    # Template: FAQArticleDelete
      'FAQ Delete' => 'FAQ törlése',
      'You really want to delete this article?' => 'Biztos, hogy törölni akarod ezt a tételt?',

    # Template: FAQArticleForm
      'Comment (internal)' => 'Megjegyzés (belsõ)',
      'Filename' => 'File neve',
      'Short Description' => 'Rövid leírás',

    # Template: FAQArticleHistory

    # Template: FAQArticlePrint

    # Template: FAQArticleSystemHistory

    # Template: FAQArticleView

    # Template: FAQCategoryForm
      'FAQ Category' => 'FAQ Kategória',

    # Template: FAQLanguageForm
      'FAQ Language' => 'FAQ nyelv',

    # Template: FAQNavigationBar

    # Template: FAQOverview

    # Template: FAQSearch

    # Template: FAQSearchResult

    # Template: FAQStateForm
      'FAQ State' => 'FAQ állapot',

    # Template: Footer
      'Top of Page' => 'Lap tetejére',

    # Template: Header

    # Template: InstallerBody
      'Create Database' => 'Adatbázis létrehozása',
      'Drop Database' => 'Adatbázis törlése',
      'Finished' => 'Befejezve',
      'System Settings' => 'Rendszerbeállítások',
      'Web-Installer' => '',

    # Template: InstallerFinish
      'Admin-User' => 'Admin-felhasználó',
      'After doing so your OTRS is up and running.' => 'Ha kész az OTRS indul és fut.',
      'Have a lot of fun!' => 'Köszönöm a látogatást!',
      'Restart your webserver' => 'Webserver újraindítás',
      'Start page' => 'Start-lap',
      'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' => 'Az OTRS használatához be kell lépned a következõ parancssor értelmezõbe (Terminál/Shell) root-ként.',
      'Your OTRS Team' => 'OTRS Adminisztrátor',

    # Template: InstallerLicense
      'accept license' => 'Licenc elfogadása',
      'don\'t accept license' => 'Licenc elutasítása',
      'License' => 'Licenc',

    # Template: InstallerStart
      'Create new database' => 'Új adatbázis létrehozása',
      'DB Admin Password' => 'DB Admin jelszó',
      'DB Admin User' => 'DB Admin felhasználó',
      'DB Host' => 'DB Host',
      'DB Type' => 'DB típusa',
      'default \'hot\'' => 'alapértelmezett',
      'Delete old database' => 'Régi adatbázis törlése',
      'next step' => 'következõ lépés',
      'OTRS DB connect host' => 'OTRS DB kapcsolódik a host-hoz',
      'OTRS DB Name' => 'OTRS DB név',
      'OTRS DB Password' => 'OTRS DB jelszó',
      'OTRS DB User' => 'OTRS DB felhasználó',
      'your MySQL DB should have a root password! Default is empty!' => 'Te MySQL DB elérésedhez jelszó kell. Az alapértelmezett üres!',

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

    # Template: Login

    # Template: LostPassword

    # Template: NoPermission
      'No Permission' => 'Nem jogosult',

    # Template: Notify
      'Info' => '',

    # Template: PrintFooter
      'URL' => '',

    # Template: PrintHeader
      'printed by' => 'Nyomtatta',

    # Template: QueueView
      'All tickets' => 'Minden jegy',
      'Page' => 'Oldal',
      'Queues' => 'Ügyek',
      'Tickets available' => 'Elérhetõ jegyek',
      'Tickets shown' => 'Jegyek mutatása',

    # Template: SystemStats
      'Graphs' => 'Grafikon',

    # Template: Test
      'OTRS Test Page' => 'OTRS tesztoldal',

    # Template: TicketEscalation
      'Ticket escalation!' => 'Jegy kiterjesztés!',

    # Template: TicketView

    # Template: TicketViewLite
      'Add Note' => 'Jegyzet hozzáadása',

    # Template: Warning

    # Misc
      'Addressbook' => 'Címjegyzék',
      'AgentFrontend' => 'Ügynök-Munkafelület',
      'Article free text' => 'Tétel-Szabadszöveg',
      'BackendMessage' => 'Háttérüzenet',
      'Bottom of Page' => 'Lap alja',
      'Charset' => 'Karakterkészlet',
      'Charsets' => 'Karakterkészletek',
      'Closed' => 'Lezárva',
      'Create' => 'Létrehozás',
      'CustomerUser' => 'Partner',
      'New ticket via call.' => 'Új jegy a híváson keresztül.',
      'New user' => 'Új felhasználó',
      'Search in' => 'Keresés itt',
      'Show all' => 'Mindent mutat',
      'Shown Tickets' => 'Jegyek megmutatása',
      'System Charset Management' => 'Rendszer karakterkészlet kezelése',
      'Time till escalation' => 'Idõ (határidõ)',
      'With Priority' => 'Jogosultsággal',
      'With State' => 'Álapottal',
      'invalid-temporarily' => 'hibás-ideiglenesen',
      'search' => 'Keresés',
      'store' => 'készlet',
      'tickets' => 'Jegyek',
      'valid' => 'érvényes',
      'CreateTicket' => 'Jegylétrehozás',
    );

    # $$STOP$$
    $Self->{Translation} = \%Hash;
}
# --
1;
