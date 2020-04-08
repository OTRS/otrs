# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::gl;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # $$START$$
    # possible charsets
    $Self->{Charset} = ['utf-8', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Year;)
    $Self->{DateFormat}          = '%D/%M/%Y - %T';
    $Self->{DateFormatLong}      = '%A, %D %B %Y - %T';
    $Self->{DateFormatShort}     = '%D/%M/%Y';
    $Self->{DateInputFormat}     = '%D/%M/%Y';
    $Self->{DateInputFormatLong} = '%D/%M/%Y - %T';
    $Self->{Completeness}        = 0.513714866237724;

    # csv separator
    $Self->{Separator}         = ';';

    $Self->{DecimalSeparator}  = ',';
    $Self->{ThousandSeparator} = '.';
    $Self->{Translation} = {

        # Template: AdminACL
        'ACL Management' => 'Xestión de ACL',
        'Actions' => 'Accións',
        'Create New ACL' => 'Crear unha ACL nova',
        'Deploy ACLs' => 'Despréguese para ACLs',
        'Export ACLs' => 'Exporte ACLs',
        'Filter for ACLs' => 'Filtro para ACLs',
        'Just start typing to filter...' => 'Comece a escribir un filtro...',
        'Configuration Import' => 'Importar Configuración',
        'Here you can upload a configuration file to import ACLs to your system. The file needs to be in .yml format as exported by the ACL editor module.' =>
            'Aquí poderá actualizar o arquivo de configuración para importar ACLs o seu sistema. O arquivo necesita ser no formato .yml coma exportado polo módulo editor ACL.',
        'This field is required.' => 'Este campo é obrigatorio',
        'Overwrite existing ACLs?' => 'Sobrescribir ACLs existentes?',
        'Upload ACL configuration' => 'Configuración da actualización do ACL',
        'Import ACL configuration(s)' => 'Importar a(s) configuración(s) de ACL',
        'Description' => 'Descrición',
        'To create a new ACL you can either import ACLs which were exported from another system or create a complete new one.' =>
            'Para crear un novo ACL pode importar ACLs que foran exportados doutros sistemas ou crear un completamente novo.',
        'Changes to the ACLs here only affect the behavior of the system, if you deploy the ACL data afterwards. By deploying the ACL data, the newly made changes will be written to the configuration.' =>
            'Os cambios nos ACLs feitos aquí so afectan o comportamiento do sistema, se despréganse os datos do ACL despois.Despregando os datos de ACL, os cambios feitos de novo serán gardados na configuración.',
        'ACLs' => 'ACL',
        'Please note: This table represents the execution order of the ACLs. If you need to change the order in which ACLs are executed, please change the names of the affected ACLs.' =>
            'Por favor fíxese: Esta táboa representa a execución da orse dos ACLs. Se necesita cambialo orden no que os ACLs son executados, por favor cambie os nomes dos ACLs afectados.',
        'ACL name' => 'Nome de ACL',
        'Comment' => 'Comentario',
        'Validity' => 'Validez',
        'Export' => 'Exportar',
        'Copy' => 'Copiar',
        'No data found.' => 'Non se atoparon datos.',
        'No matches found.' => 'Non se atopou ningunha coincidencia.',

        # Template: AdminACLEdit
        'Edit ACL %s' => 'ACL editado %s',
        'Edit ACL' => '',
        'Go to overview' => 'Vaia a vista xeral',
        'Delete ACL' => 'Borre ACL',
        'Delete Invalid ACL' => 'Borre ACL invalido',
        'Match settings' => 'Axustes de correspondencia',
        'Set up matching criteria for this ACL. Use \'Properties\' to match the current screen or \'PropertiesDatabase\' to match attributes of the current ticket that are in the database.' =>
            'Axuste o criterio da correspondencia para este ACL. Use \'Propiedades\' para atopar o pantalla actual ou \'PropiedadesBaseDatos\' para atopar os atributos do ticket actual que está na base de datos.',
        'Change settings' => 'Cambiar a configuración',
        'Set up what you want to change if the criteria match. Keep in mind that \'Possible\' is a white list, \'PossibleNot\' a black list.' =>
            'Estableza que quere cambiar se o criterio é coincidente. Lembre que \'Posible\' e unha lista en branco, \'NoPosible\' é unha lista negra.',
        'Check the official %sdocumentation%s.' => '',
        'Show or hide the content' => 'Mostrar ou agochar o contido',
        'Edit ACL Information' => '',
        'Name' => 'Nome',
        'Stop after match' => 'Pare despois da coincidencia',
        'Edit ACL Structure' => '',
        'Save ACL' => '',
        'Save' => 'Gardar',
        'or' => 'ou',
        'Save and finish' => 'Garde e finalice',
        'Cancel' => 'Cancelar',
        'Do you really want to delete this ACL?' => 'Quere realmente borrar este ACL?',

        # Template: AdminACLNew
        'Create a new ACL by submitting the form data. After creating the ACL, you will be able to add configuration items in edit mode.' =>
            'Cree unha ACL nova enviando os datos do formulario. Após crear a ACL será posíbel engadir elementos de configuración no modo de edición.',

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
        'Overwrite existing entities' => 'Sobreescriba as entidades existentes',
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
        'Group' => 'Grupo',
        'Changed' => 'Cambiado',
        'Created' => 'Creado',
        'Download' => 'Descargar',
        'URL' => '',
        'Export calendar' => '',
        'Download calendar' => '',
        'Copy public calendar URL' => '',
        'Calendar' => 'Calendario',
        'Calendar name' => '',
        'Calendar with same name already exists.' => '',
        'Color' => '',
        'Permission group' => '',
        'Ticket Appointments' => '',
        'Rule' => 'Regra',
        'Remove this entry' => 'Elimine esta entrada',
        'Remove' => 'Retirar',
        'Start date' => 'Data de comezo',
        'End date' => '',
        'Use options below to narrow down for which tickets appointments will be automatically created.' =>
            '',
        'Queues' => 'Filas',
        'Please select a valid queue.' => '',
        'Search attributes' => '',
        'Add entry' => 'Engadir unha entrada',
        'Add' => 'Engadir',
        'Define rules for creating automatic appointments in this calendar based on ticket data.' =>
            '',
        'Add Rule' => '',
        'Submit' => 'Enviar',

        # Template: AdminAppointmentImport
        'Appointment Import' => '',
        'Go back' => 'Retornar',
        'Uploaded file must be in valid iCal format (.ics).' => '',
        'If desired Calendar is not listed here, please make sure that you have at least \'create\' permissions.' =>
            '',
        'Upload' => 'Enviar',
        'Update existing appointments?' => '',
        'All existing appointments in the calendar with same UniqueID will be overwritten.' =>
            '',
        'Upload calendar' => '',
        'Import appointments' => '',

        # Template: AdminAppointmentNotificationEvent
        'Appointment Notification Management' => '',
        'Add Notification' => 'Engadir unha notificación',
        'Edit Notification' => 'Edite Notificación',
        'Export Notifications' => 'Exportar Notificacións',
        'Filter for Notifications' => '',
        'Filter for notifications' => '',
        'Here you can upload a configuration file to import appointment notifications to your system. The file needs to be in .yml format as exported by the appointment notification module.' =>
            '',
        'Overwrite existing notifications?' => 'Sobrescribir notificacións existentes?',
        'Upload Notification configuration' => 'Configuración Notificación de Carga',
        'Import Notification configuration' => 'Importar configuración de Notificación',
        'List' => 'Lista',
        'Delete' => 'Eliminar',
        'Delete this notification' => 'Elimine esta notificación',
        'Show in agent preferences' => 'Mostrar nas preferencias de axente',
        'Agent preferences tooltip' => 'Ferramentas de preferencias de axente',
        'This message will be shown on the agent preferences screen as a tooltip for this notification.' =>
            'Esta mensaxe será mostrada na pantalla de preferencias de axente como ferramenta para esta notificación.',
        'Toggle this widget' => 'Cambiar este Widget',
        'Events' => 'Eventos',
        'Event' => 'Evento',
        'Here you can choose which events will trigger this notification. An additional appointment filter can be applied below to only send for appointments with certain criteria.' =>
            '',
        'Appointment Filter' => '',
        'Type' => 'Tipo',
        'Title' => 'Título',
        'Location' => 'Lugar',
        'Team' => '',
        'Resource' => '',
        'Recipients' => 'Destinatarios',
        'Send to' => 'Enviar a',
        'Send to these agents' => 'Enviar a estes axentes',
        'Send to all group members (agents only)' => '',
        'Send to all role members' => 'Enviar a todos os membros do rol',
        'Send on out of office' => 'Enviar fora da oficina',
        'Also send if the user is currently out of office.' => 'Enviar tamén se o usuario está actualmente fóra da oficina.',
        'Once per day' => 'Unha vez por día',
        'Notify user just once per day about a single appointment using a selected transport.' =>
            '',
        'Notification Methods' => 'Métodos de notificación',
        'These are the possible methods that can be used to send this notification to each of the recipients. Please select at least one method below.' =>
            '',
        'Enable this notification method' => 'Activar este método de notificación',
        'Transport' => 'Transporte',
        'At least one method is needed per notification.' => 'Precísase ao menos un método por notificación.',
        'Active by default in agent preferences' => '',
        'This is the default value for assigned recipient agents who didn\'t make a choice for this notification in their preferences yet. If the box is enabled, the notification will be sent to such agents.' =>
            '',
        'This feature is currently not available.' => 'Esta funcionalidade non está dispoñíbel actualmente.',
        'Upgrade to %s' => 'Mellorado a %s',
        'Please activate this transport in order to use it.' => '',
        'No data found' => 'Non se atoparon datos',
        'No notification method found.' => 'Non se atopou ningún método de notificación.',
        'Notification Text' => 'Texto da notificación',
        'This language is not present or enabled on the system. This notification text could be deleted if it is not needed anymore.' =>
            '',
        'Remove Notification Language' => 'Retirar o idioma da notificación',
        'Subject' => 'Asunto',
        'Text' => 'Texto',
        'Message body' => 'Corpo da mensaxe',
        'Add new notification language' => 'Engadir un idioma de notificación novo',
        'Save Changes' => 'Gardar os cambios',
        'Tag Reference' => 'Referencia de Etiqueta',
        'Notifications are sent to an agent.' => '',
        'You can use the following tags' => 'Pode empregar os tags seguintes',
        'To get the first 20 character of the appointment title.' => '',
        'To get the appointment attribute' => '',
        ' e. g.' => 'por exemplo',
        'To get the calendar attribute' => '',
        'Attributes of the recipient user for the notification' => '',
        'Config options' => 'Opcións Configuración',
        'Example notification' => '',

        # Template: AdminAppointmentNotificationEventTransportEmailSettings
        'Additional recipient email addresses' => '',
        'This field must have less then 200 characters.' => '',
        'Article visible for customer' => '',
        'An article will be created if the notification is sent to the customer or an additional email address.' =>
            'Un artigo será creado se a notificación é enviada ao cliente ou a un enderezo de correo electrónico adicional.',
        'Email template' => '',
        'Use this template to generate the complete email (only for HTML emails).' =>
            'Utilice este modelo para xerar o correo electrónico completo (soamente para correos electrónicos HTML).',
        'Enable email security' => '',
        'Email security level' => '',
        'If signing key/certificate is missing' => '',
        'If encryption key/certificate is missing' => '',

        # Template: AdminAttachment
        'Attachment Management' => 'Xestión de anexos',
        'Add Attachment' => 'Engadir un anexo',
        'Edit Attachment' => 'Edite o adxunto',
        'Filter for Attachments' => 'Filtro para Anexos',
        'Filter for attachments' => '',
        'Filename' => 'Nome de ficheiro',
        'Download file' => 'Descargue arquivo',
        'Delete this attachment' => 'Borre este adxunto',
        'Do you really want to delete this attachment?' => '',
        'Attachment' => 'Anexo',

        # Template: AdminAutoResponse
        'Auto Response Management' => 'Xestión das respostas automáticas',
        'Add Auto Response' => 'Engadir unha resposta automática',
        'Edit Auto Response' => 'Editar a resposta automática',
        'Filter for Auto Responses' => 'Filtro para Auto Respostas',
        'Filter for auto responses' => '',
        'Response' => 'Resposta',
        'Auto response from' => 'Resposta automática de',
        'Reference' => 'Referencia',
        'To get the first 20 character of the subject.' => 'Para obter os primeiros 20 carácteres do tema',
        'To get the first 5 lines of the email.' => 'Para obter as primeiras 5 liñas do email.',
        'To get the name of the ticket\'s customer user (if given).' => '',
        'To get the article attribute' => 'Para obter os atributos do artigo',
        'Options of the current customer user data' => 'Opcións dos datos do usuario cliente actual',
        'Ticket owner options' => 'Opcións do dono do tícket',
        'Ticket responsible options' => 'Opcións do responsable do ticket',
        'Options of the current user who requested this action' => 'Opcións do usuario actual que requeriu esta acción',
        'Options of the ticket data' => 'Opcións dos datos do ticket',
        'Options of ticket dynamic fields internal key values' => 'Opcióons dos valores clave internos dos datos dinámicos do ticket',
        'Options of ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            'Opcións de valores de mostra de campos dinámicos de ticket, útil para Dropdown e campos Multiseleccións',
        'Example response' => 'Resposta de exemplo',

        # Template: AdminCloudServiceSupportDataCollector
        'Cloud Service Management' => 'Xestión Servizos na Nube',
        'Support Data Collector' => 'Recolledor Datos Soporte',
        'Support data collector' => 'Recolledor datos soporte',
        'Hint' => 'Suxestión',
        'Currently support data is only shown in this system.' => 'Actualmente os datos de soporte mostranse soamente neste sistema.',
        'It is highly recommended to send this data to OTRS Group in order to get better support.' =>
            'Recoméndase moito enviar estes datos ao Grupo OTRS para obter mellor axuda.',
        'Configuration' => 'Configuración',
        'Send support data' => 'Enviar datos de axuda',
        'This will allow the system to send additional support data information to OTRS Group.' =>
            'Isto permite que o sistema envíe información de datos de axuda adicionais ao Grupo OTRS.',
        'Update' => 'actualizar',
        'System Registration' => 'Rexistro no sistema',
        'To enable data sending, please register your system with OTRS Group or update your system registration information (make sure to activate the \'send support data\' option.)' =>
            'Para activar o envío de datos rexistre o sistema no Grupo OTRS ou actualice a información de rexistro do sistema (asegúrese de activar a opción «enviar datos de axuda»).',
        'Register this System' => 'Rexistre este Sistema',
        'System Registration is disabled for your system. Please check your configuration.' =>
            'Rexistro de Sistema é deshabilitado para o seu sistema. Por favor comprobe a súa configuración.',

        # Template: AdminCloudServices
        'System registration is a service of OTRS Group, which provides a lot of advantages!' =>
            'O rexistro do sistema é un servizo do Grupo OTRS, que fornece numerosas vantaxes!',
        'Please note that the use of OTRS cloud services requires the system to be registered.' =>
            '',
        'Register this system' => 'Rexistrar este sistema',
        'Here you can configure available cloud services that communicate securely with %s.' =>
            'Aquí pode configurar os servizos na nube dispoñibles que comunican de forma segura con %s.',
        'Available Cloud Services' => 'Servizos na Nube Dispoñibles',

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
        'Settings' => 'Configuración',
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
        'Status' => 'Estado',
        'Account' => '',
        'Edit' => 'Editar',
        'No accounts found.' => '',
        'Communication Log Details (%s)' => '',
        'Direction' => 'Dirección',
        'Start Time' => 'Hora de inicio',
        'End Time' => 'Hora de finalización',
        'No communication log entries found.' => '',

        # Template: AdminCommunicationLogCommunications
        'Duration' => '',

        # Template: AdminCommunicationLogObjectLog
        '#' => '',
        'Priority' => 'Prioridade',
        'Module' => 'Módulo',
        'Information' => 'Información',
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
        'Customer Management' => 'Xestión de clientes',
        'Add Customer' => 'Engadir un cliente',
        'Edit Customer' => 'Editar o cliente',
        'Search' => 'Buscar',
        'Wildcards like \'*\' are allowed.' => 'Comodíns coma \'*\' están permitidos',
        'Select' => 'Seleccionar',
        'List (only %s shown - more available)' => '',
        'total' => '',
        'Please enter a search term to look for customers.' => 'Introduza un termo de busca para procurar clientes.',
        'Customer ID' => 'Identificador de cliente',
        'Please note' => 'Por favor lembre',
        'This customer backend is read only!' => '',

        # Template: AdminCustomerGroup
        'Manage Customer-Group Relations' => 'Xestionar as relacións cliente-grupo',
        'Notice' => 'Aviso',
        'This feature is disabled!' => 'Esta funcionalidade está desactivada!',
        'Just use this feature if you want to define group permissions for customers.' =>
            'Empregue esta funcionalidade se desexa definir permisos de grupo para os clientes.',
        'Enable it here!' => 'Actíveo aquí!',
        'Edit Customer Default Groups' => 'Editar os Grupos Predeterminados dos Clientes',
        'These groups are automatically assigned to all customers.' => 'Estes grupos asígnanselle automaticamente a todos os clientes',
        'You can manage these groups via the configuration setting "CustomerGroupCompanyAlwaysGroups".' =>
            '',
        'Filter for Groups' => 'Filtrar por grupos',
        'Select the customer:group permissions.' => 'Seleccionar os permisos cliente:grupo.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer).' =>
            'Se non hai nada seleccionado, daquela non hai permisos neste grupo (os tíckets non estarán a disposición do cliente).',
        'Search Results' => 'Resultados da busca',
        'Customers' => 'Clientes',
        'Groups' => 'Grupos',
        'Change Group Relations for Customer' => 'Cambiar as relacións de grupo do cliente',
        'Change Customer Relations for Group' => 'Cambiar as relacións de cliente do grupo',
        'Toggle %s Permission for all' => 'Conmutar o permiso %s para todos',
        'Toggle %s permission for %s' => 'Conmutar %s o permiso para  %s',
        'Customer Default Groups:' => 'Grupos predeterminados dos clientes:',
        'No changes can be made to these groups.' => 'Non é posíbel realizar cambios nestes grupos.',
        'ro' => 'sólo lectura',
        'Read only access to the ticket in this group/queue.' => 'Acceso de só lectura aos tickets deste grupo/cola.',
        'rw' => 'lectura escritura',
        'Full read and write access to the tickets in this group/queue.' =>
            'Acceso completo de lectura e escritura aos Tickets deste grupo/cola.',

        # Template: AdminCustomerUser
        'Customer User Management' => 'Xestión de usuarios clientes',
        'Add Customer User' => 'Engadir un usuario cliente',
        'Edit Customer User' => 'Editar usuario cliente',
        'Back to search results' => 'Retornar aos resultados da busca',
        'Customer user are needed to have a customer history and to login via customer panel.' =>
            'Os usuarios clientes son necesarios para ter un historial de cliente e para acceder mediante o panel de cliente.',
        'List (%s total)' => '',
        'Username' => 'Nome de usuario',
        'Email' => 'Correo',
        'Last Login' => 'Último acceso',
        'Login as' => 'Acceder como',
        'Switch to customer' => 'Cambiar a usuario',
        'This customer backend is read only, but the customer user preferences can be changed!' =>
            '',
        'This field is required and needs to be a valid email address.' =>
            'Este campo é requirido e precisa unha dirección de correo valida.',
        'This email address is not allowed due to the system configuration.' =>
            'Esta dirección de correo non está permitida debido a configuración do sistema.',
        'This email address failed MX check.' => 'Esta dirección de correo fallou a comprobación MX.',
        'DNS problem, please check your configuration and the error log.' =>
            'Problema de DNS; comprobe a configuración e o rexistro de erros.',
        'The syntax of this email address is incorrect.' => 'A sintaxe deste enderezo de correo electrónico é incorrecta.',
        'This CustomerID is invalid.' => '',
        'Effective Permissions for Customer User' => '',
        'Group Permissions' => '',
        'This customer user has no group permissions.' => '',
        'Table above shows effective group permissions for the customer user. The matrix takes into account all inherited permissions (e.g. via customer groups). Note: The table does not consider changes made to this form without submitting it.' =>
            '',
        'Customer Access' => '',
        'Customer' => 'Cliente',
        'This customer user has no customer access.' => '',
        'Table above shows granted customer access for the customer user by permission context. The matrix takes into account all inherited access (e.g. via customer groups). Note: The table does not consider changes made to this form without submitting it.' =>
            '',

        # Template: AdminCustomerUserCustomer
        'Manage Customer User-Customer Relations' => '',
        'Select the customer user:customer relations.' => '',
        'Customer Users' => 'Usuarios clientes',
        'Change Customer Relations for Customer User' => '',
        'Change Customer User Relations for Customer' => '',
        'Toggle active state for all' => 'Conmute o estado activo a todos',
        'Active' => 'Activo',
        'Toggle active state for %s' => 'Conmutar o estado activo para %s',

        # Template: AdminCustomerUserGroup
        'Manage Customer User-Group Relations' => '',
        'Just use this feature if you want to define group permissions for customer users.' =>
            '',
        'Edit Customer User Default Groups' => '',
        'These groups are automatically assigned to all customer users.' =>
            '',
        'You can manage these groups via the configuration setting "CustomerGroupAlwaysGroups".' =>
            'Estes grupos poden ser xestionados mediante a opción de configuración «CustomerGroupAlwaysGroups»',
        'Filter for groups' => '',
        'Select the customer user - group permissions.' => '',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer user).' =>
            '',
        'Customer User Default Groups:' => '',

        # Template: AdminCustomerUserService
        'Manage Customer User-Service Relations' => '',
        'Edit default services' => 'Edite os servizos predeterminados',
        'Filter for Services' => 'Filtrar por Servicios',
        'Filter for services' => '',
        'Services' => 'Servizos',

        # Template: AdminDynamicField
        'Dynamic Fields Management' => 'Xestión dos Campos Dinámicos',
        'Add new field for object' => 'Engadir un campo novo para o obxecto',
        'Filter for Dynamic Fields' => '',
        'Filter for dynamic fields' => '',
        'More Business Fields' => '',
        'Would you like to benefit from additional dynamic field types for businesses? Upgrade to %s to get access to the following field types:' =>
            '',
        'Database' => 'Base de datos',
        'Use external databases as configurable data sources for this dynamic field.' =>
            '',
        'Web service' => '',
        'External web services can be configured as data sources for this dynamic field.' =>
            '',
        'Contact with data' => '',
        'This feature allows to add (multiple) contacts with data to tickets.' =>
            '',
        'To add a new field, select the field type from one of the object\'s list, the object defines the boundary of the field and it can\'t be changed after the field creation.' =>
            'Para engadir un novo campo, escolla o tipo de campo dun da lista de obxetos, o obxeto define os límites do campo e non pode ser modificado despois da creación do campo.',
        'Dynamic Fields List' => 'Listaxe dos Campos Dinámicos',
        'Dynamic fields per page' => 'Campos Dinámicos por paxina',
        'Label' => 'Etiqueta',
        'Order' => 'Orde',
        'Object' => 'Obxecto',
        'Delete this field' => 'Borre este campo',

        # Template: AdminDynamicFieldCheckbox
        'Dynamic Fields' => 'Campos Dinámicos',
        'Go back to overview' => 'Volte a vista xeral',
        'General' => 'Xeral',
        'This field is required, and the value should be alphabetic and numeric characters only.' =>
            'Este campo é requirido, e o valor debe conter solamente carácteres alfabeticos e numericos',
        'Must be unique and only accept alphabetic and numeric characters.' =>
            'Ten que ser unico e sólo acepta carácteres alfabeticos e numericos',
        'Changing this value will require manual changes in the system.' =>
            'Cambiar este valor requirirá cambios manuais no sistema.',
        'This is the name to be shown on the screens where the field is active.' =>
            'Este é o nome para mostrar nas pantallas onde o campeo estea activo.',
        'Field order' => 'Ordenar campo',
        'This field is required and must be numeric.' => 'Este campo é requirido e debe ser numérico.',
        'This is the order in which this field will be shown on the screens where is active.' =>
            'Este é o orden no que este campo será mostrado nas pantallas onde estea activo.',
        'Is not possible to invalidate this entry, all config settings have to be changed beforehand.' =>
            '',
        'Field type' => 'Tipo de campo',
        'Object type' => 'Tipo de obxecto',
        'Internal field' => 'Campo interno',
        'This field is protected and can\'t be deleted.' => 'Este campo está protexido e non pode ser borrado.',
        'This dynamic field is used in the following config settings:' =>
            '',
        'Field Settings' => 'Axustes do Campo',
        'Default value' => 'Valor predefinido',
        'This is the default value for this field.' => 'Este é o valor por defecto deste campo.',

        # Template: AdminDynamicFieldDateTime
        'Default date difference' => 'Diferencia nas datas por defecto',
        'This field must be numeric.' => 'Este campo ten que ser numérico',
        'The difference from NOW (in seconds) to calculate the field default value (e.g. 3600 or -60).' =>
            'A diferenza con AGORA (en segundos) para calcular o valor predeterminado do campo (p.ex. 3600 ou -60).',
        'Define years period' => 'Definir periodo de anos',
        'Activate this feature to define a fixed range of years (in the future and in the past) to be displayed on the year part of the field.' =>
            'Active esta función para definir un rango fixado de anos (no futuro e no pasado) para ser mostrados na parte do campo do ano.',
        'Years in the past' => 'Anos pasados',
        'Years in the past to display (default: 5 years).' => 'Mostrar anos pasados (defecto: 5 anos).',
        'Years in the future' => 'Anos futuros',
        'Years in the future to display (default: 5 years).' => 'Mostrar anos futuros (defecto: 5 anos)',
        'Show link' => 'Mostrar ligazón',
        'Here you can specify an optional HTTP link for the field value in Overviews and Zoom screens.' =>
            'Aquí pode especificar un enlace http opcional para o valor do campo nas pantallas Vistas Xerais e Zoom.',
        'If special characters (&, @, :, /, etc.) should not be encoded, use \'url\' instead of \'uri\' filter.' =>
            '',
        'Example' => 'Exemplo',
        'Link for preview' => '',
        'If filled in, this URL will be used for a preview which is shown when this link is hovered in ticket zoom. Please note that for this to work, the regular URL field above needs to be filled in, too.' =>
            '',
        'Restrict entering of dates' => 'Restrinxir entrada de datas.',
        'Here you can restrict the entering of dates of tickets.' => 'Aquí pode restrinxir entrada de datas nos tickets.',

        # Template: AdminDynamicFieldDropdown
        'Possible values' => 'Valores posibles',
        'Key' => 'Chave',
        'Value' => 'Valor',
        'Remove value' => 'Borrar valor',
        'Add value' => 'Engadir un valor',
        'Add Value' => 'Engadir un valor',
        'Add empty value' => 'Engadir un valor baleiro',
        'Activate this option to create an empty selectable value.' => 'Active esta opción para crear un valor valeiro seleccionable.',
        'Tree View' => 'Vista Árbore',
        'Activate this option to display values as a tree.' => 'Active esta opción para mostrar os valores coma unha árbore.',
        'Translatable values' => 'Valores traducíbeis',
        'If you activate this option the values will be translated to the user defined language.' =>
            'Se activa esta opción, os valores tradúcense ao idioma definido polo usuario.',
        'Note' => 'Nota',
        'You need to add the translations manually into the language translation files.' =>
            'Ten que engadir as traducións manualmente nos ficheiros de tradución de idioma.',

        # Template: AdminDynamicFieldText
        'Number of rows' => 'Número de filas',
        'Specify the height (in lines) for this field in the edit mode.' =>
            'Especifique o peso (en liñas) para este campo no modo de edición.',
        'Number of cols' => 'Número de columnas',
        'Specify the width (in characters) for this field in the edit mode.' =>
            'Especifique a anchura (en carácteres) para este campo no modo de edición.',
        'Check RegEx' => 'Comprobe RegEx',
        'Here you can specify a regular expression to check the value. The regex will be executed with the modifiers xms.' =>
            'Aquí pode especificar unha expresión regular para comprobar un valor. A regex será executada cos modificadores xms.',
        'RegEx' => 'Expresión regular',
        'Invalid RegEx' => 'Invalida RegEx',
        'Error Message' => 'Mensaxe de erro',
        'Add RegEx' => 'Engadir unha expresión regular',

        # Template: AdminEmail
        'Admin Message' => '',
        'With this module, administrators can send messages to agents, group or role members.' =>
            'Con este módulo, os administradores poden enviar mensaxes a axentes, grupos ou membros dun rol.',
        'Create Administrative Message' => 'Crear unha mensaxe administrativa',
        'Your message was sent to' => 'A súa mensaxe foi enviada a ',
        'From' => 'Desde',
        'Send message to users' => 'Envíe mensaxe a usuarios',
        'Send message to group members' => 'Envía mensaxe aos membros do grupo',
        'Group members need to have permission' => 'Os membros do grupo deben ter permisos',
        'Send message to role members' => 'Envía mensaxes aos membros do rol',
        'Also send to customers in groups' => 'Enviar tamén os clientes en grupos',
        'Body' => 'Corpo',
        'Send' => 'Enviar',

        # Template: AdminGenericAgent
        'Generic Agent Job Management' => '',
        'Edit Job' => '',
        'Add Job' => '',
        'Run Job' => '',
        'Filter for Jobs' => '',
        'Filter for jobs' => '',
        'Last run' => 'Última execución',
        'Run Now!' => 'Execute Agora!',
        'Delete this task' => 'Borre esta tarefa',
        'Run this task' => 'Execute esta tarefa',
        'Job Settings' => 'Axustes de Traballo',
        'Job name' => 'Nome Traballo',
        'The name you entered already exists.' => 'O nome que introduciu xa existe.',
        'Automatic Execution (Multiple Tickets)' => '',
        'Execution Schedule' => 'Horario de Execución',
        'Schedule minutes' => 'Minutos de horario',
        'Schedule hours' => 'Horas de horario',
        'Schedule days' => 'Días de horario',
        'Automatic execution values are in the system timezone.' => '',
        'Currently this generic agent job will not run automatically.' =>
            'Actualmente este traballo de axente xenérico non se executará automaticamente',
        'To enable automatic execution select at least one value from minutes, hours and days!' =>
            'Para activar a execución automática seleccione ao menos un valor de entre minutos, horas e días!',
        'Event Based Execution (Single Ticket)' => '',
        'Event Triggers' => 'Desencadeantes de Evento',
        'List of all configured events' => 'Lista de todos os eventos configurados',
        'Delete this event' => 'Eliminar este evento',
        'Additionally or alternatively to a periodic execution, you can define ticket events that will trigger this job.' =>
            'Adicionalmente ou alternativamente a unha execución periódica, vostede pode definir eventos de ticket que desencadearán esta tarefa.',
        'If a ticket event is fired, the ticket filter will be applied to check if the ticket matches. Only then the job is run on that ticket.' =>
            'Se un evento de ticket é disparado, o filtro de ticket será aplicado para comprobar se o ticket coincide. Soamente entón a tarefa é executada nese ticket.',
        'Do you really want to delete this event trigger?' => 'Vostede quere realmente borrar este desencadeante de evento?',
        'Add Event Trigger' => 'Engadir un disparador de eventos',
        'To add a new event select the event object and event name' => '',
        'Select Tickets' => 'Seleccione Tickets',
        '(e. g. 10*5155 or 105658*)' => '(p.ex. 10*5155 ou 105658*)',
        '(e. g. 234321)' => '(por exemplo 234321)',
        'Customer user ID' => '',
        '(e. g. U5150)' => '(p.ex. U5150)',
        'Fulltext-search in article (e. g. "Mar*in" or "Baue*").' => 'Busca de texto completo en artigo (ex. "Mar*in" ou "Baue*")',
        'To' => 'A',
        'Cc' => 'Copia',
        'Service' => 'Servizo',
        'Service Level Agreement' => 'Acordo de nivel de servizo',
        'Queue' => 'Fila',
        'State' => 'Estado',
        'Agent' => 'Axente',
        'Owner' => 'Dono',
        'Responsible' => 'Responsable',
        'Ticket lock' => 'Bloqueo de Ticket',
        'Dynamic fields' => 'Campos dinámicos',
        'Add dynamic field' => '',
        'Create times' => 'Cree tempos',
        'No create time settings.' => 'Non crear axustes de tempo',
        'Ticket created' => 'Ticket creado',
        'Ticket created between' => 'Ticket creado entre',
        'and' => 'e',
        'Last changed times' => 'Tempo do derradeiro cambio',
        'No last changed time settings.' => 'Non axustes de tempo do derradeiro cambio.',
        'Ticket last changed' => 'Derradeiro cambio de ticket',
        'Ticket last changed between' => 'Derradeiro cambio de ticket entre',
        'Change times' => 'Tempo do cambio',
        'No change time settings.' => 'Non axustes do cambio do tempo',
        'Ticket changed' => 'Ticket cambiado',
        'Ticket changed between' => 'Ticket cambiado entre',
        'Last close times' => '',
        'No last close time settings.' => '',
        'Ticket last close' => '',
        'Ticket last close between' => '',
        'Close times' => 'Horas de peche',
        'No close time settings.' => 'Non axustes de peche de tempo',
        'Ticket closed' => 'Ticket pechado',
        'Ticket closed between' => 'Ticket pechado entre',
        'Pending times' => 'Tempos á espera',
        'No pending time settings.' => 'Non axustes de tempos á espera',
        'Ticket pending time reached' => 'Tempo á espera de Ticket alcanzado',
        'Ticket pending time reached between' => 'Tempo á espera de ticket alcanzado entre',
        'Escalation times' => 'Tempos de escalado',
        'No escalation time settings.' => 'Non axustes de tempos de escalado',
        'Ticket escalation time reached' => 'Tempo de escalado de ticket alcanzado',
        'Ticket escalation time reached between' => 'Tempo de escalado de ticket alcanzado entre',
        'Escalation - first response time' => 'Escalado - tempo de primeira resposta',
        'Ticket first response time reached' => 'Tempo de primeira resposta de ticket alcanzado',
        'Ticket first response time reached between' => 'Tempo de primeira resposta de ticket alcanzado entre',
        'Escalation - update time' => 'Escalado - tempo de actualización',
        'Ticket update time reached' => 'Tempo de actualización de ticket alcanzado',
        'Ticket update time reached between' => 'Tempo de actualización de ticket alcanzado entre',
        'Escalation - solution time' => 'Escalado - tempo de resolución',
        'Ticket solution time reached' => 'Tempo de resolución de ticket alcanzado',
        'Ticket solution time reached between' => 'Tempo de resolución de ticket alcanzado',
        'Archive search option' => 'Opción de busca no arquivo',
        'Update/Add Ticket Attributes' => 'Actualizar/Engadir Atributos de Ticket',
        'Set new service' => 'Establecer novo servizo',
        'Set new Service Level Agreement' => 'Establecer un novo Acordo de Nivel de Servizo',
        'Set new priority' => 'Establecer nova prioridade',
        'Set new queue' => 'Establecer nova cola',
        'Set new state' => 'Establecer novo estado',
        'Pending date' => 'Data pendente',
        'Set new agent' => 'Establecer novo axente',
        'new owner' => 'novo dono',
        'new responsible' => 'novo responsable',
        'Set new ticket lock' => 'Establecer novo bloqueo de ticket',
        'New customer user ID' => '',
        'New customer ID' => 'Novo identificador de cliente',
        'New title' => 'Novo título',
        'New type' => 'Novo tipo',
        'Archive selected tickets' => 'Arquivar os tíckets seleccionados',
        'Add Note' => 'Engadir unha nota',
        'Visible for customer' => '',
        'Time units' => 'Unidades de tempo',
        'Execute Ticket Commands' => 'Execute Comandos de Ticket',
        'Send agent/customer notifications on changes' => 'Enviar notificacións sobre os cambios ao axente/cliente',
        'CMD' => 'CMD',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' =>
            'Este comando será executado. ARG[0] sera o número de ticket. ARG[1] será o id do ticket.',
        'Delete tickets' => 'Borre tickets',
        'Warning: All affected tickets will be removed from the database and cannot be restored!' =>
            'Alerta: Tódolos tickets afectados serán eliminados da base de datos en non poderanse reestablecer! ',
        'Execute Custom Module' => 'Execute Módulo Propio',
        'Param %s key' => 'Chave Param %s',
        'Param %s value' => 'Valor Param %s',
        'Results' => 'Resultados',
        '%s Tickets affected! What do you want to do?' => '%s Tickets afectados! Que quere facer?',
        'Warning: You used the DELETE option. All deleted tickets will be lost!' =>
            'Alerta: Usou a opción BORRAR. Tódolos tickets borrados serán perdidos!',
        'Warning: There are %s tickets affected but only %s may be modified during one job execution!' =>
            '',
        'Affected Tickets' => 'Tíckets afectados',
        'Age' => 'Antigüidade',

        # Template: AdminGenericInterfaceDebugger
        'GenericInterface Web Service Management' => 'InterfaceXenérica de Xestión do Servizo Web',
        'Web Service Management' => '',
        'Debugger' => 'Depurador',
        'Go back to web service' => 'Volte ao Servizo Web',
        'Clear' => 'Limpar',
        'Do you really want to clear the debug log of this web service?' =>
            'Quere realmente limpar o log do debug deste servizo web?',
        'Request List' => 'Lista de solicitudes',
        'Time' => 'Hora',
        'Communication ID' => '',
        'Remote IP' => 'IP remoto',
        'Loading' => 'Cargando',
        'Select a single request to see its details.' => 'Seleccione unha única petición para ver os seus detalles.',
        'Filter by type' => 'Filtro por tipo',
        'Filter from' => 'Filtro desde',
        'Filter to' => 'Filtro a',
        'Filter by remote IP' => 'Filtro por IP remota',
        'Limit' => 'Límite',
        'Refresh' => 'Actualizar',

        # Template: AdminGenericInterfaceErrorHandlingDefault
        'Add ErrorHandling' => '',
        'Edit ErrorHandling' => '',
        'Do you really want to delete this error handling module?' => '',
        'All configuration data will be lost.' => 'Hanse perder todos os datos de configuración.',
        'General options' => '',
        'The name can be used to distinguish different error handling configurations.' =>
            '',
        'Please provide a unique name for this web service.' => 'Por favor proporcione un nome único para este servizo web.',
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
        'Do you really want to delete this invoker?' => 'Quere realmente borrar este invocador?',
        'Invoker Details' => 'Detalles do Invocador',
        'The name is typically used to call up an operation of a remote web service.' =>
            'O nome é tipicamente utilizado para chamar a unha operación dun servizo web remoto.',
        'Invoker backend' => 'Backend do invocador',
        'This OTRS invoker backend module will be called to prepare the data to be sent to the remote system, and to process its response data.' =>
            'O módulo backend do invocador sera chamado para preparar os datos á enviar ao sistema remoto, e para procesar os datos da resposta.',
        'Mapping for outgoing request data' => 'Mapeado dos datos requiridos de saída',
        'Configure' => 'Configurar',
        'The data from the invoker of OTRS will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            'Os datos dende o invocador de OTRS serán procesados por este mapeado, para transformalos ao tipo de dato que o sistema remoto espera.',
        'Mapping for incoming response data' => 'Mapeado das respostas de datos entrantes',
        'The response data will be processed by this mapping, to transform it to the kind of data the invoker of OTRS expects.' =>
            'Os datos de resposta serán procesados por este mapeado, para transformalos ao tipo de datos que o invocador de OTRS espera.',
        'Asynchronous' => 'Asíncrono',
        'Condition' => 'Condición',
        'Edit this event' => '',
        'This invoker will be triggered by the configured events.' => 'Este invocador será disparado polos eventos configurados.',
        'Add Event' => 'Engadir un evento',
        'To add a new event select the event object and event name and click on the "+" button' =>
            'Para engadir un novo evento, seleccione un novo obxeto  e  nome de evento e faga clic no botón "+". ',
        'Asynchronous event triggers are handled by the OTRS Scheduler Daemon in background (recommended).' =>
            'Disparadores de evento asincrónicos son manexados polo Planificador Daemon OTRS en segundo plano (recomendado).',
        'Synchronous event triggers would be processed directly during the web request.' =>
            'Desecadeantes de eventos sincrónicos serán procesados directamente durante a petición web.',

        # Template: AdminGenericInterfaceInvokerEvent
        'GenericInterface Invoker Event Settings for Web Service %s' => '',
        'Go back to' => 'Volte a',
        'Delete all conditions' => '',
        'Do you really want to delete all the conditions for this event?' =>
            '',
        'General Settings' => '',
        'Event type' => '',
        'Conditions' => 'Condicións',
        'Conditions can only operate on non-empty fields.' => '',
        'Type of Linking between Conditions' => 'Tipo de ligazón entre condicións',
        'Remove this Condition' => 'Elimine esta Condición',
        'Type of Linking' => 'Tipo de ligazón',
        'Fields' => 'Campos',
        'Add a new Field' => 'Engadir un campo novo',
        'Remove this Field' => 'Elimine este Campo',
        'And can\'t be repeated on the same condition.' => 'E non pode repetirse na mesma condición.',
        'Add New Condition' => 'Engadir unha condición nova',

        # Template: AdminGenericInterfaceMappingSimple
        'Mapping Simple' => 'Mapeado Simple',
        'Default rule for unmapped keys' => 'Regra por defecto para chaves non mapeadas',
        'This rule will apply for all keys with no mapping rule.' => 'Esta regra aplicarase para todalas chaves sen regra de mapeado.',
        'Default rule for unmapped values' => 'Regra por defecto para valores no mapeados',
        'This rule will apply for all values with no mapping rule.' => 'Esta regra aplicarase para tódolos valores sen regra de mapeado.',
        'New key map' => 'Novo mapa de caracteres',
        'Add key mapping' => 'Engadir unha asignación de teclas',
        'Mapping for Key ' => 'Mapeado para chave',
        'Remove key mapping' => 'Elimine o mapeado da chave',
        'Key mapping' => 'Mapeado Chave',
        'Map key' => 'Mapa de chave',
        'matching the' => 'coincide con',
        'to new key' => 'a nova chave',
        'Value mapping' => 'Valor do mapeo',
        'Map value' => 'Valor do mapa',
        'to new value' => 'o novo valor',
        'Remove value mapping' => 'Elimine o valor do mapeado',
        'New value map' => 'Novo mapa de valores',
        'Add value mapping' => 'Engada o valor do mapeado',
        'Do you really want to delete this key mapping?' => 'Quere realmente borrar esta chave de mapeado?',

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
        'Do you really want to delete this operation?' => 'Quere realmente borrar esta operación?',
        'Operation Details' => 'Detalles de Operación',
        'The name is typically used to call up this web service operation from a remote system.' =>
            'O nome é tipicamente utilizado para chamar a esta operación de servizo web dende un sistema remoto.',
        'Operation backend' => 'Operación de backend',
        'This OTRS operation backend module will be called internally to process the request, generating data for the response.' =>
            'Este módulo de operación de backend será chamado internamente para procesar a petición, xerando datos para a resposta.',
        'Mapping for incoming request data' => 'Mapeado para as peticións de datos de entrada.',
        'The request data will be processed by this mapping, to transform it to the kind of data OTRS expects.' =>
            'A petición de datos será procesada por este mapeado, para transformalo ao tipo de dato que espera OTRS.',
        'Mapping for outgoing response data' => 'Mapeado para os datos de resposta de saída',
        'The response data will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            'Os datos de resposta serán procesados por este mapeado, para transformalos ao tipo de dato que o sistema remoto espera.',
        'Include Ticket Data' => '',
        'Include ticket data in response.' => '',

        # Template: AdminGenericInterfaceTransportHTTPREST
        'Network Transport' => '',
        'Properties' => 'Propiedades',
        'Route mapping for Operation' => 'Ruta de mapeado para Operación',
        'Define the route that should get mapped to this operation. Variables marked by a \':\' will get mapped to the entered name and passed along with the others to the mapping. (e.g. /Ticket/:TicketID).' =>
            'Defina a ruta que debe ser mapeada a esta operación. As variables marcadas con \'.\' quedarán mapeadas ao nome introducido e pasados xunto a outras ao mapeado (ex. /Ticket/:TicketID)',
        'Valid request methods for Operation' => 'Métodos validos de petición para Operación',
        'Limit this Operation to specific request methods. If no method is selected all requests will be accepted.' =>
            'Limite esta Operación a métodos de petición específicos. Se ningún método é seleccionado todalas peticións serán aceptadas.',
        'Maximum message length' => 'Máxima lonxitude de mensaxe',
        'This field should be an integer number.' => 'Este campo debería ser un número enteiro.',
        'Here you can specify the maximum size (in bytes) of REST messages that OTRS will process.' =>
            'Aquí pode especificar o máximo tamaño (en bytes) de mensaxes REST que OTRS procesará.',
        'Send Keep-Alive' => 'Envíe Manter-Vivo',
        'This configuration defines if incoming connections should get closed or kept alive.' =>
            'Esta configuración define se conexións entrantes deberían ser pechadas ou mantidas vivas.',
        'Additional response headers' => '',
        'Add response header' => '',
        'Endpoint' => 'Final',
        'URI to indicate specific location for accessing a web service.' =>
            '',
        'e.g https://www.otrs.com:10745/api/v1.0 (without trailing backslash)' =>
            'p.ex. https://www.otrs.com:10745/api/v1.0 (sen barra final)',
        'Timeout' => '',
        'Timeout value for requests.' => '',
        'Authentication' => 'Autenticación',
        'An optional authentication mechanism to access the remote system.' =>
            '',
        'BasicAuth User' => '',
        'The user name to be used to access the remote system.' => 'O nome de usuario que usar para acceder ao sistema remoto.',
        'BasicAuth Password' => '',
        'The password for the privileged user.' => 'O contrasinal para o usuario privilexiado.',
        'Use Proxy Options' => '',
        'Show or hide Proxy options to connect to the remote system.' => '',
        'Proxy Server' => 'Servidor proxy',
        'URI of a proxy server to be used (if needed).' => 'URI dun servidor proxy para usar (de se precisar).',
        'e.g. http://proxy_hostname:8080' => 'ex. http://proxy_hostname:8080',
        'Proxy User' => 'Usuario do proxy',
        'The user name to be used to access the proxy server.' => 'O nome a empregar para o acceso o servidor de proxy.',
        'Proxy Password' => 'Contrasinal do proxy',
        'The password for the proxy user.' => 'O contrasinal do usuario de proxy.',
        'Skip Proxy' => '',
        'Skip proxy servers that might be configured globally?' => '',
        'Use SSL Options' => 'Empregar as opcións de SSL',
        'Show or hide SSL options to connect to the remote system.' => 'Mostrar ou agochar as opcións de SSL para conectarse ao sistema remoto.',
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
            'A ruta completa e o nome do ficheiro do certificado da autoridade de certificación que valida o certificado de SSL.',
        'e.g. /opt/otrs/var/certificates/SOAP/CA/ca.pem' => 'ex. /opt/otrs/var/certificates/SOAP/CA/ca.pem',
        'Certification Authority (CA) Directory' => 'Directorio Autoridade de Certificación (AC)',
        'The full path of the certification authority directory where the CA certificates are stored in the file system.' =>
            'A ruta completa do directorio da autoridade de certificación onde os certificados AC son gardados no arquivo do sistema.',
        'e.g. /opt/otrs/var/certificates/SOAP/CA' => 'ex. /opt/otrs/var/certificates/SOAP/CA',
        'Controller mapping for Invoker' => 'Mapeado do controlador para o Invocador',
        'The controller that the invoker should send requests to. Variables marked by a \':\' will get replaced by the data value and passed along with the request. (e.g. /Ticket/:TicketID?UserLogin=:UserLogin&Password=:Password).' =>
            'O controlador ao cal o invocador debería enviar peticións. As variables marcadas con \': \' serán substituídas polos valores de datos e pasadas xunto coa petición. (p.ej. /Ticket/:TicketID?UserLogin=:UserLogin&Password=:Password).',
        'Valid request command for Invoker' => 'Comando de petición válido para Invocador',
        'A specific HTTP command to use for the requests with this Invoker (optional).' =>
            'Un comando específico de HTTP  utilizase para as peticións con este Invocador (opcional).',
        'Default command' => 'Orde predeterminada',
        'The default HTTP command to use for the requests.' => 'O comando HTTP utilizase por defecto para estas peticións.',

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
        'SOAPAction separator' => 'Separador SOAPAcción',
        'Character to use as separator between name space and SOAP operation.' =>
            '',
        'Usually .Net web services use "/" as separator.' => '',
        'SOAPAction free text' => '',
        'Text to be used to as SOAPAction.' => '',
        'Namespace' => 'Espazo de nomes',
        'URI to give SOAP methods a context, reducing ambiguities.' => 'URI para lles dar un contexto aos métodos SOAP, reducindo ambigüidades.',
        'e.g urn:otrs-com:soap:functions or http://www.otrs.com/GenericInterface/actions' =>
            'ex. urn:otrs-com:soap:functions ou http://www.otrs.com/GenericInterface/actions',
        'Request name scheme' => 'Petición de nome de esquema',
        'Select how SOAP request function wrapper should be constructed.' =>
            'Selecione como o colector de funcion de peticións SOAP debe ser construido.',
        '\'FunctionName\' is used as example for actual invoker/operation name.' =>
            '\'NomeFunción\' é usado coma exemplo para os nomes de invocador/operación actuáis.',
        '\'FreeText\' is used as example for actual configured value.' =>
            '\'TextoLibre\' é usado coma exemplo para os valores configurados actuáis.',
        'Request name free text' => '',
        'Text to be used to as function wrapper name suffix or replacement.' =>
            'Texto para ser usado nun sufixo do nome do colector de función ou remplazo.',
        'Please consider XML element naming restrictions (e.g. don\'t use \'<\' and \'&\').' =>
            'Por favor considere as restriccións de nomeado de elementos XML (ex. non use \'<\' e \'&\').',
        'Response name scheme' => 'Esquema nome resposta',
        'Select how SOAP response function wrapper should be constructed.' =>
            'Seleccione como o colector de función de resposta SOAP debe ser construido.',
        'Response name free text' => 'Nome resposta texto libre',
        'Here you can specify the maximum size (in bytes) of SOAP messages that OTRS will process.' =>
            'Aquí pode especificar o tamaño máximo (en bytes) de mensaxes SOAP que OTRS procesará.',
        'Encoding' => 'Codificando',
        'The character encoding for the SOAP message contents.' => 'Codificando o caracter para os contidos da mensaxe SOAP. ',
        'e.g utf-8, latin1, iso-8859-1, cp1250, Etc.' => 'ex. utf-8, latin1, iso-8859-1, cp1250, Etc.',
        'Sort options' => 'Clasificar opcións',
        'Add new first level element' => 'Engadir novo elemento de primeiro nivel',
        'Element' => '',
        'Outbound sort order for xml fields (structure starting below function name wrapper) - see documentation for SOAP transport.' =>
            'Orde de clasificación de saída para campos xml (estructura comezando abaixo do nome do colecter da función) - vexa a documentación para transporte SOAP.',

        # Template: AdminGenericInterfaceWebservice
        'Add Web Service' => '',
        'Edit Web Service' => '',
        'Clone Web Service' => '',
        'The name must be unique.' => 'O nome ten que ser único.',
        'Clone' => 'Replicar',
        'Export Web Service' => '',
        'Import web service' => 'Importar servizo web',
        'Configuration File' => 'Ficheiro de configuración',
        'The file must be a valid web service configuration YAML file.' =>
            'O ficheiro ten que ser un ficheiro YAML de configuración de servizo web.',
        'Here you can specify a name for the webservice. If this field is empty, the name of the configuration file is used as name.' =>
            '',
        'Import' => 'Importar',
        'Configuration History' => '',
        'Delete web service' => 'Eliminar servizo web',
        'Do you really want to delete this web service?' => 'Desexa realmente eliminar este servicio web?',
        'Ready2Adopt Web Services' => '',
        'Here you can activate Ready2Adopt web services showcasing our best practices that are a part of %s.' =>
            '',
        'Please note that these web services may depend on other modules only available with certain %s contract levels (there will be a notification with further details when importing).' =>
            '',
        'Import Ready2Adopt web service' => '',
        'Would you like to benefit from web services created by experts? Upgrade to %s to import some sophisticated Ready2Adopt web services.' =>
            '',
        'After you save the configuration you will be redirected again to the edit screen.' =>
            'Despois de gardar a configuración será redirixido novamente a pantalla de edición.',
        'If you want to return to overview please click the "Go to overview" button.' =>
            'Se quere voltar a vista xeral por favor faga clic no botón "Ir a vista xeral".',
        'Remote system' => 'Sistema remoto',
        'Provider transport' => 'Transporte do fornecedor',
        'Requester transport' => 'Transporte do solicitante',
        'Debug threshold' => 'Limiar de depuración',
        'In provider mode, OTRS offers web services which are used by remote systems.' =>
            'No modo de fornecedor, OTRS ofrece servizos web que son empregados por sistemas remotos.',
        'In requester mode, OTRS uses web services of remote systems.' =>
            'No modo de solicitante, OTRS emprega servizos web de sistemas remotos.',
        'Network transport' => 'Transporte de rede',
        'Error Handling Modules' => '',
        'Error handling modules are used to react in case of errors during the communication. Those modules are executed in a specific order, which can be changed by drag and drop.' =>
            '',
        'Backend' => '',
        'Add error handling module' => '',
        'Operations are individual system functions which remote systems can request.' =>
            'As operacións son funcións individuais do sistema as cales o sistema remoto pode pedir.',
        'Invokers prepare data for a request to a remote web service, and process its response data.' =>
            'Os invocadores preparan os datos para unha petición a un web service remoto, e procesan os datos da resposta.',
        'Controller' => 'Controlador',
        'Inbound mapping' => 'Mapeado de chegada',
        'Outbound mapping' => 'Mapeado de ida',
        'Delete this action' => 'Elimine esta acción',
        'At least one %s has a controller that is either not active or not present, please check the controller registration or delete the %s' =>
            'Polo menos un %s ten un controlador que ou non está activo ou non está presente, por favor verifique o rexistro do controlador ou elimine o %s',

        # Template: AdminGenericInterfaceWebserviceHistory
        'History' => 'Historial',
        'Go back to Web Service' => 'Volte ao Servizo Web',
        'Here you can view older versions of the current web service\'s configuration, export or even restore them.' =>
            'Aquí pode ver versións anteriores da configuración actual do servizo web, exportalas ou incluso restauralas.',
        'Configuration History List' => 'Lista do historial de configuración',
        'Version' => 'Versión',
        'Create time' => 'Crear tempo',
        'Select a single configuration version to see its details.' => 'Seleccione unha única versión de configuración para ver os seus detalles.',
        'Export web service configuration' => 'Exporte a configuración do servizo web',
        'Restore web service configuration' => 'Reestablecer a configuración do servizo web',
        'Do you really want to restore this version of the web service configuration?' =>
            'Quere realmente reestablecer esta versión da configuración do servicio web?',
        'Your current web service configuration will be overwritten.' => 'A configuración actual do seu servizo web será sobreescribida.',

        # Template: AdminGroup
        'Group Management' => 'Xestión de grupos',
        'Add Group' => 'Engadir un grupo',
        'Edit Group' => 'Editar o grupo',
        'The admin group is to get in the admin area and the stats group to get stats area.' =>
            'O grupo de admin ten que chegar a área de admin e o grupo de stats para chegar a área de stats.',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...). ' =>
            'Cree novos grupos para manexar os permisos de acceso segundo o grupo de axente (ex. departamento compras, departamento soporte, departamento vendas...)',
        'It\'s useful for ASP solutions. ' => 'É util para solucións ASP.',

        # Template: AdminLog
        'System Log' => 'Rexistro do sistema',
        'Here you will find log information about your system.' => 'Aquí atopará información dos logs do seu sistema.',
        'Hide this message' => 'Agochar esta mensaxe',
        'Recent Log Entries' => 'Entradas recentes do rexistro',
        'Facility' => 'Instalación',
        'Message' => 'Mensaxe',

        # Template: AdminMailAccount
        'Mail Account Management' => 'Xestión de contas de correo',
        'Add Mail Account' => 'Engadir unha conta de correo',
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
        'Host' => 'Servidor',
        'Delete account' => 'Eliminar a conta',
        'Fetch mail' => 'Recuperar o correo',
        'Do you really want to delete this mail account?' => '',
        'Password' => 'Contrasinal',
        'Example: mail.example.com' => 'Exemplo: mail.example.com',
        'IMAP Folder' => 'Cartafol de IMAP',
        'Only modify this if you need to fetch mail from a different folder than INBOX.' =>
            'Modifique isto só se ten que obter correo dun cartafol distinto a INBOX.',
        'Trusted' => 'De confianza',
        'Dispatching' => 'Enviando',
        'Edit Mail Account' => 'Edite Conta Correo',

        # Template: AdminNavigationBar
        'Administration Overview' => '',
        'Filter for Items' => '',
        'Filter' => 'Filtro',
        'Favorites' => '',
        'You can add favorites by moving your cursor over items on the right side and clicking the star icon.' =>
            '',
        'Links' => '',
        'View the admin manual on Github' => '',
        'No Matches' => '',
        'Sorry, your search didn\'t match any items.' => '',
        'Set as favorite' => '',

        # Template: AdminNotificationEvent
        'Ticket Notification Management' => 'Xestión de Notificación de Ticket',
        'Here you can upload a configuration file to import Ticket Notifications to your system. The file needs to be in .yml format as exported by the Ticket Notification module.' =>
            'Aquí vostede pode cargar un arquivo de configuración para importar Notificacións de Ticket ao seu sistema. O arquivo necesita estar en formato .yml como exportado polo módulo de Notificación de Ticket.',
        'Here you can choose which events will trigger this notification. An additional ticket filter can be applied below to only send for ticket with certain criteria.' =>
            'Aquí vostede pode decidir que acontecementos desencadearán esta notificación. Un filtro de ticket adicional pode ser aplicado abaixo para soamente mandar buscar ticket con certos criterios.',
        'Ticket Filter' => 'Filtro do Ticket',
        'Lock' => 'Bloquear',
        'SLA' => 'SLA',
        'Customer User ID' => '',
        'Article Filter' => 'Filtro de artigos',
        'Only for ArticleCreate and ArticleSend event' => 'Soamente para evento de CrearArtigo e EnviarArtigo',
        'Article sender type' => 'Tipo de remitente de artigos',
        'If ArticleCreate or ArticleSend is used as a trigger event, you need to specify an article filter as well. Please select at least one of the article filter fields.' =>
            'Se CrearArtigo ou EnviarArtigoson empregados para disparar un evento, ten que especificar un filtro de artigo tamén. Por favor seleccione polo menos un dos campos de filtros de artigo.',
        'Customer visibility' => '',
        'Communication channel' => '',
        'Include attachments to notification' => 'Incluír os anexos na notificación',
        'Notify user just once per day about a single ticket using a selected transport.' =>
            'Notificar ao usuario só unha vez por día sobre un tícket único empregando un transporte seleccionado.',
        'This field is required and must have less than 4000 characters.' =>
            '',
        'Notifications are sent to an agent or a customer.' => 'As notificacións envíanselle a un axente ou a un cliente.',
        'To get the first 20 character of the subject (of the latest agent article).' =>
            'Conseguir os primeiros 20 carácteres do tema (do último artigo de axente).',
        'To get the first 5 lines of the body (of the latest agent article).' =>
            'Conseguir as primeiras 5 liñas do corpo (do último artigo de axente).',
        'To get the first 20 character of the subject (of the latest customer article).' =>
            'Para obter os primeiros vinte caracteres do asunto (do último artigo de cliente).',
        'To get the first 5 lines of the body (of the latest customer article).' =>
            'Para obter as cinco primeiras liñas do corpo (do último artigo de cliente).',
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
        'Manage %s' => 'Administrar %s',
        'Downgrade to ((OTRS)) Community Edition' => '',
        'Read documentation' => 'Leer documentación',
        '%s makes contact regularly with cloud.otrs.com to check on available updates and the validity of the underlying contract.' =>
            '%s contacta frecuentemente con cloud.otrs.com para comprobar as actualizacións dispoñíbeis e a validez do contrato en vigor.',
        'Unauthorized Usage Detected' => 'Uso Non Autorizado Detectado',
        'This system uses the %s without a proper license! Please make contact with %s to renew or activate your contract!' =>
            'Este sistema utiliza o %s sen un permiso correcto! Por favor contacte con %s para renovar ou activar o seu contrato!',
        '%s not Correctly Installed' => '%s non instalado correctamente',
        'Your %s is not correctly installed. Please reinstall it with the button below.' =>
            'O seu %s non é correctamente instalado. Por favor reinstáleo co botón abaixo.',
        'Reinstall %s' => 'Reinstalar %s',
        'Your %s is not correctly installed, and there is also an update available.' =>
            'O seu %s non é correctamente instalado, e tamén hai unha actualización dispoñible.',
        'You can either reinstall your current version or perform an update with the buttons below (update recommended).' =>
            'Vostede pode reinstalar a súa versión actual ou realizar unha actualización cos botóns de abaixo (actualización recomendada).',
        'Update %s' => 'Actualice %s',
        '%s Not Yet Available' => '%s non está dispoñíbel aínda',
        '%s will be available soon.' => '%s estará dispoñíbel en breve.',
        '%s Update Available' => '%s actualización dispoñíbel',
        'An update for your %s is available! Please update at your earliest!' =>
            'Existe unha actualización para o seu %s! Actualice o antes posíbel!',
        '%s Correctly Deployed' => '%s Correctamente Despregado',
        'Congratulations, your %s is correctly installed and up to date!' =>
            'Parabéns, o %s está instalado correctamente e actualizado!',

        # Template: AdminOTRSBusinessNotInstalled
        'Go to the OTRS customer portal' => '',
        '%s will be available soon. Please check again in a few days.' =>
            '%s estará dispoñíbel en breve. Comprobe de novo nuns días.',
        'Please have a look at %s for more information.' => 'Por favor vexa en %s para obter mais información.',
        'Your ((OTRS)) Community Edition is the base for all future actions. Please register first before you continue with the upgrade process of %s!' =>
            '',
        'Before you can benefit from %s, please contact %s to get your %s contract.' =>
            'Antes de beneficiarse de %s, por favor contacto con %s para obter o seu %s contrato.',
        'Connection to cloud.otrs.com via HTTPS couldn\'t be established. Please make sure that your OTRS can connect to cloud.otrs.com via port 443.' =>
            'Non foi posíbel conectarse a cloud.otrs.com mediante HTTPS. Asegúrese de que OTRS pode conectarse a cloud.otrs.com a través do porto 443.',
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
            'Co seu contrato existente só pode usar unha pequena parte de %s.',
        'If you would like to take full advantage of the %s get your contract upgraded now! Contact %s.' =>
            'Se quere obter todalas vantaxes de %s mellore o seu contrato agora! Contacte %s.',

        # Template: AdminOTRSBusinessUninstall
        'Cancel downgrade and go back' => 'Cancelar a reversión e regresar',
        'Go to OTRS Package Manager' => 'Ir ao Xestor de Paquetes de OTRS',
        'Sorry, but currently you can\'t downgrade due to the following packages which depend on %s:' =>
            'O sentimos, pero actualmente non pode degradar debido a que os seguintes paquetes dependen de %s:',
        'Vendor' => 'Vendedor',
        'Please uninstall the packages first using the package manager and try again.' =>
            'Por favor desinstale os paquetes primeiro empregando o manager de paquetes e probe de novo.',
        'You are about to downgrade to ((OTRS)) Community Edition and will lose the following features and all data related to these:' =>
            '',
        'Chat' => 'Conversa',
        'Report Generator' => '',
        'Timeline view in ticket zoom' => 'Vista da liña de tempo no zoom do Ticket',
        'DynamicField ContactWithData' => 'CampoDinamico ContactoConDatos',
        'DynamicField Database' => 'CampoDinamico BaseDeDatos',
        'SLA Selection Dialog' => 'Diálogo de selección de SLA',
        'Ticket Attachment View' => 'Vista Adxuntos Ticket',
        'The %s skin' => 'A aparencia %s',

        # Template: AdminPGP
        'PGP Management' => 'Xestión PGP',
        'Add PGP Key' => 'Engadir unha chave de PGP',
        'PGP support is disabled' => '',
        'To be able to use PGP in OTRS, you have to enable it first.' => '',
        'Enable PGP support' => '',
        'Faulty PGP configuration' => '',
        'PGP support is enabled, but the relevant configuration contains errors. Please check the configuration using the button below.' =>
            '',
        'Configure it here!' => '',
        'Check PGP configuration' => '',
        'In this way you can directly edit the keyring configured in SysConfig.' =>
            'Desta maneira pódese editar directamente o chaveiro configurado en SysConfig.',
        'Introduction to PGP' => 'Introdución a PGP',
        'Identifier' => 'Identificador',
        'Bit' => 'Bit',
        'Fingerprint' => 'Pegada dactilar',
        'Expires' => 'Expira',
        'Delete this key' => 'Eliminar esta clave',
        'PGP key' => 'Chave de PGP',

        # Template: AdminPackageManager
        'Package Manager' => 'Xestor de Paquetes',
        'Uninstall Package' => '',
        'Uninstall package' => 'Desinstalar o paquete',
        'Do you really want to uninstall this package?' => 'Confirma que desexa desinstalar este paquete?',
        'Reinstall package' => 'Reinstalar o paquete',
        'Do you really want to reinstall this package? Any manual changes will be lost.' =>
            'Confirma que desexa reinstalar este paquete? Os cambios manuais hanse perder.',
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
            'No caso de que teña máis preguntas, encantaríanos respondelas.',
        'Install Package' => 'Paquete de instalación',
        'Update Package' => '',
        'Continue' => 'Continuar',
        'Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            'Asegúrese de que a base de datos acepta paquetes de máis de %s MB de tamaño (actualmente só acepta paquetes de até %s MB). Adapte a opción max_allowed_packet da base de datos para evitar erros.',
        'Install' => 'Instalar',
        'Update repository information' => 'Actualice a información do repositorio',
        'Cloud services are currently disabled.' => '',
        'OTRS Verify™ can not continue!' => '',
        'Enable cloud services' => '',
        'Update all installed packages' => '',
        'Online Repository' => 'Repositorio na rede',
        'Action' => 'Acción',
        'Module documentation' => 'Documentación do módulo',
        'Local Repository' => 'Repositorio local',
        'This package is verified by OTRSverify (tm)' => 'Este pauqete foi verificado por OTRSverify (tm)',
        'Uninstall' => 'Desinstale',
        'Package not correctly deployed! Please reinstall the package.' =>
            'O paquete non foi correctamente despregado! Por favor, volva a instalar o paquete.',
        'Reinstall' => 'Reinstalar',
        'Features for %s customers only' => 'Funcionalidades só para clientes %s',
        'With %s, you can benefit from the following optional features. Please make contact with %s if you need more information.' =>
            'Con %s, pódese beneficiar de ás seguintes funcionalidades opcionáis. Por favor contacte con %s se precisa mais información.',
        'Package Information' => '',
        'Download package' => 'Descargar paquete',
        'Rebuild package' => 'Reconstruír o paquete',
        'Metadata' => 'Metadatos',
        'Change Log' => 'Rexistro de cambios',
        'Date' => 'Data',
        'List of Files' => 'Listaxe de Arquivos',
        'Permission' => 'Permiso',
        'Download file from package!' => 'Descargue o arquivo dende o paquete!',
        'Required' => 'Necesario',
        'Size' => 'Tamaño',
        'Primary Key' => '',
        'Auto Increment' => '',
        'SQL' => 'SQL',
        'File Differences for File %s' => '',
        'File differences for file %s' => 'Diferencias en arquivo do arquivo %s',

        # Template: AdminPerformanceLog
        'Performance Log' => 'Log de Rendemento',
        'Range' => 'Intervalo',
        'last' => 'último',
        'This feature is enabled!' => 'Esta funcionalidade está activada!',
        'Just use this feature if you want to log each request.' => 'Empregue esta funcionalidade se desexa rexistrar cada solicitude.',
        'Activating this feature might affect your system performance!' =>
            'Activar esta funcionalidade pode afectar ó rendemento do seu sistema!',
        'Disable it here!' => 'Deshabiliteo aquí!',
        'Logfile too large!' => 'Arquivo de Log demasiado grande!',
        'The logfile is too large, you need to reset it' => 'O arquivo de log é demasiado grande, precisa resetealo',
        'Reset' => 'Restabelecer',
        'Overview' => 'Vista xeral',
        'Interface' => 'Interface',
        'Requests' => 'Solicitudes',
        'Min Response' => 'Resposta Min',
        'Max Response' => 'Resposta Max',
        'Average Response' => 'Resposta media',
        'Period' => 'Período',
        'minutes' => 'minutos',
        'Min' => 'Mín',
        'Max' => 'Máx',
        'Average' => 'Media',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => 'Xestión  Filtros PostMaster',
        'Add PostMaster Filter' => 'Engadir un filtro de PostMaster',
        'Edit PostMaster Filter' => 'Edito Filtro PostMaster',
        'Filter for PostMaster Filters' => '',
        'Filter for PostMaster filters' => '',
        'To dispatch or filter incoming emails based on email headers. Matching using Regular Expressions is also possible.' =>
            'Para enviar ou filtrar os emails recibidos baseado nas cabeceiras dos emails. As coincidencias empregando Expresións Regulares tamén son posibles.',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' =>
            'Sé quere que coincida soamente coa dirección de correo electrónico, empregue EMAILADDRESS:info@example.com en Desde, Para ou Cc.',
        'If you use Regular Expressions, you also can use the matched value in () as [***] in the \'Set\' action.' =>
            'Se usa Expresións Regulares, pode tamén empregar o valor que coincida en () coma [***] na acción \'Estableza\'.',
        'You can also use named captures %s and use the names in the \'Set\' action %s (e.g. Regexp: %s, Set action: %s). A matched EMAILADDRESS has the name \'%s\'.' =>
            '',
        'Delete this filter' => 'Elimine este filtro',
        'Do you really want to delete this postmaster filter?' => '',
        'A postmaster filter with this name already exists!' => '',
        'Filter Condition' => 'Condición Filtro',
        'AND Condition' => 'Condición E',
        'Search header field' => '',
        'for value' => '',
        'The field needs to be a valid regular expression or a literal word.' =>
            'O campo precisa ser unha expresión regular válida ou unha palabra literal.',
        'Negate' => 'Negar',
        'Set Email Headers' => 'Estableza Cabeceira Email',
        'Set email header' => 'Estableza cabeceira email',
        'with value' => '',
        'The field needs to be a literal word.' => 'O campo ten que ser unha palabra con letras.',
        'Header' => 'Cabeceira',

        # Template: AdminPriority
        'Priority Management' => 'Xestión das prioridades',
        'Add Priority' => 'Engadir unha prioridade',
        'Edit Priority' => 'Edite Prioridade',
        'Filter for Priorities' => '',
        'Filter for priorities' => '',
        'This priority is present in a SysConfig setting, confirmation for updating settings to point to the new priority is needed!' =>
            '',
        'This priority is used in the following config settings:' => '',

        # Template: AdminProcessManagement
        'Process Management' => 'Xestión de procesos',
        'Filter for Processes' => 'Filtre por Procedementos',
        'Filter for processes' => '',
        'Create New Process' => 'Crear un proceso novo',
        'Deploy All Processes' => 'Despregue Todolos Procesos',
        'Here you can upload a configuration file to import a process to your system. The file needs to be in .yml format as exported by process management module.' =>
            'Aquí pode cargar un arquivo de configuración para importar un proceso ao seu sistema. O arquivo necesita estar en formato .yml e exportado polo módulo de xestión de proceso.',
        'Upload process configuration' => 'Cargue a configuración do procedemento',
        'Import process configuration' => 'Configuración do proceso de importación',
        'Ready2Adopt Processes' => '',
        'Here you can activate Ready2Adopt processes showcasing our best practices. Please note that some additional configuration may be required.' =>
            '',
        'Would you like to benefit from processes created by experts? Upgrade to %s to import some sophisticated Ready2Adopt processes.' =>
            '',
        'Import Ready2Adopt process' => '',
        'To create a new Process you can either import a Process that was exported from another system or create a complete new one.' =>
            'Para crear un novo Procedemento pode importar un que fora exportado doutro sistema ou crear un completamente novo.',
        'Changes to the Processes here only affect the behavior of the system, if you synchronize the Process data. By synchronizing the Processes, the newly made changes will be written to the Configuration.' =>
            'Cambios nos Procedementos aquí só aflictirán o comportamento do sistema, se sincroniza os datos do Procedemento. Sincronizando os Procedementos, os cambios feitos de novo serán escritos na Configuración.',
        'Processes' => 'Procesos',
        'Process name' => 'Nome do proceso',
        'Print' => 'Imprimir',
        'Export Process Configuration' => 'Exportar Configuración Procedemento',
        'Copy Process' => 'Copiar proceso',

        # Template: AdminProcessManagementActivity
        'Cancel & close' => 'Cancelar e pechar',
        'Go Back' => 'Volte Atrás',
        'Please note, that changing this activity will affect the following processes' =>
            'Por favor lembre, cambiando esta actividade afectará os seguintes procedementos',
        'Activity' => 'Actividade',
        'Activity Name' => 'Nome de actividade',
        'Activity Dialogs' => 'Diálogos de actividade',
        'You can assign Activity Dialogs to this Activity by dragging the elements with the mouse from the left list to the right list.' =>
            'Pode asignar Dialogos de Actividades a esta Actividade arrastrando os elementos có rato dende a listaxe da esquerda a da dereita.',
        'Ordering the elements within the list is also possible by drag \'n\' drop.' =>
            'Ordear os elementos dentro da lista e tamén posible arrastrando e soltando.',
        'Filter available Activity Dialogs' => 'Filtros dispoñibles Dialogos Actividade',
        'Available Activity Dialogs' => 'Diálogos de actividade dispoñíbeis',
        'Name: %s, EntityID: %s' => '',
        'Create New Activity Dialog' => 'Crear un diálogo de actividade nova',
        'Assigned Activity Dialogs' => 'Diálogos de actividade asignados',

        # Template: AdminProcessManagementActivityDialog
        'Please note that changing this activity dialog will affect the following activities' =>
            'Por favor lembre que cambiar este dialogo de actividade afectará as seguintes actividades',
        'Please note that customer users will not be able to see or use the following fields: Owner, Responsible, Lock, PendingTime and CustomerID.' =>
            'Teña en conta que os usuarios clientes non poden ver ou usar os campos seguintes: Dono, Responsábel, Bloqueo, TempoPendente e IdenfificadorDeCliente.',
        'The Queue field can only be used by customers when creating a new ticket.' =>
            'O campo Fila só pode ser utilizado polos clientes ao crearen un tícket novo.',
        'Activity Dialog' => 'Diálogo de actividade',
        'Activity dialog Name' => 'Nome de diálogo de actividade',
        'Available in' => 'Dispoñíbel en',
        'Description (short)' => 'Descripción (curta)',
        'Description (long)' => 'Descripción (longa)',
        'The selected permission does not exist.' => 'O permiso escollido non existe.',
        'Required Lock' => 'Bloqueo Requirido',
        'The selected required lock does not exist.' => 'O bloqueo requirido seleccionado non existe.',
        'Submit Advice Text' => 'Envíe Texto de Consello',
        'Submit Button Text' => 'Botón Envíe Texto ',
        'You can assign Fields to this Activity Dialog by dragging the elements with the mouse from the left list to the right list.' =>
            'Vostede pode asignar Campos a este Diálogo de Actividade arrastrando os elementos co rato da lista esquerda á lista da dereita.',
        'Filter available fields' => 'Campos de filtro dispoñibles',
        'Available Fields' => 'Campos dispoñíbeis',
        'Assigned Fields' => 'Campos asignados',
        'Communication Channel' => '',
        'Is visible for customer' => '',
        'Display' => 'Mostrar',

        # Template: AdminProcessManagementPath
        'Path' => 'Ruta',
        'Edit this transition' => 'Edite esta transición',
        'Transition Actions' => 'Accións Transicións',
        'You can assign Transition Actions to this Transition by dragging the elements with the mouse from the left list to the right list.' =>
            'Pode asignar Accións de Transición a esta Transición arrastrando os elementos co rato da lista esquerda á lista da dereita.',
        'Filter available Transition Actions' => 'Filtro dispoñible para Accións Transicións',
        'Available Transition Actions' => 'Accións Transicións Dispoñibles',
        'Create New Transition Action' => 'Crear unha acción de transición nova',
        'Assigned Transition Actions' => 'Accións Transicións Asignadas',

        # Template: AdminProcessManagementProcessAccordion
        'Activities' => 'Actividades',
        'Filter Activities...' => 'Filtro Actividades...',
        'Create New Activity' => 'Crear unha actividade nova',
        'Filter Activity Dialogs...' => 'Diálogos Filtro Actividades...',
        'Transitions' => 'Transicións',
        'Filter Transitions...' => 'Filtro Transicións...',
        'Create New Transition' => 'Crear unha transición nova',
        'Filter Transition Actions...' => 'Accións Filtro Transición...',

        # Template: AdminProcessManagementProcessEdit
        'Edit Process' => 'Edite Proceso',
        'Print process information' => 'Imprima información do proceso',
        'Delete Process' => 'Elimine Proceso',
        'Delete Inactive Process' => 'Elimine Proceso Inactivo',
        'Available Process Elements' => 'Elementos de Proceso Dispoñibles',
        'The Elements listed above in this sidebar can be moved to the canvas area on the right by using drag\'n\'drop.' =>
            'Os Elementos clasificados arriba neste sidebar poden ser movidos á área canvas á dereita utilizando drag\'n\'drop.',
        'You can place Activities on the canvas area to assign this Activity to the Process.' =>
            'Vostede pode poñer Actividades na área canvas para asignar esta Actividade ao Proceso.',
        'To assign an Activity Dialog to an Activity drop the Activity Dialog element from this sidebar over the Activity placed in the canvas area.' =>
            'Para asignar un Diálogo de Actividade a unha Actividade, deixe caer o elemento de Diálogo de Actividade deste sidebar sobre a Actividade situada na área de canvas.',
        'You can start a connection between two Activities by dropping the Transition element over the Start Activity of the connection. After that you can move the loose end of the arrow to the End Activity.' =>
            '',
        'Actions can be assigned to a Transition by dropping the Action Element onto the label of a Transition.' =>
            'Accións poden ser asignadas a unha Transición baixando o Elemento de Acción á etiqueta dunha Transición.',
        'Edit Process Information' => 'Edite Información de Proceso',
        'Process Name' => 'Nome do proceso',
        'The selected state does not exist.' => 'O estado seleccionado non existe.',
        'Add and Edit Activities, Activity Dialogs and Transitions' => 'Engada e Edite Actividades, Diálogos de Actividade e Transicións',
        'Show EntityIDs' => 'Mostrar EntityIDs',
        'Extend the width of the Canvas' => 'Estenda á anchura do Canvas',
        'Extend the height of the Canvas' => 'Estenda a altura do Canvas',
        'Remove the Activity from this Process' => 'Elimine a Actividade deste Proceso',
        'Edit this Activity' => 'Edite esta Actividade',
        'Save Activities, Activity Dialogs and Transitions' => 'Garde Actividades, Diálogos de Actividade e Transicións',
        'Do you really want to delete this Process?' => 'Quere realmente borrar este Proceso?',
        'Do you really want to delete this Activity?' => 'Quere realmente borrar esta Actividade?',
        'Do you really want to delete this Activity Dialog?' => 'Confirma que desexa eliminar este diálogo de actividade?',
        'Do you really want to delete this Transition?' => 'Quere realmente borrar esta Transición?',
        'Do you really want to delete this Transition Action?' => 'Quere realmente borrar esta Acción de Transición?',
        'Do you really want to remove this activity from the canvas? This can only be undone by leaving this screen without saving.' =>
            'Quere realmente borrar esta actividade do canvas? Esto só pode ser desfeito deixando esta pantalla sen gardar.',
        'Do you really want to remove this transition from the canvas? This can only be undone by leaving this screen without saving.' =>
            'Quere realmente borrar esta transición do canvas? Esto só pode ser desfeito deixando esta pantalla sen gardar.',

        # Template: AdminProcessManagementProcessNew
        'In this screen, you can create a new process. In order to make the new process available to users, please make sure to set its state to \'Active\' and synchronize after completing your work.' =>
            'Nesta pantalla pódese crear un proceso novo. Para que o novo proceso estea a disposición dos usuarios asegúrese de que o seu estado sexa «Activo» e sincronice após completar o traballo.',

        # Template: AdminProcessManagementProcessPrint
        'cancel & close' => '',
        'Start Activity' => 'Inicie Actividade',
        'Contains %s dialog(s)' => 'Contén %s diálogo(s)',
        'Assigned dialogs' => 'Diálogos asignados',
        'Activities are not being used in this process.' => 'As Actividades non estar a ser empregadas neste proceso.',
        'Assigned fields' => 'Campos asignados',
        'Activity dialogs are not being used in this process.' => 'Non se está a usar diálogos de actividade neste proceso.',
        'Condition linking' => 'Conexión de condición',
        'Transitions are not being used in this process.' => 'As Transicións non están a ser empregadas neste proceso.',
        'Module name' => 'Nome do módulo',
        'Transition actions are not being used in this process.' => 'As Accións de Transición non están a ser empregadas neste proceso.',

        # Template: AdminProcessManagementTransition
        'Please note that changing this transition will affect the following processes' =>
            'Por favor fíxese en que cambiar esta transición afectará os procesos seguintes',
        'Transition' => 'Transición',
        'Transition Name' => 'Nome da Transición',

        # Template: AdminProcessManagementTransitionAction
        'Please note that changing this transition action will affect the following processes' =>
            'Por favor fíxese en que cambiar esta acción de transición afectará os procesos seguintes',
        'Transition Action' => 'Acción Transición',
        'Transition Action Name' => 'Nome Acción Transición',
        'Transition Action Module' => 'Módulo Acción Transición',
        'Config Parameters' => 'Parámetros Configurables',
        'Add a new Parameter' => 'Engada un novo Parámetro',
        'Remove this Parameter' => 'Elimine este Parámetro',

        # Template: AdminQueue
        'Queue Management' => '',
        'Add Queue' => 'Engadir unha fila',
        'Edit Queue' => 'Edite Cola',
        'Filter for Queues' => 'Filtro para Colas',
        'Filter for queues' => '',
        'A queue with this name already exists!' => 'Unha cola con este nome xa existe!',
        'This queue is present in a SysConfig setting, confirmation for updating settings to point to the new queue is needed!' =>
            '',
        'Sub-queue of' => 'Sub-fila de',
        'Unlock timeout' => 'Desbloquear o tempo de espera',
        '0 = no unlock' => '0 = no desbloqueo',
        'hours' => 'horas',
        'Only business hours are counted.' => 'Só se contan as horas laborábeis.',
        'If an agent locks a ticket and does not close it before the unlock timeout has passed, the ticket will unlock and will become available for other agents.' =>
            'Se un axente bloquea un ticket e non o pecha antes de que o desbloqueo do tempo de espera pasara, o ticket abrirase e volverase dispoñible para outros axentes.',
        'Notify by' => 'Notificar por',
        '0 = no escalation' => '0 = no escalado',
        'If there is not added a customer contact, either email-external or phone, to a new ticket before the time defined here expires, the ticket is escalated.' =>
            'Se non hai engadido un contacto de cliente, ben sexa por correo electrónico externo ou teléfono, a un ticket novo antes do tempo definido aquí que expira, o ticket é escalado.',
        'If there is an article added, such as a follow-up via email or the customer portal, the escalation update time is reset. If there is no customer contact, either email-external or phone, added to a ticket before the time defined here expires, the ticket is escalated.' =>
            'Se hai un artigo engadido, como un seguimento mediante correo electrónico ou o portal de cliente, o tempo de actualización de escalado é recomposto. Se non hai un contacto de cliente, ben sexa por correo electrónico externo ou teléfono, engadido a un ticket  antes do tempo definido aquí que expira, o ticket é escalado.',
        'If the ticket is not set to closed before the time defined here expires, the ticket is escalated.' =>
            'Se o ticket non é posto a pechado antes de que o tempo definido aquí expire, o ticket é escalado.',
        'Follow up Option' => 'Opción de Seguemento',
        'Specifies if follow up to closed tickets would re-open the ticket, be rejected or lead to a new ticket.' =>
            'Especifica se o seguimento a tickets pechados pode reabrir o ticket, ser rexeitado ou conducir a un ticket novo.',
        'Ticket lock after a follow up' => 'Ticket bloqueado despois dun seguimento',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked to the old owner.' =>
            'Se se pecha un tícket e o cliente envía un seguimento, o tícket bloquéase para o dono antigo.',
        'System address' => 'Enderezo do sistema',
        'Will be the sender address of this queue for email answers.' => 'Será o enderezo de remitente desta cola para respostas de correo electrónico.',
        'Default sign key' => 'Chave de sinatura por defecto',
        'To use a sign key, PGP keys or S/MIME certificates need to be added with identifiers for selected queue system address.' =>
            '',
        'Salutation' => 'Saúdo',
        'The salutation for email answers.' => 'O saúdo para as respostas por correo electrónico.',
        'Signature' => 'Sinatura',
        'The signature for email answers.' => 'A sinatura para as respostas por correo electrónico.',
        'This queue is used in the following config settings:' => '',

        # Template: AdminQueueAutoResponse
        'Manage Queue-Auto Response Relations' => 'Xestione Relacións de Resposta de Auto-Cola',
        'Change Auto Response Relations for Queue' => 'Cambie Relacións de Resposta Auto para Cola',
        'This filter allow you to show queues without auto responses' => '',
        'Queues without Auto Responses' => '',
        'This filter allow you to show all queues' => '',
        'Show All Queues' => '',
        'Auto Responses' => 'Respostas automáticas',

        # Template: AdminQueueTemplates
        'Manage Template-Queue Relations' => 'Xestionar as relacións modelo-fila',
        'Filter for Templates' => 'Filtro para Modelos',
        'Filter for templates' => '',
        'Templates' => 'Modelos',

        # Template: AdminRegistration
        'System Registration Management' => 'Xestión do rexistro no sistema',
        'Edit System Registration' => '',
        'System Registration Overview' => '',
        'Register System' => '',
        'Validate OTRS-ID' => '',
        'Deregister System' => 'Desrexistrar Sistema',
        'Edit details' => 'Edite detalles',
        'Show transmitted data' => 'Mostrar os datos transmitidos',
        'Deregister system' => 'Desrexistre sistema',
        'Overview of registered systems' => 'Vista xeral dos sistemas rexistrados',
        'This system is registered with OTRS Group.' => 'Este sistema é rexistrado co grupo OTRS.',
        'System type' => 'Tipo de sistema',
        'Unique ID' => 'ID Único',
        'Last communication with registration server' => 'Derradeira comunicación co servidor de rexistro',
        'System Registration not Possible' => '',
        'Please note that you can\'t register your system if OTRS Daemon is not running correctly!' =>
            'Por favor tenga en conta que non pode rexistrar o seu sistema se o Daemon OTRS non se está a executar correctamente!',
        'Instructions' => 'Instrucións',
        'System Deregistration not Possible' => '',
        'Please note that you can\'t deregister your system if you\'re using the %s or having a valid service contract.' =>
            'Por favor fíxese que non pode desrexistrar o seu sistema se está empregando %s ou tendo un contrato de servizo válido.',
        'OTRS-ID Login' => 'Log-In OTRS-ID',
        'Read more' => 'Ler máis',
        'You need to log in with your OTRS-ID to register your system.' =>
            'Necesita conectarse coa súa identidade de OTRS para rexistrar o seu sistema.',
        'Your OTRS-ID is the email address you used to sign up on the OTRS.com webpage.' =>
            'O seu OTRS-ID é o enderezo de correo electrónico que empregou para darse de alta na páxina web OTRS.com.',
        'Data Protection' => 'Protección de datos',
        'What are the advantages of system registration?' => 'Cales son as ventaxas do sistema de rexistro?',
        'You will receive updates about relevant security releases.' => 'Recibirá actualizacións sobre presentacións de seguridade relevantes.',
        'With your system registration we can improve our services for you, because we have all relevant information available.' =>
            'Co seu rexistro de sistema podemos mellorar os nosos servizos para vostede, porque temos toda a información relevante dispoñible.',
        'This is only the beginning!' => 'Esto é só o comezo!',
        'We will inform you about our new services and offerings soon.' =>
            'Informarémolo dos nosos novos servizos e ofertas pronto.',
        'Can I use OTRS without being registered?' => 'Podo usar OTRS sen estar rexistrado?',
        'System registration is optional.' => 'O rexistro do sistema é optativo.',
        'You can download and use OTRS without being registered.' => 'Vostede pode descargar e utilizar OTRS sen ser rexistrado.',
        'Is it possible to deregister?' => 'É posible desrexistrarse?',
        'You can deregister at any time.' => 'pode desrexistrarse en calquera momento.',
        'Which data is transfered when registering?' => 'Que datos son transferidos cando rexístrome?',
        'A registered system sends the following data to OTRS Group:' => 'Un sistema rexistrado envía os seguintes datos o Grupo OTRS:',
        'Fully Qualified Domain Name (FQDN), OTRS version, Database, Operating System and Perl version.' =>
            'Nome de Dominio Completo (FQDN), versión de OTRS, Base de datos, Sistema Operativo e versión Perl.',
        'Why do I have to provide a description for my system?' => 'Por que teño que proporcionar unha descrición do meu sistema?',
        'The description of the system is optional.' => 'A descrición do sistema é opcional.',
        'The description and system type you specify help you to identify and manage the details of your registered systems.' =>
            'A descrición e o tipo de sistema que indique axudan a identificar e xestionar os detalles dos sistemas que teña rexistrados.',
        'How often does my OTRS system send updates?' => 'Con que frecuencia envía actualizacións o meu sistema OTRS?',
        'Your system will send updates to the registration server at regular intervals.' =>
            'O seu sistema enviará actualizacións ao servidor de rexistro en intervalos regulares.',
        'Typically this would be around once every three days.' => 'Tipicamente isto sería por volta de unha vez cada tres días.',
        'If you deregister your system, you will lose these benefits:' =>
            'Se vostede desrexistra o seu sistema, perderá estes beneficios:',
        'You need to log in with your OTRS-ID to deregister your system.' =>
            'Vostede necesita conectarse coa súa identidade de OTRS para desrexistrar o seu sistema.',
        'OTRS-ID' => 'OTRS-ID',
        'You don\'t have an OTRS-ID yet?' => 'Ainda non ten unha ID-OTRS?',
        'Sign up now' => 'Inscríbase agora',
        'Forgot your password?' => 'Olvidou a sua contrasinal?',
        'Retrieve a new one' => 'Consiga unha nova',
        'Next' => 'Seguinte',
        'This data will be frequently transferred to OTRS Group when you register this system.' =>
            'Estes datos serán frecuentemente transferidos a Grupo OTRS cando rexistre este sistema.',
        'Attribute' => 'Atributo',
        'FQDN' => 'FQDN',
        'OTRS Version' => 'Versión do OTRS',
        'Operating System' => 'Sistema Operativo',
        'Perl Version' => 'Versión de Perl',
        'Optional description of this system.' => 'Descripción opcional deste sistema.',
        'Register' => 'Rexistro',
        'Continuing with this step will deregister the system from OTRS Group.' =>
            'Se continúa con este paso ha anular o rexistro do sistema no Grupo OTRS.',
        'Deregister' => 'Desrexistrar',
        'You can modify registration settings here.' => 'Pode modificar os axustes de rexistro aquí.',
        'Overview of Transmitted Data' => '',
        'There is no data regularly sent from your system to %s.' => 'Non hai datos enviados regularmente do seu sistema a %s.',
        'The following data is sent at minimum every 3 days from your system to %s.' =>
            'Os datos seguintes envíanse como mínimo cada tres días desde o sistema a %s.',
        'The data will be transferred in JSON format via a secure https connection.' =>
            'Os datos transferidos en formato JSON vía unha conexión segura https.',
        'System Registration Data' => 'Datos de rexistro no sistema',
        'Support Data' => 'Datos de axuda',

        # Template: AdminRole
        'Role Management' => 'Xestión de papeis',
        'Add Role' => 'Engadir un papel',
        'Edit Role' => 'Editar o papel',
        'Filter for Roles' => 'Filtrar por papeis',
        'Filter for roles' => '',
        'Create a role and put groups in it. Then add the role to the users.' =>
            'Cree un papel e coloque grupos nel. A seguir, engada o papel aos usuarios.',
        'There are no roles defined. Please use the \'Add\' button to create a new role.' =>
            'Non hai ningún papel definido. Empregue o botón «Engadir» para crear un papel novo.',

        # Template: AdminRoleGroup
        'Manage Role-Group Relations' => 'Xestionar as relacións papel-grupo',
        'Roles' => 'Papeis',
        'Select the role:group permissions.' => 'Seleccione os permisos de role:group.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the role).' =>
            'Se nada é seleccionado, entón non hai permisos neste grupo (os tickets non estarán dispoñibles para o rol).',
        'Toggle %s permission for all' => 'Conmutar permiso %s para todos',
        'move_into' => 'moverse_en',
        'Permissions to move tickets into this group/queue.' => 'Permisos para mover tickets neste grupo/cola.',
        'create' => 'crear',
        'Permissions to create tickets in this group/queue.' => 'Permisos para creartickets neste grupo/cola.',
        'note' => 'nota',
        'Permissions to add notes to tickets in this group/queue.' => 'Permisos para engadir notas a tickets neste grupo/cola.',
        'owner' => 'dono',
        'Permissions to change the owner of tickets in this group/queue.' =>
            'Permisos para cambiar o propietario dos tickets neste grupo/cola.',
        'priority' => 'prioridade',
        'Permissions to change the ticket priority in this group/queue.' =>
            'Permisos para cambiar a prioridade dos tickets neste grupo/cola.',

        # Template: AdminRoleUser
        'Manage Agent-Role Relations' => 'Xestionar as relacións axente-papel',
        'Add Agent' => 'Engadir un axente',
        'Filter for Agents' => 'Fiiltro para Axentes',
        'Filter for agents' => '',
        'Agents' => 'Axentes',
        'Manage Role-Agent Relations' => 'Xestionar as relacións papel-axente',

        # Template: AdminSLA
        'SLA Management' => 'Xestión de ACL',
        'Edit SLA' => 'Editar o SLA',
        'Add SLA' => 'Engadir un SLA',
        'Filter for SLAs' => '',
        'Please write only numbers!' => 'Por favor escriba só números!',

        # Template: AdminSMIME
        'S/MIME Management' => 'Xestión de S/MIME',
        'Add Certificate' => 'Engadir un certificado',
        'Add Private Key' => 'Engadir unha chave privada',
        'SMIME support is disabled' => '',
        'To be able to use SMIME in OTRS, you have to enable it first.' =>
            '',
        'Enable SMIME support' => '',
        'Faulty SMIME configuration' => '',
        'SMIME support is enabled, but the relevant configuration contains errors. Please check the configuration using the button below.' =>
            '',
        'Check SMIME configuration' => '',
        'Filter for Certificates' => '',
        'Filter for certificates' => 'Filtro para certificados',
        'To show certificate details click on a certificate icon.' => 'Para mostrar os detalles do certificado prema no icono do certificado.',
        'To manage private certificate relations click on a private key icon.' =>
            'Para manexar as relacións de certificado privadas faga clic no icono de clave privada.',
        'Here you can add relations to your private certificate, these will be embedded to the S/MIME signature every time you use this certificate to sign an email.' =>
            'Aquí vostede pode engadir relacións ao seu certificado confidencial, estes serán incrustados á sinatura de S/MIME cada vez que vostede usa este certificado para asinar un correo electrónico.',
        'See also' => 'Consulte tamén',
        'In this way you can directly edit the certification and private keys in file system.' =>
            'Desta forma vostede pode directamente editar a certificación e chaves privadas no sistema de arquivos.',
        'Hash' => 'Hash',
        'Create' => 'Crear',
        'Handle related certificates' => 'Manipular os certificados relacionados',
        'Read certificate' => 'Leer certificado',
        'Delete this certificate' => 'Elimine este certificado',
        'File' => 'Ficheiro',
        'Secret' => 'Secreto',
        'Related Certificates for' => 'Certificados relacionados de',
        'Delete this relation' => 'Elimene esta relación',
        'Available Certificates' => 'Certificados dispoñíbeis',
        'Filter for S/MIME certs' => 'Filtro para certificados S/MIME',
        'Relate this certificate' => 'Relacionar este certificado',

        # Template: AdminSMIMECertRead
        'S/MIME Certificate' => 'Certificado S/MIME',
        'Close this dialog' => 'Pechar este diálogo',
        'Certificate Details' => '',

        # Template: AdminSalutation
        'Salutation Management' => 'Xestión de Saúdos',
        'Add Salutation' => 'Engadir un saúdo',
        'Edit Salutation' => 'Edite Saúdo',
        'Filter for Salutations' => '',
        'Filter for salutations' => '',
        'e. g.' => 'por exemplo',
        'Example salutation' => 'Saúdo de exemplo',

        # Template: AdminSecureMode
        'Secure Mode Needs to be Enabled!' => '',
        'Secure mode will (normally) be set after the initial installation is completed.' =>
            'O modo seguro será (normalmente) fixado despois de que a instalación inicial sexa completada.',
        'If secure mode is not activated, activate it via SysConfig because your application is already running.' =>
            'Se o modo seguro non está activado, actíveo via SysConfig porque a súa aplicación estase a executar.',

        # Template: AdminSelectBox
        'SQL Box' => 'SQL',
        'Filter for Results' => '',
        'Filter for results' => '',
        'Here you can enter SQL to send it directly to the application database. It is not possible to change the content of the tables, only select queries are allowed.' =>
            'Aquí vostede pode introducir SQL para envialo directamente á base de datos da aplicación. Non é posible cambiar o contido das táboas, soamente as consultas select son permitidas.',
        'Here you can enter SQL to send it directly to the application database.' =>
            'Aquí vostede pode introducir SQL para envialo directamente á base de datos da aplicación.',
        'Options' => 'Opcións',
        'Only select queries are allowed.' => 'Soamente consultas select son permitidas.',
        'The syntax of your SQL query has a mistake. Please check it.' =>
            'A sintaxe da súa consulta de SQL ten un erro. Por favor compróbea.',
        'There is at least one parameter missing for the binding. Please check it.' =>
            'Hai polo menos un parámetro que falla para a unión. Por favor compróbeo.',
        'Result format' => 'Formato resultante',
        'Run Query' => 'Executar a consulta',
        '%s Results' => '',
        'Query is executed.' => 'A consulta foi executada.',

        # Template: AdminService
        'Service Management' => 'Xestión de servizos',
        'Add Service' => 'Engadir un servizo',
        'Edit Service' => 'Edite Servizo',
        'Service name maximum length is 200 characters (with Sub-service).' =>
            '',
        'Sub-service of' => 'Sub-servizo de',

        # Template: AdminSession
        'Session Management' => 'Xestión de sesións',
        'Detail Session View for %s (%s)' => '',
        'All sessions' => 'Todas as sesións',
        'Agent sessions' => 'Sesións de axentes',
        'Customer sessions' => 'Sesións do cliente',
        'Unique agents' => 'Axentes únicos',
        'Unique customers' => 'Clientes únicos',
        'Kill all sessions' => 'Matar todas as sesións',
        'Kill this session' => 'Matar esta sesión',
        'Filter for Sessions' => '',
        'Filter for sessions' => '',
        'Session' => 'Sesión',
        'User' => 'Usuario',
        'Kill' => 'Matar',
        'Detail View for SessionID: %s - %s' => '',

        # Template: AdminSignature
        'Signature Management' => 'Xestión de Sinatura',
        'Add Signature' => 'Engadir unha sinatura',
        'Edit Signature' => 'Edite Sinatura',
        'Filter for Signatures' => '',
        'Filter for signatures' => '',
        'Example signature' => 'Exemplo de sinatura',

        # Template: AdminState
        'State Management' => 'Estado',
        'Add State' => 'Engadir un estado',
        'Edit State' => 'Edite Estado',
        'Filter for States' => '',
        'Filter for states' => '',
        'Attention' => 'Atención',
        'Please also update the states in SysConfig where needed.' => 'Por favor actualice os estados en SysConfig cando sexa necesario.',
        'This state is present in a SysConfig setting, confirmation for updating settings to point to the new type is needed!' =>
            '',
        'State type' => 'Tipo estado',
        'It\'s not possible to invalidate this entry because there is no other merge states in system!' =>
            '',
        'This state is used in the following config settings:' => '',

        # Template: AdminSupportDataCollector
        'Sending support data to OTRS Group is not possible!' => '',
        'Enable Cloud Services' => '',
        'This data is sent to OTRS Group on a regular basis. To stop sending this data please update your system registration.' =>
            'Estes datos son enviados a Grupo OTRS nunha base regular. Para parar de enviar a estes datos por favor actualice o seu rexistro de sistema.',
        'You can manually trigger the Support Data sending by pressing this button:' =>
            'Pódese disparar manualmente o envío de datos de axuda premendo neste botón:',
        'Send Update' => 'Enviar Actualización',
        'Currently this data is only shown in this system.' => 'Actualmente este dato é mostrado soamente neste sistema.',
        'A support bundle (including: system registration information, support data, a list of installed packages and all locally modified source code files) can be generated by pressing this button:' =>
            'Un paquetede de apoio (incluíndo: información de rexistro de sistema, datos de apoio, unha lista de paquetes instalados e todolos arquivos de código fonte localmente modificados) pode ser xerado apertando este botón:',
        'Generate Support Bundle' => 'Xeración Paquete de Apoio',
        'The Support Bundle has been Generated' => '',
        'Please choose one of the following options.' => 'Por favor escolla unha das seguintes opcións.',
        'Send by Email' => 'Enviado por Correo Electrónico',
        'The support bundle is too large to send it by email, this option has been disabled.' =>
            'O paquete de apoio e demasiado grande para envialo por correo electrónico, esta opción foi desactivada.',
        'The email address for this user is invalid, this option has been disabled.' =>
            'O enderezo de correo electrónico para este usuario non é valido, esta opción foi desactivada.',
        'Sending' => 'Enviando',
        'The support bundle will be sent to OTRS Group via email automatically.' =>
            'O paquete de apoio será enviado a Grupo OTRS mediante correo electrónico automaticamente.',
        'Download File' => 'Descargue Arquivo',
        'A file containing the support bundle will be downloaded to the local system. Please save the file and send it to the OTRS Group, using an alternate method.' =>
            'Un arquivo que contén o paquete de apoio será descargado no sistema local. Por favor garde o arquivo e envíeo ao Grupo OTRS, utilizando un método alternativo.',
        'Error: Support data could not be collected (%s).' => 'Erro: Non foi posíbel recoller os datos de axuda (%s).',
        'Details' => 'Detalles',

        # Template: AdminSystemAddress
        'System Email Addresses Management' => 'Xestión Enderezos de Correo Electrónico de Sistema',
        'Add System Email Address' => 'Engadir un enderezo de correo do sistema',
        'Edit System Email Address' => 'Edite Enderezo de Correo Electrónico de Sistema',
        'Add System Address' => '',
        'Filter for System Addresses' => '',
        'Filter for system addresses' => '',
        'All incoming email with this address in To or Cc will be dispatched to the selected queue.' =>
            'Todo o correo entrante con este enderezo en A: ou Copia: será despachado á fila seleccionada.',
        'Email address' => 'Enderezo de correo electrónico',
        'Display name' => 'Nome a mostrar',
        'This email address is already used as system email address.' => '',
        'The display name and email address will be shown on mail you send.' =>
            'O nome de mostra e o enderezo de correo electrónico será acompañado no correo que vostede envía.',
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
        'Category' => 'Categoría',
        'Run search' => 'Comezar busca',

        # Template: AdminSystemConfigurationView
        'View a custom List of Settings' => '',
        'View single Setting: %s' => '',
        'Go back to Deployment Details' => '',

        # Template: AdminSystemMaintenance
        'System Maintenance Management' => 'Xestión do mantemento do sistema',
        'Schedule New System Maintenance' => 'Programe Novo Mantemento de Sistema',
        'Filter for System Maintenances' => '',
        'Filter for system maintenances' => '',
        'Schedule a system maintenance period for announcing the Agents and Customers the system is down for a time period.' =>
            'Programar un período de mantemento do sistema para anunciar a axentes e clientes que o sistema estará inaccesíbel durante un período de tempo.',
        'Some time before this system maintenance starts the users will receive a notification on each screen announcing about this fact.' =>
            'Algún tempo antes de que este mantemento de sistema empece os usuarios recibirán unha notificación en cada pantalla que anuncia sobre este feito.',
        'Stop date' => 'Data de parada',
        'Delete System Maintenance' => 'Borre Mantemento de Sistema',

        # Template: AdminSystemMaintenanceEdit
        'Edit System Maintenance' => '',
        'Edit System Maintenance Information' => '',
        'Date invalid!' => 'A data é incorrecta!',
        'Login message' => 'mensaxe de acceso',
        'This field must have less then 250 characters.' => '',
        'Show login message' => 'Mostre mensaxe de login',
        'Notify message' => 'Notifique mensaxe',
        'Manage Sessions' => 'Xestionar as sesións',
        'All Sessions' => 'Todas as sesións',
        'Agent Sessions' => 'Sesións de axentes',
        'Customer Sessions' => 'Sesións do cliente',
        'Kill all Sessions, except for your own' => 'Matar todas as sesións, excepto a súa.',

        # Template: AdminTemplate
        'Template Management' => '',
        'Add Template' => 'Engadir un modelo',
        'Edit Template' => 'Editar o modelo',
        'A template is a default text which helps your agents to write faster tickets, answers or forwards.' =>
            'Un modelo é un texto predeterminado que axuda os axentes a escribiren tíckets, respostas ou encamiñamentos máis rápidos.',
        'Don\'t forget to add new templates to queues.' => 'Non esqueza de engadir novos modelos as colas',
        'Attachments' => 'Anexos',
        'Delete this entry' => 'Borre esta entrada',
        'Do you really want to delete this template?' => '',
        'A standard template with this name already exists!' => 'Un modelo estandard con este nome xa existe!',
        'Template' => 'Modelo',
        'To get the first 20 characters of the subject of the current/latest agent article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            '',
        'To get the first 5 lines of the body of the current/latest agent article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            '',
        'To get the first 20 characters of the subject of the current/latest article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            '',
        'To get the first 5 lines of the body of the current/latest article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            '',
        'Create type templates only supports this smart tags' => 'Cree modelos tipo só soportados por estos smart tags',
        'Example template' => 'Modelo exemplo',
        'The current ticket state is' => 'O estado do tícket actual é',
        'Your email address is' => 'O seu enderezo de correo electrónico é',

        # Template: AdminTemplateAttachment
        'Manage Template-Attachment Relations' => '',
        'Toggle active for all' => 'Alternar activo para todos',
        'Link %s to selected %s' => 'Ligue %s cos seleccionados %s',

        # Template: AdminType
        'Type Management' => 'Xestión de tipos',
        'Add Type' => 'Engadir un tipo',
        'Edit Type' => 'Edite Tipo',
        'Filter for Types' => '',
        'Filter for types' => '',
        'A type with this name already exists!' => 'Un tipo con este nome xa existe!',
        'This type is present in a SysConfig setting, confirmation for updating settings to point to the new type is needed!' =>
            '',
        'This type is used in the following config settings:' => '',

        # Template: AdminUser
        'Agent Management' => 'Xestión de axentes',
        'Edit Agent' => 'Edite Axente',
        'Edit personal preferences for this agent' => '',
        'Agents will be needed to handle tickets.' => 'Axentes serán necesitados para manexar tickets.',
        'Don\'t forget to add a new agent to groups and/or roles!' => 'Non esqueza de engadir a un novo axente a grupos e/ou roles!',
        'Please enter a search term to look for agents.' => 'Por favor entre un termo de busca para buscar axentes.',
        'Last login' => 'Último acceso',
        'Switch to agent' => 'Cambie a axente',
        'Title or salutation' => '',
        'Firstname' => 'Nome',
        'Lastname' => 'Apelido',
        'A user with this username already exists!' => 'Un usuario con este nome de usuario xa existe!',
        'Will be auto-generated if left empty.' => 'Será auto-xerada se é deixado baleiro.',
        'Mobile' => 'Móbil',
        'Effective Permissions for Agent' => '',
        'This agent has no group permissions.' => '',
        'Table above shows effective group permissions for the agent. The matrix takes into account all inherited permissions (e.g. via roles).' =>
            '',

        # Template: AdminUserGroup
        'Manage Agent-Group Relations' => 'Xestionar as relacións axente-grupo',

        # Template: AgentAppointmentAgendaOverview
        'Agenda Overview' => '',
        'Manage Calendars' => '',
        'Add Appointment' => '',
        'Today' => 'Hoxe',
        'All-day' => 'Todo o día',
        'Repeat' => '',
        'Notification' => 'Notificación',
        'Yes' => 'Si',
        'No' => 'Non',
        'No calendars found. Please add a calendar first by using Manage Calendars page.' =>
            '',

        # Template: AgentAppointmentCalendarOverview
        'Add new Appointment' => '',
        'Calendars' => '',

        # Template: AgentAppointmentEdit
        'Basic information' => '',
        'Date/Time' => '',
        'Invalid date!' => 'Data incorrecta!',
        'Please set this to value before End date.' => '',
        'Please set this to value after Start date.' => '',
        'This an occurrence of a repeating appointment.' => '',
        'Click here to see the parent appointment.' => '',
        'Click here to edit the parent appointment.' => '',
        'Frequency' => '',
        'Every' => '',
        'day(s)' => 'día(s)',
        'week(s)' => 'semana(s)',
        'month(s)' => 'mes(es)',
        'year(s)' => 'ano(s)',
        'On' => 'Activado',
        'Monday' => 'Luns',
        'Mon' => 'Lu',
        'Tuesday' => 'Martes',
        'Tue' => 'Mar',
        'Wednesday' => 'Mércores',
        'Wed' => 'Unirse con',
        'Thursday' => 'Xoves',
        'Thu' => 'Xo',
        'Friday' => 'Venres',
        'Fri' => 'Ve',
        'Saturday' => 'Sábado',
        'Sat' => 'Sá',
        'Sunday' => 'Domingo',
        'Sun' => 'Do',
        'January' => 'Xaneiro',
        'Jan' => 'Xan',
        'February' => 'Febreiro',
        'Feb' => 'Feb',
        'March' => 'Marzo',
        'Mar' => 'Mar',
        'April' => 'Abril',
        'Apr' => 'Abr',
        'May_long' => 'Maio',
        'May' => 'Maio',
        'June' => 'Xuño',
        'Jun' => 'Xñ',
        'July' => 'Xullo',
        'Jul' => 'Xl',
        'August' => 'Agosto',
        'Aug' => 'Ag',
        'September' => 'Setembro',
        'Sep' => 'Definir',
        'October' => 'Outubro',
        'Oct' => 'Out',
        'November' => 'Novembro',
        'Nov' => 'Nov',
        'December' => 'Decembro',
        'Dec' => 'Dec',
        'Relative point of time' => '',
        'Link' => 'Ligar',
        'Remove entry' => 'Elimine entrada',

        # Template: AgentCustomerInformationCenter
        'Customer Information Center' => 'Centro de información ao cliente',

        # Template: AgentCustomerInformationCenterSearch
        'Customer User' => 'Usuario cliente',

        # Template: AgentCustomerTableView
        'Note: Customer is invalid!' => 'Nota: O cliente non é correcto!',
        'Start chat' => 'Comece chat',
        'Video call' => '',
        'Audio call' => '',

        # Template: AgentCustomerUserAddressBook
        'Customer User Address Book' => '',
        'Search for recipients and add the results as \'%s\'.' => '',
        'Search template' => 'Busque modelo',
        'Create Template' => 'Para crear un modelo',
        'Create New' => 'Crear novo',
        'Save changes in template' => 'Garde cambios no modelo',
        'Filters in use' => 'Filtros en uso',
        'Additional filters' => 'Filtros adicionais',
        'Add another attribute' => 'Engadir outro atributo',
        'The attributes with the identifier \'(Customer)\' are from the customer company.' =>
            '',
        '(e. g. Term* or *Term*)' => '',

        # Template: AgentCustomerUserAddressBookOverview
        'Select all' => 'Seleccionar todo',
        'The customer user is already selected in the ticket mask.' => '',
        'Select this customer user' => '',
        'Add selected customer user to' => '',

        # Template: AgentCustomerUserAddressBookOverviewNavBar
        'Change search options' => 'Cambiar as opcións de busca',

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
        'Dashboard' => 'Taboleiro',

        # Template: AgentDashboardAppointmentCalendar
        'New Appointment' => '',
        'Tomorrow' => 'Mañá',
        'Soon' => '',
        '5 days' => '',
        'Start' => 'Inicio',
        'none' => 'ningún',

        # Template: AgentDashboardCalendarOverview
        'in' => 'en',

        # Template: AgentDashboardCommon
        'Save settings' => 'Gardar a configuración',
        'Close this widget' => '',
        'more' => 'máis',
        'Available Columns' => 'Columnas dispoñíbeis',
        'Visible Columns (order by drag & drop)' => 'Columnas visibles (orde por arrastre & caída)',

        # Template: AgentDashboardCustomerIDList
        'Change Customer Relations' => '',
        'Open' => 'Abrir',
        'Closed' => 'Pechado',
        '%s open ticket(s) of %s' => '%s tícket(s) abertos de %s',
        '%s closed ticket(s) of %s' => '%s tícket(s) pechado(s) de %s',
        'Edit customer ID' => '',

        # Template: AgentDashboardCustomerIDStatus
        'Escalated tickets' => 'Tickets escalados',
        'Open tickets' => 'Tickets abertos',
        'Closed tickets' => 'Tíckets pechados',
        'All tickets' => 'Todos os tíckets',
        'Archived tickets' => 'Tíckets arquivados',

        # Template: AgentDashboardCustomerUserInformation
        'Note: Customer User is invalid!' => '',

        # Template: AgentDashboardCustomerUserList
        'Customer user information' => '',
        'Phone ticket' => 'Ticket telefónico',
        'Email ticket' => 'Ticket correo electrónico',
        'New phone ticket from %s' => 'Novo ticket telefónico de %s',
        'New email ticket to %s' => 'Novo ticket de correo electrónico a %s',

        # Template: AgentDashboardProductNotify
        '%s %s is available!' => '%s %s está dispoñíbel!',
        'Please update now.' => 'Por favor actualice agora',
        'Release Note' => 'Nota de versión',
        'Level' => 'Nivel',

        # Template: AgentDashboardRSSOverview
        'Posted %s ago.' => 'Publicado fai %s ',

        # Template: AgentDashboardStats
        'The configuration for this statistic widget contains errors, please review your settings.' =>
            'A configuración para este widget estático contén erros, por favor revise os seus axustes.',
        'Download as SVG file' => 'Descargar como ficheiro SVG',
        'Download as PNG file' => 'Descargar como ficheiro PNG',
        'Download as CSV file' => 'Descargar como ficheiro CSV',
        'Download as Excel file' => 'Descargar como ficheiro do Excel',
        'Download as PDF file' => 'Descargar como ficheiro PDF',
        'Please select a valid graph output format in the configuration of this widget.' =>
            'Por favor seleccione un formato de saída de gráficos valido na configuración deste widget.',
        'The content of this statistic is being prepared for you, please be patient.' =>
            'O contido desta estatística está a ser preparado para vostede, por favor sexa paciente.',
        'This statistic can currently not be used because its configuration needs to be corrected by the statistics administrator.' =>
            'Esta estatística pode non estra a ser usada actualmente debido a que a súa configuración precisa ser correxida polo administrador de estatísticas.',

        # Template: AgentDashboardTicketGeneric
        'Assigned to customer user' => '',
        'Accessible for customer user' => '',
        'My locked tickets' => 'Os meus tíckets bloqueados',
        'My watched tickets' => 'Os meus tickets mirados',
        'My responsibilities' => 'As miñas responsabilidades',
        'Tickets in My Queues' => 'Tíckets nas miñas filas',
        'Tickets in My Services' => 'Tickets en Meus Servizos',
        'Service Time' => 'Tempo de servizo',

        # Template: AgentDashboardTicketQueueOverview
        'Total' => 'Total',

        # Template: AgentDashboardUserOnline
        'out of office' => 'fóra da oficina',

        # Template: AgentDashboardUserOutOfOffice
        'until' => 'ata',

        # Template: AgentInfo
        'To accept some news, a license or some changes.' => 'Para aceptar algunhas noticias, un permiso ou algúns cambios.',
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
        'Edit your preferences' => 'Edite as súas preferencias',
        'Personal Preferences' => '',
        'Preferences' => 'Preferencias',
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
        'Off' => 'Desactivado',
        'End' => 'Fin',
        'This setting can currently not be saved.' => '',
        'This setting can currently not be saved' => '',
        'Save this setting' => '',
        'Did you know? You can help translating OTRS at %s.' => 'Sabíao? Pode axudar na tradución do OTRS en %s.',

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
        'Process' => 'Proceso',
        'Split' => 'Dividir',

        # Template: AgentStatisticsAdd
        'Statistics Management' => '',
        'Add Statistics' => '',
        'Read more about statistics in OTRS' => '',
        'Dynamic Matrix' => 'Matriz dinámica',
        'Each cell contains a singular data point.' => '',
        'Dynamic List' => 'Lista Dinámica',
        'Each row contains data of one entity.' => '',
        'Static' => 'Estático',
        'Non-configurable complex statistics.' => '',
        'General Specification' => 'Especificación xeral',
        'Create Statistic' => 'Crear estatísticas',

        # Template: AgentStatisticsEdit
        'Edit Statistics' => '',
        'Run now' => 'Executar agora',
        'Statistics Preview' => 'Visualización das estatísticas',
        'Save Statistic' => '',

        # Template: AgentStatisticsImport
        'Import Statistics' => '',
        'Import Statistics Configuration' => '',

        # Template: AgentStatisticsOverview
        'Statistics' => 'Estatísticas',
        'Run' => 'Executar',
        'Edit statistic "%s".' => 'Editar as estatísticas «%s».',
        'Export statistic "%s"' => 'Exportar as estatísticas «%s»',
        'Export statistic %s' => 'Exportar as estatísticas %s',
        'Delete statistic "%s"' => 'Eliminar as estatísticas «%s»',
        'Delete statistic %s' => 'Eliminar as estatísticas %s',

        # Template: AgentStatisticsView
        'Statistics Overview' => '',
        'View Statistics' => '',
        'Statistics Information' => '',
        'Created by' => 'Creado por',
        'Changed by' => 'Cambiado por',
        'Sum rows' => 'Filas de suma',
        'Sum columns' => 'Columnas de suma',
        'Show as dashboard widget' => 'Mostrar como trebello no taboleiro',
        'Cache' => 'Caché',
        'This statistic contains configuration errors and can currently not be used.' =>
            'Esta estatística contén erros de configuración e actualmente non pode ser usada.',

        # Template: AgentTicketActionCommon
        'Change Free Text of %s%s%s' => '',
        'Change Owner of %s%s%s' => '',
        'Close %s%s%s' => '',
        'Add Note to %s%s%s' => '',
        'Set Pending Time for %s%s%s' => '',
        'Change Priority of %s%s%s' => '',
        'Change Responsible of %s%s%s' => '',
        'All fields marked with an asterisk (*) are mandatory.' => 'Todos os campos marcados cun asterisco (*) son obrigatorios.',
        'The ticket has been locked' => 'O tícket foi bloqueado',
        'Undo & close' => 'Desfacer e pechar',
        'Ticket Settings' => 'Axustes do Ticket',
        'Queue invalid.' => '',
        'Service invalid.' => 'Servizo incorrecto.',
        'SLA invalid.' => '',
        'New Owner' => 'Novo dono',
        'Please set a new owner!' => 'Por favor estableza novo propietario!',
        'Owner invalid.' => '',
        'New Responsible' => 'Novo Responsable',
        'Please set a new responsible!' => '',
        'Responsible invalid.' => '',
        'Next state' => 'Estado seguinte',
        'State invalid.' => '',
        'For all pending* states.' => 'Para tódolos estados pendentes.',
        'Add Article' => 'Engadir un artigo',
        'Create an Article' => 'Crear un artigo',
        'Inform agents' => '',
        'Inform involved agents' => '',
        'Here you can select additional agents which should receive a notification regarding the new article.' =>
            'Aquí pode seleccionar axentes adicionais os cales deberán recibir unha notificación respecto do novo artigo.',
        'Text will also be received by' => '',
        'Text Template' => 'Modelo Texto',
        'Setting a template will overwrite any text or attachment.' => 'Establecer un modelo sobreescribira calquira texto ou anexo.',
        'Invalid time!' => 'Hora incorrecta!',

        # Template: AgentTicketBounce
        'Bounce %s%s%s' => '',
        'Bounce to' => 'Facer rebotar a',
        'You need a email address.' => 'Necesita un enderezo de correo electrónico.',
        'Need a valid email address or don\'t use a local email address.' =>
            'Necesita un enderezo de correo electrónico valido ou non use un enderezo de correo electrónico local.',
        'Next ticket state' => 'estado seguinte do tícket',
        'Inform sender' => 'Informar o remitente',
        'Send mail' => 'Envía mail',

        # Template: AgentTicketBulk
        'Ticket Bulk Action' => 'Acción en Masa de Ticket',
        'Send Email' => 'Envíe Email',
        'Merge' => 'Combinar',
        'Merge to' => 'Combinar con',
        'Invalid ticket identifier!' => 'Identificador de ticket inválido!',
        'Merge to oldest' => 'Combinar co máis antigo',
        'Link together' => 'Conéctese xunto',
        'Link to parent' => 'Ligar a pai',
        'Unlock tickets' => 'Desbloquear tickets',
        'Execute Bulk Action' => '',

        # Template: AgentTicketCompose
        'Compose Answer for %s%s%s' => '',
        'This address is registered as system address and cannot be used: %s' =>
            '',
        'Please include at least one recipient' => 'Por favor inclúa polo menos un receptor',
        'Select one or more recipients from the customer user address book.' =>
            '',
        'Customer user address book' => '',
        'Remove Ticket Customer' => 'Elimine Ticket Cliente',
        'Please remove this entry and enter a new one with the correct value.' =>
            'Por favor elimine esta entrada e introdúzao unha nova co valor correcto.',
        'This address already exists on the address list.' => 'Este enderezo xa existe na lista de enderezos.',
        'Remove Cc' => 'Elimine Cc',
        'Bcc' => 'Copia oculta',
        'Remove Bcc' => 'Elimine Bcc',
        'Date Invalid!' => 'A data é incorrecta!',

        # Template: AgentTicketCustomer
        'Change Customer of %s%s%s' => '',
        'Customer Information' => 'Información do cliente',
        'Customer user' => 'Usuario cliente',

        # Template: AgentTicketEmail
        'Create New Email Ticket' => 'Crear un tícket de correo electrónico novo',
        'Example Template' => 'Exemplo Modelo',
        'From queue' => 'Dende cola',
        'To customer user' => 'Ao usuario cliente',
        'Please include at least one customer user for the ticket.' => 'Inclúa ao menos un usuario cliente para o tícket.',
        'Select this customer as the main customer.' => 'Seleccionar este cliente como cliente principal.',
        'Remove Ticket Customer User' => 'Elimine Ticket Usuario Cliente',
        'Get all' => 'Obteña todos',

        # Template: AgentTicketEmailOutbound
        'Outbound Email for %s%s%s' => '',

        # Template: AgentTicketEmailResend
        'Resend Email for %s%s%s' => '',

        # Template: AgentTicketEscalation
        'Ticket %s: first response time is over (%s/%s)!' => 'Ticket %s: primeiro tempo de resposta está por enriba (%s/%s)!',
        'Ticket %s: first response time will be over in %s/%s!' => 'Ticket %s: primeiro tempo de resposta vai estar por enriba en %s/%s!',
        'Ticket %s: update time is over (%s/%s)!' => '',
        'Ticket %s: update time will be over in %s/%s!' => 'Ticket %s: o tempo de actualización vai estar por enriba en %s%s!',
        'Ticket %s: solution time is over (%s/%s)!' => 'Ticket %s: o tempo de solución vai estar por enriba (%s%s)!',
        'Ticket %s: solution time will be over in %s/%s!' => 'Ticket %s: o tempo de solución vai estar por enriba en %s%s!',

        # Template: AgentTicketForward
        'Forward %s%s%s' => '',

        # Template: AgentTicketHistory
        'History of %s%s%s' => '',
        'Filter for history items' => '',
        'Expand/collapse all' => '',
        'CreateTime' => '',
        'Article' => 'Artigo',

        # Template: AgentTicketMerge
        'Merge %s%s%s' => '',
        'Merge Settings' => 'Axustes Fusionar',
        'You need to use a ticket number!' => 'Necsita un número de ticket!',
        'A valid ticket number is required.' => 'Un número de ticket válido é requirido.',
        'Try typing part of the ticket number or title in order to search by it.' =>
            '',
        'Limit the search to tickets with same Customer ID (%s).' => '',
        'Inform Sender' => '',
        'Need a valid email address.' => 'Precisa dun enderezo de correo electrónico correcto.',

        # Template: AgentTicketMove
        'Move %s%s%s' => '',
        'New Queue' => 'Nova fila',
        'Move' => 'Mover',

        # Template: AgentTicketOverviewMedium
        'No ticket data found.' => 'Non se atoparon datos do ticket.',
        'Open / Close ticket action menu' => 'Abrir / Pechar menú acción ticket',
        'Select this ticket' => 'Selecciones este ticket.',
        'Sender' => 'Remitente',
        'First Response Time' => 'Tempo de Primeira Resposta',
        'Update Time' => 'Tempo Actualización',
        'Solution Time' => 'Tempo de Solución',
        'Move ticket to a different queue' => 'Mover ticket a unha cola diferente',
        'Change queue' => 'Cambiar a fila',

        # Template: AgentTicketOverviewNavBar
        'Remove active filters for this screen.' => 'Elimine os filtros activos para esta pantalla',
        'Tickets per page' => 'Tickets por páxina',

        # Template: AgentTicketOverviewPreview
        'Missing channel' => '',

        # Template: AgentTicketOverviewSmall
        'Reset overview' => 'Restablecer vista xeral',
        'Column Filters Form' => 'Formulario de filtros de columnas',

        # Template: AgentTicketPhone
        'Split Into New Phone Ticket' => 'Dividir Nun Novo Ticket Telefónico',
        'Save Chat Into New Phone Ticket' => 'Gardar Chat Nun Novo Ticket Telefónico',
        'Create New Phone Ticket' => 'Crear un Novo Ticket Telefónico',
        'Please include at least one customer for the ticket.' => 'Inclúa ao menos un cliente para o tícket.',
        'To queue' => 'A cola',
        'Chat protocol' => 'Protocolo de conversa',
        'The chat will be appended as a separate article.' => 'O chat será engadido como artigo separado.',

        # Template: AgentTicketPhoneCommon
        'Phone Call for %s%s%s' => '',

        # Template: AgentTicketPlain
        'View Email Plain Text for %s%s%s' => '',
        'Plain' => 'Simple',
        'Download this email' => 'Descargue este email',

        # Template: AgentTicketProcess
        'Create New Process Ticket' => 'Crear un tícket de proceso novo',

        # Template: AgentTicketProcessSmall
        'Enroll Ticket into a Process' => 'Rexistra Ticket nun Proceso',

        # Template: AgentTicketSearch
        'Profile link' => 'Enlace de perfil',
        'Output' => 'Saída',
        'Fulltext' => 'Texto completo',
        'Customer ID (complex search)' => '',
        '(e. g. 234*)' => '',
        'Customer ID (exact match)' => '',
        'Assigned to Customer User Login (complex search)' => '',
        '(e. g. U51*)' => '',
        'Assigned to Customer User Login (exact match)' => '',
        'Accessible to Customer User Login (exact match)' => '',
        'Created in Queue' => 'Creado na Cola',
        'Lock state' => 'Estado do bloqueo',
        'Watcher' => 'Observador',
        'Article Create Time (before/after)' => 'Hora de creación do artigo (antes/despois)',
        'Article Create Time (between)' => 'Hora de creación do artigo (entre)',
        'Please set this to value before end date.' => '',
        'Please set this to value after start date.' => '',
        'Ticket Create Time (before/after)' => 'Crear Tempo Ticket (antes/despois)',
        'Ticket Create Time (between)' => 'Crear Tempo Ticket (entre)',
        'Ticket Change Time (before/after)' => 'Cambiar Tempo Ticket (antes/despois)',
        'Ticket Change Time (between)' => 'Cambiar Tempo Ticket (entre)',
        'Ticket Last Change Time (before/after)' => 'Tempo Último Cambio Ticket (antes/despois)',
        'Ticket Last Change Time (between)' => 'Tempo Último Cambio Ticket (entre)',
        'Ticket Pending Until Time (before/after)' => '',
        'Ticket Pending Until Time (between)' => '',
        'Ticket Close Time (before/after)' => 'Tempo Peche Ticket (antes/despois)',
        'Ticket Close Time (between)' => 'Tempo Peche Ticket (entre)',
        'Ticket Escalation Time (before/after)' => 'Tempo Escalado Ticket (antes/despois)',
        'Ticket Escalation Time (between)' => 'Tempo Escalado Ticket (entre)',
        'Archive Search' => 'Busca no arquivo',

        # Template: AgentTicketZoom
        'Sender Type' => 'Tipo de Remitente',
        'Save filter settings as default' => 'Gardar axustes filtro como por defecto',
        'Event Type' => 'Tipo de evento',
        'Save as default' => 'Gardar como por defecto',
        'Drafts' => '',
        'by' => 'de',
        'Change Queue' => 'Cambiar a fila',
        'There are no dialogs available at this point in the process.' =>
            'Non hai dialogos dispoñibles neste punto no proceso.',
        'This item has no articles yet.' => 'Este elemento non ten artigos aínda.',
        'Ticket Timeline View' => 'Ver Cronoloxía do Ticket',
        'Article Overview - %s Article(s)' => '',
        'Page %s' => '',
        'Add Filter' => 'Engadir filtro',
        'Set' => 'Definir',
        'Reset Filter' => 'Restablecer Filtros',
        'No.' => 'Nº.',
        'Unread articles' => 'Artigos sen leer',
        'Via' => '',
        'Important' => 'Importante',
        'Unread Article!' => 'Artigo non lido!',
        'Incoming message' => 'Mensaxe entrante',
        'Outgoing message' => 'Mensaxe de saída',
        'Internal message' => 'Mensaxe interna',
        'Sending of this message has failed.' => '',
        'Resize' => 'Redimensionar',
        'Mark this article as read' => 'Marcar este artigo como lido',
        'Show Full Text' => 'Mostrar Texto Completo',
        'Full Article Text' => 'Texto Artigo Completo',
        'No more events found. Please try changing the filter settings.' =>
            'Non se atoparon máis eventos. Tente cambiando a configuración do filtro.',

        # Template: Chat
        '#%s' => '',
        'via %s' => '',
        'by %s' => '',
        'Toggle article details' => '',

        # Template: MIMEBase
        'This message is being processed. Already tried to send %s time(s). Next try will be %s.' =>
            '',
        'To open links in the following article, you might need to press Ctrl or Cmd or Shift key while clicking the link (depending on your browser and OS).' =>
            'Para abrir enlaces no artigo seguinte, vostede podería necesitar apertar Ctrl ou Cmd ou chave Shift mentres fai clic no enlace (dependendo do seu explorador e OS).',
        'Close this message' => 'Pechar esta mensaxe',
        'Image' => '',
        'PDF' => 'PDF',
        'Unknown' => 'Descoñecido',
        'View' => 'Ver',

        # Template: LinkTable
        'Linked Objects' => 'Obxectos ligados',

        # Template: TicketInformation
        'Archive' => 'Arquivo',
        'This ticket is archived.' => 'Este tícket está arquivado.',
        'Note: Type is invalid!' => '',
        'Pending till' => 'Pendente ata',
        'Locked' => 'Bloqueado',
        '%s Ticket(s)' => '',
        'Accounted time' => 'Tempo intervención',

        # Template: Invalid
        'Preview of this article is not possible because %s channel is missing in the system.' =>
            '',
        'This feature is part of the %s. Please contact us at %s for an upgrade.' =>
            '',
        'Please re-install %s package in order to display this article.' =>
            '',

        # Template: AttachmentBlocker
        'To protect your privacy, remote content was blocked.' => 'Para protexer a súa privacidade bloqueouse contido remoto.',
        'Load blocked content.' => 'Cargar contido bloqueado',

        # Template: Breadcrumb
        'Home' => '',
        'Back to admin overview' => '',

        # Template: CloudServicesDisabled
        'This Feature Requires Cloud Services' => '',
        'You can' => 'Vostede pode',
        'go back to the previous page' => 'volte a páxina anterior',

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
        'Error Details' => 'Detalles do erro',
        'Traceback' => 'Imprimir',

        # Template: CustomerFooter
        '%s powered by %s™' => '',
        'Powered by %s™' => '',

        # Template: CustomerFooterJS
        '%s detected possible network issues. You could either try reloading this page manually or wait until your browser has re-established the connection on its own.' =>
            '',
        'The connection has been re-established after a temporary connection loss. Due to this, elements on this page could have stopped to work correctly. In order to be able to use all elements correctly again, it is strongly recommended to reload this page.' =>
            '',

        # Template: CustomerLogin
        'JavaScript Not Available' => 'JavaScript non dispoñible',
        'In order to experience this software, you\'ll need to enable JavaScript in your browser.' =>
            '',
        'Browser Warning' => 'Aviso de Explorador',
        'The browser you are using is too old.' => 'O navegador que usa é vello de máis.',
        'This software runs with a huge lists of browsers, please upgrade to one of these.' =>
            '',
        'Please see the documentation or ask your admin for further information.' =>
            'Por favor vexa a documentación ou pregunte o seu administrador para mais información.',
        'One moment please, you are being redirected...' => 'Agarde un momentiño; vaise encamiñar...',
        'Login' => 'Iniciar sesión',
        'User name' => 'Nome do usuario',
        'Your user name' => 'O seu nome de usuario',
        'Your password' => 'O seu contrasinal',
        'Forgot password?' => 'Esqueceu o contrasinal?',
        '2 Factor Token' => '2 Factor Token',
        'Your 2 Factor Token' => 'Teus 2 Factor Token',
        'Log In' => 'Acceso',
        'Not yet registered?' => 'Aínda non se rexistrou?',
        'Back' => 'Volver',
        'Request New Password' => 'Solicitar un contrasinal novo',
        'Your User Name' => 'O Seu Nome de Usuario',
        'A new password will be sent to your email address.' => 'Un novo contrasinal será enviado ao seu enderezo de correo electrónico.',
        'Create Account' => 'Crear unha conta',
        'Please fill out this form to receive login credentials.' => 'Por favor encha este formulario para recibir credenciais de login.',
        'How we should address you' => 'Como nos deberíamos dirixir a vostede',
        'Your First Name' => 'O Seu Nome',
        'Your Last Name' => 'Os Seús Apelidos',
        'Your email address (this will become your username)' => 'O seu enderezo de correo electrónico (será o seu nome de usuario)',

        # Template: CustomerNavigationBar
        'Incoming Chat Requests' => 'Solicitudes de conversa entrantes',
        'Edit personal preferences' => 'Edite as preferencias persoais',
        'Logout %s' => '',

        # Template: CustomerTicketMessage
        'Service level agreement' => 'Acordo de nivel de servizo',

        # Template: CustomerTicketOverview
        'Welcome!' => 'Reciba a benvida!',
        'Please click the button below to create your first ticket.' => 'Por favor faga clic no botón de abaixo para crear o seu primeiro ticket.',
        'Create your first ticket' => 'Cree o seu primeiro ticket',

        # Template: CustomerTicketSearch
        'Profile' => 'Perfil',
        'e. g. 10*5155 or 105658*' => 'p.ex. 10*5155 ou 105658*',
        'CustomerID' => 'Identificador do cliente',
        'Fulltext Search in Tickets (e. g. "John*n" or "Will*")' => '',
        'Types' => 'Tipos',
        'Time Restrictions' => '',
        'No time settings' => 'Non hai configuración horaria',
        'All' => 'Todo',
        'Specific date' => '',
        'Only tickets created' => 'Só tickets creados',
        'Date range' => 'Intervalo de datas',
        'Only tickets created between' => 'Só tickets creados entre',
        'Ticket Archive System' => '',
        'Save Search as Template?' => '',
        'Save as Template?' => 'Garde como Modelo?',
        'Save as Template' => 'Garde como Modelo',
        'Template Name' => 'Nome do modelo',
        'Pick a profile name' => 'Escolla un nome de perfil',
        'Output to' => 'Saída',

        # Template: CustomerTicketSearchResultShort
        'of' => 'de',
        'Page' => 'Páxina',
        'Search Results for' => 'Buscar resultados para',
        'Remove this Search Term.' => 'Elimine este Termo de Busca',

        # Template: CustomerTicketZoom
        'Start a chat from this ticket' => 'Comence un chat dende este ticket',
        'Next Steps' => 'Pasos seguintes',
        'Reply' => 'Responder',

        # Template: Chat
        'Expand article' => 'Expanda artigo',

        # Template: CustomerWarning
        'Warning' => 'Aviso',

        # Template: DashboardEventsTicketCalendar
        'Event Information' => 'Información do evento',
        'Ticket fields' => 'Campos Ticket',

        # Template: Error
        'Really a bug? 5 out of 10 bug reports result from a wrong or incomplete installation of OTRS.' =>
            '',
        'With %s, our experts take care of correct installation and cover your back with support and periodic security updates.' =>
            '',
        'Contact our service team now.' => '',
        'Send a bugreport' => 'Enviar un reporte de bugs',
        'Expand' => 'Expandir',

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
        'Logout' => 'Pechar a sesión',
        'You are logged in as' => 'Está logeado como',

        # Template: Installer
        'JavaScript not available' => 'JavaScript non dispoñible',
        'Step %s' => 'Paso %s',
        'License' => 'Licenza',
        'Database Settings' => 'Configuración da base de datos',
        'General Specifications and Mail Settings' => 'Especificacións Xeráis e Axustes de Correo',
        'Finish' => 'Rematar',
        'Welcome to %s' => 'Benvido a %s',
        'Germany' => '',
        'Phone' => 'Teléfono',
        'United States' => '',
        'Mexico' => '',
        'Hungary' => '',
        'Brazil' => '',
        'Singapore' => '',
        'Hong Kong' => '',
        'Web site' => 'Sitio web',

        # Template: InstallerConfigureMail
        'Configure Outbound Mail' => 'Configurar o correo saínte',
        'Outbound mail type' => 'Tipo',
        'Select outbound mail type.' => 'Seleccione o tipo de correo de saída.',
        'Outbound mail port' => 'Porto de correo de saída.',
        'Select outbound mail port.' => 'Seleccione porto de correo de saída.',
        'SMTP host' => 'Servidor de SMTP',
        'SMTP host.' => 'Servidor de SMTP.',
        'SMTP authentication' => 'Autenticación SMTP',
        'Does your SMTP host need authentication?' => 'Precisa o seu host SMTP autenticación?',
        'SMTP auth user' => 'Usuario autenticado SMTP',
        'Username for SMTP auth.' => 'Nome de usuario para autenticación SMTP',
        'SMTP auth password' => 'Contrasinal autenticación SMTP',
        'Password for SMTP auth.' => 'Contrasinal para a autenticación SMTP',
        'Configure Inbound Mail' => 'Configurar o correo entrante',
        'Inbound mail type' => 'Tipo de correo entrante',
        'Select inbound mail type.' => 'Seleccione tipo de correo de entrada.',
        'Inbound mail host' => 'Servidor de correo entrante',
        'Inbound mail host.' => 'Servidor de correo entrante.',
        'Inbound mail user' => 'Usuario de correo entrante',
        'User for inbound mail.' => 'Usuario para correo de entrada.',
        'Inbound mail password' => 'Contrasinal do correo entrante',
        'Password for inbound mail.' => 'Contrasinal para correo de entrada.',
        'Result of mail configuration check' => 'Resultado da comprobación da configuración do correo',
        'Check mail configuration' => 'Comprobar a configuración do correo',
        'Skip this step' => 'Salte este paso',

        # Template: InstallerDBResult
        'Done' => 'Feito',
        'Error' => 'Erro',
        'Database setup successful!' => 'A base de datos foi configurada correctamente!',

        # Template: InstallerDBStart
        'Install Type' => 'Tipo de instalación',
        'Create a new database for OTRS' => 'Cree unha nova base de datos para OTRS',
        'Use an existing database for OTRS' => 'Use unha base de datos existente para OTRS',

        # Template: InstallerDBmssql
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty.' =>
            'Se non indicou xa un contrasinal de superusuario para a base de datos, haino que facer aquí. Se non, deixe este cambo baleiro.',
        'Database name' => 'Nome da base de datos',
        'Check database settings' => 'Comprobar a configuración da base de datos',
        'Result of database check' => 'Resultado da comprobación da base de datos',
        'Database check successful.' => 'A base de datos foi comprobada correctamente.',
        'Database User' => 'Usuario da base de datos',
        'New' => 'Novo',
        'A new database user with limited permissions will be created for this OTRS system.' =>
            'Un novo usuario de base de datos con permisos limitados será creado para este sistema OTRS.',
        'Repeat Password' => 'Repita Contrasinal',
        'Generated password' => 'Contrasinal xerada',

        # Template: InstallerDBmysql
        'Passwords do not match' => 'Os contrasinais non coinciden',

        # Template: InstallerDBoracle
        'SID' => 'SID',
        'Port' => 'Porto',

        # Template: InstallerFinish
        'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' =>
            'Para poder usar OTRS debe introducir o seguinte na súa liña de comandos (Terminal/Shell) como root.',
        'Restart your webserver' => 'Reiniciar o seu servidor web',
        'After doing so your OTRS is up and running.' => 'Despois de facer iso o seu OTRS está subido e executándose',
        'Start page' => 'Páxina de inicio',
        'Your OTRS Team' => 'O teu equipo OTRS',

        # Template: InstallerLicense
        'Don\'t accept license' => 'Non aceptar a licencia',
        'Accept license and continue' => 'Aceptar a licenza e continuar',

        # Template: InstallerSystem
        'SystemID' => 'IDSistema',
        'The identifier of the system. Each ticket number and each HTTP session ID contain this number.' =>
            'O identificador do sistema. Cada número de ticket e cada ID da sesión HTTP conteñen este número.',
        'System FQDN' => 'FQDN do Sistema',
        'Fully qualified domain name of your system.' => 'nome de dominio completo do seu sistema.',
        'AdminEmail' => 'AdminEmail',
        'Email address of the system administrator.' => 'Enderezo de correo electrónico do administrador do sistema.',
        'Organization' => 'Organización',
        'Log' => 'Rexistro',
        'LogModule' => 'LogModulo',
        'Log backend to use.' => 'Log backend para usar',
        'LogFile' => 'ArquivoLog',
        'Webfrontend' => 'Webfrontend',
        'Default language' => 'Idioma predeterminado',
        'Default language.' => 'Idioma predeterminado.',
        'CheckMXRecord' => 'ComprobarMXRexistro',
        'Email addresses that are manually entered are checked against the MX records found in DNS. Don\'t use this option if your DNS is slow or does not resolve public addresses.' =>
            'Os enderezos de correo electrónico que se introduzan manualmente compróbanse nos rexistros de MX atopados en DNS. Non empregue esta opción se o seu DNS é lento ou non resolve enderezos públicos.',

        # Template: LinkObject
        'Delete link' => '',
        'Delete Link' => '',
        'Object#' => 'Obxecto nº',
        'Add links' => 'Engadir ligazóns',
        'Delete links' => 'Elimine enlaces',

        # Template: Login
        'Lost your password?' => 'Perdeu o seu contrasinal?',
        'Back to login' => 'Retornar á pantalla de acceso',

        # Template: MetaFloater
        'Scale preview content' => '',
        'Open URL in new tab' => '',
        'Close preview' => '',
        'A preview of this website can\'t be provided because it didn\'t allow to be embedded.' =>
            '',

        # Template: MobileNotAvailableWidget
        'Feature not Available' => '',
        'Sorry, but this feature of OTRS is currently not available for mobile devices. If you\'d like to use it, you can either switch to desktop mode or use your regular desktop device.' =>
            'O sentimos, pero esta función de OTRS non é dispoñible actualmente para dispositivos móbiles. Se quere usala, pode ou ben cambiar a modo escritorio ou usar o dispositivo de escritorio regular.',

        # Template: Motd
        'Message of the Day' => 'Mensaxe do día',
        'This is the message of the day. You can edit this in %s.' => '',

        # Template: NoPermission
        'Insufficient Rights' => 'Dereitos insuficientes',
        'Back to the previous page' => 'Retornar á páxina anterior',

        # Template: Alert
        'Alert' => '',
        'Powered by' => 'Iniciar sesión',

        # Template: Pagination
        'Show first page' => 'Mostrar primeira páxina',
        'Show previous pages' => 'Mostrar páxinas anteriores',
        'Show page %s' => 'Mostrar páxina %s',
        'Show next pages' => 'Mostrar páxinas seguintes',
        'Show last page' => 'Mostrar última páxina',

        # Template: PictureUpload
        'Need FormID!' => 'Necesítase FormID!',
        'No file found!' => 'Non se atopou ningún ficheiro!',
        'The file is not an image that can be shown inline!' => 'O ficheiro non é unha imaxe que poida ser mostrada dentro!',

        # Template: PreferencesNotificationEvent
        'No user configurable notifications found.' => 'Non se atoparon notificacións configurables de usuario.',
        'Receive messages for notification \'%s\' by transport method \'%s\'.' =>
            'Recibir mensaxes para notificación \'%s\' polo método de transporte \'%s\'.',

        # Template: ActivityDialogHeader
        'Process Information' => 'Información do proceso',
        'Dialog' => '',

        # Template: Article
        'Inform Agent' => 'Informar o Axente',

        # Template: PublicDefault
        'Welcome' => 'Benvido',
        'This is the default public interface of OTRS! There was no action parameter given.' =>
            '',
        'You could install a custom public module (via the package manager), for example the FAQ module, which has a public interface.' =>
            '',

        # Template: GeneralSpecificationsWidget
        'Permissions' => 'Permisos',
        'You can select one or more groups to define access for different agents.' =>
            'Pode seleccionar un ou mais grupos para definir o acceso para distintos axentes.',
        'Result formats' => '',
        'Time Zone' => 'Fuso horario',
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
            'Proporcione a estatística como un widget que os axentes poden activar no seu cadro de mando.',
        'Please note that enabling the dashboard widget will activate caching for this statistic in the dashboard.' =>
            '',
        'If set to invalid end users can not generate the stat.' => 'Se se establece a inválido os usuarios finales non poden xerar o stat.',

        # Template: PreviewWidget
        'There are problems in the configuration of this statistic:' => '',
        'You may now configure the X-axis of your statistic.' => '',
        'This statistic does not provide preview data.' => '',
        'Preview format' => '',
        'Please note that the preview uses random data and does not consider data filters.' =>
            '',
        'Configure X-Axis' => '',
        'X-axis' => 'Eixo X',
        'Configure Y-Axis' => '',
        'Y-axis' => 'Eixo Y',
        'Configure Filter' => '',

        # Template: RestrictionsWidget
        'Please select only one element or turn off the button \'Fixed\'.' =>
            'Por favor seleccione soamente un elemento ou apague o botón \'Fixo\'.',
        'Absolute period' => '',
        'Between %s and %s' => '',
        'Relative period' => '',
        'The past complete %s and the current+upcoming complete %s %s' =>
            '',
        'Do not allow changes to this element when the statistic is generated.' =>
            '',

        # Template: StatsParamsWidget
        'Format' => 'Formato',
        'Exchange Axis' => 'Eixe de Intercambio',
        'Configurable Params of Static Stat' => '',
        'No element selected.' => 'Non hai ningún elemento seleccionado.',
        'Scale' => 'Escala',
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
        'OTRS Test Page' => 'Páxina de probas do OTRS',
        'Unlock' => 'Desbloquear',
        'Welcome %s %s' => 'Benvido %s %s',
        'Counter' => 'Contador',

        # Template: Warning
        'Go back to the previous page' => 'Volte a páxina anterior',

        # JS Template: CalendarSettingsDialog
        'Show' => '',

        # JS Template: FormDraftAddDialog
        'Draft title' => '',

        # JS Template: ArticleViewSettingsDialog
        'Article display' => '',

        # JS Template: FormDraftDeleteDialog
        'Do you really want to delete "%s"?' => '',
        'Confirm' => 'Confirmar',

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
        'Finished' => 'Rematado',
        'No package information available.' => '',

        # JS Template: AddButton
        'Add new entry' => 'Engadir unha entrada nova',

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
        'CustomerIDs' => 'Identificadores de cliente',
        'Fax' => 'Fax',
        'Street' => 'Rúa',
        'Zip' => 'CP',
        'City' => 'Cidade',
        'Country' => 'País',
        'Valid' => 'Correcto',
        'Mr.' => 'Sr.',
        'Mrs.' => 'Sra.',
        'Address' => 'Enderezo',
        'View system log messages.' => 'Ver mensaxes log do sistema.',
        'Edit the system configuration settings.' => 'Editar as opcións de configuración do sistema.',
        'Update and extend your system with software packages.' => 'Actualice e extenda o seu sistema con paquetes de software.',

        # Perl Module: Kernel/Modules/AdminACL.pm
        'ACL information from database is not in sync with the system configuration, please deploy all ACLs.' =>
            'A información de ACL da base de datos non está sincronizada coa configuración do sistema; instale todas as ACL.',
        'ACLs could not be Imported due to a unknown error, please check OTRS logs for more information' =>
            '',
        'The following ACLs have been added successfully: %s' => '',
        'The following ACLs have been updated successfully: %s' => '',
        'There where errors adding/updating the following ACLs: %s. Please check the log file for more information.' =>
            '',
        'This field is required' => 'Este campo é obrigatorio',
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
        'Attachment added!' => 'Engadiuse un anexo!',

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
        'Failed' => 'Fallou',
        'Invalid Filter: %s!' => '',
        'Less than a second' => '',
        'sorted descending' => '',
        'sorted ascending' => '',
        'Trace' => '',
        'Debug' => '',
        'Info' => 'Información',
        'Warn' => '',
        'days' => 'días',
        'day' => 'día',
        'hour' => 'hora',
        'minute' => 'minuto',
        'seconds' => 'segundos',
        'second' => 'segundo',

        # Perl Module: Kernel/Modules/AdminCustomerCompany.pm
        'Customer company updated!' => 'Empresa do cliente actualizada!',
        'Dynamic field %s not found!' => '',
        'Unable to set value for dynamic field %s!' => '',
        'Customer Company %s already exists!' => '',
        'Customer company added!' => 'Empresa do cliente engadida!',

        # Perl Module: Kernel/Modules/AdminCustomerGroup.pm
        'No configuration for \'CustomerGroupPermissionContext\' found!' =>
            '',
        'Please check system configuration.' => '',
        'Invalid permission context configuration:' => '',

        # Perl Module: Kernel/Modules/AdminCustomerUser.pm
        'Customer updated!' => 'O cliente foi actualizado!',
        'New phone ticket' => 'Novo ticket telefónico',
        'New email ticket' => 'Novo ticket correo electrónico',
        'Customer %s added' => 'Engadiuse o usuario %s',
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
        'Currently' => 'Actualmente',
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
        'minute(s)' => 'minuto(s)',
        'hour(s)' => 'hora(s)',
        'Time unit' => 'Unidade de tempo',
        'within the last ...' => 'no último...',
        'within the next ...' => 'nos seguintes...',
        'more than ... ago' => 'hai máis de...',
        'Unarchived tickets' => 'Tickets sen archivar',
        'archive tickets' => '',
        'restore tickets from archive' => '',
        'Need Profile!' => '',
        'Got no values to check.' => '',
        'Please remove the following words because they cannot be used for the ticket selection:' =>
            'Por favor elimine as seguintes palabras porque non poden ser usadas para a selección de ticket:',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceDebugger.pm
        'Need WebserviceID!' => '',
        'Could not get data for WebserviceID %s' => '',
        'ascending' => 'ascendente',
        'descending' => 'descendente',

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
        '10 minutes' => '10 minutos',
        '15 minutes' => '15 minutos',
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
        'Web service "%s" created!' => 'Servizo web "%s" creado!',
        'Need Name!' => '',
        'Need ExampleWebService!' => '',
        'Could not load %s.' => '',
        'Could not read %s!' => '',
        'Need a file to import!' => '',
        'The imported file has not valid YAML content! Please check OTRS log for details' =>
            '',
        'Web service "%s" deleted!' => 'Servizo web "%s" eliminado!',
        'OTRS as provider' => 'OTRS como fornecedor',
        'Operations' => '',
        'OTRS as requester' => 'OTRS como solicitante',
        'Invokers' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceWebserviceHistory.pm
        'Got no WebserviceHistoryID!' => '',
        'Could not get history data for WebserviceHistoryID %s' => '',

        # Perl Module: Kernel/Modules/AdminGroup.pm
        'Group updated!' => 'O grupo foi actualizado!',

        # Perl Module: Kernel/Modules/AdminMailAccount.pm
        'Mail account added!' => 'Engadiuse a conta de correo!',
        'Email account fetch already fetched by another process. Please try again later!' =>
            '',
        'Dispatching by email To: field.' => 'Enviando por email A: campo',
        'Dispatching by selected Queue.' => 'Enviando a cola seleccionada',

        # Perl Module: Kernel/Modules/AdminNotificationEvent.pm
        'Agent who created the ticket' => '',
        'Agent who owns the ticket' => 'Axente que é dono do ticket',
        'Agent who is responsible for the ticket' => 'Axente que é responsable do ticket',
        'All agents watching the ticket' => 'Tódolos axentes vendo o ticket',
        'All agents with write permission for the ticket' => 'Tódolos axentes con permisos de escritura para o ticket',
        'All agents subscribed to the ticket\'s queue' => 'Tódolos axentes suscritos a cola do ticket',
        'All agents subscribed to the ticket\'s service' => 'Tódolos axentes suscritos o servizo do ticket',
        'All agents subscribed to both the ticket\'s queue and service' =>
            'Tódolos axentes suscritos aos dous cola e servizo de ticket',
        'Customer user of the ticket' => '',
        'All recipients of the first article' => '',
        'All recipients of the last article' => '',
        'Invisible to customer' => '',
        'Visible to customer' => '',

        # Perl Module: Kernel/Modules/AdminOTRSBusiness.pm
        'Your system was successfully upgraded to %s.' => 'O seu sistema foi actualizado satistactoriamente a %s',
        'There was a problem during the upgrade to %s.' => 'Houbo un problema durante a actualización a %s',
        '%s was correctly reinstalled.' => '%s foi reinstalado correctamente.',
        'There was a problem reinstalling %s.' => 'Houbo un problema reinstalando %s',
        'Your %s was successfully updated.' => 'O seu %s foi actualizado satisfactoriamente.',
        'There was a problem during the upgrade of %s.' => 'Houbo un problema durante a actualización de %s.',
        '%s was correctly uninstalled.' => '%s foi desinstalado correctamente.',
        'There was a problem uninstalling %s.' => 'Houbo un problema desistalando %s.',

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
            'Este paquete non foi comprobado polo Grupo OTRS! Non se recomenda empregar este paquete.',
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
            'Paquete non verificado debido a un problema co servidor de verificación!',
        'Can\'t connect to OTRS Feature Add-on list server!' => '',
        'Can\'t get OTRS Feature Add-on list from server!' => '',
        'Can\'t get OTRS Feature Add-on from server!' => '',

        # Perl Module: Kernel/Modules/AdminPostMasterFilter.pm
        'No such filter: %s' => '',

        # Perl Module: Kernel/Modules/AdminPriority.pm
        'Priority added!' => 'Engadiuse a prioridade!',

        # Perl Module: Kernel/Modules/AdminProcessManagement.pm
        'Process Management information from database is not in sync with the system configuration, please synchronize all processes.' =>
            'A información sobre a xestión de procesos da base de datos non está sincronizada coa configuración do sistema; sincronice todos os procesos.',
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
        'Queue updated!' => 'Actualizouse a fila!',
        'Don\'t use :: in queue name!' => '',
        'Click back and change it!' => '',
        '-none-' => '-ningún-',

        # Perl Module: Kernel/Modules/AdminQueueAutoResponse.pm
        'Queues ( without auto responses )' => '',

        # Perl Module: Kernel/Modules/AdminQueueTemplates.pm
        'Change Queue Relations for Template' => 'Cambie as Relacións da Cola para Modelo',
        'Change Template Relations for Queue' => 'Cambie Relacións de Modelo para Cola',

        # Perl Module: Kernel/Modules/AdminRegistration.pm
        'Production' => 'Produción',
        'Test' => '',
        'Training' => 'Formación',
        'Development' => '',

        # Perl Module: Kernel/Modules/AdminRole.pm
        'Role updated!' => 'Papel actualizado',
        'Role added!' => 'Papel engadido!',

        # Perl Module: Kernel/Modules/AdminRoleGroup.pm
        'Change Group Relations for Role' => 'Cambie Relacións de Grupo para o Rol',
        'Change Role Relations for Group' => 'Cambie Relacións de Rol para o Grupo',

        # Perl Module: Kernel/Modules/AdminRoleUser.pm
        'Role' => '',
        'Change Role Relations for Agent' => 'Cambie Relacións de Rol para Axente ',
        'Change Agent Relations for Role' => 'Cambie Relacións de Axente para Rol',

        # Perl Module: Kernel/Modules/AdminSLA.pm
        'Please activate %s first!' => 'Active %s primeiro!',

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
        'Signature updated!' => 'Sinatura actualizada!',
        'Signature added!' => 'Sinatura engadida!',

        # Perl Module: Kernel/Modules/AdminState.pm
        'State added!' => 'Estado engadido!',

        # Perl Module: Kernel/Modules/AdminSupportDataCollector.pm
        'File %s could not be read!' => '',

        # Perl Module: Kernel/Modules/AdminSystemAddress.pm
        'System e-mail address added!' => 'Engadiuse o enderezo de correo do sistema!',

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
        'All sessions have been killed, except for your own.' => 'Matáronse todas as sesións, excepto a súa.',
        'There was an error updating the System Maintenance' => '',
        'Was not possible to delete the SystemMaintenance entry: %s!' => '',

        # Perl Module: Kernel/Modules/AdminTemplate.pm
        'Template updated!' => '',
        'Template added!' => '',

        # Perl Module: Kernel/Modules/AdminTemplateAttachment.pm
        'Change Attachment Relations for Template' => 'Cambie Relacións Anexos para Modelo',
        'Change Template Relations for Attachment' => 'Cambie as Relacións do Modelo para Anexos',

        # Perl Module: Kernel/Modules/AdminType.pm
        'Need Type!' => '',
        'Type added!' => 'Engadiuse un tipo!',

        # Perl Module: Kernel/Modules/AdminUser.pm
        'Agent updated!' => 'Axente actualizado!',

        # Perl Module: Kernel/Modules/AdminUserGroup.pm
        'Change Group Relations for Agent' => 'Cambie Relacións de Grupo para Axente',
        'Change Agent Relations for Group' => 'Cambie Relacións de Axente para Grupo',

        # Perl Module: Kernel/Modules/AgentAppointmentAgendaOverview.pm
        'Month' => 'Mes',
        'Week' => '',
        'Day' => 'Día',

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
        'Customer History' => 'Historial de cliente',

        # Perl Module: Kernel/Modules/AgentCustomerUserAddressBook.pm
        'No RecipientField is given!' => '',

        # Perl Module: Kernel/Modules/AgentDashboardCommon.pm
        'No such config for %s' => '',
        'Statistic' => 'Estatística',
        'No preferences for %s!' => '',
        'Can\'t get element data of %s!' => '',
        'Can\'t get filter content data of %s!' => '',
        'Customer Name' => '',
        'Customer User Name' => '',

        # Perl Module: Kernel/Modules/AgentLinkObject.pm
        'Need SourceObject and SourceKey!' => '',
        'You need ro permission!' => '',
        'Can not delete link with %s!' => 'Non se pode eliminar a ligazón con %s!',
        '%s Link(s) deleted successfully.' => '',
        'Can not create link with %s! Object already linked as %s.' => '',
        'Can not create link with %s!' => 'Non se pode crear a ligazón con %s!',
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
        'Statistic could not be imported.' => 'Estatística non puido ser importada.',
        'Please upload a valid statistic file.' => 'Por favor cargue un arquivo de estatística valido.',
        'Export: Need StatID!' => '',
        'Delete: Get no StatID!' => '',
        'Need StatID!' => '',
        'Could not load stat.' => '',
        'Add New Statistic' => 'Engadir Nova Estatística',
        'Could not create statistic.' => '',
        'Run: Get no %s!' => '',

        # Perl Module: Kernel/Modules/AgentTicketActionCommon.pm
        'No TicketID is given!' => '',
        'You need %s permissions!' => '',
        'Loading draft failed!' => '',
        'Sorry, you need to be the ticket owner to perform this action.' =>
            'O sentimos, precisas ser o propietario do ticket para facer dita acción.',
        'Please change the owner first.' => 'Por favor cambie o propietario primeiro.',
        'FormDraft functionality disabled!' => '',
        'Draft name is required!' => '',
        'FormDraft name %s is already in use!' => '',
        'Could not perform validation on field %s!' => '',
        'No subject' => 'Ningún tema',
        'Could not delete draft!' => '',
        'Previous Owner' => 'Anterior Propietario',
        'wrote' => 'escribiu',
        'Message from' => 'Mensaxe de',
        'End message' => 'Fin da mesaxe',

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
        'Address %s replaced with registered customer address.' => 'O enderezo %s foi substituído polo enderezo do cliente rexistrado.',
        'Customer user automatically added in Cc.' => 'O usuario cliente foi engadido automaticamente en Copia.',

        # Perl Module: Kernel/Modules/AgentTicketEmail.pm
        'Ticket "%s" created!' => 'Creouse o tícket «%s»!',
        'No Subaction!' => '',

        # Perl Module: Kernel/Modules/AgentTicketEmailOutbound.pm
        'Got no TicketID!' => '',
        'System Error!' => '',

        # Perl Module: Kernel/Modules/AgentTicketEmailResend.pm
        'No ArticleID is given!' => '',

        # Perl Module: Kernel/Modules/AgentTicketEscalationView.pm
        'Next week' => 'A próxima semana',
        'Ticket Escalation View' => 'Vista do Escalado do Ticket',

        # Perl Module: Kernel/Modules/AgentTicketForward.pm
        'Article %s could not be found!' => '',
        'Forwarded message from' => 'Mensaxe encamiñado desde',
        'End forwarded message' => 'Fin da mesaxe enviada',

        # Perl Module: Kernel/Modules/AgentTicketHistory.pm
        'Can\'t show history, no TicketID is given!' => '',

        # Perl Module: Kernel/Modules/AgentTicketLock.pm
        'Can\'t lock Ticket, no TicketID is given!' => '',
        'Sorry, the current owner is %s!' => '',
        'Please become the owner first.' => '',
        'Ticket (ID=%s) is locked by %s!' => '',
        'Change the owner!' => '',

        # Perl Module: Kernel/Modules/AgentTicketLockedView.pm
        'New Article' => 'Novo artigo',
        'Pending' => 'Pendente',
        'Reminder Reached' => 'Recordatorio Alcanzado',
        'My Locked Tickets' => 'Os meus tíckets bloqueados',

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
        'Ticket locked.' => 'Tícket boqueado.',

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
        'The selected process is invalid!' => 'O proceso seleccionado é invalido!',
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
        'Pending Date' => 'Á Espera de Data',
        'for pending* states' => 'para estados de espera* ',
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
        'Available tickets' => 'Tíckets dispoñíbeis',
        'including subqueues' => 'incluíndo subconsultas',
        'excluding subqueues' => 'excluíndo subconsultas',
        'QueueView' => 'Vista da Cola',

        # Perl Module: Kernel/Modules/AgentTicketResponsibleView.pm
        'My Responsible Tickets' => 'Tickets dos que son Responsable',

        # Perl Module: Kernel/Modules/AgentTicketSearch.pm
        'last-search' => 'derradeira busca',
        'Untitled' => '',
        'Ticket Number' => 'Numero do Ticket',
        'Ticket' => 'Tícket',
        'printed by' => 'imprimido por',
        'CustomerID (complex search)' => '',
        'CustomerID (exact match)' => '',
        'Invalid Users' => 'Usuarios Inválidos',
        'Normal' => 'Normal',
        'CSV' => 'CSV',
        'Excel' => '',
        'in more than ...' => 'ten máis de...',

        # Perl Module: Kernel/Modules/AgentTicketService.pm
        'Feature not enabled!' => '',
        'Service View' => 'Vista de servizos',

        # Perl Module: Kernel/Modules/AgentTicketStatusView.pm
        'Status View' => 'Vista do estado',

        # Perl Module: Kernel/Modules/AgentTicketWatchView.pm
        'My Watched Tickets' => 'Meus Tickets Vistos',

        # Perl Module: Kernel/Modules/AgentTicketWatcher.pm
        'Feature is not active' => '',

        # Perl Module: Kernel/Modules/AgentTicketZoom.pm
        'Link Deleted' => '',
        'Ticket Locked' => '',
        'Pending Time Set' => '',
        'Dynamic Field Updated' => '',
        'Outgoing Email (internal)' => '',
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
        'Outgoing Email' => '',
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
        'Forward article via mail' => 'Encamiñar o artigo mediante correo electrónico',
        'Forward' => 'Adiante',
        'Fields with no group' => 'Campos sen grupo',
        'Invisible only' => '',
        'Visible only' => '',
        'Visible and invisible' => '',
        'Article could not be opened! Perhaps it is on another article page?' =>
            'Non é posíbel abrir este artigo! Talvez estea noutra páxina de artigo?',
        'Show one article' => 'Mostrar un artigo',
        'Show all articles' => 'Mostrar todos os artigos',
        'Show Ticket Timeline View' => 'Mostrar Vista Cronoloxía do Ticket',
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
        'My Tickets' => 'Meus Tickets',
        'Company Tickets' => 'Tíckets da empresa',
        'Untitled!' => '',

        # Perl Module: Kernel/Modules/CustomerTicketSearch.pm
        'Customer Realname' => 'Nome real do cliente',
        'Created within the last' => 'Creado no último',
        'Created more than ... ago' => 'Creado hai máis de...',
        'Please remove the following words because they cannot be used for the search:' =>
            'Por favor elimine as seguintes palabras porque non poden ser usadas para a busca:',

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
        'Install OTRS' => 'Instalar OTRS',
        'Intro' => 'Introdución',
        'Kernel/Config.pm isn\'t writable!' => '',
        'If you want to use the installer, set the Kernel/Config.pm writable for the webserver user!' =>
            '',
        'Database Selection' => 'Selección de base de datos',
        'Unknown Check!' => '',
        'The check "%s" doesn\'t exist!' => '',
        'Enter the password for the database user.' => 'Introduza o contrasinal para o usuario da base de datos.',
        'Database %s' => '',
        'Configure MySQL' => '',
        'Enter the password for the administrative database user.' => 'Introduza o contrasinal para o usuario administrador da base de datos.',
        'Configure PostgreSQL' => '',
        'Configure Oracle' => '',
        'Unknown database type "%s".' => '',
        'Please go back.' => '',
        'Create Database' => 'Crear base de datos',
        'Install OTRS - Error' => '',
        'File "%s/%s.xml" not found!' => '',
        'Contact your Admin!' => '',
        'System Settings' => 'Configuración do sistema',
        'Syslog' => '',
        'Configure Mail' => 'Configurar o correo',
        'Mail Configuration' => 'Configuración do correo',
        'Can\'t write Config file!' => '',
        'Unknown Subaction %s!' => '',
        'Can\'t connect to database, Perl module DBD::%s not installed!' =>
            '',
        'Can\'t connect to database, read comment!' => '',
        'Database already contains data - it should be empty!' => 'A base de datos xa contén datos - debería estar baleira!',
        'Error: Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            'Erro: Por favor asegúrese de que a súa base de datos acepta paquetes de mais de %s MB en tamaño (actualmente só acepta paquetes de ata %s MB). Por favor adapte o axuste max_allowed_packet a súa base de datos para evitar erros.',
        'Error: Please set the value for innodb_log_file_size on your database to at least %s MB (current: %s MB, recommended: %s MB). For more information, please have a look at %s.' =>
            'Erro: Por favor estableza o valor para innodb_log_file_size na súa base de datos ata polo menos %s MB (actualmente: %s MB, recomendado: %s MB). Para mais información, por favor bote unha ollada en %s.',
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
        'Bounce Article to a different mail address' => 'Facer rebotar o artigo a un enderezo de correo distinto',
        'Bounce' => 'Rebotar',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketCompose.pm
        'Reply All' => 'Contestar a Todos',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketEmailResend.pm
        'Resend this article' => '',
        'Resend' => '',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketMessageLog.pm
        'View message log details for this article' => '',
        'Message Log' => '',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketNote.pm
        'Reply to note' => 'Contestación a nota',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketPhone.pm
        'Split this article' => 'Divida este articulo',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketPlain.pm
        'View the source for this Article' => '',
        'Plain Format' => 'Formato plano',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketPrint.pm
        'Print this article' => 'Imprimir este artigo',

        # Perl Module: Kernel/Output/HTML/ArticleAction/GetHelpLink.pm
        'Contact us at sales@otrs.com' => '',
        'Get Help' => '',

        # Perl Module: Kernel/Output/HTML/ArticleAction/MarkAsImportant.pm
        'Mark' => 'Marcar',
        'Unmark' => 'Desmarcar',

        # Perl Module: Kernel/Output/HTML/ArticleAction/ReinstallPackageLink.pm
        'Upgrade to OTRS Business Solution™' => '',
        'Re-install Package' => '',
        'Upgrade' => 'Repositorio local',
        'Re-install' => '',

        # Perl Module: Kernel/Output/HTML/ArticleCheck/PGP.pm
        'Crypted' => 'Cifrado',
        'Sent message encrypted to recipient!' => '',
        'Signed' => 'Asinado',
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
        'Sign' => 'Asinar',
        'Keys/certificates will only be shown for a sender with more than one key/certificate. The first found key/certificate will be pre-selected. Please make sure to select the correct one.' =>
            '',

        # Perl Module: Kernel/Output/HTML/Dashboard/AppointmentCalendar.pm
        'Shown' => 'Mostrado',
        'Refresh (minutes)' => '',
        'off' => 'desactivado',

        # Perl Module: Kernel/Output/HTML/Dashboard/CustomerIDList.pm
        'Shown customer ids' => '',

        # Perl Module: Kernel/Output/HTML/Dashboard/CustomerUserList.pm
        'Shown customer users' => 'Mostrar os usuarios clientes',
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
        'Shown Tickets' => 'Tíckets mostrados',
        'Shown Columns' => 'Columnas mostradas',
        'filter not active' => '',
        'filter active' => '',
        'This ticket has no title or subject' => 'Este ticket non ten título ou tema',

        # Perl Module: Kernel/Output/HTML/Dashboard/TicketStatsGeneric.pm
        '7 Day Stats' => 'Estatísticas de 7 días',

        # Perl Module: Kernel/Output/HTML/Dashboard/UserOnline.pm
        'User set their status to unavailable.' => '',
        'Unavailable' => '',

        # Perl Module: Kernel/Output/HTML/Layout.pm
        'Standard' => 'Estándar',
        'The following tickets are not updated: %s.' => '',
        'h' => 'h',
        'm' => 'm',
        'd' => 'de',
        'This ticket does not exist, or you don\'t have permissions to access it in its current state. You can take one of the following actions:' =>
            '',
        'This is a' => 'Esto e un',
        'email' => 'Correo',
        'click here' => 'prema aquí',
        'to open it in a new window.' => 'abrilo nunha nova ventá.',
        'Year' => 'Ano',
        'Hours' => 'Horas',
        'Minutes' => 'Minutos',
        'Check to activate this date' => 'Marque para activar esta data',
        '%s TB' => '',
        '%s GB' => '',
        '%s MB' => '',
        '%s KB' => '',
        '%s B' => '',
        'No Permission!' => 'Permiso denegado!',
        'No Permission' => '',
        'Show Tree Selection' => 'Mostrar a árbore de selección',
        'Split Quote' => 'Split Quote',
        'Remove Quote' => '',

        # Perl Module: Kernel/Output/HTML/Layout/LinkObject.pm
        'Linked as' => '',
        'Search Result' => '',
        'Linked' => 'Ligado',
        'Bulk' => 'Masa',

        # Perl Module: Kernel/Output/HTML/Layout/Ticket.pm
        'Lite' => 'Lixeira',
        'Unread article(s) available' => 'Artigo(s) sen leer dispoñibles',

        # Perl Module: Kernel/Output/HTML/LinkObject/Appointment.pm
        'Appointment' => '',

        # Perl Module: Kernel/Output/HTML/LinkObject/Ticket.pm
        'Archive search' => '',

        # Perl Module: Kernel/Output/HTML/Notification/AgentCloudServicesDisabled.pm
        'Enable cloud services to unleash all OTRS features!' => '',

        # Perl Module: Kernel/Output/HTML/Notification/AgentOTRSBusiness.pm
        '%s Upgrade to %s now! %s' => '%s Actualice a %s agora! %s',
        'Please verify your license data!' => '',
        'The license for your %s is about to expire. Please make contact with %s to renew your contract!' =>
            'A licencia para a súa %s e preto de expirar. Por favor contacte con %s para a renovación do seu contrato!',
        'An update for your %s is available, but there is a conflict with your framework version! Please update your framework first!' =>
            'Existe unha actualización para o seu %s mais existe un conflito coa versión da súa infraestrutura! Actualice a súa infraestrutura antes!',

        # Perl Module: Kernel/Output/HTML/Notification/AgentOnline.pm
        'Online Agent: %s' => 'Axente na rede: %s',

        # Perl Module: Kernel/Output/HTML/Notification/AgentTicketEscalation.pm
        'There are more escalated tickets!' => 'Hai mais Tickets escalados!',

        # Perl Module: Kernel/Output/HTML/Notification/AgentTimeZoneCheck.pm
        'Please select a time zone in your preferences and confirm it by clicking the save button.' =>
            '',

        # Perl Module: Kernel/Output/HTML/Notification/CustomerOnline.pm
        'Online Customer: %s' => 'Cliente na rede: %s',

        # Perl Module: Kernel/Output/HTML/Notification/CustomerSystemMaintenanceCheck.pm
        'System maintenance is active!' => '',
        'A system maintenance period will start at: %s and is expected to stop at: %s' =>
            '',

        # Perl Module: Kernel/Output/HTML/Notification/DaemonCheck.pm
        'OTRS Daemon is not running.' => 'Daemon OTRS non se está a executar',

        # Perl Module: Kernel/Output/HTML/Notification/OutofOfficeCheck.pm
        'You have Out of Office enabled, would you like to disable it?' =>
            'Ten activado o servizo «fóra da oficina»; desexa desactivalo?',

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
        'Preferences updated successfully!' => 'Actualización das preferencias satisfatoria!',

        # Perl Module: Kernel/Output/HTML/Preferences/Language.pm
        '(in process)' => '(en proceso)',

        # Perl Module: Kernel/Output/HTML/Preferences/OutOfOffice.pm
        'Please specify an end date that is after the start date.' => '',

        # Perl Module: Kernel/Output/HTML/Preferences/Password.pm
        'Current password' => 'Contrasinal actual',
        'New password' => 'Novo contrasinal',
        'Verify password' => 'Verificar contrasinal',
        'The current password is not correct. Please try again!' => 'O contrasinal actual non é correcto. Por favor, probe de novo!',
        'Please supply your new password!' => 'Por favor proporcione o seu novo contrasinal!',
        'Can\'t update password, your new passwords do not match. Please try again!' =>
            'Non se pode actualizar o contrasinal, as súas novas contrasinais non coinciden. Por favor, probe novamente!',
        'This password is forbidden by the current system configuration. Please contact the administrator if you have additional questions.' =>
            '',
        'Can\'t update password, it must be at least %s characters long!' =>
            'Non se pode actualizar o contrasinal, debe conter polo menos %s carácteres!',
        'Can\'t update password, it must contain at least 2 lowercase and 2 uppercase letter characters!' =>
            '',
        'Can\'t update password, it must contain at least 1 digit!' => 'Non se pode actualizar o contrasinal, debe conter polo menos 1 dixito!',
        'Can\'t update password, it must contain at least 2 letter characters!' =>
            '',

        # Perl Module: Kernel/Output/HTML/Preferences/TimeZone.pm
        'Time zone updated successfully!' => '',

        # Perl Module: Kernel/Output/HTML/Statistics/View.pm
        'invalid' => 'incorrecto',
        'valid' => 'correcto',
        'No (not supported)' => 'Non (non admitido)',
        'No past complete or the current+upcoming complete relative time value selected.' =>
            'Ningún pasado completo ou o actual+vindeiro valor de tempo relativo completo seleccionado.',
        'The selected time period is larger than the allowed time period.' =>
            'O período de tempo seleccionado é maior que o período de tempo permitido.',
        'No time scale value available for the current selected time scale value on the X axis.' =>
            'Non hai dispoñible valor de escala de tempo para o actual valor seleccionado da escala de tempo no eixo X.',
        'The selected date is not valid.' => 'A data seleccionada non é válida.',
        'The selected end time is before the start time.' => 'O tempo de finalización seleccionado é anterior o tempo de comezo.',
        'There is something wrong with your time selection.' => 'Hai algo mal coa súa selección de tempo.',
        'Please select only one element or allow modification at stat generation time.' =>
            'Por favor seleccione un elemento ou permita a modificación no tempo de xeneración de estatística.',
        'Please select at least one value of this field or allow modification at stat generation time.' =>
            '',
        'Please select one element for the X-axis.' => 'Por favor seleccione un elemento para o eixo X.',
        'You can only use one time element for the Y axis.' => 'So pode usar un elemento de tempo para o eixo Y.',
        'You can only use one or two elements for the Y axis.' => 'So pode usar un ou dous elementos para o eixo Y.',
        'Please select at least one value of this field.' => '',
        'Please provide a value or allow modification at stat generation time.' =>
            '',
        'Please select a time scale.' => '',
        'Your reporting time interval is too small, please use a larger time scale.' =>
            '',
        'second(s)' => 'segundo(s)',
        'quarter(s)' => 'cuadrimestre(s)',
        'half-year(s)' => 'medio ano(s)',
        'Please remove the following words because they cannot be used for the ticket restrictions: %s.' =>
            '',

        # Perl Module: Kernel/Output/HTML/SysConfig.pm
        'Cancel editing and unlock this setting' => '',
        'Reset this setting to its default value.' => '',
        'Unable to load %s!' => '',
        'Content' => 'Contido',

        # Perl Module: Kernel/Output/HTML/TicketMenu/Lock.pm
        'Unlock to give it back to the queue' => 'Desbloquear para devolvelo á cola',
        'Lock it to work on it' => 'Bloquealo para traballar con el',

        # Perl Module: Kernel/Output/HTML/TicketMenu/TicketWatcher.pm
        'Unwatch' => 'Non vistos',
        'Remove from list of watched tickets' => 'Elimine da lista de tickets vistos.',
        'Watch' => 'Vixilancia',
        'Add to list of watched tickets' => 'Engadir á lista de tíckets vixiados',

        # Perl Module: Kernel/Output/HTML/TicketOverviewMenu/Sort.pm
        'Order by' => 'Ordene por',

        # Perl Module: Kernel/Output/HTML/TicketZoom/TicketInformation.pm
        'Ticket Information' => 'Información Ticket',

        # Perl Module: Kernel/Output/HTML/ToolBar/TicketLocked.pm
        'Locked Tickets New' => 'Tíckets bloqueados novos',
        'Locked Tickets Reminder Reached' => 'Alcanzado o Recordatorio de Tickets Bloqueados',
        'Locked Tickets Total' => 'Total de tíckets bloqueados',

        # Perl Module: Kernel/Output/HTML/ToolBar/TicketResponsible.pm
        'Responsible Tickets New' => 'Novos Tickets do Responsable',
        'Responsible Tickets Reminder Reached' => 'Recordatorio dos Tickets do Responsable Alcanzado',
        'Responsible Tickets Total' => 'Total de Tickets do Responsable',

        # Perl Module: Kernel/Output/HTML/ToolBar/TicketWatcher.pm
        'Watched Tickets New' => 'Novos Tickets Mirados',
        'Watched Tickets Reminder Reached' => 'Recordatorio dos Tickets Mirados Alcanzado',
        'Watched Tickets Total' => 'Total de Tickets Mirados',

        # Perl Module: Kernel/Output/PDF/Ticket.pm
        'Ticket Dynamic Fields' => 'Campos Dinámicos do Ticket',

        # Perl Module: Kernel/System/ACL/DB/ACL.pm
        'Couldn\'t read ACL configuration file. Please make sure the file is valid.' =>
            '',

        # Perl Module: Kernel/System/Auth.pm
        'It is currently not possible to login due to a scheduled system maintenance.' =>
            'Actualmente non é posíble acceder debido a un mantemento programado do sistema.',

        # Perl Module: Kernel/System/AuthSession.pm
        'You have exceeded the number of concurrent agents - contact sales@otrs.com.' =>
            '',
        'Please note that the session limit is almost reached.' => '',
        'Login rejected! You have exceeded the maximum number of concurrent Agents! Contact sales@otrs.com immediately!' =>
            '',
        'Session limit reached! Please try again later.' => 'Alcanzado o limite da sesión! Intenteo novamente despois.',
        'Session per user limit reached!' => '',

        # Perl Module: Kernel/System/AuthSession/DB.pm
        'Session invalid. Please log in again.' => 'A sesión é incorrecta. Acceda de novo.',
        'Session has timed out. Please log in again.' => 'A sesión expirou. Ingrese novamente.',

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
        'before/after' => 'antes/despois',
        'between' => 'entre',

        # Perl Module: Kernel/System/DynamicField/Driver/BaseText.pm
        'e.g. Text or Te*t' => '',

        # Perl Module: Kernel/System/DynamicField/Driver/Checkbox.pm
        'Ignore this field.' => '',

        # Perl Module: Kernel/System/DynamicField/Driver/TextArea.pm
        'This field is required or' => 'O campo é obrigatorio ou',
        'The field content is too long!' => 'O contido do campo é longo de máis!',
        'Maximum size is %s characters.' => 'O tamaño máximo é de %s caracteres.',

        # Perl Module: Kernel/System/NotificationEvent.pm
        'Couldn\'t read Notification configuration file. Please make sure the file is valid.' =>
            '',
        'Imported notification has body text with more than 4000 characters.' =>
            '',

        # Perl Module: Kernel/System/Package.pm
        'not installed' => '',
        'installed' => 'instalado',
        'Unable to parse repository index document.' => 'Non foi posíbel analizar o documento de índice do repositorio.',
        'No packages for your framework version found in this repository, it only contains packages for other framework versions.' =>
            'Non se atoparon paquetes para a súa versión da infraestrutura neste repositorio, só contén paquetes para versións doutras infraestruturas.',
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
        'Inactive' => 'Inactivo',
        'FadeAway' => '',

        # Perl Module: Kernel/System/Registration.pm
        'Can\'t contact registration server. Please try again later.' => 'Non se pode contactar co servizo de rexistro. Por favor, volva a intentalo mais tarde.',
        'No content received from registration server. Please try again later.' =>
            'Non se recibiu ningún contido do servidor de rexistro. Ténteo de novo máis tarde.',
        'Can\'t get Token from sever' => '',
        'Username and password do not match. Please try again.' => 'Nome de usuario e contrasinal non coinciden. Por favor, volva a intentalo.',
        'Problems processing server result. Please try again later.' => 'Problemas no procesado dos resultados do servidor. Por favor, volva a intentalo mais tarde.',

        # Perl Module: Kernel/System/Stats.pm
        'Sum' => 'Suma',
        'week' => 'semana',
        'quarter' => 'cuadrimestre',
        'half-year' => 'medio ano',

        # Perl Module: Kernel/System/Stats/Dynamic/Ticket.pm
        'State Type' => '',
        'Created Priority' => 'Prioridade Creada',
        'Created State' => 'Estado Creado',
        'Create Time' => 'Tempo de Creación',
        'Pending until time' => '',
        'Close Time' => 'Hora de peche',
        'Escalation' => 'Agravación',
        'Escalation - First Response Time' => '',
        'Escalation - Update Time' => '',
        'Escalation - Solution Time' => '',
        'Agent/Owner' => 'Axente/Dono',
        'Created by Agent/Owner' => 'Creado polo Axente/Propietario',
        'Assigned to Customer User Login' => '',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketAccountedTime.pm
        'Evaluation by' => 'Avaliar por',
        'Ticket/Article Accounted Time' => 'Tempo considerado polo Ticket/Artigo',
        'Ticket Create Time' => 'Tempo Creación Ticket',
        'Ticket Close Time' => 'Tempo Peche Ticket',
        'Accounted time by Agent' => 'Tempo considerado polo Axente',
        'Total Time' => 'Tempo Total',
        'Ticket Average' => 'Media de Ticket',
        'Ticket Min Time' => 'Mínimo tempo de Ticket',
        'Ticket Max Time' => 'Máximo Tempo de Ticket',
        'Number of Tickets' => 'Número de Tickets',
        'Article Average' => 'Media de artigos',
        'Article Min Time' => 'Tempo Mínimo de Artigo',
        'Article Max Time' => 'Máximo Tempo de Artigo',
        'Number of Articles' => 'Número de artigos',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketList.pm
        'unlimited' => '',
        'Attributes to be printed' => 'Atributos que imprimir',
        'Sort sequence' => 'Secuencia de clase',
        'State Historic' => '',
        'State Type Historic' => '',
        'Historic Time Range' => '',
        'Number' => 'Número',
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
        'Days' => 'Días',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/OutdatedTables.pm
        'Outdated Tables' => '',
        'Outdated tables were found in the database. These can be removed if empty.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/TablePresence.pm
        'Table Presence' => 'Presenza de táboas',
        'Internal Error: Could not open file.' => 'Erro interno: Non foi posíbel abrir o ficheiro.',
        'Table Check' => 'Comprobación de táboas',
        'Internal Error: Could not read file.' => 'Erro interno: Non foi posíbel ler o ficheiro.',
        'Tables found which are not present in the database.' => 'Táboas atopadas as cales non están presentes na base de datos.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mssql/Size.pm
        'Database Size' => 'Tamaño da base de datos',
        'Could not determine database size.' => 'Non se pode determinar o tamaño da base de datos.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mssql/Version.pm
        'Database Version' => 'Versión da base de datos',
        'Could not determine database version.' => 'Non se pode determinar a versión da base de datos.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Charset.pm
        'Client Connection Charset' => 'Conxunto de caracteres da conexión do cliente',
        'Setting character_set_client needs to be utf8.' => 'O axuste do character_set_client ten que ser utf8',
        'Server Database Charset' => 'Cadea de carácteres do Servidor da Base de Datos',
        'This character set is not yet supported, please see https://bugs.otrs.org/show_bug.cgi?id=12361. Please convert your database to the character set \'utf8\'.' =>
            '',
        'The setting character_set_database needs to be \'utf8\'.' => '',
        'Table Charset' => 'Conxunto de caracteres da táboa',
        'There were tables found which do not have \'utf8\' as charset.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/InnoDBLogFileSize.pm
        'InnoDB Log File Size' => 'Tamaño do ficheiro de rexistro de InnoDB',
        'The setting innodb_log_file_size must be at least 256 MB.' => 'A opción innodb_log_file_size ha de ter, como mínimo, 256 MB.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/InvalidDefaultValues.pm
        'Invalid Default Values' => '',
        'Tables with invalid default values were found. In order to fix it automatically, please run: bin/otrs.Console.pl Maint::Database::Check --repair' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/MaxAllowedPacket.pm
        'Maximum Query Size' => 'Tamaño Máximo da Consulta',
        'The setting \'max_allowed_packet\' must be higher than 64 MB.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Performance.pm
        'Query Cache Size' => 'Tamaño da Cache da Consulta',
        'The setting \'query_cache_size\' should be used (higher than 10 MB but not more than 512 MB).' =>
            'Deberíase empregar a opción «query_cache_size» (maior de 10 MB mais non de 512 MB).',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/StorageEngine.pm
        'Default Storage Engine' => 'Motor de almacenamento predeterminado',
        'Table Storage Engine' => '',
        'Tables with a different storage engine than the default engine were found.' =>
            'Atopáronse táboas cun motor de almacenamento disinto do predeterminado.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Version.pm
        'MySQL 5.x or higher is required.' => 'Requírese MySQL 5.x ou superior.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/oracle/NLS.pm
        'NLS_LANG Setting' => 'Axuste de NLS_LANG',
        'NLS_LANG must be set to al32utf8 (e.g. GERMAN_GERMANY.AL32UTF8).' =>
            '',
        'NLS_DATE_FORMAT Setting' => 'Axuste NLS_DATE_FORMAT',
        'NLS_DATE_FORMAT must be set to \'YYYY-MM-DD HH24:MI:SS\'.' => 'NLS_DATE_FORMAT debe ser posto como \'YYY-MM-DD HH24:MI:SS\'.',
        'NLS_DATE_FORMAT Setting SQL Check' => 'Axuste Comprobación SQL NLS_DATE_FORMAT',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/oracle/PrimaryKeySequencesAndTriggers.pm
        'Primary Key Sequences and Triggers' => '',
        'The following sequences and/or triggers with possible wrong names have been found. Please rename them manually.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/Charset.pm
        'Setting client_encoding needs to be UNICODE or UTF8.' => 'O axuste client_encoding ten que ser UNICODE ou UTF8.',
        'Setting server_encoding needs to be UNICODE or UTF8.' => 'O axuste server_encoding ten que ser UNICODE ou UTF8.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/DateStyle.pm
        'Date Format' => 'Formato de data',
        'Setting DateStyle needs to be ISO.' => 'O axuste DateStyle ten que ser ISO.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/PrimaryKeySequences.pm
        'Primary Key Sequences' => '',
        'The following sequences with possible wrong names have been found. Please rename them manually.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/Version.pm
        'PostgreSQL 9.2 or higher is required.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskPartitionOTRS.pm
        'OTRS Disk Partition' => 'Partición de disco de OTRS',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskSpace.pm
        'Disk Usage' => 'Uso de disco',
        'The partition where OTRS is located is almost full.' => 'A partición onde OTRS é localizado é practicamente chea.',
        'The partition where OTRS is located has no disk space problems.' =>
            'A partición onde OTRS é localizado non ten problemas de espazo en disco.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskSpacePartitions.pm
        'Disk Partitions Usage' => 'Uso Particions Disco',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Distribution.pm
        'Distribution' => 'Distribución',
        'Could not determine distribution.' => 'non se pode determinar a distribución.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/KernelVersion.pm
        'Kernel Version' => 'Versión do kernel',
        'Could not determine kernel version.' => 'Non se pode determinar a versión do kernel.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Load.pm
        'System Load' => 'Carga do sistema',
        'The system load should be at maximum the number of CPUs the system has (e.g. a load of 8 or less on a system with 8 CPUs is OK).' =>
            'A carga do sistema debe ser como máximo como o número de CPUs co sistema ten (P.Ex. a craga de 8 ou menos nun sistema con 8 CPUs é OK).',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/PerlModules.pm
        'Perl Modules' => 'Módulos de Perl',
        'Not all required Perl modules are correctly installed.' => 'Non todos os módulos de Perl requiridos están instalados correctamente.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/PerlModulesAudit.pm
        'Perl Modules Audit' => '',
        'CPAN::Audit reported that one or more installed Perl modules have known vulnerabilities. Please note that there might be false positives for distributions patching Perl modules without changing their version number.' =>
            '',
        'CPAN::Audit did not report any known vulnerabilities in the installed Perl modules.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Swap.pm
        'Free Swap Space (%)' => 'Espazo Libre de Permutación (%)',
        'No swap enabled.' => '',
        'Used Swap Space (MB)' => 'Espazo de Permutación Usado (MB)',
        'There should be more than 60% free swap space.' => 'Ten que haber mais do 60% de espazo libre permutado.',
        'There should be no more than 200 MB swap space used.' => 'Non debe haber mais de 200 MB de espazo libre permutado.',

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
        'Average processing time of communications (s)' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/CommunicationLogAccountStatus.pm
        'Communication Log Account Status (last 24 hours)' => '',
        'No connections found.' => '',
        'ok' => '',
        'permanent connection errors' => '',
        'intermittent connection errors' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/ConfigSettings.pm
        'Config Settings' => 'Axustes de Configuración',
        'Could not determine value.' => 'Non se pode determinar o valor.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/DaemonRunning.pm
        'Daemon' => '',
        'Daemon is running.' => '',
        'Daemon is not running.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/DatabaseRecords.pm
        'Database Records' => 'Rexistros da base de datos',
        'Tickets' => 'Tickets',
        'Ticket History Entries' => 'Historial Entrada Ticket',
        'Articles' => 'Artigos',
        'Attachments (DB, Without HTML)' => 'Anexos (Base de datos, sen HTML)',
        'Customers With At Least One Ticket' => 'Clientes cun mínimo de un tícket',
        'Dynamic Field Values' => 'Valores Campo Dinámico',
        'Invalid Dynamic Fields' => 'Campos dinámicos incorrectos',
        'Invalid Dynamic Field Values' => 'Valores incorrectos de campo dinámico',
        'GenericInterface Webservices' => 'Interface Xenérica dos Servizos Web',
        'Process Tickets' => '',
        'Months Between First And Last Ticket' => 'Meses Entre o Primeiro e o Derradeiro Ticket',
        'Tickets Per Month (avg)' => 'Tíckets por mes (media)',
        'Open Tickets' => 'Abrir Tickets',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/DefaultSOAPUser.pm
        'Default SOAP Username And Password' => '',
        'Security risk: you use the default setting for SOAP::User and SOAP::Password. Please change it.' =>
            'Risco de Seguridade: Está empregando un axuste por defecto para SOAP::User e SOAP::Password. Por favor, cámbielo.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/DefaultUser.pm
        'Default Admin Password' => 'Contrasinal de administración predeterminada',
        'Security risk: the agent account root@localhost still has the default password. Please change it or invalidate the account.' =>
            'Risco de Seguridade: A conta de axente root@localhost ten ainda o contrasinal por defecto. Por favor cambielo ou invalide a conta.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/EmailQueue.pm
        'Email Sending Queue' => '',
        'Emails queued for sending' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/FQDN.pm
        'FQDN (domain name)' => '',
        'Please configure your FQDN setting.' => '',
        'Domain Name' => 'Nome de Dominio',
        'Your FQDN setting is invalid.' => 'O seu axuste de FQDN é invalido.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/FileSystemWritable.pm
        'File System Writable' => 'Arquivo de Sitema Editable',
        'The file system on your OTRS partition is not writable.' => 'O arquivo de sitema na súa partición de OTRS non é editable.',

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
        'Some packages are not correctly installed.' => 'Algúns paquetes non están instalados correctamente.',
        'Package Verification Status' => '',
        'Some packages are not verified by the OTRS Group! It is recommended not to use this packages.' =>
            '',
        'Package Framework Version Status' => '',
        'Some packages are not allowed for the current framework version.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/PackageList.pm
        'Package List' => 'Lista de paquetes',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/SessionConfigSettings.pm
        'Session Config Settings' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/SpoolMails.pm
        'Spooled Emails' => '',
        'There are emails in var/spool that OTRS could not process.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/SystemID.pm
        'Your SystemID setting is invalid, it should only contain digits.' =>
            'O axuste daIDSistema é invalido, debe conter só dixitos.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/DefaultType.pm
        'Default Ticket Type' => '',
        'The configured default ticket type is invalid or missing. Please change the setting Ticket::Type::Default and select a valid ticket type.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/IndexModule.pm
        'Ticket Index Module' => 'Módulo de Índice de Ticket',
        'You have more than 60,000 tickets and should use the StaticDB backend. See admin manual (Performance Tuning) for more information.' =>
            'Ten mais de 60,000 tickets e debería empregar StaticDB backend. Vexa o manual do administrador (Sintonía do Rendemento) para mais información.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/InvalidUsersWithLockedTickets.pm
        'Invalid Users with Locked Tickets' => '',
        'There are invalid users with locked tickets.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/OpenTickets.pm
        'You should not have more than 8,000 open tickets in your system.' =>
            'Non debe ter mais de 8,000 tickets no seu sistema.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/SearchIndexModule.pm
        'Ticket Search Index Module' => '',
        'The indexing process forces the storage of the original article text in the article search index, without executing filters or applying stop word lists. This will increase the size of the search index and thus may slow down fulltext searches.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/StaticDBOrphanedRecords.pm
        'Orphaned Records In ticket_lock_index Table' => 'Rexistros orfos na táboa ticket_lock_index',
        'Table ticket_lock_index contains orphaned records. Please run bin/otrs.Console.pl "Maint::Ticket::QueueIndexCleanup" to clean the StaticDB index.' =>
            '',
        'Orphaned Records In ticket_index Table' => 'Rexistros orfos na táboa ticket_index',
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
        'Webserver' => 'Servidor Web',
        'Loaded Apache Modules' => 'Módulos de Apache cargados',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/MPMModel.pm
        'MPM model' => 'Modelo MPM',
        'OTRS requires apache to be run with the \'prefork\' MPM model.' =>
            'OTRS require apache para ser executado co modelo \'prefork\' MPM.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/Performance.pm
        'CGI Accelerator Usage' => 'Uso Acelerador CGI',
        'You should use FastCGI or mod_perl to increase your performance.' =>
            'Debe empregar FastCGI ou mod_perl para incrementa-lo seu rendemento',
        'mod_deflate Usage' => 'Uso de mod_deflate',
        'Please install mod_deflate to improve GUI speed.' => 'Por favor instale mod_deflate para incrementar a velocidade da GUI',
        'mod_filter Usage' => 'Uso de mod_filter',
        'Please install mod_filter if mod_deflate is used.' => 'Por favor instale mod_filter se mod_deflate é empregado',
        'mod_headers Usage' => 'Uso de mod_headers',
        'Please install mod_headers to improve GUI speed.' => 'Por favor instale mod_headers para que mellore a velocidade da GUI',
        'Apache::Reload Usage' => 'Uso de Apache::Reload',
        'Apache::Reload or Apache2::Reload should be used as PerlModule and PerlInitHandler to prevent web server restarts when installing and upgrading modules.' =>
            'Apache::Reload ou Apache2::Reload deben ser empregados coma PerlModule e PerlInitHandler para previr o reinicio de servidor web cando se instalan e actualizan módulos.',
        'Apache2::DBI Usage' => '',
        'Apache2::DBI should be used to get a better performance  with pre-established database connections.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/EnvironmentVariables.pm
        'Environment Variables' => 'Variables de Ambiente',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/InternalWebRequest.pm
        'Support Data Collection' => '',
        'Support data could not be collected from the web server.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Version.pm
        'Webserver Version' => 'Versión do Servidor Web',
        'Could not determine webserver version.' => 'Non se pode determinar a versión do servidor web',

        # Perl Module: Kernel/System/SupportDataCollector/PluginAsynchronous/OTRS/ConcurrentUsers.pm
        'Concurrent Users Details' => '',
        'Concurrent Users' => 'Usuarios Concurrentes',

        # Perl Module: Kernel/System/SupportDataCollector/PluginBase.pm
        'OK' => 'Aceptar',
        'Problem' => 'Problema',

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
            'Fallou o acceso! O nome de usuario ou o contrasinal foron introducidos incorrectamente.',
        'Authentication succeeded, but no user data record is found in the database. Please contact the administrator.' =>
            '',
        'Can`t remove SessionID.' => '',
        'Logout successful.' => '',
        'Feature not active!' => 'Esta funcionalidade non está activa!',
        'Sent password reset instructions. Please check your email.' => 'Enviadas as instruccións para resetea-la contrasinal. Por favor comprobe o seu email.',
        'Invalid Token!' => 'Ficha incorrecta!',
        'Sent new password to %s. Please check your email.' => 'Enviada a nova contrasinal a %s. Por favor comprobe o seu email.',
        'Error: invalid session.' => '',
        'No Permission to use this frontend module!' => '',

        # Perl Module: Kernel/System/Web/InterfaceCustomer.pm
        'Authentication succeeded, but no customer record is found in the customer backend. Please contact the administrator.' =>
            '',
        'Reset password unsuccessful. Please contact the administrator.' =>
            '',
        'This e-mail address already exists. Please log in or reset your password.' =>
            'Este enderezo de correo xa existe. Acceda ou reinicie o seu contrasinal.',
        'This email address is not allowed to register. Please contact support staff.' =>
            'Non se permite rexistrar este enderezo de correo. Contacte co persoal de apoio.',
        'Added via Customer Panel (%s)' => '',
        'Customer user can\'t be added!' => '',
        'Can\'t send account info!' => '',
        'New account created. Sent login information to %s. Please check your email.' =>
            'Creouse unha conta nova. A información de acceso foille enviada a %s. Comprobe o seu correo.',

        # Perl Module: Kernel/System/Web/InterfaceInstaller.pm
        'Action "%s" not found!' => '',

        # Database XML Definition: scripts/database/otrs-initial_insert.xml
        'invalid-temporarily' => 'Non valido temporalmente',
        'Group for default access.' => '',
        'Group of all administrators.' => '',
        'Group for statistics access.' => '',
        'new' => 'novo',
        'All new state types (default: viewable).' => '',
        'open' => 'abrir',
        'All open state types (default: viewable).' => '',
        'closed' => 'pechado',
        'All closed state types (default: not viewable).' => '',
        'pending reminder' => 'recordatorio pendente',
        'All \'pending reminder\' state types (default: viewable).' => '',
        'pending auto' => 'espera auto',
        'All \'pending auto *\' state types (default: viewable).' => '',
        'removed' => 'retirado',
        'All \'removed\' state types (default: not viewable).' => '',
        'merged' => 'combinado',
        'State type for merged tickets (default: not viewable).' => '',
        'New ticket created by customer.' => '',
        'closed successful' => 'pechado satisfactoriamente',
        'Ticket is closed successful.' => '',
        'closed unsuccessful' => 'pechado infrutuosamente',
        'Ticket is closed unsuccessful.' => '',
        'Open tickets.' => '',
        'Customer removed ticket.' => '',
        'Ticket is pending for agent reminder.' => '',
        'pending auto close+' => 'espera auto pechado+',
        'Ticket is pending for automatic close.' => '',
        'pending auto close-' => 'espera auto pechado-',
        'State for merged tickets.' => '',
        'system standard salutation (en)' => '',
        'Standard Salutation.' => '',
        'system standard signature (en)' => '',
        'Standard Signature.' => '',
        'Standard Address.' => '',
        'possible' => 'posíble',
        'Follow-ups for closed tickets are possible. Ticket will be reopened.' =>
            '',
        'reject' => 'rexeitar',
        'Follow-ups for closed tickets are not possible. No new ticket will be created.' =>
            '',
        'new ticket' => '',
        'Follow-ups for closed tickets are not possible. A new ticket will be created.' =>
            '',
        'Postmaster queue.' => '',
        'All default incoming tickets.' => '',
        'All junk tickets.' => '',
        'All misc tickets.' => '',
        'auto reply' => 'autoresposta',
        'Automatic reply which will be sent out after a new ticket has been created.' =>
            '',
        'auto reject' => 'autorexeitar',
        'Automatic reject which will be sent out after a follow-up has been rejected (in case queue follow-up option is "reject").' =>
            '',
        'auto follow up' => 'autoseguimento',
        'Automatic confirmation which is sent out after a follow-up has been received for a ticket (in case queue follow-up option is "possible").' =>
            '',
        'auto reply/new ticket' => 'autoresposta/novo ticket',
        'Automatic response which will be sent out after a follow-up has been rejected and a new ticket has been created (in case queue follow-up option is "new ticket").' =>
            '',
        'auto remove' => 'auto eliminar',
        'Auto remove will be sent out after a customer removed the request.' =>
            '',
        'default reply (after new ticket has been created)' => '',
        'default reject (after follow-up and rejected of a closed ticket)' =>
            '',
        'default follow-up (after a ticket follow-up has been added)' => '',
        'default reject/new ticket created (after closed follow-up with new ticket creation)' =>
            '',
        'Unclassified' => '',
        '1 very low' => '1 moi baixo',
        '2 low' => '2 baixo',
        '3 normal' => '3 normal',
        '4 high' => '4 alto',
        '5 very high' => '5 moi alto',
        'unlock' => 'desbloquear',
        'lock' => 'bloquear',
        'tmp_lock' => '',
        'agent' => 'axente',
        'system' => 'sistema',
        'customer' => 'cliente',
        'Ticket create notification' => '',
        'You will receive a notification each time a new ticket is created in one of your "My Queues" or "My Services".' =>
            '',
        'Ticket follow-up notification (unlocked)' => '',
        'You will receive a notification if a customer sends a follow-up to an unlocked ticket which is in your "My Queues" or "My Services".' =>
            '',
        'Ticket follow-up notification (locked)' => '',
        'You will receive a notification if a customer sends a follow-up to a locked ticket of which you are the ticket owner or responsible.' =>
            '',
        'Ticket lock timeout notification' => 'Notificación tempo de bloqueo de ticket excedido',
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
        'Add all' => 'Engadir todo',
        'An item with this name is already present.' => 'Xa existe un elemento con este nome.',
        'This item still contains sub items. Are you sure you want to remove this item including its sub items?' =>
            'Este elemento ainda contén sub elementos. Está seguro que quere borrar este elemento incluindo os seus sub elementos?',

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
            'Realmente quere borrar este campo dinámico? Tódolos  datos asociados serán PERDIDOS!',
        'Delete field' => 'Borre campo',
        'Deleting the field and its data. This may take a while...' => '',

        # JS File: Core.Agent.Admin.GenericAgent
        'Remove this dynamic field' => '',
        'Remove selection' => 'Elimine a selección',
        'Do you really want to delete this generic agent job?' => '',
        'Delete this Event Trigger' => 'Borrar este Desencadeante de Evento',
        'Duplicate event.' => 'Evento duplicado.',
        'This event is already attached to the job, Please use a different one.' =>
            'Este eventoé xa concedido ao traballo, Por Favor utilizar un diferente.',

        # JS File: Core.Agent.Admin.GenericInterfaceDebugger
        'An error occurred during communication.' => 'Produciuse un erro durante a comunicación.',
        'Request Details' => 'Detalles da solicitude',
        'Request Details for Communication ID' => '',
        'Show or hide the content.' => 'Mostrar ou agochar o contido.',
        'Clear debug log' => 'Limpar o rexistro de depuración',

        # JS File: Core.Agent.Admin.GenericInterfaceErrorHandling
        'Delete error handling module' => '',

        # JS File: Core.Agent.Admin.GenericInterfaceInvoker
        'It is not possible to add a new event trigger because the event is not set.' =>
            '',
        'Delete this Invoker' => 'Elimine este Invocador',

        # JS File: Core.Agent.Admin.GenericInterfaceInvokerEvent
        'Sorry, the only existing condition can\'t be removed.' => '',
        'Sorry, the only existing field can\'t be removed.' => '',
        'Delete conditions' => '',

        # JS File: Core.Agent.Admin.GenericInterfaceMapping
        'Mapping for Key %s' => '',
        'Mapping for Key' => '',
        'Delete this Key Mapping' => 'Borre esta Chave de Mapeado',

        # JS File: Core.Agent.Admin.GenericInterfaceOperation
        'Delete this Operation' => 'Borre esta Operación',

        # JS File: Core.Agent.Admin.GenericInterfaceWebservice
        'Clone web service' => 'Replicar o servizo web',
        'Delete operation' => 'Elimine a operación',
        'Delete invoker' => 'Elimine o invocador',

        # JS File: Core.Agent.Admin.Group
        'WARNING: When you change the name of the group \'admin\', before making the appropriate changes in the SysConfig, you will be locked out of the administrations panel! If this happens, please rename the group back to admin per SQL statement.' =>
            'ALERTA: Cando vostede cambia o nome do grupo \'admin\', antes de facer os cambios apropiados no SysConfig, vostede será bloqueado fóra do panel de administración! Se isto sucede, por favor renomee o grupo de volta a admin por declaración de SQL.',

        # JS File: Core.Agent.Admin.MailAccount
        'Delete this Mail Account' => '',
        'Deleting the mail account and its data. This may take a while...' =>
            '',

        # JS File: Core.Agent.Admin.NotificationEvent
        'Do you really want to delete this notification language?' => 'Confirma que desexa eliminar este idioma de notificación?',
        'Do you really want to delete this notification?' => 'Desexa realmente eliminar esta notificación?',

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
        'Remove Entity from canvas' => 'Elimine Entidade do canvas',
        'No TransitionActions assigned.' => 'Non AcciónsTransición asignadas.',
        'No dialogs assigned yet. Just pick an activity dialog from the list on the left and drag it here.' =>
            'Aínda non se asignou ningún diálogo. Colla un diálogo de actividade da lista da esquerda e arrástreo para aquí.',
        'This Activity cannot be deleted because it is the Start Activity.' =>
            'Esta Actividade non pode ser eliminada porque é a Actividade de Inicio.',
        'Remove the Transition from this Process' => 'Elimine a Transición para este Proceso',

        # JS File: Core.Agent.Admin.ProcessManagement
        'As soon as you use this button or link, you will leave this screen and its current state will be saved automatically. Do you want to continue?' =>
            'Tan pronto como use este botón ou ligazón, abandoará esta pantalla e o seu estado actual será gardado automaticamente. Quere continuar?',
        'Delete Entity' => 'Elimine Entidade',
        'This Activity is already used in the Process. You cannot add it twice!' =>
            'Esta Actividade está a ser empregada no Proceso. Non pode engadila dúas veces!',
        'Error during AJAX communication' => '',
        'An unconnected transition is already placed on the canvas. Please connect this transition first before placing another transition.' =>
            'Unha transición non conectada é xa posta no canvas. Por favor conecte esta transición antes de poñer outra transición.',
        'This Transition is already used for this Activity. You cannot use it twice!' =>
            'A Transición está a ser empregada para esta Actividade. Non pode usala dúas veces!',
        'This TransitionAction is already used in this Path. You cannot use it twice!' =>
            'Esta AcciónTransición está a ser empregada nesta Ruta. Non pode empregala dúas veces!',
        'Hide EntityIDs' => 'Ocultar EntityIds',
        'Edit Field Details' => 'Edite Detalles Campo',
        'Customer interface does not support articles not visible for customers.' =>
            '',
        'Sorry, the only existing parameter can\'t be removed.' => '',

        # JS File: Core.Agent.Admin.SMIME
        'Do you really want to delete this certificate?' => '',

        # JS File: Core.Agent.Admin.SupportDataCollector
        'Sending Update...' => 'Enviando Actualización...',
        'Support Data information was successfully sent.' => 'A información de datos de axuda foi enviada correctamente.',
        'Was not possible to send Support Data information.' => 'Non foi posíbel enviar a información de datos de axuda.',
        'Update Result' => 'Resultado Actualización',
        'Generating...' => 'Xerando...',
        'It was not possible to generate the Support Bundle.' => 'Non foi posible xenerar o Paquete de Apoio.',
        'Generate Result' => 'Resultado Xeración',
        'Support Bundle' => 'Paquete Apoio',
        'The mail could not be sent' => 'O mail non pudo ser enviado',

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
        'Loading...' => 'Cargando...',
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
            'Vostede realmente quere borrar este mantemento de sistema programado?',

        # JS File: Core.Agent.Admin.Template
        'Delete this Template' => '',
        'Deleting the template and its data. This may take a while...' =>
            '',

        # JS File: Core.Agent.AppointmentCalendar
        'Jump' => '',
        'Timeline Month' => '',
        'Timeline Week' => '',
        'Timeline Day' => '',
        'Previous' => 'Anterior',
        'Resources' => '',
        'Su' => 'Do',
        'Mo' => 'Lu',
        'Tu' => 'Sá',
        'We' => 'en',
        'Th' => 'Xo',
        'Fr' => 'Ve',
        'Sa' => 'Sá',
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
        'Duplicated entry' => 'Entrada duplicada',
        'It is going to be deleted from the field, please try again.' => 'Vai ser borrado do campo, por favor probar outra vez.',

        # JS File: Core.Agent.CustomerUserAddressBook
        'Please enter at least one search value or * to find anything.' =>
            'Por favor introduza polo menos un valor de busca ou * para atopar calquera cousa.',

        # JS File: Core.Agent.Daemon
        'Information about the OTRS Daemon' => '',

        # JS File: Core.Agent.Dashboard
        'Please check the fields marked as red for valid inputs.' => 'Por favor revise os campos marcados en vermello para entradas válidas.',
        'month' => 'mes',
        'Remove active filters for this widget.' => 'Elimine os filtros activos para este widget',

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
        'Switch to desktop mode' => 'Cambiar a modo escritorio',

        # JS File: Core.Agent.Search
        'Please remove the following words from your search as they cannot be searched for:' =>
            'Por favor elimine as palabras seguintes da súa busca porque elas non poden ser buscadas:',

        # JS File: Core.Agent.SharedSecretGenerator
        'Generate' => '',

        # JS File: Core.Agent.SortedTree
        'This element has children elements and can currently not be removed.' =>
            '',

        # JS File: Core.Agent.Statistics
        'Do you really want to delete this statistic?' => 'Confirma que desexa eliminar estas estatísticas?',

        # JS File: Core.Agent.TicketAction
        'Select a customer ID to assign to this ticket' => '',
        'Do you really want to continue?' => 'Desexa realmente continuar?',

        # JS File: Core.Agent.TicketBulk
        ' ...and %s more' => '',
        ' ...show less' => '',

        # JS File: Core.Agent.TicketFormDraft
        'Add new draft' => '',
        'Delete draft' => '',
        'There are no more drafts available.' => '',
        'It was not possible to delete this draft.' => '',

        # JS File: Core.Agent.TicketZoom
        'Article filter' => 'Filtro de artigos',
        'Apply' => 'Aplicar',
        'Event Type Filter' => 'Filtro de tipos de evento',

        # JS File: Core.Agent
        'Slide the navigation bar' => 'Desprazar a barra de navegación',
        'Please turn off Compatibility Mode in Internet Explorer!' => 'Por favor apague o Modo de Compatibilidade en Internet Explorer!',
        'Find out more' => '',

        # JS File: Core.App.Responsive
        'Switch to mobile mode' => 'Cambiar a modo móbil',

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
        'One or more errors occurred!' => 'Producíronse un ou máis erros!',

        # JS File: Core.Installer
        'Mail check successful.' => 'Comprobación de correo satisfactoria.',
        'Error in the mail settings. Please correct and try again.' => 'Erro nos axustes de corre. Por favor corríxao e volva a intentalo.',

        # JS File: Core.SystemConfiguration
        'Open this node in a new window' => '',
        'Please add values for all keys before saving the setting.' => '',
        'The key must not be empty.' => '',
        'A key with this name (\'%s\') already exists.' => '',
        'Do you really want to revert this setting to its historical value?' =>
            '',

        # JS File: Core.UI.Datepicker
        'Open date selection' => 'Abra selección de data',
        'Invalid date (need a future date)!' => 'A data é incorrecta (ten que ser unha data futura)!',
        'Invalid date (need a past date)!' => 'A data é incorrecta (ten que ser unha data do pasado)!',

        # JS File: Core.UI.InputFields
        'Not available' => 'Non dispoñible',
        'and %s more...' => 'e %s mais...',
        'Show current selection' => '',
        'Current selection' => '',
        'Clear all' => 'Limpar todo',
        'Filters' => 'Filtros',
        'Clear search' => 'Limpar busca',

        # JS File: Core.UI.Popup
        'If you now leave this page, all open popup windows will be closed, too!' =>
            'Se vostede deixa agora esta páxina, todas as ventás despregables abertas serán pechadas, tamén!',
        'A popup of this screen is already open. Do you want to close it and load this one instead?' =>
            'Un despregable desta pantalla xa está aberto. Vostede quere pechalo e cargar en cambio este?',
        'Could not open popup window. Please disable any popup blockers for this application.' =>
            'Non se puido abrir á ventá despregable. Por favor deshabilite calquera bloqueador de despregables para esta aplicación.',

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
        'There are currently no elements available to select from.' => 'Actualmente non hai elementos dispoñíbeis dos que seleccionar.',

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
        'yes' => 'si',
        'no' => 'non',
        'This is %s' => '',
        'Complex %s with %s arguments' => '',

        # JS File: OTRSLineChart
        'No Data Available.' => '',

        # JS File: OTRSMultiBarChart
        'Grouped' => 'Agrupado',
        'Stacked' => 'Amoreados',

        # JS File: OTRSStackedAreaChart
        'Stream' => 'Fluxo',
        'Expanded' => 'Expandido',

        # SysConfig
        '
Dear Customer,

Unfortunately we could not detect a valid ticket number
in your subject, so this email can\'t be processed.

Please create a new ticket via the customer panel.

Thanks for your help!

 Your Helpdesk Team
' => '',
        ' (work units)' => '(unidades de traballo)',
        ' 2 minutes' => ' 2 minutos',
        ' 5 minutes' => ' 5 minutos',
        ' 7 minutes' => ' 7 minutos',
        '"Slim" skin which tries to save screen space for power users.' =>
            '',
        '%s' => '%s',
        '(UserLogin) Firstname Lastname' => '(Usuario) Nome Apelido',
        '(UserLogin) Lastname Firstname' => '',
        '(UserLogin) Lastname, Firstname' => '(Usuario) Apelido, Nome',
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
        'A Website' => 'Un sitio web',
        'A list of dynamic fields that are merged into the main ticket during a merge operation. Only dynamic fields that are empty in the main ticket will be set.' =>
            'Unha lista de campos dinámicos que se combinan no tícket principal durante unha operación de combinación. Só se fixan os campos dinámicos que estean baleiros no tícket principal.',
        'A picture' => 'Unha imaxe',
        'ACL module that allows closing parent tickets only if all its children are already closed ("State" shows which states are not available for the parent ticket until all child tickets are closed).' =>
            'Módulo ACL que permite pechar tickets pais soamente se todos os seus fillos están xa pechados ("Estado" mostra que estados non están dispoñibles para o ticket pai ata que todos os tickets fillos están pechados).',
        'Access Control Lists (ACL)' => 'Listas de Control de Acceso (ACL)',
        'AccountedTime' => 'TempoContabilizado',
        'Activates a blinking mechanism of the queue that contains the oldest ticket.' =>
            'Activa un mecanismo da cola que pestanexa que contén o ticket máis antigo.',
        'Activates lost password feature for agents, in the agent interface.' =>
            'Activa a función de perda de contrasinal para axentes, na interface de axente.',
        'Activates lost password feature for customers.' => 'Activa a funcionalidade de contrasinais perdidos para o clientes.',
        'Activates support for customer and customer user groups.' => '',
        'Activates the article filter in the zoom view to specify which articles should be shown.' =>
            'Activa o filtro de artigo na vista zoom para especificar que artigos deberían ser mostrados.',
        'Activates the available themes on the system. Value 1 means active, 0 means inactive.' =>
            'Activa os temas dispoñibles no sistema. Valor 1 significa activo, 0 significa inactivo.',
        'Activates the ticket archive system search in the customer interface.' =>
            'Activa a busca no sistema de arquivo de tíckets na interface do cliente.',
        'Activates the ticket archive system to have a faster system by moving some tickets out of the daily scope. To search for these tickets, the archive flag has to be enabled in the ticket search.' =>
            'Activa o sistema de arquivo de ticket para ter un sistema máis rápido movendo algúns tickets fóra do alcance diario. Para buscar estes tickets, a bandeira de arquivo ten que estar permitida na busca de ticket.',
        'Activates time accounting.' => 'Activa contador de tempo.',
        'ActivityID' => 'ActividadeID',
        'Add a note to this ticket' => 'Engada unha nota a este Ticket',
        'Add an inbound phone call to this ticket' => '',
        'Add an outbound phone call to this ticket' => '',
        'Added %s time unit(s), for a total of %s time unit(s).' => '',
        'Added email. %s' => 'Engadiuse o correo electrónico. %s',
        'Added follow-up to ticket [%s]. %s' => '',
        'Added link to ticket "%s".' => 'Engadiuse a ligazón ao ticket «%s».',
        'Added note (%s).' => '',
        'Added phone call from customer.' => '',
        'Added phone call to customer.' => '',
        'Added subscription for user "%s".' => 'Engadiuse unha subscrición',
        'Added system request (%s).' => '',
        'Added web request from customer.' => '',
        'Adds a suffix with the actual year and month to the OTRS log file. A logfile for every month will be created.' =>
            'Engade un sufixo co ano e mes actuais ao arquivo OTRS log. Un logfile para cada mes será creado.',
        'Adds customers email addresses to recipients in the ticket compose screen of the agent interface. The customers email address won\'t be added if the article type is email-internal.' =>
            'Engade enderezos de correo de clientes aos destinatarios na pantalla de redacción de tíckets da interface do axente. Os enderezos de correo dos clientes non se engaden se o tipo de artigo é correo interno.',
        'Adds the one time vacation days for the indicated calendar.' => '',
        'Adds the one time vacation days.' => '',
        'Adds the permanent vacation days for the indicated calendar.' =>
            '',
        'Adds the permanent vacation days.' => '',
        'Admin' => 'Administración',
        'Admin Area.' => '',
        'Admin Notification' => 'Notificación Administrador',
        'Admin area navigation for the agent interface.' => '',
        'Admin modules overview.' => '',
        'Admin.' => '',
        'Administration' => 'Administración',
        'Agent Customer Search' => '',
        'Agent Customer Search.' => '',
        'Agent Name' => '',
        'Agent Name + FromSeparator + System Address Display Name' => '',
        'Agent Preferences.' => '',
        'Agent Statistics.' => '',
        'Agent User Search' => '',
        'Agent User Search.' => '',
        'Agent interface article notification module to check PGP.' => 'Módulo de notificación de artigo da interface de axente para comprobar PGP.',
        'Agent interface article notification module to check S/MIME.' =>
            'Módulo de notificación de artigo da interface de axente para comprobar S/MIME.',
        'Agent interface module to access CIC search via nav bar. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Agent interface module to access fulltext search via nav bar. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Agent interface module to access search profiles via nav bar. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Agent interface module to check incoming emails in the Ticket-Zoom-View if the S/MIME-key is available and true.' =>
            'Módulo da interface de axente para comprobar correos electrónicos entrantes na Vist-Ticket-Zoom se a chave  S/MIME está dispoñible e é verdadeira.',
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
        'All customer users of a CustomerID' => 'Todos os usuarios clientes dun identificador de cliente',
        'All escalated tickets' => 'Tódolos tickets escalados',
        'All new tickets, these tickets have not been worked on yet' => 'Tódolos novos tickets, nestes tickets aínda non se a estado traballando',
        'All open tickets, these tickets have already been worked on.' =>
            '',
        'All tickets with a reminder set where the reminder date has been reached' =>
            'Tólodos tickets cun recordatorio posto onde a data do recordatorio foi alcanzada',
        'Allows adding notes in the close ticket screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Permite engadir notas na pantalla de ticket pechado  da interface de axente. Pode ser sobrescribido por Ticket::Frontend::NeedAccountedTime.',
        'Allows adding notes in the ticket free text screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Permite engadir notas na pantalla de texto libre do ticket da interface de axente. Pode ser sobreescribido por Ticket::Frontend::NeedAccountedTime.',
        'Allows adding notes in the ticket note screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Permite engadir notas na pantalla de notas do ticket da interface de axente. Pode ser sobreescribido por Ticket::Frontend::NeedAccountedTime.',
        'Allows adding notes in the ticket owner screen of a zoomed ticket in the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Permite engadir notas na pantalla do propietario do ticket dun ticket con zoom da interface de axente. Pode ser sobreescribido por Ticket::Frontend::NeedAccountedTime.',
        'Allows adding notes in the ticket pending screen of a zoomed ticket in the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Permite engadir notas na pantalla de ticket pendente dun ticket con zoom da interface de axente. Pode ser sobreescribido por Ticket::Frontend::NeedAccountedTime.',
        'Allows adding notes in the ticket priority screen of a zoomed ticket in the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Permite engadir notas na pantalla de prioridade do ticket dun ticket con zoom da interface de axente. Pode ser sobreescribido por Ticket::Frontend::NeedAccountedTime.',
        'Allows adding notes in the ticket responsible screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Permite engadir notas na pantalla do responsable do ticket da interface de axente. Pode ser sobreescribido por Ticket::Frontend::NeedAccountedTime.',
        'Allows agents to exchange the axis of a stat if they generate one.' =>
            'Permite que os axentes intercambien o eixo dunha estatística se xeran unha.',
        'Allows agents to generate individual-related stats.' => 'Permite que os axentes xeren estatísticas relacionadas con individuos.',
        'Allows choosing between showing the attachments of a ticket in the browser (inline) or just make them downloadable (attachment).' =>
            'Permite escoller entre mostrar os adxuntos dun ticket no buscador (inline) ou só facelos descargables (adxuntos).',
        'Allows choosing the next compose state for customer tickets in the customer interface.' =>
            'Permite escoller o seguinte estado de redacción dos tíckets de cliente na interface do cliente.',
        'Allows customers to change the ticket priority in the customer interface.' =>
            'Permite que os clientes cambien a prioridade dos tíckets na interface do cliente.',
        'Allows customers to set the ticket SLA in the customer interface.' =>
            'Permite que os clientes indiquen o SLA dos tíckets na interface do cliente.',
        'Allows customers to set the ticket priority in the customer interface.' =>
            'Permite que os clientes indiquen a prioridade dos tíckets na interface do cliente.',
        'Allows customers to set the ticket queue in the customer interface. If this is not enabled, QueueDefault should be configured.' =>
            '',
        'Allows customers to set the ticket service in the customer interface.' =>
            'Permite que os clientes indiquen o servizo dos tíckets na interface do cliente.',
        'Allows customers to set the ticket type in the customer interface. If this is not enabled, TicketTypeDefault should be configured.' =>
            '',
        'Allows default services to be selected also for non existing customers.' =>
            'Permite que os servizos por omisión sexan seleccionados tamén para clientes non existentes.',
        'Allows defining services and SLAs for tickets (e. g. email, desktop, network, ...), and escalation attributes for SLAs (if ticket service/SLA feature is enabled).' =>
            'Permite a definición de servizos e ANSs para tickets (ex. email, desktop, rede...) e escalar atributos para os ANSs (se a función servizo de ticket/ANS está habilitada).',
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
            'Permite ter unha visión xeral de ticket de formato medio (CustomerInfo => 1 - mostra tamén a información de clientes).',
        'Allows having a small format ticket overview (CustomerInfo => 1 - shows also the customer information).' =>
            'Permite ter unha visión xeral de ticket de formato pequeno (CustomerInfo => 1 - mostra tamén a información de clientes).',
        'Allows invalid agents to generate individual-related stats.' => 'Permite que os axentes non correctos xeren estatísticas relacionadas con individuos.',
        'Allows the administrators to login as other customers, via the customer user administration panel.' =>
            'Permite que os administradores accedan como outros clientes a través do panel de administración dos usuarios clientes.',
        'Allows the administrators to login as other users, via the users administration panel.' =>
            'Permite que os administradores accedan como outros usuarios a través do panel de administración dos usuarios.',
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
            'Permite establecer un novo estado de ticket na pantalla de movemento do ticket da interface de axente.',
        'Always show RichText if available' => '',
        'Answer' => 'Resposta',
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
        'ArticleTree' => 'ÁrboreArtigos',
        'Attachment Name' => 'Nome do anexo',
        'Automated line break in text messages after x number of chars.' =>
            'Salto de liña automatizada en mensaxes de texto despois de x número de carácteres.',
        'Automatically change the state of a ticket with an invalid owner once it is unlocked. Maps from a state type to a new ticket state.' =>
            '',
        'Automatically lock and set owner to current Agent after opening the move ticket screen of the agent interface.' =>
            'Automaticamente bloqueado e establecido o propietario ao Axente actual despois de abrir a pantalla de movemento de ticket da interface de axente.',
        'Automatically lock and set owner to current Agent after selecting for an Bulk Action.' =>
            'Automaticamente bloqueado e establecido o propietario ao Axente actual despois de seleccionar unha Acción Masiva.',
        'Automatically sets the owner of a ticket as the responsible for it (if ticket responsible feature is enabled). This will only work by manually actions of the logged in user. It does not work for automated actions e.g. GenericAgent, Postmaster and GenericInterface.' =>
            '',
        'Automatically sets the responsible of a ticket (if it is not set yet) after the first owner update.' =>
            'Establece automaticamente o responsable do ticket (se non está establecido ainda) despois da actualización do primeiro propietario.',
        'Avatar' => '',
        'Balanced white skin by Felix Niklas (slim version).' => 'Apariencia blanca equilibrada por Felix Niklas (version slim).',
        'Balanced white skin by Felix Niklas.' => 'Apariencia blanca equilibrada por Felix Niklas ',
        'Based on global RichText setting' => '',
        'Basic fulltext index settings. Execute "bin/otrs.Console.pl Maint::Ticket::FulltextIndex --rebuild" in order to generate a new index.' =>
            '',
        'Blocks all the incoming emails that do not have a valid ticket number in subject with From: @example.com address.' =>
            'Bloquea tódolos correos electrónicos entrantes que non teñen un número de ticket válido no tema con De: Enderezo de @example.com.',
        'Bounced to "%s".' => 'Rebotado para «%s».',
        'Bulgarian' => '',
        'Bulk Action' => 'Acción en masa',
        'CMD example setup. Ignores emails where external CMD returns some output on STDOUT (email will be piped into STDIN of some.bin).' =>
            'Montaxe exemplo CMD. Ignora os correos electrónicos onde unha CMD externa retorna nun STDOUT (correo será canalizado en STDIN de some.bin).',
        'CSV Separator' => 'Separador de CSV',
        'Cache time in seconds for agent authentication in the GenericInterface.' =>
            'Tempo cache en segundos para á autenticación de axente na InterfaceXenérica.',
        'Cache time in seconds for customer authentication in the GenericInterface.' =>
            'Tempo cache en segundos para á autenticación de cliente na InterfaceXenérica.',
        'Cache time in seconds for the DB ACL backend.' => 'Tempo cache en segundos para ó backend BD ACL.',
        'Cache time in seconds for the DB process backend.' => 'Tempo cache en segundos para ó proceso backend da BD.',
        'Cache time in seconds for the SSL certificate attributes.' => 'Tempo cache en segundos para os atributos de certificado SSL.',
        'Cache time in seconds for the ticket process navigation bar output module.' =>
            'Tempo cache en segundos para ó modulo de saída da barra de navegación do proceso de ticket.',
        'Cache time in seconds for the web service config backend.' => 'Tempo cache en segundos para á configuración backend do servizo web.',
        'Calendar manage screen.' => '',
        'Catalan' => '',
        'Change password' => 'Cambiar o contrasinal',
        'Change queue!' => 'Cambiar a fila!',
        'Change the customer for this ticket' => 'Cambiar o cliente deste tícket.',
        'Change the free fields for this ticket' => 'Cambie os campos libres deste tícket',
        'Change the owner for this ticket' => 'Cambie o propietario deste Ticket',
        'Change the priority for this ticket' => 'Cambie a prioridade para este ticket',
        'Change the responsible for this ticket' => '',
        'Change your avatar image.' => '',
        'Change your password and more.' => '',
        'Changed SLA to "%s" (%s).' => '',
        'Changed archive state to "%s".' => '',
        'Changed customer to "%s".' => '',
        'Changed dynamic field %s from "%s" to "%s".' => '',
        'Changed owner to "%s" (%s).' => '',
        'Changed pending time to "%s".' => '',
        'Changed priority from "%s" (%s) to "%s" (%s).' => 'Prioridade cambiada de "%s" (%s) a "%s" (%s).',
        'Changed queue to "%s" (%s) from "%s" (%s).' => '',
        'Changed responsible to "%s" (%s).' => '',
        'Changed service to "%s" (%s).' => '',
        'Changed state from "%s" to "%s".' => '',
        'Changed title from "%s" to "%s".' => '',
        'Changed type from "%s" (%s) to "%s" (%s).' => '',
        'Changes the owner of tickets to everyone (useful for ASP). Normally only agent with rw permissions in the queue of the ticket will be shown.' =>
            'Cambiar propietario de tickets a todos (útil para ASP). Normalmente só o axente con permisos rw na cola do ticket vai ser mostrado.',
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
        'Child' => 'Fillo',
        'Chinese (Simplified)' => '',
        'Chinese (Traditional)' => '',
        'Choose for which kind of appointment changes you want to receive notifications.' =>
            '',
        'Choose for which kind of ticket changes you want to receive notifications. Please note that you can\'t completely disable notifications marked as mandatory.' =>
            '',
        'Choose which notifications you\'d like to receive.' => '',
        'Christmas Eve' => 'Noiteboa',
        'Close' => 'Pechar',
        'Close this ticket' => 'Pechar este tícket',
        'Closed tickets (customer user)' => 'Tíckets pechados (usuario cliente)',
        'Closed tickets (customer)' => 'Tíckets pechados (cliente)',
        'Cloud Services' => '',
        'Cloud service admin module registration for the transport layer.' =>
            '',
        'Collect support data for asynchronous plug-in modules.' => '',
        'Column ticket filters for Ticket Overviews type "Small".' => 'Filtro de columna de ticket para Vista Xeral de Ticket tipo "Pequeno".',
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
        'Comment for new history entries in the customer interface.' => 'Comentario para as entradas novas do historial na interface do cliente.',
        'Comment2' => 'Comentario2',
        'Communication' => '',
        'Communication & Notifications' => '',
        'Communication Log GUI' => '',
        'Communication log limit per page for Communication Log Overview.' =>
            '',
        'CommunicationLog Overview Limit' => '',
        'Company Status' => 'Estado da empresa',
        'Company Tickets.' => '',
        'Company name which will be included in outgoing emails as an X-Header.' =>
            'O nome da empresa que se inclúe no correo saínte como X-Header.',
        'Compat module for AgentZoom to AgentTicketZoom.' => '',
        'Complex' => '',
        'Compose' => 'Redactar',
        'Configure Processes.' => 'Configure Procesos.',
        'Configure and manage ACLs.' => 'Configurar e xestionar as ACL.',
        'Configure any additional readonly mirror databases that you want to use.' =>
            '',
        'Configure sending of support data to OTRS Group for improved support.' =>
            '',
        'Configure which screen should be shown after a new ticket has been created.' =>
            '',
        'Configure your own log text for PGP.' => 'Configure o seu propio texto de log para PGP.',
        'Configures a default TicketDynamicField setting. "Name" defines the dynamic field which should be used, "Value" is the data that will be set, and "Event" defines the trigger event. Please check the developer manual (https://doc.otrs.com/doc/), chapter "Ticket Event Module".' =>
            '',
        'Controls how to display the ticket history entries as readable values.' =>
            'Controla cómo mostrar o historial do ticket coma valores lexibles.',
        'Controls if CustomerID is automatically copied from the sender address for unknown customers.' =>
            '',
        'Controls if CustomerID is read-only in the agent interface.' => '',
        'Controls if customers have the ability to sort their tickets.' =>
            'Controla se os clientes teñen a capacidade de ordenar os seus tíckets.',
        'Controls if more than one from entry can be set in the new phone ticket in the agent interface.' =>
            'Controla se máis dunha das entradas pode ser establecida no novo ticket telefónico na interface de axente.',
        'Controls if the admin is allowed to import a saved system configuration in SysConfig.' =>
            'Controla se se permite ao administrador importar unha configuración do sistema gardada en SysConfig.',
        'Controls if the admin is allowed to make changes to the database via AdminSelectBox.' =>
            'Controla se se permite ao administradorfacer cambios na base de datos vía AdminSelectBox.',
        'Controls if the autocomplete field will be used for the customer ID selection in the AdminCustomerUser interface.' =>
            '',
        'Controls if the ticket and article seen flags are removed when a ticket is archived.' =>
            'Controla se as bandeiras vistas de ticket e artigo son eliminadas cando un ticket é arquivado',
        'Converts HTML mails into text messages.' => 'Convirte correos HTML en mensaxes de texto.',
        'Create New process ticket.' => '',
        'Create Ticket' => '',
        'Create a new calendar appointment linked to this ticket' => '',
        'Create and manage Service Level Agreements (SLAs).' => 'Crear e xestionar Acordos de Nivel de Servizo (SLA).',
        'Create and manage agents.' => 'Cree é xestione axentes.',
        'Create and manage appointment notifications.' => '',
        'Create and manage attachments.' => 'Cree e xestione adxuntos.',
        'Create and manage calendars.' => '',
        'Create and manage customer users.' => 'Cree e xestione usuarios.',
        'Create and manage customers.' => 'Crear e xestionar clientes.',
        'Create and manage dynamic fields.' => 'Cree e xestione campos dinámicos.',
        'Create and manage groups.' => 'Cree e xestione grupos.',
        'Create and manage queues.' => 'Cree e xestione colas.',
        'Create and manage responses that are automatically sent.' => 'Cree e xestione respostas que son enviadas automáticamente.',
        'Create and manage roles.' => 'Crear e xestionar papeis.',
        'Create and manage salutations.' => 'Crear e xestionar saúdos.',
        'Create and manage services.' => 'Crear e xestionar servizos.',
        'Create and manage signatures.' => 'Crear e xestionar papeis sinaturas.',
        'Create and manage templates.' => 'Crear e xestionar modelos.',
        'Create and manage ticket notifications.' => '',
        'Create and manage ticket priorities.' => 'Cree e xestione prioridades de ticket.',
        'Create and manage ticket states.' => 'Cree e xestione estados de ticket.',
        'Create and manage ticket types.' => 'Cree e xestione tipos de ticket.',
        'Create and manage web services.' => 'Crear e xestionar servizos web.',
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
        'Custom RSS Feed' => 'Custom RSS Feed',
        'Custom RSS feed.' => '',
        'Custom text for the page shown to customers that have no tickets yet (if you need those text translated add them to a custom translation module).' =>
            'Texto personalizada para a páxina que se lles mostra aos clientes que aínda non teñen tíckets (se precisa traducir eses textos, engádaos a un módulo de tradución personalizada).',
        'Customer Administration' => 'Administración de clientes',
        'Customer Companies' => 'Empresas do cliente',
        'Customer IDs' => '',
        'Customer Information Center Search.' => '',
        'Customer Information Center search.' => '',
        'Customer Information Center.' => '',
        'Customer Ticket Print Module.' => '',
        'Customer User Administration' => 'Administración de usuarios clientes',
        'Customer User Information' => '',
        'Customer User Information Center Search.' => '',
        'Customer User Information Center search.' => '',
        'Customer User Information Center.' => '',
        'Customer Users ↔ Customers' => '',
        'Customer Users ↔ Groups' => '',
        'Customer Users ↔ Services' => '',
        'Customer item (icon) which shows the closed tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            'Elemento de cliente (icono) o cal mostra os tickets pechados deste cliente coma un bloque de información. Establecendo CustomerUserLogin a 1 busca por tickets baseado no nome do login en lugar de IDCliente. ',
        'Customer item (icon) which shows the open tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            'Elemento de cliente (icono) o cal mostra os tickets abertos deste cliente coma un bloque de información. Establecendo CustomerUserLogin a 1 busca por tickets baseado no nome do login en lugar de IDCliente. ',
        'Customer preferences.' => '',
        'Customer ticket overview' => '',
        'Customer ticket search.' => '',
        'Customer ticket zoom' => '',
        'Customer user search' => 'Busca de usuarios clientes',
        'CustomerID search' => 'Busca por identificador de cliente',
        'CustomerName' => 'NomeCliente',
        'CustomerUser' => '',
        'Customers ↔ Groups' => '',
        'Customizable stop words for fulltext index. These words will be removed from the search index.' =>
            '',
        'Czech' => '',
        'Danish' => '',
        'Dashboard overview.' => '',
        'Data used to export the search result in CSV format.' => 'Datos utilizados para exportar os resultados da busca en formato CSV.',
        'Date / Time' => 'Data / hora',
        'Default (Slim)' => '',
        'Default ACL values for ticket actions.' => 'Valores ACL por defecto para as accións de ticket.',
        'Default ProcessManagement entity prefixes for entity IDs that are automatically generated.' =>
            'Prefixos da entidade XestiónProceso por defecto para IDs entidades que son automaticamente xeradas.',
        'Default agent name' => '',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimePointFormat=year;TicketCreateTimePointStart=Last;TicketCreateTimePoint=2;".' =>
            'Datos por defecto para usar no atributo para a pantalla busca de ticket. Exemplo: "TicketCreateTimePointFormat=year;TicketCreateTimePointStart=Last;TicketCreateTimePoint=2;".',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimeStartYear=2010;TicketCreateTimeStartMonth=10;TicketCreateTimeStartDay=4;TicketCreateTimeStopYear=2010;TicketCreateTimeStopMonth=11;TicketCreateTimeStopDay=3;".' =>
            'Datos por defecto para usar no atributo para a pantalla busca de ticket. Exemplo: "TicketCreateTimeStartYear=2010;TicketCreateTimeStartMonth=10;TicketCreateTimeStartDay=4;TicketCreateTimeStopYear=2010;TicketCreateTimeStopMonth=11;TicketCreateTimeStopDay=3;".',
        'Default display type for recipient (To,Cc) names in AgentTicketZoom and CustomerTicketZoom.' =>
            '',
        'Default display type for sender (From) names in AgentTicketZoom and CustomerTicketZoom.' =>
            '',
        'Default loop protection module.' => 'Módulo de protección de bucle por defecto.',
        'Default queue ID used by the system in the agent interface.' => 'ID de cola por defecto utilizada polo sistema na interface de axente.',
        'Default skin for the agent interface (slim version).' => 'Aparencia predeterminada da interface do axente (versión lixeira).',
        'Default skin for the agent interface.' => 'Aparencia predeterminada da interface do axente.',
        'Default skin for the customer interface.' => '',
        'Default ticket ID used by the system in the agent interface.' =>
            'ID de ticket por defecto utilizado polo sistema na interface de axente.',
        'Default ticket ID used by the system in the customer interface.' =>
            'ID de ticket por defecto utilizado polo sistema na interface de cliente.',
        'Default value for NameX' => 'Valor por defecto para NomeX',
        'Define Actions where a settings button is available in the linked objects widget (LinkObject::ViewMode = "complex"). Please note that these Actions must have registered the following JS and CSS files: Core.AllocationList.css, Core.UI.AllocationList.js, Core.UI.Table.Sort.js, Core.Agent.TableFilters.js.' =>
            '',
        'Define a filter for html output to add links behind a defined string. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Define un filtro para que a saída de html engada enlaces detrás dun string definido. A Imaxe do elemento permite dous tipos de entrada. Ao mesmo tempo o nome dunha imaxe (p.ej. faq.png). Neste caso a ruta da imaxe de OTRS será utilizada. A segunda posiblidade é introducir o enlace á imaxe.',
        'Define a mapping between variables of the customer user data (keys) and dynamic fields of a ticket (values). The purpose is to store customer user data in ticket dynamic fields. The dynamic fields must be present in the system and should be enabled for AgentTicketFreeText, so that they can be set/updated manually by the agent. They mustn\'t be enabled for AgentTicketPhone, AgentTicketEmail and AgentTicketCustomer. If they were, they would have precedence over the automatically set values. To use this mapping, you have to also activate the Ticket::EventModulePost###4100-DynamicFieldFromCustomerUser setting.' =>
            '',
        'Define dynamic field name for end time. This field has to be manually added to the system as Ticket: "Date / Time" and must be activated in ticket creation screens and/or in any other ticket action screens.' =>
            'Defina nome de campo dinámico para tempo de fin. Este campo ten que ser manualmente engadido ao sistema como Ticket: "Data / Tempo" e debe ser activado en pantallas de creación de ticket e/ou en calquera outras pantallas de acción de ticket.',
        'Define dynamic field name for start time. This field has to be manually added to the system as Ticket: "Date / Time" and must be activated in ticket creation screens and/or in any other ticket action screens.' =>
            'Defina nome de campo dinámico para tempo de comezo. Este campo ten que ser manualmente engadido ao sistema como Ticket: "Data / Tempo" e debe ser activado en pantallas de creación de ticket e/ou en calquera outras pantallas de acción de ticket.',
        'Define the max depth of queues.' => 'Defina a máx profundidade das colas.',
        'Define the queue comment 2.' => 'Defina o comentario de cola 2.',
        'Define the service comment 2.' => 'Defina o comentario de servizo 2.',
        'Define the sla comment 2.' => 'Defina o comentario de ANS 2.',
        'Define the start day of the week for the date picker for the indicated calendar.' =>
            'Defina o día de comezo da semana para o selector de datas para o calendario indicado.',
        'Define the start day of the week for the date picker.' => 'Defina o día de comezo da semana para o selector de datas.',
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
            'Defina un elemento de cliente, o cal vai xerar un icono de LinkedIn ao final do bloque de información do cliente.',
        'Defines a customer item, which generates a XING icon at the end of a customer info block.' =>
            'Defina un elemento de cliente, o cal vai xerar un icono de XING ao final do bloque de información do cliente.',
        'Defines a customer item, which generates a google icon at the end of a customer info block.' =>
            'Defina un elemento de cliente, o cal vai xerar un icono de google ao final do bloque de información do cliente.',
        'Defines a customer item, which generates a google maps icon at the end of a customer info block.' =>
            'Defina un elemento de cliente, o cal vai xerar un icono de google maps ao final do bloque de información do cliente.',
        'Defines a filter for html output to add links behind CVE numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Define un filtro para a saída de html que engada enlaces detrás dos números CVE. A Imaxe de elemento permite dous tipos de entrada. Á vez o nome dunha imaxe (p.ex. faq.png). Neste caso a ruta de imaxe de OTRS será utilizada. A segunda posibilidade é introducir o enlace á imaxe.',
        'Defines a filter for html output to add links behind MSBulletin numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Define un filtro para a saída de html que engada enlaces detrás dos números MSBulletin. A Imaxe de elemento permite dous tipos de entrada. Á vez o nome dunha imaxe (p.ex. faq.png). Neste caso a ruta de imaxe de OTRS será utilizada. A segunda posibilidade é introducir o enlace á imaxe.',
        'Defines a filter for html output to add links behind a defined string. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Define un filtro para a saída de html que engada enlaces detrás dun string definido. A Imaxe de elemento permite dous tipos de entrada. Á vez o nome dunha imaxe (p.ex. faq.png). Neste caso a ruta de imaxe de OTRS será utilizada. A segunda posibilidade é introducir o enlace á imaxe.',
        'Defines a filter for html output to add links behind bugtraq numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Define un filtro para a saída de html que engada enlaces detrás dos números bugtraq. A Imaxe de elemento permite dous tipos de entrada. Á vez o nome dunha imaxe (p.ex. faq.png). Neste caso a ruta de imaxe de OTRS será utilizada. A segunda posibilidade é introducir o enlace á imaxe.',
        'Defines a filter to collect CVE numbers from article texts in AgentTicketZoom. The results will be displayed in a meta box next to the article. Fill in URLPreview if you would like to see a preview when moving your mouse cursor above the link element. This could be the same URL as in URL, but also an alternate one. Please note that some websites deny being displayed within an iframe (e.g. Google) and thus won\'t work with the preview mode.' =>
            '',
        'Defines a filter to process the text in the articles, in order to highlight predefined keywords.' =>
            'Define un filtro para procesar o texto nos artigos, para subliñar palabras clave predefinidas.',
        'Defines a permission context for customer to group assignment.' =>
            '',
        'Defines a regular expression that excludes some addresses from the syntax check (if "CheckEmailAddresses" is set to "Yes"). Please enter a regex in this field for email addresses, that aren\'t syntactically valid, but are necessary for the system (i.e. "root@localhost").' =>
            'Define unha expresión regular que exclúe algunos enderezos da comprobación da sintaxe (se "CheckEmailAddresses" está establecido a "Si"). Por favor introduzca unha expreg neste campo para enderezos de correo electrónico, que noon señan sintacticamente validos, pero necesarios para o sistema (ex. "root@localhost").',
        'Defines a regular expression that filters all email addresses that should not be used in the application.' =>
            'Define unha expresión regular que filtre tódolos enderezos de correo electrónico que non deben ser usados na aplicación.',
        'Defines a sleep time in microseconds between tickets while they are been processed by a job.' =>
            '',
        'Defines a useful module to load specific user options or to display news.' =>
            'Define un módulo útil para cargar opcións de usuario específicas ou mostrar noticias.',
        'Defines all the X-headers that should be scanned.' => 'Define tódalas cabeceiras-X que deben ser escaneadas.',
        'Defines all the languages that are available to the application. Specify only English names of languages here.' =>
            '',
        'Defines all the languages that are available to the application. Specify only native names of languages here.' =>
            '',
        'Defines all the parameters for the RefreshTime object in the customer preferences of the customer interface.' =>
            'Define tódolos parámetros para o obxecto RefreshTime nas preferencias de cliente da interface de cliente.',
        'Defines all the parameters for the ShownTickets object in the customer preferences of the customer interface.' =>
            'Define tódolos parámetros para o obxecto MostrarTickets nas preferencias de cliente da interface de cliente.',
        'Defines all the parameters for this item in the customer preferences.' =>
            'Define tódolos parámetros para este elemento nas preferencias de cliente.',
        'Defines all the parameters for this item in the customer preferences. \'PasswordRegExp\' allows to match passwords against a regular expression. Define the minimum number of characters using \'PasswordMinSize\'. Define if at least 2 lowercase and 2 uppercase letter characters are needed by setting the appropriate option to \'1\'. \'PasswordMin2Characters\' defines if the password needs to contain at least 2 letter characters (set to 0 or 1). \'PasswordNeedDigit\' controls the need of at least 1 digit (set to 0 or 1 to control).' =>
            '',
        'Defines all the parameters for this notification transport.' => '',
        'Defines all the possible stats output formats.' => 'Define tódolos posibles formatos de saída de estatísticas.',
        'Defines an alternate URL, where the login link refers to.' => 'Define unha URL alternativa, onde o enlace login se refire.',
        'Defines an alternate URL, where the logout link refers to.' => 'Define unha URL alternativa, onde o enlace logout se refire.',
        'Defines an alternate login URL for the customer panel..' => 'Define unha URL alternativa de login para o panel de cliente..',
        'Defines an alternate logout URL for the customer panel.' => 'Define unha URL alternativa de logout para o panel de cliente.',
        'Defines an external link to the database of the customer (e.g. \'http://yourhost/customer.php?CID=[% Data.CustomerID %]\' or \'\').' =>
            'Define un enlace externo á base de datos do cliente (ex. \'http://yourhost/customer.php?CID=[% Data.CustomerID %]\' or \'\').',
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
            'Define de que atributtos de ticket o axente pode seleccionara orde de resultado.',
        'Defines groups for preferences items.' => '',
        'Defines how many deployments the system should keep.' => '',
        'Defines how the From field from the emails (sent from answers and email tickets) should look like.' =>
            'Define como o campo De dos emails (enviados dende respostas e tickets de email) debe semellarse a.',
        'Defines if a pre-sorting by priority should be done in the queue view.' =>
            'Define se unha pre-ordenación por prioridades debe ser feita na vista de cola.',
        'Defines if a pre-sorting by priority should be done in the service view.' =>
            'Define se unha pre-ordenación por prioridades debe ser feita na vista de servizo.',
        'Defines if a ticket lock is required in the close ticket screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Define se un bloqueo de ticket é requirido na pantalla de peche de ticket da interface de axente (se o ticket aínda non está bloqueado, o ticket bloquéase e o axente actual vai ser automaticamente o seu propietario).',
        'Defines if a ticket lock is required in the email outbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Define se un bloqueo de ticket é requirido na pantalla de saída de email da interface de axente (se o ticket aínda non está bloqueado, o ticket bloquéase e o axente actual vai ser automaticamente o seu propietario).',
        'Defines if a ticket lock is required in the email resend screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket bounce screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Define se se require un bloqueo de tícket na pantalla de rebote de tíckets da interface do axente (se o tícket non está bloqueado aínda, o tícket bloquéase e o axente actual resulta ser automaticamente o seu dono).',
        'Defines if a ticket lock is required in the ticket compose screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Define se un bloqueo de ticket é requirido na pantalla composta de ticket da interface de axente (se o ticket aínda non está bloqueado, o ticket bloquéase e o axente actual vai ser automaticamente o seu propietario).',
        'Defines if a ticket lock is required in the ticket forward screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Define se un bloqueo de ticket é requirido na pantalla dianteira de ticket da interface de axente (se o ticket aínda non está bloqueado, o ticket bloquéase e o axente actual vai ser automaticamente o seu propietario).',
        'Defines if a ticket lock is required in the ticket free text screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Define se un bloqueo de ticket é requirido na pantalla texto libre de ticket da interface de axente (se o ticket aínda non está bloqueado, o ticket bloquéase e o axente actual vai ser automaticamente o seu propietario).',
        'Defines if a ticket lock is required in the ticket merge screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Define se un bloqueo de ticket é requirido na pantalla emerxente de ticket dun zoom ticket da interface de axente (se o ticket aínda non está bloqueado, o ticket bloquéase e o axente actual vai ser automaticamente o seu propietario).',
        'Defines if a ticket lock is required in the ticket note screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Define se un bloqueo de ticket é requirido na pantalla notas de ticket da interface de axente (se o ticket aínda non está bloqueado, o ticket bloquéase e o axente actual vai ser automaticamente o seu propietario).',
        'Defines if a ticket lock is required in the ticket owner screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Define se un bloqueo de ticket é requirido na pantalla propietario de ticket dun ticket zoom da interface de axente (se o ticket aínda non está bloqueado, o ticket bloquéase e o axente actual vai ser automaticamente o seu propietario).',
        'Defines if a ticket lock is required in the ticket pending screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Define se un bloqueo de ticket é requirido na pantalla pendente de ticket dun ticket zoom da interface de axente (se o ticket aínda non está bloqueado, o ticket bloquéase e o axente actual vai ser automaticamente o seu propietario).',
        'Defines if a ticket lock is required in the ticket phone inbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Define se un bloqueo de ticket é requirido na pantalla ticket de chamada entrante da interface de axente (se o ticket aínda non está bloqueado, o ticket bloquéase e o axente actual vai ser automaticamente o seu propietario).',
        'Defines if a ticket lock is required in the ticket phone outbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Define se un bloqueo de ticket é requirido na pantalla ticket de chamada saínte da interface de axente (se o ticket aínda non está bloqueado, o ticket bloquéase e o axente actual vai ser automaticamente o seu propietario).',
        'Defines if a ticket lock is required in the ticket priority screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Define se un bloqueo de ticket é requirido na pantalla prioridade  de ticket nun ticket zoom da interface de axente (se o ticket aínda non está bloqueado, o ticket bloquéase e o axente actual vai ser automaticamente o seu propietario).',
        'Defines if a ticket lock is required in the ticket responsible screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Define se un bloqueo de ticket é requirido na pantalla responsable de ticket da interface de axente (se o ticket aínda non está bloqueado, o ticket bloquéase e o axente actual vai ser automaticamente o seu propietario).',
        'Defines if a ticket lock is required to change the customer of a ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Define se un bloqueo de ticket é requirido para cambiar ó cliente dun tiocket na interface de axente (se o ticket aínda non está bloqueado, o ticket bloquéase e o axente actual vai ser automaticamente o seu propietario).',
        'Defines if agents should be allowed to login if they have no shared secret stored in their preferences and therefore are not using two-factor authentication.' =>
            '',
        'Defines if customers should be allowed to login if they have no shared secret stored in their preferences and therefore are not using two-factor authentication.' =>
            '',
        'Defines if the communication between this system and OTRS Group servers that provide cloud services is possible. If set to \'Disable cloud services\', some functionality will be lost such as system registration, support data sending, upgrading to and use of OTRS Business Solution™, OTRS Verify™, OTRS News and product News dashboard widgets, among others.' =>
            '',
        'Defines if the enhanced mode should be used (enables use of table, replace, subscript, superscript, paste from word, etc.) in customer interface.' =>
            '',
        'Defines if the enhanced mode should be used (enables use of table, replace, subscript, superscript, paste from word, etc.).' =>
            'Define se o modo realzado debería ser utilizado (permite uso de mesa, substituír, subscript, superscript, pegar dende palabra, etc).',
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
            'Define se contabilizar o tempo debe ser establecido a tódolos tickets nunha acción masiva.',
        'Defines internal communication channel.' => '',
        'Defines out of office message template. Two string parameters (%s) available: end date and number of days left.' =>
            '',
        'Defines phone communication channel.' => '',
        'Defines queues that\'s tickets are used for displaying as calendar events.' =>
            'Define as colas nas que os tickets son usados para mostrar como eventos de calendario.',
        'Defines the HTTP hostname for the support data collection with the public module \'PublicSupportDataCollector\' (e.g. used from the OTRS Daemon).' =>
            '',
        'Defines the IP regular expression for accessing the local repository. You need to enable this to have access to your local repository and the package::RepositoryList is required on the remote host.' =>
            'Define a expresión regular do IP para acceder ao repositorio local. Haino que activar para ter acceso completo ao repositorio local e o servidor remoto ten que ter package::RepositoryList.',
        'Defines the PostMaster header to be used on the filter for keeping the current state of the ticket.' =>
            '',
        'Defines the URL CSS path.' => 'Define a ruta CSS URL',
        'Defines the URL base path of icons, CSS and Java Script.' => 'Define a ruta base URL para iconos, CSS e JavaScript.',
        'Defines the URL image path of icons for navigation.' => 'Define a ruta de imaxenes  URL para os iconos de navegación.',
        'Defines the URL java script path.' => 'Define a ruta java script URL',
        'Defines the URL rich text editor path.' => 'Define a ruta de texto enriquecido URL',
        'Defines the address of a dedicated DNS server, if necessary, for the "CheckMXRecord" look-ups.' =>
            'Define o enderezo do servidor dedicado DNS, se é necesario, para consultas "CheckMXRecord".',
        'Defines the agent preferences key where the shared secret key is stored.' =>
            '',
        'Defines the available steps in time selections. Select "Minute" to be able to select all minutes of one hour from 1-59. Select "30 Minutes" to only make full and half hours available.' =>
            '',
        'Defines the body text for notification mails sent to agents, about new password.' =>
            '',
        'Defines the body text for notification mails sent to agents, with token about new requested password.' =>
            '',
        'Defines the body text for notification mails sent to customers, about new account.' =>
            'Define o texto de corpo para correos de notificación enviados a clientes, sobre nova conta.',
        'Defines the body text for notification mails sent to customers, about new password.' =>
            '',
        'Defines the body text for notification mails sent to customers, with token about new requested password.' =>
            '',
        'Defines the body text for rejected emails.' => 'Define o texto do corpo para correos rexeitados.',
        'Defines the calendar width in percent. Default is 95%.' => 'Define a anchura de calendario en porcentaxe. Defecto é un 95%.',
        'Defines the column to store the keys for the preferences table.' =>
            'Define a columna para almacenar as chaves para a táboa de preferencias.',
        'Defines the config options for the autocompletion feature.' => 'Define as opcións de configuración da función autocompletar.',
        'Defines the config parameters of this item, to be shown in the preferences view.' =>
            'Define os parámetros de configuración deste elemento, para ser mostrado na vista de preferencias.',
        'Defines the config parameters of this item, to be shown in the preferences view. \'PasswordRegExp\' allows to match passwords against a regular expression. Define the minimum number of characters using \'PasswordMinSize\'. Define if at least 2 lowercase and 2 uppercase letter characters are needed by setting the appropriate option to \'1\'. \'PasswordMin2Characters\' defines if the password needs to contain at least 2 letter characters (set to 0 or 1). \'PasswordNeedDigit\' controls the need of at least 1 digit (set to 0 or 1 to control). \'PasswordMaxLoginFailed\' allows to set an agent to invalid-temporarily if max failed logins reached. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Defines the config parameters of this item, to be shown in the preferences view. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Defines the connections for http/ftp, via a proxy.' => 'Define as conexións para http/ftp, mediante un proxy.',
        'Defines the customer preferences key where the shared secret key is stored.' =>
            '',
        'Defines the date input format used in forms (option or input fields).' =>
            'Define o formato de entrada de datos utilizado en formularios (campos de opción ou entrada).',
        'Defines the default CSS used in rich text editors.' => 'Define o CSS utilizado por defecto en editores de texto enriquecido.',
        'Defines the default agent name in the ticket zoom view of the customer interface.' =>
            '',
        'Defines the default auto response type of the article for this operation.' =>
            'Define o tipo de resposta automatica por defecto do artigo para esta operación.',
        'Defines the default body of a note in the ticket free text screen of the agent interface.' =>
            'Define o corpo por defecto dunha nota na pantalla de texto libre do ticket da interface de axente.',
        'Defines the default filter fields in the customer user address book search (CustomerUser or CustomerCompany). For the CustomerCompany fields a prefix \'CustomerCompany_\' must be added.' =>
            '',
        'Defines the default front-end (HTML) theme to be used by the agents and customers. If you like, you can add your own theme. Please refer the administrator manual located at https://doc.otrs.com/doc/.' =>
            '',
        'Defines the default front-end language. All the possible values are determined by the available language files on the system (see the next setting).' =>
            'Define o idioma do front-end por defecto. Tódolos posibles valores son determinados polos arquivos de idioma dispoñibles no sistema (vexa o axuste seguinte).',
        'Defines the default history type in the customer interface.' => 'Define o tipo de historico por defecto na interface de cliente.',
        'Defines the default maximum number of X-axis attributes for the time scale.' =>
            'Define a máxima cantidade de atributos do eixo-X por defecto para a escala de tempo.',
        'Defines the default maximum number of statistics per page on the overview screen.' =>
            '',
        'Defines the default next state for a ticket after customer follow-up in the customer interface.' =>
            '',
        'Defines the default next state of a ticket after adding a note, in the close ticket screen of the agent interface.' =>
            'Define por defecto o próximo estado dun ticket despois de engadir unha nota, na pantalla de peche de ticket da interface de axente.',
        'Defines the default next state of a ticket after adding a note, in the ticket free text screen of the agent interface.' =>
            'Define ó próximo estado por defecto dun ticket despois de engadir unha nota, na pantalla de texto libre de ticket da interface de axente.',
        'Defines the default next state of a ticket after adding a note, in the ticket note screen of the agent interface.' =>
            'Define ó próximo estado por defecto dun ticket despois de engadir unha nota, na pantalla nota de ticket da interface de axente.',
        'Defines the default next state of a ticket after adding a note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Define por defecto ó próximo estado dun ticket despois de engadir unha nota, na pantalla propietario de ticket dun ticket zoom da interface de axente.',
        'Defines the default next state of a ticket after adding a note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Define por defecto ó próximo estado dun ticket despois de engadir unha nota, na pantalla pendente de ticket dun ticket zoom da interface de axente.',
        'Defines the default next state of a ticket after adding a note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Define por defecto ó próximo estado dun ticket despois de engadir unha nota, na pantalla prioridade de ticket dun ticket zoom da interface de axente.',
        'Defines the default next state of a ticket after adding a note, in the ticket responsible screen of the agent interface.' =>
            'Define por defecto ó próximo estado dun ticket despois de engadir unha nota, na pantalla responsable de ticket da interface de axente.',
        'Defines the default next state of a ticket after being bounced, in the ticket bounce screen of the agent interface.' =>
            'Define o estado seguinte predeterminado dun tícket cando este é rebotado, na pantalla de encamiñamento de tíckets da interface do axente.',
        'Defines the default next state of a ticket after being forwarded, in the ticket forward screen of the agent interface.' =>
            'Define por defecto ó próximo estado dun ticket despois de ser enviado, na pantalla enviar ticket da interface de axente.',
        'Defines the default next state of a ticket after the message has been sent, in the email outbound screen of the agent interface.' =>
            'Define por defecto ó próximo estado dun ticket despois de que unha mensaxe fora enviada, na pantalla email de saída da interface de axente.',
        'Defines the default next state of a ticket if it is composed / answered in the ticket compose screen of the agent interface.' =>
            'Define por defecto ó próximo estado dun ticket se é composto / contestado na pantalla composición ticket da interface de axente.',
        'Defines the default next state of a ticket, in the ticket bulk screen of the agent interface.' =>
            '',
        'Defines the default note body text for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            'Define por defecto ó texto do corpo da nota para tickets telefónicos na pantalla ticket chamada entrante da interface de axente.',
        'Defines the default note body text for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            'Define por defecto ó texto do corpo da nota para tickets telefónicos na pantalla ticket chamada saínte da interface de axente.',
        'Defines the default priority of follow-up customer tickets in the ticket zoom screen in the customer interface.' =>
            '',
        'Defines the default priority of new customer tickets in the customer interface.' =>
            'Define por defecto a prioridade de tickets de novos clientes da interface de axente.',
        'Defines the default priority of new tickets.' => 'Define as prioridades por defecto de novos tickets.',
        'Defines the default queue for new customer tickets in the customer interface.' =>
            'Define a cola por defecto para tickets de clientes da interface de cliente.',
        'Defines the default queue for new tickets in the agent interface.' =>
            '',
        'Defines the default selection at the drop down menu for dynamic objects (Form: Common Specification).' =>
            'Define a selección por defecto no menu "drop down" para obxectos dinámicos (Formulario: Especificación común).',
        'Defines the default selection at the drop down menu for permissions (Form: Common Specification).' =>
            'Define a selección por defecto no menu "drop down" para permisos (Formulario: Especificación común)',
        'Defines the default selection at the drop down menu for stats format (Form: Common Specification). Please insert the format key (see Stats::Format).' =>
            'Define a selección por defecto no menu "drop down" para formato de estatísticas (Formulario: Especificación Común). Por favor inserte a chave formato (vexa Stats::Format).',
        'Defines the default sender type for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            'Define o tipo de remitente por defecto para tickets telefónicos na pantalla ticket de chamada entrante da interface de axente.',
        'Defines the default sender type for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            'Define o tipo de remitente por defecto para tickets telefónicos na pantalla ticket de chamada saínte da interface de axente.',
        'Defines the default sender type for tickets in the ticket zoom screen of the customer interface.' =>
            'Define o tipo de remitente por defecto para tickets na pantalla ticket zoom da interface de cliente.',
        'Defines the default shown ticket search attribute for ticket search screen (AllTickets/ArchivedTickets/NotArchivedTickets).' =>
            '',
        'Defines the default shown ticket search attribute for ticket search screen.' =>
            'Define os atributos de busca mostrados no ticket por defecto para a pantalla busca de ticket. ',
        'Defines the default shown ticket search attribute for ticket search screen. Example: "Key" must have the name of the Dynamic Field in this case \'X\', "Content" must have the value of the Dynamic Field depending on the Dynamic Field type,  Text: \'a text\', Dropdown: \'1\', Date/Time: \'Search_DynamicField_XTimeSlotStartYear=1974; Search_DynamicField_XTimeSlotStartMonth=01; Search_DynamicField_XTimeSlotStartDay=26; Search_DynamicField_XTimeSlotStartHour=00; Search_DynamicField_XTimeSlotStartMinute=00; Search_DynamicField_XTimeSlotStartSecond=00; Search_DynamicField_XTimeSlotStopYear=2013; Search_DynamicField_XTimeSlotStopMonth=01; Search_DynamicField_XTimeSlotStopDay=26; Search_DynamicField_XTimeSlotStopHour=23; Search_DynamicField_XTimeSlotStopMinute=59; Search_DynamicField_XTimeSlotStopSecond=59;\' and or \'Search_DynamicField_XTimePointFormat=week; Search_DynamicField_XTimePointStart=Before; Search_DynamicField_XTimePointValue=7\';.' =>
            'Define os atributos de busca mostrados no ticket por defecto para a pantalla busca de ticket. Exemplo: "Chave" debe ter o nome do Campo Dinámico neste caso \'X\', "Contido" debe ter o valor do Campo Dinámico dependendo do tipo de Campo Dinámico, Texto: \'un texto\', Dropdown:\'1\', Data/Tempo:  \'Search_DynamicField_XTimeSlotStartYear=1974; Search_DynamicField_XTimeSlotStartMonth=01; Search_DynamicField_XTimeSlotStartDay=26; Search_DynamicField_XTimeSlotStartHour=00; Search_DynamicField_XTimeSlotStartMinute=00; Search_DynamicField_XTimeSlotStartSecond=00; Search_DynamicField_XTimeSlotStopYear=2013; Search_DynamicField_XTimeSlotStopMonth=01; Search_DynamicField_XTimeSlotStopDay=26; Search_DynamicField_XTimeSlotStopHour=23; Search_DynamicField_XTimeSlotStopMinute=59; Search_DynamicField_XTimeSlotStopSecond=59;\' and or \'Search_DynamicField_XTimePointFormat=week; Search_DynamicField_XTimePointStart=Before; Search_DynamicField_XTimePointValue=7\';.',
        'Defines the default sort criteria for all queues displayed in the queue view.' =>
            'Define os criterios de ordenación por defecto para todas as colas mostradas na vista de cola.',
        'Defines the default sort criteria for all services displayed in the service view.' =>
            'Define os criterios de ordenación por defecto para todos os servizos mostrados na vista de servizo.',
        'Defines the default sort order for all queues in the queue view, after priority sort.' =>
            'Define a orde de ordenación por defecto para todas na vista de cola, despois de ordenación prioritaria.',
        'Defines the default sort order for all services in the service view, after priority sort.' =>
            'Define a orde de ordenación por defecto para todos os servizos na vista de servizo, despois de ordenación prioritaria.',
        'Defines the default state of new customer tickets in the customer interface.' =>
            'Define o estado por defecto dos tickets dun novo cliente na interface de cliente.',
        'Defines the default state of new tickets.' => 'Define o estado por defecto de novos tickets.',
        'Defines the default subject for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            'Define o tema por defecto para tickets telefónicos na pantalla ticket de chamada entrante da interface de axente.',
        'Defines the default subject for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            'Define o tema por defecto para tickets telefónicos na pantalla ticket de chamada saínte da interface de axente.',
        'Defines the default subject of a note in the ticket free text screen of the agent interface.' =>
            'Define o tema por defecto dunha nota na pantalla texto libre de ticket da interface de axente.',
        'Defines the default the number of seconds (from current time) to re-schedule a generic interface failed task.' =>
            '',
        'Defines the default ticket attribute for ticket sorting in a ticket search of the customer interface.' =>
            'Define os atributos de ticket por defecto para a ordenación de ticket nunha busca de ticket na interface cliente.',
        'Defines the default ticket attribute for ticket sorting in the escalation view of the agent interface.' =>
            'Define os atributos de ticket por defecto para a ordenación de ticket na vista de escalado da interface axente.',
        'Defines the default ticket attribute for ticket sorting in the locked ticket view of the agent interface.' =>
            'Define os atributos de ticket por defecto para a ordenación de ticket na vista de ticket bloqueado da interface axente.',
        'Defines the default ticket attribute for ticket sorting in the responsible view of the agent interface.' =>
            'Define os atributos de ticket por defecto para a ordenación de ticket na vista de responsable da interface axente.',
        'Defines the default ticket attribute for ticket sorting in the status view of the agent interface.' =>
            'Define os atributos de ticket por defecto para a ordenación na vista de estado da interface axente.',
        'Defines the default ticket attribute for ticket sorting in the watch view of the agent interface.' =>
            'Define os atributos de ticket por defecto para a ordenación de ticket na vista mirar da interface axente.',
        'Defines the default ticket attribute for ticket sorting of the ticket search result of the agent interface.' =>
            'Define os atributos de ticket por defecto para a ordenación de ticket do resultado da busca de ticket da interface axente.',
        'Defines the default ticket attribute for ticket sorting of the ticket search result of this operation.' =>
            'Define os atributos de ticket por defecto para a ordenación de ticket do resultado da busca de ticket desta operación.',
        'Defines the default ticket bounced notification for customer/sender in the ticket bounce screen of the agent interface.' =>
            'Define a notificación de encamiñamento predeterminada dun tícket para un cliente/remitente na pantalla de rebote de tíckets da interface do axente.',
        'Defines the default ticket next state after adding a phone note in the ticket phone inbound screen of the agent interface.' =>
            'Define o próximo estado por defecto do ticket despois de engadir unha nota de teléfono na pantalla de ticket de chamada entrante da interface de axente.',
        'Defines the default ticket next state after adding a phone note in the ticket phone outbound screen of the agent interface.' =>
            'Define o próximo estado por defecto do ticket despois de engadir unha nota de teléfono na pantalla de ticket de chamada saínte da interface de axente.',
        'Defines the default ticket order (after priority sort) in the escalation view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Define a orde por defecto de ticket (despois de ordear por prioridade) na vista de escalado da interface de axente. Arriba: os mais antigos no alto. Abaixo: os últimos no alto.',
        'Defines the default ticket order (after priority sort) in the status view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Define a orde por defecto de ticket (despois de ordear por prioridade) na vista de estado da interface de axente. Arriba: os mais antigos no alto. Abaixo: os últimos no alto.',
        'Defines the default ticket order in the responsible view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Define a orde por defecto de ticket na vista de responsable da interface de axente. Arriba: os mais antigos no alto. Abaixo: os últimos no alto.',
        'Defines the default ticket order in the ticket locked view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Define a orde por defecto de ticket na vista de ticket bloqueado da interface de axente. Arriba: os mais antigos no alto. Abaixo: os últimos no alto.',
        'Defines the default ticket order in the ticket search result of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Define a orde por defecto de ticket nos resultados de busca de ticket da interface de axente. Arriba: os mais antigos no alto. Abaixo: os últimos no alto.',
        'Defines the default ticket order in the ticket search result of the this operation. Up: oldest on top. Down: latest on top.' =>
            'Define a orde por defecto de ticket nos resultados de busca de ticket desta operación. Arriba: os mais antigos no alto. Abaixo: os últimos no alto.',
        'Defines the default ticket order in the watch view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Define a orde por defecto de ticket na vista mirar da interface de axente. Arriba: os mais antigos no alto. Abaixo: os últimos no alto.',
        'Defines the default ticket order of a search result in the customer interface. Up: oldest on top. Down: latest on top.' =>
            'Define a orde por defecto de ticket nos resultados de busca na interface de axente. Arriba: os mais antigos no alto. Abaixo: os últimos no alto.',
        'Defines the default ticket priority in the close ticket screen of the agent interface.' =>
            'Define a prioridade de ticket por defecto na pantalla pechar ticket da interface axente.',
        'Defines the default ticket priority in the ticket bulk screen of the agent interface.' =>
            'Define a prioridade de ticket por defecto na pantalla ticket masivo da interface axente.',
        'Defines the default ticket priority in the ticket free text screen of the agent interface.' =>
            'Define a prioridade de ticket por defecto na pantalla texto libre de ticket da interface axente.',
        'Defines the default ticket priority in the ticket note screen of the agent interface.' =>
            'Define a prioridade de ticket por defecto na pantalla nota de ticket da interface axente.',
        'Defines the default ticket priority in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Define a prioridade de ticket por defecto na pantalla propietario de ticket dun ticket zoom na interface axente.',
        'Defines the default ticket priority in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Define a prioridade de ticket por defecto na pantalla de ticket pendente dun ticket zoom na interface axente.',
        'Defines the default ticket priority in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Define a prioridade de ticket por defecto na pantalla de prioridade de ticket dun ticket zoom na interface axente.',
        'Defines the default ticket priority in the ticket responsible screen of the agent interface.' =>
            'Define a prioridade de ticket por defecto na pantalla responsable de ticket na interface axente.',
        'Defines the default ticket type for new customer tickets in the customer interface.' =>
            'Define o tipo de ticket por defecto para novos tickets de cliente na interface cliente.',
        'Defines the default ticket type.' => '',
        'Defines the default used Frontend-Module if no Action parameter given in the url on the agent interface.' =>
            'Define o Módulo-Frontend usado por defecto se non foron dados os parámetros Acción da url na interface axente.',
        'Defines the default used Frontend-Module if no Action parameter given in the url on the customer interface.' =>
            'Define o Módulo-Frontend usado por defecto se non foron dados os parametros Accion da url na interface cliente.',
        'Defines the default value for the action parameter for the public frontend. The action parameter is used in the scripts of the system.' =>
            'Define os valores porr defecto para os parametros de accion para el frontend público. El parametro de acción é usado nos scripts do sistema.',
        'Defines the default viewable sender types of a ticket (default: customer).' =>
            'Define os tipos de remitentes visibles por defecto de un ticket (por defecto: cliente).',
        'Defines the default visibility of the article to customer for this operation.' =>
            '',
        'Defines the displayed style of the From field in notes that are visible for customers. A default agent name can be defined in Ticket::Frontend::CustomerTicketZoom###DefaultAgentName setting.' =>
            '',
        'Defines the dynamic fields that are used for displaying on calendar events.' =>
            'Define los campos dinámicos que usanse para mostrar eventos no calendario.',
        'Defines the event object types that will be handled via AdminAppointmentNotificationEvent.' =>
            '',
        'Defines the fall-back path to open fetchmail binary. Note: The name of the binary needs to be \'fetchmail\', if it is different please use a symbolic link.' =>
            '',
        'Defines the filter that processes the text in the articles, in order to highlight URLs.' =>
            'Define o filtro que procesa texto nos artigos, para resaltar as URLs.',
        'Defines the format of responses in the ticket compose screen of the agent interface ([% Data.OrigFrom | html %] is From 1:1, [% Data.OrigFromName | html %] is only realname of From).' =>
            'Define o formato das respostas na pantalla composición de ticket da interface axente ([% Data.OrigFrom | html %] é Dende 1:1, [% Data.OrigFromName | html %] é só nome real de Dende).',
        'Defines the fully qualified domain name of the system. This setting is used as a variable, OTRS_CONFIG_FQDN which is found in all forms of messaging used by the application, to build links to the tickets within your system.' =>
            'Define o nome completo de dominio do sistema. Este axuste e usado coma unha variable, OTRS_CONFIG_FQDN que atópase en todolos formularios de mensaxeria usados pola aplicación, para construir enlaces a tickets dentro do seu sistema.',
        'Defines the groups every customer user will be in (if CustomerGroupSupport is enabled and you don\'t want to manage every customer user for these groups).' =>
            '',
        'Defines the groups every customer will be in (if CustomerGroupSupport is enabled and you don\'t want to manage every customer for these groups).' =>
            '',
        'Defines the height for the rich text editor component for this screen. Enter number (pixels) or percent value (relative).' =>
            'Define a altura para o compoñente de editor de texto rico para esta pantalla. Introduza en número (pixeis) ou valor porcentual (relativo).',
        'Defines the height for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            'Define a altura para o compoñente de editor de texto rico. Introduza en número (pixeis) ou valor porcentual (relativo).',
        'Defines the history comment for the close ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Define o historico do comentario para a pantalla de acción de peche de ticket, que emprégase para o historico do ticket na interface de axente.',
        'Defines the history comment for the email ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Define o historico do comentario para a pantalla de accion de ticket email, que emprégase para o historico do ticket na interface de axente.',
        'Defines the history comment for the phone ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Define o historico do comentario para a pantalla de accion de ticket telefónico, que emprégase para o historico do ticket na interface de axente.',
        'Defines the history comment for the ticket free text screen action, which gets used for ticket history.' =>
            'Define o historico do comentario para a pantalla de accion de texto libre de ticket, que emprégase para o historico do ticket.',
        'Defines the history comment for the ticket note screen action, which gets used for ticket history in the agent interface.' =>
            'Define o historico do comentario para a pantalla de accion de nota de ticket, que emprégase para o historico do ticket na interface de axente.',
        'Defines the history comment for the ticket owner screen action, which gets used for ticket history in the agent interface.' =>
            'Define o historico do comentario para a pantalla de acción de propietario de ticket, que emprégase para o historico do ticket na interface de axente.',
        'Defines the history comment for the ticket pending screen action, which gets used for ticket history in the agent interface.' =>
            'Define o historico do comentario para a pantalla de acción de ticket pendente, a cal emprégase para o historico de ticket na interface de axente.',
        'Defines the history comment for the ticket phone inbound screen action, which gets used for ticket history in the agent interface.' =>
            'Define o historico do comentario para a pantalla de acción de ticket de chamada entrante, a cal emprégase para o historico de ticket na interface de axente.',
        'Defines the history comment for the ticket phone outbound screen action, which gets used for ticket history in the agent interface.' =>
            'Define o historico do comentario para a pantalla de acción de ticket de chamada saínte, a cal emprégase para o historico de ticket na interface de axente.',
        'Defines the history comment for the ticket priority screen action, which gets used for ticket history in the agent interface.' =>
            'Define o historico do comentario para a pantalla de acción de prioridade de ticket, a cal emprégase para o historico de ticket na interface de axente.',
        'Defines the history comment for the ticket responsible screen action, which gets used for ticket history in the agent interface.' =>
            'Define o historico do comentario para a pantalla de acción de reponsable de ticket, a cal emprégase para o historico de ticket na interface de axente.',
        'Defines the history comment for the ticket zoom action, which gets used for ticket history in the customer interface.' =>
            'Define o historico do comentario para a pantalla de acción de ticket zoom, a cal emprégase para o historico de ticket na interface de axente.',
        'Defines the history comment for this operation, which gets used for ticket history in the agent interface.' =>
            'Define o historico do comentario para esta operación, a cal emprégase para o historico de ticket na interface de axente.',
        'Defines the history type for the close ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Define o tipo de historico para a pantalla de acción de ticket pechado, a cal emprégase para o historico de ticket na interface de axente.',
        'Defines the history type for the email ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Define o tipo de historico para a pantalla de acción de email ticket, a cal emprégase para o historico de ticket na interface de axente.',
        'Defines the history type for the phone ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Define o tipo de historico para a pantalla de acción de ticket telefónico, a cal emprégase para o historico de ticket na interface de axente.',
        'Defines the history type for the ticket free text screen action, which gets used for ticket history.' =>
            'Define o tipo de historico para a pantalla de acción de texto libre de ticket, a cal emprégase para o historico de ticket.',
        'Defines the history type for the ticket note screen action, which gets used for ticket history in the agent interface.' =>
            'Define o tipo de historico para a pantalla de acción de nota de ticket, a cal emprégase para o historico de ticket na interface de axente.',
        'Defines the history type for the ticket owner screen action, which gets used for ticket history in the agent interface.' =>
            'Define o tipo de historico para a pantalla de acción de propietario de ticket, a cal emprégase para o historico de ticket na interface de axente.',
        'Defines the history type for the ticket pending screen action, which gets used for ticket history in the agent interface.' =>
            'Define o tipo de historico para a pantalla de acción de ticket pendente, a cal emprégase para o historico de ticket na interface de axente.',
        'Defines the history type for the ticket phone inbound screen action, which gets used for ticket history in the agent interface.' =>
            'Define o tipo de historico para a pantalla de acción de ticket de chamda entrante, a cal emprégase para o historico de ticket na interface de axente.',
        'Defines the history type for the ticket phone outbound screen action, which gets used for ticket history in the agent interface.' =>
            'Define o tipo de historico para a pantalla de acción de ticket de chamada saínte , a cal emprégase para o historico de ticket na interface de axente.',
        'Defines the history type for the ticket priority screen action, which gets used for ticket history in the agent interface.' =>
            'Define o tipo de historico para a pantalla de acción de prioridade de ticket, a cal emprégase para o historico de ticket na interface de axente.',
        'Defines the history type for the ticket responsible screen action, which gets used for ticket history in the agent interface.' =>
            'Define o tipo de historico para a pantalla de acción de responsable de ticket, a cal emprégase para o historico de ticket na interface de axente.',
        'Defines the history type for the ticket zoom action, which gets used for ticket history in the customer interface.' =>
            'Define o tipo de historico para a pantalla de acción de ticket  zoom, a cal emprégase para o historico de ticket na interface de cliente.',
        'Defines the history type for this operation, which gets used for ticket history in the agent interface.' =>
            'Define o tipo de historico para esta operación, a cal emprégase para o historico de ticket na interface de axente.',
        'Defines the hours and week days of the indicated calendar, to count the working time.' =>
            'Define as horas e os días da semana do calendario indicado, para contar o tempo de traballo.',
        'Defines the hours and week days to count the working time.' => 'Define as horas e os días da semana para contar o tempo de traballo.',
        'Defines the key to be checked with Kernel::Modules::AgentInfo module. If this user preferences key is true, the message is accepted by the system.' =>
            'Define a chave a comprobar co módulo Kernel::Modules::AgentInfo. Se a chave das preferencias de usuario e verdadeira, a mensaxe e aceptada polo sistema.',
        'Defines the key to check with CustomerAccept. If this user preferences key is true, then the message is accepted by the system.' =>
            'Define a chave a comprobar con ClienteAcepta. Se a chave das preferencias de usuario e verdadeira, a mensaxe e aceptada polo sistema.',
        'Defines the link type \'Normal\'. If the source name and the target name contain the same value, the resulting link is a non-directional one; otherwise, the result is a directional link.' =>
            'Define o tipo de enlace \'Normal\'. Se o nome da fonte e o nome do obxetivo conteñen o mesmo valor, o enlace resultante e un non direccional; doutra forma, o resultado é un enlace direccional.',
        'Defines the link type \'ParentChild\'. If the source name and the target name contain the same value, the resulting link is a non-directional one; otherwise, the result is a directional link.' =>
            'Define o tipo de enlace \'PaiFillo\'. Se o nome fonte e o nome obxetivo conteñen o mesmo valor, o enlace resultante e un non direccional; doutra forma, o resultado e un enlace direccional.',
        'Defines the link type groups. The link types of the same group cancel one another. Example: If ticket A is linked per a \'Normal\' link with ticket B, then these tickets could not be additionally linked with link of a \'ParentChild\' relationship.' =>
            'Define os grupos de tipos de enlace. Os tipos de enlace do mesmo grupo cancelan uns aos outros. Exemplo: Se ticket A é enlazado cun enlace \'Normal\' có ticket B, estos tickets non poden ser ligados adicionalmente cunha relación \'PaiFillo\'.',
        'Defines the list of online repositories. Another installations can be used as repository, for example: Key="http://example.com/otrs/public.pl?Action=PublicRepository;File=" and Content="Some Name".' =>
            'Define a lista de repositorios online. Outras instalacións poden empregarse coma repositorio, por exemplo: Chave="http://example.com/otrs/public.pl?Action=PublicRepository;File=" e Contido="Algún Nome".',
        'Defines the list of params that can be passed to ticket search function.' =>
            '',
        'Defines the list of possible next actions on an error screen, a full path is required, then is possible to add external links if needed.' =>
            '',
        'Defines the list of types for templates.' => 'Define a lista de tipos para modelos.',
        'Defines the location to get online repository list for additional packages. The first available result will be used.' =>
            'Define o lugar para obter a lista de repositorios online para paquetes adicionais. Emprégase o primeiro resultado dispoñíble.',
        'Defines the log module for the system. "File" writes all messages in a given logfile, "SysLog" uses the syslog daemon of the system, e.g. syslogd.' =>
            'Define o módulo log para o sistema. "Arquivo" escribe tódolos mensaxes nun logfile dado, "SysLog" emprega o daemon syslog do sistema, ex. syslogd.',
        'Defines the maximal size (in bytes) for file uploads via the browser. Warning: Setting this option to a value which is too low could cause many masks in your OTRS instance to stop working (probably any mask which takes input from the user).' =>
            'Define o tamaño maximo (en bytes) para carga de arquivos vía o navegador. Alerta: Axustar esta opción a un valor moi baixo pode causar moitas máscaras na súa instancia de OTRS para parar de traballar (probablemente algunha máscara a cal colla entradas do usuario).',
        'Defines the maximal valid time (in seconds) for a session id.' =>
            'Define o tempo válido máximo (en segundos) para unha id de sesión.',
        'Defines the maximum number of affected tickets per job.' => '',
        'Defines the maximum number of pages per PDF file.' => 'Define o número máximo de páxinas por arquivo PDF.',
        'Defines the maximum number of quoted lines to be added to responses.' =>
            'Define o número máximo de liñas citadas para ser engadidas as respostas.',
        'Defines the maximum number of tasks to be executed as the same time.' =>
            '',
        'Defines the maximum size (in MB) of the log file.' => 'Define o tamaño máximo (en MB) do arquivo log.',
        'Defines the maximum size in KiloByte of GenericInterface responses that get logged to the gi_debugger_entry_content table.' =>
            '',
        'Defines the module that shows a generic notification in the agent interface. Either "Text" - if configured - or the contents of "File" will be displayed.' =>
            'Define o módulo que mostra a notificación xenérica na interface de axente. Ambos "Texto" - se configurado- ou os contidos de "Arquivo" van ser mostrados.',
        'Defines the module that shows all the currently logged in agents in the agent interface.' =>
            'Define o módulo que mostra tódolos axentes actualmente "logeados" na interface de axente.',
        'Defines the module that shows all the currently logged in customers in the agent interface.' =>
            '',
        'Defines the module that shows the currently logged in agents in the customer interface.' =>
            '',
        'Defines the module that shows the currently logged in customers in the customer interface.' =>
            '',
        'Defines the module to authenticate customers.' => 'Define o módulo para autenticar clientes.',
        'Defines the module to display a notification if cloud services are disabled.' =>
            '',
        'Defines the module to display a notification in different interfaces on different occasions for OTRS Business Solution™.' =>
            'Define o módulo para mostrar unha notificación en direntes interfaces nas diferentes ocasións para OTRS Business Solution™. ',
        'Defines the module to display a notification in the agent interface if the OTRS Daemon is not running.' =>
            '',
        'Defines the module to display a notification in the agent interface if the system configuration is out of sync.' =>
            '',
        'Defines the module to display a notification in the agent interface, if the agent has not yet selected a time zone.' =>
            '',
        'Defines the module to display a notification in the agent interface, if the agent is logged in while having out-of-office active.' =>
            'Define o módulo para mostrar unha notificación na interface de axente, se o axente está "logeado" mentres ten fora da oficina activo.',
        'Defines the module to display a notification in the agent interface, if the agent is logged in while having system maintenance active.' =>
            'Define o módulo para mostrar unha notificación na interface de axente, se o axente está "logeado" mentres ten o mantemento do sistema activo.',
        'Defines the module to display a notification in the agent interface, if the agent session limit prior warning is reached.' =>
            '',
        'Defines the module to display a notification in the agent interface, if the installation of not verified packages is activated (only shown to admins).' =>
            '',
        'Defines the module to display a notification in the agent interface, if the system is used by the admin user (normally you shouldn\'t work as admin).' =>
            'Define o módule para mostrar unha notificación na interface de axente, se o sistema está sendo empregado polo usuario administrador (normalmente non debe traballar coma administrador).',
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
            'Define o módulo empregado para almacenar os datos da sesión. Con «DB» o servidor frontend pode ser partido do servidor da base de datos. «FS» é máis rápido.',
        'Defines the name of the application, shown in the web interface, tabs and title bar of the web browser.' =>
            'Define o nome da aplicación, mostrado na interface web, pestañas e barras de título do buscador web.',
        'Defines the name of the column to store the data in the preferences table.' =>
            'Define o nome da columna para almacenar os datos na táboa preferencias.',
        'Defines the name of the column to store the user identifier in the preferences table.' =>
            'Define o nome da columna para almacenar o identificador de usuario na táboa de preferencias.',
        'Defines the name of the indicated calendar.' => 'Define o nome do calendario indicado.',
        'Defines the name of the key for customer sessions.' => 'Define o nome da chave para sesións de cliente.',
        'Defines the name of the session key. E.g. Session, SessionID or OTRS.' =>
            'Define o nome da chave de sesión. Ex. Sesión, IDSesión ou OTRS.',
        'Defines the name of the table where the user preferences are stored.' =>
            '',
        'Defines the next possible states after composing / answering a ticket in the ticket compose screen of the agent interface.' =>
            'Define os seguintes posibles estados despois de compoñer / responder un ticket na pantalla composición de ticket da interface de axente.',
        'Defines the next possible states after forwarding a ticket in the ticket forward screen of the agent interface.' =>
            'Define os seguintes posibles estados despois de avanzar un ticket na pantalla de avance de ticket da interface de axente.',
        'Defines the next possible states after sending a message in the email outbound screen of the agent interface.' =>
            'Define os seguintes posibles estados despois de enviar unha mensaxe na pantalla de saída de email da interface de axente.',
        'Defines the next possible states for customer tickets in the customer interface.' =>
            'Define os seguintes posibles estados para tickets de cliente na interface de axente.',
        'Defines the next state of a ticket after adding a note, in the close ticket screen of the agent interface.' =>
            'Define o seguinte estado dun ticket despois de engadir unha nota, na pantalla peche de ticket da interface de axente.',
        'Defines the next state of a ticket after adding a note, in the ticket free text screen of the agent interface.' =>
            'Define o seguinte estado dun ticket despois de engadir unha nota, na pantalla de texto libre de ticket da interface de axente.',
        'Defines the next state of a ticket after adding a note, in the ticket note screen of the agent interface.' =>
            'Define o seguinte estado dun ticket despois de engadir unha nota, na pantalla de nota de ticket da interface de axente.',
        'Defines the next state of a ticket after adding a note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Define o seguinte estado dun ticket despois de engadir unha nota, na pantalla de propietario de ticket dun ticket zoom na interface de axente.',
        'Defines the next state of a ticket after adding a note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Define o seguinte estado dun ticket despois de engadir unha nota, na pantalla de ticket pendente dun ticket zoom na interface de axente.',
        'Defines the next state of a ticket after adding a note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Define o seguinte estado dun ticket despois de engadir unha nota, na pantalla de prioridade de ticket dun ticket zoom na interface de axente.',
        'Defines the next state of a ticket after adding a note, in the ticket responsible screen of the agent interface.' =>
            'Define o seguinte estado dun ticket despois de engadir unha nota, na pantalla de responsable de ticket da interface de axente.',
        'Defines the next state of a ticket after being bounced, in the ticket bounce screen of the agent interface.' =>
            'Define o estado seguinte dun tícket despois de ser rebotado, na pantalla de rebote de tícket da interface do axente.',
        'Defines the next state of a ticket after being moved to another queue, in the move ticket screen of the agent interface.' =>
            'Define o seguinte estado dun ticket despois de ser movido a outra cola, na pantalla de mover ticket da interface de axente.',
        'Defines the next state of a ticket, in the ticket bulk screen of the agent interface.' =>
            '',
        'Defines the number of character per line used in case an HTML article preview replacement on TemplateGenerator for EventNotifications.' =>
            '',
        'Defines the number of days to keep the daemon log files.' => '',
        'Defines the number of header fields in frontend modules for add and update postmaster filters. It can be up to 99 fields.' =>
            'Define o número de campos da cabeceira nos modulos frontend para engadir e actualizar filtros postmaster. Pode ser ata 99 campos.',
        'Defines the number of hours a communication will be stored, whichever its status.' =>
            '',
        'Defines the number of hours a successful communication will be stored.' =>
            '',
        'Defines the parameters for the customer preferences table.' => 'Define os parametros para a táboa de preferencias de cliente.',
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
            'Define o contrasinal para manexar o acceso SOAP (bin/cgi-bin/rpc.pl).',
        'Defines the path and TTF-File to handle bold italic monospaced font in PDF documents.' =>
            'Define a ruta e o Arquivo-TTF para manexar a fonte monoespacio negrita italica en documentos PDF.',
        'Defines the path and TTF-File to handle bold italic proportional font in PDF documents.' =>
            'Define a ruta e o Arquivo-TTF para manexar a fonte proporcional negrita italica en documentos PDF.',
        'Defines the path and TTF-File to handle bold monospaced font in PDF documents.' =>
            'Define a ruta e o Arquivo-TTF para manexar a fonte monoespacio negrita en documentos PDF.',
        'Defines the path and TTF-File to handle bold proportional font in PDF documents.' =>
            'Define a ruta e o Arquivo-TTF para manexar a fonte proporcional negrita en documentos PDF.',
        'Defines the path and TTF-File to handle italic monospaced font in PDF documents.' =>
            'Define a ruta e o Arquivo-TTF para manexar a fonte monoespacio italica en documentos PDF.',
        'Defines the path and TTF-File to handle italic proportional font in PDF documents.' =>
            'Define a ruta e o Arquivo-TTF para manexar a fonte proporcional italica en documentos PDF.',
        'Defines the path and TTF-File to handle monospaced font in PDF documents.' =>
            'Define a ruta e o Arquivo-TTF para manexar a fonte monoespacio en documentos PDF.',
        'Defines the path and TTF-File to handle proportional font in PDF documents.' =>
            'Define a ruta e o Arquivo-TTF para manexar a fonte proporcional en documentos PDF.',
        'Defines the path of the shown info file, that is located under Kernel/Output/HTML/Templates/Standard/CustomerAccept.tt.' =>
            '',
        'Defines the path to PGP binary.' => 'Define a ruta ao binario PGP.',
        'Defines the path to open ssl binary. It may need a HOME env ($ENV{HOME} = \'/var/lib/wwwrun\';).' =>
            'Define a ruta do binario ssl aberto. Pode necesitar un HOME env ($ENV{HOME} = \'/var/lib/wwwrun\';).',
        'Defines the period of time (in minutes) before agent is marked as "away" due to inactivity (e.g. in the "Logged-In Users" widget or for the chat).' =>
            '',
        'Defines the period of time (in minutes) before customer is marked as "away" due to inactivity (e.g. in the "Logged-In Users" widget or for the chat).' =>
            '',
        'Defines the postmaster default queue.' => 'Define a cola por defecto de postmaster.',
        'Defines the priority in which the information is logged and presented.' =>
            'Define a prioridade na que á información é logeada e presentada. ',
        'Defines the recipient target of the phone ticket and the sender of the email ticket ("Queue" shows all queues, "System address" displays all system addresses) in the agent interface.' =>
            '',
        'Defines the recipient target of the tickets ("Queue" shows all queues, "SystemAddress" shows only the queues which are assigned to system addresses) in the customer interface.' =>
            '',
        'Defines the required permission to show a ticket in the escalation view of the agent interface.' =>
            'Define os permisos requiridos para mostrar un tícket na vista de escalado da interface de axente.',
        'Defines the search limit for the stats.' => 'Define os limite de busca para as estatísticas.',
        'Defines the search parameters for the AgentCustomerUserAddressBook screen. With the setting \'CustomerTicketTextField\' the values for the recipient field can be specified.' =>
            '',
        'Defines the sender for rejected emails.' => 'Define o remitente para correos electrónicos rexeitados.',
        'Defines the separator between the agents real name and the given queue email address.' =>
            'Define o separador entre o nome real de axentes e a cola dada de enderezo de correo.',
        'Defines the shown columns and the position in the AgentCustomerUserAddressBook result screen.' =>
            '',
        'Defines the shown links in the footer area of the customer and public interface of this OTRS system. The value in "Key" is the external URL, the value in "Content" is the shown label.' =>
            '',
        'Defines the standard permissions available for customers within the application. If more permissions are needed, you can enter them here. Permissions must be hard coded to be effective. Please ensure, when adding any of the afore mentioned permissions, that the "rw" permission remains the last entry.' =>
            'Define os permisos estándares dispoñibles para clientes dentro da aplicación. Se máis permisos son necesitados, pode introducílos aquí. Permisos deben ser "hard coded" para ser efectivos. Por favor asegure, cando engada calquera dos permisos anteriormente mencionados, que o permiso de "rw" permanece coma última entrada.',
        'Defines the standard size of PDF pages.' => 'Define o tamaño estandard das páxinas PDF.',
        'Defines the state of a ticket if it gets a follow-up and the ticket was already closed.' =>
            'Define o estado dun ticket se obtén un seguemento e o ticket xa fora pechado.',
        'Defines the state of a ticket if it gets a follow-up.' => 'Define o estado sun ticket se obtén un seguemento.',
        'Defines the state type of the reminder for pending tickets.' => 'Define o tipo de estado do recordatorio para tickets pendentes.',
        'Defines the subject for notification mails sent to agents, about new password.' =>
            'Define o tema para correos de notificación enviados a axentes, sobre novo contrasinal.',
        'Defines the subject for notification mails sent to agents, with token about new requested password.' =>
            'Define o tema para correos de notificación enviados a axentes, con sinal sobre novo contrasinal pedido.',
        'Defines the subject for notification mails sent to customers, about new account.' =>
            'Define o tema para correos de notificación enviados a clientes, sobre nova conta.',
        'Defines the subject for notification mails sent to customers, about new password.' =>
            'Define o tema para correos de notificación enviados a clientes, sobre novo contrasinal.',
        'Defines the subject for notification mails sent to customers, with token about new requested password.' =>
            'Define o tema para correos de notificación enviados a clientes, con sinal sobre novo contrasinal pedido.',
        'Defines the subject for rejected emails.' => 'Define o tema para correos electrónicos rexeitados.',
        'Defines the system administrator\'s email address. It will be displayed in the error screens of the application.' =>
            'Define o enderezo de correo electrónico do administrador de sistema. Será mostrado nas pantallas de erro da aplicación.',
        'Defines the system identifier. Every ticket number and http session string contains this ID. This ensures that only tickets which belong to your system will be processed as follow-ups (useful when communicating between two instances of OTRS).' =>
            'Define o identificador de sistema. Todos os números de ticket e string de sesión http contén esta ID. Isto asegura que soamente os tickets que pertencen ao seu sistema serán procesados como seguimentos (útil cando comunicánse entre dúas instancias de OTRS).',
        'Defines the target attribute in the link to external customer database. E.g. \'AsPopup PopupType_TicketAction\'.' =>
            'Define o atributo de obxectivo no enlace a base de datos de cliente externa. P.ex. \'AsPopup PopupType_TicketAction\'.',
        'Defines the target attribute in the link to external customer database. E.g. \'target="cdb"\'.' =>
            'Define o atributo obxectivo no enlace a base de datos de clientes externa. \'P.ej. target="cdb " \'.',
        'Defines the ticket appointment type backend for ticket dynamic field date time.' =>
            '',
        'Defines the ticket appointment type backend for ticket escalation time.' =>
            '',
        'Defines the ticket appointment type backend for ticket pending time.' =>
            '',
        'Defines the ticket fields that are going to be displayed calendar events. The "Key" defines the field or ticket attribute and the "Content" defines the display name.' =>
            'Define os campos do ticket que van ser mostrados eventos de calendario. A "Chave" define o atributo de campo ou ticket e o "Contido" define o nome de mostra.',
        'Defines the ticket plugin for calendar appointments.' => '',
        'Defines the time zone of the indicated calendar, which can be assigned later to a specific queue.' =>
            'Define a zona horaria do calendario indicado, o cal pode ser asignado despois a unha cola especifica.',
        'Defines the timeout (in seconds, minimum is 20 seconds) for the support data collection with the public module \'PublicSupportDataCollector\' (e.g. used from the OTRS Daemon).' =>
            '',
        'Defines the two-factor module to authenticate agents.' => '',
        'Defines the two-factor module to authenticate customers.' => '',
        'Defines the type of protocol, used by the web server, to serve the application. If https protocol will be used instead of plain http, it must be specified here. Since this has no affect on the web server\'s settings or behavior, it will not change the method of access to the application and, if it is wrong, it will not prevent you from logging into the application. This setting is only used as a variable, OTRS_CONFIG_HttpType which is found in all forms of messaging used by the application, to build links to the tickets within your system.' =>
            'Define o tipo de protocolo, utilizado polo servidor web, para servir a aplicación. Se o protocolo de https é utilizado en lugar de http sinxelo, debe ser especificado aquí. Debido a  que isto non ten ningún efecto nos axustes ou comportamento do servidor web, non cambiará o método de acceso na aplicación e, se está equivocado, non lle impedirá que rexistrarse na aplicación. Este axuste é soamente utilizado como unha variable, OTRS_CONFIG_HttpType que é atopado en todas as formas de mensaxería utilizada pola aplicación, para construír enlaces aos tickets dentro do seu sistema.',
        'Defines the used character for plaintext email quotes in the ticket compose screen of the agent interface. If this is empty or inactive, original emails will not be quoted but appended to the response.' =>
            'Define o carácter utilizado para citas de correo electrónico de texto plano na pantalla composición de ticket da interface de axente. Se isto é baleiro ou inactivo, correos electrónicos orixinais non serán citados senón que engadidos á resposta.',
        'Defines the user identifier for the customer panel.' => 'Define o identificador de usuario para o panel de cliente.',
        'Defines the username to access the SOAP handle (bin/cgi-bin/rpc.pl).' =>
            'Define o nome de usuario para manexar o acceso SOAP (bin/cgi-bin/rpc.pl).',
        'Defines the users avatar. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Defines the valid state types for a ticket. If a ticket is in a state which have any state type from this setting, this ticket will be considered as open, otherwise as closed.' =>
            '',
        'Defines the valid states for unlocked tickets. To unlock tickets the script "bin/otrs.Console.pl Maint::Ticket::UnlockTimeout" can be used.' =>
            '',
        'Defines the viewable locks of a ticket. NOTE: When you change this setting, make sure to delete the cache in order to use the new value. Default: unlock, tmp_lock.' =>
            '',
        'Defines the width for the rich text editor component for this screen. Enter number (pixels) or percent value (relative).' =>
            'Define a anchura para o compoñente do editor de texto rico para esta pantalla. Introduzca número (pixeis) ou valor de porcentaxe (relativo).',
        'Defines the width for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            'Define a anchura para o compoñente do editor de texto rico. Introduzca número (pixeis) ou valor da porcentaxe (relativa).',
        'Defines time in minutes since last modification for drafts of specified type before they are considered expired.' =>
            '',
        'Defines whether to index archived tickets for fulltext searches.' =>
            '',
        'Defines which article sender types should be shown in the preview of a ticket.' =>
            'Define cales tipos de remitente de artigo deberían ser mostrados na vista previa dun ticket.',
        'Defines which items are available for \'Action\' in third level of the ACL structure.' =>
            'Define cales elementos están dispoñibles para \'Acción\' no terceiro nivel da estructura ACL.',
        'Defines which items are available in first level of the ACL structure.' =>
            'Define cales elementos están dispoñibles no primeiro nivel da estructura ACL.',
        'Defines which items are available in second level of the ACL structure.' =>
            'Define cales elementos están dispoñibles no segundo nivel da estructura ACL.',
        'Defines which states should be set automatically (Content), after the pending time of state (Key) has been reached.' =>
            'Define cales estados deben ser establecidos automaticamente (Contido), despois de que o estado do tempo pendente (Chave) fora alcanzado.',
        'Defines, which tickets of which ticket state types should not be listed in linked ticket lists.' =>
            'Define, cales tickets de cal tipo de estado de ticket non deben ser listados en listas de ticket enlazadas.',
        'Delete expired cache from core modules.' => '',
        'Delete expired loader cache weekly (Sunday mornings).' => '',
        'Delete expired sessions.' => '',
        'Delete expired ticket draft entries.' => '',
        'Delete expired upload cache hourly.' => '',
        'Delete this ticket' => 'Borre este Ticket',
        'Deleted link to ticket "%s".' => 'Enlace eliminado ao ticket "%s".',
        'Deletes a session if the session id is used with an invalid remote IP address.' =>
            'Elimina unha sesión se o id de sesión foi empregado un enderexo IP remoto invalido.',
        'Deletes requested sessions if they have timed out.' => 'Elimina as sesións solicitadas se se lles esgotou o tempo.',
        'Delivers extended debugging information in the frontend in case any AJAX errors occur, if enabled.' =>
            '',
        'Deploy and manage OTRS Business Solution™.' => 'Despregue e dirixa OTRS Business Solution™.',
        'Detached' => '',
        'Determines if a button to delete a link should be displayed next to each link in each zoom mask.' =>
            '',
        'Determines if the list of possible queues to move to ticket into should be displayed in a dropdown list or in a new window in the agent interface. If "New Window" is set you can add a move note to the ticket.' =>
            'Determina se a lista de posibles colas para mover o ticket debería ser mostrada nunha lista de dropdown ou nunha nova ventá na interface de axente. Se "Nova Ventá" é fixado pode engadir unha nota de movemento ao ticket.',
        'Determines if the statistics module may generate ticket lists.' =>
            'Determina se o módulo de estatísticas pode xerar listas de ticket.',
        'Determines the next possible ticket states, after the creation of a new email ticket in the agent interface.' =>
            'Determina os próximos posibles estados de ticket, despois da creación dun novo ticket de correo electrónico na interface de axente.',
        'Determines the next possible ticket states, after the creation of a new phone ticket in the agent interface.' =>
            'Determina os próximos posibles estados do ticket, despois da creación dun novo ticket de teléfono na interface de axente.',
        'Determines the next possible ticket states, for process tickets in the agent interface.' =>
            'Determina os próximos posibles estados do ticket, para tickets de proceso na interface de axente.',
        'Determines the next possible ticket states, for process tickets in the customer interface.' =>
            '',
        'Determines the next screen after new customer ticket in the customer interface.' =>
            'Determina a seguinte pantalla despois dun novo ticket de cliente na interface de clientes.',
        'Determines the next screen after the follow-up screen of a zoomed ticket in the customer interface.' =>
            '',
        'Determines the next screen after the ticket is moved. LastScreenOverview will return the last overview screen (e.g. search results, queueview, dashboard). TicketZoom will return to the TicketZoom.' =>
            'Determina a seguinte pantalla despois de que un ticket é movido. LastScreenOverview devolverá a última pantalla de visión xeral (p. ex. resultados de busca, vistacola, cadro de mando). TicketZoom volverá ao TicketZoom.',
        'Determines the possible states for pending tickets that changed state after reaching time limit.' =>
            'Determina os posibles estados para tickets pendentes que cambiaban de estado despois de que alcanza o límite de tempo.',
        'Determines the strings that will be shown as recipient (To:) of the phone ticket and as sender (From:) of the email ticket in the agent interface. For Queue as NewQueueSelectionType "<Queue>" shows the names of the queues and for SystemAddress "<Realname> <<Email>>" shows the name and email of the recipient.' =>
            '',
        'Determines the strings that will be shown as recipient (To:) of the ticket in the customer interface. For Queue as CustomerPanelSelectionType, "<Queue>" shows the names of the queues, and for SystemAddress, "<Realname> <<Email>>" shows the name and email of the recipient.' =>
            '',
        'Determines the way the linked objects are displayed in each zoom mask.' =>
            'Determina a forma en que os obxetos ligados son mostrados en cada máscara de zoom.',
        'Determines which options will be valid of the recipient (phone ticket) and the sender (email ticket) in the agent interface.' =>
            '',
        'Determines which queues will be valid for ticket\'s recepients in the customer interface.' =>
            'Determina cales colas van ser validas para receptores de tickets na interface de cliente.',
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
            'Mostra unha alerta e prevén a busca cando se usan palabras de parada dentro dunha busca de texto completo.',
        'Display communication log entries.' => '',
        'Display settings to override defaults for Process Tickets.' => 'Mostra axustes para sobreescribir os Procesos Tickets por defecto.',
        'Displays the accounted time for an article in the ticket zoom view.' =>
            'Mostra o tempo rexistrado para un artigo na vista zoom de ticket.',
        'Displays the number of all tickets with the same CustomerID as current ticket in the ticket zoom view.' =>
            '',
        'Down' => 'Abaixo',
        'Dropdown' => 'Despregable',
        'Dutch' => '',
        'Dutch stop words for fulltext index. These words will be removed from the search index.' =>
            '',
        'Dynamic Fields Checkbox Backend GUI' => 'Campos Dinámicos Checkbox Backend GUI',
        'Dynamic Fields Date Time Backend GUI' => 'Campos Dinámicos Data Hora Backend GUI',
        'Dynamic Fields Drop-down Backend GUI' => 'Campos Dinámicos Despregable Backend GUI',
        'Dynamic Fields GUI' => 'Campos Dinámicos GUI',
        'Dynamic Fields Multiselect Backend GUI' => 'Campos Dinámicos Multiselección Backend GUI',
        'Dynamic Fields Overview Limit' => 'Campos Dinámicos Vista Xeral Límite',
        'Dynamic Fields Text Backend GUI' => 'Campos Dinámicos Texto Backend GUI',
        'Dynamic Fields used to export the search result in CSV format.' =>
            'Campos Dinámicos usados para exportar os resultados da busca en formato CSV.',
        'Dynamic fields groups for process widget. The key is the name of the group, the value contains the fields to be shown. Example: \'Key => My Group\', \'Content: Name_X, NameY\'.' =>
            'Grupos de campos dinámicos para proceso widget. A chave e o nome do grupo, o valor contén os campos a ser mostrados. Exemplo: \'Chave => Meu Grupo\', \'Contido: Nome_X, NomeY\'.',
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
        'DynamicField backend registration.' => 'Rexistro backend CampoDinamico.',
        'DynamicField object registration.' => 'Rexistro obxeto CampoDinamico.',
        'DynamicField_%s' => '',
        'E-Mail Outbound' => 'Correo electrónico De Ida',
        'Edit Customer Companies.' => '',
        'Edit Customer Users.' => '',
        'Edit appointment' => '',
        'Edit customer company' => 'Editar a empresa do cliente',
        'Email Addresses' => 'Enderezos de Correo Electronico',
        'Email Outbound' => '',
        'Email Resend' => '',
        'Email communication channel.' => '',
        'Enable highlighting queues based on ticket age.' => '',
        'Enable keep-alive connection header for SOAP responses.' => 'Activar a cabeceira da conexión manterse-viva para respostas SOAP.',
        'Enable this if you trust in all your public and private pgp keys, even if they are not certified with a trusted signature.' =>
            '',
        'Enabled filters.' => 'Filtros activos.',
        'Enables PGP support. When PGP support is enabled for signing and encrypting mail, it is HIGHLY recommended that the web server runs as the OTRS user. Otherwise, there will be problems with the privileges when accessing .gnupg folder.' =>
            'Activa a compatibilidade con PGP. Cando a compatibilidade con PGP está activada para asinar e cifrar correo, recoméndase MOITO que o servidor web se execute como usuario OTRS. Caso contrario, haberá problemas cos privilexios ao acceder ao cartafol .gnupg.',
        'Enables S/MIME support.' => 'Activa a compatibilidade con S/MIME.',
        'Enables customers to create their own accounts.' => 'Permite que os clientes creen as súas propias contas.',
        'Enables fetch S/MIME from CustomerUser backend support.' => '',
        'Enables file upload in the package manager frontend.' => 'Activa o envío de ficheiros na interface do xestor de paquetes.',
        'Enables or disables the caching for templates. WARNING: Do NOT disable template caching for production environments for it will cause a massive performance drop! This setting should only be disabled for debugging reasons!' =>
            'Activa ou desactiva o cacheado de modelos. ALERTA: NON desactive cacheado para contorno de producción para él pois causará unha baixada do rendemento! Este axuste soamente debe ser desactivado por razóns de debugging!',
        'Enables or disables the debug mode over frontend interface.' => 'Activa ou desactiva o modo debug sobre a interface frontend.',
        'Enables or disables the ticket watcher feature, to keep track of tickets without being the owner nor the responsible.' =>
            'Activa ou desactiva a función visor de ticket, para ter un seguemento de tickets sen ser o propietario nin o responsable.',
        'Enables performance log (to log the page response time). It will affect the system performance. Frontend::Module###AdminPerformanceLog must be enabled.' =>
            'Active o log de rendemento (para facer log do tempo de resposta da páxina). Vai afectar o rendemento do sistema. Frontend::Module###AdminPerformanceLog bebe ser activado.',
        'Enables the minimal ticket counter size (if "Date" was selected as TicketNumberGenerator).' =>
            'Permite o tamaño de contador de ticket mínimo (se "Data" foi seleccionado como TicketNumberGenerator)',
        'Enables ticket bulk action feature for the agent frontend to work on more than one ticket at a time.' =>
            'Permite función de acción en masa do ticket para o frontend de axente para traballar en máis dun ticket á vez.',
        'Enables ticket bulk action feature only for the listed groups.' =>
            'Permite función de acción en masa de ticket soamente para os grupos enumerados.',
        'Enables ticket responsible feature, to keep track of a specific ticket.' =>
            'Permite función responsable de ticket, para seguimento dun ticket específico.',
        'Enables ticket type feature.' => '',
        'Enables ticket watcher feature only for the listed groups.' => 'Permite función de visor de ticket soamente para os grupos listados.',
        'English (Canada)' => '',
        'English (United Kingdom)' => '',
        'English (United States)' => '',
        'English stop words for fulltext index. These words will be removed from the search index.' =>
            '',
        'Enroll process for this ticket' => '',
        'Enter your shared secret to enable two factor authentication. WARNING: Make sure that you add the shared secret to your generator application and the application works well. Otherwise you will be not able to login anymore without the two factor token.' =>
            '',
        'Escalated Tickets' => 'Escalado Tickets',
        'Escalation view' => 'Vista Escalado',
        'EscalationTime' => 'TempoEscalado',
        'Estonian' => '',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate).' =>
            'Rexistro módulo evento. Para maior rendemento pode definir un disparador de evento (ex. Event => CrearTicket).',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate). This is only possible if all Ticket dynamic fields need the same event.' =>
            'Rexistro módulo evento. Para maior rendemento pode definir un disparador de evento (ex. Event => CrearTicket). Isto só e posible se tódolos campos dinámicos de Ticket necesitan o mesmo evento.',
        'Event module that performs an update statement on TicketIndex to rename the queue name there if needed and if StaticDB is actually used.' =>
            'Módulo de evento que executa unha sentenza de actualización en IndiceTicket para renomear o nombe da cola se necesario e se StaticDB e usado actualmente.',
        'Event module that updates customer company object name for dynamic fields.' =>
            '',
        'Event module that updates customer user object name for dynamic fields.' =>
            '',
        'Event module that updates customer user search profiles if login changes.' =>
            '',
        'Event module that updates customer user service membership if login changes.' =>
            'Módulo de evento que actualiza a afiliación ao servizo de usuario do cliente se o login cambia.',
        'Event module that updates customer users after an update of the Customer.' =>
            'Módulo de evento que actualiza os usuarios clientes despois de unha actualización de Cliente.',
        'Event module that updates tickets after an update of the Customer User.' =>
            'Módulo de evento que actualiza os tickets despois dunha actualización do Cliente Usuario.',
        'Event module that updates tickets after an update of the Customer.' =>
            'Módulo evento que actualiza os tickets despois dunha actualización do Cliente.',
        'Events Ticket Calendar' => 'Clendario Eventos Ticket',
        'Example package autoload configuration.' => '',
        'Execute SQL statements.' => 'Executar sentenzas SQL.',
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
            'Exporta á árbore do artigo completo no resultado da busca (esto pode afectar o rendemento do sistema).',
        'External' => '',
        'External Link' => '',
        'Fetch emails via fetchmail (using SSL).' => '',
        'Fetch emails via fetchmail.' => '',
        'Fetch incoming emails from configured mail accounts.' => '',
        'Fetches packages via proxy. Overwrites "WebUserAgent::Proxy".' =>
            'Obtén paquetes a través dun proxy. Substitúe «WebUserAgent::Proxy».',
        'File that is displayed in the Kernel::Modules::AgentInfo module, if located under Kernel/Output/HTML/Templates/Standard/AgentInfo.tt.' =>
            '',
        'Filter for debugging ACLs. Note: More ticket attributes can be added in the format <OTRS_TICKET_Attribute> e.g. <OTRS_TICKET_Priority>.' =>
            'Filtro para debug ACLs. Nota: Mais atributos de tickets poden ser engadidos no formato <OTRS_TICKET_Atribute> ex. <OTRS_TICKET_Priority>.',
        'Filter for debugging Transitions. Note: More filters can be added in the format <OTRS_TICKET_Attribute> e.g. <OTRS_TICKET_Priority>.' =>
            'Filtro para debug Transicións. Nota: Mais filtros poden ser engadidos no formato <OTRS_TICKET_Atributte> ex. <OTRS_TICKET_Priority>.',
        'Filter incoming emails.' => 'Filtro para correos electrónicos entrantes.',
        'Finnish' => '',
        'First Christmas Day' => 'Primeiro día de Nadal.',
        'First Queue' => 'Primeira Cola',
        'First response time' => '',
        'FirstLock' => 'PrimeiroBloqueo',
        'FirstResponse' => 'PrimeiraResposta',
        'FirstResponseDiffInMin' => 'PrimeiraRespostaDifEnMin',
        'FirstResponseInMin' => 'PrimeiraRespostaEnMin',
        'Firstname Lastname' => 'Nome Apelidos',
        'Firstname Lastname (UserLogin)' => 'Nome Apelidos (UsuarioLogin)',
        'For these state types the ticket numbers are striked through in the link table.' =>
            '',
        'Force the storage of the original article text in the article search index, without executing filters or applying stop word lists. This will increase the size of the search index and thus may slow down fulltext searches.' =>
            '',
        'Forces encoding of outgoing emails (7bit|8bit|quoted-printable|base64).' =>
            'Forza codificar os correos electrónicos de saída (7bit|8bit|quoted-printable|base64).',
        'Forces to choose a different ticket state (from current) after lock action. Define the current state as key, and the next state after lock action as content.' =>
            'Forza a elexir un estado de ticket diferente (do actual) despois da acción de bloqueo. Define o estado actual coma chave, e o seguinte estado despois da acción de bloqueo coma contido.',
        'Forces to unlock tickets after being moved to another queue.' =>
            'Forza a desbloquear tickets despois de ser movidos a outra cola.',
        'Forwarded to "%s".' => 'Encamiñado a «%s».',
        'Free Fields' => 'Campos libres',
        'French' => '',
        'French (Canada)' => '',
        'French stop words for fulltext index. These words will be removed from the search index.' =>
            '',
        'Frontend' => '',
        'Frontend module registration (disable AgentTicketService link if Ticket Service feature is not used).' =>
            '',
        'Frontend module registration (disable company link if no company feature is used).' =>
            'Rexistro módulo frontend (desactivar enlace compañía se á función compañía non é usada).',
        'Frontend module registration (disable ticket processes screen if no process available) for Customer.' =>
            'Rexistro módulo frontend (desactivar pantalla proceso ticket se non hai proceso dispoñible) para Cliente.',
        'Frontend module registration (disable ticket processes screen if no process available).' =>
            'Rexistro módulo frontend (desactivar pantalla proceso ticket se non hai proceso dispoñible).',
        'Frontend module registration (show personal favorites as sub navigation items of \'Admin\').' =>
            '',
        'Frontend module registration for the agent interface.' => 'Rexistro módulo frontend para a interface de axente.',
        'Frontend module registration for the customer interface.' => 'Rexistro módulo frontend para a interface de cliente.',
        'Frontend module registration for the public interface.' => '',
        'Full value' => '',
        'Fulltext index regex filters to remove parts of the text.' => 'Filtros expresión regular índice de texto completo para eliminar partes do texto.',
        'Fulltext search' => 'Busca de texto completo',
        'Galician' => '',
        'General ticket data shown in the ticket overviews (fall-back). Note that TicketNumber can not be disabled, because it is necessary.' =>
            '',
        'Generate dashboard statistics.' => '',
        'Generic Info module.' => '',
        'GenericAgent' => 'AxenteXenérico',
        'GenericInterface Debugger GUI' => 'InterfaceXenérica Depurador GUI',
        'GenericInterface ErrorHandling GUI' => '',
        'GenericInterface Invoker Event GUI' => '',
        'GenericInterface Invoker GUI' => 'InterfaceXenérica Invocador GUI',
        'GenericInterface Operation GUI' => 'InterfaceXenérica Operación GUI',
        'GenericInterface TransportHTTPREST GUI' => 'InterfaceXenérica TransporteHTTPREST GUI',
        'GenericInterface TransportHTTPSOAP GUI' => 'InterfaceXenérica TransporteHTTPSOAP GUI',
        'GenericInterface Web Service GUI' => 'InterfaceXenérica Servizo Web GUI',
        'GenericInterface Web Service History GUI' => '',
        'GenericInterface Web Service Mapping GUI' => '',
        'GenericInterface module registration for an error handling module.' =>
            '',
        'GenericInterface module registration for the invoker layer.' => 'InterfaceXenérica módulo rexistro para a capa do invocador.',
        'GenericInterface module registration for the mapping layer.' => 'InterfaceXenérica módulo rexistro para a capa do mapeado.',
        'GenericInterface module registration for the operation layer.' =>
            'InterfaceXenérica módulo rexistro para a capa de operación.',
        'GenericInterface module registration for the transport layer.' =>
            'InterfaceXenérica módulo rexistro para a capa de transporte.',
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
            'Se "BD" foi seleccionada para Customer::AuthModule, un driver de base de datos (normalmente autodetección é usado) pode ser especificado.',
        'If "DB" was selected for Customer::AuthModule, a password to connect to the customer table can be specified.' =>
            'Se "BD" foi seleccionada para Customer::AuthModule, un contrasinal para conectar a táboa de cliente pode ser especificada.',
        'If "DB" was selected for Customer::AuthModule, a username to connect to the customer table can be specified.' =>
            'Se "BD" foi seleccionada para Customer::AuthModule, un nome de usuario para conectar á táboa de cliente pode ser especificado.',
        'If "DB" was selected for Customer::AuthModule, the DSN for the connection to the customer table must be specified.' =>
            'Se "BD" foi seleccionada para Customer::AuthModule, un DSN para conectar á táboa de cliente debe ser especificado.',
        'If "DB" was selected for Customer::AuthModule, the column name for the CustomerPassword in the customer table must be specified.' =>
            'Se "BD" foi seleccionada para Customer::AuthModule, o nome de columna para o ContrasinalCliente na táboa de cliente debe ser especificado.',
        'If "DB" was selected for Customer::AuthModule, the encryption type of passwords must be specified.' =>
            '',
        'If "DB" was selected for Customer::AuthModule, the name of the column for the CustomerKey in the customer table must be specified.' =>
            'Se "BD" foi seleccionada para Customer::AuthModule, un nome de columna para ChaveCliente na táboa de cliente debe ser especificado.',
        'If "DB" was selected for Customer::AuthModule, the name of the table where your customer data should be stored must be specified.' =>
            'Se "BD" foi seleccionada para Customer::AuthModule, un nome da táboa onde os datos do cliente deben ser gardados debe ser especificado.',
        'If "DB" was selected for SessionModule, a table in database where session data will be stored must be specified.' =>
            'Se "BD" foi seleccionada para MóduloSesión, a táboa na base de datos onde os datos de sesión serán gardados debe ser especificada.',
        'If "FS" was selected for SessionModule, a directory where the session data will be stored must be specified.' =>
            'Se "FS" foi seleccionado para MóduloSesión, o directorio onde os datos de sesión serán gardados debe ser especificado.',
        'If "HTTPBasicAuth" was selected for Customer::AuthModule, you can specify (by using a RegExp) to strip parts of REMOTE_USER (e. g. for to remove trailing domains). RegExp-Note, $1 will be the new Login.' =>
            'Se "HTTPBasicAuth" foi seleccionado para Customer::AuthModule, pode especificar (usando ExpReg) espir partes de REMOTE_USER (ex. para eliminar dominios trailing). Nota-ExpReg, $1 vai ser o novo Login.',
        'If "HTTPBasicAuth" was selected for Customer::AuthModule, you can specify to strip leading parts of user names (e. g. for domains like example_domain\user to user).' =>
            'Se "HTTPBasicAuth" foi seleccionado para Customer::AuthModule, pode especificar espir partes líderes de nomes de usuarios (ex. para dominios como example_domain\user a usuario ). ',
        'If "LDAP" was selected for Customer::AuthModule and if you want to add a suffix to every customer login name, specifiy it here, e. g. you just want to write the username user but in your LDAP directory exists user@domain.' =>
            'Se "LDAP" foi seleccionado para Customer::AuthModule e se quere engadir un sufixo a cada nome login de cliente, especifíqueo aquí, ex. vostede quere soamente escribir o usuario do nome de usuario pero no seu directorio LDAP existe usuario@domain.',
        'If "LDAP" was selected for Customer::AuthModule and special paramaters are needed for the Net::LDAP perl module, you can specify them here. See "perldoc Net::LDAP" for more information about the parameters.' =>
            'Se "LDAP" foi seleccionado para Customer::AuthModule e os carácteres especiais son necesitados para o módulo perl Net::LDAP, pode especificalos aquí. Vexa "perldoc Net::LDAP" para mais información sobre os parámetros.',
        'If "LDAP" was selected for Customer::AuthModule and your users have only anonymous access to the LDAP tree, but you want to search through the data, you can do this with a user who has access to the LDAP directory. Specify the password for this special user here.' =>
            'Se "LDAP" foi seleccionado para Customer::AuthModule e teus usuarios soamente teñen acceso anónimo a árbore LDAP, pero queres buscar a través dos datos, vostede pode facelo cun usuario que ten acceso ao directorio do LDAP. Especifique o conrasinal deste usuario especial aquí.',
        'If "LDAP" was selected for Customer::AuthModule and your users have only anonymous access to the LDAP tree, but you want to search through the data, you can do this with a user who has access to the LDAP directory. Specify the username for this special user here.' =>
            'Se "LDAP" foi seleccionado para Customer::AuthModule e teus usuarios soamente teñen acceso anónimo a árbore LDAP, pero queres buscar a través dos datos, vostede pode facelo cun usuario que ten acceso ao directorio do LDAP. Especifique o nome de usuario deste usuario especial aquí.',
        'If "LDAP" was selected for Customer::AuthModule, the BaseDN must be specified.' =>
            'Se "LDAP" foi seleccionado para Customer::AuthModule, o BaseDN debe ser especificado.',
        'If "LDAP" was selected for Customer::AuthModule, the LDAP host can be specified.' =>
            'Se "LDAP" foi seleccionado para Customer::AuthModule, o hots do LDAP pode ser especificado.',
        'If "LDAP" was selected for Customer::AuthModule, the user identifier must be specified.' =>
            'Se "LDAP" foi seleccionado para Customer::AuthModule, o identificador de usuario debe ser especificado.',
        'If "LDAP" was selected for Customer::AuthModule, user attributes can be specified. For LDAP posixGroups use UID, for non LDAP posixGroups use full user DN.' =>
            'Se "LDAP" foi seleccionado para Customer::AuthModule, os atributos de usuario poden ser especificado. Para LDAP posixGrupos use UID, para non LDAP posixGrupos use o usuario completo DN.',
        'If "LDAP" was selected for Customer::AuthModule, you can specify access attributes here.' =>
            'Se "LDAP" foi seleccionado para Customer::AuthModule, pode especificar os atributos de acceso aquí.',
        'If "LDAP" was selected for Customer::AuthModule, you can specify if the applications will stop if e. g. a connection to a server can\'t be established due to network problems.' =>
            'Se "LDAP" foi seleccionado para Customer::AuthModule, vostede pode especificar se as aplicacións van parar se ex. a concexión co servidor non pode ser establecida debido a problemas na rede.',
        'If "LDAP" was selected for Customer::Authmodule, you can check if the user is allowed to authenticate because he is in a posixGroup, e.g. user needs to be in a group xyz to use OTRS. Specify the group, who may access the system.' =>
            'Se "LDAP" foi seleccionado para Customer::AuthModule, pode comprobar se o usuario ten permitido autenticarse porque el está no posixGrupo, ex. usuario precisa estar no grupo xyz para usar OTRS. Especifica el grupo, quien puede acceder al sistema.',
        'If "LDAP" was selected, you can add a filter to each LDAP query, e.g. (mail=*), (objectclass=user) or (!objectclass=computer).' =>
            'Se "LDAP" foi seleccionado, pode engadir un filtro para cada consulta LDAP, ex. (mail=*), (objectclass=user) ou (!objectclass=computer).',
        'If "Radius" was selected for Customer::AuthModule, the password to authenticate to the radius host must be specified.' =>
            'Se "Radio" foi seleccionado para Customer::AuthModule, o contrasinal para autenticarse ao host do radio debe ser especificado.',
        'If "Radius" was selected for Customer::AuthModule, the radius host must be specified.' =>
            'Se "Radio" foi seleccionado para Customer::AuthModule, o host do radio debe ser especificado.',
        'If "Radius" was selected for Customer::AuthModule, you can specify if the applications will stop if e. g. a connection to a server can\'t be established due to network problems.' =>
            'Se "Radio" foi seleccionado para Customer::AuthModule, pode especificar se as aplicacións van parar se ex. unha conexión a un servidor non pode ser establecida debido a problemas na rede.',
        'If "Sendmail" was selected as SendmailModule, the location of the sendmail binary and the needed options must be specified.' =>
            'Se "Enviarmail" foi seleccionado coma EnviarmailModule, a localización do binario sendmail e as opcións necesitadas deben ser especificadas.',
        'If "SysLog" was selected for LogModule, a special log facility can be specified.' =>
            'Se "SysLog" foi seleccionado para LogModulo, unha instalación especial de log pode ser especificada.',
        'If "SysLog" was selected for LogModule, the charset that should be used for logging can be specified.' =>
            'Se "SysLog" foi seleccionado para LogModulo, o conxunto de carácteres que debe ser usado para logearse pode ser especificado.',
        'If "bcrypt" was selected for CryptType, use cost specified here for bcrypt hashing. Currently max. supported cost value is 31.' =>
            '',
        'If "file" was selected for LogModule, a logfile must be specified. If the file doesn\'t exist, it will be created by the system.' =>
            'Se "Arquivo" foi seleccionado para LogModulo, un arquivo log debe ser especificado. Se o arquivo non existe, será creado polo sistema.',
        'If active, none of the regular expressions may match the user\'s email address to allow registration.' =>
            'Se activo, ninguna das expresións regulares poden coincidir  co enderezo de correo electrónico do usuario para permitir o rexistro.',
        'If active, one of the regular expressions has to match the user\'s email address to allow registration.' =>
            'Se activo, unha das expresións regulares debe coincidir co enderezo de correo electrónico do usuario para permitir o rexistro.',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, and authentication to the mail server is needed, a password must be specified.' =>
            'Se calquera dos mecanismos "SMTP" foi seleccionado coma EnviarcorreoModulo, e necesítase a autenticación ao servidor de correo, un contrasinal debe ser especificado.',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, and authentication to the mail server is needed, an username must be specified.' =>
            'Se calquera dos mecanismos "SMTP" foi seleccionado coma EnviarcorreoModulo, e necesítase a autenticación ao servidor de correo, un nome de usuario debe ser especificado.',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, the mailhost that sends out the mails must be specified.' =>
            'Se calquera dos mecanismos "SMTP" foi seleccionado coma EnviarcorreoModulo, o hostcorreo que envía os correos debe ser especificado.',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, the port where your mailserver is listening for incoming connections must be specified.' =>
            'Se calquera dos mecanismos "SMTP" foi seleccionado coma EnviarcorreoModulo, o porto onde o seu servidorcorreo está a escoitar para conexións entrantes debe ser especificado.',
        'If enabled debugging information for ACLs is logged.' => 'Se habilitado a información de depuración para ACLs é introducida.',
        'If enabled debugging information for transitions is logged.' => 'Se habilitado a información de depuración para transicións é introducida.',
        'If enabled the daemon will redirect the standard error stream to a log file.' =>
            '',
        'If enabled the daemon will redirect the standard output stream to a log file.' =>
            '',
        'If enabled the daemon will use this directory to create its PID files. Note: Please stop the daemon before any change and use this setting only if <$OTRSHome>/var/run/ can not be used.' =>
            '',
        'If enabled, OTRS will deliver all CSS files in minified form.' =>
            '',
        'If enabled, OTRS will deliver all JavaScript files in minified form.' =>
            'Se habilitado, OTRS proporcionará tódolos arquivos JavaScript en forma minimizada.',
        'If enabled, TicketPhone and TicketEmail will be open in new windows.' =>
            'Se habilitado, TicketTelefónico e TicketEmail serán abertos en novas ventás.',
        'If enabled, the OTRS version tag will be removed from the Webinterface, the HTTP headers and the X-Headers of outgoing mails. NOTE: If you change this option, please make sure to delete the cache.' =>
            '',
        'If enabled, the cache data be held in memory.' => '',
        'If enabled, the cache data will be stored in cache backend.' => '',
        'If enabled, the customer can search for tickets in all services (regardless what services are assigned to the customer).' =>
            'Se habilitado, o cliente pode buscar tickets en tódolos servizos (independentemente de que servizos sexan asignados ao cliente).',
        'If enabled, the different overviews (Dashboard, LockedView, QueueView) will automatically refresh after the specified time.' =>
            'Se habilitado, as distintas vistas xerais (Cadro de mando, VistaBloqueada, VistaCola) recargará automaticamente despois do tempo especificado.',
        'If enabled, the first level of the main menu opens on mouse hover (instead of click only).' =>
            'Se habilitado, o primeiro nivel do menu principal abriráse o pasar o rato por enriba (en lugar de só o facer clic).',
        'If enabled, users that haven\'t selected a time zone yet will be notified to do so. Note: Notification will not be shown if (1) user has not yet selected a time zone and (2) OTRSTimeZone and UserDefaultTimeZone do match and (3) are not set to UTC.' =>
            '',
        'If no SendmailNotificationEnvelopeFrom is specified, this setting makes it possible to use the email\'s from address instead of an empty envelope sender (required in certain mail server configurations).' =>
            '',
        'If set, this address is used as envelope sender header in outgoing notifications. If no address is specified, the envelope sender header is empty (unless SendmailNotificationEnvelopeFrom::FallbackToEmailFrom is set).' =>
            '',
        'If set, this address is used as envelope sender in outgoing messages (not notifications - see below). If no address is specified, the envelope sender is equal to queue e-mail address.' =>
            'Se é fixado, este enderezo é utilizado como remitente de sobre en mensaxes de saída (non notificacións - vexa abaixo). Se ningún enderezo é especificado, o remitente de sobre é igual o enderezo de correo electrónico da cola.',
        'If this option is enabled, tickets created via the web interface, via Customers or Agents, will receive an autoresponse if configured. If this option is not enabled, no autoresponses will be sent.' =>
            '',
        'If this regex matches, no message will be send by the autoresponder.' =>
            'Se esta ExpReg coincide, ningún mensaxe vai ser enviado pola autoresposta.',
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
            '',
        'Include unknown customers in ticket filter.' => '',
        'Includes article create times in the ticket search of the agent interface.' =>
            'Inclúe tempo creación artigo na busca de ticket da interface de axente.',
        'Incoming Phone Call.' => '',
        'IndexAccelerator: to choose your backend TicketViewAccelerator module. "RuntimeDB" generates each queue view on the fly from ticket table (no performance problems up to approx. 60.000 tickets in total and 6.000 open tickets in the system). "StaticDB" is the most powerful module, it uses an extra ticket-index table that works like a view (recommended if more than 80.000 and 6.000 open tickets are stored in the system). Use the command "bin/otrs.Console.pl Maint::Ticket::QueueIndexRebuild" for initial index creation.' =>
            '',
        'Indicates if a bounce e-mail should always be treated as normal follow-up.' =>
            '',
        'Indonesian' => '',
        'Inline' => '',
        'Input' => '',
        'Interface language' => 'Idioma da interface',
        'Internal communication channel.' => '',
        'International Workers\' Day' => 'Día do Traballo',
        'It is possible to configure different skins, for example to distinguish between diferent agents, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            'É posible configurar aparencias diferentes, para por exemplo distinguir entre axentes diferentes, para ser utilizados nunha base de por dominio dentro da aplicación. Utilizando unha expresión regular (regex), vostede pode configurar un Chave/Contido par para coincidir un dominio. O valor en "Chave" debería coincidir co dominio, e o valor en "Contido" debería ser unha apariencia válida no seu sistema. Por favor vexa as entradas de exemplo para a forma correcta da regex.',
        'It is possible to configure different skins, for example to distinguish between diferent customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            'É posible configurar aparencias diferentes, para por exemplo distinguir entre clientes diferentes, para ser utilizados nunha base de por dominio dentro da aplicación. Utilizando unha expresión regular (regex), vostede pode configurar un Chave/Contido par para coincidir un dominio. O valor en "Chave" debería coincidir co dominio, e o valor en "Contido" debería ser unha aparencia válida no seu sistema. Por favor vexa as entradas de exemplo para a forma correcta do regex.',
        'It is possible to configure different themes, for example to distinguish between agents and customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid theme on your system. Please see the example entries for the proper form of the regex.' =>
            'É posible configurar temas diferentes, para por exemplo distinguir entre axentes e clientes, para ser utilizados nunha base de por dominio dentro da aplicación. Utilizando unha expresión regular (regex), vostede pode configurar un Chave/Contido par para igualar un dominio. O valor en "Chave" debería coincidir co dominio, e o valor en "Contido" debería ser unha tema válido no seu sistema. Por favor vexa as entradas de exemplo para a forma correcta do regex.',
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
        'Language' => 'Idioma',
        'Large' => 'Grande',
        'Last Screen Overview' => '',
        'Last customer subject' => '',
        'Lastname Firstname' => '',
        'Lastname Firstname (UserLogin)' => '',
        'Lastname, Firstname' => 'Apelido, Nome',
        'Lastname, Firstname (UserLogin)' => 'Apelido, Nome (Nome de usuario)',
        'LastnameFirstname' => '',
        'Latvian' => '',
        'Left' => 'Esquerda',
        'Link Object' => 'Ligar o obxecto',
        'Link Object.' => '',
        'Link agents to groups.' => 'Ligar axentes a grupos.',
        'Link agents to roles.' => 'Ligar axentes a papeis.',
        'Link customer users to customers.' => '',
        'Link customer users to groups.' => '',
        'Link customer users to services.' => '',
        'Link customers to groups.' => '',
        'Link queues to auto responses.' => 'Enlaza colas con auto respostas.',
        'Link roles to groups.' => 'Ligar papeis a grupos.',
        'Link templates to attachments.' => '',
        'Link templates to queues.' => 'Ligar modelos a filas.',
        'Link this ticket to other objects' => 'Vincule este Ticket con outros obxetos',
        'Links 2 tickets with a "Normal" type link.' => 'Enlaza 2 tickets con tipo de enlace "Normal".',
        'Links 2 tickets with a "ParentChild" type link.' => 'Enlaza 2 tickets con tipo de enlace "PaiFillo".',
        'Links appointments and tickets with a "Normal" type link.' => '',
        'List of CSS files to always be loaded for the agent interface.' =>
            'Lista de arquivos CSS para estar sempre cargados para a interface de axente.',
        'List of CSS files to always be loaded for the customer interface.' =>
            'Lista de arquivos CSS para estar sempre cargados para a interface de cliente.',
        'List of JS files to always be loaded for the agent interface.' =>
            'Lista de arquivos JS para estar sempre cargados para a interface de axente.',
        'List of JS files to always be loaded for the customer interface.' =>
            'Lista de arquivos JS para estar sempre cargados para a interface de cliente.',
        'List of all CustomerCompany events to be displayed in the GUI.' =>
            'Lista de tódolos eventos de ClienteCompañia para ser mostrados na GUI.',
        'List of all CustomerUser events to be displayed in the GUI.' => 'Lista de tódolos eventos de ClienteUsuario para ser mostrados na GUI.',
        'List of all DynamicField events to be displayed in the GUI.' => 'Lista de tódolos eventos de CampoDinamico para ser mostrados na GUI.',
        'List of all LinkObject events to be displayed in the GUI.' => '',
        'List of all Package events to be displayed in the GUI.' => 'Lista de eventos de paquete que se mostran na interface gráfica.',
        'List of all appointment events to be displayed in the GUI.' => '',
        'List of all article events to be displayed in the GUI.' => 'Lista de tódolos eventos de artigo para ser mostrados na GUI.',
        'List of all calendar events to be displayed in the GUI.' => '',
        'List of all queue events to be displayed in the GUI.' => 'Lista de tódolos eventos de cola para ser mostrados na GUI.',
        'List of all ticket events to be displayed in the GUI.' => 'Lista de tódolos eventos de ticket para ser mostrados na GUI.',
        'List of colors in hexadecimal RGB which will be available for selection during calendar creation. Make sure the colors are dark enough so white text can be overlayed on them.' =>
            '',
        'List of default Standard Templates which are assigned automatically to new Queues upon creation.' =>
            'Lista de los Modelos Estandard por defecto os cales son asignados automaticamente a novas Colas sobre á creación.',
        'List of responsive CSS files to always be loaded for the agent interface.' =>
            '',
        'List of responsive CSS files to always be loaded for the customer interface.' =>
            '',
        'List view' => 'Vista de lista',
        'Lithuanian' => '',
        'Loader module registration for the agent interface.' => '',
        'Loader module registration for the customer interface.' => '',
        'Lock / unlock this ticket' => '',
        'Locked Tickets' => 'Tíckets bloqueados',
        'Locked Tickets.' => '',
        'Locked ticket.' => 'Tícket bloqueado.',
        'Logged in users.' => '',
        'Logged-In Users' => '',
        'Logout of customer panel.' => '',
        'Look into a ticket!' => 'Mire nun Ticket!',
        'Loop protection: no auto-response sent to "%s".' => '',
        'Macedonian' => '',
        'Mail Accounts' => 'Contas de correo',
        'MailQueue configuration settings.' => '',
        'Main menu item registration.' => '',
        'Main menu registration.' => 'Rexistro menú principal.',
        'Makes the application block external content loading.' => '',
        'Makes the application check the MX record of email addresses before sending an email or submitting a telephone or email ticket.' =>
            'Fai a aplicación comprobar o rexistro MX de enderezos de correo electrónico antes de enviar un correo electrónico ou o envío dun ticket de teléfono ou de correo electrónico.',
        'Makes the application check the syntax of email addresses.' => 'Fai a aplicación comprobar a sintaxe do enderezo de correo electrónico.',
        'Makes the session management use html cookies. If html cookies are disabled or if the client browser disabled html cookies, then the system will work as usual and append the session id to the links.' =>
            'Fai a xestión da sesión usar cookies de html. Se as cookies html están deshabilitadas ou o cliente do navegador ten as cookies deshabilitadas, logo o sistema traballará coma normalmente é agregará o id da sesión aos enlaces.',
        'Malay' => '',
        'Manage OTRS Group cloud services.' => '',
        'Manage PGP keys for email encryption.' => 'Xestionar as claves de PGP para o cifrado do correo.',
        'Manage POP3 or IMAP accounts to fetch email from.' => 'Xestionar as contas POP3 ou IMAP das que obter o correo.',
        'Manage S/MIME certificates for email encryption.' => 'Xestionar os certificados S/MIME para o cifrado do correo.',
        'Manage System Configuration Deployments.' => '',
        'Manage different calendars.' => '',
        'Manage existing sessions.' => 'Xestionar as sesións existentes.',
        'Manage support data.' => '',
        'Manage system registration.' => 'Xestionar o rexistro no sistema.',
        'Manage tasks triggered by event or time based execution.' => 'Dirixa tarefas disparadas por evento ou baseadas no tempo de execución.',
        'Mark as Spam!' => 'Marcar como lixo!',
        'Mark this ticket as junk!' => '',
        'Max size (in characters) of the customer information table (phone and email) in the compose screen.' =>
            'Tamaño máximo (en carácteres) da táboa de información de cliente (teléfono e correo electrónico) na pantalla composta.',
        'Max size (in rows) of the informed agents box in the agent interface.' =>
            'Tamaño máximo (en filas) da caixa de axentes informados na interface de axente.',
        'Max size (in rows) of the involved agents box in the agent interface.' =>
            'Tamaño máximo (en filas) da caixa de axentes implicados na interface de axente.',
        'Max size of the subjects in an email reply and in some overview screens.' =>
            '',
        'Maximal auto email responses to own email-address a day (Loop-Protection).' =>
            'Maximas auto respostas de correo electrónico que son propiedade dun enderezo de correo electrónico por día (Protección de Bucle).',
        'Maximal auto email responses to own email-address a day, configurable by email address (Loop-Protection).' =>
            '',
        'Maximal size in KBytes for mails that can be fetched via POP3/POP3S/IMAP/IMAPS (KBytes).' =>
            'Tamaño máximo en KBytes para correos que poden ser recuperados vía POP3/POP3S/IMAP/IMAPS (KBytes).',
        'Maximum Number of a calendar shown in a dropdown.' => '',
        'Maximum length (in characters) of the dynamic field in the article of the ticket zoom view.' =>
            'Máxima lonxitude (en carácteres) do campo dinámico no artigo da vista zoom de ticket.',
        'Maximum length (in characters) of the dynamic field in the sidebar of the ticket zoom view.' =>
            'Máxima lonxitude (en carácteres) do campo dinámico na barra lateral da vista zoom de ticket.',
        'Maximum number of active calendars in overview screens. Please note that large number of active calendars can have a performance impact on your server by making too much simultaneous calls.' =>
            '',
        'Maximum number of tickets to be displayed in the result of a search in the agent interface.' =>
            'Número máximo de tickets para ser mostrados no resultado dunha busca na interface de axente.',
        'Maximum number of tickets to be displayed in the result of a search in the customer interface.' =>
            'Número máximo de tickets para ser mostrados no resultado dunha busca na interface de cliente.',
        'Maximum number of tickets to be displayed in the result of this operation.' =>
            'Número máximo de tickets para ser mostrados no resultado desta operación.',
        'Maximum size (in characters) of the customer information table in the ticket zoom view.' =>
            'Tamaño máximo (en carácteres) da táboa de información de cliente na vista zoom de ticket.',
        'Medium' => 'Medio',
        'Merge this ticket and all articles into another ticket' => '',
        'Merged Ticket (%s/%s) to (%s/%s).' => '',
        'Merged Ticket <OTRS_TICKET> to <OTRS_MERGE_TO_TICKET>.' => '',
        'Minute' => '',
        'Miscellaneous' => '',
        'Module for To-selection in new ticket screen in the customer interface.' =>
            'Módulo para selección-A na pantalla novo ticket na interface de axente.',
        'Module to check if a incoming e-mail message is bounce.' => '',
        'Module to check if arrived emails should be marked as internal (because of original forwarded internal email). IsVisibleForCustomer and SenderType define the values for the arrived email/article.' =>
            '',
        'Module to check the group permissions for customer access to tickets.' =>
            '',
        'Module to check the group permissions for the access to tickets.' =>
            '',
        'Module to compose signed messages (PGP or S/MIME).' => 'Módulo para redactar mensaxes asinadas (PGP ou S/MIME).',
        'Module to define the email security options to use (PGP or S/MIME).' =>
            '',
        'Module to encrypt composed messages (PGP or S/MIME).' => '',
        'Module to fetch customer users SMIME certificates of incoming messages.' =>
            '',
        'Module to filter and manipulate incoming messages. Block/ignore all spam email with From: noreply@ address.' =>
            'Módulo para filtrar e manipular as mensaxes entrantes. Bloquea/Ignora todo o correo lixo con enderezo From: noreply@.',
        'Module to filter and manipulate incoming messages. Get a 4 digit number to ticket free text, use regex in Match e. g. From => \'(.+?)@.+?\', and use () as [***] in Set =>.' =>
            'Módulo para filtrar e manipular mensaxes entrantes. Leve un número de 4 díxitos ao texto libre de ticket, use regex en Coincidir ex. De => \'(.+?)@.+?\', e use () coma [***] en Establecer =>.',
        'Module to filter encrypted bodies of incoming messages.' => '',
        'Module to generate accounted time ticket statistics.' => 'Módulo para xenerar estatísticas de tempo empregado no ticket.',
        'Module to generate html OpenSearch profile for short ticket search in the agent interface.' =>
            'Módulo para xerar perfíl html BuscaAberta para busca ticket curta na interface de axente.',
        'Module to generate html OpenSearch profile for short ticket search in the customer interface.' =>
            'Módulo para xerar perfíl html BuscaAberta para busca ticket curta na interface de cliente.',
        'Module to generate ticket solution and response time statistics.' =>
            'Módulo para xerar estatísticas de tempo de solución e resposta de ticket.',
        'Module to generate ticket statistics.' => 'Módulo para xerar estatísticas de ticket.',
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
            'Módulo para mostrar notificacións e escalados (MostrarMax: max. escalados mostrados, EscaladoEnMinutos: Mostra o ticket o cal será escalado en, TempoCache: Cache dos escalados calculados en segundos).',
        'Module to use database filter storage.' => 'Módulo para empregar o almacenamento de filtros da base de datos.',
        'Module used to detect if attachments are present.' => '',
        'Multiselect' => 'Multiselección',
        'My Queues' => 'As miñas filas',
        'My Services' => 'Os meus servizos',
        'My Tickets.' => '',
        'Name of custom queue. The custom queue is a queue selection of your preferred queues and can be selected in the preferences settings.' =>
            'Nome da fila personalizada. A fila personalizada é unha selección de filas das súas filas preferidas e pode ser seleccionada nas preferencias.',
        'Name of custom service. The custom service is a service selection of your preferred services and can be selected in the preferences settings.' =>
            'Nome do servizo personalizado. O servizo personalizado é unha selección de servizos dos seus servizos preferidos e pode ser seleccionado nas preferencias.',
        'NameX' => 'NomeX',
        'New Ticket' => 'Novo Ticket',
        'New Tickets' => 'Novos Tickets',
        'New Window' => 'Nova xanela',
        'New Year\'s Day' => 'Aninovo',
        'New Year\'s Eve' => 'Fin de ano',
        'New process ticket' => 'Novo ticket de proceso',
        'News about OTRS releases!' => 'Novas sobre as versións novas de OTRS!',
        'News about OTRS.' => '',
        'Next possible ticket states after adding a phone note in the ticket phone inbound screen of the agent interface.' =>
            'Próximos estados posibles de ticket despois de engadir unha nota de teléfono na pantalla ticket de chamada entrante da interface de axente.',
        'Next possible ticket states after adding a phone note in the ticket phone outbound screen of the agent interface.' =>
            'Próximos estados posibles de ticket despois de engadir unha nota de teléfono na pantalla ticket de chamada saínte da interface de axente.',
        'No public key found.' => '',
        'No valid OpenPGP data found.' => '',
        'None' => 'Ningún',
        'Norwegian' => '',
        'Notification Settings' => '',
        'Notified about response time escalation.' => '',
        'Notified about solution time escalation.' => '',
        'Notified about update time escalation.' => '',
        'Number of displayed tickets' => 'Número de tickets mostrados.',
        'Number of lines (per ticket) that are shown by the search utility in the agent interface.' =>
            'Número de liñas (por ticket) que son mostrados pola utilidade de busca na interface de axente.',
        'Number of tickets to be displayed in each page of a search result in the agent interface.' =>
            'Número de tickets para ser mostrados en cada páxina dun resultado de busca na interface de axente.',
        'Number of tickets to be displayed in each page of a search result in the customer interface.' =>
            'Número de tickets para ser mostrados en cada páxina dun resultado de busca na interface de cliente.',
        'Number of tickets to be displayed in each page.' => '',
        'OTRS Group Services' => '',
        'OTRS News' => 'Novas do OTRS',
        'OTRS can use one or more readonly mirror databases for expensive operations like fulltext search or statistics generation. Here you can specify the DSN for the first mirror database.' =>
            '',
        'OTRS doesn\'t support recurring Appointments without end date or number of iterations. During import process, it might happen that ICS file contains such Appointments. Instead, system creates all Appointments in the past, plus Appointments for the next N months (120 months/10 years by default).' =>
            '',
        'Open an external link!' => '',
        'Open tickets (customer user)' => 'Tíckets abertos (usuario cliente)',
        'Open tickets (customer)' => 'Tíckets abertos (cliente)',
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
        'Out Of Office' => 'Fóra da oficina',
        'Out Of Office Time' => 'Tempo fóra da oficina',
        'Out of Office users.' => '',
        'Overloads (redefines) existing functions in Kernel::System::Ticket. Used to easily add customizations.' =>
            'Sobrecargas (redefine) funcións existentes en Kernel::System::Ticket. Utilizado para engadir facilmente personalizacións.',
        'Overview Escalated Tickets.' => '',
        'Overview Refresh Time' => 'Vista Xeral Tempo Recarga',
        'Overview of all Tickets per assigned Queue.' => '',
        'Overview of all appointments.' => '',
        'Overview of all escalated tickets.' => '',
        'Overview of all open Tickets.' => 'Vista Xeral  de tódolos Tickets abertos.',
        'Overview of all open tickets.' => '',
        'Overview of customer tickets.' => '',
        'PGP Key' => 'Chave de PGP',
        'PGP Key Management' => 'Xestión Clave de PGP',
        'PGP Keys' => 'Chaves de PGP',
        'Package event module file a scheduler task for update registration.' =>
            'Paquete de archivo de módulo de evento un planificador de tarefas para rexistro de actualización.',
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
            'Os parámetros para o cadro de mando do backend do widget estado do id do cliente da interface de axente. "Grupo" é utilizado para restrinxir o acceso ao plugin (e. g. Grupo: admin;group1;group2;). "Defecto" determina se o plugin se permite por defecto ou se o usuario necesita activalo manualmente. "CacheTTLLocal" é o tempo de cache en minutos para o plugin.',
        'Parameters for the dashboard backend of the customer user information of the agent interface. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the customer user list overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'Os parámetros para o cadro de mando do backend da vista xeral da lista do cliente usuario da interface de axente. "Limite" e o número de entradas mostradas por defecto. "Grupo" é utilizado para restrinxir o acceso ao plugin (e. g. Grupo: admin;group1;group2;). "Defecto" determina se o plugin se permite por defecto ou se o usuario necesita activalo manualmente. "CacheTTLLocal" é o tempo de cache en minutos para o plugin.',
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
        'Parameters of the example SLA attribute Comment2.' => 'Parámetros do exemplo ANS atributo Comentario2.',
        'Parameters of the example queue attribute Comment2.' => 'Parámetros do exemplo cola atributo Comentario2.',
        'Parameters of the example service attribute Comment2.' => 'Parámetros do exemplo servizo atributo Comentario2.',
        'Parent' => 'Pai',
        'ParentChild' => '',
        'Path for the log file (it only applies if "FS" was selected for LoopProtectionModule and it is mandatory).' =>
            'Ruta do arquivo log (só aplica se "FS" foi seleccionado para MóduloProtecciónBucle e é obrigatorio).',
        'Pending time' => '',
        'People' => '',
        'Performs the configured action for each event (as an Invoker) for each configured web service.' =>
            '',
        'Permitted width for compose email windows.' => 'Anchura permitida para compoñer ventás de correo electrónico.',
        'Permitted width for compose note windows.' => 'Anchura permitida para compoñer ventás de nota.',
        'Persian' => '',
        'Phone Call Inbound' => 'Chamada entrante',
        'Phone Call Outbound' => 'Chamada saínte',
        'Phone Call.' => '',
        'Phone call' => 'Chamada de teléfono',
        'Phone communication channel.' => '',
        'Phone-Ticket' => 'Ticket-Teléfono',
        'Picture Upload' => '',
        'Picture upload module.' => '',
        'Picture-Upload' => 'Carga-Imaxe',
        'Plugin search' => '',
        'Plugin search module for autocomplete.' => '',
        'Polish' => '',
        'Portuguese' => '',
        'Portuguese (Brasil)' => '',
        'PostMaster Filters' => 'Filtros PostMaster',
        'PostMaster Mail Accounts' => 'Contas Correo PostMaster',
        'Print this ticket' => 'Imprima este Ticket',
        'Priorities' => 'Prioridades',
        'Process Management Activity Dialog GUI' => 'Diálogo de Actividade de Proceso de Xestión GUI',
        'Process Management Activity GUI' => 'Actividade de Proceso de Xestión GUI',
        'Process Management Path GUI' => 'Ruta Proceso Xestión GUI',
        'Process Management Transition Action GUI' => 'Acción Transición Proceso Xestión GUI',
        'Process Management Transition GUI' => 'Transición Proceso Xestión GUI',
        'Process Ticket.' => '',
        'Process pending tickets.' => '',
        'ProcessID' => 'IDProceso',
        'Processes & Automation' => '',
        'Product News' => 'Novas sobre o produto',
        'Protection against CSRF (Cross Site Request Forgery) exploits (for more info see https://en.wikipedia.org/wiki/Cross-site_request_forgery).' =>
            '',
        'Provides a matrix overview of the tickets per state per queue' =>
            '',
        'Provides customer users access to tickets even if the tickets are not assigned to a customer user of the same customer ID(s), based on permission groups.' =>
            '',
        'Public Calendar' => '',
        'Public calendar.' => '',
        'Queue view' => 'Vista Cola',
        'Queues ↔ Auto Responses' => '',
        'Rebuild the ticket index for AgentTicketQueue.' => '',
        'Recognize if a ticket is a follow-up to an existing ticket using an external ticket number. Note: the first capturing group from the \'NumberRegExp\' expression will be used as the ticket number value.' =>
            '',
        'Refresh interval' => 'Intervalo Recarga',
        'Registers a log module, that can be used to log communication related information.' =>
            '',
        'Reminder Tickets' => 'Recordatorio Tickets',
        'Removed subscription for user "%s".' => 'Eliminar subscrición para o usuario "%s".',
        'Removes old generic interface debug log entries created before the specified amount of days.' =>
            '',
        'Removes old system configuration deployments (Sunday mornings).' =>
            '',
        'Removes old ticket number counters (each 10 minutes).' => '',
        'Removes the ticket watcher information when a ticket is archived.' =>
            'Elimina a información do vixiante de ticket cando un ticket é arquivado.',
        'Renew existing SMIME certificates from customer backend. Note: SMIME and SMIME::FetchFromCustomer needs to be enabled in SysConfig and customer backend needs to be configured to fetch UserSMIMECertificate attribute.' =>
            '',
        'Replaces the original sender with current customer\'s email address on compose answer in the ticket compose screen of the agent interface.' =>
            'Substitúe o remitente orixinal co enderezo de correo electrónico do cliente actual na resposta composta na pantalla de ticket composto da interface de axente.',
        'Reports' => '',
        'Reports (OTRS Business Solution™)' => '',
        'Reprocess mails from spool directory that could not be imported in the first place.' =>
            '',
        'Required permissions to change the customer of a ticket in the agent interface.' =>
            'Permisos requiridos para cambiar o cliente dun tícket na interface do axente.',
        'Required permissions to use the close ticket screen in the agent interface.' =>
            'Permisos requiridos para empregar a pantalla de peche de tíckets da interface do axente.',
        'Required permissions to use the email outbound screen in the agent interface.' =>
            'Permisos requiridos para empregar a pantalla de correo saínte da interface do axente.',
        'Required permissions to use the email resend screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket bounce screen in the agent interface.' =>
            'Permisos requiridos para empregar a pantalla de rebote de tíckets da interface do axente.',
        'Required permissions to use the ticket compose screen in the agent interface.' =>
            'Permisos requiridos para empregar a pantalla de redacción de tíckets da interface do axente.',
        'Required permissions to use the ticket forward screen in the agent interface.' =>
            'Permisos requiridos para empregar a pantalla de encamiñamento de tíckets da interface do axente.',
        'Required permissions to use the ticket free text screen in the agent interface.' =>
            'Permisos requiridos para empregar a pantalla de texto libre de tíckets da interface do axente.',
        'Required permissions to use the ticket merge screen of a zoomed ticket in the agent interface.' =>
            'Permisos necesarios para utilizar a pantalla de fusión de ticket dun ticket zoom na interface de axente.',
        'Required permissions to use the ticket note screen in the agent interface.' =>
            'Permisos requiridos para empregar a pantalla de nota de tíckets da interface do axente.',
        'Required permissions to use the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Permisos requiridos para empregar a pantalla de dono de tíckets da interface do axente.',
        'Required permissions to use the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Permisos requiridos para empregar a pantalla de tíckets pendentes da interface do axente.',
        'Required permissions to use the ticket phone inbound screen in the agent interface.' =>
            'Permisos necesarios para utilizar a pantalla de ticket de chamada entrante na interface de axente.',
        'Required permissions to use the ticket phone outbound screen in the agent interface.' =>
            'Permisos necesarios para utilizar a pantalla de ticket de chamada saínte na interface de axente.',
        'Required permissions to use the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Permisos requiridos para empregar a pantalla de prioridade de tíckets da interface do axente.',
        'Required permissions to use the ticket responsible screen in the agent interface.' =>
            'Permisos requiridos para empregar a pantalla de responsábel de tíckets da interface do axente.',
        'Resend Ticket Email.' => '',
        'Resent email to "%s".' => '',
        'Resets and unlocks the owner of a ticket if it was moved to another queue.' =>
            'Restablece e desbloquea o propietario dun ticket se foi movido a outra cola.',
        'Resource Overview (OTRS Business Solution™)' => '',
        'Responsible Tickets' => '',
        'Responsible Tickets.' => '',
        'Restores a ticket from the archive (only if the event is a state change to any open available state).' =>
            '',
        'Retains all services in listings even if they are children of invalid elements.' =>
            'Retén tódolos servizos en listas incluso se son fillos de elementos invalidos.',
        'Right' => 'Dereita',
        'Roles ↔ Groups' => '',
        'Romanian' => '',
        'Run file based generic agent jobs (Note: module name needs to be specified in -configuration-module param e.g. "Kernel::System::GenericAgent").' =>
            '',
        'Running Process Tickets' => 'Tickets Proceso Executándose',
        'Runs an initial wildcard search of the existing customer company when accessing the AdminCustomerCompany module.' =>
            'Executa unha busca inicial comodín dos clientes da compañía existentes cando acceden o módulo AdminClienteCompañía.',
        'Runs an initial wildcard search of the existing customer users when accessing the AdminCustomerUser module.' =>
            'Executa unha busca inicial comodín dos clientes usuarios existentes cando acceden o módulo AdminClienteCompañía.',
        'Runs the system in "Demo" mode. If enabled, agents can change preferences, such as selection of language and theme via the agent web interface. These changes are only valid for the current session. It will not be possible for agents to change their passwords.' =>
            '',
        'Russian' => '',
        'S/MIME Certificates' => 'Certificados S/MIME',
        'SMS' => '',
        'SMS (Short Message Service)' => '',
        'Salutations' => 'Saúdos',
        'Sample command output' => 'Saída comando exemplo',
        'Saves the attachments of articles. "DB" stores all data in the database (not recommended for storing big attachments). "FS" stores the data on the filesystem; this is faster but the webserver should run under the OTRS user. You can switch between the modules even on a system that is already in production without any loss of data. Note: Searching for attachment names is not supported when "FS" is used.' =>
            'Garda os anexos dos artigos. «BD» almacena todos os datos na base de datos (non se recomenda para almacenar anexos grandes). «SF» almacena os datos no sistema de ficheiros; isto é máis rápido mais o servidor web debería ser executado co usuario OTRS. Pódese alternar entre os módulos mesmo nun sistema que xa estea en produción, sen perda de datos. Nota: A busca nos nomes dos anexos non é posíbel cando se emprega «SF».',
        'Schedule a maintenance period.' => 'Planifique un periodo mantemento.',
        'Screen after new ticket' => 'Pantalla despois de ticket novo',
        'Search Customer' => 'Buscar clientes',
        'Search Ticket.' => '',
        'Search Tickets.' => '',
        'Search User' => 'Busque Usuario',
        'Search backend default router.' => 'Busca router por defecto de backend.',
        'Search backend router.' => 'Busca router backend.',
        'Search.' => '',
        'Second Christmas Day' => 'Segundo día do nadal.',
        'Second Queue' => 'Segunda Cola',
        'Select after which period ticket overviews should refresh automatically.' =>
            '',
        'Select how many tickets should be shown in overviews by default.' =>
            '',
        'Select the main interface language.' => '',
        'Select the separator character used in CSV files (stats and searches). If you don\'t select a separator here, the default separator for your language will be used.' =>
            'Escolla o carácter separador empregado nos arquivos CSV (estatísticas e buscas). Se non selecciona un separador aquí, o separador por defecto para o seu idioma será empregado.',
        'Select your frontend Theme.' => 'Seleccione o seu Tema frontend.',
        'Select your personal time zone. All times will be displayed relative to this time zone.' =>
            '',
        'Select your preferred layout for the software.' => '',
        'Select your preferred theme for OTRS.' => '',
        'Selects the cache backend to use.' => 'Seleccione o cache backend a usar.',
        'Selects the module to handle uploads via the web interface. "DB" stores all uploads in the database, "FS" uses the file system.' =>
            'Selecciona el módulo para manexar cargas vía a interface web. "BD" garda tódalas cargas na base de datos, "FS" emprega o arquivo de sistema.',
        'Selects the ticket number generator module. "AutoIncrement" increments the ticket number, the SystemID and the counter are used with SystemID.counter format (e.g. 1010138, 1010139). With "Date" the ticket numbers will be generated by the current date, the SystemID and the counter. The format looks like Year.Month.Day.SystemID.counter (e.g. 200206231010138, 200206231010139). With "DateChecksum"  the counter will be appended as checksum to the string of date and SystemID. The checksum will be rotated on a daily basis. The format looks like Year.Month.Day.SystemID.Counter.CheckSum (e.g. 2002070110101520, 2002070110101535).' =>
            '',
        'Send new outgoing mail from this ticket' => '',
        'Send notifications to users.' => 'Envíe notificacións a usuarios.',
        'Sender type for new tickets from the customer inteface.' => 'Tipo de remitente para tickets novos dende a interface de clientes.',
        'Sends agent follow-up notification only to the owner, if a ticket is unlocked (the default is to send the notification to all agents).' =>
            'Envía notificación de seguemento ao axente  só se é propietario, se un ticket non está bloqueado (por defecto envíanse notificacións a tódolos axentes).',
        'Sends all outgoing email via bcc to the specified address. Please use this only for backup reasons.' =>
            'Envía tódolos correos electrónicos de ida mediante bcc ao enderezo especificado. Por favor use esto soamente por razóns de backup.',
        'Sends customer notifications just to the mapped customer.' => '',
        'Sends registration information to OTRS group.' => '',
        'Sends reminder notifications of unlocked ticket after reaching the reminder date (only sent to ticket owner).' =>
            'Envía notificacións de recordatorio de tickets non bloqueados despois de alcanzar a data de recordatorio (só enviado ao propietario do ticket).',
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
        'Service Level Agreements' => 'Acordos de nivel de servizos',
        'Service view' => 'Vista de servizos',
        'ServiceView' => '',
        'Set a new password by filling in your current password and a new one.' =>
            '',
        'Set sender email addresses for this system.' => 'Estableza enderezos de correo electrónico de remitente para este sistema.',
        'Set the default height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            'Estableza a altura por defecto (en pixels) de artigos de HTML inline en AxenteTicketZoom.',
        'Set the limit of tickets that will be executed on a single genericagent job execution.' =>
            '',
        'Set the maximum height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            'Estableza a altura máxima (en pixels) de artigos de HTML inline en AxenteTicketZoom.',
        'Set the minimum log level. If you select \'error\', just errors are logged. With \'debug\' you get all logging messages. The order of log levels is: \'debug\', \'info\', \'notice\' and \'error\'.' =>
            '',
        'Set this ticket to pending' => 'Poña este Ticket a espera',
        'Sets if SLA must be selected by the agent.' => 'Indica se o SLA debe ser seleccionado polo axente.',
        'Sets if SLA must be selected by the customer.' => 'Establece se o ANS debe ser seleccionado polo cliente.',
        'Sets if note must be filled in by the agent. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Establece se nota debe ser enchida polo axente. Pode ser sobreescribido por Ticket::Frontend::NeedAccountedTime.',
        'Sets if queue must be selected by the agent.' => '',
        'Sets if service must be selected by the agent.' => 'Establce se servizo debe ser seleccionado polo axente.',
        'Sets if service must be selected by the customer.' => 'Establce se servizo debe ser seleccionado polo cliente.',
        'Sets if state must be selected by the agent.' => '',
        'Sets if ticket owner must be selected by the agent.' => 'Establce se propietario do ticket debe ser seleccionado polo axente.',
        'Sets if ticket responsible must be selected by the agent.' => '',
        'Sets the PendingTime of a ticket to 0 if the state is changed to a non-pending state.' =>
            'Establce o TempoPendente dun ticket a 0 se o estado é cambiado a un estado non pendente.',
        'Sets the age in minutes (first level) for highlighting queues that contain untouched tickets.' =>
            'Establece a idade en minutos (primeiro nivel) para destacar colas que conteñen tickets sen tocar.',
        'Sets the age in minutes (second level) for highlighting queues that contain untouched tickets.' =>
            'Establece a idade en minutos (segundo nivel) para resaltar colas que conteñen tickets sen tocar.',
        'Sets the configuration level of the administrator. Depending on the config level, some sysconfig options will be not shown. The config levels are in in ascending order: Expert, Advanced, Beginner. The higher the config level is (e.g. Beginner is the highest), the less likely is it that the user can accidentally configure the system in a way that it is not usable any more.' =>
            'Establece o nivel de configuración do administrador. Dependendo do nivel de config, algunhas opcións de sysconfig non serán mostradas. Os niveis de config están en orde ascendente: Principiante, Avanzado, Experto. O máis alto o nivel de config é (p.ex. Principiante é o maior), o menos probable é que o usuario pode accidentalmente configurar o sistema dunha forma que xa non é utilizable.',
        'Sets the count of articles visible in preview mode of ticket overviews.' =>
            'Establece o contador de artigos visible no modo vista previa da vista xeral do ticket.',
        'Sets the default article customer visibility for new email tickets in the agent interface.' =>
            '',
        'Sets the default article customer visibility for new phone tickets in the agent interface.' =>
            '',
        'Sets the default body text for notes added in the close ticket screen of the agent interface.' =>
            'Establece o corpo por defecto para notas engadidas na pantalla ticket pechado da interface de axente.',
        'Sets the default body text for notes added in the ticket move screen of the agent interface.' =>
            'Establece o corpo por defecto para notas engadidas na pantalla mover ticket da interface de axente.',
        'Sets the default body text for notes added in the ticket note screen of the agent interface.' =>
            'Establece o corpo por defecto para notas engadidas na pantalla notas de ticket da interface de axente.',
        'Sets the default body text for notes added in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Establece o corpo por defecto para notas engadidas na pantalla propietario de ticket dun ticket zoom na interface de axente.',
        'Sets the default body text for notes added in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Establece o corpo por defecto para notas engadidas na pantalla ticket pendente dun ticket zoom na interface de axente.',
        'Sets the default body text for notes added in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Establece o corpo por defecto para notas engadidas na pantalla prioridade de ticket dun ticket zoom na interface de axente.',
        'Sets the default body text for notes added in the ticket responsible screen of the agent interface.' =>
            'Establece o corpo por defecto para notas engadidas na pantalla responsable de ticket da interface de axente.',
        'Sets the default error message for the login screen on Agent and Customer interface, it\'s shown when a running system maintenance period is active.' =>
            'Establece a mensaxe de erro por defecto para a pantalla de login nas interfaces de Axente e Cliente, é mostrado cando unha execución dun periodo de mantemento de sistema é activo.',
        'Sets the default link type of split tickets in the agent interface.' =>
            '',
        'Sets the default link type of splitted tickets in the agent interface.' =>
            'Establece o tipo de enlace por defecto de tickets divididos na interface de axente.',
        'Sets the default message for the login screen on Agent and Customer interface, it\'s shown when a running system maintenance period is active.' =>
            'Establece a mensaxe por defecto para a pantalla login nas interfaces de Axente e Cliente, é mostrado cando unha execución dun período de mantemento de sistema é activo.',
        'Sets the default message for the notification is shown on a running system maintenance period.' =>
            'Establece a mensaxe por defecto para a notificación mostrada nunha execución dun periodo de mantemento de sistema.',
        'Sets the default next state for new phone tickets in the agent interface.' =>
            'Establece o próximo estado por defecto para novos tickets telefónicos na interface de axente.',
        'Sets the default next ticket state, after the creation of an email ticket in the agent interface.' =>
            'Estabelece o estado seguinte do tícket após a creación dun tícket de correo na interface do axente.',
        'Sets the default note text for new telephone tickets. E.g \'New ticket via call\' in the agent interface.' =>
            'Establecea nota de texto por defecto para novos tickets telefónicos. Ex. \'Novo ticket via chamada\' na interface de axente.',
        'Sets the default priority for new email tickets in the agent interface.' =>
            'Establece a prioridade por defecto para novos tickets de correo electrónico na interface de axente.',
        'Sets the default priority for new phone tickets in the agent interface.' =>
            'Establece a prioridade por defecto para novos tickets telefónicos na interface de axente.',
        'Sets the default sender type for new email tickets in the agent interface.' =>
            'Establece o tipo de remitente por defecto para tickets de correo electrónico novos na interface de axente.',
        'Sets the default sender type for new phone ticket in the agent interface.' =>
            'Establece o tipo de remitente por defecto para tickets telefónicos novos na interface de axente.',
        'Sets the default subject for new email tickets (e.g. \'email Outbound\') in the agent interface.' =>
            'Establece o tema por defecto para tickets de correo electrónico novos (ex. \'correo electrónico de saída\') na interface de axente.',
        'Sets the default subject for new phone tickets (e.g. \'Phone call\') in the agent interface.' =>
            'Estabelece o asunto por omisión dos tíckets de teléfono novo (p.ex. «Chamada de teléfono») na interface do axente.',
        'Sets the default subject for notes added in the close ticket screen of the agent interface.' =>
            'Establece o tema por defecto para notas engadidas na pantalla de ticket pechado da interface de axente.',
        'Sets the default subject for notes added in the ticket move screen of the agent interface.' =>
            'Establece o tema por defecto para notas engadidas na pantalla de mover ticket da interface de axente.',
        'Sets the default subject for notes added in the ticket note screen of the agent interface.' =>
            'Establece o tema por defecto para notas engadidas na pantalla nota de ticket da interface de axente.',
        'Sets the default subject for notes added in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Establece o tema por defecto para notas engadidas na pantalla propietario de ticket dun ticket zoom na interface de axente.',
        'Sets the default subject for notes added in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Establece o tema por defecto para notas engadidas na pantalla de ticket pendente dun ticket zoom na interface de axente.',
        'Sets the default subject for notes added in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Establece o tema por defecto para notas engadidas na pantalla prioridade de ticket dun ticket zoom na interface de axente.',
        'Sets the default subject for notes added in the ticket responsible screen of the agent interface.' =>
            'Establece o tema por defecto para notas engadidas na pantalla responsable de ticket da interface de axente.',
        'Sets the default text for new email tickets in the agent interface.' =>
            'Establece o texto por defecto para novos tickets de correo electrónico da interface de axente.',
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
            'Establece os minutos que unha notificación é mostrada para darse conta dos próximos periodos de mantemento de sistema.',
        'Sets the number of lines that are displayed in text messages (e.g. ticket lines in the QueueZoom).' =>
            'Establece o número de liñas que son mostradas en mensaxes de texto (ex. liñas en ticket na ColaZoom).',
        'Sets the options for PGP binary.' => 'Establece as opcións para o binario PGP.',
        'Sets the password for private PGP key.' => 'Establece o contrasinal para á chave PGP privada.',
        'Sets the prefered time units (e.g. work units, hours, minutes).' =>
            'Establece as unidades de tempo preferidas (ex. horas traballo, horas, minutos).',
        'Sets the preferred digest to be used for PGP binary.' => '',
        'Sets the prefix to the scripts folder on the server, as configured on the web server. This setting is used as a variable, OTRS_CONFIG_ScriptAlias which is found in all forms of messaging used by the application, to build links to the tickets within the system.' =>
            'Establece o prefixo á carpeta de scripts no servidor, como configurado no servidor web. Este axuste é utilizado como unha variable, OTRS_CONFIG_ScriptAlias que é atopado en tódolos formularios de mensaxería utilizada pola aplicación, para construír enlaces aos tickets dentro do sistema.',
        'Sets the queue in the ticket close screen of a zoomed ticket in the agent interface.' =>
            'Establece a cola na pantalla de ticket pechado dun ticket zoom na interface de axente.',
        'Sets the queue in the ticket free text screen of a zoomed ticket in the agent interface.' =>
            'Establece a cola na pantalla de texto libre de ticket dun ticket zoom na interface de axente.',
        'Sets the queue in the ticket note screen of a zoomed ticket in the agent interface.' =>
            'Establece a cola na pantalla nota de ticket dun ticket zoom na interface de axente.',
        'Sets the queue in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Establece a cola na pantalla propietario de ticket dun ticket zoom na interface de axente.',
        'Sets the queue in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Establece a cola na pantalla de ticket pendente dun ticket zoom na interface de axente.',
        'Sets the queue in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Establece a cola na pantalla prioridade de ticket dun ticket zoom na interface de axente.',
        'Sets the queue in the ticket responsible screen of a zoomed ticket in the agent interface.' =>
            'Establece a cola na pantalla responsable de ticket dun ticket zoom na interface de axente.',
        'Sets the responsible agent of the ticket in the close ticket screen of the agent interface.' =>
            'Establece o axente responsable do ticket na pantalla de ticket pechado da interface de axente.',
        'Sets the responsible agent of the ticket in the ticket bulk screen of the agent interface.' =>
            'Establece o axente responsable do ticket na pantalla de ticket masivo da interface de axente.',
        'Sets the responsible agent of the ticket in the ticket free text screen of the agent interface.' =>
            'Establece o axente responsable do ticket na pantalla texto libre de ticket da interface de axente.',
        'Sets the responsible agent of the ticket in the ticket note screen of the agent interface.' =>
            'Establece o axente responsable do ticket na pantalla nota de ticket da interface de axente.',
        'Sets the responsible agent of the ticket in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Establece o axente responsable do ticket na pantalla propietario de ticket dun ticket zoom na interface de axente.',
        'Sets the responsible agent of the ticket in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Establece o axente responsable do ticket na pantalla de ticket pendente dun ticket zoom na interface de axente.',
        'Sets the responsible agent of the ticket in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Establece o axente responsable do ticket na pantalla prioridade de ticket dun ticket zoom na interface de axente.',
        'Sets the responsible agent of the ticket in the ticket responsible screen of the agent interface.' =>
            'Establece o axente responsable do ticket na pantalla responsable de ticket da interface de axente.',
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
        'Sets the stats hook.' => 'Establece o enganche as estatísticas.',
        'Sets the ticket owner in the close ticket screen of the agent interface.' =>
            'Establece o propietario do ticket na pantalla de ticket pechado da interface de axente.',
        'Sets the ticket owner in the ticket bulk screen of the agent interface.' =>
            'Establece o propietario do ticket na pantalla de ticket masivo da interface de axente.',
        'Sets the ticket owner in the ticket free text screen of the agent interface.' =>
            'Establece o propietario do ticket na pantalla texto libre de ticket da interface de axente.',
        'Sets the ticket owner in the ticket note screen of the agent interface.' =>
            'Establece o propietario do ticket na pantalla nota de ticket da interface de axente.',
        'Sets the ticket owner in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Establece o propietario do ticket na pantalla propietario de ticket dun ticket zoom na interface de axente.',
        'Sets the ticket owner in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Establece o propietario do ticket na pantalla de ticket pendente dun ticket zoom na interface de axente.',
        'Sets the ticket owner in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Establece o propietario do ticket na pantalla prioridade de ticket dun ticket zoom na interface de axente.',
        'Sets the ticket owner in the ticket responsible screen of the agent interface.' =>
            'Establece o propietario do ticket na pantalla responsable de ticket da interface de axente.',
        'Sets the ticket type in the close ticket screen of the agent interface (Ticket::Type needs to be enabled).' =>
            '',
        'Sets the ticket type in the ticket bulk screen of the agent interface.' =>
            'Establece o tipo de ticket na pantalla de ticket masivo da interface de axente.',
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
        'Sets the timeout (in seconds) for http/ftp downloads.' => 'Establece o tempo esgotado (en segundos) para descargas http/ftp.',
        'Sets the timeout (in seconds) for package downloads. Overwrites "WebUserAgent::Timeout".' =>
            'Establece o tempo esgotado (en segundos) para descargas de paquetes. Sobreescribe "WebUserAgent::TimeOut".',
        'Shared Secret' => '',
        'Show a responsible selection in phone and email tickets in the agent interface.' =>
            'Mostra unha selección de responsable en tickets telefónicos e de correo electronico na interface de axente.',
        'Show article as rich text even if rich text writing is disabled.' =>
            'Mostrar artigo coma texto rico inluso se a escritura en texto rico está deshabilitada.',
        'Show command line output.' => '',
        'Show queues even when only locked tickets are in.' => '',
        'Show the current owner in the customer interface.' => 'Mostrar o dono actual na interface do cliente.',
        'Show the current queue in the customer interface.' => 'Mostrar a fila actual na interface do cliente.',
        'Show the history for this ticket' => '',
        'Show the ticket history' => 'Mostrar o historial do tícket',
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
            'Mostra un enlace no menu para engadir unha nota a un ticket en cada vista xeral de ticket da interface de axente.',
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
            'Mostra un enlace no menu para pechar un ticket en cada vista xeral de ticket da interface de axente.',
        'Shows a link in the menu to close a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to delete a ticket in every ticket overview of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Mostra un enlace no menú para borrar un ticket en todas as vistas xerais de ticket da interface de axente. Control de acceso adicional para mostrar ou non mostrar este enlace podese facer utilizando Clave "Grupo" e Contido como "rw:group1;move_into:group2".',
        'Shows a link in the menu to delete a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to enroll a ticket into a process in the ticket zoom view of the agent interface.' =>
            'Mostra un enlace no menu para inscribir un ticket en un proceso na vista zoom de ticket da interface de axente.',
        'Shows a link in the menu to go back in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to lock / unlock a ticket in the ticket overviews of the agent interface.' =>
            'Mostra un enlace no menu para bloquear / desbloquear un ticket  nas vistas xeráis de ticket da interface de axente.',
        'Shows a link in the menu to lock/unlock tickets in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to move a ticket in every ticket overview of the agent interface.' =>
            'Mostra un enlace no menu para mover un ticket en en tódalas vistas xeráis de ticket da interface de axente.',
        'Shows a link in the menu to print a ticket or an article in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to see the history of a ticket in every ticket overview of the agent interface.' =>
            'Mostra un enlace no menu para ver o historico dun ticket en tódalas vistas xeráis de ticket da interface de axente.',
        'Shows a link in the menu to see the priority of a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to send an outbound email in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to set a ticket as junk in every ticket overview of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Shows a link in the menu to set a ticket as pending in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to set the priority of a ticket in every ticket overview of the agent interface.' =>
            'Mostra un enlace no menu para establecer á prioridade dun ticket en tódalas vistas xeráis de ticket da interface de axente.',
        'Shows a link in the menu to zoom a ticket in the ticket overviews of the agent interface.' =>
            'Mostra un enlace no menu para facer zoom nun ticket nas vistas xeráis de ticket da interface de axente.',
        'Shows a link to access article attachments via a html online viewer in the zoom view of the article in the agent interface.' =>
            'Mostra un enlace para acceder adxuntos de artigo vía un visor online html na vista zoom de artigo da interface de axente.',
        'Shows a link to download article attachments in the zoom view of the article in the agent interface.' =>
            'Mostra un enlace para descargar adxuntos de artigo na vista zoom de artigo da interface de axente.',
        'Shows a link to see a zoomed email ticket in plain text.' => 'Mostra un enlace para ver un ticket zoom de correo electrónico en texto plano.',
        'Shows a link to set a ticket as junk in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a list of all the involved agents on this ticket, in the close ticket screen of the agent interface.' =>
            'Mostra unha lista de tódolos axentes implicados neste ticket, na pantalla de ticket pechado da interface de axente.',
        'Shows a list of all the involved agents on this ticket, in the ticket free text screen of the agent interface.' =>
            'Mostra unha lista de tódolos axentes implicados neste ticket, na pantalla texto libre de ticket da interface de axente.',
        'Shows a list of all the involved agents on this ticket, in the ticket note screen of the agent interface.' =>
            'Mostra unha lista de tódolos axentes implicados neste ticket, na pantalla nota de ticket da interface de axente.',
        'Shows a list of all the involved agents on this ticket, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Mostra unha lista de tódolos axentes implicados neste ticket, na pantalla propietario de ticket dun ticket zoom na interface de axente.',
        'Shows a list of all the involved agents on this ticket, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Mostra unha lista de tódolos axentes implicados neste ticket, na pantalla de ticket pendente dun ticket zoom na interface de axente.',
        'Shows a list of all the involved agents on this ticket, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Mostra unha lista de tódolos axentes implicados neste ticket, na pantalla prioridade de ticket dun ticket zoom da interface de axente.',
        'Shows a list of all the involved agents on this ticket, in the ticket responsible screen of the agent interface.' =>
            'Mostra unha lista de tódolos axentes implicados neste ticket, na pantalla responsable de ticket da interface de axente.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the close ticket screen of the agent interface.' =>
            'Mostra unha lista de tódolos posibles axentes (tódolos axentes con permisos de nota na cola/ticket) para determinar quen debe ser informado sobre esta nota, na pantalla ticket pechado da interface de axente.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket free text screen of the agent interface.' =>
            'Mostra unha lista de tódolos posibles axentes (tódolos axentes con permisos de nota na cola/ticket) para determinar quen debe ser informado sobre esta nota, na pantalla texto libre de ticket da interface de axente.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket note screen of the agent interface.' =>
            'Mostra unha lista de tódolos posibles axentes (tódolos axentes con permisos de nota na cola/ticket) para determinar quen debe ser informado sobre esta nota, na pantalla nota de ticket da interface de axente.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Mostra unha lista de tódolos posibles axentes (tódolos axentes con permisos de nota na cola/ticket) para determinar quen debe ser informado sobre esta nota, na pantalla propietario de ticket dun ticket zoom na interface de axente.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Mostra unha lista de tódolos posibles axentes (tódolos axentes con permisos de nota na cola/ticket) para determinar quen debe ser informado sobre esta nota, na pantalla de ticket pendente  dun ticket zoom na interface de axente.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Mostra unha lista de tódolos posibles axentes (tódolos axentes con permisos de nota na cola/ticket) para determinar quen debe ser informado sobre esta nota, na pantalla prioridade de ticket dun ticket zoom na interface de axente.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket responsible screen of the agent interface.' =>
            'Mostra unha lista de tódolos posibles axentes (tódolos axentes con permisos de nota na cola/ticket) para determinar quen debe ser informado sobre esta nota, na pantalla responsable de ticket da interface de axente.',
        'Shows a preview of the ticket overview (CustomerInfo => 1 - shows also Customer-Info, CustomerInfoMaxSize max. size in characters of Customer-Info).' =>
            'Mostra unha vista previa da vista xeral de ticket (ClienteInfo => 1 - mostra tamén Cliente-Info, ClienteInfoMaxTamaño max. tamaño en carácteres de Cliente-Info).',
        'Shows a teaser link in the menu for the ticket attachment view of OTRS Business Solution™.' =>
            '',
        'Shows all both ro and rw queues in the queue view.' => 'Mostra ambas as dúas colas ro and rw na vista da cola.',
        'Shows all both ro and rw tickets in the service view.' => 'Mostra ambas os dous tickets ro and rw na vista dde servizo.',
        'Shows all open tickets (even if they are locked) in the escalation view of the agent interface.' =>
            'Mostra tódolos tickets abertos (incluso se están bloqueados) na vista de escalado da interface de axente.',
        'Shows all the articles of the ticket (expanded) in the agent zoom view.' =>
            '',
        'Shows all the articles of the ticket (expanded) in the customer zoom view.' =>
            '',
        'Shows all the customer identifiers in a multi-select field (not useful if you have a lot of customer identifiers).' =>
            'Mostra tódolos identificadores de cliente nun campo de selección múltiple (non útil se ten moitos identificadores de cliente).',
        'Shows all the customer user identifiers in a multi-select field (not useful if you have a lot of customer user identifiers).' =>
            '',
        'Shows an owner selection in phone and email tickets in the agent interface.' =>
            'Mostra unha selección de propietarios en tickets teléfonicos e de correo eléctronico na interface de axente.',
        'Shows customer history tickets in AgentTicketPhone, AgentTicketEmail and AgentTicketCustomer.' =>
            'Mostra o historial de tíckets dos clientes en AgentTicketPhone, AgentTicketEmail e AgentTicketCustomer.',
        'Shows either the last customer article\'s subject or the ticket title in the small format overview.' =>
            'Mostra tanto o derradeiro subxeto de artigo ou o titulo de ticket na vista xeral de formato pequeno.',
        'Shows existing parent/child queue lists in the system in the form of a tree or a list.' =>
            'Mostra listas de colas pai/fillo existentes no sistema na forma dunha árbore ou unha lista.',
        'Shows information on how to start OTRS Daemon' => '',
        'Shows link to external page in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Shows the article head information in the agent zoom view.' => '',
        'Shows the articles sorted normally or in reverse, under ticket zoom in the agent interface.' =>
            'Mostra artigos ordeados normalemnte ou ó revés, baixo zoom de ticket na interface de axente.',
        'Shows the customer user information (phone and email) in the compose screen.' =>
            'Mostra a información do usuario cliente (teléfono e correo electrónico) na vista composición.',
        'Shows the enabled ticket attributes in the customer interface (0 = Disabled and 1 = Enabled).' =>
            '',
        'Shows the message of the day (MOTD) in the agent dashboard. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            '',
        'Shows the message of the day on login screen of the agent interface.' =>
            'Mostra a mensaxe do día na pantalla de login da interface de axente.',
        'Shows the ticket history (reverse ordered) in the agent interface.' =>
            'Mostra o historico do ticket (ordeado o revé) na interface de axente.',
        'Shows the ticket priority options in the close ticket screen of the agent interface.' =>
            'Mostra as opcións da prioridade do ticket na pantalla ticket pechado da interface de axente.',
        'Shows the ticket priority options in the move ticket screen of the agent interface.' =>
            'Mostra as opcións da prioridade do ticket na pantalla mover ticket da interface de axente.',
        'Shows the ticket priority options in the ticket bulk screen of the agent interface.' =>
            'Mostra as opcións da prioridade do ticket na pantalla ticket masivo da interface de axente.',
        'Shows the ticket priority options in the ticket free text screen of the agent interface.' =>
            'Mostra as opcións da prioridade do ticket na pantalla texto libre de ticket da interface de axente.',
        'Shows the ticket priority options in the ticket note screen of the agent interface.' =>
            'Mostra as opcións da prioridade do ticket na pantalla nota de ticket da interface de axente.',
        'Shows the ticket priority options in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Mostra as opcións da prioridade do ticket na pantalla propietario de ticket  dun ticket zoom na interface de axente.',
        'Shows the ticket priority options in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Mostra as opcións da prioridade do ticket na pantalla ticket pendente dun ticket zoom na interface de axente.',
        'Shows the ticket priority options in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Mostra as opcións da prioridade do ticket na pantalla prioridade de ticket  dun ticket zoom na interface de axente.',
        'Shows the ticket priority options in the ticket responsible screen of the agent interface.' =>
            'Mostra as opcións da prioridade do ticket na pantalla responsable de ticket da interface de axente.',
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
        'Signatures' => 'Sinaturas',
        'Simple' => '',
        'Skin' => 'Aparencia',
        'Slovak' => '',
        'Slovenian' => '',
        'Small' => 'Pequeno',
        'Software Package Manager.' => '',
        'Solution time' => '',
        'SolutionDiffInMin' => 'SolucionDifEnMin',
        'SolutionInMin' => 'SolucionEnMin',
        'Some description!' => 'Algunha descripción!',
        'Some picture description!' => 'Algunha descripción da imaxe!',
        'Sorts the tickets (ascendingly or descendingly) when a single queue is selected in the queue view and after the tickets are sorted by priority. Values: 0 = ascending (oldest on top, default), 1 = descending (youngest on top). Use the QueueID for the key and 0 or 1 for value.' =>
            'Ordea os tickets (ascendente ou descendentemente) cando unha única cola é seleccionada na vista da cola e despois os tickets son ordeados por prioridades. Valores: 0 = ascendente (mais vello enriba, por defecto), 1 = descendente (mais novo enriba). Use IDCola para a chave e 0 ou 1 para o valor.',
        'Sorts the tickets (ascendingly or descendingly) when a single queue is selected in the service view and after the tickets are sorted by priority. Values: 0 = ascending (oldest on top, default), 1 = descending (youngest on top). Use the ServiceID for the key and 0 or 1 for value.' =>
            'Ordea os tickets (ascendente ou descendentemente) cando unha única cola é seleccionada na vista de servizo e despois os tickets son ordeados por prioridade. Valores: 0 = ascendente (mais vello enriba, por defecto), 1 = descendente (mais novo enriba). Use IDServizo para a chave e 0 ou 1 para o valor.',
        'Spam' => '',
        'Spam Assassin example setup. Ignores emails that are marked with SpamAssassin.' =>
            'Exemplo de montaxe de Asasino de Spam. Ignorar correos electrónicos marcados con AsasinoSpam.',
        'Spam Assassin example setup. Moves marked mails to spam queue.' =>
            'Exemplo de mantaxe de Asasino de Spam. Mover correos electrónicos marcados á cola de spam.',
        'Spanish' => '',
        'Spanish (Colombia)' => '',
        'Spanish (Mexico)' => '',
        'Spanish stop words for fulltext index. These words will be removed from the search index.' =>
            '',
        'Specifies if an agent should receive email notification of his own actions.' =>
            'Especifica se un axente debe recibir notificacións de correo electrónico das súas propias accións.',
        'Specifies the directory to store the data in, if "FS" was selected for ArticleStorage.' =>
            '',
        'Specifies the directory where SSL certificates are stored.' => 'Especifica o directorio onde os certificados ssl están gardados.',
        'Specifies the directory where private SSL certificates are stored.' =>
            'Especifica o directorio onde os certificados privados ssl están gardados.',
        'Specifies the email address that should be used by the application when sending notifications. The email address is used to build the complete display name for the notification master (i.e. "OTRS Notifications" otrs@your.example.com). You can use the OTRS_CONFIG_FQDN variable as set in your configuation, or choose another email address.' =>
            '',
        'Specifies the email addresses to get notification messages from scheduler tasks.' =>
            '',
        'Specifies the group where the user needs rw permissions so that he can access the "SwitchToCustomer" feature.' =>
            'Especifica o grupo onde o usuario necesita permisos rw para que él poida acceder a función "SwitchToCustomer".',
        'Specifies the group where the user needs rw permissions so that they can edit other users preferences.' =>
            '',
        'Specifies the name that should be used by the application when sending notifications. The sender name is used to build the complete display name for the notification master (i.e. "OTRS Notifications" otrs@your.example.com).' =>
            '',
        'Specifies the order in which the firstname and the lastname of agents will be displayed.' =>
            'Especifica a orde na cal o nome e os apelidos de axentes serán mostrados.',
        'Specifies the path of the file for the logo in the page header (gif|jpg|png, 700 x 100 pixel).' =>
            'Especifica a ruta do arquivo para o logo na cabeceira de páxina (gif|jpg|png, 700 x 100 pixel).',
        'Specifies the path of the file for the performance log.' => 'Especifica a ruta do arquivo de rendemento de log.',
        'Specifies the path to the converter that allows the view of Microsoft Excel files, in the web interface.' =>
            'Especifica a ruta ao conversor que permite a vista de arquivos Microsoft Excel, na interface web.',
        'Specifies the path to the converter that allows the view of Microsoft Word files, in the web interface.' =>
            'Especifica a ruta ao conversor que permite a vista de arquivos Microsoft Word, na interface web.',
        'Specifies the path to the converter that allows the view of PDF documents, in the web interface.' =>
            'Especifica a ruta ao conversor que permite a vista de documentos PDF, na interface web.',
        'Specifies the path to the converter that allows the view of XML files, in the web interface.' =>
            'Especifica a ruta ao conversor que permite a vista de arquivos XML, na interface web.',
        'Specifies the text that should appear in the log file to denote a CGI script entry.' =>
            'Especifica o texto que debería aparecer no arquivo log para indicar unha entrada de script de CGI.',
        'Specifies user id of the postmaster data base.' => 'Especifica o id usuario da base de datos postmaster.',
        'Specifies whether all storage backends should be checked when looking for attachments. This is only required for installations where some attachments are in the file system, and others in the database.' =>
            '',
        'Specifies whether the (MIMEBase) article attachments will be indexed and searchable.' =>
            '',
        'Specify how many sub directory levels to use when creating cache files. This should prevent too many cache files being in one directory.' =>
            'Especifique cantos niveis sub directorio se deben utilizar cando creanse arquivos de cache. Isto debería previr demasiados arquivos de cache de estar nun directorio.',
        'Specify the channel to be used to fetch OTRS Business Solution™ updates. Warning: Development releases might not be complete, your system might experience unrecoverable errors and on extreme cases could become unresponsive!' =>
            'Especifique a canle para ser utilizada para traer actualizacións de OTRS Business Solution™. Alerta: Presentacións de desenvolvemento poderían non ser totais, o seu sistema podería experimentar erros non-recuperables e en casos extremos podería voltarse sen resposta!',
        'Specify the password to authenticate for the first mirror database.' =>
            '',
        'Specify the username to authenticate for the first mirror database.' =>
            '',
        'Stable' => '',
        'Standard available permissions for agents within the application. If more permissions are needed, they can be entered here. Permissions must be defined to be effective. Some other good permissions have also been provided built-in: note, close, pending, customer, freetext, move, compose, responsible, forward, and bounce. Make sure that "rw" is always the last registered permission.' =>
            'Permisos normais dispoñíbeis para os axentes desde dentro do aplicativo. Se se precisaren máis precisos, é posíbel engadilos aquí. Os permisos teñen que ser definidos para seren efectivos. Outros permisos bos tamén se fornecen incorporados: nota, pechar, pendente, cliente, texto libre, mover, redactar, responsábel, encamiñar e rebotar. Asegúrese de que «rw» é sempre o último permiso rexistrado.',
        'Start number for statistics counting. Every new stat increments this number.' =>
            'Empece número para reconto da estatística. Tódalas estatísticas novas incrementan este número.',
        'Started response time escalation.' => '',
        'Started solution time escalation.' => '',
        'Started update time escalation.' => '',
        'Starts a wildcard search of the active object after the link object mask is started.' =>
            'Empece unha busca comodín do obxecto activo despois de que o enlace ao obxecto máscara foi empezado.',
        'Stat#' => 'Estatística#',
        'States' => 'Estado',
        'Statistic Reports overview.' => '',
        'Statistics overview.' => '',
        'Status view' => 'Vista do estado',
        'Stopped response time escalation.' => '',
        'Stopped solution time escalation.' => '',
        'Stopped update time escalation.' => '',
        'Stores cookies after the browser has been closed.' => 'Garde cookies despois de que o buscador foi pechado.',
        'Strips empty lines on the ticket preview in the queue view.' => 'Tiras liñas baleiras na vista previa do ticket na vista de cola.',
        'Strips empty lines on the ticket preview in the service view.' =>
            'Tiras liñas baleiras na vista previa do ticket na vista de servizo.',
        'Support Agent' => '',
        'Swahili' => '',
        'Swedish' => '',
        'System Address Display Name' => '',
        'System Configuration Deployment' => '',
        'System Configuration Group' => '',
        'System Maintenance' => 'Mantemento do sistema',
        'Templates ↔ Attachments' => '',
        'Templates ↔ Queues' => '',
        'Textarea' => 'Área de texto',
        'Thai' => '',
        'The PGP signature is expired.' => '',
        'The PGP signature was made by a revoked key, this could mean that the signature is forged.' =>
            '',
        'The PGP signature was made by an expired key.' => '',
        'The PGP signature with the keyid has not been verified successfully.' =>
            '',
        'The PGP signature with the keyid is good.' => '',
        'The agent skin\'s InternalName which should be used in the agent interface. Please check the available skins in Frontend::Agent::Skins.' =>
            'A aparencia NomeInterno de axente a cal debe ser usada na interface de axente. Por favor comprobe as aparencias dispoñibles en Frontend::Agent::Skins.',
        'The customer skin\'s InternalName which should be used in the customer interface. Please check the available skins in Frontend::Customer::Skins.' =>
            'A aparencia NomeInterno de cliente a cal debe ser usada na interface de cliente. Por favor comprobe as aparencias dispoñibles en Frontend::Agent::Skins.',
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
            'O separador entre GanchoTicket e número de ticket. Ex.  \': \'.',
        'The duration in minutes after emitting an event, in which the new escalation notify and start events are suppressed.' =>
            'A duración en minutos despois de emitir un evento, no cal o novo escalado notificar e empezar eventos son suprimidos.',
        'The format of the subject. \'Left\' means \'[TicketHook#:12345] Some Subject\', \'Right\' means \'Some Subject [TicketHook#:12345]\', \'None\' means \'Some Subject\' and no ticket number. In the latter case you should verify that the setting PostMaster::CheckFollowUpModule###0200-References is activated to recognize followups based on email headers.' =>
            '',
        'The headline shown in the customer interface.' => 'A cabeceira que aparece na interface do cliente.',
        'The identifier for a ticket, e.g. Ticket#, Call#, MyTicket#. The default is Ticket#.' =>
            'O identificador dun tícket, p.e.x Ticket#, Chamada#, Omeutícket#. Por omisión é Ticket#.',
        'The logo shown in the header of the agent interface for the skin "High Contrast". See "AgentLogo" for further description.' =>
            '',
        'The logo shown in the header of the agent interface for the skin "default". See "AgentLogo" for further description.' =>
            'O logo mostrado na cabeceira da interface de axente para a aparencia "defecto". Vexa "LogoAxente" para unha maior descripción.',
        'The logo shown in the header of the agent interface for the skin "ivory". See "AgentLogo" for further description.' =>
            'O logo mostrado na cabeceira da interface de axente para a aparencia "ivory". Vexa "LogoAxente" para unha maior descripción.',
        'The logo shown in the header of the agent interface for the skin "ivory-slim". See "AgentLogo" for further description.' =>
            'O logo mostrado na cabeceira da interface de axente para a aparencia "ivory-slim". Vexa "LogoAxente" para unha maior descripción.',
        'The logo shown in the header of the agent interface for the skin "slim". See "AgentLogo" for further description.' =>
            'O logo mostrado na cabeceira da interface de axente para a aparencia "slim". Vexa "LogoAxente" para unha maior descripción.',
        'The logo shown in the header of the agent interface. The URL to the image can be a relative URL to the skin image directory, or a full URL to a remote web server.' =>
            'O logo mostrado na cabeceira da interface de axente. A URL a imaxe pode ser unha URL relativa ao directorio da imaxe da aparencia, ou unha URL completa a un servidor web remoto.',
        'The logo shown in the header of the customer interface. The URL to the image can be a relative URL to the skin image directory, or a full URL to a remote web server.' =>
            'O logo mostrado na cabeceira da interface de cliente. A URL a imaxe pode ser unha URL relativa ao directorio da imaxe da aparencia, ou unha URL completa a un servidor web remoto.',
        'The logo shown on top of the login box of the agent interface. The URL to the image can be a relative URL to the skin image directory, or a full URL to a remote web server.' =>
            '',
        'The maximal number of articles expanded on a single page in AgentTicketZoom.' =>
            'Número máximo de artigos expandidos nunha única páxina en AxenteTicketZoom.',
        'The maximal number of articles shown on a single page in AgentTicketZoom.' =>
            'Número máximo de artigos mostrados nunha única páxina en AxenteTicketZoom.',
        'The maximum number of mails fetched at once before reconnecting to the server.' =>
            '',
        'The secret you supplied is invalid. The secret must only contain letters (A-Z, uppercase) and numbers (2-7) and must consist of 16 characters.' =>
            '',
        'The text at the beginning of the subject in an email reply, e.g. RE, AW, or AS.' =>
            'O texto ao comezo do tema nunha resposta de correo electrónico, ex. RE, AW, ou AS.',
        'The text at the beginning of the subject when an email is forwarded, e.g. FW, Fwd, or WG.' =>
            'O texto ao principio do asunto cando se encamiña unha mensaxe de correo, p.ex. Re ou FW.',
        'The value of the From field' => '',
        'Theme' => 'Tema',
        'This event module stores attributes from CustomerUser as DynamicFields tickets. Please see DynamicFieldFromCustomerUser::Mapping setting for how to configure the mapping.' =>
            '',
        'This is a Description for Comment on Framework.' => '',
        'This is a Description for DynamicField on Framework.' => '',
        'This is the default orange - black skin for the customer interface.' =>
            '',
        'This is the default orange - black skin.' => '',
        'This key is not certified with a trusted signature!' => '',
        'This module and its PreRun() function will be executed, if defined, for every request. This module is useful to check some user options or to display news about new applications.' =>
            'Este módulo e a súa función PreRun() será executada, se definido, para cada petición. Este módulo é útil para comprobar algunhas  opcións de usuario ou para mostrar novas sobre novas aplicacións.',
        'This module is part of the admin area of OTRS.' => '',
        'This option defines the dynamic field in which a Process Management activity entity id is stored.' =>
            'Esta opción define o campo dinámico no cal o id da entidade actividade Xestión Procedemento é almacenada.',
        'This option defines the dynamic field in which a Process Management process entity id is stored.' =>
            'Esta opción define o campo dinámico no cal un id de entidade de proceso de Xestión de Proceso é almacenado.',
        'This option defines the process tickets default lock.' => 'Esta opción define o bloqueo por defecto dos tickets de proceso.',
        'This option defines the process tickets default priority.' => 'Esta opción define á prioridade por defecto dos tickets de proceso.',
        'This option defines the process tickets default queue.' => 'Esta opción define á cola por defecto dos tickets de proceso.',
        'This option defines the process tickets default state.' => 'Esta opción define o estado por defecto dos tickets de proceso.',
        'This option will deny the access to customer company tickets, which are not created by the customer user.' =>
            'Esta opción vai denegar o acceso aos tickets da compañía do cliente, os cales non foron creados polo usuario cliente.',
        'This setting allows you to override the built-in country list with your own list of countries. This is particularly handy if you just want to use a small select group of countries.' =>
            'Este axuste permite sobreescribir a lista construida de paises coa súa propia lista de paises. Isto é particularmente práctico se só quere usar un pequeno grupo seleccionado de países. ',
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
        'Ticket Overview "Medium" Limit' => 'Limite "Medio" na visión xeral do Ticket',
        'Ticket Overview "Preview" Limit' => 'Limite "Vista Previa" na visión xeral do Ticket',
        'Ticket Overview "Small" Limit' => 'Limite "Baixo" na visión xeral do Ticket',
        'Ticket Owner.' => '',
        'Ticket Pending.' => '',
        'Ticket Print.' => '',
        'Ticket Priority.' => '',
        'Ticket Queue Overview' => 'Vista xeral da fila de tíckets',
        'Ticket Responsible.' => '',
        'Ticket Watcher' => '',
        'Ticket Zoom' => '',
        'Ticket Zoom.' => '',
        'Ticket bulk module.' => '',
        'Ticket event module that triggers the escalation stop events.' =>
            'Módulo evento de ticket que dispara os eventos de parada do escalado.',
        'Ticket limit per page for Ticket Overview "Medium".' => '',
        'Ticket limit per page for Ticket Overview "Preview".' => '',
        'Ticket limit per page for Ticket Overview "Small".' => '',
        'Ticket notifications' => '',
        'Ticket overview' => 'Vista xeral de ticket',
        'Ticket plain view of an email.' => '',
        'Ticket split dialog.' => '',
        'Ticket title' => '',
        'Ticket zoom view.' => '',
        'TicketNumber' => 'NúmeroTicket',
        'Tickets.' => '',
        'Time in seconds that gets added to the actual time if setting a pending-state (default: 86400 = 1 day).' =>
            'Tempo en segundos que se engade á hora actual ao indicar estado pendente (predeterminado: 86400 = 1 día).',
        'To accept login information, such as an EULA or license.' => '',
        'To download attachments.' => '',
        'To view HTML attachments.' => '',
        'Toggles display of OTRS FeatureAddons list in PackageManager.' =>
            'Alterna á mostra da lista de OTRS FeatureAddons no PackageManager.',
        'Toolbar Item for a shortcut. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Transport selection for appointment notifications. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Transport selection for ticket notifications. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Tree view' => 'Vista en árbore',
        'Triggers add or update of automatic calendar appointments based on certain ticket times.' =>
            '',
        'Triggers ticket escalation events and notification events for escalation.' =>
            '',
        'Turkish' => '',
        'Turns off SSL certificate validation, for example if you use a transparent HTTPS proxy. Use at your own risk!' =>
            'Apaga a validación do certificado SSL, por exemplo se usa un proxy HTTPS transparente. Use no seu propio risco!',
        'Turns on drag and drop for the main navigation.' => 'Encenda arrastre e caída para a navegación principal.',
        'Turns on the remote ip address check. It should not be enabled if the application is used, for example, via a proxy farm or a dialup connection, because the remote ip address is mostly different for the requests.' =>
            '',
        'Tweak the system as you wish.' => '',
        'Type of daemon log rotation to use: Choose \'OTRS\' to let OTRS system to handle the file rotation, or choose \'External\' to use a 3rd party rotation mechanism (i.e. logrotate). Note: External rotation mechanism requires its own and independent configuration.' =>
            '',
        'Ukrainian' => '',
        'Unlock tickets that are past their unlock timeout.' => '',
        'Unlock tickets whenever a note is added and the owner is out of office.' =>
            'Desbloquear tickets sempre que unha nota seña engadida e o propietario é fora da oficina.',
        'Unlocked ticket.' => 'Tícket desbloqueado.',
        'Up' => 'Arriba',
        'Upcoming Events' => 'Eventos vindeiros',
        'Update Ticket "Seen" flag if every article got seen or a new Article got created.' =>
            'Actualice a bandeira "Visto" se cada artigo é visto ou un novo Artigo foi creado.',
        'Update time' => '',
        'Updates the ticket escalation index after a ticket attribute got updated.' =>
            'Actualiza o índice de escalado de ticket despois de que un atributo de ticket fora actualizado.',
        'Updates the ticket index accelerator.' => 'Actualiza o índice acelerador de ticket.',
        'Upload your PGP key.' => '',
        'Upload your S/MIME certificate.' => '',
        'Use new type of select and autocomplete fields in agent interface, where applicable (InputFields).' =>
            '',
        'Use new type of select and autocomplete fields in customer interface, where applicable (InputFields).' =>
            '',
        'User Profile' => 'Perfil do usuario',
        'UserFirstname' => 'UsuarioNome',
        'UserLastname' => 'UsuarioApelidos',
        'Users, Groups & Roles' => '',
        'Uses richtext for viewing and editing ticket notification.' => '',
        'Uses richtext for viewing and editing: articles, salutations, signatures, standard templates, auto responses and notifications.' =>
            'Usa texto rico para ver y editar: artigos, saúdos, sinaturas, modelos estandard, auto respostas e notificacións.',
        'Vietnam' => '',
        'View all attachments of the current ticket' => '',
        'View performance benchmark results.' => 'Ver os resultados das probas de banco de rendemento.',
        'Watch this ticket' => '',
        'Watched Tickets' => 'Tickets Vistos',
        'Watched Tickets.' => '',
        'We are performing scheduled maintenance.' => '',
        'We are performing scheduled maintenance. Login is temporarily not available.' =>
            '',
        'We are performing scheduled maintenance. We should be back online shortly.' =>
            '',
        'Web Services' => 'Servizos Web',
        'Web View' => '',
        'When agent creates a ticket, whether or not the ticket is automatically locked to the agent.' =>
            '',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. Here you can define the body of this note (this text cannot be changed by the agent).' =>
            'Cando os tickets son fusionados, unha nota será engadida automaticamente ao ticket que xa non é activo. Aquí vostede pode definir o corpo desta nota (este texto non pode ser cambiado polo axente).',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. Here you can define the subject of this note (this subject cannot be changed by the agent).' =>
            'Cando os tickets son fusionados, unha nota será engadida automaticamente ao ticket que xa non é activo. Aquí vostede pode definir o tema desta nota (este texto non pode ser cambiado polo axente).',
        'When tickets are merged, the customer can be informed per email by setting the check box "Inform Sender". In this text area, you can define a pre-formatted text which can later be modified by the agents.' =>
            'Cando os tickets son fusionados, o cliente pode ser informado por correo electrónico activando a caixa "Informar Remitente". Nesta áre de texto, pode definir un texto pre-formado que pode despois ser modificado polos axentes.',
        'Whether or not to collect meta information from articles using filters configured in Ticket::Frontend::ZoomCollectMetaFilters.' =>
            '',
        'Whether to force redirect all requests from http to https protocol. Please check that your web server is configured correctly for https protocol before enable this option.' =>
            '',
        'Yes, but hide archived tickets' => 'Si, mais agochar os tíckets arquivados',
        'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further information.' =>
            '',
        'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' =>
            'O seu correo, con número de tícket «<OTRS_TICKET>» foi combinado como «<OTRS_MERGE_TO_TICKET>».',
        'Your queue selection of your preferred queues. You also get notified about those queues via email if enabled.' =>
            '',
        'Your service selection of your preferred services. You also get notified about those services via email if enabled.' =>
            '',
        'Zoom' => 'Ampliación',
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
        'phone' => 'teléfono',
        'responsible' => '',
        'reverse' => 'invertir',
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
