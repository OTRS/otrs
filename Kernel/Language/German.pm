# --
# German.pm - provides german languag translation
# Copyright (C) 2001 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: German.pm,v 1.4 2002-01-30 16:36:33 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
package Kernel::Language::German;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.4 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

# --
sub Data {
    my $Self = shift;
    my %Param = @_;

    # some common words
    $Self->{Lock} = 'Ziehen';
    $Self->{Unlock} = 'Frei geben';
    $Self->{Zoom} = 'Genauer';
    $Self->{History} = 'Geschichte';
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
    $Self->{Close} = 'Schliesen';
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
    $Self->{View} = 'Sicht';
    $Self->{Action} = 'Aktion';
    $Self->{User} = 'Benutzer';
    $Self->{Back} = 'zurück';
    $Self->{store} = 'speichern';
    $Self->{currently} = 'im Moment';
    $Self->{Customer} = 'Kunde';
    $Self->{'Customer info'} = 'Kunden Info';
    $Self->{'Set customer id of a ticket'} = 'Setze eine Kunden# zu einem Ticket';
    $Self->{'All tickets of this customer'} = 'Alle Tickets zu diesem Kunden';
    $Self->{'New CustomerID'} = 'Neue Kundennummer';
    $Self->{'for ticket'} = 'für Ticket';
    $Self->{'Start work'} = 'Start Arbeit';
    $Self->{'Stop work'} = 'Stop Arbeit';
    $Self->{'CustomerID'} = 'Kunden#';
    $Self->{'Compose Answer'} = 'Antwort erstellen';
    $Self->{'Change queue'} = 'Wechsle Queue';
    $Self->{'go!'} = 'start!';
    $Self->{'update!'} = 'aktualisieren!';
    $Self->{'submit!'} = 'übermitteln!';
    $Self->{'change!'} = 'ändern!';
    $Self->{'change'} = 'ändern';
    $Self->{'Comment'} = 'Komentar';
    $Self->{'Valid'} = 'Gültig';
    $Self->{'Forward'} = 'Weiterleiten';
    $Self->{'Name'} = 'Name';
    $Self->{'Group'} = 'Gruppe';
    $Self->{'Response'} = 'Antwort';
    $Self->{'none!'} = 'keine Angabe!';
    $Self->{'German'} = 'Deutsch';
    $Self->{'English'} = 'Englisch';
    $Self->{'Lite'} = 'Einfach';
    # admin area
    $Self->{'Firstname'} = 'Vorname';
    $Self->{'Lastname'} = 'Nachname';
    $Self->{'Add User'} = 'Benutzer hinzufügen';
    $Self->{'Languages'} = 'Sprachen';
    $Self->{'Language'} = 'Sprache';
    $Self->{'Salutation'} = 'Anrede';
    $Self->{'Signature'} = 'Signatur';
    $Self->{'Standart Responses'} = 'Standart Antworten';
    $Self->{'System Addresses'} = 'System Adressen';
    $Self->{'Admin Area'} = 'Adminbereich';
    $Self->{'Preferences'} = 'Einstellungen';
    $Self->{'top'} = 'hoch';
    $Self->{'AgentFrontend'} = 'AgentOberfläche';
    $Self->{'Groups'} = 'Gruppen';
    $Self->{'User'} = 'Benutzer';
    $Self->{'User <-> Groups'} = 'Benutzer <-> Gruppen';
    $Self->{'Std. Responses <-> Queue'} = 'Std. Antworten <-> Queue';
    $Self->{'Add Group'} = 'Gruppe hinzufügen';
    $Self->{'Change Group settings'} = 'Ändern einer Gruppe';
    $Self->{'Add Queue'} = 'Queue hinzufügen';
    $Self->{'Systemaddress'} = 'Systemadresse';
    $Self->{'Change Queue settings'} = 'Ändern einer Queue';
    $Self->{'Add Response'} = 'Antwort hinzufügen';
    $Self->{'Change Response settings'} = 'Ändern einer Antwort';
    $Self->{'Add Salutation'} = 'Anrede hinzufügen';
    $Self->{'Change Salutation settings'} = 'Ändern einer Anrede';
    # nav bar
    $Self->{Logout} = 'Abmelden';
    $Self->{QueueView} = 'QueueAnsicht';
    $Self->{PhoneView} = 'PhoneAnsicht';
    $Self->{Utilities} = 'Werkzeug';
    $Self->{AdminArea} = 'AdminBereich';
    $Self->{Preferences} = 'Einstellungen';
    $Self->{'Locked tickets'} = 'Eigene Tickets';
    $Self->{'new message'} = 'new Nachricht';
    # ticket history
    $Self->{'History of Ticket'} = 'History von Ticket';
    # ticket note
    $Self->{'Add note to ticket'} = 'Add note to ticket';
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
    $Self->{'Seach again'} = 'Nochmal suchen';
    $Self->{'max viewable hits'} = 'max Treffer sichtbar';
    $Self->{'Utilities/Search'} = 'Werkzeug/Suche';
    $Self->{'Ticket# search (e. g. 10*5155 or 105658*)'} = 'Ticket# Suche (z. B. 10*5155 or 105658*)';
    $Self->{'Fulltext search (e. g. "Mar*in" or "Baue*" or "martin+hallo")'} = 'Volltextsuche (z. B. "Mar*in" ode 
 "Baue*" oder "martin+hallo")';
    # compose
    $Self->{'Compose message'} = 'Nachricht verfassen';
    $Self->{'please do not edit!'} = 'Bitte nicht verändern!';
    $Self->{'Send mail!'} = 'Mail senden!';
    # preferences
    $Self->{'User Preferences'} = 'Benutzereinstellungen';
    $Self->{'Change Password'} = 'Paßwort ändern';
    $Self->{'New password'} = 'Neues Paßwort';
    $Self->{'New password again'} = 'Neues Paßwort wiederholen';
    $Self->{'Select your custom queues'} = 'Bitte wähle Deine bevorzugten Queues';
    $Self->{'Select your frontend language'} = 'Bitte wähle Deine Oberflächen Sprache';
    $Self->{'Select your frontend Charset'} = 'Bitte wähle Deinen Frontend Charset';
    $Self->{'Select your frontend theme'} = 'Bitte wähle Dein Theme';
    $Self->{'Frontend language'} = 'Frontend Sprache';
    # change priority
    $Self->{'Change priority of ticket'} = 'Priorität ändern für Ticket';
    # some other words ...
    $Self->{AddLink} = 'Link hinzufügen';
#    $Self->{} = '';
#    $Self->{} = '';
#    $Self->{} = '';

    # states
    $Self->{'new'} = 'neu';
    $Self->{'open'} = 'offen';
    $Self->{'closed succsessful'} = 'erfolgreich geschlossen';
    $Self->{'closed unsuccsessful'} = 'unerfolgreich geschlossen';
    $Self->{'removed'} = 'zurückgezogen';
#    $Self->{''} = '';
#    $Self->{''} = '';
#    $Self->{''} = '';

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

