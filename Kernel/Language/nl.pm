# --
# Kernel/Language/nl.pm - provides nl language translation
# Copyright (C) 2002-2003 Fred van Dijk <fvandijk at marklin.nl>
# Maintenance responsibility taken over by Hans Bakker (h.bakker@a-net.nl)
# Copyright (C) 2003 A-NeT Internet Services bv
# Copyright (C) 2004 Martijn Lohmeijer (martijn.lohmeijer 'at' sogeti.nl)
# --
# $Id: nl.pm,v 1.32 2005-07-28 20:32:31 martin Exp $
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
$VERSION = '$Revision: 1.32 $';
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
      'No' => 'Geen',
      'yes' => 'ja',
      'no' => 'geen',
      'Off' => 'Uit',
      'off' => 'uit',
      'On' => 'Aan',
      'on' => 'aan',
      'top' => 'Bovenkant',
      'end' => 'Onderkant',
      'Done' => 'Klaar',
      'Cancel' => 'Annuleren',
      'Reset' => 'leegmaken',
      'last' => 'laatste',
      'before' => 'voor',
      'day' => 'dag',
      'days' => 'dagen',
      'day(s)' => 'dag(en)',
      'hour' => 'uur',
      'hours' => 'uren',
      'hour(s)' => '',
      'minute' => 'minuut',
      'minutes' => 'minuten',
      'minute(s)' => '',
      'month' => '',
      'months' => '',
      'month(s)' => 'maand(en)',
      'week' => '',
      'week(s)' => 'we(e)k(en)',
      'year' => '',
      'years' => '',
      'year(s)' => 'ja(a)r(en)',
      'wrote' => 'schreef',
      'Message' => 'Bericht',
      'Error' => 'Fout',
      'Bug Report' => 'Foutrapport',
      'Attention' => 'Let op',
      'Warning' => 'Waarschuwing',
      'Module' => '',
      'Modulefile' => 'Modulebestand',
      'Subfunction' => 'Sub-functie',
      'Line' => 'Regel',
      'Example' => 'Voorbeeld',
      'Examples' => 'Voorbeelden',
      'valid' => 'geldig',
      'invalid' => 'ongeldig',
      'invalid-temporarily' => '',
      ' 2 minutes' => ' 2 minuten',
      ' 5 minutes' => ' 5 minuten',
      ' 7 minutes' => ' 7 minuten',
      '10 minutes' => '10 minuten',
      '15 minutes' => '15 minuten',
      'Mr.' => '',
      'Mrs.' => '',
      'Next' => '',
      'Back' => 'Terug',
      'Next...' => '',
      '...Back' => '',
      '-none-' => '',
      'none' => 'geen',
      'none!' => 'niet ingevoerd!',
      'none - answered' => 'geen - beantwoord',
      'please do not edit!' => 'A.u.b. niet wijzigen!',
      'AddLink' => 'Link toevoegen',
      'Link' => '',
      'Linked' => '',
      'Link (Normal)' => '',
      'Link (Parent)' => '',
      'Link (Child)' => '',
      'Normal' => 'Normaal',
      'Parent' => '',
      'Child' => '',
      'Hit' => 'Gevonden',
      'Hits' => '',
      'Text' => 'Tekst',
      'Lite' => 'Licht',
      'User' => 'Gebruiker',
      'Username' => 'Gebruikersnaam',
      'Language' => 'Taal',
      'Languages' => 'Talen',
      'Password' => 'Wachtwoord',
      'Salutation' => 'Aanhef',
      'Signature' => 'Handtekening',
      'Customer' => 'Klant',
      'CustomerID' => 'KlantID',
      'CustomerIDs' => '',
      'customer' => 'klant',
      'agent' => '',
      'system' => 'systeem',
      'Customer Info' => 'Klant informatie',
      'go!' => 'start!',
      'go' => 'start',
      'All' => 'Alle',
      'all' => 'alle',
      'Sorry' => '',
      'update!' => 'wijzigen!',
      'update' => 'wijzigen',
      'Update' => 'Wijzigen',
      'submit!' => 'versturen!',
      'submit' => 'versturen',
      'Submit' => '',
      'change!' => 'wijzigen!',
      'Change' => 'Wijzigen',
      'change' => 'wijzigen',
      'click here' => 'klik hier',
      'Comment' => 'Commentaar',
      'Valid' => 'Geldig',
      'Invalid Option!' => '',
      'Invalid time!' => '',
      'Invalid date!' => '',
      'Name' => 'Naam',
      'Group' => 'Groep',
      'Description' => 'Omschrijving',
      'description' => 'omschrijving',
      'Theme' => 'Thema',
      'Created' => 'Gemaakt',
      'Created by' => '',
      'Changed' => '',
      'Changed by' => '',
      'Search' => 'Zoek',
      'and' => 'en',
      'between' => '',
      'Fulltext Search' => '',
      'Data' => '',
      'Options' => 'Opties',
      'Title' => 'Titel',
      'Item' => '',
      'Delete' => 'Verwijder',
      'Edit' => 'Wijzig',
      'View' => 'Weergave',
      'Number' => '',
      'System' => 'Systeem',
      'Contact' => '',
      'Contacts' => '',
      'Export' => '',
      'Up' => '',
      'Down' => '',
      'Add' => 'Toevoegen',
      'Category' => 'Categorie',
      'Viewer' => '',
      'New message' => 'Nieuw bericht',
      'New message!' => 'Nieuw bericht!',
      'Please answer this ticket(s) to get back to the normal queue view!' => 'A.u.b. geëscaleerde tickets beantwoorden om terug te komen in de normale wachtwij',
      'You got new message!' => 'U heeft een nieuw bericht!',
      'You have %s new message(s)!' => 'U heeft %s nieuwe bericht(en)!',
      'You have %s reminder ticket(s)!' => 'U heeft %s herinneringsticket(s)!',
      'The recommended charset for your language is %s!' => 'De aanbevolen karakterset voor uw taal is %s!',
      'Passwords dosn\'t match! Please try it again!' => 'Passwords komen niet overeen! Probeer het opnieuw!',
      'Password is already in use! Please use an other password!' => '',
      'Password is already used! Please use an other password!' => '',
      'You need to activate %s first to use it!' => '',
      'No suggestions' => 'Geen suggesties',
      'Word' => 'Woord',
      'Ignore' => 'Negeren',
      'replace with' => 'vervangen met',
      'Welcome to OTRS' => 'Welkom bij OTRS',
      'There is no account with that login name.' => 'Er is geen account met deze gebruikersnaam',
      'Login failed! Your username or password was entered incorrectly.' => 'Aanmelden mislukt. Uw gebruikersnaam of wachtwoord is onjuist.',
      'Please contact your admin' => 'Vraag uw systeembeheerder',
      'Logout successful. Thank you for using OTRS!' => 'Afgemeld! Wij danken u voor het gebruiken van OTRS!',
      'Invalid SessionID!' => 'Ongeldige SessieID',
      'Feature not active!' => 'Functie niet actief!',
      'Take this Customer' => 'Selecteer deze klant',
      'Take this User' => 'Selecteer deze gebruiker',
      'possible' => 'mogelijk',
      'reject' => 'afwijzen',
      'Facility' => '',
      'Timeover' => '',
      'Pending till' => 'In wachtstand tot',
      'Don\'t work with UserID 1 (System account)! Create new users!' => 'Werk niet met User# 1 (systeem account)! Maak nieuwe gebruikers aan',
      'Dispatching by email To: field.' => 'Versturen per email Aan: veld.',
      'Dispatching by selected Queue.' => 'Versturen per geselecteerde wachtrij',
      'No entry found!' => 'Niets gevonden!',
      'Session has timed out. Please log in again.' => 'Sessie is verlopen. Opnieuw inloggen AUB.',
      'No Permission!' => 'Geen toegang! Onvoldoende rechten.',
      'To: (%s) replaced with database email!' => 'Aan: (%s) vervangen met database email!',
      'Cc: (%s) added database email!' => '',
      '(Click here to add)' => '(Klik hier om toe te voegen)',
      'Preview' => '',
      'Added User "%s"' => 'Gebruiker "%s" toegevoegd.',
      'Contract' => '',
      'Online Customer: %s' => 'Online klant: %s',
      'Online Agent: %s' => '',
      'Calendar' => 'Kalender',
      'File' => '',
      'Filename' => 'Bestandsnaam',
      'Type' => '',
      'Size' => 'Grootte',
      'Upload' => '',
      'Directory' => '',
      'Signed' => '',
      'Sign' => '',
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
      'Agent-Area' => '',
      'Ticket-Area' => '',
      'Logout' => 'Uitloggen',
      'Agent Preferences' => '',
      'Preferences' => 'Voorkeuren',
      'Agent Mailbox' => '',
      'Stats' => 'Statistieken',
      'Stats-Area' => '',
      'FAQ-Area' => '',
      'FAQ' => '',
      'FAQ-Search' => '',
      'FAQ-Article' => '',
      'New Article' => 'Nieuw artikel',
      'FAQ-State' => '',
      'Admin' => '',
      'A web calendar' => '',
      'WebMail' => '',
      'A web mail client' => '',
      'FileManager' => '',
      'A web file manager' => '',
      'Artefact' => '',
      'Incident' => '',
      'Advisory' => '',
      'WebWatcher' => '',
      'Customer Users' => '',
      'Customer Users <-> Groups' => '',
      'Users <-> Groups' => '',
      'Roles' => '',
      'Roles <-> Users' => '',
      'Roles <-> Groups' => '',
      'Salutations' => '',
      'Signatures' => '',
      'Email Addresses' => '',
      'Notifications' => '',
      'Category Tree' => '',
      'Admin Notification' => '',

      # Template: AAAPreferences
      'Preferences updated successfully!' => 'Voorkeuren zijn gewijzigd!',
      'Mail Management' => 'Mail beheer',
      'Frontend' => 'Voorkant',
      'Other Options' => 'Overige opties',
      'Change Password' => '',
      'New password' => '',
      'New password again' => '',
      'Select your QueueView refresh time.' => 'Verversingstijd kiezen',
      'Select your frontend language.' => 'Kies een taal',
      'Select your frontend Charset.' => 'Karakterset kiezen',
      'Select your frontend Theme.' => 'thema kiezen',
      'Select your frontend QueueView.' => 'Wachtrij weergave kiezen',
      'Spelling Dictionary' => 'Spelling bibliotheek',
      'Select your default spelling dictionary.' => 'Selekteer uw standaard spellingsbibliotheek.',
      'Max. shown Tickets a page in Overview.' => 'Max. getoonde tickets per pagina in overzichtsscherm.',
      'Can\'t update password, passwords dosn\'t match! Please try it again!' => '',
      'Can\'t update password, invalid characters!' => '',
      'Can\'t update password, need min. 8 characters!' => '',
      'Can\'t update password, need 2 lower and 2 upper characters!' => '',
      'Can\'t update password, need min. 1 digit!' => '',
      'Can\'t update password, need min. 2 characters!' => '',
      'Password is needed!' => '',

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
      'This is a HTML email. Click here to show it.' => '',
      'Free Fields' => '',
      'Merge' => '',
      'closed successful' => 'succesvol gesloten',
      'closed unsuccessful' => 'niet succesvol gesloten',
      'new' => 'nieuw',
      'open' => '',
      'closed' => 'geschlossen',
      'removed' => 'verwijderd',
      'pending reminder' => 'Herinnering voor wachtend',
      'pending auto close+' => 'Wachtend op automatisch sluiten+',
      'pending auto close-' => 'Wachtend op automatisch sluiten-',
      'email-external' => 'E-mail naar extern',
      'email-internal' => 'E-mail naar intern',
      'note-external' => 'externe notitie',
      'note-internal' => 'interne notitie',
      'note-report' => 'Notitie rapportage',
      'phone' => 'telefoon',
      'sms' => '',
      'webrequest' => 'Verzoek via web',
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
      'Ticket Number' => '',
      'Ticket Object' => '',
      'No such Ticket Number "%s"! Can\'t link it!' => 'Ticketnummer "%s" niet gevonden! Kan niet gelinkt worden!',
      'Don\'t show closed Tickets' => 'Gesloten tickets niet tonen',
      'Show closed Tickets' => 'Gesloten tickets tonen',
      'Email-Ticket' => '',
      'Create new Email Ticket' => '',
      'Phone-Ticket' => '',
      'Create new Phone Ticket' => '',
      'Search Tickets' => '',
      'Edit Customer Users' => '',
      'Bulk-Action' => '',
      'Bulk Actions on Tickets' => '',
      'Send Email and create a new Ticket' => '',
      'Overview of all open Tickets' => '',
      'Locked Tickets' => '',
      'Lock it to work on it!' => '',
      'Unlock to give it back to the queue!' => '',
      'Shows the ticket history!' => '',
      'Print this ticket!' => '',
      'Change the ticket priority!' => '',
      'Change the ticket free fields!' => '',
      'Link this ticket to an other objects!' => '',
      'Change the ticket owner!' => '',
      'Change the ticket customer!' => '',
      'Add a note to this ticket!' => '',
      'Merge this ticket!' => '',
      'Set this ticket to pending!' => '',
      'Close this ticket!' => '',
      'Look into a ticket!' => '',
      'Delete this ticket!' => '',
      'Mark as Spam!' => '',
      'My Queues' => '',
      'Shown Tickets' => '',
      'New ticket notification' => 'Bericht bij een nieuw ticket',
      'Send me a notification if there is a new ticket in "My Queues".' => 'Stuur mij een bericht als er een nieuw ticket in mijn aangepaste wachtrij komt.',
      'Follow up notification' => 'Bericht bij vervolgvragen',
      'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.' => 'Stuur een bericht als een klant een vervolgvraag stelt en ik de eigenaar van het ticket ben.',
      'Ticket lock timeout notification' => 'Bericht van tijdsoverschreiding van een vergrendeling',
      'Send me a notification if a ticket is unlocked by the system.' => 'Stuur  me een bericht als een ticket wordt ontgrendeld door het systeem.',
      'Move notification' => 'Bericht bij het verplaatsen',
      'Send me a notification if a ticket is moved into one of "My Queues".' => ' Stuur mij een bericht als een bericht wordt verplaatst in een aangepaste wachtrij',
      'Your queue selection of your favorite queues. You also get notified about this queues via email if enabled.' => '',
      'Custom Queue' => 'Aangepaste wachtrij',
      'QueueView refresh time' => 'Verversingstijd wachtrij',
      'Screen after new ticket' => 'Scherm na een nieuw ticket',
      'Select your screen after creating a new ticket.' => 'Selecteer het vervolgscherm na het invoeren van een nieuw ticket',
      'Closed Tickets' => 'Afgesloten tickets',
      'Show closed tickets.' => 'Gesloten tickets tonen',
      'Max. shown Tickets a page in QueueView.' => 'Max. getoonde tickets per pagina in wachtrijscherm',
      'Responses' => 'Antwoorden',
      'Responses <-> Queue' => '',
      'Auto Responses' => '',
      'Auto Responses <-> Queue' => '',
      'Attachments <-> Responses' => '',
      'History::Move' => 'Ticket verplaatst naar wachtrij "%s" (%s) van wachtrij "%s" (%s).',
      'History::NewTicket' => 'Nieuw ticket [%s] aangemaakt (Q=%s;P=%s;S=%s).',
      'History::FollowUp' => 'FollowUp voor [%s]. %s',
      'History::SendAutoReject' => 'AutoReject verstuurd aan "%s".',
      'History::SendAutoReply' => 'AutoReply verstuurd aan "%s".',
      'History::SendAutoFollowUp' => 'AutoFollowUp verstuurd aan "%s".',
      'History::Forward' => 'Doorgestuurd aan "%s".',
      'History::Bounce' => 'Bounced naar "%s".',
      'History::SendAnswer' => 'Email verstuurd aan "%s".',
      'History::SendAgentNotification' => '"%s"-notificatie verstuurd aan "%s".',
      'History::SendCustomerNotification' => 'Notificatie verstuurd aan "%s".',
      'History::EmailAgent' => 'Mail verzonden aan klant.',
      'History::EmailCustomer' => 'Email toegevoegd. %s',
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
      'History::WebRequestCustomer' => 'Klant stelt vraag via web.',
      'History::TicketLinkAdd' => 'Link naar "%s" toegevoegd.',
      'History::TicketLinkDelete' => 'Link naar "%s" toegevoegd.',

      # Template: AAAWeekDay
      'Sun' => 'zon',
      'Mon' => 'maa',
      'Tue' => 'din',
      'Wed' => 'woe',
      'Thu' => 'don',
      'Fri' => 'vrij',
      'Sat' => 'zat',

      # Template: AdminAttachmentForm
      'Attachment Management' => 'Bijlage beheer',

      # Template: AdminAutoResponseForm
      'Auto Response Management' => 'Autoreply beheer',
      'Response' => 'Antwoord',
      'Auto Response From' => 'Autoreply Van',
      'Note' => 'Notitie',
      'Useable options' => '',
      'to get the first 20 character of the subject' => 'voor de eerste 20 tekens van het onderwerp',
      'to get the first 5 lines of the email' => '',
      'to get the from line of the email' => 'voor de Van: kop',
      'to get the realname of the sender (if given)' => 'voor de echte naam van de afzender (indien beschikbaar)',
      'Options of the ticket data (e. g. &lt;OTRS_TICKET_Number&gt;, &lt;OTRS_TICKET_ID&gt;, &lt;OTRS_TICKET_Queue&gt;, &lt;OTRS_TICKET_State&gt;)' => '',

      # Template: AdminCustomerUserForm
      'The message being composed has been closed.  Exiting.' => 'Het bericht dat werd aangemaakt is gesloten.',
      'This window must be called from compose window' => 'Dit scherm moet van het scherm opstellen worden aangeroepen',
      'Customer User Management' => 'Userbeheer klanten',
      'Search for' => 'Zoek naar',
      'Result' => 'Resultaat',
      'Select Source (for add)' => 'Selecteer bron (voor toevoegen)',
      'Source' => 'Bron',
      'This values are read only.' => '',
      'This values are required.' => 'Deze waarden zijn verplicht',
      'Customer user will be needed to have an customer histor and to to login via customer panels.' => 'Klanten moeten een klanthistorie hebben en inloggen via de klantschermen',

      # Template: AdminCustomerUserGroupChangeForm
      'Customer Users <-> Groups Management' => '',
      'Change %s settings' => 'Wijzig instellingen voor %s',
      'Select the user:group permissions.' => 'Selecteer de gebruiker/groep rechten',
      'If nothing is selected, then there are no permissions in this group (tickets will not be available for the user).' => 'Als er geen selectie is gemaakt dan zijn er geen rechten voor deze groep (tickets zullen die beschikbaar zijn voor de gebruiker).',
      'Permission' => 'Rechten',
      'ro' => '',
      'Read only access to the ticket in this group/queue.' => 'Leesrechten op het ticket in deze groep/wachtrij',
      'rw' => '',
      'Full read and write access to the tickets in this group/queue.' => 'Volledige lees- en schrijfrechten op de tickets in deze groep/wachtrij',

      # Template: AdminCustomerUserGroupForm

      # Template: AdminEmail
      'Message sent to' => 'Bericht verstuurd naar',
      'Recipents' => 'Ontvangers',
      'Body' => 'berichttekst',
      'send' => 'verstuur',

      # Template: AdminGenericAgent
      'GenericAgent' => '',
      'Job-List' => '',
      'Last run' => '',
      'Run Now!' => '',
      'x' => '',
      'Save Job as?' => '',
      'Is Job Valid?' => '',
      'Is Job Valid' => '',
      'Schedule' => '',
      'Fulltext-Search in Article (e. g. "Mar*in" or "Baue*")' => 'Fulltext-Search in artikel (b.v. "Mar*in" of "Baue*")',
      '(e. g. 10*5155 or 105658*)' => '(b.v. 10*5155 or 105658*)',
      '(e. g. 234321)' => '(b.v. 234321)',
      'Customer User Login' => 'Klant login',
      '(e. g. U5150)' => '(b.v. U5150)',
      'Agent' => '',
      'TicketFreeText' => '',
      'Ticket Lock' => '',
      'Times' => 'Malen',
      'No time settings.' => 'Geen tijdinstellingen',
      'Ticket created' => 'Ticket aangemaakt',
      'Ticket created between' => 'Ticket aangemaakt tussen',
      'New Priority' => '',
      'New Queue' => 'Nieuwe wachtrij',
      'New State' => '',
      'New Agent' => '',
      'New Owner' => 'Nieuwe eigenaar',
      'New Customer' => '',
      'New Ticket Lock' => '',
      'CustomerUser' => '',
      'Add Note' => 'Notitie toevoegen',
      'CMD' => '',
      'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' => '',
      'Delete tickets' => '',
      'Warning! This tickets will be removed from the database! This tickets are lost!' => '',
      'Modules' => '',
      'Param 1' => '',
      'Param 2' => '',
      'Param 3' => '',
      'Param 4' => '',
      'Param 5' => '',
      'Param 6' => '',
      'Save' => '',

      # Template: AdminGroupForm
      'Group Management' => 'Groepenbeheer',
      'The admin group is to get in the admin area and the stats group to get stats area.' => 'Leden van de admingroep mogen in het administratiegedeelte, leden van de Stats groep hebben toegang tot het statistiekgedeelte.',
      'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).' => 'Maak nieuwe groepen om toegangsrechten te regelen voor verschillende groepen van agenten (bijv. verkoopafdeling, supportafdeling, enz. enz.).',
      'It\'s useful for ASP solutions.' => 'Zeer bruikbaar voor ASP-oplossingen.',

      # Template: AdminLog
      'System Log' => 'Systeem logboek',
      'Time' => '',

      # Template: AdminNavigationBar
      'Users' => '',
      'Groups' => 'Groepen',
      'Misc' => 'Overige',

      # Template: AdminNotificationForm
      'Notification Management' => 'Notificatie beheer',
      'Notification' => '',
      'Notifications are sent to an agent or a customer.' => 'Notificaties worden verstuurd naar een agent of een klant',
      'Config options (e. g. &lt;OTRS_CONFIG_HttpType&gt;)' => 'Config opties (b.v. &lt;OTRS_CONFIG_HttpType&gt;)',
      'Ticket owner options (e. g. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)' => 'Opties voor de ticketeigenaar (b.v. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)',
      'Options of the current user who requested this action (e. g. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)' => 'Opties van de user die deze actie heeft aangevraagd (b.v. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)',
      'Options of the current customer user data (e. g. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)' => 'Opties van de huidige user data van de klant (b.v. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)',

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
      'POP3 Account Management' => 'POP3 account-beheer',
      'Host' => 'Server',
      'Trusted' => 'Te vertrouwen',
      'Dispatching' => '',
      'All incoming emails with one account will be dispatched in the selected queue!' => 'Alle binnenkomende e-mail\'s in een account zullen worden geplaatst in de geselecteerde wachtrij',
      'If your account is trusted, the already existing x-otrs header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' => '',

      # Template: AdminPostMasterFilter
      'PostMaster Filter Management' => '',
      'Filtername' => '',
      'Match' => '',
      'Header' => '',
      'Value' => 'Waarde',
      'Set' => '',
      'Do dispatch or filter incoming emails based on email X-Headers! RegExp is also possible.' => '',
      'If you use RegExp, you also can use the matched value in () as [***] in \'Set\'.' => '',

      # Template: AdminQueueAutoResponseForm
      'Queue <-> Auto Responses Management' => '',

      # Template: AdminQueueAutoResponseTable

      # Template: AdminQueueForm
      'Queue Management' => 'Wachtrijbeheer',
      'Sub-Queue of' => 'onder-wachtrij van',
      'Unlock timeout' => 'Vrijgave tijdoverschrijding',
      '0 = no unlock' => '0 = geen ontgrendeling',
      'Escalation time' => 'Escalatietijd',
      '0 = no escalation' => '0 = geen escalatie',
      'Follow up Option' => 'Follow up optie',
      'Ticket lock after a follow up' => 'Ticket-vergrendeling na een follow up',
      'Systemaddress' => 'Systeem-adres',
      'Customer Move Notify' => 'Klant notificatie bij verplaatsen',
      'Customer State Notify' => 'Klant notificatie andere status',
      'Customer Owner Notify' => 'Klant notificatie andere eigenaar',
      'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.' => 'Wanneer een agent een ticket vergrendeld en hij/zij stuurt geen antwoord binnen deze tijd dan zal het ticket automatisch ontgrendeld worden. Het ticket kan dan door andere agenten worden ingezien.',
      'If a ticket will not be answered in thos time, just only this ticket will be shown.' => 'Als een ticket niet binnen deze tijd is beantwoord zal alleen dit ticket worden getoond',
      'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.' => 'Wanneer een ticket wordt gesloten and de klant stuurt een follow-up wordt het ticket vergrendeld door de oude eigenaar',
      'Will be the sender address of this queue for email answers.' => 'is het afzenderadres van deze wachtrij voor antwoorden per e-mail',
      'The salutation for email answers.' => 'De aanhef voor antwoorden per e-mail.',
      'The signature for email answers.' => 'De handtekening voor antwoorden per e-mail.',
      'OTRS sends an notification email to the customer if the ticket is moved.' => 'OTRS stuurt een notificatie e-mail naar de klant wanneer het ticket wordt verplaatst.',
      'OTRS sends an notification email to the customer if the ticket state has changed.' => 'OTRS stuurt een notificatie e-mail naar de klant wanneer de status is veranderd',
      'OTRS sends an notification email to the customer if the ticket owner has changed.' => 'OTRS stuurt een notificatie e-mail naar de klant wanneer de eigenaar is veranderd',

      # Template: AdminQueueResponsesChangeForm
      'Responses <-> Queue Management' => '',

      # Template: AdminQueueResponsesForm
      'Answer' => 'Antwoord',

      # Template: AdminResponseAttachmentChangeForm
      'Responses <-> Attachments Management' => '',

      # Template: AdminResponseAttachmentForm

      # Template: AdminResponseForm
      'Response Management' => 'Antwoordbeheer',
      'A response is default text to write faster answer (with default text) to customers.' => 'Een antworord is een standaard-tekst om sneller antwoorden te kunnen opstellen.',
      'Don\'t forget to add a new response a queue!' => 'Vergeet niet om een antwoord aan de wachtrij toe te kennen!',
      'Next state' => 'Volgende status',
      'All Customer variables like defined in config option CustomerUser.' => 'Alle klantvariabelen zoals vastgelegd in de configuratieoptie Klantgebruiker.',
      'The current ticket state is' => 'De huidige ticketstatus is',
      'Your email address is new' => 'Uw e-mail adres is nieuw',

      # Template: AdminRoleForm
      'Role Management' => '',
      'Create a role and put groups in it. Then add the role to the users.' => '',
      'It\'s useful for a lot of users and groups.' => '',

      # Template: AdminRoleGroupChangeForm
      'Roles <-> Groups Management' => '',
      'move_into' => 'verplaats naar',
      'Permissions to move tickets into this group/queue.' => 'Rechten om tickets naar deze groep/wachtrij te verplaatsen',
      'create' => 'Aanmaken',
      'Permissions to create tickets in this group/queue.' => 'Rechten om tickets in deze groep/wachtrij aan te maken',
      'owner' => 'eigenaar',
      'Permissions to change the ticket owner in this group/queue.' => 'Rechten om de ticketeigenaar in deze groep/wachtrij te wijzigen',
      'priority' => 'prioriteit',
      'Permissions to change the ticket priority in this group/queue.' => 'Rechten om de prioriteit van een ticket in deze groep/wachtrij te wijzigen',

      # Template: AdminRoleGroupForm
      'Role' => '',

      # Template: AdminRoleUserChangeForm
      'Roles <-> Users Management' => '',
      'Active' => '',
      'Select the role:user relations.' => '',

      # Template: AdminRoleUserForm

      # Template: AdminSalutationForm
      'Salutation Management' => 'Aanhef beheer',
      'customer realname' => 'echte klantnaam',
      'for agent firstname' => 'voornaam van agent',
      'for agent lastname' => 'achternaam van agent',
      'for agent user id' => 'de loginnaam van de agent ',
      'for agent login' => 'de login van de agent',

      # Template: AdminSelectBoxForm
      'Select Box' => 'SQL select query',
      'SQL' => '',
      'Limit' => 'Beperk',
      'Select Box Result' => 'keuzekader resultaat',

      # Template: AdminSession
      'Session Management' => 'Sessiebeheer',
      'Sessions' => '',
      'Uniq' => '',
      'kill all sessions' => 'Alle sessies afsluiten',
      'Session' => '',
      'kill session' => 'Sessie afsluiten',

      # Template: AdminSignatureForm
      'Signature Management' => 'handtekeningbeheer',

      # Template: AdminSMIMEForm
      'SMIME Management' => '',
      'Add Certificate' => '',
      'Add Private Key' => '',
      'Secret' => '',
      'Hash' => '',
      'In this way you can directly edit the certification and private keys in file system.' => '',

      # Template: AdminStateForm
      'System State Management' => 'Systeem-status beheer',
      'State Type' => 'Status Type',
      'Take care that you also updated the default states in you Kernel/Config.pm!' => 'Bewaak dat u ook de default statussen in uw Kernel/Config.pm bijwerkt!',
      'See also' => 'Zie ook',

      # Template: AdminSysConfig
      'SysConfig' => '',
      'Group selection' => '',
      'Show' => '',
      'Download Settings' => '',
      'Download all system config changes.' => '',
      'Load Settings' => '',
      'Subgroup' => '',
      'Elements' => '',

      # Template: AdminSysConfigEdit
      'Config Options' => '',
      'Default' => '',
      'Content' => '',
      'New' => 'Nieuw',
      'New Group' => '',
      'Group Ro' => '',
      'New Group Ro' => '',
      'NavBarName' => '',
      'Image' => '',
      'Prio' => '',
      'Block' => '',
      'NavBar' => '',
      'AccessKey' => '',

      # Template: AdminSystemAddressForm
      'System Email Addresses Management' => 'Systeem E-mailadressen beheer',
      'Email' => '',
      'Realname' => 'Echte naam',
      'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!' => 'Alle binnenkomende emails met deze "To:" worden in de gekozen wachtrij geplaatst.',

      # Template: AdminUserForm
      'User Management' => 'Gebruikersbeheer',
      'Firstname' => 'Voornaam',
      'Lastname' => 'Achternaam',
      'User will be needed to handle tickets.' => 'Gebruikers zijn nodig om tickets te behandelen.',
      'Don\'t forget to add a new user to groups and/or roles!' => '',

      # Template: AdminUserGroupChangeForm
      'Users <-> Groups Management' => '',

      # Template: AdminUserGroupForm

      # Template: AgentBook
      'Address Book' => 'Adresboek',
      'Return to the compose screen' => 'Terug naar berichtscherm',
      'Discard all changes and return to the compose screen' => 'Veranderingen niet toepassen en ga terug naar het berichtscherm',

      # Template: AgentCalendarSmall

      # Template: AgentCalendarSmallIcon

      # Template: AgentCustomerTableView

      # Template: AgentInfo
      'Info' => 'Informatie',

      # Template: AgentLinkObject
      'Link Object' => '',
      'Select' => 'Selecteer',
      'Results' => 'Resultaten',
      'Total hits' => 'Totaal gevonden',
      'Site' => '',
      'Detail' => '',

      # Template: AgentLookup
      'Lookup' => '',

      # Template: AgentNavigationBar
      'Ticket selected for bulk action!' => 'Ticket geselecteerd voor bulk aktie!',
      'You need min. one selected Ticket!' => '',

      # Template: AgentPreferencesForm

      # Template: AgentSpelling
      'Spell Checker' => 'Spellingscontrole',
      'spelling error(s)' => 'Spelfout(en)',
      'or' => 'of',
      'Apply these changes' => 'Pas deze wijzigingen toe',

      # Template: AgentTicketBounce
      'A message should have a To: recipient!' => 'Een bericht moet een ontvanger (aan:) hebben!',
      'You need a email address (e. g. customer@example.com) in To:!' => 'In het Aan-veld is een E-mail adres nodig!',
      'Bounce ticket' => '',
      'Bounce to' => 'Bounce naar',
      'Next ticket state' => 'Volgende status van het ticket',
      'Inform sender' => 'Informeer afzender',
      'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further informations.' => 'Je email met ticket nummer "<OTRS_TICKET>" is gebounced naar "<OTRS_BOUNCE_TO>". Contacteer dit adres voor meer informatie.',
      'Send mail!' => 'bericht versturen!',

      # Template: AgentTicketBulk
      'A message should have a subject!' => 'Een bericht moet een onderwerp hebben!',
      'Ticket Bulk Action' => 'Ticket Bulk Aktie',
      'Spell Check' => 'Spellingscontrole',
      'Note type' => 'Notitietype',
      'Unlock Tickets' => '',

      # Template: AgentTicketClose
      'A message should have a body!' => 'Een bericht moet een berichttekst hebben!',
      'You need to account time!' => 'Het is verplicht tijd te verantwoorden!',
      'Close ticket' => 'Sluit ticket',
      'Note Text' => 'Notitietekst',
      'Close type' => 'Sluit-type',
      'Time units' => 'Tijdseenheden',
      ' (work units)' => '(werk eenheden)',

      # Template: AgentTicketCompose
      'A message must be spell checked!' => 'Van een bericht moet de spelling gecontroleerd worden',
      'Compose answer for ticket' => 'Bericht opstellen voor',
      'Attach' => 'Bijlage',
      'Pending Date' => 'Nog hangende datum',
      'for pending* states' => 'voor nog hangende* statussen',

      # Template: AgentTicketCustomer
      'Change customer of ticket' => 'Wijzig klant van een ticket',
      'Set customer user and customer id of a ticket' => 'Wijs de klantgebruiker en klantID van een ticket toe',
      'Customer User' => 'Klant beheer',
      'Search Customer' => 'Klanten zoeken',
      'Customer Data' => 'Klantgegevens',
      'Customer history' => 'Klantgeschiedenis',
      'All customer tickets.' => 'Alle klanttickets',

      # Template: AgentTicketCustomerMessage
      'Follow up' => '',

      # Template: AgentTicketEmail
      'Compose Email' => 'E-mail opstellen',
      'new ticket' => 'nieuw ticket',
      'Clear To' => '',
      'All Agents' => 'Alle agents',
      'Termin1' => '',

      # Template: AgentTicketForward
      'Article type' => 'Artikel-type',

      # Template: AgentTicketFreeText
      'Change free text of ticket' => 'Verander de vrije tekstvelden van een bericht',

      # Template: AgentTicketHistory
      'History of' => 'Geschiedenis van',

      # Template: AgentTicketLocked
      'Ticket locked!' => 'Ticket vergrendeld!',
      'Ticket unlock!' => 'Ticket ontgrendeld!',

      # Template: AgentTicketMailbox
      'Mailbox' => 'Postbus',
      'Tickets' => '',
      'All messages' => 'Alle berichten',
      'New messages' => 'Nieuwe berichten',
      'Pending messages' => 'wachtende berichten',
      'Reminder messages' => 'Herinneringsberichten',
      'Reminder' => 'Herinnering',
      'Sort by' => 'Sorteer volgens',
      'Order' => 'Volgorde',
      'up' => 'naar boven',
      'down' => 'naar beneden',

      # Template: AgentTicketMerge
      'You need to use a ticket number!' => '',
      'Ticket Merge' => '',
      'Merge to' => '',
      'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' => '',

      # Template: AgentTicketMove
      'Queue ID' => 'WachtrijID',
      'Move Ticket' => 'Verplaats Bericht',
      'Previous Owner' => 'Vorige eigenaar',

      # Template: AgentTicketNote
      'Add note to ticket' => 'Notitie toevoegen aan ticket',
      'Inform Agent' => '',
      'Optional' => '',
      'Inform involved Agents' => '',

      # Template: AgentTicketOwner
      'Change owner of ticket' => 'Wijzig eigenaar van ticket',
      'Message for new Owner' => 'Bericht voor nieuwe eigenaar',

      # Template: AgentTicketPending
      'Set Pending' => 'Zet wachtend',
      'Pending type' => 'Wachtend: type',
      'Pending date' => 'Wachtend: datum',

      # Template: AgentTicketPhone
      'Phone call' => 'Telefoongesprek',

      # Template: AgentTicketPhoneNew
      'Clear From' => 'Wis Van',

      # Template: AgentTicketPlain
      'Plain' => 'Zonder opmaak',
      'TicketID' => '',
      'ArticleID' => 'ArtikelID',

      # Template: AgentTicketPrint
      'Ticket-Info' => '',
      'Accounted time' => 'Geregistreerde tijd',
      'Escalation in' => 'Escalatie om',
      'Linked-Object' => '',
      'Parent-Object' => '',
      'Child-Object' => '',
      'by' => 'door',

      # Template: AgentTicketPriority
      'Change priority of ticket' => 'Prioriteit wijzigen voor ticket',

      # Template: AgentTicketQueue
      'Tickets shown' => 'Tickets getoond',
      'Page' => 'Pagina',
      'Tickets available' => 'Tickets beschikbaar',
      'All tickets' => 'Alle tickets',
      'Queues' => 'Wachtrij',
      'Ticket escalation!' => 'Ticket escalatie!',

      # Template: AgentTicketQueueTicketView
      'Your own Ticket' => 'Je eigen ticket',
      'Compose Follow up' => 'Follow up aanmaken',
      'Compose Answer' => 'Antwoord opstellen',
      'Contact customer' => 'Klant contacteren',
      'Change queue' => 'Wachtrij wisselen',

      # Template: AgentTicketQueueTicketViewLite

      # Template: AgentTicketSearch
      'Ticket Search' => 'Zoek ticket',
      'Profile' => 'Profiel',
      'Search-Template' => 'Zoektemplate',
      'Created in Queue' => '',
      'Result Form' => 'Resultaatformulier',
      'Save Search-Profile as Template?' => 'Zoekprofiel als template bewaren ?',
      'Yes, save it with name' => 'Ja, sla op met naam',
      'Customer history search' => 'zoeken in klantgeschiednis',
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
      'Split' => 'splitsing',

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
      'modified' => '',
      'FAQ Search' => '',
      'Fulltext' => '',
      'Keyword' => '',
      'FAQ Search Result' => 'FAQ zoekresultaat',
      'FAQ Overview' => '',

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
      'New FAQ Article' => '',
      'Do you really want to delete this Object?' => '',
      'System History' => '',

      # Template: FAQCategoryForm
      'Name is required!' => 'Naam is verplicht!',
      'FAQ Category' => 'FAQ Categorie',

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
      'Important' => '',

      # Template: PrintFooter
      'URL' => '',

      # Template: PrintHeader
      'printed by' => 'afgedrukt door',

      # Template: Redirect

      # Template: SystemStats
      'Format' => '',

      # Template: Test
      'OTRS Test Page' => 'OTRS Testpagina',
      'Counter' => '',

      # Template: Warning
      # Misc
      '(Ticket identifier. Some people want toset this to e. g. \'Ticket#\', \'Call#\' or \'MyTicket#\')' => '',
      'Close!' => 'Sluit!',
      'TicketZoom' => 'Inhoud ticket',
      'Don\'t forget to add a new user to groups!' => 'Vergeet niet om groepen aan deze gebruiker toe te kennen!',
      'CreateTicket' => 'Ticket aanmaken',
      'Options of the ticket data (e. g. &lt;OTRS_TICKET_TicketNumber&gt;, &lt;OTRS_TICKET_TicketID&gt;, &lt;OTRS_TICKET_Queue&gt;, &lt;OTRS_TICKET_State&gt;)' => '',
      'Change user <-> group settings' => 'Wijzigen van gebruiker <-> groep toekenning',
      'next step' => 'volgende stap',
      'Admin-Email' => 'Admin e-mail adres',
    };
    # $$STOP$$
}
# --
1;
