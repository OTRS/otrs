# --
# Kernel/Language/de.pm - provides de language translation
# Copyright (C) 2002-2003 Martin Edenhofer <martin at otrs.org>
# --
# $Id: de.pm,v 1.31 2004-01-05 16:48:27 bs Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
package Kernel::Language::de;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.31 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub Data {
    my $Self = shift;
    my %Param = @_;
    my %Hash = ();

    # $$START$$
    # Last translation Sun Apr 13 00:56:54 2003 by 

    # possible charsets
    $Self->{Charset} = ['iso-8859-1', 'iso-8859-15', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Jear;)
    $Self->{DateFormat} = '%D.%M.%Y %T';
    $Self->{DateFormatLong} = '%A %D %B %T %Y';
    $Self->{DateInputFormat} = '%D.%M.%Y - %T';

    %Hash = (
    # Template: AAABase
      ' 2 minutes' => ' 2 Minuten',
      ' 5 minutes' => ' 5 Minuten',
      ' 7 minutes' => ' 7 Minuten',
      '10 minutes' => '10 Minuten',
      '15 minutes' => '15 Minuten',
      'AddLink' => 'Link hinzufügen',
      'AdminArea' => 'Admin-Oberfläche',
      'agent' => 'Agent',
      'all' => 'alle',
      'All' => 'Alle',
      'Attention' => 'Achtung',
      'Bug Report' => 'Fehler berichten',
      'Cancel' => 'Abbrechen',
      'change' => 'Ändern',
      'Change' => 'Ändern',
      'change!' => 'Ändern!',
      'click here' => 'hier klicken',
      'Comment' => 'Kommentar',
      'Customer' => 'Kunde',
      'customer' => 'Kunde',
      'Customer Info' => 'Kunden-Info',
      'day' => 'Tag',
      'days' => 'Tage',
      'description' => 'Beschreibung',
      'Description' => 'Beschreibung',
      'Dispatching by email To: field.' => 'Verteilung nach To: Feld.',
      'Dispatching by selected Queue.' => 'Verteilung nach ausgewählter Queue.',
      'Don\'t work with UserID 1 (System account)! Create new users!' => 'Bitte nicht mit UserID 1 (System Account) arbeiten! Erstelle neue Benutzer!',
      'Done' => 'Fertig',
      'end' => 'runter',
      'Error' => 'Fehler',
      'Example' => 'Beispiel',
      'Examples' => 'Beispiele',
      'Facility' => 'Einrichtung',
      'Feature not active!' => 'Funktion nicht aktiviert!',
      'go' => 'Start',
      'go!' => 'Start!',
      'Group' => 'Gruppe',
      'Hit' => 'Treffer',
      'Hits' => 'Treffer',
      'hour' => 'Stunde',
      'hours' => 'Stunden',
      'Ignore' => 'Ignorieren',
      'invalid' => 'ungültig',
      'Invalid SessionID!' => 'Ungültige SessionID!',
      'Language' => 'Sprache',
      'Languages' => 'Sprachen',
      'Line' => 'Zeile',
      'Lite' => 'Einfach',
      'Login failed! Your username or password was entered incorrectly.' => 'Anmeldung fehlgeschlagen! Benutzername oder Passwort falsch.',
      'Logout successful. Thank you for using OTRS!' => 'Abmeldung erfolgreich! Danke für die Benutzung von OTRS!',
      'Message' => 'Nachricht',
      'minute' => 'Minute',
      'minutes' => 'Minuten',
      'Module' => 'Modul',
      'Modulefile' => 'Moduldatei',
      'Name' => 'Name',
      'New message' => 'Neue Nachricht',
      'New message!' => 'Neue Nachricht!',
      'No' => 'Nein',
      'no' => 'kein',
      'No entry found!' => 'Kein Eintrag gefunden!',
      'No suggestions' => 'Keine Vorschläge',
      'none' => 'keine',
      'none - answered' => 'keine - beantwortet',
      'none!' => 'keine Angabe!',
      'Off' => 'Aus',
      'off' => 'aus',
      'On' => 'Ein',
      'on' => 'ein',
      'Password' => 'Passwort',
      'Pending till' => 'Warten bis',
      'Please answer this ticket(s) to get back to the normal queue view!' => 'Bitte beantworten Sie dieses Ticket, um in die normale Queue-Ansicht zurück zu kommen!',
      'Please contact your admin' => 'Bitte kontaktieren Sie Ihren Administrator',
      'please do not edit!' => 'Bitte nicht ändern!',
      'possible' => 'möglich',
      'QueueView' => 'Queue-Ansicht',
      'reject' => 'ablehnen',
      'replace with' => 'ersetzen mit',
      'Reset' => 'Rücksetzen',
      'Salutation' => 'Anrede',
      'Session has timed out. Please log in again.' => 'Session Zeitüberschreitung. Bitte neu anmelden.',
      'Signature' => 'Signatur',
      'Sorry' => 'Bedauere',
      'Stats' => 'Statistik',
      'Subfunction' => 'Unterfunktion',
      'submit' => 'Übermitteln',
      'submit!' => 'Übermitteln!',
      'system' => 'System',
      'Take this User' => 'Benutzer übernehmen',
      'Text' => '',
      'The recommended charset for your language is %s!' => 'Der empfohlene Zeichenset für Ihre Sprache ist %s!',
      'Theme' => 'Schema',
      'There is no account with that login name.' => 'Es existiert kein Benutzerkonto mit diesem Namen.',
      'Timeover' => 'Zeitüberschreitung',
      'top' => 'hoch',
      'update' => 'Aktualisieren',
      'update!' => 'Aktualisieren!',
      'User' => 'Benutzer',
      'Username' => 'Benutzername',
      'Valid' => 'Gültig',
      'Warning' => 'Warnung',
      'Welcome to OTRS' => 'Willkommen zu OTRS',
      'Word' => 'Wort',
      'wrote' => 'schrieb',
      'yes' => 'ja',
      'Yes' => 'Ja',
      'Please go away!' => 'Bitte zurück gehen!',
      'You got new message!' => 'Sie haben eine neue Nachricht bekommen!',
      'You have %s new message(s)!' => 'Sie haben %s neue Nachricht(en) bekommen!',
      'You have %s reminder ticket(s)!' => 'Sie haben %s Erinnerungs-Ticket(s)!',

    # Template: AAAMonth
      'Apr' => '',
      'Aug' => '',
      'Dec' => 'Dez',
      'Feb' => '',
      'Jan' => '',
      'Jul' => '',
      'Jun' => '',
      'Mar' => 'Mär',
      'May' => 'Mai',
      'Nov' => '',
      'Oct' => 'Okt',
      'Sep' => '',

    # Template: AAAPreferences
      'Closed Tickets' => 'Geschlossene Tickets',
      'Custom Queue' => 'Bevorzugte Queue',
      'Follow up notification' => 'Mitteilung bei Nachfragen',
      'Frontend' => 'Oberfläche',
      'Mail Management' => '',
      'Move notification' => 'Mitteilung bei Queue-Wechsel',
      'New ticket notification' => 'Mitteilung bei neuem Ticket',
      'Other Options' => 'Andere Optionen',
      'Preferences updated successfully!' => 'Benutzereinstellungen erfolgreich aktualisiert!',
      'QueueView refresh time' => 'Queue-Ansicht Aktualisierungszeit',
      'Select your default spelling dictionary.' => 'Standard Rechtschreib-Wörterbuch auswählen.',
      'Select your frontend Charset.' => 'Zeichensatz für Darstellung auswählen.',
      'Select your frontend language.' => 'Oberflächen-Sprache auswählen.',
      'Select your frontend QueueView.' => 'Queue-Ansicht auswählen.',
      'Select your frontend Theme.' => 'Anzeigeschema auswählen.',
      'Select your QueueView refresh time.' => 'Queue-Ansicht Aktualisierungszeit auswählen.',
      'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.' => 'Zusenden einer Mitteilung, wenn ein Kunde eine Nachfrage stellt und ich der Besitzer bin.',
      'Send me a notification if a ticket is moved into a custom queue.' => 'Zusenden einer Mitteilung beim Verschieben eines Tickets in meine bevorzugten Queues.',
      'Send me a notification if a ticket is unlocked by the system.' => 'Zusenden einer Mitteilung, wenn ein Ticket vom System freigegeben (unlocked) wird.',
      'Send me a notification if there is a new ticket in my custom queues.' => 'Zusenden einer Mitteilung bei neuem Ticket in den bevorzugten Queues.',
      'Show closed tickets.' => 'Geschlossene Tickets anzeigen.',
      'Spelling Dictionary' => 'Rechtschreib-Wörterbuch',
      'Ticket lock timeout notification' => 'Mitteilung bei Überschreiten der Sperrzeit',
      'Shown Tickets' => 'Angezeigte Tickets'
      'Max. shown Tickets a page in QueueView.' => 'Maximale Anzahl angezeigter Tickets in der Queue-Ansicht'
      'Screen after new phone ticket' => 'Fenster nach neuem Anruf Ticket'
      'Select your screen after creating a new ticket via PhoneView.' => 'Wählen Sie das Fenster nach der Erstellung eines neuen Anruf Tickets.'

    # Template: AAATicket
      '1 very low' => '1 sehr niedrig',
      '2 low' => '2 niedrig',
      '3 normal' => '3 normal',
      '4 high' => '4 hoch',
      '5 very high' => '5 sehr hoch',
      'Action' => 'Aktion',
      'Age' => 'Alter',
      'Article' => 'Artikel',
      'Attachment' => 'Anlage',
      'Attachments' => 'Anlagen',
      'Bcc' => '',
      'Bounce' => '',
      'Cc' => '',
      'Close' => 'Schließen',
      'closed successful' => 'erfolgreich geschlossen',
      'closed unsuccessful' => 'erfolglos geschlossen',
      'Compose' => 'Verfassen',
      'Created' => 'Erstellt',
      'Createtime' => 'Erstellt am',
      'email' => 'E-Mail',
      'eMail' => 'E-Mail',
      'email-external' => 'E-Mail an extern',
      'email-internal' => 'E-Mail an intern',
      'Forward' => 'Weiterleiten',
      'From' => 'Von',
      'high' => 'hoch',
      'History' => 'Historie',
      'If it is not displayed correctly,' => 'Wenn sie nicht korrekt angezeigt wird,',
      'lock' => 'gesperrt',
      'Lock' => 'Sperren',
      'low' => 'niedrig',
      'Move' => 'Verschieben',
      'new' => 'neu',
      'normal' => 'normal',
      'note-external' => 'Notiz für extern',
      'note-internal' => 'Notiz für intern',
      'note-report' => 'Notiz für reporting',
      'open' => 'offen',
      'Owner' => 'Besitzer',
      'Pending' => 'Warten',
      'pending auto close+' => 'warten auf erfolgreich schließen',
      'pending auto close-' => 'warten auf erfolglos schließen',
      'pending reminder' => 'warten zur Erinnerung',
      'phone' => 'Telefon',
      'plain' => 'klar',
      'Priority' => 'Priorität',
      'Queue' => '',
      'removed' => 'entfernt',
      'Sender' => 'Sender',
      'sms' => '',
      'State' => 'Status',
      'Subject' => 'Betreff',
      'This is a' => 'Dies ist eine',
      'This is a HTML email. Click here to show it.' => 'Dies ist eine HTML E-Mail. Hier klicken um sie anzusehen.',
      'This message was written in a character set other than your own.' => 'Diese Nachricht wurde in einem Zeichensatz erstellt, der nicht Ihrem eigenen entspricht.',
      'Ticket' => 'Ticket',
      'To' => 'An',
      'to open it in a new window.' => 'um sie in einem neuen Fenster angezeigt zu bekommen',
      'unlock' => 'frei',
      'Unlock' => 'Freigeben',
      'very high' => 'sehr hoch',
      'very low' => 'sehr niedrig',
      'View' => 'Ansicht',
      'webrequest' => 'Webanfrage',
      'Zoom' => 'Inhalt',

    # Template: AAAWeekDay
      'Fri' => 'Fre',
      'Mon' => 'Mon',
      'Sat' => 'Sam',
      'Sun' => 'Son',
      'Thu' => 'Don',
      'Tue' => 'Die',
      'Wed' => 'Mit',

    # Template: AdminAttachmentForm
      'Add attachment' => 'Anlage hinzufügen',
      'Attachment Management' => 'Anlagen-Verwaltung',
      'Change attachment settings' => 'Anlage-Einstellungen ändern',

    # Template: AdminAutoResponseForm
      'Add auto response' => 'Auto-Antwort hinzufügen',
      'Auto Response From' => 'Auto-Antwort-Absender',
      'Auto Response Management' => 'Auto-Antworten-Verwaltung',
      'Change auto response settings' => 'Auto-Antworten-Einstellungen ändern',
      'Charset' => 'Zeichensatz',
      'Note' => 'Notiz',
      'Response' => 'Antwort',
      'to get the first 20 character of the subject' => 'Um die ersten 20 Zeichen des Betreffs zu bekommen',
      'to get the first 5 lines of the email' => 'Um die ersten 5 Zeilen der E-Mail zu bekommen',
      'to get the from line of the email' => 'Um die From Zeile zu bekommen',
      'to get the realname of the sender (if given)' => 'Um den Realname des Senders zu bekommen (wenn möglich)',
      'to get the ticket id of the ticket' => 'Um die TicketID des Tickets zu bekommen',
      'to get the ticket number of the ticket' => 'Um die Ticketnummer des Ticket zu bekommen',
      'Type' => 'Typ',
      'Useable options' => 'Verfügbare Optionen',

    # Template: AdminCharsetForm
      'Add charset' => 'Zeichensatz hinzufügen',
      'Change system charset setting' => 'Ändere Zeichensatz',
      'System Charset Management' => 'Zeichensatz-Verwaltung',

    # Template: AdminCustomerUserForm
      'Add customer user' => 'Hinzufügen eines Kunden-Benutzers',
      'Change customer user settings' => 'Kunden-Benutzer-Einstellungen ändern',
      'Customer User Management' => 'Kunden-Benutzer-Verwaltung',
      'Update customer user' => 'Kunden-Benutzer ändern',
      'Customer user will be needed to to login via customer panels.' => 'Kunden-Benutzer werden für die Kunden-Weboberfläche benötigt',

    # Template: AdminCustomerUserGeneric

    # Template: AdminCustomerUserPreferencesGeneric

    # Template: AdminEmail
      'Admin-Email' => '',
      'Body' => '',
      'OTRS-Admin Info!' => '',
      'Permission' => 'Rechte',
      'Recipents' => 'Empfänger',
      'send' => 'Senden',

    # Template: AdminEmailSent
      'Message sent to' => 'Nachricht gesendet an',

    # Template: AdminGroupForm
      'Add group' => 'Gruppe hinzufügen',
      'Change group settings' => 'Gruppe ändern',
      'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).' => 'Erstellen Sie neue Gruppen, um die Zugriffe für verschiedene Agenten-Gruppen zu definieren (z.B. Einkaufs-Abteilung, Support-Abteilung, Verkaufs-Abteilung, ...).',
      'Group Management' => 'Gruppen-Verwaltung',
      'It\'s useful for ASP solutions.' => 'Sehr nützlich für ASP-Lösungen.',
      'The admin group is to get in the admin area and the stats group to get stats area.' => 'Die \'admin\'-Gruppe wird für den Admin-Bereich benötigt, die \'stats\'-Gruppe für den Statistik-Bereich.',

    # Template: AdminLog
      'System Log' => '',

    # Template: AdminNavigationBar
      'AdminEmail' => '',
      'AgentFrontend' => 'Agent-Oberfläche',
      'Attachment <-> Response' => 'Anlage <-> Antworten',
      'Auto Response <-> Queue' => 'Auto-Antworten <-> Queues',
      'Auto Responses' => 'Auto-Antworten',
      'Charsets' => 'Zeichensätze',
      'Customer User' => 'Kunden-Benutzer',
      'Email Addresses' => 'E-Mail-Adressen',
      'Groups' => 'Gruppen',
      'Logout' => 'Abmelden',
      'Misc' => 'Sonstiges',
      'POP3 Account' => 'POP3-Konto',
      'Responses' => 'Antworten',
      'Responses <-> Queue' => 'Antworten <-> Queues',
      'Select Box' => '',
      'Session Management' => 'Sitzungsverwaltung',
      'Status' => '',
      'System' => '',
      'User <-> Groups' => 'Benutzer <-> Gruppen',

    # Template: AdminPOP3Form
      'Add POP3 Account' => 'POP3-Konto hinzufügen',
      'All incoming emails with one account will be dispatched in the selected queue!' => 'Einkommende E-Mails von POP3-Konten werden in die ausgewählte Queue einsortiert!',
      'Change POP3 Account setting' => 'POP3-Konto ändern',
      'Dispatching' => 'Verteilung',
      'Host' => 'Rechner',
      'If your account is trusted, the x-otrs header (for priority, ...) will be used!' => 'Wird dem Konto vertraut, werden die X-OTRS Header benutzt!',
      'Login' => '',
      'POP3 Account Management' => 'POP3-Konten-Verwaltung',
      'Trusted' => 'Vertraut',

    # Template: AdminQueueAutoResponseForm
      'Queue <-> Auto Response Management' => 'Queue <-> Auto-Antworten Verwaltung',

    # Template: AdminQueueAutoResponseTable

    # Template: AdminQueueForm
      '0 = no escalation' => '0 = keine Eskalation',
      '0 = no unlock' => '0 = keine Freigabe',
      'Add queue' => 'Queue hinzufügen',
      'Change queue settings' => 'Queue ändern',
      'Customer Move Notify' => 'Kundeninfo Verschieben',
      'Customer Owner Notify' => 'Kundeninfo Besitzer',
      'Customer State Notify' => 'Kundeninfo Status',
      'Escalation time' => 'Eskalationszeit',
      'Follow up Option' => '',
      'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.' => 'Wenn ein Ticket geschlossen ist und der Kunde ein Follow-Up sendet, wird das Ticket für den alten Besitzer gesperrt.',
      'If a ticket will not be answered in thos time, just only this ticket will be shown.' => 'Wird ein Ticket nicht in dieser Zeit beantwortet, wird nur noch dieses Ticket gezeigt.',
      'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.' => 'Wird ein Ticket durch einen Agent gesperrt, jedoch nicht in dieser Zeit beantwortet, wird das Ticket automatisch freigegeben.',
      'Key' => 'Schlüssel',
      'OTRS sends an notification email to the customer if the ticket is moved.' => 'OTRS sendet Info-E-Mails an Kunden beim Verschieben des Tickets.',
      'OTRS sends an notification email to the customer if the ticket owner has changed.' => 'OTRS sendet Info-E-Mails an Kunden beim Ändern des Besitzers.',
      'OTRS sends an notification email to the customer if the ticket state has changed.' => 'OTRS sendet Info E-Mails an Kunden beim Ändern des Status.',
      'Queue Management' => 'Queue-Verwaltung',
      'Sub-Queue of' => 'Unterqueue von',
      'Systemaddress' => 'Systemadresse',
      'The salutation for email answers.' => 'Die Anrede für E-Mail-Antworten.',
      'The signature for email answers.' => 'Die Signatur für E-Mail-Antworten.',
      'Ticket lock after a follow up' => 'Ticket sperren nach einem Follow-Up',
      'Unlock timeout' => 'Freigabe-Zeitintervall',
      'Will be the sender address of this queue for email answers.' => 'Absenderadresse für E-Mails aus dieser Queue.',

    # Template: AdminQueueResponsesChangeForm
      'Change %s settings' => 'Ändern der %s Einstellungen',
      'Std. Responses <-> Queue Management' => 'Std. Antworten <-> Queue Verwaltung',

    # Template: AdminQueueResponsesForm
      'Answer' => 'Antwort',
      'Change answer <-> queue settings' => 'Ändern der Antworten <-> Queue Einstellungen',

    # Template: AdminResponseAttachmentChangeForm
      'Std. Responses <-> Std. Attachment Management' => 'Std. Antwort <-> Std. Anlage Verwaltung',

    # Template: AdminResponseAttachmentForm
      'Change Response <-> Attachment settings' => 'Ändere Antwort <-> Anlage Einstellungen',

    # Template: AdminResponseForm
      'A response is default text to write faster answer (with default text) to customers.' => 'Eine Antwort ist ein vorgegebener Text, um Kunden schneller antworten zu können.',
      'Add response' => 'Antwort hinzufügen',
      'Change response settings' => 'Antwort ändern',
      'Don\'t forget to add a new response a queue!' => 'Eine neue Antwort muss einer Queue zugewiesen werden!',
      'Response Management' => 'Antworten-Verwaltung',

    # Template: AdminSalutationForm
      'Add salutation' => 'Anrede hinzufügen',
      'Change salutation settings' => 'Anrede ändern',
      'customer realname' => 'Wirklicher Kundenname',
      'for agent firstname' => 'für Vorname des Agents',
      'for agent lastname' => 'für Nachname des Agents',
      'for agent login' => 'für Agent Login',
      'for agent user id' => 'für Agent UserID',
      'Salutation Management' => 'Anreden-Verwaltung',

    # Template: AdminSelectBoxForm
      'Max Rows' => 'Max. Zeilen',

    # Template: AdminSelectBoxResult
      'Limit' => '',
      'Select Box Result' => 'Select Box Ergebnis',
      'SQL' => '',

    # Template: AdminSession
      'kill all sessions' => 'Alle Sitzungen löschen',

    # Template: AdminSessionTable
      'kill session' => 'Sitzung löschen',
      'SessionID' => '',

    # Template: AdminSignatureForm
      'Add signature' => 'Signatur hinzufügen',
      'Change signature settings' => 'Ändere Signatur',
      'Signature Management' => 'Signatur-Verwaltung',

    # Template: AdminStateForm
      'Add state' => 'Status hinzufügen',
      'Change system state setting' => 'Ändere Status',
      'State Type' => 'Status-Typ',
      'System State Management' => 'Status-Verwaltung',

    # Template: AdminSystemAddressForm
      'Add system address' => 'E-Mail-Adresse hinzufügen',
      'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!' => 'Alle eingehenden E-Mails mit diesem Empfänger (To:) werden in die ausgewählte Queue einsortiert.',
      'Change system address setting' => 'Ändere E-Mail-Adresse',
      'Email' => 'E-Mail',
      'Realname' => '',
      'System Email Addresses Management' => 'E-Mail-Adressen-Verwaltung',

    # Template: AdminUserForm
      'Add user' => 'Benutzer hinzufügen',
      'Change user settings' => 'Benutzereinstellungen ändern',
      'Don\'t forget to add a new user to groups!' => 'Ein neuer Benutzer muss einer Gruppe zugewiesen werden!',
      'Firstname' => 'Vorname',
      'Lastname' => 'Nachname',
      'User Management' => 'Benutzer-Verwaltung',
      'User will be needed to handle tickets.' => 'Benutzer werden benötigt, um Tickets zu bearbeiten.',

    # Template: AdminUserGroupChangeForm
      'Change  settings' => '',
      'User <-> Group Management' => 'Benutzer <-> Gruppe Verwaltung',

    # Template: AdminUserGroupForm
      'Change user <-> group settings' => 'Ändern der Benutzer <-> Gruppe Einstellungen',

    # Template: AdminUserPreferencesGeneric

    # Template: AgentBounce
      'A message should have a To: recipient!' => 'Eine Nachricht sollte einen Empfänger im An: haben!',
      'Bounce ticket' => '',
      'Bounce to' => 'Bounce an',
      'Inform sender' => 'Sender informieren',
      'Next ticket state' => 'Nächster Status des Tickets',
      'Send mail!' => 'Mail senden!',
      'You need a email address (e. g. customer@example.com) in To:!' => 'Im An-Feld wird eine E-Mail-Adresse (z.B. kunde@beispiel.de) benötigt!',
      'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further informations.' => 'Die E-Mail mit Ticketnummer "<OTRS_TICKET>" ist an "<OTRS_BOUNCE_TO>" gebounced. Kontaktieren Sie diese Adresse für weitere Nachfragen.',

    # Template: AgentClose
      ' (work units)' => ' (Arbeitseinheiten)',
      'A message should have a subject!' => 'Eine Nachricht sollte einen Betreff haben!',
      'Close ticket' => 'Ticket schließen',
      'Close type' => 'Art des Schließens',
      'Close!' => 'Schließen!',
      'Note Text' => 'Notiztext',
      'Note type' => 'Notiztyp',
      'Options' => 'Optionen',
      'Spell Check' => 'Rechtschreibprüfung',
      'Time units' => 'Zeiteinheiten',
      'You need to account time!' => 'Zeit muss berechnet werden!',

    # Template: AgentCompose
      'A message must be spell checked!' => 'Nachrichten müssen rechtschreibüberprüft sein!',
      'Attach' => 'Anhängen',
      'Compose answer for ticket' => 'Antwort erstellen für',
      'for pending* states' => 'für warten* Stati',
      'Is the ticket answered' => 'Ist das Ticket beantwortet',
      'Pending Date' => 'Warten bis',

    # Template: AgentCustomer
      'Back' => 'Zurück',
      'Change customer of ticket' => 'Ändern des Kunden von Ticket',
      'CustomerID' => 'Kunden#',
      'Search Customer' => 'Kunden suchen',
      'Set customer user and customer id of a ticket' => 'Kunden-Benutzer und Kunden-Nummer des Tickets auswählen',

    # Template: AgentCustomerHistory
      'Customer history' => 'Kunden-Historie',

    # Template: AgentCustomerHistoryTable

    # Template: AgentCustomerMessage
      'Follow up' => '',
      'Next state' => 'Nächster Status',

    # Template: AgentCustomerView
      'Customer Data' => 'Kunden-Daten',

    # Template: AgentForward
      'Article type' => 'Artikeltyp',
      'Date' => 'Datum',
      'End forwarded message' => 'Ende der weitergeleiteten Nachricht',
      'Forward article of ticket' => 'Weiterleitung des Artikels vom Ticket',
      'Forwarded message from' => 'Weitergeleitete Nachricht von',
      'Reply-To' => '',

    # Template: AgentFreeText
      'Change free text of ticket' => 'Ändern der freien Ticket Felder',
      'Value' => 'Inhalt',

    # Template: AgentHistoryForm
      'History of' => 'Historie von',

    # Template: AgentMailboxNavBar
      'All messages' => 'Alle Nachrichten',
      'down' => 'abwärts',
      'Mailbox' => '',
      'New' => 'Neu',
      'New messages' => 'Neue Nachrichten',
      'Open' => 'Offen',
      'Open messages' => 'Offene Nachrichten',
      'Order' => 'Sortierung',
      'Pending messages' => 'Wartende Nachrichten',
      'Reminder' => 'Erinnernd',
      'Reminder messages' => 'Erinnernde Nachrichten',
      'Sort by' => 'Sortieren nach',
      'Tickets' => '',
      'up' => 'aufwärts',

    # Template: AgentMailboxTicket

    # Template: AgentMove
      'Move Ticket' => 'Ticket Verschieben',
      'New Queue' => 'Neue Queue',
      'New user' => 'Neuer Besitzer',

    # Template: AgentNavigationBar
      'Locked tickets' => 'Eigene Tickets',
      'new message' => 'Neue Nachrichten',
      'PhoneView' => 'Telefon-Ansicht',
      'Preferences' => 'Einstellungen',
      'Utilities' => 'Werkzeuge',

    # Template: AgentNote
      'Add note to ticket' => 'Anheften einer Notiz an Ticket',
      'Note!' => 'Notiz!',

    # Template: AgentOwner
      'Change owner of ticket' => 'Ticket-Besitzer ändern',
      'Message for new Owner' => 'Nachricht an neuen Besitzer',

    # Template: AgentPending
      'Pending date' => 'Warten bis',
      'Pending type' => 'Warten auf',
      'Pending!' => 'Warten!',
      'Set Pending' => 'Setze wartend',

    # Template: AgentPhone
      'Customer called' => 'Kunden angerufen',
      'Phone call' => 'Anruf',
      'Phone call at %s' => 'Anruf am %s',

    # Template: AgentPhoneNew
      'Clear From' => 'Von: löschen',
      'create' => 'Erstellen',
      'new ticket' => 'Neues Ticket',

    # Template: AgentPlain
      'ArticleID' => '',
      'Plain' => '',
      'TicketID' => '',

    # Template: AgentPreferencesCustomQueue
      'Select your custom queues' => 'Bevorzugte Queues auswählen',

    # Template: AgentPreferencesForm

    # Template: AgentPreferencesGeneric

    # Template: AgentPreferencesPassword
      'Change Password' => 'Passwort ändern',
      'New password' => 'Neues Passwort',
      'New password again' => 'Neues Passwort wiederholen',

    # Template: AgentPriority
      'Change priority of ticket' => 'Priorität ändern für Ticket',
      'New state' => 'Neue Priorität',

    # Template: AgentSpelling
      'Apply these changes' => 'Änderungen übernehmen',
      'Discard all changes and return to the compose screen' => 'Alle Änderungen verwerfen und zurück zum Verfassen-Fenster',
      'Return to the compose screen' => 'Zurück zum Verfassen-Fenster',
      'Spell Checker' => 'Rechtschreibprüfung',
      'spelling error(s)' => 'Rechtschreibfehler',
      'The message being composed has been closed.  Exiting.' => 'Die erstellte Nachricht wurde geschlossen.',
      'This window must be called from compose window' => 'Dieses Fenster muss über das Verfassen-Fenster aufgerufen werden',

    # Template: AgentStatusView
      'D' => 'Z',
      'of' => 'von',
      'Site' => 'Seite',
      'sort downward' => 'Sortierung abwärts',
      'sort upward' => 'Sortierung aufwärts',
      'Ticket Status' => 'Ticket-Status',
      'U' => 'A',

    # Template: AgentStatusViewTable

    # Template: AgentStatusViewTableNotAnswerd

    # Template: AgentTicketLocked
      'Ticket locked!' => 'Ticket gesperrt!',
      'Ticket unlock!' => 'Ticket freigeben!',

    # Template: AgentTicketPrint
      'by' => 'von',

    # Template: AgentTicketPrintHeader
      'Accounted time' => 'Zugewiesene Zeit',
      'Escalation in' => 'Eskalation in',
      'printed by' => 'gedruckt von',

    # Template: AgentUtilSearch
      'Article free text' => 'Artikel-Freitext',
      'Fulltext search (e. g. "Mar*in" or "Baue*" or "martin+hallo")' => 'Volltextsuche (z.B. "Mar*in" oder "Baue*" oder "martin+hallo")',
      'search' => 'Suche',
      'search (e. g. 10*5155 or 105658*)' => 'Suche (z.B. "10*5155" oder "105658*")',
      'Ticket free text' => 'Ticket-Freitext',
      'Ticket Search' => 'Ticket-Suche',

    # Template: AgentUtilSearchByCustomerID
      'Customer history search' => 'Kunden-Historie-Suche',
      'Customer history search (e. g. "ID342425").' => 'Kunden-Historie-Suche (z.B. "ID342425").',
      'No * possible!' => 'Kein "*" möglich!',

    # Template: AgentUtilSearchNavBar
      'Results' => 'Ergebnis',
      'Total hits' => 'Treffer gesamt',

    # Template: AgentUtilSearchResult

    # Template: AgentUtilTicketStatus
      'All closed tickets' => 'Alle geschlossenen Tickets',
      'All open tickets' => 'Alle offenen Tickets',
      'closed tickets' => 'geschlossenen Tickets',
      'open tickets' => 'offenen',
      'or' => 'oder',
      'Provides an overview of all' => 'Bietet eine Übersicht von allen',
      'So you see what is going on in your system.' => 'Damit können Sie sehen, was in Ihrem System vorgeht.',
      'Closed' => 'Geschlossen',

    # Template: AgentZoomAgentIsCustomer
      'Compose Follow up' => 'Follow up erstellen',
      'Your own Ticket' => 'Ihr eigenes Ticket',

    # Template: AgentZoomAnswer
      'Compose Answer' => 'Antwort erstellen',
      'Contact customer' => 'Kunden kontaktieren',
      'phone call' => 'Anrufen',

    # Template: AgentZoomArticle
      'Split' => 'Teilen',

    # Template: AgentZoomBody
      'Change queue' => 'Queue wechseln',

    # Template: AgentZoomHead
      'Free Fields' => 'Freie Felder',
      'Print' => 'Drucken',

    # Template: AgentZoomStatus

    # Template: CustomerCreateAccount
      'Create Account' => 'Account erstellen',

    # Template: CustomerError
      'Traceback' => '',

    # Template: CustomerFooter
      'Powered by' => '',

    # Template: CustomerHeader
      'Contact' => 'Kontakt',
      'Home' => '',
      'Online-Support' => '',
      'Products' => 'Produkt',
      'Support' => '',

    # Template: CustomerLogin

    # Template: CustomerLostPassword
      'Lost your password?' => 'Passwort verloren?',
      'Request new password' => 'Neues Passwort beantragen',

    # Template: CustomerMessage

    # Template: CustomerMessageNew

    # Template: CustomerNavigationBar
      'Create new Ticket' => 'Neues Ticket erstellen',
      'My Tickets' => 'Meine Tickets',
      'New Ticket' => 'Neues Ticket',
      'Ticket-Overview' => 'Ticket-Übersicht',
      'Welcome %s' => 'Willkommen %s',

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
      'Top of Page' => 'Seitenanfang',

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
      'Start page' => 'Start-Seite',
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
      '(Used default language)' => '(Standardwert für die Sprache)',
      '(Used log backend)' => '(Benutztes Log Backend)',
      '(Used ticket number format)' => '(Benutztes Ticketnummer Format)',
      'CheckMXRecord' => '',
      'Default Charset' => 'Standard-Zeichensatz',
      'Default Language' => 'Standardsprache',
      'Logfile' => 'Logdatei',
      'LogModule' => '',
      'Organization' => 'Organisation',
      'System FQDN' => '',
      'SystemID' => '',
      'Ticket Hook' => '',
      'Ticket Number Generator' => 'Ticket Nummer Generator',
      'Webfrontend' => 'Web-Oberfläche',

    # Template: Login

    # Template: LostPassword

    # Template: NoPermission
      'No Permission' => 'Keine Berechtigung',

    # Template: Notify
      'Info' => '',

    # Template: PrintFooter
      'URL' => '',

    # Template: PrintHeader

    # Template: QueueView
      'All tickets' => 'Alle Tickets',
      'Queues' => 'Queues',
      'Tickets available' => 'Tickets verfügbar',
      'Tickets shown' => 'Tickets angezeigt',

    # Template: SystemStats
      'Graphs' => 'Diagramme',

    # Template: Test
      'OTRS Test Page' => 'OTRS Test Seite',

    # Template: TicketEscalation
      'Ticket escalation!' => 'Ticket-Eskalation!',

    # Template: TicketView

    # Template: TicketViewLite
      'Add Note' => 'Notiz anheften',

    # Template: Warning

    # Misc
      '(Click here to add a group)' => '(Hier klicken - Gruppe hinzufügen)',
      '(Click here to add a queue)' => '(Hier klicken - Queue hinzufügen)',
      '(Click here to add a response)' => '(Hier klicken - Antwort hinzufügen)',
      '(Click here to add a salutation)' => '(Hier klicken - Anrede hinzufügen)',
      '(Click here to add a signature)' => '(Hier klicken - Signatur hinzufügen)',
      '(Click here to add a system email address)' => '(Hier klicken - System-E-Mail-Adresse hinzufügen)',
      '(Click here to add a customer user)' => '(Hier klicken - Kunden-Benutzer hinzufügen)',
      '(Click here to add a user)' => '(Hier klicken - Benutzer hinzufügen)',
      '(Click here to add an auto response)' => '(Hier klicken - Auto-Antwort hinzufügen)',
      '(Click here to add charset)' => '(Hier klicken - Zeichensatz hinzufügen',
      '(Click here to add language)' => '(Hier klicken - Sprache hinzufügen)',
      '(Click here to add state)' => '(Hier klicken - Status hinzufügen)',
      '(E-Mail of the system admin)' => '(E-Mail des System-Administrator)',
      'A message should have a From: recipient!' => 'Eine Nachricht sollte einen Absender (Von:) haben!',
      'Add language' => 'Sprache hinzufügen',
      'Backend' => '',
      'BackendMessage' => 'Backend-Nachricht',
      'Bottom of Page' => 'Seitenende',
      'Change system language setting' => 'Ändere Systemsprache',
      'Create' => 'Erstellen',
      'CustomerUser' => 'Kunden-Benutzer',
      'FAQ' => '',
      'Fulltext search' => 'Volltext-Suche',
      'Handle' => '',
      'In Queue' => '',
      'New ticket via call.' => 'Neues Ticket durch Anruf.',
      'Search in' => 'Suche in',
      'Set customer id of a ticket' => 'Setze eine Kunden# eines Ticket',
      'Show all' => 'Alle anzeigen',
      'System Language Management' => 'Systemsprache-Verwaltung',
      'Ticket limit:' => '',
      'Time till escalation' => 'Zeit bis zur Eskalation',
      'Update auto response' => 'Auto-Antwort aktualisieren',
      'Update charset' => 'Zeichensatz aktualisieren',
      'Update group' => 'Gruppe aktualisieren',
      'Update language' => 'Sprache aktualisieren',
      'Update queue' => 'Queue aktualisieren',
      'Update response' => 'Antworten aktualisieren',
      'Update salutation' => 'Anrede aktualisieren',
      'Update signature' => 'Signatur aktualisieren',
      'Update state' => 'Status aktualisieren',
      'Update system address' => 'System-E-Mail-Adresse aktualisieren',
      'Update user' => 'Benutzer aktualisieren',
      'With Priority' => 'Mit Priotität',
      'With State' => 'Mit Status',
      'You have to be in the admin group!' => 'Sie müssen dafür in der Admin-Gruppe sein!',
      'You have to be in the stats group!' => 'Sie müssen dafür in der Statistik-Gruppe sein!',
      'You need a email address (e. g. customer@example.com) in From:!' => 'Im From-Feld wird eine E-Mail-Adresse (z.B. kunde@beispiel.de) benötigt!',
      'auto responses set' => 'Auto-Antworten aktiviert',
      'invalid-temporarily' => 'vorübergehend ungültig',
      'store' => 'Speichern',
      'tickets' => 'Tickets',
      'valid' => 'gültig',
    );

    # $$STOP$$

    $Self->{Translation} = \%Hash;
}
# --
1;
