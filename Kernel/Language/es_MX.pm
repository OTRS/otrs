# --
# Kernel/Language/es_MX.pm - provides Spanish language translation for Mexico
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: es_MX.pm,v 1.21 2010-10-13 13:24:33 mg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::es_MX;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.21 $) [1];

sub Data {
    my $Self = shift;

    # $$START$$
    # Last translation file sync: Sat Jun 27 14:02:34 2009

    # possible charsets
    $Self->{Charset} = ['iso-8859-1', 'iso-8859-15', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Year;)
    $Self->{DateFormat}          = '%D/%M/%Y - %T';
    $Self->{DateFormatLong}      = '%A, %D %B %Y - %T';
    $Self->{DateFormatShort}     = '%D/%M/%Y';
    $Self->{DateInputFormat}     = '%D/%M/%Y';
    $Self->{DateInputFormatLong} = '%D/%M/%Y - %T';
    $Self->{Separator}           = ';';

    $Self->{Translation} = {
        # Template: AAABase
        'Yes' => 'Sí',
        'No' => 'No',
        'yes' => 'sí',
        'no' => 'no',
        'Off' => 'Apagado',
        'off' => 'apagado',
        'On' => 'Encendido',
        'on' => 'encendido',
        'top' => 'inicio',
        'end' => 'fin',
        'Done' => 'Hecho',
        'Cancel' => 'Cancelar',
        'Reset' => 'Resetear',
        'last' => 'último',
        'before' => 'antes',
        'day' => 'día',
        'days' => 'días',
        'day(s)' => 'día(s)',
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
        'Error' => 'Error',
        'Bug Report' => 'Informe de errores',
        'Attention' => 'Atención',
        'Warning' => 'Advertencia',
        'Module' => 'Módulo',
        'Modulefile' => 'Archivo de módulo',
        'Subfunction' => 'Subfunción',
        'Line' => 'Línea',
        'Setting' => 'Configuración',
        'Settings' => 'Configuraciones',
        'Example' => 'Ejemplo',
        'Examples' => 'Ejemplos',
        'valid' => 'válido',
        'invalid' => 'inválido',
        '* invalid' => '* inválido',
        'invalid-temporarily' => 'temporalmente-inválido',
        ' 2 minutes' => ' 2 minutos',
        ' 5 minutes' => ' 5 minutos',
        ' 7 minutes' => ' 7 minutos',
        '10 minutes' => '10 minutos',
        '15 minutes' => '15 minutos',
        'Mr.' => 'Sr.',
        'Mrs.' => 'Sra.',
        'Next' => 'Siguiente',
        'Back' => 'Atrás',
        'Next...' => 'Siguiente...',
        '...Back' => '...Regresar',
        '-none-' => '-ninguno-',
        'none' => 'ninguno',
        'none!' => 'ninguno',
        'none - answered' => 'ninguno - respondido',
        'please do not edit!' => 'Por favor, no lo modifique',
        'AddLink' => 'Añadir enlace',
        'Link' => 'Enlazar',
        'Unlink' => 'Desenlazar',
        'Linked' => 'Enlazado',
        'Link (Normal)' => 'Enlazar (Normal)',
        'Link (Parent)' => 'Enlazar (Padre)',
        'Link (Child)' => 'Enlazar (Hijo)',
        'Normal' => 'Normal',
        'Parent' => 'Padre',
        'Child' => 'Hijo',
        'Hit' => 'Acierto',
        'Hits' => 'Aciertos',
        'Text' => 'Texto',
        'Lite' => 'Reducida',
        'User' => 'Usuario',
        'Username' => 'Nombre de Usuario',
        'Language' => 'Idioma',
        'Languages' => 'Idiomas',
        'Password' => 'Contraseña',
        'Salutation' => 'Saludo',
        'Signature' => 'Firma',
        'Customer' => 'Cliente',
        'CustomerID' => 'Identificador del cliente',
        'CustomerIDs' => 'Identificadores del cliente',
        'customer' => 'cliente',
        'agent' => 'agente',
        'system' => 'sistema',
        'Customer Info' => 'Información del Cliente',
        'Customer Company' => 'Compañía del Cliente',
        'Company' => 'Compañía',
        'go!' => 'ir',
        'go' => 'ir',
        'All' => 'Todo',
        'all' => 'todo',
        'Sorry' => 'Disculpe',
        'update!' => 'actualizar',
        'update' => 'actualizar',
        'Update' => 'Actualizar',
        'Updated!' => 'Actualizado',
        'submit!' => 'enviar',
        'submit' => 'enviar',
        'Submit' => 'Enviar',
        'change!' => 'modificar',
        'Change' => 'Modificar',
        'change' => 'modificar',
        'click here' => 'haga click aquí',
        'Comment' => 'Comentario',
        'Valid' => 'Válido',
        'Invalid Option!' => 'Opción Inválida',
        'Invalid time!' => 'Hora inválida.',
        'Invalid date!' => 'Fecha inválida.',
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
        'Title' => 'Título',
        'Item' => 'Artículo',
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
        'Add' => 'Añadir',
        'Added!' => 'Agregado.',
        'Category' => 'Categoría',
        'Viewer' => 'Visor',
        'Expand' => 'Expandir',
        'Small' => 'Pequeño',
        'Medium' => 'Mediano',
        'Large' => 'Grande',
        'New message' => 'Mensaje nuevo',
        'New message!' => '¡Mensaje nuevo!',
        'Please answer this ticket(s) to get back to the normal queue view!' => 'Por favor, responda a este(os) ticket(s) para regresar a la vista normal de la fila.',
        'You got new message!' => 'Tiene un mensaje nuevo.',
        'You have %s new message(s)!' => 'Tiene %s mensaje(s) nuevo(s)',
        'You have %s reminder ticket(s)!' => 'Tiene %s recordatorio(s) de ticket',
        'The recommended charset for your language is %s!' => 'El juego de caracteres recomendado para su idioma es %s.',
        'Passwords doesn\'t match! Please try it again!' => 'Las contraseñas no coinciden. Por favor, intente nuevamente.',
        'Password is already in use! Please use an other password!' => 'La contraseña ya se está utilizando. Por favor, utilice otra.',
        'Password is already used! Please use an other password!' => 'La contraseña ya fue usada. Por favor, utilice otra.',
        'You need to activate %s first to use it!' => 'Necesita activar %s primero para utilizarlo.',
        'No suggestions' => 'Sin sugerencias.',
        'Word' => 'Palabra',
        'Ignore' => 'Ignorar',
        'replace with' => 'reemplazar con',
        'There is no account with that login name.' => 'No existe una cuenta para ese nombre de usuario.',
        'Login failed! Your username or password was entered incorrectly.' => 'Inicio de sesión fallido. El nombre de usuario o contraseña fue introducido incorrectamente.',
        'Please contact your admin' => 'Por favor, contacte a su administrador.',
        'Logout successful. Thank you for using OTRS!' => 'Sesión terminada satisfactoriamente. ¡Gracias por utilizar OTRS!',
        'Invalid SessionID!' => 'Identificador de sesión inválido.',
        'Feature not active!' => 'Funcionalidad inactiva.',
        'Notifications (Event)' => 'Notificaciones (Evento)',
        'Login is needed!' => 'Inicio de sesión requerido.',
        'Password is needed!' => 'Contraseña requerida.',
        'License' => 'Licencia',
        'Take this Customer' => 'Utilizar este cliente',
        'Take this User' => 'Utilizar este usuario',
        'possible' => 'posible',
        'reject' => 'rechazar',
        'reverse' => 'revertir',
        'Facility' => 'Instalación',
        'Pending till' => 'Pendiente hasta',
        'Don\'t work with UserID 1 (System account)! Create new users!' => 'No trabaje con el usuario 1 (cuenta del sistema). Cree usuarios nuevos.',
        'Dispatching by email To: field.' => 'Despachar por el campo Para: del correo electrónico.',
        'Dispatching by selected Queue.' => 'Despachar por la fila seleccionada.',
        'No entry found!' => 'No se encontró entrada alguna.',
        'Session has timed out. Please log in again.' => 'La sesión ha caducado. Por favor, conéctese nuevamente.',
        'No Permission!' => 'No tiene Permiso.',
        'To: (%s) replaced with database email' => 'Para: (%s) sustituido con el correo electrónico de la base de datos',
        'Cc: (%s) added database email' => 'Cc: (%s) añadido a la base de datos de correo electrónico',
        '(Click here to add)' => '(Haga click aquí para añadir)',
        'Preview' => 'Vista Previa',
        'Package not correctly deployed! You should reinstall the Package again!' => 'Paquete instalado incorrectamente. Debe reinstalar el paquete.',
        'Added User "%s"' => 'Usuario "%s añadido"',
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
        'Phone' => 'Teléfono',
        'Fax' => 'Fax',
        'Mobile' => 'Móvil',
        'Zip' => 'CP',
        'City' => 'Ciudad',
        'Street' => 'Calle',
        'Country' => 'País',
        'Location' => 'Localidad',
        'installed' => 'instalado',
        'uninstalled' => 'desinstalado',
        'Security Note: You should activate %s because application is already running!' => 'Nota de seguridad: Debe activar %s porque la aplicación ya está ejecutándose',
        'Unable to parse Online Repository index document!' => 'Incapaz de interpretar el documento índice del Repositorio en Línea',
        'No Packages for requested Framework in this Online Repository, but Packages for other Frameworks!' => 'No hay paquetes para el Framework solicitado en este Repositorio en Línea, pero hay paquetes para otros Frameworks',
        'No Packages or no new Packages in selected Online Repository!' => 'No hay paquetes o no hay paquetes nuevos en el Repositorio en Línea seleccionado',
        'printed at' => 'impreso en',
        'Dear Mr. %s,' => 'Apreciable Sr. %s,',
        'Dear Mrs. %s,' => 'Apreciable Sra. %s,',
        'Dear %s,' => 'Apreciable %s,',
        'Hello %s,' => 'Hola %s,',
        'This account exists.' => 'Esta cuenta existe.',
        'New account created. Sent Login-Account to %s.' => 'Cuenta nueva creada. Cuenta de inicio de sesión enviada a %s.',
        'Please press Back and try again.' => 'Por favor, presione Atrás e inténtelo de nuevo.',
        'Sent password token to: %s' => 'Información de contraseña enviada a: %s',
        'Sent new password to: %s' => 'Contraseña nueva enviada a: %s',
        'Upcoming Events' => 'Eventos Próximos',
        'Event' => 'Evento',
        'Events' => 'Eventos',
        'Invalid Token!' => 'Información inválida.',
        'more' => 'más',
        'For more info see:' => 'Para mas información vea:',
        'Package verification failed' => 'Falló la verificación del paquete',
        'Collapse' => 'Colapso',
        'News' => 'Noticias',
        'Product News' => 'Noticias de Productos',
        'Bold' => 'Negritas',
        'Italic' => 'Cursiva',
        'Underline' => 'Subrallado',
        'Font Color' => 'Color de la letra',
        'Background Color' => 'Color del fondo',
        'Remove Formatting' => 'Eliminar formato',
        'Show/Hide Hidden Elements' => 'Mostrar/Ocultar Elementos Ocultos',
        'Align Left' => 'Alinear a la izquierda',
        'Align Center' => 'Alinear al centro',
        'Align Right' => 'Alinear a la derecha',
        'Justify' => 'Justificar',
        'Header' => 'Encabezado',
        'Indent' => 'Aumentar sagría',
        'Outdent' => 'Reducir sangría',
        'Create an Unordered List' => 'Crear una Lista Desordenada',
        'Create an Ordered List' => 'Crear una Lista Ordenada',
        'HTML Link' => 'Enlace HTML',
        'Insert Image' => 'Insertar imagen',
        'CTRL' => 'CTRL',
        'SHIFT' => 'SHIFT',
        'Undo' => 'Deshacer',
        'Redo' => 'Rehacer',
        '7 Day Stats' => 'Estadísticas Semanales',
        'Online' => 'En línea',
        'OTRS News' => 'Novedades de OTRS',
        'Database Backend' => 'Base de Datos',
        'This values are required.' => 'Estos valores son necesarios.',
        'This values are read only.' => 'Estos valores son de sólo lectura.',
        'Customer Users <-> Services' => 'Clientes <-> Servicios',
        'PostMaster Mail Account' => 'Cuenta del Administrador del Correo',
        'PostMaster Filter' => 'Filtro del Administrador del Correo',

        # Template: AAAMonth
        'Jan' => 'Ene',
        'Feb' => 'Feb',
        'Mar' => 'Mar',
        'Apr' => 'Abr',
        'May' => 'May',
        'Jun' => 'Jun',
        'Jul' => 'Jul',
        'Aug' => 'Ago',
        'Sep' => 'Sep',
        'Oct' => 'Oct',
        'Nov' => 'Nov',
        'Dec' => 'Dic',
        'January' => 'Enero',
        'February' => 'Febrero',
        'March' => 'Marzo',
        'April' => 'Abril',
        'May_long' => 'Mayo',
        'June' => 'Junio',
        'July' => 'Julio',
        'August' => 'Agosto',
        'September' => 'Septiembre',
        'October' => 'Octubre',
        'November' => 'Noviembre',
        'December' => 'Diciembre',

        # Template: AAANavBar
        'Admin-Area' => 'Área-Admin',
        'Agent-Area' => 'Área-Agente',
        'Ticket-Area' => 'Área-Ticket',
        'Logout' => 'Cerrar Sesión',
        'Agent Preferences' => 'Preferencias del Agente',
        'Preferences' => 'Preferencias',
        'Agent Mailbox' => 'Buzón del Agente',
        'Stats' => 'Estadísticas',
        'Stats-Area' => 'Area de Estadísticas',
        'Admin' => 'Administración',
        'Customer Users' => 'Clientes',
        'Customer Users <-> Groups' => 'Clientes <-> Grupos',
        'Users <-> Groups' => 'Usuarios <-> Grupos',
        'Roles' => 'Roles',
        'Roles <-> Users' => 'Roles <-> Usuarios',
        'Roles <-> Groups' => 'Roles <-> Grupos',
        'Salutations' => 'Saludos',
        'Signatures' => 'Firmas',
        'Email Addresses' => 'Direcciones de Correo',
        'Notifications' => 'Notificaciones',
        'Category Tree' => 'Arbol de Categorías',
        'Admin Notification' => 'Notificación del Administrador',

        # Template: AAAPreferences
        'Preferences updated successfully!' => 'Las preferencias se actualizaron satisfactoriamente.',
        'Mail Management' => 'Administración de Correo',
        'Frontend' => 'Interfaz de usuario',
        'Other Options' => 'Otras Opciones',
        'Change Password' => 'Cambiar Contraseña',
        'New password' => 'Nueva contraseña',
        'New password again' => 'Repetir Contraseña',
        'Select your QueueView refresh time.' => 'Seleccione su tiempo de actualización de la vista de filas.',
        'Select your frontend language.' => 'Seleccione su idioma de trabajo.',
        'Select your frontend Charset.' => 'Seleccione su juego de caracteres.',
        'Select your frontend Theme.' => 'Seleccione su tema.',
        'Select your frontend QueueView.' => 'Seleccione su Vista de Filas.',
        'Spelling Dictionary' => 'Diccionario Ortográfico',
        'Select your default spelling dictionary.' => 'Seleccione su diccionario por defecto.',
        'Max. shown Tickets a page in Overview.' => 'Cantidad máxima de Tickets a mostrar en vista Resumen.',
        'Can\'t update password, your new passwords do not match! Please try again!' => 'No se puede actualizar la contraseña, su nueva contraseña no coincide. Por favor reinténtelo.',
        'Can\'t update password, invalid characters!' => 'No se puede actualizar la contraseña, caracteres inválidos',
        'Can\'t update password, must be at least %s characters!' => 'No se puede actualizar la contraseña, se necesitan al menos %s caracteres',
        'Can\'t update password, must contain 2 lower and 2 upper characters!' => 'No se puede actualizar la contraseña, se necesitan al menos 2 caracteres en minúsculas y 2 en mayúsculas.',
        'Can\'t update password, needs at least 1 digit!' => 'No se puede actualizar la contraseña, se necesita al menos 1 dígito.',
        'Can\'t update password, needs at least 2 characters!' => 'No se puede actualizar la contraseña, se necesitan al menos 2 caracteres.',

        # Template: AAAStats
        'Stat' => 'Estadísticas',
        'Please fill out the required fields!' => 'Por favor, proporcione los campos requeridos.',
        'Please select a file!' => 'Por favor, seleccione un archivo.',
        'Please select an object!' => 'Por favor, seleccione un objeto.',
        'Please select a graph size!' => 'Por favor, seleccione un tamaño de gráfica.',
        'Please select one element for the X-axis!' => 'Por favor, seleccione un elemento para el eje X.',
        'Please select only one element or turn off the button \'Fixed\' where the select field is marked!' => 'Por favor, seleccione únicamente un elemento o desactive el botón \'Fijo\' donde el campo está señalado.',
        'If you use a checkbox you have to select some attributes of the select field!' => 'Si usa una casilla de selección, debe seleccionar algunos atributos de dicho campo.',
        'Please insert a value in the selected input field or turn off the \'Fixed\' checkbox!' => 'Por favor, inserte un valor en la caja de texto o desactive la opción \'Fijo\'',
        'The selected end time is before the start time!' => 'La fecha de finalización seleccionada es previa a la de inicio.',
        'You have to select one or more attributes from the select field!' => 'Debe elegir uno o más atributos de la lista de selección.',
        'The selected Date isn\'t valid!' => 'La fecha seleccionada es inválida.',
        'Please select only one or two elements via the checkbox!' => 'Por favor, elija sólo uno o dos elementos de la casilla de selección.',
        'If you use a time scale element you can only select one element!' => 'Si utiliza una escala de tiempo, sólo puede seleccionar un elemento.',
        'You have an error in your time selection!' => 'Tiene un error en la selección del tiempo.',
        'Your reporting time interval is too small, please use a larger time scale!' => 'Su intervalo de tiempo para el reporte es demasiado pequeño, por favor utilice una escala mayor.',
        'The selected start time is before the allowed start time!' => 'El tiempo de inicio seleccionado es previo al permitido.',
        'The selected end time is after the allowed end time!' => 'El tiempo de finalización seleccionado es posterior al permitido.',
        'The selected time period is larger than the allowed time period!' => 'El periodo de tiempo seleccionado es mayor al permitido.',
        'Common Specification' => 'Especificación común',
        'Xaxis' => 'EjeX',
        'Value Series' => 'Serie de Valores',
        'Restrictions' => 'Restricciones',
        'graph-lines' => 'gráfica-líneas',
        'graph-bars' => 'gráfica-barras ',
        'graph-hbars' => 'gráfica-barras-horiz',
        'graph-points' => 'gráfica-puntos',
        'graph-lines-points' => 'gráfica-punteada',
        'graph-area' => 'gráfica-área',
        'graph-pie' => 'gráfica-pastel',
        'extended' => 'extendido',
        'Agent/Owner' => 'Agente/Propietario',
        'Created by Agent/Owner' => 'Creado por Agente/Propietario',
        'Created Priority' => 'Prioridad de Creación',
        'Created State' => 'Estado de Creación',
        'Create Time' => 'Tiempo de Creación',
        'CustomerUserLogin' => 'Cuenta de inicio de sesión del Cliente',
        'Close Time' => 'Fecha de Cierre',
        'TicketAccumulation' => 'Acumulación de Tickets',
        'Attributes to be printed' => 'Atributos a imprimir',
        'Sort sequence' => 'Secuencia de ordenamiento',
        'Order by' => 'Ordenar por',
        'Limit' => 'Límite',
        'Ticketlist' => 'Lista de tickets',
        'ascending' => 'ascendente',
        'descending' => 'descendente',
        'First Lock' => 'Primer bloqueo',
        'Evaluation by' => 'Evaluación por',
        'Total Time' => 'Tiempo Total',
        'Ticket Average' => 'Ticket-Promedio',
        'Ticket Min Time' => 'Ticket-Tiempo Mín',
        'Ticket Max Time' => 'Ticket-Tiempo Máx',
        'Number of Tickets' => 'Número de tickets',
        'Article Average' => 'Artículo-Promedio',
        'Article Min Time' => 'Artículo-Tiempo Mín',
        'Article Max Time' => 'Artículo-Tiempo Máx',
        'Number of Articles' => 'Número de artículos',
        'Accounted time by Agent' => 'Tiempo utilizado por el Agente',
        'Ticket/Article Accounted Time' => 'Tiempo utilizado por el Ticket/Articulo',
        'TicketAccountedTime' => 'Tiempo Utilizado por el Ticket',
        'Ticket Create Time' => 'Tiempo de creación del ticket',
        'Ticket Close Time' => 'Tiempo de cierre del ticket',

        # Template: AAATicket
        'Lock' => 'Bloquear',
        'Unlock' => 'Desbloquear',
        'History' => 'Historia',
        'Zoom' => 'Detalle',
        'Age' => 'Antigüedad',
        'Bounce' => 'Rebotar',
        'Forward' => 'Reenviar',
        'From' => 'De',
        'To' => 'Para',
        'Cc' => 'Copia ',
        'Bcc' => 'Copia Invisible',
        'Subject' => 'Asunto',
        'Move' => 'Mover',
        'Queue' => 'Fila',
        'Priority' => 'Prioridad',
        'Priority Update' => 'Modificar prioridad',
        'State' => 'Estado',
        'Compose' => 'Redactar',
        'Pending' => 'Pendiente',
        'Owner' => 'Propietario',
        'Owner Update' => 'Modificar Propietario',
        'Responsible' => 'Responsable',
        'Responsible Update' => 'Modificar Responsable',
        'Sender' => 'Emisor',
        'Article' => 'Artículo',
        'Ticket' => 'Ticket',
        'Createtime' => 'Fecha de creación ',
        'plain' => 'texto plano',
        'Email' => 'Correo',
        'email' => 'correo',
        'Close' => 'Cerrar',
        'Action' => 'Acción',
        'Attachment' => 'Anexo',
        'Attachments' => 'Anexos',
        'This message was written in a character set other than your own.' => 'Este mensaje fue escrito usando un juego de caracteres distinto al suyo',
        'If it is not displayed correctly,' => 'Si no se muestra correctamente',
        'This is a' => 'Este es un',
        'to open it in a new window.' => 'para abrir en una nueva ventana',
        'This is a HTML email. Click here to show it.' => 'Este es un mensaje HTML. Haga click aquí para mostrarlo.',
        'Free Fields' => 'Campos Libres',
        'Merge' => 'Mezclar',
        'merged' => 'mezclado',
        'closed successful' => 'cerrado exitosamente',
        'closed unsuccessful' => 'cerrado sin éxito',
        'new' => 'nuevo',
        'open' => 'abierto',
        'Open' => 'Abierto',
        'closed' => 'cerrado',
        'Closed' => 'Cerrado',
        'removed' => 'eliminado',
        'pending reminder' => 'recordatorio pendiente',
        'pending auto' => 'pendiente automático',
        'pending auto close+' => 'pendiente auto close+',
        'pending auto close-' => 'pendiente auto close-',
        'email-external' => 'correo-externo',
        'email-internal' => 'correo-interno',
        'note-external' => 'nota-externa',
        'note-internal' => 'nota-interna',
        'note-report' => 'nota-informe',
        'phone' => 'teléfono',
        'sms' => 'sms',
        'webrequest' => 'solicitud vía web',
        'lock' => 'bloquear',
        'unlock' => 'desbloquear',
        'very low' => 'muy bajo',
        'low' => 'bajo',
        'normal' => 'normal',
        'high' => 'alto',
        'very high' => 'muy alto',
        '1 very low' => '1 - muy bajo',
        '2 low' => '2 - bajo',
        '3 normal' => '3 - normal',
        '4 high' => '4 - alto',
        '5 very high' => '5 - muy alto',
        'Ticket "%s" created!' => 'Ticket "%s" creado',
        'Ticket Number' => 'Ticket Número',
        'Ticket Object' => 'Objeto Ticket',
        'No such Ticket Number "%s"! Can\'t link it!' => 'No existe el Ticket Número "%s", no se puede vincular',
        'Don\'t show closed Tickets' => 'No mostrar los tickets cerrados',
        'Show closed Tickets' => 'Mostrar Tickets cerrados',
        'New Article' => 'Nuevo Artículo',
        'Email-Ticket' => 'Ticket de Email',
        'Create new Email Ticket' => 'Crea nuevo Ticket de Email',
        'Phone-Ticket' => 'Ticket Telefónico',
        'Search Tickets' => 'Buscar Tickets',
        'Edit Customer Users' => 'Editar Clientes',
        'Edit Customer Company' => 'Editar Compañía de Clientes',
        'Bulk Action' => 'Acción Múltiple',
        'Bulk Actions on Tickets' => 'Acción Múltiple sobre Tickets',
        'Send Email and create a new Ticket' => 'Enviar un correo y crear un nuevo ticket',
        'Create new Email Ticket and send this out (Outbound)' => 'Crea nuevo Ticket de Email y descartar este (saliente)',
        'Create new Phone Ticket (Inbound)' => 'Crea nuevo Ticket Telefónico (entrante)',
        'Overview of all open Tickets' => 'Resumen de todos los tickets abiertos',
        'Locked Tickets' => 'Tickets Bloqueados',
        'Watched Tickets' => 'Ticket Monitoreados',
        'Watched' => 'Monitoreado',
        'Subscribe' => 'Subscribir',
        'Unsubscribe' => 'Desubscribir',
        'Lock it to work on it!' => 'Bloquearlo para trabajar en él',
        'Unlock to give it back to the queue' => 'Desbloquearlo para devolverlo a la fila',
        'Shows the ticket history!' => 'Mostrar la historia del ticket',
        'Print this ticket!' => 'Imprimir este ticket',
        'Change the ticket priority!' => 'Cambiar la prioridad del ticket',
        'Change the ticket free fields!' => 'Cambiar los campos libres del ticket',
        'Link this ticket to an other objects!' => 'Enlazar este ticket a otros objetos',
        'Change the ticket owner!' => 'Cambiar el propietario del ticket',
        'Change the ticket customer!' => 'Cambiar el cliente del ticket',
        'Add a note to this ticket!' => 'Añadir una nota a este ticket',
        'Merge this ticket!' => 'Fusionar este ticket',
        'Set this ticket to pending!' => 'Poner este ticket como pendiente',
        'Close this ticket!' => 'Cerrar este ticket',
        'Look into a ticket!' => 'Revisar un ticket',
        'Delete this ticket!' => 'Eliminar este ticket',
        'Mark as Spam!' => 'Marcar como correo no deseado',
        'My Queues' => 'Mis Filas',
        'Shown Tickets' => 'Tickets Mostrados',
        'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' => 'Su correo con número de ticket "<OTRS_TICKET>" se unió a "<OTRS_MERGE_TO_TICKET>".',
        'Ticket %s: first response time is over (%s)!' => 'Ticket %s: Tiempo para primera respuesta ha vencido (%s)',
        'Ticket %s: first response time will be over in %s!' => 'Ticket %s: Tiempo para primera respuesta vencerá en %s',
        'Ticket %s: update time is over (%s)!' => 'Ticket %s: Tiempo para actualización ha vencido (%s)',
        'Ticket %s: update time will be over in %s!' => 'Ticket %s: Tiempo para actualización vencerá en %s',
        'Ticket %s: solution time is over (%s)!' => 'Ticket %s: Tiempo para solución ha vencido (%s)',
        'Ticket %s: solution time will be over in %s!' => 'Ticket %s: Tiempo para solución vencerá en %s',
        'There are more escalated tickets!' => 'No hay más tickets escalados',
        'New ticket notification' => 'Notificación de nuevos tickets',
        'Send me a notification if there is a new ticket in "My Queues".' => 'Notifíqueme si hay un nuevo ticket en "Mis Filas".',
        'Follow up notification' => 'Notificación de seguimiento',
        'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.' => 'Notifíqueme si un cliente solicita un seguimiento y yo soy el dueño del ticket.',
        'Ticket lock timeout notification' => 'Notificación de bloqueo de tickets por tiempo',
        'Send me a notification if a ticket is unlocked by the system.' => 'Notifíqueme si un ticket es desbloqueado por el sistema',
        'Move notification' => 'Notificación de movimientos',
        'Send me a notification if a ticket is moved into one of "My Queues".' => 'Notifíqueme si un ticket es colocado en una de "Mis Filas".',
        'Your queue selection of your favourite queues. You also get notified about those queues via email if enabled.' => 'Fila de selección de filas favoritas. Ud. también puede ser notificado de estas filas vía correo si está habilitado',
        'Custom Queue' => 'Fila personal',
        'QueueView refresh time' => 'Tiempo de actualización de la vista de filas',
        'Screen after new ticket' => 'Pantalla posterior a nuevo ticket',
        'Select your screen after creating a new ticket.' => 'Seleccione la pantalla a mostrar después de crear un ticket',
        'Closed Tickets' => 'Tickets Cerrados',
        'Show closed tickets.' => 'Mostrar Tickets cerrados',
        'Max. shown Tickets a page in QueueView.' => 'Cantidad de Tickets a mostrar en la Vista de Fila',
        'Watch notification' => 'Vigilar notificación',
        'Send me a notification of an watched ticket like an owner of an ticket.' => 'Enviarme notificación de un ticket vigilado como si fuera un ticket del que soy dueño.',
        'Out Of Office' => 'Fuera de la oficina',
        'Select your out of office time.' => 'Elija el tiempo fuera de la oficina.',
        'CompanyTickets' => 'TicketsCompañía',
        'MyTickets' => 'MisTickets',
        'New Ticket' => 'Nuevo Ticket',
        'Create new Ticket' => 'Crear un nuevo Ticket',
        'Customer called' => 'Llamada de Cliente',
        'phone call' => 'llamada telefónica',
        'Reminder Reached' => 'Recordatorios alcanzados',
        'Reminder Tickets' => 'Tickets de recordatorios',
        'Escalated Tickets' => 'Tickets escalados',
        'New Tickets' => 'Nuevos tickets',
        'Open Tickets / Need to be answered' => 'Tickets Abiertos / Que necesitan de una respuesta',
        'Tickets which need to be answered!' => 'Tickets que necesitan ser respondidos',
        'All new tickets!' => 'Todos los nuevos tickets',
        'All tickets which are escalated!' => 'Todos los tickets que estan escalados',
        'All tickets where the reminder date has reached!' => 'Todos los tickes que han alcanzado la fecha de recordatorio',
        'Responses' => 'Respuestas',
        'Responses <-> Queues' => 'Respuestas <-> Filas',
        'Auto Responses' => 'Respuestas Automáticas',
        'Auto Responses <-> Queues' => 'Respuestas Automáticas <-> Filas',
        'Attachments <-> Responses' => 'Anexos <-> Respuestas',
        'History::Move' => 'Ticket movido a la fila "%s" (%s) de la fila "%s" (%s).',
        'History::TypeUpdate' => 'Tipo actualizado a %s (ID=%s).',
        'History::ServiceUpdate' => 'Servicio actualizado a %s (ID=%s).',
        'History::SLAUpdate' => 'SLA actualizado a %s (ID=%s).',
        'History::NewTicket' => 'Nuevo Ticket [%s] creado (Q=%s;P=%s;S=%s).',
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
        'History::EmailCustomer' => 'Correo añadido. %s',
        'History::PhoneCallAgent' => 'El agente llamó al cliente.',
        'History::PhoneCallCustomer' => 'El cliente llamó.',
        'History::AddNote' => 'Nota añadida (%s)',
        'History::Lock' => 'Ticket bloqueado.',
        'History::Unlock' => 'Ticket desbloqueado.',
        'History::TimeAccounting' => '%s unidad(es) de tiempo contabilizadas. Nuevo total : %s unidad(es) de tiempo.',
        'History::Remove' => '%s',
        'History::CustomerUpdate' => 'Actualizado: %s',
        'History::PriorityUpdate' => 'Cambiar prioridad de "%s" (%s) a "%s" (%s).',
        'History::OwnerUpdate' => 'El nuevo propietario es "%s" (ID=%s).',
        'History::LoopProtection' => 'Protección de bucle! NO se envió auto-respuesta a "%s".',
        'History::Misc' => '%s',
        'History::SetPendingTime' => 'Actualizado: %s',
        'History::StateUpdate' => 'Antiguo: "%s". Nuevo: "%s"',
        'History::TicketFreeTextUpdate' => 'Actualizado: %s=%s;%s=%s;',
        'History::WebRequestCustomer' => 'Solicitud de cliente vía web.',
        'History::TicketLinkAdd' => 'Añadido enlace al ticket "%s".',
        'History::TicketLinkDelete' => 'Eliminado enlace al ticket "%s".',
        'History::Subscribe' => 'Añadida subscripción para el usuario "%s".',
        'History::Unsubscribe' => 'Eliminada subscripción para el usuario "%s".',

        # Template: AAAWeekDay
        'Sun' => 'Dom',
        'Mon' => 'Lun',
        'Tue' => 'Mar',
        'Wed' => 'Mié',
        'Thu' => 'Jue',
        'Fri' => 'Vie',
        'Sat' => 'Sáb',

        # Template: AdminAttachmentForm
        'Attachment Management' => 'Administración de Anexos',

        # Template: AdminAutoResponseForm
        'Auto Response Management' => 'Administración de Respuestas Automáticas',
        'Response' => 'Respuesta',
        'Auto Response From' => 'Respuesta Automática De',
        'Note' => 'Nota',
        'Useable options' => 'Opciones disponibles',
        'To get the first 20 character of the subject.' => 'Para obtener los primeros 20 caracteres del asunto.',
        'To get the first 5 lines of the email.' => 'Para obtener las primeras 5 líneas del correo.',
        'To get the realname of the sender (if given).' => 'Para obtener el nombre real del remitente (si se proporcionó).',
        'To get the article attribute (e. g. (<OTRS_CUSTOMER_From>, <OTRS_CUSTOMER_To>, <OTRS_CUSTOMER_Cc>, <OTRS_CUSTOMER_Subject> and <OTRS_CUSTOMER_Body>).' => 'Para obtener el atributo del artículo (ej. <OTRS_CUSTOMER_From>, <OTRS_CUSTOMER_To>, <OTRS_CUSTOMER_Cc>, <OTRS_CUSTOMER_Subject> y <OTRS_CUSTOMER_Body>).',
        'Options of the current customer user data (e. g. <OTRS_CUSTOMER_DATA_UserFirstname>).' => 'Opciones de los datos del cliente actual (ej. <OTRS_CUSTOMER_DATA_UserFirstname>).',
        'Ticket owner options (e. g. <OTRS_OWNER_UserFirstname>).' => 'Opciones del propietario del Ticket (ej. <OTRS_OWNER_UserFirstname>).',
        'Ticket responsible options (e. g. <OTRS_RESPONSIBLE_UserFirstname>).' => 'Opciones del responsable del Ticket (ej. <OTRS_RESPONSIBLE_UserFirstname>).',
        'Options of the current user who requested this action (e. g. <OTRS_CURRENT_UserFirstname>).' => 'Opciones del usuario actual que solicitó ésta acción (ej. <OTRS_CURRENT_UserFirstname>).',
        'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>).' => 'Opciones de los datos del Ticket (ej. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>).',
        'Config options (e. g. <OTRS_CONFIG_HttpType>).' => 'Opciones de configuración (ej. <OTRS_CONFIG_HttpType>).',

        # Template: AdminCustomerCompanyForm
        'Customer Company Management' => 'Administración de Compañías del Cliente',
        'Search for' => 'Buscar por',
        'Add Customer Company' => 'Añadir Compañía del Cliente',
        'Add a new Customer Company.' => 'Añadir una nueva Compañía del Cliente.',
        'List' => 'Listar',
        'These values are required.' => 'Estos valores son obligatorios.',
        'These values are read-only.' => 'Estos valores son de sólo-lectura.',

        # Template: AdminCustomerUserForm
        'Title{CustomerUser}' => 'Saludo',
        'Firstname{CustomerUser}' => 'Nombre',
        'Lastname{CustomerUser}' => 'Apellido',
        'Username{CustomerUser}' => 'Nombre de Usuario',
        'Email{CustomerUser}' => 'Correo electrónico',
        'CustomerID{CustomerUser}' => 'Identificador del cliente',
        'Phone{CustomerUser}' => 'Teléfono',
        'Fax{CustomerUser}' => 'Fax',
        'Mobile{CustomerUser}' => 'Móvil',
        'Street{CustomerUser}' => 'Calle',
        'Zip{CustomerUser}' => 'Código Postal',
        'City{CustomerUser}' => 'Ciudad',
        'Country{CustomerUser}' => 'País',
        'Comment{CustomerUser}' => 'Comentario',
        'The message being composed has been closed.  Exiting.' => 'El mensaje que se estaba redactando ha sido cerrado. Saliendo...',
        'This window must be called from compose window' => 'Esta ventana debe ser llamada desde la ventana de redacción',
        'Customer User Management' => 'Administración de Clientes',
        'Add Customer User' => 'Añadir Cliente',
        'Source' => 'Origen',
        'Create' => 'Crear',
        'Customer user will be needed to have a customer history and to login via customer panel.' => 'El cliente se necesita para tener un historial e iniciar sesión a través del panel de clientes.',

        # Template: AdminCustomerUserGroupChangeForm
        'Customer Users <-> Groups Management' => 'Administración de Clientes <-> Grupos',
        'Change %s settings' => 'Cambiar las configuraciones %s',
        'Select the user:group permissions.' => 'Seleccionar los permisos del usuario:grupo',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the user).' => 'Si no se selecciona algo, no habrá permisos en este grupo (los tickets no estarán disponibles para el cliente).',
        'Permission' => 'Permiso',
        'ro' => 'ro',
        'Read only access to the ticket in this group/queue.' => 'Acceso de sólo lectura a los tickets de este grupo/fila.',
        'rw' => 'rw',
        'Full read and write access to the tickets in this group/queue.' => 'Acceso completo de lectura y escritura a los tickets de este grupo/fila.',

        # Template: AdminCustomerUserService
        'Customer Users <-> Services Management' => 'Administración de Clientes <-> Servicios',
        'CustomerUser' => 'Cliente',
        'Service' => 'Servicio',
        'Edit default services.' => 'Modificar los servicios por defecto.',
        'Search Result' => 'Buscar resultados',
        'Allocate services to CustomerUser' => 'Relacionar Servicios con Clientes',
        'Active' => 'Activo',
        'Allocate CustomerUser to service' => 'Relacionar Clientes con Servicios',

        # Template: AdminEmail
        'Message sent to' => 'Mensaje enviado a',
        'A message should have a subject!' => 'Los mensajes deben tener asunto.',
        'Recipients' => 'Destinatarios',
        'Body' => 'Cuerpo',
        'Send' => 'Enviar',

        # Template: AdminGenericAgent
        'GenericAgent' => 'GenericAgent',
        'Job-List' => 'Lista de Tareas',
        'Last run' => 'Última ejecución',
        'Run Now!' => 'Ejecutar ahora',
        'x' => 'x',
        'Save Job as?' => '¿Guardar Tarea como?',
        'Is Job Valid?' => '¿La tarea es válida?',
        'Is Job Valid' => 'La tarea es válida',
        'Schedule' => 'Horario',
        'Currently this generic agent job will not run automatically.' => 'Actualmente esta tarea del agente genérico no se ejecutará automáticamente',
        'To enable automatic execution select at least one value from minutes, hours and days!' => 'Para habilitar la ejecución automática, seleccione al menos un valor de minutos, horas y días.',
        'Fulltext-Search in Article (e. g. "Mar*in" or "Baue*")' => 'Búsqueda de texto en Artículo (ej. "Mar*in" o "Baue*")',
        '(e. g. 10*5155 or 105658*)' => '(ej: 10*5155 o 105658*)',
        '(e. g. 234321)' => '(ej: 234321)',
        'Customer User Login' => 'Nombre de inicio de sesión del cliente',
        '(e. g. U5150)' => '(ej: U5150)',
        'SLA' => 'SLA',
        'Agent' => 'Agente',
        'Ticket Lock' => 'Ticket Bloqueado',
        'TicketFreeFields' => 'CamposLibresDeTicket',
        'Create Times' => 'Tiempos de Creación',
        'No create time settings.' => 'No existen configuraciones para tiempo de creación.',
        'Ticket created' => 'Ticket creado',
        'Ticket created between' => 'Ticket creado entre',
        'Close Times' => 'Tiempos de Cierre',
        'No close time settings.' => 'No existen configuraciones para tiempo de cierre.',
        'Ticket closed' => 'Ticket cerrado',
        'Ticket closed between' => 'Ticket cerrado entre',
        'Pending Times' => 'Tiempos en espera',
        'No pending time settings.' => 'No existen configuraciones para tiempo en espera',
        'Ticket pending time reached' => 'El tiempo en espera del Ticket ha sido alcanzado',
        'Ticket pending time reached between' => 'El tiempo en espera del Ticket ha sido alcanzado entre',
        'Escalation Times' => 'Tiempos de escalado',
        'No escalation time settings.' => 'No existen configuraciones para tiempo de escalado',
        'Ticket escalation time reached' => 'El tiempo de escalado del Ticket ha sido alcanzado',
        'Ticket escalation time reached between' => 'El tiempo de escalado del Ticket ha sido alcanzado entre',
        'Escalation - First Response Time' => 'Escalado - Tiempo Primer Respuesta',
        'Ticket first response time reached' => 'El tiempo para la primer respuesta del Ticket ha sido alcanzado',
        'Ticket first response time reached between' => 'El tiempo para la primer respuesta del Ticket ha sido alcanzado entre',
        'Escalation - Update Time' => 'Escalado - Tiempo Actualización',
        'Ticket update time reached' => 'El tiempo para la actualización del Ticket ha sido alcanzado',
        'Ticket update time reached between' => 'El tiempo para la actualización del Ticket ha sido alcanzado entre',
        'Escalation - Solution Time' => 'Escalado - Tiempo Solución',
        'Ticket solution time reached' => 'El tiempo para la solución del Ticket ha sido alcanzado',
        'Ticket solution time reached between' => 'El tiempo para la solución del Ticket ha sido alcanzado entre',
        'New Service' => 'Servicio nuevo',
        'New SLA' => 'SLA nuevo',
        'New Priority' => 'Prioridad nueva',
        'New Queue' => 'Fila nueva',
        'New State' => 'Estado nuevo',
        'New Agent' => 'Agente nuevo',
        'New Owner' => 'Propietario nuevo',
        'New Customer' => 'Cliente nuevo',
        'New Ticket Lock' => 'Bloqueo de ticket nuevo',
        'New Type' => 'Tipo nuevo',
        'New Title' => 'Título nuevo',
        'New TicketFreeFields' => 'CamposLibresDeTicket nuevos',
        'Add Note' => 'Añadir Nota',
        'Time units' => 'Unidades de tiempo',
        'CMD' => 'CMD',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' => 'Este comando se ejecutará. ARG[0] será el número del ticket y ARG[0] el identificador del ticket.',
        'Delete tickets' => 'Eliminar tickets',
        'Warning! This tickets will be removed from the database! This tickets are lost!' => 'Advertencia: Estos tickets se eliminarán de la base de datos y serán inaccesibles',
        'Send Notification' => 'Enviar Notificación',
        'Param 1' => 'Parámetro 1',
        'Param 2' => 'Parámetro 2',
        'Param 3' => 'Parámetro 3',
        'Param 4' => 'Parámetro 4',
        'Param 5' => 'Parámetro 5',
        'Param 6' => 'Parámetro 6',
        'Send agent/customer notifications on changes' => 'Enviar notificación de cambios al agente/cliente',
        'Save' => 'Guardar',
        '%s Tickets affected! Do you really want to use this job?' => '%s Tickets afectados. ¿Realmente desea utilizar esta tarea?',

        # Template: AdminGroupForm
        'WARNING: When you change the name of the group \'admin\', before making the appropriate changes in the SysConfig, you will be locked out of the administrations panel! If this happens, please rename the group back to admin per SQL statement.' => 'ATENCIÓN: Cuando cambia el nombre del grupo \'admin\', antes de realizar los cambios apropiados en SysConfig, bloqueará el panel de administración! Si esto sucediera, por favor vuelva a renombrar el grupo para administrar por declaración SQL.',
        'Group Management' => 'Administración de grupos',
        'Add Group' => 'Añadir Grupo',
        'Add a new Group.' => 'Añadir nuevo Grupo',
        'The admin group is to get in the admin area and the stats group to get stats area.' => 'El grupo admin es para usar el área de administración y el grupo stats para usar el área estadisticas.',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).' => 'Crear nuevos grupos para manipular los permisos de acceso por distintos grupos de agente (ej: departamento de compra, departamento de soporte, departamento de ventas,...).',
        'It\'s useful for ASP solutions.' => 'Esto es útil para soluciones ASP.',

        # Template: AdminLog
        'System Log' => 'Log del Sistema',
        'Time' => 'Tiempo',

        # Template: AdminMailAccount
        'Mail Account Management' => 'Administración de Cuentas de Correo',
        'Host' => 'Host',
        'Trusted' => 'Confiable',
        'Dispatching' => 'Remitiendo',
        'All incoming emails with one account will be dispatched in the selected queue!' => 'Todos los correos entrantes con una cuenta serán enviados a la fila seleccionada',
        'If your account is trusted, the already existing X-OTRS header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' => 'Si su cuenta está validada, las cabeceras X-OTRS ya existentes en la llegada se utilizarán para la prioridad. El filtro Postmaster se usa de todas formas.',

        # Template: AdminNavigationBar
        'Users' => 'Usuarios',
        'Groups' => 'Grupos',
        'Misc' => 'Misceláneo',

        # Template: AdminNotificationEventForm
        'Notification Management' => 'Administración de Notificaciones',
        'Add Notification' => 'Agregar Notificación',
        'Add a new Notification.' => 'Agregar una nueva Notificación',
        'Name is required!' => 'Debe especificar Nombre',
        'Event is required!' => 'Debe especificar Evento',
        'A message should have a body!' => 'Los mensajes deben tener contenido',
        'Recipient' => 'Recipiente',
        'Group based' => 'Basado en grupo',
        'Agent based' => 'Basado en agente',
        'Email based' => 'Basado en e-mail',
        'Article Type' => 'Tipo de artículo',
        'Only for ArticleCreate Event.' => 'Solo para el Evento CrearArtículo',
        'Subject match' => 'Coincidencia de asunto',
        'Body match' => 'Coincidencia del cuerpo',
        'Notifications are sent to an agent or a customer.' => 'Las notificaciones se envían a un agente o cliente',
        'To get the first 20 character of the subject (of the latest agent article).' => 'Para obtener los primeros 20 caracters del Sujeto (del último artículo del agente).',
        'To get the first 5 lines of the body (of the latest agent article).' => 'Para obtener las primeras 5 líneas del cuerpo (del último artículo del agente).',
        'To get the article attribute (e. g. (<OTRS_AGENT_From>, <OTRS_AGENT_To>, <OTRS_AGENT_Cc>, <OTRS_AGENT_Subject> and <OTRS_AGENT_Body>).' => 'Para obtener los atributos (ej. <OTRS_AGENT_From>, <OTRS_AGENT_To>, <OTRS_AGENT_Cc>, <OTRS_AGENT_Subject> and <OTRS_AGENT_Body>)',
        'To get the first 20 character of the subject (of the latest customer article).' => 'Para obtener los primeros 20 caracters del Sujeto (del último artículo del cliente).',
        'To get the first 5 lines of the body (of the latest customer article).' => 'Para obtener las primeras 5 líneas del cuerpo (del último artículo del cliente).',

        # Template: AdminNotificationForm
        'Notification' => 'Notificaciones',

        # Template: AdminPackageManager
        'Package Manager' => 'Gestor de paquetes',
        'Uninstall' => 'Desinstalar',
        'Version' => 'Versión',
        'Do you really want to uninstall this package?' => 'Está seguro de que desea desinstalar este paquete?',
        'Reinstall' => 'Reinstalar',
        'Do you really want to reinstall this package (all manual changes get lost)?' => 'Realmente desea reinstalar este paquete (todos los cambios manuales se perderán)?',
        'Continue' => 'Continuar',
        'Install' => 'Instalar',
        'Package' => 'Paquete',
        'Online Repository' => 'Repositorio Online',
        'Vendor' => 'Vendedor',
        'Module documentation' => 'Módulo de Documentación',
        'Upgrade' => 'Actualizar',
        'Local Repository' => 'Repositorio Local',
        'Status' => 'Estados',
        'Overview' => 'Resumen',
        'Download' => 'Descargar',
        'Rebuild' => 'Reconstruir',
        'ChangeLog' => 'Log de Cambios',
        'Date' => 'Fecha',
        'Filelist' => 'Lista de Archivos',
        'Download file from package!' => 'Descargar archivo del paquete!',
        'Required' => 'Obligatorio',
        'PrimaryKey' => 'ClavePrimaria',
        'AutoIncrement' => 'AutoIncrementar',
        'SQL' => '',
        'Diff' => '',

        # Template: AdminPerformanceLog
        'Performance Log' => 'Log de rendimiento',
        'This feature is enabled!' => 'Esta característica está habilitada',
        'Just use this feature if you want to log each request.' => 'Use esta característica sólo si desea registrar cada petición.',
        'Activating this feature might affect your system performance!' => 'Activar esta opción podría afectar el rendimiento de su sistema!',
        'Disable it here!' => 'Deshabilítelo aquí',
        'This feature is disabled!' => 'Esta característica está deshabilitada',
        'Enable it here!' => 'Habilítelo aquí',
        'Logfile too large!' => 'Archivo de log muy grande',
        'Logfile too large, you need to reset it!' => 'Archivo de log muy grande, necesita reinicializarlo',
        'Range' => 'Rango',
        'Interface' => 'Interfase',
        'Requests' => 'Solicitudes',
        'Min Response' => 'Respuesta Mínima',
        'Max Response' => 'Respuesta Máxima',
        'Average Response' => 'Respuesta Promedio',
        'Period' => 'Periodo',
        'Min' => 'Min',
        'Max' => 'Max',
        'Average' => 'Promedio',

        # Template: AdminPGPForm
        'PGP Management' => 'Administración PGP',
        'Result' => 'Resultado',
        'Identifier' => 'Identificador',
        'Bit' => '',
        'Key' => 'Clave',
        'Fingerprint' => 'Huella',
        'Expires' => 'Expira',
        'In this way you can directly edit the keyring configured in SysConfig.' => 'De esta forma puede editar directamente el anillo de Claves configurado en Sysconfig',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => 'Administración del filtro maestro',
        'Filtername' => 'Nombre del filtro',
        'Stop after match' => 'Parar al coincidir',
        'Match' => 'Coincidir',
        'Value' => 'Valor',
        'Set' => 'Ajustar',
        'Do dispatch or filter incoming emails based on email X-Headers! RegExp is also possible.' => 'Clasificar o filtrar correos entrantes basado en encabezamientos X-Headers! Puede utilizar expresiones regulares.',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' => 'Si desea chequear sólo la dirección del email, use EMAILADDRESS:info@example.com en De, Para o Cc.',
        'If you use RegExp, you also can use the matched value in () as [***] in \'Set\'.' => 'Si utiliza expresiones regulares, puede también usar el valor encontrado en () as [***] en \'Set\'.',

        # Template: AdminPriority
        'Priority Management' => 'Administración de Prioridades',
        'Add Priority' => 'Añadir Prioridad',
        'Add a new Priority.' => 'Añadir una nueva Prioridad.',

        # Template: AdminQueueAutoResponseForm
        'Queue <-> Auto Responses Management' => 'Administración de Fila <-> Respuestas Automáticas',
        'settings' => 'configuración',

        # Template: AdminQueueForm
        'Queue Management' => 'Administración de Filas',
        'Sub-Queue of' => 'Subfila de',
        'Unlock timeout' => 'Tiempo para desbloqueo automático',
        '0 = no unlock' => '0 = sin desbloqueo',
        'Only business hours are counted.' => 'Sólo se contarán las horas de trabajo',
        '0 = no escalation' => '0 = sin escalado',
        'Notify by' => 'Notificado por',
        'Follow up Option' => 'Opción de seguimiento',
        'Ticket lock after a follow up' => 'Bloquear un ticket después del seguimiento',
        'Systemaddress' => 'Direcciones de correo del sistema',
        'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.' => 'Si un agente bloquea un ticket y no envía una respuesta en este tiempo, el ticket será desbloqueado automáticamente. El Ticket será visible por todos los demás agentes.',
        'Escalation time' => 'Tiempo de escalado',
        'If a ticket will not be answered in this time, just only this ticket will be shown.' => 'Si un ticket no ha sido respondido es este tiempo, sólo este ticket se mostrará',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.' => 'Si el ticket está cerrado y el cliente envía un seguimiento al mismo, éste será bloqueado para el antiguo propietario',
        'Will be the sender address of this queue for email answers.' => 'Será la dirección del emisor en esta fila para respuestas por correo.',
        'The salutation for email answers.' => 'Saludo para respuestas por correo.',
        'The signature for email answers.' => 'Firma para respuestas por correo.',
        'Customer Move Notify' => 'Notificar al Cliente al Mover',
        'OTRS sends an notification email to the customer if the ticket is moved.' => 'OTRS envía una notificación por correo al cliente si el ticket se mueve',
        'Customer State Notify' => 'Notificación de estado al Cliente',
        'OTRS sends an notification email to the customer if the ticket state has changed.' => 'OTRS envía una notificación por correo al cliente si el estado del ticket cambia',
        'Customer Owner Notify' => 'Notificar al Propietario al Mover',
        'OTRS sends an notification email to the customer if the ticket owner has changed.' => 'OTRS envía una notificación por correo al cliente si el propietario del ticket cambia',

        # Template: AdminQueueResponsesChangeForm
        'Responses <-> Queue Management' => 'Administración de Respuestas <-> Filas',

        # Template: AdminQueueResponsesForm
        'Answer' => 'Responder',

        # Template: AdminResponseAttachmentChangeForm
        'Responses <-> Attachments Management' => 'Administración de Respuestas <-> Anexos',

        # Template: AdminResponseAttachmentForm

        # Template: AdminResponseForm
        'Response Management' => 'Administración de Respuestas',
        'A response is default text to write faster answer (with default text) to customers.' => 'Una respuesta es el texto por defecto para responder más rápido (con el texto por defecto) a los clientes.',
        'Don\'t forget to add a new response a queue!' => 'No olvide incluir una nueva respuesta en la fila',
        'The current ticket state is' => 'El estado actual del ticket es',
        'Your email address is new' => 'Su dirección de correo es nueva',

        # Template: AdminRoleForm
        'Role Management' => 'Administración de Roles',
        'Add Role' => 'Añadir Rol',
        'Add a new Role.' => 'Añadir un nuevo Rol',
        'Create a role and put groups in it. Then add the role to the users.' => 'Cree un rol y coloque grupos en el mismo. Luego añada el rol a los usuarios.',
        'It\'s useful for a lot of users and groups.' => 'Es útil para gestionar muchos usuarios y grupos.',

        # Template: AdminRoleGroupChangeForm
        'Roles <-> Groups Management' => 'Administración de Roles <-> Grupos',
        'move_into' => 'mover_a',
        'Permissions to move tickets into this group/queue.' => 'Permiso para mover tickets a este grupo/fila',
        'create' => 'crear',
        'Permissions to create tickets in this group/queue.' => 'Permiso para crear tickets en este grupo/fila',
        'owner' => 'propietario',
        'Permissions to change the ticket owner in this group/queue.' => 'Permiso para cambiar el propietario del ticket en este grupo/fila',
        'priority' => 'prioridad',
        'Permissions to change the ticket priority in this group/queue.' => 'Permiso para cambiar la prioridad del ticket en este grupo/fila',

        # Template: AdminRoleGroupForm
        'Role' => 'Rol',

        # Template: AdminRoleUserChangeForm
        'Roles <-> Users Management' => 'Administración de Roles <-> Usuarios',
        'Select the role:user relations.' => 'Seleccionar las relaciones Rol-Cliente',

        # Template: AdminRoleUserForm

        # Template: AdminSalutationForm
        'Salutation Management' => 'Administración de Saludos',
        'Add Salutation' => 'Añadir Saludo',
        'Add a new Salutation.' => 'Añadir un nuevo Saludo',

        # Template: AdminSecureMode
        'Secure Mode need to be enabled!' => '¡El Modo Seguro debe estar habilitado!',
        'Secure mode will (normally) be set after the initial installation is completed.' => 'El Modo Seguro (normalmente) queda habilitado cuando la instalación inicial se completa.',
        'Secure mode must be disabled in order to reinstall using the web-installer.' => 'El Modo Seguro debe estar deshabilitado para poder reinstalar usado el instalador web.',
        'If Secure Mode is not activated, activate it via SysConfig because your application is already running.' => 'Si el Modo Seguro no está activado actívelo con SysConfig ya que su aplicación está en funcionamiento.',

        # Template: AdminSelectBoxForm
        'SQL Box' => 'Consola SQL',
        'Go' => 'Ir',
        'Select Box Result' => 'Seleccione tipo de resultado',

        # Template: AdminService
        'Service Management' => 'Administración de Servicios',
        'Add Service' => 'Añadir Servicio',
        'Add a new Service.' => 'Añadir un nuevo Servicio',
        'Sub-Service of' => 'Sub-Servicio de',

        # Template: AdminSession
        'Session Management' => 'Administración de Sesiones',
        'Sessions' => 'Sesiones',
        'Uniq' => 'Único',
        'Kill all sessions' => 'Finalizar todas las sesiones',
        'Session' => 'Sesión',
        'Content' => 'Contenido',
        'kill session' => 'finalizar la sesión',

        # Template: AdminSignatureForm
        'Signature Management' => 'Administración de Firmas',
        'Add Signature' => 'Añadir Firma',
        'Add a new Signature.' => 'Añadir una nueva Firma',

        # Template: AdminSLA
        'SLA Management' => 'Administración de SLA',
        'Add SLA' => 'Añadir SLA',
        'Add a new SLA.' => 'Añadir un nuevo SLA',

        # Template: AdminSMIMEForm
        'S/MIME Management' => 'Gestion S/MIME',
        'Add Certificate' => 'Añadir Certificado',
        'Add Private Key' => 'Añadir Clave Privada',
        'Secret' => 'Secreto',
        'Hash' => '',
        'In this way you can directly edit the certification and private keys in file system.' => 'De esta forma Ud. puede editar directamente la certificación y claves privadas en el sistema de archivos.',

        # Template: AdminStateForm
        'State Management' => 'Administración de Estados',
        'Add State' => 'Añadir Estado',
        'Add a new State.' => 'Añadir un nuevo Estado',
        'State Type' => 'Tipo de Estado',
        'Take care that you also updated the default states in you Kernel/Config.pm!' => 'Recuerde también actualizar los estados en su archivo Kernel/Config.pm! ',
        'See also' => 'Vea también',

        # Template: AdminSysConfig
        'SysConfig' => 'Configuración del sistema',
        'Group selection' => 'Selección de Grupo',
        'Show' => 'Mostrar',
        'Download Settings' => 'Descargar Configuración',
        'Download all system config changes.' => 'Descargar todos los cambios de configuración',
        'Load Settings' => 'Cargar Configuración',
        'Subgroup' => 'Subgrupo',
        'Elements' => 'Elementos',

        # Template: AdminSysConfigEdit
        'Config Options' => 'Opciones de Configuración',
        'Default' => 'Por Defecto',
        'New' => 'Nuevo',
        'New Group' => 'Nuevo grupo',
        'Group Ro' => 'Grupo Ro',
        'New Group Ro' => 'Nuevo Grupo Ro',
        'NavBarName' => 'NombreBarraNavegación',
        'NavBar' => 'BarraNavegación',
        'Image' => 'Imagen',
        'Prio' => 'Prio',
        'Block' => 'Bloquear',
        'AccessKey' => 'TeclaAcceso',

        # Template: AdminSystemAddressForm
        'System Email Addresses Management' => 'Administración de Direcciones de Correo del sistema',
        'Add System Address' => 'Añadir Dirección de Sistema',
        'Add a new System Address.' => 'Añadir una Dirección de Sistema',
        'Realname' => 'Nombre real',
        'All email addresses get excluded on replaying on composing an email.' => 'Toda dirección de correo electrónico será omitida mientras se compone la respuesta de un correo.',
        'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!' => 'Todos los mensajes entrantes con esta dirección (Para:) serán enviados a la fila seleccionada',

        # Template: AdminTypeForm
        'Type Management' => 'Administración de Tipos',
        'Add Type' => 'Añadir Tipo',
        'Add a new Type.' => 'Añadir un nuevo Tipo',

        # Template: AdminUserForm
        'User Management' => 'Administración de usuarios',
        'Add User' => 'Añadir Usuario',
        'Add a new Agent.' => 'Añadir un nuevo Agente',
        'Login as' => 'Conectarse como',
        'Title{user}' => 'Título',
        'Firstname' => 'Nombre',
        'Lastname' => 'Apellido',
        'Start' => 'Iniciar',
        'End' => 'Fin',
        'User will be needed to handle tickets.' => 'Se necesita un usuario para manipular los tickets.',
        'Don\'t forget to add a new user to groups and/or roles!' => 'No olvide añadir los nuevos usuarios a grupos y/o roles',

        # Template: AdminUserGroupChangeForm
        'Users <-> Groups Management' => 'Administración de Usuarios <-> Grupos',

        # Template: AdminUserGroupForm

        # Template: AgentBook
        'Address Book' => 'Libreta de Direcciones',
        'Return to the compose screen' => 'Volver a la pantalla de redacción',
        'Discard all changes and return to the compose screen' => 'Descartar todos los cambios y volver a la pantalla de redacción',

        # Template: AgentCalendarSmall

        # Template: AgentCalendarSmallIcon

        # Template: AgentCustomerSearch

        # Template: AgentCustomerTableView

        # Template: AgentDashboard
        'Dashboard' => 'Panel principal',

        # Template: AgentDashboardCalendarOverview
        'in' => 'en',

        # Template: AgentDashboardImage

        # Template: AgentDashboardProductNotify
        '%s %s is available!' => '%s %s está disponible!',
        'Please update now.' => 'Por favór, actualize ahora',
        'Release Note' => 'Notas de versión',
        'Level' => 'Nivel',

        # Template: AgentDashboardRSSOverview
        'Posted %s ago.' => 'Enviado hace %s.',

        # Template: AgentDashboardTicketOverview

        # Template: AgentDashboardTicketStats

        # Template: AgentInfo
        'Info' => 'Información',

        # Template: AgentLinkObject
        'Link Object: %s' => 'Objeto Vinculado: %s',
        'Object' => 'Objeto',
        'Link Object' => 'Enlazar Objeto',
        'with' => 'con',
        'Select' => 'Seleccionar',
        'Unlink Object: %s' => 'Objecto desvinculado: %s',

        # Template: AgentLookup
        'Lookup' => 'Observar',

        # Template: AgentNavigationBar

        # Template: AgentPreferencesForm

        # Template: AgentSpelling
        'Spell Checker' => 'Chequeo Ortográfico',
        'spelling error(s)' => 'errores ortográficos',
        'or' => 'o',
        'Apply these changes' => 'Aplicar los cambios',

        # Template: AgentStatsDelete
        'Do you really want to delete this Object?' => 'Seguro que desea eliminar este objeto?',

        # Template: AgentStatsEditRestrictions
        'Select the restrictions to characterise the stat' => 'Seleccione las restricciones para caracterizar la estadística',
        'Fixed' => 'Fijo',
        'Please select only one element or turn off the button \'Fixed\'.' => 'Por favor seleccione sólo un elemento o desactive el botón \'Fijo\.',
        'Absolut Period' => 'Periodo Absoluto',
        'Between' => 'Entre',
        'Relative Period' => 'Periodo Relativo',
        'The last' => 'El último',
        'Finish' => 'Finalizar',
        'Here you can make restrictions to your stat.' => 'Aquí puede declarar restricciones para sus estadísticas.',
        'If you remove the hook in the "Fixed" checkbox, the agent generating the stat can change the attributes of the corresponding element.' => 'Si elimina el candado en la casilla "Fijo", el agente que genera la estadística puede cambiar los atributos del elemento correspondiente',

        # Template: AgentStatsEditSpecification
        'Insert of the common specifications' => 'Inserte las especificaciones comunes',
        'Permissions' => 'Permisos',
        'Format' => 'Formato',
        'Graphsize' => 'Tamaño de la Gráfica',
        'Sum rows' => 'Sumar filas',
        'Sum columns' => 'Sumar columnas',
        'Cache' => '',
        'Required Field' => 'Campos obligatorios',
        'Selection needed' => 'Selección obligatoria',
        'Explanation' => 'Explicación',
        'In this form you can select the basic specifications.' => 'En esta pantalla puede seleccionar las especificaciones básicas',
        'Attribute' => 'Atributo',
        'Title of the stat.' => 'Título de la estadística',
        'Here you can insert a description of the stat.' => 'Aquí puede insertar una descripción de la estadística.',
        'Dynamic-Object' => 'Objeto-Dinámico',
        'Here you can select the dynamic object you want to use.' => 'Aquí puede seleccionar el elemento dinámico que desea utilizar',
        '(Note: It depends on your installation how many dynamic objects you can use)' => '(Nota: Depende de su instalación cuántos objetos dinámicos puede utilizar',
        'Static-File' => 'Archivo-Estático',
        'For very complex stats it is possible to include a hardcoded file.' => 'Para una estadística muy compleja es posible incluir un archivo preconfigurado',
        'If a new hardcoded file is available this attribute will be shown and you can select one.' => 'Si un nuevo archivo preconfigurado está disponible, este atributo se le mostrará y podrá seleccionar uno',
        'Permission settings. You can select one or more groups to make the configurated stat visible for different agents.' => 'Configuración de permisos. Puede seleccionar uno o más grupos para hacer visibles las estadísticas configuradas a distintos agentes',
        'Multiple selection of the output format.' => 'Selección múltiple del formato de salida',
        'If you use a graph as output format you have to select at least one graph size.' => 'Si utiliza un gráfico como formato de salida debe seleccionar al menos un tamaño de gráfico.',
        'If you need the sum of every row select yes' => 'Si necesita la suma de cada fila seleccione Sí',
        'If you need the sum of every column select yes.' => 'Si necesita las suma de cada columna seleccione Sí',
        'Most of the stats can be cached. This will speed up the presentation of this stat.' => 'La mayoría de las estadisticas pueden ser conservadas en cache. Esto acelera la presentación de esta estadística.',
        '(Note: Useful for big databases and low performance server)' => '(Nota: Util para bases de datos grandes y servidores de bajo rendimiento)',
        'With an invalid stat it isn\'t feasible to generate a stat.' => 'Con una estadistica inválida, no es posible generar estadísticas.',
        'This is useful if you want that no one can get the result of the stat or the stat isn\'t ready configurated.' => 'Esto es útil si desea que nadie pueda obtener el resultado de una estadística o la misma aún no está configurada',

        # Template: AgentStatsEditValueSeries
        'Select the elements for the value series' => 'Seleccione los elementos para los valores de la serie',
        'Scale' => 'Escala',
        'minimal' => 'mínimo',
        'Please remember, that the scale for value series has to be larger than the scale for the X-axis (e.g. X-Axis => Month, ValueSeries => Year).' => 'Recuerde, la escala para los valores de la serie debe ser mayor que la escala para el eje-X (ej: eje-X => Mes, ValorSeries => Año).',
        'Here you can define the value series. You have the possibility to select one or two elements. Then you can select the attributes of elements. Each attribute will be shown as single value series. If you don\'t select any attribute all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' => 'Aquí puede definir la serie de valores. Tiene la posibilidad de seleccionar uno o más elementos. Luego, puede seleccionar los atributos de los elementos. Cada atributo será mostrado como un elemento de la serie. Si no selecciona ningún atributo, todos los atributos del elemento serán utilizados si genera una estadística. Asimismo un nuevo atributo es añadido desde la última configuración.',

        # Template: AgentStatsEditXaxis
        'Select the element, which will be used at the X-axis' => 'Seleccione el elemento, que será utilizado en el eje-X',
        'maximal period' => 'periodo máximo',
        'minimal scale' => 'escala mínima',
        'Here you can define the x-axis. You can select one element via the radio button. If you make no selection, all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' =>
        'Aquí Ud. puede definir el eje x. Puede seleccionar un elemento con un boton circular (radio button). Si no selecciona un atributo, todos los atributos del elemento serán usados si genera una estadística, apenas se agrega un nuevo atributo desde la útima configuración',

        # Template: AgentStatsImport
        'Import' => 'Importar',
        'File is not a Stats config' => 'El archivo no es una configuración de estadísticas',
        'No File selected' => 'No hay archivo seleccionado',

        # Template: AgentStatsOverview
        'Results' => 'Resultados',
        'Total hits' => 'Total de coincidencias',
        'Page' => 'Página',

        # Template: AgentStatsPrint
        'Print' => 'Imprimir',
        'No Element selected.' => 'No hay elemento seleccionado',

        # Template: AgentStatsView
        'Export Config' => 'Exportar Configuración',
        'Information about the Stat' => 'Información sobre la estadística',
        'Exchange Axis' => 'Intercambiar Ejes',
        'Configurable params of static stat' => 'Parámetro configurable de estadística estática',
        'No element selected.' => 'No hay elemento seleccionado',
        'maximal period from' => 'periodo máximo desde',
        'to' => 'a',
        'With the input and select fields you can configurate the stat at your needs. Which elements of a stat you can edit depends on your stats administrator who configurated the stat.' => 'Con los campos de entrada y selección, puede configurar las estadísticas a sus necesidades. Los elementos de estadísticas que puede editar dependen de cómo haya sido configurado por el administrador',

        # Template: AgentTicketBounce
        'A message should have a To: recipient!' => 'El mensaje debe tener el destinatario Para: !',
        'You need a email address (e. g. customer@example.com) in To:!' => 'Necesita una dirección de correo (ej: cliente@ejemplo.com) en Para:!',
        'Bounce ticket' => 'Ticket rebotado',
        'Ticket locked!' => 'Ticket bloqueado',
        'Ticket unlock!' => 'Ticket desbloqueado',
        'Bounce to' => 'Rebotar a',
        'Next ticket state' => 'Nuevo estado del ticket',
        'Inform sender' => 'Informar al emisor',
        'Send mail!' => 'Enviar correo',

        # Template: AgentTicketBulk
        'You need to account time!' => 'Necesita contabilizar el tiempo',
        'Ticket Bulk Action' => 'Acción múltiple con Tickets',
        'Spell Check' => 'Chequeo Ortográfico',
        'Note type' => 'Tipo de nota',
        'Next state' => 'Siguiente estado',
        'Pending date' => 'Fecha pendiente',
        'Merge to' => 'Fusionar con',
        'Merge to oldest' => 'Combinar con el mas viejo',
        'Link together' => 'Enlazar juntos',
        'Link to Parent' => 'Enlazar con el padre',
        'Unlock Tickets' => 'Desbloquear Tickets',

        # Template: AgentTicketClose
        'Ticket Type is required!' => 'Se necesita el tipo de Ticket',
        'A required field is:' => 'Un campo requerido es:',
        'Close ticket' => 'Cerrar el ticket',
        'Previous Owner' => 'Propietario Anterior',
        'Inform Agent' => 'Notificar a Agente',
        'Optional' => 'Opcional',
        'Inform involved Agents' => 'Notificar a Agentes involucrados',
        'Attach' => 'Anexo',

        # Template: AgentTicketCompose
        'A message must be spell checked!' => 'El mensaje debe ser verificado ortográficamente!',
        'Compose answer for ticket' => 'Redacte una respuesta para el ticket',
        'Pending Date' => 'Fecha pendiente',
        'for pending* states' => 'en estado pendiente*',

        # Template: AgentTicketCustomer
        'Change customer of ticket' => 'Cambiar cliente del ticket',
        'Set customer user and customer id of a ticket' => 'Asignar agente y cliente de un ticket',
        'Customer User' => 'Cliente',
        'Search Customer' => 'Búsqueda de cliente',
        'Customer Data' => 'Información del cliente',
        'Customer history' => 'Historia del cliente',
        'All customer tickets.' => 'Todos los tickets de un cliente',

        # Template: AgentTicketEmail
        'Compose Email' => 'Redactar Correo',
        'new ticket' => 'nuevo ticket',
        'Refresh' => 'Refrescar',
        'Clear To' => 'Vaciar Para',
        'All Agents' => 'Todos los Agentes',

        # Template: AgentTicketEscalation

        # Template: AgentTicketForward
        'Article type' => 'Tipo de artículo',

        # Template: AgentTicketFreeText
        'Change free text of ticket' => 'Cambiar el texto libre del ticket',

        # Template: AgentTicketHistory
        'History of' => 'Historia de',

        # Template: AgentTicketLocked

        # Template: AgentTicketMerge
        'You need to use a ticket number!' => 'Necesita usar un número de ticket!',
        'Ticket Merge' => 'Fusionar Ticket',

        # Template: AgentTicketMove
        'If you want to account time, please provide Subject and Text!' => 'Si desea contabilizar el tiempo, porfavor ingrese Sujeto y Texto',
        'Move Ticket' => 'Mover Ticket',

        # Template: AgentTicketNote
        'Add note to ticket' => 'Añadir nota al ticket',

        # Template: AgentTicketOverviewMedium
        'First Response Time' => 'Tiempo para Primera Respuesta',
        'Service Time' => 'Tiempo de Servicio',
        'Update Time' => 'Tiempo para Actualización',
        'Solution Time' => 'Tiempo para Solución',

        # Template: AgentTicketOverviewMediumMeta
        'You need min. one selected Ticket!' => 'Necesita al menos seleccionar un Ticket!',

        # Template: AgentTicketOverviewNavBar
        'Filter' => 'Filtro',
        'Change search options' => 'Cambiar opciones de búsqueda',
        'Tickets' => '',
        'of' => 'de',

        # Template: AgentTicketOverviewNavBarSmall

        # Template: AgentTicketOverviewPreview
        'Compose Answer' => 'Responder',
        'Contact customer' => 'Contactar con el cliente',
        'Change queue' => 'Modificar fila',

        # Template: AgentTicketOverviewPreviewMeta

        # Template: AgentTicketOverviewSmall
        'sort upward' => 'ordenar ascendente',
        'up' => 'arriba',
        'sort downward' => 'ordenar descendente',
        'down' => 'abajo',
        'Escalation in' => 'Escalado en',
        'Locked' => 'Bloqueado',

        # Template: AgentTicketOwner
        'Change owner of ticket' => 'Cambiar el propietario del ticket',

        # Template: AgentTicketPending
        'Set Pending' => 'Establecer como pendiente',

        # Template: AgentTicketPhone
        'Phone call' => 'Llamada telefónica',
        'Clear From' => 'Vaciar De',

        # Template: AgentTicketPhoneOutbound

        # Template: AgentTicketPlain
        'Plain' => 'Texto plano',

        # Template: AgentTicketPrint
        'Ticket-Info' => 'Informacion-Ticket',
        'Accounted time' => 'Tiempo contabilizado',
        'Linked-Object' => 'Objeto-vinculado',
        'by' => 'por',

        # Template: AgentTicketPriority
        'Change priority of ticket' => 'Cambiar la prioridad del ticket',

        # Template: AgentTicketQueue
        'Tickets shown' => 'Tickets mostrados',
        'Tickets available' => 'Tickets disponibles',
        'All tickets' => 'Todos los tickets',
        'Queues' => 'Filas',
        'Ticket escalation!' => 'Escalado de ticket',

        # Template: AgentTicketResponsible
        'Change responsible of ticket' => 'Cambiar responsable del ticket',

        # Template: AgentTicketSearch
        'Ticket Search' => 'Buscar ticket',
        'Profile' => 'Perfil',
        'Search-Template' => 'Buscar-Modelo',
        'TicketFreeText' => 'TextoLibreTicket',
        'Created in Queue' => 'Creado en Fila',
        'Article Create Times' => 'Tiempo de Creación de Artículo',
        'Article created' => 'Artículo Creado',
        'Article created between' => 'Artículo creado entre',
        'Change Times' => 'Cambio de Tiempo',
        'No change time settings.' => 'Sin cambio de marca de tiempo',
        'Ticket changed' => 'Ticket modificado',
        'Ticket changed between' => 'Ticket modificado entre',
        'Result Form' => 'Modelo de Resultados',
        'Save Search-Profile as Template?' => 'Guardar perfil de búsqueda como patrón?',
        'Yes, save it with name' => 'Sí, guardarlo con nombre',

        # Template: AgentTicketSearchOpenSearchDescriptionFulltext
        'Fulltext' => 'Texto Completo',

        # Template: AgentTicketSearchOpenSearchDescriptionTicketNumber

        # Template: AgentTicketSearchResultPrint

        # Template: AgentTicketZoom
        'Expand View' => 'Vista ampliada',
        'Collapse View' => 'Vista reducida',
        'Split' => 'Dividir',

        # Template: AgentTicketZoomArticleFilterDialog
        'Article filter settings' => 'Configuración de filtro de artículos',
        'Save filter settings as default' => 'Grabar configuración de filtros como defecto',

        # Template: AgentWindowTab

        # Template: AJAX

        # Template: Copyright

        # Template: CustomerAccept

        # Template: CustomerCalendarSmallIcon

        # Template: CustomerError
        'Traceback' => 'Determinar el origen',

        # Template: CustomerFooter
        'Powered by' => '',

        # Template: CustomerFooterSmall

        # Template: CustomerHeader

        # Template: CustomerHeaderSmall

        # Template: CustomerLogin
        'Login' => 'Identificador',
        'Lost your password?' => '¿Perdió su contraseña?',
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
        'No time settings.' => 'Sin especificación de tiempo',

        # Template: CustomerTicketSearchOpenSearchDescription

        # Template: CustomerTicketSearchResultCSV

        # Template: CustomerTicketSearchResultPrint

        # Template: CustomerTicketSearchResultShort

        # Template: CustomerTicketZoom

        # Template: CustomerWarning

        # Template: Error
        'Click here to report a bug!' => 'Haga click aquí para informar de un error',

        # Template: Footer
        'Top of Page' => 'Inicio de página',

        # Template: FooterSmall

        # Template: Header
        'Home' => 'Inicio',

        # Template: HeaderSmall

        # Template: Installer
        'Web-Installer' => 'Instalador Web',
        'Welcome to %s' => 'Bienvenido a %s',
        'Accept license' => 'Aceptar licencia',
        'Don\'t accept license' => 'No aceptar licencia',
        'Admin-User' => 'Usuario-Admin',
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty. For security reasons we do recommend setting a root password. For more information please refer to your database documentation.' => 'Si ha fijado una clave para su base de datos, debe especificarla aquí. Si no, déjelo en blanco. Por razones de seguridad, recomendamos establecer una clave para root. PAra más información, consulte la documentación de su base de datos.',
        'Admin-Password' => 'Contraseña-Administrador',
        'Database-User' => 'Usuario-Base de datos',
        'default \'hot\'' => 'por defecto \'hot\'',
        'DB connect host' => 'Host de conexión a la Base de datos',
        'Database' => 'Base de Datos',
        'Default Charset' => 'Juego de caracteres por defecto',
        'utf8' => 'utf8',
        'false' => 'falso',
        'SystemID' => 'ID de sistema',
        '(The identify of the system. Each ticket number and each http session id starts with this number)' => '(La identidad del sistema. Cada número de ticket y cada id de sesión http comienza con este número)',
        'System FQDN' => 'FQDN del sistema',
        '(Full qualified domain name of your system)' => '(Nombre completo del dominio de su sistema)',
        'AdminEmail' => 'Correo del Administrador.',
        '(Email of the system admin)' => '(email del administrador del sistema)',
        'Organization' => 'Organización',
        'Log' => 'Log',
        'LogModule' => 'Módulo de logs',
        '(Used log backend)' => '(Interface de log Utilizada)',
        'Logfile' => 'Archivo de log',
        '(Logfile just needed for File-LogModule!)' => '(Archivo de log necesario para File-LogModule)',
        'Webfrontend' => 'Interface Web',
        'Use utf-8 it your database supports it!' => 'Use utf-8 si su base de datos lo permite!',
        'Default Language' => 'Lenguaje por defecto',
        '(Used default language)' => '(Use el lenguaje por defecto)',
        'CheckMXRecord' => 'Revisar record MX',
        '(Checks MX recordes of used email addresses by composing an answer. Don\'t use CheckMXRecord if your OTRS machine is behinde a dial-up line $!)' => '(Chequear registro MX de direcciones utilizadas al responder. ¡ No usarlo si su PC con OTRS está detrás de una línea telefonica $!)',
        'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' => 'Para poder utilizar OTRS debe escribir la siguiente línea en la consola de sistema (Terminal/Shell) como usuario root',
        'Restart your webserver' => 'Reinicie su servidor web',
        'After doing so your OTRS is up and running.' => 'Después de hacer esto, su OTRS estará activo y ejecutándose',
        'Start page' => 'Página de inicio',
        'Your OTRS Team' => 'Su equipo OTRS',

        # Template: LinkObject

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

        # Template: PublicDefault

        # Template: Redirect

        # Template: Test
        'OTRS Test Page' => 'Página de Prueba de OTRS',
        'Counter' => 'Contador',

        # Template: Warning

        # Template: YUI

        # Misc
        'Edit Article' => 'Editar Artículo',
        'Create Database' => 'Crear Base de Datos',
        'Ticket Number Generator' => 'Generador de números de Tickets',
        '(Ticket identifier. Some people want toset this to e. g. \'Ticket#\', \'Call#\' or \'MyTicket#\')' => '(Identificador de Ticket. Algunas personas quieren usar por ejemplo \'Ticket#\', \'Call#\' o \'MyTicket#\')',
        'In this way you can directly edit the keyring configured in Kernel/Config.pm.' => 'De esta forma, Ud. puede editar directamente las claves configuradas en Kernel/Config.pm.',
        'Create new Phone Ticket' => 'Crear un nuevo Ticket Telefónico',
        'Symptom' => 'Síntoma',
        'U' => 'A',
        'Site' => 'Sitio',
        'Customer history search (e. g. "ID342425").' => 'Historia de búsquedas del cliente (ej: "ID342425")',
        'Can not delete link with %s' => 'No se puede eliminar vínculo con %s',
        'Close!' => 'Cerrar',
        'for agent firstname' => 'nombre del agente',
        'No means, send agent and customer notifications on changes.' => '"No" significa enviar a los agentes y clientes notificaciones al realizar cambios.',
        'A web calendar' => 'Calendario Web',
        'to get the realname of the sender (if given)' => 'para obtener el nombre del emisor (si lo proporcionó)',
        'OTRS DB Name' => 'Nombre de la BD OTRS',
        'Notification (Customer)' => 'Notificación (Cliente)',
        'Select Source (for add)' => 'Seleccionar Fuente (para añadir)',
        'Options of the ticket data (e. g. &lt;OTRS_TICKET_Number&gt;, &lt;OTRS_TICKET_ID&gt;, &lt;OTRS_TICKET_Queue&gt;, &lt;OTRS_TICKET_State&gt;)' => 'Opcciones de los datos del ticket (ej. &lt;OTRS_TICKET_Number&gt;, &lt;OTRS_TICKET_ID&gt;, &lt;OTRS_TICKET_Queue&gt;, &lt;OTRS_TICKET_State&gt;)',
        'Child-Object' => 'Objeto-Hijo',
        'Days' => 'Días',
        'Queue ID' => 'Id de la Fila',
        'Config options (e. g. <OTRS_CONFIG_HttpType>)' => 'Opciones de configuración (ej: <OTRS_CONFIG_HttpType>)',
        'System History' => 'Historia del Sistema',
        'customer realname' => 'Nombre del cliente',
        'Pending messages' => 'Mensajes pendientes',
        'Modules' => 'Módulos',
        'for agent login' => 'login del agente',
        'Keyword' => 'Palabra clave',
        'Close type' => 'Tipo de cierre',
        'DB Admin User' => 'Usuario Admin de la BD',
        'for agent user id' => 'id del agente',
        'Problem' => 'Problema',
        'Escalation' => 'Escalado',
        'Order' => 'Orden',
        'next step' => 'próximo paso',
        'Follow up' => 'Seguimiento',
        'Customer history search' => 'Historia de búsquedas del cliente',
        'Admin-Email' => 'Correo del Administrador',
        'Stat#' => 'Estadística#',
        'Create new database' => 'Crear nueva base de datos',
        'ArticleID' => 'Identificador de artículo',
        'Keywords' => 'Palabras clave',
        'Ticket Escalation View' => 'Ver Escalado del Ticket',
        'Today' => 'Hoy',
        'No * possible!' => 'No * posible!',
        'Options ' => 'Opciones',
        'Options of the current user who requested this action (e. g. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)' => 'Opciones del usuario que solicitó la acción (ej. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)',
        'Message for new Owner' => 'Mensaje para el nuevo propietario',
        'to get the first 5 lines of the email' => 'para obtener las primeras 5 líneas del correo',
        'Sort by' => 'Ordenado por',
        'OTRS DB Password' => 'Contraseña para BD del usuario OTRS',
        'Last update' => 'Ultima Actualización',
        'Tomorrow' => 'Mañana',
        'to get the first 20 character of the subject' => 'para obtener los primeros 20 caracteres del asunto ',
        'Select the customeruser:service relations.' => 'Seleccione las relaciones cliente:servicio.',
        'DB Admin Password' => 'Contraseña del Administrador de la BD',
        'Drop Database' => 'Eliminar Base de Datos',
        'Advisory' => 'Advertencia',
        'Here you can define the x-axis. You can select one element via the radio button. Then you have to select two or more attributes of the element. If you make no selection all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' => 'Aqui puede definir el eje-x. Puede seleccionar un elemento usando la casilla de selección. Luego debe seleccionar dos o más atributos del elemento. Si Ud. no selecciona ninguno, todos los atributos del elemento se utilizarán para generar una estadística. Asimismo un nuevo atributo es añadido desde la última configuración.',
        'FileManager' => 'Administrador de Archivos',
        'Options of the current customer user data (e. g. <OTRS_CUSTOMER_DATA_UserFirstname>)' => 'Opciones del usuario activo  (ej. <OTRS_CUSTOMER_DATA_UserFirstname>)',
        'Pending type' => 'Tipo pendiente',
        'Comment (internal)' => 'Comentario (interno)',
        'Ticket owner options (e. g. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)' => 'Opciones del propietario del Ticket (ej. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)',
        'Minutes' => 'Minutos',
        'Options of the ticket data (e. g. <OTRS_TICKET_Number>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' => 'Opciones de la información del ticket (ej: <OTRS_TICKET_Number>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)',
        '(Used ticket number format)' => '(Formato de número de ticket utilizado)',
        'Reminder' => 'Recordatorio',
        'Incident' => 'Incidente',
        'All Agent variables.' => 'Todas las variables de Agente',
        ' (work units)' => ' (unidades de trabajo)',
        'Next Week' => 'Próxima semana',
        'All Customer variables like defined in config option CustomerUser.' => 'Todas las variables de cliente, como las declaradas en la opción de configuracion del cliente',
        'accept license' => 'aceptar licencia',
        'for agent lastname' => 'apellido del agente',
        'Options of the current user who requested this action (e. g. <OTRS_CURRENT_UserFirstname>)' => 'Opciones del usuario activo que solicitó esta acción (ej. <OTRS_CURRENT_UserFirstname>)',
        'Reminder messages' => 'Mensajes recordatorios',
        'Change users <-> roles settings' => 'Modificar Configuración de Usuarios <-> Roles',
        'Parent-Object' => 'Objeto-Padre',
        'Of couse this feature will take some system performance it self!' => 'De acuerdo a esta característica se efectuarán ciertas mejoras en el sistema por sí mismo.',
        'Detail' => 'Detalle',
        'Your own Ticket' => 'Sus tickets',
        'TicketZoom' => 'Detalle del Ticket',
        'Don\'t forget to add a new user to groups!' => 'No olvide incluir un nuevo usuario a los grupos',
        'Open Tickets' => 'Tickets Abiertos',
        'CreateTicket' => 'CrearTicket',
        'You have to select two or more attributes from the select field!' => 'Debe seleccionar dos o más atributos del campo seleccionado',
        'System Settings' => 'Configuración del sistema',
        'WebWatcher' => 'ObservadorWeb',
        'Hours' => 'Horas',
        'Finished' => 'Finalizado',
        'Account Type' => 'Tipo de cuenta',
        'D' => '',
        'All messages' => 'Todos los mensajes',
        'System Status' => 'Estado del Sistema',
        'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' => 'Opciones de la información del ticket (ej. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)',
        'Artefact' => 'Artefacto',
        'Object already linked as %s.' => 'Objecto ya vinculado como %s.',
        'A article should have a title!' => 'Los artículos deben tener título',
        'Config options (e. g. &lt;OTRS_CONFIG_HttpType&gt;)' => 'Opciones de configuración (ej. &lt;OTRS_CONFIG_HttpType&gt;)',
        'All email addresses get excluded on replaying on composing and email.' => 'Todas las direcciones de correo electrónico será omitidas al componer la respuesta a un correo',
        'don\'t accept license' => 'no aceptar la licencia',
        'A web mail client' => 'Un cliente de correo Web',
        'Compose Follow up' => 'Redactar seguimiento',
        'WebMail' => 'CorreoWeb',
        'Ticket owner options (e. g. <OTRS_OWNER_UserFirstname>)' => 'Opciones del propietario del ticket (ej. <OTRS_OWNER_UserFirstname>)',
        'DB Type' => 'Tipo de BD',
        'kill all sessions' => 'finalizar todas las sesiones',
        'to get the from line of the email' => 'para obtener la línea Para del correo',
        'Solution' => 'Solución',
        'Package not correctly deployed, you need to deploy it again!' => 'El paquete no ha sido correctamente instalado, necesita instalarlo nuevamente!',
        'QueueView' => 'Ver la fila',
        'Select Box' => 'Ventana de selección',
        'New messages' => 'Nuevos mensajes',
        'Can not create link with %s!' => 'No se puede vincular con %s!',
        'Linked as' => 'Vinculado como',
        'Welcome to OTRS' => 'Bienvenido a OTRS',
        'modified' => 'modificado',
        'Delete old database' => 'Eliminar BD antigua',
        'A web file manager' => 'Administrador web de archivos',
        'Have a lot of fun!' => 'Disfrútelo!',
        'send' => 'enviar',
        'Send no notifications' => 'No enviar notificaciones',
        'Note Text' => 'Nota!',
        'POP3 Account Management' => 'Administración de cuenta POP3',
        'Options of the current customer user data (e. g. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)' => 'Opciones de los datos del cliente activo (ej. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)',
        'System State Management' => 'Administración de Estados del Sistema',
        'OTRS DB User' => 'Usuario de BD OTRS',
        'Mailbox' => 'Buzón',
        'PhoneView' => 'Vista telefónica',
        'maximal period form' => 'periodo máximo del formulario',
        'TicketID' => 'Identificador de Ticket',
        'Escaladed Tickets' => 'Tickets Escalados',
        'Yes means, send no agent and customer notifications on changes.' => '"Sí" significa no enviar notificación a los agentes y clientes al realizarse cambios.',
        'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further information.' => 'Su correo con número de ticket "<OTRS_TICKET>"  fue rebotado a "<OTRS_BOUNCE_TO>". Contacte con dicha dirección para más información.',
        'Ticket Status View' => 'Ver Estado del Ticket',
        'Modified' => 'Modificado',
        'Ticket selected for bulk action!' => 'Ticket seleccionado para acción múltiple!',
        '%s is not writable!' => '%s no es modificable!',
        'Cannot create %s!' => 'No se puede crear %s!',
    };
    # $$STOP$$
    return;
}

1;
