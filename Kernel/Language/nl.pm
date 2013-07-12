# --
# Kernel/Language/nl.pm - provides nl language translation
# Copyright (C) 2002-2003 Fred van Dijk <fvandijk at marklin.nl>
# Copyright (C) 2003 A-NeT Internet Services bv Hans Bakker <h.bakker at a-net.nl>
# Copyright (C) 2004 Martijn Lohmeijer <martijn.lohmeijer 'at' sogeti.nl>
# Copyright (C) 2005-2007 Jurgen Rutgers <jurgen 'at' besite.nl>
# Copyright (C) 2005-2007 Richard Hinkamp <richard 'at' besite.nl>
# Copyright (C) 2010 Ton van Boven <ton 'at' avebo.nl>
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::nl;

use strict;
use warnings;

sub Data {
    my $Self = shift;

    # $$START$$
    # Last translation file sync: 2013-06-14 08:49:41

    # possible charsets
    $Self->{Charset} = ['utf-8', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Year;)
    $Self->{DateFormat}          = '%D-%M-%Y %T';
    $Self->{DateFormatLong}      = '%A %D %B %Y %T';
    $Self->{DateFormatShort}     = '%D-%M-%Y';
    $Self->{DateInputFormat}     = '%D-%M-%Y';
    $Self->{DateInputFormatLong} = '%D-%M-%Y - %T';

    # csv separator
    $Self->{Separator} = ';';

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
        'Today' => 'Vandaag',
        'Tomorrow' => 'Morgen',
        'Next week' => 'Volgende week',
        'day' => 'dag',
        'days' => 'dagen',
        'day(s)' => 'dag(en)',
        'd' => 'd',
        'hour' => 'uur',
        'hours' => 'uur',
        'hour(s)' => 'uur',
        'Hours' => 'Uren',
        'h' => 'u',
        'minute' => 'minuut',
        'minutes' => 'minuten',
        'minute(s)' => 'minuten',
        'Minutes' => 'Minuten',
        'm' => 'm',
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
        's' => 's',
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
        'Valid' => 'Geldigheid',
        'invalid' => 'ongeldig',
        'Invalid' => 'Ongeldig',
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
        'none!' => 'niet ingevoerd',
        'none - answered' => 'geen - beantwoord',
        'please do not edit!' => 'niet wijzigen alstublieft!',
        'Need Action' => 'Actie nodig',
        'AddLink' => 'Koppeling toevoegen',
        'Link' => 'Koppel',
        'Unlink' => 'Ontkoppel',
        'Linked' => 'Gekoppeld',
        'Link (Normal)' => 'Koppeling (normaal)',
        'Link (Parent)' => 'Koppeling (vader)',
        'Link (Child)' => 'Koppeling (zoon)',
        'Normal' => 'Normaal',
        'Parent' => 'vader',
        'Child' => 'zoon',
        'Hit' => 'Hit',
        'Hits' => 'Hits',
        'Text' => 'Tekst',
        'Standard' => 'Standaard',
        'Lite' => 'Light',
        'User' => 'Gebruiker',
        'Username' => 'Gebruikersnaam',
        'Language' => 'Taal',
        'Languages' => 'Talen',
        'Password' => 'Wachtwoord',
        'Preferences' => 'Voorkeuren',
        'Salutation' => 'Aanhef',
        'Salutations' => 'Aanheffen',
        'Signature' => 'Handtekening',
        'Signatures' => 'Handtekeningen',
        'Customer' => 'Klant',
        'CustomerID' => 'Klantcode',
        'CustomerIDs' => 'Klantcodes',
        'customer' => 'klant',
        'agent' => 'behandelaar',
        'system' => 'systeem',
        'Customer Info' => 'Klantinformatie',
        'Customer Information' => 'Klantinformatie',
        'Customer Company' => 'Bedrijf',
        'Customer Companies' => 'Bedrijven',
        'Company' => 'Bedrijf',
        'go!' => 'start!',
        'go' => 'start',
        'All' => 'Alle',
        'all' => 'alle',
        'Sorry' => 'Sorry',
        'update!' => 'opslaan',
        'update' => 'opslaan',
        'Update' => 'Opslaan',
        'Updated!' => 'Gewijzigd',
        'submit!' => 'versturen',
        'submit' => 'versturen',
        'Submit' => 'Versturen',
        'change!' => 'wijzigen',
        'Change' => 'Wijzigen',
        'change' => 'wijzigen',
        'click here' => 'klik hier',
        'Comment' => 'Opmerking',
        'Invalid Option!' => 'Geen geldige optie.',
        'Invalid time!' => 'Geen geldige tijd.',
        'Invalid date!' => 'Geen geldige datum.',
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
        'Added!' => 'Toegevoegd',
        'Category' => 'Categorie',
        'Viewer' => 'Viewer',
        'Expand' => 'Klap uit',
        'Small' => 'Klein',
        'Medium' => 'Middel',
        'Large' => 'Groot',
        'Date picker' => 'Datumkiezer',
        'New message' => 'Nieuw bericht',
        'New message!' => 'Nieuw bericht.',
        'Please answer this ticket(s) to get back to the normal queue view!' =>
            'Beantwoord eerst onderstaande geëscaleerde tickets om terug te kunnen komen in de normale wachtrij.',
        'You have %s new message(s)!' => 'U heeft %s nieuwe bericht(en).',
        'You have %s reminder ticket(s)!' => 'U heeft %s herinneringsticket(s).',
        'The recommended charset for your language is %s!' => 'De aanbevolen karakterset voor uw taal is %s.',
        'Change your password.' => 'Verander uw wachtwoord.',
        'Please activate %s first!' => 'Activeer %s eerst.',
        'No suggestions' => 'Geen suggesties',
        'Word' => 'Woord',
        'Ignore' => 'Negeren',
        'replace with' => 'vervangen met',
        'There is no account with that login name.' => 'Er is geen account bekend met deze gebruikersnaam.',
        'Login failed! Your user name or password was entered incorrectly.' =>
            'Inloggen mislukt. Uw gebruikersnaam of wachtwoord is niet correct.',
        'There is no acount with that user name.' => 'Deze gebruikersnaam is niet bekend.',
        'Please contact your administrator' => 'Neem contact op met uw beheerder',
        'Logout' => 'Uitloggen',
        'Logout successful. Thank you for using %s!' => 'U bent afgemeld. Bedankt voor het gebruiken van %s.',
        'Feature not active!' => 'Deze functie is niet actief.',
        'Agent updated!' => 'Behandelaar aangepast.',
        'Create Database' => 'Database aanmaken',
        'System Settings' => 'Systeemconfiguratie',
        'Mail Configuration' => 'E-mailconfiguratie',
        'Finished' => 'Afgerond',
        'Install OTRS' => 'Installeer OTRS',
        'Intro' => 'Introductie',
        'License' => 'Licentie',
        'Database' => 'Database',
        'Configure Mail' => 'Configureer mail',
        'Database deleted.' => 'Database verwijderd.',
        'Database setup successful!' => 'Database-installatie afgerond.',
        'Generated password' => '',
        'Login is needed!' => 'Inloggen is nodig.',
        'Password is needed!' => 'Een wachtwoord is vereist.',
        'Take this Customer' => 'Selecteer deze klant',
        'Take this User' => 'Selecteer deze gebruiker',
        'possible' => 'mogelijk',
        'reject' => 'afwijzen',
        'reverse' => 'omgekeerd',
        'Facility' => 'Maatregel',
        'Time Zone' => 'Tijdzone',
        'Pending till' => 'In de wacht tot',
        'Don\'t use the Superuser account to work with OTRS! Create new Agents and work with these accounts instead.' =>
            'Werk niet met het SuperUser account. Maak andere accounts aan.',
        'Dispatching by email To: field.' => 'Toewijzen gebaseerd op e-mailadres.',
        'Dispatching by selected Queue.' => 'Toewijzen gebaseerd op geselecteerde wachtrij.',
        'No entry found!' => 'Niets gevonden.',
        'Session invalid. Please log in again.' => 'Uw sessie is ongeldig. Meldt u opnieuw aan.',
        'Session has timed out. Please log in again.' => 'Uw sessie is verlopen. Meldt u opnieuw aan.',
        'Session limit reached! Please try again later.' => 'Sessie-limiet bereikt. Probeert u later opnieuw in te loggen.',
        'No Permission!' => 'Geen toegang! Onvoldoende permissies.',
        '(Click here to add)' => '(Klik hier om toe te voegen)',
        'Preview' => 'Voorbeeld',
        'Package not correctly deployed! Please reinstall the package.' =>
            'Pakket onjuist geïnstalleerd. Installeer het pakket opnieuw.',
        '%s is not writable!' => '%s is niet schrijfbaar.',
        'Cannot create %s!' => 'Kan %s niet aanmaken.',
        'Check to activate this date' => 'Selecteer om deze datum te gebruiken',
        'You have Out of Office enabled, would you like to disable it?' =>
            'U staat geregistreerd als afwezig. Wilt u dit aanpassen?',
        'Customer %s added' => 'Klant %s toegevoegd.',
        'Role added!' => 'Rol toegevoegd.',
        'Role updated!' => 'Rol bijgewerkt.',
        'Attachment added!' => 'Bijlage toegevoegd.',
        'Attachment updated!' => 'Bijlage bijgewerkt.',
        'Response added!' => 'Antwoord toegevoegd.',
        'Response updated!' => 'Antwoord bijgewerkt',
        'Group updated!' => 'Groep bijgewerkt.',
        'Queue added!' => 'Wachtrij toegevoegd.',
        'Queue updated!' => 'Wachtrij bijgewerkt.',
        'State added!' => 'Status toegevoegd.',
        'State updated!' => 'Status bijgewerkt.',
        'Type added!' => 'Type toegevoegd.',
        'Type updated!' => 'Type bijgewerkt',
        'Customer updated!' => 'Klant aangepast.',
        'Customer company added!' => 'Bedrijf toegevoegd.',
        'Customer company updated!' => 'Bedrijf bijgewerkt.',
        'Mail account added!' => 'E-mailaccount toegevoegd.',
        'Mail account updated!' => 'E-mailaccount bijgewerkt.',
        'System e-mail address added!' => 'E-mailadres toegevoegd.',
        'System e-mail address updated!' => 'E-mailadres bijgewerkt.',
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
        'PGP' => 'PGP',
        'PGP Key' => 'PGP Sleutel',
        'PGP Keys' => 'PGP Sleutels',
        'S/MIME' => 'S/MIME',
        'S/MIME Certificate' => 'S/MIME Certificaat',
        'S/MIME Certificates' => 'S/MIME Certificaten',
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
        'Security Note: You should activate %s because application is already running!' =>
            'Beveiligingswaarschuwing: Activeer %s omdat de applicatie al actief is!',
        'Unable to parse repository index document.' => 'Kan repository index document niet verwerken.',
        'No packages for your framework version found in this repository, it only contains packages for other framework versions.' =>
            'Geen pakketten gevonden in deze repository voor de huidige framework versie. De repository bevaty alleen pakketten voor andere framework versies.',
        'No packages, or no new packages, found in selected repository.' =>
            'Geen pakketten, of geen nieuwe pakketten, gevonden in de geselecteerde repository.',
        'Edit the system configuration settings.' => 'Bewerk de systeemconfiguratie.',
        'printed at' => 'afgedrukt op',
        'Loading...' => 'Bezig met laden...',
        'Dear Mr. %s,' => 'Geachte heer %s,',
        'Dear Mrs. %s,' => 'Geachte mevrouw %s,',
        'Dear %s,' => 'Geachte %s,',
        'Hello %s,' => 'Beste %s,',
        'This email address already exists. Please log in or reset your password.' =>
            'Dit e-mailadres bestaat al. Log in of reset uw wachtwoord.',
        'New account created. Sent login information to %s. Please check your email.' =>
            'Nieuw account aangemaakt. Login informatie gestuurd aan %s. Controleer uw e-mail.',
        'Please press Back and try again.' => 'Druk op Terug en probeer opnieuw.',
        'Sent password reset instructions. Please check your email.' => 'Wachtwoord reset instructies zijn verstuurd. Controleer uw e-mail.',
        'Sent new password to %s. Please check your email.' => 'Nieuw wachtwoord gestuurd aan %s. Controleer uw e-mail.',
        'Upcoming Events' => 'Aankomende gebeurtenissen',
        'Event' => 'Gebeurtenis',
        'Events' => 'Gebeurtenissen',
        'Invalid Token!' => 'Fout token!',
        'more' => 'meer',
        'Collapse' => 'Inklappen',
        'Shown' => 'Tonen',
        'Shown customer users' => 'Getoonde klanten',
        'News' => 'Nieuws',
        'Product News' => 'Productnieuws',
        'OTRS News' => 'OTRS Nieuws',
        '7 Day Stats' => 'Afgelopen 7 dagen',
        'Process Management information from database is not in sync with the system configuration, please synchronize all processes.' =>
            'Proces informatie uit de database is niet gesynchroniseerd met de systeemconfiguratie. Voer een synchronisatie uit.',
        'Package not verified by the OTRS Group! It is recommended not to use this package.' =>
            '',
        '<br>If you continue to install this package, the following issues may occur!<br><br>&nbsp;-Security problems<br>&nbsp;-Stability problems<br>&nbsp;-Performance problems<br><br>Please note that issues that are caused by working with this package are not covered by OTRS service contracts!<br><br>' =>
            '',
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
        'Create an Unordered List' => 'Maak een ongesorteerd overzicht aan',
        'Create an Ordered List' => 'Maak een gesorteerd overzicht aan',
        'HTML Link' => 'HTML koppeling',
        'Insert Image' => 'Afbeelding invoegen',
        'CTRL' => 'CTRL',
        'SHIFT' => 'SHIFT',
        'Undo' => 'Ongedaan maken',
        'Redo' => 'Herhalen',
        'Scheduler process is registered but might not be running.' => 'Schedulerproces is geregistreerd, maar niet actief.',
        'Scheduler is not running.' => 'De Scheduler is niet actief.',

        # Template: AAACalendar
        'New Year\'s Day' => 'Nieuwjaarsdag',
        'International Workers\' Day' => 'Dag van de Arbeid',
        'Christmas Eve' => 'Kerstavond',
        'First Christmas Day' => 'Eerste Kerstdag',
        'Second Christmas Day' => 'Tweede Kerstdag',
        'New Year\'s Eve' => 'Oudjaarsdag',

        # Template: AAAGenericInterface
        'OTRS as requester' => 'OTRS als requester',
        'OTRS as provider' => 'OTRS als provider',
        'Webservice "%s" created!' => 'Webservice "%s" is aangemaakt.',
        'Webservice "%s" updated!' => 'Webservice "%s" is bijgewerkt.',

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

        # Template: AAAPreferences
        'Preferences updated successfully!' => 'Uw voorkeuren zijn gewijzigd.',
        'User Profile' => 'Gebruikersprofiel',
        'Email Settings' => 'E-mail voorkeuren',
        'Other Settings' => 'Overige voorkeuren',
        'Change Password' => 'Wachtwoord Wijzigen',
        'Current password' => 'Huidig wachtwoord',
        'New password' => 'Nieuw wachtwoord',
        'Verify password' => 'Herhaal wachtwoord',
        'Spelling Dictionary' => 'Spellingsbibliotheek',
        'Default spelling dictionary' => 'Standaard spellingsbibliotheek',
        'Max. shown Tickets a page in Overview.' => 'Max. getoonde tickets per pagina in overzichtsscherm.',
        'The current password is not correct. Please try again!' => 'Het ingegeven wachtwoord klopt niet. Probeer het opnieuw.',
        'Can\'t update password, your new passwords do not match. Please try again!' =>
            'Kan het wachtwoord niet bijwerken, de wachtwoorden komen niet overeen.',
        'Can\'t update password, it contains invalid characters!' => 'Kan het wachtwoord niet bijwerken, het bevat ongeldige tekens.',
        'Can\'t update password, it must be at least %s characters long!' =>
            'Kan het wachtwoord niet bijwerken, het moet minstens %s tekens lang zijn.',
        'Can\'t update password, it must contain at least 2 lowercase and 2 uppercase characters!' =>
            'Kan het wachtwoord niet bijwerken, het moet minstens twee kleine letters en twee hoofdletters bevatten.',
        'Can\'t update password, it must contain at least 1 digit!' => 'Kan het wachtwoord niet bijwerken, het moet minstens 1 cijfer bevatten.',
        'Can\'t update password, it must contain at least 2 characters!' =>
            'Kan het wachtwoord niet bijwerken, het moet minstens twee tekens lang zijn.',
        'Can\'t update password, this password has already been used. Please choose a new one!' =>
            'Dit wachtwoord is al eerder gebruikt. Kies een nieuw wachtwoord.',
        'Select the separator character used in CSV files (stats and searches). If you don\'t select a separator here, the default separator for your language will be used.' =>
            'Selecteer het scheidingsteken voor CSV bestanden. Als u geen scheidingsteken kiest zal het standaard scheidingsteken voor uw taal gebruikt worden.',
        'CSV Separator' => 'CSV scheidingsteken',

        # Template: AAAStats
        'Stat' => 'Rapportage',
        'Sum' => 'Totaal',
        'Please fill out the required fields!' => 'Vul de verplichte velden in.',
        'Please select a file!' => 'Selecteer een bestand.',
        'Please select an object!' => 'Selecteer een object.',
        'Please select a graph size!' => 'Selecteer de grootte van de grafiek.',
        'Please select one element for the X-axis!' => 'Selecteer een element voor X-as.',
        'Please select only one element or turn off the button \'Fixed\' where the select field is marked!' =>
            'Selecteer een element of haal het vinkje bij \'Statisch\' weg.',
        'If you use a checkbox you have to select some attributes of the select field!' =>
            'Als u een attribuut selecteert moet u ook één of meerdere waarden van dit attribuut selecteren.',
        'Please insert a value in the selected input field or turn off the \'Fixed\' checkbox!' =>
            'Selecteer een element of haal het vinkje bij \'Statisch\' weg.',
        'The selected end time is before the start time!' => 'De opgegeven eindtijd ligt voor de starttijd.',
        'You have to select one or more attributes from the select field!' =>
            'Kies één of meer attributen.',
        'The selected Date isn\'t valid!' => 'De geselecteerde datum is niet geldig.',
        'Please select only one or two elements via the checkbox!' => 'Kies één of meer elementen met de keuzebox.',
        'If you use a time scale element you can only select one element!' =>
            'Als u een tijdselement kiest kunt u maar één element selecteren.',
        'You have an error in your time selection!' => 'De tijdselectie bevat een fout.',
        'Your reporting time interval is too small, please use a larger time scale!' =>
            'De tijdsinterval is te klein, kies een grotere interval.',
        'The selected start time is before the allowed start time!' => 'De starttijd is te vroeg.',
        'The selected end time is after the allowed end time!' => 'De eindtijd is te laat.',
        'The selected time period is larger than the allowed time period!' =>
            'De geselecteerde tijdsperiode is langer dan de toegestane periode.',
        'Common Specification' => 'Algemene eigenschappen',
        'X-axis' => 'X-as',
        'Value Series' => 'Waardes',
        'Restrictions' => 'Restricties',
        'graph-lines' => 'lijnengrafiek',
        'graph-bars' => 'balkengrafiek',
        'graph-hbars' => 'horizontale balkengrafiek',
        'graph-points' => 'puntengrafiek',
        'graph-lines-points' => 'lijnen- en puntengrafiek',
        'graph-area' => 'vlakkengrafiek',
        'graph-pie' => 'taartpuntengrafiek',
        'extended' => 'uitgebreid',
        'Agent/Owner' => 'Behandelaar/eigenaar',
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
        'Status View' => 'Statusoverzicht',
        'Bulk' => 'Bulk',
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
        'Queues' => 'Wachtrijen',
        'Priority' => 'Prioriteit',
        'Priorities' => 'Prioriteiten',
        'Priority Update' => 'Prioriteit wijziging',
        'Priority added!' => 'Prioriteit toegevoegd.',
        'Priority updated!' => 'Prioriteit bijgewerkt.',
        'Signature added!' => 'Handtekening toegevoegd.',
        'Signature updated!' => 'Handtekening bijgewerkt.',
        'SLA' => 'SLA',
        'Service Level Agreement' => 'Service Level Agreement',
        'Service Level Agreements' => 'Service Level Agreements',
        'Service' => 'Service',
        'Services' => 'Services',
        'State' => 'Status',
        'States' => 'Statussen',
        'Status' => 'Status',
        'Statuses' => 'Statussen',
        'Ticket Type' => 'Ticket type',
        'Ticket Types' => 'Ticket typen',
        'Compose' => 'Maken',
        'Pending' => 'Wachten',
        'Owner' => 'Eigenaar',
        'Owner Update' => 'Eigenaar gewijzigd',
        'Responsible' => 'Verantwoordelijke',
        'Responsible Update' => 'Verantwoordelijke gewijzigd',
        'Sender' => 'Afzender',
        'Article' => 'Interactie',
        'Ticket' => 'Ticket',
        'Createtime' => 'Aangemaakt op',
        'plain' => 'zonder opmaak',
        'Email' => 'E-mail',
        'email' => 'e-mail',
        'Close' => 'Sluiten',
        'Action' => 'Actie',
        'Attachment' => 'Bijlage',
        'Attachments' => 'Bijlagen',
        'This message was written in a character set other than your own.' =>
            'Dit bericht is geschreven in een andere karakterset dan degene die u nu heeft ingesteld.',
        'If it is not displayed correctly,' => 'Als dit niet juist wordt weergegeven,',
        'This is a' => 'Dit is een',
        'to open it in a new window.' => 'om deze in een nieuw venster te openen.',
        'This is a HTML email. Click here to show it.' => 'Dit is een HTML e-mail. Klik hier om deze te tonen.',
        'Free Fields' => 'Vrije invulvelden',
        'Merge' => 'Samenvoegen',
        'merged' => 'samengevoegd',
        'closed successful' => 'succesvol gesloten',
        'closed unsuccessful' => 'niet succesvol gesloten',
        'Locked Tickets Total' => 'Totaal aantal vergrendelde tickets',
        'Locked Tickets Reminder Reached' => 'Vergrendelde tickets herinnering bereikt',
        'Locked Tickets New' => 'Nieuwe vergrendelde tickets',
        'Responsible Tickets Total' => 'Totaal aantal tickets verantwoordelijk',
        'Responsible Tickets New' => 'Nieuwe tickets verantwoordelijk',
        'Responsible Tickets Reminder Reached' => 'Tickets verantwoordelijk herinnering bereikt',
        'Watched Tickets Total' => 'Totaal gevolgde tickets',
        'Watched Tickets New' => 'Nieuwe gevolgde tickets',
        'Watched Tickets Reminder Reached' => 'Gevolgde tickets herinnering bereikt',
        'All tickets' => 'Alle tickets',
        'Available tickets' => 'Beschikbare tickets',
        'Escalation' => 'Escalatie',
        'last-search' => 'laatste zoekopdracht',
        'QueueView' => 'Wachtrijoverzicht',
        'Ticket Escalation View' => 'Ticket escalatie',
        'Message from' => 'Bericht van',
        'End message' => 'Einde van het bericht',
        'Forwarded message from' => 'Doorgestuurd bericht van',
        'End forwarded message' => 'Einde doorgestuurd bericht',
        'new' => 'nieuw',
        'open' => 'open',
        'Open' => 'Open',
        'Open tickets' => 'Open tickets',
        'closed' => 'gesloten',
        'Closed' => 'Gesloten',
        'Closed tickets' => 'Gesloten tickets',
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
        'auto follow up' => '',
        'auto reject' => '',
        'auto remove' => '',
        'auto reply' => '',
        'auto reply/new ticket' => '',
        'Ticket "%s" created!' => 'Ticket "%s" aangemaakt.',
        'Ticket Number' => 'Ticketnummer',
        'Ticket Object' => 'Ticketonderwerp',
        'No such Ticket Number "%s"! Can\'t link it!' => 'Ticketnummer "%s" niet gevonden! Er kan dus geen koppeling worden gemaakt.',
        'You don\'t have write access to this ticket.' => 'U heeft geen schrijfrechten op dit ticket.',
        'Sorry, you need to be the ticket owner to perform this action.' =>
            'U moet de eigenaar zijn om deze actie uit te voeren.',
        'Please change the owner first.' => '',
        'Ticket selected.' => 'Ticket geselecteerd.',
        'Ticket is locked by another agent.' => 'Dit ticket is vergrendeld door een andere behandelaar.',
        'Ticket locked.' => 'Ticket vergrendeld.',
        'Don\'t show closed Tickets' => 'Gesloten tickets niet tonen',
        'Show closed Tickets' => 'Gesloten tickets wel tonen',
        'New Article' => 'Nieuwe interactie',
        'Unread article(s) available' => 'Ongelezen interactie(s) aanwezig',
        'Remove from list of watched tickets' => 'Verwijder van lijst met gevolgde tickets',
        'Add to list of watched tickets' => 'Voeg toe aan lijst met gevolgde tickets',
        'Email-Ticket' => 'E-mail ticket',
        'Create new Email Ticket' => 'Maak nieuw e-mail ticket aan',
        'Phone-Ticket' => 'Telefoon ticket',
        'Search Tickets' => 'Zoek tickets',
        'Edit Customer Users' => 'Wijzig klanten',
        'Edit Customer Company' => 'Wijzig bedrijf',
        'Bulk Action' => 'Bulk actie',
        'Bulk Actions on Tickets' => 'Bulk actie op tickets',
        'Send Email and create a new Ticket' => 'Verstuur e-mail en maak een nieuw ticket aan',
        'Create new Email Ticket and send this out (Outbound)' => 'Maak een nieuw ticket aan en verstuur per e-mail',
        'Create new Phone Ticket (Inbound)' => 'Maak nieuw ticket aan van telefoongesprek',
        'Address %s replaced with registered customer address.' => 'Adres %s vervangen met vastgelegde klant-adres.',
        'Customer automatically added in Cc.' => 'Klant automatisch toegevoegd als CC.',
        'Overview of all open Tickets' => 'Laat alle open tickets zien',
        'Locked Tickets' => 'Vergrendelde tickets',
        'My Locked Tickets' => 'Mijn vergrendelde tickets',
        'My Watched Tickets' => 'Mijn gevolgde tickets',
        'My Responsible Tickets' => 'Mijn verantwoordelijke tickets',
        'Watched Tickets' => 'Gevolgde tickets',
        'Watched' => 'Gevolgd',
        'Watch' => 'Volg',
        'Unwatch' => 'Stop met volgen',
        'Lock it to work on it' => 'Vergrendel dit ticket',
        'Unlock to give it back to the queue' => 'Ontgrendelen om dit ticket vrij te geven',
        'Show the ticket history' => 'Toon de ticket-geschiedenis',
        'Print this ticket' => 'Print dit ticket',
        'Print this article' => 'Print deze interactie',
        'Split' => '',
        'Split this article' => 'Splits deze interactie',
        'Forward article via mail' => 'Stuur interactie naar een mailadres',
        'Change the ticket priority' => 'Wijzig de prioriteit van dit ticket',
        'Change the ticket free fields!' => 'Wijzig de vrije invulvelden van het ticket',
        'Link this ticket to other objects' => 'Koppel dit ticket aan andere objecten',
        'Change the owner for this ticket' => 'Wijzig de eigenaar van dit ticket',
        'Change the  customer for this ticket' => 'Wijzig de klant voor dit ticket',
        'Add a note to this ticket' => 'Voeg een notitie toe aan dit ticket',
        'Merge into a different ticket' => 'Voeg samen met een ander ticket',
        'Set this ticket to pending' => 'Zet dit ticket in de wacht',
        'Close this ticket' => 'Sluit dit ticket',
        'Look into a ticket!' => 'Bekijk dit ticket.',
        'Delete this ticket' => 'Verwijder dit ticket',
        'Mark as Spam!' => 'Markeer als spam',
        'My Queues' => 'Mijn wachtrijen',
        'Shown Tickets' => 'Laat tickets zien',
        'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' =>
            'Uw e-mail met ticketnummer "<OTRS_TICKET>" is samengevoegd met "<OTRS_MERGE_TO_TICKET>".',
        'Ticket %s: first response time is over (%s)!' => 'Ticket %s: eerste antwoord tijd is voorbij (%s).',
        'Ticket %s: first response time will be over in %s!' => 'Ticket %s: eerste antwoord tijd zal voorbij zijn binnen %s.',
        'Ticket %s: update time is over (%s)!' => 'Ticket %s: vervolg tijd is voorbij (%s).',
        'Ticket %s: update time will be over in %s!' => 'Ticket %s: vervolg tijd zal voorbij zijn binnen %s.',
        'Ticket %s: solution time is over (%s)!' => 'Ticket %s: oplossing tijd is voorbij (%s).',
        'Ticket %s: solution time will be over in %s!' => 'Ticket %s: oplossing tijd zal voorbij zijn binnen %s.',
        'There are more escalated tickets!' => 'Er zijn nog meer geëscaleerde tickets.',
        'Plain Format' => 'Broncode',
        'Reply All' => 'Allen beantwoorden',
        'Direction' => 'Richting',
        'Agent (All with write permissions)' => 'Behandelaars (met schrijfrechten)',
        'Agent (Owner)' => 'Behandelaar (eigenaar)',
        'Agent (Responsible)' => 'Behandelaar (verantwoordelijke)',
        'New ticket notification' => 'Melding bij een nieuw ticket',
        'Send me a notification if there is a new ticket in "My Queues".' =>
            'Stuur mij een melding als er een nieuw ticket in \'Mijn wachtrijen\' komt.',
        'Send new ticket notifications' => 'Melding bij nieuwe tickets',
        'Ticket follow up notification' => 'Melding bij nieuwe reacties',
        'Ticket lock timeout notification' => 'Melding bij tijdsoverschrijding van een vergrendeld ticket',
        'Send me a notification if a ticket is unlocked by the system.' =>
            'Melding bij ontgrendeling van een ticket door het systeem',
        'Send ticket lock timeout notifications' => 'Melding bij het automatisch ontgrendelen van een ticket',
        'Ticket move notification' => 'Melding bij verplaatsen van een ticket',
        'Send me a notification if a ticket is moved into one of "My Queues".' =>
            ' Stuur een melding als een ticket wordt verplaatst in een van mijn wachtrijen',
        'Send ticket move notifications' => 'Melding bij het verplaatsen van een ticket',
        'Your queue selection of your favourite queues. You also get notified about those queues via email if enabled.' =>
            'Uw selectie van favoriete wachtrijen. U ontvangt automatisch een melding van nieuwe tickets in deze wachtrij, als u hiervoor heeft gekozen.',
        'Custom Queue' => 'Aangepaste wachtrij.',
        'QueueView refresh time' => 'Verversingstijd wachtrij',
        'If enabled, the QueueView will automatically refresh after the specified time.' =>
            'Het wachtrijoverzicht zal automatisch verversen na de ingestelde periode.',
        'Refresh QueueView after' => 'Ververs overzicht na',
        'Screen after new ticket' => 'Scherm na nieuw ticket',
        'Show this screen after I created a new ticket' => 'Toon dit scherm na het aanmaken van een nieuw ticket',
        'Closed Tickets' => 'Afgesloten tickets',
        'Show closed tickets.' => 'Toon gesloten tickets.',
        'Max. shown Tickets a page in QueueView.' => 'Max. getoonde tickets per pagina in wachtrijscherm.',
        'Ticket Overview "Small" Limit' => 'Ticket overzicht (klein) limiet',
        'Ticket limit per page for Ticket Overview "Small"' => 'Getoonde tickets per pagina (klein)',
        'Ticket Overview "Medium" Limit' => 'Ticket overzicht (middel) limiet',
        'Ticket limit per page for Ticket Overview "Medium"' => 'Getoonde tickets per pagina (middel)',
        'Ticket Overview "Preview" Limit' => 'Ticket overzicht (groot) limiet',
        'Ticket limit per page for Ticket Overview "Preview"' => 'Getoonde tickets per pagina (groot)',
        'Ticket watch notification' => 'Gevolgde ticket meldingen',
        'Send me the same notifications for my watched tickets that the ticket owners will get.' =>
            'Stuur mij dezelfde melding voor gevolgde tickets die naar ticket eigenaars gaan.',
        'Send ticket watch notifications' => 'Stuur melding voor gevolgde tickets',
        'Out Of Office Time' => 'Buiten kantoortijd',
        'New Ticket' => 'Nieuw ticket',
        'Create new Ticket' => 'Maak nieuw ticket aan',
        'Customer called' => 'Klant gebeld',
        'phone call' => 'telefoongesprek',
        'Phone Call Outbound' => 'Uitgaand telefoongesprek',
        'Phone Call Inbound' => 'Inkomend telefoongesprek',
        'Reminder Reached' => 'Moment van herinnering bereikt',
        'Reminder Tickets' => 'Tickets met herinnering',
        'Escalated Tickets' => 'Geëscaleerde tickets',
        'New Tickets' => 'Nieuwe tickets',
        'Open Tickets / Need to be answered' => 'Open tickets / wachtend op antwoord',
        'All open tickets, these tickets have already been worked on, but need a response' =>
            'Alle open tickets. Aan deze tickets is al gewerkt, maar moeten nog een antwoord krijgen.',
        'All new tickets, these tickets have not been worked on yet' => 'Alle nieuwe tickets. Aan deze tickets is nog niet gewerkt',
        'All escalated tickets' => 'Alle geëscaleerde tickets',
        'All tickets with a reminder set where the reminder date has been reached' =>
            'Alle tickets met een herinnering waarbij het herinnermoment is bereikt',
        'Archived tickets' => 'Gearchiveerde tickets',
        'Unarchived tickets' => 'Ongearchiveerde tickets',
        'History::Move' => 'Ticket verplaatst naar wachtrij "%s" (%s) van wachtrij "%s" (%s).',
        'History::TypeUpdate' => 'Type gewijzigd naar %s (ID=%s).',
        'History::ServiceUpdate' => 'Service gewijzigd naar %s (ID=%s).',
        'History::SLAUpdate' => 'SLA gewijzigd naar %s (ID=%s).',
        'History::NewTicket' => 'Nieuw ticket [%s] aangemaakt (Q=%s;P=%s;S=%s).',
        'History::FollowUp' => 'Vervolg vraag voor [%s]. %s',
        'History::SendAutoReject' => 'Automatische afwijzing verstuurd aan "%s".',
        'History::SendAutoReply' => 'Automatische beantwoording verstuurd aan "%s".',
        'History::SendAutoFollowUp' => 'Automatische melding verstuurd aan "%s".',
        'History::Forward' => 'Doorgestuurd aan "%s".',
        'History::Bounce' => 'Gebounced naar "%s".',
        'History::SendAnswer' => 'E-mail verstuurd aan "%s".',
        'History::SendAgentNotification' => '"%s" melding verstuurd aan "%s".',
        'History::SendCustomerNotification' => 'Melding verstuurd aan "%s".',
        'History::EmailAgent' => 'E-mail verzonden aan behandelaar.',
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
        'History::LoopProtection' => 'Lus beveiliging! Geen automatisch antwoord verstuurd aan "%s".',
        'History::Misc' => '%s',
        'History::SetPendingTime' => 'Bijgewerkt: %s',
        'History::StateUpdate' => 'Oud: "%s" Nieuw: "%s"',
        'History::TicketDynamicFieldUpdate' => 'Bijgewerkt: %s=%s;%s=%s;',
        'History::WebRequestCustomer' => 'Klant stelt vraag via web.',
        'History::TicketLinkAdd' => 'Koppeling naar "%s" toegevoegd.',
        'History::TicketLinkDelete' => 'Koppeling naar "%s" verwijderd.',
        'History::Subscribe' => 'Added subscription for user "%s".',
        'History::Unsubscribe' => 'Removed subscription for user "%s".',
        'History::SystemRequest' => 'SystemRequest: "%s"',
        'History::ResponsibleUpdate' => 'Nieuwe verantwoordelijke is "%s" (ID=%s).',
        'History::ArchiveFlagUpdate' => 'Archiefstatus veranderd: "%s"',

        # Template: AAAWeekDay
        'Sun' => 'zo',
        'Mon' => 'ma',
        'Tue' => 'di',
        'Wed' => 'wo',
        'Thu' => 'do',
        'Fri' => 'vr',
        'Sat' => 'za',

        # Template: AdminAttachment
        'Attachment Management' => 'Beheer bijlagen',
        'Actions' => 'Acties',
        'Go to overview' => 'Naar het overzicht',
        'Add attachment' => 'Nieuwe bijlage',
        'List' => 'Overzicht',
        'Validity' => 'Geldigheid',
        'No data found.' => 'Geen gegevens gevonden.',
        'Download file' => 'Download bijlage',
        'Delete this attachment' => 'Verwijder bijlage',
        'Add Attachment' => 'Nieuwe bijlage',
        'Edit Attachment' => 'Bijlage bewerken',
        'This field is required.' => 'Dit veld is verplicht.',
        'or' => 'of',

        # Template: AdminAutoResponse
        'Auto Response Management' => 'Beheer automatische antwoorden',
        'Add auto response' => 'Nieuw automatisch antwoord',
        'Add Auto Response' => 'Nieuw automatisch antwoord',
        'Edit Auto Response' => 'Bewerk automatisch antwoord',
        'Response' => 'Antwoord',
        'Auto response from' => 'Automatisch antwoord van',
        'Reference' => 'Referentie',
        'You can use the following tags' => 'U kunt de volgende tags gebruiken',
        'To get the first 20 character of the subject.' => 'Voor de eerste 20 tekens van het onderwerp.',
        'To get the first 5 lines of the email.' => 'Voor de eerste vijf regels van het e-mail bericht.',
        'To get the realname of the sender (if given).' => 'Voor de echte naam van de afzender (indien beschikbaar).',
        'To get the article attribute' => 'Voor de attributen van de interactie',
        ' e. g.' => ' bijv.',
        'Options of the current customer user data' => 'Attributen van de huidige klant',
        'Ticket owner options' => 'Attributen van de ticket eigenaar',
        'Ticket responsible options' => 'Attributen van de verantwoordelijke',
        'Options of the current user who requested this action' => 'Attributen van de huidige gebruiker',
        'Options of the ticket data' => 'Attributen van het ticket',
        'Options of ticket dynamic fields internal key values' => 'Attributen van dynamische velden, interne waarden',
        'Options of ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            'Waarden van dynamische velden, voor Dropdown en Multiselect velden',
        'Config options' => 'Attributen van de configuratie',
        'Example response' => 'Voorbeeld',

        # Template: AdminCustomerCompany
        'Customer Company Management' => 'Beheer bedrijven',
        'Wildcards like \'*\' are allowed.' => 'Wildcards zijn toegestaan.',
        'Add customer company' => 'Nieuw bedrijf',
        'Please enter a search term to look for customer companies.' => 'Typ om te zoeken naar bedrijven.',
        'Add Customer Company' => 'Bedrijf toevoegen',

        # Template: AdminCustomerUser
        'Customer Management' => 'Beheer klanten',
        'Back to search results' => 'Terug naar zoekresultaat',
        'Add customer' => 'Nieuwe klant',
        'Select' => 'Selecteer',
        'Hint' => 'Opmerking',
        'Customer will be needed to have a customer history and to login via customer panel.' =>
            'Klanten zijn nodig om een historie te kunnen inzien en om in te loggen via het klantenscherm.',
        'Please enter a search term to look for customers.' => 'Typ om te zoeken naar klanten.',
        'Last Login' => 'Laatst ingelogd',
        'Login as' => 'Inloggen als',
        'Switch to customer' => 'Omschakelen naar klant',
        'Add Customer' => 'Klant toevoegen',
        'Edit Customer' => 'Klant bewerken',
        'This field is required and needs to be a valid email address.' =>
            'Dit veld is verplicht en moet een geldig e-mailadres zijn.',
        'This email address is not allowed due to the system configuration.' =>
            'Dit e-mailadres is niet toegestaan.',
        'This email address failed MX check.' => 'Dit e-mailadres klopt niet.',
        'DNS problem, please check your configuration and the error log.' =>
            'DNS probleem geconstateerd. Kijk in de log voor meer details en pas uw configuratie aan.',
        'The syntax of this email address is incorrect.' => 'De syntax van dit e-mailadres klopt niet.',

        # Template: AdminCustomerUserGroup
        'Manage Customer-Group Relations' => 'Beheer Klant - Groep koppelingen',
        'Notice' => 'Notitie',
        'This feature is disabled!' => 'Deze functie is niet geactiveerd.',
        'Just use this feature if you want to define group permissions for customers.' =>
            'Gebuik deze mogelijkheid alleen als u groep-permissies voor klanten wilt gebruiken.',
        'Enable it here!' => 'Inschakelen',
        'Search for customers.' => 'Zoek naar klanten',
        'Edit Customer Default Groups' => 'Bewerk standaard groepen voor klanten',
        'These groups are automatically assigned to all customers.' => 'Deze groepen worden toegewezen aan alle klanten.',
        'You can manage these groups via the configuration setting "CustomerGroupAlwaysGroups".' =>
            'U kunt deze groepen beheren via de optie "CustomerGroupAlwaysGroups".',
        'Filter for Groups' => 'Filter op groepen',
        'Select the customer:group permissions.' => 'Selecteer de permissies voor klant:groep.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer).' =>
            'Als niets geselecteerd is, zijn er geen permissies in deze groep (de klant zal geen tickets kunnen zien).',
        'Search Results' => 'Zoekresultaat',
        'Customers' => 'Klanten',
        'Groups' => 'Groepen',
        'No matches found.' => 'Niets gevonden.',
        'Change Group Relations for Customer' => 'Bewerk gekoppelde groepen voor klant',
        'Change Customer Relations for Group' => 'Bewerk gekoppelde klanten voor groep',
        'Toggle %s Permission for all' => '%s permissies aan/uit',
        'Toggle %s permission for %s' => '%s permissies aan/uit voor %s',
        'Customer Default Groups:' => 'Standaard groepen',
        'No changes can be made to these groups.' => 'Deze kunnen niet verwijderd worden.',
        'ro' => 'alleen lezen',
        'Read only access to the ticket in this group/queue.' => 'Leesrechten op de tickets in deze groep/wachtrij.',
        'rw' => 'lezen + schrijven',
        'Full read and write access to the tickets in this group/queue.' =>
            'Volledige lees- en schrijfrechten op de tickets in deze groep/wachtrij.',

        # Template: AdminCustomerUserService
        'Manage Customer-Services Relations' => 'Beheer Klant - Service koppelingen',
        'Edit default services' => 'Beheer standaard services',
        'Filter for Services' => 'Filter op services',
        'Allocate Services to Customer' => 'Koppel services aan klant',
        'Allocate Customers to Service' => 'Koppel klanten aan service',
        'Toggle active state for all' => 'Alles actief aan/uit',
        'Active' => 'Actief',
        'Toggle active state for %s' => 'Actief aan/uit voor %s',

        # Template: AdminDynamicField
        'Dynamic Fields Management' => 'Beheer van dynamische velden',
        'Add new field for object' => 'Nieuw veld voor object',
        'To add a new field, select the field type form one of the object\'s list, the object defines the boundary of the field and it can\'t be changed after the field creation.' =>
            'Om een nieuw veld toe te voegen: kies een object-type uit de lijst. Deze kan na het aanmaken niet meer worden aangepast.',
        'Dynamic Fields List' => 'Lijst met dynamische velden',
        'Dynamic fields per page' => 'Dynamische velden per pagina',
        'Label' => 'Label',
        'Order' => 'Volgorde',
        'Object' => 'Object',
        'Delete this field' => 'Verwijder dit veld',
        'Do you really want to delete this dynamic field? ALL associated data will be LOST!' =>
            'Wilt u dit veld definitief verwijderen? Alle data in dit veld wordt ook verwijderd!',
        'Delete field' => 'Verwijder veld',

        # Template: AdminDynamicFieldCheckbox
        'Dynamic Fields' => 'Dynamische velden',
        'Field' => 'Veld',
        'Go back to overview' => 'Terug naar het overzicht',
        'General' => 'Algemeen',
        'This field is required, and the value should be alphabetic and numeric characters only.' =>
            'Dit veld is verplicht. Het kan aleen alfanumerieke tekens bevatten.',
        'Must be unique and only accept alphabetic and numeric characters.' =>
            'Moet uniek zijn en kan alleen alfanumerieke tekens bevatten.',
        'Changing this value will require manual changes in the system.' =>
            'Na aanpassen van deze waarde zijn handmatige aanpassingen in het systeem nodig.',
        'This is the name to be shown on the screens where the field is active.' =>
            'Deze naam wordt getoond in de schermen waar dit veld actief is.',
        'Field order' => 'Veldvolgorde',
        'This field is required and must be numeric.' => 'Dit veld is verplicht en moet numeriek zijn.',
        'This is the order in which this field will be shown on the screens where is active.' =>
            'Dit is de volgorde waarin de velden worden weergegeven op de schermen waar ze geactiveerd zijn.',
        'Field type' => 'Veldtype',
        'Object type' => 'Objecttype',
        'Internal field' => 'Intern veld',
        'This field is protected and can\'t be deleted.' => 'Dit veld is beschermd en kan niet worden verwijderd.',
        'Field Settings' => 'Veld-instellingen',
        'Default value' => 'Standaard waarde',
        'This is the default value for this field.' => 'Dit is de standaard-waarde voor dit veld.',
        'Save' => 'Opslaan',

        # Template: AdminDynamicFieldDateTime
        'Default date difference' => 'Standaard verschil met huidige datum',
        'This field must be numeric.' => 'Dit veld moet numeriek zijn.',
        'The difference from NOW (in seconds) to calculate the field default value (e.g. 3600 or -60).' =>
            'Het verschil tot de huidige tijd (in seconden) ten behoeve van de standaard waarde van dit veld.',
        'Define years period' => 'Geef mogelijke periode',
        'Activate this feature to define a fixed range of years (in the future and in the past) to be displayed on the year part of the field.' =>
            'Activeer deze feature om een minimale en maximale waarde te kiezen in het jaar-veld van de datum.',
        'Years in the past' => 'Jaren in het verleden',
        'Years in the past to display (default: 5 years).' => '(standaard: 5 jaar).',
        'Years in the future' => 'Jaren in de toekomst',
        'Years in the future to display (default: 5 years).' => '(standaard: 5 jaar).',
        'Show link' => 'Toon koppeling',
        'Here you can specify an optional HTTP link for the field value in Overviews and Zoom screens.' =>
            'Hier kunt u een optionele hyperlink opgeven die getoond wordt in de overzichten en zoom-schermen.',

        # Template: AdminDynamicFieldDropdown
        'Possible values' => 'Mogelijke waarden',
        'Key' => 'Sleutel',
        'Value' => 'Waarde',
        'Remove value' => 'Waarde verwijderen',
        'Add value' => 'Waarde toevoegen',
        'Add Value' => 'Waarde toevoegen',
        'Add empty value' => 'Lege waarde toevoegen',
        'Activate this option to create an empty selectable value.' => 'Activeer deze optie om een lege selecteerbare waarde toe te voeten.',
        'Translatable values' => 'Waarden zijn vertaalbaar',
        'If you activate this option the values will be translated to the user defined language.' =>
            'Als u deze optie activeerd zullen de waarden vertaald worden in de taal van de eindgebruiker.',
        'Note' => 'Notitie',
        'You need to add the translations manually into the language translation files.' =>
            'U moet de vertalingen zelf toevoegen aan de vertalingsbestanden.',

        # Template: AdminDynamicFieldMultiselect

        # Template: AdminDynamicFieldText
        'Number of rows' => 'Aantal regels',
        'Specify the height (in lines) for this field in the edit mode.' =>
            'Geef de hoogte van het invoervak voor dit veld (in regels)',
        'Number of cols' => 'Aantal kolommen',
        'Specify the width (in characters) for this field in the edit mode.' =>
            'Geef de breedte van het invoervak voor dit veld (in kolommen)',

        # Template: AdminEmail
        'Admin Notification' => 'Melding van de beheerder',
        'With this module, administrators can send messages to agents, group or role members.' =>
            'Vanuit dit scherm kunt u een bericht sturen aan behandelaars of klanten.',
        'Create Administrative Message' => 'Stuur een bericht',
        'Your message was sent to' => 'Uw bericht is verstuurd aan',
        'Send message to users' => 'Stuur bericht aan gebruikers',
        'Send message to group members' => 'Stuur bericht aan accounts met groep',
        'Group members need to have permission' => 'Leden van de groep moeten permissies hebben',
        'Send message to role members' => 'Stuur bericht naar accounts met rol',
        'Also send to customers in groups' => 'Stuur ook naar klanten in deze groepen',
        'Body' => 'Bericht tekst',
        'Send' => 'Verstuur',

        # Template: AdminGenericAgent
        'Generic Agent' => 'Automatische Taken',
        'Add job' => 'Taak toevoegen',
        'Last run' => 'Laatst uitgevoerd',
        'Run Now!' => 'Nu uitvoeren',
        'Delete this task' => 'Verwijder deze taak',
        'Run this task' => 'Voer deze taak',
        'Job Settings' => 'Taak instellingen',
        'Job name' => 'Naam',
        'Currently this generic agent job will not run automatically.' =>
            'Deze taak zal niet automatisch draaien.',
        'To enable automatic execution select at least one value from minutes, hours and days!' =>
            'Om automatisch uit te voeren selecteer ten minste één waarde bij minuten, uren en dagen.',
        'Schedule minutes' => 'minuten',
        'Schedule hours' => 'uren',
        'Schedule days' => 'dagen',
        'Toggle this widget' => 'Klap in/uit',
        'Ticket Filter' => 'Ticket filter',
        '(e. g. 10*5155 or 105658*)' => '(bijvoorbeeld 10*5155 or 105658*)',
        '(e. g. 234321)' => '(bijvoorbeeld 234321)',
        'Customer login' => 'Klant login',
        '(e. g. U5150)' => '(bijvoorbeeld U5150)',
        'Fulltext-search in article (e. g. "Mar*in" or "Baue*").' => 'Zoek in tekst van een interactie. Gebruik wildcards (bijvoorbeeld "Mar*in" of "Jans*").',
        'Agent' => 'Behandelaar',
        'Ticket lock' => 'Vergrendeling',
        'Create times' => 'Tijdstip van aanmaken',
        'No create time settings.' => 'Alle',
        'Ticket created' => 'Ticket aangemaakt',
        'Ticket created between' => 'Ticket aangemaakt tussen',
        'Change times' => 'Tijdstip van wijzigen',
        'No change time settings.' => 'Alle',
        'Ticket changed' => 'Ticket gewijzigd',
        'Ticket changed between' => 'Ticket gewijzigd tussen',
        'Close times' => 'Tijdstip van sluiten',
        'No close time settings.' => 'Alle',
        'Ticket closed' => 'Ticket gesloten',
        'Ticket closed between' => 'Ticket gesloten tussen',
        'Pending times' => 'Tijdstip van wachten',
        'No pending time settings.' => 'Niet op zoeken',
        'Ticket pending time reached' => 'Ticket wachtend tot tijd bereikt',
        'Ticket pending time reached between' => 'Ticket wachtend tot tijd tussen',
        'Escalation times' => 'Tijdstip van escalatie',
        'No escalation time settings.' => 'Niet op zoeken',
        'Ticket escalation time reached' => 'Escalatiemoment bereikt',
        'Ticket escalation time reached between' => 'Escalatiemoment bereikt tussen',
        'Escalation - first response time' => 'Escalatie - eerste reactietijd',
        'Ticket first response time reached' => 'Escalatiemoment eerste reactie bereikt',
        'Ticket first response time reached between' => 'Escalatiemoment eerste reactie bereikt tussen',
        'Escalation - update time' => 'Escalatie - tijd van bijwerken',
        'Ticket update time reached' => 'Escalatiemoment - tijd van bijwerken bereikt',
        'Ticket update time reached between' => 'Escalatiemoment - tijd van bijwerken bereikt tussen',
        'Escalation - solution time' => 'Escalatie - tijd van oplossen',
        'Ticket solution time reached' => 'Escalatiemoment - tijd van oplossen bereikt',
        'Ticket solution time reached between' => 'Escalatiemoment - tijd van oplossen bereikt tussen',
        'Archive search option' => 'Zoek in archief',
        'Ticket Action' => 'Bewerk ticket',
        'Set new service' => 'Nieuwe service',
        'Set new Service Level Agreement' => 'Nieuwe Service Level Agreement',
        'Set new priority' => 'Nieuwe prioriteit',
        'Set new queue' => 'Nieuwe wachtrij',
        'Set new state' => 'Nieuwe status',
        'Set new agent' => 'Nieuwe behandelaar',
        'new owner' => 'nieuwe eigenaar',
        'new responsible' => 'nieuwe verantwoordelijke',
        'Set new ticket lock' => 'Nieuwe vergrendeling',
        'New customer' => 'Nieuwe klant',
        'New customer ID' => 'Nieuwe klantcode',
        'New title' => 'Nieuwe titel',
        'New type' => 'Nieuw type',
        'New Dynamic Field Values' => 'Nieuwe dynamische velden',
        'Archive selected tickets' => 'Archiveer geselecteerde tickets',
        'Add Note' => 'Notitie toevoegen',
        'Time units' => 'Bestede tijd',
        '(work units)' => '(in minuten)',
        'Ticket Commands' => 'Geavanceerd',
        'Send agent/customer notifications on changes' => 'Stuur behandelaars / klanten een melding bij wijzigingen',
        'CMD' => 'Commando',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' =>
            'Dit commando zal worden uitgevoerd. ARG[0] is het nieuwe ticketnummer. ARG[1] is het nieuwe ticketid.',
        'Delete tickets' => 'Verwijder tickets.',
        'Warning: All affected tickets will be removed from the database and cannot be restored!' =>
            'Waarschuwing: alle geselecteerde tickets worden verwijderd uit de database en kunnen niet terug worden geplaatst.',
        'Execute Custom Module' => 'Start externe module',
        'Param %s key' => 'Parameter %s sleutel',
        'Param %s value' => 'Parameter %s waarde',
        'Save Changes' => 'Wijzigingen opslaan',
        'Results' => 'Resultaten',
        '%s Tickets affected! What do you want to do?' => '%s tickets gevonden! Wat wilt u doen?',
        'Warning: You used the DELETE option. All deleted tickets will be lost!' =>
            'Waarschuwing: u hebt voor VERWIJDEREN gekozen!',
        'Edit job' => 'Bewerk taak',
        'Run job' => 'Voer taak uit',
        'Affected Tickets' => 'Gevonden tickets',

        # Template: AdminGenericInterfaceDebugger
        'GenericInterface Debugger for Web Service %s' => 'GenericInterface Debugger voor webservice %s',
        'Web Services' => 'Webservices',
        'Debugger' => 'Debugger',
        'Go back to web service' => 'Ga terug naar webservice',
        'Clear' => 'Leegmaken',
        'Do you really want to clear the debug log of this web service?' =>
            'Wilt u de debug-log van deze webservice leegmaken?',
        'Request List' => 'Lijst van verzoeken',
        'Time' => 'Tijd',
        'Remote IP' => 'IP-adres afzender',
        'Loading' => 'Laden',
        'Select a single request to see its details.' => 'Kies een verzoek om de details te zien.',
        'Filter by type' => 'Filter op type',
        'Filter from' => 'Filter op afzender',
        'Filter to' => 'Filter op bestemming',
        'Filter by remote IP' => 'Filter op IP-adres',
        'Refresh' => 'Vernieuwen',
        'Request Details' => 'Details verzoek',
        'An error occurred during communication.' => 'Er is een fout opgetreden tijdens de communicatie.',
        'Show or hide the content' => 'Toon of verberg de inhoud',
        'Clear debug log' => 'Leeg debug-log.',

        # Template: AdminGenericInterfaceInvokerDefault
        'Add new Invoker to Web Service %s' => 'Nieuwe Invoker toevoegen aan webservice %s',
        'Change Invoker %s of Web Service %s' => 'Wijzig Invoker %s voor webservice %s',
        'Add new invoker' => 'Nieuwe invoker toevoegen',
        'Change invoker %s' => 'Wijzig invoker %s',
        'Do you really want to delete this invoker?' => 'Wilt u deze invoker echt verwijderen?',
        'All configuration data will be lost.' => 'Alle configuratiedata gaat verloren.',
        'Invoker Details' => 'Invoker details',
        'The name is typically used to call up an operation of a remote web service.' =>
            'De naam wordt gebruikt om een operatie van een webservice aan te roepen.',
        'Please provide a unique name for this web service invoker.' => 'Geef een unieke naam voor deze web service invoker.',
        'The name you entered already exists.' => 'De naam die u hebt opgegeven bestaat al.',
        'Invoker backend' => 'Invoker backend',
        'This OTRS invoker backend module will be called to prepare the data to be sent to the remote system, and to process its response data.' =>
            'Deze OTRS invoker module zal worden aangeroepen om de data te formatteren voordat deze naar het andere systeem verstuurd wordt.',
        'Mapping for outgoing request data' => 'Mapping voor uitgaande data.',
        'Configure' => 'Configureer',
        'The data from the invoker of OTRS will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            'De data van de invoker van OTRS wordt verwerkt door deze mapping om het om te zetten in het formaat wat het communicerende systeem verwacht.',
        'Mapping for incoming response data' => 'Koppeling voor inkomende response-data',
        'The response data will be processed by this mapping, to transform it to the kind of data the invoker of OTRS expects.' =>
            'De data van het antwoord wordt verwerkt door deze koppeling om dit om te zetten in het formaat wat de OTRS invoker verwacht.',
        'Event Triggers' => 'Event triggers',
        'Asynchronous' => 'Asynchroon',
        'Delete this event' => 'Verwijder dit event',
        'This invoker will be triggered by the configured events.' => 'De invoker wordt aangeroepen door de geconfigureerde events.',
        'Do you really want to delete this event trigger?' => 'Wilt u deze event trigger verwijderen?',
        'Add Event Trigger' => 'Nieuwe event trigger toevoegen',
        'To add a new event select the event object and event name and click on the "+" button' =>
            'Om een nieuw event toe te voegen, selecteer het event object en de naam van het event en klik op de "+".',
        'Asynchronous event triggers are handled by the OTRS Scheduler in background (recommended).' =>
            'Asynchrone event triggers worden afgehandeld door de OTRS Scheduler in de achtergrond (aangeraden).',
        'Synchronous event triggers would be processed directly during the web request.' =>
            'Synchrone event triggers worden afgehandeld direct tijdens het event (blocking).',
        'Save and continue' => 'Opslaan en doorgaan',
        'Save and finish' => 'Opslaan en voltooien',
        'Delete this Invoker' => 'Verwijder deze invoker',
        'Delete this Event Trigger' => 'Verwijder deze event trigger.',

        # Template: AdminGenericInterfaceMappingSimple
        'GenericInterface Mapping Simple for Web Service %s' => 'GenericInterface Eenvoudige Koppeling voor Web Service %s',
        'Go back to' => 'Ga terug naar',
        'Mapping Simple' => 'Eenvoudige koppeling',
        'Default rule for unmapped keys' => 'Standaardregel voor nietgekoppelde sleutels',
        'This rule will apply for all keys with no mapping rule.' => 'Deze regel geldt voor alle sleutelwaarden zonder koppeling.',
        'Default rule for unmapped values' => 'Standaardregel voor nietgekoppelde waarden',
        'This rule will apply for all values with no mapping rule.' => 'Deze regel geldt voor alle waarden zonder koppeling.',
        'New key map' => 'Nieuwe sleutelkoppeling',
        'Add key mapping' => 'Voeg sleutelkoppeling toe',
        'Mapping for Key ' => 'Koppeling voor sleutel',
        'Remove key mapping' => 'Verwijder sleutelkoppeling',
        'Key mapping' => 'Sleutelkoppeling',
        'Map key' => 'Koppel sleutel',
        'matching the' => 'die overeenkomen met',
        'to new key' => 'aan nieuwe sleutel',
        'Value mapping' => 'Waardekoppeling',
        'Map value' => 'Koppel waarde',
        'to new value' => 'aan nieuwe waarde',
        'Remove value mapping' => 'Verwijder waardekoppeling',
        'New value map' => 'Nieuwe waardekoppeling',
        'Add value mapping' => 'Voeg waardekoppeling toe',
        'Do you really want to delete this key mapping?' => 'Deze sleutelkoppeling verwijderen?',
        'Delete this Key Mapping' => 'Verwijder sleutelkoppeling',

        # Template: AdminGenericInterfaceOperationDefault
        'Add new Operation to Web Service %s' => 'Voeg nieuwe operatie toe voor Web Service %s',
        'Change Operation %s of Web Service %s' => 'Wijzig operatie %s voor Web Service %s',
        'Add new operation' => 'Nieuwe operatie toevoegen',
        'Change operation %s' => 'Verander operatie %s',
        'Do you really want to delete this operation?' => 'Wilt u deze operatie echt verwijderen?',
        'Operation Details' => 'Operatie-details',
        'The name is typically used to call up this web service operation from a remote system.' =>
            'De naam wordt normaal gesproken gebruikt om deze Web Service aan te roepen vanaf een ander systeem.',
        'Please provide a unique name for this web service.' => 'Geef een unieke naam op voor deze Web Service.',
        'Mapping for incoming request data' => 'Koppeling voor inkomende data',
        'The request data will be processed by this mapping, to transform it to the kind of data OTRS expects.' =>
            'De inkomende data wordt verwerkt door deze koppeling, om het om te zetten naar de data die OTRS verwacht.',
        'Operation backend' => 'Operatie-backend',
        'This OTRS operation backend module will be called internally to process the request, generating data for the response.' =>
            'Deze OTRS operatie-module zal intern worden gebruikt om de data voor de respons te genereren.',
        'Mapping for outgoing response data' => 'Koppeling voor respons-data',
        'The response data will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            'De respons-data wordt verwerkt door deze koppeling, om het om te zetten naar de data die het andere systeem verwacht.',
        'Delete this Operation' => 'Verwijder deze operatie',

        # Template: AdminGenericInterfaceTransportHTTPSOAP
        'GenericInterface Transport HTTP::SOAP for Web Service %s' => 'GenericInterface Transport HTTP::SOAP voor web service %s',
        'Network transport' => 'Netwerk-transport',
        'Properties' => 'Eigenschappen',
        'Endpoint' => 'Eindpunt',
        'URI to indicate a specific location for accessing a service.' =>
            'URI om de specifieke lokatie van een service te definieren.',
        'e.g. http://local.otrs.com:8000/Webservice/Example' => 'e.g. http://local.otrs.com:8000/Webservice/Example',
        'Namespace' => 'Namespace',
        'URI to give SOAP methods a context, reducing ambiguities.' => 'URI om SOAP methods een context te geven.',
        'e.g urn:otrs-com:soap:functions or http://www.otrs.com/GenericInterface/actions' =>
            'bijv. urn:otrs-com:soap:functions of http://www.otrs.com/GenericInterface/actions',
        'Maximum message length' => 'Maximale bericht-lengte',
        'This field should be an integer number.' => 'Dit veld moet een getal bevatten.',
        'Here you can specify the maximum size (in bytes) of SOAP messages that OTRS will process.' =>
            'Hier kunt u de maximale berichtgrootte (in bytes) opgeven van de berichten die OTRS zal verwerken.',
        'Encoding' => 'Karakterset',
        'The character encoding for the SOAP message contents.' => 'De karakterset voor de inhoud van het SOAP-bericht.',
        'e.g utf-8, latin1, iso-8859-1, cp1250, Etc.' => 'bijv. utf-8, latin1, iso-8859-1, cp1250, etc.',
        'SOAPAction' => 'SOAP-Action',
        'Set to "Yes" to send a filled SOAPAction header.' => 'Kies "Ja" om een gevulde SOAPAction header te versturen.',
        'Set to "No" to send an empty SOAPAction header.' => 'Kies "Nee" om een lege SOAPAction header te versturen.',
        'SOAPAction separator' => 'SOAP-action separator',
        'Character to use as separator between name space and SOAP method.' =>
            'Karakter om te gebruiken als separator tussen de name-space en SOAP method.',
        'Usually .Net web services uses a "/" as separator.' => 'Normaal gesproken gebruiken .Net web services de "/" als een separator.',
        'Authentication' => 'Authenticatie',
        'The authentication mechanism to access the remote system.' => 'Het authenticatie-mechanisme voor het andere systeem.',
        'A "-" value means no authentication.' => 'De waarde "-" betekent geen authenticatie.',
        'The user name to be used to access the remote system.' => 'De gebruikersnaam om toegang te krijgen tot het andere systeem.',
        'The password for the privileged user.' => 'Wachtwoord',
        'Use SSL Options' => 'Configureer SSL opties',
        'Show or hide SSL options to connect to the remote system.' => 'Toon of verberg SSL opties om te verbinden naar het andere systeem',
        'Certificate File' => 'Certificaat-bestand',
        'The full path and name of the SSL certificate file (must be in .p12 format).' =>
            'Het volledige pad en de naam van het SSL-certificaat (in .p12 formaat).',
        'e.g. /opt/otrs/var/certificates/SOAP/certificate.p12' => 'bijv. /opt/otrs/var/certificates/SOAP/certificate.p12',
        'Certificate Password File' => 'Bestand dat wachtwoord van het certificaaat bevat',
        'The password to open the SSL certificate.' => 'Het wachtwoord voor het SSL-certificaat',
        'Certification Authority (CA) File' => 'Certification Authority (CA) bestand',
        'The full path and name of the certification authority certificate file that validates SSL certificate.' =>
            'Het volledige pad en de naam van het CA certificaat dat het SSL certificaat valideert.',
        'e.g. /opt/otrs/var/certificates/SOAP/CA/ca.pem' => 'Bijvoorbeeld /opt/otrs/var/certificates/SOAP/CA/ca.pem',
        'Certification Authority (CA) Directory' => 'Certification Authority (CA) directory',
        'The full path of the certification authority directory where the CA certificates are stored in the file system.' =>
            'Het volledige pad van de directory waar de CA-certificaten worden opgeslagen.',
        'e.g. /opt/otrs/var/certificates/SOAP/CA' => 'bijvoorbeeld /opt/otrs/var/certificates/SOAP/CA',
        'Proxy Server' => 'Proxy-server',
        'URI of a proxy server to be used (if needed).' => 'URI van de proxy-server (indien nodig).',
        'e.g. http://proxy_hostname:8080' => 'e.g. http://proxy_hostname:8080',
        'Proxy User' => 'Proxy-gebruikersnaam',
        'The user name to be used to access the proxy server.' => 'De gebruikersnaam voor toegang tot de proxy-server.',
        'Proxy Password' => 'Proxy-wachtwoord',
        'The password for the proxy user.' => 'Het wachtwoord voor de proxy-gebruiker.',

        # Template: AdminGenericInterfaceWebservice
        'GenericInterface Web Service Management' => 'GenericInterface Web Service Beheer',
        'Add web service' => 'Webservice toevoegen',
        'Clone web service' => 'Kloon webservice',
        'The name must be unique.' => 'De naam moet uniek zijn',
        'Clone' => 'Kloon',
        'Export web service' => 'Exporteer webservice',
        'Import web service' => 'Importeer webservice',
        'Configuration File' => 'Configuratiebestand',
        'The file must be a valid web service configuration YAML file.' =>
            'Het bestand moet een geldig web service YAML bestand zijn.',
        'Import' => 'Importeer',
        'Configuration history' => 'Configuratiegeschiedenis',
        'Delete web service' => 'Verwijder webservice',
        'Do you really want to delete this web service?' => 'Wilt u deze webservice verwijderen?',
        'After you save the configuration you will be redirected again to the edit screen.' =>
            'Na opslaan blijft u in dit scherm.',
        'If you want to return to overview please click the "Go to overview" button.' =>
            'Als u terug wilt na het overzicht klik dan op de "Naar het overzicht" knop.',
        'Web Service List' => 'Webservice-overzicht',
        'Remote system' => 'Ander systeem',
        'Provider transport' => 'Provider-transport',
        'Requester transport' => 'Requester-transport',
        'Details' => 'Details',
        'Debug threshold' => 'Debug-niveau',
        'In provider mode, OTRS offers web services which are used by remote systems.' =>
            'In Provider-modus levert OTRS web services die aangeroepen worden door andere systemen.',
        'In requester mode, OTRS uses web services of remote systems.' =>
            'In Requester-modus gebruikt OTRS web services van andere systemen.',
        'Operations are individual system functions which remote systems can request.' =>
            'Operaties zijn individuele systeemfuncties die aangeroepen kunnen worden door andere systemen.',
        'Invokers prepare data for a request to a remote web service, and process its response data.' =>
            'Invokers verzamelen data voor een aanroep naar een ander systeem, en om de responsdata van het andere systeem te verwerken.',
        'Controller' => 'Controller',
        'Inbound mapping' => 'Inkomende koppeling',
        'Outbound mapping' => 'Uitgaande koppeling',
        'Delete this action' => 'Verwijder deze actie',
        'At least one %s has a controller that is either not active or not present, please check the controller registration or delete the %s' =>
            'Tenminste een %s heeft een controller die niet actief of beschikbaar is.',
        'Delete webservice' => 'Verwijder webservice',
        'Delete operation' => 'Verwijder operatie',
        'Delete invoker' => 'Verwijder invoker',
        'Clone webservice' => 'Kloon webservice',
        'Import webservice' => 'Importeer webservice',

        # Template: AdminGenericInterfaceWebserviceHistory
        'GenericInterface Configuration History for Web Service %s' => 'GenericInterface Configuratie-geschiedenis voor webservice %s',
        'Go back to Web Service' => 'Ga terug naar webservice',
        'Here you can view older versions of the current web service\'s configuration, export or even restore them.' =>
            'Hier kunt u oudere versies van de huidige web service-configuratie bekijken, exporteren of terugzetten.',
        'Configuration History List' => 'Configuratie-geschiedenis',
        'Version' => 'Versie',
        'Create time' => 'Aanmaaktijd',
        'Select a single configuration version to see its details.' => 'Selecteer een configuratie-versie om de details te bekijken.',
        'Export web service configuration' => 'Exporteer webserviceconfiguratie',
        'Restore web service configuration' => 'Herstel webserviceconfiguratie',
        'Do you really want to restore this version of the web service configuration?' =>
            'Wilt u echt deze versie van de webservice-configuratie herstellen?',
        'Your current web service configuration will be overwritten.' => 'De huidige webservice-configuratie zal worden overschreven.',
        'Show or hide the content.' => 'Toon of verberg de inhoud.',
        'Restore' => 'Herstellen',

        # Template: AdminGroup
        'WARNING: When you change the name of the group \'admin\', before making the appropriate changes in the SysConfig, you will be locked out of the administrations panel! If this happens, please rename the group back to admin per SQL statement.' =>
            'WAARSCHUWING: Als u de naam van de groep \'admin\'aanpast voordat u de bijbehorende wijzigingen in de Systeemconfiguratie heeft aangebracht, zult u geen beheer-permissies meer hebben in OTRS. Als dit gebeurt, moet u de naam van de groep aanpassen met een SQL statement.',
        'Group Management' => 'Groepenbeheer',
        'Add group' => 'Groep toevoegen',
        'The admin group is to get in the admin area and the stats group to get stats area.' =>
            'Leden van de groep Admin mogen in het administratie gedeelte, leden van de groep Stats hebben toegang tot het statistieken gedeelte.',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...). ' =>
            'Maak nieuwe groepen aan om tickets te kunnen scheiden en de juiste wachtrijen aan behandelaars te tonen (bijv. support, sales, management).',
        'It\'s useful for ASP solutions. ' => 'Bruikbaar voor ASP situaties.',
        'Add Group' => 'Groep toevoegen',
        'Edit Group' => 'Bewerk groep',

        # Template: AdminLog
        'System Log' => 'Logboek',
        'Here you will find log information about your system.' => 'Hier is de OTRS log te raadplegen.',
        'Hide this message' => 'Verberg dit paneel',
        'Recent Log Entries' => 'Recente Logboekregels',

        # Template: AdminMailAccount
        'Mail Account Management' => 'Beheer e-mail accounts',
        'Add mail account' => 'E-mail account toevoegen',
        'All incoming emails with one account will be dispatched in the selected queue!' =>
            'Alle binnenkomende e-mails van een account zullen standaard geplaatst worden in de opgegeven wachtrij.',
        'If your account is trusted, the already existing X-OTRS header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' =>
            'Als het account gemarkeerd is als \'vertrouwd\' worden al bestaande X-OTRS headers bij aankomst gebruikt. Hierna worden de e-mail filters doorlopen.',
        'Host' => 'Server',
        'Delete account' => 'Verwijder account',
        'Fetch mail' => 'Mail ophalen',
        'Add Mail Account' => 'Mail account toevoegen',
        'Example: mail.example.com' => 'Bijvoorbeeld: mail.example.com',
        'IMAP Folder' => 'IMAP folder',
        'Only modify this if you need to fetch mail from a different folder than INBOX.' =>
            'Alleen aanpassen als u uit een andere folder dan INBOX mails wilt ophalen.',
        'Trusted' => 'Vertrouwd',
        'Dispatching' => 'Sortering',
        'Edit Mail Account' => 'Bewerk mail account',

        # Template: AdminNavigationBar
        'Admin' => 'Beheer',
        'Agent Management' => 'Beheer behandelaars',
        'Queue Settings' => 'Wachtrij instellingen',
        'Ticket Settings' => 'Ticket instellingen',
        'System Administration' => 'Beheer systeem',

        # Template: AdminNotification
        'Notification Management' => 'Melding beheer',
        'Select a different language' => 'Kies een andere taal',
        'Filter for Notification' => 'Filter op meldingen',
        'Notifications are sent to an agent or a customer.' => 'Meldingen worden verstuurd naar een behandelaar.',
        'Notification' => 'Melding',
        'Edit Notification' => 'Bewerk melding',
        'e. g.' => 'bijv.',
        'Options of the current customer data' => 'Attributen van de klant',

        # Template: AdminNotificationEvent
        'Add notification' => 'Melding toevoegen',
        'Delete this notification' => 'Melding verwijderen',
        'Add Notification' => 'Melding toevoegen',
        'Recipient groups' => 'Ontvanger groepen',
        'Recipient agents' => 'Ontvanger behandelaars',
        'Recipient roles' => 'Ontvanger rollen',
        'Recipient email addresses' => 'Ontvanger e-mailadressen',
        'Article type' => 'Soort interactie',
        'Only for ArticleCreate event' => 'Alleen bij ArticleCreate gebeurtenis',
        'Article sender type' => 'Soort verzender',
        'Subject match' => 'Onderwerp',
        'Body match' => 'Bericht tekst',
        'Include attachments to notification' => 'Voeg bijlagen toe aan melding',
        'Notification article type' => 'Interactiesoort voor melding',
        'Only for notifications to specified email addresses' => 'Alleen voor meldingen aan een specifiek e-mail adres',
        'To get the first 20 character of the subject (of the latest agent article).' =>
            'Om de eerste 20 karakters van het onderwerp van de nieuwste behandelaars-interactie te tonen.',
        'To get the first 5 lines of the body (of the latest agent article).' =>
            'Om de eerste vijf regels van de tekst van de nieuwste behandelaars-interactie te tonen.',
        'To get the first 20 character of the subject (of the latest customer article).' =>
            'Om de eerste 20 karakters van het onderwerp van de nieuwste klant-interactie te tonen.',
        'To get the first 5 lines of the body (of the latest customer article).' =>
            'Om de eerste vijf regels van de tekst van de nieuwste klant-interactie te tonen.',

        # Template: AdminPGP
        'PGP Management' => 'PGP beheer',
        'Use this feature if you want to work with PGP keys.' => 'Gebruik deze feature als u e-mail wilt versleutelen met PGP.',
        'Add PGP key' => 'PGP sleutel toevoegen',
        'In this way you can directly edit the keyring configured in SysConfig.' =>
            'Hier kunt u de keyring beheren die is ingesteld in de systeemconfiguratie.',
        'Introduction to PGP' => 'Introductie tot PGP',
        'Result' => 'Resultaat',
        'Identifier' => 'Identifier',
        'Bit' => 'Bit',
        'Fingerprint' => 'Fingerprint',
        'Expires' => 'Verloopt',
        'Delete this key' => 'Verwijder deze sleutel',
        'Add PGP Key' => 'PGP sleutel toevoegen',
        'PGP key' => 'PGP sleutel',

        # Template: AdminPackageManager
        'Package Manager' => 'Pakketbeheer',
        'Uninstall package' => 'Verwijder pakket',
        'Do you really want to uninstall this package?' => 'Wilt u dit pakket echt verwijderen?',
        'Reinstall package' => 'Herinstalleer pakket',
        'Do you really want to reinstall this package? Any manual changes will be lost.' =>
            'Wilt u dit pakket echt herinstalleren? Eventuele handmatige aanpassingen gaan verloren.',
        'Continue' => 'Doorgaan',
        'Install' => 'Installeer',
        'Install Package' => 'Installeer pakket',
        'Update repository information' => 'Vernieuw repository gegevens',
        'Did not find a required feature? OTRS Group provides their service contract customers with exclusive Add-Ons:' =>
            '',
        'Online Repository' => 'Online Repository',
        'Vendor' => 'Leverancier',
        'Module documentation' => 'Moduledocumentatie',
        'Upgrade' => 'Upgrade',
        'Local Repository' => 'Lokale Repository',
        'Uninstall' => 'Verwijder',
        'Reinstall' => 'Herinstalleer',
        'Feature Add-Ons' => 'Feature Add-Ons',
        'Download package' => 'Download pakket',
        'Rebuild package' => 'Genereer pakket opnieuw',
        'Metadata' => 'Metadata',
        'Change Log' => 'Wijzigingen',
        'Date' => 'Datum',
        'List of Files' => 'Overzicht van bestanden',
        'Permission' => 'Permissie',
        'Download' => 'Downloaden',
        'Download file from package!' => 'Download bestand van pakket.',
        'Required' => 'Verplicht',
        'PrimaryKey' => 'Primaire sleutel',
        'AutoIncrement' => 'AutoIncrement',
        'SQL' => 'SQL statement',
        'File differences for file %s' => 'Verschillen in bestand %s',

        # Template: AdminPerformanceLog
        'Performance Log' => 'Performance log',
        'This feature is enabled!' => 'Deze functie is ingeschakeld.',
        'Just use this feature if you want to log each request.' => 'Activeer de Performance Log alleen als u ieder verzoek wilt loggen.',
        'Activating this feature might affect your system performance!' =>
            'Deze functie gaat zelf ook een beetje ten koste van de performance.',
        'Disable it here!' => 'Uitschakelen',
        'Logfile too large!' => 'Logbestand te groot.',
        'The logfile is too large, you need to reset it' => 'Het logbestand is te groot, u moet het resetten',
        'Overview' => 'Overzicht',
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

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => 'E-mail filterbeheer',
        'Add filter' => 'Nieuw filter',
        'To dispatch or filter incoming emails based on email headers. Matching using Regular Expressions is also possible.' =>
            'Om inkomende e-mails te routeren op basis van e-mail headers. Matching op tekst of met behulp van regular expressions.',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' =>
            'Als u alleen wilt filteren op het e-mailadres, gebruik dan EMAILADDRESS:info@example.local in Van, Aan of CC.',
        'If you use Regular Expressions, you also can use the matched value in () as [***] in the \'Set\' action.' =>
            'Als u regular expressions gebruikt dan kunt u ook de gevonden waarde tussen haakjes () gebruiken als [***] in de \'Set\' actie.',
        'Delete this filter' => 'Verwijder filter',
        'Add PostMaster Filter' => 'Nieuw e-mail filter',
        'Edit PostMaster Filter' => 'Bewerk e-mail filter',
        'Filter name' => 'Filter naam',
        'The name is required.' => 'De naam is verplicht.',
        'Stop after match' => 'Stop met filters na match',
        'Filter Condition' => 'Filter conditie',
        'The field needs to be a valid regular expression or a literal word.' =>
            'Dit veld kan een woord bevatten of een regular expression.',
        'Set Email Headers' => 'Nieuwe waarden',
        'The field needs to be a literal word.' => 'Dit veld moet een letterlijke waarde bevatten.',

        # Template: AdminPriority
        'Priority Management' => 'Prioriteitenbeheer',
        'Add priority' => 'Nieuwe prioriteit',
        'Add Priority' => 'Nieuwe prioriteit',
        'Edit Priority' => 'Bewerk prioriteit',

        # Template: AdminProcessManagement
        'Process Management' => 'Procesbeheer',
        'Filter for Processes' => 'Filter op processen',
        'Filter' => 'Filter',
        'Process Name' => 'Naam',
        'Create New Process' => 'Nieuw proces',
        'Synchronize All Processes' => 'Synchroniseer alle processen',
        'Configuration import' => 'Importeer configuratie',
        'Here you can upload a configuration file to import a process to your system. The file needs to be in .yml format as exported by process management module.' =>
            'Hier kunt u een proces importeren vanuit een configuratiebestand. Het bestand moet in .yml formaat zijn, zoals geëxporteerd door de procesbeheer-module.',
        'Upload process configuration' => 'Upload procesconfiguratie',
        'Import process configuration' => 'Importeer procesconfiguratie',
        'To create a new Process you can either import a Process that was exported from another system or create a complete new one.' =>
            'Om een nieuw proces aan te maken kunt u een bestand importeren, aangemaakt op een ander systeem, of een compleet nieuw proces aanmaken.',
        'Changes to the Processes here only affect the behavior of the system, if you synchronize the Process data. By synchronizing the Processes, the newly made changes will be written to the Configuration.' =>
            'Wijzigingen aan de processen hebben alleen invloed op het systeem als u de proces-data synchroniseert. Door het synchroniseren van de processen worden de wijzigingen weggeschreven naar de configuratie.',
        'Processes' => 'Processen',
        'Process name' => 'Naam',
        'Copy' => 'Kopiëer',
        'Print' => 'Afdrukken',
        'Export Process Configuration' => 'Exporteer procesconfiguratie',
        'Copy Process' => 'Kopiëer proces',

        # Template: AdminProcessManagementActivity
        'Cancel & close window' => 'Annuleren en scherm sluiten',
        'Go Back' => 'Terug',
        'Please note, that changing this activity will affect the following processes' =>
            'Let op: het wijzigen van deze activiteit heeft invloed op de volgende processen',
        'Activity' => 'Activiteit',
        'Activity Name' => 'Naam',
        'Activity Dialogs' => 'Dialogen',
        'You can assign Activity Dialogs to this Activity by dragging the elements with the mouse from the left list to the right list.' =>
            'U kunt dialogen toevoegen aan deze activiteit door de elementen met de muis van links naar rechts te slepen.',
        'Ordering the elements within the list is also possible by drag \'n\' drop.' =>
            'U kunt de elementen ook van volgorde te wijzigen door ze te slepen met de muis.',
        'Filter available Activity Dialogs' => 'Filter beschikbare dialogen',
        'Available Activity Dialogs' => 'Beschikbare dialogen',
        'Create New Activity Dialog' => 'Nieuwe dialoog',
        'Assigned Activity Dialogs' => 'Toegewezen dialogen',
        'As soon as you use this button or link, you will leave this screen and its current state will be saved automatically. Do you want to continue?' =>
            'Als u deze knop of link gebruikt, verlaat u dit scherm en de huidige staat wordt automatisch opgeslagen. Wilt u doorgaan?',

        # Template: AdminProcessManagementActivityDialog
        'Please note that changing this activity dialog will affect the following activities' =>
            'Let op: het wijzigen van deze dialoog heeft invoed op de volgende activiteiten',
        'Activity Dialog' => 'Dialoog',
        'Activity dialog Name' => 'Naam',
        'Available in' => 'Beschikbaar in',
        'Description (short)' => 'Beschrijving (kort)',
        'Description (long)' => 'Beschrijving (lang)',
        'The selected permission does not exist.' => 'De gekozen permissie bestaat niet.',
        'Required Lock' => 'Vergrendeling nodig',
        'The selected required lock does not exist.' => 'De gekozen vergrendeling bestaat niet.',
        'Submit Advice Text' => 'Verstuur-advies tekst',
        'Submit Button Text' => 'Tekst op Verstuur-knop',
        'Fields' => 'Velden',
        'You can assign Fields to this Activity Dialog by dragging the elements with the mouse from the left list to the right list.' =>
            'U kunt velden aan deze dialoog toevoegen door de elementen met de muis van links naar rechts te slepen.',
        'Filter available fields' => 'Filter beschikbare velden',
        'Available Fields' => 'Beschikbare velden',
        'Assigned Fields' => 'Toegewezen velden',
        'Edit Details for Field' => 'Bewerk details voor veld',
        'ArticleType' => 'Interactie-type',
        'Display' => 'Weergave',
        'Edit Field Details' => 'Bewerk veld-details',
        'Customer interface does not support internal article types.' => '',

        # Template: AdminProcessManagementPath
        'Path' => 'Pad',
        'Edit this transition' => 'Bewerk transitie',
        'Transition Actions' => 'Transitie-acties',
        'You can assign Transition Actions to this Transition by dragging the elements with the mouse from the left list to the right list.' =>
            'U kunt transitie-acties aan deze transitie toevoegen door de elementen met de muis van links naar rechts te slepen.',
        'Filter available Transition Actions' => 'Filter beschikbare transitie-acties',
        'Available Transition Actions' => 'Beschikbare transitie-acties',
        'Create New Transition Action' => 'Nieuwe transitie-actie',
        'Assigned Transition Actions' => 'Gekoppelde transitie-acties',

        # Template: AdminProcessManagementPopupResponse

        # Template: AdminProcessManagementProcessAccordion
        'Activities' => 'Activiteiten',
        'Filter Activities...' => 'Filter activiteiten',
        'Create New Activity' => 'Nieuwe activiteit',
        'Filter Activity Dialogs...' => 'Filter dialogen...',
        'Transitions' => 'Transities',
        'Filter Transitions...' => 'Filter transities...',
        'Create New Transition' => 'Nieuwe transitie',
        'Filter Transition Actions...' => 'Filter transitie-acties...',

        # Template: AdminProcessManagementProcessEdit
        'Edit Process' => 'Bewerk proces',
        'Print process information' => 'Print proces',
        'Delete Process' => 'Verwijder proces',
        'Delete Inactive Process' => 'Verwijder inactief proces',
        'Available Process Elements' => 'Beschikbare proces-elementen',
        'The Elements listed above in this sidebar can be moved to the canvas area on the right by using drag\'n\'drop.' =>
            'De elementen hierboven kunnen verplaatst worden naar de canvas aan de rechterzijde door middel van slepen.',
        'You can place Activities on the canvas area to assign this Activity to the Process.' =>
            'U kunt activiteiten op de canvas plaatsen om ze toe te wijzen aan dit proces.',
        'To assign an Activity Dialog to an Activity drop the Activity Dialog element from this sidebar over the Activity placed in the canvas area.' =>
            'Om een dialoog toe te voegen aan een activiteit sleept u de dialoog uit deze lijst naar de activiteit geplaatst op de canvas.',
        'You can start a connection between to Activities by dropping the Transition element over the Start Activity of the connection. After that you can move the loose end of the arrow to the End Activity.' =>
            'U kunt een verbinding maken tussen activiteiten door de transitie op de start-actiiteit te slepen. Daarna kunt u het losse einde van de pijl naar de eind-activiteit slepen.',
        'Actions can be assigned to a Transition by dropping the Action Element onto the label of a Transition.' =>
            'Acties kunnen gekoppeld worden aan een transitie door het actie-element naar het label van een transitie te slepen.',
        'Edit Process Information' => 'Bewerk proces-informatie',
        'The selected state does not exist.' => 'De geselecteerde status bestaat niet.',
        'Add and Edit Activities, Activity Dialogs and Transitions' => 'Beheren activiteiten, dialogen en transities',
        'Show EntityIDs' => 'Toon ID\'s',
        'Extend the width of the Canvas' => 'Vergroot de breedte van de canvas',
        'Extend the height of the Canvas' => 'Vergroot de hoogte van de canvas',
        'Remove the Activity from this Process' => 'Verwijder de activiteit uit dit proces',
        'Edit this Activity' => '',
        'Do you really want to delete this Process?' => 'Wilt u dit proces verwijderen?',
        'Do you really want to delete this Activity?' => 'Wilt u deze activiteit verwijderen?',
        'Do you really want to delete this Activity Dialog?' => 'Wilt u deze dialoog verwijderen?',
        'Do you really want to delete this Transition?' => 'Wilt u deze transitie verwijderen?',
        'Do you really want to delete this Transition Action?' => 'Wilt u deze transitie-actie verwijderen?',
        'Do you really want to remove this activity from the canvas? This can only be undone by leaving this screen without saving.' =>
            'Wilt u deze activiteit van de canvas verwijderen? Dit kan alleen ongedaan worden gemaakt door dit scherm te verlaten zonder opslaan.',
        'Do you really want to remove this transition from the canvas? This can only be undone by leaving this screen without saving.' =>
            'Wilt u deze transitie van de canvas verwijderen? Dit kan alleen ongedaan worden gemaakt door dit scherm te verlaten zonder opslaan.',
        'Hide EntityIDs' => 'Verberg ID\'s',
        'Delete Entity' => 'Verwijderen',
        'Remove Entity from canvas' => 'Verwijder van canvas',
        'This Activity is already used in the Process. You cannot add it twice!' =>
            'Deze activiteit wordt al gebruikt in dit proces. U kunt het niet tweemaal gebruiken.',
        'This Activity cannot be deleted because it is the Start Activity.' =>
            'Deze activiteit kan niet worden verwijderd omdat het de start-activiteit is.',
        'This Transition is already used for this Activity. You cannot use it twice!' =>
            'Deze transitie wordt al gebruikt in deze activiteit. U kunt het niet tweemaal gebruiken.',
        'This TransitionAction is already used in this Path. You cannot use it twice!' =>
            'Deze transitie-actie wordt al gebruikt in dit pad. U kunt het niet tweemaal gebruiken.',
        'Remove the Transition from this Process' => '',
        'No TransitionActions assigned.' => 'Geen transitie-acties toegewezen.',
        'The Start Event cannot loose the Start Transition!' => 'Het start-event kan niet de start-transitie kwijtraken.',
        'No dialogs assigned yet. Just pick an activity dialog from the list on the left and drag it here.' =>
            'Er zijn nog geen dialogen toegewezen. Kies een dialoog uit de lijst en sleep deze hiernaartoe.',
        'An unconnected transition is already placed on the canvas. Please connect this transition first before placing another transition.' =>
            '',

        # Template: AdminProcessManagementProcessNew
        'In this screen, you can create a new process. In order to make the new process available to users, please make sure to set its state to \'Active\' and synchronize after completing your work.' =>
            'In dit scherm kunt u een nieuw proces aanmaken. Om het nieuwe proces beschikbaar te maken voor uw gebruikers moet u de status op \'Actief\' zetten en vervolgens een synchronisatie uitvoeren.',

        # Template: AdminProcessManagementProcessPrint
        'Start Activity' => 'Start activiteit',
        'Contains %s dialog(s)' => 'Bevat %s dialoog(en)',
        'Assigned dialogs' => 'Toegewezen dialogen',
        'Activities are not being used in this process.' => 'Er zijn geen activiteiten in dit proces.',
        'Assigned fields' => 'Toegewezen velden',
        'Activity dialogs are not being used in this process.' => 'Er zijn geen dialogen in dit proces.',
        'Condition linking' => 'Condities koppelen',
        'Conditions' => 'Condities',
        'Condition' => 'Conditie',
        'Transitions are not being used in this process.' => 'Er zijn geen overgangen in dit proces.',
        'Module name' => 'Modulenaam',
        'Configuration' => 'Configuratie',
        'Transition actions are not being used in this process.' => 'Er zijn geen transitie-acties in dit proces.',

        # Template: AdminProcessManagementTransition
        'Please note that changing this transition will affect the following processes' =>
            'Let op: het wijzigen van deze transitie heeft invloed op de volgende processen',
        'Transition' => 'Transitie',
        'Transition Name' => 'Naam',
        'Type of Linking between Conditions' => 'Type koppeling tussen condities',
        'Remove this Condition' => 'Verwijder conditie',
        'Type of Linking' => 'Type koppeling',
        'Remove this Field' => 'Verwijder dit veld',
        'Add a new Field' => 'Nieuw veld',
        'Add New Condition' => 'Nieuwe conditie',

        # Template: AdminProcessManagementTransitionAction
        'Please note that changing this transition action will affect the following processes' =>
            'Let op: het wijzigen van deze transitie-actie heeft invloed op de volgende processen',
        'Transition Action' => 'Transitie-actie',
        'Transition Action Name' => 'Naam',
        'Transition Action Module' => 'Transitie-actiemodule',
        'Config Parameters' => 'Configuratie',
        'Remove this Parameter' => 'Verwijder deze parameter',
        'Add a new Parameter' => 'Nieuwe parameter',

        # Template: AdminQueue
        'Manage Queues' => 'Wachtrijenbeheer',
        'Add queue' => 'Nieuwe wachtrij',
        'Add Queue' => 'Nieuwe wachtrij',
        'Edit Queue' => 'Bewerk wachtrij',
        'Sub-queue of' => 'Onderdeel van',
        'Unlock timeout' => 'Ontgrendel tijdsoverschrijding',
        '0 = no unlock' => '0 = geen ontgrendeling',
        'Only business hours are counted.' => 'Alleen openingstijden tellen mee.',
        'If an agent locks a ticket and does not close it before the unlock timeout has passed, the ticket will unlock and will become available for other agents.' =>
            'Als een ticket vergrendeld is en de behandelaar handelt het ticket niet af voor het verstrijken van de tijdsoverschrijding, wordt het ticket automatisch ontgrendeld en komt deze weer beschikbaar voor andere gebruikers.',
        'Notify by' => 'Melding bij',
        '0 = no escalation' => '0 = geen escalatie',
        'If there is not added a customer contact, either email-external or phone, to a new ticket before the time defined here expires, the ticket is escalated.' =>
            'Als er geen klant naam, het externe e-mail of telefoon, bekend is voor de hier ingestelde tijd dan wordt het ticket geëscaleerd.',
        'If there is an article added, such as a follow-up via email or the customer portal, the escalation update time is reset. If there is no customer contact, either email-external or phone, added to a ticket before the time defined here expires, the ticket is escalated.' =>
            'Als er iets wordt toegevoegd aan het ticket, b.v. een reactie per e-mail of via het web, dan zal de escalatie update tijd worden gereset. Als er geen klantencontact plaatsvindt, per e-mail of telefoon, voor de hier gedefiniëerde tijd, dan wordt het ticket geëscaleerd.',
        'If the ticket is not set to closed before the time defined here expires, the ticket is escalated.' =>
            'Als het ticket niet is afgesloten voor de hier gedefiniëerde tijd, dan wordt het ticket geëscaleerd.',
        'Follow up Option' => 'Reactie optie',
        'Specifies if follow up to closed tickets would re-open the ticket, be rejected or lead to a new ticket.' =>
            'Bepaalt of reacties op gesloten tickets zorgen voor heropenen voor het ticket, geweigerd wordt, of een nieuw ticket genereert.',
        'Ticket lock after a follow up' => 'Ticket wordt vergrendeld na een reactie',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked to the old owner.' =>
            'Als een ticket gesloten is en de klant een reactie stuurt dan wordt het ticket gekoppeld aan de oude eigenaar.',
        'System address' => 'Systeem adres',
        'Will be the sender address of this queue for email answers.' => 'Is het afzenderadres van deze wachtrij voor antwoorden per e-mail.',
        'Default sign key' => 'Standaard sleutel voor ondertekening.',
        'The salutation for email answers.' => 'De aanhef voor beantwoording van berichten per e-mail.',
        'The signature for email answers.' => 'De ondertekening voor beantwoording van berichten per e-mail.',

        # Template: AdminQueueAutoResponse
        'Manage Queue-Auto Response Relations' => 'Beheer Wachtrij - Automatische antwoorden koppelingen',
        'Filter for Queues' => 'Filter op wachtrijen',
        'Filter for Auto Responses' => 'Filter op automatische antwoorden',
        'Auto Responses' => 'Automatische antwoorden',
        'Change Auto Response Relations for Queue' => 'Bewerk automatische antwoorden voor wachtrij',
        'settings' => 'instellingen',

        # Template: AdminQueueResponses
        'Manage Response-Queue Relations' => 'Beheer Antwoord - Wachtrij koppelingen',
        'Filter for Responses' => 'Filter op antwoorden',
        'Responses' => 'Standaard-antwoorden',
        'Change Queue Relations for Response' => 'Bewerk gekoppelde wachtrijen voor antwoord',
        'Change Response Relations for Queue' => 'Bewerk gekoppelde antwoorden voor wachtrij',

        # Template: AdminResponse
        'Manage Responses' => 'Beheer Antwoorden',
        'Add response' => 'Nieuw antwoord',
        'A response is a default text which helps your agents to write faster answers to customers.' =>
            'Een antwoord is een standaard-tekst die uw behandelaars helpt sneller te reageren op tickets van klanten.',
        'Don\'t forget to add new responses to queues.' => 'Vergeet niet om antwoorden aan wachtrijen toe te wijzen.',
        'Delete this entry' => 'Verwijder antwoord',
        'Add Response' => 'Nieuw antwoord',
        'Edit Response' => 'Bewerk antwoord',
        'The current ticket state is' => 'De huidige ticketstatus is',
        'Your email address is' => 'Uw e-mailadres is',

        # Template: AdminResponseAttachment
        'Manage Responses <-> Attachments Relations' => 'Beheer Antwoorden <-> Bijlagen',
        'Filter for Attachments' => 'Filter op bijlagen',
        'Change Response Relations for Attachment' => 'Bewerk gekoppelde antwoorden voor attachment',
        'Change Attachment Relations for Response' => 'Bewerk gekoppelde attachments voor antwoord',
        'Toggle active for all' => 'Actief aan/uit voor alles',
        'Link %s to selected %s' => 'Koppel %s aan %s',

        # Template: AdminRole
        'Role Management' => 'Beheer rollen',
        'Add role' => 'Nieuwe rol',
        'Create a role and put groups in it. Then add the role to the users.' =>
            'Maak een nieuwe rol en koppel deze aan groepen. Vervolgens kunt u rollen toewijzen aan gebruikers.',
        'There are no roles defined. Please use the \'Add\' button to create a new role.' =>
            'Er zijn geen rollen gedefiniëerd. Maak een nieuwe aan.',
        'Add Role' => 'Nieuwe rol',
        'Edit Role' => 'Bewerk rol',

        # Template: AdminRoleGroup
        'Manage Role-Group Relations' => 'Beheer Rol-Groep koppelingen',
        'Filter for Roles' => 'Filter op rollen',
        'Roles' => 'Rollen',
        'Select the role:group permissions.' => 'Selecteer de rol-groep permissies.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the role).' =>
            'Als niets is geselecteerd, heeft deze rol geen permissies op deze groep.',
        'Change Role Relations for Group' => 'Bewerk gekoppelde rollen voor groep',
        'Change Group Relations for Role' => 'Bewerk gekoppelde groepen voor rol',
        'Toggle %s permission for all' => 'Permissies %s aan/uit',
        'move_into' => 'verplaats naar',
        'Permissions to move tickets into this group/queue.' => 'Permissies om tickets naar deze groep/wachtrij te verplaatsen.',
        'create' => 'aanmaken',
        'Permissions to create tickets in this group/queue.' => 'Permissies om tickets in deze groep/wachtrij aan te maken.',
        'priority' => 'prioriteit',
        'Permissions to change the ticket priority in this group/queue.' =>
            'Permissies om de prioriteit van een ticket in deze groep/wachtrij te wijzigen.',

        # Template: AdminRoleUser
        'Manage Agent-Role Relations' => 'Beheer Behandelaar-Rol koppelingen',
        'Filter for Agents' => 'Filter op behandelaars',
        'Agents' => 'Behandelaars',
        'Manage Role-Agent Relations' => 'Beheer Rol-Behandelaar koppelingen',
        'Change Role Relations for Agent' => 'Bewerk gekoppelde rollen voor behandelaar',
        'Change Agent Relations for Role' => 'Bewerk gekoppelde behandelaars voor rol',

        # Template: AdminSLA
        'SLA Management' => 'SLA beheer',
        'Add SLA' => 'Nieuwe SLA',
        'Edit SLA' => 'Bewerk SLA',
        'Please write only numbers!' => 'Gebruik alleen cijfers.',

        # Template: AdminSMIME
        'S/MIME Management' => 'S/MIME beheer',
        'Add certificate' => 'Nieuw certificaat',
        'Add private key' => 'Private sleutel toevoegen',
        'Filter for certificates' => 'Filter op certificaten',
        'Filter for SMIME certs' => 'Filter op SMIME certificaten',
        'Here you can add relations to your private certificate, these will be embedded to the SMIME signature every time you use this certificate to sign an email.' =>
            'Hier kunt u koppelingen naar uw private sleutels toevoegen. Deze worden ingesloten in SMIME handtekeningen iedere keer als u dit certificaat gebruikt om een e-mail te ondertekenen.',
        'See also' => 'Zie voor meer informatie',
        'In this way you can directly edit the certification and private keys in file system.' =>
            'Hier kunt u de certificaten en private sleutels van OTRS beheren.',
        'Hash' => 'Hash',
        'Create' => 'Aanmaken',
        'Handle related certificates' => 'Beheer gekoppelde certificaten',
        'Read certificate' => 'Lees certificaat',
        'Delete this certificate' => 'Verwijder certificaat',
        'Add Certificate' => 'Nieuw certificaat',
        'Add Private Key' => 'Nieuwe private sleutel',
        'Secret' => 'Geheim',
        'Related Certificates for' => 'Gekoppelde certificaten voor',
        'Delete this relation' => 'Verwijder deze koppeling',
        'Available Certificates' => 'Beschikbare certificaten',
        'Relate this certificate' => 'Koppel dit certificaat',

        # Template: AdminSMIMECertRead
        'SMIME Certificate' => 'S/MIME certificaat',
        'Close window' => 'Sluit venster',

        # Template: AdminSalutation
        'Salutation Management' => 'Beheer aanheffen',
        'Add salutation' => 'Nieuwe aanhef',
        'Add Salutation' => 'Nieuwe aanhef',
        'Edit Salutation' => 'Bewerk aanhef',
        'Example salutation' => 'Aanhef voorbeeld',

        # Template: AdminScheduler
        'This option will force Scheduler to start even if the process is still registered in the database' =>
            'Deze optie zorgt ervoor dat de Scheduler gestart wordt, ook als het proces nog geregistreerd is in de database',
        'Start scheduler' => 'Start Scheduler',
        'Scheduler could not be started. Check if scheduler is not running and try it again with Force Start option' =>
            'De Scheduler kon niet worden gestart. Verifiëer of de Scheduler niet actief is en probeer opnieuw met de Forceer Start-optie.',

        # Template: AdminSecureMode
        'Secure mode needs to be enabled!' => 'Secure Mode is niet actief.',
        'Secure mode will (normally) be set after the initial installation is completed.' =>
            'Secure Mode wordt normaal gesproken geactiveerd na afronding van de installatie.',
        'If secure mode is not activated, activate it via SysConfig because your application is already running.' =>
            'Als Secure Mode nog niet actief is activeer dit via de Systeemconfiguratie omdat de applicatie al draait.',

        # Template: AdminSelectBox
        'SQL Box' => 'SQL console',
        'Here you can enter SQL to send it directly to the application database.' =>
            'Hier kunt u SQL statements invoeren die direct door de database worden uitgevoerd.',
        'The syntax of your SQL query has a mistake. Please check it.' =>
            'De syntax van uw SQL query bevat een fout.',
        'There is at least one parameter missing for the binding. Please check it.' =>
            'Er mist tenminste een parameter.',
        'Result format' => 'Uitvoeren naar',
        'Run Query' => 'Uitvoeren',

        # Template: AdminService
        'Service Management' => 'Service beheer',
        'Add service' => 'Nieuwe service',
        'Add Service' => 'Nieuwe service',
        'Edit Service' => 'Bewerk Service',
        'Sub-service of' => 'Onderdeel van',

        # Template: AdminSession
        'Session Management' => 'Sessies',
        'All sessions' => 'Alle sessies',
        'Agent sessions' => 'Behandelaar-sessies',
        'Customer sessions' => 'Klant-sessies',
        'Unique agents' => 'Unieke behandelaars',
        'Unique customers' => 'Unieke klanten',
        'Kill all sessions' => 'Alle sessies verwijderen',
        'Kill this session' => 'Verwijder deze sessie',
        'Session' => 'Sessie',
        'Kill' => 'Verwijder',
        'Detail View for SessionID' => 'Details',

        # Template: AdminSignature
        'Signature Management' => 'Handtekening-beheer',
        'Add signature' => 'Nieuwe handtekening',
        'Add Signature' => 'Nieuwe handtekening',
        'Edit Signature' => 'Bewerk handtekening',
        'Example signature' => 'Handtekening-voorbeeld',

        # Template: AdminState
        'State Management' => 'Status beheer',
        'Add state' => 'Nieuwe status',
        'Please also update the states in SysConfig where needed.' => 'Pas ook de namen van de status aan in SysConfig waar nodig.',
        'Add State' => 'Nieuwe status',
        'Edit State' => 'Bewerk status',
        'State type' => 'Status type',

        # Template: AdminSysConfig
        'SysConfig' => 'Systeemconfiguratie',
        'Navigate by searching in %s settings' => 'Doorzoek %s instellingen',
        'Navigate by selecting config groups' => 'Navigeer door groepen te kiezen',
        'Download all system config changes' => 'Download alle aanpassingen in de systeemconfiguratie',
        'Export settings' => 'Exporteer configuratie',
        'Load SysConfig settings from file' => 'Laad configuratie uit bestand',
        'Import settings' => 'Importeer configuratie',
        'Import Settings' => 'Importeer configuratie',
        'Please enter a search term to look for settings.' => 'Geef een zoekterm op.',
        'Subgroup' => 'Subgroep',
        'Elements' => 'Elementen',

        # Template: AdminSysConfigEdit
        'Edit Config Settings' => 'Bewerk systeemconfiguratie',
        'This config item is only available in a higher config level!' =>
            'Dit configuratieitem is alleen beschikbaar op een hoger configuratieniveau.',
        'Reset this setting' => 'Terug naar standaard',
        'Error: this file could not be found.' => 'Fout: dit bestand is niet gevonden.',
        'Error: this directory could not be found.' => 'Fout: deze map niet gevonden.',
        'Error: an invalid value was entered.' => 'Fout: een ongeldige waarde is ingegeven.',
        'Content' => 'Inhoud',
        'Remove this entry' => 'Verwijder deze sleutel',
        'Add entry' => 'Sleutel toevoegen',
        'Remove entry' => 'Verwijder sleutel',
        'Add new entry' => 'Nieuwe sleutel toevoegen',
        'Create new entry' => 'Nieuwe sleutel toevoegen',
        'New group' => 'Nieuwe groep',
        'Group ro' => 'Alleen-lezen groep',
        'Readonly group' => 'Alleen-lezen groep',
        'New group ro' => 'Nieuwe alleen-lezen groep',
        'Loader' => 'Loader',
        'File to load for this frontend module' => 'Bestand om te laden voor deze frontend module',
        'New Loader File' => 'Nieuw bestand voor Loader',
        'NavBarName' => 'Titel navigatiebalk',
        'NavBar' => 'Navigatiebalk',
        'LinkOption' => 'Link',
        'Block' => 'Blok',
        'AccessKey' => 'Sneltoetskoppeling',
        'Add NavBar entry' => 'Navigatiebalk item toevoegen',
        'Year' => 'Jaar',
        'Month' => 'Maand',
        'Day' => 'Dag',
        'Invalid year' => 'Ongeldig jaar',
        'Invalid month' => 'Ongeldige maand',
        'Invalid day' => 'Ongeldige dag',

        # Template: AdminSystemAddress
        'System Email Addresses Management' => 'Systeem e-mailadressen beheer',
        'Add system address' => 'Nieuw e-mailadres',
        'All incoming email with this address in To or Cc will be dispatched to the selected queue.' =>
            'Alle inkomende berichten met dit adres in Aan of CC worden toegewezen aan de geselecteerde wachtrij.',
        'Email address' => 'E-mailadres',
        'Display name' => 'Weergegeven naam',
        'Add System Email Address' => 'Nieuw e-mailadres',
        'Edit System Email Address' => 'Bewerk e-mailadres',
        'The display name and email address will be shown on mail you send.' =>
            'De weergegeven naam en het e-mailadres worden gebruikt voor uitgaande mail.',

        # Template: AdminType
        'Type Management' => 'Type beheer',
        'Add ticket type' => 'Nieuw ticket type',
        'Add Type' => 'Nieuw type',
        'Edit Type' => 'Bewerk type',

        # Template: AdminUser
        'Add agent' => 'Nieuwe behandelaar',
        'Agents will be needed to handle tickets.' => 'Behandelaar-accounts zijn nodig om te kunnen werken in het systeem.',
        'Don\'t forget to add a new agent to groups and/or roles!' => 'vergeet niet om een behandelaar aan groepen en/of rollen te koppelen.',
        'Please enter a search term to look for agents.' => 'Typ om te zoeken naar behandelaars.',
        'Last login' => 'Laatst ingelogd',
        'Switch to agent' => 'Omschakelen naar behandelaar',
        'Add Agent' => 'Nieuwe behandelaar',
        'Edit Agent' => 'Bewerk behandelaar',
        'Firstname' => 'Voornaam',
        'Lastname' => 'Achternaam',
        'Password is required.' => 'Wachtwoord is verplicht.',
        'Start' => 'Begin',
        'End' => 'Einde',

        # Template: AdminUserGroup
        'Manage Agent-Group Relations' => 'Beheer Behandelaar-Groep koppelingen',
        'Change Group Relations for Agent' => 'Bewerk gekoppelde groepen voor behandelaar',
        'Change Agent Relations for Group' => 'Bewerk gekoppelde behandelaars voor groep',
        'note' => 'notitie',
        'Permissions to add notes to tickets in this group/queue.' => 'Permissies om notities aan tickets in de wachtrijen behorende bij deze groep toe te voegen.',
        'owner' => 'eigenaar',
        'Permissions to change the owner of tickets in this group/queue.' =>
            'Permissies om de eigenaar van de tickets in de wachtrijen behorende bij deze groep te wijzigen.',

        # Template: AgentBook
        'Address Book' => 'Adresboek',
        'Search for a customer' => 'Zoek naar een klant',
        'Add email address %s to the To field' => 'Voeg e-mailadres %s toe aan het Aan-veld',
        'Add email address %s to the Cc field' => 'Voeg e-mailadres %s toe aan het CC-veld',
        'Add email address %s to the Bcc field' => 'Voeg e-mailadres %s toe aan het BCC-veld',
        'Apply' => 'Toepassen',

        # Template: AgentCustomerInformationCenter
        'Customer Information Center' => 'Klantinformatie overzicht',

        # Template: AgentCustomerInformationCenterBlank

        # Template: AgentCustomerInformationCenterSearch
        'Customer ID' => 'Klant ID',
        'Customer User' => 'Klant',

        # Template: AgentCustomerSearch
        'Search Customer' => 'Klanten zoeken',
        'Duplicated entry' => 'Dubbel adres',
        'This address already exists on the address list.' => 'Dit adres is al toegevoegd.',
        'It is going to be deleted from the field, please try again.' => 'Het wordt verwijderd van dit veld, probeer opnieuw.',

        # Template: AgentCustomerTableView

        # Template: AgentDashboard
        'Dashboard' => 'Dashboard',

        # Template: AgentDashboardCalendarOverview
        'in' => 'over',

        # Template: AgentDashboardCustomerCompanyInformation

        # Template: AgentDashboardCustomerIDStatus
        'Escalated tickets' => 'Geëscaleerde tickets',

        # Template: AgentDashboardCustomerUserList
        'Customer information' => 'Klantinformatie',
        'Phone ticket' => 'Telefoon-ticket',
        'Email ticket' => 'E-mail-ticket',
        '%s open ticket(s) of %s' => '%s open ticket(s) van %s',
        '%s closed ticket(s) of %s' => '%s gesloten ticket(s) van %s',
        'New phone ticket from %s' => 'Nieuw telefoonticket van %s',
        'New email ticket to %s' => 'Nieuw emailticket aan %s',

        # Template: AgentDashboardIFrame

        # Template: AgentDashboardImage

        # Template: AgentDashboardProductNotify
        '%s %s is available!' => '%s %s is beschikbaar.',
        'Please update now.' => 'Voer nu een update uit.',
        'Release Note' => 'Releasenote',
        'Level' => 'Soort',

        # Template: AgentDashboardRSSOverview
        'Posted %s ago.' => 'Geplaatst %s geleden.',

        # Template: AgentDashboardTicketGeneric
        'My locked tickets' => 'Mijn vergrendelde tickets',
        'My watched tickets' => 'Mijn gevolgde tickets',
        'My responsibilities' => 'Tickets waarvoor ik verantwoordelijk ben',
        'Tickets in My Queues' => 'Tickets in mijn wachtrijen',

        # Template: AgentDashboardTicketStats

        # Template: AgentDashboardUserOnline
        'out of office' => 'afwezigheid',

        # Template: AgentDashboardUserOutOfOffice
        'until' => 'tot',

        # Template: AgentHTMLReferenceForms

        # Template: AgentHTMLReferenceOverview

        # Template: AgentHTMLReferencePageLayout
        'The ticket has been locked' => 'Het ticket is vergrendeld',
        'Undo & close window' => 'Annuleren en scherm sluiten',

        # Template: AgentInfo
        'Info' => 'Informatie',
        'To accept some news, a license or some changes.' => 'Om een tekst te tonen, zoals nieuws of een licentie, die de agent moet accepteren.',

        # Template: AgentLinkObject
        'Link Object: %s' => 'Koppel object: %s',
        'go to link delete screen' => 'ga naar koppeling-verwijder scherm',
        'Select Target Object' => 'Selecteer doel',
        'Link Object' => 'Koppel object',
        'with' => 'met',
        'Unlink Object: %s' => 'Ontkoppel object',
        'go to link add screen' => 'ga naar koppelscherm',

        # Template: AgentNavigationBar

        # Template: AgentPreferences
        'Edit your preferences' => 'Bewerk uw voorkeuren',

        # Template: AgentSpelling
        'Spell Checker' => 'Spellingcontrole',
        'spelling error(s)' => 'Spelfout(en)',
        'Apply these changes' => 'Pas deze wijzigingen toe',

        # Template: AgentStatsDelete
        'Delete stat' => 'Verwijder rapport',
        'Stat#' => 'Rapport#',
        'Do you really want to delete this stat?' => 'Wilt u dit rapport echt verwijderen?',

        # Template: AgentStatsEditRestrictions
        'Step %s' => 'Stap %s',
        'General Specifications' => 'Algemene Instellingen',
        'Select the element that will be used at the X-axis' => 'Selecteer het element wat gebruikt wordt op de X-as',
        'Select the elements for the value series' => 'Selecteer de elementen voor de Y-as',
        'Select the restrictions to characterize the stat' => 'Selecteer de zoekrestricties voor dit rapport',
        'Here you can make restrictions to your stat.' => 'Hier kunt u beperkingen voor dit rapport opgeven.',
        'If you remove the hook in the "Fixed" checkbox, the agent generating the stat can change the attributes of the corresponding element.' =>
            'Als u het vinkje bij \'Statisch\' weghaalt, kunnen gebruikers de attributen van het bijbehorende element aanpassen bij het genereren van de rapporten.',
        'Fixed' => 'Statisch',
        'Please select only one element or turn off the button \'Fixed\'.' =>
            'Kies een element, of schakel de optie \'Statisch\' uit.',
        'Absolute Period' => 'Absolute periode',
        'Between' => 'Tussen',
        'Relative Period' => 'Relatieve periode',
        'The last' => 'De laatste',
        'Finish' => 'Voltooien',

        # Template: AgentStatsEditSpecification
        'Permissions' => 'Permissies',
        'You can select one or more groups to define access for different agents.' =>
            'U kunt één of meerdere groepen definiëren die deze rapportage kunnen gebruiken.',
        'Some result formats are disabled because at least one needed package is not installed.' =>
            'Sommige formaten worden niet getoond omdat de juiste bibliotheken niet zijn geïnstalleerd. Vraag uw beheerder.',
        'Please contact your administrator.' => 'Neem contact op met uw beheerder.',
        'Graph size' => 'Grootte',
        'If you use a graph as output format you have to select at least one graph size.' =>
            'Als u een afbeelding als vorm heeft gekozen moet u tenminste één grootte selecteren.',
        'Sum rows' => 'Toon totaal per rij',
        'Sum columns' => 'Toon totaal per kolom',
        'Use cache' => 'Gebruik buffer',
        'Most of the stats can be cached. This will speed up the presentation of this stat.' =>
            'De meeste rapporten kunnen worden gebufferd, dit versnelt het genereren van het rapport.',
        'If set to invalid end users can not generate the stat.' => 'Als deze op ongeldig staat, kan het rapport niet gebruikt worden.',

        # Template: AgentStatsEditValueSeries
        'Here you can define the value series.' => 'Hier kunt u de waarden voor de Y-as kiezen.',
        'You have the possibility to select one or two elements.' => 'U kunt één of twee elementen kiezen.',
        'Then you can select the attributes of elements.' => 'Vervolgens kunt u de getoonde attributen van de elementen kiezen.',
        'Each attribute will be shown as single value series.' => 'Ieder attribuut wordt getoond als een eigen waarde.',
        'If you don\'t select any attribute all attributes of the element will be used if you generate a stat, as well as new attributes which were added since the last configuration.' =>
            'Als u geen waarde kiest worden alle attributen van het element gebruikt bij het genereren van het rapport.',
        'Scale' => 'Schaal',
        'minimal' => 'minimaal',
        'Please remember, that the scale for value series has to be larger than the scale for the X-axis (e.g. X-Axis => Month, ValueSeries => Year).' =>
            'Let er op dat de schaal voor de Y-as groter moet zijn dan die voor de X-as (bijvooreeld X-as = maand, Y-as = jaar).',

        # Template: AgentStatsEditXaxis
        'Here you can define the x-axis. You can select one element via the radio button.' =>
            'Hier kunt u de X-as definiëren. U kunt een element kiezen met de radio-button.',
        'maximal period' => 'maximale periode',
        'minimal scale' => 'minimale schaal',

        # Template: AgentStatsImport
        'Import Stat' => 'Importeer rapport',
        'File is not a Stats config' => 'Het bestand is geen geldig rapport-configuratie bestand',
        'No File selected' => 'Geen bestand geselecteerd',

        # Template: AgentStatsOverview
        'Stats' => 'Rapporten',

        # Template: AgentStatsPrint
        'No Element selected.' => 'Geen element geselecteerd.',

        # Template: AgentStatsView
        'Export config' => 'Exporteer rapport-configuratie',
        'With the input and select fields you can influence the format and contents of the statistic.' =>
            'Met deze velden kunt u het formaat en de inhoud van het rapport beïnvloeden.',
        'Exactly what fields and formats you can influence is defined by the statistic administrator.' =>
            'Welke velden en formaten beschikbaar zijn is gedefiniëerd in het rapport zelf.',
        'Stat Details' => 'Rapport ',
        'Format' => 'Formaat',
        'Graphsize' => 'Grafiek grootte',
        'Cache' => 'Cache',
        'Exchange Axis' => 'Wissel assen',
        'Configurable params of static stat' => 'Configureerbare parameters voor rapport',
        'No element selected.' => 'Geen element geselecteerd.',
        'maximal period from' => 'Maximale periode van',
        'to' => 'tot',

        # Template: AgentTicketActionCommon
        'Change Free Text of Ticket' => 'Wijzig vrije velden',
        'Change Owner of Ticket' => 'Wijzig eigenaar van het ticket',
        'Close Ticket' => 'Sluit ticket',
        'Add Note to Ticket' => 'Voeg notitie toe aan ticket',
        'Set Pending' => 'Zet in de wacht',
        'Change Priority of Ticket' => 'Wijzig prioriteit van ticket',
        'Change Responsible of Ticket' => 'Wijzig verantwoordelijke voor ticket',
        'Service invalid.' => 'Service is ongeldig.',
        'New Owner' => 'Nieuwe eigenaar',
        'Please set a new owner!' => 'Kies een nieuwe eigenaar.',
        'Previous Owner' => 'Vorige eigenaar',
        'Inform Agent' => 'Informeer behandelaar',
        'Optional' => 'Optioneel',
        'Inform involved Agents' => 'Informeer betrokken behandelaars',
        'Spell check' => 'Spellingscontrole',
        'Note type' => 'Notitiesoort',
        'Next state' => 'Status',
        'Pending date' => 'In de wacht: datum',
        'Date invalid!' => 'Ongeldige datum.',

        # Template: AgentTicketActionPopupClose

        # Template: AgentTicketBounce
        'Bounce Ticket' => 'Bounce ticket',
        'Bounce to' => 'Bounce naar',
        'You need a email address.' => 'E-mailadres is verplicht.',
        'Need a valid email address or don\'t use a local email address.' =>
            'Een e-mailadres is verplicht. U kunt geen lokale adressen gebruiken.',
        'Next ticket state' => 'Status',
        'Inform sender' => 'Informeer afzender',
        'Send mail!' => 'Bericht versturen',

        # Template: AgentTicketBulk
        'Ticket Bulk Action' => 'Ticket bulk-actie',
        'Send Email' => 'Stuur e-mail',
        'Merge to' => 'Voeg samen met',
        'Invalid ticket identifier!' => 'Ongeldige ticket identifier.',
        'Merge to oldest' => 'Voeg samen met oudste',
        'Link together' => 'Koppelen',
        'Link to parent' => 'Koppel aan vader',
        'Unlock tickets' => 'Ontgrendel tickets',

        # Template: AgentTicketClose

        # Template: AgentTicketCompose
        'Compose answer for ticket' => 'Bericht opstellen voor',
        'Remove Ticket Customer' => 'Verwijder ',
        'Please remove this entry and enter a new one with the correct value.' =>
            'Verwijder deze en geef een nieuwe met een correcte waarde.',
        'Please include at least one recipient' => 'Voeg tenminste één ontvanger toe',
        'Remove Cc' => 'Verwijder CC',
        'Remove Bcc' => 'Verwijder BCC',
        'Address book' => 'Adresboek',
        'Pending Date' => 'Wacht tot datum',
        'for pending* states' => 'voor \'wachtend op-\' statussen',
        'Date Invalid!' => 'Datum ongeldig.',

        # Template: AgentTicketCustomer
        'Change customer of ticket' => 'Wijzig klant van een ticket',
        'Customer user' => 'Klant',

        # Template: AgentTicketEmail
        'Create New Email Ticket' => 'Maak nieuw e-mail ticket',
        'From queue' => 'In wachtrij',
        'To customer' => 'Aan klant',
        'Please include at least one customer for the ticket.' => 'Voeg ten minste één klant toe voor dit ticket.',
        'Get all' => 'Gebruik alle',

        # Template: AgentTicketEscalation

        # Template: AgentTicketForward
        'Forward ticket: %s - %s' => 'Ticket doorsturen: %s - %s',

        # Template: AgentTicketFreeText

        # Template: AgentTicketHistory
        'History of' => 'Geschiedenis van',
        'History Content' => 'Inhoud',
        'Zoom view' => 'Detailoverzicht',

        # Template: AgentTicketMerge
        'Ticket Merge' => 'Ticket samenvoegen',
        'You need to use a ticket number!' => 'Gebruik een ticketnummer.',
        'A valid ticket number is required.' => 'Een geldig ticketnummer is verplicht.',
        'Need a valid email address.' => 'Geen geldig e-mailadres.',

        # Template: AgentTicketMove
        'Move Ticket' => 'Verplaats ticket',
        'New Queue' => 'Nieuwe wachtrij',

        # Template: AgentTicketNote

        # Template: AgentTicketOverviewMedium
        'Select all' => 'Selecteer alles',
        'No ticket data found.' => 'Geen tickets gevonden.',
        'First Response Time' => 'Eerste reactie',
        'Service Time' => 'Service tijd',
        'Update Time' => 'Vervolg tijd',
        'Solution Time' => 'Oplossingstijd',
        'Move ticket to a different queue' => 'Verplaats naar nieuwe wachtrij',
        'Change queue' => 'Verplaats naar wachtrij',

        # Template: AgentTicketOverviewNavBar
        'Change search options' => 'Verander zoekopties',
        'Tickets per page' => 'Tickets per pagina',

        # Template: AgentTicketOverviewPreview

        # Template: AgentTicketOverviewSmall
        'Escalation in' => 'Escalatie om',
        'Locked' => 'Vergrendeling',

        # Template: AgentTicketOwner

        # Template: AgentTicketPending

        # Template: AgentTicketPhone
        'Create New Phone Ticket' => 'Maak nieuw telefoon ticket aan',
        'From customer' => 'Van klant',
        'To queue' => 'In wachtrij',

        # Template: AgentTicketPhoneCommon
        'Phone call' => 'Telefoongesprek',

        # Template: AgentTicketPlain
        'Email Text Plain View' => 'E-mailbericht zonder opmaak',
        'Plain' => 'Zonder opmaak',
        'Download this email' => 'Download deze e-mail',

        # Template: AgentTicketPrint
        'Ticket-Info' => 'Ticket informatie',
        'Accounted time' => 'Bestede tijd',
        'Linked-Object' => 'Gekoppeld item',
        'by' => 'door',

        # Template: AgentTicketPriority

        # Template: AgentTicketProcess
        'Create New Process Ticket' => 'Nieuw proces-ticket',
        'Process' => 'Proces',

        # Template: AgentTicketProcessNavigationBar

        # Template: AgentTicketQueue

        # Template: AgentTicketResponsible

        # Template: AgentTicketSearch
        'Search template' => 'Sjabloon',
        'Create Template' => 'Maak sjabloon',
        'Create New' => 'Nieuw',
        'Profile link' => 'Koppeling naar sjabloon',
        'Save changes in template' => 'Sla wijzigingen op in sjabloon',
        'Add another attribute' => 'Voeg attribuut toe',
        'Output' => 'Uitvoeren naar',
        'Fulltext' => 'Volledig',
        'Remove' => 'Verwijderen',
        'Searches in the attributes From, To, Cc, Subject and the article body, overriding other attributes with the same name.' =>
            '',
        'Customer User Login' => 'Klant login',
        'Created in Queue' => 'Aangemaakt in wachtrij',
        'Lock state' => 'Vergrendeling',
        'Watcher' => 'Volger',
        'Article Create Time (before/after)' => 'Aanmaaktijd interactie (voor/na)',
        'Article Create Time (between)' => 'Aanmaaktijd interactie (tussen)',
        'Ticket Create Time (before/after)' => 'Aanmaaktijd ticket (voor/na)',
        'Ticket Create Time (between)' => 'Aanmaaktijd ticket (tussen)',
        'Ticket Change Time (before/after)' => 'Ticket gewijzigd (voor/na)',
        'Ticket Change Time (between)' => 'Ticket gewijzigd (tussen)',
        'Ticket Close Time (before/after)' => 'Ticket gesloten (voor/na)',
        'Ticket Close Time (between)' => 'Ticket gesloten (tussen)',
        'Ticket Escalation Time (before/after)' => 'Ticket escalatietijd (voor/na)',
        'Ticket Escalation Time (between)' => 'Ticket escaltietijd (tussen)',
        'Archive Search' => 'Zoek in archief',
        'Run search' => 'Voer zoekopdracht uit',

        # Template: AgentTicketSearchOpenSearchDescriptionFulltext

        # Template: AgentTicketSearchOpenSearchDescriptionTicketNumber

        # Template: AgentTicketSearchResultPrint

        # Template: AgentTicketZoom
        'Article filter' => 'Filter interacties',
        'Article Type' => 'Soort interactie',
        'Sender Type' => 'Soort verzender',
        'Save filter settings as default' => 'Sla filter op als standaard',
        'Archive' => 'Archief',
        'This ticket is archived.' => 'Dit ticket is gearchiveerd.',
        'Linked Objects' => 'Gekoppelde objecten',
        'Article(s)' => 'Interactie(s)',
        'Change Queue' => 'Wijzig wachtrij',
        'There are no dialogs available at this point in the process.' =>
            '',
        'This item has no articles yet.' => 'Dit item heeft nog geen interacties.',
        'Article Filter' => 'Filter interacties',
        'Add Filter' => 'Nieuw filter',
        'Set' => 'Nieuwe waarden',
        'Reset Filter' => 'Herstel filter',
        'Show one article' => 'Toon één interactie',
        'Show all articles' => 'Toon alle interacties',
        'Unread articles' => 'Ongelezen interacties',
        'No.' => 'Nr.',
        'Unread Article!' => 'Ongelezen interactie.',
        'Incoming message' => 'Binnenkomend bericht',
        'Outgoing message' => 'Uitgaand bericht',
        'Internal message' => 'Intern bericht',
        'Resize' => 'Grootte wijzigen',

        # Template: AttachmentBlocker
        'To protect your privacy, remote content was blocked.' => 'Om uw privacy te beschermen is actieve inhoud geblokkeerd.',
        'Load blocked content.' => 'Laad actieve inhoud.',

        # Template: Copyright

        # Template: CustomerAccept

        # Template: CustomerError
        'Traceback' => 'Traceback',

        # Template: CustomerFooter
        'Powered by' => 'Draait op',
        'One or more errors occurred!' => 'Een of meerdere problemen zijn opgetreden.',
        'Close this dialog' => 'Sluit venster',
        'Could not open popup window. Please disable any popup blockers for this application.' =>
            'Kan geen popup openen. Schakel popup blockers uit voor deze website.',

        # Template: CustomerFooterSmall

        # Template: CustomerHeader

        # Template: CustomerHeaderSmall

        # Template: CustomerLogin
        'JavaScript Not Available' => 'JavaScript niet beschikbaar',
        'In order to experience OTRS, you\'ll need to enable JavaScript in your browser.' =>
            'Om OTRS te kunnen gebruiken, moet JavaScript geactiveerd zijn in uw browser.',
        'Browser Warning' => 'Waarschuwing',
        'The browser you are using is too old.' => 'De browser die u gebruikt is te oud.',
        'OTRS runs with a huge lists of browsers, please upgrade to one of these.' =>
            'OTRS kan overweg met een grote hoeveelheid browsers. Gebruik s.v.p een van deze.',
        'Please see the documentation or ask your admin for further information.' =>
            'Zie de documentatie of vraag uw beheerder voor meer informatie.',
        'Login' => 'Inloggen',
        'User name' => 'Gebruikersnaam',
        'Your user name' => 'Uw gebruikersnaam',
        'Your password' => 'Uw wachtwoord',
        'Forgot password?' => 'Wachtwoord vergeten?',
        'Log In' => 'Inloggen',
        'Not yet registered?' => 'Nog niet geregistreerd?',
        'Sign up now' => 'Gebruikersnaam registreren',
        'Request new password' => 'Vraag een nieuw wachtwoord aan',
        'Your User Name' => 'Uw gebruikersnaam',
        'A new password will be sent to your email address.' => 'Een nieuw wachtwoord wordt naar uw e-mailadres verzonden.',
        'Create Account' => 'Maak account',
        'Please fill out this form to receive login credentials.' => 'Vul dit formulier in om een gebruikersnaam aan te maken.',
        'How we should address you' => 'Hoe moeten we u adresseren?',
        'Your First Name' => 'Uw voornaam',
        'Your Last Name' => 'Uw achternaam',
        'Your email address (this will become your username)' => 'Uw e-mailadres (dit wordt uw gebruikersnaam)',

        # Template: CustomerNavigationBar
        'Edit personal preferences' => 'Voorkeuren bewerken',
        'Logout %s' => 'Uitloggen %s',

        # Template: CustomerPreferences

        # Template: CustomerRichTextEditor

        # Template: CustomerTicketMessage
        'Service level agreement' => 'Service level agreement',

        # Template: CustomerTicketOverview
        'Welcome!' => 'Welkom!',
        'Please click the button below to create your first ticket.' => 'Klik op de button om uw eerste ticket aan te maken.',
        'Create your first ticket' => 'Maak uw eerste ticket aan',

        # Template: CustomerTicketPrint
        'Ticket Print' => 'Ticket print',

        # Template: CustomerTicketSearch
        'Profile' => 'Sjabloon',
        'e. g. 10*5155 or 105658*' => 'bijv. 2010*5155 of 20100802*',
        'Fulltext search in tickets (e. g. "John*n" or "Will*")' => 'Zoeken in tekst in tickets (bijv. "Jans*en" of "Print*")',
        'Recipient' => 'Geadresseerde',
        'Carbon Copy' => 'CC',
        'Time restrictions' => 'Tijd',
        'No time settings' => 'Niet zoeken op tijd',
        'Only tickets created' => 'Alleen tickets aangemaakt',
        'Only tickets created between' => 'Alleen tickets aangemaakt tussen',
        'Ticket archive system' => 'Ticket-archief',
        'Save search as template?' => 'Bewaar zoekopdracht als sjabloon?',
        'Save as Template?' => 'Bewaar als sjabloon?',
        'Save as Template' => 'Bewaar',
        'Template Name' => 'Template naam',
        'Pick a profile name' => 'Naam voor dit sjabloon',
        'Output to' => 'Uitvoer naar',

        # Template: CustomerTicketSearchOpenSearchDescription

        # Template: CustomerTicketSearchResultPrint

        # Template: CustomerTicketSearchResultShort
        'of' => 'van',
        'Page' => 'Pagina',
        'Search Results for' => 'Zoekresultaat voor',

        # Template: CustomerTicketZoom
        'Show  article' => 'Toon interactie',
        'Expand article' => 'Toon interactie',
        'Information' => 'Informatie',
        'Next Steps' => 'Volgende stappen',
        'Reply' => 'Beantwoord',

        # Template: CustomerWarning

        # Template: Datepicker
        'Invalid date (need a future date)!' => 'Ongeldig (datum kan niet in verleden zijn).',
        'Previous' => 'Vorige',
        'Sunday' => 'zondag',
        'Monday' => 'maandag',
        'Tuesday' => 'dinsdag',
        'Wednesday' => 'woensdag',
        'Thursday' => 'donderdag',
        'Friday' => 'vrijdag',
        'Saturday' => 'zaterdag',
        'Su' => 'zo',
        'Mo' => 'ma',
        'Tu' => 'di',
        'We' => 'wo',
        'Th' => 'do',
        'Fr' => 'vr',
        'Sa' => 'za',
        'Open date selection' => 'Open datumkiezer',

        # Template: Error
        'Oops! An Error occurred.' => 'Oeps! Daar ging iets mis.',
        'Error Message' => 'Foutmelding',
        'You can' => 'U kunt',
        'Send a bugreport' => 'Een bug report indienen',
        'go back to the previous page' => 'terug naar de vorige pagina',
        'Error Details' => 'Error gegevens',

        # Template: Footer
        'Top of page' => 'Naar boven',

        # Template: FooterJS
        'If you now leave this page, all open popup windows will be closed, too!' =>
            'Als u deze pagina verlaat worden alle openstaande popup-vensters ook gesloten.',
        'A popup of this screen is already open. Do you want to close it and load this one instead?' =>
            'Er is al een popup open voor dit ticket. Wilt u deze sluiten en de nieuwe laden?',
        'Please enter at least one search value or * to find anything.' =>
            'Geef één of meerdere tekens of een wildcard als * op om een zoekopdracht uit te voeren.',

        # Template: FooterSmall

        # Template: HTMLHead

        # Template: HTMLHeadBlockEvents

        # Template: Header
        'Fulltext search' => 'Zoeken',
        'CustomerID Search' => 'Zoeken op klantcode',
        'CustomerUser Search' => 'Zoeken op klant',
        'You are logged in as' => 'Ingelogd als',

        # Template: HeaderSmall

        # Template: Installer
        'JavaScript not available' => 'JavaScript is niet beschikbaar',
        'Database Settings' => 'Database configuratie',
        'General Specifications and Mail Settings' => 'Algemene instellingen en mailconfiguratie',
        'Registration' => 'Registratie',
        'Welcome to %s' => 'Welkom bij %s',
        'Web site' => 'Website',
        'Database check successful.' => 'Database controle gelukt.',
        'Mail check successful.' => 'Mail controle gelukt.',
        'Error in the mail settings. Please correct and try again.' => 'Fout in de mailinstellingen. Corrigeer ze en probeer nog eens.',

        # Template: InstallerConfigureMail
        'Configure Outbound Mail' => 'Configureer uitgaande mail',
        'Outbound mail type' => 'Uitgaande mail type',
        'Select outbound mail type.' => 'Selecteer e-mail soort.',
        'Outbound mail port' => 'Uitgaande mail poort',
        'Select outbound mail port.' => 'Kies de TCP poort voor uitgaand e-mail verkeer.',
        'SMTP host' => 'SMTP host',
        'SMTP host.' => 'SMTP host.',
        'SMTP authentication' => 'SMTP authenticatie',
        'Does your SMTP host need authentication?' => 'Heeft uw SMTP host authenticatie nodig?',
        'SMTP auth user' => 'SMTP auth user',
        'Username for SMTP auth.' => 'Login voor SMTP authenticatie',
        'SMTP auth password' => 'SMTP auth password',
        'Password for SMTP auth.' => 'Wachtwoord voor SMTP authenticatie',
        'Configure Inbound Mail' => 'Configureer binnenkomende mail',
        'Inbound mail type' => 'Ingaande mail type',
        'Select inbound mail type.' => 'Selecteer e-mail soort.',
        'Inbound mail host' => 'Ingaande mail host',
        'Inbound mail host.' => 'Hostnaam mailserver voor inkomende mail.',
        'Inbound mail user' => 'User',
        'User for inbound mail.' => 'Login voor inkomende mail server.',
        'Inbound mail password' => 'Password',
        'Password for inbound mail.' => 'Wachtwoord voor inkomende mail server.',
        'Result of mail configuration check' => 'Resultaat van mailconfiguratie test',
        'Check mail configuration' => 'Test mailconfiguratie',
        'Skip this step' => 'Sla dit over',
        'Skipping this step will automatically skip the registration of your OTRS. Are you sure you want to continue?' =>
            'Als u deze stap overslaat dan slaat u ook de registratie van uw OTRS-systeem over. Weet u zeker dat u wilt doorgaan?',

        # Template: InstallerDBResult
        'False' => 'Fout',

        # Template: InstallerDBStart
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty. For security reasons we do recommend setting a root password. For more information please refer to your database documentation.' =>
            'Als er een wachtwoord hoort bij dit account, vul deze hier in. Vanuit beveiligingsoogpunt is het aan te bevelen een wachtwoord te gebruiken. Kijk in de databasedocumentatie voor meer informatie.',
        'Currently only MySQL is supported in the web installer.' => 'Alleen MySQL wordt ondersteund door de web installer.',
        'If you want to install OTRS on another database type, please refer to the file README.database.' =>
            'Als u OTRS op een ander type database wilt installeren, kijk dan in het bestand README.database voor instructies.',
        'Database-User' => 'OTRS database gebruiker',
        'New' => 'Nieuw',
        'A new database user with limited rights will be created for this OTRS system.' =>
            'Een nieuwe database gebruiker met beperkte permissies wordt aangemaakt voor deze OTRS omgeving.',
        'default \'hot\'' => 'Standaard \'hot\'',
        'DB host' => 'Database host',
        'Check database settings' => 'Test database instellingen',
        'Result of database check' => 'Resultaat van database test',

        # Template: InstallerFinish
        'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' =>
            'Om OTRS te gebruiken moet u nu de webserver herstarten.',
        'Restart your webserver' => 'Herstart webserver',
        'After doing so your OTRS is up and running.' => 'Hierna is OTRS klaar voor gebruik.',
        'Start page' => 'Inlogpagina',
        'Your OTRS Team' => 'Het OTRS team',

        # Template: InstallerLicense
        'Accept license' => 'Accepteer licentie',
        'Don\'t accept license' => 'Licentie niet accepteren',

        # Template: InstallerLicenseText

        # Template: InstallerRegistration
        'Organization' => 'Organisatie',
        'Position' => 'Rol',
        'Complete registration and continue' => 'Registreer en ga verder met installatie',
        'Please fill in all fields marked as mandatory.' => 'Vul de verplichte velden in.',

        # Template: InstallerSystem
        'SystemID' => 'Systeem identificatie',
        'The identifier of the system. Each ticket number and each HTTP session ID contain this number.' =>
            'De identifier van het systeem. Ieder ticketnummer en elk HTTP sessie ID bevat dit nummer.',
        'System FQDN' => 'OTRS FQDN',
        'Fully qualified domain name of your system.' => 'Fully Qualified Domain Name van het systeem.',
        'AdminEmail' => 'E-mailadres beheerder',
        'Email address of the system administrator.' => 'E-mailadres van de beheerder.',
        'Log' => 'Log',
        'LogModule' => 'Logmodule',
        'Log backend to use.' => 'Te gebruiken logbestand.',
        'LogFile' => 'Logbestand',
        'Log file location is only needed for File-LogModule!' => 'Locatie logbestand is alleen nodig voor de File-Log module.',
        'Webfrontend' => 'Web Frontend',
        'Default language' => 'Standaard taal',
        'Default language.' => 'Standaard taal.',
        'CheckMXRecord' => 'Check MX Record',
        'Email addresses that are manually entered are checked against the MX records found in DNS. Don\'t use this option if your DNS is slow or does not resolve public addresses.' =>
            'E-mailadressen die handmatig worden ingevoerd worden gecontroleerd met de MX records gevonden in de DNS. Gebruik deze mogelijkheid niet als uw DNS traag is of geen publieke adressen kan herleiden.',

        # Template: LinkObject
        'Object#' => 'Object#',
        'Add links' => 'Links toevoegen',
        'Delete links' => 'Links verwijderen',

        # Template: Login
        'Lost your password?' => 'Wachtwoord vergeten?',
        'Request New Password' => 'Vraag nieuw wachtwoord aan',
        'Back to login' => 'Terug naar inlogscherm',

        # Template: Motd
        'Message of the Day' => 'Soep van de Dag',

        # Template: NoPermission
        'Insufficient Rights' => 'Onvoldoende permissies',
        'Back to the previous page' => 'Terug naar de vorige pagina',

        # Template: Notify

        # Template: Pagination
        'Show first page' => 'Toon eerste pagina',
        'Show previous pages' => 'Toon vorige pagina\'s',
        'Show page %s' => 'Toon pagina %s',
        'Show next pages' => 'Toon volgende pagina\'s',
        'Show last page' => 'Toon laatste pagina',

        # Template: PictureUpload
        'Need FormID!' => 'Geen FormID gevonden.',
        'No file found!' => 'Geen bestand gevonden.',
        'The file is not an image that can be shown inline!' => 'Dit bestand kan niet inline worden weergegeven.',

        # Template: PrintFooter
        'URL' => 'URL',

        # Template: PrintHeader
        'printed by' => 'afgedrukt door',

        # Template: PublicDefault

        # Template: Redirect

        # Template: RichTextEditor

        # Template: SpellingInline

        # Template: Test
        'OTRS Test Page' => 'OTRS Testpagina',
        'Welcome %s' => 'Welkom %s',
        'Counter' => 'Teller',

        # Template: Warning
        'Go back to the previous page' => 'Terug naar de vorige pagina',

        # SysConfig
        '"Slim" Skin which tries to save screen space for power users.' =>
            '',
        'ACL module that allows closing parent tickets only if all its children are already closed ("State" shows which states are not available for the parent ticket until all child tickets are closed).' =>
            '',
        'AccountedTime' => '',
        'Activates a blinking mechanism of the queue that contains the oldest ticket.' =>
            '',
        'Activates lost password feature for agents, in the agent interface.' =>
            '',
        'Activates lost password feature for customers.' => '',
        'Activates support for customer groups.' => '',
        'Activates the article filter in the zoom view to specify which articles should be shown.' =>
            '',
        'Activates the available themes on the system. Value 1 means active, 0 means inactive.' =>
            '',
        'Activates the ticket archive system search in the customer interface.' =>
            '',
        'Activates the ticket archive system to have a faster system by moving some tickets out of the daily scope. To search for these tickets, the archive flag has to be enabled in the ticket search.' =>
            '',
        'Activates time accounting.' => '',
        'Adds a suffix with the actual year and month to the OTRS log file. A logfile for every month will be created.' =>
            '',
        'Adds customers email addresses to recipients in the ticket compose screen of the agent interface. The customers email address won\'t be added if the article type is email-internal.' =>
            '',
        'Adds the one time vacation days for the indicated calendar. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            '',
        'Adds the one time vacation days. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            '',
        'Adds the permanent vacation days for the indicated calendar. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            '',
        'Adds the permanent vacation days. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            '',
        'Agent Notifications' => 'Meldingen voor behandelaars',
        'Agent interface article notification module to check PGP.' => '',
        'Agent interface article notification module to check S/MIME.' =>
            '',
        'Agent interface module to access CIC search via nav bar.' => '',
        'Agent interface module to access fulltext search via nav bar.' =>
            '',
        'Agent interface module to access search profiles via nav bar.' =>
            '',
        'Agent interface module to check incoming emails in the Ticket-Zoom-View if the S/MIME-key is available and true.' =>
            '',
        'Agent interface notification module to check the used charset.' =>
            '',
        'Agent interface notification module to see the number of tickets an agent is responsible for.' =>
            '',
        'Agent interface notification module to see the number of watched tickets.' =>
            '',
        'Agents <-> Groups' => 'Behandelaars <-> Groepen',
        'Agents <-> Roles' => 'Behandelaars <-> Rollen',
        'All customer users of a CustomerID' => '',
        'Allows adding notes in the close ticket screen of the agent interface.' =>
            '',
        'Allows adding notes in the ticket free text screen of the agent interface.' =>
            '',
        'Allows adding notes in the ticket note screen of the agent interface.' =>
            '',
        'Allows adding notes in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Allows adding notes in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Allows adding notes in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Allows adding notes in the ticket responsible screen of the agent interface.' =>
            '',
        'Allows agents to exchange the axis of a stat if they generate one.' =>
            '',
        'Allows agents to generate individual-related stats.' => '',
        'Allows choosing between showing the attachments of a ticket in the browser (inline) or just make them downloadable (attachment).' =>
            '',
        'Allows choosing the next compose state for customer tickets in the customer interface.' =>
            '',
        'Allows customers to change the ticket priority in the customer interface.' =>
            '',
        'Allows customers to set the ticket SLA in the customer interface.' =>
            '',
        'Allows customers to set the ticket priority in the customer interface.' =>
            '',
        'Allows customers to set the ticket queue in the customer interface. If this is set to \'No\', QueueDefault should be configured.' =>
            '',
        'Allows customers to set the ticket service in the customer interface.' =>
            '',
        'Allows customers to set the ticket type in the customer interface. If this is set to \'No\', TicketTypeDefault should be configured.' =>
            '',
        'Allows default services to be selected also for non existing customers.' =>
            '',
        'Allows defining new types for ticket (if ticket type feature is enabled).' =>
            '',
        'Allows defining services and SLAs for tickets (e. g. email, desktop, network, ...), and escalation attributes for SLAs (if ticket service/SLA feature is enabled).' =>
            '',
        'Allows extended search conditions in ticket search of the agent interface. With this feature you can search e. g. with this kind of conditions like "(key1&&key2)" or "(key1||key2)".' =>
            '',
        'Allows extended search conditions in ticket search of the customer interface. With this feature you can search w. g. with this kind of conditions like "(key1&&key2)" or "(key1||key2)".' =>
            '',
        'Allows having a medium format ticket overview (CustomerInfo => 1 - shows also the customer information).' =>
            '',
        'Allows having a small format ticket overview (CustomerInfo => 1 - shows also the customer information).' =>
            '',
        'Allows the administrators to login as other customers, via the customer user administration panel.' =>
            '',
        'Allows the administrators to login as other users, via the users administration panel.' =>
            '',
        'Allows to set a new ticket state in the move ticket screen of the agent interface.' =>
            '',
        'ArticleTree' => '',
        'Attachments <-> Responses' => 'Standaard-antwoorden <-> Bijlagen',
        'Auto Responses <-> Queues' => 'Wachtrijen <-> Automatische antwoorden',
        'Automated line break in text messages after x number of chars.' =>
            '',
        'Automatically lock and set owner to current Agent after selecting for an Bulk Action.' =>
            '',
        'Automatically sets the owner of a ticket as the responsible for it (if ticket responsible feature is enabled).' =>
            '',
        'Automatically sets the responsible of a ticket (if it is not set yet) after the first owner update.' =>
            '',
        'Balanced white skin by Felix Niklas.' => '',
        'Basic fulltext index settings. Execute "bin/otrs.RebuildFulltextIndex.pl" in order to generate a new index.' =>
            '',
        'Blocks all the incoming emails that do not have a valid ticket number in subject with From: @example.com address.' =>
            '',
        'Builds an article index right after the article\'s creation.' =>
            '',
        'CMD example setup. Ignores emails where external CMD returns some output on STDOUT (email will be piped into STDIN of some.bin).' =>
            '',
        'Cache time in seconds for agent authentication in the GenericInterface.' =>
            '',
        'Cache time in seconds for customer authentication in the GenericInterface.' =>
            '',
        'Cache time in seconds for the DB process backend.' => '',
        'Cache time in seconds for the ticket process navigation bar output module.' =>
            '',
        'Cache time in seconds for the web service config backend.' => '',
        'Change password' => 'Wachtwoord wijzigen',
        'Change queue!' => 'Verander wachtrij.',
        'Change the customer for this ticket' => 'Wijzig de klant voor dit ticket',
        'Change the free fields for this ticket' => 'Wijzig de vrije velden voor dit ticket',
        'Change the priority for this ticket' => 'Wijzig de prioriteit voor dit ticket',
        'Change the responsible person for this ticket' => 'Wijzig de verantwoordelijke personen voor dit ticket',
        'Changes the owner of tickets to everyone (useful for ASP). Normally only agent with rw permissions in the queue of the ticket will be shown.' =>
            '',
        'Checkbox' => 'Checkbox',
        'Checks the SystemID in ticket number detection for follow-ups (use "No" if SystemID has been changed after using the system).' =>
            '',
        'Closed tickets of customer' => 'Gesloten tickets van klant',
        'Comment for new history entries in the customer interface.' => '',
        'Company Status' => 'Klantstatus',
        'Company Tickets' => 'Tickets van groep',
        'Company name for the customer web interface. Will also be included in emails as an X-Header.' =>
            '',
        'Configure Processes.' => 'Beheer processen',
        'Configure your own log text for PGP.' => '',
        'Configures a default TicketDynmicField setting. "Name" defines the dynamic field which should be used, "Value" is the data that will be set, and "Event" defines the trigger event. Please check the developer manual (http://doc.otrs.org/), chapter "Ticket Event Module".' =>
            '',
        'Controls if customers have the ability to sort their tickets.' =>
            '',
        'Controls if more than one from entry can be set in the new phone ticket in the agent interface.' =>
            '',
        'Controls if the ticket and article seen flags are removed when a ticket is archived.' =>
            '',
        'Converts HTML mails into text messages.' => '',
        'Create New process ticket' => 'Maak nieuw proces-ticket aan',
        'Create and manage Service Level Agreements (SLAs).' => 'Aanmaken en beheren van Service Level Agreements (SLA\'s).',
        'Create and manage agents.' => 'Aanmaken en beheren van behandelaars.',
        'Create and manage attachments.' => 'Aanmaken en beheren van bijlagen.',
        'Create and manage companies.' => 'Aanmaken en beheren van bedrijven.',
        'Create and manage customers.' => 'Aanmaken en beheren van klanten.',
        'Create and manage dynamic fields.' => 'Aanmaken en beheren van dynamische velden.',
        'Create and manage event based notifications.' => 'Aanmaken en beheren van meldingen door gebeurtenissen.',
        'Create and manage groups.' => 'Aanmaken en beheren van groepen.',
        'Create and manage queues.' => 'Aanmaken en beheren van wachtrijen.',
        'Create and manage response templates.' => 'Aanmaken en beheren van voorgedefiniëerde antwoorden.',
        'Create and manage responses that are automatically sent.' => 'Aanmaken en beheren van teksten die automatisch naar de klant worden gestuurd.',
        'Create and manage roles.' => 'Aanmaken en beheren van rollen.',
        'Create and manage salutations.' => 'Aanmaken en beheren van aanheffen.',
        'Create and manage services.' => 'Aanmaken en beheren van services.',
        'Create and manage signatures.' => 'Aanmaken en beheren van handtekeningen.',
        'Create and manage ticket priorities.' => 'Aanmaken en beheren van prioriteiten.',
        'Create and manage ticket states.' => 'Aanmaken en beheren van statussen.',
        'Create and manage ticket types.' => 'Aanmaken en beheren van typen.',
        'Create and manage web services.' => 'Aanmaken en beheren van webservices.',
        'Create new email ticket and send this out (outbound)' => 'Maak een nieuw ticket en verstuur hiervan een mail (uitgaand)',
        'Create new phone ticket (inbound)' => 'Maak een nieuw telefoon ticket aan (inkomend)',
        'Custom text for the page shown to customers that have no tickets yet.' =>
            '',
        'Customer Company Administration' => 'Beheren van bedrijven',
        'Customer Company Information' => 'Bedrijfsinformatie',
        'Customer User Administration' => 'Beheren van klanten',
        'Customer Users' => 'Klanten',
        'Customer item (icon) which shows the closed tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            '',
        'Customer item (icon) which shows the open tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            '',
        'CustomerName' => '',
        'Customers <-> Groups' => 'Klanten <-> Groepen',
        'Customers <-> Services' => 'Klanten <-> Services',
        'Data used to export the search result in CSV format.' => '',
        'Date / Time' => 'Datum / tijd',
        'Debugs the translation set. If this is set to "Yes" all strings (text) without translations are written to STDERR. This can be helpful when you are creating a new translation file. Otherwise, this option should remain set to "No".' =>
            '',
        'Default ACL values for ticket actions.' => '',
        'Default ProcessManagement entity prefixes for entity IDs that are automatically generated.' =>
            '',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimePointFormat=year;TicketCreateTimePointStart=Last;TicketCreateTimePoint=2;".' =>
            '',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimeStartYear=2010;TicketCreateTimeStartMonth=10;TicketCreateTimeStartDay=4;TicketCreateTimeStopYear=2010;TicketCreateTimeStopMonth=11;TicketCreateTimeStopDay=3;".' =>
            '',
        'Default loop protection module.' => '',
        'Default queue ID used by the system in the agent interface.' => '',
        'Default skin for OTRS 3.0 interface.' => '',
        'Default skin for interface.' => 'Standaard kleuren voor OTRS schermen.',
        'Default ticket ID used by the system in the agent interface.' =>
            '',
        'Default ticket ID used by the system in the customer interface.' =>
            '',
        'Default value for NameX' => '',
        'Define a filter for html output to add links behind a defined string. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            '',
        'Define the max depth of queues.' => '',
        'Define the start day of the week for the date picker.' => '',
        'Defines a customer item, which generates a LinkedIn icon at the end of a customer info block.' =>
            '',
        'Defines a customer item, which generates a XING icon at the end of a customer info block.' =>
            '',
        'Defines a customer item, which generates a google icon at the end of a customer info block.' =>
            '',
        'Defines a customer item, which generates a google maps icon at the end of a customer info block.' =>
            '',
        'Defines a default list of words, that are ignored by the spell checker.' =>
            '',
        'Defines a filter for html output to add links behind CVE numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            '',
        'Defines a filter for html output to add links behind MSBulletin numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            '',
        'Defines a filter for html output to add links behind a defined string. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            '',
        'Defines a filter for html output to add links behind bugtraq numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            '',
        'Defines a filter to process the text in the articles, in order to highlight predefined keywords.' =>
            '',
        'Defines a regular expression that excludes some addresses from the syntax check (if "CheckEmailAddresses" is set to "Yes"). Please enter a regex in this field for email addresses, that aren\'t syntactically valid, but are necessary for the system (i.e. "root@localhost").' =>
            '',
        'Defines a regular expression that filters all email addresses that should not be used in the application.' =>
            '',
        'Defines a useful module to load specific user options or to display news.' =>
            '',
        'Defines all the X-headers that should be scanned.' => '',
        'Defines all the languages that are available to the application. The Key/Content pair links the front-end display name to the appropriate language PM file. The "Key" value should be the base-name of the PM file (i.e. de.pm is the file, then de is the "Key" value). The "Content" value should be the display name for the front-end. Specify any own-defined language here (see the developer documentation http://doc.otrs.org/ for more infomation). Please remember to use the HTML equivalents for non-ASCII characters (i.e. for the German oe = o umlaut, it is necessary to use the &ouml; symbol).' =>
            '',
        'Defines all the parameters for the RefreshTime object in the customer preferences of the customer interface.' =>
            '',
        'Defines all the parameters for the ShownTickets object in the customer preferences of the customer interface.' =>
            '',
        'Defines all the parameters for this item in the customer preferences.' =>
            '',
        'Defines all the possible stats output formats.' => '',
        'Defines an alternate URL, where the login link refers to.' => '',
        'Defines an alternate URL, where the logout link refers to.' => '',
        'Defines an alternate login URL for the customer panel..' => '',
        'Defines an alternate logout URL for the customer panel.' => '',
        'Defines an external link to the database of the customer (e.g. \'http://yourhost/customer.php?CID=$Data{"CustomerID"}\' or \'\').' =>
            '',
        'Defines how the From field from the emails (sent from answers and email tickets) should look like.' =>
            '',
        'Defines if a pre-sorting by priority should be done in the queue view.' =>
            '',
        'Defines if a ticket lock is required in the close ticket screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket bounce screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket compose screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket forward screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket free text screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket merge screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket note screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket owner screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket pending screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket phone inbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket phone outbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket priority screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket responsible screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required to change the customer of a ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if composed messages have to be spell checked in the agent interface.' =>
            '',
        'Defines if the enhanced mode should be used (enables use of table, replace, subscript, superscript, paste from word, etc.).' =>
            '',
        'Defines if time accounting is mandatory in the agent interface.' =>
            '',
        'Defines if time accounting must be set to all tickets in bulk action.' =>
            '',
        'Defines scheduler PID update time in seconds (floating point number).' =>
            '',
        'Defines scheduler sleep time in seconds after processing all available tasks (floating point number).' =>
            '',
        'Defines the IP regular expression for accessing the local repository. You need to enable this to have access to your local repository and the package::RepositoryList is required on the remote host.' =>
            '',
        'Defines the URL CSS path.' => '',
        'Defines the URL base path of icons, CSS and Java Script.' => '',
        'Defines the URL image path of icons for navigation.' => '',
        'Defines the URL java script path.' => '',
        'Defines the URL rich text editor path.' => '',
        'Defines the address of a dedicated DNS server, if necessary, for the "CheckMXRecord" look-ups.' =>
            '',
        'Defines the body text for notification mails sent to agents, about new password (after using this link the new password will be sent).' =>
            '',
        'Defines the body text for notification mails sent to agents, with token about new requested password (after using this link the new password will be sent).' =>
            '',
        'Defines the body text for notification mails sent to customers, about new account.' =>
            '',
        'Defines the body text for notification mails sent to customers, about new password (after using this link the new password will be sent).' =>
            '',
        'Defines the body text for notification mails sent to customers, with token about new requested password (after using this link the new password will be sent).' =>
            '',
        'Defines the body text for rejected emails.' => '',
        'Defines the boldness of the line drawed by the graph.' => '',
        'Defines the colors for the graphs.' => '',
        'Defines the column to store the keys for the preferences table.' =>
            '',
        'Defines the config parameters of this item, to be shown in the preferences view.' =>
            '',
        'Defines the config parameters of this item, to be shown in the preferences view. Take care to maintain the dictionaries installed in the system in the data section.' =>
            '',
        'Defines the connections for http/ftp, via a proxy.' => '',
        'Defines the date input format used in forms (option or input fields).' =>
            '',
        'Defines the default CSS used in rich text editors.' => '',
        'Defines the default auto response type of the article for this operation.' =>
            '',
        'Defines the default body of a note in the ticket free text screen of the agent interface.' =>
            '',
        'Defines the default front-end (HTML) theme to be used by the agents and customers. The default themes are Standard and Lite. If you like, you can add your own theme. Please refer the administrator manual located at http://doc.otrs.org/.' =>
            '',
        'Defines the default front-end language. All the possible values are determined by the available language files on the system (see the next setting).' =>
            '',
        'Defines the default history type in the customer interface.' => '',
        'Defines the default maximum number of X-axis attributes for the time scale.' =>
            '',
        'Defines the default maximum number of search results shown on the overview page.' =>
            '',
        'Defines the default next state for a ticket after customer follow up in the customer interface.' =>
            '',
        'Defines the default next state of a ticket after adding a note, in the close ticket screen of the agent interface.' =>
            '',
        'Defines the default next state of a ticket after adding a note, in the ticket bulk screen of the agent interface.' =>
            '',
        'Defines the default next state of a ticket after adding a note, in the ticket free text screen of the agent interface.' =>
            '',
        'Defines the default next state of a ticket after adding a note, in the ticket note screen of the agent interface.' =>
            '',
        'Defines the default next state of a ticket after adding a note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the default next state of a ticket after adding a note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the default next state of a ticket after adding a note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the default next state of a ticket after adding a note, in the ticket responsible screen of the agent interface.' =>
            '',
        'Defines the default next state of a ticket after being bounced, in the ticket bounce screen of the agent interface.' =>
            '',
        'Defines the default next state of a ticket after being forwarded, in the ticket forward screen of the agent interface.' =>
            '',
        'Defines the default next state of a ticket if it is composed / answered in the ticket compose screen of the agent interface.' =>
            '',
        'Defines the default note body text for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Defines the default note body text for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            '',
        'Defines the default priority of follow up customer tickets in the ticket zoom screen in the customer interface.' =>
            '',
        'Defines the default priority of new customer tickets in the customer interface.' =>
            '',
        'Defines the default priority of new tickets.' => '',
        'Defines the default queue for new customer tickets in the customer interface.' =>
            '',
        'Defines the default selection at the drop down menu for dynamic objects (Form: Common Specification).' =>
            '',
        'Defines the default selection at the drop down menu for permissions (Form: Common Specification).' =>
            '',
        'Defines the default selection at the drop down menu for stats format (Form: Common Specification). Please insert the format key (see Stats::Format).' =>
            '',
        'Defines the default sender type for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Defines the default sender type for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            '',
        'Defines the default sender type for tickets in the ticket zoom screen of the customer interface.' =>
            '',
        'Defines the default shown ticket search attribute for ticket search screen.' =>
            '',
        'Defines the default shown ticket search attribute for ticket search screen. Example: a text, 1, Search_DynamicField_Field1StartYear=2002; Search_DynamicField_Field1StartMonth=12; Search_DynamicField_Field1StartDay=12; Search_DynamicField_Field1StartHour=00; Search_DynamicField_Field1StartMinute=00; Search_DynamicField_Field1StartSecond=00; Search_DynamicField_Field1StopYear=2009; Search_DynamicField_Field1StopMonth=02; Search_DynamicField_Field1StopDay=10; Search_DynamicField_Field1StopHour=23; Search_DynamicField_Field1StopMinute=59; Search_DynamicField_Field1StopSecond=59;.' =>
            '',
        'Defines the default sort criteria for all queues displayed in the queue view.' =>
            '',
        'Defines the default sort order for all queues in the queue view, after priority sort.' =>
            '',
        'Defines the default spell checker dictionary.' => '',
        'Defines the default state of new customer tickets in the customer interface.' =>
            '',
        'Defines the default state of new tickets.' => '',
        'Defines the default subject for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Defines the default subject for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            '',
        'Defines the default subject of a note in the ticket free text screen of the agent interface.' =>
            '',
        'Defines the default ticket attribute for ticket sorting in a ticket search of the customer interface.' =>
            '',
        'Defines the default ticket attribute for ticket sorting in the escalation view of the agent interface.' =>
            '',
        'Defines the default ticket attribute for ticket sorting in the locked ticket view of the agent interface.' =>
            '',
        'Defines the default ticket attribute for ticket sorting in the responsible view of the agent interface.' =>
            '',
        'Defines the default ticket attribute for ticket sorting in the status view of the agent interface.' =>
            '',
        'Defines the default ticket attribute for ticket sorting in the watch view of the agent interface.' =>
            '',
        'Defines the default ticket attribute for ticket sorting of the ticket search result of the agent interface.' =>
            '',
        'Defines the default ticket bounced notification for customer/sender in the ticket bounce screen of the agent interface.' =>
            '',
        'Defines the default ticket next state after adding a phone note in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Defines the default ticket next state after adding a phone note in the ticket phone outbound screen of the agent interface.' =>
            '',
        'Defines the default ticket order (after priority sort) in the escalation view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            '',
        'Defines the default ticket order (after priority sort) in the status view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            '',
        'Defines the default ticket order in the responsible view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            '',
        'Defines the default ticket order in the ticket locked view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            '',
        'Defines the default ticket order in the ticket search result of the agent interface. Up: oldest on top. Down: latest on top.' =>
            '',
        'Defines the default ticket order in the watch view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            '',
        'Defines the default ticket order of a search result in the customer interface. Up: oldest on top. Down: latest on top.' =>
            '',
        'Defines the default ticket priority in the close ticket screen of the agent interface.' =>
            '',
        'Defines the default ticket priority in the ticket bulk screen of the agent interface.' =>
            '',
        'Defines the default ticket priority in the ticket free text screen of the agent interface.' =>
            '',
        'Defines the default ticket priority in the ticket note screen of the agent interface.' =>
            '',
        'Defines the default ticket priority in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the default ticket priority in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the default ticket priority in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the default ticket priority in the ticket responsible screen of the agent interface.' =>
            '',
        'Defines the default ticket type for new customer tickets in the customer interface.' =>
            '',
        'Defines the default type for article in the customer interface.' =>
            '',
        'Defines the default type of forwarded message in the ticket forward screen of the agent interface.' =>
            '',
        'Defines the default type of the article for this operation.' => '',
        'Defines the default type of the note in the close ticket screen of the agent interface.' =>
            '',
        'Defines the default type of the note in the ticket bulk screen of the agent interface.' =>
            '',
        'Defines the default type of the note in the ticket free text screen of the agent interface.' =>
            '',
        'Defines the default type of the note in the ticket note screen of the agent interface.' =>
            '',
        'Defines the default type of the note in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the default type of the note in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the default type of the note in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Defines the default type of the note in the ticket phone outbound screen of the agent interface.' =>
            '',
        'Defines the default type of the note in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the default type of the note in the ticket responsible screen of the agent interface.' =>
            '',
        'Defines the default type of the note in the ticket zoom screen of the customer interface.' =>
            '',
        'Defines the default used Frontend-Module if no Action parameter given in the url on the agent interface.' =>
            '',
        'Defines the default used Frontend-Module if no Action parameter given in the url on the customer interface.' =>
            '',
        'Defines the default value for the action parameter for the public frontend. The action parameter is used in the scripts of the system.' =>
            '',
        'Defines the default viewable sender types of a ticket (default: customer).' =>
            '',
        'Defines the filter that processes the text in the articles, in order to highlight URLs.' =>
            '',
        'Defines the format of responses in the ticket compose screen of the agent interface ($QData{"OrigFrom"} is From 1:1, $QData{"OrigFromName"} is only realname of From).' =>
            '',
        'Defines the fully qualified domain name of the system. This setting is used as a variable, OTRS_CONFIG_FQDN which is found in all forms of messaging used by the application, to build links to the tickets within your system.' =>
            '',
        'Defines the groups every customer user will be in (if CustomerGroupSupport is enabled and you don\'t want to manage every user for these groups).' =>
            '',
        'Defines the height for the rich text editor component for this screen. Enter number (pixels) or percent value (relative).' =>
            '',
        'Defines the height for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            '',
        'Defines the height of the legend.' => '',
        'Defines the history comment for the close ticket screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the email ticket screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the phone ticket screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the ticket free text screen action, which gets used for ticket history.' =>
            '',
        'Defines the history comment for the ticket note screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the ticket owner screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the ticket pending screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the ticket phone inbound screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the ticket phone outbound screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the ticket priority screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the ticket responsible screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the ticket zoom action, which gets used for ticket history in the customer interface.' =>
            '',
        'Defines the history comment for this operation, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the close ticket screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the email ticket screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the phone ticket screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the ticket free text screen action, which gets used for ticket history.' =>
            '',
        'Defines the history type for the ticket note screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the ticket owner screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the ticket pending screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the ticket phone inbound screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the ticket phone outbound screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the ticket priority screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the ticket responsible screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the ticket zoom action, which gets used for ticket history in the customer interface.' =>
            '',
        'Defines the history type for this operation, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the hours and week days of the indicated calendar, to count the working time.' =>
            '',
        'Defines the hours and week days to count the working time.' => '',
        'Defines the key to be checked with Kernel::Modules::AgentInfo module. If this user preferences key is true, the message is accepted by the system.' =>
            '',
        'Defines the key to check with CustomerAccept. If this user preferences key is true, then the message is accepted by the system.' =>
            '',
        'Defines the link type \'Normal\'. If the source name and the target name contain the same value, the resulting link is a non-directional one; otherwise, the result is a directional link.' =>
            '',
        'Defines the link type \'ParentChild\'. If the source name and the target name contain the same value, the resulting link is a non-directional one; otherwise, the result is a directional link.' =>
            '',
        'Defines the link type groups. The link types of the same group cancel one another. Example: If ticket A is linked per a \'Normal\' link with ticket B, then these tickets could not be additionally linked with link of a \'ParentChild\' relationship.' =>
            '',
        'Defines the list of online repositories. Another installations can be used as repository, for example: Key="http://example.com/otrs/public.pl?Action=PublicRepository;File=" and Content="Some Name".' =>
            '',
        'Defines the location to get online repository list for additional packages. The first available result will be used.' =>
            '',
        'Defines the log module for the system. "File" writes all messages in a given logfile, "SysLog" uses the syslog daemon of the system, e.g. syslogd.' =>
            '',
        'Defines the maximal size (in bytes) for file uploads via the browser.' =>
            '',
        'Defines the maximal valid time (in seconds) for a session id.' =>
            '',
        'Defines the maximum length (in characters) for a scheduler task data. WARNING: Do not modify this setting unless you are sure of the current Database length for \'task_data\' filed from \'scheduler_data_list\' table.' =>
            '',
        'Defines the maximum number of pages per PDF file.' => '',
        'Defines the maximum size (in MB) of the log file.' => '',
        'Defines the module that shows a generic notification in the agent interface. Either "Text" - if configured - or the contents of "File" will be displayed.' =>
            '',
        'Defines the module that shows all the currently loged in customers in the agent interface.' =>
            '',
        'Defines the module that shows all the currently logged in agents in the agent interface.' =>
            '',
        'Defines the module that shows the currently loged in agents in the customer interface.' =>
            '',
        'Defines the module that shows the currently loged in customers in the customer interface.' =>
            '',
        'Defines the module to authenticate customers.' => '',
        'Defines the module to display a notification in the agent interface, (only for agents on the admin group) if the scheduler is not running.' =>
            '',
        'Defines the module to display a notification in the agent interface, if the agent is logged in while having out-of-office active.' =>
            '',
        'Defines the module to display a notification in the agent interface, if the system is used by the admin user (normally you shouldn\'t work as admin).' =>
            '',
        'Defines the module to generate html refresh headers of html sites, in the customer interface.' =>
            '',
        'Defines the module to generate html refresh headers of html sites.' =>
            '',
        'Defines the module to send emails. "Sendmail" directly uses the sendmail binary of your operating system. Any of the "SMTP" mechanisms use a specified (external) mailserver. "DoNotSendEmail" doesn\'t send emails and it is useful for test systems.' =>
            '',
        'Defines the module used to store the session data. With "DB" the frontend server can be splitted from the db server. "FS" is faster.' =>
            '',
        'Defines the name of the application, shown in the web interface, tabs and title bar of the web browser.' =>
            '',
        'Defines the name of the column to store the data in the preferences table.' =>
            '',
        'Defines the name of the column to store the user identifier in the preferences table.' =>
            '',
        'Defines the name of the indicated calendar.' => '',
        'Defines the name of the key for customer sessions.' => '',
        'Defines the name of the session key. E.g. Session, SessionID or OTRS.' =>
            '',
        'Defines the name of the table, where the customer preferences are stored.' =>
            '',
        'Defines the next possible states after composing / answering a ticket in the ticket compose screen of the agent interface.' =>
            '',
        'Defines the next possible states after forwarding a ticket in the ticket forward screen of the agent interface.' =>
            '',
        'Defines the next possible states for customer tickets in the customer interface.' =>
            '',
        'Defines the next state of a ticket after adding a note, in the close ticket screen of the agent interface.' =>
            '',
        'Defines the next state of a ticket after adding a note, in the ticket bulk screen of the agent interface.' =>
            '',
        'Defines the next state of a ticket after adding a note, in the ticket free text screen of the agent interface.' =>
            '',
        'Defines the next state of a ticket after adding a note, in the ticket note screen of the agent interface.' =>
            '',
        'Defines the next state of a ticket after adding a note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the next state of a ticket after adding a note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the next state of a ticket after adding a note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the next state of a ticket after adding a note, in the ticket responsible screen of the agent interface.' =>
            '',
        'Defines the next state of a ticket after being bounced, in the ticket bounce screen of the agent interface.' =>
            '',
        'Defines the next state of a ticket after being moved to another queue, in the move ticket screen of the agent interface.' =>
            '',
        'Defines the parameters for the customer preferences table.' => '',
        'Defines the parameters for the dashboard backend. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin.' =>
            '',
        'Defines the parameters for the dashboard backend. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" defines the cache expiration period in minutes for the plugin.' =>
            '',
        'Defines the parameters for the dashboard backend. "Limit" defines the number of entries displayed by default. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin.' =>
            '',
        'Defines the parameters for the dashboard backend. "Limit" defines the number of entries displayed by default. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" defines the cache expiration period in minutes for the plugin.' =>
            '',
        'Defines the password to access the SOAP handle (bin/cgi-bin/rpc.pl).' =>
            '',
        'Defines the path and TTF-File to handle bold italic monospaced font in PDF documents.' =>
            '',
        'Defines the path and TTF-File to handle bold italic proportional font in PDF documents.' =>
            '',
        'Defines the path and TTF-File to handle bold monospaced font in PDF documents.' =>
            '',
        'Defines the path and TTF-File to handle bold proportional font in PDF documents.' =>
            '',
        'Defines the path and TTF-File to handle italic monospaced font in PDF documents.' =>
            '',
        'Defines the path and TTF-File to handle italic proportional font in PDF documents.' =>
            '',
        'Defines the path and TTF-File to handle monospaced font in PDF documents.' =>
            '',
        'Defines the path and TTF-File to handle proportional font in PDF documents.' =>
            '',
        'Defines the path for scheduler to store its console output (SchedulerOUT.log and SchedulerERR.log).' =>
            '',
        'Defines the path of the shown info file, that is located under Kernel/Output/HTML/Standard/CustomerAccept.dtl.' =>
            '',
        'Defines the path to PGP binary.' => '',
        'Defines the path to open ssl binary. It may need a HOME env ($ENV{HOME} = \'/var/lib/wwwrun\';).' =>
            '',
        'Defines the placement of the legend. This should be a two letter key of the form: \'B[LCR]|R[TCB]\'. The first letter indicates the placement (Bottom or Right), and the second letter the alignment (Left, Right, Center, Top, or Bottom).' =>
            '',
        'Defines the postmaster default queue.' => '',
        'Defines the receipent target of the phone ticket and the sender of the email ticket ("Queue" shows all queues, "SystemAddress" displays all system addresses) in the agent interface.' =>
            '',
        'Defines the receipent target of the tickets ("Queue" shows all queues, "SystemAddress" displays all system addresses) in the customer interface.' =>
            '',
        'Defines the required permission to show a ticket in the escalation view of the agent interface.' =>
            '',
        'Defines the search limit for the stats.' => '',
        'Defines the sender for rejected emails.' => '',
        'Defines the separator between the agents real name and the given queue email address.' =>
            '',
        'Defines the spacing of the legends.' => '',
        'Defines the standard permissions available for customers within the application. If more permissions are needed, you can enter them here. Permissions must be hard coded to be effective. Please ensure, when adding any of the afore mentioned permissions, that the "rw" permission remains the last entry.' =>
            '',
        'Defines the standard size of PDF pages.' => '',
        'Defines the state of a ticket if it gets a follow-up and the ticket was already closed.' =>
            '',
        'Defines the state of a ticket if it gets a follow-up.' => '',
        'Defines the state type of the reminder for pending tickets.' => '',
        'Defines the subject for notification mails sent to agents, about new password.' =>
            '',
        'Defines the subject for notification mails sent to agents, with token about new requested password.' =>
            '',
        'Defines the subject for notification mails sent to customers, about new account.' =>
            '',
        'Defines the subject for notification mails sent to customers, about new password.' =>
            '',
        'Defines the subject for notification mails sent to customers, with token about new requested password.' =>
            '',
        'Defines the subject for rejected emails.' => '',
        'Defines the system administrator\'s email address. It will be displayed in the error screens of the application.' =>
            '',
        'Defines the system identifier. Every ticket number and http session string contain this ID. This ensures that only tickets which belong to your system will be processed as follow-ups (useful when communicating between two instances of OTRS).' =>
            '',
        'Defines the target attribute in the link to external customer database. E.g. \'AsPopup PopupType_TicketAction\'.' =>
            '',
        'Defines the target attribute in the link to external customer database. E.g. \'target="cdb"\'.' =>
            '',
        'Defines the time in days to keep log backup files.' => '',
        'Defines the time in seconds after which the Scheduler performs an automatic self-restart.' =>
            '',
        'Defines the time zone of the indicated calendar, which can be assigned later to a specific queue.' =>
            '',
        'Defines the type of protocol, used by ther web server, to serve the application. If https protocol will be used instead of plain http, it must be specified it here. Since this has no affect on the web server\'s settings or behavior, it will not change the method of access to the application and, if it is wrong, it will not prevent you from logging into the application. This setting is used as a variable, OTRS_CONFIG_HttpType which is found in all forms of messaging used by the application, to build links to the tickets within your system.' =>
            '',
        'Defines the used character for email quotes in the ticket compose screen of the agent interface.' =>
            '',
        'Defines the user identifier for the customer panel.' => '',
        'Defines the username to access the SOAP handle (bin/cgi-bin/rpc.pl).' =>
            '',
        'Defines the valid state types for a ticket.' => '',
        'Defines the valid states for unlocked tickets. To unlock tickets the script "bin/otrs.UnlockTickets.pl" can be used.' =>
            '',
        'Defines the viewable locks of a ticket. Default: unlock, tmp_lock.' =>
            '',
        'Defines the width for the rich text editor component for this screen. Enter number (pixels) or percent value (relative).' =>
            '',
        'Defines the width for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            '',
        'Defines the width of the legend.' => '',
        'Defines which article sender types should be shown in the preview of a ticket.' =>
            '',
        'Defines which states should be set automatically (Content), after the pending time of state (Key) has been reached.' =>
            '',
        'Defines wich article type should be expanded when entering the overview. If nothing defined, latest article will be expanded.' =>
            '',
        'Delay time between autocomplete queries in milliseconds.' => '',
        'Deletes a session if the session id is used with an invalid remote IP address.' =>
            '',
        'Deletes requested sessions if they have timed out.' => '',
        'Determines if the list of possible queues to move to ticket into should be displayed in a dropdown list or in a new window in the agent interface. If "New Window" is set you can add a move note to the ticket.' =>
            '',
        'Determines if the search results container for the autocomplete feature should adjust its width dynamically.' =>
            '',
        'Determines if the statistics module may generate ticket lists.' =>
            '',
        'Determines the next possible ticket states, after the creation of a new email ticket in the agent interface.' =>
            '',
        'Determines the next possible ticket states, after the creation of a new phone ticket in the agent interface.' =>
            '',
        'Determines the next possible ticket states, for process tickets in the agent interface.' =>
            '',
        'Determines the next screen after new customer ticket in the customer interface.' =>
            '',
        'Determines the next screen after the follow up screen of a zoomed ticket in the customer interface.' =>
            '',
        'Determines the next screen after the ticket is moved. LastScreenOverview will return to search results, queueview, dashboard or the like, LastScreenView will return to TicketZoom.' =>
            '',
        'Determines the possible states for pending tickets that changed state after reaching time limit.' =>
            '',
        'Determines the strings that will be shown as receipent (To:) of the phone ticket and as sender (From:) of the email ticket in the agent interface. For Queue as NewQueueSelectionType "<Queue>" shows the names of the queues and for SystemAddress "<Realname> <<Email>>" shows the name and email of the receipent.' =>
            '',
        'Determines the strings that will be shown as receipent (To:) of the ticket in the customer interface. For Queue as CustomerPanelSelectionType, "<Queue>" shows the names of the queues, and for SystemAddress, "<Realname> <<Email>>" shows the name and email of the receipent.' =>
            '',
        'Determines the way the linked objects are displayed in each zoom mask.' =>
            '',
        'Determines which options will be valid of the recepient (phone ticket) and the sender (email ticket) in the agent interface.' =>
            '',
        'Determines which queues will be valid for ticket\'s recepients in the customer interface.' =>
            '',
        'Disables sending reminder notifications to the responsible agent of a ticket (Ticket::Responsible needs to be activated).' =>
            '',
        'Disables the web installer (http://yourhost.example.com/otrs/installer.pl), to prevent the system from being hijacked. If set to "No", the system can be reinstalled and the current basic configuration will be used to pre-populate the questions within the installer script. If not active, it also disables the GenericAgent, PackageManager and SQL Box.' =>
            '',
        'Display settings to override defaults for Process Tickets.' => '',
        'Displays the accounted time for an article in the ticket zoom view.' =>
            '',
        'Dropdown' => '',
        'Dynamic Fields Checkbox Backend GUI' => '',
        'Dynamic Fields Date Time Backend GUI' => '',
        'Dynamic Fields Drop-down Backend GUI' => '',
        'Dynamic Fields GUI' => '',
        'Dynamic Fields Multiselect Backend GUI' => '',
        'Dynamic Fields Overview Limit' => '',
        'Dynamic Fields Text Backend GUI' => '',
        'Dynamic Fields used to export the search result in CSV format.' =>
            '',
        'Dynamic fields groups for process widget. The key is the name of the group, the value contains the fields to be shown. Example: \'Key => My Group\', \'Content: Name_X, NameY\'.' =>
            '',
        'Dynamic fields limit per page for Dynamic Fields Overview' => '',
        'Dynamic fields options shown in the ticket message screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required. NOTE. If you want to display these fields also in the ticket zoom of the customer interface, you have to enable them in CustomerTicketZoom###DynamicField.' =>
            '',
        'Dynamic fields options shown in the ticket reply section in the ticket zoom screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the process widget in ticket zoom screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'Dynamic fields shown in the sidebar of the ticket zoom screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'Dynamic fields shown in the ticket close screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket compose screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket email screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket forward screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket free text screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket medium format overview screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'Dynamic fields shown in the ticket move screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket note screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket overview screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket owner screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket pending screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket phone inbound screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket phone outbound screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket phone screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket preview format overview screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'Dynamic fields shown in the ticket print screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'Dynamic fields shown in the ticket print screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'Dynamic fields shown in the ticket priority screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket responsible screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket search overview results screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'Dynamic fields shown in the ticket search screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and shown by default.' =>
            '',
        'Dynamic fields shown in the ticket search screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'Dynamic fields shown in the ticket small format overview screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'Dynamic fields shown in the ticket zoom screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'DynamicField backend registration.' => '',
        'DynamicField object registration.' => '',
        'Edit customer company' => '',
        'Email Addresses' => 'E-mailadressen',
        'Enable keep-alive connection header for SOAP responses.' => '',
        'Enables PDF output. The CPAN module PDF::API2 is required, if not installed, PDF output will be disabled.' =>
            '',
        'Enables PGP support. When PGP support is enabled for signing and securing mail, it is HIGHLY recommended that the web server be run as the OTRS user. Otherwise, there will be problems with the privileges when accessing .gnupg folder.' =>
            '',
        'Enables S/MIME support.' => '',
        'Enables customers to create their own accounts.' => '',
        'Enables file upload in the package manager frontend.' => '',
        'Enables or disable the debug mode over frontend interface.' => '',
        'Enables or disables the autocomplete feature for the customer search in the agent interface.' =>
            '',
        'Enables or disables the ticket watcher feature, to keep track of tickets without being the owner nor the responsible.' =>
            '',
        'Enables performance log (to log the page response time). It will affect the system performance. Frontend::Module###AdminPerformanceLog must be enabled.' =>
            '',
        'Enables spell checker support.' => '',
        'Enables ticket bulk action feature for the agent frontend to work on more than one ticket at a time.' =>
            '',
        'Enables ticket bulk action feature only for the listed groups.' =>
            '',
        'Enables ticket responsible feature, to keep track of a specific ticket.' =>
            '',
        'Enables ticket watcher feature only for the listed groups.' => '',
        'Escalation view' => 'Escalatieoverzicht',
        'Event list to be displayed on GUI to trigger generic interface invokers.' =>
            '',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate).' =>
            '',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate). This is only possible if all Ticket dynamic fields need the same event.' =>
            '',
        'Execute SQL statements.' => 'Voer SQL statements uit op de database.',
        'Executes follow up checks on In-Reply-To or References headers for mails that don\'t have a ticket number in the subject.' =>
            '',
        'Executes follow up mail attachments checks in  mails that don\'t have a ticket number in the subject.' =>
            '',
        'Executes follow up mail body checks in mails that don\'t have a ticket number in the subject.' =>
            '',
        'Executes follow up plain/raw mail checks in mails that don\'t have a ticket number in the subject.' =>
            '',
        'Exports the whole article tree in search result (it can affect the system performance).' =>
            '',
        'Fetches packages via proxy. Overwrites "WebUserAgent::Proxy".' =>
            '',
        'File that is displayed in the Kernel::Modules::AgentInfo module, if located under Kernel/Output/HTML/Standard/AgentInfo.dtl.' =>
            '',
        'Filter incoming emails.' => 'Filter inkomende e-mails.',
        'FirstLock' => '',
        'FirstResponse' => '',
        'FirstResponseDiffInMin' => '',
        'FirstResponseInMin' => '',
        'Forces encoding of outgoing emails (7bit|8bit|quoted-printable|base64).' =>
            '',
        'Forces to choose a different ticket state (from current) after lock action. Define the current state as key, and the next state after lock action as content.' =>
            '',
        'Forces to unlock tickets after being moved to another queue.' =>
            '',
        'Frontend language' => 'Taal',
        'Frontend module registration (disable company link if no company feature is used).' =>
            '',
        'Frontend module registration (disable ticket processes screen if no process available).' =>
            '',
        'Frontend module registration for the agent interface.' => '',
        'Frontend module registration for the customer interface.' => '',
        'Frontend theme' => 'Thema',
        'Fulltext index regex filters to remove parts of the text.' => '',
        'GenericAgent' => 'Automatische taken',
        'GenericInterface Debugger GUI' => '',
        'GenericInterface Invoker GUI' => '',
        'GenericInterface Operation GUI' => '',
        'GenericInterface TransportHTTPSOAP GUI' => '',
        'GenericInterface Web Service GUI' => '',
        'GenericInterface Webservice History GUI' => '',
        'GenericInterface Webservice Mapping GUI' => '',
        'GenericInterface module registration for the invoker layer.' => '',
        'GenericInterface module registration for the mapping layer.' => '',
        'GenericInterface module registration for the operation layer.' =>
            '',
        'GenericInterface module registration for the transport layer.' =>
            '',
        'Gives end users the possibility to override the separator character for CSV files, defined in the translation files.' =>
            '',
        'Grants access, if the customer ID of the ticket matches the customer user\'s ID and the customer user has group permissions on the queue the ticket is in.' =>
            '',
        'Helps to extend your articles full-text search (From, To, Cc, Subject and Body search). Runtime will do full-text searches on live data (it works fine for up to 50.000 tickets). StaticDB will strip all articles and will build an index after article creation, increasing fulltext searches about 50%. To create an initial index use "bin/otrs.RebuildFulltextIndex.pl".' =>
            '',
        'If "DB" was selected for Customer::AuthModule, a database driver (normally autodetection is used) can be specified.' =>
            '',
        'If "DB" was selected for Customer::AuthModule, a password to connect to the customer table can be specified.' =>
            '',
        'If "DB" was selected for Customer::AuthModule, a username to connect to the customer table can be specified.' =>
            '',
        'If "DB" was selected for Customer::AuthModule, the DSN for the connection to the customer table must be specified.' =>
            '',
        'If "DB" was selected for Customer::AuthModule, the column name for the CustomerPassword in the customer table must be specified.' =>
            '',
        'If "DB" was selected for Customer::AuthModule, the crypt type of passwords must be specified.' =>
            '',
        'If "DB" was selected for Customer::AuthModule, the name of the column for the CustomerKey in the customer table must be specified.' =>
            '',
        'If "DB" was selected for Customer::AuthModule, the name of the table where your customer data should be stored must be specified.' =>
            '',
        'If "DB" was selected for SessionModule, a table in database where session data will be stored must be specified.' =>
            '',
        'If "FS" was selected for SessionModule, a directory where the session data will be stored must be specified.' =>
            '',
        'If "HTTPBasicAuth" was selected for Customer::AuthModule, you can specify (by using a RegExp) to strip parts of REMOTE_USER (e. g. for to remove trailing domains). RegExp-Note, $1 will be the new Login.' =>
            '',
        'If "HTTPBasicAuth" was selected for Customer::AuthModule, you can specify to strip leading parts of user names (e. g. for domains like example_domain\user to user).' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule and if you want to add a suffix to every customer login name, specifiy it here, e. g. you just want to write the username user but in your LDAP directory exists user@domain.' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule and special paramaters are needed for the Net::LDAP perl module, you can specify them here. See "perldoc Net::LDAP" for more information about the parameters.' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule and your users have only anonymous access to the LDAP tree, but you want to search through the data, you can do this with a user who has access to the LDAP directory. Specify the password for this special user here.' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule and your users have only anonymous access to the LDAP tree, but you want to search through the data, you can do this with a user who has access to the LDAP directory. Specify the username for this special user here.' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule, the BaseDN must be specified.' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule, the LDAP host can be specified.' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule, the user identifier must be specified.' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule, user attributes can be specified. For LDAP posixGroups use UID, for non LDAP posixGroups use full user DN.' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule, you can specify access attributes here.' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule, you can specify if the applications will stop if e. g. a connection to a server can\'t be established due to network problems.' =>
            '',
        'If "LDAP" was selected for Customer::Authmodule, you can check if the user is allowed to authenticate because he is in a posixGroup, e.g. user needs to be in a group xyz to use OTRS. Specify the group, who may access the system.' =>
            '',
        'If "LDAP" was selected, you can add a filter to each LDAP query, e.g. (mail=*), (objectclass=user) or (!objectclass=computer).' =>
            '',
        'If "Radius" was selected for Customer::AuthModule, the password to authenticate to the radius host must be specified.' =>
            '',
        'If "Radius" was selected for Customer::AuthModule, the radius host must be specified.' =>
            '',
        'If "Radius" was selected for Customer::AuthModule, you can specify if the applications will stop if e. g. a connection to a server can\'t be established due to network problems.' =>
            '',
        'If "Sendmail" was selected as SendmailModule, the location of the sendmail binary and the needed options must be specified.' =>
            '',
        'If "SysLog" was selected for LogModule, a special log facility can be specified.' =>
            '',
        'If "SysLog" was selected for LogModule, a special log sock can be specified (on solaris you may need to use \'stream\').' =>
            '',
        'If "SysLog" was selected for LogModule, the charset that should be used for logging can be specified.' =>
            '',
        'If "file" was selected for LogModule, a logfile must be specified. If the file doesn\'t exist, it will be created by the system.' =>
            '',
        'If a note is added by an agent, sets the state of a ticket in the close ticket screen of the agent interface.' =>
            '',
        'If a note is added by an agent, sets the state of a ticket in the ticket bulk screen of the agent interface.' =>
            '',
        'If a note is added by an agent, sets the state of a ticket in the ticket free text screen of the agent interface.' =>
            '',
        'If a note is added by an agent, sets the state of a ticket in the ticket note screen of the agent interface.' =>
            '',
        'If a note is added by an agent, sets the state of a ticket in the ticket responsible screen of the agent interface.' =>
            '',
        'If a note is added by an agent, sets the state of the ticket in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'If a note is added by an agent, sets the state of the ticket in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'If a note is added by an agent, sets the state of the ticket in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, and authentication to the mail server is needed, a password must be specified.' =>
            '',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, and authentication to the mail server is needed, an username must be specified.' =>
            '',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, the mailhost that sends out the mails must be specified.' =>
            '',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, the port where your mailserver is listening for incoming connections must be specified.' =>
            '',
        'If enabled, OTRS will deliver all CSS files in minified form. WARNING: If you turn this off, there will likely be problems in IE 7, because it cannot load more than 32 CSS files.' =>
            '',
        'If enabled, OTRS will deliver all JavaScript files in minified form.' =>
            '',
        'If enabled, TicketPhone and TicketEmail will be open in new windows.' =>
            '',
        'If enabled, the OTRS version tag will be removed from the HTTP headers.' =>
            '',
        'If enabled, the different overviews (Dashboard, LockedView, QueueView) will automatically refresh after the specified time.' =>
            'Indien geactiveerd worden de verschillende overzichten (Dashboard, vergrendelde tickets, wachtrijoverzicht) automatisch ververst na de ingestelde tijd.',
        'If enabled, the first level of the main menu opens on mouse hover (instead of click only).' =>
            '',
        'If set, this address is used as envelope sender header in outgoing notifications. If no address is specified, the envelope sender header is empty.' =>
            '',
        'If this regex matches, no message will be send by the autoresponder.' =>
            '',
        'If you want to use a mirror database for agent ticket fulltext search or to generate stats, specify the DSN to this database.' =>
            '',
        'If you want to use a mirror database for agent ticket fulltext search or to generate stats, the password to authenticate to this database can be specified.' =>
            '',
        'If you want to use a mirror database for agent ticket fulltext search or to generate stats, the user to authenticate to this database can be specified.' =>
            '',
        'Ignore article with system sender type for new article feature (e. g. auto responses or email notifications).' =>
            '',
        'Includes article create times in the ticket search of the agent interface.' =>
            '',
        'IndexAccelerator: to choose your backend TicketViewAccelerator module. "RuntimeDB" generates each queue view on the fly from ticket table (no performance problems up to approx. 60.000 tickets in total and 6.000 open tickets in the system). "StaticDB" is the most powerful module, it uses an extra ticket-index table that works like a view (recommended if more than 80.000 and 6.000 open tickets are stored in the system). Use the script "bin/otrs.RebuildTicketIndex.pl" for initial index update.' =>
            '',
        'Install ispell or aspell on the system, if you want to use a spell checker. Please specify the path to the aspell or ispell binary on your operating system.' =>
            '',
        'Interface language' => 'Taal',
        'It is possible to configure different skins, for example to distinguish between diferent agents, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            '',
        'It is possible to configure different skins, for example to distinguish between diferent customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            '',
        'It is possible to configure different themes, for example to distinguish between agents and customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid theme on your system. Please see the example entries for the proper form of the regex.' =>
            '',
        'Link agents to groups.' => 'Koppel gebruikers aan groepen.',
        'Link agents to roles.' => 'Koppel gebruikers aan rollen.',
        'Link attachments to responses templates.' => 'Koppel standaard-antwoorden aan bijlagen.',
        'Link customers to groups.' => 'Koppel klanten aan groepen.',
        'Link customers to services.' => 'Koppel klanten aan services.',
        'Link queues to auto responses.' => 'Koppel wachtrijen aan automatische antwoorden.',
        'Link responses to queues.' => 'Koppel standaard-antwoorden aan wachtrijen.',
        'Link roles to groups.' => 'Koppel rollen aan groepen.',
        'Links 2 tickets with a "Normal" type link.' => 'Koppelt twee tickets met een "Normaal"-type koppeling.',
        'Links 2 tickets with a "ParentChild" type link.' => 'Koppelt twee tickets met een "vader - zoon"-type koppeling.',
        'List of CSS files to always be loaded for the agent interface.' =>
            '',
        'List of CSS files to always be loaded for the customer interface.' =>
            '',
        'List of IE7-specific CSS files to always be loaded for the customer interface.' =>
            '',
        'List of IE8-specific CSS files to always be loaded for the agent interface.' =>
            '',
        'List of IE8-specific CSS files to always be loaded for the customer interface.' =>
            '',
        'List of JS files to always be loaded for the agent interface.' =>
            '',
        'List of JS files to always be loaded for the customer interface.' =>
            '',
        'List of default StandardResponses which are assigned automatically to new Queues upon creation.' =>
            '',
        'Log file for the ticket counter.' => '',
        'Mail Accounts' => '',
        'Main menu registration.' => '',
        'Makes the application check the MX record of email addresses before sending an email or submitting a telephone or email ticket.' =>
            '',
        'Makes the application check the syntax of email addresses.' => '',
        'Makes the picture transparent.' => '',
        'Makes the session management use html cookies. If html cookies are disabled or if the client browser disabled html cookies, then the system will work as usual and append the session id to the links.' =>
            '',
        'Manage PGP keys for email encryption.' => 'Beheer PGP-sleutels voor encryptie van e-mail.',
        'Manage POP3 or IMAP accounts to fetch email from.' => 'Beheer POP3 of IMAP accounts om e-mail van op te halen en om te zetten in tickets.',
        'Manage S/MIME certificates for email encryption.' => 'Beheer S/MIME certificaten voor encryptie van e-mail.',
        'Manage existing sessions.' => 'Beheer sessies van klanten en gebruikers.',
        'Manage notifications that are sent to agents.' => 'Beheer van notificatieteksten.',
        'Manage periodic tasks.' => 'Beheer terugkerende taken.',
        'Max size (in characters) of the customer information table (phone and email) in the compose screen.' =>
            '',
        'Max size (in rows) of the informed agents box in the agent interface.' =>
            '',
        'Max size (in rows) of the involved agents box in the agent interface.' =>
            '',
        'Max size of the subjects in an email reply.' => '',
        'Maximal auto email responses to own email-address a day (Loop-Protection).' =>
            '',
        'Maximal size in KBytes for mails that can be fetched via POP3/POP3S/IMAP/IMAPS (KBytes).' =>
            '',
        'Maximum number of tickets to be displayed in the result of a search in the agent interface.' =>
            '',
        'Maximum number of tickets to be displayed in the result of a search in the customer interface.' =>
            '',
        'Maximum size (in characters) of the customer information table in the ticket zoom view.' =>
            '',
        'Module for To-selection in new ticket screen in the customer interface.' =>
            '',
        'Module to check customer permissions.' => '',
        'Module to check if a user is in a special group. Access is granted, if the user is in the specified group and has ro and rw permissions.' =>
            '',
        'Module to check if arrived emails should be marked as email-internal (because of original forwared internal email it college). ArticleType and SenderType define the values for the arrived email/article.' =>
            '',
        'Module to check the agent responsible of a ticket.' => '',
        'Module to check the group permissions for the access to customer tickets.' =>
            '',
        'Module to check the owner of a ticket.' => '',
        'Module to check the watcher agents of a ticket.' => '',
        'Module to compose signed messages (PGP or S/MIME).' => '',
        'Module to crypt composed messages (PGP or S/MIME).' => '',
        'Module to filter and manipulate incoming messages. Block/ignore all spam email with From: noreply@ address.' =>
            '',
        'Module to filter and manipulate incoming messages. Get a 4 digit number to ticket free text, use regex in Match e. g. From => \'(.+?)@.+?\', and use () as [***] in Set =>.' =>
            '',
        'Module to generate accounted time ticket statistics.' => '',
        'Module to generate html OpenSearch profile for short ticket search in the agent interface.' =>
            '',
        'Module to generate html OpenSearch profile for short ticket search in the customer interface.' =>
            '',
        'Module to generate ticket solution and response time statistics.' =>
            '',
        'Module to generate ticket statistics.' => '',
        'Module to show notifications and escalations (ShownMax: max. shown escalations, EscalationInMinutes: Show ticket which will escalation in, CacheTime: Cache of calculated escalations in seconds).' =>
            '',
        'Module to use database filter storage.' => '',
        'Multiselect' => '',
        'My Tickets' => 'Mijn tickets',
        'Name of custom queue. The custom queue is a queue selection of your preferred queues and can be selected in the preferences settings.' =>
            '',
        'NameX' => '',
        'New email ticket' => 'Nieuw e-mail-ticket',
        'New phone ticket' => 'Nieuw telefoon-ticket',
        'New process ticket' => 'Nieuw proces-ticket',
        'Next possible ticket states after adding a phone note in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Next possible ticket states after adding a phone note in the ticket phone outbound screen of the agent interface.' =>
            '',
        'Notifications (Event)' => 'Meldingen (gebeurtenis)',
        'Number of displayed tickets' => 'Aantal weergegeven tickets',
        'Number of lines (per ticket) that are shown by the search utility in the agent interface.' =>
            '',
        'Number of tickets to be displayed in each page of a search result in the agent interface.' =>
            '',
        'Number of tickets to be displayed in each page of a search result in the customer interface.' =>
            '',
        'Open tickets of customer' => 'Open tickets van klant',
        'Overloads (redefines) existing functions in Kernel::System::Ticket. Used to easily add customizations.' =>
            '',
        'Overview Escalated Tickets' => 'Overzicht geëscaleerde tickets',
        'Overview Refresh Time' => 'Verversingsinterval overzichten',
        'Overview of all open Tickets.' => 'Overzicht van alle openstaande tickets',
        'PGP Key Management' => '',
        'PGP Key Upload' => 'PGP sleutel upload',
        'Parameters for the CreateNextMask object in the preference view of the agent interface.' =>
            '',
        'Parameters for the CustomQueue object in the preference view of the agent interface.' =>
            '',
        'Parameters for the FollowUpNotify object in the preference view of the agent interface.' =>
            '',
        'Parameters for the LockTimeoutNotify object in the preference view of the agent interface.' =>
            '',
        'Parameters for the MoveNotify object in the preference view of the agent interface.' =>
            '',
        'Parameters for the NewTicketNotify object in the preferences view of the agent interface.' =>
            '',
        'Parameters for the RefreshTime object in the preference view of the agent interface.' =>
            '',
        'Parameters for the WatcherNotify object in the preference view of the agent interface.' =>
            '',
        'Parameters for the dashboard backend of the customer company information of the agent interface . "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the customer id status widget of the agent interface . "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the customer user list overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the new tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the ticket calendar of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the ticket escalation overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the ticket pending reminder overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the ticket pending reminder overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the ticket stats of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the pages (in which the dynamic fields are shown) of the dynamic fields overview.' =>
            '',
        'Parameters for the pages (in which the tickets are shown) of the medium ticket overview.' =>
            '',
        'Parameters for the pages (in which the tickets are shown) of the small ticket overview.' =>
            '',
        'Parameters for the pages (in which the tickets are shown) of the ticket preview overview.' =>
            '',
        'Parameters of the example SLA attribute Comment2.' => '',
        'Parameters of the example queue attribute Comment2.' => '',
        'Parameters of the example service attribute Comment2.' => '',
        'Path for the log file (it only applies if "FS" was selected for LoopProtectionModule and it is mandatory).' =>
            '',
        'Path of the file that stores all the settings for the QueueObject object for the agent interface.' =>
            '',
        'Path of the file that stores all the settings for the QueueObject object for the customer interface.' =>
            '',
        'Path of the file that stores all the settings for the TicketObject for the agent interface.' =>
            '',
        'Path of the file that stores all the settings for the TicketObject for the customer interface.' =>
            '',
        'Performs the configured action for each event (as an Invoker) for each configured Webservice.' =>
            '',
        'Permitted width for compose email windows.' => '',
        'Permitted width for compose note windows.' => '',
        'Picture-Upload' => '',
        'PostMaster Filters' => 'E-mail filters',
        'PostMaster Mail Accounts' => 'E-mail accounts',
        'Process Information' => 'Procesinformatie',
        'Process Management Activity Dialog GUI' => 'Procesbeheer dialoog',
        'Process Management Activity GUI' => 'Procesbeheer activiteit',
        'Process Management Path GUI' => 'Procesbeheer pad',
        'Process Management Transition Action GUI' => 'Procesbeheer transitie-actie',
        'Process Management Transition GUI' => 'Procesbeheer transitie',
        'Protection against CSRF (Cross Site Request Forgery) exploits (for more info see http://en.wikipedia.org/wiki/Cross-site_request_forgery).' =>
            '',
        'Queue view' => 'Wachtrijoverzicht',
        'Refresh Overviews after' => 'Ververs Overzichten na',
        'Refresh interval' => 'Interval',
        'Removes the ticket watcher information when a ticket is archived.' =>
            '',
        'Replaces the original sender with current customer\'s email address on compose answer in the ticket compose screen of the agent interface.' =>
            '',
        'Required permissions to change the customer of a ticket in the agent interface.' =>
            '',
        'Required permissions to use the close ticket screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket bounce screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket compose screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket forward screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket free text screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket merge screen of a zoomed ticket in the agent interface.' =>
            '',
        'Required permissions to use the ticket note screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Required permissions to use the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Required permissions to use the ticket phone inbound screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket phone outbound screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Required permissions to use the ticket responsible screen in the agent interface.' =>
            '',
        'Resets and unlocks the owner of a ticket if it was moved to another queue.' =>
            '',
        'Responses <-> Queues' => 'Standaard-antwoorden <-> Wachtrijen',
        'Restores a ticket from the archive (only if the event is a state change, from closed to any open available state).' =>
            '',
        'Roles <-> Groups' => 'Rollen <-> Groepen',
        'Runs an initial wildcard search of the existing customer users when accessing the AdminCustomerUser module.' =>
            '',
        'Runs the system in "Demo" mode. If set to "Yes", agents can change preferences, such as selection of language and theme via the agent web interface. These changes are only valid for the current session. It will not be possible for agents to change their passwords.' =>
            '',
        'S/MIME Certificate Upload' => 'S/MIME Certificaten Uploaden',
        'Saves the attachments of articles. "DB" stores all data in the database (not recommended for storing big attachments). "FS" stores the data on the filesystem; this is faster but the webserver should run under the OTRS user. You can switch between the modules even on a system that is already in production without any loss of data.' =>
            '',
        'Search backend default router.' => '',
        'Search backend router.' => '',
        'Select your frontend Theme.' => 'Kies uw thema',
        'Selects the cache backend to use.' => '',
        'Selects the module to handle uploads via the web interface. "DB" stores all uploads in the database, "FS" uses the file system.' =>
            '',
        'Selects the ticket number generator module. "AutoIncrement" increments the ticket number, the SystemID and the counter are used with SystemID.counter format (e.g. 1010138, 1010139). With "Date" the ticket numbers will be generated by the current date, the SystemID and the counter. The format looks like Year.Month.Day.SystemID.counter (e.g. 200206231010138, 200206231010139). With "DateChecksum"  the counter will be appended as checksum to the string of date and SystemID. The checksum will be rotated on a daily basis. The format looks like Year.Month.Day.SystemID.Counter.CheckSum (e.g. 2002070110101520, 2002070110101535). "Random" generates randomized ticket numbers in the format "SystemID.Random" (e.g. 100057866352, 103745394596).' =>
            '',
        'Send me a notification if a customer sends a follow up and I\'m the owner of the ticket or the ticket is unlocked and is in one of my subscribed queues.' =>
            'Stuur mij een melding als een reactie op een ticket binnenkomt en ik de eigenaar van het ticket ben, of het ticket ontgrendeld is en in één van \'Mijn wachtrijen\' staat.',
        'Send notifications to users.' => 'Stuur berichten aan gebruikers.',
        'Send ticket follow up notifications' => 'Stuur meldingen bij reacties op een ticket',
        'Sender type for new tickets from the customer inteface.' => '',
        'Sends agent follow-up notification only to the owner, if a ticket is unlocked (the default is to send the notification to all agents).' =>
            '',
        'Sends all outgoing email via bcc to the specified address. Please use this only for backup reasons.' =>
            '',
        'Sends customer notifications just to the mapped customer. Normally, if no customer is mapped, the latest customer sender gets the notification.' =>
            '',
        'Sends reminder notifications of unlocked ticket after reaching the reminder date (only sent to ticket owner).' =>
            '',
        'Sends the notifications which are configured in the admin interface under "Notfication (Event)".' =>
            '',
        'Set sender email addresses for this system.' => 'Instellen van e-mailadressen gebruikt voor dit systeem.',
        'Set the default height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            '',
        'Set the maximum height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            '',
        'Set this to yes if you trust in all your public and private pgp keys, even if they are not certified with a trusted signature.' =>
            '',
        'Sets if ticket owner must be selected by the agent.' => '',
        'Sets the PendingTime of a ticket to 0 if the state is changed to a non-pending state.' =>
            '',
        'Sets the age in minutes (first level) for highlighting queues that contain untouched tickets.' =>
            '',
        'Sets the age in minutes (second level) for highlighting queues that contain untouched tickets.' =>
            '',
        'Sets the configuration level of the administrator. Depending on the config level, some sysconfig options will be not shown. The config levels are in in ascending order: Expert, Advanced, Beginner. The higher the config level is (e.g. Beginner is the highest), the less likely is it that the user can accidentally configure the system in a way that it is not usable any more.' =>
            '',
        'Sets the default article type for new email tickets in the agent interface.' =>
            '',
        'Sets the default article type for new phone tickets in the agent interface.' =>
            '',
        'Sets the default body text for notes added in the close ticket screen of the agent interface.' =>
            '',
        'Sets the default body text for notes added in the ticket move screen of the agent interface.' =>
            '',
        'Sets the default body text for notes added in the ticket note screen of the agent interface.' =>
            '',
        'Sets the default body text for notes added in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the default body text for notes added in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the default body text for notes added in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the default body text for notes added in the ticket responsible screen of the agent interface.' =>
            '',
        'Sets the default link type of splitted tickets in the agent interface.' =>
            '',
        'Sets the default next state for new phone tickets in the agent interface.' =>
            '',
        'Sets the default next ticket state, after the creation of an email ticket in the agent interface.' =>
            '',
        'Sets the default note text for new telephone tickets. E.g \'New ticket via call\' in the agent interface.' =>
            '',
        'Sets the default priority for new email tickets in the agent interface.' =>
            '',
        'Sets the default priority for new phone tickets in the agent interface.' =>
            '',
        'Sets the default sender type for new email tickets in the agent interface.' =>
            '',
        'Sets the default sender type for new phone ticket in the agent interface.' =>
            '',
        'Sets the default subject for new email tickets (e.g. \'email Outbound\') in the agent interface.' =>
            '',
        'Sets the default subject for new phone tickets (e.g. \'Phone call\') in the agent interface.' =>
            '',
        'Sets the default subject for notes added in the close ticket screen of the agent interface.' =>
            '',
        'Sets the default subject for notes added in the ticket move screen of the agent interface.' =>
            '',
        'Sets the default subject for notes added in the ticket note screen of the agent interface.' =>
            '',
        'Sets the default subject for notes added in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the default subject for notes added in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the default subject for notes added in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the default subject for notes added in the ticket responsible screen of the agent interface.' =>
            '',
        'Sets the default text for new email tickets in the agent interface.' =>
            '',
        'Sets the display order of the different items in the preferences view.' =>
            '',
        'Sets the inactivity time (in seconds) to pass before a session is killed and a user is loged out.' =>
            '',
        'Sets the maximum number of active agents within the timespan defined in SessionActiveTime.' =>
            '',
        'Sets the maximum number of active customers within the timespan defined in SessionActiveTime.' =>
            '',
        'Sets the minimal ticket counter size (if "AutoIncrement" was selected as TicketNumberGenerator). Default is 5, this means the counter starts from 10000.' =>
            '',
        'Sets the minimum number of characters before autocomplete query is sent.' =>
            '',
        'Sets the number of lines that are displayed in text messages (e.g. ticket lines in the QueueZoom).' =>
            '',
        'Sets the number of search results to be displayed for the autocomplete feature.' =>
            '',
        'Sets the options for PGP binary.' => '',
        'Sets the order of the different items in the customer preferences view.' =>
            '',
        'Sets the password for private PGP key.' => '',
        'Sets the prefered time units (e.g. work units, hours, minutes).' =>
            '',
        'Sets the prefix to the scripts folder on the server, as configured on the web server. This setting is used as a variable, OTRS_CONFIG_ScriptAlias which is found in all forms of messaging used by the application, to build links to the tickets within the system.' =>
            '',
        'Sets the queue in the ticket close screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the queue in the ticket free text screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the queue in the ticket note screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the queue in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the queue in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the queue in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the queue in the ticket responsible screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the responsible agent of the ticket in the close ticket screen of the agent interface.' =>
            '',
        'Sets the responsible agent of the ticket in the ticket bulk screen of the agent interface.' =>
            '',
        'Sets the responsible agent of the ticket in the ticket free text screen of the agent interface.' =>
            '',
        'Sets the responsible agent of the ticket in the ticket note screen of the agent interface.' =>
            '',
        'Sets the responsible agent of the ticket in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the responsible agent of the ticket in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the responsible agent of the ticket in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the responsible agent of the ticket in the ticket responsible screen of the agent interface.' =>
            '',
        'Sets the service in the close ticket screen of the agent interface (Ticket::Service needs to be activated).' =>
            '',
        'Sets the service in the ticket free text screen of the agent interface (Ticket::Service needs to be activated).' =>
            '',
        'Sets the service in the ticket note screen of the agent interface (Ticket::Service needs to be activated).' =>
            '',
        'Sets the service in the ticket owner screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).' =>
            '',
        'Sets the service in the ticket pending screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).' =>
            '',
        'Sets the service in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).' =>
            '',
        'Sets the service in the ticket responsible screen of the agent interface (Ticket::Service needs to be activated).' =>
            '',
        'Sets the size of the statistic graph.' => '',
        'Sets the stats hook.' => '',
        'Sets the system time zone (required a system with UTC as system time). Otherwise this is a diff time to the local time.' =>
            '',
        'Sets the ticket owner in the close ticket screen of the agent interface.' =>
            '',
        'Sets the ticket owner in the ticket bulk screen of the agent interface.' =>
            '',
        'Sets the ticket owner in the ticket free text screen of the agent interface.' =>
            '',
        'Sets the ticket owner in the ticket note screen of the agent interface.' =>
            '',
        'Sets the ticket owner in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the ticket owner in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the ticket owner in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the ticket owner in the ticket responsible screen of the agent interface.' =>
            '',
        'Sets the ticket type in the close ticket screen of the agent interface (Ticket::Type needs to be activated).' =>
            '',
        'Sets the ticket type in the ticket bulk screen of the agent interface.' =>
            '',
        'Sets the ticket type in the ticket free text screen of the agent interface (Ticket::Type needs to be activated).' =>
            '',
        'Sets the ticket type in the ticket note screen of the agent interface (Ticket::Type needs to be activated).' =>
            '',
        'Sets the ticket type in the ticket owner screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).' =>
            '',
        'Sets the ticket type in the ticket pending screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).' =>
            '',
        'Sets the ticket type in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).' =>
            '',
        'Sets the ticket type in the ticket responsible screen of the agent interface (Ticket::Type needs to be activated).' =>
            '',
        'Sets the time (in seconds) a user is marked as active.' => '',
        'Sets the time type which should be shown.' => '',
        'Sets the timeout (in seconds) for http/ftp downloads.' => '',
        'Sets the timeout (in seconds) for package downloads. Overwrites "WebUserAgent::Timeout".' =>
            '',
        'Sets the user time zone per user (required a system with UTC as system time and UTC under TimeZone). Otherwise this is a diff time to the local time.' =>
            '',
        'Sets the user time zone per user based on java script / browser time zone offset feature at login time.' =>
            '',
        'Show a responsible selection in phone and email tickets in the agent interface.' =>
            '',
        'Show article as rich text even if rich text writing is disabled.' =>
            '',
        'Show the current owner in the customer interface.' => '',
        'Show the current queue in the customer interface.' => '',
        'Shows a count of icons in the ticket zoom, if the article has attachments.' =>
            '',
        'Shows a link in the menu for subscribing / unsubscribing from a ticket in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu that allows linking a ticket with another object in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu that allows merging tickets in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to access the history of a ticket in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to add a free text field in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to add a note in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to add a note to a ticket in every ticket overview of the agent interface.' =>
            '',
        'Shows a link in the menu to close a ticket in every ticket overview of the agent interface.' =>
            '',
        'Shows a link in the menu to close a ticket in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to delete a ticket in every ticket overview of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Shows a link in the menu to delete a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Shows a link in the menu to go back in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to lock / unlock a ticket in the ticket overviews of the agent interface.' =>
            '',
        'Shows a link in the menu to lock/unlock tickets in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to move a ticket in every ticket overview of the agent interface.' =>
            '',
        'Shows a link in the menu to print a ticket or an article in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to see the customer who requested the ticket in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to see the history of a ticket in every ticket overview of the agent interface.' =>
            '',
        'Shows a link in the menu to see the owner of a ticket in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to see the priority of a ticket in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to see the responsible agent of a ticket in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to set a ticket as pending in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to set a ticket as spam in every ticket overview of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Shows a link in the menu to set the priority of a ticket in every ticket overview of the agent interface.' =>
            '',
        'Shows a link in the menu to zoom a ticket in the ticket overviews of the agent interface.' =>
            '',
        'Shows a link to access article attachments via a html online viewer in the zoom view of the article in the agent interface.' =>
            '',
        'Shows a link to download article attachments in the zoom view of the article in the agent interface.' =>
            '',
        'Shows a link to see a zoomed email ticket in plain text.' => '',
        'Shows a link to set a ticket as spam in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Shows a list of all the involved agents on this ticket, in the close ticket screen of the agent interface.' =>
            '',
        'Shows a list of all the involved agents on this ticket, in the ticket free text screen of the agent interface.' =>
            '',
        'Shows a list of all the involved agents on this ticket, in the ticket note screen of the agent interface.' =>
            '',
        'Shows a list of all the involved agents on this ticket, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows a list of all the involved agents on this ticket, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows a list of all the involved agents on this ticket, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows a list of all the involved agents on this ticket, in the ticket responsible screen of the agent interface.' =>
            '',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the close ticket screen of the agent interface.' =>
            '',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket free text screen of the agent interface.' =>
            '',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket note screen of the agent interface.' =>
            '',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket responsible screen of the agent interface.' =>
            '',
        'Shows a preview of the ticket overview (CustomerInfo => 1 - shows also Customer-Info, CustomerInfoMaxSize max. size in characters of Customer-Info).' =>
            '',
        'Shows all both ro and rw queues in the queue view.' => '',
        'Shows all open tickets (even if they are locked) in the escalation view of the agent interface.' =>
            '',
        'Shows all open tickets (even if they are locked) in the status view of the agent interface.' =>
            '',
        'Shows all the articles of the ticket (expanded) in the zoom view.' =>
            '',
        'Shows all the customer identifiers in a multi-select field (not useful if you have a lot of customer identifiers).' =>
            '',
        'Shows an owner selection in phone and email tickets in the agent interface.' =>
            '',
        'Shows colors for different article types in the article table.' =>
            '',
        'Shows customer history tickets in AgentTicketPhone, AgentTicketEmail and AgentTicketCustomer.' =>
            '',
        'Shows either the last customer article\'s subject or the ticket title in the small format overview.' =>
            '',
        'Shows existing parent/child queue lists in the system in the form of a tree or a list.' =>
            '',
        'Shows the activated ticket attributes in the customer interface (0 = Disabled and 1 = Enabled).' =>
            '',
        'Shows the articles sorted normally or in reverse, under ticket zoom in the agent interface.' =>
            '',
        'Shows the customer user information (phone and email) in the compose screen.' =>
            '',
        'Shows the customer user\'s info in the ticket zoom view.' => '',
        'Shows the message of the day (MOTD) in the agent dashboard. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually.' =>
            '',
        'Shows the message of the day on login screen of the agent interface.' =>
            '',
        'Shows the ticket history (reverse ordered) in the agent interface.' =>
            '',
        'Shows the ticket priority options in the close ticket screen of the agent interface.' =>
            '',
        'Shows the ticket priority options in the move ticket screen of the agent interface.' =>
            '',
        'Shows the ticket priority options in the ticket bulk screen of the agent interface.' =>
            '',
        'Shows the ticket priority options in the ticket free text screen of the agent interface.' =>
            '',
        'Shows the ticket priority options in the ticket note screen of the agent interface.' =>
            '',
        'Shows the ticket priority options in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows the ticket priority options in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows the ticket priority options in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows the ticket priority options in the ticket responsible screen of the agent interface.' =>
            '',
        'Shows the title fields in the close ticket screen of the agent interface.' =>
            '',
        'Shows the title fields in the ticket free text screen of the agent interface.' =>
            '',
        'Shows the title fields in the ticket note screen of the agent interface.' =>
            '',
        'Shows the title fields in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows the title fields in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows the title fields in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows the title fields in the ticket responsible screen of the agent interface.' =>
            '',
        'Shows time in long format (days, hours, minutes), if set to "Yes"; or in short format (days, hours), if set to "No".' =>
            '',
        'Shows time use complete description (days, hours, minutes), if set to "Yes"; or just first letter (d, h, m), if set to "No".' =>
            '',
        'Skin' => 'Skin',
        'SolutionDiffInMin' => '',
        'SolutionInMin' => '',
        'Sorts the tickets (ascendingly or descendingly) when a single queue is selected in the queue view and after the tickets are sorted by priority. Values: 0 = ascending (oldest on top, default), 1 = descending (youngest on top). Use the QueueID for the key and 0 or 1 for value.' =>
            '',
        'Spam Assassin example setup. Ignores emails that are marked with SpamAssassin.' =>
            '',
        'Spam Assassin example setup. Moves marked mails to spam queue.' =>
            '',
        'Specifies if an agent should receive email notification of his own actions.' =>
            '',
        'Specifies the available note types for this ticket mask. If the option is deselected, ArticleTypeDefault is used and the option is removed from the mask.' =>
            '',
        'Specifies the background color of the chart.' => '',
        'Specifies the background color of the picture.' => '',
        'Specifies the border color of the chart.' => '',
        'Specifies the border color of the legend.' => '',
        'Specifies the bottom margin of the chart.' => '',
        'Specifies the different article types that will be used in the system.' =>
            '',
        'Specifies the different note types that will be used in the system.' =>
            '',
        'Specifies the directory to store the data in, if "FS" was selected for TicketStorageModule.' =>
            '',
        'Specifies the directory where SSL certificates are stored.' => '',
        'Specifies the directory where private SSL certificates are stored.' =>
            '',
        'Specifies the email address that should be used by the application when sending notifications. The email address is used to build the complete display name for the notification master (i.e. "OTRS Notification Master" otrs@your.example.com). You can use the OTRS_CONFIG_FQDN variable as set in your configuation, or choose another email address. Notifications are messages such as en::Customer::QueueUpdate or en::Agent::Move.' =>
            '',
        'Specifies the group where the user needs rw permissions so that he can access the "SwitchToCustomer" feature.' =>
            '',
        'Specifies the left margin of the chart.' => '',
        'Specifies the name that should be used by the application when sending notifications. The sender name is used to build the complete display name for the notification master (i.e. "OTRS Notification Master" otrs@your.example.com). Notifications are messages such as en::Customer::QueueUpdate or en::Agent::Move.' =>
            '',
        'Specifies the path of the file for the logo in the page header (gif|jpg|png, 700 x 100 pixel).' =>
            '',
        'Specifies the path of the file for the performance log.' => '',
        'Specifies the path to the converter that allows the view of Microsoft Excel files, in the web interface.' =>
            '',
        'Specifies the path to the converter that allows the view of Microsoft Word files, in the web interface.' =>
            '',
        'Specifies the path to the converter that allows the view of PDF documents, in the web interface.' =>
            '',
        'Specifies the path to the converter that allows the view of XML files, in the web interface.' =>
            '',
        'Specifies the right margin of the chart.' => '',
        'Specifies the text color of the chart (e. g. caption).' => '',
        'Specifies the text color of the legend.' => '',
        'Specifies the text that should appear in the log file to denote a CGI script entry.' =>
            '',
        'Specifies the top margin of the chart.' => '',
        'Specifies user id of the postmaster data base.' => '',
        'Specify how many sub directory levels to use when creating cache files. This should prevent too many cache files being in one directory.' =>
            '',
        'Standard available permissions for agents within the application. If more permissions are needed, they can be entered here. Permissions must be defined to be effective. Some other good permissions have also been provided built-in: note, close, pending, customer, freetext, move, compose, responsible, forward, and bounce. Make sure that "rw" is always the last registered permission.' =>
            '',
        'Start number for statistics counting. Every new stat increments this number.' =>
            '',
        'Starts a wildcard search of the active object after the link object mask is started.' =>
            '',
        'Statistics' => 'Rapportages',
        'Status view' => 'Statusoverzicht',
        'Stop words for fulltext index. These words will be removed.' => '',
        'Stores cookies after the browser has been closed.' => '',
        'Strips empty lines on the ticket preview in the queue view.' => '',
        'Textarea' => '',
        'The "bin/PostMasterMailAccount.pl" will reconnect to POP3/POP3S/IMAP/IMAPS host after the specified count of messages.' =>
            '',
        'The agent skin\'s InternalName which should be used in the agent interface. Please check the available skins in Frontend::Agent::Skins.' =>
            '',
        'The customer skin\'s InternalName which should be used in the customer interface. Please check the available skins in Frontend::Customer::Skins.' =>
            '',
        'The divider between TicketHook and ticket number. E.g \': \'.' =>
            '',
        'The duration in minutes after emitting an event, in which the new escalation notify and start events are suppressed.' =>
            '',
        'The format of the subject. \'Left\' means \'[TicketHook#:12345] Some Subject\', \'Right\' means \'Some Subject [TicketHook#:12345]\', \'None\' means \'Some Subject\' and no ticket number. In the last case you should enable PostmasterFollowupSearchInRaw or PostmasterFollowUpSearchInReferences to recognize followups based on email headers and/or body.' =>
            '',
        'The headline shown in the customer interface.' => '',
        'The identifier for a ticket, e.g. Ticket#, Call#, MyTicket#. The default is Ticket#.' =>
            '',
        'The logo shown in the header of the agent interface. The URL to the image can be a relative URL to the skin image directory, or a full URL to a remote web server.' =>
            '',
        'The logo shown in the header of the customer interface. The URL to the image can be a relative URL to the skin image directory, or a full URL to a remote web server.' =>
            '',
        'The logo shown on top of the login box of the agent interface. The URL to the image must be relative URL to the skin image directory.' =>
            '',
        'The text at the beginning of the subject in an email reply, e.g. RE, AW, or AS.' =>
            '',
        'The text at the beginning of the subject when an email is forwarded, e.g. FW, Fwd, or WG.' =>
            '',
        'This module and its PreRun() function will be executed, if defined, for every request. This module is useful to check some user options or to display news about new applications.' =>
            '',
        'This option defines the dynamic field in which a Process Management activity entity id is stored.' =>
            '',
        'This option defines the dynamic field in which a Process Management process entity id is stored.' =>
            '',
        'This option defines the process tickets default lock.' => '',
        'This option defines the process tickets default priority.' => '',
        'This option defines the process tickets default queue.' => '',
        'This option defines the process tickets default state.' => '',
        'This setting allows you to override the built-in country list with your own list of countries. This is particularly handy if you just want to use a small select group of countries.' =>
            '',
        'Ticket event module that triggers the escalation stop events.' =>
            '',
        'Ticket overview' => 'Ticketoverzicht',
        'TicketNumber' => '',
        'Tickets' => 'Tickets',
        'Time in seconds that gets added to the actual time if setting a pending-state (default: 86400 = 1 day).' =>
            '',
        'Toggles display of OTRS FeatureAddons list in PackageManager.' =>
            '',
        'Toolbar Item for a shortcut.' => '',
        'Turns on the animations used in the GUI. If you have problems with these animations (e.g. performance issues), you can turn them off here.' =>
            '',
        'Turns on the remote ip address check. It should be set to "No" if the application is used, for example, via a proxy farm or a dialup connection, because the remote ip address is mostly different for the requests.' =>
            '',
        'Types' => 'Typen',
        'Update Ticket "Seen" flag if every article got seen or a new Article got created.' =>
            '',
        'Update and extend your system with software packages.' => 'Voeg functies toe aan uw systeem door het installeren van pakketten.',
        'Updates the ticket escalation index after a ticket attribute got updated.' =>
            '',
        'Updates the ticket index accelerator.' => '',
        'UserFirstname' => '',
        'UserLastname' => '',
        'Uses Cc recipients in reply Cc list on compose an email answer in the ticket compose screen of the agent interface.' =>
            '',
        'Uses richtext for viewing and editing: articles, salutations, signatures, standard responses, auto responses and notifications.' =>
            '',
        'View performance benchmark results.' => 'Bekijk resultaten van de performance log.',
        'View system log messages.' => 'Bekijk het OTRS logboek.',
        'Wear this frontend skin' => 'Kies een kleur voor de schermen',
        'Webservice path separator.' => 'Webservice-pad separator',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. In this text area you can define this text (This text cannot be changed by the agent).' =>
            '',
        'When tickets are merged, the customer can be informed per email by setting the check box "Inform Sender". In this text area, you can define a pre-formatted text which can later be modified by the agents.' =>
            '',
        'Your queue selection of your favorite queues. You also get notified about those queues via email if enabled.' =>
            'Uw selectie van favoriete wachtrijen. U ontvangt automatisch een melding van nieuwe tickets in deze wachtrij, als u hiervoor heeft gekozen.',

        #
        # OBSOLETE ENTRIES FOR REFERENCE, DO NOT TRANSLATE!
        #
        'Changes to the Processes here only affect the behaviour of the system, if you synchronize the Process data. By synchronizing the Processes, the newly made changes will be written to the Configuration.' =>
            'Wijzigingen aangebracht aan de processen hebben alleen invloed op het systeem als u de processen synchroniseert. Door het synchroniseren van de processen worden de aangemaakte wijzigingen weggeschreven naar de configuratie.',
        'Customer Data' => 'Klantgegevens',
        'Did not find a required feature? OTRS Group provides their subscription customers with exclusive Add-Ons:' =>
            'Heeft u een feature niet kunnen vinden? De OTRS Groep levert add-ons voor klanten met een subscription:',
        'For more info see:' => 'Voor meer informatie zie:',
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty.' =>
            'Als er een root-wachtwoord voor deze database nodig is, vul deze hier in. Anders moet dit veld leeg blijven.',
        'Logout successful. Thank you for using OTRS!' => 'U bent afgemeld. Bedankt voor het gebruiken van OTRS.',
        'New email ticket for %s' => 'Nieuw e-mail-ticket voor %s',
        'New phone ticket for %s' => 'Nieuw telefoon-ticket voor %s',
        'Package verification failed!' => 'Pakketverificatie mislukt!',
        'Please supply a' => 'Geef een',
        'Please supply a first name' => 'Voer uw voornaam in',
        'Please supply a last name' => 'Voer uw achternaam in',
        'Repeat Password' => 'Herhaal wachtwoord',
        'Secure mode must be disabled in order to reinstall using the web-installer.' =>
            'Secure Mode moet gedeactiveerd worden om te kunnen herinstalleren met de web-installer.',
        'There are currently no steps available for this process.' => 'Er zijn geen stappen beschikbaar voor dit proces.',
        'There are no further steps in this process' => 'Er zijn geen volgende stappen in dit proces',

    };
    # $$STOP$$
    return;
}

1;
