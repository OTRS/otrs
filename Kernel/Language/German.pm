# --
# Kernel/Language/German.pm - provides German language translation
# Copyright (C) 2002 ??? <???>
# --
# $Id: German.pm,v 1.29 2002-11-21 22:17:27 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
package Kernel::Language::German;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.29 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*\$/\$1/;
# --
sub Data {
    my $Self = shift;
    my %Param = @_;
    my %Hash = ();

    # possible charsets
    $Self->{Charset} = ['iso-8859-1', 'iso-8859-15', ];

    # Template: AAABasics
    $Hash{' 2 minutes'} = ' 2 Minuten';
    $Hash{' 5 minutes'} = ' 5 Minuten';
    $Hash{' 7 minutes'} = ' 7 Minuten';
    $Hash{'10 minutes'} = '10 Minuten';
    $Hash{'15 minutes'} = '15 Minuten';
    $Hash{'AddLink'} = 'Link hinzufügen';
    $Hash{'AdminArea'} = 'AdminBereich';
    $Hash{'All'} = 'All';
    $Hash{'all'} = 'alle';
    $Hash{'Attention'} = 'Achtung';
    $Hash{'Bug Report'} = 'Fehler berichten';
    $Hash{'Cancel'} = 'Abbrechen';
    $Hash{'change'} = 'ändern';
    $Hash{'Change'} = 'Ändern';
    $Hash{'change!'} = 'ändern!';
    $Hash{'click here'} = 'klick hier';
    $Hash{'Comment'} = 'Kommentar';
    $Hash{'Customer'} = 'Kunde';
    $Hash{'Customer info'} = 'Kunden Info';
    $Hash{'day'} = 'Tag';
    $Hash{'days'} = 'Tage';
    $Hash{'description'} = 'Beschreibung';
    $Hash{'Description'} = 'Beschreibung';
    $Hash{'Done'} = 'Fertig';
    $Hash{'end'} = 'runter';
    $Hash{'Error'} = 'Fehler';
    $Hash{'Example'} = 'Beispiel';
    $Hash{'Examples'} = 'Beispiele';
    $Hash{'go'} = 'start';
    $Hash{'go!'} = 'start!';
    $Hash{'Group'} = 'Gruppe';
    $Hash{'Hit'} = 'Treffer';
    $Hash{'Hits'} = 'Treffer';
    $Hash{'hour'} = 'Stunde';
    $Hash{'hours'} = 'Stunden';
    $Hash{'Ignore'} = 'Ignorieren';
    $Hash{'Language'} = 'Sprache';
    $Hash{'Languages'} = 'Sprachen';
    $Hash{'Line'} = 'Zeile';
    $Hash{'Logout successful. Thank you for using OTRS!'} = 'Abmelden erfolgreich! Danke für die Benutzung von OTRS!';
    $Hash{'Message'} = 'Nachricht';
    $Hash{'minute'} = 'Minute';
    $Hash{'minutes'} = 'Minuten';
    $Hash{'Module'} = 'Modul';
    $Hash{'Modulefile'} = 'Moduldatei';
    $Hash{'Name'} = 'Name';
    $Hash{'New message'} = 'Neue Nachricht';
    $Hash{'New message!'} = 'Neue Nachricht!';
    $Hash{'no'} = 'kein';
    $Hash{'No'} = 'Nein';
    $Hash{'No suggestions'} = 'Keine Vorschläge';
    $Hash{'none'} = 'keine';
    $Hash{'none - answered'} = 'keine - beantwortet';
    $Hash{'none!'} = 'keine Angabe!';
    $Hash{'Off'} = 'Aus';
    $Hash{'off'} = 'aus';
    $Hash{'on'} = 'ein';
    $Hash{'On'} = 'Ein';
    $Hash{'Password'} = 'Passwort';
    $Hash{'Please answer this ticket(s) to get back to the normal queue view!'} = 'Bitte beantworten Sie dieses Ticket um in die normale queue view zurück zu kommen!';
    $Hash{'please do not edit!'} = 'Bitte nicht verändern!';
    $Hash{'QueueView'} = 'Queue-Ansicht';
    $Hash{'replace with'} = 'ersetzen mit';
    $Hash{'Reset'} = 'Rücksetzen';
    $Hash{'Salutation'} = 'Anrede';
    $Hash{'Signature'} = 'Signatur';
    $Hash{'Sorry'} = 'Bedauere';
    $Hash{'Stats'} = 'Statistik';
    $Hash{'Subfunction'} = 'Unterfunktion';
    $Hash{'submit'} = 'übermitteln';
    $Hash{'submit!'} = 'übermitteln!';
    $Hash{'Text'} = '';
    $Hash{'top'} = 'hoch';
    $Hash{'update'} = 'aktualisieren';
    $Hash{'update!'} = 'aktualisieren!';
    $Hash{'User'} = 'Benutzer';
    $Hash{'Username'} = 'Benutzername';
    $Hash{'Valid'} = 'Gültig';
    $Hash{'Warning'} = 'Warnung';
    $Hash{'Welcome to OTRS'} = 'Willkommen zu OTRS';
    $Hash{'Word'} = 'Wort';
    $Hash{'wrote'} = 'schrieb';
    $Hash{'yes'} = 'ja';
    $Hash{'Yes'} = 'Ja';
    $Hash{'You got new message!'} = 'Neue Nachricht bekommen!';
    $Hash{'The recommended charset for your language is %s!'} = 'Der empfohlene Charset für Ihre Sprache ist %s!';

    # Template: AAALanguage
    $Hash{'Brazilian'} = 'Brasilianisch';
    $Hash{'Chinese'} = 'Chinesisch';
    $Hash{'Czech'} = 'Tschechisch';
    $Hash{'Danish'} = 'Dänisch';
    $Hash{'Dutch'} = 'Niederländisch';
    $Hash{'English'} = 'Englisch';
    $Hash{'French'} = 'Französisch';
    $Hash{'German'} = 'Deutsch';
    $Hash{'Greek'} = 'Griechisch';
    $Hash{'Italian'} = 'Italienisch';
    $Hash{'Korean'} = 'Koreanisch';
    $Hash{'Polish'} = 'Polnisch';
    $Hash{'Russian'} = 'Russisch';
    $Hash{'Spanish'} = 'Spanisch';
    $Hash{'Swedish'} = 'Schwedisch';

    # Template: AAAPreferences
    $Hash{'Custom Queue'} = '';
    $Hash{'Follow up notification'} = 'Mitteilung bei Nachfragen';
    $Hash{'Frontend'} = '';
    $Hash{'Mail Management'} = '';
    $Hash{'Move notification'} = 'Move Mitteilung';
    $Hash{'New ticket notification'} = 'Mitteilung bei neuem Ticket';
    $Hash{'Other Options'} = 'Andere Optionen';
    $Hash{'Preferences updated successfully!'} = 'Update der Benutzereinstellungen erfolgreich!';
    $Hash{'QueueView refresh time'} = 'Queue-Ansicht refresh Zeit';
    $Hash{'Select your frontend Charset.'} = 'Zeichensatz für Darstellung auswählen.';
    $Hash{'Select your frontend language.'} = 'Oberflächen-Sprache auswählen.';
    $Hash{'Select your frontend QueueView.'} = 'Queue-Ansicht auswählen.';
    $Hash{'Select your frontend Theme.'} = 'Anzeigeschema auswählen.';
    $Hash{'Select your QueueView refresh time.'} = 'Queue-Ansicht Aktualisierungszeit auswählen';
    $Hash{'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.'} = 'Zusenden einer Mitteilung wenn ein Kunden eine Nachfrage stellt uns ich der Eigner bin.';
    $Hash{'Send me a notification if a ticket is moved into a custom queue.'} = ' Zusenden einer Mitteilung beim verschieben eines Ticket in meine individuellen Queue(s).';
    $Hash{'Send me a notification if a ticket is unlocked by the system.'} = 'Zusenden einer Mitteilung wenn ein Ticket vom System freigegeben (unlocked) wird.';
    $Hash{'Send me a notification if there is a new ticket in my custom queues.'} = 'Zusenden einer Mitteilung bei neuem Ticket in der/den individuellen Queue(s).';
    $Hash{'Ticket lock timeout notification'} = 'Mitteilung bei lock Zeitüberschreitung';

    # Template: AAATicket
    $Hash{'Action'} = 'Aktion';
    $Hash{'Age'} = 'Alter';
    $Hash{'Article'} = 'Artikel';
    $Hash{'Attachment'} = 'Anlage';
    $Hash{'Attachments'} = 'Anlagen';
    $Hash{'Bcc'} = '';
    $Hash{'Bounce'} = '';
    $Hash{'Cc'} = '';
    $Hash{'Close'} = 'Schließen';
    $Hash{'closed succsessful'} = 'erfolgreich geschlossen';
    $Hash{'closed unsuccsessful'} = 'erfolglos geschlossen';
    $Hash{'Compose'} = 'Verfassen';
    $Hash{'Created'} = 'Erstellt';
    $Hash{'Createtime'} = 'Erstellt am';
    $Hash{'eMail'} = '';
    $Hash{'email'} = 'eMail';
    $Hash{'email-external'} = 'Email an extern';
    $Hash{'email-internal'} = 'Email an intern';
    $Hash{'Forward'} = 'Weiterleiten';
    $Hash{'From'} = 'Von';
    $Hash{'high'} = 'hoch';
    $Hash{'History'} = '';
    $Hash{'If it is not displayed correctly,'} = 'Wenn sie nicht korrekt angezeigt wird,';
    $Hash{'Lock'} = 'Ziehen';
    $Hash{'low'} = 'niedrig';
    $Hash{'Move'} = 'Verschieben';
    $Hash{'new'} = 'neu';
    $Hash{'normal'} = 'normal';
    $Hash{'note-external'} = 'Notiz für extern';
    $Hash{'note-internal'} = 'Notiz für intern';
    $Hash{'note-report'} = 'Notiz für reporting';
    $Hash{'open'} = 'offen';
    $Hash{'Owner'} = 'Besitzer';
    $Hash{'Pending'} = 'Warten';
    $Hash{'phone'} = 'Telefon';
    $Hash{'plain'} = 'klar';
    $Hash{'Priority'} = 'Priorität';
    $Hash{'Queue'} = '';
    $Hash{'removed'} = 'entfernt';
    $Hash{'Sender'} = 'Sender';
    $Hash{'sms'} = '';
    $Hash{'State'} = 'Status';
    $Hash{'Subject'} = 'Betreff';
    $Hash{'This is a'} = 'Dies ist eine';
    $Hash{'This is a HTML email. Click here to show it.'} = 'Dies ist eine HTML eMail. Hier klicken um sie anzusehen.';
    $Hash{'This message was written in a character set other than your own.'} = 'Diese Nachricht wurde in einem Zeichensatz erstellt, der nicht Ihrem eigenen entspricht.';
    $Hash{'Ticket'} = 'Ticket';
    $Hash{'To'} = 'An';
    $Hash{'to open it in a new window.'} = 'um sie in einem neuen Fenster angezeigt zu bekommen';
    $Hash{'Unlock'} = 'Freigeben';
    $Hash{'very high'} = 'sehr hoch';
    $Hash{'very low'} = 'sehr niedrig';
    $Hash{'View'} = 'Ansicht';
    $Hash{'webrequest'} = 'Webanfrage';
    $Hash{'Zoom'} = 'Inhalt';

    # Template: AdminAutoResponseForm
    $Hash{'Add auto response'} = 'Auto-Antwort hinzufügen';
    $Hash{'Auto Response From'} = 'Auto-Antwort Form';
    $Hash{'Auto Response Management'} = 'Auto-Antworten Verwaltung';
    $Hash{'Change auto response settings'} = 'Ändern einer Auto-Antworten';
    $Hash{'Charset'} = '';
    $Hash{'Note'} = 'Notiz';
    $Hash{'Response'} = 'Antwort';
    $Hash{'to get the first 20 character of the subject'} = 'Um die ersten 20 Zeichen des Betreffs zu bekommen';
    $Hash{'to get the first 5 lines of the email'} = 'Um die ersten 5 Zeilen der eMail zu bekommen';
    $Hash{'Type'} = '';
    $Hash{'Useable options'} = 'Benutzbare Optionen';

    # Template: AdminCharsetForm
    $Hash{'Add charset'} = 'Charset hinzufügen';
    $Hash{'Change system charset setting'} = 'Ändere System-Charset';
    $Hash{'System Charset Management'} = 'System-Charset Verwaltung';

    # Template: AdminCustomerUserForm
    $Hash{'Add customer user'} = 'Hinzufügen eines Kunden-Benutzers';
    $Hash{'Change customer user settings'} = 'Ämdern der Kunden-Benutzers einstellungen';
    $Hash{'Customer User Management'} = 'Kunden-Benutzer Management';
    $Hash{'Customer user will be needed to to login via customer panels.'} = 'Kunden-Benutzer werden für das Kunden-Webfrontend benötigt';
    $Hash{'CustomerID'} = 'Kunden#';
    $Hash{'Email'} = 'eMail';
    $Hash{'Firstname'} = 'Vorname';
    $Hash{'Lastname'} = 'Nachname';
    $Hash{'Login'} = '';

    # Template: AdminCustomerUserPreferencesGeneric

    # Template: AdminEmail
    $Hash{'Admin-Email'} = '';
    $Hash{'Body'} = '';
    $Hash{'OTRS-Admin Info!'} = '';
    $Hash{'Recipents'} = 'Empfänger';

    # Template: AdminEmailSent
    $Hash{'Message sent to'} = 'Nachricht gesendet an';

    # Template: AdminGroupForm
    $Hash{'Add group'} = 'Gruppe hinzufügen';
    $Hash{'Change group settings'} = 'Ändern einer Gruppe';
    $Hash{'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).'} = 'Erstelle neue Gruppen um die Zugriffe für verschieden Agent-Gruppen zu definieren (z. B. Einkaufs-Abteilung, Support-Abteilung, Verkaufs-Abteilung, ...).';
    $Hash{'Group Management'} = 'Gruppen Verwaltung';
    $Hash{'It\'s useful for ASP solutions.'} = 'Sehr nützlich für ASP-Lösungen.';
    $Hash{'The admin group is to get in the admin area and the stats group to get stats area.'} = 'Die admin Gruppe wird für den Admin-Bereich benötigt, die stats Gruppe für den Statistik-Bereich.';

    # Template: AdminLanguageForm
    $Hash{'Add language'} = 'Sprache hinzufügen';
    $Hash{'Change system language setting'} = 'Ändere System-Sprache';
    $Hash{'System Language Management'} = 'System-Sprache Verwaltung';

    # Template: AdminNavigationBar
    $Hash{'AdminEmail'} = '';
    $Hash{'AgentFrontend'} = 'AgentOberfläche';
    $Hash{'Auto Response <-> Queue'} = 'Auto-Antworten <-> Queues';
    $Hash{'Auto Responses'} = 'Auto-Antworten';
    $Hash{'Charsets'} = '';
    $Hash{'CustomerUser'} = 'Kunden-Benutzer';
    $Hash{'Email Addresses'} = 'Email-Adressen';
    $Hash{'Groups'} = 'Gruppen';
    $Hash{'Logout'} = 'Abmelden';
    $Hash{'Responses'} = 'Antworten';
    $Hash{'Responses <-> Queue'} = 'Antworten <-> Queues';
    $Hash{'Select Box'} = '';
    $Hash{'Session Management'} = 'Sitzungs Verwaltung';
    $Hash{'Status defs'} = '';
    $Hash{'User <-> Groups'} = 'Benutzer <-> Gruppen';

    # Template: AdminQueueAutoResponseForm
    $Hash{'Queue <-> Auto Response Management'} = 'Queue <-> Auto-Antworten Verwaltung';

    # Template: AdminQueueAutoResponseTable

    # Template: AdminQueueForm
    $Hash{'0 = no escalation'} = '0 = keine Eskalation';
    $Hash{'0 = no unlock'} = '0 = kein Unlock';
    $Hash{'Add queue'} = 'Queue hinzufügen';
    $Hash{'Change queue settings'} = 'Ändern einer Queue';
    $Hash{'Escalation time'} = 'Eskalationszeit';
    $Hash{'Follow up Option'} = '';
    $Hash{'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.'} = 'Wenn ein Ticket geschlossen ist und der Kunde jedoch ein follow up sendet, wird das ticket für den alten Eigner gelocked.';
    $Hash{'If a ticket will not be answered in thos time, just only this ticket will be shown.'} = 'Wird ein Ticket nicht in jener Zeit beantortet, wird nur noch dieses Ticket gezeigt.';
    $Hash{'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.'} = 'Wird ein Ticket durch einen Agent gelocked jedoch nicht in dieser Zeit beantwortet, wird das Ticket automatisch unlocked.';
    $Hash{'Key'} = 'Schlüssel';
    $Hash{'Queue Management'} = 'Queue Verwaltung';
    $Hash{'Systemaddress'} = 'System-Adresse';
    $Hash{'The salutation for email answers.'} = 'Die Anrede für eMail Antworten.';
    $Hash{'The signature for email answers.'} = 'Die Signatur für eMail Antworten.';
    $Hash{'Ticket lock after a follow up'} = 'Ticket locken nache einem follow up';
    $Hash{'Unlock timeout'} = 'Freigabe Zeitüberschreitung';
    $Hash{'Will be the sender address of this queue for email answers.'} = 'Absende Adresse für eMails aus dieser Queue.';

    # Template: AdminQueueResponsesChangeForm
    $Hash{'Change %s settings'} = 'Ändern der %s Einstellungen';
    $Hash{'Std. Responses <-> Queue Management'} = 'Std. Antworten <-> Queue Verwaltung';

    # Template: AdminQueueResponsesForm
    $Hash{'Answer'} = 'Antwort';
    $Hash{'Change answer <-> queue settings'} = 'Ändern der Antworten <-> Queue Beziehung';

    # Template: AdminResponseForm
    $Hash{'A response is default text to write faster answer (with default text) to customers.'} = 'Eine Antwort ist ein vorgegebener Text um schneller Antworten an Kundern schreiben zu können.';
    $Hash{'Add response'} = 'Antwort hinzufügen';
    $Hash{'Change response settings'} = 'Ändern einer Antwort';
    $Hash{'Don\'t forget to add a new response a queue!'} = 'Eine neue Antwort muss auch einer Queue zugewiesen werden!';
    $Hash{'Response Management'} = 'Antworten Verwaltung';

    # Template: AdminSalutationForm
    $Hash{'Add salutation'} = 'Anrede hinzufügen';
    $Hash{'Change salutation settings'} = 'Ändern einer Anrede';
    $Hash{'customer realname'} = 'echter Kundenname';
    $Hash{'Salutation Management'} = 'Anreden Verwaltung';

    # Template: AdminSelectBoxForm
    $Hash{'Max Rows'} = 'Max. Zeile';

    # Template: AdminSelectBoxResult
    $Hash{'Limit'} = '';
    $Hash{'Select Box Result'} = 'Select Box Ergebnis';
    $Hash{'SQL'} = '';

    # Template: AdminSession
    $Hash{'kill all sessions'} = 'Löschen alles Sitzungen';

    # Template: AdminSessionTable
    $Hash{'kill session'} = 'Sitzung löschen';
    $Hash{'SessionID'} = '';

    # Template: AdminSignatureForm
    $Hash{'Add signature'} = 'Signatur hinzufügen';
    $Hash{'Change signature settings'} = 'Ändern einer Signatur';
    $Hash{'for agent firstname'} = 'für Vorname des Agents';
    $Hash{'for agent lastname'} = 'für Nachname des Agents';
    $Hash{'Signature Management'} = 'Signatur Verwaltung';

    # Template: AdminStateForm
    $Hash{'Add state'} = 'State hinzufügen';
    $Hash{'Change system state setting'} = 'Ändere System-State';
    $Hash{'System State Management'} = 'System-State Verwaltung';

    # Template: AdminSystemAddressForm
    $Hash{'Add system address'} = 'System-Email-Adresse hinzufügen';
    $Hash{'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!'} = 'Alle eingehenden Emails mit dem "To:" werden in die ausgewählte Queue einsortiert.';
    $Hash{'Change system address setting'} = 'Ändere System-Adresse';
    $Hash{'Realname'} = '';
    $Hash{'System Email Addresses Management'} = 'System-Email-Adressen Verwaltung';

    # Template: AdminUserForm
    $Hash{'Add user'} = 'Benutzer hinzufügen';
    $Hash{'Change user settings'} = 'Ändern der Benutzereinstellung';
    $Hash{'Don\'t forget to add a new user to groups!'} = 'Eine neuer Benutzer muss auch einer Gruppe zugewiesen werden!';
    $Hash{'User Management'} = 'Benutzer Verwaltung';
    $Hash{'User will be needed to handle tickets.'} = 'Benutzer werden benötigt um Tickets zu bearbeietn.';

    # Template: AdminUserGroupChangeForm
    $Hash{'Change  settings'} = '';
    $Hash{'User <-> Group Management'} = 'Benutzer <-> Gruppe Verwaltung';

    # Template: AdminUserGroupForm
    $Hash{'Change user <-> group settings'} = 'Ändern der Benutzer <-> Gruppe Beziehung';

    # Template: AdminUserPreferencesGeneric

    # Template: AgentBounce
    $Hash{'A message should have a To: recipient!'} = 'Eine Nachricht sollte einen Empfänger im An: haben!';
    $Hash{'Bounce ticket'} = '';
    $Hash{'Bounce to'} = 'Bounce an';
    $Hash{'Inform sender'} = 'Sender informieren';
    $Hash{'Next ticket state'} = 'Nächster Status des Tickets';
    $Hash{'Send mail!'} = 'Mail senden!';
    $Hash{'You need a email address (e. g. customer@example.com) in To:!'} = 'Im An-Feld wird eine eMail-Adresse (z. B. kunde@beispiel.de) benötigt!';
    $Hash{'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further inforamtions.'} = '';

    # Template: AgentClose
    $Hash{' (work units)'} = '';
    $Hash{'Close ticket'} = 'Ticket schließen';
    $Hash{'Close type'} = 'Schließen Type';
    $Hash{'Close!'} = 'Schließen!';
    $Hash{'Note Text'} = 'Notiz Text';
    $Hash{'Note type'} = 'Notiz-Typ';
    $Hash{'store'} = 'speichern';
    $Hash{'Time units'} = 'Zeit-Einheiten';

    # Template: AgentCompose
    $Hash{'A message should have a subject!'} = 'Eine Nachricht sollte ein Betreff haben!';
    $Hash{'Attach'} = 'Anhängen';
    $Hash{'Compose answer for ticket'} = 'Antwort erstellen für';
    $Hash{'Is the ticket answered'} = 'Ist das Ticket beantwortet';
    $Hash{'Options'} = 'Optionen';
    $Hash{'Spell Check'} = 'Rechtschreibkontrolle';

    # Template: AgentCustomer
    $Hash{'Back'} = 'zurück';
    $Hash{'Change customer of ticket'} = 'Ändern des Kunden von Ticket';
    $Hash{'Set customer id of a ticket'} = 'Setze eine Kunden# zu einem Ticket';

    # Template: AgentCustomerHistory
    $Hash{'Customer history'} = 'Kunden History';

    # Template: AgentCustomerHistoryTable

    # Template: AgentForward
    $Hash{'Article type'} = 'Artikel-Typ';
    $Hash{'Date'} = 'Datum';
    $Hash{'End forwarded message'} = '';
    $Hash{'Forward article of ticket'} = 'Weiterleitung des Artikels vom Ticket';
    $Hash{'Forwarded message from'} = '';
    $Hash{'Reply-To'} = '';

    # Template: AgentHistoryForm
    $Hash{'History of'} = 'History von';

    # Template: AgentMailboxTicket
    $Hash{'Add Note'} = 'Notiz anheften';

    # Template: AgentNavigationBar
    $Hash{'FAQ'} = '';
    $Hash{'Locked tickets'} = 'Eigene Tickets';
    $Hash{'new message'} = 'neue Nachricht';
    $Hash{'PhoneView'} = 'Telefon-Ansicht';
    $Hash{'Preferences'} = 'Einstellungen';
    $Hash{'Utilities'} = 'Werkzeuge';

    # Template: AgentNote
    $Hash{'Add note to ticket'} = 'Anheften einer Notiz an Ticket';
    $Hash{'Note!'} = 'Notiz!';

    # Template: AgentOwner
    $Hash{'Change owner of ticket'} = 'Ändern Eigners von Ticket';
    $Hash{'Message for new Owner'} = 'Nachricht an neuen Eigner';
    $Hash{'New user'} = 'Neuer Eigner';

    # Template: AgentPhone
    $Hash{'Customer called'} = 'Kunden angerufen';
    $Hash{'Phone call'} = 'Anruf';
    $Hash{'Phone call at %s'} = 'Anruf um %s';

    # Template: AgentPhoneNew
    $Hash{'A message should have a From: recipient!'} = 'Eine Nachricht sollte einen Absender im Von: haben!';
    $Hash{'new ticket'} = 'neues Ticket';
    $Hash{'New ticket via call.'} = 'Neues Ticket durch Anruf.';
    $Hash{'You need a email address (e. g. customer@example.com) in From:!'} = 'Im From-Feld wird eine eMail-Adresse (z. B. kunde@beispiel.de) benötigt!';

    # Template: AgentPlain
    $Hash{'ArticleID'} = '';
    $Hash{'Plain'} = '';
    $Hash{'TicketID'} = '';

    # Template: AgentPreferencesCustomQueue
    $Hash{'Select your custom queues'} = 'Bevorzugte Queues auswählen';

    # Template: AgentPreferencesForm

    # Template: AgentPreferencesGeneric

    # Template: AgentPreferencesPassword
    $Hash{'Change Password'} = 'Passwort ändern';
    $Hash{'New password'} = 'Neues Passwort';
    $Hash{'New password again'} = 'Neues Passwort wiederholen';

    # Template: AgentPriority
    $Hash{'Change priority of ticket'} = 'Priorität ändern für Ticket';
    $Hash{'New state'} = 'Neue Priorität';

    # Template: AgentSpelling
    $Hash{'Apply these changes'} = 'Änderungen übernehmen';
    $Hash{'Discard all changes and return to the compose screen'} = 'Verwerfen aller Änderungen und zurück zum Verfassen-Fenster';
    $Hash{'Return to the compose screen'} = 'Zurück zum Verfassen-Fenster';
    $Hash{'Spell Checker'} = 'Rechtschreibkontrolle';
    $Hash{'spelling error(s)'} = 'Rechtschreibfehler';
    $Hash{'The message being composed has been closed.  Exiting.'} = 'Die erstellte Nachricht wurde geschlossen.';
    $Hash{'This window must be called from compose window'} = 'Dieses Fenster muss über das Verfassen-Fenster aufgerufen werden';

    # Template: AgentStatusView
    $Hash{'D'} = '';
    $Hash{'sort downward'} = 'Sortierung abwärts';
    $Hash{'sort upward'} = 'Sortierung aufwärts';
    $Hash{'Ticket limit:'} = '';
    $Hash{'Ticket Status'} = '';
    $Hash{'U'} = '';

    # Template: AgentStatusViewTable

    # Template: AgentStatusViewTableNotAnswerd

    # Template: AgentTicketLocked
    $Hash{'Ticket locked!'} = 'Ticket gesperrt!';
    $Hash{'unlock'} = 'freigeben';

    # Template: AgentUtilSearchByCustomerID
    $Hash{'Customer history search'} = 'Kunden-History-Suche';
    $Hash{'Customer history search (e. g. "ID342425").'} = 'Kunden History Suche (z. B. "ID342425").';
    $Hash{'No * possible!'} = 'Kein * möglich!';

    # Template: AgentUtilSearchByText
    $Hash{'Article free text'} = '';
    $Hash{'Fulltext search'} = 'Volltext-Suche';
    $Hash{'Fulltext search (e. g. "Mar*in" or "Baue*" or "martin+hallo")'} = 'Volltextsuche (z. B. "Mar*in" oder "Baue*" oder "martin+hallo")';
    $Hash{'Search in'} = 'Suche in';
    $Hash{'Ticket free text'} = '';

    # Template: AgentUtilSearchByTicketNumber
    $Hash{'search'} = 'Suchen';
    $Hash{'search (e. g. 10*5155 or 105658*)'} = 'Suche (z. B. 10*5155 or 105658*)';

    # Template: AgentUtilSearchNavBar
    $Hash{'Results'} = 'Ergebnis';
    $Hash{'Site'} = 'Seite';
    $Hash{'Total hits'} = 'Treffer gesamt';

    # Template: AgentUtilSearchResult

    # Template: AgentUtilTicketStatus
    $Hash{'All open tickets'} = 'Alle offenen Tickets';
    $Hash{'open tickets'} = 'offene Tickets';
    $Hash{'Provides an overview of all'} = 'Bietet eine Übersicht von allen';
    $Hash{'So you see what is going on in your system.'} = 'Somit können Sie sehen, was in Ihrem System vorgeht.';

    # Template: CustomerCreateAccount
    $Hash{'Create'} = 'Erstellen';
    $Hash{'Create Account'} = 'Account erstellen';

    # Template: CustomerError
    $Hash{'Backend'} = '';
    $Hash{'BackendMessage'} = '';
    $Hash{'Click here to report a bug!'} = 'Klicken Sie hier um einen Fehler zu berichten!';
    $Hash{'Handle'} = '';

    # Template: CustomerFooter
    $Hash{'Powered by'} = '';

    # Template: CustomerHeader

    # Template: CustomerLogin

    # Template: CustomerLostPassword
    $Hash{'Lost your password?'} = 'Passwort verloren?';
    $Hash{'Request new password'} = 'Neues Passwort beantragen';

    # Template: CustomerMessage
    $Hash{'Follow up'} = '';

    # Template: CustomerMessageNew

    # Template: CustomerNavigationBar
    $Hash{'Create new Ticket'} = 'Neues Ticket erstellen';
    $Hash{'My Tickets'} = 'Meine Tickets';
    $Hash{'New Ticket'} = 'neues Ticket';
    $Hash{'Ticket-Overview'} = 'Ticket-Übersicht';
    $Hash{'Welcome %s'} = 'Willkommen %s';

    # Template: CustomerPreferencesForm

    # Template: CustomerPreferencesGeneric

    # Template: CustomerPreferencesPassword

    # Template: CustomerStatusView

    # Template: CustomerStatusViewTable

    # Template: CustomerTicketZoom
    $Hash{'Accounted time'} = 'Zugewiesene Zeit';

    # Template: CustomerWarning

    # Template: Error

    # Template: Footer

    # Template: Header
    $Hash{'Home'} = '';

    # Template: InstallerStart
    $Hash{'next step'} = 'Nächster Schritt';

    # Template: InstallerSystem

    # Template: Login

    # Template: LostPassword

    # Template: NoPermission
    $Hash{'No Permission'} = 'Keine Erlaubnis';

    # Template: Notify
    $Hash{'Info'} = '';

    # Template: QueueView
    $Hash{'All tickets'} = 'Alle Tickets';
    $Hash{'Queues'} = 'Queues';
    $Hash{'Show all'} = 'Alle gezeigt';
    $Hash{'Ticket available'} = 'Ticket verfügbar';
    $Hash{'tickets'} = 'Tickets';
    $Hash{'Tickets shown'} = 'Tickets gezeigt';

    # Template: SystemStats
    $Hash{'Graphs'} = 'Diagramme';
    $Hash{'Tickets'} = '';

    # Template: Test
    $Hash{'OTRS Test Page'} = 'OTRS Test Seite';

    # Template: TicketEscalation
    $Hash{'Ticket escalation!'} = 'Ticket Eskalation!';

    # Template: TicketView
    $Hash{'Change queue'} = 'Wechsle Queue';
    $Hash{'Compose Answer'} = 'Antwort erstellen';
    $Hash{'Contact customer'} = 'Kunden kontaktieren';
    $Hash{'phone call'} = 'Anrufen';
    $Hash{'Time till escalation'} = 'Zeit bis zur Escalation';

    # Template: TicketViewLite

    # Template: TicketZoom

    # Template: TicketZoomNote

    # Template: TicketZoomSystem

    # Template: Warning

    # Misc
    $Hash{'(Click here to add a group)'} = '(Hier klicken - Gruppe hinzufügen)';
    $Hash{'(Click here to add a queue)'} = '(Hier klicken - Queue hinzufügen)';
    $Hash{'(Click here to add a response)'} = '(Hier klicken - Antwort hinzufügen)';
    $Hash{'(Click here to add a salutation)'} = '(Hier klicken - Anrede hinzufügen)';
    $Hash{'(Click here to add a signature)'} = '(Hier klicken - Signatur hinzufügen)';
    $Hash{'(Click here to add a system email address)'} = '(Hier klicken - System-Email-Adresse hinzufügen)';
    $Hash{'(Click here to add a user)'} = '(Hier klicken - Benutzer hinzufügen)';
    $Hash{'(Click here to add an auto response)'} = '(Hier klicken - Auto-Antwort hinzufügen)';
    $Hash{'(Click here to add charset)'} = '(Hier klicken - Charset hinzufügen';
    $Hash{'(Click here to add language)'} = '(Hier klicken - Sprache hinzufügen)';
    $Hash{'(Click here to add state)'} = '(Hier klicken - state hinzufügen)';
    $Hash{'Update auto response'} = 'Auto-Antwort aktualisieren';
    $Hash{'Update charset'} = 'Charset aktualisieren';
    $Hash{'Update group'} = 'Gruppe aktualisieren';
    $Hash{'Update language'} = 'Sprache aktualisieren';
    $Hash{'Update queue'} = 'Queue aktualisieren';
    $Hash{'Update response'} = 'Antworten aktualisieren';
    $Hash{'Update salutation'} = 'Anrede aktualisieren';
    $Hash{'Update signature'} = 'Signatur aktualisieren';
    $Hash{'Update state'} = 'State aktualisieren';
    $Hash{'Update system address'} = 'System-Email-Adresse aktualisieren';
    $Hash{'Update user'} = 'Benutzer aktualisieren';
    $Hash{'You have to be in the admin group!'} = 'Sie müssen hierfür in der Admin-Gruppe sein!';
    $Hash{'You have to be in the stats group!'} = 'Sie müssen hierfür in der Statistik-Gruppe sein!';
    $Hash{'auto responses set'} = 'Auto-Antworten gesetzt';

    $Self->{Translation} = \%Hash;

}
# --
1;
