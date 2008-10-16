# --
# Kernel/Language/nl.pm - provides nl language translation
# Copyright (C) 2002-2003 Fred van Dijk <fvandijk at marklin.nl>
# Copyright (C) 2003 A-NeT Internet Services bv Hans Bakker <h.bakker at a-net.nl>
# Copyright (C) 2004 Martijn Lohmeijer <martijn.lohmeijer 'at' sogeti.nl>
# Copyright (C) 2005-2007 Jurgen Rutgers <jurgen 'at' besite.nl>
# Copyright (C) 2005-2007 Richard Hinkamp <richard 'at' besite.nl>
# --
# $Id: nl.pm,v 1.84 2008-10-16 14:42:26 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

# Not translated terms / words:

# Agent Area --> it's clear what that does
# Bounce
# Contract
# Directory
# Online Agent
# Type
# Upload

package Kernel::Language::nl;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.84 $) [1];

sub Data {
    my $Self = shift;

    # $$START$$
    # Last translation file sync: Fri May 16 14:08:45 2008

    # possible charsets
    $Self->{Charset} = ['iso-8859-1', 'iso-8859-15', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Jear;)
    $Self->{DateFormat}          = '%D.%M.%Y %T';
    $Self->{DateFormatLong}      = '%A %D %B %T %Y';
    $Self->{DateFormatShort}     = '%D.%M.%Y';
    $Self->{DateInputFormat}     = '%D.%M.%Y';
    $Self->{DateInputFormatLong} = '%D.%M.%Y - %T';

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
        'Reset' => 'opnieuw',
        'last' => 'laatste',
        'before' => 'voor',
        'day' => 'dag',
        'days' => 'dagen',
        'day(s)' => 'dag(en)',
        'hour' => 'uur',
        'hours' => 'uren',
        'hour(s)' => 'u(u)r(en)',
        'minute' => 'minuut',
        'minutes' => 'minuten',
        'minute(s)' => 'minu(u)t(en)',
        'month' => 'maand',
        'months' => 'maanden',
        'month(s)' => 'maand(en)',
        'week' => 'week',
        'week(s)' => 'we(e)k(en)',
        'year' => 'jaar',
        'years' => 'jaren',
        'year(s)' => 'ja(a)r(en)',
        'second(s)' => 'seconde(n)',
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
        'Subfunction' => 'Sub-functie',
        'Line' => 'Regel',
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
        'Next...' => 'Volgende...',
        '...Back' => '...Terug',
        '-none-' => '-geen-',
        'none' => 'geen',
        'none!' => 'niet ingevoerd!',
        'none - answered' => 'geen - beantwoord',
        'please do not edit!' => 'niet wijzigen s.v.p.!',
        'AddLink' => 'Link toevoegen',
        'Link' => 'Link',
        'Unlink' => '',
        'Linked' => 'Gelinkt',
        'Link (Normal)' => 'Link (normaal)',
        'Link (Parent)' => 'Link (hoofd)',
        'Link (Child)' => 'Link (sub)',
        'Normal' => 'Normaal',
        'Parent' => 'hoofd',
        'Child' => 'sub',
        'Hit' => '',
        'Hits' => '',
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
        'CustomerID' => 'KlantID',
        'CustomerIDs' => 'KlantIDs',
        'customer' => 'klant',
        'agent' => '',
        'system' => 'systeem',
        'Customer Info' => 'Klant informatie',
        'Customer Company' => 'Klant bedrijf',
        'Company' => 'Bedrijf',
        'go!' => 'start!',
        'go' => 'start',
        'All' => 'Alle',
        'all' => 'alle',
        'Sorry' => 'Sorry',
        'update!' => 'wijzigen!',
        'update' => 'wijzigen',
        'Update' => 'Wijzigen',
        'submit!' => 'versturen!',
        'submit' => 'versturen',
        'Submit' => 'Versturen',
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
        'Created' => 'Gemaakt',
        'Created by' => 'Gemaakt door',
        'Changed' => 'Gewijzigd',
        'Changed by' => 'Gewijzigd door',
        'Search' => 'Zoek',
        'and' => 'en',
        'between' => 'tussen',
        'Fulltext Search' => 'Alles doorzoeken',
        'Data' => 'Gegevens',
        'Options' => 'Opties',
        'Title' => 'Titel',
        'Item' => '',
        'Delete' => 'Verwijder',
        'Edit' => 'Wijzig',
        'View' => 'Weergave',
        'Number' => 'Nummer',
        'System' => 'Systeem',
        'Contact' => 'Contact',
        'Contacts' => 'Contacten',
        'Export' => '',
        'Up' => 'Boven',
        'Down' => 'Beneden',
        'Add' => 'Toevoegen',
        'Category' => 'Categorie',
        'Viewer' => '',
        'New message' => 'Nieuw bericht',
        'New message!' => 'Nieuw bericht!',
        'Please answer this ticket(s) to get back to the normal queue view!' => 'Onderstaande geëscaleerde Tickets dient u eerst te beantwoorden om terug te kunnen komen in de normale wachtrij',
        'You got new message!' => 'U heeft een nieuw bericht!',
        'You have %s new message(s)!' => 'U heeft %s nieuwe bericht(en)!',
        'You have %s reminder ticket(s)!' => 'U heeft %s herinneringsTicket(s)!',
        'The recommended charset for your language is %s!' => 'De aanbevolen karakterset voor uw taal is %s!',
        'Passwords doesn\'t match! Please try it again!' => 'Wachtwoorden komen niet overeen! Probeer het opnieuw!',
        'Password is already in use! Please use an other password!' => 'Wachtwoord wordt al gebruikt. Kies een ander wachtwoord!',
        'Password is already used! Please use an other password!' => 'Wachtwoord is al in gebruik. Kies een ander wachtwoord!',
        'You need to activate %s first to use it!' => 'U dient %s eerst te activeren voordat u het kunt gebruiken.',
        'No suggestions' => 'Geen suggesties',
        'Word' => 'Woord',
        'Ignore' => 'Negeren',
        'replace with' => 'vervangen met',
        'There is no account with that login name.' => 'Er is geen account bekend met deze gebruikersnaam',
        'Login failed! Your username or password was entered incorrectly.' => 'Aanmelden is mislukt. Uw gebruikersnaam of wachtwoord is onjuist.',
        'Please contact your admin' => 'Vraag uw systeembeheerder',
        'Logout successful. Thank you for using OTRS!' => 'Afgemeld! Wij danken u voor het gebruiken van OTRS!',
        'Invalid SessionID!' => 'Ongeldige SessieID',
        'Feature not active!' => 'Deze functie is niet actief!',
        'Login is needed!' => '',
        'Password is needed!' => 'Een wachtwoord is vereist.',
        'License' => 'Licentie',
        'Take this Customer' => 'Selecteer deze klant',
        'Take this User' => 'Selecteer deze gebruiker',
        'possible' => 'mogelijk',
        'reject' => 'afwijzen',
        'reverse' => 'omgekeerd',
        'Facility' => 'Maatregel',
        'Timeover' => '',
        'Pending till' => 'In de wacht tot',
        'Don\'t work with UserID 1 (System account)! Create new users!' => 'Werk niet met User# 1 (systeem account)! Maak nieuwe gebruikers aan',
        'Dispatching by email To: field.' => 'Sorteren per e-mailadres ',
        'Dispatching by selected Queue.' => 'Sorteren per geselecteerde wachtrij',
        'No entry found!' => 'Niets gevonden!',
        'Session has timed out. Please log in again.' => 'Uw sessie is verlopen. Opnieuw inloggen s.v.p.',
        'No Permission!' => 'Geen toegang! Onvoldoende rechten.',
        'To: (%s) replaced with database email!' => 'Aan: (%s) vervangen met database e-mail!',
        'Cc: (%s) added database email!' => 'Cc: (%s) toevoegen met database e-mail',
        '(Click here to add)' => '(Klik hier om toe te voegen)',
        'Preview' => 'Voorbeeld',
        'Package not correctly deployed! You should reinstall the Package again!' => '',
        'Added User "%s"' => 'Gebruiker "%s" toegevoegd.',
        'Contract' => 'Contract',
        'Online Customer: %s' => 'Online klant: %s',
        'Online Agent: %s' => 'Online agent: %s',
        'Calendar' => 'Kalender',
        'File' => 'Bestand',
        'Filename' => 'Bestandsnaam',
        'Type' => 'Type',
        'Size' => 'Grootte',
        'Upload' => 'Upload',
        'Directory' => 'Map',
        'Signed' => 'Getekend',
        'Sign' => 'Teken',
        'Crypted' => '',
        'Crypt' => '',
        'Office' => 'Kantoor',
        'Phone' => 'Telefoon',
        'Fax' => 'Fax',
        'Mobile' => 'Mobiel',
        'Zip' => 'Postcode',
        'City' => 'Plaats',
        'Location' => 'Locatie',
        'Street' => 'Straat',
        'Country' => 'Land',
        'installed' => 'geïnstalleerd',
        'uninstalled' => 'verwijderd',
        'Security Note: You should activate %s because application is already running!' => '',
        'Unable to parse Online Repository index document!' => '',
        'No Packages for requested Framework in this Online Repository, but Packages for other Frameworks!' => '',
        'No Packages or no new Packages in selected Online Repository!' => '',
        'printed at' => '',
        'Dear Mr. %s,' => '',
        'Dear Mrs. %s,' => '',
        'Dear %s,' => '',
        'Hello %s,' => '',
        'This account exists.' => '',
        'New account created. Sent Login-Account to %s.' => '',
        'Please press Back and try again.' => '',
        'Sent password token to: %s' => '',
        'Sent new password to: %s' => '',
        'Invalid Token!' => '',

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
        'January' => 'Januari',
        'February' => 'Februari',
        'March' => 'Maart',
        'April' => 'April',
        'June' => 'Juni',
        'July' => 'Juli',
        'August' => 'Augustus',
        'September' => 'September',
        'October' => 'Oktober',
        'November' => 'November',
        'December' => 'December',

        # Template: AAANavBar
        'Admin-Area' => 'Admin',
        'Agent-Area' => 'Agent',
        'Ticket-Area' => 'Ticket',
        'Logout' => 'Uitloggen',
        'Agent Preferences' => 'Agent voorkeuren',
        'Preferences' => 'Voorkeuren',
        'Agent Mailbox' => 'Agent postvak',
        'Stats' => 'Statistieken',
        'Stats-Area' => 'Statistieken',
        'Admin' => 'Admin',
        'Customer Users' => 'Klant gebruikers',
        'Customer Users <-> Groups' => 'Klant gebruikers <-> Groepen',
        'Users <-> Groups' => 'Gebruikers <-> Groepen',
        'Roles' => 'Rollen',
        'Roles <-> Users' => 'Rollen <-> Gebruikers',
        'Roles <-> Groups' => 'Rollen <-> Groepen',
        'Salutations' => 'Aanhef',
        'Signatures' => 'Handtekening',
        'Email Addresses' => 'E-mail adressen',
        'Notifications' => 'Meldingen',
        'Category Tree' => 'Categorie boom',
        'Admin Notification' => 'Admin melding',

        # Template: AAAPreferences
        'Preferences updated successfully!' => 'Uw voorkeuren zijn gewijzigd!',
        'Mail Management' => 'Mail beheer',
        'Frontend' => 'Voorkant',
        'Other Options' => 'Overige opties',
        'Change Password' => 'Wijzig uw wachtwoord',
        'New password' => 'Nieuw wachtwoord',
        'New password again' => 'Nogmaals nieuwe wachtwoord',
        'Select your QueueView refresh time.' => 'Verversingstijd kiezen',
        'Select your frontend language.' => 'Kies uw taal',
        'Select your frontend Charset.' => 'Kies uw karakterset',
        'Select your frontend Theme.' => 'Kies uw thema',
        'Select your frontend QueueView.' => 'Kies uw weergave van de wachtrij',
        'Spelling Dictionary' => 'Spelling bibliotheek',
        'Select your default spelling dictionary.' => 'Selecteer uw standaard spellingsbibliotheek.',
        'Max. shown Tickets a page in Overview.' => 'Max. getoonde Tickets per pagina in overzichtsscherm.',
        'Can\'t update password, passwords doesn\'t match! Please try it again!' => 'Uw wachtwoord kan niet worden gewijzigd, de wachtwoorden komen niet overeen. Probeer het opnieuw.',
        'Can\'t update password, invalid characters!' => 'Uw wachtwoord kan niet worden gewijzigd, er zijn ongeldige karakters gevonden.',
        'Can\'t update password, need min. 8 characters!' => 'Uw wachtwoord kan niet worden gewijzigd, er zijn minimaal 8 karakters noodzakelijk.',
        'Can\'t update password, need 2 lower and 2 upper characters!' => 'Uw wachtwoord kan niet worden gewijzigd, er zijn minimaal 2 normale en 2 hoofdletters noodzakelijk.',
        'Can\'t update password, need min. 1 digit!' => 'Uw wachtwoord kan niet worden gewijzigd, er is minimaal 1 cijfer noodzakelijk.',
        'Can\'t update password, need min. 2 characters!' => 'Uw wachtwoord kan niet worden gewijzigd, er zijn minimaal 2 letters noodzakelijk.',

        # Template: AAAStats
        'Stat' => '',
        'Please fill out the required fields!' => 'Vul de verplichte velden in alstublieft!',
        'Please select a file!' => 'Selecteer een bestand alstublieft!',
        'Please select an object!' => 'Selecteer een object alstublieft!',
        'Please select a graph size!' => 'Selecteer de grootte van de grafiek alstublieft!',
        'Please select one element for the X-axis!' => 'Selecteer een element voor X-as alstublieft!',
        'You have to select two or more attributes from the select field!' => '',
        'Please select only one element or turn off the button \'Fixed\' where the select field is marked!' => '',
        'If you use a checkbox you have to select some attributes of the select field!' => '',
        'Please insert a value in the selected input field or turn off the \'Fixed\' checkbox!' => '',
        'The selected end time is before the start time!' => '',
        'You have to select one or more attributes from the select field!' => '',
        'The selected Date isn\'t valid!' => '',
        'Please select only one or two elements via the checkbox!' => '',
        'If you use a time scale element you can only select one element!' => '',
        'You have an error in your time selection!' => '',
        'Your reporting time interval is too small, please use a larger time scale!' => '',
        'The selected start time is before the allowed start time!' => '',
        'The selected end time is after the allowed end time!' => '',
        'The selected time period is larger than the allowed time period!' => '',
        'Common Specification' => '',
        'Xaxis' => 'X-as',
        'Value Series' => 'Waardes',
        'Restrictions' => 'Restricties',
        'graph-lines' => '',
        'graph-bars' => '',
        'graph-hbars' => '',
        'graph-points' => '',
        'graph-lines-points' => '',
        'graph-area' => '',
        'graph-pie' => '',
        'extended' => '',
        'Agent/Owner' => '',
        'Created by Agent/Owner' => '',
        'Created Priority' => '',
        'Created State' => '',
        'Create Time' => '',
        'CustomerUserLogin' => '',
        'Close Time' => '',

        # Template: AAATicket
        'Lock' => 'Vergrendel',
        'Unlock' => 'Ontgrendel',
        'History' => 'Geschiedenis',
        'Zoom' => 'Inhoud',
        'Age' => 'Leeftijd',
        'Bounce' => '',
        'Forward' => 'Doorsturen',
        'From' => 'Van',
        'To' => 'Aan',
        'Cc' => 'Cc',
        'Bcc' => 'Bcc',
        'Subject' => 'Betreft',
        'Move' => 'Verplaatsen',
        'Queue' => 'Wachtrij',
        'Priority' => 'Prioriteit',
        'Priority Update' => '',
        'State' => 'Status',
        'Compose' => 'Maken',
        'Pending' => 'Wachtend',
        'Owner' => 'Eigenaar',
        'Owner Update' => 'Eigenaar aangepast',
        'Responsible' => 'Verantwoordelijke',
        'Responsible Update' => 'Verantwoordelijke aangepast',
        'Sender' => 'Afzender',
        'Article' => 'Artikel',
        'Ticket' => 'Ticket',
        'Createtime' => 'Gemaakt op',
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
        'closed' => 'gesloten',
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
        'No such Ticket Number "%s"! Can\'t link it!' => 'Ticketnummer "%s" niet gevonden! Kan dus geen link worden gemaakt!',
        'Don\'t show closed Tickets' => 'Gesloten Tickets niet tonen',
        'Show closed Tickets' => 'Gesloten Tickets wel tonen',
        'New Article' => 'Nieuw artikel',
        'Email-Ticket' => 'E-mail Ticket',
        'Create new Email Ticket' => 'Maak nieuw E-mail Ticket aan',
        'Phone-Ticket' => 'Telefoon Ticket',
        'Search Tickets' => 'Zoek Tickets',
        'Edit Customer Users' => 'Wijzig klant gebruikers',
        'Edit Customer Company' => '',
        'Bulk-Action' => 'Bulk Actie',
        'Bulk Actions on Tickets' => 'Bulk Actie op Tickets',
        'Send Email and create a new Ticket' => 'Verstuur e-mail en maak een nieuw Ticket aan',
        'Create new Email Ticket and send this out (Outbound)' => '',
        'Create new Phone Ticket (Inbound)' => '',
        'Overview of all open Tickets' => 'Laat alle open Tickets zien',
        'Locked Tickets' => 'Vergrendelde Tickets',
        'Watched Tickets' => 'Bekeken Tickets',
        'Watched' => 'Bekeken',
        'Subscribe' => 'Inschrijven',
        'Unsubscribe' => 'Uitschrijven',
        'Lock it to work on it!' => 'Vergrendel een Ticket om er mee te kunnen werken.',
        'Unlock to give it back to the queue!' => 'Ontgrendel een Ticket om deze vrij te geven.',
        'Shows the ticket history!' => 'Laat de Ticket geschiedenis zien.',
        'Print this ticket!' => 'Print het Ticket.',
        'Change the ticket priority!' => 'Wijzig de prioriteit van het Ticket.',
        'Change the ticket free fields!' => 'Wijzig de vrije invulvelden van het Ticket.',
        'Link this ticket to an other objects!' => 'Link het Ticket met andere items.',
        'Change the ticket owner!' => 'Wijzig de eigenaar van het Ticket.',
        'Change the ticket customer!' => 'Wijzig de klant van het Ticket.',
        'Add a note to this ticket!' => 'Voeg een notitie toe aan het Ticket.',
        'Merge this ticket!' => 'Voeg dit Ticket samen met een ander Ticket.',
        'Set this ticket to pending!' => 'Plaats dit Ticket als wachtend.',
        'Close this ticket!' => 'Sluit dit Ticket.',
        'Look into a ticket!' => 'Bekijk dit Ticket.',
        'Delete this ticket!' => 'Verwijder dit Ticket.',
        'Mark as Spam!' => 'Markeer als SPAM.',
        'My Queues' => 'Mijn wachtrijen',
        'Shown Tickets' => 'Laat Tickets zien',
        'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' => 'Uw e-mail met Ticket nummer "<OTRS_TICKET>" is samengevoegd met "<OTRS_MERGE_TO_TICKET>".',
        'Ticket %s: first response time is over (%s)!' => 'Ticket %s: eerste antwoord tijd is voorbij (%s)!',
        'Ticket %s: first response time will be over in %s!' => 'Ticket %s: eerste antwoord tijd zal voorbij zijn binnen %s!',
        'Ticket %s: update time is over (%s)!' => 'Ticket %s: vervolg tijd is voorbij (%s)!',
        'Ticket %s: update time will be over in %s!' => 'Ticket %s: vervolg tijd zal voorbij zijn binnen %s!',
        'Ticket %s: solution time is over (%s)!' => 'Ticket %s: oplossing tijd is voorbij (%s)!',
        'Ticket %s: solution time will be over in %s!' => 'Ticket %s: oplossing tijd zal voorbij zijn binnen %s!',
        'There are more escalated tickets!' => 'Er zijn geen geëscaleerde tickets meer!',
        'New ticket notification' => 'Melding bij een nieuw Ticket',
        'Send me a notification if there is a new ticket in "My Queues".' => 'Stuur mij een melding als er een nieuw Ticket in Mijn wachtrijen komt.',
        'Follow up notification' => 'Melding bij vervolgvragen.',
        'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.' => 'Stuur mij een melding als een klant een vervolgvraag stelt en ik ben de eigenaar van het Ticket.',
        'Ticket lock timeout notification' => 'Stuur mij een melding van tijdsoverschreiding van een vergrendeld Ticket.',
        'Send me a notification if a ticket is unlocked by the system.' => 'Stuur mij een melding van een bericht als een Ticket wordt ontgrendeld door het systeem.',
        'Move notification' => 'Stuur mij een melding bij het verplaatsen van een Ticket.',
        'Send me a notification if a ticket is moved into one of "My Queues".' => ' Stuur mij een melding als een Ticket wordt verplaatst in een aangepaste wachtrij.',
        'Your queue selection of your favourite queues. You also get notified about those queues via email if enabled.' => 'Uw selectie van uw favoriete wachtrijen. U ontvangt automatisch een melding van nieuwe Tickets in deze wachtrij, indien u hiervor heeft gekozen.',
        'Custom Queue' => 'Aangepaste wachtrij.',
        'QueueView refresh time' => 'Verversingstijd wachtrij.',
        'Screen after new ticket' => 'Scherm na het aanmaken van een nieuw Ticket.',
        'Select your screen after creating a new ticket.' => 'Selecteer het vervolgscherm na het invoeren van een nieuw Ticket.',
        'Closed Tickets' => 'Afgesloten Tickets.',
        'Show closed tickets.' => 'Toon gesloten Tickets.',
        'Max. shown Tickets a page in QueueView.' => 'Max. getoonde Tickets per pagina in wachtrijscherm.',
        'CompanyTickets' => 'Bedrijf Tickets',
        'MyTickets' => 'Mijn tickets',
        'New Ticket' => 'Nieuw ticket',
        'Create new Ticket' => 'Maak nieuw ticket aan',
        'Customer called' => 'Klant gebeld',
        'phone call' => 'telefoongesprek',
        'Responses' => 'Antwoorden.',
        'Responses <-> Queue' => 'Antwoorden <-> Wachtrijen',
        'Auto Responses' => 'Automatische beantwoordingen',
        'Auto Responses <-> Queue' => 'Automatische beantwoordeingen <-> Wachtrijen',
        'Attachments <-> Responses' => 'Bijlagen <-> Automatische beantwoordingen',
        'History::Move' => 'Ticket verplaatst naar wachtrij "%s" (%s) van wachtrij "%s" (%s).',
        'History::TypeUpdate' => 'Type aangepast naar %s (ID=%s).',
        'History::ServiceUpdate' => 'Service aangepast naar %s (ID=%s).',
        'History::SLAUpdate' => 'SLA aangepast naar %s (ID=%s).',
        'History::NewTicket' => 'Nieuw Ticket [%s] aangemaakt (Q=%s;P=%s;S=%s).',
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
        'History::WebRequestCustomer' => 'Klant stelt vraag via het web.',
        'History::TicketLinkAdd' => 'Link naar "%s" toegevoegd.',
        'History::TicketLinkDelete' => 'Link naar "%s" verwijderd.',
        'History::Subscribe' => 'Added subscription for user "%s".',
        'History::Unsubscribe' => 'Removed subscription for user "%s".',

        # Template: AAAWeekDay
        'Sun' => 'zondag',
        'Mon' => 'maandag',
        'Tue' => 'dinsdag',
        'Wed' => 'woensdag',
        'Thu' => 'donderdag',
        'Fri' => 'vrijdag',
        'Sat' => 'zaterdag',

        # Template: AdminAttachmentForm
        'Attachment Management' => 'Bijlage beheer',

        # Template: AdminAutoResponseForm
        'Auto Response Management' => 'Automatische beantwoordingen beheer',
        'Response' => 'Antwoord',
        'Auto Response From' => 'E-mailadres',
        'Note' => 'Notitie',
        'Useable options' => 'Mogelijkheden',
        'To get the first 20 character of the subject.' => 'Voor de eerste 20 tekens van het onderwerp',
        'To get the first 5 lines of the email.' => 'Voor de eerste vijf regels van het e-mail bericht',
        'To get the realname of the sender (if given).' => 'Voor de echte naam van de afzender (indien beschikbaar)',
        'To get the article attribute (e. g. (<OTRS_CUSTOMER_From>, <OTRS_CUSTOMER_To>, <OTRS_CUSTOMER_Cc>, <OTRS_CUSTOMER_Subject> and <OTRS_CUSTOMER_Body>).' => 'Voor de eigenscaheppen van het artikel (bijv. <OTRS_CUSTOMER_From>, <OTRS_CUSTOMER_To>, <OTRS_CUSTOMER_Cc>, <OTRS_CUSTOMER_Subject> and <OTRS_CUSTOMER_Body>).',
        'Options of the current customer user data (e. g. <OTRS_CUSTOMER_DATA_UserFirstname>).' => 'Mogelijkheden van de huidige klant gegevens (bijv. <OTRS_CUSTOMER_DATA_UserFirstname>).',
        'Ticket owner options (e. g. <OTRS_OWNER_UserFirstname>).' => 'Ticket eigenaar mogelijkheden (bijv. <OTRS_OWNER_UserFirstname>).',
        'Ticket responsible options (e. g. <OTRS_RESPONSIBLE_UserFirstname>).' => 'Ticket verantwoordelijke mogelijkheden (bijv. <OTRS_RESPONSIBLE_UserFirstname).',
        'Options of the current user who requested this action (e. g. <OTRS_CURRENT_UserFirstname>).' => 'Mogelijkheden van de huidige gebruiker die deze actie heeft verzocht (bijv. <OTRS_CURRENT_UserFirstname>).',
        'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>).' => 'Mogelijkheden van de ticket gegevens (bijv. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>).',
        'Config options (e. g. <OTRS_CONFIG_HttpType>).' => 'Configuratie mogelijkheden (bijv. <OTRS_CONFIG_HttpType>).',

        # Template: AdminCustomerCompanyForm
        'Customer Company Management' => 'Klant bedrijven beheer',
        'Search for' => 'Zoek naar',
        'Add Customer Company' => 'Klant bedrijf toevoegen',
        'Add a new Customer Company.' => 'Voeg een nieuw klant bedrijf toe.',
        'List' => 'Lijst',
        'This values are required.' => 'Deze waarden zijn verplicht.',
        'This values are read only.' => 'Deze waarden kunt u alleen lezen.',

        # Template: AdminCustomerUserForm
        'Customer User Management' => 'Gebruikersbeheer klanten',
        'Add Customer User' => 'Klant gebruiker toevoegen',
        'Source' => 'Bron',
        'Create' => 'Aanmaken',
        'Customer user will be needed to have a customer history and to login via customer panel.' => 'Klanten moeten een klanthistorie hebben voordat zij kunnen inloggen via de klantschermen.',

        # Template: AdminCustomerUserGroupChangeForm
        'Customer Users <-> Groups Management' => 'Klant gebruikers <-> Groepen beheer',
        'Change %s settings' => 'Wijzig instellingen voor %s',
        'Select the user:group permissions.' => 'Selecteer de gebruikers / groep rechten',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the user).' => 'Als er geen selectie is gemaakt dan zijn er geen rechten voor deze groep (Tickets zullen dus niet beschikbaar zijn voor de gebruiker).',
        'Permission' => 'Rechten',
        'ro' => 'alleen lezen',
        'Read only access to the ticket in this group/queue.' => 'Leesrechten op de Tickets in deze groep / wachtrij.',
        'rw' => 'lezen + schrijven',
        'Full read and write access to the tickets in this group/queue.' => 'Volledige lees- en schrijfrechten op de Tickets in deze groep / wachtrij.',

        # Template: AdminCustomerUserGroupForm

        # Template: AdminCustomerUserService
        'Customer Users <-> Services Management' => '',
        'CustomerUser' => 'Klant gebruiker',
        'Service' => 'Service',
        'Edit default services.' => '',
        'Search Result' => 'Zoekresultaat',
        'Allocate services to CustomerUser' => '',
        'Active' => 'Actief',
        'Allocate CustomerUser to service' => '',

        # Template: AdminEmail
        'Message sent to' => 'Bericht verstuurd naar',
        'Recipents' => 'Ontvangers',
        'Body' => 'Bericht tekst',
        'Send' => 'Verstuur',

        # Template: AdminGenericAgent
        'GenericAgent' => 'Standaard agent',
        'Job-List' => 'Taak lijst',
        'Last run' => 'Laatste run',
        'Run Now!' => 'Run nu',
        'x' => '',
        'Save Job as?' => 'Sla taak op als?',
        'Is Job Valid?' => 'Is de taak juist?',
        'Is Job Valid' => 'Is de taak juist?',
        'Schedule' => 'Plan in',
        'Fulltext-Search in Article (e. g. "Mar*in" or "Baue*")' => 'Volledige zoekactie in artikel (b.v. "Mar*in" of "Baue*")',
        '(e. g. 10*5155 or 105658*)' => '(b.v. 10*5155 or 105658*)',
        '(e. g. 234321)' => '(b.v. 234321)',
        'Customer User Login' => 'Klant login',
        '(e. g. U5150)' => '(b.v. U5150)',
        'SLA' => 'SLA',
        'Agent' => 'Agent/Eigenaar',
        'Ticket Lock' => 'Ticket vergrendeling',
        'TicketFreeFields' => 'Vrije invulvelden van het Ticket',
        'Create Times' => 'Tijd instellingen',
        'No create time settings.' => 'Geen tijd instellingen',
        'Ticket created' => 'Ticket aangemaakt',
        'Ticket created between' => 'Ticket aangemaakt tussen',
        'Close Times' => '',
        'No close time settings.' => '',
        'Ticket closed' => '',
        'Ticket closed between' => '',
        'Pending Times' => 'Wachtend tijden',
        'No pending time settings.' => 'Geen wachtende tijd instellingen',
        'Ticket pending time reached' => 'Ticket wachtende tijd bereikt',
        'Ticket pending time reached between' => 'Ticket wachtende tijd tussen',
        'New Service' => '',
        'New SLA' => '',
        'New Priority' => 'Nieuwe prioriteit',
        'New Queue' => 'Nieuwe wachtrij',
        'New State' => 'Nieuwe status',
        'New Agent' => 'Nieuwe agent',
        'New Owner' => 'Nieuwe eigenaar',
        'New Customer' => 'Nieuwe klant',
        'New Ticket Lock' => 'Nieuwe Ticket vergrendeling',
        'New Type' => '',
        'New Title' => '',
        'New Type' => '',
        'New TicketFreeFields' => '',
        'Add Note' => 'Notitie toevoegen',
        'CMD' => 'Commando',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' => 'Dit commando zal worden uitgevoerd. ARG[0] is het nieuwe ticketnummer. ARG[1] is het nieuwe ticket id.',
        'Delete tickets' => 'Verwijder tickets.',
        'Warning! This tickets will be removed from the database! This tickets are lost!' => 'Waarschuwing! Deze Tickets zullen worden verwijderd uit de database!',
        'Send Notification' => 'Stuur notificatie',
        'Param 1' => 'Parameter 1',
        'Param 2' => 'Parameter 2',
        'Param 3' => 'Parameter 3',
        'Param 4' => 'Parameter 4',
        'Param 5' => 'Parameter 5',
        'Param 6' => 'Parameter 6',
        'Send no notifications' => 'Stuur geen notificaties',
        'Yes means, send no agent and customer notifications on changes.' => 'Ja betekent dat er geen notificaties worden gestuurd naar eigenaren en klanten bij wijzigingen.',
        'No means, send agent and customer notifications on changes.' => 'Nee betekent dat er wel notificaties worden gestuurd naar eigenaren en klanten bij wijzigingen.',
        'Save' => 'Opslaan',
        '%s Tickets affected! Do you really want to use this job?' => '%s Tickets worden bewerkt! Weet u zeker dat u deze actie wilt uitvoeren?',
        '"}' => '"}',

        # Template: AdminGroupForm
        'Group Management' => 'Groepenbeheer',
        'Add Group' => 'Groep toevoegen',
        'Add a new Group.' => 'Nieuwe groep toevoegen',
        'The admin group is to get in the admin area and the stats group to get stats area.' => 'Leden van de groep Admin mogen in het administratie gedeelte, leden van de groep Stats hebben toegang tot het statistieken gedeelte.',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).' => 'Maak nieuwe groepen aan om de toegangsrechten te regelen voor verschillende groepen van agenten (bijv. verkoopafdeling, supportafdeling).',
        'It\'s useful for ASP solutions.' => 'Zeer bruikbaar voor ASP-oplossingen.',

        # Template: AdminLog
        'System Log' => 'Systeem logboek',
        'Time' => 'Tijd',

        # Template: AdminMailAccount
        'Mail Account Management' => '',
        'Host' => 'Server',
        'Trusted' => 'Vertrouwd',
        'Dispatching' => 'Sortering',
        'All incoming emails with one account will be dispatched in the selected queue!' => 'Alle binnenkomende e-mail\'s in een account zullen worden geplaatst in de geselecteerde wachtrij',
        'If your account is trusted, the already existing X-OTRS header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' => '',

        # Template: AdminNavigationBar
        'Users' => 'Gebruikers',
        'Groups' => 'Groepen',
        'Misc' => 'Overige',

        # Template: AdminNotificationForm
        'Notification Management' => 'Meldingen beheer',
        'Notification' => 'Melding',
        'Notifications are sent to an agent or a customer.' => 'Meldingen worden verstuurd naar een agent of een klant',

        # Template: AdminPackageManager
        'Package Manager' => '',
        'Uninstall' => '',
        'Version' => '',
        'Do you really want to uninstall this package?' => '',
        'Reinstall' => 'Reinstall',
        'Do you really want to reinstall this package (all manual changes get lost)?' => '',
        'Continue' => 'Doorgaan',
        'Install' => 'Installeer',
        'Package' => 'Arrangement',
        'Online Repository' => '',
        'Vendor' => 'Verkoper',
        'Upgrade' => '',
        'Local Repository' => '',
        'Status' => '',
        'Overview' => 'Overzicht',
        'Download' => 'Downloaden',
        'Rebuild' => 'Herbouw',
        'ChangeLog' => '',
        'Date' => 'Datum',
        'Filelist' => '',
        'Download file from package!' => '',
        'Required' => 'verplicht',
        'PrimaryKey' => '',
        'AutoIncrement' => '',
        'SQL' => '',
        'Diff' => '',

        # Template: AdminPerformanceLog
        'Performance Log' => '',
        'This feature is enabled!' => '',
        'Just use this feature if you want to log each request.' => '',
        'Of couse this feature will take some system performance it self!' => '',
        'Disable it here!' => '',
        'This feature is disabled!' => '',
        'Enable it here!' => '',
        'Logfile too large!' => '',
        'Logfile too large, you need to reset it!' => '',
        'Range' => 'Bereik',
        'Interface' => '',
        'Requests' => 'Verzoeken',
        'Min Response' => '',
        'Max Response' => '',
        'Average Response' => 'Gemiddelde Response',
        'Period' => 'Looptijd',
        'Min' => '',
        'Max' => '',
        'Average' => 'Gemiddeld',

        # Template: AdminPGPForm
        'PGP Management' => '',
        'Result' => 'Resultaat',
        'Identifier' => '',
        'Bit' => '',
        'Key' => '',
        'Fingerprint' => '',
        'Expires' => 'Verloopt',
        'In this way you can directly edit the keyring configured in SysConfig.' => '',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => 'Postmaster filter beheer',
        'Filtername' => 'Filter naam',
        'Match' => 'Komt overeen met',
        'Header' => 'Type',
        'Value' => 'Waarde',
        'Set' => '...wordt dan gewijzigd met...',
        'Do dispatch or filter incoming emails based on email X-Headers! RegExp is also possible.' => 'U kunt hiermee een filtering aanbrengen in het ontvangen van e-mailberichten op basis van e-mail gegevens, zoals het e-mailadres, het onderwerp etc.',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' => '',
        'If you use RegExp, you also can use the matched value in () as [***] in \'Set\'.' => '',

        # Template: AdminQueueAutoResponseForm
        'Queue <-> Auto Responses Management' => 'Wachtrij <-> Automatische beantwoordingen',

        # Template: AdminQueueForm
        'Queue Management' => 'Wachtrij beheer',
        'Sub-Queue of' => 'Sub-wachtrij van',
        'Unlock timeout' => 'Ontgrendel tijdsoverschrijding',
        '0 = no unlock' => '0 = geen ontgrendeling',
        'Only business hours are counted.' => '',
        'Escalation - First Response Time' => '',
        '0 = no escalation' => '0 = geen escalatie',
        'Only business hours are counted.' => '',
        'Notify by' => '',
        'Escalation - Update Time' => '',
        'Notify by' => '',
        'Escalation - Solution Time' => '',
        'Follow up Option' => 'Follow up optie',
        'Ticket lock after a follow up' => 'Ticket-vergrendeling na een follow up',
        'Systemaddress' => 'Systeem-adres',
        'Customer Move Notify' => 'Klant notificatie bij verplaatsen',
        'Customer State Notify' => 'Klant notificatie andere status',
        'Customer Owner Notify' => 'Klant notificatie andere eigenaar',
        'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.' => 'Wanneer een agent een ticket vergrendelt en hij/zij stuurt geen antwoord binnen de vergrendel tijd dan zal het ticket automatisch ontgrendeld worden. Het ticket kan dan door andere agenten worden ingezien.',
        'Escalation time' => 'Escalatietijd',
        'If a ticket will not be answered in this time, just only this ticket will be shown.' => 'Als een ticket niet binnen deze tijd is beantwoord zal alleen dit ticket worden getoond.',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.' => 'Wanneer een ticket wordt gesloten and de klant stuurt een follow up wordt het ticket vergrendeld door de oude eigenaar.',
        'Will be the sender address of this queue for email answers.' => 'is het afzenderadres van deze wachtrij voor antwoorden per e-mail',
        'The salutation for email answers.' => 'De aanhef voor beantwoording van berichten per e-mail.',
        'The signature for email answers.' => 'De handtekening voor beantwoording van berichten per e-mail.',
        'OTRS sends an notification email to the customer if the ticket is moved.' => 'Het systeem stuurt een notificatie e-mail naar de klant wanneer het ticket wordt verplaatst.',
        'OTRS sends an notification email to the customer if the ticket state has changed.' => 'Het systeem stuurt een notificatie e-mail naar de klant wanneer de status is veranderd',
        'OTRS sends an notification email to the customer if the ticket owner has changed.' => 'Het systeem stuurt een notificatie e-mail naar de klant wanneer de eigenaar is veranderd',

        # Template: AdminQueueResponsesChangeForm
        'Responses <-> Queue Management' => 'Beantwoordingen <-> Wachtrij beheer',

        # Template: AdminQueueResponsesForm
        'Answer' => 'Antwoord',

        # Template: AdminResponseAttachmentChangeForm
        'Responses <-> Attachments Management' => 'Beantwoordingen <-> Bijlagen beheer',

        # Template: AdminResponseAttachmentForm

        # Template: AdminResponseForm
        'Response Management' => 'Antwoordbeheer',
        'A response is default text to write faster answer (with default text) to customers.' => 'Een antworord is een standaard-tekst om sneller antwoorden te kunnen opstellen.',
        'Don\'t forget to add a new response a queue!' => 'Vergeet niet om een antwoord aan de wachtrij toe te kennen!',
        'The current ticket state is' => 'De huidige ticketstatus is.',
        'Your email address is new' => 'Uw e-mail adres is nieuw.',

        # Template: AdminRoleForm
        'Role Management' => 'Rollen beheer',
        'Add Role' => 'Voeg rol toe',
        'Add a new Role.' => 'Voeg een nieuwe rol toe',
        'Create a role and put groups in it. Then add the role to the users.' => 'Maak een nieuwe rol en koppel deze aan groepen. Vervolgens kunt u rollen toewijzen aan gebruikers.',
        'It\'s useful for a lot of users and groups.' => '',

        # Template: AdminRoleGroupChangeForm
        'Roles <-> Groups Management' => 'Rollen <-> Groepen beheer',
        'move_into' => 'verplaats naar',
        'Permissions to move tickets into this group/queue.' => 'Rechten om Tickets naar deze groep/wachtrij te verplaatsen.',
        'create' => 'aanmaken',
        'Permissions to create tickets in this group/queue.' => 'Rechten om Tickets in deze groep/wachtrij aan te maken.',
        'owner' => 'eigenaar',
        'Permissions to change the ticket owner in this group/queue.' => 'Rechten om de eigenaar van het Ticket in deze groep / wachtrij te wijzigen.',
        'priority' => 'prioriteit',
        'Permissions to change the ticket priority in this group/queue.' => 'Rechten om de prioriteit van een Ticket in deze groep / wachtrij te wijzigen.',

        # Template: AdminRoleGroupForm
        'Role' => 'Rol',

        # Template: AdminRoleUserChangeForm
        'Roles <-> Users Management' => 'Rollen <-> Gebruikers beheer',
        'Select the role:user relations.' => 'Selecteer de rol : gebruiker relatie',

        # Template: AdminRoleUserForm

        # Template: AdminSalutationForm
        'Salutation Management' => 'Aanhef beheer',
        'Add Salutation' => 'Aanhef toevoegen',
        'Add a new Salutation.' => 'Een nieuwe aanhef toevoegen',

        # Template: AdminSelectBoxForm
        'SQL Box' => '',
        'Limit' => 'Beperk tot',
        'Go' => 'Uitvoeren',
        'Select Box Result' => 'keuzekader resultaat',

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
        'S/MIME Management' => '',
        'Add Certificate' => '',
        'Add Private Key' => '',
        'Secret' => '',
        'Hash' => '',
        'In this way you can directly edit the certification and private keys in file system.' => '',

        # Template: AdminStateForm
        'State Management' => 'Status beheer',
        'Add State' => 'Status toevoegen',
        'Add a new State.' => 'Voet een nieuwe status toe.',
        'State Type' => 'Status Type',
        'Take care that you also updated the default states in you Kernel/Config.pm!' => 'Bewaak dat u ook de default statussen in uw Kernel/Config.pm bijwerkt!',
        'See also' => 'Zie ook',

        # Template: AdminSysConfig
        'SysConfig' => 'Systeem configuratie',
        'Group selection' => 'Groep selectie',
        'Show' => 'Laat zien',
        'Download Settings' => 'Download instellingen',
        'Download all system config changes.' => 'Download alle wijzigingen in de systeem configuratie.',
        'Load Settings' => 'Laad de instellingen',
        'Subgroup' => 'Sub-groep',
        'Elements' => 'Elementen',

        # Template: AdminSysConfigEdit
        'Config Options' => 'Configuratie opties',
        'Default' => 'Standaard',
        'New' => 'Nieuw',
        'New Group' => 'Nieuwe groep',
        'Group Ro' => 'Groep Read Only',
        'New Group Ro' => 'Nieuwe groep Read Only',
        'NavBarName' => 'Navigatie bar name',
        'NavBar' => 'Navigatiebar',
        'Image' => 'Afbeelding',
        'Prio' => 'Prioriteit',
        'Block' => 'Blokkeer',
        'AccessKey' => 'Toegangssleutel',

        # Template: AdminSystemAddressForm
        'System Email Addresses Management' => 'Systeem e-mailadressen beheer',
        'Add System Address' => 'Systeem e-mailadres toevoegen',
        'Add a new System Address.' => 'Voeg nieuw systeem e-mailadres toe.',
        'Realname' => 'Echte naam',
        'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!' => 'Alle binnenkomende emails met deze "To:" worden in de gekozen wachtrij geplaatst.',

        # Template: AdminTypeForm
        'Type Management' => 'Type beheer',
        'Add Type' => 'Type toevoegen',
        'Add a new Type.' => 'Nieuw type toevoegen.',

        # Template: AdminUserForm
        'User Management' => 'Gebruikersbeheer',
        'Add User' => 'Nieuwe gebruiker toevoegen',
        'Add a new Agent.' => '',
        'Login as' => 'Inloggen als',
        'Firstname' => 'Voornaam',
        'Lastname' => 'Achternaam',
        'User will be needed to handle tickets.' => 'Gebruikers zijn nodig om Tickets te behandelen.',
        'Don\'t forget to add a new user to groups and/or roles!' => 'Vergeet niet om een nieuwe gebruiker toe te voegen aan de groep en/of rollen.',

        # Template: AdminUserGroupChangeForm
        'Users <-> Groups Management' => 'Gebruikers <-> Groepen beheer',

        # Template: AdminUserGroupForm

        # Template: AgentBook
        'Address Book' => 'Adresboek',
        'Return to the compose screen' => 'Terug naar berichtscherm',
        'Discard all changes and return to the compose screen' => 'Veranderingen niet opslaan en ga terug naar het berichtscherm',

        # Template: AgentCalendarSmall

        # Template: AgentCalendarSmallIcon

        # Template: AgentCustomerTableView

        # Template: AgentInfo
        'Info' => 'Informatie',

        # Template: AgentLinkObject
        'Link Object' => 'Link object',
        'Select' => 'Selecteer',
        'Results' => 'Resultaten',
        'Total hits' => 'Totaal gevonden',
        'Page' => 'Pagina',
        'Detail' => 'Detail',

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
        'Select the restrictions to characterise the stat' => '',
        'Fixed' => 'Opgelost',
        'Please select only one element or turn off the button \'Fixed\'.' => '',
        'Absolut Period' => '',
        'Between' => 'Tussen',
        'Relative Period' => '',
        'The last' => 'De laatste',
        'Finish' => 'Afronden',
        'Here you can make restrictions to your stat.' => '',
        'If you remove the hook in the "Fixed" checkbox, the agent generating the stat can change the attributes of the corresponding element.' => '',

        # Template: AgentStatsEditSpecification
        'Insert of the common specifications' => '',
        'Permissions' => 'Rechten',
        'Format' => 'Formaat',
        'Graphsize' => 'Grafiek grootte',
        'Sum rows' => 'Totaal rijen',
        'Sum columns' => 'Totaal kolommen',
        'Cache' => '',
        'Required Field' => 'Verplicht veld',
        'Selection needed' => 'Selectie benodigd',
        'Explanation' => 'Uitleg',
        'In this form you can select the basic specifications.' => '',
        'Attribute' => 'Eigenschap',
        'Title of the stat.' => 'Naam van deze statistieken.',
        'Here you can insert a description of the stat.' => 'Hier kunt u een beschrijving van deze statistieken toevoegen.',
        'Dynamic-Object' => '',
        'Here you can select the dynamic object you want to use.' => '',
        '(Note: It depends on your installation how many dynamic objects you can use)' => '',
        'Static-File' => '',
        'For very complex stats it is possible to include a hardcoded file.' => '',
        'If a new hardcoded file is available this attribute will be shown and you can select one.' => '',
        'Permission settings. You can select one or more groups to make the configurated stat visible for different agents.' => '',
        'Multiple selection of the output format.' => '',
        'If you use a graph as output format you have to select at least one graph size.' => '',
        'If you need the sum of every row select yes' => '',
        'If you need the sum of every column select yes.' => '',
        'Most of the stats can be cached. This will speed up the presentation of this stat.' => '',
        '(Note: Useful for big databases and low performance server)' => '',
        'With an invalid stat it isn\'t feasible to generate a stat.' => '',
        'This is useful if you want that no one can get the result of the stat or the stat isn\'t ready configurated.' => '',

        # Template: AgentStatsEditValueSeries
        'Select the elements for the value series' => '',
        'Scale' => '',
        'minimal' => 'minimaal',
        'Please remember, that the scale for value series has to be larger than the scale for the X-axis (e.g. X-Axis => Month, ValueSeries => Year).' => '',
        'Here you can define the value series. You have the possibility to select one or two elements. Then you can select the attributes of elements. Each attribute will be shown as single value series. If you don\'t select any attribute all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' => '',

        # Template: AgentStatsEditXaxis
        'Select the element, which will be used at the X-axis' => 'Selecteer het element dat gebruikt zal worden voor de X-as',
        'maximal period' => 'maximale periode',
        'minimal scale' => '',
        'Here you can define the x-axis. You can select one element via the radio button. Then you you have to select two or more attributes of the element. If you make no selection all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' => '',

        # Template: AgentStatsImport
        'Import' => 'Importeer',
        'File is not a Stats config' => 'Het bestand is geen geldig statistieken configuratie bestand',
        'No File selected' => 'Geen bestand geselecteerd',

        # Template: AgentStatsOverview
        'Object' => '',

        # Template: AgentStatsPrint
        'Print' => 'Afdrukken',
        'No Element selected.' => 'Geen element geselecteerd.',

        # Template: AgentStatsView
        'Export Config' => 'Exporteer configuratie',
        'Information about the Stat' => 'Informatie over deze statistieken',
        'Exchange Axis' => '',
        'Configurable params of static stat' => '',
        'No element selected.' => 'Geen element geselecteerd.',
        'maximal period from' => '',
        'to' => '',
        'Start' => 'Begin',
        'With the input and select fields you can configurate the stat at your needs. Which elements of a stat you can edit depends on your stats administrator who configurated the stat.' => '',

        # Template: AgentTicketBounce
        'Bounce ticket' => 'Bounce Ticket',
        'Ticket locked!' => 'Ticket vergrendeld!',
        'Ticket unlock!' => 'Ticket ontgrendeld!',
        'Bounce to' => 'Bounce naar',
        'Next ticket state' => 'Volgende status van het ticket',
        'Inform sender' => 'Informeer afzender',
        'Send mail!' => 'Bericht versturen!',

        # Template: AgentTicketBulk
        'Ticket Bulk Action' => 'Ticket Bulk Aktie',
        'Spell Check' => 'Spellingscontrole',
        'Note type' => 'Notitietype',
        'Unlock Tickets' => 'Tickets ontgrendelen',

        # Template: AgentTicketClose
        'Close ticket' => 'Sluit ticket',
        'Previous Owner' => 'Vorige eigenaar',
        'Inform Agent' => 'Informeer agent',
        'Optional' => 'Optioneel',
        'Inform involved Agents' => 'Informeer betrokken agenten',
        'Attach' => 'Bijlage',
        'Next state' => 'Volgende status',
        'Pending date' => 'In de wacht: datum',
        'Time units' => 'Gewerkte tijd',

        # Template: AgentTicketCompose
        'Compose answer for ticket' => 'Bericht opstellen voor',
        'Pending Date' => 'Wachtende datum',
        'for pending* states' => 'voor wachtende statussen',

        # Template: AgentTicketCustomer
        'Change customer of ticket' => 'Wijzig klant van een Ticket',
        'Set customer user and customer id of a ticket' => 'Wijs de klantgebruiker en klantID van een Ticket toe',
        'Customer User' => 'Klant beheer',
        'Search Customer' => 'Klanten zoeken',
        'Customer Data' => 'Klantgegevens',
        'Customer history' => 'Klantgeschiedenis',
        'All customer tickets.' => 'Alle klant Tickets',

        # Template: AgentTicketCustomerMessage
        'Follow up' => '',

        # Template: AgentTicketEmail
        'Compose Email' => 'E-mail opstellen',
        'new ticket' => 'nieuw ticket',
        'Refresh' => 'Herniew',
        'Clear To' => '"Aan" leeg maken',

        # Template: AgentTicketEscalationView
        'Ticket Escalation View' => '',
        'Escalation' => '',
        'Today' => '',
        'Tomorrow' => '',
        'Next Week' => '',
        'up' => 'naar boven',
        'down' => 'naar beneden',
        'Escalation' => '',
        'Locked' => 'Vergrendeld',

        # Template: AgentTicketForward
        'Article type' => 'Artikel type',

        # Template: AgentTicketFreeText
        'Change free text of ticket' => 'Verander de vrije tekstvelden van een Ticket.',

        # Template: AgentTicketHistory
        'History of' => 'Geschiedenis van',

        # Template: AgentTicketLocked

        # Template: AgentTicketMailbox
        'Mailbox' => 'Postbus',
        'Tickets' => 'Tickets',
        'of' => 'van',
        'Filter' => '',
        'New messages' => 'Nieuwe berichten',
        'Reminder' => 'Herinnering',
        'Sort by' => 'Sorteer volgens',
        'Order' => 'Volgorde',

        # Template: AgentTicketMerge
        'Ticket Merge' => 'Ticket samenvoegen',
        'Merge to' => 'Voeg samen met',

        # Template: AgentTicketMove
        'Move Ticket' => 'Verplaats Ticket',

        # Template: AgentTicketNote
        'Add note to ticket' => 'Notitie toevoegen aan Ticket',

        # Template: AgentTicketOwner
        'Change owner of ticket' => 'Wijzig eigenaar van Ticket',

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
        'First Response Time' => 'Eerste antwoord tijd',
        'Update Time' => 'Vervolg tijd',
        'Solution Time' => 'Oplossing tijd',
        'Linked-Object' => 'Gelinkt item',
        'Parent-Object' => 'Hoofd item',
        'Child-Object' => 'Sub item',
        'by' => 'door',

        # Template: AgentTicketPriority
        'Change priority of ticket' => 'Prioriteit wijzigen voor Ticket',

        # Template: AgentTicketQueue
        'Tickets shown' => 'Tickets getoond',
        'Tickets available' => 'Tickets beschikbaar',
        'All tickets' => 'Alle tickets',
        'Queues' => 'Wachtrij',
        'Ticket escalation!' => 'Ticket escalatie!',

        # Template: AgentTicketQueueTicketView
        'Service Time' => 'Service tijd',
        'Your own Ticket' => 'Je eigen Ticket',
        'Compose Follow up' => 'Follow up aanmaken',
        'Compose Answer' => 'Antwoord opstellen',
        'Contact customer' => 'Klant contacteren',
        'Change queue' => 'Wachtrij wisselen',

        # Template: AgentTicketQueueTicketViewLite

        # Template: AgentTicketResponsible
        'Change responsible of ticket' => 'Verander verantwoordelijke van dit ticket',

        # Template: AgentTicketSearch
        'Ticket Search' => 'Zoek Ticket',
        'Profile' => 'Profiel',
        'Search-Template' => 'Zoek template',
        'TicketFreeText' => 'Vrije invulvelden van het Ticket',
        'Created in Queue' => 'Aangemaakt in wachtrij',
        'Close Times' => '',
        'No close time settings.' => '',
        'Ticket closed' => '',
        'Ticket closed between' => '',
        'Result Form' => 'Resultaatformulier',
        'Save Search-Profile as Template?' => 'Zoekprofiel als template bewaren ?',
        'Yes, save it with name' => 'Ja, sla op met naam',

        # Template: AgentTicketSearchOpenSearchDescription

        # Template: AgentTicketSearchResult
        'Change search options' => 'Verander zoekopties',

        # Template: AgentTicketSearchResultPrint

        # Template: AgentTicketSearchResultShort

        # Template: AgentTicketStatusView
        'Ticket Status View' => '',
        'Open Tickets' => 'Openstaande tickets',

        # Template: AgentTicketZoom
        'Expand View' => '',
        'Collapse View' => '',

        # Template: AgentWindowTab

        # Template: AJAX

        # Template: Copyright

        # Template: css

        # Template: customer-css

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
        'Login' => 'Login',
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
        'No time settings.' => 'Geen tijd instellingen',

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

        # Template: HeaderSmall

        # Template: Installer
        'Web-Installer' => '',
        'Welcome to %s' => 'Welkom bij %s',
        'Accept license' => 'Accepteer licentie',
        'Don\'t accept license' => 'Licentie niet accepteren',
        'Admin-User' => 'Admin gebruiker',
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty. For security reasons we do recommend setting a root password. For more information please refer to your database documentation.' => '',
        'Admin-Password' => 'Admin wachtwoord',
        'Database-User' => 'Database gebruiker',
        'default \'hot\'' => '',
        'DB connect host' => '',
        'Database' => 'Database',
        'Default Charset' => '',
        'utf8' => '',
        'false' => 'onwaar',
        'SystemID' => 'Systeem ID',
        '(The identify of the system. Each ticket number and each http session id starts with this number)' => '',
        'System FQDN' => 'Systeem domeinnaam',
        '(Full qualified domain name of your system)' => '',
        'AdminEmail' => 'Admin e-mail adres',
        '(Email of the system admin)' => '',
        'Organization' => 'Organisatie',
        'Log' => '',
        'LogModule' => '',
        '(Used log backend)' => '',
        'Logfile' => '',
        '(Logfile just needed for File-LogModule!)' => '',
        'Webfrontend' => '',
        'Use utf-8 it your database supports it!' => '',
        'Default Language' => '',
        '(Used default language)' => '',
        'CheckMXRecord' => '',
        '(Checks MX recordes of used email addresses by composing an answer. Don\'t use CheckMXRecord if your OTRS machine is behinde a dial-up line $!)' => '',
        'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' => '',
        'Restart your webserver' => '',
        'After doing so your OTRS is up and running.' => '',
        'Start page' => '',
        'Your OTRS Team' => '',

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

        # Template: Redirect

        # Template: Test
        'OTRS Test Page' => 'OTRS Testpagina',
        'Counter' => 'Teller',

        # Template: Warning
        # Misc
        'Edit Article' => 'Bewerk artikel',
        'Create new Phone Ticket' => 'Maak nieuw Telefoon Ticket aan',
        'Symptom' => 'Symptoom',
        'U' => 'U',
        'A message should have a To: recipient!' => 'Een bericht moet een ontvanger (aan:) hebben!',
        'Customer history search (e. g. "ID342425").' => 'Klantgeschiedenis zoeken (bijv. "ID342425").',
        'for agent firstname' => 'voornaam van agent',
        'Close!' => 'Sluit!',
        'The message being composed has been closed.  Exiting.' => 'Het bericht dat werd aangemaakt is gesloten.',
        'A web calendar' => 'Kalender',
        'to get the realname of the sender (if given)' => 'voor de echte naam van de afzender (indien beschikbaar)',
        'Notification (Customer)' => 'Notificatie (klant)',
        'Select Source (for add)' => 'Selecteer bron (voor toevoegen)',
        'Options of the ticket data (e. g. &lt;OTRS_TICKET_Number&gt;, &lt;OTRS_TICKET_ID&gt;, &lt;OTRS_TICKET_Queue&gt;, &lt;OTRS_TICKET_State&gt;)' => 'Mogelijkheden van de ticket gegevens (bijv. &lt;OTRS_TICKET_Number&gt;, &lt;OTRS_TICKET_ID&gt;, &lt;OTRS_TICKET_Queue&gt;, &lt;OTRS_TICKET_State&gt;)',
        'Days' => 'Dagen',
        'Queue ID' => 'Wachtrij ID',
        'Config options (e. g. <OTRS_CONFIG_HttpType>)' => 'Configuratie opties (b.v. <OTRS_CONFIG_HttpType>)',
        'System History' => 'Systeem geschiedenis',
        'customer realname' => 'naam van de klant',
        'Pending messages' => 'Wachtende berichten',
        'Modules' => 'Modulen',
        'for agent login' => 'de login van de agent',
        'Keyword' => 'Steekwoord',
        'with' => 'met',
        'Close type' => 'Sluit-type',
        'for agent user id' => 'de loginnaam van de agent ',
        'sort upward' => 'sorteer oplopend',
        'Change user <-> group settings' => 'Wijzigen van gebruiker <-> groep toekenning',
        'Problem' => 'Probleem',
        'next step' => 'volgende stap',
        'Customer history search' => 'Zoeken in klantgeschiednis',
        'Admin-Email' => 'Admin e-mail adres',
        'A message must be spell checked!' => 'Van een bericht moet de spelling gecontroleerd worden',
        'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further information.' => 'Uw e-mail met Ticket nummer "<OTRS_TICKET>" is gebounced naar "<OTRS_BOUNCE_TO>". Neem contact op met dit adres voor meer informatie.',
        'ArticleID' => 'Artikel ID',
        'A message should have a body!' => 'Een bericht moet een berichttekst hebben!',
        'All Agents' => 'Alle agenten',
        'Keywords' => 'Steekwoorden',
        'No * possible!' => 'Geen * mogelijk!',
        'Options of the current user who requested this action (e. g. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)' => 'Mogelijkheden van de huidige gebruiker die deze bewerking heeft aangevraagd (bijv. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)',
        'Message for new Owner' => 'Bericht voor nieuwe eigenaar',
        'to get the first 5 lines of the email' => 'voor de eerste vijf regels van het e-mail bericht',
        'Last update' => 'Laatste wijziging',
        'to get the first 20 character of the subject' => 'voor de eerste 20 tekens van het onderwerp',
        'Select the customeruser:service relations.' => '',
        'FileManager' => 'Bestandsbeheer',
        'Options of the current customer user data (e. g. <OTRS_CUSTOMER_DATA_UserFirstname>)' => 'Opties van de huidige gebruikersdata van de klant (b.v. <OTRS_CUSTOMER_DATA_UserFirstname>)',
        'Pending type' => 'In de wacht: type',
        'Comment (internal)' => 'Interne opmerking',
        'Ticket owner options (e. g. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)' => 'Ticket eigenaar mogelijkheden (bijv. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)',
        'This window must be called from compose window' => 'Dit scherm moet van het scherm <opstellen bericht> worden aangeroepen',
        'You need min. one selected Ticket!' => 'U heeft tenminste 1 geselecteerd Ticket nodig.',
        'Options of the ticket data (e. g. <OTRS_TICKET_Number>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' => 'Mogelijkheden van Ticket gegevens (e. g. <OTRS_TICKET_Number>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)',
        'Fulltext' => 'Volledig',
        ' (work units)' => '(in minuten)',
        'All Customer variables like defined in config option CustomerUser.' => 'Alle klantvariabelen zoals vastgelegd in de configuratieoptie Klantgebruiker.',
        'for agent lastname' => 'achternaam van agent',
        'Options of the current user who requested this action (e. g. <OTRS_CURRENT_UserFirstname>)' => 'Opties van de gebruiker die deze actie heeft aangevraagd (b.v. <OTRS_CURRENT_UserFirstname>)',
        'Reminder messages' => 'Herinneringsberichten',
        'If your account is trusted, the already existing x-otrs header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' => 'Wanneer het account vertrouwd is, zullen de x-otrs headers gebruikt worden! PostMaster filters zullen ook nog steeds gebruikt worden.',
        'A message should have a subject!' => 'Een bericht moet een onderwerp hebben!',
        'TicketZoom' => 'Inhoud ticket',
        'Don\'t forget to add a new user to groups!' => 'Vergeet niet om groepen aan deze gebruiker toe te kennen!',
        'You need a email address (e. g. customer@example.com) in To:!' => 'In het Aan-veld is een e-mail adres nodig!',
        'CreateTicket' => 'Ticket aanmaken',
        'You need to account time!' => 'Het is verplicht tijd te verantwoorden!',
        'WebWatcher' => '',
        'Finished' => 'Afgerond',
        'Split' => 'Splitsing',
        'D' => 'D',
        'All messages' => 'Alle berichten',
        'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' => 'Mogelijkheden van de ticket gegevens (bijv. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)',
        'A article should have a title!' => 'Een artikel moet een titel hebben!',
        'Config options (e. g. &lt;OTRS_CONFIG_HttpType&gt;)' => 'Configuratie mogelijkheden (bijv. &lt;OTRS_CONFIG_HttpType&gt;)',
        'Event' => '',
        'A web mail client' => 'Webmail gebruiker',
        'WebMail' => 'Webmail',
        'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' => 'Mogelijkheden van de ticket gegevens (bijv. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)',
        'Ticket owner options (e. g. <OTRS_OWNER_UserFirstname>)' => 'Opties voor de Ticket eigenaar (b.v. <OTRS_OWNER_UserFirstname>)',
        'Name is required!' => 'Naam is verplicht!',
        'kill all sessions' => 'alle sessies afsluiten',
        'to get the from line of the email' => 'voor het e-mailadres waar vandaan de e-mail komt',
        'Solution' => 'Oplossing',
        'QueueView' => 'Wachtrijen',
        'My Queue' => 'Mijn wachtrij',
        'Select Box' => 'SQL select query',
        'Welcome to OTRS' => 'Welkom bij OTRS',
        'modified' => 'aangepast',
        'Escalation in' => 'Escalatie om',
        'sort downward' => 'sorteer aflopend',
        'You need to use a ticket number!' => 'U dient een Ticket nummer te gebruiken.',
        'A web file manager' => 'Een online bestandsbeheer',
        'Have a lot of fun!' => '',
        'send' => 'verstuur',
        'Note Text' => 'Notitietekst',
        'POP3 Account Management' => 'POP3 Account beheer',
        'Options of the current customer user data (e. g. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)' => 'Mogelijkheden van de huidige klant gegevens (bijv. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)',
        'System State Management' => 'Status beheer',
        'PhoneView' => 'Telefoonscherm',
        'maximal period form' => '',
        'TicketID' => 'Ticket ID',
        'Modified' => 'Gewijzigd',
        'Ticket selected for bulk action!' => 'Ticket geselecteerd voor bulk aktie!',

        'Link Object: %s' => '',
        'Unlink Object: %s' => '',
        'Linked as' => '',
        'Can not create link with %s!' => '',
        'Can not delete link with %s!' => '',
        'Object already linked as %s.' => '',
        'Priority Management' => '',
        'Add a new Priority.' => '',
        'Add Priority' => '',
        'Ticket Type is required!' => '',
        'Module documentation' => '',
        'Added!' => '',
        'Updated!' => '',
    };
    # $$STOP$$
    return;
}

1;
