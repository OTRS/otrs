# --
# Kernel/Language/bb.pm - provides bb language translation
# Copyright (C) 2002 Martin Edenhofer <martin at otrs.org>
# --
# $Id: bb.pm,v 1.2 2002-12-15 00:58:22 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
package Kernel::Language::bb;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.2 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*\$/\$1/;
# --
sub Data {
    my $Self = shift;
    my %Param = @_;
    my %Hash = ();

    # possible charsets
    $Self->{Charset} = ['iso-8859-1', 'iso-8859-15', ];

    # Template: AAABasics
    $Hash{' 2 minutes'} = ' 2 Minutn';
    $Hash{' 5 minutes'} = ' 5 Minutn';
    $Hash{' 7 minutes'} = ' 7 Minutn';
    $Hash{'10 minutes'} = '10 Minutn';
    $Hash{'15 minutes'} = '15 Minutn';
    $Hash{'AddLink'} = 'Link hinzufügen';
    $Hash{'AdminArea'} = 'AdminBereich';
    $Hash{'all'} = 'alle';
    $Hash{'All'} = 'All';
    $Hash{'Attention'} = 'Achtung';
    $Hash{'Bug Report'} = 'Fehler berichten';
    $Hash{'Cancel'} = 'Zruck';
    $Hash{'change'} = 'ändern';
    $Hash{'Change'} = 'Ändern';
    $Hash{'change!'} = 'ändern!';
    $Hash{'click here'} = 'klick hier';
    $Hash{'Comment'} = 'Kommentar';
    $Hash{'Customer'} = 'Kunde';
    $Hash{'Customer info'} = 'Kundn Info';
    $Hash{'day'} = 'Tag';
    $Hash{'days'} = 'Tage';
    $Hash{'Description'} = 'Beschreibung';
    $Hash{'description'} = 'Beschreibung';
    $Hash{'Done'} = 'Weider';
    $Hash{'end'} = 'runter';
    $Hash{'Error'} = 'Fehler';
    $Hash{'Example'} = 'Beispiel';
    $Hash{'Examples'} = 'Beispiele';
    $Hash{'go'} = 'weider';
    $Hash{'go!'} = 'weider!';
    $Hash{'Group'} = 'Gruppe';
    $Hash{'Hit'} = 'Troffer';
    $Hash{'Hits'} = 'Troffer';
    $Hash{'hour'} = 'Stunde';
    $Hash{'hours'} = 'Stunden';
    $Hash{'Ignore'} = 'Nix do';
    $Hash{'Language'} = 'Sprache';
    $Hash{'Languages'} = 'Sprachen';
    $Hash{'Line'} = 'Zeile';
    $Hash{'Logout successful. Thank you for using OTRS!'} = 'Servus. Dei OTRS!';
    $Hash{'Message'} = 'Nachricht';
    $Hash{'minute'} = 'Minute';
    $Hash{'minutes'} = 'Minutn';
    $Hash{'Module'} = 'Modul';
    $Hash{'Modulefile'} = 'Moduldatei';
    $Hash{'Name'} = 'Name';
    $Hash{'New message'} = 'Neue Nachricht';
    $Hash{'New message!'} = 'Neue Nachricht!';
    $Hash{'no'} = 'kein';
    $Hash{'No'} = 'Na';
    $Hash{'No suggestions'} = 'Nix do';
    $Hash{'none'} = 'koane';
    $Hash{'none - answered'} = 'koane - beantwortet';
    $Hash{'none!'} = 'koane Angabe!';
    $Hash{'off'} = 'aus';
    $Hash{'Off'} = 'Aus';
    $Hash{'On'} = 'Ein';
    $Hash{'on'} = 'ein';
    $Hash{'Password'} = 'Passwort';
    $Hash{'Please answer this ticket(s) to get back to the normal queue view!'} = 'Bitte eskalierte Tickets beantworten um in die normale Queue-Ansicht zurück zu kommen!';
    $Hash{'please do not edit!'} = 'Bitte nicht verändern!';
    $Hash{'QueueView'} = 'Queue-Ansicht';
    $Hash{'replace with'} = 'tauchn mit';
    $Hash{'Reset'} = 'Nix do';
    $Hash{'Salutation'} = 'Anrede';
    $Hash{'Signature'} = 'Signatur';
    $Hash{'Sorry'} = 'Bedauere';
    $Hash{'Stats'} = 'Statistik';
    $Hash{'Subfunction'} = 'Unterfunktion';
    $Hash{'submit'} = 'weider';
    $Hash{'submit!'} = 'übermitteln!';
    $Hash{'Text'} = '';
    $Hash{'The recommended charset for your language is %s!'} = 'Dei charset für die Sprach sollte %s sei!';
    $Hash{'top'} = 'hou';
    $Hash{'update'} = 'basst scho';
    $Hash{'update!'} = 'basst scho!';
    $Hash{'User'} = 'Benutzer';
    $Hash{'Username'} = 'Benutzername';
    $Hash{'Valid'} = 'Gültig';
    $Hash{'Warning'} = 'Forsicht';
    $Hash{'Welcome to OTRS'} = 'Dei OTRS';
    $Hash{'Word'} = 'Wort';
    $Hash{'wrote'} = 'hod gschrim';
    $Hash{'yes'} = 'ja';
    $Hash{'Yes'} = 'Ja';
    $Hash{'You got new message!'} = 'Neie Nachtricht grikt';

    # Template: AAAPreferences
    $Hash{'Custom Queue'} = '';
    $Hash{'Follow up notification'} = 'Follow up Nachricht';
    $Hash{'Frontend'} = '';
    $Hash{'Mail Management'} = '';
    $Hash{'Move notification'} = 'Move Nachricht';
    $Hash{'New ticket notification'} = 'Neis Ticket Nachricht';
    $Hash{'Other Options'} = 'Andre Sachan';
    $Hash{'Preferences updated successfully!'} = 'Einstellungen bassan jetztat';
    $Hash{'QueueView refresh time'} = 'Queue-Ansicht refresh Zeit';
    $Hash{'Select your frontend Charset.'} = 'Suach Dei Fronten-Charset aus';
    $Hash{'Select your frontend language.'} = 'Suach da Dei Sprach aus';
    $Hash{'Select your frontend QueueView.'} = 'Suach da Dei Queue-Ansicht aus';
    $Hash{'Select your frontend Theme.'} = 'Suach da Dei Theme aus';
    $Hash{'Select your QueueView refresh time.'} = 'Suach da Dei Queue-Ansicht refresh Zeit aus';
    $Hash{'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.'} = 'Zusenden einer Mitteilung wenn ein Kundn eine Nachfrage stellt uns ich der Eigner bin.';
    $Hash{'Send me a notification if a ticket is moved into a custom queue.'} = 'Schik ma a Nachricht wenn a ticket is verschobm in mei Custom-Queue';
    $Hash{'Send me a notification if a ticket is unlocked by the system.'} = 'Schik ma a Nachricht wenn a ticket is unlocked';
    $Hash{'Send me a notification if there is a new ticket in my custom queues.'} = 'Zusenden einer Mitteilung bei neuem Ticket in der/den individuellen Queue(s).';
    $Hash{'Ticket lock timeout notification'} = ' Ticker lock Zeitaus Nachricht';

    # Template: AAATicket
    $Hash{'Action'} = 'Aktion';
    $Hash{'Age'} = 'Alter';
    $Hash{'Article'} = 'Artikel';
    $Hash{'Attachment'} = 'Anlage';
    $Hash{'Attachments'} = 'Anhangsl';
    $Hash{'Bcc'} = '';
    $Hash{'Bounce'} = 'Bounce';
    $Hash{'Cc'} = 'Cc';
    $Hash{'Close'} = 'Schließen';
    $Hash{'closed successful'} = 'erfolgreich geschlossen';
    $Hash{'closed unsuccessful'} = 'erfolglos geschlossen';
    $Hash{'Compose'} = 'schreim';
    $Hash{'Created'} = 'gschrim';
    $Hash{'Createtime'} = 'gschrim am';
    $Hash{'eMail'} = '';
    $Hash{'email'} = 'eMail';
    $Hash{'email-external'} = 'Email an extern';
    $Hash{'email-internal'} = 'Email an intern';
    $Hash{'Forward'} = 'Weidaleiten';
    $Hash{'From'} = 'Vom';
    $Hash{'high'} = 'hou';
    $Hash{'History'} = 'History';
    $Hash{'If it is not displayed correctly,'} = 'Wenn sie nicht korrekt angoagt wird,';
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
    $Hash{'This message was written in a character set other than your own.'} = 'Dei Nachricht wurde in einem Zeichensatz gschrim, der nicht Deim eigenen entspricht.';
    $Hash{'Ticket'} = 'Ticket';
    $Hash{'To'} = 'An';
    $Hash{'to open it in a new window.'} = 'um sie in einem neuen Fenster angoagt zu bekommen';
    $Hash{'Unlock'} = 'Freigeben';
    $Hash{'very high'} = 'gscheid hou';
    $Hash{'very low'} = 'gscheid niedrig';
    $Hash{'View'} = 'Ansicht';
    $Hash{'webrequest'} = '';
    $Hash{'Zoom'} = 'Inhalt';

    # Template: AdminAutoResponseForm
    $Hash{'Add auto response'} = 'Auto-Antwort hinzufügen';
    $Hash{'Auto Response From'} = 'Auto-Antworten Form';
    $Hash{'Auto Response Management'} = 'Auto-Antworten Verwaltung';
    $Hash{'Change auto response settings'} = 'Ändern einer Auto-Antworten';
    $Hash{'Charset'} = '';
    $Hash{'Note'} = 'Notiz';
    $Hash{'Response'} = 'Antwort';
    $Hash{'to get the first 20 character of the subject'} = '';
    $Hash{'to get the first 5 lines of the email'} = '';
    $Hash{'Type'} = '';
    $Hash{'Useable options'} = 'Benutzbare Optionen';

    # Template: AdminCharsetForm
    $Hash{'Add charset'} = 'Charset hinzufügen';
    $Hash{'Change system charset setting'} = 'Ändere System-Charset';
    $Hash{'System Charset Management'} = 'System-Charset Verwaltung';

    # Template: AdminCustomerUserForm
    $Hash{'Add customer user'} = 'Kundn User hinzufügen';
    $Hash{'Change customer user settings'} = 'Kundn User ändern';
    $Hash{'Customer User Management'} = 'Kundn User Management';
    $Hash{'Customer user will be needed to to login via customer panels.'} = '';
    $Hash{'CustomerID'} = 'Kundn#';
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
    $Hash{'Message sent to'} = 'Verschikt zu';

    # Template: AdminGroupForm
    $Hash{'Add group'} = 'Gruppe hinzufügen';
    $Hash{'Change group settings'} = 'Ändern einer Gruppe';
    $Hash{'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).'} = 'Erstelle neue Gruppen um die Zugriffe für verschieden Agent-Gruppen zu definieren (z. B. Einkaufs-Abteilung, Support-Abteilung, Verkaufs-Abteilung, ...).';
    $Hash{'Group Management'} = 'Gruppen Verwaltung';
    $Hash{'It\'s useful for ASP solutions.'} = 'gscheid nützlich für ASP-Lösungen.';
    $Hash{'The admin group is to get in the admin area and the stats group to get stats area.'} = 'Die admin Gruppe wird für den Admin-Bereich benötigt, die stats Gruppe für den Statistik-Bereich.';

    # Template: AdminLanguageForm
    $Hash{'Add language'} = 'Sprache hinzufügen';
    $Hash{'Change system language setting'} = 'Ändere System-Sprache';
    $Hash{'System Language Management'} = 'System-Sprache Verwaltung';

    # Template: AdminNavigationBar
    $Hash{'AdminEmail'} = '';
    $Hash{'AgentFrontend'} = 'AgentOberfläche';
    $Hash{'Auto Response <-> Queue'} = '';
    $Hash{'Auto Responses'} = 'Auto-Antworten';
    $Hash{'Charsets'} = '';
    $Hash{'CustomerUser'} = 'Kundn User';
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
    $Hash{'0 = no escalation'} = '0 = nix Eskalation';
    $Hash{'0 = no unlock'} = '0 = nix unlock';
    $Hash{'Add queue'} = 'Queue hinzufügen';
    $Hash{'Change queue settings'} = 'Ändern einer Queue';
    $Hash{'Escalation time'} = 'Eskalationszeit';
    $Hash{'Follow up Option'} = '';
    $Hash{'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.'} = '';
    $Hash{'If a ticket will not be answered in thos time, just only this ticket will be shown.'} = '';
    $Hash{'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.'} = '';
    $Hash{'Key'} = 'Schlüssel';
    $Hash{'Queue Management'} = 'Queue Verwaltung';
    $Hash{'Systemaddress'} = '';
    $Hash{'The salutation for email answers.'} = '';
    $Hash{'The signature for email answers.'} = '';
    $Hash{'Ticket lock after a follow up'} = '';
    $Hash{'Unlock timeout'} = 'Freigabe Zeitüberschreitung';
    $Hash{'Will be the sender address of this queue for email answers.'} = '';

    # Template: AdminQueueResponsesChangeForm
    $Hash{'Change %s settings'} = 'Ändern von %s Einstellungen';
    $Hash{'Std. Responses <-> Queue Management'} = 'Std. Antworten <-> Queue Verwaltung';

    # Template: AdminQueueResponsesForm
    $Hash{'Answer'} = 'Antwortn';
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
    $Hash{'customer realname'} = 'echter Kundnname';
    $Hash{'Salutation Management'} = 'Anreden Verwaltung';

    # Template: AdminSelectBoxForm
    $Hash{'Max Rows'} = 'Max. Zeile';

    # Template: AdminSelectBoxResult
    $Hash{'Limit'} = '';
    $Hash{'Select Box Result'} = '';
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
    $Hash{'Bounce to'} = 'Bounce zu';
    $Hash{'Inform sender'} = '';
    $Hash{'Next ticket state'} = 'Nächster Status des Tickets';
    $Hash{'Send mail!'} = 'Mail senden!';
    $Hash{'You need a email address (e. g. customer@example.com) in To:!'} = 'Im An-Feld wird eine eMail-Adresse (z. B. kunde@beispiel.de) benötigt!';
    $Hash{'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further inforamtions.'} = '';

    # Template: AgentClose
    $Hash{' (work units)'} = '';
    $Hash{'Close ticket'} = '';
    $Hash{'Close type'} = '';
    $Hash{'Close!'} = '';
    $Hash{'Note Text'} = '';
    $Hash{'Note type'} = 'Notiz-Typ';
    $Hash{'store'} = 'speichern';
    $Hash{'Time units'} = '';

    # Template: AgentCompose
    $Hash{'A message should have a subject!'} = 'Eine Nachricht sollte ein Betreff haben!';
    $Hash{'Attach'} = 'Ohenga';
    $Hash{'Compose answer for ticket'} = 'Antwort schreim für';
    $Hash{'Is the ticket answered'} = 'Ticket beantwortet';
    $Hash{'Options'} = 'Optionn';
    $Hash{'Spell Check'} = 'Rechtschreib-Checker';

    # Template: AgentCustomer
    $Hash{'Back'} = 'zurück';
    $Hash{'Change customer of ticket'} = 'Änder Kundn vom Ticket';

    # Template: AgentCustomerHistoryTable

    # Template: AgentForward
    $Hash{'Article type'} = 'Artikel-Typ';
    $Hash{'Date'} = 'Datum';
    $Hash{'End forwarded message'} = '';
    $Hash{'Forward article of ticket'} = 'Weidaleitung des Artikels vom Ticket';
    $Hash{'Forwarded message from'} = '';
    $Hash{'Reply-To'} = '';

    # Template: AgentHistoryForm
    $Hash{'History of'} = 'Gschichtn';

    # Template: AgentMailboxTicket
    $Hash{'Add Note'} = 'Notiz anheften';

    # Template: AgentNavigationBar
    $Hash{'FAQ'} = '';
    $Hash{'Locked tickets'} = 'Eigene Tickets';
    $Hash{'new message'} = 'neue Nachricht';
    $Hash{'PhoneView'} = 'Telefon-Ansicht';
    $Hash{'Preferences'} = 'Einstellungen';
    $Hash{'Utilities'} = 'Werkzeige';

    # Template: AgentNote
    $Hash{'Add note to ticket'} = 'Anheften einer Notiz an Ticket';
    $Hash{'Note!'} = 'Notiz!';

    # Template: AgentOwner
    $Hash{'Change owner of ticket'} = 'Ändern des Eigners vom Ticket';
    $Hash{'Message for new Owner'} = 'Nachricht um neia Eigner';
    $Hash{'New user'} = 'Neier Benutzer';

    # Template: AgentPhone
    $Hash{'Customer called'} = 'Kundn angrufa';
    $Hash{'Phone call'} = 'Anruf';
    $Hash{'Phone call at %s'} = 'Angrufa um %s';

    # Template: AgentPhoneNew
    $Hash{'A message should have a From: recipient!'} = '';
    $Hash{'new ticket'} = 'Neis Ticket';
    $Hash{'New ticket via call.'} = 'Neis Ticket am Telefon.';
    $Hash{'You need a email address (e. g. customer@example.com) in From:!'} = '';

    # Template: AgentPlain
    $Hash{'ArticleID'} = '';
    $Hash{'Plain'} = 'Ungemustert';
    $Hash{'TicketID'} = '';

    # Template: AgentPreferencesCustomQueue
    $Hash{'Select your custom queues'} = 'Bevorzugte Queues wähln';

    # Template: AgentPreferencesForm

    # Template: AgentPreferencesGeneric

    # Template: AgentPreferencesPassword
    $Hash{'Change Password'} = 'Passwort ändern';
    $Hash{'New password'} = 'Neis Passwort';
    $Hash{'New password again'} = 'Neis Passwort wiederholen';

    # Template: AgentPriority
    $Hash{'Change priority of ticket'} = 'Priorität ändern für Ticket';
    $Hash{'New state'} = 'Neia Status';

    # Template: AgentSpelling
    $Hash{'Apply these changes'} = 'Duas endan';
    $Hash{'Discard all changes and return to the compose screen'} = 'Dua nix und zruck';
    $Hash{'Return to the compose screen'} = 'zruck';
    $Hash{'Spell Checker'} = 'Rechtschreib-Checker';
    $Hash{'spelling error(s)'} = 'Rechtschreib-Fella';
    $Hash{'The message being composed has been closed.  Exiting.'} = '';
    $Hash{'This window must be called from compose window'} = '';

    # Template: AgentStatusView
    $Hash{'D'} = '';
    $Hash{'sort downward'} = 'Sortierung abwärts';
    $Hash{'sort upward'} = 'Sortierung aufärts';
    $Hash{'Ticket limit:'} = '';
    $Hash{'Ticket Status'} = '';
    $Hash{'U'} = '';

    # Template: AgentStatusViewTable

    # Template: AgentStatusViewTableNotAnswerd

    # Template: AgentTicketLocked
    $Hash{'Ticket locked!'} = 'Ticket gesperrt!';
    $Hash{'unlock'} = 'freigeben';

    # Template: AgentUtilSearchByCustomerID
    $Hash{'Customer history search'} = 'Kundn-History-suacha';
    $Hash{'Customer history search (e. g. "ID342425").'} = 'Kundn History suacha (z. B. "ID342425").';
    $Hash{'No * possible!'} = 'Kein * möglich!';

    # Template: AgentUtilSearchByText
    $Hash{'Article free text'} = '';
    $Hash{'Fulltext search'} = 'Volltext-suacha';
    $Hash{'Fulltext search (e. g. "Mar*in" or "Baue*" or "martin+hallo")'} = 'Volltextsuacha (z. B. "Mar*in" oder "Baue*" oder "martin+hallo")';
    $Hash{'Search in'} = 'Sucha in';
    $Hash{'Ticket free text'} = '';

    # Template: AgentUtilSearchByTicketNumber
    $Hash{'search'} = 'suachan';
    $Hash{'search (e. g. 10*5155 or 105658*)'} = 'suacha (z. B. 10*5155 or 105658*)';

    # Template: AgentUtilSearchNavBar
    $Hash{'Results'} = 'Gfuntn';
    $Hash{'Site'} = 'Seitn';
    $Hash{'Total hits'} = 'Treffer gsamt';

    # Template: AgentUtilSearchResult

    # Template: AgentUtilTicketStatus
    $Hash{'All open tickets'} = 'Alle offna Tickets';
    $Hash{'open tickets'} = 'offne Tickets';
    $Hash{'Provides an overview of all'} = 'Gibt an Übersicht von allen';
    $Hash{'So you see what is going on in your system.'} = 'Damit Du sigst was Sache ist.';

    # Template: CustomerCreateAccount
    $Hash{'Create'} = 'Erstelln';
    $Hash{'Create Account'} = 'Account erstelln';

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
    $Hash{'Lost your password?'} = 'Passwort verschmissn?';
    $Hash{'Request new password'} = 'Neis Passwort wolln';

    # Template: CustomerMessage
    $Hash{'Follow up'} = '';

    # Template: CustomerMessageNew

    # Template: CustomerNavigationBar
    $Hash{'Create new Ticket'} = 'Erstll neis Ticket';
    $Hash{'My Tickets'} = '';
    $Hash{'New Ticket'} = 'Neis Ticket';
    $Hash{'Ticket-Overview'} = 'Alle Tickets';
    $Hash{'Welcome %s'} = 'Griaste %s';

    # Template: CustomerPreferencesForm

    # Template: CustomerPreferencesGeneric

    # Template: CustomerPreferencesPassword

    # Template: CustomerStatusView

    # Template: CustomerStatusViewTable

    # Template: CustomerTicketZoom
    $Hash{'Accounted time'} = 'Aufgschrime Zeit';

    # Template: CustomerWarning

    # Template: Error

    # Template: Footer

    # Template: Header
    $Hash{'Home'} = '';

    # Template: InstallerStart
    $Hash{'next step'} = 'Nexter Schritt';

    # Template: InstallerSystem

    # Template: Login

    # Template: LostPassword

    # Template: NoPermission
    $Hash{'No Permission'} = 'koane Erlaubnis';

    # Template: Notify
    $Hash{'Info'} = '';

    # Template: QueueView
    $Hash{'All tickets'} = 'Alle Tickets';
    $Hash{'Queues'} = 'Queues';
    $Hash{'Show all'} = 'Alle goagt';
    $Hash{'Ticket available'} = 'Ticket verfügbar';
    $Hash{'tickets'} = 'Tickets';
    $Hash{'Tickets shown'} = 'Tickets goagt';

    # Template: SystemStats
    $Hash{'Graphs'} = 'Diagramme';
    $Hash{'Tickets'} = '';

    # Template: Test
    $Hash{'OTRS Test Page'} = '';

    # Template: TicketEscalation
    $Hash{'Ticket escalation!'} = 'Ticket Eskalation!';

    # Template: TicketView
    $Hash{'Change queue'} = 'Wechsle Queue';
    $Hash{'Compose Answer'} = 'Antwort schreim';
    $Hash{'Contact customer'} = 'Kundn kontaktieren';
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
    $Hash{'Update auto response'} = 'Auto-Antwort basst scho';
    $Hash{'Update charset'} = 'Charset basst scho';
    $Hash{'Update group'} = 'Gruppe basst scho';
    $Hash{'Update language'} = 'Sprache basst scho';
    $Hash{'Update queue'} = 'Queue basst scho';
    $Hash{'Update response'} = 'Antworten basst scho';
    $Hash{'Update salutation'} = 'Anrede basst scho';
    $Hash{'Update signature'} = 'Signatur basst scho';
    $Hash{'Update state'} = 'State basst scho';
    $Hash{'Update system address'} = 'System-Email-Adresse basst scho';
    $Hash{'Update user'} = 'Benutzer basst scho';
    $Hash{'You have to be in the admin group!'} = 'Sie müssen hierfür in der Admin-Gruppe sein!';
    $Hash{'You have to be in the stats group!'} = 'Sie müssen hierfür in der Statistik-Gruppe sein!';
    $Hash{'auto responses set'} = 'Auto-Antworten gesetzt';

    $Self->{Translation} = \%Hash;

}
# --
1;
