# --
# Kernel/Language/pl.pm - provides Polish language translation
# Copyright (C) 2007 Tomasz Melissa <janek at rumianek.com>
# Copyright (C) 2009 Artur Skalski <skal.ar at wp.pl>
# --
# $Id: pl.pm,v 1.90 2010-01-19 22:57:48 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::pl;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.90 $) [1];

sub Data {
    my $Self = shift;

    # $$START$$
    # Last translation file sync: Thu Jul  9 03:58:03 2009

    # possible charsets
    $Self->{Charset} = ['iso-8859-2', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Year;)
    $Self->{DateFormat}          = '%D.%M.%Y %T';
    $Self->{DateFormatLong}      = '%A %D %B %T %Y';
    $Self->{DateFormatShort}     = '%D.%M.%Y';
    $Self->{DateInputFormat}     = '%D.%M.%Y';
    $Self->{DateInputFormatLong} = '%D.%M.%Y - %T';
    $Self->{Separator}           = ';';

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
        'hour(s)' => 'godz.',
        'minute' => 'minuta',
        'minutes' => 'minut',
        'minute(s)' => 'minuta(minut)',
        'month' => 'miesi±c',
        'months' => 'miesiêcy',
        'month(s)' => 'miesi±c(-cy)',
        'week' => 'tydzieñ',
        'week(s)' => 'tydzieñ(tygodnie)',
        'year' => 'rok',
        'years' => 'lat',
        'year(s)' => 'rok(lat)',
        'second(s)' => 'sekund(a)',
        'seconds' => 'sekund',
        'second' => 'drugi',
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
        'Setting' => '',
        'Settings' => '',
        'Example' => 'Przyk³ad',
        'Examples' => 'Przyk³ady',
        'valid' => 'Poprawne',
        'invalid' => 'Niewa¿ne',
        '* invalid' => '* Niewa¿ne',
        'invalid-temporarily' => 'Czasowo niewa¿ne',
        ' 2 minutes' => ' 2 Minuty',
        ' 5 minutes' => ' 5 Minut',
        ' 7 minutes' => ' 7 Minut',
        '10 minutes' => '10 Minut',
        '15 minutes' => '15 Minut',
        'Mr.' => 'Pan',
        'Mrs.' => 'Pani',
        'Next' => 'Dalej',
        'Back' => 'Powrót',
        'Next...' => 'Dalej...',
        '...Back' => '...Powrót',
        '-none-' => '-brak-',
        'none' => 'brak danych',
        'none!' => 'brak!',
        'none - answered' => 'brak - odpowiedziane',
        'please do not edit!' => 'nie edytowaæ!',
        'AddLink' => 'Dodaj link',
        'Link' => 'Po³±cz',
        'Unlink' => 'Roz³±cz',
        'Linked' => 'Po³±czone',
        'Link (Normal)' => 'Po³±czone (równorzêdnie)',
        'Link (Parent)' => 'Po³±czone (Rodzic)',
        'Link (Child)' => 'Po³±czone (Potomek)',
        'Normal' => 'Normalne',
        'Parent' => 'Rodzic',
        'Child' => 'Potomek',
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
        'CustomerIDs' => 'IDs Klienta',
        'customer' => 'klient',
        'agent' => 'agent',
        'system' => 'System',
        'Customer Info' => 'Informacja o kliencie',
        'Customer Company' => 'Firma klienta',
        'Company' => 'Firma',
        'go!' => 'Start!',
        'go' => 'Start',
        'All' => 'Wszystkie',
        'all' => 'wszystkie',
        'Sorry' => 'Przykro mi',
        'update!' => 'uaktualnij!',
        'update' => 'uaktualnij',
        'Update' => 'Uaktualnij',
        'Updated!' => 'Uaktualniono!',
        'submit!' => 'akceptuj!',
        'submit' => 'akceptuj',
        'Submit' => 'Akceptuj',
        'change!' => 'Zmieñ!',
        'Change' => 'Zmieñ',
        'change' => 'zmieñ',
        'click here' => 'kliknij tutaj',
        'Comment' => 'Komentarz',
        'Valid' => 'Poprawne',
        'Invalid Option!' => 'B³êdna opcja!',
        'Invalid time!' => 'B³êdny czas!',
        'Invalid date!' => 'B³edna data!',
        'Name' => 'Nazwa',
        'Group' => 'Grupa',
        'Description' => 'Opis',
        'description' => 'opis',
        'Theme' => 'Schemat',
        'Created' => 'Utworzone',
        'Created by' => 'Utworzone przez',
        'Changed' => 'Zmienione',
        'Changed by' => 'Zmienione przez',
        'Search' => 'Szukaj',
        'and' => 'i',
        'between' => 'pomiêdzy',
        'Fulltext Search' => 'Wyszukiwanie pe³notekstowe',
        'Data' => 'Data',
        'Options' => 'Opcje',
        'Title' => 'Tytu³',
        'Item' => 'Pozycja',
        'Delete' => 'Kasuj',
        'Edit' => 'Edytuj',
        'View' => 'Widok',
        'Number' => 'Liczba',
        'System' => 'System',
        'Contact' => 'Kontakt',
        'Contacts' => 'Kontakty',
        'Export' => 'Eksport',
        'Up' => 'Góra',
        'Down' => 'Dó³',
        'Add' => 'Dodaj',
        'Added!' => 'Dodano!',
        'Category' => 'Kategoria',
        'Viewer' => 'Przegl±darka',
        'Expand' => '',
        'New message' => 'Nowa wiadomo¶æ',
        'New message!' => 'Nowa wiadomo¶æ!',
        'Please answer this ticket(s) to get back to the normal queue view!' => 'Proszê odpowiedz na to zg³oszenie, by móc powrociæ do zwyk³ego widoku kolejki zg³oszeñ!',
        'You got new message!' => 'Masz now± wiadomo¶æ!',
        'You have %s new message(s)!' => 'Masz %s nowych wiadomo¶ci!',
        'You have %s reminder ticket(s)!' => 'Masz %s przypomnieñ o zg³oszeniach!',
        'The recommended charset for your language is %s!' => 'Sugerowane kodowanie dla Twojego jêzyka to %s!',
        'Passwords doesn\'t match! Please try it again!' => 'Has³a nie s± zgodne! Spróbuj ponownie!',
        'Password is already in use! Please use an other password!' => 'Has³o obecnie u¿ywane! Wybierz inne has³o!',
        'Password is already used! Please use an other password!' => 'Has³o u¿yte! Wybierz inne has³o!',
        'You need to activate %s first to use it!' => 'Musisz aktywowaæ %s przed u¿yciem!',
        'No suggestions' => 'Brak podpowiedzi',
        'Word' => 'S³owo',
        'Ignore' => 'Ignoruj',
        'replace with' => 'zamieñ z',
        'There is no account with that login name.' => 'Nie istnieje konto z takim loginem.',
        'Login failed! Your username or password was entered incorrectly.' => 'Logowanie niepoprawne! Twój login lub has³o zosta³y wpisane niepoprawnie.',
        'Please contact your admin' => 'Skontaktuj siê z Administratorem',
        'Logout successful. Thank you for using OTRS!' => 'Wylogowanie zakoñczone! Dziêkujemy za u¿ywanie OTRS!',
        'Invalid SessionID!' => 'Niepoprawne ID Sesji!',
        'Feature not active!' => 'Funkcja nie aktywna!',
        'Notifications (Event)' => '',
        'Login is needed!' => 'Wymagane zalogowanie!',
        'Password is needed!' => 'Has³o jest wymagane!',
        'License' => 'Licencja',
        'Take this Customer' => 'U¿yj tego klienta!',
        'Take this User' => 'U¿yj tego u¿ytkownika',
        'possible' => 'mo¿liwe',
        'reject' => 'odrzuæ',
        'reverse' => 'odwróæ',
        'Facility' => 'U³atwienie',
        'Timeover' => 'Przekroczenie czasu',
        'Pending till' => 'Oczekuje do',
        'Don\'t work with UserID 1 (System account)! Create new users!' => 'Nie u¿ywaj u¿ytkownika z UserID 1 (Konto systemowe)! Stwórz nowych u¿ytkowników!',
        'Dispatching by email To: field.' => 'Przekazywanie na podstawie pola DO:',
        'Dispatching by selected Queue.' => 'Przekazywanie na podstawie zaznaczonej kolejki.',
        'No entry found!' => 'Nic nie odnaleziono!',
        'Session has timed out. Please log in again.' => 'Sesja wygas³a. Zaloguj siê ponownie',
        'No Permission!' => 'Brak uprawnieñ',
        'To: (%s) replaced with database email!' => 'DO: (%s) zamienione z adresem email z bazy danych',
        'Cc: (%s) added database email!' => 'Cc: (%s) zamienione z adresem email z bazy danych',
        '(Click here to add)' => '(By dodaæ kliknij tutaj)',
        'Preview' => 'Podgl±d',
        'Package not correctly deployed! You should reinstall the Package again!' => 'Pakiet niew³aciwie zainstalowany! Nale¿y reinstalowaæ pakiet!',
        'Added User "%s"' => 'Dodano u¿ytkownika "%s"',
        'Contract' => 'Umowa',
        'Online Customer: %s' => 'Klient zalogowany: %s',
        'Online Agent: %s' => 'Agent zalogowany: %s',
        'Calendar' => 'Kalendarz',
        'File' => 'Plik',
        'Filename' => 'Nazwa pliku',
        'Type' => 'Typ',
        'Size' => 'Rozmiar',
        'Upload' => 'Wysy³anie',
        'Directory' => 'Katalog',
        'Signed' => 'Podpisany',
        'Sign' => 'Podpis',
        'Crypted' => 'Zaszyfrowany',
        'Crypt' => 'Szyfr',
        'Office' => 'Biuro',
        'Phone' => 'Tel.',
        'Fax' => 'Fax',
        'Mobile' => 'Tel. komórkowy',
        'Zip' => 'Kod',
        'City' => 'Miasto',
        'Street' => 'Ulica',
        'Country' => 'Kraj',
        'Location' => 'Miejsce',
        'installed' => 'zainstalowany',
        'uninstalled' => 'odinstalowany',
        'Security Note: You should activate %s because application is already running!' => 'Nota bezpieczeñstwa: Nale¿y aktywowaæ %s poniewa¿ aplikacja jest uruchomiona!',
        'Unable to parse Online Repository index document!' => 'Niedostêpne repozytorium on-line',
        'No Packages for requested Framework in this Online Repository, but Packages for other Frameworks!' => 'Brak pakietów dla u¿ywanej wersji Frameworka w tym repozytorium, ale s± pakiety dla innych wersji!',
        'No Packages or no new Packages in selected Online Repository!' => 'Brak pakietów lub brak nowych pakietów w wybranym repozytorium!',
        'printed at' => 'wydrukowano',
        'Dear Mr. %s,' => 'Drogi Panie %s,',
        'Dear Mrs. %s,' => 'Droga Pani %s,',
        'Dear %s,' => 'Drogi %s,',
        'Hello %s,' => 'Witaj %s,',
        'This account exists.' => 'Konto istnieje.',
        'New account created. Sent Login-Account to %s.' => 'Utworzono konto. Wys³ano login do %s.',
        'Please press Back and try again.' => 'Prosze wybrac Cofnij i spróbowac ponownie.',
        'Sent password token to: %s' => 'Wys³ano token has³a do: %s',
        'Sent new password to: %s' => 'Wys³ano nowe has³o do: %s',
        'Upcoming Events' => '',
        'Event' => 'Zdarzenie',
        'Events' => '',
        'Invalid Token!' => 'B³êdny token!',
        'more' => '',
        'For more info see:' => '',
        'Package verification failed!' => '',
        'Collapse' => '',
        'News' => '',
        'Product News' => '',
        'OTRS News' => '',
        '7 Day Stats' => '',
        'Bold' => '',
        'Italic' => '',
        'Underline' => '',
        'Font Color' => '',
        'Background Color' => '',
        'Remove Formatting' => '',
        'Show/Hide Hidden Elements' => '',
        'Align Left' => '',
        'Align Center' => '',
        'Align Right' => '',
        'Justify' => '',
        'Header' => '',
        'Indent' => '',
        'Outdent' => '',
        'Create an Unordered List' => '',
        'Create an Ordered List' => '',
        'HTML Link' => '',
        'Insert Image' => '',
        'CTRL' => '',
        'SHIFT' => '',
        'Undo' => '',
        'Redo' => '',

        # Template: AAAMonth
        'Jan' => 'Sty',
        'Feb' => 'Lut',
        'Mar' => 'Mar',
        'Apr' => 'Kwi',
        'May' => 'Maj',
        'Jun' => 'Cze',
        'Jul' => 'Lip',
        'Aug' => 'Sie',
        'Sep' => 'Wrz',
        'Oct' => 'Pa¼',
        'Nov' => 'Lis',
        'Dec' => 'Gru',
        'January' => 'Styczeñ',
        'February' => 'Luty',
        'March' => 'Marzec',
        'April' => 'Kwiecieñ',
        'May_long' => 'Maj',
        'June' => 'Czerwiec',
        'July' => 'Lipiec',
        'August' => 'Sierpieñ',
        'September' => 'Wrzesieñ',
        'October' => 'Pa¼dziernik',
        'November' => 'Listopad',
        'December' => 'Grudzieñ',

        # Template: AAANavBar
        'Admin-Area' => 'Administracja',
        'Agent-Area' => 'Obs³uga',
        'Ticket-Area' => 'Zg³oszenia',
        'Logout' => 'Wyloguj',
        'Agent Preferences' => 'Ustawienia agenta',
        'Preferences' => 'Ustawienia',
        'Agent Mailbox' => 'Poczta',
        'Stats' => 'Statystyki',
        'Stats-Area' => 'Staystyki',
        'Admin' => 'Administracja',
        'Customer Users' => 'Klienci',
        'Customer Users <-> Groups' => 'Klienci <-> Grupy',
        'Users <-> Groups' => 'U¿ytkownicy <-> Grupy',
        'Roles' => 'Role',
        'Roles <-> Users' => 'Role <-> U¿ytkownicy',
        'Roles <-> Groups' => 'Role <-> Grupy',
        'Salutations' => 'Powitania',
        'Signatures' => 'Podpisy',
        'Email Addresses' => 'Adresy e-mail',
        'Notifications' => 'Powiadomienia',
        'Category Tree' => 'Drzewo kategorii',
        'Admin Notification' => 'Powiadomienia administratora',

        # Template: AAAPreferences
        'Preferences updated successfully!' => 'Ustawienia zapisano pomy¶lnie!',
        'Mail Management' => 'Zarz±dzanie poczt±',
        'Frontend' => 'Interfejs',
        'Other Options' => 'Inne opcje',
        'Change Password' => 'Zmieñ has³o',
        'New password' => 'Nowe has³o',
        'New password again' => 'Ponownie nowe has³o',
        'Select your QueueView refresh time.' => 'Wybierz okres od¶wierzania Podgl±du Kolejki.',
        'Select your frontend language.' => 'Wybierz jêzyk.',
        'Select your frontend Charset.' => 'Wybierz kodowanie.',
        'Select your frontend Theme.' => 'Wybierz schemat wygl±du systemu.',
        'Select your frontend QueueView.' => 'Wybierz Podgl±d Kolejki.',
        'Spelling Dictionary' => 'S³ownik pisowni',
        'Select your default spelling dictionary.' => 'Wybierz domy¶lny s³ownik.',
        'Max. shown Tickets a page in Overview.' => 'Limit pokazywanych zg³oszeñ na stronie Podsumowania',
        'Can\'t update password, your new passwords do not match! Please try again!' => '',
        'Can\'t update password, invalid characters!' => 'Nie mo¿na zmieniæ has³a, niedozwolone znaki!',
        'Can\'t update password, must be at least %s characters!' => '',
        'Can\'t update password, must contain 2 lower and 2 upper characters!' => '',
        'Can\'t update password, needs at least 1 digit!' => '',
        'Can\'t update password, needs at least 2 characters!' => '',

        # Template: AAAStats
        'Stat' => 'Statystyki',
        'Please fill out the required fields!' => 'Wype³nij wymagane pola!',
        'Please select a file!' => 'Wybierz plik!',
        'Please select an object!' => 'Wybierz obiekt!',
        'Please select a graph size!' => 'Wybierz rozmiar wykresu!',
        'Please select one element for the X-axis!' => 'Wybierz element dla osi X!',
        'Please select only one element or turn off the button \'Fixed\' where the select field is marked!' => 'Wybierz tylko jeden element lyb wy³±cz klawisz\'Sta³e\' przy zaznaczonym polu!',
        'If you use a checkbox you have to select some attributes of the select field!' => 'Po zaznaczeniu pola wyboru musisz wskazaæ atrybuty wybranego pola!',
        'Please insert a value in the selected input field or turn off the \'Fixed\' checkbox!' => 'Wprowad¼ warto¶æ w wybrane pole lub odznacz pole \'Sta³y\'!',
        'The selected end time is before the start time!' => 'Czas zakoñczenia wcze¶niejszy od czasu rozpoczêcia!',
        'You have to select one or more attributes from the select field!' => 'Wska¿ jeden lub wiêcej atrybut z pola wyboru!',
        'The selected Date isn\'t valid!' => 'Wybrana data jest nieprawid³owa!',
        'Please select only one or two elements via the checkbox!' => 'Zaznacz tylko jeden lub dwa pola wyboru!',
        'If you use a time scale element you can only select one element!' => 'Je¿eli u¿ywasz skalowania czasu mo¿esz wybraæ tylko jeden element!',
        'You have an error in your time selection!' => 'B³±d w wyborze czasu!',
        'Your reporting time interval is too small, please use a larger time scale!' => 'Wybrany zakres czasu jest za ma³y, u¿yj wiêkszej skali czasu!',
        'The selected start time is before the allowed start time!' => 'Wybrany czas pocz±tku jest przed dozwolonym czasem rozpoczêcia!',
        'The selected end time is after the allowed end time!' => 'Wybrany czas koñca przekracza dopuszczalny czas zakoñczenia!',
        'The selected time period is larger than the allowed time period!' => 'Wybrany zakres czasu przekracza maksymalny dopuszczalny!',
        'Common Specification' => 'Podstawowa specyfikacja',
        'Xaxis' => 'O¶ X',
        'Value Series' => 'Serie warto¶ci',
        'Restrictions' => 'Ograniczenia',
        'graph-lines' => 'wykres-linie',
        'graph-bars' => 'wykres-s³upki',
        'graph-hbars' => 'wykres-s³upki poziome',
        'graph-points' => 'wykres-punkty',
        'graph-lines-points' => 'wykres- linie i punkty',
        'graph-area' => 'obszar wykresu',
        'graph-pie' => 'wykres-ko³owy',
        'extended' => 'rozszerzony',
        'Agent/Owner' => 'Obs³uguj±cy/W³a¶ciciel',
        'Created by Agent/Owner' => 'Utworzony przez Obs³uguj±cego/W³a¶ciciela',
        'Created Priority' => 'Utworzony prirytet',
        'Created State' => 'Utworzony status',
        'Create Time' => 'Czas utworzenia',
        'CustomerUserLogin' => 'Login klienta',
        'Close Time' => 'Czas zamkniêcia',
        'TicketAccumulation' => '',
        'Attributes to be printed' => '',
        'Sort sequence' => '',
        'Order by' => '',
        'Limit' => '',
        'Ticketlist' => '',
        'ascending' => '',
        'descending' => '',
        'First Lock' => '',
        'Evaluation by' => '',
        'Total Time' => '',
        'Ticket Average' => '',
        'Ticket Min Time' => '',
        'Ticket Max Time' => '',
        'Number of Tickets' => '',
        'Article Average' => '',
        'Article Min Time' => '',
        'Article Max Time' => '',
        'Number of Articles' => '',
        'Accounted time by Agent' => '',
        'Ticket/Article Accounted Time' => '',
        'TicketAccountedTime' => '',
        'Ticket Create Time' => '',
        'Ticket Close Time' => '',

        # Template: AAATicket
        'Lock' => 'Zablokuj',
        'Unlock' => 'Odblokuj',
        'History' => 'Historia',
        'Zoom' => 'Podgl±d',
        'Age' => 'Wiek',
        'Bounce' => 'Odbij',
        'Forward' => 'Prze¶lij dalej',
        'From' => 'Od',
        'To' => 'Do',
        'Cc' => 'Cc',
        'Bcc' => 'Bcc',
        'Subject' => 'Temat',
        'Move' => 'Przesuñ',
        'Queue' => 'Kolejka',
        'Priority' => 'Priorytet',
        'Priority Update' => 'Aktualizacja priorytetu',
        'State' => 'Status',
        'Compose' => 'Stwórz',
        'Pending' => 'Oczekuj±ce',
        'Owner' => 'W³a¶ciciel',
        'Owner Update' => 'Aktualizacja w³asciciela',
        'Responsible' => 'Odpowiedzialny',
        'Responsible Update' => 'Aktualizacja odpowiedzialnego',
        'Sender' => 'Nadawca',
        'Article' => 'Artyku³',
        'Ticket' => 'Zg³oszenie',
        'Createtime' => 'Utworzone o',
        'plain' => 'bez formatowania',
        'Email' => 'E-Mail',
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
        'Free Fields' => 'Wolne pola',
        'Merge' => 'Scalaj',
        'merged' => 'scalone',
        'closed successful' => 'zamkniête z powodzeniem',
        'closed unsuccessful' => 'zamkniête bez powodzenia',
        'new' => 'nowe',
        'open' => 'otwarte',
        'Open' => '',
        'closed' => 'zamkniête',
        'Closed' => '',
        'removed' => 'usuniête',
        'pending reminder' => 'oczekuj±ce przypomnienie',
        'pending auto' => 'oczekuj±ce auto',
        'pending auto close+' => 'oczekuj±ce na automatyczne zamkniêcie+',
        'pending auto close-' => 'oczekuj±ce na automatyczne zamkniêcie-',
        'email-external' => 'e-mail zewnêtrzny',
        'email-internal' => 'e-mail wewnêtrzny',
        'note-external' => 'Notatka zewnêtrzna',
        'note-internal' => 'Notatka wewnêtrzna',
        'note-report' => 'Notatka raportujaca',
        'phone' => 'telefon',
        'sms' => 'SMS',
        'webrequest' => 'zg³oszenie WWW',
        'lock' => 'zablokuj',
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
        'Ticket Number' => 'Numer zg³oszenia',
        'Ticket Object' => 'Obiekt zg³oszenia',
        'No such Ticket Number "%s"! Can\'t link it!' => 'Nie znaleziono zg³oszenia numer "%s"! Nie mozna po³±czyæ!',
        'Don\'t show closed Tickets' => 'Nie pokazuj zamkniêtych zg³oszeñ',
        'Show closed Tickets' => 'Poka¿ zamkniête zg³oszenia',
        'New Article' => 'Nowy artyku³',
        'Email-Ticket' => 'Zg³oszenie e-mail',
        'Create new Email Ticket' => 'Utwórz nowe zg³oszenie e-mail',
        'Phone-Ticket' => 'Zg³oszenie telefoniczne',
        'Search Tickets' => 'Szukaj zg³oszeñ',
        'Edit Customer Users' => 'Edycja klientów',
        'Edit Customer Company' => 'Edycja firm',
        'Bulk Action' => '',
        'Bulk Actions on Tickets' => 'Akcja grupowa na zg³oszeniach',
        'Send Email and create a new Ticket' => 'Wylij e-mail i utwórz nowe zg³oszenie',
        'Create new Email Ticket and send this out (Outbound)' => 'Utwórz nowe zg³oszenie e-mail i wy¶lij (wychodz±ce)',
        'Create new Phone Ticket (Inbound)' => 'Utwórz zg³oszenie telefoniczne (przychodz±ce)',
        'Overview of all open Tickets' => 'Przegl±d otwartych zg³oszeñ',
        'Locked Tickets' => 'Zablokowane zg³oszenia',
        'Watched Tickets' => 'Obserwowane zg³oszenia',
        'Watched' => 'Obserwowane',
        'Subscribe' => 'Zapisz',
        'Unsubscribe' => 'Wypisz',
        'Lock it to work on it!' => 'Zablokuj w celu obs³ugi',
        'Unlock to give it back to the queue!' => 'Odblokuj i skieruj do kolejki!',
        'Shows the ticket history!' => 'Poka¿ historiê zg³oszenia!',
        'Print this ticket!' => 'Wydrukuj zg³oszenie!',
        'Change the ticket priority!' => 'Zmieñ priorytet zg³oszenia!',
        'Change the ticket free fields!' => 'Zmieñ wolne pola zg³oszenia!',
        'Link this ticket to an other objects!' => 'Po³±cz zg³oszenie z innym!',
        'Change the ticket owner!' => 'Zmieñ w³aciciela zg³oszenia!',
        'Change the ticket customer!' => 'Zmieñ klienta zg³oszenia!',
        'Add a note to this ticket!' => 'Dodaj notatkê do zg³oszenia!',
        'Merge this ticket!' => 'Do³±cz zg³oszenie!',
        'Set this ticket to pending!' => 'Ustaw zg³oszenie jako oczekuj±ce!',
        'Close this ticket!' => 'Zamknij zg³oszenie!',
        'Look into a ticket!' => 'Szczegó³y zg³oszenia!',
        'Delete this ticket!' => 'Usuñ zg³oszenie!',
        'Mark as Spam!' => 'Oznacz jako spam!',
        'My Queues' => 'Moje kolejki',
        'Shown Tickets' => 'Poka¿ zg³oszenia',
        'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' => 'Twoje zg³oszenie o numerze "<OTRS_TICKET>" zosta³o do³±czone do "<OTRS_MERGE_TO_TICKET>".',
        'Ticket %s: first response time is over (%s)!' => 'Zg³oszenie %s: czas pierwszej odpowiedzi przekroczony (%s)!',
        'Ticket %s: first response time will be over in %s!' => 'Zg³oszenie %s: czas pierwszej odpowiedzi zostanie przekroczony za %s!',
        'Ticket %s: update time is over (%s)!' => 'Zg³oszenie %s: czas aktualizacji przekroczony (%s)!',
        'Ticket %s: update time will be over in %s!' => 'Zg³oszenie %s: czas aktualizacji zostanie przekroczony za %s!',
        'Ticket %s: solution time is over (%s)!' => 'Zg³oszenie %s: czas rozwi±zania przekroczony (%s)!',
        'Ticket %s: solution time will be over in %s!' => 'Zg³oszenie %s: czas rozwi±zania zostanie przekroczony za %s!',
        'There are more escalated tickets!' => 'Wiêcej przeterminowanych zg³oszeñ!',
        'New ticket notification' => 'Powiadomienie o nowym zg³oszeniu',
        'Send me a notification if there is a new ticket in "My Queues".' => 'Powiadom o nowym zg³oszeniu w moich kolejkach.',
        'Follow up notification' => 'Powiadomienie o odpowiedzi',
        'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.' => 'Wy¶lij mi wiadomo¶æ, gdy klient odpowie na zg³oszenie, którego ja jestem w³a¶cicielem.',
        'Ticket lock timeout notification' => 'Powiadomienie o przekroczonym czasie blokady zg³oszenia',
        'Send me a notification if a ticket is unlocked by the system.' => 'Wy¶lij mi wiadomo¶æ, gdy zg³oszenie zostanie odblokowane przez system.',
        'Move notification' => 'Powiadomienie o przesuniêciu',
        'Send me a notification if a ticket is moved into one of "My Queues".' => 'Powiadom o przesuniêciu do mojej kolejki',
        'Your queue selection of your favourite queues. You also get notified about those queues via email if enabled.' => 'Twój zestaw wybranych kolejek spo¶ród ulubionych. Bedziesz powiadamiany o tych kolejkach przez e-mail je¿eli us³ugê w³±czono.',
        'Custom Queue' => 'Kolejka modyfikowana',
        'QueueView refresh time' => 'Okres od¶wierzania Podgl±du Kolejki',
        'Screen after new ticket' => 'Ekran po nowym zg³oszeniu',
        'Select your screen after creating a new ticket.' => 'Wybierz ekran, który poka¿e siê po rejestracji nowego zg³oszenia',
        'Closed Tickets' => 'Zamkniête zg³oszenia',
        'Show closed tickets.' => 'Poka¿ zamkniête zg³oszenia.',
        'Max. shown Tickets a page in QueueView.' => 'Limit pokazywanych zg³oszeñ na stronie Podgl±du Kolejki',
        'Watch notification' => 'Obserwuj powiadomienia',
        'Send me a notification of an watched ticket like an owner of an ticket.' => 'Wy¶lij mi powiadomienie obserwowaych zg³oszeñ tak jak w³a¶cicielowi zg³oszenia.',
        'Out Of Office' => 'Poza biurem',
        'Select your out of office time.' => 'Wybierz czas nieobecnosci',
        'CompanyTickets' => 'Zg³oszenia firmy',
        'MyTickets' => 'Moje zg³oszenia',
        'New Ticket' => 'Nowe zg³oszenie',
        'Create new Ticket' => 'Utwórz nowe zg³oszenie',
        'Customer called' => 'Telefon od klienta',
        'phone call' => 'rozmowa telefoniczna',
        'Reminder Reached' => 'Przypomnienie osi±gniêto',
        'Reminder Tickets' => '',
        'Escalated Tickets' => '',
        'New Tickets' => '',
        'Open Tickets / Need to be answered' => '',
        'Tickets which need to be answered!' => '',
        'All new tickets!' => '',
        'All tickets which are escalated!' => '',
        'All tickets where the reminder date has reached!' => '',
        'Responses' => 'Odpowiedzi',
        'Responses <-> Queues' => 'Odpowied¼ <-> Kolejka',
        'Auto Responses' => 'Automatyczna odpowied¼',
        'Auto Responses <-> Queues' => 'Automatyczna odpowied¼ <-> Kolejka',
        'Attachments <-> Responses' => 'Za³±czniki <-> Odpowiedzi',
        'History::Move' => 'Zg³oszenie przeniesiono do kolejki "%s" (%s) z kolejki "%s" (%s).',
        'History::TypeUpdate' => 'Zaktualizowano typ do %s (ID=%s).',
        'History::ServiceUpdate' => 'Zaktualizowano us³ugê do %s (ID=%s).',
        'History::SLAUpdate' => 'Zaktualizowano SLA do %s (ID=%s).',
        'History::NewTicket' => 'Nowe zg³oszenie [%s] utworzone (Q=%s;P=%s;S=%s).',
        'History::FollowUp' => 'FollowUp dla [%s]. %s',
        'History::SendAutoReject' => 'Automatyczne odrzucenie wys³ano do "%s".',
        'History::SendAutoReply' => 'Auto odpowied¼ wys³ano do "%s".',
        'History::SendAutoFollowUp' => 'AutoFollowUp wys³ano do "%s".',
        'History::Forward' => 'Przekazano do "%s".',
        'History::Bounce' => 'Bounced to "%s".',
        'History::SendAnswer' => 'E-mail wys³ano do "%s".',
        'History::SendAgentNotification' => '"%s"-powiadomienie wys³ano do "%s".',
        'History::SendCustomerNotification' => 'Powiadomienie wys³ano do "%s".',
        'History::EmailAgent' => 'E-mail wys³any do klienta.',
        'History::EmailCustomer' => 'Dodano e-mail. %s',
        'History::PhoneCallAgent' => 'Agent telefonowa³ do klienta.',
        'History::PhoneCallCustomer' => 'klient telefonowa³.',
        'History::AddNote' => 'Dodano notatkê (%s)',
        'History::Lock' => 'Zablokowano zg³oszenie.',
        'History::Unlock' => 'Odblokowano zg³oszenie.',
        'History::TimeAccounting' => '%s jednostek czasu zliczono. Czas ca³kowity %s jednostek.',
        'History::Remove' => '%s',
        'History::CustomerUpdate' => 'Zaktualizowano: %s',
        'History::PriorityUpdate' => 'Zmieniono priorytet z "%s" (%s) na "%s" (%s).',
        'History::OwnerUpdate' => 'Nowym w³a¶cicielem jest "%s" (ID=%s).',
        'History::LoopProtection' => 'Loop-Protection! Nie wyslano auto-odpowiedzi do "%s".',
        'History::Misc' => '%s',
        'History::SetPendingTime' => 'Zaktualizowano: %s',
        'History::StateUpdate' => 'Stary: "%s" nowy: "%s"',
        'History::TicketFreeTextUpdate' => 'Zaktualizowano: %s=%s;%s=%s;',
        'History::WebRequestCustomer' => '¯±danie klienta przez www.',
        'History::TicketLinkAdd' => 'Dodano ³±cze do zg³oszenia "%s".',
        'History::TicketLinkDelete' => 'Usuniêto ³acze ze zg³oszenia "%s".',
        'History::Subscribe' => 'Dodano subskrypcje dla u¿ytkownika "%s".',
        'History::Unsubscribe' => 'Usuniêto subskrypcje dla u¿ytkownika "%s".',

        # Template: AAAWeekDay
        'Sun' => 'Nie',
        'Mon' => 'Pon',
        'Tue' => 'Wt',
        'Wed' => '¦r',
        'Thu' => 'Czw',
        'Fri' => 'Pi±',
        'Sat' => 'Sob',

        # Template: AdminAttachmentForm
        'Attachment Management' => 'Zarz±dzanie za³±cznikami',

        # Template: AdminAutoResponseForm
        'Auto Response Management' => 'Zarz±dzanie automatycznymi odpowiedziami',
        'Response' => 'Odpowied¼',
        'Auto Response From' => 'Automatyczna odpowied¼ Od',
        'Note' => 'Uwagi',
        'Useable options' => 'U¿yteczne opcje',
        'To get the first 20 character of the subject.' => 'Poka¿ pierwsze 20 znaków tematu.',
        'To get the first 5 lines of the email.' => 'Poka¿ 5 linii wiadomo¶ci e-mail.',
        'To get the realname of the sender (if given).' => 'Poka¿ imiê i nazwisko nadawcy (je¿eli poda³).',
        'To get the article attribute (e. g. (<OTRS_CUSTOMER_From>, <OTRS_CUSTOMER_To>, <OTRS_CUSTOMER_Cc>, <OTRS_CUSTOMER_Subject> and <OTRS_CUSTOMER_Body>).' => 'Atrybuty artyku³u (np. (<OTRS_CUSTOMER_From>, <OTRS_CUSTOMER_To>, <OTRS_CUSTOMER_Cc>, <OTRS_CUSTOMER_Subject> and <OTRS_CUSTOMER_Body>).',
        'Options of the current customer user data (e. g. <OTRS_CUSTOMER_DATA_UserFirstname>).' => 'W³asno¶ci aktualnego klienta(np. <OTRS_CUSTOMER_DATA_UserFirstname>).',
        'Ticket owner options (e. g. <OTRS_OWNER_UserFirstname>).' => 'W³asno¶ci w³asciciela zg³oszenia (np. <OTRS_OWNER_UserFirstname>).',
        'Ticket responsible options (e. g. <OTRS_RESPONSIBLE_UserFirstname>).' => 'W³asno¶ci odpowiedzialnego agenta (np. <OTRS_RESPONSIBLE_UserFirstname>).',
        'Options of the current user who requested this action (e. g. <OTRS_CURRENT_UserFirstname>).' => 'W³asno¶ci aktualnego u¿ytkownika który wykona³ akcjê (np. <OTRS_CURRENT_UserFirstname>).',
        'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>).' => 'W³asno¶ci zg³oszenia (np. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>).',
        'Config options (e. g. <OTRS_CONFIG_HttpType>).' => 'W³asno¶ci systemu (np. <OTRS_CONFIG_HttpType>).',

        # Template: AdminCustomerCompanyForm
        'Customer Company Management' => 'Zarz±dzanie firmami',
        'Search for' => 'Szukaj',
        'Add Customer Company' => 'Dodaj firmê',
        'Add a new Customer Company.' => 'Dodaj now± firmê',
        'List' => 'Lista',
        'These values are required.' => 'Warto¶æ wymagana.',
        'These values are read-only.' => 'Warto¶æ tylko do odczytu.',

        # Template: AdminCustomerUserForm
        'Title{CustomerUser}' => '',
        'Firstname{CustomerUser}' => '',
        'Lastname{CustomerUser}' => '',
        'Username{CustomerUser}' => '',
        'Email{CustomerUser}' => '',
        'CustomerID{CustomerUser}' => '',
        'Phone{CustomerUser}' => '',
        'Fax{CustomerUser}' => '',
        'Mobile{CustomerUser}' => '',
        'Street{CustomerUser}' => '',
        'Zip{CustomerUser}' => '',
        'City{CustomerUser}' => '',
        'Country{CustomerUser}' => '',
        'Comment{CustomerUser}' => '',
        'The message being composed has been closed.  Exiting.' => 'Wiadomo¶æ edytowana zosta³a zamkniêta.  Wychodzê.',
        'This window must be called from compose window' => 'To okno musi zostaæ wywo³ane z okna edycji',
        'Customer User Management' => 'Zarzadzanie klientami',
        'Add Customer User' => 'Dodaj klienta',
        'Source' => '¬ród³o',
        'Create' => 'Utwórz',
        'Customer user will be needed to have a customer history and to login via customer panel.' => 'Klient jest wymagany aby obejrzeæ historiê i zalogowaæ siê do panelu.',

        # Template: AdminCustomerUserGroupChangeForm
        'Customer Users <-> Groups Management' => 'Klienci <-> Grupy',
        'Change %s settings' => 'Zmieñ %s ustawienia',
        'Select the user:group permissions.' => 'Wybierz prawa dostêpu dla u¿ytkownika:grupy',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the user).' => 'Je¶li nic nie zaznaczono, wtedy u¿ytkownik nie bêdzie mia³ praw w tej grupie (zg³oszenia bêd± niedostêpne)',
        'Permission' => 'Prawo dostêpu',
        'ro' => 'odczyt',
        'Read only access to the ticket in this group/queue.' => 'Prawo jedynie do odczytu zg³oszeñ w tej grupie/kolejce',
        'rw' => 'odczyt/zapis',
        'Full read and write access to the tickets in this group/queue.' => 'Prawa pe³nego odczytu i zapisu zg³oszeñ w tej grupie/kolejce',

        # Template: AdminCustomerUserGroupForm

        # Template: AdminCustomerUserService
        'Customer Users <-> Services Management' => 'Klienci <-> Us³ugi',
        'CustomerUser' => 'Klient',
        'Service' => 'Us³uga',
        'Edit default services.' => 'Edycja domy¶lnych us³ug.',
        'Search Result' => 'Wyniki wyszukiwania',
        'Allocate services to CustomerUser' => 'Przypisz us³ugi do klienta',
        'Active' => 'Aktywne',
        'Allocate CustomerUser to service' => 'Przypisz klienta do us³ugi',

        # Template: AdminEmail
        'Message sent to' => 'Wiadomo¶æ wys³ana do',
        'A message should have a subject!' => 'Wiadomosc powinna posiadaæ temat!',
        'Recipients' => 'Adresaci',
        'Body' => 'Tre¶æ',
        'Send' => 'Wy¶lij',

        # Template: AdminGenericAgent
        'GenericAgent' => 'Agent automatyczny',
        'Job-List' => 'Lista zadañ',
        'Last run' => 'Ostatnie uruchomienie',
        'Run Now!' => 'Uruchom teraz',
        'x' => '',
        'Save Job as?' => 'Zapisz zadanie jako',
        'Is Job Valid?' => 'Zadanie jest wa¿ne?',
        'Is Job Valid' => 'Zadanie jest wa¿ne',
        'Schedule' => 'Harmonogram',
        'Currently this generic agent job will not run automatically.' => 'Zadanie nie zostanie uruchomione automatycznie.',
        'To enable automatic execution select at least one value from minutes, hours and days!' => '',
        'Fulltext-Search in Article (e. g. "Mar*in" or "Baue*")' => 'Przeszukiwanie pe³notekstowe w artykule (np. "Ja*k" lub "Rumia*)',
        '(e. g. 10*5155 or 105658*)' => '(np. 10*5155 lub 105658*)',
        '(e. g. 234321)' => '(np. 3242442)',
        'Customer User Login' => 'Login Klienta',
        '(e. g. U5150)' => '(np. U4543)',
        'SLA' => 'SLA',
        'Agent' => 'Agent',
        'Ticket Lock' => 'Zablokowanie zg³oszenia',
        'TicketFreeFields' => 'Wolne pola zg³oszenia',
        'Create Times' => 'Czasy utworzenia',
        'No create time settings.' => 'Bez czasów utworzenia.',
        'Ticket created' => 'Zg³oszenie utworzone',
        'Ticket created between' => 'Zg³oszenie utworzone miêdzy',
        'Close Times' => 'Czasy zamkniêcia',
        'No close time settings.' => 'Bez czasów zamkniecia.',
        'Ticket closed' => 'Zg³oszenie zamkniête',
        'Ticket closed between' => 'Zg³oszenie zamkniête miêdzy',
        'Pending Times' => 'Czasy oczekiwania',
        'No pending time settings.' => 'Bez czasów oczekiwania.',
        'Ticket pending time reached' => 'Oczekiwanie zakoñczone',
        'Ticket pending time reached between' => 'Oczekiwanie zakoñczone miêdzy',
        'Escalation Times' => '',
        'No escalation time settings.' => '',
        'Ticket escalation time reached' => '',
        'Ticket escalation time reached between' => '',
        'Escalation - First Response Time' => 'Eskalacja - czas pierwszej odpowiedzi',
        'No escalation time settings.' => '',
        'Ticket first response time reached' => '',
        'Ticket first response time reached between' => '',
        'Escalation - Update Time' => 'Eskalacja - czas aktualizacji',
        'Ticket update time reached' => '',
        'Ticket update time reached between' => '',
        'Escalation - Solution Time' => 'Eskalacja - czas rozwi±zania',
        'Ticket solution time reached' => '',
        'Ticket solution time reached between' => '',
        'New Service' => 'Nowa us³uga',
        'New SLA' => 'Nowa SLA',
        'New Priority' => 'Nowy priorytet',
        'New Queue' => 'Nowa kolejka',
        'New State' => 'Nowy status',
        'New Agent' => 'Nowy agent',
        'New Owner' => 'Nowy w³a¶ciciel',
        'New Customer' => 'Nowy klient',
        'New Ticket Lock' => 'Nowa blokada zg³oszenia',
        'New Type' => 'Nowy typ',
        'New Title' => 'Nowy tytu³',
        'New TicketFreeFields' => 'Nowe wolne pole',
        'Add Note' => 'Dodaj notatkê',
        'Time units' => 'Jednostek czasu',
        'CMD' => 'linia poleceñ',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' => 'Komenda zostanie wykonana. ARG[0] to numer zg³oszenia. ARG[1] to id zg³oszenia.',
        'Delete tickets' => 'Usuñ zg³oszenia',
        'Warning! This tickets will be removed from the database! This tickets are lost!' => 'Uwaga! Zg³oszenia zostan± usuniete z bazy danych! Zg³oszenia zostan± utracone!',
        'Send Notification' => 'Wy¶lij powiadomienie',
        'Param 1' => 'Parametr 1',
        'Param 2' => 'Parametr 2',
        'Param 3' => 'Parametr 3',
        'Param 4' => 'Parametr 4',
        'Param 5' => 'Parametr 5',
        'Param 6' => 'Parametr 6',
        'Send agent/customer notifications on changes' => 'Wy¶lij powidomienia agentowi/klientowi przy zmianie ',
        'Save' => 'Zapisz',
        '%s Tickets affected! Do you really want to use this job?' => '%s zg³oszeñ dotyczy! Chcesz wykonaæ zadanie?',

        # Template: AdminGroupForm
        'WARNING: When you change the name of the group \'admin\', before making the appropriate changes in the SysConfig, you will be locked out of the administrations panel! If this happens, please rename the group back to admin per SQL statement.' => 'Uwaga: Jezeli zmienisz nazwê grupy \'admin\', przed wykonaniem w³a¶ciwych zmian w SysConfig, zablokujesz panel administratorów! Je¿eli to nast±pi, przywróæ nazwê grupy admin z u¿yciem SQL.',
        'Group Management' => 'Zarz±dzanie grupami',
        'Add Group' => 'Dodaj grupê',
        'Add a new Group.' => 'Dodaj now± grupê',
        'The admin group is to get in the admin area and the stats group to get stats area.' => 'Grupa Admin pozwala posiada prawa Administracji systemem. Grupa Stats umo¿liwia przegl±danie statystyk zg³oszeñ.',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).' => 'Stwórz nowe grupy, by móc efektywniej zarz±dzaæ dostêpem do zg³oszeñ ró¼nych grup ow (np. Serwisu, Sprzeda¿y itp...).',
        'It\'s useful for ASP solutions.' => 'Pomocne w rozwi±zanich ASP.',

        # Template: AdminLog
        'System Log' => 'Log Systemu',
        'Time' => 'Czas',

        # Template: AdminMailAccount
        'Mail Account Management' => 'Zarz±dzanie kontami e-mail',
        'Host' => 'Komputer',
        'Trusted' => 'Zaufane',
        'Dispatching' => 'Przekazanie',
        'All incoming emails with one account will be dispatched in the selected queue!' => 'Wszystkie przychodz±ce na jedno konto wiadomo¶ci bêd± umieszczone w zaznacznej kolejce!',
        'If your account is trusted, the already existing X-OTRS header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' => 'Jezeli konto jest zaufane, istniej±ce w chwili przybycia nag³ówki X-OTRS (priorytet, ...) zostan± u¿yte! Filtr PostMaster zostanie wykonany.',

        # Template: AdminNavigationBar
        'Users' => 'U¿ytkownicy',
        'Groups' => 'Grupy',
        'Misc' => 'Ró¿ne',

        # Template: AdminNotificationEventForm
        'Notification Management' => 'Konfiguracja Powiadomieñ',
        'Add Notification' => '',
        'Add a new Notification.' => '',
        'Name is required!' => 'Nazwa jest wymagana!',
        'Event is required!' => '',
        'A message should have a body!' => 'Wiadomo¶æ powinna zawieraæ jak±¶ tre¶æ!',
        'Recipient' => '',
        'Group based' => '',
        'Recipient' => '',
        'Agent based' => '',
        'Email based' => '',
        'Article Type' => '',
        'Only for ArticleCreate Event.' => '',
        'Subject match' => '',
        'Only for ArticleCreate Event.' => '',
        'Body match' => '',
        'Notifications are sent to an agent or a customer.' => 'Powiadomienia s± wysy³ane do agenta obs³ugi lub klienta',
        'To get the first 20 character of the subject (of the latest agent article).' => '',
        'To get the first 5 lines of the body (of the latest agent article).' => '',
        'To get the article attribute (e. g. (<OTRS_AGENT_From>, <OTRS_AGENT_To>, <OTRS_AGENT_Cc>, <OTRS_AGENT_Subject> and <OTRS_AGENT_Body>).' => '',
        'To get the first 20 character of the subject (of the latest customer article).' => '',
        'To get the first 5 lines of the body (of the latest customer article).' => '',

        # Template: AdminNotificationForm
        'Notification' => 'Powiadomienie',

        # Template: AdminPackageManager
        'Package Manager' => 'Mened¿er pakietów',
        'Uninstall' => 'Odinstaluj',
        'Version' => 'Wersja',
        'Do you really want to uninstall this package?' => 'Czy na pewno chcesz odinstalowaæ ten pakiet?',
        'Reinstall' => 'Przeinstaluj',
        'Do you really want to reinstall this package (all manual changes get lost)?' => 'Czy chcesz przeinstalowaæ pakiet (wszystkie zmiany rêczne zostan± utracone)?',
        'Continue' => 'Kontynuuj',
        'Install' => 'Instaluj',
        'Package' => 'Pakiet',
        'Online Repository' => 'Baza on-line',
        'Vendor' => 'Wydawca',
        'Module documentation' => 'Dokumentacja modu³u',
        'Upgrade' => 'Aktualizacja',
        'Local Repository' => 'Lokalna baza',
        'Status' => 'Status',
        'Overview' => 'Podsumowanie',
        'Download' => 'Pobierz',
        'Rebuild' => 'Przebuduj',
        'ChangeLog' => 'Lista zmian',
        'Date' => 'Data',
        'Filelist' => 'Lista plików',
        'Download file from package!' => 'Pobierz plik z pakietu!',
        'Required' => 'Wymagany',
        'PrimaryKey' => 'Klucz podstawowy',
        'AutoIncrement' => 'Zwiêkszaj automatycznie',
        'SQL' => 'SQL',
        'Diff' => 'Ró¿nica',

        # Template: AdminPerformanceLog
        'Performance Log' => 'Log wydajnosci',
        'This feature is enabled!' => 'Ta funkcja jest w³±czona!',
        'Just use this feature if you want to log each request.' => 'Wybierz t± opcjê jezeli chcesz logowaæ ka¿de ¿±danie.',
        'Activating this feature might affect your system performance!' => '',
        'Disable it here!' => 'Wy³±cz tutaj!',
        'This feature is disabled!' => 'Ta funkcja jest wy³±czona!',
        'Activating this feature might affect your system performance!' => '',
        'Enable it here!' => 'W³±cz tutaj!',
        'Logfile too large!' => 'Plik log jest za du¿y!',
        'Logfile too large, you need to reset it!' => 'Plik log jest za du¿y, nale¿y go usun±æ!',
        'Range' => 'Zakres',
        'Interface' => 'Interfejs',
        'Requests' => '¯±dania',
        'Min Response' => 'Min. odpowied¼',
        'Max Response' => 'Max odpowied¼',
        'Average Response' => '¦rednia odpowied¼',
        'Period' => 'Okres',
        'Min' => 'Min.',
        'Max' => 'Max.',
        'Average' => '¦rednia',

        # Template: AdminPGPForm
        'PGP Management' => 'Zarz±dzanie PGP',
        'Result' => 'Wynik',
        'Identifier' => 'Identyfikator',
        'Bit' => 'Bit',
        'Key' => 'Klucz',
        'Fingerprint' => 'Znacznik (fingerprint)',
        'Expires' => 'Wygasa',
        'In this way you can directly edit the keyring configured in SysConfig.' => 'W ten sposób mozesz bezpo¶rednio edytowaæ plik kluczy skonfigurowany w SysConfig.',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => 'Zarz±dzanie filtrami poczty',
        'Filtername' => 'Nazwa filtra',
        'Stop after match' => 'Zatrzymaj po dopasowaniu',
        'Match' => 'Odpowiada',
        'Header' => '',
        'Value' => 'Warto¶æ',
        'Set' => 'Ustaw',
        'Do dispatch or filter incoming emails based on email X-Headers! RegExp is also possible.' => 'Dostarcz lub filtruj przychodz±ce wiadomo¶ci w oparciu o nag³ówki X-Headers! Wyra¿enia regularne (RegExp) tak¿e mog± byæ u¿yte.',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' => 'Je¿eli chcesz tylko dopasowaæ adres e-mail u¿yj EMAILADDRESS:info@example.com w polach Od, Do lub Cc.',
        'If you use RegExp, you also can use the matched value in () as [***] in \'Set\'.' => 'Je¿eli u¿ywasz wzorców regularnych (RegExp), mo¿esz tak¿e u¿yæ dopasowanych warto¶ci w () jako [***] w \'Set\'.',

        # Template: AdminPriority
        'Priority Management' => 'Zarz±dzanie priorytetami',
        'Add Priority' => 'Dodaj priorytet',
        'Add a new Priority.' => 'Dodaj nowy priorytet',

        # Template: AdminQueueAutoResponseForm
        'Queue <-> Auto Responses Management' => 'Kolejka <-> Zarz±dzanie automatycznymi odpowiedziami',
        'settings' => 'ustawienia',

        # Template: AdminQueueForm
        'Queue Management' => 'Zarzadzanie kolejkami',
        'Sub-Queue of' => 'Kolejka podrzêdna',
        'Unlock timeout' => 'Limit czasowy odblokowania',
        '0 = no unlock' => '0 = bez odblokowania',
        'Only business hours are counted.' => 'Tylko godziny pracy s± liczone.',
        '0 = no escalation' => '0 = brak eskalacji',
        'Notify by' => 'Powiadom przez',
        'Follow up Option' => 'Opcja Follow Up',
        'Ticket lock after a follow up' => 'Zg³oszenie zablokowane po odpowiedzi (Follow Up)',
        'Systemaddress' => 'Adres systemowy',
        'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.' => 'Je¶li agent zablokuje zg³oszenie, a nastêpnie nie odpowie na nie w ci±gu wskazanego czasu, wtedy zg³oszenie zostanie automatycznie odblokowane. Dziêki temu pozostali agenci bêd± mogli je zobaczyæ.',
        'Escalation time' => 'Czas eskalacji',
        'If a ticket will not be answered in this time, just only this ticket will be shown.' => 'Je¶li, w podanym czasie, nie zostanie udzielona odpowied¼ na zg³oszenie, wtedy tylko to zg³oszenie bêdzie widoczne w kolejce.',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.' => 'Je¶li zg³oszenie by³o zamkniête, a klient przy¶le do niego kolejn± odpowied¼, wtedy zg³oszenie zostanie zablokowane w kolejce starego w³a¶ciciela.',
        'Will be the sender address of this queue for email answers.' => 'Bêdzie adresem nadawcy odpowiedzi emailowych wysy³anych z tej kolejki.',
        'The salutation for email answers.' => 'Zwrot grzeczno¶ciowy dla odpowiedzi emailowych.',
        'The signature for email answers.' => 'Podpis dla odpowiedzi emailowych.',
        'Customer Move Notify' => 'Powiadomienie klienta o przesuniêciu',
        'OTRS sends an notification email to the customer if the ticket is moved.' => 'System wy¶le powiadomienie do klienta, gdy zg³oszenie zostanie przesuniête do innej kolejki.',
        'Customer State Notify' => 'Powiadomienie klienta o zmianie statusu',
        'OTRS sends an notification email to the customer if the ticket state has changed.' => 'System wy¶le powiadomienie do klienta, gdy zmieni sie status zg³oszenia.',
        'Customer Owner Notify' => 'Powiadomienie klienta o zmianie w³a¶ciciela',
        'OTRS sends an notification email to the customer if the ticket owner has changed.' => 'System wy¶le powiadomienie do klienta, gdy zmieni sie w³a¶ciciel zg³oszenia.',

        # Template: AdminQueueResponsesChangeForm
        'Responses <-> Queue Management' => 'Odpowiedzi <-> Zarz±dzanie kolejkami',

        # Template: AdminQueueResponsesForm
        'Answer' => 'Odpowied¼',

        # Template: AdminResponseAttachmentChangeForm
        'Responses <-> Attachments Management' => 'Odpowiedzi <-> Zarz±dzanie za³±cznikami',

        # Template: AdminResponseAttachmentForm

        # Template: AdminResponseForm
        'Response Management' => 'Konfiguracja Odpowiedzi',
        'A response is default text to write faster answer (with default text) to customers.' => 'Odpowied¼ to domy¶lny tekst wstawiany do odpowiedzi klientowi, dziêki czemu agent mo¿e szybciej odpowiedzieæ na zg³oszenie.',
        'Don\'t forget to add a new response a queue!' => 'Nie zapomnij powi±zaæ nowej odpowiedzi z jak±¶ kolejk±!',
        'The current ticket state is' => 'Aktualny status zg³oszenia to',
        'Your email address is new' => 'Ustawiono nowy adres e-mail',

        # Template: AdminRoleForm
        'Role Management' => 'Zarz±dzanie rolami',
        'Add Role' => 'Dodaj rolê',
        'Add a new Role.' => 'Dodaj now± rolê',
        'Create a role and put groups in it. Then add the role to the users.' => 'Utwórz rolê i dodaj grupê do niej. Potem dodaj rolê do u¿ytkownika.',
        'It\'s useful for a lot of users and groups.' => 'U¿yteczne dla wielu u¿ytkowników i grup.',

        # Template: AdminRoleGroupChangeForm
        'Roles <-> Groups Management' => 'Role <-> Zarz±dzanie grupami',
        'move_into' => 'przesuñ do',
        'Permissions to move tickets into this group/queue.' => 'Uprawnienia do przesuwania zg³oszeñ do tej grupy/kolejki',
        'create' => 'utwórz',
        'Permissions to create tickets in this group/queue.' => 'Uprawnienia do tworzenia zg³oszeñ w tej grupie/kolejce',
        'owner' => 'w³a¶ciciel',
        'Permissions to change the ticket owner in this group/queue.' => 'Uprawnienia do zmiany w³a¶ciciela zg³oszenia w tej grupie/kolejce',
        'priority' => 'priorytet',
        'Permissions to change the ticket priority in this group/queue.' => 'Uprawnienia do zmiany priorytetu zg³oszenia w tej grupie/kolejce',

        # Template: AdminRoleGroupForm
        'Role' => 'Rola',

        # Template: AdminRoleUserChangeForm
        'Roles <-> Users Management' => ' Role <-> Zarz±dzanie u¿ytkownikami',
        'Select the role:user relations.' => 'Wybierz role: relacje u¿ytkowników.',

        # Template: AdminRoleUserForm

        # Template: AdminSalutationForm
        'Salutation Management' => 'Konfiguracja zwrotów grzeczno¶ciowych',
        'Add Salutation' => 'Dodaj zwrot grzeczno¶ciowy',
        'Add a new Salutation.' => 'Dodaj nowy zwrot grzeczno¶ciowy',

        # Template: AdminSecureMode
        'Secure Mode need to be enabled!' => '',
        'Secure mode will (normally) be set after the initial installation is completed.' => '',
        'Secure mode must be disabled in order to reinstall using the web-installer.' => '',
        'If Secure Mode is not activated, activate it via SysConfig because your application is already running.' => '',

        # Template: AdminSelectBoxForm
        'SQL Box' => 'Konsola SQL',
        'Limit' => '',
        'CVS' => '',
        'HTML' => '',
        'Select Box Result' => 'Wyniki Zapytania',

        # Template: AdminService
        'Service Management' => 'Konfiguracja us³ug',
        'Add Service' => 'Dodaj us³ugê',
        'Add a new Service.' => 'Dodaj now± us³ugê',
        'Sub-Service of' => 'Us³uga podrzêdna wobec',

        # Template: AdminSession
        'Session Management' => 'Zarz±dzanie sesjami',
        'Sessions' => 'Sesje',
        'Uniq' => 'Unikalne',
        'Kill all sessions' => 'Zakoñcz wszystkie sesje',
        'Session' => 'Sesja',
        'Content' => 'Zawarto¶æ',
        'kill session' => 'Zamknij sesjê',

        # Template: AdminSignatureForm
        'Signature Management' => 'Konfiguracja podpisów',
        'Add Signature' => 'Dodaj podpis',
        'Add a new Signature.' => 'Dodaj nowy podpis',

        # Template: AdminSLA
        'SLA Management' => 'KOnfiguracja SLA',
        'Add SLA' => 'Dodaj SLA',
        'Add a new SLA.' => 'Dodaj now± SLA',

        # Template: AdminSMIMEForm
        'S/MIME Management' => 'Konfiguracja S/MIME',
        'Add Certificate' => 'Dodaj certyfikat',
        'Add Private Key' => 'Dodaj klucz prywatny',
        'Secret' => 'Has³o',
        'Hash' => 'Skrót (hash)',
        'In this way you can directly edit the certification and private keys in file system.' => 'W taki sposób mo¿esz bezpo¶rednio edytowaæ certyfikaty i klucze prywarne w systemie plików',

        # Template: AdminStateForm
        'State Management' => 'Konfiguracja statusów',
        'Add State' => 'Dodaj status',
        'Add a new State.' => 'Dodaj nowy status',
        'State Type' => 'Typ statusu',
        'Take care that you also updated the default states in you Kernel/Config.pm!' => 'Pamiêtaj, by auktualniæ równie¿ domy¶lne statusy w pliku Kernel/Config.pm !',
        'See also' => 'Zobacz tak¿e',

        # Template: AdminSysConfig
        'SysConfig' => 'Konfiguracja systemu',
        'Group selection' => 'Wybierz grupê',
        'Show' => 'Poka¿',
        'Download Settings' => 'Pobierz ustawienia',
        'Download all system config changes.' => 'Pobierz wszystkie ustawienia systemowe.',
        'Load Settings' => 'Za³aduj ustawienia',
        'Subgroup' => 'Podgrupa',
        'Elements' => 'Elementy',

        # Template: AdminSysConfigEdit
        'Config Options' => 'Opcje konfiguracyjne',
        'Default' => 'Domyslne',
        'New' => 'Nowe',
        'New Group' => 'Nowa grupa',
        'Group Ro' => 'Grupa ro',
        'New Group Ro' => 'Nowa grupa ro',
        'NavBarName' => 'Nazwa paska nawigacyjnego',
        'NavBar' => 'Pasek nawigacyjny',
        'Image' => 'Obraz',
        'Prio' => 'Priorytet',
        'Block' => 'Blok',
        'AccessKey' => 'Klawisz skrótu',

        # Template: AdminSystemAddressForm
        'System Email Addresses Management' => 'Konfiguracja adresów email Systemu',
        'Add System Address' => 'Dodaj adres systemowy',
        'Add a new System Address.' => 'Dodaj nowy adres systemowy',
        'Realname' => 'Prawdziwe Imiê i Nazwisko',
        'All email addresses get excluded on replaying on composing an email.' => 'Wszystkie adresy e-mail zostan± wykluczone z odpowiedzi.',
        'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!' => 'Wszystkie wiadomo¶ci przys³ane na ten adres w polu (Do:) zostan± umieszczone w tej kolejce.',

        # Template: AdminTypeForm
        'Type Management' => 'Zarz±dzanie typami',
        'Add Type' => 'Dodaj typ',
        'Add a new Type.' => 'Dodaj nowy typ',

        # Template: AdminUserForm
        'User Management' => 'Zarz±dzanie u¿ytkownikami',
        'Add User' => 'Dodaj agenta',
        'Add a new Agent.' => 'Dodaj nowego agenta',
        'Login as' => 'Zaloguj jako',
        'Title{user}' => '',
        'Firstname' => 'Imiê',
        'Lastname' => 'Nazwisko',
        'Start' => 'Pocz±tek',
        'End' => 'Koniec',
        'User will be needed to handle tickets.' => 'U¿ytkownik bêdzie niezbêdny do obs³ugi zg³oszenia.',
        'Don\'t forget to add a new user to groups and/or roles!' => 'Nie zapomnij dodaæ u¿ytkownika do grup i/lub ról!',

        # Template: AdminUserGroupChangeForm
        'Users <-> Groups Management' => 'U¿ytkownicy <-> Zarz±dzanie grupami',

        # Template: AdminUserGroupForm

        # Template: AgentBook
        'Address Book' => 'Ksi±¿ka adresowa',
        'Return to the compose screen' => 'Powróæ do ekranu edycji',
        'Discard all changes and return to the compose screen' => 'Anuluj wszystkie zmiany i powróæ do ekranu edycji',

        # Template: AgentCalendarSmall

        # Template: AgentCalendarSmallIcon

        # Template: AgentCustomerSearch

        # Template: AgentCustomerTableView

        # Template: AgentDashboard
        'Dashboard' => '',
        'more' => '',
        'Settings' => '',
        'Expand' => '',
        'Collapse' => '',

        # Template: AgentDashboardCalendarOverview
        'in' => '',

        # Template: AgentDashboardImage

        # Template: AgentDashboardProductNotify
        '%s %s is available!' => '',
        'Please update now.' => '',
        'Release Note' => '',
        'Level' => '',

        # Template: AgentDashboardRSSOverview
        'Posted %s ago.' => '',

        # Template: AgentDashboardTicketOverview

        # Template: AgentDashboardTicketStats
        'Closed' => '',

        # Template: AgentInfo
        'Info' => 'Info',

        # Template: AgentLinkObject
        'Link Object: %s' => 'Przypisz obiekt: %s',
        'Object' => 'Obiekt',
        'Link Object' => 'Przypisz obiekt',
        'with' => 'z',
        'Select' => 'Zaznacz',
        'Unlink Object: %s' => 'Oddziel obiekt: %s',

        # Template: AgentLookup
        'Lookup' => 'Wyszukiwanie',

        # Template: AgentNavigationBar

        # Template: AgentPreferencesForm

        # Template: AgentSpelling
        'Spell Checker' => 'S³ownik',
        'spelling error(s)' => 'b³êdów jêzykowych',
        'or' => 'lub',
        'Apply these changes' => 'Zastosuj te zmiany',

        # Template: AgentStatsDelete
        'Do you really want to delete this Object?' => 'Na pewno chcesz usun±æ ten obiekt?',

        # Template: AgentStatsEditRestrictions
        'Select the restrictions to characterise the stat' => 'Wybierz ograniczenia do opisania raportu.',
        'Fixed' => 'Sta³y',
        'Please select only one element or turn off the button \'Fixed\'.' => 'Wybierz jeden element lub odznacz przycisk \'Sta³y\'',
        'Absolut Period' => 'Bezwzglêdny przedzia³',
        'Between' => 'Pomiedzy',
        'Relative Period' => 'Wzgledny przedzia³',
        'The last' => 'Ostatni',
        'Finish' => 'Koniec',
        'Here you can make restrictions to your stat.' => 'Tu mo¿esz na³o¿yæ ograniczenia na swój raport.',
        'If you remove the hook in the "Fixed" checkbox, the agent generating the stat can change the attributes of the corresponding element.' => 'Je¿eli usuniesz znacznik  w polu "Fixed", agent bêdzie móg³ zmieniæ atrybuty powiazanego elementu.',

        # Template: AgentStatsEditSpecification
        'Insert of the common specifications' => 'Wstaw podstawowe parametry',
        'Permissions' => 'Prawa',
        'Format' => 'Format',
        'Graphsize' => 'Wielko¶æ wykresu',
        'Sum rows' => 'Suma wierszy',
        'Sum columns' => 'Suma kolumn',
        'Cache' => 'Pamiêæ podrêczna',
        'Required Field' => 'Pole wymagane',
        'Selection needed' => 'Wybór wymagany',
        'Explanation' => 'Wyja¶nienie',
        'In this form you can select the basic specifications.' => 'W tym formularzu mo¿esz wybraæ podstawowe parametry.',
        'Attribute' => 'Atrybut',
        'Title of the stat.' => 'Tytu³ statystyki.',
        'Here you can insert a description of the stat.' => 'Tu mo¿esz dodaæ opis startstyki.',
        'Dynamic-Object' => 'Obiekt dynamiczny',
        'Here you can select the dynamic object you want to use.' => 'Tu mo¿esz wybraæ obiekt dynamiczny którego chcesz u¿yæ.',
        '(Note: It depends on your installation how many dynamic objects you can use)' => '(Uwaga: Od instalacji zale¿y ile obiektów dynamicznych mo¿esz u¿yæ)',
        'Static-File' => 'Plik statyczny',
        'For very complex stats it is possible to include a hardcoded file.' => 'Dla bardzo skomplikowanych statystyk mo¿na u¿yæ pliku prekompilowanego.',
        'If a new hardcoded file is available this attribute will be shown and you can select one.' => 'Je¿eli nowy plik prekompilowany bedzie dostepny, ten atrybut zostanie wy¶wietlony i bedziesz móg³ wybraæ jeden.',
        'Permission settings. You can select one or more groups to make the configurated stat visible for different agents.' => 'Ustawienia dostepu. Wybierz grupy mog±ce udostêpniaæ przygotowane raporty dla innych agentów.',
        'Multiple selection of the output format.' => 'Wielokrotny wybór formatu wyjsciowego.',
        'If you use a graph as output format you have to select at least one graph size.' => 'Je¿eli u¿ywasz wykresu jako formaty wyjsciowego musisz okresliæ jego rozmiar.',
        'If you need the sum of every row select yes' => 'Je¿eli chcesz sumowaæ wiersze wybierz tak.',
        'If you need the sum of every column select yes.' => 'Je¿eli chcesz sumowaæ kolumny wybierz tak.',
        'Most of the stats can be cached. This will speed up the presentation of this stat.' => 'Wiêkszo¶æ raportów mo¿e byæ umieszczona w pamiêci podrêcznej. Przyspiesza to wy¶wietlanie tych raportów.',
        '(Note: Useful for big databases and low performance server)' => '(Uwaga: U¿yteczne dla duzych baz i wolnych serwerów)',
        'With an invalid stat it isn\'t feasible to generate a stat.' => 'Niewa¿ny raport nie mo¿e zostaæ wygenerowany.',
        'This is useful if you want that no one can get the result of the stat or the stat isn\'t ready configurated.' => 'To jest u¿yteczna blokada je¿eli chcesz uniemo¿liwiæ generowanie raportu przed zakoñczeniem tworzenia wzorca.',

        # Template: AgentStatsEditValueSeries
        'Select the elements for the value series' => 'Wybierz elementy dla serii danych',
        'Scale' => 'Skala',
        'minimal' => 'minimum',
        'Please remember, that the scale for value series has to be larger than the scale for the X-axis (e.g. X-Axis => Month, ValueSeries => Year).' => 'Pamiêtaj ¿e skala warto¶ci moze byæ wiêksza od skali osi X (np. o¶ X => Miesi±ce, Warto¶ci => Rok).',
        'Here you can define the value series. You have the possibility to select one or two elements. Then you can select the attributes of elements. Each attribute will be shown as single value series. If you don\'t select any attribute all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' => 'Tu mozesz zdefiniowac warto¶ci. Mo¿esz wybraæ jeden lub dwa elementy. Potemmozesz wybrac atrybuty elementów. Ka¿dy atrybut zostanie pokazany jako seria warto¶ci. Jezeli nie wybierzesz ¿adnego z atrybutów elementu wszystkie zostana u¿yte przy generowaniu raportu. Tak samo jak nowe atrybuty dodane po ostatniej konfiguracji szablonu.',

        # Template: AgentStatsEditXaxis
        'Select the element, which will be used at the X-axis' => 'Wybierz element który bêdzie uzyty jako o¶ X',
        'maximal period' => 'maksymalny przedzia³',
        'minimal scale' => 'minimalna skala',
        'Here you can define the x-axis. You can select one element via the radio button. If you make no selection all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' => '',

        # Template: AgentStatsImport
        'Import' => 'Import',
        'File is not a Stats config' => 'Plik nie jest szablonem rapoortu',
        'No File selected' => 'Nie wybrano pliku',

        # Template: AgentStatsOverview
        'Results' => 'Wyniki',
        'Total hits' => 'Wszystkich trafieñ',
        'Page' => 'Strona',

        # Template: AgentStatsPrint
        'Print' => 'Drukuj',
        'No Element selected.' => 'Nie wybrano elementu.',

        # Template: AgentStatsView
        'Export Config' => 'Eksportuj Config',
        'Information about the Stat' => 'Informacja o szablonie',
        'Exchange Axis' => 'Zamieñ osie',
        'Configurable params of static stat' => 'Konfigurowalne parametry statycznego raportu',
        'No element selected.' => 'Nie wybrano elementu',
        'maximal period from' => 'maksymalny przedzia³ od',
        'to' => 'do',
        'With the input and select fields you can configurate the stat at your needs. Which elements of a stat you can edit depends on your stats administrator who configurated the stat.' => 'Mo¿esz utworzyæ szablony z wykorzystaniem pól wyboru i wprowadzania danych wed³ug w³asnych potrzeb. Które elementy mo¿esz edytowaæ okre¶li³ administrator statystyk który konfigurowa³ modu³ statystyk.',

        # Template: AgentTicketBounce
        'A message should have a To: recipient!' => 'Wiadomo¶æ musi zawieraæ wype³nione adresem polu Do: (odbiorca)!',
        'You need a email address (e. g. customer@example.com) in To:!' => 'W polu Do: musi znale¼æ siê adres email (np. klient@przyklad.pl)!',
        'Bounce ticket' => 'Odbij zg³oszenie',
        'Ticket locked!' => 'Zg³oszenie zablokowane!',
        'Ticket unlock!' => 'Zg³oszenie odblokowane!',
        'Bounce to' => 'Odbij do',
        'Next ticket state' => 'Nastêpny status zg³oszenia',
        'Inform sender' => 'Powiadom nadawcê',
        'Send mail!' => 'Wy¶lij wiadomo¶æ!',

        # Template: AgentTicketBulk
        'You need to account time!' => 'Musisz zaraportowaæ czas!',
        'Ticket Bulk Action' => 'Akcja grupowa',
        'Spell Check' => 'Sprawd¼ poprawno¶æ',
        'Note type' => 'Typ notatki',
        'Next state' => 'Nastêpny status',
        'Pending date' => 'Data oczekiwania',
        'Merge to' => 'Przy³±cz do',
        'Merge to oldest' => 'Przy³±cz do najstarszego',
        'Link together' => 'Po³±cz razem',
        'Link to Parent' => 'Do³±cz do rodzica',
        'Unlock Tickets' => 'Odblokuj zg³oszenia',

        # Template: AgentTicketClose
        'Ticket Type is required!' => 'Typ zg³oszenia jest wymagany!',
        'A required field is:' => 'Wymagane pole to:',
        'Close ticket' => 'Zamknij zg³oszenie',
        'Previous Owner' => 'Poprzedni w³a¶ciciel',
        'Inform Agent' => 'Poinformuj agenta',
        'Optional' => 'Opcjonalny',
        'Inform involved Agents' => 'Poinformuj zaanga¿owanych agentów',
        'Attach' => 'Wstaw',

        # Template: AgentTicketCompose
        'A message must be spell checked!' => 'Wiadomo¶æ musi zostaæ sprawdzona s³ownikiem!',
        'Compose answer for ticket' => 'Edytuj odpowied¼ na zg³oszenie',
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

        # Template: AgentTicketEmail
        'Compose Email' => 'Nowa wiadomo¶æ',
        'new ticket' => 'Nowe zg³oszenie',
        'Refresh' => 'Odswie¿',
        'Clear To' => 'Wyczy¶æ do',
        'All Agents' => 'Wszyscy agenci',

        # Template: AgentTicketEscalation

        # Template: AgentTicketForward
        'Article type' => 'Typ artyku³u',

        # Template: AgentTicketFreeText
        'Change free text of ticket' => 'Dodaj lub zmieñ dodatkowe informacje o zg³oszeniu',

        # Template: AgentTicketHistory
        'History of' => 'Historia',

        # Template: AgentTicketLocked

        # Template: AgentTicketMerge
        'You need to use a ticket number!' => 'Musisz u¿yæ numeru zg³oszenia!',
        'Ticket Merge' => 'Scal zg³oszenie',

        # Template: AgentTicketMove
        'If you want to account time, please provide Subject and Text!' => '',
        'Move Ticket' => 'Przesuñ zg³oszenie',

        # Template: AgentTicketNote
        'Add note to ticket' => 'Dodaj notatkê do zg³oszenia',

        # Template: AgentTicketOverviewMedium
        'First Response Time' => 'Czas pierwszej odpowiedzi',
        'Service Time' => 'Czas obs³ugi',
        'Update Time' => 'Czas aktualizacji',
        'Solution Time' => 'Czas rozwiazania',

        # Template: AgentTicketOverviewMediumMeta
        'You need min. one selected Ticket!' => 'Musisz wybraæ conajmniej jedno zg³oszenie!',
        'Bulk Action' => '',

        # Template: AgentTicketOverviewNavBar
        'Filter' => 'Filtr',
        'Change search options' => 'Zmieñ kryteria wyszukiwania',
        'Tickets' => 'Zg³oszenia',
        'of' => 'z',

        # Template: AgentTicketOverviewNavBarSmall

        # Template: AgentTicketOverviewPreview
        'Compose Answer' => 'Napisz odpowied¼',
        'Contact customer' => 'Skontaktuj siê z klientem',
        'Change queue' => 'Zmieñ kolejkê',

        # Template: AgentTicketOverviewPreviewMeta

        # Template: AgentTicketOverviewSmall
        'sort upward' => 'sortuj rosn±co',
        'up' => 'góra',
        'sort downward' => 'sortuj malej±co',
        'down' => 'dó³',
        'Escalation in' => 'Eskalowane w',
        'Locked' => 'Zablokowane',

        # Template: AgentTicketOwner
        'Change owner of ticket' => 'Zmieñ w³a¶ciciela zg³oszenia',

        # Template: AgentTicketPending
        'Set Pending' => 'Ustaw oczekiwanie',

        # Template: AgentTicketPhone
        'Phone call' => 'Telefon',
        'Clear From' => 'Wyczy¶æ pole Od:',

        # Template: AgentTicketPhoneOutbound

        # Template: AgentTicketPlain
        'Plain' => 'Puste',

        # Template: AgentTicketPrint
        'Ticket-Info' => 'Informacje o zg³oszeniu',
        'Accounted time' => 'Zaraportowany czas',
        'Linked-Object' => 'Powi±zany obiekt',
        'by' => 'przez',

        # Template: AgentTicketPriority
        'Change priority of ticket' => 'Zmieñ priorytet zg³oszenia',

        # Template: AgentTicketQueue
        'Tickets shown' => 'Pokazane zg³oszenia',
        'Tickets available' => 'Dostêpne zg³oszenia',
        'All tickets' => 'Wszystkie zg³oszenia',
        'Queues' => 'Kolejki',
        'Ticket escalation!' => 'Eskalacja zg³oszenia!',

        # Template: AgentTicketResponsible
        'Change responsible of ticket' => 'Zmieñ odpowiedzialnego za zg³oszenie',

        # Template: AgentTicketSearch
        'Ticket Search' => 'Wyszukiwanie zg³oszenia',
        'Profile' => 'Profil',
        'Search-Template' => 'Szablon wyszukiwania',
        'TicketFreeText' => 'Dodatkowe informacje o zg³oszeniu',
        'Created in Queue' => 'Utworzono w kolejce',
        'Article Create Times' => 'Czasy utworzenia artyku³u',
        'Article created' => 'Artuku³ utworzono',
        'Article created between' => 'Artuku³ utworzono pomiêdzy',
        'Change Times' => 'Zmieñ czasy',
        'No change time settings.' => 'Brak zmiany ustawieñ czasu',
        'Ticket changed' => 'Zg³oszenie zmieniono',
        'Ticket changed between' => 'Zg³oszenie zmieniono pomiêdzy',
        'Result Form' => 'Formularz wyników',
        'Save Search-Profile as Template?' => 'Zachowaj profil wyszukiwania jako szablon',
        'Yes, save it with name' => 'Tak, zapisz to pod nazw±',

        # Template: AgentTicketSearchOpenSearchDescriptionFulltext
        'Fulltext' => 'Pe³notekstowe',

        # Template: AgentTicketSearchOpenSearchDescriptionTicketNumber

        # Template: AgentTicketSearchResultPrint

        # Template: AgentTicketZoom
        'Expand View' => 'Rozwiñ widok',
        'Collapse View' => 'Zwiñ widok',
        'Split' => 'Podziel',

        # Template: AgentTicketZoomArticleFilterDialog
        'Article filter settings' => 'Ustawienie filtra artyku³ów',
        'Save filter settings as default' => 'Zapisz ustawienia filtru jako domy¶lne',

        # Template: AgentWindowTab

        # Template: AJAX

        # Template: Copyright

        # Template: CustomerAccept

        # Template: CustomerCalendarSmallIcon

        # Template: CustomerError
        'Traceback' => '¦led¼ wstecz',

        # Template: CustomerFooter
        'Powered by' => 'Oparte na',

        # Template: CustomerFooterSmall

        # Template: CustomerHeader

        # Template: CustomerHeaderSmall

        # Template: CustomerLogin
        'Login' => 'Login',
        'Lost your password?' => 'Zapomnia³e¶ has³a?',
        'Request new password' => 'Pro¶ba o nowe has³o',
        'Create Account' => 'Utwórz konto',

        # Template: CustomerNavigationBar
        'Welcome %s' => 'Witaj %s',

        # Template: CustomerPreferencesForm

        # Template: CustomerStatusView

        # Template: CustomerTicketMessage

        # Template: CustomerTicketPrint

        # Template: CustomerTicketSearch
        'Times' => 'Razy',
        'No time settings.' => 'Brak ustawieñ czasu',

        # Template: CustomerTicketSearchOpenSearchDescription

        # Template: CustomerTicketSearchResultCSV

        # Template: CustomerTicketSearchResultPrint

        # Template: CustomerTicketSearchResultShort

        # Template: CustomerTicketZoom

        # Template: CustomerWarning

        # Template: Error
        'Click here to report a bug!' => 'Kliknij tutaj, by zg³osiæ b³±d systemu OTRS!',

        # Template: Footer
        'Top of Page' => 'Góra strony',

        # Template: FooterSmall

        # Template: Header
        'Home' => 'Pocz±tek',

        # Template: HeaderSmall

        # Template: Installer
        'Web-Installer' => 'Instalator Web',
        'Welcome to %s' => 'Witamy w %s',
        'Accept license' => 'Akceptujê licencjê',
        'Don\'t accept license' => 'Nie akceptuje licencji',
        'Admin-User' => 'Administrator',
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty. For security reasons we do recommend setting a root password. For more information please refer to your database documentation.' => 'Je¿eli masz has³o administratora bazy danych wpisz je tutaj. Je¿eli nie, zostaw pole puste. Ze wzgledów bezpieczeñstwa zalecamy ustawienia has³a administratoa bazy danych. Po szczegó³y siêgnij do dokumentacji bazy danych.',
        'Admin-Password' => 'Has³o administratora',
        'Database-User' => 'U¿ytkownik bazy danych',
        'default \'hot\'' => 'domy¶lne \'hot\'',
        'DB connect host' => 'komputer bazy danych',
        'Database' => 'baza danych',
        'Default Charset' => 'Domy¶lne kodowanie',
        'utf8' => 'UTF8',
        'false' => 'fa³sz',
        'SystemID' => 'ID Systemu',
        '(The identify of the system. Each ticket number and each http session id starts with this number)' => '(Identyfikator systemu. Wszystkie zg³oszenia oraz sesje http bêd± zaczyna³y siê od tego ci±gu)',
        'System FQDN' => 'Pe³na domena systemu FQDN',
        '(Full qualified domain name of your system)' => '(Pe³na nazwa domeny Twojego systemu FQDN)',
        'AdminEmail' => 'Email od Admina',
        '(Email of the system admin)' => '(Adres E-Mail Administratora Systemu)',
        'Organization' => 'Organizacja',
        'Log' => 'Log',
        'LogModule' => 'Modu³ logowania',
        '(Used log backend)' => '(U¿ywany log backend)',
        'Logfile' => 'Plik logu',
        '(Logfile just needed for File-LogModule!)' => '(Logfile jest potrzebny jedynie dla modu³u File-Log!)',
        'Webfrontend' => 'Interfejs webowy',
        'Use utf-8 it your database supports it!' => 'U¿ywaj kodowania UTF-8 je¶li pozwala Ci na to baza danych!',
        'Default Language' => 'Domy¶lny jêzyk',
        '(Used default language)' => '(Domy¶lny jêzyk)',
        'CheckMXRecord' => 'Sprawd¼ rekord MX',
        '(Checks MX recordes of used email addresses by composing an answer. Don\'t use CheckMXRecord if your OTRS machine is behinde a dial-up line $!)' => '(Sprawd¼ rekord MX uzytego adresu e-mailprzy tworzeniu odpowiedzi. Nie u¿ywaj sprawdzania rekordu MX je¿eli twoja maszyna z OTRS jest na ³aczu z dynamicznym IP $!)',
        'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' => 'Musisz wpisaæ nastêpuj±ce polecenie w linii komend (Terminal/Shell).',
        'Restart your webserver' => 'Uruchom ponownie serwer WWW',
        'After doing so your OTRS is up and running.' => 'Po zakoñczeniu tych czynno¶ci Twój system OTRS bêdzie gotowy do pracy',
        'Start page' => 'Strona startowa',
        'Your OTRS Team' => 'Twój Team OTRS',

        # Template: LinkObject

        # Template: Login

        # Template: Motd

        # Template: NoPermission
        'No Permission' => 'Brak dostêpu',

        # Template: Notify
        'Important' => 'Wa¿ne',

        # Template: PrintFooter
        'URL' => 'URL',

        # Template: PrintHeader
        'printed by' => 'wydrukowane przez',

        # Template: PublicDefault

        # Template: Redirect

        # Template: RichTextEditor
        'Bold' => '',
        'CTRL' => '',
        'SHIFT' => '',
        'Italic' => '',
        'Underline' => '',
        'Font Color' => '',
        'Background Color' => '',
        'Remove Formatting' => '',
        'Show/Hide Hidden Elements' => '',
        'Align Left' => '',
        'Align Center' => '',
        'Align Right' => '',
        'Justify' => '',
        'Indent' => '',
        'Outdent' => '',
        'Create an Unordered List' => '',
        'Create an Ordered List' => '',
        'HTML Link' => '',
        'Insert Image' => '',
        'Undo' => '',
        'Redo' => '',

        # Template: Test
        'OTRS Test Page' => 'OTRS Strona testowa',
        'Counter' => 'Licznik',

        # Template: Warning

        # Misc
        'Edit Article' => 'Edytuj artyku³',
        'Create Database' => 'Stwórz bazê danych',
        'DB Host' => 'Host bazy danych',
        'Ticket Number Generator' => 'Generator numerów zg³oszeñ',
        '(Ticket identifier. Some people want toset this to e. g. \'Ticket#\', \'Call#\' or \'MyTicket#\')' => '(Identyfikator zg³oszenia. np. \'Ticket#\', \'Call#\' lub \'MyTicket#\')',
        'Create new Phone Ticket' => 'Utwórz zg³oszenie telefoniczne',
        'In this way you can directly edit the keyring configured in Kernel/Config.pm.' => 'W ten sposób mo¿na edytowaæ pêk kluczy skofigurowany w Kernel/Config.pm',
        'Symptom' => 'Objawy',
        'U' => 'G',
        'Site' => 'Witryna',
        'Customer history search (e. g. "ID342425").' => 'Przeszukiwanie historii klienta (np. "ID342425").',
        'Can not delete link with %s!' => 'Nie mo¿na usun±æ powi±zania z %s',
        'for agent firstname' => 'dla imienia agenta',
        'Close!' => 'Zamknij!',
        'No means, send agent and customer notifications on changes.' => '\'Nie\' oznacza - wy¶lij agentowi i klientowi powiadomienia o zmianach.',
        'A web calendar' => 'Kalendarz',
        'to get the realname of the sender (if given)' => 'by wstawiæ prawdziwe imiê i nazwisko klienta (je¶li podano)',
        'OTRS DB Name' => 'Nazwa bazy danych OTRS',
        'To enable automatic execusion select at least one value form minutes, hours and days!' => 'Aby w³±czyæ automatyczne wykonywanie ustaw dni, godziny i minuty!',
        'Notification (Customer)' => 'Powiadomienie (Klient)',
        'Select Source (for add)' => 'Wybierz ¼ród³o (dla dodania)',
        'Options of the ticket data (e. g. &lt;OTRS_TICKET_Number&gt;, &lt;OTRS_TICKET_ID&gt;, &lt;OTRS_TICKET_Queue&gt;, &lt;OTRS_TICKET_State&gt;)' => 'Opcjonalne dane (np. &lt;OTRS_TICKET_Number&gt;, &lt;OTRS_TICKET_ID&gt;, &lt;OTRS_TICKET_Queue&gt;, &lt;OTRS_TICKET_State&gt;)',
        'Child-Object' => 'Obiekt potomny',
        'Queue ID' => 'ID Kolejki',
        'Config options (e. g. <OTRS_CONFIG_HttpType>)' => 'Opcje konfiguracyjne (np. <OTRS_CONFIG_HttpType>)',
        'customer realname' => 'Prawdziwe dane klienta',
        'Pending messages' => 'Oczekuj±ce wiadomo¶ci',
        'for agent login' => 'dla loginu agenta',
        'Keyword' => 'S³owo kluczowe',
        'Close type' => 'Typ zamkniêcia',
        'Can\'t update password, need min. 2 characters!' => 'Nie mo¿na zmieniæ has³a, wymagane conajmniej 2 znaki!',
        'DB Admin User' => 'U¿ytkownik administruj±cy baz± danych',
        'for agent user id' => 'dla ID agenta',
        'Change user <-> group settings' => 'Zmieñ u¿ytkownika <-> Ustawienia grupy',
        'Problem' => 'Problem',
        'Escalation' => 'Eskalacja',
        '"}' => '"}',
        'Order' => 'Porz±dek',
        'next step' => 'Nastêpny krok',
        'Follow up' => 'Odpowiedz',
        'Customer history search' => 'Przeszukiwanie historii klienta',
        'Admin-Email' => 'Wiadomo¶æ od Administratora',
        'Stat#' => 'Statystyka',
        'Create new database' => 'Stwórz now± bazê danych',
        'Can\'t update password, need min. 1 digit!' => 'Nie mo¿na zmieniæ has³a, wymagana conajmniej 1 cyfra!',
        'ArticleID' => 'ID Artyku³u',
        'Go' => 'Start',
        'Keywords' => 'S³owa kluczowe',
        'Ticket Escalation View' => 'Widok eskalowanych zg³oszeñ',
        'Today' => 'Dzi¶',
        'No * possible!' => 'Nie u¿ywaj znaku "*"!',
        'Options of the current user who requested this action (e. g. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)' => 'Opcje bie¿±cego u¿ytkownika który wykona³ akcjê (np. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)',
        'Message for new Owner' => 'Wiadomo¶æ do nowego w³a¶ciciela',
        'to get the first 5 lines of the email' => 'by wstawiæ 5 pierwszych linii wiadomo¶ci',
        'Sort by' => 'Sortuj wed³ug',
        'OTRS DB Password' => 'Has³o dostêpu do bazy dla OTRS',
        'Last update' => 'Ostatnia aktualizacja',
        'Tomorrow' => 'Jutro',
        'to get the first 20 character of the subject' => 'by wstawiæ pierwsze 20 znaków tematu',
        'Select the customeruser:service relations.' => 'Wybierz relacjê klient:us³uga.',
        'DB Admin Password' => 'Has³o Administratora bazy danych',
        'Bulk-Action' => 'Akcja grupowa',
        'Drop Database' => 'Usuñ bazê danych',
        'Here you can define the x-axis. You can select one element via the radio button. Then you you have to select two or more attributes of the element. If you make no selection all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' => 'Tu mo¿esz zdefiniowac o¶ X. Mo¿esz wybraæ jeden element ze zdefiniowanych. Nastêpnie musisz wybraæ dwa lub wiêcej atrybutów wskazanego elementu. Je¿eli nie wybra³e¶ wszystkich atrybutów elementu u¿yte one zostan± przy generowaniu raportu. Tak samo jak nowe atrybuty dodane od ostatniej konfiguracji.',
        'FileManager' => 'Mened¿er plików',
        'Options of the current customer user data (e. g. <OTRS_CUSTOMER_DATA_UserFirstname>)' => 'Opcje aktualnego klienta (np. <OTRS_CUSTOMER_DATA_UserFirstname>)',
        'Pending type' => 'Typ oczekiwania',
        'Comment (internal)' => 'Komentarz (wewnêtrzny)',
        'Ticket owner options (e. g. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)' => 'Opcje w³a¶ciciela zg³oszenia (np. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)',
        'Options of the ticket data (e. g. <OTRS_TICKET_Number>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' => 'Opcje zg³oszenia (np. <OTRS_TICKET_Number>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)',
        '(Used ticket number format)' => '(U¿ywany format numerowania zg³oszeñ)',
        'Reminder' => 'Przypomnienie',
        'Can\'t update password, passwords doesn\'t match! Please try it again!' => 'Nie mo¿na zmieniæ has³a, podano ró¿ne has³a! Spróbuj ponownie!',
        'OTRS DB connect host' => 'Host bazy danych',
        ' (work units)' => ' (jednostek roboczych)',
        'Next Week' => 'Nastêpny tydzieñ',
        'All Customer variables like defined in config option CustomerUser.' => 'Wszystkie zdefiniowane zmienne klienta.',
        'accept license' => 'akceptujê Licencjê',
        'for agent lastname' => 'dla nazwiska agenta',
        'Options of the current user who requested this action (e. g. <OTRS_CURRENT_UserFirstname>)' => 'Opcje aktualnego agenta obs³ugi (np. <OTRS_CURRENT_UserFirstname>)',
        'Reminder messages' => 'Tekst przypomnienia',
        'Parent-Object' => 'Obiekt macierzysty',
        'Of couse this feature will take some system performance it self!' => 'Oczywi¶cie ta funkcja zabiera czê¶æ wydajno¶ci do obs³ugi samej siebie!',
        'Ticket Hook' => 'Identyfikator zg³oszenia',
        'Your own Ticket' => 'Twoje w³asne zg³oszenie',
        'Detail' => 'Szczegó³',
        'TicketZoom' => 'Podgl±d zg³oszenia',
        'Open Tickets' => 'Otwarte zg³oszenia',
        'Don\'t forget to add a new user to groups!' => 'Nie zapomnij dodaæ u¿ytkownika do grup!',
        'You have to select two or more attributes from the select field!' => 'Musisz wybraæ dwa lub wiêcej atrybutów z pola wyboru!',
        'System Settings' => 'Ustawienia systemu',
        'WebWatcher' => 'Obserwator Web',
        'Finished' => 'Zakoñczono',
        'D' => '',
        'All messages' => 'Wszystkie wiadomo¶ci',
        'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' => 'W³asno¶ci zg³oszenia (np. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)',
        'Object already linked as %s.' => 'Obiekt ju¿ przypisany jako %s',
        'A article should have a title!' => 'Artyku³ musi miec tytu³!',
        'Customer Users <-> Services' => 'Klienci <-> Us³ugi',
        'Config options (e. g. &lt;OTRS_CONFIG_HttpType&gt;)' => 'Parametry konfiguracyjne (np. &lt;OTRS_CONFIG_HttpType&gt;)',
        'don\'t accept license' => 'nie akceptujê Licencji',
        'All email addresses get excluded on replaying on composing and email.' => 'Wszystkie adresy zostan± pominiête przy odpowiedzi, tworzeniu i wysy³aniu wiadomo¶ci.',
        'A web mail client' => 'Klient poczty przez www',
        'Compose Follow up' => 'Napisz Odpowied¼ (Follow Up)',
        'Can\'t update password, need min. 8 characters!' => 'Nie mo¿na zmieniæ has³a, wymagane conajmniej 8 znaków!',
        'WebMail' => 'Poczta przez www',
        'Ticket owner options (e. g. <OTRS_OWNER_UserFirstname>)' => 'Opcje dotycz±ce w³a¶ciciela zg³oszenia (np. <OTRS_OWNER_UserFirstname>)',
        'DB Type' => 'Typ bazy danych',
        'kill all sessions' => 'Zamknij wszystkie sesje',
        'to get the from line of the email' => 'by wstawiæ pole Od wiadomo¶ci',
        'Solution' => 'Rozwi±zanie',
        'QueueView' => 'Przegl±d kolejki',
        'Select Box' => 'Zapytanie SQL',
        'New messages' => 'Nowe wiadomo¶ci',
        'Can not create link with %s!' => 'Nie po³±czono z %s!',
        'Linked as' => 'Po³±czono jako',
        'Welcome to OTRS' => 'Witamy w OTRS',
        'modified' => 'zmieniony',
        'Delete old database' => 'Usuñ star± bazê danych',
        'A web file manager' => 'Mened¿er plików przez www ',
        'Have a lot of fun!' => '¯yczymy dobrej zabawy!',
        'send' => 'wy¶lij',
        'Send no notifications' => 'Wy¶lij bez powiadomieñ',
        'Note Text' => 'Tekst notatki',
        'POP3 Account Management' => 'Konfiguracja kont POP3',
        'Options of the current customer user data (e. g. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)' => 'Cechy aktualnego klienta (np. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)',
        'System State Management' => 'Konfiguracja statusów',
        'OTRS DB User' => 'U¿ytkownik bazy danych OTRS',
        'Mailbox' => 'Skrzynka',
        'PhoneView' => 'Nowy telefon',
        'maximal period form' => 'maksymalny okres formularza',
        'TicketID' => 'ID Zg³oszenia',
        'Yes means, send no agent and customer notifications on changes.' => '\'Tak\' oznacza - nie wysy³aj powiadomieñ agentowi i klientowpi przy zmianach.',
        'Can\'t update password, need 2 lower and 2 upper characters!' => 'Nie mo¿na zmieniæ has³a, wymagane 2 ma³e i 2 wielkie litery!',
        'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further information.' => 'Twoja wiadomo¶æ o numerze zg³oszenia: "<OTRS_TICKET>" zosta³a przekazana na adres "<OTRS_BOUNCE_TO>" . Prosimy kontaktowaæ siê pod tym adresem we wszystkich sprawach dotycz±cych tego zg³oszenia.',
        'Ticket Status View' => 'Status zg³oszenia',
        'Modified' => 'Zmodyfikowany',
        'Ticket selected for bulk action!' => 'Zg³oszenie wybrano do akcji grupowej!',
        '%s is not writable!' => '',
        'Cannot create %s!' => '',
    };
    # $$STOP$$
    return;
}

1;
