# --
# Copyright (C) 2002-2003 Fred van Dijk <fvandijk at marklin.nl>
# Copyright (C) 2003 A-NeT Internet Services bv Hans Bakker <h.bakker at a-net.nl>
# Copyright (C) 2004 Martijn Lohmeijer <martijn.lohmeijer 'at' sogeti.nl>
# Copyright (C) 2005-2007 Jurgen Rutgers <jurgen 'at' besite.nl>
# Copyright (C) 2005-2007 Richard Hinkamp <richard 'at' besite.nl>
# Copyright (C) 2010 Ton van Boven <ton 'at' avebo.nl>
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::nl;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # $$START$$
    # possible charsets
    $Self->{Charset} = ['utf-8', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Year;)
    $Self->{DateFormat}          = '%D-%M-%Y %T';
    $Self->{DateFormatLong}      = '%A %D %B %Y %T';
    $Self->{DateFormatShort}     = '%D-%M-%Y';
    $Self->{DateInputFormat}     = '%D-%M-%Y';
    $Self->{DateInputFormatLong} = '%D-%M-%Y - %T';
    $Self->{Completeness}        = 0.65126974605079;

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
        'more than ... ago' => 'langer dan ... geleden',
        'in more than ...' => 'over meer dan ...',
        'within the last ...' => 'in de laatste ...',
        'within the next ...' => 'in de volgende ...',
        'Created within the last' => 'Aangemaakt in de laatste',
        'Created more than ... ago' => 'Aangemaakt langer dan ... geleden',
        'Today' => 'Vandaag',
        'Tomorrow' => 'Morgen',
        'Next week' => 'Volgende week',
        'day' => 'dag',
        'days' => 'dagen',
        'day(s)' => 'dag(en)',
        'd' => 'd',
        'hour' => 'uur',
        'hours' => 'uren',
        'hour(s)' => 'u(u)r(en)',
        'Hours' => 'Uren',
        'h' => 'u',
        'minute' => 'minuut',
        'minutes' => 'minuten',
        'minute(s)' => 'minu(u)t(en)',
        'Minutes' => 'Minuten',
        'm' => 'm',
        'month' => 'maand',
        'months' => 'maanden',
        'month(s)' => 'maand(en)',
        'week' => 'week',
        'week(s)' => 'weken',
        'quarter' => 'kwartaal',
        'quarter(s)' => 'kwarta(a)l(en)',
        'half-year' => 'half-jaar',
        'half-year(s)' => 'halve-jaren',
        'year' => 'jaar',
        'years' => 'jaren',
        'year(s)' => 'jaren',
        'second(s)' => 'seconden',
        'seconds' => 'seconden',
        'second' => 'seconde',
        's' => 's',
        'Time unit' => 'Tijd',
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
        'before/after' => 'voor/na',
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
        'Show Tree Selection' => 'Toon boomweergave',
        'The field content is too long!' => 'De inhoud van het veld is te lang!',
        'Maximum size is %s characters.' => 'De maximumlengte bedraagt %s karakters.',
        'This field is required or' => 'Dit veld is verplicht of ',
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
        'Authentication succeeded, but no customer record is found in the customer backend. Please contact your administrator.' =>
            'Inloggen is geslaagd, maar er is geen klantenrecord gevonden in het klantenbeheer. Gelieve uw beheerder te contacteren.',
        'This e-mail address already exists. Please log in or reset your password.' =>
            'Dit e-mail adres bestaat reeds. Gelieve in te loggen of uw wachtwoord te resetten.',
        'Logout' => 'Uitloggen',
        'Logout successful. Thank you for using %s!' => 'U bent afgemeld. Bedankt voor het gebruiken van %s.',
        'Feature not active!' => 'Deze functie is niet actief.',
        'Agent updated!' => 'Behandelaar aangepast.',
        'Database Selection' => 'Database-keuze',
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
        'Enter the password for the administrative database user.' => 'Voer het wachtwoord voor het database-gebruikersaccount in.',
        'Enter the password for the database user.' => 'Voer het wachtwoord voor het database-gebruikersaccount in.',
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty.' =>
            'Als er een root-wachtwoord voor deze database nodig is, vul deze hier in. Anders moet dit veld leeg blijven.',
        'Database already contains data - it should be empty!' => 'Database bevat al data - deze moet leeg zijn!',
        'Login is needed!' => 'Inloggen is nodig.',
        'It is currently not possible to login due to a scheduled system maintenance.' =>
            'Het is momenteel niet mogelijk om in te loggen omwille van een gepland systeemonderhoud.',
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
        'News about OTRS releases!' => 'Nieuws over OTRS versies!',
        'Go to dashboard!' => 'Ga naar het dashboard!',
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
        'Note: Company is invalid!' => 'Let op: bedrijf is ongeldig!',
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
        'ACL information from database is not in sync with the system configuration, please deploy all ACLs.' =>
            'De ACL-informatie in de database is niet gesynchroniseerd met het systeem. Activeer alle ACLs.',
        'printed at' => 'afgedrukt op',
        'Loading...' => 'Bezig met laden...',
        'Dear Mr. %s,' => 'Geachte heer %s,',
        'Dear Mrs. %s,' => 'Geachte mevrouw %s,',
        'Dear %s,' => 'Geachte %s,',
        'Hello %s,' => 'Beste %s,',
        'This email address is not allowed to register. Please contact support staff.' =>
            'Het is niet toegestaan om u met dit e-mailadres te registreren. Gelieve contact op te nemen met de Support afdeling.',
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
            'Pakket niet geverifieerd door de OTRS Groep! We raden aan dit pakket niet te gebruiken.',
        '<br>If you continue to install this package, the following issues may occur!<br><br>&nbsp;-Security problems<br>&nbsp;-Stability problems<br>&nbsp;-Performance problems<br><br>Please note that issues that are caused by working with this package are not covered by OTRS service contracts!<br><br>' =>
            '<br>Wanneer u doorgaat met installatie kunnen de volgende fouten verschijnen!<br><br>&nbsp;-Beveiligingsproblemen<br>&nbsp;-Stabiliteitsproblemen<br>&nbsp;-Performance problemen<br><br>Noteer a.u.b. dat deze fouten gebeuren door deze package en niet door de OTRS service contracts!<br><br>',
        'Mark' => 'Markeer',
        'Unmark' => 'Verwijder markering',
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
        'OTRS Daemon is not running.' => 'OTRS Daemon is niet actief.',
        'Can\'t contact registration server. Please try again later.' => 'Kan registratieserver niet bereiken. Probeer het later nogmaals.',
        'No content received from registration server. Please try again later.' =>
            'Geen data ontvangen van registratieserver. Probeer het later nogmaals.',
        'Problems processing server result. Please try again later.' => 'Problemen met het verwerken van data van registratieserver. Probeer het later nogmaals.',
        'Username and password do not match. Please try again.' => 'Gebruikersnaam en wachtwoord komen niet overeen.',
        'The selected process is invalid!' => 'Het geselecteerde proces is niet geldig!',
        'Upgrade to %s now!' => 'Upgrade nu naar %s!',
        '%s Go to the upgrade center %s' => '%s Ga naar het upgrade center %s',
        'The license for your %s is about to expire. Please make contact with %s to renew your contract!' =>
            'De licentie voor uw %s verloopt binnenkort. Contacteer %s om deze te hernieuwen!',
        'An update for your %s is available, but there is a conflict with your framework version! Please update your framework first!' =>
            'Er is een update beschikbaar voor uw %s, maar er is een probleem met de versie van uw framework! Gelieve eerst uw framework te updaten!',
        'Your system was successfully upgraded to %s.' => 'Het systeem is succesvol geupgraded naar %s.',
        'There was a problem during the upgrade to %s.' => 'Er is een probleem opgetreden bij het upgraden naar %s.',
        '%s was correctly reinstalled.' => '%s is opnieuw geïnstalleerd zonder problemen.',
        'There was a problem reinstalling %s.' => 'Er is een probleem opgetreden bij het herinstalleren van %s.',
        'Your %s was successfully updated.' => 'Uw %s werd succesvol geupdated.',
        'There was a problem during the upgrade of %s.' => 'Er is een probleem opgetreden tijdens het upgraden van %s.',
        '%s was correctly uninstalled.' => '%s werd zonder problemen verwijderd.',
        'There was a problem uninstalling %s.' => 'Er is een probleem opgetreden bij het verwijderen van %s.',
        'Enable cloud services to unleash all OTRS features!' => 'Schakel cloud diensten in om alle OTRS functionaliteit in te schakelen!',

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
        'Notification Settings' => 'Notificatievoorkeuren',
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

        # Template: AAATicket
        'Status View' => 'Statusoverzicht',
        'Service View' => 'Service View',
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
        'Bounce Article to a different mail address' => 'Artikel terugsturen naar een ander e-mailadres',
        'Reply to note' => 'Notitie beantwoorden',
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
        'auto follow up' => 'automatisch opvolgen',
        'auto reject' => 'automatisch weigeren',
        'auto remove' => 'automatisch verwijderen',
        'auto reply' => 'automatisch antwoorden',
        'auto reply/new ticket' => 'automatisch antwoord/nieuw ticket',
        'Create' => 'Aanmaken',
        'Answer' => 'Antwoord',
        'Phone call' => 'Telefoongesprek',
        'Ticket "%s" created!' => 'Ticket "%s" aangemaakt.',
        'Ticket Number' => 'Ticketnummer',
        'Ticket Object' => 'Ticketonderwerp',
        'No such Ticket Number "%s"! Can\'t link it!' => 'Ticketnummer "%s" niet gevonden! Er kan dus geen koppeling worden gemaakt.',
        'You don\'t have write access to this ticket.' => 'U heeft geen schrijfrechten op dit ticket.',
        'Sorry, you need to be the ticket owner to perform this action.' =>
            'U moet de eigenaar zijn om deze actie uit te voeren.',
        'Please change the owner first.' => 'Verander de eigenaar eerst.',
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
        'Customer Realname' => 'Werkelijke naam van klant',
        'Customer History' => 'Klantgeschiedenis',
        'Edit Customer Users' => 'Wijzig klanten',
        'Edit Customer' => 'Klant bewerken',
        'Bulk Action' => 'Bulk actie',
        'Bulk Actions on Tickets' => 'Bulk actie op tickets',
        'Send Email and create a new Ticket' => 'Verstuur e-mail en maak een nieuw ticket aan',
        'Create new Email Ticket and send this out (Outbound)' => 'Maak een nieuw ticket aan en verstuur per e-mail',
        'Create new Phone Ticket (Inbound)' => 'Maak nieuw ticket aan van telefoongesprek',
        'Address %s replaced with registered customer address.' => 'Adres %s vervangen met vastgelegde klant-adres.',
        'Customer user automatically added in Cc.' => 'Klant automatisch toegevoegd als CC.',
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
        'Split' => 'Splits',
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
        'Shown Columns' => 'Toon kolommen',
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
        'New ticket notification' => 'Melding bij een nieuw ticket',
        'Send me a notification if there is a new ticket in "My Queues".' =>
            'Stuur mij een melding als er een nieuw ticket in \'Mijn wachtrijen\' komt.',
        'Send new ticket notifications' => 'Melding bij nieuwe tickets',
        'Ticket follow up notification' => 'Melding bij nieuwe reacties',
        'Send me a notification if a customer sends a follow up and I\'m the owner of the ticket or the ticket is unlocked and is in one of my subscribed queues.' =>
            'Stuur mij een melding als een reactie op een ticket binnenkomt en ik de eigenaar van het ticket ben, of het ticket ontgrendeld is en in één van \'Mijn wachtrijen\' staat.',
        'Send ticket follow up notifications' => 'Stuur meldingen bij reacties op een ticket',
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
        'Out Of Office Time' => 'Afwezigheid',
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
        'Ticket Information' => 'Ticket-informatie',
        'including subqueues' => 'Inclusief sub-wachtrijen',
        'excluding subqueues' => 'Exclusief sub-wachtrijen',

        # Template: AAAWeekDay
        'Sun' => 'zo',
        'Mon' => 'ma',
        'Tue' => 'di',
        'Wed' => 'wo',
        'Thu' => 'do',
        'Fri' => 'vr',
        'Sat' => 'za',

        # Template: AdminACL
        'ACL Management' => 'ACL beheer',
        'Filter for ACLs' => 'Filter op ACLs',
        'Filter' => 'Filter',
        'ACL Name' => 'ACL-naam',
        'Actions' => 'Acties',
        'Create New ACL' => 'Nieuwe ACL aanmaken',
        'Deploy ACLs' => 'ACLs activeren',
        'Export ACLs' => 'Exporteer ACLs',
        'Configuration import' => 'Importeer configuratie',
        'Here you can upload a configuration file to import ACLs to your system. The file needs to be in .yml format as exported by the ACL editor module.' =>
            'Hier kunt u een configuratiebestand met ACLs importeren in uw systeem. Het bestand moet in .yml formaat zijn, zoals geexporteerd door de ACL module.',
        'This field is required.' => 'Dit veld is verplicht.',
        'Overwrite existing ACLs?' => 'Overschrijf bestaande ACLs?',
        'Upload ACL configuration' => 'ACL-configuratie uploaden?',
        'Import ACL configuration(s)' => 'Importeer ACL-configuratie',
        'To create a new ACL you can either import ACLs which were exported from another system or create a complete new one.' =>
            'Om nieuwe ACLs aan te maken kunt u deze importeren vanuit een bestand of een compleet nieuwe aanmaken.',
        'Changes to the ACLs here only affect the behavior of the system, if you deploy the ACL data afterwards. By deploying the ACL data, the newly made changes will be written to the configuration.' =>
            'Wijzigingen aan de ACLs worden pas actief als u de ACLs activeert. Door ',
        'ACLs' => 'ACLs',
        'Please note: This table represents the execution order of the ACLs. If you need to change the order in which ACLs are executed, please change the names of the affected ACLs.' =>
            'Let op: deze tabel toont de volgorde waarin de ALCs worden toegepast. Als u de volgorde waarin deze worden uitgevoerd moet aanpassen, verander dan de namen van de ACLs.',
        'ACL name' => 'ACL-naam',
        'Validity' => 'Geldigheid',
        'Copy' => 'Kopiëer',
        'No data found.' => 'Geen gegevens gevonden.',

        # Template: AdminACLEdit
        'Edit ACL %s' => 'Bewerk ACL %s',
        'Go to overview' => 'Naar het overzicht',
        'Delete ACL' => 'Verwijder ACL',
        'Delete Invalid ACL' => 'Verwijder ongeldige ACL',
        'Match settings' => 'Activatie-criteria',
        'Set up matching criteria for this ACL. Use \'Properties\' to match the current screen or \'PropertiesDatabase\' to match attributes of the current ticket that are in the database.' =>
            'Stel activatie-criteria in voor deze ACL. Gebruik \'Attributen\' om de huidige waarden te gebruiken of \'DatabaseAttributen\' om de waarden uit de database voor het huidige ticket te gebruiken.',
        'Change settings' => 'Verander instellingen',
        'Set up what you want to change if the criteria match. Keep in mind that \'Possible\' is a white list, \'PossibleNot\' a black list.' =>
            'Geef aan wat u wilt dat gebeurt als de activatie-criteria kloppen.',
        'Check the official' => 'Bekijk de',
        'documentation' => 'documentatie',
        'Show or hide the content' => 'Toon of verberg de inhoud',
        'Edit ACL information' => 'Bewerk ACL-informatie',
        'Stop after match' => 'Stop met filters na match',
        'Edit ACL structure' => 'Bewerk ACL-structuur',
        'Save ACL' => 'ACL Opslaan',
        'Save' => 'Opslaan',
        'or' => 'of',
        'Save and finish' => 'Opslaan en voltooien',
        'Do you really want to delete this ACL?' => 'Wilt u deze ACL verwijderen?',
        'This item still contains sub items. Are you sure you want to remove this item including its sub items?' =>
            'Dit item bevat sub-items. Weet u zeker dat u dit item inclusief subitems wilt verwijderen?',
        'An item with this name is already present.' => 'Er bestaat al een item met deze naam.',
        'Add all' => 'Alles toevoegen',
        'There was an error reading the ACL data.' => 'Er was een probleem bij het lezen van de ACL-data.',

        # Template: AdminACLNew
        'Create a new ACL by submitting the form data. After creating the ACL, you will be able to add configuration items in edit mode.' =>
            'Maak een nieuwe ACL aan. Na het aanmaken kunt u de eigenschappen aanpassen door deze te bewerken.',

        # Template: AdminAttachment
        'Attachment Management' => 'Beheer bijlagen',
        'Add attachment' => 'Nieuwe bijlage',
        'List' => 'Overzicht',
        'Download file' => 'Download bijlage',
        'Delete this attachment' => 'Verwijder bijlage',
        'Do you really want to delete this attachment?' => 'Ben je zeker dat je deze bijlage wil verwijderen?',
        'Add Attachment' => 'Nieuwe bijlage',
        'Edit Attachment' => 'Bijlage bewerken',

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
        'To get the name of the ticket\'s customer user (if given).' => 'Om de naam van de klant te verkrijgen (indien gegeven)',
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

        # Template: AdminCloudServiceSupportDataCollector
        'Cloud Service Management' => 'Cloud Service Beheer',
        'Support Data Collector' => 'Verzamelaar van supportgegevens',
        'Support data collector' => 'Verzamelaar van supportgegevens',
        'Hint' => 'Opmerking',
        'Currently support data is only shown in this system.' => 'Momenteel worden enkel ondersteuningsgegevens getoond in dit systeem.',
        'It is highly recommended to send this data to OTRS Group in order to get better support.' =>
            'Het is aangeraden om deze gegevens naar de OTRS Group te versturen om een betere ondersteuning te bekomen.',
        'Configuration' => 'Configuratie',
        'Send support data' => 'Ondersteuningsgegevens versturen',
        'This will allow the system to send additional support data information to OTRS Group.' =>
            'Hierdoor mag het systeem aanvullende ondersteuningsinformatie doorsturen naar de OTRS Groep.',
        'System Registration' => 'Systeemregistratie',
        'To enable data sending, please register your system with OTRS Group or update your system registration information (make sure to activate the \'send support data\' option.)' =>
            'Gelieve uw systeem te registreren bij de OTRS Groep of de informatie van uw systeem registratie bij te werken om het versturen van gegevens mogelijk te maken (zorg ervoor dat optie \'ondersteuningsgegevens verzenden\' geactiveerd is).',
        'Register this System' => 'Registreer dit Systeem',
        'System Registration is disabled for your system. Please check your configuration.' =>
            'Systeemregistratie is uitgeschakeld voor uw systeem. Gelieve uw configuratie na te kijken.',

        # Template: AdminCloudServices
        'System registration is a service of OTRS Group, which provides a lot of advantages!' =>
            'Systeemregistratie is een service van de OTRS Groep, die een aantal voordelen biedt.',
        'Please note that the use of OTRS cloud services requires the system to be registered.' =>
            'Houd er rekening mee dat wanneer u gebruik wilt maken van de OTRS cloud diensten uw systeem geregistreerd moet zijn.',
        'Register this system' => 'Registreer dit systeem',
        'Here you can configure available cloud services that communicate securely with %s.' =>
            'Hier kan u beschikbare Cloud diensten configureren die beveiligd communiceren met %s.',
        'Available Cloud Services' => 'Beschikbare Cloud Diensten',
        'Upgrade to %s' => 'Upgrade naar %s',

        # Template: AdminCustomerCompany
        'Customer Management' => 'Beheer klanten',
        'Wildcards like \'*\' are allowed.' => 'Wildcards zijn toegestaan.',
        'Add customer' => 'Nieuwe klant',
        'Select' => 'Selecteer',
        'List (only %s shown - more available)' => 'Lijst (slechts %s getoond - meer beschikbaar)',
        'List (%s total)' => 'Lijst (%s in totaal)',
        'Please enter a search term to look for customers.' => 'Typ om te zoeken naar klanten.',
        'Add Customer' => 'Klant toevoegen',

        # Template: AdminCustomerUser
        'Customer User Management' => 'Beheer klanten',
        'Back to search results' => 'Terug naar zoekresultaat',
        'Add customer user' => 'Nieuwe klant',
        'Customer user are needed to have a customer history and to login via customer panel.' =>
            'Klanten zijn nodig om een historie te kunnen inzien en om in te loggen via het klantenscherm.',
        'Last Login' => 'Laatst ingelogd',
        'Login as' => 'Inloggen als',
        'Switch to customer' => 'Omschakelen naar klant',
        'Add Customer User' => 'Nieuwe klant',
        'Edit Customer User' => 'Klant bewerken',
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
        'Edit Customer Default Groups' => 'Bewerk standaard groepen voor klanten',
        'These groups are automatically assigned to all customers.' => 'Deze groepen worden toegewezen aan alle klanten.',
        'You can manage these groups via the configuration setting "CustomerGroupAlwaysGroups".' =>
            'U kunt deze groepen beheren via de optie "CustomerGroupAlwaysGroups".',
        'Filter for Groups' => 'Filter op groepen',
        'Just start typing to filter...' => 'Start met typen om te filteren',
        'Select the customer:group permissions.' => 'Selecteer de permissies voor klant:groep.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer).' =>
            'Als niets geselecteerd is, zijn er geen permissies in deze groep (de klant zal geen tickets kunnen zien).',
        'Search Results' => 'Zoekresultaat',
        'Customers' => 'Klanten',
        'No matches found.' => 'Niets gevonden.',
        'Groups' => 'Groepen',
        'Change Group Relations for Customer' => 'Bewerk gekoppelde groepen voor klant',
        'Change Customer Relations for Group' => 'Bewerk gekoppelde klanten voor groep',
        'Toggle %s Permission for all' => '%s permissies aan/uit',
        'Toggle %s permission for %s' => '%s permissies aan/uit voor %s',
        'Customer Default Groups:' => 'Standaard groepen',
        'No changes can be made to these groups.' => 'Deze groepen kunnen niet gewijzigd worden.',
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
        'To add a new field, select the field type from one of the object\'s list, the object defines the boundary of the field and it can\'t be changed after the field creation.' =>
            'Om een nieuw veld toe te voegen selecteert u het veldtype uit de objectlijst, het object definieert de grens van het veld en deze kan na het aanmaken niet worden gewijzigd.',
        'Dynamic Fields List' => 'Lijst met dynamische velden',
        'Dynamic fields per page' => 'Dynamische velden per pagina',
        'Label' => 'Label',
        'Order' => 'Volgorde',
        'Object' => 'Object',
        'Delete this field' => 'Verwijder dit veld',
        'Do you really want to delete this dynamic field? ALL associated data will be LOST!' =>
            'Wilt u dit veld definitief verwijderen? Alle data in dit veld wordt ook verwijderd!',
        'Delete field' => 'Verwijder veld',
        'Deleting the field and its data. This may take a while...' => 'Dit veld en al zijn data word verwijderd. Dit kan even duren....',

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
        'Link for preview' => '',
        'If filled in, this URL will be used for a preview which is shown when this link is hovered in ticket zoom. Please note that for this to work, the regular URL field above needs to be filled in, too.' =>
            '',
        'Restrict entering of dates' => 'Beperk het invoeren van datumgegevens',
        'Here you can restrict the entering of dates of tickets.' => 'Hier kunt u het invoeren van datumgegevens van tickets beperken.',

        # Template: AdminDynamicFieldDropdown
        'Possible values' => 'Mogelijke waarden',
        'Key' => 'Sleutel',
        'Value' => 'Waarde',
        'Remove value' => 'Waarde verwijderen',
        'Add value' => 'Waarde toevoegen',
        'Add Value' => 'Waarde toevoegen',
        'Add empty value' => 'Lege waarde toevoegen',
        'Activate this option to create an empty selectable value.' => 'Activeer deze optie om een lege selecteerbare waarde toe te voeten.',
        'Tree View' => 'Boomweergave',
        'Activate this option to display values as a tree.' => 'Activeer deze optie om waarden in een boomstructuur weer te geven.',
        'Translatable values' => 'Waarden zijn vertaalbaar',
        'If you activate this option the values will be translated to the user defined language.' =>
            'Als u deze optie activeerd zullen de waarden vertaald worden in de taal van de eindgebruiker.',
        'Note' => 'Notitie',
        'You need to add the translations manually into the language translation files.' =>
            'U moet de vertalingen zelf toevoegen aan de vertalingsbestanden.',

        # Template: AdminDynamicFieldText
        'Number of rows' => 'Aantal regels',
        'Specify the height (in lines) for this field in the edit mode.' =>
            'Geef de hoogte van het invoervak voor dit veld (in regels)',
        'Number of cols' => 'Aantal kolommen',
        'Specify the width (in characters) for this field in the edit mode.' =>
            'Geef de breedte van het invoervak voor dit veld (in kolommen)',
        'Check RegEx' => 'Controleer RegEx',
        'Here you can specify a regular expression to check the value. The regex will be executed with the modifiers xms.' =>
            'Hier kunt u een reguliere expressie opgeven om de waarde te controleren. De regex zal met de xms modifier worden uitgevoerd.',
        'RegEx' => 'RegEx',
        'Invalid RegEx' => 'Ongeldig RegEx',
        'Error Message' => 'Foutmelding',
        'Add RegEx' => 'Regex toevoegen',

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
        'Do you really want to delete this task?' => '',
        'Job Settings' => 'Taak instellingen',
        'Job name' => 'Naam',
        'The name you entered already exists.' => 'De naam die u hebt opgegeven bestaat al.',
        'Toggle this widget' => 'Klap in/uit',
        'Automatic execution (multiple tickets)' => 'Automatisch uitvoeren (meerdere tickets)',
        'Execution Schedule' => 'Tijdschema',
        'Schedule minutes' => 'minuten',
        'Schedule hours' => 'uren',
        'Schedule days' => 'dagen',
        'Currently this generic agent job will not run automatically.' =>
            'Deze taak zal niet automatisch draaien.',
        'To enable automatic execution select at least one value from minutes, hours and days!' =>
            'Om automatisch uit te voeren selecteer ten minste één waarde bij minuten, uren en dagen.',
        'Event based execution (single ticket)' => 'Event-gebaseerd uitvoeren (één ticket)',
        'Event Triggers' => 'Event triggers',
        'List of all configured events' => 'Lijst van beschikbare events',
        'Delete this event' => 'Verwijder dit event',
        'Additionally or alternatively to a periodic execution, you can define ticket events that will trigger this job.' =>
            'Naast of in plaats van uitvoeren op een tijdschema kunt u ook ticket events selecteren die deze taak triggeren.',
        'If a ticket event is fired, the ticket filter will be applied to check if the ticket matches. Only then the job is run on that ticket.' =>
            'Als een ticket-event plaatsvindt zal dit filter worden toegepast om te toetsen of dit ticket voldoet. Alleen dan wordt deze taak uitgevoerd.',
        'Do you really want to delete this event trigger?' => 'Wilt u deze event trigger verwijderen?',
        'Add Event Trigger' => 'Nieuwe event trigger toevoegen',
        'Add Event' => 'Gebeurtenis toevoegen',
        'To add a new event select the event object and event name and click on the "+" button' =>
            'Om een nieuw event toe te voegen, selecteer het event object en de naam van het event en klik op de "+".',
        'Duplicate event.' => 'Dupliceer event.',
        'This event is already attached to the job, Please use a different one.' =>
            'Dit event is al gekoppeld aan deze taak. Kies een andere.',
        'Delete this Event Trigger' => 'Verwijder deze event trigger.',
        'Remove selection' => 'Selectie verwijderen',
        'Select Tickets' => 'Selecteer Tickets',
        '(e. g. 10*5155 or 105658*)' => '(bijvoorbeeld 10*5155 or 105658*)',
        '(e. g. 234321)' => '(bijvoorbeeld 234321)',
        'Customer user' => 'Klant',
        '(e. g. U5150)' => '(bijvoorbeeld U5150)',
        'Fulltext-search in article (e. g. "Mar*in" or "Baue*").' => 'Zoek in tekst van een interactie. Gebruik wildcards (bijvoorbeeld "Mar*in" of "Jans*").',
        'Agent' => 'Behandelaar',
        'Ticket lock' => 'Vergrendeling',
        'Create times' => 'Tijdstip van aanmaken',
        'No create time settings.' => 'Alle',
        'Ticket created' => 'Ticket aangemaakt',
        'Ticket created between' => 'Ticket aangemaakt tussen',
        'Last changed times' => 'Tijdstip van laatste wijziging',
        'No last changed time settings.' => 'Geen instellingen voor tijdstip laatste wijziging.',
        'Ticket last changed' => 'Laatste wijziging ticket',
        'Ticket last changed between' => 'Laatste wijziging ticket tussen',
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
        'Update/Add Ticket Attributes' => 'Update/toevoegen ticketattributen',
        'Set new service' => 'Nieuwe service',
        'Set new Service Level Agreement' => 'Nieuwe Service Level Agreement',
        'Set new priority' => 'Nieuwe prioriteit',
        'Set new queue' => 'Nieuwe wachtrij',
        'Set new state' => 'Nieuwe status',
        'Pending date' => 'In de wacht: datum',
        'Set new agent' => 'Nieuwe behandelaar',
        'new owner' => 'nieuwe eigenaar',
        'new responsible' => 'nieuwe verantwoordelijke',
        'Set new ticket lock' => 'Nieuwe vergrendeling',
        'New customer user' => 'Nieuwe klant gebruiker',
        'New customer ID' => 'Nieuwe klantcode',
        'New title' => 'Nieuwe titel',
        'New type' => 'Nieuw type',
        'New Dynamic Field Values' => 'Nieuwe dynamische velden',
        'Archive selected tickets' => 'Archiveer geselecteerde tickets',
        'Add Note' => 'Notitie toevoegen',
        'This field must have less then 200 characters.' => '',
        'Time units' => 'Bestede tijd',
        'Execute Ticket Commands' => 'Ticketcommando\'s uitvoeren',
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
        'Warning: There are %s tickets affected but only %s may be modified during one job execution!' =>
            'Waarschuwing: Er worden %s tickets geraakt, maar slechts %s tickets kunnen worden aangepast gedurende één taak executie.',
        'Edit job' => 'Bewerk taak',
        'Run job' => 'Voer taak uit',
        'Affected Tickets' => 'Gevonden tickets',

        # Template: AdminGenericInterfaceDebugger
        'GenericInterface Debugger for Web Service %s' => 'GenericInterface Debugger voor webservice %s',
        'You are here' => 'Hier bent u',
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
        'Limit' => 'Beperk tot',
        'Refresh' => 'Vernieuwen',
        'Request Details' => 'Details verzoek',
        'An error occurred during communication.' => 'Er is een fout opgetreden tijdens de communicatie.',
        'Show or hide the content.' => 'Toon of verberg de inhoud.',
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
        'Asynchronous' => 'Asynchroon',
        'This invoker will be triggered by the configured events.' => 'De invoker wordt aangeroepen door de geconfigureerde events.',
        'Asynchronous event triggers are handled by the OTRS Scheduler Daemon in background (recommended).' =>
            'Asynchrone event-triggers worden in de achtergrond afgehandeld door de OTRS Scheduler Daemon (aangeraden).',
        'Synchronous event triggers would be processed directly during the web request.' =>
            'Synchrone event triggers worden afgehandeld direct tijdens het event (blocking).',
        'Save and continue' => 'Opslaan en doorgaan',
        'Delete this Invoker' => 'Verwijder deze invoker',
        'It is not possible to add a new event trigger because the event is not set.' =>
            '',

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

        # Template: AdminGenericInterfaceMappingXSLT
        'GenericInterface Mapping XSLT for Web Service %s' => 'GenericInterface Mapping XSLT voor Web Service %s',
        'Mapping XML' => 'Mapping XML',
        'Template' => 'Sjabloon',
        'The entered data is not a valid XSLT stylesheet.' => 'De ingevoerde data is geen geldig XSLT stylesheet.',
        'Insert XSLT stylesheet.' => 'XLST stylesheet toevoegen.',

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

        # Template: AdminGenericInterfaceTransportHTTPREST
        'GenericInterface Transport HTTP::REST for Web Service %s' => 'Generieke Interface Transport HTTP::REST voor Web Service %s',
        'Network transport' => 'Netwerk-transport',
        'Properties' => 'Eigenschappen',
        'Route mapping for Operation' => 'Route maken voor actie',
        'Define the route that should get mapped to this operation. Variables marked by a \':\' will get mapped to the entered name and passed along with the others to the mapping. (e.g. /Ticket/:TicketID).' =>
            'Bepaal de route die gemapt moet worden op deze operatie. Variabelen gemarkeerd met een \':\' woden gemapt op de ingevoerde naam en doorgegeven met de maping (bijvoorbeeld /Ticket/:TicketID).',
        'Valid request methods for Operation' => 'Geldige verzoek methoden voor Operatie',
        'Limit this Operation to specific request methods. If no method is selected all requests will be accepted.' =>
            'Beperk deze operatie tot verschillende verzoek methoden. Als er geen methode is geselecteerd wordt alles geaccepteerd.',
        'Maximum message length' => 'Maximale bericht-lengte',
        'This field should be an integer number.' => 'Dit veld moet een getal bevatten.',
        'Here you can specify the maximum size (in bytes) of REST messages that OTRS will process.' =>
            'Hier kun je het maximum aantal bytes bepalen van REST berichten die OTRS verwerkt.',
        'Send Keep-Alive' => 'Verstuur Keep-Alive',
        'This configuration defines if incoming connections should get closed or kept alive.' =>
            'Deze configuratie bepaalt of binnenkomende verbindingen worden afgesloten of in leven worden gehouden.',
        'Host' => 'Server',
        'Remote host URL for the REST requests.' => 'Remote host URL voor de REST verzoeken',
        'e.g https://www.otrs.com:10745/api/v1.0 (without trailing backslash)' =>
            'e.g https://www.otrs.com:10745/api/v1.0 (zonder trailing backslash)',
        'Controller mapping for Invoker' => 'Controller mapping voor Invoker',
        'The controller that the invoker should send requests to. Variables marked by a \':\' will get replaced by the data value and passed along with the request. (e.g. /Ticket/:TicketID?UserLogin=:UserLogin&Password=:Password).' =>
            'De controller waar de invoker zijn verzoeken naar moet versturen. Variabelen die beginnen met een \':\' worden vervangen door de data waarde en doorgegeven met het verzoek. (bijvoorbeeld Ticket/:TicketID?UserLogin=:UserLogin&Password=:Password).',
        'Valid request command for Invoker' => 'Geldig verzoek commando voor Invoker',
        'A specific HTTP command to use for the requests with this Invoker (optional).' =>
            'Een specifiek HTTP commando om te gebruiken voor de verzoeken met deze Invoker (optioneel).',
        'Default command' => 'Standaard opdracht',
        'The default HTTP command to use for the requests.' => 'De standaard HTTP opdracht die gebruikt wordt bij verzoeken.',
        'Authentication' => 'Authenticatie',
        'The authentication mechanism to access the remote system.' => 'Het authenticatie-mechanisme voor het andere systeem.',
        'A "-" value means no authentication.' => 'De waarde "-" betekent geen authenticatie.',
        'The user name to be used to access the remote system.' => 'De gebruikersnaam om toegang te krijgen tot het andere systeem.',
        'The password for the privileged user.' => 'Wachtwoord',
        'Use SSL Options' => 'Configureer SSL opties',
        'Show or hide SSL options to connect to the remote system.' => 'Toon of verberg SSL opties om te verbinden naar het andere systeem',
        'Certificate File' => 'Certificaat-bestand',
        'The full path and name of the SSL certificate file.' => 'Het volledige pad en naam van het SSL certificaat bestand.',
        'e.g. /opt/otrs/var/certificates/REST/ssl.crt' => 'e.g. /opt/otrs/var/certificates/REST/ssl.crt',
        'Certificate Password File' => 'Bestand dat wachtwoord van het certificaaat bevat',
        'The full path and name of the SSL key file.' => 'Het volledige pad en naam van het SSL sleutel bestand.',
        'e.g. /opt/otrs/var/certificates/REST/ssl.key' => 'e.g. /opt/otrs/var/certificates/REST/ssl.key',
        'Certification Authority (CA) File' => 'Certification Authority (CA) bestand',
        'The full path and name of the certification authority certificate file that validates the SSL certificate.' =>
            'Het volledige pad en naam van de certificatie instantie die het SSL certificaat valideert.',
        'e.g. /opt/otrs/var/certificates/REST/CA/ca.file' => 'e.g. /opt/otrs/var/certificates/REST/CA/ca.file',

        # Template: AdminGenericInterfaceTransportHTTPSOAP
        'GenericInterface Transport HTTP::SOAP for Web Service %s' => 'GenericInterface Transport HTTP::SOAP voor web service %s',
        'Endpoint' => 'Eindpunt',
        'URI to indicate a specific location for accessing a service.' =>
            'URI om de specifieke lokatie van een service te definieren.',
        'e.g. http://local.otrs.com:8000/Webservice/Example' => 'e.g. http://local.otrs.com:8000/Webservice/Example',
        'Namespace' => 'Namespace',
        'URI to give SOAP methods a context, reducing ambiguities.' => 'URI om SOAP methods een context te geven.',
        'e.g urn:otrs-com:soap:functions or http://www.otrs.com/GenericInterface/actions' =>
            'bijv. urn:otrs-com:soap:functions of http://www.otrs.com/GenericInterface/actions',
        'Request name scheme' => 'Verzoek naamschema',
        'Select how SOAP request function wrapper should be constructed.' =>
            'Selecteer hoe de SOAP verzoeken wrapper gemaakt zou moeten worden.',
        '\'FunctionName\' is used as example for actual invoker/operation name.' =>
            '\'FunctionName\' is gebruikt als voorbeeld voor invoker/operation name.',
        '\'FreeText\' is used as example for actual configured value.' =>
            '\'FreeText\' wordt gebruikt als voorbeeld voor eigenlijk geconfigureerde waarde.',
        'Request name free text' => '',
        'Text to be used to as function wrapper name suffix or replacement.' =>
            'Tekst die gebruikt moet worden als wrapper naam achtervoegsel of vervanging.',
        'Please consider XML element naming restrictions (e.g. don\'t use \'<\' and \'&\').' =>
            'Gebruik geen XML element namen (gebruik geen \'<\' en geen \'&\').',
        'Response name scheme' => 'Antwoord naamschema',
        'Select how SOAP response function wrapper should be constructed.' =>
            'Selecteer hoe SOAP antwoorden functie gemaakt zou moeten worden.',
        'Response name free text' => 'Antwoord naam vrije tekst',
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
        'Proxy Server' => 'Proxy-server',
        'URI of a proxy server to be used (if needed).' => 'URI van de proxy-server (indien nodig).',
        'e.g. http://proxy_hostname:8080' => 'e.g. http://proxy_hostname:8080',
        'Proxy User' => 'Proxy-gebruikersnaam',
        'The user name to be used to access the proxy server.' => 'De gebruikersnaam voor toegang tot de proxy-server.',
        'Proxy Password' => 'Proxy-wachtwoord',
        'The password for the proxy user.' => 'Het wachtwoord voor de proxy-gebruiker.',
        'The full path and name of the SSL certificate file (must be in .p12 format).' =>
            'Het volledige pad en de naam van het SSL-certificaat (in .p12 formaat).',
        'e.g. /opt/otrs/var/certificates/SOAP/certificate.p12' => 'bijv. /opt/otrs/var/certificates/SOAP/certificate.p12',
        'The password to open the SSL certificate.' => 'Het wachtwoord voor het SSL-certificaat',
        'The full path and name of the certification authority certificate file that validates SSL certificate.' =>
            'Het volledige pad en de naam van het CA certificaat dat het SSL certificaat valideert.',
        'e.g. /opt/otrs/var/certificates/SOAP/CA/ca.pem' => 'Bijvoorbeeld /opt/otrs/var/certificates/SOAP/CA/ca.pem',
        'Certification Authority (CA) Directory' => 'Certification Authority (CA) directory',
        'The full path of the certification authority directory where the CA certificates are stored in the file system.' =>
            'Het volledige pad van de directory waar de CA-certificaten worden opgeslagen.',
        'e.g. /opt/otrs/var/certificates/SOAP/CA' => 'bijvoorbeeld /opt/otrs/var/certificates/SOAP/CA',
        'Sort options' => 'Sorteer voorkeuren',
        'Add new first level element' => 'Voeg nieuw eerste level element toe',
        'Element' => 'Element',
        'Outbound sort order for xml fields (structure starting below function name wrapper) - see documentation for SOAP transport.' =>
            'Uitgaande sorteer volgorde voor xml velden (structuur begint onder functie naam warpper) - zie SOAP transport documentatie.',

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
        'Ready-to-run Web Services' => '',
        'Here you can activate ready-to-run web services showcasing our best practices that are a part of %s.' =>
            '',
        'Please note that these web services may depend on other modules only available with certain %s contract levels (there will be a notification with further details when importing).' =>
            '',
        'Import ready-to-run web service' => '',
        'Would you like to benefit from web services created by experts? Upgrade to %s to import some sophisticated ready-to-run web services.' =>
            '',
        'After you save the configuration you will be redirected again to the edit screen.' =>
            'Na opslaan blijft u in dit scherm.',
        'If you want to return to overview please click the "Go to overview" button.' =>
            'Als u terug wilt na het overzicht klik dan op de "Naar het overzicht" knop.',
        'Web Service List' => 'Webservice-overzicht',
        'Remote system' => 'Ander systeem',
        'Provider transport' => 'Provider-transport',
        'Requester transport' => 'Requester-transport',
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
            'Minimaal één %s heeft een controller die niet aanwezig is of actief is, controleer de controller registratie of verwijder %s',
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
        'Restore' => 'Herstellen',

        # Template: AdminGroup
        'WARNING: When you change the name of the group \'admin\', before making the appropriate changes in the SysConfig, you will be locked out of the administrations panel! If this happens, please rename the group back to admin per SQL statement.' =>
            'WAARSCHUWING: Als u de naam van de groep \'admin\'aanpast voordat u de bijbehorende wijzigingen in de Systeemconfiguratie heeft aangebracht, zult u geen beheer-permissies meer hebben in OTRS. Als dit gebeurt, moet u de naam van de groep aanpassen met een SQL statement.',
        'Group Management' => 'Groepenbeheer',
        'Add Group' => 'Groep toevoegen',
        'The admin group is to get in the admin area and the stats group to get stats area.' =>
            'Leden van de groep Admin mogen in het administratie gedeelte, leden van de groep Stats hebben toegang tot het statistieken gedeelte.',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...). ' =>
            'Maak nieuwe groepen aan om tickets te kunnen scheiden en de juiste wachtrijen aan behandelaars te tonen (bijv. support, sales, management).',
        'It\'s useful for ASP solutions. ' => 'Bruikbaar voor ASP situaties.',
        'total' => 'totaal',
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
        'Online Admin Manual' => 'Online Admin Handleiding',

        # Template: AdminNotificationEvent
        'Ticket Notification Management' => 'Ticket Melding Management',
        'Add notification' => 'Melding toevoegen',
        'Export Notifications' => 'Meldingen exporteren',
        'Configuration Import' => 'Configuratie importeren',
        'Here you can upload a configuration file to import Ticket Notifications to your system. The file needs to be in .yml format as exported by the Ticket Notification module.' =>
            'Hier kun je configuratie bestanden uploaden om Ticket Notifications te importeren. Het bestand moet in .yml format zijn zoals geëxporteerd door de Ticket Notificatie module.',
        'Overwrite existing notifications?' => 'Bestaande meldingen overschrijven?',
        'Upload Notification configuration' => 'Upload meldingconfiguratie',
        'Import Notification configuration' => 'Melding configuratie importeren',
        'Delete this notification' => 'Melding verwijderen',
        'Do you really want to delete this notification?' => 'Wenst u deze melding te verwijderen?',
        'Add Notification' => 'Melding toevoegen',
        'Edit Notification' => 'Bewerk melding',
        'Show in agent preferences' => 'Tonen bij voorkeuren Agent',
        'Agent preferences tooltip' => 'Agent voorkeuren tooltip',
        'This message will be shown on the agent preferences screen as a tooltip for this notification.' =>
            'Dit bericht wordt getoond op de agent voorkeuren pagina als een tooltip voor deze notificatie.',
        'Here you can choose which events will trigger this notification. An additional ticket filter can be applied below to only send for ticket with certain criteria.' =>
            'Hier kun je kiezen welke events deze notificatie inschakelen. Een extra ticket filter kan worden toegepast om de notificatie alleen te versturen als het ticket voldoet aan bepaalde criteria.',
        'Ticket Filter' => 'Ticket filter',
        'Article Filter' => 'Filter interacties',
        'Only for ArticleCreate and ArticleSend event' => 'Alleen voor ArticleCreate en ArticleSend event',
        'Article type' => 'Soort interactie',
        'If ArticleCreate or ArticleSend is used as a trigger event, you need to specify an article filter as well. Please select at least one of the article filter fields.' =>
            'Als ArticleCreate of ArticleSend wordt gebruikt als trigger event, moet je een article filter spcificeren. Selecteer minimaal één van de artikel filter velden.',
        'Article sender type' => 'Soort verzender',
        'Subject match' => 'Onderwerp',
        'Body match' => 'Bericht tekst',
        'Include attachments to notification' => 'Voeg bijlagen toe aan melding',
        'Recipients' => 'Ontvangers',
        'Send to' => 'Versturen naar',
        'Send to these agents' => 'Verstuur naar deze gebruikers',
        'Send to all group members (agents only)' => '',
        'Send to all role members' => 'Verstuur naar alle leden van een rol',
        'Send on out of office' => 'Verstuur ook wanneer afwezigheidsassistent aan staat',
        'Also send if the user is currently out of office.' => 'Verstuur ook wanneer afwezigheidsassistent aan staat',
        'Once per day' => 'Eén keer per dag',
        'Notify user just once per day about a single ticket using a selected transport.' =>
            'Verstuur slechts éénmaal per dag over één ticket via de geselecteerde methode',
        'Notification Methods' => 'Notificatie methoden',
        'These are the possible methods that can be used to send this notification to each of the recipients. Please select at least one method below.' =>
            'Dit zijn de mogelijke manieren die kunnen worden gebruikt om notificaties te versturen naar elke ontvanger. Selecteer minimaal één methode.',
        'Enable this notification method' => 'Zet deze notificatie methode aan',
        'Transport' => 'Transport',
        'At least one method is needed per notification.' => 'Op zijn minst één methode is vereist per notificatie',
        'Active by default in agent preferences' => 'Standaard actief in agent voorkeuren',
        'This is the default value for assigned recipient agents who didn\'t make a choice for this notification in their preferences yet. If the box is enabled, the notification will be sent to such agents.' =>
            'Dit is de standaard waarde voor toegewezen ontvangers die geen keuze hebben gemaakt voor deze notificatie in hun voorkeuren. Als deze waarde is aangevinkt, wordt het bericht naar deze agents gestuurd.',
        'This feature is currently not available.' => 'Deze feature is niet beschikbaar op het moment.',
        'No data found' => 'Geen data gevonden',
        'No notification method found.' => 'Geen notificatie methoden gevonden',
        'Notification Text' => 'Notificatie Tekst',
        'This language is not present or enabled on the system. This notification text could be deleted if it is not needed anymore.' =>
            'Deze taal is niet aanwezig of ingeschakeld in het systeem. Deze notificatie tekst kan verwijderd worden wanneer deze niet meer nodig is.',
        'Remove Notification Language' => 'Verwijder Notificatie Taal',
        'Message body' => 'Berichttekst',
        'This field is required and must have less than 4000 characters.' =>
            '',
        'Add new notification language' => 'Voeg nieuwe notificatie taal toe',
        'Do you really want to delete this notification language?' => 'Weet uzeker dat udeze notificatietaal wilt verwijderen?',
        'Tag Reference' => 'Tag verwijzing',
        'Notifications are sent to an agent or a customer.' => 'Meldingen worden verstuurd naar een behandelaar.',
        'To get the first 20 character of the subject (of the latest agent article).' =>
            'Om de eerste 20 karakters van het onderwerp van de nieuwste behandelaars-interactie te tonen.',
        'To get the first 5 lines of the body (of the latest agent article).' =>
            'Om de eerste vijf regels van de tekst van de nieuwste behandelaars-interactie te tonen.',
        'To get the first 20 character of the subject (of the latest customer article).' =>
            'Om de eerste 20 karakters van het onderwerp van de nieuwste klant-interactie te tonen.',
        'To get the first 5 lines of the body (of the latest customer article).' =>
            'Om de eerste vijf regels van de tekst van de nieuwste klant-interactie te tonen.',
        'Attributes of the current customer user data' => 'Attributen van de huidige klantengegevens',
        'Attributes of the current ticket owner user data' => 'Eigenschappen van de huidige ticket eigenaar',
        'Attributes of the current ticket responsible user data' => 'Eigenschappen van de huidige ticket responsible',
        'Attributes of the current agent user who requested this action' =>
            'Eigenschappen van de agent die deze actie uitvoert',
        'Attributes of the recipient user for the notification' => 'Eigenschappen van de ontvanger van de notificatie',
        'Attributes of the ticket data' => 'Eigenschappen van de ticket gegevens',
        'Ticket dynamic fields internal key values' => 'Ticket dynamisch veld voor interne sleutelwaarden',
        'Ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            'Ticket dynamisch veld weergave waarden, handig voor dropdown en multiselect velden',
        'Example notification' => 'Voorbeeld notificatie',

        # Template: AdminNotificationEventTransportEmailSettings
        'Additional recipient email addresses' => 'Aanvullende ontvanger e-mailadres',
        'You can use OTRS-tags like <OTRS_TICKET_DynamicField_...> to insert values from the current ticket.' =>
            '',
        'Notification article type' => 'Interactiesoort voor melding',
        'An article will be created if the notification is sent to the customer or an additional email address.' =>
            'Wanneer de notificatie wordt verstuurd naar de klant of een extra email adres, wordt een artikel aangemaakt.',
        'Email template' => 'Email sjabloon',
        'Use this template to generate the complete email (only for HTML emails).' =>
            'Gebruik deze template om de complete mail te genereren (alleen voor HTML email).',
        'Enable email security' => '',
        'Email security level' => '',
        'If signing key/certificate is missing' => '',
        'If encryption key/certificate is missing' => '',

        # Template: AdminOTRSBusinessInstalled
        'Manage %s' => 'Beheer %s',
        'Go to the OTRS customer portal' => 'Ga naar het OTRS klantenportaal',
        'Downgrade to ((OTRS)) Community Edition' => '',
        'Read documentation' => 'Lees documentatie',
        '%s makes contact regularly with cloud.otrs.com to check on available updates and the validity of the underlying contract.' =>
            '%s maakt regelmatig contact met cloud.otrs.com om te controleren of er updates beschikbaar zijn en of het contract nog geldig is.',
        'Unauthorized Usage Detected' => 'Ongeauthoriseerd gebruik ontdekt',
        'This system uses the %s without a proper license! Please make contact with %s to renew or activate your contract!' =>
            'Dit systeem gebruikt %s zonder geldige licentie! Neem contact op met %s om je contract te vernieuwen.',
        '%s not Correctly Installed' => '%s is niet correct geïnstalleerd',
        'Your %s is not correctly installed. Please reinstall it with the button below.' =>
            'Jouw %s is op dit moment niet correct geïnstalleerd. Installeer het opnieuw met de knop hieronder.',
        'Reinstall %s' => 'Herinstalleer %s',
        'Your %s is not correctly installed, and there is also an update available.' =>
            'Jouw %s is niet correct geïnstalleerd, en er is ook een update beschikbaar.',
        'You can either reinstall your current version or perform an update with the buttons below (update recommended).' =>
            'Je kunt de huidige versie opnieuw installeeren of een update uitvoeren met de knoppen hieronder (updaten is aanbevolen).',
        'Update %s' => 'Update %s',
        '%s Not Yet Available' => '%s is nog niet beschikbaar',
        '%s will be available soon.' => '%s wordt binnenkort beschikbaar gemaakt.',
        '%s Update Available' => '%s udate beschikbaar',
        'Package installation requires patch level update of OTRS.' => '',
        'Please visit our customer portal and file a request.' => '',
        'Everything else will be done as part of your contract.' => '',
        'Your installed OTRS version is %s.' => 'Jouw geÏnstalleerde OTRS-versie is %s.',
        'To install the current version of OTRS Business Solution™, you need to update to OTRS %s or higher.' =>
            '',
        'To install the current version of OTRS Business Solution™, the Maximum OTRS Version is %s.' =>
            '',
        'To install this package, the required Framework version is %s.' =>
            '',
        'Why should I keep OTRS up to date?' => '',
        'You will receive updates about relevant security issues.' => '',
        'You will receive updates for all other relevant OTRS issues' => '',
        'An update for your %s is available! Please update at your earliest!' =>
            'Er is een update voor %s beschikbaar! Update zo snel mogelijk!',
        '%s Correctly Deployed' => '%s is succesvol geïnstalleerd',
        'Congratulations, your %s is correctly installed and up to date!' =>
            'Gefeliciteerd, jouw %s is correct geïnstalleerd en bijgewerkt.',

        # Template: AdminOTRSBusinessNotInstalled
        '%s will be available soon. Please check again in a few days.' =>
            '%s komt binnenkort beschikbaar. Kijk over een paar dagen weer.',
        'Please have a look at %s for more information.' => 'Kijk naar %s voor meer informatie.',
        'Your ((OTRS)) Community Edition is the base for all future actions. Please register first before you continue with the upgrade process of %s!' =>
            '',
        'Before you can benefit from %s, please contact %s to get your %s contract.' =>
            'Voordat je de voordelen van %s kunt gebruiken, neem contact op met %s om je %s contract te ontvangen.',
        'Connection to cloud.otrs.com via HTTPS couldn\'t be established. Please make sure that your OTRS can connect to cloud.otrs.com via port 443.' =>
            'Er kon geen verbinding worden gemaakt met cloud.otrs.com via HTTPS. Controleer of jouw OTRS met cloud.otrs.com kan verbinden via poort 443.',
        'To install this package, you need to update to OTRS %s or higher.' =>
            '',
        'To install this package, the Maximum OTRS Version is %s.' => '',
        'With your existing contract you can only use a small part of the %s.' =>
            'Met jouw huidige contract kun je slechts een klein deel van %s gebruiken.',
        'If you would like to take full advantage of the %s get your contract upgraded now! Contact %s.' =>
            'Als je alle voordelen van %s wil gebruiken, moet je je contract upgraden! Neem contact op met %s.',

        # Template: AdminOTRSBusinessUninstall
        'Cancel downgrade and go back' => 'Annuleer downgrade en ga terug',
        'Go to OTRS Package Manager' => 'Ga naar OTRS Pakketbeheer',
        'Sorry, but currently you can\'t downgrade due to the following packages which depend on %s:' =>
            'Sorry, maar we kunnen nu niet downgraden doordat de volgende pakketten afhankelijk zijn van %s:',
        'Vendor' => 'Leverancier',
        'Please uninstall the packages first using the package manager and try again.' =>
            'Verwijder de pakketten via pakketbeheer en probeer het opnieuw.',
        'You are about to downgrade to ((OTRS)) Community Edition and will lose the following features and all data related to these:' =>
            '',
        'Chat' => 'Chat',
        'Report Generator' => 'Rapportage generator',
        'Timeline view in ticket zoom' => 'Tijdslijn weergave in de ticket weergave',
        'DynamicField ContactWithData' => 'Dynamischeveld ContactMetGegevens',
        'DynamicField Database' => 'Dynamisch veld Database',
        'SLA Selection Dialog' => 'SLA selecteer dialoog',
        'Ticket Attachment View' => 'Ticket bijlage weergave',
        'The %s skin' => 'De %s template',

        # Template: AdminPGP
        'PGP Management' => 'PGP beheer',
        'PGP support is disabled' => '',
        'To be able to use PGP in OTRS, you have to enable it first.' => '',
        'Enable PGP support' => '',
        'Faulty PGP configuration' => '',
        'PGP support is enabled, but the relevant configuration contains errors. Please check the configuration using the button below.' =>
            '',
        'Configure it here!' => '',
        'Check PGP configuration' => '',
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
        'Go to updating instructions' => '',
        'package information' => '',
        'Package installation requires a patch level update of OTRS.' => '',
        'Package update requires a patch level update of OTRS.' => '',
        'If you are a OTRS Business Solution™ customer, please visit our customer portal and file a request.' =>
            '',
        'Please note that your installed OTRS version is %s.' => '',
        'To install this package, you need to update OTRS to version %s or newer.' =>
            '',
        'This package can only be installed on OTRS version %s or older.' =>
            '',
        'This package can only be installed on OTRS version %s or newer.' =>
            '',
        'You will receive updates for all other relevant OTRS issues.' =>
            '',
        'How can I do a patch level update if I don’t have a contract?' =>
            '',
        'Please find all relevant information within the updating instructions at %s.' =>
            '',
        'In case you would have further questions we would be glad to answer them.' =>
            'Als u meer vragen heeft beantwoorden we deze graag.',
        'Continue' => 'Doorgaan',
        'Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            'Zorg dat uw database pakketten van groter dan %s MB accepteert. Op dit moment is de maximale grootte %s MB. Pas de waarde voor max_allowed_packet in het mysql configuratiebestand aan om problemen te voorkomen.',
        'Install' => 'Installeer',
        'Install Package' => 'Installeer pakket',
        'Update repository information' => 'Vernieuw repository gegevens',
        'Cloud services are currently disabled.' => 'Cloud services zijn op dit moment uitgeschakeld.',
        'OTRS Verify™ can not continue!' => 'OTRS Verify™ kan niet  verder gaan!',
        'Enable cloud services' => 'Schakel cloud diensten in',
        'Online Repository' => 'Online Repository',
        'Module documentation' => 'Moduledocumentatie',
        'Upgrade' => 'Upgrade',
        'Local Repository' => 'Lokale Repository',
        'This package is verified by OTRSverify (tm)' => 'Dit pakket is geverifieerd door OTRSverify (tm)',
        'Uninstall' => 'Verwijder',
        'Reinstall' => 'Herinstalleer',
        'Features for %s customers only' => 'Functionaliteit voor alleen %s klanten',
        'With %s, you can benefit from the following optional features. Please make contact with %s if you need more information.' =>
            'Met %s kun je profiteren van de volgende optionele functionaliteit. Neem contact op met %s voor meer informatie.',
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
        'Primary Key' => '',
        'Auto Increment' => '',
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
        'last' => 'laatste',
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
        'Do you really want to delete this filter?' => '',
        'Add PostMaster Filter' => 'Nieuw e-mail filter',
        'Edit PostMaster Filter' => 'Bewerk e-mail filter',
        'A postmaster filter with this name already exists!' => '',
        'Filter Condition' => 'Filter conditie',
        'AND Condition' => 'EN conditie',
        'Check email header' => 'Controleer email kop',
        'Negate' => 'Omdraaien (negate)',
        'Look for value' => 'Zoek naar waarde',
        'The field needs to be a valid regular expression or a literal word.' =>
            'Dit veld kan een woord bevatten of een regular expression.',
        'Set Email Headers' => 'Nieuwe waarden',
        'Set email header' => 'Stel email kop in',
        'Set value' => 'Zet waarde',
        'The field needs to be a literal word.' => 'Dit veld moet een letterlijke waarde bevatten.',

        # Template: AdminPriority
        'Priority Management' => 'Prioriteitenbeheer',
        'Add priority' => 'Nieuwe prioriteit',
        'Add Priority' => 'Nieuwe prioriteit',
        'Edit Priority' => 'Bewerk prioriteit',

        # Template: AdminProcessManagement
        'Process Management' => 'Procesbeheer',
        'Filter for Processes' => 'Filter op processen',
        'Create New Process' => 'Nieuw proces',
        'Deploy All Processes' => 'Deploy alle processen',
        'Here you can upload a configuration file to import a process to your system. The file needs to be in .yml format as exported by process management module.' =>
            'Hier kunt u een proces importeren vanuit een configuratiebestand. Het bestand moet in .yml formaat zijn, zoals geëxporteerd door de procesbeheer-module.',
        'Overwrite existing entities' => 'Overschrijf bestaande records',
        'Upload process configuration' => 'Upload procesconfiguratie',
        'Import process configuration' => 'Importeer procesconfiguratie',
        'Ready-to-run Processes' => '',
        'Here you can activate ready-to-run processes showcasing our best practices. Please note that some additional configuration may be required.' =>
            '',
        'Would you like to benefit from processes created by experts? Upgrade to %s to import some sophisticated ready-to-run processes.' =>
            '',
        'Import ready-to-run process' => '',
        'To create a new Process you can either import a Process that was exported from another system or create a complete new one.' =>
            'Om een nieuw proces aan te maken kunt u een bestand importeren, aangemaakt op een ander systeem, of een compleet nieuw proces aanmaken.',
        'Changes to the Processes here only affect the behavior of the system, if you synchronize the Process data. By synchronizing the Processes, the newly made changes will be written to the Configuration.' =>
            'Wijzigingen aan de processen hebben alleen invloed op het systeem als u de proces-data synchroniseert. Door het synchroniseren van de processen worden de wijzigingen weggeschreven naar de configuratie.',
        'Processes' => 'Processen',
        'Process name' => 'Naam',
        'Print' => 'Afdrukken',
        'Export Process Configuration' => 'Exporteer procesconfiguratie',
        'Copy Process' => 'Kopiëer proces',

        # Template: AdminProcessManagementActivity
        'Cancel & close' => 'Annuleren & sluiten',
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
        'Name: %s, EntityID: %s' => 'Naam: %s. ID: %s',
        'Create New Activity Dialog' => 'Nieuwe dialoog',
        'Assigned Activity Dialogs' => 'Toegewezen dialogen',
        'As soon as you use this button or link, you will leave this screen and its current state will be saved automatically. Do you want to continue?' =>
            'Als u deze knop of link gebruikt, verlaat u dit scherm en de huidige staat wordt automatisch opgeslagen. Wilt u doorgaan?',

        # Template: AdminProcessManagementActivityDialog
        'Please note that changing this activity dialog will affect the following activities' =>
            'Let op: het wijzigen van deze dialoog heeft invoed op de volgende activiteiten',
        'Please note that customer users will not be able to see or use the following fields: Owner, Responsible, Lock, PendingTime and CustomerID.' =>
            'Let op: klanten kunnen de volgende velden niet zien of gebruiken: Eigenaar, Verantwoordelijke, Vergrendeling, Wacht tot datum en Klantcode.',
        'The Queue field can only be used by customers when creating a new ticket.' =>
            'Het Wachtrij veld kan alleen gebruikt door klanten wanneer een nieuw ticket wordt aangemaakt.',
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
        'Name: %s' => 'Naam: %s',
        'Assigned Fields' => 'Toegewezen velden',
        'ArticleType' => 'Interactie-type',
        'Display' => 'Weergave',
        'Edit Field Details' => 'Bewerk veld-details',
        'Customer interface does not support internal article types.' => 'De klant-interface ondersteunt geeb interne interactie-typen.',

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
        'You can start a connection between two Activities by dropping the Transition element over the Start Activity of the connection. After that you can move the loose end of the arrow to the End Activity.' =>
            '',
        'Actions can be assigned to a Transition by dropping the Action Element onto the label of a Transition.' =>
            'Acties kunnen gekoppeld worden aan een transitie door het actie-element naar het label van een transitie te slepen.',
        'Edit Process Information' => 'Bewerk proces-informatie',
        'Process Name' => 'Naam',
        'The selected state does not exist.' => 'De geselecteerde status bestaat niet.',
        'Add and Edit Activities, Activity Dialogs and Transitions' => 'Beheren activiteiten, dialogen en transities',
        'Show EntityIDs' => 'Toon ID\'s',
        'Extend the width of the Canvas' => 'Vergroot de breedte van de canvas',
        'Extend the height of the Canvas' => 'Vergroot de hoogte van de canvas',
        'Remove the Activity from this Process' => 'Verwijder de activiteit uit dit proces',
        'Edit this Activity' => 'Bewerk deze activiteit',
        'Save Activities, Activity Dialogs and Transitions' => 'Bewaar activiteiten, dialogen en transities',
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
        'Remove the Transition from this Process' => 'Verwijder deze transitie uit dit proces',
        'No TransitionActions assigned.' => 'Geen transitie-acties toegewezen.',
        'The Start Event cannot loose the Start Transition!' => 'Het start-event kan niet de start-transitie kwijtraken.',
        'No dialogs assigned yet. Just pick an activity dialog from the list on the left and drag it here.' =>
            'Er zijn nog geen dialogen toegewezen. Kies een dialoog uit de lijst en sleep deze hiernaartoe.',
        'An unconnected transition is already placed on the canvas. Please connect this transition first before placing another transition.' =>
            'Een niet-verbonden transitie is al op de canvas geplaatst. Verbindt deze transitie alvorens een nieuwe transitie te plaatsen.',

        # Template: AdminProcessManagementProcessNew
        'In this screen, you can create a new process. In order to make the new process available to users, please make sure to set its state to \'Active\' and synchronize after completing your work.' =>
            'In dit scherm kunt u een nieuw proces aanmaken. Om het nieuwe proces beschikbaar te maken voor uw gebruikers moet u de status op \'Actief\' zetten en vervolgens een synchronisatie uitvoeren.',

        # Template: AdminProcessManagementProcessPrint
        'cancel & close' => '',
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
        'Transition actions are not being used in this process.' => 'Er zijn geen transitie-acties in dit proces.',

        # Template: AdminProcessManagementTransition
        'Please note that changing this transition will affect the following processes' =>
            'Let op: het wijzigen van deze transitie heeft invloed op de volgende processen',
        'Transition' => 'Transitie',
        'Transition Name' => 'Naam',
        'Conditions can only operate on non-empty fields.' => '',
        'Type of Linking between Conditions' => 'Type koppeling tussen condities',
        'Remove this Condition' => 'Verwijder conditie',
        'Type of Linking' => 'Type koppeling',
        'Add a new Field' => 'Nieuw veld',
        'Remove this Field' => 'Verwijder dit veld',
        'And can\'t be repeated on the same condition.' => 'En kan niet worden herhaald in dezelfde conditie.',
        'Add New Condition' => 'Nieuwe conditie',

        # Template: AdminProcessManagementTransitionAction
        'Please note that changing this transition action will affect the following processes' =>
            'Let op: het wijzigen van deze transitie-actie heeft invloed op de volgende processen',
        'Transition Action' => 'Transitie-actie',
        'Transition Action Name' => 'Naam',
        'Transition Action Module' => 'Transitie-actiemodule',
        'Config Parameters' => 'Configuratie',
        'Add a new Parameter' => 'Nieuwe parameter',
        'Remove this Parameter' => 'Verwijder deze parameter',

        # Template: AdminQueue
        'Manage Queues' => 'Wachtrijenbeheer',
        'Add queue' => 'Nieuwe wachtrij',
        'Add Queue' => 'Nieuwe wachtrij',
        'Edit Queue' => 'Bewerk wachtrij',
        'A queue with this name already exists!' => 'Er bestaat al een wachtrij met deze naam',
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
        'To use a sign key, PGP keys or S/MIME certificates need to be added with identifiers for selected queue system address.' =>
            '',
        'The salutation for email answers.' => 'De aanhef voor beantwoording van berichten per e-mail.',
        'The signature for email answers.' => 'De ondertekening voor beantwoording van berichten per e-mail.',

        # Template: AdminQueueAutoResponse
        'Manage Queue-Auto Response Relations' => 'Beheer Wachtrij - Automatische antwoorden koppelingen',
        'This filter allow you to show queues without auto responses' => 'Dit filter staat je toe om wachtrijen te zien die geen automatisch antwoord hebben.',
        'Queues without auto responses' => 'Wachtrijen zonder automatisch antwoord',
        'This filter allow you to show all queues' => 'Dit filter staat je toe om alle wachtrijen weer te geven',
        'Show all queues' => 'Toon alle wachtrijen',
        'Filter for Queues' => 'Filter op wachtrijen',
        'Filter for Auto Responses' => 'Filter op automatische antwoorden',
        'Auto Responses' => 'Automatische antwoorden',
        'Change Auto Response Relations for Queue' => 'Bewerk automatische antwoorden voor wachtrij',

        # Template: AdminQueueTemplates
        'Manage Template-Queue Relations' => 'Beheer Sjabloon - Wachtrij koppelingen',
        'Filter for Templates' => 'Filter op sjablonen',
        'Templates' => 'Sjablonen',
        'Change Queue Relations for Template' => 'Verander gekoppelde wachtrijen voor sjabloon',
        'Change Template Relations for Queue' => 'Verander gekoppelde sjablonen voor wachtrij',

        # Template: AdminRegistration
        'System Registration Management' => 'Beheer systeemregistratie',
        'Edit details' => 'Bewerk gegevens',
        'Show transmitted data' => 'Toon verstuurde gegevens',
        'Deregister system' => 'Deregistreer systeem',
        'Overview of registered systems' => 'Overzicht van geregistreerde systemen',
        'This system is registered with OTRS Group.' => 'Dit systeem is geregistreerd bij de OTRS Groep.',
        'System type' => 'Systeemtype',
        'Unique ID' => 'Uniek ID',
        'Last communication with registration server' => 'Laatste communicatie met registratieserver',
        'System registration not possible' => 'Systeemregistratie is niet mogelijk',
        'Please note that you can\'t register your system if OTRS Daemon is not running correctly!' =>
            'Het is niet mogelijk om je systeem te registreren als OTRS Daemon niet correct is opgestart!',
        'Instructions' => 'Instructies',
        'System deregistration not possible' => 'Systeem deregistratie is niet mogelijk',
        'Please note that you can\'t deregister your system if you\'re using the %s or having a valid service contract.' =>
            'Je kunt je systeem niet deregistreren als je het %s gebruikt of wanneer je een geldig service contract hebt.',
        'OTRS-ID Login' => 'OTRS-ID',
        'Read more' => 'Lees meer',
        'You need to log in with your OTRS-ID to register your system.' =>
            'U moet inloggen met uw OTRS-ID om uw systeem te registreren',
        'Your OTRS-ID is the email address you used to sign up on the OTRS.com webpage.' =>
            'Uw OTRS-ID is het emailadres waarmee u zich heeft ingeschreven op de OTRS.com website.',
        'Data Protection' => 'Gegevens beveiliging',
        'What are the advantages of system registration?' => 'Wat zijn de voordelen van systeemregistratie?',
        'You will receive updates about relevant security releases.' => 'U krijgt bericht over relevante security-releases',
        'With your system registration we can improve our services for you, because we have all relevant information available.' =>
            'Door middel van uw systeemregistratie kunnen wij onze dienstverlening aan u verbeteren, omdat we alle relevante informatie beschikbaar hebben.',
        'This is only the beginning!' => 'Dit is nog maar het begin.',
        'We will inform you about our new services and offerings soon.' =>
            'We zullen u binnenkort informeren over onze nieuwe diensten!',
        'Can I use OTRS without being registered?' => 'Kan ik OTRS gebruiken zonder te registreren?',
        'System registration is optional.' => 'Systeemregistratie is optioneel.',
        'You can download and use OTRS without being registered.' => 'U kunt OTRS downloaden en gebruiken zonder geregistreerd te zijn.',
        'Is it possible to deregister?' => 'Is het mogelijk om te deregistreren?',
        'You can deregister at any time.' => 'U kunt op elk moment deregistreren.',
        'Which data is transfered when registering?' => 'Welke data wordt verstuurd als ik mij registreer?',
        'A registered system sends the following data to OTRS Group:' => 'Een geregistreerd systeem verstuurt de volgende gegevens naar de OTRS Groep:',
        'Fully Qualified Domain Name (FQDN), OTRS version, Database, Operating System and Perl version.' =>
            'Fully Qualified Domain Name (FQDN), OTRS-versie, database-versie, gebruikt besturingssysteem en Perl-versie.',
        'Why do I have to provide a description for my system?' => 'Waarom moet ik een beschrijving van mijn systeem invullen?',
        'The description of the system is optional.' => 'Deze beschrijving is optioneel.',
        'The description and system type you specify help you to identify and manage the details of your registered systems.' =>
            'De beschrijving en systeem-type die u specificeert helpen u om uw systeem te identificeren en een overzicht te houden van uw geregistreerde systemen.',
        'How often does my OTRS system send updates?' => 'Hoe vaak verstuurt mijn OTRS-systeem updates?',
        'Your system will send updates to the registration server at regular intervals.' =>
            'Uw systeem verstuurt op regelmatige basis updates.',
        'Typically this would be around once every three days.' => 'Normaal gesproken is dit ongeveer eens per drie dagen.',
        'Please visit our' => 'Bezoek ons',
        'portal' => 'klantportaal',
        'and file a request.' => 'en dien een verzoek in.',
        'If you deregister your system, you will lose these benefits:' =>
            'Als je je systeem deregistreert, verlies je de volgende voordelen:',
        'You need to log in with your OTRS-ID to deregister your system.' =>
            'U moet inloggen met uw OTRS-ID om uw systeem te deregistreren.',
        'OTRS-ID' => 'OTRS-ID',
        'You don\'t have an OTRS-ID yet?' => 'Heeft u nog geen OTRS-ID?',
        'Sign up now' => 'Gebruikersnaam registreren',
        'Forgot your password?' => 'Wachtwoord vergeten?',
        'Retrieve a new one' => 'Wachtwoord herstellen',
        'This data will be frequently transferred to OTRS Group when you register this system.' =>
            'Deze gegevens worden op regelmatige basis verstuurd naar de OTRS Groep als u dit systeem registreert.',
        'Attribute' => 'Attribuut',
        'FQDN' => 'FQDN',
        'OTRS Version' => 'OTRS-versie',
        'Operating System' => 'Besturingssysteem',
        'Perl Version' => 'Perl-versie',
        'Optional description of this system.' => 'Optionele omschrijving van dit systeem.',
        'Register' => 'Registreer',
        'Deregister System' => 'Deregistreer systeem',
        'Continuing with this step will deregister the system from OTRS Group.' =>
            'Doorgaan met deze stap zal uw systeem deregistreren bij de OTRS Groep.',
        'Deregister' => 'Deregistreer',
        'You can modify registration settings here.' => 'Je kunt je registratie instellingen hier aanpassen',
        'Overview of transmitted data' => 'Overzicht van verstuurde gegevens',
        'There is no data regularly sent from your system to %s.' => 'Er zijn geen gegevens die regelmatig worden verzonden van jouw systeem naar %s',
        'The following data is sent at minimum every 3 days from your system to %s.' =>
            'De volgende gegevens over jouw systeem worden maximaal elke 3 dagen verzonden naar %s',
        'The data will be transferred in JSON format via a secure https connection.' =>
            'De gegevens worden verstuurd in JSON format via een beveiligde https verbinding',
        'System Registration Data' => 'Systeemregistratie gegevens',
        'Support Data' => 'Ondersteuningsgegevens',

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
        'note' => 'notitie',
        'Permissions to add notes to tickets in this group/queue.' => 'Permissies om notities aan tickets in de wachtrijen behorende bij deze groep toe te voegen.',
        'owner' => 'eigenaar',
        'Permissions to change the owner of tickets in this group/queue.' =>
            'Permissies om de eigenaar van de tickets in de wachtrijen behorende bij deze groep te wijzigen.',
        'priority' => 'prioriteit',
        'Permissions to change the ticket priority in this group/queue.' =>
            'Permissies om de prioriteit van een ticket in deze groep/wachtrij te wijzigen.',

        # Template: AdminRoleUser
        'Manage Agent-Role Relations' => 'Beheer Behandelaar-Rol koppelingen',
        'Add agent' => 'Nieuwe behandelaar',
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
        'SMIME support is disabled' => '',
        'To be able to use SMIME in OTRS, you have to enable it first.' =>
            '',
        'Enable SMIME support' => '',
        'Faulty SMIME configuration' => '',
        'SMIME support is enabled, but the relevant configuration contains errors. Please check the configuration using the button below.' =>
            '',
        'Check SMIME configuration' => '',
        'Add certificate' => 'Nieuw certificaat',
        'Add private key' => 'Private sleutel toevoegen',
        'Filter for certificates' => 'Filter op certificaten',
        'Filter for S/MIME certs' => 'Filter voor S/MIME certificaten',
        'To show certificate details click on a certificate icon.' => 'Klik op een certificaat icoon om de details van een certificaat weer te geven.',
        'To manage private certificate relations click on a private key icon.' =>
            'Om je privé certificaat relaties te beheren, klik je op een privé sleutel icoon.',
        'Here you can add relations to your private certificate, these will be embedded to the S/MIME signature every time you use this certificate to sign an email.' =>
            'Hier kun je relaties toevoegen aan je prive certificaten, deze worden in de S/MIME ondertekening meegezonden wanneer je dit certificaat gebruikt om e-mail te ondertekenen.',
        'See also' => 'Zie voor meer informatie',
        'In this way you can directly edit the certification and private keys in file system.' =>
            'Hier kunt u de certificaten en private sleutels van OTRS beheren.',
        'Hash' => 'Hash',
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
        'Close dialog' => '',
        'Certificate details' => 'Certificaat details',

        # Template: AdminSalutation
        'Salutation Management' => 'Beheer aanheffen',
        'Add salutation' => 'Nieuwe aanhef',
        'Add Salutation' => 'Nieuwe aanhef',
        'Edit Salutation' => 'Bewerk aanhef',
        'e. g.' => 'bijv.',
        'Example salutation' => 'Aanhef voorbeeld',

        # Template: AdminSecureMode
        'Secure mode needs to be enabled!' => 'Secure Mode is niet actief.',
        'Secure mode will (normally) be set after the initial installation is completed.' =>
            'Secure Mode wordt normaal gesproken geactiveerd na afronding van de installatie.',
        'If secure mode is not activated, activate it via SysConfig because your application is already running.' =>
            'Als Secure Mode nog niet actief is activeer dit via de Systeemconfiguratie omdat de applicatie al draait.',

        # Template: AdminSelectBox
        'SQL Box' => 'SQL console',
        'Here you can enter SQL to send it directly to the application database. It is not possible to change the content of the tables, only select queries are allowed.' =>
            'Hier kun je SQL invoeren om direct naar de database te versturen. Het is niet mogelijk om de inhoud van de tabellen aan te passen, alleen select queries zijn toegestaan.',
        'Here you can enter SQL to send it directly to the application database.' =>
            'Hier kunt u SQL statements invoeren die direct door de database worden uitgevoerd.',
        'Only select queries are allowed.' => 'Alleen select queries zijn toegestaan.',
        'The syntax of your SQL query has a mistake. Please check it.' =>
            'De syntax van uw SQL query bevat een fout.',
        'There is at least one parameter missing for the binding. Please check it.' =>
            'Er mist tenminste een parameter.',
        'Result format' => 'Uitvoeren naar',
        'Run Query' => 'Uitvoeren',
        'Query is executed.' => 'Query is uitgevoerd.',

        # Template: AdminService
        'Service Management' => 'Service beheer',
        'Add service' => 'Nieuwe service',
        'Add Service' => 'Nieuwe service',
        'Edit Service' => 'Bewerk Service',
        'Service name maximum length is 200 characters (with Sub-service).' =>
            '',
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
        'It\'s not possible to invalidate this entry because there is no other merge states in system!' =>
            '',

        # Template: AdminSupportDataCollector
        'Sending support data to OTRS Group is not possible!' => 'Het versturen van support gegevens naar OTRS Group is niet mogelijk!',
        'Enable Cloud Services' => 'Schakel Cloud Diensten in',
        'This data is sent to OTRS Group on a regular basis. To stop sending this data please update your system registration.' =>
            'Deze gegevens worden regelmatig verstuurd naar OTRS Group. Om te stoppen met het versturen van deze gegevens moet je je systeem registatie aanpassen.',
        'You can manually trigger the Support Data sending by pressing this button:' =>
            'Je kunt handmatig de Support Data versturen door op deze knop te sturen:',
        'Send Update' => 'Verstuur Update',
        'Sending Update...' => 'Update versturen...',
        'Support Data information was successfully sent.' => 'Support Data is succesvol verstuurd',
        'Was not possible to send Support Data information.' => 'Het was niet mogelijk om Support Data te versturen.',
        'Update Result' => 'Update Resultaat',
        'Currently this data is only shown in this system.' => 'Op dit moment worden deze gegevens alleen in dit systeem weergegeven.',
        'A support bundle (including: system registration information, support data, a list of installed packages and all locally modified source code files) can be generated by pressing this button:' =>
            'Een support bundel kan gegenereerd worden door op deze knop te drukken (inclusief: systeem registratie informatie, ondersteuningsgegevens, een lijst met geïnstalleerde pakketen en alle lokaal aanepaste bronconde bestanden).',
        'Generate Support Bundle' => 'Genereer support bundel',
        'Generating...' => 'Genereren...',
        'It was not possible to generate the Support Bundle.' => 'Het was niet mogelijk om de Support Bundel te genereren',
        'Generate Result' => 'Genereer Resultaat',
        'Support Bundle' => 'Support Bundel',
        'The mail could not be sent' => 'De mail kon niet verzonden woden.',
        'The support bundle has been generated.' => 'De support bundel is gegenereerd.',
        'Please choose one of the following options.' => 'Kies één van de volgende opties.',
        'Send by Email' => 'Verstur via Email',
        'The support bundle is too large to send it by email, this option has been disabled.' =>
            'De support bundel is te groot om te verstuen per mail, deze optie is niet beschikbaar.',
        'The email address for this user is invalid, this option has been disabled.' =>
            'Het e-mail adres voor deze gebruiker is ongeldig, deze optie is niet beschikbaar.',
        'Sending' => 'Afzender',
        'The support bundle will be sent to OTRS Group via email automatically.' =>
            'De support bundel wordt automatisch verzonden naar OTRS Group via e-mail.',
        'Download File' => 'Download bestand',
        'A file containing the support bundle will be downloaded to the local system. Please save the file and send it to the OTRS Group, using an alternate method.' =>
            'Een bestand met de support bundel wordt gedownload naar het lokale systeem. Je kunt het opslaan en versturen naar OTRS Group via een alternatieve methode.',
        'Error: Support data could not be collected (%s).' => 'Fout: Support gegevens konden niet worden verzameld (%s).',
        'Details' => 'Details',

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
        'Edit Config Settings in %s → %s' => '',
        'This setting is read only.' => 'Deze instelling kan niet worden aangepast.',
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
        'Delete this entry' => 'Verwijder antwoord',
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
        'NavBar module' => 'Navigatiebalk module',
        'Year' => 'Jaar',
        'Month' => 'Maand',
        'Day' => 'Dag',
        'Invalid year' => 'Ongeldig jaar',
        'Invalid month' => 'Ongeldige maand',
        'Invalid day' => 'Ongeldige dag',
        'Show more' => 'Toon meer',

        # Template: AdminSystemAddress
        'System Email Addresses Management' => 'Systeem e-mailadressen beheer',
        'Add system address' => 'Nieuw e-mailadres',
        'All incoming email with this address in To or Cc will be dispatched to the selected queue.' =>
            'Alle inkomende berichten met dit adres in Aan of CC worden toegewezen aan de geselecteerde wachtrij.',
        'Email address' => 'E-mailadres',
        'Display name' => 'Weergegeven naam',
        'Add System Email Address' => 'Nieuw e-mailadres',
        'Edit System Email Address' => 'Bewerk e-mailadres',
        'This email address is already used as system email address.' => '',
        'The display name and email address will be shown on mail you send.' =>
            'De weergegeven naam en het e-mailadres worden gebruikt voor uitgaande mail.',
        'This system address cannot be set to invalid, because it is used in one or more queue(s).' =>
            '',

        # Template: AdminSystemMaintenance
        'System Maintenance Management' => 'Systeem onderhoudsbeheer.',
        'Schedule New System Maintenance' => 'Plan een nieuw systeem onderhouds tijdsvak.',
        'Schedule a system maintenance period for announcing the Agents and Customers the system is down for a time period.' =>
            'Plan een systeem onderhoudsperiode om aan Agents en Klanten aan te kondigen dat het systeem voor een bepaalde periode down is.',
        'Some time before this system maintenance starts the users will receive a notification on each screen announcing about this fact.' =>
            'Een bepaalde tijd voordat het systeem onderhoud begint krijgen de gebruikers een melding op elk scherm waarin het onderhoud wordt aangekondigd.',
        'Start date' => 'Begindatum',
        'Stop date' => 'Einddatum',
        'Delete System Maintenance' => 'Verwijder Systeemonderhoudstijdsvak.',
        'Do you really want to delete this scheduled system maintenance?' =>
            'Weet je zeker dat u dit onderhoudstijdsvak wilt verwijderen?',

        # Template: AdminSystemMaintenanceEdit
        'Edit System Maintenance %s' => 'Bewerk onderhoudsvenster %s',
        'Edit System Maintenance Information' => '',
        'Date invalid!' => 'Ongeldige datum.',
        'Login message' => 'Login bericht',
        'This field must have less then 250 characters.' => '',
        'Show login message' => 'Toon login bericht',
        'Notify message' => 'Melding bericht',
        'Manage Sessions' => 'Beheer sessies',
        'All Sessions' => 'Alle Sessies',
        'Agent Sessions' => 'Gebruikerssessies',
        'Customer Sessions' => 'Klant Sessies',
        'Kill all Sessions, except for your own' => 'Stop alle sessies, behalve die van jezelf',

        # Template: AdminTemplate
        'Manage Templates' => 'Beheer sjablonen',
        'Add template' => 'Nieuw sjabloon',
        'A template is a default text which helps your agents to write faster tickets, answers or forwards.' =>
            'Een sjabloon is een standaardtext die uw behandelaars helpt sneller tickets aan te maken of te beantwoorden.',
        'Don\'t forget to add new templates to queues.' => 'Vergeet niet de sjablonen aan wachtrijen te koppelen.',
        'Do you really want to delete this template?' => 'Wilt u deze template echt verwijderen?',
        'Add Template' => 'Nieuw sjabloon',
        'Edit Template' => 'Bewerk sjabloon',
        'A standard template with this name already exists!' => 'Er bestaat al een standaard template met deze naam!',
        'Create type templates only supports this smart tags' => 'Sjablonen van het type \'Aanmaken\' ondersteunen alleen deze tags',
        'Example template' => 'Voorbeeld-sjabloon',
        'The current ticket state is' => 'De huidige ticketstatus is',
        'Your email address is' => 'Uw e-mailadres is',

        # Template: AdminTemplateAttachment
        'Manage Templates <-> Attachments Relations' => 'Beheer Sjabloon <-> Bijlage koppelingen',
        'Filter for Attachments' => 'Filter op bijlagen',
        'Change Template Relations for Attachment' => 'Verander gekoppelde sjablonen voor bijlage',
        'Change Attachment Relations for Template' => 'Verander gekoppelde bijlagen voor sjabloon',
        'Toggle active for all' => 'Actief aan/uit voor alles',
        'Link %s to selected %s' => 'Koppel %s aan %s',

        # Template: AdminType
        'Type Management' => 'Type beheer',
        'Add ticket type' => 'Nieuw ticket type',
        'Add Type' => 'Nieuw type',
        'Edit Type' => 'Bewerk type',
        'A type with this name already exists!' => 'Er bestaat al een type met deze naam!',

        # Template: AdminUser
        'Agents will be needed to handle tickets.' => 'Behandelaar-accounts zijn nodig om te kunnen werken in het systeem.',
        'Don\'t forget to add a new agent to groups and/or roles!' => 'vergeet niet om een behandelaar aan groepen en/of rollen te koppelen.',
        'Please enter a search term to look for agents.' => 'Typ om te zoeken naar behandelaars.',
        'Last login' => 'Laatst ingelogd',
        'Switch to agent' => 'Omschakelen naar behandelaar',
        'Add Agent' => 'Nieuwe behandelaar',
        'Edit Agent' => 'Bewerk behandelaar',
        'Title or salutation' => 'Titel of Aanhef',
        'Firstname' => 'Voornaam',
        'Lastname' => 'Achternaam',
        'A user with this username already exists!' => 'Er bestaat al een gebruiker met deze naam!',
        'Will be auto-generated if left empty.' => 'Zal automatisch worden gegenereerd indien leeg.',
        'Start' => 'Begin',
        'End' => 'Einde',

        # Template: AdminUserGroup
        'Manage Agent-Group Relations' => 'Beheer Behandelaar-Groep koppelingen',
        'Add group' => 'Groep toevoegen',
        'Change Group Relations for Agent' => 'Bewerk gekoppelde groepen voor behandelaar',
        'Change Agent Relations for Group' => 'Bewerk gekoppelde behandelaars voor groep',

        # Template: AgentBook
        'Address Book' => 'Adresboek',
        'Search for a customer' => 'Zoek naar een klant',
        'Add email address %s to the To field' => 'Voeg e-mailadres %s toe aan het Aan-veld',
        'Add email address %s to the Cc field' => 'Voeg e-mailadres %s toe aan het CC-veld',
        'Add email address %s to the Bcc field' => 'Voeg e-mailadres %s toe aan het BCC-veld',
        'Apply' => 'Toepassen',

        # Template: AgentCustomerInformationCenter
        'Customer Information Center' => 'Klantinformatie overzicht',

        # Template: AgentCustomerInformationCenterSearch
        'Customer User' => 'Klant',

        # Template: AgentCustomerSearch
        'Duplicated entry' => 'Dubbel adres',
        'This address already exists on the address list.' => 'Dit adres is al toegevoegd.',
        'It is going to be deleted from the field, please try again.' => 'Het wordt verwijderd van dit veld, probeer opnieuw.',

        # Template: AgentCustomerTableView
        'Note: Customer is invalid!' => 'Let op: klant is ongeldig!',
        'Start chat' => 'Start chat',
        'Video call' => '',
        'Audio call' => '',

        # Template: AgentDaemonInfo
        'The OTRS Daemon is a daemon process that performs asynchronous tasks, e.g. ticket escalation triggering, email sending, etc.' =>
            'De OTRS Daemon is een achtergrondproces dat a synchrone taken uitvoert, dat wil zeggen, escalatie van tickets, gebeurtenissen, emails en dergelijke.',
        'A running OTRS Daemon is mandatory for correct system operation.' =>
            'Een draaiende OTRS Daemon is vereist voor een correcte werking van het systeem.',
        'Starting the OTRS Daemon' => 'De OTRS Daemon wordt opgestart',
        'Make sure that the file \'%s\' exists (without .dist extension). This cron job will check every 5 minutes if the OTRS Daemon is running and start it if needed.' =>
            'Zorg er voor dat het bestand \'%s\' bestaat (zonder .dist extensie). Deze cron taak controleert elke 5 minuten of de OTRS Daemon loopt en start hem als het nodig is.',
        'Execute \'%s start\' to make sure the cron jobs of the \'otrs\' user are active.' =>
            'Voer \'%s start\' uit om ervoor te zorgen dat de cron jobs van de gebruiker \'otrs\' actief zijn.',
        'After 5 minutes, check that the OTRS Daemon is running in the system (\'bin/otrs.Daemon.pl status\').' =>
            'Controleer na 5 minuten of de OTRS Daemon draait in het systeem (\'bin/otrs.Daemon.pl status\').',

        # Template: AgentDashboard
        'Dashboard' => 'Dashboard',

        # Template: AgentDashboardCalendarOverview
        'in' => 'over',

        # Template: AgentDashboardCommon
        'Save settings' => 'Instellingen opslaan',
        'Close this widget' => '',
        'Available Columns' => 'Beschikbare kolommen',
        'Visible Columns (order by drag & drop)' => 'Beschikbare kolommen (sorteer door middel van drag & drop)',

        # Template: AgentDashboardCustomerIDStatus
        'Escalated tickets' => 'Geëscaleerde tickets',

        # Template: AgentDashboardCustomerUserList
        'Customer login' => 'Klant login',
        'Customer information' => 'Klantinformatie',
        'Phone ticket' => 'Telefoon-ticket',
        'Email ticket' => 'E-mail-ticket',
        '%s open ticket(s) of %s' => '%s open ticket(s) van %s',
        '%s closed ticket(s) of %s' => '%s gesloten ticket(s) van %s',
        'New phone ticket from %s' => 'Nieuw telefoonticket van %s',
        'New email ticket to %s' => 'Nieuw emailticket aan %s',

        # Template: AgentDashboardProductNotify
        '%s %s is available!' => '%s %s is beschikbaar.',
        'Please update now.' => 'Voer nu een update uit.',
        'Release Note' => 'Releasenote',
        'Level' => 'Soort',

        # Template: AgentDashboardRSSOverview
        'Posted %s ago.' => 'Geplaatst %s geleden.',

        # Template: AgentDashboardStats
        'The configuration for this statistic widget contains errors, please review your settings.' =>
            'De configuratie voor deze statistieken widget bevat fouten, controleer je instelingen.',
        'Download as SVG file' => 'Download als SVG file',
        'Download as PNG file' => 'Download als PNG file',
        'Download as CSV file' => 'Download als CSV file',
        'Download as Excel file' => 'Download als Excel file',
        'Download as PDF file' => 'Download als PDF file',
        'Grouped' => 'Gegroepeerd',
        'Stacked' => 'Gestapeld',
        'Expanded' => 'Uitgebreid',
        'Stream' => 'Stream',
        'No Data Available.' => '',
        'Please select a valid graph output format in the configuration of this widget.' =>
            'Selecteer een geldige grafiek output format in de configuratie van deze widget.',
        'The content of this statistic is being prepared for you, please be patient.' =>
            'De inhoud van deze rapportage wordt voor u aangemaakt, even geduld.',
        'This statistic can currently not be used because its configuration needs to be corrected by the statistics administrator.' =>
            'Deze statistiek kan op dit moment niet worden gebruikt omdat de configuratie gecorrigeerd moet worden door de statistieken administrator. ',

        # Template: AgentDashboardTicketGeneric
        'My locked tickets' => 'Mijn vergrendelde tickets',
        'My watched tickets' => 'Mijn gevolgde tickets',
        'My responsibilities' => 'Tickets waarvoor ik verantwoordelijk ben',
        'Tickets in My Queues' => 'Tickets in mijn wachtrijen',
        'Tickets in My Services' => 'Tickets in Mijn Services',
        'Service Time' => 'Service tijd',
        'Remove active filters for this widget.' => 'Verwijder actieve filters voor dit widget.',

        # Template: AgentDashboardTicketQueueOverview
        'Totals' => 'Totaal',

        # Template: AgentDashboardUserOnline
        'out of office' => 'afwezigheid',

        # Template: AgentDashboardUserOutOfOffice
        'until' => 'tot',

        # Template: AgentHTMLReferencePageLayout
        'The ticket has been locked' => 'Het ticket is vergrendeld',
        'Undo & close' => 'Ongedaan maken & sluiten',

        # Template: AgentInfo
        'Info' => 'Informatie',
        'To accept some news, a license or some changes.' => 'Om een tekst te tonen, zoals nieuws of een licentie, die de agent moet accepteren.',

        # Template: AgentLinkObject
        'Link Object: %s' => 'Koppel object: %s',
        'go to link delete screen' => 'ga naar koppeling-verwijder scherm',
        'Select Target Object' => 'Selecteer doel',
        'Link object %s with' => '',
        'Unlink Object: %s' => 'Verwijder de relatie met object: %s',
        'go to link add screen' => 'ga naar koppelscherm',

        # Template: AgentOTRSBusinessBlockScreen
        'Unauthorized usage of %s detected' => '',
        'If you decide to downgrade to ((OTRS)) Community Edition, you will lose all database tables and data related to %s.' =>
            '',

        # Template: AgentPreferences
        'Edit your preferences' => 'Bewerk uw voorkeuren',
        'Did you know? You can help translating OTRS at %s.' => 'Wist je dat je kunt helpen om OTRS te vertalen via %s?',

        # Template: AgentSpelling
        'Spell Checker' => 'Spellingcontrole',
        'spelling error(s)' => 'Spelfout(en)',
        'Apply these changes' => 'Pas deze wijzigingen toe',

        # Template: AgentStatisticsAdd
        'Statistics » Add' => 'Statistieken » Voeg toe',
        'Add New Statistic' => 'Voeg een nieuwe statistiek toe',
        'Dynamic Matrix' => 'Dynamische matrix',
        'Tabular reporting data where each cell contains a singular data point (e. g. the number of tickets).' =>
            'Met tabs gescheiden gegevens waarbij elke cell een enkel datapunt bevat (b.v. het aantal tickets)',
        'Dynamic List' => 'Dynamische lijst',
        'Tabular reporting data where each row contains data of one entity (e. g. a ticket).' =>
            'Met tabs gescheiden gegevens waar elke rij een entiteit is (b.v. een ticket).',
        'Static' => 'Statistiek',
        'Complex statistics that cannot be configured and may return non-tabular data.' =>
            'Complexe statistieken die niet kunnen worden geconfigureerd en welke mogelijk geen met tabs gescheiden gegevens genereren.',
        'General Specification' => 'Algemene specificatie',
        'Create Statistic' => 'Maak statistiek',

        # Template: AgentStatisticsEdit
        'Statistics » Edit %s%s — %s' => 'Statistieken » Bewerk %s%s — %s',
        'Run now' => 'Voer nu uit',
        'Statistics Preview' => 'Voorbeeld van rapportages',
        'Save statistic' => 'Sla rapportage op',

        # Template: AgentStatisticsImport
        'Statistics » Import' => 'Rapportages » Importeren',
        'Import Statistic Configuration' => 'Importeer Rapportage Configuratie',

        # Template: AgentStatisticsOverview
        'Statistics » Overview' => 'Rapportages » Overzicht',
        'Statistics' => 'Rapportages',
        'Run' => 'Voer uit',
        'Edit statistic "%s".' => 'Bewerk rapportage "%s".',
        'Export statistic "%s"' => 'Exporteer rapportage "%s"',
        'Export statistic %s' => 'Exporteer Rapportage %s',
        'Delete statistic "%s"' => 'Verwijder rapportage "%s"',
        'Delete statistic %s' => 'Verwijder rapportage %s',
        'Do you really want to delete this statistic?' => 'Weet u zeker dat u deze rapportage wilt verwijderen?',

        # Template: AgentStatisticsView
        'Statistics » View %s%s — %s' => 'Statistieken » Toon %s%s — %s',
        'Statistic Information' => 'Rapportage informatie',
        'Sum rows' => 'Toon totaal per rij',
        'Sum columns' => 'Toon totaal per kolom',
        'Show as dashboard widget' => 'Toon als dashboard-widget',
        'Cache' => 'Cache',
        'This statistic contains configuration errors and can currently not be used.' =>
            'Deze rapportage bevat configuratiefouten en kan niet worden gebruikt',

        # Template: AgentTicketActionCommon
        'Change Free Text of %s%s%s' => '',
        'Change Owner of %s%s%s' => '',
        'Close %s%s%s' => '',
        'Add Note to %s%s%s' => '',
        'Set Pending Time for %s%s%s' => '',
        'Change Priority of %s%s%s' => '',
        'Change Responsible of %s%s%s' => '',
        'All fields marked with an asterisk (*) are mandatory.' => 'Alle velden met een asterisk (*) zijn verplicht.',
        'Service invalid.' => 'Service is ongeldig.',
        'New Owner' => 'Nieuwe eigenaar',
        'Please set a new owner!' => 'Kies een nieuwe eigenaar.',
        'New Responsible' => 'Nieuwe verantwoordelijke',
        'Next state' => 'Status',
        'For all pending* states.' => 'Voor alle cases die staan te wachten',
        'Add Article' => 'Voeg Artikel toe',
        'Create an Article' => 'Maak een Artikel',
        'Inform agents' => 'Stel gebruikers op de hoogte',
        'Inform involved agents' => 'Stel betrokken gebruikers op de hoogte',
        'Here you can select additional agents which should receive a notification regarding the new article.' =>
            'Hier kun je extra gebruikers aanvinken die een notificatie zouden moeten krijgen over het nieuwe artikel.',
        'Text will also be received by' => '',
        'Spell check' => 'Spellingscontrole',
        'Text Template' => 'Tekstsjabloon',
        'Setting a template will overwrite any text or attachment.' => 'Het instellen van een template overschrijft alle testen en bijlagen.',
        'Note type' => 'Notitiesoort',

        # Template: AgentTicketBounce
        'Bounce %s%s%s' => '',
        'Bounce to' => 'Bounce naar',
        'You need a email address.' => 'E-mailadres is verplicht.',
        'Need a valid email address or don\'t use a local email address.' =>
            'Een e-mailadres is verplicht. U kunt geen lokale adressen gebruiken.',
        'Next ticket state' => 'Status',
        'Inform sender' => 'Informeer afzender',
        'Send mail' => 'Bericht versturen',

        # Template: AgentTicketBulk
        'Ticket Bulk Action' => 'Ticket bulk-actie',
        'Send Email' => 'Stuur e-mail',
        'Merge to' => 'Voeg samen met',
        'Invalid ticket identifier!' => 'Ongeldige ticket identifier.',
        'Merge to oldest' => 'Voeg samen met oudste',
        'Link together' => 'Koppelen',
        'Link to parent' => 'Koppel aan vader',
        'Unlock tickets' => 'Ontgrendel tickets',
        'Execute Bulk Action' => '',

        # Template: AgentTicketCompose
        'Compose Answer for %s%s%s' => '',
        'This address is registered as system address and cannot be used: %s' =>
            'Dit adres is geregistreerd als een systee adres en kan niet worden gebruikt.',
        'Please include at least one recipient' => 'Voeg tenminste één ontvanger toe',
        'Remove Ticket Customer' => 'Verwijder ',
        'Please remove this entry and enter a new one with the correct value.' =>
            'Verwijder deze en geef een nieuwe met een correcte waarde.',
        'Remove Cc' => 'Verwijder CC',
        'Remove Bcc' => 'Verwijder BCC',
        'Address book' => 'Adresboek',
        'Date Invalid!' => 'Datum ongeldig.',

        # Template: AgentTicketCustomer
        'Change Customer of %s%s%s' => '',

        # Template: AgentTicketEmail
        'Create New Email Ticket' => 'Maak nieuw e-mail ticket',
        'Example Template' => 'Voorbeeld Template',
        'From queue' => 'In wachtrij',
        'To customer user' => 'Aan klant',
        'Please include at least one customer user for the ticket.' => 'Selecteer tenminste een klant voor dit ticket.',
        'Select this customer as the main customer.' => 'Selecteer deze klant als hoofd-klant',
        'Remove Ticket Customer User' => 'Verwijder klant van ticket',
        'Get all' => 'Gebruik alle',

        # Template: AgentTicketEmailOutbound
        'Outbound Email for %s%s%s' => '',

        # Template: AgentTicketEscalation
        'Ticket %s: first response time is over (%s/%s)!' => 'Ticket %s: eerste antwoord tijd is voorbij (%s/%s)!',
        'Ticket %s: first response time will be over in %s/%s!' => 'Ticket %s: eerste antwoord tijd zal voorbij zijn binnen %s/%s!',
        'Ticket %s: update time is over (%s/%s)!' => '',
        'Ticket %s: update time will be over in %s/%s!' => 'Ticket $s: vervolg tijd zal voorbij zijn binnen %s.',
        'Ticket %s: solution time is over (%s/%s)!' => 'Ticket %s: oplossing tijd is voorbij (%s/%s)!',
        'Ticket %s: solution time will be over in %s/%s!' => 'Ticket %s: oplossing tijd zal voorbij zijn binnen %s/%s!',

        # Template: AgentTicketForward
        'Forward %s%s%s' => '',

        # Template: AgentTicketHistory
        'History of %s%s%s' => '',
        'History Content' => 'Inhoud',
        'Zoom view' => 'Detailoverzicht',

        # Template: AgentTicketMerge
        'Merge %s%s%s' => '',
        'Merge Settings' => 'Samenvoegingsinstellingen',
        'You need to use a ticket number!' => 'Gebruik een ticketnummer.',
        'A valid ticket number is required.' => 'Een geldig ticketnummer is verplicht.',
        'Need a valid email address.' => 'Geen geldig e-mailadres.',

        # Template: AgentTicketMove
        'Move %s%s%s' => '',
        'New Queue' => 'Nieuwe wachtrij',

        # Template: AgentTicketOverviewMedium
        'Select all' => 'Selecteer alles',
        'No ticket data found.' => 'Geen tickets gevonden.',
        'Open / Close ticket action menu' => 'Open / Sluit ticket actie menu',
        'Select this ticket' => 'Selecteer dit ticket',
        'First Response Time' => 'Eerste reactie',
        'Update Time' => 'Vervolg tijd',
        'Solution Time' => 'Oplossingstijd',
        'Move ticket to a different queue' => 'Verplaats naar nieuwe wachtrij',
        'Change queue' => 'Verplaats naar wachtrij',

        # Template: AgentTicketOverviewNavBar
        'Change search options' => 'Verander zoekopties',
        'Remove active filters for this screen.' => 'Verwijder actieve filters voor dit scherm.',
        'Tickets per page' => 'Tickets per pagina',

        # Template: AgentTicketOverviewSmall
        'Reset overview' => 'Herstel overzicht',
        'Column Filters Form' => 'Kolom filter formulier',

        # Template: AgentTicketPhone
        'Split Into New Phone Ticket' => 'Splits in nieuw telefoon ticket',
        'Save Chat Into New Phone Ticket' => 'Bewaar chat in nieuw telefoon ticket',
        'Create New Phone Ticket' => 'Maak nieuw telefoon ticket aan',
        'Please include at least one customer for the ticket.' => 'Voeg ten minste één klant toe voor dit ticket.',
        'To queue' => 'In wachtrij',
        'Chat protocol' => 'Chat protocol',
        'The chat will be appended as a separate article.' => 'De chat wordt toegevoegd als een apart artikel',

        # Template: AgentTicketPhoneCommon
        'Phone Call for %s%s%s' => '',

        # Template: AgentTicketPlain
        'View Email Plain Text for %s%s%s' => '',
        'Plain' => 'Zonder opmaak',
        'Download this email' => 'Download deze e-mail',

        # Template: AgentTicketProcess
        'Create New Process Ticket' => 'Nieuw proces-ticket',
        'Process' => 'Proces',

        # Template: AgentTicketProcessSmall
        'Enroll Ticket into a Process' => 'Voeg ticket toe aan een proces',

        # Template: AgentTicketSearch
        'Search template' => 'Sjabloon',
        'Create Template' => 'Maak sjabloon',
        'Create New' => 'Nieuw',
        'Profile link' => 'Koppeling naar sjabloon',
        'Save changes in template' => 'Sla wijzigingen op in sjabloon',
        'Filters in use' => 'Filters in gebruik',
        'Additional filters' => 'Extra filters',
        'Add another attribute' => 'Voeg attribuut toe',
        'Output' => 'Uitvoeren naar',
        'Fulltext' => 'Volledig',
        'Remove' => 'Verwijderen',
        'Searches in the attributes From, To, Cc, Subject and the article body, overriding other attributes with the same name.' =>
            'Doorzoek de velden Van, Aan, Cc, Onderwerp en de berichttekst, vervangt deze zoekvelden.',
        'CustomerID (complex search)' => '',
        '(e. g. 234*)' => '',
        'CustomerID (exact match)' => '',
        'Customer User Login (complex search)' => '',
        '(e. g. U51*)' => '',
        'Customer User Login (exact match)' => '',
        'Attachment Name' => 'Bijlage Naam',
        '(e. g. m*file or myfi*)' => '(b.v. m*bestand of mijnbe*)',
        'Created in Queue' => 'Aangemaakt in wachtrij',
        'Lock state' => 'Vergrendeling',
        'Watcher' => 'Volger',
        'Article Create Time (before/after)' => 'Aanmaaktijd interactie (voor/na)',
        'Article Create Time (between)' => 'Aanmaaktijd interactie (tussen)',
        'Invalid date' => '',
        'Ticket Create Time (before/after)' => 'Aanmaaktijd ticket (voor/na)',
        'Ticket Create Time (between)' => 'Aanmaaktijd ticket (tussen)',
        'Ticket Change Time (before/after)' => 'Ticket gewijzigd (voor/na)',
        'Ticket Change Time (between)' => 'Ticket gewijzigd (tussen)',
        'Ticket Last Change Time (before/after)' => 'Meest recente ticket wijziging (voor/na)',
        'Ticket Last Change Time (between)' => 'Meest recente ticket wijziging (tussen)',
        'Ticket Close Time (before/after)' => 'Ticket gesloten (voor/na)',
        'Ticket Close Time (between)' => 'Ticket gesloten (tussen)',
        'Ticket Escalation Time (before/after)' => 'Ticket escalatietijd (voor/na)',
        'Ticket Escalation Time (between)' => 'Ticket escaltietijd (tussen)',
        'Archive Search' => 'Zoek in archief',
        'Run search' => 'Voer zoekopdracht uit',

        # Template: AgentTicketZoom
        'Article filter' => 'Filter interacties',
        'Article Type' => 'Soort interactie',
        'Sender Type' => 'Soort verzender',
        'Save filter settings as default' => 'Sla filter op als standaard',
        'Event Type Filter' => 'Gebeurtenis type filter',
        'Event Type' => 'Gebeurtenis type',
        'Save as default' => 'Opslaan als standaard',
        'Archive' => 'Archief',
        'This ticket is archived.' => 'Dit ticket is gearchiveerd.',
        'Note: Type is invalid!' => 'Let op: Type is ongeldig!',
        'Locked' => 'Vergrendeling',
        'Accounted time' => 'Bestede tijd',
        'Linked Objects' => 'Gekoppelde objecten',
        'Change Queue' => 'Wijzig wachtrij',
        'There are no dialogs available at this point in the process.' =>
            'Op dit moment zijn er geen dialogen beschikbaar.',
        'This item has no articles yet.' => 'Dit item heeft nog geen interacties.',
        'Ticket Timeline View' => 'Ticket tijdslijn weergave',
        'Article Overview' => 'Artikel overzicht',
        'Article(s)' => 'Interactie(s)',
        'Page' => 'Pagina',
        'Add Filter' => 'Nieuw filter',
        'Set' => 'Nieuwe waarden',
        'Reset Filter' => 'Herstel filter',
        'Show one article' => 'Toon één interactie',
        'Show all articles' => 'Toon alle interacties',
        'Show Ticket Timeline View' => 'Geef ticket tijdslijn weer',
        'Unread articles' => 'Ongelezen interacties',
        'No.' => 'Nr.',
        'Important' => 'Belangrijk',
        'Unread Article!' => 'Ongelezen interactie.',
        'Incoming message' => 'Binnenkomend bericht',
        'Outgoing message' => 'Uitgaand bericht',
        'Internal message' => 'Intern bericht',
        'Resize' => 'Grootte wijzigen',
        'Mark this article as read' => 'Markeer het artikel als gelezen',
        'Show Full Text' => 'Geef volledige tekst weer',
        'Full Article Text' => 'Volledige artikel tekst',
        'No more events found. Please try changing the filter settings.' =>
            'Geen events meer gevonden. Probeer de filter instellingen aan te passen.',
        'by' => 'door',
        'To open links in the following article, you might need to press Ctrl or Cmd or Shift key while clicking the link (depending on your browser and OS).' =>
            'Om links te openen in het volgende artikel, kan het nodig zijn om de toetsen Ctrl of Cmd of Shift in te druken terwijl je op de link klikt (afhankelijk van jouw browser en besturingssysteem)',
        'Close this message' => 'Sluit dit bericht',
        'Article could not be opened! Perhaps it is on another article page?' =>
            'Het artikel kan niet worden geopend! Mogelijk staat hij op een andere artikelpagina?',

        # Template: AttachmentBlocker
        'To protect your privacy, remote content was blocked.' => 'Om uw privacy te beschermen is actieve inhoud geblokkeerd.',
        'Load blocked content.' => 'Laad actieve inhoud.',

        # Template: ChatStartForm
        'First message' => 'Eerste bericht',

        # Template: CloudServicesDisabled
        'This feature requires cloud services.' => 'Deze feature vereist cloud services',
        'You can' => 'U kunt',
        'go back to the previous page' => 'terug naar de vorige pagina',

        # Template: CustomerAccept
        'Information' => 'Informatie',
        'Dear Customer,' => '',
        'thank you for using our services.' => '',
        'Yes, I accepted your license.' => '',

        # Template: CustomerError
        'An Error Occurred' => '',
        'Error Details' => 'Error gegevens',
        'Traceback' => 'Traceback',

        # Template: CustomerFooter
        'Powered by' => 'Draait op',

        # Template: CustomerFooterJS
        'One or more errors occurred!' => 'Een of meerdere problemen zijn opgetreden.',
        'Close this dialog' => 'Sluit venster',
        'Could not open popup window. Please disable any popup blockers for this application.' =>
            'Kan geen popup openen. Schakel popup blockers uit voor deze website.',
        'If you now leave this page, all open popup windows will be closed, too!' =>
            'Als u deze pagina verlaat worden alle openstaande popup-vensters ook gesloten.',
        'A popup of this screen is already open. Do you want to close it and load this one instead?' =>
            'Er is al een popup open voor dit ticket. Wilt u deze sluiten en de nieuwe laden?',
        'There are currently no elements available to select from.' => 'Er zijn nu geen elementen beschikbaar om te kiezen.',
        'Please turn off Compatibility Mode in Internet Explorer!' => 'Zet a.u.b. Compatibility Mode in Internet Explorer uit!',
        'The browser you are using is too old.' => 'De browser die u gebruikt is te oud.',
        'OTRS runs with a huge lists of browsers, please upgrade to one of these.' =>
            'OTRS kan overweg met een grote hoeveelheid browsers. Gebruik s.v.p een van deze.',
        'Please see the documentation or ask your admin for further information.' =>
            'Zie de documentatie of vraag uw beheerder voor meer informatie.',
        'Switch to mobile mode' => 'Omschakelen naar weergave voor telefoons / tablets',
        'Switch to desktop mode' => 'Omschakelen naar desktop weergave',
        'Not available' => 'Niet beschikbaar',
        'Clear all' => 'Alles weghalen',
        'Clear search' => 'Verwijder zoekactie',
        '%s selection(s)...' => '%s selectie(s)...',
        'and %s more...' => 'en nog %s meer...',
        'Filters' => 'Filters',
        'Confirm' => 'Bevestigen',
        'You have unanswered chat requests' => 'Je hebt onbeantwoorden chat verzoeken',
        'Accept' => '',
        'Decline' => '',
        'An internal error occurred.' => '',
        'Connection error' => '',
        'Reload page' => '',
        'Your browser was not able to communicate with OTRS properly, there seems to be something wrong with your network connection. You could either try reloading this page manually or wait until your browser has re-established the connection on its own.' =>
            '',
        'There was an error in communication with the server. Server might be experiencing some temporary problems, please reload this page to check if they have been resolved.' =>
            '',
        'The connection has been re-established after a temporary connection loss. Due to this, elements on this page could have stopped to work correctly. In order to be able to use all elements correctly again, it is strongly recommended to reload this page.' =>
            '',

        # Template: CustomerLogin
        'JavaScript Not Available' => 'JavaScript niet beschikbaar',
        'In order to experience OTRS, you\'ll need to enable JavaScript in your browser.' =>
            'Om OTRS te kunnen gebruiken, moet JavaScript geactiveerd zijn in uw browser.',
        'Browser Warning' => 'Waarschuwing',
        'One moment please, you are being redirected...' => 'Een moment alstublieft, je wordt doorverwezen',
        'Login' => 'Inloggen',
        'User name' => 'Gebruikersnaam',
        'Your user name' => 'Uw gebruikersnaam',
        'Your password' => 'Uw wachtwoord',
        'Forgot password?' => 'Wachtwoord vergeten?',
        '2 Factor Token' => '2 factor eken',
        'Your 2 Factor Token' => 'Jouw 2 factor teken',
        'Log In' => 'Inloggen',
        'Not yet registered?' => 'Nog niet geregistreerd?',
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
        'Incoming Chat Requests' => 'Binnenkomende Chat Verzoeken',
        'Edit personal preferences' => 'Voorkeuren bewerken',
        'Logout %s %s' => 'Uitloggen %s %s',

        # Template: CustomerRichTextEditor
        'Split Quote' => 'Splits quote',
        'Open link' => '',

        # Template: CustomerTicketMessage
        'Service level agreement' => 'Service level agreement',

        # Template: CustomerTicketOverview
        'Welcome!' => 'Welkom!',
        'Please click the button below to create your first ticket.' => 'Klik op de button om uw eerste ticket aan te maken.',
        'Create your first ticket' => 'Maak uw eerste ticket aan',

        # Template: CustomerTicketSearch
        'Profile' => 'Sjabloon',
        'e. g. 10*5155 or 105658*' => 'bijv. 2010*5155 of 20100802*',
        'Customer ID' => 'Klant ID',
        'Fulltext search in tickets (e. g. "John*n" or "Will*")' => 'Zoeken in tekst in tickets (bijv. "Jans*en" of "Print*")',
        'Recipient' => 'Geadresseerde',
        'Carbon Copy' => 'CC',
        'e. g. m*file or myfi*' => 'b.v. m*bestand of mijnbe*',
        'Types' => 'Typen',
        'Time restrictions' => 'Tijd',
        'No time settings' => 'Niet zoeken op tijd',
        'Specific date' => 'Specifieke datum',
        'Only tickets created' => 'Alleen tickets aangemaakt',
        'Date range' => 'Datum range',
        'Only tickets created between' => 'Alleen tickets aangemaakt tussen',
        'Ticket archive system' => 'Ticket-archief',
        'Save search as template?' => 'Bewaar zoekopdracht als sjabloon?',
        'Save as Template?' => 'Bewaar als sjabloon?',
        'Save as Template' => 'Bewaar',
        'Template Name' => 'Template naam',
        'Pick a profile name' => 'Naam voor dit sjabloon',
        'Output to' => 'Uitvoer naar',

        # Template: CustomerTicketSearchResultShort
        'of' => 'van',
        'Search Results for' => 'Zoekresultaat voor',
        'Remove this Search Term.' => 'Verwijder deze zoekterm',

        # Template: CustomerTicketZoom
        'Start a chat from this ticket' => 'Begin een chat vanuit dit ticket',
        'Expand article' => 'Toon interactie',
        'Next Steps' => 'Volgende stappen',
        'Reply' => 'Beantwoord',
        'Chat Protocol' => 'Chat Protocol',

        # Template: DashboardEventsTicketCalendar
        'All-day' => 'de gehele dag',
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
        'Event Information' => 'Event informatie',
        'Ticket fields' => 'Ticket-velden',
        'Dynamic fields' => 'Dynamische velden',

        # Template: Datepicker
        'Invalid date (need a future date)!' => 'Ongeldig (datum kan niet in verleden zijn).',
        'Invalid date (need a past date)!' => 'Ongeldige datum (heb een datum in het verleden nodig!)',
        'Previous' => 'Vorige',
        'Open date selection' => 'Open datumkiezer',

        # Template: Error
        'An error occurred.' => 'Er is een fout opgetreden',
        'Really a bug? 5 out of 10 bug reports result from a wrong or incomplete installation of OTRS.' =>
            'Is dit echt een fout? 5 van de 10 error reports zijn vanwege een kappotte installatie van OTRS',
        'With %s, our experts take care of correct installation and cover your back with support and periodic security updates.' =>
            '',
        'Contact our service team now.' => '',
        'Send a bugreport' => 'Een bug report indienen',

        # Template: FooterJS
        'Please enter at least one search value or * to find anything.' =>
            'Geef één of meerdere tekens of een wildcard als * op om een zoekopdracht uit te voeren.',
        'Please remove the following words from your search as they cannot be searched for:' =>
            'Verwijder de volgende woorden van je zoekactie omdat daar niet op gezocht kan worden:',
        'Please check the fields marked as red for valid inputs.' => 'Bekijk de waarden in de als rood gemarkeerde velden.',
        'Please perform a spell check on the the text first.' => 'Voer eerst een spellingscontrole uit op de tekst.',
        'Slide the navigation bar' => 'Schuif de navigaiebalk',
        'Unavailable for chat' => 'Onbeschikbaar voor de chat',
        'Available for internal chats only' => 'Alleen beschikbaar voor interne chats',
        'Available for chats' => 'Beschikbaar voor chats',
        'Please visit the chat manager' => 'Neem contact op met de chat beheerder',
        'New personal chat request' => 'Nieuw persoonlijk chat verzoek',
        'New customer chat request' => 'Nieuwe klant chat verzoek',
        'New public chat request' => 'Nieuw publiek chat verzoek',
        'Selected user is not available for chat.' => '',
        'New activity' => 'Nieuwe activiteit',
        'New activity on one of your monitored chats.' => 'Nieuwe activiteit op een van de door jou gemonitorde chats',
        'Your browser does not support video and audio calling.' => '',
        'Selected user is not available for video and audio call.' => '',
        'Target user\'s browser does not support video and audio calling.' =>
            '',
        'Do you really want to continue?' => 'Weet je zeker dat je door wil gaan?',
        'Information about the OTRS Daemon' => 'Informatie over de OTRS Daemon',
        'Communication error' => '',
        'This feature is part of the %s.  Please contact us at %s for an upgrade.' =>
            'Deze feature is onderdeel van het %s. Neem contact met ons op via %s voor een upgrade',
        'Find out more about the %s' => 'Vind meer informatie over het %s',

        # Template: Header
        'You are logged in as' => 'Ingelogd als',

        # Template: Installer
        'JavaScript not available' => 'JavaScript is niet beschikbaar',
        'Step %s' => 'Stap %s',
        'Database Settings' => 'Database configuratie',
        'General Specifications and Mail Settings' => 'Algemene instellingen en mailconfiguratie',
        'Finish' => 'Voltooien',
        'Welcome to %s' => 'Welkom bij %s',
        'Germany' => '',
        'United States' => '',
        'Mexico' => '',
        'Hungary' => '',
        'Brazil' => '',
        'Singapore' => '',
        'Hong Kong' => '',
        'Web site' => 'Website',
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

        # Template: InstallerDBResult
        'Database setup successful!' => 'Database-installatie afgerond.',

        # Template: InstallerDBStart
        'Install Type' => 'Installatie-type',
        'Create a new database for OTRS' => 'Maak een nieuwe database voor OTRS aan',
        'Use an existing database for OTRS' => 'Gebruik een bestaande database voor OTRS',

        # Template: InstallerDBmssql
        'Database name' => 'Database-naam',
        'Check database settings' => 'Test database instellingen',
        'Result of database check' => 'Resultaat van database test',
        'Database check successful.' => 'Database controle gelukt.',
        'Database User' => 'Database-gebruiker',
        'New' => 'Nieuw',
        'A new database user with limited permissions will be created for this OTRS system.' =>
            'Een nieuwe database gebruiker met beperkte permissies wordt aangemaakt voor deze OTRS omgeving.',
        'Repeat Password' => 'Herhaal wachtwoord',
        'Generated password' => 'Gegenereerd wachtwoord',

        # Template: InstallerDBmysql
        'Passwords do not match' => 'Wachtwoorden komen niet overeen',

        # Template: InstallerDBoracle
        'SID' => 'SID',
        'Port' => 'Poort',

        # Template: InstallerFinish
        'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' =>
            'Om OTRS te gebruiken moet u nu de webserver herstarten.',
        'Restart your webserver' => 'Herstart webserver',
        'After doing so your OTRS is up and running.' => 'Hierna is OTRS klaar voor gebruik.',
        'Start page' => 'Inlogpagina',
        'Your OTRS Team' => 'Het OTRS team',

        # Template: InstallerLicense
        'Don\'t accept license' => 'Licentie niet accepteren',
        'Accept license and continue' => 'Accepteer licentie en ga door',

        # Template: InstallerSystem
        'SystemID' => 'Systeem identificatie',
        'The identifier of the system. Each ticket number and each HTTP session ID contain this number.' =>
            'De identifier van het systeem. Ieder ticketnummer en elk HTTP sessie ID bevat dit nummer.',
        'System FQDN' => 'OTRS FQDN',
        'Fully qualified domain name of your system.' => 'Fully Qualified Domain Name van het systeem.',
        'AdminEmail' => 'E-mailadres beheerder',
        'Email address of the system administrator.' => 'E-mailadres van de beheerder.',
        'Organization' => 'Organisatie',
        'Log' => 'Log',
        'LogModule' => 'Logmodule',
        'Log backend to use.' => 'Te gebruiken logbestand.',
        'LogFile' => 'Logbestand',
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

        # Template: MetaFloater
        'Scale preview content' => '',
        'Open URL in new tab' => '',
        'Close preview' => '',
        'A preview of this website can\'t be provided because it didn\'t allow to be embedded.' =>
            'Een preview is niet beschikbaar omdat het geen embedding toestaat. ',

        # Template: MobileNotAvailableWidget
        'Feature not available' => 'Functionaliteit niet beschikbaar',
        'Sorry, but this feature of OTRS is currently not available for mobile devices. If you\'d like to use it, you can either switch to desktop mode or use your regular desktop device.' =>
            'Helaas, maar deze functionaliteit van OTRS is op dit moment niet beschikbaar voor mobiele apparaten. Als je de functionaliteit toch wil gebruiken kun je swichen naar desktop weergave of je desktop device gebruiken.',

        # Template: Motd
        'Message of the Day' => 'Bericht van de dag',
        'This is the message of the day. You can edit this in %s.' => '',

        # Template: NoPermission
        'Insufficient Rights' => 'Onvoldoende permissies',
        'Back to the previous page' => 'Terug naar de vorige pagina',

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

        # Template: PreferencesNotificationEvent
        'Notification' => 'Melding',
        'No user configurable notifications found.' => 'Door de eindgebruiker instelbare notificaties gevonden.',
        'Receive messages for notification \'%s\' by transport method \'%s\'.' =>
            'Ontvang berichten voor notificatie \'%s\' via transport methode \'%s\'.',
        'Please note that you can\'t completely disable notifications marked as mandatory.' =>
            'Let op dat je verplichte notificaties niet volledig uit kun zetten.',
        'Sorry, but you can\'t disable all methods for notifications marked as mandatory.' =>
            'Helaas, maar je kun niet alle methoden voor notificatie markeren als verplicht.',
        'Sorry, but you can\'t disable all methods for this notification.' =>
            'Helaas is het niet mogelijk om alle methodes voor deze notificatie uit te zetten.',

        # Template: ActivityDialogHeader
        'Process Information' => 'Procesinformatie',
        'Dialog' => 'Dialoog',

        # Template: Article
        'Inform Agent' => 'Informeer behandelaar',

        # Template: PublicDefault
        'Welcome' => 'Wekom',
        'This is the default public interface of OTRS! There was no action parameter given.' =>
            '',
        'You could install a custom public module (via the package manager), for example the FAQ module, which has a public interface.' =>
            '',

        # Template: RichTextEditor
        'Remove Quote' => 'Verwijder citaat',

        # Template: GeneralSpecificationsWidget
        'Permissions' => 'Permissies',
        'You can select one or more groups to define access for different agents.' =>
            'U kunt één of meerdere groepen definiëren die deze rapportage kunnen gebruiken.',
        'Result formats' => 'Resultaat formulieren',
        'The selected time periods in the statistic are time zone neutral.' =>
            'De geselecteerd tijdsperiode in de statistieken zijn tijdzone neutraal.',
        'Create summation row' => 'Voeg somrij toe',
        'Generate an additional row containing sums for all data rows.' =>
            '',
        'Create summation column' => 'Voeg somkolom toe',
        'Generate an additional column containing sums for all data columns.' =>
            '',
        'Cache results' => 'Cace resultaten',
        'Stores statistics result data in a cache to be used in subsequent views with the same configuration (requires at least one selected time field).' =>
            '',
        'Provide the statistic as a widget that agents can activate in their dashboard.' =>
            'Maak een dashboard-widget van dit rapport die behandelaars in hun dashboard kunnen activeren.',
        'Please note that enabling the dashboard widget will activate caching for this statistic in the dashboard.' =>
            'Inschakelen van de dashboard widget activeert caching voor dit rapport  in het dashboard.',
        'If set to invalid end users can not generate the stat.' => 'Als deze op ongeldig staat, kan het rapport niet gebruikt worden.',

        # Template: PreviewWidget
        'There are problems in the configuration of this statistic:' => 'Er zijn problemen met de configuratie van dit rapport:',
        'You may now configure the X-axis of your statistic.' => 'Je kun nu de X-as instellen van jouw rapport.',
        'This statistic does not provide preview data.' => 'Dit rapport geeft geen voorbeeldgegevens.',
        'Preview format:' => 'Voorbeeld format:',
        'Please note that the preview uses random data and does not consider data filters.' =>
            'De voorbeeldweergave gebruikt willekeurige gegevens en houdt geen rekening met data filters.',
        'Configure X-Axis' => 'Configureer X-As',
        'X-axis' => 'X-as',
        'Configure Y-Axis' => 'Configureer Y-As',
        'Y-axis' => 'Y-As',
        'Configure Filter' => 'Configureer filter',

        # Template: RestrictionsWidget
        'Please select only one element or turn off the button \'Fixed\'.' =>
            'Kies een element, of schakel de optie \'Statisch\' uit.',
        'Absolute period' => 'Absolute periode',
        'Between' => 'Tussen',
        'Relative period' => 'Relatieve periode',
        'The past complete %s and the current+upcoming complete %s %s' =>
            'De historische complete %s en de huidige en aankomende complete %s %s',
        'Do not allow changes to this element when the statistic is generated.' =>
            'Sta niet toe om dit element te wijzigen wanneer de statistiek wordt gegenereerd.',

        # Template: StatsParamsWidget
        'Format' => 'Formaat',
        'Exchange Axis' => 'Wissel assen',
        'Configurable params of static stat' => 'Configureerbare parameters voor rapport',
        'No element selected.' => 'Geen element geselecteerd.',
        'Scale' => 'Schaal',
        'show more' => '',
        'show less' => '',

        # Template: D3
        'Download SVG' => 'Download SVG',
        'Download PNG' => 'Download PNG',

        # Template: XAxisWidget
        'The selected time period defines the default time frame for this statistic to collect data from.' =>
            'De geselecteerde tijdsperiode bepaalt het standaard tijdsvenster voor deze statistiek om gegevens van te verzamelen.',
        'Defines the time unit that will be used to split the selected time period into reporting data points.' =>
            'Bepaalt de tijdseenheid die wordt gebruikt om de geselecteerde periode te splitsen in rapportage data punten.',

        # Template: YAxisWidget
        'Please remember that the scale for the Y-axis has to be larger than the scale for the X-axis (e.g. X-axis => Month, Y-Axis => Year).' =>
            'De schaal van de Y-as moet groter zijn dan de schaal voor de X-as (bijvoorbeeld: X-as => Maand, Y-as => Jaar).',

        # Template: Test
        'OTRS Test Page' => 'OTRS Testpagina',
        'Welcome %s %s' => 'Welkom %s %s',
        'Counter' => 'Teller',

        # Template: Warning
        'Go back to the previous page' => 'Terug naar de vorige pagina',

        # Perl Module: Kernel/Config/Defaults.pm
        'Database Backend' => '',
        'View system log messages.' => 'Bekijk het OTRS logboek.',
        'Update and extend your system with software packages.' => 'Voeg functies toe aan uw systeem door het installeren van pakketten.',

        # Perl Module: Kernel/Modules/AdminACL.pm
        'ACLs could not be Imported due to a unknown error, please check OTRS logs for more information' =>
            'ACL\'s kunnen niet worden geïmporteerd vanwege een onbekende fout, kijk in de OTRS loggegevens voor meer informatie.',
        'The following ACLs have been added successfully: %s' => 'De volgende ACL\'s zijn succesvol toegevoegd: %s',
        'The following ACLs have been updated successfully: %s' => 'De volgende ACLs zijn succesvol bijgewerkt: %s',
        'There where errors adding/updating the following ACLs: %s. Please check the log file for more information.' =>
            'Er zijn fouten opgetreden tijdens het toevoegen/bijwerken van de volgende ACLs: %s. Controleer de log bestanden voor meer informatie.',
        'This field is required' => 'Dit veld is verplicht',
        'There was an error creating the ACL' => 'Er is iets mis gegaan tijdens het bijwerken van de ACL',
        'Need ACLID!' => 'ACLID is vereist!',
        'Could not get data for ACLID %s' => 'Kon gegevens voor ACLID %s niet ophalen',
        'There was an error updating the ACL' => 'Er is een fout opgetreden bij het bijwerken van de ACL.',
        'There was an error setting the entity sync status.' => 'Er is een fout opgegeven bij het instellen van de synchronisatiestatus.',
        'There was an error synchronizing the ACLs.' => 'Er is een fout opgetreden met het synchroniseren van de ACL\'s.',
        'ACL %s could not be deleted' => 'ACL %s kon niet worden verwijderd',
        'There was an error getting data for ACL with ID %s' => 'Er is een fout opgetreden met het ophalen van de gegevens voor ACL met ID %s',
        'Exact match' => '',
        'Negated exact match' => '',
        'Regular expression' => '',
        'Regular expression (ignore case)' => '',
        'Negated regular expression' => '',
        'Negated regular expression (ignore case)' => '',

        # Perl Module: Kernel/Modules/AdminCustomerCompany.pm
        'Customer Company %s already exists!' => 'Klant Bedrijf %s bestaat al!',

        # Perl Module: Kernel/Modules/AdminCustomerUser.pm
        'New phone ticket' => 'Nieuw telefoon-ticket',
        'New email ticket' => 'Nieuw e-mail-ticket',

        # Perl Module: Kernel/Modules/AdminDynamicField.pm
        'Fields configuration is not valid' => 'Velden configuratie is niet geldig',
        'Objects configuration is not valid' => 'Object configuratie is niet geldig',
        'Could not reset Dynamic Field order properly, please check the error log for more details.' =>
            'Kon dynamische velden niet herstellen, kijk in het logbestand voor details.',

        # Perl Module: Kernel/Modules/AdminDynamicFieldCheckbox.pm
        'Undefined subaction.' => 'Ongedefinieerde subactie.',
        'Need %s' => 'Heb %s nodig',
        'The field does not contain only ASCII letters and numbers.' => 'Het veld bevat niet alleen maar ASCII letters en cijfers.',
        'There is another field with the same name.' => 'Er is een ander veld met dezelfde naam.',
        'The field must be numeric.' => 'Het veld moet numeriek zijn.',
        'Need ValidID' => 'Heb ValidID nodig',
        'Could not create the new field' => 'Het nieuwe veld kon niet worden aangemaakt',
        'Need ID' => 'Heb ID nodig',
        'Could not get data for dynamic field %s' => 'Kon de gegevens voor dynamisch veld %s niet ophalen',
        'The name for this field should not change.' => 'De naam van dit veld zou niet moeten veranderen.',
        'Could not update the field %s' => 'Het veld %s kon niet bijgewerkt worden.',
        'Currently' => 'Huidige',
        'Unchecked' => '',
        'Checked' => '',

        # Perl Module: Kernel/Modules/AdminDynamicFieldDateTime.pm
        'Prevent entry of dates in the future' => '',
        'Prevent entry of dates in the past' => '',

        # Perl Module: Kernel/Modules/AdminDynamicFieldDropdown.pm
        'This field value is duplicated.' => 'Deze veldwaarde is gedupliceerd.',

        # Perl Module: Kernel/Modules/AdminEmail.pm
        'Select at least one recipient.' => 'Selecteer minimaal één ontvanger.',

        # Perl Module: Kernel/Modules/AdminGenericAgent.pm
        'archive tickets' => '',
        'restore tickets from archive' => '',
        'Need Profile!' => '',
        'Got no values to check.' => 'Had geen waarden om te controleren',
        'Please remove the following words because they cannot be used for the ticket selection:' =>
            'Verwijder de volgende woorden omdat ze niet kunnen worden gebruikt voor het selecteren van een ticket:',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceDebugger.pm
        'Need WebserviceID!' => 'WebserviceID is vereist!',
        'Could not get data for WebserviceID %s' => 'Kon gegevens van WebserviceID %s niet ophalen',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceInvokerDefault.pm
        'Need InvokerType' => 'Heb InvokerType nodig',
        'Invoker %s is not registered' => 'Invoker %s is niet geregistreerd',
        'InvokerType %s is not registered' => '',
        'Need Invoker' => 'Heb Invoker nodig',
        'Could not determine config for invoker %s' => 'Kon configuratie voor invoker %s niet bepalen.',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceMappingSimple.pm
        'Could not get registered configuration for action type %s' => 'Het geregistreerde configuratiebestand voor actie type %s kon niet worden opgehaald',
        'Could not get backend for %s %s' => 'Backend voor %s %s kon niet worden opgehaald',
        'Could not update configuration data for WebserviceID %s' => 'Configuratiebestand kon niet worden bijgewerkt voor Webservice met ID %s',
        'Keep (leave unchanged)' => '',
        'Ignore (drop key/value pair)' => '',
        'Map to (use provided value as default)' => '',
        'Exact value(s)' => '',
        'Ignore (drop Value/value pair)' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceMappingXSLT.pm
        'Could not find required library %s' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceOperationDefault.pm
        'Need OperationType' => 'Heb OperatieType nodig',
        'Operation %s is not registered' => 'Operatie %s is niet geregistreerd',
        'OperationType %s is not registered' => 'OperatieType %s is niet geregistreerd',
        'Need Operation' => 'Heb Operatie nodig',
        'Could not determine config for operation %s' => 'Configuratiebestand kon niet bepaald worden voor operatie %s',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceTransportHTTPREST.pm
        'Need Subaction!' => 'Heb Subactie nodig!',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceWebservice.pm
        'There is another web service with the same name.' => 'Er is nog een webservice met dezelfde naam.',
        'There was an error updating the web service.' => 'Er is een fout opgetreden bij het bijwerken van de webservice.',
        'Web service "%s" updated!' => 'Webservice "%s" bijgewerkt!',
        'There was an error creating the web service.' => 'Er is een fout opgetreden bij het aanmaken van de webservice.',
        'Web service "%s" created!' => 'Webservice "%s" aangemaakt!',
        'Need Name!' => 'Heb Naam nodig!',
        'Need ExampleWebService!' => '',
        'Could not read %s!' => 'Kan %s niet lezen!',
        'Need a file to import!' => 'Heb een bestand nodig om te importeren!',
        'The imported file has not valid YAML content! Please check OTRS log for details' =>
            'Het geïmporteerde bestand is geen geldig YAML bestand! Kijk in het logbestand voor details',
        'Web service "%s" deleted!' => 'Webservice "%s" verwijderd!',
        'New Web service' => '',
        'Operations' => '',
        'Invokers' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceWebserviceHistory.pm
        'Got no WebserviceHistoryID!' => 'Heb geen WebserviceHistoryID!',
        'Could not get history data for WebserviceHistoryID %s' => '',

        # Perl Module: Kernel/Modules/AdminMailAccount.pm
        'Email account fetch already fetched by another process. Please try again later!' =>
            '',

        # Perl Module: Kernel/Modules/AdminNotificationEvent.pm
        'Notification updated!' => 'Melding bijgewerkt!',
        'Notification added!' => 'Melding toegevoegd!',
        'There was an error getting data for Notification with ID:%s!' =>
            'Er is een fout opgetreden bij het ophalen van de gegevens met ID:%s!',
        'Unknown Notification %s!' => 'Onbekende melding %s!',
        'There was an error creating the Notification' => 'Er is een fout opgetreden bij het genereren van de melding',
        'Notifications could not be Imported due to a unknown error, please check OTRS logs for more information' =>
            'Meldingen konden niet worden geïmporteerd vanwege een onbekende fout. Kijk de OTRS logbestanden na voor meer informatie.',
        'The following Notifications have been added successfully: %s' =>
            'De volgende melding is succesvol toegevoegd: %s',
        'The following Notifications have been updated successfully: %s' =>
            'De volgende melding is succesvol bijgewerkt: %s',
        'There where errors adding/updating the following Notifications: %s. Please check the log file for more information.' =>
            'Er zijn fouten opgetreden bij het toevoegen/aanpassen van de volgende melding: %s. Kijk de OTRS logbestanden na voor meer informatie.',
        'Agent who owns the ticket' => 'Eigenaar van het ticket',
        'Agent who is responsible for the ticket' => 'Verantwoordelijke voor het ticket',
        'All agents watching the ticket' => 'Alle agent die het ticket in de gaten houden',
        'All agents with write permission for the ticket' => 'Alle agents met schrijf rechten voor het ticket',
        'All agents subscribed to the ticket\'s queue' => 'Alle agents die zich hebben ingeschreven op de wachtrij',
        'All agents subscribed to the ticket\'s service' => 'Alle agents die zich hebben ingeschreven op de service',
        'All agents subscribed to both the ticket\'s queue and service' =>
            'Alle agents die zich zowel op de wachtrij, als op de service hebben ingeschreven',
        'Customer of the ticket' => 'Klant van het ticket',
        'Yes, but require at least one active notification method.' => 'Ja, maar er is minimaal één actieve melding methode nodig.',

        # Perl Module: Kernel/Modules/AdminPGP.pm
        'PGP environment is not working. Please check log for more info!' =>
            '',
        'Need param Key to delete!' => 'Heb param Sleutel nodig om te verwijderen!',
        'Key %s deleted!' => 'Sleutel %s is verwijderd!',
        'Need param Key to download!' => 'Heb param Sleutel nodig om te downloaden!',

        # Perl Module: Kernel/Modules/AdminPackageManager.pm
        'Sorry, Apache::Reload is needed as PerlModule and PerlInitHandler in Apache config file. See also scripts/apache2-httpd.include.conf. Alternatively, you can use the command line tool bin/otrs.Console.pl to install packages!' =>
            '',
        'No such package!' => 'Pakket bestaat niet.',
        'No such file %s in package!' => 'Geen bestand %s in pakket!',
        'No such file %s in local file system!' => 'Geen bestand %s in bestandssysteem!',
        'Can\'t read %s!' => 'Kan %s niet lezen!',
        'File is OK' => '',
        'Package has locally modified files.' => 'Pakket heeft lokaal bewerkte bestanden.',
        'No packages or no new packages found in selected repository.' =>
            'Geen pakketten of nieuwe pakketten gevonden in de geselecteerde repository.',
        'Package not verified due a communication issue with verification server!' =>
            'Pakket niet gecontroleerd vanwege een communicatiefout met de server!',
        'Can\'t connect to OTRS Feature Add-on list server!' => '',
        'Can\'t get OTRS Feature Add-on list from server!' => '',
        'Can\'t get OTRS Feature Add-on from server!' => '',

        # Perl Module: Kernel/Modules/AdminPostMasterFilter.pm
        'No such filter: %s' => 'Filter %s bestaat niet',

        # Perl Module: Kernel/Modules/AdminProcessManagement.pm
        'Need ExampleProcesses!' => '',
        'Need ProcessID!' => '',
        'Yes (mandatory)' => '',
        'Unknown Process %s!' => '',
        'There was an error generating a new EntityID for this Process' =>
            '',
        'The StateEntityID for state Inactive does not exists' => '',
        'There was an error creating the Process' => '',
        'There was an error setting the entity sync status for Process entity: %s' =>
            '',
        'Could not get data for ProcessID %s' => '',
        'There was an error updating the Process' => '',
        'Process: %s could not be deleted' => '',
        'There was an error synchronizing the processes.' => '',
        'The %s:%s is still in use' => '',
        'The %s:%s has a different EntityID' => '',
        'Could not delete %s:%s' => '',
        'There was an error setting the entity sync status for %s entity: %s' =>
            '',
        'Could not get %s' => '',
        'Need %s!' => 'Heb %s nodig!',
        'Process: %s is not Inactive' => '',

        # Perl Module: Kernel/Modules/AdminProcessManagementActivity.pm
        'There was an error generating a new EntityID for this Activity' =>
            'Er is een fout opgetreden met het genereren van een nieuwe EntityID voor deze Activiteit',
        'There was an error creating the Activity' => 'Er is een fout opgetreden bij het aanmaken van de activiteit',
        'There was an error setting the entity sync status for Activity entity: %s' =>
            'Er is een fout opgetreden bij het instellen van de synchronisatie status van de activiteit: %s',
        'Need ActivityID!' => 'Heb ActivityID nodig!',
        'Could not get data for ActivityID %s' => 'Kan gegevens niet ophalen van ActivityID %s',
        'There was an error updating the Activity' => 'Er is een fout opgetreden tijdens het bijwerken van de activiteit.',
        'Missing Parameter: Need Activity and ActivityDialog!' => 'Ontbrekende parameter: Heb Activiteit en ActiviteitDialoog nodig!',
        'Activity not found!' => 'Activiteit niet gevonden!',
        'ActivityDialog not found!' => 'ActiviteitDialoog niet gevonden',
        'ActivityDialog already assigned to Activity. You cannot add an ActivityDialog twice!' =>
            'ActiviteitDialoog al toegewezen aan Activiteit. Je kunt een ActiviteitDialoog niet twee keer toevoegen!',
        'Error while saving the Activity to the database!' => 'Fout bij het opslaan van de Activiteit in de database!',
        'This subaction is not valid' => 'Deze subactie is niet geldig',
        'Edit Activity "%s"' => '',

        # Perl Module: Kernel/Modules/AdminProcessManagementActivityDialog.pm
        'There was an error generating a new EntityID for this ActivityDialog' =>
            '',
        'There was an error creating the ActivityDialog' => '',
        'There was an error setting the entity sync status for ActivityDialog entity: %s' =>
            'Er is een fout opgetreden bij het instellen van de synchronisatiestatus van ActiviteitDialoog item: %s',
        'Need ActivityDialogID!' => '',
        'Could not get data for ActivityDialogID %s' => 'Gegevens van ActiviteitDialoogID %s konden niet worden opgehaald',
        'There was an error updating the ActivityDialog' => '',
        'Edit Activity Dialog "%s"' => '',
        'Agent Interface' => '',
        'Customer Interface' => '',
        'Agent and Customer Interface' => '',
        'Do not show Field' => '',
        'Show Field' => '',
        'Show Field As Mandatory' => '',
        'fax' => 'fax',

        # Perl Module: Kernel/Modules/AdminProcessManagementPath.pm
        'Edit Path' => '',

        # Perl Module: Kernel/Modules/AdminProcessManagementTransition.pm
        'There was an error generating a new EntityID for this Transition' =>
            'Er is een fout opgetreden bij het genereren van een nieuwe EntiteitID voor deze transitie',
        'There was an error creating the Transition' => 'Er is een fout opgetreden bij het aanmaken van de Transitie',
        'There was an error setting the entity sync status for Transition entity: %s' =>
            'Er is een fout opgetreden bij het instellen van de syncrhonisatie status van Transiti: %s',
        'Need TransitionID!' => 'Heb TranistieID nodig!',
        'Could not get data for TransitionID %s' => 'Kon gegevens voor TansitiID %s niet ophalen',
        'There was an error updating the Transition' => 'Er is een fout opgetreden bij het bijwerken van de Transitie',
        'Edit Transition "%s"' => '',
        'xor' => '',
        'String' => '',
        'Transition validation module' => '',

        # Perl Module: Kernel/Modules/AdminProcessManagementTransitionAction.pm
        'At least one valid config parameter is required.' => 'Minimaal één geldige configuratie parameter is vereist',
        'There was an error generating a new EntityID for this TransitionAction' =>
            'Er is een fout opgetreden bij het genereren van een nieuwe EntiteitID voor deze TransactieActie',
        'There was an error creating the TransitionAction' => 'Er is een fout opgetreden bij het aanmaken van de TransactieActie',
        'There was an error setting the entity sync status for TransitionAction entity: %s' =>
            'Er is een fout opgetreden bij het instellen van de entiteit synchronisatie status voor de TransactieActie:%s',
        'Need TransitionActionID!' => 'TransacActieID is vereist!',
        'Could not get data for TransitionActionID %s' => 'Kon gegevens van TransactieActieID %s niet ophalen',
        'There was an error updating the TransitionAction' => 'Er is een fout opgetreden tijdens het bijwerken van TransitieActie',
        'Edit Transition Action "%s"' => '',
        'Error: Not all keys seem to have values or vice versa.' => 'Fout: Niet alle sleutels hebben waarden of vice versa.',

        # Perl Module: Kernel/Modules/AdminQueue.pm
        'Don\'t use :: in queue name!' => '',
        'Click back and change it!' => '',

        # Perl Module: Kernel/Modules/AdminQueueAutoResponse.pm
        'Queues ( without auto responses )' => 'Wachtrijen (zonder automatische antwoorden)',

        # Perl Module: Kernel/Modules/AdminRegistration.pm
        'Production' => 'Produktie',
        'Test' => '',
        'Training' => 'Training',
        'Development' => 'Ontwikkeling',

        # Perl Module: Kernel/Modules/AdminRoleUser.pm
        'Role' => 'Rol',

        # Perl Module: Kernel/Modules/AdminSMIME.pm
        'S/MIME environment is not working. Please check log for more info!' =>
            'S/MIME omgeving werkt niet. Zie logbestand voor meer informatie!',
        'Need param Filename to delete!' => 'Heb parameter Bestandsnaam nodig om te verwijderen!',
        'Need param Filename to download!' => 'Heb parameter Bestandsnaam nodig om te downloaden',
        'Needed CertFingerprint and CAFingerprint!' => 'Heb CertFingerprint en CAFingerprint nodig!',
        'CAFingerprint must be different than CertFingerprint' => 'CAFingerbrint moet anders zijn dan CertFingerprint',
        'Relation exists!' => 'Relatie bestaat al!',
        'Relation added!' => 'Relatie toegevoegd!',
        'Impossible to add relation!' => 'Niet mogelijk de relatie toe te voegen!',
        'Relation doesn\'t exists' => 'Relatie bestaat niet',
        'Relation deleted!' => 'Relatie verwijderd!',
        'Impossible to delete relation!' => 'Niet mogelijk de relatie te verwijderen!',
        'Certificate %s could not be read!' => 'Certificaat %s kon niet worden gelezen!',
        'Needed Fingerprint' => 'Vingerafdruk is benodigd',

        # Perl Module: Kernel/Modules/AdminSalutation.pm
        'Salutation updated!' => '',
        'Salutation added!' => 'Aanhef toegevoegd!',

        # Perl Module: Kernel/Modules/AdminSupportDataCollector.pm
        'File %s could not be read!' => 'Bestand %skan niet worden gelezen!',

        # Perl Module: Kernel/Modules/AdminSysConfig.pm
        'Import not allowed!' => 'Importeren is niet toegestaan!',
        'Need File!' => 'Heb bestand nodig!',
        'Can\'t write ConfigItem!' => 'Kan configuratie item niet schrijven!',
        '-new-' => '',

        # Perl Module: Kernel/Modules/AdminSystemMaintenance.pm
        'Start date shouldn\'t be defined after Stop date!' => 'Begindatum moet vóór de einddatum liggen!',
        'There was an error creating the System Maintenance' => 'Er is een fout opgetreden bij het aanmaken van het systeem onderhoudsvenster',
        'Need SystemMaintenanceID!' => 'Heb een SysteemOnderhoudsID nodig!',
        'Could not get data for SystemMaintenanceID %s' => 'Kon gegevens voor SystemOnderhoudID %s niet ophalen',
        'System Maintenance was saved successfully!' => 'Systeem Onderhoud is succesvol opgeslagen!',
        'Session has been killed!' => 'Sessie is beëindigd!',
        'All sessions have been killed, except for your own.' => 'Alle sessies zijn beëindigd behalve die van uzelf.',
        'There was an error updating the System Maintenance' => 'Er is een fout opgetreden bij het update van het Systeem Onderhoudsvenster',
        'Was not possible to delete the SystemMaintenance entry: %s!' => 'Het was niet mogelijk om het Systeem Onderhoudsvenster %s te verwijderen!',

        # Perl Module: Kernel/Modules/AdminTemplate.pm
        'Template updated!' => 'Sjabloon bijgewerkt!',
        'Template added!' => 'Sjabloon toegevoegd!',

        # Perl Module: Kernel/Modules/AdminType.pm
        'Need Type!' => 'Heb Type nodig!',

        # Perl Module: Kernel/Modules/AgentDashboardCommon.pm
        'No such config for %s' => 'Geen configuratie gevonden voor %s',
        'Statistic' => 'Rapportage',
        'No preferences for %s!' => 'Geen voorkeuren voor %s',
        'Can\'t get element data of %s!' => 'Kan element gegevens van %s niet ophalen!',
        'Can\'t get filter content data of %s!' => 'Kan filter gegevens van %s niet ophalen!',
        'Customer Company Name' => '',
        'Customer User ID' => '',

        # Perl Module: Kernel/Modules/AgentLinkObject.pm
        'Need SourceObject and SourceKey!' => '',
        'Please contact the administrator.' => '',
        'You need ro permission!' => 'Je hebt ro rechten nodig!',
        'Can not delete link with %s!' => 'Kan relatie met %s niet verwijderen!',
        'Can not create link with %s! Object already linked as %s.' => '',
        'Can not create link with %s!' => 'Kan relatie met %s niet aanmaken!',
        'The object %s cannot link with other object!' => '',

        # Perl Module: Kernel/Modules/AgentPreferences.pm
        'Param Group is required!' => 'Parameter groep is vereist!',

        # Perl Module: Kernel/Modules/AgentStatistics.pm
        'Parameter %s is missing.' => '',
        'Invalid Subaction.' => 'Ongeldige subactie.',
        'Statistic could not be imported.' => 'Rapport kon niet worden geïmporteerd.',
        'Please upload a valid statistic file.' => 'Upload een geldig rapportage bestand.',
        'Export: Need StatID!' => 'Exporteren: Heb geen StatID!',
        'Delete: Get no StatID!' => 'Verwijderen: Heb geen StatID!',
        'Need StatID!' => 'Heb geen StatID!',
        'Could not load stat.' => 'Kon rapportage niet laden',
        'Could not create statistic.' => 'Kon rapportage niet aanmaken.',
        'Run: Get no %s!' => 'Uitvoeren: heb geen %s!',

        # Perl Module: Kernel/Modules/AgentTicketActionCommon.pm
        'No TicketID is given!' => 'Heb geen TicketID!',
        'You need %s permissions!' => 'Je hebt %s permissies nodig!',
        'Could not perform validation on field %s!' => 'Kan validatie op veld %s niet uitvoeren!',
        'No subject' => 'Geen onderwerp',
        'Previous Owner' => 'Vorige eigenaar',

        # Perl Module: Kernel/Modules/AgentTicketBounce.pm
        '%s is needed!' => '%s is vereist!',
        'Plain article not found for article %s!' => 'Volledige artikel niet gevonden voor artikel %s!',
        'Article does not belong to ticket %s!' => 'Artikel hoort niet bij ticket %s!',
        'Can\'t bounce email!' => '',
        'Can\'t send email!' => '',
        'Wrong Subaction!' => '',

        # Perl Module: Kernel/Modules/AgentTicketBulk.pm
        'Can\'t lock Tickets, no TicketIDs are given!' => '',
        'Ticket (%s) is not unlocked!' => '',
        'Bulk feature is not enabled!' => '',
        'No selectable TicketID is given!' => '',
        'You either selected no ticket or only tickets which are locked by other agents.' =>
            '',
        'You need to select at least one ticket.' => '',
        'The following tickets were ignored because they are locked by another agent or you don\'t have write access to these tickets: %s.' =>
            '',
        'The following tickets were locked: %s.' => '',

        # Perl Module: Kernel/Modules/AgentTicketCompose.pm
        'Can not determine the ArticleType!' => '',

        # Perl Module: Kernel/Modules/AgentTicketEmail.pm
        'No Subaction!' => '',

        # Perl Module: Kernel/Modules/AgentTicketEmailOutbound.pm
        'Got no TicketID!' => '',
        'System Error!' => '',

        # Perl Module: Kernel/Modules/AgentTicketEscalationView.pm
        'Invalid Filter: %s!' => '',

        # Perl Module: Kernel/Modules/AgentTicketHistory.pm
        'Can\'t show history, no TicketID is given!' => '',

        # Perl Module: Kernel/Modules/AgentTicketLock.pm
        'Can\'t lock Ticket, no TicketID is given!' => '',
        'Sorry, the current owner is %s!' => '',
        'Please become the owner first.' => '',
        'Ticket (ID=%s) is locked by %s!' => '',
        'Change the owner!' => '',

        # Perl Module: Kernel/Modules/AgentTicketMerge.pm
        'Can\'t merge ticket with itself!' => 'Kan een ticket niet samenvoegen met zichzelf!',

        # Perl Module: Kernel/Modules/AgentTicketMove.pm
        'You need move permissions!' => '',

        # Perl Module: Kernel/Modules/AgentTicketPhone.pm
        'Chat is not active.' => '',
        'No permission.' => '',
        '%s has left the chat.' => '%s heeft de chat verlaten.',
        'This chat has been closed and will be removed in %s hours.' => 'Deze chat is gesloten en wordt in %s uren verwijderd.',

        # Perl Module: Kernel/Modules/AgentTicketPlain.pm
        'No ArticleID!' => '',
        'Can\'t read plain article! Maybe there is no plain email in backend! Read backend message.' =>
            '',

        # Perl Module: Kernel/Modules/AgentTicketPrint.pm
        'Need TicketID!' => 'Heb TicketID nodig!',
        'printed by' => 'afgedrukt door',
        'Ticket Dynamic Fields' => 'Ticket Dynamische Velden',

        # Perl Module: Kernel/Modules/AgentTicketProcess.pm
        'Couldn\'t get ActivityDialogEntityID "%s"!' => 'Kon ActiviteitDialoogEntiteidID "%s" niet verkrijgen!',
        'No Process configured!' => 'Geen Proces geconfigureerd!',
        'Process %s is invalid!' => 'Proces %s is ongeldig!',
        'Subaction is invalid!' => '',
        'Parameter %s is missing in %s.' => '',
        'No ActivityDialog configured for %s in _RenderAjax!' => 'Geen ActiviteitDialog geconfigureerd voor %s in _RenderAjax!',
        'Got no Start ActivityEntityID or Start ActivityDialogEntityID for Process: %s in _GetParam!' =>
            'Geen Start ActiviteitEntiteitID of Start ActiviteitDialoogEntiteitID voor Proces: %s in _GetParam!',
        'Couldn\'t get Ticket for TicketID: %s in _GetParam!' => 'Geen Ticket voor TicketID: %s in _GetParam!',
        'Couldn\'t determine ActivityEntityID. DynamicField or Config isn\'t set properly!' =>
            'Kon geen ActiviteitEntiteitID bepalen. Dynamisch veld of Configuratie is niet juist ingesteld!',
        'Process::Default%s Config Value missing!' => 'Process::Default%s Configuratie Waarde ontbreekt!',
        'Got no ProcessEntityID or TicketID and ActivityDialogEntityID!' =>
            'Heb geen ProcesEntiteitID of TicketID en ActiviteitDialoogEntiteitID!',
        'Can\'t get StartActivityDialog and StartActivityDialog for the ProcessEntityID "%s"!' =>
            'Verkreeg geen StartActiviteitDialoog en StartActiviteitDialoog voor het ProcesEntiteitID "%s"!',
        'Can\'t get Ticket "%s"!' => 'Kan ticket "%s" niet ophalen!',
        'Can\'t get ProcessEntityID or ActivityEntityID for Ticket "%s"!' =>
            'Kan ProcesEntiteitID of ActiviteitEntiteitID niet verkrijgen voor ticket "%s"!',
        'Can\'t get Activity configuration for ActivityEntityID "%s"!' =>
            '',
        'Can\'t get ActivityDialog configuration for ActivityDialogEntityID "%s"!' =>
            'Kan ActiviteitDialoog configuratie voor ActiviteitDialoogEntiteitID "%s"!',
        'Can\'t get data for Field "%s" of ActivityDialog "%s"!' => 'Kan gegevens niet verkrijgen voor veld "%s" van ActiviteitDialoog "%s"!',
        'PendingTime can just be used if State or StateID is configured for the same ActivityDialog. ActivityDialog: %s!' =>
            'Wacht op tijd kan alleen gebruikt worden wanneer Status of StatusID is geconfigureerd voor dezelfde ActiviteitDialoog. ActiviteitDialoog: %s!',
        'Pending Date' => 'Wacht tot datum',
        'for pending* states' => 'voor \'wachtend op-\' statussen',
        'ActivityDialogEntityID missing!' => '',
        'Couldn\'t get Config for ActivityDialogEntityID "%s"!' => '',
        'Couldn\'t use CustomerID as an invisible field.' => '',
        'Missing ProcessEntityID, check your ActivityDialogHeader.tt!' =>
            '',
        'No StartActivityDialog or StartActivityDialog for Process "%s" configured!' =>
            '',
        'Couldn\'t create ticket for Process with ProcessEntityID "%s"!' =>
            '',
        'Couldn\'t set ProcessEntityID "%s" on TicketID "%s"!' => '',
        'Couldn\'t set ActivityEntityID "%s" on TicketID "%s"!' => '',
        'Could not store ActivityDialog, invalid TicketID: %s!' => '',
        'Invalid TicketID: %s!' => '',
        'Missing ActivityEntityID in Ticket %s!' => '',
        'This step does not belong anymore to the current activity in process for ticket \'%s%s%s\'! Another user changed this ticket in the meantime. Please close this window and reload the ticket.' =>
            '',
        'Missing ProcessEntityID in Ticket %s!' => '',
        'Could not set DynamicField value for %s of Ticket with ID "%s" in ActivityDialog "%s"!' =>
            '',
        'Could not set PendingTime for Ticket with ID "%s" in ActivityDialog "%s"!' =>
            '',
        'Wrong ActivityDialog Field config: %s can\'t be Display => 1 / Show field (Please change its configuration to be Display => 0 / Do not show field or Display => 2 / Show field as mandatory)!' =>
            '',
        'Could not set %s for Ticket with ID "%s" in ActivityDialog "%s"!' =>
            '',
        'Default Config for Process::Default%s missing!' => '',
        'Default Config for Process::Default%s invalid!' => '',

        # Perl Module: Kernel/Modules/AgentTicketSearch.pm
        'Untitled' => '',
        'Customer Name' => '',
        'Invalid Users' => 'Ongeldige gebruikers',
        'CSV' => '',
        'Excel' => '',

        # Perl Module: Kernel/Modules/AgentTicketService.pm
        'Feature not enabled!' => '',

        # Perl Module: Kernel/Modules/AgentTicketWatcher.pm
        'Feature is not active' => '',

        # Perl Module: Kernel/Modules/AgentTicketZoom.pm
        'Link Deleted' => '',
        'Ticket Locked' => '',
        'Pending Time Set' => '',
        'Dynamic Field Updated' => '',
        'Outgoing Email (internal)' => '',
        'Ticket Created' => 'Ticket aangemaakt',
        'Type Updated' => '',
        'Escalation Update Time In Effect' => '',
        'Escalation Update Time Stopped' => '',
        'Escalation First Response Time Stopped' => '',
        'Customer Updated' => '',
        'Internal Chat' => '',
        'Automatic Follow-Up Sent' => '',
        'Note Added' => '',
        'Note Added (Customer)' => '',
        'State Updated' => '',
        'Outgoing Answer' => '',
        'Service Updated' => '',
        'Link Added' => '',
        'Incoming Customer Email' => '',
        'Incoming Web Request' => '',
        'Priority Updated' => '',
        'Ticket Unlocked' => '',
        'Outgoing Email' => 'Uitgaande e-mail',
        'Title Updated' => '',
        'Ticket Merged' => '',
        'Outgoing Phone Call' => 'Uitgaand telefoongesprek',
        'Forwarded Message' => '',
        'Removed User Subscription' => '',
        'Time Accounted' => '',
        'Incoming Phone Call' => 'Inkomend telefoongesprek',
        'System Request.' => '',
        'Incoming Follow-Up' => '',
        'Automatic Reply Sent' => '',
        'Automatic Reject Sent' => '',
        'Escalation Solution Time In Effect' => '',
        'Escalation Solution Time Stopped' => '',
        'Escalation Response Time In Effect' => '',
        'Escalation Response Time Stopped' => '',
        'SLA Updated' => '',
        'Queue Updated' => '',
        'External Chat' => '',
        'Queue Changed' => '',
        'Notification Was Sent' => 'Melding is verstuurd.',
        'We are sorry, you do not have permissions anymore to access this ticket in its current state.' =>
            'Helaas, je hebt niet voldoende rechten om dit ticket te openen in zijn huidige staat.',
        'Can\'t get for ArticleID %s!' => '',
        'Article filter settings were saved.' => '',
        'Event type filter settings were saved.' => '',
        'Need ArticleID!' => '',
        'Invalid ArticleID!' => '',
        'Offline' => '',
        'User is currently offline.' => '',
        'User is currently active.' => '',
        'Away' => '',
        'User was inactive for a while.' => '',
        'Unavailable' => '',
        'User set their status to unavailable.' => '',
        'Fields with no group' => 'Velden zonder groep',
        'View the source for this Article' => '',

        # Perl Module: Kernel/Modules/CustomerTicketAttachment.pm
        'FileID and ArticleID are needed!' => '',
        'No TicketID for ArticleID (%s)!' => '',
        'No such attachment (%s)!' => '',

        # Perl Module: Kernel/Modules/CustomerTicketMessage.pm
        'Check SysConfig setting for %s::QueueDefault.' => '',
        'Check SysConfig setting for %s::TicketTypeDefault.' => '',

        # Perl Module: Kernel/Modules/CustomerTicketOverview.pm
        'Need CustomerID!' => '',
        'My Tickets' => 'Mijn tickets',
        'Company Tickets' => 'Tickets van groep',

        # Perl Module: Kernel/Modules/CustomerTicketSearch.pm
        'Please remove the following words because they cannot be used for the search:' =>
            'Verwijder de volgende woorden van je zoekactie omdat daar niet op gezocht kan worden:',

        # Perl Module: Kernel/Modules/CustomerTicketZoom.pm
        'Can\'t reopen ticket, not possible in this queue!' => '',
        'Create a new ticket!' => '',

        # Perl Module: Kernel/Modules/Installer.pm
        'SecureMode active!' => '',
        'If you want to re-run the Installer, disable the SecureMode in the SysConfig.' =>
            '',
        'Directory "%s" doesn\'t exist!' => '',
        'Configure "Home" in Kernel/Config.pm first!' => '',
        'File "%s/Kernel/Config.pm" not found!' => '',
        'Directory "%s" not found!' => '',
        'Kernel/Config.pm isn\'t writable!' => '',
        'If you want to use the installer, set the Kernel/Config.pm writable for the webserver user!' =>
            '',
        'Unknown Check!' => '',
        'The check "%s" doesn\'t exist!' => '',
        'Database %s' => '',
        'Configure MySQL' => '',
        'Configure PostgreSQL' => '',
        'Configure Oracle' => '',
        'Unknown database type "%s".' => '',
        'Please go back.' => '',
        'Install OTRS - Error' => '',
        'File "%s/%s.xml" not found!' => '',
        'Contact your Admin!' => '',
        'Syslog' => '',
        'Can\'t write Config file!' => '',
        'Unknown Subaction %s!' => '',
        'Can\'t connect to database, Perl module DBD::%s not installed!' =>
            '',
        'Can\'t connect to database, read comment!' => '',
        'Error: Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            '',
        'Error: Please set the value for innodb_log_file_size on your database to at least %s MB (current: %s MB, recommended: %s MB). For more information, please have a look at %s.' =>
            '',

        # Perl Module: Kernel/Modules/PublicRepository.pm
        'Need config Package::RepositoryAccessRegExp' => '',
        'Authentication failed from %s!' => '',

        # Perl Module: Kernel/Output/HTML/ArticleCheck/PGP.pm
        'Sent message crypted to recipient!' => '',
        '"PGP SIGNED MESSAGE" header found, but invalid!' => '',

        # Perl Module: Kernel/Output/HTML/ArticleCheck/SMIME.pm
        '"S/MIME SIGNED MESSAGE" header found, but invalid!' => '',
        'Ticket decrypted before' => '',
        'Impossible to decrypt: private key for email was not found!' => '',
        'Successful decryption' => '',

        # Perl Module: Kernel/Output/HTML/Dashboard/EventsTicketCalendar.pm
        'The start time of a ticket has been set after the end time!' => '',

        # Perl Module: Kernel/Output/HTML/Dashboard/News.pm
        'Can\'t connect to OTRS News server!' => '',
        'Can\'t get OTRS News from server!' => '',

        # Perl Module: Kernel/Output/HTML/Dashboard/ProductNotify.pm
        'Can\'t connect to Product News server!' => '',
        'Can\'t get Product News from server!' => '',

        # Perl Module: Kernel/Output/HTML/Dashboard/RSS.pm
        'Can\'t connect to %s!' => '',

        # Perl Module: Kernel/Output/HTML/Dashboard/TicketGeneric.pm
        'sorted ascending' => '',
        'sorted descending' => '',
        'filter not active' => '',
        'filter active' => '',
        'This ticket has no title or subject' => 'Dit ticket heeft geen titel of onderwerp',

        # Perl Module: Kernel/Output/HTML/Layout.pm
        'We are sorry, you do not have permissions anymore to access this ticket in its current state. You can take one of the following actions:' =>
            '',
        'No Permission' => '',

        # Perl Module: Kernel/Output/HTML/Layout/LinkObject.pm
        'Linked as' => 'Gekoppeld als',
        'Search Result' => '',

        # Perl Module: Kernel/Output/HTML/LinkObject/Ticket.pm
        'Archive search' => '',

        # Perl Module: Kernel/Output/HTML/Notification/AgentOTRSBusiness.pm
        '%s Upgrade to %s now! %s' => '%s upgrade naar %s nu! %s',

        # Perl Module: Kernel/Output/HTML/Notification/CustomerSystemMaintenanceCheck.pm
        'A system maintenance period will start at: ' => 'Een systeem onderhoudsperiode begint op:',

        # Perl Module: Kernel/Output/HTML/Preferences/Language.pm
        '(in process)' => '',

        # Perl Module: Kernel/Output/HTML/Preferences/NotificationEvent.pm
        'Please make sure you\'ve chosen at least one transport method for mandatory notifications.' =>
            'Zorg ervoor dat je minimaal één transportmethode hebt gekozen voor verplichtte notificaties.',

        # Perl Module: Kernel/Output/HTML/Preferences/OutOfOffice.pm
        'Please specify an end date that is after the start date.' => 'Geef een einddatum op die na de startdatum ligt.',

        # Perl Module: Kernel/Output/HTML/Preferences/Password.pm
        'Please supply your new password!' => 'Geef je nieuwe wachtwoord op.',

        # Perl Module: Kernel/Output/HTML/Statistics/View.pm
        'No (not supported)' => 'Nee (niet beschikbaar)',
        'No past complete or the current+upcoming complete relative time value selected.' =>
            'Geen historische volledige of huidige aankomende volledige relatieve tijdswaarden geselecteerd.',
        'The selected time period is larger than the allowed time period.' =>
            'De geselecteerde tijdsperiode is groter dan de toegestane tijdsperiode',
        'No time scale value available for the current selected time scale value on the X axis.' =>
            'Er is geen tijdschaal beschikbaar voor de geselecteerde tijdsschaal waarde op de X as.',
        'The selected date is not valid.' => 'De geselecteerde datum is niet geldig.',
        'The selected end time is before the start time.' => 'De geselecteerde einddtijd is voor de starttijd.',
        'There is something wrong with your time selection.' => 'Er is iets mis met je tijdsselectie.',
        'Please select only one element or allow modification at stat generation time.' =>
            'Selecteer minimaal één element of sta toe dat dit kan worden aangepast bij het genereren van de statistiek.',
        'Please select at least one value of this field or allow modification at stat generation time.' =>
            'Selecteer minimaal één element of sta toe dat dit kan worden aangepast bij het genereren van de statistiek.',
        'Please select one element for the X-axis.' => 'Selecteer een element voor X-as.',
        'You can only use one time element for the Y axis.' => 'Je kunt slechts één tijdselement voor de Y as gebruiken.',
        'You can only use one or two elements for the Y axis.' => 'Je kunt slechts één of twee elementen gebruiken voor de Y as.',
        'Please select at least one value of this field.' => 'Selecteer minimaal één waarde voor dit veld.',
        'Please provide a value or allow modification at stat generation time.' =>
            'Selecteer minimaal één element of sta toe dat dit kan worden aangepast bij het genereren van de statistiek.',
        'Please select a time scale.' => 'Selecteer een tijdsschaal.',
        'Your reporting time interval is too small, please use a larger time scale.' =>
            'De tijdsinterval is te klein, kies een grotere interval.',
        'Please remove the following words because they cannot be used for the ticket restrictions: %s.' =>
            'Verwijder de volgende woorden omdat ze niet gebruikt kunnen worden om tickets te beperken: %s',

        # Perl Module: Kernel/Output/HTML/TicketOverviewMenu/Sort.pm
        'Order by' => 'Sorteren op',

        # Perl Module: Kernel/System/ACL/DB/ACL.pm
        'Couldn\'t read ACL configuration file. Please make sure the file is valid.' =>
            '',

        # Perl Module: Kernel/System/AuthSession.pm
        'You have exceeded the number of concurrent agents - contact sales@otrs.com.' =>
            '',
        'Please note that the session limit is almost reached.' => '',
        'Login rejected! You have exceeded the maximum number of concurrent Agents! Contact sales@otrs.com immediately!' =>
            '',
        'Session per user limit reached!' => '',

        # Perl Module: Kernel/System/Console/Command/Dev/Tools/Config2Docbook.pm
        'Configuration Options Reference' => 'Configuratie opties verwijzing',
        'This setting can not be changed.' => 'Deze instelling kan niet worden aangepast.',
        'This setting is not active by default.' => 'Deze instelling is standaard niet ingeschakeld.',
        'This setting can not be deactivated.' => 'Deze instelling kan niet worden uitgeschakeld.',

        # Perl Module: Kernel/System/CustomerUser.pm
        'Customer user "%s" already exists.' => '',

        # Perl Module: Kernel/System/CustomerUser/DB.pm
        'This email address is already in use for another customer user.' =>
            '',

        # Perl Module: Kernel/System/DynamicField/Driver/BaseText.pm
        'e.g. Text or Te*t' => '',

        # Perl Module: Kernel/System/DynamicField/Driver/Checkbox.pm
        'Ignore this field.' => '',

        # Perl Module: Kernel/System/NotificationEvent.pm
        'Couldn\'t read Notification configuration file. Please make sure the file is valid.' =>
            'Niet is staat om het meldingen configuratie bestand te lezen. Zorg ervoor dat het bestand geldig is.',
        'Imported notification has body text with more than 4000 characters.' =>
            'Geïmporteerde melding is een tekst die meer dan 400 karakters bevat.',

        # Perl Module: Kernel/System/Package.pm
        'not installed' => '',
        'File is not installed!' => '',
        'File is different!' => '',
        'Can\'t read file!' => '',

        # Perl Module: Kernel/System/ProcessManagement/DB/Process.pm
        'The process "%s" and all of its data has been imported successfully.' =>
            '',

        # Perl Module: Kernel/System/ProcessManagement/DB/Process/State.pm
        'Inactive' => 'Inactief',
        'FadeAway' => '',

        # Perl Module: Kernel/System/Registration.pm
        'Can\'t get Token from sever' => '',

        # Perl Module: Kernel/System/Stats.pm
        'Sum' => 'Totaal',

        # Perl Module: Kernel/System/Stats/Dynamic/Ticket.pm
        'State Type' => 'Status type',
        'Created Priority' => 'Aangemaakt met prioriteit',
        'Created State' => 'Aangemaakt met status',
        'Create Time' => 'Aangemaakt op',
        'Close Time' => 'Afsluitingstijd',
        'Escalation - First Response Time' => 'Escalatie - eerste reactietijd',
        'Escalation - Update Time' => 'Escalatie - tijd van bijwerken',
        'Escalation - Solution Time' => 'Escalatie - tijd van oplossen',
        'Agent/Owner' => 'Behandelaar/eigenaar',
        'Created by Agent/Owner' => 'Aangemaakt door behandelaar/eigenaar',
        'CustomerUserLogin' => 'Klantlogin',
        'CustomerUserLogin (complex search)' => '',
        'CustomerUserLogin (exact match)' => '',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketAccountedTime.pm
        'Evaluation by' => 'Gebruik',
        'Ticket/Article Accounted Time' => 'Bestede tijd voor ticket en interacties',
        'Ticket Create Time' => 'Aanmaaktijd ticket',
        'Ticket Close Time' => 'Sluittijd ticket',
        'Accounted time by Agent' => 'Bestede tijd per behandelaar',
        'Total Time' => 'Totale tijd',
        'Ticket Average' => 'Gemiddelde per ticket',
        'Ticket Min Time' => 'Minimumtijd voor ticket',
        'Ticket Max Time' => 'Maximumtijd voor ticket',
        'Number of Tickets' => 'Aantal tickets',
        'Article Average' => 'Gemiddelde per interactie',
        'Article Min Time' => 'Minimumtijd voor interactie',
        'Article Max Time' => 'Maximumtijd voor interactie',
        'Number of Articles' => 'Aantal interacties',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketList.pm
        'unlimited' => '',
        'ascending' => 'aflopend',
        'descending' => 'oplopend',
        'Attributes to be printed' => 'Attributen om af te drukken',
        'Sort sequence' => 'Sorteervolgorde',
        'State Historic' => 'Historische status',
        'State Type Historic' => 'Historische status type',
        'Historic Time Range' => 'Historische tijdsvenster',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketSolutionResponseTime.pm
        'Solution Average' => '',
        'Solution Min Time' => '',
        'Solution Max Time' => '',
        'Solution Average (affected by escalation configuration)' => '',
        'Solution Min Time (affected by escalation configuration)' => '',
        'Solution Max Time (affected by escalation configuration)' => '',
        'Solution Working Time Average (affected by escalation configuration)' =>
            '',
        'Solution Min Working Time (affected by escalation configuration)' =>
            '',
        'Solution Max Working Time (affected by escalation configuration)' =>
            '',
        'First Response Average (affected by escalation configuration)' =>
            '',
        'First Response Min Time (affected by escalation configuration)' =>
            '',
        'First Response Max Time (affected by escalation configuration)' =>
            '',
        'First Response Working Time Average (affected by escalation configuration)' =>
            '',
        'First Response Min Working Time (affected by escalation configuration)' =>
            '',
        'First Response Max Working Time (affected by escalation configuration)' =>
            '',
        'Number of Tickets (affected by escalation configuration)' => '',

        # Perl Module: Kernel/System/Stats/Static/StateAction.pm
        'Days' => 'Dagen',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/TablePresence.pm
        'Table Presence' => 'Uiterlijk Tabel',
        'Internal Error: Could not open file.' => 'Interne Fout: kan bestand niet openen.',
        'Table Check' => 'Tabel Controle',
        'Internal Error: Could not read file.' => 'Interne fout: kan het bestand niet lezen.',
        'Tables found which are not present in the database.' => 'Tabellen gevonden die niet aanwezig zijn in de database.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mssql/Size.pm
        'Database Size' => 'Database omvang',
        'Could not determine database size.' => 'Kan database omvang niet bepalen',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mssql/Version.pm
        'Database Version' => 'Database versie',
        'Could not determine database version.' => 'Kan de database versie niet bepalen',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Charset.pm
        'Client Connection Charset' => 'Client verbinding karakterset',
        'Setting character_set_client needs to be utf8.' => 'Instelling character_set_client moet staan op utf8',
        'Server Database Charset' => 'Server Database karakterinstelling',
        'Setting character_set_database needs to be UNICODE or UTF8.' => 'Instelling character_set_datbase moet UNICODE of UTF8 zijn.',
        'Table Charset' => 'Tabel Karacterset',
        'There were tables found which do not have utf8 as charset.' => 'Er zijn tabellen gevonden die geen utf8 karakterset hebben.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/InnoDBLogFileSize.pm
        'InnoDB Log File Size' => 'InnoDB Log bestandsgrootte',
        'The setting innodb_log_file_size must be at least 256 MB.' => 'De instelling innodb_log_file_size meot minimaal 256MB zijn',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/MaxAllowedPacket.pm
        'Maximum Query Size' => 'Maximale Query Lengte',
        'The setting \'max_allowed_packet\' must be higher than 20 MB.' =>
            'De instelling \'max_allowed_packet\' moet minimaal 20MB zijn',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Performance.pm
        'Query Cache Size' => 'Query Cache grootte',
        'The setting \'query_cache_size\' should be used (higher than 10 MB but not more than 512 MB).' =>
            'De instelling \'query_cache_size\' gebruikt worden (minimaal 10MB, maar niet meer dan 512 MB)',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/StorageEngine.pm
        'Default Storage Engine' => 'Standaard Storage Engine',
        'Table Storage Engine' => 'Tabel Storage Engine',
        'Tables with a different storage engine than the default engine were found.' =>
            'Er zijn tabellen gevonden die een afwijkende storage engine gebruiken.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Version.pm
        'MySQL 5.x or higher is required.' => 'MySQL 5.x of hoger is vereist.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/oracle/NLS.pm
        'NLS_LANG Setting' => 'NLS_LANG instelling',
        'NLS_LANG must be set to al32utf8 (e.g. GERMAN_GERMANY.AL32UTF8).' =>
            'NLS_LANG moet ingesteld zijn op al32utf8 (GERMAN_GERMANY.AL32UTF8)',
        'NLS_DATE_FORMAT Setting' => 'NLS_DATE_FORMAT instelling',
        'NLS_DATE_FORMAT must be set to \'YYYY-MM-DD HH24:MI:SS\'.' => 'NLS_DATE_FORMAT moet ingesteld zijn op \'YYYY-MM-DD HH24:MI:SS\'.',
        'NLS_DATE_FORMAT Setting SQL Check' => 'NLS_DATE_FORMAT instelling SQL controle',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/Charset.pm
        'Setting client_encoding needs to be UNICODE or UTF8.' => 'Instelling client_encoding moet UNICODE of UTF8 zijn',
        'Setting server_encoding needs to be UNICODE or UTF8.' => 'Instelling server_encoding moet UNICODE of UTF8 zijn',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/DateStyle.pm
        'Date Format' => 'Datum Format',
        'Setting DateStyle needs to be ISO.' => 'Instelling DateStyle moet ISO zijn',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/Version.pm
        'PostgreSQL 8.x or higher is required.' => 'PostgreSQL 8.x of hoger is vereist.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskPartitionOTRS.pm
        'OTRS Disk Partition' => 'OTRS Schijfpartitie',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskSpace.pm
        'Disk Usage' => 'Harde schijf gebruik',
        'The partition where OTRS is located is almost full.' => 'De partitie waar OTRS op staat is bijna vol.',
        'The partition where OTRS is located has no disk space problems.' =>
            'De partitie waar OTRS op staat heeft voldoende ruimte.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskSpacePartitions.pm
        'Disk Partitions Usage' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Distribution.pm
        'Distribution' => 'Versie',
        'Could not determine distribution.' => 'Kan de versie niet bepalen',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/KernelVersion.pm
        'Kernel Version' => 'Kernel versie',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Load.pm
        'System Load' => 'Systeem Belasting',
        'The system load should be at maximum the number of CPUs the system has (e.g. a load of 8 or less on a system with 8 CPUs is OK).' =>
            'De systeem belasting zou niet meer moeten zijn dan het aantal CPUs dat het systeem heeft (een belasting van 8 of minder voor een systeem met 8 CPU\'s).',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/PerlModules.pm
        'Perl Modules' => 'Perl Modules',
        'Not all required Perl modules are correctly installed.' => 'Niet alle vereiste Perl modules zijn correct geïnstalleerd',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Swap.pm
        'Free Swap Space (%)' => 'Vrije Swap ruimte (%)',
        'No swap enabled.' => 'Geen swap ingeschakeld.',
        'Used Swap Space (MB)' => 'Gebruikte Swap ruimte (MB)',
        'There should be more than 60% free swap space.' => 'Er zou meer dan 60% vrije swap ruimte moeten zijn.',
        'There should be no more than 200 MB swap space used.' => 'Er zou niet meer dan 200MB swap ruimte in gebruik moeten zijn.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/ConfigSettings.pm
        'OTRS' => 'OTRS',
        'Config Settings' => '',
        'Could not determine value.' => 'Kon waarde niet bepalen',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/DaemonRunning.pm
        'Daemon' => 'Daemon',
        'Daemon is running.' => '',
        'Daemon is not running.' => 'Deamon is niet actief.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/DatabaseRecords.pm
        'Database Records' => '',
        'Tickets' => 'Tickets',
        'Ticket History Entries' => 'Ticket Historie gegevens',
        'Articles' => 'Interacties',
        'Attachments (DB, Without HTML)' => 'Bijlagen (Database, zonder HTML)',
        'Customers With At Least One Ticket' => 'Klanten met minimaal één ticket',
        'Dynamic Field Values' => 'Dynamische veldwaarden',
        'Invalid Dynamic Fields' => 'Ongeldige Dynamische velden',
        'Invalid Dynamic Field Values' => 'Ongeldige Dynamische Veld Waarden',
        'GenericInterface Webservices' => 'GenericInterface Webservices',
        'Process Tickets' => '',
        'Months Between First And Last Ticket' => 'Maanden tussen het eerste en laatste ticket',
        'Tickets Per Month (avg)' => 'Tickets per maand (gemiddeld)',
        'Open Tickets' => 'Open Tickets',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/DefaultSOAPUser.pm
        'Default SOAP Username And Password' => 'Standaard SOAP gebruikersnaam en wachtwoord',
        'Security risk: you use the default setting for SOAP::User and SOAP::Password. Please change it.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/DefaultUser.pm
        'Default Admin Password' => 'Standaard Admin Wachtwoord',
        'Security risk: the agent account root@localhost still has the default password. Please change it or invalidate the account.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/FQDN.pm
        'FQDN (domain name)' => 'FQDN (Domeinnaam)',
        'Please configure your FQDN setting.' => 'Configureer de FQDN instelling.',
        'Domain Name' => 'Domeinnaam',
        'Your FQDN setting is invalid.' => 'De FQDN instelling is ongeldig.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/FileSystemWritable.pm
        'File System Writable' => 'Bestandsysteem beschrijfbaar',
        'The file system on your OTRS partition is not writable.' => 'Het bestandsysteem op de OTRS partitie is niet schrijfbaar.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/PackageDeployment.pm
        'Package Installation Status' => 'Pakket installatie status',
        'Some packages have locally modified files.' => '',
        'Some packages are not correctly installed.' => 'Sommige pakketten zijn niet correct geïnstalleerd.',
        'Package Verification Status' => '',
        'Some packages are not verified by the OTRS Group! It is recommended not to use this packages.' =>
            '',
        'Package Framework Version Status' => '',
        'Some packages are not allowed for the current framework version.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/PackageList.pm
        'Package List' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/SessionConfigSettings.pm
        'Session Config Settings' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/SpoolMails.pm
        'Spooled Emails' => '',
        'There are emails in var/spool that OTRS could not process.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/SystemID.pm
        'Your SystemID setting is invalid, it should only contain digits.' =>
            'De gekozen SystemID is ongeldig, er mogen alleen cijfers in voorkomen.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/DefaultType.pm
        'Default Ticket Type' => '',
        'The configured default ticket type is invalid or missing. Please change the setting Ticket::Type::Default and select a valid ticket type.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/IndexModule.pm
        'Ticket Index Module' => 'Ticket Index Module',
        'You have more than 60,000 tickets and should use the StaticDB backend. See admin manual (Performance Tuning) for more information.' =>
            'Je hebt meer dan 60.000 tickets en zou een StaticDB backend moeten gebruiken. Zie ook de administrator handleiding (Performance Tuning) voor meer informatie.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/InvalidUsersWithLockedTickets.pm
        'Invalid Users with Locked Tickets' => '',
        'There are invalid users with locked tickets.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/OpenTickets.pm
        'You should not have more than 8,000 open tickets in your system.' =>
            'Je zou niet meer dan 8.000 openstaande tickets in je systeem moeten hebben.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/SearchIndexModule.pm
        'Ticket Search Index Module' => 'Ticket Zoek Indexering Module',
        'You have more than 50,000 articles and should use the StaticDB backend. See admin manual (Performance Tuning) for more information.' =>
            'Je hebt meer dan 50.000 artikelen en zou StatickDB als backend moeten gebruiken. Zie ook de administrator handleiding (Performance Tuning) voor meer informatie.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/StaticDBOrphanedRecords.pm
        'Orphaned Records In ticket_lock_index Table' => 'Weesrecords in de table ticket_lock_index.',
        'Table ticket_lock_index contains orphaned records. Please run bin/otrs.Console.pl "Maint::Ticket::QueueIndexCleanup" to clean the StaticDB index.' =>
            'De tabel ticket_lock_index bevat weesreckords. Om sw StaticDB te schonen voert u het volgende script: uit bin/otrs.Console.pl "Maint::Ticket::QueueIndexCleanup".',
        'Orphaned Records In ticket_index Table' => 'Weesrecords in de table ticket_index',
        'Table ticket_index contains orphaned records. Please run bin/otrs.Console.pl "Maint::Ticket::QueueIndexCleanup" to clean the StaticDB index.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/TimeSettings.pm
        'Time Settings' => '',
        'Server time zone' => 'Tijdzone van de server',
        'Computed server time offset' => 'Berekende server afwijking van UTC',
        'OTRS TimeZone setting (global time offset)' => 'OTRS Tijdzone instelling (globale tijdsafwijking van UTC)',
        'TimeZone may only be activated for systems running in UTC.' => 'Tijdzones kan alleen geactiveerd worden voor systemen die in UTC draaien.',
        'OTRS TimeZoneUser setting (per-user time zone support)' => 'OTRS TijdZoneUser instelling (gebruikerspecifieke tijdzone ondersteuning)',
        'TimeZoneUser may only be activated for systems running in UTC that don\'t have an OTRS TimeZone set.' =>
            'TimeZoneUsers kan alleen geactiveerd worden voor systemen die draaien in UTC die geen OTRS tijdzone hebben ingesteld.',
        'OTRS TimeZone setting for calendar ' => 'OTRS TijdZone instelling voor kalender.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/UI/AgentSkinUsage.pm
        'UI - Agent Skin Usage' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/UI/AgentThemeUsage.pm
        'UI - Agent Theme Usage' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/LoadedModules.pm
        'Webserver' => 'Webserver',
        'Loaded Apache Modules' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/MPMModel.pm
        'MPM model' => 'MPM model',
        'OTRS requires apache to be run with the \'prefork\' MPM model.' =>
            'OTRS vereist dat apache wordt uitgevoerd met de \'prefork\' MPM model.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/Performance.pm
        'CGI Accelerator Usage' => 'CGI Accelerator Gebruik',
        'You should use FastCGI or mod_perl to increase your performance.' =>
            'Gebruik FastCGI of mod_perl om performance te verbetern.',
        'mod_deflate Usage' => 'mod_deflate Gebruik',
        'Please install mod_deflate to improve GUI speed.' => 'Installeer mod_deflate om GUI snelheid te verbeteren.',
        'mod_filter Usage' => 'mod_filter Gebruik',
        'Please install mod_filter if mod_deflate is used.' => 'Installeer mod_filter wanneer mod_deflate wordt gebruikt.',
        'mod_headers Usage' => 'mod_headers Usage',
        'Please install mod_headers to improve GUI speed.' => 'Installeer mod_headers om GUI snelheid te verbeteren.',
        'Apache::Reload Usage' => 'Apache::Reload Gebruik',
        'Apache::Reload or Apache2::Reload should be used as PerlModule and PerlInitHandler to prevent web server restarts when installing and upgrading modules.' =>
            'Apache::Reload of Apache2::Reload worden gebruikt als PerlModule en PerlInitHandler om te voorkomen dat de webserver herstart wanneer modules worden geïnstalleerd of geupgrade.',
        'Apache2::DBI Usage' => 'Apach2::DBI Gebruik',
        'Apache2::DBI should be used to get a better performance  with pre-established database connections.' =>
            'Gelieve Apache2:DBI te gebruiken om de performantie met vooraf gelegde connecties met databases te verbeteren',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/EnvironmentVariables.pm
        'Environment Variables' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/InternalWebRequest.pm
        'Support Data Collection' => '',
        'Support data could not be collected from the web server.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Version.pm
        'Webserver Version' => 'Webserver versie',
        'Could not determine webserver version.' => 'Kan versie van webserver niet bepalen.',

        # Perl Module: Kernel/System/SupportDataCollector/PluginAsynchronous/OTRS/ConcurrentUsers.pm
        'Concurrent Users Details' => '',
        'Concurrent Users' => 'Gelijktijdige gebruikers',

        # Perl Module: Kernel/System/SupportDataCollector/PluginBase.pm
        'Unknown' => 'Onbekend',
        'OK' => 'OK',
        'Problem' => 'Probleem',

        # Perl Module: Kernel/System/Ticket.pm
        'Reset of unlock time.' => '',

        # Perl Module: Kernel/System/Ticket/Event/NotificationEvent/Transport/Email.pm
        'PGP sign only' => '',
        'PGP encrypt only' => '',
        'PGP sign and encrypt' => '',
        'SMIME sign only' => '',
        'SMIME encrypt only' => '',
        'SMIME sign and encrypt' => '',
        'PGP and SMIME not enabled.' => '',
        'Skip notification delivery' => 'Sla het afleveren van de melding over',
        'Send unsigned notification' => 'Stuur een niet-ondertekende melding',
        'Send unencrypted notification' => 'Stuur een niet-gecodeerde melding',

        # Perl Module: Kernel/System/Web/InterfaceAgent.pm
        'Authentication succeeded, but no user data record is found in the database. Please contact the administrator.' =>
            '',
        'Can`t remove SessionID.' => '',
        'Logout successful.' => 'Afmelden gelukt.',
        'Error: invalid session.' => '',
        'No Permission to use this frontend module!' => '',

        # Perl Module: Kernel/System/Web/InterfaceCustomer.pm
        'Authentication succeeded, but no customer record is found in the customer backend. Please contact the administrator.' =>
            '',
        'Reset password unsuccessful. Please contact the administrator.' =>
            '',
        'Added via Customer Panel (%s)' => '',
        'Customer user can\'t be added!' => '',
        'Can\'t send account info!' => '',

        # Perl Module: Kernel/System/Web/InterfaceInstaller.pm
        'Action "%s" not found!' => '',

        # Database XML Definition: scripts/database/otrs-initial_insert.xml
        'Group for default access.' => 'Groep voor standaard toegang.',
        'Group of all administrators.' => 'Groep voor alle administrators.',
        'Group for statistics access.' => 'Groep voor statistieken toegang.',
        'All new state types (default: viewable).' => 'Alle nieuwe status types (standaard: zichtbaar)',
        'All open state types (default: viewable).' => 'Alle open status types (standaard: zichtbaar)',
        'All closed state types (default: not viewable).' => 'Alle gesloten status types (standaard: niet zichtbaar).',
        'All \'pending reminder\' state types (default: viewable).' => 'Alle \'wacht op reminder\' status types (standaard: zichtbaar)',
        'All \'pending auto *\' state types (default: viewable).' => 'Alle \'wacht op automatisch *\' status types (standaard: zichtbaar).',
        'All \'removed\' state types (default: not viewable).' => 'Alle \'verwijderd\' status types (standaard: niet zichtbaar).',
        'State type for merged tickets (default: not viewable).' => 'Status type voor samengevoegde tickets (standaard: niet zichtbaar).',
        'New ticket created by customer.' => 'Niet ticket aangemaakt door klant.',
        'Ticket is closed successful.' => 'Ticket is succesvol gesloten.',
        'Ticket is closed unsuccessful.' => 'Ticket is niet succesvol gesloten.',
        'Open tickets.' => 'Openstaande tickets.',
        'Customer removed ticket.' => 'Klant heeft ticket verwijderd.',
        'Ticket is pending for agent reminder.' => 'Ticket wacht op reminder voor agent.',
        'Ticket is pending for automatic close.' => 'Ticket wacht op automatisch sluiten.',
        'State for merged tickets.' => 'Status voor samengevoegde tickets.',
        'system standard salutation (en)' => 'Systeem standaard aanhef (en)',
        'Standard Salutation.' => 'Standaard Aanhef',
        'system standard signature (en)' => 'sandaard ondertekening (engels)',
        'Standard Signature.' => 'Standaard ondertekening',
        'Standard Address.' => 'Standaard Adres.',
        'Follow-ups for closed tickets are possible. Ticket will be reopened.' =>
            'Follow-ups voor gesloten ticket zijn mogelijk. Tickets worden heropend.',
        'Follow-ups for closed tickets are not possible. No new ticket will be created.' =>
            'Follow-ups voor gesloten tickets zijn niet mogelijk. Er wordt geen nieuw ticket aangemaakt.',
        'new ticket' => 'nieuw ticket',
        'Follow-ups for closed tickets are not possible. A new ticket will be created.' =>
            '',
        'Postmaster queue.' => 'Postmaster wachtrij.',
        'All default incoming tickets.' => 'Alle standaard binnenkomende tickets',
        'All junk tickets.' => 'Alle span tickets.',
        'All misc tickets.' => 'Alle diverse tickets.',
        'Automatic reply which will be sent out after a new ticket has been created.' =>
            'Automatisch antwoord welke wordt verstuurd wanneer een nieuw ticket is aangemaakt.',
        'Automatic reject which will be sent out after a follow-up has been rejected (in case queue follow-up option is "reject").' =>
            'Automatisch antwoord welke wordt verzonden wanneer een follow-up wordt geweigerd (wanneer een follow-up wordt geweigerd).',
        'Automatic confirmation which is sent out after a follow-up has been received for a ticket (in case queue follow-up option is "possible").' =>
            'Automatische bevestiging die wordt verstuurd nadat een folluw-up is ontvangen voor een ticket (wanner een follow-up mogelijk is).',
        'Automatic response which will be sent out after a follow-up has been rejected and a new ticket has been created (in case queue follow-up option is "new ticket").' =>
            'Automatisch antwoord welke wordt verstoord nadat een follow-up is afgewezen en een nieuw ticket is aangemaakt (voor het geval dat een follow-up een nieuw ticket is).',
        'Auto remove will be sent out after a customer removed the request.' =>
            'Automatisch verwijderen wordt verstuud wanneer een klant het verzoek heeft verwijderd.',
        'default reply (after new ticket has been created)' => 'standaard antwoord (wanneer een nieuw ticket is aangemaakt)',
        'default reject (after follow-up and rejected of a closed ticket)' =>
            'standaard afwijzing (na follow-up en afwijzing van een gesloten ticket)',
        'default follow-up (after a ticket follow-up has been added)' => 'standaard follow-up (wanneer een ticket follow-up is toegevoegd)',
        'default reject/new ticket created (after closed follow-up with new ticket creation)' =>
            'standaard afwijzing/nieuw ticket aangemaakt (na een gesloten follow up en nieuw ticket is aangemaakt)',
        'Unclassified' => 'niet geclassificeerd',
        'tmp_lock' => 'tijdelijk_lock',
        'email-notification-ext' => 'email-notification-ext',
        'email-notification-int' => 'email-notification-int',
        'Ticket create notification' => 'Melding bij het aanmaken van een ticket',
        'You will receive a notification each time a new ticket is created in one of your "My Queues" or "My Services".' =>
            'U ontvangt een melding telkens wanneer een nieuw ticket wordt aangemaakt in een van uw "Mijn wachtrijen" of "Mijn diensten".',
        'Ticket follow-up notification (unlocked)' => 'Melding bij een nieuwe reactie op een ticket (niet vergrendeld)',
        'You will receive a notification if a customer sends a follow-up to an unlocked ticket which is in your "My Queues" or "My Services".' =>
            'U ontvangt een melding als een klant een reactie stuurt naar een ontgrendeld ticket dat zich in uw "Mijn wachtrijen" of "Mijn diensten" bevindt',
        'Ticket follow-up notification (locked)' => 'Melding bij een nieuwe reactie op een ticket (vergrendeld)',
        'You will receive a notification if a customer sends a follow-up to a locked ticket of which you are the ticket owner or responsible.' =>
            'U ontvangt een melding als een klant een reactie stuurt naar een vergrendeld ticket dat zich in uw "Mijn wachtrijen" of "Mijn diensten" bevindt',
        'You will receive a notification as soon as a ticket owned by you is automatically unlocked.' =>
            'U ontvangt een melding zodra een ticket van u automatisch wordt ontgrendeld.',
        'Ticket owner update notification' => 'Melding bij een nieuwe eigenaar',
        'Ticket responsible update notification' => 'Melding bij een nieuwe verantwoordelijke',
        'Ticket new note notification' => 'Melding bij een nieuwe notitie',
        'Ticket queue update notification' => 'Melding bij het verplaatsen van een ticket',
        'You will receive a notification if a ticket is moved into one of your "My Queues".' =>
            'U ontvangt een melding als een ticket wordt verplaatst naar een van uw "Mijn wachtrijen".',
        'Ticket pending reminder notification (locked)' => 'Melding wanneer een reminder afloopt (vergrendeld)',
        'Ticket pending reminder notification (unlocked)' => 'Melding wanneer een reminder afloopt (niet vergrendeld)',
        'Ticket escalation notification' => 'Ticket escalatie notificatie',
        'Ticket escalation warning notification' => 'Ticket escalatie waarschuwing notificatie',
        'Ticket service update notification' => 'Ticket service update notificatie',
        'You will receive a notification if a ticket\'s service is changed to one of your "My Services".' =>
            'U ontvangt een melding als de service van een ticket is gewijzigd in een van uw \'Mijn services\'.',

        # SysConfig
        '
Dear Customer,

Unfortunately we could not detect a valid ticket number
in your subject, so this email can\'t be processed.

Please create a new ticket via the customer panel.

Thanks for your help!

 Your Helpdesk Team
' => '
Beste Klant,

Helaas konden we geen geldig ticket nummer vinden
in jouw onderwerp, dus deze e-mail kan niet worden verwerkt.

Maak een nieuw ticket aan via het klant portaal.

Bedankt voor je hulp

Het Helpdesk Team
',
        ' (work units)' => '(werk eenheden)',
        '"%s" notification was sent to "%s" by "%s".' => '"%s"  notificatie is verstuurd aan "%s" door "%s".',
        '"Slim" skin which tries to save screen space for power users.' =>
            '',
        '%s' => '%s',
        '%s time unit(s) accounted. Now total %s time unit(s).' => '%s tijdseenheden verantwoord. Nu %s tijdseenheden totaal.',
        '(UserLogin) Firstname Lastname' => '(Loginnaam) Voornaam Achternaam',
        '(UserLogin) Lastname Firstname' => '(Loginnaam) Achternaam Voornaam',
        '(UserLogin) Lastname, Firstname' => '(Loginnaam) Achternaam, Voornaam',
        '*** out of office until %s (%s d left) ***' => '',
        '100 (Expert)' => '',
        '200 (Advanced)' => '',
        '300 (Beginner)' => '',
        'A TicketWatcher Module.' => '',
        'A Website' => 'Een website',
        'A list of dynamic fields that are merged into the main ticket during a merge operation. Only dynamic fields that are empty in the main ticket will be set.' =>
            'Een lijst met dynamische velden die worden samengevoegd in het hoofdticket gedurende de samenvoeg actie. Alleen lege velden dynamische velden in het main ticket worden gevuld.',
        'A picture' => 'Een afbeelding',
        'ACL module that allows closing parent tickets only if all its children are already closed ("State" shows which states are not available for the parent ticket until all child tickets are closed).' =>
            'ACL module staat alleen toe dat ouder tickets worden gesloten wanneer alle kinderen zijn gesloten ("Status" toont welke statussen niet beschikbaar zijn voor het ouder ticket totdat alle kind tickets zijn gesloten)',
        'Access Control Lists (ACL)' => 'Access Control Lists (ACL)',
        'AccountedTime' => 'AccountedTime',
        'Activates a blinking mechanism of the queue that contains the oldest ticket.' =>
            'Activeert een knipper mechanisme van de wachtrij met het oudste ticket.',
        'Activates lost password feature for agents, in the agent interface.' =>
            'Activeert "wachtwoord vergeten" functionaliteit voor agents in de agent interface.',
        'Activates lost password feature for customers.' => 'Activeert wachtwood vergeten functionaliteit voor alle klanten.',
        'Activates support for customer groups.' => 'Activeert ondersteuning voor klantgroepen.',
        'Activates the article filter in the zoom view to specify which articles should be shown.' =>
            'Activeert het artikel filter in de zoom weergave om te bepalen welke artikelen moeten worden weergegeven.',
        'Activates the available themes on the system. Value 1 means active, 0 means inactive.' =>
            'Activeert de beschikbare themas op het systeem. Waarde 1 betekent actief, waarde 0 betekent niet actief.',
        'Activates the ticket archive system search in the customer interface.' =>
            'Staat klanten toe om in gearchiveerde tickets te zoeken.',
        'Activates the ticket archive system to have a faster system by moving some tickets out of the daily scope. To search for these tickets, the archive flag has to be enabled in the ticket search.' =>
            'Activeert het ticket archief systeem, tickets worden uit de dagelijkse scope gehouden wat het systeem versnelt. Om te zoeken op deze ticket moet dit specifiek worden aangegeven in het zoekscherm.',
        'Activates time accounting.' => 'Activeert tijd registratie.',
        'ActivityID' => 'ActivityID',
        'Add a comment.' => '',
        'Add a default name for Dynamic Field.' => '',
        'Add an inbound phone call to this ticket' => 'Voeg een binnenkomend telefoongesprek toe aan dit ticket.',
        'Add an outbound phone call to this ticket' => 'Voeg een uitgaand telefoongesprek toe aan dit ticket.',
        'Added email. %s' => 'E-mail toegevoegd. %s',
        'Added link to ticket "%s".' => 'Koppeling naar "%s" toegevoegd.',
        'Added note (%s)' => 'Notitie toegevoegd (%s)',
        'Added subscription for user "%s".' => 'Added subscription for user "%s".',
        'Address book of CustomerUser sources.' => '',
        'Adds a suffix with the actual year and month to the OTRS log file. A logfile for every month will be created.' =>
            'Voegt een achtervoegsel met het eigenlijke jaar en maand toe aan het OTRS logbestand. Er wordt een logbestand gemaakt voor elke maand.',
        'Adds customers email addresses to recipients in the ticket compose screen of the agent interface. The customers email address won\'t be added if the article type is email-internal.' =>
            'Voeg klant e-mail adressen toe aan de ontvangers in het ticket maak scherm van de agent interface. De adressen worden niet toegevoegd wanneer het artikel van het type email-internal is.',
        'Adds the one time vacation days for the indicated calendar. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Voegt eenmalige vakantie dagen toe voor de kalender. Gebruik één cijfer voor de getallen 1 t/m 9.',
        'Adds the one time vacation days. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Voegt éénmalige vakantiedagen toe. Gebruik een enkelcijferig patroon voor de getallen 1 t/m 9 (in de plaats van 01 t/m 09).',
        'Adds the permanent vacation days for the indicated calendar. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Voegt de permanente vakantiedagen toe voor de aangegeven kalender. Gebruik een enkelcijferig patroon voor de getallen 1 t/m 9 (in de plaats van 01 t/m 09).',
        'Adds the permanent vacation days. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Voegt permanente vakantiedagen toe. Gebruik een enkelcijferig patroon voor de getallen 1 t/m 9 (in de plaats van 01 t/m 09).',
        'Admin Area.' => '',
        'After' => 'Na',
        'Agent Name' => '',
        'Agent Name + FromSeparator + System Address Display Name' => '',
        'Agent Preferences.' => '',
        'Agent called customer.' => 'Klant gebeld.',
        'Agent interface article notification module to check PGP.' => 'Agent interface melding module om PGP te controleren.',
        'Agent interface article notification module to check S/MIME.' =>
            'Agent interface melding module om S/MIME te controleren.',
        'Agent interface module to access CIC search via nav bar. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Agent interface module to access fulltext search via nav bar. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Agent interface module to access search profiles via nav bar. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Agent interface module to check incoming emails in the Ticket-Zoom-View if the S/MIME-key is available and true.' =>
            'Agent interface module om binnenkomence emails te controleren in de Ticket-Zoom-Weergave wanneer de S/MIME-sleutel beschikbaar en ingeschakeld is.',
        'Agent interface notification module to see the number of locked tickets. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Agent interface notification module to see the number of tickets an agent is responsible for. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Agent interface notification module to see the number of tickets in My Services. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Agent interface notification module to see the number of watched tickets. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'AgentCustomerSearch' => '',
        'AgentCustomerSearch.' => '',
        'AgentUserSearch' => '',
        'AgentUserSearch.' => '',
        'Agents <-> Groups' => 'Behandelaars <-> Groepen',
        'Agents <-> Roles' => 'Behandelaars <-> Rollen',
        'All customer users of a CustomerID' => 'Alle klanten accounts van een CustomerID',
        'Allows adding notes in the close ticket screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Staat het toe om notities toe te voegen in het "sluit ticket" scherm van de agent interface. Kan worden overschreven door Ticket::Frontend::NeedAccountedTime.',
        'Allows adding notes in the ticket free text screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Staat toe om notities toe te voegen in het vrije tekst scherm van de agent interface. Kan worden overschreven door Ticket::Frontend::NeedAccountedTime.',
        'Allows adding notes in the ticket note screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Staat het toe om notities toe te voegen in het notitie scherm van de agent interface. Kan worden overschreven door Ticket::Frontend::NeedAccountedTime.',
        'Allows adding notes in the ticket owner screen of a zoomed ticket in the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Staat het toe om notities toe te voegen in het eigenaar scherm van een bekeken ticket in de agent interface. Kan worden overschreven door Ticket::Frontend::NeedAccountedTime.',
        'Allows adding notes in the ticket pending screen of a zoomed ticket in the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Staat het toe om notities toe te voegen in het ticket wacht op scherm van een bekeken ticket in de agent interface. Kan worden overschreven door Ticket::Frontend::NeedAccountedTime.',
        'Allows adding notes in the ticket priority screen of a zoomed ticket in the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Staat het toe om notities toe te voegen in het prioriteit scherm van een bekeken ticket in de agent interface. Kan worden overschreven door Ticket::Frontend::NeedAccountedTime.',
        'Allows adding notes in the ticket responsible screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Staat het toe om notities toe te voegen in het ticket verantwoodelijke scherm van de agent interface. Kan worden overschreven door Ticket::Frontend::NeedAccountedTime.',
        'Allows agents to exchange the axis of a stat if they generate one.' =>
            'Staat agent toe om de as van een statistiek te delen wanneer ze er een gemaakt hebben.',
        'Allows agents to generate individual-related stats.' => 'Staat agent toe om individue gerelateerde statistieken te maken.',
        'Allows choosing between showing the attachments of a ticket in the browser (inline) or just make them downloadable (attachment).' =>
            'Staat het toe om te kiezen tussen het tonen van bijlagen van een ticket in de browser (inline) of hem alleen downloadbaar te maken (attachment)',
        'Allows choosing the next compose state for customer tickets in the customer interface.' =>
            'Staat het toe om de volgende "compose" status voor klant ticket te kiezen in de klant interface.',
        'Allows customers to change the ticket priority in the customer interface.' =>
            'Staat klanten toe om de prioriteit aan te passen van een ticket in de klant weergave.',
        'Allows customers to set the ticket SLA in the customer interface.' =>
            'Staat klanten toe om de SLA van een ticket aan te passen in de klant weergave.',
        'Allows customers to set the ticket priority in the customer interface.' =>
            'Staat klanten toe om de prioriteit van een ticket aan te passen in de klant interface.',
        'Allows customers to set the ticket queue in the customer interface. If this is set to \'No\', QueueDefault should be configured.' =>
            'Staat klanten toe om de wachtrij aan te passen in de klant interface. Als dit op "Nee" staat, moet QueueDefault ingesteld zijn.',
        'Allows customers to set the ticket service in the customer interface.' =>
            'Staat klanten toe om de ticket service te kiezen in de klant weergave.',
        'Allows customers to set the ticket type in the customer interface. If this is set to \'No\', TicketTypeDefault should be configured.' =>
            'Staat klanten toe om het ticket type te kiezen in de klant interface. Als dit op \'Nee\' staat moet TicketTypeDefault zijn ingesteld.',
        'Allows default services to be selected also for non existing customers.' =>
            'Staat toe om standaard services te selecteren voor niet bestaande klanten.',
        'Allows defining new types for ticket (if ticket type feature is enabled).' =>
            'Staat het toe om nieuwe types te definieren voor tickets (als ticket type feature aan staat).',
        'Allows defining services and SLAs for tickets (e. g. email, desktop, network, ...), and escalation attributes for SLAs (if ticket service/SLA feature is enabled).' =>
            'Staat het toe om services en SLA\'s voor tickets te specificeren (e.g. email, desktop, netwerk, ...), en escalatie attributen voor SLA\'s (als ticket service/SLA feature is ingeschakeld).',
        'Allows extended search conditions in ticket search of the agent interface. With this feature you can search e. g. ticket title with this kind of conditions like "(*key1*&&*key2*)" or "(*key1*||*key2*)".' =>
            '',
        'Allows extended search conditions in ticket search of the customer interface. With this feature you can search e. g. ticket title with this kind of conditions like "(*key1*&&*key2*)" or "(*key1*||*key2*)".' =>
            '',
        'Allows extended search conditions in ticket search of the generic agent interface. With this feature you can search e. g. ticket title with this kind of conditions like "(*key1*&&*key2*)" or "(*key1*||*key2*)".' =>
            '',
        'Allows generic agent to execute custom command line scripts.' =>
            '',
        'Allows generic agent to execute custom modules.' => '',
        'Allows having a medium format ticket overview (CustomerInfo => 1 - shows also the customer information).' =>
            '',
        'Allows having a small format ticket overview (CustomerInfo => 1 - shows also the customer information).' =>
            '',
        'Allows invalid agents to generate individual-related stats.' => '',
        'Allows the administrators to login as other customers, via the customer user administration panel.' =>
            'Hiermee kunnen beheerders inloggen als andere klanten via het gebruikerspaneel voor klanten.',
        'Allows the administrators to login as other users, via the users administration panel.' =>
            '',
        'Allows to set a new ticket state in the move ticket screen of the agent interface.' =>
            '',
        'Always show RichText if available' => '',
        'Arabic (Saudi Arabia)' => 'Arabisch (Saudi Arabië)',
        'Archive state changed: "%s"' => 'Archiefstatus veranderd: "%s"',
        'ArticleTree' => 'Interactie-boom',
        'Attachments <-> Templates' => 'Bijlagen <-> Sjablonen',
        'Auto Responses <-> Queues' => 'Wachtrijen <-> Automatische antwoorden',
        'AutoFollowUp sent to "%s".' => 'Automatische melding verstuurd aan "%s".',
        'AutoReject sent to "%s".' => 'Automatische afwijzing verstuurd aan "%s".',
        'AutoReply sent to "%s".' => 'Automatische beantwoording verstuurd aan "%s".',
        'Automated line break in text messages after x number of chars.' =>
            '',
        'Automatically lock and set owner to current Agent after opening the move ticket screen of the agent interface.' =>
            '',
        'Automatically lock and set owner to current Agent after selecting for an Bulk Action.' =>
            '',
        'Automatically sets the owner of a ticket as the responsible for it (if ticket responsible feature is enabled). This will only work by manually actions of the logged in user. It does not work for automated actions e.g. GenericAgent, Postmaster and GenericInterface.' =>
            '',
        'Automatically sets the responsible of a ticket (if it is not set yet) after the first owner update.' =>
            '',
        'Balanced white skin by Felix Niklas (slim version).' => '',
        'Balanced white skin by Felix Niklas.' => '',
        'Based on global RichText setting' => '',
        'Basic fulltext index settings. Execute "bin/otrs.Console.pl Maint::Ticket::FulltextIndexRebuild" in order to generate a new index.' =>
            '',
        'Blocks all the incoming emails that do not have a valid ticket number in subject with From: @example.com address.' =>
            '',
        'Bounced to "%s".' => 'Gebounced naar "%s".',
        'Builds an article index right after the article\'s creation.' =>
            '',
        'Bulgarian' => '',
        'CMD example setup. Ignores emails where external CMD returns some output on STDOUT (email will be piped into STDIN of some.bin).' =>
            '',
        'Cache time in seconds for agent authentication in the GenericInterface.' =>
            '',
        'Cache time in seconds for customer authentication in the GenericInterface.' =>
            '',
        'Cache time in seconds for the DB ACL backend.' => '',
        'Cache time in seconds for the DB process backend.' => '',
        'Cache time in seconds for the SSL certificate attributes.' => '',
        'Cache time in seconds for the ticket process navigation bar output module.' =>
            '',
        'Cache time in seconds for the web service config backend.' => '',
        'Catalan' => '',
        'Change password' => 'Wachtwoord wijzigen',
        'Change queue!' => 'Verander wachtrij.',
        'Change the customer for this ticket' => 'Wijzig de klant voor dit ticket',
        'Change the free fields for this ticket' => 'Wijzig de vrije velden voor dit ticket',
        'Change the priority for this ticket' => 'Wijzig de prioriteit voor dit ticket',
        'Change the responsible for this ticket' => '',
        'Changed priority from "%s" (%s) to "%s" (%s).' => 'Prioriteit gewijzigd van "%s" (%s) naar "%s" (%s).',
        'Changes the owner of tickets to everyone (useful for ASP). Normally only agent with rw permissions in the queue of the ticket will be shown.' =>
            '',
        'Checkbox' => 'Checkbox',
        'Checks if an E-Mail is a followup to an existing ticket by searching the subject for a valid ticket number.' =>
            '',
        'Checks the SystemID in ticket number detection for follow-ups (use "No" if SystemID has been changed after using the system).' =>
            '',
        'Checks the availability of OTRS Business Solution™ for this system.' =>
            '',
        'Checks the entitlement status of OTRS Business Solution™.' => '',
        'Chinese (Simplified)' => 'Chinees (Vereenvoudigd)',
        'Chinese (Traditional)' => 'Chinees (Traditioneel)',
        'Choose for which kind of ticket changes you want to receive notifications.' =>
            'Kies voor welk type ticket u notificaties wilt ontvangen.',
        'Closed tickets (customer user)' => 'Gesloten tickets (klant gebruiker)',
        'Closed tickets (customer)' => 'Gesloten tickets (klant)',
        'Cloud Services' => 'Cloud Diensten',
        'Cloud service admin module registration for the transport layer.' =>
            '',
        'Collect support data for asynchronous plug-in modules.' => '',
        'Column ticket filters for Ticket Overviews type "Small".' => '',
        'Columns that can be filtered in the escalation view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '',
        'Columns that can be filtered in the locked view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '',
        'Columns that can be filtered in the queue view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '',
        'Columns that can be filtered in the responsible view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '',
        'Columns that can be filtered in the service view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '',
        'Columns that can be filtered in the status view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '',
        'Columns that can be filtered in the ticket search result view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '',
        'Columns that can be filtered in the watch view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '',
        'Comment for new history entries in the customer interface.' => '',
        'Comment2' => 'Comment2',
        'Communication' => 'Communicatie',
        'Company Status' => 'Klantstatus',
        'Company Tickets.' => 'Bedrijf tickets.',
        'Company name which will be included in outgoing emails as an X-Header.' =>
            '',
        'Compat module for AgentZoom to AgentTicketZoom.' => '',
        'Complex' => '',
        'Configure Processes.' => 'Beheer processen',
        'Configure and manage ACLs.' => 'Beheer ACLs.',
        'Configure any additional readonly mirror databases that you want to use.' =>
            '',
        'Configure sending of support data to OTRS Group for improved support.' =>
            '',
        'Configure which screen should be shown after a new ticket has been created.' =>
            '',
        'Configure your own log text for PGP.' => '',
        'Configures a default TicketDynamicField setting. "Name" defines the dynamic field which should be used, "Value" is the data that will be set, and "Event" defines the trigger event. Please check the developer manual (http://otrs.github.io/doc/), chapter "Ticket Event Module".' =>
            '',
        'Controls how to display the ticket history entries as readable values.' =>
            '',
        'Controls if CustomerID is automatically copied from the sender address for unknown customers.' =>
            '',
        'Controls if CustomerID is read-only in the agent interface.' => '',
        'Controls if customers have the ability to sort their tickets.' =>
            '',
        'Controls if more than one from entry can be set in the new phone ticket in the agent interface.' =>
            '',
        'Controls if the admin is allowed to import a saved system configuration in SysConfig.' =>
            '',
        'Controls if the admin is allowed to make changes to the database via AdminSelectBox.' =>
            '',
        'Controls if the ticket and article seen flags are removed when a ticket is archived.' =>
            '',
        'Converts HTML mails into text messages.' => '',
        'Create New process ticket.' => '',
        'Create Ticket' => '',
        'Create and manage Service Level Agreements (SLAs).' => 'Aanmaken en beheren van Service Level Agreements (SLA\'s).',
        'Create and manage agents.' => 'Aanmaken en beheren van behandelaars.',
        'Create and manage attachments.' => 'Aanmaken en beheren van bijlagen.',
        'Create and manage customer users.' => 'Aanmaken en beheren van klanten.',
        'Create and manage customers.' => 'Aanmaken en beheren van klanten.',
        'Create and manage dynamic fields.' => 'Aanmaken en beheren van dynamische velden.',
        'Create and manage groups.' => 'Aanmaken en beheren van groepen.',
        'Create and manage queues.' => 'Aanmaken en beheren van wachtrijen.',
        'Create and manage responses that are automatically sent.' => 'Aanmaken en beheren van teksten die automatisch naar de klant worden gestuurd.',
        'Create and manage roles.' => 'Aanmaken en beheren van rollen.',
        'Create and manage salutations.' => 'Aanmaken en beheren van aanheffen.',
        'Create and manage services.' => 'Aanmaken en beheren van services.',
        'Create and manage signatures.' => 'Aanmaken en beheren van handtekeningen.',
        'Create and manage templates.' => 'Aanmaken en beheren van sjablonen.',
        'Create and manage ticket notifications.' => '',
        'Create and manage ticket priorities.' => 'Aanmaken en beheren van prioriteiten.',
        'Create and manage ticket states.' => 'Aanmaken en beheren van statussen.',
        'Create and manage ticket types.' => 'Aanmaken en beheren van typen.',
        'Create and manage web services.' => 'Aanmaken en beheren van webservices.',
        'Create new Ticket.' => 'Maak een nieuw ticket.',
        'Create new email ticket and send this out (outbound).' => '',
        'Create new email ticket.' => 'Maak een nieuw e-mail ticket.',
        'Create new phone ticket (inbound).' => 'Maak een nieuw intern telefoon ticket.',
        'Create new phone ticket.' => 'Maak een nieuw telefoon ticket.',
        'Create new process ticket.' => '',
        'Create tickets.' => 'Maak nieuwe ticket.',
        'Croatian' => '',
        'Custom RSS Feed' => '',
        'Custom text for the page shown to customers that have no tickets yet (if you need those text translated add them to a custom translation module).' =>
            '',
        'Customer Administration' => 'Klantbeheer.',
        'Customer Information Center Search.' => '',
        'Customer Information Center.' => '',
        'Customer Ticket Print Module.' => '',
        'Customer User <-> Groups' => 'Klanten <-> Groepen',
        'Customer User <-> Services' => 'Klanten <-> Services',
        'Customer User Administration' => 'Beheren van klanten',
        'Customer Users' => 'Klanten',
        'Customer called us.' => 'Klant heeft gebeld.',
        'Customer item (icon) which shows the closed tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            '',
        'Customer item (icon) which shows the open tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            '',
        'Customer preferences.' => '',
        'Customer request via web.' => 'Klant stelt vraag via web.',
        'Customer ticket overview' => 'Klant ticket overview',
        'Customer ticket search.' => '',
        'Customer ticket zoom' => '',
        'Customer user search' => '',
        'CustomerID search' => '',
        'CustomerName' => '',
        'CustomerUser' => '',
        'Customers <-> Groups' => 'Klanten <-> Groepen',
        'Customizable stop words for fulltext index. These words will be removed from the search index.' =>
            '',
        'Czech' => '',
        'DEPRECATED: This config setting will be removed in further versions of OTRS. Sets the time (in seconds) a user is marked as active (minimum active time is 300 seconds).' =>
            '',
        'Danish' => 'Deens',
        'Data used to export the search result in CSV format.' => '',
        'Date / Time' => 'Datum / tijd',
        'Debug' => 'Debug',
        'Debugs the translation set. If this is set to "Yes" all strings (text) without translations are written to STDERR. This can be helpful when you are creating a new translation file. Otherwise, this option should remain set to "No".' =>
            '',
        'Default' => '',
        'Default (Slim)' => '',
        'Default ACL values for ticket actions.' => '',
        'Default ProcessManagement entity prefixes for entity IDs that are automatically generated.' =>
            '',
        'Default agent name' => '',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimePointFormat=year;TicketCreateTimePointStart=Last;TicketCreateTimePoint=2;".' =>
            '',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimeStartYear=2010;TicketCreateTimeStartMonth=10;TicketCreateTimeStartDay=4;TicketCreateTimeStopYear=2010;TicketCreateTimeStopMonth=11;TicketCreateTimeStopDay=3;".' =>
            '',
        'Default display type for recipient (To,Cc) names in AgentTicketZoom and CustomerTicketZoom.' =>
            '',
        'Default display type for sender (From) names in AgentTicketZoom and CustomerTicketZoom.' =>
            '',
        'Default loop protection module.' => '',
        'Default queue ID used by the system in the agent interface.' => '',
        'Default skin for the agent interface (slim version).' => '',
        'Default skin for the agent interface.' => '',
        'Default skin for the customer interface.' => '',
        'Default ticket ID used by the system in the agent interface.' =>
            '',
        'Default ticket ID used by the system in the customer interface.' =>
            '',
        'Default value for NameX' => '',
        'Define Actions where a settings button is available in the linked objects widget (LinkObject::ViewMode = "complex"). Please note that these Actions must have registered the following JS and CSS files: Core.AllocationList.css, Core.UI.AllocationList.js, Core.UI.Table.Sort.js, Core.Agent.TableFilters.js.' =>
            '',
        'Define a filter for html output to add links behind a defined string. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            '',
        'Define a mapping between variables of the customer user data (keys) and dynamic fields of a ticket (values). The purpose is to store customer user data in ticket dynamic fields. The dynamic fields must be present in the system and should be enabled for AgentTicketFreeText, so that they can be set/updated manually by the agent. They mustn\'t be enabled for AgentTicketPhone, AgentTicketEmail and AgentTicketCustomer. If they were, they would have precedence over the automatically set values. To use this mapping, you have to also activate the next setting below.' =>
            '',
        'Define dynamic field name for end time. This field has to be manually added to the system as Ticket: "Date / Time" and must be activated in ticket creation screens and/or in any other ticket action screens.' =>
            '',
        'Define dynamic field name for start time. This field has to be manually added to the system as Ticket: "Date / Time" and must be activated in ticket creation screens and/or in any other ticket action screens.' =>
            '',
        'Define the max depth of queues.' => '',
        'Define the queue comment 2.' => '',
        'Define the service comment 2.' => '',
        'Define the sla comment 2.' => '',
        'Define the start day of the week for the date picker for the indicated calendar.' =>
            '',
        'Define the start day of the week for the date picker.' => '',
        'Define which columns are shown in the linked tickets widget (LinkObject::ViewMode = "complex"). Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.' =>
            '',
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
        'Defines a filter to collect CVE numbers from article texts in AgentTicketZoom. The results will be displayed in a meta box next to the article. Fill in URLPreview if you would like to see a preview when moving your mouse cursor above the link element. This could be the same URL as in URL, but also an alternate one. Please note that some websites deny being displayed within an iframe (e.g. Google) and thus won\'t work with the preview mode.' =>
            '',
        'Defines a filter to process the text in the articles, in order to highlight predefined keywords.' =>
            '',
        'Defines a regular expression that excludes some addresses from the syntax check (if "CheckEmailAddresses" is set to "Yes"). Please enter a regex in this field for email addresses, that aren\'t syntactically valid, but are necessary for the system (i.e. "root@localhost").' =>
            '',
        'Defines a regular expression that filters all email addresses that should not be used in the application.' =>
            '',
        'Defines a sleep time in microseconds between tickets while they are been processed by a job.' =>
            '',
        'Defines a useful module to load specific user options or to display news.' =>
            '',
        'Defines all the X-headers that should be scanned.' => '',
        'Defines all the languages that are available to the application. Specify only English names of languages here.' =>
            'Definieert alle talen die beschikbaar zijn voor de toepassing. Geef hier alleen Engelse namen van talen op.',
        'Defines all the languages that are available to the application. Specify only native names of languages here.' =>
            'Definieert alle talen die beschikbaar zijn voor de toepassing. Geef hier alleen de native namen van talen op.',
        'Defines all the parameters for the RefreshTime object in the customer preferences of the customer interface.' =>
            '',
        'Defines all the parameters for the ShownTickets object in the customer preferences of the customer interface.' =>
            '',
        'Defines all the parameters for this item in the customer preferences.' =>
            '',
        'Defines all the parameters for this item in the customer preferences. \'PasswordRegExp\' allows to match passwords against a regular expression. Define the minimum number of characters using \'PasswordMinSize\'. Define if at least 2 lowercase and 2 uppercase letter characters are needed by setting the appropriate option to \'1\'. \'PasswordMin2Characters\' defines if the password needs to contain at least 2 letter characters (set to 0 or 1). \'PasswordNeedDigit\' controls the need of at least 1 digit (set to 0 or 1 to control).' =>
            '',
        'Defines all the parameters for this notification transport.' => '',
        'Defines all the possible stats output formats.' => '',
        'Defines an alternate URL, where the login link refers to.' => '',
        'Defines an alternate URL, where the logout link refers to.' => '',
        'Defines an alternate login URL for the customer panel..' => '',
        'Defines an alternate logout URL for the customer panel.' => '',
        'Defines an external link to the database of the customer (e.g. \'http://yourhost/customer.php?CID=[% Data.CustomerID %]\' or \'\').' =>
            '',
        'Defines from which ticket attributes the agent can select the result order.' =>
            '',
        'Defines how the From field from the emails (sent from answers and email tickets) should look like.' =>
            '',
        'Defines if a pre-sorting by priority should be done in the queue view.' =>
            '',
        'Defines if a pre-sorting by priority should be done in the service view.' =>
            '',
        'Defines if a ticket lock is required in the close ticket screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the email outbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
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
        'Defines if agents should be allowed to login if they have no shared secret stored in their preferences and therefore are not using two-factor authentication.' =>
            'Bepaalt of behandelaars zouden kunnen inloggen als ze geen gedeeld sleutel hebben opgeslagen in hun voorkeuren en daarmee geen gebruik maken van twee stappen authenticatie.',
        'Defines if composed messages have to be spell checked in the agent interface.' =>
            '',
        'Defines if customers should be allowed to login if they have no shared secret stored in their preferences and therefore are not using two-factor authentication.' =>
            'Bepaalt of klanten zouden kunnen inloggen als ze geen gedeeld sleutel hebben opgeslagen in hun voorkeuren en daarmee geen gebruik maken van twee stappen authenticatie.',
        'Defines if the enhanced mode should be used (enables use of table, replace, subscript, superscript, paste from word, etc.) in customer interface.' =>
            '',
        'Defines if the enhanced mode should be used (enables use of table, replace, subscript, superscript, paste from word, etc.).' =>
            '',
        'Defines if the previously valid token should be accepted for authentication. This is slightly less secure but gives users 30 seconds more time to enter their one-time password.' =>
            '',
        'Defines if the values for filters should be retrieved from all available tickets. If set to "Yes", only values which are actually used in any ticket will be available for filtering. Please note: The list of customers will always be retrieved like this.' =>
            '',
        'Defines if time accounting is mandatory in the agent interface. If activated, a note must be entered for all ticket actions (no matter if the note itself is configured as active or is originally mandatory for the individual ticket action screen).' =>
            '',
        'Defines if time accounting must be set to all tickets in bulk action.' =>
            '',
        'Defines out of office message template. Two string parameters (%s) available: end date and number of days left.' =>
            '',
        'Defines queues that\'s tickets are used for displaying as calendar events.' =>
            '',
        'Defines the HTTP hostname for the support data collection with the public module \'PublicSupportDataCollector\' (e.g. used from the OTRS Daemon).' =>
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
        'Defines the agent preferences key where the shared secret key is stored.' =>
            'Definieert voor de behandelaar waar de gedeelde sleutel wordt opgeslagen.',
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
        'Defines the calendar width in percent. Default is 95%.' => '',
        'Defines the cluster node identifier. This is only used in cluster configurations where there is more than one OTRS frontend system. Note: only values from 1 to 99 are allowed.' =>
            '',
        'Defines the column to store the keys for the preferences table.' =>
            '',
        'Defines the config options for the autocompletion feature.' => '',
        'Defines the config parameters of this item, to be shown in the preferences view.' =>
            '',
        'Defines the config parameters of this item, to be shown in the preferences view. \'PasswordRegExp\' allows to match passwords against a regular expression. Define the minimum number of characters using \'PasswordMinSize\'. Define if at least 2 lowercase and 2 uppercase letter characters are needed by setting the appropriate option to \'1\'. \'PasswordMin2Characters\' defines if the password needs to contain at least 2 letter characters (set to 0 or 1). \'PasswordNeedDigit\' controls the need of at least 1 digit (set to 0 or 1 to control). \'PasswordMaxLoginFailed\' allows to set an agent to invalid-temporarily if max failed logins reached.' =>
            '',
        'Defines the config parameters of this item, to be shown in the preferences view. Take care to maintain the dictionaries installed in the system in the data section.' =>
            '',
        'Defines the connections for http/ftp, via a proxy.' => '',
        'Defines the customer preferences key where the shared secret key is stored.' =>
            'Definieert voor de klanten waar de gedeelde sleutel wordt opgeslagen.',
        'Defines the date input format used in forms (option or input fields).' =>
            '',
        'Defines the default CSS used in rich text editors.' => '',
        'Defines the default agent name in the ticket zoom view of the customer interface.' =>
            '',
        'Defines the default auto response type of the article for this operation.' =>
            '',
        'Defines the default body of a note in the ticket free text screen of the agent interface.' =>
            '',
        'Defines the default front-end (HTML) theme to be used by the agents and customers. If you like, you can add your own theme. Please refer the administrator manual located at http://otrs.github.io/doc/.' =>
            '',
        'Defines the default front-end language. All the possible values are determined by the available language files on the system (see the next setting).' =>
            'Definieert de standaard front-endtaal. Alle mogelijke waarden worden bepaald door de beschikbare taalbestanden op het systeem (zie de volgende instelling).',
        'Defines the default history type in the customer interface.' => '',
        'Defines the default maximum number of X-axis attributes for the time scale.' =>
            '',
        'Defines the default maximum number of statistics per page on the overview screen.' =>
            '',
        'Defines the default next state for a ticket after customer follow-up in the customer interface.' =>
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
        'Defines the default next state of a ticket after the message has been sent, in the email outbound screen of the agent interface.' =>
            '',
        'Defines the default next state of a ticket if it is composed / answered in the ticket compose screen of the agent interface.' =>
            '',
        'Defines the default note body text for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Defines the default note body text for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            '',
        'Defines the default priority of follow-up customer tickets in the ticket zoom screen in the customer interface.' =>
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
        'Defines the default shown ticket search attribute for ticket search screen (AllTickets/ArchivedTickets/NotArchivedTickets).' =>
            '',
        'Defines the default shown ticket search attribute for ticket search screen.' =>
            '',
        'Defines the default shown ticket search attribute for ticket search screen. Example: "Key" must have the name of the Dynamic Field in this case \'X\', "Content" must have the value of the Dynamic Field depending on the Dynamic Field type,  Text: \'a text\', Dropdown: \'1\', Date/Time: \'Search_DynamicField_XTimeSlotStartYear=1974; Search_DynamicField_XTimeSlotStartMonth=01; Search_DynamicField_XTimeSlotStartDay=26; Search_DynamicField_XTimeSlotStartHour=00; Search_DynamicField_XTimeSlotStartMinute=00; Search_DynamicField_XTimeSlotStartSecond=00; Search_DynamicField_XTimeSlotStopYear=2013; Search_DynamicField_XTimeSlotStopMonth=01; Search_DynamicField_XTimeSlotStopDay=26; Search_DynamicField_XTimeSlotStopHour=23; Search_DynamicField_XTimeSlotStopMinute=59; Search_DynamicField_XTimeSlotStopSecond=59;\' and or \'Search_DynamicField_XTimePointFormat=week; Search_DynamicField_XTimePointStart=Before; Search_DynamicField_XTimePointValue=7\';.' =>
            '',
        'Defines the default sort criteria for all queues displayed in the queue view.' =>
            '',
        'Defines the default sort criteria for all services displayed in the service view.' =>
            '',
        'Defines the default sort order for all queues in the queue view, after priority sort.' =>
            '',
        'Defines the default sort order for all services in the service view, after priority sort.' =>
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
        'Defines the default the number of seconds (from current time) to re-schedule a generic interface failed task.' =>
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
        'Defines the default ticket attribute for ticket sorting of the ticket search result of this operation.' =>
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
        'Defines the default ticket order in the ticket search result of the this operation. Up: oldest on top. Down: latest on top.' =>
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
        'Defines the default ticket type.' => '',
        'Defines the default type for article in the customer interface.' =>
            '',
        'Defines the default type of forwarded message in the ticket forward screen of the agent interface.' =>
            '',
        'Defines the default type of the article for this operation.' => '',
        'Defines the default type of the message in the email outbound screen of the agent interface.' =>
            '',
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
        'Defines the displayed style of the From field in notes that are visible for customers. A default agent name can be defined in Ticket::Frontend::CustomerTicketZoom###DefaultAgentName setting.' =>
            '',
        'Defines the dynamic fields that are used for displaying on calendar events.' =>
            '',
        'Defines the fall-back path to open fetchmail binary. Note: The name of the binary needs to be \'fetchmail\', if it is different please use a symbolic link.' =>
            '',
        'Defines the filter that processes the text in the articles, in order to highlight URLs.' =>
            '',
        'Defines the format of responses in the ticket compose screen of the agent interface ([% Data.OrigFrom | html %] is From 1:1, [% Data.OrigFromName | html %] is only realname of From).' =>
            '',
        'Defines the fully qualified domain name of the system. This setting is used as a variable, OTRS_CONFIG_FQDN which is found in all forms of messaging used by the application, to build links to the tickets within your system.' =>
            '',
        'Defines the groups every customer user will be in (if CustomerGroupSupport is enabled and you don\'t want to manage every user for these groups).' =>
            '',
        'Defines the height for the rich text editor component for this screen. Enter number (pixels) or percent value (relative).' =>
            '',
        'Defines the height for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            '',
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
        'Defines the list of possible next actions on an error screen, a full path is required, then is possible to add external links if needed.' =>
            '',
        'Defines the list of types for templates.' => '',
        'Defines the location to get online repository list for additional packages. The first available result will be used.' =>
            '',
        'Defines the log module for the system. "File" writes all messages in a given logfile, "SysLog" uses the syslog daemon of the system, e.g. syslogd.' =>
            '',
        'Defines the maximal size (in bytes) for file uploads via the browser. Warning: Setting this option to a value which is too low could cause many masks in your OTRS instance to stop working (probably any mask which takes input from the user).' =>
            '',
        'Defines the maximal valid time (in seconds) for a session id.' =>
            '',
        'Defines the maximum number of affected tickets per job.' => '',
        'Defines the maximum number of pages per PDF file.' => '',
        'Defines the maximum number of quoted lines to be added to responses.' =>
            '',
        'Defines the maximum number of tasks to be executed as the same time.' =>
            '',
        'Defines the maximum size (in MB) of the log file.' => '',
        'Defines the maximum size in KiloByte of GenericInterface responses that get logged to the gi_debugger_entry_content table.' =>
            '',
        'Defines the module that shows a generic notification in the agent interface. Either "Text" - if configured - or the contents of "File" will be displayed.' =>
            '',
        'Defines the module that shows all the currently logged in agents in the agent interface.' =>
            '',
        'Defines the module that shows all the currently logged in customers in the agent interface.' =>
            '',
        'Defines the module that shows the currently logged in agents in the customer interface.' =>
            '',
        'Defines the module that shows the currently logged in customers in the customer interface.' =>
            '',
        'Defines the module to authenticate customers.' => '',
        'Defines the module to display a notification if cloud services are disabled.' =>
            '',
        'Defines the module to display a notification in different interfaces on different occasions for OTRS Business Solution™.' =>
            '',
        'Defines the module to display a notification in the agent interface if the OTRS Daemon is not running.' =>
            '',
        'Defines the module to display a notification in the agent interface, if the agent is logged in while having out-of-office active.' =>
            '',
        'Defines the module to display a notification in the agent interface, if the agent is logged in while having system maintenance active.' =>
            '',
        'Defines the module to display a notification in the agent interface, if the agent session limit prior warning is reached.' =>
            '',
        'Defines the module to display a notification in the agent interface, if the system is used by the admin user (normally you shouldn\'t work as admin).' =>
            '',
        'Defines the module to generate code for periodic page reloads.' =>
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
        'Defines the name of the table where the user preferences are stored.' =>
            '',
        'Defines the next possible states after composing / answering a ticket in the ticket compose screen of the agent interface.' =>
            '',
        'Defines the next possible states after forwarding a ticket in the ticket forward screen of the agent interface.' =>
            '',
        'Defines the next possible states after sending a message in the email outbound screen of the agent interface.' =>
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
        'Defines the number of character per line used in case an HTML article preview replacement on TemplateGenerator for EventNotifications.' =>
            '',
        'Defines the number of days to keep the daemon log files.' => '',
        'Defines the number of header fields in frontend modules for add and update postmaster filters. It can be up to 99 fields.' =>
            '',
        'Defines the parameters for the customer preferences table.' => '',
        'Defines the parameters for the dashboard backend. "Cmd" is used to specify command with parameters. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin.' =>
            '',
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
        'Defines the path of the shown info file, that is located under Kernel/Output/HTML/Templates/Standard/CustomerAccept.tt.' =>
            '',
        'Defines the path to PGP binary.' => '',
        'Defines the path to open ssl binary. It may need a HOME env ($ENV{HOME} = \'/var/lib/wwwrun\';).' =>
            '',
        'Defines the postmaster default queue.' => '',
        'Defines the priority in which the information is logged and presented.' =>
            '',
        'Defines the recipient target of the phone ticket and the sender of the email ticket ("Queue" shows all queues, "System address" displays all system addresses) in the agent interface.' =>
            '',
        'Defines the recipient target of the tickets ("Queue" shows all queues, "SystemAddress" shows only the queues which are assigned to system addresses) in the customer interface.' =>
            '',
        'Defines the required permission to show a ticket in the escalation view of the agent interface.' =>
            '',
        'Defines the search limit for the stats.' => '',
        'Defines the sender for rejected emails.' => '',
        'Defines the separator between the agents real name and the given queue email address.' =>
            '',
        'Defines the shown links in the footer area of the customer and public interface of this OTRS system. The value in "Key" is the external URL, the value in "Content" is the shown label.' =>
            '',
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
        'Defines the system identifier. Every ticket number and http session string contains this ID. This ensures that only tickets which belong to your system will be processed as follow-ups (useful when communicating between two instances of OTRS).' =>
            '',
        'Defines the target attribute in the link to external customer database. E.g. \'AsPopup PopupType_TicketAction\'.' =>
            '',
        'Defines the target attribute in the link to external customer database. E.g. \'target="cdb"\'.' =>
            '',
        'Defines the ticket fields that are going to be displayed calendar events. The "Key" defines the field or ticket attribute and the "Content" defines the display name.' =>
            '',
        'Defines the time zone of the indicated calendar, which can be assigned later to a specific queue.' =>
            '',
        'Defines the timeout (in seconds, minimum is 20 seconds) for the support data collection with the public module \'PublicSupportDataCollector\' (e.g. used from the OTRS Daemon).' =>
            '',
        'Defines the two-factor module to authenticate agents.' => '',
        'Defines the two-factor module to authenticate customers.' => '',
        'Defines the type of protocol, used by the web server, to serve the application. If https protocol will be used instead of plain http, it must be specified here. Since this has no affect on the web server\'s settings or behavior, it will not change the method of access to the application and, if it is wrong, it will not prevent you from logging into the application. This setting is only used as a variable, OTRS_CONFIG_HttpType which is found in all forms of messaging used by the application, to build links to the tickets within your system.' =>
            '',
        'Defines the used character for plaintext email quotes in the ticket compose screen of the agent interface. If this is empty or inactive, original emails will not be quoted but appended to the response.' =>
            '',
        'Defines the user identifier for the customer panel.' => '',
        'Defines the username to access the SOAP handle (bin/cgi-bin/rpc.pl).' =>
            '',
        'Defines the valid state types for a ticket.' => '',
        'Defines the valid states for unlocked tickets. To unlock tickets the script "bin/otrs.Console.pl Maint::Ticket::UnlockTimeout" can be used.' =>
            '',
        'Defines the viewable locks of a ticket. NOTE: When you change this setting, make sure to delete the cache in order to use the new value. Default: unlock, tmp_lock.' =>
            '',
        'Defines the width for the rich text editor component for this screen. Enter number (pixels) or percent value (relative).' =>
            '',
        'Defines the width for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            '',
        'Defines which article sender types should be shown in the preview of a ticket.' =>
            '',
        'Defines which items are available for \'Action\' in third level of the ACL structure.' =>
            '',
        'Defines which items are available in first level of the ACL structure.' =>
            '',
        'Defines which items are available in second level of the ACL structure.' =>
            '',
        'Defines which states should be set automatically (Content), after the pending time of state (Key) has been reached.' =>
            '',
        'Defines wich article type should be expanded when entering the overview. If nothing defined, latest article will be expanded.' =>
            '',
        'Defines, which tickets of which ticket state types should not be listed in linked ticket lists.' =>
            '',
        'Delete expired cache from core modules.' => '',
        'Delete expired loader cache weekly (Sunday mornings).' => '',
        'Delete expired sessions.' => '',
        'Deleted link to ticket "%s".' => 'Koppeling naar "%s" verwijderd.',
        'Deletes a session if the session id is used with an invalid remote IP address.' =>
            '',
        'Deletes requested sessions if they have timed out.' => '',
        'Delivers extended debugging information in the frontend in case any AJAX errors occur, if enabled.' =>
            '',
        'Deploy and manage OTRS Business Solution™.' => '',
        'Determines if the list of possible queues to move to ticket into should be displayed in a dropdown list or in a new window in the agent interface. If "New Window" is set you can add a move note to the ticket.' =>
            '',
        'Determines if the statistics module may generate ticket lists.' =>
            '',
        'Determines the next possible ticket states, after the creation of a new email ticket in the agent interface.' =>
            '',
        'Determines the next possible ticket states, after the creation of a new phone ticket in the agent interface.' =>
            '',
        'Determines the next possible ticket states, for process tickets in the agent interface.' =>
            '',
        'Determines the next possible ticket states, for process tickets in the customer interface.' =>
            '',
        'Determines the next screen after new customer ticket in the customer interface.' =>
            '',
        'Determines the next screen after the follow-up screen of a zoomed ticket in the customer interface.' =>
            '',
        'Determines the next screen after the ticket is moved. LastScreenOverview will return the last overview screen (e.g. search results, queueview, dashboard). TicketZoom will return to the TicketZoom.' =>
            '',
        'Determines the possible states for pending tickets that changed state after reaching time limit.' =>
            '',
        'Determines the strings that will be shown as recipient (To:) of the phone ticket and as sender (From:) of the email ticket in the agent interface. For Queue as NewQueueSelectionType "<Queue>" shows the names of the queues and for SystemAddress "<Realname> <<Email>>" shows the name and email of the recipient.' =>
            '',
        'Determines the strings that will be shown as recipient (To:) of the ticket in the customer interface. For Queue as CustomerPanelSelectionType, "<Queue>" shows the names of the queues, and for SystemAddress, "<Realname> <<Email>>" shows the name and email of the recipient.' =>
            '',
        'Determines the way the linked objects are displayed in each zoom mask.' =>
            '',
        'Determines which options will be valid of the recipient (phone ticket) and the sender (email ticket) in the agent interface.' =>
            '',
        'Determines which queues will be valid for ticket\'s recepients in the customer interface.' =>
            '',
        'Disable HTTP header "Content-Security-Policy" to allow loading of external script contents. Disabling this HTTP header can be a security issue! Only disable it, if you know what you are doing!' =>
            '',
        'Disable HTTP header "X-Frame-Options: SAMEORIGIN" to allow OTRS to be included as an IFrame in other websites. Disabling this HTTP header can be a security issue! Only disable it, if you know what you are doing!' =>
            '',
        'Disable restricted security for IFrames in IE. May be required for SSO to work in IE.' =>
            '',
        'Disables sending reminder notifications to the responsible agent of a ticket (Ticket::Responsible needs to be activated).' =>
            '',
        'Disables the communication between this system and OTRS Group servers that provides cloud services. If active, some functionality will be lost such as system registration, support data sending, upgrading to and use of OTRS Business Solution™, OTRS Verify™, OTRS News and product News dashboard widgets, among others.' =>
            '',
        'Disables the web installer (http://yourhost.example.com/otrs/installer.pl), to prevent the system from being hijacked. If set to "No", the system can be reinstalled and the current basic configuration will be used to pre-populate the questions within the installer script. If not active, it also disables the GenericAgent, PackageManager and SQL Box.' =>
            '',
        'Display a warning and prevent search when using stop words within fulltext search.' =>
            '',
        'Display settings to override defaults for Process Tickets.' => '',
        'Displays the accounted time for an article in the ticket zoom view.' =>
            '',
        'Dropdown' => '',
        'Dutch stop words for fulltext index. These words will be removed from the search index.' =>
            '',
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
        'Dynamic fields shown in the email outbound screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
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
        'Dynamic fields shown in the ticket small format overview screen of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.' =>
            '',
        'Dynamic fields shown in the ticket zoom screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'DynamicField' => '',
        'DynamicField backend registration.' => '',
        'DynamicField object registration.' => '',
        'E-Mail Outbound' => '',
        'Edit Customer Companies.' => '',
        'Edit Customer Users.' => '',
        'Edit customer company' => 'Bedrijf aanpassen',
        'Email Addresses' => 'E-mailadressen',
        'Email Outbound' => '',
        'Email sent to "%s".' => 'E-mail verstuurd aan "%s".',
        'Email sent to customer.' => 'E-mail verzonden aan behandelaar.',
        'Enable keep-alive connection header for SOAP responses.' => '',
        'Enabled filters.' => '',
        'Enables PGP support. When PGP support is enabled for signing and encrypting mail, it is HIGHLY recommended that the web server runs as the OTRS user. Otherwise, there will be problems with the privileges when accessing .gnupg folder.' =>
            '',
        'Enables S/MIME support.' => '',
        'Enables customers to create their own accounts.' => '',
        'Enables fetch S/MIME from CustomerUser backend support.' => '',
        'Enables file upload in the package manager frontend.' => '',
        'Enables or disables the caching for templates. WARNING: Do NOT disable template caching for production environments for it will cause a massive performance drop! This setting should only be disabled for debugging reasons!' =>
            '',
        'Enables or disables the debug mode over frontend interface.' => '',
        'Enables or disables the ticket watcher feature, to keep track of tickets without being the owner nor the responsible.' =>
            '',
        'Enables performance log (to log the page response time). It will affect the system performance. Frontend::Module###AdminPerformanceLog must be enabled.' =>
            '',
        'Enables spell checker support.' => '',
        'Enables the minimal ticket counter size (if "Date" was selected as TicketNumberGenerator).' =>
            '',
        'Enables ticket bulk action feature for the agent frontend to work on more than one ticket at a time.' =>
            '',
        'Enables ticket bulk action feature only for the listed groups.' =>
            '',
        'Enables ticket responsible feature, to keep track of a specific ticket.' =>
            '',
        'Enables ticket watcher feature only for the listed groups.' => '',
        'English (Canada)' => 'Engels (Canada)',
        'English (United Kingdom)' => 'Engels (Verenigd Koninkrijk)',
        'English (United States)' => 'Engels (Verenigde Staten)',
        'English stop words for fulltext index. These words will be removed from the search index.' =>
            'Engelse stopwoorden voor volledige text zoek index. Deze woorden worden verwijderd van de zoek index.',
        'Enroll process for this ticket' => 'Inschrijfproces voor dit ticket',
        'Enter your shared secret to enable two factor authentication.' =>
            'Voer hier je gedeelde sleutel in om twee factor authenticatie te activeren.',
        'Escalation response time finished' => 'Escalatie antwoord tijd beëindigd',
        'Escalation response time forewarned' => 'Escalatie antwoord tijd waarschuwing',
        'Escalation response time in effect' => '',
        'Escalation solution time finished' => '',
        'Escalation solution time forewarned' => '',
        'Escalation solution time in effect' => '',
        'Escalation update time finished' => '',
        'Escalation update time forewarned' => '',
        'Escalation update time in effect' => '',
        'Escalation view' => 'Escalatieoverzicht',
        'EscalationTime' => 'EscalatieTijd',
        'Estonian' => 'Estlands',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate).' =>
            '',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate). This is only possible if all Ticket dynamic fields need the same event.' =>
            '',
        'Event module that performs an update statement on TicketIndex to rename the queue name there if needed and if StaticDB is actually used.' =>
            '',
        'Event module that updates customer user search profiles if login changes.' =>
            '',
        'Event module that updates customer user service membership if login changes.' =>
            '',
        'Event module that updates customer users after an update of the Customer.' =>
            '',
        'Event module that updates tickets after an update of the Customer User.' =>
            '',
        'Event module that updates tickets after an update of the Customer.' =>
            '',
        'Events Ticket Calendar' => 'Gebeurtenissen Ticket Kalender',
        'Execute SQL statements.' => 'Voer SQL statements uit op de database.',
        'Executes a custom command or module. Note: if module is used, function is required.' =>
            '',
        'Executes follow-up checks on In-Reply-To or References headers for mails that don\'t have a ticket number in the subject.' =>
            '',
        'Executes follow-up checks on attachment contents for mails that don\'t have a ticket number in the subject.' =>
            '',
        'Executes follow-up checks on email body for mails that don\'t have a ticket number in the subject.' =>
            '',
        'Executes follow-up checks on the raw source email for mails that don\'t have a ticket number in the subject.' =>
            '',
        'Exports the whole article tree in search result (it can affect the system performance).' =>
            '',
        'Fetch emails via fetchmail (using SSL).' => 'Haal e-mails op via fetchmail (met gebruik van SSL).',
        'Fetch emails via fetchmail.' => 'Haal e-mails op via fetchmail.',
        'Fetch incoming emails from configured mail accounts.' => 'Haal binnenkomende e-mails op van ingestelde mail accounts.',
        'Fetches packages via proxy. Overwrites "WebUserAgent::Proxy".' =>
            '',
        'File that is displayed in the Kernel::Modules::AgentInfo module, if located under Kernel/Output/HTML/Templates/Standard/AgentInfo.tt.' =>
            '',
        'Filter for debugging ACLs. Note: More ticket attributes can be added in the format <OTRS_TICKET_Attribute> e.g. <OTRS_TICKET_Priority>.' =>
            'Filter voor het debuggen van ACLs. Extra ticket attributen kunnen worden toegevoegd in het format: <OTRS_TICKET_Attribute>, bijvoorbeeld <OTRS_TICKET_Priority>.',
        'Filter for debugging Transitions. Note: More filters can be added in the format <OTRS_TICKET_Attribute> e.g. <OTRS_TICKET_Priority>.' =>
            'Filter voor het debuggen van Transities. Extra ticket attributen kunnen worden toegevoegd in het format: <OTRS_TICKET_Attribute>, bijvoorbeeld <OTRS_TICKET_Priority>.',
        'Filter incoming emails.' => 'Filter inkomende e-mails.',
        'Finnish' => 'Fins',
        'First Queue' => 'Eerste Wachtrij',
        'FirstLock' => 'EersteLock',
        'FirstResponse' => 'EersteAntwoord',
        'FirstResponseDiffInMin' => 'EersteAntwoordVerschilInMin',
        'FirstResponseInMin' => 'EersteAntwoordInMin',
        'Firstname Lastname' => 'Voornaam Achternaam',
        'Firstname Lastname (UserLogin)' => 'Voornaam Achternaam (Loginnaam)',
        'FollowUp for [%s]. %s' => 'Vervolg vraag voor [%s]. %s',
        'Forces encoding of outgoing emails (7bit|8bit|quoted-printable|base64).' =>
            '',
        'Forces to choose a different ticket state (from current) after lock action. Define the current state as key, and the next state after lock action as content.' =>
            '',
        'Forces to unlock tickets after being moved to another queue.' =>
            'Dwingt om tickets vrij te geven wanneer ze naar een nieuwe wachtrij worden verplaatst.',
        'Forwarded to "%s".' => 'Doorgestuurd aan "%s".',
        'French' => 'Frans',
        'French (Canada)' => 'Frans (Canada)',
        'French stop words for fulltext index. These words will be removed from the search index.' =>
            '',
        'Frontend' => '',
        'Frontend module registration (disable AgentTicketService link if Ticket Service feature is not used).' =>
            '',
        'Frontend module registration (disable company link if no company feature is used).' =>
            '',
        'Frontend module registration (disable ticket processes screen if no process available) for Customer.' =>
            '',
        'Frontend module registration (disable ticket processes screen if no process available).' =>
            '',
        'Frontend module registration for the agent interface.' => '',
        'Frontend module registration for the customer interface.' => '',
        'Frontend module registration for the public interface.' => '',
        'Frontend theme' => 'Thema',
        'Frontend theme.' => '',
        'Full value' => 'Volledige waarde',
        'Fulltext index regex filters to remove parts of the text.' => 'Volledige tekst reguliere expressie om bepaalde gedeelten van de tekst te verwijderen.',
        'Fulltext search' => 'Volledige tekst zoekactie',
        'Galician' => 'Galicische',
        'General ticket data shown in the ticket overviews (fall-back). Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note that TicketNumber can not be disabled, because it is necessary.' =>
            '',
        'Generate dashboard statistics.' => '',
        'Generic Info module.' => '',
        'GenericAgent' => 'Automatische taken',
        'GenericInterface Debugger GUI' => '',
        'GenericInterface Invoker GUI' => '',
        'GenericInterface Operation GUI' => '',
        'GenericInterface TransportHTTPREST GUI' => '',
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
        'German' => '',
        'German stop words for fulltext index. These words will be removed from the search index.' =>
            '',
        'Gives end users the possibility to override the separator character for CSV files, defined in the translation files.' =>
            '',
        'Global Search Module.' => '',
        'Go back' => 'Ga terug',
        'Google Authenticator' => 'Google Authenticator',
        'Graph: Bar Chart' => '',
        'Graph: Line Chart' => '',
        'Graph: Stacked Area Chart' => '',
        'Greek' => 'Grieks',
        'HTML Reference' => '',
        'HTML Reference.' => '',
        'Hebrew' => 'Hebreeuws',
        'Helps to extend your articles full-text search (From, To, Cc, Subject and Body search). Runtime will do full-text searches on live data (it works fine for up to 50.000 tickets). StaticDB will strip all articles and will build an index after article creation, increasing fulltext searches about 50%. To create an initial index use "bin/otrs.Console.pl Maint::Ticket::FulltextIndexRebuild".' =>
            '',
        'Hindi' => 'Hindi',
        'Hungarian' => 'Hongaars',
        'If "DB" was selected for Customer::AuthModule, a database driver (normally autodetection is used) can be specified.' =>
            'Als "DB" is geselecteerd voor Customer::AuthModule, kan hier een database driver worden aangegeven (normaal wordt autodetectie gebruikt).',
        'If "DB" was selected for Customer::AuthModule, a password to connect to the customer table can be specified.' =>
            'Als "DB" is geselecteerd voor Customer::AuthModule, kan hier een wachtwoord worden aangegeven om mee te verbinden met de klanttabel.',
        'If "DB" was selected for Customer::AuthModule, a username to connect to the customer table can be specified.' =>
            'Als "DB" is geselecteerd voor Customer::AuthModule, kan hier een gebruikersnaam worden ingevoerd om te verbinden met de klanttabel.',
        'If "DB" was selected for Customer::AuthModule, the DSN for the connection to the customer table must be specified.' =>
            'Als "DB" is geselecteerd voor Customer::AuthModule, moet hier de DSN voor de verbinding met de klant worden ingevoerd.',
        'If "DB" was selected for Customer::AuthModule, the column name for the CustomerPassword in the customer table must be specified.' =>
            'Als "DB" is geselecteerd voor Customer::AuthModule, moet hier de kolomnaam voor het klant wachtwoord worden opgegeven',
        'If "DB" was selected for Customer::AuthModule, the crypt type of passwords must be specified.' =>
            'Als "DB" is geselecteerd voor Customer::AuthModule, moet hier het versleutelingstype van het wachtwoord worden opgegeven.',
        'If "DB" was selected for Customer::AuthModule, the name of the column for the CustomerKey in the customer table must be specified.' =>
            'Als "DB" is geselecteerd voor Customer::AuthModule, moet hier de kolomnaam worden opgegeven van de unieke naam van de klant.',
        'If "DB" was selected for Customer::AuthModule, the name of the table where your customer data should be stored must be specified.' =>
            'Als "DB" is geselecteerd voor Customer::AuthModule, moet hier de tabel met klantgegevens worden opgegeven.',
        'If "DB" was selected for SessionModule, a table in database where session data will be stored must be specified.' =>
            'Als "DB" is geselecteerd voor Customer::AuthModule, moet hier de table worden opgegeven waar sessiegegevens worden opgeslagen.',
        'If "FS" was selected for SessionModule, a directory where the session data will be stored must be specified.' =>
            'Als "FS" is geselecteerd voor Customer::AuthModule, moet hier een map worden opgegeven waar sessiegegevens worden opgeslagen.',
        'If "HTTPBasicAuth" was selected for Customer::AuthModule, you can specify (by using a RegExp) to strip parts of REMOTE_USER (e. g. for to remove trailing domains). RegExp-Note, $1 will be the new Login.' =>
            'Als "HTTPBasicAuth" is geselecteerd voor Customer::AuthModule, kun je hier (met behulp van een Reg Exp) gedeelten van REMOTE_USER verwijderen (om domeinen aan het einde te verwijderen). RegExp-opmerking, $1 wordt de nieuwe loginnaam.',
        'If "HTTPBasicAuth" was selected for Customer::AuthModule, you can specify to strip leading parts of user names (e. g. for domains like example_domain\user to user).' =>
            'Als "HTTPBasicAuth" is geselecteerd voor Customer::AuthModule, kun je hier aangeve welke voorafgaande gedeelten van gebruikersnamen moeten worden verwijderd (voor gebruikernamen in de vorm voorbeeld_domein\gebruiker).',
        'If "LDAP" was selected for Customer::AuthModule and if you want to add a suffix to every customer login name, specifiy it here, e. g. you just want to write the username user but in your LDAP directory exists user@domain.' =>
            'Als "LDAP" is geselecteerd voor Customer::AuthModule en je wil een achtervoegsel toevoegen aan elke klantnaam, kun je dat hier aangeven, bijvoorbeeld wanneer je alleen de gebruikersnaam wil typen en in de LDAP de gebruiker staat als gebruiker@domein.',
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
        'If active, none of the regular expressions may match the user\'s email address to allow registration.' =>
            '',
        'If active, one of the regular expressions has to match the user\'s email address to allow registration.' =>
            '',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, and authentication to the mail server is needed, a password must be specified.' =>
            '',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, and authentication to the mail server is needed, an username must be specified.' =>
            '',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, the mailhost that sends out the mails must be specified.' =>
            '',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, the port where your mailserver is listening for incoming connections must be specified.' =>
            '',
        'If enabled debugging information for ACLs is logged.' => '',
        'If enabled debugging information for transitions is logged.' => '',
        'If enabled the daemon will redirect the standard error stream to a log file.' =>
            '',
        'If enabled the daemon will redirect the standard output stream to a log file.' =>
            '',
        'If enabled the daemon will use this directory to create its PID files. Note: Please stop the daemon before any change and use this setting only if <$OTRSHome>/var/run/ can not be used.' =>
            '',
        'If enabled, OTRS will deliver all CSS files in minified form. WARNING: If you turn this off, there will likely be problems in IE 7, because it cannot load more than 32 CSS files.' =>
            '',
        'If enabled, OTRS will deliver all JavaScript files in minified form.' =>
            '',
        'If enabled, TicketPhone and TicketEmail will be open in new windows.' =>
            '',
        'If enabled, the OTRS version tag will be removed from the Webinterface, the HTTP headers and the X-Headers of outgoing mails. NOTE: If you change this option, please make sure to delete the cache.' =>
            '',
        'If enabled, the customer can search for tickets in all services (regardless what services are assigned to the customer).' =>
            '',
        'If enabled, the different overviews (Dashboard, LockedView, QueueView) will automatically refresh after the specified time.' =>
            'Indien geactiveerd worden de verschillende overzichten (Dashboard, vergrendelde tickets, wachtrijoverzicht) automatisch ververst na de ingestelde tijd.',
        'If enabled, the first level of the main menu opens on mouse hover (instead of click only).' =>
            '',
        'If no SendmailNotificationEnvelopeFrom is specified, this setting makes it possible to use the email\'s from address instead of an empty envelope sender (required in certain mail server configurations).' =>
            '',
        'If set, this address is used as envelope sender header in outgoing notifications. If no address is specified, the envelope sender header is empty (unless SendmailNotificationEnvelopeFrom::FallbackToEmailFrom is set).' =>
            '',
        'If set, this address is used as envelope sender in outgoing messages (not notifications - see below). If no address is specified, the envelope sender is equal to queue e-mail address.' =>
            '',
        'If this option is disabled, articles will not automatically be decrypted and stored in the database. Please note that this also means no decryption will take place and the articles will be shown in ticket zoom in their original (encrypted) form.' =>
            '',
        'If this option is set to \'Yes\', tickets created via the web interface, via Customers or Agents, will receive an autoresponse if configured. If this option is set to \'No\', no autoresponses will be sent.' =>
            '',
        'If this regex matches, no message will be send by the autoresponder.' =>
            '',
        'If this setting is active, local modifications will not be highlighted as errors in the package manager and support data collector.' =>
            '',
        'If you\'re going to be out of office, you may wish to let other users know by setting the exact dates of your absence.' =>
            'Als u langere tijd afwezig bent kunt u hier de gebruikers precies laten weten wanneer u afwezig bent.',
        'Ignore system sender article types (e. g. auto responses or email notifications) to be flagged as \'Unread Article\' in AgentTicketZoom or expanded automatically in Large view screens.' =>
            '',
        'Include tickets of subqueues per default when selecting a queue.' =>
            '',
        'Include unknown customers in ticket filter.' => '',
        'Includes article create times in the ticket search of the agent interface.' =>
            '',
        'Incoming Phone Call.' => '',
        'IndexAccelerator: to choose your backend TicketViewAccelerator module. "RuntimeDB" generates each queue view on the fly from ticket table (no performance problems up to approx. 60.000 tickets in total and 6.000 open tickets in the system). "StaticDB" is the most powerful module, it uses an extra ticket-index table that works like a view (recommended if more than 80.000 and 6.000 open tickets are stored in the system). Use the command "bin/otrs.Console.pl Maint::Ticket::QueueIndexRebuild" for initial index creation.' =>
            '',
        'Indonesian' => '',
        'Input' => '',
        'Install ispell or aspell on the system, if you want to use a spell checker. Please specify the path to the aspell or ispell binary on your operating system.' =>
            '',
        'Interface language' => 'Taal',
        'It is possible to configure different skins, for example to distinguish between diferent agents, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            '',
        'It is possible to configure different skins, for example to distinguish between diferent customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            '',
        'It is possible to configure different themes, for example to distinguish between agents and customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid theme on your system. Please see the example entries for the proper form of the regex.' =>
            '',
        'Italian' => '',
        'Italian stop words for fulltext index. These words will be removed from the search index.' =>
            '',
        'Ivory' => '',
        'Ivory (Slim)' => '',
        'Japanese' => '',
        'JavaScript function for the search frontend.' => '',
        'Last customer subject' => '',
        'Lastname Firstname' => '',
        'Lastname Firstname (UserLogin)' => '',
        'Lastname, Firstname' => '',
        'Lastname, Firstname (UserLogin)' => '',
        'Latvian' => '',
        'Left' => '',
        'Link Object' => 'Koppel object',
        'Link Object.' => '',
        'Link agents to groups.' => 'Koppel gebruikers aan groepen.',
        'Link agents to roles.' => 'Koppel gebruikers aan rollen.',
        'Link attachments to templates.' => 'Koppel bijlagen aan sjablonen.',
        'Link customer user to groups.' => 'Koppel klanten aan groepen.',
        'Link customer user to services.' => 'Koppel klanten aan services.',
        'Link queues to auto responses.' => 'Koppel wachtrijen aan automatische antwoorden.',
        'Link roles to groups.' => 'Koppel rollen aan groepen.',
        'Link templates to queues.' => 'Koppel sjablonen aan wachtrijen.',
        'Links 2 tickets with a "Normal" type link.' => 'Koppelt twee tickets met een "Normaal"-type koppeling.',
        'Links 2 tickets with a "ParentChild" type link.' => 'Koppelt twee tickets met een "vader - zoon"-type koppeling.',
        'List of CSS files to always be loaded for the agent interface.' =>
            '',
        'List of CSS files to always be loaded for the customer interface.' =>
            '',
        'List of JS files to always be loaded for the agent interface.' =>
            '',
        'List of JS files to always be loaded for the customer interface.' =>
            '',
        'List of all CustomerCompany events to be displayed in the GUI.' =>
            '',
        'List of all CustomerUser events to be displayed in the GUI.' => '',
        'List of all DynamicField events to be displayed in the GUI.' => '',
        'List of all Package events to be displayed in the GUI.' => '',
        'List of all article events to be displayed in the GUI.' => '',
        'List of all queue events to be displayed in the GUI.' => '',
        'List of all ticket events to be displayed in the GUI.' => '',
        'List of default Standard Templates which are assigned automatically to new Queues upon creation.' =>
            'Lijst van standaard sjablonen die automatisch gekoppeld worden bij het aanmaken van een wachtrij.',
        'List of responsive CSS files to always be loaded for the agent interface.' =>
            '',
        'List of responsive CSS files to always be loaded for the customer interface.' =>
            '',
        'List view' => '',
        'Lithuanian' => '',
        'Lock / unlock this ticket' => '',
        'Locked Tickets.' => '',
        'Locked ticket.' => 'Ticket vergrendeld.',
        'Log file for the ticket counter.' => '',
        'Logged-In Users' => '',
        'Logout of customer panel.' => '',
        'Loop-Protection! No auto-response sent to "%s".' => 'Lus beveiliging! Geen automatisch antwoord verstuurd aan "%s".',
        'Mail Accounts' => '',
        'Main menu registration.' => '',
        'Makes the application block external content loading.' => '',
        'Makes the application check the MX record of email addresses before sending an email or submitting a telephone or email ticket.' =>
            '',
        'Makes the application check the syntax of email addresses.' => '',
        'Makes the session management use html cookies. If html cookies are disabled or if the client browser disabled html cookies, then the system will work as usual and append the session id to the links.' =>
            '',
        'Malay' => '',
        'Manage OTRS Group cloud services.' => '',
        'Manage PGP keys for email encryption.' => 'Beheer PGP-sleutels voor encryptie van e-mail.',
        'Manage POP3 or IMAP accounts to fetch email from.' => 'Beheer POP3 of IMAP accounts om e-mail van op te halen en om te zetten in tickets.',
        'Manage S/MIME certificates for email encryption.' => 'Beheer S/MIME certificaten voor encryptie van e-mail.',
        'Manage existing sessions.' => 'Beheer sessies van klanten en gebruikers.',
        'Manage support data.' => 'Beheer support gegevens.',
        'Manage system registration.' => 'Beheer systeemregistratie.',
        'Manage tasks triggered by event or time based execution.' => 'Beheer van taken op basis van events of tijdschema\'s',
        'Mark this ticket as junk!' => '',
        'Max size (in characters) of the customer information table (phone and email) in the compose screen.' =>
            '',
        'Max size (in rows) of the informed agents box in the agent interface.' =>
            '',
        'Max size (in rows) of the involved agents box in the agent interface.' =>
            '',
        'Max size of the subjects in an email reply and in some overview screens.' =>
            '',
        'Maximal auto email responses to own email-address a day (Loop-Protection).' =>
            '',
        'Maximal size in KBytes for mails that can be fetched via POP3/POP3S/IMAP/IMAPS (KBytes).' =>
            '',
        'Maximum Number of a calendar shown in a dropdown.' => '',
        'Maximum length (in characters) of the dynamic field in the article of the ticket zoom view.' =>
            '',
        'Maximum length (in characters) of the dynamic field in the sidebar of the ticket zoom view.' =>
            '',
        'Maximum number of tickets to be displayed in the result of a search in the agent interface.' =>
            '',
        'Maximum number of tickets to be displayed in the result of a search in the customer interface.' =>
            '',
        'Maximum number of tickets to be displayed in the result of this operation.' =>
            '',
        'Maximum size (in characters) of the customer information table in the ticket zoom view.' =>
            '',
        'Merge this ticket and all articles into another ticket' => '',
        'Merged Ticket <OTRS_TICKET> to <OTRS_MERGE_TO_TICKET>.' => '',
        'Miscellaneous' => 'Diversen',
        'Module for To-selection in new ticket screen in the customer interface.' =>
            '',
        'Module to check if arrived emails should be marked as email-internal (because of original forwarded internal email). ArticleType and SenderType define the values for the arrived email/article.' =>
            '',
        'Module to check the group permissions for customer access to tickets.' =>
            '',
        'Module to check the group permissions for the access to tickets.' =>
            '',
        'Module to compose signed messages (PGP or S/MIME).' => '',
        'Module to crypt composed messages (PGP or S/MIME).' => '',
        'Module to fetch customer users SMIME certificates of incoming messages.' =>
            '',
        'Module to filter and manipulate incoming messages. Block/ignore all spam email with From: noreply@ address.' =>
            '',
        'Module to filter and manipulate incoming messages. Get a 4 digit number to ticket free text, use regex in Match e. g. From => \'(.+?)@.+?\', and use () as [***] in Set =>.' =>
            '',
        'Module to filter encrypted bodies of incoming messages.' => '',
        'Module to generate accounted time ticket statistics.' => '',
        'Module to generate html OpenSearch profile for short ticket search in the agent interface.' =>
            '',
        'Module to generate html OpenSearch profile for short ticket search in the customer interface.' =>
            '',
        'Module to generate ticket solution and response time statistics.' =>
            '',
        'Module to generate ticket statistics.' => '',
        'Module to grant access if the CustomerID of the ticket matches the CustomerID of the customer.' =>
            '',
        'Module to grant access if the CustomerUserID of the ticket matches the CustomerUserID of the customer.' =>
            '',
        'Module to grant access to any agent that has been involved in a ticket in the past (based on ticket history entries).' =>
            '',
        'Module to grant access to the agent responsible of a ticket.' =>
            '',
        'Module to grant access to the creator of a ticket.' => '',
        'Module to grant access to the owner of a ticket.' => '',
        'Module to grant access to the watcher agents of a ticket.' => '',
        'Module to show notifications and escalations (ShownMax: max. shown escalations, EscalationInMinutes: Show ticket which will escalation in, CacheTime: Cache of calculated escalations in seconds).' =>
            '',
        'Module to use database filter storage.' => '',
        'Multiselect' => 'Multiselect',
        'My Services' => 'Mijn Diensten',
        'My Tickets.' => 'Mijn tickets',
        'Name of custom queue. The custom queue is a queue selection of your preferred queues and can be selected in the preferences settings.' =>
            '',
        'Name of custom service. The custom service is a service selection of your preferred services and can be selected in the preferences settings.' =>
            '',
        'NameX' => 'NaamX',
        'Nederlands' => 'Nederlands',
        'New Ticket [%s] created (Q=%s;P=%s;S=%s).' => 'Nieuw ticket [%s] aangemaakt (Q=%s;P=%s;S=%s).',
        'New Window' => 'Nieuw Venster',
        'New owner is "%s" (ID=%s).' => 'Nieuwe eigenaar is "%s" (ID=%s).',
        'New process ticket' => 'Nieuw proces-ticket',
        'New responsible is "%s" (ID=%s).' => 'Nieuwe verantwoordelijke is "%s" (ID=%s).',
        'Next possible ticket states after adding a phone note in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Next possible ticket states after adding a phone note in the ticket phone outbound screen of the agent interface.' =>
            '',
        'None' => '',
        'Norwegian' => '',
        'Notification sent to "%s".' => 'Melding verstuurd aan "%s".',
        'Number of displayed tickets' => 'Aantal weergegeven tickets',
        'Number of lines (per ticket) that are shown by the search utility in the agent interface.' =>
            '',
        'Number of tickets to be displayed in each page of a search result in the agent interface.' =>
            '',
        'Number of tickets to be displayed in each page of a search result in the customer interface.' =>
            '',
        'OTRS can use one or more readonly mirror databases for expensive operations like fulltext search or statistics generation. Here you can specify the DSN for the first mirror database.' =>
            '',
        'Old: "%s" New: "%s"' => 'Oud: "%s" Nieuw: "%s"',
        'Open tickets (customer user)' => 'Open tickets (klant gebruiker)',
        'Open tickets (customer)' => 'Open tickets (klant)',
        'Option' => '',
        'Optional queue limitation for the CreatorCheck permission module. If set, permission is only granted for tickets in the specified queues.' =>
            '',
        'Optional queue limitation for the InvolvedCheck permission module. If set, permission is only granted for tickets in the specified queues.' =>
            '',
        'Optional queue limitation for the OwnerCheck permission module. If set, permission is only granted for tickets in the specified queues.' =>
            '',
        'Optional queue limitation for the ResponsibleCheck permission module. If set, permission is only granted for tickets in the specified queues.' =>
            '',
        'Out Of Office' => 'Afwezig',
        'Overloads (redefines) existing functions in Kernel::System::Ticket. Used to easily add customizations.' =>
            '',
        'Overview Escalated Tickets.' => '',
        'Overview Refresh Time' => 'Verversingsinterval overzichten',
        'Overview of all escalated tickets.' => '',
        'Overview of all open Tickets.' => 'Overzicht van alle openstaande tickets',
        'Overview of all open tickets.' => 'Overzicht van alle openstaande tickets.',
        'Overview of customer tickets.' => '',
        'PGP Key Management' => '',
        'Package event module file a scheduler task for update registration.' =>
            '',
        'Parameters for the CreateNextMask object in the preference view of the agent interface.' =>
            '',
        'Parameters for the CustomQueue object in the preference view of the agent interface.' =>
            '',
        'Parameters for the CustomService object in the preference view of the agent interface.' =>
            '',
        'Parameters for the RefreshTime object in the preference view of the agent interface.' =>
            '',
        'Parameters for the column filters of the small ticket overview.' =>
            '',
        'Parameters for the dashboard backend of the customer company information of the agent interface. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the customer id status widget of the agent interface . "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the customer user list overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the new tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.' =>
            '',
        'Parameters for the dashboard backend of the open tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.' =>
            '',
        'Parameters for the dashboard backend of the queue overview widget of the agent interface. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "QueuePermissionGroup" is not mandatory, queues are only listed if they belong to this permission group if you enable it. "States" is a list of states, the key is the sort order of the state in the widget. "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'Parameters voor het wachtrijoverzicht dashboard-backend. "Group" wordt gebruikt om de plugin te tonen aan gebruikers in de geselecteerde groemen (bijvoorbeeld Group: admin;group1;group2;). "QueuePermissionGroup" is niet verplicht, wachtrijen worden alleen getoond als ze aan deze permissiegroep gekoppeld zijn als deze instelling geactiveerd is. "States" is een lijst van statussen. De sleutel is de volgorde van de statussen in het widget. "Default" bepaalt of het dashlet standaard aan staat of dat de gebruiker deze zelf moet activeren. "CacheTTLLocal" is de cache-tijd in minuten voor deze plugin.',
        'Parameters for the dashboard backend of the running process tickets overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the ticket escalation overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.' =>
            '',
        'Parameters for the dashboard backend of the ticket events calendar of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the ticket pending reminder overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.' =>
            '',
        'Parameters for the dashboard backend of the ticket stats of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the upcoming events widget of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
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
        'ParentChild' => '',
        'Path for the log file (it only applies if "FS" was selected for LoopProtectionModule and it is mandatory).' =>
            '',
        'People' => 'Personen',
        'Performs the configured action for each event (as an Invoker) for each configured Webservice.' =>
            '',
        'Permitted width for compose email windows.' => '',
        'Permitted width for compose note windows.' => '',
        'Persian' => '',
        'Phone Call.' => '',
        'Picture Upload' => '',
        'Picture upload module.' => '',
        'Picture-Upload' => '',
        'Polish' => '',
        'Portuguese' => '',
        'Portuguese (Brasil)' => '',
        'PostMaster Filters' => 'E-mail filters',
        'PostMaster Mail Accounts' => 'E-mail accounts',
        'Process Management Activity Dialog GUI' => 'Procesbeheer dialoog',
        'Process Management Activity GUI' => 'Procesbeheer activiteit',
        'Process Management Path GUI' => 'Procesbeheer pad',
        'Process Management Transition Action GUI' => 'Procesbeheer transitie-actie',
        'Process Management Transition GUI' => 'Procesbeheer transitie',
        'Process Ticket.' => '',
        'Process pending tickets.' => '',
        'Process ticket' => '',
        'ProcessID' => '',
        'Protection against CSRF (Cross Site Request Forgery) exploits (for more info see http://en.wikipedia.org/wiki/Cross-site_request_forgery).' =>
            '',
        'Provides a matrix overview of the tickets per state per queue.' =>
            'Levert een matrixoverzicht van tickets per status per wachtrij.',
        'Queue view' => 'Wachtrijoverzicht',
        'Rebuild the ticket index for AgentTicketQueue.' => '',
        'Recognize if a ticket is a follow-up to an existing ticket using an external ticket number.' =>
            '',
        'Refresh interval' => 'Interval',
        'Removed subscription for user "%s".' => 'Removed subscription for user "%s".',
        'Removes the ticket watcher information when a ticket is archived.' =>
            '',
        'Renew existing SMIME certificates from customer backend. Note: SMIME and SMIME::FetchFromCustomer needs to be active in SysConfig and customer backend needs to be configured to fetch UserSMIMECertificate attribute.' =>
            '',
        'Replaces the original sender with current customer\'s email address on compose answer in the ticket compose screen of the agent interface.' =>
            '',
        'Reports' => 'Rapporten',
        'Reports (OTRS Business Solution™)' => 'Rapporten (OTRS Business Solution™)',
        'Reprocess mails from spool directory that could not be imported in the first place.' =>
            '',
        'Required permissions to change the customer of a ticket in the agent interface.' =>
            '',
        'Required permissions to use the close ticket screen in the agent interface.' =>
            '',
        'Required permissions to use the email outbound screen in the agent interface.' =>
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
        'Responsible Tickets' => '',
        'Responsible Tickets.' => '',
        'Restores a ticket from the archive (only if the event is a state change to any open available state).' =>
            '',
        'Retains all services in listings even if they are children of invalid elements.' =>
            '',
        'Right' => '',
        'Roles <-> Groups' => 'Rollen <-> Groepen',
        'Run file based generic agent jobs (Note: module name needs to be specified in -configuration-module param e.g. "Kernel::System::GenericAgent").' =>
            '',
        'Running Process Tickets' => '',
        'Runs an initial wildcard search of the existing customer company when accessing the AdminCustomerCompany module.' =>
            '',
        'Runs an initial wildcard search of the existing customer users when accessing the AdminCustomerUser module.' =>
            '',
        'Runs the system in "Demo" mode. If set to "Yes", agents can change preferences, such as selection of language and theme via the agent web interface. These changes are only valid for the current session. It will not be possible for agents to change their passwords.' =>
            '',
        'Russian' => '',
        'SMS' => '',
        'SMS (Short Message Service)' => '',
        'Sample command output' => '',
        'Saves the attachments of articles. "DB" stores all data in the database (not recommended for storing big attachments). "FS" stores the data on the filesystem; this is faster but the webserver should run under the OTRS user. You can switch between the modules even on a system that is already in production without any loss of data. Note: Searching for attachment names is not supported when "FS" is used.' =>
            '',
        'Schedule a maintenance period.' => 'Plan een nieuw systeem onderhoudstijdsvak.',
        'Screen' => '',
        'Search Customer' => 'Klanten zoeken',
        'Search Ticket.' => '',
        'Search Tickets.' => '',
        'Search User' => 'Zoek behandelaar',
        'Search backend default router.' => '',
        'Search backend router.' => '',
        'Search.' => '',
        'Second Queue' => '',
        'Select after which period ticket overviews should refresh automatically.' =>
            '',
        'Select how many tickets should be shown in overviews by default.' =>
            '',
        'Select the main interface language.' => 'Selecteer uw standaard taal.',
        'Select your default spelling dictionary.' => '',
        'Select your preferred layout for OTRS.' => '',
        'Select your preferred theme for OTRS.' => '',
        'Select your time zone.' => '',
        'Selects the cache backend to use.' => '',
        'Selects the module to handle uploads via the web interface. "DB" stores all uploads in the database, "FS" uses the file system.' =>
            '',
        'Selects the ticket number generator module. "AutoIncrement" increments the ticket number, the SystemID and the counter are used with SystemID.counter format (e.g. 1010138, 1010139). With "Date" the ticket numbers will be generated by the current date, the SystemID and the counter. The format looks like Year.Month.Day.SystemID.counter (e.g. 200206231010138, 200206231010139). With "DateChecksum"  the counter will be appended as checksum to the string of date and SystemID. The checksum will be rotated on a daily basis. The format looks like Year.Month.Day.SystemID.Counter.CheckSum (e.g. 2002070110101520, 2002070110101535). "Random" generates randomized ticket numbers in the format "SystemID.Random" (e.g. 100057866352, 103745394596).' =>
            '',
        'Send new outgoing mail from this ticket' => '',
        'Send notifications to users.' => 'Stuur berichten aan gebruikers.',
        'Sender type for new tickets from the customer inteface.' => '',
        'Sends agent follow-up notification only to the owner, if a ticket is unlocked (the default is to send the notification to all agents).' =>
            '',
        'Sends all outgoing email via bcc to the specified address. Please use this only for backup reasons.' =>
            '',
        'Sends customer notifications just to the mapped customer.' => '',
        'Sends registration information to OTRS group.' => '',
        'Sends reminder notifications of unlocked ticket after reaching the reminder date (only sent to ticket owner).' =>
            '',
        'Sends the notifications which are configured in the admin interface under "Ticket Notifications".' =>
            '',
        'Serbian Cyrillic' => '',
        'Serbian Latin' => '',
        'Service view' => '',
        'ServiceView' => '',
        'Set a new password by filling in your current password and a new one.' =>
            'oer uw huidige wachtwoord ter verificatie om uw nieuwe wachtwoord vast te kunnen leggen.',
        'Set sender email addresses for this system.' => 'Instellen van e-mailadressen gebruikt voor dit systeem.',
        'Set the default height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            '',
        'Set the limit of tickets that will be executed on a single genericagent job execution.' =>
            '',
        'Set the maximum height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            '',
        'Set the minimum log level. If you select \'error\', just errors are logged. With \'debug\' you get all logging messages. The order of log levels is: \'debug\', \'info\', \'notice\' and \'error\'.' =>
            '',
        'Set this to yes if you trust in all your public and private pgp keys, even if they are not certified with a trusted signature.' =>
            '',
        'Sets if SLA must be selected by the agent.' => '',
        'Sets if SLA must be selected by the customer.' => '',
        'Sets if note must be filled in by the agent. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            '',
        'Sets if service must be selected by the agent.' => '',
        'Sets if service must be selected by the customer.' => '',
        'Sets if ticket owner must be selected by the agent.' => '',
        'Sets the PendingTime of a ticket to 0 if the state is changed to a non-pending state.' =>
            '',
        'Sets the age in minutes (first level) for highlighting queues that contain untouched tickets.' =>
            '',
        'Sets the age in minutes (second level) for highlighting queues that contain untouched tickets.' =>
            '',
        'Sets the configuration level of the administrator. Depending on the config level, some sysconfig options will be not shown. The config levels are in in ascending order: Expert, Advanced, Beginner. The higher the config level is (e.g. Beginner is the highest), the less likely is it that the user can accidentally configure the system in a way that it is not usable any more.' =>
            '',
        'Sets the count of articles visible in preview mode of ticket overviews.' =>
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
        'Sets the default error message for the login screen on Agent and Customer interface, it\'s shown when a running system maintenance period is active.' =>
            '',
        'Sets the default link type of splitted tickets in the agent interface.' =>
            '',
        'Sets the default message for the login screen on Agent and Customer interface, it\'s shown when a running system maintenance period is active.' =>
            '',
        'Sets the default message for the notification is shown on a running system maintenance period.' =>
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
        'Sets the inactivity time (in seconds) to pass before a session is killed and a user is logged out.' =>
            '',
        'Sets the maximum number of active agents within the timespan defined in SessionMaxIdleTime before a prior warning will be visible for the logged in agents.' =>
            '',
        'Sets the maximum number of active agents within the timespan defined in SessionMaxIdleTime.' =>
            '',
        'Sets the maximum number of active customers within the timespan defined in SessionMaxIdleTime.' =>
            '',
        'Sets the maximum number of active sessions per agent within the timespan defined in SessionMaxIdleTime.' =>
            '',
        'Sets the maximum number of active sessions per customers within the timespan defined in SessionMaxIdleTime.' =>
            '',
        'Sets the minimal ticket counter size if "AutoIncrement" was selected as TicketNumberGenerator. Default is 5, this means the counter starts from 10000.' =>
            '',
        'Sets the minutes a notification is shown for notice about upcoming system maintenance period.' =>
            '',
        'Sets the number of lines that are displayed in text messages (e.g. ticket lines in the QueueZoom).' =>
            'Bepaalt het aantal gels dat wordt weergegeven in tekstberichten (zoals het aantal regels in QueueZoom)',
        'Sets the options for PGP binary.' => 'Bepaalt de opties voor de PGP binaries',
        'Sets the order of the different items in the customer preferences view.' =>
            'Bepaalt de volgorde van de elementen in de voorkeursinstellingen van klanten.',
        'Sets the password for private PGP key.' => 'Het wachtwoord van de PGP privésleutel',
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
        'Sets the state of a ticket in the close ticket screen of the agent interface.' =>
            '',
        'Sets the state of a ticket in the ticket bulk screen of the agent interface.' =>
            '',
        'Sets the state of a ticket in the ticket free text screen of the agent interface.' =>
            '',
        'Sets the state of a ticket in the ticket note screen of the agent interface.' =>
            '',
        'Sets the state of a ticket in the ticket responsible screen of the agent interface.' =>
            '',
        'Sets the state of the ticket in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the state of the ticket in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the state of the ticket in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
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
        'Sets the timeout (in seconds) for http/ftp downloads.' => '',
        'Sets the timeout (in seconds) for package downloads. Overwrites "WebUserAgent::Timeout".' =>
            '',
        'Sets the user time zone per user (required a system with UTC as system time and UTC under TimeZone). Otherwise this is a diff time to the local time.' =>
            '',
        'Sets the user time zone per user based on java script / browser time zone offset feature at login time.' =>
            '',
        'Shared Secret' => 'Gedeelde sleutel',
        'Should the cache data be held in memory?' => '',
        'Should the cache data be stored in the selected cache backend?' =>
            '',
        'Show a responsible selection in phone and email tickets in the agent interface.' =>
            '',
        'Show article as rich text even if rich text writing is disabled.' =>
            '',
        'Show queues even when only locked tickets are in.' => '',
        'Show the current owner in the customer interface.' => '',
        'Show the current queue in the customer interface.' => '',
        'Show the history for this ticket' => 'Toon de geschiedenis van dit ticket',
        'Shows a count of icons in the ticket zoom, if the article has attachments.' =>
            '',
        'Shows a link in the menu for subscribing / unsubscribing from a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu that allows linking a ticket with another object in the ticket zoom view of the agent interface.  Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu that allows merging tickets in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to access the history of a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to add a free text field in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to add a note in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to add a note to a ticket in every ticket overview of the agent interface.' =>
            '',
        'Shows a link in the menu to add a phone call inbound in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to add a phone call outbound in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to change the customer who requested the ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to change the owner of a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to change the responsible agent of a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to close a ticket in every ticket overview of the agent interface.' =>
            '',
        'Shows a link in the menu to close a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to delete a ticket in every ticket overview of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Shows a link in the menu to delete a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to enroll a ticket into a process in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to go back in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to lock / unlock a ticket in the ticket overviews of the agent interface.' =>
            '',
        'Shows a link in the menu to lock/unlock tickets in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to move a ticket in every ticket overview of the agent interface.' =>
            '',
        'Shows a link in the menu to print a ticket or an article in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to see the history of a ticket in every ticket overview of the agent interface.' =>
            '',
        'Shows a link in the menu to see the priority of a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to send an outbound email in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to set a ticket as junk in every ticket overview of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Shows a link in the menu to set a ticket as pending in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
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
        'Shows a link to set a ticket as junk in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
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
        'Shows a select of ticket attributes to order the queue view ticket list. The possible selections can be configured via \'TicketOverviewMenuSort###SortAttributes\'.' =>
            '',
        'Shows all both ro and rw queues in the queue view.' => '',
        'Shows all both ro and rw tickets in the service view.' => '',
        'Shows all open tickets (even if they are locked) in the escalation view of the agent interface.' =>
            'Toont alle geopende tickets (zelfs als deze zijn vergrendeld) in de escalatieweergave van de behandelaar.',
        'Shows all open tickets (even if they are locked) in the status view of the agent interface.' =>
            '',
        'Shows all the articles of the ticket (expanded) in the zoom view.' =>
            '',
        'Shows all the customer identifiers in a multi-select field (not useful if you have a lot of customer identifiers).' =>
            '',
        'Shows all the customer user identifiers in a multi-select field (not useful if you have a lot of customer user identifiers).' =>
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
        'Shows information on how to start OTRS Daemon' => '',
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
        'Shows the title field in the ticket free text screen of the agent interface.' =>
            '',
        'Shows the title fields in the close ticket screen of the agent interface.' =>
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
        'Simple' => '',
        'Skin' => 'Skin',
        'Slovak' => '',
        'Slovenian' => '',
        'Software Package Manager.' => '',
        'SolutionDiffInMin' => '',
        'SolutionInMin' => '',
        'Some description!' => '',
        'Some picture description!' => '',
        'Sorts the tickets (ascendingly or descendingly) when a single queue is selected in the queue view and after the tickets are sorted by priority. Values: 0 = ascending (oldest on top, default), 1 = descending (youngest on top). Use the QueueID for the key and 0 or 1 for value.' =>
            '',
        'Sorts the tickets (ascendingly or descendingly) when a single queue is selected in the service view and after the tickets are sorted by priority. Values: 0 = ascending (oldest on top, default), 1 = descending (youngest on top). Use the ServiceID for the key and 0 or 1 for value.' =>
            '',
        'Spam' => '',
        'Spam Assassin example setup. Ignores emails that are marked with SpamAssassin.' =>
            '',
        'Spam Assassin example setup. Moves marked mails to spam queue.' =>
            '',
        'Spanish' => '',
        'Spanish (Colombia)' => '',
        'Spanish (Mexico)' => '',
        'Spanish stop words for fulltext index. These words will be removed from the search index.' =>
            '',
        'Specifies if an agent should receive email notification of his own actions.' =>
            '',
        'Specifies the available note types for this ticket mask. If the option is deselected, ArticleTypeDefault is used and the option is removed from the mask.' =>
            '',
        'Specifies the default article type for the ticket compose screen in the agent interface if the article type cannot be automatically detected.' =>
            '',
        'Specifies the different article types that will be used in the system.' =>
            '',
        'Specifies the different note types that will be used in the system.' =>
            '',
        'Specifies the directory to store the data in, if "FS" was selected for TicketStorageModule.' =>
            '',
        'Specifies the directory where SSL certificates are stored.' => '',
        'Specifies the directory where private SSL certificates are stored.' =>
            '',
        'Specifies the email address that should be used by the application when sending notifications. The email address is used to build the complete display name for the notification master (i.e. "OTRS Notifications" otrs@your.example.com). You can use the OTRS_CONFIG_FQDN variable as set in your configuation, or choose another email address.' =>
            '',
        'Specifies the email addresses to get notification messages from scheduler tasks.' =>
            '',
        'Specifies the group where the user needs rw permissions so that he can access the "SwitchToCustomer" feature.' =>
            '',
        'Specifies the name that should be used by the application when sending notifications. The sender name is used to build the complete display name for the notification master (i.e. "OTRS Notifications" otrs@your.example.com).' =>
            '',
        'Specifies the order in which the firstname and the lastname of agents will be displayed.' =>
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
        'Specifies the text that should appear in the log file to denote a CGI script entry.' =>
            '',
        'Specifies user id of the postmaster data base.' => '',
        'Specifies whether all storage backends should be checked when looking for attachments. This is only required for installations where some attachments are in the file system, and others in the database.' =>
            '',
        'Specify how many sub directory levels to use when creating cache files. This should prevent too many cache files being in one directory.' =>
            '',
        'Specify the channel to be used to fetch OTRS Business Solution™ updates. Warning: Development releases might not be complete, your system might experience unrecoverable errors and on extreme cases could become unresponsive!' =>
            '',
        'Specify the password to authenticate for the first mirror database.' =>
            '',
        'Specify the username to authenticate for the first mirror database.' =>
            '',
        'Spell checker.' => '',
        'Stable' => '',
        'Standard available permissions for agents within the application. If more permissions are needed, they can be entered here. Permissions must be defined to be effective. Some other good permissions have also been provided built-in: note, close, pending, customer, freetext, move, compose, responsible, forward, and bounce. Make sure that "rw" is always the last registered permission.' =>
            '',
        'Start number for statistics counting. Every new stat increments this number.' =>
            '',
        'Starts a wildcard search of the active object after the link object mask is started.' =>
            '',
        'Stat#' => 'Rapport#',
        'Status view' => 'Statusoverzicht',
        'Stores cookies after the browser has been closed.' => '',
        'Strips empty lines on the ticket preview in the queue view.' => '',
        'Strips empty lines on the ticket preview in the service view.' =>
            '',
        'Support Agent' => '',
        'Swahili' => '',
        'Swedish' => '',
        'System Address Display Name' => '',
        'System Maintenance' => 'Systeemonderhoud',
        'System Request (%s).' => 'SystemRequest: "%s"',
        'Target' => '',
        'Templates <-> Queues' => 'Sjablonen <-> Wachtrijen',
        'Textarea' => 'Tekstvak',
        'Thai' => '',
        'The agent skin\'s InternalName which should be used in the agent interface. Please check the available skins in Frontend::Agent::Skins.' =>
            '',
        'The customer skin\'s InternalName which should be used in the customer interface. Please check the available skins in Frontend::Customer::Skins.' =>
            '',
        'The daemon registration for the scheduler cron task manager.' =>
            '',
        'The daemon registration for the scheduler future task manager.' =>
            '',
        'The daemon registration for the scheduler generic agent task manager.' =>
            '',
        'The daemon registration for the scheduler task worker.' => '',
        'The divider between TicketHook and ticket number. E.g \': \'.' =>
            '',
        'The duration in minutes after emitting an event, in which the new escalation notify and start events are suppressed.' =>
            '',
        'The format of the subject. \'Left\' means \'[TicketHook#:12345] Some Subject\', \'Right\' means \'Some Subject [TicketHook#:12345]\', \'None\' means \'Some Subject\' and no ticket number. In the latter case you should verify that the setting PostMaster::CheckFollowUpModule###0200-References is activated to recognize followups based on email headers.' =>
            '',
        'The headline shown in the customer interface.' => '',
        'The identifier for a ticket, e.g. Ticket#, Call#, MyTicket#. The default is Ticket#.' =>
            '',
        'The logo shown in the header of the agent interface for the skin "default". See "AgentLogo" for further description.' =>
            '',
        'The logo shown in the header of the agent interface for the skin "ivory". See "AgentLogo" for further description.' =>
            '',
        'The logo shown in the header of the agent interface for the skin "ivory-slim". See "AgentLogo" for further description.' =>
            '',
        'The logo shown in the header of the agent interface for the skin "slim". See "AgentLogo" for further description.' =>
            '',
        'The logo shown in the header of the agent interface. The URL to the image can be a relative URL to the skin image directory, or a full URL to a remote web server.' =>
            '',
        'The logo shown in the header of the customer interface. The URL to the image can be a relative URL to the skin image directory, or a full URL to a remote web server.' =>
            '',
        'The logo shown on top of the login box of the agent interface. The URL to the image must be relative URL to the skin image directory.' =>
            '',
        'The maximal number of articles expanded on a single page in AgentTicketZoom.' =>
            '',
        'The maximal number of articles shown on a single page in AgentTicketZoom.' =>
            '',
        'The maximum number of mails fetched at once before reconnecting to the server.' =>
            '',
        'The text at the beginning of the subject in an email reply, e.g. RE, AW, or AS.' =>
            '',
        'The text at the beginning of the subject when an email is forwarded, e.g. FW, Fwd, or WG.' =>
            '',
        'The value of the From field' => '',
        'This event module stores attributes from CustomerUser as DynamicFields tickets. Please see the setting above for how to configure the mapping.' =>
            '',
        'This is a description for TimeZone on Customer side.' => '',
        'This is the default orange - black skin for the customer interface.' =>
            '',
        'This is the default orange - black skin.' => '',
        'This module and its PreRun() function will be executed, if defined, for every request. This module is useful to check some user options or to display news about new applications.' =>
            '',
        'This module is part of the admin area of OTRS.' => '',
        'This option defines the dynamic field in which a Process Management activity entity id is stored.' =>
            '',
        'This option defines the dynamic field in which a Process Management process entity id is stored.' =>
            '',
        'This option defines the process tickets default lock.' => '',
        'This option defines the process tickets default priority.' => '',
        'This option defines the process tickets default queue.' => '',
        'This option defines the process tickets default state.' => '',
        'This option will deny the access to customer company tickets, which are not created by the customer user.' =>
            '',
        'This setting allows you to override the built-in country list with your own list of countries. This is particularly handy if you just want to use a small select group of countries.' =>
            '',
        'This will allow the system to send text messages via SMS.' => '',
        'Ticket Close.' => '',
        'Ticket Compose Bounce Email.' => '',
        'Ticket Compose email Answer.' => '',
        'Ticket Customer.' => '',
        'Ticket Forward Email.' => '',
        'Ticket FreeText.' => '',
        'Ticket History.' => '',
        'Ticket Lock.' => '',
        'Ticket Merge.' => '',
        'Ticket Move.' => '',
        'Ticket Note.' => '',
        'Ticket Notifications' => 'Ticketnotificaties',
        'Ticket Outbound Email.' => '',
        'Ticket Owner.' => '',
        'Ticket Pending.' => '',
        'Ticket Print.' => '',
        'Ticket Priority.' => '',
        'Ticket Queue Overview' => 'Ticketwachtrij overzicht',
        'Ticket Responsible.' => '',
        'Ticket Watcher' => '',
        'Ticket Zoom' => '',
        'Ticket Zoom.' => '',
        'Ticket bulk module.' => '',
        'Ticket event module that triggers the escalation stop events.' =>
            '',
        'Ticket moved into Queue "%s" (%s) from Queue "%s" (%s).' => 'Ticket verplaatst naar wachtrij "%s" (%s) van wachtrij "%s" (%s).',
        'Ticket notifications' => 'Ticketnotificaties',
        'Ticket overview' => 'Ticketoverzicht',
        'Ticket plain view of an email.' => '',
        'Ticket title' => '',
        'Ticket zoom view.' => '',
        'TicketNumber' => '',
        'Tickets.' => '',
        'Time in seconds that gets added to the actual time if setting a pending-state (default: 86400 = 1 day).' =>
            '',
        'Title updated: Old: "%s", New: "%s"' => 'Ticket-titel veranderd: "%s"',
        'To accept login information, such as an EULA or license.' => '',
        'To download attachments.' => '',
        'Toggles display of OTRS FeatureAddons list in PackageManager.' =>
            '',
        'Toolbar Item for a shortcut. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Transport selection for ticket notifications.' => '',
        'Tree view' => '',
        'Triggers ticket escalation events and notification events for escalation.' =>
            '',
        'Turkish' => '',
        'Turns off SSL certificate validation, for example if you use a transparent HTTPS proxy. Use at your own risk!' =>
            '',
        'Turns on drag and drop for the main navigation.' => '',
        'Turns on the animations used in the GUI. If you have problems with these animations (e.g. performance issues), you can turn them off here.' =>
            '',
        'Turns on the remote ip address check. It should be set to "No" if the application is used, for example, via a proxy farm or a dialup connection, because the remote ip address is mostly different for the requests.' =>
            '',
        'Ukrainian' => '',
        'Unlock tickets that are past their unlock timeout.' => '',
        'Unlock tickets whenever a note is added and the owner is out of office.' =>
            '',
        'Unlocked ticket.' => 'Ticket ontgrendeld.',
        'Update Ticket "Seen" flag if every article got seen or a new Article got created.' =>
            '',
        'Updated SLA to %s (ID=%s).' => 'SLA gewijzigd naar %s (ID=%s).',
        'Updated Service to %s (ID=%s).' => 'Service gewijzigd naar %s (ID=%s).',
        'Updated Type to %s (ID=%s).' => 'Type gewijzigd naar %s (ID=%s).',
        'Updated: %s' => 'Bijgewerkt: %s',
        'Updated: %s=%s;%s=%s;%s=%s;' => 'Bijgewerkt: %s=%s;%s=%s;%s=%s;',
        'Updates the ticket escalation index after a ticket attribute got updated.' =>
            '',
        'Updates the ticket index accelerator.' => '',
        'Upload your PGP key.' => '',
        'Upload your S/MIME certificate.' => '',
        'Use new type of select and autocomplete fields in agent interface, where applicable (InputFields).' =>
            '',
        'Use new type of select and autocomplete fields in customer interface, where applicable (InputFields).' =>
            '',
        'UserFirstname' => 'UserFirstname',
        'UserLastname' => 'UserLastname',
        'Uses Cc recipients in reply Cc list on compose an email answer in the ticket compose screen of the agent interface.' =>
            '',
        'Uses richtext for viewing and editing ticket notification.' => 'Gebruik richtext voor het weergeven en bewerken van ticket notificaties.',
        'Uses richtext for viewing and editing: articles, salutations, signatures, standard templates, auto responses and notifications.' =>
            'Gebruik richtext voor het weergeven en bewerken van: artikelen, aanheffen, ondertekeningen, standaard templates, auto antwoorden en notificaties.',
        'Vietnam' => 'Vietnam',
        'View performance benchmark results.' => 'Bekijk resultaten van de performance log.',
        'Watch this ticket' => 'Volg dit ticket',
        'Watched Tickets.' => '',
        'We are performing scheduled maintenance.' => 'We hebben op dit moment gelpand onderhoud.',
        'We are performing scheduled maintenance. Login is temporarily not available.' =>
            'Er vindt op dit moment gepland onderhoud plaats. Inloggen is momenteel niet mogelijk.',
        'We are performing scheduled maintenance. We should be back online shortly.' =>
            'Er vindt op dit moment gepland onderhoud plaats. We zullen snel weer online zijn.',
        'Web View' => '',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. Here you can define the body of this note (this text cannot be changed by the agent).' =>
            'Wanneer tickets worden samengevoegd, wordt een notitie toegevoegd aan het ticket dat niet meer actief is. Hier kun je de tekst van die notitie toevoegen (deze tekst kan niet worden aangepast door de agent).',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. Here you can define the subject of this note (this subject cannot be changed by the agent).' =>
            '',
        'When tickets are merged, the customer can be informed per email by setting the check box "Inform Sender". In this text area, you can define a pre-formatted text which can later be modified by the agents.' =>
            '',
        'Whether or not to collect meta information from articles using filters configured in Ticket::Frontend::ZoomCollectMetaFilters.' =>
            '',
        'Yes, but hide archived tickets' => '',
        'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further information.' =>
            '',
        'Your queue selection of your preferred queues. You also get notified about those queues via email if enabled.' =>
            '',
        'Your service selection of your preferred services. You also get notified about those services via email if enabled.' =>
            '',
        'attachment' => '',
        'bounce' => '',
        'compose' => '',
        'debug' => '',
        'error' => '',
        'forward' => '',
        'info' => '',
        'inline' => '',
        'notice' => '',
        'pending' => '',
        'responsible' => '',
        'stats' => '',

    };
    # $$STOP$$
    return;
}

1;
