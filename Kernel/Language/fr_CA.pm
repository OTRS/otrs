# --
# Copyright (C) 2002 Bernard Choppy <choppy at imaginet.fr>
# Copyright (C) 2002 Nicolas Goralski <ngoralski at oceanet-technology.com>
# Copyright (C) 2004 Igor Genibel <igor.genibel at eds-opensource.com>
# Copyright (C) 2007 Remi Seguy <remi.seguy at laposte.net>
# Copyright (C) 2007 Massimiliano Franco <max-lists at ycom.ch>
# Copyright (C) 2004-2008 Yann Richard <ze at nbox.org>
# Copyright (C) 2009-2010 Olivier Sallou <olivier.sallou at irisa.fr>
# Copyright (C) 2013 Evans Bernier <ebernier@libergia.com>
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::fr_CA;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # $$START$$
    # possible charsets
    $Self->{Charset} = ['utf-8', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Year;)
    $Self->{DateFormat}          = '%D.%M.%Y %T';
    $Self->{DateFormatLong}      = '%A %D %B %T %Y';
    $Self->{DateFormatShort}     = '%D.%M.%Y';
    $Self->{DateInputFormat}     = '%D.%M.%Y';
    $Self->{DateInputFormatLong} = '%D.%M.%Y - %T';
    $Self->{Completeness}        = 0.346596681341009;

    # csv separator
    $Self->{Separator}         = ';';

    $Self->{DecimalSeparator}  = ',';
    $Self->{ThousandSeparator} = ' ';
    $Self->{Translation} = {

        # Template: AdminACL
        'ACL Management' => '',
        'Actions' => 'Actions',
        'Create New ACL' => '',
        'Deploy ACLs' => '',
        'Export ACLs' => '',
        'Filter for ACLs' => '',
        'Just start typing to filter...' => 'Commencer à taper pour filtrer...',
        'Configuration Import' => '',
        'Here you can upload a configuration file to import ACLs to your system. The file needs to be in .yml format as exported by the ACL editor module.' =>
            '',
        'This field is required.' => 'Ce champ est requis.',
        'Overwrite existing ACLs?' => '',
        'Upload ACL configuration' => '',
        'Import ACL configuration(s)' => '',
        'Description' => 'Description ',
        'To create a new ACL you can either import ACLs which were exported from another system or create a complete new one.' =>
            '',
        'Changes to the ACLs here only affect the behavior of the system, if you deploy the ACL data afterwards. By deploying the ACL data, the newly made changes will be written to the configuration.' =>
            '',
        'ACLs' => '',
        'Please note: This table represents the execution order of the ACLs. If you need to change the order in which ACLs are executed, please change the names of the affected ACLs.' =>
            '',
        'ACL name' => '',
        'Comment' => 'Commentaire ',
        'Validity' => 'Validité',
        'Export' => 'Exporter',
        'Copy' => '',
        'No data found.' => 'Aucune donnée trouvée.',
        'No matches found.' => 'Aucun résultat.',

        # Template: AdminACLEdit
        'Edit ACL %s' => '',
        'Edit ACL' => '',
        'Go to overview' => 'Aller à la visualisation',
        'Delete ACL' => '',
        'Delete Invalid ACL' => '',
        'Match settings' => '',
        'Set up matching criteria for this ACL. Use \'Properties\' to match the current screen or \'PropertiesDatabase\' to match attributes of the current ticket that are in the database.' =>
            '',
        'Change settings' => '',
        'Set up what you want to change if the criteria match. Keep in mind that \'Possible\' is a white list, \'PossibleNot\' a black list.' =>
            '',
        'Check the official %sdocumentation%s.' => '',
        'Show or hide the content' => 'Montrer ou cacher le contenu',
        'Edit ACL Information' => '',
        'Name' => 'Nom ',
        'Stop after match' => 'Cesser après la correspondance ',
        'Edit ACL Structure' => '',
        'Save ACL' => '',
        'Save' => 'Sauvegarder',
        'or' => 'ou',
        'Save and finish' => 'Sauvegarder et terminer',
        'Cancel' => 'Annuler',
        'Do you really want to delete this ACL?' => '',

        # Template: AdminACLNew
        'Create a new ACL by submitting the form data. After creating the ACL, you will be able to add configuration items in edit mode.' =>
            '',

        # Template: AdminAppointmentCalendarManage
        'Calendar Management' => '',
        'Add Calendar' => '',
        'Edit Calendar' => '',
        'Calendar Overview' => '',
        'Add new Calendar' => '',
        'Import Appointments' => '',
        'Calendar Import' => '',
        'Here you can upload a configuration file to import a calendar to your system. The file needs to be in .yml format as exported by calendar management module.' =>
            '',
        'Overwrite existing entities' => '',
        'Upload calendar configuration' => '',
        'Import Calendar' => '',
        'Filter for Calendars' => '',
        'Filter for calendars' => '',
        'Depending on the group field, the system will allow users the access to the calendar according to their permission level.' =>
            '',
        'Read only: users can see and export all appointments in the calendar.' =>
            '',
        'Move into: users can modify appointments in the calendar, but without changing the calendar selection.' =>
            '',
        'Create: users can create and delete appointments in the calendar.' =>
            '',
        'Read/write: users can manage the calendar itself.' => '',
        'Group' => 'Groupe ajouté ',
        'Changed' => 'Modification le ',
        'Created' => 'Création le ',
        'Download' => 'Téléchargement',
        'URL' => '',
        'Export calendar' => '',
        'Download calendar' => '',
        'Copy public calendar URL' => '',
        'Calendar' => 'Calendrier ',
        'Calendar name' => '',
        'Calendar with same name already exists.' => '',
        'Color' => '',
        'Permission group' => '',
        'Ticket Appointments' => '',
        'Rule' => '',
        'Remove this entry' => 'Supprimer cette entrée',
        'Remove' => 'Supprimer',
        'Start date' => '',
        'End date' => '',
        'Use options below to narrow down for which tickets appointments will be automatically created.' =>
            '',
        'Queues' => 'Files',
        'Please select a valid queue.' => '',
        'Search attributes' => '',
        'Add entry' => 'Ajouter une entrée',
        'Add' => 'Ajouter ',
        'Define rules for creating automatic appointments in this calendar based on ticket data.' =>
            '',
        'Add Rule' => '',
        'Submit' => 'Soumettre',

        # Template: AdminAppointmentImport
        'Appointment Import' => '',
        'Go back' => '',
        'Uploaded file must be in valid iCal format (.ics).' => '',
        'If desired Calendar is not listed here, please make sure that you have at least \'create\' permissions.' =>
            '',
        'Upload' => 'Télécharger',
        'Update existing appointments?' => '',
        'All existing appointments in the calendar with same UniqueID will be overwritten.' =>
            '',
        'Upload calendar' => '',
        'Import appointments' => '',

        # Template: AdminAppointmentNotificationEvent
        'Appointment Notification Management' => '',
        'Add Notification' => 'Ajouter une notification',
        'Edit Notification' => 'Éditer une notification',
        'Export Notifications' => '',
        'Filter for Notifications' => '',
        'Filter for notifications' => '',
        'Here you can upload a configuration file to import appointment notifications to your system. The file needs to be in .yml format as exported by the appointment notification module.' =>
            '',
        'Overwrite existing notifications?' => '',
        'Upload Notification configuration' => '',
        'Import Notification configuration' => '',
        'List' => 'Liste',
        'Delete' => 'Supprimer',
        'Delete this notification' => 'Supprimer cette notification',
        'Show in agent preferences' => '',
        'Agent preferences tooltip' => '',
        'This message will be shown on the agent preferences screen as a tooltip for this notification.' =>
            '',
        'Toggle this widget' => 'Basculer vers ce gadget',
        'Events' => 'Évènements',
        'Event' => 'Évènement ',
        'Here you can choose which events will trigger this notification. An additional appointment filter can be applied below to only send for appointments with certain criteria.' =>
            '',
        'Appointment Filter' => '',
        'Type' => 'Type ',
        'Title' => 'Titre ',
        'Location' => 'Localisation',
        'Team' => '',
        'Resource' => '',
        'Recipients' => '',
        'Send to' => '',
        'Send to these agents' => '',
        'Send to all group members (agents only)' => '',
        'Send to all role members' => '',
        'Send on out of office' => '',
        'Also send if the user is currently out of office.' => '',
        'Once per day' => '',
        'Notify user just once per day about a single appointment using a selected transport.' =>
            '',
        'Notification Methods' => '',
        'These are the possible methods that can be used to send this notification to each of the recipients. Please select at least one method below.' =>
            '',
        'Enable this notification method' => '',
        'Transport' => '',
        'At least one method is needed per notification.' => '',
        'Active by default in agent preferences' => '',
        'This is the default value for assigned recipient agents who didn\'t make a choice for this notification in their preferences yet. If the box is enabled, the notification will be sent to such agents.' =>
            '',
        'This feature is currently not available.' => '',
        'Upgrade to %s' => '',
        'Please activate this transport in order to use it.' => '',
        'No data found' => '',
        'No notification method found.' => '',
        'Notification Text' => '',
        'This language is not present or enabled on the system. This notification text could be deleted if it is not needed anymore.' =>
            '',
        'Remove Notification Language' => '',
        'Subject' => 'Objet ',
        'Text' => 'Texte ',
        'Message body' => 'Corps du message',
        'Add new notification language' => '',
        'Save Changes' => 'Sauvegarder les modifications',
        'Tag Reference' => '',
        'Notifications are sent to an agent.' => '',
        'You can use the following tags' => 'Vous pouvez utiliser les codets suivants ',
        'To get the first 20 character of the appointment title.' => '',
        'To get the appointment attribute' => '',
        ' e. g.' => ' p. ex.',
        'To get the calendar attribute' => '',
        'Attributes of the recipient user for the notification' => '',
        'Config options' => 'Options de configuration',
        'Example notification' => '',

        # Template: AdminAppointmentNotificationEventTransportEmailSettings
        'Additional recipient email addresses' => '',
        'This field must have less then 200 characters.' => '',
        'Article visible for customer' => '',
        'An article will be created if the notification is sent to the customer or an additional email address.' =>
            '',
        'Email template' => '',
        'Use this template to generate the complete email (only for HTML emails).' =>
            '',
        'Enable email security' => '',
        'Email security level' => '',
        'If signing key/certificate is missing' => '',
        'If encryption key/certificate is missing' => '',

        # Template: AdminAttachment
        'Attachment Management' => 'Gestion des pièces jointes',
        'Add Attachment' => 'Ajouter une pièce jointe',
        'Edit Attachment' => 'Éditer une pièce jointe',
        'Filter for Attachments' => 'Filtre pour les pièces jointes',
        'Filter for attachments' => '',
        'Filename' => 'Nom de fichier',
        'Download file' => 'Télécharger le fichier',
        'Delete this attachment' => 'Supprimer la pièce jointe',
        'Do you really want to delete this attachment?' => '',
        'Attachment' => 'Pièce jointe ',

        # Template: AdminAutoResponse
        'Auto Response Management' => 'Gestion des réponses automatiques',
        'Add Auto Response' => 'Ajouter une réponse automatique',
        'Edit Auto Response' => 'Éditer une réponse automatique',
        'Filter for Auto Responses' => 'Filtre pour les réponses automatiques',
        'Filter for auto responses' => '',
        'Response' => 'Réponse ',
        'Auto response from' => 'Réponse automatique de ',
        'Reference' => 'Référence',
        'To get the first 20 character of the subject.' => 'Pour avoir les 20 premiers caractères du sujet.',
        'To get the first 5 lines of the email.' => 'Pour avoir les 5 premières lignes du courriel.',
        'To get the name of the ticket\'s customer user (if given).' => '',
        'To get the article attribute' => 'Pour avoir l\'attribut de l\'article',
        'Options of the current customer user data' => 'Options des données du client actuel',
        'Ticket owner options' => 'Options du propriétaire de la demande',
        'Ticket responsible options' => 'Options du responsable de la demande',
        'Options of the current user who requested this action' => 'Options de l\'utilisateur actuel qui a demandé cette action',
        'Options of the ticket data' => 'Options des données de la demande',
        'Options of ticket dynamic fields internal key values' => '',
        'Options of ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            '',
        'Example response' => 'Exemple de réponse ',

        # Template: AdminCloudServiceSupportDataCollector
        'Cloud Service Management' => '',
        'Support Data Collector' => '',
        'Support data collector' => '',
        'Hint' => 'Conseil',
        'Currently support data is only shown in this system.' => '',
        'It is highly recommended to send this data to OTRS Group in order to get better support.' =>
            '',
        'Configuration' => '',
        'Send support data' => '',
        'This will allow the system to send additional support data information to OTRS Group.' =>
            '',
        'Update' => 'Mettre à jour',
        'System Registration' => '',
        'To enable data sending, please register your system with OTRS Group or update your system registration information (make sure to activate the \'send support data\' option.)' =>
            '',
        'Register this System' => '',
        'System Registration is disabled for your system. Please check your configuration.' =>
            '',

        # Template: AdminCloudServices
        'System registration is a service of OTRS Group, which provides a lot of advantages!' =>
            '',
        'Please note that the use of OTRS cloud services requires the system to be registered.' =>
            '',
        'Register this system' => '',
        'Here you can configure available cloud services that communicate securely with %s.' =>
            '',
        'Available Cloud Services' => '',

        # Template: AdminCommunicationLog
        'Communication Log' => '',
        'Time Range' => '',
        'Show only communication logs created in specific time range.' =>
            '',
        'Filter for Communications' => '',
        'Filter for communications' => '',
        'In this screen you can see an overview about incoming and outgoing communications.' =>
            '',
        'You can change the sort and order of the columns by clicking on the column header.' =>
            '',
        'If you click on the different entries, you will get redirected to a detailed screen about the message.' =>
            '',
        'Status for: %s' => '',
        'Failing accounts' => '',
        'Some account problems' => '',
        'No account problems' => '',
        'No account activity' => '',
        'Number of accounts with problems: %s' => '',
        'Number of accounts with warnings: %s' => '',
        'Failing communications' => '',
        'No communication problems' => '',
        'No communication logs' => '',
        'Number of reported problems: %s' => '',
        'Open communications' => '',
        'No active communications' => '',
        'Number of open communications: %s' => '',
        'Average processing time' => '',
        'List of communications (%s)' => '',
        'Settings' => 'Paramètres',
        'Entries per page' => '',
        'No communications found.' => '',
        '%s s' => '',

        # Template: AdminCommunicationLogAccounts
        'Account Status' => '',
        'Back to overview' => '',
        'Filter for Accounts' => '',
        'Filter for accounts' => '',
        'You can change the sort and order of those columns by clicking on the column header.' =>
            '',
        'Account status for: %s' => '',
        'Status' => 'État ',
        'Account' => '',
        'Edit' => 'Éditer ',
        'No accounts found.' => '',
        'Communication Log Details (%s)' => '',
        'Direction' => 'Direction',
        'Start Time' => '',
        'End Time' => '',
        'No communication log entries found.' => '',

        # Template: AdminCommunicationLogCommunications
        'Duration' => '',

        # Template: AdminCommunicationLogObjectLog
        '#' => '',
        'Priority' => 'Priorité ',
        'Module' => 'Module ',
        'Information' => '',
        'No log entries found.' => '',

        # Template: AdminCommunicationLogZoom
        'Detail view for %s communication started at %s' => '',
        'Filter for Log Entries' => '',
        'Filter for log entries' => '',
        'Show only entries with specific priority and higher:' => '',
        'Communication Log Overview (%s)' => '',
        'No communication objects found.' => '',
        'Communication Log Details' => '',
        'Please select an entry from the list.' => '',

        # Template: AdminCustomerCompany
        'Customer Management' => 'Gestion des clients',
        'Add Customer' => 'Ajouter un client',
        'Edit Customer' => 'Éditer les renseignements du client',
        'Search' => 'Recherche',
        'Wildcards like \'*\' are allowed.' => 'Les caractères génériques tels que \'*\' sont autorisés.',
        'Select' => 'Sélectionner',
        'List (only %s shown - more available)' => '',
        'total' => '',
        'Please enter a search term to look for customers.' => 'Pour trouver des clients, inscrire un terme de recherche.',
        'Customer ID' => 'Identité du client',
        'Please note' => '',
        'This customer backend is read only!' => '',

        # Template: AdminCustomerGroup
        'Manage Customer-Group Relations' => 'Gestion des relations avec les groupes de clients',
        'Notice' => 'Avis',
        'This feature is disabled!' => 'Cette fonctionnalité est désactivée.',
        'Just use this feature if you want to define group permissions for customers.' =>
            'Cette fonctionnalité permet de donner des permissions à des groupes de clients.',
        'Enable it here!' => 'Activez-la ici',
        'Edit Customer Default Groups' => 'Editer les groupes par défault client',
        'These groups are automatically assigned to all customers.' => 'Ces groupes sont automatiquement assignés à tous les clients',
        'You can manage these groups via the configuration setting "CustomerGroupCompanyAlwaysGroups".' =>
            '',
        'Filter for Groups' => 'Filtre pour les groupes',
        'Select the customer:group permissions.' => 'Sélectionner les permissions pour les clients et pour les groupes.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer).' =>
            'Si rien n\'est sélectionné, aucune permission ne sera accordée à ce groupe (les clients n\'auront pas accès aux demandes).',
        'Search Results' => 'Résultat de recherche',
        'Customers' => 'Clients',
        'Groups' => 'Groupes',
        'Change Group Relations for Customer' => 'Modifier les relations du groupe pour le client',
        'Change Customer Relations for Group' => 'Modifier les relations du client pour le groupe',
        'Toggle %s Permission for all' => 'Sélectionner la Permission %s pour tous',
        'Toggle %s permission for %s' => 'Sélectionner la permission %s pour %s',
        'Customer Default Groups:' => 'Groupes par défaut du client :',
        'No changes can be made to these groups.' => 'Aucun changement n\'est possible pour ces groupes.',
        'ro' => 'Lecture seule',
        'Read only access to the ticket in this group/queue.' => 'Accès en lecture seule aux demandes de cette file ou ce groupe.',
        'rw' => 'Lecture et écriture',
        'Full read and write access to the tickets in this group/queue.' =>
            'Accès complet en lecture et écriture aux demandes de cette file ou ce groupe.',

        # Template: AdminCustomerUser
        'Customer User Management' => 'Gestion des clients',
        'Add Customer User' => 'Ajouter un client',
        'Edit Customer User' => '',
        'Back to search results' => 'Retour aux résultats de la recherche',
        'Customer user are needed to have a customer history and to login via customer panel.' =>
            'Un client utilisateur doit exister si on veut consulter son historique et pour qu\'il puisse se connecter via le portail client.',
        'List (%s total)' => '',
        'Username' => 'Nom d\'utilisateur ',
        'Email' => 'Courriel ',
        'Last Login' => 'Dernière connexion',
        'Login as' => 'Connecté en tant que',
        'Switch to customer' => '',
        'This customer backend is read only, but the customer user preferences can be changed!' =>
            '',
        'This field is required and needs to be a valid email address.' =>
            'Le champ est obligatoire et l\'adresse de courrier électronique doit être valide.',
        'This email address is not allowed due to the system configuration.' =>
            'L\'adresse de courrier électronique n\'est pas autorisée selon la configuration du système.',
        'This email address failed MX check.' => 'L\'adresse de courrier électronique n\'est pas conforme.',
        'DNS problem, please check your configuration and the error log.' =>
            'Il y a un problème avec le système DNS, veuillez vérifier la configuration et le journal des erreurs.',
        'The syntax of this email address is incorrect.' => 'La syntaxe de cette adresse électronique est incorrecte.',
        'This CustomerID is invalid.' => '',
        'Effective Permissions for Customer User' => '',
        'Group Permissions' => '',
        'This customer user has no group permissions.' => '',
        'Table above shows effective group permissions for the customer user. The matrix takes into account all inherited permissions (e.g. via customer groups). Note: The table does not consider changes made to this form without submitting it.' =>
            '',
        'Customer Access' => '',
        'Customer' => 'Client ',
        'This customer user has no customer access.' => '',
        'Table above shows granted customer access for the customer user by permission context. The matrix takes into account all inherited access (e.g. via customer groups). Note: The table does not consider changes made to this form without submitting it.' =>
            '',

        # Template: AdminCustomerUserCustomer
        'Manage Customer User-Customer Relations' => '',
        'Select the customer user:customer relations.' => '',
        'Customer Users' => 'Clients utilisateurs',
        'Change Customer Relations for Customer User' => '',
        'Change Customer User Relations for Customer' => '',
        'Toggle active state for all' => 'Sélectionner l\'état actif pour tous',
        'Active' => 'Activer',
        'Toggle active state for %s' => 'Sélectionner un état actif pour %s',

        # Template: AdminCustomerUserGroup
        'Manage Customer User-Group Relations' => '',
        'Just use this feature if you want to define group permissions for customer users.' =>
            '',
        'Edit Customer User Default Groups' => '',
        'These groups are automatically assigned to all customer users.' =>
            '',
        'You can manage these groups via the configuration setting "CustomerGroupAlwaysGroups".' =>
            'Faites la gestion de ces groupes au moyen',
        'Filter for groups' => '',
        'Select the customer user - group permissions.' => '',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer user).' =>
            '',
        'Customer User Default Groups:' => '',

        # Template: AdminCustomerUserService
        'Manage Customer User-Service Relations' => '',
        'Edit default services' => 'Éditer les services par défaut',
        'Filter for Services' => 'Filtre pour les services',
        'Filter for services' => '',
        'Services' => 'Services',

        # Template: AdminDynamicField
        'Dynamic Fields Management' => 'Gestion des champs dynamiques',
        'Add new field for object' => 'Ajouter un nouveau champ pour l\'objet ',
        'Filter for Dynamic Fields' => '',
        'Filter for dynamic fields' => '',
        'More Business Fields' => '',
        'Would you like to benefit from additional dynamic field types for businesses? Upgrade to %s to get access to the following field types:' =>
            '',
        'Database' => 'Base de données',
        'Use external databases as configurable data sources for this dynamic field.' =>
            '',
        'Web service' => '',
        'External web services can be configured as data sources for this dynamic field.' =>
            '',
        'Contact with data' => '',
        'This feature allows to add (multiple) contacts with data to tickets.' =>
            '',
        'To add a new field, select the field type from one of the object\'s list, the object defines the boundary of the field and it can\'t be changed after the field creation.' =>
            '',
        'Dynamic Fields List' => 'Liste des champs dynamiques',
        'Dynamic fields per page' => 'Nombre de champs dynamiques par page ',
        'Label' => 'Étiquette ',
        'Order' => 'Ordre',
        'Object' => 'Objet ',
        'Delete this field' => 'Effacer ce champ',

        # Template: AdminDynamicFieldCheckbox
        'Dynamic Fields' => 'Champs dynamiques',
        'Go back to overview' => 'Retour à la visualisation',
        'General' => 'Généralités',
        'This field is required, and the value should be alphabetic and numeric characters only.' =>
            'Ce champ est requis et sa valeur doit être composée de caractères alphabétiques et numériques seulement.',
        'Must be unique and only accept alphabetic and numeric characters.' =>
            'Le nom doit être unique et composé seulement de caractères alphabétiques et numériques.',
        'Changing this value will require manual changes in the system.' =>
            'Changer cette valeur exige également des changements manuels dans le système.',
        'This is the name to be shown on the screens where the field is active.' =>
            'L\'étiquette porte le nom qui sera affiché sur les écrans où le champ est actif.',
        'Field order' => 'Ordre du champ ',
        'This field is required and must be numeric.' => 'Ce champ est requis et doit être composé de caractères numériques.',
        'This is the order in which this field will be shown on the screens where is active.' =>
            'L\'affichage sur les écrans où le champ est actif respectera l\'ordre choisi.',
        'Is not possible to invalidate this entry, all config settings have to be changed beforehand.' =>
            '',
        'Field type' => 'Type de champ ',
        'Object type' => 'Type d\'objet ',
        'Internal field' => '',
        'This field is protected and can\'t be deleted.' => '',
        'This dynamic field is used in the following config settings:' =>
            '',
        'Field Settings' => ': Réglage du champ',
        'Default value' => 'Valeur par défaut ',
        'This is the default value for this field.' => 'La valeur par défaut est spécifiquement pour ce champ.',

        # Template: AdminDynamicFieldDateTime
        'Default date difference' => 'Différence entre la date actuelle et le date affichée ',
        'This field must be numeric.' => 'Ce champ doit être composé de caractères numériques',
        'The difference from NOW (in seconds) to calculate the field default value (e.g. 3600 or -60).' =>
            'Inscrivez la différence par défaut (en secondes) entre la date actuelle et la date sélectionnée qui doit être affichée dans les écrans d\'éditions (ex. 3600 ou -60).',
        'Define years period' => 'Période déterminée (en années) ',
        'Activate this feature to define a fixed range of years (in the future and in the past) to be displayed on the year part of the field.' =>
            ' Activez cette fonctionnalité afin de fixer le nombre d\'années devant être affiché (dans le futur et dans le passé) à l\'intérieur de la section « année » du champ.',
        'Years in the past' => 'années passées',
        'Years in the past to display (default: 5 years).' => 'années passées à afficher (par défaut, 5 années)',
        'Years in the future' => 'Années futures',
        'Years in the future to display (default: 5 years).' => 'Années futures à afficher (par défaut, 5 années)',
        'Show link' => 'Montrer le lien ',
        'Here you can specify an optional HTTP link for the field value in Overviews and Zoom screens.' =>
            'Vous pouvez ajouter un lien HTTP optionel dans le champ « valeur » des écrans de visualisation et de synthèse.',
        'If special characters (&, @, :, /, etc.) should not be encoded, use \'url\' instead of \'uri\' filter.' =>
            '',
        'Example' => 'Exemple ',
        'Link for preview' => '',
        'If filled in, this URL will be used for a preview which is shown when this link is hovered in ticket zoom. Please note that for this to work, the regular URL field above needs to be filled in, too.' =>
            '',
        'Restrict entering of dates' => '',
        'Here you can restrict the entering of dates of tickets.' => '',

        # Template: AdminDynamicFieldDropdown
        'Possible values' => 'Valeurs possibles ',
        'Key' => 'Clé ',
        'Value' => 'Valeur ',
        'Remove value' => 'Retirer la valeur',
        'Add value' => 'Ajouter une valeur ',
        'Add Value' => 'Ajouter une valeur',
        'Add empty value' => 'Ajouter une valeur sans contenu ',
        'Activate this option to create an empty selectable value.' => 'Pour créer une valeur sans contenu, activer cette option.',
        'Tree View' => '',
        'Activate this option to display values as a tree.' => '',
        'Translatable values' => 'Valeurs traduisibles ',
        'If you activate this option the values will be translated to the user defined language.' =>
            'Pour que le contenu des valeurs soit traduit dans la langue définie par l\'utilisateur, activez cette option.',
        'Note' => 'Note ',
        'You need to add the translations manually into the language translation files.' =>
            'Vous devez traduire vous-même le contenu dans les fichiers de traduction.',

        # Template: AdminDynamicFieldText
        'Number of rows' => 'Nombre de rangées ',
        'Specify the height (in lines) for this field in the edit mode.' =>
            'Précisez la hauteur de ce champ (en nombre de lignes), présent lors de l\'édition.',
        'Number of cols' => 'Nombre de colonnes ',
        'Specify the width (in characters) for this field in the edit mode.' =>
            'Précisez la largeur de ce champ (en nombre de caractères), présent lors de l\'édition.',
        'Check RegEx' => '',
        'Here you can specify a regular expression to check the value. The regex will be executed with the modifiers xms.' =>
            '',
        'RegEx' => '',
        'Invalid RegEx' => '',
        'Error Message' => 'Message d\'erreur ',
        'Add RegEx' => '',

        # Template: AdminEmail
        'Admin Message' => '',
        'With this module, administrators can send messages to agents, group or role members.' =>
            'Le présent module permet aux administrateurs d\'envoyer des messages aux agents, aux groupes et aux autres membres du même rôle.',
        'Create Administrative Message' => 'Création d\'un message de l\'administrateur',
        'Your message was sent to' => 'Votre message a été envoyé à',
        'From' => 'De ',
        'Send message to users' => 'Envoyer un message aux utilisateurs ',
        'Send message to group members' => 'Envoyer un message aux membres du groupe ',
        'Group members need to have permission' => 'Préciser la permission accordée aux membres du groupe ',
        'Send message to role members' => 'Envoyer un message aux membres de ce rôle ',
        'Also send to customers in groups' => 'Aussi envoyer aux clients dans les groupes',
        'Body' => 'Corps ',
        'Send' => 'Envoyer',

        # Template: AdminGenericAgent
        'Generic Agent Job Management' => '',
        'Edit Job' => '',
        'Add Job' => '',
        'Run Job' => '',
        'Filter for Jobs' => '',
        'Filter for jobs' => '',
        'Last run' => 'Dernière utilisation',
        'Run Now!' => 'Démarrer maintenant',
        'Delete this task' => 'Supprimer cette tâche',
        'Run this task' => 'Exécuter cette tâche',
        'Job Settings' => 'Configuration de la tâche',
        'Job name' => 'Nom de la tâche ',
        'The name you entered already exists.' => 'Le nom que vous avez entré existe déjà.',
        'Automatic Execution (Multiple Tickets)' => '',
        'Execution Schedule' => '',
        'Schedule minutes' => 'Minutes ',
        'Schedule hours' => 'Heures ',
        'Schedule days' => 'Jour ',
        'Automatic execution values are in the system timezone.' => '',
        'Currently this generic agent job will not run automatically.' =>
            'L\'agent générique ne s\'exécutera pas automatiquement.',
        'To enable automatic execution select at least one value from minutes, hours and days!' =>
            'Pour permettre l\'exécution automatique, sélectionnez au moins une valeur dans les champs « minutes », « heures » et « jours ».',
        'Event Based Execution (Single Ticket)' => '',
        'Event Triggers' => 'Déclencheurs d\'évènements',
        'List of all configured events' => '',
        'Delete this event' => 'Supprimer cet évènement',
        'Additionally or alternatively to a periodic execution, you can define ticket events that will trigger this job.' =>
            '',
        'If a ticket event is fired, the ticket filter will be applied to check if the ticket matches. Only then the job is run on that ticket.' =>
            '',
        'Do you really want to delete this event trigger?' => 'Voulez-vous vraiment supprimer ce déclencheur d\'évènements?',
        'Add Event Trigger' => 'Ajouter un déclencheur d\'évènements',
        'To add a new event select the event object and event name' => '',
        'Select Tickets' => '',
        '(e. g. 10*5155 or 105658*)' => '(ex. : 10*5155 ou 105658*) ',
        '(e. g. 234321)' => '(ex. : 234321) ',
        'Customer user ID' => '',
        '(e. g. U5150)' => '(ex. : U5150) ',
        'Fulltext-search in article (e. g. "Mar*in" or "Baue*").' => 'Recherche plein texte dans l\'article (ex. "Valérie*m" ou "Eco*").',
        'To' => 'À ',
        'Cc' => 'Copie ',
        'Service' => 'Service ',
        'Service Level Agreement' => 'Accord sur les niveaux de service',
        'Queue' => 'File ',
        'State' => 'État ',
        'Agent' => 'Agent',
        'Owner' => 'Propriétaire ',
        'Responsible' => 'Responsable',
        'Ticket lock' => 'Verrou ',
        'Dynamic fields' => '',
        'Add dynamic field' => '',
        'Create times' => 'Date de création ',
        'No create time settings.' => 'Ne pas utiliser la date de création des demandes.',
        'Ticket created' => 'Demandes créées entre le',
        'Ticket created between' => 'Demandes créées entre le',
        'and' => 'et le',
        'Last changed times' => '',
        'No last changed time settings.' => '',
        'Ticket last changed' => '',
        'Ticket last changed between' => '',
        'Change times' => 'Date de modification ',
        'No change time settings.' => 'Ne pas utiliser la date de modification des demandes.',
        'Ticket changed' => 'Demandes modifiées',
        'Ticket changed between' => 'Demandes modifiées entre le',
        'Last close times' => '',
        'No last close time settings.' => '',
        'Ticket last close' => '',
        'Ticket last close between' => '',
        'Close times' => 'Date de fermeture ',
        'No close time settings.' => 'Ne pas utiliser la date de fermeture des demandes.',
        'Ticket closed' => 'Demandes fermées',
        'Ticket closed between' => 'Demandes fermées entre le',
        'Pending times' => 'Date d\'échéance ',
        'No pending time settings.' => 'Ne pas utiliser la date d\'échéance des demandes.',
        'Ticket pending time reached' => 'Dates d\'échéance atteintes',
        'Ticket pending time reached between' => 'Dates d\'échéance atteintes entre le',
        'Escalation times' => 'Date de l\'escalade ',
        'No escalation time settings.' => 'Ne pas utiliser la date de l\'escalade des demandes.',
        'Ticket escalation time reached' => 'Date d\'échéance des demandes atteinte',
        'Ticket escalation time reached between' => 'Date d\'échéance des demandes atteinte entre le',
        'Escalation - first response time' => 'Escalade - délai de la première réponse ',
        'Ticket first response time reached' => 'Délai de la première réponse atteint',
        'Ticket first response time reached between' => 'Délai de la première réponse atteint entre le',
        'Escalation - update time' => 'Escalade - délai de mise à jour ',
        'Ticket update time reached' => 'Délai de mise à jour des demandes atteint',
        'Ticket update time reached between' => 'Délai de mise à jour des demandes atteint entre le',
        'Escalation - solution time' => 'Escalade - délai de résolution ',
        'Ticket solution time reached' => 'Temps de résolution des demandes atteint',
        'Ticket solution time reached between' => 'Temps de résolution des demandes atteint entre le',
        'Archive search option' => 'Option de recherche dans les archives',
        'Update/Add Ticket Attributes' => '',
        'Set new service' => 'Définir un nouveau service',
        'Set new Service Level Agreement' => 'Définir un nouveau contrat de niveau de support',
        'Set new priority' => 'Fixer une nouvelle priorité ',
        'Set new queue' => 'Déterminer une nouvelle file ',
        'Set new state' => 'Déterminer un nouvel état ',
        'Pending date' => 'Délai d\'attente ',
        'Set new agent' => 'Déterminer un nouvel agent',
        'new owner' => 'nouveau propriétaire ',
        'new responsible' => 'nouveau responsable',
        'Set new ticket lock' => 'Fixer un nouveau verrou sur la demande ',
        'New customer user ID' => '',
        'New customer ID' => 'Nouvel identifiant du client ',
        'New title' => 'Nouveau titre ',
        'New type' => 'Nouveau type',
        'Archive selected tickets' => 'Archiver les demandes sélectionnées',
        'Add Note' => 'Ajouter une note',
        'Visible for customer' => '',
        'Time units' => 'Unité de temps',
        'Execute Ticket Commands' => '',
        'Send agent/customer notifications on changes' => 'Envoyer des notifications aux agents et aux clients visés lors de changements ',
        'CMD' => 'Directive ',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' =>
            'La directive sera exécutée. Le numéro de la demande est ARG[0] et son identifiant est ARG[1].',
        'Delete tickets' => 'Supprimer les demandes ',
        'Warning: All affected tickets will be removed from the database and cannot be restored!' =>
            'Avertissement : Les demandes concernées seront supprimées de la base de données et ne pourront être restaurées.',
        'Execute Custom Module' => 'Exécuter le module client',
        'Param %s key' => 'Clé du paramètre %s ',
        'Param %s value' => 'Valeur du paramètre %s ',
        'Results' => 'Résultats',
        '%s Tickets affected! What do you want to do?' => '%s demandes touchées. Que voulez vous faire?',
        'Warning: You used the DELETE option. All deleted tickets will be lost!' =>
            'Avertissement : Vous avez utilisé l\'option « supprimé ». Toutes les demandes effacés seront perdues!',
        'Warning: There are %s tickets affected but only %s may be modified during one job execution!' =>
            '',
        'Affected Tickets' => 'Demandes touchées',
        'Age' => 'Âge ',

        # Template: AdminGenericInterfaceDebugger
        'GenericInterface Web Service Management' => 'Gestion des services Web de l\'interface générique',
        'Web Service Management' => '',
        'Debugger' => 'Débogueur',
        'Go back to web service' => 'Retourner au service web',
        'Clear' => 'Supprimer',
        'Do you really want to clear the debug log of this web service?' =>
            'Voulez-vous vraiment supprimer l\'enregistrement de débogage de ce service Web?',
        'Request List' => 'Liste de demandes',
        'Time' => 'Date et heure',
        'Communication ID' => '',
        'Remote IP' => 'Fournisseur d\'information à distance',
        'Loading' => 'En cours de chargement',
        'Select a single request to see its details.' => 'Sélectionnez une demande pour voir l\'information s\'y rattachant.',
        'Filter by type' => 'Filtrer par type ',
        'Filter from' => 'Filtrer à partir de ',
        'Filter to' => 'Filtrer jusqu\'au ',
        'Filter by remote IP' => 'Filtrer par fournisseur d\'information à distance ',
        'Limit' => 'Limite ',
        'Refresh' => 'Rafraîchir',

        # Template: AdminGenericInterfaceErrorHandlingDefault
        'Add ErrorHandling' => '',
        'Edit ErrorHandling' => '',
        'Do you really want to delete this error handling module?' => '',
        'All configuration data will be lost.' => 'Tous les paramètres seront perdus.',
        'General options' => '',
        'The name can be used to distinguish different error handling configurations.' =>
            '',
        'Please provide a unique name for this web service.' => 'Veuillez fournir un nom unique pour ce service Web.',
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
        'Error message content filter' => '',
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
        'Error code' => '',
        'An error identifier for this error handling module.' => '',
        'This identifier will be available in XSLT-Mapping and shown in debugger output.' =>
            '',
        'Error message' => '',
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
        'Do you really want to delete this invoker?' => 'Voulez-vous vraiment supprimer ce demandeur?',
        'Invoker Details' => 'Détails du demandeur',
        'The name is typically used to call up an operation of a remote web service.' =>
            'Le nom est généralement utilisé pour appeler l\'opération d\'un service Web à distance.',
        'Invoker backend' => 'Arrière-plan du demandeur',
        'This OTRS invoker backend module will be called to prepare the data to be sent to the remote system, and to process its response data.' =>
            'Le module de OTRS comprenant l\'arrière-plan du demandeur traitera les données envoyées au système distant ainsi que celles composant la réponse.',
        'Mapping for outgoing request data' => 'Mappage des données des requêtes sortantes',
        'Configure' => 'Configurer',
        'The data from the invoker of OTRS will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            'Les données du demandeur de OTRS seront traitées lors du mappage; elles seront converties pour le système distant.',
        'Mapping for incoming response data' => 'Mappage des données composant les réponses entrantes',
        'The response data will be processed by this mapping, to transform it to the kind of data the invoker of OTRS expects.' =>
            'Les données composant les réponses seront traitées lors du mappage; elles seront converties pour le demandeur de OTRS.',
        'Asynchronous' => 'Asynchrone',
        'Condition' => '',
        'Edit this event' => '',
        'This invoker will be triggered by the configured events.' => 'Les évènements configurés déclencheront le demandeur.',
        'Add Event' => '',
        'To add a new event select the event object and event name and click on the "+" button' =>
            'Pour ajouter un nouvel évènement, sélectionnez l\'objet et le nom de l\'évènement puis cliquez sur le bouton « + » ',
        'Asynchronous event triggers are handled by the OTRS Scheduler Daemon in background (recommended).' =>
            '',
        'Synchronous event triggers would be processed directly during the web request.' =>
            'Les déclencheurs d\'évènements synchrones seront traités directement lors de la requête Web.',

        # Template: AdminGenericInterfaceInvokerEvent
        'GenericInterface Invoker Event Settings for Web Service %s' => '',
        'Go back to' => 'Retour à',
        'Delete all conditions' => '',
        'Do you really want to delete all the conditions for this event?' =>
            '',
        'General Settings' => '',
        'Event type' => '',
        'Conditions' => '',
        'Conditions can only operate on non-empty fields.' => '',
        'Type of Linking between Conditions' => '',
        'Remove this Condition' => '',
        'Type of Linking' => '',
        'Fields' => '',
        'Add a new Field' => '',
        'Remove this Field' => '',
        'And can\'t be repeated on the same condition.' => '',
        'Add New Condition' => '',

        # Template: AdminGenericInterfaceMappingSimple
        'Mapping Simple' => 'Mappage élémentaire',
        'Default rule for unmapped keys' => 'Règle par défaut pour les clés non mappées',
        'This rule will apply for all keys with no mapping rule.' => 'Cette règle sera appliquée à toutes les clés n\'ayant pas de règle de mappage.',
        'Default rule for unmapped values' => 'Règle par défaut pour les valeurs non mappées',
        'This rule will apply for all values with no mapping rule.' => 'Cette règle sera appliquée à toutes les valeurs n\'ayant pas de règle de mappage.',
        'New key map' => 'Nouvelle mappe de clé',
        'Add key mapping' => 'Ajouter un mappage de clé',
        'Mapping for Key ' => 'Mappage de clé',
        'Remove key mapping' => 'Supprimer le mappage de clé',
        'Key mapping' => 'Mappage de clé',
        'Map key' => 'Mappe de clé',
        'matching the' => 'faire correspondre le ou la',
        'to new key' => 'à la nouvelle clé',
        'Value mapping' => 'Mappage de valeurs',
        'Map value' => 'Mappe de valeur',
        'to new value' => 'à la nouvelle valeur',
        'Remove value mapping' => 'Supprimer le mappage de valeur',
        'New value map' => 'Nouvelle mappe de valeur',
        'Add value mapping' => 'Ajouter un mappage de valeur',
        'Do you really want to delete this key mapping?' => 'Voulez-vous vraiment supprimer ce mappage de clé?',

        # Template: AdminGenericInterfaceMappingXSLT
        'General Shortcuts' => '',
        'MacOS Shortcuts' => '',
        'Comment code' => '',
        'Uncomment code' => '',
        'Auto format code' => '',
        'Expand/Collapse code block' => '',
        'Find' => '',
        'Find next' => '',
        'Find previous' => '',
        'Find and replace' => '',
        'Find and replace all' => '',
        'XSLT Mapping' => '',
        'XSLT stylesheet' => '',
        'The entered data is not a valid XSLT style sheet.' => '',
        'Here you can add or modify your XSLT mapping code.' => '',
        'The editing field allows you to use different functions like automatic formatting, window resize as well as tag- and bracket-completion.' =>
            '',
        'Data includes' => '',
        'Select one or more sets of data that were created at earlier request/response stages to be included in mappable data.' =>
            '',
        'These sets will appear in the data structure at \'/DataInclude/<DataSetName>\' (see debugger output of actual requests for details).' =>
            '',
        'Data key regex filters (before mapping)' => '',
        'Data key regex filters (after mapping)' => '',
        'Regular expressions' => '',
        'Replace' => '',
        'Remove regex' => '',
        'Add regex' => '',
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
        'Do you really want to delete this operation?' => 'Voulez-vous vraiment supprimer cette opération?',
        'Operation Details' => 'Détails de l\'opération',
        'The name is typically used to call up this web service operation from a remote system.' =>
            'Le nom est généralement utilisé pour appeler cette opération du service Web à partir d\'un système distant.',
        'Operation backend' => 'Arrière-plan des opérations',
        'This OTRS operation backend module will be called internally to process the request, generating data for the response.' =>
            'Ce module de l\'arrière-plan des opérations de OTRS sera appelé dans le programme afin de traiter la demande, générant ainsi des donnée permettant de répondre.',
        'Mapping for incoming request data' => 'Mappage effectué pour une demande de donnée à venir',
        'The request data will be processed by this mapping, to transform it to the kind of data OTRS expects.' =>
            'La réquisition de données sera traitée par mappage afin de la transformer en données lisibles par OTRS.',
        'Mapping for outgoing response data' => 'Mappage pour les données de réponses sortantes',
        'The response data will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            'Les données de réponse seront traitées par ce mappage afin de les transformer en un type de données lisibles par le système distant.',
        'Include Ticket Data' => '',
        'Include ticket data in response.' => '',

        # Template: AdminGenericInterfaceTransportHTTPREST
        'Network Transport' => '',
        'Properties' => 'Propriétés',
        'Route mapping for Operation' => '',
        'Define the route that should get mapped to this operation. Variables marked by a \':\' will get mapped to the entered name and passed along with the others to the mapping. (e.g. /Ticket/:TicketID).' =>
            '',
        'Valid request methods for Operation' => '',
        'Limit this Operation to specific request methods. If no method is selected all requests will be accepted.' =>
            '',
        'Maximum message length' => 'longueur maximale du message',
        'This field should be an integer number.' => 'Ce champ doit être un composé d\'un nombre entier.',
        'Here you can specify the maximum size (in bytes) of REST messages that OTRS will process.' =>
            '',
        'Send Keep-Alive' => '',
        'This configuration defines if incoming connections should get closed or kept alive.' =>
            '',
        'Additional response headers' => '',
        'Add response header' => '',
        'Endpoint' => 'Point d\'extrémité',
        'URI to indicate specific location for accessing a web service.' =>
            '',
        'e.g https://www.otrs.com:10745/api/v1.0 (without trailing backslash)' =>
            '',
        'Timeout' => '',
        'Timeout value for requests.' => '',
        'Authentication' => 'Authentification',
        'An optional authentication mechanism to access the remote system.' =>
            '',
        'BasicAuth User' => '',
        'The user name to be used to access the remote system.' => 'Nom d\'utilisateur devant être utilisé pour accéder au système distant.',
        'BasicAuth Password' => '',
        'The password for the privileged user.' => 'Le mot de passe des usagers privilégiés.',
        'Use Proxy Options' => '',
        'Show or hide Proxy options to connect to the remote system.' => '',
        'Proxy Server' => 'Serveur proxy',
        'URI of a proxy server to be used (if needed).' => 'Au besoin, utiliser le URI d\'un serveur proxy.',
        'e.g. http://proxy_hostname:8080' => 'par ex. http://proxy_hostname:8080',
        'Proxy User' => 'Utilisateur proxy',
        'The user name to be used to access the proxy server.' => 'Pour accéder au serveur proxy, utiliser ce nom d\'utilisateur.',
        'Proxy Password' => 'Mot de passe proxy',
        'The password for the proxy user.' => 'Le mot de passe de l\'utilisateur proxy.',
        'Skip Proxy' => '',
        'Skip proxy servers that might be configured globally?' => '',
        'Use SSL Options' => 'Utiliser les options du protocole SSL',
        'Show or hide SSL options to connect to the remote system.' => 'Afficher ou cacher les options SSL pour se connecter au système distant',
        'Client Certificate' => '',
        'The full path and name of the SSL client certificate file (must be in PEM, DER or PKCS#12 format).' =>
            '',
        'e.g. /opt/otrs/var/certificates/SOAP/certificate.pem' => '',
        'Client Certificate Key' => '',
        'The full path and name of the SSL client certificate key file (if not already included in certificate file).' =>
            '',
        'e.g. /opt/otrs/var/certificates/SOAP/key.pem' => '',
        'Client Certificate Key Password' => '',
        'The password to open the SSL certificate if the key is encrypted.' =>
            '',
        'Certification Authority (CA) Certificate' => '',
        'The full path and name of the certification authority certificate file that validates SSL certificate.' =>
            'Le chemin complet et le nom du fichier de l\'autorité de certification qui authentifie la certification du protocole SSL.',
        'e.g. /opt/otrs/var/certificates/SOAP/CA/ca.pem' => 'par ex. /opt/otrs/var/certificates/SOAP/CA/ca.pem',
        'Certification Authority (CA) Directory' => 'Répertoire de l\'autorité de certification (AC)',
        'The full path of the certification authority directory where the CA certificates are stored in the file system.' =>
            'Le chemin complet menant au répertoire de l\'autorité de certification, où les certificats sont stockés dans le système de fichiers.',
        'e.g. /opt/otrs/var/certificates/SOAP/CA' => 'par ex. /opt/otrs/var/certificates/SOAP/CA',
        'Controller mapping for Invoker' => '',
        'The controller that the invoker should send requests to. Variables marked by a \':\' will get replaced by the data value and passed along with the request. (e.g. /Ticket/:TicketID?UserLogin=:UserLogin&Password=:Password).' =>
            '',
        'Valid request command for Invoker' => '',
        'A specific HTTP command to use for the requests with this Invoker (optional).' =>
            '',
        'Default command' => '',
        'The default HTTP command to use for the requests.' => '',

        # Template: AdminGenericInterfaceTransportHTTPSOAP
        'e.g. https://local.otrs.com:8000/Webservice/Example' => '',
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
        'SOAPAction separator' => 'séparateur d\'action du protocole SOAP (SOAPAction)',
        'Character to use as separator between name space and SOAP operation.' =>
            '',
        'Usually .Net web services use "/" as separator.' => '',
        'SOAPAction free text' => '',
        'Text to be used to as SOAPAction.' => '',
        'Namespace' => 'Espace de nommage',
        'URI to give SOAP methods a context, reducing ambiguities.' => 'Identifiant uniforme de ressource (URI) pour offrir un contexte aux méthodes du protocole SOAP et réduire ainsi les ambiguïtés.',
        'e.g urn:otrs-com:soap:functions or http://www.otrs.com/GenericInterface/actions' =>
            'par ex. urn:otrs-com:soap:functions or http://www.otrs.com/GenericInterface/actions',
        'Request name scheme' => '',
        'Select how SOAP request function wrapper should be constructed.' =>
            '',
        '\'FunctionName\' is used as example for actual invoker/operation name.' =>
            '',
        '\'FreeText\' is used as example for actual configured value.' =>
            '',
        'Request name free text' => '',
        'Text to be used to as function wrapper name suffix or replacement.' =>
            '',
        'Please consider XML element naming restrictions (e.g. don\'t use \'<\' and \'&\').' =>
            '',
        'Response name scheme' => '',
        'Select how SOAP response function wrapper should be constructed.' =>
            '',
        'Response name free text' => '',
        'Here you can specify the maximum size (in bytes) of SOAP messages that OTRS will process.' =>
            'indiquez ici le poids maximal (en octets) des messages du protocole SOAP que OTRS traitera.',
        'Encoding' => 'codage',
        'The character encoding for the SOAP message contents.' => 'Le caractère codé pour le contenu du message du protocole SOAP',
        'e.g utf-8, latin1, iso-8859-1, cp1250, Etc.' => 'par ex. utf-8, latin1, iso-8859-1, cp1250, etc.',
        'Sort options' => '',
        'Add new first level element' => '',
        'Element' => '',
        'Outbound sort order for xml fields (structure starting below function name wrapper) - see documentation for SOAP transport.' =>
            '',

        # Template: AdminGenericInterfaceWebservice
        'Add Web Service' => '',
        'Edit Web Service' => '',
        'Clone Web Service' => '',
        'The name must be unique.' => 'Le nom doit être unique.',
        'Clone' => 'Cloner',
        'Export Web Service' => '',
        'Import web service' => 'Importer un service Web',
        'Configuration File' => 'Fichier de configuration ',
        'The file must be a valid web service configuration YAML file.' =>
            'Le fichier doit être un fichier YAML de configuration de services Web valide.',
        'Here you can specify a name for the webservice. If this field is empty, the name of the configuration file is used as name.' =>
            '',
        'Import' => 'Importer',
        'Configuration History' => '',
        'Delete web service' => 'Supprimer un service Web',
        'Do you really want to delete this web service?' => 'Voulez-vous vraiment supprimer ce service Web?',
        'Ready2Adopt Web Services' => '',
        'Here you can activate Ready2Adopt web services showcasing our best practices that are a part of %s.' =>
            '',
        'Please note that these web services may depend on other modules only available with certain %s contract levels (there will be a notification with further details when importing).' =>
            '',
        'Import Ready2Adopt web service' => '',
        'Would you like to benefit from web services created by experts? Upgrade to %s to import some sophisticated Ready2Adopt web services.' =>
            '',
        'After you save the configuration you will be redirected again to the edit screen.' =>
            'Une fois la configuration sauvegardée, vous serez redirigé vers l\'écran de gestion des services Web de l\'interface générique, section « Ajouter ».',
        'If you want to return to overview please click the "Go to overview" button.' =>
            'Si vous souhaitez accéder à l\'écran de visualisation, cliquez sur « Aller à la visualisation ».',
        'Remote system' => 'Système à distance ',
        'Provider transport' => 'Fournisseur de transport',
        'Requester transport' => 'Demandeur de transport',
        'Debug threshold' => 'Seuil de mise au point ',
        'In provider mode, OTRS offers web services which are used by remote systems.' =>
            'En mode « fournisseur », OTRS offre des services Web aux systèmes à distance.',
        'In requester mode, OTRS uses web services of remote systems.' =>
            'En mode « demandeur », OTRS utilise les services Web des systèmes à distance.',
        'Network transport' => 'Transport du réseau ',
        'Error Handling Modules' => '',
        'Error handling modules are used to react in case of errors during the communication. Those modules are executed in a specific order, which can be changed by drag and drop.' =>
            '',
        'Backend' => '',
        'Add error handling module' => '',
        'Operations are individual system functions which remote systems can request.' =>
            'Les opérations constituent des fonctions individuelles du système, et les systèmes à distance peuvent en faire la demande.',
        'Invokers prepare data for a request to a remote web service, and process its response data.' =>
            'Les demandeurs préparent les données pour faire une demande à un service Web à distance, puis ils traitent les données de la réponse.',
        'Controller' => 'Contrôleur',
        'Inbound mapping' => 'Mappage des fonctions entrantes',
        'Outbound mapping' => 'Mappage des fonctions sortantes',
        'Delete this action' => 'Supprimer cet action',
        'At least one %s has a controller that is either not active or not present, please check the controller registration or delete the %s' =>
            'Au moins un %s possède un contrôleur qui n\'est pas activé ou présent; veuillez vérifier l\'enregistrement du contrôleur ou supprimer le %s',

        # Template: AdminGenericInterfaceWebserviceHistory
        'History' => 'Historique',
        'Go back to Web Service' => 'Retour au service Web',
        'Here you can view older versions of the current web service\'s configuration, export or even restore them.' =>
            'L\'historique permet de voir, d\'exporter ou de restaurer les anciennes versions des configurations de services Web habituels.',
        'Configuration History List' => 'Liste des historiques de configuration',
        'Version' => 'Version ',
        'Create time' => 'Date de création ',
        'Select a single configuration version to see its details.' => 'Sélectionnez une version pour voir l\'information s\'y rattachant.',
        'Export web service configuration' => 'Exporter une configuration de service Web',
        'Restore web service configuration' => 'Restaurer une configuration de service Web',
        'Do you really want to restore this version of the web service configuration?' =>
            'Voulez-vous vraiment restaurer cette version de la configuration du service Web?',
        'Your current web service configuration will be overwritten.' => 'La configuration actuelle du service Web sera modifiée.',

        # Template: AdminGroup
        'Group Management' => 'Gestion des groupes',
        'Add Group' => 'Ajouter un groupe',
        'Edit Group' => 'Éditer un groupe',
        'The admin group is to get in the admin area and the stats group to get stats area.' =>
            'Le groupe administrateur permet d\'accéder à la zone d\'administration et le groupe statistiques permet d\'accéder à la zone de statistiques.',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...). ' =>
            'Créer de nouveaux groupes de gestion des permissions d\'accès pour les différents groupes d\'agents (p. ex. achats, support, ventes). ',
        'It\'s useful for ASP solutions. ' => 'Cette fonction est pratique pour les solutions ASP. ',

        # Template: AdminLog
        'System Log' => 'Journal',
        'Here you will find log information about your system.' => 'L\'information relative aux ouvertures de sessions dans le système est présentée ici.',
        'Hide this message' => 'Masquer ce message',
        'Recent Log Entries' => 'Ouvertures de sessions récentes',
        'Facility' => 'service',
        'Message' => 'Message',

        # Template: AdminMailAccount
        'Mail Account Management' => 'Gestion des comptes de courrier électronique',
        'Add Mail Account' => 'Ajouter un compte de courrier électronique',
        'Edit Mail Account for host' => '',
        'and user account' => '',
        'Filter for Mail Accounts' => '',
        'Filter for mail accounts' => '',
        'All incoming emails with one account will be dispatched in the selected queue.' =>
            '',
        'If your account is marked as trusted, the X-OTRS headers already existing at arrival time (for priority etc.) will be kept and used, for example in PostMaster filters.' =>
            '',
        'Outgoing email can be configured via the Sendmail* settings in %s.' =>
            '',
        'System Configuration' => '',
        'Host' => 'Hôte ',
        'Delete account' => 'Supprimer le compte',
        'Fetch mail' => 'Chercher un courriel',
        'Do you really want to delete this mail account?' => '',
        'Password' => 'Mot de passe ',
        'Example: mail.example.com' => 'Exemple : courriel.exemple.com',
        'IMAP Folder' => 'Dossier IMAP ',
        'Only modify this if you need to fetch mail from a different folder than INBOX.' =>
            'Modifiez ce champ seulement si vous souhaitez avoir accès à des courriels situés ailleurs que dans la boîte de réception.',
        'Trusted' => 'Sécurisé ',
        'Dispatching' => 'Classement ',
        'Edit Mail Account' => 'Éditer le compte de courrier électronique',

        # Template: AdminNavigationBar
        'Administration Overview' => '',
        'Filter for Items' => '',
        'Filter' => 'Filtre',
        'Favorites' => '',
        'You can add favorites by moving your cursor over items on the right side and clicking the star icon.' =>
            '',
        'Links' => '',
        'View the admin manual on Github' => '',
        'No Matches' => '',
        'Sorry, your search didn\'t match any items.' => '',
        'Set as favorite' => '',

        # Template: AdminNotificationEvent
        'Ticket Notification Management' => '',
        'Here you can upload a configuration file to import Ticket Notifications to your system. The file needs to be in .yml format as exported by the Ticket Notification module.' =>
            '',
        'Here you can choose which events will trigger this notification. An additional ticket filter can be applied below to only send for ticket with certain criteria.' =>
            '',
        'Ticket Filter' => 'Filtrer les demandes',
        'Lock' => 'Verrou ',
        'SLA' => 'SLA ',
        'Customer User ID' => '',
        'Article Filter' => 'Filtre pour les articles',
        'Only for ArticleCreate and ArticleSend event' => '',
        'Article sender type' => '',
        'If ArticleCreate or ArticleSend is used as a trigger event, you need to specify an article filter as well. Please select at least one of the article filter fields.' =>
            '',
        'Customer visibility' => '',
        'Communication channel' => '',
        'Include attachments to notification' => 'Inclure des pièces jointes à la notification ',
        'Notify user just once per day about a single ticket using a selected transport.' =>
            '',
        'This field is required and must have less than 4000 characters.' =>
            '',
        'Notifications are sent to an agent or a customer.' => 'Des notifications sont envoyées à un agent ou à un client.',
        'To get the first 20 character of the subject (of the latest agent article).' =>
            'Pour avoir les 20 premiers caractères du sujet (du dernier article de l\'agent).',
        'To get the first 5 lines of the body (of the latest agent article).' =>
            'Pour avoir les 5 premières ligne du corps (du dernier article de l\'agent).',
        'To get the first 20 character of the subject (of the latest customer article).' =>
            'Pour avoir les 20 premiers caractères du sujet (du dernier article du client).',
        'To get the first 5 lines of the body (of the latest customer article).' =>
            'Pour avoir les 5 premières lignes du sujet (du dernier article du client).',
        'Attributes of the current customer user data' => '',
        'Attributes of the current ticket owner user data' => '',
        'Attributes of the current ticket responsible user data' => '',
        'Attributes of the current agent user who requested this action' =>
            '',
        'Attributes of the ticket data' => '',
        'Ticket dynamic fields internal key values' => '',
        'Ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            '',

        # Template: AdminNotificationEventTransportEmailSettings
        'Use comma or semicolon to separate email addresses.' => '',
        'You can use OTRS-tags like <OTRS_TICKET_DynamicField_...> to insert values from the current ticket.' =>
            '',

        # Template: AdminOTRSBusinessInstalled
        'Manage %s' => '',
        'Downgrade to ((OTRS)) Community Edition' => '',
        'Read documentation' => '',
        '%s makes contact regularly with cloud.otrs.com to check on available updates and the validity of the underlying contract.' =>
            '',
        'Unauthorized Usage Detected' => '',
        'This system uses the %s without a proper license! Please make contact with %s to renew or activate your contract!' =>
            '',
        '%s not Correctly Installed' => '',
        'Your %s is not correctly installed. Please reinstall it with the button below.' =>
            '',
        'Reinstall %s' => '',
        'Your %s is not correctly installed, and there is also an update available.' =>
            '',
        'You can either reinstall your current version or perform an update with the buttons below (update recommended).' =>
            '',
        'Update %s' => '',
        '%s Not Yet Available' => '',
        '%s will be available soon.' => '',
        '%s Update Available' => '',
        'An update for your %s is available! Please update at your earliest!' =>
            '',
        '%s Correctly Deployed' => '',
        'Congratulations, your %s is correctly installed and up to date!' =>
            '',

        # Template: AdminOTRSBusinessNotInstalled
        'Go to the OTRS customer portal' => '',
        '%s will be available soon. Please check again in a few days.' =>
            '',
        'Please have a look at %s for more information.' => '',
        'Your ((OTRS)) Community Edition is the base for all future actions. Please register first before you continue with the upgrade process of %s!' =>
            '',
        'Before you can benefit from %s, please contact %s to get your %s contract.' =>
            '',
        'Connection to cloud.otrs.com via HTTPS couldn\'t be established. Please make sure that your OTRS can connect to cloud.otrs.com via port 443.' =>
            '',
        'Package installation requires patch level update of OTRS.' => '',
        'Please visit our customer portal and file a request.' => '',
        'Everything else will be done as part of your contract.' => '',
        'Your installed OTRS version is %s.' => '',
        'To install this package, you need to update to OTRS %s or higher.' =>
            '',
        'To install this package, the Maximum OTRS Version is %s.' => '',
        'To install this package, the required Framework version is %s.' =>
            '',
        'Why should I keep OTRS up to date?' => '',
        'You will receive updates about relevant security issues.' => '',
        'You will receive updates for all other relevant OTRS issues' => '',
        'With your existing contract you can only use a small part of the %s.' =>
            '',
        'If you would like to take full advantage of the %s get your contract upgraded now! Contact %s.' =>
            '',

        # Template: AdminOTRSBusinessUninstall
        'Cancel downgrade and go back' => '',
        'Go to OTRS Package Manager' => '',
        'Sorry, but currently you can\'t downgrade due to the following packages which depend on %s:' =>
            '',
        'Vendor' => 'Vendeur ',
        'Please uninstall the packages first using the package manager and try again.' =>
            '',
        'You are about to downgrade to ((OTRS)) Community Edition and will lose the following features and all data related to these:' =>
            '',
        'Chat' => '',
        'Report Generator' => 'Générateur de rapports',
        'Timeline view in ticket zoom' => '',
        'DynamicField ContactWithData' => '',
        'DynamicField Database' => '',
        'SLA Selection Dialog' => '',
        'Ticket Attachment View' => '',
        'The %s skin' => '',

        # Template: AdminPGP
        'PGP Management' => 'Gestion des clés PGP',
        'Add PGP Key' => 'Ajouter Clé PGP',
        'PGP support is disabled' => '',
        'To be able to use PGP in OTRS, you have to enable it first.' => '',
        'Enable PGP support' => '',
        'Faulty PGP configuration' => '',
        'PGP support is enabled, but the relevant configuration contains errors. Please check the configuration using the button below.' =>
            '',
        'Configure it here!' => '',
        'Check PGP configuration' => '',
        'In this way you can directly edit the keyring configured in SysConfig.' =>
            'Ainsi, vous pouvez directement éditer le trousseau configuré dans le système de configuration.',
        'Introduction to PGP' => 'Introduction aux clés PGP',
        'Identifier' => 'Identifiant',
        'Bit' => 'Bit',
        'Fingerprint' => 'Empreinte',
        'Expires' => 'Échéance',
        'Delete this key' => 'Supprimer cette clé',
        'PGP key' => 'Clé PGP',

        # Template: AdminPackageManager
        'Package Manager' => 'Gestionnaire de paquets',
        'Uninstall Package' => '',
        'Uninstall package' => 'Désinstaller le paquet',
        'Do you really want to uninstall this package?' => 'Voulez-vous vraiment désinstaller ce paquet?',
        'Reinstall package' => 'Réinstaller le paquet',
        'Do you really want to reinstall this package? Any manual changes will be lost.' =>
            'Voulez-vous vraiment réinstaller ce paquet? Tout changement manuel sera perdu.',
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
            '',
        'Install Package' => 'Installer un paquet',
        'Update Package' => '',
        'Continue' => 'Continuer',
        'Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            '',
        'Install' => 'Installer',
        'Update repository information' => 'Mettre à jour les informations du référentiel',
        'Cloud services are currently disabled.' => '',
        'OTRS Verify™ can not continue!' => '',
        'Enable cloud services' => '',
        'Update all installed packages' => '',
        'Online Repository' => 'Référentiels en ligne',
        'Action' => 'Action',
        'Module documentation' => 'Documents relatifs au module',
        'Local Repository' => 'Référentiels locaux',
        'This package is verified by OTRSverify (tm)' => '',
        'Uninstall' => 'Désinstallation',
        'Package not correctly deployed! Please reinstall the package.' =>
            'Le paquet n\'a pas été installé correctement. Veuillez l\'installer de nouveau.',
        'Reinstall' => 'Réinstallation',
        'Features for %s customers only' => '',
        'With %s, you can benefit from the following optional features. Please make contact with %s if you need more information.' =>
            '',
        'Package Information' => '',
        'Download package' => 'Télécharger un paquet',
        'Rebuild package' => 'Reconstruire un paquet',
        'Metadata' => 'Métadonnées',
        'Change Log' => 'Journal de modifications',
        'Date' => 'Date',
        'List of Files' => 'Liste de fichiers',
        'Permission' => 'Permission',
        'Download file from package!' => 'Télécharger le fichier à partir du paquet. ',
        'Required' => 'Obligatoire ',
        'Size' => 'Taille ',
        'Primary Key' => '',
        'Auto Increment' => '',
        'SQL' => 'Requête SQL ',
        'File Differences for File %s' => '',
        'File differences for file %s' => 'Différences de fichier pour le fichier %s',

        # Template: AdminPerformanceLog
        'Performance Log' => 'Journal des performances',
        'Range' => 'Plage',
        'last' => 'depuis',
        'This feature is enabled!' => 'Cette fonctionnalité est activée',
        'Just use this feature if you want to log each request.' => 'Utilisez cette fonctionnalité seulement si vous souhaitez enregistrer chacune des requêtes.',
        'Activating this feature might affect your system performance!' =>
            'Le fait d\'activer cette fonctionnalité peut perturber le rendement de votre système.',
        'Disable it here!' => 'Désactivez-la ici',
        'Logfile too large!' => 'Le fichier journal est trop grand.',
        'The logfile is too large, you need to reset it' => 'Le fichier journal est trop grand : vous devez le réinitialiser.',
        'Reset' => 'Réinitialiser',
        'Overview' => 'Visualisation ',
        'Interface' => 'Interface',
        'Requests' => 'Requêtes',
        'Min Response' => 'Temps de réponse minimum',
        'Max Response' => 'Temps de réponse maximum',
        'Average Response' => 'Temps de réponse moyen',
        'Period' => 'Période',
        'minutes' => 'minutes',
        'Min' => 'Min',
        'Max' => 'Max',
        'Average' => 'Moyenne',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => 'Gestion des filtres du maître de poste',
        'Add PostMaster Filter' => 'Ajouter un filtre',
        'Edit PostMaster Filter' => 'Éditer ce filtre',
        'Filter for PostMaster Filters' => '',
        'Filter for PostMaster filters' => '',
        'To dispatch or filter incoming emails based on email headers. Matching using Regular Expressions is also possible.' =>
            'La présente fonctionnalité permet de distribuer et de filtrer les courriels entrants au moyen de leur en-tête. Elle permet aussi de faire de la correspondance de courriels au moyen d\'expressions courantes. ',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' =>
            'Pour faire correspondre seulement une adresse électronique, l\'inscrire dans le champ « De », « À » ou « c.c. ».',
        'If you use Regular Expressions, you also can use the matched value in () as [***] in the \'Set\' action.' =>
            'Si vous souhaitez utiliser les expressions courantes, il est aussi possible d\'utiliser des valeurs de correspondance entre parenthèses.',
        'You can also use named captures %s and use the names in the \'Set\' action %s (e.g. Regexp: %s, Set action: %s). A matched EMAILADDRESS has the name \'%s\'.' =>
            '',
        'Delete this filter' => 'Supprimer ce filtre',
        'Do you really want to delete this postmaster filter?' => '',
        'A postmaster filter with this name already exists!' => '',
        'Filter Condition' => 'Condition de filtre',
        'AND Condition' => '',
        'Search header field' => '',
        'for value' => '',
        'The field needs to be a valid regular expression or a literal word.' =>
            'Le champ doit comporter une expression admissible ou un libellé.',
        'Negate' => '',
        'Set Email Headers' => 'Définir les en-têtes de courriel',
        'Set email header' => '',
        'with value' => '',
        'The field needs to be a literal word.' => 'Ce champ doit comporter un libellé.',
        'Header' => 'En-tête',

        # Template: AdminPriority
        'Priority Management' => 'Gestion de la priorité',
        'Add Priority' => 'Ajouter la priorité',
        'Edit Priority' => 'Éditer la priorité',
        'Filter for Priorities' => '',
        'Filter for priorities' => '',
        'This priority is present in a SysConfig setting, confirmation for updating settings to point to the new priority is needed!' =>
            '',
        'This priority is used in the following config settings:' => '',

        # Template: AdminProcessManagement
        'Process Management' => '',
        'Filter for Processes' => '',
        'Filter for processes' => '',
        'Create New Process' => '',
        'Deploy All Processes' => '',
        'Here you can upload a configuration file to import a process to your system. The file needs to be in .yml format as exported by process management module.' =>
            '',
        'Upload process configuration' => '',
        'Import process configuration' => '',
        'Ready2Adopt Processes' => '',
        'Here you can activate Ready2Adopt processes showcasing our best practices. Please note that some additional configuration may be required.' =>
            '',
        'Would you like to benefit from processes created by experts? Upgrade to %s to import some sophisticated Ready2Adopt processes.' =>
            '',
        'Import Ready2Adopt process' => '',
        'To create a new Process you can either import a Process that was exported from another system or create a complete new one.' =>
            '',
        'Changes to the Processes here only affect the behavior of the system, if you synchronize the Process data. By synchronizing the Processes, the newly made changes will be written to the Configuration.' =>
            '',
        'Processes' => '',
        'Process name' => '',
        'Print' => 'Imprimer',
        'Export Process Configuration' => '',
        'Copy Process' => '',

        # Template: AdminProcessManagementActivity
        'Cancel & close' => '',
        'Go Back' => '',
        'Please note, that changing this activity will affect the following processes' =>
            '',
        'Activity' => '',
        'Activity Name' => '',
        'Activity Dialogs' => '',
        'You can assign Activity Dialogs to this Activity by dragging the elements with the mouse from the left list to the right list.' =>
            '',
        'Ordering the elements within the list is also possible by drag \'n\' drop.' =>
            '',
        'Filter available Activity Dialogs' => '',
        'Available Activity Dialogs' => '',
        'Name: %s, EntityID: %s' => '',
        'Create New Activity Dialog' => '',
        'Assigned Activity Dialogs' => '',

        # Template: AdminProcessManagementActivityDialog
        'Please note that changing this activity dialog will affect the following activities' =>
            '',
        'Please note that customer users will not be able to see or use the following fields: Owner, Responsible, Lock, PendingTime and CustomerID.' =>
            '',
        'The Queue field can only be used by customers when creating a new ticket.' =>
            '',
        'Activity Dialog' => '',
        'Activity dialog Name' => '',
        'Available in' => '',
        'Description (short)' => '',
        'Description (long)' => '',
        'The selected permission does not exist.' => '',
        'Required Lock' => '',
        'The selected required lock does not exist.' => '',
        'Submit Advice Text' => '',
        'Submit Button Text' => '',
        'You can assign Fields to this Activity Dialog by dragging the elements with the mouse from the left list to the right list.' =>
            '',
        'Filter available fields' => '',
        'Available Fields' => '',
        'Assigned Fields' => '',
        'Communication Channel' => '',
        'Is visible for customer' => '',
        'Display' => '',

        # Template: AdminProcessManagementPath
        'Path' => '',
        'Edit this transition' => '',
        'Transition Actions' => '',
        'You can assign Transition Actions to this Transition by dragging the elements with the mouse from the left list to the right list.' =>
            '',
        'Filter available Transition Actions' => '',
        'Available Transition Actions' => '',
        'Create New Transition Action' => '',
        'Assigned Transition Actions' => '',

        # Template: AdminProcessManagementProcessAccordion
        'Activities' => '',
        'Filter Activities...' => '',
        'Create New Activity' => '',
        'Filter Activity Dialogs...' => '',
        'Transitions' => '',
        'Filter Transitions...' => '',
        'Create New Transition' => '',
        'Filter Transition Actions...' => '',

        # Template: AdminProcessManagementProcessEdit
        'Edit Process' => '',
        'Print process information' => '',
        'Delete Process' => '',
        'Delete Inactive Process' => '',
        'Available Process Elements' => '',
        'The Elements listed above in this sidebar can be moved to the canvas area on the right by using drag\'n\'drop.' =>
            '',
        'You can place Activities on the canvas area to assign this Activity to the Process.' =>
            '',
        'To assign an Activity Dialog to an Activity drop the Activity Dialog element from this sidebar over the Activity placed in the canvas area.' =>
            '',
        'You can start a connection between two Activities by dropping the Transition element over the Start Activity of the connection. After that you can move the loose end of the arrow to the End Activity.' =>
            '',
        'Actions can be assigned to a Transition by dropping the Action Element onto the label of a Transition.' =>
            '',
        'Edit Process Information' => '',
        'Process Name' => '',
        'The selected state does not exist.' => '',
        'Add and Edit Activities, Activity Dialogs and Transitions' => '',
        'Show EntityIDs' => '',
        'Extend the width of the Canvas' => '',
        'Extend the height of the Canvas' => '',
        'Remove the Activity from this Process' => '',
        'Edit this Activity' => '',
        'Save Activities, Activity Dialogs and Transitions' => '',
        'Do you really want to delete this Process?' => '',
        'Do you really want to delete this Activity?' => '',
        'Do you really want to delete this Activity Dialog?' => '',
        'Do you really want to delete this Transition?' => '',
        'Do you really want to delete this Transition Action?' => '',
        'Do you really want to remove this activity from the canvas? This can only be undone by leaving this screen without saving.' =>
            '',
        'Do you really want to remove this transition from the canvas? This can only be undone by leaving this screen without saving.' =>
            '',

        # Template: AdminProcessManagementProcessNew
        'In this screen, you can create a new process. In order to make the new process available to users, please make sure to set its state to \'Active\' and synchronize after completing your work.' =>
            '',

        # Template: AdminProcessManagementProcessPrint
        'cancel & close' => '',
        'Start Activity' => '',
        'Contains %s dialog(s)' => '',
        'Assigned dialogs' => '',
        'Activities are not being used in this process.' => '',
        'Assigned fields' => '',
        'Activity dialogs are not being used in this process.' => '',
        'Condition linking' => '',
        'Transitions are not being used in this process.' => '',
        'Module name' => '',
        'Transition actions are not being used in this process.' => '',

        # Template: AdminProcessManagementTransition
        'Please note that changing this transition will affect the following processes' =>
            '',
        'Transition' => '',
        'Transition Name' => '',

        # Template: AdminProcessManagementTransitionAction
        'Please note that changing this transition action will affect the following processes' =>
            '',
        'Transition Action' => '',
        'Transition Action Name' => '',
        'Transition Action Module' => '',
        'Config Parameters' => '',
        'Add a new Parameter' => '',
        'Remove this Parameter' => '',

        # Template: AdminQueue
        'Queue Management' => '',
        'Add Queue' => 'Ajouter une file',
        'Edit Queue' => 'Éditer une File',
        'Filter for Queues' => 'Filtre pour les files',
        'Filter for queues' => '',
        'A queue with this name already exists!' => '',
        'This queue is present in a SysConfig setting, confirmation for updating settings to point to the new queue is needed!' =>
            '',
        'Sub-queue of' => 'Sous-file de ',
        'Unlock timeout' => 'Délai de déverrouillage',
        '0 = no unlock' => '0 = pas de déverrouillage',
        'hours' => 'heures',
        'Only business hours are counted.' => 'seules les plages horaires de bureau sont prises en compte.',
        'If an agent locks a ticket and does not close it before the unlock timeout has passed, the ticket will unlock and will become available for other agents.' =>
            'Si un agent verrouille une demande et ne la ferme pas avant le délai de déverrouillage, la demande sera déverrouillée et sera disponible pour un autre agent.',
        'Notify by' => 'Notification après',
        '0 = no escalation' => '0 = pas de remontée de la demande',
        'If there is not added a customer contact, either email-external or phone, to a new ticket before the time defined here expires, the ticket is escalated.' =>
            'Si une communication avec le client n\'est pas ajoutée à une nouvelle demande, soit par courriel externe soit par téléphone, avant que le délai défini ici expire, la demande sera escaladée.',
        'If there is an article added, such as a follow-up via email or the customer portal, the escalation update time is reset. If there is no customer contact, either email-external or phone, added to a ticket before the time defined here expires, the ticket is escalated.' =>
            'Si un article est ajouté, par exemple un suivi envoyé par courriel ou inscrit sur le portail client, le moment de mise à jour de l\'escalade est réinitialisé. S\'il n\'y a pas de communication avec le client (soit par courriel externe ou par téléphone) adjointe à la demande avant que le moment défini ici expire, la demande sera escaladée.',
        'If the ticket is not set to closed before the time defined here expires, the ticket is escalated.' =>
            'Si la demande n\'est pas résolue avant que le délai défini ici expire, elle sera escaladée.',
        'Follow up Option' => 'Option de suivi ',
        'Specifies if follow up to closed tickets would re-open the ticket, be rejected or lead to a new ticket.' =>
            'Défini si le suivi d\'une demande fermée conduira à la réouverture de celle-ci ou à l\'ouverture d\'une nouvelle demande. Si vous ne souhaitez pas activer l\'option de suivi, choisissez « Rejeter l\'option ».',
        'Ticket lock after a follow up' => 'Demande verrouillée après un suivi ',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked to the old owner.' =>
            'Si un client fait un suivi sur une demande fermée, cette dernière se verrouillera systématiquement au nom de l\'ancien propriétaire.',
        'System address' => 'Adresse système ',
        'Will be the sender address of this queue for email answers.' => 'Sera l\'adresse d\'expédition des réponses par courriel de cette file.',
        'Default sign key' => 'Clé de signature par défaut',
        'To use a sign key, PGP keys or S/MIME certificates need to be added with identifiers for selected queue system address.' =>
            '',
        'Salutation' => 'Formule de salutation ',
        'The salutation for email answers.' => 'La formule de salutation pour les réponses par courriel.',
        'Signature' => 'Signature ',
        'The signature for email answers.' => 'La signature des réponses par courriel.',
        'This queue is used in the following config settings:' => '',

        # Template: AdminQueueAutoResponse
        'Manage Queue-Auto Response Relations' => 'Gestion des relations entre les files et les réponses automatiques',
        'Change Auto Response Relations for Queue' => 'Modifier les réponses automatiques de la file',
        'This filter allow you to show queues without auto responses' => '',
        'Queues without Auto Responses' => '',
        'This filter allow you to show all queues' => '',
        'Show All Queues' => '',
        'Auto Responses' => 'Réponses automatiques',

        # Template: AdminQueueTemplates
        'Manage Template-Queue Relations' => '',
        'Filter for Templates' => '',
        'Filter for templates' => '',
        'Templates' => '',

        # Template: AdminRegistration
        'System Registration Management' => '',
        'Edit System Registration' => '',
        'System Registration Overview' => '',
        'Register System' => '',
        'Validate OTRS-ID' => '',
        'Deregister System' => '',
        'Edit details' => '',
        'Show transmitted data' => '',
        'Deregister system' => '',
        'Overview of registered systems' => '',
        'This system is registered with OTRS Group.' => '',
        'System type' => '',
        'Unique ID' => '',
        'Last communication with registration server' => '',
        'System Registration not Possible' => '',
        'Please note that you can\'t register your system if OTRS Daemon is not running correctly!' =>
            '',
        'Instructions' => '',
        'System Deregistration not Possible' => '',
        'Please note that you can\'t deregister your system if you\'re using the %s or having a valid service contract.' =>
            '',
        'OTRS-ID Login' => '',
        'Read more' => '',
        'You need to log in with your OTRS-ID to register your system.' =>
            '',
        'Your OTRS-ID is the email address you used to sign up on the OTRS.com webpage.' =>
            '',
        'Data Protection' => '',
        'What are the advantages of system registration?' => '',
        'You will receive updates about relevant security releases.' => '',
        'With your system registration we can improve our services for you, because we have all relevant information available.' =>
            '',
        'This is only the beginning!' => '',
        'We will inform you about our new services and offerings soon.' =>
            '',
        'Can I use OTRS without being registered?' => '',
        'System registration is optional.' => '',
        'You can download and use OTRS without being registered.' => '',
        'Is it possible to deregister?' => '',
        'You can deregister at any time.' => '',
        'Which data is transfered when registering?' => '',
        'A registered system sends the following data to OTRS Group:' => '',
        'Fully Qualified Domain Name (FQDN), OTRS version, Database, Operating System and Perl version.' =>
            '',
        'Why do I have to provide a description for my system?' => '',
        'The description of the system is optional.' => '',
        'The description and system type you specify help you to identify and manage the details of your registered systems.' =>
            '',
        'How often does my OTRS system send updates?' => '',
        'Your system will send updates to the registration server at regular intervals.' =>
            '',
        'Typically this would be around once every three days.' => '',
        'If you deregister your system, you will lose these benefits:' =>
            '',
        'You need to log in with your OTRS-ID to deregister your system.' =>
            '',
        'OTRS-ID' => '',
        'You don\'t have an OTRS-ID yet?' => '',
        'Sign up now' => 'Enregistrez-vous maintenant',
        'Forgot your password?' => '',
        'Retrieve a new one' => '',
        'Next' => 'Suivant',
        'This data will be frequently transferred to OTRS Group when you register this system.' =>
            '',
        'Attribute' => 'Attribut',
        'FQDN' => '',
        'OTRS Version' => '',
        'Operating System' => '',
        'Perl Version' => '',
        'Optional description of this system.' => '',
        'Register' => '',
        'Continuing with this step will deregister the system from OTRS Group.' =>
            '',
        'Deregister' => '',
        'You can modify registration settings here.' => '',
        'Overview of Transmitted Data' => '',
        'There is no data regularly sent from your system to %s.' => '',
        'The following data is sent at minimum every 3 days from your system to %s.' =>
            '',
        'The data will be transferred in JSON format via a secure https connection.' =>
            '',
        'System Registration Data' => '',
        'Support Data' => '',

        # Template: AdminRole
        'Role Management' => 'Gestion des rôles',
        'Add Role' => 'Ajouter un rôle',
        'Edit Role' => 'Éditer rôle',
        'Filter for Roles' => 'Filtre pour les rôles',
        'Filter for roles' => '',
        'Create a role and put groups in it. Then add the role to the users.' =>
            'Permet de créer un rôle, d\'y ajouter des groupes et d\'attribuer ensuite ce rôle aux utilisateurs.',
        'There are no roles defined. Please use the \'Add\' button to create a new role.' =>
            'Il n\'y a pas de rôle défini. Utilisez le bouton « Ajouter » pour créer un nouveau rôle.',

        # Template: AdminRoleGroup
        'Manage Role-Group Relations' => 'Gestion des relations rôle-groupe',
        'Roles' => 'Rôles',
        'Select the role:group permissions.' => 'Sélectionner les permissions des rôles et des groupes.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the role).' =>
            'Si rien n\'est sélectionné, il n\'y aura aucune permission pour ce groupe (les demandes ne seront pas accessibles pour le rôle).',
        'Toggle %s permission for all' => 'Sélectionner la permission %s pour tous',
        'move_into' => 'Déplacer',
        'Permissions to move tickets into this group/queue.' => 'Permission de déplacer une demande de cette file ou ce groupe.',
        'create' => 'Créer',
        'Permissions to create tickets in this group/queue.' => 'Permission de créer une demande dans cette file ou ce groupe.',
        'note' => 'Note',
        'Permissions to add notes to tickets in this group/queue.' => 'Permission d\'ajouter des notes aux demandes de cette file ou ce groupe. ',
        'owner' => 'Propriétaire',
        'Permissions to change the owner of tickets in this group/queue.' =>
            'Permission de changer le propriétaire des demandes de cette file ou ce groupe. ',
        'priority' => 'Priorité ',
        'Permissions to change the ticket priority in this group/queue.' =>
            'Permission de changer la priorité des demandes de cette file ou ce groupe.',

        # Template: AdminRoleUser
        'Manage Agent-Role Relations' => 'Gestion des relations agent-rôle',
        'Add Agent' => 'Ajouter un agent',
        'Filter for Agents' => 'Filtre pour les agents',
        'Filter for agents' => '',
        'Agents' => 'Agents',
        'Manage Role-Agent Relations' => 'Gestion des relations rôle-agent',

        # Template: AdminSLA
        'SLA Management' => 'Gestion des accords sur les niveaux de service (Service Level Agreement)',
        'Edit SLA' => 'Éditer le SLA',
        'Add SLA' => 'Ajouter un SLA',
        'Filter for SLAs' => '',
        'Please write only numbers!' => 'Veuillez n\'utiliser que des chiffres svp.',

        # Template: AdminSMIME
        'S/MIME Management' => 'Gestion des certificats S/MIME ',
        'Add Certificate' => 'Ajouter un certificat',
        'Add Private Key' => 'Ajouter une clé privée',
        'SMIME support is disabled' => '',
        'To be able to use SMIME in OTRS, you have to enable it first.' =>
            '',
        'Enable SMIME support' => '',
        'Faulty SMIME configuration' => '',
        'SMIME support is enabled, but the relevant configuration contains errors. Please check the configuration using the button below.' =>
            '',
        'Check SMIME configuration' => '',
        'Filter for Certificates' => '',
        'Filter for certificates' => 'Filtres pour les certificats',
        'To show certificate details click on a certificate icon.' => '',
        'To manage private certificate relations click on a private key icon.' =>
            '',
        'Here you can add relations to your private certificate, these will be embedded to the S/MIME signature every time you use this certificate to sign an email.' =>
            '',
        'See also' => 'Consultez aussi le ',
        'In this way you can directly edit the certification and private keys in file system.' =>
            'Vous pouvez mettre à jour la certification et les clés privées directement dans le système.',
        'Hash' => 'Algorithme de hachage',
        'Create' => 'Création',
        'Handle related certificates' => 'Gestion des certificats associés',
        'Read certificate' => '',
        'Delete this certificate' => 'Supprimer ce certificat',
        'File' => 'Fichier ',
        'Secret' => 'Secret ',
        'Related Certificates for' => 'Certificats associés à',
        'Delete this relation' => 'Supprimer cette relation',
        'Available Certificates' => 'Certificats disponibles',
        'Filter for S/MIME certs' => '',
        'Relate this certificate' => 'Lie ce certificat',

        # Template: AdminSMIMECertRead
        'S/MIME Certificate' => 'Certificat S/MIME',
        'Close this dialog' => 'Fermer cette fenêtre de dialogue',
        'Certificate Details' => '',

        # Template: AdminSalutation
        'Salutation Management' => 'Gestion des formules de salutation',
        'Add Salutation' => 'Ajouter une formule de salutation',
        'Edit Salutation' => 'Éditer une formule de salutation',
        'Filter for Salutations' => '',
        'Filter for salutations' => '',
        'e. g.' => 'p. ex.',
        'Example salutation' => 'Exemple de formule de salutation ',

        # Template: AdminSecureMode
        'Secure Mode Needs to be Enabled!' => '',
        'Secure mode will (normally) be set after the initial installation is completed.' =>
            'Normalement, le mode sécurisé sera activé lorsque l\'installation initiale sera terminée.',
        'If secure mode is not activated, activate it via SysConfig because your application is already running.' =>
            'Si le mode sécurisé n\'est pas activé, activez-le au moyen du système de configuration car votre application est déjà en fonction.',

        # Template: AdminSelectBox
        'SQL Box' => 'Requêtes SQL',
        'Filter for Results' => '',
        'Filter for results' => '',
        'Here you can enter SQL to send it directly to the application database. It is not possible to change the content of the tables, only select queries are allowed.' =>
            '',
        'Here you can enter SQL to send it directly to the application database.' =>
            'Entrez les requêtes SQL afin de les envoyer directement dans la base de données d\'application.',
        'Options' => 'Options ',
        'Only select queries are allowed.' => '',
        'The syntax of your SQL query has a mistake. Please check it.' =>
            'Votre requête SQL comporte une erreur de syntaxe. Veuillez la corriger.',
        'There is at least one parameter missing for the binding. Please check it.' =>
            'Il manque au moins un paramètre, ce qui empêche l\'association. Veuillez corriger la situation.',
        'Result format' => 'Format du résultat ',
        'Run Query' => 'Lancer la requête',
        '%s Results' => '',
        'Query is executed.' => '',

        # Template: AdminService
        'Service Management' => 'Gestion des services',
        'Add Service' => 'Ajouter un service',
        'Edit Service' => 'Éditer le service ',
        'Service name maximum length is 200 characters (with Sub-service).' =>
            '',
        'Sub-service of' => 'Sous-service de ',

        # Template: AdminSession
        'Session Management' => 'Gestion des sessions',
        'Detail Session View for %s (%s)' => '',
        'All sessions' => 'Toutes les sessions ',
        'Agent sessions' => 'Sessions des agents ',
        'Customer sessions' => 'Sessions des clients ',
        'Unique agents' => 'Agents seuls ',
        'Unique customers' => 'Clients seuls ',
        'Kill all sessions' => 'Supprimer toutes les sessions',
        'Kill this session' => 'Supprimer cette session',
        'Filter for Sessions' => '',
        'Filter for sessions' => '',
        'Session' => 'Session',
        'User' => 'Utilisateur',
        'Kill' => 'Supprimer',
        'Detail View for SessionID: %s - %s' => '',

        # Template: AdminSignature
        'Signature Management' => 'Gestion des signatures',
        'Add Signature' => 'Ajouter une signature',
        'Edit Signature' => 'Éditer une signature',
        'Filter for Signatures' => '',
        'Filter for signatures' => '',
        'Example signature' => 'Exemple de signature',

        # Template: AdminState
        'State Management' => 'Gestion des états',
        'Add State' => 'Ajouter un état',
        'Edit State' => 'Éditer un état',
        'Filter for States' => '',
        'Filter for states' => '',
        'Attention' => 'Attention ',
        'Please also update the states in SysConfig where needed.' => 'Veuillez également mettre les états à jour dans la configuration du système.',
        'This state is present in a SysConfig setting, confirmation for updating settings to point to the new type is needed!' =>
            '',
        'State type' => 'Type d\'état de la demande ',
        'It\'s not possible to invalidate this entry because there is no other merge states in system!' =>
            '',
        'This state is used in the following config settings:' => '',

        # Template: AdminSupportDataCollector
        'Sending support data to OTRS Group is not possible!' => '',
        'Enable Cloud Services' => '',
        'This data is sent to OTRS Group on a regular basis. To stop sending this data please update your system registration.' =>
            '',
        'You can manually trigger the Support Data sending by pressing this button:' =>
            '',
        'Send Update' => '',
        'Currently this data is only shown in this system.' => '',
        'A support bundle (including: system registration information, support data, a list of installed packages and all locally modified source code files) can be generated by pressing this button:' =>
            '',
        'Generate Support Bundle' => '',
        'The Support Bundle has been Generated' => '',
        'Please choose one of the following options.' => '',
        'Send by Email' => '',
        'The support bundle is too large to send it by email, this option has been disabled.' =>
            '',
        'The email address for this user is invalid, this option has been disabled.' =>
            '',
        'Sending' => 'Émetteur',
        'The support bundle will be sent to OTRS Group via email automatically.' =>
            '',
        'Download File' => 'Télécharger le fichier',
        'A file containing the support bundle will be downloaded to the local system. Please save the file and send it to the OTRS Group, using an alternate method.' =>
            '',
        'Error: Support data could not be collected (%s).' => '',
        'Details' => 'Informations',

        # Template: AdminSystemAddress
        'System Email Addresses Management' => 'Gestion des adresses électroniques du système',
        'Add System Email Address' => 'Ajouter une adresse électronique dans le système',
        'Edit System Email Address' => 'Editer l\'adresse de messagerie du système',
        'Add System Address' => '',
        'Filter for System Addresses' => '',
        'Filter for system addresses' => '',
        'All incoming email with this address in To or Cc will be dispatched to the selected queue.' =>
            'Tous les courriels entrants qui affichent cette adresse dans les champs « À » ou « cc » seront classés dans la file sélectionnée.',
        'Email address' => 'Adresse électronique ',
        'Display name' => 'Nom à afficher ',
        'This email address is already used as system email address.' => '',
        'The display name and email address will be shown on mail you send.' =>
            'Les courriels que vous envoyez afficheront l\'adresse électronique et le nom inscrits.',
        'This system address cannot be set to invalid.' => '',
        'This system address cannot be set to invalid, because it is used in one or more queue(s) or auto response(s).' =>
            '',

        # Template: AdminSystemConfiguration
        'online administrator documentation' => '',
        'System configuration' => '',
        'Navigate through the available settings by using the tree in the navigation box on the left side.' =>
            '',
        'Find certain settings by using the search field below or from search icon from the top navigation.' =>
            '',
        'Find out how to use the system configuration by reading the %s.' =>
            '',
        'Search in all settings...' => '',
        'There are currently no settings available. Please make sure to run \'otrs.Console.pl Maint::Config::Rebuild\' before using the software.' =>
            '',

        # Template: AdminSystemConfigurationDeployment
        'Changes Deployment' => '',
        'Help' => '',
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
        'Changes Overview' => '',
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
        'Deploy selected changes' => '',

        # Template: AdminSystemConfigurationGroup
        'This group doesn\'t contain any settings. Please try navigating to one of its sub groups.' =>
            '',

        # Template: AdminSystemConfigurationImportExport
        'Import & Export' => '',
        'Upload a file to be imported to your system (.yml format as exported from the System Configuration module).' =>
            '',
        'Upload system configuration' => '',
        'Import system configuration' => '',
        'Download current configuration settings of your system in a .yml file.' =>
            '',
        'Include user settings' => '',
        'Export current configuration' => '',

        # Template: AdminSystemConfigurationSearch
        'Search for' => '',
        'Search for category' => '',
        'Settings I\'m currently editing' => '',
        'Your search for "%s" in category "%s" did not return any results.' =>
            '',
        'Your search for "%s" in category "%s" returned one result.' => '',
        'Your search for "%s" in category "%s" returned %s results.' => '',
        'You\'re currently not editing any settings.' => '',
        'You\'re currently editing %s setting(s).' => '',

        # Template: AdminSystemConfigurationSearchDialog
        'Category' => 'Catégorie',
        'Run search' => 'Exécuter la recherche',

        # Template: AdminSystemConfigurationView
        'View a custom List of Settings' => '',
        'View single Setting: %s' => '',
        'Go back to Deployment Details' => '',

        # Template: AdminSystemMaintenance
        'System Maintenance Management' => '',
        'Schedule New System Maintenance' => '',
        'Filter for System Maintenances' => '',
        'Filter for system maintenances' => '',
        'Schedule a system maintenance period for announcing the Agents and Customers the system is down for a time period.' =>
            '',
        'Some time before this system maintenance starts the users will receive a notification on each screen announcing about this fact.' =>
            '',
        'Stop date' => '',
        'Delete System Maintenance' => '',

        # Template: AdminSystemMaintenanceEdit
        'Edit System Maintenance' => '',
        'Edit System Maintenance Information' => '',
        'Date invalid!' => 'Date invalide',
        'Login message' => '',
        'This field must have less then 250 characters.' => '',
        'Show login message' => '',
        'Notify message' => '',
        'Manage Sessions' => '',
        'All Sessions' => '',
        'Agent Sessions' => '',
        'Customer Sessions' => '',
        'Kill all Sessions, except for your own' => '',

        # Template: AdminTemplate
        'Template Management' => '',
        'Add Template' => '',
        'Edit Template' => '',
        'A template is a default text which helps your agents to write faster tickets, answers or forwards.' =>
            '',
        'Don\'t forget to add new templates to queues.' => '',
        'Attachments' => 'Pièces jointes ',
        'Delete this entry' => 'Supprimer cette entrée',
        'Do you really want to delete this template?' => '',
        'A standard template with this name already exists!' => '',
        'Template' => '',
        'To get the first 20 characters of the subject of the current/latest agent article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            '',
        'To get the first 5 lines of the body of the current/latest agent article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            '',
        'To get the first 20 characters of the subject of the current/latest article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            '',
        'To get the first 5 lines of the body of the current/latest article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            '',
        'Create type templates only supports this smart tags' => '',
        'Example template' => '',
        'The current ticket state is' => 'L\'état actuel de la demande est',
        'Your email address is' => 'Votre adresse de courrier électronique est',

        # Template: AdminTemplateAttachment
        'Manage Template-Attachment Relations' => '',
        'Toggle active for all' => 'Sélectionner actif pour tous',
        'Link %s to selected %s' => 'Lier %s à la sélection %s ',

        # Template: AdminType
        'Type Management' => 'Gestion des types',
        'Add Type' => 'Ajouter un type',
        'Edit Type' => 'Éditer un type',
        'Filter for Types' => '',
        'Filter for types' => '',
        'A type with this name already exists!' => '',
        'This type is present in a SysConfig setting, confirmation for updating settings to point to the new type is needed!' =>
            '',
        'This type is used in the following config settings:' => '',

        # Template: AdminUser
        'Agent Management' => 'Gestion des agents',
        'Edit Agent' => 'Modifier l\'agent',
        'Edit personal preferences for this agent' => '',
        'Agents will be needed to handle tickets.' => 'Les demandes devront être gérées par des agents.',
        'Don\'t forget to add a new agent to groups and/or roles!' => 'N\'oubliez pas d\'ajouter un agent aux groupes et aux rôles.',
        'Please enter a search term to look for agents.' => 'Merci d\'entrer un terme de recherche pour chercher des agents',
        'Last login' => 'Dernière connexion',
        'Switch to agent' => 'Changer pour l\'agent : ',
        'Title or salutation' => '',
        'Firstname' => 'Prénom ',
        'Lastname' => 'Nom ',
        'A user with this username already exists!' => '',
        'Will be auto-generated if left empty.' => '',
        'Mobile' => 'Téléphone mobile ',
        'Effective Permissions for Agent' => '',
        'This agent has no group permissions.' => '',
        'Table above shows effective group permissions for the agent. The matrix takes into account all inherited permissions (e.g. via roles).' =>
            '',

        # Template: AdminUserGroup
        'Manage Agent-Group Relations' => 'Gestion des relations agent-groupe',

        # Template: AgentAppointmentAgendaOverview
        'Agenda Overview' => '',
        'Manage Calendars' => '',
        'Add Appointment' => '',
        'Today' => 'Aujourd\'hui',
        'All-day' => '',
        'Repeat' => '',
        'Notification' => 'Notifications ',
        'Yes' => 'Oui',
        'No' => 'Non',
        'No calendars found. Please add a calendar first by using Manage Calendars page.' =>
            '',

        # Template: AgentAppointmentCalendarOverview
        'Add new Appointment' => '',
        'Calendars' => '',

        # Template: AgentAppointmentEdit
        'Basic information' => '',
        'Date/Time' => '',
        'Invalid date!' => 'Date invalide.',
        'Please set this to value before End date.' => '',
        'Please set this to value after Start date.' => '',
        'This an occurrence of a repeating appointment.' => '',
        'Click here to see the parent appointment.' => '',
        'Click here to edit the parent appointment.' => '',
        'Frequency' => '',
        'Every' => '',
        'day(s)' => 'jour(s)',
        'week(s)' => 'semaine(s)',
        'month(s)' => 'mois',
        'year(s)' => 'année(s)',
        'On' => 'Activée',
        'Monday' => 'Lundi',
        'Mon' => 'Lun',
        'Tuesday' => 'Mardi',
        'Tue' => 'Mar',
        'Wednesday' => 'Mercredi',
        'Wed' => 'Mer',
        'Thursday' => 'Jeudi',
        'Thu' => 'Jeu',
        'Friday' => 'Vendredi',
        'Fri' => 'Ven',
        'Saturday' => 'Samedi',
        'Sat' => 'Sam',
        'Sunday' => 'Dimanche',
        'Sun' => 'Dim',
        'January' => 'Janvier',
        'Jan' => 'Jan',
        'February' => 'Février',
        'Feb' => 'Fév',
        'March' => 'Mars',
        'Mar' => 'Mar',
        'April' => 'Avril',
        'Apr' => 'Avr',
        'May_long' => 'Mai',
        'May' => 'Mai',
        'June' => 'Juin',
        'Jun' => 'Juin',
        'July' => 'Juillet',
        'Jul' => 'Juil',
        'August' => 'Août',
        'Aug' => 'Aoû',
        'September' => 'Septembre',
        'Sep' => 'Sep',
        'October' => 'Octobre',
        'Oct' => 'Oct',
        'November' => 'Novembre',
        'Nov' => 'Nov',
        'December' => 'Décembre',
        'Dec' => 'Déc',
        'Relative point of time' => '',
        'Link' => 'Lier ',
        'Remove entry' => 'Supprimer l\'entrée',

        # Template: AgentCustomerInformationCenter
        'Customer Information Center' => 'Tableau de bord client',

        # Template: AgentCustomerInformationCenterSearch
        'Customer User' => 'Client utilisateur ',

        # Template: AgentCustomerTableView
        'Note: Customer is invalid!' => '',
        'Start chat' => '',
        'Video call' => '',
        'Audio call' => '',

        # Template: AgentCustomerUserAddressBook
        'Customer User Address Book' => '',
        'Search for recipients and add the results as \'%s\'.' => '',
        'Search template' => 'Modèle de recherche ',
        'Create Template' => 'Créer Modèle',
        'Create New' => 'Créer nouveau',
        'Save changes in template' => 'Sauvegarder les modifications du modèle',
        'Filters in use' => 'Filtres utilisés',
        'Additional filters' => 'Filtres additionnels',
        'Add another attribute' => 'Ajouter un autre attribut ',
        'The attributes with the identifier \'(Customer)\' are from the customer company.' =>
            '',
        '(e. g. Term* or *Term*)' => '',

        # Template: AgentCustomerUserAddressBookOverview
        'Select all' => 'Tout sélectionner',
        'The customer user is already selected in the ticket mask.' => '',
        'Select this customer user' => '',
        'Add selected customer user to' => '',

        # Template: AgentCustomerUserAddressBookOverviewNavBar
        'Change search options' => 'Modifier les options de recherche',

        # Template: AgentCustomerUserInformationCenter
        'Customer User Information Center' => '',

        # Template: AgentDaemonInfo
        'The OTRS Daemon is a daemon process that performs asynchronous tasks, e.g. ticket escalation triggering, email sending, etc.' =>
            '',
        'A running OTRS Daemon is mandatory for correct system operation.' =>
            '',
        'Starting the OTRS Daemon' => '',
        'Make sure that the file \'%s\' exists (without .dist extension). This cron job will check every 5 minutes if the OTRS Daemon is running and start it if needed.' =>
            '',
        'Execute \'%s start\' to make sure the cron jobs of the \'otrs\' user are active.' =>
            '',
        'After 5 minutes, check that the OTRS Daemon is running in the system (\'bin/otrs.Daemon.pl status\').' =>
            '',

        # Template: AgentDashboard
        'Dashboard' => 'Tableau de bord',

        # Template: AgentDashboardAppointmentCalendar
        'New Appointment' => '',
        'Tomorrow' => 'Demain',
        'Soon' => '',
        '5 days' => '',
        'Start' => 'Début ',
        'none' => 'néant',

        # Template: AgentDashboardCalendarOverview
        'in' => 'dans',

        # Template: AgentDashboardCommon
        'Save settings' => '',
        'Close this widget' => '',
        'more' => 'plus',
        'Available Columns' => '',
        'Visible Columns (order by drag & drop)' => '',

        # Template: AgentDashboardCustomerIDList
        'Change Customer Relations' => '',
        'Open' => 'Ouverts',
        'Closed' => 'Fermées',
        '%s open ticket(s) of %s' => '',
        '%s closed ticket(s) of %s' => '',
        'Edit customer ID' => '',

        # Template: AgentDashboardCustomerIDStatus
        'Escalated tickets' => 'Demandes escaladées',
        'Open tickets' => 'Demandes ouvertes',
        'Closed tickets' => 'Demandes fermées',
        'All tickets' => 'Toutes les demandes',
        'Archived tickets' => 'Demandes archivées',

        # Template: AgentDashboardCustomerUserInformation
        'Note: Customer User is invalid!' => '',

        # Template: AgentDashboardCustomerUserList
        'Customer user information' => '',
        'Phone ticket' => '',
        'Email ticket' => '',
        'New phone ticket from %s' => 'Nouvelle demande téléphonique de %s',
        'New email ticket to %s' => '',

        # Template: AgentDashboardProductNotify
        '%s %s is available!' => '%s %s est accessible.',
        'Please update now.' => 'Veuillez mettre à jour maintenant.',
        'Release Note' => 'Instructions d\'utilisation',
        'Level' => 'Niveau ',

        # Template: AgentDashboardRSSOverview
        'Posted %s ago.' => 'Envoyé il y a %s',

        # Template: AgentDashboardStats
        'The configuration for this statistic widget contains errors, please review your settings.' =>
            '',
        'Download as SVG file' => '',
        'Download as PNG file' => '',
        'Download as CSV file' => '',
        'Download as Excel file' => '',
        'Download as PDF file' => '',
        'Please select a valid graph output format in the configuration of this widget.' =>
            '',
        'The content of this statistic is being prepared for you, please be patient.' =>
            '',
        'This statistic can currently not be used because its configuration needs to be corrected by the statistics administrator.' =>
            '',

        # Template: AgentDashboardTicketGeneric
        'Assigned to customer user' => '',
        'Accessible for customer user' => '',
        'My locked tickets' => 'Mes demandes verrouillées',
        'My watched tickets' => 'Mes demandes sous surveillance',
        'My responsibilities' => 'Mes responsabilités',
        'Tickets in My Queues' => 'Demandes dans mes files',
        'Tickets in My Services' => 'Demandes dans mes services',
        'Service Time' => 'Délai du service',

        # Template: AgentDashboardTicketQueueOverview
        'Total' => '',

        # Template: AgentDashboardUserOnline
        'out of office' => '',

        # Template: AgentDashboardUserOutOfOffice
        'until' => '',

        # Template: AgentInfo
        'To accept some news, a license or some changes.' => 'Pour accepter des nouvelles, une licence ou des modifications.',
        'Yes, accepted.' => '',

        # Template: AgentLinkObject
        'Manage links for %s' => '',
        'Create new links' => '',
        'Manage existing links' => '',
        'Link with' => '',
        'Start search' => '',
        'There are currently no links. Please click \'Create new Links\' on the top to link this item to other objects.' =>
            '',

        # Template: AgentOTRSBusinessBlockScreen
        'Unauthorized usage of %s detected' => '',
        'If you decide to downgrade to ((OTRS)) Community Edition, you will lose all database tables and data related to %s.' =>
            '',

        # Template: AgentPreferences
        'Edit your preferences' => 'Éditer vos préférences',
        'Personal Preferences' => '',
        'Preferences' => 'Préférences',
        'Please note: you\'re currently editing the preferences of %s.' =>
            '',
        'Go back to editing this agent' => '',
        'Set up your personal preferences. Save each setting by clicking the checkmark on the right.' =>
            '',
        'You can use the navigation tree below to only show settings from certain groups.' =>
            '',
        'Dynamic Actions' => '',
        'Filter settings...' => '',
        'Filter for settings' => '',
        'Save all settings' => '',
        'Avatars have been disabled by the system administrator. You\'ll see your initials instead.' =>
            '',
        'You can change your avatar image by registering with your email address %s at %s. Please note that it can take some time until your new avatar becomes available because of caching.' =>
            '',
        'Off' => 'Désactivée',
        'End' => 'Fin ',
        'This setting can currently not be saved.' => '',
        'This setting can currently not be saved' => '',
        'Save this setting' => '',
        'Did you know? You can help translating OTRS at %s.' => '',

        # Template: SettingsList
        'Reset to default' => '',

        # Template: AgentPreferencesOverview
        'Choose from the groups on the right to find the settings you\'d wish to change.' =>
            '',
        'Did you know?' => '',
        'You can change your avatar by registering with your email address %s on %s' =>
            '',

        # Template: AgentSplitSelection
        'Target' => '',
        'Process' => '',
        'Split' => 'Scinder',

        # Template: AgentStatisticsAdd
        'Statistics Management' => '',
        'Add Statistics' => '',
        'Read more about statistics in OTRS' => '',
        'Dynamic Matrix' => '',
        'Each cell contains a singular data point.' => '',
        'Dynamic List' => '',
        'Each row contains data of one entity.' => '',
        'Static' => '',
        'Non-configurable complex statistics.' => '',
        'General Specification' => '',
        'Create Statistic' => '',

        # Template: AgentStatisticsEdit
        'Edit Statistics' => '',
        'Run now' => '',
        'Statistics Preview' => '',
        'Save Statistic' => '',

        # Template: AgentStatisticsImport
        'Import Statistics' => '',
        'Import Statistics Configuration' => '',

        # Template: AgentStatisticsOverview
        'Statistics' => 'Statistiques',
        'Run' => '',
        'Edit statistic "%s".' => '',
        'Export statistic "%s"' => '',
        'Export statistic %s' => '',
        'Delete statistic "%s"' => '',
        'Delete statistic %s' => '',

        # Template: AgentStatisticsView
        'Statistics Overview' => '',
        'View Statistics' => '',
        'Statistics Information' => '',
        'Created by' => 'Créée par ',
        'Changed by' => 'Changement effectué par ',
        'Sum rows' => 'Lignes des totaux ',
        'Sum columns' => 'Colonnes des totaux ',
        'Show as dashboard widget' => '',
        'Cache' => 'Cache ',
        'This statistic contains configuration errors and can currently not be used.' =>
            '',

        # Template: AgentTicketActionCommon
        'Change Free Text of %s%s%s' => '',
        'Change Owner of %s%s%s' => '',
        'Close %s%s%s' => '',
        'Add Note to %s%s%s' => '',
        'Set Pending Time for %s%s%s' => '',
        'Change Priority of %s%s%s' => '',
        'Change Responsible of %s%s%s' => '',
        'All fields marked with an asterisk (*) are mandatory.' => 'Tous les champs marqués d\'une étoile (*) sont obligatoires.',
        'The ticket has been locked' => 'La demande a été verrouillée',
        'Undo & close' => 'Annuler et fermer',
        'Ticket Settings' => 'Configuration des demandes',
        'Queue invalid.' => '',
        'Service invalid.' => 'Service non admissible.',
        'SLA invalid.' => '',
        'New Owner' => 'Nouveau propriétaire ',
        'Please set a new owner!' => 'Veuillez configurer un nouveau propriétaire.',
        'Owner invalid.' => '',
        'New Responsible' => '',
        'Please set a new responsible!' => '',
        'Responsible invalid.' => '',
        'Next state' => 'Nouvel état ',
        'State invalid.' => '',
        'For all pending* states.' => 'Pour tout les états en attente.',
        'Add Article' => '',
        'Create an Article' => '',
        'Inform agents' => '',
        'Inform involved agents' => '',
        'Here you can select additional agents which should receive a notification regarding the new article.' =>
            '',
        'Text will also be received by' => '',
        'Text Template' => '',
        'Setting a template will overwrite any text or attachment.' => '',
        'Invalid time!' => 'Heure ou durée invalide.',

        # Template: AgentTicketBounce
        'Bounce %s%s%s' => '',
        'Bounce to' => 'Retourner à',
        'You need a email address.' => 'Vous devez avoir une adresse électronique.',
        'Need a valid email address or don\'t use a local email address.' =>
            'Une adresse électronique valide est nécessaire. N\'utilisez pas d\'adresse électronique locale.',
        'Next ticket state' => 'Prochain état de la demande ',
        'Inform sender' => 'Informer l\'expéditeur ',
        'Send mail' => 'Envoyer le courriel',

        # Template: AgentTicketBulk
        'Ticket Bulk Action' => 'Action groupée des demandes',
        'Send Email' => 'Envoyer le courriel',
        'Merge' => 'Fusionner',
        'Merge to' => 'Fusionner avec',
        'Invalid ticket identifier!' => 'Identificateur de demande invalide.',
        'Merge to oldest' => 'Fusionner avec le plus ancien',
        'Link together' => 'Lier ensemble',
        'Link to parent' => 'Lier au parent',
        'Unlock tickets' => 'Déverrouiller les demandes',
        'Execute Bulk Action' => 'Exécuter l\'action groupée',

        # Template: AgentTicketCompose
        'Compose Answer for %s%s%s' => '',
        'This address is registered as system address and cannot be used: %s' =>
            '',
        'Please include at least one recipient' => 'Merci d\'inclure au moins un destinataire',
        'Select one or more recipients from the customer user address book.' =>
            '',
        'Customer user address book' => '',
        'Remove Ticket Customer' => 'Retirer la demande du client',
        'Please remove this entry and enter a new one with the correct value.' =>
            'Merci de retirer cette entrée et de la remplacer par une valeur correcte.',
        'This address already exists on the address list.' => 'Cette adresse est déjà dans la liste.',
        'Remove Cc' => 'Retirer le Cc',
        'Bcc' => 'Copie invisible ',
        'Remove Bcc' => 'Retirer le Bcc',
        'Date Invalid!' => 'Date invalide',

        # Template: AgentTicketCustomer
        'Change Customer of %s%s%s' => '',
        'Customer Information' => 'Renseignements sur le client',
        'Customer user' => 'Client utilisateur ',

        # Template: AgentTicketEmail
        'Create New Email Ticket' => 'Créer une nouvelle demande courriel',
        'Example Template' => '',
        'From queue' => 'De la file ',
        'To customer user' => 'Au client utilisateur',
        'Please include at least one customer user for the ticket.' => '',
        'Select this customer as the main customer.' => '',
        'Remove Ticket Customer User' => '',
        'Get all' => 'Tout prendre',

        # Template: AgentTicketEmailOutbound
        'Outbound Email for %s%s%s' => '',

        # Template: AgentTicketEmailResend
        'Resend Email for %s%s%s' => '',

        # Template: AgentTicketEscalation
        'Ticket %s: first response time is over (%s/%s)!' => '',
        'Ticket %s: first response time will be over in %s/%s!' => '',
        'Ticket %s: update time is over (%s/%s)!' => '',
        'Ticket %s: update time will be over in %s/%s!' => '',
        'Ticket %s: solution time is over (%s/%s)!' => '',
        'Ticket %s: solution time will be over in %s/%s!' => '',

        # Template: AgentTicketForward
        'Forward %s%s%s' => '',

        # Template: AgentTicketHistory
        'History of %s%s%s' => '',
        'Filter for history items' => '',
        'Expand/collapse all' => '',
        'CreateTime' => '',
        'Article' => 'Article ',

        # Template: AgentTicketMerge
        'Merge %s%s%s' => '',
        'Merge Settings' => '',
        'You need to use a ticket number!' => 'Vous devez inscrire un numéro de demande.',
        'A valid ticket number is required.' => 'Le numéro de demande doit être valide.',
        'Try typing part of the ticket number or title in order to search by it.' =>
            '',
        'Limit the search to tickets with same Customer ID (%s).' => '',
        'Inform Sender' => '',
        'Need a valid email address.' => 'L\'adresse de courrier électronique doit être valide.',

        # Template: AgentTicketMove
        'Move %s%s%s' => '',
        'New Queue' => 'Nouvelle file',
        'Move' => 'Déplacer',

        # Template: AgentTicketOverviewMedium
        'No ticket data found.' => 'Aucune donnée relative à la demande n\'a été trouvée.',
        'Open / Close ticket action menu' => '',
        'Select this ticket' => '',
        'Sender' => 'Émetteur',
        'First Response Time' => 'Délai de la première réponse',
        'Update Time' => 'Délai de mise à jour ',
        'Solution Time' => 'Délai de résolution ',
        'Move ticket to a different queue' => 'Déplacer la demande vers une autre file',
        'Change queue' => 'Changer de file',

        # Template: AgentTicketOverviewNavBar
        'Remove active filters for this screen.' => '',
        'Tickets per page' => 'Demandes par page ',

        # Template: AgentTicketOverviewPreview
        'Missing channel' => '',

        # Template: AgentTicketOverviewSmall
        'Reset overview' => '',
        'Column Filters Form' => '',

        # Template: AgentTicketPhone
        'Split Into New Phone Ticket' => '',
        'Save Chat Into New Phone Ticket' => '',
        'Create New Phone Ticket' => 'Créer une nouvelle demande téléphonique',
        'Please include at least one customer for the ticket.' => 'Veuillez ajouter au moins un client à la demande.',
        'To queue' => 'Vers la file ',
        'Chat protocol' => '',
        'The chat will be appended as a separate article.' => '',

        # Template: AgentTicketPhoneCommon
        'Phone Call for %s%s%s' => '',

        # Template: AgentTicketPlain
        'View Email Plain Text for %s%s%s' => '',
        'Plain' => 'Normal',
        'Download this email' => 'Télécharger ce courriel',

        # Template: AgentTicketProcess
        'Create New Process Ticket' => '',

        # Template: AgentTicketProcessSmall
        'Enroll Ticket into a Process' => '',

        # Template: AgentTicketSearch
        'Profile link' => 'Lien vers le profil',
        'Output' => 'Format du résultat ',
        'Fulltext' => 'Texte complet ',
        'Customer ID (complex search)' => '',
        '(e. g. 234*)' => '',
        'Customer ID (exact match)' => '',
        'Assigned to Customer User Login (complex search)' => '',
        '(e. g. U51*)' => '',
        'Assigned to Customer User Login (exact match)' => '',
        'Accessible to Customer User Login (exact match)' => '',
        'Created in Queue' => 'Créée dans la file ',
        'Lock state' => 'État du verrou ',
        'Watcher' => 'Surveillance',
        'Article Create Time (before/after)' => 'Moment de la création de l\'article (avant/après) ',
        'Article Create Time (between)' => 'Moment de la création de l\'article (entre) ',
        'Please set this to value before end date.' => '',
        'Please set this to value after start date.' => '',
        'Ticket Create Time (before/after)' => 'Moment de la création de la demande (avant/après) ',
        'Ticket Create Time (between)' => 'Moment de la création de la demande (entre) ',
        'Ticket Change Time (before/after)' => 'Moment de la modification de la demande (avant/après) ',
        'Ticket Change Time (between)' => 'Moment de la modification de la demande (entre) ',
        'Ticket Last Change Time (before/after)' => '',
        'Ticket Last Change Time (between)' => '',
        'Ticket Pending Until Time (before/after)' => '',
        'Ticket Pending Until Time (between)' => '',
        'Ticket Close Time (before/after)' => 'Moment de la fermeture de la demande (avant/après) ',
        'Ticket Close Time (between)' => 'Moment de la fermeture de la demande (entre) ',
        'Ticket Escalation Time (before/after)' => '',
        'Ticket Escalation Time (between)' => '',
        'Archive Search' => 'Recherche dans les archives',

        # Template: AgentTicketZoom
        'Sender Type' => 'Type d\'expéditeur',
        'Save filter settings as default' => 'Sauvegarder les paramètres des filtres en tant que paramètres par défaut',
        'Event Type' => '',
        'Save as default' => '',
        'Drafts' => '',
        'by' => 'par',
        'Change Queue' => 'Changer de file',
        'There are no dialogs available at this point in the process.' =>
            '',
        'This item has no articles yet.' => '',
        'Ticket Timeline View' => '',
        'Article Overview - %s Article(s)' => '',
        'Page %s' => '',
        'Add Filter' => 'Ajouter un filtre',
        'Set' => 'Définir',
        'Reset Filter' => 'Réinitialiser le filtre',
        'No.' => 'No',
        'Unread articles' => 'Articles non lus',
        'Via' => '',
        'Important' => 'Important',
        'Unread Article!' => 'Article non lu.',
        'Incoming message' => 'Message entrant',
        'Outgoing message' => 'Message sortant',
        'Internal message' => 'Message interne',
        'Sending of this message has failed.' => '',
        'Resize' => 'Redimensionner',
        'Mark this article as read' => '',
        'Show Full Text' => '',
        'Full Article Text' => '',
        'No more events found. Please try changing the filter settings.' =>
            '',

        # Template: Chat
        '#%s' => '',
        'via %s' => '',
        'by %s' => '',
        'Toggle article details' => '',

        # Template: MIMEBase
        'This message is being processed. Already tried to send %s time(s). Next try will be %s.' =>
            '',
        'To open links in the following article, you might need to press Ctrl or Cmd or Shift key while clicking the link (depending on your browser and OS).' =>
            'Pour ouvrir les liens dans cet article, vous devrez peut-être maintenir enfoncée la touche Ctrl, Cmd ou Shift en cliquant sur le lien, selon votre fureteur et votre OS.',
        'Close this message' => '',
        'Image' => '',
        'PDF' => '',
        'Unknown' => '',
        'View' => 'Vue ',

        # Template: LinkTable
        'Linked Objects' => 'Objets liés',

        # Template: TicketInformation
        'Archive' => '',
        'This ticket is archived.' => '',
        'Note: Type is invalid!' => '',
        'Pending till' => 'En attente jusqu\'au ',
        'Locked' => 'Verrou ',
        '%s Ticket(s)' => '',
        'Accounted time' => 'Temps alloué ',

        # Template: Invalid
        'Preview of this article is not possible because %s channel is missing in the system.' =>
            '',
        'This feature is part of the %s. Please contact us at %s for an upgrade.' =>
            '',
        'Please re-install %s package in order to display this article.' =>
            '',

        # Template: AttachmentBlocker
        'To protect your privacy, remote content was blocked.' => 'Pour protéger votre vie privée, les contenus distants ont été bloqués.',
        'Load blocked content.' => 'Charger le contenu bloqué',

        # Template: Breadcrumb
        'Home' => '',
        'Back to admin overview' => '',

        # Template: CloudServicesDisabled
        'This Feature Requires Cloud Services' => '',
        'You can' => 'Vous pouvez',
        'go back to the previous page' => 'Revenir à la page précédente',

        # Template: CustomerAccept
        'Dear Customer,' => '',
        'thank you for using our services.' => '',
        'Yes, I accept your license.' => '',

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
        'Error Details' => 'Détails de l\'erreur',
        'Traceback' => 'Traçage',

        # Template: CustomerFooter
        '%s powered by %s™' => '',
        'Powered by %s™' => '',

        # Template: CustomerFooterJS
        '%s detected possible network issues. You could either try reloading this page manually or wait until your browser has re-established the connection on its own.' =>
            '',
        'The connection has been re-established after a temporary connection loss. Due to this, elements on this page could have stopped to work correctly. In order to be able to use all elements correctly again, it is strongly recommended to reload this page.' =>
            '',

        # Template: CustomerLogin
        'JavaScript Not Available' => 'JavaScript indisponible',
        'In order to experience this software, you\'ll need to enable JavaScript in your browser.' =>
            '',
        'Browser Warning' => 'Avertissement du navigateur',
        'The browser you are using is too old.' => 'Votre navigateur est trop ancien.',
        'This software runs with a huge lists of browsers, please upgrade to one of these.' =>
            '',
        'Please see the documentation or ask your admin for further information.' =>
            'Pour de plus amples renseignements, veuillez consulter la documentation ou communiquer avec à votre administrateur système.',
        'One moment please, you are being redirected...' => 'Vous êtes redirigé, un moment SVP...',
        'Login' => 'S\'authentifier',
        'User name' => 'Nom d\'utilisateur',
        'Your user name' => 'Votre nom d\'utilisateur',
        'Your password' => 'Votre mot de passe',
        'Forgot password?' => 'Mot de passe oublié?',
        '2 Factor Token' => '',
        'Your 2 Factor Token' => '',
        'Log In' => 'Se connecter',
        'Not yet registered?' => 'Pas encore inscrit?',
        'Back' => 'Retour',
        'Request New Password' => 'Demander un nouveau mot de passe',
        'Your User Name' => 'Votre nom d\'utilisateur',
        'A new password will be sent to your email address.' => 'Un nouveau mot de passe sera envoyé à votre adresse électronique.',
        'Create Account' => 'Créer un compte',
        'Please fill out this form to receive login credentials.' => 'Veuillez remplir ce formulaire pour recevoir les justificatifs d\'identité permettant de se connecter.',
        'How we should address you' => 'Titre de civilité',
        'Your First Name' => 'Prénom',
        'Your Last Name' => 'Nom de famille',
        'Your email address (this will become your username)' => 'Votre adresse électronique (vous utiliserez celle-ci comme nom d\'utilisateur)',

        # Template: CustomerNavigationBar
        'Incoming Chat Requests' => '',
        'Edit personal preferences' => 'Éditer les préférences',
        'Logout %s' => '',

        # Template: CustomerTicketMessage
        'Service level agreement' => 'Accord de niveau de service',

        # Template: CustomerTicketOverview
        'Welcome!' => 'Bienvenue !',
        'Please click the button below to create your first ticket.' => 'Veuillez cliquer sur le bouton ci-dessous pour créer votre première demande.',
        'Create your first ticket' => 'Créer votre première demande',

        # Template: CustomerTicketSearch
        'Profile' => 'Profil',
        'e. g. 10*5155 or 105658*' => 'p. ex. 10*5155 ou 105658*',
        'CustomerID' => 'Numéro de client ',
        'Fulltext Search in Tickets (e. g. "John*n" or "Will*")' => '',
        'Types' => 'Types',
        'Time Restrictions' => '',
        'No time settings' => 'Pas de réglages de temps',
        'All' => 'Tout',
        'Specific date' => '',
        'Only tickets created' => 'Seulement les demandes créées',
        'Date range' => '',
        'Only tickets created between' => 'Seulement les demandes créées entre',
        'Ticket Archive System' => '',
        'Save Search as Template?' => '',
        'Save as Template?' => 'Sauvegarder comme modèle',
        'Save as Template' => 'Sauver comme Modèle',
        'Template Name' => 'Nom de modèle',
        'Pick a profile name' => 'Choisir un nom de profil',
        'Output to' => 'Sortie vers',

        # Template: CustomerTicketSearchResultShort
        'of' => 'de',
        'Page' => 'Page ',
        'Search Results for' => 'Résultats de recherche pour',
        'Remove this Search Term.' => 'Supprimer ce terme de recherche.',

        # Template: CustomerTicketZoom
        'Start a chat from this ticket' => '',
        'Next Steps' => '',
        'Reply' => 'Répondre',

        # Template: Chat
        'Expand article' => 'Développer l\'article',

        # Template: CustomerWarning
        'Warning' => 'Avertissement',

        # Template: DashboardEventsTicketCalendar
        'Event Information' => '',
        'Ticket fields' => '',

        # Template: Error
        'Really a bug? 5 out of 10 bug reports result from a wrong or incomplete installation of OTRS.' =>
            '',
        'With %s, our experts take care of correct installation and cover your back with support and periodic security updates.' =>
            '',
        'Contact our service team now.' => '',
        'Send a bugreport' => 'Envoyer un rapport d\'erreur',
        'Expand' => 'Développer',

        # Template: AttachmentList
        'Click to delete this attachment.' => '',

        # Template: DraftButtons
        'Update draft' => '',
        'Save as new draft' => '',

        # Template: DraftNotifications
        'You have loaded the draft "%s".' => '',
        'You have loaded the draft "%s". You last changed it %s.' => '',
        'You have loaded the draft "%s". It was last changed %s by %s.' =>
            '',
        'Please note that this draft is outdated because the ticket was modified since this draft was created.' =>
            '',

        # Template: Header
        'View notifications' => '',
        'Notifications' => '',
        'Notifications (OTRS Business Solution™)' => '',
        'Personal preferences' => '',
        'Logout' => 'Déconnexion',
        'You are logged in as' => 'Vous êtes connecté en tant que',

        # Template: Installer
        'JavaScript not available' => 'JavaScript non disponible',
        'Step %s' => 'Étape %s',
        'License' => 'Licence ',
        'Database Settings' => 'Réglages de la base de données',
        'General Specifications and Mail Settings' => 'Caractéristiques générales et réglages de courriel',
        'Finish' => 'Terminer',
        'Welcome to %s' => 'Bienvenue dans %s',
        'Germany' => '',
        'Phone' => 'Téléphone ',
        'United States' => '',
        'Mexico' => '',
        'Hungary' => '',
        'Brazil' => '',
        'Singapore' => '',
        'Hong Kong' => '',
        'Web site' => 'Site Web',

        # Template: InstallerConfigureMail
        'Configure Outbound Mail' => 'Configurer le courriel sortant',
        'Outbound mail type' => 'Type de courriel sortant',
        'Select outbound mail type.' => 'Sélectionner le type de courriel sortant.',
        'Outbound mail port' => 'Port de courriel sortant',
        'Select outbound mail port.' => 'Sélectionner le port de courriel sortant',
        'SMTP host' => 'Hôte SMTP',
        'SMTP host.' => 'Hôte SMTP.',
        'SMTP authentication' => 'Authentification SMTP',
        'Does your SMTP host need authentication?' => 'Est-ce-que votre hôte SMTP requiert une authentification?',
        'SMTP auth user' => 'Utilisateur de l\'authentification SMTP',
        'Username for SMTP auth.' => 'Nom utilisateur pour l\'authentification SMTP.',
        'SMTP auth password' => 'Mot de passe de l\'authentification SMTP',
        'Password for SMTP auth.' => 'Mot de passe pour l\'authentification SMTP.',
        'Configure Inbound Mail' => 'Configurer le courriel entrant',
        'Inbound mail type' => 'Type de courriel entrant',
        'Select inbound mail type.' => 'Sélectionner le type de courriel entrant',
        'Inbound mail host' => 'Hôte de courriel entrant',
        'Inbound mail host.' => 'Hôte de courriel entrant.',
        'Inbound mail user' => 'utilisateur du courriel entrant',
        'User for inbound mail.' => 'utilisateur pour le courriel entrant.',
        'Inbound mail password' => 'Mot de passe de courriel entrant',
        'Password for inbound mail.' => 'Mot de passe pour courriel entrant.',
        'Result of mail configuration check' => 'Résultat du contrôle de configuration de courriel',
        'Check mail configuration' => 'Vérifier la configuration courriel',
        'Skip this step' => 'Passer cette étape',

        # Template: InstallerDBResult
        'Done' => 'Terminé',
        'Error' => 'Erreur',
        'Database setup successful!' => 'Configuration de la base de données réussie.',

        # Template: InstallerDBStart
        'Install Type' => '',
        'Create a new database for OTRS' => '',
        'Use an existing database for OTRS' => '',

        # Template: InstallerDBmssql
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty.' =>
            '',
        'Database name' => '',
        'Check database settings' => 'Vérifier la configuration de la base de données',
        'Result of database check' => 'Résultat du contrôle de la base de données',
        'Database check successful.' => 'Contrôle de base de donnée effectué avec succès.',
        'Database User' => '',
        'New' => 'Nouvelle',
        'A new database user with limited permissions will be created for this OTRS system.' =>
            'Un nouvel utilisateur de la base de données avec des droits limités sera créé pour ce système OTRS.',
        'Repeat Password' => '',
        'Generated password' => '',

        # Template: InstallerDBmysql
        'Passwords do not match' => '',

        # Template: InstallerDBoracle
        'SID' => '',
        'Port' => '',

        # Template: InstallerFinish
        'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' =>
            'Pour pouvoir utiliser OTRS, vous devez entrer les commandes suivantes (Terminal ou Shell) en tant que segment résident.',
        'Restart your webserver' => 'Redémarrer votre serveur Web',
        'After doing so your OTRS is up and running.' => 'Après cela votre OTRS sera opérationnel.',
        'Start page' => 'Page de démarrage',
        'Your OTRS Team' => 'Votre Équipe OTRS',

        # Template: InstallerLicense
        'Don\'t accept license' => 'Ne pas accepter la licence',
        'Accept license and continue' => '',

        # Template: InstallerSystem
        'SystemID' => 'ID Système',
        'The identifier of the system. Each ticket number and each HTTP session ID contain this number.' =>
            'L\'identifiant du système. Chaque numéro de demande et chaque identité de session HTTP contiennent ce numéro.',
        'System FQDN' => 'Serveur de nom de domaine complet du système',
        'Fully qualified domain name of your system.' => 'Nom de domaine complet de votre système',
        'AdminEmail' => 'Adresse électronique de l\'administrateur.',
        'Email address of the system administrator.' => 'L\'adresse électronique de l\'administrateur de votre système.',
        'Organization' => 'Entreprise ',
        'Log' => 'Journal',
        'LogModule' => 'Module de journalisation',
        'Log backend to use.' => 'Journal à utiliser',
        'LogFile' => 'Fichier journal',
        'Webfrontend' => 'L\'avant-plan Web',
        'Default language' => 'Langue par défaut',
        'Default language.' => 'Langue par défaut.',
        'CheckMXRecord' => 'Vérifier les enregistrements messager',
        'Email addresses that are manually entered are checked against the MX records found in DNS. Don\'t use this option if your DNS is slow or does not resolve public addresses.' =>
            'Les adresses électroniques entrées manuellement sont contrevérifiées avec les enregistrements message du serveur de nom de domaine. N\'utilisez pas cette option si votre serveur de nom de domaine est lent ou qu\'il ne résout pas les adresses publiques.',

        # Template: LinkObject
        'Delete link' => '',
        'Delete Link' => '',
        'Object#' => 'Objet no ',
        'Add links' => 'Ajouter les liens',
        'Delete links' => 'Supprimer les liens',

        # Template: Login
        'Lost your password?' => 'Mot de passe oublié ?',
        'Back to login' => 'Retour à la page d\'ouverture de session',

        # Template: MetaFloater
        'Scale preview content' => '',
        'Open URL in new tab' => '',
        'Close preview' => '',
        'A preview of this website can\'t be provided because it didn\'t allow to be embedded.' =>
            '',

        # Template: MobileNotAvailableWidget
        'Feature not Available' => '',
        'Sorry, but this feature of OTRS is currently not available for mobile devices. If you\'d like to use it, you can either switch to desktop mode or use your regular desktop device.' =>
            '',

        # Template: Motd
        'Message of the Day' => 'Message du jour',
        'This is the message of the day. You can edit this in %s.' => '',

        # Template: NoPermission
        'Insufficient Rights' => 'Droits insuffisants',
        'Back to the previous page' => 'Revenir à la page précédente',

        # Template: Alert
        'Alert' => '',
        'Powered by' => 'Alimenté par ',

        # Template: Pagination
        'Show first page' => 'Afficher la première page',
        'Show previous pages' => 'Afficher les pages précédentes',
        'Show page %s' => 'Afficher la page %s',
        'Show next pages' => 'Afficher les pages suivantes',
        'Show last page' => 'Afficher la dernière page',

        # Template: PictureUpload
        'Need FormID!' => 'Vous devez posséder un formulaire d\'identification.',
        'No file found!' => 'Aucun fichier n\'a été trouvé.',
        'The file is not an image that can be shown inline!' => 'Le fichier n\'est pas une image pouvant être affichée en ligne.',

        # Template: PreferencesNotificationEvent
        'No user configurable notifications found.' => '',
        'Receive messages for notification \'%s\' by transport method \'%s\'.' =>
            '',

        # Template: ActivityDialogHeader
        'Process Information' => '',
        'Dialog' => '',

        # Template: Article
        'Inform Agent' => 'Informer l\'agent',

        # Template: PublicDefault
        'Welcome' => '',
        'This is the default public interface of OTRS! There was no action parameter given.' =>
            '',
        'You could install a custom public module (via the package manager), for example the FAQ module, which has a public interface.' =>
            '',

        # Template: GeneralSpecificationsWidget
        'Permissions' => 'Permissions ',
        'You can select one or more groups to define access for different agents.' =>
            'Afin de donner des accès à différents agents, sélectionnez un ou plusieurs groupes.',
        'Result formats' => '',
        'Time Zone' => 'Fuseau horaire',
        'The selected time periods in the statistic are time zone neutral.' =>
            '',
        'Create summation row' => '',
        'Generate an additional row containing sums for all data rows.' =>
            '',
        'Create summation column' => '',
        'Generate an additional column containing sums for all data columns.' =>
            '',
        'Cache results' => '',
        'Stores statistics result data in a cache to be used in subsequent views with the same configuration (requires at least one selected time field).' =>
            '',
        'Provide the statistic as a widget that agents can activate in their dashboard.' =>
            '',
        'Please note that enabling the dashboard widget will activate caching for this statistic in the dashboard.' =>
            '',
        'If set to invalid end users can not generate the stat.' => 'Si l\'option « non admissible » est choisie, les utilisateurs finaux ne pourront pas générer les statistiques.',

        # Template: PreviewWidget
        'There are problems in the configuration of this statistic:' => '',
        'You may now configure the X-axis of your statistic.' => '',
        'This statistic does not provide preview data.' => '',
        'Preview format' => '',
        'Please note that the preview uses random data and does not consider data filters.' =>
            '',
        'Configure X-Axis' => '',
        'X-axis' => 'Axe X',
        'Configure Y-Axis' => '',
        'Y-axis' => '',
        'Configure Filter' => '',

        # Template: RestrictionsWidget
        'Please select only one element or turn off the button \'Fixed\'.' =>
            'Veuillez ne sélectionner qu\'un seul élément ou désactiver le bouton « Figer ».',
        'Absolute period' => '',
        'Between %s and %s' => '',
        'Relative period' => '',
        'The past complete %s and the current+upcoming complete %s %s' =>
            '',
        'Do not allow changes to this element when the statistic is generated.' =>
            '',

        # Template: StatsParamsWidget
        'Format' => 'Format ',
        'Exchange Axis' => 'Échangez les axes',
        'Configurable Params of Static Stat' => '',
        'No element selected.' => 'Aucun élément n\'est sélectionné.',
        'Scale' => 'Échelle de l\'axe X ',
        'show more' => '',
        'show less' => '',

        # Template: D3
        'Download SVG' => '',
        'Download PNG' => '',

        # Template: XAxisWidget
        'The selected time period defines the default time frame for this statistic to collect data from.' =>
            '',
        'Defines the time unit that will be used to split the selected time period into reporting data points.' =>
            '',

        # Template: YAxisWidget
        'Please remember that the scale for the Y-axis has to be larger than the scale for the X-axis (e.g. X-axis => Month, Y-Axis => Year).' =>
            '',

        # Template: SettingsList
        'This setting is disabled.' => '',
        'This setting is fixed but not deployed yet!' => '',
        'This setting is currently being overridden in %s and can\'t thus be changed here!' =>
            '',
        'Changing this setting is only available in a higher config level!' =>
            '',
        '%s (%s) is currently working on this setting.' => '',
        'Toggle advanced options for this setting' => '',
        'Disable this setting, so it is no longer effective' => '',
        'Disable' => '',
        'Enable this setting, so it becomes effective' => '',
        'Enable' => '',
        'Reset this setting to its default state' => '',
        'Reset setting' => '',
        'Allow users to adapt this setting from within their personal preferences' =>
            '',
        'Allow users to update' => '',
        'Do not longer allow users to adapt this setting from within their personal preferences' =>
            '',
        'Forbid users to update' => '',
        'Show user specific changes for this setting' => '',
        'Show user settings' => '',
        'Copy a direct link to this setting to your clipboard' => '',
        'Copy direct link' => '',
        'Remove this setting from your favorites setting' => '',
        'Remove from favourites' => '',
        'Add this setting to your favorites' => '',
        'Add to favourites' => '',
        'Cancel editing this setting' => '',
        'Save changes on this setting' => '',
        'Edit this setting' => '',
        'Enable this setting' => '',
        'This group doesn\'t contain any settings. Please try navigating to one of its sub groups or another group.' =>
            '',

        # Template: SettingsListCompare
        'Now' => '',
        'User modification' => '',
        'enabled' => '',
        'disabled' => '',
        'Setting state' => '',

        # Template: Actions
        'Edit search' => '',
        'Go back to admin: ' => '',
        'Deployment' => '',
        'My favourite settings' => '',
        'Invalid settings' => '',

        # Template: DynamicActions
        'Filter visible settings...' => '',
        'Enable edit mode for all settings' => '',
        'Save all edited settings' => '',
        'Cancel editing for all settings' => '',
        'All actions from this widget apply to the visible settings on the right only.' =>
            '',

        # Template: Help
        'Currently edited by me.' => '',
        'Modified but not yet deployed.' => '',
        'Currently edited by another user.' => '',
        'Different from its default value.' => '',
        'Save current setting.' => '',
        'Cancel editing current setting.' => '',

        # Template: Navigation
        'Navigation' => '',

        # Template: OTRSBusinessTeaser
        'With %s, System Configuration supports versioning, rollback and user-specific configuration settings.' =>
            '',

        # Template: Test
        'OTRS Test Page' => 'Page de test de OTRS',
        'Unlock' => 'Déverrouillée',
        'Welcome %s %s' => '',
        'Counter' => 'Compteur',

        # Template: Warning
        'Go back to the previous page' => 'Revenir à la page précédente',

        # JS Template: CalendarSettingsDialog
        'Show' => '',

        # JS Template: FormDraftAddDialog
        'Draft title' => '',

        # JS Template: ArticleViewSettingsDialog
        'Article display' => '',

        # JS Template: FormDraftDeleteDialog
        'Do you really want to delete "%s"?' => '',
        'Confirm' => '',

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
        'Finished' => 'Terminé',
        'No package information available.' => '',

        # JS Template: AddButton
        'Add new entry' => 'Ajouter une nouvelle entrée',

        # JS Template: AddHashKey
        'Add key' => '',

        # JS Template: DialogDeployment
        'Deployment comment...' => '',
        'This field can have no more than 250 characters.' => '',
        'Deploying, please wait...' => '',
        'Preparing to deploy, please wait...' => '',
        'Deploy now' => '',
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
        'CustomerIDs' => 'Numéro de client (Groupe)',
        'Fax' => 'Télécopieur ',
        'Street' => 'Rue ',
        'Zip' => 'Code postal ',
        'City' => 'Ville ',
        'Country' => 'Pays ',
        'Valid' => 'Validité',
        'Mr.' => 'M.',
        'Mrs.' => 'Mme',
        'Address' => '',
        'View system log messages.' => 'Voir le journal.',
        'Edit the system configuration settings.' => 'Modifier la configuration du système.',
        'Update and extend your system with software packages.' => 'Mettre à jour et améliorer le système au moyen de paquets.',

        # Perl Module: Kernel/Modules/AdminACL.pm
        'ACL information from database is not in sync with the system configuration, please deploy all ACLs.' =>
            '',
        'ACLs could not be Imported due to a unknown error, please check OTRS logs for more information' =>
            '',
        'The following ACLs have been added successfully: %s' => '',
        'The following ACLs have been updated successfully: %s' => '',
        'There where errors adding/updating the following ACLs: %s. Please check the log file for more information.' =>
            '',
        'This field is required' => '',
        'There was an error creating the ACL' => '',
        'Need ACLID!' => '',
        'Could not get data for ACLID %s' => '',
        'There was an error updating the ACL' => '',
        'There was an error setting the entity sync status.' => '',
        'There was an error synchronizing the ACLs.' => '',
        'ACL %s could not be deleted' => '',
        'There was an error getting data for ACL with ID %s' => '',
        '%s (copy) %s' => '',
        'Please note that ACL restrictions will be ignored for the Superuser account (UserID 1).' =>
            '',
        'Exact match' => '',
        'Negated exact match' => '',
        'Regular expression' => '',
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
        '+5 minutes' => '',
        '+15 minutes' => '',
        '+30 minutes' => '',
        '+1 hour' => '',

        # Perl Module: Kernel/Modules/AdminAppointmentImport.pm
        'No permissions' => '',
        'System was unable to import file!' => '',
        'Please check the log for more information.' => '',

        # Perl Module: Kernel/Modules/AdminAppointmentNotificationEvent.pm
        'Notification name already exists!' => '',
        'Notification added!' => '',
        'There was an error getting data for Notification with ID:%s!' =>
            '',
        'Unknown Notification %s!' => '',
        '%s (copy)' => '',
        'There was an error creating the Notification' => '',
        'Notifications could not be Imported due to a unknown error, please check OTRS logs for more information' =>
            '',
        'The following Notifications have been added successfully: %s' =>
            '',
        'The following Notifications have been updated successfully: %s' =>
            '',
        'There where errors adding/updating the following Notifications: %s. Please check the log file for more information.' =>
            '',
        'Notification updated!' => '',
        'Agent (resources), who are selected within the appointment' => '',
        'All agents with (at least) read permission for the appointment (calendar)' =>
            '',
        'All agents with write permission for the appointment (calendar)' =>
            '',
        'Yes, but require at least one active notification method.' => '',

        # Perl Module: Kernel/Modules/AdminAttachment.pm
        'Attachment added!' => 'Pièce jointe ajoutée.',

        # Perl Module: Kernel/Modules/AdminAutoResponse.pm
        'Auto Response added!' => '',

        # Perl Module: Kernel/Modules/AdminCommunicationLog.pm
        'Invalid CommunicationID!' => '',
        'All communications' => '',
        'Last 1 hour' => '',
        'Last 3 hours' => '',
        'Last 6 hours' => '',
        'Last 12 hours' => '',
        'Last 24 hours' => '',
        'Last week' => '',
        'Last month' => '',
        'Invalid StartTime: %s!' => '',
        'Successful' => '',
        'Processing' => '',
        'Failed' => '',
        'Invalid Filter: %s!' => '',
        'Less than a second' => '',
        'sorted descending' => '',
        'sorted ascending' => '',
        'Trace' => '',
        'Debug' => '',
        'Info' => 'Information',
        'Warn' => '',
        'days' => 'jours',
        'day' => 'jour',
        'hour' => 'heure',
        'minute' => 'minute',
        'seconds' => 'secondes',
        'second' => 'seconde',

        # Perl Module: Kernel/Modules/AdminCustomerCompany.pm
        'Customer company updated!' => 'Entreprise cliente mise à jour.',
        'Dynamic field %s not found!' => '',
        'Unable to set value for dynamic field %s!' => '',
        'Customer Company %s already exists!' => '',
        'Customer company added!' => 'Entreprise cliente ajoutée.',

        # Perl Module: Kernel/Modules/AdminCustomerGroup.pm
        'No configuration for \'CustomerGroupPermissionContext\' found!' =>
            '',
        'Please check system configuration.' => '',
        'Invalid permission context configuration:' => '',

        # Perl Module: Kernel/Modules/AdminCustomerUser.pm
        'Customer updated!' => 'Client mis à jour.',
        'New phone ticket' => 'Nouvelle demande téléphonique',
        'New email ticket' => 'Nouvelle demande courriel',
        'Customer %s added' => 'Client %s ajouté',
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
        'Fields configuration is not valid' => '',
        'Objects configuration is not valid' => '',
        'Database (%s)' => '',
        'Web service (%s)' => '',
        'Contact with data (%s)' => '',
        'Could not reset Dynamic Field order properly, please check the error log for more details.' =>
            '',

        # Perl Module: Kernel/Modules/AdminDynamicFieldCheckbox.pm
        'Undefined subaction.' => '',
        'Need %s' => '',
        'Add %s field' => '',
        'The field does not contain only ASCII letters and numbers.' => '',
        'There is another field with the same name.' => '',
        'The field must be numeric.' => '',
        'Need ValidID' => '',
        'Could not create the new field' => '',
        'Need ID' => '',
        'Could not get data for dynamic field %s' => '',
        'Change %s field' => '',
        'The name for this field should not change.' => '',
        'Could not update the field %s' => '',
        'Currently' => '',
        'Unchecked' => '',
        'Checked' => '',

        # Perl Module: Kernel/Modules/AdminDynamicFieldDateTime.pm
        'Prevent entry of dates in the future' => '',
        'Prevent entry of dates in the past' => '',

        # Perl Module: Kernel/Modules/AdminDynamicFieldDropdown.pm
        'This field value is duplicated.' => '',

        # Perl Module: Kernel/Modules/AdminEmail.pm
        'Select at least one recipient.' => '',

        # Perl Module: Kernel/Modules/AdminGenericAgent.pm
        'minute(s)' => 'minute(s)',
        'hour(s)' => 'heure(s)',
        'Time unit' => '',
        'within the last ...' => '',
        'within the next ...' => '',
        'more than ... ago' => '',
        'Unarchived tickets' => 'Demandes non archivées',
        'archive tickets' => '',
        'restore tickets from archive' => '',
        'Need Profile!' => '',
        'Got no values to check.' => '',
        'Please remove the following words because they cannot be used for the ticket selection:' =>
            '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceDebugger.pm
        'Need WebserviceID!' => '',
        'Could not get data for WebserviceID %s' => '',
        'ascending' => 'ascendant',
        'descending' => 'descendant',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceErrorHandlingDefault.pm
        'Need communication type!' => '',
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
        'skip all modules' => '',
        'Operation deleted' => '',
        'Invoker deleted' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceErrorHandlingRequestRetry.pm
        '0 seconds' => '',
        '15 seconds' => '',
        '30 seconds' => '',
        '45 seconds' => '',
        '1 minute' => '',
        '2 minutes' => '',
        '3 minutes' => '',
        '4 minutes' => '',
        '5 minutes' => '',
        '10 minutes' => '10 minutes',
        '15 minutes' => '15 minutes',
        '30 minutes' => '',
        '1 hour' => '',
        '2 hours' => '',
        '3 hours' => '',
        '4 hours' => '',
        '5 hours' => '',
        '6 hours' => '',
        '12 hours' => '',
        '18 hours' => '',
        '1 day' => '',
        '2 days' => '',
        '3 days' => '',
        '4 days' => '',
        '6 days' => '',
        '1 week' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceInvokerDefault.pm
        'Could not determine config for invoker %s' => '',
        'InvokerType %s is not registered' => '',
        'MappingType %s is not registered' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceInvokerEvent.pm
        'Need Invoker!' => '',
        'Need Event!' => '',
        'Could not get registered modules for Invoker' => '',
        'Could not get backend for Invoker %s' => '',
        'The event %s is not valid.' => '',
        'Could not update configuration data for WebserviceID %s' => '',
        'This sub-action is not valid' => '',
        'xor' => '',
        'String' => '',
        'Regexp' => '',
        'Validation Module' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceMappingSimple.pm
        'Simple Mapping for Outgoing Data' => '',
        'Simple Mapping for Incoming Data' => '',
        'Could not get registered configuration for action type %s' => '',
        'Could not get backend for %s %s' => '',
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
        'Could not determine config for operation %s' => '',
        'OperationType %s is not registered' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceTransportHTTPREST.pm
        'Need valid Subaction!' => '',
        'This field should be an integer.' => '',
        'File or Directory not found.' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceWebservice.pm
        'There is another web service with the same name.' => '',
        'There was an error updating the web service.' => '',
        'There was an error creating the web service.' => '',
        'Web service "%s" created!' => '',
        'Need Name!' => '',
        'Need ExampleWebService!' => '',
        'Could not load %s.' => '',
        'Could not read %s!' => '',
        'Need a file to import!' => '',
        'The imported file has not valid YAML content! Please check OTRS log for details' =>
            '',
        'Web service "%s" deleted!' => '',
        'OTRS as provider' => 'OTRS, fournisseur',
        'Operations' => '',
        'OTRS as requester' => 'OTRS, demandeur',
        'Invokers' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceWebserviceHistory.pm
        'Got no WebserviceHistoryID!' => '',
        'Could not get history data for WebserviceHistoryID %s' => '',

        # Perl Module: Kernel/Modules/AdminGroup.pm
        'Group updated!' => 'Groupe ajouté.',

        # Perl Module: Kernel/Modules/AdminMailAccount.pm
        'Mail account added!' => 'Compte de courrier électronique ajouté.',
        'Email account fetch already fetched by another process. Please try again later!' =>
            '',
        'Dispatching by email To: field.' => 'Classement des courriels selon le champ « À : »',
        'Dispatching by selected Queue.' => 'Classement selon la file sélectionnée',

        # Perl Module: Kernel/Modules/AdminNotificationEvent.pm
        'Agent who created the ticket' => '',
        'Agent who owns the ticket' => '',
        'Agent who is responsible for the ticket' => '',
        'All agents watching the ticket' => '',
        'All agents with write permission for the ticket' => '',
        'All agents subscribed to the ticket\'s queue' => '',
        'All agents subscribed to the ticket\'s service' => '',
        'All agents subscribed to both the ticket\'s queue and service' =>
            '',
        'Customer user of the ticket' => '',
        'All recipients of the first article' => '',
        'All recipients of the last article' => '',
        'Invisible to customer' => '',
        'Visible to customer' => '',

        # Perl Module: Kernel/Modules/AdminOTRSBusiness.pm
        'Your system was successfully upgraded to %s.' => '',
        'There was a problem during the upgrade to %s.' => '',
        '%s was correctly reinstalled.' => '',
        'There was a problem reinstalling %s.' => '',
        'Your %s was successfully updated.' => '',
        'There was a problem during the upgrade of %s.' => '',
        '%s was correctly uninstalled.' => '',
        'There was a problem uninstalling %s.' => '',

        # Perl Module: Kernel/Modules/AdminPGP.pm
        'PGP environment is not working. Please check log for more info!' =>
            '',
        'Need param Key to delete!' => '',
        'Key %s deleted!' => '',
        'Need param Key to download!' => '',

        # Perl Module: Kernel/Modules/AdminPackageManager.pm
        'Sorry, Apache::Reload is needed as PerlModule and PerlInitHandler in Apache config file. See also scripts/apache2-httpd.include.conf. Alternatively, you can use the command line tool bin/otrs.Console.pl to install packages!' =>
            '',
        'No such package!' => '',
        'No such file %s in package!' => '',
        'No such file %s in local file system!' => '',
        'Can\'t read %s!' => '',
        'File is OK' => '',
        'Package has locally modified files.' => '',
        'Package not verified by the OTRS Group! It is recommended not to use this package.' =>
            '',
        'Not Started' => '',
        'Updated' => '',
        'Already up-to-date' => '',
        'Installed' => '',
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
            '',
        'Can\'t connect to OTRS Feature Add-on list server!' => '',
        'Can\'t get OTRS Feature Add-on list from server!' => '',
        'Can\'t get OTRS Feature Add-on from server!' => '',

        # Perl Module: Kernel/Modules/AdminPostMasterFilter.pm
        'No such filter: %s' => '',

        # Perl Module: Kernel/Modules/AdminPriority.pm
        'Priority added!' => 'Priorité ajoutée!',

        # Perl Module: Kernel/Modules/AdminProcessManagement.pm
        'Process Management information from database is not in sync with the system configuration, please synchronize all processes.' =>
            '',
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
        'Need %s!' => '',
        'Process: %s is not Inactive' => '',

        # Perl Module: Kernel/Modules/AdminProcessManagementActivity.pm
        'There was an error generating a new EntityID for this Activity' =>
            '',
        'There was an error creating the Activity' => '',
        'There was an error setting the entity sync status for Activity entity: %s' =>
            '',
        'Need ActivityID!' => '',
        'Could not get data for ActivityID %s' => '',
        'There was an error updating the Activity' => '',
        'Missing Parameter: Need Activity and ActivityDialog!' => '',
        'Activity not found!' => '',
        'ActivityDialog not found!' => '',
        'ActivityDialog already assigned to Activity. You cannot add an ActivityDialog twice!' =>
            '',
        'Error while saving the Activity to the database!' => '',
        'This subaction is not valid' => '',
        'Edit Activity "%s"' => '',

        # Perl Module: Kernel/Modules/AdminProcessManagementActivityDialog.pm
        'There was an error generating a new EntityID for this ActivityDialog' =>
            '',
        'There was an error creating the ActivityDialog' => '',
        'There was an error setting the entity sync status for ActivityDialog entity: %s' =>
            '',
        'Need ActivityDialogID!' => '',
        'Could not get data for ActivityDialogID %s' => '',
        'There was an error updating the ActivityDialog' => '',
        'Edit Activity Dialog "%s"' => '',
        'Agent Interface' => '',
        'Customer Interface' => '',
        'Agent and Customer Interface' => '',
        'Do not show Field' => '',
        'Show Field' => '',
        'Show Field As Mandatory' => '',

        # Perl Module: Kernel/Modules/AdminProcessManagementPath.pm
        'Edit Path' => '',

        # Perl Module: Kernel/Modules/AdminProcessManagementTransition.pm
        'There was an error generating a new EntityID for this Transition' =>
            '',
        'There was an error creating the Transition' => '',
        'There was an error setting the entity sync status for Transition entity: %s' =>
            '',
        'Need TransitionID!' => '',
        'Could not get data for TransitionID %s' => '',
        'There was an error updating the Transition' => '',
        'Edit Transition "%s"' => '',
        'Transition validation module' => '',

        # Perl Module: Kernel/Modules/AdminProcessManagementTransitionAction.pm
        'At least one valid config parameter is required.' => '',
        'There was an error generating a new EntityID for this TransitionAction' =>
            '',
        'There was an error creating the TransitionAction' => '',
        'There was an error setting the entity sync status for TransitionAction entity: %s' =>
            '',
        'Need TransitionActionID!' => '',
        'Could not get data for TransitionActionID %s' => '',
        'There was an error updating the TransitionAction' => '',
        'Edit Transition Action "%s"' => '',
        'Error: Not all keys seem to have values or vice versa.' => '',

        # Perl Module: Kernel/Modules/AdminQueue.pm
        'Queue updated!' => 'File mise à jour.',
        'Don\'t use :: in queue name!' => '',
        'Click back and change it!' => '',
        '-none-' => 'aucune',

        # Perl Module: Kernel/Modules/AdminQueueAutoResponse.pm
        'Queues ( without auto responses )' => '',

        # Perl Module: Kernel/Modules/AdminQueueTemplates.pm
        'Change Queue Relations for Template' => '',
        'Change Template Relations for Queue' => '',

        # Perl Module: Kernel/Modules/AdminRegistration.pm
        'Production' => '',
        'Test' => '',
        'Training' => '',
        'Development' => '',

        # Perl Module: Kernel/Modules/AdminRole.pm
        'Role updated!' => 'Rôle mis à jour.',
        'Role added!' => 'Rôle ajouté.',

        # Perl Module: Kernel/Modules/AdminRoleGroup.pm
        'Change Group Relations for Role' => 'Modifier les relations des groupes pour le rôle',
        'Change Role Relations for Group' => 'Modifier les relations des rôles pour un groupe',

        # Perl Module: Kernel/Modules/AdminRoleUser.pm
        'Role' => '',
        'Change Role Relations for Agent' => 'Changer les rôles de l\'agent',
        'Change Agent Relations for Role' => 'Changer les agents du rôle :',

        # Perl Module: Kernel/Modules/AdminSLA.pm
        'Please activate %s first!' => 'Veuillez d\'abord activer le %s.',

        # Perl Module: Kernel/Modules/AdminSMIME.pm
        'S/MIME environment is not working. Please check log for more info!' =>
            '',
        'Need param Filename to delete!' => '',
        'Need param Filename to download!' => '',
        'Needed CertFingerprint and CAFingerprint!' => '',
        'CAFingerprint must be different than CertFingerprint' => '',
        'Relation exists!' => '',
        'Relation added!' => '',
        'Impossible to add relation!' => '',
        'Relation doesn\'t exists' => '',
        'Relation deleted!' => '',
        'Impossible to delete relation!' => '',
        'Certificate %s could not be read!' => '',
        'Needed Fingerprint' => '',
        'Handle Private Certificate Relations' => '',

        # Perl Module: Kernel/Modules/AdminSalutation.pm
        'Salutation added!' => '',

        # Perl Module: Kernel/Modules/AdminSignature.pm
        'Signature updated!' => 'Signature mise à jour!',
        'Signature added!' => 'Signature ajoutée!',

        # Perl Module: Kernel/Modules/AdminState.pm
        'State added!' => 'État ajouté.',

        # Perl Module: Kernel/Modules/AdminSupportDataCollector.pm
        'File %s could not be read!' => '',

        # Perl Module: Kernel/Modules/AdminSystemAddress.pm
        'System e-mail address added!' => 'adresse électronique du système ajoutée.',

        # Perl Module: Kernel/Modules/AdminSystemConfiguration.pm
        'Invalid Settings' => '',
        'There are no invalid settings active at this time.' => '',
        'You currently don\'t have any favourite settings.' => '',
        'The following settings could not be found: %s' => '',
        'Import not allowed!' => '',
        'System Configuration could not be imported due to an unknown error, please check OTRS logs for more information.' =>
            '',
        'Category Search' => '',

        # Perl Module: Kernel/Modules/AdminSystemConfigurationDeployment.pm
        'Some imported settings are not present in the current state of the configuration or it was not possible to update them. Please check the OTRS log for more information.' =>
            '',

        # Perl Module: Kernel/Modules/AdminSystemConfigurationGroup.pm
        'You need to enable the setting before locking!' => '',
        'You can\'t work on this setting because %s (%s) is currently working on it.' =>
            '',
        'Missing setting name!' => '',
        'Missing ResetOptions!' => '',
        'Setting is locked by another user!' => '',
        'System was not able to lock the setting!' => '',
        'System was not able to reset the setting!' => '',
        'System was unable to update setting!' => '',
        'Missing setting name.' => '',
        'Setting not found.' => '',
        'Missing Settings!' => '',

        # Perl Module: Kernel/Modules/AdminSystemMaintenance.pm
        'Start date shouldn\'t be defined after Stop date!' => '',
        'There was an error creating the System Maintenance' => '',
        'Need SystemMaintenanceID!' => '',
        'Could not get data for SystemMaintenanceID %s' => '',
        'System Maintenance was added successfully!' => '',
        'System Maintenance was updated successfully!' => '',
        'Session has been killed!' => '',
        'All sessions have been killed, except for your own.' => '',
        'There was an error updating the System Maintenance' => '',
        'Was not possible to delete the SystemMaintenance entry: %s!' => '',

        # Perl Module: Kernel/Modules/AdminTemplate.pm
        'Template updated!' => '',
        'Template added!' => '',

        # Perl Module: Kernel/Modules/AdminTemplateAttachment.pm
        'Change Attachment Relations for Template' => '',
        'Change Template Relations for Attachment' => '',

        # Perl Module: Kernel/Modules/AdminType.pm
        'Need Type!' => '',
        'Type added!' => 'Type ajouté.',

        # Perl Module: Kernel/Modules/AdminUser.pm
        'Agent updated!' => 'La mise à jour des renseignements de l\'agent a été effectuée.',

        # Perl Module: Kernel/Modules/AdminUserGroup.pm
        'Change Group Relations for Agent' => 'Changer les relations de groupe pour l\'agent : ',
        'Change Agent Relations for Group' => 'Changer les relations avec les agents pour le groupe : ',

        # Perl Module: Kernel/Modules/AgentAppointmentAgendaOverview.pm
        'Month' => 'Mois',
        'Week' => '',
        'Day' => 'Jour',

        # Perl Module: Kernel/Modules/AgentAppointmentCalendarOverview.pm
        'All appointments' => '',
        'Appointments assigned to me' => '',
        'Showing only appointments assigned to you! Change settings' => '',

        # Perl Module: Kernel/Modules/AgentAppointmentEdit.pm
        'Appointment not found!' => '',
        'Never' => '',
        'Every Day' => '',
        'Every Week' => '',
        'Every Month' => '',
        'Every Year' => '',
        'Custom' => '',
        'Daily' => '',
        'Weekly' => '',
        'Monthly' => '',
        'Yearly' => '',
        'every' => '',
        'for %s time(s)' => '',
        'until ...' => '',
        'for ... time(s)' => '',
        'until %s' => '',
        'No notification' => '',
        '%s minute(s) before' => '',
        '%s hour(s) before' => '',
        '%s day(s) before' => '',
        '%s week before' => '',
        'before the appointment starts' => '',
        'after the appointment has been started' => '',
        'before the appointment ends' => '',
        'after the appointment has been ended' => '',
        'No permission!' => '',
        'Cannot delete ticket appointment!' => '',
        'No permissions!' => '',

        # Perl Module: Kernel/Modules/AgentAppointmentList.pm
        '+%s more' => '',

        # Perl Module: Kernel/Modules/AgentCustomerSearch.pm
        'Customer History' => 'Historique du client',

        # Perl Module: Kernel/Modules/AgentCustomerUserAddressBook.pm
        'No RecipientField is given!' => '',

        # Perl Module: Kernel/Modules/AgentDashboardCommon.pm
        'No such config for %s' => '',
        'Statistic' => '',
        'No preferences for %s!' => '',
        'Can\'t get element data of %s!' => '',
        'Can\'t get filter content data of %s!' => '',
        'Customer Name' => '',
        'Customer User Name' => '',

        # Perl Module: Kernel/Modules/AgentLinkObject.pm
        'Need SourceObject and SourceKey!' => '',
        'You need ro permission!' => '',
        'Can not delete link with %s!' => '',
        '%s Link(s) deleted successfully.' => '',
        'Can not create link with %s! Object already linked as %s.' => '',
        'Can not create link with %s!' => '',
        '%s links added successfully.' => '',
        'The object %s cannot link with other object!' => '',

        # Perl Module: Kernel/Modules/AgentPreferences.pm
        'Param Group is required!' => '',
        'Updated user preferences' => '',
        'System was unable to deploy your changes.' => '',
        'Setting not found!' => '',
        'System was unable to reset the setting!' => '',

        # Perl Module: Kernel/Modules/AgentSplitSelection.pm
        'Process ticket' => '',

        # Perl Module: Kernel/Modules/AgentStatistics.pm
        'Parameter %s is missing.' => '',
        'Invalid Subaction.' => '',
        'Statistic could not be imported.' => '',
        'Please upload a valid statistic file.' => '',
        'Export: Need StatID!' => '',
        'Delete: Get no StatID!' => '',
        'Need StatID!' => '',
        'Could not load stat.' => '',
        'Add New Statistic' => '',
        'Could not create statistic.' => '',
        'Run: Get no %s!' => '',

        # Perl Module: Kernel/Modules/AgentTicketActionCommon.pm
        'No TicketID is given!' => '',
        'You need %s permissions!' => '',
        'Loading draft failed!' => '',
        'Sorry, you need to be the ticket owner to perform this action.' =>
            'Désolé, vous devez être le propriétaire de la demande pour effectuer cette action.',
        'Please change the owner first.' => 'D\'abord, veuillez modifier le propriétaire.',
        'FormDraft functionality disabled!' => '',
        'Draft name is required!' => '',
        'FormDraft name %s is already in use!' => '',
        'Could not perform validation on field %s!' => '',
        'No subject' => '',
        'Could not delete draft!' => '',
        'Previous Owner' => 'Propriétaire précédent ',
        'wrote' => 'a écrit',
        'Message from' => 'Message de',
        'End message' => 'Fin du message',

        # Perl Module: Kernel/Modules/AgentTicketBounce.pm
        '%s is needed!' => '',
        'Plain article not found for article %s!' => '',
        'Article does not belong to ticket %s!' => '',
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
        'Address %s replaced with registered customer address.' => 'Adresse %s remplacée par celle du client enregistré.',
        'Customer user automatically added in Cc.' => 'Le client a été ajouté automatiquement en cc.',

        # Perl Module: Kernel/Modules/AgentTicketEmail.pm
        'Ticket "%s" created!' => 'La demande %s a été créée.',
        'No Subaction!' => '',

        # Perl Module: Kernel/Modules/AgentTicketEmailOutbound.pm
        'Got no TicketID!' => '',
        'System Error!' => '',

        # Perl Module: Kernel/Modules/AgentTicketEmailResend.pm
        'No ArticleID is given!' => '',

        # Perl Module: Kernel/Modules/AgentTicketEscalationView.pm
        'Next week' => 'La semaine prochaine',
        'Ticket Escalation View' => 'Vue des escalades de la demande ',

        # Perl Module: Kernel/Modules/AgentTicketForward.pm
        'Article %s could not be found!' => '',
        'Forwarded message from' => 'Message transféré par',
        'End forwarded message' => 'Fin du message tranféré',

        # Perl Module: Kernel/Modules/AgentTicketHistory.pm
        'Can\'t show history, no TicketID is given!' => '',

        # Perl Module: Kernel/Modules/AgentTicketLock.pm
        'Can\'t lock Ticket, no TicketID is given!' => '',
        'Sorry, the current owner is %s!' => '',
        'Please become the owner first.' => '',
        'Ticket (ID=%s) is locked by %s!' => '',
        'Change the owner!' => '',

        # Perl Module: Kernel/Modules/AgentTicketLockedView.pm
        'New Article' => 'Nouvel Article',
        'Pending' => 'En attente',
        'Reminder Reached' => 'Rappel atteint',
        'My Locked Tickets' => 'Mes demandes verrouillées',

        # Perl Module: Kernel/Modules/AgentTicketMerge.pm
        'Can\'t merge ticket with itself!' => '',

        # Perl Module: Kernel/Modules/AgentTicketMove.pm
        'You need move permissions!' => '',

        # Perl Module: Kernel/Modules/AgentTicketPhone.pm
        'Chat is not active.' => '',
        'No permission.' => '',
        '%s has left the chat.' => '',
        'This chat has been closed and will be removed in %s hours.' => '',

        # Perl Module: Kernel/Modules/AgentTicketPhoneCommon.pm
        'Ticket locked.' => 'Demande verrouillée.',

        # Perl Module: Kernel/Modules/AgentTicketPlain.pm
        'No ArticleID!' => '',
        'This is not an email article.' => '',
        'Can\'t read plain article! Maybe there is no plain email in backend! Read backend message.' =>
            '',

        # Perl Module: Kernel/Modules/AgentTicketPrint.pm
        'Need TicketID!' => '',

        # Perl Module: Kernel/Modules/AgentTicketProcess.pm
        'Couldn\'t get ActivityDialogEntityID "%s"!' => '',
        'No Process configured!' => '',
        'The selected process is invalid!' => '',
        'Process %s is invalid!' => '',
        'Subaction is invalid!' => '',
        'Parameter %s is missing in %s.' => '',
        'No ActivityDialog configured for %s in _RenderAjax!' => '',
        'Got no Start ActivityEntityID or Start ActivityDialogEntityID for Process: %s in _GetParam!' =>
            '',
        'Couldn\'t get Ticket for TicketID: %s in _GetParam!' => '',
        'Couldn\'t determine ActivityEntityID. DynamicField or Config isn\'t set properly!' =>
            '',
        'Process::Default%s Config Value missing!' => '',
        'Got no ProcessEntityID or TicketID and ActivityDialogEntityID!' =>
            '',
        'Can\'t get StartActivityDialog and StartActivityDialog for the ProcessEntityID "%s"!' =>
            '',
        'Can\'t get Ticket "%s"!' => '',
        'Can\'t get ProcessEntityID or ActivityEntityID for Ticket "%s"!' =>
            '',
        'Can\'t get Activity configuration for ActivityEntityID "%s"!' =>
            '',
        'Can\'t get ActivityDialog configuration for ActivityDialogEntityID "%s"!' =>
            '',
        'Can\'t get data for Field "%s" of ActivityDialog "%s"!' => '',
        'PendingTime can just be used if State or StateID is configured for the same ActivityDialog. ActivityDialog: %s!' =>
            '',
        'Pending Date' => 'Date d\'échéance',
        'for pending* states' => 'pour toutes les demandes en attente',
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
        'Available tickets' => 'Demandes disponibles',
        'including subqueues' => 'incluant les sous-files',
        'excluding subqueues' => 'excluant les sous-files',
        'QueueView' => 'Vue des files',

        # Perl Module: Kernel/Modules/AgentTicketResponsibleView.pm
        'My Responsible Tickets' => 'Les demandes dont je suis responsable',

        # Perl Module: Kernel/Modules/AgentTicketSearch.pm
        'last-search' => 'recherche précédente',
        'Untitled' => '',
        'Ticket Number' => 'Numéro de demande',
        'Ticket' => 'Demande ',
        'printed by' => 'Imprimé par :',
        'CustomerID (complex search)' => '',
        'CustomerID (exact match)' => '',
        'Invalid Users' => '',
        'Normal' => 'Normal',
        'CSV' => 'CSV',
        'Excel' => '',
        'in more than ...' => '',

        # Perl Module: Kernel/Modules/AgentTicketService.pm
        'Feature not enabled!' => '',
        'Service View' => '',

        # Perl Module: Kernel/Modules/AgentTicketStatusView.pm
        'Status View' => 'Vue des états ',

        # Perl Module: Kernel/Modules/AgentTicketWatchView.pm
        'My Watched Tickets' => 'Mes demandes sous surveillance',

        # Perl Module: Kernel/Modules/AgentTicketWatcher.pm
        'Feature is not active' => '',

        # Perl Module: Kernel/Modules/AgentTicketZoom.pm
        'Link Deleted' => '',
        'Ticket Locked' => '',
        'Pending Time Set' => '',
        'Dynamic Field Updated' => '',
        'Outgoing Email (internal)' => 'Courriel sortant (interne)',
        'Ticket Created' => '',
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
        'Outgoing Email' => 'Courriel sortant',
        'Title Updated' => '',
        'Ticket Merged' => '',
        'Outgoing Phone Call' => '',
        'Forwarded Message' => '',
        'Removed User Subscription' => '',
        'Time Accounted' => '',
        'Incoming Phone Call' => '',
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
        'Notification Was Sent' => '',
        'This ticket does not exist, or you don\'t have permissions to access it in its current state.' =>
            '',
        'Missing FormDraftID!' => '',
        'Can\'t get for ArticleID %s!' => '',
        'Article filter settings were saved.' => '',
        'Event type filter settings were saved.' => '',
        'Need ArticleID!' => '',
        'Invalid ArticleID!' => '',
        'Forward article via mail' => 'Transférer l\'article par courriel',
        'Forward' => 'Transférer',
        'Fields with no group' => '',
        'Invisible only' => '',
        'Visible only' => '',
        'Visible and invisible' => '',
        'Article could not be opened! Perhaps it is on another article page?' =>
            '',
        'Show one article' => 'Afficher un article',
        'Show all articles' => 'Afficher tous les articles',
        'Show Ticket Timeline View' => '',
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
        'My Tickets' => 'Mes demandes',
        'Company Tickets' => 'Demandes de l\'entreprise',
        'Untitled!' => '',

        # Perl Module: Kernel/Modules/CustomerTicketSearch.pm
        'Customer Realname' => '',
        'Created within the last' => '',
        'Created more than ... ago' => '',
        'Please remove the following words because they cannot be used for the search:' =>
            '',

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
        'Install OTRS' => 'Installer OTRS',
        'Intro' => 'Introduction',
        'Kernel/Config.pm isn\'t writable!' => '',
        'If you want to use the installer, set the Kernel/Config.pm writable for the webserver user!' =>
            '',
        'Database Selection' => '',
        'Unknown Check!' => '',
        'The check "%s" doesn\'t exist!' => '',
        'Enter the password for the database user.' => '',
        'Database %s' => '',
        'Configure MySQL' => '',
        'Enter the password for the administrative database user.' => '',
        'Configure PostgreSQL' => '',
        'Configure Oracle' => '',
        'Unknown database type "%s".' => '',
        'Please go back.' => '',
        'Create Database' => 'Créer la base de données',
        'Install OTRS - Error' => '',
        'File "%s/%s.xml" not found!' => '',
        'Contact your Admin!' => '',
        'System Settings' => 'Paramètres du système',
        'Syslog' => '',
        'Configure Mail' => 'Configuration de la messagerie',
        'Mail Configuration' => 'Configuration des courriels',
        'Can\'t write Config file!' => '',
        'Unknown Subaction %s!' => '',
        'Can\'t connect to database, Perl module DBD::%s not installed!' =>
            '',
        'Can\'t connect to database, read comment!' => '',
        'Database already contains data - it should be empty!' => '',
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
        'Bounce Article to a different mail address' => 'Retourner l\'article à une adresse électronique différente',
        'Bounce' => 'Retourner',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketCompose.pm
        'Reply All' => 'Répondre à tous',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketEmailResend.pm
        'Resend this article' => '',
        'Resend' => '',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketMessageLog.pm
        'View message log details for this article' => '',
        'Message Log' => '',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketNote.pm
        'Reply to note' => '',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketPhone.pm
        'Split this article' => 'Scinder cet article',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketPlain.pm
        'View the source for this Article' => '',
        'Plain Format' => 'Format texte',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketPrint.pm
        'Print this article' => 'Imprimer cet article',

        # Perl Module: Kernel/Output/HTML/ArticleAction/GetHelpLink.pm
        'Contact us at sales@otrs.com' => '',
        'Get Help' => '',

        # Perl Module: Kernel/Output/HTML/ArticleAction/MarkAsImportant.pm
        'Mark' => 'Marquer',
        'Unmark' => 'Démarquer',

        # Perl Module: Kernel/Output/HTML/ArticleAction/ReinstallPackageLink.pm
        'Upgrade to OTRS Business Solution™' => '',
        'Re-install Package' => '',
        'Upgrade' => 'Mise à jour',
        'Re-install' => '',

        # Perl Module: Kernel/Output/HTML/ArticleCheck/PGP.pm
        'Crypted' => 'Crypté',
        'Sent message encrypted to recipient!' => '',
        'Signed' => 'Signé',
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
        'Sign' => 'Signer',
        'Keys/certificates will only be shown for a sender with more than one key/certificate. The first found key/certificate will be pre-selected. Please make sure to select the correct one.' =>
            '',

        # Perl Module: Kernel/Output/HTML/Dashboard/AppointmentCalendar.pm
        'Shown' => 'Affiché(s)',
        'Refresh (minutes)' => '',
        'off' => 'désactivée',

        # Perl Module: Kernel/Output/HTML/Dashboard/CustomerIDList.pm
        'Shown customer ids' => '',

        # Perl Module: Kernel/Output/HTML/Dashboard/CustomerUserList.pm
        'Shown customer users' => '',
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
        'Shown Tickets' => 'Demandes affichées',
        'Shown Columns' => 'Colonnes affichées',
        'filter not active' => '',
        'filter active' => '',
        'This ticket has no title or subject' => '',

        # Perl Module: Kernel/Output/HTML/Dashboard/TicketStatsGeneric.pm
        '7 Day Stats' => 'Statistiques sur 7 jours',

        # Perl Module: Kernel/Output/HTML/Dashboard/UserOnline.pm
        'User set their status to unavailable.' => '',
        'Unavailable' => '',

        # Perl Module: Kernel/Output/HTML/Layout.pm
        'Standard' => 'Standard',
        'The following tickets are not updated: %s.' => '',
        'h' => 'h',
        'm' => 'm',
        'd' => 'j',
        'This ticket does not exist, or you don\'t have permissions to access it in its current state. You can take one of the following actions:' =>
            '',
        'This is a' => 'Ceci est un',
        'email' => 'courriel ',
        'click here' => 'Cliquer ici',
        'to open it in a new window.' => 'L\'ouvrir dans une nouvelle fenêtre',
        'Year' => 'Année',
        'Hours' => 'Heures',
        'Minutes' => 'Minutes',
        'Check to activate this date' => 'Cochez pour activer cette date.',
        '%s TB' => '',
        '%s GB' => '',
        '%s MB' => '',
        '%s KB' => '',
        '%s B' => '',
        'No Permission!' => 'Pas de permission.',
        'No Permission' => '',
        'Show Tree Selection' => '',
        'Split Quote' => '',
        'Remove Quote' => '',

        # Perl Module: Kernel/Output/HTML/Layout/LinkObject.pm
        'Linked as' => '',
        'Search Result' => '',
        'Linked' => 'Lié',
        'Bulk' => 'Groupées',

        # Perl Module: Kernel/Output/HTML/Layout/Ticket.pm
        'Lite' => 'Allégée',
        'Unread article(s) available' => 'Article non lu disponible',

        # Perl Module: Kernel/Output/HTML/LinkObject/Appointment.pm
        'Appointment' => '',

        # Perl Module: Kernel/Output/HTML/LinkObject/Ticket.pm
        'Archive search' => '',

        # Perl Module: Kernel/Output/HTML/Notification/AgentCloudServicesDisabled.pm
        'Enable cloud services to unleash all OTRS features!' => '',

        # Perl Module: Kernel/Output/HTML/Notification/AgentOTRSBusiness.pm
        '%s Upgrade to %s now! %s' => '',
        'Please verify your license data!' => '',
        'The license for your %s is about to expire. Please make contact with %s to renew your contract!' =>
            '',
        'An update for your %s is available, but there is a conflict with your framework version! Please update your framework first!' =>
            '',

        # Perl Module: Kernel/Output/HTML/Notification/AgentOnline.pm
        'Online Agent: %s' => 'Nombre d\'opérateurs en ligne : %s',

        # Perl Module: Kernel/Output/HTML/Notification/AgentTicketEscalation.pm
        'There are more escalated tickets!' => 'Il y a d\'autres demandes en escalade.',

        # Perl Module: Kernel/Output/HTML/Notification/AgentTimeZoneCheck.pm
        'Please select a time zone in your preferences and confirm it by clicking the save button.' =>
            '',

        # Perl Module: Kernel/Output/HTML/Notification/CustomerOnline.pm
        'Online Customer: %s' => 'Nombre de clients en ligne : %s',

        # Perl Module: Kernel/Output/HTML/Notification/CustomerSystemMaintenanceCheck.pm
        'System maintenance is active!' => '',
        'A system maintenance period will start at: %s and is expected to stop at: %s' =>
            '',

        # Perl Module: Kernel/Output/HTML/Notification/DaemonCheck.pm
        'OTRS Daemon is not running.' => '',

        # Perl Module: Kernel/Output/HTML/Notification/OutofOfficeCheck.pm
        'You have Out of Office enabled, would you like to disable it?' =>
            'Votre indicateur d\'absence est activé, souhaitez-vous le désactivé?',

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
            '',
        'Preferences updated successfully!' => 'Les préférences ont bien été mises à jour.',

        # Perl Module: Kernel/Output/HTML/Preferences/Language.pm
        '(in process)' => '',

        # Perl Module: Kernel/Output/HTML/Preferences/OutOfOffice.pm
        'Please specify an end date that is after the start date.' => '',

        # Perl Module: Kernel/Output/HTML/Preferences/Password.pm
        'Current password' => 'Mot de passe actuel',
        'New password' => 'Nouveau mot de passe',
        'Verify password' => 'Vérifier le mot de passe',
        'The current password is not correct. Please try again!' => 'Le mot de passe actuel n\'est pas correct. Merci d\'essayer à nouveau.',
        'Please supply your new password!' => '',
        'Can\'t update password, your new passwords do not match. Please try again!' =>
            'Impossible de mettre à jour le mot de passe, votre nouveau mot de passe ne correspond pas. Merci d\'essayer à nouveau.',
        'This password is forbidden by the current system configuration. Please contact the administrator if you have additional questions.' =>
            '',
        'Can\'t update password, it must be at least %s characters long!' =>
            'Impossible de mettre à jour le mot de passe; il doit contenir au moins %s caractères.',
        'Can\'t update password, it must contain at least 2 lowercase and 2 uppercase letter characters!' =>
            '',
        'Can\'t update password, it must contain at least 1 digit!' => 'Impossible de mettre à jour le mot de passe; il doit contenir au moins un chiffre.',
        'Can\'t update password, it must contain at least 2 letter characters!' =>
            '',

        # Perl Module: Kernel/Output/HTML/Preferences/TimeZone.pm
        'Time zone updated successfully!' => '',

        # Perl Module: Kernel/Output/HTML/Statistics/View.pm
        'invalid' => 'non valide',
        'valid' => 'valide',
        'No (not supported)' => '',
        'No past complete or the current+upcoming complete relative time value selected.' =>
            '',
        'The selected time period is larger than the allowed time period.' =>
            '',
        'No time scale value available for the current selected time scale value on the X axis.' =>
            '',
        'The selected date is not valid.' => '',
        'The selected end time is before the start time.' => '',
        'There is something wrong with your time selection.' => '',
        'Please select only one element or allow modification at stat generation time.' =>
            '',
        'Please select at least one value of this field or allow modification at stat generation time.' =>
            '',
        'Please select one element for the X-axis.' => '',
        'You can only use one time element for the Y axis.' => '',
        'You can only use one or two elements for the Y axis.' => '',
        'Please select at least one value of this field.' => '',
        'Please provide a value or allow modification at stat generation time.' =>
            '',
        'Please select a time scale.' => '',
        'Your reporting time interval is too small, please use a larger time scale.' =>
            '',
        'second(s)' => 'seconde(s)',
        'quarter(s)' => '',
        'half-year(s)' => '',
        'Please remove the following words because they cannot be used for the ticket restrictions: %s.' =>
            '',

        # Perl Module: Kernel/Output/HTML/SysConfig.pm
        'Cancel editing and unlock this setting' => '',
        'Reset this setting to its default value.' => '',
        'Unable to load %s!' => '',
        'Content' => 'Contenu',

        # Perl Module: Kernel/Output/HTML/TicketMenu/Lock.pm
        'Unlock to give it back to the queue' => 'Déverrouillage permettant de remettre en file',
        'Lock it to work on it' => 'Verrouiller la demande pour y travailler',

        # Perl Module: Kernel/Output/HTML/TicketMenu/TicketWatcher.pm
        'Unwatch' => 'Arrêter la surveillance',
        'Remove from list of watched tickets' => 'Retirer de la liste des demandes sous surveillance',
        'Watch' => 'Surveiller',
        'Add to list of watched tickets' => 'Ajouter à la liste des demandes sous surveillance',

        # Perl Module: Kernel/Output/HTML/TicketOverviewMenu/Sort.pm
        'Order by' => 'Trier par',

        # Perl Module: Kernel/Output/HTML/TicketZoom/TicketInformation.pm
        'Ticket Information' => 'Information sur la demande',

        # Perl Module: Kernel/Output/HTML/ToolBar/TicketLocked.pm
        'Locked Tickets New' => 'Nouvelles demandes verrouillées',
        'Locked Tickets Reminder Reached' => 'Rappel des demandes fermées atteint',
        'Locked Tickets Total' => 'Total des demandes verrouillés',

        # Perl Module: Kernel/Output/HTML/ToolBar/TicketResponsible.pm
        'Responsible Tickets New' => 'Nouvelles demandes du responsable',
        'Responsible Tickets Reminder Reached' => 'Rappel pour le responsable des demandes atteint.',
        'Responsible Tickets Total' => 'Total des demandes du responsable',

        # Perl Module: Kernel/Output/HTML/ToolBar/TicketWatcher.pm
        'Watched Tickets New' => 'Total de nouvelles demandes',
        'Watched Tickets Reminder Reached' => 'Rappel des demandes vues atteint',
        'Watched Tickets Total' => 'Total des demandes vues',

        # Perl Module: Kernel/Output/PDF/Ticket.pm
        'Ticket Dynamic Fields' => '',

        # Perl Module: Kernel/System/ACL/DB/ACL.pm
        'Couldn\'t read ACL configuration file. Please make sure the file is valid.' =>
            '',

        # Perl Module: Kernel/System/Auth.pm
        'It is currently not possible to login due to a scheduled system maintenance.' =>
            '',

        # Perl Module: Kernel/System/AuthSession.pm
        'You have exceeded the number of concurrent agents - contact sales@otrs.com.' =>
            '',
        'Please note that the session limit is almost reached.' => '',
        'Login rejected! You have exceeded the maximum number of concurrent Agents! Contact sales@otrs.com immediately!' =>
            '',
        'Session limit reached! Please try again later.' => '',
        'Session per user limit reached!' => '',

        # Perl Module: Kernel/System/AuthSession/DB.pm
        'Session invalid. Please log in again.' => '',
        'Session has timed out. Please log in again.' => 'Le délai de votre session est dépassé, veuillez vous ré-authentifier.',

        # Perl Module: Kernel/System/Calendar/Event/Transport/Email.pm
        'PGP sign only' => '',
        'PGP encrypt only' => '',
        'SMIME sign only' => '',
        'SMIME encrypt only' => '',
        'PGP and SMIME not enabled.' => '',
        'Skip notification delivery' => '',
        'Send unsigned notification' => '',
        'Send unencrypted notification' => '',

        # Perl Module: Kernel/System/Console/Command/Dev/Tools/Config2Docbook.pm
        'Configuration Options Reference' => '',
        'This setting can not be changed.' => '',
        'This setting is not active by default.' => '',
        'This setting can not be deactivated.' => '',
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
        'before/after' => '',
        'between' => 'entre',

        # Perl Module: Kernel/System/DynamicField/Driver/BaseText.pm
        'e.g. Text or Te*t' => '',

        # Perl Module: Kernel/System/DynamicField/Driver/Checkbox.pm
        'Ignore this field.' => '',

        # Perl Module: Kernel/System/DynamicField/Driver/TextArea.pm
        'This field is required or' => '',
        'The field content is too long!' => '',
        'Maximum size is %s characters.' => '',

        # Perl Module: Kernel/System/NotificationEvent.pm
        'Couldn\'t read Notification configuration file. Please make sure the file is valid.' =>
            '',
        'Imported notification has body text with more than 4000 characters.' =>
            '',

        # Perl Module: Kernel/System/Package.pm
        'not installed' => '',
        'installed' => 'installé',
        'Unable to parse repository index document.' => 'Le système est incapable d\'analyser l\'index du répertoire.',
        'No packages for your framework version found in this repository, it only contains packages for other framework versions.' =>
            'Aucun paquet n\'a été trouvé dans le répertoire pour votre version du cadre d\'applications; les paquets trouvés concernent d\'autres versions.',
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
        'Inactive' => '',
        'FadeAway' => '',

        # Perl Module: Kernel/System/Registration.pm
        'Can\'t contact registration server. Please try again later.' => '',
        'No content received from registration server. Please try again later.' =>
            '',
        'Can\'t get Token from sever' => '',
        'Username and password do not match. Please try again.' => '',
        'Problems processing server result. Please try again later.' => '',

        # Perl Module: Kernel/System/Stats.pm
        'Sum' => 'Somme',
        'week' => 'semaine',
        'quarter' => '',
        'half-year' => '',

        # Perl Module: Kernel/System/Stats/Dynamic/Ticket.pm
        'State Type' => '',
        'Created Priority' => 'Priorité créée ',
        'Created State' => 'État créé ',
        'Create Time' => 'Date de création ',
        'Pending until time' => '',
        'Close Time' => 'Date de fermeture ',
        'Escalation' => 'Escalade ',
        'Escalation - First Response Time' => '',
        'Escalation - Update Time' => '',
        'Escalation - Solution Time' => '',
        'Agent/Owner' => 'Agent ou propriétaire ',
        'Created by Agent/Owner' => 'Créé par l\'agent ou le propriétaire',
        'Assigned to Customer User Login' => '',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketAccountedTime.pm
        'Evaluation by' => 'Évaluation par',
        'Ticket/Article Accounted Time' => 'Temps alloué par demande ou par article',
        'Ticket Create Time' => 'Heure de création de la demande',
        'Ticket Close Time' => 'Heure de fermeture de la demande',
        'Accounted time by Agent' => 'Temps alloué par agent',
        'Total Time' => 'Temps Total',
        'Ticket Average' => 'Moyenne des demandes',
        'Ticket Min Time' => 'Temps minimum de la demande',
        'Ticket Max Time' => 'Temps maximum de la demande',
        'Number of Tickets' => 'Nombre de demandes',
        'Article Average' => 'Moyenne des articles',
        'Article Min Time' => 'Temps minimum des articles',
        'Article Max Time' => 'Temps maximum des articles',
        'Number of Articles' => 'Nombre d\'articles',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketList.pm
        'unlimited' => '',
        'Attributes to be printed' => 'Attributs à imprimer',
        'Sort sequence' => 'Ordre de tri',
        'State Historic' => '',
        'State Type Historic' => '',
        'Historic Time Range' => '',
        'Number' => 'Nombre',
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
        'Days' => 'Jours',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/OutdatedTables.pm
        'Outdated Tables' => '',
        'Outdated tables were found in the database. These can be removed if empty.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/TablePresence.pm
        'Table Presence' => '',
        'Internal Error: Could not open file.' => '',
        'Table Check' => '',
        'Internal Error: Could not read file.' => '',
        'Tables found which are not present in the database.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mssql/Size.pm
        'Database Size' => '',
        'Could not determine database size.' => 'La taille de la base de données n\'a pu être déterminée.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mssql/Version.pm
        'Database Version' => '',
        'Could not determine database version.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Charset.pm
        'Client Connection Charset' => '',
        'Setting character_set_client needs to be utf8.' => '',
        'Server Database Charset' => '',
        'This character set is not yet supported, please see https://bugs.otrs.org/show_bug.cgi?id=12361. Please convert your database to the character set \'utf8\'.' =>
            '',
        'The setting character_set_database needs to be \'utf8\'.' => '',
        'Table Charset' => '',
        'There were tables found which do not have \'utf8\' as charset.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/InnoDBLogFileSize.pm
        'InnoDB Log File Size' => '',
        'The setting innodb_log_file_size must be at least 256 MB.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/InvalidDefaultValues.pm
        'Invalid Default Values' => '',
        'Tables with invalid default values were found. In order to fix it automatically, please run: bin/otrs.Console.pl Maint::Database::Check --repair' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/MaxAllowedPacket.pm
        'Maximum Query Size' => '',
        'The setting \'max_allowed_packet\' must be higher than 64 MB.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Performance.pm
        'Query Cache Size' => '',
        'The setting \'query_cache_size\' should be used (higher than 10 MB but not more than 512 MB).' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/StorageEngine.pm
        'Default Storage Engine' => '',
        'Table Storage Engine' => '',
        'Tables with a different storage engine than the default engine were found.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Version.pm
        'MySQL 5.x or higher is required.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/oracle/NLS.pm
        'NLS_LANG Setting' => '',
        'NLS_LANG must be set to al32utf8 (e.g. GERMAN_GERMANY.AL32UTF8).' =>
            '',
        'NLS_DATE_FORMAT Setting' => '',
        'NLS_DATE_FORMAT must be set to \'YYYY-MM-DD HH24:MI:SS\'.' => '',
        'NLS_DATE_FORMAT Setting SQL Check' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/oracle/PrimaryKeySequencesAndTriggers.pm
        'Primary Key Sequences and Triggers' => '',
        'The following sequences and/or triggers with possible wrong names have been found. Please rename them manually.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/Charset.pm
        'Setting client_encoding needs to be UNICODE or UTF8.' => '',
        'Setting server_encoding needs to be UNICODE or UTF8.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/DateStyle.pm
        'Date Format' => '',
        'Setting DateStyle needs to be ISO.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/PrimaryKeySequences.pm
        'Primary Key Sequences' => '',
        'The following sequences with possible wrong names have been found. Please rename them manually.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/Version.pm
        'PostgreSQL 9.2 or higher is required.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskPartitionOTRS.pm
        'OTRS Disk Partition' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskSpace.pm
        'Disk Usage' => '',
        'The partition where OTRS is located is almost full.' => '',
        'The partition where OTRS is located has no disk space problems.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskSpacePartitions.pm
        'Disk Partitions Usage' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Distribution.pm
        'Distribution' => '',
        'Could not determine distribution.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/KernelVersion.pm
        'Kernel Version' => '',
        'Could not determine kernel version.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Load.pm
        'System Load' => '',
        'The system load should be at maximum the number of CPUs the system has (e.g. a load of 8 or less on a system with 8 CPUs is OK).' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/PerlModules.pm
        'Perl Modules' => '',
        'Not all required Perl modules are correctly installed.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/PerlModulesAudit.pm
        'Perl Modules Audit' => '',
        'CPAN::Audit reported that one or more installed Perl modules have known vulnerabilities. Please note that there might be false positives for distributions patching Perl modules without changing their version number.' =>
            '',
        'CPAN::Audit did not report any known vulnerabilities in the installed Perl modules.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Swap.pm
        'Free Swap Space (%)' => '',
        'No swap enabled.' => '',
        'Used Swap Space (MB)' => '',
        'There should be more than 60% free swap space.' => '',
        'There should be no more than 200 MB swap space used.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/ArticleSearchIndexStatus.pm
        'OTRS' => '',
        'Article Search Index Status' => '',
        'Indexed Articles' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/ArticlesPerCommunicationChannel.pm
        'Articles Per Communication Channel' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/CommunicationLog.pm
        'Incoming communications' => '',
        'Outgoing communications' => '',
        'Failed communications' => '',
        'Average processing time of communications (s)' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/CommunicationLogAccountStatus.pm
        'Communication Log Account Status (last 24 hours)' => '',
        'No connections found.' => '',
        'ok' => '',
        'permanent connection errors' => '',
        'intermittent connection errors' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/ConfigSettings.pm
        'Config Settings' => '',
        'Could not determine value.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/DaemonRunning.pm
        'Daemon' => '',
        'Daemon is running.' => '',
        'Daemon is not running.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/DatabaseRecords.pm
        'Database Records' => '',
        'Tickets' => 'Demandes',
        'Ticket History Entries' => '',
        'Articles' => 'Articles',
        'Attachments (DB, Without HTML)' => '',
        'Customers With At Least One Ticket' => '',
        'Dynamic Field Values' => '',
        'Invalid Dynamic Fields' => '',
        'Invalid Dynamic Field Values' => '',
        'GenericInterface Webservices' => '',
        'Process Tickets' => '',
        'Months Between First And Last Ticket' => '',
        'Tickets Per Month (avg)' => '',
        'Open Tickets' => 'Demandes ouvertes',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/DefaultSOAPUser.pm
        'Default SOAP Username And Password' => '',
        'Security risk: you use the default setting for SOAP::User and SOAP::Password. Please change it.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/DefaultUser.pm
        'Default Admin Password' => '',
        'Security risk: the agent account root@localhost still has the default password. Please change it or invalidate the account.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/EmailQueue.pm
        'Email Sending Queue' => '',
        'Emails queued for sending' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/FQDN.pm
        'FQDN (domain name)' => '',
        'Please configure your FQDN setting.' => '',
        'Domain Name' => '',
        'Your FQDN setting is invalid.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/FileSystemWritable.pm
        'File System Writable' => '',
        'The file system on your OTRS partition is not writable.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/LegacyConfigBackups.pm
        'Legacy Configuration Backups' => '',
        'No legacy configuration backup files found.' => '',
        'Legacy configuration backup files found in Kernel/Config/Backups folder, but they might still be required by some packages.' =>
            '',
        'Legacy configuration backup files are no longer needed for the installed packages, please remove them from Kernel/Config/Backups folder.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/PackageDeployment.pm
        'Package Installation Status' => '',
        'Some packages have locally modified files.' => '',
        'Some packages are not correctly installed.' => '',
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
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/DefaultType.pm
        'Default Ticket Type' => '',
        'The configured default ticket type is invalid or missing. Please change the setting Ticket::Type::Default and select a valid ticket type.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/IndexModule.pm
        'Ticket Index Module' => '',
        'You have more than 60,000 tickets and should use the StaticDB backend. See admin manual (Performance Tuning) for more information.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/InvalidUsersWithLockedTickets.pm
        'Invalid Users with Locked Tickets' => '',
        'There are invalid users with locked tickets.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/OpenTickets.pm
        'You should not have more than 8,000 open tickets in your system.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/SearchIndexModule.pm
        'Ticket Search Index Module' => '',
        'The indexing process forces the storage of the original article text in the article search index, without executing filters or applying stop word lists. This will increase the size of the search index and thus may slow down fulltext searches.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/StaticDBOrphanedRecords.pm
        'Orphaned Records In ticket_lock_index Table' => '',
        'Table ticket_lock_index contains orphaned records. Please run bin/otrs.Console.pl "Maint::Ticket::QueueIndexCleanup" to clean the StaticDB index.' =>
            '',
        'Orphaned Records In ticket_index Table' => '',
        'Table ticket_index contains orphaned records. Please run bin/otrs.Console.pl "Maint::Ticket::QueueIndexCleanup" to clean the StaticDB index.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/TimeSettings.pm
        'Time Settings' => '',
        'Server time zone' => '',
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
        'Webserver' => '',
        'Loaded Apache Modules' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/MPMModel.pm
        'MPM model' => '',
        'OTRS requires apache to be run with the \'prefork\' MPM model.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/Performance.pm
        'CGI Accelerator Usage' => '',
        'You should use FastCGI or mod_perl to increase your performance.' =>
            'Vous devez utiliser « FastCGI » ou « mod_perl » afin d\'améliorer la performance du système.',
        'mod_deflate Usage' => '',
        'Please install mod_deflate to improve GUI speed.' => '',
        'mod_filter Usage' => '',
        'Please install mod_filter if mod_deflate is used.' => '',
        'mod_headers Usage' => '',
        'Please install mod_headers to improve GUI speed.' => '',
        'Apache::Reload Usage' => '',
        'Apache::Reload or Apache2::Reload should be used as PerlModule and PerlInitHandler to prevent web server restarts when installing and upgrading modules.' =>
            'Apache::Reload ou Apache2::Reload doit être utilisé en tant que « PerlModule » et « PerlInitHandler » pour s\'assurer que le serveur Web ne redémarre pas lors de l\'installation ou de la mise à niveau des modules.',
        'Apache2::DBI Usage' => '',
        'Apache2::DBI should be used to get a better performance  with pre-established database connections.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/EnvironmentVariables.pm
        'Environment Variables' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/InternalWebRequest.pm
        'Support Data Collection' => '',
        'Support data could not be collected from the web server.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Version.pm
        'Webserver Version' => '',
        'Could not determine webserver version.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/PluginAsynchronous/OTRS/ConcurrentUsers.pm
        'Concurrent Users Details' => '',
        'Concurrent Users' => '',

        # Perl Module: Kernel/System/SupportDataCollector/PluginBase.pm
        'OK' => '',
        'Problem' => 'Problème',

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
            'La session ne peut être ouverte. Le nom d\'utilisateur ou le mot de passe est incorrect.',
        'Authentication succeeded, but no user data record is found in the database. Please contact the administrator.' =>
            '',
        'Can`t remove SessionID.' => '',
        'Logout successful.' => '',
        'Feature not active!' => 'Cette fonctionnalité n\'est pas activée. ',
        'Sent password reset instructions. Please check your email.' => 'Les instructions relatives à la réinitialisation du mot de passe ont été envoyées. Veuillez vérifier vos courriels.',
        'Invalid Token!' => 'Jeton invalide.',
        'Sent new password to %s. Please check your email.' => 'Le nouveau mot de passe a été envoyé à %s. Veuillez vérifier vos courriels.',
        'Error: invalid session.' => '',
        'No Permission to use this frontend module!' => '',

        # Perl Module: Kernel/System/Web/InterfaceCustomer.pm
        'Authentication succeeded, but no customer record is found in the customer backend. Please contact the administrator.' =>
            '',
        'Reset password unsuccessful. Please contact the administrator.' =>
            '',
        'This e-mail address already exists. Please log in or reset your password.' =>
            '',
        'This email address is not allowed to register. Please contact support staff.' =>
            '',
        'Added via Customer Panel (%s)' => '',
        'Customer user can\'t be added!' => 'Le client n\'a pu être ajouté!',
        'Can\'t send account info!' => '',
        'New account created. Sent login information to %s. Please check your email.' =>
            'Le nouveau compte a été créé. Les informations relatives à l\'ouverture de session ont été envoyées à %s. Veuillez vérifier vos courriels.',

        # Perl Module: Kernel/System/Web/InterfaceInstaller.pm
        'Action "%s" not found!' => '',

        # Database XML Definition: scripts/database/otrs-initial_insert.xml
        'invalid-temporarily' => 'temporairement non valide',
        'Group for default access.' => '',
        'Group of all administrators.' => '',
        'Group for statistics access.' => '',
        'new' => 'nouvelle',
        'All new state types (default: viewable).' => '',
        'open' => 'ouverte',
        'All open state types (default: viewable).' => '',
        'closed' => 'fermée',
        'All closed state types (default: not viewable).' => '',
        'pending reminder' => 'rappel en attente',
        'All \'pending reminder\' state types (default: viewable).' => '',
        'pending auto' => 'mise en attente automatique',
        'All \'pending auto *\' state types (default: viewable).' => '',
        'removed' => 'supprimée',
        'All \'removed\' state types (default: not viewable).' => '',
        'merged' => 'fusionnée',
        'State type for merged tickets (default: not viewable).' => '',
        'New ticket created by customer.' => '',
        'closed successful' => 'fermée (résolue)',
        'Ticket is closed successful.' => '',
        'closed unsuccessful' => 'fermée (non résolue)',
        'Ticket is closed unsuccessful.' => '',
        'Open tickets.' => '',
        'Customer removed ticket.' => '',
        'Ticket is pending for agent reminder.' => '',
        'pending auto close+' => 'en attente de la fermeture automatique (+)',
        'Ticket is pending for automatic close.' => '',
        'pending auto close-' => 'en attente de la fermeture automatique (-)',
        'State for merged tickets.' => '',
        'system standard salutation (en)' => '',
        'Standard Salutation.' => '',
        'system standard signature (en)' => '',
        'Standard Signature.' => '',
        'Standard Address.' => '',
        'possible' => 'Réouverture de la demande',
        'Follow-ups for closed tickets are possible. Ticket will be reopened.' =>
            '',
        'reject' => 'Rejeter l\'option',
        'Follow-ups for closed tickets are not possible. No new ticket will be created.' =>
            '',
        'new ticket' => '',
        'Follow-ups for closed tickets are not possible. A new ticket will be created.' =>
            '',
        'Postmaster queue.' => '',
        'All default incoming tickets.' => '',
        'All junk tickets.' => '',
        'All misc tickets.' => '',
        'auto reply' => 'réponse automatique',
        'Automatic reply which will be sent out after a new ticket has been created.' =>
            '',
        'auto reject' => 'rejet automatique',
        'Automatic reject which will be sent out after a follow-up has been rejected (in case queue follow-up option is "reject").' =>
            '',
        'auto follow up' => 'suivi automatique',
        'Automatic confirmation which is sent out after a follow-up has been received for a ticket (in case queue follow-up option is "possible").' =>
            '',
        'auto reply/new ticket' => 'réponse auto ou nouvelle demande',
        'Automatic response which will be sent out after a follow-up has been rejected and a new ticket has been created (in case queue follow-up option is "new ticket").' =>
            '',
        'auto remove' => 'suppression automatique',
        'Auto remove will be sent out after a customer removed the request.' =>
            '',
        'default reply (after new ticket has been created)' => '',
        'default reject (after follow-up and rejected of a closed ticket)' =>
            '',
        'default follow-up (after a ticket follow-up has been added)' => '',
        'default reject/new ticket created (after closed follow-up with new ticket creation)' =>
            '',
        'Unclassified' => 'Non classé',
        '1 very low' => '1 minimale',
        '2 low' => '2 basse',
        '3 normal' => '3 normale',
        '4 high' => '4 haute',
        '5 very high' => '5 maximale',
        'unlock' => 'déverrouillée',
        'lock' => 'verrouillée',
        'tmp_lock' => '',
        'agent' => 'agent',
        'system' => 'système',
        'customer' => 'client',
        'Ticket create notification' => '',
        'You will receive a notification each time a new ticket is created in one of your "My Queues" or "My Services".' =>
            '',
        'Ticket follow-up notification (unlocked)' => '',
        'You will receive a notification if a customer sends a follow-up to an unlocked ticket which is in your "My Queues" or "My Services".' =>
            '',
        'Ticket follow-up notification (locked)' => '',
        'You will receive a notification if a customer sends a follow-up to a locked ticket of which you are the ticket owner or responsible.' =>
            '',
        'Ticket lock timeout notification' => 'Notification de désactivation du verrou ',
        'You will receive a notification as soon as a ticket owned by you is automatically unlocked.' =>
            '',
        'Ticket owner update notification' => '',
        'Ticket responsible update notification' => '',
        'Ticket new note notification' => '',
        'Ticket queue update notification' => '',
        'You will receive a notification if a ticket is moved into one of your "My Queues".' =>
            '',
        'Ticket pending reminder notification (locked)' => '',
        'Ticket pending reminder notification (unlocked)' => '',
        'Ticket escalation notification' => '',
        'Ticket escalation warning notification' => '',
        'Ticket service update notification' => '',
        'You will receive a notification if a ticket\'s service is changed to one of your "My Services".' =>
            '',
        'Appointment reminder notification' => '',
        'You will receive a notification each time a reminder time is reached for one of your appointments.' =>
            '',
        'Ticket email delivery failure notification' => '',

        # JS File: Core.AJAX
        'Error during AJAX communication. Status: %s, Error: %s' => '',
        'This window must be called from compose window.' => '',

        # JS File: Core.Agent.Admin.ACL
        'Add all' => 'Ajouter tous',
        'An item with this name is already present.' => '',
        'This item still contains sub items. Are you sure you want to remove this item including its sub items?' =>
            '',

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
            'Voulez-vous vraiment effacer ce champ dynamique? Toutes les données associées seront PERDUES.',
        'Delete field' => 'Effacer ce champ',
        'Deleting the field and its data. This may take a while...' => '',

        # JS File: Core.Agent.Admin.GenericAgent
        'Remove this dynamic field' => '',
        'Remove selection' => '',
        'Do you really want to delete this generic agent job?' => '',
        'Delete this Event Trigger' => 'Supprimer ce déclencheur d\'évènements',
        'Duplicate event.' => '',
        'This event is already attached to the job, Please use a different one.' =>
            '',

        # JS File: Core.Agent.Admin.GenericInterfaceDebugger
        'An error occurred during communication.' => 'Une erreur est survenue durant la communication.',
        'Request Details' => 'Détails demandés',
        'Request Details for Communication ID' => '',
        'Show or hide the content.' => 'Afficher ou cacher le contenu.',
        'Clear debug log' => 'Supprimer l\'enregistrement de débogage',

        # JS File: Core.Agent.Admin.GenericInterfaceErrorHandling
        'Delete error handling module' => '',

        # JS File: Core.Agent.Admin.GenericInterfaceInvoker
        'It is not possible to add a new event trigger because the event is not set.' =>
            '',
        'Delete this Invoker' => 'Supprimer ce demandeur',

        # JS File: Core.Agent.Admin.GenericInterfaceInvokerEvent
        'Sorry, the only existing condition can\'t be removed.' => '',
        'Sorry, the only existing field can\'t be removed.' => '',
        'Delete conditions' => '',

        # JS File: Core.Agent.Admin.GenericInterfaceMapping
        'Mapping for Key %s' => '',
        'Mapping for Key' => '',
        'Delete this Key Mapping' => 'Supprimer ce mappage de clé',

        # JS File: Core.Agent.Admin.GenericInterfaceOperation
        'Delete this Operation' => 'Supprimer cette opération',

        # JS File: Core.Agent.Admin.GenericInterfaceWebservice
        'Clone web service' => 'Cloner un service Web',
        'Delete operation' => 'Supprimer une opération',
        'Delete invoker' => 'Supprimer un demandeur',

        # JS File: Core.Agent.Admin.Group
        'WARNING: When you change the name of the group \'admin\', before making the appropriate changes in the SysConfig, you will be locked out of the administrations panel! If this happens, please rename the group back to admin per SQL statement.' =>
            'ATTENTION: Lorsque vous modifier le nom du group \'admin\', avant de faire les changements appropriés dans SysConfig, vous serez déconnecté du panneau d\'administration. Si cela arrive, veuillez renommer à nouveau le groupe admin par une requête SQL.',

        # JS File: Core.Agent.Admin.MailAccount
        'Delete this Mail Account' => '',
        'Deleting the mail account and its data. This may take a while...' =>
            '',

        # JS File: Core.Agent.Admin.NotificationEvent
        'Do you really want to delete this notification language?' => '',
        'Do you really want to delete this notification?' => '',

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
        'Remove Entity from canvas' => '',
        'No TransitionActions assigned.' => '',
        'No dialogs assigned yet. Just pick an activity dialog from the list on the left and drag it here.' =>
            '',
        'This Activity cannot be deleted because it is the Start Activity.' =>
            '',
        'Remove the Transition from this Process' => '',

        # JS File: Core.Agent.Admin.ProcessManagement
        'As soon as you use this button or link, you will leave this screen and its current state will be saved automatically. Do you want to continue?' =>
            '',
        'Delete Entity' => '',
        'This Activity is already used in the Process. You cannot add it twice!' =>
            '',
        'Error during AJAX communication' => '',
        'An unconnected transition is already placed on the canvas. Please connect this transition first before placing another transition.' =>
            '',
        'This Transition is already used for this Activity. You cannot use it twice!' =>
            '',
        'This TransitionAction is already used in this Path. You cannot use it twice!' =>
            '',
        'Hide EntityIDs' => '',
        'Edit Field Details' => '',
        'Customer interface does not support articles not visible for customers.' =>
            '',
        'Sorry, the only existing parameter can\'t be removed.' => '',

        # JS File: Core.Agent.Admin.SMIME
        'Do you really want to delete this certificate?' => '',

        # JS File: Core.Agent.Admin.SupportDataCollector
        'Sending Update...' => '',
        'Support Data information was successfully sent.' => '',
        'Was not possible to send Support Data information.' => '',
        'Update Result' => '',
        'Generating...' => '',
        'It was not possible to generate the Support Bundle.' => '',
        'Generate Result' => '',
        'Support Bundle' => '',
        'The mail could not be sent' => '',

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
        'Loading...' => 'Chargement...',
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
            '',

        # JS File: Core.Agent.Admin.Template
        'Delete this Template' => '',
        'Deleting the template and its data. This may take a while...' =>
            '',

        # JS File: Core.Agent.AppointmentCalendar
        'Jump' => '',
        'Timeline Month' => '',
        'Timeline Week' => '',
        'Timeline Day' => '',
        'Previous' => 'Précédent',
        'Resources' => '',
        'Su' => 'Di',
        'Mo' => 'Lu',
        'Tu' => 'Ma',
        'We' => 'Me',
        'Th' => 'Je',
        'Fr' => 'Ve',
        'Sa' => 'Sa',
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
        'Duplicated entry' => 'Dédoublement d\'une entrée',
        'It is going to be deleted from the field, please try again.' => 'Cela va être supprimé du champ. Veuillez ré-éssayer',

        # JS File: Core.Agent.CustomerUserAddressBook
        'Please enter at least one search value or * to find anything.' =>
            'Veuillez entrer au moins un critère de recherche ou une « * » pour trouver quoi que ce soit.',

        # JS File: Core.Agent.Daemon
        'Information about the OTRS Daemon' => '',

        # JS File: Core.Agent.Dashboard
        'Please check the fields marked as red for valid inputs.' => '',
        'month' => 'mois',
        'Remove active filters for this widget.' => '',

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
            '',
        'Sorry, but you can\'t disable all methods for this notification.' =>
            '',
        'Please note that at least one of the settings you have changed requires a page reload. Click here to reload the current screen.' =>
            '',
        'An unknown error occurred. Please contact the administrator.' =>
            '',

        # JS File: Core.Agent.Responsive
        'Switch to desktop mode' => '',

        # JS File: Core.Agent.Search
        'Please remove the following words from your search as they cannot be searched for:' =>
            '',

        # JS File: Core.Agent.SharedSecretGenerator
        'Generate' => '',

        # JS File: Core.Agent.SortedTree
        'This element has children elements and can currently not be removed.' =>
            '',

        # JS File: Core.Agent.Statistics
        'Do you really want to delete this statistic?' => '',

        # JS File: Core.Agent.TicketAction
        'Select a customer ID to assign to this ticket' => '',
        'Do you really want to continue?' => '',

        # JS File: Core.Agent.TicketBulk
        ' ...and %s more' => '',
        ' ...show less' => '',

        # JS File: Core.Agent.TicketFormDraft
        'Add new draft' => '',
        'Delete draft' => '',
        'There are no more drafts available.' => '',
        'It was not possible to delete this draft.' => '',

        # JS File: Core.Agent.TicketZoom
        'Article filter' => 'Filtre pour les articles',
        'Apply' => 'Appliquer',
        'Event Type Filter' => '',

        # JS File: Core.Agent
        'Slide the navigation bar' => '',
        'Please turn off Compatibility Mode in Internet Explorer!' => '',
        'Find out more' => '',

        # JS File: Core.App.Responsive
        'Switch to mobile mode' => '',

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
        'One or more errors occurred!' => 'Une ou plusieurs erreurs se sont produites!',

        # JS File: Core.Installer
        'Mail check successful.' => 'Contrôle de courriel effectué avec succès.',
        'Error in the mail settings. Please correct and try again.' => 'Erreur dans la configuration courriel. Veuillez corriger la configuration et réessayer.',

        # JS File: Core.SystemConfiguration
        'Open this node in a new window' => '',
        'Please add values for all keys before saving the setting.' => '',
        'The key must not be empty.' => '',
        'A key with this name (\'%s\') already exists.' => '',
        'Do you really want to revert this setting to its historical value?' =>
            '',

        # JS File: Core.UI.Datepicker
        'Open date selection' => 'Sélection de la date d\'ouverture',
        'Invalid date (need a future date)!' => 'Date non valide (besoin d\'une date ultérieure).',
        'Invalid date (need a past date)!' => '',

        # JS File: Core.UI.InputFields
        'Not available' => '',
        'and %s more...' => '',
        'Show current selection' => '',
        'Current selection' => '',
        'Clear all' => '',
        'Filters' => '',
        'Clear search' => '',

        # JS File: Core.UI.Popup
        'If you now leave this page, all open popup windows will be closed, too!' =>
            'Si vous quittez cette page maintenant, toutes les fenêtres contextuelles seront également fermées!',
        'A popup of this screen is already open. Do you want to close it and load this one instead?' =>
            'Une fenêtre contextuelle de cet écran est déjà ouverte. Désirez-vous la fermer et télécharger celle-ci à la place?',
        'Could not open popup window. Please disable any popup blockers for this application.' =>
            'La fenêtre contextuelle n\'a pas pu s\'ouvrir. Veuillez désactiver le bloqueur de fenêtres contextuelles pour cette application.',

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
        'There are currently no elements available to select from.' => '',

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
        'yes' => 'oui',
        'no' => 'non',
        'This is %s' => '',
        'Complex %s with %s arguments' => '',

        # JS File: OTRSLineChart
        'No Data Available.' => '',

        # JS File: OTRSMultiBarChart
        'Grouped' => '',
        'Stacked' => '',

        # JS File: OTRSStackedAreaChart
        'Stream' => '',
        'Expanded' => '',

        # SysConfig
        '
Dear Customer,

Unfortunately we could not detect a valid ticket number
in your subject, so this email can\'t be processed.

Please create a new ticket via the customer panel.

Thanks for your help!

 Your Helpdesk Team
' => '',
        ' (work units)' => '',
        ' 2 minutes' => ' 2 minutes',
        ' 5 minutes' => ' 5 minutes',
        ' 7 minutes' => ' 7 minutes',
        '"Slim" skin which tries to save screen space for power users.' =>
            '',
        '%s' => '%s',
        '(UserLogin) Firstname Lastname' => '',
        '(UserLogin) Lastname Firstname' => '',
        '(UserLogin) Lastname, Firstname' => '',
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
        'A Website' => '',
        'A list of dynamic fields that are merged into the main ticket during a merge operation. Only dynamic fields that are empty in the main ticket will be set.' =>
            '',
        'A picture' => '',
        'ACL module that allows closing parent tickets only if all its children are already closed ("State" shows which states are not available for the parent ticket until all child tickets are closed).' =>
            'Le module ACL permet la fermeture des demandes parents uniquement si les demandes enfants sont déjà fermées (l\' « État » affiche quels sont les états qui ne peuvent être accessibles pour les demandes parents jusqu\'à ce que l\'ensemble des demandes enfants soient fermées).',
        'Access Control Lists (ACL)' => '',
        'AccountedTime' => '',
        'Activates a blinking mechanism of the queue that contains the oldest ticket.' =>
            'Active le clignotement de la file qui contient la demande la plus ancienne.',
        'Activates lost password feature for agents, in the agent interface.' =>
            'Active la fonction « mot de passe perdu » pour les agents, dans l\'interface des agents.',
        'Activates lost password feature for customers.' => 'Active la fonction « mot de passe perdu » pour les clients.',
        'Activates support for customer and customer user groups.' => '',
        'Activates the article filter in the zoom view to specify which articles should be shown.' =>
            'Active le filtre des articles dans la vue de la synthèse afin de désigner quels articles doivent être affichés.',
        'Activates the available themes on the system. Value 1 means active, 0 means inactive.' =>
            'Active les thèmes accessibles dans le système. La valeur « 1 » signifie « actif » et la valeur « 0 » signifie « inactif ».',
        'Activates the ticket archive system search in the customer interface.' =>
            'Active l\'outil de recherche dans l\'archivage des demandes de l\'interface client.',
        'Activates the ticket archive system to have a faster system by moving some tickets out of the daily scope. To search for these tickets, the archive flag has to be enabled in the ticket search.' =>
            'Active la fonction d\'archivage des demandes pour accélérer le système en déplaçant des demandes qui ne sont pas du jour. Pour rechercher vos demandes, activez l\'indicateur d\'archivage dans la boîte de recherche.',
        'Activates time accounting.' => 'Active la comptabilisation du temps.',
        'ActivityID' => '',
        'Add a note to this ticket' => 'Ajouter une note à cette demande',
        'Add an inbound phone call to this ticket' => '',
        'Add an outbound phone call to this ticket' => '',
        'Added %s time unit(s), for a total of %s time unit(s).' => '',
        'Added email. %s' => 'Ajout d\'une adresse électronique. %s',
        'Added follow-up to ticket [%s]. %s' => '',
        'Added link to ticket "%s".' => 'Ajout d\'un lien vers la demande "%s".',
        'Added note (%s).' => '',
        'Added phone call from customer.' => '',
        'Added phone call to customer.' => '',
        'Added subscription for user "%s".' => 'Abonnement pour l\'utilisateur "%s".',
        'Added system request (%s).' => '',
        'Added web request from customer.' => '',
        'Adds a suffix with the actual year and month to the OTRS log file. A logfile for every month will be created.' =>
            'Ajoute un suffixe comprenant l\'année et le mois en cours au fichier d\'enregistrement de OTRS. Un fichier d\'enregistrement est créé à chaque mois.',
        'Adds customers email addresses to recipients in the ticket compose screen of the agent interface. The customers email address won\'t be added if the article type is email-internal.' =>
            '',
        'Adds the one time vacation days for the indicated calendar.' => '',
        'Adds the one time vacation days.' => '',
        'Adds the permanent vacation days for the indicated calendar.' =>
            '',
        'Adds the permanent vacation days.' => '',
        'Admin' => 'Administrateur',
        'Admin Area.' => '',
        'Admin Notification' => 'Notifications',
        'Admin area navigation for the agent interface.' => '',
        'Admin modules overview.' => '',
        'Admin.' => '',
        'Administration' => '',
        'Agent Customer Search' => '',
        'Agent Customer Search.' => '',
        'Agent Name' => '',
        'Agent Name + FromSeparator + System Address Display Name' => '',
        'Agent Preferences.' => '',
        'Agent Statistics.' => '',
        'Agent User Search' => '',
        'Agent User Search.' => '',
        'Agent interface article notification module to check PGP.' => 'Module de notification des articles dans l\'interface agent pour vérifier les clés PGP.',
        'Agent interface article notification module to check S/MIME.' =>
            'Module de notification des articles dans l\'interface agent pour vérifier les certificats S/MIME.',
        'Agent interface module to access CIC search via nav bar. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Agent interface module to access fulltext search via nav bar. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Agent interface module to access search profiles via nav bar. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Agent interface module to check incoming emails in the Ticket-Zoom-View if the S/MIME-key is available and true.' =>
            'Module de l\'interface agent pour voir dans les courriels entrants si la clé S/MIME est accessible et vraie au moyen de la vue de la synthèse de la demande .',
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
        'Agents ↔ Roles' => '',
        'All CustomerIDs of a customer user.' => '',
        'All attachments (OTRS Business Solution™)' => '',
        'All customer users of a CustomerID' => '',
        'All escalated tickets' => 'Les demandes escaladées',
        'All new tickets, these tickets have not been worked on yet' => 'Les nouvelles demandes; ces demandes n\'ont pas été traitées.',
        'All open tickets, these tickets have already been worked on.' =>
            '',
        'All tickets with a reminder set where the reminder date has been reached' =>
            'Les demandes dont la date de rappel à été atteinte.',
        'Allows adding notes in the close ticket screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            '',
        'Allows adding notes in the ticket free text screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            '',
        'Allows adding notes in the ticket note screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            '',
        'Allows adding notes in the ticket owner screen of a zoomed ticket in the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            '',
        'Allows adding notes in the ticket pending screen of a zoomed ticket in the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            '',
        'Allows adding notes in the ticket priority screen of a zoomed ticket in the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            '',
        'Allows adding notes in the ticket responsible screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            '',
        'Allows agents to exchange the axis of a stat if they generate one.' =>
            'Permet aux agents d\'intervertir les axes après avoir généré une statistique.',
        'Allows agents to generate individual-related stats.' => 'Permet aux agents de générer des statistiques relatives à une personne.',
        'Allows choosing between showing the attachments of a ticket in the browser (inline) or just make them downloadable (attachment).' =>
            'Permet le choix d\'afficher les pièces jointes d\'une demande dans le navigateur (en file) ou de faire en sorte quelles soient téléchargeables.',
        'Allows choosing the next compose state for customer tickets in the customer interface.' =>
            'Permet de choisir le prochain état des demandes des clients dans l\'interface client.',
        'Allows customers to change the ticket priority in the customer interface.' =>
            'Permet aux clients de changer la priorité d\'une demande dans l\'interface client.',
        'Allows customers to set the ticket SLA in the customer interface.' =>
            'Permet aux clients d\'établir un accord sur les niveaux de service relativement à une demande dans l\'interface client.',
        'Allows customers to set the ticket priority in the customer interface.' =>
            'Permet aux clients d\'établir la priorité d\'une demande dans l\'interface client.',
        'Allows customers to set the ticket queue in the customer interface. If this is not enabled, QueueDefault should be configured.' =>
            '',
        'Allows customers to set the ticket service in the customer interface.' =>
            'Permet aux clients d\'établir le service relatif à la demande dans l\'interface client.',
        'Allows customers to set the ticket type in the customer interface. If this is not enabled, TicketTypeDefault should be configured.' =>
            '',
        'Allows default services to be selected also for non existing customers.' =>
            'Permet de sélectionner les services par défaut pour les clients inexistants.',
        'Allows defining services and SLAs for tickets (e. g. email, desktop, network, ...), and escalation attributes for SLAs (if ticket service/SLA feature is enabled).' =>
            'Permet d\'établir des services et des accords sur les niveaux de service (SLAs) pour les demandes (par ex. courriel, bureau, réseau, etc.) ainsi que des attributs d\'escalade des SLAs (si cette fonctionnalité est activée).',
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
            'Permet la visualisation de la demande en format « M » (moyen); les « Renseignements du client » (CustomerInfo => 1) présentent aussi les renseignements relatifs au client.',
        'Allows having a small format ticket overview (CustomerInfo => 1 - shows also the customer information).' =>
            'Permet la visualisation de la demande en format « S » (petit); les « Renseignements du client » (CustomerInfo => 1) présentent aussi les renseignements relatifs au client.',
        'Allows invalid agents to generate individual-related stats.' => '',
        'Allows the administrators to login as other customers, via the customer user administration panel.' =>
            '',
        'Allows the administrators to login as other users, via the users administration panel.' =>
            'Permet aux administrateurs d\'ouvrir une session à titre d\'utilisateurs au moyen de la page de gestion des utilisateurs.',
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
            'Permet d\'établir un nouvel état de la demande dans l\'écran de déplacement des demandes de l\'interface agent.',
        'Always show RichText if available' => '',
        'Answer' => 'Réponse ',
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
        'Arabic (Saudi Arabia)' => '',
        'ArticleTree' => '',
        'Attachment Name' => '',
        'Automated line break in text messages after x number of chars.' =>
            'Saut de ligne automatique dans les messages texte tous les x charactères.',
        'Automatically change the state of a ticket with an invalid owner once it is unlocked. Maps from a state type to a new ticket state.' =>
            '',
        'Automatically lock and set owner to current Agent after opening the move ticket screen of the agent interface.' =>
            '',
        'Automatically lock and set owner to current Agent after selecting for an Bulk Action.' =>
            'Après la sélection d\'une action groupée, verrouille la demande et établit systématiquement que l\'agent qui y travaille devient son propriétaire.',
        'Automatically sets the owner of a ticket as the responsible for it (if ticket responsible feature is enabled). This will only work by manually actions of the logged in user. It does not work for automated actions e.g. GenericAgent, Postmaster and GenericInterface.' =>
            '',
        'Automatically sets the responsible of a ticket (if it is not set yet) after the first owner update.' =>
            'Détermine systématiquement le responsable d\'une demande (s\'il n\'a pas encore été déterminé) après la mise à jour du premier propriétaire.',
        'Avatar' => '',
        'Balanced white skin by Felix Niklas (slim version).' => '',
        'Balanced white skin by Felix Niklas.' => 'Habillage blanc équilibré conçu par Felix Niklas.',
        'Based on global RichText setting' => '',
        'Basic fulltext index settings. Execute "bin/otrs.Console.pl Maint::Ticket::FulltextIndex --rebuild" in order to generate a new index.' =>
            '',
        'Blocks all the incoming emails that do not have a valid ticket number in subject with From: @example.com address.' =>
            'Pare tous les courriels entrants qui ont un numéro de demande qui n\'est pas valide inscrit dans le champ objet et dont l\'adresse de provenance est « @exemple.com ».',
        'Bounced to "%s".' => 'Retourner à "%s".',
        'Bulgarian' => '',
        'Bulk Action' => 'Action groupée',
        'CMD example setup. Ignores emails where external CMD returns some output on STDOUT (email will be piped into STDIN of some.bin).' =>
            'Réglage d\'un exemple de commande. Ignore les courriels dont la commande externe retourne des résultats sur une sortie standard STDOUT (le courriel sera conduit dans une entrée standard STDIN de « .bin »).',
        'CSV Separator' => 'Séparateur CSV',
        'Cache time in seconds for agent authentication in the GenericInterface.' =>
            'Temps de mémorisation en mémoire cache, en secondes, de l\'authentification de l\'agent dans l\'interface générique.',
        'Cache time in seconds for customer authentication in the GenericInterface.' =>
            'Temps de mémorisation en mémoire cache, en secondes, de l\'authentification du client dans l\'interface générique.',
        'Cache time in seconds for the DB ACL backend.' => '',
        'Cache time in seconds for the DB process backend.' => '',
        'Cache time in seconds for the SSL certificate attributes.' => '',
        'Cache time in seconds for the ticket process navigation bar output module.' =>
            '',
        'Cache time in seconds for the web service config backend.' => 'Temps de mémorisation en mémoire cache, en secondes, de l\'arrière-plan de la configuration du service Web.',
        'Calendar manage screen.' => '',
        'Catalan' => '',
        'Change password' => 'Changer de mot de passe',
        'Change queue!' => 'Changer de file.',
        'Change the customer for this ticket' => 'Changer le client de cette demande',
        'Change the free fields for this ticket' => 'Modifier les champs libres de cette demande',
        'Change the owner for this ticket' => 'Changer le propriétaire de cette demande',
        'Change the priority for this ticket' => 'Modifier la priorité de cette demande',
        'Change the responsible for this ticket' => '',
        'Change your avatar image.' => '',
        'Change your password and more.' => '',
        'Changed SLA to "%s" (%s).' => '',
        'Changed archive state to "%s".' => '',
        'Changed customer to "%s".' => '',
        'Changed dynamic field %s from "%s" to "%s".' => '',
        'Changed owner to "%s" (%s).' => '',
        'Changed pending time to "%s".' => '',
        'Changed priority from "%s" (%s) to "%s" (%s).' => 'Changement de priorité de "%s" (%s) pour "%s" (%s).',
        'Changed queue to "%s" (%s) from "%s" (%s).' => '',
        'Changed responsible to "%s" (%s).' => '',
        'Changed service to "%s" (%s).' => '',
        'Changed state from "%s" to "%s".' => '',
        'Changed title from "%s" to "%s".' => '',
        'Changed type from "%s" (%s) to "%s" (%s).' => '',
        'Changes the owner of tickets to everyone (useful for ASP). Normally only agent with rw permissions in the queue of the ticket will be shown.' =>
            'Permet à tous les agents d\'être propriétaires des demandes (utile en programmation Web dynamique). Normalement, seuls les agents avec permission de lecture et d\'écriture dans la file de la demande apparaîtront.',
        'Chat communication channel.' => '',
        'Checkbox' => 'Case à cocher',
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
        'Child' => 'Enfant',
        'Chinese (Simplified)' => '',
        'Chinese (Traditional)' => '',
        'Choose for which kind of appointment changes you want to receive notifications.' =>
            '',
        'Choose for which kind of ticket changes you want to receive notifications. Please note that you can\'t completely disable notifications marked as mandatory.' =>
            '',
        'Choose which notifications you\'d like to receive.' => '',
        'Christmas Eve' => 'Réveillon de Noël',
        'Close' => 'Fermer',
        'Close this ticket' => 'Fermer cette demande',
        'Closed tickets (customer user)' => '',
        'Closed tickets (customer)' => '',
        'Cloud Services' => '',
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
        'Comment for new history entries in the customer interface.' => 'Commentaire destiné aux nouvelles entrées de l\'historique de l\'interface client.',
        'Comment2' => '',
        'Communication' => '',
        'Communication & Notifications' => '',
        'Communication Log GUI' => '',
        'Communication log limit per page for Communication Log Overview.' =>
            '',
        'CommunicationLog Overview Limit' => '',
        'Company Status' => 'Statut de l\'entreprise',
        'Company Tickets.' => '',
        'Company name which will be included in outgoing emails as an X-Header.' =>
            '',
        'Compat module for AgentZoom to AgentTicketZoom.' => '',
        'Complex' => '',
        'Compose' => 'Composer',
        'Configure Processes.' => '',
        'Configure and manage ACLs.' => '',
        'Configure any additional readonly mirror databases that you want to use.' =>
            '',
        'Configure sending of support data to OTRS Group for improved support.' =>
            '',
        'Configure which screen should be shown after a new ticket has been created.' =>
            '',
        'Configure your own log text for PGP.' => 'Configure votre journal pour le logiciel de chiffrement PGP.',
        'Configures a default TicketDynamicField setting. "Name" defines the dynamic field which should be used, "Value" is the data that will be set, and "Event" defines the trigger event. Please check the developer manual (https://doc.otrs.com/doc/), chapter "Ticket Event Module".' =>
            '',
        'Controls how to display the ticket history entries as readable values.' =>
            '',
        'Controls if CustomerID is automatically copied from the sender address for unknown customers.' =>
            '',
        'Controls if CustomerID is read-only in the agent interface.' => '',
        'Controls if customers have the ability to sort their tickets.' =>
            'Contrôle la possibilité pour les clients de classer leurs demandes.',
        'Controls if more than one from entry can be set in the new phone ticket in the agent interface.' =>
            'Contrôle si plus d\'une entrée dans le champ « de » peut être inscrite dans une nouvelle demande téléphonique depuis l\'interface agent.',
        'Controls if the admin is allowed to import a saved system configuration in SysConfig.' =>
            '',
        'Controls if the admin is allowed to make changes to the database via AdminSelectBox.' =>
            '',
        'Controls if the autocomplete field will be used for the customer ID selection in the AdminCustomerUser interface.' =>
            '',
        'Controls if the ticket and article seen flags are removed when a ticket is archived.' =>
            '',
        'Converts HTML mails into text messages.' => 'Convertit les courriels HTML en messages texte.',
        'Create New process ticket.' => '',
        'Create Ticket' => '',
        'Create a new calendar appointment linked to this ticket' => '',
        'Create and manage Service Level Agreements (SLAs).' => 'Créer et gérer les accords sur les niveaux de service (SLAs).',
        'Create and manage agents.' => 'Créer et gérer les agents.',
        'Create and manage appointment notifications.' => '',
        'Create and manage attachments.' => 'Créer et gérer les pièces jointes.',
        'Create and manage calendars.' => '',
        'Create and manage customer users.' => 'Créer et gérer les clients utilisateurs.',
        'Create and manage customers.' => 'Créer et gérer les clients.',
        'Create and manage dynamic fields.' => 'Créer et gérer les champs dynamiques.',
        'Create and manage groups.' => 'Créer et gérer les groupes.',
        'Create and manage queues.' => 'Créer et gérer les files.',
        'Create and manage responses that are automatically sent.' => 'Créer et gérer les réponses envoyées automatiquement.',
        'Create and manage roles.' => 'Créer et gérer les rôles.',
        'Create and manage salutations.' => 'Créer et gérer les formules de salutation.',
        'Create and manage services.' => 'Créer et gérer les services.',
        'Create and manage signatures.' => 'Créer et gérer les signatures.',
        'Create and manage templates.' => '',
        'Create and manage ticket notifications.' => '',
        'Create and manage ticket priorities.' => 'Créer et gérer les priorités de la demande.',
        'Create and manage ticket states.' => 'Créer et gérer les états des demandes.',
        'Create and manage ticket types.' => 'Créer et gérer les types de demandes.',
        'Create and manage web services.' => 'Créer et gérer les services Web.',
        'Create new Ticket.' => '',
        'Create new appointment.' => '',
        'Create new email ticket and send this out (outbound).' => '',
        'Create new email ticket.' => '',
        'Create new phone ticket (inbound).' => '',
        'Create new phone ticket.' => '',
        'Create new process ticket.' => '',
        'Create tickets.' => '',
        'Created ticket [%s] in "%s" with priority "%s" and state "%s".' =>
            '',
        'Croatian' => '',
        'Custom RSS Feed' => '',
        'Custom RSS feed.' => '',
        'Custom text for the page shown to customers that have no tickets yet (if you need those text translated add them to a custom translation module).' =>
            '',
        'Customer Administration' => 'Administration des clients',
        'Customer Companies' => 'Entreprises clientes',
        'Customer IDs' => '',
        'Customer Information Center Search.' => '',
        'Customer Information Center search.' => '',
        'Customer Information Center.' => '',
        'Customer Ticket Print Module.' => '',
        'Customer User Administration' => 'Administration des utilisateurs clients',
        'Customer User Information' => '',
        'Customer User Information Center Search.' => '',
        'Customer User Information Center search.' => '',
        'Customer User Information Center.' => '',
        'Customer Users ↔ Customers' => '',
        'Customer Users ↔ Groups' => '',
        'Customer Users ↔ Services' => '',
        'Customer item (icon) which shows the closed tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            'Article du client (icône) lui montrant les demandes fermées regroupées. Le réglage de l\'ouverture de session de l\'utilisateur-client (CustomerUserLogin) à 1 permet la recherche de demandes fondée sur le nom d\'ouverture de session plutôt que sur l\'identification du client.',
        'Customer item (icon) which shows the open tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            'Article du client (icône) lui montrant les demandes ouvertes regroupées. Le réglage de l\'ouverture de session de l\'utilisateur-client (CustomerUserLogin) à 1 permet la recherche de demandes fondée sur le nom d\'ouverture de session plutôt que sur l\'identification du client.',
        'Customer preferences.' => '',
        'Customer ticket overview' => '',
        'Customer ticket search.' => '',
        'Customer ticket zoom' => '',
        'Customer user search' => 'Recherche par client utilisateur',
        'CustomerID search' => '',
        'CustomerName' => '',
        'CustomerUser' => '',
        'Customers ↔ Groups' => '',
        'Customizable stop words for fulltext index. These words will be removed from the search index.' =>
            '',
        'Czech' => '',
        'Danish' => '',
        'Dashboard overview.' => '',
        'Data used to export the search result in CSV format.' => 'Données utilisées pour exporter les résultats de recherche dans le format CSV.',
        'Date / Time' => 'Date et heure',
        'Default (Slim)' => '',
        'Default ACL values for ticket actions.' => 'Valeurs par défaut de la liste des droits d\'accès pour les actions des demandes.',
        'Default ProcessManagement entity prefixes for entity IDs that are automatically generated.' =>
            '',
        'Default agent name' => '',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimePointFormat=year;TicketCreateTimePointStart=Last;TicketCreateTimePoint=2;".' =>
            'Données par défaut à utiliser comme attributs dans l\'écran de recherche de demandes. Exemple : "TicketCreateTimePointFormat=year;TicketCreateTimePointStart=Last;TicketCreateTimePoint=2;".',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimeStartYear=2010;TicketCreateTimeStartMonth=10;TicketCreateTimeStartDay=4;TicketCreateTimeStopYear=2010;TicketCreateTimeStopMonth=11;TicketCreateTimeStopDay=3;".' =>
            'Données par défaut à utiliser comme attributs dans l\'écran de recherche de demandes. Exemple : "TicketCreateTimeStartYear=2010;TicketCreateTimeStartMonth=10;TicketCreateTimeStartDay=4;TicketCreateTimeStopYear=2010;TicketCreateTimeStopMonth=11;TicketCreateTimeStopDay=3;".',
        'Default display type for recipient (To,Cc) names in AgentTicketZoom and CustomerTicketZoom.' =>
            '',
        'Default display type for sender (From) names in AgentTicketZoom and CustomerTicketZoom.' =>
            '',
        'Default loop protection module.' => 'Module de protection en boucle par défaut.',
        'Default queue ID used by the system in the agent interface.' => 'Identification de files par défaut utilisée par le système dans l\'interface agent.',
        'Default skin for the agent interface (slim version).' => '',
        'Default skin for the agent interface.' => '',
        'Default skin for the customer interface.' => '',
        'Default ticket ID used by the system in the agent interface.' =>
            'Identification de demandes par défaut utilisée par le système dans l\'interface agent.',
        'Default ticket ID used by the system in the customer interface.' =>
            'Identification de demandes par défaut utilisée par le système dans l\'interface client.',
        'Default value for NameX' => 'Valeur par défaut pour un « NomX »',
        'Define Actions where a settings button is available in the linked objects widget (LinkObject::ViewMode = "complex"). Please note that these Actions must have registered the following JS and CSS files: Core.AllocationList.css, Core.UI.AllocationList.js, Core.UI.Table.Sort.js, Core.Agent.TableFilters.js.' =>
            '',
        'Define a filter for html output to add links behind a defined string. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Détermine un filtre pour les html sortants afin d\'ajouter des liens aux chaînes sélectionnées. L\'élément Image permet de faire deux sortes d\'entrées. Tout d\'abord, le nom de l\'image (ex. faq.png). Dans ce cas, le chemin de l\'image dans OTRS sera utilisé. Il est aussi possible d\'insérer le lien vers l\'image.',
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
        'Define the start day of the week for the date picker.' => 'Détermine le jour débutant la semaine pour le sélecteur de date.',
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
            'Détermine un élément client qui génère une icône LinkedIn à la fin du bloc d\'information client.',
        'Defines a customer item, which generates a XING icon at the end of a customer info block.' =>
            'Détermine un élément client qui génère une icône XING à la fin du bloc d\'information client.',
        'Defines a customer item, which generates a google icon at the end of a customer info block.' =>
            'Détermine un élément client qui génère une icône Google à la fin du bloc d\'information client.',
        'Defines a customer item, which generates a google maps icon at the end of a customer info block.' =>
            'Détermine un élément client qui génère une icône Google Maps à la fin du bloc d\'information client.',
        'Defines a filter for html output to add links behind CVE numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Détermine un filtre pour les html sortants afin d\'ajouter des liens aux nombres CVE. L\'élément Image permet de faire deux sortes d\'entrées. Tout d\'abord, le nom de l\'image (ex. faq.png). Dans ce cas, le chemin de l\'image dans OTRS sera utilisé. Il est aussi possible d\'insérer le lien vers l\'image.',
        'Defines a filter for html output to add links behind MSBulletin numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Détermine un filtre pour les html sortants afin d\'ajouter des liens aux nombres MSBulletin. L\'élément Image permet de faire deux sortes d\'entrées. Tout d\'abord, le nom de l\'image (ex. faq.png). Dans ce cas, le chemin de l\'image dans OTRS sera utilisé. Il est aussi possible d\'insérer le lien vers l\'image.',
        'Defines a filter for html output to add links behind a defined string. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Détermine un filtre pour les html sortants afin d\'ajouter des liens à des chaînes sélectionnées. L\'élément Image permet de faire deux sortes d\'entrées. Tout d\'abord, le nom de l\'image (ex. faq.png). Dans ce cas, le chemin de l\'image dans OTRS sera utilisé. Il est aussi possible d\'insérer le lien vers l\'image.',
        'Defines a filter for html output to add links behind bugtraq numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Détermine un filtre pour les html sortants afin d\'ajouter des liens aux nombres de retraçage des bogues. L\'élément Image permet de faire deux sortes d\'entrées. Tout d\'abord, le nom de l\'image (ex. faq.png). Dans ce cas, le chemin de l\'image dans OTRS sera utilisé. Il est aussi possible d\'insérer le lien vers l\'image.',
        'Defines a filter to collect CVE numbers from article texts in AgentTicketZoom. The results will be displayed in a meta box next to the article. Fill in URLPreview if you would like to see a preview when moving your mouse cursor above the link element. This could be the same URL as in URL, but also an alternate one. Please note that some websites deny being displayed within an iframe (e.g. Google) and thus won\'t work with the preview mode.' =>
            '',
        'Defines a filter to process the text in the articles, in order to highlight predefined keywords.' =>
            'Détermine un filtre pour traiter le texte dans les articles afin de mettre en surbrillance des mots clés prédéfinis.',
        'Defines a permission context for customer to group assignment.' =>
            '',
        'Defines a regular expression that excludes some addresses from the syntax check (if "CheckEmailAddresses" is set to "Yes"). Please enter a regex in this field for email addresses, that aren\'t syntactically valid, but are necessary for the system (i.e. "root@localhost").' =>
            'Détermine une expression rationnelle qui exclu certaines adresses du contrôle de syntaxe si le « Contrôle des adresses électroniques » (CheckEmailAddresses) est réglé à « Oui ». Veuillez entrer une expression rationnelle dans ce champ pour les adresses électroniques qui ne sont pas syntaxiquement correctes, mais qui sont essentielles au système (p.ex. « root@localhost »).',
        'Defines a regular expression that filters all email addresses that should not be used in the application.' =>
            'Détermine une expression rationnelle qui filtre les adresses électroniques qui ne devraient pas être utilisées dans l\'application.',
        'Defines a sleep time in microseconds between tickets while they are been processed by a job.' =>
            '',
        'Defines a useful module to load specific user options or to display news.' =>
            'Détermine un module utile qui charge des options spécifiques pour l\'utilisateur ou en affiche de nouvelles.',
        'Defines all the X-headers that should be scanned.' => 'Détermine les en-têtes qui doivent être analysés.',
        'Defines all the languages that are available to the application. Specify only English names of languages here.' =>
            '',
        'Defines all the languages that are available to the application. Specify only native names of languages here.' =>
            '',
        'Defines all the parameters for the RefreshTime object in the customer preferences of the customer interface.' =>
            'Détermine les paramètres pour l\'objet « Rafraîchissement » (RefreshTime) dans les préférences du client de l\'interface client.',
        'Defines all the parameters for the ShownTickets object in the customer preferences of the customer interface.' =>
            'Détermine les paramètres pour l\'objet « Demandes affichées » (ShownTickets) dans les préférences du client de l\'interface client.',
        'Defines all the parameters for this item in the customer preferences.' =>
            'Détermine les paramètres pour cet article dans les préférences du client.',
        'Defines all the parameters for this item in the customer preferences. \'PasswordRegExp\' allows to match passwords against a regular expression. Define the minimum number of characters using \'PasswordMinSize\'. Define if at least 2 lowercase and 2 uppercase letter characters are needed by setting the appropriate option to \'1\'. \'PasswordMin2Characters\' defines if the password needs to contain at least 2 letter characters (set to 0 or 1). \'PasswordNeedDigit\' controls the need of at least 1 digit (set to 0 or 1 to control).' =>
            '',
        'Defines all the parameters for this notification transport.' => '',
        'Defines all the possible stats output formats.' => 'Détermine les formats sortants possibles de statistiques.',
        'Defines an alternate URL, where the login link refers to.' => 'Détermine une adresse URL alternative à l\'endroit ou mène le lien d\'ouverture de session.',
        'Defines an alternate URL, where the logout link refers to.' => 'Détermine une adresse URL alternative à l\'endroit ou mène le lien de fermeture de session.',
        'Defines an alternate login URL for the customer panel..' => 'Détermine une adresse URL alternative d\'ouverture de session dans la page du client.',
        'Defines an alternate logout URL for the customer panel.' => 'Détermine une adresse URL alternative de fermeture de session dans la page du client.',
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
            'Détermine l\'affichage du champ « de » des courriels envoyés à partir de réponses aux demandes et de demandes courriels.',
        'Defines if a pre-sorting by priority should be done in the queue view.' =>
            '',
        'Defines if a pre-sorting by priority should be done in the service view.' =>
            '',
        'Defines if a ticket lock is required in the close ticket screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Détermine si le verrouillage de la demande est nécessaire dans l\'écran de fermeture de la demande de l\'interface agent (si la demande n\'est pas encore verrouillée, elle le devient automatiquement et l\'agent qui y travaille devient son propriétaire).',
        'Defines if a ticket lock is required in the email outbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the email resend screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket bounce screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Détermine si le verrouillage de la demande est nécessaire dans l\'écran de retour des demandes de l\'interface agent (si la demande n\'est pas encore verrouillée, elle le devient automatiquement et l\'agent qui y travaille devient son propriétaire).',
        'Defines if a ticket lock is required in the ticket compose screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Détermine si le verrouillage de la demande est nécessaire dans l\'écran de rédaction des demandes de l\'interface agent (si la demande n\'est pas encore verrouillée, elle le devient automatiquement et l\'agent qui y travaille devient son propriétaire).',
        'Defines if a ticket lock is required in the ticket forward screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Détermine si le verrouillage de la demande est nécessaire dans l\'écran de transfert des demandes de l\'interface agent (si la demande n\'est pas encore verrouillée, elle le devient automatiquement et l\'agent qui y travaille devient son propriétaire).',
        'Defines if a ticket lock is required in the ticket free text screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Détermine si le verrouillage de la demande est nécessaire dans l\'écran de texte libre des demandes de l\'interface agent (si la demande n\'est pas encore verrouillée, elle le devient automatiquement et l\'agent qui y travaille devient son propriétaire).',
        'Defines if a ticket lock is required in the ticket merge screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Détermine si le verrouillage de la demande est nécessaire dans l\'écran de fusion de la synthèse de la demande dans l\'interface agent (si la demande n\'est pas encore verrouillée, elle le devient automatiquement et l\'agent qui y travaille devient son propriétaire).',
        'Defines if a ticket lock is required in the ticket note screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Détermine si le verrouillage de la demande est nécessaire dans l\'écran de notes de l\'interface agent (si la demande n\'est pas encore verrouillée, elle le devient automatiquement et l\'agent qui y travaille devient son propriétaire).',
        'Defines if a ticket lock is required in the ticket owner screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Détermine si le verrouillage de la demande est nécessaire dans l\'écran du propriétaire de la synthèse de la demande dans l\'interface agent (si la demande n\'est pas encore verrouillée, elle le devient automatiquement et l\'agent qui y travaille devient son propriétaire).',
        'Defines if a ticket lock is required in the ticket pending screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Détermine si le verrouillage de la demande est nécessaire dans l\'écran de mise en attente de la synthèse de la demande dans l\'interface agent (si la demande n\'est pas encore verrouillée, elle le devient automatiquement et l\'agent qui y travaille devient son propriétaire).',
        'Defines if a ticket lock is required in the ticket phone inbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Détermine si le verrouillage de la demande est nécessaire dans l\'écran des demandes téléphoniques entrantes de l\'interface agent (si la demande n\'est pas encore verrouillée, elle le devient automatiquement et l\'agent qui y travaille devient son propriétaire).',
        'Defines if a ticket lock is required in the ticket phone outbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Détermine si le verrouillage de la demande est nécessaire dans l\'écran des demandes téléphoniques sortantes de l\'interface agent (si la demande n\'est pas encore verrouillée, elle le devient automatiquement et l\'agent qui y travaille devient son propriétaire).',
        'Defines if a ticket lock is required in the ticket priority screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Détermine si le verrouillage de la demande est nécessaire dans l\'écran de priorité de la synthèse de la demande dans l\'interface agent (si la demande n\'est pas encore verrouillée, elle le devient automatiquement et l\'agent qui y travaille devient son propriétaire).',
        'Defines if a ticket lock is required in the ticket responsible screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Détermine si le verrouillage de la demande est nécessaire dans l\'écran du responsable de la demande dans l\'interface agent (si la demande n\'est pas encore verrouillée, elle le devient automatiquement et l\'agent qui y travaille devient son propriétaire).',
        'Defines if a ticket lock is required to change the customer of a ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Détermine si le verrouillage de la demande est nécessaire pour modifier le client d\'une demande dans l\'interface agent (si la demande n\'est pas encore verrouillée, elle le devient automatiquement et l\'agent qui y travaille devient son propriétaire).',
        'Defines if agents should be allowed to login if they have no shared secret stored in their preferences and therefore are not using two-factor authentication.' =>
            '',
        'Defines if customers should be allowed to login if they have no shared secret stored in their preferences and therefore are not using two-factor authentication.' =>
            '',
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
            'Détermine si le compte du temps alloué doit être réglé pour toutes les demandes d\'une action groupée.',
        'Defines internal communication channel.' => '',
        'Defines out of office message template. Two string parameters (%s) available: end date and number of days left.' =>
            '',
        'Defines phone communication channel.' => '',
        'Defines queues that\'s tickets are used for displaying as calendar events.' =>
            '',
        'Defines the HTTP hostname for the support data collection with the public module \'PublicSupportDataCollector\' (e.g. used from the OTRS Daemon).' =>
            '',
        'Defines the IP regular expression for accessing the local repository. You need to enable this to have access to your local repository and the package::RepositoryList is required on the remote host.' =>
            'Détermine l\'expression rationnelle de l\'adresse IP permettant l\'accès au référentiel local. Vous devez activer cette fonction pour pouvoir accéder au référentiel local et le paquet « liste du référentiel » (package::RepositoryList) est requis sur le système distant.',
        'Defines the PostMaster header to be used on the filter for keeping the current state of the ticket.' =>
            '',
        'Defines the URL CSS path.' => 'Détermine le chemin URL du programme de simulation CSS.',
        'Defines the URL base path of icons, CSS and Java Script.' => 'Détermine le chemin URL de base des icônes, du CSS et de Java Script. ',
        'Defines the URL image path of icons for navigation.' => 'Détermine le chemin URL des images des icônes de navigation.',
        'Defines the URL java script path.' => 'Détermine le chemin URL de Java Script.',
        'Defines the URL rich text editor path.' => 'Détermine le chemin URL de l\'éditeur RTF.',
        'Defines the address of a dedicated DNS server, if necessary, for the "CheckMXRecord" look-ups.' =>
            'Si nécessaire, détermine l\'adresse d\'un serveur DNS dédié pour les consultations de table de vérification des enregistrement du messager (CheckMXRecord).',
        'Defines the agent preferences key where the shared secret key is stored.' =>
            '',
        'Defines the available steps in time selections. Select "Minute" to be able to select all minutes of one hour from 1-59. Select "30 Minutes" to only make full and half hours available.' =>
            '',
        'Defines the body text for notification mails sent to agents, about new password.' =>
            '',
        'Defines the body text for notification mails sent to agents, with token about new requested password.' =>
            '',
        'Defines the body text for notification mails sent to customers, about new account.' =>
            'Détermine le corps du texte des courriels de notification envoyés aux clients à propos des nouveaux comptes.',
        'Defines the body text for notification mails sent to customers, about new password.' =>
            '',
        'Defines the body text for notification mails sent to customers, with token about new requested password.' =>
            '',
        'Defines the body text for rejected emails.' => 'Détermine le corps du texte des courriels rejetés.',
        'Defines the calendar width in percent. Default is 95%.' => '',
        'Defines the column to store the keys for the preferences table.' =>
            'Détermine la colonne où seront stockées les clés des tables de préférences.',
        'Defines the config options for the autocompletion feature.' => '',
        'Defines the config parameters of this item, to be shown in the preferences view.' =>
            'Détermine les paramètres de configuration de cet élément qui seront présentés dans la vue des préférences.',
        'Defines the config parameters of this item, to be shown in the preferences view. \'PasswordRegExp\' allows to match passwords against a regular expression. Define the minimum number of characters using \'PasswordMinSize\'. Define if at least 2 lowercase and 2 uppercase letter characters are needed by setting the appropriate option to \'1\'. \'PasswordMin2Characters\' defines if the password needs to contain at least 2 letter characters (set to 0 or 1). \'PasswordNeedDigit\' controls the need of at least 1 digit (set to 0 or 1 to control). \'PasswordMaxLoginFailed\' allows to set an agent to invalid-temporarily if max failed logins reached. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Defines the config parameters of this item, to be shown in the preferences view. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Defines the connections for http/ftp, via a proxy.' => 'Détermine les connexions pour les protocoles HTTP ou FTP à partir d\'une passerelle de procuration.',
        'Defines the customer preferences key where the shared secret key is stored.' =>
            '',
        'Defines the date input format used in forms (option or input fields).' =>
            'Détermine le format de date utilisé dans les formulaires (champs d\'entrée ou d\'option).',
        'Defines the default CSS used in rich text editors.' => 'Détermine le CSS par défaut utilisé par les éditeurs RTF.',
        'Defines the default agent name in the ticket zoom view of the customer interface.' =>
            '',
        'Defines the default auto response type of the article for this operation.' =>
            'Détermine le type de réponses automatiques par défaut de l\'article pour cette opération.',
        'Defines the default body of a note in the ticket free text screen of the agent interface.' =>
            'Détermine le corps par défaut d\'une note dans l\'écran de texte libre de l\'interface agent.',
        'Defines the default filter fields in the customer user address book search (CustomerUser or CustomerCompany). For the CustomerCompany fields a prefix \'CustomerCompany_\' must be added.' =>
            '',
        'Defines the default front-end (HTML) theme to be used by the agents and customers. If you like, you can add your own theme. Please refer the administrator manual located at https://doc.otrs.com/doc/.' =>
            '',
        'Defines the default front-end language. All the possible values are determined by the available language files on the system (see the next setting).' =>
            'Détermine la langue de l\'avant-plan par défaut. Les valeurs possibles sont déterminées par les fichiers de langues disponibles dans le système (consultez le réglage suivant).',
        'Defines the default history type in the customer interface.' => 'Détermine le type d\'historique par défaut dans l\'interface client.',
        'Defines the default maximum number of X-axis attributes for the time scale.' =>
            'Détermine le nombre maximal par défaut d\'attributs de l\'axe x pour l\'échelle de temps.',
        'Defines the default maximum number of statistics per page on the overview screen.' =>
            '',
        'Defines the default next state for a ticket after customer follow-up in the customer interface.' =>
            '',
        'Defines the default next state of a ticket after adding a note, in the close ticket screen of the agent interface.' =>
            'Détermine le nouvel état par défaut d\'une demande après l\'ajout d\'une note dans l\'écran de fermeture de la demande de l\'interface agent.',
        'Defines the default next state of a ticket after adding a note, in the ticket free text screen of the agent interface.' =>
            'Détermine le nouvel état par défaut d\'une demande après l\'ajout d\'une note dans l\'écran de texte libre de la demande de l\'interface agent. ',
        'Defines the default next state of a ticket after adding a note, in the ticket note screen of the agent interface.' =>
            'Détermine le nouvel état par défaut d\'une demande après l\'ajout d\'une note dans l\'écran de notes de la demande de l\'interface agent.',
        'Defines the default next state of a ticket after adding a note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Détermine le nouvel état par défaut d\'une demande après l\'ajout d\'une note dans l\'écran du propriétaire de la synthèse de la demande de l\'interface agent.',
        'Defines the default next state of a ticket after adding a note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Détermine le nouvel état par défaut d\'une demande après l\'ajout d\'une note dans l\'écran de mise en attente de la synthèse de la demande de l\'interface agent.',
        'Defines the default next state of a ticket after adding a note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Détermine le nouvel état par défaut d\'une demande après l\'ajout d\'une note dans l\'écran de priorité de la synthèse de la demande de l\'interface agent.',
        'Defines the default next state of a ticket after adding a note, in the ticket responsible screen of the agent interface.' =>
            'Détermine le nouvel état par défaut d\'une demande après l\'ajout d\'une note dans l\'écran de responsabilité d\'une demande de l\'interface agent.',
        'Defines the default next state of a ticket after being bounced, in the ticket bounce screen of the agent interface.' =>
            'Détermine le nouvel état par défaut d\'une demande après qu\'elle a été retournée dans l\'écran de retour des demandes de l\'interface agent.',
        'Defines the default next state of a ticket after being forwarded, in the ticket forward screen of the agent interface.' =>
            'Détermine le nouvel état par défaut d\'une demande après avoir été transférée dans l\'écran de transfert des demandes de l\'interface agent. ',
        'Defines the default next state of a ticket after the message has been sent, in the email outbound screen of the agent interface.' =>
            '',
        'Defines the default next state of a ticket if it is composed / answered in the ticket compose screen of the agent interface.' =>
            'Détermine le nouvel état par défaut d\'une demande si elle a été rédigée ou répondue dans l\'écran de rédaction de l\'interface agent.',
        'Defines the default next state of a ticket, in the ticket bulk screen of the agent interface.' =>
            '',
        'Defines the default note body text for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            'Détermine le corps de texte par défaut d\'une note dans l\'écran des demandes téléphoniques entrantes dans l\'interface agent.',
        'Defines the default note body text for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            'Détermine le corps de texte par défaut d\'une note dans l\'écran des demandes téléphoniques sortantes dans l\'interface agent.',
        'Defines the default priority of follow-up customer tickets in the ticket zoom screen in the customer interface.' =>
            '',
        'Defines the default priority of new customer tickets in the customer interface.' =>
            'Détermine la priorité par défaut des demandes des nouveaux clients dans l\'interface client.',
        'Defines the default priority of new tickets.' => 'Détermine la priorité par défaut des nouvelles demandes.',
        'Defines the default queue for new customer tickets in the customer interface.' =>
            'Détermine la file par défaut des demandes des nouveaux clients dans l\'interface client.',
        'Defines the default queue for new tickets in the agent interface.' =>
            '',
        'Defines the default selection at the drop down menu for dynamic objects (Form: Common Specification).' =>
            'Détermine la sélection par défaut des menus déroulants des objects dynamiques (Forme : caractéristique commune).',
        'Defines the default selection at the drop down menu for permissions (Form: Common Specification).' =>
            'Détermine la sélection par défaut des menus déroulants des permissions (Forme : caractéristique commune).',
        'Defines the default selection at the drop down menu for stats format (Form: Common Specification). Please insert the format key (see Stats::Format).' =>
            'Détermine la sélection par défaut des menus déroulants des formats statistiques (Forme : caractéristique commune). Veuillez insérer la touche format (voir Stats::Format).',
        'Defines the default sender type for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            'Détermine le type d\'expéditeur par défaut des demandes dans l\'écran des demandes téléphoniques entrantes dans l\'interface agent.',
        'Defines the default sender type for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            'Détermine le type d\'expéditeur par défaut des demandes dans l\'écran des demandes téléphoniques sortantes dans l\'interface agent.',
        'Defines the default sender type for tickets in the ticket zoom screen of the customer interface.' =>
            'Détermine le type d\'expéditeur par défaut pour les demandes dans l\'écran de synthèse de la demande de l\'interface client.',
        'Defines the default shown ticket search attribute for ticket search screen (AllTickets/ArchivedTickets/NotArchivedTickets).' =>
            '',
        'Defines the default shown ticket search attribute for ticket search screen.' =>
            'Détermine l\'attribut de recherche de demandes affiché par défaut dans l\'écran de recherche.',
        'Defines the default shown ticket search attribute for ticket search screen. Example: "Key" must have the name of the Dynamic Field in this case \'X\', "Content" must have the value of the Dynamic Field depending on the Dynamic Field type,  Text: \'a text\', Dropdown: \'1\', Date/Time: \'Search_DynamicField_XTimeSlotStartYear=1974; Search_DynamicField_XTimeSlotStartMonth=01; Search_DynamicField_XTimeSlotStartDay=26; Search_DynamicField_XTimeSlotStartHour=00; Search_DynamicField_XTimeSlotStartMinute=00; Search_DynamicField_XTimeSlotStartSecond=00; Search_DynamicField_XTimeSlotStopYear=2013; Search_DynamicField_XTimeSlotStopMonth=01; Search_DynamicField_XTimeSlotStopDay=26; Search_DynamicField_XTimeSlotStopHour=23; Search_DynamicField_XTimeSlotStopMinute=59; Search_DynamicField_XTimeSlotStopSecond=59;\' and or \'Search_DynamicField_XTimePointFormat=week; Search_DynamicField_XTimePointStart=Before; Search_DynamicField_XTimePointValue=7\';.' =>
            '',
        'Defines the default sort criteria for all queues displayed in the queue view.' =>
            '',
        'Defines the default sort criteria for all services displayed in the service view.' =>
            '',
        'Defines the default sort order for all queues in the queue view, after priority sort.' =>
            'Détermine l\'ordre de tri par défaut pour toutes les files de la vue des files après le tri par priorité.',
        'Defines the default sort order for all services in the service view, after priority sort.' =>
            '',
        'Defines the default state of new customer tickets in the customer interface.' =>
            'Détermine l\'état par défaut des demandes des nouveaux clients dans l\'interface client.',
        'Defines the default state of new tickets.' => 'Détermine l\'état par défaut des nouvelles demandes.',
        'Defines the default subject for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            'Détermine l\'objet par défaut des demandes dans l\'écran des demandes téléphoniques entrantes de l\'interface agent.',
        'Defines the default subject for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            'Détermine l\'objet par défaut des demandes dans l\'écran des demandes téléphoniques sortantes de l\'interface agent.',
        'Defines the default subject of a note in the ticket free text screen of the agent interface.' =>
            'Détermine l\'objet par défaut des notes dans l\'écran de texte libre des demandes dans l\'interface agent.',
        'Defines the default the number of seconds (from current time) to re-schedule a generic interface failed task.' =>
            '',
        'Defines the default ticket attribute for ticket sorting in a ticket search of the customer interface.' =>
            'Détermine l\'attribut par défaut qui permet le tri des demandes dans l\'outil de recherche de demandes de l\'interface client.',
        'Defines the default ticket attribute for ticket sorting in the escalation view of the agent interface.' =>
            'Détermine l\'attribut par défaut qui permet le tri des demandes dans la vue des escalades de l\'interface agent.',
        'Defines the default ticket attribute for ticket sorting in the locked ticket view of the agent interface.' =>
            'Détermine l\'attribut par défaut qui permet le tri des demandes dans la vue des demandes fermées de l\'interface agent.',
        'Defines the default ticket attribute for ticket sorting in the responsible view of the agent interface.' =>
            'Détermine l\'attribut par défaut qui permet le tri des demandes dans la vue des responsables de l\'interface agent.',
        'Defines the default ticket attribute for ticket sorting in the status view of the agent interface.' =>
            'Détermine l\'attribut par défaut qui permet le tri des demandes dans la vue des états de l\'interface agent.',
        'Defines the default ticket attribute for ticket sorting in the watch view of the agent interface.' =>
            'Détermine l\'attribut par défaut qui permet le tri des demandes dans la vue des demandes sous surveillance de l\'interface agent.',
        'Defines the default ticket attribute for ticket sorting of the ticket search result of the agent interface.' =>
            'Détermine l\'attribut par défaut qui permet le tri des demandes dans les résultats de l\'outil de recherche des demandes de l\'interface agent.',
        'Defines the default ticket attribute for ticket sorting of the ticket search result of this operation.' =>
            '',
        'Defines the default ticket bounced notification for customer/sender in the ticket bounce screen of the agent interface.' =>
            'Détermine la notification de demande retournée par défaut pour le client ou l\'expéditeur dans l\'écran de retour des demandes de l\'interface agent.',
        'Defines the default ticket next state after adding a phone note in the ticket phone inbound screen of the agent interface.' =>
            'Détermine le nouvel état par défaut de la demande après qu\'une note téléphonique est ajoutée dans l\'écran des demandes téléphoniques entrantes de l\'interface agent.',
        'Defines the default ticket next state after adding a phone note in the ticket phone outbound screen of the agent interface.' =>
            'Détermine le nouvel état par défaut de la demande après qu\'une note téléphonique est ajoutée dans l\'écran des demandes téléphoniques sortantes de l\'interface agent.',
        'Defines the default ticket order (after priority sort) in the escalation view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Détermine l\'ordre par défaut des demandes après le tri par priorité dans la vue des escalades de l\'interface agent. « Chronologique croissant » : la plus ancienne en haut de la liste et « Chronologique décroissant » : la plus récente en haut de la liste.',
        'Defines the default ticket order (after priority sort) in the status view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Détermine l\'ordre par défaut des demandes après le tri par priorité dans la vue des états des demandes de l\'interface agent. « Chronologique croissant » : la plus ancienne en haut de la liste et « Chronologique décroissant » : la plus récente en haut de la liste.',
        'Defines the default ticket order in the responsible view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Détermine l\'ordre par défaut des demandes dans la vue des responsables de l\'interface agent. « Chronologique croissant » : la plus ancienne en haut de la liste et « Chronologique décroissant » : la plus récente en haut de la liste.',
        'Defines the default ticket order in the ticket locked view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Détermine l\'ordre par défaut des demandes dans la vue de fermeture des demandes de l\'interface agent. « Chronologique croissant » : la plus ancienne en haut de la liste et « Chronologique décroissant » : la plus récente en haut de la liste.',
        'Defines the default ticket order in the ticket search result of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Détermine l\'ordre par défaut des demandes dans les résultats de recherche de demandes de l\'interface agent. « Chronologique croissant » : la plus ancienne en haut de la liste et « Chronologique décroissant » : la plus récente en haut de la liste.',
        'Defines the default ticket order in the ticket search result of the this operation. Up: oldest on top. Down: latest on top.' =>
            '',
        'Defines the default ticket order in the watch view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Détermine l\'ordre par défaut des demandes dans la vue des demandes surveillées de l\'interface agent. « Chronologique croissant » : la plus ancienne en haut de la liste et « Chronologique décroissant » : la plus récente en haut de la liste.',
        'Defines the default ticket order of a search result in the customer interface. Up: oldest on top. Down: latest on top.' =>
            'Détermine l\'ordre par défaut des demandes des résultats de recherche de l\'interface client. « Chronologique croissant » : la plus ancienne en haut de la liste et « Chronologique décroissant » : la plus récente en haut de la liste.',
        'Defines the default ticket priority in the close ticket screen of the agent interface.' =>
            'Détermine la priorité par défaut des demandes dans l\'écran de fermeture de la demande de l\'interface agent.',
        'Defines the default ticket priority in the ticket bulk screen of the agent interface.' =>
            'Détermine la priorité par défaut de la demande dans l\'écran de demandes groupées de l\'interface agent.',
        'Defines the default ticket priority in the ticket free text screen of the agent interface.' =>
            'Détermine la priorité par défaut de la demande dans son écran de texte libre de l\'interface agent.',
        'Defines the default ticket priority in the ticket note screen of the agent interface.' =>
            'Détermine la priorité par défaut de la demande dans son écran de notes de l\'interface agent.',
        'Defines the default ticket priority in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Détermine la priorité par défaut de la demande dans l\'écran du propriétaire de la synthèse de la demande dans l\'interface agent.',
        'Defines the default ticket priority in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Détermine la priorité par défaut de la demande dans l\'écran de mise en attente de la synthèse de la demande dans l\'interface agent.',
        'Defines the default ticket priority in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Détermine la priorité par défaut de la demande dans l\'écran de priorité de la synthèse de la demande dans l\'interface agent.',
        'Defines the default ticket priority in the ticket responsible screen of the agent interface.' =>
            'Détermine la priorité par défaut de la demande dans l\'écran du responsable dans l\'interface agent.',
        'Defines the default ticket type for new customer tickets in the customer interface.' =>
            '',
        'Defines the default ticket type.' => '',
        'Defines the default used Frontend-Module if no Action parameter given in the url on the agent interface.' =>
            'Détermine le module d\'avant-plan utilisé par défaut en l\'absence d\'un paramètre d\'action dans l\'adresse url de l\'interface agent.',
        'Defines the default used Frontend-Module if no Action parameter given in the url on the customer interface.' =>
            'Détermine le module d\'avant-plan utilisé par défaut en l\'absence d\'un paramètre d\'action dans l\'adresse url de l\'interface client.',
        'Defines the default value for the action parameter for the public frontend. The action parameter is used in the scripts of the system.' =>
            'Détermine la valeur par défaut du paramètre d\'action pour l\'avant-plan public. Le paramètre d\'action est utilisé dans les scripts du système.',
        'Defines the default viewable sender types of a ticket (default: customer).' =>
            'Détermine les types d\'expéditeur visibles par défaut pour une demande (par défaut : le client).',
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
            'Détermine le filtre qui traite le texte dans les articles afin de mettre en surbrillance les adresses URL.',
        'Defines the format of responses in the ticket compose screen of the agent interface ([% Data.OrigFrom | html %] is From 1:1, [% Data.OrigFromName | html %] is only realname of From).' =>
            '',
        'Defines the fully qualified domain name of the system. This setting is used as a variable, OTRS_CONFIG_FQDN which is found in all forms of messaging used by the application, to build links to the tickets within your system.' =>
            'Détermine le nom de domaine complet du système. Le réglage est utilisé en tant que variable, OTRS_CONFIG_FQDN est trouvé sous toutes les formes de message utilisé par l\'application afin de créer des liens vers les demandes dans votre système.',
        'Defines the groups every customer user will be in (if CustomerGroupSupport is enabled and you don\'t want to manage every customer user for these groups).' =>
            '',
        'Defines the groups every customer will be in (if CustomerGroupSupport is enabled and you don\'t want to manage every customer for these groups).' =>
            '',
        'Defines the height for the rich text editor component for this screen. Enter number (pixels) or percent value (relative).' =>
            '',
        'Defines the height for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            'Détermine la hauteur de l\'élément de l\'éditeur RTF. Entrez un nombre de pixels ou un pourcentage relatif.',
        'Defines the history comment for the close ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Détermine le commentaire de l\'historique pour l\'action de l\'écran de fermeture de la demande de l\'interface agent.',
        'Defines the history comment for the email ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Détermine le commentaire de l\'historique pour l\'action de l\'écran de demande par courriel de l\'interface agent.',
        'Defines the history comment for the phone ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Détermine le commentaire de l\'historique pour l\'action de l\'écran des demandes téléphoniques de l\'interface agent.',
        'Defines the history comment for the ticket free text screen action, which gets used for ticket history.' =>
            'Détermine le commentaire de l\'historique pour l\'action de l\'écran de texte libre de la demande.',
        'Defines the history comment for the ticket note screen action, which gets used for ticket history in the agent interface.' =>
            'Détermine le commentaire de l\'historique pour l\'action de l\'écran de notes de la demande de l\'interface agent.',
        'Defines the history comment for the ticket owner screen action, which gets used for ticket history in the agent interface.' =>
            'Détermine le commentaire de l\'historique pour l\'action de l\'écran du propriétaire de la demande de l\'interface agent.',
        'Defines the history comment for the ticket pending screen action, which gets used for ticket history in the agent interface.' =>
            'Détermine le commentaire de l\'historique pour l\'action de l\'écran de la mise en attente de la demande de l\'interface agent.',
        'Defines the history comment for the ticket phone inbound screen action, which gets used for ticket history in the agent interface.' =>
            'Détermine le commentaire de l\'historique pour l\'action de l\'écran des demandes téléphoniques entrantes de l\'interface agent.',
        'Defines the history comment for the ticket phone outbound screen action, which gets used for ticket history in the agent interface.' =>
            'Détermine le commentaire de l\'historique pour l\'action de l\'écran des demandes téléphoniques sortantes de l\'interface agent.',
        'Defines the history comment for the ticket priority screen action, which gets used for ticket history in the agent interface.' =>
            'Détermine le commentaire de l\'historique pour l\'action de l\'écran de priorité de la demande de l\'interface agent.',
        'Defines the history comment for the ticket responsible screen action, which gets used for ticket history in the agent interface.' =>
            'Détermine le commentaire de l\'historique pour l\'action de l\'écran du responsable de la demande de l\'interface agent.',
        'Defines the history comment for the ticket zoom action, which gets used for ticket history in the customer interface.' =>
            'Détermine le commentaire de l\'historique pour l\'action de synthèse de la demande de l\'interface client.',
        'Defines the history comment for this operation, which gets used for ticket history in the agent interface.' =>
            'Détermine le commentaire de l\'historique pour cette opération qui sera utilisé dans l\'historique de l\'interface agent.',
        'Defines the history type for the close ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Détermine le type d\'historique pour l\'action de l\'écran de fermeture de la demande de l\'interface agent.',
        'Defines the history type for the email ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Détermine le type d\'historique pour l\'action de l\'écran de demande par courriel de l\'interface agent.',
        'Defines the history type for the phone ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Détermine le type d\'historique pour l\'action de l\'écran des demandes téléphoniques de l\'interface agent.',
        'Defines the history type for the ticket free text screen action, which gets used for ticket history.' =>
            'Détermine le type d\'historique pour l\'action de l\'écran de texte libre de la demande.',
        'Defines the history type for the ticket note screen action, which gets used for ticket history in the agent interface.' =>
            'Détermine le type d\'historique pour l\'action de l\'écran de notes de la demande de l\'interface agent.',
        'Defines the history type for the ticket owner screen action, which gets used for ticket history in the agent interface.' =>
            'Détermine le type d\'historique pour l\'action de l\'écran du propriétaire de la demande de l\'interface agent.',
        'Defines the history type for the ticket pending screen action, which gets used for ticket history in the agent interface.' =>
            'Détermine le type d\'historique pour l\'action de l\'écran de mise en attente de la demande de l\'interface agent.',
        'Defines the history type for the ticket phone inbound screen action, which gets used for ticket history in the agent interface.' =>
            'Détermine le type d\'historique pour l\'action de l\'écran des demandes téléphoniques entrantes de l\'interface agent.',
        'Defines the history type for the ticket phone outbound screen action, which gets used for ticket history in the agent interface.' =>
            'Détermine le type d\'historique pour l\'action de l\'écran des demandes téléphoniques sortantes de l\'interface agent.',
        'Defines the history type for the ticket priority screen action, which gets used for ticket history in the agent interface.' =>
            'Détermine le type d\'historique pour l\'action de l\'écran de priorité de la demande de l\'interface agent.',
        'Defines the history type for the ticket responsible screen action, which gets used for ticket history in the agent interface.' =>
            'Détermine le type d\'historique pour l\'action de l\'écran de responsabilité de la demande de l\'interface agent.',
        'Defines the history type for the ticket zoom action, which gets used for ticket history in the customer interface.' =>
            'Détermine le type d\'historique pour l\'action de synthèse de la demande de l\'interface client.',
        'Defines the history type for this operation, which gets used for ticket history in the agent interface.' =>
            'Détermine le type d\'historique pour cette opération dans l\'interface client.',
        'Defines the hours and week days of the indicated calendar, to count the working time.' =>
            'Détermine les heures et les jours de la semaine du calendrier indiqué afin de calculer le temps de travail.',
        'Defines the hours and week days to count the working time.' => 'Détermine les heures et les jours de la semaine afin de calculer le temps de travail.',
        'Defines the key to be checked with Kernel::Modules::AgentInfo module. If this user preferences key is true, the message is accepted by the system.' =>
            'Détermine la clé à vérifier dans le module « Kernel::Modules::AgentInfo ». Si la clé des préférences de l\'utilisateur est positive, le message est accepté par le système.',
        'Defines the key to check with CustomerAccept. If this user preferences key is true, then the message is accepted by the system.' =>
            'Détermine la clé à vérifier avec le module d\'acceptation du client (CustomerAccept). Si cette clé des préférences de l\'utilisateur est positive, le message est accepté par le système.',
        'Defines the link type \'Normal\'. If the source name and the target name contain the same value, the resulting link is a non-directional one; otherwise, the result is a directional link.' =>
            'Détermine le lien de type « Normal ». Si le nom source et le nom cible sont les mêmes, le lien est bidirectionnel, autrement, il est unidirectionnel.',
        'Defines the link type \'ParentChild\'. If the source name and the target name contain the same value, the resulting link is a non-directional one; otherwise, the result is a directional link.' =>
            'Détermine le lien de type «ParentChild » (parent enfant). Si le nom source et le nom cible sont les mêmes, le lien est bidirectionnel, autrement, il est unidirectionnel.',
        'Defines the link type groups. The link types of the same group cancel one another. Example: If ticket A is linked per a \'Normal\' link with ticket B, then these tickets could not be additionally linked with link of a \'ParentChild\' relationship.' =>
            'Détermine le type de lien des groupes. Le type de lien entre les membres d\'un même groupe détermine le type de lien du groupe. Par exemple, si la demande A est liée à la demande B par un lien « Normal », ces demandes ne pourront en plus être liés par un lien de type « ParentChild » (parent enfant). ',
        'Defines the list of online repositories. Another installations can be used as repository, for example: Key="http://example.com/otrs/public.pl?Action=PublicRepository;File=" and Content="Some Name".' =>
            'Détermine la liste des référentiels en ligne. Une autre installation pourrait servir de référentiel, par exemple, clé=« http://exemple.com/otrs/public.pl?Action=Référentielpublic;Fichier= » et Contenu=« Nom ».',
        'Defines the list of params that can be passed to ticket search function.' =>
            '',
        'Defines the list of possible next actions on an error screen, a full path is required, then is possible to add external links if needed.' =>
            '',
        'Defines the list of types for templates.' => '',
        'Defines the location to get online repository list for additional packages. The first available result will be used.' =>
            'Détermine l\'emplacement Web de la liste des référentiels d\'installation de paquets supplémentaires. Le premier résultat affiché sera utilisé.',
        'Defines the log module for the system. "File" writes all messages in a given logfile, "SysLog" uses the syslog daemon of the system, e.g. syslogd.' =>
            'Détermine le module de journalisation du système. L\'option « Fichier » écrit tous les messages dans un journal donné, l\'option « Journal du système » utilise le programme démon, par exemple, le syslogd.',
        'Defines the maximal size (in bytes) for file uploads via the browser. Warning: Setting this option to a value which is too low could cause many masks in your OTRS instance to stop working (probably any mask which takes input from the user).' =>
            '',
        'Defines the maximal valid time (in seconds) for a session id.' =>
            'Détermine le temps maximal (en secondes) d\'une identification de session.',
        'Defines the maximum number of affected tickets per job.' => '',
        'Defines the maximum number of pages per PDF file.' => 'Détermine le nombre de pages maximal des fichiers PDF.',
        'Defines the maximum number of quoted lines to be added to responses.' =>
            '',
        'Defines the maximum number of tasks to be executed as the same time.' =>
            '',
        'Defines the maximum size (in MB) of the log file.' => 'Précise la taille maximale (en Mo) du fichier d\'enregistrement.',
        'Defines the maximum size in KiloByte of GenericInterface responses that get logged to the gi_debugger_entry_content table.' =>
            '',
        'Defines the module that shows a generic notification in the agent interface. Either "Text" - if configured - or the contents of "File" will be displayed.' =>
            'Détermine le module qui présente une notification générique dans l\'interface agent. Le champ « texte », si configuré comme tel, ou le contenu d\'un « fichier » sera affiché. ',
        'Defines the module that shows all the currently logged in agents in the agent interface.' =>
            'Détermine le module qui présente tous les agents connectés dans l\'interface agent.',
        'Defines the module that shows all the currently logged in customers in the agent interface.' =>
            '',
        'Defines the module that shows the currently logged in agents in the customer interface.' =>
            '',
        'Defines the module that shows the currently logged in customers in the customer interface.' =>
            '',
        'Defines the module to authenticate customers.' => 'Détermine le module d\'authentification des clients.',
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
            'Détermine le module d\'affichage de notifications de l\'interface agent lorsque l\'agent est connecté et que son indicateur d\'absence est activé.',
        'Defines the module to display a notification in the agent interface, if the agent is logged in while having system maintenance active.' =>
            '',
        'Defines the module to display a notification in the agent interface, if the agent session limit prior warning is reached.' =>
            '',
        'Defines the module to display a notification in the agent interface, if the installation of not verified packages is activated (only shown to admins).' =>
            '',
        'Defines the module to display a notification in the agent interface, if the system is used by the admin user (normally you shouldn\'t work as admin).' =>
            'Détermine le module d\'affichage de notifications de l\'interface agent lorsque le système est utilisé par l\'administrateur (Vous ne devriez normalement pas travailler connecté en tant qu\'administrateur).',
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
            'Détermine le module utilisé pour stocker les données de la session. L\'option « DB » permet de scinder le serveur d\'avant-plan du serveur de base de données. L\'option « FS » est plus rapide.',
        'Defines the name of the application, shown in the web interface, tabs and title bar of the web browser.' =>
            'Détermine le nom de l\'application présentée dans l\'interface Web et celui des onglets et des barres de titres du navigateur Web.',
        'Defines the name of the column to store the data in the preferences table.' =>
            'Détermine le nom de la colonne de la table des préférences où les données seront enregistrées.',
        'Defines the name of the column to store the user identifier in the preferences table.' =>
            'Détermine le nom de la colonne de la table des préférences où les identifiants des utilisateurs seront enregistrés.',
        'Defines the name of the indicated calendar.' => 'Détermine le nom du calendrier spécifié.',
        'Defines the name of the key for customer sessions.' => 'Détermine le nom de la clé des sessions client.',
        'Defines the name of the session key. E.g. Session, SessionID or OTRS.' =>
            'Détermine le nom de la clé de session, par exemple, Session, SessionID ou OTRS.',
        'Defines the name of the table where the user preferences are stored.' =>
            '',
        'Defines the next possible states after composing / answering a ticket in the ticket compose screen of the agent interface.' =>
            'Détermine les nouveaux états possibles après avoir rédigé une demande ou y avoir répondu dans l\'écran de rédaction de l\'interface agent.',
        'Defines the next possible states after forwarding a ticket in the ticket forward screen of the agent interface.' =>
            'Détermine les nouveaux états possibles après avoir transféré une demande dans l\'écran de transfert de demande de l\'interface agent.',
        'Defines the next possible states after sending a message in the email outbound screen of the agent interface.' =>
            '',
        'Defines the next possible states for customer tickets in the customer interface.' =>
            'Détermine les nouveaux états possibles des demandes du client dans l\'interface client.',
        'Defines the next state of a ticket after adding a note, in the close ticket screen of the agent interface.' =>
            'Détermine le nouvel état d\'une demande après avoir ajouté une note dans l\'écran de fermeture de la demande de l\'interface agent.',
        'Defines the next state of a ticket after adding a note, in the ticket free text screen of the agent interface.' =>
            'Détermine le nouvel état d\'une demande après avoir ajouté une note dans l\'écran de texte libre de l\'interface agent.',
        'Defines the next state of a ticket after adding a note, in the ticket note screen of the agent interface.' =>
            'Détermine le nouvel état d\'une demande après avoir ajouté une note dans l\'écran de notes de l\'interface agent.',
        'Defines the next state of a ticket after adding a note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Détermine le nouvel état d\'une demande après avoir ajouté une note dans l\'écran de propriété de la synthèse de la demande de l\'interface agent.',
        'Defines the next state of a ticket after adding a note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Détermine le nouvel état d\'une demande après avoir ajouté une note dans l\'écran de mise en attente de la synthèse de la demande de l\'interface agent.',
        'Defines the next state of a ticket after adding a note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Détermine le nouvel état d\'une demande après avoir ajouté une note dans l\'écran de priorité de la synthèse de la demande de l\'interface agent.',
        'Defines the next state of a ticket after adding a note, in the ticket responsible screen of the agent interface.' =>
            'Détermine le nouvel état d\'une demande dans l\'écran du responsable de la demande de l\'interface agent à la suite de l\'ajout d\'une note.',
        'Defines the next state of a ticket after being bounced, in the ticket bounce screen of the agent interface.' =>
            'Détermine le nouvel état d\'une demande dans l\'écran de retour des demandes de l\'interface agent à la suite d\'un retour.',
        'Defines the next state of a ticket after being moved to another queue, in the move ticket screen of the agent interface.' =>
            'Détermine le nouvel état d\'une demande dans l\'écran de déplacement des demandes de l\'interface agent à la suite de son déplacement dans une autre file.',
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
        'Defines the parameters for the customer preferences table.' => 'Détermine les paramètres de la table comprenant les préférences du client.',
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
            'Détermine le mot de passe pour accéder au descripteur du protocole SOAP (bin/cgi-bin/rpc.pl).',
        'Defines the path and TTF-File to handle bold italic monospaced font in PDF documents.' =>
            'Détermine le chemin et le fichier TTF pour traiter la police à espacement constant en italique et en gras dans les documents PDF.',
        'Defines the path and TTF-File to handle bold italic proportional font in PDF documents.' =>
            'Détermine le chemin et le fichier TTF pour traiter la police proportionnelle en italique et en gras dans les documents PDF.',
        'Defines the path and TTF-File to handle bold monospaced font in PDF documents.' =>
            'Détermine le chemin et le fichier TTF pour traiter la police à espacement constant en gras dans les documents PDF.',
        'Defines the path and TTF-File to handle bold proportional font in PDF documents.' =>
            'Détermine le chemin et le fichier TTF pour traiter la police proportionnelle en gras dans les documents PDF.',
        'Defines the path and TTF-File to handle italic monospaced font in PDF documents.' =>
            'Détermine le chemin et le fichier TTF pour traiter la police à espacement constant en italique dans les documents PDF.',
        'Defines the path and TTF-File to handle italic proportional font in PDF documents.' =>
            'Détermine le chemin et le fichier TTF pour traiter la police proportionnelle en italique dans les documents PDF.',
        'Defines the path and TTF-File to handle monospaced font in PDF documents.' =>
            'Détermine le chemin et le fichier TTF pour traiter la police à espacement constant dans les documents PDF.',
        'Defines the path and TTF-File to handle proportional font in PDF documents.' =>
            'Détermine le chemin et le fichier TTF pour traiter la police proportionnelle dans les documents PDF.',
        'Defines the path of the shown info file, that is located under Kernel/Output/HTML/Templates/Standard/CustomerAccept.tt.' =>
            '',
        'Defines the path to PGP binary.' => 'Détermine le chemin vers le code binaire du logiciel PGP.',
        'Defines the path to open ssl binary. It may need a HOME env ($ENV{HOME} = \'/var/lib/wwwrun\';).' =>
            'Détermine le chemin vers le code binaire du protocole ouvert ssl. Une variable d\'environnement HOME peut être nécessaire ($ENV{HOME} = \'/var/lib/wwwrun\';).',
        'Defines the period of time (in minutes) before agent is marked as "away" due to inactivity (e.g. in the "Logged-In Users" widget or for the chat).' =>
            '',
        'Defines the period of time (in minutes) before customer is marked as "away" due to inactivity (e.g. in the "Logged-In Users" widget or for the chat).' =>
            '',
        'Defines the postmaster default queue.' => 'Détermine la file par défaut du maître de poste.',
        'Defines the priority in which the information is logged and presented.' =>
            '',
        'Defines the recipient target of the phone ticket and the sender of the email ticket ("Queue" shows all queues, "System address" displays all system addresses) in the agent interface.' =>
            '',
        'Defines the recipient target of the tickets ("Queue" shows all queues, "SystemAddress" shows only the queues which are assigned to system addresses) in the customer interface.' =>
            '',
        'Defines the required permission to show a ticket in the escalation view of the agent interface.' =>
            'Détermine la permission requise pour afficher une demande dans la vue de l\'escalade de l\'interface agent.',
        'Defines the search limit for the stats.' => 'Détermine la limite de recherche pour les statistiques.',
        'Defines the search parameters for the AgentCustomerUserAddressBook screen. With the setting \'CustomerTicketTextField\' the values for the recipient field can be specified.' =>
            '',
        'Defines the sender for rejected emails.' => 'Détermine l\'expéditeur des courriels rejetés.',
        'Defines the separator between the agents real name and the given queue email address.' =>
            'Détermine le séparateur entre les noms réels des agents et l\'adresse électronique attribuée à une file.',
        'Defines the shown columns and the position in the AgentCustomerUserAddressBook result screen.' =>
            '',
        'Defines the shown links in the footer area of the customer and public interface of this OTRS system. The value in "Key" is the external URL, the value in "Content" is the shown label.' =>
            '',
        'Defines the standard permissions available for customers within the application. If more permissions are needed, you can enter them here. Permissions must be hard coded to be effective. Please ensure, when adding any of the afore mentioned permissions, that the "rw" permission remains the last entry.' =>
            'Détermine les permissions standards accessibles aux clients au sein de l\'application. Au besoin, vous pouvez inscrire des permissions supplémentaires. Celles-ci doivent être figées dans le code pour être efficaces. Assurez-vous que la permission « rw » (lecture et écriture) soit la dernière entrée inscrite après avoir ajouté les permissions susmentionnées.',
        'Defines the standard size of PDF pages.' => 'Détermine la taille standard des pages en format PDF.',
        'Defines the state of a ticket if it gets a follow-up and the ticket was already closed.' =>
            'Détermine l\'état d\'une demande déjà fermée qui fait l\'objet d\'un suivi.',
        'Defines the state of a ticket if it gets a follow-up.' => 'Détermine l\'état d\'une demande qui fait l\'objet d\'un suivi.',
        'Defines the state type of the reminder for pending tickets.' => 'Détermine le type d\'état du rappel des demandes en attente.',
        'Defines the subject for notification mails sent to agents, about new password.' =>
            'Détermine le sujet des notifications envoyées aux agents pour un nouveau mot de passe.',
        'Defines the subject for notification mails sent to agents, with token about new requested password.' =>
            'Détermine le sujet des notifications envoyées aux agents avec un jeton d\'authentification pour une nouvelle demande de mot de passe.',
        'Defines the subject for notification mails sent to customers, about new account.' =>
            'Détermine le sujet des notifications envoyées aux clients pour un nouveau compte d\'accès.',
        'Defines the subject for notification mails sent to customers, about new password.' =>
            'Détermine le sujet des notifications envoyées aux clients pour un nouveau mot de passe.',
        'Defines the subject for notification mails sent to customers, with token about new requested password.' =>
            'Détermine le sujet des notifications envoyées aux clients avec un jeton d\'authentification pour une nouvelle demande de mot de passe.',
        'Defines the subject for rejected emails.' => 'Détermine le sujet des courriels rejetés.',
        'Defines the system administrator\'s email address. It will be displayed in the error screens of the application.' =>
            'Détermine l\'adresse de courrier électronique de l\'administrateur du système. Elle sera affichée dans les écrans d\'erreur de l\'application. ',
        'Defines the system identifier. Every ticket number and http session string contains this ID. This ensures that only tickets which belong to your system will be processed as follow-ups (useful when communicating between two instances of OTRS).' =>
            '',
        'Defines the target attribute in the link to external customer database. E.g. \'AsPopup PopupType_TicketAction\'.' =>
            '',
        'Defines the target attribute in the link to external customer database. E.g. \'target="cdb"\'.' =>
            'Détermine l\'attribut cible dans le lien vers la base de données externe du client (p.ex. \'target="cdb"\').',
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
            'Détermine la période de temps du calendrier indiqué, qui pourra par la suite être attribué à une file précise.',
        'Defines the timeout (in seconds, minimum is 20 seconds) for the support data collection with the public module \'PublicSupportDataCollector\' (e.g. used from the OTRS Daemon).' =>
            '',
        'Defines the two-factor module to authenticate agents.' => '',
        'Defines the two-factor module to authenticate customers.' => '',
        'Defines the type of protocol, used by the web server, to serve the application. If https protocol will be used instead of plain http, it must be specified here. Since this has no affect on the web server\'s settings or behavior, it will not change the method of access to the application and, if it is wrong, it will not prevent you from logging into the application. This setting is only used as a variable, OTRS_CONFIG_HttpType which is found in all forms of messaging used by the application, to build links to the tickets within your system.' =>
            '',
        'Defines the used character for plaintext email quotes in the ticket compose screen of the agent interface. If this is empty or inactive, original emails will not be quoted but appended to the response.' =>
            '',
        'Defines the user identifier for the customer panel.' => 'Détermine l\'identifiant de l\'utilisateur dans la page du client.',
        'Defines the username to access the SOAP handle (bin/cgi-bin/rpc.pl).' =>
            'Détermine le nom d\'utilisateur qui permet l\'accès au descripteur du protocle SOAP (bin/cgi-bin/rpc.pl).',
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
            'Détermine la chasse des éléments de l\'éditeur RTF. Indiquez le nombre de pixels ou la valeur relative en pourcentage.',
        'Defines time in minutes since last modification for drafts of specified type before they are considered expired.' =>
            '',
        'Defines whether to index archived tickets for fulltext searches.' =>
            '',
        'Defines which article sender types should be shown in the preview of a ticket.' =>
            'Détermine quels types d\'envoi d\'article devraient être affichés dans l\'aperçu de la demande.',
        'Defines which items are available for \'Action\' in third level of the ACL structure.' =>
            '',
        'Defines which items are available in first level of the ACL structure.' =>
            '',
        'Defines which items are available in second level of the ACL structure.' =>
            '',
        'Defines which states should be set automatically (Content), after the pending time of state (Key) has been reached.' =>
            'Détermine quels états doivent être programmés systématiquement (Contenu) après que le délai d\'attente de l\'état (Clé) a été atteint.',
        'Defines, which tickets of which ticket state types should not be listed in linked ticket lists.' =>
            '',
        'Delete expired cache from core modules.' => '',
        'Delete expired loader cache weekly (Sunday mornings).' => '',
        'Delete expired sessions.' => '',
        'Delete expired ticket draft entries.' => '',
        'Delete expired upload cache hourly.' => '',
        'Delete this ticket' => 'Effacer cette demande',
        'Deleted link to ticket "%s".' => 'Suppression du lien vers la demande "%s".',
        'Deletes a session if the session id is used with an invalid remote IP address.' =>
            'Supprime une session si l\'identification de session est utilisée avec une adresse IP distante non valide.',
        'Deletes requested sessions if they have timed out.' => 'Supprime les sessions demandées si elles sont expirées.',
        'Delivers extended debugging information in the frontend in case any AJAX errors occur, if enabled.' =>
            '',
        'Deploy and manage OTRS Business Solution™.' => '',
        'Detached' => '',
        'Determines if a button to delete a link should be displayed next to each link in each zoom mask.' =>
            '',
        'Determines if the list of possible queues to move to ticket into should be displayed in a dropdown list or in a new window in the agent interface. If "New Window" is set you can add a move note to the ticket.' =>
            'Détermine si la liste des files dans lesquelles il est possible de déplacer des demandes devrait être présentée sous forme de menu déroulant ou dans une nouvelle fenêtre dans l\'interface de l\'agent. Si l\'option « nouvelle fenêtre » est en fonction, vous pouvez ajouter une note à la demande.',
        'Determines if the statistics module may generate ticket lists.' =>
            'Détermine si le module statistique peut générer des listes de demandes.',
        'Determines the next possible ticket states, after the creation of a new email ticket in the agent interface.' =>
            'Détermine les nouveaux états de la demande après la création d\'une demande par courriel dans l\'interface agent.',
        'Determines the next possible ticket states, after the creation of a new phone ticket in the agent interface.' =>
            'Détermine les nouveaux états de la demande après la création d\'une demande téléphonique dans l\'interface agent.',
        'Determines the next possible ticket states, for process tickets in the agent interface.' =>
            '',
        'Determines the next possible ticket states, for process tickets in the customer interface.' =>
            '',
        'Determines the next screen after new customer ticket in the customer interface.' =>
            'Détermine l\'écran suivant une nouvelle demande du client dans l\'interface client.',
        'Determines the next screen after the follow-up screen of a zoomed ticket in the customer interface.' =>
            '',
        'Determines the next screen after the ticket is moved. LastScreenOverview will return the last overview screen (e.g. search results, queueview, dashboard). TicketZoom will return to the TicketZoom.' =>
            '',
        'Determines the possible states for pending tickets that changed state after reaching time limit.' =>
            'Détermine les états possibles pour les demandes en attente qui ont changé d\'état après avoir atteint leur délai d\'attente.',
        'Determines the strings that will be shown as recipient (To:) of the phone ticket and as sender (From:) of the email ticket in the agent interface. For Queue as NewQueueSelectionType "<Queue>" shows the names of the queues and for SystemAddress "<Realname> <<Email>>" shows the name and email of the recipient.' =>
            '',
        'Determines the strings that will be shown as recipient (To:) of the ticket in the customer interface. For Queue as CustomerPanelSelectionType, "<Queue>" shows the names of the queues, and for SystemAddress, "<Realname> <<Email>>" shows the name and email of the recipient.' =>
            '',
        'Determines the way the linked objects are displayed in each zoom mask.' =>
            'Détermine la manière dont les objets liés sont affichés dans chaque masque.',
        'Determines which options will be valid of the recipient (phone ticket) and the sender (email ticket) in the agent interface.' =>
            '',
        'Determines which queues will be valid for ticket\'s recepients in the customer interface.' =>
            'Détermine quelles files seront admissibles pour les destinaires des demandes dans l\'interface client.',
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
            'Affiche le temps alloué à un article dans la synthèse de la demande.',
        'Displays the number of all tickets with the same CustomerID as current ticket in the ticket zoom view.' =>
            '',
        'Down' => 'Chronologique décroissant',
        'Dropdown' => 'Menu déroulant',
        'Dutch' => '',
        'Dutch stop words for fulltext index. These words will be removed from the search index.' =>
            '',
        'Dynamic Fields Checkbox Backend GUI' => 'IUG de l\'arrière-plan pour les case à cocher ',
        'Dynamic Fields Date Time Backend GUI' => 'IUG de l\'arrière-plan pour les champs dynamiques « Date » et « Heure »',
        'Dynamic Fields Drop-down Backend GUI' => 'IUG de l\'arrière-plan pour les menus déroulants',
        'Dynamic Fields GUI' => 'IUG des champs dynamiques',
        'Dynamic Fields Multiselect Backend GUI' => 'IUG de l\'arrière-plan pour les champs « multi-choix »',
        'Dynamic Fields Overview Limit' => 'Nombre de champs dynamiques par page ',
        'Dynamic Fields Text Backend GUI' => 'IUG de l\'arrière-plan pour les champs « texte »',
        'Dynamic Fields used to export the search result in CSV format.' =>
            'Champs dynamiques utilisés pour exporter les résultats de recherche en format CSV.',
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
        'DynamicField backend registration.' => 'Enregistrement des champs dynamiques (DynamicField) dans l\'arrière-plan.',
        'DynamicField object registration.' => 'Enregistrement de l\'objet « Champ dynamique » (DynamicField).',
        'DynamicField_%s' => '',
        'E-Mail Outbound' => 'Courriel sortant',
        'Edit Customer Companies.' => '',
        'Edit Customer Users.' => '',
        'Edit appointment' => '',
        'Edit customer company' => '',
        'Email Addresses' => 'Adresses de courrier électronique',
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
        'Enables S/MIME support.' => 'Permet la gestion des certificats S/MIME.',
        'Enables customers to create their own accounts.' => 'Permet aux clients de créer leur propre compte.',
        'Enables fetch S/MIME from CustomerUser backend support.' => '',
        'Enables file upload in the package manager frontend.' => 'Permet le téléchargement de fichiers dans l\'avant-plan du gestionnaire de paquets.',
        'Enables or disables the caching for templates. WARNING: Do NOT disable template caching for production environments for it will cause a massive performance drop! This setting should only be disabled for debugging reasons!' =>
            '',
        'Enables or disables the debug mode over frontend interface.' => '',
        'Enables or disables the ticket watcher feature, to keep track of tickets without being the owner nor the responsible.' =>
            'Active ou désactive la fonction de surveillance de demandes qui permet à un agent de suivre une demande sans en être le propriétaire ni le responsable.',
        'Enables performance log (to log the page response time). It will affect the system performance. Frontend::Module###AdminPerformanceLog must be enabled.' =>
            'Permet l\'enregistrement des performances (pour enregistrer les temps de réponse). Cela perturbera le rendement du système. Vous devez activer le Frontend::Module###AdminPerformanceLog.',
        'Enables the minimal ticket counter size (if "Date" was selected as TicketNumberGenerator).' =>
            '',
        'Enables ticket bulk action feature for the agent frontend to work on more than one ticket at a time.' =>
            'Active la fonction d\'action groupée des demandes pour que l\'avant-plan de l\'agent puisse travailler sur plus d\'une demande à la fois.',
        'Enables ticket bulk action feature only for the listed groups.' =>
            'Active la fonction d\'action groupée des demandes pour les groupes en liste.',
        'Enables ticket responsible feature, to keep track of a specific ticket.' =>
            'Active la fonction de responsabilité d\'une demande afin de pouvoir suivre une demande précise.',
        'Enables ticket type feature.' => '',
        'Enables ticket watcher feature only for the listed groups.' => 'Active la fonction de surveillance de demandes pour les groupes en liste.',
        'English (Canada)' => '',
        'English (United Kingdom)' => '',
        'English (United States)' => '',
        'English stop words for fulltext index. These words will be removed from the search index.' =>
            '',
        'Enroll process for this ticket' => '',
        'Enter your shared secret to enable two factor authentication. WARNING: Make sure that you add the shared secret to your generator application and the application works well. Otherwise you will be not able to login anymore without the two factor token.' =>
            '',
        'Escalated Tickets' => 'Demandes escaladées',
        'Escalation view' => 'Vue des escalades',
        'EscalationTime' => '',
        'Estonian' => '',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate).' =>
            '',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate). This is only possible if all Ticket dynamic fields need the same event.' =>
            'Enregistrement du module des évènements. Pour une meilleure performance, vous pouvez créer un déclencheur d\'évènement (p.ex. Évènement => Créer une demande (Event => TicketCreate)). La création n\'est possible que si les champs dynamiques requièrent tous le même évènement.',
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
        'Events Ticket Calendar' => '',
        'Example package autoload configuration.' => '',
        'Execute SQL statements.' => 'Exécuter des requêtes SQL.',
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
            'Exporte l\'arborescence complet d\'un article dans les résultats de recherche (la performance du système pourrait être touchée).',
        'External' => '',
        'External Link' => '',
        'Fetch emails via fetchmail (using SSL).' => '',
        'Fetch emails via fetchmail.' => '',
        'Fetch incoming emails from configured mail accounts.' => '',
        'Fetches packages via proxy. Overwrites "WebUserAgent::Proxy".' =>
            'Recherche les paquets au moyen du serveur mandataire. Écrase « WebUserAgent::Proxy ».',
        'File that is displayed in the Kernel::Modules::AgentInfo module, if located under Kernel/Output/HTML/Templates/Standard/AgentInfo.tt.' =>
            '',
        'Filter for debugging ACLs. Note: More ticket attributes can be added in the format <OTRS_TICKET_Attribute> e.g. <OTRS_TICKET_Priority>.' =>
            '',
        'Filter for debugging Transitions. Note: More filters can be added in the format <OTRS_TICKET_Attribute> e.g. <OTRS_TICKET_Priority>.' =>
            '',
        'Filter incoming emails.' => 'Filtrer les courriels entrants.',
        'Finnish' => '',
        'First Christmas Day' => '1er jour de Noël',
        'First Queue' => '',
        'First response time' => '',
        'FirstLock' => '',
        'FirstResponse' => '',
        'FirstResponseDiffInMin' => '',
        'FirstResponseInMin' => '',
        'Firstname Lastname' => '',
        'Firstname Lastname (UserLogin)' => '',
        'For these state types the ticket numbers are striked through in the link table.' =>
            '',
        'Force the storage of the original article text in the article search index, without executing filters or applying stop word lists. This will increase the size of the search index and thus may slow down fulltext searches.' =>
            '',
        'Forces encoding of outgoing emails (7bit|8bit|quoted-printable|base64).' =>
            'Force le codage des courriels sortants (7bit|8bit|quoted-printable|base64).',
        'Forces to choose a different ticket state (from current) after lock action. Define the current state as key, and the next state after lock action as content.' =>
            'Force à choisir un état de la demande différent après une action de verrouillage. Défini l\'état actuel en tant que clé et l\'état suivant en tant que contenu après une action de verrouillage.',
        'Forces to unlock tickets after being moved to another queue.' =>
            'Force le déverrouillage des demandes après qu\'elles sont déplacées dans une autre file.',
        'Forwarded to "%s".' => 'Transférée vers "%s".',
        'Free Fields' => 'Champs libres',
        'French' => '',
        'French (Canada)' => '',
        'French stop words for fulltext index. These words will be removed from the search index.' =>
            '',
        'Frontend' => '',
        'Frontend module registration (disable AgentTicketService link if Ticket Service feature is not used).' =>
            '',
        'Frontend module registration (disable company link if no company feature is used).' =>
            'Enregistrement du module interface (désactive le lien de la société si aucune fonction de la société n\'est utilisée).',
        'Frontend module registration (disable ticket processes screen if no process available) for Customer.' =>
            '',
        'Frontend module registration (disable ticket processes screen if no process available).' =>
            '',
        'Frontend module registration (show personal favorites as sub navigation items of \'Admin\').' =>
            '',
        'Frontend module registration for the agent interface.' => 'Enregistrement du module interface pour l\'interface agent.',
        'Frontend module registration for the customer interface.' => 'Enregistrement du module interface pour l\'interface client.',
        'Frontend module registration for the public interface.' => '',
        'Full value' => '',
        'Fulltext index regex filters to remove parts of the text.' => '',
        'Fulltext search' => '',
        'Galician' => '',
        'General ticket data shown in the ticket overviews (fall-back). Note that TicketNumber can not be disabled, because it is necessary.' =>
            '',
        'Generate dashboard statistics.' => '',
        'Generic Info module.' => '',
        'GenericAgent' => 'Agent générique',
        'GenericInterface Debugger GUI' => 'Débogueur IUG de l\'interface générique',
        'GenericInterface ErrorHandling GUI' => '',
        'GenericInterface Invoker Event GUI' => '',
        'GenericInterface Invoker GUI' => 'Demandeur IUG de l\'interface générique',
        'GenericInterface Operation GUI' => 'Opération IUG de l\'interface générique',
        'GenericInterface TransportHTTPREST GUI' => '',
        'GenericInterface TransportHTTPSOAP GUI' => 'TransportHTTPSOAP IUG de l\'interface générique',
        'GenericInterface Web Service GUI' => 'Service Web IUG de l\'interface générique',
        'GenericInterface Web Service History GUI' => '',
        'GenericInterface Web Service Mapping GUI' => '',
        'GenericInterface module registration for an error handling module.' =>
            '',
        'GenericInterface module registration for the invoker layer.' => 'Enregistrement du module de l\'interface générique pour la couche du demandeur.',
        'GenericInterface module registration for the mapping layer.' => 'Enregistrement du module de l\'interface générique pour la couche de mappage.',
        'GenericInterface module registration for the operation layer.' =>
            'Enregistrement du module de l\'interface générique pour la couche des opérations.',
        'GenericInterface module registration for the transport layer.' =>
            'Enregistrement du module de l\'interface générique pour la couche de transport.',
        'German' => '',
        'German stop words for fulltext index. These words will be removed from the search index.' =>
            '',
        'Gives customer users group based access to tickets from customer users of the same customer (ticket CustomerID is a CustomerID of the customer user).' =>
            '',
        'Gives end users the possibility to override the separator character for CSV files, defined in the translation files. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Global Search Module.' => '',
        'Go to dashboard!' => '',
        'Good PGP signature.' => '',
        'Google Authenticator' => '',
        'Graph: Bar Chart' => '',
        'Graph: Line Chart' => '',
        'Graph: Stacked Area Chart' => '',
        'Greek' => '',
        'Hebrew' => '',
        'Helps to extend your articles full-text search (From, To, Cc, Subject and Body search). It will strip all articles and will build an index after article creation, increasing fulltext searches about 50%. To create an initial index use "bin/otrs.Console.pl Maint::Ticket::FulltextIndex --rebuild".' =>
            '',
        'High Contrast' => '',
        'High contrast skin for visually impaired users.' => '',
        'Hindi' => '',
        'Hungarian' => '',
        'If "DB" was selected for Customer::AuthModule, a database driver (normally autodetection is used) can be specified.' =>
            'Si vous sélectionnez l\'option « DB » pour le module « Customer::AuthModule », vous pouvez déterminer un pilote de base de données (l\'autodétection est habituellement utilisée).',
        'If "DB" was selected for Customer::AuthModule, a password to connect to the customer table can be specified.' =>
            'Si vous sélectionnez l\'option « DB » pour le module « Customer::AuthModule », vous pouvez déterminer un mot de passe pour la connexion à la table du client.',
        'If "DB" was selected for Customer::AuthModule, a username to connect to the customer table can be specified.' =>
            'Si vous sélectionnez l\'option « DB » pour le module « Customer::AuthModule », vous pouvez déterminer un nom d\'usager pour la connexion à la table du client.',
        'If "DB" was selected for Customer::AuthModule, the DSN for the connection to the customer table must be specified.' =>
            'Si vous sélectionnez l\'option « DB » pour le module « Customer::AuthModule », vous devez préciser le DSN pour la connexion à la table du client.',
        'If "DB" was selected for Customer::AuthModule, the column name for the CustomerPassword in the customer table must be specified.' =>
            'Si vous sélectionnez l\'option « DB » pour le module « Customer::AuthModule », vous devez préciser le nom de la colonne du mot de passe client (CustomerPassword) dans la table du client.',
        'If "DB" was selected for Customer::AuthModule, the encryption type of passwords must be specified.' =>
            '',
        'If "DB" was selected for Customer::AuthModule, the name of the column for the CustomerKey in the customer table must be specified.' =>
            'Si vous sélectionnez l\'option « DB » pour le module « Customer::AuthModule », vous devez préciser le nom de la colonne pour la clé du client (CustomerKey) dans la table du client.',
        'If "DB" was selected for Customer::AuthModule, the name of the table where your customer data should be stored must be specified.' =>
            'Si vous sélectionnez l\'option « DB » pour le module « Customer::AuthModule », vous devez préciser le nom de la table où sont stockées vos données clients.',
        'If "DB" was selected for SessionModule, a table in database where session data will be stored must be specified.' =>
            'Si vous sélectionnez l\'option « DB » pour le module « SessionModule », vous devez préciser une table dans la base de données où seront stockées les données de la session.',
        'If "FS" was selected for SessionModule, a directory where the session data will be stored must be specified.' =>
            'Si vous sélectionnez l\'option « FS » pour le module « SessionModule », vous devez préciser un répertoire où seront stockées les données de la session.',
        'If "HTTPBasicAuth" was selected for Customer::AuthModule, you can specify (by using a RegExp) to strip parts of REMOTE_USER (e. g. for to remove trailing domains). RegExp-Note, $1 will be the new Login.' =>
            'Si vous sélectionnez l\'option « HTTPBasicAuth » pour le module « Customer::AuthModule », vous pouvez préciser (en utilisant une expression rationnelle) la mise en chaîne de parties du « REMOTE_USER » (afin de supprimer les domaines de poids faibles). « RegExp-Note, $1 » servira alors à l\'ouverture de la session.',
        'If "HTTPBasicAuth" was selected for Customer::AuthModule, you can specify to strip leading parts of user names (e. g. for domains like example_domain\user to user).' =>
            'Si vous sélectionnez l\'option « HTTPBasicAuth » pour le module « Customer::AuthModule », vous pouvez préciser la mise en chaîne de parties de noms d\'utilisateur que vous souhaitez mettre de l\'avant (p. ex. pour les domaines de type « exemple_domaine\utilisateur à utilisateur »).',
        'If "LDAP" was selected for Customer::AuthModule and if you want to add a suffix to every customer login name, specifiy it here, e. g. you just want to write the username user but in your LDAP directory exists user@domain.' =>
            'Si vous sélectionnez l\'option « LDAP » pour le module « Customer::AuthModule » et que vous souhaitez ajouter un suffixe aux noms d\'utilisateur de chacun des clients, vous devez le spécifier ici (p. ex. vous voulez uniquement écrire le nom de l\'utilisateur alors que dans votre répertoire LDAP, il existe sous la forme « utilisateur@domaine »).',
        'If "LDAP" was selected for Customer::AuthModule and special paramaters are needed for the Net::LDAP perl module, you can specify them here. See "perldoc Net::LDAP" for more information about the parameters.' =>
            'Si vous sélectionnez l\'option « LDAP » pour le module « Customer::AuthModule » et que vous devez avoir des paramètres spéciaux pour le module perl « Net::LDAP », vous devez le spécifier ici. Pour de plus amples renseignements sur les paramètres, consultez « perldoc Net::LDAP ».',
        'If "LDAP" was selected for Customer::AuthModule and your users have only anonymous access to the LDAP tree, but you want to search through the data, you can do this with a user who has access to the LDAP directory. Specify the password for this special user here.' =>
            'Si vous sélectionnez l\'option « LDAP » pour le module « Customer::AuthModule », que vos utilisateurs ont seulement des accès anonymes à l\'arborescence LDAP et que vous souhaitez faire des recherches dans les données, vous aurez besoin d\'un utilisateur qui a accès au répertoire LDPA. Veuillez indiquer ici le mot de passe pour cet utilisateur spécialisé.',
        'If "LDAP" was selected for Customer::AuthModule and your users have only anonymous access to the LDAP tree, but you want to search through the data, you can do this with a user who has access to the LDAP directory. Specify the username for this special user here.' =>
            'Si vous sélectionnez l\'option « LDAP » pour le module « Customer::AuthModule », que vos utilisateurs ont seulement des accès anonymes à l\'arborescence LDAP et que vous souhaitez faire des recherches dans les données, vous aurez besoin d\'un utilisateur qui a accès au répertoire LDPA. Veuillez indiquer ici le nom d\'utilisateur pour cet utilisateur spécialisé.',
        'If "LDAP" was selected for Customer::AuthModule, the BaseDN must be specified.' =>
            'Si vous sélectionnez l\'option « LDAP » pour le module « Customer::AuthModule », vous devez préciser la base DN « BaseDN ».',
        'If "LDAP" was selected for Customer::AuthModule, the LDAP host can be specified.' =>
            'Si vous sélectionnez l\'option « LDAP » pour le module « Customer::AuthModule », vous devez préciser l\'hôte LDAP.',
        'If "LDAP" was selected for Customer::AuthModule, the user identifier must be specified.' =>
            'Si vous sélectionnez l\'option « LDAP » pour le module « Customer::AuthModule », vous devez préciser l\'identifiant de l\'utilisateur.',
        'If "LDAP" was selected for Customer::AuthModule, user attributes can be specified. For LDAP posixGroups use UID, for non LDAP posixGroups use full user DN.' =>
            'Si vous sélectionnez l\'option « LDAP » pour le module « Customer::AuthModule », vous pouvez préciser les attributs de l\'utilisateur. Pour les groupes POSIX (posixGroups) LDPA, utilisez un numéro d\'identification d\'utilisateur; pour les autres groupes, utilisez un nom distinctif complet d\'utilisateur. ',
        'If "LDAP" was selected for Customer::AuthModule, you can specify access attributes here.' =>
            'Si vous sélectionnez l\'option « LDAP » pour le module « Customer::AuthModule », vous pouvez ici préciser les attributs d\'accès.',
        'If "LDAP" was selected for Customer::AuthModule, you can specify if the applications will stop if e. g. a connection to a server can\'t be established due to network problems.' =>
            'Si vous sélectionnez l\'option « LDAP » pour le module « Customer::AuthModule », vous pouvez préciser si les applications doivent arrêter, par exemple, si une connexion à un serveur ne peut être établi en raison d\'un problème de réseau.',
        'If "LDAP" was selected for Customer::Authmodule, you can check if the user is allowed to authenticate because he is in a posixGroup, e.g. user needs to be in a group xyz to use OTRS. Specify the group, who may access the system.' =>
            'Si vous sélectionnez l\'option « LDAP » pour le module « Customer::AuthModule », vous pouvez vérifier si l\'utilisateur est autorisé à s\'authentifier parce qu\'il est dans un groupe POSIX (posixGroup) (p. ex. un utilisateur doit être dans un groupe XYX pour utiliser OTRS). Veuillez préciser le groupe ayant accès au système.',
        'If "LDAP" was selected, you can add a filter to each LDAP query, e.g. (mail=*), (objectclass=user) or (!objectclass=computer).' =>
            'Si vous sélectionnez l\'option « LDAP », vous pouvez ajouter un filtre pour chaque requête LDAP, p. ex. (mail=*), (objectclass=user) or (!objectclass=computer).',
        'If "Radius" was selected for Customer::AuthModule, the password to authenticate to the radius host must be specified.' =>
            'Si vous sélectionnez l\'option « RADIUS » pour le module « Customer::AuthModule », vous devez préciser le mot de passe pour l\'authentification à l\'hôte RADIUS.',
        'If "Radius" was selected for Customer::AuthModule, the radius host must be specified.' =>
            'Si vous sélectionnez l\'option « RADIUS » pour le module « Customer::AuthModule », vous devez préciser l\'hôte RADIUS.',
        'If "Radius" was selected for Customer::AuthModule, you can specify if the applications will stop if e. g. a connection to a server can\'t be established due to network problems.' =>
            'Si vous sélectionnez l\'option « RADIUS » pour le module « Customer::AuthModule », vous pouvez préciser si les applications doivent arrêter, par exemple, si une connexion à un serveur ne peut être établi en raison d\'un problème de réseau.',
        'If "Sendmail" was selected as SendmailModule, the location of the sendmail binary and the needed options must be specified.' =>
            'Si vous sélectionnez le processus « Envoyer des courriels » en tant que module « SendMailModule », vous devez préciser l\'emplacement du code binaire du processus ainsi que les options nécessaires.',
        'If "SysLog" was selected for LogModule, a special log facility can be specified.' =>
            'Si vous sélectionnez le  « Journal du système » pour le module « LogModule », vous pouvez déterminer une fonction spécialisée. ',
        'If "SysLog" was selected for LogModule, the charset that should be used for logging can be specified.' =>
            'Si l\'option « Journal du système » est sélectionné pour le module « LogModule », le jeu de caractère qui doit être utilisé pour la connexion peut y être spécifié.',
        'If "bcrypt" was selected for CryptType, use cost specified here for bcrypt hashing. Currently max. supported cost value is 31.' =>
            '',
        'If "file" was selected for LogModule, a logfile must be specified. If the file doesn\'t exist, it will be created by the system.' =>
            'Si l\'option « Fichier » est sélectionné pour le module « LogModule », un fichier journal doit être spécifié. Si le fichier n\'existe pas, il sera créé par le système.',
        'If active, none of the regular expressions may match the user\'s email address to allow registration.' =>
            '',
        'If active, one of the regular expressions has to match the user\'s email address to allow registration.' =>
            '',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, and authentication to the mail server is needed, a password must be specified.' =>
            'Si un mécanisme « SMTP » est sélectionné en tant que module d\'envoi de courriel ( SendmailModule ) et qu\'une authentification au serveur de courriel est nécessaire, un mot de passe doit être spécifié.',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, and authentication to the mail server is needed, an username must be specified.' =>
            'Si un mécanisme « SMTP » est sélectionné en tant que module d\'envoi de courriel ( SendmailModule ) et qu\'une authentification au serveur de courriel est nécessaire, un nom d\'utilisateur doit être spécifié.',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, the mailhost that sends out the mails must be specified.' =>
            'Si un mécanisme « SMTP » est sélectionné en tant que module d\'envoi de courriel ( SendmailModule ), l\'hôte de messagerie responsable de l\'envoi des courriels doit être spécifié.',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, the port where your mailserver is listening for incoming connections must be specified.' =>
            'Si un mécanisme « SMTP » est sélectionné en tant que module d\'envoi de courriel ( SendmailModule ), le port d\'écoute des connections entrantes du serveur courriel doit être spécifié.',
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
            'OTRS livrera tous les fichiers JavaScript en format minimisé si vous activez cette option.',
        'If enabled, TicketPhone and TicketEmail will be open in new windows.' =>
            'Les demandes téléphoniques et les demandes par courriel seront ouvertes dans des nouvelles fenêtres si cette option est activée.',
        'If enabled, the OTRS version tag will be removed from the Webinterface, the HTTP headers and the X-Headers of outgoing mails. NOTE: If you change this option, please make sure to delete the cache.' =>
            '',
        'If enabled, the cache data be held in memory.' => '',
        'If enabled, the cache data will be stored in cache backend.' => '',
        'If enabled, the customer can search for tickets in all services (regardless what services are assigned to the customer).' =>
            '',
        'If enabled, the different overviews (Dashboard, LockedView, QueueView) will automatically refresh after the specified time.' =>
            'Les différentes visualisations ( tableau de bord, vue de fermeture, vue des files) seront automatiquement rafraîchies après le délai déterminé ici.',
        'If enabled, the first level of the main menu opens on mouse hover (instead of click only).' =>
            'Le premier plan du menu principal s\'ouvre d\'un pointage de la souris plutôt que d\'un clic, si cette option est activée.',
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
            'Si cette expression rationnelle correspond, aucun message ne sera envoyé par l\'autorépondeur.',
        'If this setting is enabled, it is possible to install packages which are not verified by OTRS Group. These packages could threaten your whole system!' =>
            '',
        'If this setting is enabled, local modifications will not be highlighted as errors in the package manager and support data collector.' =>
            '',
        'If you\'re going to be out of office, you may wish to let other users know by setting the exact dates of your absence.' =>
            '',
        'Ignore system sender article types (e. g. auto responses or email notifications) to be flagged as \'Unread Article\' in AgentTicketZoom or expanded automatically in Large view screens.' =>
            '',
        'Import appointments screen.' => '',
        'Include tickets of subqueues per default when selecting a queue.' =>
            'Inclure les demandes des sous-files par défaut lors de la sélection d\'une file.',
        'Include unknown customers in ticket filter.' => '',
        'Includes article create times in the ticket search of the agent interface.' =>
            'Comprend les moments de création des articles dans les recherches de demandes de l\'interface agent.',
        'Incoming Phone Call.' => '',
        'IndexAccelerator: to choose your backend TicketViewAccelerator module. "RuntimeDB" generates each queue view on the fly from ticket table (no performance problems up to approx. 60.000 tickets in total and 6.000 open tickets in the system). "StaticDB" is the most powerful module, it uses an extra ticket-index table that works like a view (recommended if more than 80.000 and 6.000 open tickets are stored in the system). Use the command "bin/otrs.Console.pl Maint::Ticket::QueueIndexRebuild" for initial index creation.' =>
            '',
        'Indicates if a bounce e-mail should always be treated as normal follow-up.' =>
            '',
        'Indonesian' => '',
        'Inline' => '',
        'Input' => '',
        'Interface language' => 'Langue de l\'interface ',
        'Internal communication channel.' => '',
        'International Workers\' Day' => 'Fête internationale des travailleurs',
        'It is possible to configure different skins, for example to distinguish between diferent agents, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            'Il est possible de configurer différents habillages par domaine dans l\'application pour distinguer les agents entre eux par exemple. En utilisant une expression rationnelle (regex) vous pouvez configurer un couple clé-contenu qui correspond au domaine. La valeur « Clé » doit correspondre au domaine et la valeur « Contenu » doit être un habillage admissible à votre système. Veuillez consulter les exemples pour vérifier quels sont les formats appropriés d\'expressions rationnelles.',
        'It is possible to configure different skins, for example to distinguish between diferent customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            'Il est possible de configurer différents habillages par domaine dans l\'application pour distinguer les clients entre eux par exemple. En utilisant une expression rationnelle (regex) vous pouvez configurer un couple clé-contenu qui correspond au domaine. La valeur « Clé » doit correspondre au domaine et la valeur « Contenu » doit être un habillage admissible à votre système. Veuillez consulter les exemples pour vérifier quels sont les formats appropriés d\'expressions rationnelles.',
        'It is possible to configure different themes, for example to distinguish between agents and customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid theme on your system. Please see the example entries for the proper form of the regex.' =>
            'Il est possible de configurer différents thèmes par domaine dans l\'application pour distinguer les agents des clients par exemple. En utilisant une expression rationnelle (regex) vous pouvez configurer un couple clé-contenu qui correspond au domaine. La valeur « Clé » doit correspondre au domaine et la valeur « Contenu » doit être un habillage admissible à votre système. Veuillez consulter les exemples pour vérifier quels sont les formats appropriés d\'expressions rationnelles.',
        'It was not possible to check the PGP signature, this may be caused by a missing public key or an unsupported algorithm.' =>
            '',
        'Italian' => '',
        'Italian stop words for fulltext index. These words will be removed from the search index.' =>
            '',
        'Ivory' => '',
        'Ivory (Slim)' => '',
        'Japanese' => '',
        'JavaScript function for the search frontend.' => '',
        'Korean' => '',
        'Language' => 'Langue',
        'Large' => 'Grand (L)',
        'Last Screen Overview' => '',
        'Last customer subject' => '',
        'Lastname Firstname' => '',
        'Lastname Firstname (UserLogin)' => '',
        'Lastname, Firstname' => '',
        'Lastname, Firstname (UserLogin)' => '',
        'LastnameFirstname' => '',
        'Latvian' => '',
        'Left' => '',
        'Link Object' => 'Lier l\'objet',
        'Link Object.' => '',
        'Link agents to groups.' => 'Lier les agents aux groupes.',
        'Link agents to roles.' => 'Lier les agents aux rôles.',
        'Link customer users to customers.' => '',
        'Link customer users to groups.' => '',
        'Link customer users to services.' => '',
        'Link customers to groups.' => '',
        'Link queues to auto responses.' => 'Lier les files aux réponses automatiques.',
        'Link roles to groups.' => 'Lier les rôles aux groupes.',
        'Link templates to attachments.' => '',
        'Link templates to queues.' => '',
        'Link this ticket to other objects' => 'Lier cette demande à d\'autres objets',
        'Links 2 tickets with a "Normal" type link.' => 'Lier deux demandes d\'un lien « Normal ».',
        'Links 2 tickets with a "ParentChild" type link.' => 'Lier deux demandes d\'un lien « ParentChild » (parent enfant).',
        'Links appointments and tickets with a "Normal" type link.' => '',
        'List of CSS files to always be loaded for the agent interface.' =>
            'Liste des fichiers CSS qui doivent toujours être téléchargés sur l\'interface agent.',
        'List of CSS files to always be loaded for the customer interface.' =>
            'Liste des fichiers CSS qui doivent toujours être téléchargés sur l\'interface client.',
        'List of JS files to always be loaded for the agent interface.' =>
            'Liste des fichiers JavaScript qui doivent toujours être téléchargés sur l\'interface agent.',
        'List of JS files to always be loaded for the customer interface.' =>
            'Liste des fichiers JavaScript qui doivent toujours être téléchargés sur l\'interface client.',
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
            '',
        'List of responsive CSS files to always be loaded for the agent interface.' =>
            '',
        'List of responsive CSS files to always be loaded for the customer interface.' =>
            '',
        'List view' => '',
        'Lithuanian' => '',
        'Loader module registration for the agent interface.' => '',
        'Loader module registration for the customer interface.' => '',
        'Lock / unlock this ticket' => '',
        'Locked Tickets' => 'Demandes verrouillées',
        'Locked Tickets.' => '',
        'Locked ticket.' => 'Demande verrouillée.',
        'Logged in users.' => '',
        'Logged-In Users' => '',
        'Logout of customer panel.' => '',
        'Look into a ticket!' => 'Voyez le détail de la demande!',
        'Loop protection: no auto-response sent to "%s".' => '',
        'Macedonian' => '',
        'Mail Accounts' => 'Comptes courriel',
        'MailQueue configuration settings.' => '',
        'Main menu item registration.' => '',
        'Main menu registration.' => '',
        'Makes the application block external content loading.' => '',
        'Makes the application check the MX record of email addresses before sending an email or submitting a telephone or email ticket.' =>
            'S\'assurer que l\'application vérifie l\'enregistrement du messager des adresses électroniques avant d\'envoyer un courriel ou de soumettre une demande téléphonique ou par courriel.',
        'Makes the application check the syntax of email addresses.' => 'S\'assurer que l\'application vérifie la syntaxe des adresses électroniques.',
        'Makes the session management use html cookies. If html cookies are disabled or if the client browser disabled html cookies, then the system will work as usual and append the session id to the links.' =>
            'S\'assurer que le gestionnaire de sessions utilise les témoins HTML. Si les témoins HTML sont désactivés ou que le navigateur du client les désactive, le système fonctionnera comme à l\'habitude et adjoindra l\'identification de la session aux liens.',
        'Malay' => '',
        'Manage OTRS Group cloud services.' => '',
        'Manage PGP keys for email encryption.' => 'Gérer les clés PGP pour le cryptage des courriels.',
        'Manage POP3 or IMAP accounts to fetch email from.' => 'Gérer les comptes POP3 ou IMAP afin d\'aller y chercher des courriels.',
        'Manage S/MIME certificates for email encryption.' => 'Gérer les certificats S/MIME pour le cryptage des courriels.',
        'Manage System Configuration Deployments.' => '',
        'Manage different calendars.' => '',
        'Manage existing sessions.' => 'Gérer les sessions existantes.',
        'Manage support data.' => '',
        'Manage system registration.' => '',
        'Manage tasks triggered by event or time based execution.' => '',
        'Mark as Spam!' => 'Marquer comme pourriel!',
        'Mark this ticket as junk!' => 'Marquer cette demande comme pourriel!',
        'Max size (in characters) of the customer information table (phone and email) in the compose screen.' =>
            'Le nombre maximal de caractères de la table de renseignements du client (numéro de téléphone et courriel) dans l\'écran de rédaction.',
        'Max size (in rows) of the informed agents box in the agent interface.' =>
            'Le nombre maximal de lignes des boîtes des agents informés de l\'interface agent.',
        'Max size (in rows) of the involved agents box in the agent interface.' =>
            'Le nombre maximal de lignes des boîtes des agents impliqués de l\'interface agent.',
        'Max size of the subjects in an email reply and in some overview screens.' =>
            '',
        'Maximal auto email responses to own email-address a day (Loop-Protection).' =>
            'Le nombre maximal quotidien de réponses automatiques à sa propre adresse électronique (boucle de protection).',
        'Maximal auto email responses to own email-address a day, configurable by email address (Loop-Protection).' =>
            '',
        'Maximal size in KBytes for mails that can be fetched via POP3/POP3S/IMAP/IMAPS (KBytes).' =>
            'La taille maximale en kilo-octets des courriels qui peuvent être récupérés par POP3, POP3S, IMAP, IMAPS.',
        'Maximum Number of a calendar shown in a dropdown.' => '',
        'Maximum length (in characters) of the dynamic field in the article of the ticket zoom view.' =>
            '',
        'Maximum length (in characters) of the dynamic field in the sidebar of the ticket zoom view.' =>
            '',
        'Maximum number of active calendars in overview screens. Please note that large number of active calendars can have a performance impact on your server by making too much simultaneous calls.' =>
            '',
        'Maximum number of tickets to be displayed in the result of a search in the agent interface.' =>
            'Le nombre maximal de demandes à afficher dans les résultats de recherche de l\'interface agent.',
        'Maximum number of tickets to be displayed in the result of a search in the customer interface.' =>
            'Le nombre maximal de demandes à afficher dans les résultats de recherche de l\'interface client.',
        'Maximum number of tickets to be displayed in the result of this operation.' =>
            '',
        'Maximum size (in characters) of the customer information table in the ticket zoom view.' =>
            'Le nombre maximal de caractères dans la table de renseignements du client dans la synthèse de la demande.',
        'Medium' => 'Moyen (M)',
        'Merge this ticket and all articles into another ticket' => '',
        'Merged Ticket (%s/%s) to (%s/%s).' => '',
        'Merged Ticket <OTRS_TICKET> to <OTRS_MERGE_TO_TICKET>.' => '',
        'Minute' => '',
        'Miscellaneous' => 'Divers',
        'Module for To-selection in new ticket screen in the customer interface.' =>
            'Module de sélection du destinataire dans l\'écran de nouvelle demande de l\'interface client.',
        'Module to check if a incoming e-mail message is bounce.' => '',
        'Module to check if arrived emails should be marked as internal (because of original forwarded internal email). IsVisibleForCustomer and SenderType define the values for the arrived email/article.' =>
            '',
        'Module to check the group permissions for customer access to tickets.' =>
            '',
        'Module to check the group permissions for the access to tickets.' =>
            '',
        'Module to compose signed messages (PGP or S/MIME).' => 'Module de rédaction des messages signés (PGP ou S/MIME).',
        'Module to define the email security options to use (PGP or S/MIME).' =>
            '',
        'Module to encrypt composed messages (PGP or S/MIME).' => '',
        'Module to fetch customer users SMIME certificates of incoming messages.' =>
            '',
        'Module to filter and manipulate incoming messages. Block/ignore all spam email with From: noreply@ address.' =>
            'Module qui permet de filtrer et de manipuler les messages entrants. Ce module permet de bloquer ou d\'ignorer tous les pourriels dont le champ d\'expéditeur comporte la valeur : noreply@address (pasderéponse@adresse).',
        'Module to filter and manipulate incoming messages. Get a 4 digit number to ticket free text, use regex in Match e. g. From => \'(.+?)@.+?\', and use () as [***] in Set =>.' =>
            '',
        'Module to filter encrypted bodies of incoming messages.' => '',
        'Module to generate accounted time ticket statistics.' => 'Module qui génère des statistiques du temps alloué aux demandes.',
        'Module to generate html OpenSearch profile for short ticket search in the agent interface.' =>
            'Module qui génère un profil «OpenSearch » HTML pour les courtes recherches dans l\'interface agent.',
        'Module to generate html OpenSearch profile for short ticket search in the customer interface.' =>
            'Module qui génère un profil «OpenSearch » HTML pour les courtes recherches dans l\'interface client.',
        'Module to generate ticket solution and response time statistics.' =>
            'Module qui génère des statistiques de résolution de demandes et de temps de réponse.',
        'Module to generate ticket statistics.' => 'Module qui génère des statistiques concernant les demandes.',
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
            'Module d\'affichage des notifications et des escalades (Affichage maximal (ShownMax) : nombre maximal d\'escalades affichées, Escalade à venir (EscalationInMinutes) : affiche les demandes qui escaladeront, Temps de cache (CacheTime) : temps de cache des escalades prévues en secondes.)',
        'Module to use database filter storage.' => 'Module qui permet d\'utiliser la mise en mémoire des filtres de base de données.',
        'Module used to detect if attachments are present.' => '',
        'Multiselect' => 'Multi-choix',
        'My Queues' => 'Mes files ',
        'My Services' => 'Mes services',
        'My Tickets.' => '',
        'Name of custom queue. The custom queue is a queue selection of your preferred queues and can be selected in the preferences settings.' =>
            'Dénomination des files personnalisées. Les files personnalisées réfèrent aux files que vous avez choisies comme favorites.',
        'Name of custom service. The custom service is a service selection of your preferred services and can be selected in the preferences settings.' =>
            '',
        'NameX' => 'Nom x',
        'New Ticket' => 'Nouvelle demande',
        'New Tickets' => 'Nouvelles demandes',
        'New Window' => '',
        'New Year\'s Day' => 'Jour de l\'An',
        'New Year\'s Eve' => 'Veille du jour de l\'An',
        'New process ticket' => '',
        'News about OTRS releases!' => 'Nouvelles au sujet des versions de OTRS.',
        'News about OTRS.' => '',
        'Next possible ticket states after adding a phone note in the ticket phone inbound screen of the agent interface.' =>
            'Les états de demande possibles après qu\'une note téléphonique est ajoutée dans l\'écran des demandes téléphoniques entrantes de l\'interface agent.',
        'Next possible ticket states after adding a phone note in the ticket phone outbound screen of the agent interface.' =>
            'Les états de demande possibles après qu\'une note téléphonique est ajoutée dans l\'écran des demandes téléphoniques sortantes de l\'interface agent.',
        'No public key found.' => '',
        'No valid OpenPGP data found.' => '',
        'None' => '',
        'Norwegian' => '',
        'Notification Settings' => 'Paramètres de notification',
        'Notified about response time escalation.' => '',
        'Notified about solution time escalation.' => '',
        'Notified about update time escalation.' => '',
        'Number of displayed tickets' => 'Nombre de demandes affichées ',
        'Number of lines (per ticket) that are shown by the search utility in the agent interface.' =>
            'Nombre de lignes (par demande) affichées par l\'utilitaire de recherche dans l\'interface agent.',
        'Number of tickets to be displayed in each page of a search result in the agent interface.' =>
            'Nombre de demandes affichées dans chaque page de résultats de recherche dans l\'interface agent.',
        'Number of tickets to be displayed in each page of a search result in the customer interface.' =>
            'Nombre de demandes affichées dans chaque page de résultats de recherche dans l\'interface client.',
        'Number of tickets to be displayed in each page.' => '',
        'OTRS Group Services' => '',
        'OTRS News' => 'Nouvelles de OTRS',
        'OTRS can use one or more readonly mirror databases for expensive operations like fulltext search or statistics generation. Here you can specify the DSN for the first mirror database.' =>
            '',
        'OTRS doesn\'t support recurring Appointments without end date or number of iterations. During import process, it might happen that ICS file contains such Appointments. Instead, system creates all Appointments in the past, plus Appointments for the next N months (120 months/10 years by default).' =>
            '',
        'Open an external link!' => '',
        'Open tickets (customer user)' => '',
        'Open tickets (customer)' => 'Demandes ouvertes (client)',
        'Option' => '',
        'Optional queue limitation for the CreatorCheck permission module. If set, permission is only granted for tickets in the specified queues.' =>
            '',
        'Optional queue limitation for the InvolvedCheck permission module. If set, permission is only granted for tickets in the specified queues.' =>
            '',
        'Optional queue limitation for the OwnerCheck permission module. If set, permission is only granted for tickets in the specified queues.' =>
            '',
        'Optional queue limitation for the ResponsibleCheck permission module. If set, permission is only granted for tickets in the specified queues.' =>
            '',
        'Other Customers' => '',
        'Out Of Office' => '',
        'Out Of Office Time' => 'Période d\'absence du bureau ',
        'Out of Office users.' => '',
        'Overloads (redefines) existing functions in Kernel::System::Ticket. Used to easily add customizations.' =>
            'Surcharge (redéfini) les fonctions existantes dans Kernel::System::Ticket. Ce module est utilisé pour faciliter la personnalisation.',
        'Overview Escalated Tickets.' => '',
        'Overview Refresh Time' => 'Actualisation de la visualisation tous les ',
        'Overview of all Tickets per assigned Queue.' => '',
        'Overview of all appointments.' => '',
        'Overview of all escalated tickets.' => '',
        'Overview of all open Tickets.' => 'Visualisation des demandes ouvertes.',
        'Overview of all open tickets.' => '',
        'Overview of customer tickets.' => '',
        'PGP Key' => 'Clé PGP',
        'PGP Key Management' => 'Gestion des clés PGP',
        'PGP Keys' => 'Clés PGP',
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
        'Parameters of the example SLA attribute Comment2.' => 'Paramètres des attributs SLA montrés en exemple (commentaire no 2).',
        'Parameters of the example queue attribute Comment2.' => 'Paramètres des attributs de file montrés en exemple (commentaire no 2).',
        'Parameters of the example service attribute Comment2.' => 'Paramètres des attributs de service montrés en exemple (commentaire no 2).',
        'Parent' => 'Parent',
        'ParentChild' => '',
        'Path for the log file (it only applies if "FS" was selected for LoopProtectionModule and it is mandatory).' =>
            'Chemin du fichier journal (s\'appliquera uniquement si vous sélectionnez l\'option « FS » pour le module « LoopProtectionModule », car elle est obligatoire).',
        'Pending time' => '',
        'People' => 'Intervenants',
        'Performs the configured action for each event (as an Invoker) for each configured web service.' =>
            '',
        'Permitted width for compose email windows.' => 'Largeur autorisée pour les fenêtres de rédaction de courriels.',
        'Permitted width for compose note windows.' => 'Largeur autorisée pour les fenêtres de rédaction de notes.',
        'Persian' => '',
        'Phone Call Inbound' => 'Appel vers l\'agent',
        'Phone Call Outbound' => 'Appel vers le client',
        'Phone Call.' => '',
        'Phone call' => 'Appel téléphonique ',
        'Phone communication channel.' => '',
        'Phone-Ticket' => 'Demande téléphonique',
        'Picture Upload' => '',
        'Picture upload module.' => '',
        'Picture-Upload' => 'Télécharger l\'image',
        'Plugin search' => '',
        'Plugin search module for autocomplete.' => '',
        'Polish' => '',
        'Portuguese' => '',
        'Portuguese (Brasil)' => '',
        'PostMaster Filters' => 'Filtres du maître de poste',
        'PostMaster Mail Accounts' => 'Comptes du maître de poste',
        'Print this ticket' => 'Imprimer cette demande',
        'Priorities' => 'Priorités',
        'Process Management Activity Dialog GUI' => '',
        'Process Management Activity GUI' => '',
        'Process Management Path GUI' => '',
        'Process Management Transition Action GUI' => '',
        'Process Management Transition GUI' => '',
        'Process Ticket.' => '',
        'Process pending tickets.' => '',
        'ProcessID' => '',
        'Processes & Automation' => '',
        'Product News' => 'Nouvelles du produit',
        'Protection against CSRF (Cross Site Request Forgery) exploits (for more info see https://en.wikipedia.org/wiki/Cross-site_request_forgery).' =>
            '',
        'Provides a matrix overview of the tickets per state per queue' =>
            '',
        'Provides customer users access to tickets even if the tickets are not assigned to a customer user of the same customer ID(s), based on permission groups.' =>
            '',
        'Public Calendar' => '',
        'Public calendar.' => '',
        'Queue view' => 'Vue des files',
        'Queues ↔ Auto Responses' => '',
        'Rebuild the ticket index for AgentTicketQueue.' => '',
        'Recognize if a ticket is a follow-up to an existing ticket using an external ticket number. Note: the first capturing group from the \'NumberRegExp\' expression will be used as the ticket number value.' =>
            '',
        'Refresh interval' => 'Intervalle de rafraîchissement',
        'Registers a log module, that can be used to log communication related information.' =>
            '',
        'Reminder Tickets' => 'Rappels',
        'Removed subscription for user "%s".' => 'Désabonnement pour l\'utilisateur "%s".',
        'Removes old generic interface debug log entries created before the specified amount of days.' =>
            '',
        'Removes old system configuration deployments (Sunday mornings).' =>
            '',
        'Removes old ticket number counters (each 10 minutes).' => '',
        'Removes the ticket watcher information when a ticket is archived.' =>
            '',
        'Renew existing SMIME certificates from customer backend. Note: SMIME and SMIME::FetchFromCustomer needs to be enabled in SysConfig and customer backend needs to be configured to fetch UserSMIMECertificate attribute.' =>
            '',
        'Replaces the original sender with current customer\'s email address on compose answer in the ticket compose screen of the agent interface.' =>
            'Remplace l\'expéditeur original par l\'adresse de courrier électronique du client actuel dans les réponses écrites au moyen de l\'écran de rédaction des demandes de l\'interface agent.',
        'Reports' => 'Rapports',
        'Reports (OTRS Business Solution™)' => '',
        'Reprocess mails from spool directory that could not be imported in the first place.' =>
            '',
        'Required permissions to change the customer of a ticket in the agent interface.' =>
            'Permissions requises pour changer le client d\'une demande dans l\'interface agent.',
        'Required permissions to use the close ticket screen in the agent interface.' =>
            'Permissions requises pour utiliser l\'écran de fermeture de la demande de l\'interface agent.',
        'Required permissions to use the email outbound screen in the agent interface.' =>
            '',
        'Required permissions to use the email resend screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket bounce screen in the agent interface.' =>
            'Permissions requises pour utiliser l\'écran de retour de la demande dans l\'interface agent.',
        'Required permissions to use the ticket compose screen in the agent interface.' =>
            'Permissions requises pour utiliser l\'écran de rédaction de la demande dans l\'interface agent.',
        'Required permissions to use the ticket forward screen in the agent interface.' =>
            'Permissions requises pour utiliser l\'écran de suivi de la demande dans l\'interface agent.',
        'Required permissions to use the ticket free text screen in the agent interface.' =>
            'Permissions requises pour utiliser l\'écran de texte libre de la demande dans l\'interface agent.',
        'Required permissions to use the ticket merge screen of a zoomed ticket in the agent interface.' =>
            'Permissions requises pour utiliser l\'écran de fusion de la synthèse de la demande dans l\'interface agent.',
        'Required permissions to use the ticket note screen in the agent interface.' =>
            'Permissions requises pour utiliser l\'écran de notes de l\'interface agent.',
        'Required permissions to use the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Permissions requises pour utiliser l\'écran de propriété de la synthèse de la demande de l\'interface agent.',
        'Required permissions to use the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Permissions requises pour utiliser l\'écran de mise en attente de la synthèse de la demande de l\'interface agent.',
        'Required permissions to use the ticket phone inbound screen in the agent interface.' =>
            'Permissions requises pour utiliser l\'écran des demandes téléphoniques entrantes de l\'interface agent.',
        'Required permissions to use the ticket phone outbound screen in the agent interface.' =>
            'Permissions requises pour utiliser l\'écran des demandes téléphoniques sortantes de l\'interface agent.',
        'Required permissions to use the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Permissions requises pour utiliser l\'écran de priorité de la synthèse de la demande dans l\'interface agent.',
        'Required permissions to use the ticket responsible screen in the agent interface.' =>
            'Permissions requises pour utiliser l\'écran de responsabilité de l\'interface agent.',
        'Resend Ticket Email.' => '',
        'Resent email to "%s".' => '',
        'Resets and unlocks the owner of a ticket if it was moved to another queue.' =>
            'Réinitialise et déverrouille le propriétaire de la demande lorsque cette dernière a été déplacée dans une autre file.',
        'Resource Overview (OTRS Business Solution™)' => '',
        'Responsible Tickets' => '',
        'Responsible Tickets.' => '',
        'Restores a ticket from the archive (only if the event is a state change to any open available state).' =>
            '',
        'Retains all services in listings even if they are children of invalid elements.' =>
            '',
        'Right' => '',
        'Roles ↔ Groups' => '',
        'Romanian' => '',
        'Run file based generic agent jobs (Note: module name needs to be specified in -configuration-module param e.g. "Kernel::System::GenericAgent").' =>
            '',
        'Running Process Tickets' => '',
        'Runs an initial wildcard search of the existing customer company when accessing the AdminCustomerCompany module.' =>
            '',
        'Runs an initial wildcard search of the existing customer users when accessing the AdminCustomerUser module.' =>
            'Lors de l\'accès au module « AdminCustomerUser », le présent module exécute une recherche initiale de caractères de remplacement des utilisateurs clients existants.',
        'Runs the system in "Demo" mode. If enabled, agents can change preferences, such as selection of language and theme via the agent web interface. These changes are only valid for the current session. It will not be possible for agents to change their passwords.' =>
            '',
        'Russian' => '',
        'S/MIME Certificates' => 'Certificats S/MIME',
        'SMS' => '',
        'SMS (Short Message Service)' => '',
        'Salutations' => 'Formules de salutation',
        'Sample command output' => '',
        'Saves the attachments of articles. "DB" stores all data in the database (not recommended for storing big attachments). "FS" stores the data on the filesystem; this is faster but the webserver should run under the OTRS user. You can switch between the modules even on a system that is already in production without any loss of data. Note: Searching for attachment names is not supported when "FS" is used.' =>
            '',
        'Schedule a maintenance period.' => '',
        'Screen after new ticket' => 'Écran qui suit la création d\'une demande ',
        'Search Customer' => 'Recherche d\'un client',
        'Search Ticket.' => '',
        'Search Tickets.' => '',
        'Search User' => '',
        'Search backend default router.' => 'Recherche du routeur par défaut de l\'arrière-plan.',
        'Search backend router.' => 'Recherche du routeur de l\'arrière-plan.',
        'Search.' => '',
        'Second Christmas Day' => '2e jour de Noël',
        'Second Queue' => '',
        'Select after which period ticket overviews should refresh automatically.' =>
            '',
        'Select how many tickets should be shown in overviews by default.' =>
            '',
        'Select the main interface language.' => '',
        'Select the separator character used in CSV files (stats and searches). If you don\'t select a separator here, the default separator for your language will be used.' =>
            'Sélectionner le caractère séparateur pour les fichiers CSV (stats et recherches). Si rien n\'est indiqué ici, le séparateur par défaut pour votre langage sera utilisé.',
        'Select your frontend Theme.' => 'Choix du thème de l\'interface',
        'Select your personal time zone. All times will be displayed relative to this time zone.' =>
            '',
        'Select your preferred layout for the software.' => '',
        'Select your preferred theme for OTRS.' => '',
        'Selects the cache backend to use.' => '',
        'Selects the module to handle uploads via the web interface. "DB" stores all uploads in the database, "FS" uses the file system.' =>
            'Sélection du module de gestion des téléchargements en passant par l\'interface Web. L\'option « DB » stocke tous les téléchargements dans la base de données, « FS » utilise le fichier système.',
        'Selects the ticket number generator module. "AutoIncrement" increments the ticket number, the SystemID and the counter are used with SystemID.counter format (e.g. 1010138, 1010139). With "Date" the ticket numbers will be generated by the current date, the SystemID and the counter. The format looks like Year.Month.Day.SystemID.counter (e.g. 200206231010138, 200206231010139). With "DateChecksum"  the counter will be appended as checksum to the string of date and SystemID. The checksum will be rotated on a daily basis. The format looks like Year.Month.Day.SystemID.Counter.CheckSum (e.g. 2002070110101520, 2002070110101535).' =>
            '',
        'Send new outgoing mail from this ticket' => '',
        'Send notifications to users.' => 'Envoyer des notifications aux utilisateurs.',
        'Sender type for new tickets from the customer inteface.' => 'Type d\'expéditeur des nouvelles demandes dans l\'interface client.',
        'Sends agent follow-up notification only to the owner, if a ticket is unlocked (the default is to send the notification to all agents).' =>
            'N\'envoie la notification de suivi de l\'agent qu\'au propriétaire si la demande est déverrouillée (par défaut, on enverrait normalement la notification à tous les agents).',
        'Sends all outgoing email via bcc to the specified address. Please use this only for backup reasons.' =>
            'Envoie tous les courriels sortants en tant que copie conforme invisible (bcc) à l\'adresse spécifiée. Veuillez n\'utiliser cette option que pour les copies de secours.',
        'Sends customer notifications just to the mapped customer.' => '',
        'Sends registration information to OTRS group.' => '',
        'Sends reminder notifications of unlocked ticket after reaching the reminder date (only sent to ticket owner).' =>
            'Envoie les notifications de rappel des demandes déverrouillées après que la date de rappel est atteinte (envoyées seulement au propriétaire de la demande).',
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
        'Service Level Agreements' => 'Accords sur les niveaux de service',
        'Service view' => '',
        'ServiceView' => '',
        'Set a new password by filling in your current password and a new one.' =>
            '',
        'Set sender email addresses for this system.' => 'Choisir les adresses électroniques pour l\'envoi des courriels du système.',
        'Set the default height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            'Règle le nombre de pixels par défaut des articles HTML (en file) de la synthèse de la demande dans l\'interface agent (AgentTicketZoom).',
        'Set the limit of tickets that will be executed on a single genericagent job execution.' =>
            '',
        'Set the maximum height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            'Règle le nombre maximal de pixels des articles HTML (en file) de la synthèse de la demande dans l\'interface agent (AgentTicketZoom).',
        'Set the minimum log level. If you select \'error\', just errors are logged. With \'debug\' you get all logging messages. The order of log levels is: \'debug\', \'info\', \'notice\' and \'error\'.' =>
            '',
        'Set this ticket to pending' => 'Mettre cette demande en attente',
        'Sets if SLA must be selected by the agent.' => '',
        'Sets if SLA must be selected by the customer.' => '',
        'Sets if note must be filled in by the agent. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            '',
        'Sets if queue must be selected by the agent.' => '',
        'Sets if service must be selected by the agent.' => '',
        'Sets if service must be selected by the customer.' => '',
        'Sets if state must be selected by the agent.' => '',
        'Sets if ticket owner must be selected by the agent.' => 'Règle si l\'agent doit sélectionner le propriétaire de la demande.',
        'Sets if ticket responsible must be selected by the agent.' => '',
        'Sets the PendingTime of a ticket to 0 if the state is changed to a non-pending state.' =>
            'Règle le délai d\'attente (PendingTime) d\'une demande à 0 si son état est modifié pour un état sans attente.',
        'Sets the age in minutes (first level) for highlighting queues that contain untouched tickets.' =>
            'Règle l\'âge, en minutes, (premier niveau) des files en surbrillance qui contiennent des demandes intouchées.',
        'Sets the age in minutes (second level) for highlighting queues that contain untouched tickets.' =>
            'Règle l\'âge, en minutes, (deuxième niveau) des files en surbrillance qui contiennent des demandes intouchées.',
        'Sets the configuration level of the administrator. Depending on the config level, some sysconfig options will be not shown. The config levels are in in ascending order: Expert, Advanced, Beginner. The higher the config level is (e.g. Beginner is the highest), the less likely is it that the user can accidentally configure the system in a way that it is not usable any more.' =>
            'Règle le niveau de configuration de l\'administateur. Selon le niveau de configuration, certaines options de configuration du système (sysconfig) seront affichées. Voici les différents niveaux de configuration en ordre croissant : expert, avancé et débutant. Plus le niveau de configuration est élevé (par exemple, le niveau débutant est le plus élevé), moins il sera possible pour l\'utilisateur de configurer accidentellement le système de façon à le rendre inutilisable.',
        'Sets the count of articles visible in preview mode of ticket overviews.' =>
            '',
        'Sets the default article customer visibility for new email tickets in the agent interface.' =>
            '',
        'Sets the default article customer visibility for new phone tickets in the agent interface.' =>
            '',
        'Sets the default body text for notes added in the close ticket screen of the agent interface.' =>
            'Règle le corps de texte par défaut des notes ajoutées dans l\'écran de fermeture de la demande dans l\'interface agent.',
        'Sets the default body text for notes added in the ticket move screen of the agent interface.' =>
            'Règle le corps du texte par défaut des notes ajoutées dans l\'écran de déplacement de la demande dans l\'interface agent.',
        'Sets the default body text for notes added in the ticket note screen of the agent interface.' =>
            'Établit le corps du texte par défaut des notes ajoutées à l\'écran de notes de la demande dans l\'interface agent.',
        'Sets the default body text for notes added in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Établit le corps du texte par défaut des notes ajoutées à l\'écran du propriétaire dans la synthèse de la demande de l\'interface agent.',
        'Sets the default body text for notes added in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Établit le corps du texte par défaut des notes ajoutées à l\'écran de mise en attente dans la synthèse de la demande de l\'interface agent.',
        'Sets the default body text for notes added in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Établit le corps du texte par défaut des notes ajoutées à l\'écran de priorité dans la synthèse de la demande de l\'interface agent.',
        'Sets the default body text for notes added in the ticket responsible screen of the agent interface.' =>
            'Établit le corps du texte par défaut des notes ajoutées à l\'écran du responsable de la demande de l\'interface agent.',
        'Sets the default error message for the login screen on Agent and Customer interface, it\'s shown when a running system maintenance period is active.' =>
            '',
        'Sets the default link type of split tickets in the agent interface.' =>
            '',
        'Sets the default link type of splitted tickets in the agent interface.' =>
            'Établit le type de lien par défaut des demandes partagées de l\'interface agent.',
        'Sets the default message for the login screen on Agent and Customer interface, it\'s shown when a running system maintenance period is active.' =>
            '',
        'Sets the default message for the notification is shown on a running system maintenance period.' =>
            '',
        'Sets the default next state for new phone tickets in the agent interface.' =>
            'Établit l\'état suivant par défaut des nouvelles demandes téléphoniques dans l\'interface agent.',
        'Sets the default next ticket state, after the creation of an email ticket in the agent interface.' =>
            'Établit l\'état suivant par défaut des demandes après la création d\'une demande par courriel dans l\'interface agent.',
        'Sets the default note text for new telephone tickets. E.g \'New ticket via call\' in the agent interface.' =>
            'Établit le texte par défaut de la note dans les nouvelles demandes téléphoniques dans l\'interface agent, par exemple : « Nouvelle demande téléphonique ».',
        'Sets the default priority for new email tickets in the agent interface.' =>
            'Établit la priorité par défaut des nouvelles demandes par courriel dans l\'interface agent.',
        'Sets the default priority for new phone tickets in the agent interface.' =>
            'Établit la priorité par défaut des nouvelles demandes téléphoniques dans l\'interface agent.',
        'Sets the default sender type for new email tickets in the agent interface.' =>
            'Établit le type d\'expéditeur par défaut des nouvelles demandes par courriel dans l\'interface agent.',
        'Sets the default sender type for new phone ticket in the agent interface.' =>
            'Établit le type d\'expéditeur par défaut des nouvelles demandes téléphoniques dans l\'interface agent.',
        'Sets the default subject for new email tickets (e.g. \'email Outbound\') in the agent interface.' =>
            'Établit le sujet par défaut des nouvelles demandes par courriel dans l\'interface agent (p. ex. « Courriel sortant »).',
        'Sets the default subject for new phone tickets (e.g. \'Phone call\') in the agent interface.' =>
            'Établit le sujet par défaut des nouvelles demandes téléphoniques dans l\'interface agent (p. ex. « Appel téléphonique »).',
        'Sets the default subject for notes added in the close ticket screen of the agent interface.' =>
            'Établit le sujet par défaut des notes ajoutées à l\'écran de fermeture de la demande de l\'interface agent.',
        'Sets the default subject for notes added in the ticket move screen of the agent interface.' =>
            'Établit le sujet par défaut des notes ajoutées à l\'écran de déplacement des demandes de l\'interface agent.',
        'Sets the default subject for notes added in the ticket note screen of the agent interface.' =>
            'Établit le sujet par défaut des notes ajoutées à l\'écran de notes de la demande de l\'interface agent.',
        'Sets the default subject for notes added in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Établit le sujet par défaut des notes ajoutées à l\'écran du propriétaire dans la synthèse de la demande de l\'interface agent.',
        'Sets the default subject for notes added in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Établit le sujet par défaut des notes ajoutées à l\'écran de mise en attente dans la synthèse de la demande de l\'interface agent.',
        'Sets the default subject for notes added in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Établit le sujet par défaut des notes ajoutées à l\'écran de priorité dans la synthèse de la demande de l\'interface agent.',
        'Sets the default subject for notes added in the ticket responsible screen of the agent interface.' =>
            'Établit le sujet par défaut des notes ajoutées à l\'écran du responsable de la demande de l\'interface agent.',
        'Sets the default text for new email tickets in the agent interface.' =>
            'Établit le texte par défaut des nouvelles demandes par courriel de l\'interface agent.',
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
            'Établit le nombre de lignes affichées dans les messages (p. ex. lignes affichées par demande dans la file de synthèse (QueueZoom).',
        'Sets the options for PGP binary.' => 'Établit les options de code binaire du logiciel PGP.',
        'Sets the password for private PGP key.' => 'Établit le mot de passe pour une clé PGP privée.',
        'Sets the prefered time units (e.g. work units, hours, minutes).' =>
            'Établit les unités de temps préférées (p. ex. unité de travail, heures, minutes).',
        'Sets the preferred digest to be used for PGP binary.' => '',
        'Sets the prefix to the scripts folder on the server, as configured on the web server. This setting is used as a variable, OTRS_CONFIG_ScriptAlias which is found in all forms of messaging used by the application, to build links to the tickets within the system.' =>
            'Établit le préfix du fichier de script sur le serveur, compte tenu de sa configuration sur le serveur Web. Le réglage est utilisé en tant que variable, OTRS_CONFIG_ScriptAlias est trouvé sous toutes les formes de message utilisé par l\'application afin de créer des liens vers les demandes du système.',
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
            'Établit l\'agent responsable de la demande dans l\'écran de fermeture de l\'interface agent.',
        'Sets the responsible agent of the ticket in the ticket bulk screen of the agent interface.' =>
            'Établit l\'agent responsable de la demande dans l\'écran de demandes groupées de l\'interface agent.',
        'Sets the responsible agent of the ticket in the ticket free text screen of the agent interface.' =>
            'Établit l\'agent responsable de la demande dans l\'écran de texte libre de l\'interface agent.',
        'Sets the responsible agent of the ticket in the ticket note screen of the agent interface.' =>
            'Établit l\'agent responsable de la demande dans l\'écran de notes de l\'interface agent.',
        'Sets the responsible agent of the ticket in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Établit l\'agent responsable de la demande dans l\'écran du propriétaire de la synthèse de la demande de l\'interface agent.',
        'Sets the responsible agent of the ticket in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Établit l\'agent responsable de la demande dans l\'écran de mise en attente de la synthèse de la demande de l\'interface agent.',
        'Sets the responsible agent of the ticket in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Établit l\'agent responsable de la demande dans l\'écran de priorité de la synthèse de la demande de l\'interface agent.',
        'Sets the responsible agent of the ticket in the ticket responsible screen of the agent interface.' =>
            'Établit l\'agent responsable de la demande dans l\'écran du responsable de l\'interface agent.',
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
        'Sets the stats hook.' => 'Règle le point d\'accueil pour le logiciel de statistiques.',
        'Sets the ticket owner in the close ticket screen of the agent interface.' =>
            'Règle le propriétaire de la demande dans l\'écran de fermeture de l\'interface agent.',
        'Sets the ticket owner in the ticket bulk screen of the agent interface.' =>
            'Règle le propriétaire de la demande dans l\'écran d\'action groupée de l\'interface agent.',
        'Sets the ticket owner in the ticket free text screen of the agent interface.' =>
            'Règle le propriétaire de la demande dans l\'écran de texte libre de l\'interface agent.',
        'Sets the ticket owner in the ticket note screen of the agent interface.' =>
            'Règle le propriétaire de la demande dans l\'écran de notes de l\'interface agent.',
        'Sets the ticket owner in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Règle le propriétaire de la demande dans l\'écran de propriété de la synthèse de la demande dans l\'interface agent.',
        'Sets the ticket owner in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Règle le propriétaire de la demande dans l\'écran de mise en attente de la synthèse de la demande dans l\'interface agent.',
        'Sets the ticket owner in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Règle le propriétaire de la demande dans l\'écran de priorité de la synthèse de la demande dans l\'interface agent.',
        'Sets the ticket owner in the ticket responsible screen of the agent interface.' =>
            'Règle le propriétaire de la demande dans l\'écran de responsabilité de l\'interface agent.',
        'Sets the ticket type in the close ticket screen of the agent interface (Ticket::Type needs to be enabled).' =>
            '',
        'Sets the ticket type in the ticket bulk screen of the agent interface.' =>
            'Règle le type de demande dans l\'écran d\'action groupée de l\'interface agent.',
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
        'Sets the timeout (in seconds) for http/ftp downloads.' => 'Règle le délai (en secondes) des téléchargements HTTP ou FTP.',
        'Sets the timeout (in seconds) for package downloads. Overwrites "WebUserAgent::Timeout".' =>
            'Règle le délai (en secondes) des téléchargements de paquets. Écrase le délai des agents utilisateurs Web « WebUserAgent::Timeout ».',
        'Shared Secret' => '',
        'Show a responsible selection in phone and email tickets in the agent interface.' =>
            'Affiche la sélection des responsables dans les demandes par courriel ou par téléphone de l\'interface agent.',
        'Show article as rich text even if rich text writing is disabled.' =>
            'Affiche les articles en RTF même si l\'option d\'écriture RTF est désactivée.',
        'Show command line output.' => '',
        'Show queues even when only locked tickets are in.' => '',
        'Show the current owner in the customer interface.' => '',
        'Show the current queue in the customer interface.' => '',
        'Show the history for this ticket' => '',
        'Show the ticket history' => 'Afficher l\'historique de la demande',
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
            'Dans le menu, affiche un lien qui permet l\'ajout d\'une note dans chaque visualisation de la demande de l\'interface agent.',
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
            'Dans le menu, affiche un lien qui permet la fermeture d\'une demande dans chaque visualisation de la demande de l\'interface agent.',
        'Shows a link in the menu to close a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to delete a ticket in every ticket overview of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Dans le menu, affiche un lien qui permet la suppression d\'une demande dans chaque visualisation de la demande de l\'interface agent. Des contrôles d\'accès supplémentaires pour permettre l\'affichage ou non de ce lien peuvent être effectués en utilisant la clé « Group » (groupe) et un contenu tel que « rw:group1;move_into:group2 » (lecture et écriture : groupe 1; déplacer:groupe 2). ',
        'Shows a link in the menu to delete a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to enroll a ticket into a process in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to go back in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to lock / unlock a ticket in the ticket overviews of the agent interface.' =>
            'Dans le menu, affiche un lien qui permet de verrouiller ou de déverrouiller une demande dans les visualisations des demandes de l\'interface agent.',
        'Shows a link in the menu to lock/unlock tickets in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to move a ticket in every ticket overview of the agent interface.' =>
            'Dans le menu, affiche un lien qui permet le déplacement d\'une demande dans chaque visualisation de demandes de l\'interface agent.',
        'Shows a link in the menu to print a ticket or an article in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to see the history of a ticket in every ticket overview of the agent interface.' =>
            'Dans le menu, affiche un lien qui permet de voir l\'historique d\'une demande dans chaque visualisation de demandes de l\'interface agent.',
        'Shows a link in the menu to see the priority of a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to send an outbound email in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to set a ticket as junk in every ticket overview of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Shows a link in the menu to set a ticket as pending in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to set the priority of a ticket in every ticket overview of the agent interface.' =>
            'Dans le menu, affiche un lien qui permet le réglage de la priorité d\'une demande dans chaque visualisation de la demande de l\'interface agent.',
        'Shows a link in the menu to zoom a ticket in the ticket overviews of the agent interface.' =>
            'Dans le menu, affiche un lien afin de faire la synthèse de la demande dans les visualisations des demandes de l\'interface agent.',
        'Shows a link to access article attachments via a html online viewer in the zoom view of the article in the agent interface.' =>
            'Affiche un lien pour accéder aux pièces jointes aux articles au moyen d\'un visualiseur html en ligne dans la vue de la synthèse de l\'article de l\'interface agent.',
        'Shows a link to download article attachments in the zoom view of the article in the agent interface.' =>
            'Affiche un lien pour télécharger les pièces jointes aux articles dans la vue de la synthèse de l\'article de l\'interface agent.',
        'Shows a link to see a zoomed email ticket in plain text.' => 'Affiche un lien pour voir une synthèse de la demande par courriel en texte en clair.',
        'Shows a link to set a ticket as junk in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a list of all the involved agents on this ticket, in the close ticket screen of the agent interface.' =>
            'Affiche une liste des agents qui participent au traitement de la demande dans l\'écran de fermeture de la demande de l\'interface agent.',
        'Shows a list of all the involved agents on this ticket, in the ticket free text screen of the agent interface.' =>
            'Affiche une liste des agents qui participent au traitement de la demande dans l\'écran de texte libre de la demande de l\'interface agent.',
        'Shows a list of all the involved agents on this ticket, in the ticket note screen of the agent interface.' =>
            'Affiche une liste des agents qui participent au traitement de la demande dans l\'écran de notes de la demande de l\'interface agent.',
        'Shows a list of all the involved agents on this ticket, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Affiche une liste des agents qui participent au traitement de la demande dans l\'écran du propriétaire de la synthèse de la demande de l\'interface agent.',
        'Shows a list of all the involved agents on this ticket, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Affiche une liste des agents qui participent au traitement de la demande dans l\'écran de mise en attente de la synthèse de la demande de l\'interface agent.',
        'Shows a list of all the involved agents on this ticket, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Affiche une liste des agents qui participent au traitement de la demande dans l\'écran de priorité de la synthèse de la demande de l\'interface agent.',
        'Shows a list of all the involved agents on this ticket, in the ticket responsible screen of the agent interface.' =>
            'Affiche une liste des agents qui participent au traitement de la demande dans l\'écran du responsable de la demande de l\'interface agent.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the close ticket screen of the agent interface.' =>
            'Affiche une liste de tous les agents qui ont les permissions requises de la file ou de la demande afin de déterminer lequel ou lesquels devraient être informés de ces permissions dans l\'écran de fermeture de la demande de l\'interface agent.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket free text screen of the agent interface.' =>
            'Affiche une liste de tous les agents qui ont les permissions requises de la file ou de la demande afin de déterminer lequel ou lesquels devraient être informés de ces permissions dans l\'écran de texte libre de la demande de l\'interface agent.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket note screen of the agent interface.' =>
            'Affiche une liste de tous les agents qui ont les permissions requises de la file ou de la demande afin de déterminer lequel ou lesquels devraient être informés de ces permissions dans l\'écran de notes de la demande de l\'interface agent.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Affiche une liste de tous les agents qui ont les permissions requises de la file ou de la demande afin de déterminer lequel ou lesquels devraient être informés de ces permissions dans l\'écran du propriétaire de la synthèse de la demande de l\'interface agent.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Affiche une liste de tous les agents qui ont les permissions requises de la file ou de la demande afin de déterminer lequel ou lesquels devraient être informés de ces permissions dans l\'écran de mise en attente de la synthèse de la demande de l\'interface agent.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Affiche une liste de tous les agents qui ont les permissions requises de la file ou de la demande afin de déterminer lequel ou lesquels devraient être informés de ces permissions dans l\'écran de priorité de la synthèse de la demande de l\'interface agent.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket responsible screen of the agent interface.' =>
            'Affiche une liste de tous les agents qui ont les permissions requises de la file ou de la demande afin de déterminer lequel ou lesquels devraient être informés de ces permissions dans l\'écran du responsable de la demande de l\'interface agent.',
        'Shows a preview of the ticket overview (CustomerInfo => 1 - shows also Customer-Info, CustomerInfoMaxSize max. size in characters of Customer-Info).' =>
            'Affiche la visualisation de la demande en format « L » (Grand) (« CustomerInfo => 1 - » affiche l\'information relative aux clients, et « CustomerInfoMaxSize » affiche la taille maximale, en caractères, de l\'information relative aux clients.)',
        'Shows a teaser link in the menu for the ticket attachment view of OTRS Business Solution™.' =>
            '',
        'Shows all both ro and rw queues in the queue view.' => 'Affiche les files en lecture seule et en lecture et écriture dans la vue des files.',
        'Shows all both ro and rw tickets in the service view.' => '',
        'Shows all open tickets (even if they are locked) in the escalation view of the agent interface.' =>
            'Affiche les demandes ouvertes (même si elles sont verrouillées) dans la vue de l\'escalade de l\'interface agent.',
        'Shows all the articles of the ticket (expanded) in the agent zoom view.' =>
            '',
        'Shows all the articles of the ticket (expanded) in the customer zoom view.' =>
            '',
        'Shows all the customer identifiers in a multi-select field (not useful if you have a lot of customer identifiers).' =>
            'Affiche les identifiants clients dans un champ de sélections multiples (n\'est pas utile si vous avez de nombreux identifiants clients).',
        'Shows all the customer user identifiers in a multi-select field (not useful if you have a lot of customer user identifiers).' =>
            '',
        'Shows an owner selection in phone and email tickets in the agent interface.' =>
            'Affiche la sélection de propriétaires de demandes par courriel ou par téléphone de l\'interface agent.',
        'Shows customer history tickets in AgentTicketPhone, AgentTicketEmail and AgentTicketCustomer.' =>
            'Affiche l\'historique des demandes de clients dans les « Demandes téléphoniques de l\'agent » (AgentTicketPhone), les « Demandes par courriel de l\'agent » (AgentTicketEmail) et les « Demandes des clients de l\'agent » (AgentTicketCustomer).',
        'Shows either the last customer article\'s subject or the ticket title in the small format overview.' =>
            'Affiche soit le sujet du dernier article du client ou le titre de la demande dans la visualisation en format « S » (Petit).',
        'Shows existing parent/child queue lists in the system in the form of a tree or a list.' =>
            'Affiche les listes de files existantes dans le système de type parents et enfants sous la forme d\'une arborescence ou d\'une liste.',
        'Shows information on how to start OTRS Daemon' => '',
        'Shows link to external page in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Shows the article head information in the agent zoom view.' => '',
        'Shows the articles sorted normally or in reverse, under ticket zoom in the agent interface.' =>
            'Affiche les articles triés dans l\'ordre habituel ou inverse dans la synthèse de la demande de l\'interface agent. ',
        'Shows the customer user information (phone and email) in the compose screen.' =>
            'Affiche les renseignements de l\'utilisateur client (numéro de téléphone et adresse de courrier électronique) dans l\'écran de rédaction.',
        'Shows the enabled ticket attributes in the customer interface (0 = Disabled and 1 = Enabled).' =>
            '',
        'Shows the message of the day (MOTD) in the agent dashboard. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            '',
        'Shows the message of the day on login screen of the agent interface.' =>
            'Affiche le message du jour dans l\'écran d\'ouverture de session de l\'interface agent.',
        'Shows the ticket history (reverse ordered) in the agent interface.' =>
            'Affiche l\'historique de la demande (en ordre décroissant) dans l\'interface agent.',
        'Shows the ticket priority options in the close ticket screen of the agent interface.' =>
            'Affiche le choix de priorités de la demande dans l\'écran de fermeture de l\'interface agent.',
        'Shows the ticket priority options in the move ticket screen of the agent interface.' =>
            'Affiche le choix de priorités de la demande dans l\'écran de déplacement de l\'interface agent.',
        'Shows the ticket priority options in the ticket bulk screen of the agent interface.' =>
            'Affiche le choix de priorités de la demande dans l\'écran de demandes groupées de l\'interface agent.',
        'Shows the ticket priority options in the ticket free text screen of the agent interface.' =>
            'Affiche le choix de priorités de la demande dans l\'écran de texte libre de l\'interface agent.',
        'Shows the ticket priority options in the ticket note screen of the agent interface.' =>
            'Affiche le choix de priorités de la demande dans l\'écran de notes de l\'interface agent.',
        'Shows the ticket priority options in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Affiche le choix de priorités de la demande dans l\'écran du propriétaire de la synthèse de la demande de l\'interface agent.',
        'Shows the ticket priority options in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Affiche le choix de priorités de la demande dans l\'écran de mise en attente de la synthèse de la demande de l\'interface agent.',
        'Shows the ticket priority options in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Affiche le choix de priorités de la demande dans l\'écran de priorité de la synthèse de la demande de l\'interface agent.',
        'Shows the ticket priority options in the ticket responsible screen of the agent interface.' =>
            'Affiche le choix de priorités de la demande dans l\'écran du responsable de l\'interface agent.',
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
        'Signatures' => 'Signatures',
        'Simple' => '',
        'Skin' => 'Habillage ',
        'Slovak' => '',
        'Slovenian' => '',
        'Small' => 'Petit (S)',
        'Software Package Manager.' => '',
        'Solution time' => '',
        'SolutionDiffInMin' => '',
        'SolutionInMin' => '',
        'Some description!' => '',
        'Some picture description!' => '',
        'Sorts the tickets (ascendingly or descendingly) when a single queue is selected in the queue view and after the tickets are sorted by priority. Values: 0 = ascending (oldest on top, default), 1 = descending (youngest on top). Use the QueueID for the key and 0 or 1 for value.' =>
            'Classe les demandes (en ordre croissant ou décroissant) lorsqu\'une seule file est sélectionnée dans la vue des files et après que les demandes sont classées par priorité. Valeurs : 0 = en ordre croissant (Par défaut, la plus ancienne en haut de la file), 1 = en ordre décroissant (la plus récente en haut de la file). Utilise l\'identification de la file (QueueID) en tant que clé et « 0 » ou « 1 » en tant que valeur.',
        'Sorts the tickets (ascendingly or descendingly) when a single queue is selected in the service view and after the tickets are sorted by priority. Values: 0 = ascending (oldest on top, default), 1 = descending (youngest on top). Use the ServiceID for the key and 0 or 1 for value.' =>
            '',
        'Spam' => 'Pourriel',
        'Spam Assassin example setup. Ignores emails that are marked with SpamAssassin.' =>
            'Exemple de réglage du logiciel « Spam Assassin ». Ignore les courriels comportant des « SpamAssassin ».',
        'Spam Assassin example setup. Moves marked mails to spam queue.' =>
            'Exemple de réglage du logiciel « Spam Assassin ». Déplace les courriels comportant des « SpamAssasin » dans la file de pourriels.',
        'Spanish' => '',
        'Spanish (Colombia)' => '',
        'Spanish (Mexico)' => '',
        'Spanish stop words for fulltext index. These words will be removed from the search index.' =>
            '',
        'Specifies if an agent should receive email notification of his own actions.' =>
            'Précise si un agent devrait recevoir un courriel de notification pour ses propres actions.',
        'Specifies the directory to store the data in, if "FS" was selected for ArticleStorage.' =>
            '',
        'Specifies the directory where SSL certificates are stored.' => 'Précise le répertoire dans lequel les certificats SSL sont enregistrés.',
        'Specifies the directory where private SSL certificates are stored.' =>
            'Précise le répertoire dans lequel les certificats SSL privés sont enregistrés.',
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
            'Précise le chemin menant au fichier du logo de l\'en-tête de page (gif ou jpg ou png, de 700 x 100 pixels).',
        'Specifies the path of the file for the performance log.' => 'Précise le chemin menant au fichier pour l\'enregistrement des performances.',
        'Specifies the path to the converter that allows the view of Microsoft Excel files, in the web interface.' =>
            'Précise le chemin menant au convertisseur qui permet la vue des fichiers Microsoft Excel dans l\'interface Web.',
        'Specifies the path to the converter that allows the view of Microsoft Word files, in the web interface.' =>
            'Précise le chemin menant au convertisseur qui permet la vue des fichiers Microsoft Word dans l\'interface Web.',
        'Specifies the path to the converter that allows the view of PDF documents, in the web interface.' =>
            'Précise le chemin menant au convertisseur qui permet la vue des documents PDF dans l\'interface Web.',
        'Specifies the path to the converter that allows the view of XML files, in the web interface.' =>
            'Précise le chemin menant au convertisseur qui permet la vue des fichiers XML dans l\'interface Web.',
        'Specifies the text that should appear in the log file to denote a CGI script entry.' =>
            'Précise le texte qui doit apparaître dans le fichier journal pour indiquer l\'entrée d\'un script CGI.',
        'Specifies user id of the postmaster data base.' => 'Précise l\'identification de l\'utilisateur de la base de données du maître de poste.',
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
            'Permissions couramment accordées aux agents dans cette application. Des permissions supplémentaires peuvent être inscrites dans ces champs. Les permissions doivent être définies pour être efficaces. Quelques permissions prédéfinies ont été fournies : note, fermer, en attente, client, texte libre, déplacer, rédiger, responsable, transférer et retourner. Assurez-vous que « rw » (lecture et écriture) soit toujours la dernière permission enregistrée.',
        'Start number for statistics counting. Every new stat increments this number.' =>
            'Chiffre de départ du dénombrement statistique. Chaque nouvelle statistique incrémente ce chiffre.',
        'Started response time escalation.' => '',
        'Started solution time escalation.' => '',
        'Started update time escalation.' => '',
        'Starts a wildcard search of the active object after the link object mask is started.' =>
            'Démarre une recherche de caractères de remplacement de l\'object actif après le démarrage du masque de l\'objet lié.',
        'Stat#' => 'Statistique no ',
        'States' => 'État ',
        'Statistic Reports overview.' => '',
        'Statistics overview.' => '',
        'Status view' => 'Vue des états ',
        'Stopped response time escalation.' => '',
        'Stopped solution time escalation.' => '',
        'Stopped update time escalation.' => '',
        'Stores cookies after the browser has been closed.' => 'Enregistre les témoins de connexion après la fermeture du navigateur',
        'Strips empty lines on the ticket preview in the queue view.' => 'Élimine les lignes vides dans l\'aperçu de la demande de la vue des files.',
        'Strips empty lines on the ticket preview in the service view.' =>
            '',
        'Support Agent' => '',
        'Swahili' => '',
        'Swedish' => '',
        'System Address Display Name' => '',
        'System Configuration Deployment' => '',
        'System Configuration Group' => '',
        'System Maintenance' => '',
        'Templates ↔ Attachments' => '',
        'Templates ↔ Queues' => '',
        'Textarea' => 'Zone de texte',
        'Thai' => '',
        'The PGP signature is expired.' => '',
        'The PGP signature was made by a revoked key, this could mean that the signature is forged.' =>
            '',
        'The PGP signature was made by an expired key.' => '',
        'The PGP signature with the keyid has not been verified successfully.' =>
            '',
        'The PGP signature with the keyid is good.' => '',
        'The agent skin\'s InternalName which should be used in the agent interface. Please check the available skins in Frontend::Agent::Skins.' =>
            'Ceci est le nom interne (InternalName) qui devrait être utilisé pour l\'habillage dans l\'interface de l\'agent. Veuillez vérifier les habillages disponibles dans « Frontend::Agent::Skins ».',
        'The customer skin\'s InternalName which should be used in the customer interface. Please check the available skins in Frontend::Customer::Skins.' =>
            'Ceci est le nom interne (InternalName) qui devrait être utilisé pour l\'habillage dans l\'interface du client. Veuillez vérifier les habillages disponibles dans « Frontend::Customer::Skins ».',
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
            'Le séparateur entre le point d\'accueil de la demande (TicketHook) et le numéro de la demande. Par ex. « \': ou \'. »',
        'The duration in minutes after emitting an event, in which the new escalation notify and start events are suppressed.' =>
            'La période en minutes, à la suite de l\'émission d\'un événement, après laquelle la notification d\'une nouvelle escalade et le démarrage d\'événements sont supprimés. ',
        'The format of the subject. \'Left\' means \'[TicketHook#:12345] Some Subject\', \'Right\' means \'Some Subject [TicketHook#:12345]\', \'None\' means \'Some Subject\' and no ticket number. In the latter case you should verify that the setting PostMaster::CheckFollowUpModule###0200-References is activated to recognize followups based on email headers.' =>
            '',
        'The headline shown in the customer interface.' => 'Le titre vedette affiché dans l\'interface client.',
        'The identifier for a ticket, e.g. Ticket#, Call#, MyTicket#. The default is Ticket#.' =>
            'L\'identifiant d\'une demande, par ex. Demande no , Appel no , Ma demande no. Par défaut, c\'est le numéro de demande qui apparaîtra.',
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
            'Le logo affiché dans l\'en-tête de l\'interface agent. L\'adresse URL vers l\'image peut être une adresse relative vers le répertoire d\'habillages ou une adresse complète vers un serveur Web distant.',
        'The logo shown in the header of the customer interface. The URL to the image can be a relative URL to the skin image directory, or a full URL to a remote web server.' =>
            'Le logo affiché dans l\'en-tête de l\'interface client. L\'adresse URL vers l\'image peut être une adresse relative vers le répertoire d\'habillages ou une adresse complète vers un serveur Web distant.',
        'The logo shown on top of the login box of the agent interface. The URL to the image can be a relative URL to the skin image directory, or a full URL to a remote web server.' =>
            '',
        'The maximal number of articles expanded on a single page in AgentTicketZoom.' =>
            '',
        'The maximal number of articles shown on a single page in AgentTicketZoom.' =>
            '',
        'The maximum number of mails fetched at once before reconnecting to the server.' =>
            '',
        'The secret you supplied is invalid. The secret must only contain letters (A-Z, uppercase) and numbers (2-7) and must consist of 16 characters.' =>
            '',
        'The text at the beginning of the subject in an email reply, e.g. RE, AW, or AS.' =>
            'Le texte affiché en début de sujet dans une réponse courriel, p. ex. : Rép.',
        'The text at the beginning of the subject when an email is forwarded, e.g. FW, Fwd, or WG.' =>
            'Le texte affiché en début de sujet lorsqu\'un courriel est transféré, p. ex. : Tr.',
        'The value of the From field' => '',
        'Theme' => 'Thème ',
        'This event module stores attributes from CustomerUser as DynamicFields tickets. Please see DynamicFieldFromCustomerUser::Mapping setting for how to configure the mapping.' =>
            '',
        'This is a Description for Comment on Framework.' => '',
        'This is a Description for DynamicField on Framework.' => '',
        'This is the default orange - black skin for the customer interface.' =>
            '',
        'This is the default orange - black skin.' => '',
        'This key is not certified with a trusted signature!' => '',
        'This module and its PreRun() function will be executed, if defined, for every request. This module is useful to check some user options or to display news about new applications.' =>
            'Le module et la fonction d\'avant exécution seront exécutés pour chacune des requêtes (si précisé). Le module s\'avère utile pour vérifier certaines options des utilisateurs ou pour afficher des nouvelles au sujet des dernières applications offertes.',
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
            'Le réglage vous permet de modifier la liste prédéfinie des pays. La modification peut-être particulièrement utile si vous souhaitez travailler avec une courte liste de pays.',
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
        'Ticket Notifications' => '',
        'Ticket Outbound Email.' => '',
        'Ticket Overview "Medium" Limit' => 'Limites de l\'affichage « M » (Moyen) ',
        'Ticket Overview "Preview" Limit' => 'Limites de l\'affichage « L » (Grand) ',
        'Ticket Overview "Small" Limit' => 'Limites de l\'affichage « S » (Petit ) ',
        'Ticket Owner.' => '',
        'Ticket Pending.' => '',
        'Ticket Print.' => '',
        'Ticket Priority.' => '',
        'Ticket Queue Overview' => 'État des files',
        'Ticket Responsible.' => '',
        'Ticket Watcher' => '',
        'Ticket Zoom' => '',
        'Ticket Zoom.' => '',
        'Ticket bulk module.' => '',
        'Ticket event module that triggers the escalation stop events.' =>
            'Module d\'événements des demandes qui déclenche les arrêts d\'escalade.',
        'Ticket limit per page for Ticket Overview "Medium".' => '',
        'Ticket limit per page for Ticket Overview "Preview".' => '',
        'Ticket limit per page for Ticket Overview "Small".' => '',
        'Ticket notifications' => '',
        'Ticket overview' => 'Visualisation de la demande ',
        'Ticket plain view of an email.' => '',
        'Ticket split dialog.' => '',
        'Ticket title' => '',
        'Ticket zoom view.' => '',
        'TicketNumber' => '',
        'Tickets.' => '',
        'Time in seconds that gets added to the actual time if setting a pending-state (default: 86400 = 1 day).' =>
            'Temps, en secondes, à ajouter à l\'heure actuelle dans le cas d\'une mise en attente (par défaut : 86400 = 1 jour).',
        'To accept login information, such as an EULA or license.' => '',
        'To download attachments.' => 'Pour télécharger les pièces jointes.',
        'To view HTML attachments.' => '',
        'Toggles display of OTRS FeatureAddons list in PackageManager.' =>
            'Permet de basculer dans l\'affichage de la liste des fonctions des compagnons de OTRS dans le gestionnaire de paquets.',
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
        'Unlocked ticket.' => 'Demande déverrouillée.',
        'Up' => 'Chronologique croissant',
        'Upcoming Events' => 'Évènements à venir',
        'Update Ticket "Seen" flag if every article got seen or a new Article got created.' =>
            'Met à jour l\'indicateur de prise de connaissance (vue) de la demande si chacun des articles ont été vus ou qu\'un nouvel article a été créé.',
        'Update time' => '',
        'Updates the ticket escalation index after a ticket attribute got updated.' =>
            'Met à jour l\'index des escalades des demandes après qu\'un attribut de demande a été mis à jour.',
        'Updates the ticket index accelerator.' => 'Effectue la mise à jour de l\'accélérateur de l\'index des demandes.',
        'Upload your PGP key.' => '',
        'Upload your S/MIME certificate.' => '',
        'Use new type of select and autocomplete fields in agent interface, where applicable (InputFields).' =>
            '',
        'Use new type of select and autocomplete fields in customer interface, where applicable (InputFields).' =>
            '',
        'User Profile' => 'Profil utilisateur',
        'UserFirstname' => '',
        'UserLastname' => '',
        'Users, Groups & Roles' => '',
        'Uses richtext for viewing and editing ticket notification.' => '',
        'Uses richtext for viewing and editing: articles, salutations, signatures, standard templates, auto responses and notifications.' =>
            '',
        'Vietnam' => '',
        'View all attachments of the current ticket' => '',
        'View performance benchmark results.' => 'Voir les résultats du test de performance.',
        'Watch this ticket' => '',
        'Watched Tickets' => 'Demandes sous surveillance',
        'Watched Tickets.' => '',
        'We are performing scheduled maintenance.' => '',
        'We are performing scheduled maintenance. Login is temporarily not available.' =>
            '',
        'We are performing scheduled maintenance. We should be back online shortly.' =>
            '',
        'Web Services' => 'Services Web',
        'Web View' => '',
        'When agent creates a ticket, whether or not the ticket is automatically locked to the agent.' =>
            '',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. Here you can define the body of this note (this text cannot be changed by the agent).' =>
            '',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. Here you can define the subject of this note (this subject cannot be changed by the agent).' =>
            '',
        'When tickets are merged, the customer can be informed per email by setting the check box "Inform Sender". In this text area, you can define a pre-formatted text which can later be modified by the agents.' =>
            'Lorsque des demandes sont fusionnées, le client peut en être informé par courriel en cochant la case « Informer l\'expéditeur ». Vous pouvez définir un texte pré-formaté qui pourra ensuite être modifié par les agents.',
        'Whether or not to collect meta information from articles using filters configured in Ticket::Frontend::ZoomCollectMetaFilters.' =>
            '',
        'Whether to force redirect all requests from http to https protocol. Please check that your web server is configured correctly for https protocol before enable this option.' =>
            '',
        'Yes, but hide archived tickets' => '',
        'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further information.' =>
            '',
        'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' =>
            'Le courriel portant le numéro de demande « <OTRS_TICKET> » a été fusionné avec la demande numéro « <OTRS_MERGE_TO_TICKET> ».',
        'Your queue selection of your preferred queues. You also get notified about those queues via email if enabled.' =>
            '',
        'Your service selection of your preferred services. You also get notified about those services via email if enabled.' =>
            '',
        'Zoom' => 'Détails',
        'attachment' => '',
        'bounce' => '',
        'compose' => '',
        'debug' => '',
        'error' => '',
        'forward' => '',
        'info' => '',
        'inline' => '',
        'normal' => 'normal',
        'notice' => '',
        'pending' => '',
        'phone' => 'téléphone ',
        'responsible' => '',
        'reverse' => 'inverse',
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
