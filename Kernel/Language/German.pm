# --
# German.pm - provides german languag translation
# Copyright (C) 2001-2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: German.pm,v 1.13 2002-05-14 02:19:49 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
package Kernel::Language::German;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.13 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

# --
sub Data {
    my $Self = shift;
    my %Param = @_;

    # --
    # some common words
    # --
    $Self->{Lock} = 'Ziehen';
    $Self->{Unlock} = 'Freigeben';
    $Self->{unlock} = 'freigeben';
    $Self->{Zoom} = 'Inhalt';
    $Self->{History} = 'History';
    $Self->{'Add Note'} = 'Notiz anheften';
    $Self->{Bounce} = 'Bounce';
    $Self->{Age} = 'Alter';
    $Self->{Priority} = 'Priorität';
    $Self->{State} = 'Status';
    $Self->{From} = 'Von';
    $Self->{To} = 'An';
    $Self->{Cc} = 'Cc';
    $Self->{Subject} = 'Betreff';
    $Self->{Move} = 'Verschieben';
    $Self->{Queues} = 'Queues';
    $Self->{Close} = 'Schließen';
    $Self->{Compose} = 'Verfassen';
    $Self->{Pending} = 'Warten';
    $Self->{end} = 'runter';
    $Self->{top} = 'Anfang';
    $Self->{day} = 'Tag';
    $Self->{days} = 'Tage';
    $Self->{hour} = 'Stunde';
    $Self->{hours} = 'Stunden';
    $Self->{minute} = 'Minute';
    $Self->{minutes} = 'Minuten';
    $Self->{Owner} = 'Besitzer';
    $Self->{Sender} = 'Sender';
    $Self->{Article} = 'Artikel';
    $Self->{Ticket} = 'Ticket';
    $Self->{Createtime} = 'Erstellt am';
    $Self->{Created} = 'Erstellt';
    $Self->{View} = 'Ansicht';
    $Self->{plain} = 'klar';
    $Self->{Plain} = 'Ungemustert';
    $Self->{Action} = 'Aktion';
    $Self->{Attachment} = 'Anlage';
    $Self->{User} = 'Benutzer';
    $Self->{Back} = 'zurück';
    $Self->{store} = 'speichern';
    $Self->{phone} = 'Telefon';
    $Self->{Phone} = 'Telefon';
    $Self->{email} = 'Email';
    $Self->{Email} = 'Email';
    $Self->{'Language'} = 'Sprache';
    $Self->{'Languages'} = 'Sprachen';
    $Self->{'Salutation'} = 'Anrede';
    $Self->{'Signature'} = 'Signatur';
    $Self->{currently} = 'im Moment';
    $Self->{Customer} = 'Kunde';
    $Self->{'Customer info'} = 'Kunden Info';
    $Self->{'Set customer id of a ticket'} = 'Setze eine Kunden# zu einem Ticket';
    $Self->{'All tickets of this customer'} = 'Alle Tickets dieses Kunden';
    $Self->{'New CustomerID'} = 'Neue Kundennummer';
    $Self->{'for ticket'} = 'für Ticket';
    $Self->{'new ticket'} = 'neues Ticket';
    $Self->{'Start work'} = 'Start Arbeit';
    $Self->{'Stop work'} = 'Stop Arbeit';
    $Self->{'CustomerID'} = 'Kunden#';
    $Self->{'Compose Answer'} = 'Antwort erstellen';
    $Self->{'Contact customer'} = 'Kunden kontaktieren';
    $Self->{'Change queue'} = 'Wechsle Queue';
    $Self->{'go!'} = 'start!';
    $Self->{'all'} = 'alle';
    $Self->{'All'} = 'All';
    $Self->{'Sorry'} = 'Bedauere';
    $Self->{'No'} = 'Nein';
    $Self->{'no'} = 'kein';
    $Self->{'Yes'} = 'Ja';
    $Self->{'yes'} = 'ja';
    $Self->{'update!'} = 'aktualisieren!';
    $Self->{'submit!'} = 'übermitteln!';
    $Self->{'change!'} = 'ändern!';
    $Self->{'change'} = 'ändern';
    $Self->{'Change'} = 'Ändern';
    $Self->{'settings'} = 'Einstellungen';
    $Self->{'Settings'} = 'Einstellungen';
    $Self->{'Comment'} = 'Kommentar';
    $Self->{'Valid'} = 'Gültig';
    $Self->{'Forward'} = 'Weiterleiten';
    $Self->{'Name'} = 'Name';
    $Self->{'Group'} = 'Gruppe';
    $Self->{'Response'} = 'Antwort';
    $Self->{'Preferences'} = 'Einstellungen';
    $Self->{'Description'} = 'Beschreibung';
    $Self->{'description'} = 'Beschreibung';
    $Self->{'Key'} = 'Schlüssel';
    $Self->{'top'} = 'hoch';
    $Self->{'Line'} = 'Zeile';
    $Self->{'Subfunction'} = 'Unterfunktion';
    $Self->{'Module'} = 'Modul';
    $Self->{'Modulefile'} = 'Moduldatei';
    $Self->{'No Permission'} = 'Keine Erlaubnis';
    $Self->{'You have to be in the admin group!'} = 'Sie müssen hierfür in der Admin-Gruppe sein!';
    $Self->{'You have to be in the stats group!'} = 'Sie müssen hierfür in der Statistik-Gruppe sein!';
    $Self->{'Message'} = 'Nachricht';
    $Self->{'Error'} = 'Fehler';
    $Self->{'Bug Report'} = 'Fehler berichten';
    $Self->{'Click her to report a bug!'} = 'Klicken Sie hier um einen Fehler zu berichten!';
    $Self->{'AgentFrontend'} = 'AgentOberfläche';
    $Self->{'Groups'} = 'Gruppen';
    $Self->{'User'} = 'Benutzer';
    $Self->{'none!'} = 'keine Angabe!';
    $Self->{'German'} = 'Deutsch';
    $Self->{'English'} = 'Englisch';
    $Self->{'French'} = 'Französisch';
    $Self->{'French'} = 'Französisch';
    $Self->{'Chinese'} = 'Chinesisch';
    $Self->{'Czech'} = 'Tschechisch';
    $Self->{'Danish'} = 'Dänisch';
    $Self->{'Spanish'} = 'Spanisch';
    $Self->{'Greek'} = 'Griechisch';
    $Self->{'Italian'} = 'Italienisch';
    $Self->{'Korean'} = 'Koreanisch';
    $Self->{'Dutch'} = 'Niederländisch';
    $Self->{'Polish'} = 'Polnisch';
    $Self->{'Brazilian'} = 'Brasilianisch';
    $Self->{'Russian'} = 'Russisch';
    $Self->{'Swedish'} = 'Schwedisch';
    $Self->{'Lite'} = 'Einfach';
    # --
    # admin interface
    # --
    # common adminwords
    $Self->{'Useable options'} = 'Benutzbare Optionen';
    $Self->{'Example'} = 'Beispiel';
    $Self->{'Examples'} = 'Beispiele';
    # nav bar
    $Self->{'Admin Area'} = 'Adminbereich';
    $Self->{'Auto Responses'} = 'Auto-Antworten'; 
    $Self->{'Responses'} = 'Antworten';
    $Self->{'Responses <-> Queue'} = 'Antworten <-> Queues';
    $Self->{'Queue <-> Auto Response'} = 'Queues <-> Auto-Antworten';
    $Self->{'Session Managmant'} = 'Sitzungs Verwaltung';
    $Self->{'Email Addresses'} = 'Email-Adressen';
    # user
    $Self->{'User Management'} = 'Benutzer Verwaltung';
    $Self->{'Change user settings'} = 'Ändern der Benutzereinstellung';
    $Self->{'Add user'} = 'Benutzer hinzufügen';
    $Self->{'Update user'} = 'Benutzer aktualisieren';
    $Self->{'Firstname'} = 'Vorname';
    $Self->{'Lastname'} = 'Nachname';
    $Self->{'(Click here to add a user)'} = '(Hier klicken - Benutzer hinzufügen)';
    # group
    $Self->{'Group Management'} = 'Gruppen Verwaltung';
    $Self->{'Change group settings'} = 'Ändern einer Gruppe';
    $Self->{'Add group'} = 'Gruppe hinzufügen';
    $Self->{'Update group'} = 'Gruppe aktualisieren';
    $Self->{'(Click here to add a group)'} = '(Hier klicken - Gruppe hinzufügen)';
    # user <-> group
    $Self->{'User <-> Group Management'} = 'Benutzer <-> Gruppe Verwaltung';
    $Self->{'Change user <-> group settings'} = 'Ändern der Benutzer <-> Gruppe Beziehung';
    # queue
    $Self->{'Queue Management'} = 'Queue Verwaltung';
    $Self->{'Add queue'} = 'Queue hinzufügen';
    $Self->{'Change queue settings'} = 'Ändern einer Queue';
    $Self->{'Update queue'} = 'Queue aktualisieren';
    $Self->{'(Click here to add a queue)'} = '(Hier klicken - Queue hinzufügen)';
    $Self->{'Unlock timeout'} = 'Freigabe Zeitüberschreitung';
    $Self->{'Escalation time'} = 'Eskalationszeit';
    # Response
    $Self->{'Response Management'} = 'Antworten Verwaltung';
    $Self->{'Add response'} = 'Antwort hinzufügen';
    $Self->{'Change response settings'} = 'Ändern einer Antwort';
    $Self->{'Update response'} = 'Antworten aktualisieren';
    $Self->{'(Click here to add a response)'} = '(Hier klicken - Antwort hinzufügen)';
    # Responses <-> Queue
    $Self->{'Std. Responses <-> Queue Management'} = 'Std. Antworten <-> Queue Verwaltung';
    $Self->{'Standart Responses'} = 'Standard-Antworten';
    $Self->{'Change answer <-> queue settings'} = 'Ändern der Antworten <-> Queue Beziehung';
    # auto responses
    $Self->{'Auto Response Management'} = 'Auto-Antworten Verwaltung';
    $Self->{'Change auto response settings'} = 'Ändern einer Auto-Antworten';
    $Self->{'Add auto response'} = 'Auto-Antwort hinzufügen';
    $Self->{'Update auto response'} = 'Auto-Antwort aktualisieren';
    $Self->{'(Click here to add an auto response)'} = '(Hier klicken - Auto-Antwort hinzufügen)';
    # salutation
    $Self->{'Salutation Management'} = 'Anreden Verwaltung';
    $Self->{'Add salutation'} = 'Anrede hinzufügen';
    $Self->{'Update salutation'} = 'Anrede aktualisieren';
    $Self->{'Change salutation settings'} = 'Ändern einer Anrede';
    $Self->{'(Click here to add a salutation)'} = '(Hier klicken - Anrede hinzufügen)';
    $Self->{'customer realname'} = 'echter Kundenname';
    # signature
    $Self->{'Signature Management'} = 'Signatur Verwaltung';
    $Self->{'Add signature'} = 'Signatur hinzufügen';
    $Self->{'Update signature'} = 'Signatur aktualisieren';
    $Self->{'Change signature settings'} = 'Ändern einer Signatur';
    $Self->{'(Click here to add a signature)'} = '(Hier klicken - Signatur hinzufügen)';
    $Self->{'for agent firstname'} = 'für Vorname des Agents';
    $Self->{'for agent lastname'} = 'für Nachname des Agents';
    # queue <-> auto response
    $Self->{'Queue <-> Auto Response Management'} = 'Queue <-> Auto-Antworten Verwaltung';
    $Self->{'auto responses set'} = 'Auto-Antworten gesetzt';
    # system email addesses
    $Self->{'System Email Addresses Management'} = 'System-Email-Adressen Verwaltung';
    $Self->{'Change system address setting'} = 'Ändere System-Adresse';
    $Self->{'Add system address'} = 'System-Email-Adresse hinzufügen';
    $Self->{'Update system address'} = 'System-Email-Adresse aktualisieren';
    $Self->{'(Click here to add a system email address)'} = '(Hier klicken - System-Email-Adresse hinzufügen)';
    $Self->{'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!'} = 'Alle eingehenden Emails mit dem "To:" werden in die ausgewählte Queue einsortiert.';
    # charsets
    $Self->{'System Charset Management'} = 'System-Charset Verwaltung';
    $Self->{'Change system charset setting'} = 'Ändere System-Charset';
    $Self->{'Add charset'} = 'Charset hinzufügen';
    $Self->{'Update charset'} = 'Charset aktualisieren';
    $Self->{'(Click here to add charset)'} = '(Hier klicken - Charset hinzufügen';
    # states
    $Self->{'System State Management'} = 'System-State Verwaltung';
    $Self->{'Change system state setting'} = 'Ändere System-State';
    $Self->{'Add state'} = 'State hinzufügen';
    $Self->{'Update state'} = 'State aktualisieren';
    $Self->{'(Click here to add state)'} = '(Hier klicken - state hinzufügen)';
    # language
    $Self->{'System Language Management'} = 'System-Sprache Verwaltung';
    $Self->{'Change system language setting'} = 'Ändere System-Sprache';
    $Self->{'Add language'} = 'Sprache hinzufügen';
    $Self->{'Update language'} = 'Sprache aktualisieren';
    $Self->{'(Click here to add language)'} = '(Hier klicken - Sprache hinzufügen)';
    # session
    $Self->{'Session Management'} = 'Sitzungs Verwaltung';
    $Self->{'kill all sessions'} = 'Löschen alles Sitzungen';
    $Self->{'kill session'} = 'Sitzung löschen';
    # select box
    $Self->{'Max Rows'} = 'Max. Zeile';

    # --
    # agent interface
    # --
    # nav bar
    $Self->{Logout} = 'Abmelden';
    $Self->{QueueView} = 'Queue-Ansicht';
    $Self->{PhoneView} = 'Telefon-Ansicht';
    $Self->{Utilities} = 'Werkzeug';
    $Self->{AdminArea} = 'AdminBereich';
    $Self->{Preferences} = 'Einstellungen';
    $Self->{'Locked tickets'} = 'Eigene Tickets';
    $Self->{'new message'} = 'neue Nachricht';
    # ticket history
    $Self->{'History of Ticket'} = 'History von Ticket';
    # ticket note
    $Self->{'Add note to ticket'} = 'Anheften einer Notiz an Ticket';
    $Self->{'Note type'} = 'Notiz-Typ';
    # queue view
    $Self->{'Tickets shown'} = 'Tickets gezeigt';
    $Self->{'Ticket available'} = 'Ticket verfügbar';
    $Self->{'Show all'} = 'Alle gezeigt';
    $Self->{'tickets'} = 'Tickets';
    $Self->{'All tickets'} = 'Alle Tickets';
    # locked tickets
    $Self->{'All locked Tickets'} = 'Eigene Tickets';
    $Self->{'New message'} = 'Neue Nachricht';
    $Self->{'New message!'} = 'Neue Nachricht!';
    # util
    $Self->{'Hit'} = 'Treffer';
    $Self->{'Total hits'} = 'Treffer gesamt';
    $Self->{'Search again'} = 'Nochmal suchen';
    $Self->{'max viewable hits'} = 'max. Treffer sichtbar';
    $Self->{'Utilities/Search'} = 'Werkzeug/Suche';
    $Self->{'Ticket# search (e. g. 10*5155 or 105658*)'} = 'Ticket# Suche (z. B. 10*5155 or 105658*)';
    $Self->{'Fulltext search (e. g. "Mar*in" or "Baue*" or "martin+hallo")'} = 'Volltextsuche (z. B. "Mar*in" oder "Baue*" oder "martin+hallo")';
    # compose
    $Self->{'Compose message'} = 'Nachricht verfassen';
    $Self->{'please do not edit!'} = 'Bitte nicht verändern!';
    $Self->{'Send mail!'} = 'Mail senden!';
    $Self->{'wrote'} = 'schrieb';
    $Self->{'Compose answer for ticket'} = 'Antwort erstellen für';
    $Self->{'Ticket locked!'} = 'Ticket gesperrt!';
    # forward
    $Self->{'Forward article of ticket'} = 'Weiterleitung des Artikels vom Ticket';
    $Self->{'Article type'} = 'Artikel-Typ';
    $Self->{'Next ticket state'} = 'Nächster Status des Tickets';

    # preferences
    $Self->{'User Preferences'} = 'Benutzereinstellungen';
    $Self->{'Change Password'} = 'Passwort ändern';
    $Self->{'New password'} = 'Neues Passwort';
    $Self->{'New password again'} = 'Neues Passwort wiederholen';
    $Self->{'Select your custom queues'} = 'Bevorzugten Queues auswählen';
    $Self->{'Select your QueueView refresh time'} = 'Queue-Ansicht Aktualisierungszeit auswählen';
    $Self->{'Select your frontend language'} = 'Oberflächen-Sprache auswählen';
    $Self->{'Select your frontend Charset'} = 'Zeichensatz für Darstellung auswählen';
    $Self->{'Select your frontend theme'} = 'Anzeigeschema auswählen';
    $Self->{'Frontend language'} = 'Bedien-Sprache auswählen';
    $Self->{' 2 minutes'} = ' 2 Minuten';
    $Self->{' 5 minutes'} = ' 5 Minuten';
    $Self->{' 7 minutes'} = ' 7 Minuten';
    $Self->{'10 minutes'} = '10 Minuten';
    $Self->{'15 minutes'} = '15 Minuten';
    # change priority
    $Self->{'Change priority of ticket'} = 'Priorität ändern für Ticket';
    # some other words ...
    $Self->{AddLink} = 'Link hinzufügen';
#    $Self->{} = '';
#    $Self->{} = '';
#    $Self->{} = '';

    # stats
    $Self->{'Stats'} = 'Statistik';
    $Self->{'Status'} = 'Status';
    $Self->{'Graph'} = 'Diagramm';
    $Self->{'Graphs'} = 'Diagramme';

    # phone view
    $Self->{'Phone call'} = 'Anruf';
    $Self->{'Phone call at'} = 'Anruf um';

    # states
    $Self->{'new'} = 'neu';
    $Self->{'open'} = 'offen';
    $Self->{'closed succsessful'} = 'erfolgreich geschlossen';
    $Self->{'closed unsuccsessful'} = 'erfolglos geschlossen';
    $Self->{'removed'} = 'entfernt';
    # article types
    $Self->{'email-external'} = 'Email an extern';
    $Self->{'email-internal'} = 'Email an intern';
    $Self->{'note-internal'} = 'Notiz für intern';
    $Self->{'note-external'} = 'Notiz für extern';
    $Self->{'note-report'} = 'Notiz für reporting';

    # priority
    $Self->{'very low'} = 'sehr niedrig';
    $Self->{'low'} = 'niedrig';
    $Self->{'normal'} = 'normal';
    $Self->{'high'} = 'hoch';
    $Self->{'very high'} = 'sehr hoch';

    return;
}
# --

1;

