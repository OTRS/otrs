# --
# Kernel/Language/es.pm - provides es language translation
# Copyright (C) 2003-2004 Jorge Becerra <jorge at icc-cuba.com>
# --
# $Id: es.pm,v 1.31 2005-07-29 10:22:06 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
package Kernel::Language::es;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.31 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub Data {
    my $Self = shift;
    my %Param = @_;

    # $$START$$
    # Last translation file sync: Thu Jul 28 22:14:13 2005

    # possible charsets
    $Self->{Charset} = ['iso-8859-1', 'iso-8859-15', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Jear;)
    $Self->{DateFormat} = '%D.%M.%Y %T';
    $Self->{DateFormatLong} = '%A %D %B %T %Y';
    $Self->{DateInputFormat} = '%D.%M.%Y';
    $Self->{DateInputFormatLong} = '%D.%M.%Y - %T';

    $Self->{Translation} = {
      # Template: AAABase
      'Yes' => 'Si',
      'No' => '',
      'yes' => 'si',
      'no' => '',
      'Off' => '',
      'off' => '',
      'On' => '',
      'on' => '',
      'top' => 'inicio',
      'end' => 'fin',
      'Done' => 'Hecho',
      'Cancel' => 'Cancelar',
      'Reset' => 'Resetear',
      'last' => 'último',
      'before' => 'antes',
      'day' => 'dia',
      'days' => 'dias',
      'day(s)' => 'dias(s)',
      'hour' => 'hora',
      'hours' => 'horas',
      'hour(s)' => 'hora(s)',
      'minute' => 'minuto',
      'minutes' => 'minutos',
      'minute(s)' => 'minuto(s)',
      'month' => 'mes',
      'months' => 'meses',
      'month(s)' => 'mes(es)',
      'week' => 'semana',
      'week(s)' => 'semana(s)',
      'year' => 'a&ntilde;o',
      'years' => 'a&ntilde;os',
      'year(s)' => 'a&ntilde;o(s)',
      'wrote' => 'escribió',
      'Message' => 'Mensaje',
      'Error' => '',
      'Bug Report' => 'Reporte de errores',
      'Attention' => 'Atención',
      'Warning' => 'Atención',
      'Module' => 'Módulo',
      'Modulefile' => 'Archivo de módulo',
      'Subfunction' => 'Subfunciones',
      'Line' => 'Linea',
      'Example' => 'Ejemplo',
      'Examples' => 'Ejemplos',
      'valid' => 'valido',
      'invalid' => 'inválido',
      'invalid-temporarily' => 'invalido-temporalmente',
      ' 2 minutes' => ' 2 minutos',
      ' 5 minutes' => ' 5 minutos',
      ' 7 minutes' => ' 7 minutos',
      '10 minutes' => '10 minutos',
      '15 minutes' => '15 minutos',
      'Mr.' => 'Sr.',
      'Mrs.' => 'Sra.',
      'Next' => 'Siguiente',
      'Back' => 'Regresar',
      'Next...' => 'Siguiente...',
      '...Back' => '..Regresar',
      '-none-' => '-nada-',
      'none' => 'nada',
      'none!' => 'nada!',
      'none - answered' => 'nada  - respondido',
      'please do not edit!' => 'Por favor no lo edite!',
      'AddLink' => 'Adicionar enlace',
      'Link' => 'Vinculo',
      'Linked' => 'Enlazado',
      'Link (Normal)' => 'Enlace (Normal)',
      'Link (Parent)' => 'Enlace (Padre)',
      'Link (Child)' => 'Enlace (Hijo)',
      'Normal' => '',
      'Parent' => 'Padre',
      'Child' => 'Hijo',
      'Hit' => '',
      'Hits' => '',
      'Text' => 'Texto',
      'Lite' => 'Chica',
      'User' => 'Usuario',
      'Username' => 'Nombre de Usuario',
      'Language' => 'Idioma',
      'Languages' => 'Idiomas',
      'Password' => 'Contrase&ntilde;a',
      'Salutation' => 'Saludo',
      'Signature' => 'Firmas',
      'Customer' => 'Cliente',
      'CustomerID' => 'Número de cliente',
      'CustomerIDs' => '',
      'customer' => 'cliente',
      'agent' => 'agente',
      'system' => 'Sistema',
      'Customer Info' => 'Información del cliente',
      'go!' => 'ir!',
      'go' => 'ir',
      'All' => 'Todo',
      'all' => 'todo',
      'Sorry' => 'Disculpe',
      'update!' => 'Actualizar!',
      'update' => 'actualizar',
      'Update' => 'Actualizar',
      'submit!' => 'enviar!',
      'submit' => 'enviar',
      'Submit' => 'Enviar',
      'change!' => 'cambiar!',
      'Change' => 'Cambiar',
      'change' => 'cambiar',
      'click here' => 'haga click aquí',
      'Comment' => 'Comentario',
      'Valid' => 'Válido',
      'Invalid Option!' => 'Opcion no valida',
      'Invalid time!' => 'Hora no valida',
      'Invalid date!' => 'Fecha no valida',
      'Name' => 'Nombre',
      'Group' => 'Grupo',
      'Description' => 'Descripción',
      'description' => 'descripción',
      'Theme' => 'Tema',
      'Created' => 'Creado',
      'Created by' => 'Creado por',
      'Changed' => 'Modificado',
      'Changed by' => 'Modificado por',
      'Search' => 'Buscar',
      'and' => 'y',
      'between' => 'entre',
      'Fulltext Search' => 'Busqueda de texto completo',
      'Data' => 'Datos',
      'Options' => 'Opciones',
      'Title' => 'Titulo',
      'Item' => 'Articulo',
      'Delete' => 'Borrar',
      'Edit' => 'Editar',
      'View' => 'Ver',
      'Number' => 'Numero',
      'System' => 'Sistema',
      'Contact' => 'Contacto',
      'Contacts' => 'Contactos',
      'Export' => 'Exportar',
      'Up' => 'Arriba',
      'Down' => 'Abajo',
      'Add' => 'Adicionar',
      'Category' => 'Categoria',
      'Viewer' => 'Visor',
      'New message' => 'Nuevo mensaje',
      'New message!' => 'Nuevo mensaje!',
      'Please answer this ticket(s) to get back to the normal queue view!' => 'Por favor responda el ticket para regresar a la vista normal de la cola.',
      'You got new message!' => 'Ud tiene un nuevo mensaje',
      'You have %s new message(s)!' => 'Ud tiene %s nuevos mensaje(s)!',
      'You have %s reminder ticket(s)!' => 'Ud tiene %s tickets recordatorios',
      'The recommended charset for your language is %s!' => 'EL juego de caracteres recomendado para su idioma es %s!',
      'Passwords dosn\'t match! Please try it again!' => 'Las contrase&ntilde;as no coinciden. Por favor Reintente!',
      'Password is already in use! Please use an other password!' => 'La contrase&ntilde;a ya se esta utilizando! Por Favor utilice otra!',
      'Password is already used! Please use an other password!' => 'La contrase&ntilde;a ya fue usada! Por favor use otra!',
      'You need to activate %s first to use it!' => 'Necesita activar %s primero para usarlo!',
      'No suggestions' => 'Sin sugerencias',
      'Word' => 'Palabra',
      'Ignore' => 'Ignorar',
      'replace with' => 'reemplazar con',
      'Welcome to OTRS' => 'Bienvenido a OTRS',
      'There is no account with that login name.' => 'No existe una cuenta con ese login',
      'Login failed! Your username or password was entered incorrectly.' => 'Identificación incorrecta. Su nombre de usuario o contrase&ntilde;a fue introducido incorrectamente',
      'Please contact your admin' => 'Por favor contace su administrador',
      'Logout successful. Thank you for using OTRS!' => 'Desconexión exitosa. Gracias por utilizar OTRS!',
      'Invalid SessionID!' => 'Sesión no válida',
      'Feature not active!' => 'Característica no activa',
      'Take this Customer' => 'Tomar este cliente',
      'Take this User' => 'Tomar este usuario',
      'possible' => 'posible',
      'reject' => 'rechazar',
      'Facility' => 'Instalación',
      'Timeover' => '',
      'Pending till' => 'Pendiente hasta',
      'Don\'t work with UserID 1 (System account)! Create new users!' => 'No trabaje con el Identificador 1 (cuenta de sistema)! Cree nuevos usuarios! ',
      'Dispatching by email To: field.' => 'Despachar por correo del campo To:',
      'Dispatching by selected Queue.' => 'Despachar por la cola seleccionada',
      'No entry found!' => 'No se encontró!',
      'Session has timed out. Please log in again.' => 'La sesión ha expirado. Por favor conectese nuevamente.',
      'No Permission!' => 'No tiene Permiso!',
      'To: (%s) replaced with database email!' => 'To: (%s) sustituido con email de la base de datos!',
      'Cc: (%s) added database email!' => 'Cc: (%s) A&ntilde;adido a la base de correo!',
      '(Click here to add)' => '(Haga click aqui para agregar)',
      'Preview' => 'Vista Previa',
      'Added User "%s"' => 'A&ntilde;adido Usuario "%s"',
      'Contract' => 'Contrato',
      'Online Customer: %s' => 'Cliente Conectado: %s',
      'Online Agent: %s' => 'Agente Conectado: %s',
      'Calendar' => 'Calendario',
      'File' => 'Archivo',
      'Filename' => 'Nombre del archivo',
      'Type' => 'Tipo',
      'Size' => 'Tama&ntilde;o',
      'Upload' => 'Subir',
      'Directory' => 'Directorio',
      'Signed' => 'Firmado',
      'Sign' => 'Firma',
      'Crypted' => 'Encriptado',
      'Crypt' => 'Encriptar',

      # Template: AAAMonth
      'Jan' => 'Ene',
      'Feb' => '',
      'Mar' => '',
      'Apr' => 'Abr',
      'May' => '',
      'Jun' => '',
      'Jul' => '',
      'Aug' => 'Ago',
      'Sep' => '',
      'Oct' => '',
      'Nov' => '',
      'Dec' => 'Dic',

      # Template: AAANavBar
      'Admin-Area' => 'Area de administración',
      'Agent-Area' => 'Area-Agente',
      'Ticket-Area' => 'Area-Ticket',
      'Logout' => 'Desconectarse',
      'Agent Preferences' => 'Preferencias de Agente',
      'Preferences' => 'Preferencias',
      'Agent Mailbox' => 'Buzón de Agente',
      'Stats' => 'Estadisticas',
      'Stats-Area' => 'Area-Estadisticas',
      'FAQ-Area' => 'Area-FAQ',
      'FAQ' => '',
      'FAQ-Search' => 'FAQ-Buscar',
      'FAQ-Article' => 'FAQ-Articulo',
      'New Article' => 'Nuevo Articulo',
      'FAQ-State' => 'FAQ-Estado',
      'Admin' => '',
      'A web calendar' => 'Calendario Web',
      'WebMail' => '',
      'A web mail client' => 'Un cliente de correo Web',
      'FileManager' => 'Administrador de Archivos',
      'A web file manager' => 'Administrador web de archivos',
      'Artefact' => 'Artefacto',
      'Incident' => 'Incidente',
      'Advisory' => 'Advertencia',
      'WebWatcher' => '',
      'Customer Users' => 'Clientes',
      'Customer Users <-> Groups' => 'Clientes <-> Grupos',
      'Users <-> Groups' => 'Usuarios <-> Grupos',
      'Roles' => '',
      'Roles <-> Users' => 'Roles <-> Usuarios',
      'Roles <-> Groups' => 'Roles <-> Grupos',
      'Salutations' => 'Saludos',
      'Signatures' => 'Firmas',
      'Email Addresses' => 'Direcciones de Correo',
      'Notifications' => 'Notificaciones',
      'Category Tree' => 'Arbol de categorias',
      'Admin Notification' => 'Notificacion al Administrador',

      # Template: AAAPreferences
      'Preferences updated successfully!' => 'Las preferencia fueron actualizadas!',
      'Mail Management' => 'Gestión de Correos',
      'Frontend' => 'Frontal',
      'Other Options' => 'Otras Opciones',
      'Change Password' => 'Cambiar contrase&ntilde;a',
      'New password' => 'Nueva contrase&ntilde;a',
      'New password again' => 'Repetir Contrase&ntilde;a',
      'Select your QueueView refresh time.' => 'Seleccione su tiempo de actualización de la vista de colas',
      'Select your frontend language.' => 'Seleccione su idioma de trabajo',
      'Select your frontend Charset.' => 'Seleccione su juego de caracteres',
      'Select your frontend Theme.' => 'Seleccione su tema',
      'Select your frontend QueueView.' => 'Seleccione su Vista de cola de trabajo',
      'Spelling Dictionary' => 'Diccionario Ortográfico',
      'Select your default spelling dictionary.' => 'Seleccione su diccionario por defecto',
      'Max. shown Tickets a page in Overview.' => 'Cantidad de Tickets a mostrar en Resumen',
      'Can\'t update password, passwords dosn\'t match! Please try it again!' => 'No se puede actualizar la contrase&ntilde;a, no coinciden! Por favor reintentelo!',
      'Can\'t update password, invalid characters!' => 'No se puede actualizar la contrase&ntilde;a, caracteres no validos!',
      'Can\'t update password, need min. 8 characters!' => 'No se puede actualizar la contrase&ntilde;a, se necesitan al menos 8 caracteres',
      'Can\'t update password, need 2 lower and 2 upper characters!' => 'No se puede actualizar la contrase&ntilde;a, se necesitan al menos 2 en minuscula y 2 en mayuscula!',
      'Can\'t update password, need min. 1 digit!' => 'No se puede actualizar la contrase&ntilde;a, se necesita al menos 1 digito!',
      'Can\'t update password, need min. 2 characters!' => 'No se puede actualizar la contrase&ntilde;a, se necesitan al menos 2 caracteres!',
      'Password is needed!' => 'Falta la contrase&ntilde;a!',

      # Template: AAATicket
      'Lock' => 'Bloquear',
      'Unlock' => 'Desbloquear',
      'History' => 'Historia',
      'Zoom' => 'Detalle',
      'Age' => 'Antiguedad',
      'Bounce' => 'Rebotar',
      'Forward' => 'Reenviar',
      'From' => 'De',
      'To' => 'Para',
      'Cc' => 'Copia ',
      'Bcc' => 'Copia Invisible',
      'Subject' => 'Asunto',
      'Move' => 'Mover',
      'Queue' => 'Colas',
      'Priority' => 'Prioridad',
      'State' => 'Estado',
      'Compose' => 'Redactar',
      'Pending' => 'Pendiente',
      'Owner' => 'Propietario',
      'Owner Update' => 'Actualizar Propietario',
      'Sender' => 'Emisor',
      'Article' => 'Artículo',
      'Ticket' => '',
      'Createtime' => 'Fecha de creaci&ntilde;n ',
      'plain' => 'texto',
      'eMail' => 'Correo',
      'email' => 'correo',
      'Close' => 'Cerrar',
      'Action' => 'Acción',
      'Attachment' => 'Anexo',
      'Attachments' => 'Anexos',
      'This message was written in a character set other than your own.' => 'Este mensaje fue escrito usando un juego de caracteres distinto al suyo',
      'If it is not displayed correctly,' => 'Si no se muestra correctamente',
      'This is a' => 'Este es un',
      'to open it in a new window.' => 'Para abrir en una nueva ventana',
      'This is a HTML email. Click here to show it.' => 'Este es un mensaje HTML. Haga click aquí para mostrarlo.',
      'Free Fields' => 'Campos Libres',
      'Merge' => 'Mezclar',
      'closed successful' => 'cerrado exitosamente',
      'closed unsuccessful' => 'cerrado sin éxito',
      'new' => 'nuevo',
      'open' => 'abierto',
      'closed' => 'cerrado',
      'removed' => 'eliminado',
      'pending reminder' => 'recordatorio pendiente',
      'pending auto close+' => 'pendiente auto close+',
      'pending auto close-' => 'pendiente auto close-',
      'email-external' => 'correo-externo',
      'email-internal' => 'correo-interno',
      'note-external' => 'nota-externa',
      'note-internal' => 'nota-interna',
      'note-report' => 'nota-reporte',
      'phone' => 'teléfono',
      'sms' => '',
      'webrequest' => 'Solicitud via web',
      'lock' => 'bloqueado',
      'unlock' => 'desbloqueado',
      'very low' => 'muy bajo',
      'low' => 'bajo',
      'normal' => '',
      'high' => 'alto',
      'very high' => 'muy alto',
      '1 very low' => '1 muy bajo',
      '2 low' => '2 bajo',
      '3 normal' => '',
      '4 high' => '4 alto',
      '5 very high' => '5 muy alto',
      'Ticket "%s" created!' => 'Ticket "%s" creado!',
      'Ticket Number' => 'Ticket Número',
      'Ticket Object' => 'Objeto Ticket',
      'No such Ticket Number "%s"! Can\'t link it!' => 'No existe el Ticket Numero "%s"! No puede vincularlo!',
      'Don\'t show closed Tickets' => 'No mostrar los tickets cerrados',
      'Show closed Tickets' => 'Mostrar Tickets cerrados',
      'Email-Ticket' => 'Ticket-Correo',
      'Create new Email Ticket' => '',
      'Phone-Ticket' => 'Ticket-Telefonico',
      'Create new Phone Ticket' => 'Crear un nuevo Ticket Telefonico',
      'Search Tickets' => 'Buscar Tickets',
      'Edit Customer Users' => 'Editar Clientes',
      'Bulk-Action' => 'Accion Multiple',
      'Bulk Actions on Tickets' => 'Accion Multiple en Tickets',
      'Send Email and create a new Ticket' => 'Enviar un correo y crear un nuevo ticket',
      'Overview of all open Tickets' => 'Resumen de todos los tickets abiertos',
      'Locked Tickets' => 'Tickets Bloqueados',
      'Lock it to work on it!' => 'Bloquearlo para trabajar en el!',
      'Unlock to give it back to the queue!' => 'Desbloquearlo para regresarlo a la cola!',
      'Shows the ticket history!' => 'Mostrar la historia del ticket!',
      'Print this ticket!' => 'Imprimir este ticket!',
      'Change the ticket priority!' => 'Cambiar la prioridad del ticket!',
      'Change the ticket free fields!' => 'Cambiar los campos libres del ticket!',
      'Link this ticket to an other objects!' => 'Enlazar este ticket a otros objetos',
      'Change the ticket owner!' => 'Cambiar el propietario del ticket!',
      'Change the ticket customer!' => 'Cambiar el cliente del ticket!',
      'Add a note to this ticket!' => 'Adicionar una nota a este ticket!',
      'Merge this ticket!' => 'Unir este ticket!',
      'Set this ticket to pending!' => 'Colocar este ticket como pendiente!',
      'Close this ticket!' => 'Cerrar este ticket!',
      'Look into a ticket!' => 'Revisar un ticket',
      'Delete this ticket!' => 'Eliminar este ticket!',
      'Mark as Spam!' => 'Parcar como correo no deseado!',
      'My Queues' => 'Mis Colas',
      'Shown Tickets' => 'Mostrar Tickets',
      'New ticket notification' => 'Notificación de nuevos tickets',
      'Send me a notification if there is a new ticket in "My Queues".' => 'Notifíqueme si hay un nuevo ticket en "Mis Colas".',
      'Follow up notification' => 'Seguimiento a notificaciones',
      'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.' => 'Notifíqueme si un cliente enví un seguimiento y yo soy el due&ntilde;o del ticket.',
      'Ticket lock timeout notification' => 'Notificación de bloqueo de tickets por tiempo',
      'Send me a notification if a ticket is unlocked by the system.' => 'Notifíqueme si un ticket es desbloqueado por el sistema',
      'Move notification' => 'Notificación de movimientos',
      'Send me a notification if a ticket is moved into one of "My Queues".' => 'Notifíqueme si un ticket es colocado en una de "Mis Colas".',
      'Your queue selection of your favorite queues. You also get notified about this queues via email if enabled.' => '',
      'Custom Queue' => 'Cola personal',
      'QueueView refresh time' => 'Tiempo de actualización de la vista de colas',
      'Screen after new ticket' => 'Pantalla posterior a nuevo ticket',
      'Select your screen after creating a new ticket.' => 'Seleccione la pantalla a mostrar despues de crear un ticket',
      'Closed Tickets' => 'Tickets Cerrados',
      'Show closed tickets.' => 'Mostrar Tickets cerrados',
      'Max. shown Tickets a page in QueueView.' => 'Cantidad de Tickets a mostrar en la Vista de Cola',
      'Responses' => 'Respuestas',
      'Responses <-> Queue' => 'Respuestas <-> Colas',
      'Auto Responses' => 'Respuestas Automaticas',
      'Auto Responses <-> Queue' => 'Respuestas Automaticas <-> Colas',
      'Attachments <-> Responses' => 'Anexos <-> Respuestas',
      'History::Move' => 'Ticket movido a la cola "%s" (%s) de la cola "%s" (%s).',
      'History::NewTicket' => 'Nuevo Ticket [%s] createdo (Q=%s;P=%s;S=%s).',
      'History::FollowUp' => 'Seguimiento para [%s]. %s',
      'History::SendAutoReject' => 'Rechazo automático enviado a "%s".',
      'History::SendAutoReply' => 'Respuesta automática enviada a "%s".',
      'History::SendAutoFollowUp' => 'Seguimiento automático enviado a "%s".',
      'History::Forward' => 'Reenviado a "%s".',
      'History::Bounce' => 'Reenviado a "%s".',
      'History::SendAnswer' => 'Correo enviado a "%s".',
      'History::SendAgentNotification' => '"%s"-notificación enviada a "%s".',
      'History::SendCustomerNotification' => 'Notificaci&oacuten; enviada a "%s".',
      'History::EmailAgent' => 'Correo enviado al cliente.',
      'History::EmailCustomer' => 'Adicionado correo. %s',
      'History::PhoneCallAgent' => 'El agente llamó al cliente.',
      'History::PhoneCallCustomer' => 'El cliente llamó.',
      'History::AddNote' => 'Adicionada nota (%s)',
      'History::Lock' => 'Ticket bloqueado.',
      'History::Unlock' => 'Ticket desbloqueado.',
      'History::TimeAccounting' => '%s unidad(es) de tiempo contabilizadas. Nuevo total : %s uniodad(es) de tiempo.',
      'History::Remove' => '%s',
      'History::CustomerUpdate' => 'Actualizado: %s',
      'History::PriorityUpdate' => 'Cambiar prioridad de "%s" (%s) a "%s" (%s).',
      'History::OwnerUpdate' => 'El nuevo propietario es "%s" (ID=%s).',
      'History::LoopProtection' => 'Protección de lazo! NO se envio auto-respuesta a "%s".',
      'History::Misc' => '%s',
      'History::SetPendingTime' => 'Actualizado: %s',
      'History::StateUpdate' => 'Antiguo: "%s" Nuevo: "%s"',
      'History::TicketFreeTextUpdate' => 'Actualizado: %s=%s;%s=%s;',
      'History::WebRequestCustomer' => 'Solicitud de cliente via web.',
      'History::TicketLinkAdd' => 'Adicionado enlace al ticket "%s".',
      'History::TicketLinkDelete' => 'Eliminado enlace al ticket "%s".',

      # Template: AAAWeekDay
      'Sun' => 'Dom',
      'Mon' => 'Lun',
      'Tue' => 'Mar',
      'Wed' => 'Mie',
      'Thu' => 'Jue',
      'Fri' => 'Vie',
      'Sat' => 'Sab',

      # Template: AdminAttachmentForm
      'Attachment Management' => 'Gestión de Anexos',

      # Template: AdminAutoResponseForm
      'Auto Response Management' => 'Gestión de respuestas automáticas',
      'Response' => 'Respuesta',
      'Auto Response From' => 'Respuesta automática de ',
      'Note' => 'Nota',
      'Useable options' => 'Opciones accesibles',
      'to get the first 20 character of the subject' => 'para obtener los primeros 20 caracteres del asunto ',
      'to get the first 5 lines of the email' => 'para obtener las primeras 5 líneas del correo',
      'to get the from line of the email' => 'para obtener la linea from del correo',
      'to get the realname of the sender (if given)' => 'para obtener el nombre del emisor (si lo proporcionó)',
      'Options of the ticket data (e. g. &lt;OTRS_TICKET_Number&gt;, &lt;OTRS_TICKET_ID&gt;, &lt;OTRS_TICKET_Queue&gt;, &lt;OTRS_TICKET_State&gt;)' => '',

      # Template: AdminCustomerUserForm
      'The message being composed has been closed.  Exiting.' => 'El mensaje que se estaba redactando ha sido cerrado. Saliendo.!',
      'This window must be called from compose window' => 'Esta ventana debe ser llamada desde la ventana de redacción',
      'Customer User Management' => 'Gestión de clientes',
      'Search for' => 'Buscar por',
      'Result' => 'Resultado',
      'Select Source (for add)' => 'Seleccionar Fuente (para adicionar)',
      'Source' => 'Origen',
      'This values are read only.' => 'Estos valores son solo-lectura',
      'This values are required.' => 'Estos valores son obligatorios',
      'Customer user will be needed to have an customer histor and to to login via customer panels.' => 'El cliente necesita tener una historia y conectarse via panel de clientes',

      # Template: AdminCustomerUserGroupChangeForm
      'Customer Users <-> Groups Management' => 'Clientes <-> Gestion de Grupos',
      'Change %s settings' => 'Cambiar %s especificaciones',
      'Select the user:group permissions.' => 'Seleccionar los permisos de usuario:grupo',
      'If nothing is selected, then there are no permissions in this group (tickets will not be available for the user).' => 'Si no se selecciona algo, no habrán permisos en este grupo (Los tickets no estarán disponibles para este cliente).',
      'Permission' => 'Permisos',
      'ro' => '',
      'Read only access to the ticket in this group/queue.' => 'Acceso de solo lectura a los tickets en este grupo/cola.',
      'rw' => '',
      'Full read and write access to the tickets in this group/queue.' => 'Acceso completo de lectura y escritura a los tickets en este grupo/cola.',

      # Template: AdminCustomerUserGroupForm

      # Template: AdminEmail
      'Message sent to' => 'Mensaje enviado a',
      'Recipents' => 'Destinatarios',
      'Body' => 'Cuerpo',
      'send' => 'enviar',

      # Template: AdminGenericAgent
      'GenericAgent' => '',
      'Job-List' => 'Lista de Tareas',
      'Last run' => 'Última corrida',
      'Run Now!' => 'Ejecutar ahora',
      'x' => '',
      'Save Job as?' => 'Guardar Tarea como?',
      'Is Job Valid?' => 'Es la tarea Valida?',
      'Is Job Valid' => 'Es una tarea valida',
      'Schedule' => 'Horario',
      'Fulltext-Search in Article (e. g. "Mar*in" or "Baue*")' => 'Búsqueda de texto en Articulo (ej. "Mar*in" or "Baue*")',
      '(e. g. 10*5155 or 105658*)' => '',
      '(e. g. 234321)' => '',
      'Customer User Login' => 'Identificador del cliente',
      '(e. g. U5150)' => '',
      'Agent' => 'Agente',
      'TicketFreeText' => '',
      'Ticket Lock' => 'Ticket Bloqueado',
      'Times' => 'Veces',
      'No time settings.' => 'Sin especificación de fecha',
      'Ticket created' => 'Ticket creado',
      'Ticket created between' => 'Ticket creado entre',
      'New Priority' => 'Nueva prioridad',
      'New Queue' => 'Nueva Cola',
      'New State' => 'Nuevo estado',
      'New Agent' => 'Nuevo Agente',
      'New Owner' => 'Nuevo Propietario',
      'New Customer' => 'Nuevo Cliente',
      'New Ticket Lock' => 'Nuevo bloqueo de ticket!',
      'CustomerUser' => 'Usuario Cliente',
      'Add Note' => 'Adicionar Nota',
      'CMD' => '',
      'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' => 'Se ejecutará el comando. ARG[0] el número del ticket. ARG[0] el id del ticket.',
      'Delete tickets' => 'Eliminar tickets',
      'Warning! This tickets will be removed from the database! This tickets are lost!' => 'Aviso! Estos tickets serán eliminados de la base de datos! Los mismos se perderán!',
      'Modules' => 'Módulos',
      'Param 1' => 'Parámetro 1',
      'Param 2' => 'Parámetro 2',
      'Param 3' => 'Parámetro 3',
      'Param 4' => 'Parámetro 4',
      'Param 5' => 'Parámetro 5',
      'Param 6' => 'Parámetro 6',
      'Save' => 'Guardar',

      # Template: AdminGroupForm
      'Group Management' => 'Administración de grupos',
      'The admin group is to get in the admin area and the stats group to get stats area.' => 'El grupo admin es para usar el área de administración y el grupo stats para usar el área estadisticas.',
      'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).' => 'Crear nuevos grupos para manipular los permisos de acceso por distintos grupos de agente (ejemplo: departamento de compra, departamento de soporte, departamento de ventas,...).',
      'It\'s useful for ASP solutions.' => 'Esto es útil para soluciones ASP.',

      # Template: AdminLog
      'System Log' => 'Trazas del Sistema',
      'Time' => 'Tiempo',

      # Template: AdminNavigationBar
      'Users' => 'Usuarios',
      'Groups' => 'Grupos',
      'Misc' => 'Miscelaneas',

      # Template: AdminNotificationForm
      'Notification Management' => 'Gestión de Notificaciones',
      'Notification' => 'Notificacion',
      'Notifications are sent to an agent or a customer.' => 'Las notificación se le envian a un agente o cliente',
      'Config options (e. g. &lt;OTRS_CONFIG_HttpType&gt;)' => 'Opciones de configuración (ej: &lt;OTRS_CONFIG_HttpType&gt;)',
      'Ticket owner options (e. g. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)' => 'Opciones de propietario del ticket (ej. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)',
      'Options of the current user who requested this action (e. g. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)' => 'Opciones del usuario activo que solicita esta acción (ej. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)',
      'Options of the current customer user data (e. g. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)' => 'Opciones del usuario activo',

      # Template: AdminPackageManager
      'Package Manager' => 'Gestor de paquete',
      'Uninstall' => 'Desinstalar',
      'Verion' => '',
      'Do you really want to uninstall this package?' => 'Seguro que desea desinstalar este paquete?',
      'Install' => 'Instalar',
      'Package' => 'Paquete',
      'Online Repository' => 'Reporsitorio Online',
      'Version' => '',
      'Vendor' => 'Vendedor',
      'Upgrade' => 'Actualizar',
      'Local Repository' => 'Repositorio Local',
      'Status' => 'Estado',
      'Overview' => 'Resumen',
      'Download' => 'Descargar',
      'Rebuild' => 'Reconstruir',
      'Reinstall' => 'Reinstalar',

      # Template: AdminPGPForm
      'PGP Management' => 'Administracion PGP',
      'Identifier' => 'Identificador',
      'Bit' => '',
      'Key' => 'Llave',
      'Fingerprint' => '',
      'Expires' => 'Expira',
      'In this way you can directly edit the keyring configured in SysConfig.' => 'De esta forma puede editar directamente el anillo de Llaves configurado en Sysconfig',

      # Template: AdminPOP3Form
      'POP3 Account Management' => 'Gestión de cuenta POP3',
      'Host' => '',
      'Trusted' => 'Confiable',
      'Dispatching' => 'Remitiendo',
      'All incoming emails with one account will be dispatched in the selected queue!' => 'Todos los correos de entrada serán enviados a la cola seleccionada',
      'If your account is trusted, the already existing x-otrs header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' => 'Si su cuenta es confiable, los headers ya existentes x-otrs en la llegada se utilizarán para la prioridad! El filtro Postmaster se usa de todas formas.',

      # Template: AdminPostMasterFilter
      'PostMaster Filter Management' => 'Gestión del filtro maestro',
      'Filtername' => '',
      'Match' => 'Coincidir',
      'Header' => 'Encabezado',
      'Value' => 'Valor',
      'Set' => '',
      'Do dispatch or filter incoming emails based on email X-Headers! RegExp is also possible.' => 'Clasificar o filtrar correos entrantes basado en el encabezamiento X-Headers del correo! Puede utilizar expresiones regulares.',
      'If you use RegExp, you also can use the matched value in () as [***] in \'Set\'.' => 'Si utilza expresion regular, puede tambien usar el valor encontrado en () as [***] en \'Set\'.',

      # Template: AdminQueueAutoResponseForm
      'Queue <-> Auto Responses Management' => 'Cola <-> Gestion de respuestas automaticas',

      # Template: AdminQueueAutoResponseTable

      # Template: AdminQueueForm
      'Queue Management' => 'Gestión de Colas',
      'Sub-Queue of' => 'Subcola de',
      'Unlock timeout' => 'Tiempo para desbloqueo automático',
      '0 = no unlock' => '0 = sin bloqueo',
      'Escalation time' => 'Tiempo de escalado',
      '0 = no escalation' => '0 = sin escalado',
      'Follow up Option' => 'Opción de seguimiento',
      'Ticket lock after a follow up' => 'Bloquear un ticket después del seguimiento',
      'Systemaddress' => 'Direcciones de correo del sistema',
      'Customer Move Notify' => 'Notificar al Cliente al Mover',
      'Customer State Notify' => 'Notificación de estado al Cliente',
      'Customer Owner Notify' => 'Notificar al Due&ntilde;o al Mover',
      'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.' => 'Si un agente bloquea un ticket y el/ella no enví una respuesta en este tiempo, el ticket sera desbloqueado automáticamente',
      'If a ticket will not be answered in thos time, just only this ticket will be shown.' => 'Si un ticket no ha sido respondido es este tiempo, solo este ticket se mostrará',
      'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.' => 'Si el tickes esta cerrado y el cliente enví un seguimiento al mismo este será bloqueado para el antiguo propietario',
      'Will be the sender address of this queue for email answers.' => 'Será la dirección del emisor en esta cola para respuestas por correo.',
      'The salutation for email answers.' => 'Saludo para las respuestas por correo.',
      'The signature for email answers.' => 'Firma para respuestas por correo.',
      'OTRS sends an notification email to the customer if the ticket is moved.' => 'OTRS envía una notificación por correo si el ticket se mueve',
      'OTRS sends an notification email to the customer if the ticket state has changed.' => 'OTRS envía una notificación por correo al cliente si el estado del ticket cambia',
      'OTRS sends an notification email to the customer if the ticket owner has changed.' => 'OTRS envía una notificación por correo al cliente si el due&ntildeo; del ticket cambia',

      # Template: AdminQueueResponsesChangeForm
      'Responses <-> Queue Management' => 'Respuestas <-> Gestion de Colas',

      # Template: AdminQueueResponsesForm
      'Answer' => 'Responder',

      # Template: AdminResponseAttachmentChangeForm
      'Responses <-> Attachments Management' => 'respuestas <-> Gestion de Anexos',

      # Template: AdminResponseAttachmentForm

      # Template: AdminResponseForm
      'Response Management' => 'Gestión de respuestas',
      'A response is default text to write faster answer (with default text) to customers.' => 'Una respuesta es el texto por defecto para escribir respuestas más rapido (con el texto por defecto) a los clientes.',
      'Don\'t forget to add a new response a queue!' => 'No olvide incluir una nueva respuesta en la cola!',
      'Next state' => 'Siguiente estado',
      'All Customer variables like defined in config option CustomerUser.' => 'Todas las variables de cliente como aparecen declaradas en la opcion de configuracion del cliente',
      'The current ticket state is' => 'El estado actual del ticket es',
      'Your email address is new' => 'Su dirección de correo es nueva',

      # Template: AdminRoleForm
      'Role Management' => 'Gestión de Roles',
      'Create a role and put groups in it. Then add the role to the users.' => 'Crea un rol y coloca grupos en el mismo. Luego adiciona el rol a los usuarios.',
      'It\'s useful for a lot of users and groups.' => 'Es útil para gestionar muchos usuarios y grupos.',

      # Template: AdminRoleGroupChangeForm
      'Roles <-> Groups Management' => 'Roles <-> Gestion de grupos',
      'move_into' => 'mover_a',
      'Permissions to move tickets into this group/queue.' => 'Permiso para mover tickets a este grupo/cola',
      'create' => 'crear',
      'Permissions to create tickets in this group/queue.' => 'Permiso para crear tickets en este grupo/cola',
      'owner' => 'propietario',
      'Permissions to change the ticket owner in this group/queue.' => 'Permiso para cambiar el propietario del ticket en este grupo/cola',
      'priority' => 'prioridad',
      'Permissions to change the ticket priority in this group/queue.' => 'Permiso para cambiar la prioridad del ticket en este grupo/cola',

      # Template: AdminRoleGroupForm
      'Role' => 'Rol',

      # Template: AdminRoleUserChangeForm
      'Roles <-> Users Management' => 'Roles <-> Gestion de Usuarios',
      'Active' => 'Activo',
      'Select the role:user relations.' => 'Seleccionar las relaciones Rol-Cliente',

      # Template: AdminRoleUserForm

      # Template: AdminSalutationForm
      'Salutation Management' => 'Gestión de saludos',
      'customer realname' => 'Nombre del cliente',
      'for agent firstname' => 'nombre del agente',
      'for agent lastname' => 'apellido del agente',
      'for agent user id' => 'id del agente',
      'for agent login' => 'login del agente',

      # Template: AdminSelectBoxForm
      'Select Box' => 'Ventana de selección',
      'SQL' => '',
      'Limit' => 'Límite',
      'Select Box Result' => 'Seleccione tipo de resultado',

      # Template: AdminSession
      'Session Management' => 'Gestión de sesiones',
      'Sessions' => 'Sesiones',
      'Uniq' => '',
      'kill all sessions' => 'Finalizar todas las sesiones',
      'Session' => 'Sesión',
      'kill session' => 'Finalizar una sesión',

      # Template: AdminSignatureForm
      'Signature Management' => 'Gestión de firmas',

      # Template: AdminSMIMEForm
      'SMIME Management' => 'Gestion SMIME',
      'Add Certificate' => 'Adicionar un certificado',
      'Add Private Key' => 'Adicionar una Llave privada',
      'Secret' => 'Secreto',
      'Hash' => '',
      'In this way you can directly edit the certification and private keys in file system.' => 'De esta fomra Ud puede editar directamente la certificacion y llaves privadas el el sistema de archivos.',

      # Template: AdminStateForm
      'System State Management' => 'Gestión de estados del Sistema',
      'State Type' => 'Tipo de estado',
      'Take care that you also updated the default states in you Kernel/Config.pm!' => 'Recuerde tambien actualizar los estados en su archivo Kernel/Config.pm! ',
      'See also' => 'Vea tambien',

      # Template: AdminSysConfig
      'SysConfig' => '',
      'Group selection' => 'Seleccion de Grupo',
      'Show' => 'Mostrar',
      'Download Settings' => 'Descargar Configuracion',
      'Download all system config changes.' => 'Descargar todos los cambios de configuracion',
      'Load Settings' => 'Cargar Configuracion',
      'Subgroup' => 'Subgrupo',
      'Elements' => 'Elementos',

      # Template: AdminSysConfigEdit
      'Config Options' => 'Opciones de Configuracion',
      'Default' => '',
      'Content' => 'Contenido',
      'New' => 'Nuevo',
      'New Group' => 'Nuevo grupo',
      'Group Ro' => 'Grupo Ro',
      'New Group Ro' => 'Nuevo Grupo Ro',
      'NavBarName' => '',
      'Image' => 'Imagen',
      'Prio' => '',
      'Block' => '',
      'NavBar' => '',
      'AccessKey' => '',

      # Template: AdminSystemAddressForm
      'System Email Addresses Management' => 'Gestión de direcciones de correo del sistema',
      'Email' => 'Correo',
      'Realname' => 'Nombre real',
      'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!' => 'Todos los mensajes entrantes con este correo(To:) serán enviados a la cola seleccionada!',

      # Template: AdminUserForm
      'User Management' => 'Administración de usuarios',
      'Firstname' => 'Nombre',
      'Lastname' => 'Apellido',
      'User will be needed to handle tickets.' => 'Se necesita un usuario para manipular los tickets.',
      'Don\'t forget to add a new user to groups and/or roles!' => 'No olvide adicionar los nuevos usuario a los grupos y/o roles',

      # Template: AdminUserGroupChangeForm
      'Users <-> Groups Management' => 'Usuarios <-> Gestion de Grupos',

      # Template: AdminUserGroupForm

      # Template: AgentBook
      'Address Book' => 'Libreta de Direcciones',
      'Return to the compose screen' => 'Regresar a la pantalla de redacción',
      'Discard all changes and return to the compose screen' => 'Descartar todos los cambios y regresar a la pantalla de redacción',

      # Template: AgentCalendarSmall

      # Template: AgentCalendarSmallIcon

      # Template: AgentCustomerTableView

      # Template: AgentInfo
      'Info' => 'Información',

      # Template: AgentLinkObject
      'Link Object' => 'Enlazar Objeto',
      'Select' => 'Seleccionar',
      'Results' => 'Resultados',
      'Total hits' => 'Total de coincidencias',
      'Site' => 'Sitio',
      'Detail' => 'Detalle',

      # Template: AgentLookup
      'Lookup' => '',

      # Template: AgentNavigationBar
      'Ticket selected for bulk action!' => 'Ticket seleccionado para acción múltiple!',
      'You need min. one selected Ticket!' => 'Necesita al menos seleccionar un Ticket!',

      # Template: AgentPreferencesForm

      # Template: AgentSpelling
      'Spell Checker' => 'Chequeo Ortográfico',
      'spelling error(s)' => 'errores gramaticales',
      'or' => 'o',
      'Apply these changes' => 'Aplicar los cambios',

      # Template: AgentTicketBounce
      'A message should have a To: recipient!' => 'El mensaje debe tenes el destinatario To: !',
      'You need a email address (e. g. customer@example.com) in To:!' => 'Necesita una dirección de correo (ejemplo: cliente@ejemplo.com) en To:!',
      'Bounce ticket' => 'Ticket rebotado',
      'Bounce to' => 'Rebotar a',
      'Next ticket state' => 'Nuevo estado del ticket',
      'Inform sender' => 'Informar al emisor',
      'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further informations.' => 'Su correo con el ticket número "<OTRS_TICKET>"  fue rebotado a "<OTRS_BOUNCE_TO>". Contacte dicha dirección para mas información',
      'Send mail!' => 'Enviar correo!',

      # Template: AgentTicketBulk
      'A message should have a subject!' => 'Los mensajes deben tener asunto!',
      'Ticket Bulk Action' => 'Acción múltiple con Tickets',
      'Spell Check' => 'Chequeo Ortográfico',
      'Note type' => 'Tipo de nota',
      'Unlock Tickets' => 'Desbloquear Tickets',

      # Template: AgentTicketClose
      'A message should have a body!' => 'Los mensajes deben tener contenido',
      'You need to account time!' => 'Necesita contabilizar el tiempo!',
      'Close ticket' => 'Cerrar el ticket',
      'Note Text' => 'Nota!',
      'Close type' => 'Tipo de cierre',
      'Time units' => 'Unidades de tiempo',
      ' (work units)' => ' (unidades de trabajo)',

      # Template: AgentTicketCompose
      'A message must be spell checked!' => 'El mensaje debe ser chequeado ortograficamente!',
      'Compose answer for ticket' => 'Redacte una respuesta al ticket',
      'Attach' => 'Anexo',
      'Pending Date' => 'Fecha pendiente',
      'for pending* states' => 'en estado pendiente*',

      # Template: AgentTicketCustomer
      'Change customer of ticket' => 'Cambiar cliente del ticket',
      'Set customer user and customer id of a ticket' => 'Asignar agente y cliente de un ticket',
      'Customer User' => 'Cliente',
      'Search Customer' => 'Búsquedas del cliente',
      'Customer Data' => 'Información del cliente',
      'Customer history' => 'Historia del cliente',
      'All customer tickets.' => 'Todos los tickets de un cliente',

      # Template: AgentTicketCustomerMessage
      'Follow up' => 'Seguimiento',

      # Template: AgentTicketEmail
      'Compose Email' => 'Redactar Correo',
      'new ticket' => 'nuevo ticket',
      'Clear To' => 'Copia Oculta a',
      'All Agents' => 'Todos los Agentes',
      'Termin1' => '',

      # Template: AgentTicketForward
      'Article type' => 'Tipo de artículo',

      # Template: AgentTicketFreeText
      'Change free text of ticket' => 'Cambiar el texto libre del ticket',

      # Template: AgentTicketHistory
      'History of' => 'Historia de',

      # Template: AgentTicketLocked
      'Ticket locked!' => 'Ticket bloqueado!',
      'Ticket unlock!' => 'Ticket desbloqueado!',

      # Template: AgentTicketMailbox
      'Mailbox' => 'Buzón',
      'Tickets' => '',
      'All messages' => 'Todos los mensajes',
      'New messages' => 'Nuevo mensaje',
      'Pending messages' => 'Mensajes pendientes',
      'Reminder messages' => 'Mensajes recordatorios',
      'Reminder' => 'Recordatorio',
      'Sort by' => 'Ordenado por',
      'Order' => 'Orden',
      'up' => 'arriba',
      'down' => 'abajo',

      # Template: AgentTicketMerge
      'You need to use a ticket number!' => 'Necesita user un numero de ticket!',
      'Ticket Merge' => 'Unir Ticket',
      'Merge to' => 'Unir a',
      'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' => 'Su correo con numero de ticket "<OTRS_TICKET>" se unio a "<OTRS_MERGE_TO_TICKET>".',

      # Template: AgentTicketMove
      'Queue ID' => 'Id de la Cola',
      'Move Ticket' => 'Mover Ticket',
      'Previous Owner' => 'Propietario Anterior',

      # Template: AgentTicketNote
      'Add note to ticket' => 'Adicionar nota al ticket',
      'Inform Agent' => 'Notificar Agente',
      'Optional' => 'Opcional',
      'Inform involved Agents' => 'Notificar Agentes involucrados',

      # Template: AgentTicketOwner
      'Change owner of ticket' => 'Cambiar el propietario del ticket',
      'Message for new Owner' => 'Mensaje para el nuevo propietario',

      # Template: AgentTicketPending
      'Set Pending' => 'Indicar pendiente',
      'Pending type' => 'Tipo pendiente',
      'Pending date' => 'Fecha pendiente',

      # Template: AgentTicketPhone
      'Phone call' => 'Llamada telefónica',

      # Template: AgentTicketPhoneNew
      'Clear From' => 'Borrar de',

      # Template: AgentTicketPlain
      'Plain' => 'Texto plano',
      'TicketID' => 'Identificador de Ticket',
      'ArticleID' => 'Identificador de articulo',

      # Template: AgentTicketPrint
      'Ticket-Info' => 'Informacion-Ticket',
      'Accounted time' => 'Tiempo contabilizado',
      'Escalation in' => 'Escalado en',
      'Linked-Object' => 'Objeta-vincular',
      'Parent-Object' => 'Objeto-Padre',
      'Child-Object' => 'Objeto-Hijo',
      'by' => 'por',

      # Template: AgentTicketPriority
      'Change priority of ticket' => 'Cambiar la prioridad al ticket',

      # Template: AgentTicketQueue
      'Tickets shown' => 'Tickets mostrados',
      'Page' => 'Página',
      'Tickets available' => 'Tickets disponibles',
      'All tickets' => 'Todos los tickets',
      'Queues' => 'Colas',
      'Ticket escalation!' => 'Escalado de ticket',

      # Template: AgentTicketQueueTicketView
      'Your own Ticket' => 'Sus tickets',
      'Compose Follow up' => 'Redactar seguimiento',
      'Compose Answer' => 'Responder',
      'Contact customer' => 'Contactar el cliente',
      'Change queue' => 'Cambiar cola',

      # Template: AgentTicketQueueTicketViewLite

      # Template: AgentTicketSearch
      'Ticket Search' => 'Buscar ticket',
      'Profile' => 'Perfil',
      'Search-Template' => 'Buscar-Modelo',
      'Created in Queue' => 'Creado en Cola',
      'Result Form' => 'Modelo de Resultados',
      'Save Search-Profile as Template?' => 'Guardar perfil de búsqueda como patrón?',
      'Yes, save it with name' => 'Si, guardarlo con nombre',
      'Customer history search' => 'Historia de búsquedas del cliente',
      'Customer history search (e. g. "ID342425").' => 'Historia de búsquedas del cliente (ejemplo: "ID342425"',
      'No * possible!' => 'No * posible!',

      # Template: AgentTicketSearchResult
      'Search Result' => 'Buscar resultados',
      'Change search options' => 'Cambiar opciones de búsqueda',

      # Template: AgentTicketSearchResultPrint
      '"}' => '',

      # Template: AgentTicketSearchResultShort
      'sort upward' => 'ordenar ascendente',
      'U' => 'A',
      'sort downward' => 'ordenar descendente',
      'D' => '',

      # Template: AgentTicketStatusView
      'Ticket Status View' => 'Ver Estado de Ticket',
      'Open Tickets' => 'Tickets Abiertos',

      # Template: AgentTicketZoom
      'Split' => 'Dividir',

      # Template: AgentTicketZoomStatus
      'Locked' => 'Bloqueado',

      # Template: AgentWindowTabStart

      # Template: AgentWindowTabStop

      # Template: Copyright

      # Template: css

      # Template: customer-css

      # Template: CustomerAccept

      # Template: CustomerCalendarSmallIcon

      # Template: CustomerError
      'Traceback' => '',

      # Template: CustomerFAQ
      'Print' => 'Imprimir',
      'Keywords' => 'palabras clave',
      'Symptom' => 'Sintoma',
      'Problem' => 'Problema',
      'Solution' => 'Solución',
      'Modified' => 'Modificado',
      'Last update' => 'Ultima Actualización',
      'FAQ System History' => 'Sistema de historia de FAQ',
      'modified' => 'modificado',
      'FAQ Search' => 'Buscar en la FAQ',
      'Fulltext' => 'Texto Completo',
      'Keyword' => 'palabra clave',
      'FAQ Search Result' => 'Resultado de búsqueda en la FAQ',
      'FAQ Overview' => 'Resumen de la FAQ',

      # Template: CustomerFooter
      'Powered by' => '',

      # Template: CustomerFooterSmall

      # Template: CustomerHeader

      # Template: CustomerHeaderSmall

      # Template: CustomerLogin
      'Login' => 'Identificador',
      'Lost your password?' => 'Perdió su contrase&ntilde;a',
      'Request new password' => 'Solicitar una nueva contrase&ntilde;a',
      'Create Account' => 'Crear Cuenta',

      # Template: CustomerNavigationBar
      'Welcome %s' => 'Bienvenido %s',

      # Template: CustomerPreferencesForm

      # Template: CustomerStatusView
      'of' => 'de',

      # Template: CustomerTicketMessage

      # Template: CustomerTicketMessageNew

      # Template: CustomerTicketSearch

      # Template: CustomerTicketSearchResultCSV

      # Template: CustomerTicketSearchResultPrint

      # Template: CustomerTicketSearchResultShort

      # Template: CustomerTicketZoom

      # Template: CustomerWarning

      # Template: Error
      'Click here to report a bug!' => 'Haga click aqui para reportar un error!',

      # Template: FAQ
      'Comment (internal)' => 'Comentario (interno)',
      'A article should have a title!' => 'Los articulos deben tener t&ntilde;tulo',
      'New FAQ Article' => 'Nuevo Articulo de la FAQ',
      'Do you really want to delete this Object?' => 'VErdaderamente desea eliminar esre objeto?',
      'System History' => 'Historia del Sistema',

      # Template: FAQCategoryForm
      'Name is required!' => 'Debe especificar nombre!',
      'FAQ Category' => 'Categoria de FAQ',

      # Template: FAQLanguageForm
      'FAQ Language' => 'Idioma de la FAQ',

      # Template: Footer
      'QueueView' => 'Ver la cola',
      'PhoneView' => 'Vista telefónica',
      'Top of Page' => 'Inicio de página',

      # Template: FooterSmall

      # Template: Header
      'Home' => 'Inicio',

      # Template: HeaderSmall

      # Template: Installer
      'Web-Installer' => 'Instalador Web',
      'accept license' => 'aceptar licencia',
      'don\'t accept license' => 'no acepto la licencia',
      'Admin-User' => 'Usuario-Admin',
      'Admin-Password' => 'Contraseña-Administrador',
      'your MySQL DB should have a root password! Default is empty!' => 'Su BD MySQL debe tener una contrase&ntiulde; de root! Por defecto es va&itilde;a!',
      'Database-User' => '',
      'default \'hot\'' => 'por defecto \'hot\'',
      'DB connect host' => '',
      'Database' => 'Base de Datos',
      'Create' => 'Crear',
      'false' => 'falso',
      'SystemID' => 'ID de sistema',
      '(The identify of the system. Each ticket number and each http session id starts with this number)' => '(La identidad del sistema. Cada número de ticket y cada id de sesi&oacuten http comienza con este número)',
      'System FQDN' => 'FQDN del sistema',
      '(Full qualified domain name of your system)' => '(Nombre completo del dominio de su sistema)',
      'AdminEmail' => 'Correo del administrador.',
      '(Email of the system admin)' => '(email del administrador del sistema)',
      'Organization' => 'Organización',
      'Log' => 'Traza',
      'LogModule' => 'Modulo de trazas',
      '(Used log backend)' => '(Interface de trazas Utilizada)',
      'Logfile' => 'Archivo de trazas',
      '(Logfile just needed for File-LogModule!)' => '(Archivo de trazas necesario para File-LogModule)',
      'Webfrontend' => 'Interface Web',
      'Default Charset' => 'Juego de caracteres por defecto',
      'Use utf-8 it your database supports it!' => 'Usar utf-8 si su base de datos lo soporta!',
      'Default Language' => 'Lenguaje por defecto',
      '(Used default language)' => '(Lenguaje por defecto)',
      'CheckMXRecord' => 'Revisar record MX',
      '(Checks MX recordes of used email addresses by composing an answer. Don\'t use CheckMXRecord if your OTRS machine is behinde a dial-up line $!)' => '(Chequear record MX de direcciones utilizadas al responder. No usarlo si la PC con el Otrs esta detrás de una linea conmutada $!)',
      'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' => 'Para poder utilizar el OTRS debe escribir la siguiente linea de comandos (Terminal/Shell) como root',
      'Restart your webserver' => 'Reinicie su servidor web',
      'After doing so your OTRS is up and running.' => 'Después de hacer esto su OTRS estará activo y ejecutandose',
      'Start page' => 'Página de inicio',
      'Have a lot of fun!' => 'Disfrutelo!',
      'Your OTRS Team' => 'Su equipo OTRS',

      # Template: Login

      # Template: Motd

      # Template: NoPermission
      'No Permission' => 'No tiene autorización',

      # Template: Notify
      'Important' => 'Importante',

      # Template: PrintFooter
      'URL' => '',

      # Template: PrintHeader
      'printed by' => 'impreso por',

      # Template: Redirect

      # Template: SystemStats
      'Format' => 'Formato',

      # Template: Test
      'OTRS Test Page' => 'Página de Prueba de OTRS',
      'Counter' => 'Contador',

      # Template: Warning
      # Misc
      'Create Database' => 'Crear Base de Datos',
      'Ticket Number Generator' => 'Generador de números de Tickets',
      '(Ticket identifier. Some people want toset this to e. g. \'Ticket#\', \'Call#\' or \'MyTicket#\')' => '(Identificador de Ticker. Algunas personas gustan de usar por ejemplo \'Ticket#\', \'Call#\' or \'MyTicket#\')',
      'In this way you can directly edit the keyring configured in Kernel/Config.pm.' => 'De esta forma Ud puede editar directamente las llaves configuradas en Kernel/Config.pm.',
      'Change users <-> roles settings' => '',
      'Close!' => 'Cerrar!',
      'TicketZoom' => 'Detalle de Ticket',
      'Don\'t forget to add a new user to groups!' => 'No olvide incluir el usuario en grupos!',
      'License' => 'Licencia',
      'CreateTicket' => 'CrearTicket',
      'OTRS DB Name' => 'Nombre de la BD OTRS',
      'System Settings' => 'Configuración del sistema',
      'Hours' => 'Horas',
      'Finished' => 'Finalizado',
      'Days' => 'Dias',
      'DB Admin User' => 'Usuario Admin de la BD',
      'DB Type' => 'Tipo de BD',
      'next step' => 'próximo paso',
      'Admin-Email' => 'Correo Administrativo',
      'Create new database' => 'Crear nueva base de datos',
      'Delete old database' => 'Eliminar BD antigua',
      'OTRS DB User' => 'Usuario de BD OTRS',
      'Options ' => 'Opciones',
      'OTRS DB Password' => 'Contrase&ntilde;a para BD del usuario OTRS',
      'DB Admin Password' => 'Contrase&ntilde;a del Admin de la BD',
      'Drop Database' => 'Eliminar Base de Datos',
      'Minutes' => 'Minutos',
      '(Used ticket number format)' => '(Formato de ticket usado)',
      'FAQ History' => 'Historia de FAQ',
    };
    # $$STOP$$
}
# --
1;
