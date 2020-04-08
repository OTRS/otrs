# --
# Copyright (C) 2003-2010 Tomasz Melissa <janek at rumianek.com>
# Copyright (C) 2009 Artur Skalski <skal.ar at wp.pl>
# Copyright (C) 2011-2013 Informatyka Boguslawski sp. z o.o. sp.k., http://www.ib.pl/
# Copyright (C) 2014 Wojciech Myrda <wmyrda at auticon.pl>, http://www.auticon.pl
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
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
    $Self->{Completeness}        = 0.666610226887911;

    # csv separator
    $Self->{Separator}         = ';';

    $Self->{DecimalSeparator}  = ',';
    $Self->{ThousandSeparator} = ' ';
    $Self->{Translation} = {

        # Template: AdminACL
        'ACL Management' => 'Zarządzanie ACL',
        'Actions' => 'Akcje',
        'Create New ACL' => 'Utwórz nowy ACL',
        'Deploy ACLs' => 'Wdróż ACL',
        'Export ACLs' => 'Eksportuj ACL',
        'Filter for ACLs' => 'Filtr dla ACLi',
        'Just start typing to filter...' => 'Aby filtrować, wystarczy zacząć pisać',
        'Configuration Import' => 'Import konfiguracji',
        'Here you can upload a configuration file to import ACLs to your system. The file needs to be in .yml format as exported by the ACL editor module.' =>
            'Tutaj możesz wgrać pliki konfiguracyjne ACL do systemu. Plik musi być w formacie .yml takim jaki jest eksportowany z modułu edytora ACL.',
        'This field is required.' => 'To pole jest wymagane.',
        'Overwrite existing ACLs?' => 'Nadpisać istniejący ACL?',
        'Upload ACL configuration' => 'Wgraj konfigurację ACL',
        'Import ACL configuration(s)' => 'Importuj konfigurację ACL',
        'Description' => 'Opis',
        'To create a new ACL you can either import ACLs which were exported from another system or create a complete new one.' =>
            'By utworzyć nowy ACL możesz importować te uprzednio eksportowane z innego systemu lub utworzyć kompletnie nowe.',
        'Changes to the ACLs here only affect the behavior of the system, if you deploy the ACL data afterwards. By deploying the ACL data, the newly made changes will be written to the configuration.' =>
            'Zmiany dokonane tu dla reguł ACL będą mieć wpływ na zachowanie systemu dopiero po ich wdrożeniu. Podczas wdrażania danych ACL, zmiany zostaną zapisane w konfiguracji.',
        'ACLs' => 'ACLe',
        'Please note: This table represents the execution order of the ACLs. If you need to change the order in which ACLs are executed, please change the names of the affected ACLs.' =>
            'Proszę zapamiętaj: Ta tabela reprezentuje kolejność wykonania ACLi. Jeśli potrzebujesz by kolejność była inna wówczas proszę zmień odpowiednio ich nazwy.',
        'ACL name' => 'Nazwa ACL',
        'Comment' => 'Komentarz',
        'Validity' => 'Aktualność',
        'Export' => 'Eksport',
        'Copy' => 'Kopia',
        'No data found.' => 'Nie odnaleziono żadnych elementów spełniających kryteria',
        'No matches found.' => 'Nie odnaleziono dopasowań.',

        # Template: AdminACLEdit
        'Edit ACL %s' => 'Edytuj ACL %s',
        'Edit ACL' => 'Edytuj ACL',
        'Go to overview' => 'Idź do przeglądu',
        'Delete ACL' => 'Usuń ACL',
        'Delete Invalid ACL' => 'Usuń nieprawidłowy ACL',
        'Match settings' => 'Dopasuj ustawienia',
        'Set up matching criteria for this ACL. Use \'Properties\' to match the current screen or \'PropertiesDatabase\' to match attributes of the current ticket that are in the database.' =>
            'Ustaw kryteria dla tego ACL. Uzyj \'Własciwości\' by dopasować obecne okno lub \'Właściwości Bazy Danych\' by dopasowac atrybuty obecnego zgłoszenia w bazie danych.',
        'Change settings' => 'Zmień ustawienia',
        'Set up what you want to change if the criteria match. Keep in mind that \'Possible\' is a white list, \'PossibleNot\' a black list.' =>
            'Ustaw co chcesz zmienić jeśli kryteria zostaną spełnione. Prosze zapamiętaj, że \'możliwe\' jest białą listą, \'Niemożliwe\' jest czarną listą',
        'Check the official %sdocumentation%s.' => 'Sprawdź oficjalną %sdokumentację%s',
        'Show or hide the content' => 'Pokaż lub ukryj treść',
        'Edit ACL Information' => 'Edytuj informację ACL',
        'Name' => 'Nazwa',
        'Stop after match' => 'Zatrzymaj po dopasowaniu',
        'Edit ACL Structure' => 'Edytuj strukturę ACL',
        'Save ACL' => 'Zapisz ACL',
        'Save' => 'Zapisz',
        'or' => 'lub',
        'Save and finish' => 'Zapisz i zakończ',
        'Cancel' => 'Anuluj',
        'Do you really want to delete this ACL?' => 'Czy na pewno chcesz usunąć ten ACL?',

        # Template: AdminACLNew
        'Create a new ACL by submitting the form data. After creating the ACL, you will be able to add configuration items in edit mode.' =>
            'Utwórz nowy ACL poprzez wypełnienie formularza danych. Po dodaniu ACL będzie możliwe dodawanie pozycji konfiguracji w trybie edycji.',

        # Template: AdminAppointmentCalendarManage
        'Calendar Management' => 'Zarządzanie Kalendarzami',
        'Add Calendar' => 'Dodaj Kalendarz',
        'Edit Calendar' => 'Edytuj Kalendarz',
        'Calendar Overview' => 'Przegląd Kalendarzy',
        'Add new Calendar' => 'Dodaj nowy Kalendarz',
        'Import Appointments' => 'Zaimportuj Wydarzenia',
        'Calendar Import' => 'Import Kalendarza',
        'Here you can upload a configuration file to import a calendar to your system. The file needs to be in .yml format as exported by calendar management module.' =>
            'W tym miejscu możesz załadować plik konfiguracyjny by zaimportować kalendarz to systemu. Plik musi być w formacie .yml, podobnie jak wyeksportowany moduł zarządzania kalendarzem.',
        'Overwrite existing entities' => 'Nadpisać istniejące encje',
        'Upload calendar configuration' => 'Wczytaj konfigurację kalendarza',
        'Import Calendar' => 'Zaimportuj Kalendarz',
        'Filter for Calendars' => 'Filtr dla Kalendarzy',
        'Filter for calendars' => 'Filtr dla kalendarzy',
        'Depending on the group field, the system will allow users the access to the calendar according to their permission level.' =>
            'W zależności od pola grupy, system udostępni użytkownikom dostęp do kalendarza zgodnie z ich uprawnieniami.',
        'Read only: users can see and export all appointments in the calendar.' =>
            'Tylko do odczytu: użytkownicy mogą widzieć i eksportować wszystkie wydarzenia w kalendarzu.',
        'Move into: users can modify appointments in the calendar, but without changing the calendar selection.' =>
            'Przenieś na: użytkownicy mogą modyfikować wydarzenia w kalendarzu, jednak bez możliwości zmiany wybranego kalendarza.',
        'Create: users can create and delete appointments in the calendar.' =>
            'Utwórz: użytkownicy mogą tworzyć i usuwać wydarzenia w kalendarzu.',
        'Read/write: users can manage the calendar itself.' => 'Odczyt/Zapis: użytkownicy mogą zarządzać kalendarzem.',
        'Group' => 'Grupa',
        'Changed' => 'Zmienione',
        'Created' => 'Utworzone',
        'Download' => 'Pobierz',
        'URL' => 'URL',
        'Export calendar' => 'Wyeksportuj kalendarz',
        'Download calendar' => 'Ściągnij kalendarz',
        'Copy public calendar URL' => 'Skopiuj URL publicznego kalendarza',
        'Calendar' => 'Kalendarz',
        'Calendar name' => 'Nazwa kalendarza',
        'Calendar with same name already exists.' => 'Kalendarz z tą nazwą już istnieje.',
        'Color' => 'Kolor',
        'Permission group' => 'Grupa uprawnień',
        'Ticket Appointments' => 'Wydarzenia Zgłoszeń',
        'Rule' => 'Reguła',
        'Remove this entry' => 'Usuń tę pozycję',
        'Remove' => 'Usuń',
        'Start date' => 'Data początku',
        'End date' => 'Data zakończenia',
        'Use options below to narrow down for which tickets appointments will be automatically created.' =>
            'Użyj opcji poniżej by zawęzić dla jakich zgłoszeń będą tworzone automatyczne wydarzenai.',
        'Queues' => 'Kolejki',
        'Please select a valid queue.' => 'Proszę wybrać ważną kolejkę.',
        'Search attributes' => 'Atrybuty wyszukiwania',
        'Add entry' => 'Dodaj pozycję',
        'Add' => 'Dodaj',
        'Define rules for creating automatic appointments in this calendar based on ticket data.' =>
            'Definiuje reguły dla automatycznego tworzenia wydarzeń w tym kalendarzu, w zależności od danych zgłoszenia.',
        'Add Rule' => 'Dodaj regułę',
        'Submit' => 'Akceptuj',

        # Template: AdminAppointmentImport
        'Appointment Import' => 'Import Wydarzeń',
        'Go back' => 'Wstecz',
        'Uploaded file must be in valid iCal format (.ics).' => 'Wczytany plik musi posiadać prawidłowy format iCAL (.ics).',
        'If desired Calendar is not listed here, please make sure that you have at least \'create\' permissions.' =>
            'Jeśli szukany Kalendarz nie jest tutaj wyświetlony, proszę upewnić się, że posiadasz przy najmniej uprawnienie \'Utwórz\'.',
        'Upload' => 'Wyślij',
        'Update existing appointments?' => 'Zaktualizować istniejące wydarzenia?',
        'All existing appointments in the calendar with same UniqueID will be overwritten.' =>
            'Wszystkie istniejące wydarzenia w kalendarzu z tym samym UniqueID zostaną nadpisane.',
        'Upload calendar' => 'Wczytaj kalendarz.',
        'Import appointments' => 'Import wydarzeń',

        # Template: AdminAppointmentNotificationEvent
        'Appointment Notification Management' => 'Zarządzanie Powiadomieniami Wydarzeń',
        'Add Notification' => 'Dodaj powiadomienie',
        'Edit Notification' => 'Edytuj Powiadomienie',
        'Export Notifications' => 'Eksportuj powiadomienia',
        'Filter for Notifications' => 'Filtr powiadomień',
        'Filter for notifications' => 'Filtr powiadomień',
        'Here you can upload a configuration file to import appointment notifications to your system. The file needs to be in .yml format as exported by the appointment notification module.' =>
            'Tu możesz przesłać plik konfiguracji by zaimportować powiadomienia o spotkaniach do systemu. Plik powinien być w formacie .yml, takim jak wyeksportowany z modułu powiadomień o spotkaniach.',
        'Overwrite existing notifications?' => 'Nadpisać istniejące powiadomienia?',
        'Upload Notification configuration' => 'Prześlij konfigurację powiadomień',
        'Import Notification configuration' => 'Importuj konfigurację powiadomień',
        'List' => 'Lista',
        'Delete' => 'Usuń',
        'Delete this notification' => 'Usuń to powiadomienie',
        'Show in agent preferences' => 'Pokaż w preferencjach agenta',
        'Agent preferences tooltip' => 'Podpowiedź (etykieta) w preferencjach agenta',
        'This message will be shown on the agent preferences screen as a tooltip for this notification.' =>
            'Ten komunikat agent zobaczy na ekranie ustawień jako podpowiedź opisująca te powiadomienie.',
        'Toggle this widget' => 'Przełącz ten widget',
        'Events' => 'Zdarzenia',
        'Event' => 'Zdarzenie',
        'Here you can choose which events will trigger this notification. An additional appointment filter can be applied below to only send for appointments with certain criteria.' =>
            'Tu można wybrać, które zdarzenia będą wyzwalać to powiadomienie. Zdefiniowany poniżej dodatkowy filtr wydarzeń może ograniczyć powiadomienia do wydarzeń spełniających określone kryteria.',
        'Appointment Filter' => 'Filtr wydarzeń',
        'Type' => 'Typ',
        'Title' => 'Tytuł',
        'Location' => 'Miejsce',
        'Team' => 'Zespół',
        'Resource' => 'Zasoby',
        'Recipients' => 'Odbiorcy',
        'Send to' => 'Wyślij do',
        'Send to these agents' => 'Wyślij do tych agentów',
        'Send to all group members (agents only)' => ' Wyślij do wszystkich członków grupy (tylko agenci)',
        'Send to all role members' => 'Wyślij do wszystkich członków roli',
        'Send on out of office' => 'Wyślij powiadomienie o nieobecności w biurze',
        'Also send if the user is currently out of office.' => 'Również wyślij jeśli użytkownik jest aktualnie poza biurem',
        'Once per day' => 'Jeden na dzień',
        'Notify user just once per day about a single appointment using a selected transport.' =>
            'Powiadamiaj użytkownika o pojedynczym wydarzeniu, przy użyciu wybranego transportu, tylko raz dziennie.',
        'Notification Methods' => 'Metoda powiadomienia',
        'These are the possible methods that can be used to send this notification to each of the recipients. Please select at least one method below.' =>
            'To są metody, które mogą zostać użyte do wysłania tego powiadomienia do każdego z odbiorców. Wybierz przynajmniej jedną metodę poniżej.',
        'Enable this notification method' => 'Włącz tą metodę powiadomienia',
        'Transport' => 'Transport',
        'At least one method is needed per notification.' => 'Wymagana jest przynajmniej jedna metoda na powiadomienie.',
        'Active by default in agent preferences' => 'Domyślnie aktywne w ustawieniach agenta',
        'This is the default value for assigned recipient agents who didn\'t make a choice for this notification in their preferences yet. If the box is enabled, the notification will be sent to such agents.' =>
            'Wartość domyślna ustawienia odbioru tego powiadomienia dla agenta, który nie określił jeszcze tej wartości w swoich preferencjach. Jeśli pole jest zaznaczone, powiadomienie będzie do takich agentów wysyłane.',
        'This feature is currently not available.' => 'Ta funkcja jest obecnie niedostępna.',
        'Upgrade to %s' => 'Zaktualizuj do %s',
        'Please activate this transport in order to use it.' => 'Aktywuj ten sposób transportu aby go użyć.',
        'No data found' => 'Nie znaleziono danych',
        'No notification method found.' => 'Nie znaleziono metody powiadomienia',
        'Notification Text' => 'Treść powiadomienia',
        'This language is not present or enabled on the system. This notification text could be deleted if it is not needed anymore.' =>
            'Ten język nie jest obecny lub włączony w systemie. Powiadomienie może zostać skasowane, jeśli nie jest już potrzebne.',
        'Remove Notification Language' => 'Usuń język powiadomienia',
        'Subject' => 'Temat',
        'Text' => 'Treść',
        'Message body' => 'Treść wiadomości',
        'Add new notification language' => 'Dodaj nowy język powiadomienia',
        'Save Changes' => 'Zapisz zmiany',
        'Tag Reference' => 'Opis tag\'u',
        'Notifications are sent to an agent.' => 'Powiadomienia są wysyłane do agenta.',
        'You can use the following tags' => 'Możesz używać następujących znaczników',
        'To get the first 20 character of the appointment title.' => 'By pobrać pierwsze 20 znaków tytułu wydarzenia.',
        'To get the appointment attribute' => 'By pobrać atrybut wydarzenia',
        ' e. g.' => 'np.',
        'To get the calendar attribute' => 'By pobrać atrybut kalendarza',
        'Attributes of the recipient user for the notification' => 'Atrybuty danych odbiorcy powiadomienia',
        'Config options' => 'Opcje konfiguracyjne',
        'Example notification' => 'Przykładowe powiadomienie',

        # Template: AdminAppointmentNotificationEventTransportEmailSettings
        'Additional recipient email addresses' => 'Dodatkowe adresy email odbiorców',
        'This field must have less then 200 characters.' => 'To pole musi zawierać mniej niż 200 znaków.',
        'Article visible for customer' => 'Artykuł widoczny dla klienta',
        'An article will be created if the notification is sent to the customer or an additional email address.' =>
            'Artykuł zostanie utworzony jeżeli zostanie wysłane powiadomienie do klienta lub na adres dodatkowy.',
        'Email template' => 'Formatka email',
        'Use this template to generate the complete email (only for HTML emails).' =>
            'Użyj tego szablonu, aby wygenerować kompletną wiadomość email (dotyczy tylko emaili HTML).',
        'Enable email security' => 'Włącz zabezpieczenia email',
        'Email security level' => 'Poziom zabezpieczeń Email',
        'If signing key/certificate is missing' => 'Jeśli brakuje podpisanego klucza / certyfikatu',
        'If encryption key/certificate is missing' => 'Jeśli brakuje klucza szyfrującego / certyfikatu',

        # Template: AdminAttachment
        'Attachment Management' => 'Zarządzanie załącznikami',
        'Add Attachment' => 'Dodaj załącznik',
        'Edit Attachment' => 'Edytuj załącznik',
        'Filter for Attachments' => 'Filtr załączników',
        'Filter for attachments' => 'Filtr dla załączników',
        'Filename' => 'Nazwa pliku',
        'Download file' => 'Pobierz plik',
        'Delete this attachment' => 'Usuń ten załącznik',
        'Do you really want to delete this attachment?' => 'Czy na pewno usunąć załącznik?',
        'Attachment' => 'Załącznik',

        # Template: AdminAutoResponse
        'Auto Response Management' => 'Zarządzanie automatycznymi odpowiedziami',
        'Add Auto Response' => 'Dodaj automatyczną odpowiedź',
        'Edit Auto Response' => 'Edytuj automatyczną odpowiedź',
        'Filter for Auto Responses' => 'Filtrowanie automatycznych odpowiedzi',
        'Filter for auto responses' => 'Filtr dla automatycznych odpowiedzi',
        'Response' => 'Odpowiedź',
        'Auto response from' => 'Automatyczna odpowiedź od',
        'Reference' => 'Podpowiedzi',
        'To get the first 20 character of the subject.' => 'Pokaż pierwsze 20 znaków tematu.',
        'To get the first 5 lines of the email.' => 'Pokaż 5 linii wiadomości e-mail.',
        'To get the name of the ticket\'s customer user (if given).' => 'Pokaż nazwę klienta ze zgłoszenia (jeśli jest podana).',
        'To get the article attribute' => 'Pokaż właściwości wiadomości',
        'Options of the current customer user data' => 'Opcje danych obecnego użytkownika',
        'Ticket owner options' => 'Opcje właściciela zgłoszenia',
        'Ticket responsible options' => 'Opcje odpowiedzialego za zgłoszenie',
        'Options of the current user who requested this action' => 'Opcje bieżącego użytkownika, który żądał akcji',
        'Options of the ticket data' => 'Opcje danych zgłoszenia',
        'Options of ticket dynamic fields internal key values' => 'Opcje wewnętrznych wartości kluczy pól dynamicznych zgłoszeń',
        'Options of ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            'Opcje wartości wyświetlanych pól dynamicznych zgłoszeń, przydatne dla pól Dropdown i Multiselect',
        'Example response' => 'Przykładowa odpowiedź',

        # Template: AdminCloudServiceSupportDataCollector
        'Cloud Service Management' => 'Zarządzanie usługami w chmurze',
        'Support Data Collector' => 'Kolekcjoner Danych Wsparcia',
        'Support data collector' => 'Kolekcjoner danych wsparcia',
        'Hint' => 'Podpowiedź',
        'Currently support data is only shown in this system.' => 'Obecnie dane wsparca są wyświetlane jedynie w tym systemie.',
        'It is highly recommended to send this data to OTRS Group in order to get better support.' =>
            'Jest wysoce zalecanym by wysłać te dane do Grupy OTRS w celu uzyskania lepszego wsparcia.',
        'Configuration' => 'Konfiguracja',
        'Send support data' => 'Wysyłaj dane wsparcia',
        'This will allow the system to send additional support data information to OTRS Group.' =>
            'Pozwala na przesyłanie dodatkowych danych do grupy wsparcia OTRS',
        'Update' => 'Zaktualizuj',
        'System Registration' => 'Rejestracja systemu',
        'To enable data sending, please register your system with OTRS Group or update your system registration information (make sure to activate the \'send support data\' option.)' =>
            'Aby włączyć przesyłanie danych, zarejestruj swój system w Grupie OTRS lub zaktualizuj informacje rejestracyjne systemu (upewnij się że opcja \'wysyłaj dane wsparcia\' jest akywna).',
        'Register this System' => 'Zarejestruj ten system',
        'System Registration is disabled for your system. Please check your configuration.' =>
            'Rejestracja Systemu jest wyłączona. Sprawdź konfigurację.',

        # Template: AdminCloudServices
        'System registration is a service of OTRS Group, which provides a lot of advantages!' =>
            'System rejestracji jest serwisem grupy OTRS, kóry posiada wiele zalet!',
        'Please note that the use of OTRS cloud services requires the system to be registered.' =>
            'Zauważ że używanie usług OTRS w chmurze wymaga by Twój system był zarejestrowany',
        'Register this system' => 'Zarejestruj system',
        'Here you can configure available cloud services that communicate securely with %s.' =>
            'Tu możesz skonfigurować dostępne usługi, które mogą komunikować się bezpiecznie z %s',
        'Available Cloud Services' => 'Dostępne usługi w chmurze',

        # Template: AdminCommunicationLog
        'Communication Log' => 'Log komunikacji',
        'Time Range' => 'Zakres czasu',
        'Show only communication logs created in specific time range.' =>
            'Pokaż log komunikacyjny utworzony tylko w określonym zakresie czasu.',
        'Filter for Communications' => 'Filtr kanałów komunikacji',
        'Filter for communications' => 'Filtr kanałów komunikacji',
        'In this screen you can see an overview about incoming and outgoing communications.' =>
            'Na tym ekranie możesz zobaczyć podsumowanie komunikacji przychodzącej i wychodzącej.',
        'You can change the sort and order of the columns by clicking on the column header.' =>
            'Możesz zmienić kolejność i sortowanie kolumn klikając na nagłówek tabeli.',
        'If you click on the different entries, you will get redirected to a detailed screen about the message.' =>
            'Jeśli klikniesz w niektóre kolumny elementu, zostaniesz przekierowany do ekranu szczegółów.',
        'Status for: %s' => 'Status dla: 1 %s',
        'Failing accounts' => 'Nieprawidłowe konta',
        'Some account problems' => 'Występują problemy kont',
        'No account problems' => 'Nie ma problemów z kontami',
        'No account activity' => 'Nie ma aktywności konta',
        'Number of accounts with problems: %s' => 'Ilość kont z problemami: %s',
        'Number of accounts with warnings: %s' => 'Ilość kont z ostrzeżeniami: %s',
        'Failing communications' => 'Niepowodzenia komunikacji',
        'No communication problems' => 'Brak problemów komunikacyjnych',
        'No communication logs' => 'Brak logów komunikacyjnych',
        'Number of reported problems: %s' => 'Liczba zaraportowanych problemów: %s',
        'Open communications' => 'Otwarta komunikacja',
        'No active communications' => 'Brak aktywnej komunikacji',
        'Number of open communications: %s' => 'Liczba otwartych komunikacji: %s',
        'Average processing time' => 'Średni czas przetwarzania',
        'List of communications (%s)' => 'Lista komunikacji (%s)',
        'Settings' => 'Ustawienia',
        'Entries per page' => 'Pozycji na stronie',
        'No communications found.' => 'Nie znaleziono komunikacji.',
        '%s s' => '%s',

        # Template: AdminCommunicationLogAccounts
        'Account Status' => 'Status konta',
        'Back to overview' => 'Powrót do przeglądu',
        'Filter for Accounts' => 'Filtr dla Kont',
        'Filter for accounts' => 'Filtr dla kont',
        'You can change the sort and order of those columns by clicking on the column header.' =>
            'Możesz zmienić kolejność i sortowanie kolumn klikając na nagłówek tabeli.',
        'Account status for: %s' => 'Stan konta dla: 1 %s',
        'Status' => 'Stan',
        'Account' => 'Konto',
        'Edit' => 'Edytuj',
        'No accounts found.' => 'Brak znalezionych kont.',
        'Communication Log Details (%s)' => 'Szczegóły logu komunikacyjnego (%s)',
        'Direction' => 'Kierunek',
        'Start Time' => 'Czas rozpoczęcia',
        'End Time' => 'Czas zakończenia',
        'No communication log entries found.' => 'Nie znaleziono pozycji logu komunikacyjnego.',

        # Template: AdminCommunicationLogCommunications
        'Duration' => 'Czas trwania',

        # Template: AdminCommunicationLogObjectLog
        '#' => '#',
        'Priority' => 'Priorytet',
        'Module' => 'Moduł',
        'Information' => 'Informacje',
        'No log entries found.' => 'Nie znaleziono pozycji logu.',

        # Template: AdminCommunicationLogZoom
        'Detail view for %s communication started at %s' => 'Podgląd szczegółów dla %s komunikacja rozpoczęta o %s',
        'Filter for Log Entries' => 'Filtruj pozycje logu',
        'Filter for log entries' => 'Filtruj pozycje logu',
        'Show only entries with specific priority and higher:' => 'Pokaż tylko te pozycje logu od określonego priorytetu wzwyż:',
        'Communication Log Overview (%s)' => 'Przegląd Logu Komunikacyjnego (%s)',
        'No communication objects found.' => 'Nie znaleziono obiektów komunikacyjnych.',
        'Communication Log Details' => 'Szczegóły Logu Komunikacyjnego',
        'Please select an entry from the list.' => 'Wybierz pozycję z listy.',

        # Template: AdminCustomerCompany
        'Customer Management' => 'Zarządzanie klientami',
        'Add Customer' => 'Dodaj Klienta',
        'Edit Customer' => 'Edytuj Klienta',
        'Search' => 'Szukaj',
        'Wildcards like \'*\' are allowed.' => 'Wieloznaczniki (wildcards) takie jak \'*\' są dozwolone.',
        'Select' => 'Zaznacz',
        'List (only %s shown - more available)' => 'Lista (pokazano tylko %s - jest więcej dostępnych',
        'total' => 'wszystkich',
        'Please enter a search term to look for customers.' => 'Prosimy wprowadź frazę wyszukiwania by odszukać klientów.',
        'Customer ID' => 'Identyfikator Klienta',
        'Please note' => 'Zwróć uwagę',
        'This customer backend is read only!' => 'Ten backend klienta jest tylko do odczytu!',

        # Template: AdminCustomerGroup
        'Manage Customer-Group Relations' => 'Zarządzaj relacjami Klient-Grupa',
        'Notice' => 'Uwaga',
        'This feature is disabled!' => 'Ta funkcja jest wyłączona!',
        'Just use this feature if you want to define group permissions for customers.' =>
            'Użyj tej funkcji jeśli chcesz określić grupę uprawnień dla klientów.',
        'Enable it here!' => 'Włącz tutaj!',
        'Edit Customer Default Groups' => 'Edytuj Domyślne Grupy Klientów',
        'These groups are automatically assigned to all customers.' => 'Te grupy są automatycznie przypisywane wszystkim klientom.',
        'You can manage these groups via the configuration setting "CustomerGroupCompanyAlwaysGroups".' =>
            'Możesz zarządzać tymi grupami poprzez ustawienia konfiguracji
"CustomerGroupCompanyAlwaysGroups".',
        'Filter for Groups' => 'Filtr dla grup.',
        'Select the customer:group permissions.' => 'Wybierz uprawnienia klient:grupa',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer).' =>
            'Jeśli nic nie zostało zaznaczone, wtedy nie ma uprawnień w tej grupie (zgłoszenia nie będą dostępne dla klienta).',
        'Search Results' => 'Wyniki wyszukiwania',
        'Customers' => 'Klienci',
        'Groups' => 'Grupy',
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

        # Template: AdminCustomerUser
        'Customer User Management' => 'Zarządzanie użytkownikami klientów',
        'Add Customer User' => 'Dodaj użytkownika klienta',
        'Edit Customer User' => 'Edytuj użytkownika klienta',
        'Back to search results' => 'Wstecz do wyników wyszukiwania',
        'Customer user are needed to have a customer history and to login via customer panel.' =>
            'Aby posiadać historię klienta i umożliwić mu logowanie się do panelu klienta konieczne jest założenie konta użytkownika klienta.',
        'List (%s total)' => 'Lista (%s wszystkich)',
        'Username' => 'Nazwa użytkownika',
        'Email' => 'E-Mail',
        'Last Login' => 'Ostatnie logowanie',
        'Login as' => 'Nazwa użytkownika',
        'Switch to customer' => 'Zmień klienta',
        'This customer backend is read only, but the customer user preferences can be changed!' =>
            'Ten backend klienta jest tylko do odczytu, ale preferencje użytkownika klienta mogą być zmieniane!',
        'This field is required and needs to be a valid email address.' =>
            'To pole jest wymagane i musi być poprawnym adresem e-mail.',
        'This email address is not allowed due to the system configuration.' =>
            'Ten adres e-mail nie jest dozwolony z uwagi na konfigurację systemu.',
        'This email address failed MX check.' => 'Walidacja MX tego adresu e-mail nie powiodła się.',
        'DNS problem, please check your configuration and the error log.' =>
            'Problem z DNS, sprawdź konfigurację i log błędów.',
        'The syntax of this email address is incorrect.' => 'Składnia tego adresu e-mail jest niepoprawna.',
        'This CustomerID is invalid.' => 'CustomerID jest nieprawidłowy.',
        'Effective Permissions for Customer User' => 'Efektywne uprawnienia dla Użytkownika Klienta',
        'Group Permissions' => 'Uprawnienia Grupy',
        'This customer user has no group permissions.' => 'Ten użytkownik klienta, nie jest członkiem żadnej z grup zabezpieczeń,',
        'Table above shows effective group permissions for the customer user. The matrix takes into account all inherited permissions (e.g. via customer groups). Note: The table does not consider changes made to this form without submitting it.' =>
            'Powyższa tabela pokazuje efektywne uprawnienia do grup użytkownika klienta. Macierz pobiera wszystkie dziedziczone uprawnienia dla konta (np. poprzez grupy użytkownika). Uwaga: Tabela nie zawiera zmian dokonanych na tej formatce i jeszcze nie zapisanych.',
        'Customer Access' => 'Dostęp Klienta',
        'Customer' => 'Nazwa klienta',
        'This customer user has no customer access.' => 'Ten użytkownik klienta nie ma dostępu jako klient.',
        'Table above shows granted customer access for the customer user by permission context. The matrix takes into account all inherited access (e.g. via customer groups). Note: The table does not consider changes made to this form without submitting it.' =>
            'Tabela powyżej pokazuje przyznany dostęp klienta dla użytkownika klienta przez kontekst uprawnień. Macierz uwzględnia cały dziedziczny dostęp (na przykład poprzez grupy klientów). Uwaga: tabela nie uwzględnia zmian wprowadzonych w tym formularzu bez jego przesyłania.',

        # Template: AdminCustomerUserCustomer
        'Manage Customer User-Customer Relations' => 'Zarządzaj relacjami Użytkownik klienta - Klient',
        'Select the customer user:customer relations.' => 'Wybierz relacje użytkownik klienta:klient',
        'Customer Users' => 'Użytkownicy klienta',
        'Change Customer Relations for Customer User' => 'Zmień relacje Klienta dla Użytkownika klienta',
        'Change Customer User Relations for Customer' => 'Zmień relacje Użytkownika klienta do Klienta',
        'Toggle active state for all' => 'Przełącz stan aktywności dla wszystkich',
        'Active' => 'Aktywne',
        'Toggle active state for %s' => 'Przełącz stan aktywności dla %s',

        # Template: AdminCustomerUserGroup
        'Manage Customer User-Group Relations' => 'Zarządzaj relacjami Użytkownik klienta - Grupa',
        'Just use this feature if you want to define group permissions for customer users.' =>
            'Użyj tej funkcjonalności jeśli chcesz określić uprawnienia grup dla użytkowników klienta.',
        'Edit Customer User Default Groups' => 'Zmień Domyślną Grupę Użytkownika Klienta',
        'These groups are automatically assigned to all customer users.' =>
            'Te grupy zostaną automatycznie przypisane do wszystkich użytkowników klienta.',
        'You can manage these groups via the configuration setting "CustomerGroupAlwaysGroups".' =>
            'Możesz zarządzać tymi grupami poprzez parametr "CustomerGroupAlwaysGroups".',
        'Filter for groups' => 'Filtr dla grup.',
        'Select the customer user - group permissions.' => 'Określ uprawnienia użytkownik klienta - grupa.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer user).' =>
            'Jeśli nic nie zostało zaznaczone, wtedy nie ma uprawnień w tej grupie (zgłoszenia nie będą dostępne dla klienta).',
        'Customer User Default Groups:' => 'Domyślna Grupa Użytkownika klienta',

        # Template: AdminCustomerUserService
        'Manage Customer User-Service Relations' => 'Zarządzaj relacjami Użytkownik klienta - Usługi',
        'Edit default services' => 'Edytuj domyślną usługę',
        'Filter for Services' => 'Filtruj usługi',
        'Filter for services' => 'Filtr usług',
        'Services' => 'Usługi',

        # Template: AdminDynamicField
        'Dynamic Fields Management' => 'Zarządzanie polami dynamicznymi',
        'Add new field for object' => 'Dodaj nowej pole do obiektu',
        'Filter for Dynamic Fields' => 'Filtr dla Pól Dynamicznych',
        'Filter for dynamic fields' => 'Filtr dla pól dynamicznych',
        'More Business Fields' => 'Więcej pól biznesowych',
        'Would you like to benefit from additional dynamic field types for businesses? Upgrade to %s to get access to the following field types:' =>
            'Czy chcesz korzystać z dodatkowych dynamicznych typów pól dla firm? Uaktualnij do %s, aby uzyskać dostęp do następujących typów pól:',
        'Database' => 'Baza danych',
        'Use external databases as configurable data sources for this dynamic field.' =>
            'Użyj zewnętrznych baz danych jako konfigurowalnych źródeł danych dla tego dynamicznego pola.',
        'Web service' => 'Serwis sieciowy',
        'External web services can be configured as data sources for this dynamic field.' =>
            'Dla tego pola dynamicznego można skonfigurować jako źródło danych zewnętrzny serwis sieciowy.',
        'Contact with data' => 'Połącz z danymi',
        'This feature allows to add (multiple) contacts with data to tickets.' =>
            'Ta funkcja umożliwia dodawanie (wielu) kontaktów z danymi do biletów.',
        'To add a new field, select the field type from one of the object\'s list, the object defines the boundary of the field and it can\'t be changed after the field creation.' =>
            'Aby dodać nowe pole, wybierz typ pola z listy obiektów. Wybrany obiekt definiuje typ pola, który nie będzie mógł być zmieniony po utworzeniu tego pola.',
        'Dynamic Fields List' => 'Lista pól dynamicznych',
        'Dynamic fields per page' => 'Pola dynamiczne na stronę',
        'Label' => 'Etykieta',
        'Order' => 'Zamówienie',
        'Object' => 'Obiekt',
        'Delete this field' => 'Usuń to pole',

        # Template: AdminDynamicFieldCheckbox
        'Dynamic Fields' => 'Pola dynamiczne',
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
        'Is not possible to invalidate this entry, all config settings have to be changed beforehand.' =>
            'Nie można unieważnić tego wpisu, wszystkie ustawienia konfiguracji muszą zostać wcześniej zmienione.',
        'Field type' => 'Typ pola',
        'Object type' => 'Typ obiektu',
        'Internal field' => 'Pole wewnętrzne',
        'This field is protected and can\'t be deleted.' => 'To pole jest chronione i nie może być usunięte.',
        'This dynamic field is used in the following config settings:' =>
            'To dynamiczne pole jest używane w następujących ustawieniach konfiguracji:Pole dynamiczne',
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
        'If special characters (&, @, :, /, etc.) should not be encoded, use \'url\' instead of \'uri\' filter.' =>
            'Jeżeli znaki specjalne (&, @, :, /, etc.) nie mogą zostać zakodowane, użyj filtra \'url\' zamiast \'uri\'.',
        'Example' => 'Przykład',
        'Link for preview' => 'Link do podglądu',
        'If filled in, this URL will be used for a preview which is shown when this link is hovered in ticket zoom. Please note that for this to work, the regular URL field above needs to be filled in, too.' =>
            'Jeżeli jest wpisany, ten link (URL) będzie używany do podglądu, który będzie widoczny w szczegółach zgłoszenia, gdy najedziesz kursorem na ten link. Zauważ, że żeby ten podgląd działał, pełny adres (URL) w polu powyżej również musi być wpisany.',
        'Restrict entering of dates' => 'Ogranicz zakres wprowadzanych dat',
        'Here you can restrict the entering of dates of tickets.' => 'Tutaj możesz ograniczyć zakres wprowadzanych dat w zgłoszeniach. ',

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
        'Note' => 'Notatka',
        'You need to add the translations manually into the language translation files.' =>
            'Musisz dodać tłumaczenia ręcznie do plików z tłumaczeniami.',

        # Template: AdminDynamicFieldText
        'Number of rows' => 'Liczba wierszy',
        'Specify the height (in lines) for this field in the edit mode.' =>
            'Określ wysokość (w liniach) dla tego pola w trybie edycji.',
        'Number of cols' => 'Liczba kolumn',
        'Specify the width (in characters) for this field in the edit mode.' =>
            'Określ szerokość (w znakach) dla tego pola w trybie edycji.',
        'Check RegEx' => 'Sprawdź wyrażenie regularne',
        'Here you can specify a regular expression to check the value. The regex will be executed with the modifiers xms.' =>
            'Tutaj możesz określić wyrażenie regularne sprawdzające tą wartość. To sprawdzenie będzie wykonywane razem z modyfikatorami xms.',
        'RegEx' => 'Wyrażenie regularne',
        'Invalid RegEx' => 'Nieprawidłowe wyrażenie regularne',
        'Error Message' => 'Komunikat błędu',
        'Add RegEx' => 'Dodaj wyrażenie regularne',

        # Template: AdminEmail
        'Admin Message' => 'Wiadomość Administratora',
        'With this module, administrators can send messages to agents, group or role members.' =>
            'Przy pomocy tego modułu administratorzy mogą wysyłać wiadomości do agentów, członków grup lub ról.',
        'Create Administrative Message' => 'Utwórz wiadomość od administratora',
        'Your message was sent to' => 'Twoja wiadomość została wysłana do',
        'From' => 'Od',
        'Send message to users' => 'Wyślij wiadomość do użytkowników',
        'Send message to group members' => 'Wyślij wiadomość do członków grupy',
        'Group members need to have permission' => 'Członkowie grupy muszą posiadać uprawnienia',
        'Send message to role members' => 'Wyślij wiadomość do posiadaczy roli',
        'Also send to customers in groups' => 'Wyślij także, do klientów w grupach',
        'Body' => 'Treść',
        'Send' => 'Wyślij',

        # Template: AdminGenericAgent
        'Generic Agent Job Management' => 'Zarządzanie zadaniami automatycznymi',
        'Edit Job' => 'Edytuj Zadanie',
        'Add Job' => 'Dodaj Zadanie',
        'Run Job' => 'Wykonaj Zadanie',
        'Filter for Jobs' => 'Filtr Zadań',
        'Filter for jobs' => 'Filtr zadań',
        'Last run' => 'Ostatnie uruchomienie',
        'Run Now!' => 'Uruchom teraz',
        'Delete this task' => 'Usuń to zadanie',
        'Run this task' => 'Uruchom to zadanie',
        'Job Settings' => 'Ustawienia zadania',
        'Job name' => 'Nazwa zadania',
        'The name you entered already exists.' => 'Podana nazwa już istnieje.',
        'Automatic Execution (Multiple Tickets)' => 'Automatyczne wykonywanie (Wiele Ticketów)',
        'Execution Schedule' => 'Harmonogram wykonania',
        'Schedule minutes' => 'Ustal minuty',
        'Schedule hours' => 'Ustal godziny',
        'Schedule days' => 'Ustal dni',
        'Automatic execution values are in the system timezone.' => 'Wartości automatycznego wykonania są określone dla strefy czasowej systemu.',
        'Currently this generic agent job will not run automatically.' =>
            'Zadanie nie zostanie uruchomione automatycznie.',
        'To enable automatic execution select at least one value from minutes, hours and days!' =>
            'Aby uruchomić automatyczne wykonywanie zaznacz przynajmniej jedną wartość dla minut, godzin i dni!',
        'Event Based Execution (Single Ticket)' => 'Wykonywanie bazowane na zdarzeniach (pojedyńcze zgłoszenie)',
        'Event Triggers' => 'Triggery',
        'List of all configured events' => 'Lista wszystkich skonfigurowanych zdarzeń',
        'Delete this event' => 'Usuń to zdarzenie',
        'Additionally or alternatively to a periodic execution, you can define ticket events that will trigger this job.' =>
            'Dodatkowo lub alternatywnie dla wykonywania okresowego możesz zdefiniować zdarzenia które spowodują wykonannie tego zadania.',
        'If a ticket event is fired, the ticket filter will be applied to check if the ticket matches. Only then the job is run on that ticket.' =>
            'Jeśli zgłoszenie zostanie wykonane wówczas filtr zgłoszeń zostanie wykonany dla sprawdzenia dopasowania zgłoszenia. Tylko wówczas zadanie jest wykonane na danym zgłoszeniu.',
        'Do you really want to delete this event trigger?' => 'Czy na pewno chcesz usunąć ten trigger?',
        'Add Event Trigger' => 'Dodaj trigger',
        'To add a new event select the event object and event name' => 'Aby dodać nowe wydarzenie, wybierz obiekt zdarzenia i nazwę wydarzenia',
        'Select Tickets' => 'Zaznacz zgłoszenia',
        '(e. g. 10*5155 or 105658*)' => '(np. 10*5155 lub 105658*)',
        '(e. g. 234321)' => '(np. 3242442)',
        'Customer user ID' => 'ID Użytkownika Klienta',
        '(e. g. U5150)' => '(np. U4543)',
        'Fulltext-search in article (e. g. "Mar*in" or "Baue*").' => 'Szukanie pełnotekstowe we wiadomości (np. "J*n" lub "Kowalsk*")',
        'To' => 'Do',
        'Cc' => 'DW',
        'Service' => 'Usługa',
        'Service Level Agreement' => ' Umowa o gwarantowanym poziomie świadczenia usług - Service Level Agreement (SLA)',
        'Queue' => 'Kolejka',
        'State' => 'Stan',
        'Agent' => 'Agent',
        'Owner' => 'Właściciel',
        'Responsible' => 'Odpowiedzialny',
        'Ticket lock' => 'Blokada zgłoszenia',
        'Dynamic fields' => 'Pola dynamiczne',
        'Add dynamic field' => '',
        'Create times' => 'Czasy utworzenia',
        'No create time settings.' => 'Bez czasów utworzenia.',
        'Ticket created' => 'Zgłoszenie utworzone',
        'Ticket created between' => 'Zgłoszenie utworzone między',
        'and' => 'i',
        'Last changed times' => 'Data ostatnich modyfikacji',
        'No last changed time settings.' => 'Nie ustawiono czasu ostatniej zmiany.',
        'Ticket last changed' => 'Ostatnia modyfikacja zgłoszenia',
        'Ticket last changed between' => 'Ostatnia modyfikacja zgłoszenia między',
        'Change times' => 'Czasy zmiany',
        'No change time settings.' => 'Brak zmiany ustawień czasu',
        'Ticket changed' => 'Zgłoszenie zmieniono',
        'Ticket changed between' => 'Zgłoszenie zmieniono pomiędzy',
        'Last close times' => '',
        'No last close time settings.' => '',
        'Ticket last close' => '',
        'Ticket last close between' => '',
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
        'Update/Add Ticket Attributes' => 'Zmień/dodaj parametry zgłoszenia',
        'Set new service' => 'Ustaw nową usługę',
        'Set new Service Level Agreement' => 'Ustaw nowe SLA',
        'Set new priority' => 'Ustaw nowy priorytet',
        'Set new queue' => 'Ustaw nową kolejkę',
        'Set new state' => 'Ustaw nowy stan',
        'Pending date' => 'Data oczekiwania',
        'Set new agent' => 'Ustaw nowego agenta',
        'new owner' => 'nowy właściciel',
        'new responsible' => 'nowy odpowiedzialny',
        'Set new ticket lock' => 'Ustaw nową blokadę zgłoszenia',
        'New customer user ID' => 'Nowe ID Użytkownika Klienta',
        'New customer ID' => 'Nowy klient',
        'New title' => 'Nowy tytuł',
        'New type' => 'Nowy typ',
        'Archive selected tickets' => 'Zarchiwizuj zaznaczone zgłoszenia',
        'Add Note' => 'Dodaj notatkę',
        'Visible for customer' => 'Widoczny dla klienta',
        'Time units' => 'Zaraportowany czas obsługi',
        'Execute Ticket Commands' => 'Wykonaj polecenia zgłoszeń',
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
        'Results' => 'Wyniki',
        '%s Tickets affected! What do you want to do?' => 'Liczba wybranych zgłoszeń %s. Co chcesz zrobić?',
        'Warning: You used the DELETE option. All deleted tickets will be lost!' =>
            'Uwaga: Użyta została opcja USUWANIA. Wszystkie usunięte zgłoszenia będą utracone!',
        'Warning: There are %s tickets affected but only %s may be modified during one job execution!' =>
            'Ostrzeżenie: Istnieje %s zgłoszeń, których dotyczy zadanie ale tylko %s może być zmodyfikowanych przy jednym wykonaniu zadania.',
        'Affected Tickets' => 'Wybrane zgłoszenia',
        'Age' => 'Wiek',

        # Template: AdminGenericInterfaceDebugger
        'GenericInterface Web Service Management' => 'Zarządzanie serwisami sieciowymi GenericInterface',
        'Web Service Management' => 'Zarządzanie Web Service',
        'Debugger' => 'Debugger',
        'Go back to web service' => 'Powróć do usług sieciowych',
        'Clear' => 'Wyczyść',
        'Do you really want to clear the debug log of this web service?' =>
            'Czy na pewno chcesz wyczyścić log debug tego serwisu sieciowego?',
        'Request List' => 'Lista żądań',
        'Time' => 'Czas',
        'Communication ID' => 'Identyfikator komunikacji',
        'Remote IP' => 'Zdalny IP',
        'Loading' => 'Ładowanie',
        'Select a single request to see its details.' => 'Zaznacz pojedyncze żądanie aby zobaczyć jego szczegóły.',
        'Filter by type' => 'Filtruj po typie',
        'Filter from' => 'Filtruj od',
        'Filter to' => 'Filtruj do',
        'Filter by remote IP' => 'Filtruj po zdalnym IP',
        'Limit' => 'Limit',
        'Refresh' => 'Odswież',

        # Template: AdminGenericInterfaceErrorHandlingDefault
        'Add ErrorHandling' => 'Dodaj obsługę błędu',
        'Edit ErrorHandling' => 'Edytuj obsługę błędu',
        'Do you really want to delete this error handling module?' => 'Czy na pewno chcesz usunąć ten moduł obsługi błędów?',
        'All configuration data will be lost.' => 'Cała konfiguracja zostanie utracona.',
        'General options' => 'Opcje ogólne',
        'The name can be used to distinguish different error handling configurations.' =>
            'Nazwa może być używana do rozróżniania różnych konfiguracji obsługi błędów.',
        'Please provide a unique name for this web service.' => 'Podaj unikalną nazwę dla tego serwisu sieciowego.',
        'Error handling module backend' => 'Moduł obsługi błędów',
        'This OTRS error handling backend module will be called internally to process the error handling mechanism.' =>
            'Ten moduł zaplecza obsługi błędów OTRS będzie wywoływany wewnętrznie w celu przetworzenia mechanizmu obsługi błędów.',
        'Processing options' => 'Opcje przetwarzania',
        'Configure filters to control error handling module execution.' =>
            'Skonfiguruj filtry, aby kontrolować wykonywanie modułu obsługi błędów.',
        'Only requests matching all configured filters (if any) will trigger module execution.' =>
            'Tylko żądania pasujące do wszystkich skonfigurowanych filtrów (jeśli są) będą pozwalać na wykonanie modułu.',
        'Operation filter' => 'Filtr operacji',
        'Only execute error handling module for selected operations.' => 'Wykonuj tylko moduł obsługi błędów dla wybranych operacji.',
        'Note: Operation is undetermined for errors occuring while receiving incoming request data. Filters involving this error stage should not use operation filter.' =>
            'Uwaga: Operacja nieokreślona dla błędów występujących podczas odbierania przychodzących danych żądania. Filtry z tym stopniem błędu nie powinny używać filtra operacji.',
        'Invoker filter' => 'FIltr odwołujący',
        'Only execute error handling module for selected invokers.' => 'Wykonuj tylko moduł obsługi błędów dla wybranych odwołań.',
        'Error message content filter' => 'Filtr treści komunikatu o błędzie',
        'Enter a regular expression to restrict which error messages should cause error handling module execution.' =>
            'Wprowadź wyrażenie regularne, aby ograniczyć, które komunikaty o błędach powinny spowodować wykonanie modułu obsługi błędów.',
        'Error message subject and data (as seen in the debugger error entry) will considered for a match.' =>
            'Obiekt z komunikatem o błędzie i dane (widoczne w opisie błędu debuggera) zostaną uwzględnione w dopasowaniu.',
        'Example: Enter \'^.*401 Unauthorized.*\$\' to handle only authentication related errors.' =>
            'Przykład: Wprowadź  \'^.*401 Unauthorized.*\$\', aby obsłużyć tylko błędy związane z uwierzytelnianiem.',
        'Error stage filter' => 'Filtr fazy błędu',
        'Only execute error handling module on errors that occur during specific processing stages.' =>
            'Moduł obsługi błędów należy uruchamiać wyłącznie w przypadku błędów, które występują podczas określonych etapów przetwarzania.',
        'Example: Handle only errors where mapping for outgoing data could not be applied.' =>
            'Przykład: błędy związane z obsługą tylko wtedy, gdy nie można zastosować mapowania dla danych wychodzących.',
        'Error code' => 'Kod błędu',
        'An error identifier for this error handling module.' => 'Identyfikator błędu dla tego modułu obsługi błędów.',
        'This identifier will be available in XSLT-Mapping and shown in debugger output.' =>
            'Ten identyfikator będzie dostępny w XSLT-Mapping i pokazany na wyjściu debuggera.',
        'Error message' => 'Komunikat błędu',
        'An error explanation for this error handling module.' => 'Objaśnienie błędu dla tego modułu obsługi błędów.',
        'This message will be available in XSLT-Mapping and shown in debugger output.' =>
            'Ta wiadomość będzie dostępna w XSLT-Mapping i pokazana na wyjściu debuggera.',
        'Define if processing should be stopped after module was executed, skipping all remaining modules or only those of the same backend.' =>
            'Zdefiniuj, czy przetwarzanie powinno zostać zatrzymane po wykonaniu modułu, pomijając wszystkie pozostałe moduły lub tylko te z tego samego zaplecza.',
        'Default behavior is to resume, processing the next module.' => 'Domyślnym zachowaniem jest wznowienie, przetwarzanie następnego modułu.',

        # Template: AdminGenericInterfaceErrorHandlingRequestRetry
        'This module allows to configure scheduled retries for failed requests.' =>
            'Ten moduł umożliwia skonfigurowanie zaplanowanych ponownych prób dla nieudanych żądań.',
        'Default behavior of GenericInterface web services is to send each request exactly once and not to reschedule after errors.' =>
            'Domyślnym zachowaniem usług WWW ogólnego interfejsu jest wysyłanie każdego żądania dokładnie jeden raz i nieprzekazywanie po błędach.',
        'If more than one module capable of scheduling a retry is executed for an individual request, the module executed last is authoritative and determines if a retry is scheduled.' =>
            'Jeśli dla pojedynczego żądania wykonywany jest więcej niż jeden moduł zdolny do planowania ponownej próby, ostatni wykonany moduł jest autorytatywny i określa, czy ponowna próba jest zaplanowana.',
        'Request retry options' => 'Poproś o opcje ponowienia',
        'Retry options are applied when requests cause error handling module execution (based on processing options).' =>
            'Opcje ponowienia są stosowane, gdy żądania powodują wykonanie modułu obsługi błędów (w oparciu o opcje przetwarzania).',
        'Schedule retry' => 'Zaplanuj powtórzenie',
        'Should requests causing an error be triggered again at a later time?' =>
            'Czy żądania powodujące błąd będą uruchamiane ponownie w późniejszym czasie?',
        'Initial retry interval' => 'Początkowy interwał ponawiania próby',
        'Interval after which to trigger the first retry.' => 'Czas po którym ma zostać uruchomiona pierwsza powtórka próby.',
        'Note: This and all further retry intervals are based on the error handling module execution time for the initial request.' =>
            'Uwaga: Ten i wszystkie kolejne interwały ponowienia są oparte na czasie wykonania modułu obsługi błędów dla początkowego żądania.',
        'Factor for further retries' => 'Współczynnik dla dalszych prób',
        'If a request returns an error even after a first retry, define if subsequent retries are triggered using the same interval or in increasing intervals.' =>
            'Jeżeli żądanie zwróci błąd również po pierwszej powtórce próby, określ czy kolejne próby mają być uruchamiane w takich samych interwałach lub coraz większych.',
        'Example: If a request is initially triggered at 10:00 with initial interval at \'1 minute\' and retry factor at \'2\', retries would be triggered at 10:01 (1 minute), 10:03 (2*1=2 minutes), 10:07 (2*2=4 minutes), 10:15 (2*4=8 minutes), ...' =>
            'Przykład: jeśli żądanie jest początkowo uruchamiane o godzinie 10:00 z początkowym odstępem czasu o wartości: 1 minuta i współczynnikiem powtórzenia: 2, ponowne próby będą uruchamiane o 10:01 (1 minuta), 10:03 (2 * 1 = 2 minuty), 10:07 (2 * 2 = 4 minuty), 10:15 (2 * 4 = 8 minut), ...',
        'Maximum retry interval' => 'Maksymalny interwał ponawiania prób',
        'If a retry interval factor of \'1.5\' or \'2\' is selected, undesirably long intervals can be prevented by defining the largest interval allowed.' =>
            'Jeżeli wybrano współczynnik interwału powtórzenia: 1,5 lub 2, można zapobiec niepożądanym długim interwałom, definiując maksymalny dopuszczalny przedział czasu.',
        'Intervals calculated to exceed the maximum retry interval will then automatically be shortened accordingly.' =>
            'Odstępy obliczone w celu przekroczenia maksymalnego interwału ponawiania będą wówczas automatycznie odpowiednio skracane.',
        'Example: If a request is initially triggered at 10:00 with initial interval at \'1 minute\', retry factor at \'2\' and maximum interval at \'5 minutes\', retries would be triggered at 10:01 (1 minute), 10:03 (2 minutes), 10:07 (4 minutes), 10:12 (8=>5 minutes), 10:17, ...' =>
            'Przykład: jeśli żądanie jest początkowo uruchamiane o godzinie 10:00 z początkowym interwałem: 1 minuta, współczynnik ponowienia: 2 i maksymalny czas: 5 minut, ponowne próby będą uruchamiane o 10:01 (1 minuta), 10:03 (2 minuty), 10:07 (4 minuty), 10:12 (8 => 5 minut), 10:17, ...',
        'Maximum retry count' => 'Maksymalna liczba powtórzeń',
        'Maximum number of retries before a failing request is discarded, not counting the initial request.' =>
            'Maksymalna liczba ponownych prób przed odrzuceniem żądania jest odrzucana, nie licząc początkowego żądania.',
        'Example: If a request is initially triggered at 10:00 with initial interval at \'1 minute\', retry factor at \'2\' and maximum retry count at \'2\', retries would be triggered at 10:01 and 10:02 only.' =>
            'Przykład: jeśli żądanie jest początkowo uruchamiane o godzinie 10:00 z początkowym interwałem: 1 minuta, współczynnik ponów: 2 i maksymalna liczba ponownych prób: 2, ponowne próby będą uruchamiane tylko o 10:01 i 10:02.',
        'Note: Maximum retry count might not be reached if a maximum retry period is configured as well and reached earlier.' =>
            'Uwaga: Maksymalna liczba powtórzeń może nie zostać osiągnięta, jeśli maksymalny czas ponowienia jest również skonfigurowany i osiągnięty wcześniej.',
        'This field must be empty or contain a positive number.' => 'To pole musi być puste lub zawierać liczbę dodatnią.',
        'Maximum retry period' => 'Maksymalny okres powtarzania',
        'Maximum period of time for retries of failing requests before they are discarded (based on the error handling module execution time for the initial request).' =>
            'Maksymalny czas ponowienia próśb o niepowodzenie przed ich odrzuceniem (w oparciu o czas wykonania modułu obsługi błędów dla pierwotnego żądania).',
        'Retries that would normally be triggered after maximum period is elapsed (according to retry interval calculation) will automatically be triggered at maximum period exactly.' =>
            'Próby, które normalnie byłyby uruchamiane po upływie maksymalnego okresu (zgodnie z obliczeniem przedziału czasu ponownej próby), będą automatycznie uruchamiane dokładnie w maksymalnym okresie.',
        'Example: If a request is initially triggered at 10:00 with initial interval at \'1 minute\', retry factor at \'2\' and maximum retry period at \'30 minutes\', retries would be triggered at 10:01, 10:03, 10:07, 10:15 and finally at 10:31=>10:30.' =>
            'Przykład: jeśli żądanie jest początkowo wyzwalane o godzinie 10:00 z początkowym interwałem:  minuta, współczynnikiem powtórzenia: 2 i maksymalnym czasem ponowienia próby po: 30 minutach. Ponowne próby będą uruchamiane o 10:01, 10:03, 10:07, 10:15 i wreszcie o 10:31 => 10:30.',
        'Note: Maximum retry period might not be reached if a maximum retry count is configured as well and reached earlier.' =>
            'Uwaga: Maksymalny czas ponowienia może nie zostać osiągnięty, jeśli maksymalna liczba ponownych prób jest również skonfigurowana i osiągnięta wcześniej.',

        # Template: AdminGenericInterfaceInvokerDefault
        'Add Invoker' => 'Dodaj wywołanie',
        'Edit Invoker' => 'Edytuj wywołanie',
        'Do you really want to delete this invoker?' => 'Czy na pewno chcesz usunąć ten invoker?',
        'Invoker Details' => 'Szczegóły invokera.',
        'The name is typically used to call up an operation of a remote web service.' =>
            'Nazwa jest zwykle używana do wywołania operacji zdalnego serwisu sieciowego.',
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
        'Condition' => 'Warunek',
        'Edit this event' => 'Edytuj to zdarzenie',
        'This invoker will be triggered by the configured events.' => 'Ten invoker będzie wykonany przez skonfigurowane zdarzenia.',
        'Add Event' => 'Dodaj wydarzenie',
        'To add a new event select the event object and event name and click on the "+" button' =>
            'Aby dodać nowe zdarzenie, zaznacz obiekt zdarzenia i nazwę zdarzenia i kliknij przycisk "+"',
        'Asynchronous event triggers are handled by the OTRS Scheduler Daemon in background (recommended).' =>
            'Wyzwalacze (triggery) zdarzeń asynchronicznych obsługiwane przez harmonogram OTRS pracujący w tle (zalecane)',
        'Synchronous event triggers would be processed directly during the web request.' =>
            'Triggery synchroniczne będą przetwarzane bezpośrednio w trakcie przetwarzania żądania web.',

        # Template: AdminGenericInterfaceInvokerEvent
        'GenericInterface Invoker Event Settings for Web Service %s' => '',
        'Go back to' => 'Powrót do',
        'Delete all conditions' => 'Usuń wszystkie warunki',
        'Do you really want to delete all the conditions for this event?' =>
            'Czy na pewno chcesz usunąć wszystkie warunki dla tego wydarzenia?',
        'General Settings' => 'Główne ustawienia',
        'Event type' => 'Typ wydarzenia',
        'Conditions' => 'Warunki',
        'Conditions can only operate on non-empty fields.' => 'Wyrażenia warunkowe mogą operować tylko na polach niepustych.',
        'Type of Linking between Conditions' => 'Typ połączenia pomiędzy warunkami',
        'Remove this Condition' => 'Usuń ten warunek',
        'Type of Linking' => 'Typ połączenia',
        'Fields' => 'Pola',
        'Add a new Field' => 'Dodaj nowe pole',
        'Remove this Field' => 'Usuń to pole',
        'And can\'t be repeated on the same condition.' => '',
        'Add New Condition' => 'Dodaj nowy warunek',

        # Template: AdminGenericInterfaceMappingSimple
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

        # Template: AdminGenericInterfaceMappingXSLT
        'General Shortcuts' => '',
        'MacOS Shortcuts' => 'Skróty MacOS',
        'Comment code' => '',
        'Uncomment code' => '',
        'Auto format code' => '',
        'Expand/Collapse code block' => 'Zwiń/Rozwiń blok kodu',
        'Find' => 'Znajdź',
        'Find next' => 'Znajdź następny',
        'Find previous' => 'Znajdź poprzedni',
        'Find and replace' => 'Znajdź i zamień',
        'Find and replace all' => 'Znajdź i zamień wszystko',
        'XSLT Mapping' => 'Mapowanie XSLT',
        'XSLT stylesheet' => 'Arkusz stylu XSLT',
        'The entered data is not a valid XSLT style sheet.' => 'Wprowadzone dane nie są prawidłowym arkuszem stylu XSLT.',
        'Here you can add or modify your XSLT mapping code.' => 'Tutaj możesz dodać lub zmodyfikować kod mapujący XSLT.',
        'The editing field allows you to use different functions like automatic formatting, window resize as well as tag- and bracket-completion.' =>
            '',
        'Data includes' => '',
        'Select one or more sets of data that were created at earlier request/response stages to be included in mappable data.' =>
            '',
        'These sets will appear in the data structure at \'/DataInclude/<DataSetName>\' (see debugger output of actual requests for details).' =>
            '',
        'Data key regex filters (before mapping)' => '',
        'Data key regex filters (after mapping)' => '',
        'Regular expressions' => 'Regularne wyrażenia',
        'Replace' => 'Zamień',
        'Remove regex' => 'Usuń regex',
        'Add regex' => 'Dodaj regex',
        'These filters can be used to transform keys using regular expressions.' =>
            '',
        'The data structure will be traversed recursively and all configured regexes will be applied to all keys.' =>
            '',
        'Use cases are e.g. removing key prefixes that are undesired or correcting keys that are invalid as XML element names.' =>
            '',
        'Example 1: Search = \'^jira:\' / Replace = \'\' turns \'jira:element\' into \'element\'.' =>
            '',
        'Example 2: Search = \'^\' / Replace = \'_\' turns \'16x16\' into \'_16x16\'.' =>
            '',
        'Example 3: Search = \'^(?<number>\d+) (?<text>.+?)\$\' / Replace = \'_\$+{text}_\$+{number}\' turns \'16 elementname\' into \'_elementname_16\'.' =>
            '',
        'For information about regular expressions in Perl please see here:' =>
            '',
        'Perl regular expressions tutorial' => 'Przewodnik wyrażeń regularnych Perla',
        'If modifiers are desired they have to be specified within the regexes themselves.' =>
            '',
        'Regular expressions defined here will be applied before the XSLT mapping.' =>
            '',
        'Regular expressions defined here will be applied after the XSLT mapping.' =>
            '',

        # Template: AdminGenericInterfaceOperationDefault
        'Add Operation' => 'Dodaj operację',
        'Edit Operation' => 'Zmień operację',
        'Do you really want to delete this operation?' => 'Czy na pewno chcesz usunąć tę operację?',
        'Operation Details' => 'Szczegóły operacji',
        'The name is typically used to call up this web service operation from a remote system.' =>
            'Nazwa jest zwykle używana do wywoływania tej operacji serwisu sieciowego ze zdalnego systemu.',
        'Operation backend' => 'Zaplecze operacji',
        'This OTRS operation backend module will be called internally to process the request, generating data for the response.' =>
            'Ten moduł zaplecza operacji OTRS będzie wywoływany wewnętrznie aby przetworzyć żądanie i wygenerować dane odpowiedzi.',
        'Mapping for incoming request data' => 'Mapowanie otrzymanych danych żądania',
        'The request data will be processed by this mapping, to transform it to the kind of data OTRS expects.' =>
            'Dane żądania będą przetwarzane przez to mapowanie aby przekształcić je do postaci oczekiwanej przez OTRS.',
        'Mapping for outgoing response data' => 'Mapowanie danych wysyłanej odpowiedzi',
        'The response data will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            'Dane odpowiedzi będą przetwarzane przez to mapowanie aby przetworzyć je do postaci oczekiwanej przez system zdalny.',
        'Include Ticket Data' => '',
        'Include ticket data in response.' => '',

        # Template: AdminGenericInterfaceTransportHTTPREST
        'Network Transport' => '',
        'Properties' => 'Właściwości',
        'Route mapping for Operation' => '',
        'Define the route that should get mapped to this operation. Variables marked by a \':\' will get mapped to the entered name and passed along with the others to the mapping. (e.g. /Ticket/:TicketID).' =>
            'Określ trasę, która powinna zostać odwzorowana dla tej operacji. Zmienne określone przez \':\' zostaną odwzorowane we wprowadzonej nazwie i przekazane dalej razem z innymi do odwzorowań (np. /Ticket/:TicketID).',
        'Valid request methods for Operation' => 'Poprawne metody wywołania dla tej operacji',
        'Limit this Operation to specific request methods. If no method is selected all requests will be accepted.' =>
            'Ogranicz tą operację do określonych metod wywołania. Jeżeli żadna metoda nie zostanie wybrana, wszystkie dostępne metody będą akceptowane',
        'Maximum message length' => 'Maksymalna długość wiadomości',
        'This field should be an integer number.' => 'To pole powinno być liczbą całkowitą.',
        'Here you can specify the maximum size (in bytes) of REST messages that OTRS will process.' =>
            'Tu możesz określić maksymalny rozmiar komunikatów REST, które OTRS będzie przetwarzał (w bajtach).',
        'Send Keep-Alive' => 'Wysyłaj "Keep-Alive" (podtrzymuj)',
        'This configuration defines if incoming connections should get closed or kept alive.' =>
            'Ta konfiguracja określa czy przychodzące połączenia powinny być zamknięte lub utrzymane. ',
        'Additional response headers' => '',
        'Add response header' => '',
        'Endpoint' => 'Punkt końcowy',
        'URI to indicate specific location for accessing a web service.' =>
            '',
        'e.g https://www.otrs.com:10745/api/v1.0 (without trailing backslash)' =>
            'np. https://www.otrs.com:10745/api/v1.0 (bez ukośnika na końcu)',
        'Timeout' => 'Czas wygaśnięcia',
        'Timeout value for requests.' => '',
        'Authentication' => 'Autentykacja',
        'An optional authentication mechanism to access the remote system.' =>
            '',
        'BasicAuth User' => 'BasicAuth Użytkownik',
        'The user name to be used to access the remote system.' => 'Nazwa użytkownika do logowania do zdalnego systemu.',
        'BasicAuth Password' => 'BasicAuth Hasło',
        'The password for the privileged user.' => 'Hasło użytkownika do logowania do zdalnego systemu.',
        'Use Proxy Options' => 'Użyj ustawień proxy',
        'Show or hide Proxy options to connect to the remote system.' => 'Pokaż lub ukryj ustawienia Proxy aby połączyć się z systemem zdalnym',
        'Proxy Server' => 'Serwer proxy',
        'URI of a proxy server to be used (if needed).' => 'URI serwera proxy jeśli ma być używany (jeśli wymagane).',
        'e.g. http://proxy_hostname:8080' => 'np. http://proxy_hostname:8080',
        'Proxy User' => 'Użytkownik proxy',
        'The user name to be used to access the proxy server.' => 'Nazwa użytkownika, która ma być używana do logowania do serwera proxy.',
        'Proxy Password' => 'Hasło do proxy',
        'The password for the proxy user.' => 'Hasło użytkownika proxy.',
        'Skip Proxy' => 'Pomiń Proxy',
        'Skip proxy servers that might be configured globally?' => 'Pomiń serwery proxy może być skonfigurowane globalnie?',
        'Use SSL Options' => 'Użyj opcji SSL',
        'Show or hide SSL options to connect to the remote system.' => 'Pokaż lub ukryj opcje SSL połączenia do zdalnego systemu.',
        'Client Certificate' => 'Certyfikat Klienta',
        'The full path and name of the SSL client certificate file (must be in PEM, DER or PKCS#12 format).' =>
            'Pełna ścieżka i nazwa pliku certyfikatu SSL klienta (powinno być: PEM, DER lub PKCS#12 format)',
        'e.g. /opt/otrs/var/certificates/SOAP/certificate.pem' => 'np. /opt/otrs/var/certificates/SOAP/certificate.pem',
        'Client Certificate Key' => 'Klucz Certyfikatu Klienta',
        'The full path and name of the SSL client certificate key file (if not already included in certificate file).' =>
            'Pełna ścieżka i nazwa pliku certyfikatu SSL klienta (jeśli nie jest włączone w plik certyfikatu)',
        'e.g. /opt/otrs/var/certificates/SOAP/key.pem' => 'np. /opt/otrs/var/certificates/SOAP/key.pem',
        'Client Certificate Key Password' => 'Hasło Klucza Certyfikatu Klienta',
        'The password to open the SSL certificate if the key is encrypted.' =>
            'Hasło do otwarcia certyfikatu SSL jeśli jest zaszyfrowany.',
        'Certification Authority (CA) Certificate' => '',
        'The full path and name of the certification authority certificate file that validates SSL certificate.' =>
            'Pełna ścieżka i nazwa pliku z certyfikatem CA, który potwierdza certyfikat SSL.',
        'e.g. /opt/otrs/var/certificates/SOAP/CA/ca.pem' => 'np. /opt/otrs/var/certificates/SOAP/CA/ca.pem',
        'Certification Authority (CA) Directory' => 'Katalog Certification Authority (CA)',
        'The full path of the certification authority directory where the CA certificates are stored in the file system.' =>
            'Pełna ścieżka do katalogu gdzie znajdują się certyfikaty CA.',
        'e.g. /opt/otrs/var/certificates/SOAP/CA' => 'np. /opt/otrs/var/certificates/SOAP/CA',
        'Controller mapping for Invoker' => '',
        'The controller that the invoker should send requests to. Variables marked by a \':\' will get replaced by the data value and passed along with the request. (e.g. /Ticket/:TicketID?UserLogin=:UserLogin&Password=:Password).' =>
            '',
        'Valid request command for Invoker' => '',
        'A specific HTTP command to use for the requests with this Invoker (optional).' =>
            '',
        'Default command' => 'Polecenie domyślne',
        'The default HTTP command to use for the requests.' => '',

        # Template: AdminGenericInterfaceTransportHTTPSOAP
        'e.g. https://local.otrs.com:8000/Webservice/Example' => 'np. https://local.otrs.com:8000/Webservice/Example',
        'Set SOAPAction' => 'Ustaw SOAPAction',
        'Set to "Yes" in order to send a filled SOAPAction header.' => '',
        'Set to "No" in order to send an empty SOAPAction header.' => '',
        'Set to "Yes" in order to check the received SOAPAction header (if not empty).' =>
            '',
        'Set to "No" in order to ignore the received SOAPAction header.' =>
            '',
        'SOAPAction scheme' => '',
        'Select how SOAPAction should be constructed.' => '',
        'Some web services require a specific construction.' => '',
        'Some web services send a specific construction.' => '',
        'SOAPAction separator' => 'Separator SOAPAction',
        'Character to use as separator between name space and SOAP operation.' =>
            '',
        'Usually .Net web services use "/" as separator.' => '',
        'SOAPAction free text' => '',
        'Text to be used to as SOAPAction.' => '',
        'Namespace' => 'Namespace',
        'URI to give SOAP methods a context, reducing ambiguities.' => 'URI nadające kontekst metodom SOAP w celu uniknięcia niejednoznaczności.',
        'e.g urn:otrs-com:soap:functions or http://www.otrs.com/GenericInterface/actions' =>
            'np. urn:otrs-com:soap:functions lub http://www.otrs.com/GenericInterface/actions',
        'Request name scheme' => '',
        'Select how SOAP request function wrapper should be constructed.' =>
            '',
        '\'FunctionName\' is used as example for actual invoker/operation name.' =>
            '',
        '\'FreeText\' is used as example for actual configured value.' =>
            '',
        'Request name free text' => '',
        'Text to be used to as function wrapper name suffix or replacement.' =>
            '',
        'Please consider XML element naming restrictions (e.g. don\'t use \'<\' and \'&\').' =>
            '',
        'Response name scheme' => '',
        'Select how SOAP response function wrapper should be constructed.' =>
            '',
        'Response name free text' => '',
        'Here you can specify the maximum size (in bytes) of SOAP messages that OTRS will process.' =>
            'Tutaj możesz określić maksymalny rozmiar (w bajtach) wiadomości SOAP, które OTRS będzie przetwarzać.',
        'Encoding' => 'Kodowanie',
        'The character encoding for the SOAP message contents.' => 'Kodowanie znaków dla zawartości wiadomości SOAP.',
        'e.g utf-8, latin1, iso-8859-1, cp1250, Etc.' => 'np. utf-8, latin1, iso-8859-1, cp1250, etc.',
        'Sort options' => 'Opcje sortowania',
        'Add new first level element' => 'Dodaj element pierwszego poziomu',
        'Element' => 'Element',
        'Outbound sort order for xml fields (structure starting below function name wrapper) - see documentation for SOAP transport.' =>
            '',

        # Template: AdminGenericInterfaceWebservice
        'Add Web Service' => 'Dodaj Web Service',
        'Edit Web Service' => 'Zmień Web Service',
        'Clone Web Service' => 'Zamknij Web Service',
        'The name must be unique.' => 'Nazwa musi być unikalna',
        'Clone' => 'Klonuj',
        'Export Web Service' => 'Eksportuj Web Service',
        'Import web service' => 'Importuj serwis sieciowy',
        'Configuration File' => 'Plik konfiguracyjny.',
        'The file must be a valid web service configuration YAML file.' =>
            'Plik musi być poprawnym plikiem konfiguracyjnym YAML web service.',
        'Here you can specify a name for the webservice. If this field is empty, the name of the configuration file is used as name.' =>
            '',
        'Import' => 'Importuj',
        'Configuration History' => 'Konfiguracja Historii',
        'Delete web service' => 'Usuń serwis sieciowy',
        'Do you really want to delete this web service?' => 'Czy na pewno chcesz usunąć serwis siecioy?',
        'Ready2Adopt Web Services' => '',
        'Here you can activate Ready2Adopt web services showcasing our best practices that are a part of %s.' =>
            '',
        'Please note that these web services may depend on other modules only available with certain %s contract levels (there will be a notification with further details when importing).' =>
            '',
        'Import Ready2Adopt web service' => '',
        'Would you like to benefit from web services created by experts? Upgrade to %s to import some sophisticated Ready2Adopt web services.' =>
            '',
        'After you save the configuration you will be redirected again to the edit screen.' =>
            'Po zapisaniu konfiguracji będziesz przekierowany ponownie do ekranu edycji.',
        'If you want to return to overview please click the "Go to overview" button.' =>
            'Jeśli chcesz wrócić do przeglądu, kliknij przycisk "Idź do przeglądu".',
        'Remote system' => 'Zdalny system',
        'Provider transport' => 'Transport serwera',
        'Requester transport' => 'Transport klienta',
        'Debug threshold' => 'Poziom debugowania',
        'In provider mode, OTRS offers web services which are used by remote systems.' =>
            'W trybie serwera OTRS udostępnia usługi sieciowe, które są używane przez zdalne systemy.',
        'In requester mode, OTRS uses web services of remote systems.' =>
            'W trybie klienta OTRS używa usług systemów zdalnych.',
        'Network transport' => 'Transport sieciowy',
        'Error Handling Modules' => '',
        'Error handling modules are used to react in case of errors during the communication. Those modules are executed in a specific order, which can be changed by drag and drop.' =>
            '',
        'Backend' => 'Zaplecze',
        'Add error handling module' => '',
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

        # Template: AdminGenericInterfaceWebserviceHistory
        'History' => 'Historia',
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

        # Template: AdminGroup
        'Group Management' => 'Zarządzanie grupami',
        'Add Group' => 'Dodaj grupę',
        'Edit Group' => 'Edytuj Grupę',
        'The admin group is to get in the admin area and the stats group to get stats area.' =>
            'Grupa Admin posiada prawa do Administracji systemem. Grupa Stats umożliwia przeglądanie statystyk zgłoszeń.',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...). ' =>
            'Utwórz nowe grupy aby obsłużyć prawa dostępu dla różnych grup agentów (np. działu zakupu, działu wsparcia, działu sprzedaży, ...). ',
        'It\'s useful for ASP solutions. ' => 'Przydatne dla rozwiązań ASP. ',

        # Template: AdminLog
        'System Log' => 'Log systemu',
        'Here you will find log information about your system.' => 'Tutaj znajdziesz informacje o swoim systemie OTRS',
        'Hide this message' => 'Ukryj tę wiadomość',
        'Recent Log Entries' => 'Ostatnie pozycje loga',
        'Facility' => 'Obiekt',
        'Message' => 'Informacja',

        # Template: AdminMailAccount
        'Mail Account Management' => 'Zarządzanie kontami e-mail',
        'Add Mail Account' => 'Dodaj Konto Pocztowe',
        'Edit Mail Account for host' => 'Zmień konto mailowe dla hosta',
        'and user account' => 'i konto użytkownika',
        'Filter for Mail Accounts' => 'Filtruj po Konta E-Mail',
        'Filter for mail accounts' => 'Filtruj po konta e-mail',
        'All incoming emails with one account will be dispatched in the selected queue.' =>
            'Wszystkie przychodzące na jedno konto wiadomości będą umieszczone w zaznacznej kolejce.',
        'If your account is marked as trusted, the X-OTRS headers already existing at arrival time (for priority etc.) will be kept and used, for example in PostMaster filters.' =>
            '',
        'Outgoing email can be configured via the Sendmail* settings in %s.' =>
            'Wychodzące emaile będą skonfigurowane przez ustawienia Sendmail* w %s.',
        'System Configuration' => 'Konfiguracja Systemu',
        'Host' => 'Adres',
        'Delete account' => 'Usuń konto',
        'Fetch mail' => 'Pobierz pocztę',
        'Do you really want to delete this mail account?' => 'Czy naprawdę chcesz usunąć to konto e-mail?',
        'Password' => 'Hasło',
        'Example: mail.example.com' => 'Na przykład: mail.example.com',
        'IMAP Folder' => 'Folder IMAP',
        'Only modify this if you need to fetch mail from a different folder than INBOX.' =>
            'Zmień to jeśli potrzebujesz pobirać pocztę z innego foldera niż INBOX.',
        'Trusted' => 'Zaufane',
        'Dispatching' => 'Przekazanie',
        'Edit Mail Account' => 'Edytuj Konto Pocztowe',

        # Template: AdminNavigationBar
        'Administration Overview' => 'Podgląd administracyjny',
        'Filter for Items' => 'Filtr pozycji',
        'Filter' => 'Filtr',
        'Favorites' => 'Ulubione',
        'You can add favorites by moving your cursor over items on the right side and clicking the star icon.' =>
            '',
        'Links' => 'Linki',
        'View the admin manual on Github' => 'Zobacz Instrukcję administratora na Github',
        'No Matches' => 'Brak Dopasowań',
        'Sorry, your search didn\'t match any items.' => 'Niestety twoje kryteria wyszukiwania nie pasują do żadnych elementów.',
        'Set as favorite' => 'Ustaw jako ulubiony',

        # Template: AdminNotificationEvent
        'Ticket Notification Management' => 'Zarządzanie powiadomieniami ',
        'Here you can upload a configuration file to import Ticket Notifications to your system. The file needs to be in .yml format as exported by the Ticket Notification module.' =>
            '',
        'Here you can choose which events will trigger this notification. An additional ticket filter can be applied below to only send for ticket with certain criteria.' =>
            'Tu możesz wybrać które zdarzenia będą wywoływać te powiadomienie. Poniżej może zostać zastosowany dodatkowy filtr zgłoszeń by wysyłać powiadomienie tylko dla zgłoszeń spełniających określone kryteria.',
        'Ticket Filter' => 'Filtr zgłoszeń',
        'Lock' => 'Blokada',
        'SLA' => 'SLA',
        'Customer User ID' => 'ID Użytkownika Klienta',
        'Article Filter' => 'Filtr wiadomości',
        'Only for ArticleCreate and ArticleSend event' => 'Tylko w przypadku UtworzeniaWiadomości lub WysłaniaWiadomości',
        'Article sender type' => 'Typ nadawcy wiadomości',
        'If ArticleCreate or ArticleSend is used as a trigger event, you need to specify an article filter as well. Please select at least one of the article filter fields.' =>
            'Jeśli UtworzenieWiadomości lub WysłanieWiadomości inicjuje jakieś zdarzenie, konieczne jest również określenie filtra wiadomości. Należy wybrać co najmniej jedno pole pole filtrowania wiadomości.',
        'Customer visibility' => 'Widoczność Klienta',
        'Communication channel' => 'Kanał komunikacji',
        'Include attachments to notification' => 'Umieść załączniki w powiadomieniu',
        'Notify user just once per day about a single ticket using a selected transport.' =>
            'Powiadamiaj użytkownika raz na dzień o pojedynczym tickecie używając wybranego sposobu',
        'This field is required and must have less than 4000 characters.' =>
            'To pole jest wymagane i musi być krótsze niż 4000 znaków.',
        'Notifications are sent to an agent or a customer.' => 'Powiadomienia są wysyłane do agenta obsługi lub klienta',
        'To get the first 20 character of the subject (of the latest agent article).' =>
            'Aby uzyskać pierwsze 20 znaków tematu (najnowszej wiadomości agenta).',
        'To get the first 5 lines of the body (of the latest agent article).' =>
            'Aby uzyskać pierwsze 5 linii treści (najnowszej wiadomości agenta).',
        'To get the first 20 character of the subject (of the latest customer article).' =>
            'Aby uzyskać pierwsze 20 znaków tematu (najnowszej wiadomości klienta).',
        'To get the first 5 lines of the body (of the latest customer article).' =>
            'Aby uzyskać pierwsze 5 linii treści (najnowszej wiadomości klienta).',
        'Attributes of the current customer user data' => 'Atrybuty danych obecnego użytkownika klienta',
        'Attributes of the current ticket owner user data' => 'Atrybuty danych użytkownika aktualnego właściciela zgłoszenia',
        'Attributes of the current ticket responsible user data' => 'Atrybuty danych użytkownika aktualnego odpowiedzialnego za zgłoszenie',
        'Attributes of the current agent user who requested this action' =>
            'Opcje bieżącego agenta, który żądał akcji',
        'Attributes of the ticket data' => 'Atrybuty danych zgłoszenia',
        'Ticket dynamic fields internal key values' => 'Wartości wewnętrznych kluczy pól dynamicznych',
        'Ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            'Wyświetlane wartości pól dynamicznych zgłoszeń, przydatne dla pól list rozwijanych i wielokrotnego wyboru.',

        # Template: AdminNotificationEventTransportEmailSettings
        'Use comma or semicolon to separate email addresses.' => '',
        'You can use OTRS-tags like <OTRS_TICKET_DynamicField_...> to insert values from the current ticket.' =>
            'Aby wstawić wartości z bieżącego zgłoszenia, możesz użyć tagów OTRS takich jak <OTRS_TICKET_DynamicField_...>',

        # Template: AdminOTRSBusinessInstalled
        'Manage %s' => 'Zarządzaj %s',
        'Downgrade to ((OTRS)) Community Edition' => '',
        'Read documentation' => 'Przeczytaj dokument',
        '%s makes contact regularly with cloud.otrs.com to check on available updates and the validity of the underlying contract.' =>
            '',
        'Unauthorized Usage Detected' => 'Wykryto nieautoryzowane użycie',
        'This system uses the %s without a proper license! Please make contact with %s to renew or activate your contract!' =>
            '',
        '%s not Correctly Installed' => '%s jest nie poprawnie zainstalowany',
        'Your %s is not correctly installed. Please reinstall it with the button below.' =>
            'Twój %s nie jest poprawnie zainstalowany. Przeinstaluj, klikając na przycisk poniżej',
        'Reinstall %s' => 'Zainstaluj ponownie %s',
        'Your %s is not correctly installed, and there is also an update available.' =>
            'Twój %s nie jest poprawnie zainstalowany, jest również dostępna aktualizacja.',
        'You can either reinstall your current version or perform an update with the buttons below (update recommended).' =>
            '',
        'Update %s' => 'Zaktualizuj %s',
        '%s Not Yet Available' => '%s jeszcze nie jest dostępne',
        '%s will be available soon.' => '%s wkrótce będzie dostępne.',
        '%s Update Available' => '%s dostępna jest aktualizacja',
        'An update for your %s is available! Please update at your earliest!' =>
            '',
        '%s Correctly Deployed' => '%s poprawnie wdrożony',
        'Congratulations, your %s is correctly installed and up to date!' =>
            'Gratulacje, twój %szostał poprawnie zainstalowany i jest aktualny.',

        # Template: AdminOTRSBusinessNotInstalled
        'Go to the OTRS customer portal' => 'Przejdź do portalu klienta OTRS',
        '%s will be available soon. Please check again in a few days.' =>
            '%s będzie dostępny niebawem. Sprawdź ponownie za kilka dni.',
        'Please have a look at %s for more information.' => 'Spójrz na %s aby uzyskać więcej informacji.',
        'Your ((OTRS)) Community Edition is the base for all future actions. Please register first before you continue with the upgrade process of %s!' =>
            '',
        'Before you can benefit from %s, please contact %s to get your %s contract.' =>
            '',
        'Connection to cloud.otrs.com via HTTPS couldn\'t be established. Please make sure that your OTRS can connect to cloud.otrs.com via port 443.' =>
            'Połączenie do cloud.otrs.com przez HTTPS nie mogło zostać zestawione. Upewnij się, że Twój OTRS może podłączyć się do cloud.otrs.com po 443 porcie.',
        'Package installation requires patch level update of OTRS.' => 'Instalacja pakietu wymaga zastosowania odpowiedniego poziomu aktualizacji OTRS',
        'Please visit our customer portal and file a request.' => '',
        'Everything else will be done as part of your contract.' => '',
        'Your installed OTRS version is %s.' => 'Twoja zainstalowana wersja OTRS to %s',
        'To install this package, you need to update to OTRS %s or higher.' =>
            '',
        'To install this package, the Maximum OTRS Version is %s.' => '',
        'To install this package, the required Framework version is %s.' =>
            '',
        'Why should I keep OTRS up to date?' => 'Dlaczego powinienem aktualizować OTRS?',
        'You will receive updates about relevant security issues.' => '',
        'You will receive updates for all other relevant OTRS issues' => '',
        'With your existing contract you can only use a small part of the %s.' =>
            '',
        'If you would like to take full advantage of the %s get your contract upgraded now! Contact %s.' =>
            '',

        # Template: AdminOTRSBusinessUninstall
        'Cancel downgrade and go back' => 'Przerwij downgrade i wróć',
        'Go to OTRS Package Manager' => 'Przejdź do menedżera pakietów OTRS',
        'Sorry, but currently you can\'t downgrade due to the following packages which depend on %s:' =>
            '',
        'Vendor' => 'Producent',
        'Please uninstall the packages first using the package manager and try again.' =>
            'Odinstaluj najpierw pakiety za pomocą menedżera pakietów i spróbuj ponownie.',
        'You are about to downgrade to ((OTRS)) Community Edition and will lose the following features and all data related to these:' =>
            '',
        'Chat' => 'Czat',
        'Report Generator' => 'Generator Raportów',
        'Timeline view in ticket zoom' => '',
        'DynamicField ContactWithData' => '',
        'DynamicField Database' => 'Baza danych pól dynamicznych',
        'SLA Selection Dialog' => 'Okno wyboru SLA',
        'Ticket Attachment View' => 'Widok załącznika zgłoszenia',
        'The %s skin' => '',

        # Template: AdminPGP
        'PGP Management' => 'Zarządzanie PGP',
        'Add PGP Key' => 'Dodaj klucz PGP',
        'PGP support is disabled' => 'Wsparcie dla PGP jest wyłączone',
        'To be able to use PGP in OTRS, you have to enable it first.' => 'Aby móc używać PGP w OTRS musisz najpierw włączyć dla niego wsparcie.',
        'Enable PGP support' => 'Aktywuj wsparcie dla PGP',
        'Faulty PGP configuration' => 'Błędna konfiguracja PGP',
        'PGP support is enabled, but the relevant configuration contains errors. Please check the configuration using the button below.' =>
            'Wsparcie dla PGP jest włączone, ale odpowiadająca mu konfiguracja zawiera błędy. Sprawdź proszę konfigurację używając przycisku poniżej.',
        'Configure it here!' => 'Skonfiguruj to tutaj!',
        'Check PGP configuration' => 'Sprawdź konfigurację PGP',
        'In this way you can directly edit the keyring configured in SysConfig.' =>
            'W ten sposób mozesz bezpośrednio edytować plik kluczy skonfigurowany w SysConfig.',
        'Introduction to PGP' => 'Wprowadenie do PGP',
        'Identifier' => 'Identyfikator',
        'Bit' => 'Bit',
        'Fingerprint' => 'Znacznik (fingerprint)',
        'Expires' => 'Wygasa',
        'Delete this key' => 'Usuń ten klucz',
        'PGP key' => 'Klucz PGP',

        # Template: AdminPackageManager
        'Package Manager' => 'Menedżer pakietów',
        'Uninstall Package' => 'Odinstaluj pakiet',
        'Uninstall package' => 'Odinstaluj pakiet',
        'Do you really want to uninstall this package?' => 'Czy na pewno chcesz odinstalować ten pakiet?',
        'Reinstall package' => 'Reinstaluj pakiet',
        'Do you really want to reinstall this package? Any manual changes will be lost.' =>
            'Czy na pewno chcesz reinstalować ten pakiet? Wszystkie ręczne modyfikacje będą utracone.',
        'Go to updating instructions' => '',
        'package information' => 'informacja o pakiecie',
        'Package installation requires a patch level update of OTRS.' => 'Instalacja pakietu wymaga zastosowania odpowiedniego poziomu aktualizacji OTRS',
        'Package update requires a patch level update of OTRS.' => 'Aktualizacja pakietu wymaga zastosowania odpowiedniego poziomu aktualizacji OTRS',
        'If you are a OTRS Business Solution™ customer, please visit our customer portal and file a request.' =>
            '',
        'Please note that your installed OTRS version is %s.' => 'Zauważ, że twoja zainstalowana wersja OTRS to %s',
        'To install this package, you need to update OTRS to version %s or newer.' =>
            'Aby zainstalować ten pakiet musisz zaktualizować OTRS do wersji%s lub nowszej.',
        'This package can only be installed on OTRS version %s or older.' =>
            'Ten pakiet może być zainstalowany w OTRS jedynie w wersji %s lub starszej.',
        'This package can only be installed on OTRS version %s or newer.' =>
            'Ten pakiet może być zainstalowany w OTRS jedynie w wersji %s lub nowszej.',
        'You will receive updates for all other relevant OTRS issues.' =>
            'Będziesz otrzymywał informacje o innych istotnych problemach w OTRS.',
        'How can I do a patch level update if I don’t have a contract?' =>
            '',
        'Please find all relevant information within the updating instructions at %s.' =>
            '',
        'In case you would have further questions we would be glad to answer them.' =>
            'W przyapdku gdy posiadasz dodatkowe pytania będziemy zadowoleni by móc na nie odpowiedzieć.',
        'Install Package' => 'Instaluj pakiet',
        'Update Package' => 'Aktualizuj pakiet',
        'Continue' => 'Kontynuuj',
        'Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            'Proszę upewnij się, że baza danych akceptuje rozmiar powyżej %s (ona obecnie akceptuje pakiety tylko do %s MB). Proszę zmień ustawienie max_allowed_packet by uniknąć błędów w bazie danych.',
        'Install' => 'Instaluj',
        'Update repository information' => 'Zaktualizuj informację o repozytoriach',
        'Cloud services are currently disabled.' => 'Usługi w chmurze są wyłączone.',
        'OTRS Verify™ can not continue!' => '',
        'Enable cloud services' => 'Uruchom usługi w churze',
        'Update all installed packages' => 'Zaktualizuj wszystkie zainstalowane pakiety',
        'Online Repository' => 'Baza on-line',
        'Action' => 'Akcja',
        'Module documentation' => 'Dokumentacja modułu',
        'Local Repository' => 'Lokalna baza',
        'This package is verified by OTRSverify (tm)' => 'Ten pakiet został zweryfikowany poprzez OTRSverify (tm)',
        'Uninstall' => 'Odinstaluj',
        'Package not correctly deployed! Please reinstall the package.' =>
            'Pakiet wdrożony nieprawidłowo! Zainstaluj pakiet ponownie.',
        'Reinstall' => 'Przeinstaluj',
        'Features for %s customers only' => 'Funkcje tylko dla %s klientów',
        'With %s, you can benefit from the following optional features. Please make contact with %s if you need more information.' =>
            '',
        'Package Information' => 'Informacja o pakietach',
        'Download package' => 'Pobierz pakiet',
        'Rebuild package' => 'Przebuduj pakiet',
        'Metadata' => 'Metadane',
        'Change Log' => 'Log zmian',
        'Date' => 'Data',
        'List of Files' => 'Lista plików',
        'Permission' => 'Prawo dostępu',
        'Download file from package!' => 'Pobierz plik z pakietu!',
        'Required' => 'Wymagany',
        'Size' => 'Rozmiar',
        'Primary Key' => 'Klucz podstawowy',
        'Auto Increment' => 'Automatycznie zwiększane',
        'SQL' => 'SQL',
        'File Differences for File %s' => '',
        'File differences for file %s' => 'Różnice plikowe dla pliku %s',

        # Template: AdminPerformanceLog
        'Performance Log' => 'Log wydajnosci',
        'Range' => 'Zakres',
        'last' => 'w ciągu',
        'This feature is enabled!' => 'Ta funkcja jest włączona!',
        'Just use this feature if you want to log each request.' => 'Wybierz tę opcję jeżeli chcesz logować każde żądanie.',
        'Activating this feature might affect your system performance!' =>
            'Włączenie tej opcji może wpłynąć na wydajność twojego systemu!',
        'Disable it here!' => 'Wyłącz tutaj!',
        'Logfile too large!' => 'Plik log jest za duży!',
        'The logfile is too large, you need to reset it' => 'Log jest zbyt duży - musisz go zresetować!',
        'Reset' => 'Resetuj',
        'Overview' => 'Przegląd',
        'Interface' => 'Interfejs',
        'Requests' => 'Żądania',
        'Min Response' => 'Min. odpowiedź',
        'Max Response' => 'Max odpowiedź',
        'Average Response' => 'Średnia odpowiedź',
        'Period' => 'Okres',
        'minutes' => 'minut(-y)',
        'Min' => 'Min.',
        'Max' => 'Max.',
        'Average' => 'Średnia',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => 'Zarządzanie filtrami poczty przychodzącej',
        'Add PostMaster Filter' => 'Dodaj filtr pocztowy',
        'Edit PostMaster Filter' => 'Edytuj filtr pocztowy',
        'Filter for PostMaster Filters' => '',
        'Filter for PostMaster filters' => '',
        'To dispatch or filter incoming emails based on email headers. Matching using Regular Expressions is also possible.' =>
            'Aby rozdzielić lub odfiltrować napływające wiadomości e-mail na podstawie nagłówków e-mail. Możliwe dopasowywanie przy użyciu wyrażeń regularnych.',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' =>
            'Jeżeli chcesz tylko dopasować adres e-mail użyj EMAILADDRESS:info@example.com w polach Od, Do lub Cc.',
        'If you use Regular Expressions, you also can use the matched value in () as [***] in the \'Set\' action.' =>
            'Jeśli użyjesz wyrażeń regularnych, możesz również użyć dopasowanej wartości w () jako [***] w akcji \'Set\'.',
        'You can also use named captures %s and use the names in the \'Set\' action %s (e.g. Regexp: %s, Set action: %s). A matched EMAILADDRESS has the name \'%s\'.' =>
            '',
        'Delete this filter' => 'Usuń ten filtr',
        'Do you really want to delete this postmaster filter?' => 'Czy na pewno chcesz skasować ten filtr pocztowy?',
        'A postmaster filter with this name already exists!' => 'Filtr poczty o takiej nazwie już istnieje!',
        'Filter Condition' => 'Warunek filtra',
        'AND Condition' => 'Warunek ORAZ',
        'Search header field' => '',
        'for value' => 'dla wartości',
        'The field needs to be a valid regular expression or a literal word.' =>
            'Pole musi zawierać poprawne wyrażenie regularne lub słowo.',
        'Negate' => 'Zaprzeczenie',
        'Set Email Headers' => 'Ustaw nagłówek e-mail',
        'Set email header' => 'Ustaw nagłówek wiadomości e-mail',
        'with value' => 'z wartością',
        'The field needs to be a literal word.' => 'Pole musi zawierać słowo.',
        'Header' => 'Nagłówek',

        # Template: AdminPriority
        'Priority Management' => 'Zarządzanie priorytetami',
        'Add Priority' => 'Dodaj priorytet',
        'Edit Priority' => 'Edytuj priorytet',
        'Filter for Priorities' => 'Filtr dla Priorytetów',
        'Filter for priorities' => 'Filtr dla priorytetów',
        'This priority is present in a SysConfig setting, confirmation for updating settings to point to the new priority is needed!' =>
            '',
        'This priority is used in the following config settings:' => '',

        # Template: AdminProcessManagement
        'Process Management' => 'Zarządzanie procesami',
        'Filter for Processes' => 'Filtr procesów',
        'Filter for processes' => '',
        'Create New Process' => 'Utwórz nowy proces',
        'Deploy All Processes' => 'Wdróż wszystkie procesy',
        'Here you can upload a configuration file to import a process to your system. The file needs to be in .yml format as exported by process management module.' =>
            'Tutaj możesz załadować plik konfiguracji aby zaimportować proces do twojego systemu. Plik musi być w formacie .yml wyeksportowanym z modułu zarządzania procesami.',
        'Upload process configuration' => 'Załaduj konfigurację procesu',
        'Import process configuration' => 'Importuj konfigurację procesu',
        'Ready2Adopt Processes' => '',
        'Here you can activate Ready2Adopt processes showcasing our best practices. Please note that some additional configuration may be required.' =>
            '',
        'Would you like to benefit from processes created by experts? Upgrade to %s to import some sophisticated Ready2Adopt processes.' =>
            '',
        'Import Ready2Adopt process' => '',
        'To create a new Process you can either import a Process that was exported from another system or create a complete new one.' =>
            'Aby utworzyć nowy proces, możesz albo zaimportować proces, który został wyeksportowany z innego systemu lub utworzyć całkowicie nowy proces.',
        'Changes to the Processes here only affect the behavior of the system, if you synchronize the Process data. By synchronizing the Processes, the newly made changes will be written to the Configuration.' =>
            'Zmiany wprowadzone tutaj do procesów zostaną uwzględnione w systemie jeśli zsynchronizujesz dane procesów. Wskutek synchronizacji procesów, nowe zmiany będą zapisane do konfiguracji.',
        'Processes' => 'Procesy',
        'Process name' => 'Nazwa procesu',
        'Print' => 'Drukuj',
        'Export Process Configuration' => 'Eksportuj konfigurację procesu',
        'Copy Process' => 'Kopiuj proces',

        # Template: AdminProcessManagementActivity
        'Cancel & close' => 'Zrezygnuj i zamknij',
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
        'Name: %s, EntityID: %s' => 'Nazwa: %s, EtnityID: %s',
        'Create New Activity Dialog' => 'Utwórz nowe okno działania',
        'Assigned Activity Dialogs' => 'Przypisane okna działań',

        # Template: AdminProcessManagementActivityDialog
        'Please note that changing this activity dialog will affect the following activities' =>
            'Zwróć uwagę, że zmiany tego okna wpłyną na następnujące działania',
        'Please note that customer users will not be able to see or use the following fields: Owner, Responsible, Lock, PendingTime and CustomerID.' =>
            'Miej na uwadze, że użytkownicy klientów nie będą widzieć pól: Właściciel, Odpowiedzialny, Blokada, CzasOczekiwania i IDużytkownika.',
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
        'You can assign Fields to this Activity Dialog by dragging the elements with the mouse from the left list to the right list.' =>
            'Możesz przypisac pola do tego okna działania za pomocą przeciągania elementów myszką z listy po lewej stronie do listy po prawej stronie.',
        'Filter available fields' => 'Filtruj dostępne pola',
        'Available Fields' => 'Dostępne pola',
        'Assigned Fields' => 'Przypisane pola',
        'Communication Channel' => 'Kanał Komunikacji',
        'Is visible for customer' => 'Jest widoczna dla klienta',
        'Display' => 'Wyświetl',

        # Template: AdminProcessManagementPath
        'Path' => 'Ścieżka',
        'Edit this transition' => 'Edytuj to przejście',
        'Transition Actions' => 'Akcje przejścia',
        'You can assign Transition Actions to this Transition by dragging the elements with the mouse from the left list to the right list.' =>
            'Możesz przypisać akcje przejścia do tego przejścia za pomocą przeciągania elementów myszką z listy po lewej stronie do listy po prawej stronie.',
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
        'Print process information' => 'Drukuj informację o procesie',
        'Delete Process' => 'Usuń proces',
        'Delete Inactive Process' => 'Usuń nieaktywny proces',
        'Available Process Elements' => 'Dostępne elementy procesów',
        'The Elements listed above in this sidebar can be moved to the canvas area on the right by using drag\'n\'drop.' =>
            'Elementy z listy ponad tym paskiem bocznym mogą być przenoszone do obszaru projektu po prawej stronie za pomocą chwytania i upuszczania.',
        'You can place Activities on the canvas area to assign this Activity to the Process.' =>
            'Możes umieszczać działania na obszarze projektu aby przypisywać te działania do procesu.',
        'To assign an Activity Dialog to an Activity drop the Activity Dialog element from this sidebar over the Activity placed in the canvas area.' =>
            'Aby przypisać okno działania do działania, upuść element okna działania z paska bocznego na działanie znajdujące się w obszarze projektu.',
        'You can start a connection between two Activities by dropping the Transition element over the Start Activity of the connection. After that you can move the loose end of the arrow to the End Activity.' =>
            '',
        'Actions can be assigned to a Transition by dropping the Action Element onto the label of a Transition.' =>
            'Akcje mogą być przypisywane do przejść poprzez upuszczanie elementu akcji na etykietę przejścia.',
        'Edit Process Information' => 'Edytuj informacje o procesie',
        'Process Name' => 'Nazwa procesu',
        'The selected state does not exist.' => 'Wybrany stan nie istnieje.',
        'Add and Edit Activities, Activity Dialogs and Transitions' => 'Dodaj i edytuj działania, okna działań i przejścia',
        'Show EntityIDs' => 'Pokaż EntityID',
        'Extend the width of the Canvas' => 'Zwiększ szerokość obszaru projektu',
        'Extend the height of the Canvas' => 'Zwiększ wysokość obszaru projektu',
        'Remove the Activity from this Process' => 'Usuń działanie z tego procesu',
        'Edit this Activity' => 'Edytuj to działanie',
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

        # Template: AdminProcessManagementProcessNew
        'In this screen, you can create a new process. In order to make the new process available to users, please make sure to set its state to \'Active\' and synchronize after completing your work.' =>
            'Na tym ekranie możesz utworzyć nowy proces. Aby udostępnić proces użytkownikom, ustaw stan na "Aktywne" i zsynchronizuj po zakończeniu.',

        # Template: AdminProcessManagementProcessPrint
        'cancel & close' => 'zrezygnuj i zamknij',
        'Start Activity' => 'Działanie początkowe',
        'Contains %s dialog(s)' => 'Zawiera %s okien',
        'Assigned dialogs' => 'Przypisane okna',
        'Activities are not being used in this process.' => 'Działania nie są używane w tym procesie.',
        'Assigned fields' => 'Przypisane pola',
        'Activity dialogs are not being used in this process.' => 'Okna działań nie są używane w tym procesie.',
        'Condition linking' => 'Łączenie warunkowe',
        'Transitions are not being used in this process.' => 'Przejścia nie są używane w tym procesie.',
        'Module name' => 'Nazwa modułu',
        'Transition actions are not being used in this process.' => 'Akcje przejść nie są używane w tym procesie.',

        # Template: AdminProcessManagementTransition
        'Please note that changing this transition will affect the following processes' =>
            'Zwróć uwagę, że zmiana tego przejścia wpłynie na następujące procesy',
        'Transition' => 'Przejście',
        'Transition Name' => 'Nazwa przejścia',

        # Template: AdminProcessManagementTransitionAction
        'Please note that changing this transition action will affect the following processes' =>
            'Zwróć uwagę, że zmiana tej akcji przejścia wpłynie na następujące procesy',
        'Transition Action' => 'Akcja przejścia',
        'Transition Action Name' => 'Nazwa akcji przejścia',
        'Transition Action Module' => 'Moduł akcji przejścia',
        'Config Parameters' => 'Parametry konfiguracyjne',
        'Add a new Parameter' => 'Dodaj nowy parametr',
        'Remove this Parameter' => 'Usuń ten parametr',

        # Template: AdminQueue
        'Queue Management' => '',
        'Add Queue' => 'Dodaj kolejkę',
        'Edit Queue' => 'Edytuj kolejkę',
        'Filter for Queues' => 'Filtrowanie kolejek',
        'Filter for queues' => 'Filtr dla kolejek',
        'A queue with this name already exists!' => 'Kolejka o tej nazwie już istnieje!',
        'This queue is present in a SysConfig setting, confirmation for updating settings to point to the new queue is needed!' =>
            '',
        'Sub-queue of' => 'Podkolejka kolejki',
        'Unlock timeout' => 'Limit czasowy odblokowania',
        '0 = no unlock' => '0 = bez odblokowania',
        'hours' => 'godz.',
        'Only business hours are counted.' => 'Tylko godziny pracy są liczone.',
        'If an agent locks a ticket and does not close it before the unlock timeout has passed, the ticket will unlock and will become available for other agents.' =>
            'Jeśli agent zablokuje zgłoszenie i nie zamknie go w czasie określonym przez limit odblokowania, zgłoszenie zostanie odblokowane i będzie dostępne dla innych agentów.',
        'Notify by' => 'Powiadom wcześniej',
        '0 = no escalation' => '0 = brak eskalacji',
        'If there is not added a customer contact, either email-external or phone, to a new ticket before the time defined here expires, the ticket is escalated.' =>
            'Jeśli nie będzie kontaktu z klientem, ani wiadomości e-mail, ani telefonu dodanego do zgłoszenia przed upływem określonego tutaj czasu, zgłoszenie to będzie eskalowane.',
        'If there is an article added, such as a follow-up via email or the customer portal, the escalation update time is reset. If there is no customer contact, either email-external or phone, added to a ticket before the time defined here expires, the ticket is escalated.' =>
            'Jeśli dodana zostanie wiadomość, przez e-mail lub przez panel klienta, czas aktualizacji eskalacji będzie zresetowany. Jeśli nie będzie kontaktu z klientem, ani wiadomości e-mail, ani telefonu dodanego do zgłoszenia przed upływem określonego tutaj czasu, zgłoszenie to będzie eskalowane.',
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
        'To use a sign key, PGP keys or S/MIME certificates need to be added with identifiers for selected queue system address.' =>
            '',
        'Salutation' => 'Powitanie',
        'The salutation for email answers.' => 'Powitanie dla odpowiedzi e-mailowych.',
        'Signature' => 'Podpis',
        'The signature for email answers.' => 'Podpis dla odpowiedzi e-mailowych.',
        'This queue is used in the following config settings:' => '',

        # Template: AdminQueueAutoResponse
        'Manage Queue-Auto Response Relations' => 'Zarządzaj relacjami kolejka-autoodpowiedź',
        'Change Auto Response Relations for Queue' => 'Zmień relacje autoodpowiedzi dla kolejki',
        'This filter allow you to show queues without auto responses' => 'Ten filtr pozwala pokazać zapytania bez automatycznych odpowiedzi',
        'Queues without Auto Responses' => 'Kolejki bez Auto Odpowiedzi',
        'This filter allow you to show all queues' => 'Ten filtr pozwala na wyświetlenie wszystkich kolejek',
        'Show All Queues' => 'Pokaż Wszystkie Kolejki',
        'Auto Responses' => 'Automatyczne odpowiedzi',

        # Template: AdminQueueTemplates
        'Manage Template-Queue Relations' => 'Zarządzaj relacjami Szablonowo-Kolejkowymi',
        'Filter for Templates' => 'Filtr szalbonów',
        'Filter for templates' => '',
        'Templates' => 'Szablony',

        # Template: AdminRegistration
        'System Registration Management' => 'Zarządzanie rejestracją systemu',
        'Edit System Registration' => 'Zmień Rejestracje Systemu',
        'System Registration Overview' => '',
        'Register System' => 'Zarejestruj System',
        'Validate OTRS-ID' => '',
        'Deregister System' => 'Wyrejestruj system',
        'Edit details' => 'Edytuj detale',
        'Show transmitted data' => 'Pokaż wysłane dane',
        'Deregister system' => 'Wyrejestruj system',
        'Overview of registered systems' => 'Przegląd zarejestrowanych systemów',
        'This system is registered with OTRS Group.' => 'Ten system jest zarejestrowany w grupie OTRS.',
        'System type' => 'Typ systemu',
        'Unique ID' => 'Unikalne ID',
        'Last communication with registration server' => 'Ostatnia komunikacja z serwerem rejestrującym',
        'System Registration not Possible' => '',
        'Please note that you can\'t register your system if OTRS Daemon is not running correctly!' =>
            'Zauważ, że nie możesz zarejestrować swojego systemu jeśli Demon OTRS nie jest poprawnie uruchomiony!',
        'Instructions' => 'Instrukcje',
        'System Deregistration not Possible' => '',
        'Please note that you can\'t deregister your system if you\'re using the %s or having a valid service contract.' =>
            '',
        'OTRS-ID Login' => 'Login OTRS-ID',
        'Read more' => 'Przeczytaj więcej',
        'You need to log in with your OTRS-ID to register your system.' =>
            'Musisz zalogować się przy użyciu swojego loginu OTRS-ID by móc zarejestrować system.',
        'Your OTRS-ID is the email address you used to sign up on the OTRS.com webpage.' =>
            'Twoje OTRS-ID to adres e-mail który użyłeś podczas rejestracji na stonie OTRS.com.',
        'Data Protection' => 'Ochrona danych',
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
        'If you deregister your system, you will lose these benefits:' =>
            '',
        'You need to log in with your OTRS-ID to deregister your system.' =>
            'Musisz zalogować się przy użyciu swojego OTRS-ID b ymóc dokonać derejestracji.',
        'OTRS-ID' => 'OTRS-ID',
        'You don\'t have an OTRS-ID yet?' => 'Nie posiadasz jeszcze OTRS-ID?',
        'Sign up now' => 'Zarejestruj się',
        'Forgot your password?' => 'Zapomniałeś swojego hasła?',
        'Retrieve a new one' => 'Otrzymaj nowe',
        'Next' => 'Dalej',
        'This data will be frequently transferred to OTRS Group when you register this system.' =>
            'następujące dane będą przesyłane do Grupy OTRS gdy zarejestrujesz system.',
        'Attribute' => 'Atrybut',
        'FQDN' => 'FQDN',
        'OTRS Version' => 'Wersja OTRS',
        'Operating System' => 'System operacyjny',
        'Perl Version' => 'Wersja Perl',
        'Optional description of this system.' => 'Opcjonalny opis systemu',
        'Register' => 'Zarejestruj',
        'Continuing with this step will deregister the system from OTRS Group.' =>
            'Kontynuacja tego kroku spowoduje wyrejestrowanie systemu z Grupy OTRS',
        'Deregister' => 'Wyrejestrowanie',
        'You can modify registration settings here.' => 'Tutaj możesz zmienić ustawienia rejestracji.',
        'Overview of Transmitted Data' => '',
        'There is no data regularly sent from your system to %s.' => '',
        'The following data is sent at minimum every 3 days from your system to %s.' =>
            '',
        'The data will be transferred in JSON format via a secure https connection.' =>
            '',
        'System Registration Data' => '',
        'Support Data' => 'Dane wsparcia',

        # Template: AdminRole
        'Role Management' => 'Zarządzanie rolami',
        'Add Role' => 'Dodaj rolę',
        'Edit Role' => 'Edytuj rolę',
        'Filter for Roles' => 'Filtr ról',
        'Filter for roles' => 'Filtr dla ról',
        'Create a role and put groups in it. Then add the role to the users.' =>
            'Utwórz rolę i dodaj grupę do niej. Potem dodaj rolę do użytkownika.',
        'There are no roles defined. Please use the \'Add\' button to create a new role.' =>
            'Nie ma zdefiniowanych ról. Użyj przycisku \'Dodaj rolę\' aby utworzyć nową rolę.',

        # Template: AdminRoleGroup
        'Manage Role-Group Relations' => 'Zarządzaj relacjami rola-grupa',
        'Roles' => 'Role',
        'Select the role:group permissions.' => 'Zaznacz uprawnienia rola:grupa',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the role).' =>
            'Jeśli nic nie będzie zaznaczone, wtedy nie będzie uprawnień w tej grupie (zgłoszenia nie będą dostępne dla roli).',
        'Toggle %s permission for all' => 'Przełącz uprawnienie %s dla wszystkich',
        'move_into' => 'przenieś do',
        'Permissions to move tickets into this group/queue.' => 'Uprawnienia do przesuwania zgłoszeń do tej grupy/kolejki',
        'create' => 'utwórz',
        'Permissions to create tickets in this group/queue.' => 'Uprawnienia do tworzenia zgłoszeń w tej grupie/kolejce',
        'note' => 'uwaga',
        'Permissions to add notes to tickets in this group/queue.' => 'Uprawnienia do dodawania uwag do zgłoszeń w tej grupie/kolejce.',
        'owner' => 'właściciel',
        'Permissions to change the owner of tickets in this group/queue.' =>
            'Uprawnienia do zmiany właściciela zgłoszeńw tej grupie/kolejce.',
        'priority' => 'priorytet',
        'Permissions to change the ticket priority in this group/queue.' =>
            'Uprawnienia do zmiany priorytetu zgłoszenia w tej grupie/kolejce',

        # Template: AdminRoleUser
        'Manage Agent-Role Relations' => 'Zarządzaj relacjami agent-rola',
        'Add Agent' => 'Dodaj agenta',
        'Filter for Agents' => 'Filtrowanie agentów',
        'Filter for agents' => '',
        'Agents' => 'Agenci',
        'Manage Role-Agent Relations' => 'Zarządzaj relacjami rola-agent',

        # Template: AdminSLA
        'SLA Management' => 'Konfiguracja SLA',
        'Edit SLA' => 'Edytuj SLA',
        'Add SLA' => 'Dodaj SLA',
        'Filter for SLAs' => 'Filtr dla SLA',
        'Please write only numbers!' => 'Podaj wyłączenie numery!',

        # Template: AdminSMIME
        'S/MIME Management' => 'Konfiguracja S/MIME',
        'Add Certificate' => 'Dodaj certyfikat',
        'Add Private Key' => 'Dodaj klucz prywatny',
        'SMIME support is disabled' => 'Wsparcie dla SMIME jest wyłączone',
        'To be able to use SMIME in OTRS, you have to enable it first.' =>
            'Aby móc używać SMIME w OTRS musisz najpierw włączyć dla niego wsparcie.',
        'Enable SMIME support' => 'Aktywuj wsparcie dla SMIME',
        'Faulty SMIME configuration' => 'Błędna konfiguracja SMIME',
        'SMIME support is enabled, but the relevant configuration contains errors. Please check the configuration using the button below.' =>
            '',
        'Check SMIME configuration' => 'Sprawdź konfigurację SMIME',
        'Filter for Certificates' => 'Filtr dla Certyfikatów',
        'Filter for certificates' => 'Filtruj certyfikaty',
        'To show certificate details click on a certificate icon.' => 'Kliknij w ikonę certyfikatu by zobaczyć jego detale.',
        'To manage private certificate relations click on a private key icon.' =>
            'Kliknij w ikonę prywatne by zarządzać relacjami certyfikatu prywatnego.',
        'Here you can add relations to your private certificate, these will be embedded to the S/MIME signature every time you use this certificate to sign an email.' =>
            '',
        'See also' => 'Zobacz także',
        'In this way you can directly edit the certification and private keys in file system.' =>
            'W taki sposób możesz bezpośrednio edytować certyfikaty i klucze prywarne w systemie plików.',
        'Hash' => 'Skrót (hash)',
        'Create' => 'Utwórz',
        'Handle related certificates' => 'Obsługuj powiązane certyfikaty',
        'Read certificate' => 'Czytaj certyfikat',
        'Delete this certificate' => 'Usuń ten certyfikat',
        'File' => 'Plik',
        'Secret' => 'Hasło',
        'Related Certificates for' => 'Certyfikaty powiązane dla',
        'Delete this relation' => 'Usuń to powiązanie',
        'Available Certificates' => 'Dostępne certyfikaty',
        'Filter for S/MIME certs' => 'Filtruj certyfikaty S/MIME',
        'Relate this certificate' => 'Powiąż ten certyfikat',

        # Template: AdminSMIMECertRead
        'S/MIME Certificate' => 'Certyfikat S/MIME',
        'Close this dialog' => 'Zamknij to okno dialogowe',
        'Certificate Details' => 'Szczegóły Certyfikatu',

        # Template: AdminSalutation
        'Salutation Management' => 'Zarządzanie powitaniami',
        'Add Salutation' => 'Dodaj powitanie',
        'Edit Salutation' => 'Edytuj powitanie',
        'Filter for Salutations' => '',
        'Filter for salutations' => '',
        'e. g.' => 'np.',
        'Example salutation' => 'Przykładowe powitanie',

        # Template: AdminSecureMode
        'Secure Mode Needs to be Enabled!' => '',
        'Secure mode will (normally) be set after the initial installation is completed.' =>
            'Tryb bezpieczny będzie (standardowo) włączony po inicjalnej instalacji.',
        'If secure mode is not activated, activate it via SysConfig because your application is already running.' =>
            'Jeśli tryb bezpieczny nie jest aktywny, uaktywnij go w SysConfig gdyż twoja aplikacja jest już uruchomiona.',

        # Template: AdminSelectBox
        'SQL Box' => 'Konsola SQL',
        'Filter for Results' => 'Filtr dla Wyników',
        'Filter for results' => 'Filtr dla wyników',
        'Here you can enter SQL to send it directly to the application database. It is not possible to change the content of the tables, only select queries are allowed.' =>
            '',
        'Here you can enter SQL to send it directly to the application database.' =>
            'Wpisz zapytanie SQL, które zostanie wysłane bezpośrednio do bazy danych.',
        'Options' => 'Opcje',
        'Only select queries are allowed.' => 'Tylko wybrane zapytania są dozwolone.',
        'The syntax of your SQL query has a mistake. Please check it.' =>
            'Składnia twojego zapytania SQL jest niepoprawna. Sprawdź ją.',
        'There is at least one parameter missing for the binding. Please check it.' =>
            'Brakuje przynajmniej jednego parametru połączenia. Sprawdź je.',
        'Result format' => 'Format wyników',
        'Run Query' => 'Uruchom polecenie',
        '%s Results' => '1%s Wyniki',
        'Query is executed.' => 'Zapytanie jest wykonywane.',

        # Template: AdminService
        'Service Management' => 'Konfiguracja usług',
        'Add Service' => 'Dodaj usługę',
        'Edit Service' => 'Edytuj usługę',
        'Service name maximum length is 200 characters (with Sub-service).' =>
            'Długość nazwy usługi to maksymalnie 200 znaków (razem z podusługą)',
        'Sub-service of' => 'Usługa podrzędna dla',

        # Template: AdminSession
        'Session Management' => 'Zarządzanie sesjami',
        'Detail Session View for %s (%s)' => '',
        'All sessions' => 'Wszystkie sesje',
        'Agent sessions' => 'Sesje agentów',
        'Customer sessions' => 'Sesje klientów',
        'Unique agents' => 'Unikalni agenci',
        'Unique customers' => 'Unikalni klienci',
        'Kill all sessions' => 'Zakończ wszystkie sesje',
        'Kill this session' => 'Zabij tą sesję',
        'Filter for Sessions' => 'Filtr dla Sesji',
        'Filter for sessions' => 'Filtr dla sesji',
        'Session' => 'Sesja',
        'User' => 'Użytkownik',
        'Kill' => 'Zabij',
        'Detail View for SessionID: %s - %s' => '',

        # Template: AdminSignature
        'Signature Management' => 'Konfiguracja podpisów',
        'Add Signature' => 'Dodaj podpis',
        'Edit Signature' => 'Edytuj podpis',
        'Filter for Signatures' => 'Filtr dla Podpisów',
        'Filter for signatures' => 'Filtr dla podpisów',
        'Example signature' => 'Przykładowy podpis',

        # Template: AdminState
        'State Management' => 'Zarządzanie stanami',
        'Add State' => 'Dodaj stan',
        'Edit State' => 'Edytuj stan',
        'Filter for States' => 'Filtr dla Stanów',
        'Filter for states' => 'Filtr dla stanów',
        'Attention' => 'Uwaga',
        'Please also update the states in SysConfig where needed.' => 'Zaktualizuj również stan w konfiguracji systemu tam gdzie to konieczne.',
        'This state is present in a SysConfig setting, confirmation for updating settings to point to the new type is needed!' =>
            '',
        'State type' => 'Rodzaj stanu',
        'It\'s not possible to invalidate this entry because there is no other merge states in system!' =>
            '',
        'This state is used in the following config settings:' => '',

        # Template: AdminSupportDataCollector
        'Sending support data to OTRS Group is not possible!' => '',
        'Enable Cloud Services' => 'Uruchom usługi w churze',
        'This data is sent to OTRS Group on a regular basis. To stop sending this data please update your system registration.' =>
            '',
        'You can manually trigger the Support Data sending by pressing this button:' =>
            '',
        'Send Update' => 'Wyślij aktualizację',
        'Currently this data is only shown in this system.' => '',
        'A support bundle (including: system registration information, support data, a list of installed packages and all locally modified source code files) can be generated by pressing this button:' =>
            '',
        'Generate Support Bundle' => '',
        'The Support Bundle has been Generated' => '',
        'Please choose one of the following options.' => 'Proszę wybrać jedną z poniższych opcji.',
        'Send by Email' => 'Wyślij za pomocą wiadomości e-mail',
        'The support bundle is too large to send it by email, this option has been disabled.' =>
            'Pakiet serwisowy jest zbyt duży, by wysłać go e-mailem. Ta opcja została wyłączona.',
        'The email address for this user is invalid, this option has been disabled.' =>
            'Adres e-mail użytkownika jest nieprawidłowy. Ta opcja została wyłączona.',
        'Sending' => 'Nadawca',
        'The support bundle will be sent to OTRS Group via email automatically.' =>
            'Pakiet serwisowy zostanie automatycznie wysłany e-mailem do Grupy OTRS',
        'Download File' => 'Pobierz plik',
        'A file containing the support bundle will be downloaded to the local system. Please save the file and send it to the OTRS Group, using an alternate method.' =>
            '',
        'Error: Support data could not be collected (%s).' => '',
        'Details' => 'Szczegóły',

        # Template: AdminSystemAddress
        'System Email Addresses Management' => 'Konfiguracja adresów e-mail Systemu',
        'Add System Email Address' => 'Dodaj systemowy adres e-mail',
        'Edit System Email Address' => 'Edytuj systemowy adres e-mail',
        'Add System Address' => '',
        'Filter for System Addresses' => '',
        'Filter for system addresses' => '',
        'All incoming email with this address in To or Cc will be dispatched to the selected queue.' =>
            'Wszystkie przychodzące wiadomości e-mail z tym adresem w Do lub DW będą skierowane do wskazanej kolejki.',
        'Email address' => 'Adres e-mail',
        'Display name' => 'Wyświetlana nazwa',
        'This email address is already used as system email address.' => '',
        'The display name and email address will be shown on mail you send.' =>
            'Wyświetlana nazwa oraz adres e-mail będą umieszczane w wysyłanej poczcie.',
        'This system address cannot be set to invalid.' => '',
        'This system address cannot be set to invalid, because it is used in one or more queue(s) or auto response(s).' =>
            '',

        # Template: AdminSystemConfiguration
        'online administrator documentation' => 'dokumentację administratora online',
        'System configuration' => 'Konfiguracja systemu',
        'Navigate through the available settings by using the tree in the navigation box on the left side.' =>
            'Poruszaj się wśród dostępnych ustawień, używając drzewa w obszarze nawigacyjnym po lewej stronie.',
        'Find certain settings by using the search field below or from search icon from the top navigation.' =>
            'Znajdź określone ustawienia używając poniższego pola wyszukiwania, lub przy pomocy ikony wyszukiwania w menu nawigacyjnym.',
        'Find out how to use the system configuration by reading the %s.' =>
            'Przeczytaj "%s" i dowiedz się jak używać konfiguracji systemu.',
        'Search in all settings...' => '',
        'There are currently no settings available. Please make sure to run \'otrs.Console.pl Maint::Config::Rebuild\' before using the software.' =>
            '',

        # Template: AdminSystemConfigurationDeployment
        'Changes Deployment' => 'Wdrażanie zmian',
        'Help' => 'Pomoc',
        'This is an overview of all settings which will be part of the deployment if you start it now. You can compare each setting to its former state by clicking the icon on the top right.' =>
            '',
        'To exclude certain settings from a deployment, click the checkbox on the header bar of a setting.' =>
            '',
        'By default, you will only deploy settings which you changed on your own. If you\'d like to deploy settings changed by other users, too, please click the link on top of the screen to enter the advanced deployment mode.' =>
            '',
        'A deployment has just been restored, which means that all affected setting have been reverted to the state from the selected deployment.' =>
            '',
        'Please review the changed settings and deploy afterwards.' => '',
        'An empty list of changes means that there are no differences between the restored and the current state of the affected settings.' =>
            '',
        'Changes Overview' => 'Przegląd Zmian',
        'There are %s changed settings which will be deployed in this run.' =>
            '',
        'Switch to basic mode to deploy settings only changed by you.' =>
            '',
        'You have %s changed settings which will be deployed in this run.' =>
            '',
        'Switch to advanced mode to deploy settings changed by other users, too.' =>
            'Przełącz się do trybu zaawansowanego by wdrożyć parametry konfiguracji zmienione również przez innych użytkowników.',
        'There are no settings to be deployed.' => 'Nie ma zmian parametrów do wdrożenia.',
        'Switch to advanced mode to see deployable settings changed by other users.' =>
            'Przełącz się do trybu zaawansowanego by zobaczyć gotowe do wdrożenia parametry konfiguracji zmienione przez innych użytkowników.',
        'Deploy selected changes' => 'Opublikuj wybrane zmiany',

        # Template: AdminSystemConfigurationGroup
        'This group doesn\'t contain any settings. Please try navigating to one of its sub groups.' =>
            '',

        # Template: AdminSystemConfigurationImportExport
        'Import & Export' => 'Import i Eksport',
        'Upload a file to be imported to your system (.yml format as exported from the System Configuration module).' =>
            '',
        'Upload system configuration' => '',
        'Import system configuration' => '',
        'Download current configuration settings of your system in a .yml file.' =>
            '',
        'Include user settings' => '',
        'Export current configuration' => '',

        # Template: AdminSystemConfigurationSearch
        'Search for' => '',
        'Search for category' => '',
        'Settings I\'m currently editing' => 'Ustawienia, które aktualnie edytuję',
        'Your search for "%s" in category "%s" did not return any results.' =>
            'Twoje wyszukiwanie "%s" w categorii "%s" nie zwróciło żadnego wyniku.',
        'Your search for "%s" in category "%s" returned one result.' => 'Twoje wyszukiwanie "%s" w categorii "%s" zwróciło jeden wynik.',
        'Your search for "%s" in category "%s" returned %s results.' => 'Twoje wyszukiwanie "%s" w categorii "%s" zwróciło "%s" wyników.',
        'You\'re currently not editing any settings.' => '',
        'You\'re currently editing %s setting(s).' => '',

        # Template: AdminSystemConfigurationSearchDialog
        'Category' => 'Kategoria',
        'Run search' => 'Szukaj',

        # Template: AdminSystemConfigurationView
        'View a custom List of Settings' => '',
        'View single Setting: %s' => '',
        'Go back to Deployment Details' => 'Wróć do szczegółów wdrożenia',

        # Template: AdminSystemMaintenance
        'System Maintenance Management' => 'Zarządzanie konserwacją systemu',
        'Schedule New System Maintenance' => 'Zaplanuj nową konserwację systemu',
        'Filter for System Maintenances' => '',
        'Filter for system maintenances' => '',
        'Schedule a system maintenance period for announcing the Agents and Customers the system is down for a time period.' =>
            '',
        'Some time before this system maintenance starts the users will receive a notification on each screen announcing about this fact.' =>
            '',
        'Stop date' => 'Data końca',
        'Delete System Maintenance' => 'Usuń konserwację systemu',

        # Template: AdminSystemMaintenanceEdit
        'Edit System Maintenance' => '',
        'Edit System Maintenance Information' => '',
        'Date invalid!' => 'Niepoprawna data',
        'Login message' => 'Wiadomość przy logowaniu',
        'This field must have less then 250 characters.' => '',
        'Show login message' => 'Pokaż wiadomość przy logowaniu',
        'Notify message' => 'Komunikat',
        'Manage Sessions' => 'Zarządzanie sesjami',
        'All Sessions' => 'Wszystkie sesje',
        'Agent Sessions' => 'Sesje Agentów',
        'Customer Sessions' => 'Sesje Klientów',
        'Kill all Sessions, except for your own' => 'Zakończ wszystkie sesje z wyjątkiem własnej',

        # Template: AdminTemplate
        'Template Management' => '',
        'Add Template' => 'Dodaj szablon',
        'Edit Template' => 'Edytuj szablon',
        'A template is a default text which helps your agents to write faster tickets, answers or forwards.' =>
            'Szablon jest domyślnym tekstem który pozwala agentom na szybsze wypisywanie zgłoszeń, odpowiedzi i przekazań.',
        'Don\'t forget to add new templates to queues.' => 'Nie zapomnij dodać nowych szablonów do kolejki.',
        'Attachments' => 'Załączniki',
        'Delete this entry' => 'Usuń tę pozycję',
        'Do you really want to delete this template?' => 'Czy na pewno chcesz usunąć ten szablon?',
        'A standard template with this name already exists!' => 'Szablon o takiej nazwie już istnieje!',
        'Template' => 'Szablon',
        'To get the first 20 characters of the subject of the current/latest agent article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            '',
        'To get the first 5 lines of the body of the current/latest agent article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            '',
        'To get the first 20 characters of the subject of the current/latest article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            '',
        'To get the first 5 lines of the body of the current/latest article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            '',
        'Create type templates only supports this smart tags' => 'Tworzenie typowych szablonów wspiera jedynie takie tagi',
        'Example template' => 'Przykładowy szablon',
        'The current ticket state is' => 'Aktualny stan zgłoszenia to',
        'Your email address is' => 'Twój adres e-mail to',

        # Template: AdminTemplateAttachment
        'Manage Template-Attachment Relations' => '',
        'Toggle active for all' => 'Przełącz aktywność dla wszystkich',
        'Link %s to selected %s' => 'Łącz %s do zaznaczenia %s',

        # Template: AdminType
        'Type Management' => 'Zarządzanie typami',
        'Add Type' => 'Dodaj typ',
        'Edit Type' => 'Edytuj typ zgłoszenia',
        'Filter for Types' => '',
        'Filter for types' => '',
        'A type with this name already exists!' => 'Typ o takiej nazwie już istnieje!',
        'This type is present in a SysConfig setting, confirmation for updating settings to point to the new type is needed!' =>
            '',
        'This type is used in the following config settings:' => '',

        # Template: AdminUser
        'Agent Management' => 'Zarządzanie agentami',
        'Edit Agent' => 'Edytuj agenta',
        'Edit personal preferences for this agent' => 'Edytuj ustawienia osobiste tego agenta',
        'Agents will be needed to handle tickets.' => 'Agenci są potrzebni do obsługi zgłoszeń.',
        'Don\'t forget to add a new agent to groups and/or roles!' => 'Nie zapomnij dodać nowego agenta do grup lub/i ról!',
        'Please enter a search term to look for agents.' => 'Podaj frazy wyszukiwania agentów.',
        'Last login' => 'Ostatnie logowanie',
        'Switch to agent' => 'Przełącz na agenta',
        'Title or salutation' => 'Tytuł albo zwrot grzecznościowy',
        'Firstname' => 'Imię',
        'Lastname' => 'Nazwisko',
        'A user with this username already exists!' => 'Użytkownik o takiej nazwie już istnieje!',
        'Will be auto-generated if left empty.' => 'Zostanie wygenerowane automatycznie jeśli pozostawione puste.',
        'Mobile' => 'Tel. kom.',
        'Effective Permissions for Agent' => 'Wypadkowe uprawnienia agenta',
        'This agent has no group permissions.' => 'Ten Agent nie ma uprawnień do grup.',
        'Table above shows effective group permissions for the agent. The matrix takes into account all inherited permissions (e.g. via roles).' =>
            '',

        # Template: AdminUserGroup
        'Manage Agent-Group Relations' => 'Zarządzaj relacjami agent-grupa',

        # Template: AgentAppointmentAgendaOverview
        'Agenda Overview' => 'Przegląd terminarza',
        'Manage Calendars' => 'Zarządzaj kalendarzami',
        'Add Appointment' => 'Dodaj wydarzenie',
        'Today' => 'Dzisiaj',
        'All-day' => 'całodobowo',
        'Repeat' => 'Powtarzaj',
        'Notification' => 'Powiadomienie',
        'Yes' => 'Tak',
        'No' => 'Nie',
        'No calendars found. Please add a calendar first by using Manage Calendars page.' =>
            'Nie znaleziono kalendarzy. Proszę dodać najpierw kalendarz używając strony Zarządzanie Kalendarzami.',

        # Template: AgentAppointmentCalendarOverview
        'Add new Appointment' => 'Dodaj nowe wydarzenie',
        'Calendars' => 'Kalendarze',

        # Template: AgentAppointmentEdit
        'Basic information' => 'Podstawowe informacje',
        'Date/Time' => 'Data/Czas',
        'Invalid date!' => 'Błędna data!',
        'Please set this to value before End date.' => 'Proszę ustawić tę wartość przed datą zakończenia.',
        'Please set this to value after Start date.' => 'Proszę ustawić tę wartość po dacie rozpoczęcia.',
        'This an occurrence of a repeating appointment.' => 'To jest wystąpienie powtarzalnego wydarzenia.',
        'Click here to see the parent appointment.' => 'Kliknij tutaj by sprawdzić wydarzenie główne.',
        'Click here to edit the parent appointment.' => 'Kliknij tutaj by edytować wydarzenie główne.',
        'Frequency' => 'Częstotliwość',
        'Every' => 'Każdy',
        'day(s)' => 'dzień(dni)',
        'week(s)' => 'tydzień(tygodnie)',
        'month(s)' => 'miesiąc(-cy)',
        'year(s)' => 'rok(lat)',
        'On' => 'Włączone',
        'Monday' => '1.Poniedziałek',
        'Mon' => 'Pn',
        'Tuesday' => '2.Wtorek',
        'Tue' => 'Wt',
        'Wednesday' => '3.Środa',
        'Wed' => 'Śr',
        'Thursday' => '4.Czwartek',
        'Thu' => 'Cz',
        'Friday' => '5.Piątek',
        'Fri' => 'Pt',
        'Saturday' => '6.Sobota',
        'Sat' => 'So',
        'Sunday' => '7.Niedziela',
        'Sun' => 'Nd',
        'January' => 'Styczeń',
        'Jan' => 'Sty',
        'February' => 'Luty',
        'Feb' => 'Lut',
        'March' => 'Marzec',
        'Mar' => 'Mar',
        'April' => 'Kwiecień',
        'Apr' => 'Kwi',
        'May_long' => 'Maj',
        'May' => 'Maj',
        'June' => 'Czerwiec',
        'Jun' => 'Cze',
        'July' => 'Lipiec',
        'Jul' => 'Lip',
        'August' => 'Sierpień',
        'Aug' => 'Sie',
        'September' => 'Wrzesień',
        'Sep' => 'Wrz',
        'October' => 'Październik',
        'Oct' => 'Paź',
        'November' => 'Listopad',
        'Nov' => 'Lis',
        'December' => 'Grudzień',
        'Dec' => 'Gru',
        'Relative point of time' => '',
        'Link' => 'Połącz',
        'Remove entry' => 'Usuń pozycję',

        # Template: AgentCustomerInformationCenter
        'Customer Information Center' => 'Centrum informacji o kliencie',

        # Template: AgentCustomerInformationCenterSearch
        'Customer User' => 'Użytkownik klienta',

        # Template: AgentCustomerTableView
        'Note: Customer is invalid!' => 'Uwaga: Nieprawidłowy klient!',
        'Start chat' => 'Rozpocznij czat',
        'Video call' => 'Wideo rozmowa',
        'Audio call' => '',

        # Template: AgentCustomerUserAddressBook
        'Customer User Address Book' => '',
        'Search for recipients and add the results as \'%s\'.' => '',
        'Search template' => 'Szablon wyszukiwania',
        'Create Template' => 'Utwórz szablon',
        'Create New' => 'Utwórz nowy',
        'Save changes in template' => 'Zapisz zmiany w szablonie',
        'Filters in use' => 'Filtry w użyciu',
        'Additional filters' => 'Dodatkowe filtry',
        'Add another attribute' => 'Dodaj inny parametr',
        'The attributes with the identifier \'(Customer)\' are from the customer company.' =>
            '',
        '(e. g. Term* or *Term*)' => '',

        # Template: AgentCustomerUserAddressBookOverview
        'Select all' => 'Zaznacz wszystkie',
        'The customer user is already selected in the ticket mask.' => '',
        'Select this customer user' => '',
        'Add selected customer user to' => '',

        # Template: AgentCustomerUserAddressBookOverviewNavBar
        'Change search options' => 'Zmień kryteria wyszukiwania',

        # Template: AgentCustomerUserInformationCenter
        'Customer User Information Center' => 'Centrum Informacji o użytkowniku klienta',

        # Template: AgentDaemonInfo
        'The OTRS Daemon is a daemon process that performs asynchronous tasks, e.g. ticket escalation triggering, email sending, etc.' =>
            '',
        'A running OTRS Daemon is mandatory for correct system operation.' =>
            'Uruchomiony Daemon OTRS jest niezbędny do prawidłowego działania systemu.',
        'Starting the OTRS Daemon' => 'Uruchom OTRS Daemon',
        'Make sure that the file \'%s\' exists (without .dist extension). This cron job will check every 5 minutes if the OTRS Daemon is running and start it if needed.' =>
            '',
        'Execute \'%s start\' to make sure the cron jobs of the \'otrs\' user are active.' =>
            '',
        'After 5 minutes, check that the OTRS Daemon is running in the system (\'bin/otrs.Daemon.pl status\').' =>
            '',

        # Template: AgentDashboard
        'Dashboard' => 'Pulpit',

        # Template: AgentDashboardAppointmentCalendar
        'New Appointment' => 'Nowe wydarzenie',
        'Tomorrow' => 'Jutro',
        'Soon' => 'Niebawem',
        '5 days' => '5 dni',
        'Start' => 'Start',
        'none' => 'brak',

        # Template: AgentDashboardCalendarOverview
        'in' => 'za',

        # Template: AgentDashboardCommon
        'Save settings' => 'Zapisz ustawienia',
        'Close this widget' => 'Zamknij ten widget',
        'more' => 'więcej',
        'Available Columns' => 'Dostępne kolumny',
        'Visible Columns (order by drag & drop)' => 'Widoczne kolumny (sortuj poprzez przeciągnij i upuść)',

        # Template: AgentDashboardCustomerIDList
        'Change Customer Relations' => '',
        'Open' => 'Otwarte',
        'Closed' => 'Zamknięte',
        '%s open ticket(s) of %s' => '% otwartych zgłoszeń z %s',
        '%s closed ticket(s) of %s' => '%s zamkniętych zgłoszeń z %s',
        'Edit customer ID' => 'Zmień ID klienta',

        # Template: AgentDashboardCustomerIDStatus
        'Escalated tickets' => 'Zgłoszenia eskalowane',
        'Open tickets' => 'Otwarte zgłoszenia',
        'Closed tickets' => 'Zamknięte zgłoszenia',
        'All tickets' => 'Wszystkie zgłoszenia',
        'Archived tickets' => 'Zarchiwizowane zgłoszenia',

        # Template: AgentDashboardCustomerUserInformation
        'Note: Customer User is invalid!' => 'Uwaga: Użytkownik klienta jest nieprawidłowy!',

        # Template: AgentDashboardCustomerUserList
        'Customer user information' => 'Informacje o Użytkowniku Klienta',
        'Phone ticket' => 'Zgłoszenia tel.',
        'Email ticket' => 'Zgłoszenia e-mail',
        'New phone ticket from %s' => 'Nowe zgłoszenie tel. od %s',
        'New email ticket to %s' => 'Nowe zgłoszenie e-mail od %s',

        # Template: AgentDashboardProductNotify
        '%s %s is available!' => '%s %s jest dostępna',
        'Please update now.' => 'Prosimy, zaktualizuj teraz.',
        'Release Note' => 'Uwagi do wydania',
        'Level' => 'Poziom',

        # Template: AgentDashboardRSSOverview
        'Posted %s ago.' => 'Opublikowane %s temu.',

        # Template: AgentDashboardStats
        'The configuration for this statistic widget contains errors, please review your settings.' =>
            'Konfiguracja tego wigdeta statystyk zawiera błędy, przejrzyj jego ustawienia.',
        'Download as SVG file' => 'Pobierz jako plik SVG',
        'Download as PNG file' => 'Pobierz jako plik PNG',
        'Download as CSV file' => 'Pobierz jako plik CSV',
        'Download as Excel file' => 'Pobierz jako plik Excel',
        'Download as PDF file' => 'Pobierz jako plik PDF',
        'Please select a valid graph output format in the configuration of this widget.' =>
            '',
        'The content of this statistic is being prepared for you, please be patient.' =>
            'Statystyki są dla ciebie przygotowywane. Proszę o cierpliwość.',
        'This statistic can currently not be used because its configuration needs to be corrected by the statistics administrator.' =>
            '',

        # Template: AgentDashboardTicketGeneric
        'Assigned to customer user' => 'Przypisane do użytkownika klienta',
        'Accessible for customer user' => 'Dostępne dla użytkownika klienta',
        'My locked tickets' => 'Zablokowane',
        'My watched tickets' => 'Obserwowane',
        'My responsibilities' => 'Odpowiedzialny',
        'Tickets in My Queues' => 'Zgłoszenia w Moich Kolejkach',
        'Tickets in My Services' => 'Zgłoszenia w Moje Usługi',
        'Service Time' => 'W godzinach roboczych',

        # Template: AgentDashboardTicketQueueOverview
        'Total' => 'Suma',

        # Template: AgentDashboardUserOnline
        'out of office' => 'poza biurem',

        # Template: AgentDashboardUserOutOfOffice
        'until' => 'do',

        # Template: AgentInfo
        'To accept some news, a license or some changes.' => 'Aby zaakceptować niektóre wiadomości, licencje lub niektóre zmiany.',
        'Yes, accepted.' => '',

        # Template: AgentLinkObject
        'Manage links for %s' => '',
        'Create new links' => '',
        'Manage existing links' => '',
        'Link with' => 'Połącz z',
        'Start search' => '',
        'There are currently no links. Please click \'Create new Links\' on the top to link this item to other objects.' =>
            '',

        # Template: AgentOTRSBusinessBlockScreen
        'Unauthorized usage of %s detected' => 'Wykryte nieautoryzowane użycie %s',
        'If you decide to downgrade to ((OTRS)) Community Edition, you will lose all database tables and data related to %s.' =>
            '',

        # Template: AgentPreferences
        'Edit your preferences' => 'Zmień swoje ustawienia',
        'Personal Preferences' => 'Ustawienia osobiste',
        'Preferences' => 'Ustawienia',
        'Please note: you\'re currently editing the preferences of %s.' =>
            '',
        'Go back to editing this agent' => '',
        'Set up your personal preferences. Save each setting by clicking the checkmark on the right.' =>
            'Dostosuj swoje ustawienia osobiste. Każdą z opcji można zapisać klikając ✓ po prawej stronie.',
        'You can use the navigation tree below to only show settings from certain groups.' =>
            '',
        'Dynamic Actions' => 'Akcje dynamiczne',
        'Filter settings...' => 'Ustawienia filtru...',
        'Filter for settings' => 'Filtr dla ustawień',
        'Save all settings' => 'Zapisz wszystkie ustawienia',
        'Avatars have been disabled by the system administrator. You\'ll see your initials instead.' =>
            '',
        'You can change your avatar image by registering with your email address %s at %s. Please note that it can take some time until your new avatar becomes available because of caching.' =>
            '',
        'Off' => 'Wyłączone',
        'End' => 'Koniec',
        'This setting can currently not be saved.' => 'To ustawienie nie może być teraz zapisane',
        'This setting can currently not be saved' => 'To ustawienie nie może być teraz zapisane',
        'Save this setting' => 'Zapisz ustawienie',
        'Did you know? You can help translating OTRS at %s.' => 'Czy wiesz, że możesz pomóc w tłumaczeniu OTRS na %s',

        # Template: SettingsList
        'Reset to default' => 'Przywróć do domyślnych',

        # Template: AgentPreferencesOverview
        'Choose from the groups on the right to find the settings you\'d wish to change.' =>
            '',
        'Did you know?' => '',
        'You can change your avatar by registering with your email address %s on %s' =>
            '',

        # Template: AgentSplitSelection
        'Target' => 'Cel',
        'Process' => 'Proces',
        'Split' => 'Podziel',

        # Template: AgentStatisticsAdd
        'Statistics Management' => '',
        'Add Statistics' => 'Dodaj Statystyki',
        'Read more about statistics in OTRS' => '',
        'Dynamic Matrix' => 'Macierz dynamiczna',
        'Each cell contains a singular data point.' => '',
        'Dynamic List' => 'Lista dynamiczna',
        'Each row contains data of one entity.' => '',
        'Static' => 'statyczny',
        'Non-configurable complex statistics.' => '',
        'General Specification' => '',
        'Create Statistic' => 'Utwórz statystykę',

        # Template: AgentStatisticsEdit
        'Edit Statistics' => '',
        'Run now' => 'Uruchom teraz',
        'Statistics Preview' => 'Podgląd statystyk',
        'Save Statistic' => 'Zapisz Statystyki',

        # Template: AgentStatisticsImport
        'Import Statistics' => '',
        'Import Statistics Configuration' => '',

        # Template: AgentStatisticsOverview
        'Statistics' => 'Statystyki',
        'Run' => 'Uruchom',
        'Edit statistic "%s".' => 'Edytuj statystykę "%s".',
        'Export statistic "%s"' => 'Eksportuj statystykę "%s"',
        'Export statistic %s' => 'Eksportuj statystykę %s',
        'Delete statistic "%s"' => 'Usuń statystykę "%s"',
        'Delete statistic %s' => 'Usuń statystykę %s',

        # Template: AgentStatisticsView
        'Statistics Overview' => 'Przegląd statystyk',
        'View Statistics' => '',
        'Statistics Information' => '',
        'Created by' => 'Utworzone przez',
        'Changed by' => 'Zmienione przez',
        'Sum rows' => 'Suma wierszy',
        'Sum columns' => 'Suma kolumn',
        'Show as dashboard widget' => 'Pokaż jako widget pulpitu',
        'Cache' => 'Pamięć podręczna',
        'This statistic contains configuration errors and can currently not be used.' =>
            '',

        # Template: AgentTicketActionCommon
        'Change Free Text of %s%s%s' => '',
        'Change Owner of %s%s%s' => 'Zmień właściciela dla %s%s%s',
        'Close %s%s%s' => 'Zamknij %s%s%s',
        'Add Note to %s%s%s' => 'Dodaj notatkę do %s%s%s',
        'Set Pending Time for %s%s%s' => '',
        'Change Priority of %s%s%s' => 'Zmień priorytet dla %s%s%s',
        'Change Responsible of %s%s%s' => 'Zmień odpowiedzialnego dla %s%s%s',
        'All fields marked with an asterisk (*) are mandatory.' => 'Pola oznaczone gwiazdką (*) są wymagane.',
        'The ticket has been locked' => 'Zgłoszenie zostało zablokowane',
        'Undo & close' => 'Cofnij i zamknij',
        'Ticket Settings' => 'Ustawienia zgłoszenia',
        'Queue invalid.' => 'Nie prawidłowa kolejka.',
        'Service invalid.' => 'Nieprawidłowa usługa.',
        'SLA invalid.' => 'Nie prawidłowe SLA',
        'New Owner' => 'Nowy właściciel',
        'Please set a new owner!' => 'Prosimy ustaw nowego właściciela!',
        'Owner invalid.' => 'Nie prawidłowy właściciel.',
        'New Responsible' => 'Nowy odpowiedzialny',
        'Please set a new responsible!' => 'Ustaw nowego odpowiedzialnego!',
        'Responsible invalid.' => 'Nie prawidłowy odpowiedzialny.',
        'Next state' => 'Następny stan',
        'State invalid.' => 'Stan jest nie prawidłowy.',
        'For all pending* states.' => 'Dla wszystkich stanów "oczekujacych".',
        'Add Article' => 'Dodaj wiadomość',
        'Create an Article' => 'Utwórz wiadomość',
        'Inform agents' => 'Poinformuj agentów',
        'Inform involved agents' => 'Poinformuj zaangażowanych agentów',
        'Here you can select additional agents which should receive a notification regarding the new article.' =>
            'Tutaj można wybrać dodatkowych Agentów, którzy powinni otrzymać powiadomienie o nowej wiadomości.',
        'Text will also be received by' => 'Tekst zostanie również odebrany przez',
        'Text Template' => 'Tekst szablonu',
        'Setting a template will overwrite any text or attachment.' => 'Wybranie szablonu usunie całą treść i załączniki.',
        'Invalid time!' => 'Błędny czas!',

        # Template: AgentTicketBounce
        'Bounce %s%s%s' => 'Odbij %s%s%s',
        'Bounce to' => 'Przekaż do',
        'You need a email address.' => 'Potrzebujesz adresu e-mail.',
        'Need a valid email address or don\'t use a local email address.' =>
            'Potrzebny poprawny adres e-mail lub nie używaj lokalnego adresu e-mail.',
        'Next ticket state' => 'Następny stan zgłoszenia',
        'Inform sender' => 'Powiadom nadawcę',
        'Send mail' => 'Wyślij wiadomość!',

        # Template: AgentTicketBulk
        'Ticket Bulk Action' => 'Akcja grupowa',
        'Send Email' => 'Wyślij e-mail',
        'Merge' => 'Scal',
        'Merge to' => 'Scal z',
        'Invalid ticket identifier!' => 'Niepoprawny identyfikator zgłoszenia!',
        'Merge to oldest' => 'Scal z najstarszym',
        'Link together' => 'Połącz razem',
        'Link to parent' => 'Połącz z rodzicem',
        'Unlock tickets' => 'Odblokuj zgłoszenia',
        'Execute Bulk Action' => 'Wykonaj działanie zbiorcze',

        # Template: AgentTicketCompose
        'Compose Answer for %s%s%s' => 'Utwórz Odpowiedź dla %s%s%s',
        'This address is registered as system address and cannot be used: %s' =>
            'Ten adres został zarejestrowany jako adres systemowy i nie może zostać użyty: %s',
        'Please include at least one recipient' => 'Wprowadź przynajmniej jednego odbiorcę',
        'Select one or more recipients from the customer user address book.' =>
            '',
        'Customer user address book' => '',
        'Remove Ticket Customer' => 'Usuń klienta ze zgłoszenia',
        'Please remove this entry and enter a new one with the correct value.' =>
            'Usuń ten wpis i wprowadź nowy z poprawną wartością.',
        'This address already exists on the address list.' => 'Ten adres juz istnieje na liście adresów.',
        'Remove Cc' => 'Usuń DW',
        'Bcc' => 'UDW',
        'Remove Bcc' => 'Usuń UDW',
        'Date Invalid!' => 'Niepoprawna data!',

        # Template: AgentTicketCustomer
        'Change Customer of %s%s%s' => 'Zmień klienta dla %s%s%s',
        'Customer Information' => 'Informacje o kliencie',
        'Customer user' => 'Użytkownik klienta',

        # Template: AgentTicketEmail
        'Create New Email Ticket' => 'Utwórz nowe zgłoszenie e-mail',
        'Example Template' => 'Przykładowy szablon',
        'From queue' => 'Do kolejki',
        'To customer user' => 'Do użytkownika klienta',
        'Please include at least one customer user for the ticket.' => 'Proszę dodaj przynajmniej jednego użytkownika do zgłoszenia.',
        'Select this customer as the main customer.' => 'Wybierz tego klienta jako podstawowego',
        'Remove Ticket Customer User' => 'Usuń zgłoszenie użytkownika klienta',
        'Get all' => 'Pobierz wszystkich',

        # Template: AgentTicketEmailOutbound
        'Outbound Email for %s%s%s' => 'Zewnętrzny Email dla %s%s%s',

        # Template: AgentTicketEmailResend
        'Resend Email for %s%s%s' => '',

        # Template: AgentTicketEscalation
        'Ticket %s: first response time is over (%s/%s)!' => 'Zgłoszenie %s: przekroczono czas reakcji (%s/%s)!',
        'Ticket %s: first response time will be over in %s/%s!' => 'Zgłoszenie %s: czas reakcji zostanie przekroczony za %s/%s!',
        'Ticket %s: update time is over (%s/%s)!' => 'Zgłoszenie %s: przekroczono czas aktualizacji (%s/%s)!',
        'Ticket %s: update time will be over in %s/%s!' => 'Zgłoszenie %s: czas aktualizacji zostanie przekroczony za %s/%s!',
        'Ticket %s: solution time is over (%s/%s)!' => 'Zgłoszenie %s: przekroczono czas rozwiązania (%s/%s)!',
        'Ticket %s: solution time will be over in %s/%s!' => 'Zgłoszenie %s: czas rozwiązania zostanie przekroczony za %s/%s!',

        # Template: AgentTicketForward
        'Forward %s%s%s' => 'Prześlij %s%s%s',

        # Template: AgentTicketHistory
        'History of %s%s%s' => 'Historia %s%s%s',
        'Filter for history items' => '',
        'Expand/collapse all' => 'Rozwiń/zwiń wszystko',
        'CreateTime' => 'Czas utworzenia',
        'Article' => 'Wiadomość',

        # Template: AgentTicketMerge
        'Merge %s%s%s' => 'Scal %s%s%s',
        'Merge Settings' => 'Ustawienia scalania',
        'You need to use a ticket number!' => 'Musisz użyć numeru zgłoszenia!',
        'A valid ticket number is required.' => 'Wymagany jest poprawny numer zgłoszenia.',
        'Try typing part of the ticket number or title in order to search by it.' =>
            '',
        'Limit the search to tickets with same Customer ID (%s).' => '',
        'Inform Sender' => 'Powiadom nadawcę',
        'Need a valid email address.' => 'Potrzebny poprawny adres e-mail',

        # Template: AgentTicketMove
        'Move %s%s%s' => 'Przenieś %s%s%s',
        'New Queue' => 'Nowa kolejka',
        'Move' => 'Przenieś',

        # Template: AgentTicketOverviewMedium
        'No ticket data found.' => 'Nie odnaleziono danych zgłoszenia.',
        'Open / Close ticket action menu' => 'Menu akcji otwartych / zamkniętych zgłoszeń',
        'Select this ticket' => 'Zaznacz to zgłoszenie',
        'Sender' => 'Nadawca',
        'First Response Time' => 'Czas pozostały do pierwszej odpowiedzi',
        'Update Time' => 'Czas pozostały do aktualizacji',
        'Solution Time' => 'Czas pozostały do rozwiązania',
        'Move ticket to a different queue' => 'Przenieś zgłoszenie do innej kolejki',
        'Change queue' => 'Zmień kolejkę',

        # Template: AgentTicketOverviewNavBar
        'Remove active filters for this screen.' => 'Usuń aktywne filtry z tego ekranu.',
        'Tickets per page' => 'Zgłoszeń na stronę',

        # Template: AgentTicketOverviewPreview
        'Missing channel' => '',

        # Template: AgentTicketOverviewSmall
        'Reset overview' => 'Resetuj wygląd',
        'Column Filters Form' => 'Formularz filtrów kolumn',

        # Template: AgentTicketPhone
        'Split Into New Phone Ticket' => 'Rozdziel jako nowe zgłoszenie telefoniczne',
        'Save Chat Into New Phone Ticket' => 'Zapisz czat jako nowe zgłoszenie telefoniczne',
        'Create New Phone Ticket' => 'Utwórz nowe zgłoszenie telefoniczne',
        'Please include at least one customer for the ticket.' => 'Wprowadź przynajmniej jednego klienta dla zgłoszenia.',
        'To queue' => 'Do kolejki',
        'Chat protocol' => 'Protokół czatu',
        'The chat will be appended as a separate article.' => 'Wiadomość czatu będzie dodana jako osobna wiadomość w zgłoszeniu.',

        # Template: AgentTicketPhoneCommon
        'Phone Call for %s%s%s' => 'Telefon do %s%s%s',

        # Template: AgentTicketPlain
        'View Email Plain Text for %s%s%s' => 'Zobacz teskt wiadomości email dla %s%s%s',
        'Plain' => 'Bez formatowania',
        'Download this email' => 'Pobierz ten e-mail',

        # Template: AgentTicketProcess
        'Create New Process Ticket' => 'Utwórz nowe zgłoszenie do procesu',

        # Template: AgentTicketProcessSmall
        'Enroll Ticket into a Process' => 'Zapisz zgłoszenie jako proces',

        # Template: AgentTicketSearch
        'Profile link' => 'Link do profilu',
        'Output' => 'Format wyjściowy',
        'Fulltext' => 'Pełnotekstowe',
        'Customer ID (complex search)' => 'ID Klienta (wyszukiwanie kompleksowe)',
        '(e. g. 234*)' => '(np. 234*)',
        'Customer ID (exact match)' => 'ID Klienta (dokładne dopasowanie)',
        'Assigned to Customer User Login (complex search)' => '',
        '(e. g. U51*)' => '(np. U51*)',
        'Assigned to Customer User Login (exact match)' => '',
        'Accessible to Customer User Login (exact match)' => '',
        'Created in Queue' => 'Utworzono w kolejce',
        'Lock state' => 'Stan blokady',
        'Watcher' => 'Obserwujący',
        'Article Create Time (before/after)' => 'Czas utworzenia wiadomości (przed/po)',
        'Article Create Time (between)' => 'Czas utworzenia wiadomości (pomiędzy)',
        'Please set this to value before end date.' => '',
        'Please set this to value after start date.' => '',
        'Ticket Create Time (before/after)' => 'Czas utworzenia zgłoszenia (przed/po)',
        'Ticket Create Time (between)' => 'Czas utworzenia zgłoszenia (pomiędzy)',
        'Ticket Change Time (before/after)' => 'Czas zmiany zgłoszenia (przed/po)',
        'Ticket Change Time (between)' => 'Czas zmiany zgłoszenia (pomiędzy)',
        'Ticket Last Change Time (before/after)' => 'Data modyfikacji zgłoszenia (przed/po)',
        'Ticket Last Change Time (between)' => 'Data modyfikacji zgłoszenia (pomiędzy)',
        'Ticket Pending Until Time (before/after)' => '',
        'Ticket Pending Until Time (between)' => '',
        'Ticket Close Time (before/after)' => 'Czas zamknięcia zgłoszenia (przed/po)',
        'Ticket Close Time (between)' => 'Czas zamknięcia zgłoszenia (pomiędzy)',
        'Ticket Escalation Time (before/after)' => 'Czas eskalacji zgłoszenia (przez/po)',
        'Ticket Escalation Time (between)' => 'Czas eskalacji zgłoszenia (pomiędzy)',
        'Archive Search' => 'Szukanie w archiwum',

        # Template: AgentTicketZoom
        'Sender Type' => 'Typ nadawcy',
        'Save filter settings as default' => 'Zapisz ustawienia filtru jako domyślne',
        'Event Type' => 'Typ zdarzenia',
        'Save as default' => 'Zapisz jako domyślny',
        'Drafts' => 'Szkice',
        'by' => 'przez',
        'Change Queue' => 'Zmień kolejkę',
        'There are no dialogs available at this point in the process.' =>
            'W tym punkcie procesów brak jest jeszcze dialogów.',
        'This item has no articles yet.' => 'Ten element nie zawiera jeszcze żadnych wiadomości.',
        'Ticket Timeline View' => 'Podgląd linii czasu zgłoszenia',
        'Article Overview - %s Article(s)' => '',
        'Page %s' => 'Strona %s',
        'Add Filter' => 'Dodaj filtr',
        'Set' => 'Ustaw',
        'Reset Filter' => 'resetuj filtr',
        'No.' => 'Lp.',
        'Unread articles' => 'Nieprzeczytane wiadomości',
        'Via' => 'Przez',
        'Important' => 'Ważne',
        'Unread Article!' => 'Nieprzeczytana wiadomość!',
        'Incoming message' => 'Wiadomość przychodząca',
        'Outgoing message' => 'Wiadomość wychodząca',
        'Internal message' => 'Wiadomość wewnętrzna',
        'Sending of this message has failed.' => '',
        'Resize' => 'Zmień rozmiar',
        'Mark this article as read' => 'Oznacz wiadomość jako przeczytaną',
        'Show Full Text' => 'Pokaż pełną treść',
        'Full Article Text' => 'Pełna treść wiadomości',
        'No more events found. Please try changing the filter settings.' =>
            'Nie znaleziono więcej zdarzeń. Proszę spróbuj zmienić ustawienia filtrów.',

        # Template: Chat
        '#%s' => '',
        'via %s' => 'przez %s',
        'by %s' => 'przez %s',
        'Toggle article details' => '',

        # Template: MIMEBase
        'This message is being processed. Already tried to send %s time(s). Next try will be %s.' =>
            '',
        'To open links in the following article, you might need to press Ctrl or Cmd or Shift key while clicking the link (depending on your browser and OS).' =>
            'W celu otwarcia linków zawartych w wiadomości może być konieczne naciśnięcie klawisza Ctrl, Cmd lub Shift w połączeniu z kliknięciem klawisza myszy (w zależności od używanej przeglądarki internetowej).',
        'Close this message' => 'Zamknij wiadomość',
        'Image' => 'Obraz',
        'PDF' => 'PDF',
        'Unknown' => 'Nieznany',
        'View' => 'Zobacz',

        # Template: LinkTable
        'Linked Objects' => 'Połączone elementy',

        # Template: TicketInformation
        'Archive' => 'Archiwum',
        'This ticket is archived.' => 'To zgłoszenie jest zarchiwizowane.',
        'Note: Type is invalid!' => 'Uwaga: Typ jest niepoprawny!',
        'Pending till' => 'Oczekuje do',
        'Locked' => 'Blokada',
        '%s Ticket(s)' => '%s Zgłoszenie(a)',
        'Accounted time' => 'Zaraportowany czas',

        # Template: Invalid
        'Preview of this article is not possible because %s channel is missing in the system.' =>
            '',
        'This feature is part of the %s. Please contact us at %s for an upgrade.' =>
            '',
        'Please re-install %s package in order to display this article.' =>
            '',

        # Template: AttachmentBlocker
        'To protect your privacy, remote content was blocked.' => 'Aby chronić twoją prywatność, zdalna zawartość została zablokowana.',
        'Load blocked content.' => 'Załaduj zablokowaną treść.',

        # Template: Breadcrumb
        'Home' => '',
        'Back to admin overview' => '',

        # Template: CloudServicesDisabled
        'This Feature Requires Cloud Services' => 'Ta funkcja wymaga usług w chmurze',
        'You can' => 'Możesz',
        'go back to the previous page' => 'powrócić do poprzedniej strony',

        # Template: CustomerAccept
        'Dear Customer,' => 'Drogi Kliencie,',
        'thank you for using our services.' => 'dziękujemy za korzystanie z naszych usług.',
        'Yes, I accept your license.' => '',

        # Template: TicketCustomerIDSelection
        'The customer ID is not changeable, no other customer ID can be assigned to this ticket.' =>
            '',
        'First select a customer user, then you can select a customer ID to assign to this ticket.' =>
            '',
        'Select a customer ID to assign to this ticket.' => '',
        'From all Customer IDs' => '',
        'From assigned Customer IDs' => '',

        # Template: CustomerError
        'An Error Occurred' => 'Wystąpił błąd',
        'Error Details' => 'Szczegóły błędu',
        'Traceback' => 'Śledź wstecz',

        # Template: CustomerFooter
        '%s powered by %s™' => '',
        'Powered by %s™' => '',

        # Template: CustomerFooterJS
        '%s detected possible network issues. You could either try reloading this page manually or wait until your browser has re-established the connection on its own.' =>
            '',
        'The connection has been re-established after a temporary connection loss. Due to this, elements on this page could have stopped to work correctly. In order to be able to use all elements correctly again, it is strongly recommended to reload this page.' =>
            '',

        # Template: CustomerLogin
        'JavaScript Not Available' => 'JavaScript nie jest dostęny',
        'In order to experience this software, you\'ll need to enable JavaScript in your browser.' =>
            '',
        'Browser Warning' => 'Ostrzeżenie dotyczące przeglądarki',
        'The browser you are using is too old.' => 'Przeglądarka której używasz jest zbyt stara.',
        'This software runs with a huge lists of browsers, please upgrade to one of these.' =>
            '',
        'Please see the documentation or ask your admin for further information.' =>
            'Zajrzyj do dokumentacji lub zapytaj o szczegóły swojego administratora.',
        'One moment please, you are being redirected...' => 'Poczekaj chwilę, trwa przekierowywanie...',
        'Login' => 'Login',
        'User name' => 'Nazwa użytkownika',
        'Your user name' => 'Twoja nazwa użytkownika',
        'Your password' => 'Twoje hasło',
        'Forgot password?' => 'Zapomniane hasło?',
        '2 Factor Token' => 'Token weryfikacji dwuetapowej',
        'Your 2 Factor Token' => 'Twój token weryfikacji dwuetapowej',
        'Log In' => 'Zaloguj się',
        'Not yet registered?' => 'Nie jesteś jeszcze zarejetrowanym użytkownikiem?',
        'Back' => 'Powrót',
        'Request New Password' => 'Prośba o nowe hasło',
        'Your User Name' => 'Nazwa użytkownika',
        'A new password will be sent to your email address.' => 'Nowe hasło będzie wysłane na twój adres e-mail',
        'Create Account' => 'Utwórz konto',
        'Please fill out this form to receive login credentials.' => 'Wypełnij ten formularz aby otrzymać dane logowania.',
        'How we should address you' => 'Jak powinniśmy cię tytułować',
        'Your First Name' => 'Twoje imię',
        'Your Last Name' => 'Twoje nazwisko',
        'Your email address (this will become your username)' => 'Twój adres e-mail (stanie się twoją nazwą użytkownika)',

        # Template: CustomerNavigationBar
        'Incoming Chat Requests' => 'Czaty z oczekującymi wiadomościami',
        'Edit personal preferences' => 'Edytuj ustawienia osobiste',
        'Logout %s' => 'Wyloguj %s',

        # Template: CustomerTicketMessage
        'Service level agreement' => 'SLA',

        # Template: CustomerTicketOverview
        'Welcome!' => 'Witaj!',
        'Please click the button below to create your first ticket.' => 'Prosimy, kliknij przycisk poniżej aby utworzyć swoje pierwsze zgłoszenie.',
        'Create your first ticket' => 'Utwórz swoje pierwsze zgłoszenie',

        # Template: CustomerTicketSearch
        'Profile' => 'Profil',
        'e. g. 10*5155 or 105658*' => 'np. 10*5155 lub 105658*',
        'CustomerID' => 'Identyfikator klienta',
        'Fulltext Search in Tickets (e. g. "John*n" or "Will*")' => '',
        'Types' => 'Typy zgłoszeń',
        'Time Restrictions' => '',
        'No time settings' => 'Brak ustawień czasowych',
        'All' => 'Wszystkie',
        'Specific date' => 'Konkretna data',
        'Only tickets created' => 'Tylko zgłoszenia utworzone',
        'Date range' => 'Zakres dat',
        'Only tickets created between' => 'Tylko zgłoszenia utworzone między',
        'Ticket Archive System' => '',
        'Save Search as Template?' => '',
        'Save as Template?' => 'Zapisać jako szablon?',
        'Save as Template' => 'Zapisz jako szablon',
        'Template Name' => 'Nazwa szablonu',
        'Pick a profile name' => 'Wybierz nazwę profilu',
        'Output to' => 'Wyniki prezentuj jako',

        # Template: CustomerTicketSearchResultShort
        'of' => 'z',
        'Page' => 'Strona',
        'Search Results for' => 'Wyniki wyszukiwania dla',
        'Remove this Search Term.' => '',

        # Template: CustomerTicketZoom
        'Start a chat from this ticket' => 'Rozpocznij czat z tego zgłoszenia',
        'Next Steps' => 'Następne kroki',
        'Reply' => 'Odpowiedź',

        # Template: Chat
        'Expand article' => 'Rozwiń wiadomość',

        # Template: CustomerWarning
        'Warning' => 'Ostrzeżenie',

        # Template: DashboardEventsTicketCalendar
        'Event Information' => 'Informacje o zdarzeniach',
        'Ticket fields' => 'Pola zgłoszenia',

        # Template: Error
        'Really a bug? 5 out of 10 bug reports result from a wrong or incomplete installation of OTRS.' =>
            '',
        'With %s, our experts take care of correct installation and cover your back with support and periodic security updates.' =>
            '',
        'Contact our service team now.' => '',
        'Send a bugreport' => 'Wysłać raport na temat błędu',
        'Expand' => 'Rozwiń',

        # Template: AttachmentList
        'Click to delete this attachment.' => '',

        # Template: DraftButtons
        'Update draft' => 'Zaktualizuj szkic',
        'Save as new draft' => 'Zapisz jako nowy szkic',

        # Template: DraftNotifications
        'You have loaded the draft "%s".' => 'Wczytałeś szkic "%s"',
        'You have loaded the draft "%s". You last changed it %s.' => 'Wczytałeś szkic "%s". Ostatnio zmieniałeś go %s.',
        'You have loaded the draft "%s". It was last changed %s by %s.' =>
            'Wczytałeś szkic "%s". Ostatnio zmieniony %s przez %s.',
        'Please note that this draft is outdated because the ticket was modified since this draft was created.' =>
            'Zauważ, że szkic jest nieaktualny ponieważ zgłoszenie zostało zmienione od czasu utworzenia szkicu.',

        # Template: Header
        'View notifications' => 'Pokaż powiadomienia',
        'Notifications' => 'Powiadomienia',
        'Notifications (OTRS Business Solution™)' => 'Powiadomienia (OTRS Business Solution™)',
        'Personal preferences' => 'Ustawienia osobiste',
        'Logout' => 'Wyloguj',
        'You are logged in as' => 'Jesteś zalogowany jako',

        # Template: Installer
        'JavaScript not available' => 'JavaSript nie jest dostępny',
        'Step %s' => 'Krok %s',
        'License' => 'Licencja',
        'Database Settings' => 'Ustawienia bazy danych',
        'General Specifications and Mail Settings' => 'Ustawienia ogólne i poczty e-mail',
        'Finish' => 'Koniec',
        'Welcome to %s' => 'Witaj w %s',
        'Germany' => '',
        'Phone' => 'Tel.',
        'United States' => '',
        'Mexico' => '',
        'Hungary' => '',
        'Brazil' => '',
        'Singapore' => '',
        'Hong Kong' => '',
        'Web site' => 'Strona WWW',

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
        'Done' => 'Wykonane',
        'Error' => 'Błąd',
        'Database setup successful!' => 'Konfiguracja bazy danych powiodła się!',

        # Template: InstallerDBStart
        'Install Type' => 'Zainstaluj typ',
        'Create a new database for OTRS' => 'Utwórz nową baze danych dla OTRS',
        'Use an existing database for OTRS' => 'Użyj istniejącej bazy danych dla OTRS',

        # Template: InstallerDBmssql
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty.' =>
            'Jeśli ustawiłeś hasło główne do bazy danych to wprowadź je w tym polu. Jeśli nie to pozostaw pole puste .',
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
            'Musisz wpisać następujące polecenie w linii komend (Terminal/Shell) jako root.',
        'Restart your webserver' => 'Uruchom ponownie serwer WWW',
        'After doing so your OTRS is up and running.' => 'Po zakończeniu tych czynności Twój system OTRS będzie gotowy do pracy.',
        'Start page' => 'Strona startowa',
        'Your OTRS Team' => 'Twój Zespół OTRS',

        # Template: InstallerLicense
        'Don\'t accept license' => 'Nie akceptuję licencji',
        'Accept license and continue' => 'Zaakceptuj licencje i kontynuuj',

        # Template: InstallerSystem
        'SystemID' => 'SystemID',
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
        'Delete link' => 'Usuń połączenie',
        'Delete Link' => 'Usuń Połączenie',
        'Object#' => 'Obiekt#',
        'Add links' => 'Dodaj odnośniki',
        'Delete links' => 'Usuń odnośniki',

        # Template: Login
        'Lost your password?' => 'Zapomniałeś hasła?',
        'Back to login' => 'Powrót do logowania',

        # Template: MetaFloater
        'Scale preview content' => '',
        'Open URL in new tab' => 'Otwórz URL w nowej zakładce',
        'Close preview' => 'Zamknij podgląd',
        'A preview of this website can\'t be provided because it didn\'t allow to be embedded.' =>
            '',

        # Template: MobileNotAvailableWidget
        'Feature not Available' => '',
        'Sorry, but this feature of OTRS is currently not available for mobile devices. If you\'d like to use it, you can either switch to desktop mode or use your regular desktop device.' =>
            '',

        # Template: Motd
        'Message of the Day' => 'Wiadomość dnia',
        'This is the message of the day. You can edit this in %s.' => '',

        # Template: NoPermission
        'Insufficient Rights' => 'Niewystarczające uprawnienia',
        'Back to the previous page' => 'Powrót do poprzedniej strony',

        # Template: Alert
        'Alert' => '',
        'Powered by' => 'Oparte na',

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

        # Template: PreferencesNotificationEvent
        'No user configurable notifications found.' => '',
        'Receive messages for notification \'%s\' by transport method \'%s\'.' =>
            '',

        # Template: ActivityDialogHeader
        'Process Information' => 'Informacje procesowe',
        'Dialog' => '',

        # Template: Article
        'Inform Agent' => 'Poinformuj agenta',

        # Template: PublicDefault
        'Welcome' => 'Witaj',
        'This is the default public interface of OTRS! There was no action parameter given.' =>
            '',
        'You could install a custom public module (via the package manager), for example the FAQ module, which has a public interface.' =>
            '',

        # Template: GeneralSpecificationsWidget
        'Permissions' => 'Uprawnienia',
        'You can select one or more groups to define access for different agents.' =>
            'Możesz wskazać jedną lub więcej grup aby zdefiniować dostęp dla różnych agentów.',
        'Result formats' => '',
        'Time Zone' => 'Strefa czasowa',
        'The selected time periods in the statistic are time zone neutral.' =>
            '',
        'Create summation row' => '',
        'Generate an additional row containing sums for all data rows.' =>
            '',
        'Create summation column' => '',
        'Generate an additional column containing sums for all data columns.' =>
            '',
        'Cache results' => 'Buforuj wyniki',
        'Stores statistics result data in a cache to be used in subsequent views with the same configuration (requires at least one selected time field).' =>
            '',
        'Provide the statistic as a widget that agents can activate in their dashboard.' =>
            'Udostępnij statystyki jako widget który agenci mogą aktywowac na swoim pulpicie.',
        'Please note that enabling the dashboard widget will activate caching for this statistic in the dashboard.' =>
            '',
        'If set to invalid end users can not generate the stat.' => 'Jeśli ustawiono wartość \'nieaktywne\' to użytkownicy nie będą mogli wygenerować tej statystyki.',

        # Template: PreviewWidget
        'There are problems in the configuration of this statistic:' => '',
        'You may now configure the X-axis of your statistic.' => '',
        'This statistic does not provide preview data.' => '',
        'Preview format' => '',
        'Please note that the preview uses random data and does not consider data filters.' =>
            '',
        'Configure X-Axis' => 'Skonfiguruj oś X',
        'X-axis' => 'Oś X',
        'Configure Y-Axis' => 'Skonfiguruj oś Y',
        'Y-axis' => 'oś Y',
        'Configure Filter' => 'Konfiguruj filtr',

        # Template: RestrictionsWidget
        'Please select only one element or turn off the button \'Fixed\'.' =>
            'Wybierz jeden element lub odznacz przycisk \'Stały\'.',
        'Absolute period' => 'Okres bezwzględny',
        'Between %s and %s' => 'Pomiędzy %s i %s',
        'Relative period' => 'Okres względny',
        'The past complete %s and the current+upcoming complete %s %s' =>
            'Zakończonych okresów %s oraz okres bieżący + przyszłe okresy %s%s',
        'Do not allow changes to this element when the statistic is generated.' =>
            '',

        # Template: StatsParamsWidget
        'Format' => 'Format',
        'Exchange Axis' => 'Zamień osie',
        'Configurable Params of Static Stat' => '',
        'No element selected.' => 'Nie wybrano elementu',
        'Scale' => 'Skala',
        'show more' => 'pokaż więcej',
        'show less' => 'pokaż mniej',

        # Template: D3
        'Download SVG' => 'Pobierz SVG',
        'Download PNG' => 'Pobierz PNG',

        # Template: XAxisWidget
        'The selected time period defines the default time frame for this statistic to collect data from.' =>
            '',
        'Defines the time unit that will be used to split the selected time period into reporting data points.' =>
            '',

        # Template: YAxisWidget
        'Please remember that the scale for the Y-axis has to be larger than the scale for the X-axis (e.g. X-axis => Month, Y-Axis => Year).' =>
            '',

        # Template: SettingsList
        'This setting is disabled.' => 'To ustawienie jest wyłączone.',
        'This setting is fixed but not deployed yet!' => 'To ustawienie jest przygotowane ale jeszcze nie wdrożone!',
        'This setting is currently being overridden in %s and can\'t thus be changed here!' =>
            '',
        'Changing this setting is only available in a higher config level!' =>
            '',
        '%s (%s) is currently working on this setting.' => '',
        'Toggle advanced options for this setting' => '',
        'Disable this setting, so it is no longer effective' => '',
        'Disable' => 'Wyłącz',
        'Enable this setting, so it becomes effective' => '',
        'Enable' => 'Włącz',
        'Reset this setting to its default state' => '',
        'Reset setting' => 'Przywróć ustawienie',
        'Allow users to adapt this setting from within their personal preferences' =>
            '',
        'Allow users to update' => 'Pozwól użytkownikom aktualizować',
        'Do not longer allow users to adapt this setting from within their personal preferences' =>
            '',
        'Forbid users to update' => 'Zabroń użytkownikom aktualizować',
        'Show user specific changes for this setting' => '',
        'Show user settings' => 'Pokaż ustawienia użytkownika',
        'Copy a direct link to this setting to your clipboard' => '',
        'Copy direct link' => '',
        'Remove this setting from your favorites setting' => '',
        'Remove from favourites' => 'Usuń z ulubionych',
        'Add this setting to your favorites' => 'Dodaj to ustawienie do swoich ulubionych',
        'Add to favourites' => 'Dodaj do ulubionych',
        'Cancel editing this setting' => 'Anuluj zmianę tego ustawienia',
        'Save changes on this setting' => 'Zapisz zmiany dla tego ustawienia',
        'Edit this setting' => 'Zmień to ustawienie',
        'Enable this setting' => 'Włącz to ustawienie',
        'This group doesn\'t contain any settings. Please try navigating to one of its sub groups or another group.' =>
            '',

        # Template: SettingsListCompare
        'Now' => 'Teraz',
        'User modification' => 'Modyfikacje użytkownika',
        'enabled' => 'włączone',
        'disabled' => 'wyłączone',
        'Setting state' => '',

        # Template: Actions
        'Edit search' => '',
        'Go back to admin: ' => '',
        'Deployment' => 'Wdrożenie',
        'My favourite settings' => 'Moje ulubione ustawienia',
        'Invalid settings' => '',

        # Template: DynamicActions
        'Filter visible settings...' => 'Filtruj widoczne ustawienia...',
        'Enable edit mode for all settings' => 'Włącz tryb edycji dla wszystkich ustawień',
        'Save all edited settings' => 'Zapisz wszystkie edytowane ustawienia',
        'Cancel editing for all settings' => 'Anuluj edycję wszystkich ustawień',
        'All actions from this widget apply to the visible settings on the right only.' =>
            'Wszystkie akcje dostępne w tym widżecie stosuje się wyłącznie do ustawień widocznych po prawej stronie.',

        # Template: Help
        'Currently edited by me.' => 'Obecnie edytowane przeze mnie',
        'Modified but not yet deployed.' => 'Zmodyfikowane, ale jeszcze nie wdrożone.',
        'Currently edited by another user.' => 'Obecnie edytowane przez innego użytkownika',
        'Different from its default value.' => 'Wartość różna od wartości domyślnej.',
        'Save current setting.' => 'Zapisz bieżące ustawienie.',
        'Cancel editing current setting.' => 'Anuluj edycję bieżącego ustawienia.',

        # Template: Navigation
        'Navigation' => 'Nawigacja',

        # Template: OTRSBusinessTeaser
        'With %s, System Configuration supports versioning, rollback and user-specific configuration settings.' =>
            '',

        # Template: Test
        'OTRS Test Page' => 'OTRS Strona testowa',
        'Unlock' => 'Odblokuj',
        'Welcome %s %s' => 'Witaj %s %s',
        'Counter' => 'Licznik',

        # Template: Warning
        'Go back to the previous page' => 'Powrót do poprzedniej strony',

        # JS Template: CalendarSettingsDialog
        'Show' => 'Pokaż',

        # JS Template: FormDraftAddDialog
        'Draft title' => 'Tytuł szkicu',

        # JS Template: ArticleViewSettingsDialog
        'Article display' => '',

        # JS Template: FormDraftDeleteDialog
        'Do you really want to delete "%s"?' => '',
        'Confirm' => 'Potwierdź',

        # JS Template: WidgetLoading
        'Loading, please wait...' => '',

        # JS Template: UploadContainer
        'Click to select a file for upload.' => '',
        'Click to select files or just drop them here.' => 'Kliknij aby wybrać pliki lub po prostu upuść je tutaj.',
        'Click to select a file or just drop it here.' => '',
        'Uploading...' => '',

        # JS Template: InformationDialog
        'Process state' => 'Stan procesu',
        'Running' => '',
        'Finished' => 'Zakończono',
        'No package information available.' => '',

        # JS Template: AddButton
        'Add new entry' => 'Dodaj nową pozycję',

        # JS Template: AddHashKey
        'Add key' => 'Dodaj klucz',

        # JS Template: DialogDeployment
        'Deployment comment...' => 'Komentarz do wdrożenia...',
        'This field can have no more than 250 characters.' => '',
        'Deploying, please wait...' => 'Wdrażanie, proszę czekać...',
        'Preparing to deploy, please wait...' => 'Przygotowanie do wdrożenia, proszę czekać...',
        'Deploy now' => 'Wdróż teraz',
        'Try again' => 'Spróbuj ponownie',

        # JS Template: DialogReset
        'Reset options' => 'Opcje Resetu',
        'Reset setting on global level.' => 'Resetuj ustawienia na poziomie globalnym',
        'Reset globally' => 'Resetuj globalnie',
        'Remove all user changes.' => 'Wycofaj wszystkie zmiany użytkownika',
        'Reset locally' => 'Resetuj lokalnie',
        'user(s) have modified this setting.' => '',
        'Do you really want to reset this setting to it\'s default value?' =>
            '',

        # JS Template: HelpDialog
        'You can use the category selection to limit the navigation tree below to entries from the selected category. As soon as you select the category, the tree will be re-built.' =>
            '',

        # Perl Module: Kernel/Config/Defaults.pm
        'Database Backend' => '',
        'CustomerIDs' => 'Identyfikatory klientów',
        'Fax' => 'Faks',
        'Street' => 'Ulica',
        'Zip' => 'Kod pocztowy',
        'City' => 'Miejscowość',
        'Country' => 'Kraj',
        'Valid' => 'Aktualne',
        'Mr.' => 'Pan',
        'Mrs.' => 'Pani',
        'Address' => 'Adres',
        'View system log messages.' => 'Podgląd dziennika zdarzeń systemowych',
        'Edit the system configuration settings.' => 'Edytuj ustawienia konfiguracji systemu.',
        'Update and extend your system with software packages.' => 'Zaktualizuj i rozbuduj swój system przy pomocy pakietów oprogramowania.',

        # Perl Module: Kernel/Modules/AdminACL.pm
        'ACL information from database is not in sync with the system configuration, please deploy all ACLs.' =>
            'Dane dostępu ACL z bazy danych nie są zsynchronizowane z konfiguraacją systemu, proszę wprowadź wszystkie ACLe.',
        'ACLs could not be Imported due to a unknown error, please check OTRS logs for more information' =>
            'ACL nie została zaimportowania z powodu nieznanego błędu, więcej informacji znajdziesz w logach OTRS',
        'The following ACLs have been added successfully: %s' => 'Dodanie następujących ACLi powiodło się: %s',
        'The following ACLs have been updated successfully: %s' => 'Aktualizacja następujących ACLi powiodła się: %s',
        'There where errors adding/updating the following ACLs: %s. Please check the log file for more information.' =>
            'Podczas dodawania/aktualizacji następujących ACLi wystąpiły błędy: %s. Więcej informacji znajdziesz w pliku logu.',
        'This field is required' => 'To pole jest wymagane',
        'There was an error creating the ACL' => 'Podczas tworzenia ACLa wystąpił błąd.',
        'Need ACLID!' => 'Potrzebny ACLID!',
        'Could not get data for ACLID %s' => 'Nieudane pobranie danych dla ACLID %s',
        'There was an error updating the ACL' => 'Podczas aktualizacji ACL wystąpił błąd.',
        'There was an error setting the entity sync status.' => 'Podczas ustawiania statusu synchronizacji encji wystąpił błąd.',
        'There was an error synchronizing the ACLs.' => 'Wystąpił błąd podczas synchronizacji ACLi.',
        'ACL %s could not be deleted' => 'ACL %s nie mógł zostać usunięty',
        'There was an error getting data for ACL with ID %s' => 'Nastąpił błąd przy pobieraniu danych dla ACL o ID %s',
        '%s (copy) %s' => '',
        'Please note that ACL restrictions will be ignored for the Superuser account (UserID 1).' =>
            '',
        'Exact match' => 'Dokładne dopasowanie',
        'Negated exact match' => 'Zanegowane dokładne dopasowanie',
        'Regular expression' => 'Wyrażenie regularne',
        'Regular expression (ignore case)' => 'Wyrażenie regularne (ignoruj wielkość liter)',
        'Negated regular expression' => 'Zanegowane wyrażenie regularne',
        'Negated regular expression (ignore case)' => 'Zanegowane wyrażenie regularne (ignoruj wielkość liter)',

        # Perl Module: Kernel/Modules/AdminAppointmentCalendarManage.pm
        'System was unable to create Calendar!' => 'System nie był w stanie stworzyć Kalendarza.',
        'Please contact the administrator.' => 'Proszę skontaktuj się z administratorem',
        'No CalendarID!' => 'Brak CalendarID!',
        'You have no access to this calendar!' => 'Nie masz dostępu do tego kalendarza!',
        'Error updating the calendar!' => 'Błąd aktualizacji kalendarza!',
        'Couldn\'t read calendar configuration file.' => 'Nie można odczytać pliku konfiguracyjnego kalendarza.',
        'Please make sure your file is valid.' => 'Proszę upewnić się, że plik jest właściwy.',
        'Could not import the calendar!' => 'Nie można zaimportować kalendarza!',
        'Calendar imported!' => 'Kalendarz Zaimportowany!',
        'Need CalendarID!' => 'Potrzebne CalendarID!',
        'Could not retrieve data for given CalendarID' => 'Nie można odczytać informacji dla podanego CalendarID',
        'Successfully imported %s appointment(s) to calendar %s.' => 'Poprawnie zaimportowano %s wydarzeń do kalendarza %s.',
        '+5 minutes' => '+5 minut',
        '+15 minutes' => '+15 minut',
        '+30 minutes' => '+30 minut',
        '+1 hour' => '+1 godzina',

        # Perl Module: Kernel/Modules/AdminAppointmentImport.pm
        'No permissions' => 'Brak uprawnień',
        'System was unable to import file!' => 'System nie był w stanie zaimportować pliku!',
        'Please check the log for more information.' => 'Proszę sprawdzić logi dla dokładniejszych informacji.',

        # Perl Module: Kernel/Modules/AdminAppointmentNotificationEvent.pm
        'Notification name already exists!' => 'Powiadomienie o tej samej nazwie już istnieje!',
        'Notification added!' => 'Powiadomienie dostało dodane!',
        'There was an error getting data for Notification with ID:%s!' =>
            '',
        'Unknown Notification %s!' => 'Nieznane Powiadomienie %s!',
        '%s (copy)' => '',
        'There was an error creating the Notification' => 'Wystąpił błąd podczas tworzenia powiadomienia',
        'Notifications could not be Imported due to a unknown error, please check OTRS logs for more information' =>
            '',
        'The following Notifications have been added successfully: %s' =>
            '',
        'The following Notifications have been updated successfully: %s' =>
            '',
        'There where errors adding/updating the following Notifications: %s. Please check the log file for more information.' =>
            '',
        'Notification updated!' => 'Powiadomienie zostało zaktualizowane!',
        'Agent (resources), who are selected within the appointment' => 'Agenci (zasoby), wybrani w ramach wydarzenia',
        'All agents with (at least) read permission for the appointment (calendar)' =>
            'Wszyscy agenci posiadający (przynajmniej) prawo odczytu zdarzenia (kalendarza)',
        'All agents with write permission for the appointment (calendar)' =>
            'Wszyscy agenci z prawem zapisu wydarzenia (kalendarza)',
        'Yes, but require at least one active notification method.' => '',

        # Perl Module: Kernel/Modules/AdminAttachment.pm
        'Attachment added!' => 'Załącznik dodany!',

        # Perl Module: Kernel/Modules/AdminAutoResponse.pm
        'Auto Response added!' => 'Automatyczna odpowiedź została dodana!',

        # Perl Module: Kernel/Modules/AdminCommunicationLog.pm
        'Invalid CommunicationID!' => '',
        'All communications' => 'Cała komunikacja',
        'Last 1 hour' => 'Ostatnia godzina',
        'Last 3 hours' => 'Ostatnie 3 godziny',
        'Last 6 hours' => 'Ostatnie 6 godzin',
        'Last 12 hours' => 'Ostatnie 12 godzin',
        'Last 24 hours' => 'Ostatnie 24 godziny',
        'Last week' => 'Ostatni tydzień',
        'Last month' => 'Ostatni miesiąc',
        'Invalid StartTime: %s!' => 'Niepoprawny StartTime: 1%s!',
        'Successful' => 'Sukces',
        'Processing' => 'Przetwarzanie',
        'Failed' => 'Niepowodzenie',
        'Invalid Filter: %s!' => '',
        'Less than a second' => 'Mniej niż sekunda',
        'sorted descending' => 'posortowane malejąco',
        'sorted ascending' => 'posortowane rosnąco',
        'Trace' => '',
        'Debug' => '',
        'Info' => 'Info',
        'Warn' => '',
        'days' => 'dni',
        'day' => 'dzień',
        'hour' => 'godzina',
        'minute' => 'minuta',
        'seconds' => 'sekund',
        'second' => 'drugi',

        # Perl Module: Kernel/Modules/AdminCustomerCompany.pm
        'Customer company updated!' => 'Firma zaktualizowana!',
        'Dynamic field %s not found!' => '',
        'Unable to set value for dynamic field %s!' => '',
        'Customer Company %s already exists!' => 'Firma klienta %s już istnieje!',
        'Customer company added!' => 'Firma dodana!',

        # Perl Module: Kernel/Modules/AdminCustomerGroup.pm
        'No configuration for \'CustomerGroupPermissionContext\' found!' =>
            '',
        'Please check system configuration.' => '',
        'Invalid permission context configuration:' => '',

        # Perl Module: Kernel/Modules/AdminCustomerUser.pm
        'Customer updated!' => 'Klient zaktualizowany!',
        'New phone ticket' => 'Nowe zgłoszenie telefoniczne',
        'New email ticket' => 'Nowe zgłoszenie e-mail',
        'Customer %s added' => 'Klient %s został dodany',
        'Customer user updated!' => '',
        'Same Customer' => '',
        'Direct' => '',
        'Indirect' => '',

        # Perl Module: Kernel/Modules/AdminCustomerUserGroup.pm
        'Change Customer User Relations for Group' => '',
        'Change Group Relations for Customer User' => '',

        # Perl Module: Kernel/Modules/AdminCustomerUserService.pm
        'Allocate Customer Users to Service' => 'Przypisz Użytkowników Klienta do Usług',
        'Allocate Services to Customer User' => 'Przypisz Usługi do Użytkownika Klienta',

        # Perl Module: Kernel/Modules/AdminDynamicField.pm
        'Fields configuration is not valid' => 'Konfiguracja pól jest niepoprawna',
        'Objects configuration is not valid' => 'Konfiguracja obiektów jest niepoprawna',
        'Database (%s)' => 'Baza danych (%s)',
        'Web service (%s)' => 'Serwis sieciowy (%s)',
        'Contact with data (%s)' => '',
        'Could not reset Dynamic Field order properly, please check the error log for more details.' =>
            'Nie udało się prawidłowo przywrócić kolejności Pól Dynamicznych, więcej szczegółów znajduje się w pliku logu.',

        # Perl Module: Kernel/Modules/AdminDynamicFieldCheckbox.pm
        'Undefined subaction.' => 'Nieokreślone działanie podrzędne.',
        'Need %s' => 'Wymagany %s',
        'Add %s field' => 'Dodaj 1%s pole',
        'The field does not contain only ASCII letters and numbers.' => '',
        'There is another field with the same name.' => '',
        'The field must be numeric.' => '',
        'Need ValidID' => 'Wymagane poprawne ID',
        'Could not create the new field' => 'Nie udało się utworzyć nowego pola',
        'Need ID' => 'Wymagane ID',
        'Could not get data for dynamic field %s' => '',
        'Change %s field' => 'Zmień 1%s pole',
        'The name for this field should not change.' => '',
        'Could not update the field %s' => '',
        'Currently' => 'Aktualnie',
        'Unchecked' => 'Niezaznaczone',
        'Checked' => 'Zaznaczone',

        # Perl Module: Kernel/Modules/AdminDynamicFieldDateTime.pm
        'Prevent entry of dates in the future' => 'Nie pozwalaj na wprowadzanie dat w przyszłości',
        'Prevent entry of dates in the past' => 'Nie pozwalaj na wprowadzanie dat w przeszłości',

        # Perl Module: Kernel/Modules/AdminDynamicFieldDropdown.pm
        'This field value is duplicated.' => '',

        # Perl Module: Kernel/Modules/AdminEmail.pm
        'Select at least one recipient.' => 'Wybierz przynajmniej jednego odbiorcę.',

        # Perl Module: Kernel/Modules/AdminGenericAgent.pm
        'minute(s)' => 'minut(-a/-y)',
        'hour(s)' => 'godz.',
        'Time unit' => 'Jednostka czasu',
        'within the last ...' => 'w ciągu ostatniego(-ch) ...',
        'within the next ...' => 'w ciągu następnego(-ych) ...',
        'more than ... ago' => 'wcześniej niż ...',
        'Unarchived tickets' => 'Zgłoszenia nie zachiwizowane',
        'archive tickets' => 'archiwizuj zgłoszenia',
        'restore tickets from archive' => 'przywróć zgłoszenia z archiwum',
        'Need Profile!' => 'Potrzebny Profil!',
        'Got no values to check.' => '',
        'Please remove the following words because they cannot be used for the ticket selection:' =>
            '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceDebugger.pm
        'Need WebserviceID!' => 'Wymagane ID webserwisu',
        'Could not get data for WebserviceID %s' => '',
        'ascending' => 'rosnąco',
        'descending' => 'malejąco',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceErrorHandlingDefault.pm
        'Need communication type!' => '',
        'Communication type needs to be \'Requester\' or \'Provider\'!' =>
            '',
        'Invalid Subaction!' => '',
        'Need ErrorHandlingType!' => '',
        'ErrorHandlingType %s is not registered' => '',
        'Could not update web service' => '',
        'Need ErrorHandling' => '',
        'Could not determine config for error handler %s' => '',
        'Invoker processing outgoing request data' => '',
        'Mapping outgoing request data' => '',
        'Transport processing request into response' => '',
        'Mapping incoming response data' => '',
        'Invoker processing incoming response data' => '',
        'Transport receiving incoming request data' => '',
        'Mapping incoming request data' => '',
        'Operation processing incoming request data' => '',
        'Mapping outgoing response data' => '',
        'Transport sending outgoing response data' => '',
        'skip same backend modules only' => '',
        'skip all modules' => '',
        'Operation deleted' => 'Operacja usunięta',
        'Invoker deleted' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceErrorHandlingRequestRetry.pm
        '0 seconds' => '0 sekund',
        '15 seconds' => '15 sekund',
        '30 seconds' => '30 sekund',
        '45 seconds' => '45 sekund',
        '1 minute' => '1 minuta',
        '2 minutes' => '2 minuty',
        '3 minutes' => '3 minuty',
        '4 minutes' => '4 minuty',
        '5 minutes' => '5 minut',
        '10 minutes' => '10 minut',
        '15 minutes' => '15 minut',
        '30 minutes' => '30 minut',
        '1 hour' => '1 godzina',
        '2 hours' => '2 godziny',
        '3 hours' => '3 godziny',
        '4 hours' => '4 godziny',
        '5 hours' => '5 godzin',
        '6 hours' => '6 godzin',
        '12 hours' => '12 godzin',
        '18 hours' => '18 godzin',
        '1 day' => '1 dzień',
        '2 days' => '2 dni',
        '3 days' => '3 dni',
        '4 days' => '4 dni',
        '6 days' => '6 dni',
        '1 week' => '1 tydzień',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceInvokerDefault.pm
        'Could not determine config for invoker %s' => '',
        'InvokerType %s is not registered' => '',
        'MappingType %s is not registered' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceInvokerEvent.pm
        'Need Invoker!' => '',
        'Need Event!' => '',
        'Could not get registered modules for Invoker' => '',
        'Could not get backend for Invoker %s' => '',
        'The event %s is not valid.' => '',
        'Could not update configuration data for WebserviceID %s' => '',
        'This sub-action is not valid' => '',
        'xor' => 'xor',
        'String' => 'Ciąg',
        'Regexp' => '',
        'Validation Module' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceMappingSimple.pm
        'Simple Mapping for Outgoing Data' => '',
        'Simple Mapping for Incoming Data' => '',
        'Could not get registered configuration for action type %s' => '',
        'Could not get backend for %s %s' => '',
        'Keep (leave unchanged)' => '',
        'Ignore (drop key/value pair)' => '',
        'Map to (use provided value as default)' => '',
        'Exact value(s)' => '',
        'Ignore (drop Value/value pair)' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceMappingXSLT.pm
        'XSLT Mapping for Outgoing Data' => '',
        'XSLT Mapping for Incoming Data' => '',
        'Could not find required library %s' => '',
        'Outgoing request data before processing (RequesterRequestInput)' =>
            '',
        'Outgoing request data before mapping (RequesterRequestPrepareOutput)' =>
            '',
        'Outgoing request data after mapping (RequesterRequestMapOutput)' =>
            '',
        'Incoming response data before mapping (RequesterResponseInput)' =>
            '',
        'Outgoing error handler data after error handling (RequesterErrorHandlingOutput)' =>
            '',
        'Incoming request data before mapping (ProviderRequestInput)' => '',
        'Incoming request data after mapping (ProviderRequestMapOutput)' =>
            '',
        'Outgoing response data before mapping (ProviderResponseInput)' =>
            '',
        'Outgoing error handler data after error handling (ProviderErrorHandlingOutput)' =>
            '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceOperationDefault.pm
        'Could not determine config for operation %s' => '',
        'OperationType %s is not registered' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceTransportHTTPREST.pm
        'Need valid Subaction!' => '',
        'This field should be an integer.' => '',
        'File or Directory not found.' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceWebservice.pm
        'There is another web service with the same name.' => '',
        'There was an error updating the web service.' => '',
        'There was an error creating the web service.' => '',
        'Web service "%s" created!' => '',
        'Need Name!' => 'Wymagana nazwa!',
        'Need ExampleWebService!' => '',
        'Could not load %s.' => '',
        'Could not read %s!' => '',
        'Need a file to import!' => 'Wymagany plik do zaimportowania!',
        'The imported file has not valid YAML content! Please check OTRS log for details' =>
            '',
        'Web service "%s" deleted!' => '',
        'OTRS as provider' => 'OTRS jako usługodawca',
        'Operations' => 'Operacje',
        'OTRS as requester' => 'OTRS jako wnioskujący',
        'Invokers' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceWebserviceHistory.pm
        'Got no WebserviceHistoryID!' => '',
        'Could not get history data for WebserviceHistoryID %s' => '',

        # Perl Module: Kernel/Modules/AdminGroup.pm
        'Group updated!' => 'Grupa zaktualizowana!',

        # Perl Module: Kernel/Modules/AdminMailAccount.pm
        'Mail account added!' => 'Konto pocztowe dodane!',
        'Email account fetch already fetched by another process. Please try again later!' =>
            '',
        'Dispatching by email To: field.' => 'Przydzielaj na podstawie pola DO:',
        'Dispatching by selected Queue.' => 'Przydzielaj na podstawie wybranej kolejki.',

        # Perl Module: Kernel/Modules/AdminNotificationEvent.pm
        'Agent who created the ticket' => 'Agent który utworzył zgłoszenie',
        'Agent who owns the ticket' => 'Agent który jest właścicielem zgłoszenia',
        'Agent who is responsible for the ticket' => 'Agent który jest odpowiedzialny za zgłoszenie',
        'All agents watching the ticket' => 'Wszyscy Agenci którzy obserwują zgłoszenie',
        'All agents with write permission for the ticket' => 'Wszyscy agenci z prawami do zapisu w zgłoszeniu',
        'All agents subscribed to the ticket\'s queue' => '',
        'All agents subscribed to the ticket\'s service' => '',
        'All agents subscribed to both the ticket\'s queue and service' =>
            '',
        'Customer user of the ticket' => 'Użytkownik klienta w tym zgłoszeniu',
        'All recipients of the first article' => '',
        'All recipients of the last article' => '',
        'Invisible to customer' => '',
        'Visible to customer' => '',

        # Perl Module: Kernel/Modules/AdminOTRSBusiness.pm
        'Your system was successfully upgraded to %s.' => 'Z powodzeniem zaktualizowano system do %s.',
        'There was a problem during the upgrade to %s.' => 'Wystąpił problem z aktualizacją do %s.',
        '%s was correctly reinstalled.' => '%s było poprawnie przeinstalowane.',
        'There was a problem reinstalling %s.' => 'Wystąpił problem z przeinstalowaniem %s.',
        'Your %s was successfully updated.' => 'Twój %s został zaktualizowany z powodzeniem.',
        'There was a problem during the upgrade of %s.' => 'Wystąpił problem podczas aktualizacji %s.',
        '%s was correctly uninstalled.' => '%s został poprawnie odinstalowany.',
        'There was a problem uninstalling %s.' => 'Wystąpił problem z odinstalowaniem %s.',

        # Perl Module: Kernel/Modules/AdminPGP.pm
        'PGP environment is not working. Please check log for more info!' =>
            '',
        'Need param Key to delete!' => '',
        'Key %s deleted!' => 'Klucz %s usunięty!',
        'Need param Key to download!' => '',

        # Perl Module: Kernel/Modules/AdminPackageManager.pm
        'Sorry, Apache::Reload is needed as PerlModule and PerlInitHandler in Apache config file. See also scripts/apache2-httpd.include.conf. Alternatively, you can use the command line tool bin/otrs.Console.pl to install packages!' =>
            '',
        'No such package!' => '',
        'No such file %s in package!' => '',
        'No such file %s in local file system!' => '',
        'Can\'t read %s!' => 'Nie można odczytać %s!',
        'File is OK' => 'Plik jest OK',
        'Package has locally modified files.' => '',
        'Package not verified by the OTRS Group! It is recommended not to use this package.' =>
            'Pakiet nie został zweryfikowany przez Grupę OTRS! Zalecamy nie korzystanie z tego pakietu.',
        'Not Started' => '',
        'Updated' => '',
        'Already up-to-date' => '',
        'Installed' => 'Zainstalowane',
        'Not correctly deployed' => 'Niepoprawnie wdrożone',
        'Package updated correctly' => '',
        'Package was already updated' => '',
        'Dependency installed correctly' => '',
        'The package needs to be reinstalled' => '',
        'The package contains cyclic dependencies' => '',
        'Not found in on-line repositories' => 'Nie znaleziono w repozytoriach on-line',
        'Required version is higher than available' => '',
        'Dependencies fail to upgrade or install' => '',
        'Package could not be installed' => '',
        'Package could not be upgraded' => '',
        'Repository List' => 'Lista Repezytoriów',
        'No packages found in selected repository. Please check log for more info!' =>
            '',
        'Package not verified due a communication issue with verification server!' =>
            '',
        'Can\'t connect to OTRS Feature Add-on list server!' => '',
        'Can\'t get OTRS Feature Add-on list from server!' => '',
        'Can\'t get OTRS Feature Add-on from server!' => '',

        # Perl Module: Kernel/Modules/AdminPostMasterFilter.pm
        'No such filter: %s' => '',

        # Perl Module: Kernel/Modules/AdminPriority.pm
        'Priority added!' => 'Dodano priorytet!',

        # Perl Module: Kernel/Modules/AdminProcessManagement.pm
        'Process Management information from database is not in sync with the system configuration, please synchronize all processes.' =>
            'Informacje zarządzania procesami z bazy danych nie są zsynchronizowane z konfiguracją systemu, zsynchronizuj wszystkie procesy.',
        'Need ExampleProcesses!' => '',
        'Need ProcessID!' => 'Potrzebny ProcessID!',
        'Yes (mandatory)' => 'Tak (obowiązkowo)',
        'Unknown Process %s!' => 'Nieznany Proces %s!',
        'There was an error generating a new EntityID for this Process' =>
            '',
        'The StateEntityID for state Inactive does not exists' => 'Nie istnieje identyfikator stanu "nieaktywny"',
        'There was an error creating the Process' => '',
        'There was an error setting the entity sync status for Process entity: %s' =>
            '',
        'Could not get data for ProcessID %s' => '',
        'There was an error updating the Process' => '',
        'Process: %s could not be deleted' => 'Proces: %s nie może być usunięty',
        'There was an error synchronizing the processes.' => '',
        'The %s:%s is still in use' => '%s:%s jest cały czas w użyciu',
        'The %s:%s has a different EntityID' => '%s:%s mają inne EtnityID',
        'Could not delete %s:%s' => 'Nie można usunąć %s:%s',
        'There was an error setting the entity sync status for %s entity: %s' =>
            '',
        'Could not get %s' => 'Nie można pobrać %s',
        'Need %s!' => 'Potrzebny %s!',
        'Process: %s is not Inactive' => 'Proces: %s jest nie aktywny',

        # Perl Module: Kernel/Modules/AdminProcessManagementActivity.pm
        'There was an error generating a new EntityID for this Activity' =>
            '',
        'There was an error creating the Activity' => '',
        'There was an error setting the entity sync status for Activity entity: %s' =>
            '',
        'Need ActivityID!' => 'Potrzebny ActivityID!',
        'Could not get data for ActivityID %s' => '',
        'There was an error updating the Activity' => '',
        'Missing Parameter: Need Activity and ActivityDialog!' => '',
        'Activity not found!' => '',
        'ActivityDialog not found!' => '',
        'ActivityDialog already assigned to Activity. You cannot add an ActivityDialog twice!' =>
            '',
        'Error while saving the Activity to the database!' => '',
        'This subaction is not valid' => 'Działanie podrzędne jest nieprawidłowe',
        'Edit Activity "%s"' => '',

        # Perl Module: Kernel/Modules/AdminProcessManagementActivityDialog.pm
        'There was an error generating a new EntityID for this ActivityDialog' =>
            '',
        'There was an error creating the ActivityDialog' => '',
        'There was an error setting the entity sync status for ActivityDialog entity: %s' =>
            '',
        'Need ActivityDialogID!' => '',
        'Could not get data for ActivityDialogID %s' => '',
        'There was an error updating the ActivityDialog' => '',
        'Edit Activity Dialog "%s"' => '',
        'Agent Interface' => 'Interfejs Agenta',
        'Customer Interface' => 'Interfejs klienta',
        'Agent and Customer Interface' => 'Interfejs Klienta i Agenta',
        'Do not show Field' => 'Nie pokazuj pola',
        'Show Field' => 'Pokaż pole.',
        'Show Field As Mandatory' => 'Pokaż pole jako wymagane',

        # Perl Module: Kernel/Modules/AdminProcessManagementPath.pm
        'Edit Path' => 'Zmień Ścieżkę',

        # Perl Module: Kernel/Modules/AdminProcessManagementTransition.pm
        'There was an error generating a new EntityID for this Transition' =>
            '',
        'There was an error creating the Transition' => '',
        'There was an error setting the entity sync status for Transition entity: %s' =>
            '',
        'Need TransitionID!' => '',
        'Could not get data for TransitionID %s' => '',
        'There was an error updating the Transition' => '',
        'Edit Transition "%s"' => '',
        'Transition validation module' => '',

        # Perl Module: Kernel/Modules/AdminProcessManagementTransitionAction.pm
        'At least one valid config parameter is required.' => '',
        'There was an error generating a new EntityID for this TransitionAction' =>
            '',
        'There was an error creating the TransitionAction' => '',
        'There was an error setting the entity sync status for TransitionAction entity: %s' =>
            '',
        'Need TransitionActionID!' => '',
        'Could not get data for TransitionActionID %s' => '',
        'There was an error updating the TransitionAction' => '',
        'Edit Transition Action "%s"' => '',
        'Error: Not all keys seem to have values or vice versa.' => '',

        # Perl Module: Kernel/Modules/AdminQueue.pm
        'Queue updated!' => 'Kolejka zaktualizowana!',
        'Don\'t use :: in queue name!' => 'Nie używaj :: w nazwie kolejki!',
        'Click back and change it!' => 'Naciśnij powrót i zmień to!',
        '-none-' => '-brak-',

        # Perl Module: Kernel/Modules/AdminQueueAutoResponse.pm
        'Queues ( without auto responses )' => 'Kolejki (bez automatycznych odpowiedzi)',

        # Perl Module: Kernel/Modules/AdminQueueTemplates.pm
        'Change Queue Relations for Template' => 'Zmień relacje kolejki dla szablonu',
        'Change Template Relations for Queue' => 'Zmień relacje szablonu dla kolejki',

        # Perl Module: Kernel/Modules/AdminRegistration.pm
        'Production' => 'Produkcja',
        'Test' => '',
        'Training' => 'Trening',
        'Development' => '',

        # Perl Module: Kernel/Modules/AdminRole.pm
        'Role updated!' => 'Rola zaktualizowana!',
        'Role added!' => 'Rola dodana!',

        # Perl Module: Kernel/Modules/AdminRoleGroup.pm
        'Change Group Relations for Role' => 'Zmień relacje grup do roli',
        'Change Role Relations for Group' => 'Zmień relacje ról do grupy',

        # Perl Module: Kernel/Modules/AdminRoleUser.pm
        'Role' => 'Rola',
        'Change Role Relations for Agent' => 'Zmień relacje ról do agenta',
        'Change Agent Relations for Role' => 'Zmień relacje agentów do roli',

        # Perl Module: Kernel/Modules/AdminSLA.pm
        'Please activate %s first!' => 'Najpierw aktywuj %s',

        # Perl Module: Kernel/Modules/AdminSMIME.pm
        'S/MIME environment is not working. Please check log for more info!' =>
            '',
        'Need param Filename to delete!' => '',
        'Need param Filename to download!' => '',
        'Needed CertFingerprint and CAFingerprint!' => '',
        'CAFingerprint must be different than CertFingerprint' => '',
        'Relation exists!' => 'Relacja istnieje!',
        'Relation added!' => 'Relacja dodana!',
        'Impossible to add relation!' => '',
        'Relation doesn\'t exists' => 'Relacja nie istnieje',
        'Relation deleted!' => 'Relacja usunięta!',
        'Impossible to delete relation!' => '',
        'Certificate %s could not be read!' => '',
        'Needed Fingerprint' => '',
        'Handle Private Certificate Relations' => '',

        # Perl Module: Kernel/Modules/AdminSalutation.pm
        'Salutation added!' => 'Powitanie dodane!',

        # Perl Module: Kernel/Modules/AdminSignature.pm
        'Signature updated!' => 'Zaktualizowano podpis!',
        'Signature added!' => 'Dodano podpis!',

        # Perl Module: Kernel/Modules/AdminState.pm
        'State added!' => 'Stan dodany!',

        # Perl Module: Kernel/Modules/AdminSupportDataCollector.pm
        'File %s could not be read!' => 'Plik %s nie mógł zostać odczytany!',

        # Perl Module: Kernel/Modules/AdminSystemAddress.pm
        'System e-mail address added!' => 'Systemowy adres e-mail dodany!',

        # Perl Module: Kernel/Modules/AdminSystemConfiguration.pm
        'Invalid Settings' => '',
        'There are no invalid settings active at this time.' => '',
        'You currently don\'t have any favourite settings.' => '',
        'The following settings could not be found: %s' => '',
        'Import not allowed!' => 'Import niedozwolony!',
        'System Configuration could not be imported due to an unknown error, please check OTRS logs for more information.' =>
            '',
        'Category Search' => '',

        # Perl Module: Kernel/Modules/AdminSystemConfigurationDeployment.pm
        'Some imported settings are not present in the current state of the configuration or it was not possible to update them. Please check the OTRS log for more information.' =>
            '',

        # Perl Module: Kernel/Modules/AdminSystemConfigurationGroup.pm
        'You need to enable the setting before locking!' => '',
        'You can\'t work on this setting because %s (%s) is currently working on it.' =>
            '',
        'Missing setting name!' => '',
        'Missing ResetOptions!' => '',
        'Setting is locked by another user!' => '',
        'System was not able to lock the setting!' => '',
        'System was not able to reset the setting!' => '',
        'System was unable to update setting!' => '',
        'Missing setting name.' => '',
        'Setting not found.' => '',
        'Missing Settings!' => '',

        # Perl Module: Kernel/Modules/AdminSystemMaintenance.pm
        'Start date shouldn\'t be defined after Stop date!' => '',
        'There was an error creating the System Maintenance' => '',
        'Need SystemMaintenanceID!' => '',
        'Could not get data for SystemMaintenanceID %s' => '',
        'System Maintenance was added successfully!' => '',
        'System Maintenance was updated successfully!' => '',
        'Session has been killed!' => 'Sesja została zabita!',
        'All sessions have been killed, except for your own.' => 'Zakończono wszystkie aktywne sesje za wyjątkiem bieżącej.',
        'There was an error updating the System Maintenance' => '',
        'Was not possible to delete the SystemMaintenance entry: %s!' => '',

        # Perl Module: Kernel/Modules/AdminTemplate.pm
        'Template updated!' => 'Szablon zmieniony!',
        'Template added!' => 'Szablon dodany!',

        # Perl Module: Kernel/Modules/AdminTemplateAttachment.pm
        'Change Attachment Relations for Template' => 'Zmień relacje załącznika dla szablonu',
        'Change Template Relations for Attachment' => 'Zmień relacje szablonu dla załącznika',

        # Perl Module: Kernel/Modules/AdminType.pm
        'Need Type!' => 'Potrzebny Typ!',
        'Type added!' => 'Typ dodany!',

        # Perl Module: Kernel/Modules/AdminUser.pm
        'Agent updated!' => 'Agent został zaktualizowany!',

        # Perl Module: Kernel/Modules/AdminUserGroup.pm
        'Change Group Relations for Agent' => 'Zmień relacje grup do agenta',
        'Change Agent Relations for Group' => 'Zmień relacje agentów do grupy',

        # Perl Module: Kernel/Modules/AgentAppointmentAgendaOverview.pm
        'Month' => 'Miesiąc',
        'Week' => 'Tydzień',
        'Day' => 'Dzień',

        # Perl Module: Kernel/Modules/AgentAppointmentCalendarOverview.pm
        'All appointments' => 'Wszystkie wydarzenia',
        'Appointments assigned to me' => 'Wydarzenia przypisane do mnie',
        'Showing only appointments assigned to you! Change settings' => 'Wyświetlanie wydarzeń przypisanych do Ciebie! Zmień ustawienia',

        # Perl Module: Kernel/Modules/AgentAppointmentEdit.pm
        'Appointment not found!' => 'Wydarzenie nie odnalezione!',
        'Never' => 'Nigdy',
        'Every Day' => 'Codziennie',
        'Every Week' => 'Co tydzeń',
        'Every Month' => 'Co miesiąc',
        'Every Year' => 'Co rok',
        'Custom' => 'Własne',
        'Daily' => 'Dziennie',
        'Weekly' => 'Tygodniowo',
        'Monthly' => 'Miesięcznie',
        'Yearly' => 'Rocznie',
        'every' => 'każde',
        'for %s time(s)' => '',
        'until ...' => 'dopóki ...',
        'for ... time(s)' => '',
        'until %s' => 'aż do %s',
        'No notification' => 'Brak powiadomień',
        '%s minute(s) before' => '%s minut(y) przed',
        '%s hour(s) before' => '%s godzin(y) przed',
        '%s day(s) before' => '%s dni(dzień) przed',
        '%s week before' => '%s tygodnie przed',
        'before the appointment starts' => 'zanim wydarzenie rozpocznie się',
        'after the appointment has been started' => 'po rozpoczęciu wydarzeniu',
        'before the appointment ends' => 'przed zakończeniem wydarzenia',
        'after the appointment has been ended' => 'po zakończeniu wydarzenia',
        'No permission!' => 'Brak uprawnień!',
        'Cannot delete ticket appointment!' => 'Nie można usunąć wydarzenia dla zgłoszenia!',
        'No permissions!' => 'Brak uprawnień!',

        # Perl Module: Kernel/Modules/AgentAppointmentList.pm
        '+%s more' => '+ %s więcej',

        # Perl Module: Kernel/Modules/AgentCustomerSearch.pm
        'Customer History' => 'Historia Klienta',

        # Perl Module: Kernel/Modules/AgentCustomerUserAddressBook.pm
        'No RecipientField is given!' => '',

        # Perl Module: Kernel/Modules/AgentDashboardCommon.pm
        'No such config for %s' => '',
        'Statistic' => 'Statystyka',
        'No preferences for %s!' => '',
        'Can\'t get element data of %s!' => '',
        'Can\'t get filter content data of %s!' => '',
        'Customer Name' => 'Nazwa klienta',
        'Customer User Name' => 'Nazwa użytkownika klienta',

        # Perl Module: Kernel/Modules/AgentLinkObject.pm
        'Need SourceObject and SourceKey!' => '',
        'You need ro permission!' => 'Potrzebujesz uprawnień do odczytu!',
        'Can not delete link with %s!' => 'Nie można usunąć połączenia z %s!',
        '%s Link(s) deleted successfully.' => '%s Połączenie (a) usunięte pomyślnie.',
        'Can not create link with %s! Object already linked as %s.' => 'Nie można utworzyć łączenia z %s! Już połączono jako %s.',
        'Can not create link with %s!' => 'Nie można stworzyć połączenia z %s!',
        '%s links added successfully.' => '%s połączenie dodane pomyślnie.',
        'The object %s cannot link with other object!' => 'Obiekt %s nie może być połączony z innym obiektem!',

        # Perl Module: Kernel/Modules/AgentPreferences.pm
        'Param Group is required!' => '',
        'Updated user preferences' => '',
        'System was unable to deploy your changes.' => 'System nie mógł wdrożyć twoich zmian.',
        'Setting not found!' => '',
        'System was unable to reset the setting!' => '',

        # Perl Module: Kernel/Modules/AgentSplitSelection.pm
        'Process ticket' => 'Zgłoszenie procesowe',

        # Perl Module: Kernel/Modules/AgentStatistics.pm
        'Parameter %s is missing.' => 'Brak parametru %s',
        'Invalid Subaction.' => 'Nieprawidłowe działanie podrzędne.',
        'Statistic could not be imported.' => '',
        'Please upload a valid statistic file.' => '',
        'Export: Need StatID!' => '',
        'Delete: Get no StatID!' => '',
        'Need StatID!' => '',
        'Could not load stat.' => '',
        'Add New Statistic' => 'Dodaj nowe statystyki',
        'Could not create statistic.' => '',
        'Run: Get no %s!' => '',

        # Perl Module: Kernel/Modules/AgentTicketActionCommon.pm
        'No TicketID is given!' => '',
        'You need %s permissions!' => 'Potrzebujesz uprawnień do %s !',
        'Loading draft failed!' => 'Nieudane wczytanie szkicu!',
        'Sorry, you need to be the ticket owner to perform this action.' =>
            'Przykro mi, musisz być właścicielem zgłoszenia aby wykonać tę operację.',
        'Please change the owner first.' => 'Najpierw zmień właściciela.',
        'FormDraft functionality disabled!' => '',
        'Draft name is required!' => 'Nazwa szkicu jest wymagana!',
        'FormDraft name %s is already in use!' => '',
        'Could not perform validation on field %s!' => '',
        'No subject' => 'Brak tematu',
        'Could not delete draft!' => 'Nie można usunąć szkicu!',
        'Previous Owner' => 'Poprzedni właściciel',
        'wrote' => 'napisał(a)',
        'Message from' => 'Wiadomość od',
        'End message' => 'Wiadomość kończąca',

        # Perl Module: Kernel/Modules/AgentTicketBounce.pm
        '%s is needed!' => '%s jest potrzebny!',
        'Plain article not found for article %s!' => '',
        'Article does not belong to ticket %s!' => '',
        'Can\'t bounce email!' => 'Nie można odbić email\'a!',
        'Can\'t send email!' => 'Nie można wysłać email\'a!',
        'Wrong Subaction!' => 'Złe działanie podrzędne!',

        # Perl Module: Kernel/Modules/AgentTicketBulk.pm
        'Can\'t lock Tickets, no TicketIDs are given!' => 'Nie można zablokować zgłoszeń, nie podano TicketID.',
        'Ticket (%s) is not unlocked!' => 'Zgłoszenie (%s) nie jest odblokowane!',
        'The following tickets were ignored because they are locked by another agent or you don\'t have write access to tickets: %s.' =>
            '',
        'The following ticket was ignored because it is locked by another agent or you don\'t have write access to ticket: %s.' =>
            '',
        'You need to select at least one ticket.' => 'Musisz zaznaczyć przynajmniej jedno zgłoszenie.',
        'Bulk feature is not enabled!' => '',
        'No selectable TicketID is given!' => '',
        'You either selected no ticket or only tickets which are locked by other agents.' =>
            '',
        'The following tickets were ignored because they are locked by another agent or you don\'t have write access to these tickets: %s.' =>
            'Następujące zgłoszenia zostały zignorowane ponieważ albo są zablokowane przez innego agenta, albo nie masz praw zapisu do tych zgłoszeń: %s.',
        'The following tickets were locked: %s.' => '',

        # Perl Module: Kernel/Modules/AgentTicketCompose.pm
        'Article subject will be empty if the subject contains only the ticket hook!' =>
            '',
        'Address %s replaced with registered customer address.' => 'Adres %s zastąpiony zarejestrowanym adresem klienta.',
        'Customer user automatically added in Cc.' => 'Użytkownik automatycznie dodany jako DW (Cc).',

        # Perl Module: Kernel/Modules/AgentTicketEmail.pm
        'Ticket "%s" created!' => 'Zgłoszenie "%s" utworzone!',
        'No Subaction!' => 'Brak działania podrzędnego!',

        # Perl Module: Kernel/Modules/AgentTicketEmailOutbound.pm
        'Got no TicketID!' => '',
        'System Error!' => 'Błąd systemu!',

        # Perl Module: Kernel/Modules/AgentTicketEmailResend.pm
        'No ArticleID is given!' => '',

        # Perl Module: Kernel/Modules/AgentTicketEscalationView.pm
        'Next week' => 'Następny tydzień',
        'Ticket Escalation View' => 'Widok eskalowanych zgłoszeń',

        # Perl Module: Kernel/Modules/AgentTicketForward.pm
        'Article %s could not be found!' => '',
        'Forwarded message from' => 'Wiadomość przekazana od',
        'End forwarded message' => 'Wiadomość kończąca przekazana od',

        # Perl Module: Kernel/Modules/AgentTicketHistory.pm
        'Can\'t show history, no TicketID is given!' => '',

        # Perl Module: Kernel/Modules/AgentTicketLock.pm
        'Can\'t lock Ticket, no TicketID is given!' => '',
        'Sorry, the current owner is %s!' => 'Przykro mi, aktualnym właścicielem jest %s!',
        'Please become the owner first.' => '',
        'Ticket (ID=%s) is locked by %s!' => '',
        'Change the owner!' => 'Zmień właściciela!',

        # Perl Module: Kernel/Modules/AgentTicketLockedView.pm
        'New Article' => 'Nowa wiadomość',
        'Pending' => 'Oczekujące',
        'Reminder Reached' => 'Przypomnienie',
        'My Locked Tickets' => 'Moje zablokowane zgłoszenia',

        # Perl Module: Kernel/Modules/AgentTicketMerge.pm
        'Can\'t merge ticket with itself!' => '',

        # Perl Module: Kernel/Modules/AgentTicketMove.pm
        'You need move permissions!' => 'Wymaga uprawnień do przenoszenia!',

        # Perl Module: Kernel/Modules/AgentTicketPhone.pm
        'Chat is not active.' => 'Czat jest nieaktywny.',
        'No permission.' => 'Brak uprawnień!',
        '%s has left the chat.' => '%s opuścił czat.',
        'This chat has been closed and will be removed in %s hours.' => 'Ten czat został zamknięty i będzie usunięty w ciągu %sgodzin.',

        # Perl Module: Kernel/Modules/AgentTicketPhoneCommon.pm
        'Ticket locked.' => 'Zgłoszenie zablokowane.',

        # Perl Module: Kernel/Modules/AgentTicketPlain.pm
        'No ArticleID!' => '',
        'This is not an email article.' => '',
        'Can\'t read plain article! Maybe there is no plain email in backend! Read backend message.' =>
            '',

        # Perl Module: Kernel/Modules/AgentTicketPrint.pm
        'Need TicketID!' => '',

        # Perl Module: Kernel/Modules/AgentTicketProcess.pm
        'Couldn\'t get ActivityDialogEntityID "%s"!' => '',
        'No Process configured!' => 'Żaden proces nie został jeszcze skonfigurowany!',
        'The selected process is invalid!' => 'Wybrany proces jest nieprawidłowy!',
        'Process %s is invalid!' => '',
        'Subaction is invalid!' => 'Działanie podrzędne jest nieprawidłowe!',
        'Parameter %s is missing in %s.' => '',
        'No ActivityDialog configured for %s in _RenderAjax!' => '',
        'Got no Start ActivityEntityID or Start ActivityDialogEntityID for Process: %s in _GetParam!' =>
            '',
        'Couldn\'t get Ticket for TicketID: %s in _GetParam!' => '',
        'Couldn\'t determine ActivityEntityID. DynamicField or Config isn\'t set properly!' =>
            '',
        'Process::Default%s Config Value missing!' => '',
        'Got no ProcessEntityID or TicketID and ActivityDialogEntityID!' =>
            '',
        'Can\'t get StartActivityDialog and StartActivityDialog for the ProcessEntityID "%s"!' =>
            '',
        'Can\'t get Ticket "%s"!' => '',
        'Can\'t get ProcessEntityID or ActivityEntityID for Ticket "%s"!' =>
            '',
        'Can\'t get Activity configuration for ActivityEntityID "%s"!' =>
            '',
        'Can\'t get ActivityDialog configuration for ActivityDialogEntityID "%s"!' =>
            '',
        'Can\'t get data for Field "%s" of ActivityDialog "%s"!' => '',
        'PendingTime can just be used if State or StateID is configured for the same ActivityDialog. ActivityDialog: %s!' =>
            '',
        'Pending Date' => 'Termin oczekiwania',
        'for pending* states' => 'dla stanów oczekujących*',
        'ActivityDialogEntityID missing!' => '',
        'Couldn\'t get Config for ActivityDialogEntityID "%s"!' => '',
        'Couldn\'t use CustomerID as an invisible field.' => '',
        'Missing ProcessEntityID, check your ActivityDialogHeader.tt!' =>
            '',
        'No StartActivityDialog or StartActivityDialog for Process "%s" configured!' =>
            '',
        'Couldn\'t create ticket for Process with ProcessEntityID "%s"!' =>
            '',
        'Couldn\'t set ProcessEntityID "%s" on TicketID "%s"!' => '',
        'Couldn\'t set ActivityEntityID "%s" on TicketID "%s"!' => '',
        'Could not store ActivityDialog, invalid TicketID: %s!' => '',
        'Invalid TicketID: %s!' => '',
        'Missing ActivityEntityID in Ticket %s!' => '',
        'This step does not belong anymore to the current activity in process for ticket \'%s%s%s\'! Another user changed this ticket in the meantime. Please close this window and reload the ticket.' =>
            '',
        'Missing ProcessEntityID in Ticket %s!' => '',
        'Could not set DynamicField value for %s of Ticket with ID "%s" in ActivityDialog "%s"!' =>
            '',
        'Could not set PendingTime for Ticket with ID "%s" in ActivityDialog "%s"!' =>
            '',
        'Wrong ActivityDialog Field config: %s can\'t be Display => 1 / Show field (Please change its configuration to be Display => 0 / Do not show field or Display => 2 / Show field as mandatory)!' =>
            '',
        'Could not set %s for Ticket with ID "%s" in ActivityDialog "%s"!' =>
            '',
        'Default Config for Process::Default%s missing!' => '',
        'Default Config for Process::Default%s invalid!' => '',

        # Perl Module: Kernel/Modules/AgentTicketQueue.pm
        'Available tickets' => 'Dostępne zgłoszenia',
        'including subqueues' => 'włączając podkolejki',
        'excluding subqueues' => 'wyłączając podkolejki',
        'QueueView' => 'Widok kolejek',

        # Perl Module: Kernel/Modules/AgentTicketResponsibleView.pm
        'My Responsible Tickets' => 'Zgłoszenia, za które jestem odpowiedzialny',

        # Perl Module: Kernel/Modules/AgentTicketSearch.pm
        'last-search' => 'ostatnie wyszukiwanie',
        'Untitled' => 'Bez tytułu',
        'Ticket Number' => 'Numer zgłoszenia',
        'Ticket' => 'Zgłoszenie',
        'printed by' => 'Wydrukowane przez',
        'CustomerID (complex search)' => 'ID klienta (wyszukiwanie złożone)',
        'CustomerID (exact match)' => 'ID klienta (dokładne dopasowanie)',
        'Invalid Users' => 'Nieprawidłowi użytkownicy',
        'Normal' => 'Normalne',
        'CSV' => 'CSV',
        'Excel' => '',
        'in more than ...' => 'później niż ...',

        # Perl Module: Kernel/Modules/AgentTicketService.pm
        'Feature not enabled!' => '',
        'Service View' => 'Przegląd usług',

        # Perl Module: Kernel/Modules/AgentTicketStatusView.pm
        'Status View' => 'Podgląd stanów',

        # Perl Module: Kernel/Modules/AgentTicketWatchView.pm
        'My Watched Tickets' => 'Moje obserwowane zgłoszenia',

        # Perl Module: Kernel/Modules/AgentTicketWatcher.pm
        'Feature is not active' => '',

        # Perl Module: Kernel/Modules/AgentTicketZoom.pm
        'Link Deleted' => '',
        'Ticket Locked' => 'Zagłoszenie zablokowane',
        'Pending Time Set' => '',
        'Dynamic Field Updated' => 'Pole Dynamiczne Zaktualizowane',
        'Outgoing Email (internal)' => '',
        'Ticket Created' => 'Zgłoszenie Utworzone',
        'Type Updated' => '',
        'Escalation Update Time In Effect' => '',
        'Escalation Update Time Stopped' => '',
        'Escalation First Response Time Stopped' => '',
        'Customer Updated' => 'Klient zaktualizowany',
        'Internal Chat' => 'Czat wewnętrzny',
        'Automatic Follow-Up Sent' => '',
        'Note Added' => 'Uwaga Dodana',
        'Note Added (Customer)' => 'Notatka doana (klient)',
        'SMS Added' => '',
        'SMS Added (Customer)' => '',
        'State Updated' => 'Stan Zaktualizowany',
        'Outgoing Answer' => 'Odpowiedź Wychodząca',
        'Service Updated' => 'Usługa Zaktualizowana',
        'Link Added' => '',
        'Incoming Customer Email' => ' Wiadomość od klienta',
        'Incoming Web Request' => '',
        'Priority Updated' => '',
        'Ticket Unlocked' => '',
        'Outgoing Email' => 'Wiadomość Wychodząca',
        'Title Updated' => 'Tytuł został zaktualizowany',
        'Ticket Merged' => '',
        'Outgoing Phone Call' => 'Telefon Wychodzący',
        'Forwarded Message' => '',
        'Removed User Subscription' => '',
        'Time Accounted' => '',
        'Incoming Phone Call' => 'Telefon Przychodzący',
        'System Request.' => '',
        'Incoming Follow-Up' => '',
        'Automatic Reply Sent' => '',
        'Automatic Reject Sent' => '',
        'Escalation Solution Time In Effect' => '',
        'Escalation Solution Time Stopped' => '',
        'Escalation Response Time In Effect' => '',
        'Escalation Response Time Stopped' => '',
        'SLA Updated' => 'SLA Zaktualizowane',
        'External Chat' => 'Czat zewnętrzny',
        'Queue Changed' => '',
        'Notification Was Sent' => '',
        'This ticket does not exist, or you don\'t have permissions to access it in its current state.' =>
            '',
        'Missing FormDraftID!' => '',
        'Can\'t get for ArticleID %s!' => '',
        'Article filter settings were saved.' => '',
        'Event type filter settings were saved.' => '',
        'Need ArticleID!' => '',
        'Invalid ArticleID!' => '',
        'Forward article via mail' => 'Prześlij wiadomość dalej przez e-mail',
        'Forward' => 'Prześlij dalej',
        'Fields with no group' => '',
        'Invisible only' => 'Tylko niewidoczne',
        'Visible only' => 'Tylko widoczne',
        'Visible and invisible' => 'Widoczne i niewidoczne',
        'Article could not be opened! Perhaps it is on another article page?' =>
            'Wiadomość nie może być otwarta! Być może znajduje się na innej stronie wiadomości.',
        'Show one article' => 'Pokaż tylko jedną wiadomość',
        'Show all articles' => 'Pokaż wszystkie wiadomości',
        'Show Ticket Timeline View' => 'Pokaż podgląd linii czasu zgłoszenia',
        'Show Ticket Timeline View (%s)' => '',

        # Perl Module: Kernel/Modules/AjaxAttachment.pm
        'Got no FormID.' => '',
        'Error: the file could not be deleted properly. Please contact your administrator (missing FileID).' =>
            '',

        # Perl Module: Kernel/Modules/CustomerTicketArticleContent.pm
        'ArticleID is needed!' => '',
        'No TicketID for ArticleID (%s)!' => '',
        'HTML body attachment is missing!' => '',

        # Perl Module: Kernel/Modules/CustomerTicketAttachment.pm
        'FileID and ArticleID are needed!' => '',
        'No such attachment (%s)!' => '',

        # Perl Module: Kernel/Modules/CustomerTicketMessage.pm
        'Check SysConfig setting for %s::QueueDefault.' => '',
        'Check SysConfig setting for %s::TicketTypeDefault.' => '',
        'You don\'t have sufficient permissions for ticket creation in default queue.' =>
            '',

        # Perl Module: Kernel/Modules/CustomerTicketOverview.pm
        'Need CustomerID!' => 'Potrzebne ID Klienta!',
        'My Tickets' => 'Moje zgłoszenia',
        'Company Tickets' => 'Zgłoszenia firmy',
        'Untitled!' => 'Bez tytułu!',

        # Perl Module: Kernel/Modules/CustomerTicketSearch.pm
        'Customer Realname' => 'Prawdziwe nazwisko klienta',
        'Created within the last' => 'Utworzone w ciągu ostatniego(-ich)',
        'Created more than ... ago' => 'Utworzone wcześniej niż ...',
        'Please remove the following words because they cannot be used for the search:' =>
            '',

        # Perl Module: Kernel/Modules/CustomerTicketZoom.pm
        'Can\'t reopen ticket, not possible in this queue!' => '',
        'Create a new ticket!' => 'Utwórz nowe zgłoszenie!',

        # Perl Module: Kernel/Modules/Installer.pm
        'SecureMode active!' => '',
        'If you want to re-run the Installer, disable the SecureMode in the SysConfig.' =>
            '',
        'Directory "%s" doesn\'t exist!' => '',
        'Configure "Home" in Kernel/Config.pm first!' => '',
        'File "%s/Kernel/Config.pm" not found!' => '',
        'Directory "%s" not found!' => 'Katalog "%s" nie został znaleziony!',
        'Install OTRS' => 'Zainstaluj OTRS',
        'Intro' => 'Wprowadzenie',
        'Kernel/Config.pm isn\'t writable!' => 'Kernel/Config.pm nie jest zapisywalny!',
        'If you want to use the installer, set the Kernel/Config.pm writable for the webserver user!' =>
            'Jeśli chcesz użyć instalatora, ustaw Kernel/Config.pm jako zapisywalny dla użytkownika WebServer',
        'Database Selection' => 'Wybór bazy danych',
        'Unknown Check!' => '',
        'The check "%s" doesn\'t exist!' => '',
        'Enter the password for the database user.' => 'Wprowadź hasło użytkownika bazy danych.',
        'Database %s' => 'Baza danych %s',
        'Configure MySQL' => 'Skonfiguruj MySQL',
        'Enter the password for the administrative database user.' => 'Wprowadź hasło administratora bazy danych.',
        'Configure PostgreSQL' => 'Skonfiguruj PostgreSQL',
        'Configure Oracle' => 'Skonfiguruj Oracle',
        'Unknown database type "%s".' => 'Nieznany typ bazy danych "%s".',
        'Please go back.' => '',
        'Create Database' => 'Utwórz bazę danych',
        'Install OTRS - Error' => '',
        'File "%s/%s.xml" not found!' => '',
        'Contact your Admin!' => 'Skontaktuj się ze swoim Administratorem',
        'System Settings' => 'Konfiguracja Systemu',
        'Syslog' => '',
        'Configure Mail' => 'Skonfiguruj pocztę',
        'Mail Configuration' => 'Konfiguracja poczty',
        'Can\'t write Config file!' => '',
        'Unknown Subaction %s!' => 'Nieznane działanie podrzędne: %s!',
        'Can\'t connect to database, Perl module DBD::%s not installed!' =>
            '',
        'Can\'t connect to database, read comment!' => '',
        'Database already contains data - it should be empty!' => 'Baza danych zawiera już dane - powinna być pusta!',
        'Error: Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            '',
        'Error: Please set the value for innodb_log_file_size on your database to at least %s MB (current: %s MB, recommended: %s MB). For more information, please have a look at %s.' =>
            '',
        'Wrong database collation (%s is %s, but it needs to be utf8).' =>
            '',

        # Perl Module: Kernel/Modules/PublicCalendar.pm
        'No %s!' => 'Brak %s!',
        'No such user!' => 'Nie ma takiego użytkownika!',
        'Invalid calendar!' => 'Niewłaściwy kalendarz!',
        'Invalid URL!' => 'Niewłaściwy URL!',
        'There was an error exporting the calendar!' => 'Błąd podczas eksportowania kalendarza!',

        # Perl Module: Kernel/Modules/PublicRepository.pm
        'Need config Package::RepositoryAccessRegExp' => '',
        'Authentication failed from %s!' => '',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketBounce.pm
        'Bounce Article to a different mail address' => 'Przekaż wiadomość na inny adres e-mail',
        'Bounce' => 'Przekaż',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketCompose.pm
        'Reply All' => 'Odpowiedz wszystkim',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketEmailResend.pm
        'Resend this article' => '',
        'Resend' => '',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketMessageLog.pm
        'View message log details for this article' => '',
        'Message Log' => '',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketNote.pm
        'Reply to note' => 'Odpowiedź na notatkę',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketPhone.pm
        'Split this article' => 'Podziel wiadomość',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketPlain.pm
        'View the source for this Article' => '',
        'Plain Format' => 'Bez formatowania',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketPrint.pm
        'Print this article' => 'Wydrukuj tą wiadomość',

        # Perl Module: Kernel/Output/HTML/ArticleAction/GetHelpLink.pm
        'Contact us at sales@otrs.com' => '',
        'Get Help' => '',

        # Perl Module: Kernel/Output/HTML/ArticleAction/MarkAsImportant.pm
        'Mark' => 'Zaznacz',
        'Unmark' => 'Odznacz',

        # Perl Module: Kernel/Output/HTML/ArticleAction/ReinstallPackageLink.pm
        'Upgrade to OTRS Business Solution™' => 'Ulepsz do wersji OTRS Business Solution™',
        'Re-install Package' => 'Zainstaluj ponownie pakiet',
        'Upgrade' => 'Aktualizacja',
        'Re-install' => 'Zainstaluj ponownie',

        # Perl Module: Kernel/Output/HTML/ArticleCheck/PGP.pm
        'Crypted' => 'Zaszyfrowany',
        'Sent message encrypted to recipient!' => '',
        'Signed' => 'Podpis',
        '"PGP SIGNED MESSAGE" header found, but invalid!' => '',

        # Perl Module: Kernel/Output/HTML/ArticleCheck/SMIME.pm
        '"S/MIME SIGNED MESSAGE" header found, but invalid!' => '',
        'Ticket decrypted before' => '',
        'Impossible to decrypt: private key for email was not found!' => '',
        'Successful decryption' => '',

        # Perl Module: Kernel/Output/HTML/ArticleCompose/Crypt.pm
        'There are no encryption keys available for the addresses: \'%s\'. ' =>
            '',
        'There are no selected encryption keys for the addresses: \'%s\'. ' =>
            '',
        'Cannot use expired encryption keys for the addresses: \'%s\'. ' =>
            '',
        'Cannot use revoked encryption keys for the addresses: \'%s\'. ' =>
            '',
        'Encrypt' => 'Zaszyfruj',
        'Keys/certificates will only be shown for recipients with more than one key/certificate. The first found key/certificate will be pre-selected. Please make sure to select the correct one.' =>
            '',

        # Perl Module: Kernel/Output/HTML/ArticleCompose/Security.pm
        'Email security' => 'Zabezpieczenia e-mail',
        'PGP sign' => '',
        'PGP sign and encrypt' => '',
        'PGP encrypt' => '',
        'SMIME sign' => '',
        'SMIME sign and encrypt' => '',
        'SMIME encrypt' => '',

        # Perl Module: Kernel/Output/HTML/ArticleCompose/Sign.pm
        'Cannot use expired signing key: \'%s\'. ' => '',
        'Cannot use revoked signing key: \'%s\'. ' => '',
        'There are no signing keys available for the addresses \'%s\'.' =>
            '',
        'There are no selected signing keys for the addresses \'%s\'.' =>
            '',
        'Sign' => 'Podpis',
        'Keys/certificates will only be shown for a sender with more than one key/certificate. The first found key/certificate will be pre-selected. Please make sure to select the correct one.' =>
            '',

        # Perl Module: Kernel/Output/HTML/Dashboard/AppointmentCalendar.pm
        'Shown' => 'Pokazane',
        'Refresh (minutes)' => 'Odświeżaj (minuty)',
        'off' => 'wyłączone',

        # Perl Module: Kernel/Output/HTML/Dashboard/CustomerIDList.pm
        'Shown customer ids' => '',

        # Perl Module: Kernel/Output/HTML/Dashboard/CustomerUserList.pm
        'Shown customer users' => 'Widoczni użytkownicy klienta',
        'Offline' => '',
        'User is currently offline.' => '',
        'User is currently active.' => '',
        'Away' => 'Poza',
        'User was inactive for a while.' => '',

        # Perl Module: Kernel/Output/HTML/Dashboard/EventsTicketCalendar.pm
        'The start time of a ticket has been set after the end time!' => '',

        # Perl Module: Kernel/Output/HTML/Dashboard/News.pm
        'Can\'t connect to OTRS News server!' => '',
        'Can\'t get OTRS News from server!' => '',

        # Perl Module: Kernel/Output/HTML/Dashboard/ProductNotify.pm
        'Can\'t connect to Product News server!' => '',
        'Can\'t get Product News from server!' => '',

        # Perl Module: Kernel/Output/HTML/Dashboard/RSS.pm
        'Can\'t connect to %s!' => '',

        # Perl Module: Kernel/Output/HTML/Dashboard/TicketGeneric.pm
        'Shown Tickets' => 'Wyświetlane zgłoszenia',
        'Shown Columns' => 'Wyświetlane kolumny',
        'filter not active' => '',
        'filter active' => '',
        'This ticket has no title or subject' => 'Zgłoszenie nie ma tytułu albo tematu',

        # Perl Module: Kernel/Output/HTML/Dashboard/TicketStatsGeneric.pm
        '7 Day Stats' => 'Statystyka z 7 dni',

        # Perl Module: Kernel/Output/HTML/Dashboard/UserOnline.pm
        'User set their status to unavailable.' => '',
        'Unavailable' => '',

        # Perl Module: Kernel/Output/HTML/Layout.pm
        'Standard' => 'Standard',
        'The following tickets are not updated: %s.' => '',
        'h' => 'godz.',
        'm' => 'min',
        'd' => 'd',
        'This ticket does not exist, or you don\'t have permissions to access it in its current state. You can take one of the following actions:' =>
            '',
        'This is a' => 'To jest',
        'email' => 'e-mail',
        'click here' => 'kliknij tutaj',
        'to open it in a new window.' => 'aby otworzyć w nowym oknie',
        'Year' => 'Rok',
        'Hours' => 'Godziny',
        'Minutes' => 'Minut(-y)',
        'Check to activate this date' => 'Zaznacz aby aktywować tę datę',
        '%s TB' => '',
        '%s GB' => '',
        '%s MB' => '',
        '%s KB' => '',
        '%s B' => '',
        'No Permission!' => 'Brak uprawnień!',
        'No Permission' => 'Brak uprawnień',
        'Show Tree Selection' => 'Pokaż wybór drzewa',
        'Split Quote' => 'Podziel cytując',
        'Remove Quote' => 'Usuń cytowanie',

        # Perl Module: Kernel/Output/HTML/Layout/LinkObject.pm
        'Linked as' => 'Połączone jako',
        'Search Result' => 'Wynik wyszukiwania',
        'Linked' => 'Połączone',
        'Bulk' => 'Zbiorczo',

        # Perl Module: Kernel/Output/HTML/Layout/Ticket.pm
        'Lite' => 'Lekkie',
        'Unread article(s) available' => 'Dostępne są nieprzeczytane wiadomości ',

        # Perl Module: Kernel/Output/HTML/LinkObject/Appointment.pm
        'Appointment' => 'Wydarzenie',

        # Perl Module: Kernel/Output/HTML/LinkObject/Ticket.pm
        'Archive search' => 'Szukanie w archiwum',

        # Perl Module: Kernel/Output/HTML/Notification/AgentCloudServicesDisabled.pm
        'Enable cloud services to unleash all OTRS features!' => 'W celu uruchomienia wszystkich funkcji OTRS włącz usługi w chmurze!',

        # Perl Module: Kernel/Output/HTML/Notification/AgentOTRSBusiness.pm
        '%s Upgrade to %s now! %s' => '%sUlepsz do wersji %steraz! %s',
        'Please verify your license data!' => '',
        'The license for your %s is about to expire. Please make contact with %s to renew your contract!' =>
            'Twoja licencja na %s niedługo wygaśnie. Proszę skontaktuj się z %s w celu przedłużenia umowy!',
        'An update for your %s is available, but there is a conflict with your framework version! Please update your framework first!' =>
            'Dostępna jest aktualizacja dla %s, jednakże istnieje konflikt z atualną wersją frameworka! Należy zaktualizować framework w pierwszej kolejności.',

        # Perl Module: Kernel/Output/HTML/Notification/AgentOnline.pm
        'Online Agent: %s' => 'Zalogowany Agent: %s',

        # Perl Module: Kernel/Output/HTML/Notification/AgentTicketEscalation.pm
        'There are more escalated tickets!' => 'Istnieje więcej eskalowanych zgłoszeń!',

        # Perl Module: Kernel/Output/HTML/Notification/AgentTimeZoneCheck.pm
        'Please select a time zone in your preferences and confirm it by clicking the save button.' =>
            '',

        # Perl Module: Kernel/Output/HTML/Notification/CustomerOnline.pm
        'Online Customer: %s' => 'Zalogowany Klient: %s',

        # Perl Module: Kernel/Output/HTML/Notification/CustomerSystemMaintenanceCheck.pm
        'System maintenance is active!' => 'Konserwacja systemu w toku!',
        'A system maintenance period will start at: %s and is expected to stop at: %s' =>
            '',

        # Perl Module: Kernel/Output/HTML/Notification/DaemonCheck.pm
        'OTRS Daemon is not running.' => 'Demon OTRS nie jest uruchomiony.',

        # Perl Module: Kernel/Output/HTML/Notification/OutofOfficeCheck.pm
        'You have Out of Office enabled, would you like to disable it?' =>
            'Usługa wiadomości o  nieobecności jest aktywna, czy chcesz ją wyłączyć?',

        # Perl Module: Kernel/Output/HTML/Notification/PackageManagerCheckNotVerifiedPackages.pm
        'The installation of packages which are not verified by the OTRS Group is activated. These packages could threaten your whole system! It is recommended not to use unverified packages.' =>
            '',

        # Perl Module: Kernel/Output/HTML/Notification/SystemConfigurationInvalidCheck.pm
        'You have %s invalid setting(s) deployed. Click here to show invalid settings.' =>
            'Są opublikowane nieprawidłowe parametry: %s. Kliknij tutaj aby je wyświetlić.',

        # Perl Module: Kernel/Output/HTML/Notification/SystemConfigurationIsDirtyCheck.pm
        'You have undeployed settings, would you like to deploy them?' =>
            'Masz niewdrożone parametry, czy chcesz je wdrożyć?',

        # Perl Module: Kernel/Output/HTML/Notification/SystemConfigurationOutOfSyncCheck.pm
        'The configuration is being updated, please be patient...' => 'Trwa aktualizacja konfiguracji. Proszę o cierpliwość...',
        'There is an error updating the system configuration!' => '',

        # Perl Module: Kernel/Output/HTML/Notification/UIDCheck.pm
        'Don\'t use the Superuser account to work with %s! Create new Agents and work with these accounts instead.' =>
            '',

        # Perl Module: Kernel/Output/HTML/Preferences/AppointmentNotificationEvent.pm
        'Please make sure you\'ve chosen at least one transport method for mandatory notifications.' =>
            '',
        'Preferences updated successfully!' => 'Konfiguracja uaktualniona!',

        # Perl Module: Kernel/Output/HTML/Preferences/Language.pm
        '(in process)' => '',

        # Perl Module: Kernel/Output/HTML/Preferences/OutOfOffice.pm
        'Please specify an end date that is after the start date.' => '',

        # Perl Module: Kernel/Output/HTML/Preferences/Password.pm
        'Current password' => 'Aktualne hasło',
        'New password' => 'Nowe hasło',
        'Verify password' => 'Powtórz hasło',
        'The current password is not correct. Please try again!' => 'Aktualne hasło jest niepoprawne. Spróbuj jeszcze raz!',
        'Please supply your new password!' => '',
        'Can\'t update password, your new passwords do not match. Please try again!' =>
            'Nie można zmienić hasła. Hasła nie pasują do siebie. Spróbuj ponownie!',
        'This password is forbidden by the current system configuration. Please contact the administrator if you have additional questions.' =>
            '',
        'Can\'t update password, it must be at least %s characters long!' =>
            'Nie można zmienić hasła, musi się ono składać z co najmniej %s znaków!',
        'Can\'t update password, it must contain at least 2 lowercase and 2 uppercase letter characters!' =>
            '',
        'Can\'t update password, it must contain at least 1 digit!' => 'Nie można zmienić hasła. Hasło musi zawierać co najmniej 1 cyfrę!',
        'Can\'t update password, it must contain at least 2 letter characters!' =>
            '',

        # Perl Module: Kernel/Output/HTML/Preferences/TimeZone.pm
        'Time zone updated successfully!' => '',

        # Perl Module: Kernel/Output/HTML/Statistics/View.pm
        'invalid' => 'nieaktualne',
        'valid' => 'aktualne',
        'No (not supported)' => 'Nie (nie obsługiwany)',
        'No past complete or the current+upcoming complete relative time value selected.' =>
            '',
        'The selected time period is larger than the allowed time period.' =>
            '',
        'No time scale value available for the current selected time scale value on the X axis.' =>
            '',
        'The selected date is not valid.' => '',
        'The selected end time is before the start time.' => '',
        'There is something wrong with your time selection.' => '',
        'Please select only one element or allow modification at stat generation time.' =>
            '',
        'Please select at least one value of this field or allow modification at stat generation time.' =>
            '',
        'Please select one element for the X-axis.' => '',
        'You can only use one time element for the Y axis.' => '',
        'You can only use one or two elements for the Y axis.' => '',
        'Please select at least one value of this field.' => '',
        'Please provide a value or allow modification at stat generation time.' =>
            '',
        'Please select a time scale.' => '',
        'Your reporting time interval is too small, please use a larger time scale.' =>
            '',
        'second(s)' => 'sekund(a)',
        'quarter(s)' => 'kwartał(y)',
        'half-year(s)' => 'półrocze(a)',
        'Please remove the following words because they cannot be used for the ticket restrictions: %s.' =>
            '',

        # Perl Module: Kernel/Output/HTML/SysConfig.pm
        'Cancel editing and unlock this setting' => '',
        'Reset this setting to its default value.' => '',
        'Unable to load %s!' => 'Nie można załadować %s!',
        'Content' => 'Zawartość',

        # Perl Module: Kernel/Output/HTML/TicketMenu/Lock.pm
        'Unlock to give it back to the queue' => 'Odblokuj aby przywrócić do kolejki',
        'Lock it to work on it' => 'Zablokuj by na tym pracować',

        # Perl Module: Kernel/Output/HTML/TicketMenu/TicketWatcher.pm
        'Unwatch' => 'Nie obserwuj',
        'Remove from list of watched tickets' => 'Usuń z listy obserwowanych zgłoszeń',
        'Watch' => 'Obserwuj',
        'Add to list of watched tickets' => 'Dodaj do listy obserwowanych zgłoszeń',

        # Perl Module: Kernel/Output/HTML/TicketOverviewMenu/Sort.pm
        'Order by' => 'Sortuj według',

        # Perl Module: Kernel/Output/HTML/TicketZoom/TicketInformation.pm
        'Ticket Information' => 'Informacje o zgłoszeniu',

        # Perl Module: Kernel/Output/HTML/ToolBar/TicketLocked.pm
        'Locked Tickets New' => 'Zablokowane nowe zgłoszenia',
        'Locked Tickets Reminder Reached' => 'Zablokowane zgłoszenia z przekroczonym czasem przypomnienia',
        'Locked Tickets Total' => 'Zablokowane zgłoszenia razem',

        # Perl Module: Kernel/Output/HTML/ToolBar/TicketResponsible.pm
        'Responsible Tickets New' => 'Odpowiedzialność za nowe zgłoszenia',
        'Responsible Tickets Reminder Reached' => 'Odpowiedzialność za zgłoszenia z przekroczonym czasem przypomnienia',
        'Responsible Tickets Total' => 'Odpowiedzialność za zgłoszenia razem',

        # Perl Module: Kernel/Output/HTML/ToolBar/TicketWatcher.pm
        'Watched Tickets New' => 'Obserwowane nowe zgłoszenia',
        'Watched Tickets Reminder Reached' => 'Obserwowane zgłoszenia z przekroczonym czasem przypomnienia',
        'Watched Tickets Total' => 'Obserwowane zgłoszenia razem',

        # Perl Module: Kernel/Output/PDF/Ticket.pm
        'Ticket Dynamic Fields' => 'Informacje dodatkowe',

        # Perl Module: Kernel/System/ACL/DB/ACL.pm
        'Couldn\'t read ACL configuration file. Please make sure the file is valid.' =>
            '',

        # Perl Module: Kernel/System/Auth.pm
        'It is currently not possible to login due to a scheduled system maintenance.' =>
            'W tej chwili logowanie nie jest możliwe w związku z planowaną przerwą techniczną.',

        # Perl Module: Kernel/System/AuthSession.pm
        'You have exceeded the number of concurrent agents - contact sales@otrs.com.' =>
            '',
        'Please note that the session limit is almost reached.' => 'Proszę zauważyć, że został już prawie osiągnięty limit ilości sesji.',
        'Login rejected! You have exceeded the maximum number of concurrent Agents! Contact sales@otrs.com immediately!' =>
            '',
        'Session limit reached! Please try again later.' => 'Osiągnięto limit sesji! Spróbuj się zalogować później.',
        'Session per user limit reached!' => '',

        # Perl Module: Kernel/System/AuthSession/DB.pm
        'Session invalid. Please log in again.' => 'Sesja nieważna. Zaloguj się ponownie.',
        'Session has timed out. Please log in again.' => 'Sesja wygasła. Zaloguj się ponownie',

        # Perl Module: Kernel/System/Calendar/Event/Transport/Email.pm
        'PGP sign only' => '',
        'PGP encrypt only' => '',
        'SMIME sign only' => '',
        'SMIME encrypt only' => '',
        'PGP and SMIME not enabled.' => '',
        'Skip notification delivery' => '',
        'Send unsigned notification' => '',
        'Send unencrypted notification' => '',

        # Perl Module: Kernel/System/Console/Command/Dev/Tools/Config2Docbook.pm
        'Configuration Options Reference' => 'Opcje konfiguracji',
        'This setting can not be changed.' => '',
        'This setting is not active by default.' => '',
        'This setting can not be deactivated.' => '',
        'This setting is not visible.' => 'To ustawienie jest niewidoczne.',
        'This setting can be overridden in the user preferences.' => '',
        'This setting can be overridden in the user preferences, but is not active by default.' =>
            '',

        # Perl Module: Kernel/System/CustomerUser.pm
        'Customer user "%s" already exists.' => '',

        # Perl Module: Kernel/System/CustomerUser/DB.pm
        'This email address is already in use for another customer user.' =>
            '',

        # Perl Module: Kernel/System/DynamicField/Driver/BaseDateTime.pm
        'before/after' => 'przed/po',
        'between' => 'pomiędzy',

        # Perl Module: Kernel/System/DynamicField/Driver/BaseText.pm
        'e.g. Text or Te*t' => '',

        # Perl Module: Kernel/System/DynamicField/Driver/Checkbox.pm
        'Ignore this field.' => '',

        # Perl Module: Kernel/System/DynamicField/Driver/TextArea.pm
        'This field is required or' => 'To pole jes twymagane lub',
        'The field content is too long!' => 'Zawartość pola jest zbyt długa!',
        'Maximum size is %s characters.' => 'Maksymalny rozmiar to %s znaków',

        # Perl Module: Kernel/System/NotificationEvent.pm
        'Couldn\'t read Notification configuration file. Please make sure the file is valid.' =>
            '',
        'Imported notification has body text with more than 4000 characters.' =>
            '',

        # Perl Module: Kernel/System/Package.pm
        'not installed' => 'nie zainstalowane',
        'installed' => 'zainstalowany',
        'Unable to parse repository index document.' => 'Nie można sparsować indeksu rezpozytorium.',
        'No packages for your framework version found in this repository, it only contains packages for other framework versions.' =>
            'Nie znaleziono pakietów dla Twojej wersji frameworka w tym repozytorium, zawiera ono tylko pakiety pasujące do innych wersji frameworka.',
        'File is not installed!' => 'Plik nie jest zainstalowany!',
        'File is different!' => 'Plik jest inny!',
        'Can\'t read file!' => 'Nie można czytać pliku!',
        '<p>If you continue to install this package, the following issues may occur:</p><ul><li>Security problems</li><li>Stability problems</li><li>Performance problems</li></ul><p>Please note that issues that are caused by working with this package are not covered by OTRS service contracts.</p>' =>
            '',
        '<p>The installation of packages which are not verified by the OTRS Group is not possible by default. You can activate the installation of not verified packages via the "AllowNotVerifiedPackages" system configuration setting.</p>' =>
            '',

        # Perl Module: Kernel/System/ProcessManagement/DB/Process.pm
        'The process "%s" and all of its data has been imported successfully.' =>
            '',

        # Perl Module: Kernel/System/ProcessManagement/DB/Process/State.pm
        'Inactive' => 'Nieaktywny',
        'FadeAway' => 'Wygaszony',

        # Perl Module: Kernel/System/Registration.pm
        'Can\'t contact registration server. Please try again later.' => 'Nie można połączyć się z serwerem rejestracji. Prosimy spróbuj ponownie później.',
        'No content received from registration server. Please try again later.' =>
            'Z serwera rejestracji nie otrzymano żadnych danych. Prosimy spróbuj ponownie później.',
        'Can\'t get Token from sever' => '',
        'Username and password do not match. Please try again.' => 'Użytkownik oraz hasło nie zgadzają się. Prosze spróbuj ponownie.',
        'Problems processing server result. Please try again later.' => 'Problem przy procesowaniu rezultatów. Prosimy spróbuj ponownie później.',

        # Perl Module: Kernel/System/Stats.pm
        'Sum' => 'Suma',
        'week' => 'tydzień',
        'quarter' => 'kwartał',
        'half-year' => 'półrocze',

        # Perl Module: Kernel/System/Stats/Dynamic/Ticket.pm
        'State Type' => '',
        'Created Priority' => 'Utworzony priorytet',
        'Created State' => 'Utworzony stan',
        'Create Time' => 'Czas utworzenia',
        'Pending until time' => '',
        'Close Time' => 'Data zamknięcia',
        'Escalation' => 'Eskalacja',
        'Escalation - First Response Time' => '',
        'Escalation - Update Time' => '',
        'Escalation - Solution Time' => '',
        'Agent/Owner' => 'Agent/Właściciel',
        'Created by Agent/Owner' => 'Utworzone przez Agenta/Właściciela',
        'Assigned to Customer User Login' => '',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketAccountedTime.pm
        'Evaluation by' => 'Ocenione przez',
        'Ticket/Article Accounted Time' => 'Rozliczony czas zgłoszenia (wiadomości)',
        'Ticket Create Time' => 'Czas utworzenia zgłoszenia',
        'Ticket Close Time' => 'Czas zamknięcia zgłoszenia',
        'Accounted time by Agent' => 'Czas rozliczony przez Agenta',
        'Total Time' => 'Czas całkowity',
        'Ticket Average' => 'Średnia zgłoszenia',
        'Ticket Min Time' => 'Min. czas zgłoszenia',
        'Ticket Max Time' => 'Maks. czas zgłoszenia',
        'Number of Tickets' => 'Ilość zgłoszeń',
        'Article Average' => 'Średnia wiadomości',
        'Article Min Time' => 'Min. czas wiadomości',
        'Article Max Time' => 'Maks. czas wiadomości',
        'Number of Articles' => 'Ilość wiadomości',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketList.pm
        'unlimited' => '',
        'Attributes to be printed' => 'Drukowane atrybuty',
        'Sort sequence' => 'Kolejność sortowania',
        'State Historic' => '',
        'State Type Historic' => '',
        'Historic Time Range' => '',
        'Number' => 'Liczba',
        'Last Changed' => '',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketSolutionResponseTime.pm
        'Solution Average' => '',
        'Solution Min Time' => '',
        'Solution Max Time' => '',
        'Solution Average (affected by escalation configuration)' => '',
        'Solution Min Time (affected by escalation configuration)' => '',
        'Solution Max Time (affected by escalation configuration)' => '',
        'Solution Working Time Average (affected by escalation configuration)' =>
            '',
        'Solution Min Working Time (affected by escalation configuration)' =>
            '',
        'Solution Max Working Time (affected by escalation configuration)' =>
            '',
        'First Response Average (affected by escalation configuration)' =>
            '',
        'First Response Min Time (affected by escalation configuration)' =>
            '',
        'First Response Max Time (affected by escalation configuration)' =>
            '',
        'First Response Working Time Average (affected by escalation configuration)' =>
            '',
        'First Response Min Working Time (affected by escalation configuration)' =>
            '',
        'First Response Max Working Time (affected by escalation configuration)' =>
            '',
        'Number of Tickets (affected by escalation configuration)' => '',

        # Perl Module: Kernel/System/Stats/Static/StateAction.pm
        'Days' => 'Dni',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/OutdatedTables.pm
        'Outdated Tables' => '',
        'Outdated tables were found in the database. These can be removed if empty.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/TablePresence.pm
        'Table Presence' => 'Obecność tabeli',
        'Internal Error: Could not open file.' => 'Błąd wewnętrzny: Nie można otworzyć pliku.',
        'Table Check' => 'Sprawdzanie tabeli',
        'Internal Error: Could not read file.' => 'Błąd wewnętrzny: Nie można odczytać pliku.',
        'Tables found which are not present in the database.' => 'Zostały wykryte tabele których nie ma w bazie danych.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mssql/Size.pm
        'Database Size' => 'Rozmiar bazy danych',
        'Could not determine database size.' => 'Nie udało się określić rozmiaru bazy danych.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mssql/Version.pm
        'Database Version' => 'Wersja bazy danych',
        'Could not determine database version.' => 'Nie udało się określić wersji bazy danych.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Charset.pm
        'Client Connection Charset' => 'Kodowanie znaków połączenia Klienta',
        'Setting character_set_client needs to be utf8.' => 'Character_set_client musi być ustawione na utf8.',
        'Server Database Charset' => 'Kodowanie znaków serwera bazy danych',
        'This character set is not yet supported, please see https://bugs.otrs.org/show_bug.cgi?id=12361. Please convert your database to the character set \'utf8\'.' =>
            '',
        'The setting character_set_database needs to be \'utf8\'.' => 'Wartość character_set_database musi być ustawiona na \'utf8\'.',
        'Table Charset' => 'Kodowanie znaków tabeli',
        'There were tables found which do not have \'utf8\' as charset.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/InnoDBLogFileSize.pm
        'InnoDB Log File Size' => 'Rozmiar pliku dziennika InnoDB',
        'The setting innodb_log_file_size must be at least 256 MB.' => 'Parametr "innodb_log_file_size" musi być ustawiony na co najmniej 256 MB.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/InvalidDefaultValues.pm
        'Invalid Default Values' => '',
        'Tables with invalid default values were found. In order to fix it automatically, please run: bin/otrs.Console.pl Maint::Database::Check --repair' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/MaxAllowedPacket.pm
        'Maximum Query Size' => 'Maksymalny rozmiar zapytania',
        'The setting \'max_allowed_packet\' must be higher than 64 MB.' =>
            'Wartość \'max_allowed_packet\' powinna być większa niż 64MB',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Performance.pm
        'Query Cache Size' => 'Rozmiar pamięci podręcznej zapytania',
        'The setting \'query_cache_size\' should be used (higher than 10 MB but not more than 512 MB).' =>
            'Parametr "query_cache_size" powinień być ustawiony (więcej niż 10 MB, ale nie więcej niż 512 MB).',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/StorageEngine.pm
        'Default Storage Engine' => 'Domyślny magazyn danych',
        'Table Storage Engine' => '',
        'Tables with a different storage engine than the default engine were found.' =>
            'Znaleziono tabele z ustawionym magazynem danych innym niż domyślny.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Version.pm
        'MySQL 5.x or higher is required.' => 'Wymagany jest MYSQL w wersji 5.x lub wyższej.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/oracle/NLS.pm
        'NLS_LANG Setting' => 'Ustawienie NLS_LANG',
        'NLS_LANG must be set to al32utf8 (e.g. GERMAN_GERMANY.AL32UTF8).' =>
            '',
        'NLS_DATE_FORMAT Setting' => 'Ustawienie NLS_DATE_FORMAT',
        'NLS_DATE_FORMAT must be set to \'YYYY-MM-DD HH24:MI:SS\'.' => 'NLS_DATE_FORMAT musi mieć postać "RRRR-MM-DD GG:MM:SS".',
        'NLS_DATE_FORMAT Setting SQL Check' => 'NLS_DATE_FORMAT Ustawienie SQL Check',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/oracle/PrimaryKeySequencesAndTriggers.pm
        'Primary Key Sequences and Triggers' => '',
        'The following sequences and/or triggers with possible wrong names have been found. Please rename them manually.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/Charset.pm
        'Setting client_encoding needs to be UNICODE or UTF8.' => 'Parametr "client_encoding" musi być ustawiony na UNICODE lub UTF8.',
        'Setting server_encoding needs to be UNICODE or UTF8.' => 'Parametr "server_encoding" musi być ustawiony na UNICODE lub UTF8.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/DateStyle.pm
        'Date Format' => 'Format daty',
        'Setting DateStyle needs to be ISO.' => 'Parametr "DateStyle" musi być zgodny z ISO.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/PrimaryKeySequences.pm
        'Primary Key Sequences' => '',
        'The following sequences with possible wrong names have been found. Please rename them manually.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/Version.pm
        'PostgreSQL 9.2 or higher is required.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskPartitionOTRS.pm
        'OTRS Disk Partition' => 'Partycja dysku OTRS',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskSpace.pm
        'Disk Usage' => 'Użycie dysku',
        'The partition where OTRS is located is almost full.' => 'Partycja na której znajduje się OTRS jest prawie pełna.',
        'The partition where OTRS is located has no disk space problems.' =>
            'Na partycji na której znajduje się OTRS zabrakło wolnego miejsca.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskSpacePartitions.pm
        'Disk Partitions Usage' => 'Użycie miejsca partycji',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Distribution.pm
        'Distribution' => 'Dystrybucja',
        'Could not determine distribution.' => 'Nie udało się określić dystrybucji.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/KernelVersion.pm
        'Kernel Version' => 'Wersja jądra systemu',
        'Could not determine kernel version.' => 'Nie udało się określić wersji jądra systemu.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Load.pm
        'System Load' => 'Obciążenie systemu',
        'The system load should be at maximum the number of CPUs the system has (e.g. a load of 8 or less on a system with 8 CPUs is OK).' =>
            'Maksymalne obciążenie systemu powinno być równe ilości procesorów dostępnych w serwerze (np. obciążenie równe 8 lub mniej na 8 rdzeniowym serwerze jest prawidłowe).',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/PerlModules.pm
        'Perl Modules' => 'Moduły Perl',
        'Not all required Perl modules are correctly installed.' => 'Nie wszystkie wymagane moduły Perl są poprawnie zainstalowane.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/PerlModulesAudit.pm
        'Perl Modules Audit' => '',
        'CPAN::Audit reported that one or more installed Perl modules have known vulnerabilities. Please note that there might be false positives for distributions patching Perl modules without changing their version number.' =>
            '',
        'CPAN::Audit did not report any known vulnerabilities in the installed Perl modules.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Swap.pm
        'Free Swap Space (%)' => 'Dostępna przestrzeń stronicowania (%)',
        'No swap enabled.' => 'Nie włączona partycja SWAP.',
        'Used Swap Space (MB)' => 'Używana przestrzeń wymiany (MB)',
        'There should be more than 60% free swap space.' => ' Co najmniej 60% przestrzeni wymiany powinno być wolne.',
        'There should be no more than 200 MB swap space used.' => 'Co najmniej 200 MB przestrzeni wymiany powinno być używane.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/ArticleSearchIndexStatus.pm
        'OTRS' => 'OTRS',
        'Article Search Index Status' => '',
        'Indexed Articles' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/ArticlesPerCommunicationChannel.pm
        'Articles Per Communication Channel' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/CommunicationLog.pm
        'Incoming communications' => '',
        'Outgoing communications' => '',
        'Failed communications' => '',
        'Average processing time of communications (s)' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/CommunicationLogAccountStatus.pm
        'Communication Log Account Status (last 24 hours)' => '',
        'No connections found.' => '',
        'ok' => '',
        'permanent connection errors' => '',
        'intermittent connection errors' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/ConfigSettings.pm
        'Config Settings' => 'Ustawienia konfiguracyjne',
        'Could not determine value.' => 'Nie można określić wartości.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/DaemonRunning.pm
        'Daemon' => 'Demon',
        'Daemon is running.' => 'Demon jest uruchomiony',
        'Daemon is not running.' => 'Demon nie jest uruchomiony',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/DatabaseRecords.pm
        'Database Records' => 'Rekordy bazy danych',
        'Tickets' => 'Zgłoszenia',
        'Ticket History Entries' => 'Historia zgłoszeń',
        'Articles' => 'Wiadomości',
        'Attachments (DB, Without HTML)' => 'Załączniki (DB, bez HTML)',
        'Customers With At Least One Ticket' => 'Klienci którzy posiadają co najmniej jedno zgłoszenie',
        'Dynamic Field Values' => 'Wartości pól dynamicznych',
        'Invalid Dynamic Fields' => 'Nieprawidłowe pola dynamiczne',
        'Invalid Dynamic Field Values' => 'Nieprawidłowe wartości pól dynamicznych',
        'GenericInterface Webservices' => 'Ogólny interfejs usług sieciowych',
        'Process Tickets' => 'Zgłoszenia procesowe',
        'Months Between First And Last Ticket' => 'Ilość miesięcy pomiędzy pierwszym, a ostatnim zgłoszeniem',
        'Tickets Per Month (avg)' => 'Zgłoszeń w miesiącu (śred.)',
        'Open Tickets' => 'Otwarte zgłoszenia',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/DefaultSOAPUser.pm
        'Default SOAP Username And Password' => '',
        'Security risk: you use the default setting for SOAP::User and SOAP::Password. Please change it.' =>
            'Zagrożenie bezpieczeństwa: używasz domyślnych ustawień SOAP::User i SOAP::Password. Należy je zmienić.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/DefaultUser.pm
        'Default Admin Password' => 'Domyślne hasło Admina',
        'Security risk: the agent account root@localhost still has the default password. Please change it or invalidate the account.' =>
            'Zagrożenie bezpieczeństwa: Konto agenta "root@localhost" nadal ma ustawione domyślne hasło. Należy je zmienić lub wyłączyć konto.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/EmailQueue.pm
        'Email Sending Queue' => 'Kolejka Nadawcza Email',
        'Emails queued for sending' => 'Emaile w kolejce wysyłania',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/FQDN.pm
        'FQDN (domain name)' => 'FQDN (nazwa domeny)',
        'Please configure your FQDN setting.' => 'Skonfiguruj proszę ustawienie twojej FQDN',
        'Domain Name' => 'Nazwa domeny',
        'Your FQDN setting is invalid.' => 'Kompletna nazwa hosta (FQDN) jest nieprawidłowa.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/FileSystemWritable.pm
        'File System Writable' => 'System plików jest zapisywalny',
        'The file system on your OTRS partition is not writable.' => 'System plików na partycji OTRS nie ma praw do zapisu.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/LegacyConfigBackups.pm
        'Legacy Configuration Backups' => '',
        'No legacy configuration backup files found.' => '',
        'Legacy configuration backup files found in Kernel/Config/Backups folder, but they might still be required by some packages.' =>
            '',
        'Legacy configuration backup files are no longer needed for the installed packages, please remove them from Kernel/Config/Backups folder.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/PackageDeployment.pm
        'Package Installation Status' => 'Stan instalacji pakietu',
        'Some packages have locally modified files.' => '',
        'Some packages are not correctly installed.' => 'Niektóre pakiety nie zostały poprawnie zainstalowane.',
        'Package Verification Status' => 'Stan Weryfikacji Pakietów',
        'Some packages are not verified by the OTRS Group! It is recommended not to use this packages.' =>
            '',
        'Package Framework Version Status' => '',
        'Some packages are not allowed for the current framework version.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/PackageList.pm
        'Package List' => 'Lista pakietów',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/SessionConfigSettings.pm
        'Session Config Settings' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/SpoolMails.pm
        'Spooled Emails' => '',
        'There are emails in var/spool that OTRS could not process.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/SystemID.pm
        'Your SystemID setting is invalid, it should only contain digits.' =>
            'Wartość pola SystemID jest nieprawidłowa, powinno zawierać tylko cyfry.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/DefaultType.pm
        'Default Ticket Type' => 'Domyślny Typ Zgłoszenia',
        'The configured default ticket type is invalid or missing. Please change the setting Ticket::Type::Default and select a valid ticket type.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/IndexModule.pm
        'Ticket Index Module' => 'Moduł indeksów zgłoszeń',
        'You have more than 60,000 tickets and should use the StaticDB backend. See admin manual (Performance Tuning) for more information.' =>
            'Masz ponad 60 000 zgłoszeń i powinieneś korzystać z modułu StaticDB. Zobacz podręcznik administratora (poprawa wydajności) w celu uzyskania dodatkowych informacji.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/InvalidUsersWithLockedTickets.pm
        'Invalid Users with Locked Tickets' => '',
        'There are invalid users with locked tickets.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/OpenTickets.pm
        'You should not have more than 8,000 open tickets in your system.' =>
            'Nie należy utrzymywać  w systemie więcej niż 8 000 otwartych zgłoszeń.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/SearchIndexModule.pm
        'Ticket Search Index Module' => '',
        'The indexing process forces the storage of the original article text in the article search index, without executing filters or applying stop word lists. This will increase the size of the search index and thus may slow down fulltext searches.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/StaticDBOrphanedRecords.pm
        'Orphaned Records In ticket_lock_index Table' => 'Osierocone rekordy w tabeli ticket_lock_index',
        'Table ticket_lock_index contains orphaned records. Please run bin/otrs.Console.pl "Maint::Ticket::QueueIndexCleanup" to clean the StaticDB index.' =>
            '',
        'Orphaned Records In ticket_index Table' => 'Osierocone rekordy w tabeli ticket_index',
        'Table ticket_index contains orphaned records. Please run bin/otrs.Console.pl "Maint::Ticket::QueueIndexCleanup" to clean the StaticDB index.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/TimeSettings.pm
        'Time Settings' => 'Ustawienia czasu',
        'Server time zone' => 'Ustawienia strefy czasowej serwera',
        'OTRS time zone' => 'Strefa czasowa OTRS',
        'OTRS time zone is not set.' => 'Strefa czasowa OTRS nie jest ustawiona.',
        'User default time zone' => 'Domyślna strefa czasowa użytkownika',
        'User default time zone is not set.' => 'Nie ustawiona domyślna strefa czasowa użytkownika.',
        'Calendar time zone is not set.' => 'Strefa czasowa kalendarza nie jest ustawiona.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/UI/AgentSkinUsage.pm
        'UI - Agent Skin Usage' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/UI/AgentThemeUsage.pm
        'UI - Agent Theme Usage' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/UI/SpecialStats.pm
        'UI - Special Statistics' => '',
        'Agents using custom main menu ordering' => '',
        'Agents using favourites for the admin overview' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/LoadedModules.pm
        'Webserver' => 'Serwer www',
        'Loaded Apache Modules' => 'Załadowane moduły Apache',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/MPMModel.pm
        'MPM model' => 'Model MPM',
        'OTRS requires apache to be run with the \'prefork\' MPM model.' =>
            'OTRS wymaga uruchomienia serwera Apache wraz z modelem "prefork" MPM.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/Performance.pm
        'CGI Accelerator Usage' => 'Wykorzystanie akceleratora CGI',
        'You should use FastCGI or mod_perl to increase your performance.' =>
            'Należy korzystać z FastCGI lub mod_perl w celu zwiększenia wydajności.',
        'mod_deflate Usage' => 'Wykorzystanie mod_deflate',
        'Please install mod_deflate to improve GUI speed.' => 'Należy zainstalować mod_deflate w celu poprawy wydajności GUI.',
        'mod_filter Usage' => 'Wykorzystanie mod_filter',
        'Please install mod_filter if mod_deflate is used.' => 'Należy zainstalować mod_filter jeśli wykorzystywany jest mod_deflate.',
        'mod_headers Usage' => 'Wykorzystanie mod_headers',
        'Please install mod_headers to improve GUI speed.' => 'Należy zainstalować mod_headers w celu poprawy wydajności GUI.',
        'Apache::Reload Usage' => 'Wykorzystanie Apache::Reload',
        'Apache::Reload or Apache2::Reload should be used as PerlModule and PerlInitHandler to prevent web server restarts when installing and upgrading modules.' =>
            'Apache::Reload lub Apache2::Reload powinno być używane jako moduł Perl oraz PerlInitHandler, aby uniknąć ponownego uruchomienia serwera WWW podczas instalacji i aktualizacji modułów.',
        'Apache2::DBI Usage' => '',
        'Apache2::DBI should be used to get a better performance  with pre-established database connections.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/EnvironmentVariables.pm
        'Environment Variables' => 'Zmienne środowiskowe',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/InternalWebRequest.pm
        'Support Data Collection' => '',
        'Support data could not be collected from the web server.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Version.pm
        'Webserver Version' => 'Wersja serwera WWW',
        'Could not determine webserver version.' => 'Nie udało się określić wersji serwera WWW.',

        # Perl Module: Kernel/System/SupportDataCollector/PluginAsynchronous/OTRS/ConcurrentUsers.pm
        'Concurrent Users Details' => '',
        'Concurrent Users' => 'Jednocześni Użytkownicy',

        # Perl Module: Kernel/System/SupportDataCollector/PluginBase.pm
        'OK' => 'OK',
        'Problem' => 'Problem',

        # Perl Module: Kernel/System/SysConfig.pm
        'Setting %s does not exists!' => '',
        'Setting %s is not locked to this user!' => '',
        'Setting value is not valid!' => 'Wartość ustawienia jest nieprawidłowa!',
        'Could not add modified setting!' => '',
        'Could not update modified setting!' => '',
        'Setting could not be unlocked!' => 'Ustawienia nie można odblokować!',
        'Missing key %s!' => 'Brakujący klucz %s!',
        'Invalid setting: %s' => 'Nieprawidłowe ustawienie: %s',
        'Could not combine settings values into a perl hash.' => '',
        'Can not lock the deployment for UserID \'%s\'!' => 'Nie mogę zablokować wdrożenia dla UserID \'%s\'!',
        'All Settings' => 'Wszystkie Ustawienia',

        # Perl Module: Kernel/System/SysConfig/BaseValueType.pm
        'Default' => 'Domyślne',
        'Value is not correct! Please, consider updating this field.' => '',
        'Value doesn\'t satisfy regex (%s).' => 'Wartość nie pasuje do regex (%s).',

        # Perl Module: Kernel/System/SysConfig/ValueType/Checkbox.pm
        'Enabled' => 'Włączony',
        'Disabled' => 'Wyłączony',

        # Perl Module: Kernel/System/SysConfig/ValueType/Date.pm
        'System was not able to calculate user Date in OTRSTimeZone!' => '',

        # Perl Module: Kernel/System/SysConfig/ValueType/DateTime.pm
        'System was not able to calculate user DateTime in OTRSTimeZone!' =>
            '',

        # Perl Module: Kernel/System/SysConfig/ValueType/FrontendNavigation.pm
        'Value is not correct! Please, consider updating this module.' =>
            '',

        # Perl Module: Kernel/System/SysConfig/ValueType/VacationDays.pm
        'Value is not correct! Please, consider updating this setting.' =>
            '',

        # Perl Module: Kernel/System/Ticket.pm
        'Reset of unlock time.' => '',

        # Perl Module: Kernel/System/Ticket/Article/Backend/Chat.pm
        'Chat Participant' => '',
        'Chat Message Text' => '',

        # Perl Module: Kernel/System/Web/InterfaceAgent.pm
        'Login failed! Your user name or password was entered incorrectly.' =>
            'Logowanie nieudane! Podano błędną nazwę użytkownika lub hasło.',
        'Authentication succeeded, but no user data record is found in the database. Please contact the administrator.' =>
            '',
        'Can`t remove SessionID.' => '',
        'Logout successful.' => 'Wylogowanie zakończone pomyślnie.',
        'Feature not active!' => 'Funkcja nieaktywna!',
        'Sent password reset instructions. Please check your email.' => 'Instrukcje dotyczące resetowania hasła zostały wysłane. Prosimy o sprawdzenie swojej skrzynki pocztowej.',
        'Invalid Token!' => 'Błędny token!',
        'Sent new password to %s. Please check your email.' => 'Nowe hasło wysłane na adres %s. Prosimy o sprawdzenie swojej skrzynki pocztowej.',
        'Error: invalid session.' => 'Błąd: nie prawidłowa sesja.',
        'No Permission to use this frontend module!' => 'Brak uprawnień do użycia tego modułu!',

        # Perl Module: Kernel/System/Web/InterfaceCustomer.pm
        'Authentication succeeded, but no customer record is found in the customer backend. Please contact the administrator.' =>
            '',
        'Reset password unsuccessful. Please contact the administrator.' =>
            '',
        'This e-mail address already exists. Please log in or reset your password.' =>
            'Wpisany adres e-mail już istnieje. Wystarczy się zalogować lub skorzystać z funkcji resetowania hasła.',
        'This email address is not allowed to register. Please contact support staff.' =>
            'Podany adres e-mail nie jest dopuszczony do rejestracji. Skontaktuj się z Obsługą Kienta.',
        'Added via Customer Panel (%s)' => '',
        'Customer user can\'t be added!' => 'Nie mozna dodać użytkownika klienta!',
        'Can\'t send account info!' => '',
        'New account created. Sent login information to %s. Please check your email.' =>
            'Utworzono nowe konto. Informacje dotyczące sposobu logowania zostały wysłane na adres %s. Prosimy o sprawdzenie swojej skrzynki pocztowej.',

        # Perl Module: Kernel/System/Web/InterfaceInstaller.pm
        'Action "%s" not found!' => '',

        # Database XML Definition: scripts/database/otrs-initial_insert.xml
        'invalid-temporarily' => 'czasowo nieaktualne',
        'Group for default access.' => 'Grupa z podstawowymi prawami dostępu.',
        'Group of all administrators.' => 'Grupa wszystkich administratorów.',
        'Group for statistics access.' => 'Grupa z dostępem do statystyk.',
        'new' => 'nowe',
        'All new state types (default: viewable).' => '',
        'open' => 'otwarte',
        'All open state types (default: viewable).' => '',
        'closed' => 'zamknięte',
        'All closed state types (default: not viewable).' => '',
        'pending reminder' => 'oczekujące przypomnienie',
        'All \'pending reminder\' state types (default: viewable).' => '',
        'pending auto' => 'oczekujące na automatyczne',
        'All \'pending auto *\' state types (default: viewable).' => '',
        'removed' => 'usunięte',
        'All \'removed\' state types (default: not viewable).' => '',
        'merged' => 'scalone',
        'State type for merged tickets (default: not viewable).' => '',
        'New ticket created by customer.' => 'Nowe zgłoszenie stworzone przez klienta.',
        'closed successful' => 'zamknięte z powodzeniem',
        'Ticket is closed successful.' => 'Zgłoszenie zamknięte z powodzeniem.',
        'closed unsuccessful' => 'zamknięte bez powodzenia',
        'Ticket is closed unsuccessful.' => 'Zgłoszenie zamknięte bez powodzenia.',
        'Open tickets.' => 'Otwarte zgłoszenia.',
        'Customer removed ticket.' => 'Usunięte zgłoszenia klienta.',
        'Ticket is pending for agent reminder.' => '',
        'pending auto close+' => 'oczekujące na automatyczne zamknięcie+',
        'Ticket is pending for automatic close.' => '',
        'pending auto close-' => 'oczekujące na automatyczne zamknięcie-',
        'State for merged tickets.' => '',
        'system standard salutation (en)' => '',
        'Standard Salutation.' => 'Standardowe powitanie.',
        'system standard signature (en)' => '',
        'Standard Signature.' => '',
        'Standard Address.' => '',
        'possible' => 'możliwe',
        'Follow-ups for closed tickets are possible. Ticket will be reopened.' =>
            '',
        'reject' => 'odrzuć',
        'Follow-ups for closed tickets are not possible. No new ticket will be created.' =>
            '',
        'new ticket' => 'nowe zgłoszenie',
        'Follow-ups for closed tickets are not possible. A new ticket will be created.' =>
            '',
        'Postmaster queue.' => 'Kolejka poczty przychodzącej.',
        'All default incoming tickets.' => '',
        'All junk tickets.' => 'Wszystkie śmieciowe wiadomości.',
        'All misc tickets.' => 'Inne zgłoszenia.',
        'auto reply' => 'automatyczna odpowiedź',
        'Automatic reply which will be sent out after a new ticket has been created.' =>
            '',
        'auto reject' => 'automatyczne odrzucenie',
        'Automatic reject which will be sent out after a follow-up has been rejected (in case queue follow-up option is "reject").' =>
            '',
        'auto follow up' => 'automatyczne śledzenie',
        'Automatic confirmation which is sent out after a follow-up has been received for a ticket (in case queue follow-up option is "possible").' =>
            '',
        'auto reply/new ticket' => 'automatyczna odpowiedź / nowe zgłoszenie',
        'Automatic response which will be sent out after a follow-up has been rejected and a new ticket has been created (in case queue follow-up option is "new ticket").' =>
            '',
        'auto remove' => 'automatyczne usunięcie',
        'Auto remove will be sent out after a customer removed the request.' =>
            '',
        'default reply (after new ticket has been created)' => 'automatyczna odpowiedź (jak już zostanie stworzone nowe zgłoszenie)',
        'default reject (after follow-up and rejected of a closed ticket)' =>
            '',
        'default follow-up (after a ticket follow-up has been added)' => '',
        'default reject/new ticket created (after closed follow-up with new ticket creation)' =>
            '',
        'Unclassified' => 'Niesklasyfikowane',
        '1 very low' => '1 bardzo niski',
        '2 low' => '2 niski',
        '3 normal' => '3 normalny',
        '4 high' => '4 wysoki',
        '5 very high' => '5 bardzo wysoki',
        'unlock' => 'odblokowane',
        'lock' => 'zablokowane',
        'tmp_lock' => '',
        'agent' => 'Agent',
        'system' => 'System',
        'customer' => 'klient',
        'Ticket create notification' => 'Powiadomienia o nowym zgłoszeniu',
        'You will receive a notification each time a new ticket is created in one of your "My Queues" or "My Services".' =>
            'Otrzymasz powiadomienie, za każdym razem, gdy zgłoszenie zostanie utworzone w jednej z „Twoich Kolejek” lub „Twoich Usług”. ',
        'Ticket follow-up notification (unlocked)' => 'Powiadomienia o nowej wiadomości w zgłoszeniu (odblokowane)',
        'You will receive a notification if a customer sends a follow-up to an unlocked ticket which is in your "My Queues" or "My Services".' =>
            '',
        'Ticket follow-up notification (locked)' => 'Powiadomienia o nowej wiadomości w zgłoszeniu (zablokowane)',
        'You will receive a notification if a customer sends a follow-up to a locked ticket of which you are the ticket owner or responsible.' =>
            '',
        'Ticket lock timeout notification' => 'Powiadomienie o przekroczonym czasie blokady zgłoszenia',
        'You will receive a notification as soon as a ticket owned by you is automatically unlocked.' =>
            '',
        'Ticket owner update notification' => 'Powiadomienia o zmianie właściciela zgłoszenia',
        'Ticket responsible update notification' => 'Powiadomienia o zmianie odpowiedzialnego za zgłoszenie',
        'Ticket new note notification' => 'Powiadomienia o nowej notatce w zgłoszeniu',
        'Ticket queue update notification' => 'Powiadomienia o zmianie kolejki zgłoszenia',
        'You will receive a notification if a ticket is moved into one of your "My Queues".' =>
            'Otrzymasz powiadomienie, za każdym razem, gdy zgłoszenie zostanie przesunięte do jednej z Twoich Kolejek.',
        'Ticket pending reminder notification (locked)' => 'Powiadomienia o oczekującym przypomnieniu w zgłoszeniu (zablokowane)',
        'Ticket pending reminder notification (unlocked)' => 'Powiadomienia o oczekującym przypomnieniu w zgłoszeniu (odblokowane)',
        'Ticket escalation notification' => 'Powiadomienie o eskalacji zgłoszenia',
        'Ticket escalation warning notification' => '',
        'Ticket service update notification' => 'Powiadomienie o zmianie usługi zgłoszenia',
        'You will receive a notification if a ticket\'s service is changed to one of your "My Services".' =>
            '',
        'Appointment reminder notification' => 'Powiadomienie przypominające o wydarzeniu',
        'You will receive a notification each time a reminder time is reached for one of your appointments.' =>
            'Otrzymasz powiadomienie za każdym razem gdy zostanie osiągnięty czas przypomnienia dla jednego z twoich wydarzeń.',
        'Ticket email delivery failure notification' => '',

        # JS File: Core.AJAX
        'Error during AJAX communication. Status: %s, Error: %s' => '',
        'This window must be called from compose window.' => '',

        # JS File: Core.Agent.Admin.ACL
        'Add all' => 'Dodaj wszystkie',
        'An item with this name is already present.' => 'Pozycja o tej nazwie już istnieje.',
        'This item still contains sub items. Are you sure you want to remove this item including its sub items?' =>
            'Ta pozycja nadal zawiera podpozycje. Czy jesteś pewien, że chce usunąć ją wraz z nimi?',

        # JS File: Core.Agent.Admin.AppointmentCalendar.Manage
        'More' => 'Więcej',
        'Less' => 'Mniej',
        'Press Ctrl+C (Cmd+C) to copy to clipboard' => '',

        # JS File: Core.Agent.Admin.Attachment
        'Delete this Attachment' => 'Usuń ten Załącznik',
        'Deleting attachment...' => 'Usuwanie załącznika...',
        'There was an error deleting the attachment. Please check the logs for more information.' =>
            '',
        'Attachment was deleted successfully.' => 'Załącznik został pomyślnie usunięty.',

        # JS File: Core.Agent.Admin.DynamicField
        'Do you really want to delete this dynamic field? ALL associated data will be LOST!' =>
            'Czy na pewno chcesz usunąć to pole dynamiczne? Wszystkie związane dane będą USUNIĘTE!',
        'Delete field' => 'Usuń pole',
        'Deleting the field and its data. This may take a while...' => 'Trwa kasowanie pola i skojarzonych z nim danych. To może chwilę potrwać...',

        # JS File: Core.Agent.Admin.GenericAgent
        'Remove this dynamic field' => '',
        'Remove selection' => 'Usuń zaznaczenie',
        'Do you really want to delete this generic agent job?' => '',
        'Delete this Event Trigger' => 'Usuń ten trigger',
        'Duplicate event.' => 'Duplikuj zdarzenie',
        'This event is already attached to the job, Please use a different one.' =>
            'Jeśli zdarzenie jest już dodane do zadania wówczas prosze użyj innego.',

        # JS File: Core.Agent.Admin.GenericInterfaceDebugger
        'An error occurred during communication.' => 'W trakcie komunikacji wystąpił błąd.',
        'Request Details' => 'Szczegóły żądania',
        'Request Details for Communication ID' => '',
        'Show or hide the content.' => 'Pokaż lub ukryj zawartość.',
        'Clear debug log' => 'Wyczyść log debug',

        # JS File: Core.Agent.Admin.GenericInterfaceErrorHandling
        'Delete error handling module' => '',

        # JS File: Core.Agent.Admin.GenericInterfaceInvoker
        'It is not possible to add a new event trigger because the event is not set.' =>
            '',
        'Delete this Invoker' => 'Usuń ten invoker',

        # JS File: Core.Agent.Admin.GenericInterfaceInvokerEvent
        'Sorry, the only existing condition can\'t be removed.' => '',
        'Sorry, the only existing field can\'t be removed.' => '',
        'Delete conditions' => '',

        # JS File: Core.Agent.Admin.GenericInterfaceMapping
        'Mapping for Key %s' => '',
        'Mapping for Key' => '',
        'Delete this Key Mapping' => 'Usuń to mapowanie klucza',

        # JS File: Core.Agent.Admin.GenericInterfaceOperation
        'Delete this Operation' => 'Usuń tę operację',

        # JS File: Core.Agent.Admin.GenericInterfaceWebservice
        'Clone web service' => 'Klonuj serwis sieciowy',
        'Delete operation' => 'Usuń operację',
        'Delete invoker' => 'Usuń invoker',

        # JS File: Core.Agent.Admin.Group
        'WARNING: When you change the name of the group \'admin\', before making the appropriate changes in the SysConfig, you will be locked out of the administrations panel! If this happens, please rename the group back to admin per SQL statement.' =>
            'Uwaga: Jeżeli zmienisz nazwę grupy \'admin\', przed wykonaniem właściwych zmian w SysConfig, zablokujesz panel administratorów! Jeżeli to nastąpi, przywróć nazwę grupy admin z użyciem SQL.',

        # JS File: Core.Agent.Admin.MailAccount
        'Delete this Mail Account' => 'Usuń to Konto Pocztowe',
        'Deleting the mail account and its data. This may take a while...' =>
            '',

        # JS File: Core.Agent.Admin.NotificationEvent
        'Do you really want to delete this notification language?' => 'Czy na pewno chcesz usunąć ten język powiadomienia?',
        'Do you really want to delete this notification?' => 'Czy na pewno chcesz usunąć to powiadomienie?',

        # JS File: Core.Agent.Admin.PGP
        'Do you really want to delete this key?' => '',

        # JS File: Core.Agent.Admin.PackageManager
        'There is a package upgrade process running, click here to see status information about the upgrade progress.' =>
            '',
        'A package upgrade was recently finished. Click here to see the results.' =>
            '',
        'No response from get package upgrade result.' => '',
        'Update all packages' => 'Aktualizuj wszystkie pakiety',
        'Dismiss' => 'Zwolnij',
        'Update All Packages' => 'Aktualizuj wszystkie pakiety',
        'No response from package upgrade all.' => '',
        'Currently not possible' => '',
        'This is currently disabled because of an ongoing package upgrade.' =>
            '',
        'This option is currently disabled because the OTRS Daemon is not running.' =>
            '',
        'Are you sure you want to update all installed packages?' => 'Czy na pewno chcesz zaktualizować wszystkie zainstalowane pakiety?',
        'No response from get package upgrade run status.' => '',

        # JS File: Core.Agent.Admin.PostMasterFilter
        'Delete this PostMasterFilter' => 'Usuń ten filtr pocztowy',
        'Deleting the postmaster filter and its data. This may take a while...' =>
            'Usuwanie filtra pocztowego i jego danych. To może chwilę potrwać....',

        # JS File: Core.Agent.Admin.ProcessManagement.Canvas
        'Remove Entity from canvas' => 'Usuń Entity z obszaru projektu',
        'No TransitionActions assigned.' => 'Brak przypisanych akcji przejścia.',
        'No dialogs assigned yet. Just pick an activity dialog from the list on the left and drag it here.' =>
            'Brak jeszcze przypisanych okien. Wybierz okno działań z listy po lewej stronie i upuść je tutaj.',
        'This Activity cannot be deleted because it is the Start Activity.' =>
            'To działanie nie może być usunięte ponieważ jest działaniem początkowym.',
        'Remove the Transition from this Process' => 'Usuń to przejście z tego procesu',

        # JS File: Core.Agent.Admin.ProcessManagement
        'As soon as you use this button or link, you will leave this screen and its current state will be saved automatically. Do you want to continue?' =>
            'Gdy tylko użyjesz tego przycisku lub odnośnika, opuścisz ten ekran a jego obecny stan zostanie automatycznie zapisany. Czy chcesz kontynuować?',
        'Delete Entity' => 'Usuń Entity',
        'This Activity is already used in the Process. You cannot add it twice!' =>
            'To działanie jest już użyte w procesie. Nie możesz dodać go dwukrotnie!',
        'Error during AJAX communication' => '',
        'An unconnected transition is already placed on the canvas. Please connect this transition first before placing another transition.' =>
            'Niepodłączone przejście jest już przygotowane. Proszę wpierw połącz to przejście przed umieszczeniem kolejnego.',
        'This Transition is already used for this Activity. You cannot use it twice!' =>
            'To przejście jest już użyte w tym działaniu. Nie możesz użyć go dwukrotnie!',
        'This TransitionAction is already used in this Path. You cannot use it twice!' =>
            'Ta akcja przejścia jest już użyta na tej ścieżce. Nie możesz użyć jej dwukrotnie!',
        'Hide EntityIDs' => 'Ukryj EntityID',
        'Edit Field Details' => 'Edytuj szczegóły pola',
        'Customer interface does not support articles not visible for customers.' =>
            'Interfejs klienta nie wspiera wyświetlania artykułów niewidocznych dla klienta',
        'Sorry, the only existing parameter can\'t be removed.' => '',

        # JS File: Core.Agent.Admin.SMIME
        'Do you really want to delete this certificate?' => '',

        # JS File: Core.Agent.Admin.SupportDataCollector
        'Sending Update...' => 'Wysyłanie aktualizacji...',
        'Support Data information was successfully sent.' => '',
        'Was not possible to send Support Data information.' => '',
        'Update Result' => 'Wyślij wynik',
        'Generating...' => 'Generowanie...',
        'It was not possible to generate the Support Bundle.' => '',
        'Generate Result' => 'Generuj wynik',
        'Support Bundle' => 'Pakiet serwisowy',
        'The mail could not be sent' => 'Wiadomość nie mogła być wysłana',

        # JS File: Core.Agent.Admin.SysConfig.Entity
        'It is not possible to set this entry to invalid. All affected configuration settings have to be changed beforehand.' =>
            '',
        'Cannot proceed' => '',
        'Update manually' => '',
        'You can either have the affected settings updated automatically to reflect the changes you just made or do it on your own by pressing \'update manually\'.' =>
            '',
        'Save and update automatically' => '',
        'Don\'t save, update manually' => '',
        'The item you\'re currently viewing is part of a not-yet-deployed configuration setting, which makes it impossible to edit it in its current state. Please wait until the setting has been deployed. If you\'re unsure what to do next, please contact your system administrator.' =>
            '',

        # JS File: Core.Agent.Admin.SystemConfiguration
        'Loading...' => 'Ładowanie...',
        'Search the System Configuration' => '',
        'Please enter at least one search word to find anything.' => '',
        'Unfortunately deploying is currently not possible, maybe because another agent is already deploying. Please try again later.' =>
            '',
        'Deploy' => 'Wdróż',
        'The deployment is already running.' => 'Wdrażanie jest już aktualnie uruchomione.',
        'Deployment successful. You\'re being redirected...' => 'Wdrożenie udane. Zostaniesz przekierowany...',
        'There was an error. Please save all settings you are editing and check the logs for more information.' =>
            '',
        'Reset option is required!' => '',
        'By restoring this deployment all settings will be reverted to the value they had at the time of the deployment. Do you really want to continue?' =>
            '',
        'Keys with values can\'t be renamed. Please remove this key/value pair instead and re-add it afterwards.' =>
            '',
        'Unlock setting.' => '',

        # JS File: Core.Agent.Admin.SystemMaintenance
        'Do you really want to delete this scheduled system maintenance?' =>
            'Czy jesteś pewien, że chcesz usunąć zaplanowaną konserwację systemu?',

        # JS File: Core.Agent.Admin.Template
        'Delete this Template' => '',
        'Deleting the template and its data. This may take a while...' =>
            '',

        # JS File: Core.Agent.AppointmentCalendar
        'Jump' => 'Przejdź',
        'Timeline Month' => 'Widok Miesięczny',
        'Timeline Week' => 'Widok Tygodniowy',
        'Timeline Day' => 'Widok Dzienny',
        'Previous' => 'Poprzednie',
        'Resources' => 'Zasoby',
        'Su' => 'Nd',
        'Mo' => 'Pn',
        'Tu' => 'Wt',
        'We' => 'Śr',
        'Th' => 'Cz',
        'Fr' => 'Pt',
        'Sa' => 'So',
        'This is a repeating appointment' => 'To powtarzające wydarzenie',
        'Would you like to edit just this occurrence or all occurrences?' =>
            'Czy chciałbyś edytować tylko to wystąpienie czy wszystkie?',
        'All occurrences' => 'Wszystkie wystąpienia',
        'Just this occurrence' => 'Tylko to wystąpienie',
        'Too many active calendars' => 'Zbyt dużo aktywnych kalendarzy',
        'Please either turn some off first or increase the limit in configuration.' =>
            'Proszę wyłączyć kilka lub zwiększyć limit w konfiguracji.',
        'Restore default settings' => 'Przywróć ustawienia domyślne',
        'Are you sure you want to delete this appointment? This operation cannot be undone.' =>
            'Czy jesteś pewien, że chcesz usunąć to wydarzenie? Tej operacji nie można cofnąć.',

        # JS File: Core.Agent.CustomerSearch
        'First select a customer user, then select a customer ID to assign to this ticket.' =>
            '',
        'Duplicated entry' => 'Zduplikowana pozycja',
        'It is going to be deleted from the field, please try again.' => 'To zostanie usunięte z pola, spróbuj ponownie.',

        # JS File: Core.Agent.CustomerUserAddressBook
        'Please enter at least one search value or * to find anything.' =>
            'Wprowadź przynajmniej jedną wyszukiwaną wartość lub * aby znaleźć cokolwiek.',

        # JS File: Core.Agent.Daemon
        'Information about the OTRS Daemon' => 'Informacje o OTRS Daemon',

        # JS File: Core.Agent.Dashboard
        'Please check the fields marked as red for valid inputs.' => 'Proszę sprawdź poprawnośc danych w polach oznaczonych jako czerowne.',
        'month' => 'miesiąc',
        'Remove active filters for this widget.' => 'Usuń aktywne filtry dla tego widgeta.',

        # JS File: Core.Agent.LinkObject.SearchForm
        'Please wait...' => 'Proszę czekać...',
        'Searching for linkable objects. This may take a while...' => '',

        # JS File: Core.Agent.LinkObject
        'Do you really want to delete this link?' => 'Czy na pewno chcesz usunąć to połączenie?',

        # JS File: Core.Agent.Login
        'Are you using a browser plugin like AdBlock or AdBlockPlus? This can cause several issues and we highly recommend you to add an exception for this domain.' =>
            'Czy używasz wtyczki typu AdBlock lub AdBlockPlus w swojej przeglądarce? To może powodować wiele problemów i dlatego gorąco zalecamy dodanie wyjątku we wtyczce dla tej domeny.',
        'Do not show this warning again.' => '',

        # JS File: Core.Agent.Preferences
        'Sorry, but you can\'t disable all methods for notifications marked as mandatory.' =>
            '',
        'Sorry, but you can\'t disable all methods for this notification.' =>
            '',
        'Please note that at least one of the settings you have changed requires a page reload. Click here to reload the current screen.' =>
            '',
        'An unknown error occurred. Please contact the administrator.' =>
            '',

        # JS File: Core.Agent.Responsive
        'Switch to desktop mode' => 'Przełącz na pełną wersję strony',

        # JS File: Core.Agent.Search
        'Please remove the following words from your search as they cannot be searched for:' =>
            '',

        # JS File: Core.Agent.SharedSecretGenerator
        'Generate' => '',

        # JS File: Core.Agent.SortedTree
        'This element has children elements and can currently not be removed.' =>
            '',

        # JS File: Core.Agent.Statistics
        'Do you really want to delete this statistic?' => 'Czy na pewno chcesz usunąć tą statystykę?',

        # JS File: Core.Agent.TicketAction
        'Select a customer ID to assign to this ticket' => '',
        'Do you really want to continue?' => 'Czy jesteś pewien, że chcesz kontynuować?',

        # JS File: Core.Agent.TicketBulk
        ' ...and %s more' => '...i %s więcej',
        ' ...show less' => '...pokaż mniej',

        # JS File: Core.Agent.TicketFormDraft
        'Add new draft' => 'Dodaj nowy szkic',
        'Delete draft' => 'Usuń szkic',
        'There are no more drafts available.' => 'Nie ma więcej dostępnych szkiców.',
        'It was not possible to delete this draft.' => 'Usunięcie szkicu jest niemożliwe.',

        # JS File: Core.Agent.TicketZoom
        'Article filter' => 'Filtr wiadomości',
        'Apply' => 'Zastosuj',
        'Event Type Filter' => 'Filtr typu zdarzenia',

        # JS File: Core.Agent
        'Slide the navigation bar' => 'Wysuń panel nawigacji',
        'Please turn off Compatibility Mode in Internet Explorer!' => 'Proszę wyłącz Widok Zgodności w Internet Explorerze!',
        'Find out more' => '',

        # JS File: Core.App.Responsive
        'Switch to mobile mode' => 'Przełącz na wersję mobilną',

        # JS File: Core.App
        'Error: Browser Check failed!' => '',
        'Reload page' => 'Przeładuj stronę',
        'Reload page (%ss)' => '',

        # JS File: Core.Debug
        'Namespace %s could not be initialized, because %s could not be found.' =>
            '',

        # JS File: Core.Exception
        'An error occurred! Please check the browser error log for more details!' =>
            '',

        # JS File: Core.Form.Validate
        'One or more errors occurred!' => 'Wystąpił jeden lub więcej błędów!',

        # JS File: Core.Installer
        'Mail check successful.' => 'Sprawdzanie poczty e-mail zakończone pomyślnie.',
        'Error in the mail settings. Please correct and try again.' => 'Błąd w ustawieniach poczty. Popraw i spróbuj ponownie.',

        # JS File: Core.SystemConfiguration
        'Open this node in a new window' => '',
        'Please add values for all keys before saving the setting.' => '',
        'The key must not be empty.' => '',
        'A key with this name (\'%s\') already exists.' => '',
        'Do you really want to revert this setting to its historical value?' =>
            '',

        # JS File: Core.UI.Datepicker
        'Open date selection' => 'Otwórz wybór daty',
        'Invalid date (need a future date)!' => 'Niepoprawna data (wymagana przyszła data)!',
        'Invalid date (need a past date)!' => 'Nieprawidłowa data (wymagana data przeszła)!',

        # JS File: Core.UI.InputFields
        'Not available' => 'Nie dostępne',
        'and %s more...' => 'oraz %s więcej...',
        'Show current selection' => '',
        'Current selection' => '',
        'Clear all' => 'Wyczyść',
        'Filters' => 'Filtry',
        'Clear search' => 'Wyczyść szukanie',

        # JS File: Core.UI.Popup
        'If you now leave this page, all open popup windows will be closed, too!' =>
            'Jeśli opuścisz tę stronę, wszystkie okna popup będą również zamknięte!',
        'A popup of this screen is already open. Do you want to close it and load this one instead?' =>
            'Okno popup tej strony jest wciąż otwarte. Czy chcesz je zamknąć i załadować zamiast niego to okno?',
        'Could not open popup window. Please disable any popup blockers for this application.' =>
            'Nie można otworzyć okna popup. Usuń wszelkie blokady popup-ów dla tej aplikacji.',

        # JS File: Core.UI.Table.Sort
        'Ascending sort applied, ' => '',
        'Descending sort applied, ' => '',
        'No sort applied, ' => '',
        'sorting is disabled' => '',
        'activate to apply an ascending sort' => '',
        'activate to apply a descending sort' => '',
        'activate to remove the sort' => '',

        # JS File: Core.UI.Table
        'Remove the filter' => '',

        # JS File: Core.UI.TreeSelection
        'There are currently no elements available to select from.' => 'Obecnie nie ma jeszcze elementów z których można by wybrać.',

        # JS File: Core.UI
        'Please only select one file for upload.' => '',
        'Sorry, you can only upload one file here.' => '',
        'Sorry, you can only upload %s files.' => '',
        'Please only select at most %s files for upload.' => '',
        'The following files are not allowed to be uploaded: %s' => '',
        'The following files exceed the maximum allowed size per file of %s and were not uploaded: %s' =>
            '',
        'The following files were already uploaded and have not been uploaded again: %s' =>
            '',
        'No space left for the following files: %s' => '',
        'Available space %s of %s.' => '',
        'Upload information' => '',
        'An unknown error occurred when deleting the attachment. Please try again. If the error persists, please contact your system administrator.' =>
            '',

        # JS File: Core.Language.UnitTest
        'yes' => 'tak',
        'no' => 'nie',
        'This is %s' => '',
        'Complex %s with %s arguments' => '',

        # JS File: OTRSLineChart
        'No Data Available.' => '',

        # JS File: OTRSMultiBarChart
        'Grouped' => 'Pogrupowane',
        'Stacked' => 'Zestakowane',

        # JS File: OTRSStackedAreaChart
        'Stream' => 'Stream',
        'Expanded' => 'Rozszerzony',

        # SysConfig
        '
Dear Customer,

Unfortunately we could not detect a valid ticket number
in your subject, so this email can\'t be processed.

Please create a new ticket via the customer panel.

Thanks for your help!

 Your Helpdesk Team
' => '',
        ' (work units)' => ' (jednostki pracy)',
        ' 2 minutes' => ' 2 minuty',
        ' 5 minutes' => ' 5 minut',
        ' 7 minutes' => ' 7 minut',
        '"Slim" skin which tries to save screen space for power users.' =>
            '',
        '%s' => '%s',
        '(UserLogin) Firstname Lastname' => '(Login) Imię Nazwisko',
        '(UserLogin) Lastname Firstname' => '(Login) Nazwisko Imię',
        '(UserLogin) Lastname, Firstname' => '(Login) Nazwisko, Imię',
        '*** out of office until %s (%s d left) ***' => '',
        '0 - Disabled' => '0 - Wyłączone',
        '1 - Available' => '1 - Dostępne',
        '1 - Enabled' => '1 - Włączone',
        '10 Minutes' => '10 Minut',
        '100 (Expert)' => '',
        '15 Minutes' => '15 Minut',
        '2 - Enabled and required' => '',
        '2 - Enabled and shown by default' => '',
        '2 - Enabled by default' => '2 - Włączone domyślnie',
        '2 Minutes' => '2 Minuty',
        '200 (Advanced)' => '200 (Zaawansowane)',
        '30 Minutes' => '',
        '300 (Beginner)' => '',
        '5 Minutes' => '',
        'A TicketWatcher Module.' => '',
        'A Website' => 'Strona internetowa',
        'A list of dynamic fields that are merged into the main ticket during a merge operation. Only dynamic fields that are empty in the main ticket will be set.' =>
            '',
        'A picture' => 'Obrazek',
        'ACL module that allows closing parent tickets only if all its children are already closed ("State" shows which states are not available for the parent ticket until all child tickets are closed).' =>
            'Moduł ACL pozwala na zamykanie nadrzędnych zgłoszeń, tylko wówczas, gdy wszystkie podrzędne są już zamknięte ("Stan" pokazuje, które stany nie są dostępne dla zgłoszenia nadrzędnego, aż do momentu zamknięcia wszystkich podrzędnych).',
        'Access Control Lists (ACL)' => 'Lista Kontroli dostępu (ACL)',
        'AccountedTime' => 'Ubiegły czas',
        'Activates a blinking mechanism of the queue that contains the oldest ticket.' =>
            'Aktywuje mechanizm pulsowania kolejki dla najstarszych zgłoszeń.',
        'Activates lost password feature for agents, in the agent interface.' =>
            'Aktywuje funkcjonalność ozdyskania hasła dla agentów w interfejsie agenta.',
        'Activates lost password feature for customers.' => 'Aktywuje funkcjonalność ozdyskania hasła dla klientów',
        'Activates support for customer and customer user groups.' => '',
        'Activates the article filter in the zoom view to specify which articles should be shown.' =>
            'W widoku rozszerzonym aktywuje filtr wiadomości umożliwiający wybór, które artykuły powinny być widoczne.',
        'Activates the available themes on the system. Value 1 means active, 0 means inactive.' =>
            'Aktywuje dostepne motywy w systeie. Watrość 1 oznacza aktywację, 0 oznacza deaktywację.',
        'Activates the ticket archive system search in the customer interface.' =>
            'Aktywuje archiwum systemu zgłoszeń w interfejsie klienta.',
        'Activates the ticket archive system to have a faster system by moving some tickets out of the daily scope. To search for these tickets, the archive flag has to be enabled in the ticket search.' =>
            'Aktywuje archiwum złoszeń by uzyskać szybsze działanie systemu poprzez przeniesienie zgłoszeń z dziennego zakresu. By wyszukiwać te zgłoszenia flaga archiwum musi zostać aktywowana w oknie wyszukiwania zgłoszeń.',
        'Activates time accounting.' => 'Aktywuje rozliczanie czasu.',
        'ActivityID' => '',
        'Add a note to this ticket' => 'Dodaj notatkę do tego zgłoszenia',
        'Add an inbound phone call to this ticket' => '',
        'Add an outbound phone call to this ticket' => '',
        'Added %s time unit(s), for a total of %s time unit(s).' => '',
        'Added email. %s' => 'Dodano e-mail. %s',
        'Added follow-up to ticket [%s]. %s' => '',
        'Added link to ticket "%s".' => 'Dodano łącze do zgłoszenia "%s".',
        'Added note (%s).' => '',
        'Added phone call from customer.' => '',
        'Added phone call to customer.' => '',
        'Added subscription for user "%s".' => 'Dodano subskrypcje dla użytkownika "%s".',
        'Added system request (%s).' => '',
        'Added web request from customer.' => '',
        'Adds a suffix with the actual year and month to the OTRS log file. A logfile for every month will be created.' =>
            '',
        'Adds customers email addresses to recipients in the ticket compose screen of the agent interface. The customers email address won\'t be added if the article type is email-internal.' =>
            '',
        'Adds the one time vacation days for the indicated calendar.' => '',
        'Adds the one time vacation days.' => '',
        'Adds the permanent vacation days for the indicated calendar.' =>
            '',
        'Adds the permanent vacation days.' => '',
        'Admin' => 'Administracja',
        'Admin Area.' => '',
        'Admin Notification' => 'Powiadomienia administratora',
        'Admin area navigation for the agent interface.' => '',
        'Admin modules overview.' => 'Przegląd modułów Adminsitratora',
        'Admin.' => 'Admin',
        'Administration' => 'Administracja',
        'Agent Customer Search' => '',
        'Agent Customer Search.' => '',
        'Agent Name' => 'Imię i nazwisko Agenta',
        'Agent Name + FromSeparator + System Address Display Name' => 'Imię i nazwisko agenta + Separator + Systemowy adres ',
        'Agent Preferences.' => 'Preferencje Agenta',
        'Agent Statistics.' => 'Statystyki Agenta',
        'Agent User Search' => '',
        'Agent User Search.' => '',
        'Agent interface article notification module to check PGP.' => 'Interfejs agenta w module powiadomień PGP',
        'Agent interface article notification module to check S/MIME.' =>
            'Interfejs agenta w module powiadomień S/MIME',
        'Agent interface module to access CIC search via nav bar. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Agent interface module to access fulltext search via nav bar. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Agent interface module to access search profiles via nav bar. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Agent interface module to check incoming emails in the Ticket-Zoom-View if the S/MIME-key is available and true.' =>
            '',
        'Agent interface notification module to see the number of locked tickets. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Agent interface notification module to see the number of tickets an agent is responsible for. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Agent interface notification module to see the number of tickets in My Services. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Agent interface notification module to see the number of watched tickets. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'AgentTicketZoom widget that displays a table of objects linked to the ticket.' =>
            '',
        'AgentTicketZoom widget that displays customer information for the ticket in the side bar.' =>
            '',
        'AgentTicketZoom widget that displays ticket data in the side bar.' =>
            '',
        'Agents ↔ Groups' => 'Agenci ↔ Grupy',
        'Agents ↔ Roles' => 'Agenci ↔ Role',
        'All CustomerIDs of a customer user.' => '',
        'All attachments (OTRS Business Solution™)' => '',
        'All customer users of a CustomerID' => 'Wszyscy użytkownicy  z identyfikatorem klienta',
        'All escalated tickets' => 'Wszystkie eskalowane zgłoszenia',
        'All new tickets, these tickets have not been worked on yet' => 'Wszystkie nowe zgłoszenia, nie podjęto jeszcze prac w związku z nimi',
        'All open tickets, these tickets have already been worked on.' =>
            '',
        'All tickets with a reminder set where the reminder date has been reached' =>
            'Wszystkie zgłoszenia z ustawionym przypomnieniem, dla których minął czas przypomnienia',
        'Allows adding notes in the close ticket screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Pozwala na dodawanie notatek w oknie zamknięcia zgłoszenia interfejsu agenta. Może być nadpisane przez Ticket::Frontend::NeedAccountedTime.',
        'Allows adding notes in the ticket free text screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Pozwala na dodawanie notatek w oknie pól dodatkowych interfejsu agenta. Może być nadpisane przez Ticket::Frontend::NeedAccountedTime.',
        'Allows adding notes in the ticket note screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Pozwala na dodawanie notatek w oknie dodawania notatek interfejsu agenta. Może być nadpisane przez Ticket::Frontend::NeedAccountedTime.',
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
        'Allows customers to set the ticket queue in the customer interface. If this is not enabled, QueueDefault should be configured.' =>
            '',
        'Allows customers to set the ticket service in the customer interface.' =>
            'Pozwala klientom na ustawienie serwisu złoszenia w interfejsie klienta.',
        'Allows customers to set the ticket type in the customer interface. If this is not enabled, TicketTypeDefault should be configured.' =>
            '',
        'Allows default services to be selected also for non existing customers.' =>
            'Pozwala na wybranie domyślnych serwisów dla nieistniejącyh klientów.',
        'Allows defining services and SLAs for tickets (e. g. email, desktop, network, ...), and escalation attributes for SLAs (if ticket service/SLA feature is enabled).' =>
            '',
        'Allows extended search conditions in ticket search of the agent interface. With this feature you can search e. g. ticket title with this kind of conditions like "(*key1*&&*key2*)" or "(*key1*||*key2*)".' =>
            '',
        'Allows extended search conditions in ticket search of the customer interface. With this feature you can search e. g. ticket title with this kind of conditions like "(*key1*&&*key2*)" or "(*key1*||*key2*)".' =>
            '',
        'Allows extended search conditions in ticket search of the generic agent interface. With this feature you can search e. g. ticket title with this kind of conditions like "(*key1*&&*key2*)" or "(*key1*||*key2*)".' =>
            '',
        'Allows generic agent to execute custom command line scripts.' =>
            '',
        'Allows generic agent to execute custom modules.' => '',
        'Allows having a medium format ticket overview (CustomerInfo => 1 - shows also the customer information).' =>
            '',
        'Allows having a small format ticket overview (CustomerInfo => 1 - shows also the customer information).' =>
            '',
        'Allows invalid agents to generate individual-related stats.' => '',
        'Allows the administrators to login as other customers, via the customer user administration panel.' =>
            'Pozwala administratorom na logowanie się jako inni użytkownicy, poprzez panel administracyjny użytkowników.',
        'Allows the administrators to login as other users, via the users administration panel.' =>
            'Pozwala administratorom na logowanie się jako inni użytkownicy poprzez panel administracyjny użytkowników.',
        'Allows to save current work as draft in the close ticket screen of the agent interface.' =>
            'Pozwala na zapisanie bieżącej pracy jako szkicu na ekranie zamykania zgłoszenia w interfejsie agenta.',
        'Allows to save current work as draft in the email outbound screen of the agent interface.' =>
            'Pozwala na zapisanie bieżącej pracy jako szkicu na ekranie emaila wychodzącego w interfejsie agenta.',
        'Allows to save current work as draft in the ticket compose screen of the agent interface.' =>
            'Pozwala na zapisanie bieżącej pracy jako szkicu na ekranie tworzenia zgłoszenia w interfejsie agenta.',
        'Allows to save current work as draft in the ticket forward screen of the agent interface.' =>
            'Pozwala na zapisanie bieżącej pracy jako szkicu na ekranie przekazywania zgłoszenia w interfejsie agenta.',
        'Allows to save current work as draft in the ticket free text screen of the agent interface.' =>
            'Pozwala na zapisanie bieżącej pracy jako szkicu na ekranie notatki tekstowej zgłoszenia w interfejsie agenta.',
        'Allows to save current work as draft in the ticket move screen of the agent interface.' =>
            'Pozwala na zapisanie bieżącej pracy jako szkicu na ekranie przenoszenia zgłoszenia w interfejsie agenta.',
        'Allows to save current work as draft in the ticket note screen of the agent interface.' =>
            'Pozwala na zapisanie bieżącej pracy jako szkicu na ekranie notatki do  zgłoszenia w interfejsie agenta.',
        'Allows to save current work as draft in the ticket owner screen of the agent interface.' =>
            'Pozwala na zapisanie bieżącej pracy jako szkicu na ekranie właściciela zgłoszenia w interfejsie agenta.',
        'Allows to save current work as draft in the ticket pending screen of the agent interface.' =>
            'Pozwala na zapisanie bieżącej pracy jako szkicu na ekranie przypomnienia zgłoszenia w interfejsie agenta.',
        'Allows to save current work as draft in the ticket phone inbound screen of the agent interface.' =>
            'Pozwala na zapisanie bieżącej pracy jako szkicu na ekranie telefonu przychodzącego do zgłoszenia w interfejsie agenta.',
        'Allows to save current work as draft in the ticket phone outbound screen of the agent interface.' =>
            'Pozwala na zapisanie bieżącej pracy jako szkicu na ekranie telefonu wychodzącego do  zgłoszenia w interfejsie agenta.',
        'Allows to save current work as draft in the ticket priority screen of the agent interface.' =>
            'Pozwala na zapisanie bieżącej pracy jako szkicu na ekranie priorytetu zgłoszenia w interfejsie agenta.',
        'Allows to save current work as draft in the ticket responsible screen of the agent interface.' =>
            '',
        'Allows to set a new ticket state in the move ticket screen of the agent interface.' =>
            '',
        'Always show RichText if available' => '',
        'Answer' => 'Odpowiedz',
        'Appointment Calendar overview page.' => 'Strona podsumowująca Kalendarz Wydarzeń',
        'Appointment Notifications' => 'Powiadomienia Wydarzeń',
        'Appointment calendar event module that prepares notification entries for appointments.' =>
            '',
        'Appointment calendar event module that updates the ticket with data from ticket appointment.' =>
            '',
        'Appointment edit screen.' => 'Ekran edycji wydarzeń.',
        'Appointment list' => 'Lista wydarzeń',
        'Appointment list.' => 'Lista wydarzeń.',
        'Appointment notifications' => 'Powiadomienia wydarzeń',
        'Appointments' => 'Wydarzenia',
        'Arabic (Saudi Arabia)' => '',
        'ArticleTree' => 'Drzewo z artykułami',
        'Attachment Name' => 'Nazwa załącznika',
        'Automated line break in text messages after x number of chars.' =>
            '',
        'Automatically change the state of a ticket with an invalid owner once it is unlocked. Maps from a state type to a new ticket state.' =>
            '',
        'Automatically lock and set owner to current Agent after opening the move ticket screen of the agent interface.' =>
            '',
        'Automatically lock and set owner to current Agent after selecting for an Bulk Action.' =>
            '',
        'Automatically sets the owner of a ticket as the responsible for it (if ticket responsible feature is enabled). This will only work by manually actions of the logged in user. It does not work for automated actions e.g. GenericAgent, Postmaster and GenericInterface.' =>
            'Automatycznie ustawia właściciela zgłoszenia jako odpowiedzialnego za nie (jeżeli funkcjonlaność odpowiedzialnego jest włączona). Zadziała tylko w przypadku ręcznych działań zalogowanego użytkownika. Nie zadziała w przypadku akcji wykonywanych automatycznie przez np. Agenta automatycznego, Postmastera lub GenericInterface.',
        'Automatically sets the responsible of a ticket (if it is not set yet) after the first owner update.' =>
            '',
        'Avatar' => '',
        'Balanced white skin by Felix Niklas (slim version).' => 'Biała zbalansowana skóra Felix Niklas (wersja odchudzona).',
        'Balanced white skin by Felix Niklas.' => 'Biała zbalansowana skóra Felix Niklas.',
        'Based on global RichText setting' => '',
        'Basic fulltext index settings. Execute "bin/otrs.Console.pl Maint::Ticket::FulltextIndex --rebuild" in order to generate a new index.' =>
            '',
        'Blocks all the incoming emails that do not have a valid ticket number in subject with From: @example.com address.' =>
            'Blokuje wszystkie przychodzące maile które nie posiadają ważnego numeru zgłoszenia w temacie z adresu: przyklad.pl.',
        'Bounced to "%s".' => 'Przekazano do "%s".',
        'Bulgarian' => '',
        'Bulk Action' => 'Zbiorcze działanie',
        'CMD example setup. Ignores emails where external CMD returns some output on STDOUT (email will be piped into STDIN of some.bin).' =>
            '',
        'CSV Separator' => 'Separator CSV',
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
        'Calendar manage screen.' => 'Ekran zarządzania Kalendarzem',
        'Catalan' => '',
        'Change password' => 'Zmień hasło',
        'Change queue!' => 'Zmień kolejkę!',
        'Change the customer for this ticket' => 'Zmień klienta tego zgłoszenia',
        'Change the free fields for this ticket' => 'Zmień pola dodatkowe tego zgłoszenia',
        'Change the owner for this ticket' => 'Zmień właściciela tego zgłoszenia',
        'Change the priority for this ticket' => 'Zmień priorytet zgłoszenia',
        'Change the responsible for this ticket' => 'Zmień odpowiedzialnego za ten ticket',
        'Change your avatar image.' => '',
        'Change your password and more.' => '',
        'Changed SLA to "%s" (%s).' => 'Zmieniono SLA z "%s" (%s).',
        'Changed archive state to "%s".' => '',
        'Changed customer to "%s".' => '',
        'Changed dynamic field %s from "%s" to "%s".' => '',
        'Changed owner to "%s" (%s).' => '',
        'Changed pending time to "%s".' => '',
        'Changed priority from "%s" (%s) to "%s" (%s).' => 'Zmieniono priorytet z "%s" (%s) na "%s" (%s).',
        'Changed queue to "%s" (%s) from "%s" (%s).' => '',
        'Changed responsible to "%s" (%s).' => '',
        'Changed service to "%s" (%s).' => '',
        'Changed state from "%s" to "%s".' => '',
        'Changed title from "%s" to "%s".' => '',
        'Changed type from "%s" (%s) to "%s" (%s).' => '',
        'Changes the owner of tickets to everyone (useful for ASP). Normally only agent with rw permissions in the queue of the ticket will be shown.' =>
            'Zmienia właściciela zgłoszeń dla wszyscy (użyteczne dla ASP). Zwykle widoczny będzie tylko agent z prawami rw do kolejki.',
        'Chat communication channel.' => '',
        'Checkbox' => 'Pole wyboru',
        'Checks for articles that needs to be updated in the article search index.' =>
            '',
        'Checks for communication log entries to be deleted.' => '',
        'Checks for queued outgoing emails to be sent.' => '',
        'Checks if an E-Mail is a followup to an existing ticket by searching the subject for a valid ticket number.' =>
            '',
        'Checks if an email is a follow-up to an existing ticket with external ticket number which can be found by ExternalTicketNumberRecognition filter module.' =>
            '',
        'Checks the SystemID in ticket number detection for follow-ups. If not enabled, SystemID will be changed after using the system.' =>
            '',
        'Checks the availability of OTRS Business Solution™ for this system.' =>
            '',
        'Checks the entitlement status of OTRS Business Solution™.' => '',
        'Child' => 'Potomek',
        'Chinese (Simplified)' => 'Chiński (Uproszczony)',
        'Chinese (Traditional)' => 'Chiński (Tradycyjny)',
        'Choose for which kind of appointment changes you want to receive notifications.' =>
            'Wybierz, dla jakiego rodzaju zmian w wydarzeniach, chcesz otrzymywać powiadomienia.',
        'Choose for which kind of ticket changes you want to receive notifications. Please note that you can\'t completely disable notifications marked as mandatory.' =>
            'Wybierz, dla jakich rodzajów zmian w zgłoszeniach, chcesz otrzymywać powiadomienia. Zauważ, że nie można całkowicie wyłączyć powiadomień oznaczonych jako obowiązkowe.',
        'Choose which notifications you\'d like to receive.' => '',
        'Christmas Eve' => 'Wigilia Bożego Narodzenia',
        'Close' => 'Zamknij',
        'Close this ticket' => 'Zamknij to zgłoszenie',
        'Closed tickets (customer user)' => 'Zamknięte zgłoszenia (użytkownik)',
        'Closed tickets (customer)' => 'Zamknięte zgłoszenia (klient)',
        'Cloud Services' => 'Usługi w chmurze',
        'Cloud service admin module registration for the transport layer.' =>
            '',
        'Collect support data for asynchronous plug-in modules.' => '',
        'Column ticket filters for Ticket Overviews type "Small".' => 'Kolumna filtrów zgłoszeń dla "małego" Podglądu Zgłoszeń.',
        'Columns that can be filtered in the escalation view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '',
        'Columns that can be filtered in the locked view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '',
        'Columns that can be filtered in the queue view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '',
        'Columns that can be filtered in the responsible view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '',
        'Columns that can be filtered in the service view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '',
        'Columns that can be filtered in the status view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '',
        'Columns that can be filtered in the ticket search result view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '',
        'Columns that can be filtered in the watch view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '',
        'Comment for new history entries in the customer interface.' => 'Komenntarz dla nowych wspisów historii w interfejsie klienta.',
        'Comment2' => '',
        'Communication' => 'Komunikacja',
        'Communication & Notifications' => '',
        'Communication Log GUI' => '',
        'Communication log limit per page for Communication Log Overview.' =>
            '',
        'CommunicationLog Overview Limit' => '',
        'Company Status' => 'Stan firmy',
        'Company Tickets.' => 'Zgłoszenia firmy.',
        'Company name which will be included in outgoing emails as an X-Header.' =>
            'Nazwa firmy, która zostanie dodana w nagłówku X-Header wychodzącej poczty e-mail.',
        'Compat module for AgentZoom to AgentTicketZoom.' => '',
        'Complex' => '',
        'Compose' => 'Utwórz',
        'Configure Processes.' => 'Konfiguracja procesów.',
        'Configure and manage ACLs.' => 'Konfiguruj i zarządzaj ACLami.',
        'Configure any additional readonly mirror databases that you want to use.' =>
            '',
        'Configure sending of support data to OTRS Group for improved support.' =>
            '',
        'Configure which screen should be shown after a new ticket has been created.' =>
            'Określ, jaki ekran powinien wyświetlić się po utworzeniu nowego zgłoszenia.',
        'Configure your own log text for PGP.' => 'Skonfiguruj swój własny tekst-log dla PGP.',
        'Configures a default TicketDynamicField setting. "Name" defines the dynamic field which should be used, "Value" is the data that will be set, and "Event" defines the trigger event. Please check the developer manual (https://doc.otrs.com/doc/), chapter "Ticket Event Module".' =>
            '',
        'Controls how to display the ticket history entries as readable values.' =>
            '',
        'Controls if CustomerID is automatically copied from the sender address for unknown customers.' =>
            '',
        'Controls if CustomerID is read-only in the agent interface.' => '',
        'Controls if customers have the ability to sort their tickets.' =>
            'Kontroluje czy klienci mają możliwość sortowania swoimi zgłoszeniami.',
        'Controls if more than one from entry can be set in the new phone ticket in the agent interface.' =>
            'Kontroluje czy więcej niż jedna pozycja może być zaznaczona przy zgłoszeniu telefonicznym w panelu agenta.',
        'Controls if the admin is allowed to import a saved system configuration in SysConfig.' =>
            '',
        'Controls if the admin is allowed to make changes to the database via AdminSelectBox.' =>
            '',
        'Controls if the autocomplete field will be used for the customer ID selection in the AdminCustomerUser interface.' =>
            '',
        'Controls if the ticket and article seen flags are removed when a ticket is archived.' =>
            'Kontroluje czy flagi zgłoszenia i artykułu są usunięte kiedy zgłoszenie jest zarchiwizowane.',
        'Converts HTML mails into text messages.' => 'Konwertuję e-maile HTML do tekstowych',
        'Create New process ticket.' => '',
        'Create Ticket' => 'Utwórz Zgłoszenie',
        'Create a new calendar appointment linked to this ticket' => 'Utwórz nowy kalendarz wydarzeń połączony z tym zgłoszeniem',
        'Create and manage Service Level Agreements (SLAs).' => 'Twórz i zarządzaj poziomami SLA.',
        'Create and manage agents.' => 'Zarządzanie listą agentów.',
        'Create and manage appointment notifications.' => 'Utwórz i zarządzaj powiadomieniami wydarzeń.',
        'Create and manage attachments.' => 'Ustawienia standardowych załączników.',
        'Create and manage calendars.' => 'Twórz i zarządzaj kalendarzami.',
        'Create and manage customer users.' => 'Tworzenie i modyfikacja użytkowników klienta.',
        'Create and manage customers.' => 'Tworzenie i modyfikacja klientów',
        'Create and manage dynamic fields.' => 'Zarządzanie polami dynamicznymi.',
        'Create and manage groups.' => 'Ustawienia grup agentów.',
        'Create and manage queues.' => 'Ustawienia kolejek zgłoszeń.',
        'Create and manage responses that are automatically sent.' => 'Ustawienia szablonów odpowiedzi automatycznych.',
        'Create and manage roles.' => 'Zarządzanie rolami systemowymi.',
        'Create and manage salutations.' => 'Ustawienia szablonów powitań.',
        'Create and manage services.' => 'Tworzenie i zarządzanie usługami.',
        'Create and manage signatures.' => 'Ustawienia szablonów podpisów.',
        'Create and manage templates.' => 'Zarządzanie szablonami.',
        'Create and manage ticket notifications.' => 'Dodaj i modyfikuj powiadomienia o zgłoszeniach',
        'Create and manage ticket priorities.' => 'Ustawianie priorytetów zgłoszeń.',
        'Create and manage ticket states.' => 'Twórz i zarządzaj stanami zgłoszeń.',
        'Create and manage ticket types.' => 'Ustawienia typów zgłoszeń.',
        'Create and manage web services.' => 'Zarządzanie serwisami sieciowymi.',
        'Create new Ticket.' => 'Utwórz nowe zgłoszenie',
        'Create new appointment.' => 'Utwórz nowe wydarzenie.',
        'Create new email ticket and send this out (outbound).' => 'Utwórz nowe zgłoszenie email i wyślij je (na zewnątrz)',
        'Create new email ticket.' => 'Utwórz nowy zgłoszenie Email.',
        'Create new phone ticket (inbound).' => 'Utwórz nowe zgłoszenie telefoniczne (wewnętrzne).',
        'Create new phone ticket.' => 'Utwórz nowe zgłoszenie telefoniczne.',
        'Create new process ticket.' => '',
        'Create tickets.' => 'Utwórz zgłoszenia.',
        'Created ticket [%s] in "%s" with priority "%s" and state "%s".' =>
            '',
        'Croatian' => 'Chorwacki',
        'Custom RSS Feed' => '',
        'Custom RSS feed.' => 'Niestandardowe źródło RSS',
        'Custom text for the page shown to customers that have no tickets yet (if you need those text translated add them to a custom translation module).' =>
            '',
        'Customer Administration' => 'Zarządzanie klientami',
        'Customer Companies' => 'Firmy klientów',
        'Customer IDs' => '',
        'Customer Information Center Search.' => '',
        'Customer Information Center search.' => 'Wyszukiwanie w Centrum informacji o Kliencie.',
        'Customer Information Center.' => 'Centrum Informacji o Kliencie',
        'Customer Ticket Print Module.' => '',
        'Customer User Administration' => 'Zarządzanie użytkownikami klientów',
        'Customer User Information' => '',
        'Customer User Information Center Search.' => 'Wyszukiwanie w Centrum Informacji o użytkowniku klienta.',
        'Customer User Information Center search.' => 'Wyszukiwanie w Centrum Informacji o użytkowniku klienta.',
        'Customer User Information Center.' => 'Centrum Informacji o użytkowniku klienta.',
        'Customer Users ↔ Customers' => 'Użytkownicy Klientów ↔ Klienci',
        'Customer Users ↔ Groups' => 'Użytkownicy Klienta ↔ Grupy',
        'Customer Users ↔ Services' => 'Użytkownicy Klienta ↔ Usługi',
        'Customer item (icon) which shows the closed tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            '',
        'Customer item (icon) which shows the open tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            '',
        'Customer preferences.' => 'Właściwości klienta',
        'Customer ticket overview' => '',
        'Customer ticket search.' => '',
        'Customer ticket zoom' => '',
        'Customer user search' => 'Wyszukiwanie uzytkowników',
        'CustomerID search' => '',
        'CustomerName' => 'Imię i nazwisko użytkownika',
        'CustomerUser' => 'Imię i nazwisko użytkownika',
        'Customers ↔ Groups' => 'Klienci ↔ Grupy',
        'Customizable stop words for fulltext index. These words will be removed from the search index.' =>
            '',
        'Czech' => 'Czeski',
        'Danish' => 'Duński',
        'Dashboard overview.' => 'Przegląd pulpitu.',
        'Data used to export the search result in CSV format.' => 'Dane używane przy eksporcie wyników wyszukiwania do formatu CSV.',
        'Date / Time' => 'Data / Czas',
        'Default (Slim)' => '',
        'Default ACL values for ticket actions.' => 'Domyślne wartości ACL dla zgłoszeń.',
        'Default ProcessManagement entity prefixes for entity IDs that are automatically generated.' =>
            '',
        'Default agent name' => '',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimePointFormat=year;TicketCreateTimePointStart=Last;TicketCreateTimePoint=2;".' =>
            '',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimeStartYear=2010;TicketCreateTimeStartMonth=10;TicketCreateTimeStartDay=4;TicketCreateTimeStopYear=2010;TicketCreateTimeStopMonth=11;TicketCreateTimeStopDay=3;".' =>
            '',
        'Default display type for recipient (To,Cc) names in AgentTicketZoom and CustomerTicketZoom.' =>
            '',
        'Default display type for sender (From) names in AgentTicketZoom and CustomerTicketZoom.' =>
            '',
        'Default loop protection module.' => 'Domyślny moduł pętli ochronnej',
        'Default queue ID used by the system in the agent interface.' => 'Domyślne ID kolejki uzywane przez system w interfejsie agenta.',
        'Default skin for the agent interface (slim version).' => 'Domyślna skóra dla interfejsu agentów (wersja odchudzona).',
        'Default skin for the agent interface.' => 'Domyślna skóra dla interfejsu agentów.',
        'Default skin for the customer interface.' => '',
        'Default ticket ID used by the system in the agent interface.' =>
            'Domyślne ID zgłoszenia używane przez system w interfejsie agenta.',
        'Default ticket ID used by the system in the customer interface.' =>
            'Domyślne ID zgłoszenia używane przez system w interfejsie klienta.',
        'Default value for NameX' => 'Domyślna wartość dla NazwyX',
        'Define Actions where a settings button is available in the linked objects widget (LinkObject::ViewMode = "complex"). Please note that these Actions must have registered the following JS and CSS files: Core.AllocationList.css, Core.UI.AllocationList.js, Core.UI.Table.Sort.js, Core.Agent.TableFilters.js.' =>
            '',
        'Define a filter for html output to add links behind a defined string. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Definicja filtru wyświetlania HTML dodającego linki pod wskazanym ciągiem znaków. Element Image pozwala na dwa rodzaje danych. Może to być nazwa grafiki (np. faq.png) i wtedy zostanie użyta ścieżka dostępu do grafik OTRS. Drugą możliwością jest podanie linku do grafiki.',
        'Define a mapping between variables of the customer user data (keys) and dynamic fields of a ticket (values). The purpose is to store customer user data in ticket dynamic fields. The dynamic fields must be present in the system and should be enabled for AgentTicketFreeText, so that they can be set/updated manually by the agent. They mustn\'t be enabled for AgentTicketPhone, AgentTicketEmail and AgentTicketCustomer. If they were, they would have precedence over the automatically set values. To use this mapping, you have to also activate the Ticket::EventModulePost###4100-DynamicFieldFromCustomerUser setting.' =>
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
        'Define which avatar default image should be used for the article view if no gravatar is assigned to the mail address. Check https://gravatar.com/site/implement/images/ for further information.' =>
            '',
        'Define which avatar default image should be used for the current agent if no gravatar is assigned to the mail address of the agent. Check https://gravatar.com/site/implement/images/ for further information.' =>
            '',
        'Define which avatar engine should be used for the agent avatar on the header and the sender images in AgentTicketZoom. If \'None\' is selected, initials will be displayed instead. Please note that selecting anything other than \'None\' will transfer the encrypted email address of the particular user to an external service.' =>
            '',
        'Define which columns are shown in the linked appointment widget (LinkObject::ViewMode = "complex"). Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.' =>
            '',
        'Define which columns are shown in the linked tickets widget (LinkObject::ViewMode = "complex"). Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            '',
        'Defines a customer item, which generates a LinkedIn icon at the end of a customer info block.' =>
            'Definiuje pozycję, która generuje ikonę LinkedIn na końcu bloku informacyjnego klienta.',
        'Defines a customer item, which generates a XING icon at the end of a customer info block.' =>
            'Definiuje pozycję, która generuje ikonę XING na końcu bloku informacyjnego klienta.',
        'Defines a customer item, which generates a google icon at the end of a customer info block.' =>
            'Definiuje pozycję, która generuje ikonę google na końcu bloku informacyjnego klienta.',
        'Defines a customer item, which generates a google maps icon at the end of a customer info block.' =>
            'Definiuje pozycję, która generuje ikonę google maps na końcu bloku informacyjnego klienta.',
        'Defines a filter for html output to add links behind CVE numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Definicja filtru wyświetlania HTML dodającego linki do numerów CVE. Element Image pozwala na dwa rodzaje danych. Może to być nazwa grafiki (np. faq.png) i wtedy zostanie użyta ścieżka dostępu do grafik OTRS. Drugą możliwością jest podanie linku do grafiki.',
        'Defines a filter for html output to add links behind MSBulletin numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Definicja filtru wyświetlania HTML dodającego linki do numerów Biuletynów Zabezpieczeń Microsoft. Element Image pozwala na dwa rodzaje danych. Może to być nazwa grafiki (np. faq.png) i wtedy zostanie użyta ścieżka dostępu do grafik OTRS. Drugą możliwością jest podanie linku do grafiki.',
        'Defines a filter for html output to add links behind a defined string. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Definicja filtru wyświetlania HTML dodającego linki pod wskazanym ciągiem znaków. Element Image pozwala na dwa rodzaje danych. Może to być nazwa grafiki (np. faq.png) i wtedy zostanie użyta ścieżka dostępu do grafik OTRS. Drugą możliwością jest podanie linku do grafiki.',
        'Defines a filter for html output to add links behind bugtraq numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Definicja filtru wyświetlania HTML dodającego linki do numerów bugtraq. Element Image pozwala na dwa rodzaje danych. Może to być nazwa grafiki (np. faq.png) i wtedy zostanie użyta ścieżka dostępu do grafik OTRS. Drugą możliwością jest podanie linku do grafiki.',
        'Defines a filter to collect CVE numbers from article texts in AgentTicketZoom. The results will be displayed in a meta box next to the article. Fill in URLPreview if you would like to see a preview when moving your mouse cursor above the link element. This could be the same URL as in URL, but also an alternate one. Please note that some websites deny being displayed within an iframe (e.g. Google) and thus won\'t work with the preview mode.' =>
            '',
        'Defines a filter to process the text in the articles, in order to highlight predefined keywords.' =>
            '',
        'Defines a permission context for customer to group assignment.' =>
            '',
        'Defines a regular expression that excludes some addresses from the syntax check (if "CheckEmailAddresses" is set to "Yes"). Please enter a regex in this field for email addresses, that aren\'t syntactically valid, but are necessary for the system (i.e. "root@localhost").' =>
            'Definiuje wyrażenie regularne wykluczające adresy ze sprawdzania składni (jeżeli "CheckEmailAddresses" jest ustawione na "Tak"). Wprowadź wyrażenie regularne dla adresów email, które nie są syntaktycznie prawidłowe ale są niezbędne w systemie (np. "root@localhost").',
        'Defines a regular expression that filters all email addresses that should not be used in the application.' =>
            '',
        'Defines a sleep time in microseconds between tickets while they are been processed by a job.' =>
            '',
        'Defines a useful module to load specific user options or to display news.' =>
            '',
        'Defines all the X-headers that should be scanned.' => 'Definiuje nagłówki-X które powinny zostać zeskanowane.',
        'Defines all the languages that are available to the application. Specify only English names of languages here.' =>
            '',
        'Defines all the languages that are available to the application. Specify only native names of languages here.' =>
            '',
        'Defines all the parameters for the RefreshTime object in the customer preferences of the customer interface.' =>
            'Definiuje wszystkie parametry dla pozycji OdświeżCzas (RefreshTime) w preferencjach klienta interfejsu klienta.',
        'Defines all the parameters for the ShownTickets object in the customer preferences of the customer interface.' =>
            'Definiuje wszystkie parametry dla objektów PokażZgłoszenia (ShownTickets) w preferencjach klienta interfejsu klienta.',
        'Defines all the parameters for this item in the customer preferences.' =>
            'Definiuje wszystkie parametry dla tej pozycji w preferencjach klienta.',
        'Defines all the parameters for this item in the customer preferences. \'PasswordRegExp\' allows to match passwords against a regular expression. Define the minimum number of characters using \'PasswordMinSize\'. Define if at least 2 lowercase and 2 uppercase letter characters are needed by setting the appropriate option to \'1\'. \'PasswordMin2Characters\' defines if the password needs to contain at least 2 letter characters (set to 0 or 1). \'PasswordNeedDigit\' controls the need of at least 1 digit (set to 0 or 1 to control).' =>
            '',
        'Defines all the parameters for this notification transport.' => '',
        'Defines all the possible stats output formats.' => 'Definiuje wszystkie możliwe formaty użyskiwania statystyk.',
        'Defines an alternate URL, where the login link refers to.' => 'Definiuje alternatywną ścieżkę dla linku logowania.',
        'Defines an alternate URL, where the logout link refers to.' => 'Definiuje alternatywną ścieżkę dla linku wylogowywania.',
        'Defines an alternate login URL for the customer panel..' => 'Definiuje alternatywną ścieżkę logowania w panelu klienta.',
        'Defines an alternate logout URL for the customer panel.' => 'Definiuje alternatywną ścieżkę wylogowywania w panelu klienta.',
        'Defines an external link to the database of the customer (e.g. \'http://yourhost/customer.php?CID=[% Data.CustomerID %]\' or \'\').' =>
            '',
        'Defines an icon with link to the google map page of the current location in appointment edit screen.' =>
            '',
        'Defines an overview module to show the address book view of a customer user list.' =>
            '',
        'Defines available article actions for Chat articles.' => '',
        'Defines available article actions for Email articles.' => '',
        'Defines available article actions for Internal articles.' => '',
        'Defines available article actions for Phone articles.' => '',
        'Defines available article actions for invalid articles.' => '',
        'Defines available groups for the admin overview screen.' => '',
        'Defines chat communication channel.' => '',
        'Defines default headers for outgoing emails.' => 'Określa domyślne nagłówki dla emaili wychodzących.',
        'Defines email communication channel.' => '',
        'Defines from which ticket attributes the agent can select the result order.' =>
            'Definiuje wśród których atrybutów agent może wybrać kolejność wyszukiwania.',
        'Defines groups for preferences items.' => '',
        'Defines how many deployments the system should keep.' => '',
        'Defines how the From field from the emails (sent from answers and email tickets) should look like.' =>
            'Definiuje jak powinno wyglądac pole Od w e-mailach (wysłane z odpowiedzi i zgłoszeń e-mail)',
        'Defines if a pre-sorting by priority should be done in the queue view.' =>
            '',
        'Defines if a pre-sorting by priority should be done in the service view.' =>
            '',
        'Defines if a ticket lock is required in the close ticket screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Określa, czy wymagana jest blokada zgłoszenia na ekranie zamykania zgłoszenia w interfejsie agenta (jeśli zgłoszenie nie jest jeszcze zablokowane, zostaje nałożona blokada, a bieżący agent staje się automatycznie właścicielem).',
        'Defines if a ticket lock is required in the email outbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Określa, czy wymagana jest blokada zgłoszenia na ekranie emaila wychodzącego w interfejsie agenta (jeśli zgłoszenie nie jest jeszcze zablokowane, zostaje nałożona blokada, a bieżący agent staje się automatycznie właścicielem).',
        'Defines if a ticket lock is required in the email resend screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Określa, czy wymagana jest blokada zgłoszenia na ekranie przesyłania dalej zgłoszenia w interfejsie agenta (jeśli zgłoszenie nie jest jeszcze zablokowane, zostaje nałożona blokada, a bieżący agent staje się automatycznie właścicielem).',
        'Defines if a ticket lock is required in the ticket bounce screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Określa, czy wymagana jest blokada zgłoszenia na ekranie przkazania zgłoszenia w interfejsie agenta (jeśli zgłoszenie nie jest jeszcze zablokowane, zostaje nałożona blokada, a bieżący agent staje się automatycznie właścicielem).',
        'Defines if a ticket lock is required in the ticket compose screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Określa, czy wymagana jest blokada zgłoszenia na ekranie tworzenia zgłoszenia w interfejsie agenta (jeśli zgłoszenie nie jest jeszcze zablokowane, zostaje nałożona blokada, a bieżący agent staje się automatycznie właścicielem).',
        'Defines if a ticket lock is required in the ticket forward screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Określa, czy wymagana jest blokada zgłoszenia na ekranie przekazania dalej zgłoszenia w interfejsie agenta (jeśli zgłoszenie nie jest jeszcze zablokowane, zostaje nałożona blokada, a bieżący agent staje się automatycznie właścicielem).',
        'Defines if a ticket lock is required in the ticket free text screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Określa, czy wymagana jest blokada zgłoszenia na ekranie notatki tekstowej zgłoszenia w interfejsie agenta (jeśli zgłoszenie nie jest jeszcze zablokowane, zostaje nałożona blokada, a bieżący agent staje się automatycznie właścicielem).',
        'Defines if a ticket lock is required in the ticket merge screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Określa, czy wymagana jest blokada zgłoszenia na ekranie łączenia przybliżonego zgłoszenia w interfejsie agenta (jeśli zgłoszenie nie jest jeszcze zablokowane, zostaje nałożona blokada, a bieżący agent staje się automatycznie właścicielem).',
        'Defines if a ticket lock is required in the ticket note screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Określa, czy wymagana jest blokada zgłoszenia na ekranie notatki do zgłoszenia w interfejsie agenta (jeśli zgłoszenie nie jest jeszcze zablokowane, zostaje nałożona blokada, a bieżący agent staje się automatycznie właścicielem).',
        'Defines if a ticket lock is required in the ticket owner screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Określa, czy wymagana jest blokada zgłoszenia na ekranie właściciela przybliżonego zgłoszenia w interfejsie agenta (jeśli zgłoszenie nie jest jeszcze zablokowane, zostaje nałożona blokada, a bieżący agent staje się automatycznie właścicielem).',
        'Defines if a ticket lock is required in the ticket pending screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Określa, czy wymagana jest blokada zgłoszenia na ekranie oczekującego przybliżonego zgłoszenia w interfejsie agenta (jeśli zgłoszenie nie jest jeszcze zablokowane, zostaje nałożona blokada, a bieżący agent staje się automatycznie właścicielem).',
        'Defines if a ticket lock is required in the ticket phone inbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Określa, czy wymagana jest blokada zgłoszenia na ekranie rozmowy tel. przychodzącej zgłoszenia w interfejsie agenta (jeśli zgłoszenie nie jest jeszcze zablokowane, zostaje nałożona blokada, a bieżący agent staje się automatycznie właścicielem).',
        'Defines if a ticket lock is required in the ticket phone outbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Określa, czy wymagana jest blokada zgłoszenia na ekranie rozmowy tel. wychodzącej zgłoszenia w interfejsie agenta (jeśli zgłoszenie nie jest jeszcze zablokowane, zostaje nałożona blokada, a bieżący agent staje się automatycznie właścicielem).',
        'Defines if a ticket lock is required in the ticket priority screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Określa, czy wymagana jest blokada zgłoszenia na ekranie priorytetu przybliżonego zgłoszenia w interfejsie agenta (jeśli zgłoszenie nie jest jeszcze zablokowane, zostaje nałożona blokada, a bieżący agent staje się automatycznie właścicielem).',
        'Defines if a ticket lock is required in the ticket responsible screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Określa, czy wymagana jest blokada zgłoszenia na ekranie odpowiedzialnego za zgłoszenie w interfejsie agenta (jeśli zgłoszenie nie jest jeszcze zablokowane, zostaje nałożona blokada, a bieżący agent staje się automatycznie właścicielem).',
        'Defines if a ticket lock is required to change the customer of a ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Określa czy blokada zgłoszenia jest wymagana, aby zmienić klienta powiązanego ze zgłoszeniem (jeżeli zgłoszenie nie zostało jeszcze zablokowane, blokuje się ono automatycznie i aktualny agent zostaje jego właścicielem).',
        'Defines if agents should be allowed to login if they have no shared secret stored in their preferences and therefore are not using two-factor authentication.' =>
            '',
        'Defines if customers should be allowed to login if they have no shared secret stored in their preferences and therefore are not using two-factor authentication.' =>
            '',
        'Defines if the communication between this system and OTRS Group servers that provide cloud services is possible. If set to \'Disable cloud services\', some functionality will be lost such as system registration, support data sending, upgrading to and use of OTRS Business Solution™, OTRS Verify™, OTRS News and product News dashboard widgets, among others.' =>
            'Określa czy jest możliwa komunikacja pomiędzy tym systemem a serwerami OTRS Group świadczącymi usługi w chmurze. Jeśli ustawisz na \'Wyłącz usługi w chmurze\' stracisz niektóre funkjonalności, między innymi: rejestracja systemu, przesyłanie danych do wsparcia, możliwość upgrade\'u i używania OTRS Business Solution™, OTRS Verify™, oraz widżety pulpitu Aktualności OTRS.',
        'Defines if the enhanced mode should be used (enables use of table, replace, subscript, superscript, paste from word, etc.) in customer interface.' =>
            '',
        'Defines if the enhanced mode should be used (enables use of table, replace, subscript, superscript, paste from word, etc.).' =>
            '',
        'Defines if the first article should be displayed as expanded, that is visible for the related customer. If nothing defined, latest article will be expanded.' =>
            '',
        'Defines if the message in the email outbound screen of the agent interface is visible for the customer by default.' =>
            '',
        'Defines if the message in the email resend screen of the agent interface is visible for the customer by default.' =>
            '',
        'Defines if the message in the ticket compose screen of the agent interface is visible for the customer by default.' =>
            '',
        'Defines if the message in the ticket forward screen of the agent interface is visible for the customer by default.' =>
            '',
        'Defines if the note in the close ticket screen of the agent interface is visible for the customer by default.' =>
            '',
        'Defines if the note in the ticket bulk screen of the agent interface is visible for the customer by default.' =>
            '',
        'Defines if the note in the ticket free text screen of the agent interface is visible for the customer by default.' =>
            '',
        'Defines if the note in the ticket note screen of the agent interface is visible for the customer by default.' =>
            '',
        'Defines if the note in the ticket owner screen of the agent interface is visible for the customer by default.' =>
            '',
        'Defines if the note in the ticket pending screen of the agent interface is visible for the customer by default.' =>
            '',
        'Defines if the note in the ticket priority screen of the agent interface is visible for the customer by default.' =>
            '',
        'Defines if the note in the ticket responsible screen of the agent interface is visible for the customer by default.' =>
            '',
        'Defines if the previously valid token should be accepted for authentication. This is slightly less secure but gives users 30 seconds more time to enter their one-time password.' =>
            '',
        'Defines if the values for filters should be retrieved from all available tickets. If enabled, only values which are actually used in any ticket will be available for filtering. Please note: The list of customers will always be retrieved like this.' =>
            '',
        'Defines if time accounting is mandatory in the agent interface. If enabled, a note must be entered for all ticket actions (no matter if the note itself is configured as active or is originally mandatory for the individual ticket action screen).' =>
            '',
        'Defines if time accounting must be set to all tickets in bulk action.' =>
            'Definiuje czy rozliczanie czasu musi byc ustawione dla wszystkich zebranych zgłoszeń',
        'Defines internal communication channel.' => '',
        'Defines out of office message template. Two string parameters (%s) available: end date and number of days left.' =>
            '',
        'Defines phone communication channel.' => '',
        'Defines queues that\'s tickets are used for displaying as calendar events.' =>
            'Definiuje kolejki których zgłoszenia są użyte do wyświetlenia jako wydarzenia kalendarzowe.',
        'Defines the HTTP hostname for the support data collection with the public module \'PublicSupportDataCollector\' (e.g. used from the OTRS Daemon).' =>
            '',
        'Defines the IP regular expression for accessing the local repository. You need to enable this to have access to your local repository and the package::RepositoryList is required on the remote host.' =>
            '',
        'Defines the PostMaster header to be used on the filter for keeping the current state of the ticket.' =>
            'Określa nagłówek poczty przychodzącej używany do zachowania bieżącego stanu zgłoszenia.',
        'Defines the URL CSS path.' => 'Definiuje ścieżkę dla CSS',
        'Defines the URL base path of icons, CSS and Java Script.' => 'Definiuje ścieżkę dla ikon, CSS i skryptów Java.',
        'Defines the URL image path of icons for navigation.' => 'Definiuje ścieżkę dla ikon nawigacyjnych.',
        'Defines the URL java script path.' => 'Definiuje ścieżkę dla skryptów java.',
        'Defines the URL rich text editor path.' => 'Definiuję scieżkę dla edytora tekstu.',
        'Defines the address of a dedicated DNS server, if necessary, for the "CheckMXRecord" look-ups.' =>
            '',
        'Defines the agent preferences key where the shared secret key is stored.' =>
            '',
        'Defines the available steps in time selections. Select "Minute" to be able to select all minutes of one hour from 1-59. Select "30 Minutes" to only make full and half hours available.' =>
            '',
        'Defines the body text for notification mails sent to agents, about new password.' =>
            '',
        'Defines the body text for notification mails sent to agents, with token about new requested password.' =>
            '',
        'Defines the body text for notification mails sent to customers, about new account.' =>
            'Definiuje treść wiadomości dla powiadomień mailowych wysyłanych do klientów o nowo tworzonym haśle.',
        'Defines the body text for notification mails sent to customers, about new password.' =>
            '',
        'Defines the body text for notification mails sent to customers, with token about new requested password.' =>
            '',
        'Defines the body text for rejected emails.' => 'Definiuje treść wiadomości dla odrzucowych e-maili.',
        'Defines the calendar width in percent. Default is 95%.' => 'Definiuje szerokość kalendarza. Domyślnie 95%.',
        'Defines the column to store the keys for the preferences table.' =>
            'Definiuje kolumny przechowujące klucze w preferencjach tabeli.',
        'Defines the config options for the autocompletion feature.' => 'Definiuje opcje konfiguracyjne dla fukcji autouzupełnienia.',
        'Defines the config parameters of this item, to be shown in the preferences view.' =>
            'Definiuje parametry konfiguracyjne dla tej pozycji do ukazania w widoku preferencji.',
        'Defines the config parameters of this item, to be shown in the preferences view. \'PasswordRegExp\' allows to match passwords against a regular expression. Define the minimum number of characters using \'PasswordMinSize\'. Define if at least 2 lowercase and 2 uppercase letter characters are needed by setting the appropriate option to \'1\'. \'PasswordMin2Characters\' defines if the password needs to contain at least 2 letter characters (set to 0 or 1). \'PasswordNeedDigit\' controls the need of at least 1 digit (set to 0 or 1 to control). \'PasswordMaxLoginFailed\' allows to set an agent to invalid-temporarily if max failed logins reached. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Defines the config parameters of this item, to be shown in the preferences view. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Defines the connections for http/ftp, via a proxy.' => 'Definiuje połączenia dla http/ftp poprzez proxy.',
        'Defines the customer preferences key where the shared secret key is stored.' =>
            '',
        'Defines the date input format used in forms (option or input fields).' =>
            'Definiuje format daty używanej w formularzach (opcja lub pole wstawienia).',
        'Defines the default CSS used in rich text editors.' => 'Definiuje domyślny CSS używany w edytorach tekstu.',
        'Defines the default agent name in the ticket zoom view of the customer interface.' =>
            '',
        'Defines the default auto response type of the article for this operation.' =>
            'Definiuje rodzaj odpowiedzi automatycznej artykułu dla tej operacji.',
        'Defines the default body of a note in the ticket free text screen of the agent interface.' =>
            'Definiuje domyślną zawartość notatki w oknie tekstu interfejsu agenta.',
        'Defines the default filter fields in the customer user address book search (CustomerUser or CustomerCompany). For the CustomerCompany fields a prefix \'CustomerCompany_\' must be added.' =>
            '',
        'Defines the default front-end (HTML) theme to be used by the agents and customers. If you like, you can add your own theme. Please refer the administrator manual located at https://doc.otrs.com/doc/.' =>
            '',
        'Defines the default front-end language. All the possible values are determined by the available language files on the system (see the next setting).' =>
            'Predefiniuje język interfejsu. Wszystkie możliwe wartości są określone przez dostępne pliki językowe w systemie (patrz kolejne ustawienie).',
        'Defines the default history type in the customer interface.' => 'Definiuje domyślny rodzaj historii w interfejsie klienta.',
        'Defines the default maximum number of X-axis attributes for the time scale.' =>
            '',
        'Defines the default maximum number of statistics per page on the overview screen.' =>
            '',
        'Defines the default next state for a ticket after customer follow-up in the customer interface.' =>
            '',
        'Defines the default next state of a ticket after adding a note, in the close ticket screen of the agent interface.' =>
            'Definiuje domyślny stan zgłoszenia po dodaniu notatki w oknie zamykania zgłoszenia w panelu agenta.',
        'Defines the default next state of a ticket after adding a note, in the ticket free text screen of the agent interface.' =>
            'Definiuje domyślny stan zgłoszenia po dodaniu notatki w oknie tekstowym zgłoszenia w panelu agenta.',
        'Defines the default next state of a ticket after adding a note, in the ticket note screen of the agent interface.' =>
            'Definiuje domyślny stan zgłoszenia po dodaniu notatki w oknie notatki zgłoszenia w panelu agenta.',
        'Defines the default next state of a ticket after adding a note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Definiuje domyślny stan zgłoszenia po dodaniu notatki w oknie zmiany właściciela zgłoszenia w panelu agenta.',
        'Defines the default next state of a ticket after adding a note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Definiuje domyślny stan zgłoszenia po dodaniu notatki w oknie oczekującego zgłoszenia w panelu agenta.',
        'Defines the default next state of a ticket after adding a note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Definiuje domyślny stan zgłoszenia po dodaniu notatki w oknie zmiany priorytetu zgłoszenia w panelu agenta.',
        'Defines the default next state of a ticket after adding a note, in the ticket responsible screen of the agent interface.' =>
            'Definiuje domyślny stan zgłoszenia po dodaniu notatki w oknie zmiany odpowiedzialnego za zgłoszenie w panelu agenta.',
        'Defines the default next state of a ticket after being bounced, in the ticket bounce screen of the agent interface.' =>
            '',
        'Defines the default next state of a ticket after being forwarded, in the ticket forward screen of the agent interface.' =>
            '',
        'Defines the default next state of a ticket after the message has been sent, in the email outbound screen of the agent interface.' =>
            '',
        'Defines the default next state of a ticket if it is composed / answered in the ticket compose screen of the agent interface.' =>
            '',
        'Defines the default next state of a ticket, in the ticket bulk screen of the agent interface.' =>
            '',
        'Defines the default note body text for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Defines the default note body text for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            '',
        'Defines the default priority of follow-up customer tickets in the ticket zoom screen in the customer interface.' =>
            '',
        'Defines the default priority of new customer tickets in the customer interface.' =>
            'Definiuje domyślny priorytet nowych zgłoszeń klienta w interfejsie klienta.',
        'Defines the default priority of new tickets.' => 'Definiuje priorytet dla nowych zgłoszeń.',
        'Defines the default queue for new customer tickets in the customer interface.' =>
            'Definiuje domyślną kolejkę dla zgłoszeń klienta w interefejsie klienta.',
        'Defines the default queue for new tickets in the agent interface.' =>
            '',
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
        'Defines the default shown ticket search attribute for ticket search screen (AllTickets/ArchivedTickets/NotArchivedTickets).' =>
            '',
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
        'Defines the default state of new customer tickets in the customer interface.' =>
            'Definiuje domyślny stan nowych zgłoszeń klienta w interfejsie klienta.',
        'Defines the default state of new tickets.' => 'Definiuje domyślny stan nowych zgłoszeń.',
        'Defines the default subject for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            'Definiuje domyślny tytuł dla zgłoszeń telefonicznych w oknie przychodzących zgłoszeń telefonicznych interfejsu agenta.',
        'Defines the default subject for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            'Definiuje domyślny tytuł dla zgłoszeń telefonicznych w oknie wychodzących zgłoszeń telefonicznych interfejsu agenta.',
        'Defines the default subject of a note in the ticket free text screen of the agent interface.' =>
            'Definiuje domyślny tytuł notatki w oknie tekstowym interfejsu agenta.',
        'Defines the default the number of seconds (from current time) to re-schedule a generic interface failed task.' =>
            '',
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
        'Defines the default ticket type.' => 'Definicja domyślnego typu zgłoszenia.',
        'Defines the default used Frontend-Module if no Action parameter given in the url on the agent interface.' =>
            '',
        'Defines the default used Frontend-Module if no Action parameter given in the url on the customer interface.' =>
            '',
        'Defines the default value for the action parameter for the public frontend. The action parameter is used in the scripts of the system.' =>
            '',
        'Defines the default viewable sender types of a ticket (default: customer).' =>
            'Definiuje domyślne widoczne typy wysyłających zgłoszenie (domyślny: klient).',
        'Defines the default visibility of the article to customer for this operation.' =>
            '',
        'Defines the displayed style of the From field in notes that are visible for customers. A default agent name can be defined in Ticket::Frontend::CustomerTicketZoom###DefaultAgentName setting.' =>
            '',
        'Defines the dynamic fields that are used for displaying on calendar events.' =>
            'Definiuje domyślne pola dynamiczne, które są użyte do wyświetlenia zdarzeń kalendarzowych.',
        'Defines the event object types that will be handled via AdminAppointmentNotificationEvent.' =>
            '',
        'Defines the fall-back path to open fetchmail binary. Note: The name of the binary needs to be \'fetchmail\', if it is different please use a symbolic link.' =>
            '',
        'Defines the filter that processes the text in the articles, in order to highlight URLs.' =>
            'Definiuje filtr procesujący tekst w artykułach służący wyróżnieniu URLi.',
        'Defines the format of responses in the ticket compose screen of the agent interface ([% Data.OrigFrom | html %] is From 1:1, [% Data.OrigFromName | html %] is only realname of From).' =>
            '',
        'Defines the fully qualified domain name of the system. This setting is used as a variable, OTRS_CONFIG_FQDN which is found in all forms of messaging used by the application, to build links to the tickets within your system.' =>
            '',
        'Defines the groups every customer user will be in (if CustomerGroupSupport is enabled and you don\'t want to manage every customer user for these groups).' =>
            '',
        'Defines the groups every customer will be in (if CustomerGroupSupport is enabled and you don\'t want to manage every customer for these groups).' =>
            '',
        'Defines the height for the rich text editor component for this screen. Enter number (pixels) or percent value (relative).' =>
            '',
        'Defines the height for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            '',
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
        'Defines the link type \'Normal\'. If the source name and the target name contain the same value, the resulting link is a non-directional one; otherwise, the result is a directional link.' =>
            '',
        'Defines the link type \'ParentChild\'. If the source name and the target name contain the same value, the resulting link is a non-directional one; otherwise, the result is a directional link.' =>
            '',
        'Defines the link type groups. The link types of the same group cancel one another. Example: If ticket A is linked per a \'Normal\' link with ticket B, then these tickets could not be additionally linked with link of a \'ParentChild\' relationship.' =>
            '',
        'Defines the list of online repositories. Another installations can be used as repository, for example: Key="http://example.com/otrs/public.pl?Action=PublicRepository;File=" and Content="Some Name".' =>
            '',
        'Defines the list of params that can be passed to ticket search function.' =>
            '',
        'Defines the list of possible next actions on an error screen, a full path is required, then is possible to add external links if needed.' =>
            '',
        'Defines the list of types for templates.' => 'Definiuje listę rodzajów szablonów.',
        'Defines the location to get online repository list for additional packages. The first available result will be used.' =>
            'Definiuje lokalizację listy repozytoriów pakietów dodatkowy. Użyty zostanie pierwszy dostępny wynik.',
        'Defines the log module for the system. "File" writes all messages in a given logfile, "SysLog" uses the syslog daemon of the system, e.g. syslogd.' =>
            '',
        'Defines the maximal size (in bytes) for file uploads via the browser. Warning: Setting this option to a value which is too low could cause many masks in your OTRS instance to stop working (probably any mask which takes input from the user).' =>
            '',
        'Defines the maximal valid time (in seconds) for a session id.' =>
            'Definiuje maksymalny dopuszczalny czas dla id sesji.',
        'Defines the maximum number of affected tickets per job.' => '',
        'Defines the maximum number of pages per PDF file.' => 'Definiuje maksymalną liczbę stron dla pliku PDF.',
        'Defines the maximum number of quoted lines to be added to responses.' =>
            '',
        'Defines the maximum number of tasks to be executed as the same time.' =>
            '',
        'Defines the maximum size (in MB) of the log file.' => 'Definiuje maksymalny rozmiar (w MB) dla pliku logowania.',
        'Defines the maximum size in KiloByte of GenericInterface responses that get logged to the gi_debugger_entry_content table.' =>
            '',
        'Defines the module that shows a generic notification in the agent interface. Either "Text" - if configured - or the contents of "File" will be displayed.' =>
            'Definiuje moduł ukazujący podstawowe powiadomienia w interfejsie agenta. Zostanie pokazany "tekst" - jeśli skonfigurowany - lub zawartość "pliku".',
        'Defines the module that shows all the currently logged in agents in the agent interface.' =>
            'Definiuje moduł, który ukazuje wszystkich obecnie zalogowanych agentów w interfejsie agenta.',
        'Defines the module that shows all the currently logged in customers in the agent interface.' =>
            '',
        'Defines the module that shows the currently logged in agents in the customer interface.' =>
            '',
        'Defines the module that shows the currently logged in customers in the customer interface.' =>
            '',
        'Defines the module to authenticate customers.' => 'Definiuje moduł autentykacji klientów.',
        'Defines the module to display a notification if cloud services are disabled.' =>
            '',
        'Defines the module to display a notification in different interfaces on different occasions for OTRS Business Solution™.' =>
            '',
        'Defines the module to display a notification in the agent interface if the OTRS Daemon is not running.' =>
            '',
        'Defines the module to display a notification in the agent interface if the system configuration is out of sync.' =>
            '',
        'Defines the module to display a notification in the agent interface, if the agent has not yet selected a time zone.' =>
            '',
        'Defines the module to display a notification in the agent interface, if the agent is logged in while having out-of-office active.' =>
            'Definiuje moduł wyświetlający powiadomienie w interfejsie agenta, jeśli agent jest zalogowany w przypadku aktywnego agenta nieobecności.',
        'Defines the module to display a notification in the agent interface, if the agent is logged in while having system maintenance active.' =>
            '',
        'Defines the module to display a notification in the agent interface, if the agent session limit prior warning is reached.' =>
            '',
        'Defines the module to display a notification in the agent interface, if the installation of not verified packages is activated (only shown to admins).' =>
            '',
        'Defines the module to display a notification in the agent interface, if the system is used by the admin user (normally you shouldn\'t work as admin).' =>
            'Definiuje moduł ukazujący powiadomienia w interfejsie agenta, jeśli system jest użytkowany przez administratora (w codziennej pracy praca jako admin jest niewskazana).',
        'Defines the module to display a notification in the agent interface, if there are invalid sysconfig settings deployed.' =>
            '',
        'Defines the module to display a notification in the agent interface, if there are modified sysconfig settings that are not deployed yet.' =>
            '',
        'Defines the module to display a notification in the customer interface, if the customer is logged in while having system maintenance active.' =>
            '',
        'Defines the module to display a notification in the customer interface, if the customer user has not yet selected a time zone.' =>
            '',
        'Defines the module to generate code for periodic page reloads.' =>
            '',
        'Defines the module to send emails. "DoNotSendEmail" doesn\'t send emails at all. Any of the "SMTP" mechanisms use a specified (external) mailserver. "Sendmail" directly uses the sendmail binary of your operating system. "Test" doesn\'t send emails, but writes them to $OTRS_HOME/var/tmp/CacheFileStorable/EmailTest/ for testing purposes.' =>
            '',
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
        'Defines the name of the table where the user preferences are stored.' =>
            '',
        'Defines the next possible states after composing / answering a ticket in the ticket compose screen of the agent interface.' =>
            'Definiuje kolejne możliwe stany po tworzeniu / odpowiedzi na zgłoszenie w oknie tworzenia zgłoszenia interfejsu agenta.',
        'Defines the next possible states after forwarding a ticket in the ticket forward screen of the agent interface.' =>
            'Definiuje kolejne możliwe stany po przesłaniu zgłoszenia w oknie przesłanych dalej interfejsu agenta.',
        'Defines the next possible states after sending a message in the email outbound screen of the agent interface.' =>
            '',
        'Defines the next possible states for customer tickets in the customer interface.' =>
            'Definiuje kolejne możliwe stany dla zgłoszeń klienta w interfejsie klienta.',
        'Defines the next state of a ticket after adding a note, in the close ticket screen of the agent interface.' =>
            'Definiuje stan zgłoszenia po dodaniu notatki w oknie zamknięcia zgłoszenia w panelu agenta.',
        'Defines the next state of a ticket after adding a note, in the ticket free text screen of the agent interface.' =>
            'Definiuje stan zgłoszenia po dodaniu notatki w oknie dowolnego tekstu zgłoszenia w panelu agenta.',
        'Defines the next state of a ticket after adding a note, in the ticket note screen of the agent interface.' =>
            'Definiuje stan zgłoszenia po dodaniu notatki w oknie notatki zgłoszenia w panelu agenta.',
        'Defines the next state of a ticket after adding a note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Definiuje stan zgłoszenia po dodaniu notatki w oknie zmiany właściciela zgłoszenia w panelu agenta.',
        'Defines the next state of a ticket after adding a note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Definiuje stan zgłoszenia po dodaniu notatki w oknie ustawiania oczekującego zgłoszenia panelu agenta.',
        'Defines the next state of a ticket after adding a note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Definiuje stan zgłoszenia po dodaniu notatki w oknie zmiany priorytetu zgłoszenia w panelu agenta.',
        'Defines the next state of a ticket after adding a note, in the ticket responsible screen of the agent interface.' =>
            'Definiuje stan zgłoszenia po dodaniu notatki w oknie zmiany odpowiedzialnego za zgłoszenie w panelu agenta.',
        'Defines the next state of a ticket after being bounced, in the ticket bounce screen of the agent interface.' =>
            'Definiuje stan zgłoszenia po jego przekazaniu w oknie przekazywania na inny adres w panelu agenta.',
        'Defines the next state of a ticket after being moved to another queue, in the move ticket screen of the agent interface.' =>
            'Definiuje stan zgłoszenia po przeniesieniu do innej kolejki w oknie przenoszenia zgłoszeń w panelu agenta.',
        'Defines the next state of a ticket, in the ticket bulk screen of the agent interface.' =>
            '',
        'Defines the number of character per line used in case an HTML article preview replacement on TemplateGenerator for EventNotifications.' =>
            '',
        'Defines the number of days to keep the daemon log files.' => '',
        'Defines the number of header fields in frontend modules for add and update postmaster filters. It can be up to 99 fields.' =>
            'Definiuje liczbę pól nagłówków w modułach interfejsu do dodawania i aktualizacji filtrów poczty przychodzącej. Możliwe jest ustawienie do 99 pól.',
        'Defines the number of hours a communication will be stored, whichever its status.' =>
            '',
        'Defines the number of hours a successful communication will be stored.' =>
            '',
        'Defines the parameters for the customer preferences table.' => 'Definiuje parametry dla tabeli preferencji klienta.',
        'Defines the parameters for the dashboard backend. "Cmd" is used to specify command with parameters. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            '',
        'Defines the parameters for the dashboard backend. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            '',
        'Defines the parameters for the dashboard backend. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" defines the cache expiration period in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            '',
        'Defines the parameters for the dashboard backend. "Limit" defines the number of entries displayed by default. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            '',
        'Defines the parameters for the dashboard backend. "Limit" defines the number of entries displayed by default. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" defines the cache expiration period in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
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
        'Defines the path of the shown info file, that is located under Kernel/Output/HTML/Templates/Standard/CustomerAccept.tt.' =>
            '',
        'Defines the path to PGP binary.' => 'Definiuje ścieżkę dla programu PGP.',
        'Defines the path to open ssl binary. It may need a HOME env ($ENV{HOME} = \'/var/lib/wwwrun\';).' =>
            'Definiuje ścieźkę do programu ssl. Może wymagać środowiska HOME ($ENV{HOME} = \'/var/lib/wwwrun\';).',
        'Defines the period of time (in minutes) before agent is marked as "away" due to inactivity (e.g. in the "Logged-In Users" widget or for the chat).' =>
            '',
        'Defines the period of time (in minutes) before customer is marked as "away" due to inactivity (e.g. in the "Logged-In Users" widget or for the chat).' =>
            '',
        'Defines the postmaster default queue.' => 'Definiuje domyślną kolejkę postmastera.',
        'Defines the priority in which the information is logged and presented.' =>
            '',
        'Defines the recipient target of the phone ticket and the sender of the email ticket ("Queue" shows all queues, "System address" displays all system addresses) in the agent interface.' =>
            '',
        'Defines the recipient target of the tickets ("Queue" shows all queues, "SystemAddress" shows only the queues which are assigned to system addresses) in the customer interface.' =>
            '',
        'Defines the required permission to show a ticket in the escalation view of the agent interface.' =>
            'Definiuje wymagane prawa do ukazania zgłoszenia w widoku eskalacji interfejsu agenta.',
        'Defines the search limit for the stats.' => 'Definiuje limit wyszukiwań dla statystyk.',
        'Defines the search parameters for the AgentCustomerUserAddressBook screen. With the setting \'CustomerTicketTextField\' the values for the recipient field can be specified.' =>
            '',
        'Defines the sender for rejected emails.' => 'Definiuje nadawcę dla odrzuconych e-maili.',
        'Defines the separator between the agents real name and the given queue email address.' =>
            'Definiuje separator pomiędzy prawdziwym imieniem agenta a wskazanym adresem e-mail.',
        'Defines the shown columns and the position in the AgentCustomerUserAddressBook result screen.' =>
            '',
        'Defines the shown links in the footer area of the customer and public interface of this OTRS system. The value in "Key" is the external URL, the value in "Content" is the shown label.' =>
            '',
        'Defines the standard permissions available for customers within the application. If more permissions are needed, you can enter them here. Permissions must be hard coded to be effective. Please ensure, when adding any of the afore mentioned permissions, that the "rw" permission remains the last entry.' =>
            'Określa standardowe uprawnienia dostępne dla użytkowników wewnątrz aplikacji. Jeśli wymagane jest więcej uprawnień, można je tutaj wprowadzić. Uprawnienia muszą być zakodowane, żeby były efektywne. Należy upewnić się, że podczas dodawania któregokolwiek z wyżej wymienionych uprawnień, uprawnienie "rw" pozostaje jako ostatni wpis.',
        'Defines the standard size of PDF pages.' => 'Definiuje standardowy rozmiar stron PDF.',
        'Defines the state of a ticket if it gets a follow-up and the ticket was already closed.' =>
            'Definiuje stan zgłoszenia, w którym pojawiła się nowa wiadomość, w przypadku gdy zgłoszenie było już zamknięte.',
        'Defines the state of a ticket if it gets a follow-up.' => 'Definiuje stan zgłoszenia, w którym pojawiła się nowa wiadomość.',
        'Defines the state type of the reminder for pending tickets.' => 'Definiuje stan powiadomień dla oczekujących zgłoszeń.',
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
        'Defines the ticket appointment type backend for ticket dynamic field date time.' =>
            '',
        'Defines the ticket appointment type backend for ticket escalation time.' =>
            '',
        'Defines the ticket appointment type backend for ticket pending time.' =>
            '',
        'Defines the ticket fields that are going to be displayed calendar events. The "Key" defines the field or ticket attribute and the "Content" defines the display name.' =>
            '',
        'Defines the ticket plugin for calendar appointments.' => '',
        'Defines the time zone of the indicated calendar, which can be assigned later to a specific queue.' =>
            'Definiuje strefe czasową wskazanego kalendarza, który będzie dodany w później do wybranej kolejki.',
        'Defines the timeout (in seconds, minimum is 20 seconds) for the support data collection with the public module \'PublicSupportDataCollector\' (e.g. used from the OTRS Daemon).' =>
            '',
        'Defines the two-factor module to authenticate agents.' => '',
        'Defines the two-factor module to authenticate customers.' => '',
        'Defines the type of protocol, used by the web server, to serve the application. If https protocol will be used instead of plain http, it must be specified here. Since this has no affect on the web server\'s settings or behavior, it will not change the method of access to the application and, if it is wrong, it will not prevent you from logging into the application. This setting is only used as a variable, OTRS_CONFIG_HttpType which is found in all forms of messaging used by the application, to build links to the tickets within your system.' =>
            '',
        'Defines the used character for plaintext email quotes in the ticket compose screen of the agent interface. If this is empty or inactive, original emails will not be quoted but appended to the response.' =>
            '',
        'Defines the user identifier for the customer panel.' => 'Określa identyfikator użytkownika w panelu klienta.',
        'Defines the username to access the SOAP handle (bin/cgi-bin/rpc.pl).' =>
            'Definiuje uzytkownika do wykorzystania SOAP (bin/cgi-bin/rpc.pl).',
        'Defines the users avatar. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Defines the valid state types for a ticket. If a ticket is in a state which have any state type from this setting, this ticket will be considered as open, otherwise as closed.' =>
            '',
        'Defines the valid states for unlocked tickets. To unlock tickets the script "bin/otrs.Console.pl Maint::Ticket::UnlockTimeout" can be used.' =>
            '',
        'Defines the viewable locks of a ticket. NOTE: When you change this setting, make sure to delete the cache in order to use the new value. Default: unlock, tmp_lock.' =>
            '',
        'Defines the width for the rich text editor component for this screen. Enter number (pixels) or percent value (relative).' =>
            '',
        'Defines the width for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            '',
        'Defines time in minutes since last modification for drafts of specified type before they are considered expired.' =>
            '',
        'Defines whether to index archived tickets for fulltext searches.' =>
            '',
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
        'Defines, which tickets of which ticket state types should not be listed in linked ticket lists.' =>
            '',
        'Delete expired cache from core modules.' => '',
        'Delete expired loader cache weekly (Sunday mornings).' => '',
        'Delete expired sessions.' => 'Usuń wygasłe sesje.',
        'Delete expired ticket draft entries.' => '',
        'Delete expired upload cache hourly.' => '',
        'Delete this ticket' => 'Usuń to zgłoszenie',
        'Deleted link to ticket "%s".' => 'Usunięto łacze ze zgłoszenia "%s".',
        'Deletes a session if the session id is used with an invalid remote IP address.' =>
            'Usuwa sesje jeśli id sesji jest użyte wraz z nieprawidłowym adresem IP.',
        'Deletes requested sessions if they have timed out.' => 'Usuwa podane wygasnięte sesje.',
        'Delivers extended debugging information in the frontend in case any AJAX errors occur, if enabled.' =>
            '',
        'Deploy and manage OTRS Business Solution™.' => '',
        'Detached' => '',
        'Determines if a button to delete a link should be displayed next to each link in each zoom mask.' =>
            '',
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
        'Determines the next possible ticket states, for process tickets in the customer interface.' =>
            '',
        'Determines the next screen after new customer ticket in the customer interface.' =>
            'Determinuje kolejne okno dla nowych zgłoszeń klienta w interfejsie klienta.',
        'Determines the next screen after the follow-up screen of a zoomed ticket in the customer interface.' =>
            '',
        'Determines the next screen after the ticket is moved. LastScreenOverview will return the last overview screen (e.g. search results, queueview, dashboard). TicketZoom will return to the TicketZoom.' =>
            '',
        'Determines the possible states for pending tickets that changed state after reaching time limit.' =>
            'Determinuje możliwe stany dla oczekujących zgłoszeń po osiągnięciu limitu czasu.',
        'Determines the strings that will be shown as recipient (To:) of the phone ticket and as sender (From:) of the email ticket in the agent interface. For Queue as NewQueueSelectionType "<Queue>" shows the names of the queues and for SystemAddress "<Realname> <<Email>>" shows the name and email of the recipient.' =>
            '',
        'Determines the strings that will be shown as recipient (To:) of the ticket in the customer interface. For Queue as CustomerPanelSelectionType, "<Queue>" shows the names of the queues, and for SystemAddress, "<Realname> <<Email>>" shows the name and email of the recipient.' =>
            '',
        'Determines the way the linked objects are displayed in each zoom mask.' =>
            'Determinuje sposób wyświetlania zlinkowanych objektów w każdej masce przybliżenia.',
        'Determines which options will be valid of the recipient (phone ticket) and the sender (email ticket) in the agent interface.' =>
            '',
        'Determines which queues will be valid for ticket\'s recepients in the customer interface.' =>
            '',
        'Disable HTTP header "Content-Security-Policy" to allow loading of external script contents. Disabling this HTTP header can be a security issue! Only disable it, if you know what you are doing!' =>
            '',
        'Disable HTTP header "X-Frame-Options: SAMEORIGIN" to allow OTRS to be included as an IFrame in other websites. Disabling this HTTP header can be a security issue! Only disable it, if you know what you are doing!' =>
            '',
        'Disable autocomplete in the login screen.' => '',
        'Disable cloud services' => 'Wyłącz usługi w chmurze',
        'Disables sending reminder notifications to the responsible agent of a ticket (Ticket::Responsible needs to be enabled).' =>
            '',
        'Disables the redirection to the last screen overview / dashboard after a ticket is closed.' =>
            '',
        'Disables the web installer (http://yourhost.example.com/otrs/installer.pl), to prevent the system from being hijacked. If not enabled, the system can be reinstalled and the current basic configuration will be used to pre-populate the questions within the installer script. If enabled, it also disables the GenericAgent, PackageManager and SQL Box.' =>
            '',
        'Display a warning and prevent search when using stop words within fulltext search.' =>
            '',
        'Display communication log entries.' => '',
        'Display settings to override defaults for Process Tickets.' => 'Wyświetl ustawienia nadpisujące domyślne dla złoszeń procesowych.',
        'Displays the accounted time for an article in the ticket zoom view.' =>
            'Wyświetla zliczony czas artykułu w widoku przybliżonym zgłoszenia.',
        'Displays the number of all tickets with the same CustomerID as current ticket in the ticket zoom view.' =>
            '',
        'Down' => 'Dół',
        'Dropdown' => 'Lista rozwijana',
        'Dutch' => '',
        'Dutch stop words for fulltext index. These words will be removed from the search index.' =>
            '',
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
        'Dynamic fields limit per page for Dynamic Fields Overview.' => '',
        'Dynamic fields options shown in the ticket message screen of the customer interface. NOTE. If you want to display these fields also in the ticket zoom of the customer interface, you have to enable them in CustomerTicketZoom###DynamicField.' =>
            '',
        'Dynamic fields options shown in the ticket reply section in the ticket zoom screen of the customer interface.' =>
            '',
        'Dynamic fields shown in the email outbound screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the process widget in ticket zoom screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the sidebar of the ticket zoom screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket close screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket compose screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket email screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket forward screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket free text screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket medium format overview screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket move screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket note screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket overview screen of the customer interface.' =>
            '',
        'Dynamic fields shown in the ticket owner screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket pending screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket phone outbound screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket phone screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket preview format overview screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket print screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket print screen of the customer interface.' =>
            '',
        'Dynamic fields shown in the ticket priority screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket responsible screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket search overview results screen of the customer interface.' =>
            '',
        'Dynamic fields shown in the ticket search screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket search screen of the customer interface.' =>
            '',
        'Dynamic fields shown in the ticket small format overview screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket zoom screen of the customer interface.' =>
            '',
        'DynamicField' => 'Pole Dynamiczne',
        'DynamicField backend registration.' => '',
        'DynamicField object registration.' => 'Rejestracja obiektów pól dynamicznych',
        'DynamicField_%s' => 'DynamicField_%s',
        'E-Mail Outbound' => 'E-mail wychodzący',
        'Edit Customer Companies.' => '',
        'Edit Customer Users.' => 'Edytuj użytkowników klienta.',
        'Edit appointment' => 'Edytuj wydarzenie',
        'Edit customer company' => 'Edytuj firmę klienta',
        'Email Addresses' => 'Adresy e-mail',
        'Email Outbound' => 'Email Zewnętrzny',
        'Email Resend' => '',
        'Email communication channel.' => '',
        'Enable highlighting queues based on ticket age.' => '',
        'Enable keep-alive connection header for SOAP responses.' => 'Włącz nagłówek utrzymywania połączeń keep-alive dla odpowiedzi SOAP.',
        'Enable this if you trust in all your public and private pgp keys, even if they are not certified with a trusted signature.' =>
            '',
        'Enabled filters.' => 'Włączone filtry.',
        'Enables PGP support. When PGP support is enabled for signing and encrypting mail, it is HIGHLY recommended that the web server runs as the OTRS user. Otherwise, there will be problems with the privileges when accessing .gnupg folder.' =>
            '',
        'Enables S/MIME support.' => 'Aktywuje wsparcie dla S/MIME.',
        'Enables customers to create their own accounts.' => 'Umożliwia klientom na tworzenie własnych kont.',
        'Enables fetch S/MIME from CustomerUser backend support.' => '',
        'Enables file upload in the package manager frontend.' => 'Włącza możliwość zamieszczania plików w menadzeże pakietów.',
        'Enables or disables the caching for templates. WARNING: Do NOT disable template caching for production environments for it will cause a massive performance drop! This setting should only be disabled for debugging reasons!' =>
            '',
        'Enables or disables the debug mode over frontend interface.' => '',
        'Enables or disables the ticket watcher feature, to keep track of tickets without being the owner nor the responsible.' =>
            '',
        'Enables performance log (to log the page response time). It will affect the system performance. Frontend::Module###AdminPerformanceLog must be enabled.' =>
            '',
        'Enables the minimal ticket counter size (if "Date" was selected as TicketNumberGenerator).' =>
            'Włącza minimalny numer zgłoszenia (jeśli "Data" została wybrana jako TicketNumberGenerator).',
        'Enables ticket bulk action feature for the agent frontend to work on more than one ticket at a time.' =>
            '',
        'Enables ticket bulk action feature only for the listed groups.' =>
            '',
        'Enables ticket responsible feature, to keep track of a specific ticket.' =>
            '',
        'Enables ticket type feature.' => '',
        'Enables ticket watcher feature only for the listed groups.' => 'Włącza obserwatora zgłoszenia tylko dla podanych grup.',
        'English (Canada)' => 'Angielski (Kanada)',
        'English (United Kingdom)' => 'Angielski (Wielka Brytania)',
        'English (United States)' => 'Angielski (USA)',
        'English stop words for fulltext index. These words will be removed from the search index.' =>
            '',
        'Enroll process for this ticket' => '',
        'Enter your shared secret to enable two factor authentication. WARNING: Make sure that you add the shared secret to your generator application and the application works well. Otherwise you will be not able to login anymore without the two factor token.' =>
            '',
        'Escalated Tickets' => 'Zgłoszenia eskalowane',
        'Escalation view' => 'Zgłoszenia eskalowane',
        'EscalationTime' => '',
        'Estonian' => 'Estoński',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate).' =>
            '',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate). This is only possible if all Ticket dynamic fields need the same event.' =>
            '',
        'Event module that performs an update statement on TicketIndex to rename the queue name there if needed and if StaticDB is actually used.' =>
            '',
        'Event module that updates customer company object name for dynamic fields.' =>
            '',
        'Event module that updates customer user object name for dynamic fields.' =>
            '',
        'Event module that updates customer user search profiles if login changes.' =>
            '',
        'Event module that updates customer user service membership if login changes.' =>
            'Moduł zdarzeń modyfikujący przynależność konta klienta do serwisu po zmianie loginu.',
        'Event module that updates customer users after an update of the Customer.' =>
            '',
        'Event module that updates tickets after an update of the Customer User.' =>
            'Moduł zdarzeń modyfikujący zgłoszenie po zmianie konta klienta.',
        'Event module that updates tickets after an update of the Customer.' =>
            '',
        'Events Ticket Calendar' => 'Kalendarz zdarzeń zgłoszeń',
        'Example package autoload configuration.' => '',
        'Execute SQL statements.' => 'Wykonaj polecenia SQL',
        'Executes a custom command or module. Note: if module is used, function is required.' =>
            '',
        'Executes follow-up checks on In-Reply-To or References headers for mails that don\'t have a ticket number in the subject.' =>
            '',
        'Executes follow-up checks on OTRS Header \'X-OTRS-Bounce\'.' => '',
        'Executes follow-up checks on attachment contents for mails that don\'t have a ticket number in the subject.' =>
            '',
        'Executes follow-up checks on email body for mails that don\'t have a ticket number in the subject.' =>
            '',
        'Executes follow-up checks on the raw source email for mails that don\'t have a ticket number in the subject.' =>
            '',
        'Exports the whole article tree in search result (it can affect the system performance).' =>
            'Eksportuje całe drzewo artykułów z rezultatów wyszukiwania (może to mieć wpływ na wydajnośc systemu).',
        'External' => '',
        'External Link' => '',
        'Fetch emails via fetchmail (using SSL).' => 'Pobierz pocztę przez fetchmail (używając SSL)',
        'Fetch emails via fetchmail.' => 'Pobierz pocztę przez fetchmail',
        'Fetch incoming emails from configured mail accounts.' => 'Pobierz nadchodzącą pocztę ze skonfigurowanych kont mailowych.',
        'Fetches packages via proxy. Overwrites "WebUserAgent::Proxy".' =>
            'Pobiera pakiety przez proxy. Nadpisuje "WebUserAgent::Proxy".',
        'File that is displayed in the Kernel::Modules::AgentInfo module, if located under Kernel/Output/HTML/Templates/Standard/AgentInfo.tt.' =>
            '',
        'Filter for debugging ACLs. Note: More ticket attributes can be added in the format <OTRS_TICKET_Attribute> e.g. <OTRS_TICKET_Priority>.' =>
            '',
        'Filter for debugging Transitions. Note: More filters can be added in the format <OTRS_TICKET_Attribute> e.g. <OTRS_TICKET_Priority>.' =>
            '',
        'Filter incoming emails.' => 'Fitrowanie przychodzących e-maili.',
        'Finnish' => 'Zakończ',
        'First Christmas Day' => 'Boże Narodzenie (pierwszy dzień)',
        'First Queue' => 'Pierwsza kolejka',
        'First response time' => 'Czas pierwszej odpowiedzi',
        'FirstLock' => 'Pierwsza blokada',
        'FirstResponse' => 'Pierwsza odpowiedź',
        'FirstResponseDiffInMin' => 'Pierwsza odpowiedź w min. - różnica',
        'FirstResponseInMin' => 'Pierwsza odpowiedź w min.',
        'Firstname Lastname' => 'Imię Nazwisko',
        'Firstname Lastname (UserLogin)' => 'Imię Nazwisko (Login)',
        'For these state types the ticket numbers are striked through in the link table.' =>
            '',
        'Force the storage of the original article text in the article search index, without executing filters or applying stop word lists. This will increase the size of the search index and thus may slow down fulltext searches.' =>
            '',
        'Forces encoding of outgoing emails (7bit|8bit|quoted-printable|base64).' =>
            'Wymusza kodowanie wychodzącej poczty (7bit|8bit|quoted-printable|base64).',
        'Forces to choose a different ticket state (from current) after lock action. Define the current state as key, and the next state after lock action as content.' =>
            'Wymusza wybranie innego stanu zgłoszenia (od obecnego) po zablokowaniu. Definiuje obecny stan jako klucz oraz następny stan po zablokowaniu jako treść.',
        'Forces to unlock tickets after being moved to another queue.' =>
            'Wymusza odblokowanie zgłoszeń po przeniesieniu do innej kolejki.',
        'Forwarded to "%s".' => 'Przesłano do "%s".',
        'Free Fields' => 'Pola dodatkowe',
        'French' => 'Francuski',
        'French (Canada)' => 'Francuski (Kanada)',
        'French stop words for fulltext index. These words will be removed from the search index.' =>
            '',
        'Frontend' => '',
        'Frontend module registration (disable AgentTicketService link if Ticket Service feature is not used).' =>
            '',
        'Frontend module registration (disable company link if no company feature is used).' =>
            'Widok modułu interfejsu (wyłącz link firmy jeśli żadna cecha firmy nie jets używana.)',
        'Frontend module registration (disable ticket processes screen if no process available) for Customer.' =>
            'Widok modułu interfejsu (wyłącz okno procesów jeśli żadne procesy nie są dostepne) dla klienta.',
        'Frontend module registration (disable ticket processes screen if no process available).' =>
            'Widok modułu interfejsu (wyłącz okno procesów jeśli żadne procesy nie są dostepne).',
        'Frontend module registration (show personal favorites as sub navigation items of \'Admin\').' =>
            '',
        'Frontend module registration for the agent interface.' => 'Rejestracja modułu interfejsu dla interfejsu agenta.',
        'Frontend module registration for the customer interface.' => 'Rejestracja modułu interfejsu dla interfejsu klienta.',
        'Frontend module registration for the public interface.' => 'Rejestracja modułu interfejsu dla interfejsu publicznego.',
        'Full value' => '',
        'Fulltext index regex filters to remove parts of the text.' => 'Indeks filtrów pełnotekstowych do usuwania części tekstu.',
        'Fulltext search' => 'Szukanie pełnotekstowe',
        'Galician' => '',
        'General ticket data shown in the ticket overviews (fall-back). Note that TicketNumber can not be disabled, because it is necessary.' =>
            '',
        'Generate dashboard statistics.' => '',
        'Generic Info module.' => '',
        'GenericAgent' => 'Agent automatyczny',
        'GenericInterface Debugger GUI' => 'Interfejs debugera GenericInterface',
        'GenericInterface ErrorHandling GUI' => '',
        'GenericInterface Invoker Event GUI' => '',
        'GenericInterface Invoker GUI' => 'Interfejs wzywajacy GenericInterface',
        'GenericInterface Operation GUI' => 'Interfejs operacji GenericInterface',
        'GenericInterface TransportHTTPREST GUI' => '',
        'GenericInterface TransportHTTPSOAP GUI' => 'Interfejs TransportHTTPSOAP GenericInterface',
        'GenericInterface Web Service GUI' => 'Interfejs serwisu sieciowego GenericInterface',
        'GenericInterface Web Service History GUI' => '',
        'GenericInterface Web Service Mapping GUI' => '',
        'GenericInterface module registration for an error handling module.' =>
            '',
        'GenericInterface module registration for the invoker layer.' => 'Rejestracja modułu GenericInterface dla warstwy wzywającej.',
        'GenericInterface module registration for the mapping layer.' => 'Rejestracja modułu GenericInterface lda warstwy mapującej.',
        'GenericInterface module registration for the operation layer.' =>
            'Rejestracja modułu GenericInterface dla warstwy operacji.',
        'GenericInterface module registration for the transport layer.' =>
            'Rejestracja modułu GenericInterface dla warstwy trasportowej.',
        'German' => 'Niemiecki',
        'German stop words for fulltext index. These words will be removed from the search index.' =>
            '',
        'Gives customer users group based access to tickets from customer users of the same customer (ticket CustomerID is a CustomerID of the customer user).' =>
            '',
        'Gives end users the possibility to override the separator character for CSV files, defined in the translation files. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Global Search Module.' => '',
        'Go to dashboard!' => 'Idź na pulpit!',
        'Good PGP signature.' => '',
        'Google Authenticator' => '',
        'Graph: Bar Chart' => '',
        'Graph: Line Chart' => '',
        'Graph: Stacked Area Chart' => '',
        'Greek' => 'Grecki',
        'Hebrew' => 'Hebrajski',
        'Helps to extend your articles full-text search (From, To, Cc, Subject and Body search). It will strip all articles and will build an index after article creation, increasing fulltext searches about 50%. To create an initial index use "bin/otrs.Console.pl Maint::Ticket::FulltextIndex --rebuild".' =>
            '',
        'High Contrast' => '',
        'High contrast skin for visually impaired users.' => '',
        'Hindi' => 'Hindi',
        'Hungarian' => 'Węgierski',
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
        'If "DB" was selected for Customer::AuthModule, the encryption type of passwords must be specified.' =>
            '',
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
        'If "SysLog" was selected for LogModule, the charset that should be used for logging can be specified.' =>
            'Jeśli wybrano "SysLog" dla LogModule wówczas tablica kodowa znaków dla logowania może zostać wybrana.',
        'If "bcrypt" was selected for CryptType, use cost specified here for bcrypt hashing. Currently max. supported cost value is 31.' =>
            '',
        'If "file" was selected for LogModule, a logfile must be specified. If the file doesn\'t exist, it will be created by the system.' =>
            '',
        'If active, none of the regular expressions may match the user\'s email address to allow registration.' =>
            'Jeśli aktywne, żadne z wyrażeń regularnych nie może pasować do adresu e-mail użytkownika by mógł on się zarejestrować.',
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
        'If enabled the daemon will redirect the standard error stream to a log file.' =>
            '',
        'If enabled the daemon will redirect the standard output stream to a log file.' =>
            '',
        'If enabled the daemon will use this directory to create its PID files. Note: Please stop the daemon before any change and use this setting only if <$OTRSHome>/var/run/ can not be used.' =>
            '',
        'If enabled, OTRS will deliver all CSS files in minified form.' =>
            '',
        'If enabled, OTRS will deliver all JavaScript files in minified form.' =>
            '',
        'If enabled, TicketPhone and TicketEmail will be open in new windows.' =>
            'Jeśli włączone to zgłoszenia telefoniczne i e-mail będą otwierane w nowych oknach.',
        'If enabled, the OTRS version tag will be removed from the Webinterface, the HTTP headers and the X-Headers of outgoing mails. NOTE: If you change this option, please make sure to delete the cache.' =>
            '',
        'If enabled, the cache data be held in memory.' => '',
        'If enabled, the cache data will be stored in cache backend.' => '',
        'If enabled, the customer can search for tickets in all services (regardless what services are assigned to the customer).' =>
            '',
        'If enabled, the different overviews (Dashboard, LockedView, QueueView) will automatically refresh after the specified time.' =>
            'Gdy włączone, przeglądy takie jak Pulpit, Zablokowane, Widok kolejek będą automatycznie odświeżane co zadany czas.',
        'If enabled, the first level of the main menu opens on mouse hover (instead of click only).' =>
            'Jeśli właczone to pierwszy poziom głównego menu otworzone zostanie przez przesunięcie myszy nad nie (zamiast jedynie poprzez kliknięcie).',
        'If enabled, users that haven\'t selected a time zone yet will be notified to do so. Note: Notification will not be shown if (1) user has not yet selected a time zone and (2) OTRSTimeZone and UserDefaultTimeZone do match and (3) are not set to UTC.' =>
            '',
        'If no SendmailNotificationEnvelopeFrom is specified, this setting makes it possible to use the email\'s from address instead of an empty envelope sender (required in certain mail server configurations).' =>
            '',
        'If set, this address is used as envelope sender header in outgoing notifications. If no address is specified, the envelope sender header is empty (unless SendmailNotificationEnvelopeFrom::FallbackToEmailFrom is set).' =>
            '',
        'If set, this address is used as envelope sender in outgoing messages (not notifications - see below). If no address is specified, the envelope sender is equal to queue e-mail address.' =>
            'Jeśli ustawiony, ten adres jest używany w nagłówku \'envelope sender\' wychodzących wiadomości (nie powiadomień - patrz niżej). Jeżeli nie jest podany żaden adres, nagłówek \'envelope sender\' jest uzupełniany adresem e-mail kolejki.',
        'If this option is enabled, tickets created via the web interface, via Customers or Agents, will receive an autoresponse if configured. If this option is not enabled, no autoresponses will be sent.' =>
            '',
        'If this regex matches, no message will be send by the autoresponder.' =>
            '',
        'If this setting is enabled, it is possible to install packages which are not verified by OTRS Group. These packages could threaten your whole system!' =>
            '',
        'If this setting is enabled, local modifications will not be highlighted as errors in the package manager and support data collector.' =>
            '',
        'If you\'re going to be out of office, you may wish to let other users know by setting the exact dates of your absence.' =>
            'Jeśli będziesz nieobecny, możesz poinformować innych użytkowników o dokładnych datach swojej nieobecności.',
        'Ignore system sender article types (e. g. auto responses or email notifications) to be flagged as \'Unread Article\' in AgentTicketZoom or expanded automatically in Large view screens.' =>
            '',
        'Import appointments screen.' => 'Ekran importu wydarzeń.',
        'Include tickets of subqueues per default when selecting a queue.' =>
            '',
        'Include unknown customers in ticket filter.' => '',
        'Includes article create times in the ticket search of the agent interface.' =>
            'Zawiera czas utworznia artykułów przy wyszukiwaniu zgłoszeń interfejsu agenta.',
        'Incoming Phone Call.' => 'Przychodzące połączenie telefoniczne.',
        'IndexAccelerator: to choose your backend TicketViewAccelerator module. "RuntimeDB" generates each queue view on the fly from ticket table (no performance problems up to approx. 60.000 tickets in total and 6.000 open tickets in the system). "StaticDB" is the most powerful module, it uses an extra ticket-index table that works like a view (recommended if more than 80.000 and 6.000 open tickets are stored in the system). Use the command "bin/otrs.Console.pl Maint::Ticket::QueueIndexRebuild" for initial index creation.' =>
            '',
        'Indicates if a bounce e-mail should always be treated as normal follow-up.' =>
            '',
        'Indonesian' => 'Indonezyjski',
        'Inline' => '',
        'Input' => '',
        'Interface language' => 'Język interfejsu',
        'Internal communication channel.' => '',
        'International Workers\' Day' => 'Międzynarodowy Dzień Pracy',
        'It is possible to configure different skins, for example to distinguish between diferent agents, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            '',
        'It is possible to configure different skins, for example to distinguish between diferent customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            '',
        'It is possible to configure different themes, for example to distinguish between agents and customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid theme on your system. Please see the example entries for the proper form of the regex.' =>
            '',
        'It was not possible to check the PGP signature, this may be caused by a missing public key or an unsupported algorithm.' =>
            '',
        'Italian' => '',
        'Italian stop words for fulltext index. These words will be removed from the search index.' =>
            '',
        'Ivory' => '',
        'Ivory (Slim)' => '',
        'Japanese' => 'Japoński',
        'JavaScript function for the search frontend.' => '',
        'Korean' => '',
        'Language' => 'Język',
        'Large' => 'Duże',
        'Last Screen Overview' => '',
        'Last customer subject' => '',
        'Lastname Firstname' => 'Nazwisko Imię',
        'Lastname Firstname (UserLogin)' => 'Nazwisko Imię (Login)',
        'Lastname, Firstname' => 'Nazwisko, Imię',
        'Lastname, Firstname (UserLogin)' => 'Nazwisko, Imię (Login)',
        'LastnameFirstname' => '',
        'Latvian' => 'Łotewski',
        'Left' => 'Lewo',
        'Link Object' => 'Połącz obiekt',
        'Link Object.' => '',
        'Link agents to groups.' => 'Zarządzanie relacjami Agenci <-> Grupy',
        'Link agents to roles.' => 'Zarządzanie relacjami Agenci <-> Role',
        'Link customer users to customers.' => '',
        'Link customer users to groups.' => '',
        'Link customer users to services.' => '',
        'Link customers to groups.' => '',
        'Link queues to auto responses.' => 'Połącz kolejki z autoodpowiedziami.',
        'Link roles to groups.' => 'Połącz role z grupami.',
        'Link templates to attachments.' => '',
        'Link templates to queues.' => 'Połącz szablony do kolejek.',
        'Link this ticket to other objects' => 'Połącz to zgłoszenie z innymi obiektami',
        'Links 2 tickets with a "Normal" type link.' => 'Łączy 2 zgłoszenia z połączeniem "Zwykłym".',
        'Links 2 tickets with a "ParentChild" type link.' => 'Łączy 2 zgłoszenia z połączeniem "Nadrzędne-Podrzędne".',
        'Links appointments and tickets with a "Normal" type link.' => '',
        'List of CSS files to always be loaded for the agent interface.' =>
            'Lista plików CSS która zawsze zostanie wczytana do interfejsu agenta.',
        'List of CSS files to always be loaded for the customer interface.' =>
            'Lista plików CSS która zawsze zostanie wczytana do interfejsu klienta.',
        'List of JS files to always be loaded for the agent interface.' =>
            'Lista plików JS która zawsze zostanie wczytana do interfejsu agenta.',
        'List of JS files to always be loaded for the customer interface.' =>
            'Lista plików JS która zawsze zostanie wczytana do interfejsu klienta.',
        'List of all CustomerCompany events to be displayed in the GUI.' =>
            'Lista wszystkich wydarzeń związanych z CustomerCompany do wyświetlenia w interfejsie uźytkownika.',
        'List of all CustomerUser events to be displayed in the GUI.' => 'Lista wszystkich wydarzeń związanych z Użytkownikiem do wyświetlenia w interfejsie.',
        'List of all DynamicField events to be displayed in the GUI.' => '',
        'List of all LinkObject events to be displayed in the GUI.' => '',
        'List of all Package events to be displayed in the GUI.' => '',
        'List of all appointment events to be displayed in the GUI.' => '',
        'List of all article events to be displayed in the GUI.' => 'Lista wszystkich wydarzeń związanych z artykułami do wyświetlenia w interfejsie uźytkownika.',
        'List of all calendar events to be displayed in the GUI.' => '',
        'List of all queue events to be displayed in the GUI.' => '',
        'List of all ticket events to be displayed in the GUI.' => 'Lista wszystkich wydarzeń związanych ze zgłoszeniami do wyświetlenia w interfejsie uźytkownika.',
        'List of colors in hexadecimal RGB which will be available for selection during calendar creation. Make sure the colors are dark enough so white text can be overlayed on them.' =>
            '',
        'List of default Standard Templates which are assigned automatically to new Queues upon creation.' =>
            'Lista predefiniowanych szablonów standardowych, które są przypisywane automatycznie do nowych kolejek po utworzeniu.',
        'List of responsive CSS files to always be loaded for the agent interface.' =>
            '',
        'List of responsive CSS files to always be loaded for the customer interface.' =>
            '',
        'List view' => '',
        'Lithuanian' => 'Litewski',
        'Loader module registration for the agent interface.' => '',
        'Loader module registration for the customer interface.' => '',
        'Lock / unlock this ticket' => 'Zablokuj / Odblokuj to zgłoszenie',
        'Locked Tickets' => 'Zablokowane zgłoszenia',
        'Locked Tickets.' => 'Zablokowane zgłoszenia',
        'Locked ticket.' => 'Zablokowano zgłoszenie.',
        'Logged in users.' => 'Zalogowani użytkownicy.',
        'Logged-In Users' => 'Zalogowani Użytkownicy',
        'Logout of customer panel.' => 'Wyloguj z panelu klienta.',
        'Look into a ticket!' => 'Szczegóły zgłoszenia!',
        'Loop protection: no auto-response sent to "%s".' => '',
        'Macedonian' => '',
        'Mail Accounts' => 'Konta Pocztowe',
        'MailQueue configuration settings.' => '',
        'Main menu item registration.' => '',
        'Main menu registration.' => 'Rejstracja okna głównego.',
        'Makes the application block external content loading.' => '',
        'Makes the application check the MX record of email addresses before sending an email or submitting a telephone or email ticket.' =>
            'Powoduje by aplikacja sprawdzała zapisy MX adresów e-mail przed wysłaniem e-mail lub zapisaniem zgłoszenia telefonicznego lub e-mail.',
        'Makes the application check the syntax of email addresses.' => 'Powoduje by aplikacja sprawdzała poprawność adresu e-mail.',
        'Makes the session management use html cookies. If html cookies are disabled or if the client browser disabled html cookies, then the system will work as usual and append the session id to the links.' =>
            '',
        'Malay' => 'Malajski',
        'Manage OTRS Group cloud services.' => 'Zarządzaj usługami chmurowymi OTRS Group.',
        'Manage PGP keys for email encryption.' => 'Zarządzanie kluczami PGP do szyfrowania poczty.',
        'Manage POP3 or IMAP accounts to fetch email from.' => 'Ustawienia konto pocztowych POP3 i IMAP, z których pobierana jest poczta przychodząca do systemu',
        'Manage S/MIME certificates for email encryption.' => 'Zarządzanie certyfikatami S/MIME służącymi do szyfrowania poczty wychodzącej',
        'Manage System Configuration Deployments.' => 'Zarządzaj Wdrożeniami Konfiguracji Systemu.',
        'Manage different calendars.' => '',
        'Manage existing sessions.' => 'Zarządzanie aktywnymi sesjami agentów i klientów',
        'Manage support data.' => 'Zarządzaj danymi wsparcia.',
        'Manage system registration.' => 'Zarządzaj rejestracją systemu.',
        'Manage tasks triggered by event or time based execution.' => 'Zarządza zadaniami wywołanymi zdarzeniami lub zaplanowymi czasowo.',
        'Mark as Spam!' => 'Oznacz jako spam!',
        'Mark this ticket as junk!' => 'Oznacz to zgłoszenie jako SPAM!',
        'Max size (in characters) of the customer information table (phone and email) in the compose screen.' =>
            'Maksymalny rozmiar (w znakach) tablicy informacyjnej klienta (telefon i e-mail) w oknie tworzenia.',
        'Max size (in rows) of the informed agents box in the agent interface.' =>
            'Maksymalny rozmiar (w wierszach) okna poinformowanych agentów w interfejsie agenta.',
        'Max size (in rows) of the involved agents box in the agent interface.' =>
            'Maksymalny rozmiar (w wierszach) okna zaangażowanych agentów w interfejsie agenta.',
        'Max size of the subjects in an email reply and in some overview screens.' =>
            '',
        'Maximal auto email responses to own email-address a day (Loop-Protection).' =>
            'Maksymalna liczba odpowiedzi automatycznych na własne adresy e-mail w ciągu dnia (ochrona przed zapętleniem).',
        'Maximal auto email responses to own email-address a day, configurable by email address (Loop-Protection).' =>
            '',
        'Maximal size in KBytes for mails that can be fetched via POP3/POP3S/IMAP/IMAPS (KBytes).' =>
            'Maksymalny rozmiar w KBajtach dla e-maili które mogą zostać ściągnięte poprzez POP3/POP3S/IMAP/IMAPS (KBajty).',
        'Maximum Number of a calendar shown in a dropdown.' => '',
        'Maximum length (in characters) of the dynamic field in the article of the ticket zoom view.' =>
            'Maksymalna długość (w znakach) w polach dynamicznych poska artykułów w poglądzie zgłoszeń.',
        'Maximum length (in characters) of the dynamic field in the sidebar of the ticket zoom view.' =>
            'Maksymalna długość (w znakach) w polach dynamicznych poska bocznego w poglądzie zgłoszeń.',
        'Maximum number of active calendars in overview screens. Please note that large number of active calendars can have a performance impact on your server by making too much simultaneous calls.' =>
            '',
        'Maximum number of tickets to be displayed in the result of a search in the agent interface.' =>
            'Maksymalna liczba zgłoszeń do wyświetlenia w rezultacie wyszukiwania w interfejsie agenta.',
        'Maximum number of tickets to be displayed in the result of a search in the customer interface.' =>
            'Maksymalna liczba zgłoszeń do wyświetlenia w rezultacie wyszukiwania w interfejsie klienta.',
        'Maximum number of tickets to be displayed in the result of this operation.' =>
            '',
        'Maximum size (in characters) of the customer information table in the ticket zoom view.' =>
            'Maksymalny rozmiar (w znakach) tabeli informacji klienta w przybliżonym widoku zgłoszenia.',
        'Medium' => 'Średnie',
        'Merge this ticket and all articles into another ticket' => '',
        'Merged Ticket (%s/%s) to (%s/%s).' => '',
        'Merged Ticket <OTRS_TICKET> to <OTRS_MERGE_TO_TICKET>.' => 'Dołącz Ticket<OTRS_TICKET> do <OTRS_MERGE_TO_TICKET>.',
        'Minute' => '',
        'Miscellaneous' => 'Różne',
        'Module for To-selection in new ticket screen in the customer interface.' =>
            '',
        'Module to check if a incoming e-mail message is bounce.' => '',
        'Module to check if arrived emails should be marked as internal (because of original forwarded internal email). IsVisibleForCustomer and SenderType define the values for the arrived email/article.' =>
            '',
        'Module to check the group permissions for customer access to tickets.' =>
            '',
        'Module to check the group permissions for the access to tickets.' =>
            '',
        'Module to compose signed messages (PGP or S/MIME).' => 'Moduł tworzący podpisane wiadomości (PGP lub S/MIME)',
        'Module to define the email security options to use (PGP or S/MIME).' =>
            '',
        'Module to encrypt composed messages (PGP or S/MIME).' => '',
        'Module to fetch customer users SMIME certificates of incoming messages.' =>
            '',
        'Module to filter and manipulate incoming messages. Block/ignore all spam email with From: noreply@ address.' =>
            '',
        'Module to filter and manipulate incoming messages. Get a 4 digit number to ticket free text, use regex in Match e. g. From => \'(.+?)@.+?\', and use () as [***] in Set =>.' =>
            '',
        'Module to filter encrypted bodies of incoming messages.' => '',
        'Module to generate accounted time ticket statistics.' => 'Moduł generujący statystyki zliczające czas zgłoszeń.',
        'Module to generate html OpenSearch profile for short ticket search in the agent interface.' =>
            'Moduł generujący profil OpenSearch da krótkich zgłoszeń w interfejsie agenta.',
        'Module to generate html OpenSearch profile for short ticket search in the customer interface.' =>
            'Moduł generujący profil OpenSearch da krótkich zgłoszeń w interfejsie klienta.',
        'Module to generate ticket solution and response time statistics.' =>
            'Moduł generujący statystyki czasu odpowiedzi i rozwiązań zgłoszeń.',
        'Module to generate ticket statistics.' => 'Moduł generowania statystyk zgłoszeń.',
        'Module to grant access if the CustomerID of the customer has necessary group permissions.' =>
            '',
        'Module to grant access if the CustomerID of the ticket matches the CustomerID of the customer.' =>
            '',
        'Module to grant access if the CustomerUserID of the ticket matches the CustomerUserID of the customer.' =>
            '',
        'Module to grant access to any agent that has been involved in a ticket in the past (based on ticket history entries).' =>
            '',
        'Module to grant access to the agent responsible of a ticket.' =>
            '',
        'Module to grant access to the creator of a ticket.' => '',
        'Module to grant access to the owner of a ticket.' => '',
        'Module to grant access to the watcher agents of a ticket.' => '',
        'Module to show notifications and escalations (ShownMax: max. shown escalations, EscalationInMinutes: Show ticket which will escalation in, CacheTime: Cache of calculated escalations in seconds).' =>
            '',
        'Module to use database filter storage.' => 'Moduł do filtrowania zapisów bazy danych.',
        'Module used to detect if attachments are present.' => '',
        'Multiselect' => 'Multiwybór',
        'My Queues' => 'Moje kolejki',
        'My Services' => 'Moje Usługi',
        'My Tickets.' => 'Moje zgłoszenia',
        'Name of custom queue. The custom queue is a queue selection of your preferred queues and can be selected in the preferences settings.' =>
            '',
        'Name of custom service. The custom service is a service selection of your preferred services and can be selected in the preferences settings.' =>
            '',
        'NameX' => 'NazwaX',
        'New Ticket' => 'Nowe zgłoszenie',
        'New Tickets' => 'Nowe zgłoszenia',
        'New Window' => 'Nowe okno',
        'New Year\'s Day' => 'Nowy Rok',
        'New Year\'s Eve' => 'Sylwester',
        'New process ticket' => 'Nowe zgłoszenie procesowe',
        'News about OTRS releases!' => 'Nowości w wersjach OTRS!',
        'News about OTRS.' => 'Aktualności OTRS',
        'Next possible ticket states after adding a phone note in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Next possible ticket states after adding a phone note in the ticket phone outbound screen of the agent interface.' =>
            '',
        'No public key found.' => '',
        'No valid OpenPGP data found.' => '',
        'None' => 'Brak',
        'Norwegian' => 'Norweski',
        'Notification Settings' => 'Ustawienia powiadomień',
        'Notified about response time escalation.' => '',
        'Notified about solution time escalation.' => '',
        'Notified about update time escalation.' => '',
        'Number of displayed tickets' => 'Liczba wyświetlanych zgłoszeń',
        'Number of lines (per ticket) that are shown by the search utility in the agent interface.' =>
            '',
        'Number of tickets to be displayed in each page of a search result in the agent interface.' =>
            '',
        'Number of tickets to be displayed in each page of a search result in the customer interface.' =>
            '',
        'Number of tickets to be displayed in each page.' => '',
        'OTRS Group Services' => '',
        'OTRS News' => 'Wiadomości OTRS',
        'OTRS can use one or more readonly mirror databases for expensive operations like fulltext search or statistics generation. Here you can specify the DSN for the first mirror database.' =>
            '',
        'OTRS doesn\'t support recurring Appointments without end date or number of iterations. During import process, it might happen that ICS file contains such Appointments. Instead, system creates all Appointments in the past, plus Appointments for the next N months (120 months/10 years by default).' =>
            '',
        'Open an external link!' => '',
        'Open tickets (customer user)' => 'Otwarte zgłoszenia (użytkownik klienta)',
        'Open tickets (customer)' => 'Otwarte zgłoszenia (klient)',
        'Option' => '',
        'Optional queue limitation for the CreatorCheck permission module. If set, permission is only granted for tickets in the specified queues.' =>
            '',
        'Optional queue limitation for the InvolvedCheck permission module. If set, permission is only granted for tickets in the specified queues.' =>
            '',
        'Optional queue limitation for the OwnerCheck permission module. If set, permission is only granted for tickets in the specified queues.' =>
            '',
        'Optional queue limitation for the ResponsibleCheck permission module. If set, permission is only granted for tickets in the specified queues.' =>
            '',
        'Other Customers' => '',
        'Out Of Office' => 'Poza biurem',
        'Out Of Office Time' => 'Przebywam poza biurem',
        'Out of Office users.' => 'Użytkownicy poza biurem.',
        'Overloads (redefines) existing functions in Kernel::System::Ticket. Used to easily add customizations.' =>
            '',
        'Overview Escalated Tickets.' => '',
        'Overview Refresh Time' => 'Czas odświeżania przeglądu',
        'Overview of all Tickets per assigned Queue.' => 'Przegląd wszystkich zgłoszeń na przypisaną kolejkę.',
        'Overview of all appointments.' => 'Przegląd wszystkich wydarzeń.',
        'Overview of all escalated tickets.' => '',
        'Overview of all open Tickets.' => 'Przegląd wszystkich otwartych zgłoszeń.',
        'Overview of all open tickets.' => '',
        'Overview of customer tickets.' => '',
        'PGP Key' => 'Klucz PGP',
        'PGP Key Management' => 'Zarządzanie kluczami PGP',
        'PGP Keys' => 'Klucze PGP',
        'Package event module file a scheduler task for update registration.' =>
            '',
        'Parameters for the CreateNextMask object in the preference view of the agent interface. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Parameters for the CustomQueue object in the preference view of the agent interface. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Parameters for the CustomService object in the preference view of the agent interface. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Parameters for the RefreshTime object in the preference view of the agent interface. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Parameters for the column filters of the small ticket overview. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Parameters for the dashboard backend of the customer company information of the agent interface. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the customer id list overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the customer id status widget of the agent interface . "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the customer user information of the agent interface. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the customer user list overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the new tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            '',
        'Parameters for the dashboard backend of the new tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            '',
        'Parameters for the dashboard backend of the open tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            '',
        'Parameters for the dashboard backend of the open tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            '',
        'Parameters for the dashboard backend of the queue overview widget of the agent interface. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "QueuePermissionGroup" is not mandatory, queues are only listed if they belong to this permission group if you enable it. "States" is a list of states, the key is the sort order of the state in the widget. "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            '',
        'Parameters for the dashboard backend of the running process tickets overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            '',
        'Parameters for the dashboard backend of the ticket escalation overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            '',
        'Parameters for the dashboard backend of the ticket escalation overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            '',
        'Parameters for the dashboard backend of the ticket escalation overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            '',
        'Parameters for the dashboard backend of the ticket events calendar of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            '',
        'Parameters for the dashboard backend of the ticket pending reminder overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            '',
        'Parameters for the dashboard backend of the ticket pending reminder overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            '',
        'Parameters for the dashboard backend of the ticket pending reminder overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            '',
        'Parameters for the dashboard backend of the ticket stats of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            '',
        'Parameters for the dashboard backend of the upcoming events widget of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            '',
        'Parameters for the pages (in which the communication log entries are shown) of the communication log overview.' =>
            '',
        'Parameters for the pages (in which the dynamic fields are shown) of the dynamic fields overview. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Parameters for the pages (in which the tickets are shown) of the medium ticket overview. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Parameters for the pages (in which the tickets are shown) of the small ticket overview. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Parameters for the pages (in which the tickets are shown) of the ticket preview overview. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Parameters of the example SLA attribute Comment2.' => 'Parametry dla atrybutu Comment2 przykładowego SLA.',
        'Parameters of the example queue attribute Comment2.' => 'Parametry dla atrybutu Comment2 przykładowej kolejki.',
        'Parameters of the example service attribute Comment2.' => 'Parametry dla atrybutu Comment2 przykładowego serwisu.',
        'Parent' => 'Rodzic',
        'ParentChild' => '',
        'Path for the log file (it only applies if "FS" was selected for LoopProtectionModule and it is mandatory).' =>
            'Ścieżka do logu (używana jedynie wóczas gdy "FS" został wybrany dla LoopProtectionModule i jest on wymagany).',
        'Pending time' => 'Czas oczekiwania',
        'People' => 'Osoby',
        'Performs the configured action for each event (as an Invoker) for each configured web service.' =>
            '',
        'Permitted width for compose email windows.' => 'Dozwolona szerokość dla okien tworzowych e-maili.',
        'Permitted width for compose note windows.' => 'Dozwolona szerokość dla okien tworzonych notatek.',
        'Persian' => 'Perski',
        'Phone Call Inbound' => 'Tel. przych.',
        'Phone Call Outbound' => 'Tel. wych.',
        'Phone Call.' => 'Telefon',
        'Phone call' => 'Telefon',
        'Phone communication channel.' => '',
        'Phone-Ticket' => 'Zgłoszenie telefoniczne',
        'Picture Upload' => '',
        'Picture upload module.' => '',
        'Picture-Upload' => 'Wgrywanie zdjęć',
        'Plugin search' => '',
        'Plugin search module for autocomplete.' => '',
        'Polish' => 'Polski',
        'Portuguese' => 'Portugalski',
        'Portuguese (Brasil)' => 'Portugalski (Brazylia)',
        'PostMaster Filters' => 'Filtrowanie poczty przychodzącej',
        'PostMaster Mail Accounts' => 'Konta pocztowe systemu',
        'Print this ticket' => 'Wydrukuj to zgłoszenie',
        'Priorities' => 'Priorytety',
        'Process Management Activity Dialog GUI' => 'Zarządzanie procesem interfejsu aktywności dialogu',
        'Process Management Activity GUI' => 'Zarządzanie procesem interfejsu aktywności',
        'Process Management Path GUI' => 'Zarządzanie procesem interfejsu ścieżki',
        'Process Management Transition Action GUI' => 'Zarządzanie procesem interfejsu akcji przejścia',
        'Process Management Transition GUI' => 'Zarządzanie procesem interfejsu przejścia',
        'Process Ticket.' => 'Zgłoszenie procesowe.',
        'Process pending tickets.' => '',
        'ProcessID' => '',
        'Processes & Automation' => '',
        'Product News' => 'Wiadomości o produkcie',
        'Protection against CSRF (Cross Site Request Forgery) exploits (for more info see https://en.wikipedia.org/wiki/Cross-site_request_forgery).' =>
            '',
        'Provides a matrix overview of the tickets per state per queue' =>
            '',
        'Provides customer users access to tickets even if the tickets are not assigned to a customer user of the same customer ID(s), based on permission groups.' =>
            '',
        'Public Calendar' => 'Kalendarz Publiczny',
        'Public calendar.' => 'Kalendarz publiczny.',
        'Queue view' => 'Widok kolejek',
        'Queues ↔ Auto Responses' => '',
        'Rebuild the ticket index for AgentTicketQueue.' => '',
        'Recognize if a ticket is a follow-up to an existing ticket using an external ticket number. Note: the first capturing group from the \'NumberRegExp\' expression will be used as the ticket number value.' =>
            '',
        'Refresh interval' => 'Interwał odświeżania',
        'Registers a log module, that can be used to log communication related information.' =>
            '',
        'Reminder Tickets' => 'Przypomnienia zgłoszeń',
        'Removed subscription for user "%s".' => 'Usunięto subskrypcje dla użytkownika "%s".',
        'Removes old generic interface debug log entries created before the specified amount of days.' =>
            '',
        'Removes old system configuration deployments (Sunday mornings).' =>
            '',
        'Removes old ticket number counters (each 10 minutes).' => '',
        'Removes the ticket watcher information when a ticket is archived.' =>
            '',
        'Renew existing SMIME certificates from customer backend. Note: SMIME and SMIME::FetchFromCustomer needs to be enabled in SysConfig and customer backend needs to be configured to fetch UserSMIMECertificate attribute.' =>
            '',
        'Replaces the original sender with current customer\'s email address on compose answer in the ticket compose screen of the agent interface.' =>
            'Zamienia oryginalnego nadawcę obecnym adresem e-mail klienta przy tworzonej odpowiedzi w oknie odpowiedzi interfejsu agenta.',
        'Reports' => 'Raporty',
        'Reports (OTRS Business Solution™)' => 'Raporty (OTRS Business Solution™)',
        'Reprocess mails from spool directory that could not be imported in the first place.' =>
            '',
        'Required permissions to change the customer of a ticket in the agent interface.' =>
            'Wymagane uprawnienia do zmiany klienta w zgłoszeniu w panelu agenta.',
        'Required permissions to use the close ticket screen in the agent interface.' =>
            'Wymagane uprawnienia do użycia okna zamknięcia zgłoszenia w panelu agenta.',
        'Required permissions to use the email outbound screen in the agent interface.' =>
            '',
        'Required permissions to use the email resend screen in the agent interface.' =>
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
        'Resend Ticket Email.' => '',
        'Resent email to "%s".' => '',
        'Resets and unlocks the owner of a ticket if it was moved to another queue.' =>
            'Resetuje i odblokowuje właściciela jeśli zgłoszenie zostało przesunięte do innej kolejki.',
        'Resource Overview (OTRS Business Solution™)' => 'Przegląd zasobów (OTRS Business Solution™)',
        'Responsible Tickets' => '',
        'Responsible Tickets.' => '',
        'Restores a ticket from the archive (only if the event is a state change to any open available state).' =>
            '',
        'Retains all services in listings even if they are children of invalid elements.' =>
            '',
        'Right' => 'Prawa',
        'Roles ↔ Groups' => 'Role ↔ Grupy',
        'Romanian' => '',
        'Run file based generic agent jobs (Note: module name needs to be specified in -configuration-module param e.g. "Kernel::System::GenericAgent").' =>
            '',
        'Running Process Tickets' => '',
        'Runs an initial wildcard search of the existing customer company when accessing the AdminCustomerCompany module.' =>
            '',
        'Runs an initial wildcard search of the existing customer users when accessing the AdminCustomerUser module.' =>
            '',
        'Runs the system in "Demo" mode. If enabled, agents can change preferences, such as selection of language and theme via the agent web interface. These changes are only valid for the current session. It will not be possible for agents to change their passwords.' =>
            '',
        'Russian' => 'Rosyjski',
        'S/MIME Certificates' => 'Certyfikaty S/MIME',
        'SMS' => '',
        'SMS (Short Message Service)' => '',
        'Salutations' => 'Powitania',
        'Sample command output' => '',
        'Saves the attachments of articles. "DB" stores all data in the database (not recommended for storing big attachments). "FS" stores the data on the filesystem; this is faster but the webserver should run under the OTRS user. You can switch between the modules even on a system that is already in production without any loss of data. Note: Searching for attachment names is not supported when "FS" is used.' =>
            '',
        'Schedule a maintenance period.' => 'Zaplanuj konserwację',
        'Screen after new ticket' => 'Ekran po utworzeniu zgłoszenia',
        'Search Customer' => 'Szukaj klienta',
        'Search Ticket.' => 'Szukaj zgłoszenia.',
        'Search Tickets.' => 'Szukaj zgłoszeń.',
        'Search User' => 'Szukaj użytkownika',
        'Search backend default router.' => '',
        'Search backend router.' => '',
        'Search.' => 'Szukaj',
        'Second Christmas Day' => 'Boże Narodzenie (drugi dzień)',
        'Second Queue' => 'Druga kolejka',
        'Select after which period ticket overviews should refresh automatically.' =>
            '',
        'Select how many tickets should be shown in overviews by default.' =>
            '',
        'Select the main interface language.' => 'Wybierz główny język interfejsu.',
        'Select the separator character used in CSV files (stats and searches). If you don\'t select a separator here, the default separator for your language will be used.' =>
            'Wybierz znak separatora w pliku CSV (statystyki i wyszukiwania). Jeśli nie wskażesz tutaj separatora, użyty zostanie domyślny separator dla twojego języka.',
        'Select your frontend Theme.' => 'Wybierz schemat wyglądu systemu.',
        'Select your personal time zone. All times will be displayed relative to this time zone.' =>
            '',
        'Select your preferred layout for the software.' => '',
        'Select your preferred theme for OTRS.' => '',
        'Selects the cache backend to use.' => 'Wybiera program cache do użycia',
        'Selects the module to handle uploads via the web interface. "DB" stores all uploads in the database, "FS" uses the file system.' =>
            '',
        'Selects the ticket number generator module. "AutoIncrement" increments the ticket number, the SystemID and the counter are used with SystemID.counter format (e.g. 1010138, 1010139). With "Date" the ticket numbers will be generated by the current date, the SystemID and the counter. The format looks like Year.Month.Day.SystemID.counter (e.g. 200206231010138, 200206231010139). With "DateChecksum"  the counter will be appended as checksum to the string of date and SystemID. The checksum will be rotated on a daily basis. The format looks like Year.Month.Day.SystemID.Counter.CheckSum (e.g. 2002070110101520, 2002070110101535).' =>
            '',
        'Send new outgoing mail from this ticket' => '',
        'Send notifications to users.' => 'Wyślij powiadomienie do użytkowników',
        'Sender type for new tickets from the customer inteface.' => 'Rodzaj wysyłającego dla nowych zgłoszeń z interfejsu klienta.',
        'Sends agent follow-up notification only to the owner, if a ticket is unlocked (the default is to send the notification to all agents).' =>
            '',
        'Sends all outgoing email via bcc to the specified address. Please use this only for backup reasons.' =>
            'Umieszcza wskazany adres jako BCC dla wszystkich wychodzących wiadomości e-mail. Proszę korzystać jedynie dla tworzenia kopii zapasowych.',
        'Sends customer notifications just to the mapped customer.' => '',
        'Sends registration information to OTRS group.' => '',
        'Sends reminder notifications of unlocked ticket after reaching the reminder date (only sent to ticket owner).' =>
            '',
        'Sends the notifications which are configured in the admin interface under "Ticket Notifications".' =>
            'Wysyła powiadomienia skonfigurowane w interfejsie administracyjnym pod "Powiadomienia o zgłoszeniach".',
        'Sent "%s" notification to "%s" via "%s".' => '',
        'Sent auto follow-up to "%s".' => '',
        'Sent auto reject to "%s".' => '',
        'Sent auto reply to "%s".' => '',
        'Sent email to "%s".' => '',
        'Sent email to customer.' => '',
        'Sent notification to "%s".' => '',
        'Serbian Cyrillic' => '',
        'Serbian Latin' => '',
        'Service Level Agreements' => 'Poziomy SLA',
        'Service view' => 'Przegląd usług',
        'ServiceView' => 'PrzeglądUsług',
        'Set a new password by filling in your current password and a new one.' =>
            'Ustaw nowe hasło podając hasło bieżące i nowe',
        'Set sender email addresses for this system.' => 'Ustaw adresy e-mail nadawcy dla tego systemu',
        'Set the default height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            'Ustaw domyślną wysokość (w pixelach) dla artykułów HTML w AgentTicketZoom',
        'Set the limit of tickets that will be executed on a single genericagent job execution.' =>
            'Ustawia limit przetwarzanych zgłoszeń podczas pojedynczego wywołania agenta automatycznego.',
        'Set the maximum height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            'Ustaw maksymalną wysokość (w pixelach) dla artykułów HTML w AgentTicketZoom',
        'Set the minimum log level. If you select \'error\', just errors are logged. With \'debug\' you get all logging messages. The order of log levels is: \'debug\', \'info\', \'notice\' and \'error\'.' =>
            '',
        'Set this ticket to pending' => 'Ustaw czas oczekiwania dla tego zgłoszenia',
        'Sets if SLA must be selected by the agent.' => 'Ustawia czy SLA musi zostać wybrane przez agenta.',
        'Sets if SLA must be selected by the customer.' => 'Ustawia czy SLA musi zostać wybrane przez klienta.',
        'Sets if note must be filled in by the agent. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            '',
        'Sets if queue must be selected by the agent.' => '',
        'Sets if service must be selected by the agent.' => 'Ustawia czy serwis musi zostać wybrany przez agenta.',
        'Sets if service must be selected by the customer.' => 'Ustawia czy serwis musi zostać wybrany przez klienta.',
        'Sets if state must be selected by the agent.' => '',
        'Sets if ticket owner must be selected by the agent.' => 'Ustawia czy właściciel zgłoszenia musi zostać wybrany przez agenta.',
        'Sets if ticket responsible must be selected by the agent.' => '',
        'Sets the PendingTime of a ticket to 0 if the state is changed to a non-pending state.' =>
            '',
        'Sets the age in minutes (first level) for highlighting queues that contain untouched tickets.' =>
            'Ustawia czas w minutach (pierwszy poziom) dla wyróżnienia kolejek z nierozpoczętymi zgłoszeniami.',
        'Sets the age in minutes (second level) for highlighting queues that contain untouched tickets.' =>
            'Ustawia czas w minutach (drugi poziom) dla wyróżnienia kolejek z nierozpoczętymi zgłoszeniami.',
        'Sets the configuration level of the administrator. Depending on the config level, some sysconfig options will be not shown. The config levels are in in ascending order: Expert, Advanced, Beginner. The higher the config level is (e.g. Beginner is the highest), the less likely is it that the user can accidentally configure the system in a way that it is not usable any more.' =>
            'Ustawia poziom konfiguracji dla administratora. Zależnie od poziomu konfiguracji niektóre opcje mogą być niewidoczne. Poziomy trudności są w kolejności wznoszącej: Ekspert, Zaawansowany, Początkujący. Nim wyższy poziom kongifu (np. Początkujacy jest najwyższy) tym mniej prawdopodobne by użytkownik nieumyślnie skofigurował system w sposób który nie pozwala na dalsze jego użycie.',
        'Sets the count of articles visible in preview mode of ticket overviews.' =>
            '',
        'Sets the default article customer visibility for new email tickets in the agent interface.' =>
            '',
        'Sets the default article customer visibility for new phone tickets in the agent interface.' =>
            '',
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
        'Sets the default link type of split tickets in the agent interface.' =>
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
            'Ustawia domyślną treść notatki dla nowych zgłoszeń telefonicznych. Np. \'Nowe zgłoszenie Telefoniczne\' w interfejsie agenta.',
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
        'Sets the inactivity time (in seconds) to pass before a session is killed and a user is logged out.' =>
            '',
        'Sets the maximum number of active agents within the timespan defined in SessionMaxIdleTime before a prior warning will be visible for the logged in agents.' =>
            '',
        'Sets the maximum number of active agents within the timespan defined in SessionMaxIdleTime.' =>
            '',
        'Sets the maximum number of active customers within the timespan defined in SessionMaxIdleTime.' =>
            '',
        'Sets the maximum number of active sessions per agent within the timespan defined in SessionMaxIdleTime.' =>
            '',
        'Sets the maximum number of active sessions per customers within the timespan defined in SessionMaxIdleTime.' =>
            '',
        'Sets the method PGP will use to sing and encrypt emails. Note Inline method is not compatible with RichText messages.' =>
            '',
        'Sets the minimal ticket counter size if "AutoIncrement" was selected as TicketNumberGenerator. Default is 5, this means the counter starts from 10000.' =>
            '',
        'Sets the minutes a notification is shown for notice about upcoming system maintenance period.' =>
            '',
        'Sets the number of lines that are displayed in text messages (e.g. ticket lines in the QueueZoom).' =>
            'Ustawia liczbę linii widocznych w wiadomościach tekstowych (np. linie zgłoszenia w QueueZoom)',
        'Sets the options for PGP binary.' => 'Ustawia opcje dla programu PGP',
        'Sets the password for private PGP key.' => 'Ustawia hasło dla klucza prywatnego PGP',
        'Sets the prefered time units (e.g. work units, hours, minutes).' =>
            'Ustawia preferowaane jednostki czasu (np. jednostki pracy, godziny, minuty).',
        'Sets the preferred digest to be used for PGP binary.' => '',
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
        'Sets the service in the close ticket screen of the agent interface (Ticket::Service needs to be enabled).' =>
            '',
        'Sets the service in the ticket free text screen of the agent interface (Ticket::Service needs to be enabled).' =>
            '',
        'Sets the service in the ticket note screen of the agent interface (Ticket::Service needs to be enabled).' =>
            '',
        'Sets the service in the ticket owner screen of a zoomed ticket in the agent interface (Ticket::Service needs to be enabled).' =>
            '',
        'Sets the service in the ticket pending screen of a zoomed ticket in the agent interface (Ticket::Service needs to be enabled).' =>
            '',
        'Sets the service in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Service needs to be enabled).' =>
            '',
        'Sets the service in the ticket responsible screen of the agent interface (Ticket::Service needs to be enabled).' =>
            '',
        'Sets the state of a ticket in the close ticket screen of the agent interface.' =>
            '',
        'Sets the state of a ticket in the ticket bulk screen of the agent interface.' =>
            '',
        'Sets the state of a ticket in the ticket free text screen of the agent interface.' =>
            '',
        'Sets the state of a ticket in the ticket note screen of the agent interface.' =>
            '',
        'Sets the state of a ticket in the ticket responsible screen of the agent interface.' =>
            '',
        'Sets the state of the ticket in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the state of the ticket in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the state of the ticket in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the stats hook.' => '',
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
        'Sets the ticket type in the close ticket screen of the agent interface (Ticket::Type needs to be enabled).' =>
            '',
        'Sets the ticket type in the ticket bulk screen of the agent interface.' =>
            'Ustawia typ zgłoszenia w oknie zbiorczym zgłoszenia interfejsu agenta ',
        'Sets the ticket type in the ticket free text screen of the agent interface (Ticket::Type needs to be enabled).' =>
            '',
        'Sets the ticket type in the ticket note screen of the agent interface (Ticket::Type needs to be enabled).' =>
            '',
        'Sets the ticket type in the ticket owner screen of a zoomed ticket in the agent interface (Ticket::Type needs to be enabled).' =>
            '',
        'Sets the ticket type in the ticket pending screen of a zoomed ticket in the agent interface (Ticket::Type needs to be enabled).' =>
            '',
        'Sets the ticket type in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Type needs to be enabled).' =>
            '',
        'Sets the ticket type in the ticket responsible screen of the agent interface (Ticket::Type needs to be enabled).' =>
            '',
        'Sets the time zone being used internally by OTRS to e. g. store dates and times in the database. WARNING: This setting must not be changed once set and tickets or any other data containing date/time have been created.' =>
            '',
        'Sets the time zone that will be assigned to newly created users and will be used for users that haven\'t yet set a time zone. This is the time zone being used as default to convert date and time between the OTRS time zone and the user\'s time zone.' =>
            '',
        'Sets the timeout (in seconds) for http/ftp downloads.' => 'Ustawia limit czasowy (w sekundach) dla pobrań http/ftp.',
        'Sets the timeout (in seconds) for package downloads. Overwrites "WebUserAgent::Timeout".' =>
            'Ustawia limit czasowy (w sekundach) dla pobrań pakietów. Nadpisuje "WebUserAgent::Timeout".',
        'Shared Secret' => '',
        'Show a responsible selection in phone and email tickets in the agent interface.' =>
            'Pokazuje wybór odpowiedzialnego w zgloszeniach telefonicznych oraz e-mail interfejsu agenta.',
        'Show article as rich text even if rich text writing is disabled.' =>
            '',
        'Show command line output.' => 'Pokaż komunikaty wyjściowe linii komend.',
        'Show queues even when only locked tickets are in.' => '',
        'Show the current owner in the customer interface.' => 'Pokazuje obecnego właściciela w interfejsie klienta.',
        'Show the current queue in the customer interface.' => 'Pokazuje obecną kolejkę w interfejsie klienta.',
        'Show the history for this ticket' => 'Pokaż historię tego zgłoszenia',
        'Show the ticket history' => 'Pokaż historię zgłoszenia',
        'Shows a count of attachments in the ticket zoom, if the article has attachments.' =>
            '',
        'Shows a link in the menu for creating a calendar appointment linked to the ticket directly from the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu for subscribing / unsubscribing from a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu that allows linking a ticket with another object in the ticket zoom view of the agent interface.  Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu that allows merging tickets in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to access the history of a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to add a free text field in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to add a note in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to add a note to a ticket in every ticket overview of the agent interface.' =>
            'Pokazuje w menu link do dodania notatki do zgłoszenia w kazdym podglądzie zgłoszenia interfejsu agenta.',
        'Shows a link in the menu to add a phone call inbound in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to add a phone call outbound in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to change the customer who requested the ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to change the owner of a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to change the responsible agent of a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to close a ticket in every ticket overview of the agent interface.' =>
            'Pokazuje w menu link do zamknięcia zgłoszenia w każdym zgłoszeniu interfejsu agenta.',
        'Shows a link in the menu to close a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to delete a ticket in every ticket overview of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Shows a link in the menu to delete a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to enroll a ticket into a process in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to go back in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to lock / unlock a ticket in the ticket overviews of the agent interface.' =>
            'Pokazuje w menu link zalokowania / odblokowania zgłoszenia w przeglądzie zgłoszeń interfejsu agenta.',
        'Shows a link in the menu to lock/unlock tickets in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to move a ticket in every ticket overview of the agent interface.' =>
            'Pokazuje w menu link przeniesienia zgłoszenia w poglądzie każdego zgłoszenia interfejsu agenta.',
        'Shows a link in the menu to print a ticket or an article in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to see the history of a ticket in every ticket overview of the agent interface.' =>
            'Pokazuje w menu link ukazania historii zgłoszenia w przeglądzie każdego zgłoszenia interfejsu agenta.',
        'Shows a link in the menu to see the priority of a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to send an outbound email in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to set a ticket as junk in every ticket overview of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Shows a link in the menu to set a ticket as pending in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to set the priority of a ticket in every ticket overview of the agent interface.' =>
            'Pokazuje w menu link ustawienia priorytetu zgłoszenia w przeglądzie zgłoszeń interfejsu agenta.',
        'Shows a link in the menu to zoom a ticket in the ticket overviews of the agent interface.' =>
            'Pokazuje w menu link do przybliżenia zgłoszenia w oidglądach zgłoszeń interfejsu agenta.',
        'Shows a link to access article attachments via a html online viewer in the zoom view of the article in the agent interface.' =>
            'Pokazuje link dostępu do załączników artykułow w przeglądarce html w widoku przyblizonym artykułu w interfejsie agenta.',
        'Shows a link to download article attachments in the zoom view of the article in the agent interface.' =>
            'Pokazuje link do ściągnięcia załączników artykułu w widoku przybliżonym artykułow w interfejsie agenta.',
        'Shows a link to see a zoomed email ticket in plain text.' => 'Pokazuje link pozwalający na pokazanie poszerzonego podglądu zgłoszenia e-mail bez formatowania tekstu.',
        'Shows a link to set a ticket as junk in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
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
        'Shows a teaser link in the menu for the ticket attachment view of OTRS Business Solution™.' =>
            '',
        'Shows all both ro and rw queues in the queue view.' => 'Pokazuje kolejki ro i rw w widoku kolejek.',
        'Shows all both ro and rw tickets in the service view.' => '',
        'Shows all open tickets (even if they are locked) in the escalation view of the agent interface.' =>
            'Pokazuje wszystkie otwarte zgłoszenia (nawet jeśli sa zablokowane) w widoku eskalacji interfejsu agenta.',
        'Shows all the articles of the ticket (expanded) in the agent zoom view.' =>
            '',
        'Shows all the articles of the ticket (expanded) in the customer zoom view.' =>
            '',
        'Shows all the customer identifiers in a multi-select field (not useful if you have a lot of customer identifiers).' =>
            'Pokazuje wszystkie identyfikatory klientów w plou multiwyboru (nieuzyteczne jeśli posiadasz większą ilość identyfikatorów).',
        'Shows all the customer user identifiers in a multi-select field (not useful if you have a lot of customer user identifiers).' =>
            '',
        'Shows an owner selection in phone and email tickets in the agent interface.' =>
            'Pokazuje selekcję właścicieli dla zgłoszeń telefonicznych oraz e-mail interfejsu agenta.',
        'Shows customer history tickets in AgentTicketPhone, AgentTicketEmail and AgentTicketCustomer.' =>
            'Pokazuje historię klienta dla zgłoszeń  AgentTicketPhone, AgentTicketEmail i AgentTicketCustomer.',
        'Shows either the last customer article\'s subject or the ticket title in the small format overview.' =>
            'Pokazuje ostatni temat artykułu klienta lub tytuł zgłoszenia w podglądzie o małym formacie.',
        'Shows existing parent/child queue lists in the system in the form of a tree or a list.' =>
            'Pokazuje bieżące listy kolejek nadrzędna/podrzędna w systemie w formie drzewa lub listy.',
        'Shows information on how to start OTRS Daemon' => '',
        'Shows link to external page in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Shows the article head information in the agent zoom view.' => '',
        'Shows the articles sorted normally or in reverse, under ticket zoom in the agent interface.' =>
            'Pokazuje artykuły posortowane w zwykły lub odwrócony sposób pod przybliżeniem zgłoszenia w interfejsie agenta.',
        'Shows the customer user information (phone and email) in the compose screen.' =>
            'Pokazuje informację o użytkowniku (telefon i e-mail) w oknie rejestracji zgłoszenia.',
        'Shows the enabled ticket attributes in the customer interface (0 = Disabled and 1 = Enabled).' =>
            '',
        'Shows the message of the day (MOTD) in the agent dashboard. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
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
        'Shows the title field in the close ticket screen of the agent interface.' =>
            '',
        'Shows the title field in the ticket free text screen of the agent interface.' =>
            '',
        'Shows the title field in the ticket note screen of the agent interface.' =>
            '',
        'Shows the title field in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows the title field in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows the title field in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows the title field in the ticket responsible screen of the agent interface.' =>
            '',
        'Shows time in long format (days, hours, minutes), if enabled; or in short format (days, hours), if not enabled.' =>
            '',
        'Shows time use complete description (days, hours, minutes), if enabled; or just first letter (d, h, m), if not enabled.' =>
            '',
        'Signature data.' => '',
        'Signatures' => 'Podpisy',
        'Simple' => 'Prosty',
        'Skin' => 'Skórka',
        'Slovak' => 'Słowacki',
        'Slovenian' => 'Słoweński',
        'Small' => 'Małe',
        'Software Package Manager.' => 'Manager Pakietów Oprogramowania.',
        'Solution time' => 'Czas rozwiązania',
        'SolutionDiffInMin' => 'Różnica rozwiązań w minutach',
        'SolutionInMin' => 'Rozwiązanie w minutach',
        'Some description!' => 'Jakiś opis!',
        'Some picture description!' => '',
        'Sorts the tickets (ascendingly or descendingly) when a single queue is selected in the queue view and after the tickets are sorted by priority. Values: 0 = ascending (oldest on top, default), 1 = descending (youngest on top). Use the QueueID for the key and 0 or 1 for value.' =>
            '',
        'Sorts the tickets (ascendingly or descendingly) when a single queue is selected in the service view and after the tickets are sorted by priority. Values: 0 = ascending (oldest on top, default), 1 = descending (youngest on top). Use the ServiceID for the key and 0 or 1 for value.' =>
            '',
        'Spam' => '',
        'Spam Assassin example setup. Ignores emails that are marked with SpamAssassin.' =>
            'Przykładowa konfiguracja SpamAssasina. Ignoruje e-maile oznaczone wraz z SpamAssasin',
        'Spam Assassin example setup. Moves marked mails to spam queue.' =>
            'Przykładowa konfiguracja SpamAssasina. Przenosi wszystkie e-maile do kolejki spam.',
        'Spanish' => 'Hiszpański',
        'Spanish (Colombia)' => 'Hiszpański (Kolumbia)',
        'Spanish (Mexico)' => 'Hiszpański (Meksyk)',
        'Spanish stop words for fulltext index. These words will be removed from the search index.' =>
            '',
        'Specifies if an agent should receive email notification of his own actions.' =>
            'Wskazuje czy agent powinien otrzymywacc powiadomienia z swoich własnych działań.',
        'Specifies the directory to store the data in, if "FS" was selected for ArticleStorage.' =>
            '',
        'Specifies the directory where SSL certificates are stored.' => 'Wskazuje katalog w którym umieszczony są certyfikaty SSL.',
        'Specifies the directory where private SSL certificates are stored.' =>
            'Wskazuje katalog w którym umieszczony są prywatne certyfikaty SSL.',
        'Specifies the email address that should be used by the application when sending notifications. The email address is used to build the complete display name for the notification master (i.e. "OTRS Notifications" otrs@your.example.com). You can use the OTRS_CONFIG_FQDN variable as set in your configuation, or choose another email address.' =>
            '',
        'Specifies the email addresses to get notification messages from scheduler tasks.' =>
            '',
        'Specifies the group where the user needs rw permissions so that he can access the "SwitchToCustomer" feature.' =>
            'Wskazuje grupę do której użytkownik potrzebuje praw zapisu by uzyskać dostęp do funkcji "SwitchToCustomer".',
        'Specifies the group where the user needs rw permissions so that they can edit other users preferences.' =>
            '',
        'Specifies the name that should be used by the application when sending notifications. The sender name is used to build the complete display name for the notification master (i.e. "OTRS Notifications" otrs@your.example.com).' =>
            '',
        'Specifies the order in which the firstname and the lastname of agents will be displayed.' =>
            'Określa kolejność wyświetlania imienia i nazwiska agentów.',
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
        'Specifies the text that should appear in the log file to denote a CGI script entry.' =>
            'Wskazuje tekst który powinien zostac wyświetlony w pliku log by oznaczyć wystąpienie skryptu CGI.',
        'Specifies user id of the postmaster data base.' => 'Wskazuje id uzytkownika w pocztowej bazie danych.',
        'Specifies whether all storage backends should be checked when looking for attachments. This is only required for installations where some attachments are in the file system, and others in the database.' =>
            '',
        'Specifies whether the (MIMEBase) article attachments will be indexed and searchable.' =>
            '',
        'Specify how many sub directory levels to use when creating cache files. This should prevent too many cache files being in one directory.' =>
            '',
        'Specify the channel to be used to fetch OTRS Business Solution™ updates. Warning: Development releases might not be complete, your system might experience unrecoverable errors and on extreme cases could become unresponsive!' =>
            '',
        'Specify the password to authenticate for the first mirror database.' =>
            '',
        'Specify the username to authenticate for the first mirror database.' =>
            '',
        'Stable' => 'Stabilny',
        'Standard available permissions for agents within the application. If more permissions are needed, they can be entered here. Permissions must be defined to be effective. Some other good permissions have also been provided built-in: note, close, pending, customer, freetext, move, compose, responsible, forward, and bounce. Make sure that "rw" is always the last registered permission.' =>
            '',
        'Start number for statistics counting. Every new stat increments this number.' =>
            'Liczba początkowa dla wyliczania statystyk. Każda nowa statystyka będzie o tą liczbę wyższa.',
        'Started response time escalation.' => '',
        'Started solution time escalation.' => '',
        'Started update time escalation.' => '',
        'Starts a wildcard search of the active object after the link object mask is started.' =>
            '',
        'Stat#' => 'Statystyka#',
        'States' => 'Stany',
        'Statistic Reports overview.' => 'Przegląd Raportów Statystycznych.',
        'Statistics overview.' => 'Przegląd statystyk.',
        'Status view' => 'Podgląd stanów',
        'Stopped response time escalation.' => '',
        'Stopped solution time escalation.' => '',
        'Stopped update time escalation.' => '',
        'Stores cookies after the browser has been closed.' => 'Przechowuje ciasteczka po zakmnięciu przeglądarki.',
        'Strips empty lines on the ticket preview in the queue view.' => 'Usuwa puste linie z podglądu zgłoszenia w widoku kolejki.',
        'Strips empty lines on the ticket preview in the service view.' =>
            '',
        'Support Agent' => '',
        'Swahili' => '',
        'Swedish' => 'Szwedzki',
        'System Address Display Name' => '',
        'System Configuration Deployment' => 'Wdrażanie Konfiguracji Systemu',
        'System Configuration Group' => '',
        'System Maintenance' => 'Konserwacja systemu',
        'Templates ↔ Attachments' => '',
        'Templates ↔ Queues' => 'Szablony ↔ Kolejki',
        'Textarea' => 'Pole tekstowe',
        'Thai' => 'Tajski',
        'The PGP signature is expired.' => '',
        'The PGP signature was made by a revoked key, this could mean that the signature is forged.' =>
            '',
        'The PGP signature was made by an expired key.' => '',
        'The PGP signature with the keyid has not been verified successfully.' =>
            '',
        'The PGP signature with the keyid is good.' => '',
        'The agent skin\'s InternalName which should be used in the agent interface. Please check the available skins in Frontend::Agent::Skins.' =>
            '',
        'The customer skin\'s InternalName which should be used in the customer interface. Please check the available skins in Frontend::Customer::Skins.' =>
            '',
        'The daemon registration for the scheduler cron task manager.' =>
            '',
        'The daemon registration for the scheduler future task manager.' =>
            '',
        'The daemon registration for the scheduler generic agent task manager.' =>
            '',
        'The daemon registration for the scheduler task worker.' => '',
        'The daemon registration for the system configuration deployment sync manager.' =>
            '',
        'The divider between TicketHook and ticket number. E.g \': \'.' =>
            'Podzielnik pomiędzy TicketHook i numerem zgłoszenia. Np. \': \'.',
        'The duration in minutes after emitting an event, in which the new escalation notify and start events are suppressed.' =>
            '',
        'The format of the subject. \'Left\' means \'[TicketHook#:12345] Some Subject\', \'Right\' means \'Some Subject [TicketHook#:12345]\', \'None\' means \'Some Subject\' and no ticket number. In the latter case you should verify that the setting PostMaster::CheckFollowUpModule###0200-References is activated to recognize followups based on email headers.' =>
            'Formatowanie tematu. \'Lewo\' oznacza \'[TicketHook#:12345] Pewien Temat\'. \'Prawo\' oznacza \'Pewien Temat [TicketHook#:12345]\', \'Brak\' oznacza \'Pewien Temat\' bez określania numeru zgłoszenia. W ostatnim przypadku sprawdź, czy ustawienie odpowiadające za rozpoznawanie kolejnych wiadomości w oparciu o nagłówki: PostMaster::CheckFollowUpModule###0200-References jest włączone',
        'The headline shown in the customer interface.' => 'Nagłówek widoczny w interfejsie klienta.',
        'The identifier for a ticket, e.g. Ticket#, Call#, MyTicket#. The default is Ticket#.' =>
            'Identyfikator zgłoszenia np. Ticket#, Call#, MyTicket#. Domyślny to Ticket#.',
        'The logo shown in the header of the agent interface for the skin "High Contrast". See "AgentLogo" for further description.' =>
            'Logo wyświetlane w nagłówku interfejsu agenta dla skórki "Wysoki kontrast". Zajrzyj do "AgentLogo" w celu uzyskania dalszych wyjaśnień.',
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
        'The logo shown on top of the login box of the agent interface. The URL to the image can be a relative URL to the skin image directory, or a full URL to a remote web server.' =>
            'Logo wyświetlane nad oknem logowania interfejsu agenta. URL do obrazka może być podany jako relatywny URL do katalogu skórek, lub pełny URL do zewnętrznego serwera.',
        'The maximal number of articles expanded on a single page in AgentTicketZoom.' =>
            'Maksymalna liczba artykułów rozszerzonych na jednej stronie w AgentTicketZoom.',
        'The maximal number of articles shown on a single page in AgentTicketZoom.' =>
            '',
        'The maximum number of mails fetched at once before reconnecting to the server.' =>
            '',
        'The secret you supplied is invalid. The secret must only contain letters (A-Z, uppercase) and numbers (2-7) and must consist of 16 characters.' =>
            '',
        'The text at the beginning of the subject in an email reply, e.g. RE, AW, or AS.' =>
            'Tekst na początku tematu w odpowiedziach e-mail np. RE lub Odp.',
        'The text at the beginning of the subject when an email is forwarded, e.g. FW, Fwd, or WG.' =>
            'Tekst na początku tematu w e-mailach przesłanch dalej np. FW lub Fwd.',
        'The value of the From field' => '',
        'Theme' => 'Schemat',
        'This event module stores attributes from CustomerUser as DynamicFields tickets. Please see DynamicFieldFromCustomerUser::Mapping setting for how to configure the mapping.' =>
            '',
        'This is a Description for Comment on Framework.' => '',
        'This is a Description for DynamicField on Framework.' => '',
        'This is the default orange - black skin for the customer interface.' =>
            '',
        'This is the default orange - black skin.' => '',
        'This key is not certified with a trusted signature!' => '',
        'This module and its PreRun() function will be executed, if defined, for every request. This module is useful to check some user options or to display news about new applications.' =>
            '',
        'This module is part of the admin area of OTRS.' => '',
        'This option defines the dynamic field in which a Process Management activity entity id is stored.' =>
            'Ta opcja definiuje pole dynamiczne w którym aktywność id Procesu Zarządzania jest zapisana.',
        'This option defines the dynamic field in which a Process Management process entity id is stored.' =>
            'Ta opcja definiuje pole dynamiczne w którym procesy id Procesu Zarządzania są zapisane.',
        'This option defines the process tickets default lock.' => 'Ta opcja definiuje domyślną blokadę dla zgłoszeń procesowych.',
        'This option defines the process tickets default priority.' => 'Ta opcja definiuje domyślny priorytet dla zgłoszeń procesowych.',
        'This option defines the process tickets default queue.' => 'Ta opcja definiuje domyślną kolejkę dla zgłoszeń procesowych.',
        'This option defines the process tickets default state.' => 'Ta opcja definiuje domyślny stan dla zgłoszeń procesowych.',
        'This option will deny the access to customer company tickets, which are not created by the customer user.' =>
            'Opcja blokuje dostęp do zgłoszeń firmowych, które nie zostały utworzone przez użytkownika klienta.',
        'This setting allows you to override the built-in country list with your own list of countries. This is particularly handy if you just want to use a small select group of countries.' =>
            '',
        'This setting is deprecated. Set OTRSTimeZone instead.' => 'To ustawienie jest nieaktualne. Zamiast tego ustaw OTRSTimeZone.',
        'This setting shows the sorting attributes in all overview screen, not only in queue view.' =>
            '',
        'This will allow the system to send text messages via SMS.' => '',
        'Ticket Close.' => 'Zamknij zgłoszenie.',
        'Ticket Compose Bounce Email.' => '',
        'Ticket Compose email Answer.' => '',
        'Ticket Customer.' => 'Zgłoszenie klienta.',
        'Ticket Forward Email.' => '',
        'Ticket FreeText.' => '',
        'Ticket History.' => 'Historia zgłoszenia.',
        'Ticket Lock.' => 'Blokowanie zgłoszenia.',
        'Ticket Merge.' => 'Scalanie zgłoszeń.',
        'Ticket Move.' => 'Przenoszenie zgłoszenia.',
        'Ticket Note.' => 'Notatka zgłoszenia',
        'Ticket Notifications' => 'Powiadomienia o zgłoszeniach',
        'Ticket Outbound Email.' => 'E-mail wychodzący zgłoszenia.',
        'Ticket Overview "Medium" Limit' => 'Limit przeglądu zgłoszeń "Średnie"',
        'Ticket Overview "Preview" Limit' => 'Limit przeglądu zgłoszeń "Podgląd"',
        'Ticket Overview "Small" Limit' => 'Limit przeglądu zgłoszeń "Małe"',
        'Ticket Owner.' => 'Właściciel zgłoszenia.',
        'Ticket Pending.' => 'Zgłoszenie oczekujące.',
        'Ticket Print.' => 'Wydruk zgłoszenia.',
        'Ticket Priority.' => 'Priorytet zgłoszenia.',
        'Ticket Queue Overview' => 'Przegląd zgłoszeń na kolejkach',
        'Ticket Responsible.' => 'Odpowiedzialny za zgłoszenie.',
        'Ticket Watcher' => 'Obserwujący zgłoszenie',
        'Ticket Zoom' => 'Szczegóły zgłoszenia',
        'Ticket Zoom.' => 'Szczegóły zgłoszenia.',
        'Ticket bulk module.' => '',
        'Ticket event module that triggers the escalation stop events.' =>
            '',
        'Ticket limit per page for Ticket Overview "Medium".' => '',
        'Ticket limit per page for Ticket Overview "Preview".' => '',
        'Ticket limit per page for Ticket Overview "Small".' => '',
        'Ticket notifications' => 'Powiadomienia o zgłoszeniach',
        'Ticket overview' => 'Lista zgłoszeń',
        'Ticket plain view of an email.' => '',
        'Ticket split dialog.' => 'Okno podziału zgłoszenia',
        'Ticket title' => 'Tytuł zgłoszenia',
        'Ticket zoom view.' => 'Widok szczegółów zgłoszenia.',
        'TicketNumber' => 'Numer zgłoszenia',
        'Tickets.' => 'Zgłoszenia.',
        'Time in seconds that gets added to the actual time if setting a pending-state (default: 86400 = 1 day).' =>
            'Czas w sekundach, ktory zostanie dodany do czasu właściwego jeśli ustawiono stan oczekiwania (domyślnie: 86400 = 1 dzień)',
        'To accept login information, such as an EULA or license.' => '',
        'To download attachments.' => '',
        'To view HTML attachments.' => '',
        'Toggles display of OTRS FeatureAddons list in PackageManager.' =>
            'Przęłacza widok ukazanych dodatków w Menadzeże Pakietów.',
        'Toolbar Item for a shortcut. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Transport selection for appointment notifications. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Transport selection for ticket notifications. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Tree view' => 'Widok drzewa',
        'Triggers add or update of automatic calendar appointments based on certain ticket times.' =>
            '',
        'Triggers ticket escalation events and notification events for escalation.' =>
            '',
        'Turkish' => 'turecki',
        'Turns off SSL certificate validation, for example if you use a transparent HTTPS proxy. Use at your own risk!' =>
            '',
        'Turns on drag and drop for the main navigation.' => '',
        'Turns on the remote ip address check. It should not be enabled if the application is used, for example, via a proxy farm or a dialup connection, because the remote ip address is mostly different for the requests.' =>
            '',
        'Tweak the system as you wish.' => '',
        'Type of daemon log rotation to use: Choose \'OTRS\' to let OTRS system to handle the file rotation, or choose \'External\' to use a 3rd party rotation mechanism (i.e. logrotate). Note: External rotation mechanism requires its own and independent configuration.' =>
            '',
        'Ukrainian' => 'ukraiński',
        'Unlock tickets that are past their unlock timeout.' => '',
        'Unlock tickets whenever a note is added and the owner is out of office.' =>
            'Odblokowuj zgłoszenia jeżeli zostałą dodana notatka a właściciel jest poza biurem.',
        'Unlocked ticket.' => 'Odblokowano zgłoszenie.',
        'Up' => 'Góra',
        'Upcoming Events' => 'Zbliżające się wydarzenia',
        'Update Ticket "Seen" flag if every article got seen or a new Article got created.' =>
            '',
        'Update time' => 'Czas aktualizacji',
        'Updates the ticket escalation index after a ticket attribute got updated.' =>
            'Aktualizuje indeks eskalacji zgłoszenia po zmianie tego atrybutu.',
        'Updates the ticket index accelerator.' => 'Aktualizuje akcelerator indeksu zgłoszeń.',
        'Upload your PGP key.' => '',
        'Upload your S/MIME certificate.' => '',
        'Use new type of select and autocomplete fields in agent interface, where applicable (InputFields).' =>
            '',
        'Use new type of select and autocomplete fields in customer interface, where applicable (InputFields).' =>
            '',
        'User Profile' => 'Profil użytkownika',
        'UserFirstname' => 'Imię użytkownika',
        'UserLastname' => 'Nazwisko użytkownika',
        'Users, Groups & Roles' => 'Użytkownicy, Grupy i Role',
        'Uses richtext for viewing and editing ticket notification.' => '',
        'Uses richtext for viewing and editing: articles, salutations, signatures, standard templates, auto responses and notifications.' =>
            '',
        'Vietnam' => 'Wietnam',
        'View all attachments of the current ticket' => 'Pokaż wszystkie załączniki bieżącego zgłoszenia',
        'View performance benchmark results.' => 'Objerzyj wyniki testów wydajności systemu',
        'Watch this ticket' => 'Obserwuj to zgłoszenie',
        'Watched Tickets' => 'Obserwowane zgłoszenia',
        'Watched Tickets.' => 'Obserwowane zgłoszenia.',
        'We are performing scheduled maintenance.' => 'Przeprowadzamy zaplanowane prace serwisowe.',
        'We are performing scheduled maintenance. Login is temporarily not available.' =>
            'Przeprowadzamy zaplanowane prace serwisowe. Logowanie jest tymczasowo niedostępne.',
        'We are performing scheduled maintenance. We should be back online shortly.' =>
            'Przeprowadzamy zaplanowane prace serwisowe. System zostanie niedługo udostępniony.',
        'Web Services' => 'Serwisy Sieciowe (WS)',
        'Web View' => 'Widok strony',
        'When agent creates a ticket, whether or not the ticket is automatically locked to the agent.' =>
            '',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. Here you can define the body of this note (this text cannot be changed by the agent).' =>
            'W momencie scalenia zgłoszeń, do zgłoszenia, które nie będzie aktywne zostanie dodana notatka. Tu można zdefiniować treść tej notatki (ten tekst nie może zostać zmieniony przez agenta).',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. Here you can define the subject of this note (this subject cannot be changed by the agent).' =>
            '',
        'When tickets are merged, the customer can be informed per email by setting the check box "Inform Sender". In this text area, you can define a pre-formatted text which can later be modified by the agents.' =>
            '',
        'Whether or not to collect meta information from articles using filters configured in Ticket::Frontend::ZoomCollectMetaFilters.' =>
            '',
        'Whether to force redirect all requests from http to https protocol. Please check that your web server is configured correctly for https protocol before enable this option.' =>
            '',
        'Yes, but hide archived tickets' => 'Tak, ale ukryj zarchiwizowane zgłoszenia',
        'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further information.' =>
            'Twój e-mail ze zgłoszeniem o numerze "<OTRS_TICKET>" został przekazany do "<OTRS_BOUNCE_TO>". Skontaktuj się z tym adresem w celu uzyskania dalszych informacji.',
        'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' =>
            'Twoje zgłoszenie o numerze "<OTRS_TICKET>" zostało scalone z "<OTRS_MERGE_TO_TICKET>".',
        'Your queue selection of your preferred queues. You also get notified about those queues via email if enabled.' =>
            'Wybór ulubionych kolejek spośród dostępnych. O tych kolejkach będziesz informowany emailem, o ile włączysz powiadomienia.',
        'Your service selection of your preferred services. You also get notified about those services via email if enabled.' =>
            'Wybór ulubionych usług spośród dostępnych. O tych usługach będziesz informowany emailem, o ile włączysz powiadomienia.',
        'Zoom' => 'Podgląd',
        'attachment' => 'załącznik',
        'bounce' => 'przekaż',
        'compose' => 'utwórz',
        'debug' => 'debug',
        'error' => 'błąd',
        'forward' => 'prześlij',
        'info' => 'informacja',
        'inline' => 'w treści',
        'normal' => 'normalny',
        'notice' => 'ogłoszenie',
        'pending' => 'oczekujący',
        'phone' => 'telefon',
        'responsible' => 'odpowiedzialny',
        'reverse' => 'odwróć',
        'stats' => 'statystyki',

    };

    $Self->{JavaScriptStrings} = [
        ' ...and %s more',
        ' ...show less',
        '%s B',
        '%s GB',
        '%s KB',
        '%s MB',
        '%s TB',
        '+%s more',
        'A key with this name (\'%s\') already exists.',
        'A package upgrade was recently finished. Click here to see the results.',
        'A popup of this screen is already open. Do you want to close it and load this one instead?',
        'A preview of this website can\'t be provided because it didn\'t allow to be embedded.',
        'Add',
        'Add Event Trigger',
        'Add all',
        'Add entry',
        'Add key',
        'Add new draft',
        'Add new entry',
        'Add to favourites',
        'Agent',
        'All occurrences',
        'All-day',
        'An error occurred during communication.',
        'An error occurred! Please check the browser error log for more details!',
        'An item with this name is already present.',
        'An unconnected transition is already placed on the canvas. Please connect this transition first before placing another transition.',
        'An unknown error occurred when deleting the attachment. Please try again. If the error persists, please contact your system administrator.',
        'An unknown error occurred. Please contact the administrator.',
        'Apply',
        'Appointment',
        'Apr',
        'April',
        'Are you sure you want to delete this appointment? This operation cannot be undone.',
        'Are you sure you want to update all installed packages?',
        'Are you using a browser plugin like AdBlock or AdBlockPlus? This can cause several issues and we highly recommend you to add an exception for this domain.',
        'Article display',
        'Article filter',
        'As soon as you use this button or link, you will leave this screen and its current state will be saved automatically. Do you want to continue?',
        'Ascending sort applied, ',
        'Attachment was deleted successfully.',
        'Attachments',
        'Aug',
        'August',
        'Available space %s of %s.',
        'Basic information',
        'By restoring this deployment all settings will be reverted to the value they had at the time of the deployment. Do you really want to continue?',
        'Calendar',
        'Cancel',
        'Cannot proceed',
        'Clear',
        'Clear all',
        'Clear debug log',
        'Clear search',
        'Click to delete this attachment.',
        'Click to select a file for upload.',
        'Click to select a file or just drop it here.',
        'Click to select files or just drop them here.',
        'Clone web service',
        'Close preview',
        'Close this dialog',
        'Complex %s with %s arguments',
        'Confirm',
        'Could not open popup window. Please disable any popup blockers for this application.',
        'Current selection',
        'Currently not possible',
        'Customer interface does not support articles not visible for customers.',
        'Data Protection',
        'Date/Time',
        'Day',
        'Dec',
        'December',
        'Delete',
        'Delete Entity',
        'Delete conditions',
        'Delete draft',
        'Delete error handling module',
        'Delete field',
        'Delete invoker',
        'Delete operation',
        'Delete this Attachment',
        'Delete this Event Trigger',
        'Delete this Invoker',
        'Delete this Key Mapping',
        'Delete this Mail Account',
        'Delete this Operation',
        'Delete this PostMasterFilter',
        'Delete this Template',
        'Delete web service',
        'Deleting attachment...',
        'Deleting the field and its data. This may take a while...',
        'Deleting the mail account and its data. This may take a while...',
        'Deleting the postmaster filter and its data. This may take a while...',
        'Deleting the template and its data. This may take a while...',
        'Deploy',
        'Deploy now',
        'Deploying, please wait...',
        'Deployment comment...',
        'Deployment successful. You\'re being redirected...',
        'Descending sort applied, ',
        'Description',
        'Dismiss',
        'Do not show this warning again.',
        'Do you really want to continue?',
        'Do you really want to delete "%s"?',
        'Do you really want to delete this certificate?',
        'Do you really want to delete this dynamic field? ALL associated data will be LOST!',
        'Do you really want to delete this generic agent job?',
        'Do you really want to delete this key?',
        'Do you really want to delete this link?',
        'Do you really want to delete this notification language?',
        'Do you really want to delete this notification?',
        'Do you really want to delete this scheduled system maintenance?',
        'Do you really want to delete this statistic?',
        'Do you really want to reset this setting to it\'s default value?',
        'Do you really want to revert this setting to its historical value?',
        'Don\'t save, update manually',
        'Draft title',
        'Duplicate event.',
        'Duplicated entry',
        'Edit Field Details',
        'Edit this setting',
        'Edit this transition',
        'End date',
        'Error',
        'Error during AJAX communication',
        'Error during AJAX communication. Status: %s, Error: %s',
        'Error in the mail settings. Please correct and try again.',
        'Error: Browser Check failed!',
        'Event Type Filter',
        'Expanded',
        'Feb',
        'February',
        'Filters',
        'Find out more',
        'Finished',
        'First select a customer user, then select a customer ID to assign to this ticket.',
        'Fr',
        'Fri',
        'Friday',
        'Generate',
        'Generate Result',
        'Generating...',
        'Grouped',
        'Help',
        'Hide EntityIDs',
        'If you now leave this page, all open popup windows will be closed, too!',
        'Import web service',
        'Information about the OTRS Daemon',
        'Invalid date (need a future date)!',
        'Invalid date (need a past date)!',
        'Invalid date!',
        'It is going to be deleted from the field, please try again.',
        'It is not possible to add a new event trigger because the event is not set.',
        'It is not possible to set this entry to invalid. All affected configuration settings have to be changed beforehand.',
        'It was not possible to delete this draft.',
        'It was not possible to generate the Support Bundle.',
        'Jan',
        'January',
        'Jul',
        'July',
        'Jump',
        'Jun',
        'June',
        'Just this occurrence',
        'Keys with values can\'t be renamed. Please remove this key/value pair instead and re-add it afterwards.',
        'Less',
        'Link',
        'Loading, please wait...',
        'Loading...',
        'Location',
        'Mail check successful.',
        'Mapping for Key',
        'Mapping for Key %s',
        'Mar',
        'March',
        'May',
        'May_long',
        'Mo',
        'Mon',
        'Monday',
        'Month',
        'More',
        'Name',
        'Namespace %s could not be initialized, because %s could not be found.',
        'Next',
        'No Data Available.',
        'No TransitionActions assigned.',
        'No data found.',
        'No dialogs assigned yet. Just pick an activity dialog from the list on the left and drag it here.',
        'No matches found.',
        'No package information available.',
        'No response from get package upgrade result.',
        'No response from get package upgrade run status.',
        'No response from package upgrade all.',
        'No sort applied, ',
        'No space left for the following files: %s',
        'Not available',
        'Notice',
        'Notification',
        'Nov',
        'November',
        'OK',
        'Oct',
        'October',
        'One or more errors occurred!',
        'Open URL in new tab',
        'Open date selection',
        'Open this node in a new window',
        'Please add values for all keys before saving the setting.',
        'Please check the fields marked as red for valid inputs.',
        'Please either turn some off first or increase the limit in configuration.',
        'Please enter at least one search value or * to find anything.',
        'Please enter at least one search word to find anything.',
        'Please note that at least one of the settings you have changed requires a page reload. Click here to reload the current screen.',
        'Please only select at most %s files for upload.',
        'Please only select one file for upload.',
        'Please remove the following words from your search as they cannot be searched for:',
        'Please see the documentation or ask your admin for further information.',
        'Please turn off Compatibility Mode in Internet Explorer!',
        'Please wait...',
        'Preparing to deploy, please wait...',
        'Press Ctrl+C (Cmd+C) to copy to clipboard',
        'Previous',
        'Process state',
        'Queues',
        'Reload page',
        'Reload page (%ss)',
        'Remove',
        'Remove Entity from canvas',
        'Remove active filters for this widget.',
        'Remove all user changes.',
        'Remove from favourites',
        'Remove selection',
        'Remove the Transition from this Process',
        'Remove the filter',
        'Remove this dynamic field',
        'Remove this entry',
        'Repeat',
        'Request Details',
        'Request Details for Communication ID',
        'Reset',
        'Reset globally',
        'Reset locally',
        'Reset option is required!',
        'Reset options',
        'Reset setting',
        'Reset setting on global level.',
        'Resource',
        'Resources',
        'Restore default settings',
        'Restore web service configuration',
        'Rule',
        'Running',
        'Sa',
        'Sat',
        'Saturday',
        'Save',
        'Save and update automatically',
        'Scale preview content',
        'Search',
        'Search attributes',
        'Search the System Configuration',
        'Searching for linkable objects. This may take a while...',
        'Select a customer ID to assign to this ticket',
        'Select a customer ID to assign to this ticket.',
        'Select all',
        'Sending Update...',
        'Sep',
        'September',
        'Setting a template will overwrite any text or attachment.',
        'Settings',
        'Show',
        'Show EntityIDs',
        'Show current selection',
        'Show or hide the content.',
        'Slide the navigation bar',
        'Sorry, but you can\'t disable all methods for notifications marked as mandatory.',
        'Sorry, but you can\'t disable all methods for this notification.',
        'Sorry, the only existing condition can\'t be removed.',
        'Sorry, the only existing field can\'t be removed.',
        'Sorry, the only existing parameter can\'t be removed.',
        'Sorry, you can only upload %s files.',
        'Sorry, you can only upload one file here.',
        'Split',
        'Stacked',
        'Start date',
        'Status',
        'Stream',
        'Su',
        'Sun',
        'Sunday',
        'Support Bundle',
        'Support Data information was successfully sent.',
        'Switch to desktop mode',
        'Switch to mobile mode',
        'System Registration',
        'Team',
        'Th',
        'The browser you are using is too old.',
        'The deployment is already running.',
        'The following files are not allowed to be uploaded: %s',
        'The following files exceed the maximum allowed size per file of %s and were not uploaded: %s',
        'The following files were already uploaded and have not been uploaded again: %s',
        'The item you\'re currently viewing is part of a not-yet-deployed configuration setting, which makes it impossible to edit it in its current state. Please wait until the setting has been deployed. If you\'re unsure what to do next, please contact your system administrator.',
        'The key must not be empty.',
        'The mail could not be sent',
        'There are currently no elements available to select from.',
        'There are no more drafts available.',
        'There is a package upgrade process running, click here to see status information about the upgrade progress.',
        'There was an error deleting the attachment. Please check the logs for more information.',
        'There was an error. Please save all settings you are editing and check the logs for more information.',
        'This Activity cannot be deleted because it is the Start Activity.',
        'This Activity is already used in the Process. You cannot add it twice!',
        'This Transition is already used for this Activity. You cannot use it twice!',
        'This TransitionAction is already used in this Path. You cannot use it twice!',
        'This address already exists on the address list.',
        'This element has children elements and can currently not be removed.',
        'This event is already attached to the job, Please use a different one.',
        'This feature is part of the %s. Please contact us at %s for an upgrade.',
        'This field can have no more than 250 characters.',
        'This field is required.',
        'This is %s',
        'This is a repeating appointment',
        'This is currently disabled because of an ongoing package upgrade.',
        'This item still contains sub items. Are you sure you want to remove this item including its sub items?',
        'This option is currently disabled because the OTRS Daemon is not running.',
        'This software runs with a huge lists of browsers, please upgrade to one of these.',
        'This window must be called from compose window.',
        'Thu',
        'Thursday',
        'Timeline Day',
        'Timeline Month',
        'Timeline Week',
        'Title',
        'Today',
        'Too many active calendars',
        'Try again',
        'Tu',
        'Tue',
        'Tuesday',
        'Unfortunately deploying is currently not possible, maybe because another agent is already deploying. Please try again later.',
        'Unknown',
        'Unlock setting.',
        'Update All Packages',
        'Update Result',
        'Update all packages',
        'Update manually',
        'Upload information',
        'Uploading...',
        'Use options below to narrow down for which tickets appointments will be automatically created.',
        'WARNING: When you change the name of the group \'admin\', before making the appropriate changes in the SysConfig, you will be locked out of the administrations panel! If this happens, please rename the group back to admin per SQL statement.',
        'Warning',
        'Was not possible to send Support Data information.',
        'We',
        'Wed',
        'Wednesday',
        'Week',
        'Would you like to edit just this occurrence or all occurrences?',
        'Yes',
        'You can either have the affected settings updated automatically to reflect the changes you just made or do it on your own by pressing \'update manually\'.',
        'You can use the category selection to limit the navigation tree below to entries from the selected category. As soon as you select the category, the tree will be re-built.',
        'You have undeployed settings, would you like to deploy them?',
        'activate to apply a descending sort',
        'activate to apply an ascending sort',
        'activate to remove the sort',
        'and %s more...',
        'day',
        'month',
        'more',
        'no',
        'none',
        'or',
        'sorting is disabled',
        'user(s) have modified this setting.',
        'week',
        'yes',
    ];

    # $$STOP$$
    return;
}

1;
