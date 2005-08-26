# --
# Kernel/Language/pl.pm - provides pl language translation
# Copyright (C) 2001-2005 Martin Edenhofer <martin+code@otrs.org>
# Translated by Tomasz Melissa <janek at rumianek.com>
# --
# $Id: pl.pm,v 1.21 2005-08-26 15:58:46 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
package Kernel::Language::pl;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.21 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub Data {
    my $Self = shift;
    my %Param = @_;

    # $$START$$
    # Last translation file sync: Thu Jul 28 22:14:38 2005

    # possible charsets
    $Self->{Charset} = ['iso-8859-2', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Jear;)
    $Self->{DateFormat} = '%D.%M.%Y %T';
    $Self->{DateFormatLong} = '%A %D %B %T %Y';
    $Self->{DateInputFormat} = '%D.%M.%Y';
    $Self->{DateInputFormatLong} = '%D.%M.%Y - %T';

    $Self->{Translation} = {
      # Template: AAABase
      'Yes' => 'Tak',
      'No' => 'Nie',
      'yes' => 'tak',
      'no' => 'nie',
      'Off' => 'Wy³±czone',
      'off' => 'wy³±czone',
      'On' => 'W³±czone',
      'on' => 'w³±czone',
      'top' => 'góra',
      'end' => 'koniec',
      'Done' => 'Zrobione',
      'Cancel' => 'Anuluj',
      'Reset' => 'Resetuj',
      'last' => 'ostatnie',
      'before' => 'przedtem',
      'day' => 'dzieñ',
      'days' => 'dni',
      'day(s)' => 'dzieñ(dni)',
      'hour' => 'godzina',
      'hours' => 'godz.',
      'hour(s)' => '',
      'minute' => 'minuta',
      'minutes' => 'min.',
      'minute(s)' => '',
      'month' => '',
      'months' => '',
      'month(s)' => 'miesi±c(-cy)',
      'week' => '',
      'week(s)' => 'tydzieñ(tygodnie)',
      'year' => '',
      'years' => '',
      'year(s)' => 'rok(lat)',
      'wrote' => 'napisa³',
      'Message' => 'Wiadomo¶æ',
      'Error' => 'B³±d',
      'Bug Report' => 'Zg³o¶ b³±d',
      'Attention' => 'Uwaga',
      'Warning' => 'Ostrze¿enie',
      'Module' => 'Modu³',
      'Modulefile' => 'Plik Modu³u',
      'Subfunction' => 'Funkcja podrzêdna',
      'Line' => 'Linia',
      'Example' => 'Przyk³ad',
      'Examples' => 'Przyk³ady',
      'valid' => 'poprawne',
      'invalid' => 'Niepoprawne',
      'invalid-temporarily' => '',
      ' 2 minutes' => ' 2 Minuty',
      ' 5 minutes' => ' 5 Minut',
      ' 7 minutes' => ' 7 Minut',
      '10 minutes' => '10 Minut',
      '15 minutes' => '15 Minut',
      'Mr.' => '',
      'Mrs.' => '',
      'Next' => '',
      'Back' => 'Powrót',
      'Next...' => '',
      '...Back' => '',
      '-none-' => '',
      'none' => 'brak danych',
      'none!' => 'brak!',
      'none - answered' => 'brak - odpowiedziane',
      'please do not edit!' => 'nie edytowaæ!',
      'AddLink' => 'Dodaj link',
      'Link' => '',
      'Linked' => '',
      'Link (Normal)' => '',
      'Link (Parent)' => '',
      'Link (Child)' => '',
      'Normal' => 'Normalne',
      'Parent' => '',
      'Child' => '',
      'Hit' => 'Ods³ona',
      'Hits' => 'Ods³on',
      'Text' => 'Tre¶æ',
      'Lite' => 'Lekkie',
      'User' => 'U¿ytkownik',
      'Username' => 'Nazwa u¿ytkownika',
      'Language' => 'Jêzyk',
      'Languages' => 'Jêzyki',
      'Password' => 'Has³o',
      'Salutation' => 'Zwrot grzeczno¶ciowy',
      'Signature' => 'Podpis',
      'Customer' => 'Klient',
      'CustomerID' => 'ID klienta',
      'CustomerIDs' => '',
      'customer' => 'klient',
      'agent' => '',
      'system' => 'System',
      'Customer Info' => 'Informacja o kliencie',
      'go!' => 'Start!',
      'go' => 'Start',
      'All' => 'Wszystkie',
      'all' => 'wszystkie',
      'Sorry' => 'Przykro mi',
      'update!' => 'uaktualnij!',
      'update' => 'uaktualnij',
      'Update' => 'Uaktualnij',
      'submit!' => 'akceptuj!',
      'submit' => 'akceptuj',
      'Submit' => '',
      'change!' => 'Zmieñ!',
      'Change' => 'Zmieñ',
      'change' => 'zmieñ',
      'click here' => 'kliknij tutaj',
      'Comment' => 'Komentarz',
      'Valid' => 'Zastosowanie',
      'Invalid Option!' => '',
      'Invalid time!' => '',
      'Invalid date!' => '',
      'Name' => 'Nazwa',
      'Group' => 'Grupa',
      'Description' => 'Opis',
      'description' => 'opis',
      'Theme' => 'Schemat',
      'Created' => 'Utworzone',
      'Created by' => '',
      'Changed' => '',
      'Changed by' => '',
      'Search' => 'Szukaj',
      'and' => 'i',
      'between' => '',
      'Fulltext Search' => '',
      'Data' => '',
      'Options' => 'Opcje',
      'Title' => '',
      'Item' => '',
      'Delete' => 'Kasuj',
      'Edit' => 'Edytuj',
      'View' => 'Widok',
      'Number' => '',
      'System' => '',
      'Contact' => 'Kontakt',
      'Contacts' => '',
      'Export' => '',
      'Up' => '',
      'Down' => '',
      'Add' => 'Dodaj',
      'Category' => 'Kategoria',
      'Viewer' => '',
      'New message' => 'Nowa wiadomo¶æ',
      'New message!' => 'Nowa wiadomo¶æ!',
      'Please answer this ticket(s) to get back to the normal queue view!' => 'Proszê odpowiedz na to zg³oszenie, by móc powrociæ do zwyk³ego widoku kolejki zg³oszeñ!',
      'You got new message!' => 'Masz now± wiadomo¶æ!',
      'You have %s new message(s)!' => 'Masz %s nowych wiadomo¶ci!',
      'You have %s reminder ticket(s)!' => 'Masz %s przypomnieñ o zg³oszeniach!',
      'The recommended charset for your language is %s!' => 'Sugerowane kodowanie dla Twojego jêzyka to %s!',
      'Passwords dosn\'t match! Please try it again!' => '',
      'Password is already in use! Please use an other password!' => '',
      'Password is already used! Please use an other password!' => '',
      'You need to activate %s first to use it!' => '',
      'No suggestions' => 'Brak podpowiedzi',
      'Word' => 'S³owo',
      'Ignore' => 'Ignoruj',
      'replace with' => 'zamieñ z',
      'Welcome to OTRS' => 'Witamy w OTRS',
      'There is no account with that login name.' => 'Nie istnieje konto z takim loginem.',
      'Login failed! Your username or password was entered incorrectly.' => 'Logowanie niepoprawne! Twój u¿ytkownik lub has³o zosta³y wpisane niepoprawnie.',
      'Please contact your admin' => 'Skontaktuj siê z Administratorem',
      'Logout successful. Thank you for using OTRS!' => 'Wylogowanie zakoñczone! Dziêkujemy za u¿ywanie OTRS!',
      'Invalid SessionID!' => 'Niepoprawne ID Sesji!',
      'Feature not active!' => 'Funkcja nie aktywna!',
      'Take this Customer' => '',
      'Take this User' => 'U¿yj tego u¿ytkownika',
      'possible' => 'mo¿liwe',
      'reject' => 'odrzuæ',
      'Facility' => 'U³atwienie',
      'Timeover' => '',
      'Pending till' => 'Oczekuje do',
      'Don\'t work with UserID 1 (System account)! Create new users!' => 'Nie u¿ywaj u¿ytkownika z UserID 1 (Konto systemowe)! Stwórz nowych u¿ytkowników!',
      'Dispatching by email To: field.' => 'Przekazywanie na podstawie pola DO:',
      'Dispatching by selected Queue.' => 'Przekazywanie na podstawie zaznaczonej kolejki.',
      'No entry found!' => 'Nic nie odnaleziono!',
      'Session has timed out. Please log in again.' => 'Sesja wygas³a. Zaloguj siê ponownie',
      'No Permission!' => '',
      'To: (%s) replaced with database email!' => 'DO: (%s) zamienione z adresem email z bazy danych',
      'Cc: (%s) added database email!' => '',
      '(Click here to add)' => '(By dodaæ kliknij tutaj)',
      'Preview' => 'Podgl±d',
      'Added User "%s"' => '',
      'Contract' => '',
      'Online Customer: %s' => '',
      'Online Agent: %s' => '',
      'Calendar' => '',
      'File' => '',
      'Filename' => 'Nazwa pliku',
      'Type' => 'Typ',
      'Size' => '',
      'Upload' => '',
      'Directory' => '',
      'Signed' => '',
      'Sign' => '',
      'Crypted' => '',
      'Crypt' => '',

      # Template: AAAMonth
      'Jan' => 'Sty',
      'Feb' => 'Lut',
      'Mar' => '',
      'Apr' => 'Kwi',
      'May' => 'Maj',
      'Jun' => 'Cze',
      'Jul' => 'Lip',
      'Aug' => 'Sie',
      'Sep' => 'Wrz',
      'Oct' => 'Pa¼',
      'Nov' => 'Lis',
      'Dec' => 'Gru',

      # Template: AAANavBar
      'Admin-Area' => 'Administracja',
      'Agent-Area' => 'Obs³uga',
      'Ticket-Area' => '',
      'Logout' => 'Wyloguj',
      'Agent Preferences' => '',
      'Preferences' => 'Ustawienia',
      'Agent Mailbox' => '',
      'Stats' => 'Statystyki',
      'Stats-Area' => '',
      'FAQ-Area' => 'Pytania i odpowiedzi (FAQ)',
      'FAQ' => '',
      'FAQ-Search' => '',
      'FAQ-Article' => '',
      'New Article' => 'Nowy artyku³',
      'FAQ-State' => '',
      'Admin' => '',
      'A web calendar' => '',
      'WebMail' => '',
      'A web mail client' => '',
      'FileManager' => '',
      'A web file manager' => '',
      'Artefact' => '',
      'Incident' => '',
      'Advisory' => '',
      'WebWatcher' => '',
      'Customer Users' => '',
      'Customer Users <-> Groups' => '',
      'Users <-> Groups' => '',
      'Roles' => '',
      'Roles <-> Users' => '',
      'Roles <-> Groups' => '',
      'Salutations' => '',
      'Signatures' => '',
      'Email Addresses' => '',
      'Notifications' => '',
      'Category Tree' => '',
      'Admin Notification' => '',

      # Template: AAAPreferences
      'Preferences updated successfully!' => 'Ustawienia zapisano pomy¶lnie!',
      'Mail Management' => 'Zarz±dzanie poczt±',
      'Frontend' => 'Interfejs',
      'Other Options' => 'Inne opcje',
      'Change Password' => '',
      'New password' => '',
      'New password again' => '',
      'Select your QueueView refresh time.' => 'Wybierz okres od¶wierzania Podgl±du Kolejki.',
      'Select your frontend language.' => 'Wybierz jêzyk.',
      'Select your frontend Charset.' => 'Wybierz kodowanie.',
      'Select your frontend Theme.' => 'Wybierz schemat wygl±du systemu.',
      'Select your frontend QueueView.' => 'Wybierz Podgl±d Kolejki.',
      'Spelling Dictionary' => 'S³ownik pisowni',
      'Select your default spelling dictionary.' => 'Wybierz domy¶lny s³ownik.',
      'Max. shown Tickets a page in Overview.' => 'Limit pokazywanych zg³oszeñ na stronie Podsumowania',
      'Can\'t update password, passwords dosn\'t match! Please try it again!' => '',
      'Can\'t update password, invalid characters!' => '',
      'Can\'t update password, need min. 8 characters!' => '',
      'Can\'t update password, need 2 lower and 2 upper characters!' => '',
      'Can\'t update password, need min. 1 digit!' => '',
      'Can\'t update password, need min. 2 characters!' => '',
      'Password is needed!' => '',

      # Template: AAATicket
      'Lock' => 'Zablokowane',
      'Unlock' => 'Odblokuj',
      'History' => 'Historia',
      'Zoom' => 'Podgl±d',
      'Age' => 'Wiek',
      'Bounce' => 'Odbij',
      'Forward' => 'Prze¶lij dalej',
      'From' => 'Od',
      'To' => 'Do',
      'Cc' => '',
      'Bcc' => '',
      'Subject' => 'Temat',
      'Move' => 'Przesuñ',
      'Queue' => 'Kolejka',
      'Priority' => 'Priorytet',
      'State' => 'Status',
      'Compose' => 'Stwórz',
      'Pending' => 'Oczekuj±ce',
      'Owner' => 'W³a¶ciciel',
      'Owner Update' => '',
      'Sender' => 'Nadawca',
      'Article' => 'Artyku³',
      'Ticket' => 'Zg³oszenie',
      'Createtime' => 'Utworzone o',
      'plain' => 'bez formatowania',
      'eMail' => 'E-Mail',
      'email' => 'e-mail',
      'Close' => 'Zamknij',
      'Action' => 'Akcja',
      'Attachment' => 'Za³±cznik',
      'Attachments' => 'Za³±czniki',
      'This message was written in a character set other than your own.' => 'Ta wiadomo¶æ zosta³a napisana z u¿yciem kodowania znaków innego ni¿ Twój.',
      'If it is not displayed correctly,' => 'Je¶li nie jest wy¶wietlane poprawnie,',
      'This is a' => 'To jest',
      'to open it in a new window.' => 'by otworzyæ w oddzielnym oknie',
      'This is a HTML email. Click here to show it.' => 'To jest e-mail w formacie HTML. Kliknij tutaj, by go przeczytaæ.',
      'Free Fields' => '',
      'Merge' => '',
      'closed successful' => 'zamkniête z powodzeniem',
      'closed unsuccessful' => 'zamkniête bez powodzenia',
      'new' => 'nowe',
      'open' => 'otwarte',
      'closed' => '',
      'removed' => 'usuniête',
      'pending reminder' => 'oczekuj±ce przypomnienie',
      'pending auto close+' => 'oczekuj±ce na automatyczne zamkniêcie+',
      'pending auto close-' => 'oczekuj±ce na automatyczne zamkniêcie-',
      'email-external' => 'e-mail zewnêtrzny',
      'email-internal' => 'e-mail wewnêtrzny',
      'note-external' => 'Notatka zewnêtrzna',
      'note-internal' => 'Notatka wewnêtrzna',
      'note-report' => 'Notatka raportujaca',
      'phone' => 'telefon',
      'sms' => 'SMS',
      'webrequest' => 'zg³oszenie z WWW',
      'lock' => 'zablokowane',
      'unlock' => 'odblokuj',
      'very low' => 'bardzo niski',
      'low' => 'niski',
      'normal' => 'normalny',
      'high' => 'wysoki',
      'very high' => 'bardzo wysoki',
      '1 very low' => '1 bardzo niski',
      '2 low' => '2 niski',
      '3 normal' => '3 normalny',
      '4 high' => '4 wysoki',
      '5 very high' => '5 bardzo wysoki',
      'Ticket "%s" created!' => 'Zg³oszenie "%s" utworzone!',
      'Ticket Number' => '',
      'Ticket Object' => '',
      'No such Ticket Number "%s"! Can\'t link it!' => '',
      'Don\'t show closed Tickets' => 'Nie pokazuj zamkniêtych zg³oszeñ',
      'Show closed Tickets' => 'Poka¿ zamkniête zg³oszenia',
      'Email-Ticket' => '',
      'Create new Email Ticket' => '',
      'Phone-Ticket' => '',
      'Create new Phone Ticket' => '',
      'Search Tickets' => '',
      'Edit Customer Users' => '',
      'Bulk-Action' => '',
      'Bulk Actions on Tickets' => '',
      'Send Email and create a new Ticket' => '',
      'Overview of all open Tickets' => '',
      'Locked Tickets' => '',
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
      'New ticket notification' => 'Powiadomienie o nowym zg³oszeniu',
      'Send me a notification if there is a new ticket in "My Queues".' => '',
      'Follow up notification' => 'Powiadomienie o odpowiedzi',
      'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.' => 'Wy¶lij mi wiadomo¶æ, gdy klient odpowie na zg³oszenie, którego ja jestem w³a¶cicielem.',
      'Ticket lock timeout notification' => 'Powiadomienie o przekroczonym czasie blokady zg³oszenia',
      'Send me a notification if a ticket is unlocked by the system.' => 'Wy¶lij mi wiadomo¶æ, gdy zg³oszenie zostanie odblokowane przez system.',
      'Move notification' => 'Powiadomienie o przesuniêciu',
      'Send me a notification if a ticket is moved into one of "My Queues".' => '',
      'Your queue selection of your favorite queues. You also get notified about this queues via email if enabled.' => '',
      'Custom Queue' => 'Kolejka modyfikowana',
      'QueueView refresh time' => 'Okres od¶wierzania Podgl±du Kolejki',
      'Screen after new ticket' => 'Ekran po nowym zg³oszeniu',
      'Select your screen after creating a new ticket.' => 'Wybierz ekran, który poka¿e siê po rejestracji nowego zg³oszenia',
      'Closed Tickets' => 'Zamkniête zg³oszenia',
      'Show closed tickets.' => 'Poka¿ zamkniête zg³oszenia.',
      'Max. shown Tickets a page in QueueView.' => 'Limit pokazywanych zg³oszeñ na stronie Podgl±du Kolejki',
      'Responses' => 'Odpowiedzi',
      'Responses <-> Queue' => '',
      'Auto Responses' => '',
      'Auto Responses <-> Queue' => '',
      'Attachments <-> Responses' => '',
      'History::Move' => 'Ticket moved into Queue "%s" (%s) from Queue "%s" (%s).',
      'History::NewTicket' => 'New Ticket [%s] created (Q=%s;P=%s;S=%s).',
      'History::FollowUp' => 'FollowUp for [%s]. %s',
      'History::SendAutoReject' => 'AutoReject sent to "%s".',
      'History::SendAutoReply' => 'AutoReply sent to "%s".',
      'History::SendAutoFollowUp' => 'AutoFollowUp sent to "%s".',
      'History::Forward' => 'Forwarded to "%s".',
      'History::Bounce' => 'Bounced to "%s".',
      'History::SendAnswer' => 'Email sent to "%s".',
      'History::SendAgentNotification' => '"%s"-notification sent to "%s".',
      'History::SendCustomerNotification' => 'Notification sent to "%s".',
      'History::EmailAgent' => 'Email sent to customer.',
      'History::EmailCustomer' => 'Added email. %s',
      'History::PhoneCallAgent' => 'Agent called customer.',
      'History::PhoneCallCustomer' => 'Customer called us.',
      'History::AddNote' => 'Added note (%s)',
      'History::Lock' => 'Locked ticket.',
      'History::Unlock' => 'Unlocked ticket.',
      'History::TimeAccounting' => '%s time unit(s) accounted. Now total %s time unit(s).',
      'History::Remove' => '%s',
      'History::CustomerUpdate' => 'Updated: %s',
      'History::PriorityUpdate' => 'Changed priority from "%s" (%s) to "%s" (%s).',
      'History::OwnerUpdate' => 'New owner is "%s" (ID=%s).',
      'History::LoopProtection' => 'Loop-Protection! No auto-response sent to "%s".',
      'History::Misc' => '%s',
      'History::SetPendingTime' => 'Updated: %s',
      'History::StateUpdate' => 'Old: "%s" New: "%s"',
      'History::TicketFreeTextUpdate' => 'Updated: %s=%s;%s=%s;',
      'History::WebRequestCustomer' => 'Customer request via web.',
      'History::TicketLinkAdd' => 'Added link to ticket "%s".',
      'History::TicketLinkDelete' => 'Deleted link to ticket "%s".',

      # Template: AAAWeekDay
      'Sun' => 'Ndz',
      'Mon' => 'Pnd',
      'Tue' => 'Wtr',
      'Wed' => '¦rd',
      'Thu' => 'Czw',
      'Fri' => 'Ptk',
      'Sat' => 'Sob',

      # Template: AdminAttachmentForm
      'Attachment Management' => 'Konfiguracja za³±czników',

      # Template: AdminAutoResponseForm
      'Auto Response Management' => 'Konfiguracja automatycznych odpowiedzi',
      'Response' => 'Odpowied¼',
      'Auto Response From' => 'Automatyczna odpowied¼ Od',
      'Note' => 'Uwagi',
      'Useable options' => 'U¿yteczne opcje',
      'to get the first 20 character of the subject' => 'by wstawiæ pierwsze 20 znaków tematu',
      'to get the first 5 lines of the email' => 'by wstawiæ 5 pierwszych linii wiadomo¶ci',
      'to get the from line of the email' => 'by wstawiæ pole Od wiadomo¶ci',
      'to get the realname of the sender (if given)' => 'by wstawiæ prawdziwe imiê i nazwisko klienta (je¶li podano)',
      'Options of the ticket data (e. g. &lt;OTRS_TICKET_Number&gt;, &lt;OTRS_TICKET_ID&gt;, &lt;OTRS_TICKET_Queue&gt;, &lt;OTRS_TICKET_State&gt;)' => '',

      # Template: AdminCustomerUserForm
      'The message being composed has been closed.  Exiting.' => 'Wiadomo¶æ edytowana zosta³a zamkniêta.  Wychodzê.',
      'This window must be called from compose window' => 'To okno musi zostaæ wywo³ane z okna edycji',
      'Customer User Management' => 'Konfiguracja u¿ytkowników',
      'Search for' => '',
      'Result' => '',
      'Select Source (for add)' => '',
      'Source' => '¬ród³o',
      'This values are read only.' => '',
      'This values are required.' => '',
      'Customer user will be needed to have an customer histor and to to login via customer panels.' => '',

      # Template: AdminCustomerUserGroupChangeForm
      'Customer Users <-> Groups Management' => '',
      'Change %s settings' => 'Zmieñ %s ustawienia',
      'Select the user:group permissions.' => 'Wybierz prawa dostêpu dla u¿ytkownika:grupy',
      'If nothing is selected, then there are no permissions in this group (tickets will not be available for the user).' => 'Je¶li nic nie zaznaczono, wtedy u¿ytkownik nie bêdzie mia³ praw w tej grupie (zg³oszenia bêd± niedostêpne)',
      'Permission' => 'Prawo dostêpu',
      'ro' => '',
      'Read only access to the ticket in this group/queue.' => 'Prawo jedynie do odczytu zg³oszeñ w tej grupie/kolejce',
      'rw' => '',
      'Full read and write access to the tickets in this group/queue.' => 'Prawa pe³nego odczytu i zapisu zg³oszeñ w tej grupie/kolejce',

      # Template: AdminCustomerUserGroupForm

      # Template: AdminEmail
      'Message sent to' => 'Wiadomo¶æ wys³ana do',
      'Recipents' => 'Adresaci',
      'Body' => 'Tre¶æ',
      'send' => 'wy¶lij',

      # Template: AdminGenericAgent
      'GenericAgent' => '',
      'Job-List' => '',
      'Last run' => '',
      'Run Now!' => '',
      'x' => '',
      'Save Job as?' => '',
      'Is Job Valid?' => '',
      'Is Job Valid' => '',
      'Schedule' => '',
      'Fulltext-Search in Article (e. g. "Mar*in" or "Baue*")' => 'Przeszukiwanie pe³notekstowe w artykule (np. "Ja*k" lub "Rumia*)',
      '(e. g. 10*5155 or 105658*)' => '(np. 10*5155 lub 105658*)',
      '(e. g. 234321)' => '(np. 3242442)',
      'Customer User Login' => 'Login Klienta',
      '(e. g. U5150)' => '(np. U4543)',
      'Agent' => '',
      'TicketFreeText' => 'Dodatkowe informacje o zg³oszeniu',
      'Ticket Lock' => '',
      'Times' => 'Razy',
      'No time settings.' => 'Brak ustawieñ czasu',
      'Ticket created' => 'Zg³oszenie utworzone',
      'Ticket created between' => 'Zg³oszenie utworzone miêdzy',
      'New Priority' => '',
      'New Queue' => 'Nowa kolejka',
      'New State' => '',
      'New Agent' => '',
      'New Owner' => 'Nowy w³a¶ciciel',
      'New Customer' => '',
      'New Ticket Lock' => '',
      'CustomerUser' => 'Klient',
      'Add Note' => 'Dodaj notatkê',
      'CMD' => '',
      'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' => '',
      'Delete tickets' => '',
      'Warning! This tickets will be removed from the database! This tickets are lost!' => '',
      'Modules' => '',
      'Param 1' => '',
      'Param 2' => '',
      'Param 3' => '',
      'Param 4' => '',
      'Param 5' => '',
      'Param 6' => '',
      'Save' => '',

      # Template: AdminGroupForm
      'Group Management' => 'Zarz±dzanie grupami',
      'The admin group is to get in the admin area and the stats group to get stats area.' => 'Grupa Admin pozwala posiada prawa Administracji systemem. Grupa Stats umo¿liwia przegl±danie statystyk zg³oszeñ.',
      'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).' => 'Stwórz nowe grupy, by móc efektywniej zarz±dzaæ dostêpem do zg³oszeñ ró¼nych grup u¿ytkownikow (np. Serwisu, Sprzeda¿y itp...).',
      'It\'s useful for ASP solutions.' => 'Pomocne w rozwi±zanich ASP.',

      # Template: AdminLog
      'System Log' => 'Log Systemu',
      'Time' => '',

      # Template: AdminNavigationBar
      'Users' => '',
      'Groups' => 'Grupy',
      'Misc' => 'Ró¿ne',

      # Template: AdminNotificationForm
      'Notification Management' => 'Konfiguracja Powiadomieñ',
      'Notification' => '',
      'Notifications are sent to an agent or a customer.' => 'Powiadomienia s± wysy³ane do agenta obs³ugi lub klienta',
      'Config options (e. g. &lt;OTRS_CONFIG_HttpType&gt;)' => 'Opcje konfiguracyjne (np. &lt;OTRS_CONFIG_HttpType&gt;)',
      'Ticket owner options (e. g. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)' => 'Opcje dotycz±ce w³a¶ciciela zg³oszenia (np. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)',
      'Options of the current user who requested this action (e. g. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)' => 'Opcje aktualnego agenta obs³ugi (np. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)',
      'Options of the current customer user data (e. g. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)' => 'Opcje aktualnego klienta (np. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)',

      # Template: AdminPackageManager
      'Package Manager' => '',
      'Uninstall' => '',
      'Verion' => '',
      'Do you really want to uninstall this package?' => '',
      'Install' => '',
      'Package' => '',
      'Online Repository' => '',
      'Version' => '',
      'Vendor' => '',
      'Upgrade' => '',
      'Local Repository' => '',
      'Status' => '',
      'Overview' => 'Podsumowanie',
      'Download' => '',
      'Rebuild' => '',
      'Reinstall' => '',

      # Template: AdminPGPForm
      'PGP Management' => '',
      'Identifier' => '',
      'Bit' => '',
      'Key' => 'Klucz',
      'Fingerprint' => '',
      'Expires' => '',
      'In this way you can directly edit the keyring configured in SysConfig.' => '',

      # Template: AdminPOP3Form
      'POP3 Account Management' => 'Konfiguracja kont POP3',
      'Host' => '',
      'Trusted' => 'Zaufane',
      'Dispatching' => 'Przekazanie',
      'All incoming emails with one account will be dispatched in the selected queue!' => 'Wszystkie przychodz±ce na jedno konto wiadomo¶ci bêd± umieszczone w zaznacznej kolejce!',
      'If your account is trusted, the already existing x-otrs header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' => '',

      # Template: AdminPostMasterFilter
      'PostMaster Filter Management' => '',
      'Filtername' => '',
      'Match' => 'Odpowiada',
      'Header' => '',
      'Value' => 'Warto¶æ',
      'Set' => 'Ustaw',
      'Do dispatch or filter incoming emails based on email X-Headers! RegExp is also possible.' => '',
      'If you use RegExp, you also can use the matched value in () as [***] in \'Set\'.' => '',

      # Template: AdminQueueAutoResponseForm
      'Queue <-> Auto Responses Management' => '',

      # Template: AdminQueueAutoResponseTable

      # Template: AdminQueueForm
      'Queue Management' => 'Konfiguracja kolejek',
      'Sub-Queue of' => 'Kolejka podrzêdna',
      'Unlock timeout' => 'Limit czasowy odblokowania',
      '0 = no unlock' => '0 = bez odblokowania',
      'Escalation time' => 'Czas eskalacji',
      '0 = no escalation' => '0 = brak eskalacji',
      'Follow up Option' => 'Opcja Follow Up',
      'Ticket lock after a follow up' => 'Zg³oszenie zablokowane po odpowiedzi (Follow Up)',
      'Systemaddress' => 'Adres systemowy',
      'Customer Move Notify' => 'Powiadomienie klienta o przesuniêciu',
      'Customer State Notify' => 'Powiadomienie klienta o zmianie statusu',
      'Customer Owner Notify' => 'Powiadomienie klienta o zmianie w³a¶ciciela',
      'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.' => 'Je¶li agent zablokuje zg³oszenie, a nastêpnie nie odpowie na nie w ci±gu wskazanego czasu, wtedy zg³oszenie zostanie automatycznie odblokowane. Dziêki temu pozostali agenci bêd± mogli je zobaczyæ.',
      'If a ticket will not be answered in thos time, just only this ticket will be shown.' => 'Je¶li, w podanym czasie, nie zostanie udzielona odpowied¼ na zg³oszenie, wtedy tylko to zg³oszenie bêdzie widoczne w kolejce.',
      'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.' => 'Je¶li zg³oszenie by³o zamkniête, a klient przy¶le do niego kolejn± odpowied¼, wtedy zg³oszenie zostanie zablokowane w kolejce starego w³a¶ciciela.',
      'Will be the sender address of this queue for email answers.' => 'Bêdzie adresem nadawcy odpowiedzi emailowych wysy³anych z tej kolejki.',
      'The salutation for email answers.' => 'Zwrot grzeczno¶ciowy dla odpowiedzi emailowych.',
      'The signature for email answers.' => 'Podpis dla odpowiedzi emailowych.',
      'OTRS sends an notification email to the customer if the ticket is moved.' => 'System wy¶le powiadomienie do klienta, gdy zg³oszenie zostanie przesuniête do innej kolejki.',
      'OTRS sends an notification email to the customer if the ticket state has changed.' => 'System wy¶le powiadomienie do klienta, gdy zmieni sie status zg³oszenia.',
      'OTRS sends an notification email to the customer if the ticket owner has changed.' => 'System wy¶le powiadomienie do klienta, gdy zmieni sie w³a¶ciciel zg³oszenia.',

      # Template: AdminQueueResponsesChangeForm
      'Responses <-> Queue Management' => '',

      # Template: AdminQueueResponsesForm
      'Answer' => 'Odpowied¼',

      # Template: AdminResponseAttachmentChangeForm
      'Responses <-> Attachments Management' => '',

      # Template: AdminResponseAttachmentForm

      # Template: AdminResponseForm
      'Response Management' => 'Konfiguracja Odpowiedzi',
      'A response is default text to write faster answer (with default text) to customers.' => 'Odpowied¼ to domy¶lny tekst wstawiany do odpowiedzi klientowi, dziêki czemu agent mo¿e szybciej odpowiedzieæ na zg³oszenie.',
      'Don\'t forget to add a new response a queue!' => 'Nie zapomnij powi±zaæ nowej odpowiedzi z jak±¶ kolejk±!',
      'Next state' => 'Nastêpny status',
      'All Customer variables like defined in config option CustomerUser.' => '',
      'The current ticket state is' => 'Aktualny status zg³oszenia to',
      'Your email address is new' => '',

      # Template: AdminRoleForm
      'Role Management' => '',
      'Create a role and put groups in it. Then add the role to the users.' => '',
      'It\'s useful for a lot of users and groups.' => '',

      # Template: AdminRoleGroupChangeForm
      'Roles <-> Groups Management' => '',
      'move_into' => 'przesuñ do',
      'Permissions to move tickets into this group/queue.' => 'Uprawnienia do przesuwania zg³oszeñ do tej grupy/kolejki',
      'create' => 'utwórz',
      'Permissions to create tickets in this group/queue.' => 'Uprawnienia do tworzenia zg³oszeñ w tej grupie/kolejce',
      'owner' => 'w³a¶ciciel',
      'Permissions to change the ticket owner in this group/queue.' => 'Uprawnienia do zmiany w³a¶ciciela zg³oszenia w tej grupie/kolejce',
      'priority' => 'priorytet',
      'Permissions to change the ticket priority in this group/queue.' => 'Uprawnienia do zmiany priorytetu zg³oszenia w tej grupie/kolejce',

      # Template: AdminRoleGroupForm
      'Role' => '',

      # Template: AdminRoleUserChangeForm
      'Roles <-> Users Management' => '',
      'Active' => '',
      'Select the role:user relations.' => '',

      # Template: AdminRoleUserForm

      # Template: AdminSalutationForm
      'Salutation Management' => 'Konfiguracja zwrotów grzeczno¶ciowych',
      'customer realname' => 'Prawdziwe dane klienta',
      'for agent firstname' => 'dla imienia agenta',
      'for agent lastname' => 'dla nazwiska agenta',
      'for agent user id' => 'dla ID u¿ytkownika agenta',
      'for agent login' => 'dla loginu agenta',

      # Template: AdminSelectBoxForm
      'Select Box' => 'Zapytanie SQL',
      'SQL' => '',
      'Limit' => '',
      'Select Box Result' => 'Wyniki Zapytania',

      # Template: AdminSession
      'Session Management' => 'Zarz±dzanie sesjami',
      'Sessions' => 'Sesje',
      'Uniq' => 'Unikalne',
      'kill all sessions' => 'Zamknij wszystkie sesje',
      'Session' => '',
      'kill session' => 'Zamknij sesjê',

      # Template: AdminSignatureForm
      'Signature Management' => 'Konfiguracja podpisów',

      # Template: AdminSMIMEForm
      'SMIME Management' => '',
      'Add Certificate' => '',
      'Add Private Key' => '',
      'Secret' => '',
      'Hash' => '',
      'In this way you can directly edit the certification and private keys in file system.' => '',

      # Template: AdminStateForm
      'System State Management' => 'Konfiguracja statusów',
      'State Type' => 'Typ statusu',
      'Take care that you also updated the default states in you Kernel/Config.pm!' => 'Pamiêtaj, by auktualniæ równie¿ domy¶lne statusy w pliku Kernel/Config.pm !',
      'See also' => 'Zobacz tak¿e',

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
      'Content' => '',
      'New' => 'Nowe',
      'New Group' => '',
      'Group Ro' => '',
      'New Group Ro' => '',
      'NavBarName' => '',
      'Image' => '',
      'Prio' => '',
      'Block' => '',
      'NavBar' => '',
      'AccessKey' => '',

      # Template: AdminSystemAddressForm
      'System Email Addresses Management' => 'Konfiguracja adresów email Systemu',
      'Email' => 'E-Mail',
      'Realname' => 'Prawdziwe Imiê i Nazwisko',
      'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!' => 'Wszystkie wiadomo¶ci przys³ane na ten adres w polu (Do:) zostan± umieszczone w tej kolejce.',

      # Template: AdminUserForm
      'User Management' => 'Zarz±dzanie U¿ytkownikami',
      'Firstname' => 'Imiê',
      'Lastname' => 'Nazwisko',
      'User will be needed to handle tickets.' => 'U¿ytkownik bêdzie niezbêdny do obs³ugi zg³oszenia.',
      'Don\'t forget to add a new user to groups and/or roles!' => '',

      # Template: AdminUserGroupChangeForm
      'Users <-> Groups Management' => '',

      # Template: AdminUserGroupForm

      # Template: AgentBook
      'Address Book' => 'Ksi±¿ka adresowa',
      'Return to the compose screen' => 'Powróæ do ekranu edycji',
      'Discard all changes and return to the compose screen' => 'Anuluj wszystkie zmiany i powróæ do ekranu edycji',

      # Template: AgentCalendarSmall

      # Template: AgentCalendarSmallIcon

      # Template: AgentCustomerTableView

      # Template: AgentInfo
      'Info' => '',

      # Template: AgentLinkObject
      'Link Object' => '',
      'Select' => 'Zaznacz',
      'Results' => 'Wyniki',
      'Total hits' => 'Wszystkich trafieñ',
      'Site' => 'Witryna',
      'Detail' => '',

      # Template: AgentLookup
      'Lookup' => '',

      # Template: AgentNavigationBar
      'Ticket selected for bulk action!' => '',
      'You need min. one selected Ticket!' => '',

      # Template: AgentPreferencesForm

      # Template: AgentSpelling
      'Spell Checker' => 'S³ownik',
      'spelling error(s)' => 'b³êdów jêzykowych',
      'or' => 'lub',
      'Apply these changes' => 'Zastosuj te zmiany',

      # Template: AgentTicketBounce
      'A message should have a To: recipient!' => 'Wiadomo¶æ musi zawieraæ wype³nione adresem polu Do: (odbiorca)!',
      'You need a email address (e. g. customer@example.com) in To:!' => 'W polu Do: musi znale¼æ siê adres email (np. klient@przyklad.pl)!',
      'Bounce ticket' => 'Odbij zg³oszenie',
      'Bounce to' => 'Odbij do',
      'Next ticket state' => 'Nastêpny status zg³oszenia',
      'Inform sender' => 'Powiadom nadawcê',
      'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further informations.' => 'Twoja wiadomo¶æ o numerze zg³oszenia: "<OTRS_TICKET>" zosta³a przekazana na adres "<OTRS_BOUNCE_TO>" . Prosimy kontaktowaæ siê pod tym adresem we wszystkich sprawach dotycz±cych tego zg³oszenia.',
      'Send mail!' => 'Wy¶lij wiadomo¶æ!',

      # Template: AgentTicketBulk
      'A message should have a subject!' => 'Wiadomosc powinna posiadaæ temat!',
      'Ticket Bulk Action' => '',
      'Spell Check' => 'Sprawd¼ poprawno¶æ',
      'Note type' => 'Typ notatki',
      'Unlock Tickets' => '',

      # Template: AgentTicketClose
      'A message should have a body!' => 'Wiadomo¶æ powinna zawieraæ jak±¶ tre¶æ!',
      'You need to account time!' => 'Musisz zaraportowaæ czas!',
      'Close ticket' => 'Zamknij zg³oszenie',
      'Note Text' => 'Tekst notatki',
      'Close type' => 'Typ zamkniêcia',
      'Time units' => 'Jednostek czasu',
      ' (work units)' => ' (jednostek roboczych)',

      # Template: AgentTicketCompose
      'A message must be spell checked!' => 'Wiadomo¶æ musi zostaæ sprawdzona s³ownikiem!',
      'Compose answer for ticket' => 'Edytuj odpowied¼ na zg³oszenie',
      'Attach' => 'Wstaw',
      'Pending Date' => 'Termin wyznaczony',
      'for pending* states' => 'dla statusów "oczekuj±cych" z pola powy¿ej',

      # Template: AgentTicketCustomer
      'Change customer of ticket' => 'Zmieñ klienta dla zg³oszenia',
      'Set customer user and customer id of a ticket' => 'Wska¿ klienta i ID klienta dla zg³oszenia',
      'Customer User' => 'Klienci',
      'Search Customer' => 'Szukaj klienta',
      'Customer Data' => 'Dane klienta',
      'Customer history' => 'Historia klienta',
      'All customer tickets.' => 'Wszystkie zg³oszenia klienta',

      # Template: AgentTicketCustomerMessage
      'Follow up' => 'Odpowiedz',

      # Template: AgentTicketEmail
      'Compose Email' => 'Nowa wiadomo¶æ',
      'new ticket' => 'Nowe zg³oszenie',
      'Clear To' => '',
      'All Agents' => 'Wszyscy agenci',
      'Termin1' => '',

      # Template: AgentTicketForward
      'Article type' => 'Typ artyku³u',

      # Template: AgentTicketFreeText
      'Change free text of ticket' => 'Dodaj lub zmieñ dodatkowe informacje o zg³oszeniu',

      # Template: AgentTicketHistory
      'History of' => 'Historia',

      # Template: AgentTicketLocked
      'Ticket locked!' => 'Zg³oszenie zablokowane!',
      'Ticket unlock!' => 'Zg³oszenie odblokowane!',

      # Template: AgentTicketMailbox
      'Mailbox' => 'Skrzynka',
      'Tickets' => 'Zgloszenia',
      'All messages' => 'Wszystkie wiadomo¶ci',
      'New messages' => 'Nowe wiadomo¶ci',
      'Pending messages' => 'Oczekuj±ce wiadomo¶ci',
      'Reminder messages' => 'Tekst przypomnienia',
      'Reminder' => 'Przypomnienie',
      'Sort by' => 'Sortuj wed³ug',
      'Order' => 'Porz±dek',
      'up' => 'góra',
      'down' => 'dó³',

      # Template: AgentTicketMerge
      'You need to use a ticket number!' => '',
      'Ticket Merge' => '',
      'Merge to' => '',
      'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' => '',

      # Template: AgentTicketMove
      'Queue ID' => 'ID Kolejki',
      'Move Ticket' => 'Przesuñ zg³oszenie',
      'Previous Owner' => 'Poprzedni w³a¶ciciel',

      # Template: AgentTicketNote
      'Add note to ticket' => 'Dodaj notatkê do zg³oszenia',
      'Inform Agent' => '',
      'Optional' => '',
      'Inform involved Agents' => '',

      # Template: AgentTicketOwner
      'Change owner of ticket' => 'Zmieñ w³a¶ciciela zg³oszenia',
      'Message for new Owner' => 'Wiadomo¶æ do nowego w³a¶ciciela',

      # Template: AgentTicketPending
      'Set Pending' => 'Ustaw oczekiwanie',
      'Pending type' => 'Typ oczekiwania',
      'Pending date' => 'Data oczekiwania',

      # Template: AgentTicketPhone
      'Phone call' => 'Telefon',

      # Template: AgentTicketPhoneNew
      'Clear From' => 'Wyczy¶æ pole Od:',

      # Template: AgentTicketPlain
      'Plain' => 'Puste',
      'TicketID' => 'ID Zg³oszenia',
      'ArticleID' => 'ID Artyku³u',

      # Template: AgentTicketPrint
      'Ticket-Info' => '',
      'Accounted time' => 'Zaraportowany czas',
      'Escalation in' => 'Eskalowane w',
      'Linked-Object' => '',
      'Parent-Object' => '',
      'Child-Object' => '',
      'by' => 'przez',

      # Template: AgentTicketPriority
      'Change priority of ticket' => 'Zmieñ priorytet zg³oszenia',

      # Template: AgentTicketQueue
      'Tickets shown' => 'Pokazane zg³oszenia',
      'Page' => 'Strona',
      'Tickets available' => 'Dostêpne zg³oszenia',
      'All tickets' => 'Wszystkie zg³oszenia',
      'Queues' => 'Kolejki',
      'Ticket escalation!' => 'Eskalacja zg³oszenia!',

      # Template: AgentTicketQueueTicketView
      'Your own Ticket' => 'Twoje w³asne zg³oszenie',
      'Compose Follow up' => 'Napisz Odpowied¼ (Follow Up)',
      'Compose Answer' => 'Napisz odpowied¼',
      'Contact customer' => 'Skontaktuj siê z klientem',
      'Change queue' => 'Zmieñ kolejkê',

      # Template: AgentTicketQueueTicketViewLite

      # Template: AgentTicketSearch
      'Ticket Search' => 'Wyszukiwanie zg³oszenia',
      'Profile' => 'Profil',
      'Search-Template' => 'Szablon wyszukiwania',
      'Created in Queue' => '',
      'Result Form' => 'Formularz wyników',
      'Save Search-Profile as Template?' => 'Zachowaj profil wyszukiwania jako szablon',
      'Yes, save it with name' => 'Tak, zapisz to pod nazw±',
      'Customer history search' => 'Przeszukiwanie historii klienta',
      'Customer history search (e. g. "ID342425").' => 'Przeszukiwanie historii klienta (np. "ID342425").',
      'No * possible!' => 'Nie u¿ywaj znaku "*"!',

      # Template: AgentTicketSearchResult
      'Search Result' => 'Wyniki wyszukiwania',
      'Change search options' => 'Zmieñ kryteria wyszukiwania',

      # Template: AgentTicketSearchResultPrint
      '"}' => '',

      # Template: AgentTicketSearchResultShort
      'sort upward' => 'sortuj rosn±co',
      'U' => 'G',
      'sort downward' => 'sortuj malej±co',
      'D' => '',

      # Template: AgentTicketStatusView
      'Ticket Status View' => '',
      'Open Tickets' => '',

      # Template: AgentTicketZoom
      'Split' => 'Podziel',

      # Template: AgentTicketZoomStatus
      'Locked' => '',

      # Template: AgentWindowTabStart

      # Template: AgentWindowTabStop

      # Template: Copyright

      # Template: css

      # Template: customer-css

      # Template: CustomerAccept

      # Template: CustomerCalendarSmallIcon

      # Template: CustomerError
      'Traceback' => '¦led¼ wstecz',

      # Template: CustomerFAQ
      'Print' => 'Drukuj',
      'Keywords' => 'S³owa kluczowe',
      'Symptom' => 'Objawy',
      'Problem' => '',
      'Solution' => 'Rozwi±zanie',
      'Modified' => 'Zmodyfikowany',
      'Last update' => 'Ostatnia aktualizacja',
      'FAQ System History' => 'Historia FAQ',
      'modified' => '',
      'FAQ Search' => 'Szukaj w FAQ',
      'Fulltext' => 'Pe³notekstowe',
      'Keyword' => 'S³owo kluczowe',
      'FAQ Search Result' => 'Wyniki przeszukiwania FAQ',
      'FAQ Overview' => 'Podsumowanie FAQ',

      # Template: CustomerFooter
      'Powered by' => 'Oparte na',

      # Template: CustomerFooterSmall

      # Template: CustomerHeader

      # Template: CustomerHeaderSmall

      # Template: CustomerLogin
      'Login' => '',
      'Lost your password?' => 'Zapomnia³e¶ has³a?',
      'Request new password' => 'Pro¶ba o nowe has³o',
      'Create Account' => 'Utwórz konto',

      # Template: CustomerNavigationBar
      'Welcome %s' => 'Witaj %s',

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
      'Click here to report a bug!' => 'Kliknij tutaj, by zg³osiæ b³±d systemu OTRS!',

      # Template: FAQ
      'Comment (internal)' => 'Komentarz (wewnêtrzny)',
      'A article should have a title!' => '',
      'New FAQ Article' => '',
      'Do you really want to delete this Object?' => '',
      'System History' => '',

      # Template: FAQCategoryForm
      'Name is required!' => '',
      'FAQ Category' => 'Kategoria FAQ',

      # Template: FAQLanguageForm
      'FAQ Language' => 'Jêzyk FAQ',

      # Template: Footer
      'QueueView' => 'Podgl±d kolejki',
      'PhoneView' => 'Nowy telefon',
      'Top of Page' => 'Góra strony',

      # Template: FooterSmall

      # Template: Header
      'Home' => '',

      # Template: HeaderSmall

      # Template: Installer
      'Web-Installer' => 'Instalator Web',
      'accept license' => 'akceptujê Licencjê',
      'don\'t accept license' => 'nie akceptujê Licencji',
      'Admin-User' => 'Administrator',
      'Admin-Password' => '',
      'your MySQL DB should have a root password! Default is empty!' => 'Twoja baza danych MYSQL powinna mieæ ustawione jakie¶ has³o dla u¿ytkownika root. Domy¶lnie jest puste!',
      'Database-User' => '',
      'default \'hot\'' => 'domy¶lne \'hot\'',
      'DB connect host' => '',
      'Database' => '',
      'Create' => '',
      'false' => '',
      'SystemID' => 'ID Systemu',
      '(The identify of the system. Each ticket number and each http session id starts with this number)' => '(Identyfikator systemu. Wszystkie zg³oszenia oraz sesje http bêd± zaczyna³y siê od tego ci±gu)',
      'System FQDN' => 'Pe³na domena systemu FQDN',
      '(Full qualified domain name of your system)' => '(Pe³na nazwa domeny Twojego systemu FQDN)',
      'AdminEmail' => 'Email od Admina',
      '(Email of the system admin)' => '(Adres E-Mail Administratora Systemu)',
      'Organization' => 'Organizacja',
      'Log' => '',
      'LogModule' => 'Modu³ logowania',
      '(Used log backend)' => '(U¿ywany log backend)',
      'Logfile' => 'Plik logu',
      '(Logfile just needed for File-LogModule!)' => '(Logfile jest potrzebny jedynie dla modu³u File-Log!)',
      'Webfrontend' => 'Interfejs webowy',
      'Default Charset' => 'Domy¶lne kodowanie',
      'Use utf-8 it your database supports it!' => 'U¿ywaj kodowania UTF-8 je¶li pozwala Ci na to baza danych!',
      'Default Language' => 'Domy¶lny jêzyk',
      '(Used default language)' => '(Domy¶lny jêzyk)',
      'CheckMXRecord' => 'Sprawd¼ rekord MX',
      '(Checks MX recordes of used email addresses by composing an answer. Don\'t use CheckMXRecord if your OTRS machine is behinde a dial-up line $!)' => '',
      'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' => 'Musisz wpisaæ nastêpuj±ce polecenie w linii komend (Terminal/Shell).',
      'Restart your webserver' => 'Uruchom ponownie serwer WWW',
      'After doing so your OTRS is up and running.' => 'Po zakoñczeniu tych czynno¶ci Twój system OTRS bêdzie gotowy do pracy',
      'Start page' => 'Strona startowa',
      'Have a lot of fun!' => '¯yczymy dobrej zabawy!',
      'Your OTRS Team' => 'Twój Team OTRS',

      # Template: Login

      # Template: Motd

      # Template: NoPermission
      'No Permission' => 'Brak dostêpu',

      # Template: Notify
      'Important' => '',

      # Template: PrintFooter
      'URL' => '',

      # Template: PrintHeader
      'printed by' => 'wydrukowane przez',

      # Template: Redirect

      # Template: SystemStats
      'Format' => '',

      # Template: Test
      'OTRS Test Page' => 'OTRS Strona testowa',
      'Counter' => '',

      # Template: Warning
      # Misc
      'OTRS DB connect host' => 'Host bazy danych',
      'Create Database' => 'Stwórz bazê danych',
      'DB Host' => 'Host bazy danych',
      'Ticket Number Generator' => 'Generator numerów zg³oszeñ',
      '(Ticket identifier. Some people want toset this to e. g. \'Ticket#\', \'Call#\' or \'MyTicket#\')' => '(Identyfikator zg³oszenia. np. \'Ticket#\', \'Call#\' lub \'MyTicket#\')',
      'In this way you can directly edit the keyring configured in Kernel/Config.pm.' => '',
      'Ticket Hook' => 'Identyfikator zg³oszenia',
      'Close!' => 'Zamknij!',
      'TicketZoom' => 'Podgl±d zg³oszenia',
      'Don\'t forget to add a new user to groups!' => 'Nie zapomnij dodaæ u¿ytkownika do grup!',
      'License' => 'Licencja',
      'OTRS DB Name' => 'Nazwa bazy danych OTRS',
      'System Settings' => 'Ustawienia systemu',
      'Finished' => 'Zakoñczono',
      'DB Admin User' => 'U¿ytkownik administruj±cy baz± danych',
      'Change user <-> group settings' => 'Zmieñ u¿ytkownika <-> Ustawienia grupy',
      'DB Type' => 'Typ bazy danych',
      'next step' => 'Nastêpny krok',
      'Admin-Email' => 'Wiadomo¶æ od Administratora',
      'Create new database' => 'Stwórz now± bazê danych',
      'Delete old database' => 'Usuñ star± bazê danych',
      'OTRS DB User' => 'U¿ytkownik bazy danych OTRS',
      'OTRS DB Password' => 'Has³o dostêpu do bazy dla OTRS',
      'DB Admin Password' => 'Has³o Administratora bazy danych',
      'Drop Database' => 'Usuñ bazê danych',
      '(Used ticket number format)' => '(U¿ywany format numerowania zg³oszeñ)',
      'FAQ History' => 'Historia FAQ',
      'Package not correctly deployed, you need to deploy it again!' => '',
    };
    # $$STOP$$
}
# --
1;
