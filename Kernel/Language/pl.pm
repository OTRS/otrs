# --
# Kernel/Language/pl.pm - provides pl language translation
# Copyright (C) 2002-2004 Martin Edenhofer <martin at otrs.org>
# Translated by Tomasz Melissa <janek at rumianek.com>
# --
# $Id: pl.pm,v 1.3 2004-01-20 00:02:28 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
package Kernel::Language::pl;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.3 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub Data {
    my $Self = shift;
    my %Param = @_;
    my %Hash = ();

    # $$START$$
    # Last translation Sun Apr 13 00:56:54 2003 by 

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
      '10 minutes' => '10 Minut',
      '15 minutes' => '15 Minut',
      'AddLink' => 'Dodaj link',
      'Admin-Area' => 'Administracja',
      'agent' => 'Agent',
      'all' => 'wszystkie',
      'All' => 'Wszystkie',
      'Attention' => 'Uwaga',
      'Bug Report' => 'Zglos blad',
      'Cancel' => 'Anuluj',
      'change' => 'zmien',
      'Change' => 'Zmien',
      'change!' => 'Zmien!',
      'click here' => 'kliknij tutaj',
      'Comment' => 'Komentarz',
      'Customer' => 'Klient',
      'customer' => 'klient',
      'Customer Info' => 'Klient Info',
      'day' => 'dzien',
      'days' => 'dni',
      'description' => 'opis',
      'Description' => 'Opis',
      'Dispatching by email To: field.' => 'Przekazywanie na podstawie pola DO:',
      'Dispatching by selected Queue.' => 'Przekazywanie na podstawie kolejki.',
      'Don\'t work with UserID 1 (System account)! Create new users!' => 'Nie uzywaj uzytkownika z UserID 1 (System Account)! Stworz nowych uzytkownikow!',
      'Done' => 'Zrobione',
      'end' => 'koniec',
      'Error' => 'Bald',
      'Example' => 'Przyklad',
      'Examples' => 'Przyklady',
      'Facility' => 'Facility',
      'Feature not active!' => 'Funkcja nie aktywna!',
      'go' => 'Start',
      'go!' => 'Start!',
      'Group' => 'Grupa',
      'Hit' => 'Odslona',
      'Hits' => 'Odslon',
      'hour' => 'godzin',
      'hours' => 'godziny',
      'Ignore' => 'Ignoruj',
      'invalid' => 'Nieuzywane',
      'Invalid SessionID!' => 'Niepoprawne SessionID!',
      'Language' => 'Jezyk',
      'Languages' => 'Jezyki',
      'Line' => 'Linia',
      'Lite' => 'Lite',
      'Login failed! Your username or password was entered incorrectly.' => 'Logowanie niepoprawne! Twoj uzytkownik lub haslo zostaly wpisane niepoprawnie.',
      'Logout successful. Thank you for using OTRS!' => 'Wylogowanie zakonczone! Dziekujemy za uzywanie OTRS!',
      'Message' => 'Wiadomosc',
      'minute' => 'minuta',
      'minutes' => 'minuty',
      'Module' => 'Modul',
      'Modulefile' => 'Plik Modulu',
      'Name' => 'Nazwisko',
      'New message' => 'Nowa wiadomosc',
      'New message!' => 'Nowa wiadomosc!',
      'No' => 'Nie',
      'no' => 'nie',
      'No entry found!' => 'Danych nie odnaleziono!',
      'No suggestions' => 'Brak podpowiedzi',
      'none' => 'brak danych',
      'none - answered' => 'brak - odpowiedziane',
      'none!' => 'brak!',
      'Off' => 'Wylaczone',
      'off' => 'wylaczone',
      'On' => 'Wlaczone',
      'on' => 'wlaczone',
      'Password' => 'Haslo',
      'Pending till' => 'Oczekuje do',
      'Please answer this ticket(s) to get back to the normal queue view!' => 'Prosze odpowiedz na to zgloszenie, by moc powrocic do zwyklego widoku kolejki zgloszen!',
      'Please contact your admin' => 'Skontaktuj sie z Administratorem',
      'please do not edit!' => 'nie edytowac!',
      'possible' => 'mozliwe',
      'QueueView' => 'Widok kolejki',
      'reject' => 'odrzuc',
      'replace with' => 'zamien z',
      'Reset' => 'Resetuj',
      'Salutation' => 'Zwrot grzecznosciowy',
      'Session has timed out. Please log in again.' => 'Sesja wygasla. Zaloguj sie ponownie',
      'Signature' => 'Podpis',
      'Sorry' => 'Niestety',
      'Stats' => 'Statystyki',
      'Subfunction' => 'Funkcja podrzedna',
      'submit' => 'wyslij',
      'submit!' => 'wyslij!',
      'system' => 'System',
      'Take this User' => 'Uzyj tego uzytkownika',
      'Text' => 'Tekst',
      'The recommended charset for your language is %s!' => 'Sugerowany charset dla Twojego jezyka to %s!',
      'Theme' => 'Schemat',
      'There is no account with that login name.' => 'Nie istnieje konto z takim loginem.',
      'Timeover' => 'Timeover',
      'top' => 'gora',
      'update' => 'aktualizuj',
      'update!' => 'Aktualizuj!',
      'User' => 'Uzytkownik',
      'Username' => 'Nazwa uzytkownika',
      'Valid' => 'Uzycie',
      'Warning' => 'Ostrzezenia',
      'Welcome to OTRS' => 'Witamy w OTRS',
      'Word' => 'Slowo',
      'wrote' => 'napisal',
      'yes' => 'tak',
      'Yes' => 'Tak',
      'Please go away!' => 'Prosze odejdz!',
      'You got new message!' => 'Masz nowa wiadomosc!',
      'You have %s new message(s)!' => 'Masz %s nowych wiadomosci!',
      'You have %s reminder ticket(s)!' => 'Masz %s przypomnien!',

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
      'Oct' => 'Paz',
      'Sep' => 'Wrz',

    # Template: AAAPreferences
      'Closed Tickets' => 'Zamkniete zgloszenia',
      'Custom Queue' => 'Custom kolejka',
      'Follow up notification' => 'Follow up powiadomienie',
      'Frontend' => 'Frontend',
      'Mail Management' => 'Zarzadzanie poczta',
      'Move notification' => 'Przesun powiadomienie',
      'New ticket notification' => 'Nowe powiadomienie o zgloszeniu',
      'Other Options' => 'Inne opcje',
      'Preferences updated successfully!' => 'Ustawienia zapisano pomyslnie!',
      'QueueView refresh time' => 'Czas odswierzania widoku kolejki',
      'Select your default spelling dictionary.' => 'Wybierz domyslny slownik.',
      'Select your frontend Charset.' => 'Wybierz charset dla Twojej pracy w OTRS.',
      'Select your frontend language.' => 'Wybierz jezyk.',
      'Select your frontend QueueView.' => 'Wybierz widok kolejki.',
      'Select your frontend Theme.' => 'Wybierz schemat dla OTRS.',
      'Select your QueueView refresh time.' => 'Wybierz czas odswierzania widoku kolejki.',
      'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.' => 'Wyslij mi wiadomosc gdy klient odpowie na zgloszenie, a ja jestem wlascicielem tego zgloszenia.',
      'Send me a notification if a ticket is moved into a custom queue.' => 'Wyslij mi wiadomosc gdy zgloszenie zostanie przesuniete do custom kolejki.',
      'Send me a notification if a ticket is unlocked by the system.' => 'Wyslij mi wiadomosc gdy zgloszenie zostanie odblokowane przez system.',
      'Send me a notification if there is a new ticket in my custom queues.' => 'Wyslij mi wiadomosc gdy pojawi sie nowe zglosznie w moich kolejkach.',
      'Show closed tickets.' => 'Pokaz zamkniete zgloszenia.',
      'Spelling Dictionary' => 'Slownik',
      'Ticket lock timeout notification' => 'Wiadomosc o przekroczonym czasie dla zablokowanych zgloszen',

    # Template: AAATicket
      '1 very low' => '1 bardzo niski',
      '2 low' => '2 niski',
      '3 normal' => '3 normalny',
      '4 high' => '4 wysoki',
      '5 very high' => '5 bardzo wysoki',
      'Action' => 'Akcja',
      'Age' => 'Wiek',
      'Article' => 'Artykul',
      'Attachment' => 'Zalacznik',
      'Attachments' => 'Zalaczniki',
      'Bcc' => 'Bcc',
      'Bounce' => 'Odbij',
      'Cc' => 'Cc',
      'Close' => 'Zamknij',
      'closed successful' => 'zamkniete z powodzeniem',
      'closed unsuccessful' => 'zamkniete bez powodzenia',
      'Compose' => 'Stworz',
      'Created' => 'Utworzone',
      'Createtime' => 'Utworzone o',
      'email' => 'E-Mail',
      'eMail' => 'E-Mail',
      'email-external' => 'E-Mail zewnetrzny',
      'email-internal' => 'E-Mail wewnetrzny',
      'Forward' => 'Przeslij dalej',
      'From' => 'Od',
      'high' => 'wysoki',
      'History' => 'Historia',
      'If it is not displayed correctly,' => 'Jesli nie jest wyswietlane poprawnie,',
      'lock' => 'zablokowane',
      'Lock' => 'Zablokowane',
      'low' => 'niski',
      'Move' => 'Przesun',
      'new' => 'nowe',
      'normal' => 'normalny',
      'note-external' => 'Notatka zewnetrzna',
      'note-internal' => 'Notatka wewnetrzna',
      'note-report' => 'Notatka raportujaca',
      'open' => 'otwarte',
      'Owner' => 'Wlasciciel',
      'Pending' => 'Oczekujace',
      'pending auto close+' => 'oczekujace na automatyczne zamkniecie+',
      'pending auto close-' => 'oczekujace na automatyczne zamkniecie-',
      'pending reminder' => 'przypomnienie',
      'phone' => 'Telefon',
      'plain' => 'czyste',
      'Priority' => 'Priorytet',
      'Queue' => 'Kolejka',
      'removed' => 'usuniete',
      'Sender' => 'Nadawca',
      'sms' => 'SMS',
      'State' => 'Status',
      'Subject' => 'Temat',
      'This is a' => 'To jest',
      'This is a HTML email. Click here to show it.' => 'To jest email w formacie HTML. Kliknij tutaj by go przeczytac.',
      'This message was written in a character set other than your own.' => 'Ta wiadomosc zostala napisana z uzyciem zestawu znakow innego niz Twoj.',
      'Ticket' => 'Zgloszenie',
      'To' => 'Do',
      'to open it in a new window.' => 'by otworzyc w oddzielnym oknie',
      'unlock' => 'odblokuj',
      'Unlock' => 'Odblokuj',
      'very high' => 'bardzo wysoki',
      'very low' => 'bardzo niski',
      'View' => 'Widok',
      'webrequest' => 'zgloszenie z WWW',
      'Zoom' => 'Pokaz',

    # Template: AAAWeekDay
      'Fri' => 'Ptk',
      'Mon' => 'Pnd',
      'Sat' => 'Sob',
      'Sun' => 'Ndz',
      'Thu' => 'Czw',
      'Tue' => 'Wtr',
      'Wed' => 'Srd',

    # Template: AdminAttachmentForm
      'Add attachment' => 'Dodaj zalacznik',
      'Attachment Management' => 'Zarzadzanie zalacznikami',
      'Change attachment settings' => 'Zmien ustawienia zalacznikow',

    # Template: AdminAutoResponseForm
      'Add auto response' => 'Dodaj automatyczna odpowiedz',
      'Auto Response From' => 'Automatyczna odpowiedz od',
      'Auto Response Management' => 'Zarzadzanie automatycznymi odpowiedziami',
      'Change auto response settings' => 'Zmien ustawienia automatycznych odpowiedzi',
      'Charset' => 'Charset',
      'Note' => 'Notatka',
      'Response' => 'Odpowiedz',
      'to get the first 20 character of the subject' => 'by wstawic pierwsze 20 znakow tematu',
      'to get the first 5 lines of the email' => 'by wstawic 5 pierwszych linii wiadomosci',
      'to get the from line of the email' => 'by wstawic pole Od wiadomosci',
      'to get the realname of the sender (if given)' => 'by wstawic prawdziwe imie i nazwisko klienta (jesli podano)',
      'to get the ticket id of the ticket' => 'by wstawic ID zgloszenia',
      'to get the ticket number of the ticket' => 'by wstawic numer zgloszenia',
      'Type' => 'Typ',
      'Useable options' => 'Uzyteczne opcje',

    # Template: AdminCharsetForm
      'Add charset' => 'Dodaj charset',
      'Change system charset setting' => 'Zmien ustawienia charsetu dla systemu',
      'System Charset Management' => 'Konfiguracja systemowego charsetu',

    # Template: AdminCustomerUserForm
      'Add customer user' => 'Dodaj klienta',
      'Change customer user settings' => 'Zmien ustawienia klienta',
      'Customer User Management' => 'Konfiguracja uzytkownikow',
      'Update customer user' => 'Aktualizuj klienta',
      'Customer user will be needed to to login via customer panels.' => 'Klient bedzie musial logowac sie poprzez interfejs klienta.',

    # Template: AdminCustomerUserGeneric

    # Template: AdminCustomerUserPreferencesGeneric

    # Template: AdminEmail
      'Admin-Email' => 'Email Administratora',
      'Body' => 'Tresc',
      'OTRS-Admin Info!' => 'Informacja od Administratora OTRS!',
      'Permission' => 'Pozwolenie',
      'Recipents' => 'Adresaci',
      'send' => 'Wyslij',

    # Template: AdminEmailSent
      'Message sent to' => 'Wiadomosc wyslana do',

    # Template: AdminGroupForm
      'Add group' => 'Dodaj grupe',
      'Change group settings' => 'Zmien ustawienia grupy',
      'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).' => 'Stworz nowa grupe, by moc zarzadzac dostepem dla roznych grup uzytkownikow (np. Serwis, Sprzedaz, Zamowienia itp...).',
      'Group Management' => 'Zarzadzanie grupami',
      'It\'s useful for ASP solutions.' => 'Pomocne w rozwiazanich ASP.',
      'The admin group is to get in the admin area and the stats group to get stats area.' => 'Grupa Admin pozwala dostac sie do sekcji Administracji systemu, Stats umozliwia przegladanie statystyk.',

    # Template: AdminLog
      'System Log' => 'Log Systemu',

    # Template: AdminNavigationBar
      'AdminEmail' => 'Email od Admina',
      'AgentFrontend' => 'Frontend Agenta',
      'Attachment <-> Response' => 'Zalacznik <-> Odpowiedz',
      'Auto Response <-> Queue' => 'AutoOdpowiedz <-> Kolejka',
      'Auto Responses' => 'AutoOdpowiedzi',
      'Charsets' => 'Charsety',
      'Customer User' => 'Klienci',
      'Email Addresses' => 'Adresy Email',
      'Groups' => 'Grupy',
      'Logout' => 'Wyloguj',
      'Misc' => 'Rozne',
      'POP3 Account' => 'Konto POP3',
      'Responses' => 'Odpowiedzi',
      'Responses <-> Queue' => 'Odpowiedzi <-> Kolejka',
      'Select Box' => 'Zapytanie SQL',
      'Session Management' => 'Zarzadzanie sesjami',
      'Status' => 'Status',
      'System' => 'System',
      'User <-> Groups' => 'Uzytkownik <-> Grupy',

    # Template: AdminPOP3Form
      'Add POP3 Account' => 'Dodaj konto POP3',
      'All incoming emails with one account will be dispatched in the selected queue!' => 'Wszystkie przychodzace emaile na jedno konto beda umieszczone w zaznacznej kolejce!',
      'Change POP3 Account setting' => 'Zmien ustawienia konta POP3',
      'Dispatching' => 'Przekazanie',
      'Host' => 'Host',
      'If your account is trusted, the x-otrs header (for priority, ...) will be used!' => 'Jesli Twoje konto jest zaufane, zostanie uzyty naglowek x-otrs (dla priorytetu)!',
      'Login' => 'Login',
      'POP3 Account Management' => 'Zarzadzanie kontem POP3',
      'Trusted' => 'Zaufane',

    # Template: AdminQueueAutoResponseForm
      'Queue <-> Auto Response Management' => 'Kolejka <-> Zarzadzanie AutoOdpowiedziami',

    # Template: AdminQueueAutoResponseTable

    # Template: AdminQueueForm
      '0 = no escalation' => '0 = brak eskalacji',
      '0 = no unlock' => '0 = bez odblokowania',
      'Add queue' => 'Dodaj kolejke',
      'Change queue settings' => 'Zmien ustawienia kolejki',
      'Customer Move Notify' => 'Powiadomienie klienta o przesunieciu',
      'Customer Owner Notify' => 'Powiadomienie klienta o zmianie wlasciciela',
      'Customer State Notify' => 'Powiadomienie klienta o zmianie statusu',
      'Escalation time' => 'Czas eskalacji',
      'Follow up Option' => 'Opcja Follow Up',
      'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.' => 'Jesli zgloszenie bylo zamkniete, a klient przysle na nie Follow Up, wtedy zgloszenie zostanie zablokowane w kolejce starego wlasciciela.',
      'If a ticket will not be answered in thos time, just only this ticket will be shown.' => 'Jesli nie zostanie udzielona odpowiedz na zgloszenie w podanym czasie, wtedy tylko to zgloszenie bedzie widoczne w kolejce.',
      'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.' => 'Jesli agent zablokuje zgloszenie, a nastepnie nie odpowie w ciagu wskazanego czasu, wtedy zgloszenie zostanie automtycznie odblokowane. Dzieki temu pozostali agenci beda mogli je zobaczyc.',
      'Key' => 'Klucz',
      'OTRS sends an notification email to the customer if the ticket is moved.' => 'OTRS wysle emaila z informacja do klienta gdy zgloszenie zostanie przesuniete.',
      'OTRS sends an notification email to the customer if the ticket owner has changed.' => 'OTRS wysle emaila z informacja do klienta, gdy zmieni sie wlasciciel zgloszenia.',
      'OTRS sends an notification email to the customer if the ticket state has changed.' => 'OTRS wysle emaila z informacja do klienta, gdy zmieni sie status zgloszenia.',
      'Queue Management' => 'Zarzadzanie kolejkami',
      'Sub-Queue of' => 'Kolejka podrzedna',
      'Systemaddress' => 'Adres systemowy',
      'The salutation for email answers.' => 'Zwrot grzecznosciowy dla odpowiedzi emailowych.',
      'The signature for email answers.' => 'Podpis dla odpowiedzi emailowych.',
      'Ticket lock after a follow up' => 'Zgloszenie zablokowane po odpowiedzi (FU)',
      'Unlock timeout' => 'Timeout odblokowania',
      'Will be the sender address of this queue for email answers.' => 'Bedzie adres nadawcy tej kolejki dla odpowiedzi wysylanych emailem.',

    # Template: AdminQueueResponsesChangeForm
      'Change %s settings' => 'Zmien %s ustawienia',
      'Std. Responses <-> Queue Management' => 'Standardowe odpowiedzi <-> Zarzadzanie kolejkami',

    # Template: AdminQueueResponsesForm
      'Answer' => 'Odpowiedz (answer)',
      'Change answer <-> queue settings' => 'Zmien odpowiedz (answer) <-> Ustawienia kolejki',

    # Template: AdminResponseAttachmentChangeForm
      'Std. Responses <-> Std. Attachment Management' => 'Standardowa odpowiedz <-> Standardowe zalczniki',

    # Template: AdminResponseAttachmentForm
      'Change Response <-> Attachment settings' => 'Zmien odpowiedz <-> Ustawienia zalacznikow',

    # Template: AdminResponseForm
      'A response is default text to write faster answer (with default text) to customers.' => 'Odpowiedz to domyslny tekst wstawiany do odpowiedzi klientowi, dzieki czemu agent moze szybciej odpowiedziec na zgloszenie.',
      'Add response' => 'Dodaj odpowiedz',
      'Change response settings' => 'Zmien ustawienia odpowiedzi',
      'Don\'t forget to add a new response a queue!' => 'Nie zapomnij dodac nowej odpowiedzi do kolejki!',
      'Response Management' => 'Zarzadzanie Odpowiedziami',

    # Template: AdminSalutationForm
      'Add salutation' => 'Dodaj zwrot',
      'Change salutation settings' => 'Zmien ustawienia zwrotu grzecznosciowego',
      'customer realname' => 'Prawdziwe dane klienta',
      'for agent firstname' => 'dla imienia agenta',
      'for agent lastname' => 'dla nazwiska agenta',
      'for agent login' => 'dla loginu agenta',
      'for agent user id' => 'dla ID uzytkownika agenta',
      'Salutation Management' => 'Zarzadzanie zwrotami grzecznosciowymi',

    # Template: AdminSelectBoxForm
      'Max Rows' => 'Maksymalna liczba wierszy',

    # Template: AdminSelectBoxResult
      'Limit' => '',
      'Select Box Result' => 'Wyniki Zapytania',
      'SQL' => '',

    # Template: AdminSession
      'kill all sessions' => 'Zamknij wszystkie sesje',

    # Template: AdminSessionTable
      'kill session' => 'Zamknij sesje',
      'SessionID' => 'ID Sesji',

    # Template: AdminSignatureForm
      'Add signature' => 'Dodaj podpsi',
      'Change signature settings' => 'Zmien ustawienia podpisu',
      'Signature Management' => 'Zarzadzanie podpisami',

    # Template: AdminStateForm
      'Add state' => 'Dodaj status',
      'Change system state setting' => 'Zmien ustawienia statusu',
      'State Type' => 'Typ statusu',
      'System State Management' => 'Zarzadzanie statusami',

    # Template: AdminSystemAddressForm
      'Add system address' => 'Dodaj adres email systemu',
      'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!' => 'Wszystkie wiadomosci przyslane na ten adres w polu (Do:) zostana umieszczone w tej kolejce.',
      'Change system address setting' => 'Zmien adres email systemu',
      'Email' => 'E-Mail',
      'Realname' => 'Prawdziwe Imie i Nazwisko',
      'System Email Addresses Management' => 'Zarzadzanie adresem email systemu',

    # Template: AdminUserForm
      'Add user' => 'Dodaj uzytkownika',
      'Change user settings' => 'Zmien ustawienia uzytkownika',
      'Don\'t forget to add a new user to groups!' => 'Nie zapomnij dodac uzytkownika do grup!',
      'Firstname' => 'Imie',
      'Lastname' => 'Nazwisko',
      'User Management' => 'Zarzadzanie Uzytkownikami',
      'User will be needed to handle tickets.' => 'Uzytkownik bedzie niezbedny do obslugi zgloszenia.',

    # Template: AdminUserGroupChangeForm
      'Change  settings' => 'Zmien ustawienia',
      'User <-> Group Management' => 'Uzytkownik <-> Zarzadzanie grupami',

    # Template: AdminUserGroupForm
      'Change user <-> group settings' => 'Zmien uzytkownika <-> ustawienia grupy',

    # Template: AdminUserPreferencesGeneric

    # Template: AgentBounce
      'A message should have a To: recipient!' => 'Wiadomosc musi zawierac informacje w polu Do: (odbiorca)!',
      'Bounce ticket' => 'Odbij zgloszenie',
      'Bounce to' => 'Odbij do',
      'Inform sender' => 'Powiadom nadawce',
      'Next ticket state' => 'Nastepny status zgloszenia',
      'Send mail!' => 'Wiadomosc wyslana!',
      'You need a email address (e. g. customer@example.com) in To:!' => 'Im An-Feld wird eine E-Mail-Adresse (z.B. kunde@beispiel.de) benötigt!',
      'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further informations.' => 'Twoja wiadomosc o zgloszeniu numer: "<OTRS_TICKET>" zostala przekazana na adres "<OTRS_BOUNCE_TO>" . Prosimy kontaktowac sie pod tym adresem we wszystkich sprawach dotyczacych tego zgloszenia.',

    # Template: AgentClose
      ' (work units)' => ' (jednostek roboczych)',
      'A message should have a subject!' => 'Wiadomosc musi posiadac temat!',
      'Close ticket' => 'Zamknij zgloszenie',
      'Close type' => 'Typ zamkniecia',
      'Close!' => 'Zamknij!',
      'Note Text' => 'Tekst notatki',
      'Note type' => 'Typ notatki',
      'Options' => 'Opcje',
      'Spell Check' => 'Sprawdz poprawnosc',
      'Time units' => 'Jednostek czasu',
      'You need to account time!' => 'Musisz zaraportowac czas!',

    # Template: AgentCompose
      'A message must be spell checked!' => 'Wiadomosc musi zostac sprawdzona slownikiem!',
      'Attach' => 'Dolacz',
      'Compose answer for ticket' => 'Edytuj odpowiedz na zgloszenie',
      'for pending* states' => 'oczekujace* statusy',
      'Is the ticket answered' => 'Czy zgloszenie zawiera odpowiedz',
      'Pending Date' => 'Data oczekiwania',

    # Template: AgentCustomer
      'Back' => 'Pworot',
      'Change customer of ticket' => 'Zmien klienta dla zgloszenia',
      'CustomerID' => 'ID klienta#',
      'Search Customer' => 'Szukaj klienta',
      'Set customer user and customer id of a ticket' => 'Wskaz klienta i ID klienta dla zgloszenia',

    # Template: AgentCustomerHistory
      'Customer history' => 'Historia klienta',

    # Template: AgentCustomerHistoryTable

    # Template: AgentCustomerMessage
      'Follow up' => '',
      'Next state' => 'Nastepny status',

    # Template: AgentCustomerView
      'Customer Data' => 'Data klienta',

    # Template: AgentForward
      'Article type' => 'Typ artykulu',
      'Date' => 'Data',
      'End forwarded message' => 'Koniec przekazanej wiadomosci',
      'Forward article of ticket' => 'Przekaz artykul zgloszenia',
      'Forwarded message from' => 'Wiadomosc przekazana przez',
      'Reply-To' => 'Odpowiedz do',

    # Template: AgentFreeText
      'Change free text of ticket' => 'Zmien free text zgloszenia',
      'Value' => 'Wartosc',

    # Template: AgentHistoryForm
      'History of' => 'Historia',

    # Template: AgentMailboxNavBar
      'All messages' => 'Wszysktie wiadomosci',
      'down' => 'dol',
      'Mailbox' => 'Skrzynka',
      'New' => 'Nowe',
      'New messages' => 'Nowe wiadomosci',
      'Open' => 'Otwarte',
      'Open messages' => 'Otwarte wiadomosci',
      'Order' => 'Porzadek',
      'Pending messages' => 'Oczekujace wiadomosci',
      'Reminder' => 'Przypomnienie',
      'Reminder messages' => 'Tekst prztpomnienia',
      'Sort by' => 'Pososrtowano wedlug',
      'Tickets' => 'Zgloszenia',
      'up' => 'gora',

    # Template: AgentMailboxTicket

    # Template: AgentMove
      'Move Ticket' => 'Przesun zgloszenie',
      'New Queue' => 'Nowa kolejka',
      'New user' => 'Nowy uzytkownik',

    # Template: AgentNavigationBar
      'Locked tickets' => 'zablokowane zgloszenia',
      'new message' => 'nowa wiadomosc',
      'PhoneView' => 'Widok telefonow',
      'Preferences' => 'Ustawienia',
      'Utilities' => 'Narzedzia',

    # Template: AgentNote
      'Add note to ticket' => 'Dodaj notatke do zgloszenia',
      'Note!' => 'Notatka!',

    # Template: AgentOwner
      'Change owner of ticket' => 'Zmien wlasciciela zgloszenia',
      'Message for new Owner' => 'Wiadomosc do nowego wlasciciela',

    # Template: AgentPending
      'Pending date' => 'Data oczekiwania',
      'Pending type' => 'Typ oczekiwania',
      'Pending!' => 'Oczekuje!',
      'Set Pending' => 'Ustaw oczekiwanie',

    # Template: AgentPhone
      'Customer called' => 'Zadzwonil klient',
      'Phone call' => 'Telefon',
      'Phone call at %s' => 'Telefon o %s',

    # Template: AgentPhoneNew
      'Clear From' => 'Wyczysc pole Od:',
      'create' => 'utworz',
      'new ticket' => 'nowe zgloszenie',

    # Template: AgentPlain
      'ArticleID' => 'ID Artykulu',
      'Plain' => 'Puste',
      'TicketID' => 'ID Zgloszenia',

    # Template: AgentPreferencesCustomQueue
      'Select your custom queues' => 'Wybierz swoje kolejki',

    # Template: AgentPreferencesForm

    # Template: AgentPreferencesGeneric

    # Template: AgentPreferencesPassword
      'Change Password' => 'Zmien haslo',
      'New password' => 'Wpisz nowe haslo',
      'New password again' => 'Jeszcze raz wpisz nowe haslo',

    # Template: AgentPriority
      'Change priority of ticket' => 'Zmien priorytet zgloszenia',
      'New state' => 'Nowy status',

    # Template: AgentSpelling
      'Apply these changes' => 'Zastosuj te zmiany',
      'Discard all changes and return to the compose screen' => 'Anuluj wszystkie zmiany i powroc do ekranu edycji',
      'Return to the compose screen' => 'Powroc do ekranu edycji',
      'Spell Checker' => 'Slownik',
      'spelling error(s)' => 'bledow',
      'The message being composed has been closed.  Exiting.' => 'Wiadomosc edytowana zostala zamknieta.  Wychodze.',
      'This window must be called from compose window' => 'To okno musi byc wywolane z okna edycji',

    # Template: AgentStatusView
      'D' => 'Dol',
      'of' => 'z',
      'Site' => 'Strona',
      'sort downward' => 'sortuj malejaco',
      'sort upward' => 'sortuj rosnaco',
      'Ticket Status' => 'Status zgloszenia',
      'U' => 'Gora',

    # Template: AgentStatusViewTable

    # Template: AgentStatusViewTableNotAnswerd

    # Template: AgentTicketLocked
      'Ticket locked!' => 'Zgloszenie zablokowane!',
      'Ticket unlock!' => 'Zgloszenie odblokowane!',

    # Template: AgentTicketPrint
      'by' => 'przez',

    # Template: AgentTicketPrintHeader
      'Accounted time' => 'Zarachowany czas',
      'Escalation in' => 'Eskalowane w',
      'printed by' => 'wydrukowane przez',

    # Template: AgentUtilSearch
      'Article free text' => 'Dowolny tekst artykulu',
      'Fulltext search (e. g. "Mar*in" or "Baue*" or "martin+hallo")' => 'Przeszukiwanie pelnoteksotwe (np. "Tom*sz" lub "Jane*" lub "janek+rumianek")',
      'search' => 'szukaj',
      'search (e. g. 10*5155 or 105658*)' => 'szukaj (np. "10*5155" lub "105658*")',
      'Ticket free text' => 'Dowolny tekst zgloszenia',
      'Ticket Search' => 'Wyszukiwanie zgloszenia',

    # Template: AgentUtilSearchByCustomerID
      'Customer history search' => 'Przeszukiwanie historii klienta',
      'Customer history search (e. g. "ID342425").' => 'Przeszukiwanie historii klienta (np. "ID342425").',
      'No * possible!' => 'Nie uzywaj "*"!',

    # Template: AgentUtilSearchNavBar
      'Results' => 'Wyniki',
      'Total hits' => 'Wszystkie odslony',

    # Template: AgentUtilSearchResult

    # Template: AgentUtilTicketStatus
      'All closed tickets' => 'Wszystkie zamkniete zgloszenia',
      'All open tickets' => 'Wszystkie otwarte zgloszenia',
      'closed tickets' => 'zamkniete zgloszenia',
      'open tickets' => 'otwarte zgloszenia',
      'or' => 'lub',
      'Provides an overview of all' => 'Pozwala obejrzec wszystkie',
      'So you see what is going on in your system.' => 'Dzieki temu widzisz co dzieje sie w systemie.',
      'Closed' => 'Zamkniete',

    # Template: AgentZoomAgentIsCustomer
      'Compose Follow up' => 'Napisz Follow Up',
      'Your own Ticket' => 'Twoje wlasne zgloszenia',

    # Template: AgentZoomAnswer
      'Compose Answer' => 'Napisz odpowiedz',
      'Contact customer' => 'Skontaktuj sie z klientem',
      'phone call' => 'Telefon',

    # Template: AgentZoomArticle
      'Split' => 'Rozdziel',

    # Template: AgentZoomBody
      'Change queue' => 'Zmien kolejke',

    # Template: AgentZoomHead
      'Free Fields' => 'Wolne pola',
      'Print' => 'Drukuj',

    # Template: AgentZoomStatus

    # Template: CustomerCreateAccount
      'Create Account' => 'Utworz konto',

    # Template: CustomerError
      'Traceback' => '',

    # Template: CustomerFooter
      'Powered by' => 'Oparte na',

    # Template: CustomerHeader
      'Contact' => 'Kontakt',
      'Home' => 'Home',
      'Online-Support' => 'Serwis Online',
      'Products' => 'Oferta',
      'Support' => 'Serwis',

    # Template: CustomerLogin

    # Template: CustomerLostPassword
      'Lost your password?' => 'Zapomniales haslo?',
      'Request new password' => 'Prosba o nowe haslo',

    # Template: CustomerMessage

    # Template: CustomerMessageNew

    # Template: CustomerNavigationBar
      'Create new Ticket' => 'Utworz nowe zgloszenie',
      'My Tickets' => 'Moje zgloszenia',
      'New Ticket' => 'Nowe zgloszenie',
      'Ticket-Overview' => 'Zgloszenia - Widok ogolny',
      'Welcome %s' => 'Witaj %s',

    # Template: CustomerPreferencesForm

    # Template: CustomerPreferencesGeneric

    # Template: CustomerPreferencesPassword

    # Template: CustomerStatusView

    # Template: CustomerStatusViewTable

    # Template: CustomerTicketZoom

    # Template: CustomerWarning

    # Template: Error
      'Click here to report a bug!' => 'Klicken Sie hier um einen Fehler zu berichten!',

    # Template: Footer
      'Top of Page' => 'Gora strony',

    # Template: Header

    # Template: InstallerBody
      'Create Database' => 'Datenbank erstellen',
      'Drop Database' => 'Datenbank löschen',
      'Finished' => 'Fertig',
      'System Settings' => 'System Einstellungen',
      'Web-Installer' => '',

    # Template: InstallerFinish
      'Admin-User' => 'Admin-Benutzer',
      'After doing so your OTRS is up and running.' => 'Nachdem ist Dein OTRS laufend.',
      'Have a lot of fun!' => 'Viel Spaß!',
      'Restart your webserver' => 'Restarte Deinen Webserver',
      'Start page' => 'Strona startowa',
      'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' => 'Um OTRS benutzen zu können, müssen die die folgenden Zeilen als root in die Befehlszeile (Terminal/Shell) eingeben.',
      'Your OTRS Team' => 'Dein OTRS-Team',

    # Template: InstallerLicense
      'accept license' => 'Lizenz anerkennen',
      'don\'t accept license' => 'Lizenz nicht anerkennen',
      'License' => 'Lizenz',

    # Template: InstallerStart
      'Create new database' => 'Neue Datenbank erstellen',
      'DB Admin Password' => 'DB Admin Passwort',
      'DB Admin User' => 'DB Admin Benuter',
      'DB Host' => 'DB Rechner',
      'DB Type' => 'DB Typ',
      'default \'hot\'' => 'voreingestellt \'hot\'',
      'Delete old database' => 'Alte Datenbank löschen',
      'next step' => 'Nächster Schritt',
      'OTRS DB connect host' => 'OTRS DB Verbindungs-Rechner',
      'OTRS DB Name' => '',
      'OTRS DB Password' => 'OTRS DB Passwort',
      'OTRS DB User' => 'OTRS DB Benuter',
      'your MySQL DB should have a root password! Default is empty!' => 'Deine MySQL DB sollte ein Root Passwort haben! Voreingestellte ist nichts!',

    # Template: InstallerSystem
      '(Checks MX recordes of used email addresses by composing an answer. Don\'t use CheckMXRecord if your OTRS machine is behinde a dial-up line $!)' => '(Überprüfen des MX Eintrags von benutzen Email Adressen im Verfassen-Fenster. Benutze CheckMXRecord nicht wenn Ihr OTRS hinter einer Wählleitung ist!)',
      '(Email of the system admin)' => '(E-Mail des System Admins)',
      '(Full qualified domain name of your system)' => '(Voller Domain-Name des Systems)',
      '(Logfile just needed for File-LogModule!)' => '(Logfile nur benötigt für File-LogModule!)',
      '(The identify of the system. Each ticket number and each http session id starts with this number)' => '(Das Kennzeichnen des Systems. Jede Ticket Nummer und http Sitzung beginnt mit dieser ID)',
      '(Ticket identifier. Some people want toset this to e. g. \'Ticket#\', \'Call#\' or \'MyTicket#\')' => '(Ticket Kennzeichnen. Z.B. \'Ticket#\', \'Call#\' oder \'MyTicket#\')',
      '(Used default language)' => '(Uzywany domyslny jezyk)',
      '(Used log backend)' => '(Uzywany log backend)',
      '(Used ticket number format)' => '(Uzywany format numeru zgloszenia)',
      'CheckMXRecord' => 'Sprawdz rekord MX',
      'Default Charset' => 'Domyslny charset',
      'Default Language' => 'Domyslny jezyk',
      'Logfile' => 'Plik logu',
      'LogModule' => 'Modul logowania',
      'Organization' => 'Organizacja',
      'System FQDN' => 'Pelna domena systemu FQDN',
      'SystemID' => 'ID Systemu',
      'Ticket Hook' => 'Identyfikator zgloszenia',
      'Ticket Number Generator' => 'Generator numerow zgloszen',
      'Webfrontend' => 'Interfejs webowy',

    # Template: Login

    # Template: LostPassword

    # Template: NoPermission
      'No Permission' => 'Brak dostepu',

    # Template: Notify
      'Info' => 'Info',

    # Template: PrintFooter
      'URL' => 'URL',

    # Template: PrintHeader

    # Template: QueueView
      'All tickets' => 'Wszystkie zgloszenia',
      'Queues' => 'Kolejki',
      'Tickets available' => 'Dostepne zgloszenia',
      'Tickets shown' => 'Pokazane zgloszenia',

    # Template: SystemStats
      'Graphs' => 'Wykresy',

    # Template: Test
      'OTRS Test Page' => 'OTRS Strona testowa',

    # Template: TicketEscalation
      'Ticket escalation!' => 'Eskalacja zgloszenia!',

    # Template: TicketView

    # Template: TicketViewLite
      'Add Note' => 'Dodaj notatke',

    # Template: Warning

    # Misc
      '(Click here to add a group)' => '(Kliknij tutaj, by dodac grupe)',
      '(Click here to add a queue)' => '(Kliknij tutaj, by dodac kolejke)',
      '(Click here to add a response)' => '(Kliknij tutaj, by dodac odpowiedz)',
      '(Click here to add a salutation)' => '(Kliknij tutaj, by dodac zwrot grzecznosciowy)',
      '(Click here to add a signature)' => '(Kliknij tutaj, by dodac podpis)',
      '(Click here to add a system email address)' => '(Kliknij tutaj, by dodac adres email systemu)',
      '(Click here to add a customer user)' => '(Kliknij tutaj, by dodac klienta)',
      '(Click here to add a user)' => '(Kliknij tutaj, by dodac uzytkownika)',
      '(Click here to add an auto response)' => '(Kliknij tutaj, by dodac AutoOdpowiedz)',
      '(Click here to add charset)' => '(Kliknij tutaj, by dodac charset)',
      '(Click here to add language)' => '(Kliknij tutaj, by dodac jezyk)',
      '(Click here to add state)' => '(Kliknij tutaj, by dodac status)',
      '(E-Mail of the system admin)' => '(Adres email Administratora)',
      'A message should have a From: recipient!' => 'Wiadomosc musi zawierac wypelnione pole Od: !',
      'Add language' => 'Dodaje jezyk',
      'Backend' => 'Backend',
      'BackendMessage' => 'Komunikat Backend',
      'Bottom of Page' => 'Dol strony',
      'Change system language setting' => 'Zmien ustawienia jezyka systemu',
      'Create' => 'Utworz',
      'CustomerUser' => 'Klient',
      'FAQ' => 'FAQ',
      'Fulltext search' => 'Przeszukiwanie pelnotekstowe',
      'Handle' => 'Handle',
      'In Queue' => 'W kolejce',
      'New ticket via call.' => 'Nowe zgloszenie telefoniczne.',
      'Search in' => 'Szukaj w',
      'Set customer id of a ticket' => 'Ustaw ID klienta dla zgloszenia',
      'Show all' => 'Pokaz wszystko',
      'System Language Management' => 'Konfiguracja jezyka systemu',
      'Ticket limit:' => 'Limit zgloszenia',
      'Time till escalation' => 'Czas do eskalacji',
      'Update auto response' => 'Aktualizuj AutoOdpowiedz',
      'Update charset' => 'Aktualizuj charset',
      'Update group' => 'Aktualizuj grupe',
      'Update language' => 'Aktualizuj jezyk',
      'Update queue' => 'Aktualizuj kolejke',
      'Update response' => 'Aktualizuj odpowiedz',
      'Update salutation' => 'Aktualizuj zwrot grzecznosciowy',
      'Update signature' => 'Aktualizuj podpis',
      'Update state' => 'Aktualizuj status',
      'Update system address' => 'Aktualizuj adres systemu',
      'Update user' => 'Aktualizuj uzytkownika',
      'With Priority' => 'Z priorytetem',
      'With State' => 'Ze statusem',
      'You have to be in the admin group!' => 'Musisz nalezec do grupy Admin!',
      'You have to be in the stats group!' => 'Musisz nalezec do grupy Stats!',
      'You need a email address (e. g. customer@example.com) in From:!' => 'Musisz posiadac email (np. klient@przykladowafirma.com.pl) w polu Od:!',
      'auto responses set' => 'ustawione AutoOdpowiedzi',
      'invalid-temporarily' => 'Tymczasowo nieuzywane',
      'store' => 'Store',
      'tickets' => 'Zgloszenia',
      'valid' => 'Uzywane',
    );

    # $$STOP$$

    $Self->{Translation} = \%Hash;
}
# --
1;
