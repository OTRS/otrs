# --
# Kernel/Language/de.pm - provides de language translation
# Copyright (C) 2002-2003 Martin Edenhofer <martin at otrs.org>
# --
# $Id: de.pm,v 1.12 2003-02-08 15:07:29 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
package Kernel::Language::de;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.12 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub Data {
    my $Self = shift;
    my %Param = @_;
    my %Hash = ();

    # $$START$$
    # Last translation Mon Feb  3 23:27:51 2003 by 

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
      'AdminArea' => 'AdminBereich',
      'all' => 'alle',
      'All' => 'Alle',
      'Attention' => 'Achtung',
      'Bug Report' => 'Fehler berichten',
      'Cancel' => 'Abbrechen',
      'Change' => 'Ändern',
      'change' => 'ändern',
      'change!' => 'ändern!',
      'click here' => 'klick hier',
      'Comment' => 'Kommentar',
      'Customer' => 'Kunde',
      'Customer info' => 'Kunden Info',
      'day' => 'Tag',
      'days' => 'Tage',
      'description' => 'Beschreibung',
      'Description' => 'Beschreibung',
      'Dispatching by email To: field.' => 'Verteilung nach To: Feld.',
      'Dispatching by selected Queue.' => 'Verteilung nach ausgewählter Queue.',
      'Don\'t work with UserID 1 (System account)! Create new users!' => 'Arbeite nicht mit UserID 1 (System Account)! Erstelle neue Benutzer!',
      'Done' => 'Fertig',
      'end' => 'runter',
      'Error' => 'Fehler',
      'Example' => 'Beispiel',
      'Examples' => 'Beispiele',
      'Facility' => 'Einrichtung',
      'Feature not acitv!' => 'Feature nicht aktiviert!',
      'go' => 'start',
      'go!' => 'start!',
      'Group' => 'Gruppe',
      'Hit' => 'Treffer',
      'Hits' => 'Treffer',
      'hour' => 'Stunde',
      'hours' => 'Stunden',
      'Ignore' => 'Ignorieren',
      'invalid' => 'ungültig',
      'Invalid SessionID!' => 'Invalid SessionID!',
      'Language' => 'Sprache',
      'Languages' => 'Sprachen',
      'Line' => 'Zeile',
      'Lite' => 'Einfach',
      'Login failed! Your username or password was entered incorrectly.' => 'Login fehlgeschlagen! Benutzername oder Passwort falsch.',
      'Logout successful. Thank you for using OTRS!' => 'Abmelden erfolgreich! Danke für die Benutzung von OTRS!',
      'Message' => 'Nachricht',
      'minute' => 'Minute',
      'minutes' => 'Minuten',
      'Module' => 'Modul',
      'Modulefile' => 'Moduldatei',
      'Name' => 'Name',
      'New message' => 'Neue Nachricht',
      'New message!' => 'Neue Nachricht!',
      'no' => 'kein',
      'No' => 'Nein',
      'No suggestions' => 'Keine Vorschläge',
      'none' => 'keine',
      'none - answered' => 'keine - beantwortet',
      'none!' => 'keine Angabe!',
      'off' => 'aus',
      'Off' => 'Aus',
      'on' => 'ein',
      'On' => 'Ein',
      'Password' => 'Passwort',
      'Pending till' => 'Warten bis',
      'Please answer this ticket(s) to get back to the normal queue view!' => 'Bitte beantworten Sie dieses Ticket um in die normale queue view zurück zu kommen!',
      'Please contact your admin' => 'Bitte kontaktieren Sie Ihren Admin',
      'please do not edit!' => 'Bitte nicht verändern!',
      'possible' => 'möglich',
      'QueueView' => 'Queue-Ansicht',
      'reject' => 'ablehnen',
      'replace with' => 'ersetzen mit',
      'Reset' => 'Rücksetzen',
      'Salutation' => 'Anrede',
      'Signature' => 'Signatur',
      'Sorry' => 'Bedauere',
      'Stats' => 'Statistik',
      'Subfunction' => 'Unterfunktion',
      'submit' => 'übermitteln',
      'submit!' => 'übermitteln!',
      'Take this User' => 'Benutzer übernehmen',
      'Text' => '',
      'The recommended charset for your language is %s!' => 'Der empfohlene Charset für Ihre Sprache ist %s!',
      'Theme' => '',
      'There is no account with that login name.' => 'Es existiert kein Login mit diesen Namen.',
      'Timeover' => 'Zeitüberschreitung',
      'top' => 'hoch',
      'update' => 'aktualisieren',
      'update!' => 'aktualisieren!',
      'User' => 'Benutzer',
      'Username' => 'Benutzername',
      'Valid' => 'Gültig',
      'Warning' => 'Warnung',
      'Welcome to OTRS' => 'Willkommen zu OTRS',
      'Word' => 'Wort',
      'wrote' => 'schrieb',
      'Yes' => 'Ja',
      'yes' => 'ja',
      'You got new message!' => 'Du hast eine Neue Nachricht bekommen!',
      'You have %s new message(s)!' => 'Du hast %s neue Nachricht(en) bekommen!',
      'You have %s reminder ticket(s)!' => 'Du hast %s Erinnerungs-Ticket(s)!',

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
      'Custom Queue' => 'Persönliche Queue',
      'Follow up notification' => 'Mitteilung bei Nachfragen',
      'Frontend' => '',
      'Mail Management' => '',
      'Move notification' => 'Move Mitteilung',
      'New ticket notification' => 'Mitteilung bei neuem Ticket',
      'Other Options' => 'Andere Optionen',
      'Preferences updated successfully!' => 'Update der Benutzereinstellungen erfolgreich!',
      'QueueView refresh time' => 'Queue-Ansicht refresh Zeit',
      'Select your frontend Charset.' => 'Zeichensatz für Darstellung auswählen.',
      'Select your frontend language.' => 'Oberflächen-Sprache auswählen.',
      'Select your frontend QueueView.' => 'Queue-Ansicht auswählen.',
      'Select your frontend Theme.' => 'Anzeigeschema auswählen.',
      'Select your QueueView refresh time.' => 'Queue-Ansicht Aktualisierungszeit auswählen',
      'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.' => 'Zusenden einer Mitteilung wenn ein Kunden eine Nachfrage stellt uns ich der Eigner bin.',
      'Send me a notification if a ticket is moved into a custom queue.' => ' Zusenden einer Mitteilung beim verschieben eines Ticket in meine individuellen Queue(s).',
      'Send me a notification if a ticket is unlocked by the system.' => 'Zusenden einer Mitteilung wenn ein Ticket vom System freigegeben (unlocked) wird.',
      'Send me a notification if there is a new ticket in my custom queues.' => 'Zusenden einer Mitteilung bei neuem Ticket in der/den individuellen Queue(s).',
      'Ticket lock timeout notification' => 'Mitteilung bei lock Zeitüberschreitung',

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
      'email' => 'eMail',
      'eMail' => '',
      'email-external' => 'Email an extern',
      'email-internal' => 'Email an intern',
      'Forward' => 'Weiterleiten',
      'From' => 'Von',
      'high' => 'hoch',
      'History' => '',
      'If it is not displayed correctly,' => 'Wenn sie nicht korrekt angezeigt wird,',
      'Lock' => 'Ziehen',
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
      'pending reminder' => 'warten zur erinnerung',
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
      'This is a HTML email. Click here to show it.' => 'Dies ist eine HTML eMail. Hier klicken um sie anzusehen.',
      'This message was written in a character set other than your own.' => 'Diese Nachricht wurde in einem Zeichensatz erstellt, der nicht Ihrem eigenen entspricht.',
      'Ticket' => 'Ticket',
      'To' => 'An',
      'to open it in a new window.' => 'um sie in einem neuen Fenster angezeigt zu bekommen',
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
      'Add attachment' => 'Anhang hinzufügen',
      'Attachment Management' => 'Anhang Management',
      'Change attachment settings' => 'Ändern der Anhang Einstellungen',

    # Template: AdminAutoResponseForm
      'Add auto response' => 'Auto-Antwort hinzufügen',
      'Auto Response From' => 'Auto-Antwort Form',
      'Auto Response Management' => 'Auto-Antworten Verwaltung',
      'Change auto response settings' => 'Ändern einer Auto-Antworten',
      'Charset' => '',
      'Note' => 'Notiz',
      'Response' => 'Antwort',
      'to get the first 20 character of the subject' => 'Um die ersten 20 Zeichen des Betreffs zu bekommen',
      'to get the first 5 lines of the email' => 'Um die ersten 5 Zeilen der eMail zu bekommen',
      'to get the from line of the email' => 'Um die From Zeile zu bekommen',
      'to get the realname of the sender (if given)' => 'Um den Realname des Senders zu bekommen (wenn möglich)',
      'to get the ticket id of the ticket' => 'Um die TicketID des Tickets zu bekommen',
      'to get the ticket number of the ticket' => 'Um die Tickernummer des Ticket zu bekommen',
      'Type' => '',
      'Useable options' => 'Benutzbare Optionen',

    # Template: AdminCharsetForm
      'Add charset' => 'Charset hinzufügen',
      'Change system charset setting' => 'Ändere System-Charset',
      'System Charset Management' => 'System-Charset Verwaltung',

    # Template: AdminCustomerUserForm
      'Add customer user' => 'Hinzufügen eines Kunden-Benutzers',
      'Change customer user settings' => 'Ämdern der Kunden-Benutzers einstellungen',
      'Customer User Management' => 'Kunden-Benutzer Management',
      'Customer user will be needed to to login via customer panels.' => 'Kunden-Benutzer werden für das Kunden-Webfrontend benötigt',

    # Template: AdminCustomerUserGeneric

    # Template: AdminCustomerUserPreferencesGeneric

    # Template: AdminEmail
      'Admin-Email' => '',
      'Body' => '',
      'OTRS-Admin Info!' => '',
      'Recipents' => 'Empfänger',

    # Template: AdminEmailSent
      'Message sent to' => 'Nachricht gesendet an',

    # Template: AdminGroupForm
      'Add group' => 'Gruppe hinzufügen',
      'Change group settings' => 'Ändern einer Gruppe',
      'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).' => 'Erstelle neue Gruppen um die Zugriffe für verschieden Agent-Gruppen zu definieren (z. B. Einkaufs-Abteilung, Support-Abteilung, Verkaufs-Abteilung, ...).',
      'Group Management' => 'Gruppen Verwaltung',
      'It\'s useful for ASP solutions.' => 'Sehr nützlich für ASP-Lösungen.',
      'The admin group is to get in the admin area and the stats group to get stats area.' => 'Die admin Gruppe wird für den Admin-Bereich benötigt, die stats Gruppe für den Statistik-Bereich.',

    # Template: AdminLanguageForm
      'Add language' => 'Sprache hinzufügen',
      'Change system language setting' => 'Ändere System-Sprache',
      'System Language Management' => 'System-Sprache Verwaltung',

    # Template: AdminLog
      'System Log' => '',

    # Template: AdminNavigationBar
      'AdminEmail' => '',
      'AgentFrontend' => 'AgentOberfläche',
      'Auto Response <-> Queue' => 'Auto-Antworten <-> Queues',
      'Auto Responses' => 'Auto-Antworten',
      'Charsets' => '',
      'Customer User' => 'Kunden Benutzer',
      'Email Addresses' => 'Email-Adressen',
      'Groups' => 'Gruppen',
      'Logout' => 'Abmelden',
      'Misc' => '',
      'POP3 Account' => '',
      'Responses' => 'Antworten',
      'Responses <-> Queue' => 'Antworten <-> Queues',
      'Select Box' => '',
      'Session Management' => 'Sitzungsverwaltung',
      'Status defs' => '',
      'System' => '',
      'User <-> Groups' => 'Benutzer <-> Gruppen',

    # Template: AdminPOP3Form
      'Add POP3 Account' => 'POP3 Account hinzufügen',
      'All incoming emails with one account will be dispatched in the selected queue!' => 'Einkommende emails von POP3 Accounts werden in die ausgewählte Queue einsortiert!',
      'Change POP3 Account setting' => 'POP3 Account ändern',
      'Dispatching' => 'Verteilung',
      'Host' => 'Rechner',
      'If your account is trusted, the x-otrs header (for priority, ...) will be used!' => 'Ist der Account trusted, werden die x-otrs Header benutzt!',
      'Login' => '',
      'POP3 Account Management' => '',
      'Trusted' => 'Vertraut',

    # Template: AdminQueueAutoResponseForm
      'Queue <-> Auto Response Management' => 'Queue <-> Auto-Antworten Verwaltung',

    # Template: AdminQueueAutoResponseTable

    # Template: AdminQueueForm
      '0 = no escalation' => '0 = keine Eskalation',
      '0 = no unlock' => '0 = kein Unlock',
      'Add queue' => 'Queue hinzufügen',
      'Change queue settings' => 'Ändern einer Queue',
      'Escalation time' => 'Eskalationszeit',
      'Follow up Option' => '',
      'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.' => 'Wenn ein Ticket geschlossen ist und der Kunde jedoch ein follow up sendet, wird das ticket für den alten Eigner gelocked.',
      'If a ticket will not be answered in thos time, just only this ticket will be shown.' => 'Wird ein Ticket nicht in jener Zeit beantortet, wird nur noch dieses Ticket gezeigt.',
      'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.' => 'Wird ein Ticket durch einen Agent gelocked jedoch nicht in dieser Zeit beantwortet, wird das Ticket automatisch unlocked.',
      'Key' => 'Schlüssel',
      'Queue Management' => 'Queue Verwaltung',
      'Systemaddress' => 'System-Adresse',
      'The salutation for email answers.' => 'Die Anrede für eMail Antworten.',
      'The signature for email answers.' => 'Die Signatur für eMail Antworten.',
      'Ticket lock after a follow up' => 'Ticket locken nache einem follow up',
      'Unlock timeout' => 'Freigabe Zeitüberschreitung',
      'Will be the sender address of this queue for email answers.' => 'Absende Adresse für eMails aus dieser Queue.',

    # Template: AdminQueueResponsesChangeForm
      'Change %s settings' => 'Ändern der %s Einstellungen',
      'Std. Responses <-> Queue Management' => 'Std. Antworten <-> Queue Verwaltung',

    # Template: AdminQueueResponsesForm
      'Answer' => 'Antwort',
      'Change answer <-> queue settings' => 'Ändern der Antworten <-> Queue Beziehung',

    # Template: AdminResponseAttachmentChangeForm
      'Std. Responses <-> Std. Attachment Management' => 'Std. Antwort <-> Std. Anhang Management',

    # Template: AdminResponseAttachmentForm
      'Change Response <-> Attachment settings' => 'Ändere Antwort <-> Anhang Einstellungen',

    # Template: AdminResponseForm
      'A response is default text to write faster answer (with default text) to customers.' => 'Eine Antwort ist ein vorgegebener Text um schneller Antworten an Kundern schreiben zu können.',
      'Add response' => 'Antwort hinzufügen',
      'Change response settings' => 'Ändern einer Antwort',
      'Don\'t forget to add a new response a queue!' => 'Eine neue Antwort muss auch einer Queue zugewiesen werden!',
      'Response Management' => 'Antworten Verwaltung',

    # Template: AdminSalutationForm
      'Add salutation' => 'Anrede hinzufügen',
      'Change salutation settings' => 'Ändern einer Anrede',
      'customer realname' => 'echter Kundenname',
      'Salutation Management' => 'Anreden Verwaltung',

    # Template: AdminSelectBoxForm
      'Max Rows' => 'Max. Zeile',

    # Template: AdminSelectBoxResult
      'Limit' => '',
      'Select Box Result' => 'Select Box Ergebnis',
      'SQL' => '',

    # Template: AdminSession
      'kill all sessions' => 'Löschen aller Sitzungen',

    # Template: AdminSessionTable
      'kill session' => 'Sitzung löschen',
      'SessionID' => '',

    # Template: AdminSignatureForm
      'Add signature' => 'Signatur hinzufügen',
      'Change signature settings' => 'Ändern einer Signatur',
      'for agent firstname' => 'für Vorname des Agents',
      'for agent lastname' => 'für Nachname des Agents',
      'Signature Management' => 'Signatur Verwaltung',

    # Template: AdminStateForm
      'Add state' => 'State hinzufügen',
      'Change system state setting' => 'Ändere System-State',
      'System State Management' => 'System-State Verwaltung',

    # Template: AdminSystemAddressForm
      'Add system address' => 'System-Email-Adresse hinzufügen',
      'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!' => 'Alle eingehenden Emails mit dem "To:" werden in die ausgewählte Queue einsortiert.',
      'Change system address setting' => 'Ändere System-Adresse',
      'Email' => 'eMail',
      'Realname' => '',
      'System Email Addresses Management' => 'System-Email-Adressen Verwaltung',

    # Template: AdminUserForm
      'Add user' => 'Benutzer hinzufügen',
      'Change user settings' => 'Ändern der Benutzereinstellung',
      'Don\'t forget to add a new user to groups!' => 'Eine neuer Benutzer muss auch einer Gruppe zugewiesen werden!',
      'Firstname' => 'Vorname',
      'Lastname' => 'Nachname',
      'User Management' => 'Benutzer Verwaltung',
      'User will be needed to handle tickets.' => 'Benutzer werden benötigt um Tickets zu bearbeietn.',

    # Template: AdminUserGroupChangeForm
      'Change  settings' => '',
      'User <-> Group Management' => 'Benutzer <-> Gruppe Verwaltung',

    # Template: AdminUserGroupForm
      'Change user <-> group settings' => 'Ändern der Benutzer <-> Gruppe Beziehung',

    # Template: AdminUserPreferencesGeneric

    # Template: AgentBounce
      'A message should have a To: recipient!' => 'Eine Nachricht sollte einen Empfänger im An: haben!',
      'Bounce ticket' => '',
      'Bounce to' => 'Bounce an',
      'Inform sender' => 'Sender informieren',
      'Next ticket state' => 'Nächster Status des Tickets',
      'Send mail!' => 'Mail senden!',
      'You need a email address (e. g. customer@example.com) in To:!' => 'Im An-Feld wird eine eMail-Adresse (z. B. kunde@beispiel.de) benötigt!',
      'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further inforamtions.' => '',

    # Template: AgentClose
      ' (work units)' => ' (arbeits Einheiten)',
      'Close ticket' => 'Ticket schließen',
      'Close type' => 'Schließen Type',
      'Close!' => 'Schließen!',
      'Note Text' => 'Notiz Text',
      'Note type' => 'Notiz-Typ',
      'store' => 'speichern',
      'Time units' => 'Zeit-Einheiten',

    # Template: AgentCompose
      'A message should have a subject!' => 'Eine Nachricht sollte ein Betreff haben!',
      'Attach' => 'Anhängen',
      'Compose answer for ticket' => 'Antwort erstellen für',
      'for pending* states' => 'für warten* Statie',
      'Is the ticket answered' => 'Ist das Ticket beantwortet',
      'Options' => 'Optionen',
      'Pending Date' => 'Warten Datum',
      'Spell Check' => 'Rechtschreibkontrolle',

    # Template: AgentCustomer
      'Back' => 'zurück',
      'Change customer of ticket' => 'Ändern des Kunden von Ticket',
      'Set customer id of a ticket' => 'Setze eine Kunden# zu einem Ticket',

    # Template: AgentCustomerHistory
      'Customer history' => 'Kunden History',

    # Template: AgentCustomerHistoryTable

    # Template: AgentCustomerView
      'Customer Data' => 'Kunden Daten',

    # Template: AgentForward
      'Article type' => 'Artikel-Typ',
      'Date' => 'Datum',
      'End forwarded message' => '',
      'Forward article of ticket' => 'Weiterleitung des Artikels vom Ticket',
      'Forwarded message from' => '',
      'Reply-To' => '',

    # Template: AgentHistoryForm
      'History of' => 'History von',

    # Template: AgentMailboxNavBar
      'All messages' => 'Alle Nachrichten',
      'CustomerID' => 'Kunden#',
      'down' => 'abwärts',
      'Mailbox' => '',
      'New' => 'Neu',
      'New messages' => 'Neue Nachrichten',
      'Open' => 'Offen',
      'Open messages' => 'Offene Nachrichten',
      'Order' => '',
      'Pending messages' => 'Wartende Nachrichten',
      'Reminder' => 'Erinnernd',
      'Reminder messages' => 'Erinnernde Nachrichten',
      'Sort by' => 'Sortieren by',
      'Tickets' => '',
      'up' => 'aufwärts',

    # Template: AgentMailboxTicket
      'Add Note' => 'Notiz anheften',

    # Template: AgentNavigationBar
      'FAQ' => '',
      'Locked tickets' => 'Eigene Tickets',
      'new message' => 'neue Nachricht',
      'PhoneView' => 'Telefon-Ansicht',
      'Preferences' => 'Einstellungen',
      'Utilities' => 'Werkzeuge',

    # Template: AgentNote
      'Add note to ticket' => 'Anheften einer Notiz an Ticket',
      'Note!' => 'Notiz!',

    # Template: AgentOwner
      'Change owner of ticket' => 'Ändern Eigners von Ticket',
      'Message for new Owner' => 'Nachricht an neuen Eigner',
      'New user' => 'Neuer Eigner',

    # Template: AgentPending
      'Pending date' => 'Warten Datum',
      'Pending type' => 'Warten Type',
      'Set Pending' => 'Setze wartend',

    # Template: AgentPhone
      'Customer called' => 'Kunden angerufen',
      'Phone call' => 'Anruf',
      'Phone call at %s' => 'Anruf um %s',

    # Template: AgentPhoneNew
      'Search Customer' => 'Kunden suchen',
      'new ticket' => 'neues Ticket',

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
      'Discard all changes and return to the compose screen' => 'Verwerfen aller Änderungen und zurück zum Verfassen-Fenster',
      'Return to the compose screen' => 'Zurück zum Verfassen-Fenster',
      'Spell Checker' => 'Rechtschreibkontrolle',
      'spelling error(s)' => 'Rechtschreibfehler',
      'The message being composed has been closed.  Exiting.' => 'Die erstellte Nachricht wurde geschlossen.',
      'This window must be called from compose window' => 'Dieses Fenster muss über das Verfassen-Fenster aufgerufen werden',

    # Template: AgentStatusView
      'D' => '',
      'sort downward' => 'Sortierung abwärts',
      'sort upward' => 'Sortierung aufwärts',
      'Ticket limit:' => '',
      'Ticket Status' => '',
      'U' => '',

    # Template: AgentStatusViewTable

    # Template: AgentStatusViewTableNotAnswerd

    # Template: AgentTicketLocked
      'Ticket locked!' => 'Ticket gesperrt!',
      'unlock' => 'freigeben',

    # Template: AgentTicketPrint
      'by' => 'von',

    # Template: AgentTicketPrintHeader
      'Accounted time' => 'Zugewiesene Zeit',
      'Escalation in' => 'Eskalation in',
      'printed by' => 'gedruckt von',

    # Template: AgentUtilSearchByCustomerID
      'Customer history search' => 'Kunden-History-Suche',
      'Customer history search (e. g. "ID342425").' => 'Kunden History Suche (z. B. "ID342425").',
      'No * possible!' => 'Kein * möglich!',

    # Template: AgentUtilSearchByText
      'Article free text' => 'Artikel frei Text',
      'Fulltext search' => 'Volltext-Suche',
      'Fulltext search (e. g. "Mar*in" or "Baue*" or "martin+hallo")' => 'Volltextsuche (z. B. "Mar*in" oder "Baue*" oder "martin+hallo")',
      'Search in' => 'Suche in',
      'Ticket free text' => 'Ticket frei Text',
      'With State' => 'Mit Status',

    # Template: AgentUtilSearchByTicketNumber
      'search' => 'Suchen',
      'search (e. g. 10*5155 or 105658*)' => 'Suche (z. B. 10*5155 or 105658*)',

    # Template: AgentUtilSearchNavBar
      'Results' => 'Ergebnis',
      'Site' => 'Seite',
      'Total hits' => 'Treffer gesamt',

    # Template: AgentUtilSearchResult

    # Template: AgentUtilTicketStatus
      'All open tickets' => 'Alle offenen Tickets',
      'open tickets' => 'offene Tickets',
      'Provides an overview of all' => 'Bietet eine Übersicht von allen',
      'So you see what is going on in your system.' => 'Somit können Sie sehen, was in Ihrem System vorgeht.',

    # Template: CustomerCreateAccount
      'Create' => 'Erstellen',
      'Create Account' => 'Account erstellen',

    # Template: CustomerError
      'Backend' => '',
      'BackendMessage' => 'Backend-Nachricht',
      'Click here to report a bug!' => 'Klicken Sie hier um einen Fehler zu berichten!',
      'Handle' => '',

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
      'Follow up' => '',

    # Template: CustomerMessageNew

    # Template: CustomerNavigationBar
      'Create new Ticket' => 'Neues Ticket erstellen',
      'My Tickets' => 'Meine Tickets',
      'New Ticket' => 'neues Ticket',
      'Ticket-Overview' => 'Ticket-Übersicht',
      'Welcome %s' => 'Willkommen %s',

    # Template: CustomerPreferencesForm

    # Template: CustomerPreferencesGeneric

    # Template: CustomerPreferencesPassword

    # Template: CustomerStatusView
      'of' => 'von',

    # Template: CustomerStatusViewTable

    # Template: CustomerTicketZoom

    # Template: CustomerWarning

    # Template: Error

    # Template: Footer

    # Template: Header

    # Template: InstallerStart
      'next step' => 'Nächster Schritt',

    # Template: InstallerSystem
      '(Checks MX recordes of used email addresses by composing an answer. Don\'t use CheckMXRecord if your OTRS machine is behinde a dial-up line $!)' => '',
      '(Email of the system admin)' => '(eMail des System Admins)',
      '(Full qualified domain name of your system)' => '(Foller Domain-Name des Systems)',
      '(Logfile just needed for File-LogModule!)' => '(Logfile nur benötigt für File-LogModule!)',
      '(The identify of the system. Each ticket number and each http session id starts with this number)' => '(Das Kennzeichnen des Systems. Jede Ticket Nummer und http Sitzung beginnt mit dieser ID)',
      '(Ticket identifier. Some people want toset this to e. g. \'Ticket#\', \'Call#\' or \'MyTicket#\')' => '(Ticket Kennzeichnen. Z. B. \'Ticket#\', \'Call#\' oder \'MyTicket#\')',
      '(Used default language)' => '(Standardwert für die Sprache)',
      '(Used log backend)' => '(Benutztes Log Backend)',
      '(Used ticket number format)' => '(Benutztes Ticket-Nummer Format)',
      'CheckMXRecord' => '',
      'Default Charset' => 'Standard Charset',
      'Default Language' => 'Standard Sprache',
      'Logfile' => '',
      'LogModule' => '',
      'Organization' => 'Organisation',
      'System FQDN' => '',
      'SystemID' => '',
      'Ticket Hook' => '',
      'Ticket Number Generator' => '',
      'Webfrontend' => '',

    # Template: Login

    # Template: LostPassword

    # Template: NoPermission
      'No Permission' => 'Keine Erlaubnis',

    # Template: Notify
      'Info' => '',

    # Template: PrintFooter
      'URL' => '',

    # Template: PrintHeader
      'Print' => 'Drucken',

    # Template: QueueView
      'All tickets' => 'Alle Tickets',
      'Queues' => 'Queues',
      'Show all' => 'Alle gezeigt',
      'Ticket available' => 'Ticket verfügbar',
      'tickets' => 'Tickets',
      'Tickets shown' => 'Tickets gezeigt',

    # Template: SystemStats
      'Graphs' => 'Diagramme',

    # Template: Test
      'OTRS Test Page' => 'OTRS Test Seite',

    # Template: TicketEscalation
      'Ticket escalation!' => 'Ticket Eskalation!',

    # Template: TicketView
      'Change queue' => 'Wechsle Queue',
      'Compose Answer' => 'Antwort erstellen',
      'Contact customer' => 'Kunden kontaktieren',
      'phone call' => 'Anrufen',

    # Template: TicketViewLite

    # Template: TicketZoom

    # Template: TicketZoomNote

    # Template: TicketZoomSystem

    # Template: Warning

    # Misc
      '(Click here to add a group)' => '(Hier klicken - Gruppe hinzufügen)',
      '(Click here to add a queue)' => '(Hier klicken - Queue hinzufügen)',
      '(Click here to add a response)' => '(Hier klicken - Antwort hinzufügen)',
      '(Click here to add a salutation)' => '(Hier klicken - Anrede hinzufügen)',
      '(Click here to add a signature)' => '(Hier klicken - Signatur hinzufügen)',
      '(Click here to add a system email address)' => '(Hier klicken - System-Email-Adresse hinzufügen)',
      '(Click here to add a user)' => '(Hier klicken - Benutzer hinzufügen)',
      '(Click here to add an auto response)' => '(Hier klicken - Auto-Antwort hinzufügen)',
      '(Click here to add charset)' => '(Hier klicken - Charset hinzufügen',
      '(Click here to add language)' => '(Hier klicken - Sprache hinzufügen)',
      '(Click here to add state)' => '(Hier klicken - state hinzufügen)',
      'A message should have a From: recipient!' => 'Eine Nachricht sollte einen Absender im Von: haben!',
      'CustomerUser' => 'Kunden-Benutzer',
      'New ticket via call.' => 'Neues Ticket durch Anruf.',
      'Time till escalation' => 'Zeit bis zur Escalation',
      'Update auto response' => 'Auto-Antwort aktualisieren',
      'Update charset' => 'Charset aktualisieren',
      'Update group' => 'Gruppe aktualisieren',
      'Update language' => 'Sprache aktualisieren',
      'Update queue' => 'Queue aktualisieren',
      'Update response' => 'Antworten aktualisieren',
      'Update salutation' => 'Anrede aktualisieren',
      'Update signature' => 'Signatur aktualisieren',
      'Update state' => 'State aktualisieren',
      'Update system address' => 'System-Email-Adresse aktualisieren',
      'Update user' => 'Benutzer aktualisieren',
      'You have to be in the admin group!' => 'Sie müssen hierfür in der Admin-Gruppe sein!',
      'You have to be in the stats group!' => 'Sie müssen hierfür in der Statistik-Gruppe sein!',
      'You need a email address (e. g. customer@example.com) in From:!' => 'Im From-Feld wird eine eMail-Adresse (z. B. kunde@beispiel.de) benötigt!',
      'auto responses set' => 'Auto-Antworten gesetzt',
    );

    # $$STOP$$

    $Self->{Translation} = \%Hash;
}
# --
1;
