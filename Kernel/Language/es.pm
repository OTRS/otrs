# --
# Kernel/Language/es.pm - provides es language translation
# Copyright (C) 2003-2004 Jorge Becerra <jorge at icc-cuba.com>
# --
# $Id: es.pm,v 1.24 2005-02-23 10:04:21 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
package Kernel::Language::es;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.24 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub Data {
    my $Self = shift;
    my %Param = @_;
    my %Hash = ();

    # $$START$$
    # Last translation Tue Sep 4 15:23:04 2004 by Jorge Becerra

    # possible charsets
    $Self->{Charset} = ['iso-8859-1', 'iso-8859-15', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Jear;)
    $Self->{DateFormat} = '%D.%M.%Y %T';
    $Self->{DateFormatLong} = '%A %D %B %T %Y';
    $Self->{DateInputFormat} = '%D.%M.%Y';
    $Self->{DateInputFormatLong} = '%D.%M.%Y - %T';

    %Hash = (
    # Template: AAABase
      ' 2 minutes' => ' 2 minutos',
      ' 5 minutes' => ' 5 minutos',
      ' 7 minutes' => ' 7 minutos',
      '(Click here to add)' => '(Haga click aqui para agregar)',
      '...Back' => '..Regresar',
      '10 minutes' => '10 minutos',
      '15 minutes' => '15 minutos',
      'Added User "%s"' => 'Añadido Usuario "%s"',
      'AddLink' => 'Adicionar enlace',
      'Admin-Area' => 'Area de administración',
      'agent' => 'agente',
      'Agent-Area' => 'Area-Agente',
      'all' => 'todo',
      'All' => 'Todo',
      'Attention' => 'Atención',
      'Back' => 'Regresar',
      'before' => 'antes',
      'Bug Report' => 'Reporte de errores',
      'Calendar' => 'Calendario',
      'Cancel' => 'Cancelar',
      'change' => 'cambiar',
      'Change' => 'Cambiar',
      'change!' => 'cambiar!',
      'click here' => 'haga click aquí',
      'Comment' => 'Comentario',
      'Contract' => 'Contrato',
      'Crypt' => 'Encriptar',
      'Crypted' => 'Encriptado',
      'Customer' => 'Cliente',
      'customer' => 'cliente',
      'Customer Info' => 'Información del cliente',
      'day' => 'dia',
      'day(s)' => 'dias(s)',
      'days' => 'dias',
      'description' => 'descripción',
      'Description' => 'Descripción',
      'Directory' => 'Directorio',
      'Dispatching by email To: field.' => 'Despachar por correo del campo To:',
      'Dispatching by selected Queue.' => 'Despachar por la cola seleccionada',
      'Don\'t show closed Tickets' => 'No mostrar los tickets cerrados',
      'Don\'t work with UserID 1 (System account)! Create new users!' => 'No trabaje con el Identificador 1 (cuenta de sistema)! Cree nuevos usuarios! ',
      'Done' => 'Hecho',
      'end' => 'fin',
      'Error' => 'Error',
      'Example' => 'Ejemplo',
      'Examples' => 'Ejemplos',
      'Facility' => 'Instalación',
      'FAQ-Area' => 'Area-FAQ',
      'Feature not active!' => 'Característica no activa',
      'go' => 'ir',
      'go!' => 'ir!',
      'Group' => 'Grupo',
      'History::AddNote' => 'Adicionada nota (%s)',
      'History::Bounce' => 'Reenviado a "%s".',
      'History::CustomerUpdate' => 'Actualizado: %s',
      'History::EmailAgent' => 'Correo enviado al cliente.',
      'History::EmailCustomer' => 'Adicionado correo. %s',
      'History::FollowUp' => 'Seguimiento para [%s]. %s',
      'History::Forward' => 'Reenviado a "%s".',
      'History::Lock' => 'Ticket bloqueado.',
      'History::LoopProtection' => 'Protección de lazo! NO se envio auto-respuesta a "%s".',
      'History::Misc' => '%s',
      'History::Move' => 'Ticket movido a la cola "%s" (%s) de la cola "%s" (%s).',
      'History::NewTicket' => 'Nuevo Ticket [%s] createdo (Q=%s;P=%s;S=%s).',
      'History::OwnerUpdate' => 'El nuevo propietario es "%s" (ID=%s).',
      'History::PhoneCallAgent' => 'El agente llamó al cliente.',
      'History::PhoneCallCustomer' => 'El cliente llamó.',
      'History::PriorityUpdate' => 'Cambiar prioridad de "%s" (%s) a "%s" (%s).',
      'History::Remove' => '%s',
      'History::SendAgentNotification' => '"%s"-notificación enviada a "%s".',
      'History::SendAnswer' => 'Correo enviado a "%s".',
      'History::SendAutoFollowUp' => 'Seguimiento automático enviado a "%s".',
      'History::SendAutoReject' => 'Rechazo automático enviado a "%s".',
      'History::SendAutoReply' => 'Respuesta automática enviada a "%s".',
      'History::SendCustomerNotification' => 'Notificaci&oacuten; enviada a "%s".',
      'History::SetPendingTime' => 'Actualizado: %s',
      'History::StateUpdate' => 'Antiguo: "%s" Nuevo: "%s"',
      'History::TicketFreeTextUpdate' => 'Actualizado: %s=%s;%s=%s;',
      'History::TicketLinkAdd' => 'Adicionado enlace al ticket "%s".',
      'History::TicketLinkDelete' => 'Eliminado enlace al ticket "%s".',
      'History::TimeAccounting' => '%s unidad(es) de tiempo contabilizadas. Nuevo total : %s uniodad(es) de tiempo.',
      'History::Unlock' => 'Ticket desbloqueado.',
      'History::WebRequestCustomer' => 'Solicitud de cliente via web.',
      'History::SystemRequest' => 'System Request (%s).',
      'Hit' => 'Hit',
      'Hits' => 'Hits',
      'hour' => 'hora',
      'hours' => 'horas',
      'Ignore' => 'Ignorar',
      'invalid' => 'inválido',
      'Invalid SessionID!' => 'Sesión no válida',
      'Language' => 'Idioma',
      'Languages' => 'Idiomas',
      'last' => 'último',
      'Line' => 'Linea',
      'Lite' => 'Chica',
      'Login failed! Your username or password was entered incorrectly.' => 'Identificación incorrecta. Su nombre de usuario o contraseña fue introducido incorrectamente',
      'Logout successful. Thank you for using OTRS!' => 'Desconexión exitosa. Gracias por utilizar OTRS!',
      'Message' => 'Mensaje',
      'minute' => 'minuto',
      'minutes' => 'minutos',
      'Module' => 'Módulo',
      'Modulefile' => 'Archivo de módulo',
      'month(s)' => 'mes(es)',
      'Name' => 'Nombre',
      'New Article' => 'Nuevo Articulo',
      'New message' => 'Nuevo mensaje',
      'New message!' => 'Nuevo mensaje!',
      'Next' => 'Siguiente',
      'Next...' => 'Siguiente...',
      'No' => 'No',
      'no' => 'no',
      'No entry found!' => 'No se encontró!',
      'No Permission!' => 'No tiene Permiso!',
      'No such Ticket Number "%s"! Can\'t link it!' => 'No existe el Ticket Numero "%s"! No puede elnazarlo!',
      'No suggestions' => 'Sin sugerencias',
      'none' => 'nada',
      'none - answered' => 'nada  - respondido',
      'none!' => 'nada!',
      'Normal' => '',
      'off' => 'off',
      'Off' => 'Off',
      'On' => 'On',
      'on' => 'on',
      'Online Agent: %s' => 'Agente Conectado: %s',
      'Online Customer: %s' => 'Cliente Conectado: %s',
      'Password' => 'Contraseña',
      'Passwords dosn\'t match! Please try it again!' => 'Las contraseñas no coinciden. Por favor Reintente!',
      'Pending till' => 'Pendiente hasta',
      'Please answer this ticket(s) to get back to the normal queue view!' => 'Por favor responda el ticket para regresar a la vista normal de la cola.',
      'Please contact your admin' => 'Por favor contace su administrador',
      'please do not edit!' => 'Por favor no lo edite!',
      'possible' => 'posible',
      'Preview' => 'Vista Previa',
      'QueueView' => 'Ver la cola',
      'reject' => 'rechazar',
      'replace with' => 'reemplazar con',
      'Reset' => 'Resetear',
      'Salutation' => 'Saludo',
      'Session has timed out. Please log in again.' => 'La sesión ha expirado. Por favor conectese nuevamente.',
      'Show closed Tickets' => 'Mostrar Tickets cerrados',
      'Sign' => 'Firma',
      'Signature' => 'Firmas',
      'Signed' => 'Firmado',
      'Size' => 'Tamaño',
      'Sorry' => 'Disculpe',
      'Stats' => 'Estadisticas',
      'Subfunction' => 'Subfunciones',
      'submit' => 'enviar',
      'submit!' => 'enviar!',
      'system' => 'Sistema',
      'Take this Customer' => 'Tomar este cliente',
      'Take this User' => 'Tomar este usuario',
      'Text' => 'Texto',
      'The recommended charset for your language is %s!' => 'EL juego de caracteres recomendado para su idioma es %s!',
      'Theme' => 'Tema',
      'There is no account with that login name.' => 'No existe una cuenta con ese login',
      'Ticket Number' => 'Ticket Número',
      'Timeover' => '',
      'To: (%s) replaced with database email!' => 'To: (%s) sustituido con email de la base de datos!',
      'top' => 'inicio',
      'Type' => 'Tipo',
      'update' => 'actualizar',
      'Update' => 'Actualizar',
      'update!' => 'Actualizar!',
      'Upload' => '',
      'User' => 'Usuario',
      'Username' => 'Nombre de Usuario',
      'Valid' => 'Válido',
      'Warning' => 'Atención',
      'week(s)' => 'semana(s)',
      'Welcome to OTRS' => 'Bienvenido a OTRS',
      'Word' => 'Palabra',
      'wrote' => 'escribió',
      'year(s)' => 'año(s)',
      'Yes' => 'Si',
      'yes' => 'si',
      'You got new message!' => 'Ud tiene un nuevo mensaje',
      'You have %s new message(s)!' => 'Ud tiene %s nuevos mensaje(s)!',
      'You have %s reminder ticket(s)!' => 'Ud tiene %s tickets recordatorios',

    # Template: AAAMonth
      'Apr' => 'Abr',
      'Aug' => 'Ago',
      'Dec' => 'Dic',
      'Feb' => 'Feb',
      'Jan' => 'Ene',
      'Jul' => 'Jul',
      'Jun' => 'Jun',
      'Mar' => 'Mar',
      'May' => 'May',
      'Nov' => 'Nov',
      'Oct' => 'Oct',
      'Sep' => 'Sep',

    # Template: AAAPreferences
      'Closed Tickets' => 'Tickets Cerrados',
      'CreateTicket' => 'CrearTicket',
      'Custom Queue' => 'Cola personal',
      'Follow up notification' => 'Seguimiento a notificaciones',
      'Frontend' => 'Frontal',
      'Mail Management' => 'Gestión de Correos',
      'Max. shown Tickets a page in Overview.' => 'Cantidad de Tickets a mostrar en Resumen',
      'Max. shown Tickets a page in QueueView.' => 'Cantidad de Tickets a mostrar en la Vista de Cola',
      'Move notification' => 'Notificación de movimientos',
      'New ticket notification' => 'Notificación de nuevos tickets',
      'Other Options' => 'Otras Opciones',
      'PhoneView' => 'Vista telefónica',
      'Preferences updated successfully!' => 'Las preferencia fueron actualizadas!',
      'QueueView refresh time' => 'Tiempo de actualización de la vista de colas',
      'Screen after new ticket' => 'Pantalla posterior a nuevo ticket',
      'Select your default spelling dictionary.' => 'Seleccione su diccionario por defecto',
      'Select your frontend Charset.' => 'Seleccione su juego de caracteres',
      'Select your frontend language.' => 'Seleccione su idioma de trabajo',
      'Select your frontend QueueView.' => 'Seleccione su Vista de cola de trabajo',
      'Select your frontend Theme.' => 'Seleccione su tema',
      'Select your QueueView refresh time.' => 'Seleccione su tiempo de actualización de la vista de colas',
      'Select your screen after creating a new ticket.' => 'Seleccione la pantalla a mostrar despues de crear un ticket',
      'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.' => 'Notifíqueme si un cliente enví un seguimiento y yo soy el dueño del ticket.',
      'Send me a notification if a ticket is moved into one of "My Queues".' => 'Notifíqueme si un ticket es colocado en una de "Mis Colas".',
      'Send me a notification if a ticket is unlocked by the system.' => 'Notifíqueme si un ticket es desbloqueado por el sistema',
      'Send me a notification if there is a new ticket in "My Queues".' => 'Notifíqueme si hay un nuevo ticket en "Mis Colas".',
      'Show closed tickets.' => 'Mostrar Tickets cerrados',
      'Spelling Dictionary' => 'Diccionario Ortográfico',
      'Ticket lock timeout notification' => 'Notificación de bloqueo de tickets por tiempo',
      'TicketZoom' => 'Detalle de Ticket',

    # Template: AAATicket
      '1 very low' => '1 muy bajo',
      '2 low' => '2 bajo',
      '3 normal' => '3 normal',
      '4 high' => '4 alto',
      '5 very high' => '5 muy alto',
      'Action' => 'Acción',
      'Age' => 'Antiguedad',
      'Article' => 'Artículo',
      'Attachment' => 'Anexo',
      'Attachments' => 'Anexos',
      'Bcc' => 'Copia Invisible',
      'Bounce' => 'Rebotar',
      'Cc' => 'Copia ',
      'Close' => 'Cerrar',
      'closed' => 'cerrado',
      'closed successful' => 'cerrado exitosamente',
      'closed unsuccessful' => 'cerrado sin éxito',
      'Compose' => 'Componer',
      'Created' => 'Creado',
      'Createtime' => 'Fecha de creaciñn ',
      'email' => 'correo',
      'eMail' => 'Correo',
      'email-external' => 'correo-externo',
      'email-internal' => 'correo-interno',
      'Forward' => 'Reenviar',
      'From' => 'De',
      'high' => 'alto',
      'History' => 'Historia',
      'If it is not displayed correctly,' => 'Si no se muestra correctamente',
      'lock' => 'bloqueado',
      'Lock' => 'Bloquear',
      'low' => 'bajo',
      'Move' => 'Mover',
      'new' => 'nuevo',
      'normal' => 'normal',
      'note-external' => 'nota-externa',
      'note-internal' => 'nota-interna',
      'note-report' => 'nota-reporte',
      'open' => 'abierto',
      'Owner' => 'Propietario',
      'Pending' => 'Pendiente',
      'pending auto close+' => 'pendiente auto close+',
      'pending auto close-' => 'pendiente auto close-',
      'pending reminder' => 'recordatorio pendiente',
      'phone' => 'teléfono',
      'plain' => 'texto',
      'Priority' => 'Prioridad',
      'Queue' => 'Colas',
      'removed' => 'eliminado',
      'Sender' => 'Emisor',
      'sms' => 'sms',
      'State' => 'Estado',
      'Subject' => 'Asunto',
      'This is a' => 'Este es un',
      'This is a HTML email. Click here to show it.' => 'Este es un mensaje HTML. Haga click aquí para mostrarlo.',
      'This message was written in a character set other than your own.' => 'Este mensaje fue escrito usando un juego de caracteres distinto al suyo',
      'Ticket' => 'Ticket',
      'Ticket "%s" created!' => 'Ticket "%s" creado!',
      'To' => 'Para',
      'to open it in a new window.' => 'Para abrir en una nueva ventana',
      'Unlock' => 'Desbloquear',
      'unlock' => 'desbloqueado',
      'very high' => 'muy alto',
      'very low' => 'muy bajo',
      'View' => 'Ver',
      'webrequest' => 'Solicitud via web',
      'Zoom' => 'Detalle',

    # Template: AAAWeekDay
      'Fri' => 'Vie',
      'Mon' => 'Lun',
      'Sat' => 'Sab',
      'Sun' => 'Dom',
      'Thu' => 'Jue',
      'Tue' => 'Mar',
      'Wed' => 'Mie',

    # Template: AdminAttachmentForm
      'Add' => 'Adicionar',
      'Attachment Management' => 'Gestón de Anexos',

    # Template: AdminAutoResponseForm
      'Auto Response From' => 'Respuesta automática de ',
      'Auto Response Management' => 'Gestión de respuestas automáticas',
      'Note' => 'Nota',
      'Response' => 'Respuesta',
      'to get the first 20 character of the subject' => 'para obtener los primeros 20 caracteres del asunto ',
      'to get the first 5 lines of the email' => 'para obtener las primeras 5 líneas del correo',
      'to get the from line of the email' => 'para obtener la linea from del correo',
      'to get the realname of the sender (if given)' => 'para obtener el nombre del emisor (si lo proporcionó)',
      'to get the ticket id of the ticket' => 'para obtener el identificador del ticket',
      'to get the ticket number of the ticket' => 'para obtener el número del ticket',
      'Useable options' => 'Opciones accesibles',

    # Template: AdminCustomerUserForm
      'Customer User Management' => 'Gestión de clientes',
      'Customer user will be needed to have an customer histor and to to login via customer panels.' => 'El cliente necesita tener una historia y conectarse via panel de clientes',
      'Result' => 'Resultado',
      'Search' => 'Buscar',
      'Search for' => 'Buscar por',
      'Select Source (for add)' => 'Seleccionar Fuente (para adicionar)',
      'Source' => 'Origen',
      'The message being composed has been closed.  Exiting.' => 'El mensaje que se estaba redactando ha sido cerrado. Saliendo.!',
      'This values are read only.' => 'Estos valores son solo-lectura',
      'This values are required.' => 'Estos valores son obligatorios',
      'This window must be called from compose window' => 'Esta ventana debe ser llamada desde la ventana de redacción',

    # Template: AdminCustomerUserGroupChangeForm
      'Change %s settings' => 'Cambiar %s especificaciones',
      'Customer User <-> Group Management' => 'Clientes <-> Grupos',
      'Full read and write access to the tickets in this group/queue.' => 'Acceso completo de lectura y escritura a los tickets en este grupo/cola.',
      'If nothing is selected, then there are no permissions in this group (tickets will not be available for the user).' => 'Si no se selecciona algo, no habrán permisos en este grupo (Los tickets no estarán disponibles para este cliente).',
      'Permission' => 'Permisos',
      'Read only access to the ticket in this group/queue.' => 'Acceso de solo lectura a los tickets en este grupo/cola.',
      'ro' => '',
      'rw' => '',
      'Select the user:group permissions.' => 'Seleccionar los permisos de usuario:grupo',

    # Template: AdminCustomerUserGroupForm
      'Change user <-> group settings' => 'Modificar usuario <-> Especificaciones de grupo',

    # Template: AdminEmail
      'Admin-Email' => 'Correo Administrativo',
      'Body' => 'Cuerpo',
      'OTRS-Admin Info!' => 'Información del administrador del OTRS',
      'Recipents' => 'Receptores',
      'send' => 'enviar',

    # Template: AdminEmailSent
      'Message sent to' => 'Mensaje enviado a',

    # Template: AdminGenericAgent
      '(e. g. 10*5155 or 105658*)' => '',
      '(e. g. 234321)' => '',
      '(e. g. U5150)' => '',
      '-' => '',
      'Add Note' => 'Adicionar Nota',
      'Agent' => 'Agente',
      'and' => 'y',
      'CMD' => '',
      'Customer User Login' => 'Identificador del cliente',
      'CustomerID' => 'Número de cliente',
      'CustomerUser' => 'Usuario Cliente',
      'Days' => 'Dias',
      'Delete' => 'Borrar',
      'Delete tickets' => 'Eliminar tickets',
      'Edit' => 'Editar',
      'Fulltext-Search in Article (e. g. "Mar*in" or "Baue*")' => 'Búsqueda de texto en Articulo (ej. "Mar*in" or "Baue*")',
      'GenericAgent' => '',
      'Hours' => 'Horas',
      'Job-List' => 'Lista de Tareas',
      'Jobs' => 'Tareas',
      'Last run' => 'Última corrida',
      'Minutes' => 'Minutos',
      'Modules' => 'Módulos',
      'New Agent' => 'Nuevo Agente',
      'New Customer' => 'Nuevo Cliente',
      'New Owner' => 'Nuevo Propietario',
      'New Priority' => 'Nueva prioridad',
      'New Queue' => 'Nueva Cola',
      'New State' => 'Nuevo estado',
      'New Ticket Lock' => 'Nuevo bloqueo de ticket!',
      'No time settings.' => 'Sin especificación de fecha',
      'Param 1' => 'Parámetro 1',
      'Param 2' => 'Parámetro 2',
      'Param 3' => 'Parámetro 3',
      'Param 4' => 'Parámetro 4',
      'Param 5' => 'Parámetro 5',
      'Param 6' => 'Parámetro 6',
      'Save' => 'Guardar',
      'Save Job as?' => 'Guardar Tarea como?',
      'Schedule' => 'Horario',
      'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' => 'Se ejecutará el comando. ARG[0] el número del ticket. ARG[0] el id del ticket.',
      'Ticket created' => 'Ticket creado',
      'Ticket created between' => 'Ticket creado entre',
      'Ticket Lock' => 'Ticket Bloqueado',
      'TicketFreeText' => '',
      'Times' => 'Veces',
      'Warning! This tickets will be removed from the database! This tickets are lost!' => 'Aviso! Estos tickets serán eliminados de la base de datos! Los mismos se perderán!',

    # Template: AdminGroupForm
      'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).' => 'Crear nuevos grupos para manipular los permisos de acceso por distintos grupos de agente (ejemplo: departamento de compra, departamento de soporte, departamento de ventas,...).',
      'Group Management' => 'Administración de grupos',
      'It\'s useful for ASP solutions.' => 'Esto es útil para soluciones ASP.',
      'The admin group is to get in the admin area and the stats group to get stats area.' => 'El grupo admin es para usar el área de administración y el grupo stats para usar el área estadisticas.',

    # Template: AdminLog
      'System Log' => 'Trazas del Sistema',
      'Time' => 'Tiempo',

    # Template: AdminNavigationBar
      'AdminEmail' => 'Correo del administrador.',
      'Attachment <-> Response' => 'Adjuntos <-> Respuestas',
      'Auto Response <-> Queue' => 'Respuesta automática <-> Colas',
      'Auto Responses' => 'Respuesta automática',
      'Customer User' => 'Cliente',
      'Customer User <-> Groups' => 'Clientes <-> Grupos',
      'Email Addresses' => 'Direcciones de correo',
      'Groups' => 'Grupos',
      'Logout' => 'Desconectarse',
      'Misc' => 'Miscelaneas',
      'Notifications' => 'Notificaciones',
      'PGP Keys' => 'Llaves PGP',
      'PostMaster Filter' => 'Filtro PostMaster',
      'PostMaster POP3 Account' => 'PostMaster Cuenta POP3',
      'Responses' => 'Respuestas',
      'Responses <-> Queue' => 'Respuestas <-> Colas',
      'Role' => 'Rol',
      'Role <-> Group' => 'Rol <-> Grupo',
      'Role <-> User' => 'Rol <-> Usuario',
      'Roles' => '',
      'Select Box' => 'Ventana de selección',
      'Session Management' => 'Gestión de sesiones',
      'SMIME Certificates' => 'Certificados SMIME',
      'Status' => 'Estado',
      'System' => 'Sistema',
      'User <-> Groups' => 'Usuarios <-> Grupos',

    # Template: AdminNotificationForm
      'Config options (e. g. &lt;OTRS_CONFIG_HttpType&gt;)' => 'Opciones de configuración (ej: &lt;OTRS_CONFIG_HttpType&gt;)',
      'Notification Management' => 'Gestión de Notificaciones',
      'Notifications are sent to an agent or a customer.' => 'Las notificación se le envian a un agente o cliente',
      'Options of the current customer user data (e. g. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)' => 'Opciones del usuario activo',
      'Options of the current user who requested this action (e. g. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)' => 'Opciones del usuario activo que solicita esta acción (ej. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)',
      'Ticket owner options (e. g. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)' => 'Opciones de propietario del ticket (ej. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)',

    # Template: AdminPGPForm
      'Bit' => '',
      'Expires' => 'Expira',
      'File' => 'Archivo',
      'Fingerprint' => '',
      'FIXME: WHAT IS PGP?' => '',
      'Identifier' => 'Identificador',
      'In this way you can directly edit the keyring configured in Kernel/Config.pm.' => 'De esta forma Ud puede editar directamente las llaves configuradas en Kernel/Config.pm.',
      'Key' => 'Llave',
      'PGP Key Management' => 'Gestión de llave PGP',

    # Template: AdminPOP3Form
      'All incoming emails with one account will be dispatched in the selected queue!' => 'Todos los correos de entrada serán enviados a la cola seleccionada',
      'Dispatching' => 'Remitiendo',
      'Host' => '',
      'If your account is trusted, the already existing x-otrs header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' => 'Si su cuenta es confiable, los headers ya existentes x-otrs en la llegada se utilizarán para la prioridad! El filtro Postmaster se usa de todas formas.',
      'POP3 Account Management' => 'Gestión de cuenta POP3',
      'Trusted' => 'Confiable',

    # Template: AdminPostMasterFilter
      'Do dispatch or filter incoming emails based on email X-Headers! RegExp is also possible.' => 'Clasificar o filtrar correos entrantes basado en el encabezamiento X-Headers del correo! Puede utilizar expresiones regulares.',
      'Filtername' => '',
      'Header' => 'Encabezado',
      'If you use RegExp, you also can use the matched value in () as [***] in \'Set\'.' => 'Si utilza expresion regular, puede tambien usar el valor encontrado en () as [***] en \'Set\'.',
      'Match' => 'Coincidir',
      'PostMaster Filter Management' => 'Gestión del filtro maestro',
      'Set' => '',
      'Value' => 'Valor',

    # Template: AdminQueueAutoResponseForm
      'Queue <-> Auto Response Management' => 'Cola <-> Respuestas automáticas',

    # Template: AdminQueueAutoResponseTable

    # Template: AdminQueueForm
      '0 = no escalation' => '0 = sin escalado',
      '0 = no unlock' => '0 = sin bloqueo',
      'Customer Move Notify' => 'Notificar al Cliente al Mover',
      'Customer Owner Notify' => 'Notificar al Dueño al Mover',
      'Customer State Notify' => 'Notificación de estado al Cliente',
      'Escalation time' => 'Tiempo de escalado',
      'Follow up Option' => 'Opción de seguimiento',
      'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.' => 'Si el tickes esta cerrado y el cliente enví un seguimiento al mismo este será bloqueado para el antiguo propietario',
      'If a ticket will not be answered in thos time, just only this ticket will be shown.' => 'Si un ticket no ha sido respondido es este tiempo, solo este ticket se mostrará',
      'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.' => 'Si un agente bloquea un ticket y el/ella no enví una respuesta en este tiempo, el ticket sera desbloqueado automáticamente',
      'OTRS sends an notification email to the customer if the ticket is moved.' => 'OTRS enví una notificación por correo si el ticket se mueve',
      'OTRS sends an notification email to the customer if the ticket owner has changed.' => 'OTRS enví una notificación por correo al cliente si el due&ntildeo; del ticket cambia',
      'OTRS sends an notification email to the customer if the ticket state has changed.' => 'OTRS enví una notificación por correo al cliente si el estado del ticket cambia',
      'Queue Management' => 'Gestión de Colas',
      'Sub-Queue of' => 'Subcola de',
      'Systemaddress' => 'Direcciones de correo del sistema',
      'The salutation for email answers.' => 'Saludo para las respuestas por correo.',
      'The signature for email answers.' => 'Firma para respuestas por correo.',
      'Ticket lock after a follow up' => 'Bloquear un ticket después del seguimiento',
      'Unlock timeout' => 'Tiempo para desbloqueo automático',
      'Will be the sender address of this queue for email answers.' => 'Será la dirección del emisor en esta cola para respuestas por correo.',

    # Template: AdminQueueResponsesChangeForm
      'Std. Responses <-> Queue Management' => 'Respuestas estandar <-> Gestión de Colas',

    # Template: AdminQueueResponsesForm
      'Answer' => 'Responder',

    # Template: AdminResponseAttachmentChangeForm
      'Std. Responses <-> Std. Attachment Management' => 'Respuesta estandard <-> Gestión estandard de anexos',

    # Template: AdminResponseAttachmentForm

    # Template: AdminResponseForm
      'A response is default text to write faster answer (with default text) to customers.' => 'Una respuesta es el texto por defecto para escribir respuestas más rapido (con el texto por defecto) a los clientes.',
      'All Customer variables like defined in config option CustomerUser.' => '',
      'Don\'t forget to add a new response a queue!' => 'No olvide incluir una nueva respuesta en la cola!',
      'Next state' => 'Siguiente estado',
      'Response Management' => 'Gestión de respuestas',
      'The current ticket state is' => 'El estado actual del ticket es',
      'Your email address is new' => 'Su dirección de correo es nueva',

    # Template: AdminRoleForm
      'Create a role and put groups in it. Then add the role to the users.' => 'Crea un rol y coloca grupos en el mismo. Luego adiciona el rol a los usuarios.',
      'It\'s useful for a lot of users and groups.' => 'Es útil para gestionar muchos usuarios y grupos.',
      'Role Management' => 'Gestión de Roles',

    # Template: AdminRoleGroupChangeForm
      'create' => 'crear',
      'move_into' => 'mover_a',
      'owner' => 'propietario',
      'Permissions to change the ticket owner in this group/queue.' => 'Permiso para cambiar el propietario del ticket en este grupo/cola',
      'Permissions to change the ticket priority in this group/queue.' => 'Permiso para cambiar la prioridad del ticket en este grupo/cola',
      'Permissions to create tickets in this group/queue.' => 'Permiso para crear tickets en este grupo/cola',
      'Permissions to move tickets into this group/queue.' => 'Permiso para mover tickets a este grupo/cola',
      'priority' => 'prioridad',
      'Role <-> Group Management' => 'Rol <-> Gestion de Grupos',

    # Template: AdminRoleGroupForm
      'Change role <-> group settings' => 'Cambiar rol <-> Configuración de grupo',

    # Template: AdminRoleUserChangeForm
      'Active' => 'Activo',
      'Role <-> User Management' => 'Rol <-> Gestió de Usuarios',
      'Select the role:user relations.' => 'Seleccionar las relaciones Rol-Cliente',

    # Template: AdminRoleUserForm
      'Change user <-> role settings' => 'Cambiar Cliente <-> Configuración de Rol',

    # Template: AdminSMIMEForm
      'Add Certificate' => 'Adicionar un certificado',
      'Add Private Key' => 'Adicionar una Llave privada',
      'FIXME: WHAT IS SMIME?' => '',
      'Hash' => '',
      'In this way you can directly edit the certification and private keys in file system.' => 'De esta fomra Ud puede editar directamente la certificacion y llaves privadas el el sistema de archivos.',
      'Secret' => 'Secreto',
      'SMIME Certificate Management' => 'Gestió de Certificado SMIME',

    # Template: AdminSalutationForm
      'customer realname' => 'Nombre del cliente',
      'for agent firstname' => 'nombre del agente',
      'for agent lastname' => 'apellido del agente',
      'for agent login' => 'login del agente',
      'for agent user id' => 'id del agente',
      'Salutation Management' => 'Gestión de saludos',

    # Template: AdminSelectBoxForm
      'Limit' => 'Límite',
      'SQL' => 'SQL',

    # Template: AdminSelectBoxResult
      'Select Box Result' => 'Seleccione tipo de resultado',

    # Template: AdminSession
      'kill all sessions' => 'Finalizar todas las sesiones',
      'kill session' => 'Finalizar una sesión',
      'Overview' => 'Resumen',
      'Session' => 'Sesión',
      'Sessions' => 'Sesiones',
      'Uniq' => '',

    # Template: AdminSignatureForm
      'Signature Management' => 'Gestión de firmas',

    # Template: AdminStateForm
      'See also' => 'Vea tambien',
      'State Type' => 'Tipo de estado',
      'System State Management' => 'Gestión de estados del Sistema',
      'Take care that you also updated the default states in you Kernel/Config.pm!' => 'Recuerde tambien actualizar los estados en su archivo Kernel/Config.pm! ',

    # Template: AdminSystemAddressForm
      'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!' => 'Todos los mensajes entrantes con este correo(To:) serán enviados a la cola seleccionada!',
      'Email' => 'Correo',
      'Realname' => 'Nombre real',
      'System Email Addresses Management' => 'Gestión de direcciones de correo del sistema',

    # Template: AdminUserForm
      'Don\'t forget to add a new user to groups!' => 'No olvide incluir el usuario en grupos!',
      'Firstname' => 'Nombre',
      'Lastname' => 'Apellido',
      'User Management' => 'Administración de usuarios',
      'User will be needed to handle tickets.' => 'Se necesita un usuario para manipular los tickets.',

    # Template: AdminUserGroupChangeForm
      'User <-> Group Management' => 'Usuarios <-> Grupos',

    # Template: AdminUserGroupForm

    # Template: AgentBook
      'Address Book' => 'Libreta de Direcciones',
      'Discard all changes and return to the compose screen' => 'Descartar todos los cambios y regresar a la pantalla de redacción',
      'Return to the compose screen' => 'Regresar a la pantalla de redacción',

    # Template: AgentBounce
      'A message should have a To: recipient!' => 'El mensaje debe tenes el destinatario To: !',
      'Bounce ticket' => 'Ticket rebotado',
      'Bounce to' => 'Rebotar a',
      'Inform sender' => 'Informar al emisor',
      'Next ticket state' => 'Nuevo estado del ticket',
      'Send mail!' => 'Enviar correo!',
      'You need a email address (e. g. customer@example.com) in To:!' => 'Necesita una dirección de correo (ejemplo: cliente@ejemplo.com) en To:!',
      'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further informations.' => 'Su correo con el ticket número "<OTRS_TICKET>"  fue rebotado a "<OTRS_BOUNCE_TO>". Contacte dicha dirección para mas información',

    # Template: AgentBulk
      '$Text{"Note!' => '$Text{"Nota!',
      'A message should have a subject!' => 'Los mensajes deben tener asunto!',
      'Note type' => 'Tipo de nota',
      'Note!' => 'Nota!',
      'Options' => 'Opciones',
      'Spell Check' => 'Chequeo Ortográfico',
      'Ticket Bulk Action' => 'Acción múltiple con Tickets',

    # Template: AgentClose
      ' (work units)' => ' (unidades de trabajo)',
      'A message should have a body!' => 'Los mensajes deben tener contenido',
      'Close ticket' => 'Cerrar el ticket',
      'Close type' => 'Tipo de cierre',
      'Close!' => 'Cerrar!',
      'Note Text' => 'Nota!',
      'Time units' => 'Unidades de tiempo',
      'You need to account time!' => 'Necesita contabilizar el tiempo!',

    # Template: AgentCompose
      'A message must be spell checked!' => 'El mensaje debe ser chequeado ortograficamente!',
      'Attach' => 'Anexo',
      'Compose answer for ticket' => 'Redacte una respuesta al ticket',
      'for pending* states' => 'en estado pendiente*',
      'Is the ticket answered' => 'Ha sido respondido el ticket',
      'Pending Date' => 'Fecha pendiente',

    # Template: AgentCrypt

    # Template: AgentCustomer
      'Change customer of ticket' => 'Cambiar cliente del ticket',
      'Search Customer' => 'Búsquedas del cliente',
      'Set customer user and customer id of a ticket' => 'Asignar agente y cliente de un ticket',

    # Template: AgentCustomerHistory
      'All customer tickets.' => 'Todos los tickets de un cliente',
      'Customer history' => 'Historia del cliente',

    # Template: AgentCustomerMessage
      'Follow up' => 'Seguimiento',

    # Template: AgentCustomerView
      'Customer Data' => 'Información del cliente',

    # Template: AgentEmailNew
      'All Agents' => 'Todos los Agentes',
      'Clear To' => 'Copia Oculta a',
      'Compose Email' => 'Redactar Correo',
      'new ticket' => 'nuevo ticket',

    # Template: AgentForward
      'Article type' => 'Tipo de artículo',
      'Date' => 'Fecha',
      'End forwarded message' => 'Finalizar mensaje reenviado',
      'Forward article of ticket' => 'Reenviar articulo del ticket',
      'Forwarded message from' => 'Reenviado mensaje de',
      'Reply-To' => 'Responder-A',

    # Template: AgentFreeText
      'Change free text of ticket' => 'Cambiar el texto libre del ticket',

    # Template: AgentHistoryForm
      'History of' => 'Historia de',

    # Template: AgentHistoryRow

    # Template: AgentInfo
      'Info' => 'Información',

    # Template: AgentLookup
      'Lookup' => '',

    # Template: AgentMailboxNavBar
      'All messages' => 'Todos los mensajes',
      'down' => 'abajo',
      'Mailbox' => 'Buzón',
      'New' => 'Nuevo',
      'New messages' => 'Nuevo mensaje',
      'Open' => 'Abrir',
      'Open messages' => 'Abrir mensajes',
      'Order' => 'Orden',
      'Pending messages' => 'Mensajes pendientes',
      'Reminder' => 'Recordatorio',
      'Reminder messages' => 'Mensajes recordatorios',
      'Sort by' => 'Ordenado por',
      'Tickets' => 'Tickets',
      'up' => 'arriba',

    # Template: AgentMailboxTicket
      '"}' => '',
      '"}","14' => '',
      'Add a note to this ticket!' => 'Adicionar una nota a este ticket!',
      'Change the ticket customer!' => 'Cambiar el cliente del ticket!',
      'Change the ticket owner!' => 'Cambiar el dueño del ticket!',
      'Change the ticket priority!' => 'Cambiar la prioridad del ticket!',
      'Close this ticket!' => 'Cerrar este ticket!',
      'Shows the detail view of this ticket!' => 'Muestra ls vista en detalle del ticket!',
      'Unlock this ticket!' => 'Desbloquea el ticket!',

    # Template: AgentMove
      'Move Ticket' => 'Mover Ticket',
      'Previous Owner' => 'Propietario Anterior',
      'Queue ID' => 'Id de la Cola',

    # Template: AgentNavigationBar
      'Agent Preferences' => 'Preferencias de Agente',
      'Bulk Action' => 'Acción múltiple',
      'Bulk Actions on Tickets' => 'Acción múltimple en tickets',
      'Create new Email Ticket' => 'Crear un nuevo Ticket de Correo',
      'Create new Phone Ticket' => 'Crear un nuevo Ticket Telefonico',
      'Email-Ticket' => 'Ticket-Correo',
      'Locked tickets' => 'Tickets bloqueados',
      'new message' => 'nuevo mensaje',
      'Overview of all open Tickets' => 'Resumen de todos los tickets abiertos',
      'Phone-Ticket' => 'Ticket-Telefónico',
      'Preferences' => 'Preferencias',
      'Search Tickets' => 'Buscar Tickets',
      'Ticket selected for bulk action!' => 'Ticket seleccionado para acción múltiple!',
      'You need min. one selected Ticket!' => 'Necesita al menos seleccionar un Ticket!',

    # Template: AgentNote
      'Add note to ticket' => 'Adicionar nota al ticket',

    # Template: AgentOwner
      'Change owner of ticket' => 'Cambiar el propietario del ticket',
      'Message for new Owner' => 'Mensaje para el nuevo propietario',

    # Template: AgentPending
      'Pending date' => 'Fecha pendiente',
      'Pending type' => 'Tipo pendiente',
      'Set Pending' => 'Indicar pendiente',

    # Template: AgentPhone
      'Phone call' => 'Llamada telefónica',

    # Template: AgentPhoneNew
      'Clear From' => 'Borrar From',

    # Template: AgentPlain
      'ArticleID' => 'Identificador de articulo',
      'Download' => 'Descargar',
      'Plain' => 'Texto plano',
      'TicketID' => 'Identificador de Ticket',

    # Template: AgentPreferencesCustomQueue
      'My Queues' => 'Mis Colas',
      'You also get notified about this queues via email if enabled.' => 'Ud tambien sera notificado sobre las colas via email si lo habilita',
      'Your queue selection of your favorite queues.' => 'Su selección de colas favoritas',

    # Template: AgentPreferencesForm

    # Template: AgentPreferencesGeneric

    # Template: AgentPreferencesPassword
      'Change Password' => 'Cambiar contraseña',
      'New password' => 'Nueva contraseña',
      'New password again' => 'Repita la contraseña (confirmación)',

    # Template: AgentPriority
      'Change priority of ticket' => 'Cambiar la prioridad al ticket',

    # Template: AgentSpelling
      'Apply these changes' => 'Aplicar los cambios',
      'Spell Checker' => 'Chequeo Ortográfico',
      'spelling error(s)' => 'errores gramaticales',

    # Template: AgentStatusView
      'D' => 'D',
      'of' => 'de',
      'Site' => 'Sitio',
      'sort downward' => 'ordenar descendente',
      'sort upward' => 'ordenar ascendente',
      'Ticket Status' => 'Estado del Ticket',
      'U' => 'A',

    # Template: AgentTicketLink
      'Delete Link' => 'Eliminar Vinculo',
      'Link' => 'Vinculo',
      'Link to' => 'Vinculado a',

    # Template: AgentTicketLocked
      'Ticket locked!' => 'Ticket bloqueado!',
      'Ticket unlock!' => 'Ticket desbloqueado!',

    # Template: AgentTicketPrint

    # Template: AgentTicketPrintHeader
      'Accounted time' => 'Tiempo contabilizado',
      'Escalation in' => 'Escalado en',

    # Template: AgentUtilSearch
      'Profile' => 'Perfil',
      'Result Form' => 'Modelo de Resultados',
      'Save Search-Profile as Template?' => 'Guardar perfil de búsqueda como patrón?',
      'Search-Template' => 'Buscar-Modelo',
      'Select' => 'Seleccionar',
      'Ticket Search' => 'Buscar ticket',
      'Yes, save it with name' => 'Si, guardarlo con nombre',

    # Template: AgentUtilSearchByCustomerID
      'Customer history search' => 'Historia de búsquedas del cliente',
      'Customer history search (e. g. "ID342425").' => 'Historia de búsquedas del cliente (ejemplo: "ID342425"',
      'No * possible!' => 'No * posible!',

    # Template: AgentUtilSearchResult
      'Change search options' => 'Cambiar opciones de búsqueda',
      'Results' => 'Resultados',
      'Search Result' => 'Buscar resultados',
      'Total hits' => 'Total de coincidencias',

    # Template: AgentUtilSearchResultPrint

    # Template: AgentUtilSearchResultShort

    # Template: AgentUtilTicketStatus
      'All closed tickets' => 'Todos los tickets cerrados',
      'All open tickets' => 'Todos los tickets abiertos',
      'closed tickets' => 'tickets cerrados',
      'open tickets' => 'Tickets abiertos',
      'or' => 'o',
      'Provides an overview of all' => 'Da una vista general de todos',
      'So you see what is going on in your system.' => 'Ver lo que ocurre en su sistema.',

    # Template: AgentZoomAgentIsCustomer
      'Compose Follow up' => 'Redactar seguimiento',
      'Your own Ticket' => 'Sus tickets',

    # Template: AgentZoomAnswer
      'Compose Answer' => 'Responder',
      'Contact customer' => 'Contactar el cliente',
      'phone call' => 'llamada telefónica',

    # Template: AgentZoomArticle
      'Split' => 'Dividir',

    # Template: AgentZoomBody
      'Change queue' => 'Cambiar cola',

    # Template: AgentZoomHead
      'Change the ticket free fields!' => 'Cambiar los campos libres del ticket!',
      'Free Fields' => 'Campos Libres',
      'Link this ticket to an other one!' => 'Vincular este ticket con otro!',
      'Lock it to work on it!' => 'Bloquearlo para trabajar en el mismo!',
      'Print' => 'Imprimir',
      'Print this ticket!' => 'Imprimir este ticket!',
      'Set this ticket to pending!' => 'Colocar el ticket como pendiente!',
      'Shows the ticket history!' => 'Mostrar la historia del ticket!',

    # Template: AgentZoomStatus
      '"}","18' => '',
      'Locked' => 'Bloqueado',
      'SLA Age' => '',

    # Template: Copyright
      'printed by' => 'impreso por',

    # Template: CustomerAccept

    # Template: CustomerCreateAccount
      'Create Account' => 'Crear Cuenta',
      'Login' => 'Identificador',

    # Template: CustomerError
      'Traceback' => '',

    # Template: CustomerFAQArticleHistory
      'FAQ History' => 'Historia de FAQ',

    # Template: CustomerFAQArticlePrint
      'Category' => 'Categoria',
      'Keywords' => 'palabras clave',
      'Last update' => 'Ultima Actualización',
      'Problem' => 'Problema',
      'Solution' => 'Solución',
      'Symptom' => 'Sintoma',

    # Template: CustomerFAQArticleSystemHistory
      'FAQ System History' => 'Sistema de historia de FAQ',

    # Template: CustomerFAQArticleView
      'FAQ Article' => 'Articulo de la FAQ',
      'Modified' => 'Modificado',

    # Template: CustomerFAQOverview
      'FAQ Overview' => 'Resumen de la FAQ',

    # Template: CustomerFAQSearch
      'FAQ Search' => 'Buscar en la FAQ',
      'Fulltext' => 'Texto Completo',
      'Keyword' => 'palabra clave',

    # Template: CustomerFAQSearchResult
      'FAQ Search Result' => 'Resultado de búsqueda en la FAQ',

    # Template: CustomerFooter
      'Powered by' => '',

    # Template: CustomerLostPassword
      'Lost your password?' => 'Perdió su contraseña',
      'Request new password' => 'Solicitar una nueva contraseña',

    # Template: CustomerMessage

    # Template: CustomerMessageNew

    # Template: CustomerNavigationBar
      'CompanyTickets' => '',
      'Create new Ticket' => 'Crear un nuevo ticket',
      'FAQ' => 'FAQ',
      'MyTickets' => 'Mis Tickets',
      'New Ticket' => 'Nuevo ticket',
      'Welcome %s' => 'Bienvenido %s',

    # Template: CustomerPreferencesForm

    # Template: CustomerPreferencesGeneric

    # Template: CustomerPreferencesPassword

    # Template: CustomerStatusView

    # Template: CustomerTicketSearch

    # Template: CustomerTicketSearchResultPrint

    # Template: CustomerTicketSearchResultShort

    # Template: CustomerTicketZoom

    # Template: CustomerWarning

    # Template: Error
      'Click here to report a bug!' => 'Haga click aqui para reportar un error!',

    # Template: FAQArticleDelete
      'FAQ Delete' => 'Eliminar FAQ',
      'You really want to delete this article?' => 'Realmente desea eliminar este articulo?',

    # Template: FAQArticleForm
      'A article should have a title!' => 'Los articulos deben tener tñtulo',
      'Comment (internal)' => 'Comentario (interno)',
      'Filename' => 'Nombre del archivo',
      'Title' => 'Tñtulo',

    # Template: FAQArticleHistory

    # Template: FAQArticlePrint

    # Template: FAQArticleSystemHistory

    # Template: FAQArticleView

    # Template: FAQArticleViewSmall

    # Template: FAQCategoryForm
      'FAQ Category' => 'Categoria de FAQ',
      'Name is required!' => 'Debe especificar nombre!',

    # Template: FAQLanguageForm
      'FAQ Language' => 'Idioma de la FAQ',

    # Template: FAQNavigationBar

    # Template: FAQOverview

    # Template: FAQSearch

    # Template: FAQSearchResult

    # Template: Footer
      'Top of Page' => 'Inicio de página',

    # Template: FooterSmall

    # Template: InstallerBody
      'Create Database' => 'Crear Base de Datos',
      'Drop Database' => 'Eliminar Base de Datos',
      'Finished' => 'Finalizado',
      'System Settings' => 'Configuración del sistema',
      'Web-Installer' => 'Instalador Web',

    # Template: InstallerFinish
      'Admin-User' => 'Usuario-Admin',
      'After doing so your OTRS is up and running.' => 'Después de hacer esto su OTRS estará activo y ejecutandose',
      'Have a lot of fun!' => 'Disfrutelo!',
      'Restart your webserver' => 'Reinicie su servidor web',
      'Start page' => 'Página de inicio',
      'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' => 'Para poder utilizar el OTRS debe escribir la siguiente linea de comandos (Terminal/Shell) como root',
      'Your OTRS Team' => 'Su equipo OTRS',

    # Template: InstallerLicense
      'accept license' => 'aceptar licencia',
      'don\'t accept license' => 'no acepto la licencia',
      'License' => 'Licencia',

    # Template: InstallerStart
      'Create new database' => 'Crear nueva base de datos',
      'DB Admin Password' => 'Contraseña del Admin de la BD',
      'DB Admin User' => 'Usuario Admin de la BD',
      'DB Host' => '',
      'DB Type' => 'Tipo de BD',
      'default \'hot\'' => 'por defecto \'hot\'',
      'Delete old database' => 'Eliminar BD antigua',
      'next step' => 'próximo paso',
      'OTRS DB connect host' => '',
      'OTRS DB Name' => 'Nombre de la BD OTRS',
      'OTRS DB Password' => 'Contraseña para BD del usuario OTRS',
      'OTRS DB User' => 'Usuario de BD OTRS',
      'your MySQL DB should have a root password! Default is empty!' => 'Su BD MySQL debe tener una contrase&ntiulde; de root! Por defecto es va&itilde;a!',

    # Template: InstallerSystem
      '(Checks MX recordes of used email addresses by composing an answer. Don\'t use CheckMXRecord if your OTRS machine is behinde a dial-up line $!)' => '(Chequear record MX de direcciones utilizadas al responder. No usarlo si la PC con el Otrs esta detrás de una linea conmutada $!)',
      '(Email of the system admin)' => '(email del administrador del sistema)',
      '(Full qualified domain name of your system)' => '(Nombre completo del dominio de su sistema)',
      '(Logfile just needed for File-LogModule!)' => '(Archivo de trazas necesario para File-LogModule)',
      '(The identify of the system. Each ticket number and each http session id starts with this number)' => '(La identidad del sistema. Cada número de ticket y cada id de sesi&oacuten http comienza con este número)',
      '(Ticket identifier. Some people want toset this to e. g. \'Ticket#\', \'Call#\' or \'MyTicket#\')' => '(Identificador de Ticker. Algunas personas gustan de usar por ejemplo \'Ticket#\', \'Call#\' or \'MyTicket#\')',
      '(Used default language)' => '(Lenguaje por defecto)',
      '(Used log backend)' => '(Interface de trazas Utilizada)',
      '(Used ticket number format)' => '(Formato de ticket usado)',
      'CheckMXRecord' => 'Revisar record MX',
      'Default Charset' => 'Juego de caracteres por defecto',
      'Default Language' => 'Lenguaje por defecto',
      'Logfile' => 'Archivo de trazas',
      'LogModule' => 'Modulo de trazas',
      'Organization' => 'Organización',
      'System FQDN' => 'FQDN del sistema',
      'SystemID' => 'ID de sistema',
      'Ticket Hook' => '',
      'Ticket Number Generator' => 'Generador de números de Tickets',
      'Use utf-8 it your database supports it!' => 'Usar utf-8 si su base de datos lo soporta!',
      'Webfrontend' => 'Interface Web',

    # Template: LostPassword

    # Template: NoPermission
      'No Permission' => 'No tiene autorización',

    # Template: Notify

    # Template: PrintFooter
      'URL' => 'URL',

    # Template: QueueView
      'All tickets' => 'Todos los tickets',
      'Page' => 'Página',
      'Queues' => 'Colas',
      'Tickets available' => 'Tickets disponibles',
      'Tickets shown' => 'Tickets mostrados',

    # Template: SystemStats

    # Template: Test
      'OTRS Test Page' => 'Página de Prueba de OTRS',

    # Template: TicketEscalation
      'Ticket escalation!' => 'Escalado de ticket',

    # Template: TicketView

    # Template: TicketViewLite

    # Template: Warning

    # Template: css
      'Home' => 'Inicio',

    # Template: customer-css
      'Contact' => 'Contacto',
      'Online-Support' => 'Soporte-Online',
      'Products' => 'Productos',
      'Support' => 'Soporte',

    # Misc
      '"}","15' => '',
      '"}","30' => '',
      'A message should have a From: recipient!' => 'Loe mensajes deben tener un origen From:!',
      'Add auto response' => 'Adicionar respuesta automática',
      'AgentFrontend' => 'Interface Agente',
      'Article free text' => 'Texto libre del articulo',
      'BLZ' => '',
      'Bank-Stammdaten' => '',
      'Change Response <-> Attachment settings' => 'Cambiar respuesta <-> Especificiones de anexos',
      'Change answer <-> queue settings' => 'Modificar respuesta <-> especificaciones de cola',
      'Change auto response settings' => 'Modificar parámetros de la respuesta automática',
      'Charset' => 'Juego de caracteres',
      'Charsets' => 'Juego de Caracteres',
      'Content Adresses' => 'Contenido de la Dirección',
      'Create' => 'Crear',
      'Customer called' => 'Llamada de cliente',
      'Customer user will be needed to to login via customer panels.' => 'El cliente necesita conectarse usando el panel de clientes',
      'Declaration' => 'Declaración',
      'Events' => 'Eventos',
      'FAQ State' => 'Estado de la FAQ',
      'Fulltext search' => 'Búsqueda a texto completo',
      'Fulltext search (e. g. "Mar*in" or "Baue*" or "martin+hallo")' => 'Buscar en todo el texto (ejemplo: "Mar*in" o "Constru*" o "martin+bonjour")',
      'Graphs' => 'Gráficos',
      'Handle' => 'Manipular',
      'Identifer' => 'Identificador',
      'If your account is trusted, the x-otrs header (for priority, ...) will be used!' => 'Si su cuenta es confiable, los headers x-otrs (para prioridad,... ) serán utilizados',
      'Institut' => 'Instituto',
      'Lock Ticket' => 'Bloquear Ticket',
      'Max Rows' => 'Número máximo de filas',
      'My Tickets' => 'Mis Tickets',
      'New state' => 'Nuevo estado',
      'New ticket via call.' => 'Nuevo ticket via telefónica.',
      'New user' => 'Nuevo usuario',
      'Pending!' => 'Pendiente!',
      'Phone call at %s' => 'Llamada telefónica a %s',
      'Please go away!' => 'Por favor salga!',
      'PostMasterFilter Management' => 'Gestión PostMasterFilter',
      'Search in' => 'Buscar en',
      'Select source:' => 'Seleccione origen',
      'Select your custom queues' => 'Seleccione su cola personal',
      'Send me a notification if a ticket is moved into a custom queue.' => 'Notifiqueme si un ticket es colocado en una cola personales',
      'Send me a notification if there is a new ticket in my custom queues.' => 'Notifiqueme si hay un nuevo ticket en mis colas personales.',
      'SessionID' => 'ID de sesión',
      'Set customer id of a ticket' => 'Definir el número de cliente del ticket',
      'Short Description' => 'Resumen',
      'Show all' => 'Mostrar todos',
      'Specification' => 'Especificación',
      'Status defs' => 'Definición de Estados',
      'System Charset Management' => 'Gesti&oactue;n del juego de caracteres',
      'System Language Management' => 'Gestión de idiomas del sistema',
      'Teil#' => '',
      'Ticket free text' => 'Texto del ticket',
      'Ticket limit:' => 'Limite de Ticket:',
      'Ticket-Overview' => 'Ticket-Resumen',
      'Ticketview' => 'Vista de Ticket',
      'Time till escalation' => 'Tiempo para escalar',
      'Utilities' => 'Utilitarios',
      'With State' => 'Con Estado',
      'You have to be in the admin group!' => 'Ud tiene que estar en el grupo admin!',
      'You have to be in the stats group!' => 'Para realizar la operación tiene que estar en el grupo estadisticas!',
      'You need a email address (e. g. customer@example.com) in From:!' => 'Necesita una direccion de correo (ejemplo: cliente@ejemplo.com) en From:!',
      'You need min. one selected Ticket.!' => 'Necesita como minimo seleccionar un Ticket.!',
      'auto responses set' => 'Respuesta automática activada',
      'by' => 'por',
      'history' => 'historia',
      'search' => 'buscar',
      'search (e. g. 10*5155 or 105658*)' => 'buscar (ejemplo: 1055155 o 105658*)',
      'store' => 'almacenar',
      'tickets' => 'Tickets',
    );

    # $$STOP$$

    $Self->{Translation} = \%Hash;
}
# --
1;
