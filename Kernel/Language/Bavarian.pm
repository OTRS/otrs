# --
# Bavarian.pm - provides bavarian languag translation
# --
# Copyright (C) 2002 Martin Edenhofer <martin+code@otrs.org>
# --
# --> this is a special for bavarian people! <--
# --> Set Bavarian Language to valid (Admin Interface), to use <--
# --> this file <--
# --
# $Id: Bavarian.pm,v 1.1 2002-05-05 13:32:22 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Language::Bavarian;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.1 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

# --
sub Data {
    my $Self = shift;
    my %Param = @_;

    # some common words
    $Self->{Lock} = 'Hoin';
    $Self->{Unlock} = 'Weg damit';
    $Self->{unlock} = 'weg damit';
    $Self->{Zoom} = 'Genauer';
    $Self->{History} = 'History';
    $Self->{'Add Note'} = 'Notiz onedoa';
    $Self->{Bounce} = 'Bounce';
    $Self->{Age} = 'Alter';
    $Self->{Priority} = 'Priorität';
    $Self->{State} = 'Status';
    $Self->{From} = 'Vom';
    $Self->{To} = 'Zum';
    $Self->{Cc} = 'Cc';
    $Self->{Subject} = 'Betreff';
    $Self->{Move} = 'Duas ume';
    $Self->{Queues} = 'Queues';
    $Self->{Close} = 'ferig macha';
    $Self->{Compose} = 'Schreib eam';
    $Self->{Pending} = 'Wotn';
    $Self->{end} = 'obe';
    $Self->{top} = 'afe';
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
    $Self->{User} = 'Leid';
    $Self->{Back} = 'zruck';
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
    $Self->{'Comment'} = 'Kommentar';
    $Self->{'Valid'} = 'Gültig';
    $Self->{'Forward'} = 'Weiterleiten';
    $Self->{'Name'} = 'Nam';
    $Self->{'Group'} = 'Gruppn';
    $Self->{'Response'} = 'Antwort';
    $Self->{'none!'} = 'keine Angabe!';
    $Self->{'German'} = 'Deutsch';
    $Self->{'English'} = 'Englisch';
    $Self->{'Lite'} = 'Einfach';
    # admin area
    $Self->{'Firstname'} = 'Voaname';
    $Self->{'Lastname'} = 'Nachname';
    $Self->{'Add User'} = 'Eban one doa';
    $Self->{'Languages'} = 'Sprachn';
    $Self->{'Language'} = 'Sprach';
    $Self->{'Salutation'} = 'Anrede';
    $Self->{'Signature'} = 'Signatur';
    $Self->{'Standart Responses'} = 'Standart Antworten';
    $Self->{'System Addresses'} = 'System Adressn';
    $Self->{'Admin Area'} = 'Chefbereich';
    $Self->{'Preferences'} = 'Einstellungen';
    $Self->{'top'} = 'hoch';
    $Self->{'AgentFrontend'} = 'Dua wos';
    $Self->{'Groups'} = 'Gruppn';
    $Self->{'User'} = 'Eba';
    $Self->{'User <-> Groups'} = 'Leid <-> Gruppen';
    $Self->{'Std. Responses <-> Queue'} = 'Std. Antworten <-> Queue';
    $Self->{'Add Group'} = 'Gruppe one doa';
    $Self->{'Change Group settings'} = 'Ändern einer Gruppe';
    $Self->{'Add Queue'} = 'Queue one doa';
    $Self->{'Systemaddress'} = 'Systemadress';
    $Self->{'Change Queue settings'} = 'Ändern einer Queue';
    $Self->{'Add Response'} = 'Antwort one doa';
    $Self->{'Change Response settings'} = 'Ändern einer Antwort';
    $Self->{'Add Salutation'} = 'Anrede one doa';
    $Self->{'Change Salutation settings'} = 'Ändern einer Anrede';
    # nav bar
    $Self->{Logout} = 'Pfide';
    $Self->{QueueView} = 'Queue sand do';
    $Self->{PhoneView} = 'Telefon klingelt';
    $Self->{Utilities} = 'Werkzeig';
    $Self->{AdminArea} = 'Chefbereich';
    $Self->{Preferences} = 'Einstellungen';
    $Self->{'Locked tickets'} = 'Meine';
    $Self->{'new message'} = 'new Nachricht';
    # ticket history
    $Self->{'History of Ticket'} = 'History von Ticket';
    # ticket note
    $Self->{'Add note to ticket'} = 'Anheften einer Notiz an Ticket';
    $Self->{'Note type'} = 'Notiz Type';
    # queue view
    $Self->{'Tickets shown'} = 'Tickets zoagt';
    $Self->{'Ticket available'} = 'Ticket verfügbar';
    $Self->{'Show all'} = 'Alle wos da is';
    $Self->{'tickets'} = 'Tickets';
    $Self->{'All tickets'} = 'Olle Tickets';
    # locked tickets
    $Self->{'All locked Tickets'} = 'Meine Tickets';
    $Self->{'New message'} = 'Neie Nachricht';
    $Self->{'New message!'} = 'Neie Nachricht!';
    # util
    $Self->{'Hit'} = 'Treffer';
    $Self->{'Total hits'} = 'Treffer gesamt';
    $Self->{'Seach again'} = 'Nochmal suchen';
    $Self->{'max viewable hits'} = 'max Treffer sichtbar';
    $Self->{'Utilities/Search'} = 'Werkzeug/Suche';
    $Self->{'Ticket# search (e. g. 10*5155 or 105658*)'} = 'Ticket# Sucha (z. B. 10*5155 oda 105658*)';
    $Self->{'Fulltext search (e. g. "Mar*in" or "Baue*" or "martin+hallo")'} = 'Folltextsucha (z. B. "Mar*in" oda "Baue*" oder "martin+hallo")';
    # compose
    $Self->{'Compose message'} = 'Nachricht verfassen';
    $Self->{'please do not edit!'} = 'Gea nicht verändern!';
    $Self->{'Send mail!'} = 'Mail schika!';
    $Self->{'wrote'} = 'hod gschrim';
    $Self->{'Compose answer for ticket'} = 'Antwort schreim für';
    $Self->{'Ticket locked!'} = 'Ticket gesperrt!';
    # forward
    $Self->{'Forward article of ticket'} = 'Weiterleitung des Artikels vom Ticket';
    $Self->{'Article type'} = 'Artikle Type';
    $Self->{'Next ticket state'} = 'Nächster Status des Tickets';

    # preferences
    $Self->{'User Preferences'} = 'Mei Zeig';
    $Self->{'Change Password'} = 'Paßwort ändern';
    $Self->{'New password'} = 'Neis Paßwort';
    $Self->{'New password again'} = 'Neis Paßwort wiederhoien';
    $Self->{'Select your custom queues'} = 'Gea wähle Dei lieblings Queues';
    $Self->{'Select your frontend language'} = 'Gea wähle Dei Oberflächen Sprache';
    $Self->{'Select your frontend Charset'} = 'Gea wähle Dein Frontend Charset';
    $Self->{'Select your frontend theme'} = 'Gea wähle Dei Theme';
    $Self->{'Frontend language'} = 'Frontend Sprach';
    # change priority
    $Self->{'Change priority of ticket'} = 'Priorität ändern für Ticket';
    # some other words ...
    $Self->{AddLink} = 'Link one doa';
#    $Self->{} = '';
#    $Self->{} = '';
#    $Self->{} = '';

    # states
    $Self->{'new'} = 'nei';
    $Self->{'open'} = 'offa';
    $Self->{'closed succsessful'} = 'erfolgreich geschlossen';
    $Self->{'closed unsuccsessful'} = 'unerfolgreich geschlossen';
    $Self->{'removed'} = 'zurückgezogen';
    # article types
    $Self->{'email-external'} = 'Email für extern';
    $Self->{'email-internal'} = 'Email für intern';
    $Self->{'note-internal'} = 'Notiz für intern';
    $Self->{'note-external'} = 'Notiz für extern';
    $Self->{'note-report'} = 'Notiz für reporting';

#    $Self->{''} = '';
#    $Self->{''} = '';

    # priority
    $Self->{'very low'} = 'braucht kona oschaun';
    $Self->{'low'} = 'nix da';
    $Self->{'normal'} = 'bast scho';
    $Self->{'high'} = 'hoch';
    $Self->{'very high'} = 'sehr hoch';

    return;
}
# --

1;

