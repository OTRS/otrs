# --
# Kernel/Language/nl.pm - provides nl language translation
# Copyright (C) 2002-2003 Fred van Dijk <fvandijk at marklin.nl>
# Copyright (C) 2003 A-NeT Internet Services bv Hans Bakker <h.bakker at a-net.nl>
# Copyright (C) 2004 Martijn Lohmeijer <martijn.lohmeijer 'at' sogeti.nl>
# Copyright (C) 2005-2007 Jurgen Rutgers <jurgen 'at' besite.nl>
# Copyright (C) 2005-2007 Richard Hinkamp <richard 'at' besite.nl>
# Copyright (C) 2009 Michiel Beijen <michiel 'at' beefreeit.nl>
# --
# $Id: nl.pm,v 1.104.2.5 2010-03-02 15:49:10 mb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

# Not translated terms / words:

# Agent Area --> it's clear what that does
# Bounce
# Contract
# Directory
# Type
# Upload

package Kernel::Language::nl;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.104.2.5 $) [1];

sub Data {
    my $Self = shift;

    # $$START$$
    # Last translation file sync: Mon Jul 13 10:28:19 2009

    # possible charsets
    $Self->{Charset} = ['iso-8859-1', 'iso-8859-15', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Year;)
    $Self->{DateFormat}          = '%D-%M-%Y %T';
    $Self->{DateFormatLong}      = '%A %D %B %Y %T';
    $Self->{DateFormatShort}     = '%D-%M-%Y';
    $Self->{DateInputFormat}     = '%D-%M-%Y';
    $Self->{DateInputFormatLong} = '%D-%M-%Y - %T';

    $Self->{Translation} = {
        # Template: AAABase
        'Yes' => 'Ja',
        'No' => 'Nee',
        'yes' => 'ja',
        'no' => 'nee',
        'Off' => 'Uit',
        'off' => 'uit',
        'On' => 'Aan',
        'on' => 'aan',
        'top' => 'bovenkant',
        'end' => 'onderkant',
        'Done' => 'Klaar',
        'Cancel' => 'Annuleren',
        'Reset' => 'Opnieuw',
        'last' => 'laatste',
        'before' => 'voor',
        'day' => 'dag',
        'days' => 'dagen',
        'day(s)' => 'dag(en)',
        'hour' => 'uur',
        'hours' => 'uur',
        'hour(s)' => 'uur',
        'minute' => 'minuut',
        'minutes' => 'minuten',
        'minute(s)' => 'minuten',
        'month' => 'maand',
        'months' => 'maanden',
        'month(s)' => 'maand(en)',
        'week' => 'week',
        'week(s)' => 'weken',
        'year' => 'jaar',
        'years' => 'jaren',
        'year(s)' => 'jaren',
        'second(s)' => 'seconden',
        'seconds' => 'seconden',
        'second' => 'seconde',
        'wrote' => 'schreef',
        'Message' => 'Bericht',
        'Error' => 'Fout',
        'Bug Report' => 'Foutrapport',
        'Attention' => 'Let op',
        'Warning' => 'Waarschuwing',
        'Module' => 'Module',
        'Modulefile' => 'Modulebestand',
        'Subfunction' => 'Subfunctie',
        'Line' => 'Regel',
        'Setting' => 'Instelling',
        'Settings' => 'Instellingen',
        'Example' => 'Voorbeeld',
        'Examples' => 'Voorbeelden',
        'valid' => 'geldig',
        'invalid' => 'ongeldig',
        '* invalid' => '* ongeldig',
        'invalid-temporarily' => 'tijdelijk ongeldig',
        ' 2 minutes' => ' 2 minuten',
        ' 5 minutes' => ' 5 minuten',
        ' 7 minutes' => ' 7 minuten',
        '10 minutes' => '10 minuten',
        '15 minutes' => '15 minuten',
        'Mr.' => 'Dhr.',
        'Mrs.' => 'Mevr.',
        'Next' => 'Volgende',
        'Back' => 'Terug',
        'Next...' => 'Volgende >',
        '...Back' => '< Terug',
        '-none-' => '-geen-',
        'none' => 'geen',
        'none!' => 'niet ingevoerd!',
        'none - answered' => 'geen - beantwoord',
        'please do not edit!' => 'niet wijzigen alstublieft!',
        'AddLink' => 'Koppeling toevoegen',
        'Link' => 'Koppel',
        'Unlink' => 'Ontkoppel',
        'Linked' => 'Gekoppeld',
        'Link (Normal)' => 'Koppeling (normaal)',
        'Link (Parent)' => 'Koppeling (hoofd)',
        'Link (Child)' => 'Koppeling (sub)',
        'Normal' => 'Normaal',
        'Parent' => 'hoofd',
        'Child' => 'sub',
        'Hit' => 'Hit',
        'Hits' => 'Hits',
        'Text' => 'Tekst',
        'Lite' => 'Light',
        'User' => 'Gebruiker',
        'Username' => 'Gebruikersnaam',
        'Language' => 'Taal',
        'Languages' => 'Talen',
        'Password' => 'Wachtwoord',
        'Salutation' => 'Aanhef',
        'Signature' => 'Handtekening',
        'Customer' => 'Klant',
        'CustomerID' => 'Klantnummer',
        'CustomerIDs' => 'Klantnummers',
        'customer' => 'klant',
        'agent' => 'behandelaar',
        'system' => 'systeem',
        'Customer Info' => 'Klantinformatie',
        'Customer Company' => 'Bedrijf',
        'Company' => 'Bedrijf',
        'go!' => 'start!',
        'go' => 'start',
        'All' => 'Alle',
        'all' => 'alle',
        'Sorry' => 'Sorry',
        'update!' => 'wijzigen!',
        'update' => 'wijzigen',
        'Update' => 'Wijzigen',
        'Updated!' => 'Gewijzigd!',
        'submit!' => 'opslaan!',
        'submit' => 'opslaan',
        'Submit' => 'Opslaan',
        'change!' => 'wijzigen!',
        'Change' => 'Wijzigen',
        'change' => 'wijzigen',
        'click here' => 'klik hier',
        'Comment' => 'Commentaar',
        'Valid' => 'Geldig',
        'Invalid Option!' => 'Geen geldige optie',
        'Invalid time!' => 'Geen geldige tijd',
        'Invalid date!' => 'Geen geldige datum',
        'Name' => 'Naam',
        'Group' => 'Groep',
        'Description' => 'Omschrijving',
        'description' => 'omschrijving',
        'Theme' => 'Thema',
        'Created' => 'Aangemaakt',
        'Created by' => 'Aangemaakt door',
        'Changed' => 'Gewijzigd',
        'Changed by' => 'Gewijzigd door',
        'Search' => 'Zoeken',
        'and' => 'en',
        'between' => 'tussen',
        'Fulltext Search' => 'Alles doorzoeken',
        'Data' => 'Gegevens',
        'Options' => 'Opties',
        'Title' => 'Titel',
        'Item' => 'Onderdeel',
        'Delete' => 'Verwijderen',
        'Edit' => 'Wijzig',
        'View' => 'Weergave',
        'Number' => 'Nummer',
        'System' => 'Systeem',
        'Contact' => 'Contact',
        'Contacts' => 'Contacten',
        'Export' => 'Exporteer',
        'Up' => 'Boven',
        'Down' => 'Beneden',
        'Add' => 'Toevoegen',
        'Added!' => 'Toegevoegd!',
        'Category' => 'Categorie',
        'Viewer' => 'Viewer',
        'Expand' => 'Klap uit',
        'Small' => 'Klein',
        'Medium' => 'Middel',
        'Large' => 'Groot',
        'New message' => 'Nieuw bericht',
        'New message!' => 'Nieuw bericht!',
        'Please answer this ticket(s) to get back to the normal queue view!' => 'Beantwoord eerst onderstaande geëscaleerde tickets om terug te kunnen komen in de normale wachtrij',
        'You got new message!' => 'U heeft een nieuw bericht!',
        'You have %s new message(s)!' => 'U heeft %s nieuwe bericht(en)!',
        'You have %s reminder ticket(s)!' => 'U heeft %s herinneringsticket(s)!',
        'The recommended charset for your language is %s!' => 'De aanbevolen karakterset voor uw taal is %s!',
        'Passwords doesn\'t match! Please try it again!' => 'Wachtwoorden komen niet overeen! Probeer het opnieuw!',
        'Password is already in use! Please use an other password!' => 'Wachtwoord wordt al gebruikt. Kies een ander wachtwoord!',
        'Password is already used! Please use an other password!' => 'Wachtwoord is al in gebruik. Kies een ander wachtwoord!',
        'You need to activate %s first to use it!' => 'U moet eerst %s activeren voordat u het kunt gebruiken.',
        'No suggestions' => 'Geen suggesties',
        'Word' => 'Woord',
        'Ignore' => 'Negeren',
        'replace with' => 'vervangen met',
        'There is no account with that login name.' => 'Er is geen account bekend met deze gebruikersnaam',
        'Login failed! Your username or password was entered incorrectly.' => 'Aanmelden is mislukt. Uw gebruikersnaam of wachtwoord is onjuist.',
        'Please contact your admin' => 'Vraag uw systeembeheerder',
        'Logout successful. Thank you for using OTRS!' => 'U bent afgemeld. Bedankt voor het gebruiken van OTRS!',
        'Invalid SessionID!' => 'Ongeldige SessieID',
        'Feature not active!' => 'Deze functie is niet actief!',
        'Notification (Event)' => 'Melding (Event)',
        'Login is needed!' => 'Inloggen is nodig',
        'Password is needed!' => 'Een wachtwoord is vereist',
        'License' => 'Licentie',
        'Take this Customer' => 'Selecteer deze klant',
        'Take this User' => 'Selecteer deze gebruiker',
        'possible' => 'mogelijk',
        'reject' => 'afwijzen',
        'reverse' => 'omgekeerd',
        'Facility' => 'Maatregel',
        'Timeover' => 'Tijdsoverschrijding',
        'Pending till' => 'In de wacht tot',
        'Don\'t work with UserID 1 (System account)! Create new users!' => 'Werk niet met deze gebruiker (User# 1 - systeemaccount). Maak nieuwe gebruikers aan!',
        'Dispatching by email To: field.' => 'Sorteren op e-mailadres ',
        'Dispatching by selected Queue.' => 'Sorteren op geselecteerde wachtrij',
        'No entry found!' => 'Niets gevonden!',
        'Session has timed out. Please log in again.' => 'Uw sessie is verlopen. Meldt u opnieuw aan.',
        'No Permission!' => 'Geen toegang! Onvoldoende rechten.',
        'To: (%s) replaced with database email!' => 'Aan: (%s) vervangen met database e-mail!',
        'Cc: (%s) added database email!' => 'Cc: (%s) toevoegen met database e-mail',
        '(Click here to add)' => '(Klik hier om toe te voegen)',
        'Preview' => 'Voorbeeld',
        'Package not correctly deployed! You should reinstall the Package again!' => 'Pakket is niet goed geïnstalleerd! Installeer het pakket overnieuw!',
        'Added User "%s"' => 'Gebruiker "%s" toegevoegd.',
        'Role added!' => 'Rol toegevoegd.',
        'Contract' => 'Contract',
        'Online Customer: %s' => 'Online klanten: %s',
        'Online Agent: %s' => 'Online behandelaars: %s',
        'Calendar' => 'Kalender',
        'File' => 'Bestand',
        'Filename' => 'Bestandsnaam',
        'Type' => 'Type',
        'Size' => 'Grootte',
        'Upload' => 'Upload',
        'Directory' => 'Map',
        'Signed' => 'Getekend',
        'Sign' => 'Teken',
        'Crypted' => 'Versleuteld',
        'Crypt' => 'Versleutel',
        'Office' => 'Kantoor',
        'Phone' => 'Telefoon',
        'Fax' => 'Fax',
        'Mobile' => 'Mobiel',
        'Zip' => 'Postcode',
        'City' => 'Plaats',
        'Street' => 'Straat',
        'Country' => 'Land',
        'Location' => 'Locatie',
        'installed' => 'geïnstalleerd',
        'uninstalled' => 'verwijderd',
        'Security Note: You should activate %s because application is already running!' => 'Beveiligingswaarschuwing: Activeer %s omdat de applicatie al actief is!',
        'Unable to parse Online Repository index document!' => 'Kan Online Repository index niet lezen',
        'No Packages for requested Framework in this Online Repository, but Packages for other Frameworks!' => 'Voor het gevraagde framework zijn er geen pakketten gevonden in de Online Repository',
        'No Packages or no new Packages in selected Online Repository!' => 'Geen pakketten (of geen nieuwe pakketten) gevonden in de geselecteerde Online Repository',
        'printed at' => 'afgedrukt op',
        'Dear Mr. %s,' => 'Geachte heer %s,',
        'Dear Mrs. %s,' => 'Geachte mevrouw %s,',
        'Dear %s,' => 'Geachte %s,',
        'Hello %s,' => 'Beste %s,',
        'This account exists.' => 'Dit account bestaat al. ',
        'New account created. Sent Login-Account to %s.' => 'Nieuw account aangemaakt. De logingegevens zijn verstuurd aan %s.',
        'Please press Back and try again.' => 'Druk op Terug en probeer opnieuw.',
        'Sent password token to: %s' => 'Wachtwoord verstuurd naar %s',
        'Sent new password to: %s' => 'Nieuw wachtwoord verstuurd naar %s',
        'Upcoming Events' => 'Aankomende events',
        'Event' => 'Event',
        'Events' => 'Events',
        'Invalid Token!' => 'Fout token!',
        'more' => 'meer',
        'For more info see:' => 'Voor meer informatie zie:',
        'Package verification failed!' => 'Pakketverificatie mislukt!',
        'Collapse' => 'Inklappen',
        'News' => 'Nieuws',
        'Product News' => 'Productnieuws',
        'OTRS News' => 'OTRS News',
        '7 Day Stats' => 'Afgelopen 7 dagen',
        'Online' => 'Ingelogd',
        'Shown' => 'Tonen',
        'Bold' => 'Vet',
        'Italic' => 'Cursief',
        'Underline' => 'Onderstreep',
        'Font Color' => 'Tekstkleur',
        'Background Color' => 'Achtergrondkleur',
        'Remove Formatting' => 'Verwijder opmaak',
        'Show/Hide Hidden Elements' => 'Toon/verberg verborgen elementen',
        'Align Left' => 'Links uitlijnen',
        'Align Center' => 'Centreren',
        'Align Right' => 'Rechts uitlijnen',
        'Justify' => 'Aanpassen',
        'Header' => 'Type',
        'Indent' => 'Inspringing vergroten',
        'Outdent' => 'Inspringing verkleinen',
        'Create an Unordered List' => 'Lijst',
        'Create an Ordered List' => 'Ongenummerde lijst',
        'HTML Link' => 'HTML Koppeling',
        'Insert Image' => 'Afbeelding invoegen',
        'CTRL' => 'CTRL',
        'SHIFT' => 'SHIFT',
        'Undo' => 'Ongedaan maken',
        'Redo' => 'Herhalen',

        # Template: AAAMonth
        'Jan' => 'jan',
        'Feb' => 'feb',
        'Mar' => 'mrt',
        'Apr' => 'apr',
        'May' => 'mei',
        'Jun' => 'jun',
        'Jul' => 'jul',
        'Aug' => 'aug',
        'Sep' => 'sep',
        'Oct' => 'okt',
        'Nov' => 'nov',
        'Dec' => 'dec',
        'January' => 'januari',
        'February' => 'februari',
        'March' => 'maart',
        'April' => 'april',
        'May_long' => 'mei',
        'June' => 'juni',
        'July' => 'juli',
        'August' => 'augustus',
        'September' => 'september',
        'October' => 'oktober',
        'November' => 'november',
        'December' => 'december',

        # Template: AAANavBar
        'Admin-Area' => 'Beheer',
        'Agent-Area' => 'Agent',
        'Ticket-Area' => 'Tickets',
        'Logout' => 'Uitloggen',
        'Agent Preferences' => 'Behandelaar-voorkeuren',
        'Preferences' => 'Voorkeuren',
        'Agent Mailbox' => 'Behandelaar-postvak',
        'Stats' => 'Statistieken',
        'Stats-Area' => 'Statistieken',
        'Admin' => 'Beheer',
        'Customer Users' => 'Klanten',
        'Customer Users <-> Groups' => 'Klanten <-> Groepen',
        'Users <-> Groups' => 'Gebruikers <-> Groepen',
        'Roles' => 'Rollen',
        'Roles <-> Users' => 'Rollen <-> Gebruikers',
        'Roles <-> Groups' => 'Rollen <-> Groepen',
        'Salutations' => 'Aanhef',
        'Signatures' => 'Handtekening',
        'Email Addresses' => 'E-mailadressen',
        'Notifications' => 'Meldingen',
        'Category Tree' => 'Categorie-boom',
        'Admin Notification' => 'Admin melding',

        # Template: AAAPreferences
        'Preferences updated successfully!' => 'Uw voorkeuren zijn gewijzigd!',
        'Mail Management' => 'Mail beheer',
        'Frontend' => 'Interface',
        'Other Options' => 'Overige opties',
        'Change Password' => 'Wijzig uw wachtwoord',
        'New password' => 'Nieuw wachtwoord',
        'New password again' => 'Bevestig nieuw wachtwoord',
        'Select your QueueView refresh time.' => 'Selecteer de verversingstijd van de wachtrij in uw scherm.',
        'Select your frontend language.' => 'Kies uw taal',
        'Select your frontend Charset.' => 'Kies uw karakterset',
        'Select your frontend Theme.' => 'Kies uw thema',
        'Select your frontend QueueView.' => 'Kies uw weergave van de wachtrij',
        'Spelling Dictionary' => 'Spellingsbibliotheek',
        'Select your default spelling dictionary.' => 'Selecteer uw standaard spellingsbibliotheek.',
        'Max. shown Tickets a page in Overview.' => 'Max. getoonde tickets per pagina in overzichtsscherm.',
        'Can\'t update password, your new passwords do not match! Please try again!' => 'Uw wachtwoord kan niet worden gewijzigd, de wachtwoorden komen niet overeen. Probeer het opnieuw.',
        'Can\'t update password, invalid characters!' => 'Uw wachtwoord kan niet worden gewijzigd, er zijn ongeldige karakters gevonden.',
        'Can\'t update password, must be at least %s characters!' => 'Uw wachtwoord kan niet worden gewijzigd, er zijn minimaal %s karakters noodzakelijk.',
        'Can\'t update password, must contain 2 lower and 2 upper characters!' => 'Uw wachtwoord kan niet worden gewijzigd, er zijn minimaal 2 kleine en 2 hoofdletters noodzakelijk.',
        'Can\'t update password, needs at least 1 digit!' => 'Uw wachtwoord kan niet worden gewijzigd, er is minimaal 1 cijfer noodzakelijk.',
        'Can\'t update password, needs at least 2 characters!' => 'Uw wachtwoord kan niet worden gewijzigd, er zijn minimaal 2 letters noodzakelijk.',

        # Template: AAAStats
        'Stat' => 'Statistiek',
        'Please fill out the required fields!' => 'Vul de verplichte velden in alstublieft!',
        'Please select a file!' => 'Selecteer een bestand alstublieft!',
        'Please select an object!' => 'Selecteer een object',
        'Please select a graph size!' => 'Selecteer de grootte van de grafiek',
        'Please select one element for the X-axis!' => 'Selecteer een element voor X-as',
        'Please select only one element or turn off the button \'Fixed\' where the select field is marked!' => 'Selecteer een element of haal het vinkje bij \'Statisch\' weg',
        'If you use a checkbox you have to select some attributes of the select field!' => 'Als u een attribuut selecteert moet u ook één of meerdere waarden van dit attribuut selecteren',
        'Please insert a value in the selected input field or turn off the \'Fixed\' checkbox!' => 'Selecteer een element of haal het vinkje bij \'Statisch\' weg',
        'The selected end time is before the start time!' => 'De opgegeven eindtijd ligt voor de starttijd',
        'You have to select one or more attributes from the select field!' => 'Kies één of meer attributen',
        'The selected Date isn\'t valid!' => 'De geselecteerde datum is niet geldig',
        'Please select only one or two elements via the checkbox!' => 'Kies één of meer elementen met de keuzebox',
        'If you use a time scale element you can only select one element!' => 'Als u een tijdselement kiest kunt u maar één element selecteren',
        'You have an error in your time selection!' => 'De tijdselectie bevat een fout',
        'Your reporting time interval is too small, please use a larger time scale!' => 'De tijdsinterval is te klein, kies een grotere interval',
        'The selected start time is before the allowed start time!' => 'De starttijd is te vroeg',
        'The selected end time is after the allowed end time!' => 'De eindtijd is te laat',
        'The selected time period is larger than the allowed time period!' => 'De geselecteerde tijdsperiode is langer dan de toegestane periode',
        'Common Specification' => 'Algemene eigenschappen',
        'Xaxis' => 'X-as',
        'Value Series' => 'Waardes',
        'Restrictions' => 'Restricties',
        'graph-lines' => 'lijnengrafiek',
        'graph-bars' => 'balkengrafiek',
        'graph-hbars' => 'horizontale balkengrafiek',
        'graph-points' => 'puntengrafiek',
        'graph-lines-points' => 'linen- en puntengrafiek',
        'graph-area' => 'vlakkengrafiek',
        'graph-pie' => 'taartpuntengrafiek',
        'extended' => 'uitgebreid',
        'Agent/Owner' => 'Behandelaar/Eigenaar',
        'Created by Agent/Owner' => 'Aangemaakt door behandelaar/eigenaar',
        'Created Priority' => 'Aangemaakt met prioriteit',
        'Created State' => 'Aangemaakt met status',
        'Create Time' => 'Aangemaakt op',
        'CustomerUserLogin' => 'Klantlogin',
        'Close Time' => 'Afsluitingstijd',
        'TicketAccumulation' => 'Ticket-totalen',
        'Attributes to be printed' => 'Attributen om af te drukken',
        'Sort sequence' => 'Sorteervolgorde',
        'Order by' => 'Sorteren op',
        'Limit' => 'Beperk tot',
        'Ticketlist' => 'Ticketoverzicht',
        'ascending' => 'aflopend',
        'descending' => 'oplopend',
        'First Lock' => 'Eerste vergrendeling',
        'Evaluation by' => 'Gebruik',
        'Total Time' => 'Totale tijd',
        'Ticket Average' => 'Gemiddelde per ticket',
        'Ticket Min Time' => 'Minimumtijd voor ticket',
        'Ticket Max Time' => 'Maximumtijd voor ticket',
        'Number of Tickets' => 'Aantal tickets',
        'Article Average' => 'Gemiddelde per interactie',
        'Article Min Time' => 'Minimumtijd voor interactie',
        'Article Max Time' => 'Maximumtijd voor interactie',
        'Number of Articles' => 'Aantal interacties',
        'Accounted time by Agent' => 'Bestede tijd per behandelaar',
        'Ticket/Article Accounted Time' => 'Bestede tijd voor ticket en interacties',
        'TicketAccountedTime' => 'Bestede tijd voor ticket',
        'Ticket Create Time' => 'Aanmaaktijd ticket',
        'Ticket Close Time' => 'Sluittijd ticket',

        # Template: AAATicket
        'Lock' => 'Vergrendel',
        'Unlock' => 'Ontgrendel',
        'History' => 'Geschiedenis',
        'Zoom' => 'Inhoud',
        'Age' => 'Leeftijd',
        'Bounce' => 'Bounce',
        'Forward' => 'Doorsturen',
        'From' => 'Van',
        'To' => 'Aan',
        'Cc' => 'Cc',
        'Bcc' => 'Bcc',
        'Subject' => 'Onderwerp',
        'Move' => 'Verplaatsen',
        'Queue' => 'Wachtrij',
        'Priority' => 'Prioriteit',
        'Priority Update' => 'Prioriteit wijziging',
        'State' => 'Status',
        'Compose' => 'Maken',
        'Pending' => 'Wachten',
        'Owner' => 'Eigenaar',
        'Owner Update' => 'Eigenaar gewijzigd',
        'Responsible' => 'Verantwoordelijke',
        'Responsible Update' => 'Verantwoordelijke gewijzigd',
        'Sender' => 'Afzender',
        'Article' => 'Interactie',
        'Articles' => 'Interacties',
        'Ticket' => 'Ticket',
        'Createtime' => 'Aangemaakt op',
        'plain' => 'zonder opmaak',
        'Email' => 'E-mail',
        'email' => 'e-mail',
        'Close' => 'Sluiten',
        'Action' => 'Actie',
        'Attachment' => 'Bijlage',
        'Attachments' => 'Bijlagen',
        'This message was written in a character set other than your own.' => 'Dit bericht is geschreven in een andere karakterset dan degene die u nu heeft ingesteld.',
        'If it is not displayed correctly,' => 'Als dit niet juist wordt weergegeven,',
        'This is a' => 'Dit is een',
        'to open it in a new window.' => 'om deze in een nieuw venster te openen',
        'This is a HTML email. Click here to show it.' => 'Dit is een HTML e-mail. Klik hier om deze te tonen.',
        'Free Fields' => 'Vrije invulvelden',
        'Merge' => 'Samenvoegen',
        'merged' => 'samengevoegd',
        'closed successful' => 'succesvol gesloten',
        'closed unsuccessful' => 'niet succesvol gesloten',
        'new' => 'nieuw',
        'open' => 'open',
        'Open' => 'Open',
        'closed' => 'gesloten',
        'Closed' => 'Gesloten',
        'removed' => 'verwijderd',
        'pending reminder' => 'wachtend op een herinnering',
        'pending auto' => 'wachtend',
        'pending auto close+' => 'wachtend op automatisch succesvol sluiten',
        'pending auto close-' => 'wachtend op automatisch niet succesvol sluiten',
        'email-external' => 'e-mail extern',
        'email-internal' => 'e-mail intern',
        'note-external' => 'externe notitie',
        'note-internal' => 'interne notitie',
        'note-report' => 'notitie rapport',
        'phone' => 'telefoon',
        'sms' => 'sms',
        'webrequest' => 'verzoek via web',
        'lock' => 'vergrendeld',
        'unlock' => 'niet vergrendeld',
        'very low' => 'zeer laag',
        'low' => 'laag',
        'normal' => 'normaal',
        'high' => 'hoog',
        'very high' => 'zeer hoog',
        '1 very low' => '1 zeer laag',
        '2 low' => '2 laag',
        '3 normal' => '3 normaal',
        '4 high' => '4 hoog',
        '5 very high' => '5 zeer hoog',
        'Ticket "%s" created!' => 'Ticket "%s" aangemaakt',
        'Ticket Number' => 'Ticket nummer',
        'Ticket Object' => 'Ticket onderwerp',
        'No such Ticket Number "%s"! Can\'t link it!' => 'Ticketnummer "%s" niet gevonden! Kan dus geen koppeling worden gemaakt!',
        'Don\'t show closed Tickets' => 'Gesloten tickets niet tonen',
        'Show closed Tickets' => 'Gesloten tickets wel tonen',
        'New Article' => 'Nieuwe interactie',
        'Email-Ticket' => 'E-mail ticket',
        'Create new Email Ticket' => 'Maak nieuw E-mail ticket aan',
        'Phone-Ticket' => 'Telefoon ticket',
        'Search Tickets' => 'Zoek tickets',
        'Edit Customer Users' => 'Wijzig klanten',
        'Edit Customer Company' => 'Wijzig bedrijven',
        'Bulk Action' => 'Bulk Actie',
        'Bulk Actions on Tickets' => 'Bulk actie op tickets',
        'Send Email and create a new Ticket' => 'Verstuur e-mail en maak een nieuw ticket aan',
        'Create new Email Ticket and send this out (Outbound)' => 'Maak een nieuw ticket aan en verstuur email (uitgaand)',
        'Create new Phone Ticket (Inbound)' => 'Maak nieuw ticket aan van telefoongesprek',
        'Overview of all open Tickets' => 'Laat alle open tickets zien',
        'Locked Tickets' => 'Vergrendelde tickets',
        'Watched Tickets' => 'Gevolgde tickets',
        'Watched' => 'Gevolgd',
        'Subscribe' => 'Inschrijven',
        'Unsubscribe' => 'Uitschrijven',
        'Lock it to work on it!' => 'Vergrendel een ticket om er mee te kunnen werken.',
        'Unlock to give it back to the queue!' => 'Ontgrendel een ticket om deze vrij te geven.',
        'Shows the ticket history!' => 'Laat de geschiedenis van het ticket zien.',
        'Print this ticket!' => 'Print het ticket.',
        'Change the ticket priority!' => 'Wijzig de prioriteit van het ticket.',
        'Change the ticket free fields!' => 'Wijzig de vrije invulvelden van het ticket.',
        'Link this ticket to an other objects!' => 'Koppel het ticket met andere items.',
        'Change the ticket owner!' => 'Wijzig de eigenaar van het ticket.',
        'Change the ticket customer!' => 'Wijzig de klant van het ticket.',
        'Add a note to this ticket!' => 'Voeg een notitie toe aan het ticket.',
        'Merge this ticket!' => 'Voeg dit Ticket samen met een ander ticket.',
        'Set this ticket to pending!' => 'Plaats dit ticket in de wacht.',
        'Close this ticket!' => 'Sluit dit ticket.',
        'Look into a ticket!' => 'Bekijk dit ticket.',
        'Delete this ticket!' => 'Verwijder dit ticket.',
        'Mark as Spam!' => 'Markeer als spam.',
        'My Queues' => 'Mijn wachtrijen',
        'Shown Tickets' => 'Laat tickets zien',
        'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' => 'Uw e-mail met ticket nummer "<OTRS_TICKET>" is samengevoegd met "<OTRS_MERGE_TO_TICKET>".',
        'Ticket %s: first response time is over (%s)!' => 'Ticket %s: eerste antwoord tijd is voorbij (%s)!',
        'Ticket %s: first response time will be over in %s!' => 'Ticket %s: eerste antwoord tijd zal voorbij zijn binnen %s!',
        'Ticket %s: update time is over (%s)!' => 'Ticket %s: vervolg tijd is voorbij (%s)!',
        'Ticket %s: update time will be over in %s!' => 'Ticket %s: vervolg tijd zal voorbij zijn binnen %s!',
        'Ticket %s: solution time is over (%s)!' => 'Ticket %s: oplossing tijd is voorbij (%s)!',
        'Ticket %s: solution time will be over in %s!' => 'Ticket %s: oplossing tijd zal voorbij zijn binnen %s!',
        'There are more escalated tickets!' => 'Er zijn geen geëscaleerde tickets meer!',
        'New ticket notification' => 'Melding bij een nieuw ticket',
        'Send me a notification if there is a new ticket in "My Queues".' => 'Stuur mij een melding als er een nieuw ticket in Mijn wachtrijen komt.',
        'Follow up notification' => 'Melding bij vervolgvragen',
        'Send me a notification if a customer sends a follow up and I\'m the owner of the ticket or the ticket is unlocked and is in one of my subscribed queues.' => 'Stuur mij een melding als een klant een vervolgvraag stelt en ik de eigenaar van het ticket ben, of als het ticket niet vergrendeld is en in Mijn Wachtrijen staat.',
        'Ticket lock timeout notification' => 'Stuur mij een melding van tijdsoverschrijding van een vergrendeld ticket',
        'Send me a notification if a ticket is unlocked by the system.' => 'Stuur mij een melding van een bericht als een ticket wordt ontgrendeld door het systeem.',
        'Move notification' => 'Stuur mij een melding bij het verplaatsen van een ticket',
        'Send me a notification if a ticket is moved into one of "My Queues".' => ' Stuur mij een melding als een ticket wordt verplaatst in een gewijzigde wachtrij.',
        'Your queue selection of your favourite queues. You also get notified about those queues via email if enabled.' => 'Uw selectie van favoriete wachtrijen. U ontvangt automatisch een melding van nieuwe tickets in deze wachtrij, als u hiervoor heeft gekozen.',
        'Custom Queue' => 'Aangepaste wachtrij.',
        'QueueView refresh time' => 'Verversingstijd wachtrij',
        'Screen after new ticket' => 'Scherm na het aanmaken van een nieuw ticket',
        'Select your screen after creating a new ticket.' => 'Selecteer het vervolgscherm na het invoeren van een nieuw ticket.',
        'Closed Tickets' => 'Afgesloten tickets',
        'Show closed tickets.' => 'Toon gesloten tickets',
        'Max. shown Tickets a page in QueueView.' => 'Max. getoonde tickets per pagina in wachtrijscherm.',
        'Watch notification' => 'Gevolgde tickets',
        'Send me a notification of an watched ticket like an owner of an ticket.' => 'Stuur mij notificaties van gevolgde tickets alsof ik de eigenaar ben.',
        'Out Of Office' => 'Afwezigheid',
        'Select your out of office time.' => 'Geef hieronder het tijdvak aan waarin u afwezig bent. Gedurende deze periode zien andere behandelaars uw afwezigheid.',
        'CompanyTickets' => 'Tickets van bedrijf',
        'MyTickets' => 'Mijn tickets',
        'New Ticket' => 'Nieuw ticket',
        'Create new Ticket' => 'Maak nieuw ticket aan',
        'Customer called' => 'Klant gebeld',
        'phone call' => 'telefoongesprek',
        'Reminder Reached' => 'Herinnermoment bereikt',
        'Reminder Tickets' => 'Tickets met herinnering',
        'Escalated Tickets' => 'Geëscaleerde tickets',
        'New Tickets' => 'Nieuwe tickets',
        'Open Tickets / Need to be answered' => 'Open tickets / wachtend op antwoord',
        'Tickets which need to be answered!' => 'Tickets die moeten worden behandeld',
        'All new tickets!' => 'Alle nieuwe tickets',
        'All tickets which are escalated!' => 'Alle geëscaleerde tickets',
        'All tickets where the reminder date has reached!' => 'Alle tickets waar het herinnermoment is bereikt',
        'Responses' => 'Standaard antwoorden',
        'Responses <-> Queue' => 'Standaard antwoorden <-> Wachtrijen',
        'Auto Responses' => 'Automatische replies',
        'Auto Responses <-> Queue' => 'Automatische replies <-> Wachtrijen',
        'Attachments <-> Responses' => 'Bijlagen <-> Standaard antwoorden',
        'History::Move' => 'Ticket verplaatst naar wachtrij "%s" (%s) van wachtrij "%s" (%s).',
        'History::TypeUpdate' => 'Type gewijzigd naar %s (ID=%s).',
        'History::ServiceUpdate' => 'Service gewijzigd naar %s (ID=%s).',
        'History::SLAUpdate' => 'SLA gewijzigd naar %s (ID=%s).',
        'History::NewTicket' => 'Nieuw ticket [%s] aangemaakt (Q=%s;P=%s;S=%s).',
        'History::FollowUp' => 'Vervolg vraag voor [%s]. %s',
        'History::SendAutoReject' => 'Automatische afwijzing verstuurd aan "%s".',
        'History::SendAutoReply' => 'Automatische beantwoording verstuurd aan "%s".',
        'History::SendAutoFollowUp' => 'Automatische follow-up verstuurd aan "%s".',
        'History::Forward' => 'Doorgestuurd aan "%s".',
        'History::Bounce' => 'Gebounced naar "%s".',
        'History::SendAnswer' => 'E-mail verstuurd aan "%s".',
        'History::SendAgentNotification' => '"%s"-notificatie verstuurd aan "%s".',
        'History::SendCustomerNotification' => 'Notificatie verstuurd aan "%s".',
        'History::EmailAgent' => 'E-mail verzonden aan klant.',
        'History::EmailCustomer' => 'E-mail toegevoegd. %s',
        'History::PhoneCallAgent' => 'Klant gebeld.',
        'History::PhoneCallCustomer' => 'Klant heeft gebeld.',
        'History::AddNote' => 'Notitie toegevoegd (%s)',
        'History::Lock' => 'Ticket vergrendeld.',
        'History::Unlock' => 'Ticket ontgrendeld.',
        'History::TimeAccounting' => '%s tijdseenheden verantwoord. Nu %s tijdseenheden totaal.',
        'History::Remove' => 'Verwijderd: %s',
        'History::CustomerUpdate' => 'Bijgewerkt: %s',
        'History::PriorityUpdate' => 'Prioriteit gewijzigd van "%s" (%s) naar "%s" (%s).',
        'History::OwnerUpdate' => 'Nieuwe eigenaar is "%s" (ID=%s).',
        'History::LoopProtection' => 'Loop beveiliging! Geen auto-reply verstuurd aan "%s".',
        'History::Misc' => '%s',
        'History::SetPendingTime' => 'Bijgewerkt: %s',
        'History::StateUpdate' => 'Oud: "%s" Nieuw: "%s"',
        'History::TicketFreeTextUpdate' => 'Bijgewerkt: %s=%s;%s=%s;',
        'History::WebRequestCustomer' => 'Klant stelt vraag via web.',
        'History::TicketLinkAdd' => 'Link naar "%s" toegevoegd.',
        'History::TicketLinkDelete' => 'Link naar "%s" verwijderd.',
        'History::Subscribe' => 'Added subscription for user "%s".',
        'History::Unsubscribe' => 'Removed subscription for user "%s".',

        # Template: AAAWeekDay
        'Sun' => 'zo',
        'Mon' => 'ma',
        'Tue' => 'di',
        'Wed' => 'wo',
        'Thu' => 'do',
        'Fri' => 'vr',
        'Sat' => 'za',

        # Template: AdminAttachmentForm
        'Attachment Management' => 'Beheer bijlagen',

        # Template: AdminAutoResponseForm
        'Auto Response Management' => 'Beheer automatische replies',
        'Response' => 'Antwoord',
        'Auto Response From' => 'E-mailadres',
        'Note' => 'Notitie',
        'Useable options' => 'Variabelen',
        'To get the first 20 character of the subject.' => 'Voor de eerste 20 tekens van het onderwerp',
        'To get the first 5 lines of the email.' => 'Voor de eerste vijf regels van het e-mail bericht',
        'To get the realname of the sender (if given).' => 'Voor de echte naam van de afzender (indien beschikbaar)',
        'To get the article attribute (e. g. (<OTRS_CUSTOMER_From>, <OTRS_CUSTOMER_To>, <OTRS_CUSTOMER_Cc>, <OTRS_CUSTOMER_Subject> and <OTRS_CUSTOMER_Body>).' => 'Voor de eigenschappen van de interactie (bijvoorbeeld <OTRS_CUSTOMER_From>, <OTRS_CUSTOMER_To>, <OTRS_CUSTOMER_Cc>, <OTRS_CUSTOMER_Subject> and <OTRS_CUSTOMER_Body>).',
        'Options of the current customer user data (e. g. <OTRS_CUSTOMER_DATA_UserFirstname>).' => 'Gegevens van de huidige klant (bijvoorbeeld <OTRS_CUSTOMER_DATA_UserFirstname>).',
        'Ticket owner options (e. g. <OTRS_OWNER_UserFirstname>).' => 'Gegevens van de ticket eigenaar (bijvoorbeeld <OTRS_OWNER_UserFirstname>).',
        'Ticket responsible options (e. g. <OTRS_RESPONSIBLE_UserFirstname>).' => 'Gegevens van de ticket verantwoordelijke (bijvoorbeeld <OTRS_RESPONSIBLE_UserFirstname).',
        'Options of the current user who requested this action (e. g. <OTRS_CURRENT_UserFirstname>).' => 'Gegevens van de huidige gebruiker die deze actie heeft verzocht (bijvoorbeeld <OTRS_CURRENT_UserFirstname>).',
        'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>).' => 'Gegevens van het ticket (bijvoorbeeld <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>).',
        'Config options (e. g. <OTRS_CONFIG_HttpType>).' => 'Configuratie-gegevens (bijvoorbeeld <OTRS_CONFIG_HttpType>).',

        # Template: AdminCustomerCompanyForm
        'Customer Company Management' => 'Beheer bedrijven',
        'Search for' => 'Zoek naar',
        'Add Customer Company' => 'Bedrijf toevoegen',
        'Add a new Customer Company.' => 'Voeg een nieuw bedrijf toe.',
        'List' => 'Lijst',
        'This values are required.' => 'Deze waarden zijn verplicht.',
        'This values are read only.' => 'Deze waarden kunt u alleen lezen.',

        # Template: AdminCustomerUserForm
        'The message being composed has been closed.  Exiting.' => 'Het bericht dat werd aangemaakt is gesloten.',
        'This window must be called from compose window' => 'Dit scherm moet van het scherm <opstellen bericht> worden aangeroepen',
        'Customer User Management' => 'Gebruikersbeheer klanten',
        'Add Customer User' => 'Klanten toevoegen',
        'Source' => 'Bron',
        'Create' => 'Aanmaken',
        'Customer user will be needed to have a customer history and to login via customer panel.' => 'Klanten moeten een klanthistorie hebben voordat zij kunnen inloggen via de klantschermen.',

        # Template: AdminCustomerUserGroupChangeForm
        'Customer Users <-> Groups Management' => 'Klanten <-> Groepen beheer',
        'Change %s settings' => 'Wijzig instellingen voor %s',
        'Select the user:group permissions.' => 'Selecteer de gebruikers / groep rechten',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the user).' => 'Als er geen selectie is gemaakt dan zijn er geen rechten voor deze groep (Tickets zullen dus niet beschikbaar zijn voor de gebruiker).',
        'Permission' => 'Rechten',
        'ro' => 'alleen lezen',
        'Read only access to the ticket in this group/queue.' => 'Leesrechten op de tickets in deze groep / wachtrij.',
        'rw' => 'lezen + schrijven',
        'Full read and write access to the tickets in this group/queue.' => 'Volledige lees- en schrijfrechten op de tickets in deze groep / wachtrij.',

        # Template: AdminCustomerUserGroupForm

        # Template: AdminCustomerUserService
        'Customer Users <-> Services Management' => 'Beheer Klanten <-> Services',
        'CustomerUser' => 'Klant',
        'Service' => 'Service',
        'Edit default services.' => 'Wijzig standaard services',
        'Search Result' => 'Zoekresultaat',
        'Allocate services to CustomerUser' => 'Koppel services aan klant',
        'Active' => 'Actief',
        'Allocate CustomerUser to service' => 'Koppel klanten aan service',

        # Template: AdminEmail
        'Message sent to' => 'Bericht verstuurd naar',
        'A message should have a subject!' => 'Geef een onderwerp op voor dit bericht',
        'Recipients' => 'Ontvangers',
        'Body' => 'Bericht tekst',
        'Send' => 'Verstuur',

        # Template: AdminGenericAgent
        'GenericAgent' => 'Automatische taken',
        'Job-List' => 'Takenlijst',
        'Last run' => 'Laatst uitgevoerd',
        'Run Now!' => 'Nu uitvoeren',
        'x' => 'x',
        'Save Job as?' => 'Sla taak op onder',
        'Is Job Valid?' => 'Activatie',
        'Is Job Valid' => 'Is de taak actief?',
        'Schedule' => 'Plan in',
        'Currently this generic agent job will not run automatically.' => 'Deze job zal niet automatisch draaien.',
        'To enable automatic execution select at least one value from minutes, hours and days!' => 'Om automatisch uit te voeren selecteer ten minste één waarde bij minuten, uren en dagen.',
        'Fulltext-Search in Article (e. g. "Mar*in" or "Baue*")' => 'Gebruik wildcards (bijvoorbeeld "Mar*in" of "Jans*")',
        '(e. g. 10*5155 or 105658*)' => '(bijvoorbeeld 10*5155 or 105658*)',
        '(e. g. 234321)' => '(bijvoorbeeld 234321)',
        'Customer User Login' => 'Klantlogin',
        '(e. g. U5150)' => '(bijvoorbeeld U5150)',
        'SLA' => 'SLA',
        'Agent' => 'Behandelaar',
        'Ticket Lock' => 'Ticketvergrendeling',
        'TicketFreeFields' => 'Vrije invulvelden van het ticket',
        'Create Times' => 'Zoek op aanmaakdatum',
        'No create time settings.' => 'Alle',
        'Ticket created' => 'Ticket aangemaakt',
        'Ticket created between' => 'Ticket aangemaakt tussen',
        'Close Times' => 'Zoek op sluitdatum',
        'No close time settings.' => 'Alle',
        'Ticket closed' => 'Ticket gesloten',
        'Ticket closed between' => 'Ticket gesloten tussen',
        'Pending Times' => 'Wachtend tot',
        'No pending time settings.' => 'Niet op zoeken',
        'Ticket pending time reached' => 'Ticket wachtend tot tijd bereikt',
        'Ticket pending time reached between' => 'Ticket wachtend tot tijd tussen',
        'Escalation Times' => 'Escalatiemoment',
        'No escalation time settings.' => 'Niet op zoeken',
        'Ticket escalation time reached' => 'Escalatiemoment bereikt',
        'Ticket escalation time reached between' => 'Escalatiemoment bereikt tussen',
        'Escalation - First Response Time' => 'Escalatiemoment First Response',
        'Ticket first response time reached' => 'Escalatiemoment First Response bereikt',
        'Ticket first response time reached between' => 'Escalatiemoment First Response bereikt tussen',
        'Escalation - Update Time' => 'Escalatiemoment Update Time',
        'Ticket update time reached' => 'Escalatiemoment Update Time bereikt',
        'Ticket update time reached between' => 'Escalatiemoment Update Time bereikt tussen',
        'Escalation - Solution Time' => 'Escalatiemoment Oplostijd',
        'Ticket solution time reached' => 'Escalatiemoment Oplostijd bereikt',
        'Ticket solution time reached between' => 'Escalatiemoment Oplostijd bereikt tussen',
        'New Service' => 'Nieuwe service',
        'New SLA' => 'Nieuwe SLA',
        'New Priority' => 'Nieuwe prioriteit',
        'New Queue' => 'Nieuwe wachtrij',
        'New State' => 'Nieuwe status',
        'New Agent' => 'Nieuwe behandelaar',
        'New Owner' => 'nieuwe eigenaar',
        'New Customer' => 'Nieuwe klant',
        'New Ticket Lock' => 'Nieuwe ticketvergrendeling',
        'New Type' => 'nieuw type',
        'New Title' => 'Nieuwe titel',
        'New TicketFreeFields' => 'Nieuwe vrije velden',
        'Add Note' => 'Notitie toevoegen',
        'Time units' => 'Bestede tijd ',
        'CMD' => 'Commando',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' => 'Dit commando zal worden uitgevoerd. ARG[0] is het nieuwe ticketnummer. ARG[1] is het nieuwe ticketid.',
        'Delete tickets' => 'Verwijder tickets.',
        'Warning! This tickets will be removed from the database! This tickets are lost!' => 'Waarschuwing: deze tickets zullen worden verwijderd uit de database!',
        'Send Notification' => 'Stuur notificatie',
        'Param 1' => 'Parameter 1',
        'Param 2' => 'Parameter 2',
        'Param 3' => 'Parameter 3',
        'Param 4' => 'Parameter 4',
        'Param 5' => 'Parameter 5',
        'Param 6' => 'Parameter 6',
        'Send agent/customer notifications on changes' => 'Stuur behandelaar/klant notificatie bij wijzigingen',
        'Save' => 'Opslaan',
        '%s Tickets affected! Do you really want to use this job?' => '%s Tickets worden bewerkt! Weet u zeker dat u deze actie wilt uitvoeren?',

        # Template: AdminGroupForm
        'WARNING: When you change the name of the group \'admin\', before making the appropriate changes in the SysConfig, you will be locked out of the administrations panel! If this happens, please rename the group back to admin per SQL statement.' => 'WAARSCHUWING: Als u de naam van de groep \'Admin\'aanpast voordat u de bijbehorende wijzigingen in de Systeemconfiguratie heeft aangebracht, zult u geen beheer-rechten meer hebben in OTRS. Als dit gebeurt, moet u de naam van de groep aanpassen met een SQL statement.',
        'Group Management' => 'Groepenbeheer',
        'Add Group' => 'Groep toevoegen',
        'Add a new Group.' => 'Nieuwe groep toevoegen',
        'The admin group is to get in the admin area and the stats group to get stats area.' => 'Leden van de groep Admin mogen in het administratie gedeelte, leden van de groep Stats hebben toegang tot het statistieken gedeelte.',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).' => 'Maak nieuwe groepen aan om de toegangsrechten te regelen voor verschillende groepen van agenten (bijvoorbeeld verkoopafdeling, supportafdeling).',
        'It\'s useful for ASP solutions.' => 'Bruikbaar voor ASP-oplossingen.',

        # Template: AdminLog
        'System Log' => 'Logboek',
        'Time' => 'Tijd',

        # Template: AdminMailAccount
        'Mail Account Management' => 'Beheer e-mail accounts',
        'Host' => 'Server',
        'Trusted' => 'Vertrouwd',
        'Dispatching' => 'Sortering',
        'All incoming emails with one account will be dispatched in the selected queue!' => 'Alle binnenkomende e-mails van een account zullen worden standaard geplaatst worden in de opgegeven wachtrij.',
        'If your account is trusted, the already existing X-OTRS header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' => 'Als het account gemarkeerd is als \'vertrouwd\' worden al bestaande X-OTRS headers bij aankomst gebruikt. Hierna worden de e-mail filters doorlopen.',

        # Template: AdminNavigationBar
        'Users' => 'Gebruikers',
        'Groups' => 'Groepen',
        'Misc' => 'Overige',

        # Template: AdminNotificationEventForm
        'Notification Management' => 'Meldingen beheer',
        'Add Notification' => 'Melding toevoegen',
        'Add a new Notification.' => 'Voeg een melding toe',
        'Name is required!' => 'Naam is verplicht!',
        'Event is required!' => 'Kies een event',
        'A message should have a body!' => 'Geen berichttekst ingevuld!',
        'Recipient' => 'Afzender',
        'Group based' => 'Gebaseerd op groep',
        'Agent based' => 'Gebaseerd op behandelaar',
        'Email based' => 'Gebaseerd op e-mail',
        'Article Type' => 'Soort interactie',
        'Only for ArticleCreate Event.' => 'Alleen voor ArticleCreate',
        'Subject match' => 'Onderwerp',
        'Body match' => 'Bericht tekst',
        'Notifications are sent to an agent or a customer.' => 'Meldingen worden verstuurd naar een behandelaar of een klant',
        'To get the first 20 character of the subject (of the latest agent article).' => 'Om de eerste 20 karakters van het onderwerp van de nieuwste behandelaar-interactie te tonen',
        'To get the first 5 lines of the body (of the latest agent article).' => 'Om de eerste vijf regels van de tekst van de nieuwste behandelaar-interactie te tonen',
        'To get the article attribute (e. g. (<OTRS_AGENT_From>, <OTRS_AGENT_To>, <OTRS_AGENT_Cc>, <OTRS_AGENT_Subject> and <OTRS_AGENT_Body>).' => 'Om attributen van de interactie te gebruiken (bijvoorbeeld <OTRS_AGENT_From>, <OTRS_AGENT_To>, <OTRS_AGENT_Cc>, <OTRS_AGENT_Subject> and <OTRS_AGENT_Body>)',
        'To get the first 20 character of the subject (of the latest customer article).' => 'Om de eerste 20 karakters van het onderwerp van de nieuwste klant-interactie te tonen',
        'To get the first 5 lines of the body (of the latest customer article).' => 'Om de eerste vijf regels van de tekst van de nieuwste klant-interactie te tonen',

        # Template: AdminNotificationForm
        'Notification' => 'Melding',

        # Template: AdminPackageManager
        'Package Manager' => 'Pakketbeheer',
        'Uninstall' => 'Deïnstalleer',
        'Version' => 'Versie',
        'Do you really want to uninstall this package?' => 'Wilt u dit pakket echt verwijderen?',
        'Reinstall' => 'Herinstalleer',
        'Do you really want to reinstall this package (all manual changes get lost)?' => 'Wilt u dit pakket echt herinstalleren? Alle handmatige wijzigingen gaan verloren.',
        'Continue' => 'Doorgaan',
        'Install' => 'Installeer',
        'Package' => 'Pakket',
        'Online Repository' => 'Online Repository',
        'Vendor' => 'Leverancier',
        'Module documentation' => 'Moduledocumentatie',
        'Upgrade' => 'Upgrade',
        'Local Repository' => 'Lokale Repository',
        'Status' => 'Status',
        'Overview' => 'Overzicht',
        'Download' => 'Downloaden',
        'Rebuild' => 'Herbouw',
        'ChangeLog' => 'Wijziging',
        'Date' => 'Datum',
        'Filelist' => 'Bestandslijst',
        'Download file from package!' => 'Download bestand van pakket!',
        'Required' => 'Verplicht',
        'PrimaryKey' => 'Primaire sleutel',
        'AutoIncrement' => 'AutoIncrement',
        'SQL' => 'SQL statement',
        'Diff' => 'Diff',

        # Template: AdminPerformanceLog
        'Performance Log' => 'Performance Log',
        'This feature is enabled!' => 'Deze feature is ingeschakeld',
        'Just use this feature if you want to log each request.' => 'Activeer de Performance Log alleen als u ieder verzoek wilt loggen.',
        'Activating this feature might affect your system performance!' => 'Deze feature gaat zelf ook een beetje ten koste van de performance.',
        'Disable it here!' => 'Uitschakelen',
        'This feature is disabled!' => 'Deze feature is geactiveerd',
        'Enable it here!' => 'Inschakelen',
        'Logfile too large!' => 'Logbestand te groot',
        'Logfile too large, you need to reset it!' => 'Het logbestand is te groot, leeg deze eerst',
        'Range' => 'Bereik',
        'Interface' => 'Interface',
        'Requests' => 'Verzoeken',
        'Min Response' => 'Minimaal',
        'Max Response' => 'Maximaal',
        'Average Response' => 'Gemiddelde',
        'Period' => 'Looptijd',
        'Min' => 'Min',
        'Max' => 'Max',
        'Average' => 'Gemiddeld',

        # Template: AdminPGPForm
        'PGP Management' => 'PGP beheer',
        'Result' => 'Resultaat',
        'Identifier' => 'Identifier',
        'Bit' => 'Bit',
        'Key' => 'Sleutel',
        'Fingerprint' => 'Fingerprint',
        'Expires' => 'Verloopt',
        'In this way you can directly edit the keyring configured in SysConfig.' => 'Hier kunt u de keyring beheren die is ingesteld in de systeemconfiguratie',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => 'E-mail filterbeheer',
        'Filtername' => 'Naam filter',
        'Stop after match' => 'Stop met filters na match',
        'Match' => 'Zoek eigen',
        'Value' => 'Waarde',
        'Set' => 'Nieuwe waarden',
        'Do dispatch or filter incoming emails based on email X-Headers! RegExp is also possible.' => 'U kunt ontvangen e-mailberichten filteren op basis van het e-mailadres, headers, het onderwerp of andere eigenschappen.',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' => 'Als u alleen wilt filteren op het e-mailadres, gebruik dan EMAILADDRESS:info@example.local in From, To of CC',
        'If you use RegExp, you also can use the matched value in () as [***] in \'Set\'.' => 'Bij gebruik van RegExp kunt u ook de gematchte waarde tussen haken () gebruiken als variabele met naam [***] ',

        # Template: AdminPriority
        'Priority Management' => 'Prioriteitenbeheer',
        'Add Priority' => 'Voeg prioriteit toe',
        'Add a new Priority.' => 'Nieuwe prioriteit toevoegen',

        # Template: AdminQueueAutoResponseForm
        'Queue <-> Auto Responses Management' => 'Wachtrij <-> Automatische replies',
        'settings' => 'Instellingen',

        # Template: AdminQueueForm
        'Queue Management' => 'Beheer wachtrijen',
        'Sub-Queue of' => 'Subwachtrij van',
        'Unlock timeout' => 'Ontgrendel na',
        '0 = no unlock' => '0 = geen ontgrendeling',
        'Only business hours are counted.' => 'Alleen kantooruren tellen mee',
        '0 = no escalation' => '0 = geen escalatie',
        'Notify by' => 'Notificatie op',
        'Follow up Option' => 'Follow up optie',
        'Ticket lock after a follow up' => 'Ticket-vergrendeling na een follow up',
        'Systemaddress' => 'Systeem-adres',
        'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.' => 'Wanneer een behandelaar een ticket vergrendelt en hij/zij stuurt geen antwoord binnen de vergrendeltijd dan zal het ticket automatisch ontgrendeld worden. Het ticket kan dan door andere agenten worden ingezien.',
        'Escalation time' => 'Escalatietijd',
        'If a ticket will not be answered in this time, just only this ticket will be shown.' => 'Als een ticket niet binnen deze tijd is beantwoord zal alleen dit ticket worden getoond.',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.' => 'Wanneer een ticket wordt gesloten en de klant stuurt een follow up wordt het ticket vergrendeld voor de oorspronkelijke eigenaar.',
        'Will be the sender address of this queue for email answers.' => 'is het afzenderadres van deze wachtrij voor antwoorden per e-mail',
        'The salutation for email answers.' => 'De aanhef voor beantwoording van berichten per e-mail.',
        'The signature for email answers.' => 'De ondertekening voor beantwoording van berichten per e-mail.',
        'Customer Move Notify' => 'Klantnotificatie bij verplaatsen',
        'OTRS sends an notification email to the customer if the ticket is moved.' => 'Het systeem stuurt een notificatie naar de klant wanneer het ticket wordt verplaatst',
        'Customer State Notify' => 'Klantnotificatie andere status',
        'OTRS sends an notification email to the customer if the ticket state has changed.' => 'Het systeem stuurt een notificatie naar de klant wanneer de status is veranderd',
        'Customer Owner Notify' => 'Klantnotificatie andere eigenaar',
        'OTRS sends an notification email to the customer if the ticket owner has changed.' => 'Het systeem stuurt een notificatie naar de klant wanneer de eigenaar is veranderd',

        # Template: AdminQueueResponsesChangeForm
        'Responses <-> Queue Management' => 'Beheer Standaard Antwoorden <-> Wachtrijen',

        # Template: AdminQueueResponsesForm
        'Answer' => 'Antwoord',

        # Template: AdminResponseAttachmentChangeForm
        'Responses <-> Attachments Management' => 'Beheer Standaard Antwoorden <-> Bijlagen',

        # Template: AdminResponseAttachmentForm

        # Template: AdminResponseForm
        'Response Management' => 'Beheer standaard antwoorden',
        'A response is default text to write faster answer (with default text) to customers.' => 'Een antwoord is een standaard-tekst om sneller antwoorden te kunnen opstellen.',
        'Don\'t forget to add a new response a queue!' => 'Vergeet niet om een antwoord aan een wachtrij te koppelen!',
        'The current ticket state is' => 'De huidige ticketstatus is.',
        'Your email address is new' => 'Uw e-mailadres is nieuw.',

        # Template: AdminRoleForm
        'Role Management' => 'Beheer Rollen',
        'Add Role' => 'Voeg rol toe',
        'Add a new Role.' => 'Voeg een nieuwe rol toe',
        'Create a role and put groups in it. Then add the role to the users.' => 'Maak een nieuwe rol en koppel deze aan groepen. Vervolgens kunt u rollen toewijzen aan gebruikers.',
        'It\'s useful for a lot of users and groups.' => 'Dit is nuttig bij grote hoeveelheden gebruikers en/of groepen.',

        # Template: AdminRoleGroupChangeForm
        'Roles <-> Groups Management' => 'Beheer Rollen <-> Groepen',
        'move_into' => 'verplaats naar',
        'Permissions to move tickets into this group/queue.' => 'Rechten om tickets naar deze groep/wachtrij te verplaatsen.',
        'create' => 'aanmaken',
        'Permissions to create tickets in this group/queue.' => 'Rechten om tickets in deze groep/wachtrij aan te maken.',
        'owner' => 'eigenaar',
        'Permissions to change the ticket owner in this group/queue.' => 'Rechten om de eigenaar van het ticket in deze groep / wachtrij te wijzigen.',
        'priority' => 'prioriteit',
        'Permissions to change the ticket priority in this group/queue.' => 'Rechten om de prioriteit van een ticket in deze groep / wachtrij te wijzigen.',

        # Template: AdminRoleGroupForm
        'Role' => 'Rol',

        # Template: AdminRoleUserChangeForm
        'Roles <-> Users Management' => 'Beheer Rollen <-> Gebruikers',
        'Select the role:user relations.' => 'Selecteer de rol : gebruiker relatie',

        # Template: AdminRoleUserForm

        # Template: AdminSalutationForm
        'Salutation Management' => 'Aanhef beheer',
        'Add Salutation' => 'Aanhef toevoegen',
        'Add a new Salutation.' => 'Een nieuwe aanhef toevoegen',

        # Template: AdminSecureMode
        'Secure Mode need to be enabled!' => 'Secure Mode moet geactiveerd zijn.',
        'Secure mode will (normally) be set after the initial installation is completed.' => 'Secure Mode wordt normaal gesproken geactiveerd na afronding van de installatie.',
        'Secure mode must be disabled in order to reinstall using the web-installer.' => 'Secure Mode moet gedeactiveerd worden om te kunnen herinstalleren met de web-installer',
        'If Secure Mode is not activated, activate it via SysConfig because your application is already running.' => 'Als Secure Mode nog niet aan staat moet u deze activeren in de Systeemconfiguratie.',

        # Template: AdminSelectBoxForm
        'SQL Box' => 'SQL Console',
        'CSV' => 'CSV',
        'HTML' => 'HTML',
        'Select Box Result' => 'Resultaat',

        # Template: AdminService
        'Service Management' => 'Service beheer',
        'Add Service' => 'Service toevoegen',
        'Add a new Service.' => 'Voeg nieuwe service toe',
        'Sub-Service of' => 'Service is onderdeel van',

        # Template: AdminSession
        'Session Management' => 'Sessiebeheer',
        'Sessions' => 'Sessies',
        'Uniq' => 'Uniek',
        'Kill all sessions' => 'Alle sessies afsluiten',
        'Session' => 'Sessie',
        'Content' => 'Inhoud',
        'kill session' => 'sessie afsluiten',

        # Template: AdminSignatureForm
        'Signature Management' => 'Handtekening beheer',
        'Add Signature' => 'Handtekening toevoegen',
        'Add a new Signature.' => 'Nieuwe handtekening toevoegen',

        # Template: AdminSLA
        'SLA Management' => 'SLA beheer',
        'Add SLA' => 'SLA toevoegen',
        'Add a new SLA.' => 'Nieuwe SLA toevoegen',

        # Template: AdminSMIMEForm
        'S/MIME Management' => 'S/MIME beheer',
        'Add Certificate' => 'Certificaat toevoegen',
        'Add Private Key' => 'Private Key toevoegen',
        'Secret' => 'Secret',
        'Hash' => 'Hash',
        'In this way you can directly edit the certification and private keys in file system.' => 'Hier kunt u de certificaten en private keys van OTRS beheren',

        # Template: AdminStateForm
        'State Management' => 'Status beheer',
        'Add State' => 'Status toevoegen',
        'Add a new State.' => 'Voeg een nieuwe status toe.',
        'State Type' => 'Status Type',
        'Take care that you also updated the default states in you Kernel/Config.pm!' => 'Bewerk ook de statussen in Kernel/Config.pm',
        'See also' => 'Zie voor meer informatie',

        # Template: AdminSysConfig
        'SysConfig' => 'Systeemconfiguratie',
        'Group selection' => 'Groep selectie',
        'Show' => 'Toon',
        'Download Settings' => 'Download configuratie',
        'Download all system config changes.' => 'De configuratie opslaan in een bestand.',
        'Load Settings' => 'Laad configuratie uit bestand',
        'Subgroup' => 'Subgroep',
        'Elements' => 'Elementen',

        # Template: AdminSysConfigEdit
        'Config Options' => 'Configuratie',
        'Default' => 'Standaard',
        'New' => 'Nieuw',
        'New Group' => 'Nieuwe groep',
        'Group Ro' => 'Alleen-lezen groep',
        'New Group Ro' => 'Nieuwe groep',
        'NavBarName' => 'Titel navigatiebalk',
        'NavBar' => 'Navigatiebalk',
        'Image' => 'Afbeelding',
        'Prio' => 'Prioriteit',
        'Block' => 'Blok',
        'AccessKey' => 'Sneltoetskoppeling',

        # Template: AdminSystemAddressForm
        'System Email Addresses Management' => 'Systeem e-mailadressen beheer',
        'Add System Address' => 'Systeem e-mailadres toevoegen',
        'Add a new System Address.' => 'Voeg nieuw systeem e-mailadres toe.',
        'Realname' => 'Echte naam',
        'All email addresses get excluded on replaying on composing an email.' => 'OTRS zal nooit mail sturen aan alle hier gedefiniëerde adressen',
        'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!' => 'Alle binnenkomende emails met deze "To:" worden in de gekozen wachtrij geplaatst.',

        # Template: AdminTypeForm
        'Type Management' => 'Type beheer',
        'Add Type' => 'Type toevoegen',
        'Add a new Type.' => 'Nieuw type toevoegen.',

        # Template: AdminUserForm
        'User Management' => 'Gebruikersbeheer',
        'Add User' => 'Nieuwe gebruiker toevoegen',
        'Add a new Agent.' => 'Voeg hier een nieuwe behandelaar toe',
        'Login as' => 'Inloggen als',
        'Firstname' => 'Voornaam',
        'Lastname' => 'Achternaam',
        'Start' => 'Begin',
        'End' => 'Einde',
        'User will be needed to handle tickets.' => 'Maak een gebruikersaccount aan voor iedere ticketbehandelaar.',
        'Don\'t forget to add a new user to groups and/or roles!' => 'Vergeet niet om een nieuwe gebruiker te koppelen aan de benodigde groepen en/of rollen.',

        # Template: AdminUserGroupChangeForm
        'Users <-> Groups Management' => 'Gebruikers <-> Groepen beheer',

        # Template: AdminUserGroupForm

        # Template: AgentBook
        'Address Book' => 'Adresboek',
        'Return to the compose screen' => 'Terug naar berichtscherm',
        'Discard all changes and return to the compose screen' => 'Veranderingen niet opslaan en ga terug naar het berichtscherm',

        # Template: AgentCalendarSmall

        # Template: AgentCalendarSmallIcon

        # Template: AgentCustomerSearch

        # Template: AgentCustomerTableView

        # Template: AgentDashboard
        'Dashboard' => 'Dashboard',

        # Template: AgentDashboardCalendarOverview
        'in' => 'tussen',

        # Template: AgentDashboardImage

        # Template: AgentDashboardProductNotify
        '%s %s is available!' => '%s %s is beschikbaar!',
        'Please update now.' => 'Voer nu een update uit.',
        'Release Note' => 'Releasenote',
        'Level' => 'Soort',

        # Template: AgentDashboardRSSOverview
        'Posted %s ago.' => 'Geplaatst %s geleden.',

        # Template: AgentDashboardTicketGeneric
        'All tickets' => 'Alle tickets',

        # Template: AgentDashboardTicketStats

        # Template: AgentDashboardUserOnline

        # Template: AgentInfo
        'Info' => 'Informatie',

        # Template: AgentLinkObject
        'Link Object: %s' => 'Koppel object: %s',
        'Object' => 'Object',
        'Link Object' => 'Koppel object',
        'with' => 'met',
        'Select' => 'Selecteer',
        'Unlink Object: %s' => 'Ontkoppel object',

        # Template: AgentLookup
        'Lookup' => 'Zoek',

        # Template: AgentNavigationBar

        # Template: AgentPreferencesForm

        # Template: AgentSpelling
        'Spell Checker' => 'Spellingcontrole',
        'spelling error(s)' => 'Spelfout(en)',
        'or' => 'of',
        'Apply these changes' => 'Pas deze wijzigingen toe',

        # Template: AgentStatsDelete
        'Do you really want to delete this Object?' => 'Weet u zeker dat u dit item wilt verwijderen?',

        # Template: AgentStatsEditRestrictions
        'Select the restrictions to characterise the stat' => 'Selecteer over welke data gerapporteerd moet worden',
        'Fixed' => 'Statisch',
        'Please select only one element or turn off the button \'Fixed\'.' => 'Kies een element, of schakel de optie \'Statisch\' uit',
        'Absolut Period' => 'Absolute data',
        'Between' => 'Tussen',
        'Relative Period' => 'Relatieve data',
        'The last' => 'De laatste',
        'Finish' => 'Voltooien',
        'Here you can make restrictions to your stat.' => 'Hier kunt u beperkingen voor deze statistiek opgeven.',
        'If you remove the hook in the "Fixed" checkbox, the agent generating the stat can change the attributes of the corresponding element.' => 'Als u het vinkje bij \'Statisch\' weghaalt, kunnen gebruikers de attributen van het bijbehorende element aanpassen bij het genereren van de statistieken.',

        # Template: AgentStatsEditSpecification
        'Insert of the common specifications' => 'Geef eigenschappen van statistieken op',
        'Permissions' => 'Rechten',
        'Format' => 'Formaat',
        'Graphsize' => 'Grafiek grootte',
        'Sum rows' => 'Toon totaal per rij',
        'Sum columns' => 'Toon totaal per kolom',
        'Cache' => 'Cache',
        'Required Field' => 'Verplicht veld',
        'Selection needed' => 'Selectie benodigd',
        'Explanation' => 'Uitleg',
        'In this form you can select the basic specifications.' => 'Hier kunt u de algemene eigenschappen opgeven',
        'Attribute' => 'Eigenschap',
        'Title of the stat.' => 'Naam van deze statistiek',
        'Here you can insert a description of the stat.' => 'Hier kunt u een beschrijving van deze statistieken toevoegen',
        'Dynamic-Object' => 'Dynamische metriek',
        'Here you can select the dynamic object you want to use.' => 'Selecteer de metriek die u wilt gebruiken',
        '(Note: It depends on your installation how many dynamic objects you can use)' => '(Let op: het is afhankelijk van uw installatie hoeveel dynamische metrieken u kunt gebruiken)',
        'Static-File' => '\'Hardcoded\' bestand',
        'For very complex stats it is possible to include a hardcoded file.' => 'Voor zeer complexe statistieken is het mogelijk om een \'hardcoded\' bestand te gebruiken',
        'If a new hardcoded file is available this attribute will be shown and you can select one.' => 'Als een \'hardcoded\' bestand beschikbaar is zal deze automatisch getoond worden en kunt u deze hier selecteren',
        'Permission settings. You can select one or more groups to make the configurated stat visible for different agents.' => 'U kunt één of meer groepen selecteren om de statistiek voor de gebruikers beschikbaar te maken',
        'Multiple selection of the output format.' => 'Vorm van de statistiek, meerdere selecties zijn mogelijk',
        'If you use a graph as output format you have to select at least one graph size.' => 'Als u een afbeelding als vorm heeft gekozen moet u tenminste één grootte selecteren',
        'If you need the sum of every row select yes' => 'Selecteer \'ja\' als u totalen per rij wilt',
        'If you need the sum of every column select yes.' => 'Selecteer \'ja\' als u totalen per kolom wilt',
        'Most of the stats can be cached. This will speed up the presentation of this stat.' => 'De meeste statistieken kunnen worden gecached, dit versnelt het genereren van de statistiek',
        '(Note: Useful for big databases and low performance server)' => '(Nuttig voor grote databases en langzame servers)',
        'With an invalid stat it isn\'t feasible to generate a stat.' => 'Als de statistiek op ongeldig staat kan deze niet gegenereerd worden.',
        'This is useful if you want that no one can get the result of the stat or the stat isn\'t ready configurated.' => 'Dit is handig als de statistiek nog niet gereed is.',

        # Template: AgentStatsEditValueSeries
        'Select the elements for the value series' => 'Selecteer de elementen voor de Y-as',
        'Scale' => 'Schaal',
        'minimal' => 'minimaal',
        'Please remember, that the scale for value series has to be larger than the scale for the X-axis (e.g. X-Axis => Month, ValueSeries => Year).' => 'Let er op dat de schaal voor de Y-as groter moet zijn dan die voor de X-as (bijvooreeld X-as = maand, Y-as = jaar).',
        'Here you can define the value series. You have the possibility to select one or two elements. Then you can select the attributes of elements. Each attribute will be shown as single value series. If you don\'t select any attribute all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' => 'Hier kunt u de Y-as definiëren. U heeft de mogelijkheid om één of twee elementen te selecteren. Daarna kunt u de attributen kiezen. Als u geen attribuut selecteerd zullen alle attributen gebruikt worden.',

        # Template: AgentStatsEditXaxis
        'Select the element, which will be used at the X-axis' => 'Selecteer het element dat gebruikt zal worden voor de X-as',
        'maximal period' => 'maximale periode',
        'minimal scale' => 'minimale schaal',
        'Here you can define the x-axis. You can select one element via the radio button. Then you you have to select two or more attributes of the element. If you make no selection all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' => 'Hier kunt u de waarden voor de X-as definiëren. U kunt een element kiezen via de radiobutton. Daarna kunt u twee of meer attributen van dit element kiezen. Als u géén selectie maakt worden alle attributen van dit element gebruikt in de statistiek.',

        # Template: AgentStatsImport
        'Import' => 'Importeer',
        'File is not a Stats config' => 'Het bestand is geen geldig statistieken configuratie bestand',
        'No File selected' => 'Geen bestand geselecteerd',

        # Template: AgentStatsOverview
        'Results' => 'Resultaten',
        'Total hits' => 'Totaal gevonden',
        'Page' => 'Pagina',

        # Template: AgentStatsPrint
        'Print' => 'Afdrukken',
        'No Element selected.' => 'Geen element geselecteerd.',

        # Template: AgentStatsView
        'Export Config' => 'Exporteer configuratie',
        'Information about the Stat' => 'Informatie over deze statistieken',
        'Exchange Axis' => 'Wissel assen',
        'Configurable params of static stat' => 'Configureerbare parameters voor statistiek',
        'No element selected.' => 'Geen element geselecteerd.',
        'maximal period from' => 'Maximale periode van',
        'to' => 'tot',
        'With the input and select fields you can configurate the stat at your needs. Which elements of a stat you can edit depends on your stats administrator who configurated the stat.' => 'Met de invoer- en selectievelden is de statistiek aanpasbaar. Welke elementen precies aan te passen zijn verschilt per statistiek.',

        # Template: AgentTicketBounce
        'A message should have a To: recipient!' => 'Geef teminste één ontvanger (aan:) op',
        'You need a email address (e. g. customer@example.com) in To:!' => 'In het Aan-veld is een e-mailadres nodig',
        'Bounce ticket' => 'Bounce Ticket',
        'Ticket locked!' => 'Ticket vergrendeld',
        'Ticket unlock!' => 'Ontgrendelen',
        'Bounce to' => 'Bounce naar',
        'Next ticket state' => 'Status',
        'Inform sender' => 'Informeer afzender',
        'Send mail!' => 'Bericht versturen!',

        # Template: AgentTicketBulk
        'You need to account time!' => 'Het is verplicht tijd te verantwoorden!',
        'Ticket Bulk Action' => 'Ticket Bulk Aktie',
        'Spell Check' => 'Spellingscontrole',
        'Note type' => 'Notitietype',
        'Next state' => 'Status',
        'Pending date' => 'In de wacht: datum',
        'Merge to' => 'Voeg samen met',
        'Merge to oldest' => 'Voeg samen met oudste',
        'Link together' => 'Koppelen',
        'Link to Parent' => 'Koppel aan hoofd-item',
        'Unlock Tickets' => 'Tickets ontgrendelen',

        # Template: AgentTicketClose
        'Ticket Type is required!' => 'Geen type ingevuld!',
        'A required field is:' => 'Verplicht veld:',
        'Close ticket' => 'Sluit ticket',
        'Previous Owner' => 'Vorige eigenaar',
        'Inform Agent' => 'Informeer behandelaar',
        'Optional' => 'Optioneel',
        'Inform involved Agents' => 'Informeer betrokken behandelaars',
        'Attach' => 'Toevoegen',

        # Template: AgentTicketCompose
        'A message must be spell checked!' => 'De spelling moet gecontroleerd worden',
        'Compose answer for ticket' => 'Bericht opstellen voor',
        'Pending Date' => 'Wacht tot datum',
        'for pending* states' => 'voor \'wachtend op-\' statussen',

        # Template: AgentTicketCustomer
        'Change customer of ticket' => 'Wijzig klant van een ticket',
        'Set customer user and customer id of a ticket' => 'Wijs de klant en klantID aan een ticket toe',
        'Customer User' => 'Klantbeheer',
        'Search Customer' => 'Klanten zoeken',
        'Customer Data' => 'Klantgegevens',
        'Customer history' => 'Klantgeschiedenis',
        'All customer tickets.' => 'Alle tickets van deze klant',

        # Template: AgentTicketEmail
        'Compose Email' => 'E-mail opstellen',
        'new ticket' => 'nieuw ticket',
        'Refresh' => 'Vernieuwen',
        'Clear To' => '"Aan" leeg maken',
        'All Agents' => 'Alle behandelaars',

        # Template: AgentTicketEscalation

        # Template: AgentTicketForward
        'Article type' => 'Soort interactie',

        # Template: AgentTicketFreeText
        'Change free text of ticket' => 'Verander de vrije tekstvelden van een ticket.',

        # Template: AgentTicketHistory
        'History of' => 'Geschiedenis van',

        # Template: AgentTicketLocked
        'My Locked Tickets' => 'Mijn vergrendelde tickets',

        # Template: AgentTicketMerge
        'You need to use a ticket number!' => 'Gebruik een ticketnummer.',
        'Ticket Merge' => 'Ticket samenvoegen',

        # Template: AgentTicketMove
        'If you want to account time, please provide Subject and Text!' => 'Als u tijd wilt registreren voor dit ticket, vul dan ook de velden Onderwerp en Tekst.',
        'Move Ticket' => 'Verplaats ticket',

        # Template: AgentTicketNote
        'Add note to ticket' => 'Notitie toevoegen aan ticket',

        # Template: AgentTicketOverviewMedium
        'First Response Time' => 'First Response Time',
        'Service Time' => 'Service tijd',
        'Update Time' => 'Vervolg tijd',
        'Solution Time' => 'Oplossingstijd',

        # Template: AgentTicketOverviewMediumMeta
        'You need min. one selected Ticket!' => 'Selecteer tenminste 1 ticket',

        # Template: AgentTicketOverviewNavBar
        'Filter' => 'Filter',
        'Change search options' => 'Verander zoekopties',
        'Tickets' => 'Tickets',
        'of' => 'van',

        # Template: AgentTicketOverviewNavBarSmall

        # Template: AgentTicketOverviewPreview
        'Compose Answer' => 'Antwoord opstellen',
        'Contact customer' => 'Neem contact op',
        'Change queue' => 'Wachtrij wisselen',

        # Template: AgentTicketOverviewPreviewMeta

        # Template: AgentTicketOverviewSmall
        'sort upward' => 'sorteer oplopend',
        'up' => 'naar boven',
        'sort downward' => 'sorteer aflopend',
        'down' => 'naar beneden',
        'Escalation in' => 'Escalatie om',
        'Locked' => 'Vergrendeld',

        # Template: AgentTicketOwner
        'Change owner of ticket' => 'Wijzig eigenaar van ticket',

        # Template: AgentTicketPending
        'Set Pending' => 'Zet in de wacht',

        # Template: AgentTicketPhone
        'Phone call' => 'Telefoongesprek',
        'Clear From' => 'Wis e-mailadres',

        # Template: AgentTicketPhoneOutbound

        # Template: AgentTicketPlain
        'Plain' => 'Zonder opmaak',

        # Template: AgentTicketPrint
        'Ticket-Info' => 'Ticket informatie',
        'Accounted time' => 'Geregistreerde tijd',
        'Linked-Object' => 'Gekoppeld item',
        'by' => 'door',

        # Template: AgentTicketPriority
        'Change priority of ticket' => 'Prioriteit wijzigen voor ticket',

        # Template: AgentTicketQueue
        'Tickets shown' => 'Tickets getoond',
        'Tickets available' => 'Tickets beschikbaar',
        'Queues' => 'Wachtrijen',
        'Ticket escalation!' => 'Ticket escalatie!',

        # Template: AgentTicketResponsible
        'Change responsible of ticket' => 'Wijzig verantwoordelijke van dit ticket',

        # Template: AgentTicketSearch
        'Ticket Search' => 'Zoek ticket',
        'Profile' => 'Profiel',
        'Search-Template' => 'Template',
        'TicketFreeText' => 'Vrije invulvelden van het ticket',
        'Created in Queue' => 'Aangemaakt in wachtrij',
        'Article Create Times' => 'Aanmaakdatum interacties',
        'Article created' => 'Interactie aangemaakt op',
        'Article created between' => 'Interactie aangemaakt tussen',
        'Change Times' => 'Zoek op wijzigingen',
        'No change time settings.' => 'Alle',
        'Ticket changed' => 'Ticket gewijzigd',
        'Ticket changed between' => 'Ticket gewijzigd tussen',
        'Result Form' => 'Doel',
        'Save Search-Profile as Template?' => 'Zoekprofiel als template bewaren ?',
        'Yes, save it with name' => 'Ja, sla op met naam',

        # Template: AgentTicketSearchOpenSearchDescriptionFulltext
        'Fulltext' => 'Volledig',

        # Template: AgentTicketSearchOpenSearchDescriptionTicketNumber

        # Template: AgentTicketSearchResultPrint

        # Template: AgentTicketZoom
        'Expand View' => 'Uitgebreid',
        'Collapse View' => 'Ingekort',
        'Split' => 'Splitsen',

        # Template: AgentTicketZoomArticleFilterDialog
        'Article filter settings' => 'Filter',
        'Save filter settings as default' => 'Sla filter op als standaard',

        # Template: AgentWindowTab

        # Template: AJAX

        # Template: Copyright

        # Template: CustomerAccept

        # Template: CustomerCalendarSmallIcon

        # Template: CustomerError
        'Traceback' => 'Terug traceren',

        # Template: CustomerFooter
        'Powered by' => 'Draait op',

        # Template: CustomerFooterSmall

        # Template: CustomerHeader

        # Template: CustomerHeaderSmall

        # Template: CustomerLogin
        'Login' => 'Inloggen',
        'Lost your password?' => 'Wachtwoord vergeten?',
        'Request new password' => 'Vraag een nieuw wachtwoord aan',
        'Create Account' => 'Maak account',

        # Template: CustomerNavigationBar
        'Welcome %s' => 'Welkom %s',

        # Template: CustomerPreferencesForm

        # Template: CustomerStatusView

        # Template: CustomerTicketMessage

        # Template: CustomerTicketPrint

        # Template: CustomerTicketSearch
        'Times' => 'Keren',
        'No time settings.' => 'Geen tijdinstellingen',

        # Template: CustomerTicketSearchOpenSearchDescription

        # Template: CustomerTicketSearchResultCSV

        # Template: CustomerTicketSearchResultPrint

        # Template: CustomerTicketSearchResultShort

        # Template: CustomerTicketZoom

        # Template: CustomerWarning

        # Template: Error
        'Click here to report a bug!' => 'Klik hier om een fout te rapporteren',

        # Template: Footer
        'Top of Page' => 'Bovenkant pagina',

        # Template: FooterSmall

        # Template: Header
        'Home' => 'Home',

        # Template: HeaderSmall

        # Template: Installer
        'Web-Installer' => 'Web Installer',
        'Welcome to %s' => 'Welkom bij %s',
        'Accept license' => 'Accepteer licentie',
        'Don\'t accept license' => 'Licentie niet accepteren',
        'Admin-User' => 'Account met databasebeheerrechten',
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty. For security reasons we do recommend setting a root password. For more information please refer to your database documentation.' => 'Als er een wachtwoord hoort bij dit account, vul deze hier in. Vanuit beveiligingsoogpunt is het aan te bevelen een wachtwoord te gebruiken. Kijk in de databasedocumentatie voor meer informatie.',
        'Admin-Password' => 'Wachtwoord',
        'Database-User' => 'OTRS database gebruiker',
        'default \'hot\'' => 'Standaard \'hot\'',
        'DB connect host' => 'Hostnaam databaseserver',
        'Database' => 'Database',
        'Default Charset' => 'Standaard karakterset',
        'utf8' => 'utf8',
        'false' => 'onwaar',
        'SystemID' => 'Systeem identificatie',
        '(The identify of the system. Each ticket number and each http session id starts with this number)' => '(De identificatie van dit systeem. Ieder ticketnummer en ieder HTTP sessie-id start met dit nummer)',
        'System FQDN' => 'OTRS FQDN',
        '(Full qualified domain name of your system)' => '(DNS-naam van dit systeem, bijvoorbeeld otrs.mycompany.local)',
        'AdminEmail' => 'E-mailadres beheerder',
        '(Email of the system admin)' => '(kan later worden gewijzigd)',
        'Organization' => 'Organisatie',
        'Log' => 'Log',
        'LogModule' => 'Logmodule',
        '(Used log backend)' => '(gebruikte logmodule)',
        'Logfile' => 'Logbestand',
        '(Logfile just needed for File-LogModule!)' => '(Logbestand alleen nodig voor File-LogModule',
        'Webfrontend' => 'Web Frontend',
        'Use utf-8 it your database supports it!' => 'Kies UTF-8 als uw database dit ondersteunt!',
        'Default Language' => 'Standaardtaal',
        '(Used default language)' => '(Gebruikte standaardtaal)',
        'CheckMXRecord' => 'Check MX Record',
        '(Checks MX recordes of used email addresses by composing an answer. Don\'t use CheckMXRecord if your OTRS machine is behinde a dial-up line $!)' => '(Controleerd MX-records voor emailadressen)',
        'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' => 'Om OTRS te gebruiken moet u nu de webserver herstarten.',
        'Restart your webserver' => 'Herstart webserver',
        'After doing so your OTRS is up and running.' => 'Hierna is OTRS up and running',
        'Start page' => 'Inlogpagina',
        'Your OTRS Team' => 'Het OTRS team',

        # Template: LinkObject

        # Template: Login

        # Template: Motd

        # Template: NoPermission
        'No Permission' => 'Geen rechten',

        # Template: Notify
        'Important' => 'Belangrijk',

        # Template: PrintFooter
        'URL' => 'URL',

        # Template: PrintHeader
        'printed by' => 'afgedrukt door',

        # Template: PublicDefault

        # Template: Redirect

        # Template: RichTextEditor

        # Template: Test
        'OTRS Test Page' => 'OTRS Testpagina',
        'Counter' => 'Teller',

        # Template: Warning

        # Misc
        'Edit Article' => 'Bewerk interactie',
        'Create new Phone Ticket' => 'Maak nieuw telefoon ticket aan',
        'Symptom' => 'Symptoom',
        'U' => 'U',
        'Services' => 'Services',
        'Customer history search (e. g. "ID342425").' => 'Klantgeschiedenis zoeken (bijvoorbeeld "ID342425").',
        'Can not delete link with %s!' => 'Kan koppeling met %s niet verwijderen!',
        'for agent firstname' => 'voornaam van agent',
        'Close!' => 'Sluit!',
        'Unique agents' => 'Unieke behandelaars',
        'No means, send agent and customer notifications on changes.' => ' ',
        'A web calendar' => 'Kalender',
        'to get the realname of the sender (if given)' => 'voor de echte naam van de afzender (indien beschikbaar)',
        'Notification (Customer)' => 'Notificatie (klant)',
        'Select Source (for add)' => 'Selecteer bron (voor toevoegen)',
        'Options of the ticket data (e. g. &lt;OTRS_TICKET_Number&gt;, &lt;OTRS_TICKET_ID&gt;, &lt;OTRS_TICKET_Queue&gt;, &lt;OTRS_TICKET_State&gt;)' => 'Ticketgegevens (bijvoorbeeld &lt;OTRS_TICKET_Number&gt;, &lt;OTRS_TICKET_ID&gt;, &lt;OTRS_TICKET_Queue&gt;, &lt;OTRS_TICKET_State&gt;)',
        'Child-Object' => 'Subitem',
        'Days' => 'Dagen',
        'Queue ID' => 'Wachtrij ID',
        'Config options (e. g. <OTRS_CONFIG_HttpType>)' => 'Configuratie opties (bijvoorbeeld <OTRS_CONFIG_HttpType>)',
        'System History' => 'Systeem geschiedenis',
        'customer realname' => 'naam van de klant',
        'Pending messages' => 'Wachtende berichten',
        'Modules' => 'Modulen',
        'for agent login' => 'de login van de behandelaar',
        'Keyword' => 'Trefwoord',
        'Close type' => 'Afsluitcode',
        'for agent user id' => 'de loginnaam van de behandelaar ',
        'Change user <-> group settings' => 'Wijzigen van gebruiker <-> groep toekenning',
        'Problem' => 'Probleem',
        'Escalation' => 'Escalatie',
        '"}' => '"}',
        'Order' => 'Volgorde',
        'next step' => 'volgende stap',
        'Follow up' => 'Opvolgen',
        'Customer history search' => 'Zoeken in klantgeschiedenis',
        'Admin-Email' => 'Admin e-mailadres',
        'PostMaster Mail Account' => 'E-mail accounts',
        'Stat#' => 'Statistiek#',
        'ArticleID' => 'Interactie ID',
        'Go' => 'Uitvoeren',
        'Types' => 'Typen',
        'Keywords' => 'Trefwoorden',
        'Ticket Escalation View' => 'Ticket Escalatie',
        'Today' => 'Vandaag',
        'No * possible!' => 'Geen * mogelijk!',
        'PostMaster Filter' => 'E-mail filters',
        'Options of the current user who requested this action (e. g. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)' => 'Gegevens van de huidige gebruiker (bijvoorbeeld &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)',
        'Message for new Owner' => 'Bericht voor nieuwe eigenaar',
        'to get the first 5 lines of the email' => 'voor de eerste vijf regels van het e-mail bericht',
        'Sort by' => 'Sorteer op',
        'Last update' => 'Laatste wijziging',
        'Sorry, feature not active!' => 'Deze functie is niet actief!',
        'Tomorrow' => 'Morgen',
        'to get the first 20 character of the subject' => 'voor de eerste 20 tekens van het onderwerp',
        'Select the customeruser:service relations.' => 'Selecteer de klant:service koppelingen',
        'Bulk-Action' => 'Bulk actie',
        'FileManager' => 'Bestandsbeheer',
        'Options of the current customer user data (e. g. <OTRS_CUSTOMER_DATA_UserFirstname>)' => 'Opties van de data van de klant (bijvoorbeeld <OTRS_CUSTOMER_DATA_UserFirstname>)',
        'Pending type' => 'In de wacht: type',
        'Comment (internal)' => 'Interne opmerking',
        'Ticket owner options (e. g. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)' => 'Gegevens van ticket-eigenaar (bijvoorbeeld &lt;OTRS_OWNER_USERFIRSTNAME&gt;)',
        'Options of the ticket data (e. g. <OTRS_TICKET_Number>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' => 'Ticket gegevens (e. g. <OTRS_TICKET_Number>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)',
        'Priorities' => 'Prioriteiten',
        'Reminder' => 'Herinnering',
        'Statuses' => 'Statussen',
        'PGP' => 'PGP',
        ' (work units)' => '(in minuten)',
        'Next Week' => 'Volgende week',
        'All Customer variables like defined in config option CustomerUser.' => 'Alle klantvariabelen zoals vastgelegd in de configuratieoptie Klant.',
        'All sessions' => 'Alle sessies',
        'for agent lastname' => 'achternaam van behandelaar',
        'Options of the current user who requested this action (e. g. <OTRS_CURRENT_UserFirstname>)' => 'Opties van de gebruiker die deze actie heeft aangevraagd (bijvoorbeeld <OTRS_CURRENT_UserFirstname>)',
        'Reminder messages' => 'Herinneringsberichten',
        'Parent-Object' => 'Hoofd item',
        'If your account is trusted, the already existing x-otrs header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' => 'Wanneer het account vertrouwd is, zullen de x-otrs headers gebruikt worden! PostMaster filters zullen ook nog steeds gebruikt worden.',
        'Of couse this feature will take some system performance it self!' => 'Deze instelling gaat zelf ook een beetje ten koste van de systeemperformance',
        'IMAPS' => 'IMAPS',
        'Your own Ticket' => 'Je eigen ticket',
        'Detail' => 'Detail',
        'TicketZoom' => 'Inhoud ticket',
        'Customer sessions' => 'Klantsessies',
        'Open Tickets' => 'Openstaande tickets',
        'Don\'t forget to add a new user to groups!' => 'Vergeet niet om groepen aan deze gebruiker toe te kennen!',
        'CreateTicket' => 'Ticket aanmaken',
        'You have to select two or more attributes from the select field!' => 'Kies twee of meer attributen',
        'WebWatcher' => 'Webwatcher',
        'Unique customers' => 'Unieke klanten',
        'Finished' => 'Afgerond',
        'D' => 'D',
        'All messages' => 'Alle berichten',
        'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' => 'Gegevens van het ticket (bijvoorbeeld <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)',
        'Object already linked as %s.' => 'Objecten al gekoppeld als %s.',
        'A article should have a title!' => 'Geef een titel op voor de interactie',
        'Customer Users <-> Services' => 'Klanten <-> Services',
        'Config options (e. g. &lt;OTRS_CONFIG_HttpType&gt;)' => 'Configuratiegegevens (bijvoorbeeld &lt;OTRS_CONFIG_HttpType&gt;)',
        'A web mail client' => 'Webmail gebruiker',
        'IMAP' => 'IMAP',
        'Compose Follow up' => 'Follow up aanmaken',
        'S/MIME' => 'S/MIME',
        'WebMail' => 'Webmail',
        'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' => 'Gegevens van het ticket(bijvoorbeeld <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)',
        'Ticket owner options (e. g. <OTRS_OWNER_UserFirstname>)' => 'Gegevens van de ticketeigenaar (bijvoorbeeld <OTRS_OWNER_UserFirstname>)',
        'Customers' => 'Klanten',
        'kill all sessions' => 'alle sessies afsluiten',
        'to get the from line of the email' => 'voor het e-mailadres waar vandaan de e-mail komt',
        'Solution' => 'Oplossing',
        'QueueView' => 'Wachtrijen',
        'My Queue' => 'Mijn wachtrij',
        'Select Box' => 'SQL select query',
        'New messages' => 'Nieuwe berichten',
        'Can not create link with %s!' => 'Kan geen koppeling maken met %s!',
        'Linked as' => 'Gekoppeld als',
        'Welcome to OTRS' => 'Welkom bij OTRS',
        'tmp_lock' => 'tijdelijk vergrendeld',
        'modified' => 'gewijzigd',
        'A web file manager' => 'Een online bestandsbeheerder',
        'Have a lot of fun!' => 'Veel plezier!',
        'send' => 'verstuur',
        'Send no notifications' => 'Stuur geen notificaties',
        'Note Text' => 'Notitietekst',
        'POP3 Account Management' => 'POP3 Accountbeheer',
        'Options of the current customer user data (e. g. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)' => 'Attributen van de huidige klant (bijvoorbeeld &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)',
        'System State Management' => 'Statusbeheer',
        'Mailbox' => 'Postbus',
        'PhoneView' => 'Telefoonscherm',
        'Database Backend' => 'Database',
        'TicketID' => 'Ticket ID',
        'Yes means, send no agent and customer notifications on changes.' => 'Bij \'Ja\' worden er geen notificaties gestuurd naar eigenaar en klant bij wijzigingen.',
        'POP3' => 'POP3',
        'POP3S' => 'POP3S',
        'Agent sessions' => 'Behandelaarsessies',
        'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further information.' => 'Uw e-mail met ticketnummer "<OTRS_TICKET>" is gebounced naar "<OTRS_BOUNCE_TO>". Neem contact op met dit adres voor meer informatie.',
        'CustomerGroupSupport needs to be active in Kernel/Config.pm, read more about this feature in the documentation. Take care!' => 'Ondersteuning voor klantgroepen moet worden geactiveerd in de Configuratie. Lees meer hierover in de documentatie: zoek op \'CustomerGroupSupport\'.',
        'Ticket Status View' => 'Overzicht Ticketstatussen',
        'Modified' => 'Gewijzigd',
        'Ticket selected for bulk action!' => 'Ticket geselecteerd voor bulk actie!',
        '%s is not writable!' => '',
        'Cannot create %s!' => '',
    };
    # $$STOP$$
    return;
}

1;
