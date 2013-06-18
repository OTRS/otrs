# --
# Kernel/Language/de.pm - provides German language translation
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# Copyright (C) 2010 Thomas Kaltenbrunner <tkaltenbrunner at opc.de>
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --
package Kernel::Language::de;

use strict;
use warnings;

sub Data {
    my $Self = shift;

    # $$START$$
    # Last translation file sync: 2013-06-14 08:49:22

    # possible charsets
    $Self->{Charset} = ['utf-8', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Year;)
    $Self->{DateFormat}          = '%D.%M.%Y %T';
    $Self->{DateFormatLong}      = '%T - %D.%M.%Y';
    $Self->{DateFormatShort}     = '%D.%M.%Y';
    $Self->{DateInputFormat}     = '%D.%M.%Y';
    $Self->{DateInputFormatLong} = '%D.%M.%Y - %T';

    # csv separator
    $Self->{Separator} = ';';

    $Self->{Translation} = {

        # Template: AAABase
        'Yes' => 'Ja',
        'No' => 'Nein',
        'yes' => 'ja',
        'no' => 'nein',
        'Off' => 'Aus',
        'off' => 'aus',
        'On' => 'Ein',
        'on' => 'ein',
        'top' => 'hoch',
        'end' => 'runter',
        'Done' => 'Fertig',
        'Cancel' => 'Abbrechen',
        'Reset' => 'Rücksetzen',
        'last' => 'letzten',
        'before' => 'vor',
        'Today' => 'Heute',
        'Tomorrow' => 'Morgen',
        'Next week' => 'Nächste Woche',
        'day' => 'Tag',
        'days' => 'Tage',
        'day(s)' => 'Tag(e)',
        'd' => 'd',
        'hour' => 'Stunde',
        'hours' => 'Stunden',
        'hour(s)' => 'Stunde(n)',
        'Hours' => 'Stunden',
        'h' => 'h',
        'minute' => 'Minute',
        'minutes' => 'Minuten',
        'minute(s)' => 'Minute(n)',
        'Minutes' => 'Minuten',
        'm' => 'm',
        'month' => 'Monat',
        'months' => 'Monate',
        'month(s)' => 'Monat(e)',
        'week' => 'Woche',
        'week(s)' => 'Woche(n)',
        'year' => 'Jahr',
        'years' => 'Jahre',
        'year(s)' => 'Jahr(e)',
        'second(s)' => 'Sekunde(n)',
        'seconds' => 'Sekunden',
        'second' => 'Sekunde',
        's' => 's',
        'wrote' => 'schrieb',
        'Message' => 'Nachricht',
        'Error' => 'Fehler',
        'Bug Report' => 'Fehler berichten',
        'Attention' => 'Achtung',
        'Warning' => 'Warnung',
        'Module' => 'Modul',
        'Modulefile' => 'Moduldatei',
        'Subfunction' => 'Unterfunktion',
        'Line' => 'Zeile',
        'Setting' => 'Einstellung',
        'Settings' => 'Einstellungen',
        'Example' => 'Beispiel',
        'Examples' => 'Beispiele',
        'valid' => 'gültig',
        'Valid' => 'Gültig',
        'invalid' => 'ungültig',
        'Invalid' => 'Ungültig',
        '* invalid' => '* ungültig',
        'invalid-temporarily' => 'ungültig-temporär',
        ' 2 minutes' => ' 2 Minuten',
        ' 5 minutes' => ' 5 Minuten',
        ' 7 minutes' => ' 7 Minuten',
        '10 minutes' => '10 Minuten',
        '15 minutes' => '15 Minuten',
        'Mr.' => 'Herr',
        'Mrs.' => 'Frau',
        'Next' => 'Weiter',
        'Back' => 'Zurück',
        'Next...' => 'Weiter...',
        '...Back' => '...Zurück',
        '-none-' => '-keine-',
        'none' => 'keine',
        'none!' => 'keine Angabe!',
        'none - answered' => 'keine - beantwortet',
        'please do not edit!' => 'Bitte nicht ändern!',
        'Need Action' => 'Aktion nötig',
        'AddLink' => 'Verknüpfung hinzufügen',
        'Link' => 'Verknüpfen',
        'Unlink' => 'Verknüpft aufheben',
        'Linked' => 'Verknüpft',
        'Link (Normal)' => 'Verknüpft (Normal)',
        'Link (Parent)' => 'Verknüpft (Eltern)',
        'Link (Child)' => 'Verknüpft (Kinder)',
        'Normal' => 'Normal',
        'Parent' => 'Eltern',
        'Child' => 'Kinder',
        'Hit' => 'Treffer',
        'Hits' => 'Treffer',
        'Text' => 'Text',
        'Standard' => 'Standard',
        'Lite' => 'Einfach',
        'User' => 'Benutzer',
        'Username' => 'Benutzername',
        'Language' => 'Sprache',
        'Languages' => 'Sprachen',
        'Password' => 'Passwort',
        'Preferences' => 'Einstellungen',
        'Salutation' => 'Anrede',
        'Salutations' => 'Anreden',
        'Signature' => 'Signatur',
        'Signatures' => 'Signaturen',
        'Customer' => 'Kunde',
        'CustomerID' => 'Kundennr.',
        'CustomerIDs' => 'Kundennummern',
        'customer' => 'Kunde',
        'agent' => 'Agent',
        'system' => 'System',
        'Customer Info' => 'Kunden-Info',
        'Customer Information' => 'Kunden-Info',
        'Customer Company' => 'Kunden-Firma',
        'Customer Companies' => 'Kunden-Firma',
        'Company' => 'Firma',
        'go!' => 'Start!',
        'go' => 'Start',
        'All' => 'Alle',
        'all' => 'alle',
        'Sorry' => 'Bedauere',
        'update!' => 'Aktualisieren!',
        'update' => 'Aktualisieren',
        'Update' => 'Aktualisieren',
        'Updated!' => 'Aktualisiert!',
        'submit!' => 'Übermitteln!',
        'submit' => 'Übermitteln',
        'Submit' => 'Übermitteln',
        'change!' => 'Ändern!',
        'Change' => 'Ändern',
        'change' => 'Ändern',
        'click here' => 'hier klicken',
        'Comment' => 'Kommentar',
        'Invalid Option!' => 'Ungültige Option!',
        'Invalid time!' => 'Ungültige Zeitangabe!',
        'Invalid date!' => 'Ungültige Zeitangabe!',
        'Name' => 'Name',
        'Group' => 'Gruppe',
        'Description' => 'Beschreibung',
        'description' => 'Beschreibung',
        'Theme' => 'Schema',
        'Created' => 'Erstellt',
        'Created by' => 'Erstellt von',
        'Changed' => 'Geändert',
        'Changed by' => 'Geändert von',
        'Search' => 'Suche',
        'and' => 'und',
        'between' => 'zwischen',
        'Fulltext Search' => 'Volltextsuche',
        'Data' => 'Daten',
        'Options' => 'Optionen',
        'Title' => 'Titel',
        'Item' => 'Punkt',
        'Delete' => 'Löschen',
        'Edit' => 'Bearbeiten',
        'View' => 'Ansehen',
        'Number' => 'Nummer',
        'System' => 'System',
        'Contact' => 'Kontakt',
        'Contacts' => 'Kontakte',
        'Export' => 'Export',
        'Up' => 'Auf',
        'Down' => 'Ab',
        'Add' => 'Hinzufügen',
        'Added!' => 'Hinzugefügt!',
        'Category' => 'Kategorie',
        'Viewer' => 'Betrachter',
        'Expand' => 'Ausklappen',
        'Small' => 'Klein',
        'Medium' => 'Mittel',
        'Large' => 'Groß',
        'Date picker' => 'Datumsauswahl',
        'New message' => 'Neue Nachricht',
        'New message!' => 'Neue Nachricht!',
        'Please answer this ticket(s) to get back to the normal queue view!' =>
            'Bitte beantworten Sie dieses Ticket, um in die normale Queue-Ansicht zurück zu kommen!',
        'You have %s new message(s)!' => 'Sie haben %s neue Nachricht(en) bekommen!',
        'You have %s reminder ticket(s)!' => 'Sie haben %s Erinnerungs-Ticket(s)!',
        'The recommended charset for your language is %s!' => 'Der empfohlene Zeichensatz für Ihre Sprache ist %s!',
        'Change your password.' => 'Passwort ändern.',
        'Please activate %s first!' => 'Bitte %s zuerst aktivieren.',
        'No suggestions' => 'Keine Vorschläge',
        'Word' => 'Wort',
        'Ignore' => 'Ignorieren',
        'replace with' => 'ersetzen mit',
        'There is no account with that login name.' => 'Es existiert kein Benutzerkonto mit diesem Namen.',
        'Login failed! Your user name or password was entered incorrectly.' =>
            'Anmeldung fehlgeschlagen! Benutzername oder Passwort wurden falsch eingegeben.',
        'There is no acount with that user name.' => 'Es gibt kein Benutzerkonto mit diesem Benutzernamen.',
        'Please contact your administrator' => 'Bitte kontaktieren Sie Ihren Administrator',
        'Logout' => 'Abmelden',
        'Logout successful. Thank you for using %s!' => 'Abmeldung erfolgreich! Danke für die Benutzung von  %s!',
        'Feature not active!' => 'Funktion nicht aktiviert!',
        'Agent updated!' => 'Agent aktualisiert!',
        'Create Database' => 'Datenbank erstellen',
        'System Settings' => 'System Einstellungen',
        'Mail Configuration' => 'Mail-Konfiguration',
        'Finished' => 'Fertig',
        'Install OTRS' => 'OTRS installieren',
        'Intro' => 'Einführung',
        'License' => 'Lizenz',
        'Database' => 'Datenbank',
        'Configure Mail' => 'E-Mail konfigurieren',
        'Database deleted.' => 'Datenbank ausgewählt.',
        'Database setup successful!' => 'Datenbankeinrichtung erfolgreich!',
        'Generated password' => 'Generiertes Passwort',
        'Login is needed!' => 'Login wird benötigt!',
        'Password is needed!' => 'Passwort wird benötigt!',
        'Take this Customer' => 'Kunden übernehmen',
        'Take this User' => 'Benutzer übernehmen',
        'possible' => 'möglich',
        'reject' => 'ablehnen',
        'reverse' => 'umgekehrt',
        'Facility' => 'Einrichtung',
        'Time Zone' => 'Zeit Zone',
        'Pending till' => 'Warten bis',
        'Don\'t use the Superuser account to work with OTRS! Create new Agents and work with these accounts instead.' =>
            'Bitte nicht mit dem Superuser-Account in OTRS arbeiten! Bitte neue Agenten anlegen und mit diesen arbeiten!',
        'Dispatching by email To: field.' => 'Verteilung nach To: Feld.',
        'Dispatching by selected Queue.' => 'Verteilung nach ausgewählter Queue.',
        'No entry found!' => 'Kein Eintrag gefunden!',
        'Session invalid. Please log in again.' => 'Session ungültig. Bitte neu anmelden.',
        'Session has timed out. Please log in again.' => 'Session abgelaufen. Bitte neu anmelden.',
        'Session limit reached! Please try again later.' => 'Maximale Anzahl an Sessions erreicht. Bitte später noch einmal versuchen.',
        'No Permission!' => 'Keine Zugriffsrechte!',
        '(Click here to add)' => '(Hier klicken um hinzuzufügen)',
        'Preview' => 'Vorschau',
        'Package not correctly deployed! Please reinstall the package.' =>
            'Paket nicht korrekt installiert. Bitte erneut installieren.',
        '%s is not writable!' => '%s kann nicht geschrieben werden!',
        'Cannot create %s!' => '%s kann nicht erzeugt werden!',
        'Check to activate this date' => 'Auswählen, um dieses Datum zu aktivieren',
        'You have Out of Office enabled, would you like to disable it?' =>
            'Sie haben die Abwesenheitszeit eingeschaltet, möchten Sie diese deaktiveren?',
        'Customer %s added' => 'Kunde %s hinzugefügt',
        'Role added!' => 'Rolle hinzugefügt!',
        'Role updated!' => 'Rolle aktualisiert!',
        'Attachment added!' => 'Anlage hinzugefügt!',
        'Attachment updated!' => 'Anlage aktualisiert!',
        'Response added!' => 'Antwort hinzugefügt!',
        'Response updated!' => 'Antwort aktualisiert!',
        'Group updated!' => 'Gruppe aktualisiert',
        'Queue added!' => 'Queue hinzugefügt!',
        'Queue updated!' => 'Queue aktualisiert!',
        'State added!' => 'Status hinzugefügt!',
        'State updated!' => 'Status aktualisiert!',
        'Type added!' => 'Typ hinzugefügt!',
        'Type updated!' => 'Typ aktualisiert!',
        'Customer updated!' => 'Kunde aktualisiert!',
        'Customer company added!' => 'Kundenfirma hinzugefügt!',
        'Customer company updated!' => 'Kundenfirma aktualisiert!',
        'Mail account added!' => 'E-Mail-Konto hinzugefügt!',
        'Mail account updated!' => 'E-Mail-Konto aktualisiert!',
        'System e-mail address added!' => 'E-Mail-Adresse hinzugefügt!',
        'System e-mail address updated!' => 'E-Mail-Adresse aktualisiert!',
        'Contract' => 'Vertrag',
        'Online Customer: %s' => 'Online Kunde: %s',
        'Online Agent: %s' => 'Online Agent: %s',
        'Calendar' => 'Kalender',
        'File' => 'Datei',
        'Filename' => 'Dateiname',
        'Type' => 'Typ',
        'Size' => 'Größe',
        'Upload' => 'Hinaufladen',
        'Directory' => 'Verzeichnis',
        'Signed' => 'Signiert',
        'Sign' => 'Signieren',
        'Crypted' => 'Verschlüsselt',
        'Crypt' => 'Verschlüsseln',
        'PGP' => 'PGP',
        'PGP Key' => 'PGP-Schlüssel',
        'PGP Keys' => 'PGP-Schlüssel',
        'S/MIME' => 'S/MIME-Schlüssel',
        'S/MIME Certificate' => 'S/MIME-Zertifikat',
        'S/MIME Certificates' => 'S/MIME-Zertifikate',
        'Office' => 'Büro',
        'Phone' => 'Telefon',
        'Fax' => 'Fax',
        'Mobile' => 'Mobiltelefon',
        'Zip' => 'PLZ',
        'City' => 'Stadt',
        'Street' => 'Straße',
        'Country' => 'Land',
        'Location' => 'Standort',
        'installed' => 'installiert',
        'uninstalled' => 'nicht installiert',
        'Security Note: You should activate %s because application is already running!' =>
            'Sicherheitshinweis: Sie sollten den %s aktivieren, da die Anwendung bereits in Betrieb ist!',
        'Unable to parse repository index document.' => 'Das Indexdokument des Verzeichnisses kann nicht gelesen werden.',
        'No packages for your framework version found in this repository, it only contains packages for other framework versions.' =>
            'Keine Pakete für Ihre Framework-Version in diesem Verzeichnis gefunden, es enthält nur Pakete für andere Framework-Versionen.',
        'No packages, or no new packages, found in selected repository.' =>
            'Keine oder keine neuen Pakete im ausgewählten Verzeichnis gefunden.',
        'Edit the system configuration settings.' => 'Systemeinstellungen bearbeiten',
        'printed at' => 'gedruckt am',
        'Loading...' => 'Laden...',
        'Dear Mr. %s,' => 'Sehr geehrter Herr %s,',
        'Dear Mrs. %s,' => 'Sehr geehrte Frau %s,',
        'Dear %s,' => 'Lieber %s,',
        'Hello %s,' => 'Hallo %s,',
        'This email address already exists. Please log in or reset your password.' =>
            'Diese E-Mail-Adresse existiert bereits. Bitte melden Sie sich an oder ändern Sie ihr Passwort.',
        'New account created. Sent login information to %s. Please check your email.' =>
            'Neues Benutzerkonto angelegt. Anmeldedaten wurden an %s gesendet. Bitte prüfen Sie Ihre E-Mail.',
        'Please press Back and try again.' => 'Bitte auf Zurück klicken und erneut versuchen.',
        'Sent password reset instructions. Please check your email.' => 'Anweisungen zum Zurücksetzen des Passworts wurden gesendet. Bitte prüfen Sie ihre E-Mail.',
        'Sent new password to %s. Please check your email.' => 'Neues Passwort an %s gesendet. Bitte prüfen Sie Ihre E-Mail',
        'Upcoming Events' => 'Anstehende Ereignisse',
        'Event' => 'Ereignis',
        'Events' => 'Ereignisse',
        'Invalid Token!' => 'Ungültiger Token!',
        'more' => 'mehr',
        'Collapse' => 'Zuklappen',
        'Shown' => 'Zeigen',
        'Shown customer users' => 'Angezeigte Kundenbenutzer',
        'News' => 'Neues',
        'Product News' => 'Produkt-Neuigkeiten',
        'OTRS News' => 'OTRS-Neuigkeiten',
        '7 Day Stats' => '7 Tage-Statistik',
        'Process Management information from database is not in sync with the system configuration, please synchronize all processes.' =>
            'Die Konfiguration des Prozessmanagements in der Datenbank ist nicht synchron mit der Systemkonfiguration, bitte synchronisieren Sie alle Prozesse.',
        'Package not verified by the OTRS Group! It is recommended not to use this package.' =>
            'Paket wurde nicht von der OTRS Gruppe verifiziert! Es wird empfohlen dieses Paket nicht zu nutzen.',
        '<br>If you continue to install this package, the following issues may occur!<br><br>&nbsp;-Security problems<br>&nbsp;-Stability problems<br>&nbsp;-Performance problems<br><br>Please note that issues that are caused by working with this package are not covered by OTRS service contracts!<br><br>' =>
            '<br>Wenn Sie die Installation dieses Pakets fortführen, können folgende Probleme auftreten!<br><br>&nbsp;-Sicherheitsprobleme<br>&nbsp;-Stabilitätsprobleme<br>&nbsp;-Performanceprobleme<br><br>Bitte beachten Sie, dass Probleme im Zusammenhang mit diesem Paket nicht durch einen OTRS Servicevertrag abgedeckt sind!<br><br>',
        'Bold' => 'Fett',
        'Italic' => 'Kursiv',
        'Underline' => 'Unterstreichen',
        'Font Color' => 'Schriftfarbe',
        'Background Color' => 'Hintergrundfarbe',
        'Remove Formatting' => 'Entferne Formatierung',
        'Show/Hide Hidden Elements' => 'Zeige/Verstecke versteckte Elemente',
        'Align Left' => 'Ausrichtung linksbündig',
        'Align Center' => 'Ausrichtung zentriert',
        'Align Right' => 'Ausrichtung rechtsbündig',
        'Justify' => 'Blocksatz',
        'Header' => 'Überschrift',
        'Indent' => 'Einzug erhöhen',
        'Outdent' => 'Einzug vermindern',
        'Create an Unordered List' => 'Aufzählungsliste erstellen',
        'Create an Ordered List' => 'Nummerierte Liste erstellen',
        'HTML Link' => 'HTML Verknüpfung',
        'Insert Image' => 'Bild einfügen',
        'CTRL' => 'STRG',
        'SHIFT' => 'Umschalt',
        'Undo' => 'Rückgängig',
        'Redo' => 'Wiederholen',
        'Scheduler process is registered but might not be running.' => 'Scheduler-Prozess ist registriert, scheint aber nicht zu laufen.',
        'Scheduler is not running.' => 'Scheduler läuft nicht.',

        # Template: AAACalendar
        'New Year\'s Day' => 'Neujahr',
        'International Workers\' Day' => 'Tag der Arbeit',
        'Christmas Eve' => 'Heiligabend',
        'First Christmas Day' => '1. Weihnachtstag',
        'Second Christmas Day' => '2. Weihachtstag',
        'New Year\'s Eve' => 'Silvester',

        # Template: AAAGenericInterface
        'OTRS as requester' => 'OTRS als Requester',
        'OTRS as provider' => 'OTRS als Provider',
        'Webservice "%s" created!' => 'Webservice "%s" erstellt!',
        'Webservice "%s" updated!' => 'Webservice "%s" aktualisiert!',

        # Template: AAAMonth
        'Jan' => 'Jan',
        'Feb' => 'Feb',
        'Mar' => 'Mär',
        'Apr' => 'Apr',
        'May' => 'Mai',
        'Jun' => 'Jun',
        'Jul' => 'Jul',
        'Aug' => 'Aug',
        'Sep' => 'Sep',
        'Oct' => 'Okt',
        'Nov' => 'Nov',
        'Dec' => 'Dez',
        'January' => 'Januar',
        'February' => 'Februar',
        'March' => 'März',
        'April' => 'April',
        'May_long' => 'Mai',
        'June' => 'Juni',
        'July' => 'Juli',
        'August' => 'August',
        'September' => 'September',
        'October' => 'Oktober',
        'November' => 'November',
        'December' => 'Dezember',

        # Template: AAAPreferences
        'Preferences updated successfully!' => 'Benutzereinstellungen erfolgreich aktualisiert!',
        'User Profile' => 'Benutzer-Profil',
        'Email Settings' => 'E-Mail-Einstellungen',
        'Other Settings' => 'Andere Einstellungen',
        'Change Password' => 'Passwort ändern',
        'Current password' => 'Aktuelles Passwort',
        'New password' => 'Neues Passwort',
        'Verify password' => 'Passwort verifizieren',
        'Spelling Dictionary' => 'Rechtschreib-Wörterbuch',
        'Default spelling dictionary' => 'Standard Rechtschreib-Wörterbuch',
        'Max. shown Tickets a page in Overview.' => 'Maximale Anzahl angezeigter Tickets pro Seite in der Übersicht.',
        'The current password is not correct. Please try again!' => 'Das eingegebene Passwort ist nicht korrekt. Bitte versuchen Sie es erneut!',
        'Can\'t update password, your new passwords do not match. Please try again!' =>
            'Das Passwort kann nicht aktualisiert werden, da die Eingaben unterschiedlich sind. Bitte versuchen Sie es erneut!',
        'Can\'t update password, it contains invalid characters!' => 'Das Passwort kann nicht aktualisiert werden, da es unerlaubte Zeichen enthält.',
        'Can\'t update password, it must be at least %s characters long!' =>
            'Das Passwort kann nicht aktualisiert werden. Es muss mindestens %s Zeichen lang sein.',
        'Can\'t update password, it must contain at least 2 lowercase  and 2 uppercase characters!' =>
            'Das Passwort kann nicht aktualisiert werden. Es muss mindestens 2 Gross- und 2 Kleinbuchstaben enthalten.',
        'Can\'t update password, it must contain at least 1 digit!' => 'Das Passwort kann nicht aktualisiert werden. Es muss mindestens eine Ziffer enthalten.',
        'Can\'t update password, it must contain at least 2 characters!' =>
            'Das Passwort kann nicht aktualisiert werden. Es muss mindestens 2 Zeichen enthalten.',
        'Can\'t update password, this password has already been used. Please choose a new one!' =>
            'Das Passwort kann nicht aktualisiert werden. Es wird bereits benutzt. Bitte wählen Sie ein neues.',
        'Select the separator character used in CSV files (stats and searches). If you don\'t select a separator here, the default separator for your language will be used.' =>
            'Wählen Sie das Trennzeichen, dass in CSV-Dateien (Statistiken und Suchenergebnisse) benutzt werden soll. Wenn Sie hier kein Zeichen wählen, dann wird das Standard-Trennzeichen gemäß der eingestellten Sprache benutzt.',
        'CSV Separator' => 'Trennzeichen für CSV-Daten',

        # Template: AAAStats
        'Stat' => 'Statistik',
        'Sum' => 'Summe',
        'Please fill out the required fields!' => 'Bitte füllen Sie alle Pflichtfelder aus!',
        'Please select a file!' => 'Bitte wählen Sie eine Datei aus!',
        'Please select an object!' => 'Bitte wählen Sie ein Statistik-Objekt aus!',
        'Please select a graph size!' => 'Bitte legen Sie die Grafikgröße fest!',
        'Please select one element for the X-axis!' => 'Bitte wählen Sie ein Element für die X-Achse aus!',
        'Please select only one element or turn off the button \'Fixed\' where the select field is marked!' =>
            'Bitte wählen Sie nur ein Element aus oder entfernen Sie das Häkchen der Checkbox \'Fixed\'!',
        'If you use a checkbox you have to select some attributes of the select field!' =>
            'Wenn Sie Inhalte eines Auswahlfelds auswählen müssen Sie mindestens zwei Attribute auswählen!',
        'Please insert a value in the selected input field or turn off the \'Fixed\' checkbox!' =>
            'Tragen Sie bitte etwas in die Eingabezeile ein oder entfernen Sie das Häkchen aus der Checkbox \'Fixed\'!',
        'The selected end time is before the start time!' => 'Die ausgewählte Endzeit ist vor der Startzeit!',
        'You have to select one or more attributes from the select field!' =>
            'Bitte wählen Sie bitte ein oder mehrere Attribute aus dem Auswahlfeld aus!',
        'The selected Date isn\'t valid!' => 'Sie haben ein ungültiges Datum ausgewählt!',
        'Please select only one or two elements via the checkbox!' => 'Bitte wählen Sie nur ein oder zwei Elemente aus!',
        'If you use a time scale element you can only select one element!' =>
            'Wenn Sie ein Zeit-Element ausgewählt haben, können Sie nur kein weiteres Element mehr auswählen!',
        'You have an error in your time selection!' => 'Sie haben einen Fehler in Ihrer Zeitauswahl!',
        'Your reporting time interval is too small, please use a larger time scale!' =>
            'Die Zeitskalierung ist zu klein gewählt, bitte wählen Sie eine größere Zeitskalierung!',
        'The selected start time is before the allowed start time!' => 'Die gewählte Startzeit ist außerhalb des erlaubten Bereichs!',
        'The selected end time is after the allowed end time!' => 'Die gewählte Endzeit ist außerhalb des erlaubten Bereichs!',
        'The selected time period is larger than the allowed time period!' =>
            'Der gewählte Zeitraum ist größer als der erlaubte Zeitraum!',
        'Common Specification' => 'Allgemeine Angaben',
        'X-axis' => 'X-Achse',
        'Value Series' => 'Wertereihen',
        'Restrictions' => 'Einschränkungen',
        'graph-lines' => 'Liniendiagramm',
        'graph-bars' => 'Balkendiagramm',
        'graph-hbars' => 'Balkendiagramm (horizontal)',
        'graph-points' => 'Punktdiagramm',
        'graph-lines-points' => 'Linienpunktdiagramm',
        'graph-area' => 'Flächendiagramm',
        'graph-pie' => 'Tortendiagramm',
        'extended' => 'erweitert',
        'Agent/Owner' => 'Agent/Besitzer',
        'Created by Agent/Owner' => 'Erstellt von Agent/Besitzer',
        'Created Priority' => 'Erstellt mit der Priorität',
        'Created State' => 'Erstellt mit dem Status',
        'Create Time' => 'Erstellzeit',
        'CustomerUserLogin' => 'Kundenlogin',
        'Close Time' => 'Schließzeit',
        'TicketAccumulation' => 'Ticket-Aufkommen',
        'Attributes to be printed' => 'Auszugebene Attribute',
        'Sort sequence' => 'Sortierreihenfolge',
        'Order by' => 'Sortieren nach',
        'Limit' => 'Limit',
        'Ticketlist' => 'Ticketliste',
        'ascending' => 'aufsteigend',
        'descending' => 'absteigend',
        'First Lock' => 'Erstmals gesperrt',
        'Evaluation by' => 'Auswertung nach',
        'Total Time' => 'Gesamtzeit',
        'Ticket Average' => 'Durchschnittszeit pro Ticket',
        'Ticket Min Time' => 'Ticket Minimalzeit',
        'Ticket Max Time' => 'Ticket Maximalzeit',
        'Number of Tickets' => 'Anzahl der Tickets',
        'Article Average' => 'Durchschnittszeit pro Artikel',
        'Article Min Time' => 'Artikel Minimalzeit',
        'Article Max Time' => 'Artikel Maximalzeit',
        'Number of Articles' => 'Anzahl der Artikel',
        'Accounted time by Agent' => 'Zeit zugewiesen von Agent',
        'Ticket/Article Accounted Time' => 'Zeit zugewiesen',
        'TicketAccountedTime' => 'Ticket-Bearbeitungszeiten',
        'Ticket Create Time' => 'Ticket-Erstellzeit',
        'Ticket Close Time' => 'Ticket-Schließzeit',

        # Template: AAATicket
        'Status View' => 'Ansicht nach Status',
        'Bulk' => 'Sammelaktion',
        'Lock' => 'Sperren',
        'Unlock' => 'Freigeben',
        'History' => 'Historie',
        'Zoom' => 'Inhalt',
        'Age' => 'Alter',
        'Bounce' => 'Umleiten',
        'Forward' => 'Weiterleiten',
        'From' => 'Von',
        'To' => 'An',
        'Cc' => 'Cc',
        'Bcc' => 'Bcc',
        'Subject' => 'Betreff',
        'Move' => 'Verschieben',
        'Queue' => 'Queue',
        'Queues' => 'Queues',
        'Priority' => 'Priorität',
        'Priorities' => 'Prioritäten',
        'Priority Update' => 'Änderung der Priorität',
        'Priority added!' => 'Priorität hinzugefügt!',
        'Priority updated!' => 'Priorität aktualisiert!',
        'Signature added!' => 'Signatur hinzugefügt!',
        'Signature updated!' => 'Signatur aktualisiert!',
        'SLA' => 'SLA',
        'Service Level Agreement' => 'Service-Level-Vereinbarung',
        'Service Level Agreements' => 'Service-Level-Vereinbarungen',
        'Service' => 'Service',
        'Services' => 'Services',
        'State' => 'Status',
        'States' => 'Status',
        'Status' => 'Status',
        'Statuses' => 'Status',
        'Ticket Type' => 'Ticket Typ',
        'Ticket Types' => 'Ticket Typen',
        'Compose' => 'Verfassen',
        'Pending' => 'Warten',
        'Owner' => 'Besitzer',
        'Owner Update' => 'Besitzer aktualisiert',
        'Responsible' => 'Verantwortlicher',
        'Responsible Update' => 'Verantwortlichen aktualisieren',
        'Sender' => 'Sender',
        'Article' => 'Artikel',
        'Ticket' => 'Ticket',
        'Createtime' => 'Erstellt am',
        'plain' => 'unformatiert',
        'Email' => 'E-Mail',
        'email' => 'E-Mail',
        'Close' => 'Schließen',
        'Action' => 'Aktion',
        'Attachment' => 'Anlage',
        'Attachments' => 'Anlagen',
        'This message was written in a character set other than your own.' =>
            'Diese Nachricht wurde in einem Zeichensatz erstellt, der nicht Ihrem eigenen entspricht.',
        'If it is not displayed correctly,' => 'Wenn sie nicht korrekt angezeigt wird,',
        'This is a' => 'Dies ist eine',
        'to open it in a new window.' => 'um sie in einem neuen Fenster angezeigt zu bekommen',
        'This is a HTML email. Click here to show it.' => 'Dies ist eine HTML E-Mail. Hier klicken, um sie anzuzeigen.',
        'Free Fields' => 'Freie Felder',
        'Merge' => 'Zusammenfassen',
        'merged' => 'zusammengefasst',
        'closed successful' => 'erfolgreich geschlossen',
        'closed unsuccessful' => 'erfolglos geschlossen',
        'Locked Tickets Total' => 'Gesperrte Tickets insgesamt',
        'Locked Tickets Reminder Reached' => 'Gesperrte Tickets, Erinnerungszeit erreicht',
        'Locked Tickets New' => 'Neue gesperrte Tickets',
        'Responsible Tickets Total' => 'Verantwortliche Tickets insgesamt',
        'Responsible Tickets New' => 'Neue verantwortliche Tickets',
        'Responsible Tickets Reminder Reached' => 'Verantwortliche Tickets, Erinnerungszeit erreicht',
        'Watched Tickets Total' => 'Beobachtete Tickets insgesamt',
        'Watched Tickets New' => 'Neue beobachtete Tickets',
        'Watched Tickets Reminder Reached' => 'Beobachtete Tickets, Erinnerungszeit erreicht',
        'All tickets' => 'Alle Tickets',
        'Available tickets' => 'Verfügbare Tickets',
        'Escalation' => 'Eskalation',
        'last-search' => 'Letzte Suche',
        'QueueView' => 'Queue-Ansicht',
        'Ticket Escalation View' => 'Ansicht nach Ticket-Eskalationen',
        'Message from' => 'Nachricht von',
        'End message' => 'Ende der Nachricht',
        'Forwarded message from' => 'Weitergeleitete Nachricht von',
        'End forwarded message' => 'Ende der weitergeleiteten Nachricht',
        'new' => 'neu',
        'open' => 'offen',
        'Open' => 'Offen',
        'Open tickets' => 'Offene Tickets',
        'closed' => 'geschlossen',
        'Closed' => 'Geschlossen',
        'Closed tickets' => 'Geschlossene Tickets',
        'removed' => 'entfernt',
        'pending reminder' => 'warten zur Erinnerung',
        'pending auto' => 'warten auto',
        'pending auto close+' => 'warten auf erfolgreich schließen',
        'pending auto close-' => 'warten auf erfolglos schließen',
        'email-external' => 'E-Mail an extern',
        'email-internal' => 'E-Mail an intern',
        'note-external' => 'Notiz für extern',
        'note-internal' => 'Notiz für intern',
        'note-report' => 'Notiz für reporting',
        'phone' => 'Telefon',
        'sms' => 'SMS',
        'webrequest' => 'Webanfrage',
        'lock' => 'gesperrt',
        'unlock' => 'frei',
        'very low' => 'sehr niedrig',
        'low' => 'niedrig',
        'normal' => 'normal',
        'high' => 'hoch',
        'very high' => 'sehr hoch',
        '1 very low' => '1 sehr niedrig',
        '2 low' => '2 niedrig',
        '3 normal' => '3 normal',
        '4 high' => '4 hoch',
        '5 very high' => '5 sehr hoch',
        'auto follow up' => 'automatische Rückfrage',
        'auto reject' => 'automatische Ablehnung',
        'auto remove' => 'automatisches Entfernen',
        'auto reply' => 'automatische Antwort',
        'auto reply/new ticket' => 'automatische Antwort / neues Ticket',
        'Ticket "%s" created!' => 'Ticket "%s" erstellt!',
        'Ticket Number' => 'Ticket Nummer',
        'Ticket Object' => 'Ticket Objekt',
        'No such Ticket Number "%s"! Can\'t link it!' => 'Ticketnummer "%s" nicht gefunden! Ticket konnte nicht verknüpft werden!',
        'You don\'t have write access to this ticket.' => 'Sie haben keinen Schreibzugriff auf dieses Ticket.',
        'Sorry, you need to be the ticket owner to perform this action.' =>
            'Entschuldigung, Sie müssen Ticketbesitzer sein, um diese Aktion ausführen zu können.',
        'Please change the owner first.' => 'Bitte ändern Sie zunächst den Besitzer.',
        'Ticket selected.' => 'Ticket ausgewählt.',
        'Ticket is locked by another agent.' => 'Das Ticket ist für einen anderen Agenten gesperrt!',
        'Ticket locked.' => 'Ticket gesperrt.',
        'Don\'t show closed Tickets' => 'Geschlossene Tickets nicht zeigen',
        'Show closed Tickets' => 'Geschlossene Tickets anzeigen',
        'New Article' => 'Neuer Artikel',
        'Unread article(s) available' => 'Ungelesene Artikel verfügbar',
        'Remove from list of watched tickets' => 'Von der Liste der beobachteten Tickets streichen',
        'Add to list of watched tickets' => 'Zur Liste der beobachteten Tickets hinzufügen',
        'Email-Ticket' => 'E-Mail-Ticket',
        'Create new Email Ticket' => 'Ein neues E-Mail-Ticket erstellen',
        'Phone-Ticket' => 'Telefon-Ticket',
        'Search Tickets' => 'Ticket-Suche',
        'Edit Customer Users' => 'Kunden-Benutzer bearbeiten',
        'Edit Customer Company' => 'Kunden-Firma bearbeiten',
        'Bulk Action' => 'Sammel-Aktion',
        'Bulk Actions on Tickets' => 'Sammel-Action an Tickets',
        'Send Email and create a new Ticket' => 'E-Mail senden und neues Ticket erstellen',
        'Create new Email Ticket and send this out (Outbound)' => 'Neues Ticket wird erstellt und E-Mail versendet',
        'Create new Phone Ticket (Inbound)' => 'Neues Ticket wird über einkommenden Anruf erstellt',
        'Address %s replaced with registered customer address.' => 'Adresse %s wurde durch die Adresse des eingetragenen Kunden ersetzt.',
        'Customer automatically added in Cc.' => 'Kunde wurde automatisch ins Cc eingetragen.',
        'Overview of all open Tickets' => 'Übersicht über alle offenen Tickets',
        'Locked Tickets' => 'Gesperrte Tickets',
        'My Locked Tickets' => 'Meine gesperrten Tickets',
        'My Watched Tickets' => 'Meine beobachteten Tickets',
        'My Responsible Tickets' => 'Meine verantwortlichen Tickets',
        'Watched Tickets' => 'Beobachtete Tickets',
        'Watched' => 'Beobachtet',
        'Watch' => 'Beobachten',
        'Unwatch' => 'Nicht beobachten',
        'Lock it to work on it' => 'Zur Bearbeitung sperren',
        'Unlock to give it back to the queue' => 'Zur Rückgabe an die Queue entsperren',
        'Show the ticket history' => 'Ticket-Historie anzeigen',
        'Print this ticket' => 'Dieses Ticket drucken',
        'Print this article' => 'Diesen Artikel drucken',
        'Split' => 'Teilen',
        'Split this article' => 'Diesen Artikel teilen',
        'Forward article via mail' => 'Artikel per E-Mail weiterleiten',
        'Change the ticket priority' => 'Ticket-Priorität ändern',
        'Change the ticket free fields!' => 'Ändern der Ticket-Frei-Felder',
        'Link this ticket to other objects' => 'Dieses Ticket mit anderen Objekten verknüpfen',
        'Change the owner for this ticket' => 'Besitzer dieses Tickets ändern',
        'Change the  customer for this ticket' => 'Kunden dieses Tickets ändern',
        'Add a note to this ticket' => 'Eine Notiz zu diesem Ticket hinzufügen',
        'Merge into a different ticket' => 'Mit einem anderen Ticket zusammenfassen',
        'Set this ticket to pending' => 'Ticket auf "warten" setzen',
        'Close this ticket' => 'Dieses Ticket schließen',
        'Look into a ticket!' => 'Ticket genauer ansehen!',
        'Delete this ticket' => 'Dieses Ticket löschen!',
        'Mark as Spam!' => 'Als Spam makieren!',
        'My Queues' => 'Meine Queues',
        'Shown Tickets' => 'Gezeigte Tickets',
        'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' =>
            'Ihre E-Mail mit Ticket-Nummer "<OTRS_TICKET>" wurde zu Ticket-Nummer "<OTRS_MERGE_TO_TICKET>" gemerged!',
        'Ticket %s: first response time is over (%s)!' => 'Ticket %s: Reaktionszeit ist abgelaufen (%s)!',
        'Ticket %s: first response time will be over in %s!' => 'Ticket %s: Reaktionszeit wird ablaufen in %s!',
        'Ticket %s: update time is over (%s)!' => 'Ticket %s: Aktualisierungszeit ist abgelaufen (%s)!',
        'Ticket %s: update time will be over in %s!' => 'Ticket %s: Aktualisierungszeit wird ablaufen in %s!',
        'Ticket %s: solution time is over (%s)!' => 'Ticket %s: Lösungszeit ist abgelaufen (%s)!',
        'Ticket %s: solution time will be over in %s!' => 'Ticket %s: Lösungszeit wird ablaufen in %s!',
        'There are more escalated tickets!' => 'Mehrere eskalierte Tickets vorhanden!',
        'Plain Format' => 'Unformatierte Ansicht',
        'Reply All' => 'Allen antworten',
        'Direction' => 'Richtung',
        'Agent (All with write permissions)' => 'Agent (alle mit Schreibberechtigung)',
        'Agent (Owner)' => 'Agent (Besitzer)',
        'Agent (Responsible)' => 'Agent (Verantwortlicher)',
        'New ticket notification' => 'Mitteilung bei neuem Ticket',
        'Send me a notification if there is a new ticket in "My Queues".' =>
            'Zusenden einer Mitteilung bei neuem Ticket in "Meine Queues".',
        'Send new ticket notifications' => 'Benachrichtigung über neue Tickets senden',
        'Ticket follow up notification' => 'Benachrichtigung über Folgeaktionen',
        'Ticket lock timeout notification' => 'Mitteilung bei Überschreiten der Sperrzeit',
        'Send me a notification if a ticket is unlocked by the system.' =>
            'Benachrichtigung bei einer System-Freigabe eines Tickets ("unlock")',
        'Send ticket lock timeout notifications' => 'Benachrichtigung bei Ablauf einer Ticket-Sperre',
        'Ticket move notification' => 'Benachrichtigung beim Verschieben von Tickets',
        'Send me a notification if a ticket is moved into one of "My Queues".' =>
            'Zusenden einer Mitteilung beim Verschieben eines Tickets in "Meine Queues".',
        'Send ticket move notifications' => 'Benachrichtigung beim Verschieben eines Tickets',
        'Your queue selection of your favourite queues. You also get notified about those queues via email if enabled.' =>
            'Die Auswahl ihrer favorisierten Queues. Sie werden auch per E-Mail über diese Queues benachrichtigt, wenn die Einstellung aktiv ist.',
        'Custom Queue' => 'Bevorzugte Queue',
        'QueueView refresh time' => 'Queue-Ansicht Aktualisierungszeit',
        'If enabled, the QueueView will automatically refresh after the specified time.' =>
            'Automatische Aktualisierung der Queue-Ansicht nach der angegebenen Zeit',
        'Refresh QueueView after' => 'Aktualisierung der Queue-Ansicht nach',
        'Screen after new ticket' => 'Ansicht nach Ticket-Erstellung',
        'Show this screen after I created a new ticket' => 'Diese Ansicht nach dem Erstellen eines Tickets anzeigen',
        'Closed Tickets' => 'Geschlossene Tickets',
        'Show closed tickets.' => 'Geschlossene Tickets anzeigen.',
        'Max. shown Tickets a page in QueueView.' => 'Maximale Anzahl angezeigter Tickets pro Seite in der Queue-Ansicht.',
        'Ticket Overview "Small" Limit' => 'Begrenzung für Ticketübersicht "Klein"',
        'Ticket limit per page for Ticket Overview "Small"' => 'Maximale Anzahl Tickets pro Seite für Ticketübersicht "Klein"',
        'Ticket Overview "Medium" Limit' => 'Begrenzung für Ticketübersicht "Mittel"',
        'Ticket limit per page for Ticket Overview "Medium"' => 'Maximale Anzahl Tickets pro Seite für Ticketübersicht "Mittel"',
        'Ticket Overview "Preview" Limit' => 'Begrenzung für Ticketübersicht "Vorschau"',
        'Ticket limit per page for Ticket Overview "Preview"' => 'Maximale Anzahl Tickets pro Seite für Ticketübersicht "Vorschau"',
        'Ticket watch notification' => 'Benachrichtigung über Ticket-Überwachungen',
        'Send me the same notifications for my watched tickets that the ticket owners will get.' =>
            'Für meine überwachten Tickets die gleiche Nachricht, die die Besitzer eines Tickets erhalten, an mich senden.',
        'Send ticket watch notifications' => 'Benachrichtigung über Ticket-Überwachungen senden',
        'Out Of Office Time' => 'Abwesenheitszeit',
        'New Ticket' => 'Neues Ticket',
        'Create new Ticket' => 'Neues Ticket erstellen',
        'Customer called' => 'Kunden angerufen',
        'phone call' => 'Telefonanruf',
        'Phone Call Outbound' => 'Ausgehender Telefonanruf',
        'Phone Call Inbound' => 'Eingehender Telefonanruf',
        'Reminder Reached' => 'Erinnerung erreicht',
        'Reminder Tickets' => 'Erinnerungs-Tickets',
        'Escalated Tickets' => 'Eskalierte Tickets',
        'New Tickets' => 'Neue Tickets',
        'Open Tickets / Need to be answered' => 'Offene Tickets / Beantwortung erforderlich',
        'All open tickets, these tickets have already been worked on, but need a response' =>
            'Alle offenen Tickets, an diesen Tickets wurde bereits gearbeitet, aber eine Antwort ist erforderlich',
        'All new tickets, these tickets have not been worked on yet' => 'Alle neuen Tickets, an diesen Tickets wurde noch nicht gearbeitet',
        'All escalated tickets' => 'Alle eskalierten Tickets',
        'All tickets with a reminder set where the reminder date has been reached' =>
            'Alle Tickets, deren Erinnerungszeit erreicht ist',
        'Archived tickets' => 'Archivierte Tickets',
        'Unarchived tickets' => 'Nicht archivierte Tickets',
        'History::Move' => 'Ticket verschoben in Queue "%s" (%s) von Queue "%s" (%s).',
        'History::TypeUpdate' => 'Typ aktualisiert "%s" (ID=%s).',
        'History::ServiceUpdate' => 'Service aktualisiert "%s" (ID=%s).',
        'History::SLAUpdate' => 'SLA aktualisiert "%s" (ID=%s).',
        'History::NewTicket' => 'Neues Ticket [%s] erstellt (Q=%s;P=%s;S=%s).',
        'History::FollowUp' => 'FollowUp für [%s]. %s',
        'History::SendAutoReject' => 'AutoReject an "%s" versandt.',
        'History::SendAutoReply' => 'AutoReply an "%s" versandt.',
        'History::SendAutoFollowUp' => 'AutoFollowUp an "%s" versandt.',
        'History::Forward' => 'Weitergeleitet an "%s".',
        'History::Bounce' => 'Bounced an "%s".',
        'History::SendAnswer' => 'E-Mail versandt an "%s".',
        'History::SendAgentNotification' => '"%s"-Benachrichtigung versandt an "%s".',
        'History::SendCustomerNotification' => 'Benachrichtigung versandt an "%s".',
        'History::EmailAgent' => 'E-Mail an Kunden versandt.',
        'History::EmailCustomer' => 'E-Mail hinzugefügt. %s',
        'History::PhoneCallAgent' => 'Kunden angerufen.',
        'History::PhoneCallCustomer' => 'Kunde hat angerufen.',
        'History::AddNote' => 'Notiz hinzugefügt (%s)',
        'History::Lock' => 'Ticket gesperrt.',
        'History::Unlock' => 'Ticketsperre aufgehoben.',
        'History::TimeAccounting' => '%s Zeiteinheit(en) gezählt. Insgesamt %s Zeiteinheit(en).',
        'History::Remove' => '%s',
        'History::CustomerUpdate' => 'Aktualisiert: %s',
        'History::PriorityUpdate' => 'Priorität aktualisiert von "%s" (%s) nach "%s" (%s).',
        'History::OwnerUpdate' => 'Neuer Besitzer ist "%s" (ID=%s).',
        'History::LoopProtection' => 'Loop-Protection! Keine Auto-Antwort versandt an "%s".',
        'History::Misc' => '%s',
        'History::SetPendingTime' => 'Aktualisiert: %s',
        'History::StateUpdate' => 'Alt: "%s" Neu: "%s"',
        'History::TicketDynamicFieldUpdate' => 'Aktualisiert: %s=%s;%s=%s;',
        'History::WebRequestCustomer' => 'Kunde stellte Anfrage über Web.',
        'History::TicketLinkAdd' => 'Verknüpfung zu "%s" hergestellt.',
        'History::TicketLinkDelete' => 'Verknüpfung zu "%s" gelöscht.',
        'History::Subscribe' => 'Abo für Benutzer "%s" eingetragen.',
        'History::Unsubscribe' => 'Abo für Benutzer "%s" ausgetragen.',
        'History::SystemRequest' => 'Systemanfrage (%s).',
        'History::ResponsibleUpdate' => 'Neuer Verantwortlicher ist "%s" (ID=%s).',
        'History::ArchiveFlagUpdate' => 'Archivstatus geändert: "%s"',

        # Template: AAAWeekDay
        'Sun' => 'So',
        'Mon' => 'Mo',
        'Tue' => 'Di',
        'Wed' => 'Mi',
        'Thu' => 'Do',
        'Fri' => 'Fr',
        'Sat' => 'Sa',

        # Template: AdminAttachment
        'Attachment Management' => 'Anlagenverwaltung',
        'Actions' => 'Aktionen',
        'Go to overview' => 'Zurück zur Übersicht',
        'Add attachment' => 'Anlage hinzufügen',
        'List' => 'Liste',
        'Validity' => 'Gültigkeit',
        'No data found.' => 'Keine Daten gefunden.',
        'Download file' => 'Datei herunterladen',
        'Delete this attachment' => 'Diesen Anhang entfernen',
        'Add Attachment' => 'Anhang hinzufügen',
        'Edit Attachment' => 'Anhang bearbeiten',
        'This field is required.' => 'Dieses Feld wird benötigt.',
        'or' => 'oder',

        # Template: AdminAutoResponse
        'Auto Response Management' => 'Verwaltung automatischer Antworten',
        'Add auto response' => 'Automatische Antwort hinzufügen',
        'Add Auto Response' => 'Automatische Antwort hinzufügen',
        'Edit Auto Response' => 'Automatische Antwort bearbeiten',
        'Response' => 'Antwort',
        'Auto response from' => 'Automatische Antwort von',
        'Reference' => 'Referenz(en)',
        'You can use the following tags' => 'Die folgenden Tags können benutzt werden',
        'To get the first 20 character of the subject.' => 'Die ersten 20 Zeichen des Betreffs',
        'To get the first 5 lines of the email.' => 'Die ersten fünf Zeilen der Nachricht',
        'To get the realname of the sender (if given).' => 'Der Name des Benutzers (wenn angegeben)',
        'To get the article attribute' => 'Die Artikel-Attribute',
        ' e. g.' => 'z. B.',
        'Options of the current customer user data' => 'Attribute des aktuellen Kunden',
        'Ticket owner options' => 'Attribute des Ticketbesitzers',
        'Ticket responsible options' => 'Attribute des Ticket-Verantwortlichen',
        'Options of the current user who requested this action' => 'Attribute des aktuellen Benutzers, der die Aktion angefordert hat',
        'Options of the ticket data' => 'Attribute der Ticketdaten',
        'Options of ticket dynamic fields internal key values' => 'Interne Werte der DynamicFields von Tickets',
        'Options of ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            'Angezeigte Werte der DynamicFields von Tickets, nutzbar mit Dropdown und Multiselect',
        'Config options' => 'Konfigurationseinstellungen',
        'Example response' => 'Beispielantwort',

        # Template: AdminCustomerCompany
        'Customer Company Management' => 'Kunden-Firma-Verwaltung',
        'Wildcards like \'*\' are allowed.' => 'Platzhalter wie \'*\' sind erlaubt.',
        'Add customer company' => 'Firma hinzufügen',
        'Please enter a search term to look for customer companies.' => 'Bitte geben Sie einen Suchbegriff ein, um nach einer Firma zu suchen.',
        'Add Customer Company' => 'Firma hinzufügen',

        # Template: AdminCustomerUser
        'Customer Management' => 'Kunden-Verwaltung',
        'Back to search results' => 'Zurück zum Suchergebnis',
        'Add customer' => 'Kunden hinzufügen',
        'Select' => 'Auswahl',
        'Hint' => 'Hinweis',
        'Customer will be needed to have a customer history and to login via customer panel.' =>
            'Kunden werden für die Bereitstellung einer Kunden-Historie und für die Anmeldung über den Kunden-Zugang benötigt.',
        'Please enter a search term to look for customers.' => 'Bitte geben Sie einen Suchbegriff ein, um nach Kunden zu suchen.',
        'Last Login' => 'Letzte Anmeldung',
        'Login as' => 'Anmelden als',
        'Switch to customer' => 'Zum Kunden wechseln',
        'Add Customer' => 'Kunden hinzufügen',
        'Edit Customer' => 'Kunden bearbeiten',
        'This field is required and needs to be a valid email address.' =>
            'Dieses Feld wird benötigt und muss eine gültige E-Mail-Adresse sein.',
        'This email address is not allowed due to the system configuration.' =>
            'Diese E-Mail-Adresse wird von der aktuellen Systemkonfiguration nicht zugelassen.',
        'This email address failed MX check.' => 'Für diese E-Mail-Adresse ist die MX-Prüfung fehlgeschlagen.',
        'DNS problem, please check your configuration and the error log.' =>
            'DNS-Problem, bitte prüfen Sie ihre Konfiguration und das Fehlerprotokoll.',
        'The syntax of this email address is incorrect.' => 'Die Syntax dieser E-Mail-Adresse ist fehlerhaft.',

        # Template: AdminCustomerUserGroup
        'Manage Customer-Group Relations' => 'Kunden-Gruppen-Zuordnung verwalten',
        'Notice' => 'Bemerkung',
        'This feature is disabled!' => 'Dieses Feature ist inaktiv!',
        'Just use this feature if you want to define group permissions for customers.' =>
            'Benutzen Sie diese Programmfunktion, wenn Sie Gruppen-Erlaubnisse für Kunden definieren möchten.',
        'Enable it here!' => 'Hier aktivieren!',
        'Search for customers.' => 'Kundensuche.',
        'Edit Customer Default Groups' => 'Standardgruppen für Kunden bearbeiten',
        'These groups are automatically assigned to all customers.' => 'Diese Gruppen werden allen Kunden automatisch zugewiesen.',
        'You can manage these groups via the configuration setting "CustomerGroupAlwaysGroups".' =>
            'Sie können diese Gruppen mit der Konfigurationseinstellung "CustomerGroupAlwaysGroups" bearbeiten.',
        'Filter for Groups' => 'Filter für Gruppen',
        'Select the customer:group permissions.' => 'Wählen sie die Kunde:Gruppe-Rechte aus',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer).' =>
            'Wenn nichts ausgewählt ist, hat der Kunde in dieser Gruppe keine Rechte (und kann nicht auf Tickets zugreifen).',
        'Search Results' => 'Suchergebnisse',
        'Customers' => 'Kunden',
        'Groups' => 'Gruppen',
        'No matches found.' => 'Keine Treffer gefunden.',
        'Change Group Relations for Customer' => 'Gruppenzuordnungen verwalten für Kunde',
        'Change Customer Relations for Group' => 'Kundenzuordnungen verwalten für Gruppe',
        'Toggle %s Permission for all' => 'Recht %s für alle umschalten',
        'Toggle %s permission for %s' => 'Recht %s für %s umschalten',
        'Customer Default Groups:' => 'Standardgruppen:',
        'No changes can be made to these groups.' => 'An diesen Gruppen können keine Änderungen vorgenommen werden.',
        'ro' => 'ro',
        'Read only access to the ticket in this group/queue.' => 'Nur-Lesen-Zugriff auf Tickets in diesen Gruppen/Queues.',
        'rw' => 'rw',
        'Full read and write access to the tickets in this group/queue.' =>
            'Voller Schreib- und Lesezugriff auf Tickets in der Queue/Gruppe.',

        # Template: AdminCustomerUserService
        'Manage Customer-Services Relations' => 'Kunden-Service-Zuordnungen verwalten',
        'Edit default services' => 'Standardservices bearbeiten',
        'Filter for Services' => 'Filter für Services',
        'Allocate Services to Customer' => 'Services zuordnen an Kunden',
        'Allocate Customers to Service' => 'Kunden zuordnen an Service',
        'Toggle active state for all' => 'Aktiv-Status für alle umschalten',
        'Active' => 'Aktiv',
        'Toggle active state for %s' => 'Aktiv-Status für %s umschalten',

        # Template: AdminDynamicField
        'Dynamic Fields Management' => 'Verwaltung dynamischer Felder',
        'Add new field for object' => 'Neues Feld hinzufügen für Objekt',
        'To add a new field, select the field type form one of the object\'s list, the object defines the boundary of the field and it can\'t be changed after the field creation.' =>
            'Zum Anlegen eines neuen Feldes, wählen Sie den Feldtyp aus der Objekliste aus. Das Objekt definiert die Zugehörigkeit des Feldes und kann nach Erstellung nicht mehr geändert werden.',
        'Dynamic Fields List' => 'Liste der dynamischen Felder',
        'Dynamic fields per page' => 'Dynamische Felder pro Seite',
        'Label' => 'Beschriftung',
        'Order' => 'Sortierung',
        'Object' => 'Objekt',
        'Delete this field' => 'Dieses Feld löschen',
        'Do you really want to delete this dynamic field? ALL associated data will be LOST!' =>
            'Wollen Sie dieses dynamische Feld wirklich löschen? Alle darin enthaltenen Daten werden GELÖSCHT!',
        'Delete field' => 'Feld löschen',

        # Template: AdminDynamicFieldCheckbox
        'Dynamic Fields' => 'Dynamische Felder',
        'Field' => 'Feld',
        'Go back to overview' => 'Zurück zur Übersicht',
        'General' => 'Allgemein',
        'This field is required, and the value should be alphabetic and numeric characters only.' =>
            'Diese Feld wird benötigt, und der Wert darf nur Buchstaben und Zahlen enthalten.',
        'Must be unique and only accept alphabetic and numeric characters.' =>
            'Muss eindeutig sein und darf nur aus Buchstaben und Zahlen bestehen.',
        'Changing this value will require manual changes in the system.' =>
            'Eine Änderung dieses Wertes macht weitere manuelle Änderungen am System erforderlich.',
        'This is the name to be shown on the screens where the field is active.' =>
            'Dieser Name wird auf den Bildschirmen angezeigt, auf denen dieses Feld aktiv ist.',
        'Field order' => 'Feldreihenfolge',
        'This field is required and must be numeric.' => 'Dieses Feld wird benötigt und darf nur Zahlen enthalten.',
        'This is the order in which this field will be shown on the screens where is active.' =>
            'Die Feldreihenfolge steuert die Ausgabe der Felder auf den Bildschirmen.',
        'Field type' => 'Feldtyp',
        'Object type' => 'Objekttyp',
        'Internal field' => 'Internes Feld',
        'This field is protected and can\'t be deleted.' => 'Dies ist ein geschütztes internes Feld und kann nicht gelöscht werden.',
        'Field Settings' => 'Feldeinstellungen',
        'Default value' => 'Standardwert',
        'This is the default value for this field.' => 'Dies ist der Standardwert für dieses Feld',
        'Save' => 'Speichern',

        # Template: AdminDynamicFieldDateTime
        'Default date difference' => 'Standard-Datumsunterschied',
        'This field must be numeric.' => 'Dieses Feld darf nur Zahlen beinhalten.',
        'The difference from NOW (in seconds) to calculate the field default value (e.g. 3600 or -60).' =>
            'Der Unterschied zu JETZT in Sekunden, mit dem der Standardwert des Feldes berechnet wird (z. B. 3600 oder -60).',
        'Define years period' => 'Jahresbereich angeben',
        'Activate this feature to define a fixed range of years (in the future and in the past) to be displayed on the year part of the field.' =>
            'Aktivieren Sie diese Funktion, um für die Datumsauswahl einen festen Jahresbereich anzugeben (Jahre in der Vergangenheit und Zukunft).',
        'Years in the past' => 'Jahre in der Vergangenheit',
        'Years in the past to display (default: 5 years).' => 'Jahre in der Vergangenheit, die angezeigt werden (Standard: 5).',
        'Years in the future' => 'Jahre in der Zukunft',
        'Years in the future to display (default: 5 years).' => 'Jahre in der Zukunft, die angezeigt werden (Standard: 5).',
        'Show link' => 'Link anzeigen',
        'Here you can specify an optional HTTP link for the field value in Overviews and Zoom screens.' =>
            'Hier können Sie einen optionalen link für die Felddarstellung in Übersichten und Ansichtsseiten angeben.',

        # Template: AdminDynamicFieldDropdown
        'Possible values' => 'Mögliche Werte',
        'Key' => 'Schlüssel',
        'Value' => 'Wert',
        'Remove value' => 'Wert löschen',
        'Add value' => 'Wert hinzufügen',
        'Add Value' => 'Wert hinzufügen',
        'Add empty value' => 'Leeren Wert hinzufügen',
        'Activate this option to create an empty selectable value.' => 'Aktivieren Sie diese Einstellung, um einen leeren Auswahlwert zu erzeugen.',
        'Translatable values' => 'Wertübersetzung',
        'If you activate this option the values will be translated to the user defined language.' =>
            'Wenn Sie diese Einstellung aktivieren, werden die Werte in die Sprache des Benutzers übersetzt.',
        'Note' => 'Notiz',
        'You need to add the translations manually into the language translation files.' =>
            'Sie müssen die Übersetzungen manuell zu den Übersetzungsdateien hinzufügen.',

        # Template: AdminDynamicFieldMultiselect

        # Template: AdminDynamicFieldText
        'Number of rows' => 'Anzahl der Zeilen',
        'Specify the height (in lines) for this field in the edit mode.' =>
            'Gibt die Anzahl der Zeilen für diese Feld im Bearbeitungsmodus an.',
        'Number of cols' => 'Anzahl der Spalten',
        'Specify the width (in characters) for this field in the edit mode.' =>
            'Gibt die Breite in Zeichen für dieses Feld im Bearbeitungsmodus an.',

        # Template: AdminEmail
        'Admin Notification' => 'Admin-Benachrichtigung',
        'With this module, administrators can send messages to agents, group or role members.' =>
            'Mit diesem Modul können Administratoren Nachrichten an Agenten, Gruppen oder Rolleninhaber senden.',
        'Create Administrative Message' => 'Administratorennachricht erzeugen',
        'Your message was sent to' => 'Ihre Nachricht wurde gesendet an',
        'Send message to users' => 'Nachricht an Benutzer senden',
        'Send message to group members' => 'Nachricht an Gruppenmitglieder senden',
        'Group members need to have permission' => 'Gruppenmitglieder brauchen eine Erlaubnis',
        'Send message to role members' => 'Nachricht an Inhaber von Rollen senden',
        'Also send to customers in groups' => 'Auch an Kunden der Gruppe senden',
        'Body' => 'Text',
        'Send' => 'Senden',

        # Template: AdminGenericAgent
        'Generic Agent' => 'GenericAgent',
        'Add job' => 'Job hinzufügen',
        'Last run' => 'Letzte Ausführung',
        'Run Now!' => 'Jetzt ausführen!',
        'Delete this task' => 'Diesen Job löschen',
        'Run this task' => 'Diesen Job ausführen',
        'Job Settings' => 'Jobeinstellungen',
        'Job name' => 'Jobname',
        'Currently this generic agent job will not run automatically.' =>
            'Derzeit würde dieser GenericAgentJob nicht automatisch ausgeführt werden.',
        'To enable automatic execution select at least one value from minutes, hours and days!' =>
            'Um ihn automatisch auszuführen muß mindestens ein Wert von Minuten, Stunden und Tagen ausgewählt werden!',
        'Schedule minutes' => 'Ausführen zu Minute(n)',
        'Schedule hours' => 'Ausführen zu Stunde(n)',
        'Schedule days' => 'Ausführen an Tag(en)',
        'Toggle this widget' => 'Dieses Widget umschalten',
        'Ticket Filter' => 'Ticketfilter',
        '(e. g. 10*5155 or 105658*)' => 'z .B. 10*5144 oder 105658*',
        '(e. g. 234321)' => 'z. B. 234321',
        'Customer login' => 'Kundenlogin',
        '(e. g. U5150)' => 'z. B. U5150',
        'Fulltext-search in article (e. g. "Mar*in" or "Baue*").' => 'Volltextsuche in Artikeln (z. B. "Mar*in" oder "Baue*").',
        'Agent' => 'Agent',
        'Ticket lock' => 'Ticketsperre',
        'Create times' => 'Erstellzeiten',
        'No create time settings.' => 'Keine Erstell-Zeiten',
        'Ticket created' => 'Ticket erstellt',
        'Ticket created between' => 'Ticket erstellt zwischen',
        'Change times' => 'Änderungs-Zeiten',
        'No change time settings.' => 'Keine Änderungs-Zeiten',
        'Ticket changed' => 'Ticket geändert',
        'Ticket changed between' => 'Ticket geändert zwischen',
        'Close times' => 'Schließ-Zeiten',
        'No close time settings.' => 'keine Schließ-Zeiten',
        'Ticket closed' => 'Ticket geschlossen',
        'Ticket closed between' => 'Ticket geschlossen zwischen',
        'Pending times' => 'Erinnerungszeiten',
        'No pending time settings.' => 'Keine Warten-Zeiten',
        'Ticket pending time reached' => 'Ticket Warten-Zeit erreicht',
        'Ticket pending time reached between' => 'Ticket Warten-Zeit erreicht zwischen',
        'Escalation times' => 'Eskalationszeiten',
        'No escalation time settings.' => 'Keine Eskalations-Zeiten',
        'Ticket escalation time reached' => 'Ticket Eskalations-Zeit erreicht',
        'Ticket escalation time reached between' => 'Ticket Eskalations-Zeit erreicht zwischen',
        'Escalation - first response time' => 'Eskalation - Zeit für erste Reaktion',
        'Ticket first response time reached' => 'Ticket-Reaktionszeit erreicht',
        'Ticket first response time reached between' => 'Ticket-Reaktionszeit erreicht zwischen',
        'Escalation - update time' => 'Eskalation - Aktualisierungszeit',
        'Ticket update time reached' => 'Ticket-Aktualisierungszeit erreicht',
        'Ticket update time reached between' => 'Ticket-Aktualisierungszeit erreicht zwischen',
        'Escalation - solution time' => 'Eskalation - Lösungszeit',
        'Ticket solution time reached' => 'Ticket-Lösungszeit erreicht',
        'Ticket solution time reached between' => 'Ticket-Lösungszeit erreicht zwischen',
        'Archive search option' => 'Im Archiv suchen',
        'Ticket Action' => 'Ticket-Aktion',
        'Set new service' => 'Neuen Service setzen',
        'Set new Service Level Agreement' => 'Neues Service-Level-Abkommen setzen',
        'Set new priority' => 'Neue Priorität setzen',
        'Set new queue' => 'Neue Queue setzen',
        'Set new state' => 'Neuen Status setzen',
        'Set new agent' => 'Neuen Agenten setzen',
        'new owner' => 'Neuer Besitzer',
        'new responsible' => 'Neuer Verantwortlicher',
        'Set new ticket lock' => 'Neue Ticketsperre setzen',
        'New customer' => 'Neuer Kunde',
        'New customer ID' => 'Neue Kundennummer',
        'New title' => 'Neuer Titel',
        'New type' => 'Neuer Typ',
        'New Dynamic Field Values' => 'Neue Werte für dynamische Felder',
        'Archive selected tickets' => 'Ausgewählte Tickets archivieren',
        'Add Note' => 'Notiz hinzufügen',
        'Time units' => 'Zeiteinheiten',
        '(work units)' => '(Arbeitseinheiten)',
        'Ticket Commands' => 'Ticket-Kommandos',
        'Send agent/customer notifications on changes' => 'Sende eine Agent/Kunden Benachrichtigung bei Änderungen',
        'CMD' => 'CMD',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' =>
            'Dieses Kommando wird mit ARG[0] (die Ticket Nummer) und ARG[1] die TicketID ausgeführt.',
        'Delete tickets' => 'Tickets Löschen',
        'Warning: All affected tickets will be removed from the database and cannot be restored!' =>
            'Warnung: Alle betroffenen Tickets werden aus der Datenbank gelöscht und können nicht wiederhergestellt werden.',
        'Execute Custom Module' => 'Benutzerdefiniertes Modul ausführen',
        'Param %s key' => 'Schlüssel Parameter %s',
        'Param %s value' => 'Wert Parameter %s',
        'Save Changes' => 'Änderungen speichern',
        'Results' => 'Ergebnis',
        '%s Tickets affected! What do you want to do?' => '%s Tickets sind betroffen! Was wollen Sie tun?',
        'Warning: You used the DELETE option. All deleted tickets will be lost!' =>
            'Warnung: Sie verwenden die Option LÖSCHEN. Alle gelöschten Tickets gehen verloren!',
        'Edit job' => 'Job bearbeiten',
        'Run job' => 'Job ausführen',
        'Affected Tickets' => 'Betroffene Tickets',

        # Template: AdminGenericInterfaceDebugger
        'GenericInterface Debugger for Web Service %s' => 'GenericInterface Debugger für Webservice',
        'Web Services' => 'Webservices',
        'Debugger' => 'Debugger',
        'Go back to web service' => 'Zurück zum Webservice',
        'Clear' => 'Leeren',
        'Do you really want to clear the debug log of this web service?' =>
            'Möchten Sie wirklich das Debug-Log dieses Webservice leeren?',
        'Request List' => 'Anfrage-Liste',
        'Time' => 'Zeit',
        'Remote IP' => 'Entfernte IP',
        'Loading' => 'Lade...',
        'Select a single request to see its details.' => 'Wählen Sie eine Anfrage aus, um die Details zu sehen.',
        'Filter by type' => 'Filtern nach Typ',
        'Filter from' => 'Filter von',
        'Filter to' => 'Filter bis',
        'Filter by remote IP' => 'Filter nach entfernter IP',
        'Refresh' => 'Aktualisieren',
        'Request Details' => 'Anfragedetails',
        'An error occurred during communication.' => 'Während der Kommunikation ist ein Fehler aufgetreten',
        'Show or hide the content' => 'Inhalt anzeigen oder ausblenden',
        'Clear debug log' => 'Debug-Log leeren',

        # Template: AdminGenericInterfaceInvokerDefault
        'Add new Invoker to Web Service %s' => 'Neuen Invoker zum Webservice %s hinzufügen',
        'Change Invoker %s of Web Service %s' => 'Invoker %s von Webservice %s ändern',
        'Add new invoker' => 'Neuen Invoker hinzufügen',
        'Change invoker %s' => 'Invoker %s ändern',
        'Do you really want to delete this invoker?' => 'Wollen Sie diesen Invoker wirklich löschen?',
        'All configuration data will be lost.' => 'Die Konfigurationsdaten gehen verloren.',
        'Invoker Details' => 'Invoker-Details',
        'The name is typically used to call up an operation of a remote web service.' =>
            'Der Name wird typischerweise genutzt, um eine Operation eines entfernten Webservice aufzurufen.',
        'Please provide a unique name for this web service invoker.' => 'Bitte geben sie einen eindeutigen Namen für diesen Webservice-Invoker an.',
        'The name you entered already exists.' => 'Der eingegebene Name existiert bereits',
        'Invoker backend' => 'Invoker-Backend',
        'This OTRS invoker backend module will be called to prepare the data to be sent to the remote system, and to process its response data.' =>
            'Dieses Invoker-Backend-Modul wird aufgerufen, um die Daten zum Versand an das entfernte System sowie die zurückgelieferten Daten aufzubereiten.',
        'Mapping for outgoing request data' => 'Mapping für ausgehende Anfragedaten',
        'Configure' => 'Konfigurieren',
        'The data from the invoker of OTRS will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            'Die Daten des Invokers von OTRS werden von diesem Mapping verarbeitet, um sie so umzuformen, wie das entfernte System die Daten benötigt.',
        'Mapping for incoming response data' => 'Mapping für eingehende Antwortdaten',
        'The response data will be processed by this mapping, to transform it to the kind of data the invoker of OTRS expects.' =>
            'Die Antwort-Daten des entfernten Systems werden von diesem Mapping verarbeitet, um sie so umzuformen, wie der Invoker von OTRS sie benötigt.',
        'Event Triggers' => 'Event-Trigger',
        'Asynchronous' => 'Asynchron',
        'Delete this event' => 'Diesen Event löschen',
        'This invoker will be triggered by the configured events.' => 'Dieser Invoker wird von den konfigurierten Events ausgelöst.',
        'Do you really want to delete this event trigger?' => 'Wollen Sie diesen Event-Trigger wirklich löschen?',
        'Add Event Trigger' => 'Event-Trigger hinzufügen',
        'To add a new event select the event object and event name and click on the "+" button' =>
            'Um einen neuen Event hinzuzufügen, wählen Sie bitte das Objekt und den Eventnamen und klicken Sie auf den "+"-Knopf',
        'Asynchronous event triggers are handled by the OTRS Scheduler in background (recommended).' =>
            'Asynchrone Event-Trigger werden vom OTRS-Scheduler im Hintergrund verarbeitet (empfohlen).',
        'Synchronous event triggers would be processed directly during the web request.' =>
            'Synchrone Event-Trigger werden direkt während des laufenden Web-Requests verarbeitet.',
        'Save and continue' => 'Speichern und weiter',
        'Save and finish' => 'Speichern und abschließen',
        'Delete this Invoker' => 'Diesen Invoker löschen',
        'Delete this Event Trigger' => 'Diesen Event-Trigger löschen',

        # Template: AdminGenericInterfaceMappingSimple
        'GenericInterface Mapping Simple for Web Service %s' => 'GenericInterface Simple mapping für Webservice %s',
        'Go back to' => 'Zurück zu',
        'Mapping Simple' => 'Simple mapping',
        'Default rule for unmapped keys' => 'Standardregel für nicht gemappte Schlüssel',
        'This rule will apply for all keys with no mapping rule.' => 'Diese Regel wird für alle Schlüssel ohne passende Regel angewendet.',
        'Default rule for unmapped values' => 'Standardregel für nicht gemappte Werte',
        'This rule will apply for all values with no mapping rule.' => 'Diese Regel wird für alle Werte ohne passende Regel angewendet.',
        'New key map' => 'Neues Schlüssel-Mapping',
        'Add key mapping' => 'Schlüssel-Mapping hinzufügen',
        'Mapping for Key ' => 'Mapping für Schlüssel',
        'Remove key mapping' => 'Schlüssel-Mapping entfernen',
        'Key mapping' => 'Schlüssel-Mapping',
        'Map key' => 'Schlüssel',
        'matching the' => 'übereinstimmend mit',
        'to new key' => 'auf neuen Schlüssel mappen',
        'Value mapping' => 'Wert-Mapping',
        'Map value' => 'Wert',
        'to new value' => 'auf neuen Wert mappen',
        'Remove value mapping' => 'Wert-Mapping entfernen',
        'New value map' => 'Neues Wert-Mapping',
        'Add value mapping' => 'Wert-Mapping hinzufügen',
        'Do you really want to delete this key mapping?' => 'Wollen Sie dieses Schlüssel-Mapping wirklich löschen?',
        'Delete this Key Mapping' => 'Schlüssel-Mapping löschen',

        # Template: AdminGenericInterfaceOperationDefault
        'Add new Operation to Web Service %s' => 'Neue Operation zu Webservice %s hinzufügen',
        'Change Operation %s of Web Service %s' => 'Operation %s von Webservice %s ändern',
        'Add new operation' => 'Neue Operation hinzufügen',
        'Change operation %s' => 'Operation %s ändern',
        'Do you really want to delete this operation?' => 'Wollen Sie diese Operation wirklich löschen?',
        'Operation Details' => 'Operation-Details',
        'The name is typically used to call up this web service operation from a remote system.' =>
            'Der Name wird typischerweise benutzt, um die Webservice-Operation von einem entfernten System aus aufzurufen.',
        'Please provide a unique name for this web service.' => 'Bitte geben Sie einen eindeutigen Namen für diesen Webservice an.',
        'Mapping for incoming request data' => 'Mapping für eingehende Anfragedaten',
        'The request data will be processed by this mapping, to transform it to the kind of data OTRS expects.' =>
            'Die Daten der eingehenden Anfrage werden von diesem Mapping verarbeitet, um sie so umzuformen, wie die OTRS-Operation sie benötigt.',
        'Operation backend' => 'Operation-Backend',
        'This OTRS operation backend module will be called internally to process the request, generating data for the response.' =>
            'Das Operation-Backend-Modul wird intern aufgerufen um die Anfrage zu verarbeiten, und erzeugt dabei Antwortdaten.',
        'Mapping for outgoing response data' => 'Mapping für ausgehende Antwortdaten',
        'The response data will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            'Die Antwortdaten werden von diesem Mapping verarbeitet, um sie so umzuformen, wie das entfernte System die Daten benötigt.',
        'Delete this Operation' => 'Diese Operation löschen',

        # Template: AdminGenericInterfaceTransportHTTPSOAP
        'GenericInterface Transport HTTP::SOAP for Web Service %s' => 'GenericInterface Transport HTTP::SOAP für Webservice %s',
        'Network transport' => 'Netzwerk-Transport',
        'Properties' => 'Eigenschaften',
        'Endpoint' => 'Endpunkt',
        'URI to indicate a specific location for accessing a service.' =>
            'URI für den Zugriff auf einen Webservice.',
        'e.g. http://local.otrs.com:8000/Webservice/Example' => 'z. B. http://local.otrs.com:8000/Webservice/Example',
        'Namespace' => 'Namespace',
        'URI to give SOAP methods a context, reducing ambiguities.' => 'URI, die SOAP-Methoden einen Kontext gibt und damit Mehrdeutigkeiten auflöst.',
        'e.g urn:otrs-com:soap:functions or http://www.otrs.com/GenericInterface/actions' =>
            'z. B. urn:otrs-com:soap:functions oder http://www.otrs.com/GenericInterface/actions',
        'Maximum message length' => 'Maximale Nachrichtenlänge',
        'This field should be an integer number.' => 'Dieses Feld sollte eine Ganzzahl beinhalten.',
        'Here you can specify the maximum size (in bytes) of SOAP messages that OTRS will process.' =>
            'Hier können Sie eine Maximalgröße für SOAP-Nachrichten (in Bytes) angeben, die OTRS verarbeitet.',
        'Encoding' => 'Kodierung',
        'The character encoding for the SOAP message contents.' => 'Die Zeichenkodierung für SOAP-Nachrichteninhalte',
        'e.g utf-8, latin1, iso-8859-1, cp1250, Etc.' => 'z. B. utf-8, latin1, iso-8859-1, cp1250, usw.',
        'SOAPAction' => 'SOAPAction',
        'Set to "Yes" to send a filled SOAPAction header.' => 'Auf "Ja" stellen, um einen befüllten SOAPAction-Header zu senden.',
        'Set to "No" to send an empty SOAPAction header.' => 'Auf "Nein" stellen, um einen leeren SOAPAction-Header zu senden.',
        'SOAPAction separator' => 'SOAPAction-Trenner',
        'Character to use as separator between name space and SOAP method.' =>
            'Trennzeichen zwischen dem Namespace und der SOAP-Methode',
        'Usually .Net web services uses a "/" as separator.' => 'Normalerweise verwenden .Net-basierte Webservices "/" als Trenner',
        'Authentication' => 'Authentifizierung',
        'The authentication mechanism to access the remote system.' => 'Die Authentifizierungsmethode für den Zugriff auf das entfernte System.',
        'A "-" value means no authentication.' => 'Der Wert "-" bedeutet keine Authentifizierung.',
        'The user name to be used to access the remote system.' => 'Der Benutzername für den Zugriff auf das entfernte System.',
        'The password for the privileged user.' => 'Dass Passwort des berechtigten Benutzers.',
        'Use SSL Options' => 'SSL-Optionen verwenden',
        'Show or hide SSL options to connect to the remote system.' => 'Optionen für die Verwendung von SSL zum Zugriff auf das entfernte System anzeigen oder verbergen.',
        'Certificate File' => 'Zertifikatsdatei',
        'The full path and name of the SSL certificate file (must be in .p12 format).' =>
            'Voller Pfad und Dateiname des SSL-Zertifikats (muss im .p12-Format vorliegen).',
        'e.g. /opt/otrs/var/certificates/SOAP/certificate.p12' => 'z. B. /opt/otrs/var/certificates/SOAP/certificate.p12',
        'Certificate Password File' => 'Passwortdatei für Zertifikat',
        'The password to open the SSL certificate.' => 'Das Passwort für den Zugriff auf das SSL-Zertifikat.',
        'Certification Authority (CA) File' => 'Datei der Certification Authority (CA)',
        'The full path and name of the certification authority certificate file that validates SSL certificate.' =>
            'Voller Pfad und Dateiname der Datei der Certification Authority (CA), welche das Zertifikat signiert hat.',
        'e.g. /opt/otrs/var/certificates/SOAP/CA/ca.pem' => 'z. B. /opt/otrs/var/certificates/SOAP/CA/ca.pem',
        'Certification Authority (CA) Directory' => 'Verzeichnis mit Certification Autorities (CA)',
        'The full path of the certification authority directory where the CA certificates are stored in the file system.' =>
            'Voller Pfad und Dateiname des CA-Verzeichnisses, in dem CA-Zertifikate gespeichert sind.',
        'e.g. /opt/otrs/var/certificates/SOAP/CA' => 'z. B. /opt/otrs/var/certificates/SOAP/CA',
        'Proxy Server' => 'Proxy-Server',
        'URI of a proxy server to be used (if needed).' => 'URI eines Proxy-Servers (optional).',
        'e.g. http://proxy_hostname:8080' => 'z. B. http://proxy_hostname:8080',
        'Proxy User' => 'Proxy-Benutzer',
        'The user name to be used to access the proxy server.' => 'Benutzername für den Zugriff auf den Proxy-Server.',
        'Proxy Password' => 'Proxy-Passwort',
        'The password for the proxy user.' => 'Passwort des Proxy-Benutzers.',

        # Template: AdminGenericInterfaceWebservice
        'GenericInterface Web Service Management' => 'GenericInterface Webservice-Verwaltung',
        'Add web service' => 'Webservice hinzufügen',
        'Clone web service' => 'Webservice klonen',
        'The name must be unique.' => 'Der Name muss eindeutig sein.',
        'Clone' => 'Klonen',
        'Export web service' => 'Webservice exportieren',
        'Import web service' => 'Webservice importieren',
        'Configuration File' => 'Konfigurationsdatei',
        'The file must be a valid web service configuration YAML file.' =>
            'Die Datei muss eine gültige Webservice-Konfigurationsdatei im YAML-Format sein.',
        'Import' => 'Importieren',
        'Configuration history' => 'Konfigurations-Historie',
        'Delete web service' => 'Webservice löschen',
        'Do you really want to delete this web service?' => 'Wollen Sie diesen Webservice wirklich löschen?',
        'After you save the configuration you will be redirected again to the edit screen.' =>
            'Nach dem Speichern der Konfiguration werden Sie wieder auf den Bearbeitungsbildschirm geleitet.',
        'If you want to return to overview please click the "Go to overview" button.' =>
            'Wenn Sie zurück zur Übersicht möchten, verwenden Sie bitte den Knopf "Zurück zur Übersicht"',
        'Web Service List' => 'Webservice-Liste',
        'Remote system' => 'Entferntes System',
        'Provider transport' => 'Provider-Transport',
        'Requester transport' => 'Requester-Transport',
        'Details' => 'Details',
        'Debug threshold' => 'Debug-Level',
        'In provider mode, OTRS offers web services which are used by remote systems.' =>
            'Im Modus "Provider" bietet OTRS Webservices an, die von entfernten Systemen genutzt werden.',
        'In requester mode, OTRS uses web services of remote systems.' =>
            'Im Modus "Requester" nutzt OTRS selbst Webservices von entfernten Systemen.',
        'Operations are individual system functions which remote systems can request.' =>
            'Operations sind einzelne Systemfunktionen, die entfernte Systeme aufrufen können.',
        'Invokers prepare data for a request to a remote web service, and process its response data.' =>
            'Invoker bereiten Daten für eine Anfrage an einen entfernten Webservice auf und verarbeiten die Antwortdaten.',
        'Controller' => 'Controller',
        'Inbound mapping' => 'Eingehendes Mapping',
        'Outbound mapping' => 'Ausgehendes Mapping',
        'Delete this action' => 'Diese Aktion löschen',
        'At least one %s has a controller that is either not active or not present, please check the controller registration or delete the %s' =>
            'Noch mindestens ein %s hat einen Controller der nicht aktiv oder nicht vorhanden ist, bitte prüfen Sie die Controller-Registrierung oder löschen Sie %s',
        'Delete webservice' => 'Webservice löschen',
        'Delete operation' => 'Operation löschen',
        'Delete invoker' => 'Invoker löschen',
        'Clone webservice' => 'Webservice klonen',
        'Import webservice' => 'Webservice importieren',

        # Template: AdminGenericInterfaceWebserviceHistory
        'GenericInterface Configuration History for Web Service %s' => 'GenericInterface Konfigurations-Historie für Webservice %s',
        'Go back to Web Service' => 'Zurück zum Webservice',
        'Here you can view older versions of the current web service\'s configuration, export or even restore them.' =>
            'Hier können Sie ältere Versionen der Konfiguration dieses Webservices einsehen, exportieren oder wiederherstellen.',
        'Configuration History List' => 'Liste der Konfigurations-Historie',
        'Version' => 'Version',
        'Create time' => 'Erstellzeit',
        'Select a single configuration version to see its details.' => 'Wählen Sie eine Konfigurationsversion aus, um die Details zu sehen.',
        'Export web service configuration' => 'Webservice-Konfiguration exportieren',
        'Restore web service configuration' => 'Webservice-Konfiguration wiederherstellen',
        'Do you really want to restore this version of the web service configuration?' =>
            'Wollen Sie diese Version der Webservice-Konfiguration wirklich wiederherstellen?',
        'Your current web service configuration will be overwritten.' => 'Ihre aktuelle Konfiguration wird überschrieben.',
        'Show or hide the content.' => 'Inhalt anzeigen oder verbergen.',
        'Restore' => 'Wiederherstellen',

        # Template: AdminGroup
        'WARNING: When you change the name of the group \'admin\', before making the appropriate changes in the SysConfig, you will be locked out of the administrations panel! If this happens, please rename the group back to admin per SQL statement.' =>
            'VORSICHT: Wenn Sie den Namen der \'admin\'-Gruppe ändern ohne zuvor die entsprechenden Anpassungen in der SysConfig getätigt haben, verlieren Sie den Zugang zum Adminbereich!',
        'Group Management' => 'Gruppen-Verwaltung',
        'Add group' => 'Gruppe hinzufügen',
        'The admin group is to get in the admin area and the stats group to get stats area.' =>
            'Die \'admin\'-Gruppe wird für den Admin-Bereich benötigt, die \'stats\'-Gruppe für den Statistik-Bereich.',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...). ' =>
            'Erstellen Sie neue Gruppen, um unterschiedliche Berechtigungen für verschiedene Agentengruppen zu realisieren (z. B. Einkauf, Produktion, Verkauf, ...).',
        'It\'s useful for ASP solutions. ' => 'Das ist nützlich für ASP-Lösungen.',
        'Add Group' => 'Gruppe hinzufügen',
        'Edit Group' => 'Gruppe bearbeiten',

        # Template: AdminLog
        'System Log' => 'Systemprotokoll',
        'Here you will find log information about your system.' => 'Hier finden Sie Informationen zu protokollierten Systemereignissen.',
        'Hide this message' => 'Diesen Hinweis ausblenden',
        'Recent Log Entries' => 'Aktuelle Einträge im Systemprotokoll',

        # Template: AdminMailAccount
        'Mail Account Management' => 'E-Mail-Kontenverwaltung',
        'Add mail account' => 'E-Mailkonto hinzufügen',
        'All incoming emails with one account will be dispatched in the selected queue!' =>
            'Einkommende E-Mails von POP3-Konten werden in die ausgewählte Queue einsortiert!',
        'If your account is trusted, the already existing X-OTRS header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' =>
            'Wird dem Konto vertraut, werden die X-OTRS Header benutzt! PostMaster Filter werden trotzdem benutzt.',
        'Host' => 'Host',
        'Delete account' => 'E-Mailkonto löschen',
        'Fetch mail' => 'E-Mails abholen',
        'Add Mail Account' => 'E-Mailkonto hinzufügen',
        'Example: mail.example.com' => 'Beispiel: mail.example.com',
        'IMAP Folder' => 'IMAP-Ordner',
        'Only modify this if you need to fetch mail from a different folder than INBOX.' =>
            'Ändern Sie diese Einstellung nur, wenn die Mails aus einem anderen Ordner als "INBOX" geholt werden sollen.',
        'Trusted' => 'Vertraut',
        'Dispatching' => 'Verteilung',
        'Edit Mail Account' => 'E-Mailkonto bearbeiten',

        # Template: AdminNavigationBar
        'Admin' => 'Admin',
        'Agent Management' => 'Agenten-Verwaltung',
        'Queue Settings' => 'Queue-Einstellungen',
        'Ticket Settings' => 'Ticket-Einstellungen',
        'System Administration' => 'Systemverwaltung',

        # Template: AdminNotification
        'Notification Management' => 'Benachrichtigungs-Verwaltung',
        'Select a different language' => 'Wählen Sie eine andere Sprache aus',
        'Filter for Notification' => 'Filter für Benachrichtigungen',
        'Notifications are sent to an agent or a customer.' => 'Benachrichtigungen werden an Agenten und Kunden gesendet.',
        'Notification' => 'Benachrichtigung',
        'Edit Notification' => 'Benachrichtigung bearbeiten',
        'e. g.' => 'z. B.',
        'Options of the current customer data' => 'Attribute des aktuellen Kunden',

        # Template: AdminNotificationEvent
        'Add notification' => 'Benachrichtigung hinzufügen',
        'Delete this notification' => 'Diese Benachrichtigung löschen',
        'Add Notification' => 'Benachrichtigung hinzufügen',
        'Recipient groups' => 'Empfänger-Gruppen',
        'Recipient agents' => 'Empfänger-Agenten',
        'Recipient roles' => 'Empfänger-Rollen',
        'Recipient email addresses' => 'Empfänger-E-Mail-Adressen',
        'Article type' => 'Artikeltyp',
        'Only for ArticleCreate event' => 'Nur für das ArticleCreate-Ereignis',
        'Article sender type' => 'Sender-Typ des Artikels',
        'Subject match' => 'Suchbegriff im Betreff',
        'Body match' => 'Suchbegriff im Text',
        'Include attachments to notification' => 'Anlagen an Benachrichtigung anfügen',
        'Notification article type' => 'Artikeltyp der Benachrichtigung',
        'Only for notifications to specified email addresses' => 'Nur für Benachrichtigungen an die angegebenen E-Mail-Adressen',
        'To get the first 20 character of the subject (of the latest agent article).' =>
            'Die ersten 20 Zeichen des Betreffs (des letzten Agenten-Artikel).',
        'To get the first 5 lines of the body (of the latest agent article).' =>
            'Die ersten fünf Zeilen der Nachricht (des letzten Agenten-Artikel).',
        'To get the first 20 character of the subject (of the latest customer article).' =>
            'Die ersten 20 Zeichen des Betreffs (des letzten Kunden-Artikel)',
        'To get the first 5 lines of the body (of the latest customer article).' =>
            'Die ersten fünf Zeilen der Nachricht (des letzten Kunden-Artikel).',

        # Template: AdminPGP
        'PGP Management' => 'PGP-Verwaltung',
        'Use this feature if you want to work with PGP keys.' => 'Verwenden Sie diese Funktion, wenn Sie mit PGP-Schlüsseln arbeiten möchten.',
        'Add PGP key' => 'PGP-Schlüssel hinzufügen',
        'In this way you can directly edit the keyring configured in SysConfig.' =>
            'Über diesen Weg kann man den Schlüsselring (konfiguriert in SysConfig) direkt bearbeiten.',
        'Introduction to PGP' => 'Einführung zu PGP',
        'Result' => 'Ergebnis',
        'Identifier' => 'Identifikator',
        'Bit' => 'Bit',
        'Fingerprint' => 'Fingerabdruck',
        'Expires' => 'Erlischt',
        'Delete this key' => 'Diesen Schlüssel löschen',
        'Add PGP Key' => 'PGP-Schlüssel hinzufügen',
        'PGP key' => 'PGP-Schlüssel',

        # Template: AdminPackageManager
        'Package Manager' => 'Paket-Verwaltung',
        'Uninstall package' => 'Paket deinstallieren',
        'Do you really want to uninstall this package?' => 'Soll das Paket wirklich deinstalliert werden?',
        'Reinstall package' => 'Paket erneut installieren',
        'Do you really want to reinstall this package? Any manual changes will be lost.' =>
            'Möchten Sie dieses Paket wirklich erneut installieren? Alle manuellen Änderungen gehen verloren.',
        'Continue' => 'Weiter',
        'Install' => 'Installieren',
        'Install Package' => 'Paket installieren',
        'Update repository information' => 'Verzeichnis aktualisieren',
        'Did not find a required feature? OTRS Group provides their service contract customers with exclusive Add-Ons:' =>
            'Der Turbo für Ihr OTRS - Exklusive Feature Add-Ons für Kunden mit Wartungsvertrag:',
        'Online Repository' => 'Online-Verzeichnis',
        'Vendor' => 'Anbieter',
        'Module documentation' => 'Moduldokumentation',
        'Upgrade' => 'Erneuern',
        'Local Repository' => 'Lokales Verzeichnis',
        'Uninstall' => 'Deinstallieren',
        'Reinstall' => 'Erneut installieren',
        'Feature Add-Ons' => 'Feature Add-Ons',
        'Download package' => 'Paket herunterladen',
        'Rebuild package' => 'Paket neu aufbauen (rebuild)',
        'Metadata' => 'Meta-Daten',
        'Change Log' => 'Änderungsprotokoll',
        'Date' => 'Datum',
        'List of Files' => 'Dateiliste',
        'Permission' => 'Rechte',
        'Download' => 'Herunterladen',
        'Download file from package!' => 'Datei aus dem Paket herunterladen!',
        'Required' => 'Benötigt',
        'PrimaryKey' => 'PrimaryKey',
        'AutoIncrement' => 'AutoIncrement',
        'SQL' => 'SQL',
        'File differences for file %s' => 'Dateiunterschiede für Datei %s',

        # Template: AdminPerformanceLog
        'Performance Log' => 'Performance Log',
        'This feature is enabled!' => 'Dieses Feature ist aktiv!',
        'Just use this feature if you want to log each request.' => 'Nur aktivieren wenn jede Anfrage protokolliert werden soll.',
        'Activating this feature might affect your system performance!' =>
            'Wenn dieses Feature aktiv ist, ist mit Leistungsdefizit zu rechnen.',
        'Disable it here!' => 'Hier deaktivieren!',
        'Logfile too large!' => 'Logdatei zu groß!',
        'The logfile is too large, you need to reset it' => 'Die Logdatei ist zu groß, sie muss zurückgesetzt werden',
        'Overview' => 'Übersicht',
        'Range' => 'Bereich',
        'Interface' => 'Interface',
        'Requests' => 'Anfragen',
        'Min Response' => 'Min. Antwortzeit',
        'Max Response' => 'Max. Antwortzeit',
        'Average Response' => 'Durchschnittliche Antwortzeit',
        'Period' => 'Periode',
        'Min' => 'Min',
        'Max' => 'Max',
        'Average' => 'Durchschnitt',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => 'PostMaster Filter-Verwaltung',
        'Add filter' => 'Filter hinzufügen',
        'To dispatch or filter incoming emails based on email headers. Matching using Regular Expressions is also possible.' =>
            'Einkommende Mails anhand von E-Mail-Kopfzeilen verteilen oder filtern. Für die Suche können auch reguläre Ausdrücke benutzt werden.',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' =>
            'Wenn nur eine E-Mail-Adresse gesucht wird, dann benutz EMAILADDRESS:info@example.com in Von, An oder Cc.',
        'If you use Regular Expressions, you also can use the matched value in () as [***] in the \'Set\' action.' =>
            'Wenn Sie reguläre Ausdrücke verwenden, können Sie die gefundenen Werte in () auch als [***] in der Aktion "Setzen" verwenden.',
        'Delete this filter' => 'Diesen Filter löschen',
        'Add PostMaster Filter' => 'PostMaster Filter hinzufügen',
        'Edit PostMaster Filter' => 'PostMaster Filter bearbeiten',
        'Filter name' => 'Filtername',
        'The name is required.' => 'Der Name ist erforderlich.',
        'Stop after match' => 'Stoppen nach Treffer',
        'Filter Condition' => 'Filterbedingung',
        'The field needs to be a valid regular expression or a literal word.' =>
            'Dieses Feld sollte einen gültigen regulären Ausdruck oder ein Wort enthalten.',
        'Set Email Headers' => 'E-Mail-Kopfzeilen setzen',
        'The field needs to be a literal word.' => 'Dieses Feld sollte ein Wort enthalten.',

        # Template: AdminPriority
        'Priority Management' => 'Priorität-Verwaltung',
        'Add priority' => 'Priorität hinzufügen',
        'Add Priority' => 'Priorität hinzufügen',
        'Edit Priority' => 'Priorität bearbeiten',

        # Template: AdminProcessManagement
        'Process Management' => 'Prozess-Management',
        'Filter for Processes' => 'Filter für Prozesse',
        'Filter' => 'Filter',
        'Process Name' => 'Prozessname',
        'Create New Process' => 'Neuen Prozess erstellen',
        'Synchronize All Processes' => 'Alle Prozesse synchronisieren',
        'Configuration import' => 'Konfiguration importieren',
        'Here you can upload a configuration file to import a process to your system. The file needs to be in .yml format as exported by process management module.' =>
            'Hier können Sie eine Konfigurationdatei hochladen, um einen Prozess in Ihr System zu importieren. Die Datei muss im YAML-Format vorliegen, so wie sie vom Prozessmanagement auch exportiert wird.',
        'Upload process configuration' => 'Prozesskonfiguration hochladen',
        'Import process configuration' => 'Prozesskonfiguration importieren',
        'To create a new Process you can either import a Process that was exported from another system or create a complete new one.' =>
            'Um einen neuen Prozess zu erstellen können Sie entweder einen Prozess aus einem anderen System importieren oder einen ganz neuen erstellen.',
        'Changes to the Processes here only affect the behavior of the system, if you synchronize the Process data. By synchronizing the Processes, the newly made changes will be written to the Configuration.' =>
            'Änderungen an den Prozessen wirken sich erst dann aus, wenn Sie die Prozesskonfiguration synchronisieren. Dabei werden alle Änderungen in die Systemkonfiguration übernommen.',
        'Processes' => 'Prozesse',
        'Process name' => 'Prozessname',
        'Copy' => 'Kopieren',
        'Print' => 'Drucken',
        'Export Process Configuration' => 'Prozesskonfiguration exportieren',
        'Copy Process' => 'Prozess kopieren',

        # Template: AdminProcessManagementActivity
        'Cancel & close window' => 'Abbrechen und Fenster schließen',
        'Go Back' => 'Zurück',
        'Please note, that changing this activity will affect the following processes' =>
            'Achtung: Änderungen an dieser Aktivität werden sich auf folgende Prozesse auswirken',
        'Activity' => 'Aktivität',
        'Activity Name' => 'Name der Aktivität',
        'Activity Dialogs' => 'Aktivitäts-Dialoge',
        'You can assign Activity Dialogs to this Activity by dragging the elements with the mouse from the left list to the right list.' =>
            'Sie können Aktivitäts-Dialoge dieser Aktivität zuweisen, indem Sie die Elemente mit der Maus aus der linken Liste in die rechte Liste verschieben.',
        'Ordering the elements within the list is also possible by drag \'n\' drop.' =>
            'Die Elemente können auch durch Verschieben mit der Maus geordnet werden.',
        'Filter available Activity Dialogs' => 'Verfügbare Aktivitäts-Dialoge filtern',
        'Available Activity Dialogs' => 'Verfügbare Aktivitäts-Dialoge',
        'Create New Activity Dialog' => 'Neuen Aktivitäts-Dialog erstellen',
        'Assigned Activity Dialogs' => 'Zugewiesene Aktivitäts-Dialoge',
        'As soon as you use this button or link, you will leave this screen and its current state will be saved automatically. Do you want to continue?' =>
            'Sobald sie den Knopf oder den Link verwenden, verlassen Sie dieses Fenster, und der aktuelle Stand wird automatisch gespeichert. Möchten Sie fortfahren?',

        # Template: AdminProcessManagementActivityDialog
        'Please note that changing this activity dialog will affect the following activities' =>
            'Veränderungen an diesem ActivityDialog werden sich auf folgende Activities auswirken',
        'Activity Dialog' => 'Aktivitäts-Dialog',
        'Activity dialog Name' => 'Name des Aktivitäts-Dialogs',
        'Available in' => 'Verfügbar in',
        'Description (short)' => 'Beschreibung (kurz)',
        'Description (long)' => 'Beschreibung (lang)',
        'The selected permission does not exist.' => 'Die ausgewählte Berechtigung existiert nicht.',
        'Required Lock' => 'Erforderliche Sperre',
        'The selected required lock does not exist.' => 'Die ausgewählte Sperre existiert nicht',
        'Submit Advice Text' => 'Hinweistext beim Absenden',
        'Submit Button Text' => 'Hinweistext für den Absendeknopf',
        'Fields' => 'Felder',
        'You can assign Fields to this Activity Dialog by dragging the elements with the mouse from the left list to the right list.' =>
            'Sie können diesem Aktivitäts-Dialog Felder zuweisen, indem Sie sie mit der Maus aus der rechten Liste in die linke Liste verschieben.',
        'Filter available fields' => 'Verfügbare Felder filtern',
        'Available Fields' => 'Verfügbare Felder',
        'Assigned Fields' => 'Zugewiesene Felder',
        'Edit Details for Field' => 'Details bearbeiten für Feld',
        'ArticleType' => 'Artikeltyp',
        'Display' => 'Anzeige',
        'Edit Field Details' => 'Feld-Details bearbeiten',
        'Customer interface does not support internal article types.' => 'Die Kundenoberfläche unterstützt keine internen Artikeltypen.',

        # Template: AdminProcessManagementPath
        'Path' => 'Pfad',
        'Edit this transition' => 'Diesen Übergang bearbeiten',
        'Transition Actions' => 'Übergangs-Aktionen',
        'You can assign Transition Actions to this Transition by dragging the elements with the mouse from the left list to the right list.' =>
            'Die können diesem Übergang Übergangs-Aktionen zuweisen, indem Sie sie mit der Maus aus der rechten Liste in die linke Liste verschieben.',
        'Filter available Transition Actions' => 'Verfügbare Übergangs-Aktionen filtern',
        'Available Transition Actions' => 'Verfügbare Übergangs-Aktionen',
        'Create New Transition Action' => 'Neue Übergangs-Aktion erstellen',
        'Assigned Transition Actions' => 'Zugewiesene Übergangs-Aktionen',

        # Template: AdminProcessManagementPopupResponse

        # Template: AdminProcessManagementProcessAccordion
        'Activities' => 'Aktivitäten',
        'Filter Activities...' => 'Aktivitäten filtern...',
        'Create New Activity' => 'Neue Aktivität erstellen',
        'Filter Activity Dialogs...' => 'Aktivitäts-Dialoge filtern',
        'Transitions' => 'Übergänge',
        'Filter Transitions...' => 'Übergänge filtern',
        'Create New Transition' => 'Neuen Übergang erstellen',
        'Filter Transition Actions...' => 'Übergangs-Aktionen filtern...',

        # Template: AdminProcessManagementProcessEdit
        'Edit Process' => 'Prozess bearbeiten',
        'Print process information' => 'Prozess-Informationen drucken',
        'Delete Process' => 'Prozess löschen',
        'Delete Inactive Process' => 'Inaktive Prozesse löschen',
        'Available Process Elements' => 'Verfügbare Prozess-Elemente',
        'The Elements listed above in this sidebar can be moved to the canvas area on the right by using drag\'n\'drop.' =>
            'Die in der Seitenleiste aufgelisteten Elemente können mit der Maus in den Zeichenbereich gezogen werden.',
        'You can place Activities on the canvas area to assign this Activity to the Process.' =>
            'Sie können Aktivitäten im Zeichenbereich platzieren, um diese Aktivitäten dem Prozess zuzuordnen',
        'To assign an Activity Dialog to an Activity drop the Activity Dialog element from this sidebar over the Activity placed in the canvas area.' =>
            'Aktivitäts-Dialoge können Sie einer Aktivität zuweisen, indem Sie diese aus der Seitenleiste über die Aktivität im Zeichenbereich ziehen.',
        'You can start a connection between to Activities by dropping the Transition element over the Start Activity of the connection. After that you can move the loose end of the arrow to the End Activity.' =>
            'Eine Verbindung zwischen Aktivitäten können sie erstellen, indem Sie ein Übergangselement auf die Start-Aktivität der Verbindung ziehen. Anschließend können Sie das freie Ende des Pfeils zur Ziel-Aktivität ziehen.',
        'Actions can be assigned to a Transition by dropping the Action Element onto the label of a Transition.' =>
            'Aktionen können einem Übergang zugeweisen werden, indem Sie das Aktionselement auf den Namen des Übergangs ziehen.',
        'Edit Process Information' => 'Prozess-Informationen bearbeiten',
        'The selected state does not exist.' => 'Der ausgewählte Status existiert nicht.',
        'Add and Edit Activities, Activity Dialogs and Transitions' => 'Aktivitäten, Aktivitäts-Dialoge und Übergänge hinzufügen und bearbeiten',
        'Show EntityIDs' => 'EntityIDs einblenden',
        'Extend the width of the Canvas' => 'Die Breite der Zeichenfläche vergrößern',
        'Extend the height of the Canvas' => 'Die Höhe der Zeichenfläche vergrößern',
        'Remove the Activity from this Process' => 'Aktivität aus diesem Prozess entfernen',
        'Edit this Activity' => 'Diese Aktivität bearbeiten',
        'Do you really want to delete this Process?' => 'Möchten Sie diesen Prozess wirklich löschen?',
        'Do you really want to delete this Activity?' => 'Möchten Sie diese Aktivität wirklich löschen?',
        'Do you really want to delete this Activity Dialog?' => 'Möchten Sie diesen Aktivitäts-Dialog wirklich löschen?',
        'Do you really want to delete this Transition?' => 'Möchten Sie diesen Übergang wirklich löschen?',
        'Do you really want to delete this Transition Action?' => 'Möchten Sie diese Übergangs-Aktion wirklich löschen?',
        'Do you really want to remove this activity from the canvas? This can only be undone by leaving this screen without saving.' =>
            'Möchten Sie diese Aktivität wirklich von der Zeichenfläche entfernen? Das kann nur rückgängig gemacht werden, wenn Sie dieses Fenster ohne Speichern verlassen.',
        'Do you really want to remove this transition from the canvas? This can only be undone by leaving this screen without saving.' =>
            'Möchten Sie diesen Übergang wirklich von der Zeichenfläche entfernen? Das kann nur rückgängig gemacht werden, wenn Sie dieses Fenster ohne Speichern verlassen.',
        'Hide EntityIDs' => 'EntityIDs ausblenden',
        'Delete Entity' => 'Entität löschen',
        'Remove Entity from canvas' => 'Entität entfernen',
        'This Activity is already used in the Process. You cannot add it twice!' =>
            'Diese Aktivität wird bereits im Prozess verwendet. Sie können sie nicht erneut hinzufügen!',
        'This Activity cannot be deleted because it is the Start Activity.' =>
            'Diese Aktivität kann nicht gelöscht werden, weil sie die Start-Aktivität ist.',
        'This Transition is already used for this Activity. You cannot use it twice!' =>
            'Dieser Übergang wird bereits für diese Aktiviät verwendet. Sie können ihn nicht erneut hinzufügen!',
        'This TransitionAction is already used in this Path. You cannot use it twice!' =>
            'Diese Übergangsaktion wird bereits in diesem Pfad verwendet. Sie können sie nicht erneut hinzufügen!',
        'Remove the Transition from this Process' => 'Diesen Übergang aus dem Prozess entfernen',
        'No TransitionActions assigned.' => 'Keine Übergangsaktionen zugewiesen.',
        'The Start Event cannot loose the Start Transition!' => 'Das Startereignis kann den Start-Übergang nicht verlieren.',
        'No dialogs assigned yet. Just pick an activity dialog from the list on the left and drag it here.' =>
            'Es sind noch keine Dialoge zugewiesen. Wählen Sie einfach einen Aktivitäts-Dialog in der linken Liste aus und ziehen Sie ihn in die rechte Liste.',
        'An unconnected transition is already placed on the canvas. Please connect this transition first before placing another transition.' =>
            'Auf der Zeichenfläche ist ein nicht verbundener Übergang vorhanden. Bitte verbinden Sie diesen Übergang zuerst, bevor Sie einen weiteren Übergang platzieren.',

        # Template: AdminProcessManagementProcessNew
        'In this screen, you can create a new process. In order to make the new process available to users, please make sure to set its state to \'Active\' and synchronize after completing your work.' =>
            'Hier können Sie einen neuen Prozess erstellen. Um ihn für die Benutzer verfügbar zu machen, sollten Sie seinen Status auf "Aktiv" setzen und als Abschluss Ihrer Arbeit die Synchronisation durchführen.',

        # Template: AdminProcessManagementProcessPrint
        'Start Activity' => 'Start-Aktivität',
        'Contains %s dialog(s)' => 'Enthält %s Dialog(e)',
        'Assigned dialogs' => 'Zugewiesene Dialoge',
        'Activities are not being used in this process.' => 'In diesem Prozess werden keine Aktivitäten verwendet.',
        'Assigned fields' => 'Zugewiesene Felder',
        'Activity dialogs are not being used in this process.' => 'In diesem Prozess werden keine Aktivitäts-Dialoge verwendet.',
        'Condition linking' => 'Verknüpfung der Bedingungen',
        'Conditions' => 'Bedingungen',
        'Condition' => 'Bedingung',
        'Transitions are not being used in this process.' => 'In diesem Prozess werden keine Übergänge verwendet.',
        'Module name' => 'Modulname',
        'Configuration' => 'Konfiguration',
        'Transition actions are not being used in this process.' => 'In diesem Prozess werden keine Übergangs-Aktionen verwendet.',

        # Template: AdminProcessManagementTransition
        'Please note that changing this transition will affect the following processes' =>
            'Achtung: Änderungen an diesem Übergang wirken sich auf folgende Prozesse aus',
        'Transition' => 'Übergang',
        'Transition Name' => 'Name des Übergangs',
        'Type of Linking between Conditions' => 'Verknüpfung zwischen den Bedingungen',
        'Remove this Condition' => 'Bedingung entfernen',
        'Type of Linking' => 'Typ der Verknüpfung',
        'Remove this Field' => 'Feld entfernen',
        'Add a new Field' => 'Neues Feld hinzufügen',
        'Add New Condition' => 'Neue Bedingung hinzufügen',

        # Template: AdminProcessManagementTransitionAction
        'Please note that changing this transition action will affect the following processes' =>
            'Achtung: Änderungen an dieser Übergangs-Aktion wirken sich auf folgende Prozesse aus',
        'Transition Action' => 'Übergangs-Aktion',
        'Transition Action Name' => 'Name der Übergangs-Aktion',
        'Transition Action Module' => 'Übergangs-Aktionsmodul',
        'Config Parameters' => 'Konfigurations-Parameter',
        'Remove this Parameter' => 'Parameter entfernen',
        'Add a new Parameter' => 'Neuen Parameter hinzufügen',

        # Template: AdminQueue
        'Manage Queues' => 'Queue-Verwaltung',
        'Add queue' => 'Queue hinzufügen',
        'Add Queue' => 'Queue hinzufügen',
        'Edit Queue' => 'Queue bearbeiten',
        'Sub-queue of' => 'Unterqueue von',
        'Unlock timeout' => 'Freigabe-Zeitintervall',
        '0 = no unlock' => '0 = keine Freigabe',
        'Only business hours are counted.' => 'Nur Geschäftszeiten werden berücksichtigt.',
        'If an agent locks a ticket and does not close it before the unlock timeout has passed, the ticket will unlock and will become available for other agents.' =>
            'Wenn ein Agent ein Ticket sperrt und es vor der Entsperrzeit nicht schließt, wird es entsperrt und wieder für andere Agenten verfügbar gemacht.',
        'Notify by' => 'Benachrichtigt von',
        '0 = no escalation' => '0 = keine Eskalation',
        'If there is not added a customer contact, either email-external or phone, to a new ticket before the time defined here expires, the ticket is escalated.' =>
            'Wenn vor der definierten Zeit keine Kundenreaktion erfolgt (email-external oder phone), eskaliert das Ticket.',
        'If there is an article added, such as a follow-up via email or the customer portal, the escalation update time is reset. If there is no customer contact, either email-external or phone, added to a ticket before the time defined here expires, the ticket is escalated.' =>
            'Wenn ein Artikel vom Kunden hinzugefügt wird, wird die Eskalationszeit zurückgesetzt. Wenn vor der definierten Zeit keine Kundenreaktion erfolgt, eskaliert das Ticket.',
        'If the ticket is not set to closed before the time defined here expires, the ticket is escalated.' =>
            'Wenn ein Ticket nicht vor der definierten Zeit geschlossen wird, eskaliert es.',
        'Follow up Option' => 'Nachfrage-Option',
        'Specifies if follow up to closed tickets would re-open the ticket, be rejected or lead to a new ticket.' =>
            'Gibt an, ob eine Rückmeldung zu einem geschlossenen Ticket diese Ticket erneut öffnet, abgelehnt wird oder zu einem neuen Ticket führt.',
        'Ticket lock after a follow up' => 'Ticket sperren nach einer Rückmeldung',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked to the old owner.' =>
            'Wenn ein Ticket geschlossen wird und der Kunde eine Rückmeldung schickt, wird es für den letzten Besitzer gesperrt.',
        'System address' => 'Systemadresse',
        'Will be the sender address of this queue for email answers.' => 'Absenderadresse für E-Mails aus dieser Queue.',
        'Default sign key' => 'Standardschlüssel zum Signieren',
        'The salutation for email answers.' => 'Die Anrede für E-Mail-Antworten.',
        'The signature for email answers.' => 'Die Signatur für E-Mail-Antworten.',

        # Template: AdminQueueAutoResponse
        'Manage Queue-Auto Response Relations' => 'Zuordnung von Queues und automatischen Antworten verwalten',
        'Filter for Queues' => 'Filter für Queues',
        'Filter for Auto Responses' => 'Filter für automatische Antworten',
        'Auto Responses' => 'Automatische Antworten',
        'Change Auto Response Relations for Queue' => 'Auto-Antwort-Zuordnungen verändern für Queue',
        'settings' => 'Einstellungen',

        # Template: AdminQueueResponses
        'Manage Response-Queue Relations' => 'Zuordnung von Antworten und Queues verwalten',
        'Filter for Responses' => 'Filter für Antworten',
        'Responses' => 'Antworten',
        'Change Queue Relations for Response' => 'Queue-Zuordnungen verändern für Antwort',
        'Change Response Relations for Queue' => 'Antwort-Zuordnungen verändern für Queue',

        # Template: AdminResponse
        'Manage Responses' => 'Antworten verwalten',
        'Add response' => 'Antwort hinzufügen',
        'A response is a default text which helps your agents to write faster answers to customers.' =>
            'Eine Antwort ist ein vordefinierter Text, mit dem Ihre Agenten den Kunden schneller antworten zu können.',
        'Don\'t forget to add new responses to queues.' => 'Neue Antworten müssen einer Queue zugewiesen werden!',
        'Delete this entry' => 'Diesen Eintrag löschen',
        'Add Response' => 'Antwort hinzufügen',
        'Edit Response' => 'Antwort bearbeiten',
        'The current ticket state is' => 'Der aktuelle Ticket-Status ist',
        'Your email address is' => 'Ihre E-Mail-Adresse ist',

        # Template: AdminResponseAttachment
        'Manage Responses <-> Attachments Relations' => 'Zuordnungen von Antworten und Anlagen verwalten',
        'Filter for Attachments' => 'Filter für Anlagen',
        'Change Response Relations for Attachment' => 'Antwort-Zuordnungen verändern für Anlage',
        'Change Attachment Relations for Response' => 'Alage-Zuordnungen verändern für Antwort',
        'Toggle active for all' => 'Aktiv umschalten für alle',
        'Link %s to selected %s' => '%s zu %s (markiert) verknüpfen',

        # Template: AdminRole
        'Role Management' => 'Rollen-Verwaltung',
        'Add role' => 'Rolle hinzufügen',
        'Create a role and put groups in it. Then add the role to the users.' =>
            'Erstelle eine Rolle und weise Gruppen hinzu. Danach füge Benutzer zu den Rollen hinzu.',
        'There are no roles defined. Please use the \'Add\' button to create a new role.' =>
            'Bislang sind keine Rollen definiert. Bitte verwenden Sie den Knopf "Hinzufügen", um neue Rollen zu erstellen.',
        'Add Role' => 'Rolle hinzufügen',
        'Edit Role' => 'Rolle bearbeiten',

        # Template: AdminRoleGroup
        'Manage Role-Group Relations' => 'Zuordnungen von Rollen zu Gruppen verwalten',
        'Filter for Roles' => 'Filter für Rollen',
        'Roles' => 'Rollen',
        'Select the role:group permissions.' => 'Wählen Sie die Rolle:Gruppe-Berechtigungen aus.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the role).' =>
            'Wenn nichts ausgewählt ist, hat die Rolle in dieser Gruppe keine Berechtigungen (und kann nicht auf Tickets zugreifen).',
        'Change Role Relations for Group' => 'Rollen-Zuordnungen ändern für Gruppe',
        'Change Group Relations for Role' => 'Gruppen-Zuordnungen ändern für Rolle',
        'Toggle %s permission for all' => 'Berechtigung %s für alle umschalten',
        'move_into' => 'Verschieben in',
        'Permissions to move tickets into this group/queue.' => 'Rechte, um Tickets in eine Gruppe/Queue zu verschieben.',
        'create' => 'Erstellen',
        'Permissions to create tickets in this group/queue.' => 'Rechte, um in einer Gruppe/Queue Tickets zu erstellen.',
        'priority' => 'Priorität',
        'Permissions to change the ticket priority in this group/queue.' =>
            'Rechte, um die Priorität eines Tickets in einer Gruppe/Queue zu ändern.',

        # Template: AdminRoleUser
        'Manage Agent-Role Relations' => 'Zuordnungen von Agenten und Rollen verwalten',
        'Filter for Agents' => 'Filter für Agenten',
        'Agents' => 'Agenten',
        'Manage Role-Agent Relations' => 'Zuordnungen von Agenten und Rollen verwalten',
        'Change Role Relations for Agent' => 'Rollen-Zuordnungen verändern für Agenten',
        'Change Agent Relations for Role' => 'Agenten-Zurordnungen verändern für Rolle',

        # Template: AdminSLA
        'SLA Management' => 'SLA-Verwaltung',
        'Add SLA' => 'SLA hinzufügen',
        'Edit SLA' => 'SLA bearbeiten',
        'Please write only numbers!' => 'Bitte geben Sie nur Zahlen ein!',

        # Template: AdminSMIME
        'S/MIME Management' => 'S/MIME-Verwaltung',
        'Add certificate' => 'Zertifikat hinzufügen',
        'Add private key' => 'Privaten Schlüssel hinzufügen',
        'Filter for certificates' => 'Filter für Zertifikate',
        'Filter for SMIME certs' => 'Filter für SMIME-Zertifikate',
        'Here you can add relations to your private certificate, these will be embedded to the SMIME signature every time you use this certificate to sign an email.' =>
            'Hier können Sie Zugehörigkeiten zu Ihren privaten Zertifikaten hinzufügen, diese werden in die SMIME-Signatur eingebettet, wenn Sie das Zertifikat zum Signieren einer Mail benutzen.',
        'See also' => 'Siehe auch',
        'In this way you can directly edit the certification and private keys in file system.' =>
            'Über diesen Weg können die Zertifikate und privaten Schlüssel im Dateisystem bearbeitet werden.',
        'Hash' => 'Hash',
        'Create' => 'Erstellen',
        'Handle related certificates' => 'Zugehörige Zertifikate verwalten',
        'Read certificate' => 'Zertifikat lesen',
        'Delete this certificate' => 'Dieses Zertifikat löschen',
        'Add Certificate' => 'Zertifikat hinzufügen',
        'Add Private Key' => 'Privaten Schlüssel hinzufügen',
        'Secret' => 'Secret',
        'Related Certificates for' => 'Zugehörige Zertifikate zu %s',
        'Delete this relation' => 'Diese Zugehörigkeit löschen',
        'Available Certificates' => 'Verfügbare Zertifikate',
        'Relate this certificate' => 'Dieses Zertifikat zuordnen',

        # Template: AdminSMIMECertRead
        'SMIME Certificate' => 'SMIME-Zertifikat',
        'Close window' => 'Fenster schließen',

        # Template: AdminSalutation
        'Salutation Management' => 'Anreden-Verwaltung',
        'Add salutation' => 'Anrede hinzufügen',
        'Add Salutation' => 'Anrede hinzufügen',
        'Edit Salutation' => 'Anrede bearbeiten',
        'Example salutation' => 'Beispiel-Anrede',

        # Template: AdminScheduler
        'This option will force Scheduler to start even if the process is still registered in the database' =>
            'Diese Option zwingt den Scheduler, auch dann zu starten, wenn bereits ein Prozess in der Datenbank registriert ist',
        'Start scheduler' => 'Scheduler starten',
        'Scheduler could not be started. Check if scheduler is not running and try it again with Force Start option' =>
            'Scheduler konnte nicht gestartet werden. Prüfen Sie, ob er bereits läuft und versuchen Sie es erneut mit der Option "Start erzwingen"',

        # Template: AdminSecureMode
        'Secure mode needs to be enabled!' => 'Sicherheitsmodus muss eingeschaltet sein!',
        'Secure mode will (normally) be set after the initial installation is completed.' =>
            'Der Sicherheitsmodus wird normalerweise eingeschaltet, nachdem die Installation abgeschlossen ist.',
        'If secure mode is not activated, activate it via SysConfig because your application is already running.' =>
            'Wenn der Sicherheitsmodus nicht aktiv ist, können Sie ihn mit der SysConfig aktivieren, da Ihr System bereits läuft.',

        # Template: AdminSelectBox
        'SQL Box' => 'SQL Box',
        'Here you can enter SQL to send it directly to the application database.' =>
            'Hier können Sie SQL eingeben, welches direkt an die Datenbank gesendet wird.',
        'The syntax of your SQL query has a mistake. Please check it.' =>
            'Die Syntax Ihrer SQL-Abfrage ist fehlerhaft. Bitte prüfen.',
        'There is at least one parameter missing for the binding. Please check it.' =>
            'Es fehlt mindestens ein Parameter für das Binding. Bitte prüfen.',
        'Result format' => 'Format der Ergebnisse',
        'Run Query' => 'Anfrage ausführen',

        # Template: AdminService
        'Service Management' => 'Service-Verwaltung',
        'Add service' => 'Service hinzufügen',
        'Add Service' => 'Service hinzufügen',
        'Edit Service' => 'Service bearbeiten',
        'Sub-service of' => 'Unterservice von',

        # Template: AdminSession
        'Session Management' => 'Sitzungsverwaltung',
        'All sessions' => 'Alle Sitzungen',
        'Agent sessions' => 'Agenten-Sitzungen',
        'Customer sessions' => 'Kunden-Sitzungen',
        'Unique agents' => 'Eindeutige Agenten',
        'Unique customers' => 'Eindeutige Kunden',
        'Kill all sessions' => 'Löschen aller Sessions',
        'Kill this session' => 'Diese Sitzung löschen',
        'Session' => 'Session',
        'Kill' => 'Löschen',
        'Detail View for SessionID' => 'Detailansicht für SessionID',

        # Template: AdminSignature
        'Signature Management' => 'Signatur-Verwaltung',
        'Add signature' => 'Signatur hinzufügen',
        'Add Signature' => 'Signatur hinzufügen',
        'Edit Signature' => 'Signatur bearbeiten',
        'Example signature' => 'Beispiel-Signatur',

        # Template: AdminState
        'State Management' => 'Status-Verwaltung',
        'Add state' => 'Status hinzufügen',
        'Please also update the states in SysConfig where needed.' => 'Bitte aktualisieren Sie auch die Status in der SysConfig dort, wo es erforderlich ist.',
        'Add State' => 'Status hinzufügen',
        'Edit State' => 'Status bearbeiten',
        'State type' => 'Status-Typ',

        # Template: AdminSysConfig
        'SysConfig' => 'SysConfig',
        'Navigate by searching in %s settings' => 'Navigieren Sie mit Hilfe der Suche in %s Einstellungen',
        'Navigate by selecting config groups' => 'Navigieren Sie durch Auswahl der Konfigurationsgruppen',
        'Download all system config changes' => 'Alle Konfigurationsanpassungen herunterladen',
        'Export settings' => 'Einstellungen exportieren',
        'Load SysConfig settings from file' => 'SysConfig-Einstellungen aus Datei laden',
        'Import settings' => 'Einstellungen importieren',
        'Import Settings' => 'Einstellungen importieren',
        'Please enter a search term to look for settings.' => 'Bitte geben Sie einen Suchbegriff ein, um nach Einstellungen zu suchen.',
        'Subgroup' => 'Untergruppe',
        'Elements' => 'Elemente',

        # Template: AdminSysConfigEdit
        'Edit Config Settings' => 'Konfigurationseinstellungen bearbeiten',
        'This config item is only available in a higher config level!' =>
            'Diese Einstellung ist nur in einem höheren Konfigurationslevel verfügbar!',
        'Reset this setting' => 'Diese Einstellung zurücksetzen',
        'Error: this file could not be found.' => 'Error: Diese Datei konnte nicht gefunden werden.',
        'Error: this directory could not be found.' => 'Error: Dieses Verzeichnis konnte nicht gefunden werden.',
        'Error: an invalid value was entered.' => 'Error: Ein ungültiger Wert wurde eingegeben.',
        'Content' => 'Inhalt',
        'Remove this entry' => 'Diesen Eintrag entfernen',
        'Add entry' => 'Eintrag hinzufügen',
        'Remove entry' => 'Eintrag entfernen',
        'Add new entry' => 'Eintrag hinzufügen',
        'Create new entry' => 'Eintrag hinzufügen',
        'New group' => 'Neue Gruppe',
        'Group ro' => 'Gruppe ro',
        'Readonly group' => 'Nur-Lesen-Gruppe',
        'New group ro' => 'Neue Gruppe ro',
        'Loader' => 'Loader',
        'File to load for this frontend module' => 'Datei, die für dieses Fontendmodul geladen werden soll',
        'New Loader File' => 'Neue Loader-Datei',
        'NavBarName' => 'NavBarName',
        'NavBar' => 'NavBar',
        'LinkOption' => 'LinkOption',
        'Block' => 'Block',
        'AccessKey' => 'AccessKey',
        'Add NavBar entry' => 'NavBar-Eintrag hinzufügen',
        'Year' => 'Jahr',
        'Month' => 'Monat',
        'Day' => 'Tag',
        'Invalid year' => 'Ungültiges Jahr',
        'Invalid month' => 'Ungültiger Monat',
        'Invalid day' => 'Ungültiger Tag',

        # Template: AdminSystemAddress
        'System Email Addresses Management' => 'Verwaltung von System-E-Mail-Adressen',
        'Add system address' => 'Systemadresse hinzufügen',
        'All incoming email with this address in To or Cc will be dispatched to the selected queue.' =>
            'Alle einkommenden E-Mails mit dieser Adresse in An: oder Cc: werden an die ausgewählte Queue geleitet.',
        'Email address' => 'E-Mail-Adresse',
        'Display name' => 'Anzeigename',
        'Add System Email Address' => 'System-E-Mail-Adresse hinzufügen',
        'Edit System Email Address' => 'System-E-Mail-Adresse bearbeiten',
        'The display name and email address will be shown on mail you send.' =>
            'Der Anzeigename und die E-Mail-Adresse werden für die gesendeten Mail verwendet.',

        # Template: AdminType
        'Type Management' => 'Typ-Verwaltung',
        'Add ticket type' => 'Ticket-Typ hinzufügen',
        'Add Type' => 'Typ hinzufügen',
        'Edit Type' => 'Typ bearbeiten',

        # Template: AdminUser
        'Add agent' => 'Agent hinzufügen',
        'Agents will be needed to handle tickets.' => 'Agenten werden für die Verarbeitung von Tickets benötigt.',
        'Don\'t forget to add a new agent to groups and/or roles!' => 'Vergessen Sie nicht, einen neuen Agenten zu Gruppen und/oder Rollen hinzuzufügen!',
        'Please enter a search term to look for agents.' => 'Bitte geben Sie einen Suchbegriff ein, um nach Agenten zu suchen.',
        'Last login' => 'Letzte Anmeldung',
        'Switch to agent' => 'Wechseln zu Agent',
        'Add Agent' => 'Agent hinzufügen',
        'Edit Agent' => 'Agent bearbeiten',
        'Firstname' => 'Vorname',
        'Lastname' => 'Nachname',
        'Password is required.' => 'Das Passwort ist erforderlich.',
        'Start' => 'Start',
        'End' => 'Ende',

        # Template: AdminUserGroup
        'Manage Agent-Group Relations' => 'Zuordnungen von Agent und Gruppe verwalten',
        'Change Group Relations for Agent' => 'Gruppenzuordnungen verwalten für Agenten',
        'Change Agent Relations for Group' => 'Agentenzuordnungen verwalten für Gruppe',
        'note' => 'Hinweis',
        'Permissions to add notes to tickets in this group/queue.' => 'Berechtigung zum Hinzufügen von Hinweisen zu Tickets dieser Gruppe/Queue.',
        'owner' => 'Besitzer',
        'Permissions to change the owner of tickets in this group/queue.' =>
            'Berechtigung zum Ändern des Besitzers von Tickets dieser Gruppe/Queue.',

        # Template: AgentBook
        'Address Book' => 'Adressbuch',
        'Search for a customer' => 'Suche nach einem Kunden',
        'Add email address %s to the To field' => 'E-Mail-Adresse %s zum "An"-Feld hinzufügen',
        'Add email address %s to the Cc field' => 'E-Mail-Adresse %s zum "Cc"-Feld hinzufügen',
        'Add email address %s to the Bcc field' => 'E-Mail-Adresse %s zum "Bcc"-Feld hinzufügen',
        'Apply' => 'Anwenden',

        # Template: AgentCustomerInformationCenter
        'Customer Information Center' => 'Kunden-Informationszentrum',

        # Template: AgentCustomerInformationCenterBlank

        # Template: AgentCustomerInformationCenterSearch
        'Customer ID' => 'Kunden-ID',
        'Customer User' => 'Kunden-Benutzer',

        # Template: AgentCustomerSearch
        'Search Customer' => 'Kunden suchen',
        'Duplicated entry' => 'Doppelter Eintrag',
        'This address already exists on the address list.' => 'Dieser Eintrag existiert bereits in der Adressliste',
        'It is going to be deleted from the field, please try again.' => 'Er wird aus dem Feld entfernt, bitte versuchen Sie es erneut.',

        # Template: AgentCustomerTableView

        # Template: AgentDashboard
        'Dashboard' => 'Übersicht',

        # Template: AgentDashboardCalendarOverview
        'in' => 'in',

        # Template: AgentDashboardCustomerCompanyInformation

        # Template: AgentDashboardCustomerIDStatus
        'Escalated tickets' => 'Eskalierte Tickets',

        # Template: AgentDashboardCustomerUserList
        'Customer information' => 'Kundeninformation',
        'Phone ticket' => 'Telefon-Ticket',
        'Email ticket' => 'E-Mail-Ticket',
        '%s open ticket(s) of %s' => '%s offene Tickets von %s',
        '%s closed ticket(s) of %s' => '%s geschlossene Tickets von %s',
        'New phone ticket from %s' => 'Neues Telefonticket von %s',
        'New email ticket to %s' => 'Neues E-Mail-Ticket an %s',

        # Template: AgentDashboardIFrame

        # Template: AgentDashboardImage

        # Template: AgentDashboardProductNotify
        '%s %s is available!' => '%s %s ist nun verfügbar!',
        'Please update now.' => 'Bitte nun aktualisieren.',
        'Release Note' => 'Versionsbeschreibung',
        'Level' => 'Level',

        # Template: AgentDashboardRSSOverview
        'Posted %s ago.' => 'Veröffentlicht vor %s.',

        # Template: AgentDashboardTicketGeneric
        'My locked tickets' => 'Meine gesperrten Tickets',
        'My watched tickets' => 'Meine beobachteten Tickets',
        'My responsibilities' => 'Meine Verantwortlichkeiten',
        'Tickets in My Queues' => 'Tickets in meinen Queues',

        # Template: AgentDashboardTicketStats

        # Template: AgentDashboardUserOnline
        'out of office' => 'abwesend',

        # Template: AgentDashboardUserOutOfOffice
        'until' => 'bis',

        # Template: AgentHTMLReferenceForms

        # Template: AgentHTMLReferenceOverview

        # Template: AgentHTMLReferencePageLayout
        'The ticket has been locked' => 'Das Ticket wurde gesperrt',
        'Undo & close window' => 'Rückgängig machen und Fenster schließen',

        # Template: AgentInfo
        'Info' => 'Info',
        'To accept some news, a license or some changes.' => 'Neuigkeiten, eine Lizenz oder Änderungen bestätigen.',

        # Template: AgentLinkObject
        'Link Object: %s' => 'Verknüpfung erstellen: %s',
        'go to link delete screen' => 'zu "Verknüpfung löschen" wechseln',
        'Select Target Object' => 'Zielobjekt auswählen',
        'Link Object' => 'Verknüpfe Objekt',
        'with' => 'mit',
        'Unlink Object: %s' => 'Verknüpfung lösen: %s',
        'go to link add screen' => 'zu "Verknüpfung hinzufügen" wechseln',

        # Template: AgentNavigationBar

        # Template: AgentPreferences
        'Edit your preferences' => 'Persönliche Einstellungen bearbeiten',

        # Template: AgentSpelling
        'Spell Checker' => 'Rechtschreibprüfung',
        'spelling error(s)' => 'Rechtschreibfehler',
        'Apply these changes' => 'Änderungen übernehmen',

        # Template: AgentStatsDelete
        'Delete stat' => 'Statistik löschen',
        'Stat#' => 'Statistik Nr.',
        'Do you really want to delete this stat?' => 'Möchten Sie diese Statistik wirklich löschen?',

        # Template: AgentStatsEditRestrictions
        'Step %s' => 'Schritt %s',
        'General Specifications' => 'Allgemeine Angaben',
        'Select the element that will be used at the X-axis' => 'Auswahl des Elements für die X-Achse',
        'Select the elements for the value series' => 'Auswahl der Elemente für die Wertereihen',
        'Select the restrictions to characterize the stat' => 'Auswahl der Beschränkungen für diese Statistik',
        'Here you can make restrictions to your stat.' => 'Dieses Formular wird dazu verwendet die Einschränkungen für die Statistik zu definieren.',
        'If you remove the hook in the "Fixed" checkbox, the agent generating the stat can change the attributes of the corresponding element.' =>
            'Wenn Sie den Haken in der "Fixiert" Checkbox entfernen, kann der Agent der die Statistik erstellt, die Attribute des entsprechenden Elements verändern.',
        'Fixed' => 'Fixiert',
        'Please select only one element or turn off the button \'Fixed\'.' =>
            'Bitte wählen Sie nur ein Attribut aus oder entfernen Sie das Häkchen der Checkbox \'Fixiert\'!',
        'Absolute Period' => 'Absoluter Zeitraum',
        'Between' => 'Zwischen',
        'Relative Period' => 'Relativer Zeitraum',
        'The last' => 'Die letzten',
        'Finish' => 'Abschließen',

        # Template: AgentStatsEditSpecification
        'Permissions' => 'Rechtevergabe',
        'You can select one or more groups to define access for different agents.' =>
            'Sie können eine oder mehrere Gruppen definieren, um Zugriffsrechte für verschiedene Agenten zu vergeben.',
        'Some result formats are disabled because at least one needed package is not installed.' =>
            'Einige Ausgabeformate sind nicht aktiviert, weil mindestens ein benötigtes Modul nicht installiert wurde.',
        'Please contact your administrator.' => 'Bitte kontaktieren Sie Ihren Administrator.',
        'Graph size' => 'Grafik-Größe',
        'If you use a graph as output format you have to select at least one graph size.' =>
            'Wenn Sie als Ausgabeformat eine Grafik ausgewählt haben, müssen Sie hier die Grafikgröße auswählen.',
        'Sum rows' => 'Zeilensummierung',
        'Sum columns' => 'Spaltensummierung',
        'Use cache' => 'Cache verwenden',
        'Most of the stats can be cached. This will speed up the presentation of this stat.' =>
            'Die meisten der Statistiken können gecached werden. Dies beschleunigt das wiederholte Aufrufen einer Statistik.',
        'If set to invalid end users can not generate the stat.' => 'Bei "ungültig" können Nutzer die Statistik nicht mehr ausführen.',

        # Template: AgentStatsEditValueSeries
        'Here you can define the value series.' => 'Hier können Sie die Wertereihen definieren.',
        'You have the possibility to select one or two elements.' => 'Sie können ein oder zwei Elemente auswählen.',
        'Then you can select the attributes of elements.' => 'Anschließend können Sie die Attribute der Elemente angeben.',
        'Each attribute will be shown as single value series.' => 'Jedes Attribut wird als eigene Wertereihe angezeigt.',
        'If you don\'t select any attribute all attributes of the element will be used if you generate a stat, as well as new attributes which were added since the last configuration.' =>
            'Wenn Sie kein Element angeben, werden alle Elemente beim Erzeugen der Statistik verwendet, ebenso alle Elemente, die seit der letzten Konfiguration hinzugekommen sind.',
        'Scale' => 'Skalierung',
        'minimal' => 'minimal',
        'Please remember, that the scale for value series has to be larger than the scale for the X-axis (e.g. X-Axis => Month, ValueSeries => Year).' =>
            'Bitte bedenken Sie, dass die Zeitskalierung für die Wertereihen größer sein muss als für die X-Achse (z. B. X-Achse => Monat; Wertereihe => Jahr).',

        # Template: AgentStatsEditXaxis
        'Here you can define the x-axis. You can select one element via the radio button.' =>
            'Hier können Sie die X-Achse konfigurieren. Sie können ein Element mit dem Radio-Button auswählen',
        'maximal period' => 'maximaler Zeitraum',
        'minimal scale' => 'minimale Skalierung',

        # Template: AgentStatsImport
        'Import Stat' => 'Statistik importieren',
        'File is not a Stats config' => 'Diese Datei ist keine Statistik-Konfiguration',
        'No File selected' => 'Keine Datei ausgewählt',

        # Template: AgentStatsOverview
        'Stats' => 'Statistik',

        # Template: AgentStatsPrint
        'No Element selected.' => 'Kein Element ausgewählt.',

        # Template: AgentStatsView
        'Export config' => 'Konfiguration exportieren',
        'With the input and select fields you can influence the format and contents of the statistic.' =>
            'Mit den Eingabe- und Auswahlelementen können Sie Format und Inhalt der Statistik beeinflussen.',
        'Exactly what fields and formats you can influence is defined by the statistic administrator.' =>
            'Welche Felder und Formate Sie genau beeinflussen können, wird vom Administrator der Statistik festgelegt.',
        'Stat Details' => 'Statistik-Details',
        'Format' => 'Format',
        'Graphsize' => 'Grafikgröße',
        'Cache' => 'Cache',
        'Exchange Axis' => 'Achsen vertauschen',
        'Configurable params of static stat' => 'Konfigurierbare Parameter der statischen Statistik',
        'No element selected.' => 'Es wurde kein Element ausgewählt.',
        'maximal period from' => 'maximaler Zeitraum von',
        'to' => 'bis',

        # Template: AgentTicketActionCommon
        'Change Free Text of Ticket' => 'Den "freien" Text des Tickets ändern',
        'Change Owner of Ticket' => 'Den Besitzer des Tickets ändern',
        'Close Ticket' => 'Ticket schließen',
        'Add Note to Ticket' => 'Bemerkung zum Ticket hinzufügen',
        'Set Pending' => 'Setze wartend',
        'Change Priority of Ticket' => 'Ändern der Ticket-Priorität',
        'Change Responsible of Ticket' => 'Ändern der Ticket-Verantwortlichen',
        'Service invalid.' => 'Ungültiger Service',
        'New Owner' => 'Neuer Besitzer',
        'Please set a new owner!' => 'Bitte einen neuen Besitzer angeben',
        'Previous Owner' => 'Vorheriger Besitzer',
        'Inform Agent' => 'Agenten informieren',
        'Optional' => 'Optional',
        'Inform involved Agents' => 'Involvierte Agenten informieren',
        'Spell check' => 'Rechtschreibprüfung',
        'Note type' => 'Notiztyp',
        'Next state' => 'Nächster Status',
        'Pending date' => 'Warten bis',
        'Date invalid!' => 'Ungültiges Datum',

        # Template: AgentTicketActionPopupClose

        # Template: AgentTicketBounce
        'Bounce Ticket' => 'Ticket umleiten',
        'Bounce to' => 'Umleiten an',
        'You need a email address.' => 'Sie benötigen eine E-Mail-Adresse',
        'Need a valid email address or don\'t use a local email address.' =>
            'Benötige eine gültige E-Mail-Adresse, verwenden Sie keine lokale Adresse.',
        'Next ticket state' => 'Nächster Status des Tickets',
        'Inform sender' => 'Sender informieren',
        'Send mail!' => 'Mail übermitteln',

        # Template: AgentTicketBulk
        'Ticket Bulk Action' => 'Ticket Sammelaktion',
        'Send Email' => 'E-Mail versenden',
        'Merge to' => 'Zusammenfassen zu',
        'Invalid ticket identifier!' => 'Ungültiger Ticket-Identifizierer!',
        'Merge to oldest' => 'Zusammenfassen zu Ältestem',
        'Link together' => 'Zusammen verlinken',
        'Link to parent' => 'Mit Eltern verknüpfen',
        'Unlock tickets' => 'Tickets entsperren',

        # Template: AgentTicketClose

        # Template: AgentTicketCompose
        'Compose answer for ticket' => 'Antwort erstellen für',
        'Remove Ticket Customer' => 'Ticket-Kunden entfernen',
        'Please remove this entry and enter a new one with the correct value.' =>
            'Bitte entfernen Sie diesen Eintrag und geben Sie einen gültigen an.',
        'Please include at least one recipient' => 'Bitte geben sie mindestens einen Empfänger an',
        'Remove Cc' => 'Cc entfernen',
        'Remove Bcc' => 'Bcc entfernen',
        'Address book' => 'Adressbuch',
        'Pending Date' => 'Warten bis',
        'for pending* states' => 'für warten* Status',
        'Date Invalid!' => 'Ungültiges Datum!',

        # Template: AgentTicketCustomer
        'Change customer of ticket' => 'Ändern des Kundenkontakts des Tickets',
        'Customer user' => 'Kontakt',

        # Template: AgentTicketEmail
        'Create New Email Ticket' => 'Neues E-Mail-Ticket anlegen',
        'From queue' => 'aus Queue',
        'To customer' => 'An Kunden',
        'Please include at least one customer for the ticket.' => 'Bitte geben Sie mindestens einen Kunden für das Ticket an.',
        'Get all' => 'Alles holen',

        # Template: AgentTicketEscalation

        # Template: AgentTicketForward
        'Forward ticket: %s - %s' => 'Ticket weiterleiten:  %s - %s',

        # Template: AgentTicketFreeText

        # Template: AgentTicketHistory
        'History of' => 'Änderungsverlauf von',
        'History Content' => 'Änderungsverlauf',
        'Zoom view' => 'Großansicht',

        # Template: AgentTicketMerge
        'Ticket Merge' => 'Ticket zusammenfassen',
        'You need to use a ticket number!' => 'Bitte eine Ticketnummer benutzen!',
        'A valid ticket number is required.' => 'Eine gültige Ticketnummer ist erforderlich.',
        'Need a valid email address.' => 'Benötige gültige E-Mail-Adresse.',

        # Template: AgentTicketMove
        'Move Ticket' => 'Ticket verschieben',
        'New Queue' => 'Neue Queue',

        # Template: AgentTicketNote

        # Template: AgentTicketOverviewMedium
        'Select all' => 'Alle auswählen',
        'No ticket data found.' => 'Keine Ticketdaten gefunden.',
        'First Response Time' => 'Reaktionszeit',
        'Service Time' => 'Service Zeit',
        'Update Time' => 'Aktualisierungszeit',
        'Solution Time' => 'Lösungszeit',
        'Move ticket to a different queue' => 'Ticket in eine andere Queue verschieben',
        'Change queue' => 'Queue wechseln',

        # Template: AgentTicketOverviewNavBar
        'Change search options' => 'Such-Optionen ändern',
        'Tickets per page' => 'Tickets pro Seite',

        # Template: AgentTicketOverviewPreview

        # Template: AgentTicketOverviewSmall
        'Escalation in' => 'Eskalation in',
        'Locked' => 'Sperre',

        # Template: AgentTicketOwner

        # Template: AgentTicketPending

        # Template: AgentTicketPhone
        'Create New Phone Ticket' => 'Neues Telefon-Ticket anlegen',
        'From customer' => 'Von Kundenkontakt',
        'To queue' => 'An Queue',

        # Template: AgentTicketPhoneCommon
        'Phone call' => 'Anruf',

        # Template: AgentTicketPlain
        'Email Text Plain View' => 'E-Mail unformatiert anzeigen',
        'Plain' => 'Unformatiert',
        'Download this email' => 'Diese E-Mail herunterladen',

        # Template: AgentTicketPrint
        'Ticket-Info' => 'Ticket-Info',
        'Accounted time' => 'Erfasste Zeit',
        'Linked-Object' => 'Verknüpfte-Objekte',
        'by' => 'von',

        # Template: AgentTicketPriority

        # Template: AgentTicketProcess
        'Create New Process Ticket' => 'Neues Prozessticket',
        'Process' => 'Prozess',

        # Template: AgentTicketProcessNavigationBar

        # Template: AgentTicketQueue

        # Template: AgentTicketResponsible

        # Template: AgentTicketSearch
        'Search template' => 'Suchvorlage',
        'Create Template' => 'Vorlage anlegen',
        'Create New' => 'Neue anlegen',
        'Profile link' => 'Profil-Link',
        'Save changes in template' => 'Änderungen in der Vorlage speichern',
        'Add another attribute' => 'Ein weiteres Attribut hinzufügen',
        'Output' => 'Ausgabe',
        'Fulltext' => 'Volltext',
        'Remove' => 'Entfernen',
        'Searches in the attributes From, To, Cc, Subject and the article body, overriding other attributes with the same name.' =>
            'Sucht in den Attributen Von, Cc, Betreff, Artikelinhalt und überschreibt Attribute mit dem selben Namen.',
        'Customer User Login' => 'Anmeldung Kundenkontakt',
        'Created in Queue' => 'Erstellt in Queue',
        'Lock state' => 'Status Sperre',
        'Watcher' => 'Beobachter',
        'Article Create Time (before/after)' => 'Artikel-Erstellzeit (vor/nach)',
        'Article Create Time (between)' => 'Artikel-Erstellzeit (zwischen)',
        'Ticket Create Time (before/after)' => 'Ticket-Erstellzeit (vor/nach)',
        'Ticket Create Time (between)' => 'Ticket-Erstellzeit (zwischen)',
        'Ticket Change Time (before/after)' => 'Ticket-Änderungszeit (vor/nach)',
        'Ticket Change Time (between)' => 'Ticket-Änderungszeit (zwischen)',
        'Ticket Close Time (before/after)' => 'Ticket-Schließzeit (vor/nach)',
        'Ticket Close Time (between)' => 'Ticket-Schließzeit (zwischen)',
        'Ticket Escalation Time (before/after)' => 'Ticket-Eskalationszeit (vor/nach)',
        'Ticket Escalation Time (between)' => 'Ticket-Eskalationszeit (zwischen)',
        'Archive Search' => 'Archivsuche',
        'Run search' => 'Suche starten',

        # Template: AgentTicketSearchOpenSearchDescriptionFulltext

        # Template: AgentTicketSearchOpenSearchDescriptionTicketNumber

        # Template: AgentTicketSearchResultPrint

        # Template: AgentTicketZoom
        'Article filter' => 'Filter für Beiträge',
        'Article Type' => 'Artikel Typ',
        'Sender Type' => 'Absender Typ',
        'Save filter settings as default' => 'Filter-Einstellungen als Standard speichern',
        'Archive' => 'Archiv',
        'This ticket is archived.' => 'Dieses Ticket ist archiviert.',
        'Linked Objects' => 'Verknüpfte Objekte',
        'Article(s)' => 'Beitrag/Beiträge',
        'Change Queue' => 'Queue ändern',
        'There are no dialogs available at this point in the process.' =>
            'Für diesen Prozess stehen derzeit keine Dialoge zur Verfügung.',
        'This item has no articles yet.' => 'Dieser Eintrag hat noch keine Artikel',
        'Article Filter' => 'Artikelfilter',
        'Add Filter' => 'Filter hinzufügen',
        'Set' => 'Setzen',
        'Reset Filter' => 'Filter zurücksetzen',
        'Show one article' => 'Einen Beitrag anzeigen',
        'Show all articles' => 'Alle Beiträge anzeigen',
        'Unread articles' => 'Ungelesene Beiträge',
        'No.' => 'Nr.',
        'Unread Article!' => 'Ungelesene Beiträge!',
        'Incoming message' => 'Eingehende Nachricht',
        'Outgoing message' => 'Ausgehende Nachricht',
        'Internal message' => 'Interne Nachricht',
        'Resize' => 'Größe anpassen',

        # Template: AttachmentBlocker
        'To protect your privacy, remote content was blocked.' => 'Zum Schutz Ihrer Privatsphäre wurden entfernte Inhalte blockiert.',
        'Load blocked content.' => 'Blockierte Inhalte laden.',

        # Template: Copyright

        # Template: CustomerAccept

        # Template: CustomerError
        'Traceback' => 'Traceback',

        # Template: CustomerFooter
        'Powered by' => 'Powered by',
        'One or more errors occurred!' => 'Ein oder mehrere Fehler sind aufgetreten!',
        'Close this dialog' => 'Diesen Dialog schließen',
        'Could not open popup window. Please disable any popup blockers for this application.' =>
            'Konnte Popup-Fenster nicht öffnen. Bitte deaktivieren Sie alle Popup-Blocker für diese Anwendung.',

        # Template: CustomerFooterSmall

        # Template: CustomerHeader

        # Template: CustomerHeaderSmall

        # Template: CustomerLogin
        'JavaScript Not Available' => 'JavaScript nicht aktiviert oder nicht unterstützt.',
        'In order to experience OTRS, you\'ll need to enable JavaScript in your browser.' =>
            'Um alle Möglichkeiten von OTRS voll ausschöpfen zu können, müssen Sie JavaScript in Ihrem Browser aktivieren.',
        'Browser Warning' => 'Browser-Warnung',
        'The browser you are using is too old.' => 'Sie verwenden leider einen (stark) veralteten Browser.',
        'OTRS runs with a huge lists of browsers, please upgrade to one of these.' =>
            'OTRS funktioniert mit einer großen Auswahl an Browsern, aus denen Sie wählen können. Bitte installieren Sie einen neueren Browser oder upgraden Sie Ihren vorhandenen.',
        'Please see the documentation or ask your admin for further information.' =>
            'Bitte lesen Sie auch die Dokumentation oder fragen Sie Ihren Systemadministrator.',
        'Login' => 'Anmeldung',
        'User name' => 'Benutzername',
        'Your user name' => 'Ihr Benutzername',
        'Your password' => 'Ihr Passwort',
        'Forgot password?' => 'Passwort vergessen?',
        'Log In' => 'Anmelden',
        'Not yet registered?' => 'Noch nicht registriert?',
        'Sign up now' => 'Registrieren Sie sich jetzt',
        'Request new password' => 'Neues Passwort beantragen',
        'Your User Name' => 'Ihr Benutzername',
        'A new password will be sent to your email address.' => 'Ein neues Passwort wird an Ihre E-Mail-Adresse gesendet.',
        'Create Account' => 'Konto erstellen',
        'Please fill out this form to receive login credentials.' => 'Bitte füllen Sie dieses Formular aus, um Ihre Anmeldedaten zu erhalten.',
        'How we should address you' => 'Wie sollen wir Sie ansprechen?',
        'Your First Name' => 'Ihr Vorname',
        'Your Last Name' => 'Ihr Nachname',
        'Your email address (this will become your username)' => 'Ihre E-Mail-Adresse (das wird Ihr Benutzername)',

        # Template: CustomerNavigationBar
        'Edit personal preferences' => 'Persönliche Einstellungen vornehmen',
        'Logout %s' => '%s abmelden',

        # Template: CustomerPreferences

        # Template: CustomerRichTextEditor

        # Template: CustomerTicketMessage
        'Service level agreement' => 'Service-Level-Vereinbarung',

        # Template: CustomerTicketOverview
        'Welcome!' => 'Willkommen!',
        'Please click the button below to create your first ticket.' => 'Bitte verwenden Sie den Knopf unten zur Erstellung Ihres ersten Tickets.',
        'Create your first ticket' => 'Ihr erstes Ticket erstellen',

        # Template: CustomerTicketPrint
        'Ticket Print' => 'Ticket-Druckansicht',

        # Template: CustomerTicketSearch
        'Profile' => 'Profil',
        'e. g. 10*5155 or 105658*' => 'z. B. 10*5155 oder 105658*',
        'Fulltext search in tickets (e. g. "John*n" or "Will*")' => 'Volltextsuche in Tickets (z. B. "Max*" oder "Muster*")',
        'Recipient' => 'Empfänger',
        'Carbon Copy' => 'Kopie an',
        'Time restrictions' => 'Zeitbeschränkungen',
        'No time settings' => 'Keine Zeiteinstellungen',
        'Only tickets created' => 'Nur Tickets, die erstellt wurden',
        'Only tickets created between' => 'Nur Tickets, die erstellt wurden zwischen',
        'Ticket archive system' => 'Ticket-Archivsystem',
        'Save search as template?' => 'Suche als Vorlage speichern?',
        'Save as Template?' => 'Als Vorlage speichern?',
        'Save as Template' => 'Als Vorlage speichern',
        'Template Name' => 'Name der Vorlage',
        'Pick a profile name' => 'Profilnamen auswählen',
        'Output to' => 'Ausgabe nach',

        # Template: CustomerTicketSearchOpenSearchDescription

        # Template: CustomerTicketSearchResultPrint

        # Template: CustomerTicketSearchResultShort
        'of' => 'von',
        'Page' => 'Seite',
        'Search Results for' => 'Suchergebnisse für',

        # Template: CustomerTicketZoom
        'Show  article' => 'Artikel anzeigen',
        'Expand article' => 'Artikel aufklappen',
        'Information' => 'Information',
        'Next Steps' => 'Nächste Schritte',
        'Reply' => 'Antworten',

        # Template: CustomerWarning

        # Template: Datepicker
        'Invalid date (need a future date)!' => 'Ungültiges Datum (benötige Datum in der Zukunft)!',
        'Previous' => 'Zurück',
        'Sunday' => 'Sonntag',
        'Monday' => 'Montag',
        'Tuesday' => 'Dienstag',
        'Wednesday' => 'Mittwoch',
        'Thursday' => 'Donnerstag',
        'Friday' => 'Freitag',
        'Saturday' => 'Samstag',
        'Su' => 'So',
        'Mo' => 'Mo',
        'Tu' => 'Di',
        'We' => 'Mi',
        'Th' => 'Do',
        'Fr' => 'Fr',
        'Sa' => 'Sa',
        'Open date selection' => 'Datumsauswahl öffnen',

        # Template: Error
        'Oops! An Error occurred.' => 'Hoppla. Es ist ein Fehler aufgetreten.',
        'Error Message' => 'Fehlermeldung',
        'You can' => 'Sie können',
        'Send a bugreport' => 'einen Fehlerbericht senden',
        'go back to the previous page' => 'zurück zur vorhergehenden Seite',
        'Error Details' => 'Fehlerdetails',

        # Template: Footer
        'Top of page' => 'Zum Anfang der Seite',

        # Template: FooterJS
        'If you now leave this page, all open popup windows will be closed, too!' =>
            'Wenn Sie diese Seite verlassen, werden auch alle geöffneten Dialoge geschlossen!',
        'A popup of this screen is already open. Do you want to close it and load this one instead?' =>
            'Auf diesem Bildschirm ist bereits ein Popup-Fenster geöffnet. Möchten Sie dieses schließen und dieses stattdessen öffnen?',
        'Please enter at least one search value or * to find anything.' =>
            'Bitte geben Sie zumindest einen Suchbegriff ein oder * um nach Allem zu suchen.',

        # Template: FooterSmall

        # Template: HTMLHead

        # Template: HTMLHeadBlockEvents

        # Template: Header
        'Fulltext search' => 'Volltextsuche',
        'CustomerID Search' => 'Kunden-Nr.-Suche',
        'CustomerUser Search' => 'Kunden-Login-Suche',
        'You are logged in as' => 'Angemeldet als',

        # Template: HeaderSmall

        # Template: Installer
        'JavaScript not available' => 'JavaScript nicht aktiviert oder nicht unterstützt.',
        'Database Settings' => 'Datenbankeinstellungen',
        'General Specifications and Mail Settings' => 'Allgemeine Einstellungen und E-Mail-Einstellungen',
        'Registration' => 'Registrierung',
        'Welcome to %s' => 'Willkommen zu %s',
        'Web site' => 'Website',
        'Database check successful.' => 'Datenbankprüfung erfolgreich.',
        'Mail check successful.' => 'Konfigurationsprüfung erfolgreich.',
        'Error in the mail settings. Please correct and try again.' => 'Fehler in der Mail-Konfiguration. Bitte korrigieren und nochmals probieren.',

        # Template: InstallerConfigureMail
        'Configure Outbound Mail' => 'Mailversand konfigurieren',
        'Outbound mail type' => 'Typ der ausgehenden E-Mail',
        'Select outbound mail type.' => 'Typ der ausgehenden E-Mail auswählen',
        'Outbound mail port' => 'Port der ausgehenden E-Mail',
        'Select outbound mail port.' => 'Port der ausgehenden E-Mail auswählen',
        'SMTP host' => 'SMTP-Host',
        'SMTP host.' => 'SMTP-Host.',
        'SMTP authentication' => 'SMPT-Authentifizierung',
        'Does your SMTP host need authentication?' => 'Benötigt der SMTP-Host eine Authentifizierung?',
        'SMTP auth user' => 'Benutzer für SMTP-Authentifizierung',
        'Username for SMTP auth.' => 'Benutzername für SMTP-Authentifizierung.',
        'SMTP auth password' => 'Passwort für SMTP-Authentifizierung',
        'Password for SMTP auth.' => 'Passwort für SMTP-Authentifizierung.',
        'Configure Inbound Mail' => 'Mailempfang konfigurieren',
        'Inbound mail type' => 'Typ der eingehenden E-Mail',
        'Select inbound mail type.' => 'Typ der eingehenden E-Mail auswählen',
        'Inbound mail host' => 'Host der eingehenden E-Mail',
        'Inbound mail host.' => 'Host der eingehenden E-Mail.',
        'Inbound mail user' => 'Benutzer der eingehenden E-Mail',
        'User for inbound mail.' => 'Benutzername der eingehenden E-Mail',
        'Inbound mail password' => 'Passwort der eingehenden E-Mail',
        'Password for inbound mail.' => 'Passwort der eingehenden E-Mail.',
        'Result of mail configuration check' => 'Ergebnis der E-Mail-Konfigurationsprüfung',
        'Check mail configuration' => 'E-Mail-Konfiguration prüfen',
        'Skip this step' => 'Diesen Schritt überspringen',
        'Skipping this step will automatically skip the registration of your OTRS. Are you sure you want to continue?' =>
            'Wenn Sie diesen Schritt überspringen, wird die Registrierung Ihres OTRS-Systems ebenfalls übersprungen. Möchten Sie wirklich fortfahren?',

        # Template: InstallerDBResult
        'False' => 'Falsch',

        # Template: InstallerDBStart
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty. For security reasons we do recommend setting a root password. For more information please refer to your database documentation.' =>
            'Falls ein Root-Passwort für die Datenbank gesetzt ist, muss es hier eingegeben werden. Ist kein Passwort gesetzt, muss das Feld leer gelassen werden. Aus Sicherheitsgründen empfehlen wir ein Root-Passwort zu setzen. Weitere Informationen hierzu finden Sie in der Dokumentation Ihrer Datenbank.',
        'Currently only MySQL is supported in the web installer.' => 'Momentan wird nur MySQL bei der Web-Installation unterstützt.',
        'If you want to install OTRS on another database type, please refer to the file README.database.' =>
            'Wenn Sie OTRS auf einer anderen Datenbank installieren möchten, lesen Sie bitte die Datei README.database.',
        'Database-User' => 'Benutzername der Datenbank',
        'New' => 'Neu',
        'A new database user with limited rights will be created for this OTRS system.' =>
            'Ein neuer Datenbank-Benutzer mit beschränkten Rechten wird für dieses OTRS-System erstellt.',
        'default \'hot\'' => 'voreingestellt \'hot\'',
        'DB host' => 'Datenbank-Host',
        'Check database settings' => 'Datenbankeinstellungen prüfen',
        'Result of database check' => 'Ergebnis der Datenbankprüfung',

        # Template: InstallerFinish
        'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' =>
            'Um OTRS nutzen zu können, müssen die die folgenden Zeilen als root in die Befehlszeile (Terminal/Shell) eingeben.',
        'Restart your webserver' => 'Starten Sie ihren Webserver neu.',
        'After doing so your OTRS is up and running.' => 'Danach ist OTRS startklar.',
        'Start page' => 'Startseite',
        'Your OTRS Team' => 'Ihr OTRS-Team',

        # Template: InstallerLicense
        'Accept license' => 'Lizenz akzeptieren',
        'Don\'t accept license' => 'Lizenz _nicht_ akzeptieren',

        # Template: InstallerLicenseText

        # Template: InstallerRegistration
        'Organization' => 'Organisation',
        'Position' => 'Position',
        'Complete registration and continue' => 'Registrierung abschließen und fortfahren',
        'Please fill in all fields marked as mandatory.' => 'Bitte füllen Sie alle Pflichtfelder aus.',

        # Template: InstallerSystem
        'SystemID' => 'SystemID',
        'The identifier of the system. Each ticket number and each HTTP session ID contain this number.' =>
            'Der System-Identifizierer. Jede Ticketnummer und jede HTTP-Sitzungs-ID enthalten diese Nummer.',
        'System FQDN' => 'System FQDN',
        'Fully qualified domain name of your system.' => 'Voll qualifizierter Domainname Ihres Systems.',
        'AdminEmail' => 'E-Mail des Administrators',
        'Email address of the system administrator.' => 'E-Mail-Adresse des Administrators.',
        'Log' => 'Protokoll',
        'LogModule' => 'Protokollmodul',
        'Log backend to use.' => 'Protokoll-Backend, welches verwendet werden soll.',
        'LogFile' => 'Protokolldatei',
        'Log file location is only needed for File-LogModule!' => 'Die Angabe der Protokolldatei wird nur für das File-Log-Backend benötigt.',
        'Webfrontend' => 'Web-Oberfläche',
        'Default language' => 'Standardsprache',
        'Default language.' => 'Standardsprache.',
        'CheckMXRecord' => 'MX-Records prüfen',
        'Email addresses that are manually entered are checked against the MX records found in DNS. Don\'t use this option if your DNS is slow or does not resolve public addresses.' =>
            'E-Mail-Adressen, die vom Benutzer angegeben werden, werden gegen die MX-Einträge im DNS geprüft. Verwenden Sie diese Option nicht, wenn Ihr DNS langsam ist oder öffentliche Adressen nicht auflösen kann.',

        # Template: LinkObject
        'Object#' => 'Objektnummer',
        'Add links' => 'Verknüpfungen hinzufügen',
        'Delete links' => 'Verknüpfungen löschen',

        # Template: Login
        'Lost your password?' => 'Passwort verloren?',
        'Request New Password' => 'Neues Passwort anfordern',
        'Back to login' => 'Zurück zur Anmeldung',

        # Template: Motd
        'Message of the Day' => 'Nachricht des Tages',

        # Template: NoPermission
        'Insufficient Rights' => 'Nicht ausreichende Rechte',
        'Back to the previous page' => 'Zurück zur vorhergehenden Seite',

        # Template: Notify

        # Template: Pagination
        'Show first page' => 'Erste Seite anzeigen',
        'Show previous pages' => 'Vorige Seiten anzeigen',
        'Show page %s' => 'Seite %s anzeigen',
        'Show next pages' => 'Nächste Seiten anzeigen',
        'Show last page' => 'Letzte Seite anzeigen',

        # Template: PictureUpload
        'Need FormID!' => 'FormID benötigt!',
        'No file found!' => 'Keine Datei gefunden!',
        'The file is not an image that can be shown inline!' => 'Diese Datei ist kein Bild, das inline angezeigt werden kann!',

        # Template: PrintFooter
        'URL' => 'URL',

        # Template: PrintHeader
        'printed by' => 'gedruckt von',

        # Template: PublicDefault

        # Template: Redirect

        # Template: RichTextEditor

        # Template: SpellingInline

        # Template: Test
        'OTRS Test Page' => 'OTRS Testseite',
        'Welcome %s' => 'Willkommen %s',
        'Counter' => 'Zähler',

        # Template: Warning
        'Go back to the previous page' => 'Zurück zur vorhergehenden Seite',

        # SysConfig
        '"Slim" Skin which tries to save screen space for power users.' =>
            '',
        'ACL module that allows closing parent tickets only if all its children are already closed ("State" shows which states are not available for the parent ticket until all child tickets are closed).' =>
            '',
        'AccountedTime' => 'Erfasste Zeit',
        'Activates a blinking mechanism of the queue that contains the oldest ticket.' =>
            '',
        'Activates lost password feature for agents, in the agent interface.' =>
            '',
        'Activates lost password feature for customers.' => '',
        'Activates support for customer groups.' => '',
        'Activates the article filter in the zoom view to specify which articles should be shown.' =>
            '',
        'Activates the available themes on the system. Value 1 means active, 0 means inactive.' =>
            '',
        'Activates the ticket archive system search in the customer interface.' =>
            '',
        'Activates the ticket archive system to have a faster system by moving some tickets out of the daily scope. To search for these tickets, the archive flag has to be enabled in the ticket search.' =>
            '',
        'Activates time accounting.' => '',
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
        'Agent Notifications' => 'Agenten-Benachrichtigungen',
        'Agent interface article notification module to check PGP.' => '',
        'Agent interface article notification module to check S/MIME.' =>
            '',
        'Agent interface module to access CIC search via nav bar.' => '',
        'Agent interface module to access fulltext search via nav bar.' =>
            '',
        'Agent interface module to access search profiles via nav bar.' =>
            '',
        'Agent interface module to check incoming emails in the Ticket-Zoom-View if the S/MIME-key is available and true.' =>
            '',
        'Agent interface notification module to check the used charset.' =>
            '',
        'Agent interface notification module to see the number of tickets an agent is responsible for.' =>
            '',
        'Agent interface notification module to see the number of watched tickets.' =>
            '',
        'Agents <-> Groups' => 'Agent <-> Gruppen',
        'Agents <-> Roles' => 'Agent <-> Rollen',
        'All customer users of a CustomerID' => 'Alle Kundenbenutzer einer Kundennummer',
        'Allows adding notes in the close ticket screen of the agent interface.' =>
            '',
        'Allows adding notes in the ticket free text screen of the agent interface.' =>
            '',
        'Allows adding notes in the ticket note screen of the agent interface.' =>
            '',
        'Allows adding notes in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Allows adding notes in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Allows adding notes in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Allows adding notes in the ticket responsible screen of the agent interface.' =>
            '',
        'Allows agents to exchange the axis of a stat if they generate one.' =>
            '',
        'Allows agents to generate individual-related stats.' => '',
        'Allows choosing between showing the attachments of a ticket in the browser (inline) or just make them downloadable (attachment).' =>
            '',
        'Allows choosing the next compose state for customer tickets in the customer interface.' =>
            '',
        'Allows customers to change the ticket priority in the customer interface.' =>
            '',
        'Allows customers to set the ticket SLA in the customer interface.' =>
            '',
        'Allows customers to set the ticket priority in the customer interface.' =>
            '',
        'Allows customers to set the ticket queue in the customer interface. If this is set to \'No\', QueueDefault should be configured.' =>
            '',
        'Allows customers to set the ticket service in the customer interface.' =>
            '',
        'Allows customers to set the ticket type in the customer interface. If this is set to \'No\', TicketTypeDefault should be configured.' =>
            '',
        'Allows default services to be selected also for non existing customers.' =>
            '',
        'Allows defining new types for ticket (if ticket type feature is enabled).' =>
            '',
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
        'Allows the administrators to login as other customers, via the customer user administration panel.' =>
            '',
        'Allows the administrators to login as other users, via the users administration panel.' =>
            '',
        'Allows to set a new ticket state in the move ticket screen of the agent interface.' =>
            '',
        'ArticleTree' => 'Artikelbaum',
        'Attachments <-> Responses' => 'Anlagen <-> Antworten',
        'Auto Responses <-> Queues' => 'Auto-Antworten <-> Queues',
        'Automated line break in text messages after x number of chars.' =>
            '',
        'Automatically lock and set owner to current Agent after selecting for an Bulk Action.' =>
            '',
        'Automatically sets the owner of a ticket as the responsible for it (if ticket responsible feature is enabled).' =>
            '',
        'Automatically sets the responsible of a ticket (if it is not set yet) after the first owner update.' =>
            '',
        'Balanced white skin by Felix Niklas.' => '',
        'Basic fulltext index settings. Execute "bin/otrs.RebuildFulltextIndex.pl" in order to generate a new index.' =>
            '',
        'Blocks all the incoming emails that do not have a valid ticket number in subject with From: @example.com address.' =>
            '',
        'Builds an article index right after the article\'s creation.' =>
            '',
        'CMD example setup. Ignores emails where external CMD returns some output on STDOUT (email will be piped into STDIN of some.bin).' =>
            '',
        'Cache time in seconds for agent authentication in the GenericInterface.' =>
            '',
        'Cache time in seconds for customer authentication in the GenericInterface.' =>
            '',
        'Cache time in seconds for the DB process backend.' => '',
        'Cache time in seconds for the ticket process navigation bar output module.' =>
            '',
        'Cache time in seconds for the web service config backend.' => '',
        'Change password' => 'Passwort ändern',
        'Change queue!' => 'Queue ändern',
        'Change the customer for this ticket' => 'Ticket-Kunden ändern',
        'Change the free fields for this ticket' => 'Freie Felder des Tickets ändern',
        'Change the priority for this ticket' => 'Priorität des Tickets ändern',
        'Change the responsible person for this ticket' => 'Verantwortlichen des Tickets ändern',
        'Changes the owner of tickets to everyone (useful for ASP). Normally only agent with rw permissions in the queue of the ticket will be shown.' =>
            '',
        'Checkbox' => '',
        'Checks the SystemID in ticket number detection for follow-ups (use "No" if SystemID has been changed after using the system).' =>
            '',
        'Closed tickets of customer' => 'Geschlossene Tickets des Kunden',
        'Comment for new history entries in the customer interface.' => '',
        'Company Status' => 'Firmenstatus',
        'Company Tickets' => 'Firmen-Tickets',
        'Company name for the customer web interface. Will also be included in emails as an X-Header.' =>
            '',
        'Configure Processes.' => '',
        'Configure your own log text for PGP.' => '',
        'Configures a default TicketDynmicField setting. "Name" defines the dynamic field which should be used, "Value" is the data that will be set, and "Event" defines the trigger event. Please check the developer manual (http://doc.otrs.org/), chapter "Ticket Event Module".' =>
            '',
        'Controls if customers have the ability to sort their tickets.' =>
            '',
        'Controls if more than one from entry can be set in the new phone ticket in the agent interface.' =>
            '',
        'Controls if the ticket and article seen flags are removed when a ticket is archived.' =>
            '',
        'Converts HTML mails into text messages.' => '',
        'Create New process ticket' => '',
        'Create and manage Service Level Agreements (SLAs).' => 'Service-Level-Abkommen (SLAs) erzeugen und verwalten.',
        'Create and manage agents.' => 'Agents erzeugen und verwalten.',
        'Create and manage attachments.' => 'Anlagen erzeugen und verwalten.',
        'Create and manage companies.' => 'Unternehmen erzeugen und verwalten.',
        'Create and manage customers.' => 'Kunden erzeugen und verwalten.',
        'Create and manage dynamic fields.' => 'Dynamische Felder erzeugen und verwalten.',
        'Create and manage event based notifications.' => 'Ereignisbasierte Benachrichtigungen erzeugen und verwalten.',
        'Create and manage groups.' => 'Gruppen erzeugen und verwalten.',
        'Create and manage queues.' => 'Queues erzeugen und verwalten.',
        'Create and manage response templates.' => 'Antwort-Vorlagen erzeugen und verwalten.',
        'Create and manage responses that are automatically sent.' => 'Vorlagen für automatische Antworten erzeugen und verwalten.',
        'Create and manage roles.' => 'Rollen erzeugen und verwalten.',
        'Create and manage salutations.' => 'Anreden erzeugen und verwalten.',
        'Create and manage services.' => 'Services erzeugen und verwalten.',
        'Create and manage signatures.' => 'Signaturen erzeugen und verwalten.',
        'Create and manage ticket priorities.' => 'Ticket-Prioritäten erzeugen und verwalten.',
        'Create and manage ticket states.' => 'Ticket-Status  erzeugen und verwalten.',
        'Create and manage ticket types.' => 'Ticket-Typen erzeugen und verwalten.',
        'Create and manage web services.' => '',
        'Create new email ticket and send this out (outbound)' => 'Neues E-Mail-Ticket erzeugen und versenden (ausgehend)',
        'Create new phone ticket (inbound)' => 'Neues Telefonticket erstellen (eingehend)',
        'Custom text for the page shown to customers that have no tickets yet.' =>
            '',
        'Customer Company Administration' => '',
        'Customer Company Information' => 'Informationen zur Kunden-Firma',
        'Customer User Administration' => '',
        'Customer Users' => 'Kunden-Benutzer',
        'Customer item (icon) which shows the closed tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            '',
        'Customer item (icon) which shows the open tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            '',
        'CustomerName' => 'Kundenname',
        'Customers <-> Groups' => 'Kunden <-> Gruppen',
        'Customers <-> Services' => 'Kunden <-> Services',
        'Data used to export the search result in CSV format.' => '',
        'Date / Time' => 'Datum / Zeit',
        'Debugs the translation set. If this is set to "Yes" all strings (text) without translations are written to STDERR. This can be helpful when you are creating a new translation file. Otherwise, this option should remain set to "No".' =>
            '',
        'Default ACL values for ticket actions.' => '',
        'Default ProcessManagement entity prefixes for entity IDs that are automatically generated.' =>
            '',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimePointFormat=year;TicketCreateTimePointStart=Last;TicketCreateTimePoint=2;".' =>
            '',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimeStartYear=2010;TicketCreateTimeStartMonth=10;TicketCreateTimeStartDay=4;TicketCreateTimeStopYear=2010;TicketCreateTimeStopMonth=11;TicketCreateTimeStopDay=3;".' =>
            '',
        'Default loop protection module.' => '',
        'Default queue ID used by the system in the agent interface.' => '',
        'Default skin for OTRS 3.0 interface.' => '',
        'Default skin for interface.' => '',
        'Default ticket ID used by the system in the agent interface.' =>
            '',
        'Default ticket ID used by the system in the customer interface.' =>
            '',
        'Default value for NameX' => '',
        'Define a filter for html output to add links behind a defined string. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            '',
        'Define the max depth of queues.' => '',
        'Define the start day of the week for the date picker.' => '',
        'Defines a customer item, which generates a LinkedIn icon at the end of a customer info block.' =>
            '',
        'Defines a customer item, which generates a XING icon at the end of a customer info block.' =>
            '',
        'Defines a customer item, which generates a google icon at the end of a customer info block.' =>
            '',
        'Defines a customer item, which generates a google maps icon at the end of a customer info block.' =>
            '',
        'Defines a default list of words, that are ignored by the spell checker.' =>
            '',
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
        'Defines all the X-headers that should be scanned.' => '',
        'Defines all the languages that are available to the application. The Key/Content pair links the front-end display name to the appropriate language PM file. The "Key" value should be the base-name of the PM file (i.e. de.pm is the file, then de is the "Key" value). The "Content" value should be the display name for the front-end. Specify any own-defined language here (see the developer documentation http://doc.otrs.org/ for more infomation). Please remember to use the HTML equivalents for non-ASCII characters (i.e. for the German oe = o umlaut, it is necessary to use the &ouml; symbol).' =>
            '',
        'Defines all the parameters for the RefreshTime object in the customer preferences of the customer interface.' =>
            '',
        'Defines all the parameters for the ShownTickets object in the customer preferences of the customer interface.' =>
            '',
        'Defines all the parameters for this item in the customer preferences.' =>
            '',
        'Defines all the possible stats output formats.' => '',
        'Defines an alternate URL, where the login link refers to.' => '',
        'Defines an alternate URL, where the logout link refers to.' => '',
        'Defines an alternate login URL for the customer panel..' => '',
        'Defines an alternate logout URL for the customer panel.' => '',
        'Defines an external link to the database of the customer (e.g. \'http://yourhost/customer.php?CID=$Data{"CustomerID"}\' or \'\').' =>
            '',
        'Defines from which ticket attributes the agent can select the result order.' =>
            '',
        'Defines how the From field from the emails (sent from answers and email tickets) should look like.' =>
            '',
        'Defines if a pre-sorting by priority should be done in the queue view.' =>
            '',
        'Defines if a ticket lock is required in the close ticket screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
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
            '',
        'Defines if the enhanced mode should be used (enables use of table, replace, subscript, superscript, paste from word, etc.).' =>
            '',
        'Defines if time accounting is mandatory in the agent interface.' =>
            '',
        'Defines if time accounting must be set to all tickets in bulk action.' =>
            '',
        'Defines scheduler PID update time in seconds (floating point number).' =>
            '',
        'Defines scheduler sleep time in seconds after processing all available tasks (floating point number).' =>
            '',
        'Defines the IP regular expression for accessing the local repository. You need to enable this to have access to your local repository and the package::RepositoryList is required on the remote host.' =>
            '',
        'Defines the URL CSS path.' => '',
        'Defines the URL base path of icons, CSS and Java Script.' => '',
        'Defines the URL image path of icons for navigation.' => '',
        'Defines the URL java script path.' => '',
        'Defines the URL rich text editor path.' => '',
        'Defines the address of a dedicated DNS server, if necessary, for the "CheckMXRecord" look-ups.' =>
            '',
        'Defines the body text for notification mails sent to agents, about new password (after using this link the new password will be sent).' =>
            '',
        'Defines the body text for notification mails sent to agents, with token about new requested password (after using this link the new password will be sent).' =>
            '',
        'Defines the body text for notification mails sent to customers, about new account.' =>
            '',
        'Defines the body text for notification mails sent to customers, about new password (after using this link the new password will be sent).' =>
            '',
        'Defines the body text for notification mails sent to customers, with token about new requested password (after using this link the new password will be sent).' =>
            '',
        'Defines the body text for rejected emails.' => '',
        'Defines the boldness of the line drawed by the graph.' => '',
        'Defines the colors for the graphs.' => '',
        'Defines the column to store the keys for the preferences table.' =>
            '',
        'Defines the config parameters of this item, to be shown in the preferences view.' =>
            '',
        'Defines the config parameters of this item, to be shown in the preferences view. Take care to maintain the dictionaries installed in the system in the data section.' =>
            '',
        'Defines the connections for http/ftp, via a proxy.' => '',
        'Defines the date input format used in forms (option or input fields).' =>
            '',
        'Defines the default CSS used in rich text editors.' => '',
        'Defines the default auto response type of the article for this operation.' =>
            '',
        'Defines the default body of a note in the ticket free text screen of the agent interface.' =>
            '',
        'Defines the default front-end (HTML) theme to be used by the agents and customers. The default themes are Standard and Lite. If you like, you can add your own theme. Please refer the administrator manual located at http://doc.otrs.org/.' =>
            '',
        'Defines the default front-end language. All the possible values are determined by the available language files on the system (see the next setting).' =>
            '',
        'Defines the default history type in the customer interface.' => '',
        'Defines the default maximum number of X-axis attributes for the time scale.' =>
            '',
        'Defines the default maximum number of search results shown on the overview page.' =>
            '',
        'Defines the default next state for a ticket after customer follow up in the customer interface.' =>
            '',
        'Defines the default next state of a ticket after adding a note, in the close ticket screen of the agent interface.' =>
            '',
        'Defines the default next state of a ticket after adding a note, in the ticket bulk screen of the agent interface.' =>
            '',
        'Defines the default next state of a ticket after adding a note, in the ticket free text screen of the agent interface.' =>
            '',
        'Defines the default next state of a ticket after adding a note, in the ticket note screen of the agent interface.' =>
            '',
        'Defines the default next state of a ticket after adding a note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the default next state of a ticket after adding a note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the default next state of a ticket after adding a note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the default next state of a ticket after adding a note, in the ticket responsible screen of the agent interface.' =>
            '',
        'Defines the default next state of a ticket after being bounced, in the ticket bounce screen of the agent interface.' =>
            '',
        'Defines the default next state of a ticket after being forwarded, in the ticket forward screen of the agent interface.' =>
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
            '',
        'Defines the default priority of new tickets.' => '',
        'Defines the default queue for new customer tickets in the customer interface.' =>
            '',
        'Defines the default selection at the drop down menu for dynamic objects (Form: Common Specification).' =>
            '',
        'Defines the default selection at the drop down menu for permissions (Form: Common Specification).' =>
            '',
        'Defines the default selection at the drop down menu for stats format (Form: Common Specification). Please insert the format key (see Stats::Format).' =>
            '',
        'Defines the default sender type for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Defines the default sender type for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            '',
        'Defines the default sender type for tickets in the ticket zoom screen of the customer interface.' =>
            '',
        'Defines the default shown ticket search attribute for ticket search screen.' =>
            '',
        'Defines the default shown ticket search attribute for ticket search screen. Example: a text, 1, Search_DynamicField_Field1StartYear=2002; Search_DynamicField_Field1StartMonth=12; Search_DynamicField_Field1StartDay=12; Search_DynamicField_Field1StartHour=00; Search_DynamicField_Field1StartMinute=00; Search_DynamicField_Field1StartSecond=00; Search_DynamicField_Field1StopYear=2009; Search_DynamicField_Field1StopMonth=02; Search_DynamicField_Field1StopDay=10; Search_DynamicField_Field1StopHour=23; Search_DynamicField_Field1StopMinute=59; Search_DynamicField_Field1StopSecond=59;.' =>
            '',
        'Defines the default sort criteria for all queues displayed in the queue view.' =>
            '',
        'Defines the default sort order for all queues in the queue view, after priority sort.' =>
            '',
        'Defines the default spell checker dictionary.' => '',
        'Defines the default state of new customer tickets in the customer interface.' =>
            '',
        'Defines the default state of new tickets.' => '',
        'Defines the default subject for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Defines the default subject for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            '',
        'Defines the default subject of a note in the ticket free text screen of the agent interface.' =>
            '',
        'Defines the default ticket attribute for ticket sorting in a ticket search of the customer interface.' =>
            '',
        'Defines the default ticket attribute for ticket sorting in the escalation view of the agent interface.' =>
            '',
        'Defines the default ticket attribute for ticket sorting in the locked ticket view of the agent interface.' =>
            '',
        'Defines the default ticket attribute for ticket sorting in the responsible view of the agent interface.' =>
            '',
        'Defines the default ticket attribute for ticket sorting in the status view of the agent interface.' =>
            '',
        'Defines the default ticket attribute for ticket sorting in the watch view of the agent interface.' =>
            '',
        'Defines the default ticket attribute for ticket sorting of the ticket search result of the agent interface.' =>
            '',
        'Defines the default ticket bounced notification for customer/sender in the ticket bounce screen of the agent interface.' =>
            '',
        'Defines the default ticket next state after adding a phone note in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Defines the default ticket next state after adding a phone note in the ticket phone outbound screen of the agent interface.' =>
            '',
        'Defines the default ticket order (after priority sort) in the escalation view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            '',
        'Defines the default ticket order (after priority sort) in the status view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            '',
        'Defines the default ticket order in the responsible view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            '',
        'Defines the default ticket order in the ticket locked view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            '',
        'Defines the default ticket order in the ticket search result of the agent interface. Up: oldest on top. Down: latest on top.' =>
            '',
        'Defines the default ticket order in the watch view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            '',
        'Defines the default ticket order of a search result in the customer interface. Up: oldest on top. Down: latest on top.' =>
            '',
        'Defines the default ticket priority in the close ticket screen of the agent interface.' =>
            '',
        'Defines the default ticket priority in the ticket bulk screen of the agent interface.' =>
            '',
        'Defines the default ticket priority in the ticket free text screen of the agent interface.' =>
            '',
        'Defines the default ticket priority in the ticket note screen of the agent interface.' =>
            '',
        'Defines the default ticket priority in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the default ticket priority in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the default ticket priority in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the default ticket priority in the ticket responsible screen of the agent interface.' =>
            '',
        'Defines the default ticket type for new customer tickets in the customer interface.' =>
            '',
        'Defines the default type for article in the customer interface.' =>
            '',
        'Defines the default type of forwarded message in the ticket forward screen of the agent interface.' =>
            '',
        'Defines the default type of the article for this operation.' => '',
        'Defines the default type of the note in the close ticket screen of the agent interface.' =>
            '',
        'Defines the default type of the note in the ticket bulk screen of the agent interface.' =>
            '',
        'Defines the default type of the note in the ticket free text screen of the agent interface.' =>
            '',
        'Defines the default type of the note in the ticket note screen of the agent interface.' =>
            '',
        'Defines the default type of the note in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the default type of the note in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the default type of the note in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Defines the default type of the note in the ticket phone outbound screen of the agent interface.' =>
            '',
        'Defines the default type of the note in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the default type of the note in the ticket responsible screen of the agent interface.' =>
            '',
        'Defines the default type of the note in the ticket zoom screen of the customer interface.' =>
            '',
        'Defines the default used Frontend-Module if no Action parameter given in the url on the agent interface.' =>
            '',
        'Defines the default used Frontend-Module if no Action parameter given in the url on the customer interface.' =>
            '',
        'Defines the default value for the action parameter for the public frontend. The action parameter is used in the scripts of the system.' =>
            '',
        'Defines the default viewable sender types of a ticket (default: customer).' =>
            '',
        'Defines the filter that processes the text in the articles, in order to highlight URLs.' =>
            '',
        'Defines the format of responses in the ticket compose screen of the agent interface ($QData{"OrigFrom"} is From 1:1, $QData{"OrigFromName"} is only realname of From).' =>
            '',
        'Defines the fully qualified domain name of the system. This setting is used as a variable, OTRS_CONFIG_FQDN which is found in all forms of messaging used by the application, to build links to the tickets within your system.' =>
            '',
        'Defines the groups every customer user will be in (if CustomerGroupSupport is enabled and you don\'t want to manage every user for these groups).' =>
            '',
        'Defines the height for the rich text editor component for this screen. Enter number (pixels) or percent value (relative).' =>
            '',
        'Defines the height for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            '',
        'Defines the height of the legend.' => '',
        'Defines the history comment for the close ticket screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the email ticket screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the phone ticket screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the ticket free text screen action, which gets used for ticket history.' =>
            '',
        'Defines the history comment for the ticket note screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the ticket owner screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the ticket pending screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the ticket phone inbound screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the ticket phone outbound screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the ticket priority screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the ticket responsible screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the ticket zoom action, which gets used for ticket history in the customer interface.' =>
            '',
        'Defines the history comment for this operation, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the close ticket screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the email ticket screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the phone ticket screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the ticket free text screen action, which gets used for ticket history.' =>
            '',
        'Defines the history type for the ticket note screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the ticket owner screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the ticket pending screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the ticket phone inbound screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the ticket phone outbound screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the ticket priority screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the ticket responsible screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the ticket zoom action, which gets used for ticket history in the customer interface.' =>
            '',
        'Defines the history type for this operation, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the hours and week days of the indicated calendar, to count the working time.' =>
            '',
        'Defines the hours and week days to count the working time.' => '',
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
        'Defines the location to get online repository list for additional packages. The first available result will be used.' =>
            '',
        'Defines the log module for the system. "File" writes all messages in a given logfile, "SysLog" uses the syslog daemon of the system, e.g. syslogd.' =>
            '',
        'Defines the maximal size (in bytes) for file uploads via the browser.' =>
            '',
        'Defines the maximal valid time (in seconds) for a session id.' =>
            '',
        'Defines the maximum length (in characters) for a scheduler task data. WARNING: Do not modify this setting unless you are sure of the current Database length for \'task_data\' filed from \'scheduler_data_list\' table.' =>
            '',
        'Defines the maximum number of pages per PDF file.' => '',
        'Defines the maximum size (in MB) of the log file.' => '',
        'Defines the module that shows a generic notification in the agent interface. Either "Text" - if configured - or the contents of "File" will be displayed.' =>
            '',
        'Defines the module that shows all the currently loged in customers in the agent interface.' =>
            '',
        'Defines the module that shows all the currently logged in agents in the agent interface.' =>
            '',
        'Defines the module that shows the currently loged in agents in the customer interface.' =>
            '',
        'Defines the module that shows the currently loged in customers in the customer interface.' =>
            '',
        'Defines the module to authenticate customers.' => '',
        'Defines the module to display a notification in the agent interface, (only for agents on the admin group) if the scheduler is not running.' =>
            '',
        'Defines the module to display a notification in the agent interface, if the agent is logged in while having out-of-office active.' =>
            '',
        'Defines the module to display a notification in the agent interface, if the system is used by the admin user (normally you shouldn\'t work as admin).' =>
            '',
        'Defines the module to generate html refresh headers of html sites, in the customer interface.' =>
            '',
        'Defines the module to generate html refresh headers of html sites.' =>
            '',
        'Defines the module to send emails. "Sendmail" directly uses the sendmail binary of your operating system. Any of the "SMTP" mechanisms use a specified (external) mailserver. "DoNotSendEmail" doesn\'t send emails and it is useful for test systems.' =>
            '',
        'Defines the module used to store the session data. With "DB" the frontend server can be splitted from the db server. "FS" is faster.' =>
            '',
        'Defines the name of the application, shown in the web interface, tabs and title bar of the web browser.' =>
            '',
        'Defines the name of the column to store the data in the preferences table.' =>
            '',
        'Defines the name of the column to store the user identifier in the preferences table.' =>
            '',
        'Defines the name of the indicated calendar.' => '',
        'Defines the name of the key for customer sessions.' => '',
        'Defines the name of the session key. E.g. Session, SessionID or OTRS.' =>
            '',
        'Defines the name of the table, where the customer preferences are stored.' =>
            '',
        'Defines the next possible states after composing / answering a ticket in the ticket compose screen of the agent interface.' =>
            '',
        'Defines the next possible states after forwarding a ticket in the ticket forward screen of the agent interface.' =>
            '',
        'Defines the next possible states for customer tickets in the customer interface.' =>
            '',
        'Defines the next state of a ticket after adding a note, in the close ticket screen of the agent interface.' =>
            '',
        'Defines the next state of a ticket after adding a note, in the ticket bulk screen of the agent interface.' =>
            '',
        'Defines the next state of a ticket after adding a note, in the ticket free text screen of the agent interface.' =>
            '',
        'Defines the next state of a ticket after adding a note, in the ticket note screen of the agent interface.' =>
            '',
        'Defines the next state of a ticket after adding a note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the next state of a ticket after adding a note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the next state of a ticket after adding a note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the next state of a ticket after adding a note, in the ticket responsible screen of the agent interface.' =>
            '',
        'Defines the next state of a ticket after being bounced, in the ticket bounce screen of the agent interface.' =>
            '',
        'Defines the next state of a ticket after being moved to another queue, in the move ticket screen of the agent interface.' =>
            '',
        'Defines the parameters for the customer preferences table.' => '',
        'Defines the parameters for the dashboard backend. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin.' =>
            '',
        'Defines the parameters for the dashboard backend. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" defines the cache expiration period in minutes for the plugin.' =>
            '',
        'Defines the parameters for the dashboard backend. "Limit" defines the number of entries displayed by default. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin.' =>
            '',
        'Defines the parameters for the dashboard backend. "Limit" defines the number of entries displayed by default. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" defines the cache expiration period in minutes for the plugin.' =>
            '',
        'Defines the password to access the SOAP handle (bin/cgi-bin/rpc.pl).' =>
            '',
        'Defines the path and TTF-File to handle bold italic monospaced font in PDF documents.' =>
            '',
        'Defines the path and TTF-File to handle bold italic proportional font in PDF documents.' =>
            '',
        'Defines the path and TTF-File to handle bold monospaced font in PDF documents.' =>
            '',
        'Defines the path and TTF-File to handle bold proportional font in PDF documents.' =>
            '',
        'Defines the path and TTF-File to handle italic monospaced font in PDF documents.' =>
            '',
        'Defines the path and TTF-File to handle italic proportional font in PDF documents.' =>
            '',
        'Defines the path and TTF-File to handle monospaced font in PDF documents.' =>
            '',
        'Defines the path and TTF-File to handle proportional font in PDF documents.' =>
            '',
        'Defines the path for scheduler to store its console output (SchedulerOUT.log and SchedulerERR.log).' =>
            '',
        'Defines the path of the shown info file, that is located under Kernel/Output/HTML/Standard/CustomerAccept.dtl.' =>
            '',
        'Defines the path to PGP binary.' => '',
        'Defines the path to open ssl binary. It may need a HOME env ($ENV{HOME} = \'/var/lib/wwwrun\';).' =>
            '',
        'Defines the placement of the legend. This should be a two letter key of the form: \'B[LCR]|R[TCB]\'. The first letter indicates the placement (Bottom or Right), and the second letter the alignment (Left, Right, Center, Top, or Bottom).' =>
            '',
        'Defines the postmaster default queue.' => '',
        'Defines the receipent target of the phone ticket and the sender of the email ticket ("Queue" shows all queues, "SystemAddress" displays all system addresses) in the agent interface.' =>
            '',
        'Defines the receipent target of the tickets ("Queue" shows all queues, "SystemAddress" displays all system addresses) in the customer interface.' =>
            '',
        'Defines the required permission to show a ticket in the escalation view of the agent interface.' =>
            '',
        'Defines the search limit for the stats.' => '',
        'Defines the sender for rejected emails.' => '',
        'Defines the separator between the agents real name and the given queue email address.' =>
            '',
        'Defines the spacing of the legends.' => '',
        'Defines the standard permissions available for customers within the application. If more permissions are needed, you can enter them here. Permissions must be hard coded to be effective. Please ensure, when adding any of the afore mentioned permissions, that the "rw" permission remains the last entry.' =>
            '',
        'Defines the standard size of PDF pages.' => '',
        'Defines the state of a ticket if it gets a follow-up and the ticket was already closed.' =>
            '',
        'Defines the state of a ticket if it gets a follow-up.' => '',
        'Defines the state type of the reminder for pending tickets.' => '',
        'Defines the subject for notification mails sent to agents, about new password.' =>
            '',
        'Defines the subject for notification mails sent to agents, with token about new requested password.' =>
            '',
        'Defines the subject for notification mails sent to customers, about new account.' =>
            '',
        'Defines the subject for notification mails sent to customers, about new password.' =>
            '',
        'Defines the subject for notification mails sent to customers, with token about new requested password.' =>
            '',
        'Defines the subject for rejected emails.' => '',
        'Defines the system administrator\'s email address. It will be displayed in the error screens of the application.' =>
            '',
        'Defines the system identifier. Every ticket number and http session string contain this ID. This ensures that only tickets which belong to your system will be processed as follow-ups (useful when communicating between two instances of OTRS).' =>
            '',
        'Defines the target attribute in the link to external customer database. E.g. \'AsPopup PopupType_TicketAction\'.' =>
            '',
        'Defines the target attribute in the link to external customer database. E.g. \'target="cdb"\'.' =>
            '',
        'Defines the time in days to keep log backup files.' => '',
        'Defines the time in seconds after which the Scheduler performs an automatic self-restart.' =>
            '',
        'Defines the time zone of the indicated calendar, which can be assigned later to a specific queue.' =>
            '',
        'Defines the type of protocol, used by ther web server, to serve the application. If https protocol will be used instead of plain http, it must be specified it here. Since this has no affect on the web server\'s settings or behavior, it will not change the method of access to the application and, if it is wrong, it will not prevent you from logging into the application. This setting is used as a variable, OTRS_CONFIG_HttpType which is found in all forms of messaging used by the application, to build links to the tickets within your system.' =>
            '',
        'Defines the used character for email quotes in the ticket compose screen of the agent interface.' =>
            '',
        'Defines the user identifier for the customer panel.' => '',
        'Defines the username to access the SOAP handle (bin/cgi-bin/rpc.pl).' =>
            '',
        'Defines the valid state types for a ticket.' => '',
        'Defines the valid states for unlocked tickets. To unlock tickets the script "bin/otrs.UnlockTickets.pl" can be used.' =>
            '',
        'Defines the viewable locks of a ticket. Default: unlock, tmp_lock.' =>
            '',
        'Defines the width for the rich text editor component for this screen. Enter number (pixels) or percent value (relative).' =>
            '',
        'Defines the width for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            '',
        'Defines the width of the legend.' => '',
        'Defines which article sender types should be shown in the preview of a ticket.' =>
            'Gibt an, welche Artikel-Sendertypen in der Vorschau eines Tickets angezeigt werden sollen.',
        'Defines which states should be set automatically (Content), after the pending time of state (Key) has been reached.' =>
            '',
        'Defines wich article type should be expanded when entering the overview. If nothing defined, latest article will be expanded.' =>
            'Gibt an, welcher Artikeltyp beim Öffnen der Übersichtsansicht aufgeklappt dargestellt werden soll. Wenn kein Typ angegeben ist, wird der neueste Artikel aufgeklappt dargestellt.',
        'Delay time between autocomplete queries in milliseconds.' => '',
        'Deletes a session if the session id is used with an invalid remote IP address.' =>
            '',
        'Deletes requested sessions if they have timed out.' => '',
        'Determines if the list of possible queues to move to ticket into should be displayed in a dropdown list or in a new window in the agent interface. If "New Window" is set you can add a move note to the ticket.' =>
            '',
        'Determines if the search results container for the autocomplete feature should adjust its width dynamically.' =>
            '',
        'Determines if the statistics module may generate ticket lists.' =>
            '',
        'Determines the next possible ticket states, after the creation of a new email ticket in the agent interface.' =>
            '',
        'Determines the next possible ticket states, after the creation of a new phone ticket in the agent interface.' =>
            '',
        'Determines the next possible ticket states, for process tickets in the agent interface.' =>
            '',
        'Determines the next screen after new customer ticket in the customer interface.' =>
            '',
        'Determines the next screen after the follow up screen of a zoomed ticket in the customer interface.' =>
            '',
        'Determines the next screen after the ticket is moved. LastScreenOverview will return the last overview screen (e.g. search results, queueview, dashboard). TicketZoom will return to the TicketZoom.' =>
            'Bestimmt das nächste Fenster nach dem das Ticket verschoben ist. LastScreenOverview wechselt zur letzten Übersichtsseite. TicketZoom wechselt zur Ticket Detailansicht.',
        'Determines the possible states for pending tickets that changed state after reaching time limit.' =>
            '',
        'Determines the strings that will be shown as receipent (To:) of the phone ticket and as sender (From:) of the email ticket in the agent interface. For Queue as NewQueueSelectionType "<Queue>" shows the names of the queues and for SystemAddress "<Realname> <<Email>>" shows the name and email of the receipent.' =>
            '',
        'Determines the strings that will be shown as receipent (To:) of the ticket in the customer interface. For Queue as CustomerPanelSelectionType, "<Queue>" shows the names of the queues, and for SystemAddress, "<Realname> <<Email>>" shows the name and email of the receipent.' =>
            '',
        'Determines the way the linked objects are displayed in each zoom mask.' =>
            '',
        'Determines which options will be valid of the recepient (phone ticket) and the sender (email ticket) in the agent interface.' =>
            '',
        'Determines which queues will be valid for ticket\'s recepients in the customer interface.' =>
            '',
        'Disables sending reminder notifications to the responsible agent of a ticket (Ticket::Responsible needs to be activated).' =>
            '',
        'Disables the web installer (http://yourhost.example.com/otrs/installer.pl), to prevent the system from being hijacked. If set to "No", the system can be reinstalled and the current basic configuration will be used to pre-populate the questions within the installer script. If not active, it also disables the GenericAgent, PackageManager and SQL Box.' =>
            '',
        'Display settings to override defaults for Process Tickets.' => '',
        'Displays the accounted time for an article in the ticket zoom view.' =>
            '',
        'Dropdown' => 'Einfachauswahl',
        'Dynamic Fields Checkbox Backend GUI' => '',
        'Dynamic Fields Date Time Backend GUI' => '',
        'Dynamic Fields Drop-down Backend GUI' => '',
        'Dynamic Fields GUI' => '',
        'Dynamic Fields Multiselect Backend GUI' => '',
        'Dynamic Fields Overview Limit' => '',
        'Dynamic Fields Text Backend GUI' => '',
        'Dynamic Fields used to export the search result in CSV format.' =>
            '',
        'Dynamic fields groups for process widget. The key is the name of the group, the value contains the fields to be shown. Example: \'Key => My Group\', \'Content: Name_X, NameY\'.' =>
            '',
        'Dynamic fields limit per page for Dynamic Fields Overview' => '',
        'Dynamic fields options shown in the ticket message screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required. NOTE. If you want to display these fields also in the ticket zoom of the customer interface, you have to enable them in CustomerTicketZoom###DynamicField.' =>
            '',
        'Dynamic fields options shown in the ticket reply section in the ticket zoom screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the process widget in ticket zoom screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'Dynamic fields shown in the sidebar of the ticket zoom screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'Dynamic fields shown in the ticket close screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket compose screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket email screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket forward screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket free text screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket medium format overview screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'Dynamic fields shown in the ticket move screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket note screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket overview screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket owner screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket pending screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket phone inbound screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket phone outbound screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket phone screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket preview format overview screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'Dynamic fields shown in the ticket print screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'Dynamic fields shown in the ticket print screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'Dynamic fields shown in the ticket priority screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket responsible screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket search overview results screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'Dynamic fields shown in the ticket search screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and shown by default.' =>
            '',
        'Dynamic fields shown in the ticket search screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'Dynamic fields shown in the ticket small format overview screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'Dynamic fields shown in the ticket zoom screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'DynamicField backend registration.' => '',
        'DynamicField object registration.' => '',
        'Edit customer company' => '',
        'Email Addresses' => 'E-Mail Adressen',
        'Enable keep-alive connection header for SOAP responses.' => '',
        'Enables PDF output. The CPAN module PDF::API2 is required, if not installed, PDF output will be disabled.' =>
            '',
        'Enables PGP support. When PGP support is enabled for signing and securing mail, it is HIGHLY recommended that the web server be run as the OTRS user. Otherwise, there will be problems with the privileges when accessing .gnupg folder.' =>
            '',
        'Enables S/MIME support.' => 'Aktiviert unterstützung für S/MIME.',
        'Enables customers to create their own accounts.' => '',
        'Enables file upload in the package manager frontend.' => '',
        'Enables or disable the debug mode over frontend interface.' => '',
        'Enables or disables the autocomplete feature for the customer search in the agent interface.' =>
            '',
        'Enables or disables the ticket watcher feature, to keep track of tickets without being the owner nor the responsible.' =>
            '',
        'Enables performance log (to log the page response time). It will affect the system performance. Frontend::Module###AdminPerformanceLog must be enabled.' =>
            '',
        'Enables spell checker support.' => '',
        'Enables ticket bulk action feature for the agent frontend to work on more than one ticket at a time.' =>
            '',
        'Enables ticket bulk action feature only for the listed groups.' =>
            '',
        'Enables ticket responsible feature, to keep track of a specific ticket.' =>
            '',
        'Enables ticket watcher feature only for the listed groups.' => '',
        'Escalation view' => 'Ansicht nach Eskalationen',
        'Event list to be displayed on GUI to trigger generic interface invokers.' =>
            '',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate).' =>
            '',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate). This is only possible if all Ticket dynamic fields need the same event.' =>
            '',
        'Execute SQL statements.' => 'Einen SQL-Befehl ausführen',
        'Executes follow up checks on In-Reply-To or References headers for mails that don\'t have a ticket number in the subject.' =>
            '',
        'Executes follow up mail attachments checks in  mails that don\'t have a ticket number in the subject.' =>
            '',
        'Executes follow up mail body checks in mails that don\'t have a ticket number in the subject.' =>
            '',
        'Executes follow up plain/raw mail checks in mails that don\'t have a ticket number in the subject.' =>
            '',
        'Exports the whole article tree in search result (it can affect the system performance).' =>
            '',
        'Fetches packages via proxy. Overwrites "WebUserAgent::Proxy".' =>
            '',
        'File that is displayed in the Kernel::Modules::AgentInfo module, if located under Kernel/Output/HTML/Standard/AgentInfo.dtl.' =>
            '',
        'Filter incoming emails.' => 'Eingehende E-Mails filtern.',
        'FirstLock' => 'Erstsperrzeit',
        'FirstResponse' => 'Erstantwortzeit',
        'FirstResponseDiffInMin' => 'Erstantwortzeitdifferenz in Minuten',
        'FirstResponseInMin' => 'Erstantwortzeit in Minuten',
        'Forces encoding of outgoing emails (7bit|8bit|quoted-printable|base64).' =>
            '',
        'Forces to choose a different ticket state (from current) after lock action. Define the current state as key, and the next state after lock action as content.' =>
            '',
        'Forces to unlock tickets after being moved to another queue.' =>
            '',
        'Frontend language' => 'Oberflächen-Sprache',
        'Frontend module registration (disable company link if no company feature is used).' =>
            '',
        'Frontend module registration (disable ticket processes screen if no process available).' =>
            '',
        'Frontend module registration for the agent interface.' => '',
        'Frontend module registration for the customer interface.' => '',
        'Frontend theme' => 'Oberflächen-Schema',
        'Fulltext index regex filters to remove parts of the text.' => '',
        'GenericAgent' => 'GenericAgent',
        'GenericInterface Debugger GUI' => '',
        'GenericInterface Invoker GUI' => '',
        'GenericInterface Operation GUI' => '',
        'GenericInterface TransportHTTPSOAP GUI' => '',
        'GenericInterface Web Service GUI' => '',
        'GenericInterface Webservice History GUI' => '',
        'GenericInterface Webservice Mapping GUI' => '',
        'GenericInterface module registration for the invoker layer.' => '',
        'GenericInterface module registration for the mapping layer.' => '',
        'GenericInterface module registration for the operation layer.' =>
            '',
        'GenericInterface module registration for the transport layer.' =>
            '',
        'Gives end users the possibility to override the separator character for CSV files, defined in the translation files.' =>
            '',
        'Grants access, if the customer ID of the ticket matches the customer user\'s ID and the customer user has group permissions on the queue the ticket is in.' =>
            '',
        'Helps to extend your articles full-text search (From, To, Cc, Subject and Body search). Runtime will do full-text searches on live data (it works fine for up to 50.000 tickets). StaticDB will strip all articles and will build an index after article creation, increasing fulltext searches about 50%. To create an initial index use "bin/otrs.RebuildFulltextIndex.pl".' =>
            '',
        'If "DB" was selected for Customer::AuthModule, a database driver (normally autodetection is used) can be specified.' =>
            '',
        'If "DB" was selected for Customer::AuthModule, a password to connect to the customer table can be specified.' =>
            '',
        'If "DB" was selected for Customer::AuthModule, a username to connect to the customer table can be specified.' =>
            '',
        'If "DB" was selected for Customer::AuthModule, the DSN for the connection to the customer table must be specified.' =>
            '',
        'If "DB" was selected for Customer::AuthModule, the column name for the CustomerPassword in the customer table must be specified.' =>
            '',
        'If "DB" was selected for Customer::AuthModule, the crypt type of passwords must be specified.' =>
            '',
        'If "DB" was selected for Customer::AuthModule, the name of the column for the CustomerKey in the customer table must be specified.' =>
            '',
        'If "DB" was selected for Customer::AuthModule, the name of the table where your customer data should be stored must be specified.' =>
            '',
        'If "DB" was selected for SessionModule, a table in database where session data will be stored must be specified.' =>
            '',
        'If "FS" was selected for SessionModule, a directory where the session data will be stored must be specified.' =>
            '',
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
            '',
        'If "LDAP" was selected for Customer::AuthModule, the LDAP host can be specified.' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule, the user identifier must be specified.' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule, user attributes can be specified. For LDAP posixGroups use UID, for non LDAP posixGroups use full user DN.' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule, you can specify access attributes here.' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule, you can specify if the applications will stop if e. g. a connection to a server can\'t be established due to network problems.' =>
            '',
        'If "LDAP" was selected for Customer::Authmodule, you can check if the user is allowed to authenticate because he is in a posixGroup, e.g. user needs to be in a group xyz to use OTRS. Specify the group, who may access the system.' =>
            '',
        'If "LDAP" was selected, you can add a filter to each LDAP query, e.g. (mail=*), (objectclass=user) or (!objectclass=computer).' =>
            '',
        'If "Radius" was selected for Customer::AuthModule, the password to authenticate to the radius host must be specified.' =>
            '',
        'If "Radius" was selected for Customer::AuthModule, the radius host must be specified.' =>
            '',
        'If "Radius" was selected for Customer::AuthModule, you can specify if the applications will stop if e. g. a connection to a server can\'t be established due to network problems.' =>
            '',
        'If "Sendmail" was selected as SendmailModule, the location of the sendmail binary and the needed options must be specified.' =>
            '',
        'If "SysLog" was selected for LogModule, a special log facility can be specified.' =>
            '',
        'If "SysLog" was selected for LogModule, a special log sock can be specified (on solaris you may need to use \'stream\').' =>
            '',
        'If "SysLog" was selected for LogModule, the charset that should be used for logging can be specified.' =>
            '',
        'If "file" was selected for LogModule, a logfile must be specified. If the file doesn\'t exist, it will be created by the system.' =>
            '',
        'If a note is added by an agent, sets the state of a ticket in the close ticket screen of the agent interface.' =>
            '',
        'If a note is added by an agent, sets the state of a ticket in the ticket bulk screen of the agent interface.' =>
            '',
        'If a note is added by an agent, sets the state of a ticket in the ticket free text screen of the agent interface.' =>
            '',
        'If a note is added by an agent, sets the state of a ticket in the ticket note screen of the agent interface.' =>
            '',
        'If a note is added by an agent, sets the state of a ticket in the ticket responsible screen of the agent interface.' =>
            '',
        'If a note is added by an agent, sets the state of the ticket in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'If a note is added by an agent, sets the state of the ticket in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'If a note is added by an agent, sets the state of the ticket in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, and authentication to the mail server is needed, a password must be specified.' =>
            '',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, and authentication to the mail server is needed, an username must be specified.' =>
            '',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, the mailhost that sends out the mails must be specified.' =>
            '',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, the port where your mailserver is listening for incoming connections must be specified.' =>
            '',
        'If enabled, OTRS will deliver all CSS files in minified form. WARNING: If you turn this off, there will likely be problems in IE 7, because it cannot load more than 32 CSS files.' =>
            '',
        'If enabled, OTRS will deliver all JavaScript files in minified form.' =>
            '',
        'If enabled, TicketPhone and TicketEmail will be open in new windows.' =>
            '',
        'If enabled, the OTRS version tag will be removed from the HTTP headers.' =>
            '',
        'If enabled, the different overviews (Dashboard, LockedView, QueueView) will automatically refresh after the specified time.' =>
            'Wenn diese Option aktiviert ist, werden die verschiedenen Übersichts-Seiten (Dashboard, LockedView, QueueView) automatisch nach der angegebenen Zeit aktualisiert.',
        'If enabled, the first level of the main menu opens on mouse hover (instead of click only).' =>
            '',
        'If set, this address is used as envelope sender header in outgoing notifications. If no address is specified, the envelope sender header is empty.' =>
            '',
        'If this regex matches, no message will be send by the autoresponder.' =>
            '',
        'If you want to use a mirror database for agent ticket fulltext search or to generate stats, specify the DSN to this database.' =>
            '',
        'If you want to use a mirror database for agent ticket fulltext search or to generate stats, the password to authenticate to this database can be specified.' =>
            '',
        'If you want to use a mirror database for agent ticket fulltext search or to generate stats, the user to authenticate to this database can be specified.' =>
            '',
        'Ignore article with system sender type for new article feature (e. g. auto responses or email notifications).' =>
            '',
        'Includes article create times in the ticket search of the agent interface.' =>
            '',
        'IndexAccelerator: to choose your backend TicketViewAccelerator module. "RuntimeDB" generates each queue view on the fly from ticket table (no performance problems up to approx. 60.000 tickets in total and 6.000 open tickets in the system). "StaticDB" is the most powerful module, it uses an extra ticket-index table that works like a view (recommended if more than 80.000 and 6.000 open tickets are stored in the system). Use the script "bin/otrs.RebuildTicketIndex.pl" for initial index update.' =>
            '',
        'Install ispell or aspell on the system, if you want to use a spell checker. Please specify the path to the aspell or ispell binary on your operating system.' =>
            '',
        'Interface language' => 'Sprache Benutzeroberfläche',
        'It is possible to configure different skins, for example to distinguish between diferent agents, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            '',
        'It is possible to configure different skins, for example to distinguish between diferent customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            '',
        'It is possible to configure different themes, for example to distinguish between agents and customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid theme on your system. Please see the example entries for the proper form of the regex.' =>
            '',
        'Link agents to groups.' => 'Agenten zu Gruppen zuordnen.',
        'Link agents to roles.' => 'Agenten zu Rollen zuordnen.',
        'Link attachments to responses templates.' => 'Anlagen zu Antwortvorlagen zuordnen.',
        'Link customers to groups.' => 'Kunden zu Gruppen zuordnen.',
        'Link customers to services.' => 'Kunden zu Services zuordnen.',
        'Link queues to auto responses.' => 'Automatische Antworten zu Queues zuordnen.',
        'Link responses to queues.' => 'Antworten zu Queues zuordnen.',
        'Link roles to groups.' => 'Rollen zu Gruppen zuordnen.',
        'Links 2 tickets with a "Normal" type link.' => '',
        'Links 2 tickets with a "ParentChild" type link.' => '',
        'List of CSS files to always be loaded for the agent interface.' =>
            '',
        'List of CSS files to always be loaded for the customer interface.' =>
            '',
        'List of IE7-specific CSS files to always be loaded for the customer interface.' =>
            '',
        'List of IE8-specific CSS files to always be loaded for the agent interface.' =>
            '',
        'List of IE8-specific CSS files to always be loaded for the customer interface.' =>
            '',
        'List of JS files to always be loaded for the agent interface.' =>
            '',
        'List of JS files to always be loaded for the customer interface.' =>
            '',
        'List of default StandardResponses which are assigned automatically to new Queues upon creation.' =>
            '',
        'Log file for the ticket counter.' => '',
        'Mail Accounts' => '',
        'Main menu registration.' => '',
        'Makes the application check the MX record of email addresses before sending an email or submitting a telephone or email ticket.' =>
            '',
        'Makes the application check the syntax of email addresses.' => '',
        'Makes the picture transparent.' => '',
        'Makes the session management use html cookies. If html cookies are disabled or if the client browser disabled html cookies, then the system will work as usual and append the session id to the links.' =>
            '',
        'Manage PGP keys for email encryption.' => 'PGP-Schlüssel für E-Mail-Verschlüsselung verwalten.',
        'Manage POP3 or IMAP accounts to fetch email from.' => 'POP3- oder IMAP-Konten für das Abholen von E-Mail verwalten.',
        'Manage S/MIME certificates for email encryption.' => 'S/MIME-Zertifikate für E-Mail-Verschlüsselung verwalten.',
        'Manage existing sessions.' => 'Sitzungen verwalten.',
        'Manage notifications that are sent to agents.' => '',
        'Manage periodic tasks.' => 'Periodische Aufgaben verwalten.',
        'Max size (in characters) of the customer information table (phone and email) in the compose screen.' =>
            '',
        'Max size (in rows) of the informed agents box in the agent interface.' =>
            '',
        'Max size (in rows) of the involved agents box in the agent interface.' =>
            '',
        'Max size of the subjects in an email reply.' => '',
        'Maximal auto email responses to own email-address a day (Loop-Protection).' =>
            '',
        'Maximal size in KBytes for mails that can be fetched via POP3/POP3S/IMAP/IMAPS (KBytes).' =>
            '',
        'Maximum number of tickets to be displayed in the result of a search in the agent interface.' =>
            '',
        'Maximum number of tickets to be displayed in the result of a search in the customer interface.' =>
            '',
        'Maximum size (in characters) of the customer information table in the ticket zoom view.' =>
            '',
        'Module for To-selection in new ticket screen in the customer interface.' =>
            '',
        'Module to check customer permissions.' => '',
        'Module to check if a user is in a special group. Access is granted, if the user is in the specified group and has ro and rw permissions.' =>
            '',
        'Module to check if arrived emails should be marked as email-internal (because of original forwared internal email it college). ArticleType and SenderType define the values for the arrived email/article.' =>
            '',
        'Module to check the agent responsible of a ticket.' => '',
        'Module to check the group permissions for the access to customer tickets.' =>
            '',
        'Module to check the owner of a ticket.' => '',
        'Module to check the watcher agents of a ticket.' => '',
        'Module to compose signed messages (PGP or S/MIME).' => '',
        'Module to crypt composed messages (PGP or S/MIME).' => '',
        'Module to filter and manipulate incoming messages. Block/ignore all spam email with From: noreply@ address.' =>
            '',
        'Module to filter and manipulate incoming messages. Get a 4 digit number to ticket free text, use regex in Match e. g. From => \'(.+?)@.+?\', and use () as [***] in Set =>.' =>
            '',
        'Module to generate accounted time ticket statistics.' => '',
        'Module to generate html OpenSearch profile for short ticket search in the agent interface.' =>
            '',
        'Module to generate html OpenSearch profile for short ticket search in the customer interface.' =>
            '',
        'Module to generate ticket solution and response time statistics.' =>
            '',
        'Module to generate ticket statistics.' => '',
        'Module to show notifications and escalations (ShownMax: max. shown escalations, EscalationInMinutes: Show ticket which will escalation in, CacheTime: Cache of calculated escalations in seconds).' =>
            '',
        'Module to use database filter storage.' => '',
        'Multiselect' => 'Mehrfachauswahl',
        'My Tickets' => 'Meine Tickets',
        'Name of custom queue. The custom queue is a queue selection of your preferred queues and can be selected in the preferences settings.' =>
            '',
        'NameX' => '',
        'New email ticket' => 'Neues E-Mail-Ticket',
        'New phone ticket' => 'Neues Telefon-Ticket',
        'New process ticket' => 'Neues Prozess-Ticket',
        'Next possible ticket states after adding a phone note in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Next possible ticket states after adding a phone note in the ticket phone outbound screen of the agent interface.' =>
            '',
        'Notifications (Event)' => 'Benachrichtigungen (Ereignis)',
        'Number of displayed tickets' => 'Anzahl der angezeigten Tickets',
        'Number of lines (per ticket) that are shown by the search utility in the agent interface.' =>
            '',
        'Number of tickets to be displayed in each page of a search result in the agent interface.' =>
            '',
        'Number of tickets to be displayed in each page of a search result in the customer interface.' =>
            '',
        'Open tickets of customer' => 'Offene Tickets des Kunden',
        'Overloads (redefines) existing functions in Kernel::System::Ticket. Used to easily add customizations.' =>
            '',
        'Overview Escalated Tickets' => 'Übersicht eskalierte Tickets',
        'Overview Refresh Time' => 'Aktualisierungszeiten der Übersichten',
        'Overview of all open Tickets.' => 'Übersicht über alle offenen Tickets.',
        'PGP Key Management' => 'PGP-Schlüssel-Verwaltung',
        'PGP Key Upload' => 'PGP Schlüssel hochladen',
        'Parameters for the CreateNextMask object in the preference view of the agent interface.' =>
            '',
        'Parameters for the CustomQueue object in the preference view of the agent interface.' =>
            '',
        'Parameters for the FollowUpNotify object in the preference view of the agent interface.' =>
            '',
        'Parameters for the LockTimeoutNotify object in the preference view of the agent interface.' =>
            '',
        'Parameters for the MoveNotify object in the preference view of the agent interface.' =>
            '',
        'Parameters for the NewTicketNotify object in the preferences view of the agent interface.' =>
            '',
        'Parameters for the RefreshTime object in the preference view of the agent interface.' =>
            '',
        'Parameters for the WatcherNotify object in the preference view of the agent interface.' =>
            '',
        'Parameters for the dashboard backend of the customer company information of the agent interface . "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the customer id status widget of the agent interface . "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the customer user list overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the new tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the ticket calendar of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the ticket escalation overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the ticket pending reminder overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the ticket pending reminder overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the ticket stats of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the pages (in which the dynamic fields are shown) of the dynamic fields overview.' =>
            '',
        'Parameters for the pages (in which the tickets are shown) of the medium ticket overview.' =>
            '',
        'Parameters for the pages (in which the tickets are shown) of the small ticket overview.' =>
            '',
        'Parameters for the pages (in which the tickets are shown) of the ticket preview overview.' =>
            '',
        'Parameters of the example SLA attribute Comment2.' => '',
        'Parameters of the example queue attribute Comment2.' => '',
        'Parameters of the example service attribute Comment2.' => '',
        'Path for the log file (it only applies if "FS" was selected for LoopProtectionModule and it is mandatory).' =>
            '',
        'Path of the file that stores all the settings for the QueueObject object for the agent interface.' =>
            '',
        'Path of the file that stores all the settings for the QueueObject object for the customer interface.' =>
            '',
        'Path of the file that stores all the settings for the TicketObject for the agent interface.' =>
            '',
        'Path of the file that stores all the settings for the TicketObject for the customer interface.' =>
            '',
        'Performs the configured action for each event (as an Invoker) for each configured Webservice.' =>
            '',
        'Permitted width for compose email windows.' => '',
        'Permitted width for compose note windows.' => '',
        'Picture-Upload' => '',
        'PostMaster Filters' => 'PostMaster-Filter',
        'PostMaster Mail Accounts' => 'PostMaster-E-Mail-Konten',
        'Process Information' => '',
        'Process Management Activity Dialog GUI' => '',
        'Process Management Activity GUI' => '',
        'Process Management Path GUI' => '',
        'Process Management Transition Action GUI' => '',
        'Process Management Transition GUI' => '',
        'Protection against CSRF (Cross Site Request Forgery) exploits (for more info see http://en.wikipedia.org/wiki/Cross-site_request_forgery).' =>
            '',
        'Queue view' => 'Ansicht nach Queues',
        'Refresh Overviews after' => 'Übersichten aktualisieren nach',
        'Refresh interval' => 'Aktualisierungsintervall',
        'Removes the ticket watcher information when a ticket is archived.' =>
            '',
        'Replaces the original sender with current customer\'s email address on compose answer in the ticket compose screen of the agent interface.' =>
            '',
        'Required permissions to change the customer of a ticket in the agent interface.' =>
            '',
        'Required permissions to use the close ticket screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket bounce screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket compose screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket forward screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket free text screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket merge screen of a zoomed ticket in the agent interface.' =>
            '',
        'Required permissions to use the ticket note screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Required permissions to use the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Required permissions to use the ticket phone inbound screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket phone outbound screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Required permissions to use the ticket responsible screen in the agent interface.' =>
            '',
        'Resets and unlocks the owner of a ticket if it was moved to another queue.' =>
            '',
        'Responses <-> Queues' => 'Antworten <-> Queues',
        'Restores a ticket from the archive (only if the event is a state change, from closed to any open available state).' =>
            '',
        'Roles <-> Groups' => 'Rollen <-> Gruppen',
        'Runs an initial wildcard search of the existing customer users when accessing the AdminCustomerUser module.' =>
            '',
        'Runs the system in "Demo" mode. If set to "Yes", agents can change preferences, such as selection of language and theme via the agent web interface. These changes are only valid for the current session. It will not be possible for agents to change their passwords.' =>
            '',
        'S/MIME Certificate Upload' => 'S/MIME Zertifikat hochladen',
        'Saves the attachments of articles. "DB" stores all data in the database (not recommended for storing big attachments). "FS" stores the data on the filesystem; this is faster but the webserver should run under the OTRS user. You can switch between the modules even on a system that is already in production without any loss of data.' =>
            '',
        'Search backend default router.' => '',
        'Search backend router.' => '',
        'Select your frontend Theme.' => 'Anzeigeschema auswählen.',
        'Selects the cache backend to use.' => '',
        'Selects the module to handle uploads via the web interface. "DB" stores all uploads in the database, "FS" uses the file system.' =>
            '',
        'Selects the ticket number generator module. "AutoIncrement" increments the ticket number, the SystemID and the counter are used with SystemID.counter format (e.g. 1010138, 1010139). With "Date" the ticket numbers will be generated by the current date, the SystemID and the counter. The format looks like Year.Month.Day.SystemID.counter (e.g. 200206231010138, 200206231010139). With "DateChecksum"  the counter will be appended as checksum to the string of date and SystemID. The checksum will be rotated on a daily basis. The format looks like Year.Month.Day.SystemID.Counter.CheckSum (e.g. 2002070110101520, 2002070110101535). "Random" generates randomized ticket numbers in the format "SystemID.Random" (e.g. 100057866352, 103745394596).' =>
            '',
        'Send me a notification if a customer sends a follow up and I\'m the owner of the ticket or the ticket is unlocked and is in one of my subscribed queues.' =>
            'Sende mir eine Benachrichtigung, wenn ein Kunde eine Rückmeldung gibt und ich der Besitzer des Tickets bin, oder das Ticket nicht gesperrt ist und in einer meiner Queues liegt.',
        'Send notifications to users.' => 'Benachrichtigungen an Agenten verschicken.',
        'Send ticket follow up notifications' => 'Benachrichtigung bei Rückmeldung verschicken',
        'Sender type for new tickets from the customer inteface.' => '',
        'Sends agent follow-up notification only to the owner, if a ticket is unlocked (the default is to send the notification to all agents).' =>
            '',
        'Sends all outgoing email via bcc to the specified address. Please use this only for backup reasons.' =>
            '',
        'Sends customer notifications just to the mapped customer. Normally, if no customer is mapped, the latest customer sender gets the notification.' =>
            '',
        'Sends reminder notifications of unlocked ticket after reaching the reminder date (only sent to ticket owner).' =>
            '',
        'Sends the notifications which are configured in the admin interface under "Notfication (Event)".' =>
            '',
        'Set sender email addresses for this system.' => 'Absendeadressen für dieses System verwalten.',
        'Set the default height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            '',
        'Set the maximum height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            '',
        'Set this to yes if you trust in all your public and private pgp keys, even if they are not certified with a trusted signature.' =>
            '',
        'Sets if ticket owner must be selected by the agent.' => '',
        'Sets the PendingTime of a ticket to 0 if the state is changed to a non-pending state.' =>
            '',
        'Sets the age in minutes (first level) for highlighting queues that contain untouched tickets.' =>
            '',
        'Sets the age in minutes (second level) for highlighting queues that contain untouched tickets.' =>
            '',
        'Sets the configuration level of the administrator. Depending on the config level, some sysconfig options will be not shown. The config levels are in in ascending order: Expert, Advanced, Beginner. The higher the config level is (e.g. Beginner is the highest), the less likely is it that the user can accidentally configure the system in a way that it is not usable any more.' =>
            '',
        'Sets the default article type for new email tickets in the agent interface.' =>
            '',
        'Sets the default article type for new phone tickets in the agent interface.' =>
            '',
        'Sets the default body text for notes added in the close ticket screen of the agent interface.' =>
            '',
        'Sets the default body text for notes added in the ticket move screen of the agent interface.' =>
            '',
        'Sets the default body text for notes added in the ticket note screen of the agent interface.' =>
            '',
        'Sets the default body text for notes added in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the default body text for notes added in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the default body text for notes added in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the default body text for notes added in the ticket responsible screen of the agent interface.' =>
            '',
        'Sets the default link type of splitted tickets in the agent interface.' =>
            '',
        'Sets the default next state for new phone tickets in the agent interface.' =>
            '',
        'Sets the default next ticket state, after the creation of an email ticket in the agent interface.' =>
            '',
        'Sets the default note text for new telephone tickets. E.g \'New ticket via call\' in the agent interface.' =>
            '',
        'Sets the default priority for new email tickets in the agent interface.' =>
            '',
        'Sets the default priority for new phone tickets in the agent interface.' =>
            '',
        'Sets the default sender type for new email tickets in the agent interface.' =>
            '',
        'Sets the default sender type for new phone ticket in the agent interface.' =>
            '',
        'Sets the default subject for new email tickets (e.g. \'email Outbound\') in the agent interface.' =>
            '',
        'Sets the default subject for new phone tickets (e.g. \'Phone call\') in the agent interface.' =>
            '',
        'Sets the default subject for notes added in the close ticket screen of the agent interface.' =>
            '',
        'Sets the default subject for notes added in the ticket move screen of the agent interface.' =>
            '',
        'Sets the default subject for notes added in the ticket note screen of the agent interface.' =>
            '',
        'Sets the default subject for notes added in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the default subject for notes added in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the default subject for notes added in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the default subject for notes added in the ticket responsible screen of the agent interface.' =>
            '',
        'Sets the default text for new email tickets in the agent interface.' =>
            '',
        'Sets the display order of the different items in the preferences view.' =>
            '',
        'Sets the inactivity time (in seconds) to pass before a session is killed and a user is loged out.' =>
            '',
        'Sets the maximum number of active agents within the timespan defined in SessionActiveTime.' =>
            '',
        'Sets the maximum number of active customers within the timespan defined in SessionActiveTime.' =>
            '',
        'Sets the minimal ticket counter size (if "AutoIncrement" was selected as TicketNumberGenerator). Default is 5, this means the counter starts from 10000.' =>
            '',
        'Sets the minimum number of characters before autocomplete query is sent.' =>
            '',
        'Sets the number of lines that are displayed in text messages (e.g. ticket lines in the QueueZoom).' =>
            '',
        'Sets the number of search results to be displayed for the autocomplete feature.' =>
            '',
        'Sets the options for PGP binary.' => '',
        'Sets the order of the different items in the customer preferences view.' =>
            '',
        'Sets the password for private PGP key.' => '',
        'Sets the prefered time units (e.g. work units, hours, minutes).' =>
            '',
        'Sets the prefix to the scripts folder on the server, as configured on the web server. This setting is used as a variable, OTRS_CONFIG_ScriptAlias which is found in all forms of messaging used by the application, to build links to the tickets within the system.' =>
            '',
        'Sets the queue in the ticket close screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the queue in the ticket free text screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the queue in the ticket note screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the queue in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the queue in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the queue in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the queue in the ticket responsible screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the responsible agent of the ticket in the close ticket screen of the agent interface.' =>
            '',
        'Sets the responsible agent of the ticket in the ticket bulk screen of the agent interface.' =>
            '',
        'Sets the responsible agent of the ticket in the ticket free text screen of the agent interface.' =>
            '',
        'Sets the responsible agent of the ticket in the ticket note screen of the agent interface.' =>
            '',
        'Sets the responsible agent of the ticket in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the responsible agent of the ticket in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the responsible agent of the ticket in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the responsible agent of the ticket in the ticket responsible screen of the agent interface.' =>
            '',
        'Sets the service in the close ticket screen of the agent interface (Ticket::Service needs to be activated).' =>
            '',
        'Sets the service in the ticket free text screen of the agent interface (Ticket::Service needs to be activated).' =>
            '',
        'Sets the service in the ticket note screen of the agent interface (Ticket::Service needs to be activated).' =>
            '',
        'Sets the service in the ticket owner screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).' =>
            '',
        'Sets the service in the ticket pending screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).' =>
            '',
        'Sets the service in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).' =>
            '',
        'Sets the service in the ticket responsible screen of the agent interface (Ticket::Service needs to be activated).' =>
            '',
        'Sets the size of the statistic graph.' => '',
        'Sets the stats hook.' => '',
        'Sets the system time zone (required a system with UTC as system time). Otherwise this is a diff time to the local time.' =>
            '',
        'Sets the ticket owner in the close ticket screen of the agent interface.' =>
            '',
        'Sets the ticket owner in the ticket bulk screen of the agent interface.' =>
            '',
        'Sets the ticket owner in the ticket free text screen of the agent interface.' =>
            '',
        'Sets the ticket owner in the ticket note screen of the agent interface.' =>
            '',
        'Sets the ticket owner in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the ticket owner in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the ticket owner in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the ticket owner in the ticket responsible screen of the agent interface.' =>
            '',
        'Sets the ticket type in the close ticket screen of the agent interface (Ticket::Type needs to be activated).' =>
            '',
        'Sets the ticket type in the ticket bulk screen of the agent interface.' =>
            '',
        'Sets the ticket type in the ticket free text screen of the agent interface (Ticket::Type needs to be activated).' =>
            '',
        'Sets the ticket type in the ticket note screen of the agent interface (Ticket::Type needs to be activated).' =>
            '',
        'Sets the ticket type in the ticket owner screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).' =>
            '',
        'Sets the ticket type in the ticket pending screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).' =>
            '',
        'Sets the ticket type in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).' =>
            '',
        'Sets the ticket type in the ticket responsible screen of the agent interface (Ticket::Type needs to be activated).' =>
            '',
        'Sets the time (in seconds) a user is marked as active.' => '',
        'Sets the time type which should be shown.' => '',
        'Sets the timeout (in seconds) for http/ftp downloads.' => '',
        'Sets the timeout (in seconds) for package downloads. Overwrites "WebUserAgent::Timeout".' =>
            '',
        'Sets the user time zone per user (required a system with UTC as system time and UTC under TimeZone). Otherwise this is a diff time to the local time.' =>
            '',
        'Sets the user time zone per user based on java script / browser time zone offset feature at login time.' =>
            '',
        'Show a responsible selection in phone and email tickets in the agent interface.' =>
            '',
        'Show article as rich text even if rich text writing is disabled.' =>
            '',
        'Show the current owner in the customer interface.' => '',
        'Show the current queue in the customer interface.' => '',
        'Shows a count of icons in the ticket zoom, if the article has attachments.' =>
            '',
        'Shows a link in the menu for subscribing / unsubscribing from a ticket in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu that allows linking a ticket with another object in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu that allows merging tickets in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to access the history of a ticket in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to add a free text field in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to add a note in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to add a note to a ticket in every ticket overview of the agent interface.' =>
            '',
        'Shows a link in the menu to close a ticket in every ticket overview of the agent interface.' =>
            '',
        'Shows a link in the menu to close a ticket in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to delete a ticket in every ticket overview of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Shows a link in the menu to delete a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Shows a link in the menu to go back in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to lock / unlock a ticket in the ticket overviews of the agent interface.' =>
            '',
        'Shows a link in the menu to lock/unlock tickets in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to move a ticket in every ticket overview of the agent interface.' =>
            '',
        'Shows a link in the menu to print a ticket or an article in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to see the customer who requested the ticket in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to see the history of a ticket in every ticket overview of the agent interface.' =>
            '',
        'Shows a link in the menu to see the owner of a ticket in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to see the priority of a ticket in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to see the responsible agent of a ticket in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to set a ticket as pending in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to set a ticket as spam in every ticket overview of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Shows a link in the menu to set the priority of a ticket in every ticket overview of the agent interface.' =>
            '',
        'Shows a link in the menu to zoom a ticket in the ticket overviews of the agent interface.' =>
            '',
        'Shows a link to access article attachments via a html online viewer in the zoom view of the article in the agent interface.' =>
            '',
        'Shows a link to download article attachments in the zoom view of the article in the agent interface.' =>
            '',
        'Shows a link to see a zoomed email ticket in plain text.' => '',
        'Shows a link to set a ticket as spam in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Shows a list of all the involved agents on this ticket, in the close ticket screen of the agent interface.' =>
            '',
        'Shows a list of all the involved agents on this ticket, in the ticket free text screen of the agent interface.' =>
            '',
        'Shows a list of all the involved agents on this ticket, in the ticket note screen of the agent interface.' =>
            '',
        'Shows a list of all the involved agents on this ticket, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows a list of all the involved agents on this ticket, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows a list of all the involved agents on this ticket, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows a list of all the involved agents on this ticket, in the ticket responsible screen of the agent interface.' =>
            '',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the close ticket screen of the agent interface.' =>
            '',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket free text screen of the agent interface.' =>
            '',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket note screen of the agent interface.' =>
            '',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket responsible screen of the agent interface.' =>
            '',
        'Shows a preview of the ticket overview (CustomerInfo => 1 - shows also Customer-Info, CustomerInfoMaxSize max. size in characters of Customer-Info).' =>
            '',
        'Shows a select of ticket attributes to order the queue view ticket list. The possible selections can be configured via "TicketOverviewMenuSort###SortAttributes".' =>
            '',
        'Shows all both ro and rw queues in the queue view.' => '',
        'Shows all open tickets (even if they are locked) in the escalation view of the agent interface.' =>
            '',
        'Shows all open tickets (even if they are locked) in the status view of the agent interface.' =>
            '',
        'Shows all the articles of the ticket (expanded) in the zoom view.' =>
            '',
        'Shows all the customer identifiers in a multi-select field (not useful if you have a lot of customer identifiers).' =>
            '',
        'Shows an owner selection in phone and email tickets in the agent interface.' =>
            '',
        'Shows colors for different article types in the article table.' =>
            '',
        'Shows customer history tickets in AgentTicketPhone, AgentTicketEmail and AgentTicketCustomer.' =>
            '',
        'Shows either the last customer article\'s subject or the ticket title in the small format overview.' =>
            '',
        'Shows existing parent/child queue lists in the system in the form of a tree or a list.' =>
            '',
        'Shows the activated ticket attributes in the customer interface (0 = Disabled and 1 = Enabled).' =>
            '',
        'Shows the articles sorted normally or in reverse, under ticket zoom in the agent interface.' =>
            '',
        'Shows the customer user information (phone and email) in the compose screen.' =>
            '',
        'Shows the customer user\'s info in the ticket zoom view.' => '',
        'Shows the message of the day (MOTD) in the agent dashboard. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually.' =>
            '',
        'Shows the message of the day on login screen of the agent interface.' =>
            '',
        'Shows the ticket history (reverse ordered) in the agent interface.' =>
            '',
        'Shows the ticket priority options in the close ticket screen of the agent interface.' =>
            '',
        'Shows the ticket priority options in the move ticket screen of the agent interface.' =>
            '',
        'Shows the ticket priority options in the ticket bulk screen of the agent interface.' =>
            '',
        'Shows the ticket priority options in the ticket free text screen of the agent interface.' =>
            '',
        'Shows the ticket priority options in the ticket note screen of the agent interface.' =>
            '',
        'Shows the ticket priority options in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows the ticket priority options in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows the ticket priority options in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows the ticket priority options in the ticket responsible screen of the agent interface.' =>
            '',
        'Shows the title fields in the close ticket screen of the agent interface.' =>
            '',
        'Shows the title fields in the ticket free text screen of the agent interface.' =>
            '',
        'Shows the title fields in the ticket note screen of the agent interface.' =>
            '',
        'Shows the title fields in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows the title fields in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows the title fields in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows the title fields in the ticket responsible screen of the agent interface.' =>
            '',
        'Shows time in long format (days, hours, minutes), if set to "Yes"; or in short format (days, hours), if set to "No".' =>
            '',
        'Shows time use complete description (days, hours, minutes), if set to "Yes"; or just first letter (d, h, m), if set to "No".' =>
            '',
        'Skin' => 'Skin',
        'SolutionDiffInMin' => 'Lösungszeitdifferenz in Minuten',
        'SolutionInMin' => 'Lösungszeit in Minuten',
        'Sorts the tickets (ascendingly or descendingly) when a single queue is selected in the queue view and after the tickets are sorted by priority. Values: 0 = ascending (oldest on top, default), 1 = descending (youngest on top). Use the QueueID for the key and 0 or 1 for value.' =>
            '',
        'Spam Assassin example setup. Ignores emails that are marked with SpamAssassin.' =>
            '',
        'Spam Assassin example setup. Moves marked mails to spam queue.' =>
            '',
        'Specifies if an agent should receive email notification of his own actions.' =>
            '',
        'Specifies the available note types for this ticket mask. If the option is deselected, ArticleTypeDefault is used and the option is removed from the mask.' =>
            '',
        'Specifies the background color of the chart.' => '',
        'Specifies the background color of the picture.' => '',
        'Specifies the border color of the chart.' => '',
        'Specifies the border color of the legend.' => '',
        'Specifies the bottom margin of the chart.' => '',
        'Specifies the different article types that will be used in the system.' =>
            '',
        'Specifies the different note types that will be used in the system.' =>
            '',
        'Specifies the directory to store the data in, if "FS" was selected for TicketStorageModule.' =>
            '',
        'Specifies the directory where SSL certificates are stored.' => '',
        'Specifies the directory where private SSL certificates are stored.' =>
            '',
        'Specifies the email address that should be used by the application when sending notifications. The email address is used to build the complete display name for the notification master (i.e. "OTRS Notification Master" otrs@your.example.com). You can use the OTRS_CONFIG_FQDN variable as set in your configuation, or choose another email address. Notifications are messages such as en::Customer::QueueUpdate or en::Agent::Move.' =>
            '',
        'Specifies the group where the user needs rw permissions so that he can access the "SwitchToCustomer" feature.' =>
            '',
        'Specifies the left margin of the chart.' => '',
        'Specifies the name that should be used by the application when sending notifications. The sender name is used to build the complete display name for the notification master (i.e. "OTRS Notification Master" otrs@your.example.com). Notifications are messages such as en::Customer::QueueUpdate or en::Agent::Move.' =>
            '',
        'Specifies the path of the file for the logo in the page header (gif|jpg|png, 700 x 100 pixel).' =>
            '',
        'Specifies the path of the file for the performance log.' => '',
        'Specifies the path to the converter that allows the view of Microsoft Excel files, in the web interface.' =>
            '',
        'Specifies the path to the converter that allows the view of Microsoft Word files, in the web interface.' =>
            '',
        'Specifies the path to the converter that allows the view of PDF documents, in the web interface.' =>
            '',
        'Specifies the path to the converter that allows the view of XML files, in the web interface.' =>
            '',
        'Specifies the right margin of the chart.' => '',
        'Specifies the text color of the chart (e. g. caption).' => '',
        'Specifies the text color of the legend.' => '',
        'Specifies the text that should appear in the log file to denote a CGI script entry.' =>
            '',
        'Specifies the top margin of the chart.' => '',
        'Specifies user id of the postmaster data base.' => '',
        'Specify how many sub directory levels to use when creating cache files. This should prevent too many cache files being in one directory.' =>
            '',
        'Standard available permissions for agents within the application. If more permissions are needed, they can be entered here. Permissions must be defined to be effective. Some other good permissions have also been provided built-in: note, close, pending, customer, freetext, move, compose, responsible, forward, and bounce. Make sure that "rw" is always the last registered permission.' =>
            '',
        'Start number for statistics counting. Every new stat increments this number.' =>
            '',
        'Starts a wildcard search of the active object after the link object mask is started.' =>
            '',
        'Statistics' => 'Statistiken',
        'Status view' => 'Ansicht nach Status',
        'Stop words for fulltext index. These words will be removed.' => '',
        'Stores cookies after the browser has been closed.' => '',
        'Strips empty lines on the ticket preview in the queue view.' => '',
        'Textarea' => 'Textfeld',
        'The "bin/PostMasterMailAccount.pl" will reconnect to POP3/POP3S/IMAP/IMAPS host after the specified count of messages.' =>
            '',
        'The agent skin\'s InternalName which should be used in the agent interface. Please check the available skins in Frontend::Agent::Skins.' =>
            '',
        'The customer skin\'s InternalName which should be used in the customer interface. Please check the available skins in Frontend::Customer::Skins.' =>
            '',
        'The divider between TicketHook and ticket number. E.g \': \'.' =>
            '',
        'The duration in minutes after emitting an event, in which the new escalation notify and start events are suppressed.' =>
            'Die Zeitspanne in Minuten nach der Erzeugung eines Ereignisses, während der neue Vorwarn- und Start-Ereignisse unterdrückt werden.',
        'The format of the subject. \'Left\' means \'[TicketHook#:12345] Some Subject\', \'Right\' means \'Some Subject [TicketHook#:12345]\', \'None\' means \'Some Subject\' and no ticket number. In the last case you should enable PostmasterFollowupSearchInRaw or PostmasterFollowUpSearchInReferences to recognize followups based on email headers and/or body.' =>
            '',
        'The headline shown in the customer interface.' => '',
        'The identifier for a ticket, e.g. Ticket#, Call#, MyTicket#. The default is Ticket#.' =>
            '',
        'The logo shown in the header of the agent interface. The URL to the image can be a relative URL to the skin image directory, or a full URL to a remote web server.' =>
            '',
        'The logo shown in the header of the customer interface. The URL to the image can be a relative URL to the skin image directory, or a full URL to a remote web server.' =>
            '',
        'The logo shown on top of the login box of the agent interface. The URL to the image must be relative URL to the skin image directory.' =>
            '',
        'The text at the beginning of the subject in an email reply, e.g. RE, AW, or AS.' =>
            '',
        'The text at the beginning of the subject when an email is forwarded, e.g. FW, Fwd, or WG.' =>
            '',
        'This module and its PreRun() function will be executed, if defined, for every request. This module is useful to check some user options or to display news about new applications.' =>
            '',
        'This option defines the dynamic field in which a Process Management activity entity id is stored.' =>
            '',
        'This option defines the dynamic field in which a Process Management process entity id is stored.' =>
            '',
        'This option defines the process tickets default lock.' => '',
        'This option defines the process tickets default priority.' => '',
        'This option defines the process tickets default queue.' => '',
        'This option defines the process tickets default state.' => '',
        'This setting allows you to override the built-in country list with your own list of countries. This is particularly handy if you just want to use a small select group of countries.' =>
            '',
        'Ticket event module that triggers the escalation stop events.' =>
            'Ticket Event Modul welche die Eskalation-Stop-Ereignisse auslöst.',
        'Ticket overview' => 'Ticket-Übersicht',
        'TicketNumber' => 'Ticketnummer',
        'Tickets' => 'Tickets',
        'Time in seconds that gets added to the actual time if setting a pending-state (default: 86400 = 1 day).' =>
            '',
        'Toggles display of OTRS FeatureAddons list in PackageManager.' =>
            '',
        'Toolbar Item for a shortcut.' => '',
        'Turns on the animations used in the GUI. If you have problems with these animations (e.g. performance issues), you can turn them off here.' =>
            '',
        'Turns on the remote ip address check. It should be set to "No" if the application is used, for example, via a proxy farm or a dialup connection, because the remote ip address is mostly different for the requests.' =>
            '',
        'Types' => 'Typen',
        'Update Ticket "Seen" flag if every article got seen or a new Article got created.' =>
            '',
        'Update and extend your system with software packages.' => 'System mit Softwarepaketen aktualisieren und erweitern.',
        'Updates the ticket escalation index after a ticket attribute got updated.' =>
            '',
        'Updates the ticket index accelerator.' => '',
        'UserFirstname' => 'Benutzervorname',
        'UserLastname' => 'Benutzernachname',
        'Uses Cc recipients in reply Cc list on compose an email answer in the ticket compose screen of the agent interface.' =>
            '',
        'Uses richtext for viewing and editing: articles, salutations, signatures, standard responses, auto responses and notifications.' =>
            '',
        'View performance benchmark results.' => 'Ergebnisse der Performance-Messung anzeigen.',
        'View system log messages.' => 'System-Protokolleinträge anzeigen.',
        'Wear this frontend skin' => 'Diesen Skin verwenden',
        'Webservice path separator.' => '',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. In this text area you can define this text (This text cannot be changed by the agent).' =>
            '',
        'When tickets are merged, the customer can be informed per email by setting the check box "Inform Sender". In this text area, you can define a pre-formatted text which can later be modified by the agents.' =>
            '',
        'Your queue selection of your favorite queues. You also get notified about those queues via email if enabled.' =>
            'Auswahl der bevorzugten Queues. Es werden E-Mail-Benachrichtigungen über diese ausgewählten Queues versendet.',

        #
        # OBSOLETE ENTRIES FOR REFERENCE, DO NOT TRANSLATE!
        #
        'Changes to the Processes here only affect the behaviour of the system, if you synchronize the Process data. By synchronizing the Processes, the newly made changes will be written to the Configuration.' =>
            'Änderungen an den Prozessen wirken sich erst dann aus, wenn Sie die Prozesskonfiguration synchronisieren. Dabei werden alle Änderungen in die Systemkonfiguration übernommen.',
        'Customer Data' => 'Kunden-/Kontakt-Daten',
        'Did not find a required feature? OTRS Group provides their subscription customers with exclusive Add-Ons:' =>
            'Der Turbo für Ihr OTRS - Exklusive Feature Add-Ons für Subscription-Kunden:',
        'For more info see:' => 'Für mehr Informationen hier:',
        'Historic Time Range' => 'Historischer Zeitraum',
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty.' =>
            'Sollte ein Root-Passwort für die Datenbank gesetzt sein, muss dieses hier angegeben werden. Anderenfalls muss dieses Feld leer bleiben.',
        'Logout successful. Thank you for using OTRS!' => 'Abmeldung erfolgreich! Danke für die Benutzung von  OTRS!',
        'New email ticket for %s' => 'Neues E-Mail-Ticket für %s',
        'New phone ticket for %s' => 'Neues Telefonticket für %s',
        'Overwrite existing entities' => 'Bestehende Einträge überschreiben',
        'Package verification failed!' => 'Paket Überprüfung Fehlgeschlagen',
        'Please supply a' => 'Angabe notwendig:',
        'Please supply a first name' => 'Bitte geben Sie einen Vornamen an',
        'Please supply a last name' => 'Bitte geben Sie einen Nachnamen an',
        'Repeat Password' => 'Passwort wiederholen',
        'Secure mode must be disabled in order to reinstall using the web-installer.' =>
            'Der Sicherheitsmodus muss ausgeschaltet werden, um mit Hilfe des Web-Installers erneut zu installieren.',
        'State Historic' => 'Historischer Status',
        'State Type Historic' => 'Historischer Status-Typ',
        'There are no further steps in this process' => 'Es gibt keine weiteren Schritte in diesem Prozess.',
        'Transition Validation Module' => 'Modul zur Übergangsvalidierung',

    };
    # $$STOP$$
    return;
}

1;
