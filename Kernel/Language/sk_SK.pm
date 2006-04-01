# --
# Kernel/Language/sk_SK.pm - provides sk_SK language translation
# Copyright (C) 2001-2006 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: sk_SK.pm,v 1.3 2006-04-01 23:38:29 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
package Kernel::Language::sk_SK;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.3 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub Data {
    my $Self = shift;
    my %Param = @_;

    # $$START$$
    # Last translation file sync: Thu Jul 28 22:12:45 2005

    # possible charsets
    $Self->{Charset} = ['iso-8859-2',];
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
      'no' => '¾iadny',
      'Off' => 'vypnú»',
      'off' => 'vypnú»',
      'On' => 'zapnú»',
      'on' => 'zapnú»',
      'top' => 'hore',
      'end' => 'koniec',
      'Done' => 'hotovo',
      'Cancel' => 'zru¹i»',
      'Reset' => 'Reset',
      'last' => 'posledný',
      'before' => 'pred',
      'day' => 'deò',
      'days' => 'dni',
      'day(s)' => 'deò/dni',
      'hour' => 'hodina',
      'hours' => 'hodiny',
      'hour(s)' => 'hodina/hodiny',
      'minute' => 'minuta',
      'minutes' => 'minuty',
      'minute(s)' => 'minuta/minuty',
      'month' => 'mesiac',
      'months' => 'mesiace',
      'month(s)' => 'mesiac/mesiace',
      'week' => 'tý¾deò',
      'week(s)' => 'tý¾dne',
      'year' => 'rok',
      'years' => 'roky',
      'year(s)' => 'rok/roky',
      'wrote' => 'písa»',
      'Message' => 'správa',
      'Error' => 'Chyba',
      'Bug Report' => 'chybové hlásenie',
      'Attention' => 'Pozor',
      'Warning' => 'Varovanie',
      'Module' => 'Modul',
      'Modulefile' => 'modulový prieèinok',
      'Subfunction' => 'Podfunkcia',
      'Line' => 'riadok',
      'Example' => 'Príklad',
      'Examples' => 'Príklady',
      'valid' => 'platný',
      'invalid' => 'neplatný',
      'invalid-temporarily' => 'doèasne neplatný',
      ' 2 minutes' => ' 2 minuty',
      ' 5 minutes' => ' 5 minút',
      ' 7 minutes' => ' 7 minút',
      '10 minutes' => ' 10 minút',
      '15 minutes' => ' 15 minút',
      'Mr.' => 'Pán',
      'Mrs.' => 'Pani',
      'Next' => 'ïalej',
      'Back' => 'spä»',
      'Next...' => 'ïalej...',
      '...Back' => '...spä»',
      '-none-' => '-¾iadny-',
      'none' => '¾iadny',
      'none!' => '¾iaden',
      'none - answered' => '¾iadna odpoveï',
      'please do not edit!' => 'Prosím neupravova»!',
      'AddLink' => 'Prida» odkaz.',
      'Link' => 'Prepojenie',
      'Linked' => 'spojený',
      'Link (Normal)' => 'Prepojenie (obyèajné)',
      'Link (Parent)' => 'Prepojenie (zdroj)',
      'Link (Child)' => 'Prepojenie (následník)',
      'Normal' => 'obyèajný',
      'Parent' => 'zdroj',
      'Child' => 'die»a',
      'Hit' => 'úder',
      'Hits' => 'údery',
      'Text' => 'Text',
      'Lite' => 'Odµahèený',
      'User' => 'U¾ívateµ',
      'Username' => 'U¾ívateµské meno',
      'Language' => 'Jazyk',
      'Languages' => 'Jazyky',
      'Password' => 'Heslo',
      'Salutation' => 'Oslovenie',
      'Signature' => 'Podpis',
      'Customer' => 'Zákazník',
      'CustomerID' => 'Zákaznícke è',
      'CustomerIDs' => 'Zákaznícke èísla',
      'customer' => 'Zákazník',
      'agent' => 'Agent',
      'system' => 'Systém',
      'Customer Info' => 'Zákazníke info',
      'go!' => '¹tart!',
      'go' => '¹tart',
      'All' => 'V¹etko',
      'all' => 'v¹etko',
      'Sorry' => 'Pardon',
      'update!' => 'Aktualizuj!',
      'update' => 'Aktualizova»',
      'Update' => 'Aktualizácia',
      'submit!' => 'predlo¾!',
      'submit' => 'predlo¾i»',
      'Submit' => 'Predlo¾enie',
      'change!' => 'Zmeò!',
      'Change' => 'Zmena',
      'change' => 'Zmeni»',
      'click here' => 'klikni tu',
      'Comment' => 'poznámka',
      'Valid' => 'Platný',
      'Invalid Option!' => 'Neplatná mo¾nos»!',
      'Invalid time!' => 'Neplatný èas!',
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
      'Search' => 'Hµada»',
      'and' => 'a',
      'between' => 'medzi',
      'Fulltext Search' => 'Fulltextové vyhµadávanie ',
      'Data' => 'údaje',
      'Options' => 'Mo¾nosti',
      'Title' => 'Názov',
      'Item' => 'Polo¾ka',
      'Delete' => 'Zmaza»',
      'Edit' => 'Upravi»',
      'View' => 'Zobrazi»',
      'Number' => 'èíslo',
      'System' => 'Systém',
      'Contact' => 'Kontakt',
      'Contacts' => 'Kontakty',
      'Export' => 'Export',
      'Up' => 'Hore',
      'Down' => 'Dolu',
      'Add' => 'Prida» ',
      'Category' => 'Kategória',
      'Viewer' => 'Zobraz',
      'New message' => 'Nová správa',
      'New message!' => 'Nová správa!',
      'Please answer this ticket(s) to get back to the normal queue view!' => 'Prosim odpovedajte na tento tiket',
      'You got new message!' => 'Máte novú správu!',
      'You have %s new message(s)!' => 'Máte % nových správ!',
      'You have %s reminder ticket(s)!' => 'Máte % pripomienok!',
      'The recommended charset for your language is %s!' => 'Odporúèaná znaková sada pre vá¹ jazyk je %',
      'Passwords doesn\'t match! Please try it again!' => 'Heslá sa nezhoduju! Prosím skúste znova!',
      'Password is already in use! Please use an other password!' => 'Heslo je u¾ pou¾ívané. Prosím pou¾ite iné heslo!',
      'Password is already used! Please use an other password!' => 'Heslo je u¾ pou¾ívané. Prosím pou¾ite iné heslo!',
      'You need to activate %s first to use it!' => 'Na pou¾ívanie musíte najprv aktivova» %',
      'No suggestions' => '®iadne návrhy.',
      'Word' => 'Slovo',
      'Ignore' => 'Ignorova»',
      'replace with' => 'nahradi» s',
      'Welcome to %s' => 'Vitajte v %',
      'There is no account with that login name.' => 'Neexistuje ¾iadny úèet s týmto ú¾ívateµským menom',
      'Login failed! Your username or password was entered incorrectly.' => 'Prihlásenie zlyhalo! Va¹e pou¾ívateµské meno alebo heslo bolo vlo¾ené nesprávne.',
      'Please contact your admin' => 'Prosím kontaktujte vá¹ho administrátora.',
      'Logout successful. Thank you for using OTRS!' => 'Odhlásenie úspe¹né. Ïakujeme za pou¾ívanie ORTS!',
      'Invalid SessionID!' => 'Neplatný SessionID',
      'Feature not active!' => 'Funkcia neaktívna!',
      'Take this Customer' => 'Pou¾i tohto klienta.',
      'Take this User' => 'Pu¾i tohto u¾ívateµa.',
      'possible' => 'mo¾ný',
      'reject' => 'odmietnu»',
      'Facility' => 'Príslu¹enstvo',
      'Timeover' => 'Timeover',
      'Pending till' => 'Odlo¾ené do.',
      'Don\'t work with UserID 1 (System account)! Create new users!' => 'Nepracujte s pou¾ívateµským èíslom 1 (systémový úèet)! Vytvorte nového pou¾ívateµa.',
      'Dispatching by email To: field.' => 'Posielam emailom =>  prijemca: pole',
      'Dispatching by selected Queue.' => 'Posielam vybraným radom.',
      'No entry found!' => 'Nenájdený ¾iaden vstup.',
      'Session has timed out. Please log in again.' => 'Relácia timeout. Prosím =>  prihláste sa znova.',
      'No Permission!' => 'Nepovolené!',
      'To: (%s) replaced with database email!' => 'Príjemca: % je nahradený databázovým emailom!',
      'Cc: (%s) added database email!' => 'Kópia: % pridaný databázový email.',
      '(Click here to add)' => '(Ak chcete prida» polo¾ku =>  kliknete sem.)',
      'Preview' => 'Náhµad',
      'Added User %s""' => 'Pridaný pou¾ívateµ %',
      'Contract' => 'Zmluva',
      'Online Customer: %s' => 'Online u¾ívateµ: %',
      'Online Agent: %s' => 'Online Agent %',
      'Calendar' => 'Kalendár',
      'File' => 'File',
      'Filename' => 'Filename',
      'Type' => 'Typ',
      'Size' => 'Veµkos»',
      'Upload' => 'Upload',
      'Directory' => 'Directory',
      'Signed' => 'Podpísaný',
      'Sign' => 'Podpísa»',
      'Crypted' => 'Za¹ifrovaný',
      'Crypt' => '¹ifrova»',

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
      'Admin-Area' => 'Admin-oblas»',
      'Agent-Area' => 'Agent-Area',
      'Ticket-Area' => 'Ticket-Area',
      'Logout' => 'Odhlásenie ',
      'Agent Preferences' => 'Nastavenia ú¾ívateµa',
      'Preferences' => 'Nastavenia',
      'Agent Mailbox' => 'Agent Mailbox',
      'Stats' => '¹tatistika',
      'Stats-Area' => '¹tatistická oblas»',
      'FAQ-Area' => 'FAQ oblas»',
      'FAQ' => 'FAQ',
      'FAQ-Search' => 'FAQ-hladanie',
      'FAQ-Article' => 'FAQ-èlánok',
      'New Article' => 'Nový èlánok',
      'FAQ-State' => 'FAQ-stav',
      'Admin' => 'Admin',
      'A web calendar' => 'webový kalendár',
      'WebMail' => 'WebMail',
      'A web mail client' => 'Web mail client',
      'FileManager' => 'Správca súborov',
      'A web file manager' => 'Správca weborých súborov',
      'Artefact' => 'Artefakt',
      'Incident' => 'Udalos»',
      'Advisory' => 'Advisory',
      'WebWatcher' => 'WebWatcher',
      'Customer Users' => 'Klientskí u¾ívatelia.',
      'Customer Users <-> Groups' => 'Klientskí u¾ívatelia <-> skupiny ',
      'Users <-> Groups' => 'U¾ívatelia <-> Skupiny',
      'Roles' => 'Funkcie',
      'Roles <-> Users' => 'Funkcie <-> U¾ívatelia',
      'Roles <-> Groups' => 'Funkcie <-> Skupiny',
      'Salutations' => 'Oslovenia',
      'Signatures' => 'Podpisy',
      'Email Addresses' => 'Emailové adresy',
      'Notifications' => 'Oznamovanie',
      'Category Tree' => 'Strom kategórií',
      'Admin Notification' => 'Administrátorské oznamovanie',

      # Template: AAAPreferences
      'Preferences updated successfully!' => 'Predvoµby úspe¹ne aktualizované!',
      'Mail Management' => 'Správa po¹ty.',
      'Frontend' => 'Frontend',
      'Other Options' => 'Ostatné Mo¾nosti',
      'Change Password' => 'Zmena hesla',
      'New password' => 'Nové heslo',
      'New password again' => 'Znova nové heslo',
      'Select your QueueView refresh time.' => 'Vyberte si refresh time fronty',
      'Select your frontend language.' => 'Vyberte si jazyk.',
      'Select your frontend Charset.' => 'Vyberte si znakovú sadu.',
      'Select your frontend Theme.' => 'Vyberte si vzhµad.',
      'Select your frontend QueueView.' => 'Vyberte si QueueView',
      'Spelling Dictionary' => 'Slovník pravopisu.',
      'Select your default spelling dictionary.' => 'Vyberte si slovník na kontrolu pravopisu.',
      'Max. shown Tickets a page in Overview.' => 'Maximálny poèet po¾iadaviek zobrazovaných v prehµade.',
      'Can\'t update password =>  passwords doesn\'t match! Please try it again!' => 'Nemo¾no aktualizova» heslo =>  heslá nezhodujú.',
      'Can\'t update password =>  invalid characters!' => 'Nemo¾no aktualizova» heslo =>  neplatné znaky.',
      'Can\'t update password =>  need min. 8 characters!' => 'Nemo¾no aktualizova» heslo =>  potrebujete minimálne 8 písmen.',
      'Can\'t update password =>  need 2 lower and 2 upper characters!' => 'Nemo¾no aktualizova» heslo =>  potrebujete 2 malé a 2 veµké písmená',
      'Can\'t update password =>  need min. 1 digit!' => 'Nemo¾no aktualizova» heslo =>  potrebujete minimálne 1 èíslicu.',
      'Can\'t update password =>  need min. 2 characters!' => 'Nemo¾no aktualizova» heslo =>  potrebujete minimálne 2 písmená!',
      'Password is needed!' => 'Je potrebné heslo.',

      # Template: AAATicket
      'Lock' => 'Zamknú»',
      'Unlock' => 'Odomknú»',
      'History' => 'História',
      'Zoom' => 'Zväè¹i»',
      'Age' => 'Vek',
      'Bounce' => 'Skoèi» na',
      'Forward' => 'Nasledujúci',
      'From' => 'Od ',
      'To' => 'Príjemca',
      'Cc' => 'Cc',
      'Bcc' => 'Bcc',
      'Subject' => 'Predmet',
      'Move' => 'Presunú»',
      'Queue' => 'Fronta',
      'Priority' => 'Priorita',
      'State' => 'Stav',
      'Compose' => 'Vytvori»',
      'Pending' => 'èakanie',
      'Owner' => 'Vlastník',
      'Owner Update' => 'aktualizácia vlastníka',
      'Sender' => 'Odosielateµ',
      'Article' => 'èlánok',
      'Ticket' => 'Po¾iadavka',
      'Createtime' => 'Doba spracovania',
      'plain' => 'jednoduchý',
      'Email' => 'e-mail',
      'email' => 'e-mail',
      'Close' => 'Zatvorit',
      'Action' => 'Akcia',
      'Attachment' => 'Príloha',
      'Attachments' => 'Prílohy',
      'This message was written in a character set other than your own.' => 'Táto správa bola napísaná v inej znakovej sade =>  ako je va¹a.',
      'If it is not displayed correctly => ' => 'Ak nie je zobrazená správne =>  ',
      'This is a' => 'To je',
      'to open it in a new window.' => 'Otvori» v novom okne',
      'This is a HTML email. Click here to show it.' => 'Toto je HMTL  e-mail. Na otvorenie =>  kliknite tu',
      'Free Fields' => 'Voµné polia',
      'Merge' => 'Zlúèi»',
      'closed successful' => 'zatvorené úspe¹ne',
      'closed unsuccessful' => 'zatvorené neúspe¹ne',
      'new' => 'nový',
      'open' => 'otvori»',
      'closed' => 'zatvorený',
      'removed' => 'odstránený',
      'pending reminder' => 'nevybavená pripomienka',
      'pending auto close+' => 'poèas automatického zatvárania +',
      'pending auto close-' => 'poèas automatického zatvárania -',
      'email-external' => 'externý e-mail',
      'email-internal' => 'interný e-mail',
      'note-external' => 'externá poznámka',
      'note-internal' => 'interná poznámka',
      'note-report' => 'hlásnie poznámky',
      'phone' => 'telefón',
      'sms' => 'sms',
      'webrequest' => 'webová po¾iadavka',
      'lock' => 'zamknú»',
      'unlock' => 'odomknú»',
      'very low' => 'veµmi nízka',
      'low' => 'nízka',
      'normal' => 'normálna',
      'high' => 'vysoká',
      'very high' => 'veµmi vysoká',
      '1 very low' => '1 veµmi nízka',
      '2 low' => '2 nízka',
      '3 normal' => '3 normálna',
      '4 high' => '4 vysoká',
      '5 very high' => '5 veµmi vysoká',
      'Ticket %s" created!"' => 'po¾iadavka % vytvorená',
      'Ticket Number' => 'èíslo po¾iadavky',
      'Ticket Object' => 'predmet po¾iadavky',
      'No such Ticket Number %s"! Can\'t link it!"' => '®iadna po¾iadavka èíslo %. ',
      'Don\'t show closed Tickets' => 'Nezobrazuj uzavreté po¾iadavky.',
      'Show closed Tickets' => 'Zobraz uzavreté po¾iadavky.',
      'Email-Ticket' => 'e-mailová po¾iadavka',
      'Create new Email Ticket' => 'Vytvor novú e-mailovú po¾iadavku',
      'Phone-Ticket' => 'Telefonická po¾iadavka',
      'Create new Phone Ticket' => 'Vytvor novú telefonickú po¾iadavku',
      'Search Tickets' => 'Hµadaj po¾iadavky',
      'Edit Customer Users' => 'Uprav zákazníckeho u¾ívateµa.',
      'Bulk-Action' => 'Hromadná akcia',
      'Bulk Actions on Tickets' => 'hromadné akcie na po¾iadavkách.',
      'Send Email and create a new Ticket' => 'Po¹li e-mail a vytvor novú po¾iadavku',
      'Overview of all open Tickets' => 'Prehµad v¹etkých otvorených po¾iadaviek.',
      'Locked Tickets' => 'Lockované po¾iadavky',
      'Lock it to work on it!' => 'Kvôli práci na nich =>  lock.',
      'Unlock to give it back to the queue!' => 'Unlock a daj spä» do radu.',
      'Shows the ticket history!' => 'Zobraz históriu po¾iadaviek.',
      'Print this ticket!' => 'Vytlaè túto po¾iadavku.',
      'Change the ticket priority!' => 'Zmeò prioritu po¾iadavky.',
      'Change the ticket free fields!' => 'Zmeò voµné polia po¾iadavky.',
      'Link this ticket to an other objects!' => 'Prepoj po¾iadavku s inými objektami!',
      'Change the ticket owner!' => 'Zmeò majiteµa po¾iadavky.',
      'Change the ticket customer!' => 'Zmeò klienta po¾iadavky.',
      'Add a note to this ticket!' => 'Pridaj poznámku k tejto po¾iadavke.',
      'Merge this ticket!' => 'Pripoj túto po¾iadavku.',
      'Set this ticket to pending!' => 'Nastav po¾iadavku na vyrie¹enie.',
      'Close this ticket!' => 'Zatvor túto po¾iadavku.',
      'Look into a ticket!' => 'Vyhµadaj po¾iadavku.',
      'Delete this ticket!' => 'Vyma¾ túto po¾iadavku.',
      'Mark as Spam!' => 'Oznaè ako Spam!',
      'My Queues' => 'Moje rady.',
      'Shown Tickets' => 'Zobraz po¾iadavky.',
      'New ticket notification' => 'Hlásenie novej po¾iadavky.',
      'Send me a notification if there is a new ticket in My Queues"."' => 'Po¹li mi notifikáciu =>  ak je nová po¾iadavka v MyQueue ?',
      'Follow up notification' => 'Nasleduj hlásenie.',
      'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.' => 'Po¹li mi oznámenie =>  ak klient po¹le overenie a ja som vlastník tejto po¾iadavky.',
      'Ticket lock timeout notification' => 'Po¾iadavka blokuje èasový limit oznámenia.',
      'Send me a notification if a ticket is unlocked by the system.' => 'Po¹li mi oznámenie =>  ak je po¾iadavka odblokovaná systémom.',
      'Move notification' => 'Premiestni hlásenie',
      'Send me a notification if a ticket is moved into one of My Queues"."' => 'Po¹li mi oznámenie =>  ak je po¾iadavka premiestnená do jedného z mojich radov.',
      'Your queue selection of your favorite queues. You also get notified about this queues via email if enabled.' => 'Vá¹ výber z obµúbených radov. Tie¾ mô¾ete by» oboznámený s po¾iadavkou cez e-mail =>  ak je to mo¾né.',
      'Custom Queue' => 'Klientské rady.',
      'QueueView refresh time' => '?',
      'Screen after new ticket' => 'Okno po novej po¾iadavke.',
      'Select your screen after creating a new ticket.' => 'Vyberte si okno zobrazujúce sa po vytvorení novej po¾iadavky.',
      'Closed Tickets' => 'Zatvorené po¾iadavky.',
      'Show closed tickets.' => 'Uká¾ zatvorené po¾iadavky.',
      'Max. shown Tickets a page in QueueView.' => 'Maximálny poèet po¾iadaviek zobrazovaných v prehµade.',
      'Responses' => 'Odpovede',
      'Responses <-> Queue' => 'Odpovede <-> rad',
      'Auto Responses' => 'Automatické odpovede',
      'Auto Responses <-> Queue' => 'Automatické odpovede <-> rad',
      'Attachments <-> Responses' => 'Prílohy <-> Odpovede',
      'History::Move' => 'História: pohyb',
      'History::NewTicket' => 'História: Nová pripomienka',
      'History::FollowUp' => 'História: sleduj',
      'History::SendAutoReject' => 'História: po¹li automatickú odpoveï',
      'History::SendAutoReply' => 'História: po¹li automatické zamietnutie',
      'History::SendAutoFollowUp' => 'História: SendAutoFollowUp',
      'History::Forward' => 'História: Forward',
      'History::Bounce' => 'História: ',
      'History::SendAnswer' => 'História:: Po¹li odpoveï',
      'History::SendAgentNotification' => 'História:: po¹li notifikáciu zástupcovi',
      'History::SendCustomerNotification' => 'História:: Po¹li zákaznícku notifikáciu',
      'History::EmailAgent' => 'História: email zástupcu',
      'History::EmailCustomer' => 'História: Email klienta',
      'History::PhoneCallAgent' => 'História: Hovor agenta',
      'History::PhoneCallCustomer' => 'História: Hovor klienta',
      'History::AddNote' => 'História: Pridaj poznámku',
      'History::Lock' => 'História: zamkni',
      'History::Unlock' => 'História: odomkni',
      'History::TimeAccounting' => 'História: èasový úèet',
      'History::Remove' => 'História: odstránené',
      'History::CustomerUpdate' => 'História: klientská aktualizácia',
      'History::PriorityUpdate' => 'História: aktualizácia priorít',
      'History::OwnerUpdate' => 'História: aktualizácia majiteµa',
      'History::LoopProtection' => 'História: LoopProtection',
      'History::Misc' => 'História: ',
      'History::SetPendingTime' => 'História: Nastav èas rie¹enia',
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
      'Response' => 'Odpoveï',
      'Auto Response From' => 'Automatická odpoveï od',
      'Note' => 'Poznámka',
      'Useable options' => 'pou¾iteµná mo¾nos»',
      'to get the first 20 character of the subject' => 'zobrazi» prvých 20 vlastností subjektu',
      'to get the first 5 lines of the email' => 'zobrazi» prvých 5 riadkov emailu',
      'to get the from line of the email' => 'zobrazi» ',
      'to get the realname of the sender (if given)' => 'zobrazi» skutoèné meno odosielateµa (ak je dané)',
      'Options of the ticket data (e. g. &lt;OTRS_TICKET_Number&gt; =>  &lt;OTRS_TICKET_ID&gt; =>  &lt;OTRS_TICKET_Queue&gt; =>  &lt;OTRS_TICKET_State&gt;)' => 'Mo¾nosti údajov po¾iadavky (napr. &lt;OTRS_TICKET_Number&gt; =>  &lt;OTRS_TICKET_ID&gt; =>  &lt;OTRS_TICKET_Queue&gt; =>  &lt;OTRS_TICKET_State&gt;)',

      # Template: AdminCustomerUserForm
      'The message being composed has been closed.  Exiting.' => 'Vytvorená správa bola zatvorená. ',
      'This window must be called from compose window' => 'Toto okno musí by» vyvolané z okna na vytváranie.',
      'Customer User Management' => 'Riadenie klientských u¾ívateµov.',
      'Search for' => 'Hµada»',
      'Result' => 'výsledok',
      'Select Source (for add)' => 'vyber zdroj (pre pridanie)',
      'Source' => 'zdroj',
      'This values are read only.' => 'Táto hodnota je iba na èítanie',
      'This values are required.' => 'Táto hodnota je po¾adovaná.',
      'Customer user will be needed to have a customer history and to login via customer panel.' => 'Customer user will be needed to have a customer history and to login via customer panel.',

      # Template: AdminCustomerUserGroupChangeForm
      'Customer Users <-> Groups Management' => 'Klientský u¾ívatelia <-> Skupiny riadenia',
      'Change %s settings' => 'Zmeni» % nastavenia',
      'Select the user:group permissions.' => 'Vyber pou¾ívateµa: skupina povolená',
      'If nothing is selected =>  then there are no permissions in this group (tickets will not be available for the user).' => 'Ak nie je niè vybrané =>  nie je dovolené pracova» v tejto skupine (po¾iadavky nie sú dostupné pre u¾ívateµa)',
      'Permission' => 'Povolenie',
      'ro' => 'ro',
      'Read only access to the ticket in this group/queue.' => 'Èítaj iba prístup k po¾iadavkám v tejto skupine/rade.',
      'rw' => 'rw',
      'Full read and write access to the tickets in this group/queue.' => ,

      # Template: AdminCustomerUserGroupForm

      # Template: AdminEmail
      'Message sent to' => 'Správa poslaná',
      'Recipents' => 'Adresáti',
      'Body' => 'Telo správy',
      'send' => 'Posla»',

      # Template: AdminGenericAgent
      'GenericAgent' => 'generovaný zástupca',
      'Job-List' => 'zoznam úloh',
      'Last run' => 'posledné spustenie',
      'Run Now!' => 'Spusti!',
      'x' => 'x',
      'Save Job as?' => 'Ulo¾i» prácu ako?',
      'Is Job Valid?' => 'Je práca platná?',
      'Is Job Valid' => 'Je práca platná',
      'Schedule' => 'Rozvrh',
      'Fulltext-Search in Article (e. g. Mar*in" or "Baue*")"' => 'Fulltextové vyhµadávanie v èlánku (napr. Mar*in" alebo "Baue*")"',
      '(e. g. 10*5155 or 105658*)' => '(napr. 10*5155 alebo 105658*)',
      '(e. g. 234321)' => '(napr. 234321)',
      'Customer User Login' => 'login klientského u¾ívateµa',
      '(e. g. U5150)' => '(napr. U5150)',
      'Agent' => 'Zástupca',
      'TicketFreeText' => 'Text bez po¾iadavky',
      'Ticket Lock' => ,
      'Times' => 'èas',
      'No time settings.' => '¾iadne èasové nastavenia',
      'Ticket created' => 'Pripomienka vytvorená',
      'Ticket created between' => 'Pripomienka vytvorená medzi',
      'New Priority' => 'Nová priorita',
      'New Queue' => 'Nový rad',
      'New State' => 'Nový stav',
      'New Agent' => 'Nový zástupca',
      'New Owner' => 'Nový ',
      'New Customer' => 'Nový zákazník',
      'New Ticket Lock' => ,
      'CustomerUser' => 'klientský u¾ívateµ',
      'Add Note' => 'priada» poznámku',
      'CMD' => 'CMD',
      'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' => 'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.',
      'Delete tickets' => 'Zmazané po¾iadavky',
      'Warning! This tickets will be removed from the database! This tickets are lost!' => 'Pozor! Táto po¾iadavka bude vymazaná z databázy. Tieto po¾iadavky sú stratené!',
      'Modules' => 'Moduly',
      'Param 1' => 'parameter 1',
      'Param 2' => 'parameter 2',
      'Param 3' => 'parameter 3',
      'Param 4' => 'parameter 4',
      'Param 5' => 'parameter 5',
      'Param 6' => 'parameter 6',
      'Save' => 'Ulo¾i»',

      # Template: AdminGroupForm
      'Group Management' => 'Správa skupín',
      'The admin group is to get in the admin area and the stats group to get stats area.' => 'The admin group is to get in the admin area and the stats group to get stats area.',
      'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department =>  support department =>  sales department =>  ...).' => 'vytvorit nove skupiny pre osetrenie pristupovych prav roznych skupin agentov (napr. Oddelenie nákupu =>  oddelenie predaja => ..)',
      'It\'s useful for ASP solutions.' => 'It\'s useful for ASP solutions.',

      # Template: AdminLog
      'System Log' => 'systémový záznam',
      'Time' => 'èas',

      # Template: AdminNavigationBar
      'Users' => 'U¾ívatelia',
      'Groups' => 'Skupiny',
      'Misc' => 'Ine',

      # Template: AdminNotificationForm
      'Notification Management' => 'Správa hlásení',
      'Notification' => 'Hlásenie',
      'Notifications are sent to an agent or a customer.' => 'Hlásenia sú poslané zástupcovi alebo zákazníkovi.',
      'Config options (e. g. &lt;OTRS_CONFIG_HttpType&gt;)' => 'mo¾nosti konfigurácie (napr. &lt;OTRS_CONFIG_HttpType&gt;)',
      'Ticket owner options (e. g. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)' => 'Mo¾nosti majiteµa po¾iadavky (napr. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)',
      'Options of the current user who requested this action (e. g. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)' => 'Mo¾nosti aktuálneho pou¾ívateµa =>  ktorý po¾aduje tieto akcie (napr. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)',
      'Options of the current customer user data (e. g. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)' => 'Mo¾nosti údajov aktuálnohe klientského u¾ívateµa (napr. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)',

      # Template: AdminPackageManager
      'Package Manager' => 'riadenie balíka',
      'Uninstall' => 'odin¹talova»',
      'Verion' => 'Verion',
      'Do you really want to uninstall this package?' => 'Skutoène chcete odin¹talova» tento balík?',
      'Install' => 'in¹talova»',
      'Package' => 'Balík',
      'Online Repository' => 'Online Repository',
      'Version' => 'Verzia',
      'Vendor' => 'Vendor',
      'Upgrade' => 'Upgrade',
      'Local Repository' => 'miestna schránka',
      'Status' => 'stav',
      'Overview' => 'Náhµad',
      'Download' => 'Stiahnu»',
      'Rebuild' => 'Prestava»',
      'Reinstall' => 'Rein¹talova»',

      # Template: AdminPGPForm
      'PGP Management' => 'PGP mana¾ment',
      'Identifier' => 'identifikátor',
      'Bit' => 'bit',
      'Key' => 'kµúè',
      'Fingerprint' => 'Fingerprint',
      'Expires' => 'Platnos»',
      'In this way you can directly edit the keyring configured in SysConfig.' => 'Týmto spôsobom mô¾ete priamo upravova» konfigurácie',

      # Template: AdminPOP3Form
      'POP3 Account Management' => 'POP3 Account Management',
      'Host' => 'Host',
      'Trusted' => 'Dôveryhodný',
      'Dispatching' => 'Vykonanie',
      'All incoming emails with one account will be dispatched in the selected queue!' => 'V¹etky prichádzajúce e-maily s jedným úètom budú vybavené vo vybranom rade.',
      'If your account is trusted =>  the already existing x-otrs header at arrival time (for priority =>  ...) will be used! PostMaster filter will be used anyway.' => 'Ak je vá¹ úèet ',

      # Template: AdminPostMasterFilter
      'PostMaster Filter Management' => 'PostMaster Filter Management',
      'Filtername' => 'Filtername',
      'Match' => 'Spoji»',
      'Header' => 'Hlavièka',
      'Value' => 'Hodnota',
      'Set' => 'Nastavi»',
      'Do dispatch or filter incoming emails based on email X-Headers! RegExp is also possible.' => 'Vybavi» =>  alebo filtrova» prichádzujúce e-maly =>  na báze e-mailu X-header! Reg-Exp je tie¾ mo¾ný!',
      'If you use RegExp =>  you also can use the matched value in () as [***] in \'Set\'.' => 'Ak pou¾ívate RegExp =>  mô¾ete tie¾ pou¾íva» prepojené hodnoty v () ako [***] v \'Set\'.',

      # Template: AdminQueueAutoResponseForm
      'Queue <-> Auto Responses Management' => 'Rady <-> Riadenie automatických odpovedí',

      # Template: AdminQueueAutoResponseTable

      # Template: AdminQueueForm
      'Queue Management' => 'Riadenie radov',
      'Sub-Queue of' => 'Podrad (èoho)',
      'Unlock timeout' => 'Unlock timeout',
      '0 = no unlock' => '0 = ¾iadne odomkýnanie',
      'Escalation time' => 'èas eskalácie',
      '0 = no escalation' => '0 = ¾iadne zvy¹ovanie',
      'Follow up Option' => 'nasledujúce mo¾nosti',
      'Ticket lock after a follow up' => 'uzamknú» po¾iadavku po nasledovnom',
      'Systemaddress' => 'systémová adresa',
      'Customer Move Notify' => 'hlásenie klientovho pohybu',
      'Customer State Notify' => 'hlásenie stavu klienta',
      'Customer Owner Notify' => 'hlásenie majiteµa klienta',
      'If an agent locks a ticket and he/she will not send an answer within this time =>  the ticket will be unlock automatically. So the ticket is viewable for all other agents.' => 'Ak zástupca uzamkne po¾iadavku a on/ona nepo¹le odpoveï do urèitého èasu =>  bude po¾iadavka automaticky odomknutá a tak zobraziteµná pre v¹etkých zástupcov.',
      'If a ticket will not be answered in this time =>  just only this ticket will be shown.' => 'Ak nebude na po¾iadavku odpovedané do urèitého èasu =>  bude táto po¾iadavka zobrazená!',
      'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.' => 'Ak je po¾iadavka zatvorená a klient po¹le nasledujúcu po¾iadavku =>  po¾iadavka bude zamknutá pre starého majiteµa.',
      'Will be the sender address of this queue for email answers.' => 'Adresa odosielateµa tohto radu pre e-mailovú odpoveï.',
      'The salutation for email answers.' => 'Pozdrav pre e-mailovú odpoveï.',
      'The signature for email answers.' => 'Podpis pre e-mailovú odpoveï.',
      'OTRS sends an notification email to the customer if the ticket is moved.' => 'OTRS posiela klientom oznámenie e-mailom =>  ak bola po¾iadavka premiestnená.',
      'OTRS sends an notification email to the customer if the ticket state has changed.' => 'OTRS posiela klientom oznámenie e-mailom =>  ak sa zmenil stav po¾iadavky.',
      'OTRS sends an notification email to the customer if the ticket owner has changed.' => 'OTRS posiela klientom oznámenie e-mailom =>  ak sa zmenil majiteµ po¾iadavky.',
      # Template: AdminQueueResponsesChangeForm
      'Responses <-> Queue Management' => 'Reakcie <-> Rady mana¾mentu',

      # Template: AdminQueueResponsesForm
      'Answer' => 'odpoveï',

      # Template: AdminResponseAttachmentChangeForm
      'Responses <-> Attachments Management' => 'Reakcie <-> Prílohy mana¾mentu',

      # Template: AdminResponseAttachmentForm

      # Template: AdminResponseForm
      'Response Management' => 'odpoveï riadenia',
      'A response is default text to write faster answer (with default text) to customers.' => 'Reakcia je prednastavený text pre rýchlej¹ie písanie odpovedí klientom.',
      'Don\'t forget to add a new response a queue!' => 'Nezabudnite prida» novú odpoveï radu!',
      'Next state' => 'Ïal¹í ',
      'All Customer variables like defined in config option CustomerUser.' => 'vsetky zakaznikove premenne ako tie definovane v konfiguracnej moznosti (volbe) CustomerUser',
      'The current ticket state is' => 'Aktuálny stav po¾iadavky je',
      'Your email address is new' => 'Va¹a e-mailová adresa je nová.',

      # Template: AdminRoleForm
      'Role Management' => 'riadenie funkcií',
      'Create a role and put groups in it. Then add the role to the users.' => 'Vytvori» funkciu a da» ju do skupiny. Potom prida» funkciu u¾ívateµom.',
      'It\'s useful for a lot of users and groups.' => 'Je to pou¾iteµné pre mno¾stvo u¾ívateµov a skupín.',

      # Template: AdminRoleGroupChangeForm
      'Roles <-> Groups Management' => 'úlohy  <-> riadenie skupín',
      'move_into' => 'premiestni»_do',
      'Permissions to move tickets into this group/queue.' => 'Povolenie presunú» po¾iadavky do tejto skupiny/radu.',
      'create' => 'vytvori»',
      'Permissions to create tickets in this group/queue.' => 'Povolenie vytvori» po¾iadavku v tejto skupine/rade.',
      'owner' => 'majiteµ',
      'Permissions to change the ticket owner in this group/queue.' => 'Povolenie zmeni» majiteµa po¾iadavky v tejto skupine/rade.',
      'priority' => 'priorita',
      'Permissions to change the ticket priority in this group/queue.' => 'Povolenie zmeni» prioritu po¾iadavky v tejto skupine/rade.',

      # Template: AdminRoleGroupForm
      'Role' => 'úloha',

      # Template: AdminRoleUserChangeForm
      'Roles <-> Users Management' => 'funkcia <-> riadenie u¾ívateµov',
      'Active' => 'aktívny',
      'Select the role:user relations.' => 'vyber funkciu: prepojenia u¾ívateµov',

      # Template: AdminRoleUserForm

      # Template: AdminSalutationForm
      'Salutation Management' => 'Salutation Management',
      'customer realname' => 'skutoèné meno klienta',
      'for agent firstname' => 'pre meno agenta',
      'for agent lastname' => 'pre priezvisko agenta',
      'for agent user id' => 'pre agentovo pou¾ívateµské id',
      'for agent login' => 'pre login agenta',

      # Template: AdminSelectBoxForm
      'Select Box' => 'vyber prieèinok',
      'SQL' => 'SQL',
      'Limit' => 'limit',
      'Select Box Result' => 'Select Box výsledok',

      # Template: AdminSession
      'Session Management' => 'riadenie relácie',
      'Sessions' => 'relácie',
      'Uniq' => 'Uniq',
      'kill all sessions' => 'zru¹ v¹etky relácie',
      'Session' => 'relácia',
      'kill session' => 'zru¹i» relácie',

      # Template: AdminSignatureForm
      'Signature Management' => 'podpis vedenia',

      # Template: AdminSMIMEForm
      'SMIME Management' => 'SMIME riadenie',
      'Add Certificate' => 'pridaj osobný kµúè',
      'Add Private Key' => 'pridaj osobný kµúè',
      'Secret' => 'Sajné',
      'Hash' => 'Hash',
      'In this way you can directly edit the certification and private keys in file system.' => 'Týmto spôsobom mo¾ene priamo meni» osvedèenie a osobný kµúè v systéme súborov.',

      # Template: AdminStateForm
      'System State Management' => 'Riadenie stavu systému.',
      'State Type' => 'typ postavenia',
      'Take care that you also updated the default states in you Kernel/Config.pm!' => 'Dávajte pozor =>  èi je aktualizovaný tie¾ ',
      'See also' => 'pozri aj',

      # Template: AdminSysConfig
      'SysConfig' => 'SysConfig',
      'Group selection' => 'výber skupiny',
      'Show' => 'ukáza»',
      'Download Settings' => 'Stiahnu» nastavenia.',
      'Download all system config changes.' => 'Stiahnu» v¹etky zmeny systémovej konfigurácie.',
      'Load Settings' => 'naèíta» nastavenia',
      'Subgroup' => 'podskupina',
      'Elements' => 'èasti',

      # Template: AdminSysConfigEdit
      'Config Options' => 'mo¾nosti configurácie',
      'Default'        => 'prednastavený',
      'Content'        => 'obsah',
      'New'            => 'nový',
      'New Group'      => 'nová skupina',
      'Group Ro'       => 'nová skupina RO',
      'New Group Ro'   => 'Neue Gruppe Ro',
      'NavBarName'     => 'obraz',
      'Image'          => 'prednastavený',
      'Prio'           => 'predchádzajúci',
      'Block'          => 'blokova»',
      'NavBar'         => 'NavBar',
      'AccessKey'      => 'Prístupový kµúè',

      # Template: AdminSystemAddressForm
      'System Email Addresses Management' => 'správa systémovej e-mailovej adresy',
      'Email' => 'Email',
      'Realname' => 'Skutoèné meno',
      'All incoming emails with this Email" (To:) will be dispatched in the selected queue!"' => 'V¹etky prichádzajúce e-maily s príjemcom =>  budú vybavené v radoch.',

      # Template: AdminUserForm
      'User Management' => 'Správa u¾ívateµov',
      'Firstname' => 'Meno',
      'Lastname' => 'Priezvisko',
      'User will be needed to handle tickets.' => ,
      'Don\'t forget to add a new user to groups and/or roles!' => 'Nezabudnite prida» nového pou¾ívateµa do skupín a/alebo úloh!',

      # Template: AdminUserGroupChangeForm
      'Users <-> Groups Management' => 'U¾ívatelia <-> skupiny ',
      # Template: AdminUserGroupForm

      # Template: AgentBook
      'Address Book' => 'adresár',
      'Return to the compose screen' => 'Spä» na obrazovku vytvorenia.',
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
      'Total hits' => 'poèet úderov',
      'Site' => 'strana',
      'Detail' => 'detail',

      # Template: AgentLookup
      'Lookup' => 'vyhµada»',

      # Template: AgentNavigationBar
      'Ticket selected for bulk action!' => 'Po¾iadavky vybrané pre hromadnú akciu!',
      'You need min. one selected Ticket!' => 'Potrebujete minimálne 1 vybranú po¾iadavku!',

      # Template: AgentPreferencesForm

      # Template: AgentSpelling
      'Spell Checker' => 'Kontrola pravopisu',
      'spelling error(s)' => 'Chyba pravopisu',
      'or' => 'alebo',
      'Apply these changes' => 'Pou¾i» tieto zmeny.',

      # Template: AgentTicketBounce
      'A message should have a To: recipient!' => 'Správa musí ma» príjemcu!',
      'You need a email address (e. g. customer@example.com) in To:!' => 'Musíte napísa» emailovú adresu (napr. klient@príklad.com) do Príjemca:!',
      'Bounce ticket' => 'preskoèi» po¾iadavku',
      'Bounce to' => 'preskoèi» na',
      'Next ticket state' => 'Stav ´dal¹ej po¾iadavky',
      'Inform sender' => 'informova» odosielateµa.',
      'Your email with ticket number <OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further informations."' => 'Vá¹ e-mail s èíslom po¾iadavky <OTRS_PO®IADAVKA> je pripojený k <OTRS_PRIPOJI«_K_PO®IADAVKE>',
      'Send mail!' => 'Po¹li mail!',

      # Template: AgentTicketBulk
      'A message should have a subject!' => 'Správa by mala ma» predmet!',
      'Ticket Bulk Action' => 'hromadná akcia po¾iadaviek',
      'Spell Check' => 'kontrola pravopisu',
      'Note type' => 'typ poznámky',
      'Unlock Tickets' => 'Unlock po¾iadavky.',

      # Template: AgentTicketClose
      'A message should have a body!' => 'Správa musí ma» telo.',
      'You need to account time!' => 'Potrebujete èasové konto!',
      'Close ticket' => 'Zatvori» po¾iadavku',
      'Note Text' => 'Text poznámky',
      'Close type' => 'Typ zatvorenia',
      'Time units' => 'Èasová jednotka',
      ' (work units)' => '(pracovná jednotka)',

      # Template: AgentTicketCompose
      'A message must be spell checked!' => 'V správe musí by» skontrolovaný pravopis.',
      'Compose answer for ticket' => 'Vytvori» odpoveï na po¾iadavku.',
      'Attach' => 'prilo¾i»',
      'Pending Date' => 'èas vybavenia',
      'for pending* states' => ,

      # Template: AgentTicketCustomer
      'Change customer of ticket' => 'Zmeò klienta po¾iadavky.',
      'Set customer user and customer id of a ticket' => 'Nastavi» klientského u¾ívateµa a klientské id po¾iadavky',
      'Customer User' => 'Klient-u¾ívateµ',
      'Search Customer' => 'Hµada» klienta',
      'Customer Data' => 'Klientské údaje',
      'Customer history' => 'História klienta',
      'All customer tickets.' => 'po¾iadavky v¹etkých klientov',

      # Template: AgentTicketCustomerMessage
      'Follow up' => 'nasledujúci',

      # Template: AgentTicketEmail
      'Compose Email' => 'vytvori» e-mail',
      'new ticket' => 'nová po¾iadavka',
      'Clear To' => 'vyma¾: Komu',
      'All Agents' => 'v¹etci agenti',
      'Termin1' => 'Termín1',

      # Template: AgentTicketForward
      'Article type' => 'typ èlánku',

      # Template: AgentTicketFreeText
      'Change free text of ticket' => 'zmeni» voµný text po¾iadavky',

      # Template: AgentTicketHistory
      'History of' => 'história',

      # Template: AgentTicketLocked
      'Ticket locked!' => 'zamknutá po¾iadavka',
      'Ticket unlock!' => 'neuzamknutá po¾iadavka!',

      # Template: AgentTicketMailbox
      'Mailbox' => ,
      'Tickets' => 'po¾iadavky',
      'All messages' => 'v¹etky správy',
      'New messages' => 'nové správy',
      'Pending messages' => 'nevybavené správy',
      'Reminder messages' => 'pripomienková správa',
      'Reminder' => 'pripomienkovaè',
      'Sort by' => 'triedi» podµa',
      'Order' => 'poradie',
      'up' => 'hore',
      'down' => 'dolu',

      # Template: AgentTicketMerge
      'You need to use a ticket number!' => 'Musíte pou¾íva» èíslo po¾iadavky!',
      'Ticket Merge' => 'pripojená po¾iadavka',
      'Merge to' => 'pripoji» k',
      'Your email with ticket number <OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>"."' => 'Vá¹ e-mail s èíslom po¾iadavky <OTRS_PO®IADAVKA> je pripojený k <OTRS_PRIPOJI«_K_PO®IADAVKE>',

      # Template: AgentTicketMove
      'Queue ID' => 'ID radu',
      'Move Ticket' => 'presuò po¾iadavku',
      'Previous Owner' => 'predchádzajúci majiteµ',

      # Template: AgentTicketNote
      'Add note to ticket' => 'prida» poznámku k po¾iadavke',
      'Inform Agent' => 'neformálny zástupca',
      'Optional' => 'mo¾nosti',
      'Inform involved Agents' => ,

      # Template: AgentTicketOwner
      'Change owner of ticket' => 'Zmeò po¾iadavku majiteµa.',
      'Message for new Owner' => 'správa od nového majiteµa.',

      # Template: AgentTicketPending
      'Set Pending' => 'nastavi» vybavenie',
      'Pending type' => 'typ vybavenia',
      'Pending date' => 'termín vybavenia',

      # Template: AgentTicketPhone
      'Phone call' => 'hovor',

      # Template: AgentTicketPhoneNew
      'Clear From' => 'zmaza» Od',

      # Template: AgentTicketPlain
      'Plain' => 'èistý',
      'TicketID' => 'ID po¾iadavky',
      'ArticleID' => 'ID èlánku',

      # Template: AgentTicketPrint
      'Ticket-Info' => 'info o po¾iadavkách',
      'Accounted time' => ,
      'Escalation in' => 'zvy¹ova» v',
      'Linked-Object' => 'prepojený objekt',
      'Parent-Object' => 'materský objekt',
      'Child-Object' => 'dcérsky objekt',
      'by' => 'kým',

      # Template: AgentTicketPriority
      'Change priority of ticket' => 'Zmeò prioritu po¾iadavky.',

      # Template: AgentTicketQueue
      'Tickets shown' => 'zobrazené po¾iadavky',
      'Page' => 'strana',
      'Tickets available' => 'dostupné po¾iadavky',
      'All tickets' => 'V¹etky po¾iadavky',
      'Queues' => 'Rady',
      'Ticket escalation!' => 'stupòovanie po¾iadaviek',

      # Template: AgentTicketQueueTicketView
      'Your own Ticket' => 'Va¹a vlastná po¾iadavka',
      'Compose Follow up' => 'vytvori» nasledujúcu',
      'Compose Answer' => 'vytvori» odpoveï',
      'Contact customer' => 'kontaktova» klienta',
      'Change queue' => 'zmeni» rady',

      # Template: AgentTicketQueueTicketViewLite

      # Template: AgentTicketSearch
      'Ticket Search' => 'vyhµadávanie po¾iadavky',
      'Profile' => 'profil',
      'Search-Template' => 'Vyhµadávacia ¹ablóna',
      'Created in Queue' => 'Vytvori» v rade.',
      'Result Form' => 'Výsledok z',
      'Save Search-Profile as Template?' => 'Ulo¾i» vyhµadávací profil ako ¹ablónu?',
      'Yes =>  save it with name' => 'Áno =>  ulo¾ s menom.',
      'Customer history search' => 'história klientského hµadania',
      'Customer history search (e. g. ID342425")."' => 'história klientského hµadania (napr. ID342425")',
      'No * possible!' => '¾iadna * nie je mo¾ná',

      # Template: AgentTicketSearchResult
      'Search Result' => 'výsledok hµadania ',
      'Change search options' => 'zmeò mo¾nosti hµadania',

      # Template: AgentTicketSearchResultPrint
      '"}' => '',

      # Template: AgentTicketSearchResultShort
      'sort upward' => 'triedi» hore',
      'U' => 'U',
      'sort downward' => 'triedi» dolu',
      'D' => 'D',

      # Template: AgentTicketStatusView
      'Ticket Status View' => 'zobrazenie stavu po¾iadavky',
      'Open Tickets' => 'Otvorené po¾iadavky',

      # Template: AgentTicketZoom
      'Split' => 'Rozdeli»',

      # Template: AgentTicketZoomStatus
      'Locked' => 'Zamknú»',

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
      'Print' => 'Tlaèi»',
      'Keywords' => 'Kµúèové slová',
      'Symptom' => 'Symptóm',
      'Problem' => 'Problem',
      'Solution' => 'Rie¹enie',
      'Modified' => 'Zmenený',
      'Last update' => 'Posledná aktualizácia',
      'FAQ System History' => 'FAQ história systému',
      'modified' => 'zmenený',
      'FAQ Search' => 'FAQ hµadanie',
      'Fulltext' => 'Fulltext',
      'Keyword' => 'Kµúèové slovo',
      'FAQ Search Result' => 'výsledok hµadania FAQ',
      'FAQ Overview' => 'FAQ prehµad',

      # Template: CustomerFooter
      'Powered by' => 'Powered by',

      # Template: CustomerFooterSmall

      # Template: CustomerHeader

      # Template: CustomerHeaderSmall

      # Template: CustomerLogin

      'Login' => 'Login',
      'Lost your password?' => 'Zabudli ste heslo?',
      'Request new password' => 'Po¾adova» nové heslo',
      'Create Account' => 'Vytvori» úèet',

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
      'A article should have a title!' => 'Èlánok musí ma» názov!',
      'New FAQ Article' => 'Nový FAQ èlánok.',
      'Do you really want to delete this Object?' => 'Naozaj chcete zmaza» tento objekt?',
      'System History' => 'História systému',

      # Template: FAQCategoryForm
      'Name is required!' => 'Po¾adované meno!',
      'FAQ Category' => 'Kategória FAQ',

      # Template: FAQLanguageForm
      'FAQ Language' => 'jazyk FAQ',

      # Template: Footer
      'QueueView' => 'Prehµad radu.',
      'PhoneView' => 'Prehµad hovorov',
      'Top of Page' => 'Zaèiatok strany',

      # Template: FooterSmall

      # Template: Header
      'Home' => 'Home',

      # Template: HeaderSmall

      # Template: Installer
      'Web-Installer' => 'Web-Installer',
      'accept license' => 'akceptova» licenciu',
      'don\'t accept license' => 'neakceptova» licenciu',
      'Admin-User' => 'Admin-pou¾ívateµ',
      'Admin-Password' => 'Admin-heslo',
      'your MySQL DB should have a root password! Default is empty!' => 'Va¹e MySQL DB',
      'Database-User' => 'pou¾ívateµ databázy',
      'default \'hot\'' => 'predvolený (?)',
      'DB connect host' => 'DB pripojenie host',
      'Database' => 'Databáza',
      'Create' => 'Vytvori»',
      0 => ,
      'SystemID' => 'SystemID',
      '(The identify of the system. Each ticket number and each http session id starts with this number)' => 'Identifikácia systému. Ka¾dé èíslo po¾iadavky a ka¾dá http zaèína týmto èíslo.',
      'System FQDN' => 'System FQDN',
      '(Full qualified domain name of your system)' => 'Celý názov domény vá¹ho systému',
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
      'Use utf-8 it your database supports it!' => 'Pou¾i» utf-8 na podporu Va¹ej databázy.',
      'Default Language' => 'Predvolený jazyk',
      '(Used default language)' => 'Pou¾ívaný predvolený jazyk',
      'CheckMXRecord' => 'CheckMXRecord',
      '(Checks MX recordes of used email addresses by composing an answer. Don\'t use CheckMXRecord if your OTRS machine is behinde a dial-up line $!)' => 'Pri skladani (kompozicii) odpovede skontroluje MX zaznamy pouzitych emailovych adries. ',
      'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' => 'Aby ste mohli pouzivat OTRS =>  musite zadat nasledovne: do Vasho prikazoveho riadku (terminal/shell) =>  pricom musite byt prihlaseny ako root:',
      'Restart your webserver' => 'dat "nasledovne") do Vasho prikazoveho riadku (terminal/shell) =>  pricom musite byt prihlaseny ako root:',
      'After doing so your OTRS is up and running.' => 'Ak to urobíte =>  Vá¹ OTRS je spustený.',
      'Start page' => 'Prvá strana',
      'Have a lot of fun!' => 'Veµa zábavy',
      'Your OTRS Team' => 'Vá¹ OTRS tím',

      # Template: Login

      # Template: Motd

      # Template: NoPermission
      'No Permission' => 'Nepovolené',

      # Template: Notify
      'Important' => 'Dôle¾ité',

      # Template: PrintFooter
      'URL' => 'URL',

      # Template: PrintHeader
      'printed by' => 'vytlaèený',

      # Template: Redirect

      # Template: SystemStats
      'Format' => 'Formát',

      # Template: Test
      'OTRS Test Page' => 'OTRS test strany',
      'Counter' => 'Poèítadlo',

      # Template: Warning
      # Misc
      'OTRS DB connect host' => 'OTRS DB pripojenie',
      'Create Database' => 'Vytvor databázu',
      'DB Host' => 'DB ',
      'Ticket Number Generator' => 'Generovaè èísel po¾iadaviek',
      '(Ticket identifier. Some people want to set this to e. g. \'Ticket#\',\'Call#\' or \'MyTicket#\')' => '(Identifikátor po¾iadavky. Niektorí µudia to chcú nastavi» napríklad: \'Ticket#\', \'Call#\' alebo \'MyTicket#\')',
      'In this way you can directly edit the keyring configured in Kernel/Config.pm.' => 'Týmto spôsobom mô¾ete priamo upravova» kµúèové nastavenie v Kenel/Config.',
      'Close!' => 'Zatvori»!',
      'TicketZoom' => 'Zväè¹i» po¾iadavku',
      'Don\'t forget to add a new user to groups!' => 'Nezabudnite prida» nového pou¾ívateµa do skupín!',
      'License' => 'Licencia',
      'CreateTicket' => 'Vytvor po¾iadavku',
      'OTRS DB Name' => 'OTRS DB meno',
      'System Settings' => 'Systémové nastavenia',
      'Finished' => 'Ukonèený',
      'Days' => 'Dni',
      'with' => 's',
      'DB Admin User' => 'DB admin pou¾ívateµ',
      'Change user <-> group settings' => 'Zmeò pou¾ívateµa <-> nastavenie skupiny',
      'DB Type' => 'DB typ',
      'next step' => 'daµ¹í krok',
      'My Queue' => 'Môj rad',
      'Create new database' => 'Vytvor novú databázu',
      'Delete old database' => 'Vyma¾ starú databázu',
      'Load' => 'Naèíta»',
      'OTRS DB User' => 'OTRS DB pou¾ívateµ',
      'OTRS DB Password' => 'OTRS DB heslo',
      'DB Admin Password' => 'DB heslo administrátora',
      'Drop Database' => 'vymaza» databázu',
      '(Used ticket number format)' => '(Pou¾ite èíselný formát po¾iadavky)',
      'FAQ History' => 'História FAQ',
      'Customer called' => 'Zákaznícky hovor',
      'Phone' => 'Telefón',
      'Office' => 'Kancelária',
      'CompanyTickets' => 'Firemné po¾iadavky',
      'MyTickets' => 'Moje po¾iadavky',
      'New Ticket' => 'Nová po¾iadavka',
      'Create new Ticket' => 'Vytvor novú po¾iadavku',
      'Package not correctly deployed =>  you need to deploy it again!' => 'Balík nie je správne rozmiestnený =>  musíte ho rozmiestni» e¹te raz.',
      'installed' => 'nain¹talovaný',
      'uninstalled' => 'odin¹talovaný',
    };
    # $$STOP$$
}
#--
1;
