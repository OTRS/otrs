# --
# Kernel/Language/de.pm - provides de language translation
# Copyright (C) 2001-2006 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: sl.pm,v 1.1.2.1 2006-03-15 17:20:43 cs Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
package Kernel::Language::sl;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.1.2.1 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub Data {
    my $Self = shift;
    my %Param = @_;

    # $$START$$
    # Last translation file sync: Thu Jul 28 22:12:45 2005

    # possible charsets
    $Self->{Charset} = ['iso-8859-1', 'iso-8859-15', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Jear;)
    $Self->{DateFormat} = '%D.%M.%Y %T';
    $Self->{DateFormatLong} = '%A %D %B %T %Y';
    $Self->{DateInputFormat} = '%D.%M.%Y';
    $Self->{DateInputFormatLong} = '%D.%M.%Y - %T';

    $Self->{Translation} = {
      # Template: AAABase
      'Yes' => 'áno',
      'No' => 'Nie',
      'yes' => 'áno',
      'no' => 'žiadny',
      'Off' => 'vypnúť',
      'off' => 'vypnúť',
      'On' => 'zapnúť',
      'on' => 'zapnúť',
      'top' => 'hore',
      'end' => 'koniec',
      'Done' => 'hotovo',
      'Cancel' => 'zrušiť',
      'Reset' => 'Reset',
      'last' => 'posledný',
      'before' => 'pred',
      'day' => 'deň',
      'days' => 'dni',
      'day(s)' => 'deň/dni',
      'hour' => 'hodina',
      'hours' => 'hodiny',
      'hour(s)' => 'hodina/hodiny',
      'minute' => 'minuta',
      'minutes' => 'minuty',
      'minute(s)' => 'minuta/minuty',
      'month' => 'mesiac',
      'months' => 'mesiace',
      'month(s)' => 'mesiac/mesiace',
      'week' => 'týždeň',
      'week(s)' => 'týždne',
      'year' => 'rok',
      'years' => 'roky',
      'year(s)' => 'rok/roky',
      'wrote' => 'písať',
      'Message' => 'správa',
      'Error' => 'Chyba',
      'Bug Report' => 'chybové hlásenie',
      'Attention' => 'Pozor',
      'Warning' => 'Varovanie',
      'Module' => 'Modul',
      'Modulefile' => 'modulový priečinok',
      'Subfunction' => 'Podfunkcia',
      'Line' => 'riadok',
      'Example' => 'Príklad',
      'Examples' => 'Príklady',
      'valid' => 'platný',
      'invalid' => 'neplatný',
      'invalid-temporarily' => 'dočasne neplatný',
      ' 2 minutes' => ' 2 minuty',
      ' 5 minutes' => ' 5 minút',
      ' 7 minutes' => ' 7 minút',
      '10 minutes' => ' 10 minút',
      '15 minutes' => ' 15 minút',
      'Mr.' => 'Pán',
      'Mrs.' => 'Pani',
      'Next' => 'ďalej',
      'Back' => 'späť',
      'Next...' => 'ďalej...',
      '...Back' => '...späť',
      '-none-' => '-žiadny-',
      'none' => 'žiadny',
      'none!' => 'žiaden',
      'none - answered' => 'žiadna odpoveď',
      'please do not edit!' => 'Prosím neupravovať!',
      'AddLink' => 'Pridať odkaz.',
      'Link' => 'Prepojenie',
      'Linked' => 'spojený',
      'Link (Normal)' => 'Prepojenie (obyčajné)',
      'Link (Parent)' => 'Prepojenie (zdroj)',
      'Link (Child)' => 'Prepojenie (následník)',
      'Normal' => 'obyčajný',
      'Parent' => 'zdroj',
      'Child' => 'dieťa',
      'Hit' => 'úder',
      'Hits' => 'údery',
      'Text' => 'Text',
      'Lite' => 'Odľahčený',
      'User' => 'Užívateľ',
      'Username' => 'Užívateľské meno',
      'Language' => 'Jazyk',
      'Languages' => 'Jazyky',
      'Password' => 'Heslo',
      'Salutation' => 'Oslovenie',
      'Signature' => 'Podpis',
      'Customer' => 'Zákazník',
      'CustomerID' => 'Zákaznícke č',
      'CustomerIDs' => 'Zákaznícke čísla',
      'customer' => 'Zákazník',
      'agent' => 'Agent',
      'system' => 'Systém',
      'Customer Info' => 'Zákazníke info',
      'go!' => 'štart!',
      'go' => 'štart',
      'All' => 'Všetko',
      'all' => 'všetko',
      'Sorry' => 'Pardon',
      'update!' => 'Aktualizuj!',
      'update' => 'Aktualizovať',
      'Update' => 'Aktualizácia',
      'submit!' => 'predlož!',
      'submit' => 'predložiť',
      'Submit' => 'Predloženie',
      'change!' => 'Zmeň!',
      'Change' => 'Zmena',
      'change' => 'Zmeniť',
      'click here' => 'klikni tu',
      'Comment' => 'poznámka',
      'Valid' => 'Platný',
      'Invalid Option!' => 'Neplatná možnosť!',
      'Invalid time!' => 'Neplatný čas!',
      'Invalid date!' => 'Neplatný dátum!',
      'Name' => 'Meno',
      'Group' => 'Skupina',
      'Description' => 'Popis ',
      'description' => 'Popis ',
      'Theme' => 'Schema',
      'Created' => 'Vytvorený',
      'Created by' => 'Vytvorený (kým)',
      'Changed' => 'Zmenený',
      'Changed by' => 'Zmenený (kým)',
      'Search' => 'Hľadať',
      'and' => 'a',
      'between' => 'medzi',
      'Fulltext Search' => 'Fulltextové vyhľadávanie ',
      'Data' => 'údaje',
      'Options' => 'Možnosti',
      'Title' => 'Názov',
      'Item' => 'Položka',
      'Delete' => 'Zmazať',
      'Edit' => 'Upraviť',
      'View' => 'Zobraziť',
      'Number' => 'číslo',
      'System' => 'Systém',
      'Contact' => 'Kontakt',
      'Contacts' => 'Kontakty',
      'Export' => 'Export',
      'Up' => 'Hore',
      'Down' => 'Dolu',
      'Add' => 'Pridať ',
      'Category' => 'Kategória',
      'Viewer' => 'Zobraz',
      'New message' => 'Nová správa',
      'New message!' => 'Nová správa!',
      'Please answer this ticket(s) to get back to the normal queue view!' => 'Prosim odpovedajte na tento tiket',
      'You got new message!' => 'Máte novú správu!',
      'You have %s new message(s)!' => 'Máte % nových správ!',
      'You have %s reminder ticket(s)!' => 'Máte % pripomienok!',
      'The recommended charset for your language is %s!' => 'Odporúčaná znaková sada pre váš jazyk je %',
      'Passwords doesn\'t match! Please try it again!' => 'Heslá sa nezhoduju! Prosím skúste znova!',
      'Password is already in use! Please use an other password!' => 'Heslo je už používané. Prosím použite iné heslo!',
      'Password is already used! Please use an other password!' => 'Heslo je už používané. Prosím použite iné heslo!',
      'You need to activate %s first to use it!' => 'Na používanie musíte najprv aktivovať %',
      'No suggestions' => 'Žiadne návrhy.',
      'Word' => 'Slovo',
      'Ignore' => 'Ignorovať',
      'replace with' => 'nahradiť s',
      'Welcome to %s' => 'Vitajte v %',
      'There is no account with that login name.' => 'Neexistuje žiadny účet s týmto úžívateľským menom',
      'Login failed! Your username or password was entered incorrectly.' => 'Prihlásenie zlyhalo! Vaše používateľské meno alebo heslo bolo vložené nesprávne.',
      'Please contact your admin' => 'Prosím kontaktujte vášho administrátora.',
      'Logout successful. Thank you for using OTRS!' => 'Odhlásenie úspešné. Ďakujeme za používanie ORTS!',
      'Invalid SessionID!' => 'Neplatný SessionID',
      'Feature not active!' => 'Funkcia neaktívna!',
      'Take this Customer' => 'Použi tohto klienta.',
      'Take this User' => 'Puži tohto užívateľa.',
      'possible' => 'možný',
      'reject' => 'odmietnuť',
      'Facility' => 'Príslušenstvo',
      'Timeover' => 'Timeover',
      'Pending till' => 'Odložené do.',
      'Don\'t work with UserID 1 (System account)! Create new users!' => 'Nepracujte s používateľským číslom 1 (systémový účet)! Vytvorte nového používateľa.',
      'Dispatching by email To: field.' => 'Posielam emailom =>  prijemca: pole',
      'Dispatching by selected Queue.' => 'Posielam vybraným radom.',
      'No entry found!' => 'Nenájdený žiaden vstup.',
      'Session has timed out. Please log in again.' => 'Relácia timeout. Prosím =>  prihláste sa znova.',
      'No Permission!' => 'Nepovolené!',
      'To: (%s) replaced with database email!' => 'Príjemca: % je nahradený databázovým emailom!',
      'Cc: (%s) added database email!' => 'Kópia: % pridaný databázový email.',
      '(Click here to add)' => '(Ak chcete pridať položku =>  kliknete sem.)',
      'Preview' => 'Náhľad',
      'Added User %s""' => 'Pridaný používateľ %',
      'Contract' => 'Zmluva',
      'Online Customer: %s' => 'Online užívateľ: %',
      'Online Agent: %s' => 'Online Agent %',
      'Calendar' => 'Kalendár',
      'File' => 'File',
      'Filename' => 'Filename',
      'Type' => 'Typ',
      'Size' => 'Veľkosť',
      'Upload' => 'Upload',
      'Directory' => 'Directory',
      'Signed' => 'Podpísaný',
      'Sign' => 'Podpísať',
      'Crypted' => 'Zašifrovaný',
      'Crypt' => 'šifrovať',

      # Template: AAAMonth
	'Jan' => 'jan',
	'Feb' => 'feb',
	'Mar' => 'mar',
	'Apr' => 'apríl',
	'May' => 'máj',
	'Jun' => 'jún',
	'Jul' => 'júl',
	'Aug' => 'aug',
	'Sep' => 'sept',
	'Oct' => 'okt',
	'Nov' => 'nov',
	'Dec' => 'dec',

      # Template: AAANavBar
      'Admin-Area' => 'Admin-oblasť',
      'Agent-Area' => 'Agent-Area',
      'Ticket-Area' => 'Ticket-Area',
      'Logout' => 'Odhlásenie ',
      'Agent Preferences' => 'Nastavenia úžívateľa',
      'Preferences' => 'Nastavenia',
      'Agent Mailbox' => 'Agent Mailbox',
      'Stats' => 'štatistika',
      'Stats-Area' => 'štatistická oblasť',
      'FAQ-Area' => 'FAQ oblasť',
      'FAQ' => 'FAQ',
      'FAQ-Search' => 'FAQ-hladanie',
      'FAQ-Article' => 'FAQ-článok',
      'New Article' => 'Nový článok',
      'FAQ-State' => 'FAQ-stav',
      'Admin' => 'Admin',
      'A web calendar' => 'webový kalendár',
      'WebMail' => 'WebMail',
      'A web mail client' => 'Web mail client',
      'FileManager' => 'Správca súborov',
      'A web file manager' => 'Správca weborých súborov',
      'Artefact' => 'Artefakt',
      'Incident' => 'Udalosť',
      'Advisory' => 'Advisory',
      'WebWatcher' => 'WebWatcher',
      'Customer Users' => 'Klientskí užívatelia.',
      'Customer Users <-> Groups' => 'Klientskí užívatelia <-> skupiny ',
      'Users <-> Groups' => 'Užívatelia <-> Skupiny',
      'Roles' => 'Funkcie',
      'Roles <-> Users' => 'Funkcie <-> Užívatelia',
      'Roles <-> Groups' => 'Funkcie <-> Skupiny',
      'Salutations' => 'Oslovenia',
      'Signatures' => 'Podpisy',
      'Email Addresses' => 'Emailové adresy',
      'Notifications' => 'Oznamovanie',
      'Category Tree' => 'Strom kategórií',
      'Admin Notification' => 'Administrátorské oznamovanie',

      # Template: AAAPreferences
      'Preferences updated successfully!' => 'Predvoľby úspešne aktualizované!',
      'Mail Management' => 'Správa pošty.',
      'Frontend' => 'Frontend',
      'Other Options' => 'Ostatné Možnosti',
      'Change Password' => 'Zmena hesla',
      'New password' => 'Nové heslo',
      'New password again' => 'Znova nové heslo',
      'Select your QueueView refresh time.' => 'Vyberte si refresh time fronty',
      'Select your frontend language.' => 'Vyberte si jazyk.',
      'Select your frontend Charset.' => 'Vyberte si znakovú sadu.',
      'Select your frontend Theme.' => 'Vyberte si vzhľad.',
      'Select your frontend QueueView.' => 'Vyberte si QueueView',
      'Spelling Dictionary' => 'Slovník pravopisu.',
      'Select your default spelling dictionary.' => 'Vyberte si slovník na kontrolu pravopisu.',
      'Max. shown Tickets a page in Overview.' => 'Maximálny počet požiadaviek zobrazovaných v prehľade.',
      'Can\'t update password =>  passwords doesn\'t match! Please try it again!' => 'Nemožno aktualizovať heslo =>  heslá nezhodujú.',
      'Can\'t update password =>  invalid characters!' => 'Nemožno aktualizovať heslo =>  neplatné znaky.',
      'Can\'t update password =>  need min. 8 characters!' => 'Nemožno aktualizovať heslo =>  potrebujete minimálne 8 písmen.',
      'Can\'t update password =>  need 2 lower and 2 upper characters!' => 'Nemožno aktualizovať heslo =>  potrebujete 2 malé a 2 veľké písmená',
      'Can\'t update password =>  need min. 1 digit!' => 'Nemožno aktualizovať heslo =>  potrebujete minimálne 1 číslicu.',
      'Can\'t update password =>  need min. 2 characters!' => 'Nemožno aktualizovať heslo =>  potrebujete minimálne 2 písmená!',
      'Password is needed!' => 'Je potrebné heslo.',

      # Template: AAATicket
      'Lock' => 'Zamknúť',
      'Unlock' => 'Odomknúť',
      'History' => 'História',
      'Zoom' => 'Zväčšiť',
      'Age' => 'Vek',
      'Bounce' => 'Skočiť na',
      'Forward' => 'Nasledujúci',
      'From' => 'Od ',
      'To' => 'Príjemca',
      'Cc' => 'Cc',
      'Bcc' => 'Bcc',
      'Subject' => 'Predmet',
      'Move' => 'Presunúť',
      'Queue' => 'Fronta',
      'Priority' => 'Priorita',
      'State' => 'Stav',
      'Compose' => 'Vytvoriť',
      'Pending' => 'čakanie',
      'Owner' => 'Vlastník',
      'Owner Update' => 'aktualizácia vlastníka',
      'Sender' => 'Odosielateľ',
      'Article' => 'článok',
      'Ticket' => 'Požiadavka',
      'Createtime' => 'Doba spracovania',
      'plain' => 'jednoduchý',
      'Email' => 'e-mail',
      'email' => 'e-mail',
      'Close' => 'Zatvorit',
      'Action' => 'Akcia',
      'Attachment' => 'Príloha',
      'Attachments' => 'Prílohy',
      'This message was written in a character set other than your own.' => 'Táto správa bola napísaná v inej znakovej sade =>  ako je vaša.',
      'If it is not displayed correctly => ' => 'Ak nie je zobrazená správne =>  ',
      'This is a' => 'To je',
      'to open it in a new window.' => 'Otvoriť v novom okne',
      'This is a HTML email. Click here to show it.' => 'Toto je HMTL  e-mail. Na otvorenie =>  kliknite tu',
      'Free Fields' => 'Voľné polia',
      'Merge' => 'Zlúčiť',
      'closed successful' => 'zatvorené úspešne',
      'closed unsuccessful' => 'zatvorené neúspešne',
      'new' => 'nový',
      'open' => 'otvoriť',
      'closed' => 'zatvorený',
      'removed' => 'odstránený',
      'pending reminder' => 'nevybavená pripomienka',
      'pending auto close+' => 'počas automatického zatvárania +',
      'pending auto close-' => 'počas automatického zatvárania -',
      'email-external' => 'externý e-mail',
      'email-internal' => 'interný e-mail',
      'note-external' => 'externá poznámka',
      'note-internal' => 'interná poznámka',
      'note-report' => 'hlásnie poznámky',
      'phone' => 'telefón',
      'sms' => 'sms',
      'webrequest' => 'webová požiadavka',
      'lock' => 'zamknúť',
      'unlock' => 'odomknúť',
      'very low' => 'veľmi nízka',
      'low' => 'nízka',
      'normal' => 'normálna',
      'high' => 'vysoká',
      'very high' => 'veľmi vysoká',
      '1 very low' => '1 veľmi nízka',
      '2 low' => '2 nízka',
      '3 normal' => '3 normálna',
      '4 high' => '4 vysoká',
      '5 very high' => '5 veľmi vysoká',
      'Ticket %s" created!"' => 'požiadavka % vytvorená',
      'Ticket Number' => 'číslo požiadavky',
      'Ticket Object' => 'predmet požiadavky',
      'No such Ticket Number %s"! Can\'t link it!"' => 'Žiadna požiadavka číslo %. ',
      'Don\'t show closed Tickets' => 'Nezobrazuj uzavreté požiadavky.',
      'Show closed Tickets' => 'Zobraz uzavreté požiadavky.',
      'Email-Ticket' => 'e-mailová požiadavka',
      'Create new Email Ticket' => 'Vytvor novú e-mailovú požiadavku',
      'Phone-Ticket' => 'Telefonická požiadavka',
      'Create new Phone Ticket' => 'Vytvor novú telefonickú požiadavku',
      'Search Tickets' => 'Hľadaj požiadavky',
      'Edit Customer Users' => 'Uprav zákazníckeho užívateľa.',
      'Bulk-Action' => 'Hromadná akcia',
      'Bulk Actions on Tickets' => 'hromadné akcie na požiadavkách.',
      'Send Email and create a new Ticket' => 'Pošli e-mail a vytvor novú požiadavku',
      'Overview of all open Tickets' => 'Prehľad všetkých otvorených požiadaviek.',
      'Locked Tickets' => 'Lockované požiadavky',
      'Lock it to work on it!' => 'Kvôli práci na nich =>  lock.',
      'Unlock to give it back to the queue!' => 'Unlock a daj späť do radu.',
      'Shows the ticket history!' => 'Zobraz históriu požiadaviek.',
      'Print this ticket!' => 'Vytlač túto požiadavku.',
      'Change the ticket priority!' => 'Zmeň prioritu požiadavky.',
      'Change the ticket free fields!' => 'Zmeň voľné polia požiadavky.',
      'Link this ticket to an other objects!' => 'Prepoj požiadavku s inými objektami!',
      'Change the ticket owner!' => 'Zmeň majiteľa požiadavky.',
      'Change the ticket customer!' => 'Zmeň klienta požiadavky.',
      'Add a note to this ticket!' => 'Pridaj poznámku k tejto požiadavke.',
      'Merge this ticket!' => 'Pripoj túto požiadavku.',
      'Set this ticket to pending!' => 'Nastav požiadavku na vyriešenie.',
      'Close this ticket!' => 'Zatvor túto požiadavku.',
      'Look into a ticket!' => 'Vyhľadaj požiadavku.',
      'Delete this ticket!' => 'Vymaž túto požiadavku.',
      'Mark as Spam!' => 'Označ ako Spam!',
      'My Queues' => 'Moje rady.',
      'Shown Tickets' => 'Zobraz požiadavky.',
      'New ticket notification' => 'Hlásenie novej požiadavky.',
      'Send me a notification if there is a new ticket in My Queues"."' => 'Pošli mi notifikáciu =>  ak je nová požiadavka v MyQueue ?',
      'Follow up notification' => 'Nasleduj hlásenie.',
      'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.' => 'Pošli mi oznámenie =>  ak klient pošle overenie a ja som vlastník tejto požiadavky.',
      'Ticket lock timeout notification' => 'Požiadavka blokuje časový limit oznámenia.',
      'Send me a notification if a ticket is unlocked by the system.' => 'Pošli mi oznámenie =>  ak je požiadavka odblokovaná systémom.',
      'Move notification' => 'Premiestni hlásenie',
      'Send me a notification if a ticket is moved into one of My Queues"."' => 'Pošli mi oznámenie =>  ak je požiadavka premiestnená do jedného z mojich radov.',
      'Your queue selection of your favorite queues. You also get notified about this queues via email if enabled.' => 'Váš výber z obľúbených radov. Tiež môžete byť oboznámený s požiadavkou cez e-mail =>  ak je to možné.',
      'Custom Queue' => 'Klientské rady.',
      'QueueView refresh time' => '?',
      'Screen after new ticket' => 'Okno po novej požiadavke.',
      'Select your screen after creating a new ticket.' => 'Vyberte si okno zobrazujúce sa po vytvorení novej požiadavky.',
      'Closed Tickets' => 'Zatvorené požiadavky.',
      'Show closed tickets.' => 'Ukáž zatvorené požiadavky.',
      'Max. shown Tickets a page in QueueView.' => 'Maximálny počet požiadaviek zobrazovaných v prehľade.',
      'Responses' => 'Odpovede',
      'Responses <-> Queue' => 'Odpovede <-> rad',
      'Auto Responses' => 'Automatické odpovede',
      'Auto Responses <-> Queue' => 'Automatické odpovede <-> rad',
      'Attachments <-> Responses' => 'Prílohy <-> Odpovede',
      'History::Move' => 'História: pohyb',
      'History::NewTicket' => 'História: Nová pripomienka',
      'History::FollowUp' => 'História: sleduj',
      'History::SendAutoReject' => 'História: pošli automatickú odpoveď',
      'History::SendAutoReply' => 'História: pošli automatické zamietnutie',
      'History::SendAutoFollowUp' => 'História: SendAutoFollowUp',
      'History::Forward' => 'História: Forward',
      'History::Bounce' => 'História: ',
      'History::SendAnswer' => 'História:: Pošli odpoveď',
      'History::SendAgentNotification' => 'História:: pošli notifikáciu zástupcovi',
      'History::SendCustomerNotification' => 'História:: Pošli zákaznícku notifikáciu',
      'History::EmailAgent' => 'História: email zástupcu',
      'History::EmailCustomer' => 'História: Email klienta',
      'History::PhoneCallAgent' => 'História: Hovor agenta',
      'History::PhoneCallCustomer' => 'História: Hovor klienta',
      'History::AddNote' => 'História: Pridaj poznámku',
      'History::Lock' => 'História: zamkni',
      'History::Unlock' => 'História: odomkni',
      'History::TimeAccounting' => 'História: časový účet',
      'History::Remove' => 'História: odstránené',
      'History::CustomerUpdate' => 'História: klientská aktualizácia',
      'History::PriorityUpdate' => 'História: aktualizácia priorít',
      'History::OwnerUpdate' => 'História: aktualizácia majiteľa',
      'History::LoopProtection' => 'História: LoopProtection',
      'History::Misc' => 'História: ',
      'History::SetPendingTime' => 'História: Nastav čas riešenia',
      'History::StateUpdate' => 'História: Aktualizácia stavu',
      'History::TicketFreeTextUpdate' => 'História: ',
      'History::WebRequestCustomer' => 'História: ',
      'History::TicketLinkAdd' => 'História: ',
      'History::TicketLinkDelete' => 'História: ',
      'Workflow Groups' => '?',

      # Template: AAAWeekDay
      'Sun' => 'Ned',
      'Mon' => 'Pon',
      'Tue' => 'Ut',
      'Wed' => 'Str',
      'Thu' => 'Stv',
      'Fri' => 'Pia',
      'Sat' => 'Sob',

      # Template: AdminAttachmentForm
      'Attachment Management' => 'riadenie príloh',

      # Template: AdminAutoResponseForm
      'Auto Response Management' => 'riadenie automatických odpovedí',
      'Response' => 'Odpoveď',
      'Auto Response From' => 'Automatická odpoveď od',
      'Note' => 'Poznámka',
      'Useable options' => 'použiteľná možnosť',
      'to get the first 20 character of the subject' => 'zobraziť prvých 20 vlastností subjektu',
      'to get the first 5 lines of the email' => 'zobraziť prvých 5 riadkov emailu',
      'to get the from line of the email' => 'zobraziť ',
      'to get the realname of the sender (if given)' => 'zobraziť skutočné meno odosielateľa (ak je dané)',
      'Options of the ticket data (e. g. &lt;OTRS_TICKET_Number&gt; =>  &lt;OTRS_TICKET_ID&gt; =>  &lt;OTRS_TICKET_Queue&gt; =>  &lt;OTRS_TICKET_State&gt;)' => 'Možnosti údajov požiadavky (napr. &lt;OTRS_TICKET_Number&gt; =>  &lt;OTRS_TICKET_ID&gt; =>  &lt;OTRS_TICKET_Queue&gt; =>  &lt;OTRS_TICKET_State&gt;)',

      # Template: AdminCustomerUserForm
      'The message being composed has been closed.  Exiting.' => 'Vytvorená správa bola zatvorená. ',
      'This window must be called from compose window' => 'Toto okno musí byť vyvolané z okna na vytváranie.',
      'Customer User Management' => 'Riadenie klientských užívateľov.',
      'Search for' => 'Hľadať',
      'Result' => 'výsledok',
      'Select Source (for add)' => 'vyber zdroj (pre pridanie)',
      'Source' => 'zdroj',
      'This values are read only.' => 'Táto hodnota je iba na čítanie',
      'This values are required.' => 'Táto hodnota je požadovaná.',
      'Customer user will be needed to have a customer history and to login via customer panel.' => 'Customer user will be needed to have a customer history and to login via customer panel.',

      # Template: AdminCustomerUserGroupChangeForm
      'Customer Users <-> Groups Management' => 'Klientský užívatelia <-> Skupiny riadenia',
      'Change %s settings' => 'Zmeniť % nastavenia',
      'Select the user:group permissions.' => 'Vyber používateľa: skupina povolená',
      'If nothing is selected =>  then there are no permissions in this group (tickets will not be available for the user).' => 'Ak nie je nič vybrané =>  nie je dovolené pracovať v tejto skupine (požiadavky nie sú dostupné pre užívateľa)',
      'Permission' => 'Povolenie',
      'ro' => 'ro',
      'Read only access to the ticket in this group/queue.' => 'Čítaj iba prístup k požiadavkám v tejto skupine/rade.',
      'rw' => 'rw',
      'Full read and write access to the tickets in this group/queue.' => ,

      # Template: AdminCustomerUserGroupForm

      # Template: AdminEmail
      'Message sent to' => 'Správa poslaná',
      'Recipents' => 'Adresáti',
      'Body' => 'Telo správy',
      'send' => 'Poslať',

      # Template: AdminGenericAgent
      'GenericAgent' => 'generovaný zástupca',
      'Job-List' => 'zoznam úloh',
      'Last run' => 'posledné spustenie',
      'Run Now!' => 'Spusti!',
      'x' => 'x',
      'Save Job as?' => 'Uložiť prácu ako?',
      'Is Job Valid?' => 'Je práca platná?',
      'Is Job Valid' => 'Je práca platná',
      'Schedule' => 'Rozvrh',
      'Fulltext-Search in Article (e. g. Mar*in" or "Baue*")"' => 'Fulltextové vyhľadávanie v článku (napr. Mar*in" alebo "Baue*")"',
      '(e. g. 10*5155 or 105658*)' => '(napr. 10*5155 alebo 105658*)',
      '(e. g. 234321)' => '(napr. 234321)',
      'Customer User Login' => 'login klientského užívateľa',
      '(e. g. U5150)' => '(napr. U5150)',
      'Agent' => 'Zástupca',
      'TicketFreeText' => 'Text bez požiadavky',
      'Ticket Lock' => ,
      'Times' => 'čas',
      'No time settings.' => 'žiadne časové nastavenia',
      'Ticket created' => 'Pripomienka vytvorená',
      'Ticket created between' => 'Pripomienka vytvorená medzi',
      'New Priority' => 'Nová priorita',
      'New Queue' => 'Nový rad',
      'New State' => 'Nový stav',
      'New Agent' => 'Nový zástupca',
      'New Owner' => 'Nový ',
      'New Customer' => 'Nový zákazník',
      'New Ticket Lock' => ,
      'CustomerUser' => 'klientský užívateľ',
      'Add Note' => 'priadať poznámku',
      'CMD' => 'CMD',
      'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' => 'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.',
      'Delete tickets' => 'Zmazané požiadavky',
      'Warning! This tickets will be removed from the database! This tickets are lost!' => 'Pozor! Táto požiadavka bude vymazaná z databázy. Tieto požiadavky sú stratené!',
      'Modules' => 'Moduly',
      'Param 1' => 'parameter 1',
      'Param 2' => 'parameter 2',
      'Param 3' => 'parameter 3',
      'Param 4' => 'parameter 4',
      'Param 5' => 'parameter 5',
      'Param 6' => 'parameter 6',
      'Save' => 'Uložiť',

      # Template: AdminGroupForm
      'Group Management' => 'Správa skupín',
      'The admin group is to get in the admin area and the stats group to get stats area.' => 'The admin group is to get in the admin area and the stats group to get stats area.',
      'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department =>  support department =>  sales department =>  ...).' => 'vytvorit nove skupiny pre osetrenie pristupovych prav roznych skupin agentov (napr. Oddelenie nákupu =>  oddelenie predaja => ..)',
      'It\'s useful for ASP solutions.' => 'It\'s useful for ASP solutions.',

      # Template: AdminLog
      'System Log' => 'systémový záznam',
      'Time' => 'čas',

      # Template: AdminNavigationBar
      'Users' => 'Užívatelia',
      'Groups' => 'Skupiny',
      'Misc' => 'Ine',

      # Template: AdminNotificationForm
      'Notification Management' => 'Správa hlásení',
      'Notification' => 'Hlásenie',
      'Notifications are sent to an agent or a customer.' => 'Hlásenia sú poslané zástupcovi alebo zákazníkovi.',
      'Config options (e. g. &lt;OTRS_CONFIG_HttpType&gt;)' => 'možnosti konfigurácie (napr. &lt;OTRS_CONFIG_HttpType&gt;)',
      'Ticket owner options (e. g. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)' => 'Možnosti majiteľa požiadavky (napr. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)',
      'Options of the current user who requested this action (e. g. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)' => 'Možnosti aktuálneho používateľa =>  ktorý požaduje tieto akcie (napr. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)',
      'Options of the current customer user data (e. g. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)' => 'Možnosti údajov aktuálnohe klientského užívateľa (napr. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)',

      # Template: AdminPackageManager
      'Package Manager' => 'riadenie balíka',
      'Uninstall' => 'odinštalovať',
      'Verion' => 'Verion',
      'Do you really want to uninstall this package?' => 'Skutočne chcete odinštalovať tento balík?',
      'Install' => 'inštalovať',
      'Package' => 'Balík',
      'Online Repository' => 'Online Repository',
      'Version' => 'Verzia',
      'Vendor' => 'Vendor',
      'Upgrade' => 'Upgrade',
      'Local Repository' => 'miestna schránka',
      'Status' => 'stav',
      'Overview' => 'Náhľad',
      'Download' => 'Stiahnuť',
      'Rebuild' => 'Prestavať',
      'Reinstall' => 'Reinštalovať',

      # Template: AdminPGPForm
      'PGP Management' => 'PGP manažment',
      'Identifier' => 'identifikátor',
      'Bit' => 'bit',
      'Key' => 'kľúč',
      'Fingerprint' => 'Fingerprint',
      'Expires' => 'Platnosť',
      'In this way you can directly edit the keyring configured in SysConfig.' => 'Týmto spôsobom môžete priamo upravovať konfigurácie',

      # Template: AdminPOP3Form
      'POP3 Account Management' => 'POP3 Account Management',
      'Host' => 'Host',
      'Trusted' => 'Dôveryhodný',
      'Dispatching' => 'Vykonanie',
      'All incoming emails with one account will be dispatched in the selected queue!' => 'Všetky prichádzajúce e-maily s jedným účtom budú vybavené vo vybranom rade.',
      'If your account is trusted =>  the already existing x-otrs header at arrival time (for priority =>  ...) will be used! PostMaster filter will be used anyway.' => 'Ak je váš účet ',

      # Template: AdminPostMasterFilter
      'PostMaster Filter Management' => 'PostMaster Filter Management',
      'Filtername' => 'Filtername',
      'Match' => 'Spojiť',
      'Header' => 'Hlavička',
      'Value' => 'Hodnota',
      'Set' => 'Nastaviť',
      'Do dispatch or filter incoming emails based on email X-Headers! RegExp is also possible.' => 'Vybaviť =>  alebo filtrovať prichádzujúce e-maly =>  na báze e-mailu X-header! Reg-Exp je tiež možný!',
      'If you use RegExp =>  you also can use the matched value in () as [***] in \'Set\'.' => 'Ak používate RegExp =>  môžete tiež používať prepojené hodnoty v () ako [***] v \'Set\'.',

      # Template: AdminQueueAutoResponseForm
      'Queue <-> Auto Responses Management' => 'Rady <-> Riadenie automatických odpovedí',

      # Template: AdminQueueAutoResponseTable

      # Template: AdminQueueForm
      'Queue Management' => 'Riadenie radov',
      'Sub-Queue of' => 'Podrad (čoho)',
      'Unlock timeout' => 'Unlock timeout',
      '0 = no unlock' => '0 = žiadne odomkýnanie',
      'Escalation time' => 'čas eskalácie',
      '0 = no escalation' => '0 = žiadne zvyšovanie',
      'Follow up Option' => 'nasledujúce možnosti',
      'Ticket lock after a follow up' => 'uzamknúť požiadavku po nasledovnom',
      'Systemaddress' => 'systémová adresa',
      'Customer Move Notify' => 'hlásenie klientovho pohybu',
      'Customer State Notify' => 'hlásenie stavu klienta',
      'Customer Owner Notify' => 'hlásenie majiteľa klienta',
      'If an agent locks a ticket and he/she will not send an answer within this time =>  the ticket will be unlock automatically. So the ticket is viewable for all other agents.' => 'Ak zástupca uzamkne požiadavku a on/ona nepošle odpoveď do určitého času =>  bude požiadavka automaticky odomknutá a tak zobraziteľná pre všetkých zástupcov.',
      'If a ticket will not be answered in thos time =>  just only this ticket will be shown.' => 'Ak nebude na požiadavku odpovedané do určitého času =>  bude táto požiadavka zobrazená!',
      'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.' => 'Ak je požiadavka zatvorená a klient pošle nasledujúcu požiadavku =>  požiadavka bude zamknutá pre starého majiteľa.',
      'Will be the sender address of this queue for email answers.' => 'Adresa odosielateľa tohto radu pre e-mailovú odpoveď.',
      'The salutation for email answers.' => 'Pozdrav pre e-mailovú odpoveď.',
      'The signature for email answers.' => 'Podpis pre e-mailovú odpoveď.',
      'OTRS sends an notification email to the customer if the ticket is moved.' => 'OTRS posiela klientom oznámenie e-mailom =>  ak bola požiadavka premiestnená.',
      'OTRS sends an notification email to the customer if the ticket state has changed.' => 'OTRS posiela klientom oznámenie e-mailom =>  ak sa zmenil stav požiadavky.',
      'OTRS sends an notification email to the customer if the ticket owner has changed.' => 'OTRS posiela klientom oznámenie e-mailom =>  ak sa zmenil majiteľ požiadavky.',
      # Template: AdminQueueResponsesChangeForm
      'Responses <-> Queue Management' => 'Reakcie <-> Rady manažmentu',

      # Template: AdminQueueResponsesForm
      'Answer' => 'odpoveď',

      # Template: AdminResponseAttachmentChangeForm
      'Responses <-> Attachments Management' => 'Reakcie <-> Prílohy manažmentu',

      # Template: AdminResponseAttachmentForm

      # Template: AdminResponseForm
      'Response Management' => 'odpoveď riadenia',
      'A response is default text to write faster answer (with default text) to customers.' => 'Reakcia je prednastavený text pre rýchlejšie písanie odpovedí klientom.',
      'Don\'t forget to add a new response a queue!' => 'Nezabudnite pridať novú odpoveď radu!',
      'Next state' => 'Ďalší ',
      'All Customer variables like defined in config option CustomerUser.' => 'vsetky zakaznikove premenne ako tie definovane v konfiguracnej moznosti (volbe) CustomerUser',
      'The current ticket state is' => 'Aktuálny stav požiadavky je',
      'Your email address is new' => 'Vaša e-mailová adresa je nová.',

      # Template: AdminRoleForm
      'Role Management' => 'riadenie funkcií',
      'Create a role and put groups in it. Then add the role to the users.' => 'Vytvoriť funkciu a dať ju do skupiny. Potom pridať funkciu užívateľom.',
      'It\'s useful for a lot of users and groups.' => 'Je to použiteľné pre množstvo užívateľov a skupín.',

      # Template: AdminRoleGroupChangeForm
      'Roles <-> Groups Management' => 'úlohy  <-> riadenie skupín',
      'move_into' => 'premiestniť_do',
      'Permissions to move tickets into this group/queue.' => 'Povolenie presunúť požiadavky do tejto skupiny/radu.',
      'create' => 'vytvoriť',
      'Permissions to create tickets in this group/queue.' => 'Povolenie vytvoriť požiadavku v tejto skupine/rade.',
      'owner' => 'majiteľ',
      'Permissions to change the ticket owner in this group/queue.' => 'Povolenie zmeniť majiteľa požiadavky v tejto skupine/rade.',
      'priority' => 'priorita',
      'Permissions to change the ticket priority in this group/queue.' => 'Povolenie zmeniť prioritu požiadavky v tejto skupine/rade.',

      # Template: AdminRoleGroupForm
      'Role' => 'úloha',

      # Template: AdminRoleUserChangeForm
      'Roles <-> Users Management' => 'funkcia <-> riadenie užívateľov',
      'Active' => 'aktívny',
      'Select the role:user relations.' => 'vyber funkciu: prepojenia užívateľov',

      # Template: AdminRoleUserForm

      # Template: AdminSalutationForm
      'Salutation Management' => 'Salutation Management',
      'customer realname' => 'skutočné meno klienta',
      'for agent firstname' => 'pre meno agenta',
      'for agent lastname' => 'pre priezvisko agenta',
      'for agent user id' => 'pre agentovo používateľské id',
      'for agent login' => 'pre login agenta',

      # Template: AdminSelectBoxForm
      'Select Box' => 'vyber priečinok',
      'SQL' => 'SQL',
      'Limit' => 'limit',
      'Select Box Result' => 'Select Box výsledok',

      # Template: AdminSession
      'Session Management' => 'riadenie relácie',
      'Sessions' => 'relácie',
      'Uniq' => 'Uniq',
      'kill all sessions' => 'zruš všetky relácie',
      'Session' => 'relácia',
      'kill session' => 'zrušiť relácie',

      # Template: AdminSignatureForm
      'Signature Management' => 'podpis vedenia',

      # Template: AdminSMIMEForm
      'SMIME Management' => 'SMIME riadenie',
      'Add Certificate' => 'pridaj osobný kľúč',
      'Add Private Key' => 'pridaj osobný kľúč',
      'Secret' => 'Sajné',
      'Hash' => 'Hash',
      'In this way you can directly edit the certification and private keys in file system.' => 'Týmto spôsobom možene priamo meniť osvedčenie a osobný kľúč v systéme súborov.',

      # Template: AdminStateForm
      'System State Management' => 'Riadenie stavu systému.',
      'State Type' => 'typ postavenia',
      'Take care that you also updated the default states in you Kernel/Config.pm!' => 'Dávajte pozor =>  či je aktualizovaný tiež ',
      'See also' => 'pozri aj',

      # Template: AdminSysConfig
      'SysConfig' => 'SysConfig',
      'Group selection' => 'výber skupiny',
      'Show' => 'ukázať',
      'Download Settings' => 'Stiahnuť nastavenia.',
      'Download all system config changes.' => 'Stiahnuť všetky zmeny systémovej konfigurácie.',
      'Load Settings' => 'načítať nastavenia',
      'Subgroup' => 'podskupina',
      'Elements' => 'časti',

      # Template: AdminSysConfigEdit
      'Config Options' => 'možnosti configurácie',
      'Default'        => 'prednastavený',
      'Content'        => 'obsah',
      'New'            => 'nový',
      'New Group'      => 'nová skupina',
      'Group Ro'       => 'nová skupina RO',
      'New Group Ro'   => 'Neue Gruppe Ro',
      'NavBarName'     => 'obraz',
      'Image'          => 'prednastavený',
      'Prio'           => 'predchádzajúci',
      'Block'          => 'blokovať',
      'NavBar'         => 'NavBar',
      'AccessKey'      => 'Prístupový kľúč',

      # Template: AdminSystemAddressForm
      'System Email Addresses Management' => 'správa systémovej e-mailovej adresy',
      'Email' => 'Email',
      'Realname' => 'Skutočné meno',
      'All incoming emails with this Email" (To:) will be dispatched in the selected queue!"' => 'Všetky prichádzajúce e-maily s príjemcom =>  budú vybavené v radoch.',

      # Template: AdminUserForm
      'User Management' => 'Správa užívateľov',
      'Firstname' => 'Meno',
      'Lastname' => 'Priezvisko',
      'User will be needed to handle tickets.' => ,
      'Don\'t forget to add a new user to groups and/or roles!' => 'Nezabudnite pridať nového používateľa do skupín a/alebo úloh!',

      # Template: AdminUserGroupChangeForm
      'Users <-> Groups Management' => 'Užívatelia <-> skupiny ',
      # Template: AdminUserGroupForm

      # Template: AgentBook
      'Address Book' => 'adresár',
      'Return to the compose screen' => 'Späť na obrazovku vytvorenia.',
      'Discard all changes and return to the compose screen' => ,

      # Template: AgentCalendarSmall

      # Template: AgentCalendarSmallIcon

      # Template: AgentCustomerTableView

      # Template: AgentInfo
      'Info' => 'info',

      # Template: AgentLinkObject
      'Link Object' => 'prepojený objekt',
      'Select' => 'výber',
      'Results' => 'výsledky',
      'Total hits' => 'počet úderov',
      'Site' => 'strana',
      'Detail' => 'detail',

      # Template: AgentLookup
      'Lookup' => 'vyhľadať',

      # Template: AgentNavigationBar
      'Ticket selected for bulk action!' => 'Požiadavky vybrané pre hromadnú akciu!',
      'You need min. one selected Ticket!' => 'Potrebujete minimálne 1 vybranú požiadavku!',

      # Template: AgentPreferencesForm

      # Template: AgentSpelling
      'Spell Checker' => 'Kontrola pravopisu',
      'spelling error(s)' => 'Chyba pravopisu',
      'or' => 'alebo',
      'Apply these changes' => 'Použiť tieto zmeny.',

      # Template: AgentTicketBounce
      'A message should have a To: recipient!' => 'Správa musí mať príjemcu!',
      'You need a email address (e. g. customer@example.com) in To:!' => 'Musíte napísať emailovú adresu (napr. klient@príklad.com) do Príjemca:!',
      'Bounce ticket' => 'preskočiť požiadavku',
      'Bounce to' => 'preskočiť na',
      'Next ticket state' => 'Stav ´dalšej požiadavky',
      'Inform sender' => 'informovať odosielateľa.',
      'Your email with ticket number <OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further informations."' => 'Váš e-mail s číslom požiadavky <OTRS_POŽIADAVKA> je pripojený k <OTRS_PRIPOJIŤ_K_POŽIADAVKE>',
      'Send mail!' => 'Pošli mail!',

      # Template: AgentTicketBulk
      'A message should have a subject!' => 'Správa by mala mať predmet!',
      'Ticket Bulk Action' => 'hromadná akcia požiadaviek',
      'Spell Check' => 'kontrola pravopisu',
      'Note type' => 'typ poznámky',
      'Unlock Tickets' => 'Unlock požiadavky.',

      # Template: AgentTicketClose
      'A message should have a body!' => 'Správa musí mať telo.',
      'You need to account time!' => 'Potrebujete časové konto!',
      'Close ticket' => 'Zatvoriť požiadavku',
      'Note Text' => 'Text poznámky',
      'Close type' => 'Typ zatvorenia',
      'Time units' => 'Časová jednotka',
      ' (work units)' => '(pracovná jednotka)',

      # Template: AgentTicketCompose
      'A message must be spell checked!' => 'V správe musí byť skontrolovaný pravopis.',
      'Compose answer for ticket' => 'Vytvoriť odpoveď na požiadavku.',
      'Attach' => 'priložiť',
      'Pending Date' => 'čas vybavenia',
      'for pending* states' => ,

      # Template: AgentTicketCustomer
      'Change customer of ticket' => 'Zmeň klienta požiadavky.',
      'Set customer user and customer id of a ticket' => 'Nastaviť klientského užívateľa a klientské id požiadavky',
      'Customer User' => 'Klient-užívateľ',
      'Search Customer' => 'Hľadať klienta',
      'Customer Data' => 'Klientské údaje',
      'Customer history' => 'História klienta',
      'All customer tickets.' => 'požiadavky všetkých klientov',

      # Template: AgentTicketCustomerMessage
      'Follow up' => 'nasledujúci',

      # Template: AgentTicketEmail
      'Compose Email' => 'vytvoriť e-mail',
      'new ticket' => 'nová požiadavka',
      'Clear To' => 'vymaž: Komu',
      'All Agents' => 'všetci agenti',
      'Termin1' => 'Termín1',

      # Template: AgentTicketForward
      'Article type' => 'typ článku',

      # Template: AgentTicketFreeText
      'Change free text of ticket' => 'zmeniť voľný text požiadavky',

      # Template: AgentTicketHistory
      'History of' => 'história',

      # Template: AgentTicketLocked
      'Ticket locked!' => 'zamknutá požiadavka',
      'Ticket unlock!' => 'neuzamknutá požiadavka!',

      # Template: AgentTicketMailbox
      'Mailbox' => ,
      'Tickets' => 'požiadavky',
      'All messages' => 'všetky správy',
      'New messages' => 'nové správy',
      'Pending messages' => 'nevybavené správy',
      'Reminder messages' => 'pripomienková správa',
      'Reminder' => 'pripomienkovač',
      'Sort by' => 'triediť podľa',
      'Order' => 'poradie',
      'up' => 'hore',
      'down' => 'dolu',

      # Template: AgentTicketMerge
      'You need to use a ticket number!' => 'Musíte používať číslo požiadavky!',
      'Ticket Merge' => 'pripojená požiadavka',
      'Merge to' => 'pripojiť k',
      'Your email with ticket number <OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>"."' => 'Váš e-mail s číslom požiadavky <OTRS_POŽIADAVKA> je pripojený k <OTRS_PRIPOJIŤ_K_POŽIADAVKE>',

      # Template: AgentTicketMove
      'Queue ID' => 'ID radu',
      'Move Ticket' => 'presuň požiadavku',
      'Previous Owner' => 'predchádzajúci majiteľ',

      # Template: AgentTicketNote
      'Add note to ticket' => 'pridať poznámku k požiadavke',
      'Inform Agent' => 'neformálny zástupca',
      'Optional' => 'možnosti',
      'Inform involved Agents' => ,

      # Template: AgentTicketOwner
      'Change owner of ticket' => 'Zmeň požiadavku majiteľa.',
      'Message for new Owner' => 'správa od nového majiteľa.',

      # Template: AgentTicketPending
      'Set Pending' => 'nastaviť vybavenie',
      'Pending type' => 'typ vybavenia',
      'Pending date' => 'termín vybavenia',

      # Template: AgentTicketPhone
      'Phone call' => 'hovor',

      # Template: AgentTicketPhoneNew
      'Clear From' => 'zmazať Od',

      # Template: AgentTicketPlain
      'Plain' => 'čistý',
      'TicketID' => 'ID požiadavky',
      'ArticleID' => 'ID článku',

      # Template: AgentTicketPrint
      'Ticket-Info' => 'info o požiadavkách',
      'Accounted time' => ,
      'Escalation in' => 'zvyšovať v',
      'Linked-Object' => 'prepojený objekt',
      'Parent-Object' => 'materský objekt',
      'Child-Object' => 'dcérsky objekt',
      'by' => 'kým',

      # Template: AgentTicketPriority
      'Change priority of ticket' => 'Zmeň prioritu požiadavky.',

      # Template: AgentTicketQueue
      'Tickets shown' => 'zobrazené požiadavky',
      'Page' => 'strana',
      'Tickets available' => 'dostupné požiadavky',
      'All tickets' => 'Všetky požiadavky',
      'Queues' => 'Rady',
      'Ticket escalation!' => 'stupňovanie požiadaviek',

      # Template: AgentTicketQueueTicketView
      'Your own Ticket' => 'Vaša vlastná požiadavka',
      'Compose Follow up' => 'vytvoriť nasledujúcu',
      'Compose Answer' => 'vytvoriť odpoveď',
      'Contact customer' => 'kontaktovať klienta',
      'Change queue' => 'zmeniť rady',

      # Template: AgentTicketQueueTicketViewLite

      # Template: AgentTicketSearch
      'Ticket Search' => 'vyhľadávanie požiadavky',
      'Profile' => 'profil',
      'Search-Template' => 'Vyhľadávacia šablóna',
      'Created in Queue' => 'Vytvoriť v rade.',
      'Result Form' => 'Výsledok z',
      'Save Search-Profile as Template?' => 'Uložiť vyhľadávací profil ako šablónu?',
      'Yes =>  save it with name' => 'Áno =>  ulož s menom.',
      'Customer history search' => 'história klientského hľadania',
      'Customer history search (e. g. ID342425")."' => 'história klientského hľadania (napr. ID342425")',
      'No * possible!' => 'žiadna * nie je možná',

      # Template: AgentTicketSearchResult
      'Search Result' => 'výsledok hľadania ',
      'Change search options' => 'zmeň možnosti hľadania',

      # Template: AgentTicketSearchResultPrint
      '"}' => '',

      # Template: AgentTicketSearchResultShort
      'sort upward' => 'triediť hore',
      'U' => 'U',
      'sort downward' => 'triediť dolu',
      'D' => 'D',

      # Template: AgentTicketStatusView
      'Ticket Status View' => 'zobrazenie stavu požiadavky',
      'Open Tickets' => 'Otvorené požiadavky',

      # Template: AgentTicketZoom
      'Split' => 'Rozdeliť',

      # Template: AgentTicketZoomStatus
      'Locked' => 'Zamknúť',

      # Template: AgentWindowTabStart

      # Template: AgentWindowTabStop

      # Template: Copyright

      # Template: css

      # Template: customer-css

      # Template: CustomerAccept

      # Template: CustomerCalendarSmallIcon

      # Template: CustomerError
      'Traceback' => 'Traceback',

      # Template: CustomerFAQ
      'Print' => 'Tlačiť',
      'Keywords' => 'Kľúčové slová',
      'Symptom' => 'Symptóm',
      'Problem' => 'Problem',
      'Solution' => 'Riešenie',
      'Modified' => 'Zmenený',
      'Last update' => 'Posledná aktualizácia',
      'FAQ System History' => 'FAQ história systému',
      'modified' => 'zmenený',
      'FAQ Search' => 'FAQ hľadanie',
      'Fulltext' => 'Fulltext',
      'Keyword' => 'Kľúčové slovo',
      'FAQ Search Result' => 'výsledok hľadania FAQ',
      'FAQ Overview' => 'FAQ prehľad',

      # Template: CustomerFooter
      'Powered by' => 'Powered by',

      # Template: CustomerFooterSmall

      # Template: CustomerHeader

      # Template: CustomerHeaderSmall

      # Template: CustomerLogin

      'Login' => 'Login',
      'Lost your password?' => 'Zabudli ste heslo?',
      'Request new password' => 'Požadovať nové heslo',
      'Create Account' => 'Vytvoriť účet',

      # Template: CustomerNavigationBar
      'Welcome %s' => 'Vitajte v %',

      # Template: CustomerPreferencesForm

      # Template: CustomerStatusView
      'of' => 'z',

      # Template: CustomerTicketMessage

      # Template: CustomerTicketMessageNew

      # Template: CustomerTicketSearch

      # Template: CustomerTicketSearchResultCSV

      # Template: CustomerTicketSearchResultPrint

      # Template: CustomerTicketSearchResultShort

      # Template: CustomerTicketZoom

      # Template: CustomerWarning

      # Template: Error
      'Click here to report a bug!' => 'Pre hlásenie chyby =>  kliknite tu!',

      # Template: FAQ
      'Comment (internal)' => 'komentár (vnútorný)',
      'A article should have a title!' => 'Článok musí mať názov!',
      'New FAQ Article' => 'Nový FAQ článok.',
      'Do you really want to delete this Object?' => 'Naozaj chcete zmazať tento objekt?',
      'System History' => 'História systému',

      # Template: FAQCategoryForm
      'Name is required!' => 'Požadované meno!',
      'FAQ Category' => 'Kategória FAQ',

      # Template: FAQLanguageForm
      'FAQ Language' => 'jazyk FAQ',

      # Template: Footer
      'QueueView' => 'Prehľad radu.',
      'PhoneView' => 'Prehľad hovorov',
      'Top of Page' => 'Začiatok strany',

      # Template: FooterSmall

      # Template: Header
      'Home' => 'Home',

      # Template: HeaderSmall

      # Template: Installer
      'Web-Installer' => 'Web-Installer',
      'accept license' => 'akceptovať licenciu',
      'don\'t accept license' => 'neakceptovať licenciu',
      'Admin-User' => 'Admin-používateľ',
      'Admin-Password' => 'Admin-heslo',
      'your MySQL DB should have a root password! Default is empty!' => 'Vaše MySQL DB',
      'Database-User' => 'používateľ databázy',
      'default \'hot\'' => 'predvolený (?)',
      'DB connect host' => 'DB pripojenie host',
      'Database' => 'Databáza',
      'Create' => 'Vytvoriť',
      0 => ,
      'SystemID' => 'SystemID',
      '(The identify of the system. Each ticket number and each http session id starts with this number)' => 'Identifikácia systému. Každé číslo požiadavky a každá http začína týmto číslo.',
      'System FQDN' => 'System FQDN',
      '(Full qualified domain name of your system)' => 'Celý názov domény vášho systému',
      'AdminEmail' => 'AdminEmail',
      '(Email of the system admin)' => 'E-mail systémového administrátora',
      'Organization' => 'Organizácia',
      'Log' => 'Log',
      'LogModule' => 'LogModule',
      '(Used log backend)' => '(Used log backend)',
      'Logfile' => 'Logfile',
      '(Logfile just needed for File-LogModule!)' => 'Súbor záznamov je potrebný pre Súbor Log Module!',
      'Webfrontend' => 'webové rozhranie',
      'Default Charset' => 'Predvolená znaková sada',
      'Use utf-8 it your database supports it!' => 'Použiť utf-8 na podporu Vašej databázy.',
      'Default Language' => 'Predvolený jazyk',
      '(Used default language)' => 'Používaný predvolený jazyk',
      'CheckMXRecord' => 'CheckMXRecord',
      '(Checks MX recordes of used email addresses by composing an answer. Don\'t use CheckMXRecord if your OTRS machine is behinde a dial-up line $!)' => 'Pri skladani (kompozicii) odpovede skontroluje MX zaznamy pouzitych emailovych adries. ',
      'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' => 'Aby ste mohli pouzivat OTRS =>  musite zadat nasledovne: do Vasho prikazoveho riadku (terminal/shell) =>  pricom musite byt prihlaseny ako root:',
      'Restart your webserver' => 'dat "nasledovne") do Vasho prikazoveho riadku (terminal/shell) =>  pricom musite byt prihlaseny ako root:',
      'After doing so your OTRS is up and running.' => 'Ak to urobíte =>  Váš OTRS je spustený.',
      'Start page' => 'Prvá strana',
      'Have a lot of fun!' => 'Veľa zábavy',
      'Your OTRS Team' => 'Váš OTRS tím',

      # Template: Login

      # Template: Motd

      # Template: NoPermission
      'No Permission' => 'Nepovolené',

      # Template: Notify
      'Important' => 'Dôležité',

      # Template: PrintFooter
      'URL' => 'URL',

      # Template: PrintHeader
      'printed by' => 'vytlačený',

      # Template: Redirect

      # Template: SystemStats
      'Format' => 'Formát',

      # Template: Test
      'OTRS Test Page' => 'OTRS test strany',
      'Counter' => 'Počítadlo',

      # Template: Warning
      # Misc
      'OTRS DB connect host' => 'OTRS DB pripojenie',
      'Create Database' => 'Vytvor databázu',
      'DB Host' => 'DB ',
      'Ticket Number Generator' => 'Generovač čísel požiadaviek',
      '(Ticket identifier. Some people want to set this to e. g. \'Ticket#\',\'Call#\' or \'MyTicket#\')' => '(Identifikátor požiadavky. Niektorí ľudia to chcú nastaviť napríklad: \'Ticket#\', \'Call#\' alebo \'MyTicket#\')',
      'In this way you can directly edit the keyring configured in Kernel/Config.pm.' => 'Týmto spôsobom môžete priamo upravovať kľúčové nastavenie v Kenel/Config.',
      'Close!' => 'Zatvoriť!',
      'TicketZoom' => 'Zväčšiť požiadavku',
      'Don\'t forget to add a new user to groups!' => 'Nezabudnite pridať nového používateľa do skupín!',
      'License' => 'Licencia',
      'CreateTicket' => 'Vytvor požiadavku',
      'OTRS DB Name' => 'OTRS DB meno',
      'System Settings' => 'Systémové nastavenia',
      'Finished' => 'Ukončený',
      'Days' => 'Dni',
      'with' => 's',
      'DB Admin User' => 'DB admin používateľ',
      'Change user <-> group settings' => 'Zmeň používateľa <-> nastavenie skupiny',
      'DB Type' => 'DB typ',
      'next step' => 'daľší krok',
      'My Queue' => 'Môj rad',
      'Create new database' => 'Vytvor novú databázu',
      'Delete old database' => 'Vymaž starú databázu',
      'Load' => 'Načítať',
      'OTRS DB User' => 'OTRS DB používateľ',
      'OTRS DB Password' => 'OTRS DB heslo',
      'DB Admin Password' => 'DB heslo administrátora',
      'Drop Database' => 'vymazať databázu',
      '(Used ticket number format)' => '(Použite číselný formát požiadavky)',
      'FAQ History' => 'História FAQ',
      'Customer called' => 'Zákaznícky hovor',
      'Phone' => 'Telefón',
      'Office' => 'Kancelária',
      'CompanyTickets' => 'Firemné požiadavky',
      'MyTickets' => 'Moje požiadavky',
      'New Ticket' => 'Nová požiadavka',
      'Create new Ticket' => 'Vytvor novú požiadavku',
      'Package not correctly deployed =>  you need to deploy it again!' => 'Balík nie je správne rozmiestnený =>  musíte ho rozmiestniť ešte raz.',
      'installed' => 'nainštalovaný',
      'uninstalled' => 'odinštalovaný',
    };
    # $$STOP$$
}
#--
1;
