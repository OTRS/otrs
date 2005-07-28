# --
# Kernel/Language/es.pm - provides es language translation
# Copyright (C) 2003-2004 Jorge Becerra <jorge at icc-cuba.com>
# --
# $Id: es.pm,v 1.30 2005-07-28 20:32:31 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
package Kernel::Language::es;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.30 $';
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
      'hour(s)' => '',
      'minute' => 'minuto',
      'minutes' => 'minutos',
      'minute(s)' => '',
      'month' => '',
      'months' => '',
      'month(s)' => 'mes(es)',
      'week' => '',
      'week(s)' => 'semana(s)',
      'year' => '',
      'years' => '',
      'year(s)' => 'año(s)',
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
      'valid' => '',
      'invalid' => 'inválido',
      'invalid-temporarily' => '',
      ' 2 minutes' => ' 2 minutos',
      ' 5 minutes' => ' 5 minutos',
      ' 7 minutes' => ' 7 minutos',
      '10 minutes' => '10 minutos',
      '15 minutes' => '15 minutos',
      'Mr.' => '',
      'Mrs.' => '',
      'Next' => 'Siguiente',
      'Back' => 'Regresar',
      'Next...' => 'Siguiente...',
      '...Back' => '..Regresar',
      '-none-' => '',
      'none' => 'nada',
      'none!' => 'nada!',
      'none - answered' => 'nada  - respondido',
      'please do not edit!' => 'Por favor no lo edite!',
      'AddLink' => 'Adicionar enlace',
      'Link' => 'Vinculo',
      'Linked' => '',
      'Link (Normal)' => '',
      'Link (Parent)' => '',
      'Link (Child)' => '',
      'Normal' => '',
      'Parent' => '',
      'Child' => '',
      'Hit' => '',
      'Hits' => '',
      'Text' => 'Texto',
      'Lite' => 'Chica',
      'User' => 'Usuario',
      'Username' => 'Nombre de Usuario',
      'Language' => 'Idioma',
      'Languages' => 'Idiomas',
      'Password' => 'Contraseña',
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
      'Submit' => '',
      'change!' => 'cambiar!',
      'Change' => 'Cambiar',
      'change' => 'cambiar',
      'click here' => 'haga click aquí',
      'Comment' => 'Comentario',
      'Valid' => 'Válido',
      'Invalid Option!' => '',
      'Invalid time!' => '',
      'Invalid date!' => '',
      'Name' => 'Nombre',
      'Group' => 'Grupo',
      'Description' => 'Descripción',
      'description' => 'descripción',
      'Theme' => 'Tema',
      'Created' => 'Creado',
      'Created by' => '',
      'Changed' => '',
      'Changed by' => '',
      'Search' => 'Buscar',
      'and' => 'y',
      'between' => '',
      'Fulltext Search' => '',
      'Data' => '',
      'Options' => 'Opciones',
      'Title' => 'Tñtulo',
      'Item' => '',
      'Delete' => 'Borrar',
      'Edit' => 'Editar',
      'View' => 'Ver',
      'Number' => '',
      'System' => 'Sistema',
      'Contact' => 'Contacto',
      'Contacts' => '',
      'Export' => '',
      'Up' => '',
      'Down' => '',
      'Add' => 'Adicionar',
      'Category' => 'Categoria',
      'Viewer' => '',
      'New message' => 'Nuevo mensaje',
      'New message!' => 'Nuevo mensaje!',
      'Please answer this ticket(s) to get back to the normal queue view!' => 'Por favor responda el ticket para regresar a la vista normal de la cola.',
      'You got new message!' => 'Ud tiene un nuevo mensaje',
      'You have %s new message(s)!' => 'Ud tiene %s nuevos mensaje(s)!',
      'You have %s reminder ticket(s)!' => 'Ud tiene %s tickets recordatorios',
      'The recommended charset for your language is %s!' => 'EL juego de caracteres recomendado para su idioma es %s!',
      'Passwords dosn\'t match! Please try it again!' => 'Las contraseñas no coinciden. Por favor Reintente!',
      'Password is already in use! Please use an other password!' => '',
      'Password is already used! Please use an other password!' => '',
      'You need to activate %s first to use it!' => '',
      'No suggestions' => 'Sin sugerencias',
      'Word' => 'Palabra',
      'Ignore' => 'Ignorar',
      'replace with' => 'reemplazar con',
      'Welcome to OTRS' => 'Bienvenido a OTRS',
      'There is no account with that login name.' => 'No existe una cuenta con ese login',
      'Login failed! Your username or password was entered incorrectly.' => 'Identificación incorrecta. Su nombre de usuario o contraseña fue introducido incorrectamente',
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
      'Cc: (%s) added database email!' => '',
      '(Click here to add)' => '(Haga click aqui para agregar)',
      'Preview' => 'Vista Previa',
      'Added User "%s"' => 'Añadido Usuario "%s"',
      'Contract' => 'Contrato',
      'Online Customer: %s' => 'Cliente Conectado: %s',
      'Online Agent: %s' => 'Agente Conectado: %s',
      'Calendar' => 'Calendario',
      'File' => 'Archivo',
      'Filename' => 'Nombre del archivo',
      'Type' => 'Tipo',
      'Size' => 'Tamaño',
      'Upload' => '',
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
      'Ticket-Area' => '',
      'Logout' => 'Desconectarse',
      'Agent Preferences' => 'Preferencias de Agente',
      'Preferences' => 'Preferencias',
      'Agent Mailbox' => '',
      'Stats' => 'Estadisticas',
      'Stats-Area' => '',
      'FAQ-Area' => 'Area-FAQ',
      'FAQ' => '',
      'FAQ-Search' => '',
      'FAQ-Article' => '',
      'New Article' => 'Nuevo Articulo',
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
      'Preferences updated successfully!' => 'Las preferencia fueron actualizadas!',
      'Mail Management' => 'Gestión de Correos',
      'Frontend' => 'Frontal',
      'Other Options' => 'Otras Opciones',
      'Change Password' => '',
      'New password' => '',
      'New password again' => '',
      'Select your QueueView refresh time.' => 'Seleccione su tiempo de actualización de la vista de colas',
      'Select your frontend language.' => 'Seleccione su idioma de trabajo',
      'Select your frontend Charset.' => 'Seleccione su juego de caracteres',
      'Select your frontend Theme.' => 'Seleccione su tema',
      'Select your frontend QueueView.' => 'Seleccione su Vista de cola de trabajo',
      'Spelling Dictionary' => 'Diccionario Ortográfico',
      'Select your default spelling dictionary.' => 'Seleccione su diccionario por defecto',
      'Max. shown Tickets a page in Overview.' => 'Cantidad de Tickets a mostrar en Resumen',
      'Can\'t update password, passwords dosn\'t match! Please try it again!' => '',
      'Can\'t update password, invalid characters!' => '',
      'Can\'t update password, need min. 8 characters!' => '',
      'Can\'t update password, need 2 lower and 2 upper characters!' => '',
      'Can\'t update password, need min. 1 digit!' => '',
      'Can\'t update password, need min. 2 characters!' => '',
      'Password is needed!' => '',

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
      'Compose' => 'Componer',
      'Pending' => 'Pendiente',
      'Owner' => 'Propietario',
      'Owner Update' => '',
      'Sender' => 'Emisor',
      'Article' => 'Artículo',
      'Ticket' => '',
      'Createtime' => 'Fecha de creaciñn ',
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
      'Free Fields' => '',
      'Merge' => '',
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
      'Ticket Object' => '',
      'No such Ticket Number "%s"! Can\'t link it!' => 'No existe el Ticket Numero "%s"! No puede elnazarlo!',
      'Don\'t show closed Tickets' => 'No mostrar los tickets cerrados',
      'Show closed Tickets' => 'Mostrar Tickets cerrados',
      'Email-Ticket' => '',
      'Create new Email Ticket' => '',
      'Phone-Ticket' => '',
      'Create new Phone Ticket' => 'Crear un nuevo Ticket Telefonico',
      'Search Tickets' => '',
      'Edit Customer Users' => '',
      'Bulk-Action' => '',
      'Bulk Actions on Tickets' => '',
      'Send Email and create a new Ticket' => '',
      'Overview of all open Tickets' => 'Resumen de todos los tickets abiertos',
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
      'New ticket notification' => 'Notificación de nuevos tickets',
      'Send me a notification if there is a new ticket in "My Queues".' => 'Notifíqueme si hay un nuevo ticket en "Mis Colas".',
      'Follow up notification' => 'Seguimiento a notificaciones',
      'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.' => 'Notifíqueme si un cliente enví un seguimiento y yo soy el dueño del ticket.',
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
      'Responses <-> Queue' => '',
      'Auto Responses' => '',
      'Auto Responses <-> Queue' => '',
      'Attachments <-> Responses' => '',
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
      'Attachment Management' => 'Gestón de Anexos',

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
      'Customer Users <-> Groups Management' => '',
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
      'Recipents' => 'Receptores',
      'Body' => 'Cuerpo',
      'send' => 'enviar',

      # Template: AdminGenericAgent
      'GenericAgent' => '',
      'Job-List' => 'Lista de Tareas',
      'Last run' => 'Última corrida',
      'Run Now!' => '',
      'x' => '',
      'Save Job as?' => 'Guardar Tarea como?',
      'Is Job Valid?' => '',
      'Is Job Valid' => '',
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
      'Users' => '',
      'Groups' => 'Grupos',
      'Misc' => 'Miscelaneas',

      # Template: AdminNotificationForm
      'Notification Management' => 'Gestión de Notificaciones',
      'Notification' => '',
      'Notifications are sent to an agent or a customer.' => 'Las notificación se le envian a un agente o cliente',
      'Config options (e. g. &lt;OTRS_CONFIG_HttpType&gt;)' => 'Opciones de configuración (ej: &lt;OTRS_CONFIG_HttpType&gt;)',
      'Ticket owner options (e. g. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)' => 'Opciones de propietario del ticket (ej. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)',
      'Options of the current user who requested this action (e. g. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)' => 'Opciones del usuario activo que solicita esta acción (ej. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)',
      'Options of the current customer user data (e. g. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)' => 'Opciones del usuario activo',

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
      'Status' => 'Estado',
      'Overview' => 'Resumen',
      'Download' => 'Descargar',
      'Rebuild' => '',
      'Reinstall' => '',

      # Template: AdminPGPForm
      'PGP Management' => '',
      'Identifier' => 'Identificador',
      'Bit' => '',
      'Key' => 'Llave',
      'Fingerprint' => '',
      'Expires' => 'Expira',
      'In this way you can directly edit the keyring configured in SysConfig.' => '',

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
      'Queue <-> Auto Responses Management' => '',

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
      'Customer Owner Notify' => 'Notificar al Dueño al Mover',
      'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.' => 'Si un agente bloquea un ticket y el/ella no enví una respuesta en este tiempo, el ticket sera desbloqueado automáticamente',
      'If a ticket will not be answered in thos time, just only this ticket will be shown.' => 'Si un ticket no ha sido respondido es este tiempo, solo este ticket se mostrará',
      'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.' => 'Si el tickes esta cerrado y el cliente enví un seguimiento al mismo este será bloqueado para el antiguo propietario',
      'Will be the sender address of this queue for email answers.' => 'Será la dirección del emisor en esta cola para respuestas por correo.',
      'The salutation for email answers.' => 'Saludo para las respuestas por correo.',
      'The signature for email answers.' => 'Firma para respuestas por correo.',
      'OTRS sends an notification email to the customer if the ticket is moved.' => 'OTRS enví una notificación por correo si el ticket se mueve',
      'OTRS sends an notification email to the customer if the ticket state has changed.' => 'OTRS enví una notificación por correo al cliente si el estado del ticket cambia',
      'OTRS sends an notification email to the customer if the ticket owner has changed.' => 'OTRS enví una notificación por correo al cliente si el due&ntildeo; del ticket cambia',

      # Template: AdminQueueResponsesChangeForm
      'Responses <-> Queue Management' => '',

      # Template: AdminQueueResponsesForm
      'Answer' => 'Responder',

      # Template: AdminResponseAttachmentChangeForm
      'Responses <-> Attachments Management' => '',

      # Template: AdminResponseAttachmentForm

      # Template: AdminResponseForm
      'Response Management' => 'Gestión de respuestas',
      'A response is default text to write faster answer (with default text) to customers.' => 'Una respuesta es el texto por defecto para escribir respuestas más rapido (con el texto por defecto) a los clientes.',
      'Don\'t forget to add a new response a queue!' => 'No olvide incluir una nueva respuesta en la cola!',
      'Next state' => 'Siguiente estado',
      'All Customer variables like defined in config option CustomerUser.' => '',
      'The current ticket state is' => 'El estado actual del ticket es',
      'Your email address is new' => 'Su dirección de correo es nueva',

      # Template: AdminRoleForm
      'Role Management' => 'Gestión de Roles',
      'Create a role and put groups in it. Then add the role to the users.' => 'Crea un rol y coloca grupos en el mismo. Luego adiciona el rol a los usuarios.',
      'It\'s useful for a lot of users and groups.' => 'Es útil para gestionar muchos usuarios y grupos.',

      # Template: AdminRoleGroupChangeForm
      'Roles <-> Groups Management' => '',
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
      'Roles <-> Users Management' => '',
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
      'SMIME Management' => '',
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
      'New' => 'Nuevo',
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
      'System Email Addresses Management' => 'Gestión de direcciones de correo del sistema',
      'Email' => 'Correo',
      'Realname' => 'Nombre real',
      'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!' => 'Todos los mensajes entrantes con este correo(To:) serán enviados a la cola seleccionada!',

      # Template: AdminUserForm
      'User Management' => 'Administración de usuarios',
      'Firstname' => 'Nombre',
      'Lastname' => 'Apellido',
      'User will be needed to handle tickets.' => 'Se necesita un usuario para manipular los tickets.',
      'Don\'t forget to add a new user to groups and/or roles!' => '',

      # Template: AdminUserGroupChangeForm
      'Users <-> Groups Management' => '',

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
      'Link Object' => '',
      'Select' => 'Seleccionar',
      'Results' => 'Resultados',
      'Total hits' => 'Total de coincidencias',
      'Site' => 'Sitio',
      'Detail' => '',

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
      'Unlock Tickets' => '',

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
      'You need to use a ticket number!' => '',
      'Ticket Merge' => '',
      'Merge to' => '',
      'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' => '',

      # Template: AgentTicketMove
      'Queue ID' => 'Id de la Cola',
      'Move Ticket' => 'Mover Ticket',
      'Previous Owner' => 'Propietario Anterior',

      # Template: AgentTicketNote
      'Add note to ticket' => 'Adicionar nota al ticket',
      'Inform Agent' => '',
      'Optional' => '',
      'Inform involved Agents' => '',

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
      'Clear From' => 'Borrar From',

      # Template: AgentTicketPlain
      'Plain' => 'Texto plano',
      'TicketID' => 'Identificador de Ticket',
      'ArticleID' => 'Identificador de articulo',

      # Template: AgentTicketPrint
      'Ticket-Info' => '',
      'Accounted time' => 'Tiempo contabilizado',
      'Escalation in' => 'Escalado en',
      'Linked-Object' => '',
      'Parent-Object' => '',
      'Child-Object' => '',
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
      'Created in Queue' => '',
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
      'Ticket Status View' => '',
      'Open Tickets' => '',

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
      'modified' => '',
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
      'Lost your password?' => 'Perdió su contraseña',
      'Request new password' => 'Solicitar una nueva contraseña',
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
      'A article should have a title!' => 'Los articulos deben tener tñtulo',
      'New FAQ Article' => '',
      'Do you really want to delete this Object?' => '',
      'System History' => '',

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
      'Admin-Password' => '',
      'your MySQL DB should have a root password! Default is empty!' => 'Su BD MySQL debe tener una contrase&ntiulde; de root! Por defecto es va&itilde;a!',
      'Database-User' => '',
      'default \'hot\'' => 'por defecto \'hot\'',
      'DB connect host' => '',
      'Database' => '',
      'Create' => '',
      'false' => '',
      'SystemID' => 'ID de sistema',
      '(The identify of the system. Each ticket number and each http session id starts with this number)' => '(La identidad del sistema. Cada número de ticket y cada id de sesi&oacuten http comienza con este número)',
      'System FQDN' => 'FQDN del sistema',
      '(Full qualified domain name of your system)' => '(Nombre completo del dominio de su sistema)',
      'AdminEmail' => 'Correo del administrador.',
      '(Email of the system admin)' => '(email del administrador del sistema)',
      'Organization' => 'Organización',
      'Log' => '',
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
      'Important' => '',

      # Template: PrintFooter
      'URL' => '',

      # Template: PrintHeader
      'printed by' => 'impreso por',

      # Template: Redirect

      # Template: SystemStats
      'Format' => '',

      # Template: Test
      'OTRS Test Page' => 'Página de Prueba de OTRS',
      'Counter' => '',

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
      'Options ' => '',
      'OTRS DB Password' => 'Contraseña para BD del usuario OTRS',
      'DB Admin Password' => 'Contraseña del Admin de la BD',
      'Drop Database' => 'Eliminar Base de Datos',
      'Minutes' => 'Minutos',
      '(Used ticket number format)' => '(Formato de ticket usado)',
      'FAQ History' => 'Historia de FAQ',
    };
    # $$STOP$$
}
# --
1;
