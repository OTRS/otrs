# --
# Kernel/Language/pl.pm - provides pl language translation
# Copyright (C) 2002-2004 Martin Edenhofer <martin at otrs.org>
# Translated by Tomasz Melissa <janek at rumianek.com>
# --
# $Id: pl.pm,v 1.8 2004-03-25 11:16:25 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
package Kernel::Language::pl;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.8 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub Data {
    my $Self = shift;
    my %Param = @_;
    my %Hash = ();

    # $$START$$
    # Last translation Tue Feb 10 01:08:12 2004 by 

    # possible charsets
    $Self->{Charset} = ['iso-8859-2', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Jear;)
    $Self->{DateFormat} = '%D.%M.%Y %T';
    $Self->{DateFormatLong} = '%A %D %B %T %Y';
    $Self->{DateInputFormat} = '%D.%M.%Y';
    $Self->{DateInputFormatLong} = '%D.%M.%Y - %T';

    %Hash = (
    # Template: AAABase
      ' 2 minutes' => ' 2 Minuty',
      ' 5 minutes' => ' 5 Minut',
      ' 7 minutes' => ' 7 Minut',
      '(Click here to add)' => '(By dodaæ kliknij tutaj)',
      '10 minutes' => '10 Minut',
      '15 minutes' => '15 Minut',
      'AddLink' => 'Dodaj link',
      'Admin-Area' => 'Administracja',
      'agent' => 'agent',
      'Agent-Area' => 'Obs³uga',
      'all' => 'wszystkie',
      'All' => 'Wszystkie',
      'Attention' => 'Uwaga',
      'before' => 'przedtem',
      'Bug Report' => 'Zg³o¶ b³±d',
      'Cancel' => 'Anuluj',
      'change' => 'zmieñ',
      'Change' => 'Zmieñ',
      'change!' => 'Zmieñ!',
      'click here' => 'kliknij tutaj',
      'Comment' => 'Komentarz',
      'Customer' => 'Klient',
      'customer' => 'klient',
      'Customer Info' => 'Informacja o kliencie',
      'day' => 'dzieñ',
      'day(s)' => 'dzieñ(dni)',
      'days' => 'dni',
      'description' => 'opis',
      'Description' => 'Opis',
      'Dispatching by email To: field.' => 'Przekazywanie na podstawie pola DO:',
      'Dispatching by selected Queue.' => 'Przekazywanie na podstawie zaznaczonej kolejki.',
      'Don\'t show closed Tickets' => 'Nie pokazuj zamkniêtych zg³oszeñ',
      'Don\'t work with UserID 1 (System account)! Create new users!' => 'Nie u¿ywaj u¿ytkownika z UserID 1 (Konto systemowe)! Stwórz nowych u¿ytkowników!',
      'Done' => 'Zrobione',
      'end' => 'koniec',
      'Error' => 'B³±d',
      'Example' => 'Przyk³ad',
      'Examples' => 'Przyk³ady',
      'Facility' => 'U³atwienie',
      'FAQ-Area' => 'Pytania i odpowiedzi (FAQ)',
      'Feature not active!' => 'Funkcja nie aktywna!',
      'go' => 'Start',
      'go!' => 'Start!',
      'Group' => 'Grupa',
      'Hit' => 'Ods³ona',
      'Hits' => 'Ods³on',
      'hour' => 'godzina',
      'hours' => 'godz.',
      'Ignore' => 'Ignoruj',
      'invalid' => 'Niepoprawne',
      'Invalid SessionID!' => 'Niepoprawne ID Sesji!',
      'Language' => 'Jêzyk',
      'Languages' => 'Jêzyki',
      'last' => 'ostatnie',
      'Line' => 'Linia',
      'Lite' => 'Lekkie',
      'Login failed! Your username or password was entered incorrectly.' => 'Logowanie niepoprawne! Twój u¿ytkownik lub has³o zosta³y wpisane niepoprawnie.',
      'Logout successful. Thank you for using OTRS!' => 'Wylogowanie zakoñczone! Dziêkujemy za u¿ywanie OTRS!',
      'Message' => 'Wiadomo¶æ',
      'minute' => 'minuta',
      'minutes' => 'min.',
      'Module' => 'Modu³',
      'Modulefile' => 'Plik Modu³u',
      'month(s)' => 'miesi±c(-cy)',
      'Name' => 'Nazwa',
      'New Article' => 'Nowy artyku³',
      'New message' => 'Nowa wiadomo¶æ',
      'New message!' => 'Nowa wiadomo¶æ!',
      'No' => 'Nie',
      'no' => 'nie',
      'No entry found!' => 'Nic nie odnaleziono!',
      'No suggestions' => 'Brak podpowiedzi',
      'none' => 'brak danych',
      'none - answered' => 'brak - odpowiedziane',
      'none!' => 'brak!',
      'Normal' => 'Normalne',
      'Off' => 'Wy³±czone',
      'off' => 'wy³±czone',
      'On' => 'W³±czone',
      'on' => 'w³±czone',
      'Password' => 'Has³o',
      'Pending till' => 'Oczekuje do',
      'Please answer this ticket(s) to get back to the normal queue view!' => 'Proszê odpowiedz na to zg³oszenie, by móc powrociæ do zwyk³ego widoku kolejki zg³oszeñ!',
      'Please contact your admin' => 'Skontaktuj siê z Administratorem',
      'please do not edit!' => 'nie edytowaæ!',
      'Please go away!' => 'Proszê zrezygnuj!',
      'possible' => 'mo¿liwe',
      'Preview' => 'Podgl±d',
      'QueueView' => 'Podgl±d kolejki',
      'reject' => 'odrzuæ',
      'replace with' => 'zamieñ z',
      'Reset' => 'Resetuj',
      'Salutation' => 'Zwrot grzeczno¶ciowy',
      'Session has timed out. Please log in again.' => 'Sesja wygas³a. Zaloguj siê ponownie',
      'Show closed Tickets' => 'Poka¿ zamkniête zg³oszenia',
      'Signature' => 'Podpis',
      'Sorry' => 'Przykro mi',
      'Stats' => 'Statystyki',
      'Subfunction' => 'Funkcja podrzêdna',
      'submit' => 'akceptuj',
      'submit!' => 'akceptuj!',
      'system' => 'System',
      'Take this User' => 'U¿yj tego u¿ytkownika',
      'Text' => 'Tre¶æ',
      'The recommended charset for your language is %s!' => 'Sugerowane kodowanie dla Twojego jêzyka to %s!',
      'Theme' => 'Schemat',
      'There is no account with that login name.' => 'Nie istnieje konto z takim loginem.',
      'Timeover' => 'Timeover',
      'To: (%s) replaced with database email!' => 'DO: (%s) zamienione z adresem email z bazy danych',
      'top' => 'góra',
      'update' => 'uaktualnij',
      'Update' => 'Uaktualnij',
      'update!' => 'uaktualnij!',
      'User' => 'U¿ytkownik',
      'Username' => 'Nazwa u¿ytkownika',
      'Valid' => 'Zastosowanie',
      'Warning' => 'Ostrze¿enie',
      'week(s)' => 'tydzieñ(tygodnie)',
      'Welcome to OTRS' => 'Witamy w OTRS',
      'Word' => 'S³owo',
      'wrote' => 'napisa³',
      'year(s)' => 'rok(lat)',
      'yes' => 'tak',
      'Yes' => 'Tak',
      'You got new message!' => 'Masz now± wiadomo¶æ!',
      'You have %s new message(s)!' => 'Masz %s nowych wiadomo¶ci!',
      'You have %s reminder ticket(s)!' => 'Masz %s przypomnieñ o zg³oszeniach!',

    # Template: AAAMonth
      'Apr' => 'Kwi',
      'Aug' => 'Sie',
      'Dec' => 'Gru',
      'Feb' => 'Lut',
      'Jan' => 'Sty',
      'Jul' => 'Lip',
      'Jun' => 'Cze',
      'Mar' => 'Mar',
      'May' => 'Maj',
      'Nov' => 'Lis',
      'Oct' => 'Pa¼',
      'Sep' => 'Wrz',

    # Template: AAAPreferences
      'Closed Tickets' => 'Zamkniête zg³oszenia',
      'Custom Queue' => 'Kolejka modyfikowana',
      'Follow up notification' => 'Powiadomienie o odpowiedzi',
      'Frontend' => 'Interfejs',
      'Mail Management' => 'Zarz±dzanie poczt±',
      'Max. shown Tickets a page in Overview.' => 'Limit pokazywanych zg³oszeñ na stronie Podsumowania',
      'Max. shown Tickets a page in QueueView.' => 'Limit pokazywanych zg³oszeñ na stronie Podgl±du Kolejki',
      'Move notification' => 'Powiadomienie o przesuniêciu',
      'New ticket notification' => 'Powiadomienie o nowym zg³oszeniu',
      'Other Options' => 'Inne opcje',
      'PhoneView' => 'Nowy telefon',
      'Preferences updated successfully!' => 'Ustawienia zapisano pomy¶lnie!',
      'QueueView refresh time' => 'Okres od¶wierzania Podgl±du Kolejki',
      'Screen after new ticket' => 'Ekran po nowym zg³oszeniu',
      'Select your default spelling dictionary.' => 'Wybierz domy¶lny s³ownik.',
      'Select your frontend Charset.' => 'Wybierz kodowanie.',
      'Select your frontend language.' => 'Wybierz jêzyk.',
      'Select your frontend QueueView.' => 'Wybierz Podgl±d Kolejki.',
      'Select your frontend Theme.' => 'Wybierz schemat wygl±du systemu.',
      'Select your QueueView refresh time.' => 'Wybierz okres od¶wierzania Podgl±du Kolejki.',
      'Select your screen after creating a new ticket.' => 'Wybierz ekran, który poka¿e siê po rejestracji nowego zg³oszenia',
      'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.' => 'Wy¶lij mi wiadomo¶æ, gdy klient odpowie na zg³oszenie, którego ja jestem w³a¶cicielem.',
      'Send me a notification if a ticket is moved into a custom queue.' => 'Wy¶lij mi wiadomo¶æ, gdy zg³oszenie zostanie przesuniête do innej kolejki.',
      'Send me a notification if a ticket is unlocked by the system.' => 'Wy¶lij mi wiadomo¶æ, gdy zg³oszenie zostanie odblokowane przez system.',
      'Send me a notification if there is a new ticket in my custom queues.' => 'Wy¶lij mi wiadomo¶æ, gdy pojawi sie nowe zg³oszenie w moich kolejkach.',
      'Show closed tickets.' => 'Poka¿ zamkniête zg³oszenia.',
      'Spelling Dictionary' => 'S³ownik pisowni',
      'Ticket lock timeout notification' => 'Powiadomienie o przekroczonym czasie blokady zg³oszenia',
      'TicketZoom' => 'Podgl±d zg³oszenia',

    # Template: AAATicket
      '1 very low' => '1 bardzo niski',
      '2 low' => '2 niski',
      '3 normal' => '3 normalny',
      '4 high' => '4 wysoki',
      '5 very high' => '5 bardzo wysoki',
      'Action' => 'Akcja',
      'Age' => 'Wiek',
      'Article' => 'Artyku³',
      'Attachment' => 'Za³±cznik',
      'Attachments' => 'Za³±czniki',
      'Bcc' => 'Bcc',
      'Bounce' => 'Odbij',
      'Cc' => 'Cc',
      'Close' => 'Zamknij',
      'closed successful' => 'zamkniête z powodzeniem',
      'closed unsuccessful' => 'zamkniête bez powodzenia',
      'Compose' => 'Stwórz',
      'Created' => 'Utworzone',
      'Createtime' => 'Utworzone o',
      'email' => 'e-mail',
      'eMail' => 'E-Mail',
      'email-external' => 'e-mail zewnêtrzny',
      'email-internal' => 'e-mail wewnêtrzny',
      'Forward' => 'Prze¶lij dalej',
      'From' => 'Od',
      'high' => 'wysoki',
      'History' => 'Historia',
      'If it is not displayed correctly,' => 'Je¶li nie jest wy¶wietlane poprawnie,',
      'lock' => 'zablokowane',
      'Lock' => 'Zablokowane',
      'low' => 'niski',
      'Move' => 'Przesuñ',
      'new' => 'nowe',
      'normal' => 'normalny',
      'note-external' => 'Notatka zewnêtrzna',
      'note-internal' => 'Notatka wewnêtrzna',
      'note-report' => 'Notatka raportujaca',
      'open' => 'otwarte',
      'Owner' => 'W³a¶ciciel',
      'Pending' => 'Oczekuj±ce',
      'pending auto close+' => 'oczekuj±ce na automatyczne zamkniêcie+',
      'pending auto close-' => 'oczekuj±ce na automatyczne zamkniêcie-',
      'pending reminder' => 'oczekuj±ce przypomnienie',
      'phone' => 'telefon',
      'plain' => 'bez formatowania',
      'Priority' => 'Priorytet',
      'Queue' => 'Kolejka',
      'removed' => 'usuniête',
      'Sender' => 'Nadawca',
      'sms' => 'SMS',
      'State' => 'Status',
      'Subject' => 'Temat',
      'This is a' => 'To jest',
      'This is a HTML email. Click here to show it.' => 'To jest e-mail w formacie HTML. Kliknij tutaj, by go przeczytaæ.',
      'This message was written in a character set other than your own.' => 'Ta wiadomo¶æ zosta³a napisana z u¿yciem kodowania znaków innego ni¿ Twój.',
      'Ticket' => 'Zg³oszenie',
      'Ticket "%s" created!' => 'Zg³oszenie "%s" utworzone!',
      'To' => 'Do',
      'to open it in a new window.' => 'by otworzyæ w oddzielnym oknie',
      'unlock' => 'odblokuj',
      'Unlock' => 'Odblokuj',
      'very high' => 'bardzo wysoki',
      'very low' => 'bardzo niski',
      'View' => 'Widok',
      'webrequest' => 'zg³oszenie z WWW',
      'Zoom' => 'Podgl±d',

    # Template: AAAWeekDay
      'Fri' => 'Ptk',
      'Mon' => 'Pnd',
      'Sat' => 'Sob',
      'Sun' => 'Ndz',
      'Thu' => 'Czw',
      'Tue' => 'Wtr',
      'Wed' => '¦rd',

    # Template: AdminAttachmentForm
      'Add' => 'Dodaj',
      'Attachment Management' => 'Konfiguracja za³±czników',

    # Template: AdminAutoResponseForm
      'Add auto response' => 'Dodaj automatyczn± odpowied¼',
      'Auto Response From' => 'Automatyczna odpowied¼ Od',
      'Auto Response Management' => 'Konfiguracja automatycznych odpowiedzi',
      'Change auto response settings' => 'Zmieñ ustawienia automatycznych odpowiedzi',
      'Note' => 'Uwagi',
      'Response' => 'Odpowied¼',
      'to get the first 20 character of the subject' => 'by wstawiæ pierwsze 20 znaków tematu',
      'to get the first 5 lines of the email' => 'by wstawiæ 5 pierwszych linii wiadomo¶ci',
      'to get the from line of the email' => 'by wstawiæ pole Od wiadomo¶ci',
      'to get the realname of the sender (if given)' => 'by wstawiæ prawdziwe imiê i nazwisko klienta (je¶li podano)',
      'to get the ticket id of the ticket' => 'by wstawiæ ID zg³oszenia',
      'to get the ticket number of the ticket' => 'by wstawiæ numer zg³oszenia',
      'Type' => 'Typ',
      'Useable options' => 'U¿yteczne opcje',

    # Template: AdminCustomerUserForm
      'Customer User Management' => 'Konfiguracja u¿ytkowników',
      'Customer user will be needed to to login via customer panels.' => 'Klient bêdzie musia³ logowaæ siê poprzez interfejs WWW klienta.',
      'Select source:' => 'Wybierz ¼ród³o:',
      'Source' => '¬ród³o',

    # Template: AdminCustomerUserGeneric

    # Template: AdminCustomerUserGroupChangeForm
      'Change %s settings' => 'Zmieñ %s ustawienia',
      'Customer User <-> Group Management' => 'Klient <-> Konfiguracja Grup',
      'Full read and write access to the tickets in this group/queue.' => 'Prawa pe³nego odczytu i zapisu zg³oszeñ w tej grupie/kolejce',
      'If nothing is selected, then there are no permissions in this group (tickets will not be available for the user).' => 'Je¶li nic nie zaznaczono, wtedy u¿ytkownik nie bêdzie mia³ praw w tej grupie (zg³oszenia bêd± niedostêpne)',
      'Permission' => 'Prawo dostêpu',
      'Read only access to the ticket in this group/queue.' => 'Prawo jedynie do odczytu zg³oszeñ w tej grupie/kolejce',
      'ro' => 'ro',
      'rw' => 'rw',
      'Select the user:group permissions.' => 'Wybierz prawa dostêpu dla u¿ytkownika:grupy',

    # Template: AdminCustomerUserGroupForm
      'Change user <-> group settings' => 'Zmieñ u¿ytkownika <-> Ustawienia grupy',

    # Template: AdminCustomerUserPreferencesGeneric

    # Template: AdminEmail
      'Admin-Email' => 'Wiadomo¶æ od Administratora',
      'Body' => 'Tre¶æ',
      'OTRS-Admin Info!' => 'Informacja od Administratora OTRS!',
      'Recipents' => 'Adresaci',
      'send' => 'wy¶lij',

    # Template: AdminEmailSent
      'Message sent to' => 'Wiadomo¶æ wys³ana do',

    # Template: AdminGroupForm
      'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).' => 'Stwórz nowe grupy, by móc efektywniej zarz±dzaæ dostêpem do zg³oszeñ ró¼nych grup u¿ytkownikow (np. Serwisu, Sprzeda¿y itp...).',
      'Group Management' => 'Zarz±dzanie grupami',
      'It\'s useful for ASP solutions.' => 'Pomocne w rozwi±zanich ASP.',
      'The admin group is to get in the admin area and the stats group to get stats area.' => 'Grupa Admin pozwala posiada prawa Administracji systemem. Grupa Stats umo¿liwia przegl±danie statystyk zg³oszeñ.',

    # Template: AdminLog
      'System Log' => 'Log Systemu',

    # Template: AdminNavigationBar
      'AdminEmail' => 'Email od Admina',
      'Attachment <-> Response' => 'Za³±cznik <-> Odpowied¼',
      'Auto Response <-> Queue' => 'AutoOdpowied¿ <-> Kolejka',
      'Auto Responses' => 'AutoOdpowiedzi',
      'Customer User' => 'Klienci',
      'Customer User <-> Groups' => 'Klienci <-> Grupy',
      'Email Addresses' => 'Adresy email',
      'Groups' => 'Grupy',
      'Logout' => 'Wyloguj',
      'Misc' => 'Ró¿ne',
      'Notifications' => 'Powiadomienia',
      'PostMaster Filter' => 'Filtr PostMaster',
      'PostMaster POP3 Account' => 'Konto pocztowe POP3 - PostMaster',
      'Responses' => 'Odpowiedzi',
      'Responses <-> Queue' => 'Odpowiedzi <-> Kolejka',
      'Select Box' => 'Zapytanie SQL',
      'Session Management' => 'Zarz±dzanie sesjami',
      'Status' => 'Status',
      'System' => 'System',
      'User <-> Groups' => 'U¿ytkownik <-> Grupy',

    # Template: AdminNotificationForm
      'Config options (e. g. &lt;OTRS_CONFIG_HttpType&gt;)' => 'Opcje konfiguracyjne (np. &lt;OTRS_CONFIG_HttpType&gt;)',
      'Notification Management' => 'Konfiguracja Powiadomieñ',
      'Notifications are sent to an agent or a customer.' => 'Powiadomienia s± wysy³ane do agenta obs³ugi lub klienta',
      'Options of the current customer user data (e. g. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)' => 'Opcje aktualnego klienta (np. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)',
      'Options of the current user who requested this action (e. g. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)' => 'Opcje aktualnego agenta obs³ugi (np. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)',
      'Ticket owner options (e. g. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)' => 'Opcje dotycz±ce w³a¶ciciela zg³oszenia (np. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)',

    # Template: AdminPOP3Form
      'All incoming emails with one account will be dispatched in the selected queue!' => 'Wszystkie przychodz±ce na jedno konto wiadomo¶ci bêd± umieszczone w zaznacznej kolejce!',
      'Dispatching' => 'Przekazanie',
      'Host' => 'Host',
      'If your account is trusted, the x-otrs header (for priority, ...) will be used!' => 'Je¶li Twoje konto jest zaufane, zostanie u¿yty nag³ówek x-otrs (dla priorytetu...)!',
      'Login' => 'Login',
      'POP3 Account Management' => 'Konfiguracja kont POP3',
      'Trusted' => 'Zaufane',

    # Template: AdminPostMasterFilterForm
      'Match' => 'Odpowiada',
      'PostMasterFilter Management' => 'Konfiguracja konta PostMaster',
      'Set' => 'Ustaw',

    # Template: AdminQueueAutoResponseForm
      'Queue <-> Auto Response Management' => 'Kolejka <-> Konfiguracja AutoOdpowiedzi',

    # Template: AdminQueueAutoResponseTable

    # Template: AdminQueueForm
      '0 = no escalation' => '0 = brak eskalacji',
      '0 = no unlock' => '0 = bez odblokowania',
      'Customer Move Notify' => 'Powiadomienie klienta o przesuniêciu',
      'Customer Owner Notify' => 'Powiadomienie klienta o zmianie w³a¶ciciela',
      'Customer State Notify' => 'Powiadomienie klienta o zmianie statusu',
      'Escalation time' => 'Czas eskalacji',
      'Follow up Option' => 'Opcja Follow Up',
      'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.' => 'Je¶li zg³oszenie by³o zamkniête, a klient przy¶le do niego kolejn± odpowied¼, wtedy zg³oszenie zostanie zablokowane w kolejce starego w³a¶ciciela.',
      'If a ticket will not be answered in thos time, just only this ticket will be shown.' => 'Je¶li, w podanym czasie, nie zostanie udzielona odpowied¼ na zg³oszenie, wtedy tylko to zg³oszenie bêdzie widoczne w kolejce.',
      'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.' => 'Je¶li agent zablokuje zg³oszenie, a nastêpnie nie odpowie na nie w ci±gu wskazanego czasu, wtedy zg³oszenie zostanie automatycznie odblokowane. Dziêki temu pozostali agenci bêd± mogli je zobaczyæ.',
      'Key' => 'Klucz',
      'OTRS sends an notification email to the customer if the ticket is moved.' => 'System wy¶le powiadomienie do klienta, gdy zg³oszenie zostanie przesuniête do innej kolejki.',
      'OTRS sends an notification email to the customer if the ticket owner has changed.' => 'System wy¶le powiadomienie do klienta, gdy zmieni sie w³a¶ciciel zg³oszenia.',
      'OTRS sends an notification email to the customer if the ticket state has changed.' => 'System wy¶le powiadomienie do klienta, gdy zmieni sie status zg³oszenia.',
      'Queue Management' => 'Konfiguracja kolejek',
      'Sub-Queue of' => 'Kolejka podrzêdna',
      'Systemaddress' => 'Adres systemowy',
      'The salutation for email answers.' => 'Zwrot grzeczno¶ciowy dla odpowiedzi emailowych.',
      'The signature for email answers.' => 'Podpis dla odpowiedzi emailowych.',
      'Ticket lock after a follow up' => 'Zg³oszenie zablokowane po odpowiedzi (Follow Up)',
      'Unlock timeout' => 'Limit czasowy odblokowania',
      'Will be the sender address of this queue for email answers.' => 'Bêdzie adresem nadawcy odpowiedzi emailowych wysy³anych z tej kolejki.',

    # Template: AdminQueueResponsesChangeForm
      'Std. Responses <-> Queue Management' => 'Standardowe odpowiedzi <-> Konfiguracja kolejek',

    # Template: AdminQueueResponsesForm
      'Answer' => 'Odpowied¼',
      'Change answer <-> queue settings' => 'Zmieñ odpowied¼ <-> Konfiguracja kolejek',

    # Template: AdminResponseAttachmentChangeForm
      'Std. Responses <-> Std. Attachment Management' => 'Standardowe odpowiedzi <-> Konfiguracja standardowych za³±czników',

    # Template: AdminResponseAttachmentForm
      'Change Response <-> Attachment settings' => 'Zmieñ odpowied¼ <-> Konfiguracja za³±czników',

    # Template: AdminResponseForm
      'A response is default text to write faster answer (with default text) to customers.' => 'Odpowied¼ to domy¶lny tekst wstawiany do odpowiedzi klientowi, dziêki czemu agent mo¿e szybciej odpowiedzieæ na zg³oszenie.',
      'Don\'t forget to add a new response a queue!' => 'Nie zapomnij powi±zaæ nowej odpowiedzi z jak±¶ kolejk±!',
      'Next state' => 'Nastêpny status',
      'Response Management' => 'Konfiguracja Odpowiedzi',
      'The current ticket state is' => 'Aktualny status zg³oszenia to',

    # Template: AdminSalutationForm
      'customer realname' => 'Prawdziwe dane klienta',
      'for agent firstname' => 'dla imienia agenta',
      'for agent lastname' => 'dla nazwiska agenta',
      'for agent login' => 'dla loginu agenta',
      'for agent user id' => 'dla ID u¿ytkownika agenta',
      'Salutation Management' => 'Konfiguracja zwrotów grzeczno¶ciowych',

    # Template: AdminSelectBoxForm
      'Max Rows' => 'Limit liczby wierszy',

    # Template: AdminSelectBoxResult
      'Limit' => 'Limit',
      'Select Box Result' => 'Wyniki Zapytania',
      'SQL' => 'SQL',

    # Template: AdminSession
      'Agent' => 'Agent',
      'kill all sessions' => 'Zamknij wszystkie sesje',
      'Overview' => 'Podsumowanie',
      'Sessions' => 'Sesje',
      'Uniq' => 'Unikalne',

    # Template: AdminSessionTable
      'kill session' => 'Zamknij sesjê',
      'SessionID' => 'ID Sesji',

    # Template: AdminSignatureForm
      'Signature Management' => 'Konfiguracja podpisów',

    # Template: AdminStateForm
      'See also' => 'Zobacz tak¿e',
      'State Type' => 'Typ statusu',
      'System State Management' => 'Konfiguracja statusów',
      'Take care that you also updated the default states in you Kernel/Config.pm!' => 'Pamiêtaj, by auktualniæ równie¿ domy¶lne statusy w pliku Kernel/Config.pm !',

    # Template: AdminSystemAddressForm
      'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!' => 'Wszystkie wiadomo¶ci przys³ane na ten adres w polu (Do:) zostan± umieszczone w tej kolejce.',
      'Email' => 'E-Mail',
      'Realname' => 'Prawdziwe Imiê i Nazwisko',
      'System Email Addresses Management' => 'Konfiguracja adresów email Systemu',

    # Template: AdminUserForm
      'Don\'t forget to add a new user to groups!' => 'Nie zapomnij dodaæ u¿ytkownika do grup!',
      'Firstname' => 'Imiê',
      'Lastname' => 'Nazwisko',
      'User Management' => 'Zarz±dzanie U¿ytkownikami',
      'User will be needed to handle tickets.' => 'U¿ytkownik bêdzie niezbêdny do obs³ugi zg³oszenia.',

    # Template: AdminUserGroupChangeForm
      'create' => 'utwórz',
      'move_into' => 'przesuñ do',
      'owner' => 'w³a¶ciciel',
      'Permissions to change the ticket owner in this group/queue.' => 'Uprawnienia do zmiany w³a¶ciciela zg³oszenia w tej grupie/kolejce',
      'Permissions to change the ticket priority in this group/queue.' => 'Uprawnienia do zmiany priorytetu zg³oszenia w tej grupie/kolejce',
      'Permissions to create tickets in this group/queue.' => 'Uprawnienia do tworzenia zg³oszeñ w tej grupie/kolejce',
      'Permissions to move tickets into this group/queue.' => 'Uprawnienia do przesuwania zg³oszeñ do tej grupy/kolejki',
      'priority' => 'priorytet',
      'User <-> Group Management' => 'U¿ytkownik <-> Zarz±dzanie grupami',

    # Template: AdminUserGroupForm

    # Template: AdminUserPreferencesGeneric

    # Template: AgentBook
      'Address Book' => 'Ksi±¿ka adresowa',
      'Discard all changes and return to the compose screen' => 'Anuluj wszystkie zmiany i powróæ do ekranu edycji',
      'Return to the compose screen' => 'Powróæ do ekranu edycji',
      'Search' => 'Szukaj',
      'The message being composed has been closed.  Exiting.' => 'Wiadomo¶æ edytowana zosta³a zamkniêta.  Wychodzê.',
      'This window must be called from compose window' => 'To okno musi zostaæ wywo³ane z okna edycji',

    # Template: AgentBounce
      'A message should have a To: recipient!' => 'Wiadomo¶æ musi zawieraæ wype³nione adresem polu Do: (odbiorca)!',
      'Bounce ticket' => 'Odbij zg³oszenie',
      'Bounce to' => 'Odbij do',
      'Inform sender' => 'Powiadom nadawcê',
      'Next ticket state' => 'Nastêpny status zg³oszenia',
      'Send mail!' => 'Wy¶lij wiadomo¶æ!',
      'You need a email address (e. g. customer@example.com) in To:!' => 'W polu Do: musi znale¼æ siê adres email (np. klient@przyklad.pl)!',
      'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further informations.' => 'Twoja wiadomo¶æ o numerze zg³oszenia: "<OTRS_TICKET>" zosta³a przekazana na adres "<OTRS_BOUNCE_TO>" . Prosimy kontaktowaæ siê pod tym adresem we wszystkich sprawach dotycz±cych tego zg³oszenia.',

    # Template: AgentClose
      ' (work units)' => ' (jednostek roboczych)',
      'A message should have a body!' => 'Wiadomo¶æ powinna zawieraæ jak±¶ tre¶æ!',
      'A message should have a subject!' => 'Wiadomosc powinna posiadaæ temat!',
      'Close ticket' => 'Zamknij zg³oszenie',
      'Close type' => 'Typ zamkniêcia',
      'Close!' => 'Zamknij!',
      'Note Text' => 'Tekst notatki',
      'Note type' => 'Typ notatki',
      'Options' => 'Opcje',
      'Spell Check' => 'Sprawd¼ poprawno¶æ',
      'Time units' => 'Jednostek czasu',
      'You need to account time!' => 'Musisz zaraportowaæ czas!',

    # Template: AgentCompose
      'A message must be spell checked!' => 'Wiadomo¶æ musi zostaæ sprawdzona s³ownikiem!',
      'Attach' => 'Wstaw',
      'Compose answer for ticket' => 'Edytuj odpowied¼ na zg³oszenie',
      'for pending* states' => 'dla statusów "oczekuj±cych" z pola powy¿ej',
      'Is the ticket answered' => 'Czy na zg³oszenie udzielono odpowiedzi',
      'Pending Date' => 'Termin wyznaczony',

    # Template: AgentCustomer
      'Back' => 'Powrót',
      'Change customer of ticket' => 'Zmieñ klienta dla zg³oszenia',
      'CustomerID' => 'ID klienta',
      'Search Customer' => 'Szukaj klienta',
      'Set customer user and customer id of a ticket' => 'Wska¿ klienta i ID klienta dla zg³oszenia',

    # Template: AgentCustomerHistory
      'All customer tickets.' => 'Wszystkie zg³oszenia klienta',
      'Customer history' => 'Historia klienta',

    # Template: AgentCustomerMessage
      'Follow up' => 'Odpowiedz',

    # Template: AgentCustomerView
      'Customer Data' => 'Dane klienta',

    # Template: AgentEmailNew
      'All Agents' => 'Wszyscy agenci',
      'Clear From' => 'Wyczy¶æ pole Od:',
      'Compose Email' => 'Nowa wiadomo¶æ',
      'Lock Ticket' => 'Zablokuj zg³oszenie',
      'new ticket' => 'Nowe zg³oszenie',

    # Template: AgentForward
      'Article type' => 'Typ artyku³u',
      'Date' => 'Data',
      'End forwarded message' => 'Koniec przekazywanej wiadomo¶ci',
      'Forward article of ticket' => 'Przeka¿ artyku³ zg³oszenia',
      'Forwarded message from' => 'Wiadomo¶æ przekazana przez',
      'Reply-To' => 'Odpowied¼ do',

    # Template: AgentFreeText
      'Change free text of ticket' => 'Dodaj lub zmieñ dodatkowe informacje o zg³oszeniu',
      'Value' => 'Warto¶æ',

    # Template: AgentHistoryForm
      'History of' => 'Historia',

    # Template: AgentMailboxNavBar
      'All messages' => 'Wszystkie wiadomo¶ci',
      'down' => 'dó³',
      'Mailbox' => 'Skrzynka',
      'New' => 'Nowe',
      'New messages' => 'Nowe wiadomo¶ci',
      'Open' => 'Otwarte',
      'Open messages' => 'Otwarte wiadomo¶ci',
      'Order' => 'Porz±dek',
      'Pending messages' => 'Oczekuj±ce wiadomo¶ci',
      'Reminder' => 'Przypomnienie',
      'Reminder messages' => 'Tekst przypomnienia',
      'Sort by' => 'Sortuj wed³ug',
      'Tickets' => 'Zgloszenia',
      'up' => 'góra',

    # Template: AgentMailboxTicket
      '"}' => '',
      '"}","14' => '',

    # Template: AgentMove
      'Move Ticket' => 'Przesuñ zg³oszenie',
      'New Owner' => 'Nowy w³a¶ciciel',
      'New Queue' => 'Nowa kolejka',
      'Previous Owner' => 'Poprzedni w³a¶ciciel',
      'Queue ID' => 'ID Kolejki',

    # Template: AgentNavigationBar
      'Locked tickets' => 'zablokowane zg³oszenia',
      'new message' => 'nowe wiadomo¶ci',
      'Preferences' => 'Ustawienia',
      'Utilities' => 'Wyszukiwanie',

    # Template: AgentNote
      'Add note to ticket' => 'Dodaj notatkê do zg³oszenia',
      'Note!' => 'Notatka!',

    # Template: AgentOwner
      'Change owner of ticket' => 'Zmieñ w³a¶ciciela zg³oszenia',
      'Message for new Owner' => 'Wiadomo¶æ do nowego w³a¶ciciela',

    # Template: AgentPending
      'Pending date' => 'Data oczekiwania',
      'Pending type' => 'Typ oczekiwania',
      'Pending!' => 'Oczekuje!',
      'Set Pending' => 'Ustaw oczekiwanie',

    # Template: AgentPhone
      'Customer called' => 'Zadzwoni³ klient',
      'Phone call' => 'Telefon',
      'Phone call at %s' => 'Telefon: %s',

    # Template: AgentPhoneNew

    # Template: AgentPlain
      'ArticleID' => 'ID Artyku³u',
      'Plain' => 'Puste',
      'TicketID' => 'ID Zg³oszenia',

    # Template: AgentPreferencesCustomQueue
      'Select your custom queues' => 'Wybierz swoje kolejki',

    # Template: AgentPreferencesForm

    # Template: AgentPreferencesGeneric

    # Template: AgentPreferencesPassword
      'Change Password' => 'Zmieñ has³o',
      'New password' => 'Wpisz nowe has³o',
      'New password again' => 'Ponownie wpisz nowe has³o',

    # Template: AgentPriority
      'Change priority of ticket' => 'Zmieñ priorytet zg³oszenia',

    # Template: AgentSpelling
      'Apply these changes' => 'Zastosuj te zmiany',
      'Spell Checker' => 'S³ownik',
      'spelling error(s)' => 'b³êdów jêzykowych',

    # Template: AgentStatusView
      'D' => 'D',
      'of' => 'z',
      'Site' => 'Witryna',
      'sort downward' => 'sortuj malej±co',
      'sort upward' => 'sortuj rosn±co',
      'Ticket Status' => 'Status zg³oszenia',
      'U' => 'G',

    # Template: AgentStatusViewTable

    # Template: AgentStatusViewTableNotAnswerd

    # Template: AgentTicketLink
      'Link' => 'Link',
      'Link to' => 'Link do',

    # Template: AgentTicketLocked
      'Ticket locked!' => 'Zg³oszenie zablokowane!',
      'Ticket unlock!' => 'Zg³oszenie odblokowane!',

    # Template: AgentTicketPrint
      'by' => 'przez',

    # Template: AgentTicketPrintHeader
      'Accounted time' => 'Zaraportowany czas',
      'Escalation in' => 'Eskalowane w',

    # Template: AgentUtilSearch
      '(e. g. 10*5155 or 105658*)' => '(np. 10*5155 lub 105658*)',
      '(e. g. 234321)' => '(np. 3242442)',
      '(e. g. U5150)' => '(np. U4543)',
      'and' => 'i',
      'Customer User Login' => 'Login Klienta',
      'Delete' => 'Kasuj',
      'Fulltext-Search in Article (e. g. "Mar*in" or "Baue*")' => 'Przeszukiwanie pe³notekstowe w artykule (np. "Ja*k" lub "Rumia*)',
      'No time settings.' => 'Brak ustawieñ czasu',
      'Profile' => 'Profil',
      'Result Form' => 'Formularz wyników',
      'Save Search-Profile as Template?' => 'Zachowaj profil wyszukiwania jako szablon',
      'Search-Template' => 'Szablon wyszukiwania',
      'Select' => 'Zaznacz',
      'Ticket created' => 'Zg³oszenie utworzone',
      'Ticket created between' => 'Zg³oszenie utworzone miêdzy',
      'Ticket Search' => 'Wyszukiwanie zg³oszenia',
      'TicketFreeText' => 'Dodatkowe informacje o zg³oszeniu',
      'Times' => 'Razy',
      'Yes, save it with name' => 'Tak, zapisz to pod nazw±',

    # Template: AgentUtilSearchByCustomerID
      'Customer history search' => 'Przeszukiwanie historii klienta',
      'Customer history search (e. g. "ID342425").' => 'Przeszukiwanie historii klienta (np. "ID342425").',
      'No * possible!' => 'Nie u¿ywaj znaku "*"!',

    # Template: AgentUtilSearchNavBar
      'Change search options' => 'Zmieñ kryteria wyszukiwania',
      'Results' => 'Wyniki',
      'Search Result' => 'Wyniki wyszukiwania',
      'Total hits' => 'Wszystkich trafieñ',

    # Template: AgentUtilSearchResult
      '"}","15' => '',

    # Template: AgentUtilSearchResultPrint

    # Template: AgentUtilSearchResultPrintTable
      '"}","30' => '',

    # Template: AgentUtilSearchResultShort

    # Template: AgentUtilSearchResultShortTable

    # Template: AgentUtilSearchResultShortTableNotAnswered

    # Template: AgentUtilTicketStatus
      'All closed tickets' => 'Wszystkie zamkniête zg³oszenia',
      'All open tickets' => 'Wszystkie otwarte zg³oszenia',
      'closed tickets' => 'zamkniête zg³oszenia',
      'open tickets' => 'otwarte zg³oszenia',
      'or' => 'lub',
      'Provides an overview of all' => 'Pozwala podejrzeæ wszystkie',
      'So you see what is going on in your system.' => 'Dziêki temu widzisz co dzieje siê w systemie.',

    # Template: AgentZoomAgentIsCustomer
      'Compose Follow up' => 'Napisz Odpowied¼ (Follow Up)',
      'Your own Ticket' => 'Twoje w³asne zg³oszenie',

    # Template: AgentZoomAnswer
      'Compose Answer' => 'Napisz odpowied¼',
      'Contact customer' => 'Skontaktuj siê z klientem',
      'phone call' => 'telefon',

    # Template: AgentZoomArticle
      'Split' => 'Podziel',

    # Template: AgentZoomBody
      'Change queue' => 'Zmieñ kolejkê',

    # Template: AgentZoomHead
      'Free Fields' => 'Dodatkowe informacje',
      'Print' => 'Drukuj',

    # Template: AgentZoomStatus
      '"}","18' => '',

    # Template: CustomerCreateAccount
      'Create Account' => 'Utwórz konto',

    # Template: CustomerError
      'Traceback' => '¦led¼ wstecz',

    # Template: CustomerFAQArticleHistory
      'Edit' => 'Edytuj',
      'FAQ History' => 'Historia FAQ',

    # Template: CustomerFAQArticlePrint
      'Category' => 'Kategoria',
      'Keywords' => 'S³owa kluczowe',
      'Last update' => 'Ostatnia aktualizacja',
      'Problem' => 'Problem',
      'Solution' => 'Rozwi±zanie',
      'Symptom' => 'Objawy',

    # Template: CustomerFAQArticleSystemHistory
      'FAQ System History' => 'Historia FAQ',

    # Template: CustomerFAQArticleView
      'FAQ Article' => 'Artyku³ FAQ',
      'Modified' => 'Zmodyfikowany',

    # Template: CustomerFAQOverview
      'FAQ Overview' => 'Podsumowanie FAQ',

    # Template: CustomerFAQSearch
      'FAQ Search' => 'Szukaj w FAQ',
      'Fulltext' => 'Pe³notekstowe',
      'Keyword' => 'S³owo kluczowe',

    # Template: CustomerFAQSearchResult
      'FAQ Search Result' => 'Wyniki przeszukiwania FAQ',

    # Template: CustomerFooter
      'Powered by' => 'Oparte na',

    # Template: CustomerHeader
      'Contact' => 'Kontakt',
      'Home' => 'Home',
      'Online-Support' => 'Serwis Online',
      'Products' => 'Produkty',
      'Support' => 'Serwis',

    # Template: CustomerLogin

    # Template: CustomerLostPassword
      'Lost your password?' => 'Zapomnia³e¶ has³a?',
      'Request new password' => 'Pro¶ba o nowe has³o',

    # Template: CustomerMessage

    # Template: CustomerMessageNew

    # Template: CustomerNavigationBar
      'Create new Ticket' => 'Utwórz nowe zg³oszenie',
      'FAQ' => 'FAQ',
      'New Ticket' => 'Nowe zg³oszenie',
      'Ticket-Overview' => 'Zgloszenie - Podgl±d',
      'Welcome %s' => 'Witaj %s',

    # Template: CustomerPreferencesForm

    # Template: CustomerPreferencesGeneric

    # Template: CustomerPreferencesPassword

    # Template: CustomerStatusView
      'My Tickets' => 'Moje zg³oszenia',

    # Template: CustomerStatusViewTable

    # Template: CustomerTicketZoom

    # Template: CustomerWarning

    # Template: Error
      'Click here to report a bug!' => 'Kliknij tutaj, by zg³osiæ b³±d systemu OTRS!',

    # Template: FAQArticleDelete
      'FAQ Delete' => 'Skasuj artyku³ FAQ',
      'You really want to delete this article?' => 'Naprawdê chcesz usun±æ ten artyku³ FAQ?',

    # Template: FAQArticleForm
      'Comment (internal)' => 'Komentarz (wewnêtrzny)',
      'Filename' => 'Nazwa pliku',
      'Short Description' => 'Krótki opis',

    # Template: FAQArticleHistory

    # Template: FAQArticlePrint

    # Template: FAQArticleSystemHistory

    # Template: FAQArticleView

    # Template: FAQCategoryForm
      'FAQ Category' => 'Kategoria FAQ',

    # Template: FAQLanguageForm
      'FAQ Language' => 'Jêzyk FAQ',

    # Template: FAQNavigationBar

    # Template: FAQOverview

    # Template: FAQSearch

    # Template: FAQSearchResult

    # Template: FAQStateForm
      'FAQ State' => 'Status FAQ',

    # Template: Footer
      'Top of Page' => 'Góra strony',

    # Template: Header

    # Template: InstallerBody
      'Create Database' => 'Stwórz bazê danych',
      'Drop Database' => 'Usuñ bazê danych',
      'Finished' => 'Zakoñczono',
      'System Settings' => 'Ustawienia systemu',
      'Web-Installer' => 'Instalator Web',

    # Template: InstallerFinish
      'Admin-User' => 'Administrator',
      'After doing so your OTRS is up and running.' => 'Po zakoñczeniu tych czynno¶ci Twój system OTRS bêdzie gotowy do pracy',
      'Have a lot of fun!' => '¯yczymy dobrej zabawy!',
      'Restart your webserver' => 'Uruchom ponownie serwer WWW',
      'Start page' => 'Strona startowa',
      'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' => 'Musisz wpisaæ nastêpuj±ce polecenie w linii komend (Terminal/Shell).',
      'Your OTRS Team' => 'Twój Team OTRS',

    # Template: InstallerLicense
      'accept license' => 'akceptujê Licencjê',
      'don\'t accept license' => 'nie akceptujê Licencji',
      'License' => 'Licencja',

    # Template: InstallerStart
      'Create new database' => 'Stwórz now± bazê danych',
      'DB Admin Password' => 'Has³o Administratora bazy danych',
      'DB Admin User' => 'U¿ytkownik administruj±cy baz± danych',
      'DB Host' => 'Host bazy danych',
      'DB Type' => 'Typ bazy danych',
      'default \'hot\'' => 'domy¶lne \'hot\'',
      'Delete old database' => 'Usuñ star± bazê danych',
      'next step' => 'Nastêpny krok',
      'OTRS DB connect host' => 'Host bazy danych',
      'OTRS DB Name' => 'Nazwa bazy danych OTRS',
      'OTRS DB Password' => 'Has³o dostêpu do bazy dla OTRS',
      'OTRS DB User' => 'U¿ytkownik bazy danych OTRS',
      'your MySQL DB should have a root password! Default is empty!' => 'Twoja baza danych MYSQL powinna mieæ ustawione jakie¶ has³o dla u¿ytkownika root. Domy¶lnie jest puste!',

    # Template: InstallerSystem
      '(Checks MX recordes of used email addresses by composing an answer. Don\'t use CheckMXRecord if your OTRS machine is behinde a dial-up line!)' => '(Sprawd¼ rekordy MX dla u¿ywanych w odpowiedziach adresów email. Nie u¿ywaj "Sprawd¼ rekord MX", gdy Twój system u¿ywa po³±czenia Dial-Up!)',
      '(Email of the system admin)' => '(Adres E-Mail Administratora Systemu)',
      '(Full qualified domain name of your system)' => '(Pe³na nazwa domeny Twojego systemu FQDN)',
      '(Logfile just needed for File-LogModule!)' => '(Logfile jest potrzebny jedynie dla modu³u File-Log!)',
      '(The identify of the system. Each ticket number and each http session id starts with this number)' => '(Identyfikator systemu. Wszystkie zg³oszenia oraz sesje http bêd± zaczyna³y siê od tego ci±gu)',
      '(Ticket identifier. Some people want toset this to e. g. \'Ticket#\', \'Call#\' or \'MyTicket#\')' => '(Identyfikator zg³oszenia. np. \'Ticket#\', \'Call#\' lub \'MyTicket#\')',
      '(Used default language)' => '(Domy¶lny jêzyk)',
      '(Used log backend)' => '(U¿ywany log backend)',
      '(Used ticket number format)' => '(U¿ywany format numerowania zg³oszeñ)',
      'CheckMXRecord' => 'Sprawd¼ rekord MX',
      'Default Charset' => 'Domy¶lne kodowanie',
      'Default Language' => 'Domy¶lny jêzyk',
      'Logfile' => 'Plik logu',
      'LogModule' => 'Modu³ logowania',
      'Organization' => 'Organizacja',
      'System FQDN' => 'Pe³na domena systemu FQDN',
      'SystemID' => 'ID Systemu',
      'Ticket Hook' => 'Identyfikator zg³oszenia',
      'Ticket Number Generator' => 'Generator numerów zg³oszeñ',
      'Use utf-8 it your database supports it!' => 'U¿ywaj kodowania UTF-8 je¶li pozwala Ci na to baza danych!',
      'Webfrontend' => 'Interfejs webowy',

    # Template: Login

    # Template: LostPassword

    # Template: NoPermission
      'No Permission' => 'Brak dostêpu',

    # Template: Notify
      'Info' => 'Info',

    # Template: PrintFooter
      'URL' => 'URL',

    # Template: PrintHeader
      'printed by' => 'wydrukowane przez',

    # Template: QueueView
      'All tickets' => 'Wszystkie zg³oszenia',
      'Page' => 'Strona',
      'Queues' => 'Kolejki',
      'Tickets available' => 'Dostêpne zg³oszenia',
      'Tickets shown' => 'Pokazane zg³oszenia',

    # Template: SystemStats
      'Graphs' => 'Wykresy',

    # Template: Test
      'OTRS Test Page' => 'OTRS Strona testowa',

    # Template: TicketEscalation
      'Ticket escalation!' => 'Eskalacja zg³oszenia!',

    # Template: TicketView

    # Template: TicketViewLite
      'Add Note' => 'Dodaj notatkê',

    # Template: Warning

    # Misc
      '(E-Mail of the system admin)' => '(Adres email Administratora)',
      'A message should have a From: recipient!' => 'Wiadomo¶æ musi zawieraæ wype³nione pole Od: !',
      'AgentFrontend' => 'Frontend Agenta',
      'Article free text' => 'Dowolny tekst artyku³u',
      'Backend' => 'Backend',
      'BackendMessage' => 'Komunikat Backend',
      'Bottom of Page' => 'Dó³ strony',
      'Charset' => 'Kodowanie',
      'Charsets' => 'Kodowania',
      'Closed' => 'Zamkniête',
      'Create' => 'Utwórz',
      'CustomerUser' => 'Klient',
      'Fulltext search' => 'Przeszukiwanie pe³notekstowe',
      'Fulltext search (e. g. "Mar*in" or "Baue*" or "martin+hallo")' => 'Przeszukiwanie pe³noteksotwe (np. "Tom*sz" lub "Jane*" lub "janek+rumianek")',
      'Handle' => 'Obs³uguj (Handle)',
      'In Queue' => 'W kolejce',
      'New state' => 'Nowy status',
      'New ticket via call.' => 'Nowe zg³oszenie telefoniczne.',
      'New user' => 'Nowy u¿ytkownik',
      'Screen after new phone ticket' => 'Ekran po nowym zg³oszeniu telefonicznym',
      'Search in' => 'Szukaj w',
      'Select your screen after creating a new ticket via PhoneView.' => 'Wybierz ekran, który poka¿e siê po stworzeniu nowego zg³oszenia telefonicznego',
      'Set customer id of a ticket' => 'Ustaw ID klienta dla zg³oszenia',
      'Show all' => 'Poka¿ wszystko',
      'System Charset Management' => 'Konfiguracja kodowania dla systemu',
      'System Language Management' => 'Konfiguracja jezyka systemu',
      'Ticket free text' => 'Dodatkowe informacje o zg³oszeniu',
      'Ticket limit:' => 'Limit zg³oszenia',
      'Time till escalation' => 'Czas do eskalacji',
      'With Priority' => 'Z priorytetem',
      'With State' => 'Ze statusem',
      'You have to be in the admin group!' => 'Musisz nale¿eæ do grupy Admin!',
      'You have to be in the stats group!' => 'Musisz nale¿eæ do grupy Stats!',
      'You need a email address (e. g. customer@example.com) in From:!' => 'Musisz wpisaæ email (np. klient@przyklad.pl) w polu Od:!',
      'auto responses set' => 'ustawione AutoOdpowiedzi',
      'invalid-temporarily' => 'Tymczasowo nieu¿ywane',
      'search' => 'szukaj',
      'search (e. g. 10*5155 or 105658*)' => 'szukaj (np. "10*5155" lub "105658*")',
      'store' => 'Store',
      'tickets' => 'Zg³oszenia',
      'valid' => 'poprawne',
    );

    # $$STOP$$

    $Self->{Translation} = \%Hash;
}
# --
1;
