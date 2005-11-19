# --
# Kernel/Language/nl.pm - provides nl language translation
# Copyright (C) 2002-2003 Fred van Dijk <fvandijk at marklin.nl>
# Maintenance responsibility taken over by Hans Bakker (h.bakker@a-net.nl)
# Copyright (C) 2003 A-NeT Internet Services bv
# Copyright (C) 2004 Martijn Lohmeijer (martijn.lohmeijer 'at' sogeti.nl)
# Copyright (C) 2005 Jurgen Rutgers (jurgen 'at' besite.nl)
# --
# $Id: nl.pm,v 1.35.2.1 2005-11-19 12:46:29 cs Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

###########################################################################
#                                                                         #
# 14-05-2004                                                              #
#                                                                         #
# This update is by: Martijn Lohmeijer (martijn.lohmeijer 'at' sogeti.nl) #
# Based on the CVS de.pm and nl.pm from 14-05-2004                        #
#                                                                         #
# Below you will find a list of specifically not translated words.        #
# Reason for not translating them is the frequent use of these terms in   #
# either a. our daily practice at the department 'Interne Automatisering' #
# of Sogeti Nederland B.V. or b. common Dutch speak in which a lot of     #
# modern English terms are not translated.                                #
#                                                                         #
# 11-11-2005                                                              #
#                                                                         #
# This update is by: Jurgen Rutgers (jurgen 'at' besite.nl)               #
# Based on the CVS de.pm and nl.pm from OTRS 2.0.3                        #
#                                                                         #
###########################################################################

# Not translated terms / words:

# Agent Area --> it's clear what that does
# Bounce
# Contract
# Directory
# History::Lock --> "Ticket locked" works for me
# History::Unlock --> see above
# lock / unlock --> see above
# Online Agent
# Type
# Upload

package Kernel::Language::nl;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.35.2.1 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*\$/$1/;
# --
sub Data {
    my $Self = shift;
    my %Param = @_;

    # $$START$$
    # Last translation file sync: Thu Jul 28 22:14:35 2005

    # possible charsets
    $Self->{Charset} = ['iso-8859-1', 'iso-8859-15', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Jear;)
    $Self->{DateFormat} = '%D.%M.%Y %T';
    $Self->{DateFormatLong} = '%A %D %B %T %Y';
    $Self->{DateInputFormat} = '%D.%M.%Y';
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
      'Linked' => 'Gelinkt',
      'Link (Normal)' => 'Link (normaal)',
      'Link (Parent)' => 'Link (hoofd)',
      'Link (Child)' => 'Link (sub)',
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
      'CustomerID' => 'KlantID',
      'CustomerIDs' => 'KlantIDs',
      'customer' => 'klant',
      'agent' => 'agent',
      'system' => 'systeem',
      'Customer Info' => 'Klant informatie',
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
      'Item' => 'Item',
      'Delete' => 'Verwijder',
      'Edit' => 'Wijzig',
      'View' => 'Weergave',
      'Number' => 'Nummer',
      'System' => 'Systeem',
      'Contact' => 'Contact',
      'Contacts' => 'Contacten',
      'Export' => 'Export',
      'Up' => 'Boven',
      'Down' => 'Beneden',
      'Add' => 'Toevoegen',
      'Category' => 'Categorie',
      'Viewer' => 'Viewer',
      'New message' => 'Nieuw bericht',
      'New message!' => 'Nieuw bericht!',
      'Please answer this ticket(s) to get back to the normal queue view!' => 'Onderstaande geëscaleerde Tickets dient u eerst te beantwoorden om terug te kunnen komen in de normale wachtwij',
      'You got new message!' => 'U heeft een nieuw bericht!',
      'You have %s new message(s)!' => 'U heeft %s nieuwe bericht(en)!',
      'You have %s reminder ticket(s)!' => 'U heeft %s herinneringsTicket(s)!',
      'The recommended charset for your language is %s!' => 'De aanbevolen karakterset voor uw taal is %s!',
      'Passwords dosn\'t match! Please try it again!' => 'Wachtwoorden komen niet overeen! Probeer het opnieuw!',
      'Password is already in use! Please use an other password!' => 'Wachtwoord wordt al gebruikt. Kies een ander wachtwoord!',
      'Password is already used! Please use an other password!' => 'Wachtwoord is al in gebruik. Kies een ander wachtwoord!',
      'You need to activate %s first to use it!' => 'U dient %s eerst te activeren voordat u het kunt gebruiken.',
      'No suggestions' => 'Geen suggesties',
      'Word' => 'Woord',
      'Ignore' => 'Negeren',
      'replace with' => 'vervangen met',
      'Welcome to OTRS' => 'Welkom bij OTRS',
      'There is no account with that login name.' => 'Er is geen account bekend met deze gebruikersnaam',
      'Login failed! Your username or password was entered incorrectly.' => 'Aanmelden is mislukt. Uw gebruikersnaam of wachtwoord is onjuist.',
      'Please contact your admin' => 'Vraag uw systeembeheerder',
      'Logout successful. Thank you for using OTRS!' => 'Afgemeld! Wij danken u voor het gebruiken van OTRS!',
      'Invalid SessionID!' => 'Ongeldige SessieID',
      'Feature not active!' => 'Deze functie is niet actief!',
      'Take this Customer' => 'Selecteer deze klant',
      'Take this User' => 'Selecteer deze gebruiker',
      'possible' => 'mogelijk',
      'reject' => 'afwijzen',
      'Facility' => 'Maatregel',
      'Timeover' => 'Timeover',
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
      'Preview' => 'Preview',
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
      'Directory' => '',
      'Signed' => 'Getekend',
      'Sign' => 'Teken',
      'Crypted' => '',
      'Crypt' => '',

      # Template: AAAMonth
      'Jan' => '',
      'Feb' => '',
      'Mar' => 'Mrt',
      'Apr' => '',
      'May' => 'Mei',
      'Jun' => '',
      'Jul' => '',
      'Aug' => '',
      'Sep' => '',
      'Oct' => 'Okt',
      'Nov' => '',
      'Dec' => '',

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
      'FAQ-Area' => 'FAQ',
      'FAQ' => 'FAQ',
      'FAQ-Search' => 'FAQ-zoeken',
      'FAQ-Article' => 'FAQ-artikel',
      'New Article' => 'Nieuw artikel',
      'FAQ-State' => 'FAQ-status',
      'Admin' => '',
      'A web calendar' => 'Kalender',
      'WebMail' => '',
      'A web mail client' => 'Webmail gebruiker',
      'FileManager' => 'Bestandsbeheer',
      'A web file manager' => 'Een online bestandsbeheer',
      'Artefact' => '',
      'Incident' => '',
      'Advisory' => '',
      'WebWatcher' => '',
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
      'Can\'t update password, passwords dosn\'t match! Please try it again!' => 'Uw wachtwoord kan niet worden gewijzigd, de wachtwoorden komen niet overeen. Probeer het opnieuw.',
      'Can\'t update password, invalid characters!' => 'Uw wachtwoord kan niet worden gewijzigd, er zijn ongeldige karakters gevonden.',
      'Can\'t update password, need min. 8 characters!' => 'Uw wachtwoord kan niet worden gewijzigd, er zijn minimaal 8 karakters noodzakelijk.',
      'Can\'t update password, need 2 lower and 2 upper characters!' => 'Uw wachtwoord kan niet worden gewijzigd, er zijn minimaal 2 normale en 2 hoofdletters noodzakelijk.',
      'Can\'t update password, need min. 1 digit!' => 'Uw wachtwoord kan niet worden gewijzigd, er is minimaal 1 cijfer noodzakelijk.',
      'Can\'t update password, need min. 2 characters!' => 'Uw wachtwoord kan niet worden gewijzigd, er zijn minimaal 2 letters noodzakelijk.',
      'Password is needed!' => 'Een wachtwoord is vereist.',

      # Template: AAATicket
      'Lock' => '',
      'Unlock' => '',
      'History' => 'Geschiedenis',
      'Zoom' => 'Inhoud',
      'Age' => 'Leeftijd',
      'Bounce' => '',
      'Forward' => 'Doorsturen',
      'From' => 'Van',
      'To' => 'Aan',
      'Cc' => '',
      'Bcc' => '',
      'Subject' => 'Betreft',
      'Move' => 'Verplaatsen',
      'Queue' => 'Wachtrij',
      'Priority' => 'Prioriteit',
      'State' => 'Status',
      'Compose' => 'Maken',
      'Pending' => 'Wachtend',
      'Owner' => 'Eigenaar',
      'Owner Update' => '',
      'Sender' => 'Afzender',
      'Article' => 'Artikel',
      'Ticket' => '',
      'Createtime' => 'Gemaakt op',
      'plain' => 'zonder opmaak',
      'eMail' => 'e-mail',
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
      'closed successful' => 'succesvol gesloten',
      'closed unsuccessful' => 'niet succesvol gesloten',
      'new' => 'nieuw',
      'open' => '',
      'closed' => 'gesloten',
      'removed' => 'verwijderd',
      'pending reminder' => 'wachtend op een herinnering',
      'pending auto close+' => 'wachtend op automatisch sluiten+',
      'pending auto close-' => 'wachtend op automatisch sluiten-',
      'email-external' => 'e-mail extern',
      'email-internal' => 'e-mail intern',
      'note-external' => 'externe notitie',
      'note-internal' => 'interne notitie',
      'note-report' => 'notitie rapport',
      'phone' => 'telefoon',
      'sms' => '',
      'webrequest' => 'verzoek via web',
      'lock' => '',
      'unlock' => '',
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
      'Email-Ticket' => 'E-mail Ticket',
      'Create new Email Ticket' => 'Maak nieuw E-mail Ticket aan',
      'Phone-Ticket' => 'Telefoon Ticket',
      'Create new Phone Ticket' => 'Maak nieuw Telefoon Ticket aan',
      'Search Tickets' => 'Zoek Tickets',
      'Edit Customer Users' => 'Wijzig klant gebruikers',
      'Bulk-Action' => 'Bulk Actie',
      'Bulk Actions on Tickets' => 'Bulk Actie op Tickets',
      'Send Email and create a new Ticket' => 'Verstuur e-mail en maak een nieuw Ticket aan',
      'Overview of all open Tickets' => 'Laat alle open Tickets zien',
      'Locked Tickets' => 'Gelockte Tickets',
      'Lock it to work on it!' => 'Lock een Ticket om er mee te kunnen werken.',
      'Unlock to give it back to the queue!' => 'Unlock een Ticket om deze vrij te geven.',
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
      'New ticket notification' => 'Metlding bij een nieuw Ticket',
      'Send me a notification if there is a new ticket in "My Queues".' => 'Stuur mij een melding als er een nieuw Ticket in Mijn wachtrijen komt.',
      'Follow up notification' => 'Melding bij vervolgvragen.',
      'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.' => 'Stuur mij een melding als een klant een vervolgvraag stelt en ik ben de eigenaar van het Ticket.',
      'Ticket lock timeout notification' => 'Stuur mij een melding van tijdsoverschreiding van een gelockt Ticket.',
      'Send me a notification if a ticket is unlocked by the system.' => 'Stuur mij een melding van een bericht als een Ticket wordt ontgrendeld door het systeem.',
      'Move notification' => 'Stuur mij een melding bij het verplaatsen van een Ticket.',
      'Send me a notification if a ticket is moved into one of "My Queues".' => ' Stuur mij een melding als een Ticket wordt verplaatst in een aangepaste wachtrij.',
      'Your queue selection of your favorite queues. You also get notified about this queues via email if enabled.' => 'Uw selectie van uw favoriete wachtrijen. U ontvangt automatisch een melding van nieuwe Tickets in deze wachtrij, indien u hiervor heeft gekozen.',
      'Custom Queue' => 'Aangepaste wachtrij.',
      'QueueView refresh time' => 'Verversingstijd wachtrij.',
      'Screen after new ticket' => 'Scherm na het aanmaken van een nieuw Ticket.',
      'Select your screen after creating a new ticket.' => 'Selecteer het vervolgscherm na het invoeren van een nieuw Ticket.',
      'Closed Tickets' => 'Afgesloten Tickets.',
      'Show closed tickets.' => 'Toon gesloten Tickets.',
      'Max. shown Tickets a page in QueueView.' => 'Max. getoonde Tickets per pagina in wachtrijscherm.',
      'Responses' => 'Antwoorden.',
      'Responses <-> Queue' => 'Antwoorden <-> Wachtrijen',
      'Auto Responses' => 'Automatische beantwoordingen',
      'Auto Responses <-> Queue' => 'Automatische beantwoordeingen <-> Wachtrijen',
      'Attachments <-> Responses' => 'Bijlagen <-> Automatische beantwoordingen',
      'History::Move' => 'Ticket verplaatst naar wachtrij "%s" (%s) van wachtrij "%s" (%s).',
      'History::NewTicket' => 'Nieuw Ticket [%s] aangemaakt (Q=%s;P=%s;S=%s).',
      'History::FollowUp' => 'Vervolg vraag voor [%s]. %s',
      'History::SendAutoReject' => 'Automatische reject verstuurd aan "%s".',
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
      'History::Lock' => '',
      'History::Unlock' => '',
      'History::TimeAccounting' => '%s tijdseenheden verantwoord. Nu %s tijdseenheden totaal.',
      'History::Remove' => '%s',
      'History::CustomerUpdate' => 'Bijgewerkt: %s',
      'History::PriorityUpdate' => 'Prioriteit gewijzigd van "%s" (%s) naar "%s" (%s).',
      'History::OwnerUpdate' => 'Nieuwe eigenaar is "%s" (ID=%s).',
      'History::LoopProtection' => 'Loop-Protection! Geen auto-reply verstuurd aan "%s".',
      'History::Misc' => '%s',
      'History::SetPendingTime' => 'Bijgewerkt: %s',
      'History::StateUpdate' => 'Oud: "%s" Nieuw: "%s"',
      'History::TicketFreeTextUpdate' => 'Bijgewerkt: %s=%s;%s=%s;',
      'History::WebRequestCustomer' => 'Klant stelt vraag via het web.',
      'History::TicketLinkAdd' => 'Link naar "%s" toegevoegd.',
      'History::TicketLinkDelete' => 'Link naar "%s" verwijderd.',

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
      'to get the first 20 character of the subject' => 'voor de eerste 20 tekens van het onderwerp',
      'to get the first 5 lines of the email' => 'voor de eerste vijf regels van het e-mail bericht',
      'to get the from line of the email' => 'voor het e-mailadres waar vandaan de e-mail komt',
      'to get the realname of the sender (if given)' => 'voor de echte naam van de afzender (indien beschikbaar)',
      'Options of the ticket data (e. g. &lt;OTRS_TICKET_Number&gt;, &lt;OTRS_TICKET_ID&gt;, &lt;OTRS_TICKET_Queue&gt;, &lt;OTRS_TICKET_State&gt;)' => 'Mogelijkheden van Ticket gegevens (e. g. &lt;OTRS_TICKET_Number&gt;, &lt;OTRS_TICKET_ID&gt;, &lt;OTRS_TICKET_Queue&gt;, &lt;OTRS_TICKET_State&gt;)',

      # Template: AdminCustomerUserForm
      'The message being composed has been closed.  Exiting.' => 'Het bericht dat werd aangemaakt is gesloten.',
      'This window must be called from compose window' => 'Dit scherm moet van het scherm <opstellen bericht> worden aangeroepen',
      'Customer User Management' => 'Gebruikersbeheer klanten',
      'Search for' => 'Zoek naar',
      'Result' => 'Resultaat',
      'Select Source (for add)' => 'Selecteer bron (voor toevoegen)',
      'Source' => 'Bron',
      'This values are read only.' => 'Deze waarden kunt u alleen lezen.',
      'This values are required.' => 'Deze waarden zijn verplicht.',
      'Customer user will be needed to have an customer histor and to to login via customer panels.' => 'Klanten moeten een klanthistorie hebben voordat zij kunnen inloggen via de klantschermen.',

      # Template: AdminCustomerUserGroupChangeForm
      'Customer Users <-> Groups Management' => 'Klant gebruikers <-> Groepen beheer',
      'Change %s settings' => 'Wijzig instellingen voor %s',
      'Select the user:group permissions.' => 'Selecteer de gebruikers / groep rechten',
      'If nothing is selected, then there are no permissions in this group (tickets will not be available for the user).' => 'Als er geen selectie is gemaakt dan zijn er geen rechten voor deze groep (Tickets zullen dus niet beschikbaar zijn voor de gebruiker).',
      'Permission' => 'Rechten',
      'ro' => '',
      'Read only access to the ticket in this group/queue.' => 'Leesrechten op de Tickets in deze groep / wachtrij.',
      'rw' => '',
      'Full read and write access to the tickets in this group/queue.' => 'Volledige lees- en schrijfrechten op de Tickets in deze groep / wachtrij.',

      # Template: AdminCustomerUserGroupForm

      # Template: AdminEmail
      'Message sent to' => 'Bericht verstuurd naar',
      'Recipents' => 'Ontvangers',
      'Body' => 'Bericht tekst',
      'send' => 'verstuur',

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
      'Agent' => '',
      'TicketFreeText' => 'Vrije invulvelden van het Ticket',
      'Ticket Lock' => '',
      'Times' => 'Keren',
      'No time settings.' => 'Geen tijd instellingen',
      'Ticket created' => 'Ticket aangemaakt',
      'Ticket created between' => 'Ticket aangemaakt tussen',
      'New Priority' => 'Nieuwe prioriteit',
      'New Queue' => 'Nieuwe wachtrij',
      'New State' => 'Nieuwe status',
      'New Agent' => 'Nieuwe agent',
      'New Owner' => 'Nieuwe eigenaar',
      'New Customer' => 'Nieuwe klant',
      'New Ticket Lock' => 'Nieuw Ticket lock',
      'CustomerUser' => 'Klant gebruiker',
      'Add Note' => 'Notitie toevoegen',
      'CMD' => '',
      'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' => 'Dit commando zal worden uitgevoerd. ARG[0] is het nieuwe ticketnummer. ARG[1] is het nieuwe ticket id.',
      'Delete tickets' => 'Verwijder tickets.',
      'Warning! This tickets will be removed from the database! This tickets are lost!' => 'Waarschuwing! Deze Tickets zullen worden verwijderd uit de database!',
      'Modules' => 'Modulen',
      'Param 1' => '',
      'Param 2' => '',
      'Param 3' => '',
      'Param 4' => '',
      'Param 5' => '',
      'Param 6' => '',
      'Save' => 'Opslaan',

      # Template: AdminGroupForm
      'Group Management' => 'Groepenbeheer',
      'The admin group is to get in the admin area and the stats group to get stats area.' => 'Leden van de groep Admin mogen in het administratie gedeelte, leden van de groep Stats hebben toegang tot het statistieken gedeelte.',
      'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).' => 'Maak nieuwe groepen aan om de toegangsrechten te regelen voor verschillende groepen van agenten (bijv. verkoopafdeling, supportafdeling).',
      'It\'s useful for ASP solutions.' => 'Zeer bruikbaar voor ASP-oplossingen.',

      # Template: AdminLog
      'System Log' => 'Systeem logboek',
      'Time' => 'Tijd',

      # Template: AdminNavigationBar
      'Users' => 'Gebruikers',
      'Groups' => 'Groepen',
      'Misc' => 'Overige',

      # Template: AdminNotificationForm
      'Notification Management' => 'Meldingen beheer',
      'Notification' => 'Melding',
      'Notifications are sent to an agent or a customer.' => 'Meldingen worden verstuurd naar een agent of een klant',
      'Config options (e. g. &lt;OTRS_CONFIG_HttpType&gt;)' => 'Configuratie opties (b.v. &lt;OTRS_CONFIG_HttpType&gt;)',
      'Ticket owner options (e. g. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)' => 'Opties voor de Ticket eigenaar (b.v. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)',
      'Options of the current user who requested this action (e. g. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)' => 'Opties van de gebruiker die deze actie heeft aangevraagd (b.v. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)',
      'Options of the current customer user data (e. g. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)' => 'Opties van de huidige gebruikersdata van de klant (b.v. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)',

      # Template: AdminPackageManager
      'Package Manager' => '',
      'Uninstall' => '',
      'Verion' => '',
      'Do you really want to uninstall this package?' => '',
      'Install' => '',
      'Package' => '',
      'Online Repository' => '',
      'Version' => '',
      'Vendor' => '',
      'Upgrade' => '',
      'Local Repository' => '',
      'Status' => '',
      'Overview' => '',
      'Download' => '',
      'Rebuild' => '',
      'Reinstall' => '',

      # Template: AdminPGPForm
      'PGP Management' => '',
      'Identifier' => '',
      'Bit' => '',
      'Key' => '',
      'Fingerprint' => '',
      'Expires' => '',
      'In this way you can directly edit the keyring configured in SysConfig.' => '',

      # Template: AdminPOP3Form
      'POP3 Account Management' => 'POP3 Account beheer',
      'Host' => 'Server',
      'Trusted' => 'Vertrouwd',
      'Dispatching' => 'Sortering',
      'All incoming emails with one account will be dispatched in the selected queue!' => 'Alle binnenkomende e-mail\'s in een account zullen worden geplaatst in de geselecteerde wachtrij',
      'If your account is trusted, the already existing x-otrs header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' => '',

      # Template: AdminPostMasterFilter
      'PostMaster Filter Management' => 'Postmaster filter beheer',
      'Filtername' => 'Filter naam',
      'Match' => 'Komt overeen met',
      'Header' => 'Type',
      'Value' => 'Waarde',
      'Set' => '...wordt dan gewijzigd met...',
      'Do dispatch or filter incoming emails based on email X-Headers! RegExp is also possible.' => 'U kunt hiermee een filtering aanbrengen in het ontvangen van e-mailberichten op basis van e-mail gegevens, zoals het e-mailadres, het onderwerp etc.',
      'If you use RegExp, you also can use the matched value in () as [***] in \'Set\'.' => '',

      # Template: AdminQueueAutoResponseForm
      'Queue <-> Auto Responses Management' => 'Wachtrij <-> Automatische beantwoordingen',

      # Template: AdminQueueAutoResponseTable

      # Template: AdminQueueForm
      'Queue Management' => 'Wachtrij beheer',
      'Sub-Queue of' => 'Sub-wachtrij van',
      'Unlock timeout' => 'Unlock tijdsoverschrijding',
      '0 = no unlock' => '0 = geen ontgrendeling',
      'Escalation time' => 'Escalatietijd',
      '0 = no escalation' => '0 = geen escalatie',
      'Follow up Option' => 'Follow up optie',
      'Ticket lock after a follow up' => 'Ticket-vergrendeling na een follow up',
      'Systemaddress' => 'Systeem-adres',
      'Customer Move Notify' => 'Klant notificatie bij verplaatsen',
      'Customer State Notify' => 'Klant notificatie andere status',
      'Customer Owner Notify' => 'Klant notificatie andere eigenaar',
      'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.' => 'Wanneer een agent een ticket locked en hij/zij stuurt geen antwoord binnen de lock tijd dan zal het ticket automatisch unlocked worden. Het ticket kan dan door andere agenten worden ingezien.',
      'If a ticket will not be answered in thos time, just only this ticket will be shown.' => 'Als een ticket niet binnen deze tijd is beantwoord zal alleen dit ticket worden getoond.',
      'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.' => 'Wanneer een ticket wordt gesloten and de klant stuurt een follow up wordt het ticket gelocked door de oude eigenaar.',
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
      'Next state' => 'Volgende status',
      'All Customer variables like defined in config option CustomerUser.' => 'Alle klantvariabelen zoals vastgelegd in de configuratieoptie Klantgebruiker.',
      'The current ticket state is' => 'De huidige ticketstatus is.',
      'Your email address is new' => 'Uw e-mail adres is nieuw.',

      # Template: AdminRoleForm
      'Role Management' => 'Rollen beheer',
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
      'Active' => 'Actief',
      'Select the role:user relations.' => 'Selecteer de rol : gebruiker relatie',

      # Template: AdminRoleUserForm

      # Template: AdminSalutationForm
      'Salutation Management' => 'Aanhef beheer',
      'customer realname' => 'naam van de klant',
      'for agent firstname' => 'voornaam van agent',
      'for agent lastname' => 'achternaam van agent',
      'for agent user id' => 'de loginnaam van de agent ',
      'for agent login' => 'de login van de agent',

      # Template: AdminSelectBoxForm
      'Select Box' => 'SQL select query',
      'SQL' => '',
      'Limit' => 'Beperk tot',
      'Select Box Result' => 'keuzekader resultaat',

      # Template: AdminSession
      'Session Management' => 'Sessiebeheer',
      'Sessions' => 'Sessies',
      'Uniq' => 'Uniek',
      'kill all sessions' => 'alle sessies afsluiten',
      'Session' => 'Sessie',
      'kill session' => 'sessie afsluiten',

      # Template: AdminSignatureForm
      'Signature Management' => 'Handtekening beheer',

      # Template: AdminSMIMEForm
      'SMIME Management' => '',
      'Add Certificate' => '',
      'Add Private Key' => '',
      'Secret' => '',
      'Hash' => '',
      'In this way you can directly edit the certification and private keys in file system.' => '',

      # Template: AdminStateForm
      'System State Management' => 'Status beheer',
      'State Type' => 'Status Type',
      'Take care that you also updated the default states in you Kernel/Config.pm!' => 'Bewaak dat u ook de default statussen in uw Kernel/Config.pm bijwerkt!',
      'See also' => 'Zie ook',

      # Template: AdminSysConfig
      'SysConfig' => '',
      'Group selection' => 'Groep selectie',
      'Show' => 'Laat zien',
      'Download Settings' => 'Download instellingen',
      'Download all system config changes.' => 'Download alle wijzigingen in de systeem configuratie.',
      'Load Settings' => 'Laad de instellingen',
      'Subgroup' => 'Sub-groep',
      'Elements' => 'Elementen',

      # Template: AdminSysConfigEdit
      'Config Options' => 'Configuratie opties',
      'Default' => '',
      'Content' => 'Inhoud',
      'New' => 'Nieuw',
      'New Group' => 'Nieuwe groep',
      'Group Ro' => 'Groep Read Only',
      'New Group Ro' => 'Nieuwe groep Read Only',
      'NavBarName' => 'Navigatie bar name',
      'Image' => 'Afbeelding',
      'Prio' => 'Prioriteit',
      'Block' => '',
      'NavBar' => 'Navigatiebar',
      'AccessKey' => 'Toegangssleutel',

      # Template: AdminSystemAddressForm
      'System Email Addresses Management' => 'Systeem e-mailadressen beheer',
      'Email' => 'E-mail',
      'Realname' => 'Echte naam',
      'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!' => 'Alle binnenkomende emails met deze "To:" worden in de gekozen wachtrij geplaatst.',

      # Template: AdminUserForm
      'User Management' => 'Gebruikersbeheer',
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
      'Site' => '',
      'Detail' => '',

      # Template: AgentLookup
      'Lookup' => 'Zoek',

      # Template: AgentNavigationBar
      'Ticket selected for bulk action!' => 'Ticket geselecteerd voor bulk aktie!',
      'You need min. one selected Ticket!' => 'U heeft tenminste 1 geselecteerd Ticket nodig.',

      # Template: AgentPreferencesForm

      # Template: AgentSpelling
      'Spell Checker' => 'Spellingscontrole',
      'spelling error(s)' => 'Spelfout(en)',
      'or' => 'of',
      'Apply these changes' => 'Pas deze wijzigingen toe',

      # Template: AgentTicketBounce
      'A message should have a To: recipient!' => 'Een bericht moet een ontvanger (aan:) hebben!',
      'You need a email address (e. g. customer@example.com) in To:!' => 'In het Aan-veld is een e-mail adres nodig!',
      'Bounce ticket' => 'Bounce Ticket',
      'Bounce to' => 'Bounce naar',
      'Next ticket state' => 'Volgende status van het ticket',
      'Inform sender' => 'Informeer afzender',
      'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further informations.' => 'Uw e-mail met Ticket nummer "<OTRS_TICKET>" is gebounced naar "<OTRS_BOUNCE_TO>". Neem contact op met dit adres voor meer informatie.',
      'Send mail!' => 'Bericht versturen!',

      # Template: AgentTicketBulk
      'A message should have a subject!' => 'Een bericht moet een onderwerp hebben!',
      'Ticket Bulk Action' => 'Ticket Bulk Aktie',
      'Spell Check' => 'Spellingscontrole',
      'Note type' => 'Notitietype',
      'Unlock Tickets' => 'Unlock Tickets',

      # Template: AgentTicketClose
      'A message should have a body!' => 'Een bericht moet een berichttekst hebben!',
      'You need to account time!' => 'Het is verplicht tijd te verantwoorden!',
      'Close ticket' => 'Sluit ticket',
      'Note Text' => 'Notitietekst',
      'Close type' => 'Sluit-type',
      'Time units' => 'Gewerkte tijd',
      ' (work units)' => '(in minuten)',

      # Template: AgentTicketCompose
      'A message must be spell checked!' => 'Van een bericht moet de spelling gecontroleerd worden',
      'Compose answer for ticket' => 'Bericht opstellen voor',
      'Attach' => 'Bijlage',
      'Pending Date' => 'Nog hangende datum',
      'for pending* states' => 'voor nog hangende* statussen',

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
      'Clear To' => '',
      'All Agents' => 'Alle agenten',
      'Termin1' => '',

      # Template: AgentTicketForward
      'Article type' => 'Artikel type',

      # Template: AgentTicketFreeText
      'Change free text of ticket' => 'Verander de vrije tekstvelden van een Ticket.',

      # Template: AgentTicketHistory
      'History of' => 'Geschiedenis van',

      # Template: AgentTicketLocked
      'Ticket locked!' => 'Ticket locked!',
      'Ticket unlock!' => 'Ticket unlocked!',

      # Template: AgentTicketMailbox
      'Mailbox' => 'Postbus',
      'Tickets' => 'Tickets',
      'All messages' => 'Alle berichten',
      'New messages' => 'Nieuwe berichten',
      'Pending messages' => 'Wachtende berichten',
      'Reminder messages' => 'Herinneringsberichten',
      'Reminder' => 'Herinnering',
      'Sort by' => 'Sorteer volgens',
      'Order' => 'Volgorde',
      'up' => 'naar boven',
      'down' => 'naar beneden',

      # Template: AgentTicketMerge
      'You need to use a ticket number!' => 'U dient een Ticket nummer te gebruiken.',
      'Ticket Merge' => 'Ticket samenvoegen',
      'Merge to' => 'Voeg samen met',
      'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' => 'Uw e-mail met Ticket nummer "<OTRS_TICKET>" is samengevoegd met "<OTRS_MERGE_TO_TICKET>".',

      # Template: AgentTicketMove
      'Queue ID' => 'Wachtrij ID',
      'Move Ticket' => 'Verplaats Ticket',
      'Previous Owner' => 'Vorige eigenaar',

      # Template: AgentTicketNote
      'Add note to ticket' => 'Notitie toevoegen aan Ticket',
      'Inform Agent' => 'Informeer agent',
      'Optional' => 'Optioneel',
      'Inform involved Agents' => 'Informeer betrokken agenten',

      # Template: AgentTicketOwner
      'Change owner of ticket' => 'Wijzig eigenaar van Ticket',
      'Message for new Owner' => 'Bericht voor nieuwe eigenaar',

      # Template: AgentTicketPending
      'Set Pending' => 'Zet in de wacht',
      'Pending type' => 'In de wacht: type',
      'Pending date' => 'In de wacht: datum',

      # Template: AgentTicketPhone
      'Phone call' => 'Telefoongesprek',

      # Template: AgentTicketPhoneNew
      'Clear From' => 'Wis e-mailadres',

      # Template: AgentTicketPlain
      'Plain' => 'Zonder opmaak',
      'TicketID' => 'Ticket ID',
      'ArticleID' => 'Artikel ID',

      # Template: AgentTicketPrint
      'Ticket-Info' => 'Ticket informatie',
      'Accounted time' => 'Geregistreerde tijd',
      'Escalation in' => 'Escalatie om',
      'Linked-Object' => 'Gelinkt item',
      'Parent-Object' => 'Hoofd item',
      'Child-Object' => 'Sub item',
      'by' => 'door',

      # Template: AgentTicketPriority
      'Change priority of ticket' => 'Prioriteit wijzigen voor Ticket',

      # Template: AgentTicketQueue
      'Tickets shown' => 'Tickets getoond',
      'Page' => 'Pagina',
      'Tickets available' => 'Tickets beschikbaar',
      'All tickets' => 'Alle tickets',
      'Queues' => 'Wachtrij',
      'Ticket escalation!' => 'Ticket escalatie!',

      # Template: AgentTicketQueueTicketView
      'Your own Ticket' => 'Je eigen Ticket',
      'Compose Follow up' => 'Follow up aanmaken',
      'Compose Answer' => 'Antwoord opstellen',
      'Contact customer' => 'Klant contacteren',
      'Change queue' => 'Wachtrij wisselen',

      # Template: AgentTicketQueueTicketViewLite

      # Template: AgentTicketSearch
      'Ticket Search' => 'Zoek Ticket',
      'Profile' => 'Profiel',
      'Search-Template' => 'Zoek template',
      'Created in Queue' => 'Aangemaakt in wachtrij',
      'Result Form' => 'Resultaatformulier',
      'Save Search-Profile as Template?' => 'Zoekprofiel als template bewaren ?',
      'Yes, save it with name' => 'Ja, sla op met naam',
      'Customer history search' => 'Zoeken in klantgeschiednis',
      'Customer history search (e. g. "ID342425").' => 'Klantgeschiedenis zoeken (bijv. "ID342425").',
      'No * possible!' => 'Geen * mogelijk!',

      # Template: AgentTicketSearchResult
      'Search Result' => 'Zoekresultaat',
      'Change search options' => 'Verander zoekopties',

      # Template: AgentTicketSearchResultPrint
      '"}' => '',

      # Template: AgentTicketSearchResultShort
      'sort upward' => 'sorteer oplopend',
      'U' => '',
      'sort downward' => 'sorteer aflopend',
      'D' => '',

      # Template: AgentTicketStatusView
      'Ticket Status View' => '',
      'Open Tickets' => '',

      # Template: AgentTicketZoom
      'Split' => 'Splitsing',

      # Template: AgentTicketZoomStatus
      'Locked' => '',

      # Template: AgentWindowTabStart

      # Template: AgentWindowTabStop

      # Template: Copyright

      # Template: css

      # Template: customer-css

      # Template: CustomerAccept

      # Template: CustomerCalendarSmallIcon

      # Template: CustomerError
      'Traceback' => 'Terug traceren',

      # Template: CustomerFAQ
      'Print' => 'Afdrukken',
      'Keywords' => '',
      'Symptom' => 'Symptoom',
      'Problem' => 'Probleem',
      'Solution' => 'Oplossing',
      'Modified' => 'Gewijzigd',
      'Last update' => 'Laatste wijziging',
      'FAQ System History' => 'FAQ Systeem geschiedenis',
      'modified' => 'aangepast',
      'FAQ Search' => 'FAQ zoeken',
      'Fulltext' => 'Volledig',
      'Keyword' => '',
      'FAQ Search Result' => 'FAQ zoekresultaat',
      'FAQ Overview' => 'FAQ overzicht',

      # Template: CustomerFooter
      'Powered by' => '',

      # Template: CustomerFooterSmall

      # Template: CustomerHeader

      # Template: CustomerHeaderSmall

      # Template: CustomerLogin
      'Login' => '',
      'Lost your password?' => 'Wachtwoord vergeten?',
      'Request new password' => 'Vraag een nieuw wachtwoord aan',
      'Create Account' => 'Maak account',

      # Template: CustomerNavigationBar
      'Welcome %s' => 'Welkom %s',

      # Template: CustomerPreferencesForm

      # Template: CustomerStatusView
      'of' => 'van',

      # Template: CustomerTicketMessage

      # Template: CustomerTicketMessageNew

      # Template: CustomerTicketSearch

      # Template: CustomerTicketSearchResultCSV

      # Template: CustomerTicketSearchResultPrint

      # Template: CustomerTicketSearchResultShort

      # Template: CustomerTicketZoom

      # Template: CustomerWarning

      # Template: Error
      'Click here to report a bug!' => 'Klik hier om een fout te rapporteren',

      # Template: FAQ
      'Comment (internal)' => 'Interne opmerking',
      'A article should have a title!' => 'Een artikel moet een titel hebben!',
      'New FAQ Article' => 'Nieuw FAQ artikel',
      'Do you really want to delete this Object?' => 'Weet u zeker dat u dit item wilt verwijderen?',
      'System History' => 'Systeem geschiedenis',

      # Template: FAQCategoryForm
      'Name is required!' => 'Naam is verplicht!',
      'FAQ Category' => 'FAQ categorie',

      # Template: FAQLanguageForm
      'FAQ Language' => 'FAQ taal',

      # Template: Footer
      'QueueView' => 'Wachtrijen',
      'PhoneView' => 'Telefoonscherm',
      'Top of Page' => 'Bovenkant pagina',

      # Template: FooterSmall

      # Template: Header
      'Home' => '',

      # Template: HeaderSmall

      # Template: Installer
      'Web-Installer' => '',
      'accept license' => '',
      'don\'t accept license' => '',
      'Admin-User' => '',
      'Admin-Password' => '',
      'your MySQL DB should have a root password! Default is empty!' => '',
      'Database-User' => '',
      'default \'hot\'' => '',
      'DB connect host' => '',
      'Database' => '',
      'Create' => '',
      'false' => '',
      'SystemID' => '',
      '(The identify of the system. Each ticket number and each http session id starts with this number)' => '',
      'System FQDN' => '',
      '(Full qualified domain name of your system)' => '',
      'AdminEmail' => 'Admin e-mail adres',
      '(Email of the system admin)' => '',
      'Organization' => '',
      'Log' => '',
      'LogModule' => '',
      '(Used log backend)' => '',
      'Logfile' => '',
      '(Logfile just needed for File-LogModule!)' => '',
      'Webfrontend' => '',
      'Default Charset' => '',
      'Use utf-8 it your database supports it!' => '',
      'Default Language' => '',
      '(Used default language)' => '',
      'CheckMXRecord' => '',
      '(Checks MX recordes of used email addresses by composing an answer. Don\'t use CheckMXRecord if your OTRS machine is behinde a dial-up line $!)' => '',
      'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' => '',
      'Restart your webserver' => '',
      'After doing so your OTRS is up and running.' => '',
      'Start page' => '',
      'Have a lot of fun!' => '',
      'Your OTRS Team' => '',

      # Template: Login

      # Template: Motd

      # Template: NoPermission
      'No Permission' => 'Geen rechten',

      # Template: Notify
      'Important' => 'Belangrijk',

      # Template: PrintFooter
      'URL' => '',

      # Template: PrintHeader
      'printed by' => 'afgedrukt door',

      # Template: Redirect

      # Template: SystemStats
      'Format' => '',

      # Template: Test
      'OTRS Test Page' => 'OTRS Testpagina',
      'Counter' => 'Teller',

      # Template: Warning
      # Misc
      'OTRS DB connect host' => '',
      'Create Database' => '',
      'DB Host' => '',
      'Ticket Number Generator' => '',
      '(Ticket identifier. Some people want toset this to e. g. \'Ticket#\', \'Call#\' or \'MyTicket#\')' => '',
      'In this way you can directly edit the keyring configured in Kernel/Config.pm.' => '',
      'Ticket Hook' => '',
      'Close!' => 'Sluit!',
      'TicketZoom' => 'Inhoud ticket',
      'Don\'t forget to add a new user to groups!' => 'Vergeet niet om groepen aan deze gebruiker toe te kennen!',
      'License' => '',
      'CreateTicket' => 'Ticket aanmaken',
      'OTRS DB Name' => '',
      'System Settings' => '',
      'Finished' => '',
      'Days' => '',
      'with' => '',
      'DB Admin User' => '',
      'Options of the ticket data (e. g. &lt;OTRS_TICKET_TicketNumber&gt;, &lt;OTRS_TICKET_TicketID&gt;, &lt;OTRS_TICKET_Queue&gt;, &lt;OTRS_TICKET_State&gt;)' => '',
      'Change user <-> group settings' => 'Wijzigen van gebruiker <-> groep toekenning',
      'DB Type' => '',
      'next step' => 'volgende stap',
      'FIXME: WHAT IS PGP?' => '',
      'My Queue' => 'Mijn wachtrij',
      'Create new database' => '',
      'Stunden' => '',
      'Delete old database' => '',
      'Load' => '',
      'OTRS DB User' => '',
      'FIXME: WHAT IS SMIME?' => '',
      'OTRS DB Password' => '',
      'DB Admin Password' => '',
      'Drop Database' => '',
      '(Used ticket number format)' => '',
      'FAQ History' => '',
      'Admin-Email' => 'Admin e-mail adres',
      'Package not correctly deployed, you need to deploy it again!' => '',
      'Customer called' => 'Klant gebeld',
      'Phone' => 'Telefoon',
      'Office' => '',
      'CompanyTickets' => 'Bedrijf Tickets',
      'MyTickets' => 'Mijn Tickets',
      'New Ticket' => '',
      'Create new Ticket' => '',
      'Package not correctly deployed, you need to deploy it again!' => '',
    };
    # $$STOP$$
}
# --
1;
