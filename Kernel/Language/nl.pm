# --
# Copyright (C) 2002-2003 Fred van Dijk <fvandijk at marklin.nl>
# Copyright (C) 2003 A-NeT Internet Services bv Hans Bakker <h.bakker at a-net.nl>
# Copyright (C) 2004 Martijn Lohmeijer <martijn.lohmeijer 'at' sogeti.nl>
# Copyright (C) 2005-2007 Jurgen Rutgers <jurgen 'at' besite.nl>
# Copyright (C) 2005-2007 Richard Hinkamp <richard 'at' besite.nl>
# Copyright (C) 2010 Ton van Boven <ton 'at' avebo.nl>
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
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
    $Self->{Completeness}        = 0.554520826278361;

    # csv separator
    $Self->{Separator}         = ';';

    $Self->{DecimalSeparator}  = ',';
    $Self->{ThousandSeparator} = '.';
    $Self->{Translation} = {

        # Template: AdminACL
        'ACL Management' => 'ACL beheer',
        'Actions' => 'Acties',
        'Create New ACL' => 'Nieuwe ACL aanmaken',
        'Deploy ACLs' => 'ACLs activeren',
        'Export ACLs' => 'Exporteer ACLs',
        'Filter for ACLs' => 'Filter op ACLs',
        'Just start typing to filter...' => 'Start met typen om te filteren',
        'Configuration Import' => 'Configuratie importeren',
        'Here you can upload a configuration file to import ACLs to your system. The file needs to be in .yml format as exported by the ACL editor module.' =>
            'Hier kunt u een configuratiebestand met ACLs importeren in uw systeem. Het bestand moet in .yml formaat zijn, zoals geexporteerd door de ACL module.',
        'This field is required.' => 'Dit veld is verplicht.',
        'Overwrite existing ACLs?' => 'Overschrijf bestaande ACLs?',
        'Upload ACL configuration' => 'ACL-configuratie uploaden?',
        'Import ACL configuration(s)' => 'Importeer ACL-configuratie',
        'Description' => 'Omschrijving',
        'To create a new ACL you can either import ACLs which were exported from another system or create a complete new one.' =>
            'Om nieuwe ACLs aan te maken kunt u deze importeren vanuit een bestand of een compleet nieuwe aanmaken.',
        'Changes to the ACLs here only affect the behavior of the system, if you deploy the ACL data afterwards. By deploying the ACL data, the newly made changes will be written to the configuration.' =>
            'Wijzigingen aan de ACLs worden pas actief als u de ACLs activeert. Door ',
        'ACLs' => 'ACLs',
        'Please note: This table represents the execution order of the ACLs. If you need to change the order in which ACLs are executed, please change the names of the affected ACLs.' =>
            'Let op: deze tabel toont de volgorde waarin de ALCs worden toegepast. Als u de volgorde waarin deze worden uitgevoerd moet aanpassen, verander dan de namen van de ACLs.',
        'ACL name' => 'ACL-naam',
        'Comment' => 'Opmerking',
        'Validity' => 'Geldigheid',
        'Export' => 'Exporteer',
        'Copy' => 'Kopiëer',
        'No data found.' => 'Geen gegevens gevonden.',
        'No matches found.' => 'Niets gevonden.',

        # Template: AdminACLEdit
        'Edit ACL %s' => 'Bewerk ACL %s',
        'Edit ACL' => 'Bewerkt ACL',
        'Go to overview' => 'Naar het overzicht',
        'Delete ACL' => 'Verwijder ACL',
        'Delete Invalid ACL' => 'Verwijder ongeldige ACL',
        'Match settings' => 'Activatie-criteria',
        'Set up matching criteria for this ACL. Use \'Properties\' to match the current screen or \'PropertiesDatabase\' to match attributes of the current ticket that are in the database.' =>
            'Stel activatie-criteria in voor deze ACL. Gebruik \'Attributen\' om de huidige waarden te gebruiken of \'DatabaseAttributen\' om de waarden uit de database voor het huidige ticket te gebruiken.',
        'Change settings' => 'Verander instellingen',
        'Set up what you want to change if the criteria match. Keep in mind that \'Possible\' is a white list, \'PossibleNot\' a black list.' =>
            'Geef aan wat u wilt dat gebeurt als de activatie-criteria kloppen.',
        'Check the official %sdocumentation%s.' => 'Bekijk de officiële %sdocumentatie%s',
        'Show or hide the content' => 'Toon of verberg de inhoud',
        'Edit ACL Information' => 'Bewerk ACL-informatie',
        'Name' => 'Naam',
        'Stop after match' => 'Stop met filters na match',
        'Edit ACL Structure' => 'Bewerk ACL-structuur',
        'Save ACL' => 'ACL Opslaan',
        'Save' => 'Opslaan',
        'or' => 'of',
        'Save and finish' => 'Opslaan en voltooien',
        'Cancel' => 'Annuleren',
        'Do you really want to delete this ACL?' => 'Wilt u deze ACL verwijderen?',

        # Template: AdminACLNew
        'Create a new ACL by submitting the form data. After creating the ACL, you will be able to add configuration items in edit mode.' =>
            'Maak een nieuwe ACL aan. Na het aanmaken kunt u de eigenschappen aanpassen door deze te bewerken.',

        # Template: AdminAppointmentCalendarManage
        'Calendar Management' => 'Kalender beheer',
        'Add Calendar' => 'Kalender toevoegen',
        'Edit Calendar' => 'Kalender bewerken',
        'Calendar Overview' => 'Kalender overzicht',
        'Add new Calendar' => 'Nieuwe kalender toevoegen',
        'Import Appointments' => 'Afspraken importeren',
        'Calendar Import' => 'Kalender import',
        'Here you can upload a configuration file to import a calendar to your system. The file needs to be in .yml format as exported by calendar management module.' =>
            'Hier kunt u een configuratiebestand uploaden om een ​​kalender naar uw systeem te importeren. Het bestand moet in .yml-indeling zijn zoals geëxporteerd door de kalenderbeheermodule.',
        'Overwrite existing entities' => 'Overschrijf bestaande records',
        'Upload calendar configuration' => 'Upload kalender configuratie',
        'Import Calendar' => 'Importeer kalender',
        'Filter for Calendars' => 'Filter voor kalenders',
        'Filter for calendars' => 'Filter voor kalenders',
        'Depending on the group field, the system will allow users the access to the calendar according to their permission level.' =>
            'Afhankelijk van het groepsveld geeft het systeem gebruikers toegang tot de kalender op basis van hun machtigingsniveau.',
        'Read only: users can see and export all appointments in the calendar.' =>
            'Alleen lezen: gebruikers kunnen alle afspraken in deze kalender raadplegen en exporteren.',
        'Move into: users can modify appointments in the calendar, but without changing the calendar selection.' =>
            'Verplaats naar: Gebruikers kunnen afspraken in de agenda wijzigen, maar zonder de kalender te wijzigen.',
        'Create: users can create and delete appointments in the calendar.' =>
            'Maken: gebruikers kunnen afspraken maken en verwijderen in de kalender',
        'Read/write: users can manage the calendar itself.' => 'Lezen/Schrijven: gebruikers kunnen de kalender beheren',
        'Group' => 'Groep',
        'Changed' => 'Gewijzigd',
        'Created' => 'Aangemaakt',
        'Download' => 'Downloaden',
        'URL' => 'URL',
        'Export calendar' => 'Exporteer kalender',
        'Download calendar' => 'Download kalender',
        'Copy public calendar URL' => 'Kopieer publieke kalender URL',
        'Calendar' => 'Kalender',
        'Calendar name' => 'Kalender naam',
        'Calendar with same name already exists.' => 'Er bestaat al een kalender met deze naam.',
        'Color' => 'Kleur',
        'Permission group' => 'Permissie groep',
        'Ticket Appointments' => 'Ticket afspraken',
        'Rule' => 'Regel',
        'Remove this entry' => 'Verwijder deze sleutel',
        'Remove' => 'Verwijderen',
        'Start date' => 'Begindatum',
        'End date' => 'Einddatum',
        'Use options below to narrow down for which tickets appointments will be automatically created.' =>
            'Gebruik de opties hieronder om te beperken voor welke tickets er automatisch afspraken worden aangemaakt.',
        'Queues' => 'Wachtrijen',
        'Please select a valid queue.' => 'Selecteer een geldige wachtrij.',
        'Search attributes' => 'Zoekeigenschappen',
        'Add entry' => 'Sleutel toevoegen',
        'Add' => 'Toevoegen',
        'Define rules for creating automatic appointments in this calendar based on ticket data.' =>
            'Definieer regels voor het automatisch aanmaken van afspraken in deze kalender, gebaseerd op gegevens van het ticket',
        'Add Rule' => 'Regel toevoegen',
        'Submit' => 'Versturen',

        # Template: AdminAppointmentImport
        'Appointment Import' => 'Afspraak importeren',
        'Go back' => 'Ga terug',
        'Uploaded file must be in valid iCal format (.ics).' => 'Opgeladen bestanden moeten een geldige iCal indeling hebben (.ics)',
        'If desired Calendar is not listed here, please make sure that you have at least \'create\' permissions.' =>
            'Als de gewenste kalender hier niet zichtbaar is, controleer dan of je ten minste \'create\' rechten hebt.',
        'Upload' => 'Upload',
        'Update existing appointments?' => 'Bestaande afspraken bijwerken?',
        'All existing appointments in the calendar with same UniqueID will be overwritten.' =>
            'Alle bestaande afspraken in de kalender met dezelfde UniqueID zullen overschreven worden.',
        'Upload calendar' => 'Upload kalender',
        'Import appointments' => 'Afspraken importeren',

        # Template: AdminAppointmentNotificationEvent
        'Appointment Notification Management' => 'Meldingen voor afspraken beheren',
        'Add Notification' => 'Melding toevoegen',
        'Edit Notification' => 'Bewerk melding',
        'Export Notifications' => 'Meldingen exporteren',
        'Filter for Notifications' => 'Filter voor notificaties',
        'Filter for notifications' => 'Filter voor notificaties',
        'Here you can upload a configuration file to import appointment notifications to your system. The file needs to be in .yml format as exported by the appointment notification module.' =>
            'Hier kun je configuratiebestanden uploaden om Afspraak Notificaties te importeren. Het bestand moet in .yml formaat zoals geëxporteerd door de notificatie module.',
        'Overwrite existing notifications?' => 'Bestaande meldingen overschrijven?',
        'Upload Notification configuration' => 'Upload meldingconfiguratie',
        'Import Notification configuration' => 'Melding configuratie importeren',
        'List' => 'Overzicht',
        'Delete' => 'Verwijderen',
        'Delete this notification' => 'Melding verwijderen',
        'Show in agent preferences' => 'Tonen bij voorkeuren Agent',
        'Agent preferences tooltip' => 'Agent voorkeuren tooltip',
        'This message will be shown on the agent preferences screen as a tooltip for this notification.' =>
            'Dit bericht wordt getoond op de agent voorkeuren pagina als een tooltip voor deze notificatie.',
        'Toggle this widget' => 'Klap in/uit',
        'Events' => 'Gebeurtenissen',
        'Event' => 'Gebeurtenis',
        'Here you can choose which events will trigger this notification. An additional appointment filter can be applied below to only send for appointments with certain criteria.' =>
            'Hier kun je kiezen welke gebeurtenissen deze notificatie inschakelen. Een extra ticket filter kan worden toegepast om de notificatie alleen te versturen als het ticket voldoet aan bepaalde criteria.',
        'Appointment Filter' => 'Filter afspraken',
        'Type' => 'Type',
        'Title' => 'Titel',
        'Location' => 'Locatie',
        'Team' => 'Team',
        'Resource' => 'Middel',
        'Recipients' => 'Ontvangers',
        'Send to' => 'Versturen naar',
        'Send to these agents' => 'Verstuur naar deze gebruikers',
        'Send to all group members (agents only)' => 'Verstuur naar alle groepsleden (alleen behandelaars)',
        'Send to all role members' => 'Verstuur naar alle leden van een rol',
        'Send on out of office' => 'Verstuur ook wanneer afwezigheidsassistent aan staat',
        'Also send if the user is currently out of office.' => 'Verstuur ook wanneer afwezigheidsassistent aan staat',
        'Once per day' => 'Eén keer per dag',
        'Notify user just once per day about a single appointment using a selected transport.' =>
            '',
        'Notification Methods' => 'Meldingsmethoden',
        'These are the possible methods that can be used to send this notification to each of the recipients. Please select at least one method below.' =>
            'Dit zijn de mogelijke manieren die kunnen worden gebruikt om meldingen te versturen naar elke ontvanger. Selecteer minimaal één methode.',
        'Enable this notification method' => 'Zet deze meldingen methode aan',
        'Transport' => 'Transport',
        'At least one method is needed per notification.' => 'Op zijn minst één methode is vereist per melding.',
        'Active by default in agent preferences' => 'Standaard actief in agent voorkeuren',
        'This is the default value for assigned recipient agents who didn\'t make a choice for this notification in their preferences yet. If the box is enabled, the notification will be sent to such agents.' =>
            'Dit is de standaard waarde voor toegewezen ontvangers die geen keuze hebben gemaakt voor deze melding in hun voorkeuren. Als deze waarde is aangevinkt, wordt het bericht naar deze behandelaars gestuurd.',
        'This feature is currently not available.' => 'Deze feature is niet beschikbaar op het moment.',
        'Upgrade to %s' => 'Upgrade naar %s',
        'Please activate this transport in order to use it.' => '',
        'No data found' => 'Geen data gevonden',
        'No notification method found.' => 'Geen meldingen methoden gevonden',
        'Notification Text' => 'Meldingstekst',
        'This language is not present or enabled on the system. This notification text could be deleted if it is not needed anymore.' =>
            'Deze taal is niet aanwezig of ingeschakeld in het systeem. Deze meldingstekst kan verwijderd worden wanneer deze niet meer nodig is.',
        'Remove Notification Language' => 'Verwijder de taal voor de meldingen',
        'Subject' => 'Onderwerp',
        'Text' => 'Tekst',
        'Message body' => 'Berichttekst',
        'Add new notification language' => 'Voeg nieuwe taal voor meldingen toe',
        'Save Changes' => 'Wijzigingen opslaan',
        'Tag Reference' => 'Tag verwijzing',
        'Notifications are sent to an agent.' => 'Meldingen zijn verzonden naar de behandelaar.',
        'You can use the following tags' => 'U kunt de volgende tags gebruiken',
        'To get the first 20 character of the appointment title.' => '',
        'To get the appointment attribute' => 'Om de afspraak eigenschap te krijgen',
        ' e. g.' => ' bijv.',
        'To get the calendar attribute' => '',
        'Attributes of the recipient user for the notification' => 'Eigenschappen van de ontvanger voor deze melding',
        'Config options' => 'Attributen van de configuratie',
        'Example notification' => 'Voorbeeld van de melding',

        # Template: AdminAppointmentNotificationEventTransportEmailSettings
        'Additional recipient email addresses' => 'Aanvullende ontvanger e-mailadres',
        'This field must have less then 200 characters.' => 'Dit veld mag maximaal 200 karakters bevatten',
        'Article visible for customer' => 'Article zichtbaar voor klant',
        'An article will be created if the notification is sent to the customer or an additional email address.' =>
            'Wanneer de melding wordt verstuurd naar de klant of een extra e-mail adres, wordt een artikel aangemaakt.',
        'Email template' => 'Email sjabloon',
        'Use this template to generate the complete email (only for HTML emails).' =>
            'Gebruik deze template om de complete mail te genereren (alleen voor HTML email).',
        'Enable email security' => 'Email beveiliging inschakelen',
        'Email security level' => 'Niveau van email beveiliging',
        'If signing key/certificate is missing' => 'Als signeer sleutel/certificaat ontbreekt',
        'If encryption key/certificate is missing' => 'Als encryptie sleutel/certificaat ontbreekt',

        # Template: AdminAttachment
        'Attachment Management' => 'Beheer bijlagen',
        'Add Attachment' => 'Nieuwe bijlage',
        'Edit Attachment' => 'Bijlage bewerken',
        'Filter for Attachments' => 'Filter op bijlagen',
        'Filter for attachments' => 'Filter op bijlagen',
        'Filename' => 'Bestandsnaam',
        'Download file' => 'Download bijlage',
        'Delete this attachment' => 'Verwijder bijlage',
        'Do you really want to delete this attachment?' => 'Ben je zeker dat je deze bijlage wil verwijderen?',
        'Attachment' => 'Bijlage',

        # Template: AdminAutoResponse
        'Auto Response Management' => 'Beheer automatische antwoorden',
        'Add Auto Response' => 'Nieuw automatisch antwoord',
        'Edit Auto Response' => 'Bewerk automatisch antwoord',
        'Filter for Auto Responses' => 'Filter op automatische antwoorden',
        'Filter for auto responses' => 'Filter op automatische antwoorden',
        'Response' => 'Antwoord',
        'Auto response from' => 'Automatisch antwoord van',
        'Reference' => 'Referentie',
        'To get the first 20 character of the subject.' => 'Voor de eerste 20 tekens van het onderwerp.',
        'To get the first 5 lines of the email.' => 'Voor de eerste vijf regels van het e-mail bericht.',
        'To get the name of the ticket\'s customer user (if given).' => 'Om de naam van de klant te verkrijgen (indien gegeven)',
        'To get the article attribute' => 'Voor de attributen van de interactie',
        'Options of the current customer user data' => 'Attributen van de huidige klant',
        'Ticket owner options' => 'Attributen van de ticket eigenaar',
        'Ticket responsible options' => 'Attributen van de verantwoordelijke',
        'Options of the current user who requested this action' => 'Attributen van de huidige gebruiker',
        'Options of the ticket data' => 'Attributen van het ticket',
        'Options of ticket dynamic fields internal key values' => 'Attributen van dynamische velden, interne waarden',
        'Options of ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            'Waarden van dynamische velden, voor Dropdown en Multiselect velden',
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
        'Update' => 'Opslaan',
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

        # Template: AdminCommunicationLog
        'Communication Log' => 'Communicatielogboek',
        'Time Range' => 'Bereik van tijd',
        'Show only communication logs created in specific time range.' =>
            'Toon alleen communicatielogboeken gemaakt binnen een bepaald tijdbereik.',
        'Filter for Communications' => 'Filter op communicatie',
        'Filter for communications' => 'Filter op communicatie',
        'In this screen you can see an overview about incoming and outgoing communications.' =>
            'Op dit scherm ziet u een overzicht van de binnenkomende en uitgaande communicatie.',
        'You can change the sort and order of the columns by clicking on the column header.' =>
            'U kunt de sortering en volgorde van de kolommen wijzigen door op de kolomkop te klikken.',
        'If you click on the different entries, you will get redirected to a detailed screen about the message.' =>
            'Als u op de verschillende items klikt, wordt u omgeleid naar een gedetailleerd scherm over het bericht.',
        'Status for: %s' => 'Status van: %s',
        'Failing accounts' => 'Probleemaccount',
        'Some account problems' => 'Bepaalde account problemen',
        'No account problems' => 'Geen account probleem',
        'No account activity' => 'Geen activiteit van account',
        'Number of accounts with problems: %s' => 'Aantal accounts met problemen: %s',
        'Number of accounts with warnings: %s' => 'Aantal account met waarschuwingen: %s',
        'Failing communications' => 'Falende communicatie',
        'No communication problems' => 'Geen communicatie problemen',
        'No communication logs' => 'Geen communicatielogboek',
        'Number of reported problems: %s' => 'Aantal met gemelde problemen: %s',
        'Open communications' => 'Open communicaties',
        'No active communications' => 'Geen actieve communicatie',
        'Number of open communications: %s' => 'Aantal actieve communicatie: %s',
        'Average processing time' => 'Gemiddelde verwerkingstijd',
        'List of communications (%s)' => 'Lijst met communicatie (%s)',
        'Settings' => 'Instellingen',
        'Entries per page' => 'Items per pagina',
        'No communications found.' => 'Geen communicatie gevonden.',
        '%s s' => '%s s',

        # Template: AdminCommunicationLogAccounts
        'Account Status' => 'Accountstatus',
        'Back to overview' => 'Terug naar het overzicht',
        'Filter for Accounts' => 'Account filter',
        'Filter for accounts' => 'Filter op accounts',
        'You can change the sort and order of those columns by clicking on the column header.' =>
            'U kunt de sortering en volgorde van de kolommen wijzigen door op de kolomkop te klikken.',
        'Account status for: %s' => 'Accountstatus voor: %s',
        'Status' => 'Status',
        'Account' => 'Account',
        'Edit' => 'Wijzig',
        'No accounts found.' => 'Geen accounts gevonden.',
        'Communication Log Details (%s)' => 'Communicatielogboek gegevens (%s)',
        'Direction' => 'Richting',
        'Start Time' => 'Begintijd',
        'End Time' => 'Eindtijd',
        'No communication log entries found.' => 'Geen communicatielogboekitems gevonden',

        # Template: AdminCommunicationLogCommunications
        'Duration' => 'Tijdsduur',

        # Template: AdminCommunicationLogObjectLog
        '#' => '#',
        'Priority' => 'Prioriteit',
        'Module' => 'Module',
        'Information' => 'Informatie',
        'No log entries found.' => 'Geen logvermeldingen gevonden',

        # Template: AdminCommunicationLogZoom
        'Detail view for %s communication started at %s' => 'Detailweergave voor %s communicatie gestart om %s',
        'Filter for Log Entries' => 'Filter op logitems',
        'Filter for log entries' => 'Filter op logitems',
        'Show only entries with specific priority and higher:' => 'Toon enkel items met deze prioriteit, of hoger',
        'Communication Log Overview (%s)' => 'Communicatielogboek overzicht (%s)',
        'No communication objects found.' => 'Geen communicatie objecten gevonden.',
        'Communication Log Details' => 'Communicatielogboek details',
        'Please select an entry from the list.' => 'Selecteer een item uit de lijst.',

        # Template: AdminCustomerCompany
        'Customer Management' => 'Beheer bedrijven',
        'Add Customer' => 'Klant toevoegen',
        'Edit Customer' => 'Klant bewerken',
        'Search' => 'Zoeken',
        'Wildcards like \'*\' are allowed.' => 'Wildcards zijn toegestaan.',
        'Select' => 'Selecteer',
        'List (only %s shown - more available)' => 'Lijst (slechts %s getoond - meer beschikbaar)',
        'total' => 'totaal',
        'Please enter a search term to look for customers.' => 'Typ om te zoeken naar klanten.',
        'Customer ID' => 'Klantcode',
        'Please note' => 'Let op',
        'This customer backend is read only!' => 'Deze klanten backend is niet te wijzigen!',

        # Template: AdminCustomerGroup
        'Manage Customer-Group Relations' => 'Beheer Bedrijf - Groep koppelingen',
        'Notice' => 'Notitie',
        'This feature is disabled!' => 'Deze functie is niet geactiveerd.',
        'Just use this feature if you want to define group permissions for customers.' =>
            'Gebuik deze mogelijkheid alleen als u groep-permissies voor klanten wilt gebruiken.',
        'Enable it here!' => 'Inschakelen',
        'Edit Customer Default Groups' => 'Bewerk standaard groepen voor klanten',
        'These groups are automatically assigned to all customers.' => 'Deze groepen worden toegewezen aan alle klanten.',
        'You can manage these groups via the configuration setting "CustomerGroupCompanyAlwaysGroups".' =>
            'U kunt deze groepen beheren via de optie "CustomerGroupAlwaysGroups".',
        'Filter for Groups' => 'Filter op groepen',
        'Select the customer:group permissions.' => 'Selecteer de permissies voor bedrijf:groep.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer).' =>
            'Als niets geselecteerd is, zijn er geen permissies in deze groep (de klant zal geen tickets kunnen zien).',
        'Search Results' => 'Zoekresultaat',
        'Customers' => 'Bedrijven',
        'Groups' => 'Groepen',
        'Change Group Relations for Customer' => 'Bewerk gekoppelde groepen voor deze klant',
        'Change Customer Relations for Group' => 'Bewerk gekoppelde klanten voor deze groep',
        'Toggle %s Permission for all' => '%s permissies aan/uit',
        'Toggle %s permission for %s' => '%s permissies aan/uit voor %s',
        'Customer Default Groups:' => 'Standaard groepen',
        'No changes can be made to these groups.' => 'Deze groepen kunnen niet gewijzigd worden.',
        'ro' => 'alleen lezen',
        'Read only access to the ticket in this group/queue.' => 'Leesrechten op de tickets in deze groep/wachtrij.',
        'rw' => 'lezen + schrijven',
        'Full read and write access to the tickets in this group/queue.' =>
            'Volledige lees- en schrijfrechten op de tickets in deze groep/wachtrij.',

        # Template: AdminCustomerUser
        'Customer User Management' => 'Beheer klanten',
        'Add Customer User' => 'Nieuwe klant',
        'Edit Customer User' => 'Klant bewerken',
        'Back to search results' => 'Terug naar zoekresultaat',
        'Customer user are needed to have a customer history and to login via customer panel.' =>
            'Klanten zijn nodig om een historie te kunnen inzien en om in te loggen via het klantenscherm.',
        'List (%s total)' => 'Lijst (%s in totaal)',
        'Username' => 'Gebruikersnaam',
        'Email' => 'E-mail',
        'Last Login' => 'Laatst ingelogd',
        'Login as' => 'Inloggen als',
        'Switch to customer' => 'Omschakelen naar klant',
        'This customer backend is read only, but the customer user preferences can be changed!' =>
            'Deze klanten backend is niet te wijzigen maar de voorkeuren van deze klant kunnen aangepast worden!',
        'This field is required and needs to be a valid email address.' =>
            'Dit veld is verplicht en moet een geldig e-mailadres zijn.',
        'This email address is not allowed due to the system configuration.' =>
            'Dit e-mailadres is niet toegestaan.',
        'This email address failed MX check.' => 'Dit e-mailadres klopt niet.',
        'DNS problem, please check your configuration and the error log.' =>
            'DNS probleem geconstateerd. Kijk in de log voor meer details en pas uw configuratie aan.',
        'The syntax of this email address is incorrect.' => 'De syntax van dit e-mailadres klopt niet.',
        'This CustomerID is invalid.' => 'Deze klantcode is ongeldig.',
        'Effective Permissions for Customer User' => 'Effectieve machtigingen voor klanten',
        'Group Permissions' => 'Groepsrechten',
        'This customer user has no group permissions.' => 'Deze klant heeft geen groepsrechten.',
        'Table above shows effective group permissions for the customer user. The matrix takes into account all inherited permissions (e.g. via customer groups). Note: The table does not consider changes made to this form without submitting it.' =>
            'De bovenstaande tabel toont de effectieve rechten van de groep voor deze klant. De matrix houdt rekening met alle overgeërfde rechten (bv. via klantgroepen). Merk op: de tabel houdt geen rekening met wijzigingen die in dit formulier werden aangebracht en nog niet opgeslagen zijn.',
        'Customer Access' => 'Bedrijf toegang',
        'Customer' => 'Klant',
        'This customer user has no customer access.' => 'Deze klant heeft geen toegang.',
        'Table above shows granted customer access for the customer user by permission context. The matrix takes into account all inherited access (e.g. via customer groups). Note: The table does not consider changes made to this form without submitting it.' =>
            '',

        # Template: AdminCustomerUserCustomer
        'Manage Customer User-Customer Relations' => 'Beheer Klant Gebruiker-Klant koppelingen',
        'Select the customer user:customer relations.' => 'Selecteer de klant gebruiker:klant relaties.',
        'Customer Users' => 'Klanten',
        'Change Customer Relations for Customer User' => 'Bewerk Klan Relaties voor Klant gebruiker',
        'Change Customer User Relations for Customer' => 'Wijzig Klant Gebruiker koppelingen voor Klant',
        'Toggle active state for all' => 'Alles actief aan/uit',
        'Active' => 'Actief',
        'Toggle active state for %s' => 'Actief aan/uit voor %s',

        # Template: AdminCustomerUserGroup
        'Manage Customer User-Group Relations' => 'Beheer Klant gebruiker - Groep koppelingen',
        'Just use this feature if you want to define group permissions for customer users.' =>
            'Gebruik deze functie alleen als u groepsrechten voor klantgebruikers wilt definiëren.',
        'Edit Customer User Default Groups' => 'Bewerk de klant - groep koppeling',
        'These groups are automatically assigned to all customer users.' =>
            '',
        'You can manage these groups via the configuration setting "CustomerGroupAlwaysGroups".' =>
            'U kunt deze groepen beheren via de optie "CustomerGroupAlwaysGroups".',
        'Filter for groups' => 'Filter op groepen',
        'Select the customer user - group permissions.' => 'Selecteer de Klant gebruiker - groep permissies',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer user).' =>
            'Als niets geselecteerd is, zijn er geen permissies in deze groep (tickets zijn niet toegankelijk voor de klant gebruiker).',
        'Customer User Default Groups:' => 'Klant Gebruiker Standaard Groepen:',

        # Template: AdminCustomerUserService
        'Manage Customer User-Service Relations' => 'Beheer Klantgebruiker-Service relaties',
        'Edit default services' => 'Beheer standaard services',
        'Filter for Services' => 'Filter op services',
        'Filter for services' => 'Filter voor Services',
        'Services' => 'Services',

        # Template: AdminDynamicField
        'Dynamic Fields Management' => 'Beheer van dynamische velden',
        'Add new field for object' => 'Nieuw veld voor object',
        'Filter for Dynamic Fields' => 'Filter op Dynamische Velden',
        'Filter for dynamic fields' => 'Filter op dynamische velden',
        'More Business Fields' => 'Meer Zakelijke Velden',
        'Would you like to benefit from additional dynamic field types for businesses? Upgrade to %s to get access to the following field types:' =>
            '',
        'Database' => 'Database',
        'Use external databases as configurable data sources for this dynamic field.' =>
            '',
        'Web service' => 'Webservice',
        'External web services can be configured as data sources for this dynamic field.' =>
            'Externe webservices kunnen als databronnen geconfigureerd worden voor dynamische velden',
        'Contact with data' => 'Contact met gegevens',
        'This feature allows to add (multiple) contacts with data to tickets.' =>
            'Met deze functie kunt u (meerdere) contacten met gegevens toevoegen aan tickets.',
        'To add a new field, select the field type from one of the object\'s list, the object defines the boundary of the field and it can\'t be changed after the field creation.' =>
            'Om een nieuw veld toe te voegen selecteert u het veldtype uit de objectlijst, het object definieert de grens van het veld en deze kan na het aanmaken niet worden gewijzigd.',
        'Dynamic Fields List' => 'Lijst met dynamische velden',
        'Dynamic fields per page' => 'Dynamische velden per pagina',
        'Label' => 'Label',
        'Order' => 'Volgorde',
        'Object' => 'Object',
        'Delete this field' => 'Verwijder dit veld',

        # Template: AdminDynamicFieldCheckbox
        'Dynamic Fields' => 'Dynamische velden',
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
        'Is not possible to invalidate this entry, all config settings have to be changed beforehand.' =>
            '',
        'Field type' => 'Veldtype',
        'Object type' => 'Objecttype',
        'Internal field' => 'Intern veld',
        'This field is protected and can\'t be deleted.' => 'Dit veld is beschermd en kan niet worden verwijderd.',
        'This dynamic field is used in the following config settings:' =>
            'Dit dynamische veld wordt gebruikt in de volgende configuratie-instellingen:',
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
        'If special characters (&, @, :, /, etc.) should not be encoded, use \'url\' instead of \'uri\' filter.' =>
            '',
        'Example' => 'Voorbeeld',
        'Link for preview' => 'Link voor voorvertoning',
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
        'Admin Message' => 'Admin Bericht',
        'With this module, administrators can send messages to agents, group or role members.' =>
            'Vanuit dit scherm kunt u een bericht sturen aan behandelaars of klanten.',
        'Create Administrative Message' => 'Stuur een bericht',
        'Your message was sent to' => 'Uw bericht is verstuurd aan',
        'From' => 'Van',
        'Send message to users' => 'Stuur bericht aan gebruikers',
        'Send message to group members' => 'Stuur bericht aan accounts met groep',
        'Group members need to have permission' => 'Leden van de groep moeten permissies hebben',
        'Send message to role members' => 'Stuur bericht naar accounts met rol',
        'Also send to customers in groups' => 'Stuur ook naar klanten in deze groepen',
        'Body' => 'Bericht tekst',
        'Send' => 'Verstuur',

        # Template: AdminGenericAgent
        'Generic Agent Job Management' => 'Generieke Agent Taakbeheer',
        'Edit Job' => 'Bewerk taak',
        'Add Job' => 'Taak toevoegen',
        'Run Job' => 'Voer taak uit',
        'Filter for Jobs' => '',
        'Filter for jobs' => '',
        'Last run' => 'Laatst uitgevoerd',
        'Run Now!' => 'Nu uitvoeren',
        'Delete this task' => 'Verwijder deze taak',
        'Run this task' => 'Voer deze taak',
        'Job Settings' => 'Taak instellingen',
        'Job name' => 'Naam',
        'The name you entered already exists.' => 'De naam die u hebt opgegeven bestaat al.',
        'Automatic Execution (Multiple Tickets)' => 'Automatische Uitvoering (Meerder Tickets)',
        'Execution Schedule' => 'Tijdschema',
        'Schedule minutes' => 'minuten',
        'Schedule hours' => 'uren',
        'Schedule days' => 'dagen',
        'Automatic execution values are in the system timezone.' => 'Automatische uitvoering waardes bevinden zich binnen de systeemtijdzone.',
        'Currently this generic agent job will not run automatically.' =>
            'Deze taak zal niet automatisch draaien.',
        'To enable automatic execution select at least one value from minutes, hours and days!' =>
            'Om automatisch uit te voeren selecteer ten minste één waarde bij minuten, uren en dagen.',
        'Event Based Execution (Single Ticket)' => 'Gebeurtenis gebaseerde uitvoering (één ticket)',
        'Event Triggers' => 'Event triggers',
        'List of all configured events' => 'Lijst van beschikbare events',
        'Delete this event' => 'Verwijder dit event',
        'Additionally or alternatively to a periodic execution, you can define ticket events that will trigger this job.' =>
            'Naast of in plaats van uitvoeren op een tijdschema kunt u ook ticket events selecteren die deze taak triggeren.',
        'If a ticket event is fired, the ticket filter will be applied to check if the ticket matches. Only then the job is run on that ticket.' =>
            'Als een ticket-event plaatsvindt zal dit filter worden toegepast om te toetsen of dit ticket voldoet. Alleen dan wordt deze taak uitgevoerd.',
        'Do you really want to delete this event trigger?' => 'Wilt u deze event trigger verwijderen?',
        'Add Event Trigger' => 'Nieuwe event trigger toevoegen',
        'To add a new event select the event object and event name' => '',
        'Select Tickets' => 'Selecteer Tickets',
        '(e. g. 10*5155 or 105658*)' => '(bijvoorbeeld 10*5155 or 105658*)',
        '(e. g. 234321)' => '(bijvoorbeeld 234321)',
        'Customer user ID' => 'Klantgebruiker ID',
        '(e. g. U5150)' => '(bijvoorbeeld U5150)',
        'Fulltext-search in article (e. g. "Mar*in" or "Baue*").' => 'Zoek in tekst van een interactie. Gebruik wildcards (bijvoorbeeld "Mar*in" of "Jans*").',
        'To' => 'Aan',
        'Cc' => 'Cc',
        'Service' => 'Service',
        'Service Level Agreement' => 'Service Level Agreement',
        'Queue' => 'Wachtrij',
        'State' => 'Status',
        'Agent' => 'Behandelaar',
        'Owner' => 'Eigenaar',
        'Responsible' => 'Verantwoordelijke',
        'Ticket lock' => 'Vergrendeling',
        'Dynamic fields' => 'Dynamische velden',
        'Add dynamic field' => '',
        'Create times' => 'Tijdstip van aanmaken',
        'No create time settings.' => 'Alle',
        'Ticket created' => 'Ticket aangemaakt',
        'Ticket created between' => 'Ticket aangemaakt tussen',
        'and' => 'en',
        'Last changed times' => 'Tijdstip van laatste wijziging',
        'No last changed time settings.' => 'Geen instellingen voor tijdstip laatste wijziging.',
        'Ticket last changed' => 'Laatste wijziging ticket',
        'Ticket last changed between' => 'Laatste wijziging ticket tussen',
        'Change times' => 'Tijdstip van wijzigen',
        'No change time settings.' => 'Alle',
        'Ticket changed' => 'Ticket gewijzigd',
        'Ticket changed between' => 'Ticket gewijzigd tussen',
        'Last close times' => '',
        'No last close time settings.' => '',
        'Ticket last close' => '',
        'Ticket last close between' => '',
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
        'New customer user ID' => 'Nieuwe klantgebruiker ID',
        'New customer ID' => 'Nieuwe klantcode',
        'New title' => 'Nieuwe titel',
        'New type' => 'Nieuw type',
        'Archive selected tickets' => 'Archiveer geselecteerde tickets',
        'Add Note' => 'Notitie toevoegen',
        'Visible for customer' => 'Zichtbaar voor klant',
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
        'Results' => 'Resultaten',
        '%s Tickets affected! What do you want to do?' => '%s tickets gevonden! Wat wilt u doen?',
        'Warning: You used the DELETE option. All deleted tickets will be lost!' =>
            'Waarschuwing: u hebt voor VERWIJDEREN gekozen!',
        'Warning: There are %s tickets affected but only %s may be modified during one job execution!' =>
            'Waarschuwing: Er worden %s tickets geraakt, maar slechts %s tickets kunnen worden aangepast gedurende één taak executie.',
        'Affected Tickets' => 'Gevonden tickets',
        'Age' => 'Leeftijd',

        # Template: AdminGenericInterfaceDebugger
        'GenericInterface Web Service Management' => 'GenericInterface Web Service Beheer',
        'Web Service Management' => 'Webservice Beheer',
        'Debugger' => 'Debugger',
        'Go back to web service' => 'Ga terug naar webservice',
        'Clear' => 'Leegmaken',
        'Do you really want to clear the debug log of this web service?' =>
            'Wilt u de debug-log van deze webservice leegmaken?',
        'Request List' => 'Lijst van verzoeken',
        'Time' => 'Tijd',
        'Communication ID' => 'Communicatie ID',
        'Remote IP' => 'IP-adres afzender',
        'Loading' => 'Laden',
        'Select a single request to see its details.' => 'Kies een verzoek om de details te zien.',
        'Filter by type' => 'Filter op type',
        'Filter from' => 'Filter op afzender',
        'Filter to' => 'Filter op bestemming',
        'Filter by remote IP' => 'Filter op IP-adres',
        'Limit' => 'Beperk tot',
        'Refresh' => 'Vernieuwen',

        # Template: AdminGenericInterfaceErrorHandlingDefault
        'Add ErrorHandling' => '',
        'Edit ErrorHandling' => '',
        'Do you really want to delete this error handling module?' => '',
        'All configuration data will be lost.' => 'Alle configuratiedata gaat verloren.',
        'General options' => 'Algemene opties',
        'The name can be used to distinguish different error handling configurations.' =>
            '',
        'Please provide a unique name for this web service.' => 'Geef een unieke naam op voor deze Web Service.',
        'Error handling module backend' => '',
        'This OTRS error handling backend module will be called internally to process the error handling mechanism.' =>
            '',
        'Processing options' => '',
        'Configure filters to control error handling module execution.' =>
            '',
        'Only requests matching all configured filters (if any) will trigger module execution.' =>
            '',
        'Operation filter' => '',
        'Only execute error handling module for selected operations.' => '',
        'Note: Operation is undetermined for errors occuring while receiving incoming request data. Filters involving this error stage should not use operation filter.' =>
            '',
        'Invoker filter' => '',
        'Only execute error handling module for selected invokers.' => '',
        'Error message content filter' => 'Foutmelding inhoud filter',
        'Enter a regular expression to restrict which error messages should cause error handling module execution.' =>
            '',
        'Error message subject and data (as seen in the debugger error entry) will considered for a match.' =>
            '',
        'Example: Enter \'^.*401 Unauthorized.*\$\' to handle only authentication related errors.' =>
            '',
        'Error stage filter' => '',
        'Only execute error handling module on errors that occur during specific processing stages.' =>
            '',
        'Example: Handle only errors where mapping for outgoing data could not be applied.' =>
            '',
        'Error code' => 'Foutcode',
        'An error identifier for this error handling module.' => '',
        'This identifier will be available in XSLT-Mapping and shown in debugger output.' =>
            '',
        'Error message' => 'Foutmelding',
        'An error explanation for this error handling module.' => '',
        'This message will be available in XSLT-Mapping and shown in debugger output.' =>
            '',
        'Define if processing should be stopped after module was executed, skipping all remaining modules or only those of the same backend.' =>
            '',
        'Default behavior is to resume, processing the next module.' => '',

        # Template: AdminGenericInterfaceErrorHandlingRequestRetry
        'This module allows to configure scheduled retries for failed requests.' =>
            '',
        'Default behavior of GenericInterface web services is to send each request exactly once and not to reschedule after errors.' =>
            '',
        'If more than one module capable of scheduling a retry is executed for an individual request, the module executed last is authoritative and determines if a retry is scheduled.' =>
            '',
        'Request retry options' => '',
        'Retry options are applied when requests cause error handling module execution (based on processing options).' =>
            '',
        'Schedule retry' => '',
        'Should requests causing an error be triggered again at a later time?' =>
            '',
        'Initial retry interval' => '',
        'Interval after which to trigger the first retry.' => '',
        'Note: This and all further retry intervals are based on the error handling module execution time for the initial request.' =>
            '',
        'Factor for further retries' => '',
        'If a request returns an error even after a first retry, define if subsequent retries are triggered using the same interval or in increasing intervals.' =>
            '',
        'Example: If a request is initially triggered at 10:00 with initial interval at \'1 minute\' and retry factor at \'2\', retries would be triggered at 10:01 (1 minute), 10:03 (2*1=2 minutes), 10:07 (2*2=4 minutes), 10:15 (2*4=8 minutes), ...' =>
            '',
        'Maximum retry interval' => '',
        'If a retry interval factor of \'1.5\' or \'2\' is selected, undesirably long intervals can be prevented by defining the largest interval allowed.' =>
            '',
        'Intervals calculated to exceed the maximum retry interval will then automatically be shortened accordingly.' =>
            '',
        'Example: If a request is initially triggered at 10:00 with initial interval at \'1 minute\', retry factor at \'2\' and maximum interval at \'5 minutes\', retries would be triggered at 10:01 (1 minute), 10:03 (2 minutes), 10:07 (4 minutes), 10:12 (8=>5 minutes), 10:17, ...' =>
            '',
        'Maximum retry count' => '',
        'Maximum number of retries before a failing request is discarded, not counting the initial request.' =>
            '',
        'Example: If a request is initially triggered at 10:00 with initial interval at \'1 minute\', retry factor at \'2\' and maximum retry count at \'2\', retries would be triggered at 10:01 and 10:02 only.' =>
            '',
        'Note: Maximum retry count might not be reached if a maximum retry period is configured as well and reached earlier.' =>
            '',
        'This field must be empty or contain a positive number.' => '',
        'Maximum retry period' => '',
        'Maximum period of time for retries of failing requests before they are discarded (based on the error handling module execution time for the initial request).' =>
            '',
        'Retries that would normally be triggered after maximum period is elapsed (according to retry interval calculation) will automatically be triggered at maximum period exactly.' =>
            '',
        'Example: If a request is initially triggered at 10:00 with initial interval at \'1 minute\', retry factor at \'2\' and maximum retry period at \'30 minutes\', retries would be triggered at 10:01, 10:03, 10:07, 10:15 and finally at 10:31=>10:30.' =>
            '',
        'Note: Maximum retry period might not be reached if a maximum retry count is configured as well and reached earlier.' =>
            '',

        # Template: AdminGenericInterfaceInvokerDefault
        'Add Invoker' => '',
        'Edit Invoker' => '',
        'Do you really want to delete this invoker?' => 'Wilt u deze invoker echt verwijderen?',
        'Invoker Details' => 'Invoker details',
        'The name is typically used to call up an operation of a remote web service.' =>
            'De naam wordt gebruikt om een operatie van een webservice aan te roepen.',
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
        'Condition' => 'Conditie',
        'Edit this event' => 'Bewerk deze gebeurtenis',
        'This invoker will be triggered by the configured events.' => 'De invoker wordt aangeroepen door de geconfigureerde events.',
        'Add Event' => 'Gebeurtenis toevoegen',
        'To add a new event select the event object and event name and click on the "+" button' =>
            'Om een nieuw event toe te voegen, selecteer het event object en de naam van het event en klik op de "+".',
        'Asynchronous event triggers are handled by the OTRS Scheduler Daemon in background (recommended).' =>
            'Asynchrone event-triggers worden in de achtergrond afgehandeld door de OTRS Scheduler Daemon (aangeraden).',
        'Synchronous event triggers would be processed directly during the web request.' =>
            'Synchrone event triggers worden afgehandeld direct tijdens het event (blocking).',

        # Template: AdminGenericInterfaceInvokerEvent
        'GenericInterface Invoker Event Settings for Web Service %s' => '',
        'Go back to' => 'Ga terug naar',
        'Delete all conditions' => 'Verwijder alle condities',
        'Do you really want to delete all the conditions for this event?' =>
            '',
        'General Settings' => 'Algemene Instellingen',
        'Event type' => 'Gebeurtenis type',
        'Conditions' => 'Condities',
        'Conditions can only operate on non-empty fields.' => '',
        'Type of Linking between Conditions' => 'Type koppeling tussen condities',
        'Remove this Condition' => 'Verwijder conditie',
        'Type of Linking' => 'Type koppeling',
        'Fields' => 'Velden',
        'Add a new Field' => 'Nieuw veld',
        'Remove this Field' => 'Verwijder dit veld',
        'And can\'t be repeated on the same condition.' => 'En kan niet worden herhaald in dezelfde conditie.',
        'Add New Condition' => 'Nieuwe conditie',

        # Template: AdminGenericInterfaceMappingSimple
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

        # Template: AdminGenericInterfaceMappingXSLT
        'General Shortcuts' => '',
        'MacOS Shortcuts' => 'MacOS Sneltoetsen',
        'Comment code' => '',
        'Uncomment code' => '',
        'Auto format code' => '',
        'Expand/Collapse code block' => '',
        'Find' => 'Zoek',
        'Find next' => 'Zoek volgende',
        'Find previous' => 'Zoek vorige',
        'Find and replace' => 'Zoek en vervang',
        'Find and replace all' => 'Zoek en vervang alle',
        'XSLT Mapping' => 'XSLT-toewijzing',
        'XSLT stylesheet' => 'XSLT stylesheet',
        'The entered data is not a valid XSLT style sheet.' => 'De ingevoerde data is geen geldig XSLT stylesheet.',
        'Here you can add or modify your XSLT mapping code.' => '',
        'The editing field allows you to use different functions like automatic formatting, window resize as well as tag- and bracket-completion.' =>
            '',
        'Data includes' => 'Data bevat',
        'Select one or more sets of data that were created at earlier request/response stages to be included in mappable data.' =>
            '',
        'These sets will appear in the data structure at \'/DataInclude/<DataSetName>\' (see debugger output of actual requests for details).' =>
            '',
        'Data key regex filters (before mapping)' => '',
        'Data key regex filters (after mapping)' => '',
        'Regular expressions' => 'Reguliere expressie',
        'Replace' => 'Vervang',
        'Remove regex' => 'Regex verwijderen',
        'Add regex' => 'Regex toevoegen',
        'These filters can be used to transform keys using regular expressions.' =>
            '',
        'The data structure will be traversed recursively and all configured regexes will be applied to all keys.' =>
            '',
        'Use cases are e.g. removing key prefixes that are undesired or correcting keys that are invalid as XML element names.' =>
            '',
        'Example 1: Search = \'^jira:\' / Replace = \'\' turns \'jira:element\' into \'element\'.' =>
            '',
        'Example 2: Search = \'^\' / Replace = \'_\' turns \'16x16\' into \'_16x16\'.' =>
            '',
        'Example 3: Search = \'^(?<number>\d+) (?<text>.+?)\$\' / Replace = \'_\$+{text}_\$+{number}\' turns \'16 elementname\' into \'_elementname_16\'.' =>
            '',
        'For information about regular expressions in Perl please see here:' =>
            '',
        'Perl regular expressions tutorial' => '',
        'If modifiers are desired they have to be specified within the regexes themselves.' =>
            '',
        'Regular expressions defined here will be applied before the XSLT mapping.' =>
            '',
        'Regular expressions defined here will be applied after the XSLT mapping.' =>
            '',

        # Template: AdminGenericInterfaceOperationDefault
        'Add Operation' => '',
        'Edit Operation' => '',
        'Do you really want to delete this operation?' => 'Wilt u deze operatie echt verwijderen?',
        'Operation Details' => 'Operatie-details',
        'The name is typically used to call up this web service operation from a remote system.' =>
            'De naam wordt normaal gesproken gebruikt om deze Web Service aan te roepen vanaf een ander systeem.',
        'Operation backend' => 'Operatie-backend',
        'This OTRS operation backend module will be called internally to process the request, generating data for the response.' =>
            'Deze OTRS operatie-module zal intern worden gebruikt om de data voor de respons te genereren.',
        'Mapping for incoming request data' => 'Koppeling voor inkomende data',
        'The request data will be processed by this mapping, to transform it to the kind of data OTRS expects.' =>
            'De inkomende data wordt verwerkt door deze koppeling, om het om te zetten naar de data die OTRS verwacht.',
        'Mapping for outgoing response data' => 'Koppeling voor respons-data',
        'The response data will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            'De respons-data wordt verwerkt door deze koppeling, om het om te zetten naar de data die het andere systeem verwacht.',
        'Include Ticket Data' => '',
        'Include ticket data in response.' => '',

        # Template: AdminGenericInterfaceTransportHTTPREST
        'Network Transport' => 'Netwerk Transport',
        'Properties' => 'Eigenschappen',
        'Route mapping for Operation' => 'Route maken voor actie',
        'Define the route that should get mapped to this operation. Variables marked by a \':\' will get mapped to the entered name and passed along with the others to the mapping. (e.g. /Ticket/:TicketID).' =>
            'Bepaal de route die gemapt moet worden op deze operatie. Variabelen gemarkeerd met een \':\' woden gemapt op de ingevoerde naam en doorgegeven met de maping (bv. /Ticket/:TicketID).',
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
        'Additional response headers' => '',
        'Add response header' => '',
        'Endpoint' => 'Eindpunt',
        'URI to indicate specific location for accessing a web service.' =>
            '',
        'e.g https://www.otrs.com:10745/api/v1.0 (without trailing backslash)' =>
            'e.g https://www.otrs.com:10745/api/v1.0 (zonder trailing backslash)',
        'Timeout' => 'time-out',
        'Timeout value for requests.' => '',
        'Authentication' => 'Authenticatie',
        'An optional authentication mechanism to access the remote system.' =>
            '',
        'BasicAuth User' => 'BasicAuth Gebruiker',
        'The user name to be used to access the remote system.' => 'De gebruikersnaam om toegang te krijgen tot het andere systeem.',
        'BasicAuth Password' => 'BasicAuth Wachtwoord',
        'The password for the privileged user.' => 'Wachtwoord',
        'Use Proxy Options' => 'Gebruik Proxy Opties',
        'Show or hide Proxy options to connect to the remote system.' => '',
        'Proxy Server' => 'Proxy-server',
        'URI of a proxy server to be used (if needed).' => 'URI van de proxy-server (indien nodig).',
        'e.g. http://proxy_hostname:8080' => 'e.g. http://proxy_hostname:8080',
        'Proxy User' => 'Proxy-gebruikersnaam',
        'The user name to be used to access the proxy server.' => 'De gebruikersnaam voor toegang tot de proxy-server.',
        'Proxy Password' => 'Proxy-wachtwoord',
        'The password for the proxy user.' => 'Het wachtwoord voor de proxy-gebruiker.',
        'Skip Proxy' => 'Proxy overslaan',
        'Skip proxy servers that might be configured globally?' => '',
        'Use SSL Options' => 'Configureer SSL opties',
        'Show or hide SSL options to connect to the remote system.' => 'Toon of verberg SSL opties om te verbinden naar het andere systeem',
        'Client Certificate' => 'Client Certificaat',
        'The full path and name of the SSL client certificate file (must be in PEM, DER or PKCS#12 format).' =>
            '',
        'e.g. /opt/otrs/var/certificates/SOAP/certificate.pem' => 'bv. /opt/otrs/var/certificates/SOAP/certificate.pem',
        'Client Certificate Key' => 'Client Certificaatsleutel',
        'The full path and name of the SSL client certificate key file (if not already included in certificate file).' =>
            '',
        'e.g. /opt/otrs/var/certificates/SOAP/key.pem' => 'bv. /opt/otrs/var/certificates/SOAP/key.pem',
        'Client Certificate Key Password' => 'Client Certificaatsleutel wachtwoord',
        'The password to open the SSL certificate if the key is encrypted.' =>
            '',
        'Certification Authority (CA) Certificate' => '',
        'The full path and name of the certification authority certificate file that validates SSL certificate.' =>
            'Het volledige pad en de naam van het CA certificaat dat het SSL certificaat valideert.',
        'e.g. /opt/otrs/var/certificates/SOAP/CA/ca.pem' => 'Bijvoorbeeld /opt/otrs/var/certificates/SOAP/CA/ca.pem',
        'Certification Authority (CA) Directory' => 'Certification Authority (CA) directory',
        'The full path of the certification authority directory where the CA certificates are stored in the file system.' =>
            'Het volledige pad van de directory waar de CA-certificaten worden opgeslagen.',
        'e.g. /opt/otrs/var/certificates/SOAP/CA' => 'bijvoorbeeld /opt/otrs/var/certificates/SOAP/CA',
        'Controller mapping for Invoker' => 'Controller mapping voor Invoker',
        'The controller that the invoker should send requests to. Variables marked by a \':\' will get replaced by the data value and passed along with the request. (e.g. /Ticket/:TicketID?UserLogin=:UserLogin&Password=:Password).' =>
            'De controller waar de invoker zijn verzoeken naar moet versturen. Variabelen die beginnen met een \':\' worden vervangen door de data waarde en doorgegeven met het verzoek. (bijvoorbeeld Ticket/:TicketID?UserLogin=:UserLogin&Password=:Password).',
        'Valid request command for Invoker' => 'Geldig verzoek commando voor Invoker',
        'A specific HTTP command to use for the requests with this Invoker (optional).' =>
            'Een specifiek HTTP commando om te gebruiken voor de verzoeken met deze Invoker (optioneel).',
        'Default command' => 'Standaard opdracht',
        'The default HTTP command to use for the requests.' => 'De standaard HTTP opdracht die gebruikt wordt bij verzoeken.',

        # Template: AdminGenericInterfaceTransportHTTPSOAP
        'e.g. https://local.otrs.com:8000/Webservice/Example' => 'bv. https://local.otrs.com:8000/Webservice/Example',
        'Set SOAPAction' => '',
        'Set to "Yes" in order to send a filled SOAPAction header.' => '',
        'Set to "No" in order to send an empty SOAPAction header.' => '',
        'Set to "Yes" in order to check the received SOAPAction header (if not empty).' =>
            '',
        'Set to "No" in order to ignore the received SOAPAction header.' =>
            '',
        'SOAPAction scheme' => '',
        'Select how SOAPAction should be constructed.' => '',
        'Some web services require a specific construction.' => '',
        'Some web services send a specific construction.' => '',
        'SOAPAction separator' => 'SOAP-action separator',
        'Character to use as separator between name space and SOAP operation.' =>
            '',
        'Usually .Net web services use "/" as separator.' => '',
        'SOAPAction free text' => '',
        'Text to be used to as SOAPAction.' => '',
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
        'Sort options' => 'Sorteer voorkeuren',
        'Add new first level element' => 'Voeg nieuw eerste level element toe',
        'Element' => 'Element',
        'Outbound sort order for xml fields (structure starting below function name wrapper) - see documentation for SOAP transport.' =>
            'Uitgaande sorteer volgorde voor xml velden (structuur begint onder functie naam warpper) - zie SOAP transport documentatie.',

        # Template: AdminGenericInterfaceWebservice
        'Add Web Service' => 'Webservice toevoegen',
        'Edit Web Service' => 'Bewerk webservice',
        'Clone Web Service' => 'Kloon Webservice',
        'The name must be unique.' => 'De naam moet uniek zijn',
        'Clone' => 'Kloon',
        'Export Web Service' => 'Exporteer Webservice',
        'Import web service' => 'Importeer webservice',
        'Configuration File' => 'Configuratiebestand',
        'The file must be a valid web service configuration YAML file.' =>
            'Het bestand moet een geldig web service YAML bestand zijn.',
        'Here you can specify a name for the webservice. If this field is empty, the name of the configuration file is used as name.' =>
            '',
        'Import' => 'Importeer',
        'Configuration History' => 'Configuratiegeschiedenis',
        'Delete web service' => 'Verwijder webservice',
        'Do you really want to delete this web service?' => 'Wilt u deze webservice verwijderen?',
        'Ready2Adopt Web Services' => 'Ready2Adopt Webservices',
        'Here you can activate Ready2Adopt web services showcasing our best practices that are a part of %s.' =>
            '',
        'Please note that these web services may depend on other modules only available with certain %s contract levels (there will be a notification with further details when importing).' =>
            '',
        'Import Ready2Adopt web service' => 'Importeer Ready2Adopt webservice',
        'Would you like to benefit from web services created by experts? Upgrade to %s to import some sophisticated Ready2Adopt web services.' =>
            '',
        'After you save the configuration you will be redirected again to the edit screen.' =>
            'Na opslaan blijft u in dit scherm.',
        'If you want to return to overview please click the "Go to overview" button.' =>
            'Als u terug wilt na het overzicht klik dan op de "Naar het overzicht" knop.',
        'Remote system' => 'Ander systeem',
        'Provider transport' => 'Provider-transport',
        'Requester transport' => 'Requester-transport',
        'Debug threshold' => 'Debug-niveau',
        'In provider mode, OTRS offers web services which are used by remote systems.' =>
            'In Provider-modus levert OTRS web services die aangeroepen worden door andere systemen.',
        'In requester mode, OTRS uses web services of remote systems.' =>
            'In Requester-modus gebruikt OTRS web services van andere systemen.',
        'Network transport' => 'Netwerk-transport',
        'Error Handling Modules' => '',
        'Error handling modules are used to react in case of errors during the communication. Those modules are executed in a specific order, which can be changed by drag and drop.' =>
            '',
        'Backend' => '',
        'Add error handling module' => '',
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

        # Template: AdminGenericInterfaceWebserviceHistory
        'History' => 'Geschiedenis',
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

        # Template: AdminGroup
        'Group Management' => 'Groepenbeheer',
        'Add Group' => 'Groep toevoegen',
        'Edit Group' => 'Bewerk groep',
        'The admin group is to get in the admin area and the stats group to get stats area.' =>
            'Leden van de groep Admin mogen in het administratie gedeelte, leden van de groep Stats hebben toegang tot het statistieken gedeelte.',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...). ' =>
            'Maak nieuwe groepen aan om tickets te kunnen scheiden en de juiste wachtrijen aan behandelaars te tonen (bijv. support, sales, management).',
        'It\'s useful for ASP solutions. ' => 'Bruikbaar voor ASP situaties.',

        # Template: AdminLog
        'System Log' => 'Logboek',
        'Here you will find log information about your system.' => 'Hier is de OTRS log te raadplegen.',
        'Hide this message' => 'Verberg dit paneel',
        'Recent Log Entries' => 'Recente Logboekregels',
        'Facility' => 'Maatregel',
        'Message' => 'Bericht',

        # Template: AdminMailAccount
        'Mail Account Management' => 'Beheer e-mail accounts',
        'Add Mail Account' => 'Mail account toevoegen',
        'Edit Mail Account for host' => '',
        'and user account' => 'en gebruikersaccount',
        'Filter for Mail Accounts' => '',
        'Filter for mail accounts' => '',
        'All incoming emails with one account will be dispatched in the selected queue.' =>
            '',
        'If your account is marked as trusted, the X-OTRS headers already existing at arrival time (for priority etc.) will be kept and used, for example in PostMaster filters.' =>
            '',
        'Outgoing email can be configured via the Sendmail* settings in %s.' =>
            '',
        'System Configuration' => 'Systeemconfiguratie',
        'Host' => 'Server',
        'Delete account' => 'Verwijder account',
        'Fetch mail' => 'Mail ophalen',
        'Do you really want to delete this mail account?' => '',
        'Password' => 'Wachtwoord',
        'Example: mail.example.com' => 'Bijvoorbeeld: mail.example.com',
        'IMAP Folder' => 'IMAP folder',
        'Only modify this if you need to fetch mail from a different folder than INBOX.' =>
            'Alleen aanpassen als u uit een andere folder dan INBOX mails wilt ophalen.',
        'Trusted' => 'Vertrouwd',
        'Dispatching' => 'Sortering',
        'Edit Mail Account' => 'Bewerk mail account',

        # Template: AdminNavigationBar
        'Administration Overview' => 'Administratieoverzicht',
        'Filter for Items' => '',
        'Filter' => 'Filter',
        'Favorites' => 'Favorieten',
        'You can add favorites by moving your cursor over items on the right side and clicking the star icon.' =>
            '',
        'Links' => 'Koppelingen',
        'View the admin manual on Github' => '',
        'No Matches' => 'Geen overeenkomsten',
        'Sorry, your search didn\'t match any items.' => '',
        'Set as favorite' => '',

        # Template: AdminNotificationEvent
        'Ticket Notification Management' => 'Ticket meldingen beheer',
        'Here you can upload a configuration file to import Ticket Notifications to your system. The file needs to be in .yml format as exported by the Ticket Notification module.' =>
            'Hier kunt u configuratie bestanden uploaden om Ticket meldingen te importeren. Het bestand moet in .yml format zijn zoals geëxporteerd door de Ticket meldingen module.',
        'Here you can choose which events will trigger this notification. An additional ticket filter can be applied below to only send for ticket with certain criteria.' =>
            'Hier kun je kiezen welke events deze notificatie inschakelen. Een extra ticket filter kan worden toegepast om de notificatie alleen te versturen als het ticket voldoet aan bepaalde criteria.',
        'Ticket Filter' => 'Ticket filter',
        'Lock' => 'Vergrendel',
        'SLA' => 'SLA',
        'Customer User ID' => 'Klantgebruiker ID',
        'Article Filter' => 'Filter interacties',
        'Only for ArticleCreate and ArticleSend event' => 'Alleen voor ArticleCreate en ArticleSend event',
        'Article sender type' => 'Soort verzender',
        'If ArticleCreate or ArticleSend is used as a trigger event, you need to specify an article filter as well. Please select at least one of the article filter fields.' =>
            'Als ArticleCreate of ArticleSend wordt gebruikt als trigger event, moet je een article filter spcificeren. Selecteer minimaal één van de artikel filter velden.',
        'Customer visibility' => 'Klant zichtbaarheid',
        'Communication channel' => 'Communicatiekanaal',
        'Include attachments to notification' => 'Voeg bijlagen toe aan melding',
        'Notify user just once per day about a single ticket using a selected transport.' =>
            'Verstuur slechts éénmaal per dag over één ticket via de geselecteerde methode',
        'This field is required and must have less than 4000 characters.' =>
            'Dit veld is vereist en mag maximaal 4000 tekens bevatten.',
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
        'Attributes of the ticket data' => 'Eigenschappen van de ticket gegevens',
        'Ticket dynamic fields internal key values' => 'Ticket dynamisch veld voor interne sleutelwaarden',
        'Ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            'Ticket dynamisch veld weergave waarden, handig voor dropdown en multiselect velden',

        # Template: AdminNotificationEventTransportEmailSettings
        'Use comma or semicolon to separate email addresses.' => '',
        'You can use OTRS-tags like <OTRS_TICKET_DynamicField_...> to insert values from the current ticket.' =>
            '',

        # Template: AdminOTRSBusinessInstalled
        'Manage %s' => 'Beheer %s',
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
        'An update for your %s is available! Please update at your earliest!' =>
            'Er is een update voor %s beschikbaar! Update zo snel mogelijk!',
        '%s Correctly Deployed' => '%s is succesvol geïnstalleerd',
        'Congratulations, your %s is correctly installed and up to date!' =>
            'Gefeliciteerd, jouw %s is correct geïnstalleerd en bijgewerkt.',

        # Template: AdminOTRSBusinessNotInstalled
        'Go to the OTRS customer portal' => 'Ga naar het OTRS klantenportaal',
        '%s will be available soon. Please check again in a few days.' =>
            '%s komt binnenkort beschikbaar. Kijk over een paar dagen weer.',
        'Please have a look at %s for more information.' => 'Kijk naar %s voor meer informatie.',
        'Your ((OTRS)) Community Edition is the base for all future actions. Please register first before you continue with the upgrade process of %s!' =>
            '',
        'Before you can benefit from %s, please contact %s to get your %s contract.' =>
            'Voordat je de voordelen van %s kunt gebruiken, neem contact op met %s om je %s contract te ontvangen.',
        'Connection to cloud.otrs.com via HTTPS couldn\'t be established. Please make sure that your OTRS can connect to cloud.otrs.com via port 443.' =>
            'Er kon geen verbinding worden gemaakt met cloud.otrs.com via HTTPS. Controleer of jouw OTRS met cloud.otrs.com kan verbinden via poort 443.',
        'Package installation requires patch level update of OTRS.' => '',
        'Please visit our customer portal and file a request.' => '',
        'Everything else will be done as part of your contract.' => '',
        'Your installed OTRS version is %s.' => 'Jouw geÏnstalleerde OTRS-versie is %s.',
        'To install this package, you need to update to OTRS %s or higher.' =>
            '',
        'To install this package, the Maximum OTRS Version is %s.' => '',
        'To install this package, the required Framework version is %s.' =>
            '',
        'Why should I keep OTRS up to date?' => '',
        'You will receive updates about relevant security issues.' => '',
        'You will receive updates for all other relevant OTRS issues' => '',
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
        'Add PGP Key' => 'PGP sleutel toevoegen',
        'PGP support is disabled' => '',
        'To be able to use PGP in OTRS, you have to enable it first.' => '',
        'Enable PGP support' => '',
        'Faulty PGP configuration' => '',
        'PGP support is enabled, but the relevant configuration contains errors. Please check the configuration using the button below.' =>
            '',
        'Configure it here!' => 'Configureer het hier!',
        'Check PGP configuration' => '',
        'In this way you can directly edit the keyring configured in SysConfig.' =>
            'Hier kunt u de keyring beheren die is ingesteld in de systeemconfiguratie.',
        'Introduction to PGP' => 'Introductie tot PGP',
        'Identifier' => 'Identifier',
        'Bit' => 'Bit',
        'Fingerprint' => 'Fingerprint',
        'Expires' => 'Verloopt',
        'Delete this key' => 'Verwijder deze sleutel',
        'PGP key' => 'PGP sleutel',

        # Template: AdminPackageManager
        'Package Manager' => 'Pakketbeheer',
        'Uninstall Package' => 'Verwijder pakket',
        'Uninstall package' => 'Verwijder pakket',
        'Do you really want to uninstall this package?' => 'Wilt u dit pakket echt verwijderen?',
        'Reinstall package' => 'Herinstalleer pakket',
        'Do you really want to reinstall this package? Any manual changes will be lost.' =>
            'Wilt u dit pakket echt herinstalleren? Eventuele handmatige aanpassingen gaan verloren.',
        'Go to updating instructions' => 'Ga naar update instructies',
        'package information' => 'pakketinformatie',
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
        'Install Package' => 'Installeer pakket',
        'Update Package' => 'Update pakket',
        'Continue' => 'Doorgaan',
        'Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            'Zorg dat uw database pakketten van groter dan %s MB accepteert. Op dit moment is de maximale grootte %s MB. Pas de waarde voor max_allowed_packet in het mysql configuratiebestand aan om problemen te voorkomen.',
        'Install' => 'Installeer',
        'Update repository information' => 'Vernieuw repository gegevens',
        'Cloud services are currently disabled.' => 'Cloud services zijn op dit moment uitgeschakeld.',
        'OTRS Verify™ can not continue!' => 'OTRS Verify™ kan niet  verder gaan!',
        'Enable cloud services' => 'Schakel cloud diensten in',
        'Update all installed packages' => '',
        'Online Repository' => 'Online Repository',
        'Action' => 'Actie',
        'Module documentation' => 'Moduledocumentatie',
        'Local Repository' => 'Lokale Repository',
        'This package is verified by OTRSverify (tm)' => 'Dit pakket is geverifieerd door OTRSverify (tm)',
        'Uninstall' => 'Verwijder',
        'Package not correctly deployed! Please reinstall the package.' =>
            'Pakket onjuist geïnstalleerd. Installeer het pakket opnieuw.',
        'Reinstall' => 'Herinstalleer',
        'Features for %s customers only' => 'Functionaliteit voor alleen %s klanten',
        'With %s, you can benefit from the following optional features. Please make contact with %s if you need more information.' =>
            'Met %s kun je profiteren van de volgende optionele functionaliteit. Neem contact op met %s voor meer informatie.',
        'Package Information' => 'Pakketinformatie',
        'Download package' => 'Download pakket',
        'Rebuild package' => 'Genereer pakket opnieuw',
        'Metadata' => 'Metadata',
        'Change Log' => 'Wijzigingen',
        'Date' => 'Datum',
        'List of Files' => 'Overzicht van bestanden',
        'Permission' => 'Permissie',
        'Download file from package!' => 'Download bestand van pakket.',
        'Required' => 'Verplicht',
        'Size' => 'Grootte',
        'Primary Key' => 'Primaire Sleutel',
        'Auto Increment' => 'Automatisch ophogen',
        'SQL' => 'SQL statement',
        'File Differences for File %s' => '',
        'File differences for file %s' => 'Verschillen in bestand %s',

        # Template: AdminPerformanceLog
        'Performance Log' => 'Performance log',
        'Range' => 'Bereik',
        'last' => 'laatste',
        'This feature is enabled!' => 'Deze functie is ingeschakeld.',
        'Just use this feature if you want to log each request.' => 'Activeer de Performance Log alleen als u ieder verzoek wilt loggen.',
        'Activating this feature might affect your system performance!' =>
            'Deze functie gaat zelf ook een beetje ten koste van de performance.',
        'Disable it here!' => 'Uitschakelen',
        'Logfile too large!' => 'Logbestand te groot.',
        'The logfile is too large, you need to reset it' => 'Het logbestand is te groot, u moet het resetten',
        'Reset' => 'Opnieuw',
        'Overview' => 'Overzicht',
        'Interface' => 'Interface',
        'Requests' => 'Verzoeken',
        'Min Response' => 'Minimaal',
        'Max Response' => 'Maximaal',
        'Average Response' => 'Gemiddelde',
        'Period' => 'Looptijd',
        'minutes' => 'minuten',
        'Min' => 'Min',
        'Max' => 'Max',
        'Average' => 'Gemiddeld',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => 'E-mail filterbeheer',
        'Add PostMaster Filter' => 'Nieuw e-mail filter',
        'Edit PostMaster Filter' => 'Bewerk e-mail filter',
        'Filter for PostMaster Filters' => '',
        'Filter for PostMaster filters' => '',
        'To dispatch or filter incoming emails based on email headers. Matching using Regular Expressions is also possible.' =>
            'Om inkomende e-mails te routeren op basis van e-mail headers. Matching op tekst of met behulp van regular expressions.',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' =>
            'Als u alleen wilt filteren op het e-mailadres, gebruik dan EMAILADDRESS:info@example.local in Van, Aan of CC.',
        'If you use Regular Expressions, you also can use the matched value in () as [***] in the \'Set\' action.' =>
            'Als u regular expressions gebruikt dan kunt u ook de gevonden waarde tussen haakjes () gebruiken als [***] in de \'Set\' actie.',
        'You can also use named captures %s and use the names in the \'Set\' action %s (e.g. Regexp: %s, Set action: %s). A matched EMAILADDRESS has the name \'%s\'.' =>
            '',
        'Delete this filter' => 'Verwijder filter',
        'Do you really want to delete this postmaster filter?' => '',
        'A postmaster filter with this name already exists!' => '',
        'Filter Condition' => 'Filter conditie',
        'AND Condition' => 'EN conditie',
        'Search header field' => '',
        'for value' => '',
        'The field needs to be a valid regular expression or a literal word.' =>
            'Dit veld kan een woord bevatten of een regular expression.',
        'Negate' => 'Omdraaien (negate)',
        'Set Email Headers' => 'Nieuwe waarden',
        'Set email header' => 'Stel email kop in',
        'with value' => '',
        'The field needs to be a literal word.' => 'Dit veld moet een letterlijke waarde bevatten.',
        'Header' => 'Type',

        # Template: AdminPriority
        'Priority Management' => 'Prioriteitenbeheer',
        'Add Priority' => 'Nieuwe prioriteit',
        'Edit Priority' => 'Bewerk prioriteit',
        'Filter for Priorities' => 'Filter voor Prioriteiten',
        'Filter for priorities' => 'Filter voor prioriteiten',
        'This priority is present in a SysConfig setting, confirmation for updating settings to point to the new priority is needed!' =>
            '',
        'This priority is used in the following config settings:' => 'Deze prioriteit wordt gebruikt in de volgende configuratieinstellingen:',

        # Template: AdminProcessManagement
        'Process Management' => 'Procesbeheer',
        'Filter for Processes' => 'Filter op processen',
        'Filter for processes' => 'Filter voor processen',
        'Create New Process' => 'Nieuw proces',
        'Deploy All Processes' => 'Deploy alle processen',
        'Here you can upload a configuration file to import a process to your system. The file needs to be in .yml format as exported by process management module.' =>
            'Hier kunt u een proces importeren vanuit een configuratiebestand. Het bestand moet in .yml formaat zijn, zoals geëxporteerd door de procesbeheer-module.',
        'Upload process configuration' => 'Upload procesconfiguratie',
        'Import process configuration' => 'Importeer procesconfiguratie',
        'Ready2Adopt Processes' => 'Ready2Adopt processen',
        'Here you can activate Ready2Adopt processes showcasing our best practices. Please note that some additional configuration may be required.' =>
            '',
        'Would you like to benefit from processes created by experts? Upgrade to %s to import some sophisticated Ready2Adopt processes.' =>
            '',
        'Import Ready2Adopt process' => 'Importeer Ready2Adopt proces',
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
        'You can assign Fields to this Activity Dialog by dragging the elements with the mouse from the left list to the right list.' =>
            'U kunt velden aan deze dialoog toevoegen door de elementen met de muis van links naar rechts te slepen.',
        'Filter available fields' => 'Filter beschikbare velden',
        'Available Fields' => 'Beschikbare velden',
        'Assigned Fields' => 'Toegewezen velden',
        'Communication Channel' => 'Communicatiekanaal',
        'Is visible for customer' => 'Is zichtbaar voor de klant',
        'Display' => 'Weergave',

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

        # Template: AdminProcessManagementProcessNew
        'In this screen, you can create a new process. In order to make the new process available to users, please make sure to set its state to \'Active\' and synchronize after completing your work.' =>
            'In dit scherm kunt u een nieuw proces aanmaken. Om het nieuwe proces beschikbaar te maken voor uw gebruikers moet u de status op \'Actief\' zetten en vervolgens een synchronisatie uitvoeren.',

        # Template: AdminProcessManagementProcessPrint
        'cancel & close' => 'Annuleren & sluiten',
        'Start Activity' => 'Start activiteit',
        'Contains %s dialog(s)' => 'Bevat %s dialoog(en)',
        'Assigned dialogs' => 'Toegewezen dialogen',
        'Activities are not being used in this process.' => 'Er zijn geen activiteiten in dit proces.',
        'Assigned fields' => 'Toegewezen velden',
        'Activity dialogs are not being used in this process.' => 'Er zijn geen dialogen in dit proces.',
        'Condition linking' => 'Condities koppelen',
        'Transitions are not being used in this process.' => 'Er zijn geen overgangen in dit proces.',
        'Module name' => 'Modulenaam',
        'Transition actions are not being used in this process.' => 'Er zijn geen transitie-acties in dit proces.',

        # Template: AdminProcessManagementTransition
        'Please note that changing this transition will affect the following processes' =>
            'Let op: het wijzigen van deze transitie heeft invloed op de volgende processen',
        'Transition' => 'Transitie',
        'Transition Name' => 'Naam',

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
        'Queue Management' => 'Wachtrij Beheer',
        'Add Queue' => 'Nieuwe wachtrij',
        'Edit Queue' => 'Bewerk wachtrij',
        'Filter for Queues' => 'Filter op wachtrijen',
        'Filter for queues' => 'Filter op wachtrijen',
        'A queue with this name already exists!' => 'Er bestaat al een wachtrij met deze naam',
        'This queue is present in a SysConfig setting, confirmation for updating settings to point to the new queue is needed!' =>
            'Deze wachtrij is beschikbaar in een SysConfig instelling, bevestiging voor het updaten van instellingen naar de nieuwe wachtrij is nodig!',
        'Sub-queue of' => 'Onderdeel van',
        'Unlock timeout' => 'Ontgrendel tijdsoverschrijding',
        '0 = no unlock' => '0 = geen ontgrendeling',
        'hours' => 'uren',
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
        'Salutation' => 'Aanhef',
        'The salutation for email answers.' => 'De aanhef voor beantwoording van berichten per e-mail.',
        'Signature' => 'Handtekening',
        'The signature for email answers.' => 'De ondertekening voor beantwoording van berichten per e-mail.',
        'This queue is used in the following config settings:' => 'Deze wachtrij wordt gebruikt in de volgende configuratieinstellingen:',

        # Template: AdminQueueAutoResponse
        'Manage Queue-Auto Response Relations' => 'Beheer Wachtrij - Automatische antwoorden koppelingen',
        'Change Auto Response Relations for Queue' => 'Bewerk automatische antwoorden voor wachtrij',
        'This filter allow you to show queues without auto responses' => 'Dit filter staat je toe om wachtrijen te zien die geen automatisch antwoord hebben.',
        'Queues without Auto Responses' => 'Wachtrijen zonder automatisch antwoord',
        'This filter allow you to show all queues' => 'Dit filter staat je toe om alle wachtrijen weer te geven',
        'Show All Queues' => 'Toon alle wachtrijen',
        'Auto Responses' => 'Automatische antwoorden',

        # Template: AdminQueueTemplates
        'Manage Template-Queue Relations' => 'Beheer Sjabloon - Wachtrij koppelingen',
        'Filter for Templates' => 'Filter op sjablonen',
        'Filter for templates' => 'Filter op sjablonen',
        'Templates' => 'Sjablonen',

        # Template: AdminRegistration
        'System Registration Management' => 'Beheer systeemregistratie',
        'Edit System Registration' => 'Bewerk Systeemregistratie',
        'System Registration Overview' => '',
        'Register System' => 'Registreer Systeem',
        'Validate OTRS-ID' => 'Valideer OTRS-ID',
        'Deregister System' => 'Deregistreer systeem',
        'Edit details' => 'Bewerk gegevens',
        'Show transmitted data' => 'Toon verstuurde gegevens',
        'Deregister system' => 'Deregistreer systeem',
        'Overview of registered systems' => 'Overzicht van geregistreerde systemen',
        'This system is registered with OTRS Group.' => 'Dit systeem is geregistreerd bij de OTRS Groep.',
        'System type' => 'Systeemtype',
        'Unique ID' => 'Uniek ID',
        'Last communication with registration server' => 'Laatste communicatie met registratieserver',
        'System Registration not Possible' => 'Systeemregistratie niet mogelijk',
        'Please note that you can\'t register your system if OTRS Daemon is not running correctly!' =>
            'Het is niet mogelijk om je systeem te registreren als OTRS Daemon niet correct is opgestart!',
        'Instructions' => 'Instructies',
        'System Deregistration not Possible' => 'Systeemuitschrijving niet mogelijk',
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
        'If you deregister your system, you will lose these benefits:' =>
            'Als je je systeem deregistreert, verlies je de volgende voordelen:',
        'You need to log in with your OTRS-ID to deregister your system.' =>
            'U moet inloggen met uw OTRS-ID om uw systeem te deregistreren.',
        'OTRS-ID' => 'OTRS-ID',
        'You don\'t have an OTRS-ID yet?' => 'Heeft u nog geen OTRS-ID?',
        'Sign up now' => 'Gebruikersnaam registreren',
        'Forgot your password?' => 'Wachtwoord vergeten?',
        'Retrieve a new one' => 'Wachtwoord herstellen',
        'Next' => 'Volgende',
        'This data will be frequently transferred to OTRS Group when you register this system.' =>
            'Deze gegevens worden op regelmatige basis verstuurd naar de OTRS Groep als u dit systeem registreert.',
        'Attribute' => 'Attribuut',
        'FQDN' => 'FQDN',
        'OTRS Version' => 'OTRS-versie',
        'Operating System' => 'Besturingssysteem',
        'Perl Version' => 'Perl-versie',
        'Optional description of this system.' => 'Optionele omschrijving van dit systeem.',
        'Register' => 'Registreer',
        'Continuing with this step will deregister the system from OTRS Group.' =>
            'Doorgaan met deze stap zal uw systeem deregistreren bij de OTRS Groep.',
        'Deregister' => 'Deregistreer',
        'You can modify registration settings here.' => 'Je kunt je registratie instellingen hier aanpassen',
        'Overview of Transmitted Data' => 'Overzicht van verstuurde gegevens',
        'There is no data regularly sent from your system to %s.' => 'Er zijn geen gegevens die regelmatig worden verzonden van jouw systeem naar %s',
        'The following data is sent at minimum every 3 days from your system to %s.' =>
            'De volgende gegevens over jouw systeem worden maximaal elke 3 dagen verzonden naar %s',
        'The data will be transferred in JSON format via a secure https connection.' =>
            'De gegevens worden verstuurd in JSON format via een beveiligde https verbinding',
        'System Registration Data' => 'Systeemregistratie gegevens',
        'Support Data' => 'Ondersteuningsgegevens',

        # Template: AdminRole
        'Role Management' => 'Beheer rollen',
        'Add Role' => 'Nieuwe rol',
        'Edit Role' => 'Bewerk rol',
        'Filter for Roles' => 'Filter op rollen',
        'Filter for roles' => '',
        'Create a role and put groups in it. Then add the role to the users.' =>
            'Maak een nieuwe rol en koppel deze aan groepen. Vervolgens kunt u rollen toewijzen aan gebruikers.',
        'There are no roles defined. Please use the \'Add\' button to create a new role.' =>
            'Er zijn geen rollen gedefiniëerd. Maak een nieuwe aan.',

        # Template: AdminRoleGroup
        'Manage Role-Group Relations' => 'Beheer Rol-Groep koppelingen',
        'Roles' => 'Rollen',
        'Select the role:group permissions.' => 'Selecteer de rol-groep permissies.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the role).' =>
            'Als niets is geselecteerd, heeft deze rol geen permissies op deze groep.',
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
        'Add Agent' => 'Nieuwe behandelaar',
        'Filter for Agents' => 'Filter op behandelaars',
        'Filter for agents' => 'Filter op behandelaars',
        'Agents' => 'Behandelaars',
        'Manage Role-Agent Relations' => 'Beheer Rol-Behandelaar koppelingen',

        # Template: AdminSLA
        'SLA Management' => 'SLA beheer',
        'Edit SLA' => 'Bewerk SLA',
        'Add SLA' => 'Nieuwe SLA',
        'Filter for SLAs' => '',
        'Please write only numbers!' => 'Gebruik alleen cijfers.',

        # Template: AdminSMIME
        'S/MIME Management' => 'S/MIME beheer',
        'Add Certificate' => 'Nieuw certificaat',
        'Add Private Key' => 'Nieuwe private sleutel',
        'SMIME support is disabled' => '',
        'To be able to use SMIME in OTRS, you have to enable it first.' =>
            '',
        'Enable SMIME support' => '',
        'Faulty SMIME configuration' => 'Onjuiste SMIME configuratie',
        'SMIME support is enabled, but the relevant configuration contains errors. Please check the configuration using the button below.' =>
            '',
        'Check SMIME configuration' => 'Controleer SMIME configuratie',
        'Filter for Certificates' => '',
        'Filter for certificates' => 'Filter op certificaten',
        'To show certificate details click on a certificate icon.' => 'Klik op een certificaat icoon om de details van een certificaat weer te geven.',
        'To manage private certificate relations click on a private key icon.' =>
            'Om je privé certificaat relaties te beheren, klik je op een privé sleutel icoon.',
        'Here you can add relations to your private certificate, these will be embedded to the S/MIME signature every time you use this certificate to sign an email.' =>
            'Hier kun je relaties toevoegen aan je prive certificaten, deze worden in de S/MIME ondertekening meegezonden wanneer je dit certificaat gebruikt om e-mail te ondertekenen.',
        'See also' => 'Zie voor meer informatie',
        'In this way you can directly edit the certification and private keys in file system.' =>
            'Hier kunt u de certificaten en private sleutels van OTRS beheren.',
        'Hash' => 'Hash',
        'Create' => 'Aanmaken',
        'Handle related certificates' => 'Beheer gekoppelde certificaten',
        'Read certificate' => 'Lees certificaat',
        'Delete this certificate' => 'Verwijder certificaat',
        'File' => 'Bestand',
        'Secret' => 'Geheim',
        'Related Certificates for' => 'Gekoppelde certificaten voor',
        'Delete this relation' => 'Verwijder deze koppeling',
        'Available Certificates' => 'Beschikbare certificaten',
        'Filter for S/MIME certs' => 'Filter voor S/MIME certificaten',
        'Relate this certificate' => 'Koppel dit certificaat',

        # Template: AdminSMIMECertRead
        'S/MIME Certificate' => 'S/MIME Certificaat',
        'Close this dialog' => 'Sluit venster',
        'Certificate Details' => 'Certificaat details',

        # Template: AdminSalutation
        'Salutation Management' => 'Beheer aanheffen',
        'Add Salutation' => 'Nieuwe aanhef',
        'Edit Salutation' => 'Bewerk aanhef',
        'Filter for Salutations' => '',
        'Filter for salutations' => '',
        'e. g.' => 'bijv.',
        'Example salutation' => 'Aanhef voorbeeld',

        # Template: AdminSecureMode
        'Secure Mode Needs to be Enabled!' => '',
        'Secure mode will (normally) be set after the initial installation is completed.' =>
            'Secure Mode wordt normaal gesproken geactiveerd na afronding van de installatie.',
        'If secure mode is not activated, activate it via SysConfig because your application is already running.' =>
            'Als Secure Mode nog niet actief is activeer dit via de Systeemconfiguratie omdat de applicatie al draait.',

        # Template: AdminSelectBox
        'SQL Box' => 'SQL console',
        'Filter for Results' => '',
        'Filter for results' => '',
        'Here you can enter SQL to send it directly to the application database. It is not possible to change the content of the tables, only select queries are allowed.' =>
            'Hier kun je SQL invoeren om direct naar de database te versturen. Het is niet mogelijk om de inhoud van de tabellen aan te passen, alleen select queries zijn toegestaan.',
        'Here you can enter SQL to send it directly to the application database.' =>
            'Hier kunt u SQL statements invoeren die direct door de database worden uitgevoerd.',
        'Options' => 'Opties',
        'Only select queries are allowed.' => 'Alleen select queries zijn toegestaan.',
        'The syntax of your SQL query has a mistake. Please check it.' =>
            'De syntax van uw SQL query bevat een fout.',
        'There is at least one parameter missing for the binding. Please check it.' =>
            'Er mist tenminste een parameter.',
        'Result format' => 'Uitvoeren naar',
        'Run Query' => 'Uitvoeren',
        '%s Results' => '',
        'Query is executed.' => 'Query is uitgevoerd.',

        # Template: AdminService
        'Service Management' => 'Service beheer',
        'Add Service' => 'Nieuwe service',
        'Edit Service' => 'Bewerk Service',
        'Service name maximum length is 200 characters (with Sub-service).' =>
            '',
        'Sub-service of' => 'Onderdeel van',

        # Template: AdminSession
        'Session Management' => 'Sessies',
        'Detail Session View for %s (%s)' => '',
        'All sessions' => 'Alle sessies',
        'Agent sessions' => 'Behandelaar-sessies',
        'Customer sessions' => 'Klant-sessies',
        'Unique agents' => 'Unieke behandelaars',
        'Unique customers' => 'Unieke klanten',
        'Kill all sessions' => 'Alle sessies verwijderen',
        'Kill this session' => 'Verwijder deze sessie',
        'Filter for Sessions' => '',
        'Filter for sessions' => '',
        'Session' => 'Sessie',
        'User' => 'Gebruiker',
        'Kill' => 'Verwijder',
        'Detail View for SessionID: %s - %s' => '',

        # Template: AdminSignature
        'Signature Management' => 'Handtekening-beheer',
        'Add Signature' => 'Nieuwe handtekening',
        'Edit Signature' => 'Bewerk handtekening',
        'Filter for Signatures' => '',
        'Filter for signatures' => '',
        'Example signature' => 'Handtekening-voorbeeld',

        # Template: AdminState
        'State Management' => 'Status beheer',
        'Add State' => 'Nieuwe status',
        'Edit State' => 'Bewerk status',
        'Filter for States' => '',
        'Filter for states' => '',
        'Attention' => 'Let op',
        'Please also update the states in SysConfig where needed.' => 'Pas ook de namen van de status aan in SysConfig waar nodig.',
        'This state is present in a SysConfig setting, confirmation for updating settings to point to the new type is needed!' =>
            '',
        'State type' => 'Status type',
        'It\'s not possible to invalidate this entry because there is no other merge states in system!' =>
            '',
        'This state is used in the following config settings:' => 'Deze status wordt gebruikt in de volgende configuratieinstellingen:',

        # Template: AdminSupportDataCollector
        'Sending support data to OTRS Group is not possible!' => 'Het versturen van support gegevens naar OTRS Group is niet mogelijk!',
        'Enable Cloud Services' => 'Schakel Cloud Diensten in',
        'This data is sent to OTRS Group on a regular basis. To stop sending this data please update your system registration.' =>
            'Deze gegevens worden regelmatig verstuurd naar OTRS Group. Om te stoppen met het versturen van deze gegevens moet je je systeem registatie aanpassen.',
        'You can manually trigger the Support Data sending by pressing this button:' =>
            'Je kunt handmatig de Support Data versturen door op deze knop te sturen:',
        'Send Update' => 'Verstuur Update',
        'Currently this data is only shown in this system.' => 'Op dit moment worden deze gegevens alleen in dit systeem weergegeven.',
        'A support bundle (including: system registration information, support data, a list of installed packages and all locally modified source code files) can be generated by pressing this button:' =>
            'Een support bundel kan gegenereerd worden door op deze knop te drukken (inclusief: systeem registratie informatie, ondersteuningsgegevens, een lijst met geïnstalleerde pakketen en alle lokaal aanepaste bronconde bestanden).',
        'Generate Support Bundle' => 'Genereer support bundel',
        'The Support Bundle has been Generated' => '',
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

        # Template: AdminSystemAddress
        'System Email Addresses Management' => 'Systeem e-mailadressen beheer',
        'Add System Email Address' => 'Nieuw e-mailadres',
        'Edit System Email Address' => 'Bewerk e-mailadres',
        'Add System Address' => 'Nieuw systeem adres',
        'Filter for System Addresses' => '',
        'Filter for system addresses' => '',
        'All incoming email with this address in To or Cc will be dispatched to the selected queue.' =>
            'Alle inkomende berichten met dit adres in Aan of CC worden toegewezen aan de geselecteerde wachtrij.',
        'Email address' => 'E-mailadres',
        'Display name' => 'Weergegeven naam',
        'This email address is already used as system email address.' => '',
        'The display name and email address will be shown on mail you send.' =>
            'De weergegeven naam en het e-mailadres worden gebruikt voor uitgaande mail.',
        'This system address cannot be set to invalid.' => '',
        'This system address cannot be set to invalid, because it is used in one or more queue(s) or auto response(s).' =>
            '',

        # Template: AdminSystemConfiguration
        'online administrator documentation' => 'online administrator documentatie',
        'System configuration' => 'Systeemconfiguratie',
        'Navigate through the available settings by using the tree in the navigation box on the left side.' =>
            '',
        'Find certain settings by using the search field below or from search icon from the top navigation.' =>
            '',
        'Find out how to use the system configuration by reading the %s.' =>
            '',
        'Search in all settings...' => 'Zoek in alle instellingen...',
        'There are currently no settings available. Please make sure to run \'otrs.Console.pl Maint::Config::Rebuild\' before using the software.' =>
            '',

        # Template: AdminSystemConfigurationDeployment
        'Changes Deployment' => '',
        'Help' => 'Help',
        'This is an overview of all settings which will be part of the deployment if you start it now. You can compare each setting to its former state by clicking the icon on the top right.' =>
            '',
        'To exclude certain settings from a deployment, click the checkbox on the header bar of a setting.' =>
            '',
        'By default, you will only deploy settings which you changed on your own. If you\'d like to deploy settings changed by other users, too, please click the link on top of the screen to enter the advanced deployment mode.' =>
            '',
        'A deployment has just been restored, which means that all affected setting have been reverted to the state from the selected deployment.' =>
            '',
        'Please review the changed settings and deploy afterwards.' => '',
        'An empty list of changes means that there are no differences between the restored and the current state of the affected settings.' =>
            '',
        'Changes Overview' => 'Gemaakte Wijzigingen',
        'There are %s changed settings which will be deployed in this run.' =>
            '',
        'Switch to basic mode to deploy settings only changed by you.' =>
            '',
        'You have %s changed settings which will be deployed in this run.' =>
            '',
        'Switch to advanced mode to deploy settings changed by other users, too.' =>
            '',
        'There are no settings to be deployed.' => '',
        'Switch to advanced mode to see deployable settings changed by other users.' =>
            '',
        'Deploy selected changes' => 'Geselecteerde wijzigingen uitrollen',

        # Template: AdminSystemConfigurationGroup
        'This group doesn\'t contain any settings. Please try navigating to one of its sub groups.' =>
            '',

        # Template: AdminSystemConfigurationImportExport
        'Import & Export' => 'Importeren & Exporteren',
        'Upload a file to be imported to your system (.yml format as exported from the System Configuration module).' =>
            '',
        'Upload system configuration' => 'Upload systeemconfiguratie',
        'Import system configuration' => 'Importeer systeemconfiguratie',
        'Download current configuration settings of your system in a .yml file.' =>
            '',
        'Include user settings' => '',
        'Export current configuration' => '',

        # Template: AdminSystemConfigurationSearch
        'Search for' => 'Zoek naar',
        'Search for category' => '',
        'Settings I\'m currently editing' => 'Instellingen die ik momenteel bewerk',
        'Your search for "%s" in category "%s" did not return any results.' =>
            '',
        'Your search for "%s" in category "%s" returned one result.' => '',
        'Your search for "%s" in category "%s" returned %s results.' => '',
        'You\'re currently not editing any settings.' => 'U bewerkt momenteel geen instellingen.',
        'You\'re currently editing %s setting(s).' => '',

        # Template: AdminSystemConfigurationSearchDialog
        'Category' => 'Categorie',
        'Run search' => 'Voer zoekopdracht uit',

        # Template: AdminSystemConfigurationView
        'View a custom List of Settings' => '',
        'View single Setting: %s' => '',
        'Go back to Deployment Details' => '',

        # Template: AdminSystemMaintenance
        'System Maintenance Management' => 'Systeem onderhoudsbeheer.',
        'Schedule New System Maintenance' => 'Plan een nieuw systeem onderhoud.',
        'Filter for System Maintenances' => '',
        'Filter for system maintenances' => '',
        'Schedule a system maintenance period for announcing the Agents and Customers the system is down for a time period.' =>
            'Plan een systeem onderhoudsperiode om aan Agents en Klanten aan te kondigen dat het systeem voor een bepaalde periode down is.',
        'Some time before this system maintenance starts the users will receive a notification on each screen announcing about this fact.' =>
            'Een bepaalde tijd voordat het systeem onderhoud begint krijgen de gebruikers een melding op elk scherm waarin het onderhoud wordt aangekondigd.',
        'Stop date' => 'Einddatum',
        'Delete System Maintenance' => 'Verwijder Systeemonderhoudstijdsvak.',

        # Template: AdminSystemMaintenanceEdit
        'Edit System Maintenance' => '',
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
        'Template Management' => '',
        'Add Template' => 'Nieuw sjabloon',
        'Edit Template' => 'Bewerk sjabloon',
        'A template is a default text which helps your agents to write faster tickets, answers or forwards.' =>
            'Een sjabloon is een standaardtext die uw behandelaars helpt sneller tickets aan te maken of te beantwoorden.',
        'Don\'t forget to add new templates to queues.' => 'Vergeet niet de sjablonen aan wachtrijen te koppelen.',
        'Attachments' => 'Bijlagen',
        'Delete this entry' => 'Verwijder antwoord',
        'Do you really want to delete this template?' => 'Wilt u deze template echt verwijderen?',
        'A standard template with this name already exists!' => 'Er bestaat al een standaard template met deze naam!',
        'Template' => 'Sjabloon',
        'To get the first 20 characters of the subject of the current/latest agent article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            '',
        'To get the first 5 lines of the body of the current/latest agent article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            '',
        'To get the first 20 characters of the subject of the current/latest article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            '',
        'To get the first 5 lines of the body of the current/latest article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            '',
        'Create type templates only supports this smart tags' => 'Sjablonen van het type \'Aanmaken\' ondersteunen alleen deze tags',
        'Example template' => 'Voorbeeld-sjabloon',
        'The current ticket state is' => 'De huidige ticketstatus is',
        'Your email address is' => 'Uw e-mailadres is',

        # Template: AdminTemplateAttachment
        'Manage Template-Attachment Relations' => '',
        'Toggle active for all' => 'Actief aan/uit voor alles',
        'Link %s to selected %s' => 'Koppel %s aan %s',

        # Template: AdminType
        'Type Management' => 'Type beheer',
        'Add Type' => 'Nieuw type',
        'Edit Type' => 'Bewerk type',
        'Filter for Types' => 'Filter voor Types',
        'Filter for types' => 'Filter voor types',
        'A type with this name already exists!' => 'Er bestaat al een type met deze naam!',
        'This type is present in a SysConfig setting, confirmation for updating settings to point to the new type is needed!' =>
            '',
        'This type is used in the following config settings:' => '',

        # Template: AdminUser
        'Agent Management' => 'Beheer behandelaars',
        'Edit Agent' => 'Bewerk behandelaar',
        'Edit personal preferences for this agent' => 'Persoonlijke instellingen voor deze behandelaar bewerken',
        'Agents will be needed to handle tickets.' => 'Behandelaar-accounts zijn nodig om te kunnen werken in het systeem.',
        'Don\'t forget to add a new agent to groups and/or roles!' => 'vergeet niet om een behandelaar aan groepen en/of rollen te koppelen.',
        'Please enter a search term to look for agents.' => 'Typ om te zoeken naar behandelaars.',
        'Last login' => 'Laatst ingelogd',
        'Switch to agent' => 'Omschakelen naar behandelaar',
        'Title or salutation' => 'Titel of Aanhef',
        'Firstname' => 'Voornaam',
        'Lastname' => 'Achternaam',
        'A user with this username already exists!' => 'Er bestaat al een gebruiker met deze naam!',
        'Will be auto-generated if left empty.' => 'Zal automatisch worden gegenereerd indien leeg.',
        'Mobile' => 'Mobiel',
        'Effective Permissions for Agent' => '',
        'This agent has no group permissions.' => 'Deze behandelaar heeft geen groepsrechten',
        'Table above shows effective group permissions for the agent. The matrix takes into account all inherited permissions (e.g. via roles).' =>
            '',

        # Template: AdminUserGroup
        'Manage Agent-Group Relations' => 'Beheer Behandelaar-Groep koppelingen',

        # Template: AgentAppointmentAgendaOverview
        'Agenda Overview' => '',
        'Manage Calendars' => 'Kalenders beheren',
        'Add Appointment' => 'Nieuwe Afspraak',
        'Today' => 'Vandaag',
        'All-day' => 'de gehele dag',
        'Repeat' => 'Herhaal',
        'Notification' => 'Melding',
        'Yes' => 'Ja',
        'No' => 'Nee',
        'No calendars found. Please add a calendar first by using Manage Calendars page.' =>
            '',

        # Template: AgentAppointmentCalendarOverview
        'Add new Appointment' => 'Nieuwe afspraak toevoegen',
        'Calendars' => 'Kalenders',

        # Template: AgentAppointmentEdit
        'Basic information' => 'Basis informatie',
        'Date/Time' => 'Datum/Tijd',
        'Invalid date!' => 'Geen geldige datum.',
        'Please set this to value before End date.' => '',
        'Please set this to value after Start date.' => '',
        'This an occurrence of a repeating appointment.' => '',
        'Click here to see the parent appointment.' => '',
        'Click here to edit the parent appointment.' => '',
        'Frequency' => '',
        'Every' => 'Elke',
        'day(s)' => 'dag(en)',
        'week(s)' => 'weken',
        'month(s)' => 'maand(en)',
        'year(s)' => 'jaren',
        'On' => 'Aan',
        'Monday' => 'maandag',
        'Mon' => 'ma',
        'Tuesday' => 'dinsdag',
        'Tue' => 'di',
        'Wednesday' => 'woensdag',
        'Wed' => 'wo',
        'Thursday' => 'donderdag',
        'Thu' => 'do',
        'Friday' => 'vrijdag',
        'Fri' => 'vr',
        'Saturday' => 'zaterdag',
        'Sat' => 'za',
        'Sunday' => 'zondag',
        'Sun' => 'zo',
        'January' => 'januari',
        'Jan' => 'jan',
        'February' => 'februari',
        'Feb' => 'feb',
        'March' => 'maart',
        'Mar' => 'mrt',
        'April' => 'april',
        'Apr' => 'apr',
        'May_long' => 'mei',
        'May' => 'mei',
        'June' => 'juni',
        'Jun' => 'jun',
        'July' => 'juli',
        'Jul' => 'jul',
        'August' => 'augustus',
        'Aug' => 'aug',
        'September' => 'september',
        'Sep' => 'sep',
        'October' => 'oktober',
        'Oct' => 'okt',
        'November' => 'november',
        'Nov' => 'nov',
        'December' => 'december',
        'Dec' => 'dec',
        'Relative point of time' => '',
        'Link' => 'Koppel',
        'Remove entry' => 'Verwijder sleutel',

        # Template: AgentCustomerInformationCenter
        'Customer Information Center' => 'Klantinformatie overzicht',

        # Template: AgentCustomerInformationCenterSearch
        'Customer User' => 'Klant',

        # Template: AgentCustomerTableView
        'Note: Customer is invalid!' => 'Let op: klant is ongeldig!',
        'Start chat' => 'Start chat',
        'Video call' => '',
        'Audio call' => '',

        # Template: AgentCustomerUserAddressBook
        'Customer User Address Book' => 'Klantgebruiker adresboek',
        'Search for recipients and add the results as \'%s\'.' => '',
        'Search template' => 'Sjabloon',
        'Create Template' => 'Maak sjabloon',
        'Create New' => 'Nieuw',
        'Save changes in template' => 'Sla wijzigingen op in sjabloon',
        'Filters in use' => 'Filters in gebruik',
        'Additional filters' => 'Extra filters',
        'Add another attribute' => 'Voeg attribuut toe',
        'The attributes with the identifier \'(Customer)\' are from the customer company.' =>
            '',
        '(e. g. Term* or *Term*)' => '(bv. Term* of *Term*)',

        # Template: AgentCustomerUserAddressBookOverview
        'Select all' => 'Selecteer alles',
        'The customer user is already selected in the ticket mask.' => '',
        'Select this customer user' => 'Selecteer deze klantgebruiker',
        'Add selected customer user to' => 'Voeg geselecteerde klantgebruiker toe aan',

        # Template: AgentCustomerUserAddressBookOverviewNavBar
        'Change search options' => 'Verander zoekopties',

        # Template: AgentCustomerUserInformationCenter
        'Customer User Information Center' => 'Klant gebruiker informatie overzicht',

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

        # Template: AgentDashboardAppointmentCalendar
        'New Appointment' => 'Nieuwe Afspraak',
        'Tomorrow' => 'Morgen',
        'Soon' => 'Binnenkort',
        '5 days' => '5 dagen',
        'Start' => 'Begin',
        'none' => 'geen',

        # Template: AgentDashboardCalendarOverview
        'in' => 'over',

        # Template: AgentDashboardCommon
        'Save settings' => 'Instellingen opslaan',
        'Close this widget' => 'Sluit deze widget',
        'more' => 'meer',
        'Available Columns' => 'Beschikbare kolommen',
        'Visible Columns (order by drag & drop)' => 'Beschikbare kolommen (sorteer door middel van drag & drop)',

        # Template: AgentDashboardCustomerIDList
        'Change Customer Relations' => 'Bewerk klant koppelingen',
        'Open' => 'Open',
        'Closed' => 'Gesloten',
        '%s open ticket(s) of %s' => '%s open ticket(s) van %s',
        '%s closed ticket(s) of %s' => '%s gesloten ticket(s) van %s',
        'Edit customer ID' => 'Klantcode aanpassen',

        # Template: AgentDashboardCustomerIDStatus
        'Escalated tickets' => 'Geëscaleerde tickets',
        'Open tickets' => 'Open tickets',
        'Closed tickets' => 'Gesloten tickets',
        'All tickets' => 'Alle tickets',
        'Archived tickets' => 'Gearchiveerde tickets',

        # Template: AgentDashboardCustomerUserInformation
        'Note: Customer User is invalid!' => '',

        # Template: AgentDashboardCustomerUserList
        'Customer user information' => 'Klantgebruiker informatie',
        'Phone ticket' => 'Telefoon-ticket',
        'Email ticket' => 'E-mail-ticket',
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
        'Please select a valid graph output format in the configuration of this widget.' =>
            'Selecteer een geldige grafiek output format in de configuratie van deze widget.',
        'The content of this statistic is being prepared for you, please be patient.' =>
            'De inhoud van deze rapportage wordt voor u aangemaakt, even geduld.',
        'This statistic can currently not be used because its configuration needs to be corrected by the statistics administrator.' =>
            'Deze statistiek kan op dit moment niet worden gebruikt omdat de configuratie gecorrigeerd moet worden door de statistieken administrator. ',

        # Template: AgentDashboardTicketGeneric
        'Assigned to customer user' => '',
        'Accessible for customer user' => '',
        'My locked tickets' => 'Mijn vergrendelde tickets',
        'My watched tickets' => 'Mijn gevolgde tickets',
        'My responsibilities' => 'Tickets waarvoor ik verantwoordelijk ben',
        'Tickets in My Queues' => 'Tickets in mijn wachtrijen',
        'Tickets in My Services' => 'Tickets in mijn services',
        'Service Time' => 'Service tijd',

        # Template: AgentDashboardTicketQueueOverview
        'Total' => 'Totaal',

        # Template: AgentDashboardUserOnline
        'out of office' => 'afwezigheid',

        # Template: AgentDashboardUserOutOfOffice
        'until' => 'tot',

        # Template: AgentInfo
        'To accept some news, a license or some changes.' => 'Om een tekst te tonen, zoals nieuws of een licentie, die de agent moet accepteren.',
        'Yes, accepted.' => '',

        # Template: AgentLinkObject
        'Manage links for %s' => '',
        'Create new links' => '',
        'Manage existing links' => 'Bestaande koppelingen beheren',
        'Link with' => 'Koppel met',
        'Start search' => 'Begin met zoeken',
        'There are currently no links. Please click \'Create new Links\' on the top to link this item to other objects.' =>
            '',

        # Template: AgentOTRSBusinessBlockScreen
        'Unauthorized usage of %s detected' => '',
        'If you decide to downgrade to ((OTRS)) Community Edition, you will lose all database tables and data related to %s.' =>
            '',

        # Template: AgentPreferences
        'Edit your preferences' => 'Bewerk uw voorkeuren',
        'Personal Preferences' => 'Eigen voorkeuren',
        'Preferences' => 'Voorkeuren',
        'Please note: you\'re currently editing the preferences of %s.' =>
            '',
        'Go back to editing this agent' => '',
        'Set up your personal preferences. Save each setting by clicking the checkmark on the right.' =>
            'Hier stelt u uw eigen voorkeuren in. Bewaar uw wijzigingen door op het vinkje dat rechts staat te klikken',
        'You can use the navigation tree below to only show settings from certain groups.' =>
            '',
        'Dynamic Actions' => 'Dynamische Acties',
        'Filter settings...' => 'Filter instellingen...',
        'Filter for settings' => '',
        'Save all settings' => 'Alle instellingen opslaan',
        'Avatars have been disabled by the system administrator. You\'ll see your initials instead.' =>
            'Avatars zijn uitgeschakeld door de systeembeheerder. Uw initialen worden gebruikt.',
        'You can change your avatar image by registering with your email address %s at %s. Please note that it can take some time until your new avatar becomes available because of caching.' =>
            'U kunt uw eigen avatar afbeeling registreren door uw e-mail adres   %s op %s te gebruiken. Let op: het kan enige tijd duren voordat uw avatar beschikbaar is vanwege buffering.',
        'Off' => 'Uit',
        'End' => 'Einde',
        'This setting can currently not be saved.' => 'Deze instelling kan op dit moment niet worden opgeslagen.',
        'This setting can currently not be saved' => 'Deze instelling kan op dit moment niet worden opgeslagen',
        'Save this setting' => 'Sla deze instelling op',
        'Did you know? You can help translating OTRS at %s.' => 'Wist je dat je kunt helpen om OTRS te vertalen via %s?',

        # Template: SettingsList
        'Reset to default' => '',

        # Template: AgentPreferencesOverview
        'Choose from the groups on the right to find the settings you\'d wish to change.' =>
            '',
        'Did you know?' => 'Wist je dat?',
        'You can change your avatar by registering with your email address %s on %s' =>
            '',

        # Template: AgentSplitSelection
        'Target' => '',
        'Process' => 'Proces',
        'Split' => 'Splits',

        # Template: AgentStatisticsAdd
        'Statistics Management' => 'Statistiekbeheer',
        'Add Statistics' => 'Statistieken toevoegen',
        'Read more about statistics in OTRS' => 'Lees meer over statistieken in OTRS',
        'Dynamic Matrix' => 'Dynamische matrix',
        'Each cell contains a singular data point.' => '',
        'Dynamic List' => 'Dynamische lijst',
        'Each row contains data of one entity.' => '',
        'Static' => 'Statistiek',
        'Non-configurable complex statistics.' => '',
        'General Specification' => 'Algemene specificatie',
        'Create Statistic' => 'Maak statistiek',

        # Template: AgentStatisticsEdit
        'Edit Statistics' => 'Statistieken bewerken',
        'Run now' => 'Voer nu uit',
        'Statistics Preview' => 'Voorbeeld van rapportages',
        'Save Statistic' => 'Statistieken opslaan',

        # Template: AgentStatisticsImport
        'Import Statistics' => 'Statistieken importeren',
        'Import Statistics Configuration' => '',

        # Template: AgentStatisticsOverview
        'Statistics' => 'Statistiek',
        'Run' => 'Voer uit',
        'Edit statistic "%s".' => 'Bewerk rapportage "%s".',
        'Export statistic "%s"' => 'Exporteer rapportage "%s"',
        'Export statistic %s' => 'Exporteer Rapportage %s',
        'Delete statistic "%s"' => 'Verwijder rapportage "%s"',
        'Delete statistic %s' => 'Verwijder rapportage %s',

        # Template: AgentStatisticsView
        'Statistics Overview' => 'Statistieken overzicht',
        'View Statistics' => 'Statistieken bekijken',
        'Statistics Information' => '',
        'Created by' => 'Aangemaakt door',
        'Changed by' => 'Gewijzigd door',
        'Sum rows' => 'Toon totaal per rij',
        'Sum columns' => 'Toon totaal per kolom',
        'Show as dashboard widget' => 'Toon als dashboard-widget',
        'Cache' => 'Cache',
        'This statistic contains configuration errors and can currently not be used.' =>
            'Deze rapportage bevat configuratiefouten en kan niet worden gebruikt',

        # Template: AgentTicketActionCommon
        'Change Free Text of %s%s%s' => '',
        'Change Owner of %s%s%s' => 'Verander de eigenaar van %s %s %s',
        'Close %s%s%s' => 'Sluit %s%s%s',
        'Add Note to %s%s%s' => 'Voeg notitie aan %s%s%s',
        'Set Pending Time for %s%s%s' => '',
        'Change Priority of %s%s%s' => 'Wijzig de prioriteit van %s%s%s',
        'Change Responsible of %s%s%s' => 'Wijzig de verantwoordelijke van %s%s%s',
        'All fields marked with an asterisk (*) are mandatory.' => 'Alle velden met een asterisk (*) zijn verplicht.',
        'The ticket has been locked' => 'Het ticket is vergrendeld',
        'Undo & close' => 'Ongedaan maken & sluiten',
        'Ticket Settings' => 'Ticket instellingen',
        'Queue invalid.' => 'Wachtrij ongeldig',
        'Service invalid.' => 'Service is ongeldig.',
        'SLA invalid.' => 'SLA ongeldig',
        'New Owner' => 'Nieuwe eigenaar',
        'Please set a new owner!' => 'Kies een nieuwe eigenaar.',
        'Owner invalid.' => 'Eigenaar ongeldig',
        'New Responsible' => 'Nieuwe verantwoordelijke',
        'Please set a new responsible!' => 'Kies een nieuwe verantwoordelijke!',
        'Responsible invalid.' => 'Verantwoordelijke ongeldig',
        'Next state' => 'Status',
        'State invalid.' => 'Status ongeldig',
        'For all pending* states.' => 'Voor alle cases die staan te wachten',
        'Add Article' => 'Voeg Artikel toe',
        'Create an Article' => 'Maak een Artikel',
        'Inform agents' => 'Stel gebruikers op de hoogte',
        'Inform involved agents' => 'Stel betrokken gebruikers op de hoogte',
        'Here you can select additional agents which should receive a notification regarding the new article.' =>
            'Hier kun je extra gebruikers aanvinken die een notificatie zouden moeten krijgen over het nieuwe artikel.',
        'Text will also be received by' => '',
        'Text Template' => 'Tekstsjabloon',
        'Setting a template will overwrite any text or attachment.' => 'Het instellen van een template overschrijft alle testen en bijlagen.',
        'Invalid time!' => 'Geen geldige tijd.',

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
        'Merge' => 'Samenvoegen',
        'Merge to' => 'Voeg samen met',
        'Invalid ticket identifier!' => 'Ongeldige ticket identifier.',
        'Merge to oldest' => 'Voeg samen met oudste',
        'Link together' => 'Koppelen',
        'Link to parent' => 'Koppel aan vader',
        'Unlock tickets' => 'Ontgrendel tickets',
        'Execute Bulk Action' => 'Bulkactie uitvoeren',

        # Template: AgentTicketCompose
        'Compose Answer for %s%s%s' => '',
        'This address is registered as system address and cannot be used: %s' =>
            'Dit adres is geregistreerd als een systee adres en kan niet worden gebruikt.',
        'Please include at least one recipient' => 'Voeg tenminste één ontvanger toe',
        'Select one or more recipients from the customer user address book.' =>
            '',
        'Customer user address book' => 'Klantgebruiker adresboek',
        'Remove Ticket Customer' => 'Verwijder ',
        'Please remove this entry and enter a new one with the correct value.' =>
            'Verwijder deze en geef een nieuwe met een correcte waarde.',
        'This address already exists on the address list.' => 'Dit adres is al toegevoegd.',
        'Remove Cc' => 'Verwijder CC',
        'Bcc' => 'Bcc',
        'Remove Bcc' => 'Verwijder BCC',
        'Date Invalid!' => 'Datum ongeldig.',

        # Template: AgentTicketCustomer
        'Change Customer of %s%s%s' => 'Wijzig klant van %s%s%s',
        'Customer Information' => 'Klantinformatie',
        'Customer user' => 'Klant',

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

        # Template: AgentTicketEmailResend
        'Resend Email for %s%s%s' => '',

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
        'Filter for history items' => '',
        'Expand/collapse all' => '',
        'CreateTime' => 'Aangemaakt op',
        'Article' => 'Interactie',

        # Template: AgentTicketMerge
        'Merge %s%s%s' => 'Samenvoegen %s%s%s',
        'Merge Settings' => 'Samenvoegingsinstellingen',
        'You need to use a ticket number!' => 'Gebruik een ticketnummer.',
        'A valid ticket number is required.' => 'Een geldig ticketnummer is verplicht.',
        'Try typing part of the ticket number or title in order to search by it.' =>
            '',
        'Limit the search to tickets with same Customer ID (%s).' => 'Beperk de zoekopdracht tot tickets met dezelfde klantcode (%s).',
        'Inform Sender' => '',
        'Need a valid email address.' => 'Geen geldig e-mailadres.',

        # Template: AgentTicketMove
        'Move %s%s%s' => '',
        'New Queue' => 'Nieuwe wachtrij',
        'Move' => 'Verplaatsen',

        # Template: AgentTicketOverviewMedium
        'No ticket data found.' => 'Geen tickets gevonden.',
        'Open / Close ticket action menu' => 'Open / Sluit ticket actie menu',
        'Select this ticket' => 'Selecteer dit ticket',
        'Sender' => 'Afzender',
        'First Response Time' => 'Eerste reactie',
        'Update Time' => 'Vervolg tijd',
        'Solution Time' => 'Oplossingstijd',
        'Move ticket to a different queue' => 'Verplaats naar nieuwe wachtrij',
        'Change queue' => 'Verplaats naar wachtrij',

        # Template: AgentTicketOverviewNavBar
        'Remove active filters for this screen.' => 'Verwijder actieve filters voor dit scherm.',
        'Tickets per page' => 'Tickets per pagina',

        # Template: AgentTicketOverviewPreview
        'Missing channel' => 'Kanaal ontbreekt',

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

        # Template: AgentTicketProcessSmall
        'Enroll Ticket into a Process' => 'Voeg ticket toe aan een proces',

        # Template: AgentTicketSearch
        'Profile link' => 'Koppeling naar sjabloon',
        'Output' => 'Uitvoeren naar',
        'Fulltext' => 'Volledig',
        'Customer ID (complex search)' => 'Klantcode (complexe zoekopdracht)',
        '(e. g. 234*)' => '(bv. 234*)',
        'Customer ID (exact match)' => 'Klantcode (exacte overeenkomst)',
        'Assigned to Customer User Login (complex search)' => '',
        '(e. g. U51*)' => '(bv. U51*)',
        'Assigned to Customer User Login (exact match)' => '',
        'Accessible to Customer User Login (exact match)' => '',
        'Created in Queue' => 'Aangemaakt in wachtrij',
        'Lock state' => 'Vergrendeling',
        'Watcher' => 'Volger',
        'Article Create Time (before/after)' => 'Aanmaaktijd interactie (voor/na)',
        'Article Create Time (between)' => 'Aanmaaktijd interactie (tussen)',
        'Please set this to value before end date.' => '',
        'Please set this to value after start date.' => '',
        'Ticket Create Time (before/after)' => 'Aanmaaktijd ticket (voor/na)',
        'Ticket Create Time (between)' => 'Aanmaaktijd ticket (tussen)',
        'Ticket Change Time (before/after)' => 'Ticket gewijzigd (voor/na)',
        'Ticket Change Time (between)' => 'Ticket gewijzigd (tussen)',
        'Ticket Last Change Time (before/after)' => 'Meest recente ticket wijziging (voor/na)',
        'Ticket Last Change Time (between)' => 'Meest recente ticket wijziging (tussen)',
        'Ticket Pending Until Time (before/after)' => '',
        'Ticket Pending Until Time (between)' => '',
        'Ticket Close Time (before/after)' => 'Ticket gesloten (voor/na)',
        'Ticket Close Time (between)' => 'Ticket gesloten (tussen)',
        'Ticket Escalation Time (before/after)' => 'Ticket escalatietijd (voor/na)',
        'Ticket Escalation Time (between)' => 'Ticket escaltietijd (tussen)',
        'Archive Search' => 'Zoek in archief',

        # Template: AgentTicketZoom
        'Sender Type' => 'Soort verzender',
        'Save filter settings as default' => 'Sla filter op als standaard',
        'Event Type' => 'Gebeurtenis type',
        'Save as default' => 'Opslaan als standaard',
        'Drafts' => 'Concepten',
        'by' => 'door',
        'Change Queue' => 'Wijzig wachtrij',
        'There are no dialogs available at this point in the process.' =>
            'Op dit moment zijn er geen dialogen beschikbaar.',
        'This item has no articles yet.' => 'Dit item heeft nog geen interacties.',
        'Ticket Timeline View' => 'Ticket tijdslijn weergave',
        'Article Overview - %s Article(s)' => '',
        'Page %s' => '',
        'Add Filter' => 'Nieuw filter',
        'Set' => 'Nieuwe waarden',
        'Reset Filter' => 'Herstel filter',
        'No.' => 'Nr.',
        'Unread articles' => 'Ongelezen interacties',
        'Via' => 'Via',
        'Important' => 'Belangrijk',
        'Unread Article!' => 'Ongelezen interactie.',
        'Incoming message' => 'Binnenkomend bericht',
        'Outgoing message' => 'Uitgaand bericht',
        'Internal message' => 'Intern bericht',
        'Sending of this message has failed.' => 'Versturen van dit bericht is mislukt.',
        'Resize' => 'Grootte wijzigen',
        'Mark this article as read' => 'Markeer het artikel als gelezen',
        'Show Full Text' => 'Geef volledige tekst weer',
        'Full Article Text' => 'Volledige artikel tekst',
        'No more events found. Please try changing the filter settings.' =>
            'Geen events meer gevonden. Probeer de filter instellingen aan te passen.',

        # Template: Chat
        '#%s' => '#%s',
        'via %s' => 'via %s',
        'by %s' => 'door %s',
        'Toggle article details' => '',

        # Template: MIMEBase
        'This message is being processed. Already tried to send %s time(s). Next try will be %s.' =>
            '',
        'To open links in the following article, you might need to press Ctrl or Cmd or Shift key while clicking the link (depending on your browser and OS).' =>
            'Om links te openen in het volgende artikel, kan het nodig zijn om de toetsen Ctrl of Cmd of Shift in te druken terwijl je op de link klikt (afhankelijk van jouw browser en besturingssysteem)',
        'Close this message' => 'Sluit dit bericht',
        'Image' => 'Afbeelding',
        'PDF' => 'PDF',
        'Unknown' => 'Onbekend',
        'View' => 'Weergave',

        # Template: LinkTable
        'Linked Objects' => 'Gekoppelde objecten',

        # Template: TicketInformation
        'Archive' => 'Archief',
        'This ticket is archived.' => 'Dit ticket is gearchiveerd.',
        'Note: Type is invalid!' => 'Let op: Type is ongeldig!',
        'Pending till' => 'In de wacht tot',
        'Locked' => 'Vergrendeling',
        '%s Ticket(s)' => '%s Ticket(s)',
        'Accounted time' => 'Bestede tijd',

        # Template: Invalid
        'Preview of this article is not possible because %s channel is missing in the system.' =>
            '',
        'This feature is part of the %s. Please contact us at %s for an upgrade.' =>
            '',
        'Please re-install %s package in order to display this article.' =>
            '',

        # Template: AttachmentBlocker
        'To protect your privacy, remote content was blocked.' => 'Om uw privacy te beschermen is actieve inhoud geblokkeerd.',
        'Load blocked content.' => 'Laad actieve inhoud.',

        # Template: Breadcrumb
        'Home' => '',
        'Back to admin overview' => '',

        # Template: CloudServicesDisabled
        'This Feature Requires Cloud Services' => '',
        'You can' => 'U kunt',
        'go back to the previous page' => 'terug naar de vorige pagina',

        # Template: CustomerAccept
        'Dear Customer,' => '',
        'thank you for using our services.' => '',
        'Yes, I accept your license.' => 'Ja, ik accepteer de licentie.',

        # Template: TicketCustomerIDSelection
        'The customer ID is not changeable, no other customer ID can be assigned to this ticket.' =>
            '',
        'First select a customer user, then you can select a customer ID to assign to this ticket.' =>
            '',
        'Select a customer ID to assign to this ticket.' => '',
        'From all Customer IDs' => '',
        'From assigned Customer IDs' => '',

        # Template: CustomerError
        'An Error Occurred' => '',
        'Error Details' => 'Error gegevens',
        'Traceback' => 'Traceback',

        # Template: CustomerFooter
        '%s powered by %s™' => '',
        'Powered by %s™' => '',

        # Template: CustomerFooterJS
        '%s detected possible network issues. You could either try reloading this page manually or wait until your browser has re-established the connection on its own.' =>
            '',
        'The connection has been re-established after a temporary connection loss. Due to this, elements on this page could have stopped to work correctly. In order to be able to use all elements correctly again, it is strongly recommended to reload this page.' =>
            '',

        # Template: CustomerLogin
        'JavaScript Not Available' => 'JavaScript niet beschikbaar',
        'In order to experience this software, you\'ll need to enable JavaScript in your browser.' =>
            '',
        'Browser Warning' => 'Waarschuwing',
        'The browser you are using is too old.' => 'De browser die u gebruikt is te oud.',
        'This software runs with a huge lists of browsers, please upgrade to one of these.' =>
            '',
        'Please see the documentation or ask your admin for further information.' =>
            'Zie de documentatie of vraag uw beheerder voor meer informatie.',
        'One moment please, you are being redirected...' => 'Een moment alstublieft, je wordt doorverwezen',
        'Login' => 'Inloggen',
        'User name' => 'Gebruikersnaam',
        'Your user name' => 'Uw gebruikersnaam',
        'Your password' => 'Uw wachtwoord',
        'Forgot password?' => 'Wachtwoord vergeten?',
        '2 Factor Token' => '2 stappen code',
        'Your 2 Factor Token' => 'Uw 2 stappen code',
        'Log In' => 'Inloggen',
        'Not yet registered?' => 'Nog niet geregistreerd?',
        'Back' => 'Terug',
        'Request New Password' => 'Vraag nieuw wachtwoord aan',
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
        'Edit personal preferences' => 'Eigen voorkeuren bewerken',
        'Logout %s' => '',

        # Template: CustomerTicketMessage
        'Service level agreement' => 'Service level agreement',

        # Template: CustomerTicketOverview
        'Welcome!' => 'Welkom!',
        'Please click the button below to create your first ticket.' => 'Klik op de button om uw eerste ticket aan te maken.',
        'Create your first ticket' => 'Maak uw eerste ticket aan',

        # Template: CustomerTicketSearch
        'Profile' => 'Sjabloon',
        'e. g. 10*5155 or 105658*' => 'bijv. 2010*5155 of 20100802*',
        'CustomerID' => 'Klantcode',
        'Fulltext Search in Tickets (e. g. "John*n" or "Will*")' => '',
        'Types' => 'Typen',
        'Time Restrictions' => '',
        'No time settings' => 'Niet zoeken op tijd',
        'All' => 'Alle',
        'Specific date' => 'Specifieke datum',
        'Only tickets created' => 'Alleen tickets aangemaakt',
        'Date range' => 'Datum range',
        'Only tickets created between' => 'Alleen tickets aangemaakt tussen',
        'Ticket Archive System' => 'Ticket archievering',
        'Save Search as Template?' => 'Zoekopdracht opslaan als sjabloon?',
        'Save as Template?' => 'Bewaar als sjabloon?',
        'Save as Template' => 'Bewaar',
        'Template Name' => 'Template naam',
        'Pick a profile name' => 'Naam voor dit sjabloon',
        'Output to' => 'Uitvoer naar',

        # Template: CustomerTicketSearchResultShort
        'of' => 'van',
        'Page' => 'Pagina',
        'Search Results for' => 'Zoekresultaat voor',
        'Remove this Search Term.' => 'Verwijder deze zoekterm',

        # Template: CustomerTicketZoom
        'Start a chat from this ticket' => 'Begin een chat vanuit dit ticket',
        'Next Steps' => 'Volgende stappen',
        'Reply' => 'Beantwoord',

        # Template: Chat
        'Expand article' => 'Toon interactie',

        # Template: CustomerWarning
        'Warning' => 'Waarschuwing',

        # Template: DashboardEventsTicketCalendar
        'Event Information' => 'Event informatie',
        'Ticket fields' => 'Ticket-velden',

        # Template: Error
        'Really a bug? 5 out of 10 bug reports result from a wrong or incomplete installation of OTRS.' =>
            'Is dit echt een fout? 5 van de 10 bugrapporten zijn het gevolg van een verkeerde of onvolledige installatie van OTRS.',
        'With %s, our experts take care of correct installation and cover your back with support and periodic security updates.' =>
            '',
        'Contact our service team now.' => '',
        'Send a bugreport' => 'Een bug report indienen',
        'Expand' => 'Klap uit',

        # Template: AttachmentList
        'Click to delete this attachment.' => '',

        # Template: DraftButtons
        'Update draft' => 'Concept bijwerken',
        'Save as new draft' => '',

        # Template: DraftNotifications
        'You have loaded the draft "%s".' => '',
        'You have loaded the draft "%s". You last changed it %s.' => '',
        'You have loaded the draft "%s". It was last changed %s by %s.' =>
            '',
        'Please note that this draft is outdated because the ticket was modified since this draft was created.' =>
            '',

        # Template: Header
        'View notifications' => 'Bekijk meldingen',
        'Notifications' => 'Meldingen',
        'Notifications (OTRS Business Solution™)' => 'Meldingen (OTRS Business Solution™)',
        'Personal preferences' => 'Eigen voorkeuren',
        'Logout' => 'Afmelden',
        'You are logged in as' => 'Ingelogd als',

        # Template: Installer
        'JavaScript not available' => 'JavaScript is niet beschikbaar',
        'Step %s' => 'Stap %s',
        'License' => 'Licentie',
        'Database Settings' => 'Database configuratie',
        'General Specifications and Mail Settings' => 'Algemene instellingen en mailconfiguratie',
        'Finish' => 'Voltooien',
        'Welcome to %s' => 'Welkom bij %s',
        'Germany' => 'Duitsland',
        'Phone' => 'Telefoon',
        'United States' => 'Verenigde Staten',
        'Mexico' => 'Mexico',
        'Hungary' => 'Hongarije',
        'Brazil' => 'Brazilië',
        'Singapore' => 'Singapore',
        'Hong Kong' => 'Hong Kong',
        'Web site' => 'Website',

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
        'Done' => 'Klaar',
        'Error' => 'Fout',
        'Database setup successful!' => 'Database-installatie afgerond.',

        # Template: InstallerDBStart
        'Install Type' => 'Installatie-type',
        'Create a new database for OTRS' => 'Maak een nieuwe database voor OTRS aan',
        'Use an existing database for OTRS' => 'Gebruik een bestaande database voor OTRS',

        # Template: InstallerDBmssql
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty.' =>
            'Als er een root-wachtwoord voor deze database nodig is, vul deze hier in. Anders moet dit veld leeg blijven.',
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
        'Delete link' => 'Koppeling verwijderen',
        'Delete Link' => 'Koppeling verwijderen',
        'Object#' => 'Object#',
        'Add links' => 'Links toevoegen',
        'Delete links' => 'Links verwijderen',

        # Template: Login
        'Lost your password?' => 'Wachtwoord vergeten?',
        'Back to login' => 'Terug naar inlogscherm',

        # Template: MetaFloater
        'Scale preview content' => '',
        'Open URL in new tab' => 'Open URL in nieuw tabblad',
        'Close preview' => 'Voorvertoning sluiten',
        'A preview of this website can\'t be provided because it didn\'t allow to be embedded.' =>
            'Een preview is niet beschikbaar omdat het geen embedding toestaat. ',

        # Template: MobileNotAvailableWidget
        'Feature not Available' => 'Functionaliteit niet beschikbaar',
        'Sorry, but this feature of OTRS is currently not available for mobile devices. If you\'d like to use it, you can either switch to desktop mode or use your regular desktop device.' =>
            'Helaas, maar deze functionaliteit van OTRS is op dit moment niet beschikbaar voor mobiele apparaten. Als je de functionaliteit toch wil gebruiken kun je swichen naar desktop weergave of je desktop device gebruiken.',

        # Template: Motd
        'Message of the Day' => 'Bericht van de dag',
        'This is the message of the day. You can edit this in %s.' => '',

        # Template: NoPermission
        'Insufficient Rights' => 'Onvoldoende permissies',
        'Back to the previous page' => 'Terug naar de vorige pagina',

        # Template: Alert
        'Alert' => '',
        'Powered by' => 'Draait op',

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
        'No user configurable notifications found.' => 'Door de eindgebruiker instelbare meldingen gevonden.',
        'Receive messages for notification \'%s\' by transport method \'%s\'.' =>
            'Ontvang berichten voor meldingen \'%s\' via transport methode \'%s\'.',

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

        # Template: GeneralSpecificationsWidget
        'Permissions' => 'Permissies',
        'You can select one or more groups to define access for different agents.' =>
            'U kunt één of meerdere groepen definiëren die deze rapportage kunnen gebruiken.',
        'Result formats' => 'Resultaat formulieren',
        'Time Zone' => 'Tijdzone',
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
        'Preview format' => '',
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
        'Between %s and %s' => '',
        'Relative period' => 'Relatieve periode',
        'The past complete %s and the current+upcoming complete %s %s' =>
            'De historische complete %s en de huidige en aankomende complete %s %s',
        'Do not allow changes to this element when the statistic is generated.' =>
            'Sta niet toe om dit element te wijzigen wanneer de statistiek wordt gegenereerd.',

        # Template: StatsParamsWidget
        'Format' => 'Formaat',
        'Exchange Axis' => 'Wissel assen',
        'Configurable Params of Static Stat' => '',
        'No element selected.' => 'Geen element geselecteerd.',
        'Scale' => 'Schaal',
        'show more' => 'Toon meer',
        'show less' => 'Toon minder',

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

        # Template: SettingsList
        'This setting is disabled.' => 'Deze instelling is uitgeschakeld',
        'This setting is fixed but not deployed yet!' => '',
        'This setting is currently being overridden in %s and can\'t thus be changed here!' =>
            '',
        'Changing this setting is only available in a higher config level!' =>
            '',
        '%s (%s) is currently working on this setting.' => '',
        'Toggle advanced options for this setting' => '',
        'Disable this setting, so it is no longer effective' => '',
        'Disable' => 'Uitschakelen',
        'Enable this setting, so it becomes effective' => 'Schakel deze instellin in, zodat deze actief wordt.',
        'Enable' => 'Inschakelen',
        'Reset this setting to its default state' => '',
        'Reset setting' => '',
        'Allow users to adapt this setting from within their personal preferences' =>
            '',
        'Allow users to update' => '',
        'Do not longer allow users to adapt this setting from within their personal preferences' =>
            'Sta niet langer toe dat gebruikers deze instelling aanpassen aan hun persoonlijke voorkeuren',
        'Forbid users to update' => '',
        'Show user specific changes for this setting' => '',
        'Show user settings' => '',
        'Copy a direct link to this setting to your clipboard' => '',
        'Copy direct link' => 'Directe link kopieren',
        'Remove this setting from your favorites setting' => '',
        'Remove from favourites' => 'Verwijder van favorieten',
        'Add this setting to your favorites' => '',
        'Add to favourites' => 'Toevoegen aan favorieten',
        'Cancel editing this setting' => '',
        'Save changes on this setting' => 'Sla wijzigingen van deze instelling op',
        'Edit this setting' => 'Instelling bewerken',
        'Enable this setting' => 'Instelling inschakelen',
        'This group doesn\'t contain any settings. Please try navigating to one of its sub groups or another group.' =>
            '',

        # Template: SettingsListCompare
        'Now' => 'Nu',
        'User modification' => '',
        'enabled' => 'ingeschakeld',
        'disabled' => 'uitgeschakeld',
        'Setting state' => '',

        # Template: Actions
        'Edit search' => 'Bewerk zoekopdracht',
        'Go back to admin: ' => 'Ga terug naar admin:',
        'Deployment' => '',
        'My favourite settings' => '',
        'Invalid settings' => 'Ongeldige instellingen',

        # Template: DynamicActions
        'Filter visible settings...' => '',
        'Enable edit mode for all settings' => '',
        'Save all edited settings' => 'Alle gewijzigde instellingen opslaan',
        'Cancel editing for all settings' => 'Annuleer wijzigingen voor alle instellingen',
        'All actions from this widget apply to the visible settings on the right only.' =>
            '',

        # Template: Help
        'Currently edited by me.' => 'Momenteel bewerkt door mij.',
        'Modified but not yet deployed.' => '',
        'Currently edited by another user.' => '',
        'Different from its default value.' => '',
        'Save current setting.' => 'Huidige instelling opslaan',
        'Cancel editing current setting.' => '',

        # Template: Navigation
        'Navigation' => 'Navigatie',

        # Template: OTRSBusinessTeaser
        'With %s, System Configuration supports versioning, rollback and user-specific configuration settings.' =>
            '',

        # Template: Test
        'OTRS Test Page' => 'OTRS Testpagina',
        'Unlock' => 'Ontgrendel',
        'Welcome %s %s' => 'Welkom %s %s',
        'Counter' => 'Teller',

        # Template: Warning
        'Go back to the previous page' => 'Terug naar de vorige pagina',

        # JS Template: CalendarSettingsDialog
        'Show' => '',

        # JS Template: FormDraftAddDialog
        'Draft title' => 'Concept titel',

        # JS Template: ArticleViewSettingsDialog
        'Article display' => '',

        # JS Template: FormDraftDeleteDialog
        'Do you really want to delete "%s"?' => '',
        'Confirm' => 'Bevestigen',

        # JS Template: WidgetLoading
        'Loading, please wait...' => '',

        # JS Template: UploadContainer
        'Click to select a file for upload.' => '',
        'Click to select files or just drop them here.' => '',
        'Click to select a file or just drop it here.' => '',
        'Uploading...' => '',

        # JS Template: InformationDialog
        'Process state' => '',
        'Running' => '',
        'Finished' => 'Afgerond',
        'No package information available.' => '',

        # JS Template: AddButton
        'Add new entry' => 'Nieuwe sleutel toevoegen',

        # JS Template: AddHashKey
        'Add key' => 'Sleutel toevoegen',

        # JS Template: DialogDeployment
        'Deployment comment...' => '',
        'This field can have no more than 250 characters.' => '',
        'Deploying, please wait...' => '',
        'Preparing to deploy, please wait...' => '',
        'Deploy now' => 'Nu uitrollen',
        'Try again' => '',

        # JS Template: DialogReset
        'Reset options' => '',
        'Reset setting on global level.' => '',
        'Reset globally' => '',
        'Remove all user changes.' => '',
        'Reset locally' => '',
        'user(s) have modified this setting.' => '',
        'Do you really want to reset this setting to it\'s default value?' =>
            '',

        # JS Template: HelpDialog
        'You can use the category selection to limit the navigation tree below to entries from the selected category. As soon as you select the category, the tree will be re-built.' =>
            '',

        # Perl Module: Kernel/Config/Defaults.pm
        'Database Backend' => '',
        'CustomerIDs' => 'Klantcodes',
        'Fax' => 'Fax',
        'Street' => 'Straat',
        'Zip' => 'Postcode',
        'City' => 'Plaats',
        'Country' => 'Land',
        'Valid' => 'Geldigheid',
        'Mr.' => 'Dhr.',
        'Mrs.' => 'Mevr.',
        'Address' => 'Adres',
        'View system log messages.' => 'Bekijk het OTRS logboek.',
        'Edit the system configuration settings.' => 'Bewerk de systeemconfiguratie.',
        'Update and extend your system with software packages.' => 'Voeg functies toe aan uw systeem door het installeren van pakketten.',

        # Perl Module: Kernel/Modules/AdminACL.pm
        'ACL information from database is not in sync with the system configuration, please deploy all ACLs.' =>
            'De ACL-informatie in de database is niet gesynchroniseerd met het systeem. Activeer alle ACLs.',
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
        '%s (copy) %s' => '',
        'Please note that ACL restrictions will be ignored for the Superuser account (UserID 1).' =>
            '',
        'Exact match' => 'Exacte overeenkomst',
        'Negated exact match' => '',
        'Regular expression' => 'Reguliere expressie',
        'Regular expression (ignore case)' => '',
        'Negated regular expression' => '',
        'Negated regular expression (ignore case)' => '',

        # Perl Module: Kernel/Modules/AdminAppointmentCalendarManage.pm
        'System was unable to create Calendar!' => '',
        'Please contact the administrator.' => '',
        'No CalendarID!' => '',
        'You have no access to this calendar!' => '',
        'Error updating the calendar!' => '',
        'Couldn\'t read calendar configuration file.' => '',
        'Please make sure your file is valid.' => '',
        'Could not import the calendar!' => '',
        'Calendar imported!' => '',
        'Need CalendarID!' => '',
        'Could not retrieve data for given CalendarID' => '',
        'Successfully imported %s appointment(s) to calendar %s.' => '',
        '+5 minutes' => '+5 minuten',
        '+15 minutes' => '+15 minuten',
        '+30 minutes' => '+30 minuten',
        '+1 hour' => '+1 uur',

        # Perl Module: Kernel/Modules/AdminAppointmentImport.pm
        'No permissions' => 'Geen rechten',
        'System was unable to import file!' => '',
        'Please check the log for more information.' => '',

        # Perl Module: Kernel/Modules/AdminAppointmentNotificationEvent.pm
        'Notification name already exists!' => 'Naam van de melding bestaat reeds!',
        'Notification added!' => 'Melding toegevoegd!',
        'There was an error getting data for Notification with ID:%s!' =>
            'Er is een fout opgetreden bij het ophalen van de gegevens met ID:%s!',
        'Unknown Notification %s!' => 'Onbekende melding %s!',
        '%s (copy)' => '',
        'There was an error creating the Notification' => 'Er is een fout opgetreden bij het genereren van de melding',
        'Notifications could not be Imported due to a unknown error, please check OTRS logs for more information' =>
            'Meldingen konden niet worden geïmporteerd vanwege een onbekende fout. Kijk de OTRS logbestanden na voor meer informatie.',
        'The following Notifications have been added successfully: %s' =>
            'De volgende melding is succesvol toegevoegd: %s',
        'The following Notifications have been updated successfully: %s' =>
            'De volgende melding is succesvol bijgewerkt: %s',
        'There where errors adding/updating the following Notifications: %s. Please check the log file for more information.' =>
            'Er zijn fouten opgetreden bij het toevoegen/aanpassen van de volgende melding: %s. Kijk de OTRS logbestanden na voor meer informatie.',
        'Notification updated!' => 'Melding bijgewerkt!',
        'Agent (resources), who are selected within the appointment' => '',
        'All agents with (at least) read permission for the appointment (calendar)' =>
            '',
        'All agents with write permission for the appointment (calendar)' =>
            '',
        'Yes, but require at least one active notification method.' => 'Ja, maar er is minimaal één actieve melding methode nodig.',

        # Perl Module: Kernel/Modules/AdminAttachment.pm
        'Attachment added!' => 'Bijlage toegevoegd.',

        # Perl Module: Kernel/Modules/AdminAutoResponse.pm
        'Auto Response added!' => '',

        # Perl Module: Kernel/Modules/AdminCommunicationLog.pm
        'Invalid CommunicationID!' => '',
        'All communications' => 'Alle communicatie',
        'Last 1 hour' => 'Laatste uur',
        'Last 3 hours' => 'Laatste 3 uur',
        'Last 6 hours' => 'Laatste 6 uur',
        'Last 12 hours' => 'Laatste 12 uur',
        'Last 24 hours' => 'Laatste 24 uur',
        'Last week' => 'Laatste week',
        'Last month' => 'Laatste maand',
        'Invalid StartTime: %s!' => '',
        'Successful' => 'Succesvol',
        'Processing' => '',
        'Failed' => 'Mislukt',
        'Invalid Filter: %s!' => '',
        'Less than a second' => 'Minder dan een seconde',
        'sorted descending' => '',
        'sorted ascending' => '',
        'Trace' => '',
        'Debug' => 'Debug',
        'Info' => 'Informatie',
        'Warn' => '',
        'days' => 'dagen',
        'day' => 'dag',
        'hour' => 'uur',
        'minute' => 'minuut',
        'seconds' => 'seconden',
        'second' => 'seconde',

        # Perl Module: Kernel/Modules/AdminCustomerCompany.pm
        'Customer company updated!' => 'Bedrijf bijgewerkt!',
        'Dynamic field %s not found!' => 'Dynamisch veld %s niet gevonden!',
        'Unable to set value for dynamic field %s!' => '',
        'Customer Company %s already exists!' => 'Bedrijf %s bestaat al!',
        'Customer company added!' => 'Bedrijf toegevoegd!',

        # Perl Module: Kernel/Modules/AdminCustomerGroup.pm
        'No configuration for \'CustomerGroupPermissionContext\' found!' =>
            '',
        'Please check system configuration.' => '',
        'Invalid permission context configuration:' => '',

        # Perl Module: Kernel/Modules/AdminCustomerUser.pm
        'Customer updated!' => 'Klant aangepast.',
        'New phone ticket' => 'Nieuw telefoon-ticket',
        'New email ticket' => 'Nieuw e-mail-ticket',
        'Customer %s added' => 'Klant %s toegevoegd.',
        'Customer user updated!' => '',
        'Same Customer' => '',
        'Direct' => '',
        'Indirect' => '',

        # Perl Module: Kernel/Modules/AdminCustomerUserGroup.pm
        'Change Customer User Relations for Group' => '',
        'Change Group Relations for Customer User' => '',

        # Perl Module: Kernel/Modules/AdminCustomerUserService.pm
        'Allocate Customer Users to Service' => '',
        'Allocate Services to Customer User' => '',

        # Perl Module: Kernel/Modules/AdminDynamicField.pm
        'Fields configuration is not valid' => 'Velden configuratie is niet geldig',
        'Objects configuration is not valid' => 'Object configuratie is niet geldig',
        'Database (%s)' => 'Database (%s)',
        'Web service (%s)' => 'Web service (%s)',
        'Contact with data (%s)' => '',
        'Could not reset Dynamic Field order properly, please check the error log for more details.' =>
            'Kon dynamische velden niet herstellen, kijk in het logbestand voor details.',

        # Perl Module: Kernel/Modules/AdminDynamicFieldCheckbox.pm
        'Undefined subaction.' => 'Ongedefinieerde subactie.',
        'Need %s' => 'Heb %s nodig',
        'Add %s field' => '',
        'The field does not contain only ASCII letters and numbers.' => 'Het veld bevat niet alleen maar ASCII letters en cijfers.',
        'There is another field with the same name.' => 'Er is een ander veld met dezelfde naam.',
        'The field must be numeric.' => 'Het veld moet numeriek zijn.',
        'Need ValidID' => 'Heb ValidID nodig',
        'Could not create the new field' => 'Het nieuwe veld kon niet worden aangemaakt',
        'Need ID' => 'Heb ID nodig',
        'Could not get data for dynamic field %s' => 'Kon de gegevens voor dynamisch veld %s niet ophalen',
        'Change %s field' => '',
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
        'minute(s)' => 'minu(u)t(en)',
        'hour(s)' => 'u(u)r(en)',
        'Time unit' => 'Tijd',
        'within the last ...' => 'in de laatste ...',
        'within the next ...' => 'in de volgende ...',
        'more than ... ago' => 'langer dan ... geleden',
        'Unarchived tickets' => 'Ongearchiveerde tickets',
        'archive tickets' => 'archiveer tickets',
        'restore tickets from archive' => 'tickets van archief herstellen',
        'Need Profile!' => 'Profiel vereist!',
        'Got no values to check.' => 'Had geen waarden om te controleren',
        'Please remove the following words because they cannot be used for the ticket selection:' =>
            'Verwijder de volgende woorden omdat ze niet kunnen worden gebruikt voor het selecteren van een ticket:',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceDebugger.pm
        'Need WebserviceID!' => 'WebserviceID is vereist!',
        'Could not get data for WebserviceID %s' => 'Kon gegevens van WebserviceID %s niet ophalen',
        'ascending' => 'aflopend',
        'descending' => 'oplopend',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceErrorHandlingDefault.pm
        'Need communication type!' => 'Communicatie type vereist!',
        'Communication type needs to be \'Requester\' or \'Provider\'!' =>
            '',
        'Invalid Subaction!' => '',
        'Need ErrorHandlingType!' => '',
        'ErrorHandlingType %s is not registered' => '',
        'Could not update web service' => '',
        'Need ErrorHandling' => '',
        'Could not determine config for error handler %s' => '',
        'Invoker processing outgoing request data' => '',
        'Mapping outgoing request data' => '',
        'Transport processing request into response' => '',
        'Mapping incoming response data' => '',
        'Invoker processing incoming response data' => '',
        'Transport receiving incoming request data' => '',
        'Mapping incoming request data' => '',
        'Operation processing incoming request data' => '',
        'Mapping outgoing response data' => '',
        'Transport sending outgoing response data' => '',
        'skip same backend modules only' => '',
        'skip all modules' => 'alle modules overslaan',
        'Operation deleted' => '',
        'Invoker deleted' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceErrorHandlingRequestRetry.pm
        '0 seconds' => '0 seconden',
        '15 seconds' => '15 seconden',
        '30 seconds' => '30 seconden',
        '45 seconds' => '45 seconden',
        '1 minute' => '1 minuut',
        '2 minutes' => '2 minuten',
        '3 minutes' => '3 minuten',
        '4 minutes' => '4 minuten',
        '5 minutes' => '5 minuten',
        '10 minutes' => '10 minuten',
        '15 minutes' => '15 minuten',
        '30 minutes' => '30 minuten',
        '1 hour' => '1 uur',
        '2 hours' => '2 uu',
        '3 hours' => '3 uur',
        '4 hours' => '4 uur',
        '5 hours' => '5 uur',
        '6 hours' => '6 uur',
        '12 hours' => '12 uur',
        '18 hours' => '18 uu',
        '1 day' => '1 dag',
        '2 days' => '2 dagen',
        '3 days' => '3 dagen',
        '4 days' => '4 dagen',
        '6 days' => '6 dagen',
        '1 week' => '1 week',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceInvokerDefault.pm
        'Could not determine config for invoker %s' => 'Kon configuratie voor invoker %s niet bepalen.',
        'InvokerType %s is not registered' => '',
        'MappingType %s is not registered' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceInvokerEvent.pm
        'Need Invoker!' => 'Invoker vereist!',
        'Need Event!' => 'Gebeurtenis vereist!',
        'Could not get registered modules for Invoker' => '',
        'Could not get backend for Invoker %s' => '',
        'The event %s is not valid.' => '',
        'Could not update configuration data for WebserviceID %s' => 'Configuratiebestand kon niet worden bijgewerkt voor Webservice met ID %s',
        'This sub-action is not valid' => '',
        'xor' => 'xor',
        'String' => 'String',
        'Regexp' => 'Regexp',
        'Validation Module' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceMappingSimple.pm
        'Simple Mapping for Outgoing Data' => '',
        'Simple Mapping for Incoming Data' => '',
        'Could not get registered configuration for action type %s' => 'Het geregistreerde configuratiebestand voor actie type %s kon niet worden opgehaald',
        'Could not get backend for %s %s' => 'Backend voor %s %s kon niet worden opgehaald',
        'Keep (leave unchanged)' => '',
        'Ignore (drop key/value pair)' => '',
        'Map to (use provided value as default)' => '',
        'Exact value(s)' => '',
        'Ignore (drop Value/value pair)' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceMappingXSLT.pm
        'XSLT Mapping for Outgoing Data' => '',
        'XSLT Mapping for Incoming Data' => '',
        'Could not find required library %s' => '',
        'Outgoing request data before processing (RequesterRequestInput)' =>
            '',
        'Outgoing request data before mapping (RequesterRequestPrepareOutput)' =>
            '',
        'Outgoing request data after mapping (RequesterRequestMapOutput)' =>
            '',
        'Incoming response data before mapping (RequesterResponseInput)' =>
            '',
        'Outgoing error handler data after error handling (RequesterErrorHandlingOutput)' =>
            '',
        'Incoming request data before mapping (ProviderRequestInput)' => '',
        'Incoming request data after mapping (ProviderRequestMapOutput)' =>
            '',
        'Outgoing response data before mapping (ProviderResponseInput)' =>
            '',
        'Outgoing error handler data after error handling (ProviderErrorHandlingOutput)' =>
            '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceOperationDefault.pm
        'Could not determine config for operation %s' => 'Configuratiebestand kon niet bepaald worden voor operatie %s',
        'OperationType %s is not registered' => 'OperatieType %s is niet geregistreerd',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceTransportHTTPREST.pm
        'Need valid Subaction!' => 'Geldige subactie vereist!',
        'This field should be an integer.' => '',
        'File or Directory not found.' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceWebservice.pm
        'There is another web service with the same name.' => 'Er is nog een webservice met dezelfde naam.',
        'There was an error updating the web service.' => 'Er is een fout opgetreden bij het bijwerken van de webservice.',
        'There was an error creating the web service.' => 'Er is een fout opgetreden bij het aanmaken van de webservice.',
        'Web service "%s" created!' => 'Webservice "%s" aangemaakt!',
        'Need Name!' => 'Heb Naam nodig!',
        'Need ExampleWebService!' => '',
        'Could not load %s.' => '',
        'Could not read %s!' => 'Kan %s niet lezen!',
        'Need a file to import!' => 'Heb een bestand nodig om te importeren!',
        'The imported file has not valid YAML content! Please check OTRS log for details' =>
            'Het geïmporteerde bestand is geen geldig YAML bestand! Kijk in het logbestand voor details',
        'Web service "%s" deleted!' => 'Webservice "%s" verwijderd!',
        'OTRS as provider' => 'OTRS als provider',
        'Operations' => '',
        'OTRS as requester' => 'OTRS als requester',
        'Invokers' => 'Invokers',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceWebserviceHistory.pm
        'Got no WebserviceHistoryID!' => 'Heb geen WebserviceHistoryID!',
        'Could not get history data for WebserviceHistoryID %s' => '',

        # Perl Module: Kernel/Modules/AdminGroup.pm
        'Group updated!' => 'Groep bijgewerkt.',

        # Perl Module: Kernel/Modules/AdminMailAccount.pm
        'Mail account added!' => 'E-mailaccount toegevoegd.',
        'Email account fetch already fetched by another process. Please try again later!' =>
            '',
        'Dispatching by email To: field.' => 'Toewijzen gebaseerd op e-mailadres.',
        'Dispatching by selected Queue.' => 'Toewijzen gebaseerd op geselecteerde wachtrij.',

        # Perl Module: Kernel/Modules/AdminNotificationEvent.pm
        'Agent who created the ticket' => '',
        'Agent who owns the ticket' => 'Eigenaar van het ticket',
        'Agent who is responsible for the ticket' => 'Verantwoordelijke voor het ticket',
        'All agents watching the ticket' => 'Alle agent die het ticket in de gaten houden',
        'All agents with write permission for the ticket' => 'Alle agents met schrijf rechten voor het ticket',
        'All agents subscribed to the ticket\'s queue' => 'Alle agents die zich hebben ingeschreven op de wachtrij',
        'All agents subscribed to the ticket\'s service' => 'Alle agents die zich hebben ingeschreven op de service',
        'All agents subscribed to both the ticket\'s queue and service' =>
            'Alle agents die zich zowel op de wachtrij, als op de service hebben ingeschreven',
        'Customer user of the ticket' => 'Klantgebruiker van het ticket',
        'All recipients of the first article' => 'Alle ontvangers van het eerste artikel',
        'All recipients of the last article' => 'Alle ontvangers van het laatste artikel',
        'Invisible to customer' => 'Onzichtbaar voor klant',
        'Visible to customer' => 'Zichtbaar voor klant',

        # Perl Module: Kernel/Modules/AdminOTRSBusiness.pm
        'Your system was successfully upgraded to %s.' => 'Het systeem is succesvol geupgraded naar %s.',
        'There was a problem during the upgrade to %s.' => 'Er is een probleem opgetreden bij het upgraden naar %s.',
        '%s was correctly reinstalled.' => '%s is opnieuw geïnstalleerd zonder problemen.',
        'There was a problem reinstalling %s.' => 'Er is een probleem opgetreden bij het herinstalleren van %s.',
        'Your %s was successfully updated.' => 'Uw %s werd succesvol geupdated.',
        'There was a problem during the upgrade of %s.' => 'Er is een probleem opgetreden tijdens het upgraden van %s.',
        '%s was correctly uninstalled.' => '%s werd zonder problemen verwijderd.',
        'There was a problem uninstalling %s.' => 'Er is een probleem opgetreden bij het verwijderen van %s.',

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
        'Package not verified by the OTRS Group! It is recommended not to use this package.' =>
            'Pakket niet geverifieerd door de OTRS Groep! We raden aan dit pakket niet te gebruiken.',
        'Not Started' => '',
        'Updated' => 'Bijgewerkt',
        'Already up-to-date' => '',
        'Installed' => 'Geïnstalleerd',
        'Not correctly deployed' => '',
        'Package updated correctly' => '',
        'Package was already updated' => '',
        'Dependency installed correctly' => '',
        'The package needs to be reinstalled' => '',
        'The package contains cyclic dependencies' => '',
        'Not found in on-line repositories' => '',
        'Required version is higher than available' => '',
        'Dependencies fail to upgrade or install' => '',
        'Package could not be installed' => '',
        'Package could not be upgraded' => '',
        'Repository List' => '',
        'No packages found in selected repository. Please check log for more info!' =>
            '',
        'Package not verified due a communication issue with verification server!' =>
            'Pakket niet gecontroleerd vanwege een communicatiefout met de server!',
        'Can\'t connect to OTRS Feature Add-on list server!' => '',
        'Can\'t get OTRS Feature Add-on list from server!' => '',
        'Can\'t get OTRS Feature Add-on from server!' => '',

        # Perl Module: Kernel/Modules/AdminPostMasterFilter.pm
        'No such filter: %s' => 'Filter %s bestaat niet',

        # Perl Module: Kernel/Modules/AdminPriority.pm
        'Priority added!' => 'Prioriteit toegevoegd.',

        # Perl Module: Kernel/Modules/AdminProcessManagement.pm
        'Process Management information from database is not in sync with the system configuration, please synchronize all processes.' =>
            'Proces informatie uit de database is niet gesynchroniseerd met de systeemconfiguratie. Voer een synchronisatie uit.',
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
        'Could not delete %s:%s' => 'Kan %s:%s niet verwijderen',
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
        'Agent Interface' => 'Behandelaar interface',
        'Customer Interface' => 'Klant interface',
        'Agent and Customer Interface' => '',
        'Do not show Field' => '',
        'Show Field' => '',
        'Show Field As Mandatory' => '',

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
        'Queue updated!' => 'Wachtrij bijgewerkt.',
        'Don\'t use :: in queue name!' => '',
        'Click back and change it!' => '',
        '-none-' => '-geen-',

        # Perl Module: Kernel/Modules/AdminQueueAutoResponse.pm
        'Queues ( without auto responses )' => 'Wachtrijen (zonder automatische antwoorden)',

        # Perl Module: Kernel/Modules/AdminQueueTemplates.pm
        'Change Queue Relations for Template' => 'Verander gekoppelde wachtrijen voor sjabloon',
        'Change Template Relations for Queue' => 'Verander gekoppelde sjablonen voor wachtrij',

        # Perl Module: Kernel/Modules/AdminRegistration.pm
        'Production' => 'Produktie',
        'Test' => 'Test',
        'Training' => 'Training',
        'Development' => 'Ontwikkeling',

        # Perl Module: Kernel/Modules/AdminRole.pm
        'Role updated!' => 'Rol bijgewerkt.',
        'Role added!' => 'Rol toegevoegd.',

        # Perl Module: Kernel/Modules/AdminRoleGroup.pm
        'Change Group Relations for Role' => 'Bewerk gekoppelde groepen voor rol',
        'Change Role Relations for Group' => 'Bewerk gekoppelde rollen voor groep',

        # Perl Module: Kernel/Modules/AdminRoleUser.pm
        'Role' => 'Rol',
        'Change Role Relations for Agent' => 'Bewerk gekoppelde rollen voor behandelaar',
        'Change Agent Relations for Role' => 'Bewerk gekoppelde behandelaars voor rol',

        # Perl Module: Kernel/Modules/AdminSLA.pm
        'Please activate %s first!' => 'Activeer %s eerst.',

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
        'Handle Private Certificate Relations' => '',

        # Perl Module: Kernel/Modules/AdminSalutation.pm
        'Salutation added!' => 'Aanhef toegevoegd!',

        # Perl Module: Kernel/Modules/AdminSignature.pm
        'Signature updated!' => 'Handtekening bijgewerkt.',
        'Signature added!' => 'Handtekening toegevoegd.',

        # Perl Module: Kernel/Modules/AdminState.pm
        'State added!' => 'Status toegevoegd.',

        # Perl Module: Kernel/Modules/AdminSupportDataCollector.pm
        'File %s could not be read!' => 'Bestand %skan niet worden gelezen!',

        # Perl Module: Kernel/Modules/AdminSystemAddress.pm
        'System e-mail address added!' => 'E-mailadres toegevoegd.',

        # Perl Module: Kernel/Modules/AdminSystemConfiguration.pm
        'Invalid Settings' => 'Ongeldige instellingen',
        'There are no invalid settings active at this time.' => 'Er zijn op dit moment geen ongeldige instellingen actief.',
        'You currently don\'t have any favourite settings.' => 'U hebt momenteel geen favoriete instellingen.',
        'The following settings could not be found: %s' => 'De volgende instellingen kunnen niet worden gevonden: %s',
        'Import not allowed!' => 'Importeren is niet toegestaan!',
        'System Configuration could not be imported due to an unknown error, please check OTRS logs for more information.' =>
            'Systeemconfiguratie kon niet worden geïmporteerd vanwege een onbekende fout. Raadpleeg de OTRS-logboeken voor meer informatie.',
        'Category Search' => 'Categorie zoeken',

        # Perl Module: Kernel/Modules/AdminSystemConfigurationDeployment.pm
        'Some imported settings are not present in the current state of the configuration or it was not possible to update them. Please check the OTRS log for more information.' =>
            'Sommige geïmporteerde instellingen zijn niet aanwezig in de huidige  configuratie of het was niet mogelijk om deze bij te werken. Raadpleeg het OTRS-logboek voor meer informatie.',

        # Perl Module: Kernel/Modules/AdminSystemConfigurationGroup.pm
        'You need to enable the setting before locking!' => 'U moet de instelling inschakelen voor vergrendeling!',
        'You can\'t work on this setting because %s (%s) is currently working on it.' =>
            'U kunt niet aan deze instelling werken omdat %s (%s) is er momenteel mee aan het werk.',
        'Missing setting name!' => '',
        'Missing ResetOptions!' => '',
        'Setting is locked by another user!' => '',
        'System was not able to lock the setting!' => '',
        'System was not able to reset the setting!' => '',
        'System was unable to update setting!' => '',
        'Missing setting name.' => '',
        'Setting not found.' => 'Instelling niet gevonden.',
        'Missing Settings!' => 'Ontbrekende Instellingen!',

        # Perl Module: Kernel/Modules/AdminSystemMaintenance.pm
        'Start date shouldn\'t be defined after Stop date!' => 'Begindatum moet vóór de einddatum liggen!',
        'There was an error creating the System Maintenance' => 'Er is een fout opgetreden bij het aanmaken van het systeem onderhoudsvenster',
        'Need SystemMaintenanceID!' => 'Heb een SysteemOnderhoudsID nodig!',
        'Could not get data for SystemMaintenanceID %s' => 'Kon gegevens voor SystemOnderhoudID %s niet ophalen',
        'System Maintenance was added successfully!' => '',
        'System Maintenance was updated successfully!' => '',
        'Session has been killed!' => 'Sessie is beëindigd!',
        'All sessions have been killed, except for your own.' => 'Alle sessies zijn beëindigd behalve die van uzelf.',
        'There was an error updating the System Maintenance' => 'Er is een fout opgetreden bij het update van het Systeem Onderhoudsvenster',
        'Was not possible to delete the SystemMaintenance entry: %s!' => 'Het was niet mogelijk om het Systeem Onderhoudsvenster %s te verwijderen!',

        # Perl Module: Kernel/Modules/AdminTemplate.pm
        'Template updated!' => 'Sjabloon bijgewerkt!',
        'Template added!' => 'Sjabloon toegevoegd!',

        # Perl Module: Kernel/Modules/AdminTemplateAttachment.pm
        'Change Attachment Relations for Template' => 'Verander gekoppelde bijlagen voor sjabloon',
        'Change Template Relations for Attachment' => 'Verander gekoppelde sjablonen voor bijlage',

        # Perl Module: Kernel/Modules/AdminType.pm
        'Need Type!' => 'Heb Type nodig!',
        'Type added!' => 'Type toegevoegd.',

        # Perl Module: Kernel/Modules/AdminUser.pm
        'Agent updated!' => 'Behandelaar aangepast.',

        # Perl Module: Kernel/Modules/AdminUserGroup.pm
        'Change Group Relations for Agent' => 'Bewerk gekoppelde groepen voor behandelaar',
        'Change Agent Relations for Group' => 'Bewerk gekoppelde behandelaars voor groep',

        # Perl Module: Kernel/Modules/AgentAppointmentAgendaOverview.pm
        'Month' => 'Maand',
        'Week' => 'Week',
        'Day' => 'Dag',

        # Perl Module: Kernel/Modules/AgentAppointmentCalendarOverview.pm
        'All appointments' => 'Alle afspraken',
        'Appointments assigned to me' => 'Afspraken aan mij toegewezen',
        'Showing only appointments assigned to you! Change settings' => 'Alleen afspraken zijn weergeven die aan u zijn toegewezen! Wijzig de instellingen',

        # Perl Module: Kernel/Modules/AgentAppointmentEdit.pm
        'Appointment not found!' => 'Afspraak niet gevonden!',
        'Never' => 'Nooit',
        'Every Day' => 'Elke dag',
        'Every Week' => 'Elke week',
        'Every Month' => 'Elke maand',
        'Every Year' => 'Elk jaar',
        'Custom' => '',
        'Daily' => 'Dagelijks',
        'Weekly' => 'Wekelijks',
        'Monthly' => 'Maandelijks',
        'Yearly' => 'Jaarlijks',
        'every' => 'elke',
        'for %s time(s)' => '',
        'until ...' => 'tot ...',
        'for ... time(s)' => 'voor ... keer',
        'until %s' => 'tot %s',
        'No notification' => 'Geen melding',
        '%s minute(s) before' => '%s minuut(en) voor',
        '%s hour(s) before' => '%s uur(en) voor',
        '%s day(s) before' => '%s dag(en) voor',
        '%s week before' => '%s week(en) voor',
        'before the appointment starts' => 'voordat de afspraak begint',
        'after the appointment has been started' => '',
        'before the appointment ends' => '',
        'after the appointment has been ended' => '',
        'No permission!' => '',
        'Cannot delete ticket appointment!' => '',
        'No permissions!' => '',

        # Perl Module: Kernel/Modules/AgentAppointmentList.pm
        '+%s more' => '',

        # Perl Module: Kernel/Modules/AgentCustomerSearch.pm
        'Customer History' => 'Klantgeschiedenis',

        # Perl Module: Kernel/Modules/AgentCustomerUserAddressBook.pm
        'No RecipientField is given!' => '',

        # Perl Module: Kernel/Modules/AgentDashboardCommon.pm
        'No such config for %s' => 'Geen configuratie gevonden voor %s',
        'Statistic' => 'Rapportage',
        'No preferences for %s!' => 'Geen voorkeuren voor %s',
        'Can\'t get element data of %s!' => 'Kan element gegevens van %s niet ophalen!',
        'Can\'t get filter content data of %s!' => 'Kan filter gegevens van %s niet ophalen!',
        'Customer Name' => '',
        'Customer User Name' => '',

        # Perl Module: Kernel/Modules/AgentLinkObject.pm
        'Need SourceObject and SourceKey!' => '',
        'You need ro permission!' => 'Je hebt ro rechten nodig!',
        'Can not delete link with %s!' => 'Kan relatie met %s niet verwijderen!',
        '%s Link(s) deleted successfully.' => '',
        'Can not create link with %s! Object already linked as %s.' => '',
        'Can not create link with %s!' => 'Kan relatie met %s niet aanmaken!',
        '%s links added successfully.' => '',
        'The object %s cannot link with other object!' => '',

        # Perl Module: Kernel/Modules/AgentPreferences.pm
        'Param Group is required!' => 'Parameter groep is vereist!',
        'Updated user preferences' => '',
        'System was unable to deploy your changes.' => '',
        'Setting not found!' => '',
        'System was unable to reset the setting!' => '',

        # Perl Module: Kernel/Modules/AgentSplitSelection.pm
        'Process ticket' => '',

        # Perl Module: Kernel/Modules/AgentStatistics.pm
        'Parameter %s is missing.' => '',
        'Invalid Subaction.' => 'Ongeldige subactie.',
        'Statistic could not be imported.' => 'Rapport kon niet worden geïmporteerd.',
        'Please upload a valid statistic file.' => 'Upload een geldig rapportage bestand.',
        'Export: Need StatID!' => 'Exporteren: Heb geen StatID!',
        'Delete: Get no StatID!' => 'Verwijderen: Heb geen StatID!',
        'Need StatID!' => 'Heb geen StatID!',
        'Could not load stat.' => 'Kon rapportage niet laden',
        'Add New Statistic' => 'Voeg een nieuwe statistiek toe',
        'Could not create statistic.' => 'Kon rapportage niet aanmaken.',
        'Run: Get no %s!' => 'Uitvoeren: heb geen %s!',

        # Perl Module: Kernel/Modules/AgentTicketActionCommon.pm
        'No TicketID is given!' => 'Heb geen TicketID!',
        'You need %s permissions!' => 'Je hebt %s permissies nodig!',
        'Loading draft failed!' => '',
        'Sorry, you need to be the ticket owner to perform this action.' =>
            'U moet de eigenaar zijn om deze actie uit te voeren.',
        'Please change the owner first.' => 'Verander de eigenaar eerst.',
        'FormDraft functionality disabled!' => '',
        'Draft name is required!' => '',
        'FormDraft name %s is already in use!' => '',
        'Could not perform validation on field %s!' => 'Kan validatie op veld %s niet uitvoeren!',
        'No subject' => 'Geen onderwerp',
        'Could not delete draft!' => '',
        'Previous Owner' => 'Vorige eigenaar',
        'wrote' => 'schreef',
        'Message from' => 'Bericht van',
        'End message' => 'Einde van het bericht',

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
        'The following tickets were ignored because they are locked by another agent or you don\'t have write access to tickets: %s.' =>
            '',
        'The following ticket was ignored because it is locked by another agent or you don\'t have write access to ticket: %s.' =>
            '',
        'You need to select at least one ticket.' => '',
        'Bulk feature is not enabled!' => '',
        'No selectable TicketID is given!' => '',
        'You either selected no ticket or only tickets which are locked by other agents.' =>
            '',
        'The following tickets were ignored because they are locked by another agent or you don\'t have write access to these tickets: %s.' =>
            '',
        'The following tickets were locked: %s.' => '',

        # Perl Module: Kernel/Modules/AgentTicketCompose.pm
        'Article subject will be empty if the subject contains only the ticket hook!' =>
            '',
        'Address %s replaced with registered customer address.' => 'Adres %s vervangen met vastgelegde klant-adres.',
        'Customer user automatically added in Cc.' => 'Klant automatisch toegevoegd als CC.',

        # Perl Module: Kernel/Modules/AgentTicketEmail.pm
        'Ticket "%s" created!' => 'Ticket "%s" aangemaakt.',
        'No Subaction!' => '',

        # Perl Module: Kernel/Modules/AgentTicketEmailOutbound.pm
        'Got no TicketID!' => '',
        'System Error!' => '',

        # Perl Module: Kernel/Modules/AgentTicketEmailResend.pm
        'No ArticleID is given!' => '',

        # Perl Module: Kernel/Modules/AgentTicketEscalationView.pm
        'Next week' => 'Volgende week',
        'Ticket Escalation View' => 'Ticket escalatie',

        # Perl Module: Kernel/Modules/AgentTicketForward.pm
        'Article %s could not be found!' => '',
        'Forwarded message from' => 'Doorgestuurd bericht van',
        'End forwarded message' => 'Einde doorgestuurd bericht',

        # Perl Module: Kernel/Modules/AgentTicketHistory.pm
        'Can\'t show history, no TicketID is given!' => '',

        # Perl Module: Kernel/Modules/AgentTicketLock.pm
        'Can\'t lock Ticket, no TicketID is given!' => '',
        'Sorry, the current owner is %s!' => '',
        'Please become the owner first.' => '',
        'Ticket (ID=%s) is locked by %s!' => '',
        'Change the owner!' => '',

        # Perl Module: Kernel/Modules/AgentTicketLockedView.pm
        'New Article' => 'Nieuwe interactie',
        'Pending' => 'Wachten',
        'Reminder Reached' => 'Moment van herinnering bereikt',
        'My Locked Tickets' => 'Mijn vergrendelde tickets',

        # Perl Module: Kernel/Modules/AgentTicketMerge.pm
        'Can\'t merge ticket with itself!' => 'Kan een ticket niet samenvoegen met zichzelf!',

        # Perl Module: Kernel/Modules/AgentTicketMove.pm
        'You need move permissions!' => '',

        # Perl Module: Kernel/Modules/AgentTicketPhone.pm
        'Chat is not active.' => '',
        'No permission.' => '',
        '%s has left the chat.' => '%s heeft de chat verlaten.',
        'This chat has been closed and will be removed in %s hours.' => 'Deze chat is gesloten en wordt in %s uren verwijderd.',

        # Perl Module: Kernel/Modules/AgentTicketPhoneCommon.pm
        'Ticket locked.' => 'Ticket vergrendeld.',

        # Perl Module: Kernel/Modules/AgentTicketPlain.pm
        'No ArticleID!' => '',
        'This is not an email article.' => '',
        'Can\'t read plain article! Maybe there is no plain email in backend! Read backend message.' =>
            '',

        # Perl Module: Kernel/Modules/AgentTicketPrint.pm
        'Need TicketID!' => 'Heb TicketID nodig!',

        # Perl Module: Kernel/Modules/AgentTicketProcess.pm
        'Couldn\'t get ActivityDialogEntityID "%s"!' => 'Kon ActiviteitDialoogEntiteidID "%s" niet verkrijgen!',
        'No Process configured!' => 'Geen Proces geconfigureerd!',
        'The selected process is invalid!' => 'Het geselecteerde proces is niet geldig!',
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

        # Perl Module: Kernel/Modules/AgentTicketQueue.pm
        'Available tickets' => 'Beschikbare tickets',
        'including subqueues' => 'Inclusief sub-wachtrijen',
        'excluding subqueues' => 'Exclusief sub-wachtrijen',
        'QueueView' => 'Wachtrijoverzicht',

        # Perl Module: Kernel/Modules/AgentTicketResponsibleView.pm
        'My Responsible Tickets' => 'Mijn verantwoordelijke tickets',

        # Perl Module: Kernel/Modules/AgentTicketSearch.pm
        'last-search' => 'laatste zoekopdracht',
        'Untitled' => '',
        'Ticket Number' => 'Ticketnummer',
        'Ticket' => 'Ticket',
        'printed by' => 'afgedrukt door',
        'CustomerID (complex search)' => '',
        'CustomerID (exact match)' => '',
        'Invalid Users' => 'Ongeldige gebruikers',
        'Normal' => 'Normaal',
        'CSV' => '',
        'Excel' => '',
        'in more than ...' => 'over meer dan ...',

        # Perl Module: Kernel/Modules/AgentTicketService.pm
        'Feature not enabled!' => '',
        'Service View' => 'Service View',

        # Perl Module: Kernel/Modules/AgentTicketStatusView.pm
        'Status View' => 'Statusoverzicht',

        # Perl Module: Kernel/Modules/AgentTicketWatchView.pm
        'My Watched Tickets' => 'Mijn gevolgde tickets',

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
        'SMS Added' => '',
        'SMS Added (Customer)' => '',
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
        'External Chat' => '',
        'Queue Changed' => '',
        'Notification Was Sent' => 'Melding is verstuurd.',
        'This ticket does not exist, or you don\'t have permissions to access it in its current state.' =>
            '',
        'Missing FormDraftID!' => '',
        'Can\'t get for ArticleID %s!' => '',
        'Article filter settings were saved.' => '',
        'Event type filter settings were saved.' => '',
        'Need ArticleID!' => '',
        'Invalid ArticleID!' => '',
        'Forward article via mail' => 'Stuur interactie naar een mailadres',
        'Forward' => 'Doorsturen',
        'Fields with no group' => 'Velden zonder groep',
        'Invisible only' => '',
        'Visible only' => '',
        'Visible and invisible' => '',
        'Article could not be opened! Perhaps it is on another article page?' =>
            'Het artikel kan niet worden geopend! Mogelijk staat hij op een andere artikelpagina?',
        'Show one article' => 'Toon één interactie',
        'Show all articles' => 'Toon alle interacties',
        'Show Ticket Timeline View' => 'Geef ticket tijdslijn weer',
        'Show Ticket Timeline View (%s)' => '',

        # Perl Module: Kernel/Modules/AjaxAttachment.pm
        'Got no FormID.' => '',
        'Error: the file could not be deleted properly. Please contact your administrator (missing FileID).' =>
            '',

        # Perl Module: Kernel/Modules/CustomerTicketArticleContent.pm
        'ArticleID is needed!' => '',
        'No TicketID for ArticleID (%s)!' => '',
        'HTML body attachment is missing!' => '',

        # Perl Module: Kernel/Modules/CustomerTicketAttachment.pm
        'FileID and ArticleID are needed!' => '',
        'No such attachment (%s)!' => '',

        # Perl Module: Kernel/Modules/CustomerTicketMessage.pm
        'Check SysConfig setting for %s::QueueDefault.' => '',
        'Check SysConfig setting for %s::TicketTypeDefault.' => '',
        'You don\'t have sufficient permissions for ticket creation in default queue.' =>
            '',

        # Perl Module: Kernel/Modules/CustomerTicketOverview.pm
        'Need CustomerID!' => '',
        'My Tickets' => 'Mijn tickets',
        'Company Tickets' => 'Tickets van groep',
        'Untitled!' => '',

        # Perl Module: Kernel/Modules/CustomerTicketSearch.pm
        'Customer Realname' => 'Werkelijke naam van klant',
        'Created within the last' => 'Aangemaakt in de laatste',
        'Created more than ... ago' => 'Aangemaakt langer dan ... geleden',
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
        'Install OTRS' => 'Installeer OTRS',
        'Intro' => 'Introductie',
        'Kernel/Config.pm isn\'t writable!' => '',
        'If you want to use the installer, set the Kernel/Config.pm writable for the webserver user!' =>
            '',
        'Database Selection' => 'Database-keuze',
        'Unknown Check!' => '',
        'The check "%s" doesn\'t exist!' => '',
        'Enter the password for the database user.' => 'Voer het wachtwoord voor het database-gebruikersaccount in.',
        'Database %s' => '',
        'Configure MySQL' => '',
        'Enter the password for the administrative database user.' => 'Voer het wachtwoord voor het database-gebruikersaccount in.',
        'Configure PostgreSQL' => '',
        'Configure Oracle' => '',
        'Unknown database type "%s".' => '',
        'Please go back.' => '',
        'Create Database' => 'Database aanmaken',
        'Install OTRS - Error' => '',
        'File "%s/%s.xml" not found!' => '',
        'Contact your Admin!' => '',
        'System Settings' => 'Systeemconfiguratie',
        'Syslog' => '',
        'Configure Mail' => 'Configureer mail',
        'Mail Configuration' => 'E-mailconfiguratie',
        'Can\'t write Config file!' => '',
        'Unknown Subaction %s!' => '',
        'Can\'t connect to database, Perl module DBD::%s not installed!' =>
            '',
        'Can\'t connect to database, read comment!' => '',
        'Database already contains data - it should be empty!' => 'Database bevat al data - deze moet leeg zijn!',
        'Error: Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            '',
        'Error: Please set the value for innodb_log_file_size on your database to at least %s MB (current: %s MB, recommended: %s MB). For more information, please have a look at %s.' =>
            '',
        'Wrong database collation (%s is %s, but it needs to be utf8).' =>
            '',

        # Perl Module: Kernel/Modules/PublicCalendar.pm
        'No %s!' => '',
        'No such user!' => '',
        'Invalid calendar!' => '',
        'Invalid URL!' => '',
        'There was an error exporting the calendar!' => '',

        # Perl Module: Kernel/Modules/PublicRepository.pm
        'Need config Package::RepositoryAccessRegExp' => '',
        'Authentication failed from %s!' => '',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketBounce.pm
        'Bounce Article to a different mail address' => 'Artikel terugsturen naar een ander e-mailadres',
        'Bounce' => 'Bounce',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketCompose.pm
        'Reply All' => 'Allen beantwoorden',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketEmailResend.pm
        'Resend this article' => '',
        'Resend' => '',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketMessageLog.pm
        'View message log details for this article' => '',
        'Message Log' => '',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketNote.pm
        'Reply to note' => 'Notitie beantwoorden',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketPhone.pm
        'Split this article' => 'Splits deze interactie',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketPlain.pm
        'View the source for this Article' => '',
        'Plain Format' => 'Broncode',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketPrint.pm
        'Print this article' => 'Print deze interactie',

        # Perl Module: Kernel/Output/HTML/ArticleAction/GetHelpLink.pm
        'Contact us at sales@otrs.com' => '',
        'Get Help' => '',

        # Perl Module: Kernel/Output/HTML/ArticleAction/MarkAsImportant.pm
        'Mark' => 'Markeer',
        'Unmark' => 'Verwijder markering',

        # Perl Module: Kernel/Output/HTML/ArticleAction/ReinstallPackageLink.pm
        'Upgrade to OTRS Business Solution™' => '',
        'Re-install Package' => '',
        'Upgrade' => 'Upgrade',
        'Re-install' => '',

        # Perl Module: Kernel/Output/HTML/ArticleCheck/PGP.pm
        'Crypted' => 'Versleuteld',
        'Sent message encrypted to recipient!' => '',
        'Signed' => 'Getekend',
        '"PGP SIGNED MESSAGE" header found, but invalid!' => '',

        # Perl Module: Kernel/Output/HTML/ArticleCheck/SMIME.pm
        '"S/MIME SIGNED MESSAGE" header found, but invalid!' => '',
        'Ticket decrypted before' => '',
        'Impossible to decrypt: private key for email was not found!' => '',
        'Successful decryption' => '',

        # Perl Module: Kernel/Output/HTML/ArticleCompose/Crypt.pm
        'There are no encryption keys available for the addresses: \'%s\'. ' =>
            '',
        'There are no selected encryption keys for the addresses: \'%s\'. ' =>
            '',
        'Cannot use expired encryption keys for the addresses: \'%s\'. ' =>
            '',
        'Cannot use revoked encryption keys for the addresses: \'%s\'. ' =>
            '',
        'Encrypt' => '',
        'Keys/certificates will only be shown for recipients with more than one key/certificate. The first found key/certificate will be pre-selected. Please make sure to select the correct one.' =>
            '',

        # Perl Module: Kernel/Output/HTML/ArticleCompose/Security.pm
        'Email security' => '',
        'PGP sign' => '',
        'PGP sign and encrypt' => '',
        'PGP encrypt' => '',
        'SMIME sign' => '',
        'SMIME sign and encrypt' => '',
        'SMIME encrypt' => '',

        # Perl Module: Kernel/Output/HTML/ArticleCompose/Sign.pm
        'Cannot use expired signing key: \'%s\'. ' => '',
        'Cannot use revoked signing key: \'%s\'. ' => '',
        'There are no signing keys available for the addresses \'%s\'.' =>
            '',
        'There are no selected signing keys for the addresses \'%s\'.' =>
            '',
        'Sign' => 'Teken',
        'Keys/certificates will only be shown for a sender with more than one key/certificate. The first found key/certificate will be pre-selected. Please make sure to select the correct one.' =>
            '',

        # Perl Module: Kernel/Output/HTML/Dashboard/AppointmentCalendar.pm
        'Shown' => 'Tonen',
        'Refresh (minutes)' => '',
        'off' => 'uit',

        # Perl Module: Kernel/Output/HTML/Dashboard/CustomerIDList.pm
        'Shown customer ids' => '',

        # Perl Module: Kernel/Output/HTML/Dashboard/CustomerUserList.pm
        'Shown customer users' => 'Getoonde klanten',
        'Offline' => '',
        'User is currently offline.' => '',
        'User is currently active.' => '',
        'Away' => '',
        'User was inactive for a while.' => '',

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
        'Shown Tickets' => 'Laat tickets zien',
        'Shown Columns' => 'Toon kolommen',
        'filter not active' => '',
        'filter active' => '',
        'This ticket has no title or subject' => 'Dit ticket heeft geen titel of onderwerp',

        # Perl Module: Kernel/Output/HTML/Dashboard/TicketStatsGeneric.pm
        '7 Day Stats' => 'Afgelopen 7 dagen',

        # Perl Module: Kernel/Output/HTML/Dashboard/UserOnline.pm
        'User set their status to unavailable.' => '',
        'Unavailable' => '',

        # Perl Module: Kernel/Output/HTML/Layout.pm
        'Standard' => 'Standaard',
        'The following tickets are not updated: %s.' => '',
        'h' => 'u',
        'm' => 'm',
        'd' => 'd',
        'This ticket does not exist, or you don\'t have permissions to access it in its current state. You can take one of the following actions:' =>
            '',
        'This is a' => 'Dit is een',
        'email' => 'e-mail',
        'click here' => 'klik hier',
        'to open it in a new window.' => 'om deze in een nieuw venster te openen.',
        'Year' => 'Jaar',
        'Hours' => 'Uren',
        'Minutes' => 'Minuten',
        'Check to activate this date' => 'Selecteer om deze datum te gebruiken',
        '%s TB' => '',
        '%s GB' => '',
        '%s MB' => '',
        '%s KB' => '',
        '%s B' => '',
        'No Permission!' => 'Geen toegang! Onvoldoende permissies.',
        'No Permission' => '',
        'Show Tree Selection' => 'Toon boomweergave',
        'Split Quote' => 'Splits quote',
        'Remove Quote' => 'Verwijder citaat',

        # Perl Module: Kernel/Output/HTML/Layout/LinkObject.pm
        'Linked as' => 'Gekoppeld als',
        'Search Result' => '',
        'Linked' => 'Gekoppeld',
        'Bulk' => 'Bulk',

        # Perl Module: Kernel/Output/HTML/Layout/Ticket.pm
        'Lite' => 'Light',
        'Unread article(s) available' => 'Ongelezen interactie(s) aanwezig',

        # Perl Module: Kernel/Output/HTML/LinkObject/Appointment.pm
        'Appointment' => '',

        # Perl Module: Kernel/Output/HTML/LinkObject/Ticket.pm
        'Archive search' => '',

        # Perl Module: Kernel/Output/HTML/Notification/AgentCloudServicesDisabled.pm
        'Enable cloud services to unleash all OTRS features!' => 'Schakel cloud diensten in om alle OTRS functionaliteit in te schakelen!',

        # Perl Module: Kernel/Output/HTML/Notification/AgentOTRSBusiness.pm
        '%s Upgrade to %s now! %s' => '%s upgrade naar %s nu! %s',
        'Please verify your license data!' => '',
        'The license for your %s is about to expire. Please make contact with %s to renew your contract!' =>
            'De licentie voor uw %s verloopt binnenkort. Contacteer %s om deze te hernieuwen!',
        'An update for your %s is available, but there is a conflict with your framework version! Please update your framework first!' =>
            'Er is een update beschikbaar voor uw %s, maar er is een probleem met de versie van uw framework! Gelieve eerst uw framework te updaten!',

        # Perl Module: Kernel/Output/HTML/Notification/AgentOnline.pm
        'Online Agent: %s' => 'Online behandelaars: %s',

        # Perl Module: Kernel/Output/HTML/Notification/AgentTicketEscalation.pm
        'There are more escalated tickets!' => 'Er zijn nog meer geëscaleerde tickets.',

        # Perl Module: Kernel/Output/HTML/Notification/AgentTimeZoneCheck.pm
        'Please select a time zone in your preferences and confirm it by clicking the save button.' =>
            '',

        # Perl Module: Kernel/Output/HTML/Notification/CustomerOnline.pm
        'Online Customer: %s' => 'Online klanten: %s',

        # Perl Module: Kernel/Output/HTML/Notification/CustomerSystemMaintenanceCheck.pm
        'System maintenance is active!' => '',
        'A system maintenance period will start at: %s and is expected to stop at: %s' =>
            '',

        # Perl Module: Kernel/Output/HTML/Notification/DaemonCheck.pm
        'OTRS Daemon is not running.' => 'OTRS Daemon is niet actief.',

        # Perl Module: Kernel/Output/HTML/Notification/OutofOfficeCheck.pm
        'You have Out of Office enabled, would you like to disable it?' =>
            'U staat geregistreerd als afwezig. Wilt u dit aanpassen?',

        # Perl Module: Kernel/Output/HTML/Notification/PackageManagerCheckNotVerifiedPackages.pm
        'The installation of packages which are not verified by the OTRS Group is activated. These packages could threaten your whole system! It is recommended not to use unverified packages.' =>
            '',

        # Perl Module: Kernel/Output/HTML/Notification/SystemConfigurationInvalidCheck.pm
        'You have %s invalid setting(s) deployed. Click here to show invalid settings.' =>
            '',

        # Perl Module: Kernel/Output/HTML/Notification/SystemConfigurationIsDirtyCheck.pm
        'You have undeployed settings, would you like to deploy them?' =>
            '',

        # Perl Module: Kernel/Output/HTML/Notification/SystemConfigurationOutOfSyncCheck.pm
        'The configuration is being updated, please be patient...' => '',
        'There is an error updating the system configuration!' => '',

        # Perl Module: Kernel/Output/HTML/Notification/UIDCheck.pm
        'Don\'t use the Superuser account to work with %s! Create new Agents and work with these accounts instead.' =>
            '',

        # Perl Module: Kernel/Output/HTML/Preferences/AppointmentNotificationEvent.pm
        'Please make sure you\'ve chosen at least one transport method for mandatory notifications.' =>
            'Zorg ervoor dat je minimaal één transportmethode hebt gekozen voor verplichtte notificaties.',
        'Preferences updated successfully!' => 'Uw voorkeuren zijn gewijzigd.',

        # Perl Module: Kernel/Output/HTML/Preferences/Language.pm
        '(in process)' => '',

        # Perl Module: Kernel/Output/HTML/Preferences/OutOfOffice.pm
        'Please specify an end date that is after the start date.' => 'Geef een einddatum op die na de startdatum ligt.',

        # Perl Module: Kernel/Output/HTML/Preferences/Password.pm
        'Current password' => 'Huidig wachtwoord',
        'New password' => 'Nieuw wachtwoord',
        'Verify password' => 'Herhaal wachtwoord',
        'The current password is not correct. Please try again!' => 'Het ingegeven wachtwoord klopt niet. Probeer het opnieuw.',
        'Please supply your new password!' => 'Geef je nieuwe wachtwoord op.',
        'Can\'t update password, your new passwords do not match. Please try again!' =>
            'Kan het wachtwoord niet bijwerken, de wachtwoorden komen niet overeen.',
        'This password is forbidden by the current system configuration. Please contact the administrator if you have additional questions.' =>
            '',
        'Can\'t update password, it must be at least %s characters long!' =>
            'Kan het wachtwoord niet bijwerken, het moet minstens %s tekens lang zijn.',
        'Can\'t update password, it must contain at least 2 lowercase and 2 uppercase letter characters!' =>
            '',
        'Can\'t update password, it must contain at least 1 digit!' => 'Kan het wachtwoord niet bijwerken, het moet minstens 1 cijfer bevatten.',
        'Can\'t update password, it must contain at least 2 letter characters!' =>
            '',

        # Perl Module: Kernel/Output/HTML/Preferences/TimeZone.pm
        'Time zone updated successfully!' => '',

        # Perl Module: Kernel/Output/HTML/Statistics/View.pm
        'invalid' => 'ongeldig',
        'valid' => 'geldig',
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
        'second(s)' => 'seconden',
        'quarter(s)' => 'kwarta(a)l(en)',
        'half-year(s)' => 'halve-jaren',
        'Please remove the following words because they cannot be used for the ticket restrictions: %s.' =>
            'Verwijder de volgende woorden omdat ze niet gebruikt kunnen worden om tickets te beperken: %s',

        # Perl Module: Kernel/Output/HTML/SysConfig.pm
        'Cancel editing and unlock this setting' => '',
        'Reset this setting to its default value.' => '',
        'Unable to load %s!' => '',
        'Content' => 'Inhoud',

        # Perl Module: Kernel/Output/HTML/TicketMenu/Lock.pm
        'Unlock to give it back to the queue' => 'Ontgrendelen om dit ticket vrij te geven',
        'Lock it to work on it' => 'Vergrendel dit ticket',

        # Perl Module: Kernel/Output/HTML/TicketMenu/TicketWatcher.pm
        'Unwatch' => 'Stop met volgen',
        'Remove from list of watched tickets' => 'Verwijder van lijst met gevolgde tickets',
        'Watch' => 'Volg',
        'Add to list of watched tickets' => 'Voeg toe aan lijst met gevolgde tickets',

        # Perl Module: Kernel/Output/HTML/TicketOverviewMenu/Sort.pm
        'Order by' => 'Sorteren op',

        # Perl Module: Kernel/Output/HTML/TicketZoom/TicketInformation.pm
        'Ticket Information' => 'Ticket-informatie',

        # Perl Module: Kernel/Output/HTML/ToolBar/TicketLocked.pm
        'Locked Tickets New' => 'Nieuwe vergrendelde tickets',
        'Locked Tickets Reminder Reached' => 'Vergrendelde tickets herinnering bereikt',
        'Locked Tickets Total' => 'Totaal aantal vergrendelde tickets',

        # Perl Module: Kernel/Output/HTML/ToolBar/TicketResponsible.pm
        'Responsible Tickets New' => 'Nieuwe tickets verantwoordelijk',
        'Responsible Tickets Reminder Reached' => 'Tickets verantwoordelijk herinnering bereikt',
        'Responsible Tickets Total' => 'Totaal aantal tickets verantwoordelijk',

        # Perl Module: Kernel/Output/HTML/ToolBar/TicketWatcher.pm
        'Watched Tickets New' => 'Nieuwe gevolgde tickets',
        'Watched Tickets Reminder Reached' => 'Gevolgde tickets herinnering bereikt',
        'Watched Tickets Total' => 'Totaal gevolgde tickets',

        # Perl Module: Kernel/Output/PDF/Ticket.pm
        'Ticket Dynamic Fields' => 'Ticket Dynamische Velden',

        # Perl Module: Kernel/System/ACL/DB/ACL.pm
        'Couldn\'t read ACL configuration file. Please make sure the file is valid.' =>
            '',

        # Perl Module: Kernel/System/Auth.pm
        'It is currently not possible to login due to a scheduled system maintenance.' =>
            'Het is momenteel niet mogelijk om in te loggen omwille van een gepland systeemonderhoud.',

        # Perl Module: Kernel/System/AuthSession.pm
        'You have exceeded the number of concurrent agents - contact sales@otrs.com.' =>
            '',
        'Please note that the session limit is almost reached.' => '',
        'Login rejected! You have exceeded the maximum number of concurrent Agents! Contact sales@otrs.com immediately!' =>
            '',
        'Session limit reached! Please try again later.' => 'Sessie-limiet bereikt. Probeert u later opnieuw in te loggen.',
        'Session per user limit reached!' => '',

        # Perl Module: Kernel/System/AuthSession/DB.pm
        'Session invalid. Please log in again.' => 'Uw sessie is ongeldig. Meldt u opnieuw aan.',
        'Session has timed out. Please log in again.' => 'Uw sessie is verlopen. Meldt u opnieuw aan.',

        # Perl Module: Kernel/System/Calendar/Event/Transport/Email.pm
        'PGP sign only' => '',
        'PGP encrypt only' => '',
        'SMIME sign only' => '',
        'SMIME encrypt only' => '',
        'PGP and SMIME not enabled.' => '',
        'Skip notification delivery' => 'Sla het afleveren van de melding over',
        'Send unsigned notification' => 'Stuur een niet-ondertekende melding',
        'Send unencrypted notification' => 'Stuur een niet-gecodeerde melding',

        # Perl Module: Kernel/System/Console/Command/Dev/Tools/Config2Docbook.pm
        'Configuration Options Reference' => 'Configuratie opties verwijzing',
        'This setting can not be changed.' => 'Deze instelling kan niet worden aangepast.',
        'This setting is not active by default.' => 'Deze instelling is standaard niet ingeschakeld.',
        'This setting can not be deactivated.' => 'Deze instelling kan niet worden uitgeschakeld.',
        'This setting is not visible.' => '',
        'This setting can be overridden in the user preferences.' => '',
        'This setting can be overridden in the user preferences, but is not active by default.' =>
            '',

        # Perl Module: Kernel/System/CustomerUser.pm
        'Customer user "%s" already exists.' => '',

        # Perl Module: Kernel/System/CustomerUser/DB.pm
        'This email address is already in use for another customer user.' =>
            '',

        # Perl Module: Kernel/System/DynamicField/Driver/BaseDateTime.pm
        'before/after' => 'voor/na',
        'between' => 'tussen',

        # Perl Module: Kernel/System/DynamicField/Driver/BaseText.pm
        'e.g. Text or Te*t' => '',

        # Perl Module: Kernel/System/DynamicField/Driver/Checkbox.pm
        'Ignore this field.' => '',

        # Perl Module: Kernel/System/DynamicField/Driver/TextArea.pm
        'This field is required or' => 'Dit veld is verplicht of ',
        'The field content is too long!' => 'De inhoud van het veld is te lang!',
        'Maximum size is %s characters.' => 'De maximumlengte bedraagt %s karakters.',

        # Perl Module: Kernel/System/NotificationEvent.pm
        'Couldn\'t read Notification configuration file. Please make sure the file is valid.' =>
            'Niet is staat om het meldingen configuratie bestand te lezen. Zorg ervoor dat het bestand geldig is.',
        'Imported notification has body text with more than 4000 characters.' =>
            'Geïmporteerde melding is een tekst die meer dan 400 karakters bevat.',

        # Perl Module: Kernel/System/Package.pm
        'not installed' => '',
        'installed' => 'geïnstalleerd',
        'Unable to parse repository index document.' => 'Kan repository index document niet verwerken.',
        'No packages for your framework version found in this repository, it only contains packages for other framework versions.' =>
            'Geen pakketten gevonden in deze repository voor de huidige framework versie. De repository bevaty alleen pakketten voor andere framework versies.',
        'File is not installed!' => '',
        'File is different!' => '',
        'Can\'t read file!' => '',
        '<p>If you continue to install this package, the following issues may occur:</p><ul><li>Security problems</li><li>Stability problems</li><li>Performance problems</li></ul><p>Please note that issues that are caused by working with this package are not covered by OTRS service contracts.</p>' =>
            '',
        '<p>The installation of packages which are not verified by the OTRS Group is not possible by default. You can activate the installation of not verified packages via the "AllowNotVerifiedPackages" system configuration setting.</p>' =>
            '',

        # Perl Module: Kernel/System/ProcessManagement/DB/Process.pm
        'The process "%s" and all of its data has been imported successfully.' =>
            '',

        # Perl Module: Kernel/System/ProcessManagement/DB/Process/State.pm
        'Inactive' => 'Inactief',
        'FadeAway' => '',

        # Perl Module: Kernel/System/Registration.pm
        'Can\'t contact registration server. Please try again later.' => 'Kan registratieserver niet bereiken. Probeer het later nogmaals.',
        'No content received from registration server. Please try again later.' =>
            'Geen data ontvangen van registratieserver. Probeer het later nogmaals.',
        'Can\'t get Token from sever' => '',
        'Username and password do not match. Please try again.' => 'Gebruikersnaam en wachtwoord komen niet overeen.',
        'Problems processing server result. Please try again later.' => 'Problemen met het verwerken van data van registratieserver. Probeer het later nogmaals.',

        # Perl Module: Kernel/System/Stats.pm
        'Sum' => 'Totaal',
        'week' => 'week',
        'quarter' => 'kwartaal',
        'half-year' => 'half-jaar',

        # Perl Module: Kernel/System/Stats/Dynamic/Ticket.pm
        'State Type' => 'Status type',
        'Created Priority' => 'Aangemaakt met prioriteit',
        'Created State' => 'Aangemaakt met status',
        'Create Time' => 'Aangemaakt op',
        'Pending until time' => '',
        'Close Time' => 'Afsluitingstijd',
        'Escalation' => 'Escalatie',
        'Escalation - First Response Time' => 'Escalatie - eerste reactietijd',
        'Escalation - Update Time' => 'Escalatie - tijd van bijwerken',
        'Escalation - Solution Time' => 'Escalatie - tijd van oplossen',
        'Agent/Owner' => 'Behandelaar/eigenaar',
        'Created by Agent/Owner' => 'Aangemaakt door behandelaar/eigenaar',
        'Assigned to Customer User Login' => '',

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
        'Attributes to be printed' => 'Attributen om af te drukken',
        'Sort sequence' => 'Sorteervolgorde',
        'State Historic' => 'Historische status',
        'State Type Historic' => 'Historische status type',
        'Historic Time Range' => 'Historische tijdsvenster',
        'Number' => 'Nummer',
        'Last Changed' => '',

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

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/OutdatedTables.pm
        'Outdated Tables' => '',
        'Outdated tables were found in the database. These can be removed if empty.' =>
            '',

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
        'This character set is not yet supported, please see https://bugs.otrs.org/show_bug.cgi?id=12361. Please convert your database to the character set \'utf8\'.' =>
            '',
        'The setting character_set_database needs to be \'utf8\'.' => '',
        'Table Charset' => 'Tabel Karacterset',
        'There were tables found which do not have \'utf8\' as charset.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/InnoDBLogFileSize.pm
        'InnoDB Log File Size' => 'InnoDB Log bestandsgrootte',
        'The setting innodb_log_file_size must be at least 256 MB.' => 'De instelling innodb_log_file_size meot minimaal 256MB zijn',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/InvalidDefaultValues.pm
        'Invalid Default Values' => '',
        'Tables with invalid default values were found. In order to fix it automatically, please run: bin/otrs.Console.pl Maint::Database::Check --repair' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/MaxAllowedPacket.pm
        'Maximum Query Size' => 'Maximale Query Lengte',
        'The setting \'max_allowed_packet\' must be higher than 64 MB.' =>
            '',

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

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/oracle/PrimaryKeySequencesAndTriggers.pm
        'Primary Key Sequences and Triggers' => '',
        'The following sequences and/or triggers with possible wrong names have been found. Please rename them manually.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/Charset.pm
        'Setting client_encoding needs to be UNICODE or UTF8.' => 'Instelling client_encoding moet UNICODE of UTF8 zijn',
        'Setting server_encoding needs to be UNICODE or UTF8.' => 'Instelling server_encoding moet UNICODE of UTF8 zijn',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/DateStyle.pm
        'Date Format' => 'Datum Format',
        'Setting DateStyle needs to be ISO.' => 'Instelling DateStyle moet ISO zijn',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/PrimaryKeySequences.pm
        'Primary Key Sequences' => '',
        'The following sequences with possible wrong names have been found. Please rename them manually.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/Version.pm
        'PostgreSQL 9.2 or higher is required.' => '',

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
        'Could not determine kernel version.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Load.pm
        'System Load' => 'Systeem Belasting',
        'The system load should be at maximum the number of CPUs the system has (e.g. a load of 8 or less on a system with 8 CPUs is OK).' =>
            'De systeem belasting zou niet meer moeten zijn dan het aantal CPUs dat het systeem heeft (een belasting van 8 of minder voor een systeem met 8 CPU\'s).',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/PerlModules.pm
        'Perl Modules' => 'Perl Modules',
        'Not all required Perl modules are correctly installed.' => 'Niet alle vereiste Perl modules zijn correct geïnstalleerd',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/PerlModulesAudit.pm
        'Perl Modules Audit' => '',
        'CPAN::Audit reported that one or more installed Perl modules have known vulnerabilities. Please note that there might be false positives for distributions patching Perl modules without changing their version number.' =>
            '',
        'CPAN::Audit did not report any known vulnerabilities in the installed Perl modules.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Swap.pm
        'Free Swap Space (%)' => 'Vrije Swap ruimte (%)',
        'No swap enabled.' => 'Geen swap ingeschakeld.',
        'Used Swap Space (MB)' => 'Gebruikte Swap ruimte (MB)',
        'There should be more than 60% free swap space.' => 'Er zou meer dan 60% vrije swap ruimte moeten zijn.',
        'There should be no more than 200 MB swap space used.' => 'Er zou niet meer dan 200MB swap ruimte in gebruik moeten zijn.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/ArticleSearchIndexStatus.pm
        'OTRS' => 'OTRS',
        'Article Search Index Status' => '',
        'Indexed Articles' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/ArticlesPerCommunicationChannel.pm
        'Articles Per Communication Channel' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/CommunicationLog.pm
        'Incoming communications' => '',
        'Outgoing communications' => '',
        'Failed communications' => '',
        'Average processing time of communications (s)' => 'Gemiddelde verwerkingstijd van de verbinding(en)',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/CommunicationLogAccountStatus.pm
        'Communication Log Account Status (last 24 hours)' => '',
        'No connections found.' => '',
        'ok' => '',
        'permanent connection errors' => '',
        'intermittent connection errors' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/ConfigSettings.pm
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
        'Open Tickets' => 'Open tickets',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/DefaultSOAPUser.pm
        'Default SOAP Username And Password' => 'Standaard SOAP gebruikersnaam en wachtwoord',
        'Security risk: you use the default setting for SOAP::User and SOAP::Password. Please change it.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/DefaultUser.pm
        'Default Admin Password' => 'Standaard Admin Wachtwoord',
        'Security risk: the agent account root@localhost still has the default password. Please change it or invalidate the account.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/EmailQueue.pm
        'Email Sending Queue' => '',
        'Emails queued for sending' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/FQDN.pm
        'FQDN (domain name)' => 'FQDN (Domeinnaam)',
        'Please configure your FQDN setting.' => 'Configureer de FQDN instelling.',
        'Domain Name' => 'Domeinnaam',
        'Your FQDN setting is invalid.' => 'De FQDN instelling is ongeldig.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/FileSystemWritable.pm
        'File System Writable' => 'Bestandsysteem beschrijfbaar',
        'The file system on your OTRS partition is not writable.' => 'Het bestandsysteem op de OTRS partitie is niet schrijfbaar.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/LegacyConfigBackups.pm
        'Legacy Configuration Backups' => '',
        'No legacy configuration backup files found.' => '',
        'Legacy configuration backup files found in Kernel/Config/Backups folder, but they might still be required by some packages.' =>
            '',
        'Legacy configuration backup files are no longer needed for the installed packages, please remove them from Kernel/Config/Backups folder.' =>
            '',

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
            'Je zou niet meer dan 8.000 openstaande tickets in uw systeem moeten hebben.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/SearchIndexModule.pm
        'Ticket Search Index Module' => 'Ticket Zoek Indexering Module',
        'The indexing process forces the storage of the original article text in the article search index, without executing filters or applying stop word lists. This will increase the size of the search index and thus may slow down fulltext searches.' =>
            '',

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
        'OTRS time zone' => '',
        'OTRS time zone is not set.' => '',
        'User default time zone' => '',
        'User default time zone is not set.' => '',
        'Calendar time zone is not set.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/UI/AgentSkinUsage.pm
        'UI - Agent Skin Usage' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/UI/AgentThemeUsage.pm
        'UI - Agent Theme Usage' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/UI/SpecialStats.pm
        'UI - Special Statistics' => '',
        'Agents using custom main menu ordering' => '',
        'Agents using favourites for the admin overview' => '',

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
        'OK' => 'OK',
        'Problem' => 'Probleem',

        # Perl Module: Kernel/System/SysConfig.pm
        'Setting %s does not exists!' => '',
        'Setting %s is not locked to this user!' => '',
        'Setting value is not valid!' => '',
        'Could not add modified setting!' => '',
        'Could not update modified setting!' => '',
        'Setting could not be unlocked!' => '',
        'Missing key %s!' => '',
        'Invalid setting: %s' => '',
        'Could not combine settings values into a perl hash.' => '',
        'Can not lock the deployment for UserID \'%s\'!' => '',
        'All Settings' => '',

        # Perl Module: Kernel/System/SysConfig/BaseValueType.pm
        'Default' => '',
        'Value is not correct! Please, consider updating this field.' => '',
        'Value doesn\'t satisfy regex (%s).' => '',

        # Perl Module: Kernel/System/SysConfig/ValueType/Checkbox.pm
        'Enabled' => '',
        'Disabled' => '',

        # Perl Module: Kernel/System/SysConfig/ValueType/Date.pm
        'System was not able to calculate user Date in OTRSTimeZone!' => '',

        # Perl Module: Kernel/System/SysConfig/ValueType/DateTime.pm
        'System was not able to calculate user DateTime in OTRSTimeZone!' =>
            '',

        # Perl Module: Kernel/System/SysConfig/ValueType/FrontendNavigation.pm
        'Value is not correct! Please, consider updating this module.' =>
            '',

        # Perl Module: Kernel/System/SysConfig/ValueType/VacationDays.pm
        'Value is not correct! Please, consider updating this setting.' =>
            '',

        # Perl Module: Kernel/System/Ticket.pm
        'Reset of unlock time.' => '',

        # Perl Module: Kernel/System/Ticket/Article/Backend/Chat.pm
        'Chat Participant' => '',
        'Chat Message Text' => '',

        # Perl Module: Kernel/System/Web/InterfaceAgent.pm
        'Login failed! Your user name or password was entered incorrectly.' =>
            'Inloggen mislukt. Uw gebruikersnaam of wachtwoord is niet correct.',
        'Authentication succeeded, but no user data record is found in the database. Please contact the administrator.' =>
            '',
        'Can`t remove SessionID.' => '',
        'Logout successful.' => 'Afmelden gelukt.',
        'Feature not active!' => 'Deze functie is niet actief.',
        'Sent password reset instructions. Please check your email.' => 'Wachtwoord reset instructies zijn verstuurd. Controleer uw e-mail.',
        'Invalid Token!' => 'Fout token!',
        'Sent new password to %s. Please check your email.' => 'Nieuw wachtwoord gestuurd aan %s. Controleer uw e-mail.',
        'Error: invalid session.' => '',
        'No Permission to use this frontend module!' => '',

        # Perl Module: Kernel/System/Web/InterfaceCustomer.pm
        'Authentication succeeded, but no customer record is found in the customer backend. Please contact the administrator.' =>
            '',
        'Reset password unsuccessful. Please contact the administrator.' =>
            '',
        'This e-mail address already exists. Please log in or reset your password.' =>
            'Dit e-mail adres bestaat reeds. Gelieve in te loggen of uw wachtwoord te resetten.',
        'This email address is not allowed to register. Please contact support staff.' =>
            'Het is niet toegestaan om u met dit e-mailadres te registreren. Gelieve contact op te nemen met de Support afdeling.',
        'Added via Customer Panel (%s)' => '',
        'Customer user can\'t be added!' => '',
        'Can\'t send account info!' => '',
        'New account created. Sent login information to %s. Please check your email.' =>
            'Nieuw account aangemaakt. Login informatie gestuurd aan %s. Controleer uw e-mail.',

        # Perl Module: Kernel/System/Web/InterfaceInstaller.pm
        'Action "%s" not found!' => '',

        # Database XML Definition: scripts/database/otrs-initial_insert.xml
        'invalid-temporarily' => 'tijdelijk ongeldig',
        'Group for default access.' => 'Groep voor standaard toegang.',
        'Group of all administrators.' => 'Groep voor alle administrators.',
        'Group for statistics access.' => 'Groep voor statistieken toegang.',
        'new' => 'nieuw',
        'All new state types (default: viewable).' => 'Alle nieuwe status types (standaard: zichtbaar)',
        'open' => 'open',
        'All open state types (default: viewable).' => 'Alle open status types (standaard: zichtbaar)',
        'closed' => 'gesloten',
        'All closed state types (default: not viewable).' => 'Alle gesloten status types (standaard: niet zichtbaar).',
        'pending reminder' => 'wachtend op een herinnering',
        'All \'pending reminder\' state types (default: viewable).' => 'Alle \'wacht op reminder\' status types (standaard: zichtbaar)',
        'pending auto' => 'wachtend',
        'All \'pending auto *\' state types (default: viewable).' => 'Alle \'wacht op automatisch *\' status types (standaard: zichtbaar).',
        'removed' => 'verwijderd',
        'All \'removed\' state types (default: not viewable).' => 'Alle \'verwijderd\' status types (standaard: niet zichtbaar).',
        'merged' => 'samengevoegd',
        'State type for merged tickets (default: not viewable).' => 'Status type voor samengevoegde tickets (standaard: niet zichtbaar).',
        'New ticket created by customer.' => 'Niet ticket aangemaakt door klant.',
        'closed successful' => 'succesvol gesloten',
        'Ticket is closed successful.' => 'Ticket is succesvol gesloten.',
        'closed unsuccessful' => 'niet succesvol gesloten',
        'Ticket is closed unsuccessful.' => 'Ticket is niet succesvol gesloten.',
        'Open tickets.' => 'Openstaande tickets.',
        'Customer removed ticket.' => 'Klant heeft ticket verwijderd.',
        'Ticket is pending for agent reminder.' => 'Ticket wacht op reminder voor agent.',
        'pending auto close+' => 'wachtend op automatisch succesvol sluiten',
        'Ticket is pending for automatic close.' => 'Ticket wacht op automatisch sluiten.',
        'pending auto close-' => 'wachtend op automatisch niet succesvol sluiten',
        'State for merged tickets.' => 'Status voor samengevoegde tickets.',
        'system standard salutation (en)' => 'Systeem standaard aanhef (en)',
        'Standard Salutation.' => 'Standaard Aanhef',
        'system standard signature (en)' => 'sandaard ondertekening (engels)',
        'Standard Signature.' => 'Standaard ondertekening',
        'Standard Address.' => 'Standaard Adres.',
        'possible' => 'mogelijk',
        'Follow-ups for closed tickets are possible. Ticket will be reopened.' =>
            'Follow-ups voor gesloten ticket zijn mogelijk. Tickets worden heropend.',
        'reject' => 'afwijzen',
        'Follow-ups for closed tickets are not possible. No new ticket will be created.' =>
            'Follow-ups voor gesloten tickets zijn niet mogelijk. Er wordt geen nieuw ticket aangemaakt.',
        'new ticket' => 'nieuw ticket',
        'Follow-ups for closed tickets are not possible. A new ticket will be created.' =>
            '',
        'Postmaster queue.' => 'Postmaster wachtrij.',
        'All default incoming tickets.' => 'Alle standaard binnenkomende tickets',
        'All junk tickets.' => 'Alle span tickets.',
        'All misc tickets.' => 'Alle diverse tickets.',
        'auto reply' => 'automatisch antwoorden',
        'Automatic reply which will be sent out after a new ticket has been created.' =>
            'Automatisch antwoord welke wordt verstuurd wanneer een nieuw ticket is aangemaakt.',
        'auto reject' => 'automatisch weigeren',
        'Automatic reject which will be sent out after a follow-up has been rejected (in case queue follow-up option is "reject").' =>
            'Automatisch antwoord welke wordt verzonden wanneer een follow-up wordt geweigerd (wanneer een follow-up wordt geweigerd).',
        'auto follow up' => 'automatisch opvolgen',
        'Automatic confirmation which is sent out after a follow-up has been received for a ticket (in case queue follow-up option is "possible").' =>
            'Automatische bevestiging die wordt verstuurd nadat een folluw-up is ontvangen voor een ticket (wanner een follow-up mogelijk is).',
        'auto reply/new ticket' => 'automatisch antwoord/nieuw ticket',
        'Automatic response which will be sent out after a follow-up has been rejected and a new ticket has been created (in case queue follow-up option is "new ticket").' =>
            'Automatisch antwoord welke wordt verstoord nadat een follow-up is afgewezen en een nieuw ticket is aangemaakt (voor het geval dat een follow-up een nieuw ticket is).',
        'auto remove' => 'automatisch verwijderen',
        'Auto remove will be sent out after a customer removed the request.' =>
            'Automatisch verwijderen wordt verstuud wanneer een klant het verzoek heeft verwijderd.',
        'default reply (after new ticket has been created)' => 'standaard antwoord (wanneer een nieuw ticket is aangemaakt)',
        'default reject (after follow-up and rejected of a closed ticket)' =>
            'standaard afwijzing (na follow-up en afwijzing van een gesloten ticket)',
        'default follow-up (after a ticket follow-up has been added)' => 'standaard follow-up (wanneer een ticket follow-up is toegevoegd)',
        'default reject/new ticket created (after closed follow-up with new ticket creation)' =>
            'standaard afwijzing/nieuw ticket aangemaakt (na een gesloten follow up en nieuw ticket is aangemaakt)',
        'Unclassified' => 'niet geclassificeerd',
        '1 very low' => '1 zeer laag',
        '2 low' => '2 laag',
        '3 normal' => '3 normaal',
        '4 high' => '4 hoog',
        '5 very high' => '5 zeer hoog',
        'unlock' => 'niet vergrendeld',
        'lock' => 'vergrendeld',
        'tmp_lock' => 'tijdelijk_lock',
        'agent' => 'behandelaar',
        'system' => 'systeem',
        'customer' => 'klant',
        'Ticket create notification' => 'Melding bij het aanmaken van een ticket',
        'You will receive a notification each time a new ticket is created in one of your "My Queues" or "My Services".' =>
            'U ontvangt een melding telkens wanneer een nieuw ticket wordt aangemaakt in een van uw "Mijn wachtrijen" of "Mijn diensten".',
        'Ticket follow-up notification (unlocked)' => 'Melding bij een nieuwe reactie op een ticket (niet vergrendeld)',
        'You will receive a notification if a customer sends a follow-up to an unlocked ticket which is in your "My Queues" or "My Services".' =>
            'U ontvangt een melding als een klant een reactie stuurt naar een ontgrendeld ticket dat zich in uw "Mijn wachtrijen" of "Mijn diensten" bevindt',
        'Ticket follow-up notification (locked)' => 'Melding bij een nieuwe reactie op een ticket (vergrendeld)',
        'You will receive a notification if a customer sends a follow-up to a locked ticket of which you are the ticket owner or responsible.' =>
            'U ontvangt een melding als een klant een reactie stuurt naar een vergrendeld ticket dat zich in uw "Mijn wachtrijen" of "Mijn diensten" bevindt',
        'Ticket lock timeout notification' => 'Melding bij tijdsoverschrijding van een vergrendeld ticket',
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
        'Ticket escalation notification' => 'Ticket escalatie melding',
        'Ticket escalation warning notification' => 'Ticket escalatie waarschuwing notificatie',
        'Ticket service update notification' => 'Ticket service update melding',
        'You will receive a notification if a ticket\'s service is changed to one of your "My Services".' =>
            'U ontvangt een melding als de service van een ticket is gewijzigd in een van uw \'Mijn services\'.',
        'Appointment reminder notification' => '',
        'You will receive a notification each time a reminder time is reached for one of your appointments.' =>
            '',
        'Ticket email delivery failure notification' => 'Foutmelding bij het versturen van de e-mail over dit ticket',

        # JS File: Core.AJAX
        'Error during AJAX communication. Status: %s, Error: %s' => '',
        'This window must be called from compose window.' => '',

        # JS File: Core.Agent.Admin.ACL
        'Add all' => 'Alles toevoegen',
        'An item with this name is already present.' => 'Er bestaat al een item met deze naam.',
        'This item still contains sub items. Are you sure you want to remove this item including its sub items?' =>
            'Dit item bevat sub-items. Weet u zeker dat u dit item inclusief subitems wilt verwijderen?',

        # JS File: Core.Agent.Admin.AppointmentCalendar.Manage
        'More' => '',
        'Less' => '',
        'Press Ctrl+C (Cmd+C) to copy to clipboard' => '',

        # JS File: Core.Agent.Admin.Attachment
        'Delete this Attachment' => '',
        'Deleting attachment...' => '',
        'There was an error deleting the attachment. Please check the logs for more information.' =>
            '',
        'Attachment was deleted successfully.' => '',

        # JS File: Core.Agent.Admin.DynamicField
        'Do you really want to delete this dynamic field? ALL associated data will be LOST!' =>
            'Wilt u dit veld definitief verwijderen? Alle data in dit veld wordt ook verwijderd!',
        'Delete field' => 'Verwijder veld',
        'Deleting the field and its data. This may take a while...' => 'Dit veld en al zijn data word verwijderd. Dit kan even duren....',

        # JS File: Core.Agent.Admin.GenericAgent
        'Remove this dynamic field' => '',
        'Remove selection' => 'Selectie verwijderen',
        'Do you really want to delete this generic agent job?' => '',
        'Delete this Event Trigger' => 'Verwijder deze event trigger.',
        'Duplicate event.' => 'Dupliceer event.',
        'This event is already attached to the job, Please use a different one.' =>
            'Dit event is al gekoppeld aan deze taak. Kies een andere.',

        # JS File: Core.Agent.Admin.GenericInterfaceDebugger
        'An error occurred during communication.' => 'Er is een fout opgetreden tijdens de communicatie.',
        'Request Details' => 'Details verzoek',
        'Request Details for Communication ID' => '',
        'Show or hide the content.' => 'Toon of verberg de inhoud.',
        'Clear debug log' => 'Leeg debug-log.',

        # JS File: Core.Agent.Admin.GenericInterfaceErrorHandling
        'Delete error handling module' => '',

        # JS File: Core.Agent.Admin.GenericInterfaceInvoker
        'It is not possible to add a new event trigger because the event is not set.' =>
            '',
        'Delete this Invoker' => 'Verwijder deze invoker',

        # JS File: Core.Agent.Admin.GenericInterfaceInvokerEvent
        'Sorry, the only existing condition can\'t be removed.' => '',
        'Sorry, the only existing field can\'t be removed.' => '',
        'Delete conditions' => '',

        # JS File: Core.Agent.Admin.GenericInterfaceMapping
        'Mapping for Key %s' => '',
        'Mapping for Key' => '',
        'Delete this Key Mapping' => 'Verwijder sleutelkoppeling',

        # JS File: Core.Agent.Admin.GenericInterfaceOperation
        'Delete this Operation' => 'Verwijder deze operatie',

        # JS File: Core.Agent.Admin.GenericInterfaceWebservice
        'Clone web service' => 'Kloon webservice',
        'Delete operation' => 'Verwijder operatie',
        'Delete invoker' => 'Verwijder invoker',

        # JS File: Core.Agent.Admin.Group
        'WARNING: When you change the name of the group \'admin\', before making the appropriate changes in the SysConfig, you will be locked out of the administrations panel! If this happens, please rename the group back to admin per SQL statement.' =>
            'WAARSCHUWING: Als u de naam van de groep \'admin\'aanpast voordat u de bijbehorende wijzigingen in de Systeemconfiguratie heeft aangebracht, zult u geen beheer-permissies meer hebben in OTRS. Als dit gebeurt, moet u de naam van de groep aanpassen met een SQL statement.',

        # JS File: Core.Agent.Admin.MailAccount
        'Delete this Mail Account' => '',
        'Deleting the mail account and its data. This may take a while...' =>
            '',

        # JS File: Core.Agent.Admin.NotificationEvent
        'Do you really want to delete this notification language?' => 'Weet u zeker dat u de taal van deze melding wilt verwijderen?',
        'Do you really want to delete this notification?' => 'Wenst u deze melding te verwijderen?',

        # JS File: Core.Agent.Admin.PGP
        'Do you really want to delete this key?' => '',

        # JS File: Core.Agent.Admin.PackageManager
        'There is a package upgrade process running, click here to see status information about the upgrade progress.' =>
            '',
        'A package upgrade was recently finished. Click here to see the results.' =>
            '',
        'No response from get package upgrade result.' => '',
        'Update all packages' => '',
        'Dismiss' => '',
        'Update All Packages' => '',
        'No response from package upgrade all.' => '',
        'Currently not possible' => '',
        'This is currently disabled because of an ongoing package upgrade.' =>
            '',
        'This option is currently disabled because the OTRS Daemon is not running.' =>
            '',
        'Are you sure you want to update all installed packages?' => '',
        'No response from get package upgrade run status.' => '',

        # JS File: Core.Agent.Admin.PostMasterFilter
        'Delete this PostMasterFilter' => '',
        'Deleting the postmaster filter and its data. This may take a while...' =>
            '',

        # JS File: Core.Agent.Admin.ProcessManagement.Canvas
        'Remove Entity from canvas' => 'Verwijder van canvas',
        'No TransitionActions assigned.' => 'Geen transitie-acties toegewezen.',
        'No dialogs assigned yet. Just pick an activity dialog from the list on the left and drag it here.' =>
            'Er zijn nog geen dialogen toegewezen. Kies een dialoog uit de lijst en sleep deze hiernaartoe.',
        'This Activity cannot be deleted because it is the Start Activity.' =>
            'Deze activiteit kan niet worden verwijderd omdat het de start-activiteit is.',
        'Remove the Transition from this Process' => 'Verwijder deze transitie uit dit proces',

        # JS File: Core.Agent.Admin.ProcessManagement
        'As soon as you use this button or link, you will leave this screen and its current state will be saved automatically. Do you want to continue?' =>
            'Als u deze knop of link gebruikt, verlaat u dit scherm en de huidige staat wordt automatisch opgeslagen. Wilt u doorgaan?',
        'Delete Entity' => 'Verwijderen',
        'This Activity is already used in the Process. You cannot add it twice!' =>
            'Deze activiteit wordt al gebruikt in dit proces. U kunt het niet tweemaal gebruiken.',
        'Error during AJAX communication' => '',
        'An unconnected transition is already placed on the canvas. Please connect this transition first before placing another transition.' =>
            'Een niet-verbonden transitie is al op de canvas geplaatst. Verbindt deze transitie alvorens een nieuwe transitie te plaatsen.',
        'This Transition is already used for this Activity. You cannot use it twice!' =>
            'Deze transitie wordt al gebruikt in deze activiteit. U kunt het niet tweemaal gebruiken.',
        'This TransitionAction is already used in this Path. You cannot use it twice!' =>
            'Deze transitie-actie wordt al gebruikt in dit pad. U kunt het niet tweemaal gebruiken.',
        'Hide EntityIDs' => 'Verberg ID\'s',
        'Edit Field Details' => 'Bewerk veld-details',
        'Customer interface does not support articles not visible for customers.' =>
            '',
        'Sorry, the only existing parameter can\'t be removed.' => '',

        # JS File: Core.Agent.Admin.SMIME
        'Do you really want to delete this certificate?' => '',

        # JS File: Core.Agent.Admin.SupportDataCollector
        'Sending Update...' => 'Update versturen...',
        'Support Data information was successfully sent.' => 'Support Data is succesvol verstuurd',
        'Was not possible to send Support Data information.' => 'Het was niet mogelijk om Support Data te versturen.',
        'Update Result' => 'Update Resultaat',
        'Generating...' => 'Genereren...',
        'It was not possible to generate the Support Bundle.' => 'Het was niet mogelijk om de Support Bundel te genereren',
        'Generate Result' => 'Genereer Resultaat',
        'Support Bundle' => 'Support Bundel',
        'The mail could not be sent' => 'De mail kon niet verzonden woden.',

        # JS File: Core.Agent.Admin.SysConfig.Entity
        'It is not possible to set this entry to invalid. All affected configuration settings have to be changed beforehand.' =>
            '',
        'Cannot proceed' => '',
        'Update manually' => '',
        'You can either have the affected settings updated automatically to reflect the changes you just made or do it on your own by pressing \'update manually\'.' =>
            '',
        'Save and update automatically' => '',
        'Don\'t save, update manually' => '',
        'The item you\'re currently viewing is part of a not-yet-deployed configuration setting, which makes it impossible to edit it in its current state. Please wait until the setting has been deployed. If you\'re unsure what to do next, please contact your system administrator.' =>
            '',

        # JS File: Core.Agent.Admin.SystemConfiguration
        'Loading...' => 'Bezig met laden...',
        'Search the System Configuration' => '',
        'Please enter at least one search word to find anything.' => '',
        'Unfortunately deploying is currently not possible, maybe because another agent is already deploying. Please try again later.' =>
            '',
        'Deploy' => '',
        'The deployment is already running.' => '',
        'Deployment successful. You\'re being redirected...' => '',
        'There was an error. Please save all settings you are editing and check the logs for more information.' =>
            '',
        'Reset option is required!' => '',
        'By restoring this deployment all settings will be reverted to the value they had at the time of the deployment. Do you really want to continue?' =>
            '',
        'Keys with values can\'t be renamed. Please remove this key/value pair instead and re-add it afterwards.' =>
            '',
        'Unlock setting.' => '',

        # JS File: Core.Agent.Admin.SystemMaintenance
        'Do you really want to delete this scheduled system maintenance?' =>
            'Weet je zeker dat u dit systeemonderhoud wilt verwijderen?',

        # JS File: Core.Agent.Admin.Template
        'Delete this Template' => '',
        'Deleting the template and its data. This may take a while...' =>
            '',

        # JS File: Core.Agent.AppointmentCalendar
        'Jump' => '',
        'Timeline Month' => '',
        'Timeline Week' => '',
        'Timeline Day' => '',
        'Previous' => 'Vorige',
        'Resources' => '',
        'Su' => 'zo',
        'Mo' => 'ma',
        'Tu' => 'di',
        'We' => 'wo',
        'Th' => 'do',
        'Fr' => 'vr',
        'Sa' => 'za',
        'This is a repeating appointment' => '',
        'Would you like to edit just this occurrence or all occurrences?' =>
            '',
        'All occurrences' => '',
        'Just this occurrence' => '',
        'Too many active calendars' => '',
        'Please either turn some off first or increase the limit in configuration.' =>
            '',
        'Restore default settings' => '',
        'Are you sure you want to delete this appointment? This operation cannot be undone.' =>
            '',

        # JS File: Core.Agent.CustomerSearch
        'First select a customer user, then select a customer ID to assign to this ticket.' =>
            '',
        'Duplicated entry' => 'Dubbel adres',
        'It is going to be deleted from the field, please try again.' => 'Het wordt verwijderd van dit veld, probeer opnieuw.',

        # JS File: Core.Agent.CustomerUserAddressBook
        'Please enter at least one search value or * to find anything.' =>
            'Geef één of meerdere tekens of een wildcard als * op om een zoekopdracht uit te voeren.',

        # JS File: Core.Agent.Daemon
        'Information about the OTRS Daemon' => 'Informatie over de OTRS Daemon',

        # JS File: Core.Agent.Dashboard
        'Please check the fields marked as red for valid inputs.' => 'Bekijk de waarden in de als rood gemarkeerde velden.',
        'month' => 'maand',
        'Remove active filters for this widget.' => 'Verwijder actieve filters voor dit widget.',

        # JS File: Core.Agent.LinkObject.SearchForm
        'Please wait...' => '',
        'Searching for linkable objects. This may take a while...' => '',

        # JS File: Core.Agent.LinkObject
        'Do you really want to delete this link?' => '',

        # JS File: Core.Agent.Login
        'Are you using a browser plugin like AdBlock or AdBlockPlus? This can cause several issues and we highly recommend you to add an exception for this domain.' =>
            '',
        'Do not show this warning again.' => '',

        # JS File: Core.Agent.Preferences
        'Sorry, but you can\'t disable all methods for notifications marked as mandatory.' =>
            'Helaas, maar je kun niet alle methoden voor notificatie markeren als verplicht.',
        'Sorry, but you can\'t disable all methods for this notification.' =>
            'Helaas is het niet mogelijk om alle methodes voor deze notificatie uit te zetten.',
        'Please note that at least one of the settings you have changed requires a page reload. Click here to reload the current screen.' =>
            '',
        'An unknown error occurred. Please contact the administrator.' =>
            '',

        # JS File: Core.Agent.Responsive
        'Switch to desktop mode' => 'Omschakelen naar desktop weergave',

        # JS File: Core.Agent.Search
        'Please remove the following words from your search as they cannot be searched for:' =>
            'Verwijder de volgende woorden van je zoekactie omdat daar niet op gezocht kan worden:',

        # JS File: Core.Agent.SharedSecretGenerator
        'Generate' => '',

        # JS File: Core.Agent.SortedTree
        'This element has children elements and can currently not be removed.' =>
            '',

        # JS File: Core.Agent.Statistics
        'Do you really want to delete this statistic?' => 'Weet u zeker dat u deze rapportage wilt verwijderen?',

        # JS File: Core.Agent.TicketAction
        'Select a customer ID to assign to this ticket' => '',
        'Do you really want to continue?' => 'Weet je zeker dat je door wil gaan?',

        # JS File: Core.Agent.TicketBulk
        ' ...and %s more' => '',
        ' ...show less' => '',

        # JS File: Core.Agent.TicketFormDraft
        'Add new draft' => '',
        'Delete draft' => '',
        'There are no more drafts available.' => '',
        'It was not possible to delete this draft.' => '',

        # JS File: Core.Agent.TicketZoom
        'Article filter' => 'Filter interacties',
        'Apply' => 'Toepassen',
        'Event Type Filter' => 'Gebeurtenis type filter',

        # JS File: Core.Agent
        'Slide the navigation bar' => 'Schuif de navigaiebalk',
        'Please turn off Compatibility Mode in Internet Explorer!' => 'Zet a.u.b. Compatibility Mode in Internet Explorer uit!',
        'Find out more' => '',

        # JS File: Core.App.Responsive
        'Switch to mobile mode' => 'Omschakelen naar weergave voor telefoons / tablets',

        # JS File: Core.App
        'Error: Browser Check failed!' => '',
        'Reload page' => '',
        'Reload page (%ss)' => '',

        # JS File: Core.Debug
        'Namespace %s could not be initialized, because %s could not be found.' =>
            '',

        # JS File: Core.Exception
        'An error occurred! Please check the browser error log for more details!' =>
            '',

        # JS File: Core.Form.Validate
        'One or more errors occurred!' => 'Een of meerdere problemen zijn opgetreden.',

        # JS File: Core.Installer
        'Mail check successful.' => 'Mail controle gelukt.',
        'Error in the mail settings. Please correct and try again.' => 'Fout in de mailinstellingen. Corrigeer ze en probeer nog eens.',

        # JS File: Core.SystemConfiguration
        'Open this node in a new window' => '',
        'Please add values for all keys before saving the setting.' => '',
        'The key must not be empty.' => '',
        'A key with this name (\'%s\') already exists.' => '',
        'Do you really want to revert this setting to its historical value?' =>
            '',

        # JS File: Core.UI.Datepicker
        'Open date selection' => 'Open datumkiezer',
        'Invalid date (need a future date)!' => 'Ongeldig (datum kan niet in verleden zijn).',
        'Invalid date (need a past date)!' => 'Ongeldige datum (heb een datum in het verleden nodig!)',

        # JS File: Core.UI.InputFields
        'Not available' => 'Niet beschikbaar',
        'and %s more...' => 'en nog %s meer...',
        'Show current selection' => '',
        'Current selection' => '',
        'Clear all' => 'Alles weghalen',
        'Filters' => 'Filters',
        'Clear search' => 'Verwijder zoekactie',

        # JS File: Core.UI.Popup
        'If you now leave this page, all open popup windows will be closed, too!' =>
            'Als u deze pagina verlaat worden alle openstaande popup-vensters ook gesloten.',
        'A popup of this screen is already open. Do you want to close it and load this one instead?' =>
            'Er is al een popup open voor dit ticket. Wilt u deze sluiten en de nieuwe laden?',
        'Could not open popup window. Please disable any popup blockers for this application.' =>
            'Kan geen popup openen. Schakel popup blockers uit voor deze website.',

        # JS File: Core.UI.Table.Sort
        'Ascending sort applied, ' => '',
        'Descending sort applied, ' => '',
        'No sort applied, ' => '',
        'sorting is disabled' => '',
        'activate to apply an ascending sort' => '',
        'activate to apply a descending sort' => '',
        'activate to remove the sort' => '',

        # JS File: Core.UI.Table
        'Remove the filter' => '',

        # JS File: Core.UI.TreeSelection
        'There are currently no elements available to select from.' => 'Er zijn nu geen elementen beschikbaar om te kiezen.',

        # JS File: Core.UI
        'Please only select one file for upload.' => '',
        'Sorry, you can only upload one file here.' => '',
        'Sorry, you can only upload %s files.' => '',
        'Please only select at most %s files for upload.' => '',
        'The following files are not allowed to be uploaded: %s' => '',
        'The following files exceed the maximum allowed size per file of %s and were not uploaded: %s' =>
            '',
        'The following files were already uploaded and have not been uploaded again: %s' =>
            '',
        'No space left for the following files: %s' => '',
        'Available space %s of %s.' => '',
        'Upload information' => '',
        'An unknown error occurred when deleting the attachment. Please try again. If the error persists, please contact your system administrator.' =>
            '',

        # JS File: Core.Language.UnitTest
        'yes' => 'ja',
        'no' => 'nee',
        'This is %s' => '',
        'Complex %s with %s arguments' => '',

        # JS File: OTRSLineChart
        'No Data Available.' => '',

        # JS File: OTRSMultiBarChart
        'Grouped' => 'Gegroepeerd',
        'Stacked' => 'Gestapeld',

        # JS File: OTRSStackedAreaChart
        'Stream' => 'Stream',
        'Expanded' => 'Uitgebreid',

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
in uw onderwerp, dus deze e-mail kan niet worden verwerkt.

Maak een nieuw ticket aan via het klant portaal.

Bedankt voor uw belangstelling.

Het Helpdesk Team
',
        ' (work units)' => ' (werk eenheden)',
        ' 2 minutes' => ' 2 minuten',
        ' 5 minutes' => ' 5 minuten',
        ' 7 minutes' => ' 7 minuten',
        '"Slim" skin which tries to save screen space for power users.' =>
            '',
        '%s' => '%s',
        '(UserLogin) Firstname Lastname' => '(Loginnaam) Voornaam Achternaam',
        '(UserLogin) Lastname Firstname' => '(Loginnaam) Achternaam Voornaam',
        '(UserLogin) Lastname, Firstname' => '(Loginnaam) Achternaam, Voornaam',
        '*** out of office until %s (%s d left) ***' => '',
        '0 - Disabled' => '',
        '1 - Available' => '',
        '1 - Enabled' => '',
        '10 Minutes' => '',
        '100 (Expert)' => '',
        '15 Minutes' => '',
        '2 - Enabled and required' => '',
        '2 - Enabled and shown by default' => '',
        '2 - Enabled by default' => '',
        '2 Minutes' => '',
        '200 (Advanced)' => '',
        '30 Minutes' => '',
        '300 (Beginner)' => '',
        '5 Minutes' => '',
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
        'Activates support for customer and customer user groups.' => '',
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
        'Add a note to this ticket' => 'Voeg een notitie toe aan dit ticket',
        'Add an inbound phone call to this ticket' => 'Voeg een binnenkomend telefoongesprek toe aan dit ticket.',
        'Add an outbound phone call to this ticket' => 'Voeg een uitgaand telefoongesprek toe aan dit ticket.',
        'Added %s time unit(s), for a total of %s time unit(s).' => '',
        'Added email. %s' => 'E-mail toegevoegd. %s',
        'Added follow-up to ticket [%s]. %s' => '',
        'Added link to ticket "%s".' => 'Koppeling naar "%s" toegevoegd.',
        'Added note (%s).' => '',
        'Added phone call from customer.' => '',
        'Added phone call to customer.' => '',
        'Added subscription for user "%s".' => 'Added subscription for user "%s".',
        'Added system request (%s).' => '',
        'Added web request from customer.' => '',
        'Adds a suffix with the actual year and month to the OTRS log file. A logfile for every month will be created.' =>
            'Voegt een achtervoegsel met het eigenlijke jaar en maand toe aan het OTRS logbestand. Er wordt een logbestand gemaakt voor elke maand.',
        'Adds customers email addresses to recipients in the ticket compose screen of the agent interface. The customers email address won\'t be added if the article type is email-internal.' =>
            'Voeg klant e-mail adressen toe aan de ontvangers in het ticket maak scherm van de agent interface. De adressen worden niet toegevoegd wanneer het artikel van het type email-internal is.',
        'Adds the one time vacation days for the indicated calendar.' => '',
        'Adds the one time vacation days.' => '',
        'Adds the permanent vacation days for the indicated calendar.' =>
            '',
        'Adds the permanent vacation days.' => '',
        'Admin' => 'Beheer',
        'Admin Area.' => '',
        'Admin Notification' => 'Melding van de beheerder',
        'Admin area navigation for the agent interface.' => '',
        'Admin modules overview.' => '',
        'Admin.' => '',
        'Administration' => 'Administratie',
        'Agent Customer Search' => '',
        'Agent Customer Search.' => '',
        'Agent Name' => '',
        'Agent Name + FromSeparator + System Address Display Name' => '',
        'Agent Preferences.' => '',
        'Agent Statistics.' => '',
        'Agent User Search' => '',
        'Agent User Search.' => '',
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
        'AgentTicketZoom widget that displays a table of objects linked to the ticket.' =>
            '',
        'AgentTicketZoom widget that displays customer information for the ticket in the side bar.' =>
            '',
        'AgentTicketZoom widget that displays ticket data in the side bar.' =>
            '',
        'Agents ↔ Groups' => '',
        'Agents ↔ Roles' => 'Behandelaars ↔ Rollen',
        'All CustomerIDs of a customer user.' => '',
        'All attachments (OTRS Business Solution™)' => '',
        'All customer users of a CustomerID' => 'Alle klanten accounts van een CustomerID',
        'All escalated tickets' => 'Alle geëscaleerde tickets',
        'All new tickets, these tickets have not been worked on yet' => 'Alle nieuwe tickets. Aan deze tickets is nog niet gewerkt',
        'All open tickets, these tickets have already been worked on.' =>
            'Alle open tickets. Aan deze tickets is al gewerkt.',
        'All tickets with a reminder set where the reminder date has been reached' =>
            'Alle tickets met een herinnering waarbij het herinnermoment is bereikt',
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
        'Allows customers to set the ticket queue in the customer interface. If this is not enabled, QueueDefault should be configured.' =>
            '',
        'Allows customers to set the ticket service in the customer interface.' =>
            'Staat klanten toe om de ticket service te kiezen in de klant weergave.',
        'Allows customers to set the ticket type in the customer interface. If this is not enabled, TicketTypeDefault should be configured.' =>
            '',
        'Allows default services to be selected also for non existing customers.' =>
            'Staat toe om standaard services te selecteren voor niet bestaande klanten.',
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
        'Allows to save current work as draft in the close ticket screen of the agent interface.' =>
            '',
        'Allows to save current work as draft in the email outbound screen of the agent interface.' =>
            '',
        'Allows to save current work as draft in the ticket compose screen of the agent interface.' =>
            '',
        'Allows to save current work as draft in the ticket forward screen of the agent interface.' =>
            '',
        'Allows to save current work as draft in the ticket free text screen of the agent interface.' =>
            '',
        'Allows to save current work as draft in the ticket move screen of the agent interface.' =>
            '',
        'Allows to save current work as draft in the ticket note screen of the agent interface.' =>
            '',
        'Allows to save current work as draft in the ticket owner screen of the agent interface.' =>
            '',
        'Allows to save current work as draft in the ticket pending screen of the agent interface.' =>
            '',
        'Allows to save current work as draft in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Allows to save current work as draft in the ticket phone outbound screen of the agent interface.' =>
            '',
        'Allows to save current work as draft in the ticket priority screen of the agent interface.' =>
            '',
        'Allows to save current work as draft in the ticket responsible screen of the agent interface.' =>
            '',
        'Allows to set a new ticket state in the move ticket screen of the agent interface.' =>
            '',
        'Always show RichText if available' => '',
        'Answer' => 'Antwoord',
        'Appointment Calendar overview page.' => '',
        'Appointment Notifications' => '',
        'Appointment calendar event module that prepares notification entries for appointments.' =>
            '',
        'Appointment calendar event module that updates the ticket with data from ticket appointment.' =>
            '',
        'Appointment edit screen.' => '',
        'Appointment list' => '',
        'Appointment list.' => '',
        'Appointment notifications' => '',
        'Appointments' => '',
        'Arabic (Saudi Arabia)' => 'Arabisch (Saudi Arabië)',
        'ArticleTree' => 'Interactie-boom',
        'Attachment Name' => 'Bijlage naam',
        'Automated line break in text messages after x number of chars.' =>
            '',
        'Automatically change the state of a ticket with an invalid owner once it is unlocked. Maps from a state type to a new ticket state.' =>
            '',
        'Automatically lock and set owner to current Agent after opening the move ticket screen of the agent interface.' =>
            '',
        'Automatically lock and set owner to current Agent after selecting for an Bulk Action.' =>
            '',
        'Automatically sets the owner of a ticket as the responsible for it (if ticket responsible feature is enabled). This will only work by manually actions of the logged in user. It does not work for automated actions e.g. GenericAgent, Postmaster and GenericInterface.' =>
            '',
        'Automatically sets the responsible of a ticket (if it is not set yet) after the first owner update.' =>
            '',
        'Avatar' => '',
        'Balanced white skin by Felix Niklas (slim version).' => '',
        'Balanced white skin by Felix Niklas.' => '',
        'Based on global RichText setting' => '',
        'Basic fulltext index settings. Execute "bin/otrs.Console.pl Maint::Ticket::FulltextIndex --rebuild" in order to generate a new index.' =>
            '',
        'Blocks all the incoming emails that do not have a valid ticket number in subject with From: @example.com address.' =>
            '',
        'Bounced to "%s".' => 'Gebounced naar "%s".',
        'Bulgarian' => '',
        'Bulk Action' => 'Bulk actie',
        'CMD example setup. Ignores emails where external CMD returns some output on STDOUT (email will be piped into STDIN of some.bin).' =>
            '',
        'CSV Separator' => 'CSV scheidingsteken',
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
        'Calendar manage screen.' => '',
        'Catalan' => '',
        'Change password' => 'Wachtwoord wijzigen',
        'Change queue!' => 'Verander wachtrij.',
        'Change the customer for this ticket' => 'Wijzig de klant voor dit ticket',
        'Change the free fields for this ticket' => 'Wijzig de vrije velden voor dit ticket',
        'Change the owner for this ticket' => 'Wijzig de eigenaar van dit ticket',
        'Change the priority for this ticket' => 'Wijzig de prioriteit voor dit ticket',
        'Change the responsible for this ticket' => '',
        'Change your avatar image.' => 'Pas uw avatar afbeelding aan.',
        'Change your password and more.' => '',
        'Changed SLA to "%s" (%s).' => '',
        'Changed archive state to "%s".' => '',
        'Changed customer to "%s".' => '',
        'Changed dynamic field %s from "%s" to "%s".' => '',
        'Changed owner to "%s" (%s).' => '',
        'Changed pending time to "%s".' => '',
        'Changed priority from "%s" (%s) to "%s" (%s).' => 'Prioriteit gewijzigd van "%s" (%s) naar "%s" (%s).',
        'Changed queue to "%s" (%s) from "%s" (%s).' => '',
        'Changed responsible to "%s" (%s).' => '',
        'Changed service to "%s" (%s).' => '',
        'Changed state from "%s" to "%s".' => '',
        'Changed title from "%s" to "%s".' => '',
        'Changed type from "%s" (%s) to "%s" (%s).' => '',
        'Changes the owner of tickets to everyone (useful for ASP). Normally only agent with rw permissions in the queue of the ticket will be shown.' =>
            '',
        'Chat communication channel.' => '',
        'Checkbox' => 'Checkbox',
        'Checks for articles that needs to be updated in the article search index.' =>
            '',
        'Checks for communication log entries to be deleted.' => '',
        'Checks for queued outgoing emails to be sent.' => '',
        'Checks if an E-Mail is a followup to an existing ticket by searching the subject for a valid ticket number.' =>
            '',
        'Checks if an email is a follow-up to an existing ticket with external ticket number which can be found by ExternalTicketNumberRecognition filter module.' =>
            '',
        'Checks the SystemID in ticket number detection for follow-ups. If not enabled, SystemID will be changed after using the system.' =>
            '',
        'Checks the availability of OTRS Business Solution™ for this system.' =>
            '',
        'Checks the entitlement status of OTRS Business Solution™.' => '',
        'Child' => 'zoon',
        'Chinese (Simplified)' => 'Chinees (Vereenvoudigd)',
        'Chinese (Traditional)' => 'Chinees (Traditioneel)',
        'Choose for which kind of appointment changes you want to receive notifications.' =>
            '',
        'Choose for which kind of ticket changes you want to receive notifications. Please note that you can\'t completely disable notifications marked as mandatory.' =>
            '',
        'Choose which notifications you\'d like to receive.' => '',
        'Christmas Eve' => 'Kerstavond',
        'Close' => 'Sluiten',
        'Close this ticket' => 'Sluit dit ticket',
        'Closed tickets (customer user)' => 'Gesloten tickets (klant gebruiker)',
        'Closed tickets (customer)' => 'Gesloten tickets (klant)',
        'Cloud Services' => 'Cloud Diensten',
        'Cloud service admin module registration for the transport layer.' =>
            '',
        'Collect support data for asynchronous plug-in modules.' => '',
        'Column ticket filters for Ticket Overviews type "Small".' => '',
        'Columns that can be filtered in the escalation view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '',
        'Columns that can be filtered in the locked view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '',
        'Columns that can be filtered in the queue view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '',
        'Columns that can be filtered in the responsible view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '',
        'Columns that can be filtered in the service view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '',
        'Columns that can be filtered in the status view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '',
        'Columns that can be filtered in the ticket search result view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '',
        'Columns that can be filtered in the watch view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '',
        'Comment for new history entries in the customer interface.' => '',
        'Comment2' => 'Comment2',
        'Communication' => 'Communicatie',
        'Communication & Notifications' => '',
        'Communication Log GUI' => '',
        'Communication log limit per page for Communication Log Overview.' =>
            '',
        'CommunicationLog Overview Limit' => '',
        'Company Status' => 'Klantstatus',
        'Company Tickets.' => 'Bedrijf tickets.',
        'Company name which will be included in outgoing emails as an X-Header.' =>
            '',
        'Compat module for AgentZoom to AgentTicketZoom.' => '',
        'Complex' => '',
        'Compose' => 'Maken',
        'Configure Processes.' => 'Beheer processen',
        'Configure and manage ACLs.' => 'Beheer ACLs.',
        'Configure any additional readonly mirror databases that you want to use.' =>
            '',
        'Configure sending of support data to OTRS Group for improved support.' =>
            '',
        'Configure which screen should be shown after a new ticket has been created.' =>
            '',
        'Configure your own log text for PGP.' => '',
        'Configures a default TicketDynamicField setting. "Name" defines the dynamic field which should be used, "Value" is the data that will be set, and "Event" defines the trigger event. Please check the developer manual (https://doc.otrs.com/doc/), chapter "Ticket Event Module".' =>
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
        'Controls if the autocomplete field will be used for the customer ID selection in the AdminCustomerUser interface.' =>
            '',
        'Controls if the ticket and article seen flags are removed when a ticket is archived.' =>
            '',
        'Converts HTML mails into text messages.' => '',
        'Create New process ticket.' => '',
        'Create Ticket' => '',
        'Create a new calendar appointment linked to this ticket' => '',
        'Create and manage Service Level Agreements (SLAs).' => 'Aanmaken en beheren van Service Level Agreements (SLA\'s).',
        'Create and manage agents.' => 'Aanmaken en beheren van behandelaars.',
        'Create and manage appointment notifications.' => '',
        'Create and manage attachments.' => 'Aanmaken en beheren van bijlagen.',
        'Create and manage calendars.' => '',
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
        'Create new appointment.' => '',
        'Create new email ticket and send this out (outbound).' => '',
        'Create new email ticket.' => 'Maak een nieuw e-mail ticket.',
        'Create new phone ticket (inbound).' => 'Maak een nieuw intern telefoon ticket.',
        'Create new phone ticket.' => 'Maak een nieuw telefoon ticket.',
        'Create new process ticket.' => '',
        'Create tickets.' => 'Maak nieuwe ticket.',
        'Created ticket [%s] in "%s" with priority "%s" and state "%s".' =>
            '',
        'Croatian' => '',
        'Custom RSS Feed' => '',
        'Custom RSS feed.' => '',
        'Custom text for the page shown to customers that have no tickets yet (if you need those text translated add them to a custom translation module).' =>
            '',
        'Customer Administration' => 'Beheer klanten',
        'Customer Companies' => 'Bedrijven',
        'Customer IDs' => '',
        'Customer Information Center Search.' => '',
        'Customer Information Center search.' => '',
        'Customer Information Center.' => '',
        'Customer Ticket Print Module.' => '',
        'Customer User Administration' => 'Beheer klant gebruikers',
        'Customer User Information' => '',
        'Customer User Information Center Search.' => 'Zoeken in klant gebruikersinformatie.',
        'Customer User Information Center search.' => 'Zoeken in klant gebruikersinformatie.',
        'Customer User Information Center.' => 'Klant gebruiker informatie overzicht.',
        'Customer Users ↔ Customers' => 'Klanten ↔ Bedrijven',
        'Customer Users ↔ Groups' => 'Klanten ↔ Groepen',
        'Customer Users ↔ Services' => 'Klanten ↔ Services',
        'Customer item (icon) which shows the closed tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            '',
        'Customer item (icon) which shows the open tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            '',
        'Customer preferences.' => '',
        'Customer ticket overview' => 'Klant ticket overview',
        'Customer ticket search.' => '',
        'Customer ticket zoom' => '',
        'Customer user search' => '',
        'CustomerID search' => '',
        'CustomerName' => '',
        'CustomerUser' => '',
        'Customers ↔ Groups' => 'Bedrijven ↔ Groepen',
        'Customizable stop words for fulltext index. These words will be removed from the search index.' =>
            '',
        'Czech' => '',
        'Danish' => 'Deens',
        'Dashboard overview.' => '',
        'Data used to export the search result in CSV format.' => '',
        'Date / Time' => 'Datum / tijd',
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
        'Define a mapping between variables of the customer user data (keys) and dynamic fields of a ticket (values). The purpose is to store customer user data in ticket dynamic fields. The dynamic fields must be present in the system and should be enabled for AgentTicketFreeText, so that they can be set/updated manually by the agent. They mustn\'t be enabled for AgentTicketPhone, AgentTicketEmail and AgentTicketCustomer. If they were, they would have precedence over the automatically set values. To use this mapping, you have to also activate the Ticket::EventModulePost###4100-DynamicFieldFromCustomerUser setting.' =>
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
        'Define which avatar default image should be used for the article view if no gravatar is assigned to the mail address. Check https://gravatar.com/site/implement/images/ for further information.' =>
            '',
        'Define which avatar default image should be used for the current agent if no gravatar is assigned to the mail address of the agent. Check https://gravatar.com/site/implement/images/ for further information.' =>
            '',
        'Define which avatar engine should be used for the agent avatar on the header and the sender images in AgentTicketZoom. If \'None\' is selected, initials will be displayed instead. Please note that selecting anything other than \'None\' will transfer the encrypted email address of the particular user to an external service.' =>
            '',
        'Define which columns are shown in the linked appointment widget (LinkObject::ViewMode = "complex"). Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.' =>
            '',
        'Define which columns are shown in the linked tickets widget (LinkObject::ViewMode = "complex"). Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            '',
        'Defines a customer item, which generates a LinkedIn icon at the end of a customer info block.' =>
            '',
        'Defines a customer item, which generates a XING icon at the end of a customer info block.' =>
            '',
        'Defines a customer item, which generates a google icon at the end of a customer info block.' =>
            '',
        'Defines a customer item, which generates a google maps icon at the end of a customer info block.' =>
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
        'Defines a permission context for customer to group assignment.' =>
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
        'Defines an icon with link to the google map page of the current location in appointment edit screen.' =>
            '',
        'Defines an overview module to show the address book view of a customer user list.' =>
            '',
        'Defines available article actions for Chat articles.' => '',
        'Defines available article actions for Email articles.' => '',
        'Defines available article actions for Internal articles.' => '',
        'Defines available article actions for Phone articles.' => '',
        'Defines available article actions for invalid articles.' => '',
        'Defines available groups for the admin overview screen.' => '',
        'Defines chat communication channel.' => '',
        'Defines default headers for outgoing emails.' => '',
        'Defines email communication channel.' => '',
        'Defines from which ticket attributes the agent can select the result order.' =>
            '',
        'Defines groups for preferences items.' => '',
        'Defines how many deployments the system should keep.' => '',
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
        'Defines if a ticket lock is required in the email resend screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
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
        'Defines if customers should be allowed to login if they have no shared secret stored in their preferences and therefore are not using two-factor authentication.' =>
            'Bepaalt of klanten zouden kunnen inloggen als ze geen gedeeld sleutel hebben opgeslagen in hun voorkeuren en daarmee geen gebruik maken van twee stappen authenticatie.',
        'Defines if the communication between this system and OTRS Group servers that provide cloud services is possible. If set to \'Disable cloud services\', some functionality will be lost such as system registration, support data sending, upgrading to and use of OTRS Business Solution™, OTRS Verify™, OTRS News and product News dashboard widgets, among others.' =>
            '',
        'Defines if the enhanced mode should be used (enables use of table, replace, subscript, superscript, paste from word, etc.) in customer interface.' =>
            '',
        'Defines if the enhanced mode should be used (enables use of table, replace, subscript, superscript, paste from word, etc.).' =>
            '',
        'Defines if the first article should be displayed as expanded, that is visible for the related customer. If nothing defined, latest article will be expanded.' =>
            '',
        'Defines if the message in the email outbound screen of the agent interface is visible for the customer by default.' =>
            '',
        'Defines if the message in the email resend screen of the agent interface is visible for the customer by default.' =>
            '',
        'Defines if the message in the ticket compose screen of the agent interface is visible for the customer by default.' =>
            '',
        'Defines if the message in the ticket forward screen of the agent interface is visible for the customer by default.' =>
            '',
        'Defines if the note in the close ticket screen of the agent interface is visible for the customer by default.' =>
            '',
        'Defines if the note in the ticket bulk screen of the agent interface is visible for the customer by default.' =>
            '',
        'Defines if the note in the ticket free text screen of the agent interface is visible for the customer by default.' =>
            '',
        'Defines if the note in the ticket note screen of the agent interface is visible for the customer by default.' =>
            '',
        'Defines if the note in the ticket owner screen of the agent interface is visible for the customer by default.' =>
            '',
        'Defines if the note in the ticket pending screen of the agent interface is visible for the customer by default.' =>
            '',
        'Defines if the note in the ticket priority screen of the agent interface is visible for the customer by default.' =>
            '',
        'Defines if the note in the ticket responsible screen of the agent interface is visible for the customer by default.' =>
            '',
        'Defines if the previously valid token should be accepted for authentication. This is slightly less secure but gives users 30 seconds more time to enter their one-time password.' =>
            '',
        'Defines if the values for filters should be retrieved from all available tickets. If enabled, only values which are actually used in any ticket will be available for filtering. Please note: The list of customers will always be retrieved like this.' =>
            '',
        'Defines if time accounting is mandatory in the agent interface. If enabled, a note must be entered for all ticket actions (no matter if the note itself is configured as active or is originally mandatory for the individual ticket action screen).' =>
            '',
        'Defines if time accounting must be set to all tickets in bulk action.' =>
            '',
        'Defines internal communication channel.' => '',
        'Defines out of office message template. Two string parameters (%s) available: end date and number of days left.' =>
            '',
        'Defines phone communication channel.' => '',
        'Defines queues that\'s tickets are used for displaying as calendar events.' =>
            '',
        'Defines the HTTP hostname for the support data collection with the public module \'PublicSupportDataCollector\' (e.g. used from the OTRS Daemon).' =>
            '',
        'Defines the IP regular expression for accessing the local repository. You need to enable this to have access to your local repository and the package::RepositoryList is required on the remote host.' =>
            '',
        'Defines the PostMaster header to be used on the filter for keeping the current state of the ticket.' =>
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
        'Defines the available steps in time selections. Select "Minute" to be able to select all minutes of one hour from 1-59. Select "30 Minutes" to only make full and half hours available.' =>
            '',
        'Defines the body text for notification mails sent to agents, about new password.' =>
            '',
        'Defines the body text for notification mails sent to agents, with token about new requested password.' =>
            '',
        'Defines the body text for notification mails sent to customers, about new account.' =>
            '',
        'Defines the body text for notification mails sent to customers, about new password.' =>
            '',
        'Defines the body text for notification mails sent to customers, with token about new requested password.' =>
            '',
        'Defines the body text for rejected emails.' => '',
        'Defines the calendar width in percent. Default is 95%.' => '',
        'Defines the column to store the keys for the preferences table.' =>
            '',
        'Defines the config options for the autocompletion feature.' => '',
        'Defines the config parameters of this item, to be shown in the preferences view.' =>
            '',
        'Defines the config parameters of this item, to be shown in the preferences view. \'PasswordRegExp\' allows to match passwords against a regular expression. Define the minimum number of characters using \'PasswordMinSize\'. Define if at least 2 lowercase and 2 uppercase letter characters are needed by setting the appropriate option to \'1\'. \'PasswordMin2Characters\' defines if the password needs to contain at least 2 letter characters (set to 0 or 1). \'PasswordNeedDigit\' controls the need of at least 1 digit (set to 0 or 1 to control). \'PasswordMaxLoginFailed\' allows to set an agent to invalid-temporarily if max failed logins reached. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Defines the config parameters of this item, to be shown in the preferences view. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
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
        'Defines the default filter fields in the customer user address book search (CustomerUser or CustomerCompany). For the CustomerCompany fields a prefix \'CustomerCompany_\' must be added.' =>
            '',
        'Defines the default front-end (HTML) theme to be used by the agents and customers. If you like, you can add your own theme. Please refer the administrator manual located at https://doc.otrs.com/doc/.' =>
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
        'Defines the default next state of a ticket, in the ticket bulk screen of the agent interface.' =>
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
        'Defines the default queue for new tickets in the agent interface.' =>
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
        'Defines the default used Frontend-Module if no Action parameter given in the url on the agent interface.' =>
            '',
        'Defines the default used Frontend-Module if no Action parameter given in the url on the customer interface.' =>
            '',
        'Defines the default value for the action parameter for the public frontend. The action parameter is used in the scripts of the system.' =>
            '',
        'Defines the default viewable sender types of a ticket (default: customer).' =>
            '',
        'Defines the default visibility of the article to customer for this operation.' =>
            '',
        'Defines the displayed style of the From field in notes that are visible for customers. A default agent name can be defined in Ticket::Frontend::CustomerTicketZoom###DefaultAgentName setting.' =>
            '',
        'Defines the dynamic fields that are used for displaying on calendar events.' =>
            '',
        'Defines the event object types that will be handled via AdminAppointmentNotificationEvent.' =>
            '',
        'Defines the fall-back path to open fetchmail binary. Note: The name of the binary needs to be \'fetchmail\', if it is different please use a symbolic link.' =>
            '',
        'Defines the filter that processes the text in the articles, in order to highlight URLs.' =>
            '',
        'Defines the format of responses in the ticket compose screen of the agent interface ([% Data.OrigFrom | html %] is From 1:1, [% Data.OrigFromName | html %] is only realname of From).' =>
            '',
        'Defines the fully qualified domain name of the system. This setting is used as a variable, OTRS_CONFIG_FQDN which is found in all forms of messaging used by the application, to build links to the tickets within your system.' =>
            '',
        'Defines the groups every customer user will be in (if CustomerGroupSupport is enabled and you don\'t want to manage every customer user for these groups).' =>
            '',
        'Defines the groups every customer will be in (if CustomerGroupSupport is enabled and you don\'t want to manage every customer for these groups).' =>
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
        'Defines the list of params that can be passed to ticket search function.' =>
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
        'Defines the module to display a notification in the agent interface if the system configuration is out of sync.' =>
            '',
        'Defines the module to display a notification in the agent interface, if the agent has not yet selected a time zone.' =>
            '',
        'Defines the module to display a notification in the agent interface, if the agent is logged in while having out-of-office active.' =>
            '',
        'Defines the module to display a notification in the agent interface, if the agent is logged in while having system maintenance active.' =>
            '',
        'Defines the module to display a notification in the agent interface, if the agent session limit prior warning is reached.' =>
            '',
        'Defines the module to display a notification in the agent interface, if the installation of not verified packages is activated (only shown to admins).' =>
            '',
        'Defines the module to display a notification in the agent interface, if the system is used by the admin user (normally you shouldn\'t work as admin).' =>
            '',
        'Defines the module to display a notification in the agent interface, if there are invalid sysconfig settings deployed.' =>
            '',
        'Defines the module to display a notification in the agent interface, if there are modified sysconfig settings that are not deployed yet.' =>
            '',
        'Defines the module to display a notification in the customer interface, if the customer is logged in while having system maintenance active.' =>
            '',
        'Defines the module to display a notification in the customer interface, if the customer user has not yet selected a time zone.' =>
            '',
        'Defines the module to generate code for periodic page reloads.' =>
            '',
        'Defines the module to send emails. "DoNotSendEmail" doesn\'t send emails at all. Any of the "SMTP" mechanisms use a specified (external) mailserver. "Sendmail" directly uses the sendmail binary of your operating system. "Test" doesn\'t send emails, but writes them to $OTRS_HOME/var/tmp/CacheFileStorable/EmailTest/ for testing purposes.' =>
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
        'Defines the next state of a ticket, in the ticket bulk screen of the agent interface.' =>
            '',
        'Defines the number of character per line used in case an HTML article preview replacement on TemplateGenerator for EventNotifications.' =>
            '',
        'Defines the number of days to keep the daemon log files.' => '',
        'Defines the number of header fields in frontend modules for add and update postmaster filters. It can be up to 99 fields.' =>
            '',
        'Defines the number of hours a communication will be stored, whichever its status.' =>
            '',
        'Defines the number of hours a successful communication will be stored.' =>
            '',
        'Defines the parameters for the customer preferences table.' => '',
        'Defines the parameters for the dashboard backend. "Cmd" is used to specify command with parameters. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            '',
        'Defines the parameters for the dashboard backend. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            '',
        'Defines the parameters for the dashboard backend. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" defines the cache expiration period in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            '',
        'Defines the parameters for the dashboard backend. "Limit" defines the number of entries displayed by default. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            '',
        'Defines the parameters for the dashboard backend. "Limit" defines the number of entries displayed by default. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" defines the cache expiration period in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
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
        'Defines the period of time (in minutes) before agent is marked as "away" due to inactivity (e.g. in the "Logged-In Users" widget or for the chat).' =>
            '',
        'Defines the period of time (in minutes) before customer is marked as "away" due to inactivity (e.g. in the "Logged-In Users" widget or for the chat).' =>
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
        'Defines the search parameters for the AgentCustomerUserAddressBook screen. With the setting \'CustomerTicketTextField\' the values for the recipient field can be specified.' =>
            '',
        'Defines the sender for rejected emails.' => '',
        'Defines the separator between the agents real name and the given queue email address.' =>
            '',
        'Defines the shown columns and the position in the AgentCustomerUserAddressBook result screen.' =>
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
        'Defines the ticket appointment type backend for ticket dynamic field date time.' =>
            '',
        'Defines the ticket appointment type backend for ticket escalation time.' =>
            '',
        'Defines the ticket appointment type backend for ticket pending time.' =>
            '',
        'Defines the ticket fields that are going to be displayed calendar events. The "Key" defines the field or ticket attribute and the "Content" defines the display name.' =>
            '',
        'Defines the ticket plugin for calendar appointments.' => '',
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
        'Defines the users avatar. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Defines the valid state types for a ticket. If a ticket is in a state which have any state type from this setting, this ticket will be considered as open, otherwise as closed.' =>
            '',
        'Defines the valid states for unlocked tickets. To unlock tickets the script "bin/otrs.Console.pl Maint::Ticket::UnlockTimeout" can be used.' =>
            '',
        'Defines the viewable locks of a ticket. NOTE: When you change this setting, make sure to delete the cache in order to use the new value. Default: unlock, tmp_lock.' =>
            '',
        'Defines the width for the rich text editor component for this screen. Enter number (pixels) or percent value (relative).' =>
            '',
        'Defines the width for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            '',
        'Defines time in minutes since last modification for drafts of specified type before they are considered expired.' =>
            '',
        'Defines whether to index archived tickets for fulltext searches.' =>
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
        'Defines, which tickets of which ticket state types should not be listed in linked ticket lists.' =>
            '',
        'Delete expired cache from core modules.' => '',
        'Delete expired loader cache weekly (Sunday mornings).' => '',
        'Delete expired sessions.' => '',
        'Delete expired ticket draft entries.' => '',
        'Delete expired upload cache hourly.' => '',
        'Delete this ticket' => 'Verwijder dit ticket',
        'Deleted link to ticket "%s".' => 'Koppeling naar "%s" verwijderd.',
        'Deletes a session if the session id is used with an invalid remote IP address.' =>
            '',
        'Deletes requested sessions if they have timed out.' => '',
        'Delivers extended debugging information in the frontend in case any AJAX errors occur, if enabled.' =>
            '',
        'Deploy and manage OTRS Business Solution™.' => '',
        'Detached' => '',
        'Determines if a button to delete a link should be displayed next to each link in each zoom mask.' =>
            '',
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
        'Disable autocomplete in the login screen.' => '',
        'Disable cloud services' => '',
        'Disables sending reminder notifications to the responsible agent of a ticket (Ticket::Responsible needs to be enabled).' =>
            '',
        'Disables the redirection to the last screen overview / dashboard after a ticket is closed.' =>
            '',
        'Disables the web installer (http://yourhost.example.com/otrs/installer.pl), to prevent the system from being hijacked. If not enabled, the system can be reinstalled and the current basic configuration will be used to pre-populate the questions within the installer script. If enabled, it also disables the GenericAgent, PackageManager and SQL Box.' =>
            '',
        'Display a warning and prevent search when using stop words within fulltext search.' =>
            '',
        'Display communication log entries.' => '',
        'Display settings to override defaults for Process Tickets.' => '',
        'Displays the accounted time for an article in the ticket zoom view.' =>
            '',
        'Displays the number of all tickets with the same CustomerID as current ticket in the ticket zoom view.' =>
            '',
        'Down' => 'Beneden',
        'Dropdown' => '',
        'Dutch' => '',
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
        'Dynamic fields limit per page for Dynamic Fields Overview.' => '',
        'Dynamic fields options shown in the ticket message screen of the customer interface. NOTE. If you want to display these fields also in the ticket zoom of the customer interface, you have to enable them in CustomerTicketZoom###DynamicField.' =>
            '',
        'Dynamic fields options shown in the ticket reply section in the ticket zoom screen of the customer interface.' =>
            '',
        'Dynamic fields shown in the email outbound screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the process widget in ticket zoom screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the sidebar of the ticket zoom screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket close screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket compose screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket email screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket forward screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket free text screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket medium format overview screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket move screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket note screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket overview screen of the customer interface.' =>
            '',
        'Dynamic fields shown in the ticket owner screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket pending screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket phone outbound screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket phone screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket preview format overview screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket print screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket print screen of the customer interface.' =>
            '',
        'Dynamic fields shown in the ticket priority screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket responsible screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket search overview results screen of the customer interface.' =>
            '',
        'Dynamic fields shown in the ticket search screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket search screen of the customer interface.' =>
            '',
        'Dynamic fields shown in the ticket small format overview screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket zoom screen of the customer interface.' =>
            '',
        'DynamicField' => '',
        'DynamicField backend registration.' => '',
        'DynamicField object registration.' => '',
        'DynamicField_%s' => '',
        'E-Mail Outbound' => '',
        'Edit Customer Companies.' => '',
        'Edit Customer Users.' => '',
        'Edit appointment' => '',
        'Edit customer company' => 'Bedrijf aanpassen',
        'Email Addresses' => 'E-mailadressen',
        'Email Outbound' => '',
        'Email Resend' => '',
        'Email communication channel.' => '',
        'Enable highlighting queues based on ticket age.' => '',
        'Enable keep-alive connection header for SOAP responses.' => '',
        'Enable this if you trust in all your public and private pgp keys, even if they are not certified with a trusted signature.' =>
            '',
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
        'Enables the minimal ticket counter size (if "Date" was selected as TicketNumberGenerator).' =>
            '',
        'Enables ticket bulk action feature for the agent frontend to work on more than one ticket at a time.' =>
            '',
        'Enables ticket bulk action feature only for the listed groups.' =>
            '',
        'Enables ticket responsible feature, to keep track of a specific ticket.' =>
            '',
        'Enables ticket type feature.' => '',
        'Enables ticket watcher feature only for the listed groups.' => '',
        'English (Canada)' => 'Engels (Canada)',
        'English (United Kingdom)' => 'Engels (Verenigd Koninkrijk)',
        'English (United States)' => 'Engels (Verenigde Staten)',
        'English stop words for fulltext index. These words will be removed from the search index.' =>
            'Engelse stopwoorden voor volledige text zoek index. Deze woorden worden verwijderd van de zoek index.',
        'Enroll process for this ticket' => 'Inschrijfproces voor dit ticket',
        'Enter your shared secret to enable two factor authentication. WARNING: Make sure that you add the shared secret to your generator application and the application works well. Otherwise you will be not able to login anymore without the two factor token.' =>
            '',
        'Escalated Tickets' => 'Geëscaleerde tickets',
        'Escalation view' => 'Escalatieoverzicht',
        'EscalationTime' => 'EscalatieTijd',
        'Estonian' => 'Estlands',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate).' =>
            '',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate). This is only possible if all Ticket dynamic fields need the same event.' =>
            '',
        'Event module that performs an update statement on TicketIndex to rename the queue name there if needed and if StaticDB is actually used.' =>
            '',
        'Event module that updates customer company object name for dynamic fields.' =>
            '',
        'Event module that updates customer user object name for dynamic fields.' =>
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
        'Example package autoload configuration.' => '',
        'Execute SQL statements.' => 'Voer SQL statements uit op de database.',
        'Executes a custom command or module. Note: if module is used, function is required.' =>
            '',
        'Executes follow-up checks on In-Reply-To or References headers for mails that don\'t have a ticket number in the subject.' =>
            '',
        'Executes follow-up checks on OTRS Header \'X-OTRS-Bounce\'.' => '',
        'Executes follow-up checks on attachment contents for mails that don\'t have a ticket number in the subject.' =>
            '',
        'Executes follow-up checks on email body for mails that don\'t have a ticket number in the subject.' =>
            '',
        'Executes follow-up checks on the raw source email for mails that don\'t have a ticket number in the subject.' =>
            '',
        'Exports the whole article tree in search result (it can affect the system performance).' =>
            '',
        'External' => '',
        'External Link' => '',
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
        'First Christmas Day' => 'Eerste Kerstdag',
        'First Queue' => 'Eerste Wachtrij',
        'First response time' => 'Eerste responstijd',
        'FirstLock' => 'EersteLock',
        'FirstResponse' => 'EersteAntwoord',
        'FirstResponseDiffInMin' => 'EersteAntwoordVerschilInMin',
        'FirstResponseInMin' => 'EersteAntwoordInMin',
        'Firstname Lastname' => 'Voornaam Achternaam',
        'Firstname Lastname (UserLogin)' => 'Voornaam Achternaam (Loginnaam)',
        'For these state types the ticket numbers are striked through in the link table.' =>
            '',
        'Force the storage of the original article text in the article search index, without executing filters or applying stop word lists. This will increase the size of the search index and thus may slow down fulltext searches.' =>
            '',
        'Forces encoding of outgoing emails (7bit|8bit|quoted-printable|base64).' =>
            'dwingt codering af van uitgaande e-mails (7bit|8bit|quoted-printable|base64).',
        'Forces to choose a different ticket state (from current) after lock action. Define the current state as key, and the next state after lock action as content.' =>
            '',
        'Forces to unlock tickets after being moved to another queue.' =>
            'Dwingt om tickets vrij te geven wanneer ze naar een nieuwe wachtrij worden verplaatst.',
        'Forwarded to "%s".' => 'Doorgestuurd aan "%s".',
        'Free Fields' => 'Vrije invulvelden',
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
        'Frontend module registration (show personal favorites as sub navigation items of \'Admin\').' =>
            '',
        'Frontend module registration for the agent interface.' => '',
        'Frontend module registration for the customer interface.' => '',
        'Frontend module registration for the public interface.' => '',
        'Full value' => 'Volledige waarde',
        'Fulltext index regex filters to remove parts of the text.' => 'Volledige tekst reguliere expressie om bepaalde gedeelten van de tekst te verwijderen.',
        'Fulltext search' => 'Volledige tekst zoekactie',
        'Galician' => 'Galicische',
        'General ticket data shown in the ticket overviews (fall-back). Note that TicketNumber can not be disabled, because it is necessary.' =>
            '',
        'Generate dashboard statistics.' => 'Genereer dashboard statistieken.',
        'Generic Info module.' => '',
        'GenericAgent' => 'Automatische taken',
        'GenericInterface Debugger GUI' => '',
        'GenericInterface ErrorHandling GUI' => '',
        'GenericInterface Invoker Event GUI' => '',
        'GenericInterface Invoker GUI' => '',
        'GenericInterface Operation GUI' => '',
        'GenericInterface TransportHTTPREST GUI' => '',
        'GenericInterface TransportHTTPSOAP GUI' => '',
        'GenericInterface Web Service GUI' => '',
        'GenericInterface Web Service History GUI' => '',
        'GenericInterface Web Service Mapping GUI' => '',
        'GenericInterface module registration for an error handling module.' =>
            '',
        'GenericInterface module registration for the invoker layer.' => '',
        'GenericInterface module registration for the mapping layer.' => '',
        'GenericInterface module registration for the operation layer.' =>
            '',
        'GenericInterface module registration for the transport layer.' =>
            '',
        'German' => '',
        'German stop words for fulltext index. These words will be removed from the search index.' =>
            '',
        'Gives customer users group based access to tickets from customer users of the same customer (ticket CustomerID is a CustomerID of the customer user).' =>
            '',
        'Gives end users the possibility to override the separator character for CSV files, defined in the translation files. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Global Search Module.' => '',
        'Go to dashboard!' => 'Ga naar het dashboard!',
        'Good PGP signature.' => '',
        'Google Authenticator' => 'Google Authenticator',
        'Graph: Bar Chart' => '',
        'Graph: Line Chart' => '',
        'Graph: Stacked Area Chart' => '',
        'Greek' => 'Grieks',
        'Hebrew' => 'Hebreeuws',
        'Helps to extend your articles full-text search (From, To, Cc, Subject and Body search). It will strip all articles and will build an index after article creation, increasing fulltext searches about 50%. To create an initial index use "bin/otrs.Console.pl Maint::Ticket::FulltextIndex --rebuild".' =>
            '',
        'High Contrast' => 'Hoog Contrast',
        'High contrast skin for visually impaired users.' => 'Hoog contrast thema voor gebruikers met een visuele beperking.',
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
        'If "DB" was selected for Customer::AuthModule, the encryption type of passwords must be specified.' =>
            '',
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
        'If "SysLog" was selected for LogModule, the charset that should be used for logging can be specified.' =>
            '',
        'If "bcrypt" was selected for CryptType, use cost specified here for bcrypt hashing. Currently max. supported cost value is 31.' =>
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
        'If enabled, OTRS will deliver all CSS files in minified form.' =>
            '',
        'If enabled, OTRS will deliver all JavaScript files in minified form.' =>
            '',
        'If enabled, TicketPhone and TicketEmail will be open in new windows.' =>
            '',
        'If enabled, the OTRS version tag will be removed from the Webinterface, the HTTP headers and the X-Headers of outgoing mails. NOTE: If you change this option, please make sure to delete the cache.' =>
            '',
        'If enabled, the cache data be held in memory.' => '',
        'If enabled, the cache data will be stored in cache backend.' => '',
        'If enabled, the customer can search for tickets in all services (regardless what services are assigned to the customer).' =>
            '',
        'If enabled, the different overviews (Dashboard, LockedView, QueueView) will automatically refresh after the specified time.' =>
            'Indien geactiveerd worden de verschillende overzichten (Dashboard, vergrendelde tickets, wachtrijoverzicht) automatisch ververst na de ingestelde tijd.',
        'If enabled, the first level of the main menu opens on mouse hover (instead of click only).' =>
            '',
        'If enabled, users that haven\'t selected a time zone yet will be notified to do so. Note: Notification will not be shown if (1) user has not yet selected a time zone and (2) OTRSTimeZone and UserDefaultTimeZone do match and (3) are not set to UTC.' =>
            '',
        'If no SendmailNotificationEnvelopeFrom is specified, this setting makes it possible to use the email\'s from address instead of an empty envelope sender (required in certain mail server configurations).' =>
            '',
        'If set, this address is used as envelope sender header in outgoing notifications. If no address is specified, the envelope sender header is empty (unless SendmailNotificationEnvelopeFrom::FallbackToEmailFrom is set).' =>
            '',
        'If set, this address is used as envelope sender in outgoing messages (not notifications - see below). If no address is specified, the envelope sender is equal to queue e-mail address.' =>
            '',
        'If this option is enabled, tickets created via the web interface, via Customers or Agents, will receive an autoresponse if configured. If this option is not enabled, no autoresponses will be sent.' =>
            '',
        'If this regex matches, no message will be send by the autoresponder.' =>
            '',
        'If this setting is enabled, it is possible to install packages which are not verified by OTRS Group. These packages could threaten your whole system!' =>
            '',
        'If this setting is enabled, local modifications will not be highlighted as errors in the package manager and support data collector.' =>
            '',
        'If you\'re going to be out of office, you may wish to let other users know by setting the exact dates of your absence.' =>
            'Als u langere tijd afwezig bent kunt u hier de gebruikers precies laten weten wanneer u afwezig bent.',
        'Ignore system sender article types (e. g. auto responses or email notifications) to be flagged as \'Unread Article\' in AgentTicketZoom or expanded automatically in Large view screens.' =>
            '',
        'Import appointments screen.' => '',
        'Include tickets of subqueues per default when selecting a queue.' =>
            '',
        'Include unknown customers in ticket filter.' => '',
        'Includes article create times in the ticket search of the agent interface.' =>
            '',
        'Incoming Phone Call.' => 'Inkomend telefoongesprek',
        'IndexAccelerator: to choose your backend TicketViewAccelerator module. "RuntimeDB" generates each queue view on the fly from ticket table (no performance problems up to approx. 60.000 tickets in total and 6.000 open tickets in the system). "StaticDB" is the most powerful module, it uses an extra ticket-index table that works like a view (recommended if more than 80.000 and 6.000 open tickets are stored in the system). Use the command "bin/otrs.Console.pl Maint::Ticket::QueueIndexRebuild" for initial index creation.' =>
            '',
        'Indicates if a bounce e-mail should always be treated as normal follow-up.' =>
            '',
        'Indonesian' => '',
        'Inline' => '',
        'Input' => '',
        'Interface language' => 'Interface taal',
        'Internal communication channel.' => '',
        'International Workers\' Day' => 'Dag van de Arbeid',
        'It is possible to configure different skins, for example to distinguish between diferent agents, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            '',
        'It is possible to configure different skins, for example to distinguish between diferent customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            '',
        'It is possible to configure different themes, for example to distinguish between agents and customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid theme on your system. Please see the example entries for the proper form of the regex.' =>
            '',
        'It was not possible to check the PGP signature, this may be caused by a missing public key or an unsupported algorithm.' =>
            '',
        'Italian' => '',
        'Italian stop words for fulltext index. These words will be removed from the search index.' =>
            '',
        'Ivory' => '',
        'Ivory (Slim)' => '',
        'Japanese' => 'Japans',
        'JavaScript function for the search frontend.' => '',
        'Korean' => '',
        'Language' => 'Taal',
        'Large' => 'Groot',
        'Last Screen Overview' => '',
        'Last customer subject' => '',
        'Lastname Firstname' => '',
        'Lastname Firstname (UserLogin)' => 'Achternaam Voornaam (Loginnaam)',
        'Lastname, Firstname' => 'Achternaam, Voornaam',
        'Lastname, Firstname (UserLogin)' => 'Achternaam, Voornaam (Loginnaam)',
        'LastnameFirstname' => 'AchternaamVoornaam',
        'Latvian' => '',
        'Left' => '',
        'Link Object' => 'Koppel object',
        'Link Object.' => 'Koppel Object',
        'Link agents to groups.' => 'Koppel behandelaars aan groepen.',
        'Link agents to roles.' => 'Koppel behandelaars aan rollen.',
        'Link customer users to customers.' => 'Koppel klanten aan bedrijven.',
        'Link customer users to groups.' => 'Koppel klanten aan groepen.',
        'Link customer users to services.' => 'Koppel klanten aan services.',
        'Link customers to groups.' => 'Koppel bedrijven aan groepen.',
        'Link queues to auto responses.' => 'Koppel wachtrijen aan automatische antwoorden.',
        'Link roles to groups.' => 'Koppel rollen aan groepen.',
        'Link templates to attachments.' => 'Koppel sjablonen aan bijlagen.',
        'Link templates to queues.' => 'Koppel sjablonen aan wachtrijen.',
        'Link this ticket to other objects' => 'Koppel dit ticket aan andere objecten',
        'Links 2 tickets with a "Normal" type link.' => 'Koppelt twee tickets met een "Normaal"-type koppeling.',
        'Links 2 tickets with a "ParentChild" type link.' => 'Koppelt twee tickets met een "vader - zoon"-type koppeling.',
        'Links appointments and tickets with a "Normal" type link.' => 'Koppelt afspraken en tickets met een "Normaal"-type koppeling.',
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
        'List of all LinkObject events to be displayed in the GUI.' => '',
        'List of all Package events to be displayed in the GUI.' => '',
        'List of all appointment events to be displayed in the GUI.' => '',
        'List of all article events to be displayed in the GUI.' => '',
        'List of all calendar events to be displayed in the GUI.' => '',
        'List of all queue events to be displayed in the GUI.' => '',
        'List of all ticket events to be displayed in the GUI.' => '',
        'List of colors in hexadecimal RGB which will be available for selection during calendar creation. Make sure the colors are dark enough so white text can be overlayed on them.' =>
            '',
        'List of default Standard Templates which are assigned automatically to new Queues upon creation.' =>
            'Lijst van standaard sjablonen die automatisch gekoppeld worden bij het aanmaken van een wachtrij.',
        'List of responsive CSS files to always be loaded for the agent interface.' =>
            '',
        'List of responsive CSS files to always be loaded for the customer interface.' =>
            '',
        'List view' => '',
        'Lithuanian' => '',
        'Loader module registration for the agent interface.' => '',
        'Loader module registration for the customer interface.' => '',
        'Lock / unlock this ticket' => '',
        'Locked Tickets' => 'Vergrendelde tickets',
        'Locked Tickets.' => 'Vergrendelde Tickets.',
        'Locked ticket.' => 'Ticket vergrendeld.',
        'Logged in users.' => 'Ingelogde gebruikers.',
        'Logged-In Users' => 'Ingelogde gebruikers.',
        'Logout of customer panel.' => 'Uitloggen van het klantpaneel.',
        'Look into a ticket!' => 'Bekijk dit ticket.',
        'Loop protection: no auto-response sent to "%s".' => '',
        'Macedonian' => '',
        'Mail Accounts' => '',
        'MailQueue configuration settings.' => '',
        'Main menu item registration.' => '',
        'Main menu registration.' => '',
        'Makes the application block external content loading.' => '',
        'Makes the application check the MX record of email addresses before sending an email or submitting a telephone or email ticket.' =>
            '',
        'Makes the application check the syntax of email addresses.' => '',
        'Makes the session management use html cookies. If html cookies are disabled or if the client browser disabled html cookies, then the system will work as usual and append the session id to the links.' =>
            '',
        'Malay' => '',
        'Manage OTRS Group cloud services.' => 'Beheer OTRS Group cloud diensten.',
        'Manage PGP keys for email encryption.' => 'Beheer PGP-sleutels voor encryptie van e-mail.',
        'Manage POP3 or IMAP accounts to fetch email from.' => 'Beheer POP3 of IMAP accounts om e-mail op te halen en om te zetten naar tickets.',
        'Manage S/MIME certificates for email encryption.' => 'Beheer S/MIME certificaten voor encryptie van e-mail.',
        'Manage System Configuration Deployments.' => '',
        'Manage different calendars.' => '',
        'Manage existing sessions.' => 'Beheer sessies van klanten en gebruikers.',
        'Manage support data.' => 'Beheer support gegevens.',
        'Manage system registration.' => 'Beheer systeemregistratie.',
        'Manage tasks triggered by event or time based execution.' => 'Beheer van taken op basis van events of tijdschema\'s',
        'Mark as Spam!' => 'Markeer als spam',
        'Mark this ticket as junk!' => 'Markeer het ticket als junk!',
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
        'Maximal auto email responses to own email-address a day, configurable by email address (Loop-Protection).' =>
            '',
        'Maximal size in KBytes for mails that can be fetched via POP3/POP3S/IMAP/IMAPS (KBytes).' =>
            '',
        'Maximum Number of a calendar shown in a dropdown.' => '',
        'Maximum length (in characters) of the dynamic field in the article of the ticket zoom view.' =>
            '',
        'Maximum length (in characters) of the dynamic field in the sidebar of the ticket zoom view.' =>
            '',
        'Maximum number of active calendars in overview screens. Please note that large number of active calendars can have a performance impact on your server by making too much simultaneous calls.' =>
            '',
        'Maximum number of tickets to be displayed in the result of a search in the agent interface.' =>
            '',
        'Maximum number of tickets to be displayed in the result of a search in the customer interface.' =>
            '',
        'Maximum number of tickets to be displayed in the result of this operation.' =>
            '',
        'Maximum size (in characters) of the customer information table in the ticket zoom view.' =>
            '',
        'Medium' => 'Middel',
        'Merge this ticket and all articles into another ticket' => '',
        'Merged Ticket (%s/%s) to (%s/%s).' => '',
        'Merged Ticket <OTRS_TICKET> to <OTRS_MERGE_TO_TICKET>.' => '',
        'Minute' => 'Minuut',
        'Miscellaneous' => 'Diversen',
        'Module for To-selection in new ticket screen in the customer interface.' =>
            '',
        'Module to check if a incoming e-mail message is bounce.' => '',
        'Module to check if arrived emails should be marked as internal (because of original forwarded internal email). IsVisibleForCustomer and SenderType define the values for the arrived email/article.' =>
            '',
        'Module to check the group permissions for customer access to tickets.' =>
            '',
        'Module to check the group permissions for the access to tickets.' =>
            '',
        'Module to compose signed messages (PGP or S/MIME).' => '',
        'Module to define the email security options to use (PGP or S/MIME).' =>
            '',
        'Module to encrypt composed messages (PGP or S/MIME).' => '',
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
        'Module to generate ticket statistics.' => 'Module om ticket statistieken te genereren.',
        'Module to grant access if the CustomerID of the customer has necessary group permissions.' =>
            '',
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
        'Module used to detect if attachments are present.' => '',
        'Multiselect' => 'Multiselect',
        'My Queues' => 'Mijn wachtrijen',
        'My Services' => 'Mijn Diensten',
        'My Tickets.' => 'Mijn tickets',
        'Name of custom queue. The custom queue is a queue selection of your preferred queues and can be selected in the preferences settings.' =>
            '',
        'Name of custom service. The custom service is a service selection of your preferred services and can be selected in the preferences settings.' =>
            '',
        'NameX' => 'NaamX',
        'New Ticket' => 'Nieuw ticket',
        'New Tickets' => 'Nieuwe tickets',
        'New Window' => 'Nieuw Venster',
        'New Year\'s Day' => 'Nieuwjaarsdag',
        'New Year\'s Eve' => 'Oudjaarsdag',
        'New process ticket' => 'Nieuw proces-ticket',
        'News about OTRS releases!' => 'Nieuws over OTRS versies!',
        'News about OTRS.' => 'Nieuws over OTRS.',
        'Next possible ticket states after adding a phone note in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Next possible ticket states after adding a phone note in the ticket phone outbound screen of the agent interface.' =>
            '',
        'No public key found.' => '',
        'No valid OpenPGP data found.' => '',
        'None' => 'Geen',
        'Norwegian' => '',
        'Notification Settings' => 'Notificatievoorkeuren',
        'Notified about response time escalation.' => '',
        'Notified about solution time escalation.' => '',
        'Notified about update time escalation.' => '',
        'Number of displayed tickets' => 'Aantal weergegeven tickets',
        'Number of lines (per ticket) that are shown by the search utility in the agent interface.' =>
            '',
        'Number of tickets to be displayed in each page of a search result in the agent interface.' =>
            '',
        'Number of tickets to be displayed in each page of a search result in the customer interface.' =>
            '',
        'Number of tickets to be displayed in each page.' => '',
        'OTRS Group Services' => 'OTRS Group diensten',
        'OTRS News' => 'OTRS Nieuws',
        'OTRS can use one or more readonly mirror databases for expensive operations like fulltext search or statistics generation. Here you can specify the DSN for the first mirror database.' =>
            '',
        'OTRS doesn\'t support recurring Appointments without end date or number of iterations. During import process, it might happen that ICS file contains such Appointments. Instead, system creates all Appointments in the past, plus Appointments for the next N months (120 months/10 years by default).' =>
            '',
        'Open an external link!' => '',
        'Open tickets (customer user)' => 'Open tickets (klant gebruiker)',
        'Open tickets (customer)' => 'Open tickets (klant)',
        'Option' => 'Optie',
        'Optional queue limitation for the CreatorCheck permission module. If set, permission is only granted for tickets in the specified queues.' =>
            '',
        'Optional queue limitation for the InvolvedCheck permission module. If set, permission is only granted for tickets in the specified queues.' =>
            '',
        'Optional queue limitation for the OwnerCheck permission module. If set, permission is only granted for tickets in the specified queues.' =>
            '',
        'Optional queue limitation for the ResponsibleCheck permission module. If set, permission is only granted for tickets in the specified queues.' =>
            '',
        'Other Customers' => 'Andere Klanten',
        'Out Of Office' => 'Afwezig',
        'Out Of Office Time' => 'Afwezigheid',
        'Out of Office users.' => '',
        'Overloads (redefines) existing functions in Kernel::System::Ticket. Used to easily add customizations.' =>
            '',
        'Overview Escalated Tickets.' => 'Overzicht geëscaleerde tickets.',
        'Overview Refresh Time' => 'Verversingsinterval overzichten',
        'Overview of all Tickets per assigned Queue.' => '',
        'Overview of all appointments.' => 'Overzicht van alle afspraken.',
        'Overview of all escalated tickets.' => 'Overzicht van alle geëscaleerde tickets.',
        'Overview of all open Tickets.' => 'Overzicht van alle openstaande tickets',
        'Overview of all open tickets.' => 'Overzicht van alle openstaande tickets.',
        'Overview of customer tickets.' => 'Overzicht van alle klanttickets.',
        'PGP Key' => 'PGP Sleutel',
        'PGP Key Management' => 'PGP sleutel beheer',
        'PGP Keys' => 'PGP Sleutels',
        'Package event module file a scheduler task for update registration.' =>
            '',
        'Parameters for the CreateNextMask object in the preference view of the agent interface. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Parameters for the CustomQueue object in the preference view of the agent interface. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Parameters for the CustomService object in the preference view of the agent interface. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Parameters for the RefreshTime object in the preference view of the agent interface. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Parameters for the column filters of the small ticket overview. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Parameters for the dashboard backend of the customer company information of the agent interface. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the customer id list overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the customer id status widget of the agent interface . "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the customer user information of the agent interface. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the customer user list overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the new tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            '',
        'Parameters for the dashboard backend of the new tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            '',
        'Parameters for the dashboard backend of the open tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            '',
        'Parameters for the dashboard backend of the open tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            '',
        'Parameters for the dashboard backend of the queue overview widget of the agent interface. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "QueuePermissionGroup" is not mandatory, queues are only listed if they belong to this permission group if you enable it. "States" is a list of states, the key is the sort order of the state in the widget. "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            '',
        'Parameters for the dashboard backend of the running process tickets overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            '',
        'Parameters for the dashboard backend of the ticket escalation overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            '',
        'Parameters for the dashboard backend of the ticket escalation overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            '',
        'Parameters for the dashboard backend of the ticket escalation overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            '',
        'Parameters for the dashboard backend of the ticket events calendar of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            '',
        'Parameters for the dashboard backend of the ticket pending reminder overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            '',
        'Parameters for the dashboard backend of the ticket pending reminder overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            '',
        'Parameters for the dashboard backend of the ticket pending reminder overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            '',
        'Parameters for the dashboard backend of the ticket stats of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            '',
        'Parameters for the dashboard backend of the upcoming events widget of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            '',
        'Parameters for the pages (in which the communication log entries are shown) of the communication log overview.' =>
            '',
        'Parameters for the pages (in which the dynamic fields are shown) of the dynamic fields overview. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Parameters for the pages (in which the tickets are shown) of the medium ticket overview. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Parameters for the pages (in which the tickets are shown) of the small ticket overview. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Parameters for the pages (in which the tickets are shown) of the ticket preview overview. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Parameters of the example SLA attribute Comment2.' => '',
        'Parameters of the example queue attribute Comment2.' => '',
        'Parameters of the example service attribute Comment2.' => '',
        'Parent' => 'vader',
        'ParentChild' => 'OuderKind',
        'Path for the log file (it only applies if "FS" was selected for LoopProtectionModule and it is mandatory).' =>
            '',
        'Pending time' => '',
        'People' => 'Personen',
        'Performs the configured action for each event (as an Invoker) for each configured web service.' =>
            '',
        'Permitted width for compose email windows.' => '',
        'Permitted width for compose note windows.' => '',
        'Persian' => '',
        'Phone Call Inbound' => 'Inkomend telefoongesprek',
        'Phone Call Outbound' => 'Uitgaand telefoongesprek',
        'Phone Call.' => 'Telefoongesprek.',
        'Phone call' => 'Telefoongesprek',
        'Phone communication channel.' => '',
        'Phone-Ticket' => 'Telefoon ticket',
        'Picture Upload' => 'Afbeelding upload',
        'Picture upload module.' => 'Afbeelding upload module.',
        'Picture-Upload' => 'Afbeelding-upload',
        'Plugin search' => '',
        'Plugin search module for autocomplete.' => '',
        'Polish' => '',
        'Portuguese' => '',
        'Portuguese (Brasil)' => '',
        'PostMaster Filters' => 'E-mail filters',
        'PostMaster Mail Accounts' => 'E-mail accounts',
        'Print this ticket' => 'Print dit ticket',
        'Priorities' => 'Prioriteiten',
        'Process Management Activity Dialog GUI' => 'Procesbeheer dialoog',
        'Process Management Activity GUI' => 'Procesbeheer activiteit',
        'Process Management Path GUI' => 'Procesbeheer pad',
        'Process Management Transition Action GUI' => 'Procesbeheer transitie-actie',
        'Process Management Transition GUI' => 'Procesbeheer transitie',
        'Process Ticket.' => '',
        'Process pending tickets.' => '',
        'ProcessID' => '',
        'Processes & Automation' => 'Processen & Automatisering',
        'Product News' => 'Productnieuws',
        'Protection against CSRF (Cross Site Request Forgery) exploits (for more info see https://en.wikipedia.org/wiki/Cross-site_request_forgery).' =>
            '',
        'Provides a matrix overview of the tickets per state per queue' =>
            '',
        'Provides customer users access to tickets even if the tickets are not assigned to a customer user of the same customer ID(s), based on permission groups.' =>
            '',
        'Public Calendar' => 'Publieke Kalender',
        'Public calendar.' => 'Publieke kalender.',
        'Queue view' => 'Wachtrijoverzicht',
        'Queues ↔ Auto Responses' => 'Wachtrijen ↔ Automatische antwoorden',
        'Rebuild the ticket index for AgentTicketQueue.' => '',
        'Recognize if a ticket is a follow-up to an existing ticket using an external ticket number. Note: the first capturing group from the \'NumberRegExp\' expression will be used as the ticket number value.' =>
            '',
        'Refresh interval' => 'Interval',
        'Registers a log module, that can be used to log communication related information.' =>
            '',
        'Reminder Tickets' => 'Tickets met herinnering',
        'Removed subscription for user "%s".' => 'Removed subscription for user "%s".',
        'Removes old generic interface debug log entries created before the specified amount of days.' =>
            '',
        'Removes old system configuration deployments (Sunday mornings).' =>
            '',
        'Removes old ticket number counters (each 10 minutes).' => 'Verwijderd oude ticket nummer tellers (iedere 10 minuten).',
        'Removes the ticket watcher information when a ticket is archived.' =>
            '',
        'Renew existing SMIME certificates from customer backend. Note: SMIME and SMIME::FetchFromCustomer needs to be enabled in SysConfig and customer backend needs to be configured to fetch UserSMIMECertificate attribute.' =>
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
        'Required permissions to use the email resend screen in the agent interface.' =>
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
        'Resend Ticket Email.' => 'Ticket e-mail opnieuw versturen.',
        'Resent email to "%s".' => '',
        'Resets and unlocks the owner of a ticket if it was moved to another queue.' =>
            '',
        'Resource Overview (OTRS Business Solution™)' => '',
        'Responsible Tickets' => 'Verantwoordelijke tickets',
        'Responsible Tickets.' => 'Verantwoordelijke tickets.',
        'Restores a ticket from the archive (only if the event is a state change to any open available state).' =>
            '',
        'Retains all services in listings even if they are children of invalid elements.' =>
            '',
        'Right' => '',
        'Roles ↔ Groups' => 'Rollen ↔ Groepen',
        'Romanian' => '',
        'Run file based generic agent jobs (Note: module name needs to be specified in -configuration-module param e.g. "Kernel::System::GenericAgent").' =>
            '',
        'Running Process Tickets' => '',
        'Runs an initial wildcard search of the existing customer company when accessing the AdminCustomerCompany module.' =>
            '',
        'Runs an initial wildcard search of the existing customer users when accessing the AdminCustomerUser module.' =>
            '',
        'Runs the system in "Demo" mode. If enabled, agents can change preferences, such as selection of language and theme via the agent web interface. These changes are only valid for the current session. It will not be possible for agents to change their passwords.' =>
            'Voert het systeem uit in de "Demo" -modus. Indien ingeschakeld kunnen behandelaars voorkeuren wijzigen, taal en thema instellen via de webinterface van de behandelaar. Deze wijzigingen zijn alleen geldig voor de huidige sessie. Het is niet mogelijk voor behandelaars om hun wachtwoorden te wijzigen.',
        'Russian' => '',
        'S/MIME Certificates' => 'S/MIME Certificaten',
        'SMS' => '',
        'SMS (Short Message Service)' => '',
        'Salutations' => 'Aanheffen',
        'Sample command output' => '',
        'Saves the attachments of articles. "DB" stores all data in the database (not recommended for storing big attachments). "FS" stores the data on the filesystem; this is faster but the webserver should run under the OTRS user. You can switch between the modules even on a system that is already in production without any loss of data. Note: Searching for attachment names is not supported when "FS" is used.' =>
            '',
        'Schedule a maintenance period.' => 'Plan een nieuw systeem onderhoudstijdsvak.',
        'Screen after new ticket' => 'Scherm na nieuw ticket',
        'Search Customer' => 'Klanten zoeken',
        'Search Ticket.' => '',
        'Search Tickets.' => '',
        'Search User' => 'Zoek behandelaar',
        'Search backend default router.' => '',
        'Search backend router.' => '',
        'Search.' => '',
        'Second Christmas Day' => 'Tweede Kerstdag',
        'Second Queue' => '',
        'Select after which period ticket overviews should refresh automatically.' =>
            '',
        'Select how many tickets should be shown in overviews by default.' =>
            '',
        'Select the main interface language.' => 'Selecteer uw standaard taal.',
        'Select the separator character used in CSV files (stats and searches). If you don\'t select a separator here, the default separator for your language will be used.' =>
            'Selecteer het scheidingsteken voor CSV bestanden. Als u geen scheidingsteken kiest zal het standaard scheidingsteken voor uw taal gebruikt worden.',
        'Select your frontend Theme.' => 'Kies uw thema',
        'Select your personal time zone. All times will be displayed relative to this time zone.' =>
            '',
        'Select your preferred layout for the software.' => '',
        'Select your preferred theme for OTRS.' => '',
        'Selects the cache backend to use.' => '',
        'Selects the module to handle uploads via the web interface. "DB" stores all uploads in the database, "FS" uses the file system.' =>
            '',
        'Selects the ticket number generator module. "AutoIncrement" increments the ticket number, the SystemID and the counter are used with SystemID.counter format (e.g. 1010138, 1010139). With "Date" the ticket numbers will be generated by the current date, the SystemID and the counter. The format looks like Year.Month.Day.SystemID.counter (e.g. 200206231010138, 200206231010139). With "DateChecksum"  the counter will be appended as checksum to the string of date and SystemID. The checksum will be rotated on a daily basis. The format looks like Year.Month.Day.SystemID.Counter.CheckSum (e.g. 2002070110101520, 2002070110101535).' =>
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
        'Sent "%s" notification to "%s" via "%s".' => '',
        'Sent auto follow-up to "%s".' => '',
        'Sent auto reject to "%s".' => '',
        'Sent auto reply to "%s".' => '',
        'Sent email to "%s".' => '',
        'Sent email to customer.' => '',
        'Sent notification to "%s".' => '',
        'Serbian Cyrillic' => '',
        'Serbian Latin' => '',
        'Service Level Agreements' => 'Service Level Agreements',
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
        'Set this ticket to pending' => 'Zet dit ticket in de wacht',
        'Sets if SLA must be selected by the agent.' => '',
        'Sets if SLA must be selected by the customer.' => '',
        'Sets if note must be filled in by the agent. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            '',
        'Sets if queue must be selected by the agent.' => '',
        'Sets if service must be selected by the agent.' => '',
        'Sets if service must be selected by the customer.' => '',
        'Sets if state must be selected by the agent.' => '',
        'Sets if ticket owner must be selected by the agent.' => '',
        'Sets if ticket responsible must be selected by the agent.' => '',
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
        'Sets the default article customer visibility for new email tickets in the agent interface.' =>
            '',
        'Sets the default article customer visibility for new phone tickets in the agent interface.' =>
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
        'Sets the default link type of split tickets in the agent interface.' =>
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
        'Sets the method PGP will use to sing and encrypt emails. Note Inline method is not compatible with RichText messages.' =>
            '',
        'Sets the minimal ticket counter size if "AutoIncrement" was selected as TicketNumberGenerator. Default is 5, this means the counter starts from 10000.' =>
            '',
        'Sets the minutes a notification is shown for notice about upcoming system maintenance period.' =>
            '',
        'Sets the number of lines that are displayed in text messages (e.g. ticket lines in the QueueZoom).' =>
            'Bepaalt het aantal gels dat wordt weergegeven in tekstberichten (zoals het aantal regels in QueueZoom)',
        'Sets the options for PGP binary.' => 'Bepaalt de opties voor de PGP binaries',
        'Sets the password for private PGP key.' => 'Het wachtwoord van de PGP privésleutel',
        'Sets the prefered time units (e.g. work units, hours, minutes).' =>
            '',
        'Sets the preferred digest to be used for PGP binary.' => '',
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
        'Sets the service in the close ticket screen of the agent interface (Ticket::Service needs to be enabled).' =>
            '',
        'Sets the service in the ticket free text screen of the agent interface (Ticket::Service needs to be enabled).' =>
            '',
        'Sets the service in the ticket note screen of the agent interface (Ticket::Service needs to be enabled).' =>
            '',
        'Sets the service in the ticket owner screen of a zoomed ticket in the agent interface (Ticket::Service needs to be enabled).' =>
            '',
        'Sets the service in the ticket pending screen of a zoomed ticket in the agent interface (Ticket::Service needs to be enabled).' =>
            '',
        'Sets the service in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Service needs to be enabled).' =>
            '',
        'Sets the service in the ticket responsible screen of the agent interface (Ticket::Service needs to be enabled).' =>
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
        'Sets the ticket type in the close ticket screen of the agent interface (Ticket::Type needs to be enabled).' =>
            '',
        'Sets the ticket type in the ticket bulk screen of the agent interface.' =>
            '',
        'Sets the ticket type in the ticket free text screen of the agent interface (Ticket::Type needs to be enabled).' =>
            '',
        'Sets the ticket type in the ticket note screen of the agent interface (Ticket::Type needs to be enabled).' =>
            '',
        'Sets the ticket type in the ticket owner screen of a zoomed ticket in the agent interface (Ticket::Type needs to be enabled).' =>
            '',
        'Sets the ticket type in the ticket pending screen of a zoomed ticket in the agent interface (Ticket::Type needs to be enabled).' =>
            '',
        'Sets the ticket type in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Type needs to be enabled).' =>
            '',
        'Sets the ticket type in the ticket responsible screen of the agent interface (Ticket::Type needs to be enabled).' =>
            '',
        'Sets the time zone being used internally by OTRS to e. g. store dates and times in the database. WARNING: This setting must not be changed once set and tickets or any other data containing date/time have been created.' =>
            '',
        'Sets the time zone that will be assigned to newly created users and will be used for users that haven\'t yet set a time zone. This is the time zone being used as default to convert date and time between the OTRS time zone and the user\'s time zone.' =>
            '',
        'Sets the timeout (in seconds) for http/ftp downloads.' => '',
        'Sets the timeout (in seconds) for package downloads. Overwrites "WebUserAgent::Timeout".' =>
            '',
        'Shared Secret' => 'Gedeelde sleutel',
        'Show a responsible selection in phone and email tickets in the agent interface.' =>
            '',
        'Show article as rich text even if rich text writing is disabled.' =>
            '',
        'Show command line output.' => '',
        'Show queues even when only locked tickets are in.' => '',
        'Show the current owner in the customer interface.' => '',
        'Show the current queue in the customer interface.' => '',
        'Show the history for this ticket' => 'Toon de geschiedenis van dit ticket',
        'Show the ticket history' => 'Toon de ticket-geschiedenis',
        'Shows a count of attachments in the ticket zoom, if the article has attachments.' =>
            '',
        'Shows a link in the menu for creating a calendar appointment linked to the ticket directly from the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
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
        'Shows a teaser link in the menu for the ticket attachment view of OTRS Business Solution™.' =>
            '',
        'Shows all both ro and rw queues in the queue view.' => '',
        'Shows all both ro and rw tickets in the service view.' => '',
        'Shows all open tickets (even if they are locked) in the escalation view of the agent interface.' =>
            'Toont alle geopende tickets (zelfs als deze zijn vergrendeld) in de escalatieweergave van de behandelaar.',
        'Shows all the articles of the ticket (expanded) in the agent zoom view.' =>
            '',
        'Shows all the articles of the ticket (expanded) in the customer zoom view.' =>
            '',
        'Shows all the customer identifiers in a multi-select field (not useful if you have a lot of customer identifiers).' =>
            '',
        'Shows all the customer user identifiers in a multi-select field (not useful if you have a lot of customer user identifiers).' =>
            '',
        'Shows an owner selection in phone and email tickets in the agent interface.' =>
            '',
        'Shows customer history tickets in AgentTicketPhone, AgentTicketEmail and AgentTicketCustomer.' =>
            '',
        'Shows either the last customer article\'s subject or the ticket title in the small format overview.' =>
            '',
        'Shows existing parent/child queue lists in the system in the form of a tree or a list.' =>
            '',
        'Shows information on how to start OTRS Daemon' => '',
        'Shows link to external page in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Shows the article head information in the agent zoom view.' => '',
        'Shows the articles sorted normally or in reverse, under ticket zoom in the agent interface.' =>
            '',
        'Shows the customer user information (phone and email) in the compose screen.' =>
            '',
        'Shows the enabled ticket attributes in the customer interface (0 = Disabled and 1 = Enabled).' =>
            '',
        'Shows the message of the day (MOTD) in the agent dashboard. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
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
        'Shows the title field in the close ticket screen of the agent interface.' =>
            '',
        'Shows the title field in the ticket free text screen of the agent interface.' =>
            '',
        'Shows the title field in the ticket note screen of the agent interface.' =>
            '',
        'Shows the title field in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows the title field in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows the title field in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows the title field in the ticket responsible screen of the agent interface.' =>
            '',
        'Shows time in long format (days, hours, minutes), if enabled; or in short format (days, hours), if not enabled.' =>
            '',
        'Shows time use complete description (days, hours, minutes), if enabled; or just first letter (d, h, m), if not enabled.' =>
            '',
        'Signature data.' => '',
        'Signatures' => 'Handtekeningen',
        'Simple' => '',
        'Skin' => 'Skin',
        'Slovak' => '',
        'Slovenian' => '',
        'Small' => 'Klein',
        'Software Package Manager.' => '',
        'Solution time' => '',
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
        'Specifies the directory to store the data in, if "FS" was selected for ArticleStorage.' =>
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
        'Specifies the group where the user needs rw permissions so that they can edit other users preferences.' =>
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
        'Specifies whether the (MIMEBase) article attachments will be indexed and searchable.' =>
            '',
        'Specify how many sub directory levels to use when creating cache files. This should prevent too many cache files being in one directory.' =>
            '',
        'Specify the channel to be used to fetch OTRS Business Solution™ updates. Warning: Development releases might not be complete, your system might experience unrecoverable errors and on extreme cases could become unresponsive!' =>
            '',
        'Specify the password to authenticate for the first mirror database.' =>
            '',
        'Specify the username to authenticate for the first mirror database.' =>
            '',
        'Stable' => '',
        'Standard available permissions for agents within the application. If more permissions are needed, they can be entered here. Permissions must be defined to be effective. Some other good permissions have also been provided built-in: note, close, pending, customer, freetext, move, compose, responsible, forward, and bounce. Make sure that "rw" is always the last registered permission.' =>
            '',
        'Start number for statistics counting. Every new stat increments this number.' =>
            '',
        'Started response time escalation.' => '',
        'Started solution time escalation.' => '',
        'Started update time escalation.' => '',
        'Starts a wildcard search of the active object after the link object mask is started.' =>
            '',
        'Stat#' => 'Rapport#',
        'States' => 'Status',
        'Statistic Reports overview.' => 'Overzicht van statistische rapporten.',
        'Statistics overview.' => 'Statistieken overzicht.',
        'Status view' => 'Statusoverzicht',
        'Stopped response time escalation.' => '',
        'Stopped solution time escalation.' => '',
        'Stopped update time escalation.' => '',
        'Stores cookies after the browser has been closed.' => '',
        'Strips empty lines on the ticket preview in the queue view.' => '',
        'Strips empty lines on the ticket preview in the service view.' =>
            '',
        'Support Agent' => '',
        'Swahili' => '',
        'Swedish' => '',
        'System Address Display Name' => '',
        'System Configuration Deployment' => '',
        'System Configuration Group' => '',
        'System Maintenance' => 'Systeemonderhoud',
        'Templates ↔ Attachments' => 'Sjablonen ↔ Bijlagen',
        'Templates ↔ Queues' => 'Sjablonen ↔ Wachtrijen',
        'Textarea' => 'Tekstvak',
        'Thai' => '',
        'The PGP signature is expired.' => '',
        'The PGP signature was made by a revoked key, this could mean that the signature is forged.' =>
            '',
        'The PGP signature was made by an expired key.' => '',
        'The PGP signature with the keyid has not been verified successfully.' =>
            '',
        'The PGP signature with the keyid is good.' => '',
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
        'The daemon registration for the system configuration deployment sync manager.' =>
            '',
        'The divider between TicketHook and ticket number. E.g \': \'.' =>
            '',
        'The duration in minutes after emitting an event, in which the new escalation notify and start events are suppressed.' =>
            '',
        'The format of the subject. \'Left\' means \'[TicketHook#:12345] Some Subject\', \'Right\' means \'Some Subject [TicketHook#:12345]\', \'None\' means \'Some Subject\' and no ticket number. In the latter case you should verify that the setting PostMaster::CheckFollowUpModule###0200-References is activated to recognize followups based on email headers.' =>
            '',
        'The headline shown in the customer interface.' => '',
        'The identifier for a ticket, e.g. Ticket#, Call#, MyTicket#. The default is Ticket#.' =>
            '',
        'The logo shown in the header of the agent interface for the skin "High Contrast". See "AgentLogo" for further description.' =>
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
        'The logo shown on top of the login box of the agent interface. The URL to the image can be a relative URL to the skin image directory, or a full URL to a remote web server.' =>
            '',
        'The maximal number of articles expanded on a single page in AgentTicketZoom.' =>
            '',
        'The maximal number of articles shown on a single page in AgentTicketZoom.' =>
            '',
        'The maximum number of mails fetched at once before reconnecting to the server.' =>
            '',
        'The secret you supplied is invalid. The secret must only contain letters (A-Z, uppercase) and numbers (2-7) and must consist of 16 characters.' =>
            'De ingevoerde sleutel is niet juist. De sleutel mag alleen letters (A-Z, a-z) bevatten en moet bestaan uit 16 karakters.',
        'The text at the beginning of the subject in an email reply, e.g. RE, AW, or AS.' =>
            '',
        'The text at the beginning of the subject when an email is forwarded, e.g. FW, Fwd, or WG.' =>
            '',
        'The value of the From field' => '',
        'Theme' => 'Thema',
        'This event module stores attributes from CustomerUser as DynamicFields tickets. Please see DynamicFieldFromCustomerUser::Mapping setting for how to configure the mapping.' =>
            '',
        'This is a Description for Comment on Framework.' => '',
        'This is a Description for DynamicField on Framework.' => '',
        'This is the default orange - black skin for the customer interface.' =>
            '',
        'This is the default orange - black skin.' => '',
        'This key is not certified with a trusted signature!' => '',
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
        'This setting is deprecated. Set OTRSTimeZone instead.' => '',
        'This setting shows the sorting attributes in all overview screen, not only in queue view.' =>
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
        'Ticket Overview "Medium" Limit' => 'Ticket overzicht (middel) limiet',
        'Ticket Overview "Preview" Limit' => 'Ticket overzicht (groot) limiet',
        'Ticket Overview "Small" Limit' => 'Ticket overzicht (klein) limiet',
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
        'Ticket limit per page for Ticket Overview "Medium".' => '',
        'Ticket limit per page for Ticket Overview "Preview".' => '',
        'Ticket limit per page for Ticket Overview "Small".' => '',
        'Ticket notifications' => 'Ticketnotificaties',
        'Ticket overview' => 'Ticketoverzicht',
        'Ticket plain view of an email.' => '',
        'Ticket split dialog.' => '',
        'Ticket title' => '',
        'Ticket zoom view.' => '',
        'TicketNumber' => '',
        'Tickets.' => '',
        'Time in seconds that gets added to the actual time if setting a pending-state (default: 86400 = 1 day).' =>
            '',
        'To accept login information, such as an EULA or license.' => '',
        'To download attachments.' => '',
        'To view HTML attachments.' => '',
        'Toggles display of OTRS FeatureAddons list in PackageManager.' =>
            '',
        'Toolbar Item for a shortcut. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Transport selection for appointment notifications. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Transport selection for ticket notifications. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Tree view' => '',
        'Triggers add or update of automatic calendar appointments based on certain ticket times.' =>
            '',
        'Triggers ticket escalation events and notification events for escalation.' =>
            '',
        'Turkish' => '',
        'Turns off SSL certificate validation, for example if you use a transparent HTTPS proxy. Use at your own risk!' =>
            '',
        'Turns on drag and drop for the main navigation.' => '',
        'Turns on the remote ip address check. It should not be enabled if the application is used, for example, via a proxy farm or a dialup connection, because the remote ip address is mostly different for the requests.' =>
            '',
        'Tweak the system as you wish.' => '',
        'Type of daemon log rotation to use: Choose \'OTRS\' to let OTRS system to handle the file rotation, or choose \'External\' to use a 3rd party rotation mechanism (i.e. logrotate). Note: External rotation mechanism requires its own and independent configuration.' =>
            '',
        'Ukrainian' => '',
        'Unlock tickets that are past their unlock timeout.' => '',
        'Unlock tickets whenever a note is added and the owner is out of office.' =>
            '',
        'Unlocked ticket.' => 'Ticket ontgrendeld.',
        'Up' => 'Boven',
        'Upcoming Events' => 'Aankomende gebeurtenissen',
        'Update Ticket "Seen" flag if every article got seen or a new Article got created.' =>
            '',
        'Update time' => '',
        'Updates the ticket escalation index after a ticket attribute got updated.' =>
            '',
        'Updates the ticket index accelerator.' => '',
        'Upload your PGP key.' => '',
        'Upload your S/MIME certificate.' => '',
        'Use new type of select and autocomplete fields in agent interface, where applicable (InputFields).' =>
            '',
        'Use new type of select and autocomplete fields in customer interface, where applicable (InputFields).' =>
            '',
        'User Profile' => 'Gebruikersprofiel',
        'UserFirstname' => 'UserFirstname',
        'UserLastname' => 'UserLastname',
        'Users, Groups & Roles' => '',
        'Uses richtext for viewing and editing ticket notification.' => 'Gebruik richtext voor het weergeven en bewerken van ticket notificaties.',
        'Uses richtext for viewing and editing: articles, salutations, signatures, standard templates, auto responses and notifications.' =>
            'Gebruik richtext voor het weergeven en bewerken van: artikelen, aanheffen, ondertekeningen, standaard templates, auto antwoorden en notificaties.',
        'Vietnam' => 'Vietnam',
        'View all attachments of the current ticket' => '',
        'View performance benchmark results.' => 'Bekijk resultaten van de performance log.',
        'Watch this ticket' => 'Volg dit ticket',
        'Watched Tickets' => 'Gevolgde tickets',
        'Watched Tickets.' => '',
        'We are performing scheduled maintenance.' => 'Er vindt op dit moment gepland onderhoud plaats.',
        'We are performing scheduled maintenance. Login is temporarily not available.' =>
            'Er vindt op dit moment gepland onderhoud plaats. Inloggen is momenteel niet mogelijk.',
        'We are performing scheduled maintenance. We should be back online shortly.' =>
            'Er vindt op dit moment gepland onderhoud plaats. We zullen snel weer online zijn.',
        'Web Services' => 'Webservices',
        'Web View' => '',
        'When agent creates a ticket, whether or not the ticket is automatically locked to the agent.' =>
            '',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. Here you can define the body of this note (this text cannot be changed by the agent).' =>
            'Wanneer tickets worden samengevoegd, wordt een notitie toegevoegd aan het ticket dat niet meer actief is. Hier kun je de tekst van die notitie toevoegen (deze tekst kan niet worden aangepast door de agent).',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. Here you can define the subject of this note (this subject cannot be changed by the agent).' =>
            '',
        'When tickets are merged, the customer can be informed per email by setting the check box "Inform Sender". In this text area, you can define a pre-formatted text which can later be modified by the agents.' =>
            '',
        'Whether or not to collect meta information from articles using filters configured in Ticket::Frontend::ZoomCollectMetaFilters.' =>
            '',
        'Whether to force redirect all requests from http to https protocol. Please check that your web server is configured correctly for https protocol before enable this option.' =>
            '',
        'Yes, but hide archived tickets' => '',
        'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further information.' =>
            '',
        'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' =>
            'Uw e-mail met ticketnummer "<OTRS_TICKET>" is samengevoegd met "<OTRS_MERGE_TO_TICKET>".',
        'Your queue selection of your preferred queues. You also get notified about those queues via email if enabled.' =>
            '',
        'Your service selection of your preferred services. You also get notified about those services via email if enabled.' =>
            '',
        'Zoom' => 'Inhoud',
        'attachment' => 'bijlage',
        'bounce' => '',
        'compose' => 'opstellen',
        'debug' => '',
        'error' => '',
        'forward' => '',
        'info' => '',
        'inline' => '',
        'normal' => 'normaal',
        'notice' => '',
        'pending' => '',
        'phone' => 'telefoon',
        'responsible' => 'verantwoordelijke',
        'reverse' => 'omgekeerd',
        'stats' => '',

    };

    $Self->{JavaScriptStrings} = [
        ' ...and %s more',
        ' ...show less',
        '%s B',
        '%s GB',
        '%s KB',
        '%s MB',
        '%s TB',
        '+%s more',
        'A key with this name (\'%s\') already exists.',
        'A package upgrade was recently finished. Click here to see the results.',
        'A popup of this screen is already open. Do you want to close it and load this one instead?',
        'A preview of this website can\'t be provided because it didn\'t allow to be embedded.',
        'Add',
        'Add Event Trigger',
        'Add all',
        'Add entry',
        'Add key',
        'Add new draft',
        'Add new entry',
        'Add to favourites',
        'Agent',
        'All occurrences',
        'All-day',
        'An error occurred during communication.',
        'An error occurred! Please check the browser error log for more details!',
        'An item with this name is already present.',
        'An unconnected transition is already placed on the canvas. Please connect this transition first before placing another transition.',
        'An unknown error occurred when deleting the attachment. Please try again. If the error persists, please contact your system administrator.',
        'An unknown error occurred. Please contact the administrator.',
        'Apply',
        'Appointment',
        'Apr',
        'April',
        'Are you sure you want to delete this appointment? This operation cannot be undone.',
        'Are you sure you want to update all installed packages?',
        'Are you using a browser plugin like AdBlock or AdBlockPlus? This can cause several issues and we highly recommend you to add an exception for this domain.',
        'Article display',
        'Article filter',
        'As soon as you use this button or link, you will leave this screen and its current state will be saved automatically. Do you want to continue?',
        'Ascending sort applied, ',
        'Attachment was deleted successfully.',
        'Attachments',
        'Aug',
        'August',
        'Available space %s of %s.',
        'Basic information',
        'By restoring this deployment all settings will be reverted to the value they had at the time of the deployment. Do you really want to continue?',
        'Calendar',
        'Cancel',
        'Cannot proceed',
        'Clear',
        'Clear all',
        'Clear debug log',
        'Clear search',
        'Click to delete this attachment.',
        'Click to select a file for upload.',
        'Click to select a file or just drop it here.',
        'Click to select files or just drop them here.',
        'Clone web service',
        'Close preview',
        'Close this dialog',
        'Complex %s with %s arguments',
        'Confirm',
        'Could not open popup window. Please disable any popup blockers for this application.',
        'Current selection',
        'Currently not possible',
        'Customer interface does not support articles not visible for customers.',
        'Data Protection',
        'Date/Time',
        'Day',
        'Dec',
        'December',
        'Delete',
        'Delete Entity',
        'Delete conditions',
        'Delete draft',
        'Delete error handling module',
        'Delete field',
        'Delete invoker',
        'Delete operation',
        'Delete this Attachment',
        'Delete this Event Trigger',
        'Delete this Invoker',
        'Delete this Key Mapping',
        'Delete this Mail Account',
        'Delete this Operation',
        'Delete this PostMasterFilter',
        'Delete this Template',
        'Delete web service',
        'Deleting attachment...',
        'Deleting the field and its data. This may take a while...',
        'Deleting the mail account and its data. This may take a while...',
        'Deleting the postmaster filter and its data. This may take a while...',
        'Deleting the template and its data. This may take a while...',
        'Deploy',
        'Deploy now',
        'Deploying, please wait...',
        'Deployment comment...',
        'Deployment successful. You\'re being redirected...',
        'Descending sort applied, ',
        'Description',
        'Dismiss',
        'Do not show this warning again.',
        'Do you really want to continue?',
        'Do you really want to delete "%s"?',
        'Do you really want to delete this certificate?',
        'Do you really want to delete this dynamic field? ALL associated data will be LOST!',
        'Do you really want to delete this generic agent job?',
        'Do you really want to delete this key?',
        'Do you really want to delete this link?',
        'Do you really want to delete this notification language?',
        'Do you really want to delete this notification?',
        'Do you really want to delete this scheduled system maintenance?',
        'Do you really want to delete this statistic?',
        'Do you really want to reset this setting to it\'s default value?',
        'Do you really want to revert this setting to its historical value?',
        'Don\'t save, update manually',
        'Draft title',
        'Duplicate event.',
        'Duplicated entry',
        'Edit Field Details',
        'Edit this setting',
        'Edit this transition',
        'End date',
        'Error',
        'Error during AJAX communication',
        'Error during AJAX communication. Status: %s, Error: %s',
        'Error in the mail settings. Please correct and try again.',
        'Error: Browser Check failed!',
        'Event Type Filter',
        'Expanded',
        'Feb',
        'February',
        'Filters',
        'Find out more',
        'Finished',
        'First select a customer user, then select a customer ID to assign to this ticket.',
        'Fr',
        'Fri',
        'Friday',
        'Generate',
        'Generate Result',
        'Generating...',
        'Grouped',
        'Help',
        'Hide EntityIDs',
        'If you now leave this page, all open popup windows will be closed, too!',
        'Import web service',
        'Information about the OTRS Daemon',
        'Invalid date (need a future date)!',
        'Invalid date (need a past date)!',
        'Invalid date!',
        'It is going to be deleted from the field, please try again.',
        'It is not possible to add a new event trigger because the event is not set.',
        'It is not possible to set this entry to invalid. All affected configuration settings have to be changed beforehand.',
        'It was not possible to delete this draft.',
        'It was not possible to generate the Support Bundle.',
        'Jan',
        'January',
        'Jul',
        'July',
        'Jump',
        'Jun',
        'June',
        'Just this occurrence',
        'Keys with values can\'t be renamed. Please remove this key/value pair instead and re-add it afterwards.',
        'Less',
        'Link',
        'Loading, please wait...',
        'Loading...',
        'Location',
        'Mail check successful.',
        'Mapping for Key',
        'Mapping for Key %s',
        'Mar',
        'March',
        'May',
        'May_long',
        'Mo',
        'Mon',
        'Monday',
        'Month',
        'More',
        'Name',
        'Namespace %s could not be initialized, because %s could not be found.',
        'Next',
        'No Data Available.',
        'No TransitionActions assigned.',
        'No data found.',
        'No dialogs assigned yet. Just pick an activity dialog from the list on the left and drag it here.',
        'No matches found.',
        'No package information available.',
        'No response from get package upgrade result.',
        'No response from get package upgrade run status.',
        'No response from package upgrade all.',
        'No sort applied, ',
        'No space left for the following files: %s',
        'Not available',
        'Notice',
        'Notification',
        'Nov',
        'November',
        'OK',
        'Oct',
        'October',
        'One or more errors occurred!',
        'Open URL in new tab',
        'Open date selection',
        'Open this node in a new window',
        'Please add values for all keys before saving the setting.',
        'Please check the fields marked as red for valid inputs.',
        'Please either turn some off first or increase the limit in configuration.',
        'Please enter at least one search value or * to find anything.',
        'Please enter at least one search word to find anything.',
        'Please note that at least one of the settings you have changed requires a page reload. Click here to reload the current screen.',
        'Please only select at most %s files for upload.',
        'Please only select one file for upload.',
        'Please remove the following words from your search as they cannot be searched for:',
        'Please see the documentation or ask your admin for further information.',
        'Please turn off Compatibility Mode in Internet Explorer!',
        'Please wait...',
        'Preparing to deploy, please wait...',
        'Press Ctrl+C (Cmd+C) to copy to clipboard',
        'Previous',
        'Process state',
        'Queues',
        'Reload page',
        'Reload page (%ss)',
        'Remove',
        'Remove Entity from canvas',
        'Remove active filters for this widget.',
        'Remove all user changes.',
        'Remove from favourites',
        'Remove selection',
        'Remove the Transition from this Process',
        'Remove the filter',
        'Remove this dynamic field',
        'Remove this entry',
        'Repeat',
        'Request Details',
        'Request Details for Communication ID',
        'Reset',
        'Reset globally',
        'Reset locally',
        'Reset option is required!',
        'Reset options',
        'Reset setting',
        'Reset setting on global level.',
        'Resource',
        'Resources',
        'Restore default settings',
        'Restore web service configuration',
        'Rule',
        'Running',
        'Sa',
        'Sat',
        'Saturday',
        'Save',
        'Save and update automatically',
        'Scale preview content',
        'Search',
        'Search attributes',
        'Search the System Configuration',
        'Searching for linkable objects. This may take a while...',
        'Select a customer ID to assign to this ticket',
        'Select a customer ID to assign to this ticket.',
        'Select all',
        'Sending Update...',
        'Sep',
        'September',
        'Setting a template will overwrite any text or attachment.',
        'Settings',
        'Show',
        'Show EntityIDs',
        'Show current selection',
        'Show or hide the content.',
        'Slide the navigation bar',
        'Sorry, but you can\'t disable all methods for notifications marked as mandatory.',
        'Sorry, but you can\'t disable all methods for this notification.',
        'Sorry, the only existing condition can\'t be removed.',
        'Sorry, the only existing field can\'t be removed.',
        'Sorry, the only existing parameter can\'t be removed.',
        'Sorry, you can only upload %s files.',
        'Sorry, you can only upload one file here.',
        'Split',
        'Stacked',
        'Start date',
        'Status',
        'Stream',
        'Su',
        'Sun',
        'Sunday',
        'Support Bundle',
        'Support Data information was successfully sent.',
        'Switch to desktop mode',
        'Switch to mobile mode',
        'System Registration',
        'Team',
        'Th',
        'The browser you are using is too old.',
        'The deployment is already running.',
        'The following files are not allowed to be uploaded: %s',
        'The following files exceed the maximum allowed size per file of %s and were not uploaded: %s',
        'The following files were already uploaded and have not been uploaded again: %s',
        'The item you\'re currently viewing is part of a not-yet-deployed configuration setting, which makes it impossible to edit it in its current state. Please wait until the setting has been deployed. If you\'re unsure what to do next, please contact your system administrator.',
        'The key must not be empty.',
        'The mail could not be sent',
        'There are currently no elements available to select from.',
        'There are no more drafts available.',
        'There is a package upgrade process running, click here to see status information about the upgrade progress.',
        'There was an error deleting the attachment. Please check the logs for more information.',
        'There was an error. Please save all settings you are editing and check the logs for more information.',
        'This Activity cannot be deleted because it is the Start Activity.',
        'This Activity is already used in the Process. You cannot add it twice!',
        'This Transition is already used for this Activity. You cannot use it twice!',
        'This TransitionAction is already used in this Path. You cannot use it twice!',
        'This address already exists on the address list.',
        'This element has children elements and can currently not be removed.',
        'This event is already attached to the job, Please use a different one.',
        'This feature is part of the %s. Please contact us at %s for an upgrade.',
        'This field can have no more than 250 characters.',
        'This field is required.',
        'This is %s',
        'This is a repeating appointment',
        'This is currently disabled because of an ongoing package upgrade.',
        'This item still contains sub items. Are you sure you want to remove this item including its sub items?',
        'This option is currently disabled because the OTRS Daemon is not running.',
        'This software runs with a huge lists of browsers, please upgrade to one of these.',
        'This window must be called from compose window.',
        'Thu',
        'Thursday',
        'Timeline Day',
        'Timeline Month',
        'Timeline Week',
        'Title',
        'Today',
        'Too many active calendars',
        'Try again',
        'Tu',
        'Tue',
        'Tuesday',
        'Unfortunately deploying is currently not possible, maybe because another agent is already deploying. Please try again later.',
        'Unknown',
        'Unlock setting.',
        'Update All Packages',
        'Update Result',
        'Update all packages',
        'Update manually',
        'Upload information',
        'Uploading...',
        'Use options below to narrow down for which tickets appointments will be automatically created.',
        'WARNING: When you change the name of the group \'admin\', before making the appropriate changes in the SysConfig, you will be locked out of the administrations panel! If this happens, please rename the group back to admin per SQL statement.',
        'Warning',
        'Was not possible to send Support Data information.',
        'We',
        'Wed',
        'Wednesday',
        'Week',
        'Would you like to edit just this occurrence or all occurrences?',
        'Yes',
        'You can either have the affected settings updated automatically to reflect the changes you just made or do it on your own by pressing \'update manually\'.',
        'You can use the category selection to limit the navigation tree below to entries from the selected category. As soon as you select the category, the tree will be re-built.',
        'You have undeployed settings, would you like to deploy them?',
        'activate to apply a descending sort',
        'activate to apply an ascending sort',
        'activate to remove the sort',
        'and %s more...',
        'day',
        'month',
        'more',
        'no',
        'none',
        'or',
        'sorting is disabled',
        'user(s) have modified this setting.',
        'week',
        'yes',
    ];

    # $$STOP$$
    return;
}

1;
