# --
# Kernel/Language/pl.pm - provides Polish language translation
# Copyright (C) 2003-2010 Tomasz Melissa <janek at rumianek.com>
# Copyright (C) 2009 Artur Skalski <skal.ar at wp.pl>
# Copyright (C) 2011-2013 Informatyka Boguslawski sp. z o.o. sp.k., http://www.ib.pl/
# Copyright (C) 2014 Wojciech Myrda <wmyrda at auticon.pl>, http://www.auticon.pl
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::pl;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # $$START$$
    # possible charsets
    $Self->{Charset} = ['utf-8', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Year;)
    $Self->{DateFormat}          = '%Y-%M-%D %T';
    $Self->{DateFormatLong}      = '%A %Y-%M-%D %T';
    $Self->{DateFormatShort}     = '%Y-%M-%D';
    $Self->{DateInputFormat}     = '%Y-%M-%D';
    $Self->{DateInputFormatLong} = '%Y-%M-%D - %T';

    # csv separator
    $Self->{Separator} = ';';

    $Self->{Translation} = {

        # Template: AAABase
        'Yes' => 'Tak',
        'No' => 'Nie',
        'yes' => 'tak',
        'no' => 'nie',
        'Off' => 'Wyłączone',
        'off' => 'wyłączone',
        'On' => 'Włączone',
        'on' => 'włączone',
        'top' => 'góra',
        'end' => 'koniec',
        'Done' => 'Zrobione',
        'Cancel' => 'Anuluj',
        'Reset' => 'Resetuj',
        'more than ... ago' => 'wcześniej niż ...',
        'in more than ...' => 'później niź ...',
        'within the last ...' => 'w ciągu ostatniego/ich ...',
        'within the next ...' => 'w ciągu następneego/ych ...',
        'Created within the last' => 'Utworzone w ciągu ostatniego/ich',
        'Created more than ... ago' => 'Utworzone wcześniej niż ...',
        'Today' => 'Dziś',
        'Tomorrow' => 'Jutro',
        'Next week' => 'Następny tydzień',
        'day' => 'dzień',
        'days' => 'dni',
        'day(s)' => 'dzień(dni)',
        'd' => 'd',
        'hour' => 'godzina',
        'hours' => 'godz.',
        'hour(s)' => 'godz.',
        'Hours' => 'Godziny',
        'h' => 'h',
        'minute' => 'minuta',
        'minutes' => 'minut',
        'minute(s)' => 'minuta(minut)',
        'Minutes' => 'Minuty',
        'm' => 'm',
        'month' => 'miesiąc',
        'months' => 'miesięcy',
        'month(s)' => 'miesiąc(-cy)',
        'week' => 'tydzień',
        'week(s)' => 'tydzień(tygodnie)',
        'year' => 'rok',
        'years' => 'lat',
        'year(s)' => 'rok(lat)',
        'second(s)' => 'sekund(a)',
        'seconds' => 'sekund',
        'second' => 'drugi',
        's' => 's',
        'Time unit' => 'Jednostka czasu',
        'wrote' => 'napisał(a)',
        'Message' => 'Wiadomość',
        'Error' => 'Błąd',
        'Bug Report' => 'Zgłoś błąd',
        'Attention' => 'Uwaga',
        'Warning' => 'Ostrzeżenie',
        'Module' => 'Moduł',
        'Modulefile' => 'Plik modułu',
        'Subfunction' => 'Funkcja podrzędna',
        'Line' => 'Linia',
        'Setting' => 'Ustawienie',
        'Settings' => 'Ustawienia',
        'Example' => 'Przykład',
        'Examples' => 'Przykłady',
        'valid' => 'aktualne',
        'Valid' => 'Aktualne',
        'invalid' => 'nieaktualne',
        'Invalid' => 'Nieaktualne',
        '* invalid' => '* nieaktualne',
        'invalid-temporarily' => 'czasowo nieaktualne',
        ' 2 minutes' => ' 2 minuty',
        ' 5 minutes' => ' 5 minut',
        ' 7 minutes' => ' 7 minut',
        '10 minutes' => '10 minut',
        '15 minutes' => '15 minut',
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
        'please do not edit!' => 'nie edytować!',
        'Need Action' => 'Wymagana akcja',
        'AddLink' => 'Dodaj link',
        'Link' => 'Połącz',
        'Unlink' => 'Rozłącz',
        'Linked' => 'Połączone',
        'Link (Normal)' => 'Połączone (równorzędnie)',
        'Link (Parent)' => 'Połączone (rodzic)',
        'Link (Child)' => 'Połączone (potomek)',
        'Normal' => 'Normalne',
        'Parent' => 'Rodzic',
        'Child' => 'Potomek',
        'Hit' => 'Odsłona',
        'Hits' => 'Odsłon',
        'Text' => 'Treść',
        'Standard' => 'Standard',
        'Lite' => 'Lekkie',
        'User' => 'Użytkownik',
        'Username' => 'Nazwa użytkownika',
        'Language' => 'Język',
        'Languages' => 'Języki',
        'Password' => 'Hasło',
        'Preferences' => 'Ustawienia',
        'Salutation' => 'Zwrot grzecznościowy',
        'Salutations' => 'Powitania',
        'Signature' => 'Podpis',
        'Signatures' => 'Podpisy',
        'Customer' => 'Klient',
        'CustomerID' => 'ID klienta',
        'CustomerIDs' => 'Dodatkowe ID klienta',
        'customer' => 'Klient',
        'agent' => 'Agent',
        'system' => 'System',
        'Customer Info' => 'Informacje o kliencie',
        'Customer Information' => 'Informacje o kliencie',
        'Customer Companies' => 'Firmy klientów',
        'Company' => 'Firma',
        'go!' => 'Start!',
        'go' => 'Start',
        'All' => 'Wszystkie',
        'all' => 'wszystkie',
        'Sorry' => 'Przykro mi',
        'update!' => 'zapisz!',
        'update' => 'zapisz',
        'Update' => 'Zapisz',
        'Updated!' => 'Uaktualniono!',
        'submit!' => 'akceptuj!',
        'submit' => 'akceptuj',
        'Submit' => 'Akceptuj',
        'change!' => 'Zmień!',
        'Change' => 'Zmień',
        'change' => 'zmień',
        'click here' => 'kliknij tutaj',
        'Comment' => 'Komentarz',
        'Invalid Option!' => 'Błędna opcja!',
        'Invalid time!' => 'Błędny czas!',
        'Invalid date!' => 'Błedna data!',
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
        'between' => 'pomiędzy',
        'before/after' => 'przed/po',
        'Fulltext Search' => 'Wyszukiwanie pełnotekstowe',
        'Data' => 'Data',
        'Options' => 'Opcje',
        'Title' => 'Tytuł',
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
        'Down' => 'Dół',
        'Add' => 'Dodaj',
        'Added!' => 'Dodano!',
        'Category' => 'Kategoria',
        'Viewer' => 'Przeglądarka',
        'Expand' => 'Rozwiń',
        'Small' => 'Małe',
        'Medium' => 'Średnie',
        'Large' => 'Duże',
        'Date picker' => 'Wybór daty',
        'Show Tree Selection' => 'Pokaż wybór drzewa',
        'The field content is too long!' => 'Zawartość pola jest zbyt długa!',
        'Maximum size is %s characters.' => 'Maksymalny rozmiar to %s znaków',
        'This field is required or' => 'To pole jes twymagane lub',
        'New message' => 'Nowa wiadomość',
        'New message!' => 'Nowa wiadomość!',
        'Please answer this ticket(s) to get back to the normal queue view!' =>
            'Proszę odpowiedz na to zgłoszenie, by powrocić do zwykłego widoku kolejki zgłoszeń!',
        'You have %s new message(s)!' => 'Masz %s nowych wiadomości!',
        'You have %s reminder ticket(s)!' => 'Masz %s przypomnień o zgłoszeniach!',
        'The recommended charset for your language is %s!' => 'Sugerowane kodowanie dla Twojego języka to %s!',
        'Change your password.' => 'Zmień hasło',
        'Please activate %s first!' => 'Najpierw aktywuj %s',
        'No suggestions' => 'Brak podpowiedzi',
        'Word' => 'Słowo',
        'Ignore' => 'Ignoruj',
        'replace with' => 'zamień z',
        'There is no account with that login name.' => 'Nie istnieje konto z takim loginem.',
        'Login failed! Your user name or password was entered incorrectly.' =>
            'Błąd logowania! Podana została zła nazwa użytkownika lub hasło.',
        'There is no acount with that user name.' => 'Nie ma konta z taką nazwą użytkownika.',
        'Please contact your administrator' => 'Prosimy, skontaktuj się ze swoim administratorem',
        'Authentication succeeded, but no customer record is found in the customer backend. Please contact your administrator.' =>
            '',
        'This e-mail address already exists. Please log in or reset your password.' =>
            '',
        'Logout' => 'Wyloguj',
        'Logout successful. Thank you for using %s!' => 'Wylogowanie zakończone! Dziękujemy za używanie %s!',
        'Feature not active!' => 'Funkcja nie aktywna!',
        'Agent updated!' => 'Agent został zaktualizowany!',
        'Database Selection' => 'Wybór bazy danych',
        'Create Database' => 'Stwórz bazę danych',
        'System Settings' => 'Ustawienia systemu',
        'Mail Configuration' => 'Konfiguracja poczty',
        'Finished' => 'Zakończono',
        'Install OTRS' => 'Zainstaluj OTRS',
        'Intro' => 'Wprowadzenie',
        'License' => 'Licencja',
        'Database' => 'Baza danych',
        'Configure Mail' => 'Skonfiguruj pocztę',
        'Database deleted.' => 'Baza danych usunięta.',
        'Enter the password for the administrative database user.' => 'Ustaw hasło dla administratora bazy danych.',
        'Enter the password for the database user.' => 'Ustaw hasło dla użytkownika bazy danych.',
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty.' =>
            'Jeśli ustawileś hasło główne do swojej bazy danych to musi ono zostać tutaj podane. Jesli nie pozostaw to pole puste.',
        'Database already contains data - it should be empty!' => 'Baza danych zawiera już dane - powinna być pusta.',
        'Login is needed!' => 'Wymagane zalogowanie!',
        'It is currently not possible to login due to a scheduled system maintenance.' =>
            '',
        'Password is needed!' => 'Wymagane hasło!',
        'Take this Customer' => 'Użyj tego klienta',
        'Take this User' => 'Użyj tego konta',
        'possible' => 'możliwe',
        'reject' => 'odrzuć',
        'reverse' => 'odwróć',
        'Facility' => 'Obiekt',
        'Time Zone' => 'Strefa czasowa',
        'Pending till' => 'Oczekuje do',
        'Don\'t use the Superuser account to work with OTRS! Create new Agents and work with these accounts instead.' =>
            'Nie używaj konta superużytkownika do pracy w OTRS! Stwórz raczej osobnych agentów i pracuj na ich kontach!',
        'Dispatching by email To: field.' => 'Przekazywanie na podstawie pola DO:',
        'Dispatching by selected Queue.' => 'Przekazywanie na podstawie zaznaczonej kolejki.',
        'No entry found!' => 'Nic nie odnaleziono!',
        'Session invalid. Please log in again.' => 'Sesja nieważna. Zaloguj się ponownie.',
        'Session has timed out. Please log in again.' => 'Sesja wygasła. Zaloguj się ponownie',
        'Session limit reached! Please try again later.' => 'Przekroczony limit sesji! Spróbuj ponownie później.',
        'No Permission!' => 'Brak uprawnień!',
        '(Click here to add)' => '(Kliknij tutaj aby dodać)',
        'Preview' => 'Podgląd',
        'Package not correctly deployed! Please reinstall the package.' =>
            'Niepoprawnie zainstalowana paczka. Reinstaluj tę paczkę.',
        '%s is not writable!' => 'nie można zapisać %s!',
        'Cannot create %s!' => 'Nie można utworzyć %s!',
        'Check to activate this date' => 'Zaznacz aby aktywować tę datę',
        'You have Out of Office enabled, would you like to disable it?' =>
            'Masz włączony status nieobecności - czy chcesz go wyłączyć?',
        'News about OTRS releases!' => '',
        'Customer %s added' => 'Klient %s został dodatny',
        'Role added!' => 'Rola dodana!',
        'Role updated!' => 'Rola zaktualizowana!',
        'Attachment added!' => 'Załącznik dodany!',
        'Attachment updated!' => 'Załącznik zaktualizowany!',
        'Response added!' => 'Odpowiedź dodana!',
        'Response updated!' => 'Odpowiedź zaktualizowana!',
        'Group updated!' => 'Grupa zaktualizowana!',
        'Queue added!' => 'Kolejka dodana!',
        'Queue updated!' => 'Kolejka zaktualizowana!',
        'State added!' => 'Stan dodany!',
        'State updated!' => 'Stan zaktualizowany!',
        'Type added!' => 'Typ dodany!',
        'Type updated!' => 'Typ zaktualizowany!',
        'Customer updated!' => 'Klient zaktualizowany!',
        'Customer company added!' => 'Firma klienta dodana!',
        'Customer company updated!' => 'Firma klienta zaktualizowana!',
        'Note: Company is invalid!' => 'Info: Firma jest nieprawidłowa!',
        'Mail account added!' => 'Konto pocztowe dodane!',
        'Mail account updated!' => 'Konto pocztowe zaktualizowane!',
        'System e-mail address added!' => 'Adres systemowy dodany!',
        'System e-mail address updated!' => 'Adres systemowy zaktualizowany!',
        'Contract' => 'Umowa',
        'Online Customer: %s' => 'Klient zalogowany: %s',
        'Online Agent: %s' => 'Agent zalogowany: %s',
        'Calendar' => 'Kalendarz',
        'File' => 'Plik',
        'Filename' => 'Nazwa pliku',
        'Type' => 'Typ',
        'Size' => 'Rozmiar',
        'Upload' => 'Wysyłanie',
        'Directory' => 'Katalog',
        'Signed' => 'Podpis',
        'Sign' => 'Podpis',
        'Crypted' => 'Zaszyfrowany',
        'Crypt' => 'Szyfr',
        'PGP' => 'PGP',
        'PGP Key' => 'Klucz PGP',
        'PGP Keys' => 'Klucze PGP',
        'S/MIME' => 'S/MIME',
        'S/MIME Certificate' => 'Certyfikat S/MIME',
        'S/MIME Certificates' => 'Certyfikaty S/MIME',
        'Office' => 'Biuro',
        'Phone' => 'Tel.',
        'Fax' => 'Faks',
        'Mobile' => 'Tel. kom.',
        'Zip' => 'Kod',
        'City' => 'Miasto',
        'Street' => 'Ulica',
        'Country' => 'Kraj',
        'Location' => 'Miejsce',
        'installed' => 'zainstalowany',
        'uninstalled' => 'odinstalowany',
        'Security Note: You should activate %s because application is already running!' =>
            'Nota bezpieczeństwa: Należy aktywować %s ponieważ aplikacja jest już uruchomiona!',
        'Unable to parse repository index document.' => 'Nie można sparsować indeksu rezpozytorium.',
        'No packages for your framework version found in this repository, it only contains packages for other framework versions.' =>
            'Brak paczek dla twojej wersji środowiska w tym repozytorium, zawiera ono tylko paczki dla innych wersji środowiska.',
        'No packages, or no new packages, found in selected repository.' =>
            'Brak paczek lub brak nowych paczek w wybranym repozytorium.',
        'Edit the system configuration settings.' => 'Edytuj ustawienia konfiguracji systemu.',
        'ACL information from database is not in sync with the system configuration, please deploy all ACLs.' =>
            'Dane dostępu ACL z bazy danych nie są zsynchronizowane z konfiguraacją systemu, proszę wprowadź wszystkie ACLe.',
        'printed at' => 'wydrukowano',
        'Loading...' => 'Ładowanie...',
        'Dear Mr. %s,' => 'Drogi Panie %s,',
        'Dear Mrs. %s,' => 'Droga Pani %s,',
        'Dear %s,' => 'Drogi %s,',
        'Hello %s,' => 'Witaj %s,',
        'This email address already exists. Please log in or reset your password.' =>
            'Ten adres e-mail już istnieje. Prosimy, zaloguj się lub zresetuj swoje hasło.',
        'This email address is not allowed to register. Please contact support staff.' =>
            '',
        'New account created. Sent login information to %s. Please check your email.' =>
            'Utworzono nowe konto. Informacje dotyczące sposobu logowania zostały wysłane do %s. Prosimy o sprawdzenie swojej skrzynki pocztowej.',
        'Please press Back and try again.' => 'Proszę wybrać Cofnij i spróbować ponownie.',
        'Sent password reset instructions. Please check your email.' => 'Instrukcje dotyczące resetowania hasła zostały wysłane. Prosimy o sprawdzenie swojej skrzynki pocztowej.',
        'Sent new password to %s. Please check your email.' => 'Nowe hasło wysłane do %s. Prosimy o sprawdzenie swojej skrzynki pocztowej.',
        'Upcoming Events' => 'Zbliżające się wydarzenia',
        'Event' => 'Zdarzenie',
        'Events' => 'Zdarzenia',
        'Invalid Token!' => 'Błędny token!',
        'more' => 'więcej',
        'Collapse' => 'Zwiń',
        'Shown' => 'Pokazane',
        'Shown customer users' => 'Widoczni użytkownicy klienta',
        'News' => 'Informacje',
        'Product News' => 'Informacje o produkcie',
        'OTRS News' => 'Wiadomości OTRS',
        '7 Day Stats' => 'Statystyka z 7 dni',
        'Process Management information from database is not in sync with the system configuration, please synchronize all processes.' =>
            'Informacje zarządzania procesami z bazy danych nie są zsynchronizowane z konfiguracją systemu, zsynchronizuj wszystkie procesy.',
        'Package not verified by the OTRS Group! It is recommended not to use this package.' =>
            'Pakiet nie został zweryfikowany przez Grupę OTRS! Jest zalecane nieużywanie tego pakietu.',
        '<br>If you continue to install this package, the following issues may occur!<br><br>&nbsp;-Security problems<br>&nbsp;-Stability problems<br>&nbsp;-Performance problems<br><br>Please note that issues that are caused by working with this package are not covered by OTRS service contracts!<br><br>' =>
            '<br>W wypadku kontynuowania instalacji pakietu mogą wystąpić następujące problemy.<br><br>&nbsp;-problemy bezpieczeństwa<br>&nbsp;-problemy ze stabilnością<br>&nbsp;-problemy z wydajnością<br><br>Proszę zwrócić uwagę, iż problemy wynikające z użytkowania pakietu nie podlegają pod umowy dotyczące korzystania z usługi OTRS!<br><br>',
        'Mark' => 'Oznacz',
        'Unmark' => 'Odznacz',
        'Bold' => 'Pogrubienie',
        'Italic' => 'Italiki',
        'Underline' => 'Podkreślenie',
        'Font Color' => 'Kolor czcionki',
        'Background Color' => 'Kolor tła',
        'Remove Formatting' => 'Usuń formatowanie',
        'Show/Hide Hidden Elements' => 'Pokaż/Ukryj ukryte wiadomości',
        'Align Left' => 'Wyrównanie do lewej',
        'Align Center' => 'Wyrównanie do środka',
        'Align Right' => 'Wyrównanie do prawej',
        'Justify' => 'Justowanie',
        'Header' => 'Nagłówek',
        'Indent' => 'Wcięcie',
        'Outdent' => 'Wysunięcie',
        'Create an Unordered List' => 'Stwórz listę nienumerowaną',
        'Create an Ordered List' => 'Stwórz listę numerowaną',
        'HTML Link' => 'Łącze',
        'Insert Image' => 'Wstaw obraz',
        'CTRL' => 'CTRL',
        'SHIFT' => 'SHIFT',
        'Undo' => 'Cofnij',
        'Redo' => 'Ponów',
        'Scheduler process is registered but might not be running.' => 'Proces harmonogramu zadań jest zarejestrowany ale prawdopodobnie nie jest uruchomiony.',
        'Scheduler is not running.' => 'Harmonogram zadań nie jest uruchomiony.',
        'Can\'t contact registration server. Please try again later.' => 'Nie można połaczyć sie z serwerem rejestracji. Porszę spróbuj ponownie.',
        'No content received from registration server. Please try again later.' =>
            'Z serwera rejestracji nie otrzymano żadnych danych. Proszę później spróbuj ponownie.',
        'Problems processing server result. Please try again later.' => 'Problem przy procesowaniu rezultatów. Proszę później spróbuj ponownie',
        'Username and password do not match. Please try again.' => 'Użytkownik oraz hasło nie zgadzają się. Prosze spróbuj ponownie.',
        'The selected process is invalid!' => 'Wybrane procesy są nieprawidłowe!',
        'Upgrade to %s now!' => '',
        '%s Go to the upgrade center %s' => '',
        'The license for your %s is about to expire. Please make contact with %s to renew your contract!' =>
            '',
        'An update for your %s is available, but there is a conflict with your framework version! Please update your framework first!' =>
            '',
        'Your system was successfully upgraded to %s.' => '',
        'There was a problem during the upgrade to %s.' => '',
        '%s was correctly reinstalled.' => '',
        'There was a problem reinstalling %s.' => '',
        'Your %s was successfully updated.' => '',
        'There was a problem during the upgrade of %s.' => '',
        '%s was correctly uninstalled.' => '',
        'There was a problem uninstalling %s.' => '',

        # Template: AAACalendar
        'New Year\'s Day' => 'Nowy Rok',
        'International Workers\' Day' => 'Międzynarodowy Dzień Pracy',
        'Christmas Eve' => 'Wigilia Bożego Narodzenia',
        'First Christmas Day' => 'Pierwszy dzień Świąt Bożego Narodzenia',
        'Second Christmas Day' => 'Drugi dzień Świąt Bożego Narodzenia',
        'New Year\'s Eve' => 'Sylwester',

        # Template: AAAGenericInterface
        'OTRS as requester' => 'OTRS jako klient',
        'OTRS as provider' => 'OTRS jako serwer',
        'Webservice "%s" created!' => 'Serwis sieciowy "%s" utworzony!',
        'Webservice "%s" updated!' => 'Serwis sieciowy "%s" zaktualizowany!',

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
        'Oct' => 'Paź',
        'Nov' => 'Lis',
        'Dec' => 'Gru',
        'January' => 'Styczeń',
        'February' => 'Luty',
        'March' => 'Marzec',
        'April' => 'Kwiecień',
        'May_long' => 'Maj',
        'June' => 'Czerwiec',
        'July' => 'Lipiec',
        'August' => 'Sierpień',
        'September' => 'Wrzesień',
        'October' => 'Październik',
        'November' => 'Listopad',
        'December' => 'Grudzień',

        # Template: AAAPreferences
        'Preferences updated successfully!' => 'Ustawienia zapisano pomyślnie!',
        'User Profile' => 'Profil użytkownika',
        'Email Settings' => 'Ustawienia poczty e-mail',
        'Other Settings' => 'Inne ustawienia',
        'Change Password' => 'Zmień hasło',
        'Current password' => 'Obecne hasło',
        'New password' => 'Nowe hasło',
        'Verify password' => 'Zweryfikuj hasło',
        'Spelling Dictionary' => 'Słownik pisowni',
        'Default spelling dictionary' => 'Domyślny słownik sprawdzania pisowni.',
        'Max. shown Tickets a page in Overview.' => 'Limit pokazywanych zgłoszeń na stronie Podsumowania',
        'The current password is not correct. Please try again!' => 'Hasło jest niepoprawne. Spróbuj jeszcze raz!',
        'Can\'t update password, your new passwords do not match. Please try again!' =>
            'Nie można zmienić hasła, nowe powtórzenia nowego hasła nie zgadzają się.',
        'Can\'t update password, it contains invalid characters!' => 'Nie można zmienić hasła ponieważ nowe hasło zawiera nidozwolone znaki.',
        'Can\'t update password, it must be at least %s characters long!' =>
            'Nie można zmienić hasła, nowe hasło musi zawierać co najmniej $s znaków.',
        'Can\'t update password, it must contain at least 2 lowercase and 2 uppercase characters!' =>
            'Nie można zmienić hasła. Hasło musi zawierać co najmniej 2 wielkie i 2 małe litery.',
        'Can\'t update password, it must contain at least 1 digit!' => 'Nie można zmienić hasła. Hasło musi zawierać co najmniej 1 cyfrę.',
        'Can\'t update password, it must contain at least 2 characters!' =>
            'Nie można zmienić hasła. Hasło musi zawierać co najmniej dwa znaki specjalne.',
        'Can\'t update password, this password has already been used. Please choose a new one!' =>
            'Nie można zmienić hasła ponieważ było już używane. Należy wybrać nowe hasło!',
        'Select the separator character used in CSV files (stats and searches). If you don\'t select a separator here, the default separator for your language will be used.' =>
            'Wskaż znak separatora w pliku CSV (statystyki i wyszukiwania). Jeśli nie wskażesz tutaj separatora, użyty zostanie domyślny separator dla twojego języka.',
        'CSV Separator' => 'Separator CSV',

        # Template: AAAStats
        'Stat' => 'Statystyki',
        'Sum' => 'Suma',
        'No (not supported)' => 'Nie (nie wspierany)',
        'Days' => '',
        'Please fill out the required fields!' => 'Wypełnij wymagane pola!',
        'Please select a file!' => 'Wybierz plik!',
        'Please select an object!' => 'Wybierz obiekt!',
        'Please select a graph size!' => 'Wybierz rozmiar wykresu!',
        'Please select one element for the X-axis!' => 'Wybierz element dla osi X!',
        'Please select only one element or turn off the button \'Fixed\' where the select field is marked!' =>
            'Wybierz tylko jeden element lyb wyłącz klawisz\'Stałe\' przy zaznaczonym polu!',
        'If you use a checkbox you have to select some attributes of the select field!' =>
            'Po zaznaczeniu pola wyboru musisz wskazać atrybuty wybranego pola!',
        'Please insert a value in the selected input field or turn off the \'Fixed\' checkbox!' =>
            'Wprowadź wartość w wybrane pole lub odznacz pole \'Stały\'!',
        'The selected end time is before the start time!' => 'Czas zakończenia wcześniejszy od czasu rozpoczęcia!',
        'You have to select one or more attributes from the select field!' =>
            'Wskaż jeden lub więcej atrybut z pola wyboru!',
        'The selected Date isn\'t valid!' => 'Wybrana data jest nieprawidłowa!',
        'Please select only one or two elements via the checkbox!' => 'Zaznacz tylko jeden lub dwa pola wyboru!',
        'If you use a time scale element you can only select one element!' =>
            'Jeżeli używasz skalowania czasu możesz wybrać tylko jeden element!',
        'You have an error in your time selection!' => 'Błąd w wyborze czasu!',
        'Your reporting time interval is too small, please use a larger time scale!' =>
            'Wybrany zakres czasu jest za mały, użyj większej skali czasu!',
        'The selected start time is before the allowed start time!' => 'Wybrany czas początku jest przed dozwolonym czasem rozpoczęcia!',
        'The selected end time is after the allowed end time!' => 'Wybrany czas końca przekracza dopuszczalny czas zakończenia!',
        'The selected time period is larger than the allowed time period!' =>
            'Wybrany zakres czasu przekracza maksymalny dopuszczalny!',
        'Common Specification' => 'Podstawowa specyfikacja',
        'X-axis' => 'Oś X',
        'Value Series' => 'Serie wartości',
        'Restrictions' => 'Ograniczenia',
        'graph-lines' => 'wykres-linie',
        'graph-bars' => 'wykres-słupki',
        'graph-hbars' => 'wykres-słupki poziome',
        'graph-points' => 'wykres-punkty',
        'graph-lines-points' => 'wykres- linie i punkty',
        'graph-area' => 'obszar wykresu',
        'graph-pie' => 'wykres-kołowy',
        'extended' => 'rozszerzony',
        'Agent/Owner' => 'Agent/Właściciel',
        'Created by Agent/Owner' => 'Utworzony przez Agenta/Właściciela',
        'Created Priority' => 'Utworzony priorytet',
        'Created State' => 'Utworzony status',
        'Create Time' => 'Czas utworzenia',
        'CustomerUserLogin' => 'Login klienta',
        'Close Time' => 'Czas zamknięcia',
        'TicketAccumulation' => 'Kumulacja zgłoszeń',
        'Attributes to be printed' => 'Drukowane atrybuty',
        'Sort sequence' => 'Kolejność sortowania',
        'Order by' => 'Sortuj według',
        'Limit' => 'Limit',
        'Ticketlist' => 'Lista zgłoszeń',
        'ascending' => 'rosnąco',
        'descending' => 'malejąco',
        'First Lock' => 'Pierwsza Blokada',
        'Evaluation by' => 'Ewaluacja do',
        'Total Time' => 'Całkowity Czas',
        'Ticket Average' => 'Zgłoszenie Średnio',
        'Ticket Min Time' => 'Zgłoszenie Min Czas',
        'Ticket Max Time' => 'Zgłoszenie Max Czas',
        'Number of Tickets' => 'Ilość Zgłoszeń',
        'Article Average' => 'Wiadomość Średnio',
        'Article Min Time' => 'Wiadomość Min Czas',
        'Article Max Time' => 'Wiadomość Max Czas',
        'Number of Articles' => 'Ilość wiadomości',
        'Accounted time by Agent' => 'Czas zaraportowany przez Agenta',
        'Ticket/Article Accounted Time' => 'Zaraportowany czas Zgłoszenia/Wiadomości',
        'TicketAccountedTime' => 'Zaraportowany czas obsługi zgłoszeń',
        'Ticket Create Time' => 'Czas Utworzenia Zgłoszenia',
        'Ticket Close Time' => 'Czas Zamknięcia Zgłoszenia',

        # Template: AAASupportDataCollector
        'Unknown' => '',
        'Information' => 'Informacje',
        'OK' => 'OK',
        'Problem' => '',
        'Webserver' => '',
        'Operating System' => 'System operacyjny',
        'OTRS' => '',
        'Table Presence' => '',
        'Internal Error: Could not open file.' => '',
        'Table Check' => '',
        'Internal Error: Could not read file.' => '',
        'Tables found which are not present in the database.' => '',
        'Database Size' => '',
        'Could not determine database size.' => '',
        'Database Version' => '',
        'Could not determine database version.' => '',
        'Client Connection Charset' => '',
        'Setting character_set_client needs to be utf8.' => '',
        'Server Database Charset' => '',
        'Setting character_set_database needs to be UNICODE or UTF8.' => '',
        'Table Charset' => '',
        'There were tables found which do not have utf8 as charset.' => '',
        'Maximum Query Size' => '',
        'The setting \'max_allowed_packet\' must be higher than 20 MB.' =>
            '',
        'Query Cache Size' => '',
        'The setting \'query_cache_size\' should be used (higher than 10 MB but not more than 512 MB).' =>
            '',
        'Default Storage Engine' => '',
        'Tables with a different storage engine than the default engine were found.' =>
            '',
        'MySQL 5.x or higher is required.' => '',
        'NLS_LANG Setting' => '',
        'NLS_LANG must be set to AL32UTF8 (e.g. GERMAN_GERMANY.AL32UTF8).' =>
            '',
        'NLS_DATE_FORMAT Setting' => '',
        'NLS_DATE_FORMAT must be set to \'YYYY-MM-DD HH24:MI:SS\'.' => '',
        'NLS_DATE_FORMAT Setting SQL Check' => '',
        'Setting client_encoding needs to be UNICODE or UTF8.' => '',
        'Setting server_encoding needs to be UNICODE or UTF8.' => '',
        'Date Format' => '',
        'Setting DateStyle needs to be ISO.' => '',
        'PostgreSQL 8.x or higher is required.' => '',
        'OTRS Disk Partition' => '',
        'Disk Usage' => '',
        'The partition where OTRS is located is almost full.' => '',
        'The partition where OTRS is located has no disk space problems.' =>
            '',
        'Disk Partitions Usage' => '',
        'Distribution' => '',
        'Could not determine distribution.' => '',
        'Kernel Version' => '',
        'Could not determine kernel version.' => '',
        'System Load' => '',
        'The system load should be at maximum the number of CPUs the system has (e.g. a load of 8 or less on a system with 8 CPUs is OK).' =>
            '',
        'Perl Modules' => '',
        'Not all required Perl modules are correctly installed.' => '',
        'Perl Version' => 'Wersja Perl',
        'Free Swap Space (%)' => '',
        'No Swap Enabled.' => '',
        'Used Swap Space (MB)' => '',
        'There should be more than 60% free swap space.' => '',
        'There should be no more than 200 MB swap space used.' => '',
        'Config Settings' => '',
        'Could not determine value.' => '',
        'Database Records' => '',
        'Tickets' => 'Zgłoszenia',
        'Ticket History Entries' => '',
        'Articles' => '',
        'Attachments (DB, Without HTML)' => '',
        'Customers With At Least One Ticket' => '',
        'Queues' => 'Kolejki',
        'Agents' => 'Agenci',
        'Roles' => 'Role',
        'Groups' => 'Grupy',
        'Dynamic Fields' => 'Pola dynamiczne',
        'Dynamic Field Values' => '',
        'Invalid Dynamic Fields' => '',
        'Invalid Dynamic Field Values' => '',
        'GenericInterface Webservices' => '',
        'Processes' => 'Procesy',
        'Months Between First And Last Ticket' => '',
        'Tickets Per Month (avg)' => '',
        'Default SOAP Username and Password' => '',
        'Security risk: you use the default setting for SOAP::User and SOAP::Password. Please change it.' =>
            '',
        'Default Admin Password' => '',
        'Security risk: the agent account root@localhost still has the default password. Please change it or invalidate the account.' =>
            '',
        'Error Log' => '',
        'There are error reports in your system log.' => '',
        'File System Writable' => '',
        'The file system on your OTRS partition is not writable.' => '',
        'Domain Name' => '',
        'Your FQDN setting is invalid.' => '',
        'Package installation status' => '',
        'Some packages are not correctly installed.' => '',
        'Package List' => '',
        'SystemID' => 'ID Systemu',
        'Your SystemID setting is invalid, it should only contain digits.' =>
            '',
        'OTRS Version' => 'Wersja OTRS',
        'Ticket Index Module' => '',
        'You have more than 60,000 tickets and should use the StaticDB backend. See admin manual (Performance Tuning) for more information.' =>
            '',
        'Open Tickets' => '',
        'You should not have more than 8,000 open tickets in your system.' =>
            '',
        'Ticket Search Index module' => '',
        'You have more than 50,000 articles and should use the StaticDB backend. See admin manual (Performance Tuning) for more information.' =>
            '',
        'Orphaned Records In ticket_lock_index Table' => '',
        'Table ticket_lock_index contains orphaned records. Please run otrs/bin/otrs.CleanTicketIndex.pl to clean the StaticDB index.' =>
            '',
        'Orphaned Records In ticket_index Table' => '',
        'Table ticket_index contains orphaned records. Please run otrs/bin/otrs.CleanTicketIndex.pl to clean the StaticDB index.' =>
            '',
        'Environment Variables' => '',
        'Webserver Version' => '',
        'Could not determine webserver version.' => '',
        'Loaded Apache Modules' => '',
        'CGI Accelerator Usage' => '',
        'You should use FastCGI or mod_perl to increase your performance.' =>
            '',
        'mod_deflate Usage' => '',
        'Please install mod_deflate to improve GUI speed.' => '',
        'mod_headers Usage' => '',
        'Please install mod_headers to improve GUI speed.' => '',
        'Apache::Reload Usage' => '',
        'Apache::Reload or Apache2::Reload should be used as PerlModule and PerlInitHandler to prevent web server restarts when installing and upgrading modules.' =>
            '',
        'Apache::DBI Usage' => '',
        'Apache::DBI should be used to get a better performance  with pre-established database connections.' =>
            '',
        'You should use PerlEx to increase your performance.' => '',

        # Template: AAATicket
        'Status View' => 'Widok statusów',
        'Service View' => '',
        'Bulk' => 'Zbiorczo',
        'Lock' => 'Blokada',
        'Unlock' => 'Odblokuj',
        'History' => 'Historia',
        'Zoom' => 'Podgląd',
        'Age' => 'Wiek',
        'Bounce' => 'Przekaż',
        'Forward' => 'Prześlij dalej',
        'From' => 'Od',
        'To' => 'Do',
        'Cc' => 'DW',
        'Bcc' => 'UDW',
        'Subject' => 'Temat',
        'Move' => 'Przenieś',
        'Queue' => 'Kolejka',
        'Priority' => 'Priorytet',
        'Priorities' => 'Priorytety',
        'Priority Update' => 'Aktualizacja priorytetu',
        'Priority added!' => 'Priorytet dodany!',
        'Priority updated!' => 'Priorytet zaktualizowany!',
        'Signature added!' => 'Podpis dodany!',
        'Signature updated!' => 'Podpis zaktualizowany!',
        'SLA' => 'SLA',
        'Service Level Agreement' => 'Poziom SLA',
        'Service Level Agreements' => 'Poziomy SLA',
        'Service' => 'Usługa',
        'Services' => 'Usługi',
        'State' => 'Status',
        'States' => 'Statusy',
        'Status' => 'Status',
        'Statuses' => 'Statusy',
        'Ticket Type' => 'Typ zgłoszenia',
        'Ticket Types' => 'Typy zgłoszeń',
        'Compose' => 'Stwórz',
        'Pending' => 'Oczekujące',
        'Owner' => 'Właściciel',
        'Owner Update' => 'Aktualizacja własciciela',
        'Responsible' => 'Odpowiedzialny',
        'Responsible Update' => 'Aktualizacja odpowiedzialnego',
        'Sender' => 'Nadawca',
        'Article' => 'Artykuł',
        'Ticket' => 'Zgłoszenie',
        'Createtime' => 'Utworzone',
        'plain' => 'bez formatowania',
        'Email' => 'E-Mail',
        'email' => 'e-mail',
        'Close' => 'Zamknij',
        'Action' => 'Akcja',
        'Attachment' => 'Załącznik',
        'Attachments' => 'Załączniki',
        'This message was written in a character set other than your own.' =>
            'Ta wiadomość została napisana z użyciem kodowania znaków innego niż Twój.',
        'If it is not displayed correctly,' => 'Jeśli nie jest wyświetlane poprawnie,',
        'This is a' => 'To jest',
        'to open it in a new window.' => 'by otworzyć w oddzielnym oknie',
        'This is a HTML email. Click here to show it.' => 'To jest e-mail w formacie HTML. Kliknij tutaj, by go przeczytać.',
        'Free Fields' => 'Pola dod.',
        'Merge' => 'Scal',
        'merged' => 'scalone',
        'closed successful' => 'zamknięte z powodzeniem',
        'closed unsuccessful' => 'zamknięte bez powodzenia',
        'Locked Tickets Total' => 'Zablokowane zgłoszenia razem',
        'Locked Tickets Reminder Reached' => 'Zablokowane zgłoszenia z przekroczonym czasem przypomnienia',
        'Locked Tickets New' => 'Nowe zablokowane zgłoszenia',
        'Responsible Tickets Total' => 'Odpowiedzialność za zgłoszenia razem',
        'Responsible Tickets New' => 'Odpowiedzialność za zgłoszenia nowe',
        'Responsible Tickets Reminder Reached' => 'Odpowiedzialność za zgłoszenia przekroczony czas przypomnienia',
        'Watched Tickets Total' => 'Zgłoszenia obserwowane razem',
        'Watched Tickets New' => 'Zgłoszenia obserwowane nowe',
        'Watched Tickets Reminder Reached' => 'Zgłoszenia obserwowane z przekroczonym czasem przypomnienia',
        'All tickets' => 'Wszystkie',
        'Available tickets' => 'Dostępne zgłoszenia',
        'Escalation' => 'Eskalacja',
        'last-search' => 'ostatnie-wyszkiwanie',
        'QueueView' => 'Widok kolejek',
        'Ticket Escalation View' => 'Widok eskalowanych zgłoszeń',
        'Message from' => 'Wiadomość od',
        'End message' => 'Koniec wiadomości',
        'Forwarded message from' => 'Wiadomość przekazana od',
        'End forwarded message' => 'Koniec przekazanej wiadomości',
        'Bounce Article to a different mail address' => '',
        'Reply to note' => '',
        'new' => 'nowe',
        'open' => 'otwarte',
        'Open' => 'Otwarte',
        'Open tickets' => 'Otwarte zgłoszenia',
        'closed' => 'zamknięte',
        'Closed' => 'Zamknięte',
        'Closed tickets' => 'Zamknięte zgłoszenia',
        'removed' => 'usunięte',
        'pending reminder' => 'oczekujące przypomnienie',
        'pending auto' => 'oczekujące auto',
        'pending auto close+' => 'oczekujące na automatyczne zamknięcie+',
        'pending auto close-' => 'oczekujące na automatyczne zamknięcie-',
        'email-external' => 'E-mail zewnętrzny',
        'email-internal' => 'E-mail wewnętrzny',
        'note-external' => 'Notatka zewnętrzna',
        'note-internal' => 'Notatka wewnętrzna',
        'note-report' => 'Notatka raportująca',
        'phone' => 'Telefon',
        'sms' => 'SMS',
        'webrequest' => 'Zgłoszenie WWW',
        'lock' => 'zablokowane',
        'unlock' => 'odblokowane',
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
        'auto follow up' => 'auto nawiązanie',
        'auto reject' => 'auto odrzucenie',
        'auto remove' => 'auto usunięcie',
        'auto reply' => 'autoodpowiedź',
        'auto reply/new ticket' => 'autoodpowiedź/nowe zgłoszenie',
        'Create' => 'Utwórz',
        'Answer' => 'Odpowiedz',
        'Phone call' => 'Telefon',
        'Ticket "%s" created!' => 'Zgłoszenie "%s" utworzone!',
        'Ticket Number' => 'Numer zgłoszenia',
        'Ticket Object' => 'Obiekt zgłoszenia',
        'No such Ticket Number "%s"! Can\'t link it!' => 'Nie znaleziono zgłoszenia numer "%s"! Nie można połączyć!',
        'You don\'t have write access to this ticket.' => 'Nie masz uprawnień zapisu do tego zgłoszenia.',
        'Sorry, you need to be the ticket owner to perform this action.' =>
            'Przykro mi, musisz być właścicielem zgłoszenia aby wykonać tę operację.',
        'Please change the owner first.' => 'Zmień najpierw właściciela zgłoszenia.',
        'Ticket selected.' => 'Zgłoszenie zaznaczone.',
        'Ticket is locked by another agent.' => 'Zgłoszenie jest zablokowane przez innego agenta.',
        'Ticket locked.' => 'Zgłoszenie zablokowane.',
        'Don\'t show closed Tickets' => 'Nie pokazuj zamkniętych zgłoszeń',
        'Show closed Tickets' => 'Pokaż zamknięte zgłoszenia',
        'New Article' => 'Nowy artykuł',
        'Unread article(s) available' => 'Dostępne nie odczytane jeszcze artykuły',
        'Remove from list of watched tickets' => 'Usuń z listy obserwowanych zgłoszeń',
        'Add to list of watched tickets' => 'Dodaj do listy obserwowanych zgłoszeń',
        'Email-Ticket' => 'Zgłoszenie e-mail',
        'Create new Email Ticket' => 'Utwórz nowe zgłoszenie e-mail',
        'Phone-Ticket' => 'Zgłoszenie telefoniczne',
        'Search Tickets' => 'Szukaj zgłoszeń',
        'Customer History' => '',
        'Edit Customer Users' => 'Edycja kont klienta',
        'Edit Customer' => 'Edytuj Klienta',
        'Bulk Action' => 'Akcja grupowa',
        'Bulk Actions on Tickets' => 'Akcje grupowe na zgłoszeniach',
        'Send Email and create a new Ticket' => 'Wylij e-mail i utwórz nowe zgłoszenie',
        'Create new Email Ticket and send this out (Outbound)' => 'Utwórz nowe zgłoszenie e-mail i wyślij (wychodzące)',
        'Create new Phone Ticket (Inbound)' => 'Utwórz zgłoszenie telefoniczne (przychodzące)',
        'Address %s replaced with registered customer address.' => 'Adres %s zastąpiony zarejestrowanym adresem klienta.',
        'Customer user automatically added in Cc.' => 'Klient automatycznie dodawany na CC.',
        'Overview of all open Tickets' => 'Przegląd otwartych zgłoszeń',
        'Locked Tickets' => 'Zablokowane',
        'My Locked Tickets' => 'Zablokowane',
        'My Watched Tickets' => 'Obserwowane',
        'My Responsible Tickets' => 'Odpowiedzialny',
        'Watched Tickets' => 'Obserwowane zgłoszenia',
        'Watched' => 'Obserwowane',
        'Watch' => 'Obserwuj',
        'Unwatch' => 'Nie obserwuj',
        'Lock it to work on it' => 'Zablokuj by na tym pracować',
        'Unlock to give it back to the queue' => 'Odblokuj aby zwrócić do kolejki',
        'Show the ticket history' => 'Pokaż historię zgłoszenia',
        'Print this ticket' => 'Wydrukuj to zgłoszenie',
        'Print this article' => 'Wydrukuj ten artykuł',
        'Split' => 'Podziel',
        'Split this article' => 'Podziel ten artykuł',
        'Forward article via mail' => 'Prześlij artykuł za pomocą e-mail',
        'Change the ticket priority' => 'Zmień priorytet zgłoszenia',
        'Change the ticket free fields!' => 'Zmień pola dodatkowe zgłoszenia!',
        'Link this ticket to other objects' => 'Połącz to zgłoszenie z innymi obiektami',
        'Change the owner for this ticket' => 'Zmień właściciela tego zgłoszenia',
        'Change the  customer for this ticket' => 'Zmień klienta dla tego zgłoszenia',
        'Add a note to this ticket' => 'Dodaj uwagi do tego zgłoszenia',
        'Merge into a different ticket' => 'Scal z innym zgłoszeniem',
        'Set this ticket to pending' => 'Ustaw przypomnienie dla tego zgłoszenia',
        'Close this ticket' => 'Zamknij to zgłoszenie',
        'Look into a ticket!' => 'Szczegóły zgłoszenia!',
        'Delete this ticket' => 'Usuń to zgłoszenie',
        'Mark as Spam!' => 'Oznacz jako spam!',
        'My Queues' => 'Moje kolejki',
        'Shown Tickets' => 'Wyświetlane zgłoszenia',
        'Shown Columns' => 'Wyświetlane kolumny',
        'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' =>
            'Twoje zgłoszenie o numerze "<OTRS_TICKET>" zostało scalone z "<OTRS_MERGE_TO_TICKET>".',
        'Ticket %s: first response time is over (%s)!' => 'Zgłoszenie %s: czas pierwszej odpowiedzi przekroczony (%s)!',
        'Ticket %s: first response time will be over in %s!' => 'Zgłoszenie %s: czas pierwszej odpowiedzi zostanie przekroczony za %s!',
        'Ticket %s: update time is over (%s)!' => 'Zgłoszenie %s: czas aktualizacji przekroczony (%s)!',
        'Ticket %s: update time will be over in %s!' => 'Zgłoszenie %s: czas aktualizacji zostanie przekroczony za %s!',
        'Ticket %s: solution time is over (%s)!' => 'Zgłoszenie %s: czas rozwiązania przekroczony (%s)!',
        'Ticket %s: solution time will be over in %s!' => 'Zgłoszenie %s: czas rozwiązania zostanie przekroczony za %s!',
        'There are more escalated tickets!' => 'Więcej przeterminowanych zgłoszeń!',
        'Plain Format' => 'Źródło',
        'Reply All' => 'Odpowiedz wszystkim',
        'Direction' => 'Kierunek',
        'Agent (All with write permissions)' => 'Agent (Wszyscy z dostępem do zapisu)',
        'Agent (Owner)' => 'Agent (Właściciel)',
        'Agent (Responsible)' => 'Agent (Odpowiedzialny)',
        'New ticket notification' => 'Powiadomienie o nowym zgłoszeniu',
        'Send me a notification if there is a new ticket in "My Queues".' =>
            'Powiadom o nowym zgłoszeniu w Moich kolejkach.',
        'Send new ticket notifications' => 'Wysyłaj powiadomienia o nowych zgłoszeniach',
        'Ticket follow up notification' => 'Wysyłaj powiadomienia o nowych wiadomościach w zgłoszeniach',
        'Send me a notification if a customer sends a follow up and I\'m the owner of the ticket or the ticket is unlocked and is in one of my subscribed queues.' =>
            'Wyślij mi wiadomość, gdy klient odpowie na zgłoszenie, którego ja jestem właścicielem.',
        'Send ticket follow up notifications' => 'Wysyłaj powiadomienia o nowych wiadomościach w zgłoszeniach',
        'Ticket lock timeout notification' => 'Powiadomienie o przekroczonym czasie blokady zgłoszenia',
        'Send me a notification if a ticket is unlocked by the system.' =>
            'Wyślij mi wiadomość, gdy zgłoszenie zostanie odblokowane przez system.',
        'Send ticket lock timeout notifications' => 'Wysyłaj powiadomienia o upłynięciu terminu przypomnienia ustawionego w zgłoszeniu',
        'Ticket move notification' => 'Powiadomienie o przeniesieniu zgłoszenia',
        'Send me a notification if a ticket is moved into one of "My Queues".' =>
            'Powiadom o przesunięciu do mojej kolejki',
        'Send ticket move notifications' => 'Wysyłaj powiadomienia o przesunięciu zgłoszenia do innej kolejki',
        'Your queue selection of your favourite queues. You also get notified about those queues via email if enabled.' =>
            'Twój zestaw wybranych kolejek. Jeżeli włączysz opcję "Powiadomienie o nowym zgłoszeniu" to dostaniesz wiadomość e-mail o każdym nowym zgłoszeniu, które pojawi się w tych kolejkach.',
        'Custom Queue' => 'Kolejka modyfikowana',
        'QueueView refresh time' => 'Interwał odświeżania Widoku Kolejek',
        'If enabled, the QueueView will automatically refresh after the specified time.' =>
            'Jeżeli ustawisz tu jakąś wartość, widok kolejek zgłoszeń będzie odświeżany w określonym interwale.',
        'Refresh QueueView after' => 'Odświeżaj widok kolejek co',
        'Screen after new ticket' => 'Ekran po nowym zgłoszeniu',
        'Show this screen after I created a new ticket' => 'Pokaż następujący widok po utworzeniu nowego zgłoszenia',
        'Closed Tickets' => 'Zamknięte zgłoszenia',
        'Show closed tickets.' => 'Pokaż zamknięte zgłoszenia.',
        'Max. shown Tickets a page in QueueView.' => 'Limit pokazywanych zgłoszeń na stronie Podglądu Kolejki',
        'Ticket Overview "Small" Limit' => 'Limit przeglądu zgłoszeń "Małe"',
        'Ticket limit per page for Ticket Overview "Small"' => 'Limit zgłoszeń na stronie dla przeglądu zgłoszeń "Małe"',
        'Ticket Overview "Medium" Limit' => 'Limit przeglądu zgłoszeń "Średnie"',
        'Ticket limit per page for Ticket Overview "Medium"' => 'Limit zgłoszeń na stronie dla przeglądu zgłoszeń "Średnie"',
        'Ticket Overview "Preview" Limit' => 'Limit przeglądu zgłoszeń "Podgląd"',
        'Ticket limit per page for Ticket Overview "Preview"' => 'Limit zgłoszeń na stronie dla przeglądu zgłoszeń "Podgląd"',
        'Ticket watch notification' => 'Powiadomienie o obserwowaniu zgłoszenia',
        'Send me the same notifications for my watched tickets that the ticket owners will get.' =>
            'Wysyłaj do mnie takie same powiadomienia dla obserwowanych przeze mnie zgłoszeń, jakie otrzymywać będą właściciele tych zgłoszeń.',
        'Send ticket watch notifications' => 'Przysyłaj powiadomienia gdy ktoś zacznie obserwować moje zgłoszenie',
        'Out Of Office Time' => 'Jestem poza biurem',
        'New Ticket' => 'Nowe zgłoszenie',
        'Create new Ticket' => 'Utwórz nowe zgłoszenie',
        'Customer called' => 'Telefon od klienta',
        'phone call' => 'Rozmowa tel.',
        'Phone Call Outbound' => 'Tel. wych.',
        'Phone Call Inbound' => 'Tel. przych.',
        'Reminder Reached' => 'Przypomnienie',
        'Reminder Tickets' => 'Przypomnienia zgłoszeń',
        'Escalated Tickets' => 'Zgłoszenia eskalowane',
        'New Tickets' => 'Nowe zgłoszenia',
        'Open Tickets / Need to be answered' => 'Zgłoszenia otwarte / wymagające odpowiedzi',
        'All open tickets, these tickets have already been worked on, but need a response' =>
            'Wszystkie otwarte zgłoszenia, były już podjęte prace w związku z nimi ale obecnie wymagają odpowiedzi',
        'All new tickets, these tickets have not been worked on yet' => 'Wszystkie nowe zgłoszenia, nie podjęto jeszcze prac w związku z nimi',
        'All escalated tickets' => 'Wszystkie eskalowane zgłoszenia',
        'All tickets with a reminder set where the reminder date has been reached' =>
            'Wszystkie zgłoszenia z ustawionym przypomnieniem, dla których minął czas przypomnienia',
        'Archived tickets' => 'Zarchiwizowane zgłoszenia',
        'Unarchived tickets' => 'Zgłoszenia przywrócone z archiwum',
        'Ticket Information' => 'Informacje o zgłoszeniu',

        # Template: AAAWeekDay
        'Sun' => 'Nie',
        'Mon' => 'Pon',
        'Tue' => 'Wt',
        'Wed' => 'Śr',
        'Thu' => 'Czw',
        'Fri' => 'Pią',
        'Sat' => 'Sob',

        # Template: AdminACL
        'ACL Management' => 'Zarządzanie ACL',
        'Filter for ACLs' => 'Filtr dla ACLi',
        'Filter' => 'Filtr',
        'ACL Name' => 'Nazwa ACL',
        'Actions' => 'Akcje',
        'Create New ACL' => 'Utwórz nowy ACL',
        'Deploy ACLs' => 'Zatwierdź ACL',
        'Export ACLs' => 'Eksportuj ACL',
        'Configuration import' => 'Import konfiguracji',
        'Here you can upload a configuration file to import ACLs to your system. The file needs to be in .yml format as exported by the ACL editor module.' =>
            'Tutaj możesz wgrać pliki konfiguracyjne ACL do systemu. Plik musi być w formacie .yml takim jaki jest eksportowany z modułu edytora ACL.',
        'This field is required.' => 'To pole jest wymagane.',
        'Overwrite existing ACLs?' => 'Nadpisać bieżący ACL?',
        'Upload ACL configuration' => 'Wgraj konfigurację ACL',
        'Import ACL configuration(s)' => 'Importuj konfigurację ACL',
        'To create a new ACL you can either import ACLs which were exported from another system or create a complete new one.' =>
            'By utworzyć nowy ACL możesz importować te uprzednio eksportowane z innego systemu lub utworzyć kompletnie nowe.',
        'Changes to the ACLs here only affect the behavior of the system, if you deploy the ACL data afterwards. By deploying the ACL data, the newly made changes will be written to the configuration.' =>
            'Zmiany dokonane tu dla ACLi będą mieć znaczenie dla twojego systemu dopiero po ich zatwierdzeniu. Zatwierdzająć ACLe nowe dane zostaną zapisane w konfiguracji.',
        'ACLs' => 'ACLe',
        'Please note: This table represents the execution order of the ACLs. If you need to change the order in which ACLs are executed, please change the names of the affected ACLs.' =>
            'Proszę zapamiętaj: Ta tabela reprezentuje kolejność wykonania ACLi. Jeśli potrzebujesz by kolejność była inna wówczas proszę zmień odpowiednio ich nazwy.',
        'ACL name' => 'Nazwa ACL',
        'Validity' => 'Aktualność',
        'Copy' => 'Kopia',
        'No data found.' => 'Nie odnaleziono żadnych elementów spełniających kryteria',

        # Template: AdminACLEdit
        'Edit ACL %s' => 'Edytuj ACL %s',
        'Go to overview' => 'Idź do przeglądu',
        'Delete ACL' => 'Usuń ACL',
        'Delete Invalid ACL' => 'Usuń nieprawidłowy ACL',
        'Match settings' => 'Dopasuj ustawienia',
        'Set up matching criteria for this ACL. Use \'Properties\' to match the current screen or \'PropertiesDatabase\' to match attributes of the current ticket that are in the database.' =>
            'Ustaw kryteria dla tego ACL. Uzyj \'Własciwości\' by dopasować obecne okno lub \'Właściwości Bazy Danych\' by dopasowac atrybuty obecnego zgłoszenia w bazie danych.',
        'Change settings' => 'Zmień ustawienia',
        'Set up what you want to change if the criteria match. Keep in mind that \'Possible\' is a white list, \'PossibleNot\' a black list.' =>
            'Ustaw co chcesz zmienić jeśli kryteria zostaną spełnione. Prosze zapamiętaj, że \'możliwe\' jest białą listą, \'Niemożliwe\' jest czarną listą',
        'Check the official' => 'Oznacz jako oficjalne',
        'documentation' => 'dokumentacja',
        'Show or hide the content' => 'Pokaż lub ukryj treść',
        'Edit ACL information' => 'Edytuj informację ACL',
        'Stop after match' => 'Zatrzymaj po dopasowaniu',
        'Edit ACL structure' => 'Edytuj strukturę ACL',
        'Save' => 'Zapisz',
        'or' => 'lub',
        'Save and finish' => 'Zapisz i zakończ',
        'Do you really want to delete this ACL?' => 'Czy na pewno chcesz usunąć ten ACL?',
        'This item still contains sub items. Are you sure you want to remove this item including its sub items?' =>
            'Ta pozycja nadal zawiera podpozycje. Czy jesteś pewien, że chce usunąć ją wraz z nimi?',
        'An item with this name is already present.' => 'Pozycja o tej nazwie już istnieje.',
        'Add all' => 'Dodaj wszystkie',
        'There was an error reading the ACL data.' => 'Nastąpił błąd przy odczycie danych ACL.',

        # Template: AdminACLNew
        'Create a new ACL by submitting the form data. After creating the ACL, you will be able to add configuration items in edit mode.' =>
            'Utwórz nowy ACL poprzez wypełnienie formularza danych. Po dodaniu ACL będzie możliwe dodawanie pozycji konfiguracji w trybie edycji.',

        # Template: AdminAttachment
        'Attachment Management' => 'Zarządzanie załącznikami',
        'Add attachment' => 'Dodaj załącznik',
        'List' => 'Lista',
        'Download file' => 'Pobierz plik',
        'Delete this attachment' => 'Usuń ten załącznik',
        'Add Attachment' => 'Dodaj załącznik',
        'Edit Attachment' => 'Edytuj załącznik',

        # Template: AdminAutoResponse
        'Auto Response Management' => 'Zarządzanie automatycznymi odpowiedziami',
        'Add auto response' => 'Dodaj odpowiedź automatyczną',
        'Add Auto Response' => 'Dodaj Odpowiedź Automatyczną',
        'Edit Auto Response' => 'Edytuj odpowiedź automatyczną',
        'Response' => 'Odpowiedź',
        'Auto response from' => 'Automatyczna odpowiedź od',
        'Reference' => 'Podpowiedzi',
        'You can use the following tags' => 'Możesz używać następujących znaczników',
        'To get the first 20 character of the subject.' => 'Pokaż pierwsze 20 znaków tematu.',
        'To get the first 5 lines of the email.' => 'Pokaż 5 linii wiadomości e-mail.',
        'To get the realname of the sender (if given).' => 'Pokaż imię i nazwisko nadawcy (jeżeli podał).',
        'To get the article attribute' => 'Pokaż atrybut artykułu.',
        ' e. g.' => 'np.',
        'Options of the current customer user data' => 'Opcje danych obecnego konta klienta',
        'Ticket owner options' => 'Opcje właściciela zgłoszenia',
        'Ticket responsible options' => 'Opcje odpowiedzialego za zgłoszenie',
        'Options of the current user who requested this action' => 'Opcje bieżącego użytkownika, który żądał akcji',
        'Options of the ticket data' => 'Opcje danych zgłoszenia',
        'Options of ticket dynamic fields internal key values' => 'Opcje wewnętrznych wartości kluczy pól dynamicznych zgłoszeń',
        'Options of ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            'Opcje wartości wyświetlanych pól dynamicznych zgłoszeń, przydatne dla pól Dropdown i Multiselect',
        'Config options' => 'Opcje konfiguracyjne',
        'Example response' => 'Przykładowa odpowiedź',

        # Template: AdminCustomerCompany
        'Customer Management' => 'Zarządzanie klientami',
        'Wildcards like \'*\' are allowed.' => 'Wieloznaczniki (wildcards) takie jak \'*\' są dozwolone.',
        'Add customer' => 'Dodaj klienta',
        'Select' => 'Zaznacz',
        'Please enter a search term to look for customers.' => 'Prosimy wprowadź frazę wyszukiwania by odszukać klientów.',
        'Add Customer' => 'Dodaj Klienta',

        # Template: AdminCustomerUser
        'Customer User Management' => 'Zarządzanie kontami klienta',
        'Back to search results' => 'Wstecz do wyników wyszukiwania',
        'Add customer user' => 'Dodaj konto klienta',
        'Hint' => 'Podpowiedź',
        'Customer user are needed to have a customer history and to login via customer panel.' =>
            'Konto klienta jest konieczne by móc posiadać historię klienta oraz logować się przez panel klienta.',
        'Last Login' => 'Ostatnie logowanie',
        'Login as' => 'Zaloguj jako',
        'Switch to customer' => 'Przełącz na klienta',
        'Add Customer User' => '',
        'Edit Customer User' => 'Edytuj konto klienta',
        'This field is required and needs to be a valid email address.' =>
            'To pole jest wymagane i musi być poprawnym adresem e-mail.',
        'This email address is not allowed due to the system configuration.' =>
            'Ten adres e-mail nie jest dozwolony z uwagi na konfigurację systemu.',
        'This email address failed MX check.' => 'Walidacja MX tego adresu e-mail nie powiodła się.',
        'DNS problem, please check your configuration and the error log.' =>
            'Problem z DNS, sprawdź konfigurację i log błędów.',
        'The syntax of this email address is incorrect.' => 'Składnia tego adresu e-mail jest niepoprawna.',

        # Template: AdminCustomerUserGroup
        'Manage Customer-Group Relations' => 'Zarządzaj relacjami Klient-Grupa',
        'Notice' => 'Uwaga',
        'This feature is disabled!' => 'Ta funkcja jest wyłączona!',
        'Just use this feature if you want to define group permissions for customers.' =>
            'Użyj tej funkcji jeśli chcesz zdefinioać grupę uprawnień dla klientów.',
        'Enable it here!' => 'Włącz tutaj!',
        'Edit Customer Default Groups' => 'Edytuj domyślne Grupy Klientów',
        'These groups are automatically assigned to all customers.' => 'Te grupy są automatycznie przypisane do wszystkich klientów.',
        'You can manage these groups via the configuration setting "CustomerGroupAlwaysGroups".' =>
            'Możesz zarządzać tymi grupami poprzez parametr "CustomerGroupAlwaysGroups".',
        'Filter for Groups' => 'Filtr dla grup.',
        'Just start typing to filter...' => '',
        'Select the customer:group permissions.' => 'Wybierz uprawnienia klient:grupa',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer).' =>
            'Jeśli nic nie zostało zaznaczone, wtedy nie ma uprawnień w tej grupie (zgłoszenia nie będą dostępne dla klienta).',
        'Search Results' => 'Wyniki wyszukiwania',
        'Customers' => 'Klienci',
        'No matches found.' => 'Nie odnaleziono dopasowań.',
        'Change Group Relations for Customer' => 'Zmień relacje grupy dla klienta',
        'Change Customer Relations for Group' => 'Zmień relacje klienta do grup',
        'Toggle %s Permission for all' => 'Przełącz uprawnienie %s dla wszystkich',
        'Toggle %s permission for %s' => 'Przełącz uprawnienie %s dla %s',
        'Customer Default Groups:' => 'Domyślne grupy klientów',
        'No changes can be made to these groups.' => 'Nie można wprowadzić zmian do tych grup.',
        'ro' => 'odczyt',
        'Read only access to the ticket in this group/queue.' => 'Prawo jedynie do odczytu zgłoszeń w tej grupie/kolejce',
        'rw' => 'odczyt/zapis',
        'Full read and write access to the tickets in this group/queue.' =>
            'Prawa pełnego odczytu i zapisu zgłoszeń w tej grupie/kolejce',

        # Template: AdminCustomerUserService
        'Manage Customer-Services Relations' => 'Zarządzaj relacjami Klient-Usługa',
        'Edit default services' => 'Edytuj domyślną usługę',
        'Filter for Services' => 'Filtruj usługi',
        'Allocate Services to Customer' => 'Przypisz usługi do klienta',
        'Allocate Customers to Service' => 'Przypisz klientów do usługi',
        'Toggle active state for all' => 'Przełącz stan aktywności dla wszystkich',
        'Active' => 'Aktywne',
        'Toggle active state for %s' => 'Przełącz stan aktywności dla %s',

        # Template: AdminDynamicField
        'Dynamic Fields Management' => 'Zarządzanie polami dynamicznymi',
        'Add new field for object' => 'Dodaj nowej pole do obiektu',
        'To add a new field, select the field type from one of the object\'s list, the object defines the boundary of the field and it can\'t be changed after the field creation.' =>
            '',
        'Dynamic Fields List' => 'Lista pól dynamicznych',
        'Dynamic fields per page' => 'Pola dynamiczne na stronę',
        'Label' => 'Etykieta',
        'Order' => 'Porządek',
        'Object' => 'Obiekt',
        'Delete this field' => 'Usuń to pole',
        'Do you really want to delete this dynamic field? ALL associated data will be LOST!' =>
            'Czy na pewno chcesz usunąć to pole dynamiczne? Wszystkie związane dane będą USUNIĘTE!',
        'Delete field' => 'Usuń pole',

        # Template: AdminDynamicFieldCheckbox
        'Field' => 'Pole',
        'Go back to overview' => 'Powrót do przeglądu',
        'General' => 'Ogólne',
        'This field is required, and the value should be alphabetic and numeric characters only.' =>
            'To pole jest wymaganel a wartość powinna być alfanumeryczna.',
        'Must be unique and only accept alphabetic and numeric characters.' =>
            'Musi być unikalne i zawierać wyłącznie znaki alfanumeryczne.',
        'Changing this value will require manual changes in the system.' =>
            'Zmiana tej wartości wymagać będzie ręcznych zmian w systemie.',
        'This is the name to be shown on the screens where the field is active.' =>
            'Ta nazwa będzie wyświetlana na ekranach, na których pole to będzie aktywne.',
        'Field order' => 'Kolejność pola',
        'This field is required and must be numeric.' => 'To pole jest wymagane i musi być numeryczne.',
        'This is the order in which this field will be shown on the screens where is active.' =>
            'To jest kolejność zgodnie z którą pole to będzie wyświetlane na ekranach, na których pole to będzie aktywne.',
        'Field type' => 'Typ pola',
        'Object type' => 'Typ obiektu',
        'Internal field' => 'Pole wewnętrzne',
        'This field is protected and can\'t be deleted.' => 'To pole jest chronione i nie może być usunięte.',
        'Field Settings' => 'Ustawienia pola',
        'Default value' => 'Domyślna wartość',
        'This is the default value for this field.' => 'To jest domyślna wartość tego pola.',

        # Template: AdminDynamicFieldDateTime
        'Default date difference' => 'Domyślne przesunięcie daty',
        'This field must be numeric.' => 'To pole musi być numeryczne.',
        'The difference from NOW (in seconds) to calculate the field default value (e.g. 3600 or -60).' =>
            'Przesunięcie w sekundach względem czasu bieżącego do obliczenia domyślnej wartości pola (mp. 3600 lub -60).',
        'Define years period' => 'Zdefiniuj zakres lat',
        'Activate this feature to define a fixed range of years (in the future and in the past) to be displayed on the year part of the field.' =>
            'Uaktywnij tę opcję aby zdefiniować ograniczony przedział lat (w przyszłość i przeszłość) wyświetlanych w części "rok" tego pola.',
        'Years in the past' => 'Lata wstecz',
        'Years in the past to display (default: 5 years).' => 'Liczba wyświetlanych lat wstecz (domyślnie: 5 lat).',
        'Years in the future' => 'Lata naprzód',
        'Years in the future to display (default: 5 years).' => 'Liczba wyświetlanych lat naprzód (domyślnie: 5 lat).',
        'Show link' => 'Pokaż odnośnik',
        'Here you can specify an optional HTTP link for the field value in Overviews and Zoom screens.' =>
            'Tutaj możesz ustalić opcjonalny odnośnik HTTP dla wartości pola, który będzie wyświetlany na ekranach przeglądów i szczegółów.',
        'Restrict entering of dates' => '',
        'Here you can restrict the entering of dates of tickets.' => '',

        # Template: AdminDynamicFieldDropdown
        'Possible values' => 'Dopuszczalne wartości',
        'Key' => 'Klucz',
        'Value' => 'Wartość',
        'Remove value' => 'Usuń wartość',
        'Add value' => 'Dodaj wartość',
        'Add Value' => 'Dodaj Wartość',
        'Add empty value' => 'Dodaj pustą wartość',
        'Activate this option to create an empty selectable value.' => 'Uaktywnij tę opcję by utworzyć pustą, wybieralną wartość.',
        'Tree View' => 'Widok drzewa',
        'Activate this option to display values as a tree.' => 'Aktywuj tę opcję by otrzymać wartości w formie drzewa.',
        'Translatable values' => 'Wartości przetłumaczalne',
        'If you activate this option the values will be translated to the user defined language.' =>
            'Jeśli uaktywnisz tę opcję, wartości zostaną przetłumaczone na język użytkownika.',
        'Note' => 'Uwaga',
        'You need to add the translations manually into the language translation files.' =>
            'Musisz dodać tłumaczenia ręcznie do plików z tłumaczeniami.',

        # Template: AdminDynamicFieldText
        'Number of rows' => 'Liczba wierszy',
        'Specify the height (in lines) for this field in the edit mode.' =>
            'Określ wysokość (w liniach) dla tego pola w trybie edycji.',
        'Number of cols' => 'Liczba kolumn',
        'Specify the width (in characters) for this field in the edit mode.' =>
            'Określ szerokość (w znakach) dla tego pola w trybie edycji.',
        'Check RegEx' => '',
        'Here you can specify a regular expression to check the value. The regex will be executed with the modifiers xms.' =>
            '',
        'RegEx' => '',
        'Invalid RegEx' => '',
        'Error Message' => 'Komunikat błędu',
        'Add RegEx' => '',

        # Template: AdminEmail
        'Admin Notification' => 'Powiadomienia administratora',
        'With this module, administrators can send messages to agents, group or role members.' =>
            'Przy pomocy tego modułu administratorzy mogą wysyłać wiadomości do agentów, członków grup lub ról.',
        'Create Administrative Message' => 'Utwórz wiadomość od administratora',
        'Your message was sent to' => 'Twoja wiadomość została wysłana do',
        'Send message to users' => 'Wyślij wiadomość do użytkowników',
        'Send message to group members' => 'Wyślij wiadomość do członków grupy',
        'Group members need to have permission' => 'Członkowie grupy muszą posiadać uprawnienia',
        'Send message to role members' => 'Wyślij wiadomość do posiadaczy roli',
        'Also send to customers in groups' => 'Wyślij także, do klientów w grupach',
        'Body' => 'Treść',
        'Send' => 'Wyślij',

        # Template: AdminGenericAgent
        'Generic Agent' => 'Agent automatyczny',
        'Add job' => 'Dodaj zadanie',
        'Last run' => 'Ostatnie uruchomienie',
        'Run Now!' => 'Uruchom teraz',
        'Delete this task' => 'Usuń to zadanie',
        'Run this task' => 'Uruchom to zadanie',
        'Job Settings' => 'Ustawienia zadania',
        'Job name' => 'Nazwa zadania',
        'The name you entered already exists.' => 'Podana nazwa już istnieje.',
        'Toggle this widget' => 'Przełącz ten gadżet',
        'Automatic execution (multiple tickets)' => 'Wykonanie automatyczne (Wiele zgłoszeń)',
        'Execution Schedule' => 'Harmonogram wykonania',
        'Schedule minutes' => 'Ustal minuty',
        'Schedule hours' => 'Ustal godziny',
        'Schedule days' => 'Ustal dni',
        'Currently this generic agent job will not run automatically.' =>
            'Zadanie nie zostanie uruchomione automatycznie.',
        'To enable automatic execution select at least one value from minutes, hours and days!' =>
            'Aby uruchomić automatyczne wykonywanie zaznacz przynajmniej jedną wartość dla minut, godzin i dni!',
        'Event based execution (single ticket)' => 'Wykonywanie bazowane na zdarzeniach (pojedyńcze zgłoszenie)',
        'Event Triggers' => 'Triggery',
        'List of all configured events' => 'Lista wszystkich skonfigurowanych zdarzeń',
        'Delete this event' => 'Usuń to zdarzenie',
        'Additionally or alternatively to a periodic execution, you can define ticket events that will trigger this job.' =>
            'Dodatkowo lub alternatywnie dla wykonywania okresowego możesz zdefiniować zdarzenia które spowodują wykonannie tego zadania.',
        'If a ticket event is fired, the ticket filter will be applied to check if the ticket matches. Only then the job is run on that ticket.' =>
            'Jeśli zgłoszenie zostanie wykonane wówczas filtr zgłoszeń zostanie wykonany dla sprawdzenia dopasowania zgłoszenia. Tylko wówczas zadanie jest wykonane na danym zgłoszeniu.',
        'Do you really want to delete this event trigger?' => 'Czy na pewno chcesz usunąć ten trigger?',
        'Add Event Trigger' => 'Dodaj trigger',
        'Add Event' => '',
        'To add a new event select the event object and event name and click on the "+" button' =>
            'Aby dodać nowe zdarzenie, zaznacz obiekt zdarzenia i nazwę zdarzenia i kliknij przycisk "+"',
        'Duplicate event.' => 'Duplikuj zdarzenie',
        'This event is already attached to the job, Please use a different one.' =>
            'Jeśli zdarzenie jest już dodane do zadania wówczas prosze użyj innego.',
        'Delete this Event Trigger' => 'Usuń ten trigger',
        'Select Tickets' => '',
        '(e. g. 10*5155 or 105658*)' => '(np. 10*5155 lub 105658*)',
        '(e. g. 234321)' => '(np. 3242442)',
        'Customer login' => 'Login klienta',
        '(e. g. U5150)' => '(np. U4543)',
        'Fulltext-search in article (e. g. "Mar*in" or "Baue*").' => 'Pełnotekstowe w artykule (np. "J*n" or "Kowalsk*")',
        'Agent' => 'Agent',
        'Ticket lock' => 'Blokada zgłoszenia',
        'Create times' => 'Czasy utworzenia',
        'No create time settings.' => 'Bez czasów utworzenia.',
        'Ticket created' => 'Zgłoszenie utworzone',
        'Ticket created between' => 'Zgłoszenie utworzone między',
        'Last changed times' => '',
        'No last changed time settings.' => '',
        'Ticket last changed' => '',
        'Ticket last changed between' => '',
        'Change times' => 'Zmień czasy',
        'No change time settings.' => 'Brak zmiany ustawień czasu',
        'Ticket changed' => 'Zgłoszenie zmieniono',
        'Ticket changed between' => 'Zgłoszenie zmieniono pomiędzy',
        'Close times' => 'Czasy zamknięcia',
        'No close time settings.' => 'Bez czasów zamkniecia.',
        'Ticket closed' => 'Zgłoszenie zamknięte',
        'Ticket closed between' => 'Zgłoszenie zamknięte między',
        'Pending times' => 'Czasy oczekiwania',
        'No pending time settings.' => 'Bez czasów oczekiwania.',
        'Ticket pending time reached' => 'Oczekiwanie zakończone',
        'Ticket pending time reached between' => 'Oczekiwanie zakończone między',
        'Escalation times' => 'Czasy eskalacji',
        'No escalation time settings.' => 'Brak ustawionego czasu eskalacji.',
        'Ticket escalation time reached' => 'Osiągnięty czas eskalacji zgłoszenia',
        'Ticket escalation time reached between' => 'Czas eskalacji zgłoszenia będzie osiągnięty za',
        'Escalation - first response time' => 'Eskalacja - czas pierwszej odpowiedzi',
        'Ticket first response time reached' => 'Osiągnięty czas pierwszej odpowiedzi na zgłoszenie',
        'Ticket first response time reached between' => 'Czas pierwszej odpowiedzi na zgłoszenie będzie osiągnięty za',
        'Escalation - update time' => 'Eskalacja - czas aktualizacji',
        'Ticket update time reached' => 'Osiągnięty czas aktualizacji zgłoszenia',
        'Ticket update time reached between' => 'Czas aktualizacji zgłoszenia będzie osiągnięty za',
        'Escalation - solution time' => 'Eskalacja - czas rozwiązania',
        'Ticket solution time reached' => 'Osiągnięty czas rozwiązania zgłoszenia',
        'Ticket solution time reached between' => 'Czas rozwiązania zgłoszenia będzie osiągnięty za',
        'Archive search option' => 'Aktywna opcja szukania',
        'Update/Add Ticket Attributes' => '',
        'Set new service' => 'Ustaw nową usługę',
        'Set new Service Level Agreement' => 'Ustaw nowe SLA',
        'Set new priority' => 'Ustaw nowy priorytet',
        'Set new queue' => 'Ustaw nową kolejkę',
        'Set new state' => 'Ustaw nowy status',
        'Pending date' => 'Data oczekiwania',
        'Set new agent' => 'Ustaw nowego agenta',
        'new owner' => 'nowy właściciel',
        'new responsible' => 'nowy odpowiedzialny',
        'Set new ticket lock' => 'Ustaw nowy status blokady zgłoszenia',
        'New customer' => 'Nowy klient',
        'New customer ID' => 'Nowe ID klienta',
        'New title' => 'Nowy tytuł',
        'New type' => 'Nowy typ',
        'New Dynamic Field Values' => 'Wartości nowego pola dynamicznego',
        'Archive selected tickets' => 'Zarchiwizuj zaznaczone zgłoszenia',
        'Add Note' => 'Dodaj notatkę',
        'Time units' => 'Zaraportowany czas obsługi',
        'Execute Ticket Commands' => '',
        'Send agent/customer notifications on changes' => 'Wyślij powidomienia agentowi/klientowi przy zmianie ',
        'CMD' => 'linia poleceń',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' =>
            'Komenda zostanie wykonana. ARG[0] to numer zgłoszenia. ARG[1] to id zgłoszenia.',
        'Delete tickets' => 'Usuń zgłoszenia',
        'Warning: All affected tickets will be removed from the database and cannot be restored!' =>
            'Uwaga: wszystkie wybrane zgłoszenia będą usunięte z bazy danych i nie będzie można ich przywrócić!',
        'Execute Custom Module' => 'Uruchom własny moduł',
        'Param %s key' => 'Klucz parametru %s',
        'Param %s value' => 'Wartość parametru %s',
        'Save Changes' => 'Zapisz zmiany',
        'Results' => 'Wyniki',
        '%s Tickets affected! What do you want to do?' => 'Liczba wybranych zgłoszeń %s. Co chcesz zrobić?',
        'Warning: You used the DELETE option. All deleted tickets will be lost!' =>
            'Uwaga: Użyta została opcja USUWANIA. Wszystkie usunięte zgłoszenia będą utracone!',
        'Edit job' => 'Edytuj zadanie',
        'Run job' => 'Wykonaj zadanie',
        'Affected Tickets' => 'Wybrane zgłoszenia',

        # Template: AdminGenericInterfaceDebugger
        'GenericInterface Debugger for Web Service %s' => 'GenericInterface Debugger dla serwisu sieciowego %s',
        'Web Services' => 'Usługi Sieciowe',
        'Debugger' => 'Debugger',
        'Go back to web service' => 'Powróć do usług sieciowych',
        'Clear' => 'Wyczyść',
        'Do you really want to clear the debug log of this web service?' =>
            'Czy na pewno chcesz wyczyścić log debug tego serwisu sieciowego?',
        'Request List' => 'Lista żądań',
        'Time' => 'Czas',
        'Remote IP' => 'Zdalny IP',
        'Loading' => 'Ładowanie',
        'Select a single request to see its details.' => 'Zaznacz pojedyncze żądanie aby zobaczyć jego szczegóły.',
        'Filter by type' => 'Filtruj po typie',
        'Filter from' => 'Filtruj od',
        'Filter to' => 'Filtruj do',
        'Filter by remote IP' => 'Filtruj po zdalnym IP',
        'Refresh' => 'Odswież',
        'Request Details' => 'Szczegóły żądania',
        'An error occurred during communication.' => 'W trakcie komunikacji wystąpił błąd.',
        'Show or hide the content.' => 'Pokaż lub ukryj zawartość.',
        'Clear debug log' => 'Wyczyść log debug',

        # Template: AdminGenericInterfaceInvokerDefault
        'Add new Invoker to Web Service %s' => 'Dodaj nowy invoker do serwisu sieciowego %s',
        'Change Invoker %s of Web Service %s' => 'Zmień invoker %s w serwisu sieciowego %s',
        'Add new invoker' => 'Dodaj nowy invoker',
        'Change invoker %s' => 'Zmień invoker %s',
        'Do you really want to delete this invoker?' => 'Czy na pewno chcesz usunąć ten invoker?',
        'All configuration data will be lost.' => 'Cała konfiguracja zostanie utracona.',
        'Invoker Details' => 'Szczegóły invokera.',
        'The name is typically used to call up an operation of a remote web service.' =>
            'Nazwa jest zwykle używana do wywołania operacji zdalnego serwisu sieciowego.',
        'Please provide a unique name for this web service invoker.' => 'Podaj unikalną nazwę dla tego invokera.',
        'Invoker backend' => 'Zaplecze invokera',
        'This OTRS invoker backend module will be called to prepare the data to be sent to the remote system, and to process its response data.' =>
            'Ten moduł zaplecza invokera OTRS będzie wywołany by przygotować dane do wysyłki do systemu zdalnego oraz by przetworzyć odpowiedź z tego systemu.',
        'Mapping for outgoing request data' => 'Mapowanie wysyłanych danych żądania',
        'Configure' => 'Konfiguruj',
        'The data from the invoker of OTRS will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            'Dane z invokera OTRS będą przetworzone przez to mapowanie na dane oczekiwane przez system zdalny.',
        'Mapping for incoming response data' => 'Mapowanie otrzymanych danych z odpowiedzi',
        'The response data will be processed by this mapping, to transform it to the kind of data the invoker of OTRS expects.' =>
            'Dane z odpowiedzi będą przetworzone przez to mapowanie na dane oczekiwane przez invoker OTRS.',
        'Asynchronous' => 'Asynchroniczny',
        'This invoker will be triggered by the configured events.' => 'Ten invoker będzie wykonany przez skonfigurowane zdarzenia.',
        'Asynchronous event triggers are handled by the OTRS Scheduler in background (recommended).' =>
            'Triggery asynchroniczne są obsługiwane przez harmonogram zadań OTRS w tle (zalecane).',
        'Synchronous event triggers would be processed directly during the web request.' =>
            'Triggery synchroniczne będą przetwarzane bezpośrednio w trakcie przetwarzania żądania web.',
        'Save and continue' => 'Zapisz i kontynuuj',
        'Delete this Invoker' => 'Usuń ten invoker',

        # Template: AdminGenericInterfaceMappingSimple
        'GenericInterface Mapping Simple for Web Service %s' => 'Proste mapowanie GenericInterface dla serwisu sieciowego %s',
        'Go back to' => 'Powrót do',
        'Mapping Simple' => 'Proste mapowanie',
        'Default rule for unmapped keys' => 'Domyślna reguła dla niezmapowanych kluczy',
        'This rule will apply for all keys with no mapping rule.' => 'Ta reguła będzie obowiązywać dla wszystkich kluczy bez reguły mapowania.',
        'Default rule for unmapped values' => 'Domyślna reguła dla niezamapowanych wartości',
        'This rule will apply for all values with no mapping rule.' => 'Ta reguła będzie obowiązywać dla wszystkich wartości bez reguły mapowania.',
        'New key map' => 'Nowe mapowanie klucza',
        'Add key mapping' => 'Dodaj mapowanie klucza',
        'Mapping for Key ' => 'Mapowanie klucza',
        'Remove key mapping' => 'Usuń mapowanie',
        'Key mapping' => 'Mapowanie klucza',
        'Map key' => 'Mapuj klucz',
        'matching the' => 'dopasowywanie',
        'to new key' => 'do nowego klucza',
        'Value mapping' => 'Mapowanie wartości',
        'Map value' => 'Mapuj wartość',
        'to new value' => 'na nową wartość',
        'Remove value mapping' => 'Usuń mapowanie wartości',
        'New value map' => 'Nowe mapowanie wartości',
        'Add value mapping' => 'Dodaj mapowanie wartości',
        'Do you really want to delete this key mapping?' => 'Czy na pewno chcesz usunąć to mapowanie klucza?',
        'Delete this Key Mapping' => 'Usuń to mapowanie klucza',

        # Template: AdminGenericInterfaceOperationDefault
        'Add new Operation to Web Service %s' => 'Dodaj nową operację do serwisu sieciowego %s',
        'Change Operation %s of Web Service %s' => 'Zmień operację %s serwisu sieciowego %s',
        'Add new operation' => 'Dodaj nową operację',
        'Change operation %s' => 'Zmień operację %s',
        'Do you really want to delete this operation?' => 'Czy na pewno chcesz usunąć tę operację?',
        'Operation Details' => 'Szczegóły operacji',
        'The name is typically used to call up this web service operation from a remote system.' =>
            'Nazwa jest zwykle używana do wywoływania tej operacji serwisu sieciowego ze zdalnego systemu.',
        'Please provide a unique name for this web service.' => 'Podaj unikalną nazwę dla tego serwisu sieciowego.',
        'Mapping for incoming request data' => 'Mapowanie otrzymanych danych żądania',
        'The request data will be processed by this mapping, to transform it to the kind of data OTRS expects.' =>
            'Dane żądania będą przetwarzane przez to mapowanie aby przekształcić je do postaci oczekiwanej przez OTRS.',
        'Operation backend' => 'Zaplecze operacji',
        'This OTRS operation backend module will be called internally to process the request, generating data for the response.' =>
            'Ten moduł zaplecza operacji OTRS będzie wywoływany wewnętrznie aby przetworzyć żądanie i wygenerować dane odpowiedzi.',
        'Mapping for outgoing response data' => 'Mapowanie danych wysyłanej odpowiedzi',
        'The response data will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            'Dane odpowiedzi będą przetwarzane przez to mapowanie aby przetworzyć je do postaci oczekiwanej przez system zdalny.',
        'Delete this Operation' => 'Usuń tę operację',

        # Template: AdminGenericInterfaceTransportHTTPREST
        'GenericInterface Transport HTTP::REST for Web Service %s' => '',
        'Network transport' => 'Transport sieciowy',
        'Properties' => 'Właściwości',
        'Route mapping for Operation' => '',
        'Define the route that should get mapped to this operation. Variables marked by a \':\' will get mapped to the entered name and passed along with the others to the mapping. (e.g. /Ticket/:TicketID).' =>
            '',
        'Valid request methods for Operation' => '',
        'Limit this Operation to specific request methods. If no method is selected all requests will be accepted.' =>
            '',
        'Maximum message length' => 'Maksymalna długość wiadomości',
        'This field should be an integer number.' => 'To pole powinno być liczbą całkowitą.',
        'Here you can specify the maximum size (in bytes) of REST messages that OTRS will process.' =>
            '',
        'Send Keep-Alive' => '',
        'This configuration defines if incoming connections should get closed or kept alive.' =>
            '',
        'Host' => 'Adres',
        'Remote host URL for the REST requests.' => '',
        'e.g https://www.otrs.com:10745/api/v1.0 (without trailing backslash)' =>
            '',
        'Controller mapping for Invoker' => '',
        'The controller that the invoker should send requests to. Variables marked by a \':\' will get replaced by the data value and passed along with the request. (e.g. /Ticket/:TicketID?UserLogin=:UserLogin&Password=:Password).' =>
            '',
        'Valid request command for Invoker' => '',
        'A specific HTTP command to use for the requests with this Invoker (optional).' =>
            '',
        'Default command' => '',
        'The default HTTP command to use for the requests.' => '',
        'Authentication' => 'Autentykacja',
        'The authentication mechanism to access the remote system.' => 'Mechanizm autentykacji używany przy dostępie do systemu zdalnego.',
        'A "-" value means no authentication.' => 'Wartość "-" oznacza brak auntentykacji.',
        'The user name to be used to access the remote system.' => 'Nazwa użytkownika do logowania do zdalnego systemu.',
        'The password for the privileged user.' => 'Hasło użytkownika do logowania do zdalnego systemu.',
        'Use SSL Options' => 'Użyj opcji SSL',
        'Show or hide SSL options to connect to the remote system.' => 'Pokaż lub ukryj opcje SSL połączenia do zdalnego systemu.',
        'Certificate File' => 'Plik certyfikatu',
        'The full path and name of the SSL certificate file.' => '',
        'e.g. /opt/otrs/var/certificates/REST/ssl.crt' => '',
        'Certificate Password File' => 'Plik z hasłem certyfikatu',
        'The full path and name of the SSL key file.' => '',
        'e.g. /opt/otrs/var/certificates/REST/ssl.key' => '',
        'Certification Authority (CA) File' => 'Plik Certification Authority (CA)',
        'The full path and name of the certification authority certificate file that validates the SSL certificate.' =>
            '',
        'e.g. /opt/otrs/var/certificates/REST/CA/ca.file' => '',

        # Template: AdminGenericInterfaceTransportHTTPSOAP
        'GenericInterface Transport HTTP::SOAP for Web Service %s' => 'Transport GenericInterface HTTP::SOAP dla serwisu sieciowego %s',
        'Endpoint' => 'Punkt końcowy',
        'URI to indicate a specific location for accessing a service.' =>
            'URI wskazyjące określoną lokalizację dostępu do usługi.',
        'e.g. http://local.otrs.com:8000/Webservice/Example' => 'np. http://local.otrs.com:8000/Webservice/Example',
        'Namespace' => 'Namespace',
        'URI to give SOAP methods a context, reducing ambiguities.' => 'URI nadające kontekst metodom SOAP w celu uniknięcia niejednoznaczności.',
        'e.g urn:otrs-com:soap:functions or http://www.otrs.com/GenericInterface/actions' =>
            'np. urn:otrs-com:soap:functions lub http://www.otrs.com/GenericInterface/actions',
        'Here you can specify the maximum size (in bytes) of SOAP messages that OTRS will process.' =>
            'Tutaj możesz określić maksymalny rozmiar (w bajtach) wiadomości SOAP, które OTRS będzie przetwarzać.',
        'Encoding' => 'Kodowanie',
        'The character encoding for the SOAP message contents.' => 'Kodowanie znaków dla zawartości wiadomości SOAP.',
        'e.g utf-8, latin1, iso-8859-1, cp1250, Etc.' => 'np. utf-8, latin1, iso-8859-1, cp1250, etc.',
        'SOAPAction' => 'SOAPAction',
        'Set to "Yes" to send a filled SOAPAction header.' => 'Ustaw "Tak" aby wysłać wypełniony nagłówek SOAPAction.',
        'Set to "No" to send an empty SOAPAction header.' => 'Ustaw "Nie" aby wysłać pusty nagłówek SOAPAction.',
        'SOAPAction separator' => 'Separator SOAPAction',
        'Character to use as separator between name space and SOAP method.' =>
            'Znak, który ma być używany jako separator między namespace i metodą SOAP.',
        'Usually .Net web services uses a "/" as separator.' => 'Serwisy sieciowe .net używają zwykle "/" jako separatora.',
        'The full path and name of the SSL certificate file (must be in .p12 format).' =>
            'Pełna ścieżka i nazwa pliku z certyfikatem (musi być w formacie .p12).',
        'e.g. /opt/otrs/var/certificates/SOAP/certificate.p12' => 'np. /opt/otrs/var/certificates/SOAP/certificate.p12',
        'The password to open the SSL certificate.' => 'Hasło do otwarcia certyfikatu.',
        'The full path and name of the certification authority certificate file that validates SSL certificate.' =>
            'Pełna ścieżka i nazwa pliku z certyfikatem CA, który potwierdza certyfikat SSL.',
        'e.g. /opt/otrs/var/certificates/SOAP/CA/ca.pem' => 'np. /opt/otrs/var/certificates/SOAP/CA/ca.pem',
        'Certification Authority (CA) Directory' => 'Katalog Certification Authority (CA)',
        'The full path of the certification authority directory where the CA certificates are stored in the file system.' =>
            'Pełna ścieżka do katalogu gdzie znajdują się certyfikaty CA.',
        'e.g. /opt/otrs/var/certificates/SOAP/CA' => 'np. /opt/otrs/var/certificates/SOAP/CA',
        'Proxy Server' => 'Serwer proxy',
        'URI of a proxy server to be used (if needed).' => 'URI serwera proxy jeśli ma być używany (jeśli wymagane).',
        'e.g. http://proxy_hostname:8080' => 'np. http://proxy_hostname:8080',
        'Proxy User' => 'Użytkownik proxy',
        'The user name to be used to access the proxy server.' => 'Nazwa użytkownika, która ma być używana do logowania do serwera proxy.',
        'Proxy Password' => 'Hasło do proxy',
        'The password for the proxy user.' => 'Hasło użytkownika proxy.',

        # Template: AdminGenericInterfaceWebservice
        'GenericInterface Web Service Management' => 'Zarządzanie serwisami sieciowymi GenericInterface',
        'Add web service' => 'Dodaj serwis sieciowy',
        'Clone web service' => 'Klonuj serwis sieciowy',
        'The name must be unique.' => 'Nazwa musi być unikalna',
        'Clone' => 'Klonuj',
        'Export web service' => 'Eksportuj serwis sieciowy',
        'Import web service' => 'Importuj serwis sieciowy',
        'Configuration File' => 'Plik konfiguracyjny.',
        'The file must be a valid web service configuration YAML file.' =>
            'Plik musi być poprawnym plikiem konfiguracyjnym YAML web service.',
        'Import' => 'Importuj',
        'Configuration history' => 'Historia konfiguracji',
        'Delete web service' => 'Usuń serwis sieciowy',
        'Do you really want to delete this web service?' => 'Czy na pewno chcesz usunąć serwis siecioy?',
        'After you save the configuration you will be redirected again to the edit screen.' =>
            'Po zapisaniu konfiguracji będziesz przekierowany ponownie do ekranu edycji.',
        'If you want to return to overview please click the "Go to overview" button.' =>
            'Jeśli chcesz wrócić do przeglądu, kliknij przycisk "Idź do przeglądu".',
        'Web Service List' => 'Lista Serwisów Sieciowych',
        'Remote system' => 'Zdalny system',
        'Provider transport' => 'Transport serwera',
        'Requester transport' => 'Transport klienta',
        'Debug threshold' => 'Poziom debugowania',
        'In provider mode, OTRS offers web services which are used by remote systems.' =>
            'W trybie serwera OTRS udostępnia usługi sieciowe, które są używane przez zdalne systemy.',
        'In requester mode, OTRS uses web services of remote systems.' =>
            'W trybie klienta OTRS używa usług systemów zdalnych.',
        'Operations are individual system functions which remote systems can request.' =>
            'Operacje to indywidualne funkcje systemowe, które mogą być wywołane przez zdalne systemy.',
        'Invokers prepare data for a request to a remote web service, and process its response data.' =>
            'Invokery przygotowują dane żądania do zdalnej usługi sieciowej i przetwarzają dane jej odpowiedzi.',
        'Controller' => 'kontroler',
        'Inbound mapping' => 'Mapowanie przychodzące',
        'Outbound mapping' => 'Mapowanie wychodzące',
        'Delete this action' => 'Usuń tę akcję',
        'At least one %s has a controller that is either not active or not present, please check the controller registration or delete the %s' =>
            'Przynajmniej jeden %s ma kontroler, który jest albo nieaktywny albo nieobecny; sprawdź zarejestrowanie kontrolera lub usuń %s',
        'Delete webservice' => 'Usuń serwis sieciowy',
        'Delete operation' => 'Usuń operację',
        'Delete invoker' => 'Usuń invoker',
        'Clone webservice' => 'Klonuj serwis sieciowy',
        'Import webservice' => 'Importuj serwis sieciowy',

        # Template: AdminGenericInterfaceWebserviceHistory
        'GenericInterface Configuration History for Web Service %s' => 'Historia konfiguracji GenericInterface serwisu sieciowego %s',
        'Go back to Web Service' => 'Powróć do serwisów sieciowych',
        'Here you can view older versions of the current web service\'s configuration, export or even restore them.' =>
            'Tutaj możesz zobaczyć starsze wersje bieżącej konfiguracji web service, wyeksportować je lub przywrócić.',
        'Configuration History List' => 'Lista historii konfiguracji',
        'Version' => 'Wersja',
        'Create time' => 'Czas utworzenia',
        'Select a single configuration version to see its details.' => 'Zaznacz pojedynczą wersję konfiguracji aby zobaczy jej szczegóły.',
        'Export web service configuration' => 'Eksportuj konfigurację serwisów sieciowych',
        'Restore web service configuration' => 'Przywróć konfigurację serwisów sieciowych',
        'Do you really want to restore this version of the web service configuration?' =>
            'Czy na pewno chcesz przywrócić tę wersję konfiguracji serwisu sieciowego?',
        'Your current web service configuration will be overwritten.' => 'Twoja obecna konfiguracja serwisu sieciowego zostanie nadpisana.',
        'Restore' => 'Przywróć',

        # Template: AdminGroup
        'WARNING: When you change the name of the group \'admin\', before making the appropriate changes in the SysConfig, you will be locked out of the administrations panel! If this happens, please rename the group back to admin per SQL statement.' =>
            'Uwaga: Jeżeli zmienisz nazwę grupy \'admin\', przed wykonaniem właściwych zmian w SysConfig, zablokujesz panel administratorów! Jeżeli to nastąpi, przywróć nazwę grupy admin z użyciem SQL.',
        'Group Management' => 'Zarządzanie grupami',
        'Add group' => 'Dodaj Grupę',
        'The admin group is to get in the admin area and the stats group to get stats area.' =>
            'Grupa Admin pozwala posiada prawa Administracji systemem. Grupa Stats umożliwia przeglądanie statystyk zgłoszeń.',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...). ' =>
            'Utwórz nowe grupy aby obsłużyć prawa dostępu dla różnych grup agentów (np. działu zakupu, działu wsparcia, działu sprzedaży, ...). ',
        'It\'s useful for ASP solutions. ' => 'Przydatne dla rozwiązań ASP. ',
        'Add Group' => 'Dodaj grupę',
        'Edit Group' => 'Edytuj Grupę',

        # Template: AdminLog
        'System Log' => 'Log systemu',
        'Here you will find log information about your system.' => 'Tutaj znajdziesz informacje o swoim systemie OTRS',
        'Hide this message' => 'Ukryj tę wiadomość',
        'Recent Log Entries' => 'Ostatnie pozycje loga',

        # Template: AdminMailAccount
        'Mail Account Management' => 'Zarządzanie kontami e-mail',
        'Add mail account' => 'Dodaj konto pocztowe',
        'All incoming emails with one account will be dispatched in the selected queue!' =>
            'Wszystkie przychodzące na jedno konto wiadomości będą umieszczone w zaznacznej kolejce!',
        'If your account is trusted, the already existing X-OTRS header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' =>
            'Jeżeli konto jest zaufane, istniejące w chwili przybycia nagłówki X-OTRS (priorytet, ...) zostaną użyte! Filtr PostMaster zostanie wykonany.',
        'Delete account' => 'Usuń konto',
        'Fetch mail' => 'Pobierz pocztę',
        'Add Mail Account' => 'Dodaj Konto Pocztowe',
        'Example: mail.example.com' => 'Na przykład: mail.example.com',
        'IMAP Folder' => 'Folder IMAP',
        'Only modify this if you need to fetch mail from a different folder than INBOX.' =>
            'Zmień to jeśli potrzebujesz pobirać pocztę z innego foldera niż INBOX.',
        'Trusted' => 'Zaufane',
        'Dispatching' => 'Przekazanie',
        'Edit Mail Account' => 'Edytuj Konto Pocztowe',

        # Template: AdminNavigationBar
        'Admin' => 'Administracja',
        'Agent Management' => 'Zarządzanie agentami',
        'Queue Settings' => 'Ustawienia kolejki',
        'Ticket Settings' => 'Ustawienia zgłoszenia',
        'System Administration' => 'Administracja systemem',
        'Online Admin Manual' => '',

        # Template: AdminNotification
        'Notification Management' => 'Konfiguracja Powiadomień',
        'Select a different language' => 'Wybierz inny język',
        'Filter for Notification' => 'Filtr powiadomień',
        'Notifications are sent to an agent or a customer.' => 'Powiadomienia są wysyłane do agenta obsługi lub klienta',
        'Notification' => 'Powiadomienie',
        'Edit Notification' => 'Edytuj Powiadomienie',
        'e. g.' => 'np.',
        'Options of the current customer data' => 'Opcje danych bieżącego klienta',

        # Template: AdminNotificationEvent
        'Add notification' => 'Dodaj powiadomienie',
        'Delete this notification' => 'Usuń to powiadomienie',
        'Add Notification' => 'Dodaj powiadomienie',
        'Ticket Filter' => 'Filtr zgłoszeń',
        'Article Filter' => 'Filtr artykułów',
        'Only for ArticleCreate and ArticleSend event' => '',
        'Article type' => 'Typ artykułu',
        'If ArticleCreate or ArticleSend is used as a trigger event, you need to specify an article filter as well. Please select at least one of the article filter fields.' =>
            '',
        'Article sender type' => 'Typ nadawcy artykułu',
        'Subject match' => 'Wyszukiwanie w temacie',
        'Body match' => 'Wyszukiwanie w treści',
        'Include attachments to notification' => 'Umieść załączniki w powiadomieniu',
        'Recipient' => 'Odbiorca',
        'Recipient groups' => 'Odbiorcy (grupy)',
        'Recipient agents' => 'Odbiorcy (agenci)',
        'Recipient roles' => 'Odbiorcy (role)',
        'Recipient email addresses' => 'Adresy e-mail odbiorców',
        'Notification article type' => 'Typ artykuły powiadomienia',
        'Only for notifications to specified email addresses' => 'Tylko dla powiadomień do określonych adresów e-mail',
        'To get the first 20 character of the subject (of the latest agent article).' =>
            'Aby pobrać pierwszych 20 znaków tematu (najnowszego artykułu agenta)',
        'To get the first 5 lines of the body (of the latest agent article).' =>
            'Aby pobrać pierwszych 5 linie treści (najnowszego artykułu agenta)',
        'To get the first 20 character of the subject (of the latest customer article).' =>
            'Aby pobrać pierwsze 20 znaków tematu (najnowszego artykułu klienta)',
        'To get the first 5 lines of the body (of the latest customer article).' =>
            'Aby pobrać pierwsze 5 linii treści (najnowszego artykułu klienta)',

        # Template: AdminOTRSBusinessInstalled
        'Manage %s' => '',
        'Downgrade to OTRS Free' => '',
        '%s makes contact regularly with cloud.otrs.com to check on available updates and the validity of the underlying contract.' =>
            '',
        'Unauthorized Usage Detected' => '',
        'This system uses the %s without a proper license! Please make contact with %s to renew or activate your contract!' =>
            '',
        '%s not Correctly Installed' => '',
        'Your %s is not correctly installed. Please reinstall it with the button below.' =>
            '',
        'Reinstall %s' => '',
        'Your %s is not correctly installed, and there is also an update available.' =>
            '',
        'You can either reinstall your current version or perform an update with the buttons below (update recommended).' =>
            '',
        'Update %s' => '',
        '%s Not Yet Available' => '',
        '%s will be available soon.' => '',
        '%s Update Available' => '',
        'An update for your %s is available! Please update at your earliest!' =>
            '',
        '%s Correctly Deployed' => '',
        'Congratulations, your %s is correctly installed and up to date!' =>
            '',

        # Template: AdminOTRSBusinessNotInstalled
        'Upgrade to %s' => '',
        '%s will be available soon. Please check again in a few days.' =>
            '',
        'Please have a look at %s for more information.' => '',
        'Your OTRS Free is the base for all future actions. Please register first before you continue with the upgrade process of %s!' =>
            '',
        'Register this System' => '',
        'Before you can benefit from %s, please contact %s to get your %s contract.' =>
            '',
        'Connection to cloud.otrs.com via HTTPS couldn\'t be established. Please make sure that your OTRS can connect to cloud.otrs.com via port 443.' =>
            '',
        'With your existing contract you can only use a small part of the %s.' =>
            '',
        'If you would like to take full advantage of the %s get your contract upgraded now! Contact %s.' =>
            '',

        # Template: AdminOTRSBusinessUninstall
        'Cancel downgrade and go back' => '',
        'Go to OTRS Package Manager' => '',
        'Sorry, but currently you can\'t downgrade due to the following packages which depend on %s:' =>
            '',
        'Vendor' => 'Wydawca',
        'Please uninstall the packages first using the package manager and try again.' =>
            '',
        'You are about to downgrade to OTRS Free and will lose the following features and all data related to these:' =>
            '',
        'Chat' => '',
        'Timeline view in ticket zoom' => '',
        'DynamicField ContactWithData' => '',
        'The %s skin' => '',

        # Template: AdminPGP
        'PGP Management' => 'Zarządzanie PGP',
        'Use this feature if you want to work with PGP keys.' => 'Użyj tej funkcji jeśli chcesz pracować z kluczami PGP.',
        'Add PGP key' => 'Dodaj klucz PGP',
        'In this way you can directly edit the keyring configured in SysConfig.' =>
            'W ten sposób mozesz bezpośrednio edytować plik kluczy skonfigurowany w SysConfig.',
        'Introduction to PGP' => 'Wprowadenie do PGP',
        'Result' => 'Wynik',
        'Identifier' => 'Identyfikator',
        'Bit' => 'Bit',
        'Fingerprint' => 'Znacznik (fingerprint)',
        'Expires' => 'Wygasa',
        'Delete this key' => 'Usuń ten klucz',
        'Add PGP Key' => 'Dodaj klucz PGP',
        'PGP key' => 'Klucz PGP',

        # Template: AdminPackageManager
        'Package Manager' => 'Menedżer pakietów',
        'Uninstall package' => 'Odinstaluj pakiet',
        'Do you really want to uninstall this package?' => 'Czy na pewno chcesz odinstalować ten pakiet?',
        'Reinstall package' => 'Reinstaluj pakiet',
        'Do you really want to reinstall this package? Any manual changes will be lost.' =>
            'Czy na pewno chcesz reinstalować ten pakiet? Wszystkie ręczne modyfikacje będą utracone.',
        'Continue' => 'Kontynuuj',
        'Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            'Proszę upewnij się, że baza danych akceptuje rozmiar powyżej %s (ona obecnie akceptuje pakiety tylko do %s MB). Proszę zmień ustawienie max_allowed_packet by uniknąć błędów w bazie danych.',
        'Install' => 'Instaluj',
        'Install Package' => 'Instaluj pakiet',
        'Update repository information' => 'Zaktualizuj informację o repozytoriach',
        'Online Repository' => 'Baza on-line',
        'Module documentation' => 'Dokumentacja modułu',
        'Upgrade' => 'Aktualizacja',
        'Local Repository' => 'Lokalna baza',
        'This package is verified by OTRSverify (tm)' => 'Ten pakiet został zweryfikowany poprzez OTRSverify (tm)',
        'Uninstall' => 'Odinstaluj',
        'Reinstall' => 'Przeinstaluj',
        'Features for %s customers only' => '',
        'With %s, you can benefit from the following optional features. Please make contact with %s if you need more information.' =>
            '',
        'Download package' => 'Pobierz pakiet',
        'Rebuild package' => 'Przebuduj pakiet',
        'Metadata' => 'Metadane',
        'Change Log' => 'Log zmian',
        'Date' => 'Data',
        'List of Files' => 'Lista plików',
        'Permission' => 'Prawo dostępu',
        'Download' => 'Pobierz',
        'Download file from package!' => 'Pobierz plik z pakietu!',
        'Required' => 'Wymagany',
        'PrimaryKey' => 'Klucz podstawowy',
        'AutoIncrement' => 'Zwiększaj automatycznie',
        'SQL' => 'SQL',
        'File differences for file %s' => 'Różnice plikowe dla pliku %s',

        # Template: AdminPerformanceLog
        'Performance Log' => 'Log wydajnosci',
        'This feature is enabled!' => 'Ta funkcja jest włączona!',
        'Just use this feature if you want to log each request.' => 'Wybierz tę opcję jeżeli chcesz logować każde żądanie.',
        'Activating this feature might affect your system performance!' =>
            'Włączenie tej opcji może wpłynąć na wydajność twojego systemu!',
        'Disable it here!' => 'Wyłącz tutaj!',
        'Logfile too large!' => 'Plik log jest za duży!',
        'The logfile is too large, you need to reset it' => 'Log jest zbyt duży - musisz go zresetować!',
        'Overview' => 'Przegląd',
        'Range' => 'Zakres',
        'last' => 'w ciągu',
        'Interface' => 'Interfejs',
        'Requests' => 'Żądania',
        'Min Response' => 'Min. odpowiedź',
        'Max Response' => 'Max odpowiedź',
        'Average Response' => 'Średnia odpowiedź',
        'Period' => 'Okres',
        'Min' => 'Min.',
        'Max' => 'Max.',
        'Average' => 'Średnia',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => 'Zarządzanie filtrami poczty',
        'Add filter' => 'Dodaj filtr',
        'To dispatch or filter incoming emails based on email headers. Matching using Regular Expressions is also possible.' =>
            'Aby rozdzielić lub odfiltrować napływające wiadomości e-mail na podstawie nagłówków e-mail. Możliwe dopasowywanie przy użyciu wyrażeń regularnych.',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' =>
            'Jeżeli chcesz tylko dopasować adres e-mail użyj EMAILADDRESS:info@example.com w polach Od, Do lub Cc.',
        'If you use Regular Expressions, you also can use the matched value in () as [***] in the \'Set\' action.' =>
            'Jeśli użyjesz wyrażeń regularnych, możesz również użyć dopasowanej wartości w () jako [***] w akcji \'Set\'.',
        'Delete this filter' => 'Usuń ten filtr',
        'Add PostMaster Filter' => 'Dodaj filtr PostMaster',
        'Edit PostMaster Filter' => 'Edytuj filtr PostMaster',
        'The name is required.' => 'Nazwa jest wymagana.',
        'Filter Condition' => 'Warunek filtra',
        'AND Condition' => 'Warunek ORAZ',
        'Check email header' => '',
        'Negate' => 'Zaprzeczenie',
        'Look for value' => '',
        'The field needs to be a valid regular expression or a literal word.' =>
            'Pole musi zawierać poprawne wyrażenie regularne lub słowo.',
        'Set Email Headers' => 'Ustaw nagłówek e-mail',
        'Set email header' => '',
        'Set value' => '',
        'The field needs to be a literal word.' => 'Pole musi zawierać słowo.',

        # Template: AdminPriority
        'Priority Management' => 'Zarządzanie priorytetami',
        'Add priority' => 'Dodaj priorytet',
        'Add Priority' => 'Dodaj priorytet',
        'Edit Priority' => 'Edytuj priorytet',

        # Template: AdminProcessManagement
        'Process Management' => 'Zarządzanie procesami',
        'Filter for Processes' => 'Filtr procesów',
        'Create New Process' => 'Utwórz nowy proces',
        'Deploy All Processes' => '',
        'Here you can upload a configuration file to import a process to your system. The file needs to be in .yml format as exported by process management module.' =>
            'Tutaj możesz załadować plik konfiguracji aby zaimportować proces do twojego systemu. Plik musi być w formacie .yml wyeksportowanym z modułu zarządzania procesami.',
        'Overwrite existing entities' => '',
        'Upload process configuration' => 'Załaduj konfigurację procesu',
        'Import process configuration' => 'Importuj konfigurację procesu',
        'To create a new Process you can either import a Process that was exported from another system or create a complete new one.' =>
            'Aby utworzyć nowy proces, możesz albo zaimportować proces, który został wyeksportowany z innego systemu lub utworzyć całkowicie nowy proces.',
        'Changes to the Processes here only affect the behavior of the system, if you synchronize the Process data. By synchronizing the Processes, the newly made changes will be written to the Configuration.' =>
            'Zmiany wprowadzone tutaj do procesów zostaną uwzględnione w systemie jeśli zsynchronizujesz dane procesów. Wskutek synchronizacji procesów, nowe zmiany będą zapisane do konfiguracji.',
        'Process name' => 'Nazwa procesu',
        'Print' => 'Drukuj',
        'Export Process Configuration' => 'Eksportuj konfigurację procesu',
        'Copy Process' => 'Kopiuj proces',

        # Template: AdminProcessManagementActivity
        'Cancel & close window' => 'Anuluj i zamknij okno',
        'Go Back' => 'Wstecz',
        'Please note, that changing this activity will affect the following processes' =>
            'Zwróć uwagę, że zmiana tego działania wpłynie na następujące procesy',
        'Activity' => 'Działanie',
        'Activity Name' => 'Nazwa działania',
        'Activity Dialogs' => 'Okna działań',
        'You can assign Activity Dialogs to this Activity by dragging the elements with the mouse from the left list to the right list.' =>
            'Możesz przypisać okna działań do tego działania poprzez przeciągnięcie elementów za pomocą myszki z listy po lewej stronie do listy po prawej stronie.',
        'Ordering the elements within the list is also possible by drag \'n\' drop.' =>
            'Porządkowanie elementów na liście jest możliwe również za pomocą chwytania i upuszczania.',
        'Filter available Activity Dialogs' => 'Filtruj dostępne okna działań',
        'Available Activity Dialogs' => 'Dostępne okna działań',
        'Create New Activity Dialog' => 'Utwórz nowe okno działania',
        'Assigned Activity Dialogs' => 'Przypisane okna działań',
        'As soon as you use this button or link, you will leave this screen and its current state will be saved automatically. Do you want to continue?' =>
            'Gdy tylko użyjesz tego przycisku lub odnośnika, opuścisz ten ekran a jego obecny stan zostanie automatycznie zapisany. Czy chcesz kontynuować?',

        # Template: AdminProcessManagementActivityDialog
        'Please note that changing this activity dialog will affect the following activities' =>
            'Zwróć uwagę, że zmiany tego okna wpłyną na następnujące działania',
        'Please note that customer users will not be able to see or use the following fields: Owner, Responsible, Lock, PendingTime and CustomerID.' =>
            'Proszę zanotuj, że klienci nie będą widzieć następujących pól: Właściciel, Odpowiedzialny, Blokada, Oczekujące i ID Klienta.',
        'The Queue field can only be used by customers when creating a new ticket.' =>
            '',
        'Activity Dialog' => 'Okna działania',
        'Activity dialog Name' => 'Nazwa okna działania',
        'Available in' => 'Dostępne w',
        'Description (short)' => 'Opis (krótki)',
        'Description (long)' => 'Opis (długi)',
        'The selected permission does not exist.' => 'Zaznaczone uprawnienie nie istnieje.',
        'Required Lock' => 'Wymagana blokada',
        'The selected required lock does not exist.' => 'Zaznaczona wymagana blokada nie istnieje.',
        'Submit Advice Text' => 'Tekst porady wysyłania',
        'Submit Button Text' => 'Tekst przycisku wysyłania',
        'Fields' => 'Pola',
        'You can assign Fields to this Activity Dialog by dragging the elements with the mouse from the left list to the right list.' =>
            'Możesz przypisac pola do tego okna działania za pomocą przeciągania elementów myszką z listy po lewej stronie do listy po prawej stronie.',
        'Filter available fields' => 'Filtruj dostępne pola',
        'Available Fields' => 'Dostępne pola',
        'Assigned Fields' => 'Przypisane pola',
        'Edit Details for Field' => 'Edytuj szczegóły pola',
        'ArticleType' => 'Typ artykułu',
        'Display' => 'Wyświetl',
        'Edit Field Details' => 'Edytuj szczegóły pola',
        'Customer interface does not support internal article types.' => 'Interfejs klienta nie wspiera wewnętrznych typów artykułów.',

        # Template: AdminProcessManagementPath
        'Path' => 'Ścieżka',
        'Edit this transition' => 'Edytuj to przejście',
        'Transition Actions' => 'Akcje przejścia',
        'You can assign Transition Actions to this Transition by dragging the elements with the mouse from the left list to the right list.' =>
            'Możesz przypisać akcje przejścia do tego przejścia za pomoca przeciągania elementów myszką z listy po lewej stronie do listy po prawej stronie.',
        'Filter available Transition Actions' => 'Filtruj dostępne akcje przejścia',
        'Available Transition Actions' => 'Dostępne akcje przejścia',
        'Create New Transition Action' => 'Utwórz nową akcję przejścia',
        'Assigned Transition Actions' => 'Przypisane akcje przejścia',

        # Template: AdminProcessManagementProcessAccordion
        'Activities' => 'Działania',
        'Filter Activities...' => 'Filtruj działania...',
        'Create New Activity' => 'Utwórz nowe działanie',
        'Filter Activity Dialogs...' => 'Filtruj okna działań...',
        'Transitions' => 'Przejścia',
        'Filter Transitions...' => 'Filtruj przejścia...',
        'Create New Transition' => 'Utwórz nowe przejście',
        'Filter Transition Actions...' => 'Filtruj akcje przejść...',

        # Template: AdminProcessManagementProcessEdit
        'Edit Process' => 'Edytuj proces',
        'Print process information' => 'Drujuj informację o procesie',
        'Delete Process' => 'Usuń proces',
        'Delete Inactive Process' => 'Usuń nieaktywny proces',
        'Available Process Elements' => 'Dostępne elementy procesów',
        'The Elements listed above in this sidebar can be moved to the canvas area on the right by using drag\'n\'drop.' =>
            'Elementy z listy ponad tym paskiem bocznym mogą być przenoszone do obszaru projektu po prawej stronie za pomocą chwytania i upuszczania.',
        'You can place Activities on the canvas area to assign this Activity to the Process.' =>
            'Możes umieszczać działania na obszarze projektu aby przypisywać te działania do procesu.',
        'To assign an Activity Dialog to an Activity drop the Activity Dialog element from this sidebar over the Activity placed in the canvas area.' =>
            'Aby przypisać okno działania do działania, upuść element okna działania z paska bocznego na działanie znajdujące się w obszarze projektu.',
        'You can start a connection between to Activities by dropping the Transition element over the Start Activity of the connection. After that you can move the loose end of the arrow to the End Activity.' =>
            'Możesz uruchomić połączenie między działaniami poprzez upuszczenie elementu przejścia na działanie początkowe połączenia. Następnie możesz przenieść luźny koniec strzałki do działania końcowego.',
        'Actions can be assigned to a Transition by dropping the Action Element onto the label of a Transition.' =>
            'Akcje mogą być przypisywane do przejść poprzez upuszczanie elementu akcji na etykietę przejścia.',
        'Edit Process Information' => 'Edytuj informacje o procesie',
        'Process Name' => 'Nazwa procesu',
        'The selected state does not exist.' => 'Zaznaczony status nie istnieje.',
        'Add and Edit Activities, Activity Dialogs and Transitions' => 'Dodaj i edytuj działania, okna działań i przejścia',
        'Show EntityIDs' => 'Pokaż EntityID',
        'Extend the width of the Canvas' => 'Zwiększ szerokość obszaru projektu',
        'Extend the height of the Canvas' => 'Zwiększ wysokość obszaru projektu',
        'Remove the Activity from this Process' => 'Usuń działanie z tego procesu',
        'Edit this Activity' => 'Edytuj to działanie',
        'Save settings' => 'Zapisz ustawienia',
        'Save Activities, Activity Dialogs and Transitions' => 'Zapisz aktywności, dialogi aktywności i przejść',
        'Do you really want to delete this Process?' => 'Czy na pewno chcesz usunąć ten proces?',
        'Do you really want to delete this Activity?' => 'Czy na pewno chcesz usunąć to działanie? ',
        'Do you really want to delete this Activity Dialog?' => 'Czy na pewno chcesz usunąć to okno działania? ',
        'Do you really want to delete this Transition?' => 'Czy na pewno chcesz usunąć to przejście?',
        'Do you really want to delete this Transition Action?' => 'Czy na pewno chcesz usunąć tę akcję przejścia? ',
        'Do you really want to remove this activity from the canvas? This can only be undone by leaving this screen without saving.' =>
            'Czy na pewno chcesz usunąć to działanie z obszaru projektu? Cofnięcie tego będzie możliwe tylko poprzez opuszczenie tego ekranu bez zapisywania.',
        'Do you really want to remove this transition from the canvas? This can only be undone by leaving this screen without saving.' =>
            'Czy na pewno chcesz usunąć to przejście z obszaru projektu? Cofnięcie tego będzie możliwe tylko poprzez opuszczenie tego ekranu bez zapisywania.',
        'Hide EntityIDs' => 'Ukryj EntityID',
        'Delete Entity' => 'Usuń Entity',
        'Remove Entity from canvas' => 'Usuń Entity z obszaru projektu',
        'This Activity is already used in the Process. You cannot add it twice!' =>
            'To działanie jest już użyte w procesie. Nie możesz dodać go dwukrotnie!',
        'This Activity cannot be deleted because it is the Start Activity.' =>
            'To działanie nie może być usunięte ponieważ jest działaniem początkowym.',
        'This Transition is already used for this Activity. You cannot use it twice!' =>
            'To przejście jest już użyte w tym działaniu. Nie możesz użyć go dwukrotnie!',
        'This TransitionAction is already used in this Path. You cannot use it twice!' =>
            'Ta akcja przejścia jest już użyta na tej ścieżce. Nie możesz użyć jej dwukrotnie!',
        'Remove the Transition from this Process' => 'Usuń to przejście z tego procesu',
        'No TransitionActions assigned.' => 'Brak przypisanych akcji przejścia.',
        'The Start Event cannot loose the Start Transition!' => 'Zdarzenie początkowe nie może utracić początkowego przejścia!',
        'No dialogs assigned yet. Just pick an activity dialog from the list on the left and drag it here.' =>
            'Brak jeszcze przypisanych okien. Wybierz okno działań z listy po lewej stronie i upuść je tutaj.',
        'An unconnected transition is already placed on the canvas. Please connect this transition first before placing another transition.' =>
            'Niepodłączone przejście jest już przygotowane. Proszę wpierw połącz to przejście przed umieszczeniem kolejnego.',

        # Template: AdminProcessManagementProcessNew
        'In this screen, you can create a new process. In order to make the new process available to users, please make sure to set its state to \'Active\' and synchronize after completing your work.' =>
            'Na tym ekranie możesz utworzyć nowy proces. Aby udostępnić proces użytkownikom, ustaw status na \'Aktywne\' i zsynchronizuj po wykonaniu.',

        # Template: AdminProcessManagementProcessPrint
        'Start Activity' => 'Działanie początkowe',
        'Contains %s dialog(s)' => 'Zawiera %s okien',
        'Assigned dialogs' => 'Przypisane okna',
        'Activities are not being used in this process.' => 'Działania nie są używane w tym procesie.',
        'Assigned fields' => 'Przypisane pola',
        'Activity dialogs are not being used in this process.' => 'Okna działań nie są używane w tym procesie.',
        'Condition linking' => 'Łączenie warunkowe',
        'Conditions' => 'Warunki',
        'Condition' => 'Warunek',
        'Transitions are not being used in this process.' => 'Przejścia nie są używane w tym procesie.',
        'Module name' => 'Nazwa modułu',
        'Configuration' => 'Konfiguracja',
        'Transition actions are not being used in this process.' => 'Akcje przejść nie są używane w tym procesie.',

        # Template: AdminProcessManagementTransition
        'Please note that changing this transition will affect the following processes' =>
            'Zwróć uwagę, że zmiana tego przejścia wpłynie na następujące procesy',
        'Transition' => 'Przejście',
        'Transition Name' => 'Nazwa przejścia',
        'Type of Linking between Conditions' => 'Typ połączenia pomiędzy warunkami',
        'Remove this Condition' => 'Usuń ten warunek',
        'Type of Linking' => 'Typ połączenia',
        'Remove this Field' => 'Usuń to pole',
        'Add a new Field' => 'Dodaj nowe pole',
        'Add New Condition' => 'Dodaj nowy warunek',

        # Template: AdminProcessManagementTransitionAction
        'Please note that changing this transition action will affect the following processes' =>
            'Zwróć uwagę, że zmiana tej akcji przejścia wpłynie na następujące procesy',
        'Transition Action' => 'Akcja przejścia',
        'Transition Action Name' => 'Nazwa akcji przejścia',
        'Transition Action Module' => 'Moduł akcji przejścia',
        'Config Parameters' => 'Parametry konfiguracyjne',
        'Remove this Parameter' => 'Usuń ten parametr',
        'Add a new Parameter' => 'Dodaj nowy parametr',

        # Template: AdminQueue
        'Manage Queues' => 'Zarządzaj kolejkami',
        'Add queue' => 'Dodaj kolejkę',
        'Add Queue' => 'Dodaj kolejkę',
        'Edit Queue' => 'Edytuj kolejkę',
        'A queue with this name already exists!' => '',
        'Sub-queue of' => 'Podkolejka kolejki',
        'Unlock timeout' => 'Limit czasowy odblokowania',
        '0 = no unlock' => '0 = bez odblokowania',
        'Only business hours are counted.' => 'Tylko godziny pracy są liczone.',
        'If an agent locks a ticket and does not close it before the unlock timeout has passed, the ticket will unlock and will become available for other agents.' =>
            'Jeśli agent zablokuje zgłoszenie i nie zamknie go w czasie określonym przez limit odblokowania, zgłoszenie zostanie odblokowane i będzie dostępne dla innych agentów.',
        'Notify by' => 'Powiadom wcześniej',
        '0 = no escalation' => '0 = brak eskalacji',
        'If there is not added a customer contact, either email-external or phone, to a new ticket before the time defined here expires, the ticket is escalated.' =>
            'Jeśli w określonym tutaj czasie nie pojawi się kontakt z klientem, zewnętrzny e-mail lub telefon związany z nowym zgłoszeniem, zgłoszenie takie będzie eskalowane.',
        'If there is an article added, such as a follow-up via email or the customer portal, the escalation update time is reset. If there is no customer contact, either email-external or phone, added to a ticket before the time defined here expires, the ticket is escalated.' =>
            'Jeśli dodany zostanie artykuł, tj. nowa wiadomość przez e-mail lub z portala WWW klineta, czas aktualizacji eskalacji będzie zresetowany. Jeśli nie będzie kontaktu z klientem, zewnętrznego e-maila lub telefonu dodanego do zgłoszenia przed upłynięciem zadanego tutaj czasu, zgłoszenie to będzie eskalowane.',
        'If the ticket is not set to closed before the time defined here expires, the ticket is escalated.' =>
            'Jeśli zgłoszenie nie zostanie zamknięce do przed podanym tutaj czasem, zgłoszenie będzie eskalowane.',
        'Follow up Option' => 'Opcje nawiązań',
        'Specifies if follow up to closed tickets would re-open the ticket, be rejected or lead to a new ticket.' =>
            'Określa czy wiadomość nawiązująca do zamkniętego zgłoszenia będzie otwierała to zgłoszenie czy będzie odrzucana czy też będzie generowała nowe zgłoszenie.',
        'Ticket lock after a follow up' => 'Zgłoszenie zablokowane po nowej wiadomości',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked to the old owner.' =>
            'Jeśli zgłoszenie jest zamknięte a klient wyśle nową wiadomość do zgłoszenia, zgłoszenie to będzie zablokowane dla ostatniego właściciela.',
        'System address' => 'Adres systemowy',
        'Will be the sender address of this queue for email answers.' => 'Będzie adresem nadawcy odpowiedzi e-mailowych wysyłanych z tej kolejki.',
        'Default sign key' => 'Domyślny klucz do podpisywania',
        'The salutation for email answers.' => 'Zwrot grzecznościowy dla odpowiedzi e-mailowych.',
        'The signature for email answers.' => 'Podpis dla odpowiedzi e-mailowych.',

        # Template: AdminQueueAutoResponse
        'Manage Queue-Auto Response Relations' => 'Zarządzaj relacjami kolejka-autoodpowiedź',
        'Filter for Queues' => 'Filtrowanie kolejek',
        'Filter for Auto Responses' => 'Filtrowanie automatycznych odpowiedzi',
        'Auto Responses' => 'Automatyczna odpowiedź',
        'Change Auto Response Relations for Queue' => 'Zmień relacje autoodpowiedzi dla kolejki',

        # Template: AdminQueueTemplates
        'Manage Template-Queue Relations' => 'Zarządzaj relacjami Szablonowo-Kolejkowymi',
        'Filter for Templates' => 'Filtr szalbonów',
        'Templates' => 'Szablony',
        'Change Queue Relations for Template' => 'Zmień relacje kolejki dla szablonu',
        'Change Template Relations for Queue' => 'Zmień relacje szablonu dla kolejki',

        # Template: AdminRegistration
        'System Registration Management' => 'Zarządzaenie systemem rejestracji',
        'Edit details' => 'Edytuj detale',
        'Show transmitted data' => '',
        'Deregister system' => 'Derejestracja systemu',
        'Overview of registered systems' => 'Przegląd zarejestrowanych systemów',
        'System Registration' => 'Rejestracja systemu',
        'This system is registered with OTRS Group.' => 'Ten system jest zarejestrowany w grupie OTRS.',
        'System type' => 'Typ systemu',
        'Unique ID' => 'Unikalne ID',
        'Last communication with registration server' => 'Ostatnia komunikacja z serwerem rejestrującym',
        'Send support data' => '',
        'System registration not possible' => '',
        'Please note that you can\'t register your system if your scheduler is not running correctly!' =>
            '',
        'Instructions' => '',
        'System deregistration not possible' => '',
        'Please note that you can\'t deregister your system if you\'re using the %s or having a valid service contract.' =>
            '',
        'OTRS-ID Login' => 'Login OTRS-ID',
        'System registration is a service of OTRS Group, which provides a lot of advantages!' =>
            'System rejestracji jest serwisem grupy OTRS, kóry posiada wiele zalet!',
        'Read more' => 'Przeczytaj więcej',
        'You need to log in with your OTRS-ID to register your system.' =>
            'Musisz zalogować się przy użyciu swojego loginu OTRS-ID by móc zarejestrować system.',
        'Your OTRS-ID is the email address you used to sign up on the OTRS.com webpage.' =>
            'Twoje OTRS-ID to adres e-mail który użyłeś podczas rejestracji na stonie OTRS.com.',
        'Data Protection' => '',
        'What are the advantages of system registration?' => 'Jakie są zalety z rejestracji systemu?',
        'You will receive updates about relevant security releases.' => 'Będziesz otrzymywał informacje o istotnych wydaniach bezpieczeństwa.',
        'With your system registration we can improve our services for you, because we have all relevant information available.' =>
            'Wraz z rejestracją możliwe będzie świadczenie przez nas ulepszonego serwisu dla was, gdyż będziemy posiadali wszystkie ku temu potrzebne informacje.',
        'This is only the beginning!' => 'To tylko początek!',
        'We will inform you about our new services and offerings soon.' =>
            'Niedługo będziemy informować o naszych serwisach i ofertach.',
        'Can I use OTRS without being registered?' => 'Czy mogę używać OTRS bez dokonania rejestracji?',
        'System registration is optional.' => 'Rejestracja systemu jest opcjonalna.',
        'You can download and use OTRS without being registered.' => 'Możesz pobrać oraz użytkować OTRS bez dokonywania rejestrcji.',
        'Is it possible to deregister?' => 'Czy wyrejestrowanie jest możliwe?',
        'You can deregister at any time.' => 'Wyrejestrować można się w każdej chwili.',
        'Which data is transfered when registering?' => 'Jakie dane są przesyłane podczas rejestracji?',
        'A registered system sends the following data to OTRS Group:' => 'Zarejestrowany system wysyła następujące dane do Grupy OTRS:',
        'Fully Qualified Domain Name (FQDN), OTRS version, Database, Operating System and Perl version.' =>
            'Pełna jednoznaczna nazwa domenowa (FQDN), wersja OTRS, Baza danych, System operacyjny oraz wersja Perl.',
        'Why do I have to provide a description for my system?' => 'Dlaczego muszę udzielić opisu mojego systemu?',
        'The description of the system is optional.' => 'Udzielenie opisu systemu jest opcjonalne.',
        'The description and system type you specify help you to identify and manage the details of your registered systems.' =>
            'Opis oraz typ systemu który podasz pomogą tobie w identyfikacji oraz zarządzaniu zarejestrowanymi systemami.',
        'How often does my OTRS system send updates?' => 'Jak często mój system OTRS wysyła uaktualnienia?',
        'Your system will send updates to the registration server at regular intervals.' =>
            'Twój system będzie wysyłał uaktulanienia do serwera rejestracji w regularnych przedziałach czasowych.',
        'Typically this would be around once every three days.' => 'Typowo będzie to następowało co trzy dni.',
        'In case you would have further questions we would be glad to answer them.' =>
            'W przyapdku gdy posiadasz dodatkowe pytania będziemy zadowoleni by móc na nie odpowiedzieć.',
        'Please visit our' => 'Proszę odwiedź nasz',
        'portal' => 'portal',
        'and file a request.' => 'i złóż podanie',
        'Here at OTRS Group we take the protection of your personal details very seriously and strictly adhere to data protection laws.' =>
            '',
        'All passwords are automatically made unrecognizable before the information is sent.' =>
            '',
        'Under no circumstances will any data we obtain be sold or passed on to unauthorized third parties.' =>
            '',
        'The following explanation provides you with an overview of how we guarantee this protection and which type of data is collected for which purpose.' =>
            '',
        'Data Handling with \'System Registration\'' => '',
        'Information received through the \'Service Center\' is saved by OTRS Group.' =>
            '',
        'This only applies to data that OTRS Group requires to analyze the performance and function of the OTRS server or to establish contact.' =>
            '',
        'Safety of Personal Details' => '',
        'OTRS Group protects your personal data from unauthorized access, use or publication.' =>
            '',
        'OTRS Group ensures that the personal information you store on the server is protected from unauthorized access and publication.' =>
            '',
        'Disclosure of Details' => '',
        'OTRS Group will not pass on your details to third parties unless required for business transactions.' =>
            '',
        'OTRS Group will only pass on your details to entitled public institutions and authorities if required by law or court order.' =>
            '',
        'Amendment of Data Protection Policy' => '',
        'OTRS Group reserves the right to amend this security and data protection policy if required by technical developments.' =>
            '',
        'In this case we will also adapt our information regarding data protection accordingly.' =>
            '',
        'Please regularly refer to the latest version of our Data Protection Policy.' =>
            '',
        'Right to Information' => '',
        'You have the right to demand information concerning the data saved about you, its origin and recipients, as well as the purpose of the data processing at any time.' =>
            '',
        'You can request information about the saved data by sending an e-mail to info@otrs.com.' =>
            '',
        'Further Information' => '',
        'Your trust is very important to us. We are willing to inform you about the processing of your personal details at any time.' =>
            '',
        'If you have any questions that have not been answered by this Data Protection Policy or if you require more detailed information about a specific topic, please contact info@otrs.com.' =>
            '',
        'If you deregister your system, you will lose these benefits:' =>
            '',
        'You need to log in with your OTRS-ID to deregister your system.' =>
            'Musisz zalogować się przy użyciu swojego OTRS-ID b ymóc dokonać derejestracji.',
        'OTRS-ID' => 'OTRS-ID',
        'You don\'t have an OTRS-ID yet?' => 'Nie posiadasz jeszcze OTRS-ID?',
        'Sign up now' => 'Zarejestruj się',
        'Forgot your password?' => 'Zapomniałeś swojego hasła?',
        'Retrieve a new one' => 'Otrzymaj nowe',
        'This data will be frequently transferred to OTRS Group when you register this system.' =>
            'następujące dane będą przesyłane do Grupy OTRS gdy zarejestrujesz system.',
        'Attribute' => 'Atrybut',
        'FQDN' => 'FQDN',
        'Optional description of this system.' => 'Opcjonalny opis systemu',
        'This will allow the system to send additional support data information to OTRS Group.' =>
            '',
        'Service Center' => '',
        'Support Data Management' => '',
        'Register' => 'Zarejestruj',
        'Deregister System' => 'Wyrejestruj system',
        'Continuing with this step will deregister the system from OTRS Group.' =>
            'Kontynuacja tego kroku spowoduje wyrejestrowanie systemu z Grupy OTRS',
        'Deregister' => 'Wyrejestrowanie',
        'You can modify registration settings here.' => '',
        'Overview of transmitted data' => '',
        'There is no data regularly sent from your system to %s.' => '',
        'The following data is sent at minimum every 3 days from your system to %s.' =>
            '',
        'The data will be transferred in JSON format via a secure https connection.' =>
            '',
        'System Registration Data' => '',
        'Support Data' => '',

        # Template: AdminRole
        'Role Management' => 'Zarządzanie rolami',
        'Add role' => 'Dodaj rolę',
        'Create a role and put groups in it. Then add the role to the users.' =>
            'Utwórz rolę i dodaj grupę do niej. Potem dodaj rolę do użytkownika.',
        'There are no roles defined. Please use the \'Add\' button to create a new role.' =>
            'Nie ma zdefiniowanych ról. Użyj przycisku \'Add\' aby utworzyć nową rolę',
        'Add Role' => 'Dodaj rolę',
        'Edit Role' => 'Edytuj rolę',

        # Template: AdminRoleGroup
        'Manage Role-Group Relations' => 'Zarządzaj relacjami rola-grupa',
        'Filter for Roles' => 'Filtr ról',
        'Select the role:group permissions.' => 'Zaznacz uprawnienia rola:grupa',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the role).' =>
            'Jeśli nic nie będzie zaznaczone, wtedy nie będzie uprawnień w tej grupie (zgłoszenia nie będą dostępne dla roli).',
        'Change Role Relations for Group' => 'Zmień relacje ról do grupy',
        'Change Group Relations for Role' => 'Zmień relacje grup do roli',
        'Toggle %s permission for all' => 'Przełącz uprawnienie %s dla wszystkich',
        'move_into' => 'przenieś do',
        'Permissions to move tickets into this group/queue.' => 'Uprawnienia do przesuwania zgłoszeń do tej grupy/kolejki',
        'create' => 'utwórz',
        'Permissions to create tickets in this group/queue.' => 'Uprawnienia do tworzenia zgłoszeń w tej grupie/kolejce',
        'priority' => 'priorytet',
        'Permissions to change the ticket priority in this group/queue.' =>
            'Uprawnienia do zmiany priorytetu zgłoszenia w tej grupie/kolejce',

        # Template: AdminRoleUser
        'Manage Agent-Role Relations' => 'Zarządzaj relacjami agent-rola',
        'Filter for Agents' => 'Filtrowanie agentów',
        'Manage Role-Agent Relations' => 'Zarządzaj relacjami rola-agent',
        'Change Role Relations for Agent' => 'Zmień relacje ról do agenta',
        'Change Agent Relations for Role' => 'Zmień relacje agentów do roli',

        # Template: AdminSLA
        'SLA Management' => 'Konfiguracja SLA',
        'Add SLA' => 'Dodaj SLA',
        'Edit SLA' => 'Edytuj SLA',
        'Please write only numbers!' => 'Podaj wyłączenie numery!',

        # Template: AdminSMIME
        'S/MIME Management' => 'Konfiguracja S/MIME',
        'Add certificate' => 'Dodaj certyfikat',
        'Add private key' => 'Dodaj klucz prywatny',
        'Filter for certificates' => 'Filtruj certyfikaty',
        'Filter for S/MIME certs' => '',
        'To show certificate details click on a certificate icon.' => 'Kliknij w ikonę certyfikatu by zobaczyć jego detale.',
        'To manage private certificate relations click on a private key icon.' =>
            'Kliknij w ikonę prywatne by zarządzać relacjami certyfikatu prywatnego.',
        'Here you can add relations to your private certificate, these will be embedded to the S/MIME signature every time you use this certificate to sign an email.' =>
            '',
        'See also' => 'Zobacz także',
        'In this way you can directly edit the certification and private keys in file system.' =>
            'W taki sposób możesz bezpośrednio edytować certyfikaty i klucze prywarne w systemie plików.',
        'Hash' => 'Skrót (hash)',
        'Handle related certificates' => 'Obsługuj powiązane certyfikaty',
        'Read certificate' => 'Czytaj certyfikat',
        'Delete this certificate' => 'Usuń ten certyfikat',
        'Add Certificate' => 'Dodaj certyfikat',
        'Add Private Key' => 'Dodaj klucz prywatny',
        'Secret' => 'Hasło',
        'Related Certificates for' => 'Certyfikaty powiązane dla',
        'Delete this relation' => 'Usuń to powiązanie',
        'Available Certificates' => 'Dostępne certyfikaty',
        'Relate this certificate' => 'Powiąż ten certyfikat',

        # Template: AdminSMIMECertRead
        'Close window' => 'Zamknij okno',
        'Certificate details' => '',

        # Template: AdminSalutation
        'Salutation Management' => 'Konfiguracja zwrotów grzecznościowych',
        'Add salutation' => 'Dodaj zwrot grzecznościowy',
        'Add Salutation' => 'Dodaj zwrot grzecznościowy',
        'Edit Salutation' => 'Edytuj zwrot',
        'Example salutation' => 'Przykładowy zwrot grzecznościowy',

        # Template: AdminSecureMode
        'Secure mode needs to be enabled!' => 'Tryb bezpieczny musi być aktywny!',
        'Secure mode will (normally) be set after the initial installation is completed.' =>
            'Tryb bezpieczny będzie (standardowo) włączony po inicjalnej instalacji.',
        'If secure mode is not activated, activate it via SysConfig because your application is already running.' =>
            'Jeśli tryb bezpieczny nie jest aktywny, uaktywnij go w SysConfig gdyż twoja aplikacja jest już uruchomiona.',

        # Template: AdminSelectBox
        'SQL Box' => 'Konsola SQL',
        'Here you can enter SQL to send it directly to the application database. It is not possible to change the content of the tables, only select queries are allowed.' =>
            '',
        'Here you can enter SQL to send it directly to the application database.' =>
            '',
        'Only select queries are allowed.' => '',
        'The syntax of your SQL query has a mistake. Please check it.' =>
            'Składnia twojego zapytania SQL jest niepoprawna. Sprawdź ją.',
        'There is at least one parameter missing for the binding. Please check it.' =>
            'Brakuje przynajmniej jednego parametru połączenia. Sprawdź je.',
        'Result format' => 'Format wyników',
        'Run Query' => 'Uruchom polecenie',
        'Query is executed.' => '',

        # Template: AdminService
        'Service Management' => 'Konfiguracja usług',
        'Add service' => 'Dodaj usługę',
        'Add Service' => 'Dodaj usługę',
        'Edit Service' => 'Edytuj usługę',
        'Sub-service of' => 'Usługa podrzędna',

        # Template: AdminServiceCenterSupportDataCollector
        'This data is sent to OTRS Group on a regular basis. To stop sending this data please update your system registration.' =>
            '',
        'You can manually trigger the Support Data sending by pressing this button:' =>
            '',
        'Send Update' => '',
        'Sending Update...' => '',
        'Support Data information was successfully sent.' => '',
        'Was not possible to send Support Data information.' => '',
        'Update Result' => '',
        'Currently this data is only shown in this system.' => '',
        'It is highly recommended to send this data to OTRS Group in order to get better support.' =>
            '',
        'To enable data sending, please register your system with OTRS Group or update your system registration information (make sure to activate the \'send support data\' option.)' =>
            '',
        'A support bundle (including: system registration information, support data, a list of installed packages and all locally modified source code files) can be generated by pressing this button:' =>
            '',
        'Generate Support Bundle' => '',
        'Generating...' => '',
        'It was not possible to generate the Support Bundle.' => '',
        'Generate Result' => '',
        'Support Bundle' => '',
        'The mail could not be sent' => '',
        'The support bundle has been generated.' => '',
        'Please choose one of the following options.' => '',
        'Send by Email' => '',
        'The support bundle is too large to send it by email, this option has been disabled.' =>
            '',
        'The email address for this user is invalid, this ption has been disabled.' =>
            '',
        'Sending' => '',
        'The support bundle will be sent to OTRS Group via email automatically.' =>
            '',
        'Download File' => '',
        'A file containing the support bundle will be downloaded to the local system. Please save the file and send it to the OTRS Group, using an alternate method.' =>
            '',
        'Error: Support data could not be collected (%s).' => '',
        'Details' => 'Szczegóły',

        # Template: AdminSession
        'Session Management' => 'Zarządzanie sesjami',
        'All sessions' => 'Wszystkie sesje',
        'Agent sessions' => 'Sesje agentów',
        'Customer sessions' => 'Sesje klientów',
        'Unique agents' => 'Unikalni agenci',
        'Unique customers' => 'Unikalni klienci',
        'Kill all sessions' => 'Zakończ wszystkie sesje',
        'Kill this session' => 'Zabij tą sesję',
        'Session' => 'Sesja',
        'Kill' => 'Zabij',
        'Detail View for SessionID' => 'Widok szczegółów sesji',

        # Template: AdminSignature
        'Signature Management' => 'Konfiguracja podpisów',
        'Add signature' => 'Dodaj podpis',
        'Add Signature' => 'Dodaj podpis',
        'Edit Signature' => 'Edytuj podpis',
        'Example signature' => 'Przykładowy podpis',

        # Template: AdminState
        'State Management' => 'Konfiguracja statusów',
        'Add state' => 'Dodaj status',
        'Please also update the states in SysConfig where needed.' => 'Zaktualizuj również statusy w konfiguracji systemu tam gdzie to konieczne.',
        'Add State' => 'Dodaj status',
        'Edit State' => 'Edytuj status',
        'State type' => 'Typ statusu',

        # Template: AdminSysConfig
        'SysConfig' => 'Konfiguracja systemu',
        'Navigate by searching in %s settings' => 'Nawiguj poprzez szukanie w %s ustawieniach',
        'Navigate by selecting config groups' => 'Nawiguj poprzez wskazanie grupy ustawień',
        'Download all system config changes' => 'Pobierz wszystkie zmiany konfiguracji systemu',
        'Export settings' => 'Eksportuj ustawienia',
        'Load SysConfig settings from file' => 'Załaduj ustawienia systemowe z pliku',
        'Import settings' => 'Importuj ustawienia',
        'Import Settings' => 'Importuj ustawienia',
        'Please enter a search term to look for settings.' => 'Podaj frazę do wyszukania ustawień. ',
        'Subgroup' => 'Podgrupa',
        'Elements' => 'Elementy',

        # Template: AdminSysConfigEdit
        'Edit Config Settings' => 'Edytuj Ustawienia Konfiguracyjne',
        'This config item is only available in a higher config level!' =>
            'Ten element konfiguracji jest dostępny wyłącznie na wyższym poziomie konfiguracji!',
        'Reset this setting' => 'Resetuj to ustawienie',
        'Error: this file could not be found.' => 'Błąd: ten plik nie został znaleziony.',
        'Error: this directory could not be found.' => 'Błąd: ten katalog nie został znaleziony.',
        'Error: an invalid value was entered.' => 'Błąd: podano niepoprawną wartość.',
        'Content' => 'Zawartość',
        'Remove this entry' => 'Usuń tę pozycję',
        'Add entry' => 'Dodaj pozycję',
        'Remove entry' => 'Usuń pozycję',
        'Add new entry' => 'Dodaj nową pozycję',
        'Delete this entry' => 'Usuń tę pozycję',
        'Create new entry' => 'Utwórz nową pozycję',
        'New group' => 'Nowa grupa',
        'Group ro' => 'Grupa ro',
        'Readonly group' => 'Grupa readonly',
        'New group ro' => 'Nowa grupa ro',
        'Loader' => 'Ładowanie',
        'File to load for this frontend module' => 'Plik do załadowania dla tego modułu',
        'New Loader File' => 'Nowy plik ładowania',
        'NavBarName' => 'Nazwa paska nawigacyjnego',
        'NavBar' => 'Pasek nawigacyjny',
        'LinkOption' => 'Opcja linkowania',
        'Block' => 'Blok',
        'AccessKey' => 'Klawisz skrótu',
        'Add NavBar entry' => 'Dodaj pozycję paska nawigacyjnego',
        'Year' => 'Rok',
        'Month' => 'Miesiąc',
        'Day' => 'Dzień',
        'Invalid year' => 'Niewłaściwy rok',
        'Invalid month' => 'Niewłaściwy miesiąc',
        'Invalid day' => 'Niewłaściwy dzień',
        'Show more' => 'Pokaż więcej',

        # Template: AdminSystemAddress
        'System Email Addresses Management' => 'Konfiguracja adresów e-mail Systemu',
        'Add system address' => 'Dodaj adres systemowy',
        'All incoming email with this address in To or Cc will be dispatched to the selected queue.' =>
            'Wszystkie przychodzące wiadomości e-mail z tym adresem w Do lub DW będą skierowane do wskazanej kolejki.',
        'Email address' => 'Adres e-mail',
        'Display name' => 'Wyświetlana nazwa',
        'Add System Email Address' => 'Dodaj systemowy adres e-mail',
        'Edit System Email Address' => 'Edytuj systemowy adres e-mail',
        'The display name and email address will be shown on mail you send.' =>
            'Wyświetlana nazwa oraz adres e-mail będą umieszczane w wysyłanej poczcie.',

        # Template: AdminSystemMaintenance
        'System Maintenance Management' => '',
        'Schedule New System Maintenance' => '',
        'Schedule a system maintenance period for announcing the Agents and Customers the system is down for a time period.' =>
            '',
        'Some time before this system maintenance starts the users will receive a notification on each screen announcing about this fact.' =>
            '',
        'Start date' => '',
        'Stop date' => '',
        'Delete System Maintenance' => '',
        'Do you really want to delete this scheduled system maintenance?' =>
            '',

        # Template: AdminSystemMaintenanceEdit
        'Edit System Maintenance %s' => '',
        'Edit System Maintenance information' => '',
        'Date invalid!' => 'Niepoprawna data',
        'Login message' => '',
        'Show login message' => '',
        'Notify message' => '',
        'Manage Sessions' => '',
        'All Sessions' => '',
        'Agent Sessions' => '',
        'Customer Sessions' => '',
        'Kill all Sessions, exept current' => '',

        # Template: AdminTemplate
        'Manage Templates' => 'Zarządzanie szablonami',
        'Add template' => 'Dodaj szablon',
        'A template is a default text which helps your agents to write faster tickets, answers or forwards.' =>
            'Szablon jest domyślnym tekstem który pozwala agentom na szybsze wypisywanie zgłoszeń, odpowiedzi i przekazań.',
        'Don\'t forget to add new templates to queues.' => 'Nie zapomnij dodać nowych szablonów do kolejki.',
        'Add Template' => 'Dodaj szablon',
        'Edit Template' => 'Edytuj szablon',
        'A standard template with this name already exists!' => '',
        'Template' => 'Szablon',
        'Create type templates only supports this smart tags' => 'Tworzenie typowych szablonów wspiera jedynie takie tagi',
        'Example template' => 'Przykładowy szablon',
        'The current ticket state is' => 'Aktualny status zgłoszenia to',
        'Your email address is' => 'Twój adres e-mail to',

        # Template: AdminTemplateAttachment
        'Manage Templates <-> Attachments Relations' => 'Zarządzaj szablonami <-> Relacje z załącznikami',
        'Filter for Attachments' => 'Filtr załączników',
        'Change Template Relations for Attachment' => 'Zmień relacje szablonu dla załącznika',
        'Change Attachment Relations for Template' => 'Zmień relacje załącznika dla szablonu',
        'Toggle active for all' => 'Przełącz aktywność dla wszystkich',
        'Link %s to selected %s' => 'Łącz %s do zaznaczenia %s',

        # Template: AdminType
        'Type Management' => 'Zarządzanie typami',
        'Add ticket type' => 'Dodaj typ zgłoszenia',
        'Add Type' => 'Dodaj typ',
        'Edit Type' => 'Edytuj typ zgłoszenia',
        'A type with this name already exists!' => '',

        # Template: AdminUser
        'Add agent' => 'Dodaj agenta',
        'Agents will be needed to handle tickets.' => 'Agenci są potrzebni do obsługi zgłoszeń.',
        'Don\'t forget to add a new agent to groups and/or roles!' => 'Nie zapomnij dodać nowego agenta do grup lub/i ról!',
        'Please enter a search term to look for agents.' => 'Podaj frazy wyszukiwania agentów.',
        'Last login' => 'Ostatnie logowanie',
        'Switch to agent' => 'Przełącz na agenta',
        'Add Agent' => 'Dodaj agenta',
        'Edit Agent' => 'Edytuj agenta',
        'Firstname' => 'Imię',
        'Lastname' => 'Nazwisko',
        'A user with this username already exists!' => '',
        'Will be auto-generated if left empty.' => 'Zostanie wygenerowane automatycznie jeśli pozostawione puste.',
        'Start' => 'Start',
        'End' => 'Koniec',

        # Template: AdminUserGroup
        'Manage Agent-Group Relations' => 'Zarządzaj relacjami agent-grupa',
        'Change Group Relations for Agent' => 'Zmień relacje grup do agenta',
        'Change Agent Relations for Group' => 'Zmień relacje agentów do grupy',
        'note' => 'uwaga',
        'Permissions to add notes to tickets in this group/queue.' => 'Uprawnienia do dodawania uwag do zgłoszeń w tej grupie/kolejce.',
        'owner' => 'właściciel',
        'Permissions to change the owner of tickets in this group/queue.' =>
            'Uprawnienia do zmiany właściciela zgłoszeńw tej grupie/kolejce.',

        # Template: AgentBook
        'Address Book' => 'Książka adresowa',
        'Search for a customer' => 'Szukaj klienta',
        'Add email address %s to the To field' => 'Dodaj adres e-mail %s do pola Do',
        'Add email address %s to the Cc field' => 'Dodaj adres e-mail %s do pola DW',
        'Add email address %s to the Bcc field' => 'Dodaj adres e-mail %s do pola UDW',
        'Apply' => 'Zastosuj',

        # Template: AgentCustomerInformationCenter
        'Customer Information Center' => 'Centrum informacji o kliencie',

        # Template: AgentCustomerInformationCenterSearch
        'Customer User' => 'Konto Klienta',

        # Template: AgentCustomerSearch
        'Duplicated entry' => 'Zduplikowana pozycja',
        'This address already exists on the address list.' => 'Ten adres juz istnieje na liście adresów.',
        'It is going to be deleted from the field, please try again.' => 'To zostanie usunięte z pola, spróbuj ponownie.',

        # Template: AgentCustomerTableView
        'Note: Customer is invalid!' => 'Info: Klient jest nieprawidłowy!',

        # Template: AgentDashboard
        'Dashboard' => 'Pulpit',

        # Template: AgentDashboardCalendarOverview
        'in' => 'za',

        # Template: AgentDashboardCommon
        'Available Columns' => 'Dostępne kolumny',
        'Visible Columns (order by drag & drop)' => 'Widoczne kolumny (sortuj poprzez przeciągnij i upuść)',

        # Template: AgentDashboardCustomerIDStatus
        'Escalated tickets' => 'Zgłoszenia eskalowane',

        # Template: AgentDashboardCustomerUserList
        'Customer information' => 'Dane klienta',
        'Phone ticket' => 'Zgłoszenia tel.',
        'Email ticket' => 'Zgłoszenia e-mail',
        'Start Chat' => '',
        '%s open ticket(s) of %s' => '% otwartych zgłoszeń z %s',
        '%s closed ticket(s) of %s' => '% zamknietych zgłoszeń z %s',
        'New phone ticket from %s' => 'Nowe zgłoszenie tel. od %s',
        'New email ticket to %s' => 'Nowe zgłoszenie e-mail od %s',
        'Start chat' => '',

        # Template: AgentDashboardProductNotify
        '%s %s is available!' => '%s %s jest dostępna',
        'Please update now.' => 'Prosimy, zaktualizuj teraz.',
        'Release Note' => 'Uwagi do wydania',
        'Level' => 'Poziom',

        # Template: AgentDashboardRSSOverview
        'Posted %s ago.' => 'Opublikowane %s temu.',

        # Template: AgentDashboardStats
        'The content of this statistic is being prepared for you, please be patient.' =>
            'Statystyki są dla ciebie przygotowywane. Proszę o cierpliwość.',
        'Grouped' => 'Pogrupowane',
        'Stacked' => 'Zestakowane',
        'Expanded' => '',
        'Stream' => '',
        'CSV' => '',
        'PDF' => '',

        # Template: AgentDashboardTicketGeneric
        'My locked tickets' => 'Zablokowane',
        'My watched tickets' => 'Obserwowane',
        'My responsibilities' => 'Odpowiedzialny',
        'Tickets in My Queues' => 'Moje kolejki',
        'Tickets in My Services' => '',
        'Service Time' => 'W godzinach roboczych',
        'Remove active filters for this widget.' => 'Usuń aktywne filtry dla tego widgeta.',

        # Template: AgentDashboardTicketQueueOverview
        'Totals' => 'Sumy',

        # Template: AgentDashboardUserOnline
        'out of office' => 'poza biurem',

        # Template: AgentDashboardUserOutOfOffice
        'until' => 'do',

        # Template: AgentHTMLReferencePageLayout
        'The ticket has been locked' => 'Zgłoszenie zostało zablokowane',
        'Undo & close window' => 'Cofnij i zamknij okno',

        # Template: AgentInfo
        'Info' => 'Info',
        'To accept some news, a license or some changes.' => 'Aby zaakceptować niektóre wiadomości, licencje lub niektóre zmiany.',

        # Template: AgentLinkObject
        'Link Object: %s' => 'Połącz obiekt: %s',
        'go to link delete screen' => 'idź do ekranu usuwania odnośnika',
        'Select Target Object' => 'Wybierz obiekt docelowy',
        'Link Object' => 'Połącz obiekt',
        'with' => 'z',
        'Unlink Object: %s' => 'Oddziel obiekt: %s',
        'go to link add screen' => 'idź do ekranu dodawania odnośnika',

        # Template: AgentPreferences
        'Edit your preferences' => 'Zmień swoje ustawienia',

        # Template: AgentSchedulerInfo
        'General Information' => '',
        'Scheduler is an OTRS separated process that perform asynchronous tasks' =>
            '',
        '(e.g. Generic Interface asynchronous invoker tasks)' => '',
        'It is necessary to have the Scheduler running to make the system work correctly!' =>
            '',
        'Starting Scheduler' => '',
        'Make sure that %s exists (without .dist extension)' => '',
        'Check that cron deamon is running in the system' => '',
        'Confirm that OTRS cron jobs are running, execute %s start' => '',

        # Template: AgentSpelling
        'Spell Checker' => 'Słownik',
        'spelling error(s)' => 'błędów językowych',
        'Apply these changes' => 'Zastosuj te zmiany',

        # Template: AgentStatsDelete
        'Delete stat' => 'Usuń statystykę',
        'Do you really want to delete this stat?' => 'Czy na pewno chcesz usunąć tę statystykę?',

        # Template: AgentStatsEditRestrictions
        'Step %s' => 'Krok %s',
        'General Specifications' => 'Specyfikacja ogólna',
        'Select the element that will be used at the X-axis' => 'Zaznacz element, który będzie używany dla osi X',
        'Select the elements for the value series' => 'Wybierz elementy dla serii danych',
        'Select the restrictions to characterize the stat' => 'Wybierz ograniczenia dla statystyki',
        'Here you can make restrictions to your stat.' => 'Tu możesz nałożyć ograniczenia na swoją statystykę.',
        'If you remove the hook in the "Fixed" checkbox, the agent generating the stat can change the attributes of the corresponding element.' =>
            'Jeżeli usuniesz znacznik  w polu "Fixed", agent będzie mógł zmienić atrybuty powiazanego elementu.',
        'Fixed' => 'Stały',
        'Please select only one element or turn off the button \'Fixed\'.' =>
            'Wybierz jeden element lub odznacz przycisk \'Stały\'.',
        'Absolute Period' => 'Okres bezwzględny',
        'Between' => 'Pomiędzy',
        'Relative Period' => 'Względny przedział',
        'The last' => 'Ostatni',
        'Finish' => 'Koniec',

        # Template: AgentStatsEditSpecification
        'Permissions' => 'Uprawnienia',
        'You can select one or more groups to define access for different agents.' =>
            'Możesz wskazać jedną lub więcej grup aby zdefiniować dostęp dla różnych agentów.',
        'Some result formats are disabled because at least one needed package is not installed.' =>
            'Niektóre formaty wynikowe są zablokowane ponieważ przynajmniej jeden z wymaganych pakietów nie jest zainstalowany.',
        'Please contact your administrator.' => 'Prosimy, o kontakt z twoim administratorem.',
        'Graph size' => 'Rozmiar wykresu.',
        'If you use a graph as output format you have to select at least one graph size.' =>
            'Jeżeli używasz wykresu jako formatu wyjściowego, musisz okreslić jego rozmiar.',
        'Sum rows' => 'Suma wierszy',
        'Sum columns' => 'Suma kolumn',
        'Use cache' => 'Użyj pamięci podręcznej',
        'Most of the stats can be cached. This will speed up the presentation of this stat.' =>
            'Większość statystyk może być umieszczona w pamięci podręcznej. Przyspiesza to wyświetlanie tych statystyk.',
        'Show as dashboard widget' => 'Pokaż jako widget pulpitu',
        'Provide the statistic as a widget that agents can activate in their dashboard.' =>
            'Udostępnij statystyki jako widget który agenci mogą aktywowac na swoim pulpicie.',
        'Please note' => 'Proszę zanotuj',
        'Enabling the dashboard widget will activate caching for this statistic in the dashboard.' =>
            'Włączenie widgetów pulpitu uaktywni cache dla statystyk pulpitu.',
        'Agents will not be able to change absolute time settings for statistics dashboard widgets.' =>
            'Agenci nie będa mieli możliwości bezwględnych ustawień czasu dla statystyk widgetów pulpitu.',
        'IE8 doesn\'t support statistics dashboard widgets.' => 'IE8 nie wspiera widgeta pulpitu dla statystyk',
        'If set to invalid end users can not generate the stat.' => 'Jeśli ustawiono wartość \'nieaktywne\' to użytkownicy nie będą mogli wygenerować tej statystyki.',

        # Template: AgentStatsEditValueSeries
        'Here you can define the value series.' => 'Tutaj definiowane są serie wartości.',
        'You have the possibility to select one or two elements.' => 'Masz możliwość zaznaczenia jednego lub dwóch elementów.',
        'Then you can select the attributes of elements.' => 'Następnie możesz zaznaczyć atrybuty elementów.',
        'Each attribute will be shown as single value series.' => 'Każdy atrybut będzie pokazany jako pojedyncza seria wartości.',
        'If you don\'t select any attribute all attributes of the element will be used if you generate a stat, as well as new attributes which were added since the last configuration.' =>
            'Jeśli nie zaznaczysz żadnego atrybutu, wszystkie atrybuty tego elementu będą użyte do wygenerowania statystyki, w tym również nowe atrybuty, które zostały dodane od czasu ostatniej konfiguracji.',
        'Scale' => 'Skala',
        'minimal' => 'minimum',
        'Please remember, that the scale for value series has to be larger than the scale for the X-axis (e.g. X-Axis => Month, ValueSeries => Year).' =>
            'Pamiętaj że skala wartości moze być większa od skali osi X (np. oś X => Miesiące, Wartości => Rok).',

        # Template: AgentStatsEditXaxis
        'Here you can define the x-axis. You can select one element via the radio button.' =>
            'Tutaj definiujesz oś X. Możesz zaznaczyć jeden element za pomocą przycisku radio.',
        'maximal period' => 'maksymalny przedział',
        'minimal scale' => 'minimalna skala',

        # Template: AgentStatsImport
        'Import Stat' => 'Importuj statystykę',
        'File is not a Stats config' => 'Plik nie jest szablonem rapoortu',
        'No File selected' => 'Nie wybrano pliku',

        # Template: AgentStatsOverview
        'Stats' => 'Statystyki',

        # Template: AgentStatsPrint
        'No Element selected.' => 'Nie wybrano elementu.',

        # Template: AgentStatsView
        'Export config' => 'Eksportuj konfigurację',
        'With the input and select fields you can influence the format and contents of the statistic.' =>
            'Korzystając z pól wejściowych i wyboru możesz wpłynąć na format i zawartość statystyki.',
        'Exactly what fields and formats you can influence is defined by the statistic administrator.' =>
            'To, które z pól i formatów możesz zmieniać zdefiniował administrator statystyki.',
        'Stat Details' => 'Szczegóły statystyki',
        'Format' => 'Format',
        'Graphsize' => 'Wielkość wykresu',
        'Cache' => 'Pamięć podręczna',
        'Exchange Axis' => 'Zamień osie',

        # Template: AgentStatsViewSettings
        'Configurable params of static stat' => 'Konfigurowalne parametry statystyki statycznej',
        'No element selected.' => 'Nie wybrano elementu',
        'maximal period from' => 'maksymalny przedział od',
        'to' => 'do',
        'not changable for dashboard statistics' => 'nie zmienialne dla statystyk pulpitu',
        'Select Chart Type' => '',
        'Chart Type' => '',
        'Multi Bar Chart' => '',
        'Multi Line Chart' => '',
        'Stacked Area Chart' => '',

        # Template: AgentTicketActionCommon
        'Change Free Text of Ticket' => 'Zmień pola dodatkowe zgłoszenia',
        'Change Owner of Ticket' => 'Zmień właściciela zgłoszenia',
        'Close Ticket' => 'Zamknij zgłoszenie',
        'Add Note to Ticket' => 'Dodaj uwagę do zgłoszenia',
        'Set Pending' => 'Ustaw oczekiwanie',
        'Change Priority of Ticket' => 'Zmień priorytet zgłoszenia',
        'Change Responsible of Ticket' => 'Zmień osobę odpowiedzialną za zgłoszenie',
        'All fields marked with an asterisk (*) are mandatory.' => 'Pola oznaczone gwiazdką (*) są wymagane.',
        'Service invalid.' => 'Nieprawidłowa usługa.',
        'New Owner' => 'Nowy właściciel',
        'Please set a new owner!' => 'Prosimy ustaw nowego właściciela!',
        'Previous Owner' => 'Poprzedni właściciel',
        'Next state' => 'Następny status',
        'For all pending* states.' => '',
        'Add Article' => '',
        'Create an Article' => '',
        'Spell check' => 'Sprawdzanie poprawności',
        'Text Template' => 'Tekst szablonu',
        'Setting a template will overwrite any text or attachment.' => '',
        'Note type' => 'Typ notatki',
        'Inform Agent' => 'Poinformuj agenta',
        'Optional' => 'Opcjonalny',
        'Inform involved Agents' => 'Poinformuj zaangażowanych agentów',
        'Here you can select additional agents which should receive a notification regarding the new article.' =>
            '',

        # Template: AgentTicketBounce
        'Bounce Ticket' => 'Przekaż zgłoszenie',
        'Bounce to' => 'Przekaż do',
        'You need a email address.' => 'Potrzebujesz adresu e-mail.',
        'Need a valid email address or don\'t use a local email address.' =>
            'Potrzebny poprawny adres e-mail lub nie używaj lokalnego adresu e-mail.',
        'Next ticket state' => 'Następny status zgłoszenia',
        'Inform sender' => 'Powiadom nadawcę',
        'Send mail' => 'Wyślij wiadomość!',

        # Template: AgentTicketBulk
        'Ticket Bulk Action' => 'Akcja grupowa',
        'Send Email' => 'Wyślij e-mail',
        'Merge to' => 'Scal z',
        'Invalid ticket identifier!' => 'Niepoprawny identyfikator zgłoszenia!',
        'Merge to oldest' => 'Scal z najstarszym',
        'Link together' => 'Połącz razem',
        'Link to parent' => 'Połącz z rodzicem',
        'Unlock tickets' => 'Odblokuj zgłoszenia',

        # Template: AgentTicketCompose
        'Compose answer for ticket' => 'Edytuj odpowiedź do zgłoszenia',
        'Please include at least one recipient' => 'Wprowadź przynajmniej jednego odbiorcę',
        'Remove Ticket Customer' => 'Usuń klienta ze zgłoszenia',
        'Please remove this entry and enter a new one with the correct value.' =>
            'Usuń ten wpis i wprowadź nowy z poprawną wartością.',
        'Remove Cc' => 'Usuń DW',
        'Remove Bcc' => 'Usuń UDW',
        'Address book' => 'Książka adresowa',
        'Date Invalid!' => 'Niepoprawna data!',

        # Template: AgentTicketCustomer
        'Change customer of ticket' => 'Zmień klienta dla zgłoszenia',
        'Customer user' => 'Konto klienta',

        # Template: AgentTicketEmail
        'Create New Email Ticket' => 'Utwórz nowe zgłoszenie e-mail',
        'Example Template' => '',
        'From queue' => 'Do kolejki',
        'To customer user' => 'Do konta klienta',
        'Please include at least one customer user for the ticket.' => 'Proszę wybierz przynajmniej jednego konta klienta dla zgłoszenia.',
        'Select this customer as the main customer.' => 'Wybierz tego klienta jako podstawowego',
        'Remove Ticket Customer User' => 'Usuń zgłoszenie klienta',
        'Get all' => 'Pobierz wszystkich',

        # Template: AgentTicketEmailOutbound
        'E-Mail Outbound' => '',

        # Template: AgentTicketForward
        'Forward ticket: %s - %s' => 'Prześlij dalej zgłoszenie: %s - %s',

        # Template: AgentTicketHistory
        'History of' => 'Historia',
        'History Content' => 'Zawartość historii',
        'Zoom view' => 'Widok szczegółowy',

        # Template: AgentTicketMerge
        'Ticket Merge' => 'Scal zgłoszenie',
        'You need to use a ticket number!' => 'Musisz użyć numeru zgłoszenia!',
        'A valid ticket number is required.' => 'Wymagany jest poprawny numer zgłoszenia.',
        'Need a valid email address.' => 'Potrzebny poprawny adres e-mail',

        # Template: AgentTicketMove
        'Move Ticket' => 'Przenieś zgłoszenie',
        'New Queue' => 'Nowa kolejka',

        # Template: AgentTicketOverviewMedium
        'Select all' => 'Zaznacz wszystkie',
        'No ticket data found.' => 'Nie odnaleziono danych zgłoszenia.',
        'Select this ticket' => '',
        'First Response Time' => 'Czas pozostały do pierwszej odpowiedzi',
        'Update Time' => 'Czas pozostały do aktualizacji',
        'Solution Time' => 'Czas pozostały do rozwiazania',
        'Move ticket to a different queue' => 'Przenieś zgłoszenie do innej kolejki',
        'Change queue' => 'Zmień kolejkę',

        # Template: AgentTicketOverviewNavBar
        'Change search options' => 'Zmień kryteria wyszukiwania',
        'Remove active filters for this screen.' => 'Usuń aktywne filtry z tego ekranu.',
        'Tickets per page' => 'Zgłoszeń na stronę',

        # Template: AgentTicketOverviewSmall
        'Reset overview' => 'Resetuj wygląd',
        'Column Filters Form' => 'Formularz filtrów kolumn',

        # Template: AgentTicketPhone
        'Split Into New Phone Ticket' => '',
        'Save Chat Into New Phone Ticket' => '',
        'Create New Phone Ticket' => 'Utwórz nowe zgłoszenie telefoniczne',
        'Please include at least one customer for the ticket.' => 'Wprowadź przynajmniej jednego klienta dla zgłoszenia.',
        'To queue' => 'Do kolejki',
        'Chat protocol' => '',
        'The chat will be appended as a separate article.' => '',

        # Template: AgentTicketPlain
        'Email Text Plain View' => 'Widok tekstu źródłowego e-mail',
        'Plain' => 'Postać źródłowa',
        'Download this email' => 'Pobierz ten e-mail',

        # Template: AgentTicketPrint
        'Ticket-Info' => 'Informacje o zgłoszeniu',
        'Accounted time' => 'Zaraportowany czas',
        'Linked-Object' => 'Powiązany obiekt',
        'by' => 'przez',

        # Template: AgentTicketProcess
        'Create New Process Ticket' => 'Utwórz nowe zgłoszenie do procesu',
        'Process' => 'Proces',

        # Template: AgentTicketProcessSmall
        'Enroll Ticket into a Process' => '',

        # Template: AgentTicketSearch
        'Search template' => 'Szablon wyszukiwania',
        'Create Template' => 'Stwórz szablon',
        'Create New' => 'Stwórz nowy',
        'Profile link' => 'Link do profilu',
        'Save changes in template' => 'Zapisz zmiany w szablonie',
        'Filters in use' => '',
        'Additional filters' => '',
        'Add another attribute' => 'Dodaj inny parametr',
        'Output' => 'Format wyjściowy',
        'Fulltext' => 'Pełnotekstowe',
        'Remove' => 'Usuń',
        'Searches in the attributes From, To, Cc, Subject and the article body, overriding other attributes with the same name.' =>
            'Wyszukiwania w atrybutach Od, Do, CC, Tytuł, Treść ignoruje inne atrybuty z tą samą nazwą.',
        'Customer User Login' => 'Login Klienta',
        'Attachment Name' => '',
        '(e. g. m*file or myfi*)' => '',
        'Created in Queue' => 'Utworzono w kolejce',
        'Lock state' => 'Stan blokady',
        'Watcher' => 'Obserwujący',
        'Article Create Time (before/after)' => 'Czas utworzenia artykułu (przed/po)',
        'Article Create Time (between)' => 'Czas utworzenia artykułu (pomiędzy)',
        'Ticket Create Time (before/after)' => 'Czas utworzenia zgłoszenia (przed/po)',
        'Ticket Create Time (between)' => 'Czas utworzenia zgłoszenia (pomiędzy)',
        'Ticket Change Time (before/after)' => 'Czas zmiany zgłoszenia (przed/po)',
        'Ticket Change Time (between)' => 'Czas zmiany zgłoszenia (pomiędzy)',
        'Ticket Last Change Time (before/after)' => '',
        'Ticket Last Change Time (between)' => '',
        'Ticket Close Time (before/after)' => 'Czas zamknięcia zgłoszenia (przed/po)',
        'Ticket Close Time (between)' => 'Czas zamknięcia zgłoszenia (pomiędzy)',
        'Ticket Escalation Time (before/after)' => 'Czas eskalacji zgłoszenia (przez/po)',
        'Ticket Escalation Time (between)' => 'Czas eskalacji zgłoszenia (pomiędzy)',
        'Archive Search' => 'Szukanie w archiwum',
        'Run search' => 'Szukaj',

        # Template: AgentTicketZoom
        'Article filter' => 'Filtr wiadomości',
        'Article Type' => 'Typ artykułu',
        'Sender Type' => 'Typ nadawcy',
        'Save filter settings as default' => 'Zapisz ustawienia filtru jako domyślne',
        'Event Type Filter' => '',
        'Event Type' => '',
        'Save as default' => '',
        'Archive' => 'Archiwum',
        'This ticket is archived.' => 'To zgłoszenie jest zarchiwizowane.',
        'Locked' => 'Blokada',
        'Linked Objects' => 'Połączone elementy',
        'Change Queue' => 'Zmień kolejkę',
        'There are no dialogs available at this point in the process.' =>
            'W tym punkcie procesów brak jest jeszcze dialogów.',
        'This item has no articles yet.' => 'Ten element nie ma jeszcze artykułów.',
        'Ticket Timeline View' => '',
        'Article Overview' => '',
        'Article(s)' => 'Wiadomość(ci)',
        'Page' => 'Strona',
        'Add Filter' => 'Dodaj filtr',
        'Set' => 'Ustaw',
        'Reset Filter' => 'resetuj filtr',
        'Show one article' => 'Pokaż tylko jedną wiadomość',
        'Show all articles' => 'Pokaż wszystkie wiadomości',
        'Show Ticket Timeline View' => '',
        'Unread articles' => 'Nieprzeczytane wiadomości',
        'No.' => 'Lp.',
        'Important' => 'Ważne',
        'Unread Article!' => 'Nieprzeczytana wiadomość!',
        'Incoming message' => 'Wiadomość przychodząca',
        'Outgoing message' => 'Wiadomość wychodząca',
        'Internal message' => 'Wiadomość wewnętrzna',
        'Resize' => 'Zmień rozmiar',
        'Mark this article as read' => '',
        'Show Full Text' => '',
        'Full Article Text' => '',
        'No more events found. Please try changing the filter settings.' =>
            '',
        'Article could not be opened! Perhaps it is on another article page?' =>
            '',

        # Template: AttachmentBlocker
        'To protect your privacy, remote content was blocked.' => 'Aby chronić twoją prywatność, zdalna zawartość została zablokowana.',
        'Load blocked content.' => 'Załaduj zablokowaną treść.',

        # Template: ChatStartForm
        'First message' => '',

        # Template: CustomerError
        'Traceback' => 'Śledź wstecz',

        # Template: CustomerFooter
        'Powered by' => 'Oparte na',

        # Template: CustomerFooterJS
        'One or more errors occurred!' => 'Wystąpił jeden lub więcej błędów!',
        'Close this dialog' => 'Zamknij to okno dialogowe',
        'Could not open popup window. Please disable any popup blockers for this application.' =>
            'Nie można otworzyć okna popup. Usuń wszelkie blokady popup-ów dla tej aplikacji.',
        'There are currently no elements available to select from.' => 'Obecnie nie ma jeszcze elementów z których można by wybrać.',
        'Please turn off Compatibility Mode in Internet Explorer!' => '',
        'The browser you are using is too old.' => 'Przeglądarka której używasz jest zbyt stara.',
        'OTRS runs with a huge lists of browsers, please upgrade to one of these.' =>
            'OTRS współpracuje z wieloma przeglądrkami, prosimy, użyj jednej z nich.',
        'Please see the documentation or ask your admin for further information.' =>
            'Zajrzyj do dokumentacji lub zapytaj o szczegóły swojego administratora.',

        # Template: CustomerLogin
        'JavaScript Not Available' => 'JavaScript nie jest dostęny',
        'In order to experience OTRS, you\'ll need to enable JavaScript in your browser.' =>
            'Aby korzystać z OTRS, musisz włączyć obsługę JavaScript w twojej przeglądarce.',
        'Browser Warning' => 'Ostrzeżenie dotyczące przeglądarki',
        'One moment please, you are being redirected...' => '',
        'Login' => 'Zaloguj się',
        'User name' => 'Nazwa użytkownika',
        'Your user name' => 'Twoja nazwa użytkownika',
        'Your password' => 'Twoje hasło',
        'Forgot password?' => 'Zapomniane hasło?',
        'Log In' => 'Zaloguj się',
        'Not yet registered?' => 'Nie jesteś jeszcze zarejetrowanym użytkownikiem?',
        'Request new password' => 'Prośba o nowe hasło',
        'Your User Name' => 'Nazwa użytkownika',
        'A new password will be sent to your email address.' => 'Nowe hasło będzie wysłane na twój adres e-mail',
        'Create Account' => 'Utwórz konto',
        'Please fill out this form to receive login credentials.' => 'Wypełnij ten formularz aby otrzymać dane logowania.',
        'How we should address you' => 'Jak powinniśmy cię tytułować',
        'Your First Name' => 'Twoje imię',
        'Your Last Name' => 'Twoje nazwisko',
        'Your email address (this will become your username)' => 'Twój adres e-mail (stanie się twoją nazwą użytkownika)',

        # Template: CustomerNavigationBar
        'Incoming Chat Requests' => '',
        'You have unanswered chat requests' => '',
        'Edit personal preferences' => 'Edytuj ustawienia osobiste',

        # Template: CustomerRichTextEditor
        'Split Quote' => '',

        # Template: CustomerTicketMessage
        'Service level agreement' => 'SLA',

        # Template: CustomerTicketOverview
        'Welcome!' => 'Witaj!',
        'Please click the button below to create your first ticket.' => 'Prosimy, kliknij przycisk poniżej aby utworzyć swoje pierwsze zgłoszenie.',
        'Create your first ticket' => 'Utwórz swoje pierwsze zgłoszenie',

        # Template: CustomerTicketPrint
        'Ticket Print' => 'Drukowanie zgłoszenia',
        'Ticket Dynamic Fields' => 'Informacje dodatkowe',

        # Template: CustomerTicketSearch
        'Profile' => 'Profil',
        'e. g. 10*5155 or 105658*' => 'np. 10*5155 lub 105658*',
        'Customer ID' => 'ID Klienta',
        'Fulltext search in tickets (e. g. "John*n" or "Will*")' => 'Wyszukiwanie pełnotekstowe w zgłoszeniach (np. "*odyfikacj* lub druk*")',
        'Carbon Copy' => 'Kopia (CC)',
        'e. g. m*file or myfi*' => '',
        'Types' => 'Typy zgłoszeń',
        'Time restrictions' => 'Ograniczenia czasowe',
        'No time settings' => 'Brak ustawień czasowych',
        'Only tickets created' => 'Tylko zgłoszenia utworzone',
        'Only tickets created between' => 'Tylko zgłoszenia utworzone między',
        'Ticket archive system' => 'System archiwizacji zgłoszeń',
        'Save search as template?' => 'Zachować wyszukiwanie jako szablon?',
        'Save as Template?' => 'Zapisać jako szablon?',
        'Save as Template' => 'Zapisz jako szablon',
        'Template Name' => 'Nazwa szablonu',
        'Pick a profile name' => 'Wybierz nazwę profilu',
        'Output to' => 'Wyniki prezentuj jako',

        # Template: CustomerTicketSearchResultShort
        'of' => 'z',
        'Search Results for' => 'Wyniki wyszukiwania dla',
        'Remove this Search Term.' => '',

        # Template: CustomerTicketZoom
        'Expand article' => 'Rozwiń artykuł',
        'Next Steps' => 'Następne kroki',
        'Reply' => 'Odpowiedź',

        # Template: DashboardEventsTicketCalendar
        'All-day' => '',
        'Sunday' => '7.Niedziela',
        'Monday' => '1.Poniedziałek',
        'Tuesday' => '2.Wtorek',
        'Wednesday' => '3.Środa',
        'Thursday' => '4.Czwartek',
        'Friday' => '5.Piątek',
        'Saturday' => '6.Sobota',
        'Su' => 'Nd',
        'Mo' => 'Pn',
        'Tu' => 'Wt',
        'We' => 'Śr',
        'Th' => 'Cz',
        'Fr' => 'Pt',
        'Sa' => 'So',
        'Event Information' => 'Informacje o zdarzeniach',
        'Ticket fields' => 'Pola zgłoszenia',
        'Dynamic fields' => 'Pola dynamiczne',

        # Template: Datepicker
        'Invalid date (need a future date)!' => 'Niepoprawna data (wymagana przyszła data)!',
        'Invalid date (need a past date)!' => '',
        'Previous' => 'Poprzednie',
        'Open date selection' => 'Otwórz wybór daty',

        # Template: Error
        'Oops! An Error occurred.' => 'Ups! Pojawił się błąd.',
        'You can' => 'Możesz',
        'Send a bugreport' => 'Wysłać raport na temat błędu',
        'go back to the previous page' => 'powrócić do poprzedniej strony',
        'Error Details' => 'Szczegóły błędu',

        # Template: FooterJS
        'If you now leave this page, all open popup windows will be closed, too!' =>
            'Jeśli opuścisz tę stronę, wszystkie okna popup będą również zamknięte!',
        'A popup of this screen is already open. Do you want to close it and load this one instead?' =>
            'Okno popup tej strony jest wciąż otwarte. Czy chcesz je zamknąć i załadować zamiast niego to okno?',
        'Please enter at least one search value or * to find anything.' =>
            'Wprowadź przynajmniej jedną wyszukiwaną wartość lub * aby znaleźć cokolwiek.',
        'Please check the fields marked as red for valid inputs.' => 'Proszę sprawdź poprawnośc danych w polach oznaczonych jako czerowne.',
        'Please perform a spell check on the the text first.' => '',
        'Slide the navigation bar' => '',

        # Template: Header
        'You are logged in as' => 'Jesteś zalogowany jako',

        # Template: Installer
        'JavaScript not available' => 'JavaSript nie jest dostępny',
        'Database Settings' => 'Ustawienia bazy danych',
        'General Specifications and Mail Settings' => 'Ustawienia ogólne i poczty e-mail',
        'Web site' => 'Strona WWW',
        'Mail check successful.' => 'Sprawdzanie poczty e-mail zakończone pomyślnie.',
        'Error in the mail settings. Please correct and try again.' => 'Błąd w ustawieniach poczty. Popraw i spróbuj ponownie.',

        # Template: InstallerConfigureMail
        'Configure Outbound Mail' => 'Konfiguruj pocztę wychodzącą',
        'Outbound mail type' => 'Typ poczty wychodzącej',
        'Select outbound mail type.' => 'Wskaż typ poczty wychodzącej',
        'Outbound mail port' => 'Port poczty wychodzącej',
        'Select outbound mail port.' => 'Wybierz port poczty wychodzącej',
        'SMTP host' => 'Serwer SMTP',
        'SMTP host.' => 'Serwer SMTP.',
        'SMTP authentication' => 'Autentykacja SMTP',
        'Does your SMTP host need authentication?' => 'Czy twój serwer SMTP wymaga autentykacji?',
        'SMTP auth user' => 'Użytkownik do autentykacji SMTP',
        'Username for SMTP auth.' => 'Użytkownik do autentykacji SMTP.',
        'SMTP auth password' => 'Hasło do autentykacji SMTP',
        'Password for SMTP auth.' => 'Hasło do autentykacji SMTP.',
        'Configure Inbound Mail' => 'Konfiguruj pocztę przychodzącą',
        'Inbound mail type' => 'Typ poczty przychodzącej',
        'Select inbound mail type.' => 'Wskaż typ poczty przychodzącej',
        'Inbound mail host' => 'Serwer poczty przychodzącej',
        'Inbound mail host.' => 'Serwer poczty przychodzącej.',
        'Inbound mail user' => 'Użytkownik poczty przychodzącej',
        'User for inbound mail.' => 'Użytkownik poczty przychodzącej.',
        'Inbound mail password' => 'Hasło do poczty przychodzącej',
        'Password for inbound mail.' => 'Hasło do poczty przychodzącej.',
        'Result of mail configuration check' => 'Wynik sprawdzania konfiguracji poczty',
        'Check mail configuration' => 'Sprawdź konfigurację poczty',
        'Skip this step' => 'Pomiń ten krok',

        # Template: InstallerDBResult
        'Database setup successful!' => 'Konfiguracja bazy danych powiodła się!',

        # Template: InstallerDBStart
        'Install Type' => 'Zainstaluj typ',
        'Create a new database for OTRS' => 'Stwórz nową baze danych dla OTRS',
        'Use an existing database for OTRS' => 'Użyj istniejącej bazy danych dla OTRS',

        # Template: InstallerDBmssql
        'Database name' => 'Nazwa bazy danych',
        'Check database settings' => 'Sprawdź ustawienia bazy danych',
        'Result of database check' => 'Wynik sprawdzenia bazy danych',
        'Database check successful.' => 'Sprawdzanie bazy zakończone pomyślnie.',
        'Database User' => 'Użytkownik bazy danych',
        'New' => 'Nowe',
        'A new database user with limited permissions will be created for this OTRS system.' =>
            'Dla tego systemu OTRS utworzony zostanie nowy użytkownik bazy danych z ograniczonymi uprawnieniami.',
        'Repeat Password' => 'Powtórz hasło',
        'Generated password' => 'Wygenerowane hasło',

        # Template: InstallerDBmysql
        'Passwords do not match' => 'Hasła nie zgadzają się',

        # Template: InstallerDBoracle
        'SID' => 'SID',
        'Port' => 'Port',

        # Template: InstallerFinish
        'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' =>
            'Musisz wpisać następujące polecenie w linii komend (Terminal/Shell).',
        'Restart your webserver' => 'Uruchom ponownie serwer WWW',
        'After doing so your OTRS is up and running.' => 'Po zakończeniu tych czynności Twój system OTRS będzie gotowy do pracy.',
        'Start page' => 'Strona startowa',
        'Your OTRS Team' => 'Twój Zespół OTRS',

        # Template: InstallerLicense
        'Don\'t accept license' => 'Nie akceptuję licencji',
        'Accept license and continue' => '',

        # Template: InstallerSystem
        'The identifier of the system. Each ticket number and each HTTP session ID contain this number.' =>
            'Identyfikator systemu. Każde zgłoszenie i każde ID sesji HTTP zawiera ten numer',
        'System FQDN' => 'Pełna domena systemu (FQDN)',
        'Fully qualified domain name of your system.' => 'Pełna nazwa domenowa (FQDN) twojego systemu.',
        'AdminEmail' => 'E-mail administratora',
        'Email address of the system administrator.' => 'Adres e-mail administratora systemu',
        'Organization' => 'Organizacja',
        'Log' => 'Log',
        'LogModule' => 'Moduł logowania',
        'Log backend to use.' => 'Używany moduł logowania',
        'LogFile' => 'Plik log',
        'Webfrontend' => 'Interfejs webowy',
        'Default language' => 'Domyślny język',
        'Default language.' => 'Domyślny język.',
        'CheckMXRecord' => 'Sprawdź rekord MX',
        'Email addresses that are manually entered are checked against the MX records found in DNS. Don\'t use this option if your DNS is slow or does not resolve public addresses.' =>
            'Poprawność wprowadzanych ręcznie adresów e-mail jest sprawdzana z rekordami MX w bazie DNS. Nie używaj tej opcji jeśli twój DNS jest wolny lub nie rozwiązuje adresów publicznych.',

        # Template: LinkObject
        'Object#' => 'Obiekt#',
        'Add links' => 'Dodaj odnośniki',
        'Delete links' => 'Usuń odnośniki',

        # Template: Login
        'Lost your password?' => 'Zapomniałeś hasła?',
        'Request New Password' => 'Prośba o nowe hasło',
        'Back to login' => 'Powrót do logowania',

        # Template: Motd
        'Message of the Day' => 'Wiadomość dnia',

        # Template: NoPermission
        'Insufficient Rights' => 'Nie wystarczające uprawnienia',
        'Back to the previous page' => 'Powrót do poprzedniej strony',

        # Template: Notify
        'Close this message' => '',

        # Template: Pagination
        'Show first page' => 'Pokaż pierwszą stronę',
        'Show previous pages' => 'Pokaż poprzednie strony',
        'Show page %s' => 'Pokaż stronę %s',
        'Show next pages' => 'Pokaż następne strony',
        'Show last page' => 'Pokaż ostatnią stronę',

        # Template: PictureUpload
        'Need FormID!' => 'Potrzebne ID formularza!',
        'No file found!' => 'Nie odnaleziono pliku!',
        'The file is not an image that can be shown inline!' => 'Plik nie jest obrazkiem, który może być pokazany w treści!',

        # Template: PrintHeader
        'printed by' => 'Wydrukowane przez',

        # Template: Test
        'OTRS Test Page' => 'OTRS Strona testowa',
        'Counter' => 'Licznik',

        # Template: Warning
        'Go back to the previous page' => 'Powrót do poprzedniej strony',

        # SysConfig
        ' (work units)' => '',
        '"%s"-notification sent to "%s".' => '"%s"-powiadomienie wysłano do "%s".',
        '%s' => '%s',
        '%s time unit(s) accounted. Now total %s time unit(s).' => 'Dodano %s jednostek czasu. Obecnie całkowity czas to %s jednostek.',
        '(UserLogin) Firstname Lastname' => '(Login) Imię',
        '(UserLogin) Lastname, Firstname' => '(Login) Nazwisko',
        'A Website' => '',
        'A list of dynamic fields that are merged into the main ticket during a merge operation. Only dynamic fields that are empty in the main ticket will be set.' =>
            '',
        'A picture' => '',
        'ACL module that allows closing parent tickets only if all its children are already closed ("State" shows which states are not available for the parent ticket until all child tickets are closed).' =>
            'Modu; ACL pozwalajacy na zamykanie nadrzędnych zgłoszeń tylko wóczas gdy wszystkie podrzędne są już zamknięte ("Status") pokazuje które stany nie są dostępne dla zgłoszenia nadrzędnego aż do momentu zamknięcia wszystkich podrzędnych.',
        'Access Control Lists (ACL)' => 'Lista Kontroli dostępu (ACL)',
        'AccountedTime' => 'Ubiegły czas',
        'Activates a blinking mechanism of the queue that contains the oldest ticket.' =>
            'Aktywuje mechanizm pulsowania kolejki dla najstarszych zgłoszeń.',
        'Activates lost password feature for agents, in the agent interface.' =>
            'Aktywuje funkcjonalność ozdyskania hasła dla agentów w interfejsie agenta.',
        'Activates lost password feature for customers.' => 'Aktywuje funkcjonalność ozdyskania hasła dla klientów',
        'Activates support for customer groups.' => 'Aktywuje wsparcie dla grup klientów.',
        'Activates the article filter in the zoom view to specify which articles should be shown.' =>
            'Aktywuje filtr artykułów w widoku zbliżonym umożliwiając wybór które artykuły powinny zostać widoczne.',
        'Activates the available themes on the system. Value 1 means active, 0 means inactive.' =>
            'Aktywuje dostepne motywy w systeie. Watrość 1 oznacza aktywację, 0 oznacza deaktywację.',
        'Activates the ticket archive system search in the customer interface.' =>
            'Aktywuje archiwum systemu zgłoszeń w interfejsie klienta.',
        'Activates the ticket archive system to have a faster system by moving some tickets out of the daily scope. To search for these tickets, the archive flag has to be enabled in the ticket search.' =>
            'Aktywuje archiwum złoszeń by uzyskać szybsze działanie systemu poprzez przeniesienie zgłoszeń z dziennego zakresu. By wyszukiwać te zgłoszenia flaga archiwum musi zostać aktywowana w oknie wyszukiwania zgłoszeń.',
        'Activates time accounting.' => 'Aktywuje rozliczanie czasu.',
        'ActivityID' => '',
        'Added email. %s' => 'Dodano e-mail. %s',
        'Added link to ticket "%s".' => 'Dodano łącze do zgłoszenia "%s".',
        'Added note (%s)' => 'Dodano notatkę (%s)',
        'Added subscription for user "%s".' => 'Dodano subskrypcje dla użytkownika "%s".',
        'Adds a suffix with the actual year and month to the OTRS log file. A logfile for every month will be created.' =>
            '',
        'Adds customers email addresses to recipients in the ticket compose screen of the agent interface. The customers email address won\'t be added if the article type is email-internal.' =>
            '',
        'Adds the one time vacation days for the indicated calendar. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            '',
        'Adds the one time vacation days. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            '',
        'Adds the permanent vacation days for the indicated calendar. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            '',
        'Adds the permanent vacation days. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            '',
        'Agent Notifications' => 'Powiadomienie dla agentów',
        'Agent called customer.' => 'Agent telefonował do klienta.',
        'Agent interface article notification module to check PGP.' => 'Interfejs agenta w module powiadomień PGP',
        'Agent interface article notification module to check S/MIME.' =>
            'Interfejs agenta w module powiadomień S/MIME',
        'Agent interface module to access CIC search via nav bar.' => 'Moduł dostępu wyszukiwania CIC interfejsu agenta w pasku nawigacyjnym',
        'Agent interface module to access fulltext search via nav bar.' =>
            'Moduł dostępu wyszukiwania pełnotekstowego interfejsu agenta w pasku nawigacyjnym',
        'Agent interface module to access search profiles via nav bar.' =>
            'Moduł dostępu wyszukiwania profili interfejsu agenta w pasku nawigacyjnym',
        'Agent interface module to check incoming emails in the Ticket-Zoom-View if the S/MIME-key is available and true.' =>
            '',
        'Agent interface notification module to check the used charset.' =>
            'Moduł powiadomień sprawdzania użytego characteru znaków interfejsu agenta',
        'Agent interface notification module to see the number of tickets an agent is responsible for.' =>
            '',
        'Agent interface notification module to see the number of tickets in My Services.' =>
            '',
        'Agent interface notification module to see the number of watched tickets.' =>
            '',
        'Agents <-> Groups' => 'Agenci <-> Grupy',
        'Agents <-> Roles' => 'Agenci <-> Role',
        'All customer users of a CustomerID' => 'wszyscy użytkownicy klienta z ID',
        'Allows adding notes in the close ticket screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            '',
        'Allows adding notes in the ticket free text screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            '',
        'Allows adding notes in the ticket note screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            '',
        'Allows adding notes in the ticket owner screen of a zoomed ticket in the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            '',
        'Allows adding notes in the ticket pending screen of a zoomed ticket in the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            '',
        'Allows adding notes in the ticket priority screen of a zoomed ticket in the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            '',
        'Allows adding notes in the ticket responsible screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            '',
        'Allows agents to exchange the axis of a stat if they generate one.' =>
            '',
        'Allows agents to generate individual-related stats.' => 'Pozwala agentom na generowanie statystyk z indywindualnych działań.',
        'Allows choosing between showing the attachments of a ticket in the browser (inline) or just make them downloadable (attachment).' =>
            'Pozwala na wybranie pomiędzy tym czy załączniki w zgłoszeniach będą widoczne bezpośrednio czy też ściągalne jako załacznik.',
        'Allows choosing the next compose state for customer tickets in the customer interface.' =>
            '',
        'Allows customers to change the ticket priority in the customer interface.' =>
            'Pozwala klientom na zmianę priorytetu zgłoszenia w interfejsie klienta.',
        'Allows customers to set the ticket SLA in the customer interface.' =>
            'Pozwala klientom na ustawienie SLA zgłoszenia w interfejsie klienta.',
        'Allows customers to set the ticket priority in the customer interface.' =>
            'Pozwala klientom na ustawienie priorytetu w interfejsie klienta.',
        'Allows customers to set the ticket queue in the customer interface. If this is set to \'No\', QueueDefault should be configured.' =>
            'Pozwala klientom na ustawienie kolejki zgłoszenia w interfejsie klienta. To jest ustawione jako \'NIE\', QueueDefault powinno zostać skonfigurowane.',
        'Allows customers to set the ticket service in the customer interface.' =>
            'Pozwala klientom na ustawienie serwisu złoszenia w interfejsie klienta.',
        'Allows customers to set the ticket type in the customer interface. If this is set to \'No\', TicketTypeDefault should be configured.' =>
            'Pozwala klientom na ustawienie typu zgłoszenia w interfejsie klienta. To jest ustawione jako \'NIE\', TicketTypeDefault powinno zostać skonfigurowane.',
        'Allows default services to be selected also for non existing customers.' =>
            'Pozwala na wybranie domyślnych serwisów dla nieistniejącyh klientów.',
        'Allows defining new types for ticket (if ticket type feature is enabled).' =>
            'Pozwala na definiowanie nowych typów dla zgłoszenia (jeśli funkcjonalność typu zgłoszenia została włączona).',
        'Allows defining services and SLAs for tickets (e. g. email, desktop, network, ...), and escalation attributes for SLAs (if ticket service/SLA feature is enabled).' =>
            '',
        'Allows extended search conditions in ticket search of the agent interface. With this feature you can search e. g. with this kind of conditions like "(key1&&key2)" or "(key1||key2)".' =>
            '',
        'Allows extended search conditions in ticket search of the customer interface. With this feature you can search w. g. with this kind of conditions like "(key1&&key2)" or "(key1||key2)".' =>
            '',
        'Allows having a medium format ticket overview (CustomerInfo => 1 - shows also the customer information).' =>
            '',
        'Allows having a small format ticket overview (CustomerInfo => 1 - shows also the customer information).' =>
            '',
        'Allows invalid agents to generate individual-related stats.' => '',
        'Allows the administrators to login as other customers, via the customer user administration panel.' =>
            'Pozwala administratorom na logowanie się jako inni klienci poprzez panel administracyjny konta klienta.',
        'Allows the administrators to login as other users, via the users administration panel.' =>
            'Pozwala administratorom na logowanie się jako inni użytkownicy poprzez panel administracyjny użytkowników.',
        'Allows to set a new ticket state in the move ticket screen of the agent interface.' =>
            '',
        'Archive state changed: "%s"' => 'Zmiana statusu archiwizacji: "%s"',
        'ArticleTree' => 'Drzewo z artykułami',
        'Attachments <-> Templates' => 'Załączniki <-> Szablony',
        'Auto Responses <-> Queues' => 'Autoodpowiedzi <-> Kolejki',
        'AutoFollowUp sent to "%s".' => 'Automatyczne nawiązanie wysłane do "%s".',
        'AutoReject sent to "%s".' => 'Automatyczne odrzucenie wysłano do "%s".',
        'AutoReply sent to "%s".' => 'Autoodpowiedź wysłana do "%s".',
        'Automated line break in text messages after x number of chars.' =>
            '',
        'Automatically lock and set owner to current Agent after opening the move ticket screen of the agent interface.' =>
            '',
        'Automatically lock and set owner to current Agent after selecting for an Bulk Action.' =>
            '',
        'Automatically sets the owner of a ticket as the responsible for it (if ticket responsible feature is enabled).' =>
            '',
        'Automatically sets the responsible of a ticket (if it is not set yet) after the first owner update.' =>
            '',
        'Balanced white skin by Felix Niklas (slim version).' => 'Biała zbalansowana skóra Felix Niklas (wersja odchudzona).',
        'Balanced white skin by Felix Niklas.' => 'Biała zbalansowana skóra Felix Niklas.',
        'Basic fulltext index settings. Execute "bin/otrs.RebuildFulltextIndex.pl" in order to generate a new index.' =>
            '',
        'Blocks all the incoming emails that do not have a valid ticket number in subject with From: @example.com address.' =>
            'Blokuje wszystkie przychodzące maile które nie posiadają ważnego numeru zgłoszenia w temacie z adresu: przyklad.pl.',
        'Bounced to "%s".' => 'Przekazano do "%s".',
        'Builds an article index right after the article\'s creation.' =>
            'Buduje indeks artykułu zaraz po utworzeniu artykułu.',
        'CMD example setup. Ignores emails where external CMD returns some output on STDOUT (email will be piped into STDIN of some.bin).' =>
            '',
        'Cache time in seconds for agent authentication in the GenericInterface.' =>
            'Okres utrzymywania cache w sekundach dla autentyfikacji agentów w GenericInterface',
        'Cache time in seconds for customer authentication in the GenericInterface.' =>
            'Okres utrzymywania cache w sekundach dla autentyfikacji klientów w GenericInterface.',
        'Cache time in seconds for the DB ACL backend.' => 'Okres utrzymywania cache w sekundach dla bazy danych ACL.',
        'Cache time in seconds for the DB process backend.' => 'Okres utrzymywania cache w sekundach dla procesowej bazy danych.',
        'Cache time in seconds for the SSL certificate attributes.' => 'Okres utrzymywania cache w sekundach dla atrybutów certyfikatu SSL.',
        'Cache time in seconds for the ticket process navigation bar output module.' =>
            'Okres utrzymywania cache w sekundach dla modułu paska zgłoszeń.',
        'Cache time in seconds for the web service config backend.' => 'Okres utrzymywania cache w sekundach dla konfigu serwisu sieciowego.',
        'Change password' => 'Zmień hasło',
        'Change queue!' => 'Zmień kolejkę!',
        'Change the customer for this ticket' => 'Zmień klienta tego zgłoszenia',
        'Change the free fields for this ticket' => 'Zmień pola dodatkowe tego zgłoszenia',
        'Change the priority for this ticket' => 'Zmień priorytet zgłoszenia',
        'Change the responsible person for this ticket' => 'Zmień osobę odpowiedzialną zgłoszenia',
        'Changed priority from "%s" (%s) to "%s" (%s).' => 'Zmieniono priorytet z "%s" (%s) na "%s" (%s).',
        'Changes the owner of tickets to everyone (useful for ASP). Normally only agent with rw permissions in the queue of the ticket will be shown.' =>
            'Zmienia właściciela zgłoszeń dla wszyscy (użyteczne dla ASP). Zwykle widoczny będzie tylko agent z prawami rw do kolejki.',
        'Checkbox' => 'Pole wyboru',
        'Checks the SystemID in ticket number detection for follow-ups (use "No" if SystemID has been changed after using the system).' =>
            '',
        'Closed tickets (customer user)' => '',
        'Closed tickets (customer)' => '',
        'Column ticket filters for Ticket Overviews type "Small".' => 'Kolumna filtrów zgłoszeń dla "małego" Podglądu Zgłoszeń.',
        'Columns that can be filtered in the escalation view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed.' =>
            '',
        'Columns that can be filtered in the locked view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed.' =>
            '',
        'Columns that can be filtered in the queue view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed.' =>
            '',
        'Columns that can be filtered in the responsible view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed.' =>
            '',
        'Columns that can be filtered in the service view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed.' =>
            '',
        'Columns that can be filtered in the status view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed.' =>
            '',
        'Columns that can be filtered in the ticket search result view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed.' =>
            '',
        'Columns that can be filtered in the watch view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed.' =>
            '',
        'Comment for new history entries in the customer interface.' => 'Komenntarz dla nowych wspisów historii w interfejsie klienta.',
        'Comment2' => '',
        'Company Status' => 'Status firmy',
        'Company Tickets' => 'Zgłoszenia firmowe',
        'Company name which will be included in outgoing emails as an X-Header.' =>
            'Nazwa firmy która zostanie dodana w nagłówku X-Header wychodzącej poczty e-mail.',
        'Configure Processes.' => 'Konfiguracja procesów.',
        'Configure and manage ACLs.' => 'Konfiguruj i zarządzaj ACLami.',
        'Configure your own log text for PGP.' => 'Skonfiguruj swój własny tekst-log dla PGP.',
        'Configures a default TicketDynamicField setting. "Name" defines the dynamic field which should be used, "Value" is the data that will be set, and "Event" defines the trigger event. Please check the developer manual (http://doc.otrs.org/), chapter "Ticket Event Module".' =>
            '',
        'Controls how to display the ticket history entries as readable values.' =>
            '',
        'Controls if customers have the ability to sort their tickets.' =>
            'Kontroluje czy klienci mają możliwość sortowania swoimi zgłoszeniami.',
        'Controls if more than one from entry can be set in the new phone ticket in the agent interface.' =>
            'Kontroluje czy więcej niż jedna pozycja może być zaznaczona przy zgłoszeniu telefonicznym w panelu agenta.',
        'Controls if the admin is allowed to import a saved system configuration in SysConfig.' =>
            '',
        'Controls if the admin is allowed to make changes to the database via AdminSelectBox.' =>
            '',
        'Controls if the ticket and article seen flags are removed when a ticket is archived.' =>
            'Kontroluje czy flagi zgłoszenia i artykułu są usunięte kiedy zgłoszenie jest zarchiwizowane.',
        'Converts HTML mails into text messages.' => 'Konwertuję e-maile HTML do tekstowych',
        'Create New process ticket' => 'Utwórz nowe zgłoszenie',
        'Create and manage Service Level Agreements (SLAs).' => 'Ustawienia poziomów SLA.',
        'Create and manage agents.' => 'Zarządzanie listą agentów.',
        'Create and manage attachments.' => 'Ustawienia standardowych załączników.',
        'Create and manage customer users.' => 'Zarządzanie kontami klienta.',
        'Create and manage customers.' => 'Zarządzanie listą klientów.',
        'Create and manage dynamic fields.' => 'Zarządzanie polami dynamicznymi.',
        'Create and manage event based notifications.' => 'Zarządzanie powiadomieniami wywoływanymi za pomocą zdarzeń.',
        'Create and manage groups.' => 'Ustawienia grup agentów.',
        'Create and manage queues.' => 'Ustawienia kolejek zgłoszeń.',
        'Create and manage responses that are automatically sent.' => 'Ustawienia szablonów odpowiedzi automatycznych.',
        'Create and manage roles.' => 'Zarządzanie rolami systemowymi.',
        'Create and manage salutations.' => 'Ustawienia szablonów powitań.',
        'Create and manage services.' => 'Zarządzanie usługami serwisowymi.',
        'Create and manage signatures.' => 'Ustawienia szablonów podpisów.',
        'Create and manage templates.' => 'Zarządzanie szablonami.',
        'Create and manage ticket priorities.' => 'Ustawianie priorytetów zgłoszeń.',
        'Create and manage ticket states.' => 'Ustawienia statusów zgłoszeń.',
        'Create and manage ticket types.' => 'Ustawienia typów zgłoszeń.',
        'Create and manage web services.' => 'Zarządzanie serwisami sieciowymi.',
        'Create new email ticket and send this out (outbound)' => 'Utwórz i wyślij nowe zgłoszenie e-mail (wychodzące)',
        'Create new phone ticket (inbound)' => 'Utwórz nowe zgłoszenie telefoniczne (przychodzące)',
        'Create new process ticket' => 'Utwórz nowe zgłoszenie',
        'Custom RSS Feed' => '',
        'Custom text for the page shown to customers that have no tickets yet (if you need those text translated add them to a custom translation module).' =>
            '',
        'Customer Administration' => '',
        'Customer User <-> Groups' => 'Użytkownicy Klienta <-> Grupy',
        'Customer User <-> Services' => 'Użytkownicy Klienta <-> Serwisy',
        'Customer User Administration' => 'Zarządzanie Kontami Klienta',
        'Customer Users' => 'Użytkownicy Klienta',
        'Customer called us.' => 'Klient telefonował do agenta.',
        'Customer item (icon) which shows the closed tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            '',
        'Customer item (icon) which shows the open tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            '',
        'Customer request via web.' => 'Żądanie klienta przez www.',
        'Customer user search' => '',
        'CustomerID search' => '',
        'CustomerName' => 'Nazwa klienta',
        'Customers <-> Groups' => 'Klienci <-> Grupy',
        'Data used to export the search result in CSV format.' => 'Dane używane przy eksporcie wyników wyszukiwania do formatu CSV.',
        'Date / Time' => 'Data / Czas',
        'Debugs the translation set. If this is set to "Yes" all strings (text) without translations are written to STDERR. This can be helpful when you are creating a new translation file. Otherwise, this option should remain set to "No".' =>
            '',
        'Default ACL values for ticket actions.' => 'Domyślne wartości ACL dla zgłoszeń.',
        'Default ProcessManagement entity prefixes for entity IDs that are automatically generated.' =>
            '',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimePointFormat=year;TicketCreateTimePointStart=Last;TicketCreateTimePoint=2;".' =>
            '',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimeStartYear=2010;TicketCreateTimeStartMonth=10;TicketCreateTimeStartDay=4;TicketCreateTimeStopYear=2010;TicketCreateTimeStopMonth=11;TicketCreateTimeStopDay=3;".' =>
            '',
        'Default loop protection module.' => 'Domyślny moduł pętli ochronnej',
        'Default queue ID used by the system in the agent interface.' => 'Domyślne ID kolejki uzywane przez system w interfejsie agenta.',
        'Default skin for OTRS 3.0 interface.' => 'Domyślna skóra dla interfejsu OTRS 3.0.',
        'Default skin for the agent interface (slim version).' => 'Domyślna skóra dla interfejsu agentów (wersja odchudzona).',
        'Default skin for the agent interface.' => 'Domyślna skóra dla interfejsu agentów.',
        'Default ticket ID used by the system in the agent interface.' =>
            'Domyślne ID zgłoszenia używane przez system w interfejsie agenta.',
        'Default ticket ID used by the system in the customer interface.' =>
            'Domyślne ID zgłoszenia używane przez system w interfejsie klienta.',
        'Default value for NameX' => 'Domyślna wartość dla NazwyX',
        'Define a filter for html output to add links behind a defined string. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            '',
        'Define a mapping between variables of the customer user data (keys) and dynamic fields of a ticket (values). The purpose is to store customer user data in ticket dynamic fields. The dynamic fields must be present in the system and should be enabled for AgentTicketFreeText, so that they can be set/updated manually by the agent. They mustn\'t be enabled for AgentTicketPhone, AgentTicketEmail and AgentTicketCustomer. If they were, they would have precedence over the automatically set values. To use this mapping, you have to also activate the next setting below.' =>
            '',
        'Define dynamic field name for end time. This field has to be manually added to the system as Ticket: "Date / Time" and must be activated in ticket creation screens and/or in any other ticket action screens.' =>
            '',
        'Define dynamic field name for start time. This field has to be manually added to the system as Ticket: "Date / Time" and must be activated in ticket creation screens and/or in any other ticket action screens.' =>
            '',
        'Define the max depth of queues.' => 'Zdefiniuj maksymalną głębokość kolejek.',
        'Define the queue comment 2.' => '',
        'Define the service comment 2.' => '',
        'Define the sla comment 2.' => '',
        'Define the start day of the week for the date picker for the indicated calendar.' =>
            '',
        'Define the start day of the week for the date picker.' => '',
        'Defines a customer item, which generates a LinkedIn icon at the end of a customer info block.' =>
            'Definiuje pozycję, która generuje ikonę LinkedIn na końcu bloku informacyjnego klienta.',
        'Defines a customer item, which generates a XING icon at the end of a customer info block.' =>
            'Definiuje pozycję, która generuje ikonę XING na końcu bloku informacyjnego klienta.',
        'Defines a customer item, which generates a google icon at the end of a customer info block.' =>
            'Definiuje pozycję, która generuje ikonę google na końcu bloku informacyjnego klienta.',
        'Defines a customer item, which generates a google maps icon at the end of a customer info block.' =>
            'Definiuje pozycję, która generuje ikonę google maps na końcu bloku informacyjnego klienta.',
        'Defines a default list of words, that are ignored by the spell checker.' =>
            'Definiuje domyślną listę słów, kóre są ignorowane przez słownik ortograficzny.',
        'Defines a filter for html output to add links behind CVE numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            '',
        'Defines a filter for html output to add links behind MSBulletin numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            '',
        'Defines a filter for html output to add links behind a defined string. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            '',
        'Defines a filter for html output to add links behind bugtraq numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            '',
        'Defines a filter to process the text in the articles, in order to highlight predefined keywords.' =>
            '',
        'Defines a regular expression that excludes some addresses from the syntax check (if "CheckEmailAddresses" is set to "Yes"). Please enter a regex in this field for email addresses, that aren\'t syntactically valid, but are necessary for the system (i.e. "root@localhost").' =>
            '',
        'Defines a regular expression that filters all email addresses that should not be used in the application.' =>
            '',
        'Defines a useful module to load specific user options or to display news.' =>
            '',
        'Defines all the X-headers that should be scanned.' => 'Definiuje nagłówki-X które powinny zostać zeskanowane.',
        'Defines all the languages that are available to the application. The Key/Content pair links the front-end display name to the appropriate language PM file. The "Key" value should be the base-name of the PM file (i.e. de.pm is the file, then de is the "Key" value). The "Content" value should be the display name for the front-end. Specify any own-defined language here (see the developer documentation http://doc.otrs.org/ for more infomation). Please remember to use the HTML equivalents for non-ASCII characters (i.e. for the German oe = o umlaut, it is necessary to use the &ouml; symbol).' =>
            '',
        'Defines all the parameters for the RefreshTime object in the customer preferences of the customer interface.' =>
            'Definiuje wszystkie parametry dla pozycji OdświeżCzas (RefreshTime) w preferencjach klienta interfejsu klienta.',
        'Defines all the parameters for the ShownTickets object in the customer preferences of the customer interface.' =>
            'Definiuje wszystkie parametry dla objektów PokażZgłoszenia (ShownTickets) w preferencjach klienta interfejsu klienta.',
        'Defines all the parameters for this item in the customer preferences.' =>
            'Definiuje wszystkie parametry dla tej pozycji w preferencjach klienta.',
        'Defines all the possible stats output formats.' => 'Definiuje wszystkie możliwe formaty użyskiwania statystyk.',
        'Defines an alternate URL, where the login link refers to.' => 'Definiuje alternatywną ścieżkę dla linku logowania.',
        'Defines an alternate URL, where the logout link refers to.' => 'Definiuje alternatywną ścieżkę dla linku wylogowywania.',
        'Defines an alternate login URL for the customer panel..' => 'Definiuje alternatywną ścieżkę logowania w panelu klienta.',
        'Defines an alternate logout URL for the customer panel.' => 'Definiuje alternatywną ścieżkę wylogowywania w panelu klienta.',
        'Defines an external link to the database of the customer (e.g. \'http://yourhost/customer.php?CID=[% Data.CustomerID %]\' or \'\').' =>
            '',
        'Defines from which ticket attributes the agent can select the result order.' =>
            'Definiuje wśród których atrybutów agent może wybrać kolejność wyszukiwania.',
        'Defines how the From field from the emails (sent from answers and email tickets) should look like.' =>
            'Definiuje jak powinno wyglądac pole Od w e-mailach (wysłane z odpowiedzi i zgłoszeń e-mail)',
        'Defines if a pre-sorting by priority should be done in the queue view.' =>
            '',
        'Defines if a pre-sorting by priority should be done in the service view.' =>
            '',
        'Defines if a ticket lock is required in the close ticket screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the email outbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket bounce screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket compose screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket forward screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket free text screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket merge screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket note screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket owner screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket pending screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket phone inbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket phone outbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket priority screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket responsible screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required to change the customer of a ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if composed messages have to be spell checked in the agent interface.' =>
            'Definiuje czy musi być sprawdzona ortografia w nowo tworzonej wiadomości interfejsu agenta.',
        'Defines if the enhanced mode should be used (enables use of table, replace, subscript, superscript, paste from word, etc.).' =>
            '',
        'Defines if the list for filters should be retrieve just from current tickets in system. Just for clarification, Customers list will always came from system\'s tickets.' =>
            '',
        'Defines if time accounting is mandatory in the agent interface. If activated, a note must be entered for all ticket actions (no matter if the note itself is configured as active or is originally mandatory for the individual ticket action screen).' =>
            '',
        'Defines if time accounting must be set to all tickets in bulk action.' =>
            'Definiuje czy rozliczanie czasu musi byc ustawione dla wszystkich zebranych zgłoszeń',
        'Defines queues that\'s tickets are used for displaying as calendar events.' =>
            'Definiuje kolejki których zgłoszenia są użyte do wyświetlenia jako wydarzenia kalendarzowe.',
        'Defines scheduler PID update time in seconds.' => '',
        'Defines scheduler sleep time in seconds after processing all available tasks (floating point number).' =>
            '',
        'Defines the IP regular expression for accessing the local repository. You need to enable this to have access to your local repository and the package::RepositoryList is required on the remote host.' =>
            '',
        'Defines the URL CSS path.' => 'Definiuje ścieżkę dla CSS',
        'Defines the URL base path of icons, CSS and Java Script.' => 'Definiuje ścieżkę dla ikon, CSS i skryptów Java.',
        'Defines the URL image path of icons for navigation.' => 'Definiuje ścieżkę dla ikon nawigacyjnych.',
        'Defines the URL java script path.' => 'Definiuje ścieżkę dla skryptów java.',
        'Defines the URL rich text editor path.' => 'Definiuję scieżkę dla edytora tekstu.',
        'Defines the address of a dedicated DNS server, if necessary, for the "CheckMXRecord" look-ups.' =>
            '',
        'Defines the body text for notification mails sent to agents, about new password (after using this link the new password will be sent).' =>
            'Definiuje treść wiadomości dla powiadomień mailowych wysyłanych do agentów o nowym haśle (po użyciu tego linku nowe hasło zostanie wysłane).',
        'Defines the body text for notification mails sent to agents, with token about new requested password (after using this link the new password will be sent).' =>
            'Definiuje treść wiadomości dla powiadomień mailowych z tokenem wysyłanych do agentów o nowo tworzonym haśle (po użyciu tego linku nowe hasło zostanie wysłane).',
        'Defines the body text for notification mails sent to customers, about new account.' =>
            'Definiuje treść wiadomości dla powiadomień mailowych wysyłanych do klientów o nowo tworzonym haśle.',
        'Defines the body text for notification mails sent to customers, about new password (after using this link the new password will be sent).' =>
            'Definiuje treść wiadomości dla powiadomień mailowych wysyłanych do klientów o nowo tworzonym haśle (po użyciu tego linku nowe hasło zostanie wysłane).',
        'Defines the body text for notification mails sent to customers, with token about new requested password (after using this link the new password will be sent).' =>
            'Definiuje treść wiadomości dla powiadomień mailowych z tokenem wysyłanych do klientów o nowo tworzonym haśle (po użyciu tego linku nowe hasło zostanie wysłane).',
        'Defines the body text for rejected emails.' => 'Definiuje treść wiadomości dla odrzucowych e-maili.',
        'Defines the boldness of the line drawed by the graph.' => 'Definiuje grubość linii rysowanych przez wykres.',
        'Defines the calendar width in percent. Default is 95%.' => 'Definiuje szerokość kalendarza. Domyślnie 95%.',
        'Defines the colors for the graphs.' => 'Definiuje kolory dla wykresów.',
        'Defines the column to store the keys for the preferences table.' =>
            'Definiuje kolumny przechowujące klucze w preferencjach tabeli.',
        'Defines the config options for the autocompletion feature.' => 'Definiuje opcje konfiguracyjne dla fukcji autouzupełnienia.',
        'Defines the config parameters of this item, to be shown in the preferences view.' =>
            'Definiuje parametry konfiguracyjne dla tej pozycji do ukazania w widoku preferencji.',
        'Defines the config parameters of this item, to be shown in the preferences view. Take care to maintain the dictionaries installed in the system in the data section.' =>
            '',
        'Defines the connections for http/ftp, via a proxy.' => 'Definiuje połączenia dla http/ftp poprzez proxy.',
        'Defines the date input format used in forms (option or input fields).' =>
            'Definiuje format daty używanej w formularzach (opcja lub pole wstawienia).',
        'Defines the default CSS used in rich text editors.' => 'Definiuje domyślny CSS używany w edytorach tekstu.',
        'Defines the default auto response type of the article for this operation.' =>
            'Definiuje rodzaj odpowiedzi automatycznej artykułu dla tej operacji.',
        'Defines the default body of a note in the ticket free text screen of the agent interface.' =>
            'Definiuje domyślną zawartość notatki w oknie tekstu interfejsu agenta.',
        'Defines the default front-end (HTML) theme to be used by the agents and customers. If you like, you can add your own theme. Please refer the administrator manual located at http://doc.otrs.org/.' =>
            'Definiuje domyślny wygląd (HTML) do użycia przez agentów i klientów. Jeśli chcesz możesz dodać swój własny. Proszę skorzystać z opidu dostepnego na http://doc.otrs.org/.',
        'Defines the default front-end language. All the possible values are determined by the available language files on the system (see the next setting).' =>
            'Definiuje domyślny język interfejsu. Wszystkie możliwe wartości są określone przez dostępne pliki językowe w systemie (patz kolejne ustawienie).',
        'Defines the default history type in the customer interface.' => 'Definiuje domyślny rodzaj historii w interfejsie klienta.',
        'Defines the default maximum number of X-axis attributes for the time scale.' =>
            '',
        'Defines the default maximum number of search results shown on the overview page.' =>
            'Definiuje maksymalną ilość rezultatów wyszukiwania do przeglądnięcia.',
        'Defines the default next state for a ticket after customer follow up in the customer interface.' =>
            'Definiuje domyślny status zgłoszenia po tym jak klient dokonał na niego odpowiedzi w panelu użytkownika.',
        'Defines the default next state of a ticket after adding a note, in the close ticket screen of the agent interface.' =>
            'Definiuje domyślny status zgłoszenia po dodaniu notatki w oknie zakmniętego zgłoszenia panelu agenta.',
        'Defines the default next state of a ticket after adding a note, in the ticket bulk screen of the agent interface.' =>
            'Definiuje domyślny status zgłoszenia po dodaniu notatki w oknie zbiorczym zgłoszenia panelu agenta.',
        'Defines the default next state of a ticket after adding a note, in the ticket free text screen of the agent interface.' =>
            'Definiuje domyślny status zgłoszenia po dodaniu notatki w oknie tekstowym zgłoszenia panelu agenta.',
        'Defines the default next state of a ticket after adding a note, in the ticket note screen of the agent interface.' =>
            'Definiuje domyślny status zgłoszenia po dodaniu notatki w oknie notatki zgłoszenia panelu agenta.',
        'Defines the default next state of a ticket after adding a note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Definiuje domyślny status zgłoszenia po dodaniu notatki w przybliżonym oknie właściciela zgłoszenia w panelu agenta.',
        'Defines the default next state of a ticket after adding a note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Definiuje domyślny status zgłoszenia po dodaniu notatki w przybliżonym oknie oczekującego zgłoszenia w panelu agenta.',
        'Defines the default next state of a ticket after adding a note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Definiuje domyślny status zgłoszenia po dodaniu notatki w przybliżonym oknie priorytetu zgłoszenia w panelu agenta.',
        'Defines the default next state of a ticket after adding a note, in the ticket responsible screen of the agent interface.' =>
            'Definiuje domyślny status zgłoszenia po dodaniu notatki w przybliżonym oknie odpowiedzialnego za zgłoszenie w panelu agenta.',
        'Defines the default next state of a ticket after being bounced, in the ticket bounce screen of the agent interface.' =>
            '',
        'Defines the default next state of a ticket after being forwarded, in the ticket forward screen of the agent interface.' =>
            '',
        'Defines the default next state of a ticket after the message has been sent, in the email outbound screen of the agent interface.' =>
            '',
        'Defines the default next state of a ticket if it is composed / answered in the ticket compose screen of the agent interface.' =>
            '',
        'Defines the default note body text for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Defines the default note body text for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            '',
        'Defines the default priority of follow up customer tickets in the ticket zoom screen in the customer interface.' =>
            '',
        'Defines the default priority of new customer tickets in the customer interface.' =>
            'Definiuje domyślny priorytet nowych zgłoszeń klienta w interfejsie klienta.',
        'Defines the default priority of new tickets.' => 'Definiuje priorytet dla nowych zgłoszeń.',
        'Defines the default queue for new customer tickets in the customer interface.' =>
            'Definiuje domyślną kolejkę dla zgłoszeń klienta w interefejsie klienta.',
        'Defines the default selection at the drop down menu for dynamic objects (Form: Common Specification).' =>
            'Definiuje domyślny wybór w menu wyboru dla objeków dynamicznych (Forma: Zwykła specyfikacja).',
        'Defines the default selection at the drop down menu for permissions (Form: Common Specification).' =>
            'Definiuje domyślny wybór w menu wyboru dlauprawnień (Forma: Zwykła specyfikacja).',
        'Defines the default selection at the drop down menu for stats format (Form: Common Specification). Please insert the format key (see Stats::Format).' =>
            'Definiuje domyślny wybór w menu wyboru dla formatu statystyk (Forma: Zwykła specyfikacja). Proszę wprowadź klucz formatu (patrz Stats::Format).',
        'Defines the default sender type for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            'Definiuje domyślnego wysyłającego dla zgłoszeń w oknie przychodzących zgłoszeń telefonicznych interfejsu agenta.',
        'Defines the default sender type for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            'Definiuje domyślnego wysyłającego dla zgłoszeń w oknie wychodzących zgłoszeń telefonicznych interfejsu agenta.',
        'Defines the default sender type for tickets in the ticket zoom screen of the customer interface.' =>
            'Definiuje domyślnego wysyłającego dla zgłoszeń w oknie przybliżonych zgłoszeń interfejsu klienta.',
        'Defines the default shown ticket search attribute for ticket search screen.' =>
            'Definiuje domyślne atrybuty wyszukiwania zgłoszeń dla okna wyszukiwania.',
        'Defines the default shown ticket search attribute for ticket search screen. Example: "Key" must have the name of the Dynamic Field in this case \'X\', "Content" must have the value of the Dynamic Field depending on the Dynamic Field type,  Text: \'a text\', Dropdown: \'1\', Date/Time: \'Search_DynamicField_XTimeSlotStartYear=1974; Search_DynamicField_XTimeSlotStartMonth=01; Search_DynamicField_XTimeSlotStartDay=26; Search_DynamicField_XTimeSlotStartHour=00; Search_DynamicField_XTimeSlotStartMinute=00; Search_DynamicField_XTimeSlotStartSecond=00; Search_DynamicField_XTimeSlotStopYear=2013; Search_DynamicField_XTimeSlotStopMonth=01; Search_DynamicField_XTimeSlotStopDay=26; Search_DynamicField_XTimeSlotStopHour=23; Search_DynamicField_XTimeSlotStopMinute=59; Search_DynamicField_XTimeSlotStopSecond=59;\' and or \'Search_DynamicField_XTimePointFormat=week; Search_DynamicField_XTimePointStart=Before; Search_DynamicField_XTimePointValue=7\';.' =>
            '',
        'Defines the default sort criteria for all queues displayed in the queue view.' =>
            'Definiuje domyślne kryteria dla wszystkich kolejek ukazanych w widoku kolejki.',
        'Defines the default sort criteria for all services displayed in the service view.' =>
            '',
        'Defines the default sort order for all queues in the queue view, after priority sort.' =>
            'Definiuje domyślne kryteria dla wszystkich kolejek posortowanych priorytetem w widoku kolejki.',
        'Defines the default sort order for all services in the service view, after priority sort.' =>
            '',
        'Defines the default spell checker dictionary.' => 'Definiuje domyślny słownik poprawności pisowni.',
        'Defines the default state of new customer tickets in the customer interface.' =>
            'Definiuje domyślny stan nowych zgłoszeń klienta w interfejsie klienta.',
        'Defines the default state of new tickets.' => 'Definiuje domyślny status nowych zgłoszeń.',
        'Defines the default subject for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            'Definiuje domyślny tytuł dla zgłoszeń telefonicznych w oknie przychodzących zgłoszeń telefonicznych interfejsu agenta.',
        'Defines the default subject for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            'Definiuje domyślny tytuł dla zgłoszeń telefonicznych w oknie wychodzących zgłoszeń telefonicznych interfejsu agenta.',
        'Defines the default subject of a note in the ticket free text screen of the agent interface.' =>
            'Definiuje domyślny tytuł notatki w oknie tekstowym interfejsu agenta.',
        'Defines the default ticket attribute for ticket sorting in a ticket search of the customer interface.' =>
            'Definiuje domyślny atrybut zgłoszenia dla sortowania zgłoszeń przy wyszukiwaniu zgłoszeń interfejsu klienta.',
        'Defines the default ticket attribute for ticket sorting in the escalation view of the agent interface.' =>
            'Definiuje domyślny atrybut zgłoszenia dla sortowania zgłoszeń w widoku eskalacji interfejsu agenta.',
        'Defines the default ticket attribute for ticket sorting in the locked ticket view of the agent interface.' =>
            'Definiuje domyślny atrybut zgłoszenia dla sortowania zgłoszeń w widoku zablokowanych zgłoszeń interfejsu agenta.',
        'Defines the default ticket attribute for ticket sorting in the responsible view of the agent interface.' =>
            'Definiuje domyślny atrybut zgłoszenia dla sortowania zgłoszeń w widoku odpowiedzialnych za zgłoszenie interfejsu agenta.',
        'Defines the default ticket attribute for ticket sorting in the status view of the agent interface.' =>
            'Definiuje domyślny atrybut zgłoszenia dla sortowania zgłoszeń w widoku stanu interfejsu agenta.',
        'Defines the default ticket attribute for ticket sorting in the watch view of the agent interface.' =>
            'Definiuje domyślny atrybut zgłoszenia dla sortowania zgłoszeń w widoku obserwowanych interfejsu agenta.',
        'Defines the default ticket attribute for ticket sorting of the ticket search result of the agent interface.' =>
            'Definiuje domyślny atrybut zgłoszenia dla sortowania zgłoszeń w widoku wyników wyszukiwania interfejsu agenta.',
        'Defines the default ticket attribute for ticket sorting of the ticket search result of this operation.' =>
            '',
        'Defines the default ticket bounced notification for customer/sender in the ticket bounce screen of the agent interface.' =>
            'Definiuje domyślne powiadomienie o odbitych zgłoszeniach klienta/nadawcy w oknie odbitych interfejsu agenta.',
        'Defines the default ticket next state after adding a phone note in the ticket phone inbound screen of the agent interface.' =>
            'Definiuje domyślny kolejny stan po dodaniu notatki telefonicznej w przychodzących zgłoszeniach telefonicznych interfejsu agenta.',
        'Defines the default ticket next state after adding a phone note in the ticket phone outbound screen of the agent interface.' =>
            'Definiuje domyślny kolejny stan po dodaniu notatki telefonicznej w wychodzących zgłoszeniach telefonicznych interfejsu agenta.',
        'Defines the default ticket order (after priority sort) in the escalation view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Definiuje domyślną kolejność (po sortowaniu priorytetem) w widoku eskalacji zgłoszeń interfejsu agenta. Góra: Najstarze na górze. Dół: Najnowsze na górze.',
        'Defines the default ticket order (after priority sort) in the status view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Definiuje domyślną kolejność (po sortowaniu priorytetem) w widoku stanu zgłoszeń interfejsu agenta. Góra: Najstarze na górze. Dół: Najnowsze na górze.',
        'Defines the default ticket order in the responsible view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Definiuje domyślną kolejność w widoku odpowiedzialnego za zgłoszenie interfejsu agenta. Góra: Najstarze na górze. Dół: Najnowsze na górze.',
        'Defines the default ticket order in the ticket locked view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Definiuje domyślną kolejność w widoku zablokowanych zgłoszeń interfejsu agenta. Góra: Najstarze na górze. Dół: Najnowsze na górze.',
        'Defines the default ticket order in the ticket search result of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Definiuje domyślną kolejność w widoku rezultatów wyszukiwania zgłoszeń interfejsu agenta. Góra: Najstarze na górze. Dół: Najnowsze na górze.',
        'Defines the default ticket order in the ticket search result of the this operation. Up: oldest on top. Down: latest on top.' =>
            '',
        'Defines the default ticket order in the watch view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Definiuje domyślną kolejność w widoku obserowanych zgłoszeń interfejsu agenta. Góra: Najstarze na górze. Dół: Najnowsze na górze.',
        'Defines the default ticket order of a search result in the customer interface. Up: oldest on top. Down: latest on top.' =>
            'Definiuje domyślną kolejność w wynikach wyszukiwania interfejsu klienta. Góra: Najstarze na górze. Dół: Najnowsze na górze.',
        'Defines the default ticket priority in the close ticket screen of the agent interface.' =>
            'Definiuje domyślny priorytet w oknie zakmniętych zgłoszeń interfejsu agenta.',
        'Defines the default ticket priority in the ticket bulk screen of the agent interface.' =>
            'Definiuje domyślny priorytet w oknie zbiorczym zgłoszeń interfejsu agenta.',
        'Defines the default ticket priority in the ticket free text screen of the agent interface.' =>
            'Definiuje domyślny priorytet w oknie tekstowym zgłoszeń interfejsu agenta.',
        'Defines the default ticket priority in the ticket note screen of the agent interface.' =>
            'Definiuje domyślny priorytet w oknie notatek interfejsu agenta.',
        'Defines the default ticket priority in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Definiuje domyślny priorytet w oknie właściciela przybliżonego zgłoszenia w interfejsie agenta.',
        'Defines the default ticket priority in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Definiuje domyślny priorytet w oknie oczekującego przybliżonego zgłoszenia w interfejsie agenta.',
        'Defines the default ticket priority in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Definiuje domyślny priorytet w oknie priorytetu przybliżonego zgłoszenia w interfejsie agenta.',
        'Defines the default ticket priority in the ticket responsible screen of the agent interface.' =>
            'Definiuje domyślny priorytet w oknie odpowiedzialnego za przybliżone zgłoszenie interfejsu agenta.',
        'Defines the default ticket type for new customer tickets in the customer interface.' =>
            'Definiuje domyślny rodzaj zgłoszenia dla nowych zgłoszeń interfejsie klienta.',
        'Defines the default type for article in the customer interface.' =>
            'Definiuje domyślny rodzaj artykułów w interfejsie klienta.',
        'Defines the default type of forwarded message in the ticket forward screen of the agent interface.' =>
            'Definiuje domyślny rodzaj przesłanej dalej wiadomości w oknie przesłanych zgłoszeń interfejsu agenta.',
        'Defines the default type of the article for this operation.' => 'Definiuje domyślny rodzaj artykułu dla tej operacji.',
        'Defines the default type of the message in the email outbound screen of the agent interface.' =>
            '',
        'Defines the default type of the note in the close ticket screen of the agent interface.' =>
            'Definiuje domyślny typ notatek w oknie zakmnięcia zgłoszeń interfejsu agenta.',
        'Defines the default type of the note in the ticket bulk screen of the agent interface.' =>
            'Definiuje domyślny typ notatek w oknie zbiorczym zgłoszeń interfejsu agenta.',
        'Defines the default type of the note in the ticket free text screen of the agent interface.' =>
            'Definiuje domyślny typ notatek w oknie tekstowym zgłoszeń interfejsu agenta.',
        'Defines the default type of the note in the ticket note screen of the agent interface.' =>
            'Definiuje domyślny typ notatek w oknie notatek zgłoszeń interfejsu agenta.',
        'Defines the default type of the note in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Definiuje domyślny typ notatek w oknie właściciela przybliżonych zgłoszeń w interfejsie agenta.',
        'Defines the default type of the note in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Definiuje domyślny typ notatek w oknie oczekujących przybliżonych zgłoszeń w interfejsie agenta.',
        'Defines the default type of the note in the ticket phone inbound screen of the agent interface.' =>
            'Definiuje domyślny typ notatek w oknie zgłoszeń odebranych rozmów telefonicznych interfejsu agenta.',
        'Defines the default type of the note in the ticket phone outbound screen of the agent interface.' =>
            'Definiuje domyślny typ notatek w oknie zgłoszeń wykonanych rozmów telefonicznych interfejsu agenta.',
        'Defines the default type of the note in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Definiuje domyślny typ notatek w oknie priorytetu przybliżonych zgłoszeń w interfejsie agenta.',
        'Defines the default type of the note in the ticket responsible screen of the agent interface.' =>
            'Definiuje domyślny typ notatek w oknie odpowiedzialnego w zgłoszeniach interfejsu agenta.',
        'Defines the default type of the note in the ticket zoom screen of the customer interface.' =>
            'Definiuje domyślny typ notatek w oknie przybliżonych zgłoszeń interfejsu klienta.',
        'Defines the default used Frontend-Module if no Action parameter given in the url on the agent interface.' =>
            '',
        'Defines the default used Frontend-Module if no Action parameter given in the url on the customer interface.' =>
            '',
        'Defines the default value for the action parameter for the public frontend. The action parameter is used in the scripts of the system.' =>
            '',
        'Defines the default viewable sender types of a ticket (default: customer).' =>
            'Definiuje domyślne widoczne typy wysyłających zgłoszenie (domyślny: klient).',
        'Defines the dynamic fields that are used for displaying on calendar events.' =>
            'Definiuje domyślne pola dynamiczne, które są użyte do wyświetlenia zdarzeń kalendarzowych.',
        'Defines the filter that processes the text in the articles, in order to highlight URLs.' =>
            'Definiuje filtr procesujący tekst w artykułach służący wyróżnieniu URLi.',
        'Defines the format of responses in the ticket compose screen of the agent interface ([% Data.OrigFrom | html %] is From 1:1, [% Data.OrigFromName | html %] is only realname of From).' =>
            '',
        'Defines the fully qualified domain name of the system. This setting is used as a variable, OTRS_CONFIG_FQDN which is found in all forms of messaging used by the application, to build links to the tickets within your system.' =>
            '',
        'Defines the groups every customer user will be in (if CustomerGroupSupport is enabled and you don\'t want to manage every user for these groups).' =>
            '',
        'Defines the height for the rich text editor component for this screen. Enter number (pixels) or percent value (relative).' =>
            '',
        'Defines the height for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            '',
        'Defines the height of the legend.' => 'Definiuje wysokość legendy.',
        'Defines the history comment for the close ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Definiuje historię komentarza dla okna akcji zamknięcia zgłoszenia, które jest użyte w historii zgłoszeń w interfejsie agenta.',
        'Defines the history comment for the email ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Definiuje historię komentarza dla okna akcji zgłoszenia e-mail, które jest użyte w historii zgłoszeń w interfejsie agenta.',
        'Defines the history comment for the phone ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Definiuje historię komentarza dla okna akcji telefonicznego zgłoszenia, które jest użyte w historii zgłoszeń w interfejsie agenta.',
        'Defines the history comment for the ticket free text screen action, which gets used for ticket history.' =>
            'Definiuje historię komentarza dla okna akcji tekstu zgłoszenia, które jest użyte w historii zgłoszenia.',
        'Defines the history comment for the ticket note screen action, which gets used for ticket history in the agent interface.' =>
            'Definiuje historię komentarza dla okna akcji notatki zgłoszenia, które jest użyte w historii zgłoszeń w interfejsie agenta.',
        'Defines the history comment for the ticket owner screen action, which gets used for ticket history in the agent interface.' =>
            'Definiuje historię komentarza dla okna akcji właściciela zgłoszenia, które jest użyte w historii zgłoszeń w interfejsie agenta.',
        'Defines the history comment for the ticket pending screen action, which gets used for ticket history in the agent interface.' =>
            'Definiuje historię komentarza dla okna akcji oczekującego zgłoszenia, które jest użyte w historii zgłoszeń w interfejsie agenta.',
        'Defines the history comment for the ticket phone inbound screen action, which gets used for ticket history in the agent interface.' =>
            'Definiuje historię komentarza dla okna akcji przychodzącego zgłoszenia telefonicznego, które jest użyte w historii zgłoszeń w interfejsie agenta.',
        'Defines the history comment for the ticket phone outbound screen action, which gets used for ticket history in the agent interface.' =>
            'Definiuje historię komentarza dla okna akcji wychodzącego zgłoszenia telefonicznego, które jest użyte w historii zgłoszeń w interfejsie agenta.',
        'Defines the history comment for the ticket priority screen action, which gets used for ticket history in the agent interface.' =>
            'Definiuje historię komentarza dla okna akcji priorytetu zgłoszenia, które jest użyte w historii zgłoszeń w interfejsie agenta.',
        'Defines the history comment for the ticket responsible screen action, which gets used for ticket history in the agent interface.' =>
            'Definiuje historię komentarza dla okna akcji odpowiedzialnego za zgłoszenie, które jest użyte w historii zgłoszeń w interfejsie agenta.',
        'Defines the history comment for the ticket zoom action, which gets used for ticket history in the customer interface.' =>
            'Definiuje historię komentarza dla okna akcji przybliżenia zgłoszenia, które jest użyte w historii zgłoszeń w interfejsie klienta.',
        'Defines the history comment for this operation, which gets used for ticket history in the agent interface.' =>
            'Definiuje historię komentarza dla tej operacji, która jest użyta w historii zgłoszeń w interfejsie agenta.',
        'Defines the history type for the close ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Definiuje rodzaj historii dla okna akcji zamkniętego zgłoszenia, która jest użyta w historii zgłoszeń w interfejsie agenta.',
        'Defines the history type for the email ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Definiuje rodzaj historii dla okna akcji zgłoszenia e-mail, która jest użyta w historii zgłoszeń w interfejsie agenta.',
        'Defines the history type for the phone ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Definiuje rodzaj historii dla okna akcji zgłoszenia telefonicznego, która jest użyta w historii zgłoszeń w interfejsie agenta.',
        'Defines the history type for the ticket free text screen action, which gets used for ticket history.' =>
            'Definiuje rodzaj historii dla okna akcji zamkniętego zgłoszenia, która jest użyta w historii zgłoszeń.',
        'Defines the history type for the ticket note screen action, which gets used for ticket history in the agent interface.' =>
            'Definiuje rodzaj historii dla okna akcji notatek zgłoszenia, która jest użyta w historii zgłoszeń w interfejsie agenta.',
        'Defines the history type for the ticket owner screen action, which gets used for ticket history in the agent interface.' =>
            'Definiuje rodzaj historii dla okna akcji właściciela zgłoszenia, która jest użyta w historii zgłoszeń w interfejsie agenta.',
        'Defines the history type for the ticket pending screen action, which gets used for ticket history in the agent interface.' =>
            'Definiuje rodzaj historii dla okna akcji oczekującego zgłoszenia, która jest użyta w historii zgłoszeń w interfejsie agenta.',
        'Defines the history type for the ticket phone inbound screen action, which gets used for ticket history in the agent interface.' =>
            'Definiuje rodzaj historii dla okna akcji przychodzącego zgłoszenia telefonicznego, która jest użyta w historii zgłoszeń w interfejsie agenta.',
        'Defines the history type for the ticket phone outbound screen action, which gets used for ticket history in the agent interface.' =>
            'Definiuje rodzaj historii dla okna akcji wychodzącego zgłoszenia telefonicznego, która jest użyta w historii zgłoszeń w interfejsie agenta.',
        'Defines the history type for the ticket priority screen action, which gets used for ticket history in the agent interface.' =>
            'Definiuje rodzaj historii dla okna akcji priorytetu zgłoszenia, która jest użyta w historii zgłoszeń w interfejsie agenta.',
        'Defines the history type for the ticket responsible screen action, which gets used for ticket history in the agent interface.' =>
            'Definiuje rodzaj historii dla okna akcji odpowiedzialnego za zgłoszenie, która jest użyta w historii zgłoszeń w interfejsie agenta.',
        'Defines the history type for the ticket zoom action, which gets used for ticket history in the customer interface.' =>
            'Definiuje rodzaj historii dla okna akcji przybliżenia zgłoszenia, która jest użyta w historii zgłoszeń w interfejsie klienta.',
        'Defines the history type for this operation, which gets used for ticket history in the agent interface.' =>
            'Definiuje rodzaj historii dla tej operacji, która jest użyta w historii zgłoszeń w interfejsie klienta.',
        'Defines the hours and week days of the indicated calendar, to count the working time.' =>
            'Definiuje godziny oraz dni wskazanego kalendarza do przeliczenia czasu pracy.',
        'Defines the hours and week days to count the working time.' => 'Definiuje godziny oraz dni do przeliczenia czasu pracy.',
        'Defines the key to be checked with Kernel::Modules::AgentInfo module. If this user preferences key is true, the message is accepted by the system.' =>
            '',
        'Defines the key to check with CustomerAccept. If this user preferences key is true, then the message is accepted by the system.' =>
            '',
        'Defines the legend font in graphs (place custom fonts in var/fonts).' =>
            '',
        'Defines the link type \'Normal\'. If the source name and the target name contain the same value, the resulting link is a non-directional one; otherwise, the result is a directional link.' =>
            '',
        'Defines the link type \'ParentChild\'. If the source name and the target name contain the same value, the resulting link is a non-directional one; otherwise, the result is a directional link.' =>
            '',
        'Defines the link type groups. The link types of the same group cancel one another. Example: If ticket A is linked per a \'Normal\' link with ticket B, then these tickets could not be additionally linked with link of a \'ParentChild\' relationship.' =>
            '',
        'Defines the list of online repositories. Another installations can be used as repository, for example: Key="http://example.com/otrs/public.pl?Action=PublicRepository;File=" and Content="Some Name".' =>
            '',
        'Defines the list of possible next actions on an error screen.' =>
            'Definiuje listę kolejnych możliwych akcji w oknie błędu.',
        'Defines the list of types for templates.' => 'Definiuje listę rodzajów szablonów.',
        'Defines the location to get online repository list for additional packages. The first available result will be used.' =>
            'Definiuje likalizację repozytorium dla kolejnych pakietów. Użyty zostanie pierwszy dostępny wynik.',
        'Defines the log module for the system. "File" writes all messages in a given logfile, "SysLog" uses the syslog daemon of the system, e.g. syslogd.' =>
            '',
        'Defines the maximal size (in bytes) for file uploads via the browser. Warning: Setting this option to a value which is too low could cause many masks in your OTRS instance to stop working (probably any mask which takes input from the user).' =>
            '',
        'Defines the maximal valid time (in seconds) for a session id.' =>
            'Definiuje maksymalny dopuszczalny czas dla id sesji.',
        'Defines the maximum length (in characters) for a scheduler task data. WARNING: Do not modify this setting unless you are sure of the current Database length for \'task_data\' filed from \'scheduler_data_list\' table.' =>
            '',
        'Defines the maximum number of pages per PDF file.' => 'Definiuje maksymalną liczbę stron dla pliku PDF.',
        'Defines the maximum number of quoted lines to be added to responses.' =>
            '',
        'Defines the maximum size (in MB) of the log file.' => 'Definiuje maksymalny rozmiar (w MB) dla pliku logowania.',
        'Defines the module that shows a generic notification in the agent interface. Either "Text" - if configured - or the contents of "File" will be displayed.' =>
            'Definiuje moduł ukazujący podstawowe powiadomienia w interfejsie agenta. Zostanie pokazany "tekst" - jeśli skonfigurowany - lub zawartość "pliku".',
        'Defines the module that shows all the currently loged in customers in the agent interface.' =>
            'Definiuje moduł, który ukazuje wszystkich obecnie zalogowanych klientów w interfejsie agenta.',
        'Defines the module that shows all the currently logged in agents in the agent interface.' =>
            'Definiuje moduł, który ukazuje wszystkich obecnie zalogowanych agentów w interfejsie agenta.',
        'Defines the module that shows the currently loged in agents in the customer interface.' =>
            'Definiuje moduł, który ukazuje obecnie zalogowanych agentów  w interfejsie klienta.',
        'Defines the module that shows the currently loged in customers in the customer interface.' =>
            'Definiuje moduł, który ukazuje obecnie zalogowanych klientów interfejsie klienta.',
        'Defines the module to authenticate customers.' => 'Definiuje moduł autentykacji klientów.',
        'Defines the module to display a notification in different interfaces on different occasions for OTRS Business Solution™.' =>
            '',
        'Defines the module to display a notification in the agent interface if the scheduler is not running.' =>
            'Definiuje moduł ukazujący powiadomienia w interfejsie agenta, jeśli terminarz nie jest uruchomiony.',
        'Defines the module to display a notification in the agent interface, if the agent is logged in while having out-of-office active.' =>
            'Definiuje moduł ukazujący powiadomienia w interfejsie agenta, jeśli agent jest zalogowany wówczas gdy posiada status "poza biurem".',
        'Defines the module to display a notification in the agent interface, if the agent is logged in while having system maintenance active.' =>
            '',
        'Defines the module to display a notification in the agent interface, if the system is used by the admin user (normally you shouldn\'t work as admin).' =>
            'Definiuje moduł ukazujący powiadomienia w interfejsie agenta, jeśli system jest użytkowany przez administratora (w codziennej pracy praca jako admin jest niewskazana).',
        'Defines the module to generate html refresh headers of html sites, in the customer interface.' =>
            'Definiuje moduł generujący nagłówki odświerzające strony html w interfejsie użytkownika.',
        'Defines the module to generate html refresh headers of html sites.' =>
            'Definiuje moduł generujący nagłówki odświerzające strony html.',
        'Defines the module to send emails. "Sendmail" directly uses the sendmail binary of your operating system. Any of the "SMTP" mechanisms use a specified (external) mailserver. "DoNotSendEmail" doesn\'t send emails and it is useful for test systems.' =>
            'Definiuje moduł wysyłkowy poczty. "Sendmail" używa bezpośrednio programu sendmail z twojego systemu. Jakikolwiek mechanizm "SMTP" używa wskazanego (zewnętrznego) serwera pocztowego. "DoNotSendEmail" nie przesyła poczty i winno być wykorzystywane w systemach testowych.',
        'Defines the module used to store the session data. With "DB" the frontend server can be splitted from the db server. "FS" is faster.' =>
            'Definiuje moduł używany do przechowywania danych. Z serwerem "DB" interfejs może zostać rozdzielony od bazy danych. "FS" jest szybszy.',
        'Defines the name of the application, shown in the web interface, tabs and title bar of the web browser.' =>
            'Definiuje nazwę aplikacji widoczną w interfejsie web, zakładkach i pasku tytułowym przeglądarki.',
        'Defines the name of the column to store the data in the preferences table.' =>
            'Definuje nazwę kolumny przechowującą dane w tabeli właściwości.',
        'Defines the name of the column to store the user identifier in the preferences table.' =>
            'Definuje nazwę kolumny przechowującą identyfikator użytkownika w tabeli właściwości.',
        'Defines the name of the indicated calendar.' => 'Definiuje nazwę wskazanego kalendarza.',
        'Defines the name of the key for customer sessions.' => 'Definiuje nazwę klucza dla sesji klienta.',
        'Defines the name of the session key. E.g. Session, SessionID or OTRS.' =>
            'Definiuje nazwę klucza sesji, np. Sesja, IDSesji lub OTRS. ',
        'Defines the name of the table, where the customer preferences are stored.' =>
            'Definiuje nazwę tabeli gdzie ustawienia klienta są zapisane.',
        'Defines the next possible states after composing / answering a ticket in the ticket compose screen of the agent interface.' =>
            'Definiuje kolejne możliwe stany po tworzeniu / odpowiedzi na zgłoszenie w oknie tworzenia zgłoszenia interfejsu agenta.',
        'Defines the next possible states after forwarding a ticket in the ticket forward screen of the agent interface.' =>
            'Definiuje kolejne możliwe stany po przesłaniu zgłoszenia w oknie przesłanych dalej interfejsu agenta.',
        'Defines the next possible states after sending a message in the email outbound screen of the agent interface.' =>
            '',
        'Defines the next possible states for customer tickets in the customer interface.' =>
            'Definiuje kolejne możliwe stany dla zgłoszeń klienta w interfejsie klienta.',
        'Defines the next state of a ticket after adding a note, in the close ticket screen of the agent interface.' =>
            'Definiuje kolejny status zgłoszenia po dodaniu notatki w oknie zamknięcia zgłoszenia interfejsu agenta.',
        'Defines the next state of a ticket after adding a note, in the ticket bulk screen of the agent interface.' =>
            'Definiuje kolejny status zgłoszenia po dodaniu notatki w oknie zbiorczym zgłoszeń interfejsu agenta.',
        'Defines the next state of a ticket after adding a note, in the ticket free text screen of the agent interface.' =>
            'Definiuje kolejny status zgłoszenia po dodaniu notatki w oknie wolnego tekstu zgłoszenia interfejsu agenta.',
        'Defines the next state of a ticket after adding a note, in the ticket note screen of the agent interface.' =>
            'Definiuje kolejny status zgłoszenia po dodaniu notatki w oknie notatki zgłoszenia interfejsu agenta.',
        'Defines the next state of a ticket after adding a note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Definiuje kolejny status zgłoszenia po dodaniu notatki w oknie właściciela przybliżonego zgłoszenia interfejsu agenta.',
        'Defines the next state of a ticket after adding a note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Definiuje kolejny status zgłoszenia po dodaniu notatki w oknie oczekującego przybliżonego zgłoszenia interfejsu agenta.',
        'Defines the next state of a ticket after adding a note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Definiuje kolejny status zgłoszenia po dodaniu notatki w oknie priorytetu przybliżonego zgłoszenia interfejsu agenta.',
        'Defines the next state of a ticket after adding a note, in the ticket responsible screen of the agent interface.' =>
            'Definiuje kolejny status zgłoszenia po dodaniu notatki w oknie odpowiedzialnego za zgłoszenie w interfejsie agenta.',
        'Defines the next state of a ticket after being bounced, in the ticket bounce screen of the agent interface.' =>
            'Definiuje kolejny status zgłoszenia po jego odbiciu w oknie odbitych interfejsu agenta.',
        'Defines the next state of a ticket after being moved to another queue, in the move ticket screen of the agent interface.' =>
            'Definiuje kolejny status zgłoszenia po przeniesieniu do innegj kolejki w oknie przeniesionych zgłoszeń interfejsu agenta.',
        'Defines the number of header fields in frontend modules for add and update postmaster filters. It can be up to 99 fields.' =>
            '',
        'Defines the parameters for the customer preferences table.' => 'Definiuje parametry dla tabeli preferencji klienta.',
        'Defines the parameters for the dashboard backend. "Cmd" is used to specify command with parameters. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin.' =>
            '',
        'Defines the parameters for the dashboard backend. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin.' =>
            '',
        'Defines the parameters for the dashboard backend. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" defines the cache expiration period in minutes for the plugin.' =>
            '',
        'Defines the parameters for the dashboard backend. "Limit" defines the number of entries displayed by default. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin.' =>
            '',
        'Defines the parameters for the dashboard backend. "Limit" defines the number of entries displayed by default. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" defines the cache expiration period in minutes for the plugin.' =>
            '',
        'Defines the password to access the SOAP handle (bin/cgi-bin/rpc.pl).' =>
            'Definiuje hasło dostępowe do wykorzystania SOAP (bin/cgi-bin/rpc.pl).',
        'Defines the path and TTF-File to handle bold italic monospaced font in PDF documents.' =>
            'Definiuje ścieżkę i plik TTF do wykorzystania w dokumentach PDF dla czcionki pogrubionej pochylonej o stałej szerokości.',
        'Defines the path and TTF-File to handle bold italic proportional font in PDF documents.' =>
            'Definiuje ścieżkę i plik TTF do wykorzystania w dokumentach PDF dla czcionki pogrubionej pochylonej proporcjonalnej.',
        'Defines the path and TTF-File to handle bold monospaced font in PDF documents.' =>
            'Definiuje ścieżkę i plik TTF do wykorzystania w dokumentach PDF dla czcionki pogrubionej o stałej szerokości.',
        'Defines the path and TTF-File to handle bold proportional font in PDF documents.' =>
            'Definiuje ścieżkę i plik TTF do wykorzystania w dokumentach PDF dla czcionki pogrubionej proporcjonalnej.',
        'Defines the path and TTF-File to handle italic monospaced font in PDF documents.' =>
            'Definiuje ścieżkę i plik TTF do wykorzystania w dokumentach PDF dla czcionki pochylonej o stałej szerokości.',
        'Defines the path and TTF-File to handle italic proportional font in PDF documents.' =>
            'Definiuje ścieżkę i plik TTF do wykorzystania w dokumentach PDF dla czcionki pochylonej proporcjonalnej.',
        'Defines the path and TTF-File to handle monospaced font in PDF documents.' =>
            'Definiuje ścieżkę i plik TTF do wykorzystania fontu o stałej szerokości w dokumentach PDF.',
        'Defines the path and TTF-File to handle proportional font in PDF documents.' =>
            'Definiuje ścieżkę i plik TTF do wykorzystania fontu proporcjonalnego w dokumentach PDF.',
        'Defines the path for scheduler to store its console output (SchedulerOUT.log and SchedulerERR.log).' =>
            'Definiuje ścieżkę dla terminarza do przechowywania wyjścia konsoli (SchedulerOUT.log i SchedulerERR.log).',
        'Defines the path of the shown info file, that is located under Kernel/Output/HTML/Standard/CustomerAccept.dtl.' =>
            'Definiuje ścieżkę pokazanego pliku info zamieszczonego pod Kernel/Output/HTML/Standard/CustomerAccept.dtl.',
        'Defines the path to PGP binary.' => 'Definiuje ścieżkę dla programu PGP.',
        'Defines the path to open ssl binary. It may need a HOME env ($ENV{HOME} = \'/var/lib/wwwrun\';).' =>
            'Definiuje ścieźkę do programu ssl. Może wymagać środowiska HOME ($ENV{HOME} = \'/var/lib/wwwrun\';).',
        'Defines the placement of the legend. This should be a two letter key of the form: \'B[LCR]|R[TCB]\'. The first letter indicates the placement (Bottom or Right), and the second letter the alignment (Left, Right, Center, Top, or Bottom).' =>
            '',
        'Defines the postmaster default queue.' => 'Definiuje domyślną ścieźkę postmaster.',
        'Defines the priority in which the information is logged and presented.' =>
            '',
        'Defines the receipent target of the phone ticket and the sender of the email ticket ("Queue" shows all queues, "System address" displays all system addresses) in the agent interface.' =>
            '',
        'Defines the receipent target of the tickets ("Queue" shows all queues, "SystemAddress" displays all system addresses) in the customer interface.' =>
            '',
        'Defines the required permission to show a ticket in the escalation view of the agent interface.' =>
            'Definiuje wymagane prawa do ukazania zgłoszenia w widoku eskalacji interfejsu agenta.',
        'Defines the search limit for the stats.' => 'Definiuje limit wyszukiwań dla statystyk.',
        'Defines the sender for rejected emails.' => 'Definiuje nadawcę dla odrzuconych e-maili.',
        'Defines the separator between the agents real name and the given queue email address.' =>
            'Definiuje separator pomiędzy prawdziwym imieniem agenta a wskazanym adresem e-mail.',
        'Defines the spacing of the legends.' => 'Definiuje rozmieszczenie legend.',
        'Defines the standard permissions available for customers within the application. If more permissions are needed, you can enter them here. Permissions must be hard coded to be effective. Please ensure, when adding any of the afore mentioned permissions, that the "rw" permission remains the last entry.' =>
            '',
        'Defines the standard size of PDF pages.' => 'Definiuje standardowy rozmiar stron PDF.',
        'Defines the state of a ticket if it gets a follow-up and the ticket was already closed.' =>
            'Definiuje status zgłoszenia jeśli ma ono kolejne związane oraz zgłoszenie zostało już zamknięte.',
        'Defines the state of a ticket if it gets a follow-up.' => 'Definiuje status zgłoszenia jeśli ma ono kolejne związane.',
        'Defines the state type of the reminder for pending tickets.' => 'Definiuje typ statusu powiadomień dla oczekujących zgłoszeń.',
        'Defines the subject for notification mails sent to agents, about new password.' =>
            'Definiuje temat dla powiadomień mailowych wysłanych do agentów o nowym haśle.',
        'Defines the subject for notification mails sent to agents, with token about new requested password.' =>
            'Definiuje temat dla powiadomień mailowych wysłanych do agentów z tokenem o nowo utworzonym haśle.',
        'Defines the subject for notification mails sent to customers, about new account.' =>
            'Definiuje temat dla powiadomień mailowych wysłanych do klientów o nowym koncie.',
        'Defines the subject for notification mails sent to customers, about new password.' =>
            'Definiuje temat dla powiadomień mailowych wysłanych do o nowym haśle.',
        'Defines the subject for notification mails sent to customers, with token about new requested password.' =>
            'Definiuje temat dla powiadomień mailowych wysłanych do klientów z tokenem o nowo utworzonym haśle.',
        'Defines the subject for rejected emails.' => 'Definiuje tytuł odrzuconych e-maili.',
        'Defines the system administrator\'s email address. It will be displayed in the error screens of the application.' =>
            'Definiuje adres e-mail administratora. Zostanie on wyświetlony w oknach błędu aplikacji.',
        'Defines the system identifier. Every ticket number and http session string contains this ID. This ensures that only tickets which belong to your system will be processed as follow-ups (useful when communicating between two instances of OTRS).' =>
            '',
        'Defines the target attribute in the link to external customer database. E.g. \'AsPopup PopupType_TicketAction\'.' =>
            'Definiuje docelowy atrybut w zewnętrznej bazie danych klienta. Np. \'AsPopup PopupType_TicketAction\'.',
        'Defines the target attribute in the link to external customer database. E.g. \'target="cdb"\'.' =>
            'Definiuje docelowy atrybut w zewnętrznej bazie danych klienta. Np. \'target="cdb"\'.',
        'Defines the ticket fields that are going to be displayed calendar events. The "Key" defines the field or ticket attribute and the "Content" defines the display name.' =>
            '',
        'Defines the time in days to keep log backup files.' => 'Definiuje w dniach okres przechowywania kopii zapasowych logów.',
        'Defines the time in seconds after which the Scheduler performs an automatic self-restart.' =>
            'Definiuje czas w sekundach po którym Terminarz dokona samorestartu.',
        'Defines the time zone of the indicated calendar, which can be assigned later to a specific queue.' =>
            'Definiuje strefe czasową wskazanego kalendarza, który będzie dodany w później do wybranej kolejki.',
        'Defines the title font in graphs (place custom fonts in var/fonts).' =>
            '',
        'Defines the type of protocol, used by the web server, to serve the application. If https protocol will be used instead of plain http, it must be specified here. Since this has no affect on the web server\'s settings or behavior, it will not change the method of access to the application and, if it is wrong, it will not prevent you from logging into the application. This setting is only used as a variable, OTRS_CONFIG_HttpType which is found in all forms of messaging used by the application, to build links to the tickets within your system.' =>
            '',
        'Defines the used character for plaintext email quotes in the ticket compose screen of the agent interface. If this is empty or inactive, original emails will not be quoted but appended to the response.' =>
            '',
        'Defines the user identifier for the customer panel.' => 'Definiuje identyfikator użytkownika w panelu klienta.',
        'Defines the username to access the SOAP handle (bin/cgi-bin/rpc.pl).' =>
            'Definiuje uzytkownika do wykorzystania SOAP (bin/cgi-bin/rpc.pl).',
        'Defines the valid state types for a ticket.' => 'Definiuje aktualne typu stanów dla zgłoszenia.',
        'Defines the valid states for unlocked tickets. To unlock tickets the script "bin/otrs.UnlockTickets.pl" can be used.' =>
            'Definiuje aktualne stany dla odblokowanych zgłoszeń. Do odblokowania zgłoszeń można użyć skryptu "bin/otrs.UnlockTickets.pl.',
        'Defines the viewable locks of a ticket. Default: unlock, tmp_lock.' =>
            'Definiuje widoczne blokady zgłoszenia. Domyślne: odblokowany, tmp_lock.',
        'Defines the width for the rich text editor component for this screen. Enter number (pixels) or percent value (relative).' =>
            '',
        'Defines the width for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            '',
        'Defines the width of the legend.' => 'Definiuje szerokość legendy.',
        'Defines which article sender types should be shown in the preview of a ticket.' =>
            'Definiuje które typy wysyłających artykuły powinny być widoczne w podglądzie zgłoszenia.',
        'Defines which items are available for \'Action\' in third level of the ACL structure.' =>
            '',
        'Defines which items are available in first level of the ACL structure.' =>
            'Definiuje które pozycje są widoczne w pierwszym poziomie ACL.',
        'Defines which items are available in second level of the ACL structure.' =>
            'Definiuje które pozycje są widoczne w drugim poziomie ACL.',
        'Defines which states should be set automatically (Content), after the pending time of state (Key) has been reached.' =>
            'Definiuje które stany powinny zostać ustawione automatycznie (treść), po osiągnięciu czasu oczekiwania (klucz).',
        'Defines wich article type should be expanded when entering the overview. If nothing defined, latest article will be expanded.' =>
            '',
        'Defines, which tickets of which ticket state types should not be listed in linked ticket lists.' =>
            '',
        'Deleted link to ticket "%s".' => 'Usunięto łacze ze zgłoszenia "%s".',
        'Deletes a session if the session id is used with an invalid remote IP address.' =>
            'Usuwa sesje jeśli id sesji jest użyte wraz z nieprawidłowym adresem IP.',
        'Deletes requested sessions if they have timed out.' => 'Usuwa podane wygasnięte sesje.',
        'Deploy and manage OTRS Business Solution™.' => '',
        'Determines if the list of possible queues to move to ticket into should be displayed in a dropdown list or in a new window in the agent interface. If "New Window" is set you can add a move note to the ticket.' =>
            '',
        'Determines if the statistics module may generate ticket lists.' =>
            'Determinuje czy moduł statystyk może generować listy zgłoszeń.',
        'Determines the next possible ticket states, after the creation of a new email ticket in the agent interface.' =>
            'Determinuje kolejne możliwe stany po utworzeniu nowego zgłoszenia e-mail w interfejsie agenta.',
        'Determines the next possible ticket states, after the creation of a new phone ticket in the agent interface.' =>
            'Determinuje kolejne możliwe stany po utworzeniu nowego zgłoszenia telefonicznego w interfejsie agenta.',
        'Determines the next possible ticket states, for process tickets in the agent interface.' =>
            'Determinuje kolejne możliwe stany dla zgłoszeń procesowych w interfejsie agenta.',
        'Determines the next screen after new customer ticket in the customer interface.' =>
            'Determinuje kolejne okno dla nowych zgłoszeń klienta w interfejsie klienta.',
        'Determines the next screen after the follow up screen of a zoomed ticket in the customer interface.' =>
            'Determinuje kolejne okno po oknie odpowiedzi przybliżonego zgłoszenia w interfejsie klienta.',
        'Determines the next screen after the ticket is moved. LastScreenOverview will return the last overview screen (e.g. search results, queueview, dashboard). TicketZoom will return to the TicketZoom.' =>
            '',
        'Determines the possible states for pending tickets that changed state after reaching time limit.' =>
            'Determinuje możliwe stany dla oczekujących zgłoszeń po osiągnięciu limitu czasu.',
        'Determines the strings that will be shown as receipent (To:) of the phone ticket and as sender (From:) of the email ticket in the agent interface. For Queue as NewQueueSelectionType "<Queue>" shows the names of the queues and for SystemAddress "<Realname> <<Email>>" shows the name and email of the receipent.' =>
            '',
        'Determines the strings that will be shown as receipent (To:) of the ticket in the customer interface. For Queue as CustomerPanelSelectionType, "<Queue>" shows the names of the queues, and for SystemAddress, "<Realname> <<Email>>" shows the name and email of the receipent.' =>
            '',
        'Determines the way the linked objects are displayed in each zoom mask.' =>
            'Determinuje sposób wyświetlania zlinkowanych objektów w każdej masce przybliżenia.',
        'Determines which options will be valid of the recepient (phone ticket) and the sender (email ticket) in the agent interface.' =>
            '',
        'Determines which queues will be valid for ticket\'s recepients in the customer interface.' =>
            '',
        'Disable restricted security for IFrames in IE. May be required for SSO to work in IE8.' =>
            '',
        'Disables sending reminder notifications to the responsible agent of a ticket (Ticket::Responsible needs to be activated).' =>
            '',
        'Disables the web installer (http://yourhost.example.com/otrs/installer.pl), to prevent the system from being hijacked. If set to "No", the system can be reinstalled and the current basic configuration will be used to pre-populate the questions within the installer script. If not active, it also disables the GenericAgent, PackageManager and SQL Box.' =>
            '',
        'Display settings to override defaults for Process Tickets.' => 'Wyświetl ustawienia nadpisujące domyślne dla złoszeń procesowych.',
        'Displays the accounted time for an article in the ticket zoom view.' =>
            'Wyświetla zliczony czas artykułu w widoku przybliżonym zgłoszenia.',
        'Dropdown' => 'Lista rozwijana',
        'Dynamic Fields Checkbox Backend GUI' => 'Interfejs pól dynamicznych okna wyboru',
        'Dynamic Fields Date Time Backend GUI' => 'Interfejs pól dynamicznych daty i czasu',
        'Dynamic Fields Drop-down Backend GUI' => 'Interfejs pól dynamicznych rozwijanej listy',
        'Dynamic Fields GUI' => 'Interfejs pól dynamicznych',
        'Dynamic Fields Multiselect Backend GUI' => 'Interfejs pól dynamicznych multiwyboru',
        'Dynamic Fields Overview Limit' => 'Limit przeglądu pól dynamicznych',
        'Dynamic Fields Text Backend GUI' => 'Interfejs pól dynamicznych programu tekstowego',
        'Dynamic Fields used to export the search result in CSV format.' =>
            'Dynamiczne pola uzyte do wyeksportowania wynikow wyszukiwania w formacie CSV.',
        'Dynamic fields groups for process widget. The key is the name of the group, the value contains the fields to be shown. Example: \'Key => My Group\', \'Content: Name_X, NameY\'.' =>
            '',
        'Dynamic fields limit per page for Dynamic Fields Overview' => 'Limit pól dynamicznych na stronie dla przeglądu pól dynamicznych',
        'Dynamic fields options shown in the ticket message screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required. NOTE. If you want to display these fields also in the ticket zoom of the customer interface, you have to enable them in CustomerTicketZoom###DynamicField.' =>
            '',
        'Dynamic fields options shown in the ticket reply section in the ticket zoom screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Dynamiczne pola widoczne w sekcji odpowiedzi na zgłoszenia okna przybliżonego zgłoszenia interfejsu agenta. Możliwe ustawienia: 0 = Wyłączony, 1 = Włączony, 2 = Włączony i wymagany.',
        'Dynamic fields shown in the email outbound screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the process widget in ticket zoom screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'Dynamic fields shown in the sidebar of the ticket zoom screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'Dynamic fields shown in the ticket close screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Dynamiczne pola widoczne w oknie zakniętego zgłoszenia interfejsu agenta. Możliwe ustawienia: 0 = Wyłączony, 1 = Włączony, 2 = Włączony i wymagany.',
        'Dynamic fields shown in the ticket compose screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Dynamiczne pola widoczne w oknie tworzenia zgłoszenia interfejsu agenta. Możliwe ustawienia: 0 = Wyłączony, 1 = Włączony, 2 = Włączony i wymagany.',
        'Dynamic fields shown in the ticket email screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Dynamiczne pola widoczne w oknie zgłoszenia e-mail interfejsu agenta. Możliwe ustawienia: 0 = Wyłączony, 1 = Włączony, 2 = Włączony i wymagany.',
        'Dynamic fields shown in the ticket forward screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Dynamiczne pola widoczne w oknie przesłanego dalej zgłoszenia interfejsu agenta. Możliwe ustawienia: 0 = Wyłączony, 1 = Włączony, 2 = Włączony i wymagany.',
        'Dynamic fields shown in the ticket free text screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Dynamiczne pola widoczne w oknie tekstu zgłoszenia interfejsu agenta. Możliwe ustawienia: 0 = Wyłączony, 1 = Włączony, 2 = Włączony i wymagany.',
        'Dynamic fields shown in the ticket medium format overview screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            'Dynamiczne pola widoczne w oknie średniego formatu podglądu zgłoszenia interfejsu agenta. Możliwe ustawienia: 0 = Wyłączony, 1 = Włączony.',
        'Dynamic fields shown in the ticket move screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Dynamiczne pola widoczne w oknie przeniesionego zgłoszenia interfejsu agenta. Możliwe ustawienia: 0 = Wyłączony, 1 = Włączony, 2 = Włączony i wymagany.',
        'Dynamic fields shown in the ticket note screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Dynamiczne pola widoczne w oknie notatek zgłoszenia interfejsu agenta. Możliwe ustawienia: 0 = Wyłączony, 1 = Włączony, 2 = Włączony i wymagany.',
        'Dynamic fields shown in the ticket overview screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Dynamiczne pola widoczne w oknie przeglądu zgłoszenia interfejsu agenta. Możliwe ustawienia: 0 = Wyłączony, 1 = Włączony, 2 = Włączony i wymagany.',
        'Dynamic fields shown in the ticket owner screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Dynamiczne pola widoczne w oknie własciciela zgłoszenia interfejsu agenta. Możliwe ustawienia: 0 = Wyłączony, 1 = Włączony, 2 = Włączony i wymagany.',
        'Dynamic fields shown in the ticket pending screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Dynamiczne pola widoczne w oknie oczekujacego zgłoszenia interfejsu agenta. Możliwe ustawienia: 0 = Wyłączony, 1 = Włączony, 2 = Włączony i wymagany.',
        'Dynamic fields shown in the ticket phone inbound screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Dynamiczne pola widoczne w oknie przychodzącego zgłoszenia telefonicznego interfejsu agenta. Możliwe ustawienia: 0 = Wyłączony, 1 = Włączony, 2 = Włączony i wymagany.',
        'Dynamic fields shown in the ticket phone outbound screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Dynamiczne pola widoczne w oknie wychodzącego zgłoszenia telefonicznego interfejsu agenta. Możliwe ustawienia: 0 = Wyłączony, 1 = Włączony, 2 = Włączony i wymagany.',
        'Dynamic fields shown in the ticket phone screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Dynamiczne pola widoczne w oknie zgłoszenia telefonicznego interfejsu agenta. Możliwe ustawienia: 0 = Wyłączony, 1 = Włączony, 2 = Włączony i wymagany.',
        'Dynamic fields shown in the ticket preview format overview screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            'Dynamiczne pola widoczne w oknie podglądu formatu interfejsu agenta. Możliwe ustawienia: 0 = Wyłączony, 1 = Włączony.',
        'Dynamic fields shown in the ticket print screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            'Dynamiczne pola widoczne w oknie wydruku interfejsu agenta. Możliwe ustawienia: 0 = Wyłączony, 1 = Włączony.',
        'Dynamic fields shown in the ticket print screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            'Dynamiczne pola widoczne w oknie wydruku formatu interfejsu klienta. Możliwe ustawienia: 0 = Wyłączony, 1 = Włączony.',
        'Dynamic fields shown in the ticket priority screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Dynamiczne pola widoczne w oknie priorytetu interfejsu agenta. Możliwe ustawienia: 0 = Wyłączony, 1 = Włączony, 2 = Włączony i wymagany.',
        'Dynamic fields shown in the ticket responsible screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Dynamiczne pola widoczne w oknie odpowiedzialnego za zgłoszenie interfejsu agenta. Możliwe ustawienia: 0 = Wyłączony, 1 = Włączony, 2 = Włączony i wymagany.',
        'Dynamic fields shown in the ticket search overview results screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            'Dynamiczne pola widoczne w oknie rezultatów wyszukiwania zgłoszenia w interfejsie klienta. Możliwe ustawienia: 0 = Wyłączony, 1 = Włączony, 2 = Włączony i wymagany.',
        'Dynamic fields shown in the ticket search screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and shown by default.' =>
            'Dynamiczne pola widoczne w oknie wyszukiwania zgłoszenia interfejsu agenta. Możliwe ustawienia: 0 = Wyłączony, 1 = Włączony, 2 = Włączony i wymagany.',
        'Dynamic fields shown in the ticket search screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            'Dynamiczne pola widoczne w oknie rezultatów wyszukiwania zgłoszenia interfejsu klienta. Możliwe ustawienia: 0 = Wyłączony, 1 = Włączony.',
        'Dynamic fields shown in the ticket small format overview screen of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.' =>
            '',
        'Dynamic fields shown in the ticket zoom screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            'Dynamiczne pola widoczne w oknie przybliżonego zgłoszenia interfejsu klienta. Możliwe ustawienia: 0 = Wyłączony, 1 = Włączony.',
        'DynamicField backend registration.' => '',
        'DynamicField object registration.' => 'Rejestracja obiektów pól dynamicznych',
        'Edit customer company' => 'Edytuj firmę klienta',
        'Email Addresses' => 'Adresy e-mail',
        'Email sent to "%s".' => 'Wysłano odpowiedź do "%s".',
        'Email sent to customer.' => 'E-mail wysłany do klienta.',
        'Enable keep-alive connection header for SOAP responses.' => 'Włącz nagłówek utrzymywania połączeń keep-alive dla odpowiedzi SOAP.',
        'Enabled filters.' => 'Włączone filtry.',
        'Enables PDF output. The CPAN module PDF::API2 is required, if not installed, PDF output will be disabled.' =>
            'Włącza format PDF. Wymagany moduł CPAN PDF::API2, jesli nie jest zainstalowany to format PDF zostanie wyłączony.',
        'Enables PGP support. When PGP support is enabled for signing and encrypting mail, it is HIGHLY recommended that the web server runs as the OTRS user. Otherwise, there will be problems with the privileges when accessing .gnupg folder.' =>
            '',
        'Enables S/MIME support.' => 'Aktywuje wsparcie dla S/MIME.',
        'Enables customers to create their own accounts.' => 'Umożliwia klientom na tworzenie własnych kont.',
        'Enables file upload in the package manager frontend.' => 'Włącza możliwość zamieszczania plików w menadzeże pakietów.',
        'Enables or disables the caching for templates. WARNING: Do NOT disable template caching for production environments for it will cause a massive performance drop! This setting should only be disabled for debugging reasons!' =>
            '',
        'Enables or disables the debug mode over frontend interface.' => '',
        'Enables or disables the ticket watcher feature, to keep track of tickets without being the owner nor the responsible.' =>
            '',
        'Enables performance log (to log the page response time). It will affect the system performance. Frontend::Module###AdminPerformanceLog must be enabled.' =>
            '',
        'Enables spell checker support.' => 'Aktywuje słownik ortograficzny.',
        'Enables the minimal ticket counter size (if "Date" was selected as TicketNumberGenerator).' =>
            'Włącza minimalny numer zgłoszenia (jeśli "Data" została wybrana jako TicketNumberGenerator).',
        'Enables ticket bulk action feature for the agent frontend to work on more than one ticket at a time.' =>
            '',
        'Enables ticket bulk action feature only for the listed groups.' =>
            '',
        'Enables ticket responsible feature, to keep track of a specific ticket.' =>
            '',
        'Enables ticket watcher feature only for the listed groups.' => '',
        'Enroll this ticket into a process' => '',
        'Escalation response time finished' => '',
        'Escalation response time forewarned' => '',
        'Escalation response time in effect' => '',
        'Escalation solution time finished' => '',
        'Escalation solution time forewarned' => '',
        'Escalation solution time in effect' => '',
        'Escalation update time finished' => '',
        'Escalation update time forewarned' => '',
        'Escalation update time in effect' => '',
        'Escalation view' => 'Zgłoszenia eskalowane',
        'EscalationTime' => '',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate).' =>
            '',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate). This is only possible if all Ticket dynamic fields need the same event.' =>
            '',
        'Event module that performs an update statement on TicketIndex to rename the queue name there if needed and if StaticDB is actually used.' =>
            '',
        'Event module that updates customer user service membership if login changes.' =>
            'Moduł zdarzeń modyfikujący przynależność konta klienta do serwisu po zmianie loginu.',
        'Event module that updates customer users after an update of the Customer.' =>
            '',
        'Event module that updates tickets after an update of the Customer User.' =>
            'Moduł zdarzeń modyfikujący zgłoszenie po zmianie konta klienta.',
        'Event module that updates tickets after an update of the Customer.' =>
            '',
        'Events Ticket Calendar' => '',
        'Execute SQL statements.' => 'Wykonaj polecenia SQL',
        'Executes follow up checks on In-Reply-To or References headers for mails that don\'t have a ticket number in the subject.' =>
            '',
        'Executes follow up mail attachments checks in  mails that don\'t have a ticket number in the subject.' =>
            '',
        'Executes follow up mail body checks in mails that don\'t have a ticket number in the subject.' =>
            '',
        'Executes follow up plain/raw mail checks in mails that don\'t have a ticket number in the subject.' =>
            '',
        'Exports the whole article tree in search result (it can affect the system performance).' =>
            'Eksportuje całe drzewo artykułów z rezultatów wyszukiwania (może to mieć wpływ na wydajnośc systemu).',
        'Fetches packages via proxy. Overwrites "WebUserAgent::Proxy".' =>
            'Pobiera pakiety przez proxy. Nadpisuje "WebUserAgent::Proxy".',
        'File that is displayed in the Kernel::Modules::AgentInfo module, if located under Kernel/Output/HTML/Standard/AgentInfo.dtl.' =>
            'Plik kóry jest wyświetlony w module Kernel::Modules::AgentInfo ',
        'Filter for debugging ACLs. Note: More ticket attributes can be added in the format <OTRS_TICKET_Attribute> e.g. <OTRS_TICKET_Priority>.' =>
            '',
        'Filter for debugging Transitions. Note: More filters can be added in the format <OTRS_TICKET_Attribute> e.g. <OTRS_TICKET_Priority>.' =>
            '',
        'Filter incoming emails.' => 'Fitrowanie przychodzących e-maili.',
        'First Queue' => '',
        'FirstLock' => 'Pierwsza blokada',
        'FirstResponse' => 'Pierwsza odpowiedź',
        'FirstResponseDiffInMin' => 'Pierwsza odpowiedź w min. - różnica',
        'FirstResponseInMin' => 'Pierwsza odpowiedź w min.',
        'Firstname Lastname' => 'Imię i Nazwisko',
        'Firstname Lastname (UserLogin)' => 'Imię i Nazwisko (login użytkownika)',
        'FollowUp for [%s]. %s' => 'Nowa wiadomość nawiązująca do [%s]. %s',
        'Forces encoding of outgoing emails (7bit|8bit|quoted-printable|base64).' =>
            'Wymusza kodowanie wychodzącej poczty (7bit|8bit|quoted-printable|base64).',
        'Forces to choose a different ticket state (from current) after lock action. Define the current state as key, and the next state after lock action as content.' =>
            'Wymusza wybranie innego statusu zgłoszenia (od obecnego) po zablokowaniu. Definiuje obecny stan jako klucz oraz następny stan po zablokowaniu jako treść.',
        'Forces to unlock tickets after being moved to another queue.' =>
            'Wymusza odblokowanie zgłoszeń po przeniesieniu do innej kolejki.',
        'Forwarded to "%s".' => 'Przesłano do "%s".',
        'Frontend language' => 'Język interfejsu',
        'Frontend module registration (disable AgentTicketService link if Ticket Serivice feature is not used).' =>
            '',
        'Frontend module registration (disable company link if no company feature is used).' =>
            'Widok modułu interfejsu (wyłącz link firmy jeśli żadna cecha firmy nie jets używana.)',
        'Frontend module registration (disable ticket processes screen if no process available) for Customer.' =>
            'Widok modułu interfejsu (wyłącz okno procesów jeśli żadne procesy nie są dostepne) dla klienta.',
        'Frontend module registration (disable ticket processes screen if no process available).' =>
            'Widok modułu interfejsu (wyłącz okno procesów jeśli żadne procesy nie są dostepne).',
        'Frontend module registration for the agent interface.' => 'Widok modułu interfejsu dla interfejsu agenta.',
        'Frontend module registration for the customer interface.' => 'Widok modułu interfejsu dla interfejsu klienta.',
        'Frontend theme' => 'Schemat graficzny',
        'Fulltext index regex filters to remove parts of the text.' => 'Indeks filtrów pełnotekstowych do usuwania części tekstu.',
        'Fulltext search' => '',
        'General ticket data shown in the ticket overviews (fall-back). Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note that TicketNumber can not be disabled, because it is necessary.' =>
            '',
        'GenericAgent' => 'Agent automatyczny',
        'GenericInterface Debugger GUI' => 'Interfejs debugera GenericInterface',
        'GenericInterface Invoker GUI' => 'Interfejs wzywajacy GenericInterface',
        'GenericInterface Operation GUI' => 'Interfejs operacji GenericInterface',
        'GenericInterface TransportHTTPREST GUI' => '',
        'GenericInterface TransportHTTPSOAP GUI' => 'Interfejs TransportHTTPSOAP GenericInterface',
        'GenericInterface Web Service GUI' => 'Interfejs serwisu sieciowego GenericInterface',
        'GenericInterface Webservice History GUI' => 'Interfejs historii serwisu Web GenericInterface',
        'GenericInterface Webservice Mapping GUI' => 'Interfejs mapowania serwisu Web GenericInterface',
        'GenericInterface module registration for the invoker layer.' => 'Rejestracja modułu GenericInterface dla warstwy wzywającej.',
        'GenericInterface module registration for the mapping layer.' => 'Rejestracja modułu GenericInterface lda warstwy mapującej.',
        'GenericInterface module registration for the operation layer.' =>
            'Rejestracja modułu GenericInterface dla warstwy operacji.',
        'GenericInterface module registration for the transport layer.' =>
            'Rejestracja modułu GenericInterface dla warstwy trasportowej.',
        'Gives end users the possibility to override the separator character for CSV files, defined in the translation files.' =>
            '',
        'Grants access, if the customer ID of the ticket matches the customer user\'s ID and the customer user has group permissions on the queue the ticket is in.' =>
            '',
        'Helps to extend your articles full-text search (From, To, Cc, Subject and Body search). Runtime will do full-text searches on live data (it works fine for up to 50.000 tickets). StaticDB will strip all articles and will build an index after article creation, increasing fulltext searches about 50%. To create an initial index use "bin/otrs.RebuildFulltextIndex.pl".' =>
            '',
        'If "DB" was selected for Customer::AuthModule, a database driver (normally autodetection is used) can be specified.' =>
            'Jeśli zaznaczono "DB" dla Customer::AuthModule można wybrać sterownik bazy danych (zwykle używana jest autodetekcja).',
        'If "DB" was selected for Customer::AuthModule, a password to connect to the customer table can be specified.' =>
            'Jeśli zaznaczono "DB" dla Customer::AuthModule może zostać wybrane hasło do połączenia z tabelą klienta.',
        'If "DB" was selected for Customer::AuthModule, a username to connect to the customer table can be specified.' =>
            'Jeśli zaznaczono "DB" dla Customer::AuthModule może zostać wybrana nazwa użytkownika do połączenia z tabelą klienta.',
        'If "DB" was selected for Customer::AuthModule, the DSN for the connection to the customer table must be specified.' =>
            'Jeśli zaznaczono "DB" dla Customer::AuthModule wówczas DSN dla połączenia z tabelą klienta musi zostać określony.',
        'If "DB" was selected for Customer::AuthModule, the column name for the CustomerPassword in the customer table must be specified.' =>
            'Jeśli zaznaczono "DB" dla Customer::AuthModule wówczas nazwa kolumny dla CustomerPassword w tabeli klienta musi zostać określona.',
        'If "DB" was selected for Customer::AuthModule, the crypt type of passwords must be specified.' =>
            'Jeśli zaznaczono "DB" dla Customer::AuthModule wówczas rodzaj szyfrowania haseł musi zostać określony.',
        'If "DB" was selected for Customer::AuthModule, the name of the column for the CustomerKey in the customer table must be specified.' =>
            'Jeśli zaznaczono "DB" dla Customer::AuthModule wówczas nazwa kolumny dla CustomerKey w tabeli klienta musi zostać określona.',
        'If "DB" was selected for Customer::AuthModule, the name of the table where your customer data should be stored must be specified.' =>
            'Jeśli zaznaczono "DB" dla Customer::AuthModule wówczas nazwa kolumny gdzie dane klienta powinny być zapisane musi zostać określona.',
        'If "DB" was selected for SessionModule, a table in database where session data will be stored must be specified.' =>
            'Jeśli zaznaczono "DB" dla SessionModule wóczas tabela w bazie danych gdzie bedą zapisane dane musi zostać określona.',
        'If "FS" was selected for SessionModule, a directory where the session data will be stored must be specified.' =>
            'Jeśli zaznaczono "FS" dla SessionModule wóczas katalog gdzie bedą zapisane dane z sesji musi zostać określona.',
        'If "HTTPBasicAuth" was selected for Customer::AuthModule, you can specify (by using a RegExp) to strip parts of REMOTE_USER (e. g. for to remove trailing domains). RegExp-Note, $1 will be the new Login.' =>
            '',
        'If "HTTPBasicAuth" was selected for Customer::AuthModule, you can specify to strip leading parts of user names (e. g. for domains like example_domain\user to user).' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule and if you want to add a suffix to every customer login name, specifiy it here, e. g. you just want to write the username user but in your LDAP directory exists user@domain.' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule and special paramaters are needed for the Net::LDAP perl module, you can specify them here. See "perldoc Net::LDAP" for more information about the parameters.' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule and your users have only anonymous access to the LDAP tree, but you want to search through the data, you can do this with a user who has access to the LDAP directory. Specify the password for this special user here.' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule and your users have only anonymous access to the LDAP tree, but you want to search through the data, you can do this with a user who has access to the LDAP directory. Specify the username for this special user here.' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule, the BaseDN must be specified.' =>
            'Jeśli zaznaczono "LDAP" dla Customer::AuthModule, wówczas BaseDN musi zostać określony.',
        'If "LDAP" was selected for Customer::AuthModule, the LDAP host can be specified.' =>
            'Jeśli zaznaczono "LDAP" dla Customer::AuthModule, wówczas host LDAP może zostać określony.',
        'If "LDAP" was selected for Customer::AuthModule, the user identifier must be specified.' =>
            'Jeśli zaznaczono "LDAP" dla Customer::AuthModule, wówczas identyfikator użytkownika musi zostać określony.',
        'If "LDAP" was selected for Customer::AuthModule, user attributes can be specified. For LDAP posixGroups use UID, for non LDAP posixGroups use full user DN.' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule, you can specify access attributes here.' =>
            'Jeśli zaznaczono "LDAP" dla Customer::AuthModule, wówczas tutaj możesz określić prawa dostępu.',
        'If "LDAP" was selected for Customer::AuthModule, you can specify if the applications will stop if e. g. a connection to a server can\'t be established due to network problems.' =>
            '',
        'If "LDAP" was selected for Customer::Authmodule, you can check if the user is allowed to authenticate because he is in a posixGroup, e.g. user needs to be in a group xyz to use OTRS. Specify the group, who may access the system.' =>
            '',
        'If "LDAP" was selected, you can add a filter to each LDAP query, e.g. (mail=*), (objectclass=user) or (!objectclass=computer).' =>
            'Jeśli zaznaczono "LDAP" możesz dodać filtr dla każdego zapytania LDAP, np. (mail=*), (objectclass=user) lub (!objectclass=computer).',
        'If "Radius" was selected for Customer::AuthModule, the password to authenticate to the radius host must be specified.' =>
            'Jesli wybrano "Radius" dla Customer::AuthModule wówczas hasło dostepu do serwera radius musi zostać wybrany.',
        'If "Radius" was selected for Customer::AuthModule, the radius host must be specified.' =>
            'Jesli wybrano "Radius" dla Customer::AuthModule wówczas serwer radius musi zostać wybrany.',
        'If "Radius" was selected for Customer::AuthModule, you can specify if the applications will stop if e. g. a connection to a server can\'t be established due to network problems.' =>
            '',
        'If "Sendmail" was selected as SendmailModule, the location of the sendmail binary and the needed options must be specified.' =>
            '',
        'If "SysLog" was selected for LogModule, a special log facility can be specified.' =>
            'Jeśli wybrano "SysLog" dla LogModule wówczas specjalna funkcja logowania może zostać wybrana.',
        'If "SysLog" was selected for LogModule, a special log sock can be specified (on solaris you may need to use \'stream\').' =>
            'Jeśli wybrano "SysLog" dla LogModule wówczas specjalny sposób logowania może zostać wybranay (na solarisie \'stream\' może być wymagany).',
        'If "SysLog" was selected for LogModule, the charset that should be used for logging can be specified.' =>
            'Jeśli wybrano "SysLog" dla LogModule wówczas tablica kodowa znaków dla logowania może zostać wybrana.',
        'If "file" was selected for LogModule, a logfile must be specified. If the file doesn\'t exist, it will be created by the system.' =>
            '',
        'If a note is added by an agent, sets the state of a ticket in the close ticket screen of the agent interface.' =>
            'Ustawia status zgłoszenia jeśli notatka została dodana przez agenta w oknie zamkniętego zgłoszenia interfejsu agenta.',
        'If a note is added by an agent, sets the state of a ticket in the ticket bulk screen of the agent interface.' =>
            'Ustawia status zgłoszenia jeśli notatka została dodana przez agenta w oknie zaznaczonych zgłoszeń interfejsu agenta.',
        'If a note is added by an agent, sets the state of a ticket in the ticket free text screen of the agent interface.' =>
            'Ustawia status zgłoszenia jeśli notatka została dodana przez agenta w oknie tekstu zgłoszenia interfejsu agenta.',
        'If a note is added by an agent, sets the state of a ticket in the ticket note screen of the agent interface.' =>
            'Ustawia status zgłoszenia jeśli notatka została dodana przez agenta w oknie notatki zgłoszenia interfejsu agenta.',
        'If a note is added by an agent, sets the state of a ticket in the ticket responsible screen of the agent interface.' =>
            'Ustawia status zgłoszenia jeśli notatka została dodana przez agenta w oknie odpowiedzialnego za zgłosznie interfejsu agenta.',
        'If a note is added by an agent, sets the state of the ticket in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Ustawia status zgłoszenia jeśli notatka została dodana przez agenta w oknie właściciela przybliżonego zgłoszenia w interfejsie agenta.',
        'If a note is added by an agent, sets the state of the ticket in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Ustawia status zgłoszenia jeśli notatka została dodana przez agenta w oknie oczekujęcego przybliżonego zgłoszenia w interfejsie agenta.',
        'If a note is added by an agent, sets the state of the ticket in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Ustawia status zgłoszenia jeśli notatka została dodana przez agenta w oknie priorytetu przybliżonego zgłoszenia w interfejsie agenta.',
        'If active, none of the regular expressions may match the user\'s email address to allow registration.' =>
            '',
        'If active, one of the regular expressions has to match the user\'s email address to allow registration.' =>
            '',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, and authentication to the mail server is needed, a password must be specified.' =>
            'Jeśli jakikolwiek mechanizm "SMTP" został wybrany jako SendmailModule i uwierzytelnianie do serwera poczty jest wymagane, wówczas hasło musi zostać podane.',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, and authentication to the mail server is needed, an username must be specified.' =>
            'Jeśli jakikolwiek mechanizm "SMTP" został wybrany jako SendmailModule i uwierzytelnianie do serwera poczty jest wymagane, wówczas użytkownik musi zostać podany.',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, the mailhost that sends out the mails must be specified.' =>
            'Jeśli jakikolwiek mechanizm "SMTP" został wybrany jako SendmailModule wówczas serwer pocztowy wysyłający e-maile musi zostać podany.',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, the port where your mailserver is listening for incoming connections must be specified.' =>
            'Jeśli jakikolwiek mechanizm "SMTP" został wybrany jako SendmailModule wówczas port na którym nasłuchuje serwer poczty musi zostać podany.',
        'If enabled debugging information for ACLs is logged.' => '',
        'If enabled debugging information for transitions is logged.' => '',
        'If enabled, OTRS will deliver all CSS files in minified form. WARNING: If you turn this off, there will likely be problems in IE 7, because it cannot load more than 32 CSS files.' =>
            '',
        'If enabled, OTRS will deliver all JavaScript files in minified form.' =>
            '',
        'If enabled, TicketPhone and TicketEmail will be open in new windows.' =>
            'Jeśli włączone to zgłoszneia telefoniczne i e-mail będą otwierane w nowych oknach.',
        'If enabled, the OTRS version tag will be removed from the Webinterface, the HTTP headers and the X-Headers of outgoing mails.' =>
            'Jeśli włączone to tag z wersją OTRS zostanie usunięty z interfejsu sieciowego, nagłówków HTTP oraz X-Headera wychodzącej poczty.',
        'If enabled, the customer can search for tickets in all services (regardless what services are assigned to the customer).' =>
            '',
        'If enabled, the different overviews (Dashboard, LockedView, QueueView) will automatically refresh after the specified time.' =>
            'Gdy włączone, przeglądy takie jak Pulpit, Zablokowane, Widok kolejek będą automatycznie odświeżane co zadany czas.',
        'If enabled, the first level of the main menu opens on mouse hover (instead of click only).' =>
            'Jeśli właczone to pierwszy poziom głównego menu otworzone zostanie przez przesunięcie myszy nad nie (zamiast jedynie poprzez kliknięcie).',
        'If set, this address is used as envelope sender header in outgoing notifications. If no address is specified, the envelope sender header is empty.' =>
            '',
        'If set, this address is used as envelope sender in outgoing messages (not notifications - see below). If no address is specified, the envelope sender is equal to queue e-mail address.' =>
            '',
        'If this option is enabled, then the decrypted data will be stored in the database if they are displayed in AgentTicketZoom.' =>
            '',
        'If this option is set to \'Yes\', tickets created via the web interface, via Customers or Agents, will receive an autoresponse if configured. If this option is set to \'No\', no autoresponses will be sent.' =>
            '',
        'If this regex matches, no message will be send by the autoresponder.' =>
            '',
        'If you want to use a mirror database for agent ticket fulltext search or to generate stats, specify the DSN to this database.' =>
            'Ustaw DSN dla tej bazy danych jeśli chcesz używać lustrzanej bazy dla pełnotekstowego wyszukiwania zgłoszeń agenta lub generowania statystyk.',
        'If you want to use a mirror database for agent ticket fulltext search or to generate stats, the password to authenticate to this database can be specified.' =>
            'Możesz ustawić hasło uwierzytelniające dla tej bazy danych jeśli chcesz używać lustrzanej bazy dla pełnotekstowego wyszukiwania zgłoszeń agenta lub generowania statystyk.',
        'If you want to use a mirror database for agent ticket fulltext search or to generate stats, the user to authenticate to this database can be specified.' =>
            'Możesz ustawić użytkownia dla tej bazy danych jeśli chcesz używać lustrzanej bazy dla pełnotekstowego wyszukiwania zgłoszeń agenta lub generowania statystyk.',
        'Ignore article with system sender type for new article feature (e. g. auto responses or email notifications).' =>
            '',
        'Includes article create times in the ticket search of the agent interface.' =>
            'Zawiera czas utworznia artykułów przy wyszukiwaniu zgłoszeń interfejsu agenta.',
        'IndexAccelerator: to choose your backend TicketViewAccelerator module. "RuntimeDB" generates each queue view on the fly from ticket table (no performance problems up to approx. 60.000 tickets in total and 6.000 open tickets in the system). "StaticDB" is the most powerful module, it uses an extra ticket-index table that works like a view (recommended if more than 80.000 and 6.000 open tickets are stored in the system). Use the script "bin/otrs.RebuildTicketIndex.pl" for initial index update.' =>
            '',
        'Install ispell or aspell on the system, if you want to use a spell checker. Please specify the path to the aspell or ispell binary on your operating system.' =>
            '',
        'Interface language' => 'Język interfejsu',
        'It is possible to configure different skins, for example to distinguish between diferent agents, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            '',
        'It is possible to configure different skins, for example to distinguish between diferent customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            '',
        'It is possible to configure different themes, for example to distinguish between agents and customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid theme on your system. Please see the example entries for the proper form of the regex.' =>
            '',
        'Lastname, Firstname' => 'Nazwisko, Imię',
        'Lastname, Firstname (UserLogin)' => 'Nazwisko, Imię (login użytkownika)',
        'Left' => '',
        'Link agents to groups.' => 'Zarządzanie relacjami Agenci <-> Grupy',
        'Link agents to roles.' => 'Zarządzanie relacjami Agenci <-> Role',
        'Link attachments to templates.' => 'Połącz załączniki z szablonami.',
        'Link customer user to groups.' => 'Połącz konto klienta do grup.',
        'Link customer user to services.' => 'Połącz konto klienta do serwisów.',
        'Link queues to auto responses.' => 'Połącz kolejki z autoodpowiedziami.',
        'Link roles to groups.' => 'Połącz role z grupami.',
        'Link templates to queues.' => 'Połącz szablony do kolejek.',
        'Links 2 tickets with a "Normal" type link.' => 'Łączy 2 zgłoszenia z połączeniem "Zwykłym".',
        'Links 2 tickets with a "ParentChild" type link.' => 'Łączy 2 zgłoszenia z połączeniem "Nadrzędne-Podrzędne".',
        'List of CSS files to always be loaded for the agent interface.' =>
            'Lista plików CSS która zawsze zostanie wczytana do interfejsu agenta.',
        'List of CSS files to always be loaded for the customer interface.' =>
            'Lista plików CSS która zawsze zostanie wczytana do interfejsu klienta.',
        'List of IE8-specific CSS files to always be loaded for the agent interface.' =>
            'Lista plików CSS specyficznych dla IE8 która zawsze zostanie wczytana do interfejsu agenta.',
        'List of IE8-specific CSS files to always be loaded for the customer interface.' =>
            'Lista plików CSS specyficznych dla IE8 która zawsze zostanie wczytana do interfejsu klienta.',
        'List of JS files to always be loaded for the agent interface.' =>
            'Lista plików JS która zawsze zostanie wczytana do interfejsu agenta.',
        'List of JS files to always be loaded for the customer interface.' =>
            'Lista plików JS która zawsze zostanie wczytana do interfejsu klienta.',
        'List of all CustomerCompany events to be displayed in the GUI.' =>
            'Lista wszystkich wydarzeń związanych z CustomerCompany do wyświetlenia w interfejsie uźytkownika.',
        'List of all CustomerUser events to be displayed in the GUI.' => 'Lista wszystkich wydarzeń związanych z CustomerUser do wyświetlenia w interfejsie uźytkownika.',
        'List of all DynamicField events to be displayed in the GUI.' => '',
        'List of all Package events to be displayed in the GUI.' => '',
        'List of all article events to be displayed in the GUI.' => 'Lista wszystkich wydarzeń związanych z artykułami do wyświetlenia w interfejsie uźytkownika.',
        'List of all queue events to be displayed in the GUI.' => '',
        'List of all ticket events to be displayed in the GUI.' => 'Lista wszystkich wydarzeń związanych ze zgłoszeniami do wyświetlenia w interfejsie uźytkownika.',
        'List of default Standard Templates which are assigned automatically to new Queues upon creation.' =>
            '',
        'List view' => '',
        'Locked ticket.' => 'Zablokowano zgłoszenie.',
        'Log file for the ticket counter.' => 'Plik z logiem liczby zgłoszeń.',
        'Loop-Protection! No auto-response sent to "%s".' => 'Loop-Protection! Nie wyslano autoodpowiedzi do "%s".',
        'Mail Accounts' => 'Konta Pocztowe',
        'Main menu registration.' => 'Rejstracja okna głównego.',
        'Makes the application check the MX record of email addresses before sending an email or submitting a telephone or email ticket.' =>
            'Powoduje by aplikacja sprawdzała zapisy MX adresów e-mail przed wysłaniem e-mail lub zapisaniem zgłoszenia telefonicznego lub e-mail.',
        'Makes the application check the syntax of email addresses.' => 'Powoduje by aplikacja sprawdzała poprawność adresu e-mail.',
        'Makes the picture transparent.' => 'Włącza przeźroczystość obrazu.',
        'Makes the session management use html cookies. If html cookies are disabled or if the client browser disabled html cookies, then the system will work as usual and append the session id to the links.' =>
            '',
        'Manage OTRS Group services.' => '',
        'Manage PGP keys for email encryption.' => 'Zarządzanie kluczami PGP do szyfrowania poczty.',
        'Manage POP3 or IMAP accounts to fetch email from.' => 'Ustawienia konto pocztowych POP3 i IMAP, z których pobierana jest poczta przychodząca do systemu',
        'Manage S/MIME certificates for email encryption.' => 'Zarządzanie certyfikatami S/MIME służącymi do szyfrowania poczty wychodzącej',
        'Manage existing sessions.' => 'Zarządzanie aktywnymi sesjami agentów i klientów',
        'Manage notifications that are sent to agents.' => 'Zarządzanie powiadomieniami wysyłanymi do agentów.',
        'Manage system registration.' => 'Zarządzaj rejestracją systemu.',
        'Manage tasks triggered by event or time based execution.' => 'Zarządza zadaniami wywołanymi zdarzeniami lub zaplanowymi czasowo.',
        'Max size (in characters) of the customer information table (phone and email) in the compose screen.' =>
            'Maksymalny rozmiar (w znakach) tablicy informacyjnej klienta (telefon i e-mail) w oknie tworzenia.',
        'Max size (in rows) of the informed agents box in the agent interface.' =>
            'Maksymalny rozmiar (w wierszach) okna poinformowanych agentów w interfejsie agenta.',
        'Max size (in rows) of the involved agents box in the agent interface.' =>
            'Maksymalny rozmiar (w wierszach) okna zaangażowanych agentów w interfejsie agenta.',
        'Max size of the subjects in an email reply.' => 'Maksymalny rozmiar tytułów w odpowiedzi e-mail.',
        'Maximal auto email responses to own email-address a day (Loop-Protection).' =>
            'Maksymalna liczba odpowiedzi automatycznych na własne adresy e-mail w ciągu dnia (ochrona przed zapętleniem).',
        'Maximal size in KBytes for mails that can be fetched via POP3/POP3S/IMAP/IMAPS (KBytes).' =>
            'Maksymalny rozmiar w KBajtach dla e-maili które mogą zostać ściągnięte poprzez POP3/POP3S/IMAP/IMAPS (KBajty).',
        'Maximum length (in characters) of the dynamic field in the article of the ticket zoom view.' =>
            'Maksymalna długość (w znakach) w polach dynamicznych poska artykułów w poglądzie zgłoszeń.',
        'Maximum length (in characters) of the dynamic field in the sidebar of the ticket zoom view.' =>
            'Maksymalna długość (w znakach) w polach dynamicznych poska bocznego w poglądzie zgłoszeń.',
        'Maximum number of tickets to be displayed in the result of a search in the agent interface.' =>
            'Maksymalna liczba zgłoszeń do wyświetlenia w rezultacie wyszukiwania w interfejsie agenta.',
        'Maximum number of tickets to be displayed in the result of a search in the customer interface.' =>
            'Maksymalna liczba zgłoszeń do wyświetlenia w rezultacie wyszukiwania w interfejsie klienta.',
        'Maximum number of tickets to be displayed in the result of this operation.' =>
            '',
        'Maximum size (in characters) of the customer information table in the ticket zoom view.' =>
            'Maksymalny rozmiar (w znakach) tabeli informacji klienta w przybliżonym widoku zgłoszenia.',
        'Module for To-selection in new ticket screen in the customer interface.' =>
            '',
        'Module to check customer permissions.' => 'Moduł sprawdzający prawa klienta.',
        'Module to check if a user is in a special group. Access is granted, if the user is in the specified group and has ro and rw permissions.' =>
            '',
        'Module to check if arrived emails should be marked as email-internal (because of original forwarded internal email). ArticleType and SenderType define the values for the arrived email/article.' =>
            '',
        'Module to check the agent responsible of a ticket.' => 'Moduł umożliwiający sprawdzenie odpowiedzialnego za zgłoszenie.',
        'Module to check the group permissions for the access to customer tickets.' =>
            'Moduł sprawdzający uprawnienia dostępu do zgłoszeń klienta.',
        'Module to check the owner of a ticket.' => 'Moduł sprawdzający właściciela zgłoszenia.',
        'Module to check the watcher agents of a ticket.' => 'Moduł sprawdzający agentów przeglądających zgłoszenie.',
        'Module to compose signed messages (PGP or S/MIME).' => 'Moduł tworzący podpisane wiadomości (PGP lub S/MIME)',
        'Module to crypt composed messages (PGP or S/MIME).' => 'Moduł szyfrujący utworzone wiadomości (PGP lub S/MIME)',
        'Module to filter and manipulate incoming messages. Block/ignore all spam email with From: noreply@ address.' =>
            '',
        'Module to filter and manipulate incoming messages. Get a 4 digit number to ticket free text, use regex in Match e. g. From => \'(.+?)@.+?\', and use () as [***] in Set =>.' =>
            '',
        'Module to generate accounted time ticket statistics.' => 'Moduł generujący statystyki zliczające czas zgłoszeń.',
        'Module to generate html OpenSearch profile for short ticket search in the agent interface.' =>
            'Moduł generujący profil OpenSearch da krótkich zgłoszeń w interfejsie agenta.',
        'Module to generate html OpenSearch profile for short ticket search in the customer interface.' =>
            'Moduł generujący profil OpenSearch da krótkich zgłoszeń w interfejsie klienta.',
        'Module to generate ticket solution and response time statistics.' =>
            'Moduł generujący statystyki czasu odpowiedzi i rozwiązań zgłoszeń.',
        'Module to generate ticket statistics.' => 'Moduł generowania statystyk zgłoszeń.',
        'Module to show notifications and escalations (ShownMax: max. shown escalations, EscalationInMinutes: Show ticket which will escalation in, CacheTime: Cache of calculated escalations in seconds).' =>
            '',
        'Module to use database filter storage.' => 'Moduł do filtrowania zapisów bazy danych.',
        'Multiselect' => 'Multiwybór',
        'My Queues and My Services' => '',
        'My Queues or My Services' => '',
        'My Services' => '',
        'My Tickets' => 'Moje zgłoszenia',
        'Name of custom queue. The custom queue is a queue selection of your preferred queues and can be selected in the preferences settings.' =>
            '',
        'Name of custom service. The custom service is a service selection of your preferred services and can be selected in the preferences settings.' =>
            '',
        'NameX' => 'NazwaX',
        'New Ticket [%s] created (Q=%s;P=%s;S=%s).' => 'Nowe zgłoszenie [%s] utworzone (Q=%s;P=%s;S=%s).',
        'New Window' => '',
        'New email ticket' => 'Nowe zgłoszenie e-mail',
        'New owner is "%s" (ID=%s).' => 'Nowym właścicielem jest "%s" (ID=%s).',
        'New phone ticket' => 'Nowe zgłoszenie telefoniczne',
        'New process ticket' => 'Nowe zgłoszenie procesowe',
        'New responsible is "%s" (ID=%s).' => 'Zmieniono osobę odpowiedzialną na "%s" (ID=%s).',
        'Next possible ticket states after adding a phone note in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Next possible ticket states after adding a phone note in the ticket phone outbound screen of the agent interface.' =>
            '',
        'No Notification' => '',
        'None' => '',
        'Notification sent to "%s".' => 'Powiadomienie wysłano do "%s".',
        'Notifications (Event)' => 'Powiadomienia o zdarzeniu',
        'Number of displayed tickets' => 'Liczba wyświetlanych zgłoszeń',
        'Number of lines (per ticket) that are shown by the search utility in the agent interface.' =>
            '',
        'Number of tickets to be displayed in each page of a search result in the agent interface.' =>
            '',
        'Number of tickets to be displayed in each page of a search result in the customer interface.' =>
            '',
        'Old: "%s" New: "%s"' => 'Aktualizacja statusu. Stary: "%s" nowy: "%s"',
        'Online' => '',
        'Open tickets (customer user)' => '',
        'Open tickets (customer)' => '',
        'Out Of Office' => '',
        'Overloads (redefines) existing functions in Kernel::System::Ticket. Used to easily add customizations.' =>
            '',
        'Overview Escalated Tickets' => 'Przegląd eskalowanych zgłoszeń',
        'Overview Refresh Time' => 'Czas odświeżania przeglądu',
        'Overview of all open Tickets.' => 'Przegląd wszystkich otwartych zgłoszeń.',
        'PGP Key Management' => 'Zarządzanie kluczami PGP',
        'PGP Key Upload' => 'Prześlij klucz PGP',
        'Package event module file a scheduler task for update registration.' =>
            '',
        'Parameters for .' => 'Parametry dla .',
        'Parameters for the CreateNextMask object in the preference view of the agent interface.' =>
            'Parametry dla objektu CreateNextMask w widoku właściwości interfejsu agenta.',
        'Parameters for the CustomQueue object in the preference view of the agent interface.' =>
            'Parametry dla objektu CustomQueue w widoku właściwości interfejsu agenta.',
        'Parameters for the CustomService object in the preference view of the agent interface.' =>
            '',
        'Parameters for the FollowUpNotify object in the preference view of the agent interface.' =>
            'Parametry dla objektu FollowUpNotify w widoku właściwości interfejsu agenta.',
        'Parameters for the LockTimeoutNotify object in the preference view of the agent interface.' =>
            'Parametry dla objektu LockTimeoutNotify w widoku właściwości interfejsu agenta.',
        'Parameters for the MoveNotify object in the preference view of the agent interface.' =>
            'Parametry dla objektu MoveNotify w widoku właściwości interfejsu agenta.',
        'Parameters for the NewTicketNotify object in the preferences view of the agent interface.' =>
            'Parametry dla objektu NewTicketNotify w widoku właściwości interfejsu agenta.',
        'Parameters for the RefreshTime object in the preference view of the agent interface.' =>
            'Parametry dla objektu RefreshTime w widoku właściwości interfejsu agenta.',
        'Parameters for the ServiceUpdateNotify object in the preference view of the agent interface.' =>
            '',
        'Parameters for the WatcherNotify object in the preference view of the agent interface.' =>
            'Parametry dla objektu WatcherNotify w widoku właściwości interfejsu agenta.',
        'Parameters for the dashboard backend of the customer company information of the agent interface . "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the customer id status widget of the agent interface . "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the customer user list overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the new tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.' =>
            '',
        'Parameters for the dashboard backend of the queue overview widget of the agent interface. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "QueuePermissionGroup" is not mandatory, queues are only listed if they belong to this permission group if you enable it. "States" is a list of states, the key is the sort order of the state in the widget. "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the running process tickets overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the ticket calendar of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the ticket escalation overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.' =>
            '',
        'Parameters for the dashboard backend of the ticket pending reminder overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.' =>
            '',
        'Parameters for the dashboard backend of the ticket pending reminder overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.' =>
            '',
        'Parameters for the dashboard backend of the ticket stats of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the pages (in which the dynamic fields are shown) of the dynamic fields overview.' =>
            'Parametry dla stron (w których widnieją pola dynamiczne) przeglądu pól dynamicznych.',
        'Parameters for the pages (in which the tickets are shown) of the medium ticket overview.' =>
            'Parametry dla stron (w których widnieją pola dynamiczne) średniego przeglądu zgłoszenia.',
        'Parameters for the pages (in which the tickets are shown) of the small ticket overview.' =>
            'Parametry dla stron (w których widnieją zgłoszenia) małego przeglądu zgłoszenia.',
        'Parameters for the pages (in which the tickets are shown) of the ticket preview overview.' =>
            'Parametry dla stron (w których widnieją zgłoszenia) poglądu przeglądu zgłoszenia.',
        'Parameters of the example SLA attribute Comment2.' => 'Parametry dla atrybutu Comment2 przykładowego SLA.',
        'Parameters of the example queue attribute Comment2.' => 'Parametry dla atrybutu Comment2 przykładowej kolejki.',
        'Parameters of the example service attribute Comment2.' => 'Parametry dla atrybutu Comment2 przykładowego serwisu.',
        'Path for the log file (it only applies if "FS" was selected for LoopProtectionModule and it is mandatory).' =>
            'Ścieżka do logu (używana jedynie wóczas gdy "FS" został wybrany dla LoopProtectionModule i jest on wymagany).',
        'Path of the file that stores all the settings for the QueueObject object for the agent interface.' =>
            'Ścieżka do pliku przechowującego wszystkie ustawienia QueueObject dla interfejsu agenta.',
        'Path of the file that stores all the settings for the QueueObject object for the customer interface.' =>
            'Ścieżka do pliku przechowującego wszystkie ustawienia QueueObject dla interfejsu klienta.',
        'Path of the file that stores all the settings for the TicketObject for the agent interface.' =>
            'Ścieżka do pliku przechowującego wszystkie ustawienia TicketObject dla interfejsu agenta.',
        'Path of the file that stores all the settings for the TicketObject for the customer interface.' =>
            'Ścieżka do pliku przechowującego wszystkie ustawienia TicketObject dla interfejsu klienta.',
        'Performs the configured action for each event (as an Invoker) for each configured Webservice.' =>
            'Wykonuje zaplanowane akcje dla każdego wydażenia (jako Wzywający) dla każdej skonfigurowanej usługi sieciowej.',
        'Permitted width for compose email windows.' => 'Dozwolona szerokość dla okien tworzowych e-maili.',
        'Permitted width for compose note windows.' => 'Dozwolona szerokość dla okien tworzonych notatek.',
        'Picture-Upload' => 'Wgrywanie zdjęć',
        'PostMaster Filters' => 'Filtrowanie poczty przychodzącej',
        'PostMaster Mail Accounts' => 'Konta pocztowe systemu',
        'Process Information' => 'Informacje procesowe',
        'Process Management Activity Dialog GUI' => 'Zarządzanie procesem interfejsu aktywności dialogu',
        'Process Management Activity GUI' => 'Zarządzanie procesem interfejsu aktywności',
        'Process Management Path GUI' => 'Zarządzanie procesem interfejsu ścieżki',
        'Process Management Transition Action GUI' => 'Zarządzanie procesem interfejsu akcji przejścia',
        'Process Management Transition GUI' => 'Zarządzanie procesem interfejsu przejścia',
        'ProcessID' => '',
        'Protection against CSRF (Cross Site Request Forgery) exploits (for more info see http://en.wikipedia.org/wiki/Cross-site_request_forgery).' =>
            'Ochrona przeciw exploitom CSRF (Cross Site Request Forgery). (By dowiedzieć się więcej odwiedź http://pl.wikipedia.org/wiki/Cross-site_request_forgery).',
        'Provides a matrix overview of the tickets per state per queue.' =>
            '',
        'Queue view' => 'Widok kolejek',
        'Recognize if a ticket is a follow up to an existing ticket using an external ticket number.' =>
            'Rozpoznaj czy zgłoszenie jest uzupełniającym to istniejącego zgłoszenia przy użyciu zewnętrznego numeru zgłoszenia.',
        'Refresh Overviews after' => 'Odśwież przeglądy po',
        'Refresh interval' => 'Interwał odświeżania',
        'Removed subscription for user "%s".' => 'Usunięto subskrypcje dla użytkownika "%s".',
        'Removes the ticket watcher information when a ticket is archived.' =>
            '',
        'Replaces the original sender with current customer\'s email address on compose answer in the ticket compose screen of the agent interface.' =>
            'Zamienia oryginalnego nadawcę obecnym adresem e-mail klienta przy tworzonej odpowiedzi w oknie odpowiedzi interfejsu agenta.',
        'Required permissions to change the customer of a ticket in the agent interface.' =>
            'Wymagane uprawnienia do zmiany klienta w zgłoszeniu w panelu agenta.',
        'Required permissions to use the close ticket screen in the agent interface.' =>
            'Wymagane uprawnienia do użycia okna zamknięcia zgłoszenia w panelu agenta.',
        'Required permissions to use the email outbound screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket bounce screen in the agent interface.' =>
            'Wymagane uprawnienia do użycia okna odbicia zgłoszenia w panelu agenta.',
        'Required permissions to use the ticket compose screen in the agent interface.' =>
            'Wymagane uprawnienia do użycia okna tworzenia zgłoszenia w panelu agenta.',
        'Required permissions to use the ticket forward screen in the agent interface.' =>
            'Wymagane uprawnienia do użycia okna przesłania dalej zgłoszenia w panelu agenta.',
        'Required permissions to use the ticket free text screen in the agent interface.' =>
            'Wymagane uprawnienia do użycia okna tekstu zgłoszenia w panelu agenta.',
        'Required permissions to use the ticket merge screen of a zoomed ticket in the agent interface.' =>
            'Wymagane uprawnienia do użycia okna połaczenia przybliżonych zgłoszeń w panelu agenta.',
        'Required permissions to use the ticket note screen in the agent interface.' =>
            'Wymagane uprawnienia do użycia okna notatki zgłoszenia w panelu agenta.',
        'Required permissions to use the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Wymagane uprawnienia do użycia okna właściciela przybliżonego zgłoszenia w panelu agenta.',
        'Required permissions to use the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Wymagane uprawnienia do użycia okna zgłoszeń oczekujących w panelu agenta.',
        'Required permissions to use the ticket phone inbound screen in the agent interface.' =>
            'Wymagane uprawnienia do użycia okna zgłoszeń telefonicznych przychodzących w panelu agenta.',
        'Required permissions to use the ticket phone outbound screen in the agent interface.' =>
            'Wymagane uprawnienia do użycia okna zgłoszeń telefonicznych wychodzących w panelu agenta.',
        'Required permissions to use the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Wymagane uprawnienia do użycia okna priorytetu zgłoszeń przybliżonych w panelu agenta.',
        'Required permissions to use the ticket responsible screen in the agent interface.' =>
            'Wymagane uprawnienia do użycia okna odpowiedzialnych za zgłoszenie w panelu agenta.',
        'Resets and unlocks the owner of a ticket if it was moved to another queue.' =>
            'Resetuje i odblokowuje właściciela jeśli zgłoszenie zostało przesunięte do innej kolejki.',
        'Restores a ticket from the archive (only if the event is a state change, from closed to any open available state).' =>
            'Odtwarza zgłoszenie z archiwum (tylko jeśli zdarzenie zmienia status z zamkniętego do dowolnego otwartego).',
        'Retains all services in listings even if they are children of invalid elements.' =>
            '',
        'Right' => '',
        'Roles <-> Groups' => 'Role <-> Grupy',
        'Running Process Tickets' => '',
        'Runs an initial wildcard search of the existing customer company when accessing the AdminCustomerCompany module.' =>
            '',
        'Runs an initial wildcard search of the existing customer users when accessing the AdminCustomerUser module.' =>
            '',
        'Runs the system in "Demo" mode. If set to "Yes", agents can change preferences, such as selection of language and theme via the agent web interface. These changes are only valid for the current session. It will not be possible for agents to change their passwords.' =>
            '',
        'S/MIME Certificate Upload' => 'Wgrywanie certyfikatu S/MIME',
        'Sample command output' => '',
        'Saves the attachments of articles. "DB" stores all data in the database (not recommended for storing big attachments). "FS" stores the data on the filesystem; this is faster but the webserver should run under the OTRS user. You can switch between the modules even on a system that is already in production without any loss of data.' =>
            '',
        'Schedule a maintenance period.' => '',
        'Search Customer' => 'Szukaj klienta',
        'Search User' => 'Szukaj użytkownika',
        'Search backend default router.' => '',
        'Search backend router.' => '',
        'Second Queue' => '',
        'Select your frontend Theme.' => 'Wybierz schemat wyglądu systemu.',
        'Selects the cache backend to use.' => 'Wybiera program cache do użycia',
        'Selects the module to handle uploads via the web interface. "DB" stores all uploads in the database, "FS" uses the file system.' =>
            '',
        'Selects the ticket number generator module. "AutoIncrement" increments the ticket number, the SystemID and the counter are used with SystemID.counter format (e.g. 1010138, 1010139). With "Date" the ticket numbers will be generated by the current date, the SystemID and the counter. The format looks like Year.Month.Day.SystemID.counter (e.g. 200206231010138, 200206231010139). With "DateChecksum"  the counter will be appended as checksum to the string of date and SystemID. The checksum will be rotated on a daily basis. The format looks like Year.Month.Day.SystemID.Counter.CheckSum (e.g. 2002070110101520, 2002070110101535). "Random" generates randomized ticket numbers in the format "SystemID.Random" (e.g. 100057866352, 103745394596).' =>
            '',
        'Send me a notification if a customer sends a follow up and I\'m the owner of the ticket or the ticket is unlocked and is in one of my queues/services.' =>
            '',
        'Send me a notification if the service of a ticket is changed to a service in "My Services" and the ticket is in a queue where I have read permissions.' =>
            '',
        'Send me a notification if there is a new ticket in my queues/services.' =>
            '',
        'Send new ticket notifications if subscribed to' => '',
        'Send notifications to users.' => 'Wyślij powiadomienie do użytkowników',
        'Send service update notifications' => '',
        'Send ticket follow up notifications if subscribed to' => '',
        'Sender type for new tickets from the customer inteface.' => 'Rodzaj wysyłającego dla nowych zgłoszeń z interfejsu klienta.',
        'Sends agent follow-up notification only to the owner, if a ticket is unlocked (the default is to send the notification to all agents).' =>
            '',
        'Sends all outgoing email via bcc to the specified address. Please use this only for backup reasons.' =>
            'Umieszna wskazany adres jako BCC dla wszystkich wychodzących wiadomości e-mail. Proszę korzystać jedynie dla tworzenia kopii zapasowych.',
        'Sends customer notifications just to the mapped customer. Normally, if no customer is mapped, the latest customer sender gets the notification.' =>
            '',
        'Sends reminder notifications of unlocked ticket after reaching the reminder date (only sent to ticket owner).' =>
            '',
        'Sends the notifications which are configured in the admin interface under "Notfication (Event)".' =>
            'Wysyła powiadomienia skonfigurowane w interfejsie administracyjnym pod "Notyfikacje (wydarzenia)".',
        'Service update notification' => '',
        'Service view' => '',
        'Set sender email addresses for this system.' => 'Ustaw adresa nadawcy dla tego systemu',
        'Set the default height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            'Ustaw domyślną wysokość (w pixelach) dla artykułów HTML w AgentTicketZoom',
        'Set the maximum height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            'Ustaw maksymalną wysokość (w pixelach) dla artykułów HTML w AgentTicketZoom',
        'Set this to yes if you trust in all your public and private pgp keys, even if they are not certified with a trusted signature.' =>
            'Ustaw na tak jeśli ufasz wszystkim swoim kluczom publicznym i prywatnym, nawet jeśli nie są one certifykowane zaufanym podpisem.',
        'Sets if SLA must be selected by the agent.' => 'Ustawia czy SLA musi zostać wybrane przez agenta.',
        'Sets if SLA must be selected by the customer.' => 'Ustawia czy SLA musi zostać wybrane przez klienta.',
        'Sets if note must be filled in by the agent. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            '',
        'Sets if service must be selected by the agent.' => 'Ustawia czy serwis musi zostać wybrany przez agenta.',
        'Sets if service must be selected by the customer.' => 'Ustawia czy serwis musi zostać wybrany przez klienta.',
        'Sets if ticket owner must be selected by the agent.' => 'Ustawia czy właściciel zgłoszenia musi zostać wybrany przez agenta.',
        'Sets the PendingTime of a ticket to 0 if the state is changed to a non-pending state.' =>
            '',
        'Sets the age in minutes (first level) for highlighting queues that contain untouched tickets.' =>
            'Ustawia czas w minutach (pierwzy poziom) dla wyróżnienia kolejek z nierozpoczętymi zgłoszeniami.',
        'Sets the age in minutes (second level) for highlighting queues that contain untouched tickets.' =>
            'Ustawia czas w minutach (drugi poziom) dla wyróżnienia kolejek z nierozpoczętymi zgłoszeniami.',
        'Sets the configuration level of the administrator. Depending on the config level, some sysconfig options will be not shown. The config levels are in in ascending order: Expert, Advanced, Beginner. The higher the config level is (e.g. Beginner is the highest), the less likely is it that the user can accidentally configure the system in a way that it is not usable any more.' =>
            'Ustawia poziom konfiguracji dla administratora. Zależnie od poziomu konfiguracji niektóre opcje mogą być niewidoczne. Poziomy trudności są w kolejności wznoszącej: Ekspert, Zaawansowany, Początkujący. Nim wyższy poziom kongifu (np. Początkujacy jest najwyższy) tym mniej prawdopodobne by użytkownik nieumyślnie skofigurował system w sposób który nie pozwala na dalsze jego użycie.',
        'Sets the count of articles visible in preview mode of ticket overviews.' =>
            '',
        'Sets the default article type for new email tickets in the agent interface.' =>
            'Ustawia domyślny typ artykułów dla nowych zgłoszeń e-mail w interfejsie agenta.',
        'Sets the default article type for new phone tickets in the agent interface.' =>
            'Ustawia domyślny typ artykułów dla nowych zgłoszeń telefonicznych w interfejsie agenta.',
        'Sets the default body text for notes added in the close ticket screen of the agent interface.' =>
            'Ustawia domyślną treść dla notatek dodanych w oknie zamknięcia zgłoszenia interfejsu agenta.',
        'Sets the default body text for notes added in the ticket move screen of the agent interface.' =>
            'Ustawia domyślną treść dla notatek dodanych w oknie przesunięcia zgłoszenia interfejsu agenta.',
        'Sets the default body text for notes added in the ticket note screen of the agent interface.' =>
            'Ustawia domyślną treść dla notatek dodanych w oknie notatki zgłoszenia interfejsu agenta.',
        'Sets the default body text for notes added in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Ustawia domyślną treść dla notatek dodanych w oknie właściciela przybliżonego zgłoszenia interfejsu agenta.',
        'Sets the default body text for notes added in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Ustawia domyślną treść dla notatek dodanych w oknie oczekującego przybliżonego zgłoszenia interfejsu agenta.',
        'Sets the default body text for notes added in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Ustawia domyślną treść dla notatek dodanych w oknie priorytetu przybliżonego zgłoszenia interfejsu agenta.',
        'Sets the default body text for notes added in the ticket responsible screen of the agent interface.' =>
            'Ustawia domyślną treść dla notatek dodanych w oknie odpowiedzialnego za zgłoszenie w interfejsie agenta.',
        'Sets the default error message for the login screen on Agent and Customer interface, it\'s shown when a running system maintenance period is active.' =>
            '',
        'Sets the default link type of splitted tickets in the agent interface.' =>
            'Ustawia domyślny rodzaj połączenia dla podzielonych zgłoszeń w interfejsie agenta.',
        'Sets the default message for the login screen on Agent and Customer interface, it\'s shown when a running system maintenance period is active.' =>
            '',
        'Sets the default message for the notification is shown on a running system maintenance period.' =>
            '',
        'Sets the default next state for new phone tickets in the agent interface.' =>
            'Ustawia domyślny kolejny stan dla nowych zgłoszeń telefonicznych w interfejsie agenta.',
        'Sets the default next ticket state, after the creation of an email ticket in the agent interface.' =>
            'Ustawia domyślny kolejny stan zgłoszeń po  w interfejsie agenta.',
        'Sets the default note text for new telephone tickets. E.g \'New ticket via call\' in the agent interface.' =>
            '',
        'Sets the default priority for new email tickets in the agent interface.' =>
            'Ustawia domyślny priorytet dla zgłoszeń e-mailowych w interfejsie agenta',
        'Sets the default priority for new phone tickets in the agent interface.' =>
            'Ustawia domyślny priorytet dla zgłoszeń telefonicznych w interfejsie agenta',
        'Sets the default sender type for new email tickets in the agent interface.' =>
            'Ustawia domyślny typ nadawcy dla zgłoszeń e-mailowych w interfejsie agenta',
        'Sets the default sender type for new phone ticket in the agent interface.' =>
            'Ustawia domyślny typ nadawcy dla zgłoszeń telefonicznych w interfejsie agenta',
        'Sets the default subject for new email tickets (e.g. \'email Outbound\') in the agent interface.' =>
            'Ustawia domyślny temat dla nowych zgłoszeń e-mailowych (np. \'E-mail wychodzący\') w interfejsie agenta.',
        'Sets the default subject for new phone tickets (e.g. \'Phone call\') in the agent interface.' =>
            'Ustawia domyślny temat dla nowych zgłoszeń telefonicznych (np. \'Telefon\') w interfejsie agenta.',
        'Sets the default subject for notes added in the close ticket screen of the agent interface.' =>
            'Ustawia domyślny tytuł dla notatek dodanych w oknie zamknięcia zgłoszenia interfejsu agenta.',
        'Sets the default subject for notes added in the ticket move screen of the agent interface.' =>
            'Ustawia domyślny tytuł dla notatek dodanych w oknie przesunięcia zgłoszenia interfejsu agenta.',
        'Sets the default subject for notes added in the ticket note screen of the agent interface.' =>
            'Ustawia domyślny tytuł dla notatek dodanych w oknie notatki zgłoszeniaa interfejsu agenta.',
        'Sets the default subject for notes added in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Ustawia domyślny tytuł dla notatek dodanych w oknie właściciela przybliżonego zgłoszenia w interfejsie agenta.',
        'Sets the default subject for notes added in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Ustawia domyślny tytuł dla notatek dodanych w oknie oczekuwania przybliżonego zgłoszenia w interfejsie agenta.',
        'Sets the default subject for notes added in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Ustawia domyślny tytuł dla notatek dodanych w oknie priorytetu przybliżonego zgłoszenia w interfejsie agenta.',
        'Sets the default subject for notes added in the ticket responsible screen of the agent interface.' =>
            'Ustawia domyślny tytuł dla notatek dodanych w oknie odpowiedzialnego za zgłoszenie w interfejsie agenta.',
        'Sets the default text for new email tickets in the agent interface.' =>
            'Ustawia domyślny tekst dla nowych zgłoszeń e-mailowych w interfejsie agenta.',
        'Sets the display order of the different items in the preferences view.' =>
            'Ustawia kolejność wyświetlania dla różnych pozycji w widoku ustawień.',
        'Sets the inactivity time (in seconds) to pass before a session is killed and a user is loged out.' =>
            'Ustawia czas nieaktywnośći (w sekundach) nim sesja zostanie zakończona i użytkownik zostanie wylogowany.',
        'Sets the maximum number of active agents within the timespan defined in SessionActiveTime.' =>
            'Ustawia maksymalną liczbę aktywnych agentów w okresie czasu zdefiniowanym w SessionActiveTime.',
        'Sets the maximum number of active customers within the timespan defined in SessionActiveTime.' =>
            'Ustawia maksymalną liczbę aktywnych klientów w okresie czasu zdefiniowanym w SessionActiveTime.',
        'Sets the maximum number of active sessions per agent within the timespan defined in SessionActiveTime.' =>
            '',
        'Sets the maximum number of active sessions per customers within the timespan defined in SessionActiveTime.' =>
            '',
        'Sets the minimal ticket counter size (if "AutoIncrement" was selected as TicketNumberGenerator). Default is 5, this means the counter starts from 10000.' =>
            '',
        'Sets the minutes a notification is shown for notice about upcoming system maintenance period.' =>
            '',
        'Sets the number of lines that are displayed in text messages (e.g. ticket lines in the QueueZoom).' =>
            'Ustawia liczbę linii widocznych w wiadomościach tekstowych (np. linie zgłoszenia w QueueZoom)',
        'Sets the options for PGP binary.' => 'Ustawia opcje dla programu PGP',
        'Sets the order of the different items in the customer preferences view.' =>
            'Ustawia kolejność dla różnych pozycji w widoku ustawień klienta.',
        'Sets the password for private PGP key.' => 'Ustawia hasło dla klucza prywatnego PGP',
        'Sets the prefered time units (e.g. work units, hours, minutes).' =>
            'Ustawia preferowaane jednostki czasu (np. Jednostki pracy, godziny, minuty).',
        'Sets the prefix to the scripts folder on the server, as configured on the web server. This setting is used as a variable, OTRS_CONFIG_ScriptAlias which is found in all forms of messaging used by the application, to build links to the tickets within the system.' =>
            '',
        'Sets the queue in the ticket close screen of a zoomed ticket in the agent interface.' =>
            'Ustawia kolejkę w przybliżonym oknie zamkniętych zgłoszeń w interfejsie agenta.',
        'Sets the queue in the ticket free text screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the queue in the ticket note screen of a zoomed ticket in the agent interface.' =>
            'Ustawia kolejkę w przybliżonym oknie notatek zgłoszeń w interfejsie agenta.',
        'Sets the queue in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Ustawia kolejkę w przybliżonym oknie właściciela zgłoszeń w interfejsie agenta.',
        'Sets the queue in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Ustawia kolejkę w przybliżonym oknie oczekujących zgłoszeń w interfejsie agenta.',
        'Sets the queue in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Ustawia kolejkę w przybliżonym oknie priorytetu zgłoszeń w interfejsie agenta.',
        'Sets the queue in the ticket responsible screen of a zoomed ticket in the agent interface.' =>
            'Ustawia kolejkę w przybliżonym oknie odpowiedzialnego za zgłoszenia w interfejsie agenta.',
        'Sets the responsible agent of the ticket in the close ticket screen of the agent interface.' =>
            'Ustawia odpowiedzialnego za zgłoszenie agenta w oknie zamkniętych zgłoszeń interfejsu agenta.',
        'Sets the responsible agent of the ticket in the ticket bulk screen of the agent interface.' =>
            'Ustawia odpowiedzialnego za zgłoszenie agenta w oknie zbiorczym zgłoszeń interfejsu agenta.',
        'Sets the responsible agent of the ticket in the ticket free text screen of the agent interface.' =>
            'Ustawia odpowiedzialnego za zgłoszenie agenta w oknie tekstu zgłoszeń interfejsu agenta.',
        'Sets the responsible agent of the ticket in the ticket note screen of the agent interface.' =>
            'Ustawia odpowiedzialnego za zgłoszenie agenta w oknie notatek zgłoszeń interfejsu agenta.',
        'Sets the responsible agent of the ticket in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Ustawia odpowiedzialnego za zgłoszenie agenta w oknie właściciela przybliżonych zgłoszeń w interfejsie agenta.',
        'Sets the responsible agent of the ticket in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Ustawia odpowiedzialnego za zgłoszenie agenta w oknie oczekujących przybliżonych zgłoszeń w interfejsie agenta.',
        'Sets the responsible agent of the ticket in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Ustawia odpowiedzialnego za zgłoszenie agenta w oknie priorytetu przybliżonych zgłoszeń w interfejsie agenta.',
        'Sets the responsible agent of the ticket in the ticket responsible screen of the agent interface.' =>
            'Ustawia odpowiedzialnego za zgłoszenie agenta w oknie odpowiedzialnego za zgłoszenia interfejsu agenta.',
        'Sets the service in the close ticket screen of the agent interface (Ticket::Service needs to be activated).' =>
            'Ustawia serwis w oknie zamknięcia zgłoszenia interfejsu agenta (Ticket::Service musi być aktywowany).',
        'Sets the service in the ticket free text screen of the agent interface (Ticket::Service needs to be activated).' =>
            'Ustawia serwis w oknie tekstu zgłoszenia interfejsu agenta (Ticket::Service musi być aktywowany).',
        'Sets the service in the ticket note screen of the agent interface (Ticket::Service needs to be activated).' =>
            'Ustawia serwis w oknie notatek zgłoszenia interfejsu agenta (Ticket::Service musi być aktywowany).',
        'Sets the service in the ticket owner screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).' =>
            'Ustawia serwis w oknie właściciela zgłoszenia interfejsu agenta (Ticket::Service musi być aktywowany).',
        'Sets the service in the ticket pending screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).' =>
            'Ustawia serwis w oknie oczekującego zgłoszenia interfejsu agenta (Ticket::Service musi być aktywowany).',
        'Sets the service in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).' =>
            'Ustawia serwis w oknie priorytetu zgłoszenia interfejsu agenta (Ticket::Service musi być aktywowany).',
        'Sets the service in the ticket responsible screen of the agent interface (Ticket::Service needs to be activated).' =>
            'Ustawia serwis w oknie odpowiedzialnego za zgłoszenie interfejsu agenta (Ticket::Service musi być aktywowany).',
        'Sets the size of the statistic graph.' => 'Ustawia rozmiar dla wykkresu statystyk.',
        'Sets the stats hook.' => '',
        'Sets the system time zone (required a system with UTC as system time). Otherwise this is a diff time to the local time.' =>
            'Ustawia strefę czasową systemu (wymagany system używajacy UTC jako czas systemowy). W innym przypadku będzie to jedynie różnica do czasu lokalnego.',
        'Sets the ticket owner in the close ticket screen of the agent interface.' =>
            'Ustawia właściciela zgłoszenia w oknie zakniętego zgłoszenia interfejsu agenta.',
        'Sets the ticket owner in the ticket bulk screen of the agent interface.' =>
            'Ustawia właściciela zgłoszenia w oknie zbiorczym zgłoszeń interfejsu agenta.',
        'Sets the ticket owner in the ticket free text screen of the agent interface.' =>
            'Ustawia właściciela zgłoszenia w oknie tekstu zgłoszenia interfejsu agenta.',
        'Sets the ticket owner in the ticket note screen of the agent interface.' =>
            'Ustawia właściciela zgłoszenia w oknie notatek zgłoszenia interfejsu agenta.',
        'Sets the ticket owner in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Ustawia właściciela zgłoszenia w oknie właściciela zgłoszenia interfejsu agenta.',
        'Sets the ticket owner in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Ustawia właściciela zgłoszenia w oknie oczekującego zgłoszenia interfejsu agenta.',
        'Sets the ticket owner in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Ustawia właściciela zgłoszenia w oknie priorytetu przybliżonego zgłoszenia w interfejsie agenta.',
        'Sets the ticket owner in the ticket responsible screen of the agent interface.' =>
            'Ustawia właściciela zgłoszenia w oknie odpowiedzialnego w interfejsie agenta.',
        'Sets the ticket type in the close ticket screen of the agent interface (Ticket::Type needs to be activated).' =>
            'Ustawia typ zgłoszenia w oknie zamkniętego zgłoszenia interfejsu agenta (Ticket::Type musi być aktywowany).',
        'Sets the ticket type in the ticket bulk screen of the agent interface.' =>
            'Ustawia typ zgłoszenia w oknie zbiorczym zgłoszenia interfejsu agenta ',
        'Sets the ticket type in the ticket free text screen of the agent interface (Ticket::Type needs to be activated).' =>
            'Ustawia typ zgłoszenia w oknie tekstowym zgłoszenia interfejsu agenta (Ticket::Type musi być aktywowany).',
        'Sets the ticket type in the ticket note screen of the agent interface (Ticket::Type needs to be activated).' =>
            'Ustawia typ zgłoszenia w oknie notatek zgłoszenia interfejsu agenta (Ticket::Type musi być aktywowany).',
        'Sets the ticket type in the ticket owner screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).' =>
            'Ustawia typ zgłoszenia w oknie właściciela zgłoszenia interfejsu agenta (Ticket::Type musi być aktywowany).',
        'Sets the ticket type in the ticket pending screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).' =>
            'Ustawia typ zgłoszenia w oknie oczekującego zgłoszenia interfejsu agenta (Ticket::Type musi być aktywowany).',
        'Sets the ticket type in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).' =>
            'Ustawia typ zgłoszenia w oknie priorytetu zgłoszenia interfejsu agenta (Ticket::Type musi być aktywowany).',
        'Sets the ticket type in the ticket responsible screen of the agent interface (Ticket::Type needs to be activated).' =>
            'Ustawia typ zgłoszenia w oknie odpowiedzialnego za zgłoszenie interfejsu agenta (Ticket::Type musi być aktywowany).',
        'Sets the time (in seconds) a user is marked as active.' => 'Ustawia czas w (sekundach) w którym użytkownik jest ustawiony jako aktywny.',
        'Sets the time type which should be shown.' => 'Ustawia rodzaj czasu jaki powinien być wyświetlony.',
        'Sets the timeout (in seconds) for http/ftp downloads.' => 'Ustawia limit czasowy (w sekundach) dla pobrań http/ftp.',
        'Sets the timeout (in seconds) for package downloads. Overwrites "WebUserAgent::Timeout".' =>
            'Ustawia limit czasowy (w sekundach) dla pobrań pakietów. Nadpisuje "WebUserAgent::Timeout".',
        'Sets the user time zone per user (required a system with UTC as system time and UTC under TimeZone). Otherwise this is a diff time to the local time.' =>
            'Ustawia strefę czasową systemu (wymagany system używajacy UTC jako czas systemowy oraz UTC jako strefę czasową). W innym przypadku będzie to jedynie różnica do czasu lokalnego.',
        'Sets the user time zone per user based on java script / browser time zone offset feature at login time.' =>
            '',
        'Should the cache data be help in memory?' => '',
        'Should the cache data be stored in the selected cache backend?' =>
            '',
        'Show a responsible selection in phone and email tickets in the agent interface.' =>
            'Pokazuje wybór odpowiedzialnego w zgloszeniach telefonicznych oraz e-mail interfejsu agenta.',
        'Show article as rich text even if rich text writing is disabled.' =>
            '',
        'Show the current owner in the customer interface.' => 'Pokazuje obecnego właściciela w interfejsie klienta.',
        'Show the current queue in the customer interface.' => 'Pokazuje obecną kolejkę w interfejsie klienta.',
        'Shows a count of icons in the ticket zoom, if the article has attachments.' =>
            'Pokazuje licznik ikon w przybliżeniu zgłoszenia, jeśli artykuł zawiera załączniki.',
        'Shows a link in the menu for subscribing / unsubscribing from a ticket in the ticket zoom view of the agent interface.' =>
            'Pokazuje w menu link do subsrybowania / zakończenia subskrypcji zgłoszenia w przybliżonym widoku zgłoszeń interfejsu agenta.',
        'Shows a link in the menu that allows linking a ticket with another object in the ticket zoom view of the agent interface.' =>
            'Pokazuje w menu link do linkowania zgłoszenia z innym objektem w przybliżonym widoku zgłoszeń interfejsu agenta.',
        'Shows a link in the menu that allows merging tickets in the ticket zoom view of the agent interface.' =>
            'Pokazuje w menu link do łączenia zgłoszeń w przybliżonym widoku zgłoszeń interfejsu agenta.',
        'Shows a link in the menu to access the history of a ticket in the ticket zoom view of the agent interface.' =>
            'Pokazuje w menu link dostępowy do historii zgłoszenia w przybliżonym widoku zgłoszeń interfejsu agenta.',
        'Shows a link in the menu to add a free text field in the ticket zoom view of the agent interface.' =>
            'Pokazuje w menu link do dodania pola tekstowego w przybliżonym widoku zgłoszeń interfejsu agenta.',
        'Shows a link in the menu to add a note in the ticket zoom view of the agent interface.' =>
            'Pokazuje w menu link do dodania notatki w przybliżonym widoku zgłoszenia interfejsu agenta.',
        'Shows a link in the menu to add a note to a ticket in every ticket overview of the agent interface.' =>
            'Pokazuje w menu link do dodania notatki do zgłoszenia w kazdym podglądzie zgłoszenia interfejsu agenta.',
        'Shows a link in the menu to close a ticket in every ticket overview of the agent interface.' =>
            'Pokazuje w menu link do zamknięcia zgłoszenia w każdym zgłoszeniu interfejsu agenta.',
        'Shows a link in the menu to close a ticket in the ticket zoom view of the agent interface.' =>
            'Pokazuje w menu link do zamknięcia zgłoszenia w przybliżonym widoku zgloszenia interfejsu agenta.',
        'Shows a link in the menu to delete a ticket in every ticket overview of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Shows a link in the menu to delete a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Shows a link in the menu to enroll a ticket into a process in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to go back in the ticket zoom view of the agent interface.' =>
            'Pokazuje w menu link wstecz w widoku przybliżonego zgłoszenia interfejsu agenta.',
        'Shows a link in the menu to lock / unlock a ticket in the ticket overviews of the agent interface.' =>
            'Pokazuje w menu link zalokowania / odblokowania zgłoszenia w przeglądzie zgłoszeń interfejsu agenta.',
        'Shows a link in the menu to lock/unlock tickets in the ticket zoom view of the agent interface.' =>
            'Pokazuje w menu link zalokowania / odblokowania zgłoszeń w przybliżonym widoku zgłoszeń interfejsu agenta.',
        'Shows a link in the menu to move a ticket in every ticket overview of the agent interface.' =>
            'Pokazuje w menu link przeniesienia zgłoszenia w poglądzie każdego zgłoszenia interfejsu agenta.',
        'Shows a link in the menu to print a ticket or an article in the ticket zoom view of the agent interface.' =>
            'Pokazuje w menu link drukowania zgłoszenia lub artykułu przybliżonego widoku zgłoszeń interfejsu agenta.',
        'Shows a link in the menu to see the customer who requested the ticket in the ticket zoom view of the agent interface.' =>
            'Pokazuje w menu link ukazania klienta który złorzył zgłoszenie przybliżonego widoku zgłoszeń interfejsu agenta.',
        'Shows a link in the menu to see the history of a ticket in every ticket overview of the agent interface.' =>
            'Pokazuje w menu link ukazania historii zgłoszenia w przeglądzie każdego zgłoszenia interfejsu agenta.',
        'Shows a link in the menu to see the owner of a ticket in the ticket zoom view of the agent interface.' =>
            'Pokazuje w menu link ukazania właściciela zgłoszenia w widoku przybliżonym zgłoszeń interfejsu agenta.',
        'Shows a link in the menu to see the priority of a ticket in the ticket zoom view of the agent interface.' =>
            'Pokazuje w menu link ukazania priorytetu zgłoszenia w widoku przybliżonym zgłoszeń interfejsu agenta.',
        'Shows a link in the menu to see the responsible agent of a ticket in the ticket zoom view of the agent interface.' =>
            'Pokazuje w menu link ukazania odpowiedzialnego agenta w widoku przybliżonym zgłoszeń interfejsu agenta.',
        'Shows a link in the menu to send an outbound email in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to set a ticket as pending in the ticket zoom view of the agent interface.' =>
            'Pokazuje w menu link ustawienia zgłoszenia jako oczekujące w widoku przybliżonym zgłoszeń interfejsu agenta.',
        'Shows a link in the menu to set a ticket as spam in every ticket overview of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Pokazuje w menu link ustawienia zgłoszenia jako spam w przeglądzie zgłoszeń interfejsu agenta. Dodatkowa kontrola dostępu by pokazac lub nie ten link może być wykonana przy użyciu klucza "Grupa" i Zawartości jak "rw:group1;move_into:group2".',
        'Shows a link in the menu to set the priority of a ticket in every ticket overview of the agent interface.' =>
            'Pokazuje w menu link ustawienia priorytetu zgłoszenia w przeglądzie zgłoszeń interfejsu agenta.',
        'Shows a link in the menu to zoom a ticket in the ticket overviews of the agent interface.' =>
            'Pokazuje w menu link do przybliżenia zgłoszenia w oidglądach zgłoszeń interfejsu agenta.',
        'Shows a link to access article attachments via a html online viewer in the zoom view of the article in the agent interface.' =>
            'Pokazuje link dostępu do załączników artykułow w przeglądarce html w widoku przyblizonym artykułu w interfejsie agenta.',
        'Shows a link to download article attachments in the zoom view of the article in the agent interface.' =>
            'Pokazuje link do ściągnięcia załączników artykułu w widoku przybliżonym artykułow w interfejsie agenta.',
        'Shows a link to see a zoomed email ticket in plain text.' => 'Pokazuje link ukazujący przybliżone zgłoszenia e-mail w czystym tekście. ',
        'Shows a link to set a ticket as spam in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Pokazuje link ustawiający zgłoszenie jako spam w widoku przybliżającym zgłoszenie interfejs agenta. Dodatkowa kontrola dostępu by ukazać lub nie link może zostac wykonana  przy użyciu klucza "Grupa" i Zawartości jak "rw:group1;move_into:group2".',
        'Shows a list of all the involved agents on this ticket, in the close ticket screen of the agent interface.' =>
            'Pokazuje listę agentów związanych z tym zgłoszeniem w oknie zamkniętego zgłoszenia interfejsu agenta.',
        'Shows a list of all the involved agents on this ticket, in the ticket free text screen of the agent interface.' =>
            'Pokazuje listę agentów związanych z tym zgłoszeniem w oknie tekstu zgłoszenia interfejsu agenta.',
        'Shows a list of all the involved agents on this ticket, in the ticket note screen of the agent interface.' =>
            'Pokazuje listę agentów związanych z tym zgłoszeniem w oknie notatek zgłoszenia interfejsu agenta.',
        'Shows a list of all the involved agents on this ticket, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Pokazuje listę agentów związanych z tym zgłoszeniem w oknie właściciela przybliżonego zgłoszenia w interfejsie agenta.',
        'Shows a list of all the involved agents on this ticket, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Pokazuje listę agentów związanych z tym zgłoszeniem w oknie oczekujacego przybliżonego zgłoszenia w interfejsie agenta.',
        'Shows a list of all the involved agents on this ticket, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Pokazuje listę agentów związanych z tym zgłoszeniem w oknie priorytetu przybliżonego zgłoszenia w interfejsie agenta.',
        'Shows a list of all the involved agents on this ticket, in the ticket responsible screen of the agent interface.' =>
            'Pokazuje listę agentów związanych z tym zgłoszeniem w oknie odpowiedzialnego za zgłoszenie interfejsu agenta.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the close ticket screen of the agent interface.' =>
            'Pokazuje listę wszystkich możliwych agenetów (wszyscy agenci z uprawnieniami do notatek na kolejce / zgłoszeniu) by okreslić kto powinien zostać powiadomiony o notatce w oknie zamkniętego zgłoszenia interfejsu agenta.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket free text screen of the agent interface.' =>
            'Pokazuje listę wszystkich możliwych agenetów (wszyscy agenci z uprawnieniami do notatek na kolejce / zgłoszeniu) by okreslić kto powinien zostać powiadomiony o notatce w oknie tekstowym zgłoszenia interfejsu agenta.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket note screen of the agent interface.' =>
            'Pokazuje listę wszystkich możliwych agenetów (wszyscy agenci z uprawnieniami do notatek na kolejce / zgłoszeniu) by okreslić kto powinien zostać powiadomiony o notatce w oknie notatek zgłoszenia interfejsu agenta.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Pokazuje listę wszystkich możliwych agenetów (wszyscy agenci z uprawnieniami do notatek na kolejce / zgłoszeniu) by okreslić kto powinien zostać powiadomiony o notatce w oknie właściciela zgłoszenia w interfejsie agenta.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Pokazuje listę wszystkich możliwych agenetów (wszyscy agenci z uprawnieniami do notatek na kolejce / zgłoszeniu) by okreslić kto powinien zostać powiadomiony o notatce w oknie oczekującego przybliżonego zgłoszenia w interfejsie agenta.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Pokazuje listę wszystkich możliwych agenetów (wszyscy agenci z uprawnieniami do notatek na kolejce / zgłoszeniu) by okreslić kto powinien zostać powiadomiony o notatce w oknie priorytetu przybliżonego zgłoszenia w interfejsie agenta.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket responsible screen of the agent interface.' =>
            'Pokazuje listę wszystkich możliwych agenetów (wszyscy agenci z uprawnieniami do notatek na kolejce / zgłoszeniu) by okreslić kto powinien zostać powiadomiony o notatce w oknie odpowiedzialnego za zgłoszenie interfejsu agenta.',
        'Shows a preview of the ticket overview (CustomerInfo => 1 - shows also Customer-Info, CustomerInfoMaxSize max. size in characters of Customer-Info).' =>
            '',
        'Shows a select of ticket attributes to order the queue view ticket list. The possible selections can be configured via \'TicketOverviewMenuSort###SortAttributes\'.' =>
            '',
        'Shows all both ro and rw queues in the queue view.' => 'Pokazuje kolejki ro i rw w widoku kolejek.',
        'Shows all both ro and rw tickets in the service view.' => '',
        'Shows all open tickets (even if they are locked) in the escalation view of the agent interface.' =>
            'Pokazuje wszystkie otwarte zgłoszenia (nawet jeśli sa zablokowane) w widoku eskalacji interfejsu agenta.',
        'Shows all open tickets (even if they are locked) in the status view of the agent interface.' =>
            'Pokazuje wszystkie otwarte zgłoszenia (nawet jeśli sa zablokowane) w widoku statusu interfejsu agenta.',
        'Shows all the articles of the ticket (expanded) in the zoom view.' =>
            'Pokazuje wszystkie artykuły zgłoszenia (rozszeżone) w oknie przybliżenia.',
        'Shows all the customer identifiers in a multi-select field (not useful if you have a lot of customer identifiers).' =>
            'Pokazuje wszystkie identyfikatory klientów w plou multiwyboru (nieuzyteczne jeśli posiadasz większą ilość identyfikatorów).',
        'Shows an owner selection in phone and email tickets in the agent interface.' =>
            'Pokazuje selekcję właścicieli dla zgłoszeń telefonicznych oraz e-mail interfejsu agenta.',
        'Shows colors for different article types in the article table.' =>
            'Pokazuje odmienne kolory dla różnego rodzaju artykulów w tabeli artykułów.',
        'Shows customer history tickets in AgentTicketPhone, AgentTicketEmail and AgentTicketCustomer.' =>
            'Pokazuje historię klienta dla zgłoszeń  AgentTicketPhone, AgentTicketEmail i AgentTicketCustomer.',
        'Shows either the last customer article\'s subject or the ticket title in the small format overview.' =>
            'Pokazuje ostatni temat artykułu klienta lub tytuł zgłoszenia w podglądzie o małym formacie.',
        'Shows existing parent/child queue lists in the system in the form of a tree or a list.' =>
            'Pokazuje bierzące listy kolejek nadrzędna/podrzędna w systemie w formie drzewa lub listy.',
        'Shows information on how to start OTRS Scheduler' => '',
        'Shows the activated ticket attributes in the customer interface (0 = Disabled and 1 = Enabled).' =>
            'Pokazuje aktywowane atrybuty zgłoszenia w interfejsie klienta (0 = Wyłączony i 1 = Włączony).',
        'Shows the articles sorted normally or in reverse, under ticket zoom in the agent interface.' =>
            'Pokazuje artykuły posortowane w zwykły lub odwrócony sposób pod przybliżeniem zgłoszenia w interfejsie agenta.',
        'Shows the customer user information (phone and email) in the compose screen.' =>
            'Pokazuje informację o kontach klienta (telefon i e-mail) w oknie przyjmowania zgłoszenia',
        'Shows the customer user\'s info in the ticket zoom view.' => 'Pokaż informację o kontach klienta w przybliżonym podglądzie zgłoszeń.',
        'Shows the message of the day (MOTD) in the agent dashboard. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually.' =>
            '',
        'Shows the message of the day on login screen of the agent interface.' =>
            'Pokazuje wiadomość dnia w oknie logowania interfejsu agenta.',
        'Shows the ticket history (reverse ordered) in the agent interface.' =>
            'Pokazuje historię zgłoszenia (w odwróconej kolejności) w interfejsie agenta.',
        'Shows the ticket priority options in the close ticket screen of the agent interface.' =>
            'Pokazuje opcje priorytetu zgłoszenia w oknie zamkniętego zgłoszenia interfejsu agenta.',
        'Shows the ticket priority options in the move ticket screen of the agent interface.' =>
            'Pokazuje opcje priorytetu zgłoszenia w oknie przeniesionego zgłoszenia interfejsu agenta.',
        'Shows the ticket priority options in the ticket bulk screen of the agent interface.' =>
            'Pokazuje opcje priorytetu zgłoszenia w oknie zbiorczym zgłoszenia interfejsu agenta.',
        'Shows the ticket priority options in the ticket free text screen of the agent interface.' =>
            'Pokazuje opcje priorytetu zgłoszenia w oknie tekstu zgłoszenia interfejsu agenta.',
        'Shows the ticket priority options in the ticket note screen of the agent interface.' =>
            'Pokazuje opcje priorytetu zgłoszenia w oknie notatek zgłoszenia interfejsu agenta.',
        'Shows the ticket priority options in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Pokazuje opcje priorytetu zgłoszenia w oknie właściciela zgłoszenia interfejsu agenta.',
        'Shows the ticket priority options in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Pokazuje opcje priorytetu zgłoszenia w oknie oczekującego przybliżonego zgłoszenia w interfejsie agenta.',
        'Shows the ticket priority options in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Pokazuje opcje priorytetu zgłoszenia w oknie priorytetu przybliżonego zgłoszenia w interfejsie agenta.',
        'Shows the ticket priority options in the ticket responsible screen of the agent interface.' =>
            'Pokazuje opcje priorytetu zgłoszenia w oknie odpowiedzialnego za zgłoszenie interfejsu agenta.',
        'Shows the title fields in the close ticket screen of the agent interface.' =>
            'Pokazuje pola tytułowe w oknie zamkniętego zgłoszenia interfejsu agenta.',
        'Shows the title fields in the ticket free text screen of the agent interface.' =>
            'Pokazuje pola tytułowe w oknie tekstu zgłoszenia interfejsu agenta.',
        'Shows the title fields in the ticket note screen of the agent interface.' =>
            'Pokazuje pola tytułowe w oknie notatki zgłoszenia interfejsu agenta.',
        'Shows the title fields in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Pokazuje pola tytułowe w oknie właściciela przybliżonego zgłoszenia w interfejsie agenta.',
        'Shows the title fields in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Pokazuje pola tytułowe w oknie poczekujacego przybliżonego zgłoszenia w interfejsie agenta.',
        'Shows the title fields in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Pokazuje pola tytułowe w oknie priorytetu przybliżonego zgłoszenia w interfejsie agenta.',
        'Shows the title fields in the ticket responsible screen of the agent interface.' =>
            'Pokazuje pola tytułowe w oknie odpowiedzialnego za zgłoszenie interfejsu agenta.',
        'Shows time in long format (days, hours, minutes), if set to "Yes"; or in short format (days, hours), if set to "No".' =>
            'Pokazuje czas w długim formacie (dni, godziny, minuty) jeśli ustawione na "TAK" lub krótkim (dni, godziny) jeśli ustawione na "NIE"',
        'Shows time use complete description (days, hours, minutes), if set to "Yes"; or just first letter (d, h, m), if set to "No".' =>
            'Pokazuje użycie przez czas długiego formatu (dni, godziny, minuty) jeśli ustawione na "Tak" lub pierwszej litery (d,g,m) jeśli ustawione na "Nie"',
        'Skin' => 'Skórka',
        'SolutionDiffInMin' => 'Różnica rozwiązań w minutach',
        'SolutionInMin' => 'Rozwiązanie w minutach',
        'Some description!' => '',
        'Some picture description!' => '',
        'Sorts the tickets (ascendingly or descendingly) when a single queue is selected in the queue view and after the tickets are sorted by priority. Values: 0 = ascending (oldest on top, default), 1 = descending (youngest on top). Use the QueueID for the key and 0 or 1 for value.' =>
            '',
        'Sorts the tickets (ascendingly or descendingly) when a single queue is selected in the service view and after the tickets are sorted by priority. Values: 0 = ascending (oldest on top, default), 1 = descending (youngest on top). Use the ServiceID for the key and 0 or 1 for value.' =>
            '',
        'Spam Assassin example setup. Ignores emails that are marked with SpamAssassin.' =>
            'Przykładowa konfiguracja SpamAssasina. Ignoruje e-maile oznaczone wraz z SpamAssasin',
        'Spam Assassin example setup. Moves marked mails to spam queue.' =>
            'Przykładowa konfiguracja SpamAssasina. Przenosi wszystkie e-maile do kolejki spam.',
        'Specifies if an agent should receive email notification of his own actions.' =>
            'Wskazuje czy agent powinien otrzymywacc powiadomienia z swoich własnych działań.',
        'Specifies the available note types for this ticket mask. If the option is deselected, ArticleTypeDefault is used and the option is removed from the mask.' =>
            '',
        'Specifies the background color of the chart.' => 'Wskazuje kolor tła wykresu.',
        'Specifies the background color of the picture.' => 'Wskazuje kolor tła zdjęcia.',
        'Specifies the border color of the chart.' => 'Wskazuje kolor ramki wykresu.',
        'Specifies the border color of the legend.' => 'Wskazuje kolor ramki legendy.',
        'Specifies the bottom margin of the chart.' => 'Wskazuje dolny margines wykresu.',
        'Specifies the default article type for the ticket compose screen in the agent interface if the article type cannot be automatically detected.' =>
            '',
        'Specifies the different article types that will be used in the system.' =>
            'Wskazuje różne rodzaje artykułów które będą używane w systemie.',
        'Specifies the different note types that will be used in the system.' =>
            'Wskazuje różne rodzaje notatek które będą używane w systemie.',
        'Specifies the directory to store the data in, if "FS" was selected for TicketStorageModule.' =>
            'Wskazuje katalog do zamieszczenia danych jeśli "FS" został wybrany dla TicketStorageModule.',
        'Specifies the directory where SSL certificates are stored.' => 'Wskazuje katalog w którym umieszczony są certyfikaty SSL.',
        'Specifies the directory where private SSL certificates are stored.' =>
            'Wskazuje katalog w którym umieszczony są prywatne certyfikaty SSL.',
        'Specifies the email address that should be used by the application when sending notifications. The email address is used to build the complete display name for the notification master (i.e. "OTRS Notification Master" otrs@your.example.com). You can use the OTRS_CONFIG_FQDN variable as set in your configuation, or choose another email address. Notifications are messages such as en::Customer::QueueUpdate or en::Agent::Move.' =>
            '',
        'Specifies the group where the user needs rw permissions so that he can access the "SwitchToCustomer" feature.' =>
            'Wskazuje grupę do której użytkownik potrzebuje praw zapisu by uzyskać dostęp do funkcji "SwitchToCustomer".',
        'Specifies the left margin of the chart.' => 'Wskazuje lewy margines wykresu.',
        'Specifies the name that should be used by the application when sending notifications. The sender name is used to build the complete display name for the notification master (i.e. "OTRS Notification Master" otrs@your.example.com). Notifications are messages such as en::Customer::QueueUpdate or en::Agent::Move.' =>
            '',
        'Specifies the order in which the firstname and the lastname of agents will be displayed.' =>
            'Wskazuje kolejność sortowania imion i nazwisk agentów.',
        'Specifies the path of the file for the logo in the page header (gif|jpg|png, 700 x 100 pixel).' =>
            'Wskazuje ścieżkę do pliku dla logo w nagłówku strony (gif|jpg|png, 700 x 100 pixel).',
        'Specifies the path of the file for the performance log.' => 'skazuje ścieżkę do pliku z logiem wydajności.',
        'Specifies the path to the converter that allows the view of Microsoft Excel files, in the web interface.' =>
            'Wskazuje ścieżkę do konwerrtera, który pozwala na otworzenie plików Microsoft Excel w interfejsie webowym.',
        'Specifies the path to the converter that allows the view of Microsoft Word files, in the web interface.' =>
            'Wskazuje ścieżkę do konwerrtera, który pozwala na otworzenie plików Microsoft Word w interfejsie webowym.',
        'Specifies the path to the converter that allows the view of PDF documents, in the web interface.' =>
            'Wskazuje ścieżkę do konwerrtera, który pozwala na otworzenie plików PDF w interfejsie webowym.',
        'Specifies the path to the converter that allows the view of XML files, in the web interface.' =>
            'Wskazuje ścieżkę do konwerrtera, który pozwala na otworzenie plików XML w interfejsie webowym.',
        'Specifies the right margin of the chart.' => 'Wskazuje prawy margines wykresu.',
        'Specifies the text color of the chart (e. g. caption).' => 'Wskazuje kolor tekstu wykresu (np. nagłówka).',
        'Specifies the text color of the legend.' => 'Wskazuje kolor tekstu legendy.',
        'Specifies the text that should appear in the log file to denote a CGI script entry.' =>
            'Wskazuje tekst który powinien zostac wyświetlony w pliku log by oznaczyć wystąpienie skryptu CGI.',
        'Specifies the top margin of the chart.' => 'Wskazuje górny margines wykresu.',
        'Specifies user id of the postmaster data base.' => 'Wskazuje id uzytkownika w pocztowej bazie danych.',
        'Specifies whether all storage backends should be checked when looking for attachements. This is only required for installations where some attachements are in the file system, and others in the database.' =>
            '',
        'Specify how many sub directory levels to use when creating cache files. This should prevent too many cache files being in one directory.' =>
            '',
        'Specify the channel to be used to fetch OTRS Business Solution™ updates. Warning: Development releases might not be complete, your system might experience unrecoverable errors and on extreme cases could become unresponsive!' =>
            '',
        'Standard available permissions for agents within the application. If more permissions are needed, they can be entered here. Permissions must be defined to be effective. Some other good permissions have also been provided built-in: note, close, pending, customer, freetext, move, compose, responsible, forward, and bounce. Make sure that "rw" is always the last registered permission.' =>
            '',
        'Start number for statistics counting. Every new stat increments this number.' =>
            'Liczba początkowa dla wyliczania statystyk. Każda nowa statystyka będzie o tą liczbę wyższa.',
        'Starts a wildcard search of the active object after the link object mask is started.' =>
            '',
        'Stat#' => 'Statystyka#',
        'Statistics' => 'Statystyki',
        'Status view' => 'Widok statusów',
        'Stop words for fulltext index. These words will be removed.' => 'Słowa wstrzymane dla indeksowania pełnotekstowego. Te słowa zostaną usunięte.',
        'Stores cookies after the browser has been closed.' => 'Przechowuje ciasteczka po zakmnięciu przeglądarki.',
        'Strips empty lines on the ticket preview in the queue view.' => 'Usuwa puste linie z podglądu zgłoszenia w widoku kolejki.',
        'Strips empty lines on the ticket preview in the service view.' =>
            '',
        'System Maintenance' => '',
        'System Request (%s).' => 'Żądanie systemowe (%s).',
        'Templates <-> Queues' => 'Szablony <-> Kolejki',
        'Textarea' => 'Obszar tekstu',
        'The "bin/PostMasterMailAccount.pl" will reconnect to POP3/POP3S/IMAP/IMAPS host after the specified count of messages.' =>
            '"bin/PostMasterMailAccount.pl" ponowi połączenie do serwera POP3/POP3S/IMAP/IMAPS po wskazanej ilości wiadomości.',
        'The agent skin\'s InternalName which should be used in the agent interface. Please check the available skins in Frontend::Agent::Skins.' =>
            '',
        'The customer skin\'s InternalName which should be used in the customer interface. Please check the available skins in Frontend::Customer::Skins.' =>
            '',
        'The divider between TicketHook and ticket number. E.g \': \'.' =>
            'Podzielnik pomiędzy TicketHook i numerem zgłoszenia. Np. \': \'.',
        'The duration in minutes after emitting an event, in which the new escalation notify and start events are suppressed.' =>
            '',
        'The format of the subject. \'Left\' means \'[TicketHook#:12345] Some Subject\', \'Right\' means \'Some Subject [TicketHook#:12345]\', \'None\' means \'Some Subject\' and no ticket number. In the last case you should enable PostmasterFollowupSearchInRaw or PostmasterFollowUpSearchInReferences to recognize followups based on email headers and/or body.' =>
            '',
        'The headline shown in the customer interface.' => 'Nagłówek widoczny w interfejsie klienta.',
        'The identifier for a ticket, e.g. Ticket#, Call#, MyTicket#. The default is Ticket#.' =>
            'Identyfikator zgłoszenia np. Ticket#, Call#, MyTicket#. Domyślny to Ticket#.',
        'The logo shown in the header of the agent interface for the skin "default". See "AgentLogo" for further description.' =>
            '',
        'The logo shown in the header of the agent interface for the skin "ivory". See "AgentLogo" for further description.' =>
            '',
        'The logo shown in the header of the agent interface for the skin "ivory-slim". See "AgentLogo" for further description.' =>
            '',
        'The logo shown in the header of the agent interface for the skin "slim". See "AgentLogo" for further description.' =>
            '',
        'The logo shown in the header of the agent interface. The URL to the image can be a relative URL to the skin image directory, or a full URL to a remote web server.' =>
            '',
        'The logo shown in the header of the customer interface. The URL to the image can be a relative URL to the skin image directory, or a full URL to a remote web server.' =>
            '',
        'The logo shown on top of the login box of the agent interface. The URL to the image must be relative URL to the skin image directory.' =>
            '',
        'The maximal number of articles expanded on a single page in AgentTicketZoom.' =>
            '',
        'The maximal number of articles shown on a single page in AgentTicketZoom.' =>
            '',
        'The text at the beginning of the subject in an email reply, e.g. RE, AW, or AS.' =>
            'Tekst na początku tematu w odpowiedziach e-mail np. RE lub Odp.',
        'The text at the beginning of the subject when an email is forwarded, e.g. FW, Fwd, or WG.' =>
            'Tekst na początku tematu w e-mailach przesłanch dalej np. FW lub Fwd.',
        'This event module stores attributes from CustomerUser as DynamicFields tickets. Please see the setting above for how to configure the mapping.' =>
            '',
        'This module and its PreRun() function will be executed, if defined, for every request. This module is useful to check some user options or to display news about new applications.' =>
            '',
        'This option defines the dynamic field in which a Process Management activity entity id is stored.' =>
            'Ta opcja definiuje pole dynamiczne w którym aktywność id Procesu Zarządzania jest zapisana.',
        'This option defines the dynamic field in which a Process Management process entity id is stored.' =>
            'Ta opcja definiuje pole dynamiczne w którym procesy id Procesu Zarządzania są zapisane.',
        'This option defines the process tickets default lock.' => 'Ta opcja definiuje domyślną blokadę dla zgłoszeń procesowych.',
        'This option defines the process tickets default priority.' => 'Ta opcja definiuje domyślny priorytet dla zgłoszeń procesowych.',
        'This option defines the process tickets default queue.' => 'Ta opcja definiuje domyślną kolejkę dla zgłoszeń procesowych.',
        'This option defines the process tickets default state.' => 'Ta opcja definiuje domyślny stan dla zgłoszeń procesowych.',
        'This option will deny the access to customer company tickets, which are not created by the customer user.' =>
            '',
        'This setting allows you to override the built-in country list with your own list of countries. This is particularly handy if you just want to use a small select group of countries.' =>
            '',
        'Ticket Queue Overview' => 'Przegląd zgłoszeń na kolejkach',
        'Ticket event module that triggers the escalation stop events.' =>
            '',
        'Ticket moved into Queue "%s" (%s) from Queue "%s" (%s).' => 'Zgłoszenie przeniesiono do kolejki "%s" (%s) z kolejki "%s" (%s).',
        'Ticket overview' => 'Lista zgłoszeń',
        'TicketNumber' => 'Numer zgłoszenia',
        'Time in seconds that gets added to the actual time if setting a pending-state (default: 86400 = 1 day).' =>
            'Czas w sekundach, ktory zostanie dodany do czasu właściwego jeśli ustawiono stan oczekiwania (domyślnie: 86400 = 1 dzień)',
        'Title updated: Old: "%s", New: "%s"' => 'Zmiana tytułu zgłoszenia',
        'Toggles display of OTRS FeatureAddons list in PackageManager.' =>
            'Przęłacza widok ukazanych dodatków w Menadzeże Pakietów.',
        'Toolbar Item for a shortcut.' => 'Pozycja paska narzędziowego dla skrótu.',
        'Tree view' => '',
        'Turns off SSL certificate validation, for example if you use a transparent HTTPS proxy. Use at your own risk!' =>
            '',
        'Turns on drag and drop for the main navigation.' => '',
        'Turns on the animations used in the GUI. If you have problems with these animations (e.g. performance issues), you can turn them off here.' =>
            'Włącza animacje używane w Interfejsie. Jesli masz problemy z tymi animacjami (np. wydajnościowe) to możesz je tu wyłączyć.',
        'Turns on the remote ip address check. It should be set to "No" if the application is used, for example, via a proxy farm or a dialup connection, because the remote ip address is mostly different for the requests.' =>
            '',
        'Unlock tickets whenever a note is added and the owner is out of office.' =>
            '',
        'Unlocked ticket.' => 'Odblokowano zgłoszenie.',
        'Update Ticket "Seen" flag if every article got seen or a new Article got created.' =>
            '',
        'Update and extend your system with software packages.' => 'Zaktualizuj i rozbuduj swój system przy pomocy pakietów oprogramowania.',
        'Updated SLA to %s (ID=%s).' => 'Zaktualizowano SLA do %s (ID=%s).',
        'Updated Service to %s (ID=%s).' => 'Zaktualizowano usługę do %s (ID=%s).',
        'Updated Type to %s (ID=%s).' => 'Zaktualizowano typ do %s (ID=%s).',
        'Updated: %s' => 'Ustawiony czas przypomnienia: %s',
        'Updated: %s=%s;%s=%s;%s=%s;' => 'Aktualizacja pola dynamicznego: %s=%s;%s=%s;',
        'Updates the ticket escalation index after a ticket attribute got updated.' =>
            'Aktualizuje indeks eskalacji zgłoszenia po zmianie tego atrybutu.',
        'Updates the ticket index accelerator.' => 'Aktualizuje akcelerator indeksu zgłoszeń.',
        'UserFirstname' => 'Imię użytkownika',
        'UserLastname' => 'Nazwisko użytkownika',
        'Uses Cc recipients in reply Cc list on compose an email answer in the ticket compose screen of the agent interface.' =>
            '',
        'Uses richtext for viewing and editing notification events.' => '',
        'Uses richtext for viewing and editing: articles, salutations, signatures, standard templates, auto responses and notifications.' =>
            '',
        'View performance benchmark results.' => 'Objerzyj wyniki testów wydajności systemu',
        'View system log messages.' => 'Podgląd dziennika zdarzeń systemowych',
        'Wear this frontend skin' => 'Użyj wybranej skórki interfejsu',
        'Webservice path separator.' => 'Separator ścieżki serwisów sieciowych.',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. Here you can define the body of this note (this text cannot be changed by the agent).' =>
            '',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. Here you can define the subject of this note (this subject cannot be changed by the agent).' =>
            '',
        'When tickets are merged, the customer can be informed per email by setting the check box "Inform Sender". In this text area, you can define a pre-formatted text which can later be modified by the agents.' =>
            '',
        'Write a new, outgoing mail' => '',
        'Yes, but hide archived tickets' => '',
        'Your queue selection of your favorite queues. You also get notified about those queues via email if enabled.' =>
            'Twój wybór ulubionych kolejek. Będziesz również informowany e-mailami o tych kolejkach jeśli włączysz powiadamianie.',
        'Your service selection of your favorite services. You also get notified about those services via email if enabled.' =>
            '',

    };
    # $$STOP$$
    return;
}

1;
