# --
# Kernel/Language/es.pm - provides es language translation
# Copyright (C) 2003 Jorge Becerra <jorge at icc-cuba.com>
# --
# $Id: es.pm,v 1.3 2003-01-18 09:11:10 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
package Kernel::Language::es;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.3 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*\$/$1/;

# --
sub Data {
    my $Self = shift;
    my %Param = @_;
    my %Hash = ();

    # $$START$$
    # Last translation Sun Jan 12 10:43:03 2003 

    # possible charsets
    $Self->{Charset} = ['iso-8859-1', 'iso-8859-15', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Jear;)
    $Self->{DateFormat} = '%D.%M.%Y %T';
    $Self->{DateFormatLong} = '%A %D %B %T %Y';
    $Self->{DateInputFormat} = '%D.%M.%Y - %T';

    %Hash = (
    # Template: AAABase
      ' 2 minutes' => ' 2 minutos',
      ' 5 minutes' => ' 5 minutos',
      ' 7 minutes' => ' 7 minutos',
      '10 minutes' => '10 minutos',
      '15 minutes' => '15 minutos',
      'AddLink' => 'Adicionar enlace',
      'AdminArea' => 'Area de administraci&oacute;n',
      'all' => 'todo',
      'All' => 'Todo',
      'Attention' => 'Atenci&oacute;n',
      'Bug Report' => 'Reporte de errores',
      'Cancel' => 'Cancelar',
      'Change' => 'Cambiar',
      'change' => 'cambiar',
      'change!' => 'cambiar!',
      'click here' => 'haga click aqu&iacute;',
      'Comment' => 'Comentario',
      'Customer' => 'Cliente',
      'Customer info' => 'Informaci&oacute;n del cliente',
      'day' => 'dia',
      'days' => 'dias',
      'description' => 'descripci&oacute;n',
      'Description' => 'Descripci&oacute;n',
      'Dispatching by email To: field.' => 'Despachar por correo del campo To:',
      'Dispatching by selected Queue.' => 'Despachar para la cola seleccionada',
      'Don\'t work with UserID 1 (System account)! Create new users!' => 'No trabaje con el Identificado 1 (cuenta de sistema)! Cree nuevos usuarios! ',
      'Done' => 'Hecho',
      'end' => 'fin',
      'Error' => 'Error',
      'Example' => 'Ejemplo',
      'Examples' => 'Ejemplos',
      'Facility' => 'Instalaci&oacute;n',
      'Feature not acitv!' => 'Caracteristica no activa',
      'go' => 'ir',
      'go!' => 'ir!',
      'Group' => 'Grupo',
      'Hit' => 'Hit',
      'Hits' => 'Hits',
      'hour' => 'hora',
      'hours' => 'horas',
      'Ignore' => 'Ignorar',
      'invalid' => 'inv&aacute;lido',
      'Invalid SessionID!' => 'Sesi&oacute;n no v&aacute;lida',
      'Language' => 'Idioma',
      'Languages' => 'Idiomas',
      'Line' => 'Linea',
      'Lite' => 'Lite',
      'Login failed! Your username or password was entered incorrectly.' => 'Identificaci&oacute;n incorrecta. Su nombre de usuario o contrase&ntilde;a fue introducida incorrectamente',
      'Logout successful. Thank you for using OTRS!' => 'Desconexion exitosa. Gracias por utilizar OTRS!',
      'Message' => 'Mensaje',
      'minute' => 'minuto',
      'minutes' => 'minutos',
      'Module' => 'M&oacute;dulo',
      'Modulefile' => 'Archivo de m&oacute;dulo',
      'Name' => 'Nombre',
      'New message' => 'Nuevo mensaje',
      'New message!' => 'Nuevo mensaje!',
      'No' => 'No',
      'no' => 'no',
      'No suggestions' => 'Sin sugerencias',
      'none' => 'nada',
      'none - answered' => 'nada  - respondido',
      'none!' => 'nada!',
      'Off' => 'Off',
      'off' => 'off',
      'on' => 'on',
      'On' => 'On',
      'Password' => 'Contrase&ntilde;a',
      'Pending till' => 'Pendiente hasta',
      'Please answer this ticket(s) to get back to the normal queue view!' => 'Por favor responda el ticket para regresar a la vista normal de la cola.',
      'Please contact your admin' => 'Por favor contace su administrador',
      'please do not edit!' => 'Por favor no lo edite!',
      'possible' => 'posible',
      'QueueView' => 'Ver la cola',
      'reject' => 'rechazar',
      'replace with' => 'reemplazar con',
      'Reset' => 'Resetear',
      'Salutation' => 'Saludo',
      'Signature' => 'Firmas',
      'Sorry' => 'Disculpe',
      'Stats' => 'Estadisticas',
      'Subfunction' => 'Subfunciones',
      'submit' => 'enviar',
      'submit!' => 'enviar!',
      'Text' => 'Texto',
      'The recommended charset for your language is %s!' => 'EL juego de caracteres recomendado para su idioma es %s!',
      'Theme' => 'Tema',
      'There is no account with that login name.' => 'No existe una cuenta con ese login',
      'Timeover' => '',
      'top' => 'inicio',
      'update' => 'actualizar',
      'update!' => 'Actualizar!',
      'User' => 'Usuario',
      'Username' => 'Nombre de Usuario',
      'Valid' => 'V&aacute;lido',
      'Warning' => 'Atenci&oacute;n',
      'Welcome to OTRS' => 'Bienvenido a OTRS',
      'Word' => 'Palabra',
      'wrote' => 'escribi&oacute;',
      'yes' => 'si',
      'Yes' => 'Si',
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
      'Custom Queue' => 'Cola personal',
      'Follow up notification' => 'Seguimiento a notificaciones',
      'Frontend' => 'Frontal',
      'Mail Management' => 'Gestión de Correos',
      'Move notification' => 'Notificaci&oacute;n de movimientos',
      'New ticket notification' => 'Notificaci&oacute;n de nuevos tickets',
      'Other Options' => 'Otras Opciones',
      'Preferences updated successfully!' => 'Las preferencia fueron actualizadas',
      'QueueView refresh time' => 'Tiempo de actualizaci&oacute;n de la vista de colas',
      'Select your frontend Charset.' => 'Seleccione su juego de caracteres',
      'Select your frontend language.' => 'Seleccione su idioma de trabajo',
      'Select your frontend QueueView.' => 'Seleccione su Vista de cola de trabajo',
      'Select your frontend Theme.' => 'Seleccione su tema',
      'Select your QueueView refresh time.' => 'Seleccione su tiempo de actualizacion de la vista de colas',
      'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.' => 'Notifiqueme si un cliente envia un seguimiento y yo soy el due&ntilde;o del ticket.',
      'Send me a notification if a ticket is moved into a custom queue.' => 'Notifiqueme si un ticket es colocado en una cola personalizada',
      'Send me a notification if a ticket is unlocked by the system.' => 'Notifiqueme si un ticket es desbloqueado por el sistema',
      'Send me a notification if there is a new ticket in my custom queues.' => 'Notifiqueme si hay un nuevo ticket en mis colas personalizadas.',
      'Ticket lock timeout notification' => 'Notificaci&oacute;n de bloqueo de tickets por tiempo',

    # Template: AAATicket
      '1 very low' => 'muy bajo',
      '2 low' => 'bajo',
      '3 normal' => 'normal',
      '4 high' => 'alto',
      '5 very high' => 'muy alto',
      'Action' => 'Acci&oacute;n',
      'Age' => 'Antiguedad',
      'Article' => 'Art&iacute;culo',
      'Attachment' => 'Anexo',
      'Attachments' => 'Anexos',
      'Bcc' => 'Copia Invisible',
      'Bounce' => 'Rebotar',
      'Cc' => 'Copia ',
      'Close' => 'Cerrar',
      'closed successful' => 'cerrado exitosamente',
      'closed unsuccessful' => 'cerrado sin exito',
      'Compose' => 'Componer',
      'Created' => 'Creado',
      'Createtime' => 'Fecha de creaci&ntilde;n ',
      'email' => 'correo',
      'eMail' => 'Correo',
      'email-external' => 'correo-externo',
      'email-internal' => 'correo-interno',
      'Forward' => 'Reenviar',
      'From' => 'De',
      'high' => 'alto',
      'History' => 'Historia',
      'If it is not displayed correctly,' => 'Si no se muestra correctamente',
      'Lock' => 'Bloqueo',
      'low' => 'bajo',
      'Move' => 'Mover',
      'new' => 'nuevo',
      'normal' => 'normal',
      'note-external' => 'nota-externa',
      'note-internal' => 'nota-interna',
      'note-report' => 'nota-reporte',
      'open' => 'abrir',
      'Owner' => 'Propietario',
      'Pending' => 'Pendiente',
      'pending auto close+' => 'pendiente auto close+',
      'pending auto close-' => 'pendiente auto close-',
      'pending reminder' => 'recordatorio pendiente',
      'phone' => 'telefono',
      'plain' => 'texto',
      'Priority' => 'Prioridad',
      'Queue' => 'Colas',
      'removed' => 'eliminado',
      'Sender' => 'Emisor',
      'sms' => 'sms',
      'State' => 'Estado',
      'Subject' => 'Asunto',
      'This is a' => 'Este es un',
      'This is a HTML email. Click here to show it.' => 'Este es un mensaje HTM. Haga click aqui para mostrarlo.',
      'This message was written in a character set other than your own.' => 'Este mensaje fue escrito usando un juego de caracteres distinto al suyo',
      'Ticket' => 'Ticket',
      'To' => 'A',
      'to open it in a new window.' => 'Para abrir en una nueva ventana',
      'Unlock' => 'Desbloquear',
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
      'Add attachment' => 'Adicionar anexo',
      'Attachment Management' => 'Gest&oacute;n de Anexos',
      'Change attachment settings' => 'Cambiar configuracion de anexos',

    # Template: AdminAutoResponseForm
      'Add auto response' => 'Adicionar respuesta automatica',
      'Auto Response From' => 'Respuesta Autom&aacute;tica de ',
      'Auto Response Management' => 'Gestion de respuestas autom&aacute;ticas',
      'Change auto response settings' => 'Modificar par&aacute;metros de la respuesta autom&aacute;tica',
      'Charset' => 'Juego de caracteres',
      'Note' => 'Nota',
      'Response' => 'Respuesta',
      'to get the first 20 character of the subject' => 'para obtener los primeros 20 caracteres del asunto ',
      'to get the first 5 lines of the email' => 'para obtener las primeras 5 lineas del correo',
      'to get the from line of the email' => 'para obtener la linea from del correo',
      'to get the realname of the sender (if given)' => 'para obtener el nombre del emisor (si lo proporciono)',
      'to get the ticket number of the ticket' => 'para obtener el n&uacute;mero del ticket',
      'Type' => 'Tipo',
      'Useable options' => 'Opciones accesibles',

    # Template: AdminCharsetForm
      'Add charset' => 'Adicionar juego de caracteres',
      'Change system charset setting' => 'Cambiar juego de caracteres',
      'System Charset Management' => 'Gesti&oactue;n del juego de caracteres',

    # Template: AdminCustomerUserForm
      'Add customer user' => 'Adicionar cliente',
      'Change customer user settings' => 'Modificar las preferencias de utilizaci&oacute;n de un cliente',
      'Customer User Management' => 'Gestion clientes',
      'Customer user will be needed to to login via customer panels.' => 'El cliente necesita conectarse usando el panel de clientes',

    # Template: AdminCustomerUserGeneric

    # Template: AdminCustomerUserPreferencesGeneric

    # Template: AdminEmail
      'Admin-Email' => 'Correo Administrativo',
      'Body' => 'Cuerpo',
      'OTRS-Admin Info!' => 'Informaci&oacute;n del administrador del OTRS',
      'Recipents' => 'Receptores',

    # Template: AdminEmailSent
      'Message sent to' => 'Mensaje enviado a',

    # Template: AdminGroupForm
      'Add group' => 'Adicionar un grupo',
      'Change group settings' => 'Cambiar los par&aacute;metros de un grupo',
      'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).' => 'Crear nuevos grupos para manipular los permisos de acceso por distintos grupos de agente (ejemplo: departamento de compra, departamento de soporte, departamento de ventas,...).',
      'Group Management' => 'Administraci&oacute;n de grupos',
      'It\'s useful for ASP solutions.' => 'Esto es &uacute;til para soluciones ASP.',
      'The admin group is to get in the admin area and the stats group to get stats area.' => 'El grupo admin es para usar el &aacute;rea de administraci&oacute;n y el grupo stats para usar el &aacute;rea estadisticas.',

    # Template: AdminLanguageForm
      'Add language' => 'Adicionar idioma',
      'Change system language setting' => 'Modificar par&aacute;metros del idioma del sistema',
      'System Language Management' => 'Gesti&oacute;n de idiomas del sistema',

    # Template: AdminLog
      'System Log' => 'Trazas del Sistema',

    # Template: AdminNavigationBar
      'AdminEmail' => 'Correo del administrador.',
      'AgentFrontend' => 'Interface Agente',
      'Auto Response <-> Queue' => 'Respuesta autom&aacute;tica <-> Colas',
      'Auto Responses' => 'Respuesta autom&aacute;tica',
      'Charsets' => 'Juego de Caracteres',
      'Customer User' => 'Cliente',
      'Email Addresses' => 'Direcciones de correo',
      'Groups' => 'Grupos',
      'Logout' => 'Desconectarse',
      'Misc' => 'Miscelaneas',
      'POP3 Account' => 'Cuenta POP3',
      'Responses' => 'Respuestas',
      'Responses <-> Queue' => 'Respuestas <-> Archivos',
      'Select Box' => 'Ventana de selecci&oacute;n',
      'Session Management' => 'Gesti&oacute;n de sesiones',
      'Status defs' => '',
      'System' => 'Sistema',
      'User <-> Groups' => 'Usuarios <-> Grupos',

    # Template: AdminPOP3Form
      'Add POP3 Account' => 'Adicionar Cuenta POP3',
      'All incoming emails with one account will be dispatched in the selected queue!' => 'Todos los correos de entrada ser&aacute;n remitidos a la cola seleccionada',
      'Change POP3 Account setting' => 'Cambiar par&aacute;metros de cuenta POP3',
      'Dispatching' => 'Remitiendo',
      'Host' => '',
      'If your account is trusted, the x-otrs header (for priority, ...) will be used!' => 'Si su cuenta es confiable, los headers x-otrs (para prioridad,... ) ser&aacute;n utilizados',
      'Login' => 'Identificador',
      'POP3 Account Management' => 'Gesti&oacute;n de cuenta POP3',
      'Trusted' => 'Confiable',

    # Template: AdminQueueAutoResponseForm
      'Queue <-> Auto Response Management' => 'Gesti&oacute;n de archivos <-> respuestas autom&aacute;ticas',

    # Template: AdminQueueAutoResponseTable

    # Template: AdminQueueForm
      '0 = no escalation' => '0 = sin escalado',
      '0 = no unlock' => '0 = sin bloqueo',
      'Add queue' => 'Ajustar una cola',
      'Change queue settings' => 'Modificar los par&aacute;metros de una cola',
      'Escalation time' => 'Tiempo de escalado',
      'Follow up Option' => 'Opci&oacute;n de seguimiento',
      'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.' => 'Si el tickes esta cerrado y el cliente envia un seguimiento al mismo este ser&aacute; bloqueado para el antiguo propietario',
      'If a ticket will not be answered in thos time, just only this ticket will be shown.' => 'Si un ticket no ha sido respondido es este tiempo, solo este ticket se mostrar&aacute;',
      'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.' => 'Si un agente bloquea un ticket y el/ella no envia una respuesta en este tiempo, el ticket sera desbloqueado autom&aacute;ticamente',
      'Key' => 'Llave',
      'Queue Management' => 'Gesti&oacute;n de Colas',
      'Systemaddress' => 'Direcciones de correo del sistema',
      'The salutation for email answers.' => 'El saludo para las respuestas por correo es.',
      'The signature for email answers.' => 'Firma para respuestas por correo',
      'Ticket lock after a follow up' => 'Bloquear un ticker despues del seguimiento',
      'Unlock timeout' => 'Tiempo para desbloqueo autom&aacute;tico',
      'Will be the sender address of this queue for email answers.' => 'Ser&aacute; la direcci&oacute;n del emisor en esta cola para respuestas por correo.',

    # Template: AdminQueueResponsesChangeForm
      'Change %s settings' => 'Cambiar %s especificaciones',
      'Std. Responses <-> Queue Management' => 'Respuestas estandar <-> Gesti&oacute;n de Colas',

    # Template: AdminQueueResponsesForm
      'Answer' => 'Responder',
      'Change answer <-> queue settings' => 'Modificar respuesta <-> especificaciones de cola',

    # Template: AdminResponseAttachmentChangeForm
      'Std. Responses <-> Std. Attachment Management' => 'Respuesta estdandar <-> Gesti&oacute;n estandar de anexos',

    # Template: AdminResponseAttachmentForm
      'Change Response <-> Attachment settings' => 'Cambiar respuesta <-> Especificiones de anexos',

    # Template: AdminResponseForm
      'A response is default text to write faster answer (with default text) to customers.' => 'Una respuesta es el texto por defecto para escribir respuestas m&aacute;s rapido (con el texto por defecto) a los clientes.',
      'Add response' => 'Adicionar respuesta',
      'Change response settings' => 'Modificar los par&aacute;metros de respuesta',
      'Don\'t forget to add a new response a queue!' => 'No olvide incluir una nueva respuesta en la cola!',
      'Response Management' => 'Gesti&oacute;n de respuestas',

    # Template: AdminSalutationForm
      'Add salutation' => 'Adicionar un saludo',
      'Change salutation settings' => 'Modificar par&aacute;metros de saludos',
      'customer realname' => 'Nombre del cliente',
      'Salutation Management' => 'Gesti&oacute;n de saludos',

    # Template: AdminSelectBoxForm
      'Max Rows' => 'N&uacute;mero m&aacute;ximo de filas',

    # Template: AdminSelectBoxResult
      'Limit' => 'L&iacute;mite',
      'Select Box Result' => 'Seleccione tipo de resultado',
      'SQL' => 'SQL',

    # Template: AdminSession
      'kill all sessions' => 'Finalizar todas las sesiones',

    # Template: AdminSessionTable
      'kill session' => 'Finalizar una sesi&oacute;n',
      'SessionID' => 'ID de sesi&oacute;n',

    # Template: AdminSignatureForm
      'Add signature' => 'Adicionar una firma',
      'Change signature settings' => 'Modificar de par&aacute;metros de firmas',
      'for agent firstname' => 'nombre del agente',
      'for agent lastname' => 'apellido del agente',
      'Signature Management' => 'Gesti&oacute;n de firmas',

    # Template: AdminStateForm
      'Add state' => 'Ajustar estado',
      'Change system state setting' => 'Modificaci&oacute;n de par&aacute;metros de estados del sistema',
      'System State Management' => 'Gesti&oacute;n de estados del sistema',

    # Template: AdminSystemAddressForm
      'Add system address' => 'Adicionar una direcci&oacute;n del sistema',
      'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!' => 'Todos los mensajes entrantes con este correo(To:) seran despachados a la cola seleccionada!',
      'Change system address setting' => 'Modificar direcciones del sistema',
      'Email' => 'Correo',
      'Realname' => 'Nombre real',
      'System Email Addresses Management' => 'Gesti&oacute;n de direcciones de correo del sistema',

    # Template: AdminUserForm
      'Add user' => 'Adicionar usuario',
      'Change user settings' => 'Cambiar par&aacute;metros del usuario',
      'Don\'t forget to add a new user to groups!' => 'No olvide incluir el usuario en grupos!',
      'Firstname' => 'Nombre',
      'Lastname' => 'Apellido',
      'User Management' => 'Administraci&oacute;n de usuarios',
      'User will be needed to handle tickets.' => 'Se necesita un usuario para manipular los tickets.',

    # Template: AdminUserGroupChangeForm
      'Change  settings' => 'Cambiar especificaciones',
      'User <-> Group Management' => 'Usuarios <-> Grupos',

    # Template: AdminUserGroupForm
      'Change user <-> group settings' => 'Modificar usuario <-> Especificaciones de grupo',

    # Template: AdminUserPreferencesGeneric

    # Template: AgentBounce
      'A message should have a To: recipient!' => 'El mensaje debe tenes el destinatario To: !',
      'Bounce ticket' => 'Ticket rebotado',
      'Bounce to' => 'Rebotar a',
      'Inform sender' => 'Informar al emisor',
      'Next ticket state' => 'Nuevo estado del ticket',
      'Send mail!' => 'Enviar correo!',
      'You need a email address (e. g. customer@example.com) in To:!' => 'Necesita una direccion de correo (ejemplo: cliente@ejemplo.com) en To:!',
      'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further inforamtions.' => 'Su correo con el ticket n&uacute;mero "<OTRS_TICKET>"  fue rebotado a "<OTRS_BOUNCE_TO>". Contacte dicha direcci&oacute;n para mas informaci&oacute;n',

    # Template: AgentClose
      ' (work units)' => ' (unidades de trabajo)',
      'Close ticket' => 'Cerrar el ticket',
      'Close type' => 'Tipo de cierre',
      'Close!' => 'Cerrar!',
      'Note Text' => 'Nota!',
      'Note type' => 'Tipo de nota',
      'store' => 'almacenar',
      'Time units' => 'Unidades de tiempo',

    # Template: AgentCompose
      'A message should have a subject!' => 'Los mensajes deben tener asunto!',
      'Attach' => 'Anexo',
      'Compose answer for ticket' => 'Redacte una respuesta al ticket',
      'for pending* states' => 'en estado pendiente*',
      'Is the ticket answered' => 'Ha sido respondido el ticket',
      'Options' => 'Opciones',
      'Pending Date' => 'fecha pendiente',
      'Spell Check' => 'Chequeo Ortogr&aacute;fico',

    # Template: AgentCustomer
      'Back' => 'Regresar',
      'Change customer of ticket' => 'Cambiar cliente del ticket',
      'Set customer id of a ticket' => 'Definir el n&uacute;mero de cliente del ticket',

    # Template: AgentCustomerHistory
      'Customer history' => 'Historia del cliente',

    # Template: AgentCustomerHistoryTable

    # Template: AgentCustomerView
      'Customer Data' => 'Informaci&oacute;n del cliente',

    # Template: AgentForward
      'Article type' => 'Tipo de art&iacute;culo',
      'Date' => 'Fecha',
      'End forwarded message' => 'Finalizar mensaje reenviado',
      'Forward article of ticket' => 'Reenviar articulo del ticket',
      'Forwarded message from' => 'Reenviado mensaje de',
      'Reply-To' => 'Reply-To',

    # Template: AgentHistoryForm
      'History of' => 'Historia de',

    # Template: AgentMailboxNavBar
      'All messages' => 'Todos los mensajes',
      'CustomerID' => 'N&uacute;mero de cliente',
      'down' => 'abajo',
      'Mailbox' => 'Buz&oacute;n',
      'New' => 'nuevo',
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
      'Add Note' => 'Adicionar Nota',

    # Template: AgentNavigationBar
      'FAQ' => 'FAQ',
      'Locked tickets' => 'Tickets bloqueados',
      'new message' => 'nuevo mensaje',
      'PhoneView' => 'Vista telef&oacute;nica',
      'Preferences' => 'Preferencias',
      'Utilities' => 'Utilitarios',

    # Template: AgentNote
      'Add note to ticket' => 'Adicionar nota al ticket',
      'Note!' => 'Nota!',

    # Template: AgentOwner
      'Change owner of ticket' => 'Cambiar el propietario del ticket',
      'Message for new Owner' => 'Mensaje para el nuevo propietario',
      'New user' => 'Nuevo usuario',

    # Template: AgentPending
      'Pending date' => 'Fecha pendiente',
      'Pending type' => 'Tipo pendiente',
      'Set Pending' => 'Indicar pendiente',

    # Template: AgentPhone
      'Customer called' => 'Llamade de cliente',
      'Phone call' => 'Llamada telef&oacute;nica',
      'Phone call at %s' => 'Llamada telef&oacute;nica a %s',

    # Template: AgentPhoneNew
      'new ticket' => 'nuevo ticket',

    # Template: AgentPlain
      'ArticleID' => 'Identificador de articulo',
      'Plain' => 'Texto plano',
      'TicketID' => 'Identificador de Ticket',

    # Template: AgentPreferencesCustomQueue
      'Select your custom queues' => 'Seleccione su cola personal',

    # Template: AgentPreferencesForm

    # Template: AgentPreferencesGeneric

    # Template: AgentPreferencesPassword
      'Change Password' => 'Cambiar contrase&ntilde;a',
      'New password' => 'Nueva contraseña',
      'New password again' => 'Repita la contrase&ntilde;a (confirmacion)',

    # Template: AgentPriority
      'Change priority of ticket' => 'Cambiar la prioridad al ticket',
      'New state' => 'Nuevo estado',

    # Template: AgentSpelling
      'Apply these changes' => 'Aplicar los cambios',
      'Discard all changes and return to the compose screen' => 'Descartar todos los cambios y regresar a la pantalla de redacci&oacute;n',
      'Return to the compose screen' => 'Regresar a la pantalla de redacci&oacute;n',
      'Spell Checker' => 'Chequeo Ortogr&aacute;fico',
      'spelling error(s)' => 'errores gramaticales',
      'The message being composed has been closed.  Exiting.' => 'El mensaje que se estaba redactando ha sido cerrado. Saliendo.!',
      'This window must be called from compose window' => 'Esta ventana debe ser llamada desde la ventana de redacci&oacute;n',

    # Template: AgentStatusView
      'D' => 'D',
      'sort downward' => 'ordenar descendiente',
      'sort upward' => 'ordenar ascendente',
      'Ticket limit:' => 'Limite de Ticket:',
      'Ticket Status' => 'Estado del Ticket',
      'U' => 'A',

    # Template: AgentStatusViewTable

    # Template: AgentStatusViewTableNotAnswerd

    # Template: AgentTicketLocked
      'Ticket locked!' => 'Ticket bloqueado!',
      'unlock' => 'desbloqueado',

    # Template: AgentTicketPrint
      'by' => 'por',

    # Template: AgentTicketPrintHeader
      'Accounted time' => 'Tiempo contabilizado',
      'Escalation in' => 'Escalado en',
      'printed by' => 'impreso por',

    # Template: AgentUtilSearchByCustomerID
      'Customer history search' => 'Historia de b&uacute;squedas del cliente',
      'Customer history search (e. g. "ID342425").' => 'Historia de b&uacute;squedas del cliente (ejemplo: "ID342425"',
      'No * possible!' => 'No * posible!',

    # Template: AgentUtilSearchByText
      'Article free text' => 'Texto libre del articulo',
      'Fulltext search' => 'B&uacute;squeda a texto completo',
      'Fulltext search (e. g. "Mar*in" or "Baue*" or "martin+hallo")' => 'Buscar en todo el texto (ejemplo: "Mar*in" o "Constru*" o "martin+bonjour")',
      'Search in' => 'Buscar en',
      'Ticket free text' => 'Texto del ticket',
      'With State' => 'Con Estado',

    # Template: AgentUtilSearchByTicketNumber
      'search' => 'buscar',
      'search (e. g. 10*5155 or 105658*)' => 'buscar (ejemplo: 1055155 o 105658*)',

    # Template: AgentUtilSearchNavBar
      'Results' => 'Resultados',
      'Site' => 'Sitio',
      'Total hits' => 'Total de coincidencias',

    # Template: AgentUtilSearchResult

    # Template: AgentUtilTicketStatus
      'All open tickets' => 'Todos los tickets abiertos',
      'open tickets' => 'Tickets abiertos',
      'Provides an overview of all' => 'Da una vista general de todos',
      'So you see what is going on in your system.' => 'De forma que Ud ve lo que esta ocurriendo en su sistema',

    # Template: CustomerCreateAccount
      'Create' => 'Crear',
      'Create Account' => 'Crear Cuenta',

    # Template: CustomerError
      'Backend' => '',
      'BackendMessage' => '',
      'Click here to report a bug!' => 'Haga click aqui para reportar un error',
      'Handle' => 'Manipular',

    # Template: CustomerFooter
      'Powered by' => '',

    # Template: CustomerHeader
      'Contact' => 'Contacto',
      'Home' => 'Inicio',
      'Online-Support' => 'Soporte-Online',
      'Products' => 'Productos',
      'Support' => 'Soporte',

    # Template: CustomerLogin

    # Template: CustomerLostPassword
      'Lost your password?' => 'Perdio su contrase&ntilde;a',
      'Request new password' => 'Solicitar una nueva contrase&ntilde;a',

    # Template: CustomerMessage
      'Follow up' => 'Seguimiento',

    # Template: CustomerMessageNew

    # Template: CustomerNavigationBar
      'Create new Ticket' => 'Crear un nuevo ticket',
      'My Tickets' => 'Mis Tickets',
      'New Ticket' => 'Nuevo ticket',
      'Ticket-Overview' => 'Ticket-Resumen',
      'Welcome %s' => 'Bienvenido %s',

    # Template: CustomerPreferencesForm

    # Template: CustomerPreferencesGeneric

    # Template: CustomerPreferencesPassword

    # Template: CustomerStatusView
      'of' => 'de',

    # Template: CustomerStatusViewTable

    # Template: CustomerTicketZoom

    # Template: CustomerWarning

    # Template: Error

    # Template: Footer

    # Template: Header

    # Template: InstallerStart
      'next step' => 'proximo paso',

    # Template: InstallerSystem
      '(Email of the system admin)' => '(amail del administrador del sistema)',
      '(Full qualified domain name of your system)' => '(Nombre completo del dominio de su sistema)',
      '(Logfile just needed for File-LogModule!)' => '(Archivo de log necesario para File-LogModule)',
      '(The identify of the system. Each ticket number and each http session id starts with this number)' => '(La identidad del sistema. Cada n&uacute;mero de ticker y cada id de sesion http comienza con este n&uacute;mero)',
      '(Ticket identifier. Some people want toset this to e. g. \'Ticket#\', \'Call#\' or \'MyTicket#\')' => '(Identificador de Ticker. Algunas personas gustan de usar por ejemplo \'Ticket#\', \'Call#\' or \'MyTicket#\')',
      '(Used default language)' => '(Lenguaje por defecto)',
      '(Used log backend)' => '()',
      '(Used ticket number format)' => '(Formato de ticket usado)',
      'Default Charset' => 'Juego de caracteres por defecto',
      'Default Language' => 'Lenguaje por defecto',
      'Logfile' => 'Archivo de log',
      'LogModule' => '',
      'Organization' => 'Organizaci&oacute;n',
      'System FQDN' => 'FQDN del sistema',
      'SystemID' => 'ID de sistema',
      'Ticket Hook' => '',
      'Ticket Number Generator' => 'Generador de numeros de tickets',
      'Webfrontend' => 'Interface Web',

    # Template: Login

    # Template: LostPassword

    # Template: NoPermission
      'No Permission' => 'No tiene autorizaci&oacute;n',

    # Template: Notify
      'Info' => 'Informaci&oacute;n',

    # Template: PrintFooter
      'URL' => 'URL',

    # Template: PrintHeader
      'Print' => 'Imprimir',

    # Template: QueueView
      'All tickets' => 'Todos los tickets',
      'Queues' => 'Colas',
      'Show all' => 'Mostrar todos',
      'Ticket available' => 'Tickets disponibles',
      'tickets' => 'Tickets',
      'Tickets shown' => 'Tickets mostrados',

    # Template: SystemStats
      'Graphs' => 'Gr&aacute;ficos',

    # Template: Test
      'OTRS Test Page' => 'P&aacute;gina de prueba de OTRS',

    # Template: TicketEscalation
      'Ticket escalation!' => 'Escalado de ticket',

    # Template: TicketView
      'Change queue' => 'Cambiar cola',
      'Compose Answer' => 'Responder',
      'Contact customer' => 'Contactar el cliente',
      'phone call' => 'llamada telef&oacute;nica',

    # Template: TicketViewLite

    # Template: TicketZoom

    # Template: TicketZoomNote

    # Template: TicketZoomSystem

    # Template: Warning

    # Misc
      '(Click here to add a group)' => '(haga click aqui para a&ntilde;adir un grupo)',
      '(Click here to add a queue)' => '(haga click aqui para a&ntilde;adir una cola)',
      '(Click here to add a response)' => '(haga click aqui para a&ntilde;adir una respuesta)',
      '(Click here to add a salutation)' => '(haga click aqui para a&ntilde;adir un saludo)',
      '(Click here to add a signature)' => '(haga click aqui para a&ntilde;adir una firma)',
      '(Click here to add a system email address)' => '(haga click aqui para a&ntilde;adir una direcci&oacute;n del sistema)',
      '(Click here to add a user)' => '(haga click aqui para a&ntilde;adir un usuario)',
      '(Click here to add an auto response)' => '(haga click aqui para a&ntilde;adir una respuesta autom&aacute;tica)',
      '(Click here to add charset)' => '(haga click aqui para a&ntilde;adir un juego de caracteres)',
      '(Click here to add language)' => '(haga click aqui para a&ntilde;adir un idioma)',
      '(Click here to add state)' => '(haga click aqui para a&ntilde;adir un estado)',
      'A message should have a From: recipient!' => 'Loe mensajes deben tener un origen From:!',
      'CustomerUser' => 'Usuario Cliente',
      'New ticket via call.' => 'Nuevo ticket via telef&oacute;nica.',
      'Time till escalation' => 'Tiempo para escalar',
      'Update auto response' => 'Actualizar respuesta aut&aacute;matica',
      'Update charset' => 'Actualizar juego de caracteres',
      'Update group' => 'Actualizar grupo',
      'Update language' => 'Actualizar idioma',
      'Update queue' => 'Actualizar cola',
      'Update response' => 'Actualizar respuesta',
      'Update salutation' => 'Actualizar saludo',
      'Update signature' => 'Actualizar firma',
      'Update state' => 'Actualizar estado',
      'Update system address' => 'Actualizar direcci&oacute;n de correo del sistema',
      'Update user' => 'Actualizar usuario',
      'You have to be in the admin group!' => 'Ud tiene que estar en el grupo admin!',
      'You have to be in the stats group!' => 'Para realizar la operacion tiene que estar en el grupo estadisticas!',
      'You need a email address (e. g. customer@example.com) in From:!' => 'Necesita una direccion de correo (ejemplo: cliente@ejemplo.com) en From:!',
      'auto responses set' => 'Respuesta autom&aacute;tica activada',
    );

    # $$STOP$$

    $Self->{Translation} = \%Hash;
}
# --
1;

