# --
# Kernel/Language/de.pm - provides de language translation
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: de.pm,v 1.204 2009-08-21 07:41:00 mb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --
package Kernel::Language::de;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.204 $) [1];

sub Data {
    my $Self = shift;

    # $$START$$
    # Last translation file sync: Sat Jun 27 13:55:00 2009

    # possible charsets
    $Self->{Charset} = ['iso-8859-1', 'iso-8859-15', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Jear;)
    $Self->{DateFormat}          = '%D.%M.%Y %T';
    $Self->{DateFormatLong}      = '%T - %D.%M.%Y';
    $Self->{DateFormatShort}     = '%D.%M.%Y';
    $Self->{DateInputFormat}     = '%D.%M.%Y';
    $Self->{DateInputFormatLong} = '%D.%M.%Y - %T';

    $Self->{Translation} = {
        # Template: AAABase
        'Yes' => 'Ja',
        'No' => 'Nein',
        'yes' => 'ja',
        'no' => 'kein',
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
        'day' => 'Tag',
        'days' => 'Tage',
        'day(s)' => 'Tag(e)',
        'hour' => 'Stunde',
        'hours' => 'Stunden',
        'hour(s)' => 'Stunde(n)',
        'minute' => 'Minute',
        'minutes' => 'Minuten',
        'minute(s)' => 'Minute(n)',
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
        'invalid' => 'ungültig',
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
        'AddLink' => 'Link hinzufügen',
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
        'Lite' => 'Einfach',
        'User' => 'Benutzer',
        'Username' => 'Benutzername',
        'Language' => 'Sprache',
        'Languages' => 'Sprachen',
        'Password' => 'Passwort',
        'Salutation' => 'Anrede',
        'Signature' => 'Signatur',
        'Customer' => 'Kunde',
        'CustomerID' => 'Kunden#',
        'CustomerIDs' => 'Kunden-Nummern',
        'customer' => 'Kunde',
        'agent' => 'Agent',
        'system' => 'System',
        'Customer Info' => 'Kunden-Info',
        'Customer Company' => 'Kunden-Firma',
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
        'Valid' => 'Gültig',
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
        'New message' => 'Neue Nachricht',
        'New message!' => 'Neue Nachricht!',
        'Please answer this ticket(s) to get back to the normal queue view!' => 'Bitte beantworten Sie dieses Ticket, um in die normale Queue-Ansicht zurück zu kommen!',
        'You got new message!' => 'Sie haben eine neue Nachricht bekommen!',
        'You have %s new message(s)!' => 'Sie haben %s neue Nachricht(en) bekommen!',
        'You have %s reminder ticket(s)!' => 'Sie haben %s Erinnerungs-Ticket(s)!',
        'The recommended charset for your language is %s!' => 'Der empfohlene Zeichensatz für Ihre Sprache ist %s!',
        'Passwords doesn\'t match! Please try it again!' => 'Passwörter stimmen nicht überein! Bitte wiederholen!',
        'Password is already in use! Please use an other password!' => 'Dieses Password wird bereits benutzt, es kann nicht verwendet werden!',
        'Password is already used! Please use an other password!' => 'Dieses Password wurde bereits benutzt, es kann nicht verwendet werden!',
        'You need to activate %s first to use it!' => '%s muss zuerst aktiviert werden um es zu benutzen!',
        'No suggestions' => 'Keine Vorschläge',
        'Word' => 'Wort',
        'Ignore' => 'Ignorieren',
        'replace with' => 'ersetzen mit',
        'There is no account with that login name.' => 'Es existiert kein Benutzerkonto mit diesem Namen.',
        'Login failed! Your username or password was entered incorrectly.' => 'Anmeldung fehlgeschlagen! Benutzername oder Passwort falsch.',
        'Please contact your admin' => 'Bitte kontaktieren Sie Ihren Administrator',
        'Logout successful. Thank you for using OTRS!' => 'Abmeldung erfolgreich! Danke für die Benutzung von  OTRS!',
        'Invalid SessionID!' => 'Ungültige SessionID!',
        'Feature not active!' => 'Funktion nicht aktiviert!',
        'Notification (Event)' => 'Benachrichtigung (Ereignis)',
        'Login is needed!' => 'Login wird benötigt!',
        'Password is needed!' => 'Passwort wird benötigt!',
        'License' => 'Lizenz',
        'Take this Customer' => 'Kunden übernehmen',
        'Take this User' => 'Benutzer übernehmen',
        'possible' => 'möglich',
        'reject' => 'ablehnen',
        'reverse' => 'umgekehrt',
        'Facility' => 'Einrichtung',
        'Timeover' => 'Zeitüberschreitung',
        'Pending till' => 'Warten bis',
        'Don\'t work with UserID 1 (System account)! Create new users!' => 'Bitte nicht mit UserID 1 (System Account) arbeiten! Erstelle neue Benutzer!',
        'Dispatching by email To: field.' => 'Verteilung nach To: Feld.',
        'Dispatching by selected Queue.' => 'Verteilung nach ausgewählter Queue.',
        'No entry found!' => 'Kein Eintrag gefunden!',
        'Session has timed out. Please log in again.' => 'Zeitüberschreitung der Session. Bitte neu anmelden.',
        'No Permission!' => 'Keine Zugriffsrechte!',
        'To: (%s) replaced with database email!' => 'An: (%s) ersetzt mit Datenbank E-Mail!',
        'Cc: (%s) added database email!' => 'Cc: (%s) Datenbank E-Mail hinzugefügt!',
        '(Click here to add)' => '(Hier klicken um hinzuzufügen)',
        'Preview' => 'Vorschau',
        'Package not correctly deployed! You should reinstall the Package again!' => 'Paket nicht korrekt installiert! Sie sollten es erneut installieren!',
        'Added User "%s"' => 'Benutzer "%s" hinzugefügt.',
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
        'Office' => 'Büro',
        'Phone' => 'Telefon',
        'Fax' => 'Fax',
        'Mobile' => 'Mobile',
        'Zip' => 'PLZ',
        'City' => 'Stadt',
        'Street' => 'Straße',
        'Country' => 'Land',
        'Location' => 'Standort',
        'installed' => 'installiert',
        'uninstalled' => 'nicht installiert',
        'Security Note: You should activate %s because application is already running!' => 'Sicherheitshinweis: Sie sollten den %s aktivieren, da die Anwendung bereits in Betrieb ist!',
        'Unable to parse Online Repository index document!' => 'Nicht möglich den Online Repository Index zu verarbeiten!',
        'No Packages for requested Framework in this Online Repository, but Packages for other Frameworks!' => 'Kein Paket für den benötigten Framework vorhanden, aber für andere Frameworks.',
        'No Packages or no new Packages in selected Online Repository!' => 'Kein Paket oder keine neuen Pakete im ausgewählten Online Repository vorhanden!',
        'printed at' => 'gedruckt am',
        'Dear Mr. %s,' => 'Sehr geehrter Herr %s,',
        'Dear Mrs. %s,' => 'Sehr geehrte Frau %s,',
        'Dear %s,' => 'Lieber %s,',
        'Hello %s,' => 'Hallo %s,',
        'This account exists.' => 'Dieser Benutzer ist bereits vorhanden.',
        'New account created. Sent Login-Account to %s.' => 'Neuen Account erstellt. Login-Daten an %s gesendet.',
        'Please press Back and try again.' => 'Bitte auf Zurück klicken und erneut versuchen.',
        'Sent password token to: %s' => 'Passwort-Token an %s gesendet.',
        'Sent new password to: %s' => 'Neues Passwort an %s gesendet.',
        'Upcoming Events' => 'Anstehende Ereignisse',
        'Event' => 'Ereignis',
        'Events' => 'Ereignisse',
        'Invalid Token!' => 'Ungültiger Token!',
        'more' => 'mehr',
        'For more info see:' => 'Für mehr Informationen hier:',
        'Package verification failed!' => 'Paket Überprüfung Fehlgeschlagen',
        'Collapse' => 'Zuklappen',
        'News' => 'Neues',
        'Product News' => 'Produkt Neuigkeiten',
        'OTRS News' => 'OTRS Neuigkeiten',
        '7 Day Stats' => '7 Tage-Statistik',
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
        'June' => 'Juni',
        'July' => 'Juli',
        'August' => 'August',
        'September' => 'September',
        'October' => 'Oktober',
        'November' => 'November',
        'December' => 'Dezember',

        # Template: AAANavBar
        'Admin-Area' => 'Admin-Bereich',
        'Agent-Area' => 'Agent-Bereich',
        'Ticket-Area' => 'Ticket-Bereich',
        'Logout' => 'Abmelden',
        'Agent Preferences' => 'Benutzer Einstellungen',
        'Preferences' => 'Einstellungen',
        'Agent Mailbox' => 'Agent Mailbox',
        'Stats' => 'Statistik',
        'Stats-Area' => 'Statistik-Bereich',
        'Admin' => 'Admin',
        'Customer Users' => 'Kunden Benutzer',
        'Customer Users <-> Groups' => 'Kunden Benutzer <-> Gruppen',
        'Users <-> Groups' => 'Benutzer <-> Gruppen',
        'Roles' => 'Rollen',
        'Roles <-> Users' => 'Rollen <-> Benutzer',
        'Roles <-> Groups' => 'Rollen <-> Gruppen',
        'Salutations' => 'Anreden',
        'Signatures' => 'Signaturen',
        'Email Addresses' => 'E-Mail Adressen',
        'Notifications' => 'Benachrichtigungen',
        'Category Tree' => 'Kategorie Baum',
        'Admin Notification' => 'Admin-Benachrichtigung',

        # Template: AAAPreferences
        'Preferences updated successfully!' => 'Benutzereinstellungen erfolgreich aktualisiert!',
        'Mail Management' => 'Mail Management',
        'Frontend' => 'Oberfläche',
        'Other Options' => 'Andere Optionen',
        'Change Password' => 'Passwort ändern',
        'New password' => 'Neues Passwort',
        'New password again' => 'Neues Passwort (wiederholen)',
        'Select your QueueView refresh time.' => 'Queue-Ansicht Aktualisierungszeit auswählen.',
        'Select your frontend language.' => 'Oberflächen-Sprache auswählen.',
        'Select your frontend Charset.' => 'Zeichensatz für Darstellung auswählen.',
        'Select your frontend Theme.' => 'Anzeigeschema auswählen.',
        'Select your frontend QueueView.' => 'Queue-Ansicht auswählen.',
        'Spelling Dictionary' => 'Rechtschreib-Wörterbuch',
        'Select your default spelling dictionary.' => 'Standard Rechtschreib-Wörterbuch auswählen.',
        'Max. shown Tickets a page in Overview.' => 'Maximale Anzahl angezeigter Tickets pro Seite in der Übersicht.',
        'Can\'t update password, your new passwords do not match! Please try again!' => 'Passwörter sind nicht identisch! Bitte erneut versuchen!',
        'Can\'t update password, invalid characters!' => 'Passwort konnte nicht aktualisiert werden, Zeichen ungülig.',
        'Can\'t update password, must be at least %s characters!' => 'Passwort konnte nicht aktualisiert werden, benötige min. %s Zeichen.',
        'Can\'t update password, must contain 2 lower and 2 upper characters!' => 'Passwort konnte nicht aktualisiert werden, benötige min. einen großgeschriebener und einen kleingeschriebener Buchstaben.',
        'Can\'t update password, needs at least 1 digit!' => 'Passwort konnte nicht aktualisiert werden, Passwort muss mind. eine Zahl enthalten!',
        'Can\'t update password, needs at least 2 characters!' => 'Passwort konnte nicht aktualisiert werden, Passwort muss mind. zwei Buchstaben enthalten!',

        # Template: AAAStats
        'Stat' => 'Statistik',
        'Please fill out the required fields!' => 'Bitte füllen Sie alle Pflichtfelder aus!',
        'Please select a file!' => 'Bitte wählen Sie eine Datei aus!',
        'Please select an object!' => 'Bitte wählen Sie ein Statistik-Objekt aus!',
        'Please select a graph size!' => 'Bitte legen Sie die Graphikgröße fest!',
        'Please select one element for the X-axis!' => 'Bitte wählen Sie ein Element für die X-Achse aus!',
        'Please select only one element or turn off the button \'Fixed\' where the select field is marked!' => 'Bitte wählen Sie nur ein Element aus oder entfernen Sie das Häkchen der Checkbox \'Fixed\'!',
        'If you use a checkbox you have to select some attributes of the select field!' => 'Wenn Sie Inhalte eines Auswahlfelds auswählen müssen Sie mindestens zwei Attribute auswählen!',
        'Please insert a value in the selected input field or turn off the \'Fixed\' checkbox!' => 'Tragen Sie bitte etwas in die Eingabezeile ein oder entfernen Sie das Häkchen aus der Checkbox \'Fixed\'!',
        'The selected end time is before the start time!' => 'Die ausgewählte Endzeit ist vor der Startzeit!',
        'You have to select one or more attributes from the select field!' => 'Bitte wählen Sie bitte ein oder mehrere Attribute aus dem Auswahlfeld aus!',
        'The selected Date isn\'t valid!' => 'Sie haben ein ungültiges Datum ausgewählt!',
        'Please select only one or two elements via the checkbox!' => 'Bitte wählen Sie nur ein oder zwei Elemente aus!',
        'If you use a time scale element you can only select one element!' => 'Wenn Sie ein Zeit-Element ausgewählt haben, können Sie nur kein weiteres Element mehr auswählen!',
        'You have an error in your time selection!' => 'Sie haben einen Fehler in Ihrer Zeitauswahl!',
        'Your reporting time interval is too small, please use a larger time scale!' => 'Die Zeitskalierung ist zu klein gewählt, bitte wählen Sie eine größere Zeitskalierung!',
        'The selected start time is before the allowed start time!' => 'Die gewählte Startzeit ist außerhalb des erlaubten Bereichs!',
        'The selected end time is after the allowed end time!' => 'Die gewählte Endzeit ist außerhalb des erlaubten Bereichs!',
        'The selected time period is larger than the allowed time period!' => 'Der gewählte Zeitraum ist größer als der erlaubte Zeitraum!',
        'Common Specification' => 'Allgemeine Angaben',
        'Xaxis' => 'X-Achse',
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
        'Create Time' => 'Ticket erstellt',
        'CustomerUserLogin' => 'Kundenlogin',
        'Close Time' => 'Ticket geschlossen',
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
        'Ticket Create Time' => 'Ticket erstellt',
        'Ticket Close Time' => 'Ticket geschlossen',

        # Template: AAATicket
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
        'Priority Update' => 'Priorität aktualisieren',
        'State' => 'Status',
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
        'plain' => 'klar',
        'Email' => 'E-Mail',
        'email' => 'E-Mail',
        'Close' => 'Schließen',
        'Action' => 'Aktion',
        'Attachment' => 'Anlage',
        'Attachments' => 'Anlagen',
        'This message was written in a character set other than your own.' => 'Diese Nachricht wurde in einem Zeichensatz erstellt, der nicht Ihrem eigenen entspricht.',
        'If it is not displayed correctly,' => 'Wenn sie nicht korrekt angezeigt wird,',
        'This is a' => 'Dies ist eine',
        'to open it in a new window.' => 'um sie in einem neuen Fenster angezeigt zu bekommen',
        'This is a HTML email. Click here to show it.' => 'Dies ist eine HTML E-Mail. Hier klicken, um sie anzuzeigen.',
        'Free Fields' => 'Freie Felder',
        'Merge' => 'Zusammenfassen',
        'merged' => 'zusammengefügt',
        'closed successful' => 'erfolgreich geschlossen',
        'closed unsuccessful' => 'erfolglos geschlossen',
        'new' => 'neu',
        'open' => 'offen',
        'Open' => 'Offen',
        'closed' => 'geschlossen',
        'Closed' => 'Geschlossen',
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
        'sms' => 'sms',
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
        'Ticket "%s" created!' => 'Ticket "%s" erstellt!',
        'Ticket Number' => 'Ticket Nummer',
        'Ticket Object' => 'Ticket Objekt',
        'No such Ticket Number "%s"! Can\'t link it!' => 'Ticketnummer "%s" nicht gefunden! Ticket konnte nicht verknüpft werden!',
        'Don\'t show closed Tickets' => 'Geschlossene Tickets nicht zeigen',
        'Show closed Tickets' => 'Geschlossene Tickets anzeigen',
        'New Article' => 'Neuer Artikel',
        'Email-Ticket' => 'E-Mail-Ticket',
        'Create new Email Ticket' => 'Ein neues E-Mail-Ticket erstellen',
        'Phone-Ticket' => 'Telefon-Ticket',
        'Search Tickets' => 'Ticket-Suche',
        'Edit Customer Users' => 'Kunden-Benutzer bearbeiten',
        'Edit Customer Company' => 'Kunden-Firma bearbeiten',
        'Bulk Action' => 'Sammel-Aktion',
        'Bulk Actions on Tickets' => 'Sammel-Action an Tickets',
        'Send Email and create a new Ticket' => 'E-Mail senden und neues Ticket erstellen',
        'Create new Email Ticket and send this out (Outbound)' => 'Neues Ticket wird erstellt und Email versendet',
        'Create new Phone Ticket (Inbound)' => 'Neues Ticket wird über einkommenden Anruf erstellt',
        'Overview of all open Tickets' => 'Übersicht über alle offenen Tickets',
        'Locked Tickets' => 'Gesperrte Tickets',
        'Watched Tickets' => 'Beobachtete Tickets',
        'Watched' => 'Beobachtet',
        'Subscribe' => 'Abonnieren',
        'Unsubscribe' => 'Ababonnieren',
        'Lock it to work on it!' => 'Sperren um es zu bearbeiten!',
        'Unlock to give it back to the queue!' => 'Freigeben um es in die Queue zurück zu geben!',
        'Shows the ticket history!' => 'Ticket Historie anzeigen!',
        'Print this ticket!' => 'Ticket drucken!',
        'Change the ticket priority!' => 'Ändern der Ticket-Priorität',
        'Change the ticket free fields!' => 'Ändern der Ticket-Frei-Felder',
        'Link this ticket to an other objects!' => 'Ticket zu anderen Objekten verknüpfen!',
        'Change the ticket owner!' => 'Ändern des Ticket-Besitzers!',
        'Change the ticket customer!' => 'Ändern des Ticket-Kunden!',
        'Add a note to this ticket!' => 'Hinzufügen einer Notiz!',
        'Merge this ticket!' => 'Ticket mit einem anderen vereinen!',
        'Set this ticket to pending!' => 'Setzen des Tickets auf -warten auf-!',
        'Close this ticket!' => 'Ticket schließen!',
        'Look into a ticket!' => 'Ticket genauer ansehen!',
        'Delete this ticket!' => 'Ticket löschen!',
        'Mark as Spam!' => 'Als Spam makieren!',
        'My Queues' => 'Meine Queues',
        'Shown Tickets' => 'Gezeigte Tickets',
        'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' => 'Ihre E-Mail mit Ticket-Nummer "<OTRS_TICKET>" wurde zu Ticket-Nummer "<OTRS_MERGE_TO_TICKET>" gemerged!',
        'Ticket %s: first response time is over (%s)!' => 'Ticket %s: Reaktionszeit ist abgelaufen (%s)!',
        'Ticket %s: first response time will be over in %s!' => 'Ticket %s: Reaktionszeit wird ablaufen in %s!',
        'Ticket %s: update time is over (%s)!' => 'Ticket %s: Aktualisierungszeit ist abgelaufen (%s)!',
        'Ticket %s: update time will be over in %s!' => 'Ticket %s: Aktualisierungszeit wird ablaufen in %s!',
        'Ticket %s: solution time is over (%s)!' => 'Ticket %s: Lösungszeit ist abgelaufen (%s)!',
        'Ticket %s: solution time will be over in %s!' => 'Ticket %s: Lösungszeit wird ablaufen in %s!',
        'There are more escalated tickets!' => 'Mehrere eskalierte Tickets vorhanden!',
        'New ticket notification' => 'Mitteilung bei neuem Ticket',
        'Send me a notification if there is a new ticket in "My Queues".' => 'Zusenden einer Mitteilung bei neuem Ticket in "Meine Queues".',
        'Follow up notification' => 'Mitteilung bei Nachfragen',
        'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.' => 'Zusenden einer Mitteilung, wenn ein Kunde eine Nachfrage stellt und ich der Besitzer bin.',
        'Ticket lock timeout notification' => 'Mitteilung bei Überschreiten der Sperrzeit',
        'Send me a notification if a ticket is unlocked by the system.' => 'Zusenden einer Mitteilung, wenn ein Ticket vom System freigegeben ("unlocked") wird.',
        'Move notification' => 'Mitteilung bei Queue-Wechsel',
        'Send me a notification if a ticket is moved into one of "My Queues".' => 'Zusenden einer Mitteilung beim Verschieben eines Tickets in "Meine Queues".',
        'Your queue selection of your favourite queues. You also get notified about those queues via email if enabled.' => 'Queue Auswahl der bevorzugten Queues. Es werden E-Mail-Benachrichtigungen über diese ausgewählten Queues versendet.',
        'Custom Queue' => 'Bevorzugte Queue',
        'QueueView refresh time' => 'Queue-Ansicht Aktualisierungszeit',
        'Screen after new ticket' => 'Fenster nach neuem Ticket',
        'Select your screen after creating a new ticket.' => 'Auswahl des Fensters, das nach der Erstellung eines neuen Tickets angezeigt werden soll.',
        'Closed Tickets' => 'Geschlossene Tickets',
        'Show closed tickets.' => 'Geschlossene Tickets anzeigen.',
        'Max. shown Tickets a page in QueueView.' => 'Maximale Anzahl angezeigter Tickets pro Seite in der Queue-Ansicht.',
        'Watch notification' => 'Beobachter Benachrichtigung',
        'Send me a notification of an watched ticket like an owner of an ticket.' => 'Informierte mich über Änderungen an beobachteten Tickets (als ob ich der Besitzer eines Ticket wäre).',
        'Out Of Office' => 'Abwesenheit',
        'Select your out of office time.' => 'Bitte die Abwesenheitszeit auswählen.',
        'CompanyTickets' => 'Firmen Ticket',
        'MyTickets' => 'Meine Tickets',
        'New Ticket' => 'Neues Ticket',
        'Create new Ticket' => 'Neues Ticket erstellen',
        'Customer called' => 'Kunden angerufen',
        'phone call' => 'Telefonanruf',
        'Reminder Reached' => 'Erinnerung erreicht',
        'Reminder Tickets' => 'Erinnerungs Tickets',
        'Escalated Tickets' => 'Eskalierte Tickets',
        'New Tickets' => 'Neue Tickets',
        'Open Tickets / Need to be answered' => 'Offene Tickets / Zur Beantwortung',
        'Tickets which need to be answered!' => 'Tickets welche beantwortet werden müssen!',
        'All new tickets!' => 'Alle neuen Tickets!',
        'All tickets which are escalated!' => 'Alle eskalierten Tickets!',
        'All tickets where the reminder date has reached!' => 'Alle Tickets welche die Wiedervorlage erreicht haben!',
        'Responses' => 'Antworten',
        'Responses <-> Queue' => 'Antworten <-> Queues',
        'Auto Responses' => 'Auto Antworten',
        'Auto Responses <-> Queue' => 'Auto Antworten <-> Queues',
        'Attachments <-> Responses' => 'Anlagen <-> Antworten',
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
        'History::TicketFreeTextUpdate' => 'Aktualisiert: %s=%s;%s=%s;',
        'History::WebRequestCustomer' => 'Kunde stellte Anfrage über Web.',
        'History::TicketLinkAdd' => 'Verknüpfung zu "%s" hergestellt.',
        'History::TicketLinkDelete' => 'Verknüpfung zu "%s" gelöscht.',
        'History::Subscribe' => 'Abo für Benutzer "%s" eingetragen.',
        'History::Unsubscribe' => 'Abo für Benutzer "%s" ausgetragen.',

        # Template: AAAWeekDay
        'Sun' => 'Son',
        'Mon' => 'Mon',
        'Tue' => 'Die',
        'Wed' => 'Mit',
        'Thu' => 'Don',
        'Fri' => 'Fre',
        'Sat' => 'Sam',

        # Template: AdminAttachmentForm
        'Attachment Management' => 'Anlagen Verwaltung',

        # Template: AdminAutoResponseForm
        'Auto Response Management' => 'Auto-Antworten Verwaltung',
        'Response' => 'Antwort',
        'Auto Response From' => 'Auto-Antwort-Absender',
        'Note' => 'Notiz',
        'Useable options' => 'Verfügbare Optionen',
        'To get the first 20 character of the subject.' => 'Die ersten 20 Zeichen des Betreffs',
        'To get the first 5 lines of the email.' => 'Die ersten fünf Zeilen der Nachricht',
        'To get the realname of the sender (if given).' => 'Der Name des Benutzers (soweit bekannt)',
        'To get the article attribute (e. g. (<OTRS_CUSTOMER_From>, <OTRS_CUSTOMER_To>, <OTRS_CUSTOMER_Cc>, <OTRS_CUSTOMER_Subject> and <OTRS_CUSTOMER_Body>).' => 'Die Artikel Attribute (z. B. (<OTRS_CUSTOMER_From>, <OTRS_CUSTOMER_To>, <OTRS_CUSTOMER_Cc>, <OTRS_CUSTOMER_Subject> and <OTRS_CUSTOMER_Body>).',
        'Options of the current customer user data (e. g. <OTRS_CUSTOMER_DATA_UserFirstname>).' => 'Details zum aktuellen Kunden (z. B. <OTRS_CUSTOMER_DATA_UserFirstname>)',
        'Ticket owner options (e. g. <OTRS_OWNER_UserFirstname>).' => 'Details zum Ticket-Besitzer (z. B. <OTRS_OWNER_UserFirstname>).',
        'Ticket responsible options (e. g. <OTRS_RESPONSIBLE_UserFirstname>).' => 'Details zum Ticket-Verantwortlichen (z. B.<OTRS_RESPONSIBLE_UserFirstname>).',
        'Options of the current user who requested this action (e. g. <OTRS_CURRENT_UserFirstname>).' => 'Details zum aktuellen Benutzer, der diese Aktion veranlasst hat (z. B. <OTRS_CURRENT_UserFirstname).',
        'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>).' => 'Detailinformation zum Ticket (z. B. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>).',
        'Config options (e. g. <OTRS_CONFIG_HttpType>).' => 'Konfigurations Optionen (z. B. <OTRS_CONFIG_HttpType).',

        # Template: AdminCustomerCompanyForm
        'Customer Company Management' => 'Kunden-Firma Verwaltung',
        'Search for' => 'Suche nach',
        'Add Customer Company' => 'Kunden-Firma hinzufügen',
        'Add a new Customer Company.' => 'Eine neue Kunden-Firma hinzufügen.',
        'List' => 'Liste',
        'This values are required.' => 'Diese Inhalte werden benötigt.',
        'This values are read only.' => 'Diese Inhalte sind schreibgeschützt.',

        # Template: AdminCustomerUserForm
        'The message being composed has been closed.  Exiting.' => 'Die erstellte Nachricht wurde geschlossen.',
        'This window must be called from compose window' => 'Dieses Fenster muss über das Verfassen-Fenster aufgerufen werden',
        'Customer User Management' => 'Kunden-Benutzer Verwaltung',
        'Add Customer User' => 'Kunden-Benutzer hinzufügen',
        'Source' => 'Quelle',
        'Create' => 'Erstellen',
        'Customer user will be needed to have a customer history and to login via customer panel.' => 'Kunden-Benutzer werden für Kunden-Historien und für die Benutzung von Kunden-Weboberfläche benötigt.',

        # Template: AdminCustomerUserGroupChangeForm
        'Customer Users <-> Groups Management' => 'Kundenbenutzer <-> Gruppen Verwaltung',
        'Change %s settings' => 'Ändern der %s Einstellungen',
        'Select the user:group permissions.' => 'Auswahl der Benutzer/Gruppen Berechtigungen.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the user).' => 'Ist nichts ausgewählt, sind keine Rechte vergeben (diese Tickets sind für den Benutzer nicht verfügbar).',
        'Permission' => 'Rechte',
        'ro' => 'ro',
        'Read only access to the ticket in this group/queue.' => 'Nur-Lesen-Zugriff auf Tickets in diesen Gruppen/Queues.',
        'rw' => 'rw',
        'Full read and write access to the tickets in this group/queue.' => 'Voller Schreib- und Lesezugriff auf Tickets in der Queue/Gruppe.',

        # Template: AdminCustomerUserGroupForm

        # Template: AdminCustomerUserService
        'Customer Users <-> Services Management' => 'Kundenbenutzer <-> Services Verwaltung',
        'CustomerUser' => 'Kundenbenutzer',
        'Service' => 'Service',
        'Edit default services.' => 'Standard-Services bearbeiten.',
        'Search Result' => 'Such-Ergebnis',
        'Allocate services to CustomerUser' => 'Services zuordnen zum Kundenbenutzer',
        'Active' => 'Aktiv',
        'Allocate CustomerUser to service' => 'Kundenbenutzer zuordnen zum Service',

        # Template: AdminEmail
        'Message sent to' => 'Nachricht gesendet an',
        'A message should have a subject!' => 'Eine Nachricht sollte einen Betreff haben!',
        'Recipients' => 'Empfänger',
        'Body' => 'Text',
        'Send' => 'Senden',

        # Template: AdminGenericAgent
        'GenericAgent' => 'GenericAgent',
        'Job-List' => 'Job-Liste',
        'Last run' => 'Letzte Ausführung',
        'Run Now!' => 'Jetzt ausführen!',
        'x' => 'x',
        'Save Job as?' => 'Speichere Job als?',
        'Is Job Valid?' => 'Ist Job gültig?',
        'Is Job Valid' => 'Ist Job gültig',
        'Schedule' => 'Zeitplan',
        'Currently this generic agent job will not run automatically.' => 'Derzeit würde dieser GenericAgentJob nicht automatisch ausgeführt werden.',
        'To enable automatic execution select at least one value from minutes, hours and days!' => 'Um ihn automatisch auszuführen muß mindestens ein Wert vom Minuten, Stunden und Tagen ausgewählt werden!',
        'Fulltext-Search in Article (e. g. "Mar*in" or "Baue*")' => 'Volltextsuche in Artikel (z. B. "Mar*in" oder "Baue*")',
        '(e. g. 10*5155 or 105658*)' => 'z .B. 10*5144 oder 105658*',
        '(e. g. 234321)' => 'z. B. 234321',
        'Customer User Login' => 'Kunden-Benutzer-Login',
        '(e. g. U5150)' => 'z. B. U5150',
        'SLA' => 'SLA',
        'Agent' => 'Agent',
        'Ticket Lock' => 'Ticket sperren',
        'TicketFreeFields' => 'TicketFreiFelder',
        'Create Times' => 'Erstell-Zeiten',
        'No create time settings.' => 'Keine Erstell-Zeiten',
        'Ticket created' => 'Ticket erstellt',
        'Ticket created between' => 'Ticket erstellt zwischen',
        'Close Times' => 'Schließ-Zeiten',
        'No close time settings.' => 'keine Schließ-Zeiten',
        'Ticket closed' => 'Ticket geschlossen',
        'Ticket closed between' => 'Ticket geschlossen zwischen',
        'Pending Times' => 'Warten-Zeiten',
        'No pending time settings.' => 'Keine Warten-Zeiten',
        'Ticket pending time reached' => 'Ticket Warten-Zeit erreicht',
        'Ticket pending time reached between' => 'Ticket Warten-Zeit erreicht zwischen',
        'Escalation Times' => 'Eskalations-Zeiten',
        'No escalation time settings.' => 'Keine Eskalations-Zeiten',
        'Ticket escalation time reached' => 'Ticket Eskalations-Zeit erreicht',
        'Ticket escalation time reached between' => 'Ticket Eskalations-Zeit erreicht zwischen',
        'Escalation - First Response Time' => 'Eskalation - Reaktionszeit',
        'Ticket first response time reached' => 'Ticket Reaktionszeit erreicht',
        'Ticket first response time reached between' => 'Ticket Reaktionszeit erreicht zwischen',
        'Escalation - Update Time' => 'Eskalation - Aktualisierungszeit',
        'Ticket update time reached' => 'Ticket Aktuallisierungszeit erreicht',
        'Ticket update time reached between' => 'Ticket Aktuallisierungszeit erreicht zwischen',
        'Escalation - Solution Time' => 'Eskalation - Lösungszeit',
        'Ticket solution time reached' => 'Ticket Lösungszeit erreicht',
        'Ticket solution time reached between' => 'Ticket Lösungszeit erreicht zwischen',
        'New Service' => 'Neuer Service',
        'New SLA' => 'Neuer SLA',
        'New Priority' => 'Neue Priorität',
        'New Queue' => 'Neue Queue',
        'New State' => 'Neuer Status',
        'New Agent' => 'Neuer Besitzer',
        'New Owner' => 'Neuer Besitzer',
        'New Customer' => 'Neuer Kunde',
        'New Ticket Lock' => 'Neues Ticket Lock',
        'New Type' => 'Neuer Typ',
        'New Title' => 'Neuer Titel',
        'New TicketFreeFields' => 'Neue TicketFreiFelder',
        'Add Note' => 'Notiz hinzufügen',
        'Time units' => 'Zeiteinheiten',
        'CMD' => 'CMD',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' => 'Dieses Kommando wird mit ARG[0] (die Ticket Nummer) und ARG[1] die TicketID ausgeführt.',
        'Delete tickets' => 'Tickets Löschen',
        'Warning! This tickets will be removed from the database! This tickets are lost!' => 'Warnung! Alle diese Tickets werden von der Datenbank entfernt! Diese Tickets sind nicht wiederherstellbar!',
        'Send Notification' => 'Senden der Benachrichtigung',
        'Param 1' => 'Param 1',
        'Param 2' => 'Param 2',
        'Param 3' => 'Param 3',
        'Param 4' => 'Param 4',
        'Param 5' => 'Param 5',
        'Param 6' => 'Param 6',
        'Send agent/customer notifications on changes' => 'Sende eine Agent/Kunden Benachrichtigung bei Änderungen',
        'Save' => 'Speichern',
        '%s Tickets affected! Do you really want to use this job?' => '%s Tickets sind betroffen! Wollen Sie diesen Job wirklich benutzen?',

        # Template: AdminGroupForm
        'WARNING: When you change the name of the group \'admin\', before making the appropriate changes in the SysConfig, you will be locked out of the administrations panel! If this happens, please rename the group back to admin per SQL statement.' => 'VORSICHT: Wenn Sie den Namen der \'admin\'-Gruppe ändern ohne zuvor die entsprechenden Anpassungen in der SysConfig getätigt haben, verlieren Sie den Zugang zum Adminbereich!',
        'Group Management' => 'Gruppen Verwaltung',
        'Add Group' => 'Gruppe hinzufügen',
        'Add a new Group.' => 'Eine neue Gruppe hinzufügen.',
        'The admin group is to get in the admin area and the stats group to get stats area.' => 'Die \'admin\'-Gruppe wird für den Admin-Bereich benötigt, die \'stats\'-Gruppe für den Statistik-Bereich.',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).' => 'Erstellen Sie neue Gruppen, um die Zugriffe für verschiedene Agenten-Gruppen zu definieren (z. B. Einkaufs-Abteilung, Support-Abteilung, Verkaufs-Abteilung,...).',
        'It\'s useful for ASP solutions.' => 'Nützlich für ASP-Lösungen.',

        # Template: AdminLog
        'System Log' => 'System Log',
        'Time' => 'Zeit',

        # Template: AdminMailAccount
        'Mail Account Management' => 'Mail Account Management',
        'Host' => 'Host',
        'Trusted' => 'Vertraut',
        'Dispatching' => 'Verteilung',
        'All incoming emails with one account will be dispatched in the selected queue!' => 'Einkommende E-Mails von POP3-Konten werden in die ausgewählte Queue einsortiert!',
        'If your account is trusted, the already existing X-OTRS header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' => 'Wird dem Konto vertraut, werden die X-OTRS Header benutzt! PostMaster Filter werden trotzdem benutzt.',

        # Template: AdminNavigationBar
        'Users' => 'Benutzer',
        'Groups' => 'Gruppen',
        'Misc' => 'Sonstiges',

        # Template: AdminNotificationEventForm
        'Notification Management' => 'Benachrichtigungs Verwaltung',
        'Add Notification' => 'Benachrichtigung hinzufügen',
        'Add a new Notification.' => 'Eine neue Benachrichtigung hinzufügen',
        'Name is required!' => 'Name wird benötigt!',
        'Event is required!' => 'Ereignis ist benötigt!',
        'A message should have a body!' => 'Eine Nachricht sollte einen Body haben!',
        'Recipient' => 'Empfänger',
        'Group based' => 'Gruppen basierend',
        'Agent based' => 'Agenten basierend',
        'Email based' => 'Email basierend',
        'Article Type' => 'Artikel Typ',
        'Only for ArticleCreate Event.' => 'Nur für Ereignis ArticleCreate.',
        'Subject match' => 'Betreff treffer',
        'Body match' => 'Body treffer',
        'Notifications are sent to an agent or a customer.' => 'Benachrichtigungen werden an Agenten und Kunden gesendet.',
        'To get the first 20 character of the subject (of the latest agent article).' => 'Die ersten 20 Zeichen des Betreffs (des letzten Agenten-Artikel).',
        'To get the first 5 lines of the body (of the latest agent article).' => 'Die ersten fünf Zeilen der Nachricht (des letzten Agenten-Artikel).',
        'To get the article attribute (e. g. (<OTRS_AGENT_From>, <OTRS_AGENT_To>, <OTRS_AGENT_Cc>, <OTRS_AGENT_Subject> and <OTRS_AGENT_Body>).' => 'Die Artikel Attribute (z. B. (<OTRS_AGENT_From>, <OTRS_AGENT_To>, <OTRS_AGENT_Cc>, <OTRS_AGENT_Subject> und <OTRS_AGENT_Body>).',
        'To get the first 20 character of the subject (of the latest customer article).' => 'Die ersten 20 Zeichen des Betreffs (des letzten Kunden-Artikel)',
        'To get the first 5 lines of the body (of the latest customer article).' => 'Die ersten fünf Zeilen der Nachricht (des letzten Kunden-Artikel).',

        # Template: AdminNotificationForm
        'Notification' => 'Benachrichtigung',

        # Template: AdminPackageManager
        'Package Manager' => 'Paket Verwaltung',
        'Uninstall' => 'Deinstallieren',
        'Version' => 'Version',
        'Do you really want to uninstall this package?' => 'Soll das Paket wirklich deinstalliert werden?',
        'Reinstall' => 'Erneut installieren',
        'Do you really want to reinstall this package (all manual changes get lost)?' => 'Soll das Paket wirklich erneut installiert werden (manuelle Änderungen gehen verloren)?',
        'Continue' => 'Weiter',
        'Install' => 'Installieren',
        'Package' => 'Paket',
        'Online Repository' => 'Online Repository',
        'Vendor' => 'Anbieter',
        'Module documentation' => 'Moduldokumentation',
        'Upgrade' => 'Erneuern',
        'Local Repository' => 'Lokales Repository',
        'Status' => 'Status',
        'Overview' => 'Übersicht',
        'Download' => 'Herunterladen',
        'Rebuild' => 'Rebuild',
        'ChangeLog' => 'ChangeLog',
        'Date' => 'Datum',
        'Filelist' => 'Dateiliste',
        'Download file from package!' => 'Datei aus dem Paket herunterladen!',
        'Required' => 'Benötigt',
        'PrimaryKey' => 'PrimaryKey',
        'AutoIncrement' => 'AutoIncrement',
        'SQL' => 'SQL',
        'Diff' => 'Diff',

        # Template: AdminPerformanceLog
        'Performance Log' => 'Performance Log',
        'This feature is enabled!' => 'Dieses Feature ist aktiv!',
        'Just use this feature if you want to log each request.' => 'Nur aktivieren wenn jede Anfrage protokolliert werden soll.',
        'Activating this feature might affect your system performance!' => 'Wenn dieses Feature aktiv ist, ist mit Leistungsdefizit zu rechnen.',
        'Disable it here!' => 'Hier deaktivieren!',
        'This feature is disabled!' => 'Dieses Feature ist inaktiv!',
        'Enable it here!' => 'Hier aktivieren!',
        'Logfile too large!' => 'Logdatei zu groß!',
        'Logfile too large, you need to reset it!' => 'Die Logdatei ist zu groß, bitte zurücksetzen!',
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

        # Template: AdminPGPForm
        'PGP Management' => 'PGP Verwaltung',
        'Result' => 'Ergebnis',
        'Identifier' => 'Identifikator',
        'Bit' => 'Bit',
        'Key' => 'Schlüssel',
        'Fingerprint' => 'Fingerabdruck',
        'Expires' => 'Erlischt',
        'In this way you can directly edit the keyring configured in SysConfig.' => 'Über diesen Weg kann man den Schlüsselring (konfiguriert in SysConfig) direkt bearbeiten.',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => 'PostMaster Filter Verwaltung',
        'Filtername' => 'Filtername',
        'Stop after match' => 'Stoppen nach Treffer',
        'Match' => 'Treffer',
        'Value' => 'Wert',
        'Set' => 'Setzen',
        'Do dispatch or filter incoming emails based on email X-Headers! RegExp is also possible.' => 'Verteilt oder Filtern einkommende E-Mail anhand der X-Headers! RegExp ist auch möglich.',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' => 'Wenn nur eine Email-Adresse gesucht wird, dann benutz EMAILADDRESS:info@example.com in Von, An oder Cc.',
        'If you use RegExp, you also can use the matched value in () as [***] in \'Set\'.' => 'Ist RegExp benutzt, können Sie auch den Inhalt von () als [***] in \'Setzen\' benutzen.',

        # Template: AdminPriority
        'Priority Management' => 'Priorität Verwaltung',
        'Add Priority' => 'Priorität hinzufügen',
        'Add a new Priority.' => 'Eine neue Priorität hinzufügen.',

        # Template: AdminQueueAutoResponseForm
        'Queue <-> Auto Responses Management' => 'Queue <-> Auto Antworten Verwaltung',
        'settings' => 'Einstellungen',

        # Template: AdminQueueForm
        'Queue Management' => 'Queue Verwaltung',
        'Sub-Queue of' => 'Unterqueue von',
        'Unlock timeout' => 'Freigabe-Zeitintervall',
        '0 = no unlock' => '0 = keine Freigabe',
        'Only business hours are counted.' => 'Nur Geschäftszeiten werden berücksichtigt.',
        '0 = no escalation' => '0 = keine Eskalation',
        'Notify by' => 'Benachrichtigt von',
        'Follow up Option' => 'Nachfrage Option',
        'Ticket lock after a follow up' => 'Ticket sperren nach einem Follow-Up',
        'Systemaddress' => 'Systemadresse',
        'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.' => 'Wird ein Ticket durch einen Agent gesperrt, jedoch nicht in dieser Zeit beantwortet, wird das Ticket automatisch freigegeben.',
        'Escalation time' => 'Eskalationszeit',
        'If a ticket will not be answered in this time, just only this ticket will be shown.' => 'Wird ein Ticket nicht in dieser Zeit beantwortet, wird nur noch dieses Ticket gezeigt.',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.' => 'Wenn ein Ticket geschlossen ist und der Kunde ein Follow-Up sendet, wird das Ticket für den alten Besitzer gesperrt.',
        'Will be the sender address of this queue for email answers.' => 'Absenderadresse für E-Mails aus dieser Queue.',
        'The salutation for email answers.' => 'Die Anrede für E-Mail-Antworten.',
        'The signature for email answers.' => 'Die Signatur für E-Mail-Antworten.',
        'Customer Move Notify' => 'Kundeninfo Verschieben',
        'OTRS sends an notification email to the customer if the ticket is moved.' => 'OTRS sendet eine Info-E-Mail an Kunden beim Verschieben des Tickets.',
        'Customer State Notify' => 'Kundeninfo Status',
        'OTRS sends an notification email to the customer if the ticket state has changed.' => 'OTRS sendet eine Info E-Mail an Kunden beim Ändern des Status.',
        'Customer Owner Notify' => 'Kundeninfo Besitzer',
        'OTRS sends an notification email to the customer if the ticket owner has changed.' => 'OTRS sendet eine Info E-Mail an Kunden beim Ändern des Besitzers.',

        # Template: AdminQueueResponsesChangeForm
        'Responses <-> Queue Management' => 'Antworten <-> Queue Verwaltung',

        # Template: AdminQueueResponsesForm
        'Answer' => 'Antwort',

        # Template: AdminResponseAttachmentChangeForm
        'Responses <-> Attachments Management' => 'Antwort <-> Anlagen Verwaltung',

        # Template: AdminResponseAttachmentForm

        # Template: AdminResponseForm
        'Response Management' => 'Antworten Verwaltung',
        'A response is default text to write faster answer (with default text) to customers.' => 'Eine Antwort ist ein vordefinierter Text, um Kunden schneller antworten zu können.',
        'Don\'t forget to add a new response a queue!' => 'Eine neue Antwort muss einer Queue zugewiesen werden!',
        'The current ticket state is' => 'Der aktuelle Ticket-Status ist',
        'Your email address is new' => 'Deine E-Mail-Adresse ist neu',

        # Template: AdminRoleForm
        'Role Management' => 'Rollen Verwaltung',
        'Add Role' => 'Rolle hinzufügen',
        'Add a new Role.' => 'Eine neue Rolle hinzufügen.',
        'Create a role and put groups in it. Then add the role to the users.' => 'Erstelle eine Rolle und weise Gruppen hinzu. Danach füge Benutzer zu den Rollen hinzu.',
        'It\'s useful for a lot of users and groups.' => 'Es ist sehr nützlich wenn man viele Gruppen und Benutzer hat.',

        # Template: AdminRoleGroupChangeForm
        'Roles <-> Groups Management' => 'Rollen <-> Gruppen Verwaltung',
        'move_into' => 'Verschieben in',
        'Permissions to move tickets into this group/queue.' => 'Rechte, um Tickets in eine Gruppe/Queue zu verschieben.',
        'create' => 'Erstellen',
        'Permissions to create tickets in this group/queue.' => 'Rechte, um in einer Gruppe/Queue Tickets zu erstellen.',
        'owner' => 'Besitzer',
        'Permissions to change the ticket owner in this group/queue.' => 'Rechte, um den Besitzer eines Ticket in einer Gruppe/Queue zu ändern.',
        'priority' => 'Priorität',
        'Permissions to change the ticket priority in this group/queue.' => 'Rechte, um die Priorität eines Tickets in einer Gruppe/Queue zu ändern.',

        # Template: AdminRoleGroupForm
        'Role' => 'Rolle',

        # Template: AdminRoleUserChangeForm
        'Roles <-> Users Management' => 'Rollen <-> Benutzer Verwaltung',
        'Select the role:user relations.' => 'Auswahl der Rollen:Benutzer Beziehungen.',

        # Template: AdminRoleUserForm

        # Template: AdminSalutationForm
        'Salutation Management' => 'Anreden Verwaltung',
        'Add Salutation' => 'Anrede hinzufügen',
        'Add a new Salutation.' => 'Eine neue Anrede hinzufügen.',

        # Template: AdminSecureMode
        'Secure Mode need to be enabled!' => 'Secure Mode muss aktiviert werden!',
        'Secure mode will (normally) be set after the initial installation is completed.' => '',
        'Secure mode must be disabled in order to reinstall using the web-installer.' => '',
        'If Secure Mode is not activated, activate it via SysConfig because your application is already running.' => '',

        # Template: AdminSelectBoxForm
        'SQL Box' => 'SQL Box',
        'Go' => 'Go',
        'Select Box Result' => 'Select Box Ergebnis',

        # Template: AdminService
        'Service Management' => 'Service Verwaltung',
        'Add Service' => 'Service hinzufügen',
        'Add a new Service.' => 'Einen neuen Service hinzufügen.',
        'Sub-Service of' => 'Unterservice von',

        # Template: AdminSession
        'Session Management' => 'Sitzungsverwaltung',
        'Sessions' => 'Sitzung',
        'Uniq' => 'Uniq',
        'Kill all sessions' => 'Löschen aller Sessions',
        'Session' => 'Session',
        'Content' => 'Inhalt',
        'kill session' => 'Sitzung löschen',

        # Template: AdminSignatureForm
        'Signature Management' => 'Signatur Verwaltung',
        'Add Signature' => 'Signatur hinzufügen',
        'Add a new Signature.' => 'Eine neue Signatur hinzufügen.',

        # Template: AdminSLA
        'SLA Management' => 'SLA Verwaltung',
        'Add SLA' => 'SLA hinzufügen',
        'Add a new SLA.' => 'Einen neuen SLA hinzufügen.',

        # Template: AdminSMIMEForm
        'S/MIME Management' => 'S/MIME Verwaltung',
        'Add Certificate' => 'Zertifikat hinzufügen',
        'Add Private Key' => 'Privaten Schlüssel hinzufügen',
        'Secret' => 'Secret',
        'Hash' => 'Hash',
        'In this way you can directly edit the certification and private keys in file system.' => 'Über diesen Weg können die Zertifikate und privaten Schlüssel im Dateisystem bearbeitet werden.',

        # Template: AdminStateForm
        'State Management' => 'Status Verwaltung',
        'Add State' => 'Status hinzufügen',
        'Add a new State.' => 'Einen neuen Status hinzufügen.',
        'State Type' => 'Status-Typ',
        'Take care that you also updated the default states in you Kernel/Config.pm!' => 'Beachte, dass auch der default-Status in Kernel/Config.pm geändert werden muss!',
        'See also' => 'Siehe auch',

        # Template: AdminSysConfig
        'SysConfig' => 'SysConfig',
        'Group selection' => 'Gruppenauswahl',
        'Show' => 'Zeigen',
        'Download Settings' => 'Einstellungen herunterladen',
        'Download all system config changes.' => 'Herunterladen aller Änderungen der Konfiguration.',
        'Load Settings' => 'Einstellungen hinaufladen',
        'Subgroup' => 'Untergruppe',
        'Elements' => 'Elemente',

        # Template: AdminSysConfigEdit
        'Config Options' => 'Config Einstellungen',
        'Default' => 'Default',
        'New' => 'Neu',
        'New Group' => 'Neue Gruppe',
        'Group Ro' => 'Gruppe Ro',
        'New Group Ro' => 'Neue Gruppe Ro',
        'NavBarName' => 'NavBarName',
        'NavBar' => 'NavBar',
        'Image' => 'Image',
        'Prio' => 'Prio',
        'Block' => 'Block',
        'AccessKey' => 'AccessKey',

        # Template: AdminSystemAddressForm
        'System Email Addresses Management' => 'E-Mail-Adressen Verwaltung',
        'Add System Address' => 'System Adresse hinzufügen',
        'Add a new System Address.' => 'Eine neue Systemadresse hinzufügen.',
        'Realname' => 'Tatsächlicher Name',
        'All email addresses get excluded on replaying on composing an email.' => 'Alle Email-Adressen werden beim Erstellen einer Antwort exkludiert.',
        'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!' => 'Alle eingehenden E-Mails mit diesem Empfänger (To:) werden in die ausgewählte Queue einsortiert.',

        # Template: AdminTypeForm
        'Type Management' => 'Typ Verwaltung',
        'Add Type' => 'Typ hinzufügen',
        'Add a new Type.' => 'Einen neuen Typ hinzufügen.',

        # Template: AdminUserForm
        'User Management' => 'Benutzer Verwaltung',
        'Add User' => 'Benutzer hinzufügen',
        'Add a new Agent.' => 'Einen neuen Agenten hinzufügen.',
        'Login as' => 'Anmelden als',
        'Firstname' => 'Vorname',
        'Lastname' => 'Nachname',
        'Start' => 'Start',
        'End' => 'Ende',
        'User will be needed to handle tickets.' => 'Benutzer werden benötigt, um Tickets zu bearbeiten.',
        'Don\'t forget to add a new user to groups and/or roles!' => 'Ein neuer Benutzer muss einer Gruppe und/oder Rollen zugewiesen werden!',

        # Template: AdminUserGroupChangeForm
        'Users <-> Groups Management' => 'Benutzer <-> Gruppen Verwaltung',

        # Template: AdminUserGroupForm

        # Template: AgentBook
        'Address Book' => 'Adressbuch',
        'Return to the compose screen' => 'Zurück zum Verfassen-Fenster',
        'Discard all changes and return to the compose screen' => 'Alle Änderungen verwerfen und zurück zum Verfassen-Fenster',

        # Template: AgentCalendarSmall

        # Template: AgentCalendarSmallIcon

        # Template: AgentCustomerSearch

        # Template: AgentCustomerTableView

        # Template: AgentDashboard
        'Dashboard' => 'Dashboard',

        # Template: AgentDashboardCalendarOverview
        'in' => 'in',

        # Template: AgentDashboardImage

        # Template: AgentDashboardProductNotify
        '%s %s is available!' => '%s %s ist nun verfügbar!',
        'Please update now.' => 'Bitte nun aktuallisieren.',
        'Release Note' => 'Versionsbeschreibung',
        'Level' => 'Level',

        # Template: AgentDashboardRSSOverview
        'Posted %s ago.' => 'Veröffentlicht vor %s.',

        # Template: AgentDashboardTicketOverview

        # Template: AgentDashboardTicketStats

        # Template: AgentInfo
        'Info' => 'Info',

        # Template: AgentLinkObject
        'Link Object: %s' => 'Verknüpfung erstellen: %s',
        'Object' => 'Objekt',
        'Link Object' => 'Verknüpfe Objekt',
        'with' => 'mit',
        'Select' => 'Auswahl',
        'Unlink Object: %s' => 'Verknüpfung aufheben: %s',

        # Template: AgentLookup
        'Lookup' => 'Lookup',

        # Template: AgentNavigationBar

        # Template: AgentPreferencesForm

        # Template: AgentSpelling
        'Spell Checker' => 'Rechtschreibprüfung',
        'spelling error(s)' => 'Rechtschreibfehler',
        'or' => 'oder',
        'Apply these changes' => 'Änderungen übernehmen',

        # Template: AgentStatsDelete
        'Do you really want to delete this Object?' => 'Soll das Objekt wirklich gelöscht werden?',

        # Template: AgentStatsEditRestrictions
        'Select the restrictions to characterise the stat' => 'Auswahl der Einschränkungen zur Charaktarisierung der Statistik',
        'Fixed' => 'Fixiert',
        'Please select only one element or turn off the button \'Fixed\'.' => 'Bitte wählen Sie nur ein Attribut aus oder entfernen Sie das Häkchen der Checkbox \'Fixiert\'!',
        'Absolut Period' => 'Absoluter Zeitraum',
        'Between' => 'Zwischen',
        'Relative Period' => 'Relativer Zeitraum',
        'The last' => 'Die letzten',
        'Finish' => 'Abschließen',
        'Here you can make restrictions to your stat.' => 'Dieses Formular wird dazu verwendet die Einschränkungen für die Statistik zu definieren.',
        'If you remove the hook in the "Fixed" checkbox, the agent generating the stat can change the attributes of the corresponding element.' => 'Wenn Sie den Haken in der "Fixiert" Checkbox entfernen, kann der Agent der die Statistik erstellt, die Attribute des entsprechenden Elements verändern.',

        # Template: AgentStatsEditSpecification
        'Insert of the common specifications' => 'Eingabe der allgemeinen Angaben',
        'Permissions' => 'Rechtevergabe',
        'Format' => 'Format',
        'Graphsize' => 'Graphikgröße',
        'Sum rows' => 'Zeilensummierung',
        'Sum columns' => 'Spaltensummierung',
        'Cache' => 'Cache',
        'Required Field' => 'Pflichtfeld',
        'Selection needed' => 'Auswahl nötig',
        'Explanation' => 'Erklärung',
        'In this form you can select the basic specifications.' => 'Diese Eingabeoberfläche ist für die Eingabe der allgemeinen Angaben.',
        'Attribute' => 'Attribut',
        'Title of the stat.' => 'Titel der Statistik.',
        'Here you can insert a description of the stat.' => 'An dieser Stelle muß die Beschreibung eingegeben werden.',
        'Dynamic-Object' => 'Dynamisches Objekt',
        'Here you can select the dynamic object you want to use.' => 'Hier kann das zu benutzende dynamische Objekt ausgewählt werden.',
        '(Note: It depends on your installation how many dynamic objects you can use)' => '(Anmerkung: Es ist installationsabhängig wieviele dynamische Objekte angezeigt werden)',
        'Static-File' => 'Statische Datei',
        'For very complex stats it is possible to include a hardcoded file.' => 'Bei sehr komplexen Statistiken ist es möglich Programmdateien zu integrieren.',
        'If a new hardcoded file is available this attribute will be shown and you can select one.' => 'Sind neue Programmdateien verfügbar, werden diese angezeigt.',
        'Permission settings. You can select one or more groups to make the configurated stat visible for different agents.' => 'Rechtevergabe: Sie können eine oder mehrere Gruppen auswählen, um die Statistiken für die entsprechenden Agents sichtbar zu machen.',
        'Multiple selection of the output format.' => 'Auswahl der möglichen Ausgabeformate.',
        'If you use a graph as output format you have to select at least one graph size.' => 'Wenn Sie als Ausgabeformat eine Graphik ausgewählt haben, müssen Sie hier die Graphikgröße auswählen.',
        'If you need the sum of every row select yes' => 'Wenn die eine Summierung der Reihen benötigen, wählen Sie bitte \'Yes\'.',
        'If you need the sum of every column select yes.' => 'Wenn Sie eine Summierung der Spalten benötigen, wählen Sie bitte \'Yes\'.',
        'Most of the stats can be cached. This will speed up the presentation of this stat.' => 'Die meisten der Statistiken können gecached werden. Diese beschleunigt das wiederholte aufrufen einer Statistik.',
        '(Note: Useful for big databases and low performance server)' => '(Anmerkung: Dies ist sinnvoll für große Datenbanken und langsame Server)',
        'With an invalid stat it isn\'t feasible to generate a stat.' => 'Durch das Setzen einer Statistik auf \'ungültig\', kann man es für die Benutzung sperren.',
        'This is useful if you want that no one can get the result of the stat or the stat isn\'t ready configurated.' => 'Dies ist sinnvoll, wenn man nicht will, dass diese Statistik aktuell genutzt wird oder die Statistik noch nicht fertig konfiguriert ist.',

        # Template: AgentStatsEditValueSeries
        'Select the elements for the value series' => 'Auswahl der Elemente für die Wertereihen',
        'Scale' => 'Skalierung',
        'minimal' => 'minimal',
        'Please remember, that the scale for value series has to be larger than the scale for the X-axis (e.g. X-Axis => Month, ValueSeries => Year).' => 'Bitte bedenken Sie, dass die Zeitskalierung für die Wertereihen größer sein muss als für die X-Achse (z. B. X-Achse => Monat; Wertereihe => Jahr).',
        'Here you can define the value series. You have the possibility to select one or two elements. Then you can select the attributes of elements. Each attribute will be shown as single value series. If you don\'t select any attribute all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' => 'Auf dieser Seite werden die Wertereihen festgelegt. Jedes Attribut wird als einzelne Wertereihe dargestellt. Wenn Sie keine Attribute auswählen werden alle Attribute bei der Generierung einer Statistik verwendet. Auch, wenn ein neues Attribut nach der Statistikkonfiguration hinzugefügt wird.',

        # Template: AgentStatsEditXaxis
        'Select the element, which will be used at the X-axis' => 'Auswahl des Elements, welches für die X-Achse genutzt wird.',
        'maximal period' => 'maximaler Zeitraum',
        'minimal scale' => 'minimale Skalierung',
        'Here you can define the x-axis. You can select one element via the radio button. If you make no selection all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' => 'Auf dieser Seite wird die X-Achse definert. Sie können ein Element per Optionsfeld auswählen. Wenn Sie keine Attribute des Elements auswählen werden alle Attribute verwendet. Auch solche die nach der Konfiguration der Statistik erst hinzukommen.',

        # Template: AgentStatsImport
        'Import' => 'Import',
        'File is not a Stats config' => 'Diese Datei ist keine Statistik-Konfiguration',
        'No File selected' => 'Keine Datei ausgewählt',

        # Template: AgentStatsOverview
        'Results' => 'Ergebnis',
        'Total hits' => 'Treffer gesamt',
        'Page' => 'Seite',

        # Template: AgentStatsPrint
        'Print' => 'Drucken',
        'No Element selected.' => 'Kein Element ausgewählt.',

        # Template: AgentStatsView
        'Export Config' => 'Konfiguration exportieren',
        'Information about the Stat' => 'Informationen über die Statistik',
        'Exchange Axis' => 'Achsen vertauschen',
        'Configurable params of static stat' => 'Konfigurierbare Parameter der statischen Statistik',
        'No element selected.' => 'Es wurde kein Element ausgewählt.',
        'maximal period from' => 'maximaler Zeitraum von',
        'to' => 'bis',
        'With the input and select fields you can configurate the stat at your needs. Which elements of a stat you can edit depends on your stats administrator who configurated the stat.' => 'Mit Hilfe der Auswahl- und Eingabefelder kann die Statistik Ihren Bedürfnissen angepasst werden. Welche Elemente der Statistik Sie verändern dürfen ist von der Vorkonfiguration der Statistik abhängig.',

        # Template: AgentTicketBounce
        'A message should have a To: recipient!' => 'Eine Nachricht sollte einen Empfänger im Feld An: haben!',
        'You need a email address (e. g. customer@example.com) in To:!' => 'Im Feld An: wird eine E-Mail-Adresse (z. B. kunde@example.com) benötigt!',
        'Bounce ticket' => 'Bounce Ticket',
        'Ticket locked!' => 'Ticket gesperrt!',
        'Ticket unlock!' => 'Ticket freigeben!',
        'Bounce to' => 'Bounce an',
        'Next ticket state' => 'Nächster Status des Tickets',
        'Inform sender' => 'Sender informieren',
        'Send mail!' => 'Mail senden!',

        # Template: AgentTicketBulk
        'You need to account time!' => 'Zeit muss berechnet werden!',
        'Ticket Bulk Action' => 'Ticket Sammelaktion',
        'Spell Check' => 'Rechtschreibprüfung',
        'Note type' => 'Notiztyp',
        'Next state' => 'Nächster Status',
        'Pending date' => 'Warten bis',
        'Merge to' => 'Zusammenfassen zu',
        'Merge to oldest' => 'Zusammenfassen zu ältesten',
        'Link together' => 'Zusammen verlinken',
        'Link to Parent' => 'Verlinken mit ältesten',
        'Unlock Tickets' => 'Freigeben der Tickets',

        # Template: AgentTicketClose
        'Ticket Type is required!' => 'Das Feld Ticket-Typ ist ein Pflichtfeld!',
        'A required field is:' => 'Bitte füllen Sie das Pflichtfeld aus:',
        'Close ticket' => 'Ticket schließen',
        'Previous Owner' => 'Vorheriger Besitzer',
        'Inform Agent' => 'Agenten informieren',
        'Optional' => 'Optional',
        'Inform involved Agents' => 'Involvierte Agenten informieren',
        'Attach' => 'Anhängen',

        # Template: AgentTicketCompose
        'A message must be spell checked!' => 'Eine Nachricht muss auf Rechtschreibung überprüft werden!',
        'Compose answer for ticket' => 'Antwort erstellen für',
        'Pending Date' => 'Warten bis',
        'for pending* states' => 'für warten* Status',

        # Template: AgentTicketCustomer
        'Change customer of ticket' => 'Ändern des Kunden des Tickets',
        'Set customer user and customer id of a ticket' => 'Kundenbenutzer und Kundennummer des Tickets auswählen',
        'Customer User' => 'Kunden-Benutzer',
        'Search Customer' => 'Kunden suchen',
        'Customer Data' => 'Kunden-Daten',
        'Customer history' => 'Kunden-Historie',
        'All customer tickets.' => 'Alle Tickets des Kunden.',

        # Template: AgentTicketEmail
        'Compose Email' => 'E-Mail erstellen',
        'new ticket' => 'Neues Ticket',
        'Refresh' => 'Aktualisieren',
        'Clear To' => 'An: löschen',
        'All Agents' => 'Alle Agenten',

        # Template: AgentTicketEscalation

        # Template: AgentTicketForward
        'Article type' => 'Artikeltyp',

        # Template: AgentTicketFreeText
        'Change free text of ticket' => 'Ändern der Freifelder des Tickets',

        # Template: AgentTicketHistory
        'History of' => 'Historie von',

        # Template: AgentTicketLocked

        # Template: AgentTicketMerge
        'You need to use a ticket number!' => 'Bitte Ticket-Nummer benutzen!',
        'Ticket Merge' => 'Ticket zusammenfassen',

        # Template: AgentTicketMove
        'Move Ticket' => 'Ticket Verschieben',

        # Template: AgentTicketNote
        'Add note to ticket' => 'Notiz an Ticket hängen',

        # Template: AgentTicketOverviewMedium
        'First Response Time' => 'Reaktionszeit',
        'Service Time' => 'Service Zeit',
        'Update Time' => 'Aktualisierungszeit',
        'Solution Time' => 'Lösungszeit',

        # Template: AgentTicketOverviewMediumMeta
        'You need min. one selected Ticket!' => 'Benötigt min. ein ausgewähltes Ticket!',

        # Template: AgentTicketOverviewNavBar
        'Filter' => 'Filter',
        'Change search options' => 'Such-Optionen ändern',
        'Tickets' => 'Tickets',
        'of' => 'von',

        # Template: AgentTicketOverviewNavBarSmall

        # Template: AgentTicketOverviewPreview
        'Compose Answer' => 'Antwort erstellen',
        'Contact customer' => 'Kunden kontaktieren',
        'Change queue' => 'Queue wechseln',

        # Template: AgentTicketOverviewPreviewMeta

        # Template: AgentTicketOverviewSmall
        'sort upward' => 'aufwärts sortieren',
        'up' => 'aufwärts',
        'sort downward' => 'abwärts sortieren',
        'down' => 'abwärts',
        'Escalation in' => 'Eskalation in',
        'Locked' => 'Sperre',

        # Template: AgentTicketOwner
        'Change owner of ticket' => 'Ticket-Besitzer ändern',

        # Template: AgentTicketPending
        'Set Pending' => 'Setze wartend',

        # Template: AgentTicketPhone
        'Phone call' => 'Anruf',
        'Clear From' => 'Von: löschen',

        # Template: AgentTicketPhoneOutbound

        # Template: AgentTicketPlain
        'Plain' => 'Klar',

        # Template: AgentTicketPrint
        'Ticket-Info' => 'Ticket-Info',
        'Accounted time' => 'Zugewiesene Zeit',
        'Linked-Object' => 'Verknüpfte-Objekte',
        'by' => 'von',

        # Template: AgentTicketPriority
        'Change priority of ticket' => 'Priorität des Tickets ändern',

        # Template: AgentTicketQueue
        'Tickets shown' => 'Tickets angezeigt',
        'Tickets available' => 'Tickets verfügbar',
        'All tickets' => 'Alle Tickets',
        'Queues' => 'Queues',
        'Ticket escalation!' => 'Ticket-Eskalation!',

        # Template: AgentTicketResponsible
        'Change responsible of ticket' => 'Verantwortlichen des Tickets ändern',

        # Template: AgentTicketSearch
        'Ticket Search' => 'Ticket-Suche',
        'Profile' => 'Profil',
        'Search-Template' => 'Such-Vorlage',
        'TicketFreeText' => 'TicketFreeText',
        'Created in Queue' => 'Erstellt in Queue',
        'Article Create Times' => 'Artikel Erstell-Zeiten',
        'Article created' => 'Artikel erstellt',
        'Article created between' => 'Artikel erstellt zwischen',
        'Change Times' => 'Änderungs-Zeiten',
        'No change time settings.' => 'Keine Änderungs-Zeiten',
        'Ticket changed' => 'Ticket geändert',
        'Ticket changed between' => 'Ticket geändert zwischen',
        'Result Form' => 'Ergebnis-Ansicht',
        'Save Search-Profile as Template?' => 'Speichere Such-Profil als Vorlage?',
        'Yes, save it with name' => 'Ja, speichere unter dem Namen',

        # Template: AgentTicketSearchOpenSearchDescriptionFulltext
        'Fulltext' => 'Volltext',

        # Template: AgentTicketSearchOpenSearchDescriptionTicketNumber

        # Template: AgentTicketSearchResultPrint

        # Template: AgentTicketZoom
        'Expand View' => 'Ausgeklappte Ansicht',
        'Collapse View' => 'Zugeklappte Ansicht',
        'Split' => 'Teilen',

        # Template: AgentTicketZoomArticleFilterDialog
        'Article filter settings' => 'Artikel-Filter Einstellungen',
        'Save filter settings as default' => 'Filter-Einstellungen als Standard speichern',

        # Template: AgentWindowTab

        # Template: AJAX

        # Template: Copyright

        # Template: CustomerAccept

        # Template: CustomerCalendarSmallIcon

        # Template: CustomerError
        'Traceback' => 'Traceback',

        # Template: CustomerFooter
        'Powered by' => 'Powered by',

        # Template: CustomerFooterSmall

        # Template: CustomerHeader

        # Template: CustomerHeaderSmall

        # Template: CustomerLogin
        'Login' => 'Login',
        'Lost your password?' => 'Passwort verloren?',
        'Request new password' => 'Neues Passwort beantragen',
        'Create Account' => 'Zugang erstellen',

        # Template: CustomerNavigationBar
        'Welcome %s' => 'Willkommen %s',

        # Template: CustomerPreferencesForm

        # Template: CustomerStatusView

        # Template: CustomerTicketMessage

        # Template: CustomerTicketPrint

        # Template: CustomerTicketSearch
        'Times' => 'Zeiten',
        'No time settings.' => 'Keine Zeit-Einstellungen.',

        # Template: CustomerTicketSearchOpenSearchDescription

        # Template: CustomerTicketSearchResultCSV

        # Template: CustomerTicketSearchResultPrint

        # Template: CustomerTicketSearchResultShort

        # Template: CustomerTicketZoom

        # Template: CustomerWarning

        # Template: Error
        'Click here to report a bug!' => 'Klicken Sie hier, um einen Fehler zu berichten!',

        # Template: Footer
        'Top of Page' => 'Seitenanfang',

        # Template: FooterSmall

        # Template: Header
        'Home' => 'Home',

        # Template: HeaderSmall

        # Template: Installer
        'Web-Installer' => 'Web-Installer',
        'Welcome to %s' => 'Willkommen zu %s',
        'Accept license' => 'Lizenz akzeptieren',
        'Don\'t accept license' => 'Lizenz _nicht_ akzeptieren',
        'Admin-User' => 'Admin-Benutzer',
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty. For security reasons we do recommend setting a root password. For more information please refer to your database documentation.' => 'Falls ein Root-Passwort für die Datenbank gesetzt ist, muss es hier eingegeben werden. Ist kein Passwort gesetzt, muss das Feld leer gelassen werden. Aus Sicherheitsgründen empfehlen wir ein Root-Passwort zu setzt. Weitere Informationen hierzu finden Sie in der Dokumentation Ihrer Datenbank.',
        'Admin-Password' => 'Admin-Passwort',
        'Database-User' => 'Datenbank-Benutzer',
        'default \'hot\'' => 'voreingestellt \'hot\'',
        'DB connect host' => 'DB Verbindungs-Host',
        'Database' => 'Datenbank',
        'Default Charset' => 'Standard-Zeichensatz',
        'utf8' => 'utf8',
        'false' => 'false',
        'SystemID' => 'SystemID',
        '(The identify of the system. Each ticket number and each http session id starts with this number)' => '(Das Kennzeichnen des Systems. Jede Ticketnummer und http-Sitzung beginnt mit dieser Kennung)',
        'System FQDN' => 'System FQDN',
        '(Full qualified domain name of your system)' => '(Voll qualifizierter Domain-Name des Systems)',
        'AdminEmail' => 'AdminE-Mail',
        '(Email of the system admin)' => '(E-Mail des System-Administrators)',
        'Organization' => 'Organisation',
        'Log' => 'Log',
        'LogModule' => 'LogModule',
        '(Used log backend)' => '(Benutztes Log Backend)',
        'Logfile' => 'Logdatei',
        '(Logfile just needed for File-LogModule!)' => '(Logfile nur benötigt für File-LogModule!)',
        'Webfrontend' => 'Web-Oberfläche',
        'Use utf-8 it your database supports it!' => 'Benutzen Sie utf-8 nur, wenn Ihre Datenbank es unterstützt!',
        'Default Language' => 'Standard-Sprache',
        '(Used default language)' => '(Standardwert für die Sprache)',
        'CheckMXRecord' => 'CheckMXRecord',
        '(Checks MX recordes of used email addresses by composing an answer. Don\'t use CheckMXRecord if your OTRS machine is behinde a dial-up line $!)' => '(Überprüfen des MX-Eintrags der benutzen E-Mail-Adressen im Verfassen-Fenster. Benutzen Sie CheckMXRecord nicht, wenn Ihr OTRS hinter einer Wählleitung ist!)',
        'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' => 'Um OTRS nutzen zu können, müssen die die folgenden Zeilen als root in die Befehlszeile (Terminal/Shell) eingeben.',
        'Restart your webserver' => 'Starte Deinen Webserver neu.',
        'After doing so your OTRS is up and running.' => 'Danach läuft Dein OTRS.',
        'Start page' => 'Startseite',
        'Your OTRS Team' => 'Dein OTRS-Team',

        # Template: LinkObject

        # Template: Login

        # Template: Motd

        # Template: NoPermission
        'No Permission' => 'Keine Berechtigung',

        # Template: Notify
        'Important' => 'Wichtig',

        # Template: PrintFooter
        'URL' => 'URL',

        # Template: PrintHeader
        'printed by' => 'gedruckt von',

        # Template: PublicDefault

        # Template: Redirect

        # Template: Test
        'OTRS Test Page' => 'OTRS Testseite',
        'Counter' => 'Zähler',

        # Template: Warning

        # Template: YUI

        # Misc
        'Create Database' => 'Datenbank erstellen',
        'verified' => 'verifiziert',
        'File-Name' => 'Datei-Dateiname',
        'Ticket Number Generator' => 'Ticketnummer Generator',
        '(Ticket identifier. Some people want toset this to e. g. \'Ticket#\', \'Call#\' or \'MyTicket#\')' => '(Ticket Kennzeichnen. Z.B. \'Ticket#\', \'Call#\' oder \'MyTicket#\')',
        'In this way you can directly edit the keyring configured in Kernel/Config.pm.' => 'Auf diesem Wege können Sie den Keyring in Kernel/Config.pm direkt verändern',
        'Create new Phone Ticket' => 'Neues Telefon-Ticket erstellen',
        'U' => 'U',
        'Site' => 'Seite',
        'Customer history search (e. g. "ID342425").' => 'Kunden-Historie-Suche (z. B. "ID342425").',
        'Can not delete link with %s!' => 'Link zu %s konnte nicht gelöscht werden!',
        'Close!' => 'Schließen!',
        'for agent firstname' => 'für Vorname des Agents',
        'Reporter' => 'Melder',
        'Process-Path' => 'Prozess-Path',
        'to get the realname of the sender (if given)' => 'Um den Realnamen des Senders zu erhalten (wenn möglich)',
        'FAQ Search Result' => 'FAQ Suchergebnis',
        'Notification (Customer)' => 'Benachrichtigung (Kunde)',
        'CSV' => 'CSV',
        'Select Source (for add)' => 'Quelle auswählen (zum Hinzufügen)',
        'Node-Name' => 'Node-Name',
        'Options of the ticket data (e. g. &lt;OTRS_TICKET_Number&gt;, &lt;OTRS_TICKET_ID&gt;, &lt;OTRS_TICKET_Queue&gt;, &lt;OTRS_TICKET_State&gt;)' => 'EInstellungen der Ticketdaten (z. B. &lt;OTRS_TICKET_Number&gt;, &lt;OTRS_TICKET_ID&gt;, &lt;OTRS_TICKET_Queue&gt;, &lt;OTRS_TICKET_State&gt;)',
        'Child-Object' => 'Kinder-Objekte',
        'Workflow Groups' => 'Workflow Gruppen',
        'Current Impact Rating' => 'aktuelles Schadenspotential',
        'Config options (e. g. <OTRS_CONFIG_HttpType>)' => 'Konfig Optionen (z. B. <OTRS_CONFIG_HttpType>)',
        'FAQ System History' => 'FAQ System Historie',
        'customer realname' => 'Wirklicher Kundenname',
        'Pending messages' => 'Wartende Nachrichten',
        'Modules' => 'Module',
        'for agent login' => 'für Agent Login',
        'Keyword' => 'Schlüsselwort',
        'Reference' => 'Referenz(en)',
        'Close type' => 'Art des Schließens',
        'DB Admin User' => 'DB Admin Benutzer',
        'for agent user id' => 'für Agent UserID',
        'Classification' => 'Klassifizierung',
        'Change user <-> group settings' => 'Ändern der Benutzer <-> Gruppen Einstellungen',
        'Escalation' => 'Eskalation',
        'Order' => 'Sortierung',
        'next step' => 'Nächster Schritt',
        'Follow up' => 'Nachfrage',
        'Customer history search' => 'Kunden-Historie-Suche',
        'not verified' => 'nicht verifiziert',
        'Stat#' => 'Statistik Nr.',
        'Create new database' => 'Neue Datenbank erstellen',
        'Year' => 'Jahr',
        'X-axis' => 'X-Achse',
        'Keywords' => 'Schlüsselwörter',
        'Ticket Escalation View' => 'Ticket Eskalations Ansicht',
        'Today' => 'Heute',
        'No * possible!' => 'Kein "*" möglich!',
        'Load' => 'Laden',
        'Change Time' => 'Geändert',
        'Options of the current user who requested this action (e. g. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)' => 'Einstellungen für den Benutzer, der diese Aktion ausgelöst hat (z. B. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)',
        'Message for new Owner' => 'Nachricht an neuen Besitzer',
        'to get the first 5 lines of the email' => 'Um die ersten 5 Zeilen der E-Mail zu erhalten',
        'Sent new password to: ' => 'Das neue Passwort wurde gesendet an: ',
        'Sort by' => 'Sortieren nach',
        'OTRS DB Password' => 'OTRS DB Passwort',
        'Last update' => 'Letzte Änderungen',
        'Tomorrow' => 'Morgen',
        'not rated' => 'nicht bewertet',
        'to get the first 20 character of the subject' => 'Um die ersten 20 Zeichen des Betreffs zu erhalten',
        'Select the customeruser:service relations.' => 'Auswahl der Kundenbenutzer:Service Beziehungen.',
        'DB Admin Password' => 'DB Admin Passwort',
        'Drop Database' => 'Datenbank löschen',
        'Options of the current customer user data (e. g. <OTRS_CUSTOMER_DATA_UserFirstname>)' => 'Die Daten der Kundenbenutzer (z. B. <OTRS_CUSTOMER_DATA_UserFirstname>)',
        'Pending type' => 'Warten auf',
        'Comment (internal)' => 'Kommentar (intern)',
        'Ticket owner options (e. g. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)' => 'Ticket Besitzer Einstellungen (z. B. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)',
        'User-Number' => 'Benutzer-Nummer',
        'Options of the ticket data (e. g. <OTRS_TICKET_Number>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' => 'Optionen von Ticket Daten (z. B. <OTRS_TICKET_Number>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)',
        '(Used ticket number format)' => '(Benutztes Format für die Ticketnummer)',
        'Reminder' => 'Erinnernd',
        'Month' => 'Monat',
        'Node-Address' => 'Node-Adresse',
        'All Agent variables.' => 'Alle Agentenvariabln',
        ' (work units)' => ' (Arbeitseinheiten)',
        'Next Week' => 'Nächste Woche',
        'You use the DELETE option! Take care, all deleted Tickets are lost!!!' => 'Sie benutzen die LÖSCHEN Option! Bitte bedenken Sie, dass dann diese Tickets verloren sind!',
        'All Customer variables like defined in config option CustomerUser.' => 'Alle Kundenvariablen wie definiert im den Konfigoptionen CustomerUser.',
        'for agent lastname' => 'für Nachname des Agents',
        'Options of the current user who requested this action (e. g. <OTRS_CURRENT_UserFirstname>)' => 'Informationen über den Benutzer, der die Aktion gerade anfragt (z. B. <OTRS_CURRENT_UserFirstname>)',
        'Reminder messages' => 'Nachrichten zur Erinnerung',
        'Parent-Object' => 'Eltern-Objekte',
        'Of couse this feature will take some system performance it self!' => 'Wenn dieses Feature aktiv ist, ist mit Leistungsdefizit zu rechnen.',
        'Your own Ticket' => 'Ihr eigenes Ticket',
        'Detail' => 'Detail',
        'TicketZoom' => 'Ticket Inhalt',
        'Don\'t forget to add a new user to groups!' => 'Ein neuer Benutzer muss einer Gruppe zugewiesen werden!',
        'Open Tickets' => 'Offene Tickets',
        'CreateTicket' => 'Ticket Erstellen',
        'unknown' => 'unbekannt',
        'System Settings' => 'System Einstellungen',
        'Finished' => 'Fertig',
        'Imported' => 'Importiert',
        'unread' => 'ungelesen',
        'D' => 'D',
        'System Status' => 'System Status',
        'All messages' => 'Alle Nachrichten',
        'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' => 'Optionen des Tickets (z. B. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)',
        'Object already linked as %s.' => 'Objekt bereits verlinkt als %s.',
        'A article should have a title!' => 'Ein Artikel sollte einen Titel haben!',
        'Customer Users <-> Services' => 'Kunden Benutzer <-> Services',
        'Config options (e. g. &lt;OTRS_CONFIG_HttpType&gt;)' => 'Einstellungen (z. B.&lt;OTRS_CONFIG_HttpType&gt;)',
        'Compose Follow up' => 'Ergänzung schreiben',
        'Imported by' => 'Importiert von',
        'Ticket owner options (e. g. <OTRS_OWNER_UserFirstname>)' => 'Informationen über den Besitzer des Tickets (z. B. <OTRS_OWNER_UserFirstname>)',
        'read' => 'gelesen',
        'Product' => 'Produkt(e)',
        'kill all sessions' => 'Alle Sitzungen löschen',
        'to get the from line of the email' => 'Um die From: Zeile zu erhalten',
        'Solution' => 'Lösung',
        'QueueView' => 'Queue-Ansicht',
        'My Queue' => 'Meine Queue',
        'Select Box' => 'Select Box',
        'Instance' => 'Instanz',
        'Day' => 'Tag',
        'New messages' => 'Neue Nachrichten',
        'Service-Name' => 'Service-Name',
        'Can not create link with %s!' => 'Link zu %s konnte nicht erstellt werden!',
        'Linked as' => 'Verknüpft als',
        'Welcome to OTRS' => 'Willkommen zu OTRS',
        'tmp_lock' => 'gesperrt (temporär)',
        'modified' => 'geändert',
        'Delete old database' => 'Alte Datenbank löschen',
        'Watcher' => 'Beobachter',
        'Have a lot of fun!' => 'Viel Spaß!',
        'send' => 'Senden',
        'Note Text' => 'Notiztext',
        'POP3 Account Management' => 'POP3-Konten Verwaltung',
        'Options of the current customer user data (e. g. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)' => 'Einstellungen der Benutzerdaten des aktuellen Benutzers ((z. B. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;).',
        'System State Management' => 'Status Verwaltung',
        'Mailbox' => 'Mailbox',
        'PhoneView' => 'Telefon-Ansicht',
        'User-Name' => 'Benutzer-Name',
        'File-Path' => 'Datei-Dateipfad',
        'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further information.' => 'Die E-Mail mit der Ticketnummer "<OTRS_TICKET>" ist an "<OTRS_BOUNCE_TO>" gebounced. Kontaktieren Sie diese Adresse für weitere Nachfragen.',
        'Ticket Status View' => 'Ticket Status Ansicht',
        'Modified' => 'Verändert',
        'Ticket selected for bulk action!' => 'Ticket für Bulk-Aktion Ausgewählt',
    };
    # $$STOP$$
    return;
}

1;
