# --
# Kernel/Language/de.pm - provides German language translation
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# Copyright (C) 2010 Thomas Kaltenbrunner <tkaltenbrunner at opc.de>
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --
package Kernel::Language::de;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # $$START$$
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
        'Reset' => 'Zurücksetzen',
        'more than ... ago' => 'vor mehr als ...',
        'in more than ...' => 'in mehr als ...',
        'within the last ...' => 'innerhalb der letzten ...',
        'within the next ...' => 'innerhalb der kommenden ...',
        'Created within the last' => 'Erstellt innerhalb der letzten',
        'Created more than ... ago' => 'Erstellt vor mehr als ...',
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
        'Time unit' => 'Zeiteinheit',
        'wrote' => 'schrieb',
        'Message' => 'Nachricht',
        'Error' => 'Fehler',
        'Bug Report' => 'Fehlerbericht',
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
        'CustomerID' => 'Kundennummer',
        'CustomerIDs' => 'Kundennummern',
        'customer' => 'Kunde',
        'agent' => 'Agent',
        'system' => 'System',
        'Customer Info' => 'Kundeninformation',
        'Customer Information' => 'Kundeninformation',
        'Customer Companies' => 'Kunden',
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
        'before/after' => 'vor/nach',
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
        'Show Tree Selection' => 'Baumauswahl anzeigen',
        'The field content is too long!' => 'Der Feldinhalt ist zu lang!',
        'Maximum size is %s characters.' => 'Die Maximallänge beträgt %s Zeichen.',
        'This field is required or' => 'Dieses Feld ist ein Pflichtfeld oder',
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
        'Authentication succeeded, but no customer record is found in the customer backend. Please contact your administrator.' =>
            'Authentifizierung erfolgreich, aber im Kunden Backend wurde kein Kunden Eintrag gefunden. Bitte kontaktieren Sie Ihren Administrator.',
        'This e-mail address already exists. Please log in or reset your password.' =>
            'Diese E-Mail Adresse existiert bereits. Bitte melden Sie sich an oder setzen Ihr Passwort zurück.',
        'Logout' => 'Abmelden',
        'Logout successful. Thank you for using %s!' => 'Abmeldung erfolgreich! Danke für die Benutzung von  %s!',
        'Feature not active!' => 'Funktion nicht aktiviert!',
        'Agent updated!' => 'Agent aktualisiert!',
        'Database Selection' => 'Datenbank-Auswahl',
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
        'Enter the password for the administrative database user.' => 'Geben Sie das Passwort für den Administrationsbenutzer der Datenbank ein.',
        'Enter the password for the database user.' => 'Geben Sie das Passwort für den Datenbankbenutzer ein.',
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty.' =>
            'Sollte ein Root-Passwort für die Datenbank gesetzt sein, muss dieses hier angegeben werden. Anderenfalls muss dieses Feld leer bleiben.',
        'Database already contains data - it should be empty!' => 'Die Datenbank enthält bereits Daten obwohl sie leer sein sollte!',
        'Login is needed!' => 'Login wird benötigt!',
        'It is currently not possible to login due to a scheduled system maintenance.' =>
            'Die Anmeldung ist derzeit aufgrund einer geplanten Systemwartung nicht verfügbar.',
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
            'Sie haben die Abwesenheitszeit eingeschaltet, möchten Sie diese deaktivieren?',
        'News about OTRS releases!' => 'Neuigkeiten zu OTRS-Releases!',
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
        'Note: Company is invalid!' => 'Hinweis: Firma ist ungültig!',
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
        'Edit the system configuration settings.' => 'Systemeinstellungen bearbeiten.',
        'ACL information from database is not in sync with the system configuration, please deploy all ACLs.' =>
            'ACL Konfiguration laut Datenbank nicht synchron mit der System Configuration, bitte ACLs in Betrieb nehmen.',
        'printed at' => 'gedruckt am',
        'Loading...' => 'Laden...',
        'Dear Mr. %s,' => 'Sehr geehrter Herr %s,',
        'Dear Mrs. %s,' => 'Sehr geehrte Frau %s,',
        'Dear %s,' => 'Lieber %s,',
        'Hello %s,' => 'Hallo %s,',
        'This email address already exists. Please log in or reset your password.' =>
            'Diese E-Mail-Adresse existiert bereits. Bitte melden Sie sich an oder ändern Sie ihr Passwort.',
        'This email address is not allowed to register. Please contact support staff.' =>
            'Diese E-Mail-Adresse darf nicht registriert werden. Bitte wenden Sie sich an die Supportabteilung.',
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
        'Mark' => 'Markieren',
        'Unmark' => 'Nicht markieren',
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
        'Can\'t contact registration server. Please try again later.' => 'Registration-Server konnte nicht erreicht werden. Bitte versuchen Sie es später noch einmal.',
        'No content received from registration server. Please try again later.' =>
            'Registration-Server lieferte keinen Inhalt. Bitte versuchen Sie es später noch einmal.',
        'Problems processing server result. Please try again later.' => 'Beim Verarbeiten der Serverantwort ist ein Fehler aufgetreten. Bitte versuchen Sie es später noch einmal.',
        'Username and password do not match. Please try again.' => 'Benutzername und Passwort stimmen nicht überein. Bitte versuchen Sie es noch einmal.',
        'The selected process is invalid!' => 'Der ausgewählte Prozess ist ungültig.',

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
        'Can\'t update password, it must contain at least 2 lowercase and 2 uppercase characters!' =>
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
        'No (not supported)' => 'Nein (nicht unterstützt)',
        'Days' => 'Tage',
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

        # Template: AAASupportDataCollector
        'Unknown' => 'Unbekannt',
        'Information' => 'Information',
        'OK' => 'OK',
        'Problem' => 'Problem',
        'Webserver' => 'Webserver',
        'Operating System' => 'Betriebssystem',
        'OTRS' => 'OTRS',
        'Table Presence' => 'Prüfung Tabellenexistenz',
        'Internal Error: Could not open file.' => 'Interner Fehler: Konnte datei nicht öffnen.',
        'Table Check' => 'Prüfung Tabellenstatus',
        'Internal Error: Could not read file.' => 'Interner Fehler: Konnte datei nicht lesen.',
        'Tables found which are not present in the database.' => 'In der Datenbank fehlen Tabellen.',
        'Database Size' => 'Datenbank-Größe',
        'Could not determine database size.' => 'Konnte Datenbank-Größe nicht ermitteln',
        'Database Version' => 'Datenbank-Version',
        'Could not determine database version.' => 'Konnte Datenbank-Version nicht ermitteln',
        'Client Connection Charset' => 'Zeichensatz der Client-Verbindung',
        'Setting character_set_client needs to be utf8.' => 'Einstellung character_set_client muss utf8 sein.',
        'Server Database Charset' => 'Zeichensatz des Datenbank-Servers',
        'Setting character_set_database needs to be UNICODE or UTF8.' => 'Einstellung character_set_database muss UNICODE oder UTF8 sein.',
        'Table Charset' => 'Zeichensatz der Tabellen',
        'There were tables found which do not have utf8 as charset.' => 'Es wurden Tabellen gefunden, die nicht utf8 als Zeichensatz eingestellt haben.',
        'Maximum Query Size' => 'Maximale Anfragegröße',
        'The setting \'max_allowed_packet\' must be higher than 20 MB.' =>
            'Die Einstellung max_allowed_packet muss größer als 20 MB sein.',
        'Query Cache Size' => 'Größe Abfrage-Cache',
        'The setting \'query_cache_size\' should be used (higher than 10 MB but not more than 512 MB).' =>
            'Die Einstellung query_cache_size sollte genutzt werden (mehr als 10 MB aber nicht mehr als 512 MB).',
        'Default Storage Engine' => 'Standard-Storage-Engine',
        'Tables with a different storage engine than the default engine were found.' =>
            'Es wurden Tabellen gefunden, die nicht die Standard-Engine nutzen.',
        'MySQL 5.x or higher is required.' => 'MySQL 5.x oder höher wird benötigt.',
        'NLS_LANG Setting' => 'Einstellung NLS_LANG',
        'NLS_LANG must be set to AL32UTF8 (e.g. GERMAN_GERMANY.AL32UTF8).' =>
            'NLS_LANG muss auf AL32UTF8 stehen (z.B. GERMAN_GERMANY.AL32UTF8).',
        'NLS_DATE_FORMAT Setting' => 'Einstellung NLS_DATE_FORMAT',
        'NLS_DATE_FORMAT must be set to \'YYYY-MM-DD HH24:MI:SS\'.' => 'NLS_DATE_FORMAT muss auf \'YYYY-MM-DD HH24:MI:SS\' gesetzt sein.',
        'NLS_DATE_FORMAT Setting SQL Check' => 'SQL-Prüfung NLS_DATE_FORMAT',
        'Setting client_encoding needs to be UNICODE or UTF8.' => 'Einstellung client_encoding muss UNICODE oder UTF8 sein.',
        'Setting server_encoding needs to be UNICODE or UTF8.' => 'Einstellung server_encoding muss UNICODE oder UTF8 sein.',
        'Date Format' => 'Datumsformat',
        'Setting DateStyle needs to be ISO.' => 'Einstellung DateStyle muss ISO sein.',
        'PostgreSQL 8.x or higher is required.' => 'PostgreSQL 8.x oder höher wird benötigt.',
        'OTRS Disk Partition' => 'OTRS-Festplattenpartition',
        'Disk Usage' => 'Festplatten-Verwendung',
        'The partition where OTRS is located is almost full.' => 'Die Partition, auf der OTRS sich befindet, ist fast voll.',
        'The partition where OTRS is located has no disk space problems.' =>
            'Die Partition, auf der OTRS sich befindet, hat keine Platzprobleme.',
        'Disk Partitions Usage' => 'Verwendung Platten-Partitionen',
        'Distribution' => 'Distribution',
        'Could not determine distribution.' => 'Konnte Distribution nicht ermitteln.',
        'Kernel Version' => 'Kernelversion',
        'Could not determine kernel version.' => 'Konnte Kernelversion nicht ermitteln.',
        'System Load' => 'Systemlast (load)',
        'The system load should be at maximum the number of CPUs the system has (e.g. a load of 8 or less on a system with 8 CPUs is OK).' =>
            'Die Last sollte die Zahl der Systemprozessoren nicht übersteigen (also wäre eine Last von 8 oder weniger auf einem 8-Core-System in Ordnung).',
        'Perl Modules' => 'Perlmodule',
        'Not all required Perl modules are correctly installed.' => 'Nicht alle benötigten Perlmodle sind installiert',
        'Perl Version' => 'Perl Version',
        'Free Swap Space (%)' => 'Freier Auslagerungsspeicher (%)',
        'No Swap Enabled.' => 'Kein Auslagerungsspeicher aktiviert.',
        'Used Swap Space (MB)' => 'Verwendeter Auslagerungsspeicher (MB)',
        'There should be more than 60% free swap space.' => 'Es sollten mehr als 60% Auslagerungsspeicher verfügbar sein.',
        'There should be no more than 200 MB swap space used.' => 'Es sollten nicht mehr als 200 MB Auslagerungsspeicher verwendet werden.',
        'Config Settings' => 'Konfigurationseinstellungen',
        'Could not determine value.' => 'Konnte Wert nicht ermitteln.',
        'Database Records' => 'Datenbankeinträge',
        'Tickets' => 'Tickets',
        'Ticket History Entries' => 'Ticket-Historien-Einträge',
        'Articles' => 'Artikel',
        'Attachments (DB, Without HTML)' => 'Anhänge (in der Datenbank, ohne HTML)',
        'Customers With At Least One Ticket' => 'Kunden mit wenigstens einem Ticket',
        'Queues' => 'Queues',
        'Agents' => 'Agenten',
        'Roles' => 'Rollen',
        'Groups' => 'Gruppen',
        'Dynamic Fields' => 'Dynamische Felder',
        'Dynamic Field Values' => 'Werte in Dynamischen Feldern',
        'GenericInterface Webservices' => 'GenericInterface Webservices',
        'Processes' => 'Prozesse',
        'Months Between First And Last Ticket' => 'Monate zwischen erstem und letztem Ticket',
        'Tickets Per Month (avg)' => 'Tickets pro Monat (Durchschnitt)',
        'Default SOAP Username and Password' => 'Standard-SOAP-Benutzername und -Passwort',
        'Security risk: you use the default setting for SOAP::User and SOAP::Password. Please change it.' =>
            'Sicherheitsrisiko: Sie verwenden den Standard-SOAP-Benutzernamen und das Standardpasswort. Bitte ändern Sie diese Einstellungen.',
        'Default Admin Password' => 'Standard-Admin-Passwort',
        'Security risk: the agent account root@localhost still has the default password. Please change it or invalidate the account.' =>
            'Sicherheitsrisiko: Das Agentenpasswort für root@localhost ist das Standardpasswort. Bitte ändern Sie es oder deaktivieren Sie diesen Nutzer.',
        'Error Log' => 'Fehlerprotokoll',
        'There are error reports in your system log.' => 'Im System wurden Einträge im Fehlerprotokoll gefunden.',
        'File System Writable' => 'Schreibbarkeit Dateisystem',
        'The file system on your OTRS partition is not writable.' => 'Das Dateisystem auf Ihrer OTRS-Partition ist nicht schreibbar.',
        'Domain Name' => 'Domainname',
        'Your FQDN setting is invalid.' => 'Ihre Einstellung FQDN ist ungültig.',
        'Package installation status' => 'Status Paketinstallation',
        'Some packages are not correctly installed.' => 'Es wurden Pakete gefunden, die nicht korrekt installiert sind.',
        'Package List' => 'Paketliste',
        'SystemID' => 'SystemID',
        'Your SystemID setting is invalid, it should only contain digits.' =>
            'Ihre Einstellung SystemID ist ungültig, sie sollte nur Ziffern enthalten.',
        'OTRS Version' => 'OTRS-Version',
        'Ticket Index Module' => 'Ticket-Index-Modul',
        'You have more than 60,000 tickets and should use the StaticDB backend. See admin manual (Performance Tuning) for more information.' =>
            'Sie haben mehr als 60.000 Tickets und sollten das StaticDB-Backend verwenden. Bitte schauen Sie im Administratorhandbuch (Performance Tuning) nach.',
        'Open Tickets' => 'Offene Tickets',
        'You should not have more than 8,000 open tickets in your system.' =>
            'Sie sollten nicht mehr als 8.000 offene Tickets im System haben.',
        'Ticket Search Index module' => 'Ticket-Suchindex-Modul',
        'You have more than 50,000 articles and should use the StaticDB backend. See admin manual (Performance Tuning) for more information.' =>
            'Sie haben mehr als 50.000 Artikel und sollten das StaticDB-Backend verwenden. Bitte schauen Sie im Administratorhandbuch (Performance Tuning) nach.',
        'Orphaned Records In ticket_lock_index Table' => 'Verwaiste Einträge in der Tabelle ticket_lock_index',
        'Table ticket_lock_index contains orphaned records. Please run otrs/bin/otrs.CleanTicketIndex.pl to clean the StaticDB index.' =>
            'Die Tabelle ticket_lock_index enthält verwaiste Einträge. Bitte führen Sie otrs/bin/otrs.CleanTicketIndex.pl aus um sie zu entfernen.',
        'Orphaned Records In ticket_index Table' => 'Verwaiste Einträge in der Tabelle ticket_index.',
        'Table ticket_index contains orphaned records. Please run otrs/bin/otrs.CleanTicketIndex.pl to clean the StaticDB index.' =>
            'Die Tabelle ticket_index enthält verwaiste Einträge. Bitte führen Sie otrs/bin/otrs.CleanTicketIndex.pl aus um sie zu entfernen.',
        'Environment Variables' => 'Umgebungsvariablen',
        'Webserver Version' => 'Webserver-Version',
        'Could not determine webserver version.' => 'Konnte Webserver-Version nicht ermitteln.',
        'CGI Accelerator Usage' => 'Verwendung CGI-Beschleuniger',
        'You should use FastCGI or mod_perl to increase your performance.' =>
            'Sie sollten FastCGI oder mod_perl verwenden, um die Geschwindigkeit zu steigern.',
        'mod_deflate Usage' => 'Verwendung mod_deflate',
        'Please install mod_deflate to improve GUI speed.' => 'Bitte installieren Sie mod_deflate, um die Geschwindigkeit zu steigern.',
        'mod_headers Usage' => 'Verwendung mod_headers',
        'Please install mod_headers to improve GUI speed.' => 'Bitte installieren Sie mod_headers, um die Geschwindigkeit zu steigern.',
        'Apache::Reload Usage' => 'Verwendung Apache::Reload',
        'Apache::Reload or Apache2::Reload should be used as PerlModule and PerlInitHandler to prevent web server restarts when installing and upgrading modules.' =>
            'Apache::Reload oder Apache2::Reload sollten als PerlModule und PerlInitHandler verwendet werden, um Webserver-Neustarts nach Paketinstallation oder -upgrade zu vermeiden.',
        'Apache::DBI Usage' => 'Verwendung Apache::DBI',
        'Apache::DBI should be used to get a better performance  with pre-established database connections.' =>
            'Sie sollten Apache::DBI verwenden, um die Geschwindigkeit mit persistenten Datenbankverbindungen zu verbessern.',
        'You should use PerlEx to increase your performance.' => 'Sie sollten PerlEx verwenden, um die Geschwindigkeit zu steigern.',

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
        'Bounce Article to a different mail address' => 'Artikel per E-Mail umleiten',
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
        'email-external' => 'E-Mail extern',
        'email-internal' => 'E-Mail intern',
        'note-external' => 'Notiz extern',
        'note-internal' => 'Notiz intern',
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
        'Create' => 'Erstellen',
        'Answer' => 'Beantworten',
        'Phone call' => 'Anruf',
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
        'Edit Customer Users' => 'Kundenbenutzer bearbeiten',
        'Edit Customer' => 'Kunde bearbeiten',
        'Bulk Action' => 'Sammel-Aktion',
        'Bulk Actions on Tickets' => 'Sammel-Action an Tickets',
        'Send Email and create a new Ticket' => 'E-Mail senden und neues Ticket erstellen',
        'Create new Email Ticket and send this out (Outbound)' => 'Neues Ticket wird erstellt und E-Mail versendet',
        'Create new Phone Ticket (Inbound)' => 'Neues Ticket wird über einkommenden Anruf erstellt',
        'Address %s replaced with registered customer address.' => 'Adresse %s wurde durch die Adresse des eingetragenen Kunden ersetzt.',
        'Customer user automatically added in Cc.' => 'Kundenbenutzer wurde automatisch ins Cc eingetragen.',
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
        'Shown Columns' => 'Gezeigte Spalten',
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
        'Send me a notification if a customer sends a follow up and I\'m the owner of the ticket or the ticket is unlocked and is in one of my subscribed queues.' =>
            'Sende mir eine Benachrichtigung, wenn ein Kunde eine Rückmeldung gibt und ich der Besitzer des Tickets bin, oder das Ticket nicht gesperrt ist und in einer meiner Queues liegt.',
        'Send ticket follow up notifications' => 'Benachrichtigung bei Rückmeldung verschicken',
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
        'Ticket Information' => 'Ticket-Informationen',

        # Template: AAAWeekDay
        'Sun' => 'So',
        'Mon' => 'Mo',
        'Tue' => 'Di',
        'Wed' => 'Mi',
        'Thu' => 'Do',
        'Fri' => 'Fr',
        'Sat' => 'Sa',

        # Template: AdminACL
        'ACL Management' => 'ACL-Verwaltung',
        'Filter for ACLs' => 'Filter für ACLs',
        'Filter' => 'Filter',
        'ACL Name' => 'ACL-Name',
        'Actions' => 'Aktionen',
        'Create New ACL' => 'Neue ACL erstellen',
        'Deploy ACLs' => 'ACLs in Betrieb nehmen',
        'Export ACLs' => 'ACLs exportieren',
        'Configuration import' => 'Konfiguration importieren',
        'Here you can upload a configuration file to import ACLs to your system. The file needs to be in .yml format as exported by the ACL editor module.' =>
            'Hier können Sie über eine Konfigurationsdatei ACLs ins System importieren. Diese Datei muss das vom ACL Editor verwendeten .yml Format haben.',
        'This field is required.' => 'Dieses Feld wird benötigt.',
        'Overwrite existing ACLs?' => 'Existierende ACLs überschreiben?',
        'Upload ACL configuration' => 'ACL-Konfiguration hochladen',
        'Import ACL configuration(s)' => 'ACL-Konfiguration(en) importieren',
        'To create a new ACL you can either import ACLs which were exported from another system or create a complete new one.' =>
            'Wenn Sie eine ACL erstellen möchten, können Sie sie von einem anderen System importieren oder eine ganz neue erstellen.',
        'Changes to the ACLs here only affect the behavior of the system, if you deploy the ACL data afterwards. By deploying the ACL data, the newly made changes will be written to the configuration.' =>
            'Änderungen an den ACLs wirken sich erst aus, wenn sie die Konfiguration in Betrieb nehmen. Dabei werden die Änderungen in der Konfiguration gespeichert.',
        'ACLs' => 'ACLs',
        'Please note: This table represents the execution order of the ACLs. If you need to change the order in which ACLs are executed, please change the names of the affected ACLs.' =>
            'Hinweis: Diese Tabelle stellt die Ausführungsreihenfolge der ACLs dar. Wenn Sie die Reihenfolge ändern möchten, ändern Sie bitte die Namen der betroffenen ACLs.',
        'ACL name' => 'ACL-Name',
        'Validity' => 'Gültigkeit',
        'Copy' => 'Kopieren',
        'No data found.' => 'Keine Daten gefunden.',

        # Template: AdminACLEdit
        'Edit ACL %s' => 'ACL %s bearbeiten',
        'Go to overview' => 'Zurück zur Übersicht',
        'Delete ACL' => 'ACL löschen',
        'Delete Invalid ACL' => 'Ungültige ACL löschen',
        'Match settings' => 'Filterbedingungen',
        'Set up matching criteria for this ACL. Use \'Properties\' to match the current screen or \'PropertiesDatabase\' to match attributes of the current ticket that are in the database.' =>
            'Stellt die Filterbedingungen dieser ACL ein. Verwenden Sie \'Properties\' um den Wert aus dem aktuellen Bildschirm zu prüfen oder \'PropertiesDatabase\' für den Wert des Tickets, wie es in der Datenbank gespeichert ist.',
        'Change settings' => 'Wertänderungen',
        'Set up what you want to change if the criteria match. Keep in mind that \'Possible\' is a white list, \'PossibleNot\' a black list.' =>
            'Stellt die Wertänderungen ein für den Fall, dass die Filterbedingungen zutreffen. Hierbei ist \'Possible\' eine Positivliste und \'PossibleNot\' eine Negativliste.',
        'Check the official' => 'Prüfen Sie die offizielle',
        'documentation' => 'Dokumentation',
        'Show or hide the content' => 'Inhalt anzeigen oder ausblenden',
        'Edit ACL information' => 'ACL-Information bearbeiten',
        'Stop after match' => 'Stoppen nach Treffer',
        'Edit ACL structure' => 'ACL-Struktur bearbeiten',
        'Save' => 'Speichern',
        'or' => 'oder',
        'Save and finish' => 'Speichern und abschließen',
        'Do you really want to delete this ACL?' => 'Wollen Sie diese ACL wirklich löschen?',
        'This item still contains sub items. Are you sure you want to remove this item including its sub items?' =>
            'Dieser Eintrag enthält Untereinträge. Wollen Sie den Eintrag und alle Untereinträge wirklich löschen?',
        'An item with this name is already present.' => 'Ein Eintrag mit diesem Namen existiert bereits.',
        'Add all' => 'Alle hinzufügen',
        'There was an error reading the ACL data.' => 'Beim Lesen der ACL-Daten ist ein Fehler aufgetreten.',

        # Template: AdminACLNew
        'Create a new ACL by submitting the form data. After creating the ACL, you will be able to add configuration items in edit mode.' =>
            'Neue ACL Erstellen, durch Eingabe der Daten. Nach Anlage der ACL ist es möglich Konfigurations Parameter im Änderungsmodus einzufügen.',

        # Template: AdminAttachment
        'Attachment Management' => 'Anlagenverwaltung',
        'Add attachment' => 'Anlage hinzufügen',
        'List' => 'Liste',
        'Download file' => 'Datei herunterladen',
        'Delete this attachment' => 'Diesen Anhang entfernen',
        'Add Attachment' => 'Anhang hinzufügen',
        'Edit Attachment' => 'Anhang bearbeiten',

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
        'Customer Management' => 'Kundenverwaltung',
        'Wildcards like \'*\' are allowed.' => 'Platzhalter wie \'*\' sind erlaubt.',
        'Add customer' => 'Kunde hinzufügen',
        'Select' => 'Auswahl',
        'Please enter a search term to look for customers.' => 'Bitte geben Sie einen Suchbegriff ein, um nach Kunden zu suchen.',
        'Add Customer' => 'Kunde hinzufügen',

        # Template: AdminCustomerUser
        'Customer User Management' => 'Kundenbenutzerverwaltung',
        'Back to search results' => 'Zurück zum Suchergebnis',
        'Add customer user' => 'Kundenbenutzer hinzufügen',
        'Hint' => 'Hinweis',
        'Customer user are needed to have a customer history and to login via customer panel.' =>
            'Kundenbenutzer werden für die Bereitstellung einer Kundenhistorie und für die Anmeldung über den Kundenzugang benötigt.',
        'Last Login' => 'Letzte Anmeldung',
        'Login as' => 'Anmelden als',
        'Switch to customer' => 'Zum Kunden wechseln',
        'Add Customer User' => 'Kundenbenutzer hinzufügen',
        'Edit Customer User' => 'Kundenbenutzer bearbeiten',
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
        'Edit Customer Default Groups' => 'Standardgruppen für Kunden bearbeiten',
        'These groups are automatically assigned to all customers.' => 'Diese Gruppen werden allen Kunden automatisch zugewiesen.',
        'You can manage these groups via the configuration setting "CustomerGroupAlwaysGroups".' =>
            'Sie können diese Gruppen mit der Konfigurationseinstellung "CustomerGroupAlwaysGroups" bearbeiten.',
        'Filter for Groups' => 'Filter für Gruppen',
        'Just start typing to filter...' => 'Beginnen Sie mit der Eingabe zum zu filtern...',
        'Select the customer:group permissions.' => 'Wählen sie die Kunde:Gruppe-Rechte aus',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer).' =>
            'Wenn nichts ausgewählt ist, hat der Kunde in dieser Gruppe keine Rechte (und kann nicht auf Tickets zugreifen).',
        'Search Results' => 'Suchergebnisse',
        'Customers' => 'Kunden',
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
        'To add a new field, select the field type from one of the object\'s list, the object defines the boundary of the field and it can\'t be changed after the field creation.' =>
            'Um ein neues Feld hinzuzufügen, wählen Sie den Feld-Typ aus der Liste der verfügbaren Typen für das jeweilige Objekt aus. Die Objekt-Auswahl ist bindend und kann nicht nachträglich verändert werden.',
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
        'Restrict entering of dates' => 'Eingabe von Daten einschränken',
        'Here you can restrict the entering of dates of tickets.' => 'Hier können Sie die Eingabe von Daten in dieses Feld einschränken.',

        # Template: AdminDynamicFieldDropdown
        'Possible values' => 'Mögliche Werte',
        'Key' => 'Schlüssel',
        'Value' => 'Wert',
        'Remove value' => 'Wert löschen',
        'Add value' => 'Wert hinzufügen',
        'Add Value' => 'Wert hinzufügen',
        'Add empty value' => 'Leeren Wert hinzufügen',
        'Activate this option to create an empty selectable value.' => 'Aktivieren Sie diese Einstellung, um einen leeren Auswahlwert zu erzeugen.',
        'Tree View' => 'Baumansicht',
        'Activate this option to display values as a tree.' => 'Aktivieren Sie diese Option um die Werte als Baum anzuzeigen.',
        'Translatable values' => 'Wertübersetzung',
        'If you activate this option the values will be translated to the user defined language.' =>
            'Wenn Sie diese Einstellung aktivieren, werden die Werte in die Sprache des Benutzers übersetzt.',
        'Note' => 'Notiz',
        'You need to add the translations manually into the language translation files.' =>
            'Sie müssen die Übersetzungen manuell zu den Übersetzungsdateien hinzufügen.',

        # Template: AdminDynamicFieldText
        'Number of rows' => 'Anzahl der Zeilen',
        'Specify the height (in lines) for this field in the edit mode.' =>
            'Gibt die Anzahl der Zeilen für diese Feld im Bearbeitungsmodus an.',
        'Number of cols' => 'Anzahl der Spalten',
        'Specify the width (in characters) for this field in the edit mode.' =>
            'Gibt die Breite in Zeichen für dieses Feld im Bearbeitungsmodus an.',
        'Check RegEx' => 'Auf RegEx prüfen',
        'Here you can specify a regular expression to check the value. The regex will be executed with the modifiers xms.' =>
            'Hier können Sie einen regulären Ausdruck definieren um den Wert zu prüfen. Der RegEx wird mit den Modifikatoren xms ausgeführt.',
        'RegEx' => 'RegEx',
        'Invalid RegEx' => 'Ungültige RegEx',
        'Error Message' => 'Fehlermeldung',
        'Add RegEx' => 'RegEx hinzufügen',

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
        'The name you entered already exists.' => 'Der eingegebene Name existiert bereits',
        'Toggle this widget' => 'Dieses Widget umschalten',
        'Automatic execution (multiple tickets)' => 'Automatische Ausführung (mehrere Tickets)',
        'Execution Schedule' => 'Ausführungsplan',
        'Schedule minutes' => 'Ausführen zu Minute(n)',
        'Schedule hours' => 'Ausführen zu Stunde(n)',
        'Schedule days' => 'Ausführen an Tag(en)',
        'Currently this generic agent job will not run automatically.' =>
            'Derzeit würde dieser GenericAgentJob nicht automatisch ausgeführt werden.',
        'To enable automatic execution select at least one value from minutes, hours and days!' =>
            'Um ihn automatisch auszuführen muß mindestens ein Wert von Minuten, Stunden und Tagen ausgewählt werden!',
        'Event based execution (single ticket)' => 'Event-gesteuerte Ausführung (einzelnes Ticket)',
        'Event Triggers' => 'Event-Trigger',
        'List of all configured events' => 'Alle konfigurierten Events anzeigen',
        'Delete this event' => 'Dieses Event löschen',
        'Additionally or alternatively to a periodic execution, you can define ticket events that will trigger this job.' =>
            'Zusätzlich oder alternativ zur periodischen Ausführung können Sie Ticket-Events angeben, bei denen dieser Job ausgeführt werden soll.',
        'If a ticket event is fired, the ticket filter will be applied to check if the ticket matches. Only then the job is run on that ticket.' =>
            'Wenn ein Ticket-Event ausgelöst wird, wird zunächst der Ticketfilter angewendet um zu prüfen, ob das Ticket betroffen ist. Erst danach wird der Job ggf. für dieses Ticket ausgeführt.',
        'Do you really want to delete this event trigger?' => 'Wollen Sie diesen Event-Trigger wirklich löschen?',
        'Add Event Trigger' => 'Event-Trigger hinzufügen',
        'To add a new event select the event object and event name and click on the "+" button' =>
            'Um einen neuen Event hinzuzufügen, wählen Sie bitte das Objekt und den Eventnamen und klicken Sie auf den "+"-Knopf',
        'Duplicate event.' => 'Doppeltes Event',
        'This event is already attached to the job, Please use a different one.' =>
            'Dieses Event ist dem Job bereits zugeordnet. Bitte wählen Sie ein anderes aus.',
        'Delete this Event Trigger' => 'Diesen Event-Trigger löschen',
        'Select Tickets' => 'Tickets selektieren',
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
        'Last changed times' => 'Letzte Änderungszeitpunkte',
        'No last changed time settings.' => 'Keine Einstellungen für letzte Änderungszeit.',
        'Ticket last changed' => 'Ticket zuletzt geändert',
        'Ticket last changed between' => 'Ticket zuletzt geändert zwischen',
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
        'Update/Add Ticket Attributes' => 'Ticket Attribute Aktualisieren/Hinzufügen',
        'Set new service' => 'Neuen Service setzen',
        'Set new Service Level Agreement' => 'Neues Service-Level-Abkommen setzen',
        'Set new priority' => 'Neue Priorität setzen',
        'Set new queue' => 'Neue Queue setzen',
        'Set new state' => 'Neuen Status setzen',
        'Pending date' => 'Warten bis',
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
        'Execute Ticket Commands' => 'Ticket-Befehle ausführen',
        'Send agent/customer notifications on changes' => 'Sende eine Agent/Kunden Benachrichtigung bei Änderungen',
        'CMD' => 'CMD',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' =>
            'Dieser Befehl wird mit ARG[0] (die Ticket Nummer) und ARG[1] die TicketID ausgeführt.',
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
        'Remote IP' => 'Remote-IP',
        'Loading' => 'Lade...',
        'Select a single request to see its details.' => 'Wählen Sie eine Anfrage aus, um die Details zu sehen.',
        'Filter by type' => 'Filtern nach Typ',
        'Filter from' => 'Filter von',
        'Filter to' => 'Filter bis',
        'Filter by remote IP' => 'Filter nach Remote-IP',
        'Refresh' => 'Aktualisieren',
        'Request Details' => 'Anfragedetails',
        'An error occurred during communication.' => 'Während der Kommunikation ist ein Fehler aufgetreten',
        'Show or hide the content.' => 'Inhalt anzeigen oder verbergen.',
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
        'Asynchronous' => 'Asynchron',
        'This invoker will be triggered by the configured events.' => 'Dieser Invoker wird von den konfigurierten Events ausgelöst.',
        'Asynchronous event triggers are handled by the OTRS Scheduler in background (recommended).' =>
            'Asynchrone Event-Trigger werden vom OTRS-Scheduler im Hintergrund verarbeitet (empfohlen).',
        'Synchronous event triggers would be processed directly during the web request.' =>
            'Synchrone Event-Trigger werden direkt während des laufenden Web-Requests verarbeitet.',
        'Save and continue' => 'Speichern und weiter',
        'Delete this Invoker' => 'Diesen Invoker löschen',

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

        # Template: AdminGenericInterfaceTransportHTTPREST
        'GenericInterface Transport HTTP::REST for Web Service %s' => 'GenericInterface Transport HTTP::REST für Webservice %s',
        'Network transport' => 'Netzwerk-Transport',
        'Properties' => 'Eigenschaften',
        'Route mapping for Operation' => 'Route-Mapping für Operationen',
        'Define the route that should get mapped to this operation. Variables marked by a \':\' will get mapped to the entered name and passed along with the others to the mapping. (e.g. /Ticket/:TicketID).' =>
            'Definiert den Weg, der zu der Operation gemappt werden soll. Variablen, die mit einem \':\' markiert sind, werden zu dem eingegeben Namen gemappt und mit den anderen Variablen an die Funktion übergeben. (z.B.: /Ticket/:TicketID)',
        'Valid request methods for Operation' => 'Gültige Anfrage-Methoden für Operation',
        'Limit this Operation to specific request methods. If no method is selected all requests will be accepted.' =>
            'Beschränken Sie diese Operation auf bestimmte Anfrage-Methoden. Wenn keine Methode ausgewählt ist, werden alle Anfragen akzeptiert.',
        'Maximum message length' => 'Maximale Nachrichtenlänge',
        'This field should be an integer number.' => 'Dieses Feld sollte eine Ganzzahl beinhalten.',
        'Here you can specify the maximum size (in bytes) of REST messages that OTRS will process.' =>
            'Bestimmen Sie die maximale Größe (in Bytes) für REST-Nachrichten, die OTRS akzeptieren soll.',
        'Send Keep-Alive' => 'Keep-Alive senden',
        'This configuration defines if incoming connections should get closed or kept alive.' =>
            'Bestimmt, ob eingehende Verbindungen geschlossen oder am Leben erhalten werden sollen.',
        'Host' => 'Host',
        'Remote host URL for the REST requests.' => 'URL des Remote-Hosts für REST-Anfragen.',
        'e.g https://www.otrs.com:10745/api/v1.0 (without trailing backslash)' =>
            'z. B. https://www.otrs.com:10745/api/v1.0 (ohne abschließenden Backslash)',
        'Controller mapping for Invoker' => 'Controller-Mapping für Invoker',
        'The controller that the invoker should send requests to. Variables marked by a \':\' will get replaced by the data value and passed along with the request. (e.g. /Ticket/:TicketID?UserLogin=:UserLogin&Password=:Password).' =>
            'Der Controller an den der Invoker Anfragen senden soll. Variablen, die mit einem \':\' markiert sind, werden durch den Datenwert ersetzt und mit dem Request übergeben. (z.B.: /Ticket/:TicketID?UserLogin=:UserLogin&Password=:Password)',
        'Valid request command for Invoker' => 'Gültiger Anforderungsbefehl für Invoker',
        'A specific HTTP command to use for the requests with this Invoker (optional).' =>
            'Ein spezifisches HTTP-Kommando um Anfragen mit diesem Invoker zu verwenden (optional).',
        'Default command' => 'Standardbefehl',
        'The default HTTP command to use for the requests.' => 'Der Standard-HTTP-Befehl für die Anfragen.',
        'Authentication' => 'Authentifizierung',
        'The authentication mechanism to access the remote system.' => 'Die Authentifizierungsmethode für den Zugriff auf das entfernte System.',
        'A "-" value means no authentication.' => 'Der Wert "-" bedeutet keine Authentifizierung.',
        'The user name to be used to access the remote system.' => 'Der Benutzername für den Zugriff auf das entfernte System.',
        'The password for the privileged user.' => 'Dass Passwort des berechtigten Benutzers.',
        'Use SSL Options' => 'SSL-Optionen verwenden',
        'Show or hide SSL options to connect to the remote system.' => 'Optionen für die Verwendung von SSL zum Zugriff auf das entfernte System anzeigen oder verbergen.',
        'Certificate File' => 'Zertifikatsdatei',
        'The full path and name of the SSL certificate file.' => 'Der vollständige Pfad und Name der SSL-Zertifikats-Datei',
        'e.g. /opt/otrs/var/certificates/REST/ssl.crt' => 'Zum Beispiel: /opt/otrs/var/certificates/REST/ssl.crt',
        'Certificate Password File' => 'Passwortdatei für Zertifikat',
        'The full path and name of the SSL key file.' => 'Der vollständige Pfad und Name der SSL-Schlüsseldatei.',
        'e.g. /opt/otrs/var/certificates/REST/ssl.key' => 'Zum Beispiel: /opt/otrs/var/certificates/REST/ssl.key',
        'Certification Authority (CA) File' => 'Datei der Certification Authority (CA)',
        'The full path and name of the certification authority certificate file that validates the SSL certificate.' =>
            'Der vollständige Pfad und Name der Zertifizierungsstellen-Zertifikatsdatei, die das SSL-Zertifikat bestätigt.',
        'e.g. /opt/otrs/var/certificates/REST/CA/ca.file' => 'Zum Beispiel: /opt/otrs/var/certificates/REST/CA/ca.file',

        # Template: AdminGenericInterfaceTransportHTTPSOAP
        'GenericInterface Transport HTTP::SOAP for Web Service %s' => 'GenericInterface Transport HTTP::SOAP für Webservice %s',
        'Endpoint' => 'Endpunkt',
        'URI to indicate a specific location for accessing a service.' =>
            'URI für den Zugriff auf einen Webservice.',
        'e.g. http://local.otrs.com:8000/Webservice/Example' => 'z. B. http://local.otrs.com:8000/Webservice/Example',
        'Namespace' => 'Namespace',
        'URI to give SOAP methods a context, reducing ambiguities.' => 'URI, die SOAP-Methoden einen Kontext gibt und damit Mehrdeutigkeiten auflöst.',
        'e.g urn:otrs-com:soap:functions or http://www.otrs.com/GenericInterface/actions' =>
            'z. B. urn:otrs-com:soap:functions oder http://www.otrs.com/GenericInterface/actions',
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
        'The full path and name of the SSL certificate file (must be in .p12 format).' =>
            'Voller Pfad und Dateiname des SSL-Zertifikats (muss im .p12-Format vorliegen).',
        'e.g. /opt/otrs/var/certificates/SOAP/certificate.p12' => 'z. B. /opt/otrs/var/certificates/SOAP/certificate.p12',
        'The password to open the SSL certificate.' => 'Das Passwort für den Zugriff auf das SSL-Zertifikat.',
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
        'Remote system' => 'Remote-System',
        'Provider transport' => 'Provider-Transport',
        'Requester transport' => 'Requester-Transport',
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
        'Online Admin Manual' => 'Online-Administrationshandbuch',

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
        'Ticket Filter' => 'Ticketfilter',
        'Article Filter' => 'Artikelfilter',
        'Only for ArticleCreate and ArticleSend event' => 'Nur für die Events ArticleCreate und ArticleSend',
        'Article type' => 'Artikeltyp',
        'If ArticleCreate or ArticleSend is used as a trigger event, you need to specify an article filter as well. Please select at least one of the article filter fields.' =>
            'Wenn ArticleCreate oder ArticleSend aus auslösendes Ereignis verwendet werden, müssen Sie ebenfalls einen ArtikelFilter spezifizieren. Bitte wählen Sie mindestens eins der Artikelfilterfelder aus.',
        'Article sender type' => 'Sender-Typ des Artikels',
        'Subject match' => 'Suchbegriff im Betreff',
        'Body match' => 'Suchbegriff im Text',
        'Include attachments to notification' => 'Anlagen an Benachrichtigung anfügen',
        'Recipient' => 'Empfänger',
        'Recipient groups' => 'Empfänger-Gruppen',
        'Recipient agents' => 'Empfänger-Agenten',
        'Recipient roles' => 'Empfänger-Rollen',
        'Recipient email addresses' => 'Empfänger-E-Mail-Adressen',
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
        'Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            'Stellen Sie sicher, dass Ihre Datenbank Pakete über %s MB akzeptiert (Derzeit werden nur Pakete bis %s MB akzeptiert). Bitte passen Sie die Einstellung max_allowed_packet Ihrer Datenbank-Konfiguration an, um Fehler zu vermeiden.',
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
        'This package is verified by OTRSverify (tm)' => 'Dieses Paket wurde von OTRSVerify (tm) geprüft',
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
        'last' => 'letzten',
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
        'The name is required.' => 'Der Name ist erforderlich.',
        'Filter Condition' => 'Filterbedingung',
        'AND Condition' => 'UND-Bedingung',
        'Check email header' => 'Zu überprüfender E-Mail Header',
        'Negate' => 'Negieren',
        'Look for value' => 'Nach dem Wert suchen',
        'The field needs to be a valid regular expression or a literal word.' =>
            'Dieses Feld sollte einen gültigen regulären Ausdruck oder ein Wort enthalten.',
        'Set Email Headers' => 'E-Mail-Kopfzeilen setzen',
        'Set email header' => 'Setze E-Mail Header',
        'Set value' => 'Setze Wert',
        'The field needs to be a literal word.' => 'Dieses Feld sollte ein Wort enthalten.',

        # Template: AdminPriority
        'Priority Management' => 'Priorität-Verwaltung',
        'Add priority' => 'Priorität hinzufügen',
        'Add Priority' => 'Priorität hinzufügen',
        'Edit Priority' => 'Priorität bearbeiten',

        # Template: AdminProcessManagement
        'Process Management' => 'Prozess-Management',
        'Filter for Processes' => 'Filter für Prozesse',
        'Create New Process' => 'Neuen Prozess erstellen',
        'Deploy All Processes' => 'Alle Prozesse speichern',
        'Here you can upload a configuration file to import a process to your system. The file needs to be in .yml format as exported by process management module.' =>
            'Hier können Sie eine Konfigurationdatei hochladen, um einen Prozess in Ihr System zu importieren. Die Datei muss im YAML-Format vorliegen, so wie sie vom Prozessmanagement auch exportiert wird.',
        'Overwrite existing entities' => 'Bestehende Einträge überschreiben',
        'Upload process configuration' => 'Prozesskonfiguration hochladen',
        'Import process configuration' => 'Prozesskonfiguration importieren',
        'To create a new Process you can either import a Process that was exported from another system or create a complete new one.' =>
            'Um einen neuen Prozess zu erstellen können Sie entweder einen Prozess aus einem anderen System importieren oder einen ganz neuen erstellen.',
        'Changes to the Processes here only affect the behavior of the system, if you synchronize the Process data. By synchronizing the Processes, the newly made changes will be written to the Configuration.' =>
            'Änderungen an den Prozessen wirken sich erst dann aus, wenn Sie die Prozesskonfiguration synchronisieren. Dabei werden alle Änderungen in die Systemkonfiguration übernommen.',
        'Process name' => 'Prozessname',
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
        'Please note that customer users will not be able to see or use the following fields: Owner, Responsible, Lock, PendingTime and CustomerID.' =>
            'Bitte beachten Sie, dass Kunden-Benutzer die folgenden Felder nicht sehen oder benutzen können: Besitzer (Owner), Verantwortlicher (Responsible), Sperre (Lock), Warten bis (PendingTime) und Kundennummer (CustomerID).',
        'The Queue field can only be used by customers when creating a new ticket.' =>
            'Das Feld Queue kann nur von Kunden ausgewählt werden, wenn diese ein neues Ticket erstellen.',
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
        'Process Name' => 'Prozessname',
        'The selected state does not exist.' => 'Der ausgewählte Status existiert nicht.',
        'Add and Edit Activities, Activity Dialogs and Transitions' => 'Aktivitäten, Aktivitäts-Dialoge und Übergänge hinzufügen und bearbeiten',
        'Show EntityIDs' => 'EntityIDs einblenden',
        'Extend the width of the Canvas' => 'Die Breite der Zeichenfläche vergrößern',
        'Extend the height of the Canvas' => 'Die Höhe der Zeichenfläche vergrößern',
        'Remove the Activity from this Process' => 'Aktivität aus diesem Prozess entfernen',
        'Edit this Activity' => 'Diese Aktivität bearbeiten',
        'Save settings' => 'Einstellungen speichern',
        'Save Activities, Activity Dialogs and Transitions' => 'Aktivitäten, Aktivitätsdialoge und Übergänge speichern',
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

        # Template: AdminQueueTemplates
        'Manage Template-Queue Relations' => 'Vorlagen-Queue-Zuordnungen verwalten',
        'Filter for Templates' => 'Filter für Vorlagen',
        'Templates' => 'Vorlagen',
        'Change Queue Relations for Template' => 'Queue-Zuordnungen für Vorlage verändern',
        'Change Template Relations for Queue' => 'Vorlagen-Zuordnungen für Queue verändern',

        # Template: AdminRegistration
        'System Registration Management' => 'Systemregistrierungs-Verwaltung',
        'Edit details' => 'Details bearbeiten',
        'Deregister system' => 'System deregistrieren',
        'Overview of registered systems' => 'Übersicht der registrieren Systeme',
        'System Registration' => 'Systemregistrierung',
        'This system is registered with OTRS Group.' => 'Dieses System ist bei der OTRS Gruppe registriert.',
        'System type' => 'System Typ',
        'Unique ID' => 'Unique ID',
        'Last communication with registration server' => 'Letzte Kommunikation mit dem Registrierungsserver',
        'Send support data' => 'Supportdaten senden',
        'OTRS-ID Login' => 'OTRS-ID Login',
        'System registration is a service of OTRS Group, which provides a lot of advantages!' =>
            'Die Systemregistrierung ist ein Service der OTRS Gruppe, der Ihnen viele Vorteile sichert!',
        'Read more' => 'Mehr erfahren',
        'You need to log in with your OTRS-ID to register your system.' =>
            'Um Ihr System zu registrieren, loggen Sie sich bitte mit Ihrer OTRS-ID ein.',
        'Your OTRS-ID is the email address you used to sign up on the OTRS.com webpage.' =>
            'Verwenden Sie dazu die E-Mail-Adresse, mit der Sie sich auf der OTRS Webseite angemeldet haben.',
        'Data Protection' => 'Datenschutz',
        'What are the advantages of system registration?' => 'Welche Vorteile bietet die Systemregistrierung?',
        'You will receive updates about relevant security releases.' => 'Bei sicherheitsrelevanten Releases werden Sie benachrichtigt.',
        'With your system registration we can improve our services for you, because we have all relevant information available.' =>
            'Die Registrierung Ihres Systems ermöglicht es der OTRS Gruppe, Sie schneller und effizienter zu betreuen, weil uns wichtige Informationen über Ihr System bereits vorliegen, die ein mehrmaliges Nachfragen unnötig machen.',
        'This is only the beginning!' => 'Und das ist erst der Anfang!',
        'We will inform you about our new services and offerings soon.' =>
            'Seien Sie gespannt auf weitere Möglichkeiten, die wir Ihnen vorstellen werden.',
        'Can I use OTRS without being registered?' => 'Kann ich OTRS auch ohne Registrierung nutzen?',
        'System registration is optional.' => 'Die Systemregistrierung ist optional.',
        'You can download and use OTRS without being registered.' => 'Sie können OTRS auch ohne Registrierung im vollen Umfang downloaden und nutzen.',
        'Is it possible to deregister?' => 'Kann ich meine Registrierung rückgängig machen?',
        'You can deregister at any time.' => 'Sie können Ihr System jederzeit deregistrieren.',
        'Which data is transfered when registering?' => 'Welche Daten werden bei der Registrierung übertragen?',
        'A registered system sends the following data to OTRS Group:' => 'Ein registriertes System überträgt folgende Daten an die OTRS Gruppe:',
        'Fully Qualified Domain Name (FQDN), OTRS version, Database, Operating System and Perl version.' =>
            'Fully Qualified Domain Name (FQDN), OTRS Version, Datenbank, Betriebssystem und Perl Version.',
        'Why do I have to provide a description for my system?' => 'Warum muss das System beschrieben werden?',
        'The description of the system is optional.' => 'Die Beschreibung des Systems ist optional.',
        'The description and system type you specify help you to identify and manage the details of your registered systems.' =>
            'Der Systemtyp und die Beschreibung hilft Ihnen, Ihre Systeme zu identifizieren und die Systemregistrierung zu verwalten.',
        'How often does my OTRS system send updates?' => 'Wie oft sendet mein OTRS Updates?',
        'Your system will send updates to the registration server at regular intervals.' =>
            'Ihr System sendet in regelmäßigen Abständen Updates an den Registrierungsserver.',
        'Typically this would be around once every three days.' => 'In der Regel findet eine Übertragung an jedem dritten Tag statt.',
        'In case you would have further questions we would be glad to answer them.' =>
            'Sollten Sie weitere Fragen haben, freuen wir uns, diese zu beantworten.',
        'Please visit our' => 'Besuchen Sie einfach unser',
        'portal' => 'Portal,',
        'and file a request.' => 'um eine Anfrage zu stellen.',
        'Here at OTRS Group we take the protection of your personal details very seriously and strictly adhere to data protection laws.' =>
            'Die OTRS-Gruppe nimmt den Schutz Ihrer persönlichen Daten sehr ernst und hält sich strikt an Datenschutzgesetze.',
        'All passwords are automatically made unrecognizable before the information is sent.' =>
            'Alle Passwörter werden automatisch unkenntlich gemacht, bevor Informationen gesendet werden.',
        'Under no circumstances will any data we obtain be sold or passed on to unauthorized third parties.' =>
            'Unter keinen Umständen werden jegliche Daten verkauft oder an unauthorisierte Dritte weitergegeben.',
        'The following explanation provides you with an overview of how we guarantee this protection and which type of data is collected for which purpose.' =>
            'Die nachfolgende Erklärung gibt Ihnen einen Überblick darüber, wie wir diesen Schutz gewährleisten und welche Art von Daten zu welchem ​​Zweck erhoben werden.',
        'Data Handling with \'System Registration\'' => 'Datenverarbeitung bei \'Systemregistrierung\'',
        'Information received through the \'Service Center\' is saved by OTRS Group.' =>
            'Informationen welche über das \'Service Center\' gesendet werden, werden von der OTRS Group gespeichert.',
        'This only applies to data that OTRS Group requires to analyze the performance and function of the OTRS server or to establish contact.' =>
            'Das trifft nur auf Daten zu, die die OTRS Group zur Performance- und Funktions-Analyse des OTRS-Servers oder zur Kontaktaufnahme benötigt.',
        'Safety of Personal Details' => 'Sicherheit von persönlichen Details',
        'OTRS Group protects your personal data from unauthorized access, use or publication.' =>
            'Die OTRS Group schützt Ihre persönlichen Daten von unauthorisiertem Zugriff.',
        'OTRS Group ensures that the personal information you store on the server is protected from unauthorized access and publication.' =>
            'Die OTRS Group versichert, dass Ihre auf dem Server gespeicherten persönlichen Daten vor unauthorisiertem Zugriff geschützt sind.',
        'Disclosure of Details' => 'Offenlegung von Details',
        'OTRS Group will not pass on your details to third parties unless required for business transactions.' =>
            'Die OTRS Gruppe wird Ihre Daten nicht an Dritte weitergeben, es sei denn diese werden zur weiteren Geschäftsabwicklung benötigt.',
        'OTRS Group will only pass on your details to entitled public institutions and authorities if required by law or court order.' =>
            'Die OTRS Gruppe wird Ihre Daten nur an öffentliche Einrichtungen und Behörden weiterleiten, wenn dies per Gesetz oder per Gerichtsbeschluss erforderlich ist.',
        'Amendment of Data Protection Policy' => 'Änderung der Datenschutzbestimmungen',
        'OTRS Group reserves the right to amend this security and data protection policy if required by technical developments.' =>
            'Die OTRS Group behält sich vor Sicherheits- und Datenschutzbestimmungen, wenn diese durch technische Entwicklungen notwendig sind, zu ändern',
        'In this case we will also adapt our information regarding data protection accordingly.' =>
            'In diesem Fall werden wir ebenfalls unsere Datenschutzbestimmungen anpassen.',
        'Please regularly refer to the latest version of our Data Protection Policy.' =>
            'Bitte überprüfen Sie regelmäßig ob eine neuere Version  unserer Datenschutzerklärung verfügbar ist.',
        'Right to Information' => 'Anspruch auf Information',
        'You have the right to demand information concerning the data saved about you, its origin and recipients, as well as the purpose of the data processing at any time.' =>
            'Sie haben jederzeit das Recht Einsicht in Daten die zu Ihrer Person gespeichert sind, deren Herkunft und Empfänger zu verlangen, sowie den Zweck der Datenverarbeitung zu erfahren.',
        'You can request information about the saved data by sending an e-mail to info@otrs.com.' =>
            'Sie können die über Sie gespeicherten Daten durch eine E-Mail an info@otrs.com anfordern.',
        'Further Information' => 'Weitere Informationen',
        'Your trust is very important to us. We are willing to inform you about the processing of your personal details at any time.' =>
            'Ihr Vertrauen ist uns sehr wichtig. Wir sind bereit, Sie über die Verarbeitung Ihrer personenbezogenen Daten jederzeit zu informieren.',
        'If you have any questions that have not been answered by this Data Protection Policy or if you require more detailed information about a specific topic, please contact info@otrs.com.' =>
            'Wenn Sie weitere Fragen haben, die durch diese Datenschutzerklärung nicht beantwortet werden konnten oder wenn Sie nähere Informationen zu einem bestimmten Thema benötigen, wenden Sie sich an info@otrs.com.',
        'If you deregister your system, you will lose these benefits:' =>
            'Wenn Sie ihre Systemregistrierung löschen, verlieren Sie folgende Vorteile:',
        'You need to log in with your OTRS-ID to deregister your system.' =>
            'Um Ihr System zu deregistrieren, loggen Sie sich bitte mit Ihrer OTRS-ID ein.',
        'OTRS-ID' => 'OTRS-ID',
        'You don\'t have an OTRS-ID yet?' => 'Sie haben noch keine OTRS-ID?',
        'Sign up now' => 'Registrieren Sie sich jetzt',
        'Forgot your password?' => 'Passwort vergessen?',
        'Retrieve a new one' => 'Neues anfordern',
        'This data will be frequently transferred to OTRS Group when you register this system.' =>
            'Wenn Sie dieses System registrieren, werden folgende Daten in regelmäßigen Abständen an die OTRS Gruppe übertragen.',
        'Attribute' => 'Attribut',
        'FQDN' => 'FQDN',
        'Optional description of this system.' => 'Optionale Beschreibung für dieses System.',
        'This will allow the system to send additional support data information to OTRS Group.' =>
            'Diese Einstellung aktiviert das Senden zusätzlicher Support-Informationen an die OTRS Gruppe.',
        'Service Center' => 'Service-Zentrum',
        'Support Data Management' => 'Support-Daten-Verwaltung',
        'Register' => 'Registrieren',
        'Deregister System' => 'System deregistrieren',
        'Continuing with this step will deregister the system from OTRS Group.' =>
            'Wenn Sie fortfahren, wird dieses System bei der OTRS Gruppe deregistriert.',
        'Deregister' => 'Deregistrieren',
        'You can modify registration settings here.' => 'Sie können ihre Registrierungseinstellungen hier bearbeiten.',

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
        'Filter for S/MIME certs' => 'Filter für S/MIME Zertifikate',
        'To show certificate details click on a certificate icon.' => 'Zertifikatsdetails können Sie mit einem Klick auf das Zertifikats-Icon aufrufen.',
        'To manage private certificate relations click on a private key icon.' =>
            'Um Zertifikats-Zugehörigkeiten zu verwalten können Sie auf das Icon eines privaten Schlüssels klicken.',
        'Here you can add relations to your private certificate, these will be embedded to the S/MIME signature every time you use this certificate to sign an email.' =>
            'Hier können Sie Beziehungen zu Ihren privaten Zertifikat hinzufügen, diese werden jedes Mal zur  S/MIME-Signatur hinzugefügt, wenn Sie dieses Zertifikat verwenden um eine E-Mail zu signieren.',
        'See also' => 'Siehe auch',
        'In this way you can directly edit the certification and private keys in file system.' =>
            'Über diesen Weg können die Zertifikate und privaten Schlüssel im Dateisystem bearbeitet werden.',
        'Hash' => 'Hash',
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
        'Close window' => 'Fenster schließen',

        # Template: AdminSalutation
        'Salutation Management' => 'Anreden-Verwaltung',
        'Add salutation' => 'Anrede hinzufügen',
        'Add Salutation' => 'Anrede hinzufügen',
        'Edit Salutation' => 'Anrede bearbeiten',
        'Example salutation' => 'Beispiel-Anrede',

        # Template: AdminSecureMode
        'Secure mode needs to be enabled!' => 'Sicherheitsmodus muss eingeschaltet sein!',
        'Secure mode will (normally) be set after the initial installation is completed.' =>
            'Der Sicherheitsmodus wird normalerweise eingeschaltet, nachdem die Installation abgeschlossen ist.',
        'If secure mode is not activated, activate it via SysConfig because your application is already running.' =>
            'Wenn der Sicherheitsmodus nicht aktiv ist, können Sie ihn mit der SysConfig aktivieren, da Ihr System bereits läuft.',

        # Template: AdminSelectBox
        'SQL Box' => 'SQL Box',
        'Here you can enter SQL to send it directly to the application database. It is not possible to change the content of the tables, only select queries are allowed.' =>
            'Hier können Sie SQL-Befehle eingeben um diese direkt an die Anwendungsdatenbank zu senden. Es ist nicht möglich, den Inhalt der Tabellen zu ändern, erlaubt sind nur SELECT-Abfragen.',
        'Here you can enter SQL to send it directly to the application database.' =>
            'Hier können Sie SQL eingeben, das an die Datenbank gesendet wird.',
        'Only select queries are allowed.' => 'Es sind nur Select Abfragen erlaubt',
        'The syntax of your SQL query has a mistake. Please check it.' =>
            'Die Syntax Ihrer SQL-Abfrage ist fehlerhaft. Bitte prüfen.',
        'There is at least one parameter missing for the binding. Please check it.' =>
            'Es fehlt mindestens ein Parameter für das Binding. Bitte prüfen.',
        'Result format' => 'Format der Ergebnisse',
        'Run Query' => 'Anfrage ausführen',
        'Query is executed.' => 'Suchanfrage wird ausgeführt.',

        # Template: AdminService
        'Service Management' => 'Service-Verwaltung',
        'Add service' => 'Service hinzufügen',
        'Add Service' => 'Service hinzufügen',
        'Edit Service' => 'Service bearbeiten',
        'Sub-service of' => 'Unterservice von',

        # Template: AdminServiceCenterSupportDataCollector
        'This data is sent to OTRS Group on a regular basis. To stop sending this data please update your system registration.' =>
            'Diese Daten werden regelmäßig an die OTRS Gruppe gesendet. Falls Sie das Senden der Daten beenden möchten, aktualisieren Sie bitte ihre Systemregistrierung.',
        'You can manually trigger the Support Data sending by pressing this button:' =>
            'Sie können den Versand der Supportdaten manuell auslösen, indem Sie diesen Knopf verwenden:',
        'Send Update' => 'Update senden',
        'Sending Update...' => 'Update wird gesendet...',
        'Support Data information was successfully sent.' => 'Supportdaten wurden erfolgreich gesendet.',
        'Was not possible to send Support Data information.' => 'Es war nicht möglich, die Supportdaten zu versenden.',
        'Update Result' => 'Update-Ergebnis',
        'Currently this data is only shown in this system.' => 'Diese Daten werden derzeit nur in Ihrem System angezeigt.',
        'It is highly recommended to send this data to OTRS Group in order to get better support.' =>
            'Es wird empfohlen, diese Daten an die OTRS Gruppe zu senden, um bessere Unterstützung zu erhalten.',
        'To enable data sending, please register your system with OTRS Group or update your system registration information (make sure to activate the \'send support data\' option.)' =>
            'Um das Senden der Daten zu aktivieren, registrieren Sie bitte Ihr System bei der OTRS Gruppe oder aktualisieren Sie ihre Systemregistrierung (aktivieren Sie die Option \'Supportdaten senden\'.)',
        'A support bundle (including: system registration information, support data, a list of installed packages and all locally modified source code files) can be generated by pressing this button:' =>
            'Ein Supportpaket (einschließlich: Systemregistrierungsdaten, Supportdaten, eine Liste der installierten Pakete und aller lokal geänderten Quellcode-Dateien) kann mit diesem Knopf erstellt werden:',
        'Generate Support Bundle' => 'Supportpaket erstellen',
        'Generating...' => 'Wird erstellt...',
        'It was not possible to generate the Support Bundle.' => 'Das Supportpaket konnte nicht erzeugt werden.',
        'Generate Result' => 'Ergebnis der Generierung',
        'Support Bundle' => 'Supportpaket',
        'The mail could not be sent' => 'Die Mail konnte nicht versendet werden',
        'The support bundle has been generated.' => 'Das Supportpaket wurde erstellt.',
        'Please choose one of the following options.' => 'Bitte wählen Sie eine der nachfolgenden Optionen aus.',
        'Send by Email' => 'Per E-Mail senden',
        'The support bundle is too large to send it by email, this option has been disabled.' =>
            'Das Supportpaket ist zu groß, um es manuell zu versenden. Diese Option wurde deaktiviert.',
        'The email address for this user is invalid, this ption has been disabled.' =>
            'Die E-Mailadresse für diesen Benutzer ist ungültig, Die Auswahl wurde deaktivert.',
        'Sending' => 'Wird gesendet',
        'The support bundle will be sent to OTRS Group via email automatically.' =>
            'Das Supportpaket wird automatisch per E-Mail zur OTRS Gruppe gesendet.',
        'Download File' => 'Datei herunterladen',
        'A file containing the support bundle will be downloaded to the local system. Please save the file and send it to the OTRS Group, using an alternate method.' =>
            'Das Supportpaket wird als Datei ins lokale Dateisystem heruntergeladen. Bitte speichern Sie die Datei und senden Sie diese auf anderen Wegen an die OTRS Gruppe.',
        'Support Data' => 'Supportdaten',
        'Error: Support data could not be collected (%s).' => 'Fehler: Supportdaten konnten nicht ermittelt werden (%s).',
        'Details' => 'Details',

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
        'Delete this entry' => 'Diesen Eintrag löschen',
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
        'Show more' => 'Mehr anzeigen',

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

        # Template: AdminSystemMaintenance
        'System Maintenance Management' => 'Systemwartungs-Verwaltung',
        'Schedule New System Maintenance' => 'Neue Systemwartung planen',
        'Schedule a system maintenance period for announcing the Agents and Customers the system is down for a time period.' =>
            'Ein Systemwartungs-Zeitfenster planen, um Agenten und Kunden auf die Downtime hinzuweisen.',
        'Some time before this system maintenance starts the users will receive a notification on each screen announcing about this fact.' =>
            'Einige Zeit vor der Systemwartung werden die Nutzer einen Hinweis auf jedem Bildschirm sehen.',
        'Start date' => 'Startzeitpunkt',
        'Stop date' => 'Endzeitpunkt',
        'Delete System Maintenance' => 'Systemwartung entfernen',
        'Do you really want to delete this scheduled system maintenance?' =>
            'Wollen Sie diese geplante Systemwartung wirklich löschen?',

        # Template: AdminSystemMaintenanceEdit
        'Edit System Maintenance %s' => 'Systemwartung %s bearbeiten',
        'Edit System Maintenance information' => 'Systemwartungs-Information bearbeiten',
        'Date invalid!' => 'Ungültiges Datum',
        'Login message' => 'Anmeldungs-Nachricht',
        'Show login message' => 'Anmeldungs-Nachricht anzeigen',
        'Notify message' => 'Hinweistext',
        'Manage Sessions' => 'Sitzungen verwalten',
        'All Sessions' => 'Alle Sitzungen',
        'Agent Sessions' => 'Agenten-Sitzungen',
        'Customer Sessions' => 'Kunden-Sitzungen',
        'Kill all Sessions, exept current' => 'Alle Sitzungen außer der aktuellen löschen',

        # Template: AdminTemplate
        'Manage Templates' => 'Vorlagen verwalten',
        'Add template' => 'Vorlage hinzufügen',
        'A template is a default text which helps your agents to write faster tickets, answers or forwards.' =>
            'Eine Vorlage ist ein Standardtext, der Ihren Agenten helfen kann, Tickets schneller zu erstellen, beantworten oder weiterzuleiten.',
        'Don\'t forget to add new templates to queues.' => 'Vergessen Sie nicht, Vorlagen den Queues zuzuordnen.',
        'Add Template' => 'Vorlage hinzufügen',
        'Edit Template' => 'Vorlage bearbeiten',
        'A standard template with this name already exists!' => 'Es existiert bereits eine Standardvorlage mit diesem Namen!',
        'Template' => 'Vorlage',
        'Create type templates only supports this smart tags' => 'Vorlagen für das Erstellen unterstützen nur diese "smart tags"',
        'Example template' => 'Beispielvorlage',
        'The current ticket state is' => 'Der aktuelle Ticket-Status ist',
        'Your email address is' => 'Ihre E-Mail-Adresse ist',

        # Template: AdminTemplateAttachment
        'Manage Templates <-> Attachments Relations' => 'Vorlagen-Anhang-Zuordnungen verwalten',
        'Filter for Attachments' => 'Filter für Anlagen',
        'Change Template Relations for Attachment' => 'Vorlagen-Zuordnungen für Anhang verändern',
        'Change Attachment Relations for Template' => 'Anhangs-Zuordnungen für Vorlage verändern',
        'Toggle active for all' => 'Aktiv umschalten für alle',
        'Link %s to selected %s' => '%s zu %s (markiert) verknüpfen',

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
        'A user with this username already exists!' => 'Es existiert bereits ein Nuter mit diesem Benutzernamen!',
        'Will be auto-generated if left empty.' => 'Wird für ein leeres Feld automatisch generiert.',
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

        # Template: AgentCustomerInformationCenterSearch
        'Customer User' => 'Kundenbenutzer',

        # Template: AgentCustomerSearch
        'Duplicated entry' => 'Doppelter Eintrag',
        'This address already exists on the address list.' => 'Dieser Eintrag existiert bereits in der Adressliste',
        'It is going to be deleted from the field, please try again.' => 'Er wird aus dem Feld entfernt, bitte versuchen Sie es erneut.',

        # Template: AgentCustomerTableView
        'Note: Customer is invalid!' => 'Hinweis: Kunde ist ungültig!',

        # Template: AgentDashboard
        'Dashboard' => 'Übersicht',

        # Template: AgentDashboardCalendarOverview
        'in' => 'in',

        # Template: AgentDashboardCommon
        'Available Columns' => 'Verfügbare Spalten',
        'Visible Columns (order by drag & drop)' => 'Angezeigte Spalten (Ändern durch Ziehen)',

        # Template: AgentDashboardCustomerIDStatus
        'Escalated tickets' => 'Eskalierte Tickets',

        # Template: AgentDashboardCustomerUserList
        'Customer information' => 'Kundeninformation',
        'Phone ticket' => 'Telefon-Ticket',
        'Email ticket' => 'E-Mail-Ticket',
        'Start Chat' => 'Starte Chat',
        '%s open ticket(s) of %s' => '%s offene Tickets von %s',
        '%s closed ticket(s) of %s' => '%s geschlossene Tickets von %s',
        'New phone ticket from %s' => 'Neues Telefonticket von %s',
        'New email ticket to %s' => 'Neues E-Mail-Ticket an %s',

        # Template: AgentDashboardProductNotify
        '%s %s is available!' => '%s %s ist nun verfügbar!',
        'Please update now.' => 'Bitte nun aktualisieren.',
        'Release Note' => 'Versionsbeschreibung',
        'Level' => 'Level',

        # Template: AgentDashboardRSSOverview
        'Posted %s ago.' => 'Veröffentlicht vor %s.',

        # Template: AgentDashboardStats
        'The content of this statistic is being prepared for you, please be patient.' =>
            'Der Inhalt dieser Statistik wird vorbereitet. Bitte haben Sie etwas Geduld.',
        'Grouped' => 'Gruppiert',
        'Stacked' => 'Gestapelt',
        'Expanded' => 'Ausgedehnt',
        'Stream' => 'Fließend',
        'CSV' => 'CSV',
        'PDF' => 'PDF',

        # Template: AgentDashboardTicketGeneric
        'My locked tickets' => 'Meine gesperrten Tickets',
        'My watched tickets' => 'Meine beobachteten Tickets',
        'My responsibilities' => 'Meine Verantwortlichkeiten',
        'Tickets in My Queues' => 'Tickets in meinen Queues',
        'Tickets in My Services' => 'Tickets in Meinen Services',
        'Service Time' => 'Service Zeit',
        'Remove active filters for this widget.' => 'Aktive Filter für dieses Widget entfernen.',

        # Template: AgentDashboardTicketQueueOverview
        'Totals' => 'Summen',

        # Template: AgentDashboardUserOnline
        'out of office' => 'abwesend',

        # Template: AgentDashboardUserOutOfOffice
        'until' => 'bis',

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

        # Template: AgentPreferences
        'Edit your preferences' => 'Persönliche Einstellungen bearbeiten',

        # Template: AgentSchedulerInfo
        'General Information' => 'Allgemeine Informationen',
        'Scheduler is an OTRS separated process that perform asynchronous tasks' =>
            'Der Scheduler ist ein OTRS-Prozess, der asynchrone Aufgaben ausführt.',
        '(e.g. Generic Interface asynchronous invoker tasks)' => '(z.B.: Generic Interface asynchrone Invoker Aufgaben)',
        'It is necessary to have the Scheduler running to make the system work correctly!' =>
            'Es ist notwendig das der Scheduler läuft, damit das System ordnungsgemäß funktioniert!',
        'Starting Scheduler' => 'Scheduler starten',
        'Make sure that %s exists (without .dist extension)' => 'Stellen Sie sicher, dass %s existiert (ohne die Endung .dist)',
        'Check that cron deamon is running in the system' => 'Überprüfen Sie das der Cron-Daemon gestartet wurde.',
        'Confirm that OTRS cron jobs are running, execute %s start' => 'Stellen Sie sicher, dass die OTRS Cronjobs gestartet wurden. Führen Sie \'%s start\' aus',

        # Template: AgentSpelling
        'Spell Checker' => 'Rechtschreibprüfung',
        'spelling error(s)' => 'Rechtschreibfehler',
        'Apply these changes' => 'Änderungen übernehmen',

        # Template: AgentStatsDelete
        'Delete stat' => 'Statistik löschen',
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
        'Show as dashboard widget' => 'Als Dashboard-Widget anzeigen',
        'Provide the statistic as a widget that agents can activate in their dashboard.' =>
            'Diese Statistik als Dashboard-Widget anbieten, die Agenten in Ihrem Dashboard aktivieren können.',
        'Please note' => 'Bitte beachten',
        'Enabling the dashboard widget will activate caching for this statistic in the dashboard.' =>
            'Das Freischalten des Dashboard-Widgets wird Caching für diese Statistik im Dashboard aktivieren.',
        'Agents will not be able to change absolute time settings for statistics dashboard widgets.' =>
            'Agenten können die absoluten Zeiteinstellungen für Statistiken im Dashboard nicht ändern',
        'IE8 doesn\'t support statistics dashboard widgets.' => 'IE8 unterstützt diese Dashboard-Widgets nicht.',
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

        # Template: AgentStatsViewSettings
        'Configurable params of static stat' => 'Konfigurierbare Parameter der statischen Statistik',
        'No element selected.' => 'Es wurde kein Element ausgewählt.',
        'maximal period from' => 'maximaler Zeitraum von',
        'to' => 'bis',
        'not changable for dashboard statistics' => 'nicht änderbar für Dashboard-Statistiken',
        'Select Chart Type' => 'Charttyp auswählen',
        'Chart Type' => 'Charttyp',
        'Multi Bar Chart' => 'Balkendiagramm',
        'Multi Line Chart' => 'Liniendiagramm',
        'Stacked Area Chart' => 'Flächendiagramm',

        # Template: AgentTicketActionCommon
        'Change Free Text of Ticket' => 'Den "freien" Text des Tickets ändern',
        'Change Owner of Ticket' => 'Den Besitzer des Tickets ändern',
        'Close Ticket' => 'Ticket schließen',
        'Add Note to Ticket' => 'Bemerkung zum Ticket hinzufügen',
        'Set Pending' => 'Setze wartend',
        'Change Priority of Ticket' => 'Ändern der Ticket-Priorität',
        'Change Responsible of Ticket' => 'Ändern der Ticket-Verantwortlichen',
        'All fields marked with an asterisk (*) are mandatory.' => 'Alle mit * gekennzeichneten Felder sind Pflichtfelder.',
        'Service invalid.' => 'Ungültiger Service',
        'New Owner' => 'Neuer Besitzer',
        'Please set a new owner!' => 'Bitte einen neuen Besitzer angeben',
        'Previous Owner' => 'Vorheriger Besitzer',
        'Next state' => 'Nächster Status',
        'Add Article' => 'Artikel hinzufügen',
        'Create an Article' => 'Artikel anlegen',
        'Spell check' => 'Rechtschreibprüfung',
        'Text Template' => 'Textvorlage',
        'Setting a template will overwrite any text or attachment.' => 'Die Auswahl einer Vorlage wird bereits bestehenden Text oder Anlagen löschen.',
        'Note type' => 'Notiztyp',
        'Inform Agent' => 'Agenten informieren',
        'Optional' => 'Optional',
        'Inform involved Agents' => 'Involvierte Agenten informieren',
        'Here you can select additional agents which should receive a notification regarding the new article.' =>
            'Hier können Sie zusätzliche Agenten auswählen, die eine Benachrichtigung über den neuen Artikel enthalten sollen.',

        # Template: AgentTicketBounce
        'Bounce Ticket' => 'Ticket umleiten',
        'Bounce to' => 'Umleiten an',
        'You need a email address.' => 'Sie benötigen eine E-Mail-Adresse',
        'Need a valid email address or don\'t use a local email address.' =>
            'Benötige eine gültige E-Mail-Adresse, verwenden Sie keine lokale Adresse.',
        'Next ticket state' => 'Nächster Status des Tickets',
        'Inform sender' => 'Sender informieren',
        'Send mail' => 'Mail übermitteln',

        # Template: AgentTicketBulk
        'Ticket Bulk Action' => 'Ticket Sammelaktion',
        'Send Email' => 'E-Mail versenden',
        'Merge to' => 'Zusammenfassen zu',
        'Invalid ticket identifier!' => 'Ungültiger Ticket-Identifizierer!',
        'Merge to oldest' => 'Zusammenfassen zu Ältestem',
        'Link together' => 'Zusammen verlinken',
        'Link to parent' => 'Mit Eltern verknüpfen',
        'Unlock tickets' => 'Tickets entsperren',

        # Template: AgentTicketCompose
        'Compose answer for ticket' => 'Antwort erstellen für',
        'Please include at least one recipient' => 'Bitte geben sie mindestens einen Empfänger an',
        'Remove Ticket Customer' => 'Ticket-Kunden entfernen',
        'Please remove this entry and enter a new one with the correct value.' =>
            'Bitte entfernen Sie diesen Eintrag und geben Sie einen gültigen an.',
        'Remove Cc' => 'Cc entfernen',
        'Remove Bcc' => 'Bcc entfernen',
        'Address book' => 'Adressbuch',
        'Pending Date' => 'Warten bis',
        'for pending* states' => 'für warten* Status',
        'Date Invalid!' => 'Ungültiges Datum!',

        # Template: AgentTicketCustomer
        'Change customer of ticket' => 'Kunde des Tickets ändern',
        'Customer user' => 'Kundenbenutzer',

        # Template: AgentTicketEmail
        'Create New Email Ticket' => 'Neues E-Mail-Ticket anlegen',
        'Example Template' => 'Beispielvorlage',
        'From queue' => 'Aus Queue',
        'To customer user' => 'An Kundenbenutzer',
        'Please include at least one customer user for the ticket.' => 'Bitte tragen Sie wenigstens einen Kundenbenutzer für das Ticket ein',
        'Select this customer as the main customer.' => 'Diesen Kunden als Hauptkunden auswählen.',
        'Remove Ticket Customer User' => 'Kundenbenutzer des Tickets entfernen',
        'Get all' => 'Alles holen',

        # Template: AgentTicketEmailOutbound
        'E-Mail Outbound' => 'Ausgehende E-Mail',

        # Template: AgentTicketForward
        'Forward ticket: %s - %s' => 'Ticket weiterleiten:  %s - %s',

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

        # Template: AgentTicketOverviewMedium
        'Select all' => 'Alle auswählen',
        'No ticket data found.' => 'Keine Ticketdaten gefunden.',
        'Select this ticket' => 'Dieses Ticket auswählen',
        'First Response Time' => 'Reaktionszeit',
        'Update Time' => 'Aktualisierungszeit',
        'Solution Time' => 'Lösungszeit',
        'Move ticket to a different queue' => 'Ticket in eine andere Queue verschieben',
        'Change queue' => 'Queue wechseln',

        # Template: AgentTicketOverviewNavBar
        'Change search options' => 'Such-Optionen ändern',
        'Remove active filters for this screen.' => 'Aktive Filter für diesen Bildschirm entfernen.',
        'Tickets per page' => 'Tickets pro Seite',

        # Template: AgentTicketOverviewSmall
        'Reset overview' => 'Übersicht zurücksetzen',
        'Column Filters Form' => 'Spalten-Filter-Formular',

        # Template: AgentTicketPhone
        'Split Into New Phone Ticket' => 'In ein neues Telefonticket splitten',
        'Save Chat Into New Phone Ticket' => 'Chat als neues Telefonticket speichern',
        'Create New Phone Ticket' => 'Neues Telefon-Ticket anlegen',
        'Please include at least one customer for the ticket.' => 'Bitte geben Sie mindestens einen Kunden für das Ticket an.',
        'To queue' => 'An Queue',
        'Chat protocol' => 'Chat Protokoll',

        # Template: AgentTicketPlain
        'Email Text Plain View' => 'E-Mail unformatiert anzeigen',
        'Plain' => 'Unformatiert',
        'Download this email' => 'Diese E-Mail herunterladen',

        # Template: AgentTicketPrint
        'Ticket-Info' => 'Ticket-Info',
        'Accounted time' => 'Erfasste Zeit',
        'Linked-Object' => 'Verknüpfte-Objekte',
        'by' => 'von',

        # Template: AgentTicketProcess
        'Create New Process Ticket' => 'Neues Prozessticket',
        'Process' => 'Prozess',

        # Template: AgentTicketProcessSmall
        'Enroll Ticket into a Process' => 'Ticket in einen Prozess überführen',

        # Template: AgentTicketSearch
        'Search template' => 'Suchvorlage',
        'Create Template' => 'Vorlage anlegen',
        'Create New' => 'Neue anlegen',
        'Profile link' => 'Profil-Link',
        'Save changes in template' => 'Änderungen in der Vorlage speichern',
        'Filters in use' => 'Verwendete Filter',
        'Additional filters' => 'zusätzliche Filter',
        'Add another attribute' => 'Ein weiteres Attribut hinzufügen',
        'Output' => 'Ausgabe',
        'Fulltext' => 'Volltext',
        'Remove' => 'Entfernen',
        'Searches in the attributes From, To, Cc, Subject and the article body, overriding other attributes with the same name.' =>
            'Sucht in den Attributen Von, Cc, Betreff, Artikelinhalt und überschreibt Attribute mit dem selben Namen.',
        'Customer User Login' => 'Anmeldung Kundenkontakt',
        'Attachment Name' => 'Name der Anlage',
        '(e. g. m*file or myfi*)' => '(z.B. m*file oder myfi*)',
        'Created in Queue' => 'Erstellt in Queue',
        'Lock state' => 'Status Sperre',
        'Watcher' => 'Beobachter',
        'Article Create Time (before/after)' => 'Artikel-Erstellzeit (vor/nach)',
        'Article Create Time (between)' => 'Artikel-Erstellzeit (zwischen)',
        'Ticket Create Time (before/after)' => 'Ticket-Erstellzeit (vor/nach)',
        'Ticket Create Time (between)' => 'Ticket-Erstellzeit (zwischen)',
        'Ticket Change Time (before/after)' => 'Ticket-Änderungszeit (vor/nach)',
        'Ticket Change Time (between)' => 'Ticket-Änderungszeit (zwischen)',
        'Ticket Last Change Time (before/after)' => 'Letzte Ticket-Änderungszeit (vor/nach)',
        'Ticket Last Change Time (between)' => 'Letzte Ticket-Änderungszeit (zwischen)',
        'Ticket Close Time (before/after)' => 'Ticket-Schließzeit (vor/nach)',
        'Ticket Close Time (between)' => 'Ticket-Schließzeit (zwischen)',
        'Ticket Escalation Time (before/after)' => 'Ticket-Eskalationszeit (vor/nach)',
        'Ticket Escalation Time (between)' => 'Ticket-Eskalationszeit (zwischen)',
        'Archive Search' => 'Archivsuche',
        'Run search' => 'Suche starten',

        # Template: AgentTicketZoom
        'Article filter' => 'Filter für Beiträge',
        'Article Type' => 'Artikel Typ',
        'Sender Type' => 'Absender Typ',
        'Save filter settings as default' => 'Filter-Einstellungen als Standard speichern',
        'Event Type Filter' => 'Ereignistypfilter',
        'Event Type' => 'Ereignistyp',
        'Save as default' => 'Save as default',
        'Archive' => 'Archiv',
        'This ticket is archived.' => 'Dieses Ticket ist archiviert.',
        'Locked' => 'Sperre',
        'Linked Objects' => 'Verknüpfte Objekte',
        'Change Queue' => 'Queue ändern',
        'There are no dialogs available at this point in the process.' =>
            'Für diesen Prozess stehen derzeit keine Dialoge zur Verfügung.',
        'This item has no articles yet.' => 'Dieser Eintrag hat noch keine Artikel',
        'Ticket Timeline View' => 'Ansicht des Ticket-Verlaufs',
        'Article Overview' => 'Artikelübersicht',
        'Article(s)' => 'Beitrag/Beiträge',
        'Add Filter' => 'Filter hinzufügen',
        'Set' => 'Setzen',
        'Reset Filter' => 'Filter zurücksetzen',
        'Show one article' => 'Einen Beitrag anzeigen',
        'Show all articles' => 'Alle Beiträge anzeigen',
        'Show Ticket Timeline View' => 'Zeige Ticket-Verlauf-Ansicht',
        'Unread articles' => 'Ungelesene Beiträge',
        'No.' => 'Nr.',
        'Important' => 'Wichtig',
        'Unread Article!' => 'Ungelesene Beiträge!',
        'Incoming message' => 'Eingehende Nachricht',
        'Outgoing message' => 'Ausgehende Nachricht',
        'Internal message' => 'Interne Nachricht',
        'Resize' => 'Größe anpassen',
        'Show Full Text' => 'Vollständigen Text anzeigen',
        'Full Article Text' => 'Vollständiger Artikeltext',
        'No more events found. Please try changing the filter settings.' =>
            'Keine weiteren Ereignisse gefunden. Versuchen Sie die Filtereinstellungen zu verändern.',

        # Template: AttachmentBlocker
        'To protect your privacy, remote content was blocked.' => 'Zum Schutz Ihrer Privatsphäre wurden entfernte Inhalte blockiert.',
        'Load blocked content.' => 'Blockierte Inhalte laden.',

        # Template: CustomerError
        'Traceback' => 'Traceback',

        # Template: CustomerFooter
        'Powered by' => 'Powered by',

        # Template: CustomerFooterJS
        'One or more errors occurred!' => 'Ein oder mehrere Fehler sind aufgetreten!',
        'Close this dialog' => 'Diesen Dialog schließen',
        'Could not open popup window. Please disable any popup blockers for this application.' =>
            'Konnte Popup-Fenster nicht öffnen. Bitte deaktivieren Sie alle Popup-Blocker für diese Anwendung.',
        'There are currently no elements available to select from.' => 'Derzeit sind keine Elemente für die Auswahl vorhanden.',
        'Please turn off Compatibility Mode in Internet Explorer!' => 'Bitte schalten Sie den Kompatibilitätsmodus im Internet Explorer aus!',
        'The browser you are using is too old.' => 'Sie verwenden leider einen (stark) veralteten Browser.',
        'OTRS runs with a huge lists of browsers, please upgrade to one of these.' =>
            'OTRS funktioniert mit einer großen Auswahl an Browsern, aus denen Sie wählen können. Bitte installieren Sie einen neueren Browser oder upgraden Sie Ihren vorhandenen.',
        'Please see the documentation or ask your admin for further information.' =>
            'Bitte lesen Sie auch die Dokumentation oder fragen Sie Ihren Systemadministrator.',

        # Template: CustomerLogin
        'JavaScript Not Available' => 'JavaScript nicht aktiviert oder nicht unterstützt.',
        'In order to experience OTRS, you\'ll need to enable JavaScript in your browser.' =>
            'Um alle Möglichkeiten von OTRS voll ausschöpfen zu können, müssen Sie JavaScript in Ihrem Browser aktivieren.',
        'Browser Warning' => 'Browser-Warnung',
        'Login' => 'Anmeldung',
        'User name' => 'Benutzername',
        'Your user name' => 'Ihr Benutzername',
        'Your password' => 'Ihr Passwort',
        'Forgot password?' => 'Passwort vergessen?',
        'Log In' => 'Anmelden',
        'Not yet registered?' => 'Noch nicht registriert?',
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
        'Incoming Chat Requests' => 'Eingehende Chatanfragen',
        'You have unanswered chat requests' => 'Sie haben unbeantwortete Chatanfragen',
        'Edit personal preferences' => 'Persönliche Einstellungen vornehmen',

        # Template: CustomerTicketMessage
        'Service level agreement' => 'Service-Level-Vereinbarung',

        # Template: CustomerTicketOverview
        'Welcome!' => 'Willkommen!',
        'Please click the button below to create your first ticket.' => 'Bitte verwenden Sie den Knopf unten zur Erstellung Ihres ersten Tickets.',
        'Create your first ticket' => 'Ihr erstes Ticket erstellen',

        # Template: CustomerTicketPrint
        'Ticket Print' => 'Ticket-Druckansicht',
        'Ticket Dynamic Fields' => 'Dynamische Felder für Tickets',

        # Template: CustomerTicketSearch
        'Profile' => 'Profil',
        'e. g. 10*5155 or 105658*' => 'z. B. 10*5155 oder 105658*',
        'Customer ID' => 'Kunden-ID',
        'Fulltext search in tickets (e. g. "John*n" or "Will*")' => 'Volltextsuche in Tickets (z. B. "Max*" oder "Muster*")',
        'Carbon Copy' => 'Kopie an',
        'e. g. m*file or myfi*' => 'z.B.. m*file oder myfi*',
        'Types' => 'Typen',
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

        # Template: CustomerTicketSearchResultShort
        'of' => 'von',
        'Page' => 'Seite',
        'Search Results for' => 'Suchergebnisse für',
        'Remove this Search Term.' => 'Entferne diesen Suchbegriff',

        # Template: CustomerTicketZoom
        'Expand article' => 'Artikel aufklappen',
        'Next Steps' => 'Nächste Schritte',
        'Reply' => 'Antworten',

        # Template: DashboardEventsTicketCalendar
        'All-day' => 'Ganztägig',
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
        'Event Information' => 'Ereignis-Information',
        'Ticket fields' => 'Ticket-Felder',
        'Dynamic fields' => 'Dynamische Felder',

        # Template: Datepicker
        'Invalid date (need a future date)!' => 'Ungültiges Datum (benötige Datum in der Zukunft)!',
        'Invalid date (need a past date)!' => 'Ungültiges Datum (benötige Datum in der Vergangenheit)!',
        'Previous' => 'Zurück',
        'Open date selection' => 'Datumsauswahl öffnen',

        # Template: Error
        'Oops! An Error occurred.' => 'Hoppla. Es ist ein Fehler aufgetreten.',
        'You can' => 'Sie können',
        'Send a bugreport' => 'einen Fehlerbericht senden',
        'go back to the previous page' => 'zurück zur vorhergehenden Seite',
        'Error Details' => 'Fehlerdetails',

        # Template: FooterJS
        'If you now leave this page, all open popup windows will be closed, too!' =>
            'Wenn Sie diese Seite verlassen, werden auch alle geöffneten Dialoge geschlossen!',
        'A popup of this screen is already open. Do you want to close it and load this one instead?' =>
            'Auf diesem Bildschirm ist bereits ein Popup-Fenster geöffnet. Möchten Sie dieses schließen und dieses stattdessen öffnen?',
        'Please enter at least one search value or * to find anything.' =>
            'Bitte geben Sie zumindest einen Suchbegriff ein oder * um nach Allem zu suchen.',
        'Please check the fields marked as red for valid inputs.' => 'Bitte prüfen Sie die rot markierten Felder auf gültige Eingaben.',
        'Please perform a spell check on the the text first.' => 'Bitte führen Sie zuerst eine Rechtschreibprüfung aus.',
        'Slide the navigation bar' => 'Verschieben Sie die Navigationsleiste',

        # Template: Header
        'You are logged in as' => 'Angemeldet als',

        # Template: Installer
        'JavaScript not available' => 'JavaScript nicht aktiviert oder nicht unterstützt.',
        'Database Settings' => 'Datenbankeinstellungen',
        'General Specifications and Mail Settings' => 'Allgemeine Einstellungen und E-Mail-Einstellungen',
        'Web site' => 'Website',
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

        # Template: InstallerDBResult
        'Database setup successful!' => 'Datenbank erfolgreich erstellt!',

        # Template: InstallerDBStart
        'Install Type' => 'Installationstyp',
        'Create a new database for OTRS' => 'Neue Datenbank für OTRS erstellen',
        'Use an existing database for OTRS' => 'Bestehende Datenbank für OTRS nutzen',

        # Template: InstallerDBmssql
        'Database name' => 'Datenbankname',
        'Check database settings' => 'Datenbankeinstellungen prüfen',
        'Result of database check' => 'Ergebnis der Datenbankprüfung',
        'Database check successful.' => 'Datenbankprüfung erfolgreich.',
        'Database User' => 'Datenbankbenutzer',
        'New' => 'Neu',
        'A new database user with limited permissions will be created for this OTRS system.' =>
            'Ein neuer Datenbank-Benutzer mit beschränkten Rechten wird für dieses OTRS-System erstellt.',
        'Repeat Password' => 'Passwort wiederholen',
        'Generated password' => 'Generiertes Passwort',

        # Template: InstallerDBmysql
        'Passwords do not match' => 'Passworte stimmen nicht überein',

        # Template: InstallerDBoracle
        'SID' => 'SID',
        'Port' => 'Port',

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

        # Template: InstallerSystem
        'The identifier of the system. Each ticket number and each HTTP session ID contain this number.' =>
            'Der System-Identifizierer. Jede Ticketnummer und jede HTTP-Sitzungs-ID enthalten diese Nummer.',
        'System FQDN' => 'System FQDN',
        'Fully qualified domain name of your system.' => 'Voll qualifizierter Domainname Ihres Systems.',
        'AdminEmail' => 'E-Mail des Administrators',
        'Email address of the system administrator.' => 'E-Mail-Adresse des Administrators.',
        'Organization' => 'Organisation',
        'Log' => 'Protokoll',
        'LogModule' => 'Protokollmodul',
        'Log backend to use.' => 'Protokoll-Backend, welches verwendet werden soll.',
        'LogFile' => 'Protokolldatei',
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
        'Close this message' => 'Diese Nachricht schließen',

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

        # Template: PrintHeader
        'printed by' => 'gedruckt von',

        # Template: Test
        'OTRS Test Page' => 'OTRS Testseite',
        'Counter' => 'Zähler',

        # Template: Warning
        'Go back to the previous page' => 'Zurück zur vorhergehenden Seite',

        # SysConfig
        '"%s"-notification sent to "%s".' => '"%s"-Benachrichtigung versandt an "%s".',
        '%s' => '%s',
        '%s time unit(s) accounted. Now total %s time unit(s).' => '%s Zeiteinheit(en) gezählt. Insgesamt %s Zeiteinheit(en).',
        '(UserLogin) Firstname Lastname' => '(BenutzerLogin) Vorname Nachname',
        '(UserLogin) Lastname, Firstname' => '(BenutzerLogin) Nachname, Vorname',
        'A list of dynamic fields that are merged into the main ticket during a merge operation. Only dynamic fields that are empty in the main ticket will be set.' =>
            'Eine Liste der dynamischen Felder, die während einer Zusammenführung in das Haupt-Ticket ebenfalls zusammengeführt werden. Es werden nur leere dynamische Felder im Haupt-Ticket geändert.',
        'ACL module that allows closing parent tickets only if all its children are already closed ("State" shows which states are not available for the parent ticket until all child tickets are closed).' =>
            'ACL Modul das erlaubt Eltern-Tickets nur dann zu schließen, wenn alle seine Kinder-Tickets geschlossen wurden. ("Status" zeigt welche Status für das Eltern-Ticket nicht verfügbar sind, bis alle Kinder-Tickets geschlossen sind).',
        'Access Control Lists (ACL)' => 'Access Control Lists (ACL)',
        'AccountedTime' => 'Erfasste Zeit',
        'Activates a blinking mechanism of the queue that contains the oldest ticket.' =>
            'Aktiviert einen Blinkmechanismus der Warteschlange, die das älteste Ticket enthält.',
        'Activates lost password feature for agents, in the agent interface.' =>
            'Aktiviert die "Passwort vergessen" Funktion für Agenten in der Agentenoberfläche.',
        'Activates lost password feature for customers.' => 'Aktiviert die "Passwort vergessen" Funktion für Kunden.',
        'Activates support for customer groups.' => 'Aktiviert die Unterstützung für Kundengruppen.',
        'Activates the article filter in the zoom view to specify which articles should be shown.' =>
            'Aktiviert verschiedene Artikelfilter in der Zoomansicht, um festzulegen, welche Artikel angezeigt werden sollen.',
        'Activates the available themes on the system. Value 1 means active, 0 means inactive.' =>
            'Aktiviert die verfügbaren Skins auf dem System. Wert 1 bedeutet aktiv, 0 bedeutet inaktiv.',
        'Activates the ticket archive system search in the customer interface.' =>
            'Aktiviert die Suche im Ticket-Archiv für das Kunden-Interface.',
        'Activates the ticket archive system to have a faster system by moving some tickets out of the daily scope. To search for these tickets, the archive flag has to be enabled in the ticket search.' =>
            'Aktiviert das Ticket Archivsystem, um ein schnelleres System zu haben, indem einige Tickets aus dem täglichen Anwendungsbereich verschoben werden. Um diese Tickets in der Suche zu finden, muss das Archiv-Flag in der Ticketsuche aktiviert werden.',
        'Activates time accounting.' => 'Aktiviert die Zeitabrechnung.',
        'ActivityID' => 'ActivityID',
        'Added email. %s' => 'E-Mail hinzugefügt. %s',
        'Added link to ticket "%s".' => 'Verknüpfung zu "%s" hergestellt.',
        'Added note (%s)' => 'Notiz hinzugefügt (%s)',
        'Added subscription for user "%s".' => 'Abo für Benutzer "%s" eingetragen.',
        'Adds a suffix with the actual year and month to the OTRS log file. A logfile for every month will be created.' =>
            'Fügt einen Suffix mit dem aktuellen Jahr und Monat in die OTRS-Protokolldatei hinzu. Für jeden Monat wir eine eigen Log-Datei erstellt.',
        'Adds customers email addresses to recipients in the ticket compose screen of the agent interface. The customers email address won\'t be added if the article type is email-internal.' =>
            'Fügt die Kunden E-Mailadresse zu den Empfängern hinzu in der "TicketCompose"-Oberfläche des Agenten-Interface hinzu. Die Kunden E-Mailadresse wird nicht hinzugefügt, wenn der Artikel-Typ \'email an intern\' ist.',
        'Adds the one time vacation days for the indicated calendar. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Fügt die einmaligen Feiertagetage für den angezeigten Kalender. Bitte verwenden Sie einstellige Zahlen von 1 bis 9 (statt 01 bis 09).',
        'Adds the one time vacation days. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Fügt die einmaligen Ferien-Tage für den ausgewählten Kalender hinzu. Bitte benutzen Sie ein Ein-Zahlen-Muster mit Zahlen von 1 bis 9 (anstatt 01 - 09).',
        'Adds the permanent vacation days for the indicated calendar. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Fügt die permanenten Ferien-Tage für den ausgewählten Kalender hinzu. Bitte benutzen Sie ein Ein-Zahlen-Muster mit Zahlen von 1 bis 9 (anstatt 01 - 09).',
        'Adds the permanent vacation days. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Fügt die permanenten Ferien-Tage hinzu. Bitte benutzen Sie ein Ein-Zahlen-Muster mit Zahlen von 1 bis 9 (anstatt 01 - 09).',
        'Agent Notifications' => 'Agenten-Benachrichtigungen',
        'Agent called customer.' => 'Kunden angerufen.',
        'Agent interface article notification module to check PGP.' => 'Benachrichtigungsmodul im Agenten-Interface das die PGP-Überprüfung durchführt.',
        'Agent interface article notification module to check S/MIME.' =>
            'Benachrichtigungsmodul im Agenten-Interface das die S/MIME-Prüfung durchführt.',
        'Agent interface module to access CIC search via nav bar.' => 'Modul im Agenten-Interface um das Kundeninformationscenter über die Navigationsleiste zu betreten.',
        'Agent interface module to access fulltext search via nav bar.' =>
            'Modul im Agenten-Interface um die Volltextsuche über die Navigationsleiste zu starten.',
        'Agent interface module to access search profiles via nav bar.' =>
            'Modul im Agenten-Interface um angelegte Suchprofile über die Navigationsleiste zu wählen.',
        'Agent interface module to check incoming emails in the Ticket-Zoom-View if the S/MIME-key is available and true.' =>
            'Modul im Agenten-Interface um eingehende E-Mails in der TicketZoomView auf vorhandene und gültige S/MIME-Schlüssel zu überprüfen. ',
        'Agent interface notification module to check the used charset.' =>
            'Benachrichtigungsmodul im Agenten-Interface um den verwendeten Zeichensatz zu überprüfen.',
        'Agent interface notification module to see the number of tickets an agent is responsible for.' =>
            'Benachrichtigungsmodul im Agenten-Interface um die Zahl der Tickets anzuzeigen, für die ein Agent verantwortlich ist.',
        'Agent interface notification module to see the number of tickets in My Services.' =>
            'Benachrichtigungsmodul im Agenten-Interface um die Zahl der Tickets in MyServces anzuzeigen',
        'Agent interface notification module to see the number of watched tickets.' =>
            'Benachrichtigungsmodul im Agenten-Interface um die Zahl der beobachteten Tickets anzuzeigen.',
        'Agents <-> Groups' => 'Agent <-> Gruppen',
        'Agents <-> Roles' => 'Agent <-> Rollen',
        'All customer users of a CustomerID' => 'Alle Kundenbenutzer einer Kundennummer',
        'Allows adding notes in the close ticket screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Erlaubt in der Agentenoberfläche das Hinzufügen von Notizen im  \'Schließen\'-Bildschirm. Kann durch Ticket::Frontend::NeedAccountedTime überschrieben werden.',
        'Allows adding notes in the ticket free text screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Erlaubt in der Agentenoberfläche das Hinzufügen von Notizen im \'Freie-Felder\'-Bildschirm. Kann durch Ticket::Frontend::NeedAccountedTime überschrieben werden.',
        'Allows adding notes in the ticket note screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Erlaubt in der Agentenoberfläche das Hinzufügen von Notizen im \'Notiz\'-Bildschirm. Kann durch Ticket::Frontend::NeedAccountedTime überschrieben werden.',
        'Allows adding notes in the ticket owner screen of a zoomed ticket in the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Erlaubt in der Agentenoberfläche in einem geöffneten Ticket das Hinzufügen von Notizen im \'Besitzer\'-Bildschirm. Kann durch Ticket::Frontend::NeedAccountedTime überschrieben werden.',
        'Allows adding notes in the ticket pending screen of a zoomed ticket in the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Erlaubt in der Agentenoberfläche in einem geöffneten Ticket das Hinzufügen von Notizen im \'Warten\'-Bildschirm. Kann durch Ticket::Frontend::NeedAccountedTime überschrieben werden.',
        'Allows adding notes in the ticket priority screen of a zoomed ticket in the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Erlaubt in der Agentenoberfläche in einem geöffneten Ticket das Hinzufügen von Notizen im \'Priorität\'-Bildschirm. Kann durch Ticket::Frontend::NeedAccountedTime überschrieben werden.',
        'Allows adding notes in the ticket responsible screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Erlaubt in der Agentenoberfläche in einem geöffneten Ticket das Hinzufügen von Notizen im \'Verantwortlichen\'-Bildschirm. Kann durch Ticket::Frontend::NeedAccountedTime überschrieben werden.',
        'Allows agents to exchange the axis of a stat if they generate one.' =>
            'Erlaubt Agenten die Achsen einer Statistik zu tauschen, wenn sie eine Statistik generieren.',
        'Allows agents to generate individual-related stats.' => 'Erlaubt Agenten eine individuelle Statistik zu generieren.',
        'Allows choosing between showing the attachments of a ticket in the browser (inline) or just make them downloadable (attachment).' =>
            'Ermöglicht die Wahl zwischen der Anzeige der Anlagen eines Tickets im Browser (Inline) oder einfach nur als Download anbieten (Anhang).',
        'Allows choosing the next compose state for customer tickets in the customer interface.' =>
            'Ermöglicht die Wahl des nächsten Verfassen-Status für Kundenticket im Kunden-Interface.',
        'Allows customers to change the ticket priority in the customer interface.' =>
            'Erlaubt Kunden die Ticketpriorität im Kunden-Interface zu ändern.',
        'Allows customers to set the ticket SLA in the customer interface.' =>
            'Erlaubt Kunden das setzen von SLAst im Kunden-Interface zu ändern.',
        'Allows customers to set the ticket priority in the customer interface.' =>
            'Erlaubt Kunden das Setzen der Ticketpriorität im Kunden-Interface zu ändern.',
        'Allows customers to set the ticket queue in the customer interface. If this is set to \'No\', QueueDefault should be configured.' =>
            'Ermöglicht es Kunden, die Ticket-Queue im Kunden-Interface zu setzen . Wenn dieser Wert auf \'Nein\' steht, sollte der Wert \'QueueDefault\' konfiguriert werden.',
        'Allows customers to set the ticket service in the customer interface.' =>
            'Ermöglicht es Kunden den Ticket-Service im Kunden-Interface einzustellen.',
        'Allows customers to set the ticket type in the customer interface. If this is set to \'No\', TicketTypeDefault should be configured.' =>
            'Ermöglicht es Kunden, den Ticket-Typ im Kunden-Interface zu setzen. Wenn dieser Wert auf \'Nein\' steht, sollte der Wert \'TicketTypeDefault\' konfiguriert werden.',
        'Allows default services to be selected also for non existing customers.' =>
            'Ermöglicht das Standard-Services auch für nicht angelegte Kunden ausgewählt werden können.',
        'Allows defining new types for ticket (if ticket type feature is enabled).' =>
            'Ermöglicht die Definition neuer Ticket-Typen  (wenn Ticket-Typ-Funktion aktiviert ist).',
        'Allows defining services and SLAs for tickets (e. g. email, desktop, network, ...), and escalation attributes for SLAs (if ticket service/SLA feature is enabled).' =>
            'Erlaubt die Definition von Services und SLAs für Tickets (zum Beispiel: E-Mail, Desktop, Network, ...) und Eskalationsattributen für SLAs (wenn die Ticket Service/SLA Einstellung aktiviert ist).',
        'Allows extended search conditions in ticket search of the agent interface. With this feature you can search e. g. with this kind of conditions like "(key1&&key2)" or "(key1||key2)".' =>
            'Erlaubt erweiterte Suchbedingungen in der Ticket-Suche des Agenten-Bereichs. Mit dieser Funktion können Sie z.B. mit Bedingungen wie "(key1&&key2)" oder "(key1||key2)" suchen.',
        'Allows extended search conditions in ticket search of the customer interface. With this feature you can search w. g. with this kind of conditions like "(key1&&key2)" or "(key1||key2)".' =>
            'Erlaubt erweiterte Suchbedingungen in der Ticket-Suche des Kunden-Bereichs. Mit dieser Funktion können Sie z.B. mit Bedingungen wie "(key1&&key2)" oder "(key1||key2)" suchen.',
        'Allows having a medium format ticket overview (CustomerInfo => 1 - shows also the customer information).' =>
            'Ermöglicht eine Ticket-Übersicht mit einigen Ticketinformationen  (Customer => 1 - zeigt auch die Kundeninformation).',
        'Allows having a small format ticket overview (CustomerInfo => 1 - shows also the customer information).' =>
            'Ermöglicht die Benutzung der kleinenTicketübersicht (CustomerInfo => 1 - zeigt auch die Kundeninformation ).',
        'Allows invalid agents to generate individual-related stats.' => 'Erlaubt Agenten, die ungültig sind, individuelle Statistiken zu generieren.',
        'Allows the administrators to login as other customers, via the customer user administration panel.' =>
            'Erlaubt Administratoren sich als Kunde über die Customer-User-Administrationsoberfläche anzumelden.',
        'Allows the administrators to login as other users, via the users administration panel.' =>
            'Erlaubt Administratoren sich als anderer Agent über die Agenten-Administrationsoberfläche anzumelden.',
        'Allows to set a new ticket state in the move ticket screen of the agent interface.' =>
            'Erlaubt das Setzen eines neuen Ticket-Status im Verschieben-Bildschirm im Agenten-Interface.',
        'Archive state changed: "%s"' => 'Archivstatus geändert: "%s"',
        'ArticleTree' => 'Artikelbaum',
        'Attachments <-> Templates' => 'Anhänge <-> Vorlagen',
        'Auto Responses <-> Queues' => 'Auto-Antworten <-> Queues',
        'AutoFollowUp sent to "%s".' => 'AutoFollowUp an "%s" versandt.',
        'AutoReject sent to "%s".' => 'AutoReject an "%s" versandt.',
        'AutoReply sent to "%s".' => 'AutoReply an "%s" versandt.',
        'Automated line break in text messages after x number of chars.' =>
            'Automatischer Zeilenumbruch in Textnachrichten nach x-Zeichen.',
        'Automatically lock and set owner to current Agent after opening the move ticket screen of the agent interface.' =>
            'Automatisches Sperren und setzen des aktuellen Agenten als Besitzer nachdem der Verschieben-Bildschirm im Agenten-Interface geöffnet wurde.',
        'Automatically lock and set owner to current Agent after selecting for an Bulk Action.' =>
            'Automatisches Sperren und setzen des aktuellen Agenten als Besitzer nachdem der Sammelaktion-Bildschirm gewählt wurde.',
        'Automatically sets the owner of a ticket as the responsible for it (if ticket responsible feature is enabled).' =>
            'Automatisches Setzen des Ticket-Inhabers als Verantwortlichen. (wenn die Funktion Ticket-Verantwortlicher aktiviert ist).',
        'Automatically sets the responsible of a ticket (if it is not set yet) after the first owner update.' =>
            'Automatisches setzen eines Ticket-Verantwortlichen (wenn er noch nicht gesetzt wurde) nach dem ersten Besitzer-Update.',
        'Balanced white skin by Felix Niklas (slim version).' => 'Balanced White-Skin von Felix Niklas (slim)',
        'Balanced white skin by Felix Niklas.' => 'Balanced White Skin von Felix Niklas.',
        'Basic fulltext index settings. Execute "bin/otrs.RebuildFulltextIndex.pl" in order to generate a new index.' =>
            'Volltext-Index-Einstellungen. Um einen neuen Index zu erstellen, führen Sie "bin/otrs.RebuildFulltextIndex.pl" aus.',
        'Blocks all the incoming emails that do not have a valid ticket number in subject with From: @example.com address.' =>
            'Blockiert alle eingehenden E-Mails, die keine gültige Ticketnummer im Betreff mit Absenderadresse: @ example.com besitzen.',
        'Bounced to "%s".' => 'Bounced an "%s".',
        'Builds an article index right after the article\'s creation.' =>
            'Erstellt einen Artikel-Index direkt nach der Erstellung des Artikels.',
        'CMD example setup. Ignores emails where external CMD returns some output on STDOUT (email will be piped into STDIN of some.bin).' =>
            'CMD Beispiel-Setup. Ignoriert E-Mails, in denen ein externer CMD eine Ausgabe auf STDOUT liefert (E-Mail von some.bin wird in STDIN geleitet).',
        'Cache time in seconds for agent authentication in the GenericInterface.' =>
            'Cache-Zeit in Sekunden für Agent-Authentifizierungen im GenericInterface.',
        'Cache time in seconds for customer authentication in the GenericInterface.' =>
            'Cache-Zeit in Sekunden für Kunden-Authentifizierungen im GenericInterface.',
        'Cache time in seconds for the DB ACL backend.' => 'Cache-Zeit in Sekunden für Datenbank ACL-Backends.',
        'Cache time in seconds for the DB process backend.' => 'Cache-Zeit in Sekunden für Datenbank Prozess-Backends.',
        'Cache time in seconds for the SSL certificate attributes.' => 'Cache-Zeit in Sekunden für SSL-Zertifikatsattribute.',
        'Cache time in seconds for the ticket process navigation bar output module.' =>
            'Cache-Zeit in Sekunden für das Ticket-Prozess-Navigationsleisten-Ausgabemodul.',
        'Cache time in seconds for the web service config backend.' => 'Cache-Zeit in Sekunden für das Webservice-Konfigurations-Backend.',
        'Change password' => 'Passwort ändern',
        'Change queue!' => 'Queue ändern',
        'Change the customer for this ticket' => 'Ticket-Kunden ändern',
        'Change the free fields for this ticket' => 'Freie Felder des Tickets ändern',
        'Change the priority for this ticket' => 'Priorität des Tickets ändern',
        'Change the responsible person for this ticket' => 'Verantwortlichen des Tickets ändern',
        'Changed priority from "%s" (%s) to "%s" (%s).' => 'Priorität aktualisiert von "%s" (%s) nach "%s" (%s).',
        'Changes the owner of tickets to everyone (useful for ASP). Normally only agent with rw permissions in the queue of the ticket will be shown.' =>
            'Ändert den Besitzer der Tickets auf Alle (nützlich für ASP). In der Regel werden nur Agenten mit rw-Berechtigungen auf die Queue angezeigt.',
        'Checkbox' => 'Kontrollkästchen',
        'Checks the SystemID in ticket number detection for follow-ups (use "No" if SystemID has been changed after using the system).' =>
            'Überprüft die System-ID in der Ticketnummer-Erkennung bei FolloUps (Wählen Sie "Nein" wenn die System-ID während der Nutzung geändert wurde).',
        'Closed tickets (customer user)' => 'Geschlossene Tickets (Kundenbenutzer)',
        'Closed tickets (customer)' => 'Geschlossene Tickets (Kunden)',
        'Column ticket filters for Ticket Overviews type "Small".' => 'Ticket-Filter-Spalte für Ticketübersichten vom Typ "Klein".',
        'Columns that can be filtered in the escalation view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed.' =>
            'Spalten, die in der Eskalationen-Ansicht im Agenten-Interface gefiltert werden können. Mögliche Einstellungen: 0 = Deaktiviert, 1 = vorhanden, 2 = standardmäßig aktiviert. Hinweis: Nur Ticket-Attribute und Dynamic Fields (DynamicField_NameX) sind erlaubt.',
        'Columns that can be filtered in the locked view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed.' =>
            'Spalten, die in der Gesperrt-Ansicht im Agenten-Interface gefiltert werden können. Mögliche Einstellungen: 0 = Deaktiviert, 1 = vorhanden, 2 = standardmäßig aktiviert. Hinweis: Nur Ticket-Attribute und Dynamic Fields (DynamicField_NameX) sind erlaubt.',
        'Columns that can be filtered in the queue view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed.' =>
            'Spalten, die in der Queue-Ansicht im Agenten-Interface gefiltert werden können. Mögliche Einstellungen: 0 = Deaktiviert, 1 = vorhanden, 2 = standardmäßig aktiviert. Hinweis: Nur Ticket-Attribute und Dynamic Fields (DynamicField_NameX) sind erlaubt.',
        'Columns that can be filtered in the responsible view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed.' =>
            'Spalten, die in der Verantwortlichen-Ansicht im Agenten-Interface gefiltert werden können. Mögliche Einstellungen: 0 = Deaktiviert, 1 = vorhanden, 2 = standardmäßig aktiviert. Hinweis: Nur Ticket-Attribute und Dynamic Fields (DynamicField_NameX) sind erlaubt.',
        'Columns that can be filtered in the service view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed.' =>
            'Spalten, die in der Service-Ansicht im Agenten-Interface gefiltert werden können. Mögliche Einstellungen: 0 = Deaktiviert, 1 = vorhanden, 2 = standardmäßig aktiviert. Hinweis: Nur Ticket-Attribute und Dynamic Fields (DynamicField_NameX) sind erlaubt.',
        'Columns that can be filtered in the status view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed.' =>
            'Spalten, die in der Status-Ansicht im Agenten-Interface gefiltert werden können. Mögliche Einstellungen: 0 = Deaktiviert, 1 = vorhanden, 2 = standardmäßig aktiviert. Hinweis: Nur Ticket-Attribute und Dynamic Fields (DynamicField_NameX) sind erlaubt.',
        'Columns that can be filtered in the ticket search result view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed.' =>
            'Spalten, die in der Ergebnisliste der Ticketsuche im Agenten-Interface gefiltert werden können. Mögliche Einstellungen: 0 = Deaktiviert, 1 = vorhanden, 2 = standardmäßig aktiviert. Hinweis: Nur Ticket-Attribute und Dynamic Fields (DynamicField_NameX) sind erlaubt.',
        'Columns that can be filtered in the watch view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed.' =>
            'Spalten, die in der Beobachten-Ansicht im Agenten-Interface gefiltert werden können. Mögliche Einstellungen: 0 = Deaktiviert, 1 = vorhanden, 2 = standardmäßig aktiviert. Hinweis: Nur Ticket-Attribute und Dynamic Fields (DynamicField_NameX) sind erlaubt.',
        'Comment for new history entries in the customer interface.' => 'Kommentar für neue Historieneinträge im Kunden-Interface.',
        'Company Status' => 'Firmenstatus',
        'Company Tickets' => 'Firmen-Tickets',
        'Company name which will be included in outgoing emails as an X-Header.' =>
            'Firmenname, welcher in ausgehenden E-Mails als X-Header gesetzt werden soll.',
        'Configure Processes.' => 'Prozesse verwalten.',
        'Configure and manage ACLs.' => 'ACLs konfigurieren und verwalten.',
        'Configure your own log text for PGP.' => 'Konfigurieren Sie Ihren eigenen Log-Text für PGP.',
        'Configures a default TicketDynamicField setting. "Name" defines the dynamic field which should be used, "Value" is the data that will be set, and "Event" defines the trigger event. Please check the developer manual (http://doc.otrs.org/), chapter "Ticket Event Module".' =>
            'Konfiguriert die Standardeinstellung für TicketDynamicField. "Name" definiert das dynamische Feld, das verwendet werden soll, "Wert" sind die Daten, die gesetzt werden sollen, und "Event" definiert das Trigger-Ereignis. Für weitere Informationen schlagen Sie im Entwickler-Handbuch (http://doc.otrs.org/), im Kapitel "Ticket Event-Module" nach.',
        'Controls how to display the ticket history entries as readable values.' =>
            'Kontrolliert wie die Ticket-Historie in lesbaren Werten dargestellt wird.',
        'Controls if customers have the ability to sort their tickets.' =>
            'Legt fest, ob Kunden die Möglichkeit haben ihre Tickets zu sortieren.',
        'Controls if more than one from entry can be set in the new phone ticket in the agent interface.' =>
            'Kontrolliert, ob mehr als ein Eintrag in einem neuen Telefon-Ticket festgelegt werden kann.',
        'Controls if the admin is allowed to import a saved system configuration in SysConfig.' =>
            'Kontrolliert, ob es dem Admin erlaubt ist, eine gespeicherte Systemkonfiguration in SysConfig zu importieren.',
        'Controls if the admin is allowed to make changes to the database via AdminSelectBox.' =>
            'Überprüft ob der Administrator die Berechtigung besitzt Änderungen in der Datenbank über die AdminSelectBox zu tätigen.',
        'Controls if the ticket and article seen flags are removed when a ticket is archived.' =>
            'Kontrolliert ob die Ticket- und Artikel "Gesehen"-Fähnchen entfernt werden, wenn ein Ticket archiviert wird.',
        'Converts HTML mails into text messages.' => 'Konvertiert HTML E-Mails in Textnachrichten.',
        'Create New process ticket' => 'Neues Prozessticket',
        'Create and manage Service Level Agreements (SLAs).' => 'Service-Level-Abkommen (SLAs) erzeugen und verwalten.',
        'Create and manage agents.' => 'Agents erzeugen und verwalten.',
        'Create and manage attachments.' => 'Anlagen erzeugen und verwalten.',
        'Create and manage customer users.' => 'Kundenbenutzer erzeugen und verwalten.',
        'Create and manage customers.' => 'Kunden erzeugen und verwalten.',
        'Create and manage dynamic fields.' => 'Dynamische Felder erzeugen und verwalten.',
        'Create and manage event based notifications.' => 'Ereignisbasierte Benachrichtigungen erzeugen und verwalten.',
        'Create and manage groups.' => 'Gruppen erzeugen und verwalten.',
        'Create and manage queues.' => 'Queues erzeugen und verwalten.',
        'Create and manage responses that are automatically sent.' => 'Vorlagen für automatische Antworten erzeugen und verwalten.',
        'Create and manage roles.' => 'Rollen erzeugen und verwalten.',
        'Create and manage salutations.' => 'Anreden erzeugen und verwalten.',
        'Create and manage services.' => 'Services erzeugen und verwalten.',
        'Create and manage signatures.' => 'Signaturen erzeugen und verwalten.',
        'Create and manage templates.' => 'Vorlagen erzeugen und verwalten.',
        'Create and manage ticket priorities.' => 'Ticket-Prioritäten erzeugen und verwalten.',
        'Create and manage ticket states.' => 'Ticket-Status  erzeugen und verwalten.',
        'Create and manage ticket types.' => 'Ticket-Typen erzeugen und verwalten.',
        'Create and manage web services.' => 'Webservices erzeugen und verwalten.',
        'Create new email ticket and send this out (outbound)' => 'Neues E-Mail-Ticket erzeugen und versenden (ausgehend)',
        'Create new phone ticket (inbound)' => 'Neues Telefonticket erstellen (eingehend)',
        'Create new process ticket' => 'Neues Prozessticket',
        'Custom text for the page shown to customers that have no tickets yet (if you need those text translated add them to a custom translation module).' =>
            'Benutzerdefinierter Text für Kunden, die noch keine Tickets haben (wenn Sie für diesen Text eine Übersetzung wünschen, fügen Sie die Übersetzung in einem eigenen Übersetzungsmodul hinzu).',
        'Customer Administration' => 'Kundenverwaltung',
        'Customer User <-> Groups' => 'Kundenbenutzer <-> Gruppen',
        'Customer User <-> Services' => 'Kundenbenutzer <-> Services',
        'Customer User Administration' => 'Kundenbenutzerverwaltung',
        'Customer Users' => 'Kundenbenutzer',
        'Customer called us.' => 'Kunde hat angerufen.',
        'Customer item (icon) which shows the closed tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            'Kunden-Tickets (Symbol), die die geschlossenen Tickets eines Kunden als Infoblock anzeigt. Setzen Sie die Einstellung CustomerUserLogin auf 1 um Tickets auf Basis des Login-Namens zu suchen anstatt auf Basis der CustomerID.',
        'Customer item (icon) which shows the open tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            'Kunden-Tickets (Symbol), die die offenen Tickets eines Kunden als Infoblock anzeigt. Setzen Sie die Einstellung CustomerUserLogin auf 1 um Tickets auf Basis des Login-Namens zu suchen anstatt auf Basis der CustomerID.',
        'Customer request via web.' => 'Kunde stellte Anfrage über Web.',
        'CustomerName' => 'Kundenname',
        'Customers <-> Groups' => 'Kunden <-> Gruppen',
        'Data used to export the search result in CSV format.' => 'Daten die verwendet werden um das Suchergebnis im CSV-Format zu exportieren.',
        'Date / Time' => 'Datum / Zeit',
        'Debugs the translation set. If this is set to "Yes" all strings (text) without translations are written to STDERR. This can be helpful when you are creating a new translation file. Otherwise, this option should remain set to "No".' =>
            'Debuggt die Übersetzungen. Wenn dies auf "Ja" gesetzt ist, werden alle nicht übersetzten Strings (Text), zur STDERR hinzugefügt. Dies kann hilfreich sein, wenn Sie eine eigene Übersetzung anlegen. Ansonsten sollte diese Option auf "Nein" gesetzt bleiben.',
        'Default ACL values for ticket actions.' => 'Standard ACL-Werte für Ticketaktionen.',
        'Default ProcessManagement entity prefixes for entity IDs that are automatically generated.' =>
            'Standard Entitäts-Präfixe des Prozessmanagements für Entitäts-IDs, die automatisch generiert werden.',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimePointFormat=year;TicketCreateTimePointStart=Last;TicketCreateTimePoint=2;".' =>
            'Standarddaten, die als Attribute für die für die Ticket-Suchmaske verwendet werden. Beispiel: "TicketCreateTimePointFormat = Jahr; TicketCreateTimePointStart = Letzter; TicketCreateTimePoint = 2;".',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimeStartYear=2010;TicketCreateTimeStartMonth=10;TicketCreateTimeStartDay=4;TicketCreateTimeStopYear=2010;TicketCreateTimeStopMonth=11;TicketCreateTimeStopDay=3;".' =>
            'Standarddaten, die als Attribute für die für die Ticket-Suchmaske verwendet werden. Beispiel: "TicketCreateTimeStartYear=2010;TicketCreateTimeStartMonth=10;TicketCreateTimeStartDay=4;TicketCreateTimeStopYear=2010;TicketCreateTimeStopMonth=11;TicketCreateTimeStopDay=3;".',
        'Default loop protection module.' => 'Standard "Loop Protection"-Modul',
        'Default queue ID used by the system in the agent interface.' => 'Standard-Queue-ID welche von OTRS in der Agentenoberfläche verwendet wird.',
        'Default skin for OTRS 3.0 interface.' => 'Standard-Skin für die OTRS 3.0 Oberfläche',
        'Default skin for the agent interface (slim version).' => 'Standard-Skin für die Agentenoberfläche (Slim)',
        'Default skin for the agent interface.' => 'Standard-Skin für die Agentenoberfläche',
        'Default ticket ID used by the system in the agent interface.' =>
            'Standard-Ticket-ID welche von OTRS in der Agentenoberfläche verwendet wird.',
        'Default ticket ID used by the system in the customer interface.' =>
            'Standard-Ticket-ID welche von OTRS in der Kundenoberfläche verwendet wird.',
        'Default value for NameX' => 'Standardwert für NameX',
        'Define a filter for html output to add links behind a defined string. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Definiert einen Filter für die HTML-Ausgabe um Links hinter einer bestimmten Zeichenfolge hinzufügen. Dieses Element erlaubt zwei Eingabearten. Zum einem den Namen eines Bildes (Beispielsweise faq.png). In diesem Fall wird der OTRS-Bildpfad verwendet. Die zweite Möglichkeit ist, den Link zu dem Bild einzufügen.',
        'Define a mapping between variables of the customer user data (keys) and dynamic fields of a ticket (values). The purpose is to store customer user data in ticket dynamic fields. The dynamic fields must be present in the system and should be enabled for AgentTicketFreeText, so that they can be set/updated manually by the agent. They mustn\'t be enabled for AgentTicketPhone, AgentTicketEmail and AgentTicketCustomer. If they were, they would have precedence over the automatically set values. To use this mapping, you have to also activate the next setting below.' =>
            'Definiert eine Zuordnung zwischen Variablen der Kundenbenutzerdaten (Schlüssel) und dynamischen Feldern eines Ticket (Werte). Somit können Sie Kundenbenutzerdaten eines Tickets in dynamische Felder speichern. Die dynamischen Felder müssen im System vorhanden sein und sollten für AgentTicketFreeText aktiviert werden, damit sie eingestellt / manuell durch den Agenten aktualisiert werden können. Sie dürfen nicht für AgentTicketPhone, AgentTicketEmail und AgentTicketCustomer aktiviert werden. Wenn sie in diesen Masken aktiviert werden, werden später automatisch gesetzte Werte überschrieben werden. Um dieses Mapping zu verwenden, müssen Sie auch Sie die nächste Einstellung aktivieren.',
        'Define dynamic field name for end time. This field has to be manually added to the system as Ticket: "Date / Time" and must be activated in ticket creation screens and/or in any other ticket action screens.' =>
            'Definiert dynamische Feldnamen für die Endzeit. Dieses Feld muss manuell im System als Ticket: "Datum / Uhrzeit" hinzugefügt werden und muss in Ticketerstellungsoberflächen und / oder in anderen Ticket-Aktionsoberflächen aktiviert werden.',
        'Define dynamic field name for start time. This field has to be manually added to the system as Ticket: "Date / Time" and must be activated in ticket creation screens and/or in any other ticket action screens.' =>
            'Definiert dynamische Feldnamen für die Startzeit. Dieses Feld muss manuell im System als Ticket: "Datum / Uhrzeit" hinzugefügt werden und muss in Ticketerstellungsoberflächen und / oder in anderen Ticket-Aktionsoberflächen aktiviert werden.',
        'Define the max depth of queues.' => 'Definiert die maximale Tiefe von Queues',
        'Define the start day of the week for the date picker for the indicated calendar.' =>
            '',
        'Define the start day of the week for the date picker.' => 'Definiert den Beginn einer Woche für den Datumswähler.',
        'Defines a customer item, which generates a LinkedIn icon at the end of a customer info block.' =>
            'Definiert einen Punkt, welcher ein LinedIn-Symbol am Endes der Kundeninformation hinzufügt.',
        'Defines a customer item, which generates a XING icon at the end of a customer info block.' =>
            'Definiert einen Punkt, welcher ein XINGSymbol am Endes der Kundeninformation hinzufügt.',
        'Defines a customer item, which generates a google icon at the end of a customer info block.' =>
            'Definiert einen Punkt, welcher ein GoogleSymbol am Endes der Kundeninformation hinzufügt.',
        'Defines a customer item, which generates a google maps icon at the end of a customer info block.' =>
            'Definiert einen Punkt, welcher ein Google-Maps-Symbol am Endes der Kundeninformation hinzufügt.',
        'Defines a default list of words, that are ignored by the spell checker.' =>
            'Definiert eine Standardliste von Wörtern, die von der Rechtschreibprüfung ignoriert werden.',
        'Defines a filter for html output to add links behind CVE numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Definiert einen Filter für die HTML-Ausgabe um Links hinter CVE-Nummern hinzufügen. Das Element Bild erlaubt zwei Eingabearten. Zum einem den Namen eines Bildes (Beispielsweise faq.png). In diesem Fall wird der OTRS-Bildpfad verwendet. Die zweite Möglichkeit ist, den Link zu dem Bild einzufügen.',
        'Defines a filter for html output to add links behind MSBulletin numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Definiert einen Filter für die HTML-Ausgabe um Links hinter einer MSBulletin-Nummer hinzufügen. Das Element Bild erlaubt zwei Eingabearten. Zum einem den Namen eines Bildes (Beispielsweise faq.png). In diesem Fall wird der OTRS-Bildpfad verwendet. Die zweite Möglichkeit ist, den Link zu dem Bild einzufügen.',
        'Defines a filter for html output to add links behind a defined string. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Definiert einen Filter für die HTML-Ausgabe um Links hinter einer bestimmten Zeichenfolge hinzufügen. Das Element Bild erlaubt zwei Eingabearten. Zum einem den Namen eines Bildes (Beispielsweise faq.png). In diesem Fall wird der OTRS-Bildpfad verwendet. Die zweite Möglichkeit ist, den Link zu dem Bild einzufügen.',
        'Defines a filter for html output to add links behind bugtraq numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Definiert einen Filter für die HTML-Ausgabe um Links hinter Bugtraq-Nummern hinzufügen. Das Element Bild erlaubt zwei Eingabearten. Zum einem den Namen eines Bildes (Beispielsweise faq.png). In diesem Fall wird der OTRS-Bildpfad verwendet. Die zweite Möglichkeit ist, den Link zu dem Bild einzufügen.',
        'Defines a filter to process the text in the articles, in order to highlight predefined keywords.' =>
            'Definiert einen Filter, um den Text in den Artikel zu verarbeiten, um vordefinierte Schlüsselwörter zu markieren.',
        'Defines a regular expression that excludes some addresses from the syntax check (if "CheckEmailAddresses" is set to "Yes"). Please enter a regex in this field for email addresses, that aren\'t syntactically valid, but are necessary for the system (i.e. "root@localhost").' =>
            'Definiert Regular-Expressions die einige Adressen von der Syntaxprüfung ausschließt (wenn "CheckEmailAddresses" auf \'"Ja" gesetzt ist). Bitte geben Sie in diesem Feld eine Regex für E-Mail-Adressen an, die syntaktisch nicht gültig, aber für das System (z.B.: "root@localhost") notwendig sind.',
        'Defines a regular expression that filters all email addresses that should not be used in the application.' =>
            'Definiert einen regulären Ausdruck, der alle E-Mail-Adressen filtert, die in der Anwendung nicht verwendet werden sollen',
        'Defines a useful module to load specific user options or to display news.' =>
            'Definiert ein nützliches Modul um bestimmte User-Optionen zu laden oder um Neuigkeiten anzuzeigen.',
        'Defines all the X-headers that should be scanned.' => 'Definiert alle X-Headers, die überprüft werden sollen.',
        'Defines all the languages that are available to the application. The Key/Content pair links the front-end display name to the appropriate language PM file. The "Key" value should be the base-name of the PM file (i.e. de.pm is the file, then de is the "Key" value). The "Content" value should be the display name for the front-end. Specify any own-defined language here (see the developer documentation http://doc.otrs.org/ for more infomation). Please remember to use the HTML equivalents for non-ASCII characters (i.e. for the German oe = o umlaut, it is necessary to use the &ouml; symbol).' =>
            '',
        'Defines all the parameters for the RefreshTime object in the customer preferences of the customer interface.' =>
            'Definiert alle Parameter für das Objekt RefreshTime in den Kundeneinstellungen des Kunden-Interface.',
        'Defines all the parameters for the ShownTickets object in the customer preferences of the customer interface.' =>
            'Definiert alle Parameter für das Objekt ShownTickets in den Kundeneinstellungen des Kunden-Interface.',
        'Defines all the parameters for this item in the customer preferences.' =>
            'Definiert alle Parameter für Kunden-Einstellungen.',
        'Defines all the possible stats output formats.' => 'Definiert alle möglichen Statistikausgabeformate.',
        'Defines an alternate URL, where the login link refers to.' => 'Definiert eine alternative URL, auf die der Login-Link verweist.',
        'Defines an alternate URL, where the logout link refers to.' => 'Definiert eine alternative URL, auf die der Logout-Link verweist.',
        'Defines an alternate login URL for the customer panel..' => 'Definiert für die Kundenoberfläche eine alternative Anmelde-URL, auf die der Login-Link verweist.',
        'Defines an alternate logout URL for the customer panel.' => 'Definiert für die Kundenoberfläche eine alternative Abmelde-URL, auf die der Logout-Link verweist.',
        'Defines an external link to the database of the customer (e.g. \'http://yourhost/customer.php?CID=[% Data.CustomerID %]\' or \'\').' =>
            'Definiert eine externen Verbindung zu einer Kundendatenbank (z.B.: \'http://yourhost/customer.php?CID=[% Data.CustomerID %]\' or \'\').',
        'Defines from which ticket attributes the agent can select the result order.' =>
            'Definiert aus welchen Ticket-Attributen der Agent die Ergebnissortierung wählen kann.',
        'Defines how the From field from the emails (sent from answers and email tickets) should look like.' =>
            'Definiert, wie das "Von:"-Feld in den E-Mails (gesendet von Antworten und E-Mail-Tickets) aussehen soll.',
        'Defines if a pre-sorting by priority should be done in the queue view.' =>
            'Definiert ob in der Queue-View eine Vorsortierung anhand der Priorität vorgenommen werden soll.',
        'Defines if a pre-sorting by priority should be done in the service view.' =>
            'Bestimmt, ob in der Service-Ansicht eine Vorsortierung anhand der Priorität vorgenommen werden soll.',
        'Defines if a ticket lock is required in the close ticket screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Bestimmt, ob dieser Screen im Agenten-Interface das Sperren des Tickets voraussetzt. Das Ticket wird (falls nötig) gesperrt und der aktuelle Agent wird als Besitzer gesetzt.',
        'Defines if a ticket lock is required in the email outbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Bestimmt, ob dieser Screen im Agenten-Interface das Sperren des Tickets voraussetzt. Das Ticket wird (falls nötig) gesperrt und der aktuelle Agent wird als Besitzer gesetzt.',
        'Defines if a ticket lock is required in the ticket bounce screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Bestimmt, ob dieser Screen im Agenten-Interface das Sperren des Tickets voraussetzt. Das Ticket wird (falls nötig) gesperrt und der aktuelle Agent wird als Besitzer gesetzt.',
        'Defines if a ticket lock is required in the ticket compose screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Bestimmt, ob dieser Screen im Agenten-Interface das Sperren des Tickets voraussetzt. Das Ticket wird (falls nötig) gesperrt und der aktuelle Agent wird als Besitzer gesetzt.',
        'Defines if a ticket lock is required in the ticket forward screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Bestimmt, ob dieser Screen im Agenten-Interface das Sperren des Tickets voraussetzt. Das Ticket wird (falls nötig) gesperrt und der aktuelle Agent wird als Besitzer gesetzt.',
        'Defines if a ticket lock is required in the ticket free text screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Bestimmt, ob dieser Screen im Agenten-Interface das Sperren des Tickets voraussetzt. Das Ticket wird (falls nötig) gesperrt und der aktuelle Agent wird als Besitzer gesetzt.',
        'Defines if a ticket lock is required in the ticket merge screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Bestimmt, ob dieser Screen im Agenten-Interface das Sperren des Tickets voraussetzt. Das Ticket wird (falls nötig) gesperrt und der aktuelle Agent wird als Besitzer gesetzt.',
        'Defines if a ticket lock is required in the ticket note screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Bestimmt, ob dieser Screen im Agenten-Interface das Sperren des Tickets voraussetzt. Das Ticket wird (falls nötig) gesperrt und der aktuelle Agent wird als Besitzer gesetzt.',
        'Defines if a ticket lock is required in the ticket owner screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Bestimmt, ob dieser Screen im Agenten-Interface das Sperren des Tickets voraussetzt. Das Ticket wird (falls nötig) gesperrt und der aktuelle Agent wird als Besitzer gesetzt.',
        'Defines if a ticket lock is required in the ticket pending screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Bestimmt, ob dieser Screen im Agenten-Interface das Sperren des Tickets voraussetzt. Das Ticket wird (falls nötig) gesperrt und der aktuelle Agent wird als Besitzer gesetzt.',
        'Defines if a ticket lock is required in the ticket phone inbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Bestimmt, ob dieser Screen im Agenten-Interface das Sperren des Tickets voraussetzt. Das Ticket wird (falls nötig) gesperrt und der aktuelle Agent wird als Besitzer gesetzt.',
        'Defines if a ticket lock is required in the ticket phone outbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Bestimmt, ob dieser Screen im Agenten-Interface das Sperren des Tickets voraussetzt. Das Ticket wird (falls nötig) gesperrt und der aktuelle Agent wird als Besitzer gesetzt.',
        'Defines if a ticket lock is required in the ticket priority screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Bestimmt, ob dieser Screen im Agenten-Interface das Sperren des Tickets voraussetzt. Das Ticket wird (falls nötig) gesperrt und der aktuelle Agent wird als Besitzer gesetzt.',
        'Defines if a ticket lock is required in the ticket responsible screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Bestimmt, ob dieser Screen im Agenten-Interface das Sperren des Tickets voraussetzt. Das Ticket wird (falls nötig) gesperrt und der aktuelle Agent wird als Besitzer gesetzt.',
        'Defines if a ticket lock is required to change the customer of a ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Bestimmt, ob dieser Screen im Agenten-Interface das Sperren des Tickets voraussetzt. Das Ticket wird (falls nötig) gesperrt und der aktuelle Agent wird als Besitzer gesetzt.',
        'Defines if composed messages have to be spell checked in the agent interface.' =>
            'Bestimmt, ob im Agenten-Interface eine Rechtschreibprüfung für Nachrichten vorgenommen werden muss.',
        'Defines if the enhanced mode should be used (enables use of table, replace, subscript, superscript, paste from word, etc.).' =>
            'Bestimmt, ob der erweiterte Modus genutzt werden soll (schaltet die Benutzung von Tabellen, Suchen & Ersetzen, Tiefstellen, Hochstellen, aus Word einfügen, etc. frei).',
        'Defines if the list for filters should be retrieve just from current tickets in system. Just for clarification, Customers list will always came from system\'s tickets.' =>
            '',
        'Defines if time accounting is mandatory in the agent interface. If activated, a note must be entered for all ticket actions (no matter if the note itself is configured as active or is originally mandatory for the individual ticket action screen).' =>
            'Definiert ob die Zeiterfassung verpflichtend in der Agenten-Oberfläche ist. Wenn diese Funktion aktiviert ist, muss eine Notiz für alle Ticketaktionen (egal ob die Notiz als aktiv konfiguriert ist oder ursprünglich zwingend für die individuellen Ticket-Aktionen konfiguert wurde).',
        'Defines if time accounting must be set to all tickets in bulk action.' =>
            'Bestimmt, ob das Zeiterfassungs-Feld für alle Tickets im Stapelverarbeitungs-Bildschirm gesetzt werden soll.',
        'Defines queues that\'s tickets are used for displaying as calendar events.' =>
            'Bestimmt die Queues, deren Tickets für die Anzeige als Kalender-Ereignisse berücksichtigt werden sollen.',
        'Defines scheduler PID update time in seconds.' => 'Definiert die Scheduler-PID Updatezeit in Sekunden.',
        'Defines scheduler sleep time in seconds after processing all available tasks (floating point number).' =>
            'Definiert die Wartezeit des Schedulers in Sekunden nachdem alle verfügbaren Aufgaben ausgeführt wurden (Fließkommazahl).',
        'Defines the IP regular expression for accessing the local repository. You need to enable this to have access to your local repository and the package::RepositoryList is required on the remote host.' =>
            'Definiert die Regular Expressions für IPs für den Zugriff auf das lokale Repository. Sie müssen diese Einstellungen aktivieren um Zugang zu Ihrem lokalen Repository zu haben, ebenfalls muss das Paket package::RepositoryList auf dem Remote-Host installiert sein.',
        'Defines the URL CSS path.' => 'Definiert den URL-CSS-Pfad',
        'Defines the URL base path of icons, CSS and Java Script.' => 'Definiert den URL-Basispfad von Symbolen, CSS und JavaScript',
        'Defines the URL image path of icons for navigation.' => 'Definiert den URL-Bildpfad von Symbolen für die Navigation',
        'Defines the URL java script path.' => 'Definiert den URL-JavaScript-Pfad',
        'Defines the URL rich text editor path.' => 'Definiert den URL-RichTextEditor-Pfad.',
        'Defines the address of a dedicated DNS server, if necessary, for the "CheckMXRecord" look-ups.' =>
            'Definiert die Adresse eines dedizierten DNS-Server, wenn nötig, für "CheckMXRecord" Auflösungen.',
        'Defines the body text for notification mails sent to agents, about new password (after using this link the new password will be sent).' =>
            'Definiert den Text im Hauptteil für Benachrichtigungs-Emails, die wegen eines neuen Passworts an Agenten geschickt werden (nachdem dieser Link benutzt wird, wird das neue Passwort gesendet).',
        'Defines the body text for notification mails sent to agents, with token about new requested password (after using this link the new password will be sent).' =>
            'Definiert den Text im Hauptteil für Benachrichtigungs-Emails für Agenten, inklusive eines Tokens für die Passwortänderungsanfrage (nachdem dieser Link benutzt wird, wird das neue Passwort gesendet).',
        'Defines the body text for notification mails sent to customers, about new account.' =>
            'Definiert den Text im Hauptteil für Benachrichtigungs-Emails, die wegen eines neuen Accounts an Kunden geschickt wird.',
        'Defines the body text for notification mails sent to customers, about new password (after using this link the new password will be sent).' =>
            'Definiert den Text im Hauptteil für Benachrichtigungs-Emails, die wegen eines neuen Passworts an Kunden geschickt wird (nachdem dieser Link benutzt wird, wird das neue Passwort gesendet).',
        'Defines the body text for notification mails sent to customers, with token about new requested password (after using this link the new password will be sent).' =>
            'Definiert den Text im Hauptteil für Benachrichtigungs-Emails für Kunden, inklusive eines Tokens für die Passwortänderungsanfrage (nachdem dieser Link benutzt wird, wird das neue Passwort gesendet).',
        'Defines the body text for rejected emails.' => 'Definiert den Body-Text für abgelehnte E-Mails.',
        'Defines the boldness of the line drawed by the graph.' => 'Definiert die Stärke der Graphenlinie.',
        'Defines the calendar width in percent. Default is 95%.' => 'Definiert die Kalenderbreite in Prozent. Standard ist 95%',
        'Defines the colors for the graphs.' => 'Definiert die Farben der Graphen',
        'Defines the column to store the keys for the preferences table.' =>
            'Definiert die Spalte um die Schlüssel in der Eigenschaften-Tabelle zu speichern',
        'Defines the config options for the autocompletion feature.' => 'Definiert die Konfigurationsoptionen für die Autovervollständigung.',
        'Defines the config parameters of this item, to be shown in the preferences view.' =>
            'Definiert die Konfigurationsparamenter des Items, die in der Eigenschaftenanzeige angezeigt wird.',
        'Defines the config parameters of this item, to be shown in the preferences view. Take care to maintain the dictionaries installed in the system in the data section.' =>
            '',
        'Defines the connections for http/ftp, via a proxy.' => 'Definiert Verbindungen für HTTP/FTP über einen Proxy.',
        'Defines the date input format used in forms (option or input fields).' =>
            'Definiert das benutzte Datumseingabeformat in Formularen (Option für Eingabefelder).',
        'Defines the default CSS used in rich text editors.' => 'Definiert die genutzte Standard-CSS in RichText-Editoren.',
        'Defines the default auto response type of the article for this operation.' =>
            'Definiert den Standard-Auto-Antwort-Typ des Artikels für diese Operation.',
        'Defines the default body of a note in the ticket free text screen of the agent interface.' =>
            'Definiert den Standard-Inhalt einer Notiz in der TicketFreeText-Oberfläche im Agenten-Interface.',
        'Defines the default front-end (HTML) theme to be used by the agents and customers. If you like, you can add your own theme. Please refer the administrator manual located at http://doc.otrs.org/.' =>
            '',
        'Defines the default front-end language. All the possible values are determined by the available language files on the system (see the next setting).' =>
            'Definiert die Standard-Frontend-Sprache. Die möglichen Werte werden durch die verfügbaren Sprachdateien auf dem System bestimmt (siehe nächste Einstellung).',
        'Defines the default history type in the customer interface.' => 'Definiert den Standard-Historientyp im Kunden-Interface.',
        'Defines the default maximum number of X-axis attributes for the time scale.' =>
            'Definiert die standardmäßig eingestellte maximale Anzahl von Attributen für die x-Achse für die Zeitachse.',
        'Defines the default maximum number of search results shown on the overview page.' =>
            'Definiert die standardmäßig eingestellte maximale Anzahl an Suchergebnissen, die auf der Überblick-Seite angezeigt werden.',
        'Defines the default next state for a ticket after customer follow up in the customer interface.' =>
            'Bestimmt den Folgestatus für Tickets, auf die ein Kunde über das Kunden-Interface geantwortet hat.',
        'Defines the default next state of a ticket after adding a note, in the close ticket screen of the agent interface.' =>
            'Bestimmt den Folgestatus für Tickets, für die im Schließen-Bildschirm im Agenten-Interface eine Notiz hinzugefügt wurde.',
        'Defines the default next state of a ticket after adding a note, in the ticket bulk screen of the agent interface.' =>
            'Bestimmt den Folgestatus für Tickets, für die im Stapelverarbeitungs-Bildschirm im Agenten-Interface eine Notiz hinzugefügt wurde.',
        'Defines the default next state of a ticket after adding a note, in the ticket free text screen of the agent interface.' =>
            'Bestimmt den Folgestatus für Tickets, für die im Freitextfelder-Bildschirm im Agenten-Interface eine Notiz hinzugefügt wurde.',
        'Defines the default next state of a ticket after adding a note, in the ticket note screen of the agent interface.' =>
            'Bestimmt den Folgestatus für Tickets, für die im Notiz-Bildschirm im Agenten-Interface eine Notiz hinzugefügt wurde.',
        'Defines the default next state of a ticket after adding a note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Bestimmt den Folgestatus für Tickets, für die im Besitzer-Bildschirm im Agenten-Interface eine Notiz hinzugefügt wurde.',
        'Defines the default next state of a ticket after adding a note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Bestimmt den Folgestatus für Tickets, für die im Warten bis-Bildschirm im Agenten-Interface eine Notiz hinzugefügt wurde.',
        'Defines the default next state of a ticket after adding a note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Bestimmt den Folgestatus für Tickets, für die im Prioritäts-Bildschirm im Agenten-Interface eine Notiz hinzugefügt wurde.',
        'Defines the default next state of a ticket after adding a note, in the ticket responsible screen of the agent interface.' =>
            'Bestimmt den Folgestatus für Tickets, für die im Verantwortlicher-Bildschirm im Agenten-Interface eine Notiz hinzugefügt wurde.',
        'Defines the default next state of a ticket after being bounced, in the ticket bounce screen of the agent interface.' =>
            'Bestimmt den Folgestatus für Tickets, für die im Umleiten-Bildschirm im Agenten-Interface eine Notiz hinzugefügt wurde.',
        'Defines the default next state of a ticket after being forwarded, in the ticket forward screen of the agent interface.' =>
            'Bestimmt den Folgestatus für Tickets, für die im Weiterleiten-Bildschirm im Agenten-Interface eine Notiz hinzugefügt wurde.',
        'Defines the default next state of a ticket after the message has been sent, in the email outbound screen of the agent interface.' =>
            'Bestimmt den Folgestatus für Tickets, nachdem eine ausgehende E-Mail versendet wurde.',
        'Defines the default next state of a ticket if it is composed / answered in the ticket compose screen of the agent interface.' =>
            'Bestimmt den Folgestatus für Tickets, auf die ein Agent im Antworten-Bildschirm im Agenten-Interface geantwortet hat.',
        'Defines the default note body text for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            'Bestimmt die Vorbelegung des Textfeldes für Telefon-Tickets im Bildschirm für eingehende Anrufe im Agenten-Interface.',
        'Defines the default note body text for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            'Bestimmt die Vorbelegung des Textfeldes für Telefon-Tickets im Bildschirm für ausgehende Anrufe im Agenten-Interface.',
        'Defines the default priority of follow up customer tickets in the ticket zoom screen in the customer interface.' =>
            'Definiert die Standard-Priorität von Kunden-FollowUps in der TicketZoom-Oberfläche im Kundenoberfläche.',
        'Defines the default priority of new customer tickets in the customer interface.' =>
            'Definiert die Standard-Prioriät von neuen Kundentickets in der Kundenoberfläche.',
        'Defines the default priority of new tickets.' => 'Definiert die Standard-Priorität von neuen Tickets.',
        'Defines the default queue for new customer tickets in the customer interface.' =>
            'Definiert den Standard-Queue von neuen Kundentickets in der Kundenoberfläche.',
        'Defines the default selection at the drop down menu for dynamic objects (Form: Common Specification).' =>
            'Definiert die Standardauswahl in der Einfachauswahl für dynamische Objekte (Formular: genauere Spezifikation).',
        'Defines the default selection at the drop down menu for permissions (Form: Common Specification).' =>
            '',
        'Defines the default selection at the drop down menu for stats format (Form: Common Specification). Please insert the format key (see Stats::Format).' =>
            '',
        'Defines the default sender type for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            'Bestimmt den Standard-Absendertyp für Telefon-Tickets in der Eingehende-Telefon-Tickets-Anzeige in der Agenten-Oberfläche.',
        'Defines the default sender type for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            'Bestimmt den Standard-Absendertp für Telefon-Tickets in der Ausgehende-Telefon-Tickets-Anzeige in der Agenten-Oberfläche.',
        'Defines the default sender type for tickets in the ticket zoom screen of the customer interface.' =>
            'Bestimmt den Standard-Absendertp für Telefon-Tickets in der TicketZoom-Anzeige in der Agenten-Oberfläche.',
        'Defines the default shown ticket search attribute for ticket search screen.' =>
            'Definiert die standardmäßig angezeigten Ticketsuchattribute für die Ticketsuche.',
        'Defines the default shown ticket search attribute for ticket search screen. Example: "Key" must have the name of the Dynamic Field in this case \'X\', "Content" must have the value of the Dynamic Field depending on the Dynamic Field type,  Text: \'a text\', Dropdown: \'1\', Date/Time: \'Search_DynamicField_XTimeSlotStartYear=1974; Search_DynamicField_XTimeSlotStartMonth=01; Search_DynamicField_XTimeSlotStartDay=26; Search_DynamicField_XTimeSlotStartHour=00; Search_DynamicField_XTimeSlotStartMinute=00; Search_DynamicField_XTimeSlotStartSecond=00; Search_DynamicField_XTimeSlotStopYear=2013; Search_DynamicField_XTimeSlotStopMonth=01; Search_DynamicField_XTimeSlotStopDay=26; Search_DynamicField_XTimeSlotStopHour=23; Search_DynamicField_XTimeSlotStopMinute=59; Search_DynamicField_XTimeSlotStopSecond=59;\' and or \'Search_DynamicField_XTimePointFormat=week; Search_DynamicField_XTimePointStart=Before; Search_DynamicField_XTimePointValue=7\';.' =>
            'Definiert die Standard Suchattribute für die Ticketsuche Beispiel: "Key" muss den Namen des dynamischen Feldes haben, in diesem Fall \'X\', "Content" muss den Wert des dynamischen Feldes, abhängig vom Feldtyp, haben, Text: \'ein Text\', Dropdown: \'1\', Date/Time: \'Search_DynamicField_XTimeSlotStartYear=1974; Search_DynamicField_XTimeSlotStartMonth=01; Search_DynamicField_XTimeSlotStartDay=26; Search_DynamicField_XTimeSlotStartHour=00; Search_DynamicField_XTimeSlotStartMinute=00; Search_DynamicField_XTimeSlotStartSecond=00; Search_DynamicField_XTimeSlotStopYear=2013; Search_DynamicField_XTimeSlotStopMonth=01; Search_DynamicField_XTimeSlotStopDay=26; Search_DynamicField_XTimeSlotStopHour=23; Search_DynamicField_XTimeSlotStopMinute=59; Search_DynamicField_XTimeSlotStopSecond=59;\' and or \'Search_DynamicField_XTimePointFormat=week; Search_DynamicField_XTimePointStart=Before; Search_DynamicField_XTimePointValue=7\';.',
        'Defines the default sort criteria for all queues displayed in the queue view.' =>
            'Definiert die standardmäßig eingestellten Sortierkriterien für alle in der Queue-Ansicht angezeigten Queues.',
        'Defines the default sort criteria for all services displayed in the service view.' =>
            'Definiert die standardmäßig eingestellten Sortierkriterien für alle in der Service-Ansicht angezeigten Dienste.',
        'Defines the default sort order for all queues in the queue view, after priority sort.' =>
            'Definiert die standardmäßig eingestellten Sortierkriterien für alle in der Queue-Ansicht angezeigten Queues, nachdem nach Priorität sortiert wurde.',
        'Defines the default sort order for all services in the service view, after priority sort.' =>
            'Definiert die standardmäßig eingestellten Sortierkriterien für alle in der Service-Ansicht angezeigten Dienste, nachdem nach Priorität sortiert wurde.',
        'Defines the default spell checker dictionary.' => 'Definiert das Standard Rechtschreib-Wörterbuch',
        'Defines the default state of new customer tickets in the customer interface.' =>
            'Definiert den Standard-Status von neuen Kundentickets in der Kundenoberfläche.',
        'Defines the default state of new tickets.' => 'Definiert den Standard-Status von neuen Tickets.',
        'Defines the default subject for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            'Bestimmt den Standard-Betreff für Telefon-Tickets in der Eingehende-Telefon-Tickets-Anzeige in der Agent-Oberfläche.',
        'Defines the default subject for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            'Bestimmt den Standard-Betreff für Telefon-Tickets in der Ausgehende-Telefon-Tickets-Anzeige in der Agent-Oberfläche.',
        'Defines the default subject of a note in the ticket free text screen of the agent interface.' =>
            'Bestimmt den Standard-Betreff einer Notiz im Ticket-Freitext-Bildschirm des Agenten-Interfaces.',
        'Defines the default ticket attribute for ticket sorting in a ticket search of the customer interface.' =>
            'Bestimmt das Standard-Ticket-Attribut für das Sortieren der Tickets in einer Ticket-Suche im Kunden-Interface.',
        'Defines the default ticket attribute for ticket sorting in the escalation view of the agent interface.' =>
            'Bestimmt das Standard-Ticket-Attribut für das Sortieren der Tickets in der Eskalations-Anzeige im Agent-Interface.',
        'Defines the default ticket attribute for ticket sorting in the locked ticket view of the agent interface.' =>
            'Bestimmt das Standard-Ticket-Attribut für das Sortieren der Tickets in der Gesperrte-Tickets-Anzeige im Agent-Interface.',
        'Defines the default ticket attribute for ticket sorting in the responsible view of the agent interface.' =>
            'Bestimmt das Standard-Ticket-Attribut für das Sortieren der Tickets in der Verantwortlicher-Anzeige im Agent-Interface.',
        'Defines the default ticket attribute for ticket sorting in the status view of the agent interface.' =>
            'Bestimmt das Standard-Ticket-Attribut für das Sortieren der Tickets in der Status-Anzeige im Agent-Interface.',
        'Defines the default ticket attribute for ticket sorting in the watch view of the agent interface.' =>
            'Bestimmt das Standard-Ticket-Attribut für das Sortieren der Tickets in der Beobachten-Anzeige im Agent-Interface.',
        'Defines the default ticket attribute for ticket sorting of the ticket search result of the agent interface.' =>
            'Bestimmt das Standard-Ticket-Attribut für das Sortieren der Tickets des Ticket-Suchergebnis im Agent-Interface.',
        'Defines the default ticket attribute for ticket sorting of the ticket search result of this operation.' =>
            'Bestimmt das Standard-Ticket-Attribut für das Sortieren der Tickets im Ticket-Suchergebnis von dieser Operation.',
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
        'Defines the default ticket order in the ticket search result of the this operation. Up: oldest on top. Down: latest on top.' =>
            '',
        'Defines the default ticket order in the watch view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            '',
        'Defines the default ticket order of a search result in the customer interface. Up: oldest on top. Down: latest on top.' =>
            '',
        'Defines the default ticket priority in the close ticket screen of the agent interface.' =>
            'Definiert die Standard-Ticketpriorität in der \'Schließen\'-Oberfläche im Agenten-Interface.',
        'Defines the default ticket priority in the ticket bulk screen of the agent interface.' =>
            'Definiert die Standard-Ticketpriorität in der \'Sammelaktion\'-Oberfläche im Agenten-Interface.',
        'Defines the default ticket priority in the ticket free text screen of the agent interface.' =>
            'Definiert die Standard-Ticketpriorität in der \'Freie Felder\'-Oberfläche im Agenten-Interface.',
        'Defines the default ticket priority in the ticket note screen of the agent interface.' =>
            'Definiert die Standard-Ticketpriorität in der \'Notiz\'-Oberfläche im Agenten-Interface.',
        'Defines the default ticket priority in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Definiert die Standard-Ticketpriorität in der \'Besitzer\'-Oberfläche im TicketZoom im Agenten-Interface.',
        'Defines the default ticket priority in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Definiert die Standard-Ticketpriorität in der \'Warten\'-Oberfläche im TicketZoom im Agenten-Interface.',
        'Defines the default ticket priority in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Definiert die Standard-Ticketpriorität in der \'Priorität\'-Oberfläche im TicketZoom im Agenten-Interface.',
        'Defines the default ticket priority in the ticket responsible screen of the agent interface.' =>
            'Definiert die Standard-Ticketpriorität in der \'Verantwortlicher\'-Oberfläche im TicketZoom im Agenten-Interface.',
        'Defines the default ticket type for new customer tickets in the customer interface.' =>
            'Definiert die Standard-Ticketpriorität für neue Kundentickets im Kunden-Interface.',
        'Defines the default type for article in the customer interface.' =>
            'Definiert den Standard-Typ für Artikel im Kunden-Interface.',
        'Defines the default type of forwarded message in the ticket forward screen of the agent interface.' =>
            '',
        'Defines the default type of the article for this operation.' => 'Definiert den Standard-Artikeltyp für diese Operation.',
        'Defines the default type of the message in the email outbound screen of the agent interface.' =>
            'Definiert den Standard-Typ der ausgehenden E-Mail.',
        'Defines the default type of the note in the close ticket screen of the agent interface.' =>
            'Definiert den Standard-Notiztyp in der \'Notiz\'-Oberfläche im Agenten-Interface.',
        'Defines the default type of the note in the ticket bulk screen of the agent interface.' =>
            'Definiert den Standard-Notiztyp in der \'Sammelaktion\'-Oberfläche im Agenten-Interface.',
        'Defines the default type of the note in the ticket free text screen of the agent interface.' =>
            'Definiert den Standard-Notiztyp in der \'Freie Felder\'-Oberfläche im Agenten-Interface.',
        'Defines the default type of the note in the ticket note screen of the agent interface.' =>
            'Definiert den Standard-Notiztyp in der \'Notiz\'-Oberfläche im Agenten-Interface.',
        'Defines the default type of the note in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Definiert den Standard-Notiztyp in der \'Besitzer\'-Oberfläche im TicketZoom im Agenten-Interface.',
        'Defines the default type of the note in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Definiert den Standard-Notiztyp in der \'Warten\'-Oberfläche im TicketZoom im Agenten-Interface.',
        'Defines the default type of the note in the ticket phone inbound screen of the agent interface.' =>
            'Definiert den Standard-Notiztyp in der \'eingehender Telefonanruf\'-Oberfläche im Agenten-Interface.',
        'Defines the default type of the note in the ticket phone outbound screen of the agent interface.' =>
            'Definiert den Standard-Notiztyp in der \'ausgehender Telefonanruf\'-Oberfläche im Agenten-Interface.',
        'Defines the default type of the note in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Definiert den Standard-Notiztyp in der \'Priorität\'-Oberfläche im TicketZoom im Agenten-Interface.',
        'Defines the default type of the note in the ticket responsible screen of the agent interface.' =>
            'Definiert den Standard-Notiztyp in der \'Verantwortlicher\'-Oberfläche im Agenten-Interface.',
        'Defines the default type of the note in the ticket zoom screen of the customer interface.' =>
            'Definiert den Standard-Notiztyp im TicketZoom im Kunden-Interface.',
        'Defines the default used Frontend-Module if no Action parameter given in the url on the agent interface.' =>
            'Definiert das standardmäßig genutzte Frontend-Modul im Agenten-Interface, wenn kein Action-Paramenter in der URL übergeben wurde.',
        'Defines the default used Frontend-Module if no Action parameter given in the url on the customer interface.' =>
            'Definiert das standardmäßig genutzte Frontend-Modul im Kunden-Interface, wenn kein Action-Paramenter in der URL übergeben wurde.',
        'Defines the default value for the action parameter for the public frontend. The action parameter is used in the scripts of the system.' =>
            'Definiert den Standard-Wert für den Action-Paramenter im Public-Frontend. Der Action-Paramter wird in System-Skripten vewendet.',
        'Defines the default viewable sender types of a ticket (default: customer).' =>
            'Definiert die standardmäßigen sichtbaren Sendertypen eines Tickets (Standard: Kunde).',
        'Defines the dynamic fields that are used for displaying on calendar events.' =>
            'Definiert die dynamischen Felder, die benutzt werden um Kalender-Events anzuzeigen.',
        'Defines the filter that processes the text in the articles, in order to highlight URLs.' =>
            'Definiert den Filter, der Text in Artikeln verarbeitet, um URLs zu highlighten.',
        'Defines the format of responses in the ticket compose screen of the agent interface ([% Data.OrigFrom | html %] is From 1:1, [% Data.OrigFromName | html %] is only realname of From).' =>
            '',
        'Defines the fully qualified domain name of the system. This setting is used as a variable, OTRS_CONFIG_FQDN which is found in all forms of messaging used by the application, to build links to the tickets within your system.' =>
            'Definiert den Full Qualified Domain Name des OTRS Systems. Diese Einstellung wird als Variable OTRS_CONFIG_FQDN genutzt, welche in allen Nachrichten-Formularen zu finden ist oder um Links zu Tickets in Ihrem OTRS System zu generieren.',
        'Defines the groups every customer user will be in (if CustomerGroupSupport is enabled and you don\'t want to manage every user for these groups).' =>
            '',
        'Defines the height for the rich text editor component for this screen. Enter number (pixels) or percent value (relative).' =>
            'Definiert die Höhe der RichText-Editor Komponente. Geben Sie einen Zahlen- (Pixel) oder Prozenwert (relativ) an.',
        'Defines the height for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            '',
        'Defines the height of the legend.' => 'Bestimmt die Höhe der Legende.',
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
        'Defines the legend font in graphs (place custom fonts in var/fonts).' =>
            'Definiert die Schriftart der Legende in Diagrammen (abzulegen in Benutzerschriftarten unter var/fonts)',
        'Defines the link type \'Normal\'. If the source name and the target name contain the same value, the resulting link is a non-directional one; otherwise, the result is a directional link.' =>
            '',
        'Defines the link type \'ParentChild\'. If the source name and the target name contain the same value, the resulting link is a non-directional one; otherwise, the result is a directional link.' =>
            '',
        'Defines the link type groups. The link types of the same group cancel one another. Example: If ticket A is linked per a \'Normal\' link with ticket B, then these tickets could not be additionally linked with link of a \'ParentChild\' relationship.' =>
            '',
        'Defines the list of online repositories. Another installations can be used as repository, for example: Key="http://example.com/otrs/public.pl?Action=PublicRepository;File=" and Content="Some Name".' =>
            '',
        'Defines the list of possible next actions on an error screen.' =>
            'Definiert die List von möglichen nächsten Aktion in einer Fehlermeldung.',
        'Defines the list of types for templates.' => 'Definiert die Typenliste für Templates.',
        'Defines the location to get online repository list for additional packages. The first available result will be used.' =>
            '',
        'Defines the log module for the system. "File" writes all messages in a given logfile, "SysLog" uses the syslog daemon of the system, e.g. syslogd.' =>
            '',
        'Defines the maximal size (in bytes) for file uploads via the browser. Warning: Setting this option to a value which is too low could cause many masks in your OTRS instance to stop working (probably any mask which takes input from the user).' =>
            '',
        'Defines the maximal valid time (in seconds) for a session id.' =>
            'Definiert die maximale Gültigkeitsdauer (in Sekunden) für eine Session-ID.',
        'Defines the maximum length (in characters) for a scheduler task data. WARNING: Do not modify this setting unless you are sure of the current Database length for \'task_data\' filed from \'scheduler_data_list\' table.' =>
            '',
        'Defines the maximum number of pages per PDF file.' => 'Bestimmt die maximale Anzahl an Seiten pro PDF-Datei.',
        'Defines the maximum number of quoted lines to be added to responses.' =>
            '',
        'Defines the maximum size (in MB) of the log file.' => 'Bestimmt die Maximalgröße (in MB) der Protokolldatei.',
        'Defines the module that shows a generic notification in the agent interface. Either "Text" - if configured - or the contents of "File" will be displayed.' =>
            '',
        'Defines the module that shows all the currently loged in customers in the agent interface.' =>
            'Definiert das Modul das alle zur Zeit angemeldeten Kunden im Agenten-Interface anzeigt.',
        'Defines the module that shows all the currently logged in agents in the agent interface.' =>
            'Definiert das Modul das alle zur Zeit angemeldeten Agenten im Agenten-Interface anzeigt.',
        'Defines the module that shows the currently loged in agents in the customer interface.' =>
            'Definiert das Modul das alle zur Zeit angemeldeten Agenten im KundenInterface anzeigt.',
        'Defines the module that shows the currently loged in customers in the customer interface.' =>
            'Definiert das Modul das alle zur Zeit angemeldeten Kunden im Kunden-Interface anzeigt.',
        'Defines the module to authenticate customers.' => 'Definiert das Modul um Kunden zu authentifizieren.',
        'Defines the module to display a notification in the agent interface if the scheduler is not running.' =>
            'Definiert das Modul das eine Benachrichtigung im Agenten-Interface anzeigt, wenn der Scheduler nicht ausgeführt wird.',
        'Defines the module to display a notification in the agent interface, if the agent is logged in while having out-of-office active.' =>
            'Definiert das Modul das eine Benachrichtigung im Agenten-Interface anzeigt, wenn ein Agent angemeldet ist, während er die "Out of Office"-Funktion aktiviert hat.',
        'Defines the module to display a notification in the agent interface, if the agent is logged in while having system maintenance active.' =>
            'Definiert das Modul das eine Benachrichtigung im Agenten-Interface anzeigt, wenn ein Agent angemeldet ist, während die Systemwartung aktiv ist.',
        'Defines the module to display a notification in the agent interface, if the system is used by the admin user (normally you shouldn\'t work as admin).' =>
            '',
        'Defines the module to generate html refresh headers of html sites, in the customer interface.' =>
            'Definiert das Modul welches HTML-Refresh-Header der HTML-Seiten im Kunden-Interface generiert.',
        'Defines the module to generate html refresh headers of html sites.' =>
            'Definiert das Modul welches HTML-Refresh-Header der HTML-Seiten generiert.',
        'Defines the module to send emails. "Sendmail" directly uses the sendmail binary of your operating system. Any of the "SMTP" mechanisms use a specified (external) mailserver. "DoNotSendEmail" doesn\'t send emails and it is useful for test systems.' =>
            '',
        'Defines the module used to store the session data. With "DB" the frontend server can be splitted from the db server. "FS" is faster.' =>
            '',
        'Defines the name of the application, shown in the web interface, tabs and title bar of the web browser.' =>
            'Definiert den Namen der Anwendung, die in der Weboberfläche, in Tabs und in der Titelleiste des Webbrowser angezeigt wird.',
        'Defines the name of the column to store the data in the preferences table.' =>
            'Definiert den Namen der Spalte, unter der Daten in der Eigenschaften-Tabelle gespeichert werden.',
        'Defines the name of the column to store the user identifier in the preferences table.' =>
            'Definiert den Namen der Spalte, unter der die Benutzer-Identifier in der Eigenschaften-Tabelle gespeichert werden.',
        'Defines the name of the indicated calendar.' => 'Definiert den Namen des angezeigten Kalenders.',
        'Defines the name of the key for customer sessions.' => 'Definiert den Namen des Schlüssels für die Kunden-Sessions.',
        'Defines the name of the session key. E.g. Session, SessionID or OTRS.' =>
            'Definiert den Namen des Session-Schlüssels. Zum Beispiel: Session, SessionID oder OTRS',
        'Defines the name of the table, where the customer preferences are stored.' =>
            'Definiert den Namen der Tabelle, in der die Kunden-Einstellungen gespeichert werden.',
        'Defines the next possible states after composing / answering a ticket in the ticket compose screen of the agent interface.' =>
            'Definiert den nächsten möglichen Status nach Erstellen eines / Antworten auf ein Ticket im Verfassen-Bildschirm im Agenten-Interface.',
        'Defines the next possible states after forwarding a ticket in the ticket forward screen of the agent interface.' =>
            '',
        'Defines the next possible states after sending a message in the email outbound screen of the agent interface.' =>
            'Definiert die nächsten, auswählbaren Status, nachdem eine ausgehende Email versendet wurde.',
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
        'Defines the number of header fields in frontend modules for add and update postmaster filters. It can be up to 99 fields.' =>
            '',
        'Defines the parameters for the customer preferences table.' => '',
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
            'Definiert das Passwort um die SOAP Schnittstelle anzusteuern (bin/cgi-bin/rpc.pl)',
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
        'Defines the path to PGP binary.' => 'Bestimmt den Pfad zur PGP-Binärdatei.',
        'Defines the path to open ssl binary. It may need a HOME env ($ENV{HOME} = \'/var/lib/wwwrun\';).' =>
            '',
        'Defines the placement of the legend. This should be a two letter key of the form: \'B[LCR]|R[TCB]\'. The first letter indicates the placement (Bottom or Right), and the second letter the alignment (Left, Right, Center, Top, or Bottom).' =>
            '',
        'Defines the postmaster default queue.' => 'Definiert die Postmaster-Standard-Queue',
        'Defines the priority in which the information is logged and presented.' =>
            'Definiert die Priorität in welcher die Information aufgezeichnet und präsentiert wird.',
        'Defines the receipent target of the phone ticket and the sender of the email ticket ("Queue" shows all queues, "SystemAddress" displays all system addresses) in the agent interface.' =>
            '',
        'Defines the receipent target of the tickets ("Queue" shows all queues, "SystemAddress" displays all system addresses) in the customer interface.' =>
            '',
        'Defines the required permission to show a ticket in the escalation view of the agent interface.' =>
            '',
        'Defines the search limit for the stats.' => 'Definiert die maximalen Suchergebnisse für Statistiken.',
        'Defines the sender for rejected emails.' => 'Definiert die Absendeadresse für abgelehnte E-Mails.',
        'Defines the separator between the agents real name and the given queue email address.' =>
            '',
        'Defines the spacing of the legends.' => '',
        'Defines the standard permissions available for customers within the application. If more permissions are needed, you can enter them here. Permissions must be hard coded to be effective. Please ensure, when adding any of the afore mentioned permissions, that the "rw" permission remains the last entry.' =>
            '',
        'Defines the standard size of PDF pages.' => 'Bestimmt die Standardgröße von PDF-Seiten.',
        'Defines the state of a ticket if it gets a follow-up and the ticket was already closed.' =>
            'Definiert den Status eines geschlossenen Tickets, wenn ein Follow-Up eingeht.',
        'Defines the state of a ticket if it gets a follow-up.' => 'Definiert den Status eines Tickets, wenn ein Follow-Up eingeht.',
        'Defines the state type of the reminder for pending tickets.' => 'Definiert den Statusttyp des Reminders für Tickets die auf "Warten" gesetzt sind.',
        'Defines the subject for notification mails sent to agents, about new password.' =>
            '',
        'Defines the subject for notification mails sent to agents, with token about new requested password.' =>
            '',
        'Defines the subject for notification mails sent to customers, about new account.' =>
            'Definiert den Betreff für Benachrichtigungs-Emails, die wegen eines neuen Accounts an Kunden geschickt wird.',
        'Defines the subject for notification mails sent to customers, about new password.' =>
            'Definiert den Betreff für Benachrichtigungs-Emails, die wegen eines neuen Passworts an Kunden geschickt wird.',
        'Defines the subject for notification mails sent to customers, with token about new requested password.' =>
            '',
        'Defines the subject for rejected emails.' => 'Bestimmt den Betreff von abgelehnten E-Mails.',
        'Defines the system administrator\'s email address. It will be displayed in the error screens of the application.' =>
            'Definiert die E-Mail-Adresse des System-Administrators. Sie wird in den Fehleranzeigen des Programms angezeigt.',
        'Defines the system identifier. Every ticket number and http session string contains this ID. This ensures that only tickets which belong to your system will be processed as follow-ups (useful when communicating between two instances of OTRS).' =>
            '',
        'Defines the target attribute in the link to external customer database. E.g. \'AsPopup PopupType_TicketAction\'.' =>
            '',
        'Defines the target attribute in the link to external customer database. E.g. \'target="cdb"\'.' =>
            '',
        'Defines the ticket fields that are going to be displayed calendar events. The "Key" defines the field or ticket attribute and the "Content" defines the display name.' =>
            '',
        'Defines the time in days to keep log backup files.' => 'Definiert für Log-Backups die Aufbewahrungszeit in Tagen.',
        'Defines the time in seconds after which the Scheduler performs an automatic self-restart.' =>
            'Definiert die Zeit in Sekunden, nach der der Scheduler einen automatischen Neustart ausführt.',
        'Defines the time zone of the indicated calendar, which can be assigned later to a specific queue.' =>
            '',
        'Defines the title font in graphs (place custom fonts in var/fonts).' =>
            'Definiert die Schriftart des Titels in Grafiken (speichere eigene Schriftarten in var/fonts).',
        'Defines the type of protocol, used by the web server, to serve the application. If https protocol will be used instead of plain http, it must be specified here. Since this has no affect on the web server\'s settings or behavior, it will not change the method of access to the application and, if it is wrong, it will not prevent you from logging into the application. This setting is only used as a variable, OTRS_CONFIG_HttpType which is found in all forms of messaging used by the application, to build links to the tickets within your system.' =>
            '',
        'Defines the used character for plaintext email quotes in the ticket compose screen of the agent interface. If this is empty or inactive, original emails will not be quoted but appended to the response.' =>
            '',
        'Defines the user identifier for the customer panel.' => 'Definiert den Benutzer-Identifier für das Kunden-Interface.',
        'Defines the username to access the SOAP handle (bin/cgi-bin/rpc.pl).' =>
            'Definiert den Benutzernamen um auf die SOAP-Schnittstelle zuzugreifen (bin/cgi-bin/rpc.pl).',
        'Defines the valid state types for a ticket.' => 'Definiert die gültigen Statustypen für ein Ticket.',
        'Defines the valid states for unlocked tickets. To unlock tickets the script "bin/otrs.UnlockTickets.pl" can be used.' =>
            'Definiert die gültigen Status für entsperrte Tickets. Um Tickets zu entsperren, führen Sie das Skript "bin/otrs.UnlockTickets.pl" aus.',
        'Defines the viewable locks of a ticket. Default: unlock, tmp_lock.' =>
            '',
        'Defines the width for the rich text editor component for this screen. Enter number (pixels) or percent value (relative).' =>
            'Definiert die Breite der RichText-Editor Komponente. Geben Sie einen Zahlen- (Pixel) oder Prozenwert (relativ) an.',
        'Defines the width for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            'Definiert die Breite der RichText-Editor Komponente. Geben Sie einen Zahlen- (Pixel) oder Prozenwert (relativ) an.',
        'Defines the width of the legend.' => 'Bestimmt die Breite der Legende.',
        'Defines which article sender types should be shown in the preview of a ticket.' =>
            'Gibt an, welche Artikel-Sendertypen in der Vorschau eines Tickets angezeigt werden sollen.',
        'Defines which items are available for \'Action\' in third level of the ACL structure.' =>
            'Definiert welche Begriffe für eine \'Aktion\' in der dritten Ebene einer ACL-Struktur verfügbar sind.',
        'Defines which items are available in first level of the ACL structure.' =>
            'Definiert welche Begriffe in der ersten Ebene einer ACL-Struktur verfügbar sind.',
        'Defines which items are available in second level of the ACL structure.' =>
            'Definiert welche Begriffe in der zweiten Ebene einer ACL-Struktur verfügbar sind.',
        'Defines which states should be set automatically (Content), after the pending time of state (Key) has been reached.' =>
            'Definiert welcher Status automatisch gesetzt wird (Inhalt), nachdem die Wartenzeit eines Status (Schlüssel) erreicht wurde.',
        'Defines wich article type should be expanded when entering the overview. If nothing defined, latest article will be expanded.' =>
            'Gibt an, welcher Artikeltyp beim Öffnen der Übersichtsansicht aufgeklappt dargestellt werden soll. Wenn kein Typ angegeben ist, wird der neueste Artikel aufgeklappt dargestellt.',
        'Defines, which tickets of which ticket state types should not be listed in linked ticket lists.' =>
            '',
        'Deleted link to ticket "%s".' => 'Verknüpfung zu "%s" gelöscht.',
        'Deletes a session if the session id is used with an invalid remote IP address.' =>
            'Löscht die Session, wenn die Session-ID mit einer ungültigen IP-Adresse benutzt wird.',
        'Deletes requested sessions if they have timed out.' => 'Löscht die angefragte Session, wenn ein Timeout vorliegt.',
        'Determines if the list of possible queues to move to ticket into should be displayed in a dropdown list or in a new window in the agent interface. If "New Window" is set you can add a move note to the ticket.' =>
            '',
        'Determines if the statistics module may generate ticket lists.' =>
            'Definiert ob das Statistik-Modul Ticketlisten generieren kann',
        'Determines the next possible ticket states, after the creation of a new email ticket in the agent interface.' =>
            'Definiert den Nächstmöglichen Ticketstatus, nachdem ein neues E-Mailticket im Agenten-interface erstellt wurde.',
        'Determines the next possible ticket states, after the creation of a new phone ticket in the agent interface.' =>
            'Definiert den Nächstmöglichen Ticketstatus, nachdem ein neues Telefonticket im Agenten-interface erstellt wurde.',
        'Determines the next possible ticket states, for process tickets in the agent interface.' =>
            'Definiert den Nächstmöglichen Ticketstatus für Prozesstickets im Agenten-Interface.',
        'Determines the next screen after new customer ticket in the customer interface.' =>
            'Definiert den nächsten Bildschirm nach einem Kundenticket im Kunden-Interface.',
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
            'Definiert wie Verlinkte-Objekte angezeigt werden in TicketZoom-Masken.',
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
        'Display settings to override defaults for Process Tickets.' => '',
        'Displays the accounted time for an article in the ticket zoom view.' =>
            'Zeigt die bisher benötigte Zeit für einen Artikel in der TicketZoomView an.',
        'Dropdown' => 'Einfachauswahl',
        'Dynamic Fields Checkbox Backend GUI' => '',
        'Dynamic Fields Date Time Backend GUI' => '',
        'Dynamic Fields Drop-down Backend GUI' => '',
        'Dynamic Fields GUI' => 'Dynamic Fields-Oberfläche',
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
        'Dynamic fields shown in the email outbound screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Angezeigte DynamicFields in der Maske für ausgehende Emails. Mögliche Einstellungen: 0 = Deaktiviert, 1 = Aktiviert, 2 = Aktiviert und zwingend benötigt.',
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
        'Dynamic fields shown in the ticket small format overview screen of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.' =>
            '',
        'Dynamic fields shown in the ticket zoom screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'DynamicField backend registration.' => '',
        'DynamicField object registration.' => '',
        'Edit customer company' => 'Kundenunternehmen bearbeiten',
        'Email Addresses' => 'E-Mail Adressen',
        'Email sent to "%s".' => 'E-Mail versandt an "%s".',
        'Email sent to customer.' => 'E-Mail an Kunden versandt.',
        'Enable keep-alive connection header for SOAP responses.' => '',
        'Enabled filters.' => 'Filter aktiviert.',
        'Enables PDF output. The CPAN module PDF::API2 is required, if not installed, PDF output will be disabled.' =>
            '',
        'Enables PGP support. When PGP support is enabled for signing and encrypting mail, it is HIGHLY recommended that the web server runs as the OTRS user. Otherwise, there will be problems with the privileges when accessing .gnupg folder.' =>
            '',
        'Enables S/MIME support.' => 'Aktiviert unterstützung für S/MIME.',
        'Enables customers to create their own accounts.' => 'Erlaubt Kunden, eigene Konten anzulegen.',
        'Enables file upload in the package manager frontend.' => 'Erlaubt den Datei-Upload im Paket-Manager.',
        'Enables or disable the debug mode over frontend interface.' => 'Aktiviert oder Deaktiviert den Debug-Modus im Frontend-Interface.',
        'Enables or disables the ticket watcher feature, to keep track of tickets without being the owner nor the responsible.' =>
            '',
        'Enables performance log (to log the page response time). It will affect the system performance. Frontend::Module###AdminPerformanceLog must be enabled.' =>
            '',
        'Enables spell checker support.' => 'Aktiviert die Unterstützung für die Rechtschreibprüfung.',
        'Enables the minimal ticket counter size (if "Date" was selected as TicketNumberGenerator).' =>
            '',
        'Enables ticket bulk action feature for the agent frontend to work on more than one ticket at a time.' =>
            '',
        'Enables ticket bulk action feature only for the listed groups.' =>
            '',
        'Enables ticket responsible feature, to keep track of a specific ticket.' =>
            '',
        'Enables ticket watcher feature only for the listed groups.' => '',
        'Enroll this ticket into a process' => 'Dieses Ticket in einen Prozess überführen',
        'Escalation response time finished' => '',
        'Escalation response time forewarned' => '',
        'Escalation response time in effect' => '',
        'Escalation solution time finished' => '',
        'Escalation solution time forewarned' => '',
        'Escalation solution time in effect' => '',
        'Escalation update time finished' => '',
        'Escalation update time forewarned' => '',
        'Escalation update time in effect' => '',
        'Escalation view' => 'Ansicht nach Eskalationen',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate).' =>
            '',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate). This is only possible if all Ticket dynamic fields need the same event.' =>
            '',
        'Event module that performs an update statement on TicketIndex to rename the queue name there if needed and if StaticDB is actually used.' =>
            '',
        'Event module that updates customer user service membership if login changes.' =>
            '',
        'Event module that updates customer users after an update of the Customer.' =>
            'Ereignis-Modul, das Kundenbenutzer aktualisiert nach einem Update des Kunden.',
        'Event module that updates tickets after an update of the Customer User.' =>
            'Ereignis-Modul, das ein Ticket aktualisiert nach einem Update des Kundenbenutzers.',
        'Event module that updates tickets after an update of the Customer.' =>
            'Ereignis-Modul, das ein Ticket aktualisiert nach einem Update des Kunden.',
        'Events Ticket Calendar' => 'Ticket-Ereigniskalender',
        'Execute SQL statements.' => 'Einen SQL-Befehl ausführen.',
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
        'Filter for debugging ACLs. Note: More ticket attributes can be added in the format <OTRS_TICKET_Attribute> e.g. <OTRS_TICKET_Priority>.' =>
            '',
        'Filter for debugging Transitions. Note: More filters can be added in the format <OTRS_TICKET_Attribute> e.g. <OTRS_TICKET_Priority>.' =>
            '',
        'Filter incoming emails.' => 'Eingehende E-Mails filtern.',
        'FirstLock' => 'Erstsperrzeit',
        'FirstResponse' => 'Erstantwortzeit',
        'FirstResponseDiffInMin' => 'Erstantwortzeitdifferenz in Minuten',
        'FirstResponseInMin' => 'Erstantwortzeit in Minuten',
        'Firstname Lastname' => 'Vorname Nachname',
        'Firstname Lastname (UserLogin)' => 'Vorname Nachname (BenutzerLogin)',
        'FollowUp for [%s]. %s' => 'FollowUp für [%s]. %s',
        'Forces encoding of outgoing emails (7bit|8bit|quoted-printable|base64).' =>
            'Erzwingt die Kodierung von ausgehenden E-Mails (7bit|8bit|quoted-printable|base64).',
        'Forces to choose a different ticket state (from current) after lock action. Define the current state as key, and the next state after lock action as content.' =>
            '',
        'Forces to unlock tickets after being moved to another queue.' =>
            '',
        'Forwarded to "%s".' => 'Weitergeleitet an "%s".',
        'Frontend language' => 'Oberflächen-Sprache',
        'Frontend module registration (disable AgentTicketService link if Ticket Serivice feature is not used).' =>
            '',
        'Frontend module registration (disable company link if no company feature is used).' =>
            '',
        'Frontend module registration (disable ticket processes screen if no process available) for Customer.' =>
            'Frontend-Modulregistrierung im Kunden-Interface (verberge Ticket-Prozesse, falls kein Prozess verfügbar ist).',
        'Frontend module registration (disable ticket processes screen if no process available).' =>
            'Frontend-Modulregistrierung (verberge Ticket-Prozesse, falls kein Prozess verfügbar ist).',
        'Frontend module registration for the agent interface.' => 'Frontend-Modulregistrierung im Agent-Interface.',
        'Frontend module registration for the customer interface.' => '',
        'Frontend theme' => 'Oberflächen-Schema',
        'Fulltext index regex filters to remove parts of the text.' => '',
        'General ticket data shown in the ticket overviews (fall-back). Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note that TicketNumber can not be disabled, because it is necessary.' =>
            '',
        'GenericAgent' => 'GenericAgent',
        'GenericInterface Debugger GUI' => '',
        'GenericInterface Invoker GUI' => '',
        'GenericInterface Operation GUI' => '',
        'GenericInterface TransportHTTPREST GUI' => '',
        'GenericInterface TransportHTTPSOAP GUI' => '',
        'GenericInterface Web Service GUI' => 'GenericInterface Webservices Benutzeroberfläche',
        'GenericInterface Webservice History GUI' => 'GenericInterface Webservice Verlauf Benutzeroberfläche',
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
        'If active, none of the regular expressions may match the user\'s email address to allow registration.' =>
            '',
        'If active, one of the regular expressions has to match the user\'s email address to allow registration.' =>
            '',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, and authentication to the mail server is needed, a password must be specified.' =>
            '',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, and authentication to the mail server is needed, an username must be specified.' =>
            '',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, the mailhost that sends out the mails must be specified.' =>
            '',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, the port where your mailserver is listening for incoming connections must be specified.' =>
            '',
        'If enabled debugging information for ACLs is logged.' => '',
        'If enabled debugging information for transitions is logged.' => '',
        'If enabled, OTRS will deliver all CSS files in minified form. WARNING: If you turn this off, there will likely be problems in IE 7, because it cannot load more than 32 CSS files.' =>
            '',
        'If enabled, OTRS will deliver all JavaScript files in minified form.' =>
            '',
        'If enabled, TicketPhone and TicketEmail will be open in new windows.' =>
            'Wenn aktiviert, werden TicketPhone und TicketEmail in neuen Fenstern geöffnet.',
        'If enabled, the OTRS version tag will be removed from the Webinterface, the HTTP headers and the X-Headers of outgoing mails.' =>
            '',
        'If enabled, the different overviews (Dashboard, LockedView, QueueView) will automatically refresh after the specified time.' =>
            'Wenn diese Option aktiviert ist, werden die verschiedenen Übersichts-Seiten (Dashboard, LockedView, QueueView) automatisch nach der angegebenen Zeit aktualisiert.',
        'If enabled, the first level of the main menu opens on mouse hover (instead of click only).' =>
            '',
        'If set, this address is used as envelope sender header in outgoing notifications. If no address is specified, the envelope sender header is empty.' =>
            '',
        'If set, this address is used as envelope sender in outgoing messages (not notifications - see below). If no address is specified, the envelope sender is equal to queue e-mail address.' =>
            '',
        'If this option is enabled, then the decrypted data will be stored in the database if they are displayed in AgentTicketZoom.' =>
            'Wenn diese Option aktiviert ist, werden die entschlüsselten Daten in der Datenbank gespeichert, wenn Sie beim ersten Aufruf des Artikels in AgentTicketZoom angezeigt werden.',
        'If this option is set to \'Yes\', tickets created via the web interface, via Customers or Agents, will receive an autoresponse if configured. If this option is set to \'No\', no autoresponses will be sent.' =>
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
        'Lastname, Firstname' => 'Nachname, Vorname',
        'Lastname, Firstname (UserLogin)' => 'Nachname, Vorname (BenutzerLogin)',
        'Link agents to groups.' => 'Agenten zu Gruppen zuordnen.',
        'Link agents to roles.' => 'Agenten zu Rollen zuordnen.',
        'Link attachments to templates.' => 'Anhänge zu Vorlagen zuordnen.',
        'Link customer user to groups.' => 'Kundenbenutzer zu Gruppen zuordnen.',
        'Link customer user to services.' => 'Kundenbenutzer zu Services zuordnen.',
        'Link queues to auto responses.' => 'Automatische Antworten zu Queues zuordnen.',
        'Link roles to groups.' => 'Rollen zu Gruppen zuordnen.',
        'Link templates to queues.' => 'Vorlagen zu Queues zuordnen.',
        'Links 2 tickets with a "Normal" type link.' => 'Verknüpft 2 Tickets mit dem Linktyp "Normal".',
        'Links 2 tickets with a "ParentChild" type link.' => 'Verknüpft 2 Tickets mit dem Linktyp "Eltern-Kind".',
        'List of CSS files to always be loaded for the agent interface.' =>
            'Liste der CSS-Dateien, die immer im Agenten-Interface geladen werden sollen.',
        'List of CSS files to always be loaded for the customer interface.' =>
            'Liste der CSS-Dateien, die immer im Kunden-Interface geladen werden sollen.',
        'List of IE8-specific CSS files to always be loaded for the agent interface.' =>
            'Liste der IE8 spezifischen CSS-Dateien, die immer im Agenten-Interface geladen werden sollen.',
        'List of IE8-specific CSS files to always be loaded for the customer interface.' =>
            'Liste der IE8 spezifischen CSS-Dateien, die immer im Kunden-Interface geladen werden sollen.',
        'List of JS files to always be loaded for the agent interface.' =>
            'Liste der JavaScript-Dateien, die immer im Agenten-Interface geladen werden sollen.',
        'List of JS files to always be loaded for the customer interface.' =>
            'Liste der JavaScript-Dateien, die immer im Kunden-Interface geladen werden sollen.',
        'List of all CustomerCompany events to be displayed in the GUI.' =>
            'Liste aller Kundenereignisse, welche in der grafischen Benutzeroberfläche angezeigt werden sollen.',
        'List of all CustomerUser events to be displayed in the GUI.' => 'Liste aller Kundenbenutzerereignisse, welche in der grafischen Benutzeroberfläche angezeigt werden sollen.',
        'List of all DynamicField events to be displayed in the GUI.' => 'Liste aller DynamicFields-Ereignisse, welche in der grafischen Benutzeroberfläche angezeigt werden sollen.',
        'List of all Package events to be displayed in the GUI.' => 'Liste aller Paket-Ereignisse, welche in der grafischen Benutzeroberfläche angezeigt werden sollen.',
        'List of all article events to be displayed in the GUI.' => 'Liste aller Artikel-Ereignisse, welche in der grafischen Benutzeroberfläche angezeigt werden sollen.',
        'List of all queue events to be displayed in the GUI.' => '',
        'List of all ticket events to be displayed in the GUI.' => 'Liste aller Ticket-Ereignisse, welche in der grafischen Benutzeroberfläche angezeigt werden sollen.',
        'List of default Standard Templates which are assigned automatically to new Queues upon creation.' =>
            'Liste der Standard-Vorlagen, welche neuen Queues nach Erstellung automatisch zugeordnet werden..',
        'Locked ticket.' => 'Ticket gesperrt.',
        'Log file for the ticket counter.' => 'Log-Datei für den Ticket-Counter.',
        'Loop-Protection! No auto-response sent to "%s".' => 'Loop-Protection! Keine Auto-Antwort versandt an "%s".',
        'Mail Accounts' => 'E-Mailkonten',
        'Main menu registration.' => 'Hauptmenü-Registrierung.',
        'Makes the application check the MX record of email addresses before sending an email or submitting a telephone or email ticket.' =>
            'Überprüft vor dem Senden einer E-Mail oder vor dem übermitteln eines Telefon-Tickets, den MX-Eintrag der E-Mailadresse.',
        'Makes the application check the syntax of email addresses.' => 'Überprüft die Syntax der E-Mailadressen.',
        'Makes the picture transparent.' => 'Macht das Bild transparent.',
        'Makes the session management use html cookies. If html cookies are disabled or if the client browser disabled html cookies, then the system will work as usual and append the session id to the links.' =>
            'Benutzt für das Session-Management HTML-Cookies. Wenn HTML-Cookies deaktiviert sind oder im Browser HTML-Cookies deaktiviert sind, arbeitet das System wie immer und fügt die Session-ID and Links an.',
        'Manage OTRS Group services.' => 'Dienstleistungen der OTRS Gruppe verwalten.',
        'Manage PGP keys for email encryption.' => 'PGP-Schlüssel für E-Mail-Verschlüsselung verwalten.',
        'Manage POP3 or IMAP accounts to fetch email from.' => 'POP3- oder IMAP-Konten für das Abholen von E-Mail verwalten.',
        'Manage S/MIME certificates for email encryption.' => 'S/MIME-Zertifikate für E-Mail-Verschlüsselung verwalten.',
        'Manage existing sessions.' => 'Sitzungen verwalten.',
        'Manage notifications that are sent to agents.' => 'Benachrichtigungen für Agenten verwalten',
        'Manage system registration.' => 'Systemregistrierung verwalten.',
        'Manage tasks triggered by event or time based execution.' => 'Verwaltung von event- oder zeitbasierten Aufgaben.',
        'Max size (in characters) of the customer information table (phone and email) in the compose screen.' =>
            'Maximale Größe (Buchstaben) der Kundeninformationen (Telefon und E-Mail) in der Erfassungs-Oberfläche.',
        'Max size (in rows) of the informed agents box in the agent interface.' =>
            'Maximale Größe (in Reihen) des "Informiere Agenten" Kästchen im Agenten-Interface.',
        'Max size (in rows) of the involved agents box in the agent interface.' =>
            'Maximale Größe (in Reihen) des "Beteiligte Agenten" Kästchen im Agenten-Interface.',
        'Max size of the subjects in an email reply.' => 'Maximale Anzahl von Zeichen im Betreff bei E-Mailantwort.',
        'Maximal auto email responses to own email-address a day (Loop-Protection).' =>
            'Maximale Anzahl von automatischen E-Mailantworten zur eigenen E-Mailadresse pro Tag (Loop-Protection)',
        'Maximal size in KBytes for mails that can be fetched via POP3/POP3S/IMAP/IMAPS (KBytes).' =>
            'Maximale Größe in KBytes für E-Mails die via POP3/POP3S/IMAP/IMAPS empfangen werden (in KBytes).',
        'Maximum length (in characters) of the dynamic field in the article of the ticket zoom view.' =>
            'Maximale Länge (Buchstaben) von dynamischen Felder von Artikeln in der TicketZoom-Übersicht.',
        'Maximum length (in characters) of the dynamic field in the sidebar of the ticket zoom view.' =>
            'Maximale Länge (Buchstaben) von dynamischen Felder in der Seitenleiste in der TicketZoom-Übersicht.',
        'Maximum number of tickets to be displayed in the result of a search in the agent interface.' =>
            'Maximale Anzahl von Tickets, die im Suchergebnis des Agenten-Interfaces angezeigt werden sollen.',
        'Maximum number of tickets to be displayed in the result of a search in the customer interface.' =>
            'Maximale Anzahl von Tickets, die im Suchergebnis des Kunden-Interfaces angezeigt werden sollen.',
        'Maximum number of tickets to be displayed in the result of this operation.' =>
            '',
        'Maximum size (in characters) of the customer information table in the ticket zoom view.' =>
            '',
        'Module for To-selection in new ticket screen in the customer interface.' =>
            '',
        'Module to check customer permissions.' => 'Modul zum Überprüfen von Kundenberechtigungen.',
        'Module to check if a user is in a special group. Access is granted, if the user is in the specified group and has ro and rw permissions.' =>
            '',
        'Module to check if arrived emails should be marked as email-internal (because of original forwarded internal email). ArticleType and SenderType define the values for the arrived email/article.' =>
            '',
        'Module to check the agent responsible of a ticket.' => 'Modul zur Überprüfung des Ticketverantwortlichen.',
        'Module to check the group permissions for the access to customer tickets.' =>
            'Modul zur Überprüfung der Gruppenberechtigung um auf Kundentickets zuzugreifen.',
        'Module to check the owner of a ticket.' => 'Modul zur Überprüfung des Ticketbesitzers.',
        'Module to check the watcher agents of a ticket.' => 'Modul zur Überprüfung des Ticketbeobachter.',
        'Module to compose signed messages (PGP or S/MIME).' => 'Modul um signierte Nachrichten zu verfassen (PGP oder S/MIME).',
        'Module to crypt composed messages (PGP or S/MIME).' => 'Modul um verschlüsselte Nachrichten zu verassen (PGP oder S/MIME).',
        'Module to filter and manipulate incoming messages. Block/ignore all spam email with From: noreply@ address.' =>
            '',
        'Module to filter and manipulate incoming messages. Get a 4 digit number to ticket free text, use regex in Match e. g. From => \'(.+?)@.+?\', and use () as [***] in Set =>.' =>
            '',
        'Module to generate accounted time ticket statistics.' => 'Modul zur Generierung von Statistiken  für die benötigte Bearbeitungszeit.',
        'Module to generate html OpenSearch profile for short ticket search in the agent interface.' =>
            '',
        'Module to generate html OpenSearch profile for short ticket search in the customer interface.' =>
            '',
        'Module to generate ticket solution and response time statistics.' =>
            'Modul zur Generierung von Lösungs- und Antwortzeitstatistiken.',
        'Module to generate ticket statistics.' => 'Modul zur Generierung von Ticket-Statistiken',
        'Module to show notifications and escalations (ShownMax: max. shown escalations, EscalationInMinutes: Show ticket which will escalation in, CacheTime: Cache of calculated escalations in seconds).' =>
            '',
        'Module to use database filter storage.' => '',
        'Multiselect' => 'Mehrfachauswahl',
        'My Queues and My Services' => 'Meine Queues und Meine Services',
        'My Queues or My Services' => 'Meine Queues oder Meine Services',
        'My Services' => 'Meine Services',
        'My Tickets' => 'Meine Tickets',
        'Name of custom queue. The custom queue is a queue selection of your preferred queues and can be selected in the preferences settings.' =>
            '',
        'Name of custom service. The custom service is a service selection of your preferred services and can be selected in the preferences settings.' =>
            '',
        'NameX' => 'NameX',
        'New Ticket [%s] created (Q=%s;P=%s;S=%s).' => 'Neues Ticket [%s] erstellt (Q=%s;P=%s;S=%s).',
        'New email ticket' => 'Neues E-Mail-Ticket',
        'New owner is "%s" (ID=%s).' => 'Neuer Besitzer ist "%s" (ID=%s).',
        'New phone ticket' => 'Neues Telefon-Ticket',
        'New process ticket' => 'Neues Prozess-Ticket',
        'New responsible is "%s" (ID=%s).' => 'Neuer Verantwortlicher ist "%s" (ID=%s).',
        'Next possible ticket states after adding a phone note in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Next possible ticket states after adding a phone note in the ticket phone outbound screen of the agent interface.' =>
            '',
        'No Notification' => 'Keine Benachrichtigung',
        'Notification sent to "%s".' => 'Benachrichtigung versandt an "%s".',
        'Notifications (Event)' => 'Benachrichtigungen (Ereignis)',
        'Number of displayed tickets' => 'Anzahl der angezeigten Tickets',
        'Number of lines (per ticket) that are shown by the search utility in the agent interface.' =>
            '',
        'Number of tickets to be displayed in each page of a search result in the agent interface.' =>
            '',
        'Number of tickets to be displayed in each page of a search result in the customer interface.' =>
            'Anzahl der anzuzeigenen Tickets pro Seite in einem Suchergebnis in der Kundenoberfläche.',
        'Old: "%s" New: "%s"' => 'Alt: "%s" Neu: "%s"',
        'Open tickets (customer user)' => 'Offene Tickets (Kundenbenutzer)',
        'Open tickets (customer)' => 'Offene Tickets (Kunde)',
        'Out Of Office' => 'Nicht mehr im Büro',
        'Overloads (redefines) existing functions in Kernel::System::Ticket. Used to easily add customizations.' =>
            '',
        'Overview Escalated Tickets' => 'Übersicht eskalierte Tickets',
        'Overview Refresh Time' => 'Aktualisierungszeiten der Übersichten',
        'Overview of all open Tickets.' => 'Übersicht über alle offenen Tickets.',
        'PGP Key Management' => 'PGP-Schlüssel-Verwaltung',
        'PGP Key Upload' => 'PGP Schlüssel hochladen',
        'Package event module file a scheduler task for update registration.' =>
            '',
        'Parameters for .' => 'Parameter für .',
        'Parameters for the CreateNextMask object in the preference view of the agent interface.' =>
            '',
        'Parameters for the CustomQueue object in the preference view of the agent interface.' =>
            '',
        'Parameters for the CustomService object in the preference view of the agent interface.' =>
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
        'Parameters for the ServiceUpdateNotify object in the preference view of the agent interface.' =>
            '',
        'Parameters for the WatcherNotify object in the preference view of the agent interface.' =>
            '',
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
        'Picture-Upload' => 'Bild-Hochladen',
        'PostMaster Filters' => 'PostMaster-Filter',
        'PostMaster Mail Accounts' => 'PostMaster-E-Mail-Konten',
        'Process Information' => 'Prozess-Informationen',
        'Process Management Activity Dialog GUI' => '',
        'Process Management Activity GUI' => '',
        'Process Management Path GUI' => '',
        'Process Management Transition Action GUI' => '',
        'Process Management Transition GUI' => '',
        'ProcessID' => 'ProcessID',
        'Protection against CSRF (Cross Site Request Forgery) exploits (for more info see http://en.wikipedia.org/wiki/Cross-site_request_forgery).' =>
            '',
        'Provides a matrix overview of the tickets per state per queue.' =>
            '',
        'Queue view' => 'Ansicht nach Queues',
        'Recognize if a ticket is a follow up to an existing ticket using an external ticket number.' =>
            '',
        'Refresh Overviews after' => 'Übersichten aktualisieren nach',
        'Refresh interval' => 'Aktualisierungsintervall',
        'Removed subscription for user "%s".' => 'Abo für Benutzer "%s" ausgetragen.',
        'Removes the ticket watcher information when a ticket is archived.' =>
            '',
        'Replaces the original sender with current customer\'s email address on compose answer in the ticket compose screen of the agent interface.' =>
            '',
        'Required permissions to change the customer of a ticket in the agent interface.' =>
            'Benötigte Rechte um den Kunden eines Tickets im Agenten-Interface zu ändern.',
        'Required permissions to use the close ticket screen in the agent interface.' =>
            'Benötigte Rechte um den "Schließen"-Dialog im Agenten-Interface aufzurufen.',
        'Required permissions to use the email outbound screen in the agent interface.' =>
            'Benötigte Rechte, um den Dialog für ausgehende Emails im Agenten-Interface aufzurufen.',
        'Required permissions to use the ticket bounce screen in the agent interface.' =>
            'Benötigte Rechte um den "Umleiten"-Dialog eines Tickets im Agenten-Interface aufzurufen.',
        'Required permissions to use the ticket compose screen in the agent interface.' =>
            'Benötigte Rechte um den "Verfassen"-Dialog eines Tickets im Agenten-Interface aufzurufen.',
        'Required permissions to use the ticket forward screen in the agent interface.' =>
            'Benötigte Rechte um den "Weiterleiten"-Dialog eines Tickets im Agenten-Interface aufzurufen.',
        'Required permissions to use the ticket free text screen in the agent interface.' =>
            'Benötigte Rechte um den "Freitext"-Dialog eines Tickets im Agenten-Interface aufzurufen.',
        'Required permissions to use the ticket merge screen of a zoomed ticket in the agent interface.' =>
            'Benötigte Rechte um den "Zusammenfassen"-Dialog eines Tickets im Agenten-Interface aufzurufen.',
        'Required permissions to use the ticket note screen in the agent interface.' =>
            'Benötigte Rechte um den "Notiz"-Dialog eines Tickets im Agenten-Interface aufzurufen.',
        'Required permissions to use the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Benötigte Rechte um den "Besitzer"-Dialog eines Tickets im Agenten-Interface aufzurufen.',
        'Required permissions to use the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Benötigte Rechte um den "Warten"-Dialog eines Tickets im Agenten-Interface aufzurufen.',
        'Required permissions to use the ticket phone inbound screen in the agent interface.' =>
            'Benötigte Rechte um den "Eingehender Telefonanruf"-Dialog eines Tickets im Agenten-Interface aufzurufen.',
        'Required permissions to use the ticket phone outbound screen in the agent interface.' =>
            'Benötigte Rechte um den "Ausgehender Telefonanruf"-Dialog eines Tickets im Agenten-Interface aufzurufen.',
        'Required permissions to use the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Benötigte Rechte um den "Priorität"-Dialog eines Tickets im Agenten-Interface aufzurufen.',
        'Required permissions to use the ticket responsible screen in the agent interface.' =>
            'Benötigte Rechte um den "Verantwortlicher"-Dialog eines Tickets im Agenten-Interface aufzurufen.',
        'Resets and unlocks the owner of a ticket if it was moved to another queue.' =>
            'Setzt den Owner eines TIckets zurück und entsperrt es, wenn das Ticket in eine andere Queue verschoben wird.',
        'Restores a ticket from the archive (only if the event is a state change, from closed to any open available state).' =>
            '',
        'Retains all services in listings even if they are children of invalid elements.' =>
            '',
        'Roles <-> Groups' => 'Rollen <-> Gruppen',
        'Running Process Tickets' => 'Aktive Prozesstickets',
        'Runs an initial wildcard search of the existing customer users when accessing the AdminCustomerUser module.' =>
            '',
        'Runs the system in "Demo" mode. If set to "Yes", agents can change preferences, such as selection of language and theme via the agent web interface. These changes are only valid for the current session. It will not be possible for agents to change their passwords.' =>
            '',
        'S/MIME Certificate Upload' => 'S/MIME Zertifikat hochladen',
        'Saves the attachments of articles. "DB" stores all data in the database (not recommended for storing big attachments). "FS" stores the data on the filesystem; this is faster but the webserver should run under the OTRS user. You can switch between the modules even on a system that is already in production without any loss of data.' =>
            '',
        'Schedule a maintenance period.' => 'Systemwartung planen',
        'Search Customer' => 'Kunden suchen',
        'Search User' => 'Benutzer suchen',
        'Search backend default router.' => '',
        'Search backend router.' => '',
        'Select your frontend Theme.' => 'Anzeigeschema auswählen.',
        'Selects the cache backend to use.' => '',
        'Selects the module to handle uploads via the web interface. "DB" stores all uploads in the database, "FS" uses the file system.' =>
            '',
        'Selects the ticket number generator module. "AutoIncrement" increments the ticket number, the SystemID and the counter are used with SystemID.counter format (e.g. 1010138, 1010139). With "Date" the ticket numbers will be generated by the current date, the SystemID and the counter. The format looks like Year.Month.Day.SystemID.counter (e.g. 200206231010138, 200206231010139). With "DateChecksum"  the counter will be appended as checksum to the string of date and SystemID. The checksum will be rotated on a daily basis. The format looks like Year.Month.Day.SystemID.Counter.CheckSum (e.g. 2002070110101520, 2002070110101535). "Random" generates randomized ticket numbers in the format "SystemID.Random" (e.g. 100057866352, 103745394596).' =>
            '',
        'Send me a notification if a customer sends a follow up and I\'m the owner of the ticket or the ticket is unlocked and is in one of my queues/services.' =>
            'Benachrichtigung, wenn ein Kunde eine Rückmeldung sendet und ich der Besitzer des Tickets bin, oder das Ticket nicht gesperrt ist und in einer meiner Queues/Services liegt. ',
        'Send me a notification if the service of a ticket is changed to a service in "My Services" and the ticket is in a queue where I have read permissions.' =>
            'Benachrichtigung bei Zuweisung eines Services aus "Meine Services" an ein Ticket, auf das ich Leserechte habe.',
        'Send me a notification if there is a new ticket in my queues/services.' =>
            'Benachrichtigung bei einem neuen Ticket in "Meine Queues/Services".',
        'Send new ticket notifications if subscribed to' => 'Benachrichtigung über neue Tickets falls passend zu',
        'Send notifications to users.' => 'Benachrichtigungen an Agenten verschicken.',
        'Send service update notifications' => 'Benachrichtigung bei Service-Zuweisung',
        'Send ticket follow up notifications if subscribed to' => 'Benachrichtigung über Rückmeldung falls passend zu',
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
        'Service update notification' => 'Service-Update-Benachrichtigung',
        'Service view' => 'Ansicht nach Services',
        'Set sender email addresses for this system.' => 'Absendeadressen für dieses System verwalten.',
        'Set the default height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            '',
        'Set the maximum height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            '',
        'Set this to yes if you trust in all your public and private pgp keys, even if they are not certified with a trusted signature.' =>
            '',
        'Sets if SLA must be selected by the agent.' => '',
        'Sets if SLA must be selected by the customer.' => '',
        'Sets if note must be filled in by the agent. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            '',
        'Sets if service must be selected by the agent.' => '',
        'Sets if service must be selected by the customer.' => '',
        'Sets if ticket owner must be selected by the agent.' => '',
        'Sets the PendingTime of a ticket to 0 if the state is changed to a non-pending state.' =>
            '',
        'Sets the age in minutes (first level) for highlighting queues that contain untouched tickets.' =>
            '',
        'Sets the age in minutes (second level) for highlighting queues that contain untouched tickets.' =>
            '',
        'Sets the configuration level of the administrator. Depending on the config level, some sysconfig options will be not shown. The config levels are in in ascending order: Expert, Advanced, Beginner. The higher the config level is (e.g. Beginner is the highest), the less likely is it that the user can accidentally configure the system in a way that it is not usable any more.' =>
            '',
        'Sets the count of articles visible in preview mode of ticket overviews.' =>
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
        'Sets the default error message for the login screen on Agent and Customer interface, it\'s shown when a running system maintenance period is active.' =>
            '',
        'Sets the default link type of splitted tickets in the agent interface.' =>
            '',
        'Sets the default message for the login screen on Agent and Customer interface, it\'s shown when a running system maintenance period is active.' =>
            '',
        'Sets the default message for the notification is shown on a running system maintenance period.' =>
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
        'Sets the maximum number of active sessions per agent within the timespan defined in SessionActiveTime.' =>
            '',
        'Sets the maximum number of active sessions per customers within the timespan defined in SessionActiveTime.' =>
            '',
        'Sets the minimal ticket counter size (if "AutoIncrement" was selected as TicketNumberGenerator). Default is 5, this means the counter starts from 10000.' =>
            '',
        'Sets the minutes a notification is shown for notice about upcoming system maintenance period.' =>
            '',
        'Sets the number of lines that are displayed in text messages (e.g. ticket lines in the QueueZoom).' =>
            '',
        'Sets the options for PGP binary.' => 'Legt die Optionen für die PGP-Binärdatei fest.',
        'Sets the order of the different items in the customer preferences view.' =>
            '',
        'Sets the password for private PGP key.' => 'Legt das Passwort für den privaten PGP-Schlüssel fest.',
        'Sets the prefered time units (e.g. work units, hours, minutes).' =>
            'Legt die bevorzugten Zeiteinheiten fest (z.B. Arbeitseinheiten, Stunden, Minuten).',
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
        'Should the cache data be help in memory?' => '',
        'Should the cache data be stored in the selected cache backend?' =>
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
        'Shows a link in the menu to enroll a ticket into a process in the ticket zoom view of the agent interface.' =>
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
        'Shows a link in the menu to send an outbound email in the ticket zoom view of the agent interface.' =>
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
        'Shows a select of ticket attributes to order the queue view ticket list. The possible selections can be configured via \'TicketOverviewMenuSort###SortAttributes\'.' =>
            '',
        'Shows all both ro and rw queues in the queue view.' => '',
        'Shows all both ro and rw tickets in the service view.' => '',
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
            'Zeigt die Farben für die verschiedenen Artikeltypen in der Artikeltabelle an.',
        'Shows customer history tickets in AgentTicketPhone, AgentTicketEmail and AgentTicketCustomer.' =>
            '',
        'Shows either the last customer article\'s subject or the ticket title in the small format overview.' =>
            '',
        'Shows existing parent/child queue lists in the system in the form of a tree or a list.' =>
            '',
        'Shows information on how to start OTRS Scheduler' => '',
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
        'Sorts the tickets (ascendingly or descendingly) when a single queue is selected in the service view and after the tickets are sorted by priority. Values: 0 = ascending (oldest on top, default), 1 = descending (youngest on top). Use the ServiceID for the key and 0 or 1 for value.' =>
            '',
        'Spam Assassin example setup. Ignores emails that are marked with SpamAssassin.' =>
            '',
        'Spam Assassin example setup. Moves marked mails to spam queue.' =>
            '',
        'Specifies if an agent should receive email notification of his own actions.' =>
            '',
        'Specifies the available note types for this ticket mask. If the option is deselected, ArticleTypeDefault is used and the option is removed from the mask.' =>
            '',
        'Specifies the background color of the chart.' => 'Legt die Hintergrundfarbe der Tabelle fest.',
        'Specifies the background color of the picture.' => 'Legt die Hintergrundfarbe des Bildes fest.',
        'Specifies the border color of the chart.' => '',
        'Specifies the border color of the legend.' => '',
        'Specifies the bottom margin of the chart.' => '',
        'Specifies the default article type for the ticket compose screen in the agent interface if the article type cannot be automatically detected.' =>
            '',
        'Specifies the different article types that will be used in the system.' =>
            'Legt die verschiedenen Artikel-Typen fest, die im System verwendet werden.',
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
        'Specifies the order in which the firstname and the lastname of agents will be displayed.' =>
            'Legt die Reihenfolge fest, in der Vorname und Nachname von Agenten angezeigt wird.',
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
        'Specifies the text color of the legend.' => 'Legt die Textfarbe der Legende fest.',
        'Specifies the text that should appear in the log file to denote a CGI script entry.' =>
            '',
        'Specifies the top margin of the chart.' => '',
        'Specifies user id of the postmaster data base.' => '',
        'Specifies whether all storage backends should be checked when looking for attachements. This is only required for installations where some attachements are in the file system, and others in the database.' =>
            '',
        'Specify how many sub directory levels to use when creating cache files. This should prevent too many cache files being in one directory.' =>
            '',
        'Standard available permissions for agents within the application. If more permissions are needed, they can be entered here. Permissions must be defined to be effective. Some other good permissions have also been provided built-in: note, close, pending, customer, freetext, move, compose, responsible, forward, and bounce. Make sure that "rw" is always the last registered permission.' =>
            '',
        'Start number for statistics counting. Every new stat increments this number.' =>
            '',
        'Starts a wildcard search of the active object after the link object mask is started.' =>
            '',
        'Stat#' => 'Statistik Nr.',
        'Statistics' => 'Statistiken',
        'Status view' => 'Ansicht nach Status',
        'Stop words for fulltext index. These words will be removed.' => '',
        'Stores cookies after the browser has been closed.' => '',
        'Strips empty lines on the ticket preview in the queue view.' => '',
        'Strips empty lines on the ticket preview in the service view.' =>
            '',
        'System Maintenance' => 'Systemwartung',
        'System Request (%s).' => 'Systemanfrage (%s).',
        'Templates <-> Queues' => 'Vorlagen <-> Queues',
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
        'The headline shown in the customer interface.' => 'Die in der Kundenoberfläche angezeigte Überschrift.',
        'The identifier for a ticket, e.g. Ticket#, Call#, MyTicket#. The default is Ticket#.' =>
            '',
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
            '',
        'The text at the beginning of the subject when an email is forwarded, e.g. FW, Fwd, or WG.' =>
            '',
        'This event module stores attributes from CustomerUser as DynamicFields tickets. Please see the setting above for how to configure the mapping.' =>
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
        'This option will deny the access to customer company tickets, which are not created by the customer user.' =>
            'Diese Option verweigert den Zugriff auf Tickets von anderen Kundenbenutzern mit der selben Kundenfirma.',
        'This setting allows you to override the built-in country list with your own list of countries. This is particularly handy if you just want to use a small select group of countries.' =>
            '',
        'Ticket Queue Overview' => 'Ticket-Übersicht nach Queues',
        'Ticket event module that triggers the escalation stop events.' =>
            'Ticket Event Modul welche die Eskalation-Stop-Ereignisse auslöst.',
        'Ticket moved into Queue "%s" (%s) from Queue "%s" (%s).' => 'Ticket verschoben in Queue "%s" (%s) von Queue "%s" (%s).',
        'Ticket overview' => 'Ticket-Übersicht',
        'TicketNumber' => 'Ticketnummer',
        'Time in seconds that gets added to the actual time if setting a pending-state (default: 86400 = 1 day).' =>
            '',
        'Title updated: Old: "%s", New: "%s"' => 'Titel geändert: Alt: "%s", Neu: "%s"',
        'Toggles display of OTRS FeatureAddons list in PackageManager.' =>
            'Schaltet die Anzeige der OTRS FeatureAddon-Liste in der Paket-Verwaltung um.',
        'Toolbar Item for a shortcut.' => 'Werkzeugleisteneintrag für den Schnellzugriff.',
        'Turns on drag and drop for the main navigation.' => '',
        'Turns on the animations used in the GUI. If you have problems with these animations (e.g. performance issues), you can turn them off here.' =>
            '',
        'Turns on the remote ip address check. It should be set to "No" if the application is used, for example, via a proxy farm or a dialup connection, because the remote ip address is mostly different for the requests.' =>
            '',
        'Unlock tickets whenever a note is added and the owner is out of office.' =>
            '',
        'Unlocked ticket.' => 'Ticketsperre aufgehoben.',
        'Update Ticket "Seen" flag if every article got seen or a new Article got created.' =>
            '',
        'Update and extend your system with software packages.' => 'System mit Softwarepaketen aktualisieren und erweitern.',
        'Updated SLA to %s (ID=%s).' => 'SLA aktualisiert "%s" (ID=%s).',
        'Updated Service to %s (ID=%s).' => 'Service aktualisiert "%s" (ID=%s).',
        'Updated Type to %s (ID=%s).' => 'Typ aktualisiert "%s" (ID=%s).',
        'Updated: %s' => 'Aktualisiert: %s',
        'Updated: %s=%s;%s=%s;%s=%s;' => 'Aktualisiert: %s=%s;%s=%s;%s=%s;',
        'Updates the ticket escalation index after a ticket attribute got updated.' =>
            '',
        'Updates the ticket index accelerator.' => '',
        'UserFirstname' => 'Benutzervorname',
        'UserLastname' => 'Benutzernachname',
        'Uses Cc recipients in reply Cc list on compose an email answer in the ticket compose screen of the agent interface.' =>
            '',
        'Uses richtext for viewing and editing notification events.' => '',
        'Uses richtext for viewing and editing: articles, salutations, signatures, standard templates, auto responses and notifications.' =>
            '',
        'View performance benchmark results.' => 'Ergebnisse der Performance-Messung anzeigen.',
        'View system log messages.' => 'System-Protokolleinträge anzeigen.',
        'Wear this frontend skin' => 'Diesen Skin verwenden',
        'Webservice path separator.' => '',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. Here you can define the body of this note (this text cannot be changed by the agent).' =>
            '',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. Here you can define the subject of this note (this subject cannot be changed by the agent).' =>
            '',
        'When tickets are merged, the customer can be informed per email by setting the check box "Inform Sender". In this text area, you can define a pre-formatted text which can later be modified by the agents.' =>
            '',
        'Write a new, outgoing mail' => 'Schreiben Sie eine neue, ausgehende E-Mail',
        'Your queue selection of your favorite queues. You also get notified about those queues via email if enabled.' =>
            'Auswahl der bevorzugten Queues. Es werden E-Mail-Benachrichtigungen über diese ausgewählten Queues versendet.',
        'Your service selection of your favorite services. You also get notified about those services via email if enabled.' =>
            'Auswahl der bevorzugten Services. Es werden E-Mail-Benachrichtigungen über diese ausgewählten Services versendet. ',

    };
    # $$STOP$$
    return;
}

1;
