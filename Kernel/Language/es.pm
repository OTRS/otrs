# --
# Kernel/Language/es.pm - provides es language translation
# Copyright (C) 2003-2006 Jorge Becerra <jorge at hab.desoft.cu>
# Copyright (C) 2007 Carlos Oyarzabal <carlos.oyarzabal at grupocash.com.mx>
# --
# $Id: es.pm,v 1.69 2008-05-28 07:27:31 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Language::es;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.69 $) [1];

sub Data {
    my ( $Self, %Param ) = @_;

    # $$START$$
    # Last translation file sync: Fri May 16 14:08:19 2008

    # possible charsets
    $Self->{Charset} = ['iso-8859-1', 'iso-8859-15', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Jear;)
    $Self->{DateFormat}          = '%D.%M.%Y %T';
    $Self->{DateFormatLong}      = '%A %D %B %T %Y';
    $Self->{DateFormatShort}     = '%D.%M.%Y';
    $Self->{DateInputFormat}     = '%D.%M.%Y';
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
        'year' => 'año',
        'years' => 'años',
        'year(s)' => 'año(s)',
        'second(s)' => 'segundo(s)',
        'seconds' => 'segundos',
        'second' => 'segundo',
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
        '* invalid' => '* inválido',
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
        'Unlink' => '',
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
        'Password' => 'Contraseña',
        'Salutation' => 'Saludo',
        'Signature' => 'Firmas',
        'Customer' => 'Cliente',
        'CustomerID' => 'Número de cliente',
        'CustomerIDs' => 'Números de cliente',
        'customer' => 'cliente',
        'agent' => 'agente',
        'system' => 'Sistema',
        'Customer Info' => 'Información del cliente',
        'Customer Company' => 'Cliente Compañía',
        'Company' => 'Compañía',
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
        'Invalid Option!' => 'Opción no valida',
        'Invalid time!' => 'Hora no válida',
        'Invalid date!' => 'Fecha no válida',
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
        'Fulltext Search' => 'Búsqueda de texto completo',
        'Data' => 'Datos',
        'Options' => 'Opciones',
        'Title' => 'Titulo',
        'Item' => 'Articulo',
        'Delete' => 'Borrar',
        'Edit' => 'Editar',
        'View' => 'Ver',
        'Number' => 'Número',
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
        'Passwords doesn\'t match! Please try it again!' => 'Las contraseñas no coinciden. Por favor Reintente!',
        'Password is already in use! Please use an other password!' => 'La contraseña ya se esta utilizando! Por Favor utilice otra!',
        'Password is already used! Please use an other password!' => 'La contraseña ya fue usada! Por favor use otra!',
        'You need to activate %s first to use it!' => 'Necesita activar %s primero para usarlo!',
        'No suggestions' => 'Sin sugerencias',
        'Word' => 'Palabra',
        'Ignore' => 'Ignorar',
        'replace with' => 'reemplazar con',
        'There is no account with that login name.' => 'No existe una cuenta con ese login',
        'Login failed! Your username or password was entered incorrectly.' => 'Identificación incorrecta. Su nombre de usuario o contraseña fue introducido incorrectamente',
        'Please contact your admin' => 'Por favor contace su administrador',
        'Logout successful. Thank you for using OTRS!' => 'Desconexión exitosa. Gracias por utilizar OTRS!',
        'Invalid SessionID!' => 'Sesión no válida',
        'Feature not active!' => 'Característica no activa',
        'Login is needed!' => 'Se requiere login',
        'Password is needed!' => 'Falta la contraseña!',
        'License' => 'Licencia',
        'Take this Customer' => 'Utilizar este cliente',
        'Take this User' => 'Utilizar este usuario',
        'possible' => 'posible',
        'reject' => 'rechazar',
        'reverse' => 'reverso',
        'Facility' => 'Instalación',
        'Timeover' => 'Vencimiento',
        'Pending till' => 'Pendiente hasta',
        'Don\'t work with UserID 1 (System account)! Create new users!' => 'No trabaje con el Identificador 1 (cuenta de sistema)! Cree nuevos usuarios! ',
        'Dispatching by email To: field.' => 'Despachar por correo del campo To:',
        'Dispatching by selected Queue.' => 'Despachar por la cola seleccionada',
        'No entry found!' => 'No se encontró!',
        'Session has timed out. Please log in again.' => 'La sesión ha expirado. Por favor conectese nuevamente.',
        'No Permission!' => 'No tiene Permiso!',
        'To: (%s) replaced with database email!' => 'To: (%s) sustituido con email de la base de datos!',
        'Cc: (%s) added database email!' => 'Cc: (%s) Añadido a la base de correo!',
        '(Click here to add)' => '(Haga click aqui para agregar)',
        'Preview' => 'Vista Previa',
        'Package not correctly deployed! You should reinstall the Package again!' => 'Paquete no instalado correctamente! Ud debe reinstalar el paquete nuevamente!',
        'Added User "%s"' => 'Añadido Usuario "%s"',
        'Contract' => 'Contrato',
        'Online Customer: %s' => 'Cliente Conectado: %s',
        'Online Agent: %s' => 'Agente Conectado: %s',
        'Calendar' => 'Calendario',
        'File' => 'Archivo',
        'Filename' => 'Nombre del archivo',
        'Type' => 'Tipo',
        'Size' => 'Tamaño',
        'Upload' => 'Subir',
        'Directory' => 'Directorio',
        'Signed' => 'Firmado',
        'Sign' => 'Firma',
        'Crypted' => 'Encriptado',
        'Crypt' => 'Encriptar',
        'Office' => 'Oficina',
        'Phone' => 'Telefono',
        'Fax' => '',
        'Mobile' => 'Móvil',
        'Zip' => '',
        'City' => 'Ciudad',
        'Street' => '',
        'Country' => 'Pais',
        'installed' => 'instalado',
        'uninstalled' => 'desinstalado',
        'Security Note: You should activate %s because application is already running!' => 'Nota de seguridad: Usted debe activar %s pues la aplicación ya está corriendo!',
        'Unable to parse Online Repository index document!' => 'Incapáz de interpretar el documento índice del Repositorio en Línea!',
        'No Packages for requested Framework in this Online Repository, but Packages for other Frameworks!' => 'No hay paquetes para el Framework solicitado en este Repositorio en Línea, pero sí hay para otros Frameworks',
        'No Packages or no new Packages in selected Online Repository!' => 'No hay paquetes o no hay paquetes nuevos en el Repositorio en Línea seleccionado',
        'printed at' => 'impreso en',
        'Dear Mr. %s,' => '',
        'Dear Mrs. %s,' => '',
        'Dear %s,' => '',
        'Hello %s,' => '',
        'This account exists.' => '',
        'New account created. Sent Login-Account to %s.' => '',
        'Please press Back and try again.' => '',
        'Sent password token to: %s' => '',
        'Sent new password to: %s' => '',
        'Invalid Token!' => '',

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
        'January' => 'Enero',
        'February' => 'Febrero',
        'March' => 'Marzo',
        'April' => 'Abril',
        'June' => 'Junio',
        'July' => 'Julio',
        'August' => 'Agosto',
        'September' => 'Septiembre',
        'October' => 'Octubre',
        'November' => 'Noviembre',
        'December' => 'Diciembre',

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
        'Admin' => '',
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
        'Admin Notification' => 'Notificación al Administrador',

        # Template: AAAPreferences
        'Preferences updated successfully!' => 'Las preferencia fueron actualizadas!',
        'Mail Management' => 'Gestión de Correos',
        'Frontend' => 'Frontal',
        'Other Options' => 'Otras Opciones',
        'Change Password' => 'Cambiar contraseña',
        'New password' => 'Nueva contraseña',
        'New password again' => 'Repetir Contraseña',
        'Select your QueueView refresh time.' => 'Seleccione su tiempo de actualización de la vista de colas',
        'Select your frontend language.' => 'Seleccione su idioma de trabajo',
        'Select your frontend Charset.' => 'Seleccione su juego de caracteres',
        'Select your frontend Theme.' => 'Seleccione su tema',
        'Select your frontend QueueView.' => 'Seleccione su Vista de cola de trabajo',
        'Spelling Dictionary' => 'Diccionario Ortográfico',
        'Select your default spelling dictionary.' => 'Seleccione su diccionario por defecto',
        'Max. shown Tickets a page in Overview.' => 'Cantidad de Tickets a mostrar en Resumen',
        'Can\'t update password, passwords doesn\'t match! Please try it again!' => 'No se puede actualizar la contraseña, no coinciden! Por favor reintentelo!',
        'Can\'t update password, invalid characters!' => 'No se puede actualizar la contraseña, caracteres no validos!',
        'Can\'t update password, need min. 8 characters!' => 'No se puede actualizar la contraseña, se necesitan al menos 8 caracteres',
        'Can\'t update password, need 2 lower and 2 upper characters!' => 'No se puede actualizar la contraseña, se necesitan al menos 2 en minúscula y 2 en mayúscula!',
        'Can\'t update password, need min. 1 digit!' => 'No se puede actualizar la contraseña, se necesita al menos 1 digito!',
        'Can\'t update password, need min. 2 characters!' => 'No se puede actualizar la contraseña, se necesitan al menos 2 caracteres!',

        # Template: AAAStats
        'Stat' => 'Estadisticas',
        'Please fill out the required fields!' => 'Por favor completo los campos requeridos',
        'Please select a file!' => 'Por favor seleccione un archivo',
        'Please select an object!' => 'Por favor seleccione un objeto',
        'Please select a graph size!' => 'Por favor , seleccione un tamaño gráfico',
        'Please select one element for the X-axis!' => 'Por favor , selecicones un elemento para el eje X',
        'You have to select two or more attributes from the select field!' => 'Debe seleccionar dos o mas atributos del campo seleccionado',
        'Please select only one element or turn off the button \'Fixed\' where the select field is marked!' => 'Por favor, selecciones un solo elemento o desactive el botón \'Fijo\' donde el campo seleccionado está marcado!',
        'If you use a checkbox you have to select some attributes of the select field!' => 'Si usa una casilla de seleccion , debe seleccionar algunos atributos del campo seleccionado',
        'Please insert a value in the selected input field or turn off the \'Fixed\' checkbox!' => 'Por favor inserte un valor en el campo de entrada o o descative la seleccion \'Fija\'',
        'The selected end time is before the start time!' => 'La fecha de finalizar es previa a la de iniciar!',
        'You have to select one or more attributes from the select field!' => 'Debe seleccionar uno mas atributos del campo seleccionado!',
        'The selected Date isn\'t valid!' => 'La fecha seleccionada no es válida',
        'Please select only one or two elements via the checkbox!' => 'Por favor selecciona solo uno o dos elementos usando la casilla de selección!',
        'If you use a time scale element you can only select one element!' => 'Si utiliza la escala de tiempo solo puede seleccionar un elemento!',
        'You have an error in your time selection!' => 'Tiene un error rn la seleccion de tiempo!',
        'Your reporting time interval is too small, please use a larger time scale!' => 'El intervalo de reporte de tiempo es pequeño, por favor use uno mayor!',
        'The selected start time is before the allowed start time!' => 'El periodo de inicio es anterior al permitido!',
        'The selected end time is after the allowed end time!' => 'El periodo de tiempo final es posterior al permitido!',
        'The selected time period is larger than the allowed time period!' => 'El periodo de tiempo es mayor que el permitido!',
        'Common Specification' => 'Especificacion comun',
        'Xaxis' => 'EjeX',
        'Value Series' => 'Serie de Valores',
        'Restrictions' => 'Restricciones',
        'graph-lines' => 'gráfica-de-lineas',
        'graph-bars' => 'gráfica-de-barras ',
        'graph-hbars' => 'gráfica-de-barrashor',
        'graph-points' => 'gráfica-de-puntos',
        'graph-lines-points' => 'gráfica-punteada',
        'graph-area' => 'gráfica-de-área',
        'graph-pie' => 'gráfica-de-pastel',
        'extended' => 'extendido',
        'Agent/Owner' => 'Agente/Dueño',
        'Created by Agent/Owner' => 'Creado por Agente/Dueño',
        'Created Priority' => 'Prioridad de Creación',
        'Created State' => 'Estado al Crearse',
        'Create Time' => 'Fecha de Creación',
        'CustomerUserLogin' => 'Login de Usuario Cliente',
        'Close Time' => 'Fecha de Cierre',

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
        'Priority Update' => '',
        'State' => 'Estado',
        'Compose' => 'Redactar',
        'Pending' => 'Pendiente',
        'Owner' => 'Propietario',
        'Owner Update' => 'Actualizar Propietario',
        'Responsible' => 'Responsable',
        'Responsible Update' => 'Actualizar Responsable',
        'Sender' => 'Emisor',
        'Article' => 'Artículo',
        'Ticket' => '',
        'Createtime' => 'Fecha de creaciñn ',
        'plain' => 'texto',
        'Email' => 'Correo',
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
        'merged' => 'mezclado',
        'closed successful' => 'cerrado exitosamente',
        'closed unsuccessful' => 'cerrado sin éxito',
        'new' => 'nuevo',
        'open' => 'abierto',
        'closed' => 'cerrado',
        'removed' => 'eliminado',
        'pending reminder' => 'recordatorio pendiente',
        'pending auto' => 'pendiente auto',
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
        'No such Ticket Number "%s"! Can\'t link it!' => 'No existe el Ticket Número "%s"! No puede vincularlo!',
        'Don\'t show closed Tickets' => 'No mostrar los tickets cerrados',
        'Show closed Tickets' => 'Mostrar Tickets cerrados',
        'New Article' => 'Nuevo Articulo',
        'Email-Ticket' => 'Ticket-Correo',
        'Create new Email Ticket' => 'Crea nuevo Ticket de Email',
        'Phone-Ticket' => 'Ticket-Telefónico',
        'Search Tickets' => 'Buscar Tickets',
        'Edit Customer Users' => 'Editar Clientes',
        'Edit Customer Company' => '',
        'Bulk-Action' => 'Accion Múltiple',
        'Bulk Actions on Tickets' => 'Acción Múltiple en Tickets',
        'Send Email and create a new Ticket' => 'Enviar un correo y crear un nuevo ticket',
        'Create new Email Ticket and send this out (Outbound)' => 'Crea nuevo Ticket de Email y lo envía (salida)',
        'Create new Phone Ticket (Inbound)' => 'Crea nuevo Ticket Telefónico (entrada)',
        'Overview of all open Tickets' => 'Resumen de todos los tickets abiertos',
        'Locked Tickets' => 'Tickets Bloqueados',
        'Watched Tickets' => 'Ticket Monitoreados',
        'Watched' => 'Monitoreado',
        'Subscribe' => 'Subscribir',
        'Unsubscribe' => 'Desubscribir',
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
        'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' => 'Su correo con número de ticket "<OTRS_TICKET>" se unio a "<OTRS_MERGE_TO_TICKET>".',
        'Ticket %s: first response time is over (%s)!' => 'Ticket %s: Tiempo para primera respuesta ha vencido (%s)!',
        'Ticket %s: first response time will be over in %s!' => 'Ticket %s: Tiempo para primera respuesta está por vencer en %s!',
        'Ticket %s: update time is over (%s)!' => 'Ticket %s: Tiempo para actualización ha vencido (%s)!',
        'Ticket %s: update time will be over in %s!' => 'Ticket %s: Tiempo para actualización está por vencer en %s!',
        'Ticket %s: solution time is over (%s)!' => 'Ticket %s: Tiempo para solución ha vencido (%s)!',
        'Ticket %s: solution time will be over in %s!' => 'Ticket %s: Tiempo para solución está por vencer en %s!',
        'There are more escalated tickets!' => 'No hay mas tickets escalados',
        'New ticket notification' => 'Notificación de nuevos tickets',
        'Send me a notification if there is a new ticket in "My Queues".' => 'Notifíqueme si hay un nuevo ticket en "Mis Colas".',
        'Follow up notification' => 'Seguimiento a notificaciones',
        'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.' => 'Notifíqueme si un cliente enví un seguimiento y yo soy el dueño del ticket.',
        'Ticket lock timeout notification' => 'Notificación de bloqueo de tickets por tiempo',
        'Send me a notification if a ticket is unlocked by the system.' => 'Notifíqueme si un ticket es desbloqueado por el sistema',
        'Move notification' => 'Notificación de movimientos',
        'Send me a notification if a ticket is moved into one of "My Queues".' => 'Notifíqueme si un ticket es colocado en una de "Mis Colas".',
        'Your queue selection of your favourite queues. You also get notified about those queues via email if enabled.' => 'Cola de selección de colas favoritas. Ud tambien puede ser notificado de estas colas via correo si está habilitado',
        'Custom Queue' => 'Cola personal',
        'QueueView refresh time' => 'Tiempo de actualización de la vista de colas',
        'Screen after new ticket' => 'Pantalla posterior a nuevo ticket',
        'Select your screen after creating a new ticket.' => 'Seleccione la pantalla a mostrar despues de crear un ticket',
        'Closed Tickets' => 'Tickets Cerrados',
        'Show closed tickets.' => 'Mostrar Tickets cerrados',
        'Max. shown Tickets a page in QueueView.' => 'Cantidad de Tickets a mostrar en la Vista de Cola',
        'CompanyTickets' => 'TicketsCompañía',
        'MyTickets' => 'MisTickets',
        'New Ticket' => 'Nuevo Ticket',
        'Create new Ticket' => 'Crear un nuevo Ticket',
        'Customer called' => 'Cliente llamado',
        'phone call' => 'Llamada telefónica',
        'Responses' => 'Respuestas',
        'Responses <-> Queue' => 'Respuestas <-> Colas',
        'Auto Responses' => 'Respuestas Automaticas',
        'Auto Responses <-> Queue' => 'Respuestas Automaticas <-> Colas',
        'Attachments <-> Responses' => 'Anexos <-> Respuestas',
        'History::Move' => 'Ticket movido a la cola "%s" (%s) de la cola "%s" (%s).',
        'History::TypeUpdate' => 'Updated Type to %s (ID=%s).',
        'History::ServiceUpdate' => 'Updated Service to %s (ID=%s).',
        'History::SLAUpdate' => 'Updated SLA to %s (ID=%s).',
        'History::NewTicket' => 'Nuevo Ticket [%s] createdo (Q=%s;P=%s;S=%s).',
        'History::FollowUp' => 'Seguimiento para [%s]. %s',
        'History::SendAutoReject' => 'Rechazo automático enviado a "%s".',
        'History::SendAutoReply' => 'Respuesta automática enviada a "%s".',
        'History::SendAutoFollowUp' => 'Seguimiento automático enviado a "%s".',
        'History::Forward' => 'Reenviado a "%s".',
        'History::Bounce' => 'Reenviado a "%s".',
        'History::SendAnswer' => 'Correo enviado a "%s".',
        'History::SendAgentNotification' => '"%s"-notificación enviada a "%s".',
        'History::SendCustomerNotification' => 'Notificación; enviada a "%s".',
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
        'History::Subscribe' => 'Added subscription for user "%s".',
        'History::Unsubscribe' => 'Removed subscription for user "%s".',

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
        'To get the first 20 character of the subject.' => 'Para obtener los primeros 20 caracteres del asunto',
        'To get the first 5 lines of the email.' => 'Para obtener las primeras 5 líneas del correo',
        'To get the realname of the sender (if given).' => 'Para obtener el nombre real del remitente (si existe)',
        'To get the article attribute (e. g. (<OTRS_CUSTOMER_From>, <OTRS_CUSTOMER_To>, <OTRS_CUSTOMER_Cc>, <OTRS_CUSTOMER_Subject> and <OTRS_CUSTOMER_Body>).' => 'Para obtener el atributo del artículo (es decir, (<OTRS_CUSTOMER_From>, <OTRS_CUSTOMER_To>, <OTRS_CUSTOMER_Cc>, <OTRS_CUSTOMER_Subject> y <OTRS_CUSTOMER_Body>).',
        'Options of the current customer user data (e. g. <OTRS_CUSTOMER_DATA_UserFirstname>).' => 'Opciones de datos del actual usuario cliente (es decir, <OTRS_CUSTOMER_DATA_UserFirstname>).',
        'Ticket owner options (e. g. <OTRS_OWNER_UserFirstname>).' => 'Opciones del propietario del ticket (es decir, <OTRS_OWNER_UserFirstname>).',
        'Ticket responsible options (e. g. <OTRS_RESPONSIBLE_UserFirstname>).' => 'Opciones del responsable del ticket (es decir, <OTRS_RESPONSIBLE_UserFirstname>).',
        'Options of the current user who requested this action (e. g. <OTRS_CURRENT_UserFirstname>).' => 'Opciones del actual usuario quien requirió esta acción (es decir, <OTRS_CURRENT_UserFirstname>).',
        'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>).' => 'Opciones de datos del ticket (es decir, <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>).',
        'Config options (e. g. <OTRS_CONFIG_HttpType>).' => 'Opciones de configuración (es decir, <OTRS_CONFIG_HttpType>).',

        # Template: AdminCustomerCompanyForm
        'Customer Company Management' => 'Administración de Cliente Compañía',
        'Search for' => 'Buscar por',
        'Add Customer Company' => 'Agregar Cliente Compañía',
        'Add a new Customer Company.' => 'Agregar un nuevo Cliente Compañía',
        'List' => 'Lista',
        'This values are required.' => 'Estos valores son obligatorios',
        'This values are read only.' => 'Estos valores son solo-lectura',

        # Template: AdminCustomerUserForm
        'Customer User Management' => 'Gestión de clientes',
        'Add Customer User' => 'Agregar Cliente Usuario',
        'Source' => 'Origen',
        'Create' => 'Crear',
        'Customer user will be needed to have a customer history and to login via customer panel.' => 'El cliente necesita tener una historia y conectarse via panel de clientes',

        # Template: AdminCustomerUserGroupChangeForm
        'Customer Users <-> Groups Management' => 'Clientes <-> Gestión de Grupos',
        'Change %s settings' => 'Cambiar %s especificaciones',
        'Select the user:group permissions.' => 'Seleccionar los permisos de usuario:grupo',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the user).' => 'Si no se selecciona algo, no habrán permisos en este grupo (Los tickets no estarán disponibles para este cliente).',
        'Permission' => 'Permisos',
        'ro' => '',
        'Read only access to the ticket in this group/queue.' => 'Acceso de solo lectura a los tickets en este grupo/cola.',
        'rw' => '',
        'Full read and write access to the tickets in this group/queue.' => 'Acceso completo de lectura y escritura a los tickets en este grupo/cola.',

        # Template: AdminCustomerUserGroupForm

        # Template: AdminCustomerUserService
        'Customer Users <-> Services Management' => '',
        'CustomerUser' => 'Usuario Cliente',
        'Service' => '',
        'Edit default services.' => '',
        'Search Result' => 'Buscar resultados',
        'Allocate services to CustomerUser' => '',
        'Active' => 'Activo',
        'Allocate CustomerUser to service' => '',

        # Template: AdminEmail
        'Message sent to' => 'Mensaje enviado a',
        'Recipents' => 'Destinatarios',
        'Body' => 'Cuerpo',
        'Send' => 'Enviar',

        # Template: AdminGenericAgent
        'GenericAgent' => 'AgenteGenérico',
        'Job-List' => 'Lista de Tareas',
        'Last run' => 'Última corrida',
        'Run Now!' => 'Ejecutar ahora',
        'x' => '',
        'Save Job as?' => 'Guardar Tarea como?',
        'Is Job Valid?' => 'Es la tarea Válida?',
        'Is Job Valid' => 'Es una tarea válida',
        'Schedule' => 'Horario',
        'Fulltext-Search in Article (e. g. "Mar*in" or "Baue*")' => 'Búsqueda de texto en Articulo (ej. "Mar*in" or "Baue*")',
        '(e. g. 10*5155 or 105658*)' => '(ej: 10*5155 o 105658*)',
        '(e. g. 234321)' => '(ej: 234321)',
        'Customer User Login' => 'Identificador del cliente',
        '(e. g. U5150)' => '(ej: U5150)',
        'SLA' => '',
        'Agent' => 'Agente',
        'Ticket Lock' => 'Ticket Bloqueado',
        'TicketFreeFields' => 'CamposLibresDeTicket',
        'Create Times' => 'Tiempos de Creación',
        'No create time settings.' => 'No hay valores para tiempo de creación',
        'Ticket created' => 'Ticket creado',
        'Ticket created between' => 'Ticket creado entre',
        'Close Times' => '',
        'No close time settings.' => '',
        'Ticket closed' => '',
        'Ticket closed between' => '',
        'Pending Times' => 'Tiempos de Pendiente',
        'No pending time settings.' => 'No hay valores para tiempo de pendiente',
        'Ticket pending time reached' => 'Tiempo de Pendiente del Ticket alcanzado',
        'Ticket pending time reached between' => 'Tiempo de Pendiente del Ticket alcanzado entre',
        'New Service' => '',
        'New SLA' => '',
        'New Priority' => 'Nueva prioridad',
        'New Queue' => 'Nueva Cola',
        'New State' => 'Nuevo estado',
        'New Agent' => 'Nuevo Agente',
        'New Owner' => 'Nuevo Propietario',
        'New Customer' => 'Nuevo Cliente',
        'New Ticket Lock' => 'Nuevo bloqueo de ticket!',
        'New Type' => '',
        'New Title' => '',
        'New Type' => '',
        'New TicketFreeFields' => 'Nuevo CampoLibredeTicket',
        'Add Note' => 'Adicionar Nota',
        'CMD' => '',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' => 'Se ejecutará el comando. ARG[0] el número del ticket. ARG[0] el id del ticket.',
        'Delete tickets' => 'Eliminar tickets',
        'Warning! This tickets will be removed from the database! This tickets are lost!' => 'Aviso! Estos tickets serán eliminados de la base de datos! Los mismos se perderán!',
        'Send Notification' => 'Enviar Notificación',
        'Param 1' => 'Parámetro 1',
        'Param 2' => 'Parámetro 2',
        'Param 3' => 'Parámetro 3',
        'Param 4' => 'Parámetro 4',
        'Param 5' => 'Parámetro 5',
        'Param 6' => 'Parámetro 6',
        'Send no notifications' => 'No enviar notificaciones',
        'Yes means, send no agent and customer notifications on changes.' => 'Si, significa no enviar notificación a los agentes y clientes al realizarse cambios.',
        'No means, send agent and customer notifications on changes.' => 'No ,significa enviar a los agentes y clientes notificaciones al realizar cambios.',
        'Save' => 'Guardar',
        '%s Tickets affected! Do you really want to use this job?' => '%s Tickets Modificados! Realmente desea utilizar esta tarea?',
        '"}' => '',

        # Template: AdminGroupForm
        'Group Management' => 'Administración de grupos',
        'Add Group' => 'Agregar Grupo',
        'Add a new Group.' => 'Agregar nuevo Grupo',
        'The admin group is to get in the admin area and the stats group to get stats area.' => 'El grupo admin es para usar el área de administración y el grupo stats para usar el área estadisticas.',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).' => 'Crear nuevos grupos para manipular los permisos de acceso por distintos grupos de agente (ejemplo: departamento de compra, departamento de soporte, departamento de ventas,...).',
        'It\'s useful for ASP solutions.' => 'Esto es útil para soluciones ASP.',

        # Template: AdminLog
        'System Log' => 'Trazas del Sistema',
        'Time' => 'Tiempo',

        # Template: AdminMailAccount
        'Mail Account Management' => '',
        'Host' => '',
        'Trusted' => 'Confiable',
        'Dispatching' => 'Remitiendo',
        'All incoming emails with one account will be dispatched in the selected queue!' => 'Todos los correos de entrada serán enviados a la cola seleccionada',
        'If your account is trusted, the already existing X-OTRS header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' => 'Si su cuenta es confiable, los headers ya existentes X-OTRS en la llegada se utilizarán para la prioridad! El filtro Postmaster se usa de todas formas.',

        # Template: AdminNavigationBar
        'Users' => 'Usuarios',
        'Groups' => 'Grupos',
        'Misc' => 'Miscelaneas',

        # Template: AdminNotificationForm
        'Notification Management' => 'Gestión de Notificaciones',
        'Notification' => 'Notificación',
        'Notifications are sent to an agent or a customer.' => 'Las notificación se le envian a un agente o cliente',

        # Template: AdminPackageManager
        'Package Manager' => 'Gestor de paquete',
        'Uninstall' => 'Desinstalar',
        'Version' => 'Versión',
        'Do you really want to uninstall this package?' => 'Seguro que desea desinstalar este paquete?',
        'Reinstall' => 'Reinstalar',
        'Do you really want to reinstall this package (all manual changes get lost)?' => 'Realmente desea reinstalar este paquete (todos los cambios manuales se perderán)?',
        'Continue' => 'Continúa',
        'Install' => 'Instalar',
        'Package' => 'Paquete',
        'Online Repository' => 'Repositorio Online',
        'Vendor' => 'Vendedor',
        'Upgrade' => 'Actualizar',
        'Local Repository' => 'Repositorio Local',
        'Status' => 'Estado',
        'Overview' => 'Resumen',
        'Download' => 'Descargar',
        'Rebuild' => 'Reconstruir',
        'ChangeLog' => '',
        'Date' => 'Fecha',
        'Filelist' => '',
        'Download file from package!' => 'Descargar archivo del paquete!',
        'Required' => 'Requerido',
        'PrimaryKey' => 'LlavePrimaria',
        'AutoIncrement' => 'AutoIncrementar',
        'SQL' => '',
        'Diff' => '',

        # Template: AdminPerformanceLog
        'Performance Log' => 'Trazas de desempeño',
        'This feature is enabled!' => 'Esta característica está habilitada',
        'Just use this feature if you want to log each request.' => 'Usa esta característica solo si usted desea registrar cada petición.',
        'Of couse this feature will take some system performance it self!' => 'De acuerdo a esta característica se tomará cierto rendimiento del sistema por si misma.',
        'Disable it here!' => 'Deshabilita aquí',
        'This feature is disabled!' => 'Esta característica está deshabilitada',
        'Enable it here!' => 'Habilita aquí',
        'Logfile too large!' => 'Archivo de trazas muy grande',
        'Logfile too large, you need to reset it!' => 'Archivo de trazas muy grande, necesita reinicializarlo!',
        'Range' => 'Rango',
        'Interface' => '',
        'Requests' => 'Solicitudes',
        'Min Response' => 'Respuesta Minima',
        'Max Response' => 'Respuesta Máxima',
        'Average Response' => 'Respuesta Promedio',
        'Period' => '',
        'Min' => '',
        'Max' => '',
        'Average' => '',

        # Template: AdminPGPForm
        'PGP Management' => 'Administración PGP',
        'Result' => 'Resultado',
        'Identifier' => 'Identificador',
        'Bit' => '',
        'Key' => 'Llave',
        'Fingerprint' => '',
        'Expires' => 'Expira',
        'In this way you can directly edit the keyring configured in SysConfig.' => 'De esta forma puede editar directamente el anillo de Llaves configurado en Sysconfig',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => 'Gestión del filtro maestro',
        'Filtername' => '',
        'Match' => 'Coincidir',
        'Header' => 'Encabezado',
        'Value' => 'Valor',
        'Set' => 'Ajustar',
        'Do dispatch or filter incoming emails based on email X-Headers! RegExp is also possible.' => 'Clasificar o filtrar correos entrantes basado en el encabezamiento X-Headers del correo! Puede utilizar expresiones regulares.',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' => '',
        'If you use RegExp, you also can use the matched value in () as [***] in \'Set\'.' => 'Si utiliza expresión regular, puede tambien usar el valor encontrado en () as [***] en \'Set\'.',

        # Template: AdminQueueAutoResponseForm
        'Queue <-> Auto Responses Management' => 'Cola <-> Gestión de respuestas automáticas',

        # Template: AdminQueueForm
        'Queue Management' => 'Gestión de Colas',
        'Sub-Queue of' => 'Subcola de',
        'Unlock timeout' => 'Tiempo para desbloqueo automático',
        '0 = no unlock' => '0 = sin bloqueo',
        'Only business hours are counted.' => '',
        'Escalation - First Response Time' => 'Escalado - Tiempo para Primera Respuesta',
        '0 = no escalation' => '0 = sin escalado',
        'Only business hours are counted.' => '',
        'Notify by' => '',
        'Escalation - Update Time' => 'Escalado - Tiempo para Actualización',
        'Notify by' => '',
        'Escalation - Solution Time' => 'Escalado - Tiempo para Solución',
        'Follow up Option' => 'Opción de seguimiento',
        'Ticket lock after a follow up' => 'Bloquear un ticket después del seguimiento',
        'Systemaddress' => 'Direcciones de correo del sistema',
        'Customer Move Notify' => 'Notificar al Cliente al Mover',
        'Customer State Notify' => 'Notificación de estado al Cliente',
        'Customer Owner Notify' => 'Notificar al Dueño al Mover',
        'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.' => 'Si un agente bloquea un ticket y el/ella no envíe una respuesta en este tiempo, el ticket será desbloqueado automáticamente',
        'Escalation time' => 'Tiempo de escalado',
        'If a ticket will not be answered in this time, just only this ticket will be shown.' => 'Si un ticket no ha sido respondido es este tiempo, solo este ticket se mostrará',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.' => 'Si el tickes esta cerrado y el cliente envía un seguimiento al mismo este será bloqueado para el antiguo propietario',
        'Will be the sender address of this queue for email answers.' => 'Será la dirección del emisor en esta cola para respuestas por correo.',
        'The salutation for email answers.' => 'Saludo para las respuestas por correo.',
        'The signature for email answers.' => 'Firma para respuestas por correo.',
        'OTRS sends an notification email to the customer if the ticket is moved.' => 'OTRS envía una notificación por correo si el ticket se mueve',
        'OTRS sends an notification email to the customer if the ticket state has changed.' => 'OTRS envía una notificación por correo al cliente si el estado del ticket cambia',
        'OTRS sends an notification email to the customer if the ticket owner has changed.' => 'OTRS envía una notificación por correo al cliente si el dueño; del ticket cambia',

        # Template: AdminQueueResponsesChangeForm
        'Responses <-> Queue Management' => 'Respuestas <-> Gestión de Colas',

        # Template: AdminQueueResponsesForm
        'Answer' => 'Responder',

        # Template: AdminResponseAttachmentChangeForm
        'Responses <-> Attachments Management' => 'Respuestas <-> Gestión de Anexos',

        # Template: AdminResponseAttachmentForm

        # Template: AdminResponseForm
        'Response Management' => 'Gestión de Respuestas',
        'A response is default text to write faster answer (with default text) to customers.' => 'Una respuesta es el texto por defecto para escribir respuestas más rapido (con el texto por defecto) a los clientes.',
        'Don\'t forget to add a new response a queue!' => 'No olvide incluir una nueva respuesta en la cola!',
        'The current ticket state is' => 'El estado actual del ticket es',
        'Your email address is new' => 'Su dirección de correo es nueva',

        # Template: AdminRoleForm
        'Role Management' => 'Gestión de Roles',
        'Add Role' => '',
        'Add a new Role.' => '',
        'Create a role and put groups in it. Then add the role to the users.' => 'Crea un rol y coloca grupos en el mismo. Luego adicione el rol a los usuarios.',
        'It\'s useful for a lot of users and groups.' => 'Es útil para gestionar muchos usuarios y grupos.',

        # Template: AdminRoleGroupChangeForm
        'Roles <-> Groups Management' => 'Roles <-> Gestión de Grupos',
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
        'Roles <-> Users Management' => 'Roles <-> Gestión de Usuarios',
        'Select the role:user relations.' => 'Seleccionar las relaciones Rol-Cliente',

        # Template: AdminRoleUserForm

        # Template: AdminSalutationForm
        'Salutation Management' => 'Gestión de saludos',
        'Add Salutation' => '',
        'Add a new Salutation.' => '',

        # Template: AdminSelectBoxForm
        'SQL Box' => '',
        'Limit' => 'Límite',
        'Go' => '',
        'Select Box Result' => 'Seleccione tipo de resultado',

        # Template: AdminService
        'Service Management' => '',
        'Add Service' => '',
        'Add a new Service.' => '',
        'Sub-Service of' => '',

        # Template: AdminSession
        'Session Management' => 'Gestión de sesiones',
        'Sessions' => 'Sesiones',
        'Uniq' => '',
        'Kill all sessions' => '',
        'Session' => 'Sesión',
        'Content' => 'Contenido',
        'kill session' => 'Finalizar una sesión',

        # Template: AdminSignatureForm
        'Signature Management' => 'Gestión de firmas',
        'Add Signature' => '',
        'Add a new Signature.' => '',

        # Template: AdminSLA
        'SLA Management' => '',
        'Add SLA' => '',
        'Add a new SLA.' => '',

        # Template: AdminSMIMEForm
        'S/MIME Management' => 'Gestion S/MIME',
        'Add Certificate' => 'Adicionar un certificado',
        'Add Private Key' => 'Adicionar una Llave privada',
        'Secret' => 'Secreto',
        'Hash' => '',
        'In this way you can directly edit the certification and private keys in file system.' => 'De esta forma Ud puede editar directamente la certificacion y llaves privadas el el sistema de archivos.',

        # Template: AdminStateForm
        'State Management' => '',
        'Add State' => '',
        'Add a new State.' => '',
        'State Type' => 'Tipo de estado',
        'Take care that you also updated the default states in you Kernel/Config.pm!' => 'Recuerde tambien actualizar los estados en su archivo Kernel/Config.pm! ',
        'See also' => 'Vea tambien',

        # Template: AdminSysConfig
        'SysConfig' => '',
        'Group selection' => 'Selección de Grupo',
        'Show' => 'Mostrar',
        'Download Settings' => 'Descargar Configuración',
        'Download all system config changes.' => 'Descargar todos los cambios de configuración',
        'Load Settings' => 'Cargar Configuración',
        'Subgroup' => 'Subgrupo',
        'Elements' => 'Elementos',

        # Template: AdminSysConfigEdit
        'Config Options' => 'Opciones de Configuración',
        'Default' => '',
        'New' => 'Nuevo',
        'New Group' => 'Nuevo grupo',
        'Group Ro' => 'Grupo Ro',
        'New Group Ro' => 'Nuevo Grupo Ro',
        'NavBarName' => '',
        'NavBar' => '',
        'Image' => 'Imagen',
        'Prio' => '',
        'Block' => '',
        'AccessKey' => '',

        # Template: AdminSystemAddressForm
        'System Email Addresses Management' => 'Gestión de direcciones de correo del sistema',
        'Add System Address' => '',
        'Add a new System Address.' => '',
        'Realname' => 'Nombre',
        'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!' => 'Todos los mensajes entrantes con este correo(To:) serán enviados a la cola seleccionada!',

        # Template: AdminTypeForm
        'Type Management' => '',
        'Add Type' => '',
        'Add a new Type.' => '',

        # Template: AdminUserForm
        'User Management' => 'Administración de usuarios',
        'Add User' => '',
        'Add a new Agent.' => '',
        'Login as' => 'Conectarse como',
        'Firstname' => 'Nombre',
        'Lastname' => 'Apellido',
        'User will be needed to handle tickets.' => 'Se necesita un usuario para manipular los tickets.',
        'Don\'t forget to add a new user to groups and/or roles!' => 'No olvide adicionar los nuevos usuario a los grupos y/o roles',

        # Template: AdminUserGroupChangeForm
        'Users <-> Groups Management' => 'Usuarios <-> Gestión de Grupos',

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
        'Page' => 'Página',
        'Detail' => 'Detalle',

        # Template: AgentLookup
        'Lookup' => '',

        # Template: AgentNavigationBar

        # Template: AgentPreferencesForm

        # Template: AgentSpelling
        'Spell Checker' => 'Chequeo Ortográfico',
        'spelling error(s)' => 'errores gramaticales',
        'or' => 'o',
        'Apply these changes' => 'Aplicar los cambios',

        # Template: AgentStatsDelete
        'Do you really want to delete this Object?' => 'Seguro que desea eliminar este objeto?',

        # Template: AgentStatsEditRestrictions
        'Select the restrictions to characterise the stat' => 'Seleccione las restricciones para caracterizar la estadistica',
        'Fixed' => '',
        'Please select only one element or turn off the button \'Fixed\'.' => 'Por favor seleccione un elemento de desactive el botón \'Fijo\.',
        'Absolut Period' => 'Periodo Absoluto',
        'Between' => 'Entre',
        'Relative Period' => 'Periodo Relativo',
        'The last' => 'El último',
        'Finish' => 'Finalizar',
        'Here you can make restrictions to your stat.' => 'Aqui puede declarar restricciones a sus estadisticas.',
        'If you remove the hook in the "Fixed" checkbox, the agent generating the stat can change the attributes of the corresponding element.' => 'Si elimina el gancho en la casilla "Fija", el agente generando la estadistica puede cambiar los atributos del elemento correspondiente',

        # Template: AgentStatsEditSpecification
        'Insert of the common specifications' => 'Inserte las especificaciones comunes',
        'Permissions' => 'Permisos',
        'Format' => 'Formato',
        'Graphsize' => '',
        'Sum rows' => 'Sumar filas',
        'Sum columns' => 'Sumar columnas',
        'Cache' => '',
        'Required Field' => 'Campos obligatorios',
        'Selection needed' => 'Selección obligatoria',
        'Explanation' => 'Explicación',
        'In this form you can select the basic specifications.' => 'En esta pantalla puede seleccionar las especificaciones básicas',
        'Attribute' => 'Atributo',
        'Title of the stat.' => 'Titulo de la estadistica',
        'Here you can insert a description of the stat.' => 'Aqui puede insertar una descripción de la estadistica.',
        'Dynamic-Object' => 'Objeto-Dinamico',
        'Here you can select the dynamic object you want to use.' => 'Aqui puede seleccionar el elemento dinamico que desea utilizar',
        '(Note: It depends on your installation how many dynamic objects you can use)' => '(Nota: Depende de su instalación cuantos objetos dinámicos puede utilizar',
        'Static-File' => 'Archivo-Estático',
        'For very complex stats it is possible to include a hardcoded file.' => 'Para una estadistica muy compleja es posible incluir un archivo prefijado',
        'If a new hardcoded file is available this attribute will be shown and you can select one.' => 'Si un nuevo archivo prefijado está disponible este atributo se le monstrará y puede seleccionar uno',
        'Permission settings. You can select one or more groups to make the configurated stat visible for different agents.' => 'Configuración de permisos. Puede seleccionar uno o mas grupos para hacer visible las estadisticas configuradas a agentes distintos',
        'Multiple selection of the output format.' => 'Selección múltiple del formato de salida',
        'If you use a graph as output format you have to select at least one graph size.' => 'Si utiliza un gráfico como formato de salida debe seleccionar al menos un tamaño de gráfico.',
        'If you need the sum of every row select yes' => 'Si necesita la suma de cada fila seleccione Si',
        'If you need the sum of every column select yes.' => 'Si necesita las suma de cada columna seleccione Si',
        'Most of the stats can be cached. This will speed up the presentation of this stat.' => 'La mayoria de las estadisticas pueden ser conservadas en cache. Esto acelera la presentación de esta estadistica.',
        '(Note: Useful for big databases and low performance server)' => '(Nota: Util para bases de datos grandes y servidores de bajo rendimiento)',
        'With an invalid stat it isn\'t feasible to generate a stat.' => 'Con una estadistica inválida, no es posible generar estadisticas.',
        'This is useful if you want that no one can get the result of the stat or the stat isn\'t ready configurated.' => 'Esto es util si desea que nadie pueda obtener el resultado de una estadística o la misma aun no está configurada',

        # Template: AgentStatsEditValueSeries
        'Select the elements for the value series' => 'Seleccione los elementos para los valores de la serie',
        'Scale' => 'Escala',
        'minimal' => 'mínimo',
        'Please remember, that the scale for value series has to be larger than the scale for the X-axis (e.g. X-Axis => Month, ValueSeries => Year).' => 'Recuerde, la escala para los valores de la serie necesita ser mayor que la escala para el eje-X (ej: eje-X => Mes, ValorSeries => Año).',
        'Here you can the value series. You have the possibility to select one or two elements. Then you can select the attributes of elements. Each attribute will be shown as single value series. If you don\'t select any attribute all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' => 'Aqui puede el valor de la serie. Tiene la posibilidad de selecciona uno o mas elementos, Luego puede selecicona los atributos de los elementos. Cada atributo será mostrado como un elemento de la serie. Si no selecciona ningun atributo, todos los atributos del elemento serán utilizados si genera una estadistica.',

        # Template: AgentStatsEditXaxis
        'Select the element, which will be used at the X-axis' => 'Seleccione el elemento, que será utilizado en el eje-X',
        'maximal period' => 'periodo máximo',
        'minimal scale' => 'escala mínima',
        'Here you can define the x-axis. You can select one element via the radio button. Then you you have to select two or more attributes of the element. If you make no selection all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' => 'Aqui puede definir el eje-x, Puede seleccionar un elemento usando la casilla de selecciona. Luego debe seleccionar dos o mas atributos del elementos. Si Ud no selecciona ninguno, todos los atributos del elemento se ustilizarán para generar una estadistica. Tambien como un nuevo atributo es añadido desde la ultima configuración',

        # Template: AgentStatsImport
        'Import' => 'Importar',
        'File is not a Stats config' => 'El archivo no es una configuración de estadisticas',
        'No File selected' => 'No hay archivo seleccionado',

        # Template: AgentStatsOverview
        'Object' => 'Objeto',

        # Template: AgentStatsPrint
        'Print' => 'Imprimir',
        'No Element selected.' => 'No hay elemento seleccionado',

        # Template: AgentStatsView
        'Export Config' => 'Exportar Configuración',
        'Information about the Stat' => 'Informaciones sobre la estadistica',
        'Exchange Axis' => 'Intercambiar Ejes',
        'Configurable params of static stat' => 'Parámetro configurable de estadistica estatica',
        'No element selected.' => 'No hay elemento seleccionado',
        'maximal period from' => '',
        'to' => 'a',
        'Start' => 'Iniciar',
        'With the input and select fields you can configurate the stat at your needs. Which elements of a stat you can edit depends on your stats administrator who configurated the stat.' => 'Con la entrada y campos seleciconados puede configurar las estadisticas a sus necesidades. Que elementos de estadisticas puede editar depende del como haya sido configurado por el administrador',

        # Template: AgentTicketBounce
        'Bounce ticket' => 'Ticket rebotado',
        'Ticket locked!' => 'Ticket bloqueado!',
        'Ticket unlock!' => 'Ticket desbloqueado!',
        'Bounce to' => 'Rebotar a',
        'Next ticket state' => 'Nuevo estado del ticket',
        'Inform sender' => 'Informar al emisor',
        'Send mail!' => 'Enviar correo!',

        # Template: AgentTicketBulk
        'Ticket Bulk Action' => 'Acción múltiple con Tickets',
        'Spell Check' => 'Chequeo Ortográfico',
        'Note type' => 'Tipo de nota',
        'Unlock Tickets' => 'Desbloquear Tickets',

        # Template: AgentTicketClose
        'Close ticket' => 'Cerrar el ticket',
        'Previous Owner' => 'Propietario Anterior',
        'Inform Agent' => 'Notificar Agente',
        'Optional' => 'Opcional',
        'Inform involved Agents' => 'Notificar Agentes involucrados',
        'Attach' => 'Anexo',
        'Next state' => 'Siguiente estado',
        'Pending date' => 'Fecha pendiente',
        'Time units' => 'Unidades de tiempo',

        # Template: AgentTicketCompose
        'Compose answer for ticket' => 'Redacte una respuesta al ticket',
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
        'Refresh' => 'Refrescar',
        'Clear To' => 'Copia Oculta a',

        # Template: AgentTicketEscalationView
        'Ticket Escalation View' => '',
        'Escalation' => '',
        'Today' => '',
        'Tomorrow' => '',
        'Next Week' => '',
        'up' => 'arriba',
        'down' => 'abajo',
        'Escalation' => '',
        'Locked' => 'Bloqueado',

        # Template: AgentTicketForward
        'Article type' => 'Tipo de artículo',

        # Template: AgentTicketFreeText
        'Change free text of ticket' => 'Cambiar el texto libre del ticket',

        # Template: AgentTicketHistory
        'History of' => 'Historia de',

        # Template: AgentTicketLocked

        # Template: AgentTicketMailbox
        'Mailbox' => 'Buzón',
        'Tickets' => '',
        'of' => 'de',
        'Filter' => '',
        'New messages' => 'Nuevo mensaje',
        'Reminder' => 'Recordatorio',
        'Sort by' => 'Ordenado por',
        'Order' => 'Orden',

        # Template: AgentTicketMerge
        'Ticket Merge' => 'Unir Ticket',
        'Merge to' => 'Unir a',

        # Template: AgentTicketMove
        'Move Ticket' => 'Mover Ticket',

        # Template: AgentTicketNote
        'Add note to ticket' => 'Adicionar nota al ticket',

        # Template: AgentTicketOwner
        'Change owner of ticket' => 'Cambiar el propietario del ticket',

        # Template: AgentTicketPending
        'Set Pending' => 'Indicar pendiente',

        # Template: AgentTicketPhone
        'Phone call' => 'Llamada telefónica',
        'Clear From' => 'Borrar de',

        # Template: AgentTicketPhoneOutbound

        # Template: AgentTicketPlain
        'Plain' => 'Texto plano',

        # Template: AgentTicketPrint
        'Ticket-Info' => 'Informacion-Ticket',
        'Accounted time' => 'Tiempo contabilizado',
        'First Response Time' => '',
        'Update Time' => '',
        'Solution Time' => '',
        'Linked-Object' => 'Objeta-vincular',
        'Parent-Object' => 'Objeto-Padre',
        'Child-Object' => 'Objeto-Hijo',
        'by' => 'por',

        # Template: AgentTicketPriority
        'Change priority of ticket' => 'Cambiar la prioridad al ticket',

        # Template: AgentTicketQueue
        'Tickets shown' => 'Tickets mostrados',
        'Tickets available' => 'Tickets disponibles',
        'All tickets' => 'Todos los tickets',
        'Queues' => 'Colas',
        'Ticket escalation!' => 'Escalado de ticket',

        # Template: AgentTicketQueueTicketView
        'Service Time' => '',
        'Your own Ticket' => 'Sus tickets',
        'Compose Follow up' => 'Redactar seguimiento',
        'Compose Answer' => 'Responder',
        'Contact customer' => 'Contactar el cliente',
        'Change queue' => 'Cambiar cola',

        # Template: AgentTicketQueueTicketViewLite

        # Template: AgentTicketResponsible
        'Change responsible of ticket' => 'Cambiar responsable del ticket',

        # Template: AgentTicketSearch
        'Ticket Search' => 'Buscar ticket',
        'Profile' => 'Perfil',
        'Search-Template' => 'Buscar-Modelo',
        'TicketFreeText' => '',
        'Created in Queue' => 'Creado en Cola',
        'Close Times' => '',
        'No close time settings.' => '',
        'Ticket closed' => '',
        'Ticket closed between' => '',
        'Result Form' => 'Modelo de Resultados',
        'Save Search-Profile as Template?' => 'Guardar perfil de búsqueda como patrón?',
        'Yes, save it with name' => 'Si, guardarlo con nombre',

        # Template: AgentTicketSearchOpenSearchDescription

        # Template: AgentTicketSearchResult
        'Change search options' => 'Cambiar opciones de búsqueda',

        # Template: AgentTicketSearchResultPrint

        # Template: AgentTicketSearchResultShort

        # Template: AgentTicketStatusView
        'Ticket Status View' => 'Ver Estado de Ticket',
        'Open Tickets' => 'Tickets Abiertos',

        # Template: AgentTicketZoom
        'Expand View' => '',
        'Collapse View' => '',

        # Template: AgentWindowTab

        # Template: AJAX

        # Template: Copyright

        # Template: css

        # Template: customer-css

        # Template: CustomerAccept

        # Template: CustomerCalendarSmallIcon

        # Template: CustomerError
        'Traceback' => '',

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

        # Template: CustomerTicketMessage

        # Template: CustomerTicketPrint

        # Template: CustomerTicketSearch
        'Times' => 'Veces',
        'No time settings.' => 'Sin especificación de fecha',

        # Template: CustomerTicketSearchResultCSV

        # Template: CustomerTicketSearchResultPrint

        # Template: CustomerTicketSearchResultShort

        # Template: CustomerTicketZoom

        # Template: CustomerWarning

        # Template: Error
        'Click here to report a bug!' => 'Haga click aqui para reportar un error!',

        # Template: Footer
        'Top of Page' => 'Inicio de página',

        # Template: FooterSmall

        # Template: Header

        # Template: HeaderSmall

        # Template: Installer
        'Web-Installer' => 'Instalador Web',
        'Welcome to %s' => 'Bienvenido a %s',
        'Accept license' => '',
        'Don\'t accept license' => '',
        'Admin-User' => 'Usuario-Admin',
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty. For security reasons we do recommend setting a root password. For more information please refer to your database documentation.' => '',
        'Admin-Password' => 'Contraseña-Administrador',
        'Database-User' => '',
        'default \'hot\'' => 'por defecto \'hot\'',
        'DB connect host' => '',
        'Database' => 'Base de Datos',
        'Default Charset' => 'Juego de caracteres por defecto',
        'utf8' => '',
        'false' => 'falso',
        'SystemID' => 'ID de sistema',
        '(The identify of the system. Each ticket number and each http session id starts with this number)' => '(La identidad del sistema. Cada número de ticket y cada id de sesión http comienza con este número)',
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
        'Use utf-8 it your database supports it!' => 'Usar utf-8 si su base de datos lo permite!',
        'Default Language' => 'Lenguaje por defecto',
        '(Used default language)' => '(Lenguaje por defecto)',
        'CheckMXRecord' => 'Revisar record MX',
        '(Checks MX recordes of used email addresses by composing an answer. Don\'t use CheckMXRecord if your OTRS machine is behinde a dial-up line $!)' => '(Chequear record MX de direcciones utilizadas al responder. No usarlo si la PC con el Otrs esta detrás de una linea conmutada $!)',
        'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' => 'Para poder utilizar el OTRS debe escribir la siguiente linea de comandos (Terminal/Shell) como root',
        'Restart your webserver' => 'Reinicie su servidor web',
        'After doing so your OTRS is up and running.' => 'Después de hacer esto su OTRS estará activo y ejecutándose',
        'Start page' => 'Página de inicio',
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

        # Template: Test
        'OTRS Test Page' => 'Página de Prueba de OTRS',
        'Counter' => 'Contador',

        # Template: Warning
        # Misc
        'Edit Article' => '',
        'Create Database' => 'Crear Base de Datos',
        'Ticket Number Generator' => 'Generador de números de Tickets',
        '(Ticket identifier. Some people want toset this to e. g. \'Ticket#\', \'Call#\' or \'MyTicket#\')' => '(Identificador de Ticker. Algunas personas gustan de usar por ejemplo \'Ticket#\', \'Call#\' or \'MyTicket#\')',
        'Create new Phone Ticket' => 'Crear un nuevo Ticket Telefónico',
        'In this way you can directly edit the keyring configured in Kernel/Config.pm.' => 'De esta forma Ud puede editar directamente las llaves configuradas en Kernel/Config.pm.',
        'Symptom' => 'Sintoma',
        'U' => 'A',
        'A message should have a To: recipient!' => 'El mensaje debe tenes el destinatario To: !',
        'Site' => 'Sitio',
        'Customer history search (e. g. "ID342425").' => 'Historia de búsquedas del cliente (ejemplo: "ID342425"',
        'for agent firstname' => 'nombre del agente',
        'Close!' => 'Cerrar!',
        'The message being composed has been closed.  Exiting.' => 'El mensaje que se estaba redactando ha sido cerrado. Saliendo.!',
        'A web calendar' => 'Calendario Web',
        'to get the realname of the sender (if given)' => 'para obtener el nombre del emisor (si lo proporcionó)',
        'OTRS DB Name' => 'Nombre de la BD OTRS',
        'Notification (Customer)' => '',
        'Select Source (for add)' => 'Seleccionar Fuente (para adicionar)',
        'Options of the ticket data (e. g. &lt;OTRS_TICKET_Number&gt;, &lt;OTRS_TICKET_ID&gt;, &lt;OTRS_TICKET_Queue&gt;, &lt;OTRS_TICKET_State&gt;)' => '',
        'Days' => 'Dias',
        'Queue ID' => 'Id de la Cola',
        'Home' => 'Inicio',
        'Config options (e. g. <OTRS_CONFIG_HttpType>)' => 'Opciones de configuración (ej: <OTRS_CONFIG_HttpType>)',
        'System History' => 'Historia del Sistema',
        'customer realname' => 'Nombre del cliente',
        'Pending messages' => 'Mensajes pendientes',
        'Modules' => 'Módulos',
        'for agent login' => 'login del agente',
        'Keyword' => 'palabra clave',
        'Close type' => 'Tipo de cierre',
        'DB Admin User' => 'Usuario Admin de la BD',
        'for agent user id' => 'id del agente',
        'sort upward' => 'ordenar ascendente',
        'Problem' => 'Problema',
        'next step' => 'próximo paso',
        'Customer history search' => 'Historia de búsquedas del cliente',
        'Admin-Email' => 'Correo Administrativo',
        'Create new database' => 'Crear nueva base de datos',
        'A message must be spell checked!' => 'El mensaje debe ser chequeado ortograficamente!',
        'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further information.' => 'Su correo con el ticket número "<OTRS_TICKET>"  fue rebotado a "<OTRS_BOUNCE_TO>". Contacte dicha dirección para mas información',
        'ArticleID' => 'Identificador de articulo',
        'A message should have a body!' => 'Los mensajes deben tener contenido',
        'All Agents' => 'Todos los Agentes',
        'Keywords' => 'palabras clave',
        'No * possible!' => 'No * posible!',
        'Options ' => 'Opciones',
        'Options of the current user who requested this action (e. g. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)' => '',
        'Message for new Owner' => 'Mensaje para el nuevo propietario',
        'to get the first 5 lines of the email' => 'para obtener las primeras 5 líneas del correo',
        'OTRS DB Password' => 'Contraseña para BD del usuario OTRS',
        'Last update' => 'Ultima Actualización',
        'to get the first 20 character of the subject' => 'para obtener los primeros 20 caracteres del asunto ',
        'Select the customeruser:service relations.' => '',
        'DB Admin Password' => 'Contraseña del Admin de la BD',
        'Advisory' => 'Advertencia',
        'Drop Database' => 'Eliminar Base de Datos',
        'FileManager' => 'Administrador de Archivos',
        'Options of the current customer user data (e. g. <OTRS_CUSTOMER_DATA_UserFirstname>)' => 'Opciones del usuario activo',
        'Pending type' => 'Tipo pendiente',
        'Comment (internal)' => 'Comentario (interno)',
        'Ticket owner options (e. g. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)' => '',
        'This window must be called from compose window' => 'Esta ventana debe ser llamada desde la ventana de redacción',
        'Minutes' => 'Minutos',
        'You need min. one selected Ticket!' => 'Necesita al menos seleccionar un Ticket!',
        'Options of the ticket data (e. g. <OTRS_TICKET_Number>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' => 'Opciones para la información de ticket (ej: <OTRS_TICKET_Number>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)',
        '(Used ticket number format)' => '(Formato de ticket usado)',
        'Fulltext' => 'Texto Completo',
        'Incident' => 'Incidente',
        'All Agent variables.' => 'Todas las variables de Agente',
        ' (work units)' => ' (unidades de trabajo)',
        'All Customer variables like defined in config option CustomerUser.' => 'Todas las variables de cliente como aparecen declaradas en la opcion de configuracion del cliente',
        'accept license' => 'aceptar licencia',
        'for agent lastname' => 'apellido del agente',
        'Options of the current user who requested this action (e. g. <OTRS_CURRENT_UserFirstname>)' => 'Opciones del usuario activo que solicita esta acción (ej. <OTRS_CURRENT_UserFirstname>)',
        'Reminder messages' => 'Mensajes recordatorios',
        'Change users <-> roles settings' => 'Cambiar Usuarios <-> Configuración de Roles',
        'A message should have a subject!' => 'Los mensajes deben tener asunto!',
        'TicketZoom' => 'Detalle de Ticket',
        'Don\'t forget to add a new user to groups!' => 'No olvide incluir el usuario en grupos!',
        'You need a email address (e. g. customer@example.com) in To:!' => 'Necesita una dirección de correo (ejemplo: cliente@ejemplo.com) en To:!',
        'CreateTicket' => 'CrearTicket',
        'You need to account time!' => 'Necesita contabilizar el tiempo!',
        'System Settings' => 'Configuración del sistema',
        'WebWatcher' => '',
        'Hours' => 'Horas',
        'Finished' => 'Finalizado',
        'Account Type' => '',
        'Split' => 'Dividir',
        'D' => '',
        'System Status' => '',
        'All messages' => 'Todos los mensajes',
        'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' => 'Opciones para la información el ticket ',
        'Artefact' => 'Artefacto',
        'A article should have a title!' => 'Los articulos deben tener título',
        'Config options (e. g. &lt;OTRS_CONFIG_HttpType&gt;)' => '',
        'Event' => '',
        'don\'t accept license' => 'no acepto la licencia',
        'A web mail client' => 'Un cliente de correo Web',
        'WebMail' => '',
        'Ticket owner options (e. g. <OTRS_OWNER_UserFirstname>)' => 'Opciones de propietario del ticket (ej. <OTRS_OWNER_UserFirstname>)',
        'Name is required!' => 'Debe especificar nombre!',
        'DB Type' => 'Tipo de BD',
        'kill all sessions' => 'Finalizar todas las sesiones',
        'to get the from line of the email' => 'para obtener la linea from del correo',
        'Solution' => 'Solución',
        'Package not correctly deployed, you need to deploy it again!' => 'El paquete no ha sido correctamente instalado, necesita instalarlo nuevamente!',
        'QueueView' => 'Ver la cola',
        'Select Box' => 'Ventana de selección',
        'Welcome to OTRS' => 'Bienvenido al OTRS',
        'modified' => 'modificado',
        'Escalation in' => 'Escalado en',
        'Delete old database' => 'Eliminar BD antigua',
        'sort downward' => 'ordenar descendente',
        'You need to use a ticket number!' => 'Necesita user un número de ticket!',
        'A web file manager' => 'Administrador web de archivos',
        'Have a lot of fun!' => 'Disfrutelo!',
        'send' => 'enviar',
        'Note Text' => 'Nota!',
        'POP3 Account Management' => 'Gestión de cuenta POP3',
        'Options of the current customer user data (e. g. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)' => '',
        'System State Management' => 'Gestión de estados del Sistema',
        'OTRS DB User' => 'Usuario de BD OTRS',
        'PhoneView' => 'Vista telefónica',
        'maximal period form' => 'mayor periodo del formulario',
        'Verion' => '',
        'TicketID' => 'Identificador de Ticket',
        'Modified' => 'Modificado',
        'Ticket selected for bulk action!' => 'Ticket seleccionado para acción múltiple!',
    };
    # $$STOP$$
    return;
}

1;
